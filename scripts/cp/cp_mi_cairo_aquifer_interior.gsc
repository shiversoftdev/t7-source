// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_debug;
#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_cairo_aquifer_objectives;
#using scripts\cp\cp_mi_cairo_aquifer_sound;
#using scripts\cp\cp_mi_cairo_aquifer_utility;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace cp_mi_cairo_aquifer_interior;

/*
	Name: post_breach_setup
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0xA6C0236F
	Offset: 0xA20
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function post_breach_setup()
{
	aquifer_util::toggle_interior_doors(1);
	guy = aquifer_obj::spawnhendricksifneeded("hendricks_hangar");
	guy util::magic_bullet_shield();
	guy.script_ignoreme = 1;
	guy.baseaccuracy = 0.25;
	level.hendricks thread dialog::say("hend_maretti_s_escaping_t_0");
	clientfield::set("hide_sand_storm", 1);
	thread hangar_combat();
	thread chase_vo();
	thread function_2fde871a();
	thread handle_round_room();
}

/*
	Name: hangar_combat
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0x10AE76FE
	Offset: 0xB28
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function hangar_combat()
{
	thread handle_hangar_extras();
	util::delay(5, undefined, &scene::init, "cin_aqu_07_not_yourself_3rd_shot010");
	spawn_manager::wait_till_complete("main_hangar_enemies");
	guys = spawn_manager::get_ai("main_hangar_enemies");
	spawn_manager::wait_till_ai_remaining("main_hangar_enemies", int(max(2, int(guys.size / 3))));
	thread aquifer_util::safe_use_trigger("extras_exposed");
	thread aquifer_util::safe_use_trigger("hendricks_move_up_hangar");
	util::delay(1, undefined, &trigger::use, "hangar_enemies_exposed", "targetname");
	spawn_manager::wait_till_cleared("main_hangar_enemies");
	level.hendricks.baseaccuracy = 10;
	spawn_manager::wait_till_cleared("hangar_breach_extras");
	level flag::set("start_interior_breadcrumbs");
	trigger::use("hendricks_leave_hangar", "targetname");
	level.hendricks battlechatter::function_d9f49fba(0);
	level.hendricks.baseaccuracy = 0.25;
}

/*
	Name: function_2fde871a
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0x2FD97059
	Offset: 0xD30
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_2fde871a()
{
	level flag::wait_till_any(array("start_interior_breadcrumbs", "chase_vo1"));
	objectives::breadcrumb("start_interior_breadcrumbs");
}

/*
	Name: function_2fc2978c
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0xACB8793D
	Offset: 0xD88
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function function_2fc2978c()
{
	a_spawn_managers = getentarray("spawn_manager", "classname");
	foreach(sm in a_spawn_managers)
	{
		if(sm.name === "pre_boss_enemies")
		{
			sm.script_wait_min = 1.5;
		}
	}
}

/*
	Name: handle_prometheus_flee
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0x27AAC76
	Offset: 0xE60
	Size: 0xAC
	Parameters: 0
	Flags: None
*/
function handle_prometheus_flee()
{
	util::magic_bullet_shield(self);
	ai::createinterfaceforentity(self);
	self ai::set_behavior_attribute("sprint", 1);
	self ai::disable_pain();
	trigger::use("promethius_flee_hangar", "targetname");
	self waittill(#"goal");
	self delete();
}

/*
	Name: handle_hangar_extras
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0xE6E19F7A
	Offset: 0xF18
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function handle_hangar_extras()
{
	spawn_manager::enable("hangar_breach_extras");
	spawn_manager::wait_till_complete("hangar_breach_extras");
	spawn_manager::wait_till_ai_remaining("hangar_breach_extras", 2);
	trigger::use("extras_exposed");
}

/*
	Name: function_3fd5eb17
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0xEA546A42
	Offset: 0xF90
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function function_3fd5eb17()
{
	util::screen_fade_out(0.25, "white");
	wait(0.25);
	util::screen_fade_in(2, "white");
}

/*
	Name: handle_round_room
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0x28AA47DC
	Offset: 0xFE8
	Size: 0x314
	Parameters: 0
	Flags: Linked
*/
function handle_round_room()
{
	var_87942fa5 = getentarray("icy", "targetname");
	array::run_all(var_87942fa5, &hide);
	level flag::wait_till("snow_vo");
	savegame::checkpoint_save();
	level thread dialog::remote("corv_let_your_mind_relax_2", undefined, "corvus");
	level flag::wait_till("flag_snow_room");
	if(isdefined(level.bzm_aquiferdialogue3_1callback))
	{
		level thread [[level.bzm_aquiferdialogue3_1callback]]();
	}
	exploder::exploder("amb_int_tank_room");
	array::thread_all(level.activeplayers, &aquifer_util::function_89eaa1b3, 1);
	wait(1);
	array::thread_all(level.activeplayers, &aquifer_util::function_716b5d66, 1);
	wait(5);
	level flag::wait_till_clear("flag_snow_room");
	exploder::exploder_stop("amb_int_tank_room");
	array::thread_all(level.activeplayers, &aquifer_util::function_89eaa1b3, 1);
	wait(1);
	array::thread_all(level.activeplayers, &aquifer_util::function_716b5d66, 0);
	level.hendricks battlechatter::function_d9f49fba(1);
	level flag::wait_till("exit_round_room");
	level.hendricks battlechatter::function_d9f49fba(0);
	level.hendricks ai::set_ignoreall(1);
	guys1 = spawn_manager::get_ai("roundroom_allies");
	guys2 = spawn_manager::get_ai("roundroom_enemies");
	guys = arraycombine(guys1, guys2, 1, 1);
	array::thread_all(guys, &aquifer_util::delete_me);
}

/*
	Name: handle_hideout
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0x26F720B3
	Offset: 0x1308
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function handle_hideout(b_starting = 0)
{
	if(!b_starting)
	{
		aquifer_util::toggle_door("hideout_door", 1);
		aquifer_util::toggle_door("hideout_doors_closed", 1);
	}
	if(isdefined(level.bzm_aquiferdialogue7callback))
	{
		level thread [[level.bzm_aquiferdialogue7callback]]();
	}
	aquifer_obj::function_f67ca613(1);
	scene::play("cin_aqu_16_outro_3rd_sh010", level.hendricks);
	level waittill(#"hideout_scene_done");
	level thread namespace_71a63eac::function_a1e074db();
	util::teleport_players_igc("post_hideout_igc");
}

/*
	Name: function_ff024877
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0x9642F7C4
	Offset: 0x1400
	Size: 0x276
	Parameters: 0
	Flags: Linked
*/
function function_ff024877()
{
	thread aquifer_util::toggle_door("hideout_door", 0);
	thread aquifer_util::toggle_door("hideout_doors_closed", 0);
	thread aquifer_obj::function_e2d8799f(1);
	thread aquifer_obj::function_5d32874c(1);
	thread leave_hideout_scene();
	skipto::objective_completed("hideout");
	savegame::checkpoint_save();
	array::run_all(level.activeplayers, &setmovespeedscale, 0.7);
	thread function_291b34c9();
	thread function_c48c4f99();
	thread escape_vo();
	thread function_3a77d1bf();
	var_8a6d11 = function_246476fd(0, "cin_aqu_07_10_escape_vign_run_hendricks_a", "cin_aqu_07_10_escape_vign_wait_hendricks_a", "cin_aqu_07_10_escape_vign_wait_loop_hendricks_a", "run_out_cinematic1", 1, "hend_runout_a");
	var_8a6d11 = function_246476fd(var_8a6d11, "cin_aqu_07_10_escape_vign_run_hendricks_b", "cin_aqu_07_10_escape_vign_wait_hendricks_b", "cin_aqu_07_10_escape_vign_wait_loop_hendricks_a", "run_out_cinematic1", 1, "hend_runout_b");
	var_8a6d11 = function_246476fd(var_8a6d11, "cin_aqu_07_10_escape_vign_run_hendricks_c", "cin_aqu_07_10_escape_vign_wait_hendricks_c", "cin_aqu_07_10_escape_vign_wait_loop_hendricks_a", "run_out_cinematic1", 1, "hend_runout_c");
	var_8a6d11 = function_246476fd(var_8a6d11, "cin_aqu_07_10_escape_vign_run_hendricks_d", "cin_aqu_07_10_escape_vign_wait_hendricks_d", "cin_aqu_07_10_escape_vign_wait_loop_hendricks_a", "run_out_cinematic2", 1, "hend_runout_d");
	if(var_8a6d11)
	{
		var_8a6d11 = function_246476fd(var_8a6d11, "cin_aqu_07_10_escape_vign_run_hendricks_e", undefined, undefined, "run_out_cinematic2", 0, undefined);
	}
	level.hendricks.n_script_anim_rate = undefined;
}

/*
	Name: function_3a77d1bf
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0x541D4435
	Offset: 0x1680
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_3a77d1bf()
{
	struct = getent("run_out_cinematic2", "targetname");
	struct scene::init("cin_aqu_07_10_escape_vign_crush_death_ally");
	level waittill(#"collapse");
	thread aquifer_util::toggle_door("ceiling_ac_unit", 1);
	struct scene::play("cin_aqu_07_10_escape_vign_crush_death_ally");
}

/*
	Name: function_64386226
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0xC5A082EF
	Offset: 0x1720
	Size: 0x40
	Parameters: 0
	Flags: None
*/
function function_64386226()
{
	level endon(#"hash_a384e425");
	while(true)
	{
		level waittill(#"collapse");
		iprintlnbold("COLLAPSE START");
	}
}

/*
	Name: function_291b34c9
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0x2DFEDA84
	Offset: 0x1768
	Size: 0x278
	Parameters: 0
	Flags: Linked
*/
function function_291b34c9()
{
	level endon(#"hash_a384e425");
	while(true)
	{
		level waittill(#"shake");
		earthquake(0.5, 2, level.hendricks.origin, 1000);
		level thread cp_mi_cairo_aquifer_sound::function_5d0cee98();
		staggers = array("pb_aqu_07_10_escape_vign_stagger_l_player", "pb_aqu_07_10_escape_vign_stagger_r_player");
		array::run_all(level.activeplayers, &setmovespeedscale, 0.5);
		array::run_all(level.activeplayers, &allowsprint, 0);
		foreach(player in level.activeplayers)
		{
			anim_name = array::random(staggers);
			player thread animation::play(anim_name, player.origin, player.angles, 1, 0, 0, 0);
		}
		array::run_all(level.activeplayers, &setmovespeedscale, 0.2);
		wait(0.8);
		array::run_all(level.activeplayers, &setmovespeedscale, 0.7);
		array::run_all(level.activeplayers, &allowsprint, 1);
	}
}

/*
	Name: function_c48c4f99
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0x3C046076
	Offset: 0x19E8
	Size: 0x1EA
	Parameters: 0
	Flags: Linked
*/
function function_c48c4f99()
{
	level endon(#"hash_a384e425");
	while(true)
	{
		level util::delay_notify(randomfloatrange(2, 5), "minishake", "shake");
		ret = level util::waittill_any_return("shake", "minishake");
		if(ret == "minishake")
		{
			exploder::exploder("cin_runout_rattles");
			earthquake(randomfloatrange(0.3, 0.4), 1.25, level.hendricks.origin, 1000);
			level thread cp_mi_cairo_aquifer_sound::function_f8835fe9();
			array::run_all(level.activeplayers, &setmovespeedscale, 0.5);
			array::run_all(level.activeplayers, &allowsprint, 0);
			wait(0.25);
			array::run_all(level.activeplayers, &setmovespeedscale, 0.7);
			array::run_all(level.activeplayers, &allowsprint, 1);
		}
		else
		{
			wait(3);
		}
	}
}

/*
	Name: hideout_scene
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0x2E4FB903
	Offset: 0x1BE0
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function hideout_scene()
{
	level.hendricks dialog::say("hend_kane_we_re_uploadin_0");
	level dialog::remote("kane_got_it_good_work_0");
	level dialog::remote("kane_the_nrc_have_capture_0");
}

/*
	Name: leave_hideout_scene
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0xB2F4EC3B
	Offset: 0x1C50
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function leave_hideout_scene()
{
	level thread cp_mi_cairo_aquifer_sound::function_b01c9f8();
	level dialog::remote("kane_the_nrc_have_launche_0");
	level dialog::player_say("plyr_don_t_need_to_tell_u_1");
}

/*
	Name: function_246476fd
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0x1D736380
	Offset: 0x1CB8
	Size: 0x290
	Parameters: 7
	Flags: Linked
*/
function function_246476fd(var_8a6d11, var_f17304b7, var_75422735, var_b6b983f4, struct_name, var_2d3b4a98, waitflag)
{
	struct = getent(struct_name, "targetname");
	var_482ba61c = 1.2;
	level.hendricks.n_script_anim_rate = var_482ba61c;
	if(var_8a6d11)
	{
		struct scene::init(var_f17304b7, level.hendricks);
		level waittill(#"hash_20aa8e12");
	}
	scene::add_scene_func(var_f17304b7, &function_8ed6a39f, "done");
	struct thread scene::play(var_f17304b7, level.hendricks);
	ret = level util::waittill_any_return(waitflag, "splice", "run_scene_done");
	if(isdefined(var_75422735) && isdefined(var_b6b983f4) && isdefined(waitflag) && (ret == "splice" || ret == "run_scene_done") && !level flag::get(waitflag))
	{
		struct scene::stop(var_f17304b7, 0);
		struct scene::play(var_75422735, level.hendricks);
		level.hendricks.n_script_anim_rate = undefined;
		if(var_2d3b4a98)
		{
			level.hendricks thread scene::play(var_b6b983f4, level.hendricks);
		}
		else
		{
			struct thread scene::play(var_b6b983f4, level.hendricks);
		}
		level flag::wait_till(waitflag);
		level.hendricks stopanimscripted();
		return true;
	}
	struct waittill(#"scene_done");
	return false;
}

/*
	Name: function_8ed6a39f
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0xF132EA5C
	Offset: 0x1F58
	Size: 0x1A
	Parameters: 1
	Flags: Linked
*/
function function_8ed6a39f(a_ents)
{
	level notify(#"hash_81d7addc");
}

/*
	Name: chase_vo
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0x27FCAFD7
	Offset: 0x1F80
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function chase_vo()
{
	level flag::wait_till("chase_vo1");
	savegame::checkpoint_save();
	level.hendricks thread dialog::say("hend_maretti_went_this_wa_0");
	level flag::wait_till("chase_vo2");
	level.hendricks thread dialog::say("hend_move_faster_we_can_0");
	level flag::wait_till("chase_vo3");
	level dialog::player_say("plyr_hendricks_0");
	level dialog::player_say("plyr_slow_down_0", 2);
	level dialog::player_say("plyr_hey_listen_to_me_0", 2);
}

/*
	Name: escape_vo
	Namespace: cp_mi_cairo_aquifer_interior
	Checksum: 0xA760B906
	Offset: 0x20A0
	Size: 0x34E
	Parameters: 0
	Flags: Linked
*/
function escape_vo()
{
	var_296988d3 = [];
	if(!isdefined(var_296988d3))
	{
		var_296988d3 = [];
	}
	else if(!isarray(var_296988d3))
	{
		var_296988d3 = array(var_296988d3);
	}
	var_296988d3[var_296988d3.size] = "plyr_we_need_to_get_back_0";
	if(!isdefined(var_296988d3))
	{
		var_296988d3 = [];
	}
	else if(!isarray(var_296988d3))
	{
		var_296988d3 = array(var_296988d3);
	}
	var_296988d3[var_296988d3.size] = "kane_you_need_to_get_out_0";
	if(!isdefined(var_296988d3))
	{
		var_296988d3 = [];
	}
	else if(!isarray(var_296988d3))
	{
		var_296988d3 = array(var_296988d3);
	}
	var_296988d3[var_296988d3.size] = "hend_keep_moving_this_pl_0";
	if(!isdefined(var_296988d3))
	{
		var_296988d3 = [];
	}
	else if(!isarray(var_296988d3))
	{
		var_296988d3 = array(var_296988d3);
	}
	var_296988d3[var_296988d3.size] = "skip";
	if(!isdefined(var_296988d3))
	{
		var_296988d3 = [];
	}
	else if(!isarray(var_296988d3))
	{
		var_296988d3 = array(var_296988d3);
	}
	var_296988d3[var_296988d3.size] = "hend_watch_out_1";
	if(!isdefined(var_296988d3))
	{
		var_296988d3 = [];
	}
	else if(!isarray(var_296988d3))
	{
		var_296988d3 = array(var_296988d3);
	}
	var_296988d3[var_296988d3.size] = "hend_keep_up_0";
	for(i = 0; i < var_296988d3.size; i++)
	{
		level waittill(#"shake");
		wait(2);
		if(var_296988d3[i] != "skip")
		{
			if(i == 0)
			{
				dialog::player_say(var_296988d3[i]);
				continue;
			}
			if(i == 1)
			{
				level dialog::remote(var_296988d3[i]);
				i++;
				level.hendricks dialog::say(var_296988d3[i]);
				continue;
			}
			level.hendricks dialog::say(var_296988d3[i]);
		}
	}
}

