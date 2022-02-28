// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\core\core_frontend_fx;
#using scripts\core\core_frontend_sound;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#namespace core_frontend;

/*
	Name: main
	Namespace: core_frontend
	Checksum: 0xA6476A3D
	Offset: 0x148
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache();
	core_frontend_fx::main();
	core_frontend_sound::main();
	setdvar("compassmaxrange", "2100");
}

/*
	Name: precache
	Namespace: core_frontend
	Checksum: 0x99EC1590
	Offset: 0x1A8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache()
{
}

