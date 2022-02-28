// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_robot;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace zm_ai_astro;

/*
	Name: init
	Namespace: zm_ai_astro
	Checksum: 0xDB52656A
	Offset: 0x688
	Size: 0x284
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initastrobehaviorsandasm();
	spawner::add_archetype_spawn_function("astronaut", &archetypeastroblackboardinit);
	spawner::add_archetype_spawn_function("astronaut", &astrospawnsetup);
	animationstatenetwork::registernotetrackhandlerfunction("headbutt_start", &astro_zombie_headbutt_release);
	animationstatenetwork::registernotetrackhandlerfunction("astro_melee", &astro_zombie_headbutt);
	init_astro_zombie_fx();
	if(!isdefined(level.astro_zombie_enter_level))
	{
		level.astro_zombie_enter_level = &astro_zombie_default_enter_level;
	}
	level.num_astro_zombies = 0;
	level.astro_zombie_spawners = getentarray("astronaut_zombie", "targetname");
	level.max_astro_zombies = 1;
	level.astro_zombie_health_mult = 4;
	level.min_astro_round_wait = 1;
	level.max_astro_round_wait = 2;
	level.astro_round_start = 1;
	level.next_astro_round = level.astro_round_start + (randomintrange(0, level.max_astro_round_wait + 1));
	level.zombies_left_before_astro_spawn = 1;
	level.zombie_left_before_spawn = 0;
	level.astro_explode_radius = 400;
	level.astro_explode_blast_radius = 150;
	level.astro_explode_pulse_min = 100;
	level.astro_explode_pulse_max = 300;
	level.astro_headbutt_delay = 2000;
	level.astro_headbutt_radius_sqr = 4096;
	level.zombie_total_update = 0;
	level.zombie_total_set_func = &astro_zombie_total_update;
	zm_spawner::register_zombie_damage_callback(&astro_damage_callback);
	while(!isdefined(level.custom_ai_spawn_check_funcs))
	{
		wait(0.05);
	}
	zm::register_custom_ai_spawn_check("astro", &astro_spawn_check, &get_astro_spawners, &get_astro_locations);
}

/*
	Name: archetypeastroblackboardinit
	Namespace: zm_ai_astro
	Checksum: 0x92A55608
	Offset: 0x918
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function archetypeastroblackboardinit()
{
	blackboard::createblackboardforentity(self);
	self aiutility::registerutilityblackboardattributes();
	ai::createinterfaceforentity(self);
	blackboard::registerblackboardattribute(self, "_locomotion_speed", "locomotion_speed_walk", &zombiebehavior::bb_getlocomotionspeedtype);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	self.___archetypeonanimscriptedcallback = &archetypeastroonanimscriptedcallback;
	/#
		self finalizetrackedblackboardattributes();
	#/
}

/*
	Name: archetypeastroonanimscriptedcallback
	Namespace: zm_ai_astro
	Checksum: 0xCB9A2DF6
	Offset: 0xA08
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private archetypeastroonanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity archetypeastroblackboardinit();
}

/*
	Name: initastrobehaviorsandasm
	Namespace: zm_ai_astro
	Checksum: 0x664E962
	Offset: 0xA48
	Size: 0x74
	Parameters: 0
	Flags: Linked, Private
*/
function private initastrobehaviorsandasm()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("astroTargetService", &astrotargetservice);
	behaviortreenetworkutility::registerbehaviortreeaction("moonAstroProceduralTraversal", &astrotraversestart, &robotsoldierbehavior::robotproceduraltraversalupdate, &astrotraverseend);
}

