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

#namespace namespace_82e422e5;

/*
	Name: function_7403e82b
	Namespace: namespace_82e422e5
	Checksum: 0x9CAB742F
	Offset: 0x250
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_7403e82b()
{
	spawncollision("collision_clip_256x256x256", "collider", (25736, -33728, -7352), (0, 0, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (22624, -9931.75, -7287), vectorscale((0, 1, 0), 270));
}

