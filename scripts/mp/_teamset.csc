// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\system_shared;

#namespace teamset;

/*
	Name: __init__sytem__
	Namespace: teamset
	Checksum: 0x7CD5FFCD
	Offset: 0xC8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("teamset_seals", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: teamset
	Checksum: 0xBBE3B745
	Offset: 0x108
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.allies_team = "allies";
	level.axis_team = "axis";
}

