// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;

#namespace cp_mi_cairo_lotus_fx;

/*
	Name: main
	Namespace: cp_mi_cairo_lotus_fx
	Checksum: 0x93CE7E52
	Offset: 0xC8
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
	Namespace: cp_mi_cairo_lotus_fx
	Checksum: 0xDF0AE6D8
	Offset: 0xE8
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["fx_snow_lotus"] = "weather/fx_snow_player_os_lotus";
}

