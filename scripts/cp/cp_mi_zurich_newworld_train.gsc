// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_debug;
#using scripts\cp\_dialog;
#using scripts\cp\_hacking;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_zurich_newworld;
#using scripts\cp\cp_mi_zurich_newworld_accolades;
#using scripts\cp\cp_mi_zurich_newworld_sound;
#using scripts\cp\cp_mi_zurich_newworld_util;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;

#namespace newworld_train;

/*
	Name: skipto_white_infinite_igc_init
	Namespace: newworld_train
	Checksum: 0xC05D0137
	Offset: 0x2258
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function skipto_white_infinite_igc_init(str_objective, b_starting)
{
	load::function_73adcefc();
	battlechatter::function_d9f49fba(0);
	init_train_flags();
	function_de13d6e2();
	level thread namespace_e38c3c58::function_5a7ad30();
	white_infinite_igc();
	skipto::objective_completed(str_objective);
}

/*
	Name: white_infinite_igc
	Namespace: newworld_train
	Checksum: 0x2263FF45
	Offset: 0x2300
	Size: 0x2B4
	Parameters: 0
	Flags: Linked
*/
function white_infinite_igc()
{
	level scene::init("cin_new_01_01_whiteinfinite_1st_intro");
	level scene::init("p7_fxanim_cp_newworld_train_intro_glass_bundle");
	level thread function_19b91013();
	load::function_c32ba481(1);
	level thread newworld_util::function_30ec5bf7();
	level util::do_chyron_text(&"CP_MI_ZURICH_NEWWORLD_INTRO_LINE_1_FULL", "", &"CP_MI_ZURICH_NEWWORLD_INTRO_LINE_3_FULL", &"CP_MI_ZURICH_NEWWORLD_INTRO_LINE_3_SHORT", &"CP_MI_ZURICH_NEWWORLD_INTRO_LINE_4_FULL", &"CP_MI_ZURICH_NEWWORLD_INTRO_LINE_4_SHORT", &"CP_MI_ZURICH_NEWWORLD_INTRO_LINE_5_FULL", &"CP_MI_ZURICH_NEWWORLD_INTRO_LINE_5_SHORT", "", "");
	if(isdefined(level.bzm_newworlddialogue1callback))
	{
		level thread [[level.bzm_newworlddialogue1callback]]();
	}
	level scene::add_scene_func("p7_fxanim_cp_newworld_train_intro_glass_bundle", &function_f910c34a);
	level scene::add_scene_func("cin_new_01_01_whiteinfinite_1st_intro", &function_7b872728);
	level scene::add_scene_func("cin_new_01_01_whiteinfinite_1st_intro", &function_f8514554);
	level scene::add_player_linked_scene("p7_fxanim_cp_newworld_train_intro_glass_bundle");
	level thread scene::play("p7_fxanim_cp_newworld_train_intro_glass_bundle");
	level thread scene::play("cin_new_01_01_whiteinfinite_1st_intro");
	array::thread_all(level.activeplayers, &newworld_util::function_737d2864, &"CP_MI_ZURICH_NEWWORLD_LOCATION_TRAIN", &"CP_MI_ZURICH_NEWWORLD_TIME_TRAIN1");
	level thread function_6fe6a34d();
	level waittill(#"hash_a4a076ed");
	setpauseworld(0);
	level flag::set("train_terrain_resume");
	exploder::exploder_stop("ex_white_inf_light");
	level notify(#"white_infinite_igc_terminate");
	level util::clear_streamer_hint();
}

/*
	Name: function_f8514554
	Namespace: newworld_train
	Checksum: 0x2C80B84F
	Offset: 0x25C0
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function function_f8514554(a_ents)
{
	level waittill(#"hash_3c94a047");
	level flag::set("infinite_white_transition");
	wait(0.6);
	scene::stop("cin_new_01_01_whiteinfinite_1st_intro");
	a_ents["taylor"] delete();
	level notify(#"hash_a4a076ed");
}

/*
	Name: function_f910c34a
	Namespace: newworld_train
	Checksum: 0x1BD08EED
	Offset: 0x2650
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_f910c34a(a_ents)
{
	a_ents["newworld_train_intro_glass"] ghost();
	a_ents["newworld_train_intro_glass"] setignorepauseworld(1);
	level waittill(#"hash_e66d6ef4");
	a_ents["newworld_train_intro_glass"] show();
}

/*
	Name: function_7b872728
	Namespace: newworld_train
	Checksum: 0x9EAB2692
	Offset: 0x26E0
	Size: 0x20C
	Parameters: 1
	Flags: Linked
*/
function function_7b872728(a_ents)
{
	a_ents["taylor"] setignorepauseworld(1);
	a_ents["whiteinfinite_civ_02"] setignorepauseworld(1);
	a_ents["whiteinfinite_civ_03"] setignorepauseworld(1);
	a_ents["whiteinfinite_civ_04"] setignorepauseworld(1);
	a_ents["whiteinfinite_civ_05"] setignorepauseworld(1);
	a_ents["whiteinfinite_civ_06"] setignorepauseworld(1);
	a_ents["whiteinfinite_civ_07"] setignorepauseworld(1);
	a_ents["player 1"] thread function_3edfb24f();
	level thread function_b7ef38e9();
	a_ents["train_car"] thread function_63d2d91e();
	level thread function_bb60f445(a_ents);
	a_ents["player 1"] waittill(#"freeze");
	if(!scene::is_skipping_in_progress())
	{
		setpauseworld(1);
		level flag::set("train_terrain_pause");
		level thread function_7d334045();
	}
}

/*
	Name: function_63d2d91e
	Namespace: newworld_train
	Checksum: 0xBDA87F7E
	Offset: 0x28F8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_63d2d91e()
{
	self clientfield::set("train_fx_occlude", 1);
	var_bf143437 = getentarray("probe_inf_white_igc", "script_noteworthy");
	foreach(var_7aa19f58 in var_bf143437)
	{
		var_7aa19f58 linkto(self);
	}
	self waittill(#"hash_999f40e4");
	self hidepart("tag_glass");
	self clientfield::set("train_fx_occlude", 0);
}

/*
	Name: function_bb60f445
	Namespace: newworld_train
	Checksum: 0x889D6B12
	Offset: 0x2A28
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function function_bb60f445(a_ents)
{
	level waittill(#"hash_3886176e");
	var_6d4af883 = a_ents["whiteinfinite_civ_07"];
	if(isdefined(var_6d4af883))
	{
		var_6d4af883 clientfield::set("derez_ai_deaths", 1);
	}
	util::wait_network_frame();
	if(isdefined(var_6d4af883))
	{
		var_6d4af883 ghost();
	}
}

/*
	Name: function_3edfb24f
	Namespace: newworld_train
	Checksum: 0xA65B038E
	Offset: 0x2AC0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_3edfb24f()
{
	level waittill(#"hash_9a0a9e67");
	function_c4addffd();
}

/*
	Name: function_b7ef38e9
	Namespace: newworld_train
	Checksum: 0xA0A4FE6F
	Offset: 0x2AF0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_b7ef38e9()
{
	level waittill(#"hash_b8f30df1");
	exploder::exploder("ex_white_inf_light");
}

/*
	Name: skipto_white_infinite_igc_done
	Namespace: newworld_train
	Checksum: 0x9E82F523
	Offset: 0x2B28
	Size: 0x74
	Parameters: 4
	Flags: Linked
*/
function skipto_white_infinite_igc_done(str_objective, b_starting, b_direct, player)
{
	function_de13d6e2(1);
	wait(3);
	newworld_util::scene_cleanup("cin_new_01_01_whiteinfinite_1st_intro");
	newworld_util::scene_cleanup("p7_fxanim_cp_newworld_train_intro_glass_bundle");
}

/*
	Name: skipto_inbound_igc_init
	Namespace: newworld_train
	Checksum: 0x35A68970
	Offset: 0x2BA8
	Size: 0x274
	Parameters: 2
	Flags: Linked
*/
function skipto_inbound_igc_init(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		train_civilians(str_objective);
		load::function_a2995f22();
		level thread newworld_util::function_30ec5bf7(1);
	}
	else
	{
		foreach(player in level.players)
		{
			player newworld_util::on_player_loadout();
		}
	}
	level clientfield::set("train_main_fx_occlude", 1);
	battlechatter::function_d9f49fba(0);
	level util::set_lighting_state(1);
	level clientfield::set("set_fog_bank", 1);
	level thread init_train_flags();
	level thread function_57409da3();
	level thread train_brake_flaps_init();
	level thread function_75fc9f6a();
	train_spawn_functions();
	setup_robot_spawn_scenes();
	level thread function_704b33db();
	skipto::teleport(str_objective);
	level thread namespace_e38c3c58::function_57a2519c();
	inbound_igc();
	util::teleport_players_igc("inbound_igc_teleport");
	skipto::objective_completed(str_objective);
}

/*
	Name: inbound_igc
	Namespace: newworld_train
	Checksum: 0xD68321F0
	Offset: 0x2E28
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function inbound_igc()
{
	level scene::init("cin_new_14_01_inbound_1st_preptalk");
	util::set_streamer_hint(8);
	newworld_util::function_83a7d040();
	util::streamer_wait();
	newworld_util::player_snow_fx();
	scene::add_scene_func("cin_new_14_01_inbound_1st_preptalk", &taylor_inbound_igc, "play");
	scene::add_scene_func("cin_new_14_01_inbound_1st_preptalk", &function_985304c3, "play");
	if(isdefined(level.bzm_newworlddialogue10callback))
	{
		level thread [[level.bzm_newworlddialogue10callback]]();
	}
	level thread function_64f742f7();
	scene::play("cin_new_14_01_inbound_1st_preptalk");
	util::clear_streamer_hint();
}

/*
	Name: function_985304c3
	Namespace: newworld_train
	Checksum: 0x2EA32377
	Offset: 0x2F58
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_985304c3(a_ents)
{
	level flag::clear("infinite_white_transition");
	array::thread_all(level.activeplayers, &newworld_util::function_737d2864, &"CP_MI_ZURICH_NEWWORLD_LOCATION_TRAIN", &"CP_MI_ZURICH_NEWWORLD_TIME_TRAIN2");
}

/*
	Name: taylor_inbound_igc
	Namespace: newworld_train
	Checksum: 0x6BFE364C
	Offset: 0x2FC8
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function taylor_inbound_igc(a_ents)
{
	ai_taylor = a_ents["taylor"];
	ai_taylor ghost();
	level waittill(#"rez_taylor");
	ai_taylor thread newworld_util::function_c949a8ed(1);
	level waittill(#"derez_taylor");
	ai_taylor thread newworld_util::function_4943984c(1);
}

/*
	Name: function_64f742f7
	Namespace: newworld_train
	Checksum: 0x4972E104
	Offset: 0x3060
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_64f742f7()
{
	level clientfield::set("inbound_igc_glass", 1);
	level waittill(#"hash_64f742f7");
	level clientfield::set("inbound_igc_glass", 2);
	level util::set_lighting_state(0);
	level clientfield::set("set_fog_bank", 0);
}

/*
	Name: function_6ce77882
	Namespace: newworld_train
	Checksum: 0x1F3C442
	Offset: 0x30F8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_6ce77882()
{
	level clientfield::set("inbound_igc_glass", 2);
}

/*
	Name: skipto_inbound_igc_done
	Namespace: newworld_train
	Checksum: 0x72E81172
	Offset: 0x3128
	Size: 0x24
	Parameters: 4
	Flags: Linked
*/
function skipto_inbound_igc_done(str_objective, b_starting, b_direct, player)
{
}

/*
	Name: skipto_train_init
	Namespace: newworld_train
	Checksum: 0x815AA661
	Offset: 0x3158
	Size: 0x344
	Parameters: 2
	Flags: Linked
*/
function skipto_train_init(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		train_spawn_functions();
		setup_robot_spawn_scenes();
		function_6ce77882();
		init_train_flags();
		train_civilians(str_objective);
		function_704b33db();
		level thread function_75fc9f6a();
		level thread function_57409da3();
		load::function_a2995f22();
		level clientfield::set("train_main_fx_occlude", 1);
	}
	if(sessionmodeiscampaignzombiesgame())
	{
		a_e_clip = getentarray("train_stairs_carver_zm", "targetname");
		foreach(e_clip in a_e_clip)
		{
			e_clip delete();
		}
	}
	util::delay(0.6, undefined, &newworld_util::function_3e37f48b, 0);
	util::delay(1, undefined, &function_1a874d86);
	level thread namespace_e38c3c58::function_c132cd41();
	level thread train_brake_flaps_init();
	battlechatter::function_d9f49fba(1);
	level util::set_lighting_state(0);
	level clientfield::set("set_fog_bank", 0);
	function_c63fb1d();
	level thread function_8c0c3c47();
	level thread namespace_e38c3c58::function_a99be221();
	level thread namespace_37a1dc33::function_8bb97e0();
	level thread function_8b44d21a();
	function_b9045c8a();
	function_9301e221();
	function_6cff67b8();
	function_7710c097();
	function_510e462e();
}

/*
	Name: function_1a874d86
	Namespace: newworld_train
	Checksum: 0x60EAAD9B
	Offset: 0x34A8
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_1a874d86()
{
	foreach(e_player in level.activeplayers)
	{
		if(isdefined(e_player.cybercom.var_7116dac7))
		{
			e_player giveweapon(e_player.cybercom.var_7116dac7);
			e_player.cybercom.activecybercommeleeweapon = e_player.cybercom.var_7116dac7;
			e_player.cybercom.var_7116dac7 = undefined;
		}
	}
}

/*
	Name: skipto_train_done
	Namespace: newworld_train
	Checksum: 0xED7CAB91
	Offset: 0x35B0
	Size: 0x24
	Parameters: 4
	Flags: Linked
*/
function skipto_train_done(str_objective, b_starting, b_direct, player)
{
}

/*
	Name: init_train_flags
	Namespace: newworld_train
	Checksum: 0x1A2A3D0C
	Offset: 0x35E0
	Size: 0x244
	Parameters: 0
	Flags: Linked
*/
function init_train_flags()
{
	if(!level flag::exists("train_terrain_pause"))
	{
		level flag::init("train_terrain_pause");
	}
	if(!level flag::exists("train_terrain_resume"))
	{
		level flag::init("train_terrain_resume");
	}
	if(!level flag::exists("train_terrain_transition"))
	{
		level flag::init("train_terrain_transition");
	}
	if(!level flag::exists("train_terrain_move_complete"))
	{
		level flag::init("train_terrain_move_complete");
	}
	if(!level flag::exists("switch_to_forest"))
	{
		level flag::init("switch_to_forest");
	}
	if(!level flag::exists("player_on_top_of_train"))
	{
		level flag::init("player_on_top_of_train");
	}
	if(!level flag::exists("concussive_wave_tutorial_started"))
	{
		level flag::init("concussive_wave_tutorial_started");
	}
	if(!level flag::exists("climb_up_spawns_complete"))
	{
		level flag::init("climb_up_spawns_complete");
	}
	if(!level flag::exists("climb_up_robots_cleared"))
	{
		level flag::init("climb_up_robots_cleared");
	}
}

/*
	Name: function_8b44d21a
	Namespace: newworld_train
	Checksum: 0x93B6655
	Offset: 0x3830
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function function_8b44d21a()
{
	var_31f0b803 = getentarray("train_neon_glass_destructible_1", "script_noteworthy");
	var_6a5caae4 = struct::get("front_of_the_train", "targetname");
	var_31f0b803 = arraysort(var_31f0b803, var_6a5caae4.origin, 1);
	for(i = 0; i < var_31f0b803.size; i++)
	{
		var_31f0b803[i] thread function_f889869b(i + 1);
	}
}

/*
	Name: function_f889869b
	Namespace: newworld_train
	Checksum: 0xD0515C95
	Offset: 0x3910
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_f889869b(n_index)
{
	self waittill(#"broken");
	exploder::exploder("ex_purple_glass_light_0" + n_index);
}

/*
	Name: function_b9045c8a
	Namespace: newworld_train
	Checksum: 0x72C92CDA
	Offset: 0x3958
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_b9045c8a()
{
	level thread function_3641dc88();
}

/*
	Name: function_9301e221
	Namespace: newworld_train
	Checksum: 0xCA845F7B
	Offset: 0x3980
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_9301e221()
{
	level thread function_7f06890d();
	trigger::wait_till("train_car_2_robot_spawn");
	s_scene = struct::get("train_car_2_robot_charger", "targetname");
	s_scene thread scene::play();
}

/*
	Name: function_6cff67b8
	Namespace: newworld_train
	Checksum: 0x2F66DC99
	Offset: 0x3A00
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_6cff67b8()
{
	level clientfield::set("train_robot_swing_glass_left", 1);
	level clientfield::set("train_robot_swing_glass_right", 1);
	trigger::wait_till("robots_swing_in");
	level thread function_6114e822();
}

/*
	Name: function_7710c097
	Namespace: newworld_train
	Checksum: 0x6D875692
	Offset: 0x3A80
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function function_7710c097()
{
	level clientfield::set("train_dropdown_glass", 1);
	scene::add_scene_func("cin_new_16_01_detachbombcar_aie_drop", &function_d6c3792a, "init");
	level thread scene::init("cin_new_16_01_detachbombcar_aie_drop");
	trigger::wait_till("train_car_4_robot_spawns");
	level thread function_6a30b44c();
	trigger::wait_till("train_car_4_robots_drop_through_glass");
	if(level.activeplayers.size > 1)
	{
		ai_robot = spawner::simple_spawn_single("train_car_4_secondstory");
		ai_robot thread function_c19bd331();
	}
	scene::add_scene_func("cin_new_16_01_detachbombcar_aie_drop", &function_613f8b51, "play");
	level thread scene::play("cin_new_16_01_detachbombcar_aie_drop");
	level waittill(#"hash_60e2e11");
	level clientfield::set("train_dropdown_glass", 2);
	level thread function_ce0fcc59();
}

/*
	Name: function_c19bd331
	Namespace: newworld_train
	Checksum: 0xFBB2419F
	Offset: 0x3C28
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_c19bd331()
{
	self endon(#"death");
	self util::waittill_any("goal", "near_goal");
	self ai::set_behavior_attribute("move_mode", "rusher");
	self ai::set_behavior_attribute("sprint", 1);
}

/*
	Name: function_d6c3792a
	Namespace: newworld_train
	Checksum: 0x711FDE3F
	Offset: 0x3CB0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_d6c3792a(a_ents)
{
	a_ents["robot_second_floor_drop"] util::magic_bullet_shield();
}

/*
	Name: function_613f8b51
	Namespace: newworld_train
	Checksum: 0xDC91F5
	Offset: 0x3CE8
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function function_613f8b51(a_ents)
{
	level waittill(#"hash_613f8b51");
	var_31f0b803 = getentarray("train_neon_glass_destructible_1", "script_noteworthy");
	var_31f0b803 = arraysort(var_31f0b803, a_ents["robot_second_floor_drop"].origin, 1);
	if(isdefined(var_31f0b803[0]))
	{
		var_31f0b803[0] dodamage(100, var_31f0b803[0].origin);
	}
	a_ents["robot_second_floor_drop"] util::stop_magic_bullet_shield();
}

/*
	Name: function_510e462e
	Namespace: newworld_train
	Checksum: 0x116F9F12
	Offset: 0x3DD0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_510e462e()
{
	level thread train_lockdown();
}

/*
	Name: function_7f06890d
	Namespace: newworld_train
	Checksum: 0x53E08A23
	Offset: 0x3DF8
	Size: 0xFA
	Parameters: 0
	Flags: Linked
*/
function function_7f06890d()
{
	trigger::wait_till("train_tutorial_takedown");
	level thread function_11711684("cybercom_rapidstrike", 0);
	foreach(player in level.players)
	{
		if(player newworld_util::function_c633d8fe())
		{
			continue;
		}
		player thread newworld_util::function_6062e90("cybercom_rapidstrike", 0, "concsusive_wave_tutorial", 1, "CP_MI_ZURICH_NEWWORLD_TAKEDOWN");
	}
}

/*
	Name: function_6a30b44c
	Namespace: newworld_train
	Checksum: 0x933953B7
	Offset: 0x3F00
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function function_6a30b44c()
{
	var_7da8df42 = struct::get_array("train_car_4_charging_stations", "targetname");
	foreach(s_scene in var_7da8df42)
	{
		s_scene thread scene::play();
		wait(randomfloatrange(0.25, 0.75));
	}
}

/*
	Name: function_ce0fcc59
	Namespace: newworld_train
	Checksum: 0xCA76B743
	Offset: 0x3FE0
	Size: 0x10A
	Parameters: 0
	Flags: Linked
*/
function function_ce0fcc59()
{
	level thread function_f3519ceb();
	level flag::wait_till("spawn_train_car4_rear_chargingstation_robots");
	var_7da8df42 = struct::get_array("train_car_4_rear_charging_stations", "targetname");
	foreach(s_scene in var_7da8df42)
	{
		s_scene thread scene::play();
		wait(randomfloatrange(0.25, 0.75));
	}
}

/*
	Name: function_f3519ceb
	Namespace: newworld_train
	Checksum: 0x7EB0FE96
	Offset: 0x40F8
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function function_f3519ceb()
{
	level endon(#"hash_f4e446c7");
	a_ai_robots = [];
	a_ai = getaiteamarray("axis");
	foreach(ai in a_ai)
	{
		if(ai.script_string === "train_car_4_robots_front" && isalive(ai))
		{
			a_ai_robots[a_ai_robots.size] = ai;
		}
	}
	if(a_ai_robots.size > 0)
	{
		ai::waittill_dead(a_ai_robots);
		level flag::set("spawn_train_car4_rear_chargingstation_robots");
	}
}

/*
	Name: setup_robot_spawn_scenes
	Namespace: newworld_train
	Checksum: 0x346B4C4D
	Offset: 0x4240
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function setup_robot_spawn_scenes()
{
	scene::add_scene_func("p7_fxanim_cp_newworld_charging_station_open_01_bundle", &function_1d0cebf2, "init");
	scene::add_scene_func("p7_fxanim_cp_newworld_charging_station_open_01_bundle", &charging_station_open, "done");
	scene::add_scene_func("cin_new_scr_temp_robot_fwd", &init_train_wakeup_robot, "init");
	scene::add_scene_func("cin_new_scr_temp_robot_fwd", &play_train_wakeup_robot, "play");
	scene::add_scene_func("cin_new_scr_temp_robot_fwd", &done_train_wakeup_robot, "done");
}

/*
	Name: function_1d0cebf2
	Namespace: newworld_train
	Checksum: 0x6002A24E
	Offset: 0x4340
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function function_1d0cebf2(a_ents)
{
	if(isdefined(self.target))
	{
		if(self.script_noteworthy === "last_car_robot_chargers")
		{
			s_scene = struct::get(self.target, "targetname");
			ai_robot = spawner::simple_spawn_single("last_train_car_robot");
			s_scene scene::init(ai_robot);
		}
		else
		{
			s_scene = struct::get(self.target, "targetname");
			s_scene scene::init();
		}
	}
}

/*
	Name: charging_station_open
	Namespace: newworld_train
	Checksum: 0x121796E
	Offset: 0x4428
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function charging_station_open(a_ents)
{
	if(isdefined(self.target))
	{
		s_scene = struct::get(self.target, "targetname");
		s_scene scene::play();
	}
}

/*
	Name: init_train_wakeup_robot
	Namespace: newworld_train
	Checksum: 0x580EFC3E
	Offset: 0x4490
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function init_train_wakeup_robot(a_ents)
{
	a_ents["train_wakeup_robot"] util::magic_bullet_shield();
}

/*
	Name: play_train_wakeup_robot
	Namespace: newworld_train
	Checksum: 0x177F5D4B
	Offset: 0x44C8
	Size: 0xD0
	Parameters: 1
	Flags: Linked
*/
function play_train_wakeup_robot(a_ents)
{
	a_ents["train_wakeup_robot"] util::stop_magic_bullet_shield();
	if(self.script_noteworthy === "rusher")
	{
		a_ents["train_wakeup_robot"] ai::set_behavior_attribute("move_mode", "rusher");
		a_ents["train_wakeup_robot"] ai::set_behavior_attribute("sprint", 1);
	}
	if(isdefined(self.script_string))
	{
		a_ents["train_wakeup_robot"].script_string = self.script_string;
	}
}

/*
	Name: done_train_wakeup_robot
	Namespace: newworld_train
	Checksum: 0xFE7F505C
	Offset: 0x45A0
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function done_train_wakeup_robot(a_ents)
{
	if(isdefined(self.target))
	{
		e_goalvolume = getent(self.target, "targetname");
		if(!isdefined(e_goalvolume))
		{
			nd_target = getnode(self.target, "targetname");
			a_ents["train_wakeup_robot"] setgoal(nd_target, 1);
			return;
		}
		a_ents["train_wakeup_robot"] setgoal(e_goalvolume, 1);
	}
}

/*
	Name: function_704b33db
	Namespace: newworld_train
	Checksum: 0xEA0A09AF
	Offset: 0x4680
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function function_704b33db()
{
	a_s_scenes = struct::get_array("main_train_robot_chargers", "script_noteworthy");
	foreach(s_scene in a_s_scenes)
	{
		s_scene scene::init();
	}
}

/*
	Name: function_5e667e1f
	Namespace: newworld_train
	Checksum: 0xBDC6A287
	Offset: 0x4740
	Size: 0x24C
	Parameters: 0
	Flags: Linked
*/
function function_5e667e1f()
{
	scene::add_scene_func("cin_gen_traversal_robot_climb_train_right", &function_b30301a7, "done");
	scene::add_scene_func("cin_gen_traversal_robot_climb_train_left", &function_b30301a7, "done");
	switch(level.activeplayers.size)
	{
		case 1:
		case 2:
		{
			n_count = 2;
			break;
		}
		case 3:
		{
			n_count = 3;
			break;
		}
		case 4:
		{
			n_count = 4;
			break;
		}
		default:
		{
			n_count = 0;
			break;
		}
	}
	for(i = 1; i < (n_count + 1); i++)
	{
		ai_robot = spawner::simple_spawn_single("climb_up_robot");
		s_scene = struct::get("train_roof1_climb_up_0" + i, "targetname");
		s_scene thread scene::init(ai_robot);
	}
	level flag::wait_till("train_rooftop_roof1_climb_up_spawns");
	level thread function_f7302a65();
	for(i = 1; i < (n_count + 1); i++)
	{
		s_scene = struct::get("train_roof1_climb_up_0" + i, "targetname");
		s_scene thread scene::play();
		wait(0.1);
	}
	level flag::set("climb_up_spawns_complete");
}

/*
	Name: function_b30301a7
	Namespace: newworld_train
	Checksum: 0x65A46260
	Offset: 0x4998
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function function_b30301a7(a_ents)
{
	wait(0.05);
	if(isalive(a_ents[0]) && a_ents[0].script_noteworthy === "train_robot_rushers")
	{
		a_ents[0] ai::set_behavior_attribute("move_mode", "rusher");
		a_ents[0] ai::set_behavior_attribute("sprint", 1);
		if(self.script_noteworthy === "train_rooftop_depth")
		{
			a_ents[0] thread function_ca6ecfb3();
		}
	}
}

/*
	Name: function_382c53b4
	Namespace: newworld_train
	Checksum: 0x4BB20193
	Offset: 0x4A70
	Size: 0x21A
	Parameters: 0
	Flags: Linked
*/
function function_382c53b4()
{
	trigger::wait_till("train_concussive_wave_tutorial");
	spawn_manager::enable("concussive_wave_tutorial_sm");
	level flag::set("concussive_wave_tutorial_started");
	level notify(#"hash_c02bc824");
	level.var_fbc6080 = 1;
	newworld_util::function_3e37f48b(1);
	if(!sessionmodeiscampaignzombiesgame())
	{
		foreach(player in level.players)
		{
			if(player newworld_util::function_c633d8fe())
			{
				continue;
			}
			player flag::init("concussive_wave_show_use_ability_tutorial");
			player flag::init("concussive_wave_tutorial_vo_complete");
			player thread function_9f8dbaa2("cybercom_concussive", 1);
			player cybercom_gadget::giveability("cybercom_concussive", 1);
			player.cybercom.given_first_ability = 0;
			player thread newworld_util::function_948d4091("cybercom_concussive", 1, "begin_skipto_detach_bomb_igc_init", 1, "CP_MI_ZURICH_NEWWORLD_CONCUSSIVE_WAVE_TUTORIAL", "concussive_wave_show_use_ability_tutorial", "concussive_wave_tutorial_vo_complete");
			player thread function_54bd9482();
		}
	}
}

/*
	Name: function_54bd9482
	Namespace: newworld_train
	Checksum: 0x60C75D63
	Offset: 0x4C98
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_54bd9482()
{
	self endon(#"death");
	trigger::wait_till("concussive_wave_use_ability_tutorial", "targetname", self);
	self flag::set("concussive_wave_show_use_ability_tutorial");
}

/*
	Name: train_civilians
	Namespace: newworld_train
	Checksum: 0x6EFD1690
	Offset: 0x4CF8
	Size: 0x70A
	Parameters: 1
	Flags: Linked
*/
function train_civilians(str_objective)
{
	scene::add_scene_func("cin_new_15_01_train_vign_drinks", &train_civilian_logic, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_drinks", &function_ffaa48a3, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_passengercar_male01", &train_civilian_logic, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_passengercar_male01", &function_ffaa48a3, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_passengercar_male01_table", &train_civilian_logic, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_passengercar_male01_table", &function_ffaa48a3, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_passengercar_male02", &train_civilian_logic, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_passengercar_male02", &function_ffaa48a3, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_passengercar_female01", &train_civilian_logic, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_passengercar_female01", &function_ffaa48a3, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_passengercar_female01_table", &train_civilian_logic, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_passengercar_female01_table", &function_ffaa48a3, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_passengercar_female02", &train_civilian_logic, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_passengercar_female02", &function_ffaa48a3, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_passengercar_female02_table", &train_civilian_logic, "play");
	scene::add_scene_func("cin_new_15_01_train_vign_passengercar_female02_table", &function_ffaa48a3, "play");
	if(str_objective === "train_inbound_igc" || str_objective === "train_train_start" || str_objective === "underground_staging_room_igc")
	{
		a_s_scenes = struct::get_array("train_civilians_car_1", "script_noteworthy");
		foreach(s_scene in a_s_scenes)
		{
			s_scene thread scene::play();
			wait(randomfloatrange(0, 0.25));
		}
		a_s_scenes = struct::get_array("train_civilians_car_2", "script_noteworthy");
		foreach(s_scene in a_s_scenes)
		{
			s_scene thread scene::play();
			wait(randomfloatrange(0, 0.25));
		}
		a_s_scenes = struct::get_array("train_civilians_car_3", "script_noteworthy");
		foreach(s_scene in a_s_scenes)
		{
			s_scene thread scene::play();
			wait(randomfloatrange(0, 0.25));
		}
		a_s_scenes = struct::get_array("train_civilians_car_4", "script_noteworthy");
		foreach(s_scene in a_s_scenes)
		{
			s_scene thread scene::play();
			wait(randomfloatrange(0, 0.25));
		}
	}
	a_s_scenes = struct::get_array("train_civilians_car_5", "script_noteworthy");
	foreach(s_scene in a_s_scenes)
	{
		s_scene thread scene::play();
		wait(randomfloatrange(0, 0.25));
	}
}

/*
	Name: train_civilian_logic
	Namespace: newworld_train
	Checksum: 0x3C628438
	Offset: 0x5410
	Size: 0x214
	Parameters: 1
	Flags: Linked
*/
function train_civilian_logic(a_ents)
{
	level endon(#"detach_bomb_igc_terminate");
	var_f11c18b5 = a_ents["train_civilian_model"];
	if(!isdefined(var_f11c18b5))
	{
		var_f11c18b5 = a_ents["train_civ_bartender_model"];
	}
	var_f11c18b5 endon(#"hash_bf294add");
	var_f11c18b5 setcandamage(1);
	var_f11c18b5.health = 100;
	var_f11c18b5.script_objective = "train_detach_bomb_igc";
	while(true)
	{
		var_f11c18b5 waittill(#"damage", n_damage, attacker);
		if(n_damage > 1)
		{
			break;
		}
	}
	if(isplayer(attacker))
	{
		attacker thread function_8e9219f();
	}
	if(!isdefined(var_f11c18b5))
	{
		return;
	}
	self scene::stop();
	wait(0.05);
	var_f11c18b5 startragdoll();
	if(isdefined(a_ents["prop"]))
	{
		a_ents["prop"] physicslaunch();
	}
	wait(0.1875);
	var_f11c18b5 notify(#"hash_ddb95805");
	var_f11c18b5 clientfield::set("derez_model_deaths", 1);
	util::wait_network_frame();
	wait(0.1);
	var_f11c18b5 delete();
	if(isdefined(a_ents["prop"]))
	{
		a_ents["prop"] delete();
	}
}

/*
	Name: function_ffaa48a3
	Namespace: newworld_train
	Checksum: 0xDD986CB4
	Offset: 0x5630
	Size: 0x194
	Parameters: 1
	Flags: Linked
*/
function function_ffaa48a3(a_ents)
{
	level endon(#"detach_bomb_igc_terminate");
	var_f11c18b5 = a_ents["train_civilian_model"];
	if(!isdefined(var_f11c18b5))
	{
		var_f11c18b5 = a_ents["train_civ_bartender_model"];
	}
	var_f11c18b5 endon(#"hash_ddb95805");
	while(isdefined(var_f11c18b5) && !var_f11c18b5 function_4a8e782e())
	{
		wait(0.1);
	}
	if(!isdefined(var_f11c18b5))
	{
		return;
	}
	self scene::stop();
	wait(0.05);
	var_f11c18b5 startragdoll();
	if(isdefined(a_ents["prop"]))
	{
		a_ents["prop"] physicslaunch();
	}
	wait(0.09375);
	var_f11c18b5 notify(#"hash_bf294add");
	var_f11c18b5 clientfield::set("derez_model_deaths", 1);
	util::wait_network_frame();
	wait(0.1);
	var_f11c18b5 delete();
	if(isdefined(a_ents["prop"]))
	{
		a_ents["prop"] delete();
	}
}

/*
	Name: function_4a8e782e
	Namespace: newworld_train
	Checksum: 0xF5D3B2C1
	Offset: 0x57D0
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_4a8e782e()
{
	level endon(#"detach_bomb_igc_terminate");
	self endon(#"hash_ddb95805");
	self endon(#"hash_bf294add");
	foreach(player in level.activeplayers)
	{
		if(self istouching(player))
		{
			return true;
		}
	}
	a_ai = getaiteamarray("axis");
	foreach(ai in a_ai)
	{
		if(self istouching(ai))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_6114e822
	Namespace: newworld_train
	Checksum: 0x267A6180
	Offset: 0x5950
	Size: 0x1DC
	Parameters: 0
	Flags: Linked
*/
function function_6114e822()
{
	level thread function_783ceb85();
	var_83b961d3 = struct::get("robot_swing_enter_left", "targetname");
	var_d2b65346 = struct::get("robot_swing_enter_right", "targetname");
	scene::add_scene_func("cin_new_15_02_train_aie_robot_swing_enter", &function_e1da9958, "play");
	scene::add_scene_func("cin_new_15_02_train_aie_robot_swing_enter", &function_5e60279a, "done");
	wait(0.5);
	var_83b961d3 thread scene::play();
	if(level.activeplayers.size > 2)
	{
		wait(0.25);
		var_4ed87bd0 = struct::get("robot_swing_enter_right2", "targetname");
		var_4ed87bd0 thread scene::play();
		wait(0.25);
		var_9c50e7ab = struct::get("robot_swing_enter_left2", "targetname");
		var_9c50e7ab thread scene::play();
	}
	wait(0.5);
	var_d2b65346 thread scene::play();
	level thread function_132d9bfb();
}

/*
	Name: function_e1da9958
	Namespace: newworld_train
	Checksum: 0x4A7AE4A2
	Offset: 0x5B38
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function function_e1da9958(a_ents)
{
	if(self.targetname == "robot_swing_enter_left")
	{
		str_clientfield = "train_robot_swing_glass_left";
	}
	else
	{
		if(self.targetname == "robot_swing_enter_right")
		{
			str_clientfield = "train_robot_swing_glass_right";
		}
		else
		{
			if(self.targetname == "robot_swing_enter_right2")
			{
				str_clientfield = "train_robot_swing_right_extra";
			}
			else if(self.targetname == "robot_swing_enter_left2")
			{
				str_clientfield = "train_robot_swing_left_extra";
			}
		}
	}
	a_ents["train_wakeup_robot"] waittill(#"hash_ea465de6");
	level clientfield::set(str_clientfield, 2);
}

/*
	Name: function_5e60279a
	Namespace: newworld_train
	Checksum: 0xAA712611
	Offset: 0x5C18
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_5e60279a(a_ents)
{
	wait(0.05);
	if(isdefined(self.target) && isalive(a_ents["train_wakeup_robot"]))
	{
		nd_goal = getnode(self.target, "targetname");
		a_ents["train_wakeup_robot"] ai::force_goal(nd_goal, 8);
	}
}

/*
	Name: function_132d9bfb
	Namespace: newworld_train
	Checksum: 0x84783ECE
	Offset: 0x5CC0
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function function_132d9bfb()
{
	wait(0.75);
	var_7da8df42 = struct::get_array("train_car_3_charging_stations", "targetname");
	foreach(s_scene in var_7da8df42)
	{
		s_scene thread scene::play();
		wait(randomfloatrange(0.25, 0.75));
	}
}

/*
	Name: train_lockdown
	Namespace: newworld_train
	Checksum: 0xD520E
	Offset: 0x5DA8
	Size: 0x26C
	Parameters: 0
	Flags: Linked
*/
function train_lockdown()
{
	level thread function_e7752aae();
	clientfield::set("train_lockdown_glass_left", 1);
	clientfield::set("train_lockdown_glass_right", 1);
	trigger::wait_till("train_lockdown", undefined, undefined, 0);
	exploder::exploder("ex_breakglass");
	clientfield::set("train_lockdown_shutters_1", 1);
	array::run_all(getentarray("train_lockdown_door", "targetname"), &movey, -64, 0.5);
	level thread start_sequential_train_door_lockdown();
	level thread function_123070a9();
	wait(1.5);
	scene::add_scene_func("cin_new_15_02_train_aie_smash", &function_b8f52cb2, "play");
	scene::add_scene_func("cin_new_15_02_train_aie_smash", &train_lockdown_glass_break_left, "play");
	scene::add_scene_func("cin_new_15_02_train_aie_smash", &train_lockdown_glass_break_right, "play");
	scene::add_scene_func("cin_new_15_02_train_aie_smash", &function_84631064, "done");
	level thread scene::play("cin_new_15_02_train_aie_smash");
	level waittill(#"train_lockdown_glass_break_right");
	array::run_all(getentarray("train_lockdown_glass", "targetname"), &delete);
}

/*
	Name: function_e7752aae
	Namespace: newworld_train
	Checksum: 0xDE4C412E
	Offset: 0x6020
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_e7752aae()
{
	scene::add_scene_func("cin_new_15_02_train_aie_smash", &function_f1aa562d, "init");
	trigger::wait_till("start_lockdown_robots");
	level thread scene::init("cin_new_15_02_train_aie_smash");
}

/*
	Name: function_f1aa562d
	Namespace: newworld_train
	Checksum: 0xA3403C82
	Offset: 0x6098
	Size: 0xA2
	Parameters: 1
	Flags: Linked
*/
function function_f1aa562d(a_ents)
{
	util::wait_network_frame();
	foreach(e_robot in a_ents)
	{
		e_robot util::magic_bullet_shield();
	}
}

/*
	Name: function_b8f52cb2
	Namespace: newworld_train
	Checksum: 0xE0274B6
	Offset: 0x6148
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_b8f52cb2(a_ents)
{
	level waittill(#"train_lockdown_glass_break_left");
	a_ents["lockdown_roof_robot_left"] util::stop_magic_bullet_shield();
	level waittill(#"train_lockdown_glass_break_right");
	a_ents["lockdown_roof_robot_right"] util::stop_magic_bullet_shield();
}

/*
	Name: train_lockdown_glass_break_left
	Namespace: newworld_train
	Checksum: 0x8F0BB5A7
	Offset: 0x61C0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function train_lockdown_glass_break_left(a_ents)
{
	level waittill(#"hash_1c281e62");
	level clientfield::set("train_lockdown_glass_left", 2);
}

/*
	Name: train_lockdown_glass_break_right
	Namespace: newworld_train
	Checksum: 0xBDA7ADA2
	Offset: 0x6208
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function train_lockdown_glass_break_right(a_ents)
{
	level waittill(#"hash_632087ff");
	level clientfield::set("train_lockdown_glass_right", 2);
}

/*
	Name: function_84631064
	Namespace: newworld_train
	Checksum: 0x3A252275
	Offset: 0x6250
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_84631064(a_ents)
{
	objectives::breadcrumb("train_rooftop_breadcrumb");
}

/*
	Name: start_sequential_train_door_lockdown
	Namespace: newworld_train
	Checksum: 0xED9F7061
	Offset: 0x6280
	Size: 0x7EC
	Parameters: 0
	Flags: Linked
*/
function start_sequential_train_door_lockdown()
{
	clientfield::set("train_lockdown_shutters_5", 1);
	e_trigger = getent("train_car_lockdown_04", "targetname");
	e_trigger wait_for_train_car_to_be_empty();
	var_5bcb8a4d = struct::get_array("train_civilians_car_1", "script_noteworthy");
	foreach(s_scene in var_5bcb8a4d)
	{
		if(s_scene scene::is_playing())
		{
			s_scene scene::stop(1);
		}
	}
	level clientfield::set("inbound_igc_glass", 0);
	clientfield::set("train_lockdown_shutters_4", 1);
	e_trigger = getent("train_car_lockdown_03", "targetname");
	e_trigger wait_for_train_car_to_be_empty();
	var_5bcb8a4d = struct::get_array("train_civilians_car_2", "script_noteworthy");
	foreach(s_scene in var_5bcb8a4d)
	{
		if(s_scene scene::is_playing())
		{
			s_scene scene::stop(1);
		}
	}
	var_809fd273 = struct::get("train_car_2_robot_charger", "targetname");
	var_809fd273 scene::stop(1);
	clientfield::set("train_lockdown_shutters_3", 1);
	e_trigger = getent("train_car_lockdown_02", "targetname");
	e_trigger wait_for_train_car_to_be_empty();
	var_5bcb8a4d = struct::get_array("train_civilians_car_3", "script_noteworthy");
	foreach(s_scene in var_5bcb8a4d)
	{
		if(s_scene scene::is_playing())
		{
			s_scene scene::stop(1);
		}
	}
	var_5bcb8a4d = struct::get_array("train_car_3_charging_stations", "targetname");
	foreach(s_scene in var_5bcb8a4d)
	{
		if(s_scene scene::is_playing())
		{
			s_scene scene::stop(1);
		}
	}
	level clientfield::set("train_robot_swing_glass_left", 0);
	level clientfield::set("train_robot_swing_glass_right", 0);
	clientfield::set("train_lockdown_shutters_2", 1);
	var_dee3d10a = getent("train_rooftop_regroup_zone", "targetname");
	var_dee3d10a.var_3367c99d = 1000;
	var_dee3d10a waittill(#"trigger");
	e_trigger = getent("train_car_lockdown_01", "targetname");
	e_trigger wait_for_train_car_to_be_empty();
	trigger::use("enable_car_0_respawns");
	var_5bcb8a4d = struct::get_array("train_civilians_car_4", "script_noteworthy");
	foreach(s_scene in var_5bcb8a4d)
	{
		if(s_scene scene::is_playing())
		{
			s_scene scene::stop(1);
		}
	}
	var_5bcb8a4d = struct::get_array("train_car_4_charging_stations", "targetname");
	foreach(s_scene in var_5bcb8a4d)
	{
		if(s_scene scene::is_playing())
		{
			s_scene scene::stop(1);
		}
	}
	var_5bcb8a4d = struct::get_array("train_car_4_rear_charging_stations", "targetname");
	foreach(s_scene in var_5bcb8a4d)
	{
		if(s_scene scene::is_playing())
		{
			s_scene scene::stop(1);
		}
	}
	level clientfield::set("train_dropdown_glass", 0);
}

/*
	Name: wait_for_train_car_to_be_empty
	Namespace: newworld_train
	Checksum: 0xBB5CBF1
	Offset: 0x6A78
	Size: 0x2A0
	Parameters: 0
	Flags: Linked
*/
function wait_for_train_car_to_be_empty()
{
	if(level flag::get(("train_car_" + self.script_int) + "_locked_down"))
	{
		return;
	}
	self notify(#"hash_ab87488c");
	self endon(#"hash_ab87488c");
	var_b2131754 = self.script_int + 1;
	if(level flag::exists(("train_car_" + var_b2131754) + "_locked_down"))
	{
		level flag::wait_till(("train_car_" + var_b2131754) + "_locked_down");
	}
	while(true)
	{
		b_empty_trigger = 1;
		foreach(player in level.players)
		{
			if(player istouching(self))
			{
				b_empty_trigger = 0;
				break;
			}
		}
		a_ai = getaiteamarray("axis", "allies");
		foreach(ai in a_ai)
		{
			if(ai istouching(self))
			{
				b_empty_trigger = 0;
				break;
			}
		}
		if(b_empty_trigger == 1)
		{
			level flag::set(("train_car_" + self.script_int) + "_locked_down");
			train_car_door_lock(self.script_int);
			break;
		}
		else
		{
			wait(0.1);
		}
	}
}

/*
	Name: train_car_door_lock
	Namespace: newworld_train
	Checksum: 0xF6179DB5
	Offset: 0x6D20
	Size: 0x1D4
	Parameters: 1
	Flags: Linked
*/
function train_car_door_lock(n_index)
{
	trigger::use(("disable_car_" + n_index) + "_respawns");
	var_265e12e8 = getent(("train_lockdown_door_0" + n_index) + "_l", "targetname");
	var_3a80c4a6 = getent(("train_lockdown_door_0" + n_index) + "_r", "targetname");
	var_265e12e8 movey(-64, 0.2);
	var_3a80c4a6 movey(64, 0.2);
	var_3a80c4a6 playsound("evt_train_door_close");
	var_265e12e8 waittill(#"movedone");
	var_265e12e8 disconnectpaths(0, 0);
	var_3a80c4a6 disconnectpaths(0, 0);
	e_gate = getent("train_umbra_gate_0" + n_index, "targetname");
	e_gate show();
	e_gate solid();
	umbragate_set("train_umbra_gate_0" + n_index, 0);
}

/*
	Name: function_42e02b4
	Namespace: newworld_train
	Checksum: 0x8D38A9DF
	Offset: 0x6F00
	Size: 0x1F4
	Parameters: 1
	Flags: Linked
*/
function function_42e02b4(n_index)
{
	e_gate = getent("train_umbra_gate_0" + n_index, "targetname");
	e_gate ghost();
	e_gate notsolid();
	e_gate connectpaths();
	umbragate_set("train_umbra_gate_0" + n_index, 1);
	var_265e12e8 = getent(("train_lockdown_door_0" + n_index) + "_l", "targetname");
	var_3a80c4a6 = getent(("train_lockdown_door_0" + n_index) + "_r", "targetname");
	var_265e12e8 movey(64, 0.2);
	var_3a80c4a6 movey(-64, 0.2);
	var_3a80c4a6 playsound("evt_train_door_open");
	var_265e12e8 waittill(#"movedone");
	var_265e12e8 connectpaths();
	var_3a80c4a6 connectpaths();
	trigger::use(("enable_car_" + n_index) + "_respawns");
}

/*
	Name: function_57409da3
	Namespace: newworld_train
	Checksum: 0x67F4BE8F
	Offset: 0x7100
	Size: 0x2B4
	Parameters: 0
	Flags: Linked
*/
function function_57409da3()
{
	level flag::init("train_car_4_locked_down");
	level flag::init("train_car_3_locked_down");
	level flag::init("train_car_2_locked_down");
	level flag::init("train_car_1_locked_down");
	e_gate = getent("train_umbra_gate_04", "targetname");
	e_gate ghost();
	e_gate notsolid();
	e_gate connectpaths();
	umbragate_set("train_umbra_gate_04", 1);
	trigger::use("disable_car_0_respawns");
	level thread train_car_door_lock(3);
	level thread train_car_door_lock(2);
	level thread train_car_door_lock(1);
	trigger::wait_till("train_car_lockdown_03");
	function_42e02b4(3);
	e_trigger = getent("train_car_lockdown_04", "targetname");
	e_trigger thread wait_for_train_car_to_be_empty();
	trigger::wait_till("train_car_lockdown_02");
	function_42e02b4(2);
	e_trigger = getent("train_car_lockdown_03", "targetname");
	e_trigger thread wait_for_train_car_to_be_empty();
	trigger::wait_till("train_car_lockdown_01");
	function_42e02b4(1);
	e_trigger = getent("train_car_lockdown_02", "targetname");
	e_trigger thread wait_for_train_car_to_be_empty();
}

/*
	Name: function_1b953f61
	Namespace: newworld_train
	Checksum: 0xE7F7A4DB
	Offset: 0x73C0
	Size: 0x206
	Parameters: 0
	Flags: Linked
*/
function function_1b953f61()
{
	switch(level.activeplayers.size)
	{
		case 1:
		case 2:
		{
			n_count = 2;
			break;
		}
		case 3:
		{
			n_count = 4;
			break;
		}
		case 4:
		{
			n_count = 4;
			break;
		}
		default:
		{
			n_count = 0;
			break;
		}
	}
	var_2d8e6fdb = [];
	for(i = 1; i < (n_count + 1); i++)
	{
		ai_robot = spawner::simple_spawn_single("train_climb_robot");
		var_2d8e6fdb[var_2d8e6fdb.size] = ai_robot;
		s_scene = struct::get("train_roof2_climb1_0" + i, "targetname");
		s_scene thread scene::init(ai_robot);
	}
	level thread function_fa538321(var_2d8e6fdb);
	level thread function_33267d4e();
	level flag::wait_till("train_climb_robot_scene");
	for(i = 1; i < (n_count + 1); i++)
	{
		s_scene = struct::get("train_roof2_climb1_0" + i, "targetname");
		s_scene thread scene::play();
		wait(0.25);
	}
}

/*
	Name: function_fa538321
	Namespace: newworld_train
	Checksum: 0x7A9DC607
	Offset: 0x75D0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_fa538321(var_2d8e6fdb)
{
	level endon(#"hash_5e95ab82");
	ai::waittill_dead(var_2d8e6fdb);
	level flag::set("spawn_wave2_climbers");
}

/*
	Name: function_33267d4e
	Namespace: newworld_train
	Checksum: 0xE443938D
	Offset: 0x7628
	Size: 0x1B6
	Parameters: 0
	Flags: Linked
*/
function function_33267d4e()
{
	switch(level.activeplayers.size)
	{
		case 1:
		case 2:
		{
			n_count = 2;
			break;
		}
		case 3:
		{
			n_count = 4;
			break;
		}
		case 4:
		{
			n_count = 6;
			break;
		}
		default:
		{
			n_count = 0;
			break;
		}
	}
	for(i = 1; i < (n_count + 1); i++)
	{
		ai_robot = spawner::simple_spawn_single("train_climb_robot");
		s_scene = struct::get("train_roof2_climb2_0" + i, "targetname");
		s_scene thread scene::init(ai_robot);
	}
	level flag::wait_till("spawn_wave2_climbers");
	for(i = 1; i < (n_count + 1); i++)
	{
		s_scene = struct::get("train_roof2_climb2_0" + i, "targetname");
		s_scene thread scene::play();
		wait(0.25);
	}
}

/*
	Name: train_wind_resistance
	Namespace: newworld_train
	Checksum: 0xB854174D
	Offset: 0x77E8
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function train_wind_resistance()
{
	level endon(#"detach_bomb_igc_terminate");
	level thread player_on_top_of_train_watcher();
	e_volume = getent("train_rooftop_volume", "targetname");
	while(isdefined(e_volume))
	{
		foreach(player in level.players)
		{
			if(!(isdefined(player.is_on_train_roof) && player.is_on_train_roof) && player istouching(e_volume))
			{
				e_volume thread train_wind_resistance_player(player);
			}
		}
		wait(1);
	}
}

/*
	Name: player_on_top_of_train_watcher
	Namespace: newworld_train
	Checksum: 0xE175E6C1
	Offset: 0x7928
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function player_on_top_of_train_watcher()
{
	e_trigger = getent("player_enters_train_rooftop", "targetname");
	e_trigger waittill(#"trigger");
	altered_gravity_enable();
	level.player_on_top_of_train = 1;
	level flag::set("player_on_top_of_train");
	level clientfield::set("set_fog_bank", 1);
	level thread player_inside_train_watcher();
}

/*
	Name: player_inside_train_watcher
	Namespace: newworld_train
	Checksum: 0x9F65EDCF
	Offset: 0x79E8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function player_inside_train_watcher()
{
	trigger::wait_till("player_exits_train_rooftop");
	altered_gravity_enable(0);
}

/*
	Name: train_wind_resistance_player
	Namespace: newworld_train
	Checksum: 0xF3CB23E3
	Offset: 0x7A28
	Size: 0x18C
	Parameters: 1
	Flags: Linked
*/
function train_wind_resistance_player(e_player)
{
	e_player endon(#"death");
	e_player.is_on_train_roof = 1;
	e_player clientfield::set_to_player("train_rumble_loop", 1);
	e_player util::set_lighting_state(1);
	n_last_push = gettime();
	e_player thread player_is_ignored_when_climbing_to_roof();
	while(e_player istouching(self))
	{
		if(e_player.angles[1] >= -90 && e_player.angles[1] <= 90)
		{
			e_player setmovespeedscale(1.2);
		}
		else
		{
			e_player setmovespeedscale(0.7);
		}
		wait(0.05);
	}
	e_player clientfield::set_to_player("train_rumble_loop", 0);
	e_player setmovespeedscale(1);
	e_player.is_on_train_roof = 0;
	e_player util::set_lighting_state(0);
}

/*
	Name: player_is_ignored_when_climbing_to_roof
	Namespace: newworld_train
	Checksum: 0x6303C55F
	Offset: 0x7BC0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function player_is_ignored_when_climbing_to_roof()
{
	self endon(#"death");
	if(!(isdefined(self.climbed_to_roof) && self.climbed_to_roof))
	{
		self.climbed_to_roof = 1;
		n_attackeraccuracy = self.attackeraccuracy;
		self.attackeraccuracy = 0.05;
		wait(5);
		self.attackeraccuracy = n_attackeraccuracy;
	}
}

/*
	Name: train_brake_flaps_init
	Namespace: newworld_train
	Checksum: 0xFDC15EB1
	Offset: 0x7C38
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function train_brake_flaps_init()
{
	a_nd_cover = getnodearray("train_rooftop_cover", "script_noteworthy");
	foreach(node in a_nd_cover)
	{
		setenablenode(node, 0);
	}
	clientfield::set("train_brake_flaps", 1);
}

/*
	Name: train_brake_flaps_pop_up
	Namespace: newworld_train
	Checksum: 0xD4FE4CC9
	Offset: 0x7D18
	Size: 0x11A
	Parameters: 1
	Flags: Linked
*/
function train_brake_flaps_pop_up(b_skipto = 0)
{
	if(!b_skipto)
	{
		level flag::wait_till("player_on_top_of_train");
	}
	clientfield::set("train_brake_flaps", 0);
	wait(0.25);
	a_nd_cover = getnodearray("train_rooftop_cover", "script_noteworthy");
	foreach(node in a_nd_cover)
	{
		setenablenode(node, 1);
	}
}

/*
	Name: function_85eaeda4
	Namespace: newworld_train
	Checksum: 0x7B232353
	Offset: 0x7E40
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_85eaeda4()
{
	train_brake_flaps_init();
	util::wait_network_frame();
	train_brake_flaps_pop_up(1);
}

/*
	Name: skipto_train_rooftop_init
	Namespace: newworld_train
	Checksum: 0xC03FE9D6
	Offset: 0x7E88
	Size: 0x68C
	Parameters: 2
	Flags: Linked
*/
function skipto_train_rooftop_init(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		function_c63fb1d();
		init_train_flags();
		train_civilians(str_objective);
		level thread function_75fc9f6a();
		level thread train_car_door_lock(1);
		level thread train_spawn_functions();
		level thread array::run_all(getentarray("train_lockdown_door", "targetname"), &movey, -64, 0.5);
		level thread array::run_all(getentarray("train_lockdown_glass", "targetname"), &delete);
		level thread setup_robot_spawn_scenes();
		load::function_a2995f22();
		level clientfield::set("train_main_fx_occlude", 1);
		clientfield::set("train_lockdown_glass_left", 2);
		clientfield::set("train_lockdown_glass_right", 2);
		exploder::exploder("ex_breakglass");
		clientfield::set("train_lockdown_shutters_1", 1);
		level thread train_brake_flaps_init();
		level thread function_123070a9();
		level thread objectives::breadcrumb("train_rooftop_breadcrumb");
		weapon = newworld_util::function_71840183("cybercom_rapidstrike", 0);
		var_12b288c7 = weapon.name + "_fired";
		foreach(player in level.players)
		{
			if(!player newworld_util::function_c633d8fe())
			{
				player thread function_e5b6ecf2(var_12b288c7);
			}
		}
		newworld_util::function_3e37f48b(0);
	}
	else
	{
		newworld_util::function_c1c980d8("t_vol_cull_stragglers_train_start");
	}
	var_a59819c6 = getentarray("train_roof_diable_respawns", "targetname");
	foreach(var_1bad7ee6 in var_a59819c6)
	{
		var_1bad7ee6 trigger::use();
	}
	callback::on_ai_killed(&function_9ee5007a);
	level thread train_wind_resistance();
	level thread train_player_checkpoints();
	level thread function_f9012fc();
	level thread train_brake_flaps_pop_up();
	level thread function_5e667e1f();
	level thread function_382c53b4();
	level thread train_quadtank_scenes();
	level thread function_441a5f5c();
	level thread function_13b3e595();
	level thread function_376cc585();
	level thread scene::play("p7_fxanim_cp_newworld_train_quadtank_tarp_bundle");
	var_3b374bac = getent("train_detach_bomb_hack", "targetname");
	var_3b374bac triggerenable(0);
	trigger::wait_till("train_1st_rooftop_enemy_spawns");
	if(level.activeplayers.size > 1)
	{
		spawn_manager::enable("train_first_rooftop_reinforcements_sm");
	}
	level flag::wait_till("climb_up_spawns_complete");
	level thread function_6ba3e1f3();
	function_8b13b1f8();
	function_5c66c0be();
	level thread function_cfb8d002();
	function_e84c6ac3();
	spawner::waittill_ai_group_ai_count("last_train_car_robots", 0);
	skipto::objective_completed(str_objective);
}

/*
	Name: function_376cc585
	Namespace: newworld_train
	Checksum: 0xED248FEA
	Offset: 0x8520
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_376cc585()
{
	self endon(#"death");
	level flag::wait_till("cull_penultimate_stragglers");
	newworld_util::function_c1c980d8("t_vol_cull_stragglers_train_main");
}

/*
	Name: skipto_train_rooftop_done
	Namespace: newworld_train
	Checksum: 0x3D425BD
	Offset: 0x8570
	Size: 0x24
	Parameters: 4
	Flags: Linked
*/
function skipto_train_rooftop_done(str_objective, b_starting, b_direct, player)
{
}

/*
	Name: train_spawn_functions
	Namespace: newworld_train
	Checksum: 0x367DAF9D
	Offset: 0x85A0
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function train_spawn_functions()
{
	spawner::add_spawn_function_group("train_robot_rushers", "script_noteworthy", &train_robot_rushers);
	spawner::add_spawn_function_group("train_roof1_reinforcements", "targetname", &function_422fbc49);
	spawner::add_spawn_function_group("train_rooftop_depth", "script_noteworthy", &function_ca6ecfb3);
}

/*
	Name: train_robot_rushers
	Namespace: newworld_train
	Checksum: 0x5D4A4CD5
	Offset: 0x8640
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function train_robot_rushers()
{
	self endon(#"death");
	if(self.classname === "actor_spawner_enemy_sec_robot_cqb_shotgun")
	{
		self ai::set_behavior_attribute("move_mode", "rusher");
		self ai::set_behavior_attribute("sprint", 1);
	}
}

/*
	Name: function_422fbc49
	Namespace: newworld_train
	Checksum: 0x1A29F9A8
	Offset: 0x86B8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_422fbc49()
{
	self endon(#"death");
	self.script_accuracy = 0.1;
	self ai::set_behavior_attribute("sprint", 1);
	e_goalvolume = getent(self.target, "targetname");
	self setgoal(e_goalvolume, 1);
	a_flags = [];
	a_flags[0] = "climb_up_robots_cleared";
	a_flags[1] = "release_train_roof1_reinforcements";
	level flag::wait_till_any(a_flags);
	self.script_accuracy = 1;
	self cleargoalvolume();
	self ai::set_behavior_attribute("move_mode", "rusher");
}

/*
	Name: function_ca6ecfb3
	Namespace: newworld_train
	Checksum: 0x66F667BF
	Offset: 0x87E8
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_ca6ecfb3()
{
	self endon(#"death");
	self.script_accuracy = 0.1;
	while(true)
	{
		foreach(player in level.activeplayers)
		{
			if(distance2dsquared(self.origin, player.origin) <= 722500)
			{
				self.script_accuracy = 1;
				return;
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_6ba3e1f3
	Namespace: newworld_train
	Checksum: 0x14710568
	Offset: 0x88E0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_6ba3e1f3()
{
	spawner::waittill_ai_group_ai_count("climb_up_spawns", 0);
	level flag::set("climb_up_robots_cleared");
}

/*
	Name: train_quadtank_scenes
	Namespace: newworld_train
	Checksum: 0xC6AF9A
	Offset: 0x8928
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function train_quadtank_scenes()
{
	scene::add_scene_func("cin_gen_ambient_quadtank_inactive", &function_3f4179e6, "play");
	scene::play("cin_gen_ambient_quadtank_inactive");
}

/*
	Name: function_3f4179e6
	Namespace: newworld_train
	Checksum: 0x1053458
	Offset: 0x8980
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function function_3f4179e6(a_ents)
{
	foreach(ent in a_ents)
	{
		ent setplayercollision(0);
	}
}

/*
	Name: function_8b13b1f8
	Namespace: newworld_train
	Checksum: 0x52BE6A64
	Offset: 0x8A20
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_8b13b1f8()
{
	level thread function_a9baa4e3();
	function_1b953f61();
	spawn_manager::enable("train_second_rooftop_sm");
	level thread function_72338df1();
	util::wait_network_frame();
	spawn_manager::enable("concussive_wave_2_robots_sm");
}

/*
	Name: function_72338df1
	Namespace: newworld_train
	Checksum: 0x9A883044
	Offset: 0x8AB0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_72338df1()
{
	level flag::wait_till("init_last_train_car_charging_stations");
	spawn_manager::kill("train_second_rooftop_sm");
}

/*
	Name: function_5c66c0be
	Namespace: newworld_train
	Checksum: 0x3ADC007E
	Offset: 0x8AF8
	Size: 0xFA
	Parameters: 0
	Flags: Linked
*/
function function_5c66c0be()
{
	level flag::wait_till("init_last_train_car_charging_stations");
	spawn_manager::enable("end_cargo_car_sm");
	util::wait_network_frame();
	a_s_scenes = struct::get_array("last_car_robot_chargers", "script_noteworthy");
	foreach(s_scene in a_s_scenes)
	{
		s_scene scene::init();
	}
}

/*
	Name: function_e84c6ac3
	Namespace: newworld_train
	Checksum: 0xC11D967C
	Offset: 0x8C00
	Size: 0x362
	Parameters: 0
	Flags: Linked
*/
function function_e84c6ac3()
{
	level thread function_96eacbb1();
	level flag::wait_till("spawn_last_train_car_enemies");
	a_s_scenes = struct::get_array("last_car_robot_chargers_left", "targetname");
	foreach(s_scene in a_s_scenes)
	{
		s_scene thread scene::play();
		wait(randomfloatrange(0.1, 0.25));
	}
	a_s_scenes = struct::get_array("last_car_robot_chargers_center", "targetname");
	foreach(s_scene in a_s_scenes)
	{
		s_scene thread scene::play();
		wait(randomfloatrange(0.1, 0.25));
	}
	a_s_scenes = struct::get_array("last_car_robot_chargers_right", "targetname");
	foreach(s_scene in a_s_scenes)
	{
		s_scene thread scene::play();
		wait(randomfloatrange(0.1, 0.25));
	}
	level flag::wait_till("start_last_train_car_end_enemies");
	a_s_scenes = struct::get_array("last_car_robot_charger_end", "targetname");
	foreach(s_scene in a_s_scenes)
	{
		s_scene thread scene::play();
		wait(randomfloatrange(0.1, 0.25));
	}
}

/*
	Name: function_96eacbb1
	Namespace: newworld_train
	Checksum: 0x35969134
	Offset: 0x8F70
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_96eacbb1()
{
	level endon(#"hash_70ca9767");
	spawn_manager::wait_till_cleared("end_cargo_car_sm");
	level flag::set("spawn_last_train_car_enemies");
}

/*
	Name: altered_gravity_enable
	Namespace: newworld_train
	Checksum: 0x27E9125A
	Offset: 0x8FC0
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function altered_gravity_enable(b_enable = 1)
{
	if(b_enable)
	{
		setdvar("phys_gravity_dir", (-1, 0, 0.9));
	}
	else
	{
		setdvar("phys_gravity_dir", (0, 0, 1));
	}
}

/*
	Name: skipto_detach_bomb_igc_init
	Namespace: newworld_train
	Checksum: 0xB849C222
	Offset: 0x9040
	Size: 0x41C
	Parameters: 2
	Flags: Linked
*/
function skipto_detach_bomb_igc_init(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		function_c63fb1d();
		init_train_flags();
		level.var_fbc6080 = 1;
		level thread train_player_checkpoints();
		level thread function_f9012fc();
		level thread function_75fc9f6a();
		level thread function_441a5f5c();
		a_s_scenes = struct::get_array("last_car_robot_chargers", "script_noteworthy");
		foreach(s_scene in a_s_scenes)
		{
			s_scene scene::skipto_end();
		}
		function_cfb8d002();
		var_3b374bac = getent("train_detach_bomb_hack", "targetname");
		var_3b374bac triggerenable(0);
		load::function_c32ba481();
		level clientfield::set("train_main_fx_occlude", 1);
		level util::set_lighting_state(0);
		level clientfield::set("set_fog_bank", 0);
		level thread function_85eaeda4();
	}
	lui::prime_movie("cp_newworld_env_detachbomb");
	battlechatter::function_d9f49fba(0);
	clientfield::set("train_lockdown_glass_left", 0);
	clientfield::set("train_lockdown_glass_right", 0);
	clientfield::set("train_lockdown_shutters_1", 0);
	level notify(#"hash_73e48fb7");
	util::set_streamer_hint(9);
	e_player = function_84dc13df();
	newworld_util::player_snow_fx();
	level clientfield::set("gameplay_started", 0);
	objectives::complete("cp_level_newworld_underground_locate_terrorist");
	objectives::set("cp_level_newworld_train_disarm");
	level thread function_68c5ad6d();
	level thread newworld_util::function_30ec5bf7();
	detach_bomb_igc(e_player);
	level waittill(#"hash_132422b6");
	level util::clear_streamer_hint();
	level notify(#"detach_bomb_igc_terminate");
	util::clientnotify("newworld_train_complete");
	objectives::complete("cp_level_newworld_train_disarm");
	skipto::objective_completed(str_objective);
}

/*
	Name: skipto_detach_bomb_igc_done
	Namespace: newworld_train
	Checksum: 0x552F6D3D
	Offset: 0x9468
	Size: 0x124
	Parameters: 4
	Flags: Linked
*/
function skipto_detach_bomb_igc_done(str_objective, b_starting, b_direct, player)
{
	if(b_starting === 1)
	{
		objectives::complete("cp_level_newworld_underground_locate_terrorist");
		objectives::complete("cp_level_newworld_train_subobj_hack_door");
	}
	level clientfield::set("train_brake_flaps", 2);
	var_265e12e8 = getent("train_bomb_push_door_l", "targetname");
	var_265e12e8 delete();
	var_3a80c4a6 = getent("train_bomb_push_door_r", "targetname");
	var_3a80c4a6 delete();
	level notify(#"hash_f49d815e");
	level thread function_f0cad19e();
}

/*
	Name: function_84dc13df
	Namespace: newworld_train
	Checksum: 0x6E1B7013
	Offset: 0x9598
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function function_84dc13df()
{
	objectives::set("cp_level_newworld_train_subobj_hack_door");
	var_3b374bac = getent("train_detach_bomb_hack", "targetname");
	var_3b374bac triggerenable(1);
	e_player = newworld_util::function_16dd8c5f("train_detach_bomb_hack", &"cp_level_newworld_access_door", &"CP_MI_ZURICH_NEWWORLD_HACK", "train_door_panel", "train_door_hacked", 0);
	objectives::complete("cp_level_newworld_train_subobj_hack_door");
	return e_player;
}

/*
	Name: function_cfb8d002
	Namespace: newworld_train
	Checksum: 0xD46F84EF
	Offset: 0x9668
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_cfb8d002()
{
	scene::add_scene_func("p7_fxanim_cp_newworld_train_end_bundle", &function_368767cf, "init");
	level thread scene::init("p7_fxanim_cp_newworld_train_end_bundle");
}

/*
	Name: function_368767cf
	Namespace: newworld_train
	Checksum: 0x783D2E4F
	Offset: 0x96C8
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function function_368767cf(a_ents)
{
	var_3ebf068e = a_ents["newworld_train_end"];
	var_3ebf068e enablelinkto();
	var_bf143437 = getentarray("snw_bomb_detach", "script_noteworthy");
	foreach(e_probe in var_bf143437)
	{
		e_probe linkto(var_3ebf068e);
	}
	var_3ebf068e ghost();
}

/*
	Name: detach_bomb_igc
	Namespace: newworld_train
	Checksum: 0x58A962CB
	Offset: 0x97E0
	Size: 0x294
	Parameters: 1
	Flags: Linked
*/
function detach_bomb_igc(e_player)
{
	level notify(#"hash_70ca9767");
	level thread namespace_e38c3c58::function_922297e3();
	if(isdefined(level.bzm_newworlddialogue11callback))
	{
		level thread [[level.bzm_newworlddialogue11callback]]();
	}
	scene::add_scene_func("cin_new_16_01_detachbombcar_1st_detach", &function_956507bd, "play");
	scene::add_scene_func("cin_new_16_01_detachbombcar_1st_detach", &derez_taylor, "play");
	scene::add_scene_func("cin_new_16_01_detachbombcar_1st_detach", &function_87eb5c2, "play");
	scene::add_scene_func("cin_new_16_01_detachbombcar_1st_detach", &function_80caa10e, "play");
	scene::add_scene_func("cin_new_16_01_detachbombcar_1st_detach", &function_7db3194d, "play");
	scene::add_scene_func("cin_new_16_01_detachbombcar_1st_detach", &function_37f058fc, "play");
	level thread scene::play("cin_new_16_01_detachbombcar_1st_detach", e_player);
	hidemiscmodels("train_bomb_exterior_hide");
	var_3ebf068e = getent("newworld_train_end", "targetname");
	var_3ebf068e show();
	level waittill(#"hash_8fa0f2c");
	var_3a80c4a6 = getent("train_bomb_push_door_r", "targetname");
	var_3a80c4a6 movey(-64, 0.5);
	var_265e12e8 = getent("train_bomb_push_door_l", "targetname");
	var_265e12e8 movey(64, 0.5);
}

/*
	Name: function_956507bd
	Namespace: newworld_train
	Checksum: 0xF51919C5
	Offset: 0x9A80
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_956507bd(a_ents)
{
	level endon(#"hash_c95de0a1");
	level waittill(#"hash_8b34418f");
	newworld_util::function_2eded728(1);
	level waittill(#"hash_8fa0f2c");
	newworld_util::function_2eded728(0);
}

/*
	Name: derez_taylor
	Namespace: newworld_train
	Checksum: 0x545E0B76
	Offset: 0x9AE8
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function derez_taylor(a_ents)
{
	ai_taylor = a_ents["taylor"];
	ai_taylor ghost();
	ai_taylor waittill(#"hash_24a44efc");
	ai_taylor newworld_util::function_c949a8ed(1);
	ai_taylor waittill(#"hash_32fc12d3");
	ai_taylor newworld_util::function_4943984c();
}

/*
	Name: function_87eb5c2
	Namespace: newworld_train
	Checksum: 0x3D2466AA
	Offset: 0x9B80
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_87eb5c2(a_ents)
{
	level waittill(#"hash_b6d3fdf6");
	newworld_util::function_2eded728(1);
	level waittill(#"hash_50398047");
	newworld_util::function_2eded728(0);
}

/*
	Name: function_80caa10e
	Namespace: newworld_train
	Checksum: 0xAB67C686
	Offset: 0x9BD8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_80caa10e(a_ents)
{
	level waittill(#"hash_c15931f2");
	newworld_util::function_2eded728(1);
	videostart("cp_newworld_env_detachbomb");
	level waittill(#"hash_6bd55c0d");
	newworld_util::function_2eded728(0);
}

/*
	Name: function_7db3194d
	Namespace: newworld_train
	Checksum: 0xEF1CCAAB
	Offset: 0x9C48
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function function_7db3194d(a_ents)
{
	level thread function_778d22d7(a_ents);
	a_ents["player 1"] waittill(#"hash_7db3194d");
	level notify(#"hash_c053b2ca");
	hidemiscmodels("train_bomb_models_hide");
	level thread scene::play("p7_fxanim_cp_newworld_train_end_bundle");
	if(!scene::is_skipping_in_progress())
	{
		level util::set_lighting_state(1);
		level clientfield::set("set_fog_bank", 1);
	}
}

/*
	Name: function_778d22d7
	Namespace: newworld_train
	Checksum: 0xF0024C1D
	Offset: 0x9D20
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function function_778d22d7(a_ents)
{
	a_ents["player 1"] waittill(#"train_explosion");
	exploder::exploder("ex_bomb_igc");
	var_3ebf068e = getent("newworld_train_end", "targetname");
	var_3ebf068e clientfield::set("train_explosion_fx", 1);
}

/*
	Name: function_37f058fc
	Namespace: newworld_train
	Checksum: 0x8A16877E
	Offset: 0x9DB8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_37f058fc(a_ents)
{
	a_ents["player 1"] waittill(#"hash_7d28806");
	level notify(#"hash_c95de0a1");
	level flag::set("infinite_white_transition");
}

/*
	Name: function_68c5ad6d
	Namespace: newworld_train
	Checksum: 0x557F2523
	Offset: 0x9E10
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_68c5ad6d()
{
	level thread scene::stop("p7_fxanim_cp_newworld_train_quadtank_tarp_bundle", 1);
}

/*
	Name: function_de13d6e2
	Namespace: newworld_train
	Checksum: 0x28405B85
	Offset: 0x9E40
	Size: 0x58A
	Parameters: 1
	Flags: Linked
*/
function function_de13d6e2(var_be1a191b = 0)
{
	level.var_55c8b6a7 = getent("train_terrain_country_01_track_01", "targetname");
	level.var_55c8b6a7 function_52874109("country_01_lighting");
	level.var_e3c1476c = getent("train_terrain_country_01_track_02", "targetname");
	level.var_e3c1476c function_52874109("country_02_lighting");
	level.var_9c3c1d5 = getent("train_terrain_country_01_track_03", "targetname");
	level.var_9c3c1d5 function_52874109("country_03_lighting");
	level.var_1bfadc08 = getent("train_terrain_country_02_track_01", "targetname");
	level.var_1bfadc08 function_52874109("country2_01_lighting");
	level.var_8e024b43 = getent("train_terrain_country_02_track_02", "targetname");
	level.var_8e024b43 function_52874109("country2_02_lighting");
	level.var_67ffd0da = getent("train_terrain_country_02_track_03", "targetname");
	level.var_67ffd0da function_52874109("country2_03_lighting");
	level.var_accc6632 = getent("train_terrain_tunnel_01_track_01", "targetname");
	level.var_accc6632 function_52874109("tunnel_01_lighting");
	level.var_86c9ebc9 = getent("train_terrain_tunnel_01_track_02", "targetname");
	level.var_86c9ebc9 function_52874109("tunnel_02_lighting");
	level.var_60c77160 = getent("train_terrain_tunnel_01_track_03", "targetname");
	level.var_60c77160 function_52874109("tunnel_03_lighting");
	level.var_689205c5 = getent("train_terrain_city_01_track_01", "targetname");
	level.var_8e94802e = getent("train_terrain_city_01_track_02", "targetname");
	level.var_b496fa97 = getent("train_terrain_city_01_track_03", "targetname");
	if(var_be1a191b == 1)
	{
		level.var_689205c5 delete();
		level.var_8e94802e delete();
		level.var_b496fa97 delete();
		a_env = array(level.var_55c8b6a7, level.var_e3c1476c, level.var_9c3c1d5, level.var_1bfadc08, level.var_8e024b43, level.var_67ffd0da, level.var_accc6632, level.var_86c9ebc9, level.var_60c77160);
	}
	else
	{
		a_env = array(level.var_55c8b6a7, level.var_e3c1476c, level.var_9c3c1d5, level.var_1bfadc08, level.var_8e024b43, level.var_67ffd0da, level.var_accc6632, level.var_86c9ebc9, level.var_60c77160, level.var_689205c5, level.var_8e94802e, level.var_b496fa97);
	}
	level.var_9cd0665b = a_env;
	foreach(var_7d2a21b6 in a_env)
	{
		if(isdefined(var_7d2a21b6.var_685c7a0b))
		{
			foreach(var_f4933ec0 in var_7d2a21b6.var_685c7a0b)
			{
				var_f4933ec0 linkto(var_7d2a21b6);
			}
		}
		function_8b08d700(var_7d2a21b6);
	}
}

/*
	Name: function_52874109
	Namespace: newworld_train
	Checksum: 0x28C912FB
	Offset: 0xA3D8
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function function_52874109(str_script_noteworthy)
{
	var_d3ec9eeb = getentarray(str_script_noteworthy, "script_noteworthy");
	if(isdefined(var_d3ec9eeb))
	{
		self.var_685c7a0b = var_d3ec9eeb;
	}
}

/*
	Name: function_8b08d700
	Namespace: newworld_train
	Checksum: 0x8BA5F452
	Offset: 0xA430
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function function_8b08d700(var_7d2a21b6)
{
	/#
		assert(isdefined(var_7d2a21b6), "");
	#/
	if(isdefined(var_7d2a21b6.var_685c7a0b))
	{
		foreach(var_f4933ec0 in var_7d2a21b6.var_685c7a0b)
		{
			var_f4933ec0 hide();
		}
	}
	var_7d2a21b6 hide();
}

/*
	Name: function_c7d3965b
	Namespace: newworld_train
	Checksum: 0x77EF464B
	Offset: 0xA530
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function function_c7d3965b(var_7d2a21b6)
{
	/#
		assert(isdefined(var_7d2a21b6), "");
	#/
	if(isdefined(var_7d2a21b6.var_685c7a0b))
	{
		foreach(var_f4933ec0 in var_7d2a21b6.var_685c7a0b)
		{
			var_f4933ec0 ghost();
		}
	}
	var_7d2a21b6 ghost();
}

/*
	Name: function_8db22683
	Namespace: newworld_train
	Checksum: 0x1FB84FBF
	Offset: 0xA630
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function function_8db22683(var_7d2a21b6)
{
	/#
		assert(isdefined(var_7d2a21b6), "");
	#/
	if(isdefined(var_7d2a21b6.var_685c7a0b))
	{
		foreach(var_f4933ec0 in var_7d2a21b6.var_685c7a0b)
		{
			var_f4933ec0 show();
		}
	}
	var_7d2a21b6 show();
}

/*
	Name: function_a86fd374
	Namespace: newworld_train
	Checksum: 0xCB3EAD7E
	Offset: 0xA730
	Size: 0x8A
	Parameters: 0
	Flags: None
*/
function function_a86fd374()
{
	foreach(var_7d2a21b6 in level.var_9cd0665b)
	{
		function_8b08d700(var_7d2a21b6);
	}
}

/*
	Name: function_6fe6a34d
	Namespace: newworld_train
	Checksum: 0x16619496
	Offset: 0xA7C8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_6fe6a34d()
{
	e_1 = level.var_689205c5;
	e_2 = level.var_8e94802e;
	e_3 = level.var_b496fa97;
	level thread environment_init(e_1, e_2, e_3, 1);
	level clientfield::set("sndTrainContext", 2);
}

/*
	Name: function_75fc9f6a
	Namespace: newworld_train
	Checksum: 0x46CF17CD
	Offset: 0xA858
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_75fc9f6a()
{
	e_1 = level.var_55c8b6a7;
	e_2 = level.var_e3c1476c;
	e_3 = level.var_9c3c1d5;
	level thread environment_init(e_1, e_2, e_3);
	level clientfield::set("sndTrainContext", 1);
}

/*
	Name: function_3641dc88
	Namespace: newworld_train
	Checksum: 0xE1F75A3D
	Offset: 0xA8E8
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function function_3641dc88()
{
	var_718f1be5 = level.var_55c8b6a7;
	var_9791964e = level.var_e3c1476c;
	var_bd9410b7 = level.var_9c3c1d5;
	e_tunnel_1 = level.var_accc6632;
	e_tunnel_2 = level.var_86c9ebc9;
	e_tunnel_3 = level.var_60c77160;
	level flag::wait_till("train_switch_to_tunnel_environment");
	/#
		iprintlnbold("");
	#/
	level clientfield::set("sndTrainContext", 0);
	level thread environment_transition(var_718f1be5, var_9791964e, var_bd9410b7, e_tunnel_1, e_tunnel_2, e_tunnel_3);
	newworld_util::function_85d8906c();
	level flag::wait_till("train_switch_to_forest_environment");
	/#
		iprintlnbold("");
	#/
	level clientfield::set("sndTrainContext", 2);
	level thread environment_transition(e_tunnel_1, e_tunnel_2, e_tunnel_3, var_718f1be5, var_9791964e, var_bd9410b7);
	level util::delay(6, undefined, &newworld_util::player_snow_fx);
}

/*
	Name: function_c4addffd
	Namespace: newworld_train
	Checksum: 0xDC42BC36
	Offset: 0xAAC8
	Size: 0x16C
	Parameters: 1
	Flags: Linked
*/
function function_c4addffd(n_delay = 3)
{
	e_tunnel_1 = level.var_accc6632;
	e_tunnel_2 = level.var_86c9ebc9;
	e_tunnel_3 = level.var_60c77160;
	var_f9c66158 = level.var_689205c5;
	var_6bcdd093 = level.var_8e94802e;
	var_45cb562a = level.var_b496fa97;
	newworld_util::function_85d8906c();
	level environment_transition(level.var_2982cbda[0], level.var_2982cbda[1], level.var_2982cbda[2], e_tunnel_1, e_tunnel_2, e_tunnel_3);
	wait(n_delay);
	level util::delay(3, undefined, &newworld_util::player_snow_fx);
	level environment_transition(level.var_2982cbda[0], level.var_2982cbda[1], level.var_2982cbda[2], var_f9c66158, var_6bcdd093, var_45cb562a);
}

/*
	Name: function_441a5f5c
	Namespace: newworld_train
	Checksum: 0x2BAEBA82
	Offset: 0xAC40
	Size: 0x1C0
	Parameters: 0
	Flags: Linked
*/
function function_441a5f5c()
{
	level endon(#"hash_f49d815e");
	var_1f163712 = level.var_55c8b6a7;
	var_f913bca9 = level.var_e3c1476c;
	var_d3114240 = level.var_9c3c1d5;
	var_f1cc2435 = level.var_1bfadc08;
	var_17ce9e9e = level.var_8e024b43;
	var_3dd11907 = level.var_67ffd0da;
	while(true)
	{
		/#
			iprintlnbold("");
		#/
		level environment_transition(level.var_2982cbda[0], level.var_2982cbda[1], level.var_2982cbda[2], var_f1cc2435, var_17ce9e9e, var_3dd11907);
		level clientfield::set("sndTrainContext", 1);
		wait(randomfloatrange(4, 10));
		/#
			iprintlnbold("");
		#/
		level environment_transition(level.var_2982cbda[0], level.var_2982cbda[1], level.var_2982cbda[2], var_1f163712, var_f913bca9, var_d3114240);
		wait(randomfloatrange(4, 10));
	}
}

/*
	Name: environment_init
	Namespace: newworld_train
	Checksum: 0x52DF29A6
	Offset: 0xAE08
	Size: 0x1CC
	Parameters: 4
	Flags: Linked
*/
function environment_init(e_environment_1, e_environment_2, e_environment_3, b_intro = 0)
{
	if(b_intro == 1)
	{
		s_origin = struct::get("train_terrain_origin_intro", "targetname");
	}
	else
	{
		s_origin = struct::get("train_terrain_origin", "targetname");
	}
	level flag::clear("train_terrain_move_complete");
	level flag::clear("train_terrain_transition");
	e_environment_1.origin = s_origin.origin - vectorscale((1, 0, 0), 36736);
	e_environment_2.origin = s_origin.origin;
	if(isdefined(e_environment_3))
	{
		e_environment_3.origin = s_origin.origin + vectorscale((1, 0, 0), 36736);
	}
	level.v_train_terrain_origin = e_environment_1.origin;
	function_8db22683(e_environment_1);
	function_8db22683(e_environment_2);
	function_8db22683(e_environment_3);
	level thread environment_move(e_environment_1, e_environment_2, e_environment_3);
}

/*
	Name: environment_move
	Namespace: newworld_train
	Checksum: 0x3345D272
	Offset: 0xAFE0
	Size: 0x354
	Parameters: 3
	Flags: Linked
*/
function environment_move(e_environment_1, e_environment_2, e_environment_3)
{
	level endon(#"white_infinite_igc_terminate");
	level endon(#"detach_bomb_igc_terminate");
	level endon(#"hash_f49d815e");
	level.var_2982cbda = array(e_environment_1, e_environment_2, e_environment_3);
	while(!level flag::get("train_terrain_transition"))
	{
		function_c7d3965b(e_environment_1);
		e_environment_1.origin = level.v_train_terrain_origin;
		util::delay(0.1, "train_terrain_stop", &function_8db22683, e_environment_1);
		e_environment_1 movex(36736, 4);
		e_environment_2 movex(36736, 4);
		if(isdefined(e_environment_3))
		{
			e_environment_3 movex(36736, 4);
		}
		wait(4);
		if(level flag::get("train_terrain_transition"))
		{
			break;
		}
		if(isdefined(e_environment_3))
		{
			function_c7d3965b(e_environment_3);
			e_environment_3.origin = level.v_train_terrain_origin;
			util::delay(0.1, "train_terrain_stop", &function_8db22683, e_environment_3);
			e_environment_1 movex(36736, 4);
			e_environment_2 movex(36736, 4);
			e_environment_3 movex(36736, 4);
			wait(4);
			if(level flag::get("train_terrain_transition"))
			{
				break;
			}
		}
		function_c7d3965b(e_environment_2);
		e_environment_2.origin = level.v_train_terrain_origin;
		util::delay(0.1, "train_terrain_stop", &function_8db22683, e_environment_2);
		e_environment_1 movex(36736, 4);
		e_environment_2 movex(36736, 4);
		if(isdefined(e_environment_3))
		{
			e_environment_3 movex(36736, 4);
		}
		wait(4);
	}
	level flag::set("train_terrain_move_complete");
}

/*
	Name: environment_transition
	Namespace: newworld_train
	Checksum: 0x5A5C27BC
	Offset: 0xB340
	Size: 0x484
	Parameters: 6
	Flags: Linked
*/
function environment_transition(e_old_environment_1, e_old_environment_2, e_old_environment_3, e_new_environment_1, e_new_environment_2, e_new_environment_3)
{
	level endon(#"white_infinite_igc_terminate");
	level endon(#"detach_bomb_igc_terminate");
	level endon(#"hash_f49d815e");
	level flag::set("train_terrain_transition");
	level flag::wait_till("train_terrain_move_complete");
	level flag::clear("train_terrain_move_complete");
	level flag::clear("train_terrain_transition");
	a_new = [];
	if(isdefined(e_new_environment_3))
	{
		a_new[0] = e_new_environment_3;
	}
	a_new[a_new.size] = e_new_environment_2;
	a_new[a_new.size] = e_new_environment_1;
	n_new_terrain_size = a_new.size;
	a_old = [];
	if(isdefined(e_old_environment_3))
	{
		a_old[0] = e_old_environment_3;
	}
	a_old[a_old.size] = e_old_environment_2;
	a_old[a_old.size] = e_old_environment_1;
	s_pos = struct::get("back_of_the_train", "targetname");
	a_old = arraysort(a_old, s_pos.origin, 0);
	while(a_new.size > 0)
	{
		e_old_end = a_old[a_old.size - 1];
		if(e_old_end === e_old_environment_1 || e_old_end === e_old_environment_2 || e_old_end === e_old_environment_3)
		{
			function_8b08d700(a_old[a_old.size - 1]);
			array::pop(a_old, a_old.size - 1);
		}
		function_c7d3965b(a_new[0]);
		a_new[0].origin = level.v_train_terrain_origin;
		util::delay(0.1, "train_terrain_stop", &function_8db22683, a_new[0]);
		array::push_front(a_old, a_new[0]);
		array::pop_front(a_new, 0);
		foreach(e_track_model in a_old)
		{
			e_track_model movex(36736, 4);
		}
		wait(4);
	}
	while(a_old.size > n_new_terrain_size)
	{
		function_8b08d700(a_old[a_old.size - 1]);
		array::pop(a_old, a_old.size - 1);
	}
	if(isdefined(a_old[2]))
	{
		level thread environment_move(a_old[2], a_old[0], a_old[1]);
	}
	else
	{
		level thread environment_move(a_old[0], a_old[1], a_old[2]);
	}
}

/*
	Name: function_7d334045
	Namespace: newworld_train
	Checksum: 0xFDEDB4A6
	Offset: 0xB7D0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_7d334045()
{
	e_1 = level.var_689205c5;
	e_2 = level.var_8e94802e;
	e_3 = level.var_b496fa97;
	level notify(#"hash_f49d815e");
	e_1 moveto(e_1.origin, 0.05);
	e_2 moveto(e_2.origin, 0.05);
	e_3 moveto(e_3.origin, 0.05);
}

/*
	Name: function_9eb901e
	Namespace: newworld_train
	Checksum: 0x1F4F7560
	Offset: 0xB8A0
	Size: 0x17C
	Parameters: 0
	Flags: None
*/
function function_9eb901e()
{
	e_1 = level.var_55c8b6a7;
	e_2 = level.var_e3c1476c;
	e_3 = level.var_9c3c1d5;
	var_5087bc9f = level.var_1bfadc08;
	var_2a854236 = level.var_8e024b43;
	var_482c7cd = level.var_67ffd0da;
	level notify(#"hash_f49d815e");
	e_1 moveto(e_1.origin, 0.05);
	e_2 moveto(e_2.origin, 0.05);
	e_3 moveto(e_3.origin, 0.05);
	var_5087bc9f moveto(var_5087bc9f.origin, 0.05);
	var_2a854236 moveto(var_2a854236.origin, 0.05);
	var_482c7cd moveto(var_482c7cd.origin, 0.05);
}

/*
	Name: function_f0cad19e
	Namespace: newworld_train
	Checksum: 0x87C24AF9
	Offset: 0xBA28
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function function_f0cad19e()
{
	foreach(var_bf3222f4 in level.var_9cd0665b)
	{
		var_bf3222f4 delete();
	}
}

/*
	Name: train_player_checkpoints
	Namespace: newworld_train
	Checksum: 0x53FD4250
	Offset: 0xBAC0
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function train_player_checkpoints()
{
	level endon(#"detach_bomb_igc_terminate");
	level thread train_robot_fell_off();
	a_e_triggers = getentarray("train_bad_area", "targetname");
	foreach(e_trigger in a_e_triggers)
	{
		e_trigger thread train_player_fell_off();
	}
}

/*
	Name: train_player_fell_off
	Namespace: newworld_train
	Checksum: 0xCEA7A52A
	Offset: 0xBBA0
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function train_player_fell_off()
{
	level endon(#"hash_47ed8d40");
	a_s_teleports = struct::get_array(self.target, "targetname");
	while(true)
	{
		self waittill(#"trigger", e_who);
		if(isplayer(e_who) && (!(isdefined(e_who.var_511157e8) && e_who.var_511157e8)))
		{
			e_who playsoundtoplayer("evt_plr_derez", e_who);
			e_who thread function_c24ce0f9(a_s_teleports);
		}
	}
}

/*
	Name: function_c24ce0f9
	Namespace: newworld_train
	Checksum: 0x92AF2474
	Offset: 0xBC78
	Size: 0x20C
	Parameters: 1
	Flags: Linked
*/
function function_c24ce0f9(a_s_teleports)
{
	self endon(#"death");
	while(true)
	{
		s_spot = array::random(a_s_teleports);
		if(!positionwouldtelefrag(s_spot.origin))
		{
			self.var_511157e8 = 1;
			self.ignoreme = 1;
			self enableinvulnerability();
			self ghost();
			self util::freeze_player_controls(1);
			self setorigin(s_spot.origin);
			self setplayerangles(s_spot.angles);
			self clientfield::increment_to_player("postfx_igc");
			util::wait_network_frame();
			self show();
			self clientfield::set("player_spawn_fx", 1);
			self util::delay(2, "death", &clientfield::set, "player_spawn_fx", 0);
			self thread function_f26eff53();
			wait(2);
			self disableinvulnerability();
			self util::freeze_player_controls(0);
			self.var_511157e8 = 0;
			self.ignoreme = 0;
			break;
		}
	}
}

/*
	Name: train_robot_fell_off
	Namespace: newworld_train
	Checksum: 0x66875D3A
	Offset: 0xBE90
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function train_robot_fell_off()
{
	level endon(#"detach_bomb_igc_terminate");
	e_trigger = getent("train_bad_area_robots", "targetname");
	while(true)
	{
		e_trigger waittill(#"trigger", e_who);
		if(!isplayer(e_who))
		{
			e_who kill();
		}
	}
}

/*
	Name: function_f9012fc
	Namespace: newworld_train
	Checksum: 0x1CC11D90
	Offset: 0xBF28
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function function_f9012fc()
{
	level endon(#"detach_bomb_igc_terminate");
	var_32400ae0 = getent("train_grenades_make_duds", "targetname");
	foreach(player in level.players)
	{
		player thread grenade_toss(var_32400ae0);
	}
	callback::on_spawned(&grenade_toss, var_32400ae0);
}

/*
	Name: grenade_toss
	Namespace: newworld_train
	Checksum: 0x756FD4AD
	Offset: 0xC018
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function grenade_toss(var_32400ae0)
{
	level endon(#"detach_bomb_igc_terminate");
	self endon(#"death");
	while(true)
	{
		self waittill(#"grenade_fire", e_grenade);
		e_grenade thread function_337c8c84(var_32400ae0);
	}
}

/*
	Name: function_337c8c84
	Namespace: newworld_train
	Checksum: 0x5E0A99E5
	Offset: 0xC080
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function function_337c8c84(var_32400ae0)
{
	self endon(#"death");
	if(isdefined(10))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(10, "timeout");
	}
	while(true)
	{
		if(self istouching(var_32400ae0))
		{
			if(isdefined(self))
			{
				self makegrenadedud();
			}
			break;
		}
		wait(0.05);
	}
}

/*
	Name: function_9ee5007a
	Namespace: newworld_train
	Checksum: 0xB7A27F5
	Offset: 0xC148
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_9ee5007a(params)
{
	self thread function_be50cfd5();
	self thread function_50171558();
}

/*
	Name: function_be50cfd5
	Namespace: newworld_train
	Checksum: 0x8E9D43E9
	Offset: 0xC190
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_be50cfd5()
{
	self waittill(#"start_ragdoll");
	if(isdefined(self))
	{
		self clientfield::set("train_throw_robot_corpses", 1);
	}
}

/*
	Name: function_50171558
	Namespace: newworld_train
	Checksum: 0xFE5899D2
	Offset: 0xC1D8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_50171558()
{
	self waittill(#"actor_corpse", e_corpse);
	if(isdefined(e_corpse))
	{
		e_corpse clientfield::set("train_throw_robot_corpses", 1);
	}
}

/*
	Name: function_19b91013
	Namespace: newworld_train
	Checksum: 0x953A031C
	Offset: 0xC228
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_19b91013()
{
	s_org = struct::get("intro_igc_train_vo", "targetname");
	e_org = spawn("script_origin", s_org.origin);
	level waittill(#"chyron_menu_open");
	e_org dialog::say("trai_downtown_zurich_fin_0", 7, 1);
	e_org delete();
}

/*
	Name: function_c63fb1d
	Namespace: newworld_train
	Checksum: 0xFF9497A4
	Offset: 0xC2E0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_c63fb1d()
{
	var_7066a248 = struct::get("taylor_vo", "targetname");
	level.var_fc1953ce = spawn("script_origin", var_7066a248.origin);
}

/*
	Name: function_8c0c3c47
	Namespace: newworld_train
	Checksum: 0x99BEB3DB
	Offset: 0xC348
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_8c0c3c47()
{
	level flag::init("train_intro_vo_complete");
	level.var_fc1953ce dialog::say("tayr_you_ve_been_here_bef_0", undefined, 1);
	level.var_fc1953ce dialog::say("tayr_all_robots_should_be_0", 0.5, 1);
	level flag::set("train_intro_vo_complete");
}

/*
	Name: function_11711684
	Namespace: newworld_train
	Checksum: 0x699BEB4A
	Offset: 0xC3F0
	Size: 0x18A
	Parameters: 2
	Flags: Linked
*/
function function_11711684(var_81a32895, var_2380d5c)
{
	level flag::wait_till("train_intro_vo_complete");
	weapon = newworld_util::function_71840183(var_81a32895, var_2380d5c);
	var_12b288c7 = weapon.name + "_fired";
	var_a2cc98e = var_81a32895 + "_use_ability_tutorial";
	foreach(player in level.activeplayers)
	{
		if(player newworld_util::function_c633d8fe())
		{
			continue;
		}
		level.var_fc1953ce dialog::say("tayr_takedown_is_another_0", 0.25, 1, player);
		player thread function_1563ec28(var_a2cc98e);
		player thread function_152eb171(var_12b288c7);
	}
}

/*
	Name: function_1563ec28
	Namespace: newworld_train
	Checksum: 0x73654281
	Offset: 0xC588
	Size: 0x146
	Parameters: 1
	Flags: Linked
*/
function function_1563ec28(var_a2cc98e)
{
	level endon(#"hash_e6f4684e");
	self endon(var_a2cc98e);
	self endon(#"death");
	if(!self flag::exists(var_a2cc98e))
	{
		return;
	}
	if(self flag::get(var_a2cc98e))
	{
		return;
	}
	wait(30);
	n_line = randomintrange(0, 3);
	switch(n_line)
	{
		case 0:
		{
			level.var_fc1953ce dialog::say("tayr_what_are_you_waiting_0", undefined, 1, self);
			break;
		}
		case 1:
		{
			level.var_fc1953ce dialog::say("tayr_don_t_leave_me_hangi_0", undefined, 1, self);
			break;
		}
		case 2:
		{
			level.var_fc1953ce dialog::say("tayr_i_m_aging_by_the_fuc_0", undefined, 1, self);
			break;
		}
	}
}

/*
	Name: function_152eb171
	Namespace: newworld_train
	Checksum: 0xD72B4971
	Offset: 0xC6D8
	Size: 0x13A
	Parameters: 1
	Flags: Linked
*/
function function_152eb171(var_12b288c7)
{
	self endon(#"death");
	level endon(#"hash_e6f4684e");
	self thread function_e5b6ecf2(var_12b288c7, 1);
	self waittill(var_12b288c7);
	wait(0.25);
	n_line = randomintrange(0, 3);
	switch(n_line)
	{
		case 0:
		{
			level.var_fc1953ce dialog::say("tayr_that_s_how_you_take_0", undefined, 1, self);
			break;
		}
		case 1:
		{
			level.var_fc1953ce dialog::say("tayr_nice_you_re_gettin_0", undefined, 1, self);
			break;
		}
		case 2:
		{
			level.var_fc1953ce dialog::say("tayr_nice_takedown_righ_0", undefined, 1, self);
			break;
		}
	}
	self notify(#"hash_8bbc0169");
}

/*
	Name: function_e5b6ecf2
	Namespace: newworld_train
	Checksum: 0xB84F4F66
	Offset: 0xC820
	Size: 0x1C8
	Parameters: 2
	Flags: Linked
*/
function function_e5b6ecf2(var_12b288c7, var_a74dbb8c)
{
	self endon(#"death");
	level endon(#"hash_70ca9767");
	if(isdefined(var_a74dbb8c))
	{
		self util::waittill_any_timeout(30, "takedown_tutorial_success_vo_complete");
		wait(15);
	}
	while(true)
	{
		self waittill(var_12b288c7);
		if(isdefined(level.var_fc1953ce.is_talking) && level.var_fc1953ce.is_talking)
		{
			continue;
		}
		if(isdefined(level.var_fc1953ce.var_c795bf9b) && level.var_fc1953ce.var_c795bf9b)
		{
			continue;
		}
		level.var_fc1953ce.var_c795bf9b = 1;
		wait(0.25);
		n_line = randomintrange(0, 3);
		switch(n_line)
		{
			case 0:
			{
				level.var_fc1953ce dialog::say("tayr_that_s_how_you_take_0", undefined, 1);
				break;
			}
			case 1:
			{
				level.var_fc1953ce dialog::say("tayr_nice_you_re_gettin_0", undefined, 1);
				break;
			}
			case 2:
			{
				level.var_fc1953ce dialog::say("tayr_nice_takedown_righ_0", undefined, 1);
				break;
			}
		}
		level thread function_11e947ae();
	}
}

/*
	Name: function_11e947ae
	Namespace: newworld_train
	Checksum: 0x9033CDAC
	Offset: 0xC9F0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_11e947ae()
{
	wait(30);
	level.var_fc1953ce.var_c795bf9b = 0;
}

/*
	Name: function_8e9219f
	Namespace: newworld_train
	Checksum: 0x8696F488
	Offset: 0xCA18
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_8e9219f()
{
	if(isdefined(self.var_470b117b) && self.var_470b117b)
	{
		return;
	}
	self.var_470b117b = 1;
	n_line = randomintrange(0, 3);
	switch(n_line)
	{
		case 0:
		{
			level.var_fc1953ce dialog::say("tayr_watch_the_civs_you_0", 0.5, 1, self);
			break;
		}
		case 1:
		{
			level.var_fc1953ce dialog::say("tayr_this_may_be_sim_but_0", 0.5, 1, self);
			break;
		}
		case 2:
		{
			level.var_fc1953ce dialog::say("tayr_if_this_shit_was_rea_0", 0.5, 1, self);
			break;
		}
	}
	self thread function_999e5485();
}

/*
	Name: function_999e5485
	Namespace: newworld_train
	Checksum: 0xD99FD7E0
	Offset: 0xCB48
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function function_999e5485()
{
	self endon(#"death");
	wait(30);
	self.var_470b117b = 0;
}

/*
	Name: function_783ceb85
	Namespace: newworld_train
	Checksum: 0x17A1C407
	Offset: 0xCB70
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_783ceb85()
{
	level.var_fc1953ce dialog::say("tayr_watch_your_flank_th_0", undefined, 1);
}

/*
	Name: function_123070a9
	Namespace: newworld_train
	Checksum: 0x7C6732AB
	Offset: 0xCBA8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_123070a9()
{
	s_org = struct::get("train_lockdown_vo", "targetname");
	e_org = spawn("script_origin", (-20881, 15612, 4267));
	while(!level flag::get("stop_train_lockdown_vo"))
	{
		e_org dialog::say("trai_warning_train_going_0", undefined, 1);
		wait(5);
	}
	e_org delete();
}

/*
	Name: function_9f8dbaa2
	Namespace: newworld_train
	Checksum: 0x1CB9356B
	Offset: 0xCC78
	Size: 0x11C
	Parameters: 2
	Flags: Linked
*/
function function_9f8dbaa2(var_81a32895, var_2380d5c)
{
	self endon(#"hash_848a4771");
	level.var_fc1953ce dialog::say("tayr_use_concussive_wave_0", undefined, 1, self);
	self flag::set("concussive_wave_tutorial_vo_complete");
	weapon = newworld_util::function_71840183(var_81a32895, var_2380d5c);
	var_12b288c7 = weapon.name + "_fired";
	var_a2cc98e = var_81a32895 + "_use_ability_tutorial";
	var_b41e8e5c = var_81a32895 + "_WW_tutorial";
	self thread function_32b93f59(var_b41e8e5c, var_a2cc98e);
	self thread function_3fbeb972(var_12b288c7);
}

/*
	Name: function_32b93f59
	Namespace: newworld_train
	Checksum: 0x6FF98EEC
	Offset: 0xCDA0
	Size: 0x1A6
	Parameters: 2
	Flags: Linked
*/
function function_32b93f59(var_b41e8e5c, var_a2cc98e)
{
	level endon(#"hash_70ca9767");
	self endon(var_a2cc98e);
	self endon(#"death");
	if(!self flag::exists(var_b41e8e5c))
	{
		return;
	}
	self flag::wait_till(var_b41e8e5c);
	wait(10);
	if(self flag::get(var_a2cc98e))
	{
		return;
	}
	n_line = randomintrange(0, 4);
	switch(n_line)
	{
		case 0:
		{
			level.var_fc1953ce dialog::say("tayr_one_concussive_wave_0", undefined, 1, self);
			break;
		}
		case 1:
		{
			level.var_fc1953ce dialog::say("tayr_let_me_see_you_can_d_0", undefined, 1, self);
			break;
		}
		case 2:
		{
			level.var_fc1953ce dialog::say("tayr_quit_dicking_around_0", undefined, 1, self);
			break;
		}
		case 3:
		{
			level.var_fc1953ce dialog::say("tayr_concussive_wave_is_o_0", undefined, 1, self);
			break;
		}
	}
}

/*
	Name: function_3fbeb972
	Namespace: newworld_train
	Checksum: 0xB3BE972B
	Offset: 0xCF50
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function function_3fbeb972(var_12b288c7)
{
	self endon(#"death");
	level endon(#"hash_70ca9767");
	self waittill(#"hash_f045e164");
	wait(0.75);
	n_line = randomintrange(0, 3);
	switch(n_line)
	{
		case 0:
		{
			level.var_fc1953ce dialog::say("tayr_fuck_yes_you_re_a_0", undefined, 1, self);
			break;
		}
		case 1:
		{
			level.var_fc1953ce dialog::say("tayr_see_how_that_just_to_0", undefined, 1, self);
			break;
		}
		case 2:
		{
			level.var_fc1953ce dialog::say("tayr_shock_and_awe_newbl_0", undefined, 1, self);
			break;
		}
	}
	self util::delay(30, "death", &function_7bece35e);
}

/*
	Name: function_7bece35e
	Namespace: newworld_train
	Checksum: 0x2EB6D0D6
	Offset: 0xD0A0
	Size: 0x188
	Parameters: 0
	Flags: Linked
*/
function function_7bece35e()
{
	self endon(#"death");
	level endon(#"hash_70ca9767");
	while(true)
	{
		self waittill(#"hash_f045e164");
		wait(0.75);
		if(isdefined(level.var_fc1953ce.is_talking) && level.var_fc1953ce.is_talking)
		{
			continue;
		}
		if(isdefined(level.var_fc1953ce.var_c795bf9b) && level.var_fc1953ce.var_c795bf9b)
		{
			continue;
		}
		level.var_fc1953ce.var_c795bf9b = 1;
		n_line = randomintrange(0, 3);
		switch(n_line)
		{
			case 0:
			{
				level.var_fc1953ce dialog::say("tayr_fuck_yes_you_re_a_0", undefined, 1);
				break;
			}
			case 1:
			{
				level.var_fc1953ce dialog::say("tayr_see_how_that_just_to_0", undefined, 1);
				break;
			}
			case 2:
			{
				level.var_fc1953ce dialog::say("tayr_shock_and_awe_newbl_0", undefined, 1);
				break;
			}
		}
		level thread function_631b737f();
	}
}

/*
	Name: function_631b737f
	Namespace: newworld_train
	Checksum: 0x415058E7
	Offset: 0xD230
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_631b737f()
{
	wait(30);
	level.var_fc1953ce.var_c795bf9b = 0;
}

/*
	Name: function_a9baa4e3
	Namespace: newworld_train
	Checksum: 0x282B555A
	Offset: 0xD258
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function function_a9baa4e3()
{
	if(sessionmodeiscampaignzombiesgame())
	{
		return;
	}
	level flag::init("dni_supercomputer_vo_complete");
	trigger::wait_till("dni_supercomputer_vo");
	level thread objectives::breadcrumb("breadcrumb_helper_find_bomb");
	level.var_fc1953ce dialog::say("tayr_the_neural_network_p_0", undefined, 1);
	level.var_fc1953ce dialog::say("tayr_you_better_pick_up_t_0", 0.5, 1);
	level flag::set("dni_supercomputer_vo_complete");
}

/*
	Name: function_f7302a65
	Namespace: newworld_train
	Checksum: 0xBD16C518
	Offset: 0xD348
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_f7302a65()
{
	wait(0.25);
	level.var_fc1953ce dialog::say("tayr_you_got_hostiles_cli_0", undefined, 1);
}

/*
	Name: function_13b3e595
	Namespace: newworld_train
	Checksum: 0xE5E67B9E
	Offset: 0xD388
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_13b3e595()
{
	trigger::wait_till("player_near_last_car_VO");
	level.var_fc1953ce dialog::say("tayr_keep_pushing_up_you_0", undefined, 1);
}

/*
	Name: function_f26eff53
	Namespace: newworld_train
	Checksum: 0x5B186BF6
	Offset: 0xD3D8
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_f26eff53()
{
	self endon(#"death");
	if(isdefined(self.var_cd9625d0) && self.var_cd9625d0)
	{
		return;
	}
	if(!isdefined(self.var_bd355621))
	{
		self.var_bd355621 = array("tayr_watch_your_step_try_0", "tayr_you_fall_here_you_ge_0", "tayr_pick_yourself_up_and_0");
	}
	wait(0.5);
	str_line = array::pop(self.var_bd355621, randomintrange(0, self.var_bd355621.size), 0);
	if(self.var_bd355621.size == 0)
	{
		self.var_bd355621 = undefined;
	}
	level.var_fc1953ce dialog::say(str_line, undefined, 1, self);
	self thread function_d9c04d31();
}

/*
	Name: function_d9c04d31
	Namespace: newworld_train
	Checksum: 0xEEC328EE
	Offset: 0xD4E8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_d9c04d31()
{
	self endon(#"death");
	self.var_cd9625d0 = 1;
	wait(30);
	self.var_cd9625d0 = 0;
}

/*
	Name: debug_link_probe
	Namespace: newworld_train
	Checksum: 0xCD6905C6
	Offset: 0xD520
	Size: 0xD8
	Parameters: 1
	Flags: None
*/
function debug_link_probe(e_probe)
{
	/#
		while(isdefined(e_probe) && isdefined(self))
		{
			line(e_probe.origin, self.origin, (1, 0, 0), 0.1);
			debug::debug_sphere(e_probe.origin, 16, (1, 0, 0), 0.5, 1);
			debug::drawarrow(self.origin, self.angles);
			debug::drawarrow(e_probe.origin, e_probe.angles);
			wait(0.05);
		}
	#/
}

