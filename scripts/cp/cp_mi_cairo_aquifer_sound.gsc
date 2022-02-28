// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\voice\voice_aquifer;
#using scripts\shared\flag_shared;
#using scripts\shared\music_shared;
#using scripts\shared\util_shared;

#namespace cp_mi_cairo_aquifer_sound;

/*
	Name: main
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x37DBC884
	Offset: 0xD28
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function main()
{
	voice_aquifer::init_voice();
	thread function_609d3ec();
	thread function_cd85d22a();
	thread function_4fb4bdc3();
}

/*
	Name: function_4fb4bdc3
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x63D158D1
	Offset: 0xD78
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_4fb4bdc3()
{
	level.var_fc9a3509 = 0;
	level.var_b8fee04d = spawn("script_origin", (16832, 3276, 2268));
	level.var_df015ab6 = spawn("script_origin", (15869, 3965, 2281));
	level.var_554aefcd = spawn("script_origin", (15979, 3297, 2050));
	level.var_7b4d6a36 = spawn("script_origin", (16820, 3947, 2047));
}

/*
	Name: test_music_loop
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x99EC1590
	Offset: 0xE50
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function test_music_loop()
{
}

/*
	Name: function_609d3ec
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x99EC1590
	Offset: 0xE60
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_609d3ec()
{
}

/*
	Name: function_77b5283a
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x8F8C0B54
	Offset: 0xE70
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_77b5283a(player)
{
	player playsoundtoplayer("veh_vtol_exit", player);
	player playsoundtoplayer("veh_vtol_exit_foley", player);
}

/*
	Name: function_976c341d
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x56425D29
	Offset: 0xEC8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function function_976c341d(player, zone)
{
	player playsoundtoplayer("veh_vtol_open", player);
	playsoundatposition("veh_vtol_land", zone.origin);
}

/*
	Name: function_c800052a
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0xD53333BE
	Offset: 0xF30
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function function_c800052a()
{
	playerlist = getplayers();
	foreach(player in playerlist)
	{
		player playsoundtoplayer("amb_cockpit", player);
	}
}

/*
	Name: function_fc716128
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0xD3C8B28E
	Offset: 0xFF0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_fc716128()
{
	playsoundatposition("evt_water_vo_lyr_01", (0, 0, 0));
}

/*
	Name: function_6e78d063
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x4DE9958E
	Offset: 0x1020
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_6e78d063()
{
	playsoundatposition("evt_water_vo_lyr_02", (0, 0, 0));
}

/*
	Name: function_487655fa
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0xBACC479D
	Offset: 0x1050
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_487655fa()
{
	playsoundatposition("evt_water_vo_lyr_03", (0, 0, 0));
}

/*
	Name: function_decbd389
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x2827020C
	Offset: 0x1080
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_decbd389()
{
	playsoundatposition("evt_drown_blink_01", (0, 0, 0));
}

/*
	Name: function_4ce4df2
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x4B763BFC
	Offset: 0x10B0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_4ce4df2()
{
	playsoundatposition("evt_drown_blink_02", (0, 0, 0));
}

/*
	Name: function_2ad0c85b
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x44CC556D
	Offset: 0x10E0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_2ad0c85b()
{
	playsoundatposition("evt_drown_blink_03", (0, 0, 0));
}

/*
	Name: function_69386a6b
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0xE05D0B0E
	Offset: 0x1110
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_69386a6b()
{
	playsoundatposition("evt_drown", (0, 0, 0));
}

/*
	Name: function_ed6114d2
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x6F9687D8
	Offset: 0x1140
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_ed6114d2()
{
	playsoundatposition("evt_door_kick", (12620, 836, 2979));
}

/*
	Name: function_ceaeaa5a
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0xB4FD81E6
	Offset: 0x1178
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_ceaeaa5a()
{
	playsoundatposition("evt_door_bomb_exp", (12295, -721, 2971));
	level util::clientnotify("sndWR");
}

/*
	Name: function_c3d203d6
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0xDFCDEFB3
	Offset: 0x11D0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_c3d203d6()
{
	playsoundatposition("evt_lower_combat_exp_snap", (17220.8, -3074.75, 3528.5));
}

/*
	Name: function_5dcd1d9
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x5102B988
	Offset: 0x1210
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_5dcd1d9()
{
	playsoundatposition("evt_scripted_jet", (17220.8, -3074.75, 3528.5));
}

/*
	Name: function_4e875e0d
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x16759B83
	Offset: 0x1250
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_4e875e0d()
{
	playsoundatposition("evt_breach_gunfire", (0, 0, 0));
	wait(3.24);
	playsoundatposition("evt_breach_missile_zip", (15047, 13, 3121));
	wait(0.8);
	playsoundatposition("evt_breach_exp", (15088, 19, 2942));
	wait(1.2);
	playsoundatposition("evt_breach_debris_left", (15286, 391, 2913));
	playsoundatposition("evt_breach_debris_right", (15308, -453, 2914));
}

/*
	Name: function_16a46955
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0xB0B3E6C6
	Offset: 0x1338
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_16a46955()
{
	wait(4.1);
	playsoundatposition("evt_breach_slowmo", (0, 0, 0));
}

/*
	Name: function_ad15f6f5
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x3F5991D8
	Offset: 0x1370
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function function_ad15f6f5()
{
	if(level.var_fc9a3509 == 1)
	{
		level.var_b8fee04d playloopsound("evt_generator_overload");
		level.var_554aefcd playloopsound("evt_generator_overload_panel");
	}
	else if(level.var_fc9a3509 == 2)
	{
		level.var_df015ab6 playloopsound("evt_generator_overload");
		level.var_7b4d6a36 playloopsound("evt_generator_overload_panel");
	}
}

/*
	Name: function_1024da0a
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x6B5A5320
	Offset: 0x1428
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function function_1024da0a()
{
	if(level.var_fc9a3509 == 1)
	{
		level.var_b8fee04d stoploopsound();
		level.var_b8fee04d playsound("evt_generator_release");
		level.var_554aefcd stoploopsound();
		level.var_554aefcd playsound("evt_generator_release_panel");
	}
	else if(level.var_fc9a3509 == 2)
	{
		level.var_df015ab6 stoploopsound();
		level.var_df015ab6 playsound("evt_generator_release");
		level.var_7b4d6a36 stoploopsound();
		level.var_7b4d6a36 playsound("evt_generator_release_panel");
	}
}

/*
	Name: function_e76f158
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x79524140
	Offset: 0x1540
	Size: 0x140
	Parameters: 0
	Flags: Linked
*/
function function_e76f158()
{
	if(level.var_fc9a3509 == 1)
	{
		level.var_b8fee04d stoploopsound();
		level.var_b8fee04d playsound("evt_boss_exp_01");
		thread function_30d6c739();
		level.var_554aefcd stoploopsound();
		level.var_554aefcd playsound("evt_generator_release_panel");
		wait(0.1);
		level.var_fc9a3509 = 2;
	}
	else if(level.var_fc9a3509 == 2)
	{
		level.var_df015ab6 stoploopsound();
		level.var_df015ab6 playsound("evt_boss_exp_02");
		thread function_56d941a2();
		level.var_7b4d6a36 stoploopsound();
		level.var_7b4d6a36 playsound("evt_generator_release_panel");
	}
}

