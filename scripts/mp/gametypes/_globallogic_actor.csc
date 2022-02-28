// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace globallogic_actor;

/*
	Name: __init__sytem__
	Namespace: globallogic_actor
	Checksum: 0xCF3F29C0
	Offset: 0x1B0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("globallogic_actor", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: globallogic_actor
	Checksum: 0xC9EFA69C
	Offset: 0x1F0
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["rcbombexplosion"] = "killstreaks/fx_rcxd_exp";
}

