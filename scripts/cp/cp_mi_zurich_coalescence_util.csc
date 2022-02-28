// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zurich_util;

/*
	Name: __init__sytem__
	Namespace: zurich_util
	Checksum: 0xF171115A
	Offset: 0x1978
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zurich_util", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zurich_util
	Checksum: 0x76DA813C
	Offset: 0x19B8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_clientfields();
	util::init_breath_fx();
	level.var_1cf7e9e8 = [];
	level.var_18402cb = [];
	init_effects();
}

/*
	Name: init_clientfields
	Namespace: zurich_util
	Checksum: 0x1BD8B27B
	Offset: 0x1A10
	Size: 0x8EC
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	var_2d20335b = getminbitcountfornum(5);
	var_a9ef5da3 = getminbitcountfornum(6);
	visionset_mgr::register_visionset_info("cp_zurich_hallucination", 1, 1, "cp_zurich_hallucination", "cp_zurich_hallucination");
	clientfield::register("actor", "exploding_ai_deaths", 1, 1, "int", &callback_exploding_death_fx, 0, 0);
	clientfield::register("actor", "hero_spawn_fx", 1, 1, "int", &function_78bd19c4, 0, 0);
	clientfield::register("scriptmover", "hero_spawn_fx", 1, 1, "int", &function_78bd19c4, 0, 0);
	clientfield::register("scriptmover", "vehicle_spawn_fx", 1, 1, "int", &function_f026ccfa, 0, 0);
	clientfield::register("toplayer", "set_world_fog", 1, 1, "int", &function_346468e3, 0, 0);
	clientfield::register("scriptmover", "raven_juke_effect", 1, 1, "counter", &function_69d5dc62, 0, 0);
	clientfield::register("actor", "raven_juke_limb_effect", 1, 1, "counter", &function_d559bc1d, 0, 0);
	clientfield::register("scriptmover", "raven_teleport_effect", 1, 1, "counter", &function_cb609334, 0, 0);
	clientfield::register("actor", "raven_teleport_limb_effect", 1, 1, "counter", &function_496c80db, 0, 0);
	clientfield::register("scriptmover", "raven_teleport_in_effect", 1, 1, "counter", &function_c39ee0a8, 0, 0);
	clientfield::register("toplayer", "player_weather", 1, var_2d20335b, "int", &function_6120ef33, 0, 0);
	clientfield::register("toplayer", "vortex_teleport", 1, 1, "counter", &function_560fbdb4, 0, 0);
	clientfield::register("toplayer", "postfx_futz", 1, 1, "counter", &postfx_futz, 0, 0);
	clientfield::register("toplayer", "postfx_futz_mild", 1, 1, "counter", &postfx_futz_mild, 0, 0);
	clientfield::register("toplayer", "postfx_transition", 1, 1, "counter", &function_edf5c801, 0, 0);
	clientfield::register("world", "zurich_city_ambience", 1, 1, "int", &function_14b2ccdd, 0, 0);
	clientfield::register("actor", "skin_transition_melt", 1, 1, "int", &function_28572b48, 0, 1);
	clientfield::register("scriptmover", "corvus_body_fx", 1, 1, "int", &function_b5037219, 0, 0);
	clientfield::register("actor", "raven_ai_rez", 1, 1, "int", &function_91c7508e, 0, 0);
	clientfield::register("scriptmover", "raven_ai_rez", 1, 1, "int", &function_91c7508e, 0, 0);
	clientfield::register("toplayer", "zurich_server_cam", 1, 1, "int", &function_9596c4e, 0, 0);
	clientfield::register("world", "set_exposure_bank", 1, 1, "int", &function_1e832062, 0, 0);
	clientfield::register("scriptmover", "corvus_tree_shader", 1, 1, "int", &function_51e77d4f, 0, 0);
	clientfield::register("actor", "hero_cold_breath", 1, 1, "int", &function_33714f9b, 0, 0);
	clientfield::register("world", "set_post_color_grade_bank", 1, 1, "int", &function_7b22d9c9, 0, 0);
	clientfield::register("toplayer", "postfx_hallucinations", 1, 1, "counter", &function_6ec9825e, 0, 0);
	clientfield::register("toplayer", "player_water_transition", 1, 1, "int", &function_70a9fa32, 0, 0);
	clientfield::register("toplayer", "raven_hallucinations", 1, 1, "int", &function_8f5cd506, 0, 0);
	clientfield::register("scriptmover", "quadtank_raven_explosion", 1, 1, "int", &function_45e22343, 0, 0);
	clientfield::register("scriptmover", "raven_fade_out", 1, 1, "int", &function_629bf9a7, 0, 0);
}

/*
	Name: init_effects
	Namespace: zurich_util
	Checksum: 0xBFBBE807
	Offset: 0x2308
	Size: 0x756
	Parameters: 0
	Flags: Linked
*/
function init_effects()
{
	level._effect["exploding_death"] = "player/fx_ai_raven_dissolve_torso";
	level._effect["vehicle_spawn_fx"] = "player/fx_ai_dni_rez_in_hero_clean";
	level._effect["raven_juke_effect"] = "player/fx_ai_raven_juke_out";
	level._effect["raven_juke_effect_arm_le"] = "player/fx_ai_raven_juke_out_arm_le";
	level._effect["raven_juke_effect_arm_ri"] = "player/fx_ai_raven_juke_out_arm_ri";
	level._effect["raven_juke_effect_leg_le"] = "player/fx_ai_raven_juke_out_leg_le";
	level._effect["raven_juke_effect_leg_ri"] = "player/fx_ai_raven_juke_out_leg_ri";
	level._effect["raven_teleport_effect"] = "player/fx_ai_raven_teleport";
	level._effect["raven_teleport_effect_arm_le"] = "player/fx_ai_raven_teleport_out_arm_le";
	level._effect["raven_teleport_effect_arm_ri"] = "player/fx_ai_raven_teleport_out_arm_ri";
	level._effect["raven_teleport_effect_leg_le"] = "player/fx_ai_raven_teleport_out_leg_le";
	level._effect["raven_teleport_effect_leg_ri"] = "player/fx_ai_raven_teleport_out_leg_ri";
	level._effect["raven_teleport_in_effect"] = "player/fx_ai_raven_teleport_in";
	level._effect["red_rain"] = "weather/fx_rain_system_hvy_blood_runner_loop";
	level._effect["light_snow"] = "weather/fx_snow_player_lt_loop";
	level._effect["regular_snow"] = "weather/fx_snow_player_loop";
	level._effect["reverse_snow"] = "weather/fx_snow_player_loop_reverse";
	level._effect["vortex_explode"] = "player/fx_ai_dni_rez_in_hero_clean";
	level._effect["corvus_fx_arm_le"] = "player/fx_ai_corvus_arm_left_loop";
	level._effect["corvus_fx_arm_ri"] = "player/fx_ai_corvus_arm_right_loop";
	level._effect["corvus_fx_head"] = "player/fx_ai_corvus_head_loop";
	level._effect["corvus_fx_hip_le"] = "player/fx_ai_corvus_hip_left_loop";
	level._effect["corvus_fx_hip_ri"] = "player/fx_ai_corvus_hip_right_loop";
	level._effect["corvus_fx_leg_le"] = "player/fx_ai_corvus_leg_left_loop";
	level._effect["corvus_fx_leg_ri"] = "player/fx_ai_corvus_leg_right_loop";
	level._effect["corvus_fx_torso"] = "player/fx_ai_corvus_torso_loop";
	level._effect["corvus_fx_waist"] = "player/fx_ai_corvus_waist_loop";
	level._effect["hero_cold_breath"] = "player/fx_plyr_breath_steam_3p";
	level._effect["raven_in_fx_arm_le"] = "player/fx_ai_dni_rez_in_arm_left_dirty";
	level._effect["raven_in_fx_arm_ri"] = "player/fx_ai_dni_rez_in_arm_right_dirty";
	level._effect["raven_in_fx_head"] = "player/fx_ai_dni_rez_in_head_dirty";
	level._effect["raven_in_fx_hip_le"] = "player/fx_ai_dni_rez_in_hip_left_dirty";
	level._effect["raven_in_fx_hip_ri"] = "player/fx_ai_dni_rez_in_hip_right_dirty";
	level._effect["raven_in_fx_leg_le"] = "player/fx_ai_dni_rez_in_leg_left_dirty";
	level._effect["raven_in_fx_leg_ri"] = "player/fx_ai_dni_rez_in_leg_right_dirty";
	level._effect["raven_in_fx_torso"] = "player/fx_ai_dni_rez_in_torso_dirty";
	level._effect["raven_in_fx_waist"] = "player/fx_ai_dni_rez_in_waist_dirty";
	level._effect["raven_hallucination_fx"] = "animals/fx_bio_birds_raven_player_camera";
	level._effect["raven_out_fx_arm_le"] = "player/fx_ai_dni_rez_out_arm_left_dirty";
	level._effect["raven_out_fx_arm_ri"] = "player/fx_ai_dni_rez_out_arm_right_dirty";
	level._effect["raven_out_fx_head"] = "player/fx_ai_dni_rez_out_head_dirty";
	level._effect["raven_out_fx_hip_le"] = "player/fx_ai_dni_rez_out_hip_left_dirty";
	level._effect["raven_out_fx_hip_ri"] = "player/fx_ai_dni_rez_out_hip_right_dirty";
	level._effect["raven_out_fx_leg_le"] = "player/fx_ai_dni_rez_out_leg_left_dirty";
	level._effect["raven_out_fx_leg_ri"] = "player/fx_ai_dni_rez_out_leg_right_dirty";
	level._effect["raven_out_fx_torso"] = "player/fx_ai_dni_rez_out_torso_dirty";
	level._effect["raven_out_fx_waist"] = "player/fx_ai_dni_rez_out_waist_dirty";
	level._effect["hero_in_fx_arm_le"] = "player/fx_ai_dni_rez_in_arm_left_clean";
	level._effect["hero_in_fx_arm_ri"] = "player/fx_ai_dni_rez_in_arm_right_clean";
	level._effect["hero_in_fx_head"] = "player/fx_ai_dni_rez_in_head_clean";
	level._effect["hero_in_fx_hip_le"] = "player/fx_ai_dni_rez_in_hip_left_clean";
	level._effect["hero_in_fx_hip_ri"] = "player/fx_ai_dni_rez_in_hip_right_clean";
	level._effect["hero_in_fx_leg_le"] = "player/fx_ai_dni_rez_in_leg_left_clean";
	level._effect["hero_in_fx_leg_ri"] = "player/fx_ai_dni_rez_in_leg_right_clean";
	level._effect["hero_in_fx_torso"] = "player/fx_ai_dni_rez_in_torso_clean";
	level._effect["hero_in_fx_waist"] = "player/fx_ai_dni_rez_in_waist_clean";
	level._effect["hero_out_fx_arm_le"] = "player/fx_ai_dni_rez_out_arm_left_clean";
	level._effect["hero_out_fx_arm_ri"] = "player/fx_ai_dni_rez_out_arm_right_clean";
	level._effect["hero_out_fx_head"] = "player/fx_ai_dni_rez_out_head_clean";
	level._effect["hero_out_fx_hip_le"] = "player/fx_ai_dni_rez_out_hip_left_clean";
	level._effect["hero_out_fx_hip_ri"] = "player/fx_ai_dni_rez_out_hip_right_clean";
	level._effect["hero_out_fx_leg_le"] = "player/fx_ai_dni_rez_out_leg_left_clean";
	level._effect["hero_out_fx_leg_ri"] = "player/fx_ai_dni_rez_out_leg_right_clean";
	level._effect["hero_out_fx_torso"] = "player/fx_ai_dni_rez_out_torso_clean";
	level._effect["hero_out_fx_waist"] = "player/fx_ai_dni_rez_out_waist_clean";
	level._effect["quadtank_explosion_fx"] = "explosions/fx_exp_dni_raven_reveal";
	level._effect["raven_fade_out_fx"] = "animals/fx_bio_raven_dni_rez_out_dirty";
}

