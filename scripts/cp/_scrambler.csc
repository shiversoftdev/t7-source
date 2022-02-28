// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_scrambler;

#namespace scrambler;

/*
	Name: __init__sytem__
	Namespace: scrambler
	Checksum: 0xCAF984B1
	Offset: 0x158
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("scrambler", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: scrambler
	Checksum: 0xCEFD323B
	Offset: 0x198
	Size: 0x14
	Parameters: 0
	Flags: None
*/
function __init__()
{
	init_shared();
}

