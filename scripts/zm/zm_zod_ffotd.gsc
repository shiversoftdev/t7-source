// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ffotd;

#namespace zm_zod_ffotd;

/*
	Name: main_start
	Namespace: zm_zod_ffotd
	Checksum: 0x74C57C4D
	Offset: 0x488
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function main_start()
{
	level.var_42792b8b = 1;
	var_aab32ea1 = struct::get("zone_canal_junction", "script_noteworthy");
	var_eab52f41 = struct::get_array(var_aab32ea1.target, "targetname");
	foreach(var_fae9adb3 in var_eab52f41)
	{
		var_fae9adb3.origin = var_fae9adb3.origin + vectorscale((0, 0, 1), 12);
		switch(var_fae9adb3.script_int)
		{
			case 1:
			{
				var_fae9adb3.origin = var_fae9adb3.origin + (vectorscale((-1, 0, 0), 7));
				break;
			}
			case 4:
			{
				var_fae9adb3.origin = var_fae9adb3.origin + vectorscale((1, 0, 0), 5);
				break;
			}
		}
	}
}

/*
	Name: main_end
	Namespace: zm_zod_ffotd
	Checksum: 0xF1F49EF1
	Offset: 0x628
	Size: 0xA54
	Parameters: 0
	Flags: Linked
*/
function main_end()
{
	zm::spawn_life_brush((1296, -1916, 660), 128, 128);
	zm::spawn_life_brush((2497, -5395, 444), 256, 400);
	if(!zm_ffotd::optimize_for_splitscreen())
	{
		spawncollision("collision_clip_ramp_128x24", "collider", (4020.93, -4314, 334.084), (0, 90, 105));
		spawncollision("collision_clip_wall_64x64x10", "collider", (4992.73, -2742.56, 464), vectorscale((0, 1, 0), 315));
		spawncollision("collision_utility_wall_128x128x10", "collider", (4640, -4802, 702), vectorscale((0, 1, 0), 315));
		spawncollision("collision_utility_wall_128x128x10", "collider", (4550, -4806, 702), vectorscale((0, 1, 0), 225));
		spawncollision("collision_clip_wall_128x128x10", "collider", (1980, -5356, 390), (0, 0, 0));
		spawncollision("collision_player_wall_256x256x10", "collider", (2216, -4036, 254), vectorscale((0, 1, 0), 270));
		spawncollision("collision_player_32x32x32", "collider", (2494, -2717, -224), (0, 0, 0));
		spawncollision("collision_player_32x32x32", "collider", (2734, -2717, -224), (0, 0, 0));
		spawncollision("collision_player_32x32x32", "collider", (3174, -3141, -288), (0, 0, 0));
		spawncollision("collision_player_32x32x32", "collider", (2062, -3141, -288), (0, 0, 0));
		spawncollision("collision_player_slick_wedge_32x128", "collider", (2602, -4694, -298), (270, 180, 0));
	}
	zm::spawn_life_brush((1896, -8240, 240), 112, 148);
	zm::spawn_life_brush((2624, -2972, -504), 512, 72);
	if(!zm_ffotd::optimize_for_splitscreen())
	{
		spawncollision("collision_clip_ramp_128x24", "collider", (2100.11, -8145.07, 123.5), (353.999, 270, 19.3998));
		spawncollision("collision_clip_wall_256x256x10", "collider", (4496, -4824, 304), vectorscale((0, 1, 0), 45));
		spawncollision("collision_clip_ramp_128x24", "collider", (4433, -4726.27, 306), (270, 27.6804, -177.681));
	}
	var_bb51a7b = spawncollision("collision_clip_32x32x128", "collider", (1455, -3545, 126), vectorscale((0, 1, 0), 45));
	var_bb51a7b disconnectpaths();
	if(!zm_ffotd::optimize_for_splitscreen())
	{
		spawncollision("collision_clip_64x64x64", "collider", (2869, -4814, 260), vectorscale((0, 1, 0), 45));
		spawncollision("collision_clip_32x32x128", "collider", (1260, -8342, 440), vectorscale((0, 1, 0), 45));
		spawncollision("collision_clip_ramp_128x24", "collider", (1256, -8381, 440), (90, 0, 180));
		spawncollision("collision_clip_wall_128x128x10", "collider", (1286, -8300, 415), vectorscale((0, 1, 0), 315));
		spawncollision("collision_clip_wall_256x256x10", "collider", (4817, -3765, 629), vectorscale((0, 1, 0), 315));
		spawncollision("collision_player_wall_256x256x10", "collider", (2268, -5516, 376), vectorscale((0, 1, 0), 315));
	}
	zm::spawn_life_brush((2340, -3892, 256), 36, 128);
	if(!zm_ffotd::optimize_for_splitscreen())
	{
		spawncollision("collision_clip_wedge_32x256", "collider", (4017, -4376, 224), vectorscale((0, 1, 0), 90));
		spawncollision("collision_player_wall_128x128x10", "collider", (1139, -3424, 492), vectorscale((0, 1, 0), 270));
		spawncollision("collision_player_128x128x128", "collider", (2368, -4065, 297), (0, 0, 0));
		spawncollision("collision_player_128x128x128", "collider", (2410, -4065, 297), (0, 0, 0));
		spawncollision("collision_utility_wall_128x128x10", "collider", (3061, -3031, -495), vectorscale((0, 1, 0), 315));
		spawncollision("collision_utility_wall_128x128x10", "collider", (2173, -3033, -495), vectorscale((0, 1, 0), 225));
		spawncollision("collision_utility_wall_128x128x10", "collider", (3156, -5642, 179), vectorscale((0, 1, 0), 315));
	}
	var_970d875d = spawn("script_model", (4423, -3243, 516));
	var_970d875d setmodel("p7_zm_zod_burlesque_wood_column_01");
	var_970d875d.angles = vectorscale((0, 1, 0), 45);
	var_d6e7650f = spawn("script_model", (2158, -5517, 253.5));
	var_d6e7650f setmodel("p7_scaff_plywood_walkway_36x192");
	var_d6e7650f.angles = (0, 0, 0);
	var_83a52ee1 = spawn("script_model", (2604, -3622, -1199));
	var_83a52ee1 setmodel("p7_inf_vista_stalingrad_bldg_04_back");
	var_83a52ee1.angles = vectorscale((0, 1, 0), 270);
	var_cc9c38e8 = spawn("script_model", (2498, -4352.25, 130.75));
	var_cc9c38e8 setmodel("p7_plank_wood_broken_2x4x64_wet");
	var_cc9c38e8.angles = vectorscale((0, 1, 0), 180);
	var_3ea3a823 = spawn("script_model", (2498.25, -4354, 132.75));
	var_3ea3a823 setmodel("p7_plank_wood_broken_sml_2x4x64_wet");
	var_3ea3a823.angles = vectorscale((0, 0, -1), 180);
	var_31363875 = spawncollision("collision_bullet_wall_128x128x10", "collider", (363, -5228.5, 316.5), (0, 0, 0));
	var_31363875 thread function_320b9477();
	level thread function_e7337b94();
}

