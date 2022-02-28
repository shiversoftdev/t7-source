// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_shopping_free;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_shopping_free
	Checksum: 0xEA3A306B
	Offset: 0x148
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_shopping_free", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_shopping_free
	Checksum: 0x517DDE6
	Offset: 0x188
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_shopping_free", "time", 60, &enable, &disable, undefined, undefined);
}

/*
	Name: enable
	Namespace: zm_bgb_shopping_free
	Checksum: 0xBF0AC0E8
	Offset: 0x1F8
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function enable()
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"bgb_update");
}

/*
	Name: disable
	Namespace: zm_bgb_shopping_free
	Checksum: 0x99EC1590
	Offset: 0x228
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function disable()
{
}

