// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_zurich_coalescence_sound;
#using scripts\cp\cp_mi_zurich_coalescence_util;
#using scripts\cp\cp_mi_zurich_coalescence_zurich_city;
#using scripts\cp\cp_mi_zurich_coalescence_zurich_plaza_battle;
#using scripts\cp\cp_mi_zurich_coalescence_zurich_street;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zurich_rails;

/*
	Name: skipto_main
	Namespace: zurich_rails
	Checksum: 0x82E5FF28
	Offset: 0x828
	Size: 0x4A4
	Parameters: 2
	Flags: Linked
*/
function skipto_main(str_objective, b_starting)
{
	spawner::add_spawn_function_group("plaza_battle_boss", "targetname", &zurich_plaza_battle::function_8fdd138);
	spawner::add_spawn_function_group("plaza_battle_intro_redshirts", "targetname", &zurich_plaza_battle::function_adfa2b54);
	if(b_starting)
	{
		load::function_73adcefc();
		zurich_util::init_kane(str_objective, 1);
		zurich_util::function_c049667c(1);
		trigger::use("garage_kane_exit_colortrig");
		scene::add_scene_func("p7_fxanim_cp_zurich_car_crash_03_bundle", &zurich_street::function_5d018732, "done");
		level thread scene::skipto_end("p7_fxanim_cp_zurich_car_crash_03_bundle");
		level thread scene::skipto_end("p7_fxanim_cp_zurich_car_crash_04_bundle");
		level thread scene::skipto_end("p7_fxanim_cp_zurich_car_crash_05_bundle");
		umbragate_set("garage_umbra_gate", 1);
		level flag::set("garage_gate_open");
		exploder::exploder("streets_tower_wasp_swarm");
		level clientfield::set("zurich_city_ambience", 1);
		level thread zurich_street::init_elevators();
		load::function_a2995f22();
		level flag::set("rails_triage_regroup_start");
		level flag::set("flag_start_kane_it_won_t_vo_done");
	}
	scene::add_scene_func("p7_fxanim_cp_zurich_coalescence_tower_door_open_bundle", &zurich_util::function_162b9ea0, "init");
	level scene::init("p7_fxanim_cp_zurich_coalescence_tower_door_open_bundle");
	array::thread_all(level.players, &function_d5b7d39e);
	level thread function_302750ab();
	level thread namespace_67110270::function_99ab0b3b();
	battlechatter::function_d9f49fba(0);
	if(isdefined(level.bzm_zurichdialogue1_2callback))
	{
		level thread [[level.bzm_zurichdialogue1_2callback]]();
	}
	level thread function_51e389ee(b_starting);
	level.var_438d2fd9 = [];
	level.ai_boss = spawner::simple_spawn_single("plaza_battle_boss");
	level notify(#"hash_4f700a7e");
	level thread zurich_util::function_2361541e("rails");
	level thread zurich_util::function_1eb6ea27("plaza_battle_intro_zone_trig", "rails");
	level.ai_kane ai::set_ignoreall(1);
	level.ai_kane ai::set_ignoreme(1);
	level.ai_kane thread zurich_util::function_2a6e38e();
	zurich_util::function_c049667c(0);
	level thread function_5ea42950();
	trigger::wait_till("rails_exit_zone_trig");
	spawn_manager::enable("plaza_battle_allies_left_spawn_manager");
	spawn_manager::enable("plaza_battle_allies_right_spawn_manager");
	skipto::objective_completed(str_objective);
}

/*
	Name: skipto_done
	Namespace: zurich_rails
	Checksum: 0xD3A5294F
	Offset: 0xCD8
	Size: 0x5C
	Parameters: 4
	Flags: Linked
*/
function skipto_done(str_objective, b_starting, b_direct, player)
{
	zurich_util::enable_surreal_ai_fx(0);
	level.var_ebb30c1a = undefined;
	zurich_city::function_9b46fb9();
}

/*
	Name: function_51e389ee
	Namespace: zurich_rails
	Checksum: 0xAE9D89DD
	Offset: 0xD40
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function function_51e389ee(b_starting)
{
	if(b_starting)
	{
		objectives::set("cp_level_zurich_assault_hq_obj");
		trigger::wait_till("garage_exit_zone_trig");
		objectives::breadcrumb("garage_kane_rooftop_colortrig", "cp_waypoint_breadcrumb");
		objectives::hide("cp_level_zurich_assault_hq_obj");
		objectives::set("cp_level_zurich_assault_hq_awaiting_obj");
	}
	else
	{
		trigger::wait_till("rails_train_enter_colortrig");
		objectives::hide("cp_level_zurich_assault_hq_obj");
		objectives::show("cp_level_zurich_assault_hq_awaiting_obj");
	}
}

/*
	Name: function_302750ab
	Namespace: zurich_rails
	Checksum: 0x49043B59
	Offset: 0xE30
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_302750ab()
{
	level flag::wait_till_all(array("flag_start_kane_it_won_t_vo_done", "flag_zurich_rails_vo_01"));
	level.ai_kane dialog::say("kane_so_much_chaos_so_0");
	level dialog::player_say("plyr_we_will_stop_him_kan_0", 0.8);
	if(!level flag::get("plaza_battle_train_exit_reached"))
	{
		level.ai_kane dialog::say("kane_once_he_s_dealt_with_0", 0.4);
		level dialog::player_say("plyr_i_told_you_i_d_find_0", 0.6);
	}
	if(!level flag::get("plaza_battle_train_exit_reached"))
	{
		level flag::wait_till("flag_zurich_rails_vo_02");
		level.ai_kane dialog::say("kane_coalescence_building_0", 1);
		level dialog::player_say("plyr_i_can_see_it_kane_0", 1);
	}
}

/*
	Name: function_5ea42950
	Namespace: zurich_rails
	Checksum: 0x8F67466B
	Offset: 0xFB0
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_5ea42950()
{
	level endon(#"hash_a835a95b");
	nd_spline = getvehiclenode("rails_hunter_spline", "targetname");
	s_look = struct::get("rails_hunter_look_spot");
	while(!zurich_util::function_f8645b6(-1, s_look.origin, 0.6))
	{
		wait(0.05);
	}
	ai_hunter = nd_spline zurich_util::function_a569867c();
	ai_hunter vehicle::god_on();
	ai_hunter waittill(#"reached_end_node");
	ai_hunter delete();
}

/*
	Name: function_d5b7d39e
	Namespace: zurich_rails
	Checksum: 0xEC7BE583
	Offset: 0x10B8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_d5b7d39e()
{
	level endon(#"hash_a835a95b");
	trigger::wait_till("trig_rails_hallucination", "targetname", self);
	self clientfield::increment_to_player("postfx_hallucinations", 1);
	wait(0.8);
	visionset_mgr::activate("visionset", "cp_zurich_hallucination", self);
	self playsoundtoplayer("vox_dying_infected_after", self);
	wait(1.4);
	visionset_mgr::deactivate("visionset", "cp_zurich_hallucination", self);
}

