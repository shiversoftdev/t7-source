// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\archetype_thrasher;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_ai_thrasher;

/*
	Name: __init__sytem__
	Namespace: zm_ai_thrasher
	Checksum: 0xC76A15FE
	Offset: 0x730
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_thrasher", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_thrasher
	Checksum: 0x28B1477C
	Offset: 0x778
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level flag::init("thrasher_round");
	/#
		execdevgui("");
		thread function_ae069b1c();
	#/
	init();
}

/*
	Name: __main__
	Namespace: zm_ai_thrasher
	Checksum: 0xF502A7D6
	Offset: 0x7E8
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	register_clientfields();
}

/*
	Name: register_clientfields
	Namespace: zm_ai_thrasher
	Checksum: 0x6F795645
	Offset: 0x808
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("actor", "thrasher_mouth_cf", 9000, 8, "int");
}

/*
	Name: init
	Namespace: zm_ai_thrasher
	Checksum: 0xA0968E02
	Offset: 0x848
	Size: 0x354
	Parameters: 0
	Flags: Linked
*/
function init()
{
	precache();
	level.can_revive = &thrasherserverutils::thrashercanberevived;
	level.var_11b06c2f = &function_6f6d7a0b;
	level.var_82212ebb = 1;
	level.var_f51fb588 = 0;
	level.var_175273f2 = 1;
	level.var_35a5aa88 = [];
	level.var_b5799c7c = 1;
	level.var_1f0937ce = 1;
	level.var_2f83d088 = 0;
	level.aat["zm_aat_blast_furnace"].immune_result_direct["thrasher"] = 1;
	level.aat["zm_aat_blast_furnace"].immune_result_indirect["thrasher"] = 1;
	level.aat["zm_aat_turned"].immune_trigger["thrasher"] = 1;
	level.aat["zm_aat_fire_works"].immune_trigger["thrasher"] = 1;
	level.aat["zm_aat_thunder_wall"].immune_result_direct["thrasher"] = 1;
	level.aat["zm_aat_thunder_wall"].immune_result_indirect["thrasher"] = 1;
	level.var_feebf312 = [];
	level.var_feebf312 = getentarray("zombie_thrasher_spawner", "script_noteworthy");
	if(level.var_feebf312.size == 0)
	{
		return;
	}
	array::thread_all(level.var_feebf312, &spawner::add_spawn_function, &function_a716de1f);
	scene::add_scene_func("scene_zm_dlc2_thrasher_transform_thrasher", &function_1c624caf, "done");
	scene::add_scene_func("scene_zm_dlc2_thrasher_transform_zombie", &function_1c624caf, "done");
	scene::add_scene_func("scene_zm_dlc2_thrasher_transform_zombie_friendly", &function_1c624caf, "done");
	scene::add_scene_func("scene_zm_dlc2_thrasher_teleport_out", &function_1c624caf, "done");
	scene::add_scene_func("scene_zm_dlc2_thrasher_teleport_in_v1", &function_1c624caf, "done");
	scene::add_scene_func("scene_zm_dlc2_thrasher_attack_swing_swipe", &function_1c624caf, "done");
	level thread function_10d1beae();
}