/*
	Name: function_320b9477
	Namespace: zm_zod_ffotd
	Checksum: 0x6C405B91
	Offset: 0x1088
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_320b9477()
{
	level flag::wait_till("connect_start_to_junction");
	self delete();
}

/*
	Name: function_2cba29a8
	Namespace: zm_zod_ffotd
	Checksum: 0x5340BA65
	Offset: 0x10D0
	Size: 0xF4
	Parameters: 4
	Flags: Linked
*/
function function_2cba29a8(zone, pos, radius, height)
{
	if(!isdefined(level.var_e7337b94))
	{
		level.var_e7337b94 = [];
	}
	if(!isdefined(level.var_e7337b94[zone]))
	{
		level.var_e7337b94[zone] = [];
	}
	else if(!isarray(level.var_e7337b94[zone]))
	{
		level.var_e7337b94[zone] = array(level.var_e7337b94[zone]);
	}
	level.var_e7337b94[zone][level.var_e7337b94[zone].size] = zm::spawn_kill_brush(pos, radius, height);
}

/*
	Name: function_e7337b94
	Namespace: zm_zod_ffotd
	Checksum: 0x2BA9416F
	Offset: 0x11D0
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_e7337b94()
{
	level.var_e7337b94 = [];
	function_2cba29a8("canal", (1031, -1726, 450), 128, 160);
	function_2cba29a8("canal", (818, -1512, 450), 128, 160);
	wait(1);
	level.var_4e5a7cb5 = level.player_out_of_playable_area_monitor_callback;
	level.player_out_of_playable_area_monitor_callback = &player_out_of_playable_area_monitor_callback;
}

/*
	Name: player_out_of_playable_area_monitor_callback
	Namespace: zm_zod_ffotd
	Checksum: 0x65A7F7C6
	Offset: 0x1278
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function player_out_of_playable_area_monitor_callback()
{
	if(isdefined(self.kill_brush))
	{
		train = level.o_zod_train;
		station = train.var_97fef807;
		if(isdefined(self.on_train) && self.on_train || !train flag::get("moving"))
		{
			if(isdefined(station) && isdefined(level.var_e7337b94[station]))
			{
				if(isinarray(level.var_e7337b94[station], self.kill_brush))
				{
					return 0;
				}
			}
		}
	}
	if(isdefined(level.var_4e5a7cb5))
	{
		return self [[level.var_4e5a7cb5]]();
	}
	return 1;
}

