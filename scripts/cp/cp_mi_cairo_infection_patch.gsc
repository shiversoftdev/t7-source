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

#namespace namespace_bb56f921;

/*
	Name: function_7403e82b
	Namespace: namespace_bb56f921
	Checksum: 0x8F908A4C
	Offset: 0x278
	Size: 0x38C
	Parameters: 0
	Flags: Linked
*/
function function_7403e82b()
{
	spawncollision("collision_player_wall_128x128x10", "collider", (-24656, 25652, -20092), vectorscale((0, 1, 0), 53.1976));
	spawncollision("collision_player_wall_256x256x10", "collider", (-24648, 25644, -19668), vectorscale((0, 1, 0), 53.1976));
	spawncollision("collision_player_512x512x512", "collider", (-27414, 23904, -19739), vectorscale((0, 1, 0), 52.599));
	spawncollision("collision_player_512x512x512", "collider", (-25916, 26552, -19428), (0, 0, 0));
	spawncollision("collision_player_512x512x512", "collider", (-25936, 23320, -19432), (0, 0, 0));
	spawncollision("collision_player_512x512x512", "collider", (-27312.4, 26014, -19601), vectorscale((0, 1, 0), 289.596));
	spawncollision("collision_player_512x512x512", "collider", (-27343, 25914, -19601), vectorscale((0, 1, 0), 306.197));
	spawncollision("collision_player_512x512x512", "collider", (-24511.6, 23778, -19585), vectorscale((0, 1, 0), 109.596));
	spawncollision("collision_player_512x512x512", "collider", (-27494.7, 25875.8, -19601), vectorscale((0, 1, 0), 326.696));
	spawncollision("collision_player_512x512x512", "collider", (-24329.3, 23916.2, -19585), vectorscale((0, 1, 0), 146.696));
	spawncollision("collision_player_512x512x512", "collider", (-24481, 23878, -19585), vectorscale((0, 1, 0), 126.197));
	spawncollision("collision_player_512x512x512", "collider", (-24481, 23878, -20097), vectorscale((0, 1, 0), 126.197));
	spawncollision("collision_player_512x512x512", "collider", (-25920, 23344, -19944), (0, 0, 0));
	spawncollision("collision_player_512x512x512", "collider", (-27343, 25914, -20113), vectorscale((0, 1, 0), 306.197));
	spawncollision("collision_player_512x512x512", "collider", (-25916, 26552, -19940), (0, 0, 0));
}

