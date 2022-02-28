// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\mp_havoc_fx;
#using scripts\mp\mp_havoc_sound;
#using scripts\shared\_oob;
#using scripts\shared\compass;
#using scripts\shared\util_shared;

#namespace mp_havoc;

/*
	Name: main
	Namespace: mp_havoc
	Checksum: 0xBBBBF0D1
	Offset: 0x188
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function main()
{
	trigger = spawn("trigger_radius_out_of_bounds", (1957.05, 1538.25, -112.32), 0, 125, 350);
	trigger thread oob::run_oob_trigger();
	precache();
	mp_havoc_fx::main();
	mp_havoc_sound::main();
	load::main();
	compass::setupminimap("compass_map_mp_havoc");
	setdvar("compassmaxrange", "2100");
	level.cleandepositpoints = array((1.29624, -584.847, 136.125), (-1513.77, -791.715, 8.125), (419.803, 1107.09, 8.93066), (300.251, -1300.87, 8.125));
}

/*
	Name: precache
	Namespace: mp_havoc
	Checksum: 0x99EC1590
	Offset: 0x2E8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache()
{
}

