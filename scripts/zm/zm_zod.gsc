// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\margwa;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\name_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_margwa;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_ai_wasp;
#using scripts\zm\_zm_altbody;
#using scripts\zm\_zm_altbody_beast;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox_zod;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerup_bonus_points_team;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_bowie;
#using scripts\zm\_zm_weap_glaive;
#using scripts\zm\_zm_weap_idgun;
#using scripts\zm\_zm_weap_octobomb;
#using scripts\zm\_zm_weap_rocketshield;
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\archetype_zod_companion;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\craftables\_zm_craft_shield;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_zod_achievements;
#using scripts\zm\zm_zod_archetype;
#using scripts\zm\zm_zod_beastcode;
#using scripts\zm\zm_zod_cleanup_mgr;
#using scripts\zm\zm_zod_craftables;
#using scripts\zm\zm_zod_defend_areas;
#using scripts\zm\zm_zod_ee;
#using scripts\zm\zm_zod_ee_side;
#using scripts\zm\zm_zod_ffotd;
#using scripts\zm\zm_zod_fx;
#using scripts\zm\zm_zod_gamemodes;
#using scripts\zm\zm_zod_idgun_quest;
#using scripts\zm\zm_zod_maps;
#using scripts\zm\zm_zod_margwa;
#using scripts\zm\zm_zod_perks;
#using scripts\zm\zm_zod_pods;
#using scripts\zm\zm_zod_portals;
#using scripts\zm\zm_zod_poweronswitch;
#using scripts\zm\zm_zod_quest;
#using scripts\zm\zm_zod_robot;
#using scripts\zm\zm_zod_shadowman;
#using scripts\zm\zm_zod_smashables;
#using scripts\zm\zm_zod_stairs;
#using scripts\zm\zm_zod_sword_quest;
#using scripts\zm\zm_zod_train;
#using scripts\zm\zm_zod_transformer;
#using scripts\zm\zm_zod_traps;
#using scripts\zm\zm_zod_util;
#using scripts\zm\zm_zod_vo;
#using scripts\zm\zm_zod_zombie;

#using_animtree("generic");

#namespace zm_zod;

/*
	Name: opt_in
	Namespace: zm_zod
	Checksum: 0x2D9E51EB
	Offset: 0x25D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec opt_in()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
	level.randomize_perk_machine_location = 1;
	level.pack_a_punch_camo_index = 26;
}

/*
	Name: main
	Namespace: zm_zod
	Checksum: 0x9208BCA7
	Offset: 0x2618
	Size: 0xBEC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	zm_zod_ffotd::main_start();
	setclearanceceiling(34);
	setdvar("zm_wasp_open_spawning", 1);
	level.uses_tesla_powerup = 1;
	level.zod_character_names = [];
	array::add(level.zod_character_names, "boxer");
	array::add(level.zod_character_names, "detective");
	array::add(level.zod_character_names, "femme");
	array::add(level.zod_character_names, "magician");
	level flag::init("train_rode_to_canal");
	level flag::init("train_rode_to_slums");
	level flag::init("train_rode_to_theater");
	level flag::init("idgun_up_for_grabs");
	level flag::init("pod_miasma");
	register_clientfields();
	callback::on_spawned(&on_player_spawned);
	callback::on_spawned(&function_f7d81bd5);
	level._uses_sticky_grenades = 1;
	level._uses_taser_knuckles = 1;
	level._no_vending_machine_auto_collision = 1;
	level.debug_keyline_zombies = 0;
	zm::init_fx();
	zm_zod_fx::main();
	zm_ai_raps::init();
	zm_ai_wasp::init();
	level._effect["eye_glow"] = "misc/fx_zombie_eye_single";
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange_zod";
	level._effect["headshot"] = "zombie/fx_bul_flesh_head_fatal_zmb";
	level._effect["headshot_nochunks"] = "zombie/fx_bul_flesh_head_nochunks_zmb";
	level._effect["bloodspurt"] = "zombie/fx_bul_flesh_neck_spurt_zmb";
	level._effect["animscript_gib_fx"] = "zombie/fx_blood_torso_explo_zmb";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["switch_sparks"] = "electric/fx_elec_sparks_directional_orange";
	level.default_start_location = "start_room";
	level.default_game_mode = "zclassic";
	level.precachecustomcharacters = &precachecustomcharacters;
	level.givecustomcharacters = &givecustomcharacters;
	level thread setup_personality_character_exerts();
	initcharacterstartindex();
	level.register_offhand_weapons_for_level_defaults_override = &offhand_weapon_overrride;
	level.zombiemode_offhand_weapon_give_override = &offhand_weapon_give_override;
	level._zombie_custom_add_weapons = &custom_add_weapons;
	level thread custom_add_vox();
	level._allow_melee_weapon_switching = 1;
	level.zombiemode_reusing_pack_a_punch = 1;
	level.do_randomized_zigzag_path = 1;
	level.enemy_location_override_func = &enemy_location_override;
	level.no_target_override = &no_target_override;
	level.player_out_of_playable_area_override = &player_out_of_playable_area_override;
	level.zm_custom_spawn_location_selection = &function_2c092767;
	level.zm_custom_get_next_wasp_round = &function_612012aa;
	level.zm_custom_get_next_raps_round = &function_612012aa;
	level.zm_wasp_spawn_callback = &function_f88e4c70;
	level.var_9cef605e = &function_89b7689f;
	level.var_2300a8ad = &function_42cc727b;
	level.var_2d0e5eb6 = &function_2d0e5eb6;
	level.var_2c12d9a6 = &function_533186ee;
	level.check_end_solo_game_override = &check_end_solo_game_override;
	level._game_module_game_end_check = &function_63f29efd;
	level.powerup_grab_get_players_override = &powerup_grab_get_players_override;
	level.zm_override_ai_aftermath_powerup_drop = &zm_override_ai_aftermath_powerup_drop;
	level.can_revive_game_module = &function_80ba9218;
	include_weapons();
	magic_box_init();
	level.using_solo_revive = zod_use_solo_revive();
	level._custom_perks["specialty_quickrevive"].cost = &revive_cost_override;
	zm_zod_perks::init();
	zm_craftables::init();
	zm_zod_craftables::randomize_craftable_spawns();
	zm_zod_craftables::include_craftables();
	zm_zod_craftables::init_craftables();
	load::main();
	setdvar("doublejump_enabled", 1);
	setdvar("playerEnergy_enabled", 1);
	setdvar("wallrun_enabled", 1);
	level thread function_4df9f4ad();
	setdvar("ai_threatUpdateInterval", 50);
	_zm_weap_tesla::init();
	level.customrandomweaponweights = &zod_custom_weapon_weights;
	level.special_weapon_magicbox_check = &zod_special_weapon_magicbox_check;
	level._round_start_func = &zm::round_start;
	level.fn_custom_round_ai_spawn = &function_33aa4940;
	level thread function_631e737d();
	level.fn_custom_zombie_spawner_selection = &function_b05d27ad;
	level thread function_48fda59a();
	level.fn_custom_wasp_favourate_enemy = undefined;
	level.func_get_zombie_spawn_delay = &function_59804866;
	level.func_get_delay_between_rounds = &function_5ee4c46c;
	level._zombiemode_post_respawn_callback = &function_afdf4111;
	init_sounds();
	zm_ai_raps::enable_raps_rounds();
	zm_ai_wasp::enable_wasp_rounds();
	zm_zod_margwa::function_5e93cd08();
	level._wasp_death_cb = &zm_zod_idgun_quest::function_14e2eca6;
	level._margwa_damage_cb = &zm_zod_ee::function_37dc5568;
	level.var_7cef68dc = &zm_zod_idgun_quest::function_c3ffc175;
	level.player_intersection_tracker_override = &function_d034d8ff;
	level.zones = [];
	level.zone_manager_init_func = &zm_zod_zone_init;
	init_zones[0] = "zone_start";
	level thread zm_zonemgr::manage_zones(init_zones);
	level.zombie_ai_limit = 24;
	level.default_laststandpistol = getweapon("pistol_revolver38");
	level.default_solo_laststandpistol = getweapon("pistol_revolver38_upgraded");
	level.laststandpistol = level.default_laststandpistol;
	level.start_weapon = level.default_laststandpistol;
	level thread zm::last_stand_pistol_rank_init();
	level thread zm_zod_ee::function_189ed812();
	level thread zm_zod_ee_side::main();
	level thread zm_zod_traps::init_traps();
	level thread zm_zod_quest::start_zod_quest();
	level thread zm_zod_maps::init();
	level thread setupmusic();
	level._powerup_grab_check = &powerup_can_player_grab;
	zm_powerups::powerup_remove_from_regular_drops("bonus_points_team");
	level thread beast_mode();
	zombie_utility::set_zombie_var("zombie_powerup_drop_max_per_round", 2);
	level thread placed_powerups();
	level thread wait_for_revive_machine_to_be_turned_on();
	weather_setup();
	level thread zm_zod_robot::init();
	level thread zm_zod_beastcode::init();
	level thread watch_for_world_transformation();
	level thread function_c257bc23();
	level thread util::set_lighting_state(0);
	level thread function_22eef972();
	level thread function_aab1d0bd();
	level thread function_a988e9bb();
	level thread function_bef9943a();
	level thread function_47f0c5f1();
	/#
		function_c9e2531c();
		function_c876231d();
		setup_devgui();
	#/
	zm_zod_ffotd::main_end();
}

/*
	Name: function_47f0c5f1
	Namespace: zm_zod
	Checksum: 0xFC377D52
	Offset: 0x3210
	Size: 0xFA
	Parameters: 0
	Flags: Linked
*/
function function_47f0c5f1()
{
	zombie_doors = getentarray("zombie_door", "targetname");
	foreach(door in zombie_doors)
	{
		if(door.script_flag == "connect_start_to_junction")
		{
			door.zombie_cost = 500;
			door zm_utility::set_hint_string(door, "default_buy_door", door.zombie_cost);
		}
	}
}

/*
	Name: function_d034d8ff
	Namespace: zm_zod
	Checksum: 0x5BCC75C5
	Offset: 0x3318
	Size: 0x56
	Parameters: 1
	Flags: Linked
*/
function function_d034d8ff(other_player)
{
	if(isdefined(self.on_train) && self.on_train)
	{
		return true;
	}
	if(isdefined(other_player.on_train) && other_player.on_train)
	{
		return true;
	}
	return false;
}

/*
	Name: check_end_solo_game_override
	Namespace: zm_zod
	Checksum: 0x174FEDA9
	Offset: 0x3378
	Size: 0x18
	Parameters: 0
	Flags: Linked
*/
function check_end_solo_game_override()
{
	if(isdefined(level.ai_robot))
	{
		return true;
	}
	return false;
}

/*
	Name: function_63f29efd
	Namespace: zm_zod
	Checksum: 0xEDFC21E4
	Offset: 0x3398
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function function_63f29efd()
{
	if(isdefined(level.var_46040f3e) && level.var_46040f3e == 1)
	{
		return false;
	}
	return true;
}

/*
	Name: powerup_grab_get_players_override
	Namespace: zm_zod
	Checksum: 0xC322DED
	Offset: 0x33C8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function powerup_grab_get_players_override()
{
	players = getplayers();
	if(isdefined(level.ai_robot))
	{
		players[players.size] = level.ai_robot;
	}
	return players;
}

/*
	Name: findclosest
	Namespace: zm_zod
	Checksum: 0x8871DC7C
	Offset: 0x3418
	Size: 0x132
	Parameters: 2
	Flags: Private
*/
function private findclosest(origin, entities)
{
	closest = spawnstruct();
	if(entities.size > 0)
	{
		closest.distancesquared = distancesquared(origin, entities[0].origin);
		closest.entity = entities[0];
		for(index = 1; index < entities.size; index++)
		{
			distancesquared = distancesquared(origin, entities[index].origin);
			if(distancesquared < closest.distancesquared)
			{
				closest.distancesquared = distancesquared;
				closest.entity = entities[index];
			}
		}
	}
	return closest;
}