/*
	Name: astrospawnsetup
	Namespace: zm_ai_astro
	Checksum: 0x1F5D5DE0
	Offset: 0xAC8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function astrospawnsetup()
{
	self astro_prespawn();
	self thread astro_zombie_spawn(self);
}

/*
	Name: astrotargetservice
	Namespace: zm_ai_astro
	Checksum: 0xB6672ACB
	Offset: 0xB08
	Size: 0x246
	Parameters: 1
	Flags: Linked
*/
function astrotargetservice(entity)
{
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return false;
	}
	player = zombie_utility::get_closest_valid_player(self.origin, self.ignore_player);
	entity.favoriteenemy = player;
	if(!isdefined(player) || player isnotarget())
	{
		if(isdefined(entity.ignore_player))
		{
			if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
			{
				return;
			}
			entity.ignore_player = [];
		}
		if(isdefined(level.no_target_override))
		{
			[[level.no_target_override]](entity);
		}
		else
		{
			entity setgoal(entity.origin);
		}
		return false;
	}
	if(isdefined(level.enemy_location_override_func))
	{
		enemy_ground_pos = [[level.enemy_location_override_func]](entity, player);
		if(isdefined(enemy_ground_pos))
		{
			entity setgoal(enemy_ground_pos);
			return true;
		}
	}
	targetpos = getclosestpointonnavmesh(player.origin, 15, 15);
	if(isdefined(targetpos))
	{
		entity setgoal(targetpos);
		return true;
	}
	if(isdefined(player.last_valid_position))
	{
		entity setgoal(player.last_valid_position);
		return true;
	}
	entity setgoal(entity.origin);
	return false;
}

