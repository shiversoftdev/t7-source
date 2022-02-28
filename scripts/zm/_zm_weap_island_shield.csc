// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace namespace_b2c57c5e;

/*
	Name: __init__sytem__
	Namespace: namespace_b2c57c5e
	Checksum: 0xF2A669B9
	Offset: 0x150
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_island_shield", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_b2c57c5e
	Checksum: 0x99EC1590
	Offset: 0x190
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

