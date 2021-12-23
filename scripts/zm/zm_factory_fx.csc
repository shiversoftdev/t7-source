// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#namespace zm_factory_fx;

/*
	Name: precache_util_fx
	Namespace: zm_factory_fx
	Checksum: 0x99EC1590
	Offset: 0x6E8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache_util_fx()
{
}

/*
	Name: main
	Namespace: zm_factory_fx
	Checksum: 0xD2F160B4
	Offset: 0x6F8
	Size: 0x274
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_util_fx();
	precache_createfx_fx();
	disablefx = getdvarint("disable_fx");
	if(!isdefined(disablefx) || disablefx <= 0)
	{
		precache_scripted_fx();
	}
	level.teleport_pad_names = [];
	level.teleport_pad_names[0] = "a";
	level.teleport_pad_names[1] = "c";
	level.teleport_pad_names[2] = "b";
	level thread perk_wire_fx("pw0", "pad_0_wire", "t01");
	level thread perk_wire_fx("pw1", "pad_1_wire", "t11");
	level thread perk_wire_fx("pw2", "pad_2_wire", "t21");
	level thread teleporter_map_light(0, "t01");
	level thread teleporter_map_light(1, "t11");
	level thread teleporter_map_light(2, "t21");
	level.map_light_receiver_on = 0;
	level thread teleporter_map_light_receiver();
	level thread dog_start_monitor();
	level thread dog_stop_monitor();
	level thread light_model_swap("smodel_light_electric", "lights_indlight_on");
	level thread light_model_swap("smodel_light_electric_milit", "lights_milit_lamp_single_int_on");
	level thread light_model_swap("smodel_light_electric_tinhatlamp", "lights_tinhatlamp_on");
}

/*
	Name: precache_scripted_fx
	Namespace: zm_factory_fx
	Checksum: 0x1C888C2D
	Offset: 0x978
	Size: 0x18A
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["electric_short_oneshot"] = "electrical/fx_elec_sparks_burst_sm_circuit_os";
	level._effect["switch_sparks"] = "electric/fx_elec_sparks_directional_orange";
	level._effect["elec_trail_one_shot"] = "electric/fx_elec_sparks_burst_sm_circuit_os";
	level._effect["zapper_light_ready"] = "maps/zombie/fx_zombie_light_glow_green";
	level._effect["zapper_light_notready"] = "maps/zombie/fx_zombie_light_glow_red";
	level._effect["wire_sparks_oneshot"] = "electrical/fx_elec_wire_spark_dl_oneshot";
	level._effect["wire_spark"] = "electric/fx_elec_sparks_burst_sm_circuit_os";
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	level._effect["headshot"] = "zombie/fx_bul_flesh_head_fatal_zmb";
	level._effect["headshot_nochunks"] = "zombie/fx_bul_flesh_head_nochunks_zmb";
	level._effect["bloodspurt"] = "zombie/fx_bul_flesh_neck_spurt_zmb";
	level._effect["powerup_on"] = "zombie/fx_powerup_on_green_zmb";
	level._effect["animscript_gib_fx"] = "zombie/fx_blood_torso_explo_zmb";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
}

/*
	Name: precache_createfx_fx
	Namespace: zm_factory_fx
	Checksum: 0xF5991F53
	Offset: 0xB10
	Size: 0xFE
	Parameters: 0
	Flags: Linked
*/
function precache_createfx_fx()
{
	level._effect["a_embers_falling_sm"] = "env/fire/fx_embers_falling_sm";
	level._effect["mp_smoke_stack"] = "zombie/fx_smk_stack_burning_zmb";
	level._effect["mp_elec_spark_fast_random"] = "electric/fx_elec_sparks_burst_sm_circuit_os";
	level._effect["zombie_elec_gen_idle"] = "zombie/fx_elec_gen_idle_zmb";
	level._effect["zombie_moon_eclipse"] = "zombie/fx_moon_eclipse_zmb";
	level._effect["zombie_clock_hand"] = "zombie/fx_clock_hand_zmb";
	level._effect["zombie_elec_pole_terminal"] = "zombie/fx_elec_pole_terminal_zmb";
	level._effect["mp_elec_broken_light_1shot"] = "electric/fx_elec_sparks_burst_sm_circuit_os";
	level._effect["zapper"] = "dlc0/factory/fx_elec_trap_factory";
}

