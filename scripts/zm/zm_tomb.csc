// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\mechz;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_callbacks;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\_zm_ai_mechz_claw;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_electric_cherry;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_random;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_powerup_zombie_blood;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_beacon;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_one_inch_punch;
#using scripts\zm\_zm_weap_staff_air;
#using scripts\zm\_zm_weap_staff_fire;
#using scripts\zm\_zm_weap_staff_lightning;
#using scripts\zm\_zm_weap_staff_water;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craft_shield;
#using scripts\zm\zm_challenges_tomb;
#using scripts\zm\zm_tomb_amb;
#using scripts\zm\zm_tomb_ambient_scripts;
#using scripts\zm\zm_tomb_capture_zones;
#using scripts\zm\zm_tomb_chamber;
#using scripts\zm\zm_tomb_craftables;
#using scripts\zm\zm_tomb_dig;
#using scripts\zm\zm_tomb_ee;
#using scripts\zm\zm_tomb_ffotd;
#using scripts\zm\zm_tomb_fx;
#using scripts\zm\zm_tomb_giant_robot;
#using scripts\zm\zm_tomb_magicbox;
#using scripts\zm\zm_tomb_mech;
#using scripts\zm\zm_tomb_quest_fire;
#using scripts\zm\zm_tomb_tank;
#using scripts\zm\zm_tomb_teleporter;

#namespace zm_tomb;

