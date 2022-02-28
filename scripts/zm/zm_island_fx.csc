// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace zm_island_fx;

/*
	Name: __init__sytem__
	Namespace: zm_island_fx
	Checksum: 0x6AB58937
	Offset: 0x1E18
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_fx", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_island_fx
	Checksum: 0xFCEED3B0
	Offset: 0x1E58
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "do_fade_material", 9000, 3, "float", &do_fade_material, 0, 0);
	clientfield::register("scriptmover", "do_fade_material_slow", 9000, 3, "float", &do_fade_material_slow, 0, 0);
	clientfield::register("scriptmover", "do_fade_material_direct", 9000, 3, "float", &do_fade_material_direct, 0, 0);
	clientfield::register("scriptmover", "do_emissive_material", 9000, 3, "float", &do_emissive_material, 0, 0);
	clientfield::register("scriptmover", "do_emissive_material_direct", 9000, 3, "float", &do_emissive_material_direct, 0, 0);
}

/*
	Name: main
	Namespace: zm_island_fx
	Checksum: 0xCF57D351
	Offset: 0x1FD0
	Size: 0xEAA
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level._effect["zm_bgb_machine_available"] = "dlc2/island/fx_bgb_machine_available_island";
	level._effect["zm_bgb_machine_flying_elec"] = "dlc2/island/fx_bgb_machine_flying_elec_island";
	level._effect["zm_bgb_machine_bulb_away"] = "dlc2/island/fx_bgb_machine_bulb_away_island";
	level._effect["zm_bgb_machine_bulb_available"] = "dlc2/island/fx_bgb_machine_bulb_available_island";
	level._effect["zm_bgb_machine_bulb_activated"] = "dlc2/island/fx_bgb_machine_bulb_activated_island";
	level._effect["zm_bgb_machine_bulb_event"] = "dlc2/island/fx_bgb_machine_bulb_event_island";
	level._effect["zm_bgb_machine_bulb_rounds"] = "dlc2/island/fx_bgb_machine_bulb_rounds_island";
	level._effect["zm_bgb_machine_bulb_time"] = "dlc2/island/fx_bgb_machine_bulb_time_island";
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "weapon/bullet/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["water_motes"] = "water/fx_underwater_debris_player_loop";
	level._effect["bubbles"] = "dlc2/island/fx_plyr_swim_bubbles_body_isl";
	level._effect["deadly_gas"] = "zombie/fx_exp_noxious_gas";
	level._effect["smoke_trail"] = "_debug/fx_test_smoke_trail";
	level._effect["airdrop_plane_smoke"] = "dlc2/island/fx_smk_plane_perk_crash_trail_sm";
	level._effect["lightning_shield_control_panel"] = "dlc2/island/fx_elec_control_panel_cage";
	level._effect["lightning_shield_1p"] = "dlc2/island/fx_elec_shield_ambient_1p";
	level._effect["lightning_shield_3p"] = "dlc2/island/fx_elec_shield_ambient_3p";
	level._effect["bgb_lightning_fx"] = "dlc2/island/fx_elec_gobblegum";
	level._effect["perk_lightning_fx_dbltap"] = "dlc2/island/fx_elec_perk_dbltap";
	level._effect["perk_lightning_fx_jugg"] = "dlc2/island/fx_elec_perk_jugg";
	level._effect["perk_lightning_fx_revive"] = "dlc2/island/fx_elec_perk_revive";
	level._effect["perk_lightning_fx_speed"] = "dlc2/island/fx_elec_perk_speed";
	level._effect["perk_lightning_fx_staminup"] = "dlc2/island/fx_elec_perk_staminup";
	level._effect["perk_lightning_fx_mulekick"] = "dlc2/island/fx_elec_perk_mulekick";
	level._effect["gear_smoke_trail"] = "dlc2/island/fx_smk_gear_piece_trail";
	level._effect["gear_smoke_smolder"] = "dlc2/island/fx_smk_gear_piece_smolder";
	level._effect["bomber_fire_trail"] = "dlc2/island/fx_perk_bomber_engine_trail";
	level._effect["bomber_explode"] = "dlc2/island/fx_aa_plane_exp";
	level._effect["glow_piece"] = "zombie/fx_ritual_glow_memento_zod_zmb";
	level._effect["water_splash"] = "dlc2/island/fx_water_zombie_splash";
	level._effect["plant_watered"] = "dlc2/island/fx_plant_watered";
	level._effect["plant_watered_startup"] = "dlc2/island/fx_plant_watered_startup";
	level._effect["plant_hit_with_ww"] = "dlc2/island/fx_plant_fertilized";
	level._effect["major_cache_plant"] = "dlc2/island/fx_plant_cache_glow";
	level._effect["babysitter_plant"] = "dlc2/island/fx_plant_babysitter_idle";
	level._effect["trap_plant"] = "dlc2/island/fx_plant_trap_pheromones";
	level._effect["cache_slime"] = "dlc2/island/fx_plant_cache_slime";
	level._effect["cache_slime_small"] = "dlc2/island/fx_plant_cache_slime_sm";
	level._effect["clone_plant_emerge"] = "dlc2/island/fx_plant_clone_slime_1p";
	level._effect["fruit_plant_vomit"] = "water/fx_liquid_vomit";
	level._effect["portal_shortcut_closed"] = "zombie/fx_quest_portal_tear_zod_zmb";
	level._effect["portal_shortcut_open_border"] = "zombie/fx_quest_portal_edge_zod_zmb";
	level._effect["portal_shortcut_ambient"] = "zombie/fx_quest_portal_ambient_zod_zmb";
	level._effect["portal_shortcut_pulse"] = "zombie/fx_quest_portal_edge_flash_zod_zmb";
	level._effect["portal_shortcut_opening"] = "zombie/fx_quest_portal_expand_zod_zmb";
	level._effect["portal_shortcut_closed_base"] = "zombie/fx_quest_portal_closed_zod_zmb";
	level._effect["portal_shortcut_ending"] = "zombie/fx_quest_portal_close_igc_zod_zmb";
	level._effect["power_switch_light_red"] = "dlc2/island/fx_lgt_bunker_blink_red";
	level._effect["power_switch_light_green"] = "dlc2/island/fx_lgt_bunker_blink_green";
	level._effect["tower_light_red"] = "dlc2/island/fx_tower_light_red";
	level._effect["tower_light_green"] = "dlc2/island/fx_tower_light_green";
	level._effect["power_switch_plant_glow"] = "_debug/fx_glow_shadow_debug_blue";
	level._effect["bucket_fx"] = "dlc2/island/fx_bucket_115_glow";
	level._effect["SIDE_EE_GT_SPORE_TRAIL_GOOD"] = "dlc2/island/fx_plyr_spores_good_trail";
	level._effect["SIDE_EE_GT_SPORE_TRAIL"] = "dlc2/island/fx_plyr_spores_trail";
	level._effect["SIDE_EE_GT_SPORE_CLOUD_GOOD_LG"] = "dlc2/island/fx_spores_cloud_ambient_good_lrg";
	level._effect["SIDE_EE_GT_SPORE_CLOUD_GOOD_MD"] = "dlc2/island/fx_spores_cloud_ambient_good_md";
	level._effect["SIDE_EE_GT_SPORE_CLOUD_GOOD_SM"] = "dlc2/island/fx_spores_cloud_ambient_good_sm";
	level._effect["SIDE_EE_GT_SPORE_CLOUD_LG"] = "dlc2/island/fx_spores_cloud_ambient_lrg";
	level._effect["SIDE_EE_GT_SPORE_CLOUD_MD"] = "dlc2/island/fx_spores_cloud_ambient_md";
	level._effect["SIDE_EE_GT_SPORE_CLOUD_SM"] = "dlc2/island/fx_spores_cloud_ambient_sm";
	level._effect["SIDE_EE_GT_SPORE_CLOUD_EXP_GOOD_LG"] = "dlc2/island/fx_spores_cloud_exp_good_lrg";
	level._effect["SIDE_EE_GT_SPORE_CLOUD_EXP_GOOD_MD"] = "dlc2/island/fx_spores_cloud_exp_good_md";
	level._effect["SIDE_EE_GT_SPORE_CLOUD_EXP_GOOD_SM"] = "dlc2/island/fx_spores_cloud_exp_good_sm";
	level._effect["SIDE_EE_GT_SPORE_CLOUD_EXP_LG"] = "dlc2/island/fx_spores_cloud_exp_lg";
	level._effect["SIDE_EE_GT_SPORE_CLOUD_EXP_MD"] = "dlc2/island/fx_spores_cloud_exp_md";
	level._effect["SIDE_EE_GT_SPORE_CLOUD_EXP_SM"] = "dlc2/island/fx_spores_cloud_exp_sm";
	level._effect["SIDE_EE_GT_SPORE_GLOW"] = "dlc2/island/fx_spores_cloud_primed";
	level._effect["SIDE_EE_GT_EYES"] = "dlc2/island/fx_thrash_eye_glow_good";
	level._effect["SIDE_EE_GT_SPINE"] = "dlc2/island/fx_thrash_good_gas_torso";
	level._effect["SIDE_EE_GT_LEG_L"] = "dlc2/island/fx_thrash_good_gas_leg_lft";
	level._effect["SIDE_EE_GT_LEG_R"] = "dlc2/island/fx_thrash_good_gas_leg_rgt";
	level._effect["spider_glow_red"] = "dlc2/island/fx_ee_spider_glow_island";
	level._effect["cocooned_fx"] = "dlc2/island/fx_ee_spider_webbing_player_island";
	level._effect["spider_drink_meteor"] = "dlc2/island/fx_ee_spider_drink_meteor_island";
	level._effect["spider_drink_lair"] = "dlc2/island/fx_ee_spider_drink_lair_island";
	level._effect["spider_drink_bunker"] = "dlc2/island/fx_ee_spider_drink_bunker_island";
	level._effect["keeper_spawn"] = "zombie/fx_portal_keeper_spawn_zod_zmb";
	level._effect["keeper_glow"] = "zombie/fx_keeper_ambient_torso_zod_zmb";
	level._effect["keeper_death"] = "dlc2/island/fx_keeper_death_island";
	level._effect["keeper_mouth"] = "zombie/fx_keeper_glow_mouth_zod_zmb";
	level._effect["keeper_trail"] = "zombie/fx_keeper_mist_trail_zod_zmb";
	level._effect["ritual_attacker"] = "dlc2/island/fx_skull_quest_glow_zombie_island";
	level._effect["ritual_portal_start"] = "dlc2/island/fx_skull_quest_portal_start_island";
	level._effect["ritual_portal_loop"] = "dlc2/island/fx_skull_quest_portal_loop_island";
	level._effect["ritual_portal_end"] = "dlc2/island/fx_skull_quest_portal_end_island";
	level._effect["ritual_progress_skulltar"] = "dlc2/zmb_weapon/fx_skull_quest_cleanse_glow_island";
	level._effect["ritual_success_skull"] = "dlc2/zmb_weapon/fx_skull_quest_cleanse_end_island";
	level._effect["ritual_progress_skull"] = "dlc2/zmb_weapon/fx_skull_quest_cleanse_island";
	level._effect["ritual_progress_skull_75"] = "dlc2/zmb_weapon/fx_skull_quest_cleanse_75_island";
	level._effect["ritual_progress_skull_50"] = "dlc2/zmb_weapon/fx_skull_quest_cleanse_50_island";
	level._effect["ritual_progress_skull_25"] = "dlc2/zmb_weapon/fx_skull_quest_cleanse_25_island";
	level._effect["ritual_progress_skull_fail"] = "dlc2/zmb_weapon/fx_skull_quest_cleanse_fail_island";
	level._effect["skullquest_finish_start"] = "dlc2/zmb_weapon/fx_skull_quest_ritual_start_island";
	level._effect["skullquest_finish_trail"] = "dlc2/zmb_weapon/fx_skull_quest_ritual_trail_island";
	level._effect["skullquest_finish_end"] = "dlc2/zmb_weapon/fx_skull_quest_ritual_end_island";
	level._effect["skullquest_skull_done_glow"] = "dlc2/zmb_weapon/fx_skull_quest_ritual_glow_island";
	level._effect["takeofight_postule_burst"] = "dlc2/island/fx_takeo_arm_pustule_burst";
	level._effect["current_effect"] = "debris/fx_debris_underwater_current_sgen_os";
	level._effect["transport_power_off"] = "dlc2/island/fx_lgt_bunker_blink_red";
	level._effect["transport_power_on"] = "dlc2/island/fx_lgt_bunker_blink_green";
	level._effect["glow_formula_piece"] = "zombie/fx_ritual_glow_memento_zod_zmb";
	level._effect["ww_part_underwater_plant"] = "dlc2/island/fx_plant_glow_underwater";
	level._effect["ww_part_scientist_vial"] = "dlc2/island/fx_powerup_on_formula_island";
	level._effect["spider_pheromone"] = "dlc2/island/fx_ee_spider_cage_trap_pheromone";
	level._effect["door_vine_fx"] = "dlc2/island/fx_vinegate_open";
	level._effect["SPORE_TRAIL_GOOD"] = "dlc2/island/fx_plyr_spores_good_trail";
	level._effect["SPORE_TRAIL_GOOD_CAM"] = "dlc2/island/fx_plyr_spores_good_trail_cam";
	level._effect["SPORE_TRAIL"] = "dlc2/island/fx_plyr_spores_trail";
	level._effect["SPORE_TRAIL_CAM"] = "dlc2/island/fx_plyr_spores_trail_cam";
	level._effect["SPORE_CLOUD_GOOD_LG"] = "dlc2/island/fx_spores_cloud_ambient_good_lrg";
	level._effect["SPORE_CLOUD_GOOD_MD"] = "dlc2/island/fx_spores_cloud_ambient_good_md";
	level._effect["SPORE_CLOUD_GOOD_SM"] = "dlc2/island/fx_spores_cloud_ambient_good_sm";
	level._effect["SPORE_CLOUD_LG"] = "dlc2/island/fx_spores_cloud_ambient_lrg";
	level._effect["SPORE_CLOUD_MD"] = "dlc2/island/fx_spores_cloud_ambient_md";
	level._effect["SPORE_CLOUD_SM"] = "dlc2/island/fx_spores_cloud_ambient_sm";
	level._effect["SPORE_CLOUD_EXP_GOOD_LG"] = "dlc2/island/fx_spores_cloud_exp_good_lrg";
	level._effect["SPORE_CLOUD_EXP_GOOD_MD"] = "dlc2/island/fx_spores_cloud_exp_good_md";
	level._effect["SPORE_CLOUD_EXP_GOOD_SM"] = "dlc2/island/fx_spores_cloud_exp_good_sm";
	level._effect["SPORE_CLOUD_EXP_LG"] = "dlc2/island/fx_spores_cloud_exp_lg";
	level._effect["SPORE_CLOUD_EXP_MD"] = "dlc2/island/fx_spores_cloud_exp_md";
	level._effect["SPORE_CLOUD_EXP_SM"] = "dlc2/island/fx_spores_cloud_exp_sm";
	level._effect["SPORE_GLOW"] = "dlc2/island/fx_spores_cloud_primed";
	level._effect["SPORE_BUBBLES"] = "dlc2/island/fx_plyr_spores_oxygen_1p";
	level._effect["spider_queen_bleed_lg"] = "dlc2/island/fx_spider_queen_bleed_lg";
	level._effect["spider_queen_bleed_md"] = "dlc2/island/fx_spider_queen_bleed_md";
	level._effect["spider_queen_bleed_sm"] = "dlc2/island/fx_spider_queen_bleed_sm";
	level._effect["spider_queen_weakspot"] = "dlc2/island/fx_spider_queen_roar";
	level._effect["spider_queen_mouth_glow"] = "dlc2/island/fx_spider_queen_mouth_glow";
}

/*
	Name: do_fade_material
	Namespace: zm_island_fx
	Checksum: 0xC64E0097
	Offset: 0x2E88
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function do_fade_material(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	b_on = 0;
	if(newval <= 0)
	{
		b_on = 0;
	}
	else
	{
		b_on = 1;
	}
	n_alpha = newval;
	self thread function_bea149a5(localclientnum, 0, 0.05, b_on, n_alpha);
}

/*
	Name: do_fade_material_slow
	Namespace: zm_island_fx
	Checksum: 0xBD8CFE3E
	Offset: 0x2F40
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function do_fade_material_slow(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	b_on = 0;
	if(newval <= 0)
	{
		b_on = 0;
	}
	else
	{
		b_on = 1;
	}
	n_alpha = newval;
	self thread function_bea149a5(localclientnum, 0, 0.1, b_on, n_alpha);
}

/*
	Name: do_fade_material_direct
	Namespace: zm_island_fx
	Checksum: 0xABFC713C
	Offset: 0x2FF8
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function do_fade_material_direct(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self transition_shader(localclientnum, newval, 0, 1);
}

/*
	Name: do_emissive_material
	Namespace: zm_island_fx
	Checksum: 0xFEFE8769
	Offset: 0x3060
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function do_emissive_material(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	b_on = 0;
	if(newval <= 0)
	{
		b_on = 0;
	}
	else
	{
		b_on = 1;
	}
	n_alpha = newval;
	self thread function_bea149a5(localclientnum, 2, 0.05, b_on, n_alpha, 0, 0, 0);
}

/*
	Name: do_emissive_material_direct
	Namespace: zm_island_fx
	Checksum: 0x6A7A582F
	Offset: 0x3120
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function do_emissive_material_direct(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self transition_shader(localclientnum, newval, 2, 1);
}

/*
	Name: function_bea149a5
	Namespace: zm_island_fx
	Checksum: 0x1E003576
	Offset: 0x3190
	Size: 0x2EC
	Parameters: 8
	Flags: Linked
*/
function function_bea149a5(localclientnum, var_afc7cc94, var_b05b3457, b_on, n_alpha = 1, var_abf03d83 = 0, var_c0ce8db2 = 0, var_30e780ae = 1)
{
	self endon(#"entityshutdown");
	if(self.b_on === b_on)
	{
		return;
	}
	self.b_on = b_on;
	if(var_abf03d83)
	{
		if(b_on)
		{
			self transition_shader(localclientnum, n_alpha, var_afc7cc94);
		}
		else
		{
			self transition_shader(localclientnum, 0, var_afc7cc94);
		}
		return;
	}
	if(b_on)
	{
		var_24fbb6c6 = 0;
		i = 0;
		while(var_24fbb6c6 <= n_alpha)
		{
			self transition_shader(localclientnum, var_24fbb6c6, var_afc7cc94);
			if(var_c0ce8db2)
			{
				var_24fbb6c6 = sqrt(i);
			}
			else
			{
				var_24fbb6c6 = i;
			}
			wait(0.01);
			i = i + var_b05b3457;
		}
		self.var_bbfa5d7d = n_alpha;
		self transition_shader(localclientnum, n_alpha, var_afc7cc94);
	}
	else
	{
		if(isdefined(self.var_bbfa5d7d))
		{
			var_bbfa5d7d = self.var_bbfa5d7d;
		}
		else
		{
			var_bbfa5d7d = 1;
		}
		var_24fbb6c6 = var_bbfa5d7d;
		i = var_bbfa5d7d;
		while(var_24fbb6c6 >= 0)
		{
			self transition_shader(localclientnum, var_24fbb6c6, var_afc7cc94);
			if(var_c0ce8db2)
			{
				var_24fbb6c6 = sqrt(i);
			}
			else
			{
				var_24fbb6c6 = i;
			}
			wait(0.01);
			i = i - var_b05b3457;
		}
		self transition_shader(localclientnum, 0, var_afc7cc94);
	}
}

/*
	Name: transition_shader
	Namespace: zm_island_fx
	Checksum: 0x9C99D191
	Offset: 0x3488
	Size: 0x94
	Parameters: 4
	Flags: Linked
*/
function transition_shader(localclientnum, n_value, var_afc7cc94, var_519aaca5 = 1)
{
	if(var_519aaca5)
	{
		var_43ab126f = n_value;
	}
	else
	{
		var_43ab126f = 0;
	}
	self mapshaderconstant(localclientnum, 0, "scriptVector" + var_afc7cc94, var_43ab126f, n_value, 0, 0);
}

/*
	Name: set_fade_material
	Namespace: zm_island_fx
	Checksum: 0xF500CCC8
	Offset: 0x3528
	Size: 0x64
	Parameters: 7
	Flags: None
*/
function set_fade_material(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self mapshaderconstant(localclientnum, 0, "scriptVector0", newval, 0, 0, 0);
}