/*
	Name: closest_player_override
	Namespace: zm_zod
	Checksum: 0xC61BD3AD
	Offset: 0x3558
	Size: 0x1A0
	Parameters: 2
	Flags: None
*/
function closest_player_override(origin, players)
{
	aiprofile_beginentry("zod-closest_player_override");
	player = arraygetclosest(origin, players);
	ai = getactorteamarray("allies");
	foreach(value in ai)
	{
		if(value.allow_zombie_to_target_ai === 1)
		{
			dist2player = distancesquared(origin, player.origin);
			dist2robot = distancesquared(origin, value.origin);
			if(dist2robot < dist2player)
			{
				aiprofile_endentry();
				return value;
			}
		}
	}
	aiprofile_endentry();
	return player;
}

/*
	Name: function_2d0e5eb6
	Namespace: zm_zod
	Checksum: 0x7434076A
	Offset: 0x3700
	Size: 0x180
	Parameters: 0
	Flags: Linked
*/
function function_2d0e5eb6()
{
	var_5cf494cb = getarraykeys(level.zombie_powerups);
	var_b4442b55 = array("bonus_points_team", "shield_charge", "ww_grenade");
	powerup_keys = [];
	for(i = 0; i < var_5cf494cb.size; i++)
	{
		var_77917a61 = 0;
		foreach(var_68de493a in var_b4442b55)
		{
			if(var_5cf494cb[i] == var_68de493a)
			{
				var_77917a61 = 1;
			}
		}
		if(var_77917a61)
		{
			continue;
			continue;
		}
		powerup_keys[powerup_keys.size] = var_5cf494cb[i];
	}
	powerup_keys = array::randomize(powerup_keys);
	return powerup_keys[0];
}

/*
	Name: function_533186ee
	Namespace: zm_zod
	Checksum: 0xBAF62256
	Offset: 0x3888
	Size: 0x102
	Parameters: 0
	Flags: Linked
*/
function function_533186ee()
{
	var_5f66b0c7 = level clientfield::get("ee_quest_state");
	if(var_5f66b0c7 == 1)
	{
		var_18bac0f0 = array((2544, -3432, -368), (2708, -3432, -368), (2544, -3624, -368), (2708, -3624, -368));
		v_spawn = array::random(var_18bac0f0);
		s_spawnpoint = spawnstruct();
		s_spawnpoint.origin = v_spawn;
		return s_spawnpoint;
	}
	return self zm_bgb_anywhere_but_here::function_728dfe3();
}

/*
	Name: wait_for_revive_machine_to_be_turned_on
	Namespace: zm_zod
	Checksum: 0x800E2E45
	Offset: 0x3998
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function wait_for_revive_machine_to_be_turned_on()
{
	level waittill(#"specialty_quickrevive_power_on");
	if(!level flag::exists("solo_revive"))
	{
		level flag::init("solo_revive");
	}
	level.override_use_solo_revive = &zod_use_solo_revive;
}

/*
	Name: zod_use_solo_revive
	Namespace: zm_zod
	Checksum: 0x82508C00
	Offset: 0x3A08
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function zod_use_solo_revive()
{
	players = getplayers();
	solo_mode = 0;
	if(players.size == 1 || (isdefined(level.force_solo_quick_revive) && level.force_solo_quick_revive))
	{
		solo_mode = 1;
	}
	level.using_solo_revive = solo_mode;
	return solo_mode;
}

/*
	Name: revive_cost_override
	Namespace: zm_zod
	Checksum: 0xC467EC44
	Offset: 0x3A80
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function revive_cost_override()
{
	solo = use_solo_revive_price();
	if(solo)
	{
		return 500;
	}
	return 1500;
}

/*
	Name: use_solo_revive_price
	Namespace: zm_zod
	Checksum: 0x5074CB84
	Offset: 0x3AC0
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function use_solo_revive_price()
{
	players = getplayers();
	solo_mode = 0;
	if(players.size == 1 || (isdefined(level.force_solo_quick_revive) && level.force_solo_quick_revive))
	{
		solo_mode = 1;
	}
	level.using_solo_revive_price = solo_mode;
	return solo_mode;
}

/*
	Name: on_player_spawned
	Namespace: zm_zod
	Checksum: 0x2883A74F
	Offset: 0x3B38
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self thread player_rain_fx();
	self thread function_8535c602();
	self allowwallrun(0);
	self allowdoublejump(0);
}

/*
	Name: register_clientfields
	Namespace: zm_zod
	Checksum: 0xE60C9184
	Offset: 0x3BA8
	Size: 0x46C
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("toplayer", "fullscreen_rain_fx", 1, 1, "int");
	clientfield::register("world", "rain_state", 1, 1, "int");
	n_bits = getminbitcountfornum(8);
	clientfield::register("toplayer", "player_rumble_and_shake", 1, n_bits, "int");
	clientfield::register("toplayer", "devgui_lightning_test", 1, 1, "counter");
	clientfield::register("actor", "ghost_actor", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_character_identity", 1, getminbitcountfornum(4), "int");
	clientfield::register("clientuimodel", "zmInventory.player_using_sprayer", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_crafted_fusebox", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_crafted_shield", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_crafted_idgun", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_sword_quest_egg_state", 1, getminbitcountfornum(7), "int");
	clientfield::register("clientuimodel", "zmInventory.player_sword_quest_completed_level_1", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_quest_items", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_idgun_parts", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_shield_parts", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_fuses", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_egg", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_sprayer", 1, 1, "int");
	clientfield::register("world", "hide_perf_static_models", 1, 1, "int");
	clientfield::register("world", "breakable_show", 1, 3, "int");
	clientfield::register("world", "breakable_hide", 1, 3, "int");
	visionset_mgr::register_info("visionset", "zombie_noire", 1, 2, 1, 1);
}

/*
	Name: player_rain_fx
	Namespace: zm_zod
	Checksum: 0xF085377D
	Offset: 0x4020
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function player_rain_fx()
{
	self endon(#"death");
	util::wait_network_frame();
	util::wait_network_frame();
	self.b_rain_on = 1;
	self clientfield::set_to_player("fullscreen_rain_fx", 1);
}

/*
	Name: weather_setup
	Namespace: zm_zod
	Checksum: 0x4597743E
	Offset: 0x4090
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function weather_setup()
{
	a_trig_rain_outdoor = getentarray("trig_rain_indoor", "targetname");
	foreach(e_trig in a_trig_rain_outdoor)
	{
		e_trig thread monitor_outdoor_rain_doorways();
	}
}

/*
	Name: monitor_outdoor_rain_doorways
	Namespace: zm_zod
	Checksum: 0x8DBF4444
	Offset: 0x4150
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function monitor_outdoor_rain_doorways()
{
	while(true)
	{
		self waittill(#"trigger", e_player);
		if(isdefined(e_player.b_rain_on) && e_player.b_rain_on)
		{
			e_player thread pause_rain_overlay(self);
		}
	}
}

/*
	Name: pause_rain_overlay
	Namespace: zm_zod
	Checksum: 0x2E63E656
	Offset: 0x41C0
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function pause_rain_overlay(e_trig)
{
	self endon(#"disconnect");
	self.b_rain_on = 0;
	self clientfield::set_to_player("fullscreen_rain_fx", 0);
	util::wait_till_not_touching(e_trig, self);
	self.b_rain_on = 1;
	self clientfield::set_to_player("fullscreen_rain_fx", 1);
}

/*
	Name: powerup_can_player_grab
	Namespace: zm_zod
	Checksum: 0xB75B6B6E
	Offset: 0x4250
	Size: 0x10
	Parameters: 1
	Flags: Linked
*/
function powerup_can_player_grab(player)
{
	return true;
}

/*
	Name: beast_mode
	Namespace: zm_zod
	Checksum: 0xADC56F8E
	Offset: 0x4268
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function beast_mode()
{
	beast_mode_highlights();
	level.player_out_of_playable_area_monitor_callback = &player_out_of_playable_area_monitor_callback;
}

/*
	Name: player_out_of_playable_area_monitor_callback
	Namespace: zm_zod
	Checksum: 0x268A399E
	Offset: 0x42A0
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function player_out_of_playable_area_monitor_callback()
{
	if(isdefined(self.beastmode) && self.beastmode && !self zm::in_kill_brush())
	{
		return false;
	}
	return true;
}

/*
	Name: beast_mode_highlights
	Namespace: zm_zod
	Checksum: 0x46DA82BF
	Offset: 0x42E0
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function beast_mode_highlights()
{
	things = getentarray("grapple_target", "targetname");
	foreach(thing in things)
	{
		thing clientfield::set("bminteract", 3);
		thing notsolid();
		wait(0.05);
	}
}

/*
	Name: placed_powerups
	Namespace: zm_zod
	Checksum: 0x2664088
	Offset: 0x43D0
	Size: 0x162
	Parameters: 0
	Flags: Linked
*/
function placed_powerups()
{
	zm_powerups::powerup_round_start();
	a_bonus_types = [];
	array::add(a_bonus_types, "double_points");
	array::add(a_bonus_types, "insta_kill");
	array::add(a_bonus_types, "full_ammo");
	a_bonus = struct::get_array("placed_powerup", "targetname");
	foreach(s_bonus in a_bonus)
	{
		str_type = array::random(a_bonus_types);
		spawn_infinite_powerup_drop(s_bonus.origin, str_type);
	}
}

/*
	Name: spawn_infinite_powerup_drop
	Namespace: zm_zod
	Checksum: 0xF35920F3
	Offset: 0x4540
	Size: 0x8A
	Parameters: 2
	Flags: Linked
*/
function spawn_infinite_powerup_drop(v_origin, str_type)
{
	level._powerup_timeout_override = &powerup_infinite_time;
	if(isdefined(str_type))
	{
		intro_powerup = zm_powerups::specific_powerup_drop(str_type, v_origin);
	}
	else
	{
		intro_powerup = zm_powerups::powerup_drop(v_origin);
	}
	level._powerup_timeout_override = undefined;
}

/*
	Name: powerup_infinite_time
	Namespace: zm_zod
	Checksum: 0x99EC1590
	Offset: 0x45D8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function powerup_infinite_time()
{
}

/*
	Name: init_sounds
	Namespace: zm_zod
	Checksum: 0xA1E5719A
	Offset: 0x45E8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function init_sounds()
{
	zm_utility::add_sound("break_stone", "evt_break_stone");
	zm_utility::add_sound("gate_door", "zmb_gate_slide_open");
	zm_utility::add_sound("heavy_door", "zmb_heavy_door_open");
	zm_utility::add_sound("zmb_heavy_door_open", "zmb_heavy_door_open");
}

/*
	Name: magic_box_init
	Namespace: zm_zod
	Checksum: 0x87119EC9
	Offset: 0x4678
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function magic_box_init()
{
	level.random_pandora_box_start = 1;
	zm_magicbox_zod::init();
}

/*
	Name: offhand_weapon_overrride
	Namespace: zm_zod
	Checksum: 0x2C55DF5F
	Offset: 0x46A8
	Size: 0xBE
	Parameters: 0
	Flags: Linked
*/
function offhand_weapon_overrride()
{
	zm_utility::register_lethal_grenade_for_level("frag_grenade");
	level.zombie_lethal_grenade_player_init = getweapon("frag_grenade");
	zm_utility::register_tactical_grenade_for_level("octobomb");
	zm_utility::register_tactical_grenade_for_level("octobomb_upgraded");
	zm_utility::register_melee_weapon_for_level(level.weaponbasemelee.name);
	level.zombie_melee_weapon_player_init = level.weaponbasemelee;
	zm_utility::register_melee_weapon_for_level("bowie_knife");
	level.zombie_equipment_player_init = undefined;
}

/*
	Name: offhand_weapon_give_override
	Namespace: zm_zod
	Checksum: 0x8EDA0ED5
	Offset: 0x4770
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function offhand_weapon_give_override(str_weapon)
{
	self endon(#"death");
	if(zm_utility::is_tactical_grenade(str_weapon) && isdefined(self zm_utility::get_player_tactical_grenade()) && !self zm_utility::is_player_tactical_grenade(str_weapon))
	{
		self setweaponammoclip(self zm_utility::get_player_tactical_grenade(), 0);
		self takeweapon(self zm_utility::get_player_tactical_grenade());
	}
	return false;
}

/*
	Name: zm_zod_beastpath
	Namespace: zm_zod
	Checksum: 0xB93972CA
	Offset: 0x4838
	Size: 0x64
	Parameters: 2
	Flags: None
*/
function zm_zod_beastpath(triggername, platformname)
{
	beast_connect_triggers = getentarray(triggername, "targetname");
	array::thread_all(beast_connect_triggers, &activate_beast_platforms, platformname);
}