/*
	Name: function_10d1beae
	Namespace: zm_ai_thrasher
	Checksum: 0xAB176F81
	Offset: 0xBA8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_10d1beae()
{
	level endon(#"end_game");
	while(true)
	{
		level waittill(#"end_of_round");
		level.var_2f83d088 = 0;
	}
}

/*
	Name: function_e2049637
	Namespace: zm_ai_thrasher
	Checksum: 0x6D962E8D
	Offset: 0xBE8
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function function_e2049637(var_5d1c220e = 30)
{
	level notify(#"hash_5e591bf9");
	level endon(#"hash_5e591bf9");
	level.var_b5799c7c = 0;
	wait(var_5d1c220e);
	level.var_b5799c7c = 1;
}

/*
	Name: precache
	Namespace: zm_ai_thrasher
	Checksum: 0x99EC1590
	Offset: 0xC48
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache()
{
}

/*
	Name: function_5e5433d8
	Namespace: zm_ai_thrasher
	Checksum: 0xE2378BD6
	Offset: 0xC58
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_5e5433d8()
{
	level.var_f51fb588 = 1;
	if(!isdefined(level.var_fc6fe2e6))
	{
		level.var_fc6fe2e6 = &function_8aac3fe;
	}
	level thread [[level.var_fc6fe2e6]]();
}

/*
	Name: function_8aac3fe
	Namespace: zm_ai_thrasher
	Checksum: 0xA1384080
	Offset: 0xCA8
	Size: 0x210
	Parameters: 0
	Flags: Linked
*/
function function_8aac3fe()
{
	level.var_175273f2 = 1;
	level.var_e51f5b82 = 0;
	level.var_ebc4830 = level.round_number + randomintrange(4, 7);
	while(true)
	{
		level waittill(#"between_round_over");
		level.var_e51f5b82 = 0;
		if(isdefined(level.var_3013498) && level.round_number == level.var_3013498)
		{
			level.var_ebc4830 = level.var_ebc4830 + 1;
			continue;
		}
		if(level flag::exists("connect_bunker_exterior_to_bunker_interior"))
		{
			if(level.round_number === level.var_ebc4830 && !level flag::get("connect_bunker_exterior_to_bunker_interior"))
			{
				level.var_ebc4830 = level.var_ebc4830 + 1;
				continue;
			}
		}
		if(level.round_number === level.var_ebc4830 && (level.round_number - level.var_1f0937ce) <= 3)
		{
			level.var_ebc4830 = level.var_ebc4830 + 1;
			continue;
		}
		if(level.round_number == level.var_ebc4830)
		{
			level.var_ebc4830 = level.round_number + 3;
			level thread function_8b7e4b15();
			level flag::set("thrasher_round");
			level waittill(#"end_of_round");
			level flag::clear("thrasher_round");
			level.var_175273f2++;
			/#
				iprintln("" + level.var_ebc4830);
			#/
		}
	}
}

/*
	Name: function_8b7e4b15
	Namespace: zm_ai_thrasher
	Checksum: 0x7D352790
	Offset: 0xEC0
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_8b7e4b15()
{
	level endon(#"end_of_round");
	var_d1cba433 = [];
	while(true)
	{
		var_d1cba433 = zombie_utility::get_zombie_array();
		if(var_d1cba433.size >= 4)
		{
			break;
		}
		wait(0.5);
	}
	switch(level.players.size)
	{
		case 1:
		{
			var_30227ea9 = 2;
			break;
		}
		case 2:
		{
			var_30227ea9 = 2;
			break;
		}
		case 3:
		{
			var_30227ea9 = 3;
			break;
		}
		case 4:
		{
			var_30227ea9 = 4;
			break;
		}
		default:
		{
			var_30227ea9 = 2;
			break;
		}
	}
	for(i = 0; i < var_30227ea9; i++)
	{
		spawn_thrasher();
		wait(30);
	}
}

/*
	Name: function_6f6d7a0b
	Namespace: zm_ai_thrasher
	Checksum: 0xF46A3E79
	Offset: 0x1000
	Size: 0xA2
	Parameters: 3
	Flags: Linked
*/
function function_6f6d7a0b(e_revivee, ignore_sight_checks = 0, ignore_touch_checks = 0)
{
	if(isdefined(e_revivee.thrasherconsumed) && e_revivee.thrasherconsumed)
	{
		if(!isdefined(e_revivee.revivetrigger))
		{
			return 0;
		}
		return 1;
	}
	return self zm_laststand::can_revive(e_revivee, ignore_sight_checks, ignore_touch_checks);
}

/*
	Name: function_6d24956b
	Namespace: zm_ai_thrasher
	Checksum: 0xAA3544E
	Offset: 0x10B0
	Size: 0x1A0
	Parameters: 1
	Flags: Linked
*/
function function_6d24956b(v_origin)
{
	if(isdefined(v_origin))
	{
		if(!zm_utility::check_point_in_playable_area(v_origin))
		{
			return false;
		}
	}
	if(level.var_2f83d088 >= 2 && level.players.size == 1 && level.round_number < 20)
	{
		return false;
	}
	if(level.round_number < 4)
	{
		return false;
	}
	if(level.round_number < 7)
	{
		if(level flag::exists("connect_bunker_exterior_to_bunker_interior") && !level flag::get("connect_bunker_exterior_to_bunker_interior"))
		{
			if(level.var_35a5aa88.size >= 1)
			{
				return false;
			}
		}
	}
	switch(level.players.size)
	{
		case 1:
		{
			if(level.var_35a5aa88.size < 2)
			{
				return true;
			}
			break;
		}
		case 2:
		{
			if(level.var_35a5aa88.size < 2)
			{
				return true;
			}
			break;
		}
		case 3:
		{
			if(level.var_35a5aa88.size < 3)
			{
				return true;
			}
			break;
		}
		case 4:
		{
			if(level.var_35a5aa88.size < 4)
			{
				return true;
			}
			break;
		}
		default:
		{
			return false;
			break;
		}
	}
	return false;
}

/*
	Name: function_68ee76ee
	Namespace: zm_ai_thrasher
	Checksum: 0xD194928C
	Offset: 0x1258
	Size: 0x1AE
	Parameters: 2
	Flags: None
*/
function function_68ee76ee(var_d1cba433, var_48cf4a3d = 1)
{
	level endon(#"end_of_round");
	/#
		assert(var_d1cba433.size >= var_48cf4a3d, "");
	#/
	for(i = 0; i < var_48cf4a3d; i++)
	{
		var_a4ef4373 = undefined;
		while(!isdefined(var_a4ef4373))
		{
			foreach(ai in var_d1cba433)
			{
				if(function_cb4aac76(ai))
				{
					var_a4ef4373 = ai;
					break;
				}
			}
			wait(0.5);
		}
		if(isalive(var_a4ef4373))
		{
			if(function_6d24956b())
			{
				var_e3372b59 = function_8b323113(var_a4ef4373);
				arrayremovevalue(var_d1cba433, var_a4ef4373);
			}
		}
	}
}

/*
	Name: function_8b323113
	Namespace: zm_ai_thrasher
	Checksum: 0x46516EC0
	Offset: 0x1410
	Size: 0x51A
	Parameters: 4
	Flags: Linked
*/
function function_8b323113(var_a4ef4373, var_42fbb5b1 = 1, var_ab0dd5e8 = 1, var_be10dc4f = 0)
{
	level endon(#"end_of_round");
	var_30f9e367 = "scene_zm_dlc2_thrasher_transform_zombie";
	if(var_be10dc4f)
	{
		var_30f9e367 = "scene_zm_dlc2_thrasher_transform_zombie_friendly";
	}
	while(!(isdefined(var_a4ef4373.zombie_init_done) && var_a4ef4373.zombie_init_done))
	{
		wait(0.05);
	}
	if(isdefined(var_a4ef4373.var_61f7b3a0) && var_a4ef4373.var_61f7b3a0)
	{
		return;
	}
	if(isdefined(var_a4ef4373.var_cbbe29a9) && var_a4ef4373.var_cbbe29a9)
	{
		return;
	}
	if(var_ab0dd5e8)
	{
		if(!level.var_b5799c7c)
		{
			return;
		}
	}
	if(!function_6d24956b(var_a4ef4373.origin) && var_42fbb5b1)
	{
		return;
	}
	if(isalive(var_a4ef4373))
	{
		var_a4ef4373.var_34d00e7 = 1;
		if(var_be10dc4f == 0)
		{
			level notify(#"hash_49c2b21f", var_a4ef4373);
		}
		else
		{
			level notify(#"hash_de7b8073", var_a4ef4373);
		}
		e_align = util::spawn_model("tag_origin", var_a4ef4373.origin, var_a4ef4373.angles);
		e_align thread scene::play(var_30f9e367, var_a4ef4373);
		var_a4ef4373 util::waittill_notify_or_timeout("spawn_thrasher", 4);
	}
	if(isalive(var_a4ef4373))
	{
		if(!function_6d24956b(var_a4ef4373.origin) && var_42fbb5b1)
		{
			return;
		}
		var_e3372b59 = zombie_utility::spawn_zombie(level.var_feebf312[0], "thrasher");
		if(!isdefined(var_e3372b59))
		{
			return;
		}
		v_origin = var_a4ef4373.origin;
		v_angles = var_a4ef4373.angles;
		var_e3372b59 forceteleport(v_origin, v_angles, 1, 1);
		if(var_be10dc4f)
		{
			var_e3372b59 ai::set_behavior_attribute("move_mode", "friendly");
		}
		a_ai_zombies = getaiarchetypearray("zombie", "axis");
		foreach(ai_zombie in a_ai_zombies)
		{
			if(isalive(ai_zombie) && (!(isdefined(ai_zombie.var_3f6ea790) && ai_zombie.var_3f6ea790)) && ai_zombie != var_a4ef4373)
			{
				var_ee9aed61 = 60 * 60;
				if(distancesquared(ai_zombie.origin, var_e3372b59.origin) <= var_ee9aed61)
				{
					thrasherserverutils::thrasherknockdownzombie(var_e3372b59, ai_zombie);
				}
			}
		}
		var_ab201dd8 = util::spawn_model("tag_origin", var_e3372b59.origin, var_e3372b59.angles);
		var_ab201dd8 thread scene::play("scene_zm_dlc2_thrasher_transform_thrasher", var_e3372b59);
		level.var_1f0937ce = level.round_number;
		level thread function_e2049637();
		return var_e3372b59;
	}
}

/*
	Name: function_1c624caf
	Namespace: zm_ai_thrasher
	Checksum: 0xCA2ED3B6
	Offset: 0x1938
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function function_1c624caf(a_ents, e_align)
{
	self zm_utility::self_delete();
}

/*
	Name: function_bf8a850e
	Namespace: zm_ai_thrasher
	Checksum: 0x1EEEECB6
	Offset: 0x1970
	Size: 0x260
	Parameters: 3
	Flags: Linked
*/
function function_bf8a850e(v_origin, weapon, e_attacker)
{
	if(isdefined(level.var_d6539691))
	{
		self thread [[level.var_d6539691]](v_origin, weapon, e_attacker);
	}
	else
	{
		var_d454b8fe = 0;
		var_29d3165e = gettime();
		var_94f86cd2 = 60 * 60;
		var_5ce805c5 = 36;
		while((var_29d3165e + 5000) > gettime())
		{
			if(level.var_e51f5b82 < 2)
			{
				zombies = getaiarchetypearray("zombie", "axis");
				foreach(zombie in zombies)
				{
					if(isdefined(zombie) && isalive(zombie))
					{
						var_c494d994 = (zombie.origin[0], zombie.origin[1], zombie.origin[2] + var_5ce805c5);
						if(distancesquared(var_c494d994, v_origin) <= var_94f86cd2)
						{
							if(0.2 >= randomfloat(1) && function_cb4aac76(zombie))
							{
								level.var_e51f5b82++;
								var_d454b8fe++;
								function_8b323113(zombie);
							}
						}
						if(var_d454b8fe >= 2)
						{
							return;
						}
					}
				}
			}
			wait(0.5);
		}
	}
}

/*
	Name: spawn_thrasher
	Namespace: zm_ai_thrasher
	Checksum: 0x25516A5F
	Offset: 0x1BD8
	Size: 0x18A
	Parameters: 1
	Flags: Linked
*/
function spawn_thrasher(var_42fbb5b1 = 1)
{
	if(!function_6d24956b() && var_42fbb5b1)
	{
		return;
	}
	s_loc = function_22338aad();
	var_e3372b59 = zombie_utility::spawn_zombie(level.var_feebf312[0], "thrasher", s_loc);
	if(isdefined(var_e3372b59) && isdefined(s_loc))
	{
		var_e3372b59 forceteleport(s_loc.origin, s_loc.angles);
		playsoundatposition("zmb_vocals_thrash_spawn", var_e3372b59.origin);
		if(!var_e3372b59 zm_utility::in_playable_area())
		{
			player = array::random(level.players);
			if(zm_utility::is_player_valid(player, 0, 1))
			{
				var_e3372b59 thread function_89976d94(player.origin);
			}
		}
		return var_e3372b59;
	}
}

/*
	Name: function_89976d94
	Namespace: zm_ai_thrasher
	Checksum: 0xB226B203
	Offset: 0x1D70
	Size: 0x23C
	Parameters: 1
	Flags: Linked
*/
function function_89976d94(v_pos)
{
	self endon(#"death");
	var_2e57f81c = util::spawn_model("tag_origin", self.origin, self.angles);
	var_2e57f81c thread scene::play("scene_zm_dlc2_thrasher_teleport_out", self);
	self util::waittill_notify_or_timeout("thrasher_teleport_out_done", 4);
	a_v_points = util::positionquery_pointarray(v_pos, 128, 750, 32, 64, self);
	if(isdefined(self.thrasher_teleport_dest_func))
	{
		a_v_points = self [[self.thrasher_teleport_dest_func]](a_v_points);
	}
	var_72436e1a = arraygetfarthest(v_pos, a_v_points);
	if(isdefined(var_72436e1a))
	{
		v_dir = v_pos - var_72436e1a;
		v_dir = vectornormalize(v_dir);
		v_angles = vectortoangles(v_dir);
		var_948d85e3 = util::spawn_model("tag_origin", var_72436e1a, v_angles);
		var_2e57f81c scene::stop("scene_zm_dlc2_thrasher_teleport_out");
		var_948d85e3 thread scene::play("scene_zm_dlc2_thrasher_teleport_in_v1", self);
	}
	else
	{
		var_948d85e3 = util::spawn_model("tag_origin", v_pos, (0, 0, 0));
		var_2e57f81c scene::stop("scene_zm_dlc2_thrasher_teleport_out");
		var_948d85e3 thread scene::play("scene_zm_dlc2_thrasher_teleport_in_v1", self);
	}
}

/*
	Name: function_22338aad
	Namespace: zm_ai_thrasher
	Checksum: 0x4AB3F3B9
	Offset: 0x1FB8
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_22338aad()
{
	var_38efd13c = level.zm_loc_types["thrasher_location"];
	for(i = 0; i < var_38efd13c.size; i++)
	{
		if(isdefined(level.var_46a39590) && level.var_46a39590 == var_38efd13c[i])
		{
			continue;
		}
		s_spawn_loc = var_38efd13c[i];
		level.var_46a39590 = s_spawn_loc;
		return s_spawn_loc;
	}
	s_spawn_loc = var_38efd13c[0];
	level.var_46a39590 = s_spawn_loc;
	return s_spawn_loc;
}

/*
	Name: function_a716de1f
	Namespace: zm_ai_thrasher
	Checksum: 0x8886D955
	Offset: 0x2080
	Size: 0x574
	Parameters: 0
	Flags: Linked
*/
function function_a716de1f()
{
	self.var_61f7b3a0 = 1;
	zombiehealth = level.zombie_health;
	if(!isdefined(zombiehealth))
	{
		zombiehealth = level.zombie_vars["zombie_health_start"];
	}
	if(level.round_number <= 50)
	{
		self.maxhealth = zombiehealth * 10;
	}
	else
	{
		if(level.round_number <= 70)
		{
			n_round = level.round_number;
			var_84e68afa = 10 - ((n_round - 50) * 0.35);
			self.maxhealth = int(zombiehealth * var_84e68afa);
		}
		else
		{
			self.maxhealth = zombiehealth * 3;
		}
	}
	if(!isdefined(self.maxhealth) || self.maxhealth <= 0 || self.maxhealth > 2147483647 || self.maxhealth != self.maxhealth)
	{
		self.maxhealth = zombiehealth;
	}
	self.health = self.maxhealth;
	self.thrasherragelevel = level.round_number;
	self.thrasherclosestvalidplayer = &zm_utility::get_closest_valid_player;
	self.thrasherconsumezombiecallback = &function_5185e56a;
	self.thrashercanconsumecallback = &function_7febcbb3;
	self.thrasherpustulepopcallback = &function_bf8a850e;
	self.thrashermovemodefriendlycallback = &function_70622dc9;
	self.nuke_damage_func = &function_7cec0046;
	self.thrashermeleehitcallback = &function_4912c054;
	self.thrasherteleportcallback = &function_565fed9e;
	self.thrashershouldteleportcallback = &function_eeeff8b3;
	self.thrashercanconsumeplayercallback = &function_7a8dca06;
	self.thrasherconsumedcallback = &function_fb5d97db;
	self.thrasherreleaseconsumedcallback = &function_bda057d1;
	self.thrasherstarttraversecallback = &function_a2c48487;
	self.thrasherterminatetraversecallback = &function_d95f74d1;
	self.thrasherattackableobjectcallback = &zm_behavior::zombieattackableobjectservice;
	self.riotshield_knockdown_func = &function_a7b4c742;
	self.riotshield_fling_func = &function_a7b4c742;
	self.tesla_damage_func = &function_bd6d26aa;
	self.thrasher_teleport_dest_func = &function_82522cfc;
	self zombie_utility::zombie_eye_glow_stop();
	self thread zm::update_zone_name();
	foreach(var_278bf215 in self.thrasherspores)
	{
		var_278bf215.health = zombiehealth * 2;
		if(!isdefined(var_278bf215.health) || var_278bf215.health <= 0 || var_278bf215.health > 2147483647 || var_278bf215.health != var_278bf215.health)
		{
			var_278bf215.health = zombiehealth;
		}
		var_278bf215.maxhealth = var_278bf215.health;
	}
	self.no_gib = 1;
	self.head_gibbed = 1;
	self.missinglegs = 0;
	self.b_ignore_cleanup = 1;
	self thread function_871a3bd5();
	self thread function_632dead();
	if(!isdefined(level.var_35a5aa88))
	{
		level.var_35a5aa88 = [];
	}
	else if(!isarray(level.var_35a5aa88))
	{
		level.var_35a5aa88 = array(level.var_35a5aa88);
	}
	level.var_35a5aa88[level.var_35a5aa88.size] = self;
	level.var_2f83d088++;
	level thread zm_spawner::zombie_death_event(self);
}

/*
	Name: function_bd6d26aa
	Namespace: zm_ai_thrasher
	Checksum: 0x6368FD94
	Offset: 0x2600
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function function_bd6d26aa(v_origin, player)
{
}

/*
	Name: function_cb4aac76
	Namespace: zm_ai_thrasher
	Checksum: 0x2D86C7B
	Offset: 0x2620
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function function_cb4aac76(zombie)
{
	if(isdefined(zombie) && isalive(zombie) && zombie isonground() && zombie.archetype == "zombie" && !zombie isplayinganimscripted() && zm_utility::check_point_in_playable_area(zombie.origin) && function_eeeff8b3(zombie.origin))
	{
		return true;
	}
	return false;
}

/*
	Name: function_82522cfc
	Namespace: zm_ai_thrasher
	Checksum: 0x2F9248F4
	Offset: 0x26E8
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function function_82522cfc(a_v_points)
{
	var_ba9cdbc3 = [];
	foreach(v_point in a_v_points)
	{
		if(zm_utility::check_point_in_enabled_zone(v_point, 1) && function_eeeff8b3(v_point))
		{
			if(!isdefined(var_ba9cdbc3))
			{
				var_ba9cdbc3 = [];
			}
			else if(!isarray(var_ba9cdbc3))
			{
				var_ba9cdbc3 = array(var_ba9cdbc3);
			}
			var_ba9cdbc3[var_ba9cdbc3.size] = v_point;
		}
	}
	return var_ba9cdbc3;
}

/*
	Name: function_7cec0046
	Namespace: zm_ai_thrasher
	Checksum: 0xDA3FE283
	Offset: 0x2810
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_7cec0046()
{
	if(!zm_utility::is_magic_bullet_shield_enabled(self))
	{
		self dodamage(self.health / 2, self.origin);
		thrasherserverutils::thrashergoberserk(self);
	}
}

/*
	Name: function_a7b4c742
	Namespace: zm_ai_thrasher
	Checksum: 0x171C61A0
	Offset: 0x2878
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function function_a7b4c742(player, gib)
{
	if(!zm_utility::is_magic_bullet_shield_enabled(self))
	{
		self dodamage(10, player.origin, player, player, "head", "MOD_IMPACT");
		self dodamage(3000, player.origin, player, player);
	}
}

/*
	Name: function_74b91821
	Namespace: zm_ai_thrasher
	Checksum: 0xC4C9C89F
	Offset: 0x2920
	Size: 0x332
	Parameters: 1
	Flags: Linked
*/
function function_74b91821(entity)
{
	var_6a9eb5b0 = zombie_utility::get_zombie_array();
	var_e38f15ea = arraysortclosest(var_6a9eb5b0, entity.origin, 5, 50, 96);
	foreach(zombie in var_e38f15ea)
	{
		if(!isdefined(zombie) || (isdefined(zombie.knockdown) && zombie.knockdown) || (isdefined(zombie.var_3f6ea790) && zombie.var_3f6ea790) || (isdefined(zombie.missinglegs) && zombie.missinglegs) || (isdefined(zombie.thrasherconsumed) && zombie.thrasherconsumed) || zombie isragdoll())
		{
			continue;
		}
		if((abs(zombie.origin[2] - entity.origin[2])) > 18)
		{
			continue;
		}
		forward = anglestoforward(entity.angles);
		forward = (forward[0], forward[1], 0);
		forward = vectornormalize(forward);
		var_537120b8 = zombie.origin - entity.origin;
		var_537120b8 = (var_537120b8[0], var_537120b8[1], 0);
		var_537120b8 = vectornormalize(var_537120b8);
		if(isalive(zombie) && zombie.archetype == "zombie" && zombie !== entity && !zombie isplayinganimscripted() && vectordot(forward, var_537120b8) >= 0.9063 && zm_utility::check_point_in_playable_area(zombie.origin))
		{
			return zombie;
		}
	}
}

/*
	Name: function_7febcbb3
	Namespace: zm_ai_thrasher
	Checksum: 0xB9A31009
	Offset: 0x2C60
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_7febcbb3(entity)
{
	if(isdefined(entity.thrasherconsumedplayer) && entity.thrasherconsumedplayer)
	{
		return 0;
	}
	return isdefined(function_74b91821(entity));
}

/*
	Name: function_7dfa2cf1
	Namespace: zm_ai_thrasher
	Checksum: 0xA4BC204A
	Offset: 0x2CB8
	Size: 0x1AC
	Parameters: 2
	Flags: Linked
*/
function function_7dfa2cf1(entity, zombie)
{
	zombie.allowdeath = 0;
	zombie.b_ignore_cleanup = 1;
	zombie.thrasherconsumed = 1;
	var_d30f1cde = anglestoforward(zombie.angles);
	entityforward = anglestoforward(entity.angles);
	if(vectordot(var_d30f1cde, entityforward) > 0)
	{
		entity thread scene::play("scene_zm_dlc2_thrasher_eat_f_zombie", array(entity, zombie));
	}
	else
	{
		entity thread scene::play("scene_zm_dlc2_thrasher_eat_b_zombie", array(entity, zombie));
	}
	zombie util::waittill_notify_or_timeout("hide_zombie", 5);
	if(isdefined(zombie))
	{
		zombie.allowdeath = 1;
		zombie hide();
		zombie kill();
		entity thrasherserverutils::thrasherrestorepustule(entity);
	}
}

/*
	Name: function_5185e56a
	Namespace: zm_ai_thrasher
	Checksum: 0x8A6896F6
	Offset: 0x2E70
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_5185e56a(entity)
{
	var_650c1f8b = function_74b91821(entity);
	if(isdefined(var_650c1f8b))
	{
		entity thread function_7dfa2cf1(entity, var_650c1f8b);
		return true;
	}
	return false;
}

/*
	Name: function_d2ac7b69
	Namespace: zm_ai_thrasher
	Checksum: 0x87622972
	Offset: 0x2EE0
	Size: 0xD4
	Parameters: 3
	Flags: Linked
*/
function function_d2ac7b69(entity, player, state)
{
	if(isdefined(entity) && isdefined(player))
	{
		entitynumber = player getentitynumber();
		var_4b5ca201 = entity clientfield::get("thrasher_mouth_cf");
		var_4b5ca201 = var_4b5ca201 & (~(3 << (entitynumber * 2)));
		var_4b5ca201 = var_4b5ca201 | (state << (entitynumber * 2));
		entity clientfield::set("thrasher_mouth_cf", var_4b5ca201);
	}
}

/*
	Name: function_a2c48487
	Namespace: zm_ai_thrasher
	Checksum: 0x6C37455
	Offset: 0x2FC0
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_a2c48487(entity)
{
	function_d2ac7b69(entity, entity.thrasherplayer, 3);
}

/*
	Name: function_d95f74d1
	Namespace: zm_ai_thrasher
	Checksum: 0x38EE31F1
	Offset: 0x3000
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_d95f74d1(entity)
{
	function_d2ac7b69(entity, entity.thrasherplayer, 2);
}

/*
	Name: function_fb5d97db
	Namespace: zm_ai_thrasher
	Checksum: 0xDDD3EEE6
	Offset: 0x3040
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function function_fb5d97db(entity, player)
{
	function_d2ac7b69(entity, player, 2);
}

/*
	Name: function_bda057d1
	Namespace: zm_ai_thrasher
	Checksum: 0xBFF37645
	Offset: 0x3080
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function function_bda057d1(entity, player)
{
	function_d2ac7b69(entity, player, 0);
}

/*
	Name: function_7a8dca06
	Namespace: zm_ai_thrasher
	Checksum: 0x588DA4AC
	Offset: 0x30C0
	Size: 0x36
	Parameters: 1
	Flags: Linked
*/
function function_7a8dca06(entity)
{
	if(!zm_utility::check_point_in_playable_area(entity.origin))
	{
		return false;
	}
	return true;
}

/*
	Name: function_4912c054
	Namespace: zm_ai_thrasher
	Checksum: 0xD5F32CC
	Offset: 0x3100
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function function_4912c054(hitentity)
{
	entity = self;
	if(isdefined(hitentity) && isactor(hitentity) && entity.team == "allies")
	{
		hitentity clientfield::increment("zm_nuked");
		hitentity kill();
	}
}

/*
	Name: function_565fed9e
	Namespace: zm_ai_thrasher
	Checksum: 0xECB02358
	Offset: 0x3198
	Size: 0x29C
	Parameters: 1
	Flags: Linked
*/
function function_565fed9e(entity)
{
	entity endon(#"death");
	if(isdefined(entity) && isalive(entity))
	{
		entity.bgbignorefearinheadlights = 1;
		function_d2ac7b69(entity, entity.thrasherplayer, 3);
		if(isdefined(entity.thrasherplayer))
		{
			entity.thrasherplayer thread lui::screen_fade_out(1.5);
		}
		var_f40f14b3 = util::spawn_model("tag_origin", entity.origin, entity.angles);
		var_f40f14b3 thread scene::play("scene_zm_dlc2_thrasher_teleport_out", entity);
		entity util::waittill_notify_or_timeout("hide_ai", 4);
		entity hide();
	}
	if(isdefined(entity) && isalive(entity))
	{
		thrasherserverutils::thrasherteleport(entity);
		var_f40f14b3 = util::spawn_model("tag_origin", entity.origin, entity.angles);
		var_f40f14b3 thread scene::play("scene_zm_dlc2_thrasher_teleport_in_v1", entity);
		entity util::waittill_notify_or_timeout("show_ai", 4);
		entity show();
		entity util::waittill_notify_or_timeout("show_player", 4);
		function_d2ac7b69(entity, entity.thrasherplayer, 2);
		if(isdefined(entity.thrasherplayer))
		{
			entity.thrasherplayer thread lui::screen_fade_in(2);
		}
		entity.bgbignorefearinheadlights = 0;
	}
}

/*
	Name: function_70622dc9
	Namespace: zm_ai_thrasher
	Checksum: 0xAE82088B
	Offset: 0x3440
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_70622dc9()
{
	zm_behavior::findzombieenemy();
	if(!isdefined(self.favoriteenemy) && isdefined(self.owner))
	{
		if(isdefined(self.owner))
		{
			queryresult = positionquery_source_navigation(self.owner.origin, 128, 256, 128, 20);
			if(isdefined(queryresult) && queryresult.data.size > 0)
			{
				self setgoal(queryresult.data[0].origin);
			}
		}
	}
}

/*
	Name: function_871a3bd5
	Namespace: zm_ai_thrasher
	Checksum: 0xFBCFDDDB
	Offset: 0x3518
	Size: 0x170
	Parameters: 0
	Flags: Linked
*/
function function_871a3bd5()
{
	self waittill(#"death", e_attacker);
	arrayremovevalue(level.var_35a5aa88, self);
	if(isplayer(e_attacker))
	{
		if(!(isdefined(self.deathpoints_already_given) && self.deathpoints_already_given))
		{
			e_attacker zm_score::player_add_points("death_thrasher", self.damagemod, self.damagelocation, 1);
		}
		if(isdefined(level.hero_power_update))
		{
			[[level.hero_power_update]](e_attacker, self);
		}
		if(randomintrange(0, 100) >= 80)
		{
			e_attacker zm_audio::create_and_play_dialog("kill", "thrashers");
		}
		e_attacker zm_stats::increment_client_stat("zthrashers_killed");
		e_attacker zm_stats::increment_player_stat("zthrashers_killed");
	}
	if(isdefined(e_attacker) && isai(e_attacker))
	{
		e_attacker notify(#"killed", self);
	}
}

/*
	Name: function_632dead
	Namespace: zm_ai_thrasher
	Checksum: 0xF6ED57DB
	Offset: 0x3690
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_632dead()
{
	self endon(#"death");
	self playloopsound("zmb_thrasher_lp_close", 2);
	wait(randomintrange(2, 5));
	while(true)
	{
		self playsoundontag("zmb_vocals_thrash_ambient", "j_head");
		level notify(#"hash_9b1446c2", self);
		wait(randomintrange(3, 9));
	}
}

/*
	Name: function_eeeff8b3
	Namespace: zm_ai_thrasher
	Checksum: 0x4917826C
	Offset: 0x3738
	Size: 0xD8
	Parameters: 1
	Flags: Linked
*/
function function_eeeff8b3(origin)
{
	no_teleport_area = getentarray("no_teleport_area", "script_noteworthy");
	if(!isdefined(level.check_model))
	{
		level.check_model = spawn("script_model", origin);
	}
	else
	{
		level.check_model.origin = origin;
	}
	for(i = 0; i < no_teleport_area.size; i++)
	{
		if(level.check_model istouching(no_teleport_area[i]))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_ae069b1c
	Namespace: zm_ai_thrasher
	Checksum: 0x12EE92D5
	Offset: 0x3818
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_ae069b1c()
{
	/#
		level flagsys::wait_till("");
		zm_devgui::add_custom_devgui_callback(&function_da954e93);
	#/
}

/*
	Name: function_11d343a5
	Namespace: zm_ai_thrasher
	Checksum: 0xEAADC62F
	Offset: 0x3868
	Size: 0x1F6
	Parameters: 1
	Flags: Linked
*/
function function_11d343a5(thrasher)
{
	/#
		thrasher notify(#"hash_eafe225a");
		thrasher endon(#"hash_eafe225a");
		thrasher endon(#"death");
		thrasher.ignoreall = 1;
		while(true)
		{
			queryresult = positionquery_source_navigation(thrasher.origin, 1024, 2024, 128, 20, thrasher);
			var_46b60716 = thrasher.origin;
			var_f749ad3e = 0;
			pointlist = queryresult.data;
			foreach(point in pointlist)
			{
				var_5bc0390c = distancesquared(point.origin, thrasher.origin);
				if(var_5bc0390c > var_f749ad3e && zm_utility::check_point_in_playable_area(point.origin))
				{
					var_f749ad3e = var_5bc0390c;
					var_46b60716 = point.origin;
				}
			}
			thrasher setgoal(var_46b60716);
			thrasher waittill(#"goal");
		}
	#/
}

/*
	Name: function_eafe225a
	Namespace: zm_ai_thrasher
	Checksum: 0x9A71B758
	Offset: 0x3A68
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function function_eafe225a(thrasher)
{
	/#
		thrasher.ignoreall = 0;
		thrasher notify(#"hash_eafe225a");
	#/
}

/*
	Name: function_13a79919
	Namespace: zm_ai_thrasher
	Checksum: 0xD9467036
	Offset: 0x3AA0
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_13a79919()
{
	/#
		thrashers = getaiarchetypearray("");
		players = getplayers();
		if(players.size > 0 && thrashers.size > 0)
		{
			thrasher = arraygetclosest(players[0].origin, thrashers);
			if(isdefined(thrasher) && zm_utility::check_point_in_playable_area(thrasher.origin))
			{
				return thrasher;
			}
		}
	#/
}

/*
	Name: function_da954e93
	Namespace: zm_ai_thrasher
	Checksum: 0x1F22FFA2
	Offset: 0x3B80
	Size: 0x726
	Parameters: 1
	Flags: Linked
*/
function function_da954e93(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				players = getplayers();
				queryresult = positionquery_source_navigation(players[0].origin, 128, 256, 128, 20);
				spot = spawnstruct();
				spot.origin = players[0].origin;
				if(isdefined(queryresult) && queryresult.data.size > 0)
				{
					spot.origin = queryresult.data[0].origin;
				}
				thrasher = zombie_utility::spawn_zombie(level.var_feebf312[0], "", spot);
				if(isdefined(thrasher))
				{
					e_player = zm_utility::get_closest_player(spot.origin);
					v_dir = e_player.origin - spot.origin;
					v_dir = vectornormalize(v_dir);
					v_angles = vectortoangles(v_dir);
					trace = bullettrace(spot.origin, spot.origin + (vectorscale((0, 0, -1), 256)), 0, spot);
					v_ground_position = trace[""];
					var_a6621bfd = v_ground_position;
					thrasher forceteleport(var_a6621bfd, v_angles);
				}
				break;
			}
			case "":
			{
				var_5613e8c5 = getaiarchetypearray("");
				if(var_5613e8c5.size > 0)
				{
					foreach(thrasher in var_5613e8c5)
					{
						thrasher kill();
					}
				}
				break;
			}
			case "":
			case "":
			{
				zombies = getaiarchetypearray("");
				players = getplayers();
				if(players.size > 0 && zombies.size > 0)
				{
					zombie = arraygetclosest(players[0].origin, zombies);
					if(function_cb4aac76(zombie))
					{
						function_8b323113(zombie, 0, 0, cmd == "");
					}
					else
					{
						/#
							iprintln("");
						#/
					}
				}
				else
				{
					/#
						iprintln("");
					#/
				}
				break;
			}
			case "":
			{
				thrasher = function_13a79919();
				if(isdefined(thrasher))
				{
					thrasherserverutils::thrashergoberserk(thrasher);
				}
				break;
			}
			case "":
			{
				thrasher = function_13a79919();
				if(isdefined(thrasher))
				{
					thrasher ai::set_behavior_attribute("", "");
					players = getplayers();
					if(players.size > 0)
					{
						thrasher.owner = players[0];
					}
				}
				break;
			}
			case "":
			{
				thrasher = function_13a79919();
				players = getplayers();
				if(isdefined(thrasher))
				{
					thrasher thread thrasherserverutils::thrasherconsumeplayerutil(thrasher, players[0]);
				}
				break;
			}
			case "":
			{
				var_5613e8c5 = getaiarchetypearray("");
				if(var_5613e8c5.size > 0)
				{
					foreach(thrasher in var_5613e8c5)
					{
						thrasher thread function_11d343a5(thrasher);
					}
				}
				break;
			}
			case "":
			{
				var_5613e8c5 = getaiarchetypearray("");
				if(var_5613e8c5.size > 0)
				{
					foreach(thrasher in var_5613e8c5)
					{
						function_eafe225a(thrasher);
					}
				}
				break;
			}
			case "":
			{
				spawn_thrasher(0);
				break;
			}
		}
	#/
}