/*
	Name: skipto_start
	Namespace: zurich_util
	Checksum: 0x969554D4
	Offset: 0x2A68
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function skipto_start(str_objective, b_starting)
{
}

/*
	Name: function_3bf27f88
	Namespace: zurich_util
	Checksum: 0xEDDBACC4
	Offset: 0x2A88
	Size: 0x538
	Parameters: 2
	Flags: Linked
*/
function function_3bf27f88(str_objective, b_starting)
{
	if(str_objective == "plaza_battle")
	{
		wait(1);
		level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_wasp_swarm_bundle");
	}
	else
	{
		if(str_objective == "root_zurich_vortex")
		{
			wait(1);
			level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_root_wall_01_bundle");
			level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_root_wall_02_bundle");
		}
		else
		{
			if(str_objective == "root_cairo_vortex")
			{
				wait(1);
				level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_cairo_b_collapse_01_bundle");
				level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_cairo_b_collapse_02_bundle");
				level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_cairo_b_collapse_03_bundle");
				level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_cairo_lightpole_bundle");
				level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_sinkhole_01_bundle");
				level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_sinkhole_02_bundle");
			}
			else
			{
				if(str_objective == "clearing_hub_3")
				{
					wait(1);
					level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_root_door_center_bundle");
					level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_root_door_left_bundle");
					level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_root_door_right_bundle");
					level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_root_door_round_bundle");
					level struct::delete_script_bundle("scene", "cin_zur_16_02_clearing_vign_bodies01");
					level struct::delete_script_bundle("scene", "cin_zur_16_02_clearing_vign_bodies02");
					level struct::delete_script_bundle("scene", "cin_zur_16_02_clearing_vign_bodies04");
				}
				else if(str_objective == "root_singapore_vortex")
				{
					wait(1);
					level struct::delete_script_bundle("scene", "cin_zur_16_02_singapore_hanging_shortrope");
					level struct::delete_script_bundle("scene", "cin_zur_16_02_singapore_hanging_shortrope_2");
					level struct::delete_script_bundle("scene", "cin_zur_16_02_singapore_vign_bodies01");
					level struct::delete_script_bundle("scene", "cin_zur_16_02_singapore_vign_bodies02");
					level struct::delete_script_bundle("scene", "cin_zur_16_02_singapore_vign_bodies03");
					level struct::delete_script_bundle("scene", "cin_zur_16_02_singapore_vign_pulled01");
					level struct::delete_script_bundle("scene", "cin_zur_16_02_singapore_vign_pulled02");
					level struct::delete_script_bundle("scene", "cin_zur_16_02_singapore_vign_pulled03");
					level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_roots_water01_bundle");
					level struct::delete_script_bundle("scene", "p7_fxanim_cp_zurich_roots_water02_bundle");
					level struct::delete_script_bundle("scene", "p7_fxanim_gp_shutter_lt_02_red_bundle");
					level struct::delete_script_bundle("scene", "p7_fxanim_gp_shutter_lt_10_red_white_bundle");
					level struct::delete_script_bundle("scene", "p7_fxanim_gp_shutter_rt_02_red_bundle");
					level struct::delete_script_bundle("scene", "p7_fxanim_gp_shutter_rt_10_red_white_bundle");
				}
			}
		}
	}
}

