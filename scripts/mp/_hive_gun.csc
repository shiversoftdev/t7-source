// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_hive_gun;

#namespace hive_gun;

/*
	Name: __init__sytem__
	Namespace: hive_gun
	Checksum: 0xD9E3DCDD
	Offset: 0x158
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("hive_gun", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: hive_gun
	Checksum: 0x21672BAC
	Offset: 0x198
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

