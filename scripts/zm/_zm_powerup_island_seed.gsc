// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_island_planting;

#namespace zm_powerup_island_seed;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_island_seed
	Checksum: 0x8345BCDC
	Offset: 0x468
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_island_seed", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_island_seed
	Checksum: 0xCC4D1B10
	Offset: 0x4A8
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	register_clientfields();
	zm_powerups::register_powerup("island_seed", &function_6adb5862);
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("island_seed", "p7_zm_isl_plant_seed_pod_01", &"ZM_ISLAND_SEED_POWERUP", &function_f766ae15, 1, 0, 0);
	}
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	/#
		thread function_7b74396f();
	#/
	level.var_9895ed0d = 0;
	level.var_325c412f = 2;
	level thread function_b2cb89c1();
	level thread function_68329bc5();
}

/*
	Name: register_clientfields
	Namespace: zm_powerup_island_seed
	Checksum: 0x86FE3BC0
	Offset: 0x608
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("toplayer", "has_island_seed", 1, 2, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_seed_parts", 9000, 1, "int");
	clientfield::register("toplayer", "bucket_seed_01", 9000, 1, "int");
	clientfield::register("toplayer", "bucket_seed_02", 9000, 1, "int");
	clientfield::register("toplayer", "bucket_seed_03", 9000, 1, "int");
}

/*
	Name: function_6adb5862
	Namespace: zm_powerup_island_seed
	Checksum: 0x41946A61
	Offset: 0x708
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_6adb5862(player)
{
	var_f65b973 = player clientfield::get_to_player("has_island_seed");
	if(var_f65b973 < 3)
	{
		var_b5c360bd = var_f65b973 + 1;
		player clientfield::set_to_player("has_island_seed", var_b5c360bd);
		player function_3968a493(1);
		player notify(#"hash_97e69ab7");
	}
}

/*
	Name: function_58b6724f
	Namespace: zm_powerup_island_seed
	Checksum: 0x351DFC28
	Offset: 0x7B8
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function function_58b6724f(player)
{
	var_f65b973 = player clientfield::get_to_player("has_island_seed");
	if(var_f65b973 > 0)
	{
		var_b5c360bd = var_f65b973 - 1;
		player clientfield::set_to_player("has_island_seed", var_b5c360bd);
		player function_3968a493(1);
		player notify(#"hash_9d289b3a");
		/#
			println("");
		#/
		return true;
	}
	return false;
}

/*
	Name: function_735cfef2
	Namespace: zm_powerup_island_seed
	Checksum: 0xA485FAD
	Offset: 0x890
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function function_735cfef2(player)
{
	return player clientfield::get_to_player("has_island_seed");
}

/*
	Name: function_aeda54f6
	Namespace: zm_powerup_island_seed
	Checksum: 0x9F0C26E8
	Offset: 0x8C8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_aeda54f6(var_f65b973)
{
	self clientfield::set_to_player("has_island_seed", var_f65b973);
	self function_3968a493();
}

/*
	Name: function_3968a493
	Namespace: zm_powerup_island_seed
	Checksum: 0xA2610A2E
	Offset: 0x918
	Size: 0x234
	Parameters: 1
	Flags: Linked
*/
function function_3968a493(var_b89973c8 = 0)
{
	var_f65b973 = function_735cfef2(self);
	switch(var_f65b973)
	{
		case 0:
		{
			self clientfield::set_to_player("bucket_seed_01", 0);
			self clientfield::set_to_player("bucket_seed_02", 0);
			self clientfield::set_to_player("bucket_seed_03", 0);
			break;
		}
		case 1:
		{
			self clientfield::set_to_player("bucket_seed_01", 1);
			self clientfield::set_to_player("bucket_seed_02", 0);
			self clientfield::set_to_player("bucket_seed_03", 0);
			break;
		}
		case 2:
		{
			self clientfield::set_to_player("bucket_seed_01", 1);
			self clientfield::set_to_player("bucket_seed_02", 1);
			self clientfield::set_to_player("bucket_seed_03", 0);
			break;
		}
		case 3:
		{
			self clientfield::set_to_player("bucket_seed_01", 1);
			self clientfield::set_to_player("bucket_seed_02", 1);
			self clientfield::set_to_player("bucket_seed_03", 1);
			break;
		}
	}
	if(var_b89973c8)
	{
		self thread zm_craftables::player_show_craftable_parts_ui(undefined, "zmInventory.widget_seed_parts", 0);
	}
}

/*
	Name: function_f766ae15
	Namespace: zm_powerup_island_seed
	Checksum: 0x3DB0A595
	Offset: 0xB58
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function function_f766ae15()
{
	if(isdefined(level.var_b426c9) && level.var_b426c9)
	{
		return false;
	}
	n_count = 0;
	foreach(player in level.activeplayers)
	{
		n_count = n_count + player clientfield::get_to_player("has_island_seed");
	}
	if(n_count == (level.activeplayers.size * 3))
	{
		return false;
	}
	return true;
}

/*
	Name: function_68329bc5
	Namespace: zm_powerup_island_seed
	Checksum: 0x2A0DA4FA
	Offset: 0xC48
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function function_68329bc5()
{
	while(true)
	{
		level waittill(#"between_round_over");
		level.var_9895ed0d = 0;
	}
}

/*
	Name: function_b2cb89c1
	Namespace: zm_powerup_island_seed
	Checksum: 0x88A92149
	Offset: 0xC78
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_b2cb89c1()
{
	level flag::init("round_1_seed_spawned");
	level.var_e964b72 = 0;
	level.custom_zombie_powerup_drop = &function_7a25b639;
	level flag::wait_till("round_1_seed_spawned");
	wait(1);
	level.custom_zombie_powerup_drop = &function_1f5d3f75;
	level thread function_af95a19e();
}

/*
	Name: function_7a25b639
	Namespace: zm_powerup_island_seed
	Checksum: 0xD1998637
	Offset: 0xD20
	Size: 0xEA
	Parameters: 1
	Flags: Linked
*/
function function_7a25b639(drop_point)
{
	if(!level function_f766ae15())
	{
		return false;
	}
	if(level flag::get("round_1_seed_spawned"))
	{
		return false;
	}
	if(math::cointoss() || getaicount() < 1)
	{
		var_93eb638b = zm_powerups::specific_powerup_drop("island_seed", drop_point);
		level flag::set("round_1_seed_spawned");
		level thread function_ca5485fa(var_93eb638b);
		level.var_9895ed0d++;
		return true;
	}
}

