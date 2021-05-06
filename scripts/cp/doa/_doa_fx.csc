// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\doa\_doa_core;
#using scripts\shared\fx_shared;
#using scripts\shared\util_shared;

#namespace namespace_eaa992c;

/*
	Name: init
	Namespace: namespace_eaa992c
	Checksum: 0xD06E0D8B
	Offset: 0x1C40
	Size: 0x23CC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level._effect["spawnZombie"] = "zombie/fx_spawn_body_cp_zmb";
	level._effect["down_marker_green"] = "zombie/fx_marker_player_down_green_doa";
	level._effect["down_marker_blue"] = "zombie/fx_marker_player_down_blue_doa";
	level._effect["down_marker_red"] = "zombie/fx_marker_player_down_red_doa";
	level._effect["down_marker_yellow"] = "zombie/fx_marker_player_down_yellow_doa";
	level._effect["ambient_snowfall_1"] = "weather/fx_snow_player_loop";
	level._effect["ambient_rainfall_1"] = "weather/fx_rain_system_med_ne_runner_blackstation";
	level._effect["ambient_rainfall_2"] = "weather/fx_rain_system_lite_ne_runner_blackstation";
	level._effect["ambient_rainfall_3"] = "weather/fx_rain_system_med_se_runner_blackstation";
	level._effect["ambient_rainfall_4"] = "weather/fx_rain_system_lite_se_runner_blackstation";
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	level._effect["eye_glow_night"] = "zombie/fx_glow_eye_orange_night_doa";
	level._effect["def_explode"] = "explosions/fx_exp_grenade_default";
	level._effect["fast_feet"] = "fire/fx_fire_furiousfeet_os_zdo";
	level._effect["boots"] = "fire/fx_fire_furiousfeet_os_zdo";
	level._effect["magnet_on"] = "zombie/fx_magnet_ring_zdo";
	level._effect["magnet_fade"] = "zombie/fx_magnet_ring_zdo";
	level._effect["stunbear"] = "zombie/fx_powerup_stun_bear_shield_doa";
	level._effect["stunbear_fade"] = "animals/fx_bio_butterfly_top";
	level._effect["stunbear_contact"] = "zombie/fx_powerup_stun_bear_shield_impact_doa";
	level._effect["player_trail_green"] = "zombie/fx_trail_player_green_doa";
	level._effect["player_trail_blue"] = "zombie/fx_trail_player_blue_doa";
	level._effect["player_trail_red"] = "zombie/fx_trail_player_red_doa";
	level._effect["player_trail_yellow"] = "zombie/fx_trail_player_yellow_doa";
	level._effect["player_trail_green_night"] = "zombie/fx_trail_night_player_green_doa";
	level._effect["player_trail_blue_night"] = "zombie/fx_trail_night_player_blue_doa";
	level._effect["player_trail_red_night"] = "zombie/fx_trail_night_player_red_doa";
	level._effect["player_trail_yellow_night"] = "zombie/fx_trail_night_player_yellow_doa";
	level._effect["glow_blue"] = "light/fx_light_doa_pickup_glow_blue";
	level._effect["glow_yellow"] = "light/fx_light_doa_pickup_glow_gold";
	level._effect["glow_green"] = "light/fx_light_doa_pickup_glow_green";
	level._effect["glow_red"] = "light/fx_light_doa_pickup_glow_red";
	level._effect["glow_white"] = "light/fx_light_doa_pickup_glow_white";
	level._effect["glow_item"] = "light/fx_light_doa_pickup_glow_blue";
	level._effect["timeshift"] = "zombie/fx_powerup_timeshift_doa";
	level._effect["timeshift_fade"] = "zombie/fx_powerup_timeshift_doa";
	level._effect["timeshift_contact"] = "zombie/fx_powerup_timeshift_impact_doa";
	level._effect["zombie_angry"] = "zombie/fx_powerup_timeshift_impact_red_doa";
	level._effect["teamShift_contact"] = "zombie/fx_horn_doa";
	level._effect["teamShift"] = "zombie/fx_powerup_timeshift_red_doa";
	level._effect["web_contact"] = "zombie/fx_web_immobilize_doa";
	level._effect["tesla_launch"] = "electric/fx_elec_sparks_burst_blue";
	level._effect["tesla_ball"] = "electric/fx_ability_elec_surge_short_raps";
	level._effect["tesla_trail"] = "zombie/fx_trail_tesla_balls_doa";
	level._effect["tesla_shock"] = "zombie/fx_tesla_shock_doa";
	level._effect["tesla_shock_eyes"] = "zombie/fx_tesla_shock_eyes_zmb";
	level._effect["ammo_infinite"] = "zombie/fx_ammo_can_doa";
	level._effect["fire_limb_left"] = "zombie/fx_fire_arm_left_os_doa";
	level._effect["fire_limb_right"] = "zombie/fx_fire_arm_right_os_doa";
	level._effect["fire_torso"] = "zombie/fx_fire_torso_os_doa";
	level._effect["fire_limb_left_red"] = "zombie/fx_fire_arm_left_red_os_doa";
	level._effect["fire_limb_right_red"] = "zombie/fx_fire_arm_right_red_os_doa";
	level._effect["fire_torso_red"] = "zombie/fx_fire_torso_red_os_doa";
	level._effect["fire_limb_left_purple"] = "zombie/fx_fire_arm_left_purple_os_doa";
	level._effect["fire_limb_right_purple"] = "zombie/fx_fire_arm_right_purple_os_doa";
	level._effect["fire_torso_purple"] = "zombie/fx_fire_torso_purple_os_doa";
	level._effect["player_flashlight"] = "light/fx_light_doa_flashlight";
	level._effect["player_respawn_green"] = "zombie/fx_player_respawn_doa";
	level._effect["player_respawn_blue"] = "zombie/fx_player_respawn_blue_doa";
	level._effect["player_respawn_red"] = "zombie/fx_player_respawn_red_doa";
	level._effect["player_respawn_yellow"] = "zombie/fx_player_respawn_yellow_doa";
	level._effect["hazard_water"] = "electric/fx_elec_sparks_burst_med_os_doa";
	level._effect["hazard_electric"] = "electric/fx_elec_sparks_burst_med_os_doa";
	level._effect["slow_feet"] = "zombie/fx_fire_slowfeet_doa";
	level._effect["bomb"] = "zombie/fx_concussive_wave_impact_zdo";
	level._effect["character_fire_death_torso"] = "zombie/fx_fire_torso_os_doa";
	level._effect["character_fire_death_sm"] = "zombie/fx_fire_zombie_sm_os_doa";
	level._effect["gib_fx"] = "zombie/fx_blood_torso_explo_zmb";
	level._effect["gibtrail_fx"] = "blood/fx_blood_trail_zmb";
	level._effect["zombie_guts_explosion"] = "zombie/fx_blood_torso_explo_lg_os_zmb";
	level._effect["red_shield"] = "zombie/fx_shield_red_zdo";
	level._effect["player_shield_long"] = "zombie/fx_shield_zdo";
	level._effect["player_shield_short"] = "zombie/fx_shield_gone_zdo";
	level._effect["trap_red"] = "zombie/fx_trap_red_light_doa";
	level._effect["trap_green"] = "zombie/fx_trap_green_light_doa";
	level._effect["electric_trap"] = "zombie/fx_electric_trap_zdo";
	level._effect["electric_trap2"] = "zombie/fx_electric_trap_sm_light_zdo";
	level._effect["rise_burst"] = "zombie/fx_spawn_dirt_rise_doa";
	level._effect["rise_billow"] = "zombie/fx_spawn_dirt_billowing_doa";
	level._effect["rise_dust"] = "zombie/fx_spawn_dirt_body_dustfalling_zmb";
	level._effect["rise_blood_burst"] = "zombie/fx_spawn_blood_rise_doa";
	level._effect["rise_blood_billow"] = "zombie/fx_spawn_blood_billowing_doa";
	level._effect["rise_blood_dust"] = "zombie/fx_spawn_dirt_body_dustfalling_zmb";
	level._effect["trashcan_damaged"] = "zombie/fx_trashcan_damaged_doa";
	level._effect["trashcan_destroyed"] = "zombie/fx_trashcan_destroyed_doa";
	level._effect["trashcan_active"] = "zombie/fx_trashcan_doa";
	level._effect["stoneboss_shield_death"] = "electric/fx_elec_sparks_burst_med_os_doa";
	level._effect["stoneboss_shield_explode"] = "electric/fx_elec_burst_xxlg_zdo";
	level._effect["stoneboss_death"] = "electric/fx_elec_gunship_dmg_1";
	level._effect["stoneboss_dmg1"] = "explosions/fx_exp_grenade_default";
	level._effect["stoneboss_dmg2"] = "explosions/fx_exp_grenade_default";
	level._effect["stoneboss_dmg3"] = "electric/fx_elec_gunship_dmg_1";
	level._effect["stoneboss_dmg4"] = "explosions/fx_exp_grenade_default";
	level._effect["stoneboss_dmg5"] = "electric/fx_elec_gunship_dmg_1";
	level._effect["fate_trigger"] = "zombie/fx_powerup_fate_lightray_doa";
	level._effect["fate_impact"] = "zombie/fx_turret_impact_doa";
	level._effect["fate_explode"] = "zombie/fx_raygun_impact_zmb";
	level._effect["fate_launch"] = "zombie/fx_trail_fast_doa";
	level._effect["fate2_awarded"] = "zombie/fx_raygun_impact_zmb";
	level._effect["fire_trail"] = "zombie/fx_meatball_trail_zmb";
	level._effect["veh_takeoff"] = "zombie/fx_turret_impact_doa";
	level._effect["egg_hatchXL"] = "zombie/fx_powerup_egg_final_hatch_doa";
	level._effect["egg_hatch"] = "zombie/fx_powerup_egg_hatch_doa";
	level._effect["egg_explode"] = "zombie/fx_powerup_egg_destroy_doa";
	level._effect["monkey_explode"] = "zombie/fx_powerup_monkey_bomb_explo_doa";
	level._effect["boss_takeoff"] = "zombie/fx_raygun_impact_zmb";
	level._effect["sprinkler_active"] = "zombie/fx_sprinkler_active_doa";
	level._effect["sprinkler_land"] = "zombie/fx_sprinkler_impact_doa";
	level._effect["sprinkler_takeoff"] = "zombie/fx_sprinkler_impact_doa";
	level._effect["fury_patch"] = "fire/fx_fire_furiousfeet_boost_doa";
	level._effect["fury_boost"] = "zombie/fx_raygun_impact_zmb";
	level._effect["heart_explode"] = "zombie/fx_blood_torso_explo_lg_os_zmb";
	level._effect["chicken_explode"] = "animals/fx_bio_chicken_death_doa";
	level._effect["gem_trail_red"] = "zombie/fx_trail_gem_red_doa";
	level._effect["gem_trail_white"] = "zombie/fx_trail_gem_white_doa";
	level._effect["gem_trail_blue"] = "zombie/fx_trail_gem_blue_doa";
	level._effect["gem_trail_green"] = "zombie/fx_trail_gem_green_doa";
	level._effect["gem_trail_yellow"] = "zombie/fx_trail_gem_yellow_doa";
	level._effect["nuke_dust"] = "zombie/fx_debris_body_nuke_dust_doa";
	level._effect["trail_fast"] = "zombie/fx_trail_fast_doa";
	level._effect["margwa_intro"] = "explosions/fx_exp_grenade_default";
	level._effect["margwa_head_explode"] = "zombie/fx_blood_torso_explo_lg_os_zmb";
	level._effect["turret_impact"] = "zombie/fx_turret_impact_doa";
	level._effect["crater_dust"] = "zombie/fx_debris_body_nuke_dust_doa";
	level._effect["blow_hole"] = "light/fx_beam_sarah_marker_bright";
	level._effect["teleporter"] = "zombie/fx_teleporter_doa";
	level._effect["boxing_pow"] = "zombie/fx_powerup_boxer_gloves_impact_doa";
	level._effect["boxing_stars"] = "zombie/fx_powerup_boxer_gloves_impact_stars_doa";
	level._effect["stunbear_affected"] = "zombie/fx_powerup_stun_bear_fear_doa";
	level._effect["cow_explode"] = "zombie/fx_blood_cow_explo_doa";
	level._effect["cow_sacred"] = "light/fx_light_doa_pickup_glow_gold";
	level._effect["cow_hoof"] = "zombie/fx_trail_gem_yellow_doa";
	level._effect["meatball_trail"] = "zombie/fx_trail_gem_red_doa";
	level._effect["incoming_impact"] = "zombie/fx_incoming_impact_doa";
	level._effect["meatball_impact"] = "zombie/fx_impact_meatball_doa";
	level._effect["sparkle_silver"] = "zombie/fx_glow_white_doa";
	level._effect["sparkle_gold"] = "zombie/fx_glow_yellow_doa";
	level._effect["headshot"] = "zombie/fx_bul_flesh_head_fatal_zmb";
	level._effect["headshot_nochunks"] = "zombie/fx_bul_flesh_head_nochunks_zmb";
	level._effect["bloodspurt"] = "zombie/fx_bul_flesh_neck_spurt_zmb";
	level._effect["silverback_intro"] = "zombie/fx_silverback_intro_doa";
	level._effect["silverback_intro_explo"] = "zombie/fx_dog_explosion_zmb";
	level._effect["silverback_intro_trail1"] = "zombie/fx_dog_fire_trail_zmb";
	level._effect["silverback_intro_trail2"] = "zombie/fx_dog_ash_trail_zmb";
	level._effect["silverback_banana_explo"] = "zombie/fx_exp_noxious_gas";
	level._effect["explo_warning_light"] = "light/fx_ability_light_chest_immolation";
	level._effect["explo_warning_light_banana"] = "light/fx_ability_light_chest_immolation";
	level._effect["shadow_fade"] = "player/fx_ai_raven_dissolve_torso";
	level._effect["shadow_move"] = "player/fx_ai_raven_teleport";
	level._effect["shadow_appear"] = "player/fx_ai_raven_teleport_in";
	level._effect["shadow_die"] = "player/fx_ai_raven_juke_out";
	level._effect["shadow_rez_in"] = "player/fx_ai_dni_rez_in";
	level._effect["shadow_rez_out"] = "player/fx_ai_dni_rez_out_clean";
	level._effect["shadow_emerge"] = "zombie/fx_raven_teleport_doa";
	level._effect["shadow_glow"] = "zombie/fx_glow_smokeman_doa";
	level._effect["cyber_eye"] = "zombie/fx_glow_eye_silver_back_doa";
	level._effect["reviveAdvertise"] = "zombie/fx_glow_white_doa";
	level._effect["reviveActive"] = "zombie/fx_glow_yellow_doa";
	level._effect["reviveCredit"] = "zombie/fx_powerup_stun_bear_shield_impact_doa";
	level._effect["electrical_surge"] = "electric/fx_ability_elec_surge_short_robot";
	level._effect["blue_eyes"] = "zombie/fx_glow_eye_blue";
	function_6dcb1bbc("boots", 1);
	function_6dcb1bbc("magnet_on", 2);
	function_6dcb1bbc("magnet_fade", 2);
	function_6dcb1bbc("stunbear", 4, "fakelink");
	function_6dcb1bbc("stunbear_fade", 5, "fakelink");
	function_6dcb1bbc("glow_red", 6);
	function_6dcb1bbc("glow_green", 7);
	function_6dcb1bbc("glow_blue", 8);
	function_6dcb1bbc("glow_yellow", 9);
	function_6dcb1bbc("glow_white", 10);
	function_6dcb1bbc("glow_item", 11);
	function_6dcb1bbc("fast_feet", 64);
	function_6dcb1bbc("timeshift", 12);
	function_6dcb1bbc("timeshift_fade", 12);
	function_6dcb1bbc("tesla_launch", 14);
	function_6dcb1bbc("tesla_trail", 15);
	function_6dcb1bbc("tesla_shock", 16, "j_spine4");
	function_6dcb1bbc("tesla_shock_eyes", 17, "j_head");
	function_6dcb1bbc("hazard_electric", 18, "j_head");
	function_6dcb1bbc("player_respawn_green", 19, "none");
	function_6dcb1bbc("player_respawn_blue", 70, "none");
	function_6dcb1bbc("player_respawn_red", 71, "none");
	function_6dcb1bbc("player_respawn_yellow", 72, "none");
	function_6dcb1bbc("hazard_water", 20, "j_head");
	function_6dcb1bbc("stoneboss_shield_death", 27, "j_head");
	function_6dcb1bbc("stoneboss_shield_explode", 28);
	function_6dcb1bbc("stoneboss_death", 21);
	function_6dcb1bbc("stoneboss_dmg1", 22);
	function_6dcb1bbc("stoneboss_dmg2", 23);
	function_6dcb1bbc("stoneboss_dmg3", 24);
	function_6dcb1bbc("stoneboss_dmg4", 25);
	function_6dcb1bbc("stoneboss_dmg5", 26);
	function_6dcb1bbc("fate_impact", 29);
	function_6dcb1bbc("fate_trigger", 30);
	function_6dcb1bbc("fate_explode", 31);
	function_6dcb1bbc("fate_launch", 32);
	function_6dcb1bbc("fate2_awarded", 33);
	function_6dcb1bbc("def_explode", 34);
	function_6dcb1bbc("fire_trail", 35);
	function_6dcb1bbc("veh_takeoff", 36);
	function_6dcb1bbc("egg_hatch", 37, "none");
	function_6dcb1bbc("egg_explode", 38, "none");
	function_6dcb1bbc("monkey_explode", 39, "none");
	function_6dcb1bbc("boss_takeoff", 40, "none");
	function_6dcb1bbc("sprinkler_land", 41);
	function_6dcb1bbc("sprinkler_takeoff", 42);
	function_6dcb1bbc("sprinkler_active", 43);
	function_6dcb1bbc("red_shield", 44);
	function_6dcb1bbc("timeshift_contact", 45);
	function_6dcb1bbc("stunbear_contact", 46, "j_hip_le");
	function_6dcb1bbc("fury_patch", 63);
	function_6dcb1bbc("fury_boost", 62);
	function_6dcb1bbc("tesla_ball", 47);
	function_6dcb1bbc("chicken_explode", 48, "none");
	function_6dcb1bbc("gem_trail_red", 49);
	function_6dcb1bbc("gem_trail_white", 50);
	function_6dcb1bbc("gem_trail_blue", 51);
	function_6dcb1bbc("gem_trail_green", 52);
	function_6dcb1bbc("gem_trail_yellow", 53);
	function_6dcb1bbc("trail_fast", 54);
	function_6dcb1bbc("margwa_intro", 55);
	function_6dcb1bbc("margwa_head_explode", 56);
	function_6dcb1bbc("player_trail_green", 58);
	function_6dcb1bbc("player_trail_blue", 59);
	function_6dcb1bbc("player_trail_red", 60);
	function_6dcb1bbc("player_trail_yellow", 61);
	function_6dcb1bbc("slow_feet", 57);
	function_6dcb1bbc("turret_impact", 65, "none");
	function_6dcb1bbc("crater_dust", 66, "none");
	function_6dcb1bbc("blow_hole", 67);
	function_6dcb1bbc("teleporter", 68);
	function_6dcb1bbc("egg_hatchXL", 69, "none");
	function_6dcb1bbc("boxing_pow", 73, "tag_eye");
	function_6dcb1bbc("boxing_stars", 74, "tag_eye");
	function_6dcb1bbc("player_flashlight", 75, "tag_flash");
	function_6dcb1bbc("meatball_trail", 76);
	function_6dcb1bbc("stunbear_affected", 77, "tag_origin");
	function_6dcb1bbc("cow_explode", 78, "none");
	function_6dcb1bbc("cow_sacred", 79, "special");
	function_6dcb1bbc("ammo_infinite", 80, "tag_origin");
	function_6dcb1bbc("player_shield_short", 81, "tag_origin");
	function_6dcb1bbc("player_shield_long", 82, "tag_origin");
	function_6dcb1bbc("incoming_impact", 83, "tag_origin");
	function_6dcb1bbc("sparkle_silver", 84, "tag_origin");
	function_6dcb1bbc("sparkle_gold", 85, "tag_origin");
	function_6dcb1bbc("player_trail_green_night", 86);
	function_6dcb1bbc("player_trail_blue_night", 87);
	function_6dcb1bbc("player_trail_red_night", 88);
	function_6dcb1bbc("player_trail_yellow_night", 89);
	function_6dcb1bbc("headshot", 90, "j_head");
	function_6dcb1bbc("headshot_nochunks", 91, "j_head");
	function_6dcb1bbc("bloodspurt", 92, "j_neck");
	function_6dcb1bbc("silverback_intro", 93, "tag_origin", 0);
	function_6dcb1bbc("silverback_intro_explo", 94, "tag_origin", 0);
	function_6dcb1bbc("silverback_intro_trail1", 95);
	function_6dcb1bbc("silverback_intro_trail2", 96);
	function_6dcb1bbc("silverback_banana_explo", 97, "none");
	function_6dcb1bbc("explo_warning_light_banana", 98);
	function_6dcb1bbc("explo_warning_light", 99, "tag_fx");
	function_6dcb1bbc("shadow_fade", 100);
	function_6dcb1bbc("shadow_move", 101);
	function_6dcb1bbc("shadow_appear", 102, "special");
	function_6dcb1bbc("shadow_die", 103, "special");
	function_6dcb1bbc("shadow_glow", 104);
	function_6dcb1bbc("meatball_impact", 105);
	function_6dcb1bbc("bomb", 106);
	function_6dcb1bbc("cyber_eye", 107, "tag_eye");
	function_6dcb1bbc("spawnZombie", 108);
	function_6dcb1bbc("reviveAdvertise", 109, "j_head");
	function_6dcb1bbc("reviveActive", 110, "j_head");
	function_6dcb1bbc("reviveCredit", 111);
	function_6dcb1bbc("down_marker_green", 112);
	function_6dcb1bbc("down_marker_blue", 113);
	function_6dcb1bbc("down_marker_red", 114);
	function_6dcb1bbc("down_marker_yellow", 115);
	function_6dcb1bbc("electrical_surge", 116, "j_spineupper");
	function_6dcb1bbc("blue_eyes", 117, "j_eyeball_le");
	function_6dcb1bbc("zombie_angry", 118);
	function_6dcb1bbc("teamShift", 120);
	function_6dcb1bbc("teamShift_contact", 119);
	function_6dcb1bbc("web_contact", 121, "fakelink");
	if(!isdefined(level.var_de2ea8e7))
	{
		level.var_de2ea8e7 = array(level._effect["fire_limb_left"], level._effect["fire_limb_right"], level._effect["fire_torso"], level._effect["fire_limb_left"], level._effect["fire_limb_right"]);
		level.var_8118b8c = array(level._effect["fire_limb_left_red"], level._effect["fire_limb_right_red"], level._effect["fire_torso_red"], level._effect["fire_limb_left_red"], level._effect["fire_limb_right_red"]);
		level.var_56ca9a5 = array(level._effect["fire_limb_left_purple"], level._effect["fire_limb_right_purple"], level._effect["fire_torso_purple"], level._effect["fire_limb_left_purple"], level._effect["fire_limb_right_purple"]);
		level.var_c3cfd178 = array("j_elbow_le", "j_elbow_ri", "j_spine4", "j_knee_le", "j_knee_ri");
	}
}

/*
	Name: function_6dcb1bbc
	Namespace: namespace_eaa992c
	Checksum: 0xFB591FBE
	Offset: 0x4018
	Size: 0xFE
	Parameters: 4
	Flags: Linked
*/
function function_6dcb1bbc(name, type, tag = "tag_origin", unique = 1)
{
	/#
		assert(type < 128, "");
	#/
	if(!isdefined(level.var_1142e0a2))
	{
		level.var_1142e0a2 = [];
	}
	fx = spawnstruct();
	fx.name = name;
	fx.tag = tag;
	fx.unique = unique;
	level.var_1142e0a2[type] = fx;
}

