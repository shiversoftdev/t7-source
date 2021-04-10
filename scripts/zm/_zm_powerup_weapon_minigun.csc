// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace zm_powerup_weapon_minigun;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_weapon_minigun
	Checksum: 0x4DD92169
	Offset: 0x120
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("zm_powerup_weapon_minigun", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_weapon_minigun
	Checksum: 0xBF5535D3
	Offset: 0x160
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_powerups::include_zombie_powerup("minigun");
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("minigun", "powerup_mini_gun");
	}
}

