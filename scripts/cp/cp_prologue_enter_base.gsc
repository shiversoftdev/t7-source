// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_eth_prologue;
#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;
#using scripts\cp\cp_prologue_apc;
#using scripts\cp\cp_prologue_enter_base;
#using scripts\cp\cp_prologue_hangars;
#using scripts\cp\cp_prologue_robot_reveal;
#using scripts\cp\cp_prologue_security_camera;
#using scripts\cp\cp_prologue_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_save;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\voice\voice_prologue;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\doors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

#namespace cp_prologue_enter_base;

/*
	Name: nrc_knocking_start
	Namespace: cp_prologue_enter_base
	Checksum: 0x68A04D2F
	Offset: 0x16A8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function nrc_knocking_start()
{
	nrc_knocking_precache();
	level thread nrc_knocking_main();
}

/*
	Name: nrc_knocking_precache
	Namespace: cp_prologue_enter_base
	Checksum: 0x99EC1590
	Offset: 0x16E0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function nrc_knocking_precache()
{
}

/*
	Name: nrc_knocking_main
	Namespace: cp_prologue_enter_base
	Checksum: 0x6EE6BBE3
	Offset: 0x16F0
	Size: 0x374
	Parameters: 0
	Flags: Linked
*/
function nrc_knocking_main()
{
	level cp_prologue_util::spawn_coop_player_replacement("skipto_nrc_knocking");
	if(isdefined(level.bzmloadoutchangecallback))
	{
		level thread [[level.bzmloadoutchangecallback]]();
	}
	foreach(ai_ally in level.var_681ad194)
	{
		ai_ally.goalradius = 16;
		ai_ally setgoal(getnode(("ally0" + ai_ally.var_a89679b6) + "_start_node", "targetname"));
	}
	battlechatter::function_d9f49fba(0);
	cp_prologue_util::function_47a62798(1);
	cp_prologue_util::function_25e841ea();
	level thread function_599e2f36();
	util::delay(2, undefined, &function_b206d9a7);
	level thread function_e4486a45();
	if(isdefined(level.bzm_prologuedialogue2callback))
	{
		level thread [[level.bzm_prologuedialogue2callback]]();
	}
	spawner::waittill_ai_group_cleared("tower_guards");
	array::run_all(level.activeplayers, &util::set_low_ready, 1);
	array::thread_all(level.activeplayers, &cp_mi_eth_prologue::function_7072c5d8);
	level thread function_63075f1d();
	battlechatter::function_d9f49fba(0);
	level.ai_hendricks.allowbattlechatter["bc"] = 1;
	level thread function_127fb1fb();
	level thread function_5dc7beec();
	level thread function_a7dec0e7();
	scene::add_scene_func("cin_pro_03_01_blendin_vign_movedown_tower_hendricks", &function_c9e3016d, "play");
	scene::add_scene_func("cin_pro_03_01_blendin_vign_movedown_tower_hendricks", &function_fe6bccbc, "play");
	level scene::play("cin_pro_03_01_blendin_vign_movedown_tower_hendricks");
	level flag::wait_till("player_reached_tower_bottom");
	skipto::objective_completed("skipto_nrc_knocking");
}

