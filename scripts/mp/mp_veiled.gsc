// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\mp_veiled_fx;
#using scripts\mp\mp_veiled_sound;
#using scripts\shared\compass;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#namespace mp_veiled;

/*
	Name: main
	Namespace: mp_veiled
	Checksum: 0xAD65A792
	Offset: 0x2D8
	Size: 0x33C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache();
	spawnlogic::move_spawn_point("mp_dm_spawn_start", (1687.56, -465.166, 45.625), (-1164.6, 603.783, 29.625), vectorscale((0, 1, 0), 315.516));
	namespace_f7008227::main();
	namespace_8f273e4e::main();
	load::main();
	compass::setupminimap("compass_map_mp_veiled");
	setdvar("compassmaxrange", "2100");
	spawncollision("collision_clip_wall_32x32x10", "collider", (-2091.09, 803.526, 140.663), (27, 82, -2));
	spawncollision("collision_clip_wall_32x32x10", "collider", (-1905.67, 876.398, 140.663), (27, 97, 2));
	spawncollision("collision_clip_wall_128x128x10", "collider", (881, -352, 116), (0, 0, 0));
	spawncollision("collision_clip_wall_128x128x10", "collider", (885, -352, 116), (0, 0, 0));
	if(util::isprophuntgametype())
	{
		spawncollision("collision_clip_wall_256x256x10", "collider", (-2043.05, 820.365, 156.942), (0, 113.394, 90));
		spawncollision("collision_clip_wall_256x256x10", "collider", (-1970.05, 854.365, 368), (0, 113.394, 90));
		spawncollision("collision_clip_wall_256x256x10", "collider", (-1970.05, 854.365, 541.5), (0, 113.394, 90));
	}
	level.cleandepositpoints = array((-63.6408, -499.434, -19.875), (-1363.59, 509.905, -20.1416), (1362.85, -166.119, 1.5134), (-237.83, 1105.17, 10));
	level thread rocket_launch();
}

/*
	Name: precache
	Namespace: mp_veiled
	Checksum: 0x99EC1590
	Offset: 0x620
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache()
{
}

/*
	Name: rocket_launch
	Namespace: mp_veiled
	Checksum: 0x80B207EB
	Offset: 0x630
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function rocket_launch()
{
	var_c6821b9b = 15;
	var_810de4c4 = 45;
	var_7b825480 = 120;
	var_da509659 = 120;
	wait(var_c6821b9b + var_810de4c4);
	var_13d61abf = struct::get("tag_align_rocket_2", "targetname");
	var_13d61abf thread scene::play("p7_fxanim_mp_veiled_rocket_launch_2");
	playsoundatposition("evt_rocket_launch_01", (-4313, 623, 316));
	wait(var_7b825480);
	var_a1ceab84 = struct::get("tag_align_rocket_1", "targetname");
	var_a1ceab84 thread scene::play("p7_fxanim_mp_veiled_rocket_launch_1");
	playsoundatposition("evt_rocket_launch_01", (-4313, 623, 316));
	wait(var_da509659);
	var_edd3a056 = struct::get("tag_align_rocket_3", "targetname");
	var_edd3a056 thread scene::play("p7_fxanim_mp_veiled_rocket_launch_3");
	playsoundatposition("evt_rocket_launch_01", (-3696, -2879, 322));
}

