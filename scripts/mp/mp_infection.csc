// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\mp_infection_fx;
#using scripts\mp\mp_infection_sound;
#using scripts\shared\util_shared;

#namespace namespace_82e4b148;

/*
	Name: main
	Namespace: namespace_82e4b148
	Checksum: 0x1BEE8B2B
	Offset: 0x138
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	namespace_5d379c9::main();
	namespace_83fbe97c::main();
	load::main();
	util::waitforclient(0);
	level.endgamexcamname = "ui_cam_endgame_mp_infection";
}

