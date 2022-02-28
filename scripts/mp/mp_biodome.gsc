// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\mp_biodome_fx;
#using scripts\mp\mp_biodome_sound;
#using scripts\shared\_oob;
#using scripts\shared\compass;
#using scripts\shared\util_shared;

#namespace namespace_86fa17e8;

/*
	Name: main
	Namespace: namespace_86fa17e8
	Checksum: 0xBA58C87E
	Offset: 0x390
	Size: 0x6FC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache();
	setdvar("phys_buoyancy", 1);
	namespace_d22f7529::main();
	namespace_8911e65c::main();
	level.remotemissile_kill_z = -130 + 50;
	load::main();
	compass::setupminimap("compass_map_mp_biodome");
	setdvar("compassmaxrange", "2100");
	spawncollision("collision_clip_512x512x512", "collider", (744, 1696, 920), (0, 0, 0));
	spawncollision("collision_clip_512x512x512", "collider", (744, 2208, 920), (0, 0, 0));
	spawncollision("collision_clip_512x512x512", "collider", (1256, 1696, 920), (0, 0, 0));
	spawncollision("collision_clip_512x512x512", "collider", (1256, 2208, 920), (0, 0, 0));
	spawncollision("collision_clip_256x256x256", "collider", (3454.82, 1094.87, 499.607), (0, 270, -90));
	spawncollision("collision_clip_256x256x256", "collider", (3454.82, 706.47, 499.607), (0, 270, -90));
	spawncollision("collision_clip_wall_64x64x10", "collider", (1640, -178.5, 150.5), vectorscale((0, 1, 0), 270));
	spawncollision("collision_clip_wall_64x64x10", "collider", (1580.5, -180.5, 141), vectorscale((0, 1, 0), 270));
	spawncollision("collision_clip_wall_64x64x10", "collider", (1640, -180.5, 141), vectorscale((0, 1, 0), 270));
	spawncollision("collision_clip_wall_128x128x10", "collider", (588, 245, 263), (1, 0, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (588, 358.5, 263), (1, 0, 0));
	spawncollision("collision_clip_wall_64x64x10", "collider", (-249, 817, 175.5), (0, 0, 0));
	spawncollision("collision_clip_wall_64x64x10", "collider", (-219.5, 844, 175.5), vectorscale((0, 1, 0), 270));
	spawncollision("collision_clip_cylinder_32x256", "collider", (1549, -350, 194), (0, 0, 0));
	spawncollision("collision_clip_cylinder_32x256", "collider", (1549, -350, 435.5), (0, 0, 0));
	spawncollision("collision_clip_cylinder_32x256", "collider", (1549, -350, 649.5), (0, 0, 0));
	if(util::isprophuntgametype())
	{
		spawncollision("collision_clip_wall_64x64x10", "collider", (-1745, 1550, 248), (0, 0, 0));
	}
	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_MAPNAME_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_MAPNAME_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_MAPNAME_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_MAPNAME_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_MAPNAME_E";
	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_MAPNAME_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_MAPNAME_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_MAPNAME_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_MAPNAME_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_MAPNAME_E";
	level spawnkilltrigger();
	trigger = spawn("trigger_radius", (3516, 620, 111), 0, 256, 50);
	trigger thread oob::run_oob_trigger();
	trigger = spawn("trigger_radius", (2182, 2176.5, -32.5), 0, 100, 256);
	trigger thread oob::run_oob_trigger();
	level.cleandepositpoints = array((-52.4927, 1252.1, 104.125), (330.408, 2402.64, 232.204), (-139.434, -303.555, 138.836), (-362.325, 325.108, 104.125));
}

/*
	Name: precache
	Namespace: namespace_86fa17e8
	Checksum: 0x99EC1590
	Offset: 0xA98
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache()
{
}

/*
	Name: spawnkilltrigger
	Namespace: namespace_86fa17e8
	Checksum: 0x9E942F27
	Offset: 0xAA8
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function spawnkilltrigger()
{
	trigger = spawn("trigger_radius", (4147.22, 1095.25, -33.0108), 0, 500, 500);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (4147.22, 590.28, -33.0108), 0, 500, 500);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (-202, 797, 135.5), 0, 50, 200);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (-162, 2442, -47), 0, 25, 60);
	trigger thread watchkilltrigger();
}

/*
	Name: watchkilltrigger
	Namespace: namespace_86fa17e8
	Checksum: 0x8C913160
	Offset: 0xBF0
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function watchkilltrigger()
{
	level endon(#"game_ended");
	trigger = self;
	while(true)
	{
		trigger waittill(#"trigger", player);
		player dodamage(1000, trigger.origin + (0, 0, 0), trigger, trigger, "none", "MOD_SUICIDE", 0);
	}
}

