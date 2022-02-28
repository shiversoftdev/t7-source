// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_decoy;

#namespace decoy;

/*
	Name: __init__sytem__
	Namespace: decoy
	Checksum: 0x7E97B40F
	Offset: 0x128
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("decoy", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: decoy
	Checksum: 0xABFBC6FD
	Offset: 0x168
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