/*
	Name: function_1f5d3f75
	Namespace: zm_powerup_island_seed
	Checksum: 0x6E529111
	Offset: 0xE18
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function function_1f5d3f75(drop_point)
{
	if(!level function_f766ae15())
	{
		return false;
	}
	if(level.var_9895ed0d >= level.var_325c412f)
	{
		return false;
	}
	rand_drop = randomint(100);
	if(rand_drop > 2)
	{
		if(level.var_e964b72 == 0)
		{
			return;
		}
		/#
			println("");
		#/
	}
	else
	{
		/#
			println("");
		#/
	}
	var_93eb638b = zm_powerups::specific_powerup_drop("island_seed", drop_point);
	level thread function_ca5485fa(var_93eb638b);
	level.var_9895ed0d++;
	level.var_e964b72 = 0;
	return true;
}

/*
	Name: function_af95a19e
	Namespace: zm_powerup_island_seed
	Checksum: 0x974D9271
	Offset: 0xF48
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_af95a19e()
{
	level endon(#"unloaded");
	players = level.players;
	level.var_e4f2021b = 2000;
	score_to_drop = (players.size * (level.zombie_vars[("zombie_score_start_" + players.size) + "p"])) + level.var_e4f2021b;
	while(true)
	{
		players = level.players;
		curr_total_score = 0;
		for(i = 0; i < players.size; i++)
		{
			if(isdefined(players[i].score_total))
			{
				curr_total_score = curr_total_score + players[i].score_total;
			}
		}
		if(curr_total_score > score_to_drop)
		{
			level.var_e4f2021b = level.var_e4f2021b * 1.14;
			score_to_drop = curr_total_score + level.var_e4f2021b;
			level.var_e964b72 = 1;
		}
		wait(0.5);
	}
}

/*
	Name: function_ca5485fa
	Namespace: zm_powerup_island_seed
	Checksum: 0xE86AC9F5
	Offset: 0x10A0
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function function_ca5485fa(var_93eb638b)
{
	var_93eb638b endon(#"powerup_grabbed");
	var_93eb638b waittill(#"powerup_timedout");
	if(level.var_9895ed0d > 0)
	{
		level.var_9895ed0d--;
	}
}

/*
	Name: show_infotext_for_duration
	Namespace: zm_powerup_island_seed
	Checksum: 0x1C0ED810
	Offset: 0x10E8
	Size: 0x54
	Parameters: 2
	Flags: None
*/
function show_infotext_for_duration(str_infotext, n_duration)
{
	self clientfield::set_to_player(str_infotext, 1);
	wait(n_duration);
	self clientfield::set_to_player(str_infotext, 0);
}

/*
	Name: function_ea405166
	Namespace: zm_powerup_island_seed
	Checksum: 0x2B2DDEE8
	Offset: 0x1148
	Size: 0xC4
	Parameters: 3
	Flags: None
*/
function function_ea405166(var_1d640f59, str_widget_clientuimodel, var_18bfcc38)
{
	self notify(#"hash_6c34b226");
	self endon(#"hash_6c34b226");
	if(var_18bfcc38)
	{
		if(isdefined(var_1d640f59))
		{
			self thread clientfield::set_player_uimodel(var_1d640f59, 1);
		}
		n_show_ui_duration = 3.5;
	}
	else
	{
		n_show_ui_duration = 3.5;
	}
	self thread clientfield::set_player_uimodel(str_widget_clientuimodel, 1);
	wait(n_show_ui_duration);
	self thread clientfield::set_player_uimodel(str_widget_clientuimodel, 0);
}

/*
	Name: on_player_connect
	Namespace: zm_powerup_island_seed
	Checksum: 0x99EC1590
	Offset: 0x1218
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
}

/*
	Name: on_player_spawned
	Namespace: zm_powerup_island_seed
	Checksum: 0xCF44F907
	Offset: 0x1228
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self clientfield::set_to_player("has_island_seed", 0);
}

/*
	Name: function_7b74396f
	Namespace: zm_powerup_island_seed
	Checksum: 0xCC347DCB
	Offset: 0x1258
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_7b74396f()
{
	/#
		level flagsys::wait_till("");
		wait(1);
		zm_devgui::add_custom_devgui_callback(&function_903fbe7);
		adddebugcommand("");
		adddebugcommand("");
	#/
}

/*
	Name: function_903fbe7
	Namespace: zm_powerup_island_seed
	Checksum: 0x18F95D4E
	Offset: 0x12E0
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function function_903fbe7(cmd)
{
	/#
		players = getplayers();
		retval = 0;
		switch(cmd)
		{
			case "":
			{
				zm_devgui::zombie_devgui_give_powerup(cmd, 1);
				return 1;
			}
			case "":
			{
				zm_devgui::zombie_devgui_give_powerup(getsubstr(cmd, 5), 0);
				return 1;
			}
		}
		return retval;
	#/
}