/*
	Name: function_4dd02a03
	Namespace: zurich_util
	Checksum: 0x1970F0E6
	Offset: 0x2FC8
	Size: 0xFA
	Parameters: 2
	Flags: Linked
*/
function function_4dd02a03(a_ents, str_notify)
{
	if(isdefined(str_notify))
	{
		level waittill(str_notify);
	}
	if(isdefined(a_ents) && isarray(a_ents))
	{
		a_ents = array::remove_undefined(a_ents);
		if(a_ents.size)
		{
			foreach(e_ent in a_ents)
			{
				e_ent delete();
			}
		}
	}
}

/*
	Name: callback_exploding_death_fx
	Namespace: zurich_util
	Checksum: 0x3DBD7747
	Offset: 0x30D0
	Size: 0x13C
	Parameters: 7
	Flags: Linked
*/
function callback_exploding_death_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		pos = self gettagorigin("j_spine4");
		angles = self gettagangles("j_spine4");
		fxobj = util::spawn_model(localclientnum, "tag_origin", pos, angles);
		playfxontag(localclientnum, level._effect["exploding_death"], fxobj, "tag_origin");
		fxobj playsound(localclientnum, "evt_ai_explode");
		waitrealtime(6);
		fxobj delete();
	}
}

/*
	Name: function_78bd19c4
	Namespace: zurich_util
	Checksum: 0x3C9AC8F5
	Offset: 0x3218
	Size: 0x494
	Parameters: 7
	Flags: Linked
*/
function function_78bd19c4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		playfxontag(localclientnum, level._effect["hero_in_fx_arm_le"], self, "j_elbow_le");
		playfxontag(localclientnum, level._effect["hero_in_fx_arm_le"], self, "j_shoulder_le");
		playfxontag(localclientnum, level._effect["hero_in_fx_arm_ri"], self, "j_elbow_ri");
		playfxontag(localclientnum, level._effect["hero_in_fx_arm_ri"], self, "j_shoulder_ri");
		playfxontag(localclientnum, level._effect["hero_in_fx_head"], self, "j_head");
		playfxontag(localclientnum, level._effect["hero_in_fx_hip_le"], self, "j_hip_le");
		playfxontag(localclientnum, level._effect["hero_in_fx_hip_ri"], self, "j_hip_ri");
		playfxontag(localclientnum, level._effect["hero_in_fx_leg_le"], self, "j_knee_le");
		playfxontag(localclientnum, level._effect["hero_in_fx_leg_ri"], self, "j_knee_ri");
		playfxontag(localclientnum, level._effect["hero_in_fx_torso"], self, "j_spine4");
		playfxontag(localclientnum, level._effect["hero_in_fx_waist"], self, "j_spinelower");
		self playsound(localclientnum, "evt_ai_raven_spawn");
	}
	else
	{
		playfxontag(localclientnum, level._effect["hero_out_fx_arm_le"], self, "j_elbow_le");
		playfxontag(localclientnum, level._effect["hero_out_fx_arm_le"], self, "j_shoulder_le");
		playfxontag(localclientnum, level._effect["hero_out_fx_arm_ri"], self, "j_elbow_ri");
		playfxontag(localclientnum, level._effect["hero_out_fx_arm_ri"], self, "j_shoulder_ri");
		playfxontag(localclientnum, level._effect["hero_out_fx_head"], self, "j_head");
		playfxontag(localclientnum, level._effect["hero_out_fx_hip_le"], self, "j_hip_le");
		playfxontag(localclientnum, level._effect["hero_out_fx_hip_ri"], self, "j_hip_ri");
		playfxontag(localclientnum, level._effect["hero_out_fx_leg_le"], self, "j_knee_le");
		playfxontag(localclientnum, level._effect["hero_out_fx_leg_ri"], self, "j_knee_ri");
		playfxontag(localclientnum, level._effect["hero_out_fx_torso"], self, "j_spine4");
		playfxontag(localclientnum, level._effect["hero_out_fx_waist"], self, "j_spinelower");
	}
}

