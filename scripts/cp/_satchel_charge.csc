// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_satchel_charge;

#namespace satchel_charge;

/*
	Name: __init__sytem__
	Namespace: satchel_charge
	Checksum: 0x3A9F1375
	Offset: 0x148
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
	Checksum: 0x836EB284
	Offset: 0x188
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function __init__(localclientnum)
{
	init_shared();
}

