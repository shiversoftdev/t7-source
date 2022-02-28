// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace zm_powerup_double_points;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_double_points
	Checksum: 0xF60699FE
	Offset: 0x128
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
	Checksum: 0xF32EFDBD
	Offset: 0x168
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_powerups::include_zombie_powerup("double_points");
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("double_points", "powerup_double_points");
	}
}

