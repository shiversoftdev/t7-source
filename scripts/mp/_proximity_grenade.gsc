// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons\_proximity_grenade;

#namespace proximity_grenade;

/*
	Name: __init__sytem__
	Namespace: proximity_grenade
	Checksum: 0x22380BD
	Offset: 0x140
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("proximity_grenade", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: proximity_grenade
	Checksum: 0xF09300E8
	Offset: 0x180
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
	level.trackproximitygrenadesonowner = 1;
}

