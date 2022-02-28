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

#namespace namespace_814e90c0;

/*
	Name: function_7403e82b
	Namespace: namespace_814e90c0
	Checksum: 0x5886DEAA
	Offset: 0x310
	Size: 0xA1C
	Parameters: 0
	Flags: Linked
*/
function function_7403e82b()
{
	collision1 = spawn("script_model", (-5538, 9256, 163));
	collision1 setmodel("p7_shelf_modern_02_e");
	collision1.angles = vectorscale((0, 1, 0), 180);
	collision1 = spawn("script_model", (-5693, 9256, 320));
	collision1 setmodel("p7_shelf_modern_02_e");
	collision1.angles = vectorscale((0, 1, 0), 180);
	collision1 = spawn("script_model", (-5760, 9256, 320));
	collision1 setmodel("p7_shelf_modern_02_e");
	collision1.angles = vectorscale((0, 1, 0), 180);
	spawncollision("collision_clip_wall_256x256x10", "collider", (-1757, 10725, 288), vectorscale((0, 1, 0), 350));
	spawncollision("collision_clip_wall_256x256x10", "collider", (-1776, 10621, 288), vectorscale((0, 1, 0), 350));
	spawncollision("collision_clip_wall_256x256x10", "collider", (-1757, 10725, 544), vectorscale((0, 1, 0), 350));
	spawncollision("collision_clip_wall_256x256x10", "collider", (-1776, 10621, 544), vectorscale((0, 1, 0), 350));
	spawncollision("collision_clip_wall_512x512x10", "collider", (5717, 2562, 852), (0, 0, 0));
	spawncollision("collision_clip_wall_512x512x10", "collider", (5717, 2446, 852), (0, 0, 0));
	spawncollision("collision_clip_wall_256x256x10", "collider", (8607, 6518, 520), vectorscale((0, 1, 0), 135));
	spawncollision("collision_clip_wall_256x256x10", "collider", (8607, 6518, 264), vectorscale((0, 1, 0), 135));
	spawncollision("collision_clip_wall_256x256x10", "collider", (8523, 6434, 520), vectorscale((0, 1, 0), 135));
	spawncollision("collision_clip_wall_256x256x10", "collider", (8523, 6434, 264), vectorscale((0, 1, 0), 135));
	spawncollision("collision_player_wall_256x256x10", "collider", (7192, 3771, 264), vectorscale((0, 1, 0), 270));
	spawncollision("collision_player_wall_256x256x10", "collider", (7258, 3771, 264), vectorscale((0, 1, 0), 270));
	spawncollision("collision_clip_128x128x128", "collider", (8710, 4706, -26), (0, 0, 0));
	spawncollision("collision_clip_wall_512x512x10", "collider", (-3026, 11244, 258), (0, 0, 0));
	spawncollision("collision_clip_wall_512x512x10", "collider", (-3026, 11244, 770), (0, 0, 0));
	spawncollision("collision_clip_wall_512x512x10", "collider", (-2796.61, 11464.8, 258), vectorscale((0, 1, 0), 263.4));
	spawncollision("collision_clip_wall_512x512x10", "collider", (-2796.61, 11464.8, 770), vectorscale((0, 1, 0), 263.4));
	spawncollision("collision_clip_wall_512x512x10", "collider", (-2288, 11406, 258), vectorscale((0, 1, 0), 263.4));
	spawncollision("collision_clip_wall_512x512x10", "collider", (-2288, 11406, 770), vectorscale((0, 1, 0), 263.4));
	spawncollision("collision_clip_wall_512x512x10", "collider", (-1779.39, 11347.2, 258), vectorscale((0, 1, 0), 263.4));
	spawncollision("collision_clip_wall_512x512x10", "collider", (-1779.39, 11347.2, 770), vectorscale((0, 1, 0), 263.4));
	spawncollision("collision_clip_wall_512x512x10", "collider", (-1552, 11074, 258), (0, 0, 0));
	spawncollision("collision_clip_wall_512x512x10", "collider", (-1552, 11074, 770), (0, 0, 0));
	spawncollision("collision_player_256x256x256", "collider", (-4146, 9465, -136), (0, 0, 0));
	spawncollision("collision_player_256x256x256", "collider", (-4070, 9465, -136), (0, 0, 0));
	model1 = spawn("script_model", (-1664.21, 2488.96, -415.985));
	model1 setmodel("p7_sin_ship_container_384_blue");
	model1.angles = (275.738, 51.9803, -143.901);
	spawncollision("collision_player_256x256x256", "collider", (-1739.08, 2506.11, -370.376), (273.8, 358.4, 1.30979E-05));
	spawncollision("collision_player_256x256x256", "collider", (-1588.17, 2501.89, -380.374), (273.8, 358.4, 1.30979E-05));
	spawncollision("collision_player_wall_512x512x10", "collider", (-1872, 2480, -248), vectorscale((0, 1, 0), 270));
	spawncollision("collision_player_wall_512x512x10", "collider", (-1872, 2500, -248), vectorscale((0, 1, 0), 270));
	model2 = spawn("script_model", (-4339.17, 10311.4, 163));
	model2 setmodel("p7_shelf_modern_02_e");
	model2.angles = vectorscale((0, 1, 0), 2.59983);
	model3 = spawn("script_model", (-4413.11, 10310, 163));
	model3 setmodel("p7_shelf_modern_02_e");
	model3.angles = vectorscale((0, 1, 0), 356);
	var_5b36c229 = spawncollision("collision_clip_128x128x128", "collider", (-4348, 10350, 148), vectorscale((0, 1, 0), 180));
	var_5b36c229 disconnectpaths();
	var_81393c92 = spawncollision("collision_clip_128x128x128", "collider", (-4392, 10350, 148), vectorscale((0, 1, 0), 180));
	var_81393c92 disconnectpaths();
}

