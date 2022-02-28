// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_collectibles;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_cairo_ramses_accolades;
#using scripts\cp\cp_mi_cairo_ramses_fx;
#using scripts\cp\cp_mi_cairo_ramses_level_start;
#using scripts\cp\cp_mi_cairo_ramses_nasser_interview;
#using scripts\cp\cp_mi_cairo_ramses_patch;
#using scripts\cp\cp_mi_cairo_ramses_sound;
#using scripts\cp\cp_mi_cairo_ramses_station_fight;
#using scripts\cp\cp_mi_cairo_ramses_station_walk;
#using scripts\cp\cp_mi_cairo_ramses_utility;
#using scripts\cp\cp_mi_cairo_ramses_vtol_ride;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\compass;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_quadtank;

#namespace cp_mi_cairo_ramses;

/*
	Name: setup_rex_starts
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xE4511BD8
	Offset: 0x980
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function setup_rex_starts()
{
	util::add_gametype("coop");
	util::add_gametype("cpzm");
}

/*
	Name: main
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x5A57B5B8
	Offset: 0x9C0
	Size: 0x23C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	if(sessionmodeiscampaignzombiesgame() && -1)
	{
		setclearanceceiling(34);
	}
	else
	{
		setclearanceceiling(23);
	}
	savegame::set_mission_name("ramses");
	namespace_38256252::function_4d39a2af();
	namespace_38256252::function_43898266();
	namespace_38256252::function_e1862c87();
	namespace_38256252::function_3484502e();
	precache();
	init_clientfields();
	init_flags();
	init_level();
	setup_skiptos();
	util::init_streamer_hints(3);
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	vehicle::add_spawn_function("station_fight_turret", &station_turret_spawnfunc);
	cp_mi_cairo_ramses_fx::main();
	cp_mi_cairo_ramses_sound::main();
	load::main();
	setdvar("compassmaxrange", "12000");
	level clientfield::set("ramses_station_lamps", 1);
	/#
		execdevgui("");
	#/
	level thread set_sound_igc();
	level.var_dc236bc8 = 1;
	namespace_e9e39773::function_7403e82b();
}

/*
	Name: precache
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x99EC1590
	Offset: 0xC08
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache()
{
}

/*
	Name: init_clientfields
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x368B3596
	Offset: 0xC18
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	clientfield::register("world", "hide_station_miscmodels", 1, 1, "int");
	clientfield::register("world", "turn_on_rotating_fxanim_fans", 1, 1, "int");
	clientfield::register("world", "turn_on_rotating_fxanim_lights", 1, 1, "int");
	clientfield::register("world", "delete_fxanim_fans", 1, 1, "int");
	clientfield::register("toplayer", "nasser_interview_extra_cam", 1, 1, "int");
	clientfield::register("toplayer", "rap_blood_on_player", 1, 1, "counter");
	clientfield::register("world", "ramses_station_lamps", 1, 1, "int");
	clientfield::register("world", "staging_area_intro", 1, 1, "int");
	clientfield::register("toplayer", "filter_ev_interference_toggle", 1, 1, "int");
}

/*
	Name: init_flags
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xCFBC5F8E
	Offset: 0xDD8
	Size: 0x204
	Parameters: 0
	Flags: Linked
*/
function init_flags()
{
	level flag::init("dead_turrets_initialized");
	level flag::init("dead_turret_stop_station_ambients");
	level flag::init("station_walk_past_stairs");
	level flag::init("station_walk_complete");
	level flag::init("station_walk_cleanup");
	level flag::init("raps_intro_done");
	level flag::init("pod_hits_floor");
	level flag::init("ceiling_collapse_complete");
	level flag::init("drop_pod_opened_and_spawned");
	level flag::init("station_fight_completed");
	level flag::init("mobile_wall_fxanim_start");
	level flag::init("vtol_ride_started");
	level flag::init("vtol_ride_done");
	level flag::init("hendricks_jumpdirect_looping");
	level flag::init("khalil_jumpdirect_looping");
	level flag::init("flak_vtol_ride_stop");
}

/*
	Name: init_level
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xD8CF3CA
	Offset: 0xFE8
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function init_level()
{
	skipto::set_skip_safehouse();
	level.b_tactical_mode_enabled = 0;
	level.b_enhanced_vision_enabled = 0;
	battlechatter::function_d9f49fba(0, "bc");
	var_69e9c588 = getentarray("mobile_armory", "script_noteworthy");
	a_ammo_cache = getentarray("ammo_cache", "script_noteworthy");
	level.var_2b205f01 = arraycombine(var_69e9c588, a_ammo_cache, 0, 0);
}

/*
	Name: station_turret_spawnfunc
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xA8A6A400
	Offset: 0x10C0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function station_turret_spawnfunc()
{
	self.team = "allies";
}

/*
	Name: setup_skiptos
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x1F861082
	Offset: 0x10E0
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function setup_skiptos()
{
	skipto::add("level_start", &skipto_level_start_init, "level_start", &skipto_level_start_done);
	skipto::add("rs_walk_through", &skipto_rs_walk_through_init, "rs_walk_through", &skipto_rs_walk_through_done);
	skipto::function_d68e678e("interview_dr_nasser", &skipto_interview_dr_nasser_init, "interview_dr_nasser", &skipto_interview_dr_nasser_done);
	skipto::function_d68e678e("defend_ramses_station", &station_fight::init, "defend_ramses_station", &station_fight::done);
	skipto::function_d68e678e("vtol_ride", &vtol_ride::init, "vtol_ride", &vtol_ride::done);
	skipto::add_dev("dev_defend_station_test", &station_fight::defend_station_test, "Defend Station Test", &station_fight::defend_station_done, "", "");
}

/*
	Name: on_player_connect
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xE367E22C
	Offset: 0x1280
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self flag::init("linked_to_truck");
}

/*
	Name: on_player_spawned
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xD200B48A
	Offset: 0x12B0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self ramses_util::set_lighting_state_on_spawn();
}

/*
	Name: skipto_level_start_init
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xA6C1E55C
	Offset: 0x12D8
	Size: 0x164
	Parameters: 2
	Flags: Linked
*/
function skipto_level_start_init(str_objective, b_starting)
{
	callback::on_spawned(&level_start::setup_players_for_station_walk);
	if(b_starting)
	{
		load::function_73adcefc();
		level_start::init_heroes(str_objective);
		ramses_util::set_lighting_state_start();
	}
	objectives::set("cp_level_ramses_determine_what_salim_knows");
	objectives::set("cp_level_ramses_meet_with_khalil");
	array::thread_all(level.var_2b205f01, &oed::disable_keyline);
	level.ai_hendricks setdedicatedshadow(1);
	level.ai_hendricks sethighdetail(1);
	level.ai_rachel sethighdetail(1);
	station_fight::intermediate_prop_state_hide();
	station_fight::hide_props("_combat");
	level_start::main();
}

