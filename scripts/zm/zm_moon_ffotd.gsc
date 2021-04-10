// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace zm_moon_ffotd;

/*
	Name: main_start
	Namespace: zm_moon_ffotd
	Checksum: 0x79BC6F84
	Offset: 0x220
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function main_start()
{
	level thread spawned_collision_ffotd();
}

/*
	Name: main_end
	Namespace: zm_moon_ffotd
	Checksum: 0xFFC7C037
	Offset: 0x248
	Size: 0x43C
	Parameters: 0
	Flags: Linked
*/
function main_end()
{
	spawncollision("collision_player_64x64x256", "collider", (76, 5552, 328), vectorscale((0, 1, 0), 270));
	spawncollision("collision_player_64x64x256", "collider", (76, 5552, 584), vectorscale((0, 1, 0), 270));
	spawncollision("collision_player_64x64x256", "collider", (140, 5552, 328), vectorscale((0, 1, 0), 270));
	spawncollision("collision_player_64x64x256", "collider", (140, 5552, 584), vectorscale((0, 1, 0), 270));
	spawncollision("collision_player_wall_512x512x10", "collider", (1473, 6312, 712), vectorscale((0, 1, 0), 240));
	spawncollision("collision_player_wall_256x256x10", "collider", (-590, 1165, -165), (0, 0, 0));
	spawncollision("collision_player_wall_256x256x10", "collider", (66.933, 7228.8, 221.5), vectorscale((0, 1, 0), 322.599));
	spawncollision("collision_player_wall_256x256x10", "collider", (45.067, 7200.2, 221.5), vectorscale((0, 1, 0), 322.599));
	spawncollision("collision_player_wall_256x256x10", "collider", (175.961, 7144.78, 223.472), vectorscale((0, 1, 0), 322.399));
	spawncollision("collision_player_wall_256x256x10", "collider", (153.995, 7116.25, 223.472), vectorscale((0, 1, 0), 322.399));
	spawncollision("collision_player_slick_wedge_32x256", "collider", (198.789, 7135.46, 344.998), (271.276, 284.062, 128.652));
	spawncollision("collision_player_slick_wedge_32x256", "collider", (170.789, 7098.46, 344.998), (271.276, 284.062, 128.652));
	spawncollision("collision_player_slick_wedge_32x256", "collider", (76.289, 7229.46, 344.998), (271.276, 284.062, 128.652));
	spawncollision("collision_player_slick_wedge_32x256", "collider", (48.289, 7192.46, 344.998), (271.276, 284.062, 128.652));
	spawncollision("collision_player_slick_wedge_32x256", "collider", (-155.692, 3850.08, -52.5), vectorscale((0, 1, 0), 175.099));
}

/*
	Name: spawned_collision_ffotd
	Namespace: zm_moon_ffotd
	Checksum: 0x7FE1B62
	Offset: 0x690
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function spawned_collision_ffotd()
{
	level flagsys::wait_till("start_zombie_round_logic");
}