/*
	Name: function_f026ccfa
	Namespace: zurich_util
	Checksum: 0xFB023139
	Offset: 0x36B8
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function function_f026ccfa(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["vehicle_spawn_fx"], self, "tag_origin");
	self playsound(localclientnum, "evt_ai_raven_spawn");
}

/*
	Name: function_346468e3
	Namespace: zurich_util
	Checksum: 0xEF036DBA
	Offset: 0x3750
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function function_346468e3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		setlitfogbank(localclientnum, -1, 1, -1);
		setworldfogactivebank(localclientnum, 2);
	}
	else
	{
		setlitfogbank(localclientnum, -1, 0, -1);
		setworldfogactivebank(localclientnum, 1);
	}
}

/*
	Name: function_1e832062
	Namespace: zurich_util
	Checksum: 0x575CDB17
	Offset: 0x3820
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_1e832062(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		setexposureactivebank(localclientnum, 4);
	}
	else
	{
		setexposureactivebank(localclientnum, 1);
	}
}

/*
	Name: function_7b22d9c9
	Namespace: zurich_util
	Checksum: 0x170E32F4
	Offset: 0x38A8
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_7b22d9c9(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		setpbgactivebank(localclientnum, 2);
	}
	else
	{
		setpbgactivebank(localclientnum, 1);
	}
}

/*
	Name: function_69d5dc62
	Namespace: zurich_util
	Checksum: 0x1133BDFC
	Offset: 0x3930
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function function_69d5dc62(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["raven_juke_effect"], self, "tag_origin");
	self playsound(localclientnum, "evt_ai_juke");
}

/*
	Name: function_d559bc1d
	Namespace: zurich_util
	Checksum: 0x123F4407
	Offset: 0x39C8
	Size: 0x1BC
	Parameters: 7
	Flags: Linked
*/
function function_d559bc1d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["raven_juke_effect_arm_le"], self, "j_elbow_le");
	playfxontag(localclientnum, level._effect["raven_juke_effect_arm_le"], self, "j_shoulder_le");
	playfxontag(localclientnum, level._effect["raven_juke_effect_arm_ri"], self, "j_elbow_ri");
	playfxontag(localclientnum, level._effect["raven_juke_effect_arm_ri"], self, "j_shoulder_ri");
	playfxontag(localclientnum, level._effect["raven_juke_effect_leg_le"], self, "j_knee_le");
	playfxontag(localclientnum, level._effect["raven_juke_effect_leg_le"], self, "j_hip_le");
	playfxontag(localclientnum, level._effect["raven_juke_effect_leg_ri"], self, "j_knee_ri");
	playfxontag(localclientnum, level._effect["raven_juke_effect_leg_ri"], self, "j_hip_ri");
}