/*
	Name: function_9e6fe7c3
	Namespace: namespace_eaa992c
	Checksum: 0xA2328501
	Offset: 0x4120
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function function_9e6fe7c3(type)
{
	/#
		assert(isdefined(level.var_1142e0a2[type]), "");
	#/
	return level.var_1142e0a2[type].name;
}

/*
	Name: function_28a90644
	Namespace: namespace_eaa992c
	Checksum: 0x5278AF6A
	Offset: 0x4180
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function function_28a90644(type)
{
	/#
		assert(isdefined(level.var_1142e0a2[type]), "");
	#/
	return level.var_1142e0a2[type].tag;
}

/*
	Name: function_7664cc94
	Namespace: namespace_eaa992c
	Checksum: 0x68B41003
	Offset: 0x41E0
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function function_7664cc94(type)
{
	/#
		assert(isdefined(level.var_1142e0a2[type]), "");
	#/
	return level.var_1142e0a2[type].unique;
}

/*
	Name: function_e68e3c0d
	Namespace: namespace_eaa992c
	Checksum: 0x7DBBB921
	Offset: 0x4240
	Size: 0x512
	Parameters: 5
	Flags: Linked
*/
function function_e68e3c0d(localclientnum, name, off, tag, kill = 0)
{
	self endon(#"entityshutdown");
	while(!clienthassnapshot(localclientnum))
	{
		wait(0.016);
	}
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self.var_ec1cda64))
	{
		self.var_ec1cda64 = [];
	}
	if(!isdefined(self.var_ca61d2d6))
	{
		self.var_ca61d2d6 = [];
	}
	/#
		assert(!(self isplayer() && name == ""));
	#/
	/#
		assert(!(self isplayer() && name == ""));
	#/
	if(self isplayer())
	{
		/#
			loc_000043C8:
			loc_000043FC:
			namespace_693feb87::debugmsg("" + (isdefined(self.name) ? self.name : "") + "" + name + "" + (isdefined(tag) ? tag : "") + "" + (off ? "" : "") + "" + localclientnum);
		#/
	}
	if(off)
	{
		if(isdefined(self.var_ec1cda64[name]))
		{
			stopfx(localclientnum, self.var_ec1cda64[name]);
			self.var_ec1cda64[name] = undefined;
		}
		if(isdefined(self.var_ca61d2d6[name]))
		{
			self.var_ca61d2d6[name] delete();
			self.var_ca61d2d6[name] = undefined;
		}
	}
	else if(tag == "special")
	{
		self function_b71a778a(localclientnum, name, off);
	}
	else if(tag == "fakelink")
	{
		org = spawn(localclientnum, self.origin, "script_model");
		org setmodel("tag_origin");
		org.fx = playfxontag(localclientnum, level._effect[name], org, "tag_origin");
		if(isdefined(self.var_ec1cda64[name]))
		{
			stopfx(localclientnum, self.var_ec1cda64[name]);
		}
		if(isdefined(self.var_ca61d2d6[name]))
		{
			self.var_ca61d2d6[name] delete();
		}
		self.var_ec1cda64[name] = org.fx;
		self.var_ca61d2d6[name] = org;
		org thread function_1c0d0290(self);
	}
	else if(tag == "none")
	{
		self.var_ec1cda64[name] = playfx(localclientnum, level._effect[name], self.origin);
	}
	else if(isdefined(tag) && tag != "tag_origin")
	{
		tagorigin = self gettagorigin(tag);
		if(!isdefined(tagorigin))
		{
			tag = "tag_origin";
		}
	}
	modelent = (isdefined(self.fakemodel) ? self.fakemodel : self);
	self.var_ec1cda64[name] = playfxontag(localclientnum, level._effect[name], modelent, tag);
	return self.var_ec1cda64[name];
}

