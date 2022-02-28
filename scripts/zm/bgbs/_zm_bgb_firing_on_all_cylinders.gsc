// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_firing_on_all_cylinders;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_firing_on_all_cylinders
	Checksum: 0xDB373B32
	Offset: 0x190
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_firing_on_all_cylinders", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_firing_on_all_cylinders
	Checksum: 0xC1659A96
	Offset: 0x1D0
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
	bgb::register("zm_bgb_firing_on_all_cylinders", "rounds", 3, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: zm_bgb_firing_on_all_cylinders
	Checksum: 0x88718F4C
	Offset: 0x238
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function enable()
{
	self setperk("specialty_sprintfire");
}

/*
	Name: disable
	Namespace: zm_bgb_firing_on_all_cylinders
	Checksum: 0xDD5C5348
	Offset: 0x268
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function disable()
{
	self unsetperk("specialty_sprintfire");
}

