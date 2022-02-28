// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons\_hive_gun;

#namespace hive_gun;

/*
	Name: __init__sytem__
	Namespace: hive_gun
	Checksum: 0x703B4250
	Offset: 0x110
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
	Checksum: 0x4174FF25
	Offset: 0x150
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

