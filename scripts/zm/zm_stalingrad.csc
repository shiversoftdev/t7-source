// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\raz;
#using scripts\shared\beam_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicles\_sentinel_drone;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_raz;
#using scripts\zm\_zm_ai_sentinel_drone;
#using scripts\zm\_zm_elemental_zombies;
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
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_dragon_gauntlet;
#using scripts\zm\_zm_weap_dragon_scale_shield;
#using scripts\zm\_zm_weap_dragon_strike;
#using scripts\zm\_zm_weap_raygun_mark3;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craft_shield;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_siegebot_nikolai;
#using scripts\zm\zm_stalingrad_amb;
#using scripts\zm\zm_stalingrad_ambient;
#using scripts\zm\zm_stalingrad_audio;
#using scripts\zm\zm_stalingrad_challenges;
#using scripts\zm\zm_stalingrad_craftables;
#using scripts\zm\zm_stalingrad_dragon;
#using scripts\zm\zm_stalingrad_dragon_strike;
#using scripts\zm\zm_stalingrad_ee_main;
#using scripts\zm\zm_stalingrad_eye_beam_trap;
#using scripts\zm\zm_stalingrad_ffotd;
#using scripts\zm\zm_stalingrad_fx;
#using scripts\zm\zm_stalingrad_mounted_mg;
#using scripts\zm\zm_stalingrad_pap_quest;
#using scripts\zm\zm_stalingrad_timer;
#using scripts\zm\zm_stalingrad_wearables;

#namespace zm_stalingrad;