/*
	Name: function_cb609334
	Namespace: zurich_util
	Checksum: 0x887DE8F2
	Offset: 0x3B90
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function function_cb609334(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["raven_teleport_effect"], self, "tag_origin");
	self playsound(localclientnum, "evt_ai_teleoprt");
}

/*
	Name: function_496c80db
	Namespace: zurich_util
	Checksum: 0x305E7544
	Offset: 0x3C28
	Size: 0x1BC
	Parameters: 7
	Flags: Linked
*/
function function_496c80db(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["raven_teleport_effect_arm_le"], self, "j_elbow_le");
	playfxontag(localclientnum, level._effect["raven_teleport_effect_arm_le"], self, "j_shoulder_le");
	playfxontag(localclientnum, level._effect["raven_teleport_effect_arm_ri"], self, "j_elbow_ri");
	playfxontag(localclientnum, level._effect["raven_teleport_effect_arm_ri"], self, "j_shoulder_ri");
	playfxontag(localclientnum, level._effect["raven_teleport_effect_leg_le"], self, "j_knee_le");
	playfxontag(localclientnum, level._effect["raven_teleport_effect_leg_le"], self, "j_hip_le");
	playfxontag(localclientnum, level._effect["raven_teleport_effect_leg_ri"], self, "j_knee_ri");
	playfxontag(localclientnum, level._effect["raven_teleport_effect_leg_ri"], self, "j_hip_ri");
}

