// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;

#namespace zm_sumpf_ffotd;

/*
	Name: main_start
	Namespace: zm_sumpf_ffotd
	Checksum: 0x4F665B91
	Offset: 0x288
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
	Namespace: zm_sumpf_ffotd
	Checksum: 0x9DE33BEF
	Offset: 0x2B0
	Size: 0x464
	Parameters: 0
	Flags: Linked
*/
function main_end()
{
	spawncollision("collision_player_wall_128x128x10", "collider", (9885, 370, -464), (0, 0, 0));
	spawncollision("collision_player_wall_256x256x10", "collider", (10803, 1348, -403), (0, 0, 0));
	spawncollision("collision_player_slick_cylinder_32x256", "collider", (11466, 2531.5, -497.5), (0, 0, 0));
	spawncollision("collision_player_slick_cylinder_32x256", "collider", (11188.5, 2048.5, -493.5), (0, 0, 0));
	spawncollision("collision_player_slick_cylinder_32x256", "collider", (11669, -1209, -472.5), (0, 0, 0));
	spawncollision("collision_player_slick_cylinder_32x256", "collider", (9042.5, 2352, -493.5), (0, 0, 0));
	spawncollision("collision_player_slick_wedge_32x128", "collider", (11275.9, 3016.23, -561), (270, 359.7, 162.397));
	spawncollision("collision_player_slick_wall_512x512x10", "collider", (8507.29, 2104.91, -286), vectorscale((0, 1, 0), 45.3977));
	spawncollision("collision_player_slick_wall_512x512x10", "collider", (8501.29, 2099.41, -286), vectorscale((0, 1, 0), 45.3977));
	spawncollision("collision_player_slick_wall_256x256x10", "collider", (8642.89, 1961.76, -405), vectorscale((0, 1, 0), 45.3978));
	spawncollision("collision_player_slick_wall_256x256x10", "collider", (8852.88, 1832.77, -405), vectorscale((0, 1, 0), 70.7946));
	spawncollision("collision_player_slick_wall_256x256x10", "collider", (8864.88, 1826.76, -405), vectorscale((0, 1, 0), 64.3971));
	spawncollision("collision_player_slick_wall_256x256x10", "collider", (9056.33, 1795.77, -405), vectorscale((0, 1, 0), 106.998));
	spawncollision("collision_player_slick_wall_256x256x10", "collider", (9150.77, 1909.83, -405), vectorscale((0, 1, 0), 168.697));
	spawncollision("collision_player_slick_wall_256x256x10", "collider", (9103.76, 2038.19, -405), vectorscale((0, 1, 0), 230.897));
	spawncollision("collision_player_slick_wall_256x256x10", "collider", (8989.21, 2082.68, -405), vectorscale((0, 1, 0), 276.596));
	spawncollision("collision_player_slick_wall_256x256x10", "collider", (8859.2, 2042.16, -405), vectorscale((0, 1, 0), 298.195));
	spawncollision("collision_player_slick_wall_256x256x10", "collider", (8786.69, 1996.15, -404), vectorscale((0, 1, 0), 314.194));
}

/*
	Name: spawned_collision_ffotd
	Namespace: zm_sumpf_ffotd
	Checksum: 0x5FF83A99
	Offset: 0x720
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function spawned_collision_ffotd()
{
	level flagsys::wait_till("start_zombie_round_logic");
}

