// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\mp_freerun_01_fx;
#using scripts\mp\mp_freerun_01_sound;
#using scripts\shared\util_shared;

#namespace namespace_49ee819c;

/*
	Name: main
	Namespace: namespace_49ee819c
	Checksum: 0xF21B9A
	Offset: 0x140
	Size: 0x8C
	Parameters: 0
	Flags: None
*/
function main()
{
	namespace_b046f355::main();
	namespace_db5bc658::main();
	setdvar("phys_buoyancy", 1);
	setdvar("phys_ragdoll_buoyancy", 1);
	load::main();
	util::waitforclient(0);
}

