// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_util;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_quadtank;

#namespace namespace_643bc20;

/*
	Name: function_7403e82b
	Namespace: namespace_643bc20
	Checksum: 0xB2BEBC25
	Offset: 0x268
	Size: 0x334
	Parameters: 0
	Flags: Linked
*/
function function_7403e82b()
{
	spawncollision("collision_clip_wall_256x256x10", "collider", (-560, 1793, -1264), vectorscale((0, 1, 0), 304.999));
	spawncollision("collision_clip_wall_256x256x10", "collider", (24832, 1744, -6808), vectorscale((0, 1, 0), 270));
	spawncollision("collision_clip_wall_256x256x10", "collider", (24704, 1424, -6808), vectorscale((0, 1, 0), 270));
	spawncollision("collision_clip_512x512x512", "collider", (-56.6863, -362.706, -2184), vectorscale((0, 1, 0), 255.999));
	spawncollision("collision_clip_512x512x512", "collider", (-507.636, -165.595, -2184), vectorscale((0, 1, 0), 229.9));
	spawncollision("collision_clip_512x512x512", "collider", (-853.325, 1393.89, -2184), vectorscale((0, 1, 0), 65.199));
	spawncollision("collision_clip_512x512x512", "collider", (-464.19, 1867.93, -2184), vectorscale((0, 1, 0), 30.2));
	spawncollision("collision_clip_512x512x512", "collider", (-35, 2064, -2184), vectorscale((0, 1, 0), 20.2));
	spawncollision("collision_clip_256x256x256", "collider", (-641.069, 170.047, -2264), vectorscale((0, 1, 0), 36.098));
	spawncollision("collision_clip_256x256x256", "collider", (-775.342, 390.502, -2264), vectorscale((0, 1, 0), 25.298));
	spawncollision("collision_clip_256x256x256", "collider", (-866.006, 660.644, -2264), vectorscale((0, 1, 0), 11.599));
	spawncollision("collision_clip_256x256x256", "collider", (-868, 962, -2264), vectorscale((0, 1, 0), 348.6));
	spawncollision("collision_clip_512x512x512", "collider", (-2016, -1104, -4888), (0, 0, 0));
}