/*
	Name: function_30d6c739
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0xC9BC37DE
	Offset: 0x1688
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_30d6c739()
{
	wait(1.5);
	playsoundatposition("evt_boss_exp_elec", (16678, 2893, 2276));
}

/*
	Name: function_56d941a2
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x5F51DFC8
	Offset: 0x16C8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_56d941a2()
{
	wait(1.5);
	playsoundatposition("evt_boss_exp_elec", (16126, 4352, 2279));
}

/*
	Name: function_f8835fe9
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x6BF0CFC9
	Offset: 0x1708
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_f8835fe9()
{
	playsoundatposition("evt_escape_exp_sml", (0, 0, 0));
}

/*
	Name: function_5d0cee98
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0xF90EEEF8
	Offset: 0x1738
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_5d0cee98()
{
	playsoundatposition("evt_escape_exp_lrg", (0, 0, 0));
}

/*
	Name: function_b01c9f8
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x2A5EEA65
	Offset: 0x1768
	Size: 0x32C
	Parameters: 0
	Flags: Linked
*/
function function_b01c9f8()
{
	playsoundatposition("evt_runout_first_exp", (0, 0, 0));
	wait(0.5);
	var_1d84d980 = spawn("script_origin", (16357, 1454, 2140));
	var_1d84d980 playloopsound("evt_runout_alarm_01");
	var_8f8c48bb = spawn("script_origin", (16548, 1041, 2561));
	var_8f8c48bb playloopsound("evt_runout_alarm_02");
	var_472c43c8 = spawn("script_origin", (15669, 1167, 2320));
	var_472c43c8 playloopsound("evt_runout_water_spray_01");
	var_b933b303 = spawn("script_origin", (16505, 918, 2519));
	var_b933b303 playloopsound("evt_runout_water_spray_01");
	var_8218f48c = spawn("script_origin", (15775, 1150, 2285));
	var_8218f48c playloopsound("evt_runout_water_splatter");
	var_f42063c7 = spawn("script_origin", (16500, 913, 2409));
	var_f42063c7 playloopsound("evt_runout_water_splatter");
	var_78abe30 = spawn("script_origin", (15643, 1158, 2442));
	var_78abe30 playloopsound("evt_runout_large_water");
	var_b77e0da = spawn("script_origin", (15883, 937, 2459));
	var_b77e0da playloopsound("evt_runout_wall_fire");
	var_6754449b = spawn("script_origin", (15755, 1298, 2164));
	var_6754449b playloopsound("evt_runout_large_fire");
	level waittill(#"hash_92f048cf");
	playsoundatposition("evt_runout_corridor_exp", (15862, 1444, 2090));
}

/*
	Name: function_850c7ab7
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0xD5249E51
	Offset: 0x1AA0
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function function_850c7ab7()
{
	wait(0.5);
	playsoundatposition("evt_exfil_elec_exp", (15827, 139, 3144));
	wait(0.5);
	playsoundatposition("evt_exfil_exp_01", (15930, 978, 2815));
	wait(14.2);
	playsoundatposition("evt_exfil_exp_02", (15725, 56, 2889));
	wait(0.6);
	playsoundatposition("evt_exfil_exp_03", (15425, 287, 2846));
	wait(0.9);
	playsoundatposition("evt_exfil_exp_04", (15039, 820, 3270));
	wait(0.7);
	playsoundatposition("evt_exfil_exp_05", (14347, 2257, 2468));
	wait(1.3);
	playsoundatposition("evt_exfil_exp_06", (15038, 4150, 2915));
	wait(0.4);
	playsoundatposition("evt_exfil_exp_07", (15180, 2305, 3093));
	wait(2.2);
	playsoundatposition("evt_exfil_exp_08", (14142, 6656, 3856));
	wait(0.4);
	playsoundatposition("evt_exfil_exp_09", (15063, 6200, 3213));
}

/*
	Name: function_fbfb4dae
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0xF771A109
	Offset: 0x1C90
	Size: 0x768
	Parameters: 0
	Flags: Linked
*/
function function_fbfb4dae()
{
	level.var_7dc8a9bd[0][0] = "vox_aqui_130_10_001_esol";
	level.var_7dc8a9bd[0][1] = "vox_aqui_130_10_002_esol";
	level.var_7dc8a9bd[1][0] = "vox_aqui_130_20_001_esol";
	level.var_7dc8a9bd[1][1] = "vox_aqui_130_20_002_esol";
	level.var_7dc8a9bd[2][0] = "vox_aqui_130_30_001_esol";
	level.var_7dc8a9bd[2][1] = "vox_aqui_130_30_002_esol";
	level.var_7dc8a9bd[2][2] = "vox_aqui_130_30_003_esol";
	level.var_7dc8a9bd[2][3] = "vox_aqui_130_30_004_esol";
	level.var_7dc8a9bd[3][0] = "vox_aqui_130_40_001_esol";
	level.var_7dc8a9bd[3][1] = "vox_aqui_130_40_002_esol";
	level.var_7dc8a9bd[3][2] = "vox_aqui_130_40_003_esol";
	level.var_7dc8a9bd[4][0] = "vox_aqui_130_50_001_esol";
	level.var_7dc8a9bd[4][1] = "vox_aqui_130_50_002_esol";
	level.var_7dc8a9bd[4][2] = "vox_aqui_130_50_003_esol";
	level.var_7dc8a9bd[4][3] = "vox_aqui_130_50_004_esol";
	level.var_7dc8a9bd[4][4] = "vox_aqui_130_50_005_esol";
	level.var_7dc8a9bd[4][5] = "vox_aqui_130_50_006_esol";
	level.var_7dc8a9bd[5][0] = "vox_aqui_130_60_001_esol";
	level.var_7dc8a9bd[5][1] = "vox_aqui_130_60_002_esol";
	level.var_7dc8a9bd[5][2] = "vox_aqui_130_60_003_esol";
	level.var_7dc8a9bd[5][3] = "vox_aqui_130_60_004_esol";
	level.var_7dc8a9bd[5][4] = "vox_aqui_130_60_005_esol";
	level.var_7dc8a9bd[5][5] = "vox_aqui_130_60_006_esol";
	level.var_7dc8a9bd[6][0] = "vox_aqui_130_70_001_esol";
	level.var_7dc8a9bd[6][1] = "vox_aqui_130_70_002_esol";
	level.var_7dc8a9bd[6][2] = "vox_aqui_130_70_003_esol";
	level.var_7dc8a9bd[7][0] = "vox_aqui_130_80_001_esol";
	level.var_7dc8a9bd[7][1] = "vox_aqui_130_80_002_esol";
	level.var_7dc8a9bd[7][2] = "vox_aqui_130_80_003_esol";
	level.var_7dc8a9bd[7][3] = "vox_aqui_130_80_004_esol";
	level.var_7dc8a9bd[7][4] = "vox_aqui_130_80_005_esol";
	level.var_7dc8a9bd[8][0] = "vox_aqui_130_90_001_esol";
	level.var_7dc8a9bd[8][1] = "vox_aqui_130_90_002_esol";
	level.var_7dc8a9bd[8][2] = "vox_aqui_130_90_003_esol";
	level.var_7dc8a9bd[8][3] = "vox_aqui_130_90_004_esol";
	level.var_7dc8a9bd[8][4] = "vox_aqui_130_90_005_esol";
	level.var_7dc8a9bd[9][0] = "vox_aqui_130_100_001_esol";
	level.var_7dc8a9bd[9][1] = "vox_aqui_130_100_002_esol";
	level.var_7dc8a9bd[9][2] = "vox_aqui_130_100_003_esol";
	level.var_7dc8a9bd[9][4] = "vox_aqui_130_100_004_esol";
	level.var_7dc8a9bd[9][5] = "vox_aqui_130_100_005_esol";
	level.var_7dc8a9bd[9][6] = "vox_aqui_130_100_006_esol";
	level.var_7dc8a9bd[9][7] = "vox_aqui_130_100_007_esol";
	level.var_7dc8a9bd[10][0] = "vox_aqui_130_110_001_esol";
	level.var_7dc8a9bd[10][1] = "vox_aqui_130_110_002_esol";
	level.var_7dc8a9bd[10][2] = "vox_aqui_130_110_003_esol";
	level.var_7dc8a9bd[10][3] = "vox_aqui_130_110_004_esol";
	level.var_7dc8a9bd[11][0] = "vox_aqui_130_120_001_esol";
	level.var_7dc8a9bd[11][1] = "vox_aqui_130_120_002_esol";
	level.var_7dc8a9bd[11][2] = "vox_aqui_130_120_003_esol";
	level.var_7dc8a9bd[11][3] = "vox_aqui_130_120_004_esol";
	level.var_7dc8a9bd[12][0] = "vox_aqui_130_120_005_esol";
	level.var_7dc8a9bd[12][1] = "vox_aqui_130_120_006_esol";
	level.var_7dc8a9bd[12][2] = "vox_aqui_130_120_007_esol";
	level.var_7dc8a9bd[12][3] = "vox_aqui_130_120_008_esol";
	level.var_7dc8a9bd[13][0] = "vox_aqui_130_130_001_esol";
	level.var_7dc8a9bd[13][1] = "vox_aqui_130_130_002_esol";
	level.var_7dc8a9bd[13][2] = "vox_aqui_130_130_003_esol";
	level.var_7dc8a9bd[13][3] = "vox_aqui_130_130_004_esol";
	level.var_7dc8a9bd[13][4] = "vox_aqui_130_130_005_esol";
	level.var_7dc8a9bd[14][0] = "vox_aqui_130_140_001_esol";
	level.var_7dc8a9bd[14][1] = "vox_aqui_130_140_002_esol";
	level.var_7dc8a9bd[14][2] = "vox_aqui_130_140_003_esol";
	level.var_7dc8a9bd[14][3] = "vox_aqui_130_140_004_esol";
	level.var_7dc8a9bd[14][4] = "vox_aqui_130_140_005_esol";
	level.var_7dc8a9bd[15][0] = "vox_aqui_130_150_001_esol";
	level.var_7dc8a9bd[15][1] = "vox_aqui_130_150_002_esol";
	level.var_7dc8a9bd[15][2] = "vox_aqui_130_150_003_esol";
	level.var_7dc8a9bd[15][3] = "vox_aqui_130_150_004_esol";
	level.var_7dc8a9bd[15][4] = "vox_aqui_130_150_005_esol";
}

/*
	Name: function_cd85d22a
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x9380F2BF
	Offset: 0x2400
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function function_cd85d22a()
{
	wait(5);
	if(isdefined(level.var_cca43db2))
	{
		return;
	}
	level.var_cca43db2 = spawn("script_origin", (0, 0, 0));
	level.var_7dc8a9bd = [];
	function_fbfb4dae();
	i = 0;
	t = 0;
	var_9999bbd7 = 0;
	while(true)
	{
		level flag::wait_till("background_chatter_active");
		var_9999bbd7 = randomint(level.var_7dc8a9bd.size);
		convo = level.var_7dc8a9bd[var_9999bbd7];
		foreach(alias in convo)
		{
			t = soundgetplaybacktime(alias);
			level.var_cca43db2 playsound(alias);
			if(t > 0)
			{
				wait(t / 1000);
			}
			wait(randomfloatrange(0.3, 1));
		}
		wait(randomfloatrange(1.5, 3.5));
	}
}

/*
	Name: function_de37a122
	Namespace: cp_mi_cairo_aquifer_sound
	Checksum: 0x401EE5DF
	Offset: 0x2600
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_de37a122(b_active = 1)
{
	if(b_active)
	{
		level flag::set("background_chatter_active");
	}
	else
	{
		level flag::clear("background_chatter_active");
	}
}

#namespace namespace_71a63eac;

/*
	Name: function_973b77f9
	Namespace: namespace_71a63eac
	Checksum: 0x6242B7E3
	Offset: 0x2670
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_973b77f9()
{
	music::setmusicstate("none");
}

/*
	Name: play_intro_igc
	Namespace: namespace_71a63eac
	Checksum: 0xA01B03BA
	Offset: 0x2698
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function play_intro_igc()
{
	music::setmusicstate("intro_igc");
}

/*
	Name: function_bdb99f05
	Namespace: namespace_71a63eac
	Checksum: 0xD4B9231
	Offset: 0x26C0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_bdb99f05()
{
	music::setmusicstate("destroy_asp");
}

/*
	Name: function_48972636
	Namespace: namespace_71a63eac
	Checksum: 0xCC7B5971
	Offset: 0x26E8
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function function_48972636()
{
	music::setmusicstate("dogfight");
}

/*
	Name: function_e703f818
	Namespace: namespace_71a63eac
	Checksum: 0xE55F2BA4
	Offset: 0x2710
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_e703f818()
{
	music::setmusicstate("comm_tower");
}

/*
	Name: function_ca2c6d9f
	Namespace: namespace_71a63eac
	Checksum: 0xBC60DA9E
	Offset: 0x2738
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_ca2c6d9f()
{
	music::setmusicstate("water_room_objective");
}

/*
	Name: function_bb8ce831
	Namespace: namespace_71a63eac
	Checksum: 0xB6159BEA
	Offset: 0x2760
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_bb8ce831()
{
	wait(7);
	music::setmusicstate("tension_loop_1");
}

/*
	Name: function_8210b658
	Namespace: namespace_71a63eac
	Checksum: 0xF3321B6D
	Offset: 0x2790
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_8210b658()
{
	music::setmusicstate("igc_1_swim");
}

/*
	Name: function_e18f629a
	Namespace: namespace_71a63eac
	Checksum: 0x616CC581
	Offset: 0x27B8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_e18f629a()
{
	music::setmusicstate("tension_loop_2");
}

/*
	Name: function_a2d40521
	Namespace: namespace_71a63eac
	Checksum: 0xA832B5BB
	Offset: 0x27E0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_a2d40521()
{
	music::setmusicstate("battle_bots");
}

/*
	Name: function_b1ee6c2d
	Namespace: namespace_71a63eac
	Checksum: 0x7FB6BFDF
	Offset: 0x2808
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_b1ee6c2d()
{
	music::setmusicstate("dogfight_2");
}

/*
	Name: function_6860e122
	Namespace: namespace_71a63eac
	Checksum: 0x2C639473
	Offset: 0x2830
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function function_6860e122()
{
	music::setmusicstate("interference");
}

/*
	Name: function_55376eeb
	Namespace: namespace_71a63eac
	Checksum: 0xC464EF76
	Offset: 0x2858
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_55376eeb()
{
	music::setmusicstate("igc_2_reinforced_door");
}

/*
	Name: function_36cd6ee8
	Namespace: namespace_71a63eac
	Checksum: 0x27D86413
	Offset: 0x2880
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_36cd6ee8()
{
	music::setmusicstate("ground_battle");
}

/*
	Name: function_5ac17e2c
	Namespace: namespace_71a63eac
	Checksum: 0xFDE99485
	Offset: 0x28A8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_5ac17e2c()
{
	music::setmusicstate("just_breach_it");
}

/*
	Name: function_4de42644
	Namespace: namespace_71a63eac
	Checksum: 0x73CFB806
	Offset: 0x28D0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_4de42644()
{
	music::setmusicstate("igc_3_chase");
}

/*
	Name: function_f819830b
	Namespace: namespace_71a63eac
	Checksum: 0x584B2EFD
	Offset: 0x28F8
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function function_f819830b()
{
	music::setmusicstate("chase_maretti");
}

/*
	Name: function_1a168f0c
	Namespace: namespace_71a63eac
	Checksum: 0xA3EB6BE
	Offset: 0x2920
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_1a168f0c()
{
	music::setmusicstate("hendricks_fight");
}

/*
	Name: function_99caac9d
	Namespace: namespace_71a63eac
	Checksum: 0xA8DC39F3
	Offset: 0x2948
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_99caac9d()
{
	music::setmusicstate("overload_battle");
}

/*
	Name: function_e0e00797
	Namespace: namespace_71a63eac
	Checksum: 0xDB0E9DD4
	Offset: 0x2970
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_e0e00797()
{
	music::setmusicstate("igc_4_maretti");
}

/*
	Name: function_a1e074db
	Namespace: namespace_71a63eac
	Checksum: 0x4200A0B4
	Offset: 0x2998
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_a1e074db()
{
	music::setmusicstate("escape");
}

/*
	Name: function_ae6b41cd
	Namespace: namespace_71a63eac
	Checksum: 0x9C38EC14
	Offset: 0x29C0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_ae6b41cd()
{
	music::setmusicstate("igc_5_outro");
}

