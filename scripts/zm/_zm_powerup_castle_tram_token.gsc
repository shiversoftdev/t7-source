// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
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

#namespace zm_powerup_castle_tram_token;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0x2E501CF0
	Offset: 0x4A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_castle_tram_token", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0xAB69CEF7
	Offset: 0x4E8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	register_clientfields();
	zm_powerups::register_powerup("castle_tram_token", &function_bcb6924e);
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("castle_tram_token", "p7_zm_ctl_115_fuse_pickup", &"ZM_CASTLE_TRAM_TOKEN_POWERUP", &function_56739ab1, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("castle_tram_token");
	}
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	/#
		thread function_6dd86f90();
	#/
}

/*
	Name: register_clientfields
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0x78D66C26
	Offset: 0x618
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("toplayer", "has_castle_tram_token", 1, 1, "int");
	clientfield::register("toplayer", "ZM_CASTLE_TRAM_TOKEN_ACQUIRED", 1, 1, "int");
	clientfield::register("scriptmover", "powerup_fuse_fx", 1, 1, "int");
	for(i = 0; i < 4; i++)
	{
		clientfield::register("world", ("player" + i) + "hasItem", 1, 1, "int");
	}
	clientfield::register("clientuimodel", "zmInventory.player_using_sprayer", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_sprayer", 1, 1, "int");
}

/*
	Name: function_bcb6924e
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0x798B76E6
	Offset: 0x778
	Size: 0x148
	Parameters: 1
	Flags: Linked
*/
function function_bcb6924e(player)
{
	if(!player clientfield::get_to_player("has_castle_tram_token"))
	{
		player clientfield::set_to_player("has_castle_tram_token", 1);
		player thread show_infotext_for_duration("ZM_CASTLE_TRAM_TOKEN_ACQUIRED", 3.5);
		player thread function_1cb39173("zmInventory.player_using_sprayer", "zmInventory.widget_sprayer", 1);
		level thread function_a52da515(player);
		level clientfield::set(("player" + player.entity_num) + "hasItem", 1);
		level thread function_4c1f0ef2();
		if(!player.var_dc5e13e5)
		{
			player thread zm_equipment::show_hint_text(&"ZM_CASTLE_TRAM_TOKEN_HINT", 4);
			player.var_dc5e13e5 = 1;
		}
	}
}

/*
	Name: function_ed4d87a3
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0xB4525982
	Offset: 0x8C8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_ed4d87a3(player)
{
	if(player clientfield::get_to_player("has_castle_tram_token"))
	{
		player notify(#"tram_token_used");
		return true;
	}
	return false;
}

/*
	Name: function_83ef471e
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0xF8FBFFF0
	Offset: 0x918
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function function_83ef471e(player)
{
	return player clientfield::get_to_player("has_castle_tram_token");
}

/*
	Name: function_56739ab1
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0xC1B84E3C
	Offset: 0x950
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function function_56739ab1()
{
	if(isdefined(level.var_6e2e91a0) && level.var_6e2e91a0)
	{
		return 0;
	}
	var_db175e = !level flag::get("tram_moving") && !level flag::get("tram_docked") && !level flag::get("tram_cooldown");
	return var_db175e;
}

/*
	Name: function_4c1f0ef2
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0x63E22053
	Offset: 0x9E8
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function function_4c1f0ef2()
{
	level.var_6e2e91a0 = 1;
	level waittill(#"between_round_over");
	level.var_6e2e91a0 = undefined;
}

/*
	Name: show_infotext_for_duration
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0x6C63C548
	Offset: 0xA18
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function show_infotext_for_duration(str_infotext, n_duration)
{
	self clientfield::set_to_player(str_infotext, 1);
	wait(n_duration);
	self clientfield::set_to_player(str_infotext, 0);
}

/*
	Name: function_1cb39173
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0x7F685EC3
	Offset: 0xA78
	Size: 0xE4
	Parameters: 3
	Flags: Linked, Private
*/
function private function_1cb39173(var_1d640f59, str_widget_clientuimodel, var_18bfcc38)
{
	level notify(#"widget_ui_override");
	self endon(#"disconnect");
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
	level util::waittill_any_ex(n_show_ui_duration, "widget_ui_override", self, "disconnect");
	self thread clientfield::set_player_uimodel(str_widget_clientuimodel, 0);
}

/*
	Name: function_a52da515
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0xBBE942A8
	Offset: 0xB68
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function function_a52da515(player)
{
	var_507b79e0 = player.entity_num;
	str_result = player util::waittill_any_return("tram_token_used", "bled_out", "death", "disconnect");
	if(str_result === "tram_token_used")
	{
		player clientfield::set_to_player("has_castle_tram_token", 0);
		player clientfield::set_player_uimodel("zmInventory.player_using_sprayer", 0);
	}
	level clientfield::set(("player" + var_507b79e0) + "hasItem", 0);
}

/*
	Name: on_player_connect
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0x9DABE6F2
	Offset: 0xC50
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self.var_dc5e13e5 = 0;
}

/*
	Name: on_player_spawned
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0xE9FF3AE7
	Offset: 0xC68
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
}

/*
	Name: function_6dd86f90
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0xDC3EC1FF
	Offset: 0xC98
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_6dd86f90()
{
	/#
		level flagsys::wait_till("");
		wait(1);
		zm_devgui::add_custom_devgui_callback(&function_9293606a);
		adddebugcommand("");
		adddebugcommand("");
	#/
}

/*
	Name: function_9293606a
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0x4238E20D
	Offset: 0xD20
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function function_9293606a(cmd)
{
	/#
		players = getplayers();
		retval = 0;
		switch(cmd)
		{
			case "":
			{
				zm_devgui::zombie_devgui_give_powerup(cmd, 1);
				break;
			}
			case "":
			{
				zm_devgui::zombie_devgui_give_powerup(getsubstr(cmd, 5), 0);
				break;
			}
		}
		return retval;
	#/
}

