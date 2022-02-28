// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_powerup_double_points;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_double_points
	Checksum: 0x6285745
	Offset: 0x2F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_double_points", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_double_points
	Checksum: 0x1A4E6C2
	Offset: 0x338
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_powerups::register_powerup("double_points", &grab_double_points);
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("double_points", "p7_zm_power_up_double_points", &"ZOMBIE_POWERUP_DOUBLE_POINTS", &zm_powerups::func_should_always_drop, 0, 0, 0, undefined, "powerup_double_points", "zombie_powerup_double_points_time", "zombie_powerup_double_points_on");
	}
}

/*
	Name: grab_double_points
	Namespace: zm_powerup_double_points
	Checksum: 0xFA86B451
	Offset: 0x400
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function grab_double_points(player)
{
	level thread double_points_powerup(self, player);
	player thread zm_powerups::powerup_vo("double_points");
}

/*
	Name: double_points_powerup
	Namespace: zm_powerup_double_points
	Checksum: 0x75519471
	Offset: 0x450
	Size: 0x2A6
	Parameters: 2
	Flags: Linked
*/
function double_points_powerup(drop_item, player)
{
	level notify("powerup points scaled_" + player.team);
	level endon("powerup points scaled_" + player.team);
	team = player.team;
	level thread zm_powerups::show_on_hud(team, "double_points");
	if(isdefined(level.pers_upgrade_double_points) && level.pers_upgrade_double_points)
	{
		player thread zm_pers_upgrades_functions::pers_upgrade_double_points_pickup_start();
	}
	if(isdefined(level.current_game_module) && level.current_game_module == 2)
	{
		if(isdefined(player._race_team))
		{
			if(player._race_team == 1)
			{
				level._race_team_double_points = 1;
			}
			else
			{
				level._race_team_double_points = 2;
			}
		}
	}
	level.zombie_vars[team]["zombie_point_scalar"] = 2;
	players = getplayers();
	for(player_index = 0; player_index < players.size; player_index++)
	{
		if(team == players[player_index].team)
		{
			players[player_index] clientfield::set_player_uimodel("hudItems.doublePointsActive", 1);
		}
	}
	n_wait = 30;
	if(bgb::is_team_enabled("zm_bgb_temporal_gift"))
	{
		n_wait = n_wait + 30;
	}
	wait(n_wait);
	level.zombie_vars[team]["zombie_point_scalar"] = 1;
	level._race_team_double_points = undefined;
	players = getplayers();
	for(player_index = 0; player_index < players.size; player_index++)
	{
		if(team == players[player_index].team)
		{
			players[player_index] clientfield::set_player_uimodel("hudItems.doublePointsActive", 0);
		}
	}
}

