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

#namespace namespace_8cf14dc8;

/*
	Name: function_7403e82b
	Namespace: namespace_8cf14dc8
	Checksum: 0xCFEA1CD7
	Offset: 0x250
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_7403e82b()
{
	spawncollision("collision_clip_wall_128x128x10", "collider", (16141, -864, 416), (0, 0, 0));
	spawncollision("collision_clip_wall_512x512x10", "collider", (8004.5, 4701, 384), vectorscale((0, 1, 0), 315));
	spawncollision("collision_clip_wall_512x512x10", "collider", (8260.5, 4957, 384), vectorscale((0, 1, 0), 315));
	spawncollision("collision_clip_wall_512x512x10", "collider", (9652.5, 6349, 384), vectorscale((0, 1, 0), 315));
	spawncollision("collision_clip_wall_512x512x10", "collider", (9908.5, 6605, 384), vectorscale((0, 1, 0), 315));
}

