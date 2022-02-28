// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\core\_multi_extracam;
#using scripts\core\core_frontend_fx;
#using scripts\core\core_frontend_sound;
#using scripts\shared\scene_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace core_frontend;

/*
	Name: main
	Namespace: core_frontend
	Checksum: 0xCB5F049B
	Offset: 0x198
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function main()
{
	core_frontend_fx::main();
	core_frontend_sound::main();
	util::waitforclient(0);
	forcestreamxmodel("p7_monitor_wall_theater_01");
}

