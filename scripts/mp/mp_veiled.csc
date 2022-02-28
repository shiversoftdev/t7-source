// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\mp_veiled_fx;
#using scripts\mp\mp_veiled_sound;
#using scripts\shared\util_shared;

#namespace mp_veiled;

/*
	Name: main
	Namespace: mp_veiled
	Checksum: 0x5DAEF1E1
	Offset: 0x128
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	namespace_f7008227::main();
	namespace_8f273e4e::main();
	load::main();
	util::waitforclient(0);
	level.endgamexcamname = "ui_cam_endgame_mp_veiled";
}

