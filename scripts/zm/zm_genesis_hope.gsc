// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis_timer;
#using scripts\zm\zm_genesis_util;

#namespace zm_genesis_hope;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_hope
	Checksum: 0x531D19BF
	Offset: 0x430
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_hope", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_hope
	Checksum: 0xF78E035D
	Offset: 0x478
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("world", "hope_state", 15000, getminbitcountfornum(4), "int");
	clientfield::register("clientuimodel", "zmInventory.super_ee", 15000, 1, "int");
	clientfield::register("toplayer", "hope_spark", 15000, 1, "int");
	clientfield::register("scriptmover", "hope_spark", 15000, 1, "int");
	level flag::init("hope_done");
	level.var_fa9755d7 = 0;
	/#
		if(getdvarint("") > 0)
		{
			level thread function_dfd4e9f8();
		}
	#/
}

/*
	Name: __main__
	Namespace: zm_genesis_hope
	Checksum: 0xF73896C0
	Offset: 0x5B8
	Size: 0xC
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	wait(0.1);
}

/*
	Name: start
	Namespace: zm_genesis_hope
	Checksum: 0x9B872365
	Offset: 0x5D0
	Size: 0x2A4
	Parameters: 0
	Flags: Linked
*/
function start()
{
	level waittill(#"start_zombie_round_logic");
	if(getdvarint("splitscreen_playerCount") > 2)
	{
		return;
	}
	var_d028d3a8 = array("ZOD", "FACTORY", "CASTLE", "ISLAND", "STALINGRAD");
	var_61d59a5a = [];
	foreach(player in level.players)
	{
		foreach(var_1493eda1 in var_d028d3a8)
		{
			var_dc163518 = (player zm_stats::get_global_stat(("DARKOPS_" + var_1493eda1) + "_SUPER_EE")) > 0;
			var_9d5e869 = isinarray(var_61d59a5a, var_1493eda1);
			if(var_dc163518 && !var_9d5e869)
			{
				if(!isdefined(var_61d59a5a))
				{
					var_61d59a5a = [];
				}
				else if(!isarray(var_61d59a5a))
				{
					var_61d59a5a = array(var_61d59a5a);
				}
				var_61d59a5a[var_61d59a5a.size] = var_1493eda1;
			}
		}
	}
	/#
		iprintlnbold(("" + var_61d59a5a.size) + "");
	#/
	if(var_61d59a5a.size == var_d028d3a8.size)
	{
		level clientfield::set("hope_state", 1);
		level thread function_bb1fbc7f();
	}
}

/*
	Name: function_bb1fbc7f
	Namespace: zm_genesis_hope
	Checksum: 0x9BB66CA9
	Offset: 0x880
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_bb1fbc7f()
{
	if(isdefined(level.var_e8bba4d1) && level.var_e8bba4d1)
	{
		return;
	}
	level.var_e8bba4d1 = 1;
	var_4ea80194 = struct::get("hope_spark", "targetname");
	var_4ea80194 zm_unitrigger::create_unitrigger("", 64, &function_4903bec6, &function_ed25d0f2, "unitrigger_radius_use");
	var_8dc2ea89 = struct::get("special_box", "targetname");
	var_8dc2ea89 zm_unitrigger::create_unitrigger("", 64, &function_2650d73f, &function_46cfcb01, "unitrigger_radius_use");
}

/*
	Name: function_4903bec6
	Namespace: zm_genesis_hope
	Checksum: 0xDA506515
	Offset: 0x9A8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_4903bec6(player)
{
	var_5d0b57e4 = level clientfield::get("hope_state");
	if(var_5d0b57e4 == 1)
	{
		self sethintstring("");
		return true;
	}
	return false;
}

/*
	Name: function_ed25d0f2
	Namespace: zm_genesis_hope
	Checksum: 0xF713338A
	Offset: 0xA20
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_ed25d0f2()
{
	while(true)
	{
		self waittill(#"trigger", e_triggerer);
		if(e_triggerer zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_triggerer, 1, 1))
		{
			continue;
		}
		var_5d0b57e4 = level clientfield::get("hope_state");
		if(var_5d0b57e4 != 1)
		{
			continue;
		}
		level thread function_b38baf01(e_triggerer);
	}
}

/*
	Name: function_b38baf01
	Namespace: zm_genesis_hope
	Checksum: 0x58F2FE43
	Offset: 0xAE8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_b38baf01(e_triggerer)
{
	level clientfield::set("hope_state", 2);
	e_triggerer thread function_ba9b0148();
	e_triggerer playsound("zmb_overachiever_spark_pickup");
}

/*
	Name: function_ba9b0148
	Namespace: zm_genesis_hope
	Checksum: 0x76A7FBF3
	Offset: 0xB58
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_ba9b0148()
{
	level endon(#"hope_done");
	self clientfield::set_to_player("hope_spark", 1);
	self clientfield::set_player_uimodel("zmInventory.super_ee", 1);
	self waittill(#"damage");
	self clientfield::set_to_player("hope_spark", 0);
	self clientfield::set_player_uimodel("zmInventory.super_ee", 0);
	self playsound("zmb_overachiever_spark_lose");
	/#
		iprintlnbold("");
	#/
}

/*
	Name: function_2650d73f
	Namespace: zm_genesis_hope
	Checksum: 0x50A964C9
	Offset: 0xC38
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function function_2650d73f(player)
{
	var_5d0b57e4 = level clientfield::get("hope_state");
	var_3d088ac6 = player clientfield::get_to_player("hope_spark");
	if(!var_3d088ac6)
	{
		return false;
	}
	if(var_5d0b57e4 == 2)
	{
		self sethintstring("");
		return true;
	}
	if(var_5d0b57e4 == 3)
	{
		self sethintstring("");
		return true;
	}
	return false;
}

/*
	Name: function_46cfcb01
	Namespace: zm_genesis_hope
	Checksum: 0xC61D6B27
	Offset: 0xD18
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function function_46cfcb01()
{
	while(true)
	{
		self waittill(#"trigger", e_triggerer);
		if(e_triggerer zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_triggerer, 1, 1))
		{
			continue;
		}
		var_3d088ac6 = e_triggerer clientfield::get_to_player("hope_spark");
		if(!var_3d088ac6)
		{
			continue;
		}
		var_5d0b57e4 = level clientfield::get("hope_state");
		if(var_5d0b57e4 != 2)
		{
			continue;
		}
		level thread function_6143b210(e_triggerer);
	}
}

/*
	Name: function_6143b210
	Namespace: zm_genesis_hope
	Checksum: 0x39521246
	Offset: 0xE18
	Size: 0x2B4
	Parameters: 1
	Flags: Linked
*/
function function_6143b210(e_triggerer)
{
	e_triggerer clientfield::set_to_player("hope_spark", 0);
	e_triggerer clientfield::set_player_uimodel("zmInventory.super_ee", 0);
	s_start = struct::get("hope_origin");
	var_8ccfc8c3 = util::spawn_model("tag_origin", s_start.origin, s_start.angles);
	util::wait_network_frame();
	var_8ccfc8c3 playsound("zmb_overachiever_spark_spawn");
	var_8ccfc8c3 clientfield::set("hope_spark", 1);
	wait(2);
	s_target = struct::get(s_start.target);
	var_8ccfc8c3 moveto(s_target.origin, 2);
	wait(3);
	s_target = struct::get(s_target.target);
	var_8ccfc8c3 moveto(s_target.origin, 2);
	var_8ccfc8c3 waittill(#"movedone");
	level clientfield::set("hope_state", 3);
	level flag::set("hope_done");
	playsoundatposition("zmb_overachiever_spark_success", (0, 0, 0));
	level.wallbuy_should_upgrade_weapon_override = &function_afddb902;
	level.magicbox_should_upgrade_weapon_override = &function_7e7eb906;
	zm_genesis_timer::function_cc8ae246(200);
	level thread bgb::function_93da425("zm_bgb_crate_power", &function_f648c43);
	level thread bgb::function_93da425("zm_bgb_wall_power", &function_f648c43);
}

/*
	Name: function_7e7eb906
	Namespace: zm_genesis_hope
	Checksum: 0xEC32BBAB
	Offset: 0x10D8
	Size: 0x18
	Parameters: 2
	Flags: Linked
*/
function function_7e7eb906(e_player, w_weapon)
{
	return true;
}

/*
	Name: function_afddb902
	Namespace: zm_genesis_hope
	Checksum: 0x987B40F3
	Offset: 0x10F8
	Size: 0x8
	Parameters: 0
	Flags: Linked
*/
function function_afddb902()
{
	return true;
}

/*
	Name: function_f648c43
	Namespace: zm_genesis_hope
	Checksum: 0xE9909B22
	Offset: 0x1108
	Size: 0x6
	Parameters: 0
	Flags: Linked
*/
function function_f648c43()
{
	return false;
}

/*
	Name: function_dfd4e9f8
	Namespace: zm_genesis_hope
	Checksum: 0x2BAB5DCA
	Offset: 0x1118
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_dfd4e9f8()
{
	/#
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_7ecb414e);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_3246e71d);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_3ff1131a);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_8070468);
	#/
}

/*
	Name: function_3246e71d
	Namespace: zm_genesis_hope
	Checksum: 0xB1E1CCFC
	Offset: 0x1210
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_3246e71d(n_val)
{
	/#
		level clientfield::set("", 1);
		level thread function_bb1fbc7f();
	#/
}

/*
	Name: function_3ff1131a
	Namespace: zm_genesis_hope
	Checksum: 0xD74B28BE
	Offset: 0x1268
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_3ff1131a(n_val)
{
	/#
		level clientfield::set("", 2);
		level thread function_bb1fbc7f();
	#/
}

/*
	Name: function_8070468
	Namespace: zm_genesis_hope
	Checksum: 0xB8A5BB70
	Offset: 0x12C0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_8070468(n_val)
{
	/#
		level clientfield::set("", 3);
		level thread function_bb1fbc7f();
		level flag::set("");
	#/
}

/*
	Name: function_7ecb414e
	Namespace: zm_genesis_hope
	Checksum: 0x18277B2F
	Offset: 0x1338
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_7ecb414e(n_val)
{
	/#
		level clientfield::set("", 1);
		level thread function_bb1fbc7f();
		/#
			iprintlnbold("");
		#/
	#/
}

