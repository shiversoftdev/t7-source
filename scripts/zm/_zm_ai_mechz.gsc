// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\_burnplayer;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\mechz;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_ai_mechz;

/*
	Name: __init__sytem__
	Namespace: zm_ai_mechz
	Checksum: 0x1E8D2BF0
	Offset: 0x6B0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_mechz", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_mechz
	Checksum: 0x9349CB6
	Offset: 0x6F8
	Size: 0x2BC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	function_f20c04a4();
	level.mechz_base_health = 1200;
	level.mechz_health = level.mechz_base_health;
	level.var_fa14536d = 1500;
	level.mechz_faceplate_health = level.var_fa14536d;
	level.var_f12b2aa3 = 500;
	level.mechz_powercap_cover_health = level.var_f12b2aa3;
	level.var_e12ec39f = 500;
	level.mechz_powercap_health = level.var_e12ec39f;
	level.var_3f1bf221 = 250;
	level.var_2cbc5b59 = level.var_3f1bf221;
	level.mechz_health_increase = 100;
	level.var_1a5bb9d8 = 100;
	level.var_a1943286 = 15;
	level.var_9684c99e = 15;
	level.var_158234c = 10;
	level.mechz_round_count = 0;
	level.mechz_spawners = getentarray("zombie_mechz_spawner", "script_noteworthy");
	level.mechz_locations = struct::get_array("mechz_location", "script_noteworthy");
	spawner::add_archetype_spawn_function("mechz", &function_3d5df242);
	zm::register_player_damage_callback(&function_ed70c868);
	level.mechz_flamethrower_ai_callback = &function_1add8026;
	level thread aat::register_immunity("zm_aat_blast_furnace", "mechz", 0, 1, 1);
	level thread aat::register_immunity("zm_aat_dead_wire", "mechz", 1, 1, 1);
	level thread aat::register_immunity("zm_aat_fire_works", "mechz", 1, 1, 1);
	level thread aat::register_immunity("zm_aat_thunder_wall", "mechz", 0, 1, 1);
	level thread aat::register_immunity("zm_aat_turned", "mechz", 1, 1, 1);
	/#
		execdevgui("");
		thread function_fbad70fd();
	#/
}

/*
	Name: __main__
	Namespace: zm_ai_mechz
	Checksum: 0xA6C7358E
	Offset: 0x9C0
	Size: 0x68
	Parameters: 0
	Flags: Linked, Private
*/
function private __main__()
{
	if(!isdefined(level.var_98b48f9c))
	{
		level.var_98b48f9c = 80;
	}
	visionset_mgr::register_info("overlay", "mechz_player_burn", 5000, level.var_98b48f9c, 15, 1, &visionset_mgr::duration_lerp_thread_per_player, 0);
	level.var_e7b9aac8 = 1;
}

/*
	Name: function_f20c04a4
	Namespace: zm_ai_mechz
	Checksum: 0xAA053713
	Offset: 0xA30
	Size: 0x2C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_f20c04a4()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMechzTargetService", &function_c28caf48);
}

/*
	Name: function_c28caf48
	Namespace: zm_ai_mechz
	Checksum: 0x747E6C8
	Offset: 0xA68
	Size: 0x29E
	Parameters: 1
	Flags: Linked, Private
*/
function private function_c28caf48(entity)
{
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return false;
	}
	if(isdefined(entity.destroy_octobomb))
	{
		return false;
	}
	player = zm_utility::get_closest_valid_player(self.origin, self.ignore_player);
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
		/#
			if(isdefined(level.b_mechz_true_ignore) && level.b_mechz_true_ignore)
			{
				entity setgoal(entity.origin);
				return false;
			}
		#/
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
	playerpos = player.origin;
	if(isdefined(player.last_valid_position))
	{
		playerpos = player.last_valid_position;
	}
	targetpos = getclosestpointonnavmesh(playerpos, 64, 30);
	if(isdefined(targetpos))
	{
		entity setgoal(targetpos);
		return true;
	}
	entity setgoal(entity.origin);
	return false;
}