/*
	Name: skipto_level_start_done
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x10485DF1
	Offset: 0x1448
	Size: 0xCC
	Parameters: 4
	Flags: Linked
*/
function skipto_level_start_done(str_objective, b_starting, b_direct, player)
{
	if(b_starting)
	{
		objectives::set("cp_level_ramses_determine_what_salim_knows");
		objectives::set("cp_level_ramses_meet_with_khalil");
	}
	station_fight::intermediate_prop_state_hide();
	station_fight::hide_props("_combat");
	ramses_util::set_lighting_state_start();
	level scene::init("cin_ram_04_02_easterncheck_vign_jumpdirect");
	level thread ramses_util::function_a0a9f927();
}

/*
	Name: skipto_rs_walk_through_init
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xEC8335C9
	Offset: 0x1520
	Size: 0x184
	Parameters: 2
	Flags: Linked
*/
function skipto_rs_walk_through_init(str_objective, b_starting)
{
	level.ai_khalil = util::get_hero("khalil");
	level.ai_khalil sethighdetail(1);
	if(b_starting)
	{
		load::function_73adcefc();
		callback::on_spawned(&level_start::setup_players_for_station_walk);
		cp_mi_cairo_ramses_station_walk::init_heroes(str_objective);
		array::thread_all(level.var_2b205f01, &oed::disable_keyline);
		load::function_a2995f22();
		util::screen_fade_out(0, "black", "skipto_fade");
		util::delay(1, undefined, &util::screen_fade_in, 1, "black", "skipto_fade");
	}
	cp_mi_cairo_ramses_nasser_interview::function_c99967dc(0);
	ramses_util::function_7255e66(0);
	cp_mi_cairo_ramses_station_walk::main();
}

/*
	Name: skipto_rs_walk_through_done
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xEFB488D2
	Offset: 0x16B0
	Size: 0x54
	Parameters: 4
	Flags: Linked
*/
function skipto_rs_walk_through_done(str_objective, b_starting, b_direct, player)
{
	objectives::complete("cp_level_ramses_go_to_holding_room");
	objectives::complete("cp_level_ramses_meet_with_khalil");
}

/*
	Name: skipto_interview_dr_nasser_init
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x8786490D
	Offset: 0x1710
	Size: 0x12C
	Parameters: 2
	Flags: Linked
*/
function skipto_interview_dr_nasser_init(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		cp_mi_cairo_ramses_nasser_interview::init_heroes();
		callback::on_spawned(&cp_mi_cairo_ramses_nasser_interview::function_1bcd464b);
		array::thread_all(level.var_2b205f01, &oed::disable_keyline);
		level.ai_khalil sethighdetail(1);
		level.ai_rachel sethighdetail(1);
		level.ai_hendricks sethighdetail(1);
	}
	objectives::set("cp_level_ramses_interrogate_salim");
	ramses_util::function_7255e66(1);
	cp_mi_cairo_ramses_nasser_interview::main(b_starting);
}

/*
	Name: skipto_interview_dr_nasser_done
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xB918AEE8
	Offset: 0x1848
	Size: 0x144
	Parameters: 4
	Flags: Linked
*/
function skipto_interview_dr_nasser_done(str_objective, b_starting, b_direct, player)
{
	if(b_starting)
	{
		array::thread_all(getentarray("mobile_armory", "script_noteworthy"), &oed::enable_keyline, 1);
		objectives::complete("cp_level_ramses_interrogate_salim");
		objectives::complete("cp_level_ramses_determine_what_salim_knows");
		objectives::set("cp_level_ramses_protect_salim");
	}
	cp_mi_cairo_ramses_station_walk::function_51f408f1();
	level util::clientnotify("walla_off");
	oed::toggle_tac_mode_for_players();
	oed::toggle_thermal_mode_for_players();
	ramses_util::function_eabc6e2f();
	ramses_util::init_dead_turrets();
	ramses_util::function_e7ebe596(0);
}

/*
	Name: set_sound_igc
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x6E5E2DA
	Offset: 0x1998
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function set_sound_igc()
{
	level waittill(#"cin_ram_01_01_enterstation_1st_ride_complete");
	level util::clientnotify("sndIGC");
}

