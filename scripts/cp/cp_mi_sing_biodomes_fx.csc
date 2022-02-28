// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\fx_shared;

#namespace cp_mi_sing_biodomes_fx;

/*
	Name: main
	Namespace: cp_mi_sing_biodomes_fx
	Checksum: 0x8C2A3548
	Offset: 0xE0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_scripted_fx();
}

/*
	Name: precache_scripted_fx
	Namespace: cp_mi_sing_biodomes_fx
	Checksum: 0x2C793F01
	Offset: 0x100
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["player_dust"] = "dirt/fx_dust_motes_player_loop";
}

