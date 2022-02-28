// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;

#namespace mp_spire_fx;

/*
	Name: precache_scripted_fx
	Namespace: mp_spire_fx
	Checksum: 0x99EC1590
	Offset: 0xA8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
}

/*
	Name: precache_fx_anims
	Namespace: mp_spire_fx
	Checksum: 0xA074CC26
	Offset: 0xB8
	Size: 0x26
	Parameters: 0
	Flags: None
*/
function precache_fx_anims()
{
	level.scr_anim = [];
	level.scr_anim["fxanim_props"] = [];
}

/*
	Name: main
	Namespace: mp_spire_fx
	Checksum: 0x98B140FB
	Offset: 0xE8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function main()
{
	disablefx = getdvarint("disable_fx");
	if(!isdefined(disablefx) || disablefx <= 0)
	{
		precache_scripted_fx();
	}
}