/*
	Name: function_b71a778a
	Namespace: namespace_eaa992c
	Checksum: 0x232371C0
	Offset: 0x4760
	Size: 0x406
	Parameters: 4
	Flags: Linked
*/
function function_b71a778a(localclientnum, name, off, tag)
{
	self endon(#"entityshutdown");
	if(!isdefined(self.var_6f5948cb))
	{
		self.var_6f5948cb = [];
	}
	if(off)
	{
		if(isdefined(self.var_6f5948cb[name]))
		{
			foreach(var_cf8e42be, fx in self.var_6f5948cb[name])
			{
				stopfx(localclientnum, self.var_ec1cda64[name]);
			}
		}
	}
	else
	{
		switch(name)
		{
			case "cow_sacred":
			{
				self.var_6f5948cb[name] = [];
				self.var_6f5948cb[name][self.var_6f5948cb[name].size] = playfxontag(localclientnum, level._effect["cow_sacred"], self, "j_belly");
				self.var_6f5948cb[name][self.var_6f5948cb[name].size] = playfxontag(localclientnum, level._effect["cow_hoof"], self, "j_ankle_le");
				self.var_6f5948cb[name][self.var_6f5948cb[name].size] = playfxontag(localclientnum, level._effect["cow_hoof"], self, "j_ankle_ri");
				self.var_6f5948cb[name][self.var_6f5948cb[name].size] = playfxontag(localclientnum, level._effect["cow_hoof"], self, "j_wrist_le");
				self.var_6f5948cb[name][self.var_6f5948cb[name].size] = playfxontag(localclientnum, level._effect["cow_hoof"], self, "j_wrist_ri");
				break;
			}
			case "shadow_appear":
			{
				playfx(localclientnum, level._effect["shadow_appear"], self.origin);
				playfx(localclientnum, level._effect["shadow_rez_in"], self.origin);
				playfx(localclientnum, level._effect["shadow_emerge"], self.origin);
				break;
			}
			case "shadow_die":
			{
				playfx(localclientnum, level._effect["shadow_fade"], self.origin);
				playfx(localclientnum, level._effect["heart_explode"], self.origin);
				playfx(localclientnum, level._effect["shadow_rez_out"], self.origin);
				break;
			}
		}
	}
}

/*
	Name: createzombieeyesinternal
	Namespace: namespace_eaa992c
	Checksum: 0x36E45C0E
	Offset: 0x4B70
	Size: 0x13A
	Parameters: 1
	Flags: Linked
*/
function createzombieeyesinternal(localclientnum)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self._eyearray))
	{
		self._eyearray = [];
	}
	fxname = "eye_glow";
	if(level.doa.var_d94564a5 == "night")
	{
		fxname = "eye_glow_night";
	}
	if(!isdefined(self._eyearray[localclientnum]))
	{
		linktag = "j_eyeball_le";
		effect = level._effect[fxname];
		if(isdefined(level._override_eye_fx))
		{
			effect = level._override_eye_fx;
		}
		if(isdefined(self._eyeglow_fx_override))
		{
			effect = self._eyeglow_fx_override;
		}
		if(isdefined(self._eyeglow_tag_override))
		{
			linktag = self._eyeglow_tag_override;
		}
		self._eyearray[localclientnum] = playfxontag(localclientnum, effect, self, linktag);
	}
}

