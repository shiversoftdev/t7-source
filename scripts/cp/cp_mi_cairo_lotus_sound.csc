// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\trigger_shared;

#namespace cp_mi_cairo_lotus_sound;

/*
	Name: main
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0x6EDA387
	Offset: 0x228
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread sndmusicrampers();
	level thread function_7bcb0782();
	clientfield::register("world", "sndHakimPaVox", 1, 3, "int", &function_5e9a8778, 0, 0);
	level thread function_4904d6ff();
	level thread function_1a66f9f3();
}

/*
	Name: sndmusicrampers
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0x58D882C3
	Offset: 0x2E0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function sndmusicrampers()
{
	level thread function_759e7aaa();
}

/*
	Name: function_759e7aaa
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0x435F7F81
	Offset: 0x308
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_759e7aaa()
{
	level waittill(#"hash_51e4b2c0");
	level thread function_60df3271();
	target_origin = (-5922, 186, 1813);
	player = getlocalplayer(0);
	level.tensionactive = 1;
	level sndramperthink(player, target_origin, "mus_assassination_layer_1", 0, 1, 250, 1300, "mus_assassination_layer_2", 0, 1, 50, 700, "mus_assassination_stinger");
}

/*
	Name: function_60df3271
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0xD9985DC2
	Offset: 0x3D0
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function function_60df3271()
{
	level waittill(#"hash_8409b4c");
	wait(3);
	level.tensionactive = 0;
	level notify(#"hash_1842ee53");
}

/*
	Name: sndramperthink
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0x7085026B
	Offset: 0x408
	Size: 0x404
	Parameters: 13
	Flags: Linked
*/
function sndramperthink(player, target_origin, alias1, min_vol1, max_vol1, min_dist1, max_dist1, alias2, min_vol2, max_vol2, min_dist2, max_dist2, end_alias)
{
	level endon(#"save_restore");
	level endon(#"disconnect");
	player endon(#"death");
	player endon(#"disconnect");
	if(!isdefined(player))
	{
		return;
	}
	volume1 = undefined;
	volume2 = undefined;
	if(isdefined(alias1))
	{
		sndloop1_ent = spawn(0, (0, 0, 0), "script_origin");
		sndloop1_id = sndloop1_ent playloopsound(alias1, 3);
		sndloop1_min_volume = min_vol1;
		sndloop1_max_volume = max_vol1;
		sndloop1_min_distance = min_dist1;
		sndloop1_max_distance = max_dist1;
		volume1 = 0;
	}
	if(isdefined(alias2))
	{
		sndloop2_ent = spawn(0, (0, 0, 0), "script_origin");
		sndloop2_id = sndloop2_ent playloopsound(alias2, 3);
		sndloop2_min_volume = min_vol2;
		sndloop2_max_volume = max_vol2;
		sndloop2_min_distance = min_dist2;
		sndloop2_max_distance = max_dist2;
		volume2 = 0;
	}
	level thread function_860d167b(sndloop1_ent, sndloop2_ent, sndloop1_id, sndloop2_id);
	while(isdefined(level.tensionactive) && level.tensionactive)
	{
		if(!isdefined(player))
		{
			return;
		}
		distance = distance(target_origin, player.origin);
		if(isdefined(volume1))
		{
			volume1 = audio::scale_speed(sndloop1_min_distance, sndloop1_max_distance, sndloop1_min_volume, sndloop1_max_volume, distance);
			volume1 = abs(1 - volume1);
			setsoundvolume(sndloop1_id, volume1);
		}
		if(isdefined(volume2))
		{
			volume2 = audio::scale_speed(sndloop2_min_distance, sndloop2_max_distance, sndloop2_min_volume, sndloop2_max_volume, distance);
			volume2 = abs(1 - volume2);
			setsoundvolume(sndloop2_id, volume2);
		}
		wait(0.1);
	}
	level notify(#"hash_61477803");
	if(isdefined(end_alias))
	{
		playsound(0, end_alias, (0, 0, 0));
	}
	if(isdefined(sndloop1_ent))
	{
		sndloop1_ent delete();
	}
	if(isdefined(sndloop2_ent))
	{
		sndloop2_ent delete();
	}
}

/*
	Name: function_860d167b
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0x26961E9
	Offset: 0x818
	Size: 0x114
	Parameters: 4
	Flags: Linked
*/
function function_860d167b(ent1, ent2, var_105ef70b, id2)
{
	level endon(#"hash_61477803");
	level waittill(#"save_restore");
	ent1 delete();
	ent2 delete();
	var_105ef70b = undefined;
	id2 = undefined;
	target_origin = (-5922, 186, 1813);
	wait(2);
	player = getlocalplayer(0);
	if(isdefined(player))
	{
		level thread sndramperthink(player, target_origin, "mus_assassination_layer_1", 0, 1, 250, 1300, "mus_assassination_layer_2", 0, 1, 50, 700, "mus_assassination_stinger");
	}
}

/*
	Name: function_4904d6ff
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0x306FFC1B
	Offset: 0x938
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_4904d6ff()
{
	level.var_27ec4154 = array("_000_haki", "_001_haki", "_002_haki", "_003_haki");
	level.var_6d0444d4 = struct::get_array("sndHakimPaVox", "targetname");
}

/*
	Name: function_5e9a8778
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0x24C7455A
	Offset: 0x9A8
	Size: 0x10A
	Parameters: 7
	Flags: Linked
*/
function function_5e9a8778(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.var_6d0444d4))
	{
		return;
	}
	if(newval)
	{
		if(newval == 5)
		{
			level notify(#"hash_4e3eaac8");
		}
		else
		{
			foreach(location in level.var_6d0444d4)
			{
				level thread function_372f5bfa(location, newval);
				wait(0.016);
			}
		}
	}
}

/*
	Name: function_372f5bfa
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0x31C1ACEA
	Offset: 0xAC0
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function function_372f5bfa(location, newval)
{
	level endon(#"hash_1842ee53");
	if(location.script_string == "large")
	{
		wait(0.05);
	}
	alias = ("vox_lot1_hakim_pa_" + location.script_string) + (level.var_27ec4154[newval - 1]);
	soundid = playsound(0, alias, location.origin);
	level waittill(#"hash_4e3eaac8");
	stopsound(soundid);
}

/*
	Name: function_7bcb0782
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0x37C1431C
	Offset: 0xB98
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_7bcb0782()
{
	if(!isdefined(level.var_b1373a38))
	{
		level.var_b1373a38 = spawn(0, (-6820, 251, 1992), "script.origin");
	}
	level waittill(#"hash_b1373a38");
	level.var_b1373a38 playsound(0, "evt_crowd_swell");
	wait(5);
	level.var_b1373a38 delete();
}

/*
	Name: function_1a66f9f3
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0x9555F13
	Offset: 0xC38
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_1a66f9f3()
{
	level waittill(#"hash_52e37ee2");
	level thread function_e675c6f2();
	target_origin = (-8944, 1407, 4186);
	player = getlocalplayer(0);
	level.tensionactive = 1;
	level thread function_a89a73f3(player, target_origin, "evt_air_scare_layer_1", 0, 1, 100, 600, "evt_air_scare_layer_2", 0, 1, 150, 300);
}

/*
	Name: function_e675c6f2
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0xBC6199CE
	Offset: 0xCF8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_e675c6f2()
{
	level waittill(#"hash_a38d24cd");
	level.tensionactive = 0;
}

/*
	Name: function_a89a73f3
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0xA4A0A04A
	Offset: 0xD20
	Size: 0x404
	Parameters: 13
	Flags: Linked
*/
function function_a89a73f3(player, target_origin, alias1, min_vol1, max_vol1, min_dist1, max_dist1, alias2, min_vol2, max_vol2, min_dist2, max_dist2, end_alias)
{
	level endon(#"save_restore");
	level endon(#"disconnect");
	player endon(#"death");
	player endon(#"disconnect");
	if(!isdefined(player))
	{
		return;
	}
	volume1 = undefined;
	volume2 = undefined;
	if(isdefined(alias1))
	{
		sndloop1_ent = spawn(0, (0, 0, 0), "script_origin");
		sndloop1_id = sndloop1_ent playloopsound(alias1, 3);
		sndloop1_min_volume = min_vol1;
		sndloop1_max_volume = max_vol1;
		sndloop1_min_distance = min_dist1;
		sndloop1_max_distance = max_dist1;
		volume1 = 0;
	}
	if(isdefined(alias2))
	{
		sndloop2_ent = spawn(0, (0, 0, 0), "script_origin");
		sndloop2_id = sndloop2_ent playloopsound(alias2, 3);
		sndloop2_min_volume = min_vol2;
		sndloop2_max_volume = max_vol2;
		sndloop2_min_distance = min_dist2;
		sndloop2_max_distance = max_dist2;
		volume2 = 0;
	}
	level thread function_dc4a5405(sndloop1_ent, sndloop2_ent, sndloop1_id, sndloop2_id);
	while(isdefined(level.tensionactive) && level.tensionactive)
	{
		if(!isdefined(player))
		{
			return;
		}
		distance = distance(target_origin, player.origin);
		if(isdefined(volume1))
		{
			volume1 = audio::scale_speed(sndloop1_min_distance, sndloop1_max_distance, sndloop1_min_volume, sndloop1_max_volume, distance);
			volume1 = abs(1 - volume1);
			setsoundvolume(sndloop1_id, volume1);
		}
		if(isdefined(volume2))
		{
			volume2 = audio::scale_speed(sndloop2_min_distance, sndloop2_max_distance, sndloop2_min_volume, sndloop2_max_volume, distance);
			volume2 = abs(1 - volume2);
			setsoundvolume(sndloop2_id, volume2);
		}
		wait(0.1);
	}
	level notify(#"hash_61477803");
	if(isdefined(end_alias))
	{
		playsound(0, end_alias, (0, 0, 0));
	}
	if(isdefined(sndloop1_ent))
	{
		sndloop1_ent delete();
	}
	if(isdefined(sndloop2_ent))
	{
		sndloop2_ent delete();
	}
}

/*
	Name: function_dc4a5405
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0x36C6CDBA
	Offset: 0x1130
	Size: 0x114
	Parameters: 4
	Flags: Linked
*/
function function_dc4a5405(ent1, ent2, var_105ef70b, id2)
{
	level endon(#"hash_a38d24cd");
	level waittill(#"save_restore");
	ent1 delete();
	ent2 delete();
	var_105ef70b = undefined;
	id2 = undefined;
	target_origin = (-8944, 1407, 4186);
	wait(2);
	player = getlocalplayer(0);
	if(isdefined(player))
	{
		level thread function_a89a73f3(player, target_origin, "evt_air_scare_layer_1", 0, 1, 100, 600, "evt_air_scare_layer_2", 0, 1, 150, 300);
	}
}