/*
	Name: opt_in
	Namespace: zm_tomb
	Checksum: 0x170EB750
	Offset: 0x1E90
	Size: 0x1C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec opt_in()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
}

/*
	Name: main
	Namespace: zm_tomb
	Checksum: 0xB99A7C37
	Offset: 0x1EB8
	Size: 0xB34
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread zm_tomb_ffotd::main_start();
	clientfield::register("scriptmover", "glow_biplane_trail_fx", 21000, 1, "int", &glow_biplane_trail_fx, 0, 0);
	clientfield::register("scriptmover", "element_glow_fx", 21000, 4, "int", &crystal_fx, 0, 0);
	clientfield::register("scriptmover", "bryce_cake", 21000, 2, "int", &function_f6e2b5fc, 0, 0);
	clientfield::register("scriptmover", "switch_spark", 21000, 1, "int", &function_81f3b018, 0, 0);
	clientfield::register("scriptmover", "plane_fx", 21000, 1, "int", &function_ae268bd3, 0, 0);
	clientfield::register("world", "cooldown_steam", 21000, 2, "int", &function_61fd4b0c, 0, 0);
	clientfield::register("scriptmover", "teleporter_fx", 21000, 1, "int", &zm_tomb_teleporter::function_a8255fab, 0, 0);
	n_bits = getminbitcountfornum(6);
	clientfield::register("toplayer", "player_rumble_and_shake", 21000, n_bits, "int", &player_rumble_and_shake, 0, 0);
	clientfield::register("scriptmover", "stone_frozen", 21000, 1, "int", &function_eb515bc3, 0, 0);
	n_bits = getminbitcountfornum(5);
	clientfield::register("world", "rain_level", 21000, n_bits, "int", &function_c62fcc7d, 0, 0);
	clientfield::register("world", "snow_level", 21000, n_bits, "int", &function_fbc162aa, 0, 0);
	clientfield::register("toplayer", "player_weather_visionset", 21000, 2, "int", &function_2feb8fa1, 0, 0);
	clientfield::register("scriptmover", "sky_pillar", 21000, 1, "int", &function_90b75360, 0, 0);
	clientfield::register("scriptmover", "staff_charger", 21000, 3, "int", &function_cef99197, 0, 0);
	clientfield::register("toplayer", "player_staff_charge", 21000, 2, "int", &function_35da9753, 0, 0);
	clientfield::register("toplayer", "player_tablet_state", 21000, 2, "int", &zm_utility::setinventoryuimodels, 0, 1);
	n_bits = getminbitcountfornum(4);
	clientfield::register("actor", "zombie_soul", 21000, n_bits, "int", &function_1ee903c, 0, 0);
	clientfield::register("zbarrier", "magicbox_runes", 21000, 1, "int", &function_1c88eb29, 0, 0);
	clientfield::register("actor", "foot_print_box_fx", 21000, 1, "int", &foot_print_box_fx, 0, 0);
	clientfield::register("scriptmover", "foot_print_box_glow", 21000, 1, "int", &foot_print_box_glow, 0, 0);
	clientfield::register("world", "crypt_open_exploder", 21000, 1, "int", &function_d20e4b5a, 0, 0);
	clientfield::register("world", "lantern_fx", 21000, 1, "int", &function_24a5862d, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_shield_parts", 21000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_crafted_shield", 21000, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "sndMudSlow", 21000, 1, "int", &zm_tomb_amb::sndmudslow, 0, 0);
	clientfield::register("world", "mus_zmb_egg_snapshot_loop", 21000, 1, "int", &zm_tomb_amb::function_ec990408, 1, 0);
	clientfield::register("toplayer", "sndMaelstrom", 21000, 1, "int", &zm_tomb_amb::sndmaelstrom, 0, 0);
	clientfield::register("actor", "crusader_emissive_fx", 21000, 1, "int", &crusader_emissive_fx, 0, 0);
	clientfield::register("actor", "zombie_instant_explode", 21000, 1, "int", &function_b3ff5e6d, 0, 1);
	level.default_start_location = "tomb";
	level.default_game_mode = "zclassic";
	level._no_water_risers = 1;
	level.var_7d2be23b = 3;
	level.zombie_eyes_clientfield_cb_additional = &function_e20b060c;
	level._uses_sticky_grenades = 1;
	level.disable_fx_zmb_wall_buy_semtex = 1;
	level._uses_taser_knuckles = 0;
	level._wallbuy_override_num_bits = 1;
	level.setupcustomcharacterexerts = &setup_personality_character_exerts;
	level._no_equipment_activated_clientfield = 1;
	level._no_navcards = 1;
	level.weather_rain = 0;
	level.weather_snow = 0;
	level.weather_fog = 0;
	_zm_weap_one_inch_punch::init();
	zm_tomb_quest_fire::main();
	zm_tomb_tank::init();
	zm_tomb_giant_robot::init();
	start_zombie_stuff();
	zm_tomb_dig::init();
	zm_tomb_mech::init();
	zm_tomb_fx::main();
	zm_tomb_ee::init();
	zm_tomb_teleporter::init();
	level thread zm_tomb_ambient_scripts::main();
	level._entityspawned_override = &function_b1ef089b;
	zm_tomb_craftables::include_craftables();
	zm_tomb_craftables::init_craftables();
	zm_tomb_capture_zones::init_structs();
	level thread zm_tomb_amb::main();
	load::main();
	level.n_level_sunlight = getdvarfloat("r_lightTweakSunLight");
	util::waitforclient(0);
	level thread zm_tomb_fx::setup_prop_anims();
	level thread function_6ac83719();
	level thread zm_tomb_capture_zones::function_902e1a6d();
	level.sndnomeleeonclient = 1;
	setdvar("bg_chargeShotExponentialAmmoPerChargeLevel", 1);
	level thread zm_tomb_ffotd::main_end();
}

/*
	Name: start_zombie_stuff
	Namespace: zm_tomb
	Checksum: 0xF9074194
	Offset: 0x29F8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function start_zombie_stuff()
{
	level.raygun2_included = 1;
	include_weapons();
	include_equipment_for_level();
	_zm_weap_beacon::init();
	_zm_weap_cymbal_monkey::init();
	zm_tomb_teleporter::main();
	visionset_mgr::register_overlay_info_style_burn("zm_transit_burn", 21000, 15, 2);
}

/*
	Name: include_equipment_for_level
	Namespace: zm_tomb
	Checksum: 0xAB5988AE
	Offset: 0x2A90
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function include_equipment_for_level()
{
	zm_equipment::include("equip_dieseldrone");
	zm_equipment::include("tomb_shield");
}

/*
	Name: setup_personality_character_exerts
	Namespace: zm_tomb
	Checksum: 0x810B159D
	Offset: 0x2AD0
	Size: 0x1482
	Parameters: 0
	Flags: Linked
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["playerbreathinsound"][0] = "vox_plr_0_exert_inhale_0";
	level.exert_sounds[1]["playerbreathinsound"][1] = "vox_plr_0_exert_inhale_1";
	level.exert_sounds[1]["playerbreathinsound"][2] = "vox_plr_0_exert_inhale_2";
	level.exert_sounds[2]["playerbreathinsound"][0] = "vox_plr_1_exert_inhale_0";
	level.exert_sounds[2]["playerbreathinsound"][1] = "vox_plr_1_exert_inhale_1";
	level.exert_sounds[2]["playerbreathinsound"][2] = "vox_plr_1_exert_inhale_2";
	level.exert_sounds[3]["playerbreathinsound"][0] = "vox_plr_2_exert_inhale_0";
	level.exert_sounds[3]["playerbreathinsound"][1] = "vox_plr_2_exert_inhale_1";
	level.exert_sounds[3]["playerbreathinsound"][2] = "vox_plr_2_exert_inhale_2";
	level.exert_sounds[4]["playerbreathinsound"][0] = "vox_plr_3_exert_inhale_0";
	level.exert_sounds[4]["playerbreathinsound"][1] = "vox_plr_3_exert_inhale_1";
	level.exert_sounds[4]["playerbreathinsound"][2] = "vox_plr_3_exert_inhale_2";
	level.exert_sounds[1]["playerbreathoutsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[1]["playerbreathoutsound"][1] = "vox_plr_0_exert_exhale_1";
	level.exert_sounds[1]["playerbreathoutsound"][2] = "vox_plr_0_exert_exhale_2";
	level.exert_sounds[2]["playerbreathoutsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[2]["playerbreathoutsound"][1] = "vox_plr_1_exert_exhale_1";
	level.exert_sounds[2]["playerbreathoutsound"][2] = "vox_plr_1_exert_exhale_2";
	level.exert_sounds[3]["playerbreathoutsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[3]["playerbreathoutsound"][1] = "vox_plr_2_exert_exhale_1";
	level.exert_sounds[3]["playerbreathoutsound"][2] = "vox_plr_2_exert_exhale_2";
	level.exert_sounds[4]["playerbreathoutsound"][0] = "vox_plr_3_exert_exhale_0";
	level.exert_sounds[4]["playerbreathoutsound"][1] = "vox_plr_3_exert_exhale_1";
	level.exert_sounds[4]["playerbreathoutsound"][2] = "vox_plr_3_exert_exhale_2";
	level.exert_sounds[1]["playerbreathgaspsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[1]["playerbreathgaspsound"][1] = "vox_plr_0_exert_exhale_1";
	level.exert_sounds[1]["playerbreathgaspsound"][2] = "vox_plr_0_exert_exhale_2";
	level.exert_sounds[2]["playerbreathgaspsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[2]["playerbreathgaspsound"][1] = "vox_plr_1_exert_exhale_1";
	level.exert_sounds[2]["playerbreathgaspsound"][2] = "vox_plr_1_exert_exhale_2";
	level.exert_sounds[3]["playerbreathgaspsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[3]["playerbreathgaspsound"][1] = "vox_plr_2_exert_exhale_1";
	level.exert_sounds[3]["playerbreathgaspsound"][2] = "vox_plr_2_exert_exhale_2";
	level.exert_sounds[4]["playerbreathgaspsound"][0] = "vox_plr_3_exert_exhale_0";
	level.exert_sounds[4]["playerbreathgaspsound"][1] = "vox_plr_3_exert_exhale_1";
	level.exert_sounds[4]["playerbreathgaspsound"][2] = "vox_plr_3_exert_exhale_2";
	level.exert_sounds[1]["falldamage"][0] = "vox_plr_0_exert_pain_low_0";
	level.exert_sounds[1]["falldamage"][1] = "vox_plr_0_exert_pain_low_1";
	level.exert_sounds[1]["falldamage"][2] = "vox_plr_0_exert_pain_low_2";
	level.exert_sounds[1]["falldamage"][3] = "vox_plr_0_exert_pain_low_3";
	level.exert_sounds[1]["falldamage"][4] = "vox_plr_0_exert_pain_low_4";
	level.exert_sounds[1]["falldamage"][5] = "vox_plr_0_exert_pain_low_5";
	level.exert_sounds[1]["falldamage"][6] = "vox_plr_0_exert_pain_low_6";
	level.exert_sounds[1]["falldamage"][7] = "vox_plr_0_exert_pain_low_7";
	level.exert_sounds[2]["falldamage"][0] = "vox_plr_1_exert_pain_low_0";
	level.exert_sounds[2]["falldamage"][1] = "vox_plr_1_exert_pain_low_1";
	level.exert_sounds[2]["falldamage"][2] = "vox_plr_1_exert_pain_low_2";
	level.exert_sounds[2]["falldamage"][3] = "vox_plr_1_exert_pain_low_3";
	level.exert_sounds[2]["falldamage"][4] = "vox_plr_1_exert_pain_low_4";
	level.exert_sounds[2]["falldamage"][5] = "vox_plr_1_exert_pain_low_5";
	level.exert_sounds[2]["falldamage"][6] = "vox_plr_1_exert_pain_low_6";
	level.exert_sounds[2]["falldamage"][7] = "vox_plr_1_exert_pain_low_7";
	level.exert_sounds[3]["falldamage"][0] = "vox_plr_2_exert_pain_low_0";
	level.exert_sounds[3]["falldamage"][1] = "vox_plr_2_exert_pain_low_1";
	level.exert_sounds[3]["falldamage"][2] = "vox_plr_2_exert_pain_low_2";
	level.exert_sounds[3]["falldamage"][3] = "vox_plr_2_exert_pain_low_3";
	level.exert_sounds[3]["falldamage"][4] = "vox_plr_2_exert_pain_low_4";
	level.exert_sounds[3]["falldamage"][5] = "vox_plr_2_exert_pain_low_5";
	level.exert_sounds[3]["falldamage"][6] = "vox_plr_2_exert_pain_low_6";
	level.exert_sounds[3]["falldamage"][7] = "vox_plr_2_exert_pain_low_7";
	level.exert_sounds[4]["falldamage"][0] = "vox_plr_3_exert_pain_low_0";
	level.exert_sounds[4]["falldamage"][1] = "vox_plr_3_exert_pain_low_1";
	level.exert_sounds[4]["falldamage"][2] = "vox_plr_3_exert_pain_low_2";
	level.exert_sounds[4]["falldamage"][3] = "vox_plr_3_exert_pain_low_3";
	level.exert_sounds[4]["falldamage"][4] = "vox_plr_3_exert_pain_low_4";
	level.exert_sounds[4]["falldamage"][5] = "vox_plr_3_exert_pain_low_5";
	level.exert_sounds[4]["falldamage"][6] = "vox_plr_3_exert_pain_low_6";
	level.exert_sounds[4]["falldamage"][7] = "vox_plr_3_exert_pain_low_7";
	level.exert_sounds[1]["mantlesoundplayer"][0] = "vox_plr_0_exert_grunt_0";
	level.exert_sounds[1]["mantlesoundplayer"][1] = "vox_plr_0_exert_grunt_1";
	level.exert_sounds[1]["mantlesoundplayer"][2] = "vox_plr_0_exert_grunt_2";
	level.exert_sounds[1]["mantlesoundplayer"][3] = "vox_plr_0_exert_grunt_3";
	level.exert_sounds[1]["mantlesoundplayer"][4] = "vox_plr_0_exert_grunt_4";
	level.exert_sounds[1]["mantlesoundplayer"][5] = "vox_plr_0_exert_grunt_5";
	level.exert_sounds[1]["mantlesoundplayer"][6] = "vox_plr_0_exert_grunt_6";
	level.exert_sounds[2]["mantlesoundplayer"][0] = "vox_plr_1_exert_grunt_0";
	level.exert_sounds[2]["mantlesoundplayer"][1] = "vox_plr_1_exert_grunt_1";
	level.exert_sounds[2]["mantlesoundplayer"][2] = "vox_plr_1_exert_grunt_2";
	level.exert_sounds[2]["mantlesoundplayer"][3] = "vox_plr_1_exert_grunt_3";
	level.exert_sounds[2]["mantlesoundplayer"][4] = "vox_plr_1_exert_grunt_4";
	level.exert_sounds[2]["mantlesoundplayer"][5] = "vox_plr_1_exert_grunt_5";
	level.exert_sounds[3]["mantlesoundplayer"][0] = "vox_plr_2_exert_grunt_0";
	level.exert_sounds[3]["mantlesoundplayer"][1] = "vox_plr_2_exert_grunt_1";
	level.exert_sounds[3]["mantlesoundplayer"][2] = "vox_plr_2_exert_grunt_2";
	level.exert_sounds[3]["mantlesoundplayer"][3] = "vox_plr_2_exert_grunt_3";
	level.exert_sounds[3]["mantlesoundplayer"][4] = "vox_plr_2_exert_grunt_4";
	level.exert_sounds[3]["mantlesoundplayer"][5] = "vox_plr_2_exert_grunt_5";
	level.exert_sounds[3]["mantlesoundplayer"][6] = "vox_plr_2_exert_grunt_6";
	level.exert_sounds[4]["mantlesoundplayer"][0] = "vox_plr_3_exert_grunt_0";
	level.exert_sounds[4]["mantlesoundplayer"][1] = "vox_plr_3_exert_grunt_1";
	level.exert_sounds[4]["mantlesoundplayer"][2] = "vox_plr_3_exert_grunt_2";
	level.exert_sounds[4]["mantlesoundplayer"][3] = "vox_plr_3_exert_grunt_4";
	level.exert_sounds[4]["mantlesoundplayer"][4] = "vox_plr_3_exert_grunt_5";
	level.exert_sounds[4]["mantlesoundplayer"][5] = "vox_plr_3_exert_grunt_6";
	level.exert_sounds[1]["meleeswipesoundplayer"][0] = "vox_plr_0_exert_knife_swipe_0";
	level.exert_sounds[1]["meleeswipesoundplayer"][1] = "vox_plr_0_exert_knife_swipe_1";
	level.exert_sounds[1]["meleeswipesoundplayer"][2] = "vox_plr_0_exert_knife_swipe_2";
	level.exert_sounds[1]["meleeswipesoundplayer"][3] = "vox_plr_0_exert_knife_swipe_3";
	level.exert_sounds[1]["meleeswipesoundplayer"][4] = "vox_plr_0_exert_knife_swipe_4";
	level.exert_sounds[1]["meleeswipesoundplayer"][5] = "vox_plr_0_exert_knife_swipe_5";
	level.exert_sounds[2]["meleeswipesoundplayer"][0] = "vox_plr_1_exert_knife_swipe_0";
	level.exert_sounds[2]["meleeswipesoundplayer"][1] = "vox_plr_1_exert_knife_swipe_1";
	level.exert_sounds[2]["meleeswipesoundplayer"][2] = "vox_plr_1_exert_knife_swipe_2";
	level.exert_sounds[2]["meleeswipesoundplayer"][3] = "vox_plr_1_exert_knife_swipe_3";
	level.exert_sounds[2]["meleeswipesoundplayer"][4] = "vox_plr_1_exert_knife_swipe_4";
	level.exert_sounds[2]["meleeswipesoundplayer"][5] = "vox_plr_1_exert_knife_swipe_5";
	level.exert_sounds[3]["meleeswipesoundplayer"][0] = "vox_plr_2_exert_knife_swipe_0";
	level.exert_sounds[3]["meleeswipesoundplayer"][1] = "vox_plr_2_exert_knife_swipe_1";
	level.exert_sounds[3]["meleeswipesoundplayer"][2] = "vox_plr_2_exert_knife_swipe_2";
	level.exert_sounds[3]["meleeswipesoundplayer"][3] = "vox_plr_2_exert_knife_swipe_3";
	level.exert_sounds[3]["meleeswipesoundplayer"][4] = "vox_plr_2_exert_knife_swipe_4";
	level.exert_sounds[3]["meleeswipesoundplayer"][5] = "vox_plr_2_exert_knife_swipe_5";
	level.exert_sounds[4]["meleeswipesoundplayer"][0] = "vox_plr_3_exert_knife_swipe_0";
	level.exert_sounds[4]["meleeswipesoundplayer"][1] = "vox_plr_3_exert_knife_swipe_1";
	level.exert_sounds[4]["meleeswipesoundplayer"][2] = "vox_plr_3_exert_knife_swipe_2";
	level.exert_sounds[4]["meleeswipesoundplayer"][3] = "vox_plr_3_exert_knife_swipe_3";
	level.exert_sounds[4]["meleeswipesoundplayer"][4] = "vox_plr_3_exert_knife_swipe_4";
	level.exert_sounds[4]["meleeswipesoundplayer"][5] = "vox_plr_3_exert_knife_swipe_5";
	level.exert_sounds[1]["dtplandsoundplayer"][0] = "vox_plr_0_exert_pain_medium_0";
	level.exert_sounds[1]["dtplandsoundplayer"][1] = "vox_plr_0_exert_pain_medium_1";
	level.exert_sounds[1]["dtplandsoundplayer"][2] = "vox_plr_0_exert_pain_medium_2";
	level.exert_sounds[1]["dtplandsoundplayer"][3] = "vox_plr_0_exert_pain_medium_3";
	level.exert_sounds[2]["dtplandsoundplayer"][0] = "vox_plr_1_exert_pain_medium_0";
	level.exert_sounds[2]["dtplandsoundplayer"][1] = "vox_plr_1_exert_pain_medium_1";
	level.exert_sounds[2]["dtplandsoundplayer"][2] = "vox_plr_1_exert_pain_medium_2";
	level.exert_sounds[2]["dtplandsoundplayer"][3] = "vox_plr_1_exert_pain_medium_3";
	level.exert_sounds[3]["dtplandsoundplayer"][0] = "vox_plr_2_exert_pain_medium_0";
	level.exert_sounds[3]["dtplandsoundplayer"][1] = "vox_plr_2_exert_pain_medium_1";
	level.exert_sounds[3]["dtplandsoundplayer"][2] = "vox_plr_2_exert_pain_medium_2";
	level.exert_sounds[3]["dtplandsoundplayer"][3] = "vox_plr_2_exert_pain_medium_3";
	level.exert_sounds[4]["dtplandsoundplayer"][0] = "vox_plr_3_exert_pain_medium_0";
	level.exert_sounds[4]["dtplandsoundplayer"][1] = "vox_plr_3_exert_pain_medium_1";
	level.exert_sounds[4]["dtplandsoundplayer"][2] = "vox_plr_3_exert_pain_medium_2";
	level.exert_sounds[4]["dtplandsoundplayer"][3] = "vox_plr_3_exert_pain_medium_3";
}

/*
	Name: function_6ac83719
	Namespace: zm_tomb
	Checksum: 0x954C4FFD
	Offset: 0x3F60
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_6ac83719()
{
	visionset_mgr::init_fog_vol_to_visionset_monitor("zm_tomb", 1);
	visionset_mgr::fog_vol_to_visionset_set_suffix("");
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zm_tomb");
	level thread visionset_mgr::fog_vol_to_visionset_monitor();
}

/*
	Name: init_clientflag_variables
	Namespace: zm_tomb
	Checksum: 0x99EC1590
	Offset: 0x3FE0
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function init_clientflag_variables()
{
}

/*
	Name: register_clientflag_callbacks
	Namespace: zm_tomb
	Checksum: 0x99EC1590
	Offset: 0x3FF0
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function register_clientflag_callbacks()
{
}

/*
	Name: include_weapons
	Namespace: zm_tomb
	Checksum: 0x8091FA0F
	Offset: 0x4000
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_tomb_weapons.csv", 1);
	zm_weapons::autofill_wallbuys_init();
}

/*
	Name: function_b1ef089b
	Namespace: zm_tomb
	Checksum: 0x61C7CBA4
	Offset: 0x4040
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function function_b1ef089b(localclientnum)
{
	if(!isdefined(self.type))
	{
		/#
			println("");
		#/
		return;
	}
	if(self.type == "player")
	{
		self thread callback::playerspawned(localclientnum);
	}
	else
	{
		if(self.type == "vehicle")
		{
			if(self.vehicletype === "heli_quadrotor_zm" || self.vehicletype === "heli_quadrotor_upgraded_zm")
			{
				self thread function_b14689f(localclientnum);
			}
		}
		else if(self.type == "actor")
		{
			if(isdefined(level._customactorcbfunc))
			{
				self thread [[level._customactorcbfunc]](localclientnum);
			}
		}
	}
}

/*
	Name: function_b14689f
	Namespace: zm_tomb
	Checksum: 0x687DB595
	Offset: 0x4140
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_b14689f(localclientnum)
{
	self util::waittill_dobj(localclientnum);
	level thread zm_tomb_amb::init();
	self thread zm_tomb_amb::start_helicopter_sounds();
}

/*
	Name: function_5efb4f48
	Namespace: zm_tomb
	Checksum: 0x92355B63
	Offset: 0x41A0
	Size: 0x88
	Parameters: 2
	Flags: Linked
*/
function function_5efb4f48(localclientnum, str_rumble)
{
	self endon(#"hash_9c289640");
	self endon(#"disconnect");
	delta_time = 0.1;
	n_max_time = 10;
	while(isdefined(self))
	{
		self playrumbleonentity(localclientnum, str_rumble);
		wait(0.1);
	}
}

/*
	Name: function_35da9753
	Namespace: zm_tomb
	Checksum: 0x4CF35DA1
	Offset: 0x4230
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function function_35da9753(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self notify(#"hash_9c289640");
	str_rumble = undefined;
	switch(newval)
	{
		case 1:
		{
			str_rumble = "reload_small";
			break;
		}
		case 2:
		{
			str_rumble = "damage_light";
			break;
		}
		case 3:
		{
			str_rumble = "damage_heavy";
			break;
		}
		default:
		{
			break;
		}
	}
	if(isdefined(str_rumble))
	{
		self thread function_5efb4f48(localclientnum, str_rumble);
	}
}

/*
	Name: function_cef99197
	Namespace: zm_tomb
	Checksum: 0x33332CC3
	Offset: 0x4328
	Size: 0x15E
	Parameters: 7
	Flags: Linked
*/
function function_cef99197(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(!isdefined(level.var_d1435401))
	{
		level.var_d1435401 = [];
	}
	if(newval != 0)
	{
		level.var_d1435401[newval] = self.origin;
	}
	else
	{
		keys = getarraykeys(level.var_d1435401);
		foreach(i in keys)
		{
			if(!isdefined(level.var_d1435401[i]))
			{
				continue;
			}
			if(distancesquared(level.var_d1435401[i], self.origin) < 100)
			{
				level.var_d1435401[i] = undefined;
			}
		}
	}
}

/*
	Name: function_1ee903c
	Namespace: zm_tomb
	Checksum: 0x654FAF55
	Offset: 0x4490
	Size: 0x28C
	Parameters: 7
	Flags: Linked
*/
function function_1ee903c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	v_origin = self gettagorigin("J_SpineUpper");
	v_dest = undefined;
	if(!isdefined(level.var_d1435401))
	{
		level.var_d1435401 = [];
	}
	if(isdefined(level.var_d1435401[newval]))
	{
		v_dest = level.var_d1435401[newval];
	}
	if(!isdefined(v_dest) || !isdefined(v_origin))
	{
		return;
	}
	if(isdefined(self))
	{
		v_origin = self gettagorigin("J_SpineUpper");
	}
	e_fx = spawn(localclientnum, v_origin, "script_model");
	e_fx setmodel("tag_origin");
	e_fx playsound(localclientnum, "zmb_squest_charge_soul_leave");
	e_fx playloopsound("zmb_squest_charge_soul_lp");
	playfxontag(localclientnum, level._effect["staff_soul"], e_fx, "tag_origin");
	e_fx moveto(v_dest + vectorscale((0, 0, 1), 5), 0.5);
	e_fx waittill(#"movedone");
	e_fx playsound(localclientnum, "zmb_squest_charge_soul_impact");
	playfxontag(localclientnum, level._effect["staff_charge"], e_fx, "tag_origin");
	util::server_wait(localclientnum, 0.3);
	e_fx delete();
}

/*
	Name: function_1c88eb29
	Namespace: zm_tomb
	Checksum: 0xE266AF9D
	Offset: 0x4728
	Size: 0x1C6
	Parameters: 7
	Flags: Linked
*/
function function_1c88eb29(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	n_pieces = self getnumzbarrierpieces();
	if(!isdefined(self.mapped_const))
	{
		for(i = 0; i < n_pieces; i++)
		{
			e_piece = self zbarriergetpiece(i);
			e_piece mapshaderconstant(localclientnum, 1, "ScriptVector0");
		}
		self.mapped_const = 1;
	}
	if(newval)
	{
		for(i = 0; i < n_pieces; i++)
		{
			e_piece = self zbarriergetpiece(i);
			e_piece setshaderconstant(localclientnum, 1, 0, 1, 0, 0);
		}
	}
	else
	{
		for(i = 0; i < n_pieces; i++)
		{
			e_piece = self zbarriergetpiece(i);
			e_piece setshaderconstant(localclientnum, 1, 0, 0, 0, 0);
		}
	}
}

/*
	Name: angle_dif
	Namespace: zm_tomb
	Checksum: 0x386A5018
	Offset: 0x48F8
	Size: 0x76
	Parameters: 2
	Flags: Linked
*/
function angle_dif(oldangle, newangle)
{
	outvalue = (oldangle - newangle) % 360;
	if(outvalue < 0)
	{
		outvalue = outvalue + 360;
	}
	if(outvalue > 180)
	{
		outvalue = (outvalue - 360) * -1;
	}
	return outvalue;
}

/*
	Name: function_d56fa005
	Namespace: zm_tomb
	Checksum: 0x3484E440
	Offset: 0x4978
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function function_d56fa005()
{
	for(i = 0; i < 5; i++)
	{
		if(!isdefined(level.var_3e984f03[i]))
		{
			continue;
		}
		n_rotation = int(level.var_3e984f03[i]);
		n_target = int(self.angles[1]);
		diff = abs(angle_dif(n_target, n_rotation));
		if(diff <= 45)
		{
			return i;
		}
	}
	return 0;
}

/*
	Name: function_657fb719
	Namespace: zm_tomb
	Checksum: 0xA3A07C8
	Offset: 0x4A70
	Size: 0x2D8
	Parameters: 2
	Flags: Linked
*/
function function_657fb719(localclientnum, light_on)
{
	if(!isdefined(level.var_3e984f03))
	{
		level.var_3e984f03 = [];
		level.var_3e984f03[2] = 270;
		level.var_3e984f03[1] = 180;
		level.var_3e984f03[3] = 90;
		level.var_3e984f03[4] = 0;
	}
	if(!isdefined(level.var_1aa82a7e))
	{
		level.var_1aa82a7e = [];
		level.var_1aa82a7e[0] = -1;
		level.var_1aa82a7e[2] = 2;
		level.var_1aa82a7e[1] = 3;
		level.var_1aa82a7e[3] = 0;
		level.var_1aa82a7e[4] = 1;
		level.var_1aa82a7e[5] = 4;
	}
	var_477f7b08 = self function_d56fa005();
	v_color = level.var_1aa82a7e[var_477f7b08];
	var_70f85c31 = 0.1;
	if(isdefined(level.var_fdb98849) && light_on)
	{
		var_904d8a16 = level clientfield::get("light_show");
		switch(var_904d8a16)
		{
			case 1:
			{
				var_477f7b08 = 0;
				break;
			}
			case 2:
			{
				var_477f7b08 = 1;
				break;
			}
			case 3:
			{
				var_477f7b08 = 5;
				break;
			}
			default:
			{
				var_477f7b08 = 0;
				break;
			}
		}
		var_70f85c31 = var_70f85c31 * 10;
	}
	else
	{
		if(isdefined(level.var_656c2f5) && !light_on)
		{
			var_477f7b08 = 0;
			var_70f85c31 = 0;
		}
		else if(light_on)
		{
			var_70f85c31 = var_70f85c31 * 10;
		}
	}
	playsound(0, "zmb_crypt_disc_light", self.origin);
	var_f9e79b00 = self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, var_70f85c31, level.var_1aa82a7e[var_477f7b08], 0);
}

/*
	Name: function_f6e2b5fc
	Namespace: zm_tomb
	Checksum: 0xFCD857D8
	Offset: 0x4D50
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_f6e2b5fc(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 2)
	{
		self thread function_657fb719(localclientnum, 1);
	}
	else
	{
		self thread function_657fb719(localclientnum, 0);
	}
}

/*
	Name: function_81f3b018
	Namespace: zm_tomb
	Checksum: 0x266ED6FE
	Offset: 0x4DE0
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function function_81f3b018(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(isdefined(self.spark_fx))
	{
		stopfx(localclientnum, self.spark_fx);
		self.spark_fx = undefined;
	}
	if(newval)
	{
		self.spark_fx = playfxontag(localclientnum, level._effect["fx_tomb_sparks"], self, "lever_jnt");
	}
}

/*
	Name: function_ae268bd3
	Namespace: zm_tomb
	Checksum: 0xD33EC512
	Offset: 0x4E98
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function function_ae268bd3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		self.var_c304583e = playfxontag(localclientnum, level._effect["biplane_glow"], self, "tag_origin");
	}
	else if(isdefined(self.var_c304583e))
	{
		stopfx(localclientnum, self.var_c304583e);
	}
}

/*
	Name: function_61fd4b0c
	Namespace: zm_tomb
	Checksum: 0xBB2912BC
	Offset: 0x4F50
	Size: 0x11C
	Parameters: 7
	Flags: Linked
*/
function function_61fd4b0c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level notify(#"stop_cooldown_fx");
	if(newval == 1)
	{
		var_4c2b197a = struct::get("cooldown_steam_1", "targetname");
	}
	else
	{
		if(newval == 2)
		{
			var_4c2b197a = struct::get("cooldown_steam_2", "targetname");
		}
		else if(newval == 3)
		{
			var_4c2b197a = struct::get("cooldown_steam_3", "targetname");
		}
	}
	if(isdefined(var_4c2b197a))
	{
		var_4c2b197a thread function_bebc67a2(localclientnum);
	}
}

/*
	Name: function_bebc67a2
	Namespace: zm_tomb
	Checksum: 0xCA755F68
	Offset: 0x5078
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function function_bebc67a2(localclientnum)
{
	level endon(#"stop_cooldown_fx");
	while(true)
	{
		playfx(localclientnum, level._effect["cooldown_steam"], self.origin);
		wait(0.1);
	}
}

/*
	Name: teleporter_fx
	Namespace: zm_tomb
	Checksum: 0x1DA026FD
	Offset: 0x50D8
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function teleporter_fx(localclientnum, enum)
{
	str_fx = "teleport_air";
	switch(enum)
	{
		case 1:
		{
			str_fx = "teleport_fire";
			break;
		}
		case 4:
		{
			str_fx = "teleport_ice";
			break;
		}
		case 3:
		{
			str_fx = "teleport_elec";
			break;
		}
		case 2:
		default:
		{
			str_fx = "teleport_air";
			break;
		}
	}
	self.var_c304583e = playfxontag(localclientnum, level._effect[str_fx], self, "tag_origin");
	setfxignorepause(localclientnum, self.var_c304583e, 1);
}

/*
	Name: glow_biplane_trail_fx
	Namespace: zm_tomb
	Checksum: 0x829B6C6B
	Offset: 0x51D8
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function glow_biplane_trail_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		playfxontag(localclientnum, level._effect["glow_biplane_trail_fx"], self, "tag_origin");
	}
}

/*
	Name: crystal_fx
	Namespace: zm_tomb
	Checksum: 0x8C3E277
	Offset: 0x5258
	Size: 0x24C
	Parameters: 7
	Flags: Linked
*/
function crystal_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval >= 5)
	{
		var_1f503d41 = newval - 4;
		teleporter_fx(localclientnum, var_1f503d41);
		return;
	}
	if(newval == 1)
	{
		self.var_c304583e = playfxontag(localclientnum, level._effect["fire_glow"], self, "tag_origin");
		setfxignorepause(localclientnum, self.var_c304583e, 1);
	}
	else
	{
		if(newval == 2)
		{
			self.var_c304583e = playfxontag(localclientnum, level._effect["air_glow"], self, "tag_origin");
			setfxignorepause(localclientnum, self.var_c304583e, 1);
		}
		else
		{
			if(newval == 3)
			{
				self.var_c304583e = playfxontag(localclientnum, level._effect["elec_glow"], self, "tag_origin");
				setfxignorepause(localclientnum, self.var_c304583e, 1);
			}
			else
			{
				if(newval == 4)
				{
					self.var_c304583e = playfxontag(localclientnum, level._effect["ice_glow"], self, "tag_origin");
					setfxignorepause(localclientnum, self.var_c304583e, 1);
				}
				else if(newval == 0)
				{
					stopfx(localclientnum, self.var_c304583e);
				}
			}
		}
	}
}

