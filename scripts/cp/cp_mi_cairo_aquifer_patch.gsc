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

#namespace namespace_a52a2a1d;

/*
	Name: function_7403e82b
	Namespace: namespace_a52a2a1d
	Checksum: 0xFF5EBD78
	Offset: 0x238
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_7403e82b()
{
	spawncollision("collision_clip_wall_512x512x10", "collider", (11119, 2965, 2620), vectorscale((0, 1, 0), 270));
}

