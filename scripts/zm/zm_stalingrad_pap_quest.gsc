// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_raz;
#using scripts\zm\_zm_ai_sentinel_drone;
#using scripts\zm\_zm_attackables;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_stalingrad_drop_pods;
#using scripts\zm\zm_stalingrad_util;
#using scripts\zm\zm_stalingrad_vo;

#using_animtree("generic");

#namespace zm_stalingrad_pap;

/*
	Name: __init__sytem__
	Namespace: zm_stalingrad_pap
	Checksum: 0x7FC287E3
	Offset: 0xB80
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_pap", &__init__, undefined, undefined);
}

/*
	Name: function_5efc91a4
	Namespace: zm_stalingrad_pap
	Checksum: 0xD8635F62
	Offset: 0xBC0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_5efc91a4()
{
	/#
		level waittill(#"open_sesame");
		level flag::set("");
	#/
}

/*
	Name: __init__
	Namespace: zm_stalingrad_pap
	Checksum: 0xC487C8D9
	Offset: 0xC00
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("world", "lockdown_lights_west", 12000, 1, "int");
	clientfield::register("world", "lockdown_lights_north", 12000, 1, "int");
	clientfield::register("world", "lockdown_lights_east", 12000, 1, "int");
}

/*
	Name: function_2fcaffe2
	Namespace: zm_stalingrad_pap
	Checksum: 0x7B30326C
	Offset: 0xCA0
	Size: 0x102
	Parameters: 0
	Flags: Linked
*/
function function_2fcaffe2()
{
	level flag::init("drop_pod_active");
	level flag::init("drop_pod_spawned");
	level flag::init("drop_pod_init_done");
	level flag::init("dragon_strike_quest_complete");
	level flag::init("lockdown_complete");
	level flag::init("lockdown_active");
	level thread namespace_2e6e7fce::function_2bb254bb();
	level thread function_2b0bc12();
	level notify(#"pack_a_punch_on");
}

/*
	Name: function_809fbbff
	Namespace: zm_stalingrad_pap
	Checksum: 0x5EB9A540
	Offset: 0xDB0
	Size: 0x15C
	Parameters: 1
	Flags: Linked
*/
function function_809fbbff(var_db0ac3dc)
{
	if(level flag::get("drop_pod_active") || level flag::get("drop_pod_spawned"))
	{
		return;
	}
	level zm_stalingrad_vo::function_3a92f7f();
	if(level.var_583e4a97.var_365bcb3c == 0)
	{
		var_1196aeee = function_23b93c79(var_db0ac3dc);
	}
	else
	{
		level.var_583e4a97.var_5d8406ed["fountain1"].b_available = 1;
		var_1196aeee = function_a0a37968(var_db0ac3dc);
	}
	var_e7a36389 = array::random(var_1196aeee);
	level.var_8cc024f2 = var_e7a36389;
	/#
		println("" + var_e7a36389.script_string);
	#/
	level thread namespace_2e6e7fce::function_d1a91c4f(var_e7a36389);
}

/*
	Name: function_d32eac7f
	Namespace: zm_stalingrad_pap
	Checksum: 0x16CD08C6
	Offset: 0xF18
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function function_d32eac7f()
{
	switch(level.var_583e4a97.var_365bcb3c)
	{
		case 0:
		{
			return "part_transmitter";
			break;
		}
		case 1:
		{
			return "part_codes";
			break;
		}
		case 2:
		{
			return "part_map";
		}
		default:
		{
			/#
				assert(level.var_583e4a97.var_365bcb3c > 2, "");
			#/
		}
	}
}

/*
	Name: function_23b93c79
	Namespace: zm_stalingrad_pap
	Checksum: 0x377D067D
	Offset: 0xFC0
	Size: 0x13E
	Parameters: 1
	Flags: Linked
*/
function function_23b93c79(var_db0ac3dc)
{
	var_8aa74c19 = [];
	foreach(s_location in level.var_583e4a97.var_5d8406ed)
	{
		str_location = (s_location.script_string + "") + s_location.script_int;
		if(s_location.b_available)
		{
			if(!(isdefined(var_db0ac3dc == "judicial" && str_location == "judicial3") && var_db0ac3dc == "judicial" && str_location == "judicial3"))
			{
				array::add(var_8aa74c19, s_location);
			}
		}
	}
	return var_8aa74c19;
}

/*
	Name: function_a0a37968
	Namespace: zm_stalingrad_pap
	Checksum: 0xE3D3297A
	Offset: 0x1108
	Size: 0xDE
	Parameters: 1
	Flags: Linked
*/
function function_a0a37968(var_db0ac3dc)
{
	var_8aa74c19 = [];
	foreach(s_location in level.var_583e4a97.var_5d8406ed)
	{
		if(s_location.script_string != var_db0ac3dc && s_location.b_available == 1)
		{
			array::add(var_8aa74c19, s_location);
		}
	}
	return var_8aa74c19;
}

/*
	Name: transport_pavlovs_to_fountain
	Namespace: zm_stalingrad_pap
	Checksum: 0xD6C1ED2B
	Offset: 0x11F0
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function transport_pavlovs_to_fountain()
{
	var_63979061 = getent("transport_pavlovs_to_fountain", "targetname");
	while(true)
	{
		var_63979061 waittill(#"trigger", e_who);
		if(!(isdefined(e_who.var_a0a9409e) && e_who.var_a0a9409e))
		{
			e_who.var_a0a9409e = 1;
			e_who thread function_f3cc536();
		}
	}
}

/*
	Name: function_f3cc536
	Namespace: zm_stalingrad_pap
	Checksum: 0x67DF15B
	Offset: 0x1298
	Size: 0x186
	Parameters: 0
	Flags: Linked
*/
function function_f3cc536()
{
	var_47ee7db6 = getent("veh_sewer_cam", "targetname");
	nd_path_start = getvehiclenode("sewer_ride_start", "targetname");
	var_f08b56c6 = getvehiclenode("sewer_ride_exit_start", "targetname");
	self notify(#"hash_4cea57aa");
	self thread zm_stalingrad_util::function_ab2df0ca();
	zm_stalingrad_util::function_5eeabbe0(var_47ee7db6, nd_path_start, var_f08b56c6, "player_exited_sewer");
	var_b8fe8638 = struct::get_array("drop_pod_radio", "targetname");
	foreach(s_radio in var_b8fe8638)
	{
		s_radio.b_used = 0;
	}
}

/*
	Name: function_2b0bc12
	Namespace: zm_stalingrad_pap
	Checksum: 0x463D6CA3
	Offset: 0x1428
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_2b0bc12()
{
	function_d6ced80(0);
	function_f10ea3a8();
	var_2b71b5b4 = 4 + level.players.size;
	var_af22dd13 = 2 + level.players.size;
	level function_6236d848(14, 8, 16, 9, 18, 10, var_2b71b5b4, level.players.size + 1, 1, var_af22dd13, level.players.size + 1, 2, "dragon_pavlov_first_time", "dragon_strike_unlocked");
	level flag::set("dragon_strike_quest_complete");
}

/*
	Name: function_6236d848
	Namespace: zm_stalingrad_pap
	Checksum: 0xA663A110
	Offset: 0x1530
	Size: 0x160C
	Parameters: 16
	Flags: Linked
*/
function function_6236d848(var_e57afa84, var_7741a4b8, var_ed686791, var_2a448c91, var_16b2096, var_adb8dbea, var_2b71b5b4, var_15eb9a52, var_f92c3865, var_af22dd13, var_ed448d3b, var_e25e1ccc, str_flag1, str_flag2, str_notify_end, var_54939bf3 = 0)
{
	if(isdefined(var_2b71b5b4))
	{
		/#
			assert(isdefined(var_15eb9a52), "");
		#/
		/#
			assert(isdefined(var_f92c3865), "");
		#/
	}
	if(isdefined(var_af22dd13))
	{
		/#
			assert(isdefined(var_ed448d3b), "");
		#/
		/#
			assert(isdefined(var_e25e1ccc), "");
		#/
	}
	if(isdefined(var_54939bf3) && var_54939bf3)
	{
		/#
			assert(isdefined(str_notify_end), "");
		#/
	}
	if(isdefined(var_e57afa84))
	{
		/#
			assert(isdefined(var_7741a4b8), "");
		#/
		/#
			assert(isdefined(var_ed686791), "");
		#/
		/#
			assert(isdefined(var_2a448c91), "");
		#/
		/#
			assert(isdefined(var_16b2096), "");
		#/
		/#
			assert(isdefined(var_adb8dbea), "");
		#/
	}
	else
	{
		var_639b5936 = isdefined(var_2b71b5b4) || isdefined(var_af22dd13);
		/#
			assert(var_639b5936, "");
		#/
	}
	level.var_1dfcc9b2 = spawnstruct();
	if(isdefined(str_flag1))
	{
		a_flags = [];
		if(!isdefined(a_flags))
		{
			a_flags = [];
		}
		else if(!isarray(a_flags))
		{
			a_flags = array(a_flags);
		}
		a_flags[a_flags.size] = str_flag1;
		if(isdefined(str_flag2))
		{
			if(!isdefined(a_flags))
			{
				a_flags = [];
			}
			else if(!isarray(a_flags))
			{
				a_flags = array(a_flags);
			}
			a_flags[a_flags.size] = str_flag2;
		}
		level flag::wait_till_all(a_flags);
	}
	if(isdefined(str_notify_end))
	{
		if(!level flag::exists(str_notify_end))
		{
			level flag::init(str_notify_end);
		}
	}
	else
	{
		level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_controller_quest_lockdown_start_0");
	}
	level thread zm_stalingrad_util::function_e7c75cf0();
	level flag::clear("zombie_drop_powerups");
	zm_spawner::deregister_zombie_death_event_callback(&namespace_2e6e7fce::function_1389d425);
	level thread zm_stalingrad_util::function_3804dbf1();
	level zm_stalingrad_util::function_adf4d1d0();
	level flag::clear("lockdown_complete");
	level flag::set("lockdown_active");
	level util::clientnotify("sndPD");
	level function_451531f2();
	level.var_1dfcc9b2.var_9fa1b3e = [];
	var_8a56b631 = level.players.size;
	if(isdefined(var_e57afa84))
	{
		level.var_1dfcc9b2.var_9fa1b3e[0] = var_e57afa84 + (var_7741a4b8 * var_8a56b631);
		level.var_1dfcc9b2.var_9fa1b3e[1] = var_ed686791 + (var_2a448c91 * var_8a56b631);
		level.var_1dfcc9b2.var_9fa1b3e[2] = var_16b2096 + (var_adb8dbea * var_8a56b631);
	}
	level.var_1dfcc9b2.var_3eeb6c22[0] = 0;
	level.var_1dfcc9b2.var_3eeb6c22[1] = 1;
	level.var_1dfcc9b2.var_3eeb6c22[2] = 2;
	var_998322e5 = level.zombie_vars["zombie_spawn_delay"];
	if(var_998322e5 <= 0.1)
	{
		var_998322e5 = 0.1;
	}
	if(!isdefined(level.var_1dfcc9b2.var_4560ec9a))
	{
		level.var_1dfcc9b2.var_4560ec9a = [];
		level.var_1dfcc9b2.var_4560ec9a[0] = struct::get_array("lockdown_raz_spawner_east", "targetname");
		level.var_1dfcc9b2.var_4560ec9a[1] = struct::get_array("lockdown_raz_spawner_north", "targetname");
		level.var_1dfcc9b2.var_4560ec9a[2] = struct::get_array("lockdown_raz_spawner_west", "targetname");
	}
	level.var_1dfcc9b2.var_3eeb6c22 = array::randomize(level.var_1dfcc9b2.var_3eeb6c22);
	function_188bdb42();
	function_d6ced80(1);
	level thread zm_stalingrad_util::function_2f621485();
	exploder::exploder("pavlov_" + 0);
	exploder::exploder("pavlov_" + 4);
	wait(2.5);
	var_d98b610d = level.zombie_spawners[0];
	var_ddb16ab3 = struct::get("lockdown_ammo_lower", "targetname");
	var_93eb638b = zm_powerups::specific_powerup_drop("full_ammo", var_ddb16ab3.origin + vectorscale((0, 0, 1), 48));
	var_93eb638b notify(#"powerup_reset");
	do
	{
		for(i = 0; i < 3; i++)
		{
			if(isdefined(str_notify_end) && level flag::get(str_notify_end))
			{
				level flag::clear("wave_event_raz_spawning_active");
			}
			else
			{
				var_879a13d6 = [];
				level.var_1dfcc9b2.var_22bf30b7 = level.var_1dfcc9b2.var_3eeb6c22[i];
				switch(level.var_1dfcc9b2.var_22bf30b7)
				{
					case 2:
					{
						var_879a13d6 = arraycopy(level.var_1dfcc9b2.var_1865827a);
						break;
					}
					case 1:
					{
						var_879a13d6 = arraycopy(level.var_1dfcc9b2.var_3ec9c2c0);
						break;
					}
					case 0:
					{
						var_879a13d6 = arraycopy(level.var_1dfcc9b2.var_6c74b6c8);
						break;
					}
				}
			}
			level thread function_f4ceb3f8();
			level function_3d5f2c8e(level.var_1dfcc9b2.var_22bf30b7);
			if(i > 0)
			{
				level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_controller_quest_wave_start_2");
			}
			var_939defa4 = [];
			if(isdefined(var_e57afa84))
			{
				if(isdefined(var_2b71b5b4))
				{
					var_b4fcee85 = int((level.var_1dfcc9b2.var_9fa1b3e[i] / var_2b71b5b4) / 2);
					if(!isdefined(var_939defa4))
					{
						var_939defa4 = [];
					}
					else if(!isarray(var_939defa4))
					{
						var_939defa4 = array(var_939defa4);
					}
					var_939defa4[var_939defa4.size] = "wave_event_raz_spawning_active";
					level thread zm_stalingrad_util::function_b55ebb81(level.var_1dfcc9b2.var_4560ec9a[level.var_1dfcc9b2.var_22bf30b7], var_2b71b5b4, var_15eb9a52, var_f92c3865, var_b4fcee85, str_notify_end);
				}
				level zm_stalingrad_util::function_f70dde0b(var_d98b610d, var_879a13d6, "lockdown_zombie", 22, var_998322e5, level.var_1dfcc9b2.var_9fa1b3e[i], undefined, 0);
			}
			else if(isdefined(var_2b71b5b4))
			{
				if(!isdefined(var_939defa4))
				{
					var_939defa4 = [];
				}
				else if(!isarray(var_939defa4))
				{
					var_939defa4 = array(var_939defa4);
				}
				var_939defa4[var_939defa4.size] = "wave_event_raz_spawning_active";
				level zm_stalingrad_util::function_b55ebb81(level.var_1dfcc9b2.var_4560ec9a[level.var_1dfcc9b2.var_22bf30b7], var_2b71b5b4, var_15eb9a52, var_f92c3865, undefined);
			}
			if(var_939defa4.size > 0)
			{
				level flag::wait_till_clear_all(var_939defa4);
			}
			var_998322e5 = var_998322e5 - (0.1 * var_8a56b631);
			if(var_998322e5 < 0.1)
			{
				var_998322e5 = 0.1;
			}
			var_f92c3865 = var_f92c3865 - (0.1 * var_8a56b631);
			if(var_f92c3865 < 0.1)
			{
				var_f92c3865 = 0.1;
			}
			wait(0.5);
			function_187a933f(level.var_1dfcc9b2.var_22bf30b7);
			exploder::exploder("pavlov_" + 4);
			level notify(#"hash_d2eac5fe");
			level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_controller_quest_wave_end_1");
			wait(2.5);
			if(isdefined(str_notify_end) && level flag::get(str_notify_end))
			{
				break;
			}
		}
		if(!isdefined(str_notify_end) || !level flag::get(str_notify_end))
		{
			var_965b4c33 = arraycopy(level.var_1dfcc9b2.var_1865827a);
			var_965b4c33 = arraycombine(var_965b4c33, level.var_1dfcc9b2.var_3ec9c2c0, 0, 0);
			var_965b4c33 = arraycombine(var_965b4c33, level.var_1dfcc9b2.var_6c74b6c8, 0, 0);
			var_4a86a85 = arraycopy(level.var_1dfcc9b2.var_4560ec9a[0]);
			var_4a86a85 = arraycombine(var_4a86a85, level.var_1dfcc9b2.var_4560ec9a[1], 0, 0);
			var_4a86a85 = arraycombine(var_4a86a85, level.var_1dfcc9b2.var_4560ec9a[2], 0, 0);
			var_b4fcee85 = 3;
			level thread function_f4ceb3f8();
			for(i = 0; i < 3; i++)
			{
				switch(i)
				{
					case 0:
					{
						var_a48df19e = "east";
						break;
					}
					case 1:
					{
						var_a48df19e = "north";
						break;
					}
					case 2:
					{
						var_a48df19e = "west";
						break;
					}
				}
				var_98782f9e = struct::get("lockdown_shutter_explosion_" + var_a48df19e, "targetname");
				level thread function_1a7c9b89(var_a48df19e);
				playrumbleonposition("zm_stalingrad_lockdown_shutter_destroyed", var_98782f9e.origin);
				util::wait_network_frame();
			}
			function_f10ea3a8();
			exploder::exploder_stop("pavlov_" + 0);
			exploder::exploder_stop("pavlov_" + 4);
			util::wait_network_frame();
			level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_controller_quest_wave_start_2");
			var_939defa4 = [];
			if(isdefined(var_e57afa84))
			{
				if(isdefined(var_2b71b5b4))
				{
					if(!isdefined(var_939defa4))
					{
						var_939defa4 = [];
					}
					else if(!isarray(var_939defa4))
					{
						var_939defa4 = array(var_939defa4);
					}
					var_939defa4[var_939defa4.size] = "wave_event_raz_spawning_active";
					level thread zm_stalingrad_util::function_b55ebb81(var_4a86a85, var_2b71b5b4, var_15eb9a52, var_f92c3865, var_b4fcee85, str_notify_end);
					util::wait_network_frame();
				}
				if(isdefined(var_af22dd13))
				{
					if(!isdefined(var_939defa4))
					{
						var_939defa4 = [];
					}
					else if(!isarray(var_939defa4))
					{
						var_939defa4 = array(var_939defa4);
					}
					var_939defa4[var_939defa4.size] = "wave_event_sentinel_spawning_active";
					level thread zm_stalingrad_util::function_923f7f72(var_af22dd13, var_ed448d3b, var_e25e1ccc, undefined);
					util::wait_network_frame();
				}
				n_max_zombies = var_16b2096 + ((var_adb8dbea * var_8a56b631) * 2);
				level zm_stalingrad_util::function_f70dde0b(var_d98b610d, var_965b4c33, "lockdown_zombie", 22, var_998322e5, n_max_zombies, undefined, 0);
			}
			else if(isdefined(var_2b71b5b4))
			{
				if(isdefined(var_af22dd13))
				{
					if(!isdefined(var_939defa4))
					{
						var_939defa4 = [];
					}
					else if(!isarray(var_939defa4))
					{
						var_939defa4 = array(var_939defa4);
					}
					var_939defa4[var_939defa4.size] = "wave_event_sentinel_spawning_active";
					level thread zm_stalingrad_util::function_923f7f72(var_af22dd13, var_ed448d3b, var_e25e1ccc, undefined);
					util::wait_network_frame();
				}
				if(!isdefined(var_939defa4))
				{
					var_939defa4 = [];
				}
				else if(!isarray(var_939defa4))
				{
					var_939defa4 = array(var_939defa4);
				}
				var_939defa4[var_939defa4.size] = "wave_event_raz_spawning_active";
				level zm_stalingrad_util::function_b55ebb81(var_4a86a85, var_2b71b5b4, var_15eb9a52, var_f92c3865, undefined);
			}
			if(var_939defa4.size > 0)
			{
				level flag::wait_till_clear_all(var_939defa4);
			}
			function_188bdb42();
			exploder::exploder("pavlov_" + 4);
		}
		level notify(#"hash_d2eac5fe");
		if(isdefined(str_notify_end) && level flag::get(str_notify_end))
		{
			var_54939bf3 = 0;
		}
	}
	while(isdefined(var_54939bf3) && var_54939bf3);
	level.var_1dfcc9b2.var_61126827 = undefined;
	level.var_a3559c05 = undefined;
	level flag::clear("lockdown_active");
	foreach(player in level.activeplayers)
	{
		player zm_score::add_to_player_score(500, 1);
		player notify(#"hash_1d89afbc");
	}
	level zm_stalingrad_util::function_2f621485(0);
	function_d6ced80(0);
	wait(2.5);
	function_f10ea3a8();
	exploder::exploder_stop("pavlov_" + 0);
	exploder::exploder_stop("pavlov_" + 4);
	zm_spawner::register_zombie_death_event_callback(&namespace_2e6e7fce::function_1389d425);
	level flag::set("zombie_drop_powerups");
	level flag::set("lockdown_complete");
	level thread zm_stalingrad_util::function_3804dbf1(0);
	level util::clientnotify("sndPD");
	if(isdefined(str_notify_end))
	{
		level flag::clear(str_notify_end);
	}
	else
	{
		level thread zm_stalingrad_vo::function_d2ea8c30();
		playsoundatposition("mus_stalingrad_underscore_pavlov_defend_end", (0, 0, 0));
	}
	if(isdefined(var_93eb638b))
	{
		var_93eb638b thread zm_powerups::powerup_timeout();
	}
}

/*
	Name: function_a71517e1
	Namespace: zm_stalingrad_pap
	Checksum: 0xD2E79241
	Offset: 0x2B48
	Size: 0x194
	Parameters: 1
	Flags: Linked
*/
function function_a71517e1(var_256a0099)
{
	switch(var_256a0099)
	{
		case 0:
		{
			var_bf34b7c4 = getent("lockdown_shutter_1", "targetname");
			var_143e45c3 = "p7_fxanim_zm_stal_pavlov_lockdown_wall_01_reset_bundle";
			var_a48df19e = "east";
			break;
		}
		case 1:
		{
			var_bf34b7c4 = getent("lockdown_shutter_2", "targetname");
			var_143e45c3 = "p7_fxanim_zm_stal_pavlov_lockdown_wall_02_reset_bundle";
			var_a48df19e = "north";
			break;
		}
		case 2:
		{
			var_bf34b7c4 = getent("lockdown_shutter_3", "targetname");
			var_143e45c3 = "p7_fxanim_zm_stal_pavlov_lockdown_wall_03_reset_bundle";
			var_a48df19e = "west";
			break;
		}
	}
	var_3d086912 = getent("lockdown_transitionblocker_" + var_a48df19e, "targetname");
	var_3d086912 connectpaths();
	var_3d086912 movez(-1000, 0.1);
	var_bf34b7c4 thread scene::play(var_143e45c3, var_bf34b7c4);
}

/*
	Name: function_f10ea3a8
	Namespace: zm_stalingrad_pap
	Checksum: 0x3EF926C5
	Offset: 0x2CE8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_f10ea3a8()
{
	level thread function_a71517e1(2);
	util::wait_network_frame();
	level thread function_a71517e1(1);
	util::wait_network_frame();
	level thread function_a71517e1(0);
}

/*
	Name: function_187a933f
	Namespace: zm_stalingrad_pap
	Checksum: 0x70195486
	Offset: 0x2D60
	Size: 0x19C
	Parameters: 1
	Flags: Linked
*/
function function_187a933f(var_256a0099)
{
	switch(var_256a0099)
	{
		case 0:
		{
			var_bf34b7c4 = getent("lockdown_shutter_1", "targetname");
			var_f08953ca = "p7_fxanim_zm_stal_pavlov_lockdown_wall_01_lock_bundle";
			var_a48df19e = "east";
			break;
		}
		case 1:
		{
			var_bf34b7c4 = getent("lockdown_shutter_2", "targetname");
			var_f08953ca = "p7_fxanim_zm_stal_pavlov_lockdown_wall_02_lock_bundle";
			var_a48df19e = "north";
			break;
		}
		case 2:
		{
			var_bf34b7c4 = getent("lockdown_shutter_3", "targetname");
			var_f08953ca = "p7_fxanim_zm_stal_pavlov_lockdown_wall_03_lock_bundle";
			var_a48df19e = "west";
			break;
		}
	}
	var_3d086912 = getent("lockdown_transitionblocker_" + var_a48df19e, "targetname");
	var_3d086912 movez(1000, 0.1);
	var_3d086912 disconnectpaths();
	var_bf34b7c4 thread scene::play(var_f08953ca, var_bf34b7c4);
}

/*
	Name: function_188bdb42
	Namespace: zm_stalingrad_pap
	Checksum: 0x641EEBFF
	Offset: 0x2F08
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_188bdb42()
{
	level thread function_187a933f(2);
	util::wait_network_frame();
	level thread function_187a933f(1);
	util::wait_network_frame();
	level thread function_187a933f(0);
}

/*
	Name: function_d6ced80
	Namespace: zm_stalingrad_pap
	Checksum: 0x20BF5621
	Offset: 0x2F80
	Size: 0x762
	Parameters: 1
	Flags: Linked
*/
function function_d6ced80(b_locked)
{
	var_2bf0ed11 = getentarray("pavlov_gate_collision", "targetname");
	var_50e0150f = getentarray("pavlov_gate_visual", "targetname");
	var_b9e116c5 = getentarray("pavlov_hatch", "targetname");
	var_870c25a8 = getentarray("pavlov_hatch_collision", "targetname");
	a_e_collision = arraycombine(var_870c25a8, var_2bf0ed11, 0, 0);
	var_595e6429 = getnodearray("pavlovs_lockdown_floor_traverse", "targetname");
	var_6f3f4356 = getnodearray("pavlovs_lockdown_stair_traverse", "targetname");
	var_63b437d6 = 0;
	if(b_locked)
	{
		foreach(e_collision in a_e_collision)
		{
			e_collision solid();
			e_collision disconnectpaths();
			var_63b437d6 = function_77f195ef(var_63b437d6);
		}
		foreach(e_gate in var_50e0150f)
		{
			e_gate movez(600, 0.25);
			var_63b437d6 = function_77f195ef(var_63b437d6);
		}
		foreach(e_hatch in var_b9e116c5)
		{
			e_hatch rotateroll(-90, 1);
			var_63b437d6 = function_77f195ef(var_63b437d6);
		}
		foreach(var_b0a376a4 in var_595e6429)
		{
			unlinktraversal(var_b0a376a4);
		}
		foreach(var_b0a376a4 in var_6f3f4356)
		{
			unlinktraversal(var_b0a376a4);
		}
	}
	else
	{
		foreach(e_collision in a_e_collision)
		{
			e_collision connectpaths();
			e_collision notsolid();
			var_63b437d6 = function_77f195ef(var_63b437d6);
		}
		foreach(e_gate in var_50e0150f)
		{
			e_gate movez(-600, 0.25);
			var_63b437d6 = function_77f195ef(var_63b437d6);
		}
		foreach(e_hatch in var_b9e116c5)
		{
			e_hatch rotateroll(90, 1);
			var_63b437d6 = function_77f195ef(var_63b437d6);
		}
		foreach(var_b0a376a4 in var_595e6429)
		{
			linktraversal(var_b0a376a4);
		}
		foreach(var_b0a376a4 in var_6f3f4356)
		{
			linktraversal(var_b0a376a4);
		}
	}
}

/*
	Name: function_77f195ef
	Namespace: zm_stalingrad_pap
	Checksum: 0xF297254E
	Offset: 0x36F0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_77f195ef(var_63b437d6)
{
	var_63b437d6++;
	if(var_63b437d6 == 5)
	{
		util::wait_network_frame();
		return 0;
	}
	return var_63b437d6;
}

/*
	Name: function_451531f2
	Namespace: zm_stalingrad_pap
	Checksum: 0x26B3F93
	Offset: 0x3738
	Size: 0x3E4
	Parameters: 0
	Flags: Linked
*/
function function_451531f2()
{
	level.var_1dfcc9b2.var_1865827a = [];
	level.var_1dfcc9b2.var_3ec9c2c0 = [];
	level.var_1dfcc9b2.var_6c74b6c8 = [];
	var_8800d843 = getent("lockdown_western_front", "targetname");
	var_32f65c5d = getent("lockdown_eastern_front", "targetname");
	var_b9ebade5 = getent("lockdown_northern_front", "targetname");
	var_93a53b37 = struct::get_array("pavlovs_B_spawn", "targetname");
	foreach(s_spawner in var_93a53b37)
	{
		if(!isdefined(s_spawner.script_string) || s_spawner.script_noteworthy == "raz_location")
		{
			continue;
			continue;
		}
		if(s_spawner.script_string == "pavlov_4" || s_spawner.script_string == "pavlov_5")
		{
			array::add(level.var_1dfcc9b2.var_1865827a, s_spawner, 0);
			continue;
		}
		if(s_spawner.script_string == "pavlov_3" || s_spawner.script_string == "pavlov_6")
		{
			array::add(level.var_1dfcc9b2.var_3ec9c2c0, s_spawner, 0);
			continue;
		}
		if(s_spawner.script_string == "pavlov_2" || s_spawner.script_string == "pavlov_7")
		{
			array::add(level.var_1dfcc9b2.var_6c74b6c8, s_spawner, 0);
		}
	}
	var_93a53b37 = struct::get_array("pavlovs_lockdown_spawn_west", "targetname");
	level.var_1dfcc9b2.var_1865827a = arraycombine(level.var_1dfcc9b2.var_1865827a, var_93a53b37, 0, 0);
	var_93a53b37 = struct::get_array("pavlovs_lockdown_spawn_north", "targetname");
	level.var_1dfcc9b2.var_3ec9c2c0 = arraycombine(level.var_1dfcc9b2.var_3ec9c2c0, var_93a53b37, 0, 0);
	var_93a53b37 = struct::get_array("pavlovs_lockdown_spawn_east", "targetname");
	level.var_1dfcc9b2.var_6c74b6c8 = arraycombine(level.var_1dfcc9b2.var_6c74b6c8, var_93a53b37, 0, 0);
}

/*
	Name: function_3d5f2c8e
	Namespace: zm_stalingrad_pap
	Checksum: 0xE55E3EB1
	Offset: 0x3B28
	Size: 0x1A8
	Parameters: 1
	Flags: Linked
*/
function function_3d5f2c8e(var_256a0099)
{
	switch(var_256a0099)
	{
		case 0:
		{
			var_a48df19e = "east";
			break;
		}
		case 1:
		{
			var_a48df19e = "north";
			break;
		}
		case 2:
		{
			var_a48df19e = "west";
			break;
		}
	}
	var_98782f9e = struct::get("lockdown_shutter_explosion_" + var_a48df19e, "targetname");
	level thread function_1a7c9b89(var_a48df19e);
	wait(3);
	playrumbleonposition("zm_stalingrad_lockdown_shutter_destroyed", var_98782f9e.origin);
	function_a71517e1(var_256a0099);
	if(isdefined(level.var_1dfcc9b2.var_61126827))
	{
		exploder::exploder_stop("pavlov_" + level.var_1dfcc9b2.var_61126827);
	}
	exploder::exploder_stop("pavlov_" + 4);
	exploder::exploder("pavlov_" + (var_256a0099 + 1));
	level.var_1dfcc9b2.var_61126827 = var_256a0099 + 1;
}

/*
	Name: function_1a7c9b89
	Namespace: zm_stalingrad_pap
	Checksum: 0x8DFBB524
	Offset: 0x3CD8
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function function_1a7c9b89(var_a48df19e)
{
	var_604d90e0 = getentarray("lockdown_lights_" + var_a48df19e, "targetname");
	level clientfield::set("lockdown_lights_" + var_a48df19e, 1);
	level waittill(#"hash_d2eac5fe");
	level clientfield::set("lockdown_lights_" + var_a48df19e, 0);
}

/*
	Name: function_f4ceb3f8
	Namespace: zm_stalingrad_pap
	Checksum: 0x90FF7B7D
	Offset: 0x3D78
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function function_f4ceb3f8()
{
	var_fa54dca5 = gettime() / 1000;
	n_time_elapsed = 0;
	while(n_time_elapsed <= 3)
	{
		n_time_current = gettime() / 1000;
		n_time_elapsed = n_time_current - var_fa54dca5;
		playsoundatposition("evt_lockdown_alarm", (-159, 1959, 793));
		wait(1 - 0.1);
	}
}

/*
	Name: function_2c6fd7
	Namespace: zm_stalingrad_pap
	Checksum: 0xB4EDC6A9
	Offset: 0x3E28
	Size: 0xC24
	Parameters: 4
	Flags: Linked
*/
function function_2c6fd7(var_2b71b5b4, var_15eb9a52, var_f92c3865, var_13d1e831)
{
	function_d6ced80(1);
	level.var_1dfcc9b2 = spawnstruct();
	level thread zm_stalingrad_util::function_e7c75cf0();
	level flag::clear("zombie_drop_powerups");
	zm_spawner::deregister_zombie_death_event_callback(&namespace_2e6e7fce::function_1389d425);
	level thread zm_stalingrad_util::function_3804dbf1();
	level zm_stalingrad_util::function_adf4d1d0();
	level flag::clear("lockdown_complete");
	level flag::set("lockdown_active");
	level util::clientnotify("sndEED");
	level function_451531f2();
	level.var_1dfcc9b2.var_9fa1b3e = [];
	var_8a56b631 = level.players.size;
	level.var_1dfcc9b2.var_3eeb6c22[0] = 0;
	level.var_1dfcc9b2.var_3eeb6c22[1] = 1;
	level.var_1dfcc9b2.var_3eeb6c22[2] = 2;
	var_998322e5 = level.zombie_vars["zombie_spawn_delay"];
	if(var_998322e5 <= 0.1)
	{
		var_998322e5 = 0.1;
	}
	if(!isdefined(level.var_1dfcc9b2.var_4560ec9a))
	{
		level.var_1dfcc9b2.var_4560ec9a = [];
		level.var_1dfcc9b2.var_4560ec9a[0] = struct::get_array("lockdown_raz_spawner_east", "targetname");
		level.var_1dfcc9b2.var_4560ec9a[1] = struct::get_array("lockdown_raz_spawner_north", "targetname");
		level.var_1dfcc9b2.var_4560ec9a[2] = struct::get_array("lockdown_raz_spawner_west", "targetname");
	}
	level.var_1dfcc9b2.var_3eeb6c22 = array::randomize(level.var_1dfcc9b2.var_3eeb6c22);
	function_188bdb42();
	level thread zm_stalingrad_util::function_2f621485();
	exploder::exploder("pavlov_" + 0);
	exploder::exploder("pavlov_" + 4);
	wait(2.5);
	var_d98b610d = level.zombie_spawners[0];
	var_ddb16ab3 = struct::get("lockdown_ammo_lower", "targetname");
	var_93eb638b = zm_powerups::specific_powerup_drop("full_ammo", var_ddb16ab3.origin + vectorscale((0, 0, 1), 48));
	var_93eb638b notify(#"powerup_reset");
	for(i = 0; i < 3; i++)
	{
		if(level flag::get(var_13d1e831))
		{
			level flag::clear("wave_event_raz_spawning_active");
		}
		else
		{
			var_879a13d6 = [];
			level.var_1dfcc9b2.var_22bf30b7 = level.var_1dfcc9b2.var_3eeb6c22[i];
			switch(level.var_1dfcc9b2.var_22bf30b7)
			{
				case 2:
				{
					var_879a13d6 = arraycopy(level.var_1dfcc9b2.var_1865827a);
					break;
				}
				case 1:
				{
					var_879a13d6 = arraycopy(level.var_1dfcc9b2.var_3ec9c2c0);
					break;
				}
				case 0:
				{
					var_879a13d6 = arraycopy(level.var_1dfcc9b2.var_6c74b6c8);
					break;
				}
			}
		}
		level thread function_f4ceb3f8();
		level function_3d5f2c8e(level.var_1dfcc9b2.var_22bf30b7);
		if(i > 0)
		{
			level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_controller_quest_wave_start_2");
		}
		var_939defa4 = [];
		if(!isdefined(var_939defa4))
		{
			var_939defa4 = [];
		}
		else if(!isarray(var_939defa4))
		{
			var_939defa4 = array(var_939defa4);
		}
		var_939defa4[var_939defa4.size] = "wave_event_raz_spawning_active";
		level zm_stalingrad_util::function_b55ebb81(level.var_1dfcc9b2.var_4560ec9a[level.var_1dfcc9b2.var_22bf30b7], var_2b71b5b4, var_15eb9a52, var_f92c3865, undefined);
		if(var_939defa4.size > 0)
		{
			level flag::wait_till_clear_all(var_939defa4);
		}
		var_f92c3865 = var_f92c3865 - (0.1 * var_8a56b631);
		if(var_f92c3865 < 0.1)
		{
			var_f92c3865 = 0.1;
		}
		wait(0.5);
		function_187a933f(level.var_1dfcc9b2.var_22bf30b7);
		exploder::exploder("pavlov_" + 4);
		level notify(#"hash_d2eac5fe");
		level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_controller_quest_wave_end_1");
		wait(2.5);
		if(level flag::get(var_13d1e831))
		{
			break;
		}
	}
	if(!level flag::get(var_13d1e831))
	{
		var_4a86a85 = arraycopy(level.var_1dfcc9b2.var_4560ec9a[0]);
		var_4a86a85 = arraycombine(var_4a86a85, level.var_1dfcc9b2.var_4560ec9a[1], 0, 0);
		var_4a86a85 = arraycombine(var_4a86a85, level.var_1dfcc9b2.var_4560ec9a[2], 0, 0);
		level thread function_f4ceb3f8();
		for(i = 0; i < 3; i++)
		{
			switch(i)
			{
				case 0:
				{
					var_a48df19e = "east";
					break;
				}
				case 1:
				{
					var_a48df19e = "north";
					break;
				}
				case 2:
				{
					var_a48df19e = "west";
					break;
				}
			}
			var_98782f9e = struct::get("lockdown_shutter_explosion_" + var_a48df19e, "targetname");
			level thread function_1a7c9b89(var_a48df19e);
			playrumbleonposition("zm_stalingrad_lockdown_shutter_destroyed", var_98782f9e.origin);
			util::wait_network_frame();
		}
		function_f10ea3a8();
		exploder::exploder_stop("pavlov_" + 0);
		exploder::exploder_stop("pavlov_" + 4);
		util::wait_network_frame();
		level zm_stalingrad_util::function_b55ebb81(var_4a86a85, undefined, var_15eb9a52, var_f92c3865, undefined, var_13d1e831);
		function_188bdb42();
		exploder::exploder("pavlov_" + 4);
	}
	level notify(#"hash_d2eac5fe");
	level.var_1dfcc9b2.var_61126827 = undefined;
	level.var_a3559c05 = undefined;
	level flag::clear("lockdown_active");
	foreach(player in level.activeplayers)
	{
		player zm_score::add_to_player_score(500, 1);
		player notify(#"hash_1d89afbc");
	}
	level zm_stalingrad_util::function_2f621485(0);
	function_d6ced80(0);
	wait(2.5);
	function_f10ea3a8();
	exploder::exploder_stop("pavlov_" + 0);
	exploder::exploder_stop("pavlov_" + 4);
	zm_spawner::register_zombie_death_event_callback(&namespace_2e6e7fce::function_1389d425);
	level flag::set("zombie_drop_powerups");
	level flag::set("lockdown_complete");
	level thread zm_stalingrad_util::function_3804dbf1(0);
	level util::clientnotify("sndPD");
	level flag::clear(var_13d1e831);
	if(isdefined(var_93eb638b))
	{
		var_93eb638b thread zm_powerups::powerup_timeout();
	}
}