/*
	Name: function_1c0d0290
	Namespace: namespace_eaa992c
	Checksum: 0x617D5854
	Offset: 0x4CB8
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_1c0d0290(parent)
{
	self endon(#"entityshutdown");
	while(isdefined(parent))
	{
		self.origin = parent.origin;
		wait(0.016);
	}
	self delete();
}

/*
	Name: createzombieeyes
	Namespace: namespace_eaa992c
	Checksum: 0x1FD2B71
	Offset: 0x4D20
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function createzombieeyes(localclientnum)
{
	self thread createzombieeyesinternal(localclientnum);
}

/*
	Name: deletezombieeyes
	Namespace: namespace_eaa992c
	Checksum: 0x4D094679
	Offset: 0x4D50
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function deletezombieeyes(localclientnum)
{
	if(isdefined(self._eyearray))
	{
		if(isdefined(self._eyearray[localclientnum]))
		{
			deletefx(localclientnum, self._eyearray[localclientnum], 1);
			self._eyearray[localclientnum] = undefined;
		}
	}
}

/*
	Name: get_eyeball_on_luminance
	Namespace: namespace_eaa992c
	Checksum: 0x3C898CFE
	Offset: 0x4DB8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function get_eyeball_on_luminance()
{
	if(isdefined(level.eyeball_on_luminance_override))
	{
		return level.eyeball_on_luminance_override;
	}
	return 1;
}

/*
	Name: get_eyeball_off_luminance
	Namespace: namespace_eaa992c
	Checksum: 0x30B165C8
	Offset: 0x4DE0
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function get_eyeball_off_luminance()
{
	if(isdefined(level.eyeball_off_luminance_override))
	{
		return level.eyeball_off_luminance_override;
	}
	return 0;
}

/*
	Name: get_eyeball_color
	Namespace: namespace_eaa992c
	Checksum: 0x2ECDCA3F
	Offset: 0x4E08
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function get_eyeball_color()
{
	val = 0;
	if(isdefined(level.zombie_eyeball_color_override))
	{
		val = level.zombie_eyeball_color_override;
	}
	if(isdefined(self.zombie_eyeball_color_override))
	{
		val = self.zombie_eyeball_color_override;
	}
	return val;
}

/*
	Name: zombie_eyes_clientfield_cb
	Namespace: namespace_eaa992c
	Checksum: 0x1F942C9C
	Offset: 0x4E58
	Size: 0x154
	Parameters: 7
	Flags: Linked
*/
function zombie_eyes_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	if(newval)
	{
		self createzombieeyes(localclientnum);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, get_eyeball_on_luminance(), self get_eyeball_color());
	}
	else
	{
		self deletezombieeyes(localclientnum);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color());
	}
	if(isdefined(level.zombie_eyes_clientfield_cb_additional))
	{
		self [[level.zombie_eyes_clientfield_cb_additional]](localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
	}
}

