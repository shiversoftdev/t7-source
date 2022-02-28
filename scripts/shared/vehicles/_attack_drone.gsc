// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#namespace attack_drone;

/*
	Name: __init__sytem__
	Namespace: attack_drone
	Checksum: 0x61ABF4E4
	Offset: 0x1A0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("attack_drone", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: attack_drone
	Checksum: 0x99EC1590
	Offset: 0x1E0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

