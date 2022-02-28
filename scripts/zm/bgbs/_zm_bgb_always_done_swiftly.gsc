// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_always_done_swiftly;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_always_done_swiftly
	Checksum: 0x1D5DB552
	Offset: 0x198
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_always_done_swiftly", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_always_done_swiftly
	Checksum: 0x79606D3
	Offset: 0x1D8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_always_done_swiftly", "rounds", 3, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: zm_bgb_always_done_swiftly
	Checksum: 0x83975A95
	Offset: 0x240
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function enable()
{
	self setperk("specialty_fastads");
	self setperk("specialty_stalker");
}

/*
	Name: disable
	Namespace: zm_bgb_always_done_swiftly
	Checksum: 0x41F6037E
	Offset: 0x290
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function disable()
{
	self unsetperk("specialty_fastads");
	self unsetperk("specialty_stalker");
}

