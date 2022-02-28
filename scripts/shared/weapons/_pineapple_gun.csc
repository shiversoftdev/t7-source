// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace sticky_grenade;

/*
	Name: __init__sytem__
	Namespace: sticky_grenade
	Checksum: 0xFFB22D9F
	Offset: 0x130
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("pineapple_gun", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: sticky_grenade
	Checksum: 0x99EC1590
	Offset: 0x170
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