/*
	Name: function_7829d7af
	Namespace: namespace_eaa992c
	Checksum: 0x44C18180
	Offset: 0x4FB8
	Size: 0xD6
	Parameters: 2
	Flags: Linked
*/
function function_7829d7af(localclientnum, mask = randomint(1 << level.var_de2ea8e7.size))
{
	idx = 0;
	while(mask > 0)
	{
		if(mask & 1)
		{
			playfxontag(localclientnum, (isdefined(self.var_a1063df8) ? self.var_a1063df8[idx] : level.var_de2ea8e7[idx]), self, level.var_c3cfd178[idx]);
		}
		mask = mask >> 1;
		idx++;
	}
}

/*
	Name: function_7aac5112
	Namespace: namespace_eaa992c
	Checksum: 0x55C75EDB
	Offset: 0x5098
	Size: 0xE2
	Parameters: 7
	Flags: Linked
*/
function function_7aac5112(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!self hasdobj(localclientnum))
	{
		return;
	}
	self.var_7aac5112 = newval;
	switch(self.var_7aac5112)
	{
		case 0:
		{
			self.var_a1063df8 = undefined;
			break;
		}
		case 1:
		{
			self.var_a1063df8 = level.var_de2ea8e7;
			break;
		}
		case 2:
		{
			self.var_a1063df8 = level.var_8118b8c;
			break;
		}
		case 3:
		{
			self.var_a1063df8 = level.var_56ca9a5;
			break;
		}
	}
}

/*
	Name: function_f6008bb4
	Namespace: namespace_eaa992c
	Checksum: 0x7466241E
	Offset: 0x5188
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function function_f6008bb4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!self hasdobj(localclientnum))
	{
		return;
	}
	if(!isdefined(self.var_c5998995))
	{
		self.var_c5998995 = 0;
	}
	if(gettime() < self.var_c5998995)
	{
		return;
	}
	self.var_c5998995 = gettime() + getdvarint("scr_doa_burn_interval", 1500);
	self function_7829d7af(localclientnum, (newval == 666 ? 1 << level.var_de2ea8e7.size - 1 : undefined));
}

/*
	Name: burncorpse
	Namespace: namespace_eaa992c
	Checksum: 0x5F843D8A
	Offset: 0x5280
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function burncorpse(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_f6008bb4(localclientnum, oldval, 666, bnewent, binitialsnap, fieldname, bwastimejump);
}

