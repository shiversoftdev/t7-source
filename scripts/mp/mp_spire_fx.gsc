// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;

#namespace mp_spire_fx;

/*
	Name: main
	Namespace: mp_spire_fx
	Checksum: 0x19A14452
	Offset: 0x98
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_fxanim_props();
	precache_scripted_fx();
}

/*
	Name: precache_scripted_fx
	Namespace: mp_spire_fx
	Checksum: 0x99EC1590
	Offset: 0xC8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
}

/*
	Name: precache_fxanim_props
	Namespace: mp_spire_fx
	Checksum: 0x2CEB8E25
	Offset: 0xD8
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function precache_fxanim_props()
{
	level.scr_anim = [];
	level.scr_anim["fxanim_props"] = [];
}

