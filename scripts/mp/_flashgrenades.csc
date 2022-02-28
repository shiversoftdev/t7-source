// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_flashgrenades;

#namespace flashgrenades;

/*
	Name: __init__sytem__
	Namespace: flashgrenades
	Checksum: 0xAE199F8B
	Offset: 0x170
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
	Checksum: 0xF0CCF5E3
	Offset: 0x1B0
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function __init__(localclientnum)
{
	init_shared();
}