/*
	Name: function_48cabef5
	Namespace: zm_ai_mechz
	Checksum: 0x3F4D2C84
	Offset: 0xD10
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_48cabef5()
{
	if(isdefined(self.customtraverseendnode) && isdefined(self.customtraversestartnode))
	{
		return self.customtraverseendnode.script_noteworthy === "custom_traversal" && self.customtraversestartnode.script_noteworthy === "custom_traversal";
	}
	return 0;
}

/*
	Name: function_3d5df242
	Namespace: zm_ai_mechz
	Checksum: 0xC8A7FC5D
	Offset: 0xD70
	Size: 0xE4
	Parameters: 0
	Flags: Linked, Private
*/
function private function_3d5df242()
{
	self.b_ignore_cleanup = 1;
	self.is_mechz = 1;
	self.n_start_health = self.health;
	self.team = level.zombie_team;
	self.zombie_lift_override = &function_817c85eb;
	self.thundergun_fling_func = &function_9bac2f00;
	self.thundergun_knockdown_func = &function_19b9b682;
	self.var_23340a5d = &function_9bac2f00;
	self.var_e1dbd63 = &function_19b9b682;
	self.var_48cabef5 = &function_48cabef5;
	level thread zm_spawner::zombie_death_event(self);
}

/*
	Name: function_ed70c868
	Namespace: zm_ai_mechz
	Checksum: 0x138FD51F
	Offset: 0xE60
	Size: 0x92
	Parameters: 10
	Flags: Linked, Private
*/
function private function_ed70c868(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime)
{
	if(isdefined(eattacker) && eattacker.archetype === "mechz" && smeansofdeath === "MOD_MELEE")
	{
		return 150;
	}
	return -1;
}

/*
	Name: function_58655f2a
	Namespace: zm_ai_mechz
	Checksum: 0x1CBB4EE6
	Offset: 0xF00
	Size: 0x32
	Parameters: 0
	Flags: None
*/
function function_58655f2a()
{
	if(!(isdefined(self.stun) && self.stun) && self.stumble_stun_cooldown_time < gettime())
	{
		return true;
	}
	return false;
}

