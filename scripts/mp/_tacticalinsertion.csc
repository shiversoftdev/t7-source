// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_tacticalinsertion;

#namespace tacticalinsertion;

/*
	Name: __init__sytem__
	Namespace: tacticalinsertion
	Checksum: 0x8650C164
	Offset: 0x150
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("tacticalinsertion", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: tacticalinsertion
	Checksum: 0xDBCF0F3F
	Offset: 0x190
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

