// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace _gadget_rapid_strike;

/*
	Name: __init__sytem__
	Namespace: _gadget_rapid_strike
	Checksum: 0x58AF2D5B
	Offset: 0x1F0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_rapid_strike", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_rapid_strike
	Checksum: 0x99EC1590
	Offset: 0x230
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

