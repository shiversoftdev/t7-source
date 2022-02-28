// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_powerup_bonus_points_player;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_bonus_points_player
	Checksum: 0xD56F9A47
	Offset: 0x308
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_bonus_points_player", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_bonus_points_player
	Checksum: 0xA617132C
	Offset: 0x348
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_powerups::register_powerup("bonus_points_player", &grab_bonus_points_player);
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("bonus_points_player", "zombie_z_money_icon", &"ZOMBIE_POWERUP_BONUS_POINTS", &zm_powerups::func_should_never_drop, 1, 0, 0);
	}
}

/*
	Name: grab_bonus_points_player
	Namespace: zm_powerup_bonus_points_player
	Checksum: 0xAE29B89
	Offset: 0x3F8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function grab_bonus_points_player(player)
{
	level thread bonus_points_player_powerup(self, player);
	player thread zm_powerups::powerup_vo("bonus_points_solo");
}

/*
	Name: bonus_points_player_powerup
	Namespace: zm_powerup_bonus_points_player
	Checksum: 0xC869E739
	Offset: 0x448
	Size: 0xE4
	Parameters: 2
	Flags: Linked
*/
function bonus_points_player_powerup(item, player)
{
	points = randomintrange(1, 25) * 100;
	if(isdefined(level.bonus_points_powerup_override))
	{
		points = [[level.bonus_points_powerup_override]]();
	}
	if(isdefined(item.bonus_points_powerup_override))
	{
		points = [[item.bonus_points_powerup_override]]();
	}
	if(!player laststand::player_is_in_laststand() && !player.sessionstate == "spectator")
	{
		player zm_score::player_add_points("bonus_points_powerup", points);
	}
}

