// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_temporal_gift;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_temporal_gift
	Checksum: 0xEC834B91
	Offset: 0x150
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_temporal_gift", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_temporal_gift
	Checksum: 0xB7C1473F
	Offset: 0x190
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
	bgb::register("zm_bgb_temporal_gift", "rounds", 1, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: zm_bgb_temporal_gift
	Checksum: 0x99EC1590
	Offset: 0x1F8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function enable()
{
}

/*
	Name: disable
	Namespace: zm_bgb_temporal_gift
	Checksum: 0x99EC1590
	Offset: 0x208
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function disable()
{
}

