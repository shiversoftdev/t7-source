// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons\_trophy_system;

#namespace trophy_system;

/*
	Name: __init__sytem__
	Namespace: trophy_system
	Checksum: 0x792A3C3A
	Offset: 0x148
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("trophy_system", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: trophy_system
	Checksum: 0xC64CBBBD
	Offset: 0x188
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

