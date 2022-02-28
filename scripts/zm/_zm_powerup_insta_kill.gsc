// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_powerup_insta_kill;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_insta_kill
	Checksum: 0xC488E35
	Offset: 0x2A0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_insta_kill", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_insta_kill
	Checksum: 0xA5B697F
	Offset: 0x2E0
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_powerups::register_powerup("insta_kill", &grab_insta_kill);
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("insta_kill", "p7_zm_power_up_insta_kill", &"ZOMBIE_POWERUP_INSTA_KILL", &zm_powerups::func_should_always_drop, 0, 0, 0, undefined, "powerup_instant_kill", "zombie_powerup_insta_kill_time", "zombie_powerup_insta_kill_on");
	}
}

/*
	Name: grab_insta_kill
	Namespace: zm_powerup_insta_kill
	Checksum: 0x9E4AE5C
	Offset: 0x3A8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function grab_insta_kill(player)
{
	level thread insta_kill_powerup(self, player);
	player thread zm_powerups::powerup_vo("insta_kill");
}

/*
	Name: insta_kill_powerup
	Namespace: zm_powerup_insta_kill
	Checksum: 0xC66D2E3E
	Offset: 0x3F8
	Size: 0x1C8
	Parameters: 2
	Flags: Linked
*/
function insta_kill_powerup(drop_item, player)
{
	level notify("powerup instakill_" + player.team);
	level endon("powerup instakill_" + player.team);
	if(isdefined(level.insta_kill_powerup_override))
	{
		level thread [[level.insta_kill_powerup_override]](drop_item, player);
		return;
	}
	if(zm_utility::is_classic())
	{
		player thread zm_pers_upgrades_functions::pers_upgrade_insta_kill_upgrade_check();
	}
	team = player.team;
	level thread zm_powerups::show_on_hud(team, "insta_kill");
	level.zombie_vars[team]["zombie_insta_kill"] = 1;
	n_wait_time = 30;
	if(bgb::is_team_enabled("zm_bgb_temporal_gift"))
	{
		n_wait_time = n_wait_time + 30;
	}
	wait(n_wait_time);
	level.zombie_vars[team]["zombie_insta_kill"] = 0;
	players = getplayers(team);
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i]))
		{
			players[i] notify(#"insta_kill_over");
		}
	}
}