/*
	Name: function_c39ee0a8
	Namespace: zurich_util
	Checksum: 0x17103743
	Offset: 0x3DF0
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function function_c39ee0a8(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["raven_teleport_in_effect"], self, "tag_origin");
	self playsound(localclientnum, "evt_ai_teleport_in");
}

/*
	Name: function_560fbdb4
	Namespace: zurich_util
	Checksum: 0xA225F7D4
	Offset: 0x3E88
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function function_560fbdb4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	wait(0.1);
	v_fxpos = (self.origin + vectorscale((0, 0, 1), 32)) + (anglestoforward(self.angles) * 12);
	playfx(localclientnum, level._effect["vortex_explode"], v_fxpos);
}

/*
	Name: function_91c7508e
	Namespace: zurich_util
	Checksum: 0x9366A702
	Offset: 0x3F48
	Size: 0x494
	Parameters: 7
	Flags: Linked
*/
function function_91c7508e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		playfxontag(localclientnum, level._effect["raven_in_fx_arm_le"], self, "j_elbow_le");
		playfxontag(localclientnum, level._effect["raven_in_fx_arm_le"], self, "j_shoulder_le");
		playfxontag(localclientnum, level._effect["raven_in_fx_arm_ri"], self, "j_elbow_ri");
		playfxontag(localclientnum, level._effect["raven_in_fx_arm_ri"], self, "j_shoulder_ri");
		playfxontag(localclientnum, level._effect["raven_in_fx_head"], self, "j_head");
		playfxontag(localclientnum, level._effect["raven_in_fx_hip_le"], self, "j_hip_le");
		playfxontag(localclientnum, level._effect["raven_in_fx_hip_ri"], self, "j_hip_ri");
		playfxontag(localclientnum, level._effect["raven_in_fx_leg_le"], self, "j_knee_le");
		playfxontag(localclientnum, level._effect["raven_in_fx_leg_ri"], self, "j_knee_ri");
		playfxontag(localclientnum, level._effect["raven_in_fx_torso"], self, "j_spine4");
		playfxontag(localclientnum, level._effect["raven_in_fx_waist"], self, "j_spinelower");
		self playsound(localclientnum, "evt_ai_raven_spawn");
	}
	else
	{
		playfxontag(localclientnum, level._effect["raven_out_fx_arm_le"], self, "j_elbow_le");
		playfxontag(localclientnum, level._effect["raven_out_fx_arm_le"], self, "j_shoulder_le");
		playfxontag(localclientnum, level._effect["raven_out_fx_arm_ri"], self, "j_elbow_ri");
		playfxontag(localclientnum, level._effect["raven_out_fx_arm_ri"], self, "j_shoulder_ri");
		playfxontag(localclientnum, level._effect["raven_out_fx_head"], self, "j_head");
		playfxontag(localclientnum, level._effect["raven_out_fx_hip_le"], self, "j_hip_le");
		playfxontag(localclientnum, level._effect["raven_out_fx_hip_ri"], self, "j_hip_ri");
		playfxontag(localclientnum, level._effect["raven_out_fx_leg_le"], self, "j_knee_le");
		playfxontag(localclientnum, level._effect["raven_out_fx_leg_ri"], self, "j_knee_ri");
		playfxontag(localclientnum, level._effect["raven_out_fx_torso"], self, "j_spine4");
		playfxontag(localclientnum, level._effect["raven_out_fx_waist"], self, "j_spinelower");
	}
}

/*
	Name: function_b5037219
	Namespace: zurich_util
	Checksum: 0xA8D5DFF9
	Offset: 0x43E8
	Size: 0x3BE
	Parameters: 7
	Flags: Linked
*/
function function_b5037219(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.a_fx_id = [];
		var_120b6bed = playfxontag(localclientnum, level._effect["corvus_fx_arm_le"], self, "j_elbow_le");
		var_380de656 = playfxontag(localclientnum, level._effect["corvus_fx_arm_le"], self, "j_shoulder_le");
		var_5e1060bf = playfxontag(localclientnum, level._effect["corvus_fx_arm_ri"], self, "j_elbow_ri");
		var_53ff07e0 = playfxontag(localclientnum, level._effect["corvus_fx_arm_ri"], self, "j_shoulder_ri");
		var_5f28bb04 = playfxontag(localclientnum, level._effect["corvus_fx_head"], self, "j_head");
		var_7c88767e = playfxontag(localclientnum, level._effect["corvus_fx_hip_le"], self, "j_hip_le");
		var_5685fc15 = playfxontag(localclientnum, level._effect["corvus_fx_hip_ri"], self, "j_hip_ri");
		var_af98a017 = playfxontag(localclientnum, level._effect["corvus_fx_leg_le"], self, "j_knee_le");
		var_3d9130dc = playfxontag(localclientnum, level._effect["corvus_fx_leg_ri"], self, "j_knee_ri");
		var_a4653f43 = playfxontag(localclientnum, level._effect["corvus_fx_torso"], self, "j_spine4");
		var_a656ad3a = playfxontag(localclientnum, level._effect["corvus_fx_waist"], self, "j_spinelower");
		self.a_fx_id = array(var_120b6bed, var_380de656, var_5e1060bf, var_53ff07e0, var_5f28bb04, var_7c88767e, var_5685fc15, var_af98a017, var_3d9130dc, var_a4653f43, var_a656ad3a);
	}
	else if(isdefined(self.a_fx_id))
	{
		for(i = 0; i < self.a_fx_id.size; i++)
		{
			deletefx(localclientnum, self.a_fx_id[i], 0);
		}
		self.a_fx_id = undefined;
	}
}

