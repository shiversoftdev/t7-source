// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_powerup_demonic_rune;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_demonic_rune
	Checksum: 0x2AFDEAAB
	Offset: 0x4A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_demonic_rune", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_demonic_rune
	Checksum: 0x9CBD3652
	Offset: 0x4E8
	Size: 0x57C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "demonic_rune_fx", 5000, 1, "int");
	zm_powerups::register_powerup("demonic_rune_lor", &function_b11a0932);
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("demonic_rune_lor", "p7_zm_ctl_demon_gate_power_up_icons_lor", &"", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("demonic_rune_lor");
		zm_powerups::powerup_set_player_specific("demonic_rune_lor", 1);
	}
	zm_powerups::register_powerup("demonic_rune_ulla", &function_b11a0932);
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("demonic_rune_ulla", "p7_zm_ctl_demon_gate_power_up_icons_door", &"", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("demonic_rune_ulla");
		zm_powerups::powerup_set_player_specific("demonic_rune_ulla", 1);
	}
	zm_powerups::register_powerup("demonic_rune_oth", &function_b11a0932);
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("demonic_rune_oth", "p7_zm_ctl_demon_gate_power_up_icons_oth", &"", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("demonic_rune_oth");
		zm_powerups::powerup_set_player_specific("demonic_rune_oth", 1);
	}
	zm_powerups::register_powerup("demonic_rune_zor", &function_b11a0932);
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("demonic_rune_zor", "p7_zm_ctl_demon_gate_power_up_icons_zor", &"", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("demonic_rune_zor");
		zm_powerups::powerup_set_player_specific("demonic_rune_zor", 1);
	}
	zm_powerups::register_powerup("demonic_rune_mar", &function_b11a0932);
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("demonic_rune_mar", "p7_zm_ctl_demon_gate_power_up_icons_stag", &"", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("demonic_rune_mar");
		zm_powerups::powerup_set_player_specific("demonic_rune_mar", 1);
	}
	zm_powerups::register_powerup("demonic_rune_uja", &function_b11a0932);
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("demonic_rune_uja", "p7_zm_ctl_demon_gate_power_up_icons_uja", &"", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("demonic_rune_uja");
		zm_powerups::powerup_set_player_specific("demonic_rune_uja", 1);
	}
	level flag::init("demonic_rune_dropped");
	/#
		level thread function_15732f56();
	#/
}

/*
	Name: function_b11a0932
	Namespace: zm_powerup_demonic_rune
	Checksum: 0xA6FDB452
	Offset: 0xA70
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_b11a0932(player)
{
	level flag::clear("demonic_rune_dropped");
	level notify(#"demonic_rune_grabbed");
	player thread zm_powerups::powerup_vo("bonus_points_solo");
}

/*
	Name: function_5b767c2
	Namespace: zm_powerup_demonic_rune
	Checksum: 0xC4640AE2
	Offset: 0xAD0
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function function_5b767c2()
{
	self endon(#"powerup_grabbed");
	self endon(#"death");
	self endon(#"powerup_reset");
	self zm_powerups::powerup_show(1);
	wait_time = 1;
	if(isdefined(level._powerup_timeout_custom_time))
	{
		time = [[level._powerup_timeout_custom_time]](self);
		if(time == 0)
		{
			return;
		}
		wait_time = time;
	}
	wait(wait_time);
	for(i = 20; i > 0; i--)
	{
		if(i % 2)
		{
			self zm_powerups::powerup_show(0);
		}
		else
		{
			self zm_powerups::powerup_show(1);
		}
		if(i > 15)
		{
			wait(0.3);
		}
		if(i > 10)
		{
			wait(0.25);
			continue;
		}
		if(i > 5)
		{
			wait(0.15);
			continue;
		}
		wait(0.1);
	}
	level.var_923a3c95 = undefined;
	level flag::clear("demonic_rune_dropped");
	level notify(#"demonic_rune_timed_out");
	self notify(#"powerup_timedout");
	self zm_powerups::powerup_delete();
}

/*
	Name: function_15732f56
	Namespace: zm_powerup_demonic_rune
	Checksum: 0x53E08A60
	Offset: 0xC90
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_15732f56()
{
	/#
		level flagsys::wait_till("");
		wait(1);
		zm_devgui::add_custom_devgui_callback(&function_a4207c70);
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
	#/
}

/*
	Name: detect_reentry
	Namespace: zm_powerup_demonic_rune
	Checksum: 0xB0634DD7
	Offset: 0xD78
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function detect_reentry()
{
	/#
		if(isdefined(self.var_1688944a))
		{
			if(self.var_1688944a == gettime())
			{
				return true;
			}
		}
		self.var_1688944a = gettime();
		return false;
	#/
}

/*
	Name: function_a4207c70
	Namespace: zm_powerup_demonic_rune
	Checksum: 0xB687FD05
	Offset: 0xDB8
	Size: 0x296
	Parameters: 1
	Flags: Linked
*/
function function_a4207c70(cmd)
{
	/#
		if(!isdefined(level.var_6e68c0d8) || !level flag::get("") || level flag::get(""))
		{
			return;
		}
		retval = 0;
		switch(cmd)
		{
			case "":
			{
				if(level detect_reentry())
				{
					return 1;
				}
				level.var_bb00a6cd = cmd;
				level.var_6e68c0d8 thread zm_devgui::zombie_devgui_give_powerup_player(cmd, 1);
				return 1;
			}
			case "":
			{
				if(level detect_reentry())
				{
					return 1;
				}
				level.var_bb00a6cd = cmd;
				level.var_6e68c0d8 thread zm_devgui::zombie_devgui_give_powerup_player(cmd, 1);
				return 1;
			}
			case "":
			{
				if(level detect_reentry())
				{
					return 1;
				}
				level.var_bb00a6cd = cmd;
				level.var_6e68c0d8 thread zm_devgui::zombie_devgui_give_powerup_player(cmd, 1);
				return 1;
			}
			case "":
			{
				if(level detect_reentry())
				{
					return 1;
				}
				level.var_bb00a6cd = cmd;
				level.var_6e68c0d8 thread zm_devgui::zombie_devgui_give_powerup_player(cmd, 1);
				return 1;
			}
			case "":
			{
				if(level detect_reentry())
				{
					return 1;
				}
				level.var_bb00a6cd = cmd;
				level.var_6e68c0d8 thread zm_devgui::zombie_devgui_give_powerup_player(cmd, 1);
				return 1;
			}
			case "":
			{
				if(level detect_reentry())
				{
					return 1;
				}
				level.var_bb00a6cd = cmd;
				level.var_6e68c0d8 thread zm_devgui::zombie_devgui_give_powerup_player(cmd, 1);
				return 1;
			}
		}
		return retval;
	#/
}