/*
	Name: opt_in
	Namespace: zm_stalingrad
	Checksum: 0x6F6F64C6
	Offset: 0x1B98
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
	Name: init_gamemodes
	Namespace: zm_stalingrad
	Checksum: 0x99EC1590
	Offset: 0x1BC0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init_gamemodes()
{
}

/*
	Name: main
	Namespace: zm_stalingrad
	Checksum: 0x31D930
	Offset: 0x1BD0
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function main()
{
	scene::add_scene_func("p7_fxanim_gp_tracer_fire_01_bundle", &function_1c53c4e1);
	zm_stalingrad_ffotd::main_start();
	level.debug_keyline_zombies = 0;
	level.setupcustomcharacterexerts = &setup_personality_character_exerts;
	level._effect["eye_glow"] = "dlc3/stalingrad/fx_glow_eye_red_stal";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "weapon/bullet/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._uses_sticky_grenades = 1;
	level._uses_taser_knuckles = 1;
	dragon::init_clientfields();
	register_clientfields();
	zm_stalingrad_craftables::include_craftables();
	zm_stalingrad_craftables::init_craftables();
	zm_stalingrad_wearables::function_ad78a144();
	include_weapons();
	load::main();
	zm_stalingrad_fx::init();
	init_gamemodes();
	level thread function_3a429aee();
	thread zm_stalingrad_amb::main();
	util::waitforclient(0);
	zm_stalingrad_ffotd::main_end();
	level thread function_38b57afd();
}

/*
	Name: function_1c53c4e1
	Namespace: zm_stalingrad
	Checksum: 0x6DF4BF3E
	Offset: 0x1DF0
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function function_1c53c4e1(a_ents)
{
	level endon(#"zesn");
	while(true)
	{
		while(!isdefined(level.localplayers[0]) || !isigcactive(level.localplayers[0].localclientnum))
		{
			wait(1);
		}
		self scene::stop(1);
		while(isigcactive(level.localplayers[0].localclientnum))
		{
			wait(1);
		}
		self scene::play();
	}
}

/*
	Name: register_clientfields
	Namespace: zm_stalingrad
	Checksum: 0x8B40FD1F
	Offset: 0x1EC0
	Size: 0x6A4
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("clientuimodel", "zmInventory.widget_shield_parts", 12000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_dragon_strike", 12000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_crafted_shield", 12000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_cylinder", 12000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.piece_cylinder", 12000, 2, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_egg", 12000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.piece_egg", 12000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.progress_egg", 12000, 4, "float", undefined, 0, 0);
	clientfield::register("actor", "drop_pod_score_beam_fx", 12000, 1, "counter", &zm_stalingrad_pap::function_c86c0cdd, 0, 0);
	clientfield::register("scriptmover", "drop_pod_active", 12000, 1, "int", &zm_stalingrad_pap::function_5858bdaf, 0, 0);
	clientfield::register("scriptmover", "drop_pod_hp_light", 12000, 2, "int", &zm_stalingrad_pap::function_5e369bd2, 0, 0);
	clientfield::register("world", "drop_pod_streaming", 12000, 1, "int", &zm_stalingrad_pap::drop_pod_streaming, 0, 0);
	clientfield::register("toplayer", "tp_water_sheeting", 12000, 1, "int", &water_sheeting_toggle, 0, 0);
	clientfield::register("toplayer", "sewer_landing_rumble", 12000, 1, "counter", &function_931fa0e1, 0, 0);
	clientfield::register("scriptmover", "dragon_egg_heat_fx", 12000, 1, "int", &function_3931d3fe, 0, 0);
	clientfield::register("scriptmover", "dragon_egg_placed", 12000, 1, "counter", &function_4b1f1b87, 0, 0);
	clientfield::register("actor", "dragon_egg_score_beam_fx", 12000, 1, "counter", &function_bfdc67e3, 0, 0);
	clientfield::register("world", "force_stream_dragon_egg", 12000, 1, "int", &function_b116183d, 0, 0);
	clientfield::register("scriptmover", "ethereal_audio_log_fx", 12000, 1, "int", &function_a96968f2, 0, 0);
	clientfield::register("world", "deactivate_ai_vox", 12000, 1, "int", &deactivate_ai_vox, 0, 0);
	clientfield::register("world", "sophia_intro_outro", 12000, 1, "int", &function_21deab84, 0, 0);
	clientfield::register("allplayers", "sophia_follow", 12000, 3, "int", &function_a431bec5, 0, 0);
	clientfield::register("scriptmover", "sophia_eye_shader", 12000, 1, "int", &function_70b3b237, 0, 0);
	clientfield::register("world", "sophia_main_waveform", 12000, 1, "int", &function_6cfcd54d, 0, 0);
	clientfield::register("toplayer", "interact_rumble", 12000, 1, "counter", &function_bbbdcfd5, 0, 0);
	level.var_6ca4d0f2 = [];
	level.var_48c1095e = [];
}

/*
	Name: include_weapons
	Namespace: zm_stalingrad
	Checksum: 0xBE52B7C9
	Offset: 0x2570
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_stalingrad_weapons.csv", 1);
	zm_weapons::autofill_wallbuys_init();
}

/*
	Name: setup_personality_character_exerts
	Namespace: zm_stalingrad
	Checksum: 0x5C4870ED
	Offset: 0x25B0
	Size: 0x1072
	Parameters: 0
	Flags: Linked
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["playerbreathinsound"][0] = "vox_plr_0_exert_inhale_0";
	level.exert_sounds[2]["playerbreathinsound"][0] = "vox_plr_1_exert_inhale_0";
	level.exert_sounds[3]["playerbreathinsound"][0] = "vox_plr_2_exert_inhale_0";
	level.exert_sounds[4]["playerbreathinsound"][0] = "vox_plr_3_exert_inhale_0";
	level.exert_sounds[1]["playerbreathoutsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[2]["playerbreathoutsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[3]["playerbreathoutsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[4]["playerbreathoutsound"][0] = "vox_plr_3_exert_exhale_0";
	level.exert_sounds[1]["playerbreathgaspsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[2]["playerbreathgaspsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[3]["playerbreathgaspsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[4]["playerbreathgaspsound"][0] = "vox_plr_3_exert_exhale_0";
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
	level.exert_sounds[2]["mantlesoundplayer"][6] = "vox_plr_1_exert_grunt_6";
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
	level.exert_sounds[4]["mantlesoundplayer"][3] = "vox_plr_3_exert_grunt_3";
	level.exert_sounds[4]["mantlesoundplayer"][4] = "vox_plr_3_exert_grunt_4";
	level.exert_sounds[4]["mantlesoundplayer"][5] = "vox_plr_3_exert_grunt_5";
	level.exert_sounds[4]["mantlesoundplayer"][6] = "vox_plr_3_exert_grunt_6";
	level.exert_sounds[1]["meleeswipesoundplayer"][0] = "vox_plr_0_exert_knife_swipe_0";
	level.exert_sounds[1]["meleeswipesoundplayer"][1] = "vox_plr_0_exert_knife_swipe_1";
	level.exert_sounds[1]["meleeswipesoundplayer"][2] = "vox_plr_0_exert_knife_swipe_2";
	level.exert_sounds[1]["meleeswipesoundplayer"][3] = "vox_plr_0_exert_knife_swipe_3";
	level.exert_sounds[1]["meleeswipesoundplayer"][4] = "vox_plr_0_exert_knife_swipe_4";
	level.exert_sounds[2]["meleeswipesoundplayer"][0] = "vox_plr_1_exert_knife_swipe_0";
	level.exert_sounds[2]["meleeswipesoundplayer"][1] = "vox_plr_1_exert_knife_swipe_1";
	level.exert_sounds[2]["meleeswipesoundplayer"][2] = "vox_plr_1_exert_knife_swipe_2";
	level.exert_sounds[2]["meleeswipesoundplayer"][3] = "vox_plr_1_exert_knife_swipe_3";
	level.exert_sounds[2]["meleeswipesoundplayer"][4] = "vox_plr_1_exert_knife_swipe_4";
	level.exert_sounds[3]["meleeswipesoundplayer"][0] = "vox_plr_2_exert_knife_swipe_0";
	level.exert_sounds[3]["meleeswipesoundplayer"][1] = "vox_plr_2_exert_knife_swipe_1";
	level.exert_sounds[3]["meleeswipesoundplayer"][2] = "vox_plr_2_exert_knife_swipe_2";
	level.exert_sounds[3]["meleeswipesoundplayer"][3] = "vox_plr_2_exert_knife_swipe_3";
	level.exert_sounds[3]["meleeswipesoundplayer"][4] = "vox_plr_2_exert_knife_swipe_4";
	level.exert_sounds[4]["meleeswipesoundplayer"][0] = "vox_plr_3_exert_knife_swipe_0";
	level.exert_sounds[4]["meleeswipesoundplayer"][1] = "vox_plr_3_exert_knife_swipe_1";
	level.exert_sounds[4]["meleeswipesoundplayer"][2] = "vox_plr_3_exert_knife_swipe_2";
	level.exert_sounds[4]["meleeswipesoundplayer"][3] = "vox_plr_3_exert_knife_swipe_3";
	level.exert_sounds[4]["meleeswipesoundplayer"][4] = "vox_plr_3_exert_knife_swipe_4";
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
	Name: function_3a429aee
	Namespace: zm_stalingrad
	Checksum: 0x1D7AAB7E
	Offset: 0x3630
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function function_3a429aee()
{
	forcestreamxmodel("p7_zm_vending_jugg");
	forcestreamxmodel("p7_zm_vending_revive");
	forcestreamxmodel("p7_zm_vending_three_gun");
	forcestreamxmodel("p7_zm_sta_dragon_network_console");
	forcestreamxmodel("p7_zm_power_up_max_ammo");
	forcestreamxmodel("p7_zm_power_up_carpenter");
	forcestreamxmodel("p7_zm_power_up_double_points");
	forcestreamxmodel("p7_zm_power_up_firesale");
	forcestreamxmodel("p7_zm_power_up_insta_kill");
	forcestreamxmodel("p7_zm_power_up_nuke");
	forcestreamxmodel("zombie_pickup_minigun");
	forcestreamxmodel("zombie_pickup_perk_bottle");
	forcestreamxmodel("zombie_z_money_icon");
	forcestreamxmodel("p7_zm_power_up_widows_wine");
	forcestreamxmodel("p7_zm_sta_code_cylinder");
	forcestreamxmodel("p7_zm_sta_code_cylinder_red");
	forcestreamxmodel("p7_zm_sta_code_cylinder_yellow");
}

/*
	Name: function_38b57afd
	Namespace: zm_stalingrad
	Checksum: 0x1F8F77C
	Offset: 0x37D8
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_38b57afd()
{
	var_beffc54 = struct::get_array("ambient_fxanim", "targetname");
	if(getdvarint("splitscreen_playerCount") >= 2)
	{
		foreach(s_fxanim in var_beffc54)
		{
			struct::delete();
		}
		var_1bbd14fd = findstaticmodelindexarray("ambient_siege_anim");
		foreach(n_model_index in var_1bbd14fd)
		{
			hidestaticmodel(n_model_index);
		}
	}
	else
	{
		level thread scene::play("ambient_fxanim", "targetname");
	}
}

/*
	Name: water_sheeting_toggle
	Namespace: zm_stalingrad
	Checksum: 0x9400E8C7
	Offset: 0x3988
	Size: 0x1B2
	Parameters: 7
	Flags: Linked
*/
function water_sheeting_toggle(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		startwatersheetingfx(localclientnum, 1);
		playsound(localclientnum, "zmb_stalingrad_sewer_water_travel_start");
		self.var_5962d89c = self playloopsound("zmb_stalingrad_sewer_water_travel_lp", 0.3);
		var_11eaf469 = getentarray(0, "sewer_ride_end", "targetname");
		foreach(var_b81de649 in var_11eaf469)
		{
			self thread function_da4ab728(localclientnum, var_b81de649);
		}
	}
	else
	{
		stopwatersheetingfx(localclientnum, 0);
		self stoploopsound(self.var_5962d89c);
		self notify(#"hash_e7cca3ce");
	}
}