/*
	Name: astro_spawn_check
	Namespace: zm_ai_astro
	Checksum: 0x8F2F877F
	Offset: 0xD58
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function astro_spawn_check()
{
	if(isdefined(level.zm_loc_types["astro_location"]) && level.zm_loc_types["astro_location"].size <= 0)
	{
		return false;
	}
	if(!(level.round_number >= level.next_astro_round && level.num_astro_zombies < level.max_astro_zombies))
	{
		return false;
	}
	if(!(isdefined(level.on_the_moon) && level.on_the_moon))
	{
		return false;
	}
	if(!(isdefined(level.zombie_total_update) && level.zombie_total_update))
	{
		return false;
	}
	if(level.zombie_total > level.zombies_left_before_astro_spawn)
	{
		return false;
	}
	return true;
}

/*
	Name: get_astro_spawners
	Namespace: zm_ai_astro
	Checksum: 0x3162AA02
	Offset: 0xE20
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_astro_spawners()
{
	return level.astro_zombie_spawners;
}

/*
	Name: get_astro_locations
	Namespace: zm_ai_astro
	Checksum: 0x772D6893
	Offset: 0xE38
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function get_astro_locations()
{
	return level.zm_loc_types["astro_location"];
}

/*
	Name: astro_prespawn
	Namespace: zm_ai_astro
	Checksum: 0x4360516B
	Offset: 0xE58
	Size: 0x2AA
	Parameters: 0
	Flags: Linked
*/
function astro_prespawn()
{
	self.animname = "astro_zombie";
	self.ignoreall = 1;
	self.allowdeath = 1;
	self.is_zombie = 1;
	self.has_legs = 1;
	self allowedstances("stand");
	self.gibbed = 0;
	self.head_gibbed = 0;
	self.disablearrivals = 1;
	self.disableexits = 1;
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoresuppression = 1;
	self.suppressionthreshold = 1;
	self.nododgemove = 1;
	self.dontshootwhilemoving = 1;
	self.pathenemylookahead = 0;
	self.badplaceawareness = 0;
	self.chatinitialized = 0;
	self thread zm_spawner::zombie_damage_failsafe();
	self thread zombie_utility::delayed_zombie_eye_glow();
	self.flame_damage_time = 0;
	self.meleedamage = 50;
	self.no_powerups = 1;
	self.no_gib = 1;
	self.ignorelocationaldamage = 1;
	self.actor_damage_func = &astro_actor_damage;
	self.nuke_damage_func = &astro_nuke_damage;
	self.custom_damage_func = &astro_custom_damage;
	self.microwavegun_sizzle_func = &astro_microwavegun_sizzle;
	self.ignore_cleanup_mgr = 1;
	self.ignore_distance_tracking = 1;
	self.ignore_enemy_count = 1;
	self.ignore_gravity = 1;
	self.ignore_devgui_death = 1;
	self.ignore_nml_delete = 1;
	self.ignore_round_spawn_failsafe = 1;
	self.ignore_poi_targetname = [];
	self.ignore_poi_targetname[self.ignore_poi_targetname.size] = "zm_bhb";
	self.zombie_move_speed = "walk";
	self zombie_utility::set_zombie_run_cycle();
	self.zombie_think_done = 1;
	self thread zm_spawner::play_ambient_zombie_vocals();
	self thread zm_audio::zmbaivox_notifyconvert();
	self notify(#"zombie_init_done");
}

/*
	Name: init_astro_zombie_fx
	Namespace: zm_ai_astro
	Checksum: 0x11F370E6
	Offset: 0x1110
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function init_astro_zombie_fx()
{
	level._effect["astro_spawn"] = "dlc5/moon/fx_moon_qbomb_explo_distort";
	level._effect["astro_explosion"] = "dlc5/moon/fx_moon_qbomb_explo_distort";
}

/*
	Name: astro_zombie_spawn
	Namespace: zm_ai_astro
	Checksum: 0xD785B6DF
	Offset: 0x1158
	Size: 0x100
	Parameters: 1
	Flags: Linked
*/
function astro_zombie_spawn(astro_zombie)
{
	self.script_moveoverride = 1;
	if(!isdefined(level.num_astro_zombies))
	{
		level.num_astro_zombies = 0;
	}
	level.num_astro_zombies++;
	astro_zombie.has_legs = 1;
	self.count = 100;
	playsoundatposition("evt_astro_spawn", self.origin);
	astro_zombie.deathfunction = &astro_zombie_die;
	astro_zombie.animname = "astro_zombie";
	astro_zombie.loopsound = "evt_astro_gasmask_loop";
	astro_zombie thread astro_zombie_think();
	_debug_astro_print("astro spawned in " + level.round_number);
	return astro_zombie;
}

/*
	Name: astro_zombie_total_update
	Namespace: zm_ai_astro
	Checksum: 0x4F05BA75
	Offset: 0x1260
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function astro_zombie_total_update()
{
	level.zombie_total_update = 1;
	level.zombies_left_before_astro_spawn = 1;
	if(level.zombie_total > 1)
	{
		level.zombies_left_before_astro_spawn = randomintrange(int(level.zombie_total * 0.25), int(level.zombie_total * 0.75));
	}
	_debug_astro_print("next astro round = " + level.next_astro_round);
	_debug_astro_print("zombies to kill = " + (level.zombie_total - level.zombies_left_before_astro_spawn));
}

/*
	Name: astro_zombie_think
	Namespace: zm_ai_astro
	Checksum: 0xF1D3017F
	Offset: 0x1350
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function astro_zombie_think()
{
	self endon(#"death");
	self.entered_level = 0;
	self.ignoreall = 0;
	self.maxhealth = (level.zombie_health * getplayers().size) * level.astro_zombie_health_mult;
	self.health = self.maxhealth;
	self.maxsightdistsqrd = 9216;
	self.zombie_move_speed = "walk";
	self thread [[level.astro_zombie_enter_level]]();
	if(isdefined(level.astro_zombie_custom_think))
	{
		self thread [[level.astro_zombie_custom_think]]();
	}
	self thread astro_zombie_headbutt_think();
	self playloopsound(self.loopsound);
}

/*
	Name: astro_zombie_headbutt_think
	Namespace: zm_ai_astro
	Checksum: 0x8929CAA
	Offset: 0x1438
	Size: 0x26C
	Parameters: 0
	Flags: Linked
*/
function astro_zombie_headbutt_think()
{
	self endon(#"death");
	self.is_headbutt = 0;
	self.next_headbutt_time = gettime() + level.astro_headbutt_delay;
	while(true)
	{
		if(!isdefined(self.enemy))
		{
			wait(0.05);
			continue;
		}
		if(!self.is_headbutt && gettime() > self.next_headbutt_time)
		{
			origin = self geteye();
			test_origin = self.enemy geteye();
			dist_sqr = distancesquared(origin, test_origin);
			if(dist_sqr > level.astro_headbutt_radius_sqr)
			{
				wait(0.05);
				continue;
			}
			yaw = zombie_utility::getyawtoorigin(self.enemy.origin);
			if(abs(yaw) > 45)
			{
				wait(0.05);
				continue;
			}
			if(!bullettracepassed(origin, test_origin, 0, undefined))
			{
				wait(0.05);
				continue;
			}
			self.is_headbutt = 1;
			self thread astro_turn_player();
			headbutt_anim = self animmappingsearch(istring("anim_astro_headbutt"));
			time = getanimlength(headbutt_anim);
			self.player_to_headbutt thread astro_restore_move_speed(time);
			self animscripted("headbutt_anim", self.origin, self.angles, "ai_zm_dlc5_zombie_astro_headbutt");
			wait(time);
			self.next_headbutt_time = gettime() + level.astro_headbutt_delay;
			self.is_headbutt = 0;
		}
		wait(0.05);
	}
}

/*
	Name: astro_restore_move_speed
	Namespace: zm_ai_astro
	Checksum: 0xF4311E76
	Offset: 0x16B0
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function astro_restore_move_speed(time)
{
	self endon(#"disconnect");
	wait(time);
	self allowjump(1);
	self allowprone(1);
	self allowcrouch(1);
	self setmovespeedscale(1);
}

/*
	Name: astrotraversestart
	Namespace: zm_ai_astro
	Checksum: 0x6EC6884
	Offset: 0x1738
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function astrotraversestart(entity, asmstatename)
{
	robotsoldierbehavior::robotcalcproceduraltraversal(entity, asmstatename);
	robotsoldierbehavior::robottraversestart(entity, asmstatename);
	return 5;
}

/*
	Name: astrotraverseend
	Namespace: zm_ai_astro
	Checksum: 0xF3A1B7B1
	Offset: 0x1788
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function astrotraverseend(entity, asmstatename)
{
	robotsoldierbehavior::robotprocedurallandingupdate(entity, asmstatename);
	robotsoldierbehavior::robottraverseend(entity);
	return 4;
}

/*
	Name: astro_turn_player
	Namespace: zm_ai_astro
	Checksum: 0x8B34E1BD
	Offset: 0x17D8
	Size: 0x26C
	Parameters: 0
	Flags: Linked
*/
function astro_turn_player()
{
	self endon(#"death");
	self.player_to_headbutt = self.enemy;
	player = self.player_to_headbutt;
	up = player.origin + vectorscale((0, 0, 1), 10);
	facing_astro = vectortoangles(self.origin - up);
	player thread astro_watch_controls(self);
	if(self.health > 0)
	{
		player freezecontrols(1);
	}
	lerp_time = 0.2;
	enemy_to_player = vectornormalize(player.origin - self.origin);
	link_org = self.origin + (40 * enemy_to_player);
	player lerp_player_view_to_position(link_org, facing_astro, lerp_time, 1);
	wait(lerp_time);
	player freezecontrols(0);
	player allowjump(0);
	player allowstand(1);
	player allowprone(0);
	player allowcrouch(0);
	player setmovespeedscale(0.1);
	player notify(#"released");
	dist = distance(self.origin, player.origin);
	_debug_astro_print("grab dist = " + dist);
}

/*
	Name: lerp_player_view_to_position
	Namespace: zm_ai_astro
	Checksum: 0xEE061D7D
	Offset: 0x1A50
	Size: 0x22C
	Parameters: 9
	Flags: Linked
*/
function lerp_player_view_to_position(origin, angles, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo)
{
	if(isplayer(self))
	{
		self endon(#"disconnect");
	}
	linker = spawn("script_origin", (0, 0, 0));
	linker.origin = self.origin;
	linker.angles = self getplayerangles();
	if(isdefined(hit_geo))
	{
		self playerlinkto(linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo);
	}
	else
	{
		if(isdefined(right_arc))
		{
			self playerlinkto(linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc);
		}
		else
		{
			if(isdefined(fraction))
			{
				self playerlinkto(linker, "", fraction);
			}
			else
			{
				self playerlinkto(linker);
			}
		}
	}
	linker moveto(origin, lerptime, lerptime * 0.25);
	linker rotateto(angles, lerptime, lerptime * 0.25);
	linker waittill(#"movedone");
	linker delete();
}

/*
	Name: astro_watch_controls
	Namespace: zm_ai_astro
	Checksum: 0xAA5F3417
	Offset: 0x1C88
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function astro_watch_controls(astro)
{
	self endon(#"released");
	self endon(#"disconnect");
	animlen = astro getanimlengthfromasd("zm_headbutt", 0);
	time = 0.5 + animlen;
	astro util::waittill_notify_or_timeout("death", time);
	self freezecontrols(0);
}

/*
	Name: astro_zombie_headbutt
	Namespace: zm_ai_astro
	Checksum: 0x2A5B9B59
	Offset: 0x1D38
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function astro_zombie_headbutt(entity)
{
	if(!isdefined(entity.player_to_headbutt) || !zombie_utility::is_player_valid(entity.player_to_headbutt))
	{
		return;
	}
	entity thread astro_zombie_attack();
	entity thread astro_zombie_teleport_enemy();
}

/*
	Name: astro_zombie_headbutt_release
	Namespace: zm_ai_astro
	Checksum: 0xADF4A985
	Offset: 0x1DC0
	Size: 0x16C
	Parameters: 1
	Flags: Linked
*/
function astro_zombie_headbutt_release(entity)
{
	_release_dist = 59;
	player = entity.player_to_headbutt;
	if(!isdefined(player) || !isalive(player))
	{
		return;
	}
	dist = distance(player.origin, entity.origin);
	_debug_astro_print("distance before headbutt = " + dist);
	if(dist < _release_dist)
	{
		return;
	}
	player allowjump(1);
	player allowprone(1);
	player allowcrouch(1);
	player setmovespeedscale(1);
	self animscripted("headbutt_anim", entity.origin, entity.angles, "ai_zm_dlc5_zombie_astro_headbutt_release");
}

/*
	Name: astro_zombie_attack
	Namespace: zm_ai_astro
	Checksum: 0x1B330221
	Offset: 0x1F38
	Size: 0x22C
	Parameters: 0
	Flags: Linked
*/
function astro_zombie_attack()
{
	self endon(#"death");
	if(!isdefined(self.player_to_headbutt))
	{
		return;
	}
	player = self.player_to_headbutt;
	perk_list = [];
	vending_triggers = getentarray("zombie_vending", "targetname");
	for(i = 0; i < vending_triggers.size; i++)
	{
		perk = vending_triggers[i].script_noteworthy;
		if(player hasperk(perk))
		{
			perk_list[perk_list.size] = perk;
		}
	}
	take_perk = 0;
	if(perk_list.size > 0 && !isdefined(player._retain_perks))
	{
		take_perk = 1;
		perk_list = array::randomize(perk_list);
		perk = perk_list[0];
		perk_str = perk + "_stop";
		player notify(perk_str);
		if(level flag::get("solo_game") && perk == "specialty_quickrevive")
		{
			player.lives--;
		}
		player thread astro_headbutt_damage(self, self.origin);
	}
	if(!take_perk)
	{
		damage = player.health - 1;
		player dodamage(damage, self.origin, self);
	}
}

/*
	Name: astro_headbutt_damage
	Namespace: zm_ai_astro
	Checksum: 0x69E4F563
	Offset: 0x2170
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function astro_headbutt_damage(astro, org)
{
	self endon(#"disconnect");
	self waittill(#"perk_lost");
	damage = self.health - 1;
	if(isdefined(astro))
	{
		self dodamage(damage, astro.origin, astro);
	}
	else
	{
		self dodamage(damage, org);
	}
}

/*
	Name: astro_zombie_teleport_enemy
	Namespace: zm_ai_astro
	Checksum: 0xBCCE0FAE
	Offset: 0x2218
	Size: 0x24C
	Parameters: 0
	Flags: Linked
*/
function astro_zombie_teleport_enemy()
{
	self endon(#"death");
	player = self.player_to_headbutt;
	black_hole_teleport_structs = struct::get_array("struct_black_hole_teleport", "targetname");
	chosen_spot = undefined;
	if(isdefined(level._special_blackhole_bomb_structs))
	{
		black_hole_teleport_structs = [[level._special_blackhole_bomb_structs]]();
	}
	player_current_zone = player zm_utility::get_current_zone();
	if(!isdefined(black_hole_teleport_structs) || black_hole_teleport_structs.size == 0 || !isdefined(player_current_zone))
	{
		return;
	}
	black_hole_teleport_structs = array::randomize(black_hole_teleport_structs);
	for(i = 0; i < black_hole_teleport_structs.size; i++)
	{
		volume = level.zones[black_hole_teleport_structs[i].script_string].volumes[0];
		zone_enabled = zm_zonemgr::get_zone_from_position(black_hole_teleport_structs[i].origin, 0);
		if(isdefined(zone_enabled) && player_current_zone != black_hole_teleport_structs[i].script_string)
		{
			if(!level flag::get("power_on") || volume.script_string == "lowgravity")
			{
				chosen_spot = black_hole_teleport_structs[i];
				break;
			}
			else
			{
				chosen_spot = black_hole_teleport_structs[i];
			}
			continue;
		}
		if(isdefined(zone_enabled))
		{
			chosen_spot = black_hole_teleport_structs[i];
		}
	}
	if(isdefined(chosen_spot))
	{
		player thread astro_zombie_teleport(chosen_spot);
	}
}

/*
	Name: astro_zombie_teleport
	Namespace: zm_ai_astro
	Checksum: 0xD2CAABD5
	Offset: 0x2470
	Size: 0x26C
	Parameters: 1
	Flags: Linked
*/
function astro_zombie_teleport(struct_dest)
{
	self endon(#"death");
	if(!isdefined(struct_dest))
	{
		return;
	}
	prone_offset = vectorscale((0, 0, 1), 49);
	crouch_offset = vectorscale((0, 0, 1), 20);
	stand_offset = (0, 0, 0);
	destination = undefined;
	if(self getstance() == "prone")
	{
		destination = struct_dest.origin + prone_offset;
	}
	else
	{
		if(self getstance() == "crouch")
		{
			destination = struct_dest.origin + crouch_offset;
		}
		else
		{
			destination = struct_dest.origin + stand_offset;
		}
	}
	if(isdefined(level._black_hole_teleport_override))
	{
		level [[level._black_hole_teleport_override]](self);
	}
	self freezecontrols(1);
	self disableoffhandweapons();
	self disableweapons();
	self dontinterpolate();
	self setorigin(destination);
	self setplayerangles(struct_dest.angles);
	self enableoffhandweapons();
	self enableweapons();
	self freezecontrols(0);
	earthquake(0.8, 0.75, self.origin, 1000, self);
	self playsoundtoplayer("zmb_gersh_teleporter_go_2d", self);
}

/*
	Name: astro_zombie_die
	Namespace: zm_ai_astro
	Checksum: 0x43F8E88D
	Offset: 0x26E8
	Size: 0x15A
	Parameters: 8
	Flags: Linked
*/
function astro_zombie_die(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	playfxontag(level._effect["astro_explosion"], self, "J_SpineLower");
	self stoploopsound(1);
	self playsound("evt_astro_zombie_explo");
	self thread astro_delay_delete();
	self thread astro_player_pulse();
	level.num_astro_zombies--;
	level.next_astro_round = level.round_number + (randomintrange(level.min_astro_round_wait, level.max_astro_round_wait + 1));
	level.zombie_total_update = 0;
	_debug_astro_print("astro killed in " + level.round_number);
	return self zm_spawner::zombie_death_animscript();
}

/*
	Name: astro_delay_delete
	Namespace: zm_ai_astro
	Checksum: 0xCE5D524E
	Offset: 0x2850
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function astro_delay_delete()
{
	self endon(#"death");
	self setplayercollision(0);
	self thread zombie_utility::zombie_eye_glow_stop();
	wait(0.05);
	self ghost();
	wait(0.05);
	self delete();
}

/*
	Name: astro_player_pulse
	Namespace: zm_ai_astro
	Checksum: 0xCC2852E5
	Offset: 0x28D8
	Size: 0x47A
	Parameters: 0
	Flags: Linked
*/
function astro_player_pulse()
{
	eye_org = self geteye();
	foot_org = self.origin + vectorscale((0, 0, 1), 8);
	mid_org = (foot_org[0], foot_org[1], (foot_org[2] + eye_org[2]) / 2);
	astro_org = self.origin;
	if(isdefined(self.player_to_headbutt))
	{
		self.player_to_headbutt allowjump(1);
		self.player_to_headbutt allowprone(1);
		self.player_to_headbutt allowcrouch(1);
		self.player_to_headbutt unlink();
		wait(0.05);
		wait(0.05);
	}
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!zombie_utility::is_player_valid(player))
		{
			continue;
		}
		test_org = player geteye();
		explode_radius = level.astro_explode_radius;
		if(distancesquared(eye_org, test_org) > (explode_radius * explode_radius))
		{
			continue;
		}
		test_org_foot = player.origin + vectorscale((0, 0, 1), 8);
		test_org_mid = (test_org_foot[0], test_org_foot[1], (test_org_foot[2] + test_org[2]) / 2);
		if(!bullettracepassed(eye_org, test_org, 0, undefined))
		{
			if(!bullettracepassed(mid_org, test_org_mid, 0, undefined))
			{
				if(!bullettracepassed(foot_org, test_org_foot, 0, undefined))
				{
					continue;
				}
			}
		}
		dist = distance(eye_org, test_org);
		scale = 1 - (dist / explode_radius);
		if(scale < 0)
		{
			scale = 0;
		}
		bonus = (level.astro_explode_pulse_max - level.astro_explode_pulse_min) * scale;
		pulse = level.astro_explode_pulse_min + bonus;
		dir = (player.origin[0] - astro_org[0], player.origin[1] - astro_org[1], 0);
		dir = vectornormalize(dir);
		dir = dir + (0, 0, 1);
		dir = dir * pulse;
		player setorigin(player.origin + (0, 0, 1));
		player_velocity = dir;
		player setvelocity(player_velocity);
		if(isdefined(level.ai_astro_explode))
		{
			player thread [[level.ai_astro_explode]](mid_org);
		}
	}
}

/*
	Name: astro_actor_damage
	Namespace: zm_ai_astro
	Checksum: 0xBE8352DD
	Offset: 0x2D60
	Size: 0xA2
	Parameters: 11
	Flags: Linked
*/
function astro_actor_damage(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	self endon(#"death");
	switch(weapon.name)
	{
		case "microwavegundw_upgraded_zm":
		case "microwavegundw_zm":
		{
			damage = 0;
			break;
		}
	}
	return damage;
}

/*
	Name: astro_nuke_damage
	Namespace: zm_ai_astro
	Checksum: 0x302ABA93
	Offset: 0x2E10
	Size: 0xE
	Parameters: 0
	Flags: Linked
*/
function astro_nuke_damage()
{
	self endon(#"death");
}

/*
	Name: astro_custom_damage
	Namespace: zm_ai_astro
	Checksum: 0xEF708F8B
	Offset: 0x2E28
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function astro_custom_damage(player)
{
	damage = self.meleedamage;
	if(self.is_headbutt)
	{
		damage = player.health - 1;
	}
	_debug_astro_print("astro damage = " + damage);
	return damage;
}

/*
	Name: astro_microwavegun_sizzle
	Namespace: zm_ai_astro
	Checksum: 0x86A399E4
	Offset: 0x2E98
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function astro_microwavegun_sizzle(player)
{
	_debug_astro_print("astro sizzle");
}

/*
	Name: astro_zombie_default_enter_level
	Namespace: zm_ai_astro
	Checksum: 0xBAFB1638
	Offset: 0x2EC8
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function astro_zombie_default_enter_level()
{
	playfx(level._effect["astro_spawn"], self.origin);
	playsoundatposition("zmb_bolt", self.origin);
	players = getplayers();
	players[randomintrange(0, players.size)] thread zm_audio::create_and_play_dialog("general", "astro_spawn");
	self.entered_level = 1;
}

/*
	Name: astro_damage_callback
	Namespace: zm_ai_astro
	Checksum: 0xA21DFA10
	Offset: 0x2F90
	Size: 0x94
	Parameters: 13
	Flags: Linked
*/
function astro_damage_callback(mod, hit_location, hit_origin, player, amount, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel)
{
	if(isdefined(self.animname) && self.animname == "astro_zombie")
	{
		return true;
	}
	return false;
}

/*
	Name: _debug_astro_health_watch
	Namespace: zm_ai_astro
	Checksum: 0xFAC80027
	Offset: 0x3030
	Size: 0x46
	Parameters: 0
	Flags: None
*/
function _debug_astro_health_watch()
{
	self endon(#"death");
	while(true)
	{
		/#
			iprintln("" + self.health);
		#/
		wait(1);
	}
}

/*
	Name: _debug_astro_print
	Namespace: zm_ai_astro
	Checksum: 0xE3B652E1
	Offset: 0x3080
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function _debug_astro_print(str)
{
	/#
		if(isdefined(level.debug_astro) && level.debug_astro)
		{
			iprintln(str);
		}
	#/
}

