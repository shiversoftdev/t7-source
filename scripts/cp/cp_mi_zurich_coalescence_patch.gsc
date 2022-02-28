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

#namespace namespace_98d4ffda;

/*
	Name: function_7403e82b
	Namespace: namespace_98d4ffda
	Checksum: 0x9B1666BE
	Offset: 0x390
	Size: 0xA0C
	Parameters: 0
	Flags: Linked
*/
function function_7403e82b()
{
	spawncollision("collision_clip_ramp_256x24", "collider", (-9254.16, 39197.2, 224), (270, 0.6, 23.9983));
	trashcan1 = spawn("script_model", (-9245.16, 39172.6, 218));
	trashcan1 setmodel("p7_trashcan_modern");
	trashcan1.angles = (270, 0, -74.4002);
	spawncollision("collision_clip_256x256x256", "collider", (-8504, 39076, 479), vectorscale((0, 1, 0), 30));
	spawncollision("collision_clip_ramp_256x24", "collider", (-8405.77, 39045.1, 334), (270, 176.8, 121.199));
	var_8be7032a = spawn("script_model", (-5716.98, 31237, 547.879));
	var_8be7032a setmodel("p7_zur_train_car_edge_dmg_05");
	var_8be7032a.angles = (355.189, 47.8194, -120.389);
	var_65e488c1 = spawn("script_model", (-5760.47, 31267.3, 308.93));
	var_65e488c1 setmodel("p7_zur_train_car_edge_dmg_02");
	var_65e488c1.angles = (337.484, 281.216, 99.1247);
	var_3fe20e58 = spawn("script_model", (-6518.81, 30941.7, 176.015));
	var_3fe20e58 setmodel("p7_zur_train_car_skin_dmg_01");
	var_3fe20e58.angles = (351.987, 75.1683, -4.03644);
	var_49f36737 = spawn("script_model", (-6485.54, 30460.5, 198.488));
	var_49f36737 setmodel("p7_zur_train_car_edge_dmg_05");
	var_49f36737.angles = (11.2407, 229.841, 104.039);
	var_23f0ecce = spawn("script_model", (-6122.86, 30594.1, 280.335));
	var_23f0ecce setmodel("p7_zur_train_car_edge_dmg_03");
	var_23f0ecce.angles = (29.4188, 359.72, 22.1248);
	var_fdee7265 = spawn("script_model", (-5854.61, 30512.1, 191.353));
	var_fdee7265 setmodel("p7_zur_train_car_brake_flap_36");
	var_fdee7265.angles = (32.5247, 68.9213, -7.60235);
	var_d7ebf7fc = spawn("script_model", (-5350.87, 33183.2, 182.559));
	var_d7ebf7fc setmodel("p7_zur_train_car_edge_dmg_04");
	var_d7ebf7fc.angles = (337.14, 221.006, -1.37542);
	var_81d5aa4b = spawn("script_model", (-5412.42, 33386.2, 17.3489));
	var_81d5aa4b setmodel("p7_zur_train_car_edge_dmg_03");
	var_81d5aa4b.angles = (34.4782, 246.3, 155.965);
	spawncollision("collision_clip_256x256x256", "collider", (-2341, 4879, 1635), vectorscale((0, 1, 0), 10.8));
	spawncollision("collision_clip_256x256x256", "collider", (-2400, 5102, 1635), vectorscale((0, 1, 0), 18.2));
	spawncollision("collision_clip_256x256x256", "collider", (-1997.05, 5544.87, 1813.57), (19.8352, 194.39, -146.069));
	spawncollision("collision_clip_32x32x128", "collider", (-2163, 4835, 1769), (0, 0, 0));
	spawncollision("collision_clip_wall_256x256x10", "collider", (-2023, 5384, 1814), (339, 20, 0));
	spawncollision("collision_clip_wall_256x256x10", "collider", (-1959, 5151, 1799), (320.599, 15, 0));
	spawncollision("collision_clip_256x256x256", "collider", (1848, 3982, 1940), (0, 0, 0));
	spawncollision("collision_clip_512x512x512", "collider", (1608, 3672, 2068), vectorscale((0, 1, 0), 345));
	spawncollision("collision_clip_256x256x256", "collider", (1702, 3304, 1940), vectorscale((0, 1, 0), 30));
	spawncollision("collision_clip_ramp_256x24", "collider", (10038.7, -21701.7, 1114.84), (355.809, 139.748, 4.21038));
	spawncollision("collision_clip_wall_256x256x10", "collider", (-30219, 2184, 1208), vectorscale((0, 1, 0), 4.1998));
	spawncollision("collision_clip_wall_256x256x10", "collider", (-30715, 3607, 1208), (354.801, 275.199, -0.185018));
	spawncollision("collision_clip_wall_256x256x10", "collider", (-31035, 3584, 1208), (349.401, 275.217, -0.187282));
	spawncollision("collision_clip_512x512x512", "collider", (-10122, 39836, 863), vectorscale((0, 1, 0), 30.8));
	spawncollision("collision_clip_512x512x512", "collider", (-10561, 39575, 863), vectorscale((0, 1, 0), 30.8));
	spawncollision("collision_clip_wall_512x512x10", "collider", (-6091, 37379, 401), vectorscale((0, 1, 0), 299.399));
	spawncollision("collision_clip_wall_512x512x10", "collider", (-5922, 37091, 401), vectorscale((0, 1, 0), 299.399));
	spawncollision("collision_clip_wall_512x512x10", "collider", (-9153, 35614, 401), vectorscale((0, 1, 0), 299.399));
	spawncollision("collision_clip_wall_512x512x10", "collider", (-8984, 35326, 401), vectorscale((0, 1, 0), 299.399));
}

