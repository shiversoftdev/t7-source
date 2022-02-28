// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_firing_on_all_cylinders;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_firing_on_all_cylinders
	Checksum: 0x89202CA1
	Offset: 0x160
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_firing_on_all_cylinders", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_bgb_firing_on_all_cylinders
	Checksum: 0x9A93DFAE
	Offset: 0x1A0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_firing_on_all_cylinders", "rounds");
}