/*
	Name: function_6120ef33
	Namespace: zurich_util
	Checksum: 0x2D935D1F
	Offset: 0x47B0
	Size: 0x1FC
	Parameters: 7
	Flags: Linked
*/
function function_6120ef33(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval >= 1)
	{
		if(level.var_1cf7e9e8[localclientnum] === newval)
		{
			return;
		}
		level.var_1cf7e9e8[localclientnum] = newval;
		switch(newval)
		{
			case 1:
			{
				str_fx = "regular_snow";
				n_delay = 0.5;
				self thread function_965fdae0(localclientnum, str_fx, n_delay);
				break;
			}
			case 2:
			{
				str_fx = "red_rain";
				n_delay = 0.3;
				self thread function_965fdae0(localclientnum, str_fx, n_delay);
				break;
			}
			case 3:
			{
				str_fx = "reverse_snow";
				n_delay = 0.03;
				self thread function_965fdae0(localclientnum, str_fx, n_delay);
				break;
			}
			case 4:
			{
				str_fx = "light_snow";
				n_delay = 0.03;
				self thread function_965fdae0(localclientnum, str_fx, n_delay);
				break;
			}
			default:
			{
				self function_a0b8d731(localclientnum);
				break;
			}
		}
	}
	else
	{
		self function_a0b8d731(localclientnum);
	}
}

/*
	Name: function_965fdae0
	Namespace: zurich_util
	Checksum: 0xD3B9E95F
	Offset: 0x49B8
	Size: 0xA2
	Parameters: 3
	Flags: Linked
*/
function function_965fdae0(localclientnum, str_fx, n_delay)
{
	if(isdefined(level.var_18402cb[localclientnum]))
	{
		deletefx(localclientnum, level.var_18402cb[localclientnum], 1);
		level.var_18402cb[localclientnum] = undefined;
	}
	level.var_18402cb[localclientnum] = playfxoncamera(localclientnum, level._effect[str_fx], (0, 0, 0), (1, 0, 0), (0, 0, 1));
}

/*
	Name: function_a0b8d731
	Namespace: zurich_util
	Checksum: 0x104E69D2
	Offset: 0x4A68
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function function_a0b8d731(localclientnum)
{
	level.var_1cf7e9e8[localclientnum] = undefined;
	if(isdefined(level.var_18402cb[localclientnum]))
	{
		deletefx(localclientnum, level.var_18402cb[localclientnum], 1);
		level.var_18402cb[localclientnum] = undefined;
	}
}

/*
	Name: postfx_futz
	Namespace: zurich_util
	Checksum: 0x77EB88A
	Offset: 0x4AD0
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function postfx_futz(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	playsound(localclientnum, "evt_dni_interrupt", (0, 0, 0));
	player postfx::playpostfxbundle("pstfx_dni_screen_futz");
}

/*
	Name: function_edf5c801
	Namespace: zurich_util
	Checksum: 0xA5D61993
	Offset: 0x4B80
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_edf5c801(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	player thread postfx::playpostfxbundle("pstfx_cp_transition_sprite_zur");
}

/*
	Name: postfx_futz_mild
	Namespace: zurich_util
	Checksum: 0xB760FD57
	Offset: 0x4C08
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function postfx_futz_mild(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	playsound(localclientnum, "evt_dni_interrupt", (0, 0, 0));
	player postfx::playpostfxbundle("pstfx_dni_interrupt_mild");
}

/*
	Name: function_14b2ccdd
	Namespace: zurich_util
	Checksum: 0xC3C79A4E
	Offset: 0x4CB8
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function function_14b2ccdd(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level thread scene::play("p7_fxanim_cp_zurich_wasp_swarm_bundle");
	}
	else
	{
		level scene::stop("p7_fxanim_cp_zurich_wasp_swarm_bundle", 1);
	}
}

/*
	Name: function_28572b48
	Namespace: zurich_util
	Checksum: 0x87169302
	Offset: 0x4D50
	Size: 0x120
	Parameters: 7
	Flags: Linked
*/
function function_28572b48(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		n_start_time = gettime();
		while(isdefined(self))
		{
			n_time = gettime();
			var_348e23ad = (n_time - n_start_time) / 1000;
			if(var_348e23ad >= 4)
			{
				var_348e23ad = 4;
				b_is_updating = 0;
			}
			var_daad71ff = 1 * (var_348e23ad / 4);
			self mapshaderconstant(localclientnum, 0, "scriptVector0", var_daad71ff, var_daad71ff, 0);
			wait(0.01);
		}
	}
}

/*
	Name: function_51e77d4f
	Namespace: zurich_util
	Checksum: 0x595ED69
	Offset: 0x4E78
	Size: 0x9E
	Parameters: 7
	Flags: Linked
*/
function function_51e77d4f(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(isdefined(self.var_540c25e7) && self.var_540c25e7)
		{
			return;
		}
		self.var_540c25e7 = 1;
		self thread function_276d0d02();
	}
	else
	{
		self.var_540c25e7 = undefined;
		self notify(#"hash_5cd0c3cb");
	}
}

