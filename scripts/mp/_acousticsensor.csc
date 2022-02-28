// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_acousticsensor;

#namespace acousticsensor;

/*
	Name: __init__sytem__
	Namespace: acousticsensor
	Checksum: 0xEF6562A8
	Offset: 0x148
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("acousticsensor", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: acousticsensor
	Checksum: 0x94F786D1
	Offset: 0x188
	Size: 0x14
	Parameters: 0
	Flags: None
*/
function __init__()
{
	init_shared();
}

