// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_load;
#using scripts\cp\_safehouse;
#using scripts\cp\_util;
#using scripts\cp\cp_sh_mobile_fx;
#using scripts\cp\cp_sh_mobile_sound;
#using scripts\shared\util_shared;

#namespace cp_sh_mobile;

/*
	Name: main
	Namespace: cp_sh_mobile
	Checksum: 0xCDC3052B
	Offset: 0x130
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	namespace_43c49144::main();
	namespace_94ce943b::main();
	load::main();
	util::waitforclient(0);
}

