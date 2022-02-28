// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_trap_electric;

#namespace zm_genesis_traps;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_traps
	Checksum: 0x511F18CD
	Offset: 0x130
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_traps", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_traps
	Checksum: 0x6B717A1A
	Offset: 0x178
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	precache_scripted_fx();
}

/*
	Name: __main__
	Namespace: zm_genesis_traps
	Checksum: 0x99EC1590
	Offset: 0x198
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
}

/*
	Name: precache_scripted_fx
	Namespace: zm_genesis_traps
	Checksum: 0xF5606D67
	Offset: 0x1A8
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["zapper"] = "dlc1/castle/fx_elec_trap_castle";
}

