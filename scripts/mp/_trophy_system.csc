// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_trophy_system;

#namespace trophy_system;

/*
	Name: __init__sytem__
	Namespace: trophy_system
	Checksum: 0x871D602B
	Offset: 0x168
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
	Checksum: 0x9B05F6AB
	Offset: 0x1A8
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function __init__(localclientnum)
{
	init_shared();
}

