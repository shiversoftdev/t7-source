// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;

#namespace mp_apartments_fx;

/*
	Name: main
	Namespace: mp_apartments_fx
	Checksum: 0x48BA926B
	Offset: 0xA0
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
	Namespace: mp_apartments_fx
	Checksum: 0x99EC1590
	Offset: 0xD0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
}

/*
	Name: precache_fxanim_props
	Namespace: mp_apartments_fx
	Checksum: 0x82045E33
	Offset: 0xE0
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function precache_fxanim_props()
{
	level.scr_anim = [];
	level.scr_anim["fxanim_props"] = [];
}

