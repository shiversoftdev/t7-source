// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_ai_napalm;

/*
	Name: __init__sytem__
	Namespace: zm_ai_napalm
	Checksum: 0x8FF137DD
	Offset: 0x8F8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_napalm", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_napalm
	Checksum: 0xA7308638
	Offset: 0x940
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_clientfields();
	registerbehaviorscriptfunctions();
}

/*
	Name: __main__
	Namespace: zm_ai_napalm
	Checksum: 0x1627B888
	Offset: 0x970
	Size: 0x22C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	init_napalm_fx();
	level.napalmzombiesenabled = 1;
	level.napalmzombieminroundwait = 1;
	level.napalmzombiemaxroundwait = 2;
	level.napalmzombieroundrequirement = 5;
	level.nextnapalmspawnround = level.napalmzombieroundrequirement + (randomintrange(0, level.napalmzombiemaxroundwait + 1));
	level.napalmzombiedamageradius = 250;
	level.napalmexploderadius = 90;
	level.napalmexplodekillradiusjugs = 90;
	level.napalmexplodekillradius = 150;
	level.napalmexplodedamageradius = 400;
	level.napalmexplodedamageradiuswet = 250;
	level.napalmexplodedamagemin = 50;
	level.napalmhealthmultiplier = 4;
	level.var_57ecc1a3 = 0;
	level.var_4e4c9791 = [];
	level.napalm_zombie_spawners = getentarray("napalm_zombie_spawner", "script_noteworthy");
	level flag::init("zombie_napalm_force_spawn");
	array::thread_all(level.napalm_zombie_spawners, &spawner::add_spawn_function, &napalm_zombie_spawn);
	array::thread_all(level.napalm_zombie_spawners, &spawner::add_spawn_function, &zombie_utility::round_spawn_failsafe);
	_napalm_initsounds();
	zm_spawner::register_zombie_damage_callback(&_napalm_damage_callback);
	level thread function_7cce5d95();
	/#
		println("" + level.nextnapalmspawnround);
	#/
}

/*
	Name: registerbehaviorscriptfunctions
	Namespace: zm_ai_napalm
	Checksum: 0xAFABCF7B
	Offset: 0xBA8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function registerbehaviorscriptfunctions()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("napalmExplodeInitialize", &napalmexplodeinitialize);
	behaviortreenetworkutility::registerbehaviortreescriptapi("napalmExplodeTerminate", &napalmexplodeterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("napalmCanExplode", &napalmcanexplode);
}

/*
	Name: get_napalm_spawners
	Namespace: zm_ai_napalm
	Checksum: 0x81A19D12
	Offset: 0xC30
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_napalm_spawners()
{
	return level.napalm_zombie_spawners;
}

/*
	Name: get_napalm_locations
	Namespace: zm_ai_napalm
	Checksum: 0x36DBDD3E
	Offset: 0xC48
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function get_napalm_locations()
{
	return level.zm_loc_types["napalm_location"];
}

/*
	Name: napalm_spawn_check
	Namespace: zm_ai_napalm
	Checksum: 0xF1A597E3
	Offset: 0xC68
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function napalm_spawn_check()
{
	forcespawn = level flag::get("zombie_napalm_force_spawn");
	if(!isdefined(level.napalmzombiesenabled) || level.napalmzombiesenabled == 0 || level.napalm_zombie_spawners.size == 0 || level.zm_loc_types["napalm_location"].size == 0)
	{
		return 0;
	}
	if(isdefined(level.napalmzombiecount) && level.napalmzombiecount > 0)
	{
		return 0;
	}
	/#
		if(getdvarint("") != 0)
		{
			return 1;
		}
	#/
	if(level.var_57ecc1a3 >= level.round_number)
	{
		return 0;
	}
	if(forcespawn)
	{
		return 1;
	}
	if(level.nextnapalmspawnround > level.round_number)
	{
		return 0;
	}
	if(level.zombie_total == 0)
	{
		return 0;
	}
	return level.zombie_total < level.zombiesleftbeforenapalmspawn;
}

/*
	Name: function_7cce5d95
	Namespace: zm_ai_napalm
	Checksum: 0xCDD92B83
	Offset: 0xDA0
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function function_7cce5d95()
{
	level waittill(#"start_of_round");
	while(true)
	{
		if(napalm_spawn_check())
		{
			spawner_list = get_napalm_spawners();
			location_list = get_napalm_locations();
			spawner = array::random(spawner_list);
			location = array::random(location_list);
			ai = zombie_utility::spawn_zombie(spawner, spawner.targetname, location);
			if(isdefined(ai))
			{
				ai.spawn_point_override = location;
			}
		}
		wait(3);
	}
}

/*
	Name: function_8f86441a
	Namespace: zm_ai_napalm
	Checksum: 0xC8CCAF8A
	Offset: 0xEB0
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_8f86441a()
{
	self endon(#"death");
	spot = self.spawn_point_override;
	self.spawn_point = spot;
	if(isdefined(spot.target))
	{
		self.target = spot.target;
	}
	if(isdefined(spot.zone_name))
	{
		self.zone_name = spot.zone_name;
	}
	if(isdefined(spot.script_parameters))
	{
		self.script_parameters = spot.script_parameters;
	}
	self thread zm_spawner::do_zombie_rise(spot);
	thread function_df01587c();
}

/*
	Name: function_df01587c
	Namespace: zm_ai_napalm
	Checksum: 0x337C0CA3
	Offset: 0xF98
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_df01587c()
{
	wait(2);
	players = getplayers();
	players[randomintrange(0, players.size)] thread zm_audio::create_and_play_dialog("general", "napalm_spawn");
}

/*
	Name: _napalm_initsounds
	Namespace: zm_ai_napalm
	Checksum: 0x5EB49DDD
	Offset: 0x1010
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function _napalm_initsounds()
{
	level.zmb_vox["napalm_zombie"] = [];
	level.zmb_vox["napalm_zombie"]["ambient"] = "napalm_ambient";
	level.zmb_vox["napalm_zombie"]["sprint"] = "napalm_ambient";
	level.zmb_vox["napalm_zombie"]["attack"] = "napalm_attack";
	level.zmb_vox["napalm_zombie"]["teardown"] = "napalm_attack";
	level.zmb_vox["napalm_zombie"]["taunt"] = "napalm_ambient";
	level.zmb_vox["napalm_zombie"]["behind"] = "napalm_ambient";
	level.zmb_vox["napalm_zombie"]["death"] = "napalm_explode";
	level.zmb_vox["napalm_zombie"]["crawler"] = "napalm_ambient";
}

/*
	Name: _entity_in_zone
	Namespace: zm_ai_napalm
	Checksum: 0x8C421F49
	Offset: 0x1158
	Size: 0x70
	Parameters: 1
	Flags: None
*/
function _entity_in_zone(zone)
{
	for(i = 0; i < zone.volumes.size; i++)
	{
		if(self istouching(zone.volumes[i]))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: init_napalm_fx
	Namespace: zm_ai_napalm
	Checksum: 0x21E0B5C
	Offset: 0x11D0
	Size: 0x136
	Parameters: 0
	Flags: Linked
*/
function init_napalm_fx()
{
	level._effect["napalm_fire_forearm"] = "dlc5/temple/fx_ztem_napalm_zombie_forearm";
	level._effect["napalm_fire_torso"] = "dlc5/temple/fx_ztem_napalm_zombie_torso";
	level._effect["napalm_fire_ground"] = "dlc5/temple/fx_ztem_napalm_zombie_ground2";
	level._effect["napalm_explosion"] = "dlc5/temple/fx_ztem_napalm_zombie_exp";
	level._effect["napalm_fire_trigger"] = "dlc5/temple/fx_ztem_napalm_zombie_end2";
	level._effect["napalm_spawn"] = "dlc5/temple/fx_ztem_napalm_zombie_spawn7";
	level._effect["napalm_distortion"] = "dlc5/temple/fx_ztem_napalm_zombie_heat";
	level._effect["napalm_fire_forearm_end"] = "dlc5/temple/fx_ztem_napalm_zombie_torso_end";
	level._effect["napalm_fire_torso_end"] = "dlc5/temple/fx_ztem_napalm_zombie_forearm_end";
	level._effect["napalm_steam"] = "dlc5/temple/fx_ztem_zombie_torso_steam_runner";
	level._effect["napalm_feet_steam"] = "dlc5/temple/fx_ztem_zombie_torso_steam_runner";
}

/*
	Name: napalm_zombie_spawn
	Namespace: zm_ai_napalm
	Checksum: 0x8E9C65EB
	Offset: 0x1310
	Size: 0x2B4
	Parameters: 1
	Flags: Linked
*/
function napalm_zombie_spawn(animname_set)
{
	self.custom_location = &function_8f86441a;
	zm_spawner::zombie_spawn_init(animname_set);
	/#
		println("");
		setdvar("", 0);
	#/
	level.var_57ecc1a3 = level.round_number;
	self.animname = "napalm_zombie";
	self thread napalm_zombie_client_flag();
	self.napalm_zombie_glowing = 0;
	self.maxhealth = self.maxhealth * (getplayers().size * level.napalmhealthmultiplier);
	self.health = self.maxhealth;
	self.no_gib = 1;
	self.rising = 1;
	self.no_damage_points = 1;
	self.explosive_volume = 0;
	self.ignore_enemy_count = 1;
	self.deathfunction = &napalm_zombie_death;
	self.actor_full_damage_func = &_napalm_zombie_damage;
	self.nuke_damage_func = &_napalm_nuke_damage;
	self.instakill_func = undefined;
	self._zombie_shrink_callback = &_napalm_shrink;
	self._zombie_unshrink_callback = &_napalm_unshrink;
	self.water_trigger_func = &napalm_enter_water_trigger;
	self.custom_damage_func = &napalm_custom_damage;
	self.monkey_bolt_taunts = &napalm_monkey_bolt_taunts;
	self.canexplodetime = gettime() + 2000;
	self thread _zombie_watchstopeffects();
	self thread napalm_watch_for_sliding();
	self thread napalm_zombie_count_watch();
	self.zombie_move_speed = "walk";
	self.zombie_arms_position = "up";
	self.variant_type = randomint(3);
	self playsound("evt_napalm_zombie_spawn");
}

/*
	Name: napalm_zombie_client_flag
	Namespace: zm_ai_napalm
	Checksum: 0x9DF19E78
	Offset: 0x15D0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function napalm_zombie_client_flag()
{
	self clientfield::set("isnapalm", 1);
	self waittill(#"death");
	self clientfield::set("isnapalm", 0);
	napalm_clear_radius_fx_all_players();
}

/*
	Name: _napalm_nuke_damage
	Namespace: zm_ai_napalm
	Checksum: 0x99EC1590
	Offset: 0x1638
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _napalm_nuke_damage()
{
}

/*
	Name: _napalm_instakill_func
	Namespace: zm_ai_napalm
	Checksum: 0x99EC1590
	Offset: 0x1648
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function _napalm_instakill_func()
{
}

/*
	Name: napalm_custom_damage
	Namespace: zm_ai_napalm
	Checksum: 0xAE1B7E2F
	Offset: 0x1658
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function napalm_custom_damage(player)
{
	damage = self.meleedamage;
	if(isdefined(self.overridedeathdamage))
	{
		damage = int(self.overridedeathdamage);
	}
	return damage;
}

/*
	Name: _zombie_runexplosionwindupeffects
	Namespace: zm_ai_napalm
	Checksum: 0x3134EA64
	Offset: 0x16B0
	Size: 0x1E6
	Parameters: 0
	Flags: None
*/
function _zombie_runexplosionwindupeffects()
{
	fx = [];
	fx["J_Elbow_LE"] = "napalm_fire_forearm_end";
	fx["J_Elbow_RI"] = "napalm_fire_forearm_end";
	fx["J_Clavicle_RI"] = "napalm_fire_forearm_end";
	fx["J_Clavicle_LE"] = "napalm_fire_forearm_end";
	fx["J_SpineLower"] = "napalm_fire_torso_end";
	offsets["J_SpineLower"] = vectorscale((0, 1, 0), 10);
	watch = [];
	keys = getarraykeys(fx);
	for(i = 0; i < keys.size; i++)
	{
		jointname = keys[i];
		fxname = fx[jointname];
		offset = offsets[jointname];
		effectent = self _zombie_setupfxonjoint(jointname, fxname, offset);
		watch[i] = effectent;
	}
	self waittill(#"stop_fx");
	if(!isdefined(self))
	{
		return;
	}
	for(i = 0; i < watch.size; i++)
	{
		watch[i] delete();
	}
}

/*
	Name: _zombie_watchstopeffects
	Namespace: zm_ai_napalm
	Checksum: 0xE07F6530
	Offset: 0x18A0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function _zombie_watchstopeffects()
{
	self waittill(#"death");
	self notify(#"stop_fx");
	if(level flag::get("world_is_paused"))
	{
		self setignorepauseworld(1);
	}
}

/*
	Name: napalmcanexplode
	Namespace: zm_ai_napalm
	Checksum: 0xC45317E8
	Offset: 0x1900
	Size: 0x312
	Parameters: 1
	Flags: Linked, Private
*/
function private napalmcanexplode(entity)
{
	if(entity.animname !== "napalm_zombie")
	{
		return false;
	}
	if(level.napalmexploderadius <= 0)
	{
		return false;
	}
	napalmexploderadiussqr = level.napalmexploderadius * level.napalmexploderadius;
	napalmplayerwarningradius = level.napalmexplodedamageradius;
	napalmplayerwarningradiussqr = napalmplayerwarningradius * napalmplayerwarningradius;
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!zombie_utility::is_player_valid(player))
		{
			continue;
		}
		if(distance2dsquared(player.origin, entity.origin) < napalmplayerwarningradiussqr)
		{
			if(!isdefined(player.napalmradiuswarningtime) || player.napalmradiuswarningtime <= (gettime() - 0.1))
			{
				player clientfield::set_to_player("napalm_pstfx_burn", 1);
				player playloopsound("chr_burning_loop", 1);
				player.napalmradiuswarningtime = gettime() + 10000;
			}
		}
		else
		{
			if(isdefined(player.napalmradiuswarningtime) && player.napalmradiuswarningtime > gettime())
			{
				player exit_napalm_radius();
			}
			continue;
		}
		if(!isdefined(entity.favoriteenemy) || !isplayer(entity.favoriteenemy))
		{
			continue;
		}
		if(isdefined(entity.in_the_ground) && entity.in_the_ground)
		{
			continue;
		}
		if(entity.canexplodetime > gettime())
		{
			continue;
		}
		if((abs(player.origin[2] - entity.origin[2])) > 50)
		{
			continue;
		}
		if(distance2dsquared(player.origin, entity.origin) > napalmexploderadiussqr)
		{
			continue;
		}
		return true;
	}
	return false;
}

/*
	Name: napalmexplodeinitialize
	Namespace: zm_ai_napalm
	Checksum: 0x65A80B3D
	Offset: 0x1C20
	Size: 0x94
	Parameters: 2
	Flags: Linked, Private
*/
function private napalmexplodeinitialize(entity, asmstatename)
{
	if(level flag::get("world_is_paused"))
	{
		entity setignorepauseworld(1);
	}
	entity clientfield::set("napalmexplode", 1);
	entity playsound("evt_napalm_zombie_charge");
}

/*
	Name: napalmexplodeterminate
	Namespace: zm_ai_napalm
	Checksum: 0x994BBA71
	Offset: 0x1CC0
	Size: 0x6C
	Parameters: 2
	Flags: Linked, Private
*/
function private napalmexplodeterminate(entity, asmstatename)
{
	napalm_clear_radius_fx_all_players();
	entity.killed_self = 1;
	entity dodamage(entity.health + 666, entity.origin);
}

/*
	Name: napalm_zombie_death
	Namespace: zm_ai_napalm
	Checksum: 0x853F0EFF
	Offset: 0x1D38
	Size: 0x36A
	Parameters: 8
	Flags: Linked
*/
function napalm_zombie_death(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	zombies_axis = array::get_all_closest(self.origin, getaispeciesarray("axis", "all"), undefined, undefined, level.napalmzombiedamageradius);
	dogs = array::get_all_closest(self.origin, getaispeciesarray("allies", "zombie_dog"), undefined, undefined, level.napalmzombiedamageradius);
	zombies = arraycombine(zombies_axis, dogs, 0, 0);
	if(isdefined(level._effect["napalm_explosion"]))
	{
		playfxontag(level._effect["napalm_explosion"], self, "J_SpineLower");
	}
	self playsound("evt_napalm_zombie_explo");
	if(isdefined(self.attacker) && isplayer(self.attacker))
	{
		self.attacker thread zm_audio::create_and_play_dialog("kill", "napalm");
	}
	level notify(#"napalm_death", self.explosive_volume);
	self thread napalm_delay_delete();
	if(!self napalm_standing_in_water(1))
	{
		level thread napalm_fire_trigger(self, 80, 20, 0);
	}
	self thread _napalm_damage_zombies(zombies);
	napalm_clear_radius_fx_all_players();
	self _napalm_damage_players();
	if(isdefined(self.attacker) && isplayer(self.attacker) && (!(isdefined(self.killed_self) && self.killed_self)) && (!(isdefined(self.shrinked) && self.shrinked)))
	{
		players = level.players;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(zombie_utility::is_player_valid(player))
			{
				player zm_score::player_add_points("thundergun_fling", 300, (0, 0, 0), 0);
			}
		}
	}
	return self zm_spawner::zombie_death_animscript();
}

/*
	Name: napalm_delay_delete
	Namespace: zm_ai_napalm
	Checksum: 0x6BBB7A0A
	Offset: 0x20B0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function napalm_delay_delete()
{
	self endon(#"death");
	self setplayercollision(0);
	self thread zombie_utility::zombie_eye_glow_stop();
	util::wait_network_frame();
	self hide();
}

/*
	Name: _napalm_damage_zombies
	Namespace: zm_ai_napalm
	Checksum: 0x24248C19
	Offset: 0x2120
	Size: 0x28E
	Parameters: 1
	Flags: Linked
*/
function _napalm_damage_zombies(zombies)
{
	eyeorigin = self geteye();
	if(!isdefined(zombies))
	{
		return;
	}
	damageorigin = self.origin;
	standinginwater = self napalm_standing_in_water();
	for(i = 0; i < zombies.size; i++)
	{
		if(!isdefined(zombies[i]))
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(zombies[i]))
		{
			continue;
		}
		test_origin = zombies[i] geteye();
		if(!bullettracepassed(eyeorigin, test_origin, 0, undefined))
		{
			continue;
		}
		if(zombies[i].animname == "napalm_zombie")
		{
			continue;
		}
		if(!standinginwater)
		{
			zombies[i] thread zombie_death::flame_death_fx();
		}
		refs = [];
		refs[refs.size] = "guts";
		refs[refs.size] = "right_arm";
		refs[refs.size] = "left_arm";
		refs[refs.size] = "right_leg";
		refs[refs.size] = "left_leg";
		refs[refs.size] = "no_legs";
		refs[refs.size] = "head";
		if(refs.size)
		{
			zombies[i].a.gib_ref = array::random(refs);
		}
		zombies[i] dodamage(zombies[i].health + 666, damageorigin);
		util::wait_network_frame();
	}
}

