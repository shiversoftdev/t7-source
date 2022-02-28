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

#namespace zm_powerup_ww_grenade;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_ww_grenade
	Checksum: 0xD36F6C9A
	Offset: 0x368
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_ww_grenade", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_ww_grenade
	Checksum: 0xC4AE65D7
	Offset: 0x3A8
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_powerups::register_powerup("ww_grenade", &grab_ww_grenade);
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("ww_grenade", "p7_zm_power_up_widows_wine", &"ZOMBIE_POWERUP_WW_GRENADE", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_player_specific("ww_grenade", 1);
	}
	/#
		level thread ww_grenade_devgui();
	#/
}

/*
	Name: grab_ww_grenade
	Namespace: zm_powerup_ww_grenade
	Checksum: 0x79EA64F5
	Offset: 0x490
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function grab_ww_grenade(player)
{
	level thread ww_grenade_powerup(self, player);
	player thread zm_powerups::powerup_vo("bonus_points_solo");
}

/*
	Name: ww_grenade_powerup
	Namespace: zm_powerup_ww_grenade
	Checksum: 0x12DE9328
	Offset: 0x4E0
	Size: 0x144
	Parameters: 2
	Flags: Linked
*/
function ww_grenade_powerup(item, player)
{
	if(!player laststand::player_is_in_laststand() && !player.sessionstate == "spectator")
	{
		if(player hasperk("specialty_widowswine"))
		{
			change = 1;
			oldammo = player getweaponammoclip(player.current_lethal_grenade);
			maxammo = player.current_lethal_grenade.startammo;
			newammo = int(min(maxammo, max(0, oldammo + change)));
			player setweaponammoclip(player.current_lethal_grenade, newammo);
		}
	}
}

/*
	Name: ww_grenade_devgui
	Namespace: zm_powerup_ww_grenade
	Checksum: 0xCC671CC9
	Offset: 0x630
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function ww_grenade_devgui()
{
	/#
		level flagsys::wait_till("");
		wait(1);
		zm_devgui::add_custom_devgui_callback(&ww_grenade_devgui_callback);
		adddebugcommand("");
		adddebugcommand("");
	#/
}

/*
	Name: detect_reentry
	Namespace: zm_powerup_ww_grenade
	Checksum: 0xD22E48FF
	Offset: 0x6B8
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function detect_reentry()
{
	/#
		if(isdefined(self.var_2654b40c))
		{
			if(self.var_2654b40c == gettime())
			{
				return true;
			}
		}
		self.var_2654b40c = gettime();
		return false;
	#/
}

/*
	Name: ww_grenade_devgui_callback
	Namespace: zm_powerup_ww_grenade
	Checksum: 0x68D49251
	Offset: 0x6F8
	Size: 0x10E
	Parameters: 1
	Flags: Linked
*/
function ww_grenade_devgui_callback(cmd)
{
	/#
		players = getplayers();
		retval = 0;
		switch(cmd)
		{
			case "":
			{
				if(level detect_reentry())
				{
					return 1;
				}
				array::thread_all(players, &zm_devgui::zombie_devgui_give_powerup_player, cmd, 1);
				return 1;
			}
			case "":
			{
				if(level detect_reentry())
				{
					return 1;
				}
				array::thread_all(players, &zm_devgui::zombie_devgui_give_powerup_player, getsubstr(cmd, 5), 0);
				return 1;
			}
		}
		return retval;
	#/
}

