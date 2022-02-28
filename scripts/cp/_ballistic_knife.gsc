// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons\_ballistic_knife;

#namespace ballistic_knife;

/*
	Name: __init__sytem__
	Namespace: ballistic_knife
	Checksum: 0x5394AADD
	Offset: 0x138
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ballistic_knife", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ballistic_knife
	Checksum: 0xFBFFD01E
	Offset: 0x178
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

