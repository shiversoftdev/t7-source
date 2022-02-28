// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\mp_freerun_02_fx;
#using scripts\mp\mp_freerun_02_sound;
#using scripts\shared\util_shared;

#namespace namespace_bbf5f0d7;

/*
	Name: main
	Namespace: namespace_bbf5f0d7
	Checksum: 0x2D395D7A
	Offset: 0x140
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	namespace_97daed88::main();
	namespace_e89da2ff::main();
	setdvar("phys_buoyancy", 1);
	setdvar("phys_ragdoll_buoyancy", 1);
	load::main();
	util::waitforclient(0);
}

