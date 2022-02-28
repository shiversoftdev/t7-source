// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_elemental_zombies;

#namespace zm_ai_mechz;

/*
	Name: __init__sytem__
	Namespace: zm_ai_mechz
	Checksum: 0xC94177DA
	Offset: 0xF8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_mechz", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_mechz
	Checksum: 0x99EC1590
	Offset: 0x140
	Size: 0x4
	Parameters: 0
	Flags: Linked, AutoExec
*/
function autoexec __init__()
{
}

/*
	Name: __main__
	Namespace: zm_ai_mechz
	Checksum: 0x4A026AEE
	Offset: 0x150
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	visionset_mgr::register_overlay_info_style_burn("mechz_player_burn", 5000, 15, 1.5);
}