/*
	Name: _napalm_damage_players
	Namespace: zm_ai_napalm
	Checksum: 0x2E8A8FE6
	Offset: 0x23B8
	Size: 0x51A
	Parameters: 0
	Flags: Linked
*/
function _napalm_damage_players()
{
	eyeorigin = self geteye();
	footorigin = self.origin + vectorscale((0, 0, 1), 8);
	midorigin = (footorigin[0], footorigin[1], (footorigin[2] + eyeorigin[2]) / 2);
	players_damaged_by_explosion = 0;
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(!zombie_utility::is_player_valid(players[i]))
		{
			continue;
		}
		test_origin = players[i] geteye();
		damageradius = level.napalmexplodedamageradius;
		if(isdefined(self.wet) && self.wet)
		{
			damageradius = level.napalmexplodedamageradiuswet;
		}
		if(distancesquared(eyeorigin, test_origin) > (damageradius * damageradius))
		{
			continue;
		}
		test_origin_foot = players[i].origin + vectorscale((0, 0, 1), 8);
		test_origin_mid = (test_origin_foot[0], test_origin_foot[1], (test_origin_foot[2] + test_origin[2]) / 2);
		if(!bullettracepassed(eyeorigin, test_origin, 0, undefined))
		{
			if(!bullettracepassed(midorigin, test_origin_mid, 0, undefined))
			{
				if(!bullettracepassed(footorigin, test_origin_foot, 0, undefined))
				{
					continue;
				}
			}
		}
		players_damaged_by_explosion = 1;
		if(isdefined(level._effect["player_fire_death_napalm"]))
		{
			playfxontag(level._effect["player_fire_death_napalm"], players[i], "J_SpineLower");
		}
		dist = distance(eyeorigin, test_origin);
		killplayerdamage = 100;
		killjusgsplayerdamage = 250;
		shellshockmintime = 1.5;
		shellshockmaxtime = 3;
		damage = level.napalmexplodedamagemin;
		shellshocktime = shellshockmaxtime;
		if(dist < level.napalmexplodekillradiusjugs)
		{
			damage = killjusgsplayerdamage;
		}
		else
		{
			if(dist < level.napalmexplodekillradius)
			{
				damage = killplayerdamage;
			}
			else
			{
				scale = (level.napalmexplodedamageradius - dist) / (level.napalmexplodedamageradius - level.napalmexplodekillradius);
				shellshocktime = (scale * (shellshockmaxtime - shellshockmintime)) + shellshockmintime;
				damage = (scale * (killplayerdamage - level.napalmexplodedamagemin)) + level.napalmexplodedamagemin;
			}
		}
		if(isdefined(self.shrinked) && self.shrinked)
		{
			damage = damage * 0.25;
			shellshocktime = shellshocktime * 0.25;
		}
		if(isdefined(self.wet) && self.wet)
		{
			damage = damage * 0.25;
			shellshocktime = shellshocktime * 0.25;
		}
		self.overridedeathdamage = damage;
		players[i] dodamage(damage, self.origin, self);
		players[i] shellshock("explosion", shellshocktime);
		players[i] thread zm_audio::create_and_play_dialog("kill", "napalm");
	}
	if(!players_damaged_by_explosion)
	{
		level notify(#"zomb_disposal_achieved");
	}
}

