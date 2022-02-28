// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons\_flashgrenades;

#namespace flashgrenades;

/*
	Name: __init__sytem__
	Namespace: flashgrenades
	Checksum: 0xB8BC3EBE
	Offset: 0x120
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("flashgrenades", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: flashgrenades
	Checksum: 0x109F6123
	Offset: 0x160
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

