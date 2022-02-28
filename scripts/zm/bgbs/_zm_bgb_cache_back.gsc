// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_cache_back;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_cache_back
	Checksum: 0x11785C9E
	Offset: 0x158
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_cache_back", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_cache_back
	Checksum: 0xDB0EAD9
	Offset: 0x198
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_cache_back", "activated", 1, undefined, undefined, undefined, &activation);
}

/*
	Name: activation
	Namespace: zm_bgb_cache_back
	Checksum: 0x268560C4
	Offset: 0x1F8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	self thread bgb::function_dea74fb0("full_ammo");
}