/*
	Name: napalm_fire_trigger
	Namespace: zm_ai_napalm
	Checksum: 0xF99D30AD
	Offset: 0x28E0
	Size: 0x28C
	Parameters: 4
	Flags: Linked
*/
function napalm_fire_trigger(ai, radius, time, spawnfire)
{
	aiisnapalm = ai.animname == "napalm_zombie";
	if(!aiisnapalm)
	{
		radius = radius / 2;
	}
	spawnflags = 1;
	trigger = spawn("trigger_radius", ai.origin, spawnflags, radius, 70);
	sound_ent = undefined;
	if(!isdefined(trigger))
	{
		return;
	}
	if(aiisnapalm)
	{
		if(spawnfire)
		{
			trigger.napalm_fire_damage = 10;
		}
		else
		{
			trigger.napalm_fire_damage = 40;
		}
		trigger.napalm_fire_damage_type = "burned";
		if(!spawnfire && isdefined(level._effect["napalm_fire_trigger"]))
		{
			sound_ent = spawn("script_origin", ai.origin);
			sound_ent playloopsound("evt_napalm_fire", 1);
			playfx(level._effect["napalm_fire_trigger"], ai.origin);
		}
	}
	else
	{
		trigger.napalm_fire_damage = 10;
		trigger.napalm_fire_damage_type = "triggerhurt";
		if(spawnfire)
		{
			ai thread zombie_death::flame_death_fx();
		}
	}
	trigger thread triggerdamage();
	wait(time);
	trigger notify(#"end_fire_effect");
	trigger delete();
	if(isdefined(sound_ent))
	{
		sound_ent stoploopsound(1);
		wait(1);
		sound_ent delete();
	}
}

/*
	Name: triggerdamage
	Namespace: zm_ai_napalm
	Checksum: 0xE959757B
	Offset: 0x2B78
	Size: 0x140
	Parameters: 0
	Flags: Linked
*/
function triggerdamage()
{
	self endon(#"end_fire_effect");
	while(true)
	{
		self waittill(#"trigger", guy);
		if(isplayer(guy))
		{
			if(zombie_utility::is_player_valid(guy))
			{
				debounce = 500;
				if(!isdefined(guy.last_napalm_fire_damage))
				{
					guy.last_napalm_fire_damage = -1 * debounce;
				}
				if((guy.last_napalm_fire_damage + debounce) < gettime())
				{
					guy dodamage(self.napalm_fire_damage, guy.origin, undefined, undefined, self.napalm_fire_damage_type);
					guy.last_napalm_fire_damage = gettime();
				}
			}
		}
		else if(guy.animname != "napalm_zombie")
		{
			guy thread kill_with_fire(self.napalm_fire_damage_type);
		}
	}
}

/*
	Name: kill_with_fire
	Namespace: zm_ai_napalm
	Checksum: 0x484BF1BD
	Offset: 0x2CC0
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function kill_with_fire(damagetype)
{
	self endon(#"death");
	if(isdefined(self.marked_for_death))
	{
		return;
	}
	self.marked_for_death = 1;
	if(self.animname == "monkey_zombie")
	{
	}
	else
	{
		if(!isdefined(level.burning_zombies))
		{
			level.burning_zombies = [];
		}
		if(level.burning_zombies.size < 6)
		{
			level.burning_zombies[level.burning_zombies.size] = self;
			self thread zombie_flame_watch();
			self playsound("evt_zombie_ignite");
			self thread zombie_death::flame_death_fx();
			wait(randomfloat(1.25));
		}
	}
	self dodamage(self.health + 666, self.origin, undefined, undefined, damagetype);
}

/*
	Name: zombie_flame_watch
	Namespace: zm_ai_napalm
	Checksum: 0x37B30D6C
	Offset: 0x2DE8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function zombie_flame_watch()
{
	if(isdefined(level.mutators) && level.mutators["mutator_noTraps"])
	{
		return;
	}
	self waittill(#"death");
	if(isdefined(self))
	{
		self stoploopsound();
		arrayremovevalue(level.burning_zombies, self);
	}
	else
	{
		array::remove_undefined(level.burning_zombies);
	}
}

/*
	Name: array_remove
	Namespace: zm_ai_napalm
	Checksum: 0xDBC1D952
	Offset: 0x2E80
	Size: 0x11C
	Parameters: 2
	Flags: None
*/
function array_remove(array, object)
{
	if(!isdefined(array) && !isdefined(object))
	{
		return;
	}
	new_array = [];
	foreach(item in array)
	{
		if(item != object)
		{
			if(!isdefined(new_array))
			{
				new_array = [];
			}
			else if(!isarray(new_array))
			{
				new_array = array(new_array);
			}
			new_array[new_array.size] = item;
		}
	}
	return new_array;
}

/*
	Name: _zombie_setupfxonjoint
	Namespace: zm_ai_napalm
	Checksum: 0x143B6F64
	Offset: 0x2FA8
	Size: 0x110
	Parameters: 3
	Flags: Linked
*/
function _zombie_setupfxonjoint(jointname, fxname, offset)
{
	origin = self gettagorigin(jointname);
	effectent = spawn("script_model", origin);
	effectent setmodel("tag_origin");
	effectent.angles = self gettagangles(jointname);
	if(!isdefined(offset))
	{
		offset = (0, 0, 0);
	}
	effectent linkto(self, jointname, offset);
	playfxontag(level._effect[fxname], effectent, "tag_origin");
	return effectent;
}

/*
	Name: _napalm_shrink
	Namespace: zm_ai_napalm
	Checksum: 0x99EC1590
	Offset: 0x30C0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _napalm_shrink()
{
}

/*
	Name: _napalm_unshrink
	Namespace: zm_ai_napalm
	Checksum: 0x99EC1590
	Offset: 0x30D0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _napalm_unshrink()
{
}

/*
	Name: _napalm_damage_callback
	Namespace: zm_ai_napalm
	Checksum: 0x6D4173FF
	Offset: 0x30E0
	Size: 0x88
	Parameters: 13
	Flags: Linked
*/
function _napalm_damage_callback(str_mod, str_hit_location, v_hit_origin, e_player, n_amount, w_weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel)
{
	if(self.classname == "actor_spawner_zm_temple_napalm")
	{
		return true;
	}
	return false;
}

/*
	Name: _napalm_zombie_damage
	Namespace: zm_ai_napalm
	Checksum: 0xC6ADEEA3
	Offset: 0x3170
	Size: 0xFA
	Parameters: 11
	Flags: Linked
*/
function _napalm_zombie_damage(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, modelindex, psoffsettime)
{
	if(level.zombie_vars["zombie_insta_kill"])
	{
		damage = damage * 2;
	}
	if(isdefined(self.wet) && self.wet)
	{
		damage = damage * 5;
	}
	else if(self napalm_standing_in_water())
	{
		damage = damage * 2;
	}
	switch(weapon)
	{
		case "spikemore_zm":
		{
			damage = 0;
			break;
		}
	}
	return damage;
}

/*
	Name: napalm_zombie_count_watch
	Namespace: zm_ai_napalm
	Checksum: 0xA533374
	Offset: 0x3278
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function napalm_zombie_count_watch()
{
	if(!isdefined(level.napalmzombiecount))
	{
		level.napalmzombiecount = 0;
	}
	level.napalmzombiecount++;
	level.var_4e4c9791[level.var_4e4c9791.size] = self;
	self waittill(#"death");
	level.napalmzombiecount--;
	arrayremovevalue(level.var_4e4c9791, self, 0);
	if(isdefined(self.shrinked) && self.shrinked)
	{
		level.nextnapalmspawnround = level.round_number + 1;
	}
	else
	{
		level.nextnapalmspawnround = level.round_number + (randomintrange(level.napalmzombieminroundwait, level.napalmzombiemaxroundwait + 1));
	}
	/#
		println("" + level.nextnapalmspawnround);
	#/
}

/*
	Name: napalm_clear_radius_fx_all_players
	Namespace: zm_ai_napalm
	Checksum: 0xF6B61C0E
	Offset: 0x3378
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function napalm_clear_radius_fx_all_players()
{
	players = getplayers();
	for(j = 0; j < players.size; j++)
	{
		player_to_clear = players[j];
		if(!isdefined(player_to_clear))
		{
			continue;
		}
		player_to_clear exit_napalm_radius();
	}
}

/*
	Name: exit_napalm_radius
	Namespace: zm_ai_napalm
	Checksum: 0x1E096059
	Offset: 0x3408
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function exit_napalm_radius()
{
	self clientfield::set_to_player("napalm_pstfx_burn", 0);
	self stoploopsound(2);
	self.napalmradiuswarningtime = gettime();
}

/*
	Name: init_clientfields
	Namespace: zm_ai_napalm
	Checksum: 0x682A88F5
	Offset: 0x3458
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	clientfield::register("actor", "napalmwet", 21000, 1, "int");
	clientfield::register("actor", "napalmexplode", 21000, 1, "int");
	clientfield::register("actor", "isnapalm", 21000, 1, "int");
	clientfield::register("toplayer", "napalm_pstfx_burn", 21000, 1, "int");
}

/*
	Name: napalm_enter_water_trigger
	Namespace: zm_ai_napalm
	Checksum: 0xBDA720E0
	Offset: 0x3528
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function napalm_enter_water_trigger(trigger)
{
	self endon(#"death");
	self thread napalm_add_wet_time(4);
}

/*
	Name: napalm_add_wet_time
	Namespace: zm_ai_napalm
	Checksum: 0x6AB671E7
	Offset: 0x3560
	Size: 0xB8
	Parameters: 1
	Flags: Linked
*/
function napalm_add_wet_time(time)
{
	self endon(#"death");
	wettime = time * 1000;
	self.wet_time = gettime() + wettime;
	if(isdefined(self.wet) && self.wet)
	{
		return;
	}
	self.wet = 1;
	self thread napalm_start_wet_fx();
	while(self.wet_time > gettime())
	{
		wait(0.1);
	}
	self thread napalm_end_wet_fx();
	self.wet = 0;
}

/*
	Name: napalm_watch_for_sliding
	Namespace: zm_ai_napalm
	Checksum: 0xFD512E4F
	Offset: 0x3620
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function napalm_watch_for_sliding()
{
	self endon(#"death");
	while(true)
	{
		if(isdefined(self.sliding) && self.sliding)
		{
			self thread napalm_add_wet_time(4);
		}
		wait(1);
	}
}

/*
	Name: napalm_start_wet_fx
	Namespace: zm_ai_napalm
	Checksum: 0xED7171BC
	Offset: 0x3678
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function napalm_start_wet_fx()
{
	self clientfield::set("napalmwet", 1);
}

/*
	Name: napalm_end_wet_fx
	Namespace: zm_ai_napalm
	Checksum: 0x7AF64C26
	Offset: 0x36A8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function napalm_end_wet_fx()
{
	self clientfield::set("napalmwet", 0);
}

/*
	Name: napalm_standing_in_water
	Namespace: zm_ai_napalm
	Checksum: 0xDD0BDDD5
	Offset: 0x36D8
	Size: 0xBA
	Parameters: 1
	Flags: Linked
*/
function napalm_standing_in_water(forcecheck)
{
	dotrace = !isdefined(self.standing_in_water_debounce);
	dotrace = dotrace || self.standing_in_water_debounce < gettime();
	dotrace = dotrace || (isdefined(forcecheck) && forcecheck);
	if(dotrace)
	{
		self.standing_in_water_debounce = gettime() + 500;
		waterheight = getwaterheight(self.origin);
		self.standing_in_water = waterheight > self.origin[2];
	}
	return self.standing_in_water;
}

/*
	Name: napalm_monkey_bolt_taunts
	Namespace: zm_ai_napalm
	Checksum: 0xEC576843
	Offset: 0x37A0
	Size: 0x10
	Parameters: 1
	Flags: Linked
*/
function napalm_monkey_bolt_taunts(monkey_bolt)
{
	return true;
}