/*
	Name: perk_wire_fx
	Namespace: zm_factory_fx
	Checksum: 0x65BE98D4
	Offset: 0xC18
	Size: 0x9E
	Parameters: 3
	Flags: Linked
*/
function perk_wire_fx(notify_wait, init_targetname, done_notify)
{
	level waittill(notify_wait);
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread perk_wire_fx_client(i, init_targetname, done_notify);
	}
}

/*
	Name: perk_wire_fx_client
	Namespace: zm_factory_fx
	Checksum: 0x45169203
	Offset: 0xCC0
	Size: 0x25E
	Parameters: 3
	Flags: Linked
*/
function perk_wire_fx_client(clientnum, init_targetname, done_notify)
{
	/#
		println("" + clientnum);
	#/
	targ = struct::get(init_targetname, "targetname");
	if(!isdefined(targ))
	{
		return;
	}
	mover = spawn(clientnum, targ.origin, "script_model");
	mover setmodel("tag_origin");
	fx = playfxontag(clientnum, level._effect["wire_spark"], mover, "tag_origin");
	playsound(0, "tele_spark_hit", mover.origin);
	mover playloopsound("tele_spark_loop");
	while(isdefined(targ))
	{
		if(isdefined(targ.target))
		{
			/#
				println((("" + clientnum) + "") + targ.target);
			#/
			target = struct::get(targ.target, "targetname");
			mover moveto(target.origin, 0.1);
			wait(0.1);
			targ = target;
		}
		else
		{
			break;
		}
	}
	level notify(#"spark_done");
	mover delete();
	level notify(done_notify);
}

/*
	Name: ramp_fog_in_out
	Namespace: zm_factory_fx
	Checksum: 0x2539B9AA
	Offset: 0xF28
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function ramp_fog_in_out()
{
	for(localclientnum = 0; localclientnum < level.localplayers.size; localclientnum++)
	{
		setlitfogbank(localclientnum, -1, 1, -1);
		setworldfogactivebank(localclientnum, 2);
	}
	wait(2.5);
	for(localclientnum = 0; localclientnum < level.localplayers.size; localclientnum++)
	{
		setlitfogbank(localclientnum, -1, 0, -1);
		setworldfogactivebank(localclientnum, 1);
	}
}

/*
	Name: dog_start_monitor
	Namespace: zm_factory_fx
	Checksum: 0x50D9434A
	Offset: 0x1008
	Size: 0x188
	Parameters: 0
	Flags: Linked
*/
function dog_start_monitor()
{
	while(true)
	{
		level waittill(#"dog_start");
		level thread ramp_fog_in_out();
		start_dist = 229;
		half_dist = 200;
		half_height = 380;
		base_height = 200;
		fog_r = 0.0117647;
		fog_g = 0.0156863;
		fog_b = 0.0235294;
		fog_scale = 5.5;
		sun_col_r = 0.0313726;
		sun_col_g = 0.0470588;
		sun_col_b = 0.0823529;
		sun_dir_x = -0.1761;
		sun_dir_y = 0.689918;
		sun_dir_z = 0.702141;
		sun_start_ang = 0;
		sun_stop_ang = 49.8549;
		time = 7;
		max_fog_opacity = 1;
	}
}

/*
	Name: dog_stop_monitor
	Namespace: zm_factory_fx
	Checksum: 0x6DBBC603
	Offset: 0x1198
	Size: 0x180
	Parameters: 0
	Flags: Linked
*/
function dog_stop_monitor()
{
	while(true)
	{
		level waittill(#"dog_stop");
		level thread ramp_fog_in_out();
		start_dist = 440;
		half_dist = 3200;
		half_height = 225;
		base_height = 64;
		fog_r = 0.533;
		fog_g = 0.717;
		fog_b = 1;
		fog_scale = 1;
		sun_col_r = 0.0313726;
		sun_col_g = 0.0470588;
		sun_col_b = 0.0823529;
		sun_dir_x = -0.1761;
		sun_dir_y = 0.689918;
		sun_dir_z = 0.702141;
		sun_start_ang = 0;
		sun_stop_ang = 0;
		time = 7;
		max_fog_opacity = 1;
	}
}

/*
	Name: level_fog_init
	Namespace: zm_factory_fx
	Checksum: 0x83D2ED7F
	Offset: 0x1320
	Size: 0x156
	Parameters: 0
	Flags: None
*/
function level_fog_init()
{
	start_dist = 440;
	half_dist = 3200;
	half_height = 225;
	base_height = 64;
	fog_r = 0.219608;
	fog_g = 0.403922;
	fog_b = 0.686275;
	fog_scale = 1;
	sun_col_r = 0.0313726;
	sun_col_g = 0.0470588;
	sun_col_b = 0.0823529;
	sun_dir_x = -0.1761;
	sun_dir_y = 0.689918;
	sun_dir_z = 0.702141;
	sun_start_ang = 0;
	sun_stop_ang = 0;
	time = 0;
	max_fog_opacity = 1;
}

/*
	Name: light_model_swap
	Namespace: zm_factory_fx
	Checksum: 0xDFD533C1
	Offset: 0x1480
	Size: 0xE8
	Parameters: 2
	Flags: Linked
*/
function light_model_swap(name, model)
{
	level waittill(#"pl1");
	players = getlocalplayers();
	for(p = 0; p < players.size; p++)
	{
		lamps = getentarray(p, name, "targetname");
		for(i = 0; i < lamps.size; i++)
		{
			lamps[i] setmodel(model);
		}
	}
}

/*
	Name: get_guide_struct_angles
	Namespace: zm_factory_fx
	Checksum: 0xD41484E4
	Offset: 0x1570
	Size: 0x134
	Parameters: 1
	Flags: None
*/
function get_guide_struct_angles(ent)
{
	guide_structs = struct::get_array("map_fx_guide_struct", "targetname");
	if(guide_structs.size > 0)
	{
		guide = guide_structs[0];
		dist = distancesquared(ent.origin, guide.origin);
		for(i = 1; i < guide_structs.size; i++)
		{
			new_dist = distancesquared(ent.origin, guide_structs[i].origin);
			if(new_dist < dist)
			{
				guide = guide_structs[i];
				dist = new_dist;
			}
		}
		return guide.angles;
	}
	return (0, 0, 0);
}

/*
	Name: teleporter_map_light
	Namespace: zm_factory_fx
	Checksum: 0xCA338342
	Offset: 0x16B0
	Size: 0x184
	Parameters: 2
	Flags: Linked
*/
function teleporter_map_light(index, on_msg)
{
	level waittill(#"pl1");
	exploder::exploder(("map_lgt_" + level.teleport_pad_names[index]) + "_red");
	level waittill(on_msg);
	exploder::stop_exploder(("map_lgt_" + level.teleport_pad_names[index]) + "_red");
	exploder::exploder(("map_lgt_" + level.teleport_pad_names[index]) + "_green");
	level thread scene::play(("fxanim_diff_engine_zone_" + level.teleport_pad_names[index]) + "1", "targetname");
	level thread scene::play(("fxanim_diff_engine_zone_" + level.teleport_pad_names[index]) + "2", "targetname");
	level thread scene::play("fxanim_powerline_" + level.teleport_pad_names[index], "targetname");
}

/*
	Name: teleporter_map_light_receiver
	Namespace: zm_factory_fx
	Checksum: 0x7E5F9E49
	Offset: 0x1840
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function teleporter_map_light_receiver()
{
	level waittill(#"pl1");
	level thread teleporter_map_light_receiver_flash();
	exploder::exploder("map_lgt_pap_red");
	level waittill(#"pap1");
	wait(1.5);
	exploder::stop_exploder("map_lgt_pap_red");
	exploder::stop_exploder("map_lgt_pap_flash");
	exploder::exploder("map_lgt_pap_green");
}

/*
	Name: teleporter_map_light_receiver_flash
	Namespace: zm_factory_fx
	Checksum: 0xE2DB1265
	Offset: 0x18E8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function teleporter_map_light_receiver_flash()
{
	level endon(#"pap1");
	level waittill(#"trf");
	level endon(#"trs");
	level thread teleporter_map_light_receiver_stop();
	exploder::stop_exploder("map_lgt_pap_red");
	exploder::exploder("map_lgt_pap_flash");
}

/*
	Name: teleporter_map_light_receiver_stop
	Namespace: zm_factory_fx
	Checksum: 0xFE26B782
	Offset: 0x1960
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function teleporter_map_light_receiver_stop()
{
	level endon(#"pap1");
	level waittill(#"trs");
	exploder::stop_exploder("map_lgt_pap_flash");
	exploder::exploder("map_lgt_pap_red");
	level thread teleporter_map_light_receiver_flash();
}

