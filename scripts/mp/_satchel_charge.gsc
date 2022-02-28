// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons\_satchel_charge;

#namespace satchel_charge;

/*
	Name: __init__sytem__
	Namespace: satchel_charge
	Checksum: 0xDBB387F6
	Offset: 0x128
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("satchel_charge", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: satchel_charge
	Checksum: 0xF69A5FD1
	Offset: 0x168
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

