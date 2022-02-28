// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace zm_powerup_bonus_points_player;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_bonus_points_player
	Checksum: 0xF22CB0EE
	Offset: 0x110
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
	Checksum: 0x2932E133
	Offset: 0x150
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_powerups::include_zombie_powerup("bonus_points_player");
	zm_powerups::add_zombie_powerup("bonus_points_player");
}

