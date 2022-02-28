// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace entityheadicons;

/*
	Name: __init__sytem__
	Namespace: entityheadicons
	Checksum: 0xC6887FC6
	Offset: 0x130
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("entityheadicons", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: entityheadicons
	Checksum: 0xB8629E1E
	Offset: 0x170
	Size: 0x14
	Parameters: 0
	Flags: None
*/
function __init__()
{
	init_shared();
}