/*
	Name: function_fe6bccbc
	Namespace: cp_prologue_enter_base
	Checksum: 0xD7177934
	Offset: 0x1A70
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_fe6bccbc(a_ents)
{
	level waittill(#"hash_948ccb30");
	level thread dialog::player_say("plyr_so_as_long_as_we_d_0");
}

/*
	Name: function_e4486a45
	Namespace: cp_prologue_enter_base
	Checksum: 0xDF2D7E0E
	Offset: 0x1AB0
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function function_e4486a45()
{
	level scene::init("cin_pro_02_01_knocking_vign_nrc_breach_soldiers");
	level thread scene::play("cin_pro_02_01_knocking_vign_approach_opendoor", level.ai_hendricks);
	level.ai_hendricks waittill(#"open_door");
	level.ai_hendricks setgoal(getnode("nd_nrc_knocking_hendrics_retreat", "targetname"), 1);
	level.ai_hendricks thread dialog::say("hend_let_s_get_this_done_0");
	level thread namespace_21b2c1f2::function_e245d17f();
	level.ai_hendricks.allowbattlechatter["bc"] = 0;
	battlechatter::function_d9f49fba(1);
	level thread function_d511e678();
	level thread scene::play("cin_pro_02_01_knocking_vign_nrc_breach_soldiers");
}

/*
	Name: function_d511e678
	Namespace: cp_prologue_enter_base
	Checksum: 0x806C8C85
	Offset: 0x1C00
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_d511e678()
{
	s_door_1 = struct::get("prologue_nrc_kocking_door1", "targetname");
	[[ s_door_1.c_door ]]->unlock();
	[[ s_door_1.c_door ]]->open();
	s_door_2 = struct::get("prologue_nrc_kocking_door2", "targetname");
	[[ s_door_2.c_door ]]->unlock();
	[[ s_door_2.c_door ]]->open();
	e_sight_block = getent("nrc_knocking_door_sight_clip", "targetname");
	e_sight_block delete();
}

/*
	Name: function_b206d9a7
	Namespace: cp_prologue_enter_base
	Checksum: 0x305AC48
	Offset: 0x1D10
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_b206d9a7()
{
	cp_prologue_util::function_d1f1caad("trig_control_room_exit");
	level thread scene::play("cin_pro_03_01_blendin_vign_vtol_sweep");
	level thread scene::play("p7_fxanim_cp_prologue_control_tower_ceiling_tiles_02_bundle");
	e_vtol = getent("sp_vtol_sweep_at_start_ai", "targetname");
	if(isdefined(e_vtol))
	{
		e_vtol thread cp_prologue_util::function_c56034b7();
	}
	wait(1.2);
	level thread cp_prologue_util::function_2a0bc326(level.ai_hendricks.origin, 0.1, 0.1, 1000, 20, "buzz_high");
	level thread scene::play("dead_turret_01", "targetname");
	level thread scene::play("dead_turret_02", "targetname");
	level thread scene::play("dead_turret_03", "targetname");
}

/*
	Name: blend_in_start
	Namespace: cp_prologue_enter_base
	Checksum: 0xC3957239
	Offset: 0x1E90
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function blend_in_start()
{
	blend_in_precache();
	spawner::add_spawn_function_group("start_through_take_out_guards", "script_aigroup", &set_ai_ignore);
	level thread function_bc06f066();
	level thread blend_in_main();
}

/*
	Name: blend_in_precache
	Namespace: cp_prologue_enter_base
	Checksum: 0x99EC1590
	Offset: 0x1F10
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function blend_in_precache()
{
}

/*
	Name: blend_in_main
	Namespace: cp_prologue_enter_base
	Checksum: 0xBE3019D4
	Offset: 0x1F20
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function blend_in_main()
{
	level cp_prologue_util::spawn_coop_player_replacement("skipto_blend_in");
	foreach(ai_ally in level.var_681ad194)
	{
		ai_ally ai::set_ignoreme(1);
		ai_ally ai::set_pacifist(1);
	}
	level thread function_be42a33f();
	if(isdefined(level.bzm_prologuedialogue2_1callback))
	{
		level thread [[level.bzm_prologuedialogue2_1callback]]();
	}
	cp_prologue_util::function_25e841ea();
	level thread function_e2ed5f34();
	cp_prologue_util::function_47a62798(1);
	level scene::init("cin_pro_03_02_blendin_vign_destruction_putoutfire");
	level thread function_4358b88b();
	level thread hendricks_movement_handler();
	level flag::wait_till("tower_doors_open");
	level util::clientnotify("sndCloseFT");
	level flag::wait_till("player_entering_tunnel");
	function_374cf6ee();
	skipto::objective_completed("skipto_blend_in");
}

/*
	Name: function_e2ed5f34
	Namespace: cp_prologue_enter_base
	Checksum: 0x428C610F
	Offset: 0x2140
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_e2ed5f34()
{
	self endon(#"death");
	self endon(#"objective_blend_in_done");
	level waittill(#"explosion_blast");
	wait(1.5);
	level thread objectives::breadcrumb("blending_in_breadcrumb_3");
}

/*
	Name: function_bc06f066
	Namespace: cp_prologue_enter_base
	Checksum: 0xF16258A1
	Offset: 0x2198
	Size: 0x2EC
	Parameters: 0
	Flags: Linked
*/
function function_bc06f066()
{
	level thread function_5b8bdfba();
	level flag::wait_till("tower_doors_open");
	battlechatter::function_d9f49fba(1);
	str_trig = "t_tarmac_vo_need_medic";
	a_vo_lines = array("need_medic");
	var_61ae76d5 = array("tarmac_soldier_ai");
	var_9e3b0b67 = array(0);
	level thread function_bafd79f6(str_trig, a_vo_lines, var_61ae76d5, var_9e3b0b67);
	str_trig = "t_tarmac_vo_get_the_fire_out";
	a_vo_lines = array("put_out_fire_hurry");
	var_61ae76d5 = array("tarmac_soldier_f_ai");
	var_9e3b0b67 = array(0);
	level thread function_bafd79f6(str_trig, a_vo_lines, var_61ae76d5, var_9e3b0b67);
	str_trig = "t_tarmac_vo_truck_conversation";
	a_vo_lines = array("what_happened", "dead_malfuctioned");
	var_61ae76d5 = array("tarmac_soldier_truck_02_ai", "tarmac_soldier_truck_03_ai");
	var_9e3b0b67 = array(0, 1.5);
	level thread function_bafd79f6(str_trig, a_vo_lines, var_61ae76d5, var_9e3b0b67);
	level thread function_bf532adb();
	level thread function_3eb38d8d();
	level waittill(#"explosion_blast");
	level.ai_hendricks dialog::say("hend_shit_keep_your_hea_0");
	var_49b32118 = getent("pa_vox_tarmac", "targetname");
	var_49b32118 thread dialog::say("nrcp_all_available_person_0", 2);
	level thread enter_tunnel_nag();
}

/*
	Name: function_5b8bdfba
	Namespace: cp_prologue_enter_base
	Checksum: 0xB6CF90D3
	Offset: 0x2490
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_5b8bdfba()
{
	wait(3);
	var_216b2dcb = spawn("script_origin", (-1001, -1422, 215));
	var_216b2dcb dialog::say("nrcp_all_available_person_0");
	wait(1);
	var_216b2dcb delete();
}

/*
	Name: function_e5670bf5
	Namespace: cp_prologue_enter_base
	Checksum: 0x6C697AA6
	Offset: 0x2518
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function function_e5670bf5()
{
	self endon(#"death");
	self notify(#"scriptedbc", "get_to_control_tower");
	wait(2);
	self notify(#"scriptedbc", "move_move");
	wait(1.5);
	self notify(#"scriptedbc", "more_men");
	wait(2);
	self notify(#"hash_c80e029a", "put_out_fire_men");
}

/*
	Name: function_bf532adb
	Namespace: cp_prologue_enter_base
	Checksum: 0x756A47AA
	Offset: 0x25A0
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_bf532adb()
{
	level endon(#"objective_take_out_guards_done");
	var_46100e43 = getent("t_tarmac_vo_firetruck", "targetname");
	var_46100e43 endon(#"death");
	var_46100e43 trigger::wait_till();
	var_46100e43 playsound("nrcm0_put_out_that_fire_w_0");
}

/*
	Name: function_bafd79f6
	Namespace: cp_prologue_enter_base
	Checksum: 0xD1C484DB
	Offset: 0x2628
	Size: 0xC4
	Parameters: 4
	Flags: Linked
*/
function function_bafd79f6(str_triggername, a_vo_lines, var_61ae76d5, var_9e3b0b67)
{
	self endon(#"death");
	level endon(#"objective_take_out_guards_done");
	var_46100e43 = getent(str_triggername, "targetname");
	var_a939b0c9 = var_46100e43.origin;
	level trigger::wait_till(str_triggername, "targetname", undefined, 0);
	function_f9be6553(var_a939b0c9, a_vo_lines, var_61ae76d5, var_9e3b0b67);
}

/*
	Name: function_f9be6553
	Namespace: cp_prologue_enter_base
	Checksum: 0x41EA3D8F
	Offset: 0x26F8
	Size: 0xEE
	Parameters: 4
	Flags: Linked
*/
function function_f9be6553(var_97fbbd0a, a_vo_lines, var_61ae76d5, var_9e3b0b67)
{
	level endon(#"objective_take_out_guards_done");
	for(i = 0; i < a_vo_lines.size; i++)
	{
		var_79cf4848 = getentarray(var_61ae76d5[i], "targetname");
		if(isdefined(var_79cf4848) && var_79cf4848.size > 0)
		{
			var_58c5eb41 = arraygetclosest(var_97fbbd0a, var_79cf4848);
			wait(var_9e3b0b67[i]);
			var_58c5eb41 notify(#"scriptedbc", a_vo_lines[i]);
		}
	}
}

/*
	Name: function_3eb38d8d
	Namespace: cp_prologue_enter_base
	Checksum: 0x5DF209EF
	Offset: 0x27F0
	Size: 0x2B0
	Parameters: 0
	Flags: Linked
*/
function function_3eb38d8d()
{
	nag0 = 0;
	var_5f00f64d = 12;
	nag1 = 0;
	var_38fe7be4 = 35;
	nag2 = 0;
	var_ab05eb1f = 50;
	s_struct = struct::get("s_player_exits_tower", "targetname");
	v_forward = anglestoforward(s_struct.angles);
	start_time = gettime();
	while(true)
	{
		a_players = getplayers();
		for(i = 0; i < a_players.size; i++)
		{
			v_dir = vectornormalize(s_struct.origin - a_players[i].origin);
			dp = vectordot(v_forward, v_dir);
			if(dp < 0)
			{
				return;
			}
		}
		time = gettime();
		dt = (time - start_time) / 1000;
		if(dt > var_5f00f64d && nag0 == 0)
		{
			level.ai_hendricks dialog::say("hend_on_me_nice_and_easy_0");
			nag0 = 1;
		}
		if(dt > var_38fe7be4 && nag1 == 0)
		{
			level.ai_hendricks dialog::say("hend_security_station_is_0");
			nag1 = 1;
		}
		if(dt > var_ab05eb1f && nag2 == 0)
		{
			level.ai_hendricks dialog::say("hend_keep_moving_don_t_b_0");
			nag2 = 1;
			break;
		}
		wait(0.05);
	}
}

/*
	Name: enter_tunnel_nag
	Namespace: cp_prologue_enter_base
	Checksum: 0x64716D96
	Offset: 0x2AA8
	Size: 0x160
	Parameters: 0
	Flags: Linked
*/
function enter_tunnel_nag()
{
	trigger::wait_till("t_tarmac_we_need_a_medic");
	nag0 = 0;
	var_5f00f64d = 30;
	nag1 = 0;
	var_38fe7be4 = 50;
	start_time = gettime();
	while(level flag::get("player_entering_tunnel") == 0)
	{
		time = gettime();
		dt = (time - start_time) / 1000;
		if(dt > var_5f00f64d && nag0 == 0)
		{
			level.ai_hendricks dialog::say("hend_stay_on_me_we_need_0");
			nag0 = 1;
		}
		if(dt > var_38fe7be4 && nag1 == 0)
		{
			level.ai_hendricks dialog::say("hend_clock_s_ticking_we_0");
			nag1 = 1;
			break;
		}
		wait(0.05);
	}
}

/*
	Name: function_4358b88b
	Namespace: cp_prologue_enter_base
	Checksum: 0x45A58CC9
	Offset: 0x2C10
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_4358b88b()
{
	level thread function_599e2f36();
	level thread scene::play("cin_pro_03_02_blendin_vign_attendfire");
	level thread tarmac_vign_anims();
	level thread function_12fd44e1();
	level thread tunnel_entrance_guard();
}

/*
	Name: hendricks_movement_handler
	Namespace: cp_prologue_enter_base
	Checksum: 0x4B49E2F7
	Offset: 0x2CA0
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function hendricks_movement_handler()
{
	level thread function_ae8c8b7b();
	level thread scene::add_scene_func("cin_pro_03_02_blendin_vign_call_for_help", &function_9b773ab2);
	level thread scene::play("cin_pro_03_02_blendin_vign_call_for_help");
	scene::add_scene_func("cin_pro_03_02_blendin_vign_tarmac_cross", &function_cdc39276, "play");
	level scene::play("cin_pro_03_01_blendin_vign_movedown_tower_exit_hendr");
	level waittill(#"hash_c64e52db");
	level flag::set("hendr_crossed_tarmac");
}

/*
	Name: function_c9e3016d
	Namespace: cp_prologue_enter_base
	Checksum: 0xDF86CD19
	Offset: 0x2D88
	Size: 0x154
	Parameters: 1
	Flags: Linked
*/
function function_c9e3016d(a_ents)
{
	level waittill(#"hash_23c82471");
	level scene::init("cin_pro_03_02_blendin_vign_tarmac_cross");
	level scene::init("cin_pro_03_02_blendin_vign_call_for_help");
	level scene::init("cin_pro_03_02_blendin_vign_destruction_injured");
	level scene::init("cin_pro_03_02_blendin_vign_attendfire");
	level scene::init("cin_pro_03_02_blendin_vign_destruction_help");
	level scene::init("cin_pro_03_02_blendin_vign_destruction_putoutfire");
	level scene::init("tarmac_guys_on_fire");
	level scene::init("cin_pro_03_02_blendin_vign_destruction_onfire_guy01");
	level scene::init("cin_pro_03_02_blendin_vign_destruction_onfire_guy03");
	level scene::init("cin_pro_03_02_blendin_vign_destruction_onfire_guy02");
}

/*
	Name: function_9b773ab2
	Namespace: cp_prologue_enter_base
	Checksum: 0x3E8EC1BC
	Offset: 0x2EE8
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function function_9b773ab2(a_ents)
{
	var_5d7f4f0f = a_ents["tarmac_soldier_seek_help_m"];
	var_5d7f4f0f dialog::say("nrcg_hurry_come_quickly_0", 2);
	var_5d7f4f0f ai::set_ignoreall(1);
	var_5d7f4f0f ai::set_ignoreme(1);
	var_5d7f4f0f setgoal(getnode("tarmac_help_goal", "targetname"), 1);
	var_5d7f4f0f thread function_e5670bf5();
	var_5d7f4f0f waittill(#"goal");
	var_5d7f4f0f delete();
}

/*
	Name: function_cdc39276
	Namespace: cp_prologue_enter_base
	Checksum: 0xB5965F6D
	Offset: 0x2FE0
	Size: 0x1AC
	Parameters: 1
	Flags: Linked
*/
function function_cdc39276(a_ents)
{
	level thread dialog::player_say("plyr_i_ll_follow_your_lea_0");
	level thread function_e78eadc4();
	level.var_fdb31b75 = a_ents["tarmac_cross_truck_02"];
	a_ents["hendricks"] waittill(#"hash_d9dc5e2b");
	level thread scene::play("cin_pro_03_02_blendin_vign_destruction_onfire_guy01");
	a_ents["hendricks"] waittill(#"hash_8dd76959");
	level thread scene::play("cin_pro_03_02_blendin_vign_destruction_onfire_guy03");
	a_ents["hendricks"] waittill(#"hash_67d4eef0");
	level thread scene::play("cin_pro_03_02_blendin_vign_destruction_onfire_guy02");
	a_ents["hendricks"] waittill(#"hash_18dec1ef");
	wait(0.5);
	if(!scene::is_playing("cin_pro_03_02_blendin_vign_destruction_putoutfire"))
	{
		level thread scene::play("cin_pro_03_02_blendin_vign_destruction_putoutfire");
	}
	nd_node = getnode("hendricks_tunnel_goal", "targetname");
	a_ents["hendricks"] setgoal(nd_node, 1);
}

/*
	Name: function_e78eadc4
	Namespace: cp_prologue_enter_base
	Checksum: 0x6CB5E4A0
	Offset: 0x3198
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_e78eadc4()
{
	level flag::wait_till("show_crash_victims");
	if(!scene::is_playing("cin_pro_03_02_blendin_vign_destruction_putoutfire"))
	{
		level thread scene::play("cin_pro_03_02_blendin_vign_destruction_putoutfire");
	}
}

/*
	Name: function_a7dec0e7
	Namespace: cp_prologue_enter_base
	Checksum: 0x3C280724
	Offset: 0x3200
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function function_a7dec0e7()
{
	level thread function_a87bddf2();
	level.ai_hendricks.pacifist = 1;
	level.ai_hendricks.ignoreme = 1;
	foreach(ai_ally in level.var_681ad194)
	{
		ai_ally ai::set_ignoreme(1);
		ai_ally ai::set_pacifist(1);
	}
	level flag::wait_till("tower_doors_open");
	level.ai_hendricks ai::set_behavior_attribute("cqb", 0);
	a_allies = cp_prologue_util::get_ai_allies();
	array::thread_all(a_allies, &ai::set_behavior_attribute, "cqb", 0);
	array::run_all(level.players, &util::set_low_ready, 1);
	array::thread_all(level.players, &cp_mi_eth_prologue::function_7072c5d8);
}

/*
	Name: function_a87bddf2
	Namespace: cp_prologue_enter_base
	Checksum: 0xAB5BA019
	Offset: 0x33D0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_a87bddf2()
{
	trigger::use("t_tower_y301");
	level waittill(#"hash_809b0d82");
	wait(3);
	trigger::use("t_tower_y302");
	wait(14);
	trigger::use("t_tower_y303");
}

/*
	Name: function_be42a33f
	Namespace: cp_prologue_enter_base
	Checksum: 0xC54DF9E
	Offset: 0x3440
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function function_be42a33f()
{
	trigger::wait_till("tarmac_move_friendies");
	foreach(ai_ally in level.var_681ad194)
	{
		ai_ally thread setgoal_then_delete(("ally0" + ai_ally.var_a89679b6) + "_tunnel_goal", "security_cam_active");
	}
}

/*
	Name: function_ae8c8b7b
	Namespace: cp_prologue_enter_base
	Checksum: 0x8C1D5715
	Offset: 0x3518
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function function_ae8c8b7b()
{
	level waittill(#"hash_c4d700a5");
	var_280d5f68 = getent("controltower_exitdoor_l", "targetname");
	var_3c301126 = getent("controltower_exitdoor_r", "targetname");
	var_280d5f68 rotateto(var_280d5f68.angles + (vectorscale((0, -1, 0), 90)), 0.75);
	var_3c301126 rotateto(var_3c301126.angles + vectorscale((0, 1, 0), 90), 0.75);
	var_3c301126 playsound("evt_towerdoor_open");
	level thread cp_prologue_util::rumble_all_players("damage_light", 0.05, 2, var_3c301126);
	level flag::set("tower_doors_open");
}

/*
	Name: setgoal_then_delete
	Namespace: cp_prologue_enter_base
	Checksum: 0x9FAFA1AC
	Offset: 0x3678
	Size: 0xAC
	Parameters: 2
	Flags: Linked
*/
function setgoal_then_delete(node, var_143df2c2 = "none")
{
	target_node = getnode(node, "targetname");
	self setgoal(target_node, 1);
	self util::waittill_either("goal", var_143df2c2);
	self delete();
}

/*
	Name: tunnel_entrance_guard
	Namespace: cp_prologue_enter_base
	Checksum: 0x708A651A
	Offset: 0x3730
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function tunnel_entrance_guard()
{
	sp_tunnel_entrance_guard = getent("tunnel_entrance_guard", "targetname");
	level.ai_tunnel_entrance_guard = sp_tunnel_entrance_guard spawner::spawn(1);
	level.ai_tunnel_entrance_guard.ignoreme = 1;
	level.ai_tunnel_entrance_guard.ignoreall = 1;
}

/*
	Name: tarmac_vign_anims
	Namespace: cp_prologue_enter_base
	Checksum: 0x2A391479
	Offset: 0x37B8
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function tarmac_vign_anims()
{
	level thread function_d5fbb820("tarmac_wounded_1");
	level thread function_d5fbb820("tarmac_wounded_2");
	level thread scene::play("tarmac_deathpose");
	var_197aede3 = struct::get("injured_carried2", "targetname");
	var_197aede3 scene::add_scene_func(var_197aede3.scriptbundlename, &function_28d9b6cd, "play");
	var_197aede3 thread scene::play(var_197aede3.scriptbundlename);
	scene::add_scene_func("cin_pro_03_02_blendin_vign_destruction_help", &function_28d9b6cd, "play");
	level thread scene::play("cin_pro_03_02_blendin_vign_destruction_help");
	var_a7737ea8 = struct::get("injured_carried1", "targetname");
	var_a7737ea8 scene::add_scene_func(var_a7737ea8.scriptbundlename, &function_28d9b6cd, "play");
	var_a7737ea8 thread scene::play(var_a7737ea8.scriptbundlename);
}

/*
	Name: function_d70eb0dd
	Namespace: cp_prologue_enter_base
	Checksum: 0x70644923
	Offset: 0x3988
	Size: 0xAC
	Parameters: 1
	Flags: None
*/
function function_d70eb0dd(a_ents)
{
	/#
		iprintlnbold("");
	#/
	var_cbd11028 = array("need_medic", "get_him_out", "more_men");
	str_vo = array::random(var_cbd11028);
	a_ents["tarmac_soldier"] thread function_c4ada726(str_vo, 400);
}

/*
	Name: function_28d9b6cd
	Namespace: cp_prologue_enter_base
	Checksum: 0x1012AC83
	Offset: 0x3A40
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_28d9b6cd(a_ents)
{
	a_ents["tarmac_soldier"] thread function_c4ada726("what_happened", 400);
}

/*
	Name: function_c4ada726
	Namespace: cp_prologue_enter_base
	Checksum: 0x6BA0B7DE
	Offset: 0x3A88
	Size: 0x56
	Parameters: 2
	Flags: Linked
*/
function function_c4ada726(var_417ec882, var_a972c5dd)
{
	self endon(#"death");
	level endon(#"objective_blend_in_done");
	self function_92e75cce(var_a972c5dd);
	self notify(#"scriptedbc", var_417ec882);
}

/*
	Name: function_92e75cce
	Namespace: cp_prologue_enter_base
	Checksum: 0x7FDADD24
	Offset: 0x3AE8
	Size: 0x11C
	Parameters: 2
	Flags: Linked
*/
function function_92e75cce(n_range, var_b0ecff80 = 1)
{
	self endon(#"death");
	var_a972c5dd = n_range * n_range;
	do
	{
		b_player_near = 0;
		foreach(player in level.activeplayers)
		{
			b_player_near = b_player_near || distancesquared(self.origin, player.origin) <= var_a972c5dd;
		}
		if(!b_player_near)
		{
			wait(var_b0ecff80);
		}
	}
	while(!b_player_near);
}

/*
	Name: blend_in_tsa_guard
	Namespace: cp_prologue_enter_base
	Checksum: 0x6B45DE17
	Offset: 0x3C10
	Size: 0x15C
	Parameters: 1
	Flags: Linked
*/
function blend_in_tsa_guard(str_scene)
{
	var_e4d0f603 = getent("spawner_tsa_guard", "targetname");
	ai_victim = spawner::simple_spawn_single(var_e4d0f603);
	ai_victim disableaimassist();
	ai_victim ai::set_ignoreall(1);
	ai_victim ai::set_ignoreme(1);
	ai_victim.health = int(ai_victim.health * 0.25);
	ai_victim thread function_b79bfbce();
	level thread scene::play(str_scene, ai_victim);
	ai_victim util::delay(0.5, undefined, &kill);
	ai_victim waittill(#"death");
	if(isdefined(ai_victim))
	{
		ai_victim startragdoll(1);
	}
}

/*
	Name: function_b79bfbce
	Namespace: cp_prologue_enter_base
	Checksum: 0x140EDA35
	Offset: 0x3D78
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_b79bfbce()
{
	self endon(#"death");
	level waittill(#"tower_doors_open");
	self kill();
}

/*
	Name: function_d5fbb820
	Namespace: cp_prologue_enter_base
	Checksum: 0x9EB0842B
	Offset: 0x3DB8
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function function_d5fbb820(str_scene)
{
	var_e4d0f603 = getent("tarmac_soldier", "targetname");
	if(randomint(100) > 70)
	{
		var_e4d0f603 = getent("tarmac_soldier_f", "targetname");
	}
	ai_victim = spawner::simple_spawn_single(var_e4d0f603);
	ai_victim disableaimassist();
	level thread scene::play(str_scene, ai_victim);
}

/*
	Name: set_ai_ignore
	Namespace: cp_prologue_enter_base
	Checksum: 0x3811A99B
	Offset: 0x3E90
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function set_ai_ignore()
{
	self.ignoreme = 1;
	self.ignoreall = 1;
}

/*
	Name: function_12fd44e1
	Namespace: cp_prologue_enter_base
	Checksum: 0x6FF8B28A
	Offset: 0x3EB8
	Size: 0x33C
	Parameters: 0
	Flags: Linked
*/
function function_12fd44e1()
{
	level flag::wait_till("tower_doors_open");
	exploder::exploder("fx_exploder_glass_tower");
	if(!scene::is_active("p7_fxanim_cp_prologue_control_tower_tarmac_turbine_bundle"))
	{
		level thread scene::play("p7_fxanim_cp_prologue_control_tower_tarmac_turbine_bundle");
	}
	level thread function_d5fbb820("wounded_crawl_1");
	level thread function_d5fbb820("wounded_crawl_2");
	level thread function_d5fbb820("wounded_crawl_3");
	level thread scene::play("cin_pro_03_02_blendin_vign_destruction_injured");
	wait(6);
	level thread scene::play("tarmac_guys_on_fire");
	level waittill(#"hash_f3f03044");
	level scene::stop("p7_fxanim_cp_prologue_control_tower_tarmac_turbine_bundle");
	level scene::stop("cin_pro_03_02_blendin_vign_destruction_injured");
	level scene::stop("cin_pro_03_02_blendin_vign_attendfire");
	level scene::stop("tarmac_deathpose");
	level scene::stop("cin_pro_03_02_blendin_vign_destruction_help");
	level scene::stop("tarmac_wounded_1");
	level scene::stop("tarmac_wounded_2");
	level scene::stop("injured_carried2", "targetname");
	level scene::stop("injured_carried1", "targetname");
	level scene::stop("cin_pro_03_02_blendin_vign_destruction_putoutfire");
	wait(0.1);
	level struct::delete_script_bundle("scene", "p7_fxanim_cp_prologue_control_tower_tarmac_turbine_bundle");
	level struct::delete_script_bundle("scene", "cin_pro_03_02_blendin_vign_destruction_injured");
	level struct::delete_script_bundle("scene", "cin_pro_03_02_blendin_vign_attendfire");
	level struct::delete_script_bundle("scene", "cin_pro_03_02_blendin_vign_destruction_help");
	level struct::delete_script_bundle("scene", "cin_pro_03_02_blendin_vign_destruction_putoutfire");
}

/*
	Name: tunneltruck
	Namespace: cp_prologue_enter_base
	Checksum: 0x85BCE191
	Offset: 0x4200
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function tunneltruck(str_node, var_5e550f5 = 1)
{
	self notsolid();
	nd_truck_start = getvehiclenode(str_node, "targetname");
	self.drivepath = var_5e550f5;
	self.angles = nd_truck_start.angles;
	self thread vehicle::get_on_and_go_path(nd_truck_start);
	self waittill(#"reached_end_node");
	self delete();
}

/*
	Name: function_374cf6ee
	Namespace: cp_prologue_enter_base
	Checksum: 0x1C424965
	Offset: 0x42D0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_374cf6ee()
{
	level clientfield::set("blend_in_cleanup", 1);
}

/*
	Name: function_599e2f36
	Namespace: cp_prologue_enter_base
	Checksum: 0x142C430A
	Offset: 0x4300
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function function_599e2f36()
{
	if(isdefined(level.var_8d6df5cb))
	{
		return;
	}
	level.var_8d6df5cb = 1;
	a_vehicles = [];
	a_vehicles[a_vehicles.size] = "tarmac_cargo_short";
	a_vehicles[a_vehicles.size] = "tarmac_cargo_long";
	a_vehicles[a_vehicles.size] = "tarmac_humvee";
	for(i = 0; i < 12; i++)
	{
		index = randomintrange(0, a_vehicles.size);
		veh_to_spawn = a_vehicles[index] + "_far";
		sp_tunneltruck2 = vehicle::simple_spawn_single(veh_to_spawn);
		sp_tunneltruck2 thread tunneltruck("tunnel_truck2_node");
		delay_between_spawns = randomfloatrange(10, 15);
		wait(delay_between_spawns);
		if(level flag::get("stop_tunnel_spawns"))
		{
			break;
		}
	}
}

/*
	Name: function_71f51761
	Namespace: cp_prologue_enter_base
	Checksum: 0xD0A37482
	Offset: 0x4478
	Size: 0x114
	Parameters: 0
	Flags: None
*/
function function_71f51761()
{
	delays = [];
	delays[delays.size] = 1.75;
	delays[delays.size] = 7.5;
	delays[delays.size] = 12;
	delays[delays.size] = 8;
	delays[delays.size] = 12;
	for(num = 0; num < 2; num++)
	{
		for(i = 0; i < delays.size; i++)
		{
			var_5e344df1 = vehicle::simple_spawn_single("tarmac_cargo_enter_far_base");
			var_5e344df1 thread tunneltruck("nd_tarmac_cargo_enter_far_base");
			wait(delays[i]);
		}
	}
}

/*
	Name: function_63075f1d
	Namespace: cp_prologue_enter_base
	Checksum: 0x605DEFBE
	Offset: 0x4598
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function function_63075f1d()
{
	foreach(player in level.activeplayers)
	{
		player thread function_3f3cae8c();
	}
}

/*
	Name: function_3f3cae8c
	Namespace: cp_prologue_enter_base
	Checksum: 0x5A84390
	Offset: 0x4630
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function function_3f3cae8c()
{
	self endon(#"death");
	var_1dd38210 = getent("info_crouch_tutorial", "targetname");
	self flag::wait_till("tutorial_allowed");
	self flag::set_val("tutorial_allowed", 0);
	while(!self istouching(var_1dd38210))
	{
		wait(0.1);
	}
	self util::show_hint_text(&"CP_MI_ETH_PROLOGUE_TUTORIAL_CROUCH", 0, undefined, 10);
	self.var_9db68ebf = 0;
	while(!self.var_9db68ebf)
	{
		if(self stancebuttonpressed())
		{
			self util::hide_hint_text();
			self.var_9db68ebf = 1;
			self flag::set_val("tutorial_allowed", 1);
		}
		else
		{
			wait(0.05);
		}
	}
}

/*
	Name: function_127fb1fb
	Namespace: cp_prologue_enter_base
	Checksum: 0x13759BD2
	Offset: 0x4780
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_127fb1fb()
{
	level thread fxanim_plane_explosion();
	level thread function_11ec608d();
	level thread function_809b0d82();
	level thread function_3e901e16();
}

/*
	Name: function_5dc7beec
	Namespace: cp_prologue_enter_base
	Checksum: 0xBAA7C33F
	Offset: 0x47F0
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function function_5dc7beec()
{
	level thread blend_in_tsa_guard("tsa_guard_wound_1");
	level thread blend_in_tsa_guard("tsa_guard_wound_2");
	level thread blend_in_tsa_guard("tsa_guard_wound_3");
	level thread blend_in_tsa_guard("tsa_guard_wound_4");
	level thread blend_in_tsa_guard("tsa_guard_wound_5");
	trigger::wait_till("close_security_door_trig");
	level scene::stop("tsa_guard_wound_1");
	level scene::stop("tsa_guard_wound_2");
	level scene::stop("tsa_guard_wound_3");
	level scene::stop("tsa_guard_wound_4");
	level scene::stop("tsa_guard_wound_5");
}

/*
	Name: fxanim_plane_explosion
	Namespace: cp_prologue_enter_base
	Checksum: 0xB118B3F9
	Offset: 0x4958
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function fxanim_plane_explosion()
{
	flag::wait_till("player_trigger_gear_drop");
	level thread scene::play("landing_gear_anim", "targetname");
	level thread cp_prologue_util::function_2a0bc326(level.ai_hendricks.origin, 0.3, 0.6, 600, 3);
	exploder::exploder("light_exploder_controltower_inset_red");
	level thread scene::play("p7_fxanim_cp_prologue_control_tower_debris_01_bundle");
	level thread scene::play("p7_fxanim_cp_prologue_control_tower_tarmac_turbine_bundle");
	trigger::wait_till("trig_plane_tail_explosion");
	videostop("cp_prologue_env_post_crash");
	level thread scene::play("plane_tail_explosion", "targetname");
	level thread scene::play("p7_fxanim_cp_prologue_control_tower_ceiling_tiles_03_bundle");
	level thread cp_prologue_util::function_2a0bc326(level.ai_hendricks.origin, 0.4, 1.2, 10000, 6);
	level thread function_4febd2da();
	function_6bad1a34();
}

/*
	Name: function_4febd2da
	Namespace: cp_prologue_enter_base
	Checksum: 0xCB25F13A
	Offset: 0x4B20
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_4febd2da()
{
	wait(2);
	playsoundatposition("amb_tower_shake", (0, 0, 0));
}

/*
	Name: function_6bad1a34
	Namespace: cp_prologue_enter_base
	Checksum: 0x263403DA
	Offset: 0x4B50
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_6bad1a34()
{
	level waittill(#"explosion_blast");
	level thread scene::play("plane_cockpit_explosion", "targetname");
	exploder::exploder("fx_exploder_plane_exp");
	level thread cp_prologue_util::function_2a0bc326(level.ai_hendricks.origin, 0.5, 1.2, 10000, 4);
	level.var_fdb31b75 scene::play("cin_pro_03_01_blendin_vign_truck_spray", level.var_fdb31b75);
}

/*
	Name: fxanim_plane_explosion_backup
	Namespace: cp_prologue_enter_base
	Checksum: 0x93BF681D
	Offset: 0x4C10
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function fxanim_plane_explosion_backup()
{
	level flag::wait_till("explosion_fallback_flag");
	trigger::use("trig_lookat_explosion");
}

/*
	Name: function_11ec608d
	Namespace: cp_prologue_enter_base
	Checksum: 0xB19CDC8F
	Offset: 0x4C58
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function function_11ec608d()
{
	while(!level flag::get("tower_doors_open"))
	{
		wait(randomfloatrange(5, 12));
		level thread cp_prologue_util::function_2a0bc326(level.ai_hendricks.origin, 0.4, 0.5, 800, 2);
		playsoundatposition("amb_tower_shake", (0, 0, 0));
		level notify(#"hash_c988e5af");
	}
	level notify(#"hash_f8e975b8");
}

/*
	Name: function_809b0d82
	Namespace: cp_prologue_enter_base
	Checksum: 0x8502D45
	Offset: 0x4D28
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_809b0d82()
{
	trigger_hit = trigger::wait_till("t_glass_floor_cracks");
	level notify(#"hash_809b0d82");
	level notify(#"hash_fc089399");
	trigger_hit.who playrumbleonentity("damage_heavy");
}

/*
	Name: function_3e901e16
	Namespace: cp_prologue_enter_base
	Checksum: 0xE26BDE0
	Offset: 0x4D98
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_3e901e16()
{
	level thread function_f494e193();
	trigger::wait_till("t_tower_wheels");
	wait(0.5);
	level thread scene::play("p7_fxanim_cp_prologue_control_tower_ceiling_tiles_01_bundle");
	level waittill(#"hash_809b0d82");
	level flag::wait_till("player_entering_tunnel");
	scene::stop("p7_fxanim_cp_prologue_control_tower_debris_01_bundle");
	scene::stop("p7_fxanim_cp_prologue_control_tower_ceiling_tiles_01_bundle");
}

/*
	Name: function_f494e193
	Namespace: cp_prologue_enter_base
	Checksum: 0x4A9B94BE
	Offset: 0x4E58
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_f494e193()
{
	level endon(#"hash_5893f877");
	level flag::wait_till("control_tower_debris");
	level thread scene::skipto_end("p7_fxanim_cp_prologue_control_tower_debris_01_bundle", undefined, undefined, 0.15, 0);
}

/*
	Name: take_out_guards_start
	Namespace: cp_prologue_enter_base
	Checksum: 0x85706C66
	Offset: 0x4EB8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function take_out_guards_start()
{
	level thread take_out_guards_main();
}

/*
	Name: take_out_guards_main
	Namespace: cp_prologue_enter_base
	Checksum: 0xA5FFFA4A
	Offset: 0x4EE0
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function take_out_guards_main()
{
	cp_prologue_util::function_25e841ea();
	battlechatter::function_d9f49fba(0);
	cp_prologue_util::function_47a62798(1);
	level.ai_hendricks.pacifist = 1;
	level.ai_hendricks.ignoreme = 1;
	array::run_all(level.players, &util::set_low_ready, 1);
	array::thread_all(level.players, &cp_mi_eth_prologue::function_7072c5d8);
	level thread tunnel_vignettes();
	level thread take_out_guards_objective_handler();
	level thread function_65e80b9e();
	level thread function_d095f82f();
	level thread tunnel_balcony_guys();
	level thread function_21dd3be1();
	level.ai_hendricks hendricks_take_out_guard();
}

/*
	Name: hendricks_take_out_guard
	Namespace: cp_prologue_enter_base
	Checksum: 0x293F0888
	Offset: 0x5058
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function hendricks_take_out_guard()
{
	level scene::init("cin_pro_04_01_takeout_vign_kiosk_kill");
	level flag::wait_till("hendr_crossed_tarmac");
	level flag::wait_till("start_hendr_kill");
	level thread function_f126566f();
	level thread function_eb28ee9b();
	level scene::add_scene_func("cin_pro_04_01_takeout_vign_keycard", &security_camera::function_30b1de21);
	level scene::add_scene_func("cin_pro_05_01_securitycam_1st_stealth_kill_prepare", &security_camera::function_d6557dc4);
	level scene::add_scene_func("cin_pro_05_01_securitycam_1st_stealth_kill_prepare", &security_camera::function_9887d555, "done");
	level scene::add_scene_func("cin_pro_04_01_takeout_vign_kiosk_kill", &hend_taylor_dialog, "play");
	level scene::play("cin_pro_04_01_takeout_vign_kiosk_kill");
}

/*
	Name: function_eb28ee9b
	Namespace: cp_prologue_enter_base
	Checksum: 0x25B10EC6
	Offset: 0x51C8
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function function_eb28ee9b()
{
	level waittill(#"hash_eb28ee9b");
	var_7e130296 = getent("blend_security_door_lt", "targetname");
	var_2a3f9df8 = getent("blend_security_door_rt", "targetname");
	var_7e130296 rotateyaw(89, 0.5);
	var_2a3f9df8 rotateyaw(90 * -1, 0.5);
	playsoundatposition("evt_tunnel_gate_open", var_2a3f9df8.origin);
	level thread function_60b83ce9();
	level waittill(#"hash_2170cc63");
	level thread objectives::breadcrumb("blending_in_breadcrumb_4");
	level waittill(#"hash_7a8dce93");
	level flag::set("activate_bc_5");
}

/*
	Name: function_60b83ce9
	Namespace: cp_prologue_enter_base
	Checksum: 0x7AC802CA
	Offset: 0x5338
	Size: 0x186
	Parameters: 0
	Flags: Linked
*/
function function_60b83ce9()
{
	t_door = getent("kiosk_guard_door", "targetname");
	level thread cp_prologue_util::function_21f52196("kiosk_doors", t_door, "t_regroup_past_guards");
	while(!cp_prologue_util::function_cdd726fb("kiosk_doors"))
	{
		wait(0.5);
	}
	var_7e130296 = getent("blend_security_door_lt", "targetname");
	var_2a3f9df8 = getent("blend_security_door_rt", "targetname");
	var_7e130296 rotateyaw(89 * -1, 0.25);
	var_2a3f9df8 rotateyaw(90, 0.25);
	playsoundatposition("evt_tunnel_gate_open", var_2a3f9df8.origin);
	level notify(#"hash_b5e3e8ba");
	level notify(#"hash_f3f03044");
}

/*
	Name: tunnel_vignettes
	Namespace: cp_prologue_enter_base
	Checksum: 0x6FA01FF1
	Offset: 0x54C8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function tunnel_vignettes()
{
	level thread function_7f967b5b();
	level thread forklift_anim();
}

/*
	Name: snddeletesndent
	Namespace: cp_prologue_enter_base
	Checksum: 0xF2E95919
	Offset: 0x5508
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function snddeletesndent(sndent)
{
	self waittill(#"death");
	sndent delete();
}

/*
	Name: forklift_anim
	Namespace: cp_prologue_enter_base
	Checksum: 0x167875ED
	Offset: 0x5540
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function forklift_anim()
{
	level notify(#"siren");
	level scene::init("forkilft_anim");
	trigger::wait_till("trigger_obj_enter_tunnels_end");
	level thread scene::skipto_end("forkilft_anim", undefined, undefined, 0.33);
}

/*
	Name: function_d095f82f
	Namespace: cp_prologue_enter_base
	Checksum: 0x29908445
	Offset: 0x55B8
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function function_d095f82f()
{
	e_turret = spawner::simple_spawn_single("tunnel_turret_1");
	e_turret thread function_927f3ae0(0.1);
	e_turret.scanning_arc = 30;
	e_turret = spawner::simple_spawn_single("tunnel_turret_2");
	e_turret thread function_927f3ae0(0.5);
	e_turret.scanning_arc = 30;
}

/*
	Name: function_927f3ae0
	Namespace: cp_prologue_enter_base
	Checksum: 0x92B0F6BB
	Offset: 0x5668
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function function_927f3ae0(delete_delay)
{
	self turret::enable_laser(0, 0);
	a_players = getplayers();
	for(i = 0; i < a_players.size; i++)
	{
		a_players[i].ignoreme = 1;
	}
	level.ai_hendricks.ignoreme = 1;
	level thread function_3d9b2dbc();
	level waittill(#"minister_located");
	a_players = getplayers();
	for(i = 0; i < a_players.size; i++)
	{
		a_players[i].ignoreme = 0;
	}
	level.ai_hendricks.ignoreme = 0;
	wait(delete_delay);
	self delete();
}

/*
	Name: function_3d9b2dbc
	Namespace: cp_prologue_enter_base
	Checksum: 0xC8542712
	Offset: 0x57A8
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function function_3d9b2dbc()
{
	level endon(#"objective_take_out_guards_done");
	while(true)
	{
		level waittill(#"hash_25ea191a");
		a_players = getplayers();
		for(i = 0; i < a_players.size; i++)
		{
			a_players[i].ignoreme = 1;
		}
	}
}

/*
	Name: function_65e80b9e
	Namespace: cp_prologue_enter_base
	Checksum: 0x794FCD19
	Offset: 0x5838
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function function_65e80b9e()
{
	function_173d3769("close", 1);
	var_813b7ee8 = vehicle::simple_spawn_single("sp_truck_tarmac_enter_base");
	var_813b7ee8 thread tunneltruck("nd_truck_tarmac_enter_base", 0);
	var_813b7ee8 playloopsound("evt_tunnel_truck_script_drive_lp");
	level waittill(#"hash_3bc05b4");
	var_813b7ee8 setspeed(0, 15, 15);
	var_813b7ee8 playsound("evt_tunnel_truck_brake");
	var_813b7ee8 thread function_8677e162();
	level thread function_790e40ec();
	level waittill(#"hash_236f4ebe");
	var_813b7ee8 setspeed(20, 15, 15);
	var_813b7ee8 resumespeed(20);
	var_813b7ee8 playloopsound("evt_tunnel_truck_script_drive_lp", 0.2);
	util::delay(2, undefined, &function_173d3769, "open");
	level waittill(#"hash_bed7581c");
	function_173d3769("close");
}

/*
	Name: function_8677e162
	Namespace: cp_prologue_enter_base
	Checksum: 0x221C05A2
	Offset: 0x5A10
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_8677e162()
{
	self stoploopsound(0.75);
	wait(0.25);
	self playloopsound("evt_tunnel_truck_script_idle_lp", 0.25);
}

/*
	Name: function_790e40ec
	Namespace: cp_prologue_enter_base
	Checksum: 0x5B121789
	Offset: 0x5A70
	Size: 0x142
	Parameters: 0
	Flags: Linked
*/
function function_790e40ec()
{
	var_b8823447 = getentarray("tunnel_traffic_barrier", "targetname");
	var_ecbf6327 = var_b8823447[0];
	var_ecbf6327 playsound("evt_tunnel_truck_trafficarm");
	var_ecbf6327 rotateroll(60, 1.5, 0.5, 0.3);
	var_ecbf6327 waittill(#"rotatedone");
	level notify(#"hash_236f4ebe");
	level waittill(#"hash_a4ce8e72");
	var_ecbf6327 playsound("evt_tunnel_truck_trafficarm");
	var_ecbf6327 rotateroll(60 * -1, 1.5, 0.5, 0.3);
	var_ecbf6327 waittill(#"rotatedone");
}

/*
	Name: function_173d3769
	Namespace: cp_prologue_enter_base
	Checksum: 0x87795512
	Offset: 0x5BC0
	Size: 0x294
	Parameters: 2
	Flags: Linked
*/
function function_173d3769(str_state, var_abf03d83 = 0)
{
	var_3c301126 = getent("tunnel_vault_door_r", "targetname");
	var_280d5f68 = getent("tunnel_vault_door_l", "targetname");
	if(!var_abf03d83)
	{
		var_3c301126 playsound("evt_tunnel_door_start");
		var_3c301126 playloopsound("evt_tunnel_door_loop", 1);
	}
	if(str_state == "open")
	{
		if(var_abf03d83)
		{
			var_3c301126 rotateyaw(90, 0.05);
			var_280d5f68 rotateyaw(90 * -1, 0.05);
		}
		else
		{
			var_3c301126 rotateyaw(90, 6, 1, 1);
			var_280d5f68 rotateyaw(90 * -1, 6, 1, 1);
		}
	}
	else
	{
		if(var_abf03d83)
		{
			var_3c301126 rotateyaw(90 * -1, 0.05);
			var_280d5f68 rotateyaw(90, 0.05);
		}
		else
		{
			var_3c301126 rotateyaw(90 * -1, 6, 1, 1);
			var_280d5f68 rotateyaw(90, 6, 1, 1);
		}
	}
	var_3c301126 waittill(#"rotatedone");
	var_3c301126 stoploopsound(0.5);
	var_3c301126 playsound("evt_tunnel_door_stop");
}

/*
	Name: take_out_guards_objective_handler
	Namespace: cp_prologue_enter_base
	Checksum: 0x28FB498C
	Offset: 0x5E60
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function take_out_guards_objective_handler()
{
	level waittill(#"hash_81d6c615");
	a_clean_up_group_start_through_take_out_guards = getaiarray("start_through_take_out_guards", "script_aigroup");
	foreach(ai_entity in a_clean_up_group_start_through_take_out_guards)
	{
		if(isalive(ai_entity))
		{
			ai_entity delete();
		}
	}
}

/*
	Name: function_7f967b5b
	Namespace: cp_prologue_enter_base
	Checksum: 0x3375A590
	Offset: 0x5F48
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_7f967b5b()
{
	level scene::init("cin_pro_04_01_takeout_vign_vault_doors");
	level waittill(#"hash_f199baa");
	level thread scene::play("cin_pro_04_01_takeout_vign_vault_doors");
	trigger::wait_till("close_security_door_trig");
	level scene::stop("cin_pro_04_01_takeout_vign_vault_doors");
}

/*
	Name: function_f126566f
	Namespace: cp_prologue_enter_base
	Checksum: 0xA452BA64
	Offset: 0x5FD8
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function function_f126566f()
{
	wait(2);
	level thread scene::init("cin_pro_04_01_takeout_vign_truck_prisoners");
	wait(4);
	level thread scene::init("cin_pro_04_02_takeout_vign_truck_unload");
	level flag::wait_till("start_tunnel_trucks");
	level thread scene::play("cin_pro_04_01_takeout_vign_truck_prisoners");
	wait(4);
	level thread scene::play("cin_pro_04_02_takeout_vign_truck_unload");
	level waittill(#"hash_81d6c615");
	scene::stop("cin_pro_04_01_takeout_vign_truck_prisoners");
	scene::stop("cin_pro_04_02_takeout_vign_truck_unload");
}

/*
	Name: hend_taylor_dialog
	Namespace: cp_prologue_enter_base
	Checksum: 0x360C9F7
	Offset: 0x60C8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function hend_taylor_dialog(a_ents)
{
	level waittill(#"hash_1a725b50");
	wait(10);
	e_ent = getent("pa_vox_security_cameras", "targetname");
	e_ent dialog::say("nrcp_emergency_protocol_0");
}

/*
	Name: tunnel_balcony_guys
	Namespace: cp_prologue_enter_base
	Checksum: 0xF5F80212
	Offset: 0x6138
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function tunnel_balcony_guys()
{
	var_dd4fa3f4 = spawner::simple_spawn_single("balcony_guy1");
	var_dd4fa3f4 ai::set_pacifist(1);
	var_dd4fa3f4 thread ai::patrol(getnode("tunnel_patrol_1", "targetname"));
	var_4f57132f = spawner::simple_spawn_single("balcony_guy2");
	var_4f57132f ai::set_pacifist(1);
	var_4f57132f thread ai::patrol(getnode("tunnel_patrol_2", "targetname"));
	trigger::wait_till("spawn_balcony_patrol");
	var_295498c6 = spawner::simple_spawn_single("balcony_guy3");
	var_295498c6 ai::set_pacifist(1);
	var_295498c6 thread ai::patrol(getnode("tunnel_patrol_3", "targetname"));
}

/*
	Name: function_21dd3be1
	Namespace: cp_prologue_enter_base
	Checksum: 0x31210D35
	Offset: 0x62B0
	Size: 0x2E4
	Parameters: 0
	Flags: Linked
*/
function function_21dd3be1()
{
	t_door = getent("tunnel_keycard_door", "targetname");
	level thread cp_prologue_util::function_21f52196("keycard_doors", t_door);
	e_left_door = getent("tunnel_vault_upperdoor_L", "targetname");
	v_side = anglestoright(e_left_door.angles);
	e_right_door = getent("tunnel_vault_upperdoor_R", "targetname");
	move_amount = 52;
	v_pos_left = e_left_door.origin + (v_side * (move_amount * -1));
	e_left_door moveto(v_pos_left, 0.1);
	v_pos_right = e_right_door.origin + (v_side * move_amount);
	e_right_door moveto(v_pos_right, 0.1);
	level waittill(#"hash_2170cc63");
	playsoundatposition("evt_tunnel_upper_door", e_left_door.origin);
	v_pos_left = e_left_door.origin + (v_side * move_amount);
	e_left_door moveto(v_pos_left, 1.5);
	v_pos_right = e_right_door.origin + (v_side * (move_amount * -1));
	e_right_door moveto(v_pos_right, 1.5);
	while(!cp_prologue_util::function_cdd726fb("keycard_doors"))
	{
		wait(0.5);
	}
	v_pos_left = e_left_door.origin + (v_side * (move_amount * -1));
	e_left_door moveto(v_pos_left, 0.1);
	v_pos_right = e_right_door.origin + (v_side * move_amount);
	e_right_door moveto(v_pos_right, 0.1);
}

