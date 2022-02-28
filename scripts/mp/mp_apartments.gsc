// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\mp_apartments_amb;
#using scripts\mp\mp_apartments_fx;
#using scripts\shared\compass;

#namespace mp_apartments;

/*
	Name: main
	Namespace: mp_apartments
	Checksum: 0x515000AD
	Offset: 0x258
	Size: 0x63C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	mp_apartments_fx::main();
	level.add_raps_drop_locations = &add_raps_drop_locations;
	level.remotemissile_kill_z = 650 + 50;
	load::main();
	compass::setupminimap("compass_map_mp_apartments");
	mp_apartments_amb::main();
	setdvar("compassmaxrange", "2100");
	setdvar("phys_buoyancy", 1);
	setdvar("phys_ragdoll_buoyancy", 1);
	spawncollision("collision_clip_wall_256x256x10", "collider", (-944.403, -907.351, 1475.01), (0, 90, -90));
	board1 = spawn("script_model", (-895.394, -903.731, 1420.55));
	board1.angles = vectorscale((0, 0, -1), 90);
	board1 setmodel("p7_debris_wood_plywood_4x8_flat_white_wet");
	board2 = spawn("script_model", (-943.14, -904.731, 1420.55));
	board2.angles = vectorscale((0, 0, -1), 90);
	board2 setmodel("p7_debris_wood_plywood_4x8_flat_white_wet");
	var_aec24eee = spawn("script_model", (-996.733, -903.731, 1420.55));
	var_aec24eee.angles = vectorscale((0, 0, -1), 90);
	var_aec24eee setmodel("p7_debris_wood_plywood_4x8_flat_white_wet");
	var_f0b5eae1 = spawn("script_model", (-1043.21, -904.731, 1420.55));
	var_f0b5eae1.angles = vectorscale((0, 0, -1), 90);
	var_f0b5eae1 setmodel("p7_debris_wood_plywood_4x8_flat_white_wet");
	var_cab37078 = spawn("script_model", (-895.394, -904.731, 1393.59));
	var_cab37078.angles = vectorscale((0, 0, -1), 90);
	var_cab37078 setmodel("p7_debris_wood_plywood_4x8_flat_white_wet");
	var_3cbadfb3 = spawn("script_model", (-943.14, -905.731, 1393.59));
	var_3cbadfb3.angles = vectorscale((0, 0, -1), 90);
	var_3cbadfb3 setmodel("p7_debris_wood_plywood_4x8_flat_white_wet");
	var_16b8654a = spawn("script_model", (-996.733, -904.731, 1393.59));
	var_16b8654a.angles = vectorscale((0, 0, -1), 90);
	var_16b8654a setmodel("p7_debris_wood_plywood_4x8_flat_white_wet");
	var_58ac013d = spawn("script_model", (-1043.21, -905.731, 1393.59));
	var_58ac013d.angles = vectorscale((0, 0, -1), 90);
	var_58ac013d setmodel("p7_debris_wood_plywood_4x8_flat_white_wet");
	spawncollision("collision_clip_cylinder_32x128", "collider", (-2155.05, -1682.18, 1691.28), (0, 0, 0));
	spawncollision("collision_clip_cylinder_32x128", "collider", (-2155.05, -1682.18, 1799.26), (0, 0, 0));
	spawncollision("collision_clip_cylinder_32x128", "collider", (-2155.05, -1682.18, 1905.5), (0, 0, 0));
	level.cleandepositpoints = array((-2348.08, -639.428, 1215.81), (-186.08, -415.428, 1344.81), (70.9199, -1853.93, 1344.81), (-1352.58, -913.428, 1226.81), (-434.08, 660.072, 1346.81));
}

/*
	Name: add_raps_drop_locations
	Namespace: mp_apartments
	Checksum: 0xD7140F66
	Offset: 0x8A0
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function add_raps_drop_locations(&drop_candidate_array)
{
	if(!isdefined(drop_candidate_array))
	{
		drop_candidate_array = [];
	}
	else if(!isarray(drop_candidate_array))
	{
		drop_candidate_array = array(drop_candidate_array);
	}
	drop_candidate_array[drop_candidate_array.size] = (-560, -2020, 1355);
}

