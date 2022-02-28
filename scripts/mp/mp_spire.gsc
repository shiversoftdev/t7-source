// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\mp_spire_amb;
#using scripts\mp\mp_spire_fx;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;

#namespace mp_spire;

/*
	Name: main
	Namespace: mp_spire
	Checksum: 0x6FF256DB
	Offset: 0x3B0
	Size: 0xC2C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	clientfield::register("world", "mpSpireExteriorBillboard", 1, 2, "int");
	mp_spire_fx::main();
	level.add_raps_omit_locations = &add_raps_omit_locations;
	load::main();
	compass::setupminimap("compass_map_mp_spire");
	spawncollision("collision_clip_ramp_64x24", "collider", (4168.34, 708.791, -12.0068), (0, 0, 0));
	spawncollision("collision_clip_ramp_64x24", "collider", (4105.71, 708.791, -12.0068), (0, 0, 0));
	spawncollision("collision_clip_wall_256x256x10", "collider", (2424.57, -1527.01, 263.799), vectorscale((1, 0, 0), 2));
	spawncollision("collision_clip_wall_64x64x10", "collider", (2970.36, -1757.79, -21.7815), vectorscale((1, 0, 0), 342));
	spawncollision("collision_clip_wall_128x128x10", "collider", (1604.54, -1050.26, -120.822), (31, 270, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (1478.62, -1050.26, -120.822), (31, 270, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (1353.01, -1050.26, -120.822), (31, 270, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (1265.75, -1142.36, -120.822), (31, 360, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (1265.75, -1268.28, -120.822), (31, 360, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (1265.75, -1393.89, -120.822), (31, 360, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (1265.75, -1514.1, -120.822), (31, 360, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (1265.75, -1640.02, -120.822), (31, 360, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (1265.75, -1730.95, -120.822), (31, 360, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (3653.42, -1756.59, -75.2497), (24, 90, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (3744.35, -1756.59, -75.2497), (24, 90, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (3867.22, -1756.58, -75.2495), (24, 90, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (3932.69, -1756.58, -75.2495), (24, 90, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (4023.62, -1756.58, -75.2495), (24, 90, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (4101.56, -1679.67, -75.2495), (24, 180, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (4101.56, -1598.22, -75.2495), (24, 180, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (4101.56, -1507.29, -75.2495), (24, 180, 0));
	spawncollision("collision_clip_wall_64x64x10", "collider", (1261.61, 86.0638, 179.294), (0, 0, 0));
	spawncollision("collision_clip_wall_64x64x10", "collider", (1261.61, 79.3592, 179.294), (0, 0, 0));
	spawncollision("collision_clip_wall_64x64x10", "collider", (1261.61, 86.0638, 241.08), (0, 0, 0));
	spawncollision("collision_clip_wall_64x64x10", "collider", (1261.61, 79.3592, 241.08), (0, 0, 0));
	spawncollision("collision_clip_wall_64x64x10", "collider", (1261.61, 86.0638, 300.684), (0, 0, 0));
	spawncollision("collision_clip_wall_64x64x10", "collider", (1261.61, 79.3592, 300.684), (0, 0, 0));
	spawncollision("collision_clip_ramp_64x24", "collider", (3792, -1413, 140), vectorscale((0, 0, -1), 90));
	spawncollision("collision_clip_ramp_64x24", "collider", (3792, -1413, 204), (0, 180, 90));
	spawncollision("collision_clip_ramp_64x24", "collider", (3728, -1413, 140), vectorscale((0, 0, -1), 90));
	spawncollision("collision_clip_ramp_64x24", "collider", (3728, -1413, 204), (0, 180, 90));
	spawncollision("collision_clip_ramp_64x24", "collider", (3664, -1413, 140), vectorscale((0, 0, -1), 90));
	spawncollision("collision_clip_ramp_64x24", "collider", (3664, -1413, 204), (0, 180, 90));
	spawncollision("collision_clip_ramp_64x24", "collider", (2994, -892, 204), (0, 180, 90));
	spawncollision("collision_clip_ramp_64x24", "collider", (2726, -892, 204), (0, 180, 90));
	if(util::isprophuntgametype())
	{
		spawncollision("collision_clip_wall_256x256x10", "collider", (1641, -796, 76), (0, 0, 0));
	}
	mp_spire_amb::main();
	setdvar("compassmaxrange", "2100");
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
	level thread exterior_billboard_exploders();
	level.cleandepositpoints = array((2870.59, -134.119, 1.81104), (4107.7, 1370.67, 90.1926), (2856.95, -1234.69, -62.1478), (1233.53, 930.651, 2.22752), (3844.93, -603.359, 139.234));
	level spawnkilltrigger();
}

/*
	Name: exterior_billboard_exploders
	Namespace: mp_spire
	Checksum: 0x5F225608
	Offset: 0xFE8
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function exterior_billboard_exploders()
{
	currentexploder = randomint(4);
	while(true)
	{
		level clientfield::set("mpSpireExteriorBillboard", currentexploder);
		wait(6);
		currentexploder++;
		if(currentexploder >= 4)
		{
			currentexploder = 0;
		}
	}
}

/*
	Name: add_raps_omit_locations
	Namespace: mp_spire
	Checksum: 0xDB01E8AE
	Offset: 0x1070
	Size: 0x214
	Parameters: 1
	Flags: Linked
*/
function add_raps_omit_locations(&omit_locations)
{
	if(!isdefined(omit_locations))
	{
		omit_locations = [];
	}
	else if(!isarray(omit_locations))
	{
		omit_locations = array(omit_locations);
	}
	omit_locations[omit_locations.size] = (2480, 1269, 67);
	if(!isdefined(omit_locations))
	{
		omit_locations = [];
	}
	else if(!isarray(omit_locations))
	{
		omit_locations = array(omit_locations);
	}
	omit_locations[omit_locations.size] = (2609, 1440, 67);
	if(!isdefined(omit_locations))
	{
		omit_locations = [];
	}
	else if(!isarray(omit_locations))
	{
		omit_locations = array(omit_locations);
	}
	omit_locations[omit_locations.size] = (3089, 1437, 69);
	if(!isdefined(omit_locations))
	{
		omit_locations = [];
	}
	else if(!isarray(omit_locations))
	{
		omit_locations = array(omit_locations);
	}
	omit_locations[omit_locations.size] = (3223, 1224, 69);
	if(!isdefined(omit_locations))
	{
		omit_locations = [];
	}
	else if(!isarray(omit_locations))
	{
		omit_locations = array(omit_locations);
	}
	omit_locations[omit_locations.size] = (2434, 1093, 67);
}

/*
	Name: spawnkilltrigger
	Namespace: mp_spire
	Checksum: 0x434201CD
	Offset: 0x1290
	Size: 0x324
	Parameters: 0
	Flags: Linked
*/
function spawnkilltrigger()
{
	trigger = spawn("trigger_radius", (4303, 1421, 88), 0, 8, 72);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (4303, 1449, 88), 0, 8, 72);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (4303, 1477, 88), 0, 8, 72);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (4303, 1505, 88), 0, 8, 72);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (3776, -1472, 114), 0, 40, 128);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (3700, -1472, 114), 0, 40, 128);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (3624, -1472, 114), 0, 40, 128);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (3060, -992, 232), 0, 40, 72);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (2660, -992, 232), 0, 40, 72);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (4052, -544, 88), 0, 16, 256);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (4084, -512, 88), 0, 48, 256);
	trigger thread watchkilltrigger();
}

/*
	Name: watchkilltrigger
	Namespace: mp_spire
	Checksum: 0x28F59F8B
	Offset: 0x15C0
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