/*
	Name: activate_beast_platforms
	Namespace: zm_zod
	Checksum: 0xE443903B
	Offset: 0x48A8
	Size: 0x10E
	Parameters: 1
	Flags: Linked
*/
function activate_beast_platforms(platformname)
{
	beast_connect_platforms = getentarray(platformname, "targetname");
	for(i = 0; i < beast_connect_platforms.size; i++)
	{
		beast_connect_platforms[i] hide();
	}
	self waittill(#"trigger");
	for(i = 0; i < beast_connect_platforms.size; i++)
	{
		beast_connect_platforms[i] show();
		beast_connect_platforms[i] connectpaths();
		beast_connect_platforms[i] setmovingplatformenabled(1);
	}
}

/*
	Name: zm_zod_zone_init
	Namespace: zm_zod
	Checksum: 0x4F45C52C
	Offset: 0x49C0
	Size: 0x24DC
	Parameters: 0
	Flags: Linked
*/
function zm_zod_zone_init()
{
	zm_zonemgr::zone_init("zone_teleport", 0);
	zm_zonemgr::zone_init("zone_train_rail", 0);
	zm_zonemgr::enable_zone("zone_teleport");
	zm_zonemgr::enable_zone("zone_train_rail");
	zm_zonemgr::add_adjacent_zone("zone_start", "zone_junction_start", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_start", "zone_start_high", "connect_start_to_magician", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_start_high", "zone_start", "connect_start_to_magician", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_start_high", "zone_start_magician", "connect_start_to_magician", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_start_magician", "zone_start_high", "connect_start_to_magician", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_start_magician", "zone_start_magician_high", "connect_start_to_magician", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_start_magician_high", "zone_start_magician", "connect_start_to_magician", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_start_magician_high", "zone_start_fire_escape", "connect_start_to_magician", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_start_fire_escape", "zone_start", "connect_start_to_magician", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_start_fire_escape", "zone_junction_start", "connect_start_to_magician", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_start_fire_escape", "zone_junction_canal", "connect_start_to_magician", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_start_fire_escape", "zone_start_magician_high", "connect_start_to_magician", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_start", "zone_junction_canal", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_start", "zone_junction_slums", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_start", "zone_junction_theater", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_start", "zone_start", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_start", "zone_start_fire_escape", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_slums", "zone_junction_start", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_slums", "zone_junction_canal", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_slums", "zone_junction_theater", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_slums", "zone_slums_junction", "connect_slums_to_junction", 1, 0, 1);
	zm_zonemgr::add_adjacent_zone("zone_junction_canal", "zone_junction_start", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_canal", "zone_junction_slums", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_canal", "zone_junction_theater", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_canal", "zone_canal_junction", "connect_canal_to_junction", 1, 0, 1);
	zm_zonemgr::add_adjacent_zone("zone_junction_theater", "zone_junction_canal", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_theater", "zone_junction_start", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_theater", "zone_junction_slums", "connect_start_to_junction", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_junction_theater", "zone_theater_junction", "connect_theater_to_junction", 1, 0, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_junction", "zone_junction_canal", "connect_canal_to_junction", 1, 1, 0);
	zm_zonemgr::add_adjacent_zone("zone_canal_junction", "zone_canal_A", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_junction", "zone_canal_B", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_junction", "zone_canal_high_A", "connect_canal_high_to_low", 1, 1, 3);
	zm_zonemgr::add_adjacent_zone("zone_canal_A", "zone_canal_junction", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_A", "zone_canal_B", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_A", "zone_canal_C", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_A", "zone_canal_water_A", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_B", "zone_canal_junction", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_B", "zone_canal_A", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_B", "zone_canal_water_A", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_C", "zone_canal_junction", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_C", "zone_canal_B", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_C", "zone_canal_D", "connect_canal_to_train", 1, 1, 2);
	zm_zonemgr::add_adjacent_zone("zone_canal_C", "zone_canal_E", "connect_canal_to_train", 1, 1, 2);
	zm_zonemgr::add_adjacent_zone("zone_canal_C", "zone_canal_water_B", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_C", "zone_canal_water_C", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_D", "zone_canal_C", "connect_canal_to_train", 1, 2, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_D", "zone_canal_E", "activate_brothel_street", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_canal_D", "zone_canal_train", "activate_brothel_street", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_canal_D", "zone_canal_high_C", "connect_canal_high_to_train", 1, 2, 3);
	zm_zonemgr::add_adjacent_zone("zone_canal_D", "zone_canal_brothel", "connect_canal_to_brothel", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_canal_E", "zone_canal_C", "connect_canal_to_train", 1, 2, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_E", "zone_canal_D", "activate_brothel_street", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_canal_E", "zone_canal_train", "activate_brothel_street", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_canal_E", "zone_canal_high_C", "connect_canal_high_to_train", 1, 2, 3);
	zm_zonemgr::add_adjacent_zone("zone_canal_E", "zone_canal_brothel", "connect_canal_to_brothel", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_canal_train", "zone_canal_C", "connect_canal_to_brothel", 1, 2, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_train", "zone_canal_D", "activate_brothel_street", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_canal_train", "zone_canal_E", "activate_brothel_street", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_canal_train", "zone_canal_high_C", "connect_canal_high_to_train", 1, 2, 3);
	zm_zonemgr::add_adjacent_zone("zone_canal_water_A", "zone_canal_water_B", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_water_A", "zone_canal_water_C", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_water_B", "zone_canal_water_A", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_water_B", "zone_canal_water_C", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_water_C", "zone_canal_water_A", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_water_C", "zone_canal_water_B", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_water_C", "zone_canal_C", "activate_canal", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_water_C", "zone_canal_D", "connect_canal_to_train", 1, 1, 2);
	zm_zonemgr::add_adjacent_zone("zone_canal_water_C", "zone_canal_E", "connect_canal_to_train", 1, 1, 2);
	zm_zonemgr::add_adjacent_zone("zone_canal_high_A", "zone_canal_high_B", "activate_canal_high", 1, 3, 3);
	zm_zonemgr::add_adjacent_zone("zone_canal_high_A", "zone_canal_junction", "connect_canal_high_to_low", 1, 3, 1);
	zm_zonemgr::add_adjacent_zone("zone_canal_high_B", "zone_canal_high_A", "activate_canal_high", 1, 3, 3);
	zm_zonemgr::add_adjacent_zone("zone_canal_high_B", "zone_canal_high_C", "connect_canal_high_to_train", 1, 3, 3);
	zm_zonemgr::add_adjacent_zone("zone_canal_high_C", "zone_canal_high_B", "connect_canal_high_to_train", 1, 3, 3);
	zm_zonemgr::add_adjacent_zone("zone_canal_high_C", "zone_canal_train", "connect_canal_high_to_train", 1, 3, 2);
	zm_zonemgr::add_adjacent_zone("zone_canal_brothel", "zone_canal_D", "connect_canal_to_brothel", 1, 2, 2);
	zm_zonemgr::add_zone_flags("connect_canal_to_junction", "activate_canal");
	zm_zonemgr::add_zone_flags("connect_canal_high_to_low", "activate_canal");
	zm_zonemgr::add_zone_flags("connect_canal_high_to_low", "activate_canal_high");
	zm_zonemgr::add_zone_flags("connect_canal_to_train", "activate_brothel_street");
	zm_zonemgr::add_zone_flags("connect_canal_to_train", "activate_canal");
	zm_zonemgr::add_zone_flags("connect_canal_high_to_train", "activate_brothel_street");
	zm_zonemgr::add_zone_flags("connect_canal_high_to_train", "activate_canal_high");
	zm_zonemgr::add_adjacent_zone("zone_slums_junction", "zone_junction_slums", "connect_slums_to_junction", 1, 1, 0);
	zm_zonemgr::add_adjacent_zone("zone_slums_junction", "zone_slums_A", "activate_slums_junction_alley", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_slums_junction", "zone_slums_high_A", "connect_slums_high_to_low", 1, 1, 3);
	zm_zonemgr::add_adjacent_zone("zone_slums_A", "zone_slums_junction", "activate_slums_junction_alley", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_slums_A", "zone_slums_B", "activate_slums_junction_alley", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_slums_B", "zone_slums_A", "activate_slums_junction_alley", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_slums_B", "zone_slums_C", "connect_slums_waterfront_to_alley", 1, 1, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_C", "zone_slums_B", "connect_slums_waterfront_to_alley", 1, 2, 1);
	zm_zonemgr::add_adjacent_zone("zone_slums_C", "zone_slums_D", "activate_slums_waterfront", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_C", "zone_slums_train", "activate_slums_waterfront", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_D", "zone_slums_C", "activate_slums_waterfront", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_D", "zone_slums_E", "activate_slums_waterfront", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_D", "zone_slums_train", "activate_slums_waterfront", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_E", "zone_slums_D", "activate_slums_waterfront", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_E", "zone_slums_gym", "connect_slums_waterfront_to_gym", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_train", "zone_slums_C", "activate_slums_waterfront", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_train", "zone_slums_D", "activate_slums_waterfront", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_train", "zone_slums_high_E", "connect_slums_high_to_train", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_train", "zone_slums_high_F", "connect_slums_high_to_train", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_gym", "zone_slums_E", "connect_slums_waterfront_to_gym", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_gym", "zone_slums_gym_lockers", "connect_slums_waterfront_to_gym", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_gym_lockers", "zone_slums_E", "connect_slums_waterfront_to_gym", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_gym_lockers", "zone_slums_gym", "connect_slums_waterfront_to_gym", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_high_A", "zone_slums_junction", "connect_slums_high_to_low", 1, 3, 1);
	zm_zonemgr::add_adjacent_zone("zone_slums_high_A", "zone_slums_high_B", "activate_slums_high", 1, 3, 3);
	zm_zonemgr::add_adjacent_zone("zone_slums_high_B", "zone_slums_high_A", "activate_slums_high", 1, 3, 3);
	zm_zonemgr::add_adjacent_zone("zone_slums_high_B", "zone_slums_high_C", "connect_slums_high_to_train", 1, 3, 3);
	zm_zonemgr::add_adjacent_zone("zone_slums_high_C", "zone_slums_high_B", "connect_slums_high_to_train", 1, 3, 3);
	zm_zonemgr::add_adjacent_zone("zone_slums_high_C", "zone_slums_high_D", "connect_slums_high_to_train", 1, 3, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_high_D", "zone_slums_high_C", "connect_slums_high_to_train", 1, 2, 3);
	zm_zonemgr::add_adjacent_zone("zone_slums_high_D", "zone_slums_high_E", "connect_slums_high_to_train", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_high_E", "zone_slums_high_D", "connect_slums_high_to_train", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_high_E", "zone_slums_high_F", "connect_slums_high_to_train", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_high_F", "zone_slums_high_E", "connect_slums_high_to_train", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_slums_high_F", "zone_slums_train", "connect_slums_high_to_train", 1, 2, 2);
	zm_zonemgr::add_zone_flags("connect_slums_to_junction", "activate_slums_junction_alley");
	zm_zonemgr::add_zone_flags("connect_slums_waterfront_to_alley", "activate_slums_junction_alley");
	zm_zonemgr::add_zone_flags("connect_slums_waterfront_to_alley", "activate_slums_waterfront");
	zm_zonemgr::add_zone_flags("connect_slums_high_to_low", "activate_slums_junction_alley");
	zm_zonemgr::add_zone_flags("connect_slums_high_to_low", "activate_slums_high");
	zm_zonemgr::add_zone_flags("connect_slums_high_to_train", "activate_slums_waterfront");
	zm_zonemgr::add_zone_flags("connect_slums_high_to_train", "activate_slums_high");
	zm_zonemgr::add_adjacent_zone("zone_theater_junction", "zone_junction_theater", "connect_theater_to_junction", 1, 1, 0);
	zm_zonemgr::add_adjacent_zone("zone_theater_junction", "zone_theater_A", "activate_theater_alley", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_theater_A", "zone_theater_junction", "activate_theater_alley", 1, 1, 1);
	zm_zonemgr::add_adjacent_zone("zone_theater_A", "zone_theater_B", "connect_theater_alley_to_square", 1, 1, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_A", "zone_theater_high_A", "connect_theater_high_to_low", 1, 1, 3);
	zm_zonemgr::add_adjacent_zone("zone_theater_B", "zone_theater_A", "connect_theater_alley_to_square", 1, 2, 1);
	zm_zonemgr::add_adjacent_zone("zone_theater_B", "zone_theater_C", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_B", "zone_theater_D", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_B", "zone_theater_E", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_C", "zone_theater_B", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_C", "zone_theater_E", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_C", "zone_theater_train", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_C", "zone_theater_high_D", "connect_theater_high_to_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_D", "zone_theater_B", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_D", "zone_theater_E", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_D", "zone_theater_F", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_E", "zone_theater_B", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_E", "zone_theater_C", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_E", "zone_theater_D", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_E", "zone_theater_F", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_F", "zone_theater_D", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_F", "zone_theater_E", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_F", "zone_theater_burlesque_entrance", "connect_theater_to_burlesque", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_high_A", "zone_theater_junction", "connect_theater_high_to_low", 1, 3, 1);
	zm_zonemgr::add_adjacent_zone("zone_theater_high_A", "zone_theater_A", "connect_theater_high_to_low", 1, 3, 1);
	zm_zonemgr::add_adjacent_zone("zone_theater_high_A", "zone_theater_high_B", "activate_theater_high", 1, 3, 3);
	zm_zonemgr::add_adjacent_zone("zone_theater_high_B", "zone_theater_high_A", "activate_theater_high", 1, 3, 3);
	zm_zonemgr::add_adjacent_zone("zone_theater_high_B", "zone_theater_high_C", "connect_theater_high_to_square", 1, 3, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_high_C", "zone_theater_high_B", "connect_theater_high_to_square", 1, 2, 3);
	zm_zonemgr::add_adjacent_zone("zone_theater_high_C", "zone_theater_high_D", "connect_theater_high_to_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_high_D", "zone_theater_high_C", "connect_theater_high_to_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_high_D", "zone_theater_train", "connect_theater_high_to_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_high_D", "zone_theater_C", "connect_theater_high_to_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_train", "zone_theater_high_D", "connect_theater_high_to_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_train", "zone_theater_C", "activate_theater_square", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_burlesque_entrance", "zone_theater_F", "connect_theater_to_burlesque", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_burlesque_entrance", "zone_theater_burlesque", "connect_theater_to_burlesque", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_burlesque", "zone_theater_burlesque_entrance", "connect_theater_to_burlesque", 1, 2, 2);
	zm_zonemgr::add_adjacent_zone("zone_theater_burlesque", "zone_theater_F", "connect_theater_to_burlesque", 1, 2, 2);
	zm_zonemgr::add_zone_flags("connect_theater_to_junction", "activate_theater_alley");
	zm_zonemgr::add_zone_flags("connect_theater_alley_to_square", "activate_theater_alley");
	zm_zonemgr::add_zone_flags("connect_theater_alley_to_square", "activate_theater_square");
	zm_zonemgr::add_zone_flags("connect_theater_high_to_square", "activate_theater_square");
	zm_zonemgr::add_zone_flags("connect_theater_high_to_square", "activate_theater_high");
	zm_zonemgr::add_zone_flags("connect_theater_high_to_square", "activate_theater_alley");
	zm_zonemgr::add_zone_flags("connect_theater_high_to_low", "activate_theater_alley");
	zm_zonemgr::add_zone_flags("connect_theater_high_to_low", "activate_theater_high");
	zm_zonemgr::add_adjacent_zone("zone_subway_pap_ritual", "zone_subway_pap", "pap_door_open", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_subway_pap_ritual", "zone_subway_north", "pap_door_open", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_subway_pap", "zone_subway_pap_ritual", "pap_door_open", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_subway_north", "zone_subway_pap", "pap_door_open", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_subway_north", "zone_subway_central", "activate_underground", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_subway_central", "zone_subway_north", "activate_underground", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_subway_central", "zone_subway_junction", "activate_underground", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_subway_junction", "zone_subway_central", "activate_underground", 1, 0, 0);
	zm_zonemgr::add_adjacent_zone("zone_subway_junction", "zone_junction_theater", "connect_subway_to_junction", 1, 0, 0);
	zm_zonemgr::add_zone_flags("connect_subway_to_junction", "activate_underground");
	level thread function_8462bb2e();
}

/*
	Name: function_8462bb2e
	Namespace: zm_zod
	Checksum: 0xD382354D
	Offset: 0x6EA8
	Size: 0x1DC
	Parameters: 0
	Flags: Linked
*/
function function_8462bb2e()
{
	level flag::wait_till("zones_initialized");
	level.var_37e8a32e = [];
	var_ddd4dbb4 = getentarray("district_area", "targetname");
	foreach(var_17d18e45 in var_ddd4dbb4)
	{
		if(!isdefined(level.var_37e8a32e[var_17d18e45.script_noteworthy]))
		{
			level.var_37e8a32e[var_17d18e45.script_noteworthy] = var_17d18e45;
		}
	}
	level.var_37e8a32e["slums"] thread function_4edf07a("connect_slums_to_junction", "connect_slums_waterfront_to_alley", "connect_slums_high_to_low", "connect_slums_high_to_train");
	level.var_37e8a32e["canal"] thread function_4edf07a("connect_canal_to_junction", "connect_canal_to_train", "connect_canal_high_to_low", "connect_canal_high_to_train");
	level.var_37e8a32e["theater"] thread function_4edf07a("connect_theater_to_junction", "connect_theater_alley_to_square", "connect_theater_high_to_low", "connect_theater_high_to_square");
}

/*
	Name: function_4edf07a
	Namespace: zm_zod
	Checksum: 0x80127B87
	Offset: 0x7090
	Size: 0x60
	Parameters: 4
	Flags: Linked
*/
function function_4edf07a(var_a3958f28, var_f8f2bd2c, var_2d938fe3, var_e4bb21a8)
{
	self.var_f380b01d = 0;
	function_34cf312d(var_a3958f28, var_f8f2bd2c, var_2d938fe3, var_e4bb21a8);
	self.var_f380b01d = 1;
}

/*
	Name: function_34cf312d
	Namespace: zm_zod
	Checksum: 0xCB421AA8
	Offset: 0x70F8
	Size: 0x8C
	Parameters: 4
	Flags: Linked
*/
function function_34cf312d(var_a3958f28, var_f8f2bd2c, var_2d938fe3, var_e4bb21a8)
{
	level flag::wait_till(var_a3958f28);
	if(!level flag::get(var_f8f2bd2c))
	{
		level endon(var_f8f2bd2c);
		level flag::wait_till_all(array(var_2d938fe3, var_e4bb21a8));
	}
}

/*
	Name: include_weapons
	Namespace: zm_zod
	Checksum: 0x386E8375
	Offset: 0x7190
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function include_weapons()
{
	zm_utility::include_weapon("idgun", 1);
}

/*
	Name: precachecustomcharacters
	Namespace: zm_zod
	Checksum: 0x99EC1590
	Offset: 0x71C0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precachecustomcharacters()
{
}

/*
	Name: initcharacterstartindex
	Namespace: zm_zod
	Checksum: 0x4B519E27
	Offset: 0x71D0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function initcharacterstartindex()
{
	level.characterstartindex = randomint(4);
}

/*
	Name: selectcharacterindextouse
	Namespace: zm_zod
	Checksum: 0xAC9A360B
	Offset: 0x7200
	Size: 0x3E
	Parameters: 0
	Flags: None
*/
function selectcharacterindextouse()
{
	if(level.characterstartindex >= 4)
	{
		level.characterstartindex = 0;
	}
	self.characterindex = level.characterstartindex;
	level.characterstartindex++;
	return self.characterindex;
}

/*
	Name: assign_lowest_unused_character_index
	Namespace: zm_zod
	Checksum: 0x52A7DE97
	Offset: 0x7248
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function assign_lowest_unused_character_index()
{
	charindexarray = [];
	charindexarray[0] = 0;
	charindexarray[1] = 1;
	charindexarray[2] = 2;
	charindexarray[3] = 3;
	players = getplayers();
	if(players.size == 1)
	{
		charindexarray = array::randomize(charindexarray);
		return charindexarray[0];
	}
	foreach(player in players)
	{
		if(isdefined(player.characterindex))
		{
			arrayremovevalue(charindexarray, player.characterindex, 0);
		}
	}
	if(charindexarray.size > 0)
	{
		charindexarray = array::randomize(charindexarray);
		return charindexarray[0];
	}
	return 0;
}

/*
	Name: givecustomcharacters
	Namespace: zm_zod
	Checksum: 0xD5D2C329
	Offset: 0x73D0
	Size: 0x2E4
	Parameters: 0
	Flags: Linked
*/
function givecustomcharacters()
{
	if(isdefined(level.hotjoin_player_setup) && [[level.hotjoin_player_setup]]("c_zom_farmgirl_viewhands"))
	{
		return;
	}
	self detachall();
	if(!isdefined(self.characterindex))
	{
		self.characterindex = assign_lowest_unused_character_index();
	}
	self.favorite_wall_weapons_list = [];
	self.talks_in_danger = 0;
	/#
		if(getdvarstring("") != "")
		{
			self.characterindex = getdvarint("");
		}
	#/
	self setcharacterbodytype(self.characterindex + 5);
	self setcharacterbodystyle(0);
	self setcharacterhelmetstyle(0);
	switch(self.characterindex)
	{
		case 0:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("frag_grenade");
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("bouncingbetty");
			break;
		}
		case 1:
		{
			self.talks_in_danger = 1;
			level.rich_sq_player = self;
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("pistol_standard");
			break;
		}
		case 2:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("870mcs");
			break;
		}
		case 3:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("hk416");
			break;
		}
	}
	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
	self thread set_exert_id();
	self clientfield::set_player_uimodel("zmInventory.player_character_identity", self.characterindex);
}

/*
	Name: set_exert_id
	Namespace: zm_zod
	Checksum: 0x4651D0A6
	Offset: 0x76C0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function set_exert_id()
{
	self endon(#"disconnect");
	util::wait_network_frame();
	util::wait_network_frame();
	self zm_audio::setexertvoice(self.characterindex + 1);
}

/*
	Name: setup_personality_character_exerts
	Namespace: zm_zod
	Checksum: 0xC975215F
	Offset: 0x7720
	Size: 0xEFA
	Parameters: 0
	Flags: Linked
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["burp"][0] = "vox_plr_0_exert_bad_taste_0";
	level.exert_sounds[1]["burp"][1] = "vox_plr_0_exert_bad_taste_1";
	level.exert_sounds[1]["burp"][2] = "vox_plr_0_exert_bad_taste_2";
	level.exert_sounds[1]["burp"][3] = "vox_plr_0_exert_drinking_0";
	level.exert_sounds[1]["burp"][4] = "vox_plr_0_exert_drinking_1";
	level.exert_sounds[1]["burp"][5] = "vox_plr_0_exert_drinking_2";
	level.exert_sounds[2]["burp"][0] = "vox_plr_1_exert_bad_taste_0";
	level.exert_sounds[2]["burp"][1] = "vox_plr_1_exert_bad_taste_1";
	level.exert_sounds[2]["burp"][2] = "vox_plr_1_exert_bad_taste_2";
	level.exert_sounds[2]["burp"][3] = "vox_plr_1_exert_drinking_3";
	level.exert_sounds[3]["burp"][0] = "vox_plr_2_exert_bad_taste_0";
	level.exert_sounds[3]["burp"][1] = "vox_plr_2_exert_bad_taste_1";
	level.exert_sounds[3]["burp"][2] = "vox_plr_2_exert_bad_taste_2";
	level.exert_sounds[3]["burp"][3] = "vox_plr_2_exert_drinking_1";
	level.exert_sounds[3]["burp"][4] = "vox_plr_2_exert_drinking_3";
	level.exert_sounds[4]["burp"][0] = "vox_plr_3_exert_bad_taste_0";
	level.exert_sounds[4]["burp"][1] = "vox_plr_3_exert_bad_taste_1";
	level.exert_sounds[4]["burp"][2] = "vox_plr_3_exert_bad_taste_2";
	level.exert_sounds[4]["burp"][3] = "vox_plr_3_exert_bad_taste_3";
	level.exert_sounds[4]["burp"][4] = "vox_plr_3_exert_bad_taste_4";
	level.exert_sounds[4]["burp"][5] = "vox_plr_3_exert_bad_taste_5";
	level.exert_sounds[4]["burp"][6] = "vox_plr_3_exert_bad_taste_6";
	level.exert_sounds[4]["burp"][7] = "vox_plr_3_exert_bad_taste_7";
	level.exert_sounds[4]["burp"][8] = "vox_plr_3_exert_drinking_0";
	level.exert_sounds[4]["burp"][9] = "vox_plr_3_exert_drinking_1";
	level.exert_sounds[4]["burp"][10] = "vox_plr_3_exert_drinking_2";
	level.exert_sounds[4]["burp"][11] = "vox_plr_3_exert_drinking_3";
	level.exert_sounds[4]["burp"][12] = "vox_plr_3_exert_drinking_4";
	level.exert_sounds[4]["burp"][13] = "vox_plr_3_exert_drinking_5";
	level.exert_sounds[1]["hitmed"][0] = "vox_plr_0_exert_bit_0";
	level.exert_sounds[1]["hitmed"][1] = "vox_plr_0_exert_bit_1";
	level.exert_sounds[1]["hitmed"][2] = "vox_plr_0_exert_bit_2";
	level.exert_sounds[1]["hitmed"][3] = "vox_plr_0_exert_bit_3";
	level.exert_sounds[1]["hitmed"][4] = "vox_plr_0_exert_pain_0";
	level.exert_sounds[1]["hitmed"][5] = "vox_plr_0_exert_pain_1";
	level.exert_sounds[1]["hitmed"][6] = "vox_plr_0_exert_pain_2";
	level.exert_sounds[1]["hitmed"][7] = "vox_plr_0_exert_pain_3";
	level.exert_sounds[1]["hitmed"][8] = "vox_plr_0_exert_pain_4";
	level.exert_sounds[2]["hitmed"][0] = "vox_plr_1_exert_pain_0";
	level.exert_sounds[2]["hitmed"][1] = "vox_plr_1_exert_pain_1";
	level.exert_sounds[2]["hitmed"][2] = "vox_plr_1_exert_pain_2";
	level.exert_sounds[2]["hitmed"][3] = "vox_plr_1_exert_pain_3";
	level.exert_sounds[2]["hitmed"][4] = "vox_plr_1_exert_pain_4";
	level.exert_sounds[3]["hitmed"][0] = "vox_plr_2_exert_pain_0";
	level.exert_sounds[3]["hitmed"][1] = "vox_plr_2_exert_pain_1";
	level.exert_sounds[3]["hitmed"][2] = "vox_plr_2_exert_pain_2";
	level.exert_sounds[3]["hitmed"][3] = "vox_plr_2_exert_pain_3";
	level.exert_sounds[3]["hitmed"][4] = "vox_plr_2_exert_pain_4";
	level.exert_sounds[4]["hitmed"][0] = "vox_plr_3_exert_pain_0";
	level.exert_sounds[4]["hitmed"][1] = "vox_plr_3_exert_pain_1";
	level.exert_sounds[4]["hitmed"][2] = "vox_plr_3_exert_pain_2";
	level.exert_sounds[4]["hitmed"][3] = "vox_plr_3_exert_pain_3";
	level.exert_sounds[4]["hitmed"][4] = "vox_plr_3_exert_pain_4";
	level.exert_sounds[4]["hitmed"][5] = "vox_plr_3_exert_bit_0";
	level.exert_sounds[4]["hitmed"][6] = "vox_plr_3_exert_bit_1";
	level.exert_sounds[4]["hitmed"][7] = "vox_plr_3_exert_bit_2";
	level.exert_sounds[4]["hitmed"][8] = "vox_plr_3_exert_bit_3";
	level.exert_sounds[4]["hitmed"][9] = "vox_plr_3_exert_bit_4";
	level.exert_sounds[4]["hitmed"][10] = "vox_plr_3_exert_bit_6";
	level.exert_sounds[4]["hitmed"][11] = "vox_plr_3_exert_bit_7";
	level.exert_sounds[4]["hitmed"][12] = "vox_plr_3_exert_bit_8";
	level.exert_sounds[4]["hitmed"][13] = "vox_plr_3_exert_bit_9";
	level.exert_sounds[4]["hitmed"][14] = "vox_plr_3_exert_bit_10";
	level.exert_sounds[1]["hitlrg"][0] = "vox_plr_0_exert_bit_0";
	level.exert_sounds[1]["hitlrg"][1] = "vox_plr_0_exert_bit_1";
	level.exert_sounds[1]["hitlrg"][2] = "vox_plr_0_exert_bit_2";
	level.exert_sounds[1]["hitlrg"][3] = "vox_plr_0_exert_bit_3";
	level.exert_sounds[1]["hitlrg"][4] = "vox_plr_0_exert_pain_0";
	level.exert_sounds[1]["hitlrg"][5] = "vox_plr_0_exert_pain_1";
	level.exert_sounds[1]["hitlrg"][6] = "vox_plr_0_exert_pain_2";
	level.exert_sounds[1]["hitlrg"][7] = "vox_plr_0_exert_pain_3";
	level.exert_sounds[1]["hitlrg"][8] = "vox_plr_0_exert_pain_4";
	level.exert_sounds[2]["hitlrg"][0] = "vox_plr_1_exert_pain_0";
	level.exert_sounds[2]["hitlrg"][1] = "vox_plr_1_exert_pain_1";
	level.exert_sounds[2]["hitlrg"][2] = "vox_plr_1_exert_pain_2";
	level.exert_sounds[2]["hitlrg"][3] = "vox_plr_1_exert_pain_3";
	level.exert_sounds[2]["hitlrg"][4] = "vox_plr_1_exert_pain_4";
	level.exert_sounds[3]["hitlrg"][0] = "vox_plr_2_exert_pain_0";
	level.exert_sounds[3]["hitlrg"][1] = "vox_plr_2_exert_pain_1";
	level.exert_sounds[3]["hitlrg"][2] = "vox_plr_2_exert_pain_2";
	level.exert_sounds[3]["hitlrg"][3] = "vox_plr_2_exert_pain_3";
	level.exert_sounds[3]["hitlrg"][4] = "vox_plr_2_exert_pain_4";
	level.exert_sounds[4]["hitlrg"][0] = "vox_plr_3_exert_pain_0";
	level.exert_sounds[4]["hitlrg"][1] = "vox_plr_3_exert_pain_1";
	level.exert_sounds[4]["hitlrg"][2] = "vox_plr_3_exert_pain_2";
	level.exert_sounds[4]["hitlrg"][3] = "vox_plr_3_exert_pain_3";
	level.exert_sounds[4]["hitlrg"][4] = "vox_plr_3_exert_pain_4";
	level.exert_sounds[4]["hitlrg"][5] = "vox_plr_3_exert_bit_0";
	level.exert_sounds[4]["hitlrg"][6] = "vox_plr_3_exert_bit_1";
	level.exert_sounds[4]["hitlrg"][7] = "vox_plr_3_exert_bit_2";
	level.exert_sounds[4]["hitlrg"][8] = "vox_plr_3_exert_bit_3";
	level.exert_sounds[4]["hitlrg"][9] = "vox_plr_3_exert_bit_4";
	level.exert_sounds[4]["hitlrg"][10] = "vox_plr_3_exert_bit_6";
	level.exert_sounds[4]["hitlrg"][11] = "vox_plr_3_exert_bit_7";
	level.exert_sounds[4]["hitlrg"][12] = "vox_plr_3_exert_bit_8";
	level.exert_sounds[4]["hitlrg"][13] = "vox_plr_3_exert_bit_9";
	level.exert_sounds[4]["hitlrg"][14] = "vox_plr_3_exert_bit_10";
}

/*
	Name: custom_add_weapons
	Namespace: zm_zod
	Checksum: 0xD7D36589
	Offset: 0x8628
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_zod_weapons.csv", 1);
	zm_weapons::autofill_wallbuys_init();
}

/*
	Name: custom_add_vox
	Namespace: zm_zod
	Checksum: 0x11917E53
	Offset: 0x8668
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function custom_add_vox()
{
	zm_audio::loadplayervoicecategories("gamedata/audio/zm/zm_zod_vox.csv");
}

/*
	Name: function_c257bc23
	Namespace: zm_zod
	Checksum: 0x450ED9F4
	Offset: 0x8690
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function function_c257bc23()
{
	for(i = 1; i <= 4; i++)
	{
		zm_zod_ee::function_93ea4183(i, 0);
	}
}

/*
	Name: watch_for_world_transformation
	Namespace: zm_zod
	Checksum: 0x2F53DB39
	Offset: 0x86E0
	Size: 0x2BC
	Parameters: 0
	Flags: Linked
*/
function watch_for_world_transformation()
{
	mdl_god_near = getent("mdl_god_near", "targetname");
	mdl_god_far = getent("mdl_god_far", "targetname");
	mdl_god_far clientfield::set("far_apothigod_active", 1);
	mdl_god_near clientfield::set("near_apothigod_active", 1);
	mdl_god_far clientfield::set("far_apothigod_active", 0);
	mdl_god_near clientfield::set("near_apothigod_active", 0);
	mdl_god_near hide();
	mdl_god_far hide();
	level flag::wait_till("ritual_pap_complete");
	players = getplayers();
	foreach(player in players)
	{
		scoreevents::processscoreevent("main_quest", player);
	}
	function_3d302906(1);
	level flag::wait_till("ee_complete");
	players = getplayers();
	foreach(player in players)
	{
		scoreevents::processscoreevent("main_EE_quest", player);
	}
	function_3d302906(0);
}

/*
	Name: function_3d302906
	Namespace: zm_zod
	Checksum: 0x88571EB0
	Offset: 0x89A8
	Size: 0x14C
	Parameters: 1
	Flags: Linked
*/
function function_3d302906(var_9392be35)
{
	mdl_god_far = getent("mdl_god_far", "targetname");
	mdl_god_near = getent("mdl_god_near", "targetname");
	if(var_9392be35)
	{
		level thread lui::screen_flash(0.2, 0.5, 1, 1, "white");
		level thread util::set_lighting_state(3);
		mdl_god_far show();
		mdl_god_far clientfield::set("far_apothigod_active", 1);
	}
	else
	{
		level thread util::set_lighting_state(0);
		mdl_god_near hide();
		mdl_god_near clientfield::set("near_apothigod_active", 0);
	}
}

/*
	Name: setupmusic
	Namespace: zm_zod
	Checksum: 0x3D93D441
	Offset: 0x8B00
	Size: 0x2E4
	Parameters: 0
	Flags: Linked
*/
function setupmusic()
{
	zm_audio::musicstate_create("round_start", 3, "zod_roundstart_1", "zod_roundstart_2", "zod_roundstart_3", "zod_roundstart_4", "zod_roundstart_5");
	zm_audio::musicstate_create("round_start_short", 3, "zod_roundstart_short_1", "zod_roundstart_short_2", "zod_roundstart_short_3");
	zm_audio::musicstate_create("round_start_first", 3, "zod_roundstart_1", "zod_roundstart_2", "zod_roundstart_3", "zod_roundstart_4", "zod_roundstart_5");
	zm_audio::musicstate_create("round_end", 3, "zod_roundend_1", "zod_roundend_2", "zod_roundend_3");
	zm_audio::musicstate_create("game_over", 5, "zod_gameover");
	zm_audio::musicstate_create("parasite_start", 3, "zod_parasite_start");
	zm_audio::musicstate_create("parasite_over", 3, "zod_parasite_end");
	zm_audio::musicstate_create("meatball_start", 3, "zod_meatball_start");
	zm_audio::musicstate_create("meatball_over", 3, "zod_meatball_end");
	zm_audio::musicstate_create("coldhardcash", 4, "zod_egg_coldhardcash");
	zm_audio::musicstate_create("snakeskinboots", 4, "zod_egg_snakeskin");
	zm_audio::musicstate_create("snakeskinboots_instr", 4, "zod_egg_snakeskin_instr");
	zm_audio::musicstate_create("zod_endigc_lullaby", 4, "zod_endigc_lullaby");
	zm_audio::musicstate_create("shadfight", 4, "zod_ee_shadfight");
	zm_audio::musicstate_create("apothifight", 4, "zod_ee_apothifight");
	zm_audio::musicstate_create("none", 4, "none");
}

/*
	Name: zod_custom_weapon_weights
	Namespace: zm_zod
	Checksum: 0xF691AB4C
	Offset: 0x8DF0
	Size: 0x10
	Parameters: 1
	Flags: Linked
*/
function zod_custom_weapon_weights(keys)
{
	return keys;
}

/*
	Name: zod_special_weapon_magicbox_check
	Namespace: zm_zod
	Checksum: 0x90A63B0D
	Offset: 0x8E08
	Size: 0x10
	Parameters: 1
	Flags: Linked
*/
function zod_special_weapon_magicbox_check(weapon)
{
	return true;
}

/*
	Name: enemy_location_override
	Namespace: zm_zod
	Checksum: 0x80C047C6
	Offset: 0x8E20
	Size: 0x1D6
	Parameters: 2
	Flags: Linked
*/
function enemy_location_override(zombie, enemy)
{
	aiprofile_beginentry("zod-enemy_location_override");
	if(isdefined(enemy.on_train) && enemy.on_train)
	{
		var_d3443466 = 0;
		if(isdefined(level.o_zod_train))
		{
			var_d3443466 = [[ level.o_zod_train ]]->function_3e62f527();
		}
		if(!(isdefined(self.locked_in_train) && self.locked_in_train) && (!(isdefined(var_d3443466) && var_d3443466)))
		{
			touching = 0;
			if(isdefined(level.o_zod_train))
			{
				touching = [[ level.o_zod_train ]]->is_touching_train_volume(zombie);
			}
			if(!touching)
			{
				escape_position = zombie zod_cleanup::get_escape_position_in_current_zone();
				if(isdefined(escape_position))
				{
					aiprofile_endentry();
					return escape_position.origin;
				}
				aiprofile_endentry();
				return zombie getorigin();
			}
		}
	}
	/#
		if(isdefined(level.zombie_pathing_validation))
		{
			var_9667df3a = (1536, -9296, 544);
			var_9667df3a = getclosestpointonnavmesh(var_9667df3a, 100, 30);
			return var_9667df3a;
		}
	#/
	aiprofile_endentry();
	return undefined;
}

/*
	Name: validate_and_set_no_target_position
	Namespace: zm_zod
	Checksum: 0xD5B36409
	Offset: 0x9000
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function validate_and_set_no_target_position(position)
{
	if(isdefined(position))
	{
		goal_point = getclosestpointonnavmesh(position.origin, 100);
		if(isdefined(goal_point))
		{
			self setgoal(goal_point);
			self.has_exit_point = 1;
			return true;
		}
	}
	return false;
}

/*
	Name: no_target_override
	Namespace: zm_zod
	Checksum: 0xFD5E9971
	Offset: 0x9088
	Size: 0x33C
	Parameters: 1
	Flags: Linked
*/
function no_target_override(zombie)
{
	if(isdefined(zombie.has_exit_point))
	{
		return;
	}
	players = level.players;
	dist_zombie = 0;
	dist_player = 0;
	dest = 0;
	if(isdefined(level.zm_loc_types["wait_location"]))
	{
		locs = array::randomize(level.zm_loc_types["wait_location"]);
		for(i = 0; i < locs.size; i++)
		{
			found_point = 0;
			foreach(player in players)
			{
				if(player laststand::player_is_in_laststand())
				{
					continue;
				}
				away = vectornormalize(self.origin - player.origin);
				endpos = self.origin + vectorscale(away, 600);
				dist_zombie = distancesquared(locs[i].origin, endpos);
				dist_player = distancesquared(locs[i].origin, player.origin);
				if(dist_zombie < dist_player)
				{
					dest = i;
					found_point = 1;
					continue;
				}
				found_point = 0;
			}
			if(found_point)
			{
				if(zombie validate_and_set_no_target_position(locs[i]))
				{
					return;
				}
			}
		}
	}
	escape_position = zombie zod_cleanup::get_escape_position_in_current_zone();
	if(zombie validate_and_set_no_target_position(escape_position))
	{
		return;
	}
	escape_position = zombie zod_cleanup::get_escape_position();
	if(zombie validate_and_set_no_target_position(escape_position))
	{
		return;
	}
	zombie.has_exit_point = 1;
	zombie setgoal(zombie.origin);
}

/*
	Name: zombie_is_target_reachable
	Namespace: zm_zod
	Checksum: 0xA4A940C6
	Offset: 0x93D0
	Size: 0x2E4
	Parameters: 1
	Flags: Linked
*/
function zombie_is_target_reachable(player)
{
	var_cfd1da70 = self.zone_name;
	player_zone = player.zone_name;
	if(var_cfd1da70 === player_zone)
	{
		return 1;
	}
	if(!isdefined(var_cfd1da70) || !isdefined(player_zone))
	{
		return 0;
	}
	var_9165799c = level.zones[self.zone_name].district;
	var_e8c4df7b = level.zones[player.zone_name].district;
	var_bb534481 = level.zones[self.zone_name].area;
	var_147beb1e = level.zones[player.zone_name].area;
	if(var_bb534481 == 0 && var_147beb1e == 0)
	{
		return 1;
	}
	if(var_9165799c === var_e8c4df7b && var_bb534481 === var_147beb1e)
	{
		return 1;
	}
	if(var_9165799c === var_e8c4df7b)
	{
		if(var_bb534481 > var_147beb1e)
		{
			temp = var_bb534481;
			var_bb534481 = var_147beb1e;
			var_147beb1e = temp;
		}
		var_54f2276d = function_17c00a4f(var_9165799c, var_bb534481, var_e8c4df7b, var_147beb1e);
		return var_54f2276d;
	}
	if(var_bb534481 == 0 && var_147beb1e != 0)
	{
		var_54f2276d = function_17c00a4f("junction", 0, var_e8c4df7b, var_147beb1e);
		return var_54f2276d;
	}
	if(var_147beb1e == 0 && var_bb534481 != 0)
	{
		var_54f2276d = function_17c00a4f("junction", 0, var_9165799c, var_bb534481);
		return var_54f2276d;
	}
	var_92280803 = 1;
	var_58b7daa8 = 1;
	var_92280803 = function_17c00a4f("junction", 0, var_9165799c, var_bb534481);
	var_58b7daa8 = function_17c00a4f("junction", 0, var_e8c4df7b, var_147beb1e);
	return var_58b7daa8 && var_92280803;
}

/*
	Name: function_17c00a4f
	Namespace: zm_zod
	Checksum: 0x36245435
	Offset: 0x96C0
	Size: 0x1A6
	Parameters: 4
	Flags: Linked
*/
function function_17c00a4f(var_9165799c, var_25cf04a1, var_e8c4df7b, player_area)
{
	var_15a343e3 = function_6b75e74c(var_e8c4df7b);
	var_2473d928 = var_15a343e3["01"];
	var_7fd9f894 = var_15a343e3["12"];
	var_a5dc72fd = var_15a343e3["13"];
	var_da02e380 = var_15a343e3["23"];
	if(var_2473d928 && var_7fd9f894 && var_a5dc72fd && var_da02e380)
	{
		return 1;
	}
	if(var_25cf04a1 == 0)
	{
		if(!var_2473d928)
		{
			return 0;
		}
		if(player_area == 1)
		{
			return 1;
		}
		var_25cf04a1++;
	}
	if(var_25cf04a1 == 1 && player_area == 2)
	{
		return var_a5dc72fd && var_da02e380 || var_7fd9f894;
	}
	if(var_25cf04a1 == 2 && player_area == 3)
	{
		return var_a5dc72fd && var_7fd9f894 || var_da02e380;
	}
	if(var_25cf04a1 == 1 && player_area == 3)
	{
		return var_7fd9f894 && var_da02e380 || var_a5dc72fd;
	}
	return 0;
}

/*
	Name: function_6b75e74c
	Namespace: zm_zod
	Checksum: 0x16D32FB2
	Offset: 0x9870
	Size: 0x24C
	Parameters: 1
	Flags: Linked
*/
function function_6b75e74c(district)
{
	flags = [];
	if(district === "theater")
	{
		flags["01"] = level flag::get("connect_theater_to_junction");
		flags["12"] = level flag::get("connect_theater_alley_to_square");
		flags["13"] = level flag::get("connect_theater_high_to_low");
		flags["23"] = level flag::get("connect_theater_high_to_square");
		return flags;
	}
	if(district === "slums")
	{
		flags["01"] = level flag::get("connect_slums_to_junction");
		flags["12"] = level flag::get("connect_slums_waterfront_to_alley");
		flags["13"] = level flag::get("connect_slums_high_to_low");
		flags["23"] = level flag::get("connect_slums_high_to_train");
		return flags;
	}
	if(district === "canal")
	{
		flags["01"] = level flag::get("connect_canal_to_junction");
		flags["12"] = level flag::get("connect_canal_to_train");
		flags["13"] = level flag::get("connect_canal_high_to_low");
		flags["23"] = level flag::get("connect_canal_high_to_train");
		return flags;
	}
	return flags;
}

/*
	Name: evaluate_zone_path_override
	Namespace: zm_zod
	Checksum: 0xD7333CDE
	Offset: 0x9AC8
	Size: 0x60
	Parameters: 1
	Flags: None
*/
function evaluate_zone_path_override(player)
{
	aiprofile_beginentry("zod-zombie_is_target_reachable");
	res = zombie_is_target_reachable(player);
	aiprofile_endentry();
	return res;
}

/*
	Name: player_out_of_playable_area_override
	Namespace: zm_zod
	Checksum: 0x698B4FD6
	Offset: 0x9B30
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function player_out_of_playable_area_override()
{
	if(isdefined(level.o_zod_train))
	{
		var_4843dc70 = [[ level.o_zod_train ]]->get_train_vehicle();
		if(isdefined(var_4843dc70))
		{
			if(!isdefined(level.var_72c68d94))
			{
				level.var_72c68d94 = [];
				trigger = spawn("trigger_box", (5764, -3400, 560), 45, 186.5, 693, 160);
				trigger.angles = vectorscale((0, 1, 0), 45);
				if(!isdefined(level.var_72c68d94))
				{
					level.var_72c68d94 = [];
				}
				else if(!isarray(level.var_72c68d94))
				{
					level.var_72c68d94 = array(level.var_72c68d94);
				}
				level.var_72c68d94[level.var_72c68d94.size] = trigger;
			}
			foreach(trigger in level.var_72c68d94)
			{
				var_b28a4a84 = self istouching(trigger);
				var_d2b747d1 = var_4843dc70 istouching(trigger);
				if(var_b28a4a84 && !var_d2b747d1)
				{
					return true;
				}
			}
		}
	}
	return false;
}

/*
	Name: function_8535c602
	Namespace: zm_zod
	Checksum: 0x29AE35BA
	Offset: 0x9D30
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_8535c602()
{
	self thread function_e33614b9();
}

/*
	Name: function_e33614b9
	Namespace: zm_zod
	Checksum: 0xF46BF3A8
	Offset: 0x9D58
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function function_e33614b9()
{
	self endon(#"disconnect");
	util::wait_network_frame();
	while(true)
	{
		if(isdefined(self) && isplayer(self))
		{
			self notify(#"lightning_strike");
			self clientfield::increment_to_player("devgui_lightning_test", 1);
		}
		wait(12);
	}
}

/*
	Name: function_c9e2531c
	Namespace: zm_zod
	Checksum: 0xF60247A6
	Offset: 0x9DE8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_c9e2531c()
{
	level thread zm_zod_util::setup_devgui_func("ZM/Zod/Lighting/Slums Lightning Test", "zod_lightning_test", 1, &function_5abd3b41);
}

/*
	Name: function_5abd3b41
	Namespace: zm_zod
	Checksum: 0x31DBC1D7
	Offset: 0x9E30
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function function_5abd3b41(n_index)
{
	level notify(#"devgui_lightning_test");
	level endon(#"devgui_lightning_test");
	player = getplayers()[0];
	while(true)
	{
		player clientfield::increment_to_player("devgui_lightning_test", n_index);
		wait(12);
	}
}

/*
	Name: function_c876231d
	Namespace: zm_zod
	Checksum: 0x1A799BA1
	Offset: 0x9EB8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_c876231d()
{
	level thread zm_zod_util::setup_devgui_func("ZM/Zod/Ghost test", "zod_ghost_test", 1, &zod_ghost_test);
}

/*
	Name: zod_ghost_test
	Namespace: zm_zod
	Checksum: 0xA7DC0F7C
	Offset: 0x9F00
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function zod_ghost_test(n_index)
{
	level notify(#"zod_ghost_test");
	level endon(#"zod_ghost_test");
	player = getplayers()[0];
	var_8cfd368 = 1;
	while(true)
	{
		foreach(zombie in getaiteamarray(level.zombie_team))
		{
			zombie clientfield::set("ghost_actor", var_8cfd368);
		}
		var_8cfd368 = 1 - var_8cfd368;
		wait(12);
	}
}

/*
	Name: setup_devgui
	Namespace: zm_zod
	Checksum: 0x6F14B81
	Offset: 0xA028
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function setup_devgui()
{
	/#
		setdvar("", "");
		setdvar("", "");
		setdvar("", 0);
		setdvar("", 0);
		execdevgui("");
		level.custom_devgui = &function_4173fe95;
	#/
}

/*
	Name: function_4173fe95
	Namespace: zm_zod
	Checksum: 0x1701B168
	Offset: 0xA0E0
	Size: 0x15A
	Parameters: 1
	Flags: Linked
*/
function function_4173fe95(cmd)
{
	/#
		cmd_strings = strtok(cmd, "");
		switch(cmd_strings[0])
		{
			case "":
			{
				zombie_devgui_wasp_round(getdvarint(""));
				break;
			}
			case "":
			{
				zombie_devgui_wasp_round_skip(getdvarint(""));
				break;
			}
			case "":
			{
				zombie_devgui_raps_round(getdvarint(""));
				break;
			}
			case "":
			{
				zombie_devgui_raps_round_skip(getdvarint(""));
				break;
			}
			case "":
			{
				function_30018788();
				break;
			}
			default:
			{
				break;
			}
		}
	#/
}

/*
	Name: zombie_devgui_wasp_round
	Namespace: zm_zod
	Checksum: 0xA8C97C85
	Offset: 0xA248
	Size: 0xA0
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_wasp_round(num_wasp)
{
	/#
		if(!isdefined(level.wasp_enabled) || !level.wasp_enabled)
		{
			return;
		}
		if(!isdefined(level.wasp_rounds_enabled) || !level.wasp_rounds_enabled)
		{
			return;
		}
		if(!isdefined(level.wasp_spawners) || level.wasp_spawners.size < 1)
		{
			return;
		}
		function_4d732a77(num_wasp);
		level.next_wasp_round = level.round_number + 1;
	#/
}

/*
	Name: zombie_devgui_raps_round
	Namespace: zm_zod
	Checksum: 0xB4D2451C
	Offset: 0xA2F0
	Size: 0xA0
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_raps_round(num_raps)
{
	/#
		if(!isdefined(level.raps_enabled) || !level.raps_enabled)
		{
			return;
		}
		if(!isdefined(level.raps_rounds_enabled) || !level.raps_rounds_enabled)
		{
			return;
		}
		if(!isdefined(level.raps_spawners) || level.raps_spawners.size < 1)
		{
			return;
		}
		function_205a2511(num_raps);
		level.n_next_raps_round = level.round_number + 1;
	#/
}

/*
	Name: zombie_devgui_wasp_round_skip
	Namespace: zm_zod
	Checksum: 0xAD831954
	Offset: 0xA398
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_wasp_round_skip(num_wasp)
{
	/#
		if(isdefined(level.next_wasp_round))
		{
			function_4d732a77(num_wasp);
			zm_devgui::zombie_devgui_goto_round(level.next_wasp_round);
		}
	#/
}

/*
	Name: zombie_devgui_raps_round_skip
	Namespace: zm_zod
	Checksum: 0x6BF6130D
	Offset: 0xA3F0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_raps_round_skip(num_raps)
{
	/#
		if(isdefined(level.n_next_raps_round))
		{
			function_205a2511(num_raps);
			zm_devgui::zombie_devgui_goto_round(level.n_next_raps_round);
		}
	#/
}

/*
	Name: function_4d732a77
	Namespace: zm_zod
	Checksum: 0x11C1B123
	Offset: 0xA448
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_4d732a77(num_wasp)
{
	/#
		if(isdefined(num_wasp) && num_wasp > 0)
		{
			setdvar("", num_wasp);
		}
		else
		{
			setdvar("", "");
		}
	#/
}

/*
	Name: function_205a2511
	Namespace: zm_zod
	Checksum: 0xDBE19114
	Offset: 0xA4C0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_205a2511(num_raps)
{
	/#
		if(isdefined(num_raps) && num_raps > 0)
		{
			setdvar("", num_raps);
		}
		else
		{
			setdvar("", "");
		}
	#/
}

/*
	Name: function_30018788
	Namespace: zm_zod
	Checksum: 0xDF1F09D5
	Offset: 0xA538
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_30018788()
{
	/#
		if(isdefined(level.n_next_raps_round))
		{
			if(level.n_next_raps_round <= 15)
			{
				level.n_next_raps_round = 15;
			}
			level notify(#"raps_round_ending");
			zm_devgui::zombie_devgui_goto_round(level.n_next_raps_round);
		}
	#/
}

/*
	Name: function_33aa4940
	Namespace: zm_zod
	Checksum: 0xF6F417EE
	Offset: 0xA598
	Size: 0x240
	Parameters: 0
	Flags: Linked
*/
function function_33aa4940()
{
	if(level.round_number <= 11)
	{
		return 0;
	}
	if(isdefined(level.a_zombie_respawn_health["parasite"]) && level.a_zombie_respawn_health["parasite"].size > 0)
	{
		zm_ai_wasp::special_wasp_spawn(1);
		level.zombie_total--;
		return 1;
	}
	if(isdefined(level.a_zombie_respawn_health["raps"]) && level.a_zombie_respawn_health["raps"].size > 0)
	{
		zm_ai_raps::special_raps_spawn(1);
		level.zombie_total--;
		return 1;
	}
	var_c0692329 = 0;
	n_random = randomfloat(100);
	if(level.round_number > 30)
	{
		if(n_random < 5)
		{
			var_c0692329 = 1;
		}
	}
	else
	{
		if(level.round_number > 25)
		{
			if(n_random < 4)
			{
				var_c0692329 = 1;
			}
		}
		else
		{
			if(level.round_number > 15)
			{
				if(n_random < 3)
				{
					var_c0692329 = 1;
				}
			}
			else if(n_random < 2)
			{
				var_c0692329 = 1;
			}
		}
	}
	if(var_c0692329)
	{
		if(!flag::get("ritual_pap_complete"))
		{
			zm_ai_wasp::special_wasp_spawn(1);
		}
		else
		{
			if(math::cointoss())
			{
				zm_ai_raps::special_raps_spawn(1);
			}
			else
			{
				zm_ai_wasp::special_wasp_spawn(1);
			}
		}
		level.zombie_total--;
	}
	return var_c0692329;
}

/*
	Name: function_80ba9218
	Namespace: zm_zod
	Checksum: 0x1B75DA8
	Offset: 0xA7E0
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function function_80ba9218(revivee)
{
	if(isdefined(revivee.being_revived_by_robot) && revivee.being_revived_by_robot == 1)
	{
		return false;
	}
	return true;
}

/*
	Name: function_59804866
	Namespace: zm_zod
	Checksum: 0xAB03CD2B
	Offset: 0xA828
	Size: 0x146
	Parameters: 1
	Flags: Linked
*/
function function_59804866(n_round)
{
	if(n_round < 2)
	{
		return 3;
	}
	if(n_round < 5)
	{
		return 2;
	}
	if(n_round > 60)
	{
		n_round = 60;
	}
	n_multiplier = 0.95;
	switch(level.players.size)
	{
		case 1:
		{
			n_delay = 2;
			break;
		}
		case 2:
		{
			n_delay = 1.5;
			break;
		}
		case 3:
		{
			n_delay = 0.89;
			break;
		}
		case 4:
		{
			n_delay = 0.67;
			break;
		}
	}
	for(i = 1; i < n_round; i++)
	{
		n_delay = n_delay * n_multiplier;
		if(n_delay <= 0.1)
		{
			n_delay = 0.1;
			break;
		}
	}
	return n_delay;
}

/*
	Name: function_5ee4c46c
	Namespace: zm_zod
	Checksum: 0x474AAABF
	Offset: 0xA978
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function function_5ee4c46c()
{
	if(level.round_number < 4)
	{
		level.zombie_move_speed = 1;
	}
	return level.zombie_vars["zombie_between_round_time"];
}

/*
	Name: function_b05d27ad
	Namespace: zm_zod
	Checksum: 0xFF54F15A
	Offset: 0xA9B0
	Size: 0x304
	Parameters: 0
	Flags: Linked
*/
function function_b05d27ad()
{
	if(!isdefined(level.var_5b9dbdff))
	{
		level.var_5b9dbdff = [];
		level.var_a7c80058 = [];
		foreach(e_spawner in level.zombie_spawners)
		{
			if(isdefined(e_spawner.script_string) && e_spawner.script_string == "male")
			{
				if(!isdefined(level.var_5b9dbdff))
				{
					level.var_5b9dbdff = [];
				}
				else if(!isarray(level.var_5b9dbdff))
				{
					level.var_5b9dbdff = array(level.var_5b9dbdff);
				}
				level.var_5b9dbdff[level.var_5b9dbdff.size] = e_spawner;
				continue;
			}
			if(isdefined(e_spawner.script_string) && e_spawner.script_string == "female")
			{
				if(!isdefined(level.var_a7c80058))
				{
					level.var_a7c80058 = [];
				}
				else if(!isarray(level.var_a7c80058))
				{
					level.var_a7c80058 = array(level.var_a7c80058);
				}
				level.var_a7c80058[level.var_a7c80058.size] = e_spawner;
			}
		}
		level.var_6b31b4b8 = 0;
		level.var_831a7edf = 0;
	}
	if(level.var_6b31b4b8 >= 1)
	{
		sp_zombie = array::random(level.var_a7c80058);
		level.var_6b31b4b8 = 0;
		level.var_831a7edf = 1;
	}
	else
	{
		if(level.var_831a7edf >= 1)
		{
			sp_zombie = array::random(level.var_5b9dbdff);
			level.var_6b31b4b8 = 1;
			level.var_831a7edf = 0;
		}
		else
		{
			var_7970b66c = randomint(1000);
			if(var_7970b66c <= 600)
			{
				sp_zombie = array::random(level.var_5b9dbdff);
				level.var_6b31b4b8++;
			}
			else
			{
				sp_zombie = array::random(level.var_a7c80058);
				level.var_831a7edf++;
			}
		}
	}
	return sp_zombie;
}

/*
	Name: function_eda7de97
	Namespace: zm_zod
	Checksum: 0xDE4B8816
	Offset: 0xACC0
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function function_eda7de97()
{
	a_players = getplayers();
	if(!isdefined(level.var_c4acfdc0))
	{
		level.var_c4acfdc0 = randomint(a_players.size);
	}
	level.var_c4acfdc0++;
	if(level.var_c4acfdc0 >= a_players.size)
	{
		level.var_c4acfdc0 = 0;
	}
	return a_players[level.var_c4acfdc0];
}

/*
	Name: function_631e737d
	Namespace: zm_zod
	Checksum: 0x909B0A0
	Offset: 0xAD48
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_631e737d()
{
	level waittill(#"raps_round_ending");
	level.zm_mixed_wasp_raps_spawning = &function_243d0df6;
	level.zm_ai_round_over = &function_68990a1c;
}

/*
	Name: function_243d0df6
	Namespace: zm_zod
	Checksum: 0xA4D0DE39
	Offset: 0xAD90
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_243d0df6()
{
	zm_ai_wasp::spawn_wasp();
	util::wait_network_frame();
	wait(2);
	if(level.zombie_total > 0)
	{
		zm_ai_raps::spawn_raps();
		util::wait_network_frame();
		wait(2);
	}
	if(level.zombie_total > 0)
	{
		if(randomint(100) >= 50)
		{
			zm_ai_wasp::spawn_wasp();
		}
	}
}

/*
	Name: function_68990a1c
	Namespace: zm_zod
	Checksum: 0x8E97107A
	Offset: 0xAE40
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function function_68990a1c()
{
	if(level.zombie_total)
	{
		return false;
	}
	if(zm_ai_raps::get_current_raps_count())
	{
		return false;
	}
	if(zm_ai_wasp::get_current_wasp_count())
	{
		return false;
	}
	return true;
}

/*
	Name: zm_override_ai_aftermath_powerup_drop
	Namespace: zm_zod
	Checksum: 0x70423997
	Offset: 0xAE90
	Size: 0x144
	Parameters: 2
	Flags: Linked
*/
function zm_override_ai_aftermath_powerup_drop(e_enemy, v_pos)
{
	if(isdefined(e_enemy) && isdefined(e_enemy.archetype) && e_enemy.archetype == "parasite")
	{
		e_ent = e_enemy.favoriteenemy;
		if(!isdefined(e_ent))
		{
			e_ent = array::random(level.players);
		}
		e_ent zm_ai_wasp::parasite_drop_item(v_pos);
	}
	else
	{
		power_up_origin = v_pos;
		trace = groundtrace(power_up_origin + vectorscale((0, 0, 1), 100), power_up_origin + (vectorscale((0, 0, -1), 1000)), 0, undefined);
		power_up_origin = trace["position"];
		if(isdefined(power_up_origin))
		{
			level thread zm_powerups::specific_powerup_drop("full_ammo", power_up_origin);
		}
	}
}

/*
	Name: function_afdf4111
	Namespace: zm_zod
	Checksum: 0x9898CF6
	Offset: 0xAFE0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_afdf4111()
{
	if(isdefined(self.var_abe77dc0) && self.var_abe77dc0)
	{
		self clientfield::set_to_player("pod_sprayer_held", 1);
	}
	else
	{
		self clientfield::set_to_player("pod_sprayer_held", 0);
	}
}

/*
	Name: function_2c092767
	Namespace: zm_zod
	Checksum: 0xFC566C3A
	Offset: 0xB048
	Size: 0x21C
	Parameters: 1
	Flags: Linked
*/
function function_2c092767(a_spots)
{
	if(level.zombie_respawns > 0)
	{
		if(!isdefined(level.n_player_spawn_selection_index))
		{
			level.n_player_spawn_selection_index = 0;
		}
		a_players = getplayers();
		level.n_player_spawn_selection_index++;
		if(level.n_player_spawn_selection_index >= a_players.size)
		{
			level.n_player_spawn_selection_index = 0;
		}
		e_player = a_players[level.n_player_spawn_selection_index];
		arraysortclosest(a_spots, e_player.origin);
		a_candidates = [];
		v_player_dir = anglestoforward(e_player.angles);
		for(i = 0; i < a_spots.size; i++)
		{
			v_dir = a_spots[i].origin - e_player.origin;
			dp = vectordot(v_player_dir, v_dir);
			if(dp >= 0)
			{
				a_candidates[a_candidates.size] = a_spots[i];
				if(a_candidates.size > 10)
				{
					break;
				}
			}
		}
		if(a_candidates.size)
		{
			s_spot = array::random(a_candidates);
		}
		else
		{
			s_spot = array::random(a_spots);
		}
	}
	else
	{
		s_spot = array::random(a_spots);
	}
	return s_spot;
}

/*
	Name: function_612012aa
	Namespace: zm_zod
	Checksum: 0x575F5F00
	Offset: 0xB270
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function function_612012aa()
{
	if(!isdefined(level.var_1300aaeb))
	{
		level.var_1300aaeb = level.next_wasp_round;
		if(level.n_next_raps_round > level.var_1300aaeb)
		{
			level.var_1300aaeb = level.n_next_raps_round;
		}
		level.var_1300aaeb = level.var_1300aaeb + 5;
	}
	else
	{
		level.var_1300aaeb = level.var_1300aaeb + randomintrange(5, 10);
	}
	return level.var_1300aaeb;
}

/*
	Name: function_48fda59a
	Namespace: zm_zod
	Checksum: 0x694B7BE2
	Offset: 0xB308
	Size: 0x158
	Parameters: 0
	Flags: Linked
*/
function function_48fda59a()
{
	var_6a6d5f3e = 0;
	n_start_time = undefined;
	while(true)
	{
		if(!var_6a6d5f3e && level.zombie_total <= 0)
		{
			var_565450eb = zombie_utility::get_current_zombie_count();
			if(var_565450eb == 1)
			{
				if(!isdefined(n_start_time))
				{
					n_start_time = gettime();
				}
				n_time = gettime();
				var_be13851f = (n_time - n_start_time) / 1000;
				if(var_be13851f >= 80)
				{
					a_zombies = getaiteamarray(level.zombie_team);
					if(a_zombies.size == 1)
					{
						a_zombies[0] zombie_utility::set_zombie_run_cycle("sprint");
						level waittill(#"between_round_over");
						level waittill(#"start_of_round");
						wait(10);
					}
				}
			}
			else
			{
				var_6a6d5f3e = 0;
				n_start_time = undefined;
			}
		}
		wait(1);
	}
}

/*
	Name: function_af2b349c
	Namespace: zm_zod
	Checksum: 0xC1548961
	Offset: 0xB468
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function function_af2b349c()
{
	/#
		var_1b913866 = self allowstand(1);
		self allowstand(var_1b913866);
		return var_1b913866;
	#/
}

/*
	Name: function_f7d81bd5
	Namespace: zm_zod
	Checksum: 0xBAA4A533
	Offset: 0xB4C8
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_f7d81bd5()
{
	self notify(#"hash_f7d81bd5");
	self endon(#"hash_f7d81bd5");
	self endon(#"disconnect");
	level endon(#"stop_suicide_trigger");
	e_volume = getent("into_disable_prone", "targetname");
	var_d8d76cd3 = 0;
	while(!(isdefined(level.intermission) && level.intermission))
	{
		if(self laststand::player_is_in_laststand())
		{
			self allowprone(1);
			var_d8d76cd3 = 0;
		}
		else if(!(isdefined(self.beastmode) && self.beastmode))
		{
			if(self istouching(e_volume))
			{
				if(!var_d8d76cd3)
				{
					/#
						if(!self function_af2b349c())
						{
							/#
								assertmsg("");
							#/
						}
					#/
					self allowprone(0);
					var_d8d76cd3 = 1;
				}
			}
			else if(var_d8d76cd3)
			{
				self allowprone(1);
				var_d8d76cd3 = 0;
			}
		}
		wait(0.25);
	}
	self allowprone(1);
}

/*
	Name: function_22eef972
	Namespace: zm_zod
	Checksum: 0x902ADC29
	Offset: 0xB678
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_22eef972()
{
	level flag::wait_till("all_players_connected");
	clientfield::set("hide_perf_static_models", 1);
}

/*
	Name: function_aab1d0bd
	Namespace: zm_zod
	Checksum: 0xBB921A3A
	Offset: 0xB6C8
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_aab1d0bd()
{
	while(true)
	{
		level waittill(#"start_of_round");
		if(level.round_number < 12)
		{
			setdvar("r_maxSpotShadowUpdates", "12");
		}
		else
		{
			setdvar("r_maxSpotShadowUpdates", "8");
		}
	}
}

/*
	Name: function_a988e9bb
	Namespace: zm_zod
	Checksum: 0x39F06226
	Offset: 0xB748
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_a988e9bb()
{
	level flag::wait_till("all_players_connected");
	array::thread_all(getplayers(), &player_noire_ee);
}

/*
	Name: player_noire_ee
	Namespace: zm_zod
	Checksum: 0x3C930B2
	Offset: 0xB7A8
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function player_noire_ee()
{
	self endon(#"disconnect");
	self endon(#"death");
	s_start = struct::get("s_noire_ee_start", "targetname");
	s_end = struct::get("s_noire_ee_end", "targetname");
	var_3acf33ec = 0;
	while(!var_3acf33ec)
	{
		if(self getstance() == "crouch")
		{
			if(self reloadbuttonpressed())
			{
				n_dist = distance(self.origin, s_start.origin);
				if(n_dist < 85)
				{
					v_forward = self getweaponforwarddir();
					v_dir = vectornormalize(s_end.origin - self.origin);
					dp = vectordot(v_forward, v_dir);
					if(dp > 0.975)
					{
						visionset_mgr::activate("visionset", "zombie_noire", self);
						var_3acf33ec = 1;
					}
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_89b7689f
	Namespace: zm_zod
	Checksum: 0x7BCEF856
	Offset: 0xB988
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function function_89b7689f()
{
	if(isdefined(self.altbody) && self.altbody)
	{
		return false;
	}
	return true;
}

/*
	Name: function_42cc727b
	Namespace: zm_zod
	Checksum: 0xC8D425E8
	Offset: 0xB9B8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_42cc727b()
{
	if(isdefined(self.train_board_time))
	{
		self.train_board_time = undefined;
	}
	var_4126c532 = self zm_zod_quest::function_b62ad2c();
	if(isdefined(var_4126c532))
	{
		array::add(var_4126c532.m_a_players_involved, self, 0);
		self.is_in_defend_area = 1;
	}
	else
	{
		self zm_zod_quest::function_15f1b929();
	}
}

/*
	Name: function_bef9943a
	Namespace: zm_zod
	Checksum: 0x8560E37F
	Offset: 0xBA50
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function function_bef9943a()
{
	level flag::wait_till("all_players_connected");
	exploder::exploder("fx_exploder_lightning_junction");
	wait(20);
	exploder::stop_exploder("fx_exploder_lightning_junction");
	while(level.round_number < 5)
	{
		n_round_number = level.round_number;
		while(zombie_utility::get_current_zombie_count() == 0)
		{
			wait(0.1);
		}
		while(true)
		{
			if(level.zombie_total == 0 && zombie_utility::get_current_zombie_count() <= 2)
			{
				break;
			}
			wait(0.1);
		}
		exploder::exploder("fx_exploder_lightning_junction");
		while(zombie_utility::get_current_zombie_count() > 0)
		{
			wait(0.1);
		}
		exploder::stop_exploder("fx_exploder_lightning_junction");
		while(level.round_number == n_round_number)
		{
			wait(0.1);
		}
	}
}

/*
	Name: function_f88e4c70
	Namespace: zm_zod
	Checksum: 0xC31B106A
	Offset: 0xBBC0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_f88e4c70()
{
	self thread function_35c958af();
}

/*
	Name: function_35c958af
	Namespace: zm_zod
	Checksum: 0xE0B4306B
	Offset: 0xBBE8
	Size: 0x19A
	Parameters: 0
	Flags: Linked
*/
function function_35c958af()
{
	self endon(#"death");
	var_f1af2991 = 0;
	while(true)
	{
		n_delay = randomfloatrange(0.9, 1.4);
		wait(n_delay);
		if(isdefined(level.bzm_worldpaused) && level.bzm_worldpaused)
		{
			continue;
		}
		v_trace_end = (self.origin[0], self.origin[1], self.origin[2] - 500);
		trace = groundtrace(self.origin, v_trace_end, 0, 0, 0, 0);
		var_ccacea03 = trace["position"] + vectorscale((0, 0, 1), 20);
		b_in_active_zone = zm_utility::check_point_in_enabled_zone(var_ccacea03, 1, level.active_zones);
		if(b_in_active_zone)
		{
			var_f1af2991 = 0;
		}
		else
		{
			var_f1af2991++;
			if(var_f1af2991 >= 5)
			{
				zm_ai_wasp::wasp_add_to_spawn_pool(self.enemy);
				self kill();
				return;
			}
		}
	}
}

/*
	Name: function_4df9f4ad
	Namespace: zm_zod
	Checksum: 0x7A1A751C
	Offset: 0xBD90
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_4df9f4ad()
{
	level endon(#"end_game");
	level notify(#"hash_a3369c1f");
	level endon(#"hash_a3369c1f");
	while(true)
	{
		level waittill(#"host_migration_end");
		setdvar("doublejump_enabled", 1);
		setdvar("playerEnergy_enabled", 1);
		setdvar("wallrun_enabled", 1);
	}
}

