// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons\_decoy;

#namespace decoy;

/*
	Name: __init__sytem__
	Namespace: decoy
	Checksum: 0x39F0F22E
	Offset: 0xF8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("decoy", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: decoy
	Checksum: 0x6EBE3191
	Offset: 0x138
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