/*
	Name: function_da4ab728
	Namespace: zm_stalingrad
	Checksum: 0x92E8458C
	Offset: 0x3B48
	Size: 0xDA
	Parameters: 2
	Flags: Linked
*/
function function_da4ab728(localclientnum, var_b81de649)
{
	self endon(#"hash_e7cca3ce");
	while(true)
	{
		var_b81de649 waittill(#"trigger", who);
		if(who islocalplayer())
		{
			playsound(localclientnum, "zmb_stalingrad_sewer_pipe_exit");
			self stoploopsound(self.var_5962d89c);
			wait(0.1);
			self.var_5962d89c = self playloopsound("zmb_stalingrad_sewer_air_lp", 0.3);
			return;
		}
	}
}

/*
	Name: function_931fa0e1
	Namespace: zm_stalingrad
	Checksum: 0xAE0AD506
	Offset: 0x3C30
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_931fa0e1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self playrumbleonentity(localclientnum, "zm_stalingrad_sewer_landing");
	}
}

/*
	Name: function_4b1f1b87
	Namespace: zm_stalingrad
	Checksum: 0xD9E1B74
	Offset: 0x3CA0
	Size: 0x4E
	Parameters: 7
	Flags: Linked
*/
function function_4b1f1b87(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level.var_48c1095e[localclientnum] = self;
}

/*
	Name: function_bfdc67e3
	Namespace: zm_stalingrad
	Checksum: 0x2622D9D1
	Offset: 0x3CF8
	Size: 0x114
	Parameters: 7
	Flags: Linked
*/
function function_bfdc67e3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	e_egg = level.var_48c1095e[localclientnum];
	mdl_target = util::spawn_model(localclientnum, "tag_origin", e_egg.origin + vectorscale((0, 0, 1), 50));
	var_e43465f2 = util::spawn_model(localclientnum, "tag_origin", self gettagorigin("j_spine4"), self gettagangles("j_spine4"));
	var_e43465f2 thread function_10e7e603(mdl_target);
}

/*
	Name: function_10e7e603
	Namespace: zm_stalingrad
	Checksum: 0x98980533
	Offset: 0x3E18
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function function_10e7e603(mdl_target)
{
	level beam::launch(self, "tag_origin", mdl_target, "tag_origin", "electric_arc_zombie_to_drop_pod");
	mdl_target playsound(0, "zmb_pod_electrocute");
	wait(0.2);
	self playsound(0, "zmb_pod_electrocute_zmb");
	level beam::kill(self, "tag_origin", mdl_target, "tag_origin", "electric_arc_zombie_to_drop_pod");
	mdl_target delete();
	self delete();
}

/*
	Name: function_3931d3fe
	Namespace: zm_stalingrad
	Checksum: 0x60A02A77
	Offset: 0x3F08
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function function_3931d3fe(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.n_fx_id = playfxontag(localclientnum, level._effect["dragon_egg_heat"], self, "tag_origin");
	}
	else if(isdefined(self.n_fx_id))
	{
		stopfx(localclientnum, self.n_fx_id);
	}
}

/*
	Name: function_b116183d
	Namespace: zm_stalingrad
	Checksum: 0x11B68F70
	Offset: 0x3FC8
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_b116183d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		forcestreamxmodel("p7_fxanim_zm_stal_dragon_incubator_egg_mod");
	}
	else
	{
		stopforcestreamingxmodel("p7_fxanim_zm_stal_dragon_incubator_egg_mod");
	}
}

/*
	Name: function_a96968f2
	Namespace: zm_stalingrad
	Checksum: 0x93761C2F
	Offset: 0x4050
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function function_a96968f2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.n_fx_id = playfxontag(localclientnum, level._effect["audio_log"], self, "tag_origin");
	}
	else if(isdefined(self.n_fx_id))
	{
		stopfx(localclientnum, self.n_fx_id);
	}
}

/*
	Name: function_21deab84
	Namespace: zm_stalingrad
	Checksum: 0x2B52DF5C
	Offset: 0x4110
	Size: 0x144
	Parameters: 7
	Flags: Linked
*/
function function_21deab84(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_1c7b6837 = getent(localclientnum, "sophia_eye", "targetname");
	if(!isdefined(var_1c7b6837))
	{
		return;
	}
	if(newval)
	{
		var_1c7b6837 rotateto((0, 0, 0), 2, 0.5, 0.5);
		var_1c7b6837 mapshaderconstant(localclientnum, 0, "scriptVector2", newval, 0, 0);
	}
	else
	{
		level notify(#"hash_deeb3634");
		wait(0.5);
		var_1c7b6837 rotateto((0, 0, 0), 0.2);
		level waittill(#"outro_done");
		var_1c7b6837 delete();
	}
}

/*
	Name: function_a431bec5
	Namespace: zm_stalingrad
	Checksum: 0xADDE615E
	Offset: 0x4260
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function function_a431bec5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level endon(#"demo_jump");
	var_1c7b6837 = getent(localclientnum, "sophia_eye", "targetname");
	if(!isdefined(var_1c7b6837))
	{
		return;
	}
	level notify(#"hash_deeb3634");
	wait(0.5);
	if(!isdefined(var_1c7b6837))
	{
		return;
	}
	if(newval == 0)
	{
		var_1c7b6837 rotateto((0, 0, 0), 0.5);
	}
	else
	{
		level.var_9a736d20 = 1;
		var_1c7b6837 thread function_36666e11(self);
	}
}

/*
	Name: function_36666e11
	Namespace: zm_stalingrad
	Checksum: 0x82463136
	Offset: 0x4368
	Size: 0x1D8
	Parameters: 1
	Flags: Linked
*/
function function_36666e11(e_player)
{
	level endon(#"demo_jump");
	level endon(#"hash_deeb3634");
	e_player endon(#"death");
	self endon(#"entityshutdown");
	while(isdefined(e_player))
	{
		var_c746e6bf = e_player gettagorigin("j_head");
		var_933e0d32 = vectortoangles(self.origin - var_c746e6bf);
		if(var_933e0d32[0] > 200)
		{
			var_f59577b7 = math::clamp(var_933e0d32[0], 333, 360);
			var_933e0d32 = (var_f59577b7, var_933e0d32[1], var_933e0d32[2]);
		}
		if(var_933e0d32[1] > 200)
		{
			var_cf92fd4e = math::clamp(var_933e0d32[1], 333, 360);
			var_933e0d32 = (var_933e0d32[0], var_cf92fd4e, var_933e0d32[2]);
		}
		else
		{
			var_cf92fd4e = math::clamp(var_933e0d32[1], 0, 27);
			var_933e0d32 = (var_933e0d32[0], var_cf92fd4e, var_933e0d32[2]);
		}
		self rotateto(var_933e0d32, 0.1);
		wait(0.1);
	}
}

/*
	Name: function_70b3b237
	Namespace: zm_stalingrad
	Checksum: 0xA17D2129
	Offset: 0x4548
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_70b3b237(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self mapshaderconstant(localclientnum, 0, "scriptVector2", newval, 0, 0);
}

/*
	Name: function_6cfcd54d
	Namespace: zm_stalingrad
	Checksum: 0xE13581C6
	Offset: 0x45B8
	Size: 0x10C
	Parameters: 7
	Flags: Linked
*/
function function_6cfcd54d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_1c7b6837 = getent(localclientnum, "sophia_eye", "targetname");
	if(!isdefined(var_1c7b6837))
	{
		return;
	}
	if(newval)
	{
		var_1c7b6837 hidepart(localclientnum, "flatline_jnt");
		var_1c7b6837 showpart(localclientnum, "wave_jnt");
	}
	else
	{
		var_1c7b6837 showpart(localclientnum, "flatline_jnt");
		var_1c7b6837 hidepart(localclientnum, "wave_jnt");
	}
}

/*
	Name: function_bbbdcfd5
	Namespace: zm_stalingrad
	Checksum: 0xD54E9199
	Offset: 0x46D0
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_bbbdcfd5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self playrumbleonentity(localclientnum, "zm_stalingrad_interact_rumble");
	}
}

/*
	Name: deactivate_ai_vox
	Namespace: zm_stalingrad
	Checksum: 0xEFB38616
	Offset: 0x4740
	Size: 0x72
	Parameters: 7
	Flags: Linked
*/
function deactivate_ai_vox(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 0:
		{
			level.voxaideactivate = 0;
		}
		case 1:
		{
			level.voxaideactivate = 1;
		}
	}
}

