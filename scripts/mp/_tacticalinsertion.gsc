// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_tacticalinsertion;

#namespace tacticalinsertion;

/*
	Name: __init__sytem__
	Namespace: tacticalinsertion
	Checksum: 0x783AF9B6
	Offset: 0x170
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("tacticalinsertion", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: tacticalinsertion
	Checksum: 0xDB1E9492
	Offset: 0x1B0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