/*
	Name: function_276d0d02
	Namespace: zurich_util
	Checksum: 0xD4B5E7AA
	Offset: 0x4F20
	Size: 0x1BA
	Parameters: 0
	Flags: Linked
*/
function function_276d0d02()
{
	self endon(#"hash_5cd0c3cb");
	n_increment = 0.1;
	n_pulse_max = 1;
	n_pulse_min = 0.4;
	n_pulse = n_pulse_min;
	while(isdefined(self))
	{
		n_cycle_time = randomfloatrange(2, 8);
		n_pulse_increment = (n_pulse_max - n_pulse_min) / (n_cycle_time / n_increment);
		while(n_pulse < n_pulse_max && isdefined(self))
		{
			self mapshaderconstant(0, 0, "scriptVector0", 1, n_pulse, 0, 0);
			n_pulse = n_pulse + n_pulse_increment;
			wait(n_increment);
		}
		n_cycle_time = randomfloatrange(2, 8);
		n_pulse_increment = (n_pulse_max - n_pulse_min) / (n_cycle_time / n_increment);
		while(n_pulse_min < n_pulse && isdefined(self))
		{
			self mapshaderconstant(0, 0, "scriptVector0", 1, n_pulse, 0, 0);
			n_pulse = n_pulse - n_pulse_increment;
			wait(n_increment);
		}
	}
}

/*
	Name: function_9596c4e
	Namespace: zurich_util
	Checksum: 0xAC9BCD1F
	Offset: 0x50E8
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function function_9596c4e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		s_align = struct::get("tag_align_coalescence_return_server");
		playmaincamxcam(localclientnum, "c_zur_20_01_plaza_1st_fight_it_shooting_cam", 0, "", "", s_align.origin, s_align.angles);
	}
	else
	{
		stopmaincamxcam(localclientnum);
	}
}

/*
	Name: function_70a9fa32
	Namespace: zurich_util
	Checksum: 0x6F45A5D9
	Offset: 0x51B8
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_70a9fa32(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self thread postfx::playpostfxbundle("pstfx_blood_transition");
	}
	else
	{
		self thread postfx::playpostfxbundle("pstfx_blood_t_out");
	}
}

/*
	Name: function_33714f9b
	Namespace: zurich_util
	Checksum: 0xCE218A76
	Offset: 0x5248
	Size: 0x6E
	Parameters: 7
	Flags: Linked
*/
function function_33714f9b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self thread function_1cb0f58c(localclientnum);
	}
	else
	{
		self notify(#"disable_breath_fx");
	}
}

/*
	Name: function_1cb0f58c
	Namespace: zurich_util
	Checksum: 0x6A7DEAC6
	Offset: 0x52C0
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function function_1cb0f58c(localclientnum)
{
	self endon(#"disable_breath_fx");
	self endon(#"entityshutdown");
	while(true)
	{
		playfxontag(localclientnum, level._effect["hero_cold_breath"], self, "j_head");
		wait(randomintrange(6, 8));
	}
}

/*
	Name: function_6ec9825e
	Namespace: zurich_util
	Checksum: 0xEE9B3BCB
	Offset: 0x5340
	Size: 0x134
	Parameters: 7
	Flags: Linked
*/
function function_6ec9825e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(newval == 1)
	{
		self playsound(0, "evt_dni_interrupt");
		self thread postfx::playpostfxbundle("pstfx_dni_screen_futz_short");
		wait(0.5);
		self thread postfx::exitpostfxbundle();
		wait(0.3);
		self thread postfx::playpostfxbundle("pstfx_raven_loop");
		wait(0.5);
		self playsound(0, "evt_dni_interrupt");
		self thread postfx::exitpostfxbundle();
	}
}

/*
	Name: function_8f5cd506
	Namespace: zurich_util
	Checksum: 0xE725E3F2
	Offset: 0x5480
	Size: 0x114
	Parameters: 7
	Flags: Linked
*/
function function_8f5cd506(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(newval)
	{
		self thread function_b5adc0ad(localclientnum);
		self thread postfx::playpostfxbundle("pstfx_dni_screen_futz_short");
		wait(0.5);
		self thread postfx::exitpostfxbundle();
	}
	else
	{
		self notify(#"hash_5ca6609a");
		wait(1.5);
		self thread postfx::playpostfxbundle("pstfx_dni_screen_futz_short");
		wait(0.15);
		self thread postfx::exitpostfxbundle();
	}
}

/*
	Name: function_b5adc0ad
	Namespace: zurich_util
	Checksum: 0x4061AD7C
	Offset: 0x55A0
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function function_b5adc0ad(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"hash_5ca6609a");
	while(true)
	{
		playfxoncamera(localclientnum, level._effect["raven_hallucination_fx"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
		wait(0.05);
	}
}

/*
	Name: function_629bf9a7
	Namespace: zurich_util
	Checksum: 0x61AFFA11
	Offset: 0x5610
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_629bf9a7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(newval)
	{
		playfxontag(localclientnum, level._effect["raven_fade_out_fx"], self, "j_spine_2");
	}
}

/*
	Name: function_45e22343
	Namespace: zurich_util
	Checksum: 0x3D7FA06A
	Offset: 0x5698
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function function_45e22343(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfxontag(localclientnum, level._effect["quadtank_explosion_fx"], self, "tag_origin");
		self playsound(0, "veh_quadtank_crowsplosion");
	}
}