/*
	Name: function_eb515bc3
	Namespace: zm_tomb
	Checksum: 0x963CADC4
	Offset: 0x54B0
	Size: 0xF2
	Parameters: 7
	Flags: Linked
*/
function function_eb515bc3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self endon(#"entityshutdown");
	if(newval)
	{
		self mapshaderconstant(localclientnum, 0, "ScriptVector3");
		f = 0;
		while(f <= 1)
		{
			self setshaderconstant(localclientnum, 0, f, f, f, f);
			util::server_wait(localclientnum, 0.0166);
			f = f + 0.01;
		}
	}
}

/*
	Name: function_5abafae8
	Namespace: zm_tomb
	Checksum: 0x8EA6C2E
	Offset: 0x55B0
	Size: 0x1CE
	Parameters: 3
	Flags: Linked
*/
function function_5abafae8(localclientnum, fade_in, fade_time)
{
	self notify(#"hash_35d6955f");
	self endon(#"hash_35d6955f");
	self endon(#"entityshutdown");
	start_val = 0;
	end_val = 1;
	if(fade_in)
	{
		start_val = 1;
		end_val = 0;
	}
	frame_time = 0.0166;
	num_steps = int(fade_time / frame_time);
	step_size = 1 / num_steps;
	for(i = 0; i < num_steps; i++)
	{
		pct = step_size * i;
		if(pct < 0)
		{
			pct = 0;
		}
		else if(pct > 1)
		{
			pct = 1;
		}
		value = lerpfloat(start_val, end_val, pct);
		self setshaderconstant(localclientnum, 0, value, value, value, value);
		util::server_wait(localclientnum, frame_time);
	}
}

/*
	Name: function_90b75360
	Namespace: zm_tomb
	Checksum: 0x7D6FD5AE
	Offset: 0x5788
	Size: 0x1EC
	Parameters: 7
	Flags: Linked
*/
function function_90b75360(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		self mapshaderconstant(localclientnum, 0, "ScriptVector0");
		self thread function_5abafae8(localclientnum, 1, 1);
		playsound(0, "zmb_squest_crystal_sky_pillar_start", (3, 0, 218));
		audio::playloopat("zmb_squest_crystal_sky_pillar_loop", (0, -2, 435));
		audio::playloopat("zmb_squest_crystal_sky_pillar_loop_fx", vectorscale((0, 0, 1), 150));
		/#
			println("");
		#/
	}
	else
	{
		self thread function_5abafae8(localclientnum, 0, 4);
		playsound(0, "zmb_squest_crystal_sky_pillar_stop", (3, 0, 218));
		audio::stoploopat("zmb_squest_crystal_sky_pillar_loop", (0, -2, 435));
		audio::stoploopat("zmb_squest_crystal_sky_pillar_loop_fx", vectorscale((0, 0, 1), 150));
		/#
			println("");
		#/
	}
}

/*
	Name: player_rumble_and_shake
	Namespace: zm_tomb
	Checksum: 0x7230F1B6
	Offset: 0x5980
	Size: 0x206
	Parameters: 7
	Flags: Linked
*/
function player_rumble_and_shake(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self endon(#"disconnect");
	if(newval == 4)
	{
		self thread player_continuous_rumble(localclientnum, 1);
	}
	else
	{
		if(newval == 5)
		{
			self thread player_continuous_rumble(localclientnum, 2);
		}
		else
		{
			if(newval == 3)
			{
				self earthquake(0.6, 1.5, self.origin, 100);
				self playrumbleonentity(localclientnum, "artillery_rumble");
			}
			else
			{
				if(newval == 2)
				{
					self earthquake(0.3, 1.5, self.origin, 100);
					self playrumbleonentity(localclientnum, "shotgun_fire");
				}
				else
				{
					if(newval == 1)
					{
						self earthquake(0.1, 1, self.origin, 100);
						self playrumbleonentity(localclientnum, "damage_heavy");
					}
					else
					{
						if(newval == 6)
						{
							self thread player_continuous_rumble(localclientnum, 1, 0);
						}
						else
						{
							self notify(#"stop_rumble_and_shake");
						}
					}
				}
			}
		}
	}
}

/*
	Name: player_continuous_rumble
	Namespace: zm_tomb
	Checksum: 0xE7266FB
	Offset: 0x5B90
	Size: 0x160
	Parameters: 3
	Flags: Linked
*/
function player_continuous_rumble(localclientnum, rumble_level, shake_camera = 1)
{
	self notify(#"stop_rumble_and_shake");
	self endon(#"disconnect");
	self endon(#"stop_rumble_and_shake");
	while(true)
	{
		if(isdefined(self) && self islocalplayer() && isdefined(self))
		{
			if(rumble_level == 1)
			{
				if(shake_camera)
				{
					self earthquake(0.2, 1, self.origin, 100);
				}
				self playrumbleonentity(localclientnum, "reload_small");
				wait(0.05);
			}
			else
			{
				if(shake_camera)
				{
					self earthquake(0.3, 1, self.origin, 100);
				}
				self playrumbleonentity(localclientnum, "damage_light");
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_d20e4b5a
	Namespace: zm_tomb
	Checksum: 0x113B4F07
	Offset: 0x5CF8
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function function_d20e4b5a(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	exploder::exploder(222);
}

/*
	Name: function_24a5862d
	Namespace: zm_tomb
	Checksum: 0x8C2F72B8
	Offset: 0x5D58
	Size: 0x2BA
	Parameters: 7
	Flags: Linked
*/
function function_24a5862d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	var_aa8e992 = array("phys_lantern01", "phys_lantern02", "phys_lantern03", "phys_lantern04", "phys_lantern05", "phys_lantern06", "phys_lantern07", "phys_lantern08", "phys_lantern09", "phys_lantern10", "phys_lantern11", "phys_lantern12", "phys_lantern13", "phys_lantern14", "phys_lantern15", "phys_lantern16", "phys_lantern17", "phys_lantern18", "phys_lantern19");
	var_e531bd52 = [];
	foreach(str_name in var_aa8e992)
	{
		var_e531bd52 = arraycombine(var_e531bd52, getdynentarray(str_name), 0, 0);
	}
	if(newval)
	{
		foreach(lantern in var_e531bd52)
		{
			lantern function_ea74b5ce(localclientnum);
		}
	}
	else
	{
		foreach(lantern in var_e531bd52)
		{
			lantern function_b44167d(localclientnum);
		}
	}
}

/*
	Name: function_ea74b5ce
	Namespace: zm_tomb
	Checksum: 0x22D00797
	Offset: 0x6020
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function function_ea74b5ce(localclientnumber)
{
	self function_b44167d(localclientnumber);
	self.a_fx[localclientnumber] = playfxondynent(level._effect["fx_tomb_light_expensive"], self);
}

/*
	Name: function_b44167d
	Namespace: zm_tomb
	Checksum: 0x5EEB385E
	Offset: 0x6088
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_b44167d(localclientnumber)
{
	if(!isdefined(self.a_fx))
	{
		self.a_fx = [];
	}
	if(isdefined(self.a_fx[localclientnumber]))
	{
		deletefx(localclientnumber, self.a_fx[localclientnumber], 1);
	}
}

/*
	Name: function_c62fcc7d
	Namespace: zm_tomb
	Checksum: 0x98E8F10
	Offset: 0x60F0
	Size: 0x48
	Parameters: 7
	Flags: Linked
*/
function function_c62fcc7d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level.weather_rain = newval;
}

/*
	Name: function_fbc162aa
	Namespace: zm_tomb
	Checksum: 0xFE6C8A97
	Offset: 0x6140
	Size: 0x48
	Parameters: 7
	Flags: Linked
*/
function function_fbc162aa(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level.weather_snow = newval;
}

/*
	Name: function_5f9e6e69
	Namespace: zm_tomb
	Checksum: 0x89A6B808
	Offset: 0x6190
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_5f9e6e69(localclientnum)
{
	if(!isdefined(level.var_1c69bb12))
	{
		level thread zm_tomb_amb::function_33be1969();
	}
	if(level.weather_snow == 0)
	{
		level notify("_snow_thread" + localclientnum);
		level.var_1c69bb12.var_308c43c8 = 0;
	}
	else
	{
		self thread _snow_thread(level.weather_snow, localclientnum);
		level.var_1c69bb12.var_308c43c8 = 1;
	}
	level thread function_f099c69d(self);
}

/*
	Name: function_4a9e7e2
	Namespace: zm_tomb
	Checksum: 0x453E4B00
	Offset: 0x6248
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function function_4a9e7e2(localclientnum)
{
	if(!isdefined(level.var_1c69bb12))
	{
		level thread zm_tomb_amb::function_33be1969();
	}
	if(!isdefined(self.b_lightning))
	{
		self.b_lightning = 0;
	}
	if(level.weather_rain == 0)
	{
		level notify("_rain_thread" + localclientnum);
		self.b_lightning = 0;
		level.var_1c69bb12.var_b13d6dfb = 0;
	}
	else
	{
		if(isdefined(self.b_lightning) && !self.b_lightning)
		{
			self thread _lightning_thread(localclientnum);
		}
		self thread _rain_thread(level.weather_rain, localclientnum);
		level.var_1c69bb12.var_b13d6dfb = 1;
	}
	level thread function_f099c69d(self);
}

/*
	Name: function_2feb8fa1
	Namespace: zm_tomb
	Checksum: 0xC7080D4C
	Offset: 0x6358
	Size: 0x2AC
	Parameters: 7
	Flags: Linked
*/
function function_2feb8fa1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	var_750d7c17 = 10;
	if(bnewent || binitialsnap || bwasdemojump)
	{
		var_750d7c17 = 0;
	}
	if(isdefined(self))
	{
		self function_4a9e7e2(localclientnum);
		self function_5f9e6e69(localclientnum);
	}
	if(newval == 0 || newval == 3)
	{
		function_b5ac96ec("clear", localclientnum);
		setlitfogbank(localclientnum, -1, 0, -1);
		if(getdvarint("splitscreen_playerCount") > 2)
		{
			setworldfogactivebank(localclientnum, 9);
		}
		else
		{
			setworldfogactivebank(localclientnum, 1);
		}
	}
	else
	{
		if(newval == 1)
		{
			function_b5ac96ec("rain", localclientnum);
			setlitfogbank(localclientnum, -1, 2, -1);
			if(getdvarint("splitscreen_playerCount") > 2)
			{
				setworldfogactivebank(localclientnum, 12);
			}
			else
			{
				setworldfogactivebank(localclientnum, 4);
			}
		}
		else if(newval == 2)
		{
			function_b5ac96ec("snow", localclientnum);
			setlitfogbank(localclientnum, -1, 1, -1);
			if(getdvarint("splitscreen_playerCount") > 2)
			{
				setworldfogactivebank(localclientnum, 10);
			}
			else
			{
				setworldfogactivebank(localclientnum, 2);
			}
		}
	}
}

/*
	Name: function_b5ac96ec
	Namespace: zm_tomb
	Checksum: 0x44223C9A
	Offset: 0x6610
	Size: 0x10A
	Parameters: 2
	Flags: Linked
*/
function function_b5ac96ec(var_d8a51337, localclientnum)
{
	exploder::stop_exploder("fxexp_111", localclientnum);
	exploder::stop_exploder("fxexp_112", localclientnum);
	exploder::stop_exploder("fxexp_113", localclientnum);
	switch(var_d8a51337)
	{
		case "clear":
		{
			exploder::exploder("fxexp_111", localclientnum);
			break;
		}
		case "rain":
		{
			exploder::exploder("fxexp_112", localclientnum);
			break;
		}
		case "snow":
		{
			exploder::exploder("fxexp_113", localclientnum);
			break;
		}
		default:
		{
			break;
		}
	}
}

/*
	Name: function_ee40d15e
	Namespace: zm_tomb
	Checksum: 0xDA1AAEE5
	Offset: 0x6728
	Size: 0x24
	Parameters: 4
	Flags: None
*/
function function_ee40d15e(localclientnum, var_24ba9457, var_c5799b7a, n_lerp_time)
{
}

/*
	Name: function_f099c69d
	Namespace: zm_tomb
	Checksum: 0x10230E36
	Offset: 0x6758
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_f099c69d(player)
{
	level notify(#"hash_72666748");
	level endon(#"hash_72666748");
	wait(0.5);
	level notify(#"hash_f099c69d");
	player thread function_7820d164();
}

/*
	Name: function_7820d164
	Namespace: zm_tomb
	Checksum: 0x1979B466
	Offset: 0x67B8
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function function_7820d164()
{
	wait(0.1);
	name = level.activeambientpackage;
}

/*
	Name: _rain_thread
	Namespace: zm_tomb
	Checksum: 0x95B258B4
	Offset: 0x6810
	Size: 0x126
	Parameters: 2
	Flags: Linked
*/
function _rain_thread(n_level, localclientnum)
{
	level notify("_rain_thread" + localclientnum);
	level notify("_rain_begin" + localclientnum);
	level endon("_snow_begin" + localclientnum);
	level endon("_rain_thread" + localclientnum);
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	n_wait = 0.35 / n_level;
	if(n_wait < 0.15)
	{
		n_wait = 0.15;
	}
	while(true)
	{
		if(!isdefined(self))
		{
			return;
		}
		var_f0b23899 = function_508af4e9(localclientnum);
		playfx(localclientnum, level._effect["player_rain"], var_f0b23899[0], var_f0b23899[1]);
		wait(n_wait);
	}
}

/*
	Name: _snow_thread
	Namespace: zm_tomb
	Checksum: 0xF757B3B4
	Offset: 0x6940
	Size: 0x126
	Parameters: 2
	Flags: Linked
*/
function _snow_thread(n_level, localclientnum)
{
	level notify("_snow_thread" + localclientnum);
	level notify("_snow_begin" + localclientnum);
	level endon("_rain_begin" + localclientnum);
	level endon("_snow_thread" + localclientnum);
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	n_wait = 0.5 / n_level;
	self.b_lightning = 0;
	while(true)
	{
		if(!isdefined(self))
		{
			return;
		}
		if(!isdefined(level.localplayers[localclientnum]))
		{
			return;
		}
		var_f0b23899 = function_508af4e9(localclientnum);
		playfx(localclientnum, level._effect["player_snow"], var_f0b23899[0], var_f0b23899[1]);
		wait(n_wait);
	}
}

/*
	Name: _lightning_thread
	Namespace: zm_tomb
	Checksum: 0x4C387AD
	Offset: 0x6A70
	Size: 0x2F0
	Parameters: 1
	Flags: Linked
*/
function _lightning_thread(localclientnum)
{
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	self.b_lightning = 1;
	if(localclientnum != 0)
	{
		return;
	}
	level notify("_lightning_thread" + localclientnum);
	level endon("_lightning_thread" + localclientnum);
	if(isdefined(localclientnum))
	{
		self util::waittill_dobj(localclientnum);
		while(isdefined(self.b_lightning) && self.b_lightning)
		{
			v_p_angles = self.angles;
			v_forward = anglestoforward(self.angles) * 25000;
			v_end_pos = self.origin + (v_forward[0], v_forward[1], 0);
			v_offset = (randomintrange(-5000, 5000), randomintrange(-5000, 5000), randomint(3000));
			v_end_pos = v_end_pos + v_offset;
			exploder::exploder("fxexp_400");
			playsound(0, "amb_thunder_clap_zm", v_end_pos);
			util::server_wait(localclientnum, randomfloatrange(0.2, 0.3));
			self thread function_d4089806(localclientnum);
			n_strikes = randomintrange(3, 5);
			for(i = 0; i < n_strikes; i++)
			{
				util::server_wait(localclientnum, 0.1);
				n_blend_time = randomfloatrange(0.1, 0.35);
				playsound(0, "amb_thunder_flash_zm", v_end_pos);
			}
			self notify(#"hash_48ec464");
			util::server_wait(localclientnum, randomfloatrange(5, 10));
		}
	}
}

/*
	Name: function_508af4e9
	Namespace: zm_tomb
	Checksum: 0x8CE465DF
	Offset: 0x6D68
	Size: 0x120
	Parameters: 1
	Flags: Linked
*/
function function_508af4e9(localclientnum)
{
	var_bbb1872c = getlocalclienteyepos(localclientnum);
	var_4bde0ff5 = getlocalclientangles(localclientnum);
	var_4bde0ff5 = anglestoforward(var_4bde0ff5);
	var_4bde0ff5 = (var_4bde0ff5[0], var_4bde0ff5[1], 0);
	if(var_4bde0ff5[0] == 0 && var_4bde0ff5[1] == 0)
	{
		if(randomint(1) == 0)
		{
			var_4bde0ff5 = vectorscale((1, 1, 0), 0.01);
		}
		else
		{
			var_4bde0ff5 = vectorscale((-1, -1, 0), 0.01);
		}
	}
	var_f0b23899 = [];
	var_f0b23899[0] = var_bbb1872c;
	var_f0b23899[1] = var_4bde0ff5;
	return var_f0b23899;
}

/*
	Name: function_d4089806
	Namespace: zm_tomb
	Checksum: 0x58C0165B
	Offset: 0x6E90
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function function_d4089806(localclientnum)
{
	self endon(#"hash_48ec464");
	self waittill("_lightning_thread" + localclientnum);
}

/*
	Name: lerp_dvar
	Namespace: zm_tomb
	Checksum: 0xC0C90FD0
	Offset: 0x6EC8
	Size: 0x164
	Parameters: 5
	Flags: None
*/
function lerp_dvar(str_dvar, n_val, n_lerp_time, b_saved_dvar, localclientnum)
{
	n_start_val = getdvarfloat(str_dvar);
	n_time_delta = 0;
	do
	{
		util::server_wait(localclientnum, 0.05);
		n_time_delta = n_time_delta + 0.05;
		n_curr_val = lerpfloat(n_start_val, n_val, n_time_delta / n_lerp_time);
		if(isdefined(b_saved_dvar) && b_saved_dvar)
		{
			setsaveddvar(str_dvar, n_curr_val);
		}
		else
		{
			setdvar(str_dvar, n_curr_val);
		}
	}
	while(n_time_delta < n_lerp_time);
	if(isdefined(b_saved_dvar) && b_saved_dvar)
	{
		setsaveddvar(str_dvar, n_val);
	}
	else
	{
		setdvar(str_dvar, n_val);
	}
}

/*
	Name: foot_print_box_fx
	Namespace: zm_tomb
	Checksum: 0x3569F3E8
	Offset: 0x7038
	Size: 0x21C
	Parameters: 7
	Flags: Linked
*/
function foot_print_box_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	a_structs = struct::get_array("foot_box_pos", "targetname");
	s_box = arraygetclosest(self.origin, a_structs);
	e_fx = spawn(localclientnum, self gettagorigin("J_SpineUpper"), "script_model");
	e_fx setmodel("tag_origin");
	e_fx playsound(localclientnum, "zmb_squest_charge_soul_leave");
	e_fx playloopsound("zmb_squest_charge_soul_lp");
	playfxontag(localclientnum, level._effect["staff_soul"], e_fx, "tag_origin");
	e_fx moveto(s_box.origin, 1);
	e_fx waittill(#"movedone");
	playsound(localclientnum, "zmb_squest_charge_soul_impact", e_fx.origin);
	playfxontag(localclientnum, level._effect["staff_charge"], e_fx, "tag_origin");
	wait(0.3);
	e_fx delete();
}

/*
	Name: foot_print_box_glow
	Namespace: zm_tomb
	Checksum: 0xE3443A39
	Offset: 0x7260
	Size: 0x1BE
	Parameters: 7
	Flags: Linked
*/
function foot_print_box_glow(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self util::waittill_dobj(localclientnum);
	if(newval == 1)
	{
		if(!isdefined(self.fx_glow))
		{
			self.fx_glow = playfxontag(localclientnum, level._effect["foot_box_glow"], self, "tag_origin");
			self thread function_91953add(localclientnum);
		}
		if(!isdefined(self.sndent))
		{
			self.sndent = spawn(0, self.origin, "script_origin");
			self.sndent playloopsound("zmb_footprintbox_glow_lp", 1);
			self.sndent thread function_3a4d4e97();
		}
	}
	else
	{
		if(isdefined(self.fx_glow))
		{
			stopfx(localclientnum, self.fx_glow);
			self.fx_glow = undefined;
			self thread function_526683dc(localclientnum);
		}
		if(isdefined(self.sndent))
		{
			self.sndent delete();
			self.sndent = undefined;
		}
	}
}

/*
	Name: function_3a4d4e97
	Namespace: zm_tomb
	Checksum: 0x4C5C73F1
	Offset: 0x7428
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_3a4d4e97()
{
	self endon(#"entityshutdown");
	level waittill(#"demo_jump");
	self delete();
}

/*
	Name: function_91953add
	Namespace: zm_tomb
	Checksum: 0x3DCE0B30
	Offset: 0x7468
	Size: 0x10A
	Parameters: 1
	Flags: Linked
*/
function function_91953add(localclientnum)
{
	self endon(#"entityshutdown");
	self mapshaderconstant(localclientnum, 0, "ScriptVector1");
	s_timer = new_timer(localclientnum);
	n_phase_in = 1;
	do
	{
		util::server_wait(localclientnum, 0.11);
		n_current_time = s_timer get_time_in_seconds();
		n_delta_val = lerpfloat(1, 0, n_current_time / n_phase_in);
		self setshaderconstant(localclientnum, 0, n_delta_val, 0, 0, 0);
	}
	while(n_current_time < n_phase_in);
}

/*
	Name: function_526683dc
	Namespace: zm_tomb
	Checksum: 0x952B828A
	Offset: 0x7580
	Size: 0x10A
	Parameters: 1
	Flags: Linked
*/
function function_526683dc(localclientnum)
{
	self endon(#"entityshutdown");
	self mapshaderconstant(localclientnum, 0, "ScriptVector1");
	s_timer = new_timer(localclientnum);
	n_phase_in = 1;
	do
	{
		util::server_wait(localclientnum, 0.11);
		n_current_time = s_timer get_time_in_seconds();
		n_delta_val = lerpfloat(0, 1, n_current_time / n_phase_in);
		self setshaderconstant(localclientnum, 0, n_delta_val, 0, 0, 0);
	}
	while(n_current_time < n_phase_in);
}

/*
	Name: timer_increment_loop
	Namespace: zm_tomb
	Checksum: 0x1ADD694A
	Offset: 0x7698
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function timer_increment_loop(localclientnum)
{
	while(isdefined(self))
	{
		util::server_wait(localclientnum, 0.016);
		self.n_time_current = self.n_time_current + 0.016;
	}
}

/*
	Name: new_timer
	Namespace: zm_tomb
	Checksum: 0x394A2F
	Offset: 0x76F0
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function new_timer(localclientnum)
{
	s_timer = spawnstruct();
	s_timer.n_time_current = 0;
	s_timer thread timer_increment_loop(localclientnum);
	return s_timer;
}

/*
	Name: get_time
	Namespace: zm_tomb
	Checksum: 0x26F72387
	Offset: 0x7750
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function get_time()
{
	return self.n_time_current * 1000;
}

/*
	Name: get_time_in_seconds
	Namespace: zm_tomb
	Checksum: 0x93FF51EC
	Offset: 0x7768
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_time_in_seconds()
{
	return self.n_time_current;
}

/*
	Name: reset_timer
	Namespace: zm_tomb
	Checksum: 0xE3DB4217
	Offset: 0x7780
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function reset_timer()
{
	self.n_time_current = 0;
}

/*
	Name: crusader_emissive_fx
	Namespace: zm_tomb
	Checksum: 0x2DBD555D
	Offset: 0x7798
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function crusader_emissive_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 1, 1, 1, 0);
	}
	else
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 0, 0, 0);
	}
}

/*
	Name: function_b3ff5e6d
	Namespace: zm_tomb
	Checksum: 0x20D5F734
	Offset: 0x7848
	Size: 0xE4
	Parameters: 7
	Flags: Linked
*/
function function_b3ff5e6d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		where = self gettagorigin("J_SpineLower");
		if(!isdefined(where))
		{
			where = self.origin;
		}
		if(isdefined(level._effect["zombie_guts_explosion"]) && util::is_mature())
		{
			playfx(localclientnum, level._effect["zombie_guts_explosion"], where);
		}
	}
}

/*
	Name: function_e20b060c
	Namespace: zm_tomb
	Checksum: 0x5A927049
	Offset: 0x7938
	Size: 0xDC
	Parameters: 7
	Flags: Linked
*/
function function_e20b060c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		if(isdefined(self) && isdefined(self._aitype) && self._aitype == "zm_tomb_basic_crusader")
		{
			self._eyeglow_fx_override = level._effect["eye_glow_blue"];
			self zm::deletezombieeyes(localclientnum);
			self zm::createzombieeyes(localclientnum);
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, level.var_7d2be23b, 0);
		}
	}
}