/*
	Name: function_9bac2f00
	Namespace: zm_ai_mechz
	Checksum: 0x7F52E823
	Offset: 0xF40
	Size: 0x68
	Parameters: 2
	Flags: Linked
*/
function function_9bac2f00(e_player, gib)
{
	self endon(#"death");
	self function_b8e0ce15(e_player);
	if(!(isdefined(self.stun) && self.stun) && self.stumble_stun_cooldown_time < gettime())
	{
		self.stun = 1;
	}
}

/*
	Name: function_19b9b682
	Namespace: zm_ai_mechz
	Checksum: 0xF8494751
	Offset: 0xFB0
	Size: 0x68
	Parameters: 2
	Flags: Linked
*/
function function_19b9b682(e_player, gib)
{
	self endon(#"death");
	self function_b8e0ce15(e_player);
	if(!(isdefined(self.stun) && self.stun) && self.stumble_stun_cooldown_time < gettime())
	{
		self.stun = 1;
	}
}

/*
	Name: function_b8e0ce15
	Namespace: zm_ai_mechz
	Checksum: 0x17BF523A
	Offset: 0x1020
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function function_b8e0ce15(e_player)
{
	var_3bb42832 = level.mechz_health;
	if(isdefined(level.var_f4dc2834))
	{
		var_3bb42832 = math::clamp(var_3bb42832, 0, level.var_f4dc2834);
	}
	n_damage = (var_3bb42832 * 0.25) / 0.2;
	self dodamage(n_damage, self getcentroid(), e_player, e_player, undefined, "MOD_PROJECTILE_SPLASH", 0, getweapon("thundergun"));
}

/*
	Name: spawn_mechz
	Namespace: zm_ai_mechz
	Checksum: 0x9A47B505
	Offset: 0x10F8
	Size: 0x510
	Parameters: 2
	Flags: Linked
*/
function spawn_mechz(s_location, flyin = 0)
{
	if(isdefined(level.mechz_spawners[0]))
	{
		if(isdefined(level.var_7f2a926d))
		{
			[[level.var_7f2a926d]]();
		}
		level.mechz_spawners[0].script_forcespawn = 1;
		ai = zombie_utility::spawn_zombie(level.mechz_spawners[0], "mechz", s_location);
		if(isdefined(ai))
		{
			ai disableaimassist();
			ai thread function_ef1ba7e5();
			ai thread function_949a3fdf();
			/#
				ai thread function_75a79bb5();
			#/
			ai.actor_damage_func = &mechzserverutils::mechzdamagecallback;
			ai.damage_scoring_function = &function_b03abc02;
			ai.mechz_melee_knockdown_function = &function_55483494;
			ai.health = level.mechz_health;
			ai.faceplate_health = level.mechz_faceplate_health;
			ai.powercap_cover_health = level.mechz_powercap_cover_health;
			ai.powercap_health = level.mechz_powercap_health;
			ai.left_knee_armor_health = level.var_2cbc5b59;
			ai.right_knee_armor_health = level.var_2cbc5b59;
			ai.left_shoulder_armor_health = level.var_2cbc5b59;
			ai.right_shoulder_armor_health = level.var_2cbc5b59;
			ai.heroweapon_kill_power = 10;
			e_player = zm_utility::get_closest_player(s_location.origin);
			v_dir = e_player.origin - s_location.origin;
			v_dir = vectornormalize(v_dir);
			v_angles = vectortoangles(v_dir);
			var_89f898ad = zm_utility::flat_angle(v_angles);
			s_spawn_location = s_location;
			queryresult = positionquery_source_navigation(s_spawn_location.origin, 0, 32, 20, 4);
			if(queryresult.data.size)
			{
				v_ground_position = array::random(queryresult.data).origin;
			}
			if(!isdefined(v_ground_position))
			{
				trace = bullettrace(s_spawn_location.origin, s_spawn_location.origin + (vectorscale((0, 0, -1), 256)), 0, s_location);
				v_ground_position = trace["position"];
			}
			var_1750e965 = v_ground_position;
			if(isdefined(level.var_e1e49cc1))
			{
				ai thread [[level.var_e1e49cc1]]();
			}
			ai forceteleport(var_1750e965, var_89f898ad);
			if(flyin === 1)
			{
				ai thread function_d07fd448();
				ai thread scene::play("cin_zm_castle_mechz_entrance", ai);
				ai thread function_c441eaba(var_1750e965);
				ai thread function_bbdc1f34(var_1750e965);
			}
			else
			{
				if(isdefined(level.var_7d2a391d))
				{
					ai thread [[level.var_7d2a391d]]();
				}
				ai.b_flyin_done = 1;
			}
			ai thread function_bb048b27();
			ai.ignore_round_robbin_death = 1;
			/#
				ai.ignore_devgui_death = 1;
			#/
			return ai;
		}
	}
	return undefined;
}

/*
	Name: function_d07fd448
	Namespace: zm_ai_mechz
	Checksum: 0xD4416EA0
	Offset: 0x1610
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_d07fd448()
{
	self endon(#"death");
	self.b_flyin_done = 0;
	self.bgbignorefearinheadlights = 1;
	self util::waittill_any("mechz_flyin_done", "scene_done");
	self.b_flyin_done = 1;
	self.bgbignorefearinheadlights = 0;
}

/*
	Name: function_c441eaba
	Namespace: zm_ai_mechz
	Checksum: 0x7E37640
	Offset: 0x1680
	Size: 0x34C
	Parameters: 1
	Flags: Linked
*/
function function_c441eaba(var_678a2319)
{
	self endon(#"death");
	var_b54110bd = 2304;
	var_f0dad551 = 9216;
	var_44615973 = 2250000;
	self waittill(#"hash_f93797a6");
	a_zombies = getaiarchetypearray("zombie");
	foreach(e_zombie in a_zombies)
	{
		dist_sq = distancesquared(e_zombie.origin, var_678a2319);
		if(dist_sq <= var_b54110bd)
		{
			e_zombie kill();
		}
	}
	a_players = getplayers();
	foreach(player in a_players)
	{
		dist_sq = distancesquared(player.origin, var_678a2319);
		if(dist_sq <= var_b54110bd)
		{
			player dodamage(100, var_678a2319, self, self);
		}
		scale = (var_44615973 - dist_sq) / var_44615973;
		if(scale <= 0 || scale >= 1)
		{
			return;
		}
		earthquake_scale = scale * 0.15;
		earthquake(earthquake_scale, 0.1, var_678a2319, 1500);
		if(scale >= 0.66)
		{
			player playrumbleonentity("shotgun_fire");
			continue;
		}
		if(scale >= 0.33)
		{
			player playrumbleonentity("damage_heavy");
			continue;
		}
		player playrumbleonentity("reload_small");
	}
	if(isdefined(self.var_1411e129))
	{
		self.var_1411e129 delete();
	}
}

/*
	Name: function_bbdc1f34
	Namespace: zm_ai_mechz
	Checksum: 0xE3ED89A7
	Offset: 0x19D8
	Size: 0x280
	Parameters: 1
	Flags: Linked
*/
function function_bbdc1f34(var_678a2319)
{
	self endon(#"death");
	self endon(#"hash_f93797a6");
	self waittill(#"hash_3d18ed4f");
	var_f0dad551 = 9216;
	while(true)
	{
		a_players = getplayers();
		foreach(player in a_players)
		{
			dist_sq = distancesquared(player.origin, var_678a2319);
			if(dist_sq <= var_f0dad551)
			{
				if(!(isdefined(player.is_burning) && player.is_burning) && zombie_utility::is_player_valid(player, 0))
				{
					player function_3389e2f3(self);
				}
			}
		}
		a_zombies = zm_elemental_zombie::function_d41418b8();
		foreach(e_zombie in a_zombies)
		{
			dist_sq = distancesquared(e_zombie.origin, var_678a2319);
			if(dist_sq <= var_f0dad551 && self.var_e05d0be2 !== 1)
			{
				self function_3efae612(e_zombie);
				e_zombie zm_elemental_zombie::function_f4defbc2();
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_3389e2f3
	Namespace: zm_ai_mechz
	Checksum: 0xE270D828
	Offset: 0x1C60
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function function_3389e2f3(mechz)
{
	if(!(isdefined(self.is_burning) && self.is_burning) && zombie_utility::is_player_valid(self, 1))
	{
		self.is_burning = 1;
		if(!self hasperk("specialty_armorvest"))
		{
			self burnplayer::setplayerburning(1.5, 0.5, 30, mechz, undefined);
		}
		else
		{
			self burnplayer::setplayerburning(1.5, 0.5, 20, mechz, undefined);
		}
		wait(1.5);
		self.is_burning = 0;
	}
}

/*
	Name: function_817c85eb
	Namespace: zm_ai_mechz
	Checksum: 0xDAA3C3AB
	Offset: 0x1D48
	Size: 0x2C8
	Parameters: 6
	Flags: Linked
*/
function function_817c85eb(e_player, v_attack_source, n_push_away, n_lift_height, v_lift_offset, n_lift_speed)
{
	self endon(#"death");
	if(isdefined(self.in_gravity_trap) && self.in_gravity_trap && e_player.gravityspikes_state === 3)
	{
		if(isdefined(self.var_1f5fe943) && self.var_1f5fe943)
		{
			return;
		}
		self.var_bcecff1d = 1;
		self.var_1f5fe943 = 1;
		self dodamage(10, self.origin);
		self.var_ab0efcf6 = self.origin;
		self thread scene::play("cin_zm_dlc1_mechz_dth_deathray_01", self);
		self clientfield::set("sparky_beam_fx", 1);
		self clientfield::set("death_ray_shock_fx", 1);
		self playsound("zmb_talon_electrocute");
		n_start_time = gettime();
		n_total_time = 0;
		while(10 > n_total_time && e_player.gravityspikes_state === 3)
		{
			util::wait_network_frame();
			n_total_time = (gettime() - n_start_time) / 1000;
		}
		self scene::stop("cin_zm_dlc1_mechz_dth_deathray_01");
		self thread function_bb84a54(self);
		self clientfield::set("sparky_beam_fx", 0);
		self clientfield::set("death_ray_shock_fx", 0);
		self.var_bcecff1d = undefined;
		while(e_player.gravityspikes_state === 3)
		{
			util::wait_network_frame();
		}
		self.var_1f5fe943 = undefined;
		self.in_gravity_trap = undefined;
	}
	else
	{
		self dodamage(10, self.origin);
		if(!(isdefined(self.stun) && self.stun))
		{
			self.stun = 1;
		}
	}
}

/*
	Name: function_bb84a54
	Namespace: zm_ai_mechz
	Checksum: 0x6CFD4C09
	Offset: 0x2018
	Size: 0x1A4
	Parameters: 1
	Flags: Linked
*/
function function_bb84a54(mechz)
{
	mechz endon(#"death");
	if(isdefined(mechz))
	{
		mechz scene::play("cin_zm_dlc1_mechz_dth_deathray_02", mechz);
	}
	if(isdefined(mechz) && isalive(mechz) && isdefined(mechz.var_ab0efcf6))
	{
		v_eye_pos = mechz gettagorigin("tag_eye");
		/#
			recordline(mechz.origin, v_eye_pos, vectorscale((0, 1, 0), 255), "", mechz);
		#/
		trace = bullettrace(v_eye_pos, mechz.origin, 0, mechz);
		if(trace["position"] !== mechz.origin)
		{
			point = getclosestpointonnavmesh(trace["position"], 64, 30);
			if(!isdefined(point))
			{
				point = mechz.var_ab0efcf6;
			}
			mechz forceteleport(point);
		}
	}
}

/*
	Name: function_1add8026
	Namespace: zm_ai_mechz
	Checksum: 0x42984563
	Offset: 0x21C8
	Size: 0x102
	Parameters: 1
	Flags: Linked
*/
function function_1add8026(mechz)
{
	flametrigger = mechz.flametrigger;
	a_zombies = zm_elemental_zombie::function_d41418b8();
	foreach(zombie in a_zombies)
	{
		if(zombie istouching(flametrigger) && zombie.var_e05d0be2 !== 1)
		{
			zombie zm_elemental_zombie::function_f4defbc2();
		}
	}
}

/*
	Name: function_ef1ba7e5
	Namespace: zm_ai_mechz
	Checksum: 0x6ECF0982
	Offset: 0x22D8
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_ef1ba7e5()
{
	self waittill(#"death");
	if(isplayer(self.attacker))
	{
		event = "death_mechz";
		if(!(isdefined(self.deathpoints_already_given) && self.deathpoints_already_given))
		{
			self.attacker zm_score::player_add_points(event, 1500);
		}
		if(isdefined(level.hero_power_update))
		{
			[[level.hero_power_update]](self.attacker, self);
		}
	}
}

/*
	Name: function_949a3fdf
	Namespace: zm_ai_mechz
	Checksum: 0xC9753F16
	Offset: 0x2380
	Size: 0x172
	Parameters: 0
	Flags: Linked
*/
function function_949a3fdf()
{
	self waittill(#"hash_46c1e51d");
	v_origin = self.origin;
	a_ai = getaispeciesarray(level.zombie_team);
	a_ai_kill_zombies = arraysortclosest(a_ai, v_origin, 18, 0, 200);
	foreach(ai_enemy in a_ai_kill_zombies)
	{
		if(isdefined(ai_enemy))
		{
			if(ai_enemy.archetype === "mechz")
			{
				ai_enemy dodamage(level.mechz_health * 0.25, v_origin);
			}
			else
			{
				ai_enemy dodamage(ai_enemy.health + 100, v_origin);
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_b03abc02
	Namespace: zm_ai_mechz
	Checksum: 0xD98EAD1A
	Offset: 0x2500
	Size: 0x10C
	Parameters: 12
	Flags: Linked
*/
function function_b03abc02(inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex)
{
	if(isdefined(attacker) && isplayer(attacker))
	{
		if(zm_spawner::player_using_hi_score_weapon(attacker))
		{
			damage_type = "damage";
		}
		else
		{
			damage_type = "damage_light";
		}
		if(!(isdefined(self.no_damage_points) && self.no_damage_points))
		{
			attacker zm_score::player_add_points(damage_type, mod, hitloc, self.isdog, self.team, weapon);
		}
	}
}

/*
	Name: function_3efae612
	Namespace: zm_ai_mechz
	Checksum: 0x6D1727E3
	Offset: 0x2618
	Size: 0x2A4
	Parameters: 1
	Flags: Linked
*/
function function_3efae612(zombie)
{
	zombie.knockdown = 1;
	zombie.knockdown_type = "knockdown_shoved";
	zombie_to_mechz = self.origin - zombie.origin;
	zombie_to_mechz_2d = vectornormalize((zombie_to_mechz[0], zombie_to_mechz[1], 0));
	zombie_forward = anglestoforward(zombie.angles);
	zombie_forward_2d = vectornormalize((zombie_forward[0], zombie_forward[1], 0));
	zombie_right = anglestoright(zombie.angles);
	zombie_right_2d = vectornormalize((zombie_right[0], zombie_right[1], 0));
	dot = vectordot(zombie_to_mechz_2d, zombie_forward_2d);
	if(dot >= 0.5)
	{
		zombie.knockdown_direction = "front";
		zombie.getup_direction = "getup_back";
	}
	else
	{
		if(dot < 0.5 && dot > -0.5)
		{
			dot = vectordot(zombie_to_mechz_2d, zombie_right_2d);
			if(dot > 0)
			{
				zombie.knockdown_direction = "right";
				if(math::cointoss())
				{
					zombie.getup_direction = "getup_back";
				}
				else
				{
					zombie.getup_direction = "getup_belly";
				}
			}
			else
			{
				zombie.knockdown_direction = "left";
				zombie.getup_direction = "getup_belly";
			}
		}
		else
		{
			zombie.knockdown_direction = "back";
			zombie.getup_direction = "getup_belly";
		}
	}
}

/*
	Name: function_55483494
	Namespace: zm_ai_mechz
	Checksum: 0x8DDC6FC8
	Offset: 0x28C8
	Size: 0x10A
	Parameters: 0
	Flags: Linked
*/
function function_55483494()
{
	a_zombies = getaiarchetypearray("zombie");
	foreach(zombie in a_zombies)
	{
		dist_sq = distancesquared(self.origin, zombie.origin);
		if(zombie function_10d36217(self) && dist_sq <= 12544)
		{
			self function_3efae612(zombie);
		}
	}
}

/*
	Name: function_10d36217
	Namespace: zm_ai_mechz
	Checksum: 0x97014B61
	Offset: 0x29E0
	Size: 0x184
	Parameters: 1
	Flags: Linked
*/
function function_10d36217(mechz)
{
	origin = self.origin;
	facing_vec = anglestoforward(mechz.angles);
	enemy_vec = origin - mechz.origin;
	enemy_yaw_vec = (enemy_vec[0], enemy_vec[1], 0);
	facing_yaw_vec = (facing_vec[0], facing_vec[1], 0);
	enemy_yaw_vec = vectornormalize(enemy_yaw_vec);
	facing_yaw_vec = vectornormalize(facing_yaw_vec);
	enemy_dot = vectordot(facing_yaw_vec, enemy_yaw_vec);
	if(enemy_dot < 0.7)
	{
		return false;
	}
	enemy_angles = vectortoangles(enemy_vec);
	if(abs(angleclamp180(enemy_angles[0])) > 45)
	{
		return false;
	}
	return true;
}

/*
	Name: function_bb048b27
	Namespace: zm_ai_mechz
	Checksum: 0x433026DB
	Offset: 0x2B70
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function function_bb048b27()
{
	self endon(#"death");
	while(true)
	{
		wait(randomintrange(9, 14));
		self playsound("zmb_ai_mechz_vox_ambient");
	}
}

/*
	Name: function_75a79bb5
	Namespace: zm_ai_mechz
	Checksum: 0xEEE038CF
	Offset: 0x2BD0
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function function_75a79bb5()
{
	self endon(#"death");
	/#
		while(true)
		{
			if(isdefined(level.var_70068a8) && level.var_70068a8)
			{
				if(self.health > 0)
				{
					print3d(self.origin + vectorscale((0, 0, 1), 72), self.health, (0, 0.8, 0.6), 3);
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_fbad70fd
	Namespace: zm_ai_mechz
	Checksum: 0xF8F6CEC
	Offset: 0x2C70
	Size: 0x44
	Parameters: 0
	Flags: Linked, Private
*/
function private function_fbad70fd()
{
	/#
		level flagsys::wait_till("");
		zm_devgui::add_custom_devgui_callback(&function_94a24a91);
	#/
}

/*
	Name: function_94a24a91
	Namespace: zm_ai_mechz
	Checksum: 0xA825197A
	Offset: 0x2CC0
	Size: 0x40E
	Parameters: 1
	Flags: Linked, Private
*/
function private function_94a24a91(cmd)
{
	/#
		players = getplayers();
		var_6aad1b23 = getentarray("", "");
		mechz = arraygetclosest(getplayers()[0].origin, var_6aad1b23);
		switch(cmd)
		{
			case "":
			{
				queryresult = positionquery_source_navigation(players[0].origin, 128, 256, 128, 20);
				spot = spawnstruct();
				spot.origin = players[0].origin;
				if(isdefined(queryresult) && queryresult.data.size > 0)
				{
					spot.origin = queryresult.data[0].origin;
				}
				mechz = spawn_mechz(spot);
				break;
			}
			case "":
			{
				if(!isdefined(level.zm_loc_types[""]) || level.zm_loc_types[""].size == 0)
				{
					iprintln("");
				}
				spot = arraygetclosest(getplayers()[0].origin, level.zm_loc_types[""]);
				if(isdefined(spot))
				{
					mechz = spawn_mechz(spot, 1);
				}
				else
				{
					iprintln("");
				}
				break;
			}
			case "":
			{
				if(isdefined(mechz))
				{
					mechz kill();
				}
				break;
			}
			case "":
			{
				if(isdefined(mechz))
				{
					if(isdefined(mechz.shoot_grenade))
					{
						mechz.shoot_grenade = !mechz.shoot_grenade;
					}
					else
					{
						mechz.shoot_grenade = 1;
					}
				}
				break;
			}
			case "":
			{
				if(isdefined(mechz))
				{
					if(isdefined(mechz.shoot_flame))
					{
						mechz.shoot_flame = !mechz.shoot_flame;
					}
					else
					{
						mechz.shoot_flame = 1;
					}
				}
				break;
			}
			case "":
			{
				if(isdefined(mechz))
				{
					mechz.berserk = 1;
				}
				break;
			}
			case "":
			{
				if(!(isdefined(level.var_70068a8) && level.var_70068a8))
				{
					level.var_70068a8 = 1;
				}
				else
				{
					level.var_70068a8 = 0;
				}
				break;
			}
			case "":
			{
				if(!(isdefined(level.b_mechz_true_ignore) && level.b_mechz_true_ignore))
				{
					level.b_mechz_true_ignore = 1;
				}
				else
				{
					level.b_mechz_true_ignore = 0;
				}
				break;
			}
		}
	#/
}

