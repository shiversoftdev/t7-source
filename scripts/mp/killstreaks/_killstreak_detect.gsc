// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_proximity_grenade;

#namespace killstreak_detect;

/*
	Name: __init__sytem__
	Namespace: killstreak_detect
	Checksum: 0xD46200EA
	Offset: 0x1E8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("killstreak_detect", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: killstreak_detect
	Checksum: 0x7913EDC6
	Offset: 0x228
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("vehicle", "enemyvehicle", 1, 2, "int");
	clientfield::register("scriptmover", "enemyvehicle", 1, 2, "int");
	clientfield::register("helicopter", "enemyvehicle", 1, 2, "int");
	clientfield::register("missile", "enemyvehicle", 1, 2, "int");
	clientfield::register("actor", "enemyvehicle", 1, 2, "int");
	clientfield::register("vehicle", "vehicletransition", 1, 1, "int");
}

/*
	Name: killstreaktargetset
	Namespace: killstreak_detect
	Checksum: 0x4880E7CB
	Offset: 0x358
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function killstreaktargetset(killstreakentity, offset = (0, 0, 0))
{
	target_set(killstreakentity, offset);
	/#
		killstreakentity thread killstreak_hacking::killstreak_switch_team(killstreakentity.owner);
	#/
}

/*
	Name: killstreaktargetclear
	Namespace: killstreak_detect
	Checksum: 0x998556BF
	Offset: 0x3D0
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function killstreaktargetclear(killstreakentity)
{
	target_remove(killstreakentity);
	/#
		killstreakentity thread killstreak_hacking::killstreak_switch_team_end();
	#/
}

