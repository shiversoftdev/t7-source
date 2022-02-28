// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_debug;
#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_sing_vengeance_accolades;
#using scripts\cp\cp_mi_sing_vengeance_killing_streets;
#using scripts\cp\cp_mi_sing_vengeance_sound;
#using scripts\cp\cp_mi_sing_vengeance_util;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\stealth;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;

#namespace vengeance_intro;

/*
	Name: skipto_intro_init
	Namespace: vengeance_intro
	Checksum: 0xAAF5D82D
	Offset: 0x1ED8
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function skipto_intro_init(str_objective, b_starting)
{
	vengeance_util::skipto_baseline(str_objective, b_starting);
	load::function_73adcefc();
	vengeance_util::init_hero("hendricks", str_objective);
	level.ai_hendricks ai::set_ignoreall(1);
	level.ai_hendricks ai::set_ignoreme(1);
	level.ai_hendricks.goalradius = 32;
	vengeance_util::function_4e8207e9("intro");
	intro_screen(str_objective);
	level.ai_hendricks battlechatter::function_d9f49fba(0);
	intro_main(str_objective);
}

/*
	Name: intro_main
	Namespace: vengeance_intro
	Checksum: 0xF21CCF63
	Offset: 0x1FF8
	Size: 0x194
	Parameters: 1
	Flags: Linked
*/
function intro_main(str_objective)
{
	foreach(e_player in level.players)
	{
		e_player thread function_773ef6a0();
	}
	level thread function_21e6e30e();
	level flag::set("intro_wall_done");
	level thread intro_hendricks();
	level thread function_858195d5();
	level thread namespace_9fd035::function_d4c52995();
	level clientfield::set("gameplay_started", 1);
	savegame::checkpoint_save();
	thread cp_mi_sing_vengeance_sound::intro_complete();
	level thread apartment_main();
	level flag::wait_till("player_near_apartment_stairs");
	savegame::checkpoint_save();
}

/*
	Name: function_773ef6a0
	Namespace: vengeance_intro
	Checksum: 0x60F3BC07
	Offset: 0x2198
	Size: 0x130
	Parameters: 0
	Flags: Linked
*/
function function_773ef6a0()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"hash_ec8fe31d");
	trigger = getent("apartment_light_fire_trigger", "targetname");
	while(true)
	{
		trigger waittill(#"trigger", e_other);
		if(e_other == self && isplayer(self))
		{
			while(isdefined(self) && self istouching(trigger))
			{
				if(!isdefined(self.var_a6b29bdf))
				{
					self.var_a6b29bdf = 1;
					self clientfield::set_to_player("apartment_light_fire_fx", 1);
				}
				wait(0.05);
			}
			self.var_a6b29bdf = undefined;
			self clientfield::set_to_player("apartment_light_fire_fx", 0);
		}
	}
}

/*
	Name: intro_street_vignette_setup
	Namespace: vengeance_intro
	Checksum: 0x802F7883
	Offset: 0x22D0
	Size: 0x334
	Parameters: 0
	Flags: Linked
*/
function intro_street_vignette_setup()
{
	level thread vengeance_util::function_e3420328("intro_ambient_anims", "start_takedown_igc");
	var_6a07eb6c = [];
	var_6a07eb6c[0] = "dead_civ1";
	var_6a07eb6c[1] = "dead_civ2";
	var_6a07eb6c[2] = "dead_civ3";
	var_6a07eb6c[3] = "dead_civ4";
	scene::add_scene_func("cin_ven_01_20_introstreet_bodies_vign", &vengeance_util::function_65a61b78, "play", var_6a07eb6c);
	var_4254e946 = [];
	var_4254e946[0] = "outside_dead_body_01";
	var_4254e946[1] = "outside_dead_body_02";
	var_4254e946[2] = "outside_dead_body_03";
	var_4254e946[3] = "outside_dead_body_04";
	var_4254e946[4] = "outside_dead_body_05";
	var_4254e946[5] = "outside_dead_body_06";
	var_4254e946[6] = "outside_dead_body_07";
	var_4254e946[7] = "outside_dead_body_08";
	var_4254e946[8] = "outside_dead_body_09";
	var_4254e946[9] = "outside_dead_body_10";
	scene::add_scene_func("cin_ven_01_25_outside_apt_bodies_vign", &vengeance_util::function_65a61b78, "play", var_4254e946);
	var_685763af = [];
	var_685763af[0] = "inside_dead_body_01";
	var_685763af[1] = "inside_dead_body_02";
	var_685763af[2] = "inside_dead_body_03";
	scene::add_scene_func("cin_ven_02_05_inside_apt_bodies_vign", &vengeance_util::function_65a61b78, "play", var_685763af);
	level thread scene::play("cin_ven_01_20_introstreet_bodies_vign");
	level thread scene::play("cin_ven_01_25_outside_apt_bodies_vign");
	level thread scene::play("cin_ven_02_05_inside_apt_bodies_vign");
	level flag::wait_till("start_takedown_igc");
	level thread scene::stop("cin_ven_01_20_introstreet_bodies_vign");
	level thread scene::stop("cin_ven_01_25_outside_apt_bodies_vign");
	level thread scene::stop("cin_ven_02_05_inside_apt_bodies_vign");
	vengeance_util::function_4e8207e9("intro", 0);
}

/*
	Name: intro_screen
	Namespace: vengeance_intro
	Checksum: 0x34300EED
	Offset: 0x2610
	Size: 0x1A4
	Parameters: 1
	Flags: Linked
*/
function intro_screen(str_objective)
{
	intro_anim_struct = struct::get("tag_align_intro", "targetname");
	vengeance_util::co_op_teleport_on_igc_end("cin_ven_01_intro_3rd_sh070", "intro_igc_teleport");
	intro_anim_struct scene::init("cin_ven_01_intro_3rd_sh010");
	util::set_streamer_hint(1);
	level thread intro_street_vignette_setup();
	level thread intro_street_ambient_vehicles();
	load::function_c32ba481();
	util::do_chyron_text(&"CP_MI_SING_VENGEANCE_INTRO_LINE_1_FULL", &"CP_MI_SING_VENGEANCE_INTRO_LINE_1_SHORT", &"CP_MI_SING_VENGEANCE_INTRO_LINE_2_FULL", &"CP_MI_SING_VENGEANCE_INTRO_LINE_2_SHORT", &"CP_MI_SING_VENGEANCE_INTRO_LINE_3_FULL", &"CP_MI_SING_VENGEANCE_INTRO_LINE_3_SHORT", &"CP_MI_SING_VENGEANCE_INTRO_LINE_4_FULL", &"CP_MI_SING_VENGEANCE_INTRO_LINE_4_SHORT");
	thread cp_mi_sing_vengeance_sound::function_4368969a();
	if(isdefined(level.bzm_vengeancedialogue1callback))
	{
		level thread [[level.bzm_vengeancedialogue1callback]]();
	}
	level thread namespace_9fd035::function_7dc66faa();
	intro_anim_struct scene::play("cin_ven_01_intro_3rd_sh010");
	level waittill(#"intro_igc_done");
	util::clear_streamer_hint();
}

/*
	Name: function_21e6e30e
	Namespace: vengeance_intro
	Checksum: 0xCEBFE949
	Offset: 0x27C0
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function function_21e6e30e()
{
	objectives::set("cp_level_vengeance_rescue_kane");
	objectives::set("cp_level_vengeance_go_to_safehouse");
	level flag::wait_till("send_hendricks_to_apartment_entrance");
	objectives::set("cp_waypoint_breadcrumb", struct::get("waypoint_intro1"));
	level flag::wait_till("apartment_entrance_door_open");
	objectives::complete("cp_waypoint_breadcrumb", struct::get("waypoint_intro1"));
	level thread function_a1d4e729("breadcrumb_apartment1_triggered", "set_breadcrumb_apartment1", "breadcrumb_apartment1");
	level flag::wait_till("breadcrumb_apartment1_triggered");
	if(!level flag::get("breadcrumb_apartment1"))
	{
		level notify(#"hash_9f640c4a");
	}
	level thread function_a1d4e729("breadcrumb_apartment2_triggered", "set_breadcrumb_apartment2", "breadcrumb_apartment2");
	level flag::wait_till("breadcrumb_apartment2_triggered");
	if(!level flag::get("breadcrumb_apartment2"))
	{
		level notify(#"hash_9f640c4a");
	}
	level thread function_a1d4e729("breadcrumb_apartment3_triggered", "set_breadcrumb_apartment3", "breadcrumb_apartment3");
}

/*
	Name: function_a1d4e729
	Namespace: vengeance_intro
	Checksum: 0x73A80B5D
	Offset: 0x29C0
	Size: 0x6C
	Parameters: 3
	Flags: Linked
*/
function function_a1d4e729(endon_flag, wait_flag, breadcrumb)
{
	level endon(endon_flag);
	level flag::wait_till(wait_flag);
	level objectives::breadcrumb(breadcrumb);
	level flag::set(breadcrumb);
}

/*
	Name: intro_street_ambient_vehicles
	Namespace: vengeance_intro
	Checksum: 0xF07227A4
	Offset: 0x2A38
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function intro_street_ambient_vehicles()
{
	level endon(#"takedown_begin");
	vehicle::add_spawn_function("intro_street_technical", &give_riders);
	vehicle::add_spawn_function("intro_street_technical2", &give_riders);
	level flag::wait_till("send_hendricks_to_apartment_entrance");
	level thread cp_mi_sing_vengeance_sound::function_6dcacaf4();
	wait(1);
	intro_street_technical = vehicle::simple_spawn_single_and_drive("intro_street_technical");
	var_7d36720d = vehicle::simple_spawn_single_and_drive("intro_street_technical2");
	wait(0.25);
	intro_street_technical thread function_b36ddcbc();
	var_7d36720d thread function_b36ddcbc();
}

/*
	Name: function_3b2e29a
	Namespace: vengeance_intro
	Checksum: 0xA61F03E5
	Offset: 0x2B60
	Size: 0x158
	Parameters: 0
	Flags: None
*/
function function_3b2e29a()
{
	level endon(#"takedown_begin");
	count = 0;
	vehicle::add_spawn_function("intro_street_technical", &give_riders);
	vehicle::add_spawn_function("intro_street_technical2", &give_riders);
	while(count <= 75)
	{
		if(math::cointoss())
		{
			intro_street_technical = vehicle::simple_spawn_single_and_drive("intro_street_technical");
		}
		else
		{
			intro_street_technical = vehicle::simple_spawn_single_and_drive("intro_street_technical");
			var_7d36720d = vehicle::simple_spawn_single_and_drive("intro_street_technical2");
		}
		count++;
		wait(0.25);
		intro_street_technical thread function_b36ddcbc();
		if(isdefined(var_7d36720d))
		{
			var_7d36720d thread function_b36ddcbc();
		}
		wait(randomfloatrange(15, 20));
	}
}

/*
	Name: give_riders
	Namespace: vengeance_intro
	Checksum: 0x34D3A75D
	Offset: 0x2CC0
	Size: 0xEE
	Parameters: 0
	Flags: Linked
*/
function give_riders()
{
	var_ae407c5 = [];
	var_5ee71f72 = array("driver", "gunner1");
	for(i = 0; i < var_5ee71f72.size; i++)
	{
		var_ae407c5[i] = spawner::simple_spawn_single("intro_street_technical_enemy1");
		if(isdefined(var_ae407c5[i]))
		{
			var_ae407c5[i] ai::set_ignoreall(1);
			var_ae407c5[i] vehicle::get_in(self, var_5ee71f72[i], 1);
		}
	}
}

/*
	Name: function_b36ddcbc
	Namespace: vengeance_intro
	Checksum: 0xCA8A7F88
	Offset: 0x2DB8
	Size: 0x1F6
	Parameters: 0
	Flags: Linked
*/
function function_b36ddcbc()
{
	self endon(#"death");
	level endon(#"takedown_begin");
	self turret::set_burst_parameters(1, 2, 0.25, 0.75, 1);
	ai_gunner = self vehicle::get_rider("gunner1");
	if(isdefined(ai_gunner))
	{
		var_153dcea0 = struct::get_array("intro_street_technical_fake_target", "targetname");
		fake_target = array::random(var_153dcea0);
		if(!isdefined(fake_target.ent))
		{
			fake_target.ent = spawn("script_model", fake_target.origin);
			fake_target.ent setmodel("tag_origin");
			fake_target.ent.health = 1;
			fake_target.ent thread function_352b4f2e();
		}
		self thread turret::shoot_at_target(fake_target.ent, -1, undefined, 1, 0);
		ai_gunner waittill(#"death");
		self notify(#"_stop_turret1");
	}
}

/*
	Name: function_352b4f2e
	Namespace: vengeance_intro
	Checksum: 0x85972CD4
	Offset: 0x2FB8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_352b4f2e()
{
	level flag::wait_till("takedown_begin");
	wait(1);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: intro_hendricks
	Namespace: vengeance_intro
	Checksum: 0xD6446FB8
	Offset: 0x3008
	Size: 0x27C
	Parameters: 0
	Flags: Linked
*/
function intro_hendricks()
{
	var_cb5f6358 = getent("apt_door_l", "targetname");
	var_7af28d51 = getent("apt_door_l_clip", "targetname");
	var_7af28d51 linkto(var_cb5f6358);
	var_1f32c7f6 = getent("apt_door_r", "targetname");
	var_46820983 = getent("apt_door_r_clip", "targetname");
	var_46820983 linkto(var_1f32c7f6);
	level.var_469a8d0d = struct::get("hendricks_apartment_anim_struct", "targetname");
	var_6a07eb6c = [];
	var_6a07eb6c[0] = "dead_door_civilian";
	scene::add_scene_func("cin_ven_02_10_apthorror_enterbldg_vign", &vengeance_util::function_65a61b78, "init", var_6a07eb6c);
	level.var_469a8d0d scene::init("cin_ven_02_10_apthorror_enterbldg_vign");
	level.var_af857373 = struct::get("hendricks_street_anim_struct", "targetname");
	level.var_469a8d0d scene::play("cin_ven_01_15_introstreet_walk_vign");
	if(!level flag::get("hendricks_move_to_apartment_building"))
	{
		level flag::wait_till("hendricks_move_to_apartment_building");
	}
	level thread function_8fc34056();
	wait(3.5);
	level thread cp_mi_sing_vengeance_sound::function_677a24e2();
	wait(1.5);
	level flag::set("apartment_entrance_door_open");
}

/*
	Name: function_8fc34056
	Namespace: vengeance_intro
	Checksum: 0xF45167C4
	Offset: 0x3290
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function function_8fc34056()
{
	level endon(#"hash_1d07a130");
	level endon(#"hash_2d132925");
	level endon(#"hash_fca941a1");
	level thread function_d5df9cca("breadcrumb_apartment1_triggered", "set_breadcrumb_apartment1");
	level thread function_d5df9cca("breadcrumb_apartment2_triggered", "set_breadcrumb_apartment2");
	level thread function_d5df9cca("breadcrumb_apartment3_triggered", "set_breadcrumb_apartment3");
	var_6a07eb6c = [];
	var_6a07eb6c[0] = "dead_door_civilian";
	scene::add_scene_func("cin_ven_02_10_apthorror_enterbldg_vign", &vengeance_util::function_65a61b78, "play", var_6a07eb6c);
	level.var_469a8d0d scene::play("cin_ven_02_10_apthorror_enterbldg_vign");
	if(!level flag::get("breadcrumb_apartment1_triggered"))
	{
		level flag::wait_till("breadcrumb_apartment1_triggered");
	}
	level.var_469a8d0d scene::play("cin_ven_02_10_apthorror_firstfloorapt_vign");
	if(isdefined(level.bzm_vengeancedialogue2callback))
	{
		level thread [[level.bzm_vengeancedialogue2callback]]();
	}
	if(!level flag::get("player_near_apartment_stairs"))
	{
		level flag::wait_till("player_near_apartment_stairs");
	}
	level.var_469a8d0d scene::play("cin_ven_02_10_apthorror_secondfloorapt_vign");
}

/*
	Name: function_d5df9cca
	Namespace: vengeance_intro
	Checksum: 0x37A8B740
	Offset: 0x3488
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function function_d5df9cca(endon_flag, var_1e583720)
{
	level endon(endon_flag);
	level.ai_hendricks waittill(var_1e583720);
	level flag::set(var_1e583720);
}

/*
	Name: function_858195d5
	Namespace: vengeance_intro
	Checksum: 0x5427F7C6
	Offset: 0x34D8
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function function_858195d5()
{
	wait(2);
	level thread function_d259704f();
	level flag::wait_till("send_hendricks_to_apartment_entrance");
	wait(3);
	level thread dialog::player_say("plyr_let_s_get_out_of_the_0");
	level flag::set("hendricks_move_to_apartment_building");
	wait(4.5);
	level.ai_hendricks vengeance_util::function_5fbec645("hend_agreed_we_ll_cut_th_1");
	level flag::wait_till("hendricks_apartment_vo");
	level thread function_c55b72a5();
	level endon(#"hash_1d07a130");
	level.ai_hendricks util::waittill_either("noise_upstairs", "player_near_apartment_stairs");
	thread cp_mi_sing_vengeance_sound::function_afc6fda4();
	wait(1);
	level.ai_hendricks vengeance_util::function_5fbec645("hend_contact_upstairs_ta_1");
	level dialog::player_say("plyr_i_hear_it_0");
}

/*
	Name: function_d259704f
	Namespace: vengeance_intro
	Checksum: 0xD959B048
	Offset: 0x3648
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_d259704f()
{
	level endon(#"hash_996095e7");
	wait(1);
	level.ai_hendricks vengeance_util::function_5fbec645("hend_it_s_a_god_damn_warz_0");
	wait(1);
	level.ai_hendricks vengeance_util::function_5fbec645("hend_they_slaughtered_em_0");
	wait(0.5);
}

/*
	Name: skipto_intro_done
	Namespace: vengeance_intro
	Checksum: 0xF2121BF8
	Offset: 0x36B8
	Size: 0x164
	Parameters: 4
	Flags: Linked
*/
function skipto_intro_done(str_objective, b_starting, b_direct, player)
{
	level struct::delete_script_bundle("scene", "cin_ven_01_intro_3rd_sh010");
	level struct::delete_script_bundle("scene", "cin_ven_01_intro_3rd_sh020");
	level struct::delete_script_bundle("scene", "cin_ven_01_intro_3rd_sh030");
	level struct::delete_script_bundle("scene", "cin_ven_01_intro_3rd_sh040");
	level struct::delete_script_bundle("scene", "cin_ven_01_intro_3rd_sh050");
	level struct::delete_script_bundle("scene", "cin_ven_01_intro_3rd_sh060");
	level struct::delete_script_bundle("scene", "cin_ven_01_intro_3rd_sh070");
	level struct::delete_script_bundle("scene", "cin_ven_01_15_introstreet_walk_vign");
}

/*
	Name: function_5cb54255
	Namespace: vengeance_intro
	Checksum: 0xE4ADEA73
	Offset: 0x3828
	Size: 0x2BC
	Parameters: 2
	Flags: Linked
*/
function function_5cb54255(str_objective, b_starting)
{
	if(b_starting)
	{
		util::set_level_start_flag("start_level");
		vengeance_util::skipto_baseline(str_objective, b_starting);
		vengeance_util::init_hero("hendricks", str_objective);
		level.ai_hendricks ai::set_ignoreall(1);
		level.ai_hendricks ai::set_ignoreme(1);
		level.ai_hendricks.goalradius = 32;
		level.ai_hendricks ai::set_behavior_attribute("cqb", 1);
		level.ai_hendricks battlechatter::function_d9f49fba(0);
		level thread intro_street_vignette_setup();
		level.var_469a8d0d = struct::get("hendricks_apartment_anim_struct", "targetname");
		level.var_469a8d0d thread scene::play("cin_ven_02_10_apthorror_secondfloorapt_vign");
		level thread function_d5df9cca("breadcrumb_apartment3_triggered", "set_breadcrumb_apartment3");
		level thread function_a1d4e729("breadcrumb_apartment3_triggered", "set_breadcrumb_apartment3", "breadcrumb_apartment3");
		level flag::wait_till("all_players_spawned");
		level flag::set("start_level");
		foreach(e_player in level.players)
		{
			e_player thread function_773ef6a0();
		}
		objectives::set("cp_level_vengeance_rescue_kane");
		objectives::set("cp_level_vengeance_go_to_safehouse");
	}
	apartment_main();
}

/*
	Name: apartment_main
	Namespace: vengeance_intro
	Checksum: 0xE04058E5
	Offset: 0x3AF0
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function apartment_main()
{
	level.var_5bc00cbb = struct::get("bedroom_anim_struct", "targetname");
	level thread function_5ef7fdc2();
	level flag::wait_till("player_near_apartment_stairs");
	thread cp_mi_sing_vengeance_sound::apartment_init();
	level flag::set("apartment_begin");
	level thread function_99eb6152();
	level thread function_5274de79();
	level thread function_b3c6efd1();
	level thread function_7acb5fc4();
	level flag::wait_till("apartment_complete");
	skipto::objective_completed("intro");
}

/*
	Name: function_99eb6152
	Namespace: vengeance_intro
	Checksum: 0x27944162
	Offset: 0x3C28
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_99eb6152()
{
	level flag::wait_till("breadcrumb_apartment3_triggered");
	if(!level flag::get("breadcrumb_apartment3"))
	{
		level notify(#"hash_9f640c4a");
	}
	level waittill(#"hash_cf441b58");
	objectives::set("cp_waypoint_breadcrumb", struct::get("waypoint_intro5"));
}

/*
	Name: function_5274de79
	Namespace: vengeance_intro
	Checksum: 0x71E55A5
	Offset: 0x3CC8
	Size: 0x694
	Parameters: 0
	Flags: Linked
*/
function function_5274de79()
{
	level.ai_hendricks ai::set_ignoreme(1);
	level flag::wait_till_any(array("apartment_enemies_alerted", "synckill_scene_complete", "apartment_enemies_dead"));
	level.ai_hendricks ai::set_ignoreme(0);
	wait(0.05);
	if(level.var_469a8d0d scene::is_playing("cin_ven_02_10_apthorror_enterbldg_vign"))
	{
		level.var_469a8d0d scene::stop("cin_ven_02_10_apthorror_enterbldg_vign");
	}
	if(level.var_469a8d0d scene::is_playing("cin_ven_02_10_apthorror_firstfloorapt_vign"))
	{
		level.var_469a8d0d scene::stop("cin_ven_02_10_apthorror_firstfloorapt_vign");
	}
	if(level.var_469a8d0d scene::is_playing("cin_ven_02_10_apthorror_secondfloorapt_vign"))
	{
		level.var_469a8d0d scene::stop("cin_ven_02_10_apthorror_secondfloorapt_vign");
	}
	level.var_469a8d0d scene::stop();
	level.ai_hendricks stopanimscripted();
	level.ai_hendricks ai::set_behavior_attribute("cqb", 0);
	if(!level flag::get("apartment_enemies_dead"))
	{
		level.ai_hendricks.goalradius = 16;
		node = getnode("hendricks_syncshot_node", "targetname");
		level.ai_hendricks setgoalnode(node);
		level.ai_hendricks ai::set_ignoreall(0);
		level.ai_hendricks ai::set_ignoreme(0);
		level.ai_hendricks.var_df53bc6 = level.ai_hendricks.script_accuracy;
		level.ai_hendricks.script_accuracy = 0.1;
		level flag::wait_till_timeout(8, "apartment_enemies_dead");
		if(!level flag::get("apartment_enemies_dead"))
		{
			if(isdefined(level.ai_hendricks.var_df53bc6))
			{
				level.ai_hendricks.script_accuracy = level.ai_hendricks.var_df53bc6;
			}
			level flag::wait_till("apartment_enemies_dead");
		}
		level.ai_hendricks ai::set_ignoreall(1);
		level.ai_hendricks ai::set_ignoreme(1);
		if(isdefined(level.ai_hendricks.var_df53bc6))
		{
			level.ai_hendricks.script_accuracy = level.ai_hendricks.var_df53bc6;
		}
	}
	level thread function_dcf3d41b();
	node = getnode("hendricks_bedroom_door_node", "targetname");
	level.ai_hendricks setgoal(node);
	level.ai_hendricks waittill(#"goal");
	level thread util::set_streamer_hint(2);
	level thread takedown_scene_setup();
	level.var_5bc00cbb thread scene::play("cin_ven_02_30_masterbedroom_vign");
	wait(11);
	videostop("cp_vengeance_env_sign_dancer01");
	wait(0.05);
	level thread vengeance_util::function_ab876b5a("cp_vengeance_env_sign_dancer01", "strip_video_start", "strip_video_end");
	wait(0.05);
	level notify(#"hash_96cd3d20");
	node = getnode("hendricks_takedown_rooftop_node", "targetname");
	level.ai_hendricks setgoal(node);
	level.ai_hendricks ai::set_behavior_attribute("cqb", 1);
	clip = getent("chair_a_clip_top", "targetname");
	if(isdefined(clip))
	{
		clip delete();
	}
	wait(2);
	level thread function_caf96976();
	level.var_5bc00cbb waittill(#"scene_done");
	level notify(#"hash_cf441b58");
	level flag::set("bedroom_scene_complete");
	level flag::wait_till("player_on_takedown_rooftop");
	var_9c1589f3 = getentarray("gunfire_behind_window", "targetname");
	foreach(card in var_9c1589f3)
	{
		card hide();
	}
	level flag::set("apartment_complete");
}

/*
	Name: function_dcf3d41b
	Namespace: vengeance_intro
	Checksum: 0x5015D38D
	Offset: 0x4368
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_dcf3d41b()
{
	if(!level flag::get("hendricks_on_second_floor_apartment"))
	{
		level flag::wait_till("hendricks_on_second_floor_apartment");
	}
	level.ai_hendricks ai::set_behavior_attribute("cqb", 1);
}

/*
	Name: function_5ef7fdc2
	Namespace: vengeance_intro
	Checksum: 0xB7C13CEB
	Offset: 0x43E0
	Size: 0x414
	Parameters: 0
	Flags: Linked
*/
function function_5ef7fdc2()
{
	trigger::wait_till("apartment_light_fire_trigger");
	level.var_1dca7888 = [];
	var_71e5f989 = getentarray("apartment_enemy", "script_noteworthy");
	var_6a00e3c4 = spawner::simple_spawn(var_71e5f989, &function_1f707d1e);
	var_12d51ad2 = getentarray("apartment_civilian", "script_noteworthy");
	var_c5b87ef7 = spawner::simple_spawn(var_12d51ad2, &function_a645cfd9);
	var_1cef4611 = getent("bedroom_door_right", "targetname");
	var_59f550ce = getent("bedroom_door_right_clip", "targetname");
	var_59f550ce linkto(var_1cef4611);
	var_517e2322 = getent("bedroom_door_left", "targetname");
	var_702c9f7 = getent("bedroom_door_left_clip", "targetname");
	var_702c9f7 linkto(var_517e2322);
	level.var_5bc00cbb thread scene::init("cin_ven_02_20_synckill_vign");
	level.var_7819b21b = level.var_1dca7888.size;
	namespace_523da15d::function_dab879d0();
	trigger = getent("syncshot_lookat_trigger", "targetname");
	foreach(player in level.players)
	{
		player thread function_4e050c10(trigger, "syncshot_lookat_failsafe");
	}
	trigger = getent("syncshot_stair_lookat_trigger", "targetname");
	foreach(player in level.players)
	{
		player thread function_4e050c10(trigger, "syncshot_lookat_failsafe");
	}
	level flag::wait_till_any(array("player_looking", "syncshot_lookat_failsafe"));
	level notify(#"hash_5262905a");
	level thread function_7f6de599();
	level flag::wait_till_any(array("apartment_enemies_alerted", "synckill_scene_complete", "apartment_enemies_dead"));
}

/*
	Name: function_4e050c10
	Namespace: vengeance_intro
	Checksum: 0xC2C09636
	Offset: 0x4800
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function function_4e050c10(trigger, endon_flag)
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"player_looking");
	if(isdefined(endon_flag))
	{
		level endon(endon_flag);
	}
	trigger_target = struct::get(trigger.target, "targetname");
	while(true)
	{
		if(self istouching(trigger))
		{
			if(util::is_player_looking_at(trigger_target.origin, 0.6, 1))
			{
				level flag::set("player_looking");
				break;
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_7f6de599
	Namespace: vengeance_intro
	Checksum: 0x345A3E69
	Offset: 0x4900
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_7f6de599()
{
	level endon(#"hash_1d07a130");
	level.var_5bc00cbb thread scene::play("cin_ven_02_20_synckill_vign");
	thread cp_mi_sing_vengeance_sound::function_57ec1ad7();
	wait(0.25);
	level.var_5bc00cbb waittill(#"scene_done");
	level flag::set("synckill_scene_complete");
}

/*
	Name: function_1f707d1e
	Namespace: vengeance_intro
	Checksum: 0xBABA3730
	Offset: 0x4980
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function function_1f707d1e()
{
	self endon(#"death");
	array::add(level.var_1dca7888, self);
	self.goalradius = 32;
	if(isdefined(self.targetname))
	{
		if(self.targetname == "synckill_enemy1_ai")
		{
			level.var_657f947a = self;
		}
		if(self.targetname == "synckill_enemy2_ai")
		{
			level.var_3f7d1a11 = self;
		}
		if(self.targetname == "synckill_enemy3_ai")
		{
			level.var_197a9fa8 = self;
		}
	}
	level flag::wait_till_any(array("player_looking", "syncshot_lookat_failsafe"));
	self thread function_fb5e09cf();
	if(self.targetname == "synckill_enemy2_ai")
	{
		self thread function_3a005b50();
		self waittill(#"hash_940c80ec");
		self.allowdeath = 1;
	}
	self thread function_1d07a130();
	self thread function_5a4b0113();
}

/*
	Name: function_3a005b50
	Namespace: vengeance_intro
	Checksum: 0x19E1892
	Offset: 0x4AE8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_3a005b50()
{
	self endon(#"death");
	self ai::set_ignoreme(1);
	self util::waittill_any("damage", "alert", "killable_now");
	self ai::set_ignoreme(0);
}

/*
	Name: function_a645cfd9
	Namespace: vengeance_intro
	Checksum: 0xD4A82F5
	Offset: 0x4B60
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_a645cfd9()
{
	self.ignoreme = 1;
	self.team = "allies";
	self disableaimassist();
}

/*
	Name: function_fb5e09cf
	Namespace: vengeance_intro
	Checksum: 0xE5FDDFB6
	Offset: 0x4BA0
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_fb5e09cf()
{
	self waittill(#"death");
	if(!level flag::get("apartment_enemy_dead"))
	{
		level flag::set("apartment_enemy_dead");
	}
	level.var_1dca7888 = array::remove_dead(level.var_1dca7888);
	if(level.var_1dca7888.size == 0)
	{
		level flag::set("apartment_enemies_dead");
	}
}

/*
	Name: function_5a4b0113
	Namespace: vengeance_intro
	Checksum: 0xE68B44A1
	Offset: 0x4C48
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_5a4b0113()
{
	self endon(#"death");
	level endon(#"hash_fca941a1");
	self waittill(#"alert", state);
	if(!level flag::get("apartment_enemies_alerted"))
	{
		level flag::set("apartment_enemies_alerted");
	}
}

/*
	Name: function_1d07a130
	Namespace: vengeance_intro
	Checksum: 0x7DD73E86
	Offset: 0x4CC8
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_1d07a130()
{
	self endon(#"death");
	level flag::wait_till_any(array("apartment_enemies_alerted", "synckill_scene_complete", "syncshot_lookat_failsafe"));
	if(level flag::get("syncshot_lookat_failsafe"))
	{
		wait(0.25);
	}
	self notify(#"alert");
	if(level flag::get("apartment_enemies_alerted") || level flag::get("syncshot_lookat_failsafe"))
	{
		self stopanimscripted();
		wait(0.05);
	}
	node = getnode(self.target, "targetname");
	self setgoal(node, 1, 8);
}

/*
	Name: function_b3c6efd1
	Namespace: vengeance_intro
	Checksum: 0xCC38F619
	Offset: 0x4E08
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_b3c6efd1()
{
	level flag::wait_till("player_near_apartment_stairs");
	wait(0.5);
	level.ai_hendricks notify(#"hash_7d304e15");
	level thread function_cce1e811();
	level.ai_hendricks waittill(#"hash_d05bd175");
	level dialog::player_say("plyr_once_we_find_her_n_0");
}

/*
	Name: function_cce1e811
	Namespace: vengeance_intro
	Checksum: 0xE7D888D4
	Offset: 0x4E98
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_cce1e811()
{
	level endon(#"hash_1d07a130");
	level endon(#"hash_2d132925");
	if(!level flag::get("hendricks_on_second_floor_apartment"))
	{
		level flag::wait_till("hendricks_on_second_floor_apartment");
	}
	if(!level flag::get("player_is_upstairs"))
	{
		level flag::wait_till("player_is_upstairs");
	}
	wait(2);
	level.ai_hendricks vengeance_util::function_5fbec645("hend_take_them_out_1");
}

/*
	Name: function_c55b72a5
	Namespace: vengeance_intro
	Checksum: 0x1A0EA4F0
	Offset: 0x4F60
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_c55b72a5()
{
	level endon(#"hash_a2cf5f81");
	var_ba1e1975 = getent("bedroom_audio_origin", "targetname");
	level thread function_a5bf9c17(var_ba1e1975);
	level flag::wait_till_any(array("apartment_enemies_alerted", "syncshot_lookat_failsafe"));
	level notify(#"kill_pending_dialog");
	var_ba1e1975 notify(#"kill_pending_dialog");
}

/*
	Name: function_a5bf9c17
	Namespace: vengeance_intro
	Checksum: 0x9785F1B2
	Offset: 0x5008
	Size: 0x244
	Parameters: 1
	Flags: Linked
*/
function function_a5bf9c17(var_ba1e1975)
{
	level endon(#"hash_1d07a130");
	level endon(#"hash_1047ee39");
	var_ba1e1975 = getent("bedroom_audio_origin", "targetname");
	var_ba1e1975 vengeance_util::function_5fbec645("ffim1_what_are_you_going_t_0");
	var_ba1e1975 vengeance_util::function_5fbec645("mciv_leave_us_alone_0");
	var_ba1e1975 vengeance_util::function_5fbec645("ffim2_no_no_he_s_mine_0");
	var_ba1e1975 vengeance_util::function_5fbec645("ffim2_death_will_be_quick_0");
	var_ba1e1975 vengeance_util::function_5fbec645("mciv_what_s_wrong_with_yo_0");
	var_ba1e1975 vengeance_util::function_5fbec645("ffim1_you_did_plenty_0");
	var_ba1e1975 vengeance_util::function_5fbec645("ffim1_all_of_you_have_liv_0");
	var_ba1e1975 vengeance_util::function_5fbec645("ffim2_tell_her_goodbye_0");
	var_ba1e1975 vengeance_util::function_5fbec645("mciv_no_0");
	wait(2);
	var_ba1e1975 vengeance_util::function_5fbec645("ffim3_now_it_s_your_turn_0");
	var_ba1e1975 vengeance_util::function_5fbec645("ffim1_no_one_s_left_to_sav_0");
	var_ba1e1975 vengeance_util::function_5fbec645("ffim3_i_want_a_piece_of_he_0");
	var_ba1e1975 vengeance_util::function_5fbec645("ffim3_you_ll_get_them_one_0");
	var_ba1e1975 vengeance_util::function_5fbec645("ffim2_the_last_one_died_to_0");
	var_ba1e1975 vengeance_util::function_5fbec645("ffim1_is_that_your_daughte_0");
	var_ba1e1975 vengeance_util::function_5fbec645("ffim2_i_bet_she_s_soft_0");
}

/*
	Name: function_4bd6211
	Namespace: vengeance_intro
	Checksum: 0x918C1E5
	Offset: 0x5258
	Size: 0x108
	Parameters: 1
	Flags: None
*/
function function_4bd6211(var_ba1e1975)
{
	level endon(#"hash_5262905a");
	var_2ab10bee = [];
	var_2ab10bee[0] = "fciv_crying_hysterically_0";
	var_2ab10bee[1] = "fciv_crying_hysterically_1";
	var_2ab10bee[2] = "fciv_crying_hysterically_2";
	var_2ab10bee[3] = "fciv_crying_hysterically_3";
	var_2ab10bee[4] = "fciv_crying_hysterically_4";
	var_2ab10bee[5] = "fciv_crying_hysterically_5";
	while(true)
	{
		var_616d3e3e = array::random(var_2ab10bee);
		var_ba1e1975 vengeance_util::function_5fbec645(var_616d3e3e);
		wait(randomfloatrange(0.5, 2));
	}
}

/*
	Name: function_7acb5fc4
	Namespace: vengeance_intro
	Checksum: 0xA046B335
	Offset: 0x5368
	Size: 0x3EA
	Parameters: 0
	Flags: Linked
*/
function function_7acb5fc4()
{
	level.var_5bc00cbb scene::init("cin_ven_02_30_masterbedroom_vign");
	wait(0.5);
	var_dad63b6d = [];
	var_a0eb961c = getent("chair_a", "targetname");
	array::add(var_dad63b6d, var_a0eb961c);
	var_f55990dd = getent("chair_a_clip", "targetname");
	array::add(var_dad63b6d, var_f55990dd);
	var_f55990dd linkto(var_a0eb961c);
	var_a6f749a8 = getent("door_exit", "targetname");
	array::add(var_dad63b6d, var_a6f749a8);
	var_c7bdecc1 = getent("door_exit_clip", "targetname");
	array::add(var_dad63b6d, var_c7bdecc1);
	var_c7bdecc1 linkto(var_a6f749a8);
	var_7f0731c6 = var_a6f749a8.origin;
	var_c815eaa0 = var_a6f749a8.angles;
	civilians = [];
	civilians[civilians.size] = getent("synckill_dead_civilian_ai", "targetname");
	civilians[civilians.size] = getent("synckill_husband_ai", "targetname");
	civilians[civilians.size] = getent("synckill_wife_ai", "targetname");
	foreach(civ in civilians)
	{
		civ.ignoreme = 1;
	}
	level flag::wait_till("start_takedown_igc");
	var_a6f749a8 stopanimscripted();
	var_a6f749a8.origin = var_7f0731c6;
	var_a6f749a8.angles = var_c815eaa0;
	level flag::wait_till("start_dogleg_1_intro");
	foreach(prop in var_dad63b6d)
	{
		if(isdefined(prop))
		{
			prop delete();
		}
	}
}

/*
	Name: function_4762cf8f
	Namespace: vengeance_intro
	Checksum: 0x568DB185
	Offset: 0x5760
	Size: 0x24
	Parameters: 4
	Flags: Linked
*/
function function_4762cf8f(str_objective, b_starting, b_direct, player)
{
}

/*
	Name: skipto_takedown_init
	Namespace: vengeance_intro
	Checksum: 0x5573830A
	Offset: 0x5790
	Size: 0x374
	Parameters: 2
	Flags: Linked
*/
function skipto_takedown_init(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		vengeance_util::skipto_baseline(str_objective, b_starting);
		vengeance_util::init_hero("hendricks", str_objective);
		level.ai_hendricks ai::set_ignoreall(1);
		level.ai_hendricks ai::set_ignoreme(1);
		level.ai_hendricks.goalradius = 32;
		level.ai_hendricks battlechatter::function_d9f49fba(0);
		takedown_scene_setup();
		while(!level scene::is_ready("cin_ven_03_10_takedown_intro_1st"))
		{
			wait(0.05);
		}
		while(!level scene::is_ready("cin_ven_03_10_takedown_intro_1st_props"))
		{
			wait(0.05);
		}
		while(!level scene::is_ready("cin_ven_01_02_rooftop_1st_overlook"))
		{
			wait(0.05);
		}
		videostop("cp_vengeance_env_sign_dancer01");
		wait(0.05);
		level thread vengeance_util::function_ab876b5a("cp_vengeance_env_sign_dancer01", "strip_video_start", "strip_video_end");
		wait(0.05);
		level notify(#"hash_96cd3d20");
		objectives::set("cp_waypoint_breadcrumb", struct::get("waypoint_intro5"));
		level thread function_caf96976();
		var_9c1589f3 = getentarray("gunfire_behind_window", "targetname");
		foreach(card in var_9c1589f3)
		{
			card hide();
		}
		objectives::set("cp_level_vengeance_rescue_kane");
		objectives::set("cp_level_vengeance_go_to_safehouse");
		level util::set_streamer_hint(2);
		load::function_a2995f22();
	}
	thread cp_mi_sing_vengeance_sound::function_7be69db9();
	level flag::set("takedown_begin");
	takedown_main(b_starting);
}

/*
	Name: takedown_main
	Namespace: vengeance_intro
	Checksum: 0x651C62F8
	Offset: 0x5B10
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function takedown_main(b_starting)
{
	level thread function_e522974a(b_starting);
	level thread function_e670b187();
	level thread hendricks_takedown_vo();
	level thread takedown_scene();
	level thread function_627987c5();
	level flag::wait_till("takedown_complete");
	skipto::objective_completed("takedown");
}

/*
	Name: function_e522974a
	Namespace: vengeance_intro
	Checksum: 0xE439A75E
	Offset: 0x5BD8
	Size: 0x152
	Parameters: 1
	Flags: Linked
*/
function function_e522974a(b_starting)
{
	var_9c1589f3 = getentarray("gunfire_behind_window", "targetname");
	foreach(card in var_9c1589f3)
	{
		card hide();
	}
	function_fb3f26d6(b_starting);
	foreach(card in var_9c1589f3)
	{
		card hide();
	}
}

/*
	Name: function_fb3f26d6
	Namespace: vengeance_intro
	Checksum: 0x8DEE110F
	Offset: 0x5D38
	Size: 0x602
	Parameters: 1
	Flags: Linked
*/
function function_fb3f26d6(b_starting)
{
	level endon(#"hash_ec8fe31d");
	if(isdefined(b_starting) && b_starting)
	{
		wait(1);
	}
	level flag::clear("player_looking");
	trigger = getent("takedown_window_gunfire_trigger", "targetname");
	foreach(player in level.players)
	{
		player thread function_4e050c10(trigger, "start_takedown_igc");
	}
	level flag::wait_till("player_looking");
	var_9c1589f3 = getentarray("gunfire_behind_window", "targetname");
	start = struct::get("takedown_window_gunfire_magicbullet_start", "targetname");
	end = struct::get("takedown_window_gunfire_magicbullet_end", "targetname");
	wait(1);
	foreach(card in var_9c1589f3)
	{
		card show();
	}
	magicbullet(level.ai_hendricks.weapon, start.origin, end.origin);
	playsoundatposition("evt_apt_win_gunfire_1", (20497, -4382, 492));
	wait(0.15);
	foreach(card in var_9c1589f3)
	{
		card hide();
	}
	wait(0.1);
	foreach(card in var_9c1589f3)
	{
		card show();
	}
	magicbullet(level.ai_hendricks.weapon, start.origin, end.origin);
	playsoundatposition("evt_apt_win_gunfire_2", (20497, -4382, 492));
	wait(0.15);
	foreach(card in var_9c1589f3)
	{
		card hide();
	}
	wait(0.5);
	foreach(card in var_9c1589f3)
	{
		card show();
	}
	magicbullet(level.ai_hendricks.weapon, start.origin, end.origin);
	playsoundatposition("evt_apt_win_gunfire_3", (20497, -4382, 492));
	wait(0.15);
	foreach(card in var_9c1589f3)
	{
		card hide();
	}
}

/*
	Name: function_627987c5
	Namespace: vengeance_intro
	Checksum: 0x4AC4740A
	Offset: 0x6348
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_627987c5()
{
	level flag::wait_till("start_killing_streets_ambient_anims");
	level thread vengeance_util::function_e3420328("killing_streets_ambient_anims", "dogleg_1_begin");
}

/*
	Name: function_e670b187
	Namespace: vengeance_intro
	Checksum: 0x17950EBF
	Offset: 0x63A0
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_e670b187()
{
	level flag::wait_till("start_takedown_igc");
	objectives::complete("cp_waypoint_breadcrumb", struct::get("waypoint_intro5"));
	level waittill(#"hash_3d3af5a5");
	objectives::set("cp_waypoint_breadcrumb", struct::get("waypoint_intro6"));
	level waittill(#"hash_bfaac156");
	objectives::complete("cp_waypoint_breadcrumb", struct::get("waypoint_intro6"));
}

/*
	Name: hendricks_takedown_vo
	Namespace: vengeance_intro
	Checksum: 0x416780AF
	Offset: 0x6480
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function hendricks_takedown_vo()
{
	level flag::wait_till("start_takedown_igc");
	wait(1.5);
	level thread function_d07dfdc1();
	level waittill(#"hash_d1668ed6");
	level thread namespace_9fd035::function_e18f629a();
	level.ai_hendricks waittill(#"hash_6ed80778");
	level dialog::player_say("plyr_this_is_what_happens_0");
	level dialog::player_say("plyr_we_get_kane_then_w_0");
	level dialog::player_say("plyr_we_don_t_leave_one_o_0");
	level notify(#"hash_c791440b");
}

/*
	Name: function_d07dfdc1
	Namespace: vengeance_intro
	Checksum: 0xE2611967
	Offset: 0x6570
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function function_d07dfdc1()
{
	level endon(#"hash_3d3af5a5");
	level waittill(#"hash_9c3eb25d");
	wait(2);
	level.ai_hendricks vengeance_util::function_5fbec645("hend_more_enemies_inboun_0");
	level waittill(#"hash_c1a33016");
}

/*
	Name: function_caf96976
	Namespace: vengeance_intro
	Checksum: 0xCC5AB5BA
	Offset: 0x65C8
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_caf96976()
{
	level endon(#"hash_ec8fe31d");
	var_abd40945 = getent("takedown_enemy_leader_audio_origin", "targetname");
	var_abd40945 vengeance_util::function_5fbec645("ffim1_today_we_rise_agains_0");
	var_abd40945 vengeance_util::function_5fbec645("ffim1_these_things_do_not_0");
	var_abd40945 vengeance_util::function_5fbec645("ffim1_do_not_make_it_quick_0");
	var_abd40945 vengeance_util::function_5fbec645("ffim1_they_are_the_oppress_0");
	var_abd40945 vengeance_util::function_5fbec645("ffim1_every_drop_of_their_0");
	var_abd40945 vengeance_util::function_5fbec645("ffim1_today_the_immortals_0");
	var_abd40945 thread vengeance_util::function_5fbec645("ffim2_yeaaaaahhh_an_0");
	var_abd40945 thread vengeance_util::function_5fbec645("ffim3_death_to_the_oppress_0");
	var_abd40945 thread vengeance_util::function_5fbec645("ffif0_aaaahhhhhh_0");
	var_abd40945 thread vengeance_util::function_5fbec645("ffim2_immorrrtaalllls_0");
}

/*
	Name: function_c6be5e1d
	Namespace: vengeance_intro
	Checksum: 0xAC809B95
	Offset: 0x6748
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function function_c6be5e1d()
{
	var_e022aef3 = getent("takedown_igc_trigger", "targetname");
	var_e022aef3 endon(#"death");
	var_e022aef3 trigger::wait_till();
	return var_e022aef3.who;
}

/*
	Name: takedown_scene
	Namespace: vengeance_intro
	Checksum: 0xA9066735
	Offset: 0x67B8
	Size: 0x9C4
	Parameters: 0
	Flags: Linked
*/
function takedown_scene()
{
	level.var_3d63f698 thread scene::init("cin_ven_03_11_gate_convo_vign");
	var_642e55f9 = getent("takedown_gate_right", "targetname");
	var_642e55f9 thread takedown_cleanup();
	var_f8d3fbd6 = getent("takedown_gate_right_clip", "targetname");
	var_f8d3fbd6 thread takedown_cleanup();
	var_f8d3fbd6 linkto(var_642e55f9, "tag_animate");
	var_eec324aa = getent("takedown_gate_left", "targetname");
	var_eec324aa thread takedown_cleanup();
	var_3a87217f = getent("takedown_gate_left_clip", "targetname");
	var_3a87217f thread takedown_cleanup();
	var_3a87217f linkto(var_eec324aa, "tag_animate");
	var_fde961b5 = function_c6be5e1d();
	level flag::wait_till("start_takedown_igc");
	level function_a2b65bd2(var_fde961b5);
	level thread cp_mi_sing_vengeance_sound::takedown_scene();
	if(isdefined(level.var_48158b2b))
	{
		level thread function_497db06c();
	}
	else
	{
		if(isdefined(level.bzm_vengeancedialogue2_1callback))
		{
			level thread [[level.bzm_vengeancedialogue2_1callback]]();
		}
		level.var_3d63f698 thread scene::play("cin_ven_03_10_takedown_intro_1st");
		level.var_3d63f698 thread scene::play("cin_ven_03_10_takedown_intro_1st_props");
		level.var_3d63f698 thread scene::play("cin_ven_01_02_rooftop_1st_overlook");
		level thread function_ca15fd13();
		level.ai_hendricks waittill(#"takedown_start");
		level.ai_hendricks cybercom::cybercom_armpulse(1);
	}
	util::clear_streamer_hint();
	level thread function_94b3c083();
	level thread function_64be6dbe();
	foreach(enemy in level.takedown_enemies)
	{
		if(isalive(enemy))
		{
			enemy.goalradius = 32;
			enemy setgoalpos(enemy.origin, 1);
			enemy.health = 40;
			enemy ai::set_ignoreall(0);
			enemy ai::set_ignoreme(0);
		}
	}
	level.ai_hendricks waittill(#"start_slowmo");
	level.var_6e0b32d8 = level.var_d9f6d6.size;
	namespace_523da15d::function_b510823b();
	setslowmotion(1, 0.3, 0.3);
	foreach(player in level.activeplayers)
	{
		player setmovespeedscale(0.3);
	}
	level.ai_hendricks waittill(#"stop_slowmo");
	thread cp_mi_sing_vengeance_sound::function_69fc18eb();
	setslowmotion(0.3, 1);
	foreach(player in level.activeplayers)
	{
		player setmovespeedscale(1);
	}
	level.ai_hendricks setgoalpos(level.ai_hendricks.origin, 1);
	level.ai_hendricks battlechatter::function_d9f49fba(1);
	level thread function_9c3eb25d();
	level.ai_hendricks ai::set_ignoreall(0);
	level.ai_hendricks ai::set_ignoreme(0);
	level.takedown_enemies = array::remove_dead(level.takedown_enemies);
	if(level.takedown_enemies.size > 0)
	{
		foreach(enemy in level.takedown_enemies)
		{
			if(isalive(enemy))
			{
				magicbullet(level.ai_hendricks.weapon, level.ai_hendricks gettagorigin("tag_flash"), enemy gettagorigin("j_head"), level.ai_hendricks, enemy);
				level.ai_hendricks thread ai::shoot_at_target("kill_within_time", enemy, "j_head", 0.1);
				enemy waittill(#"death");
			}
		}
	}
	if(isdefined(level.var_e7c1ffa) && level.var_e7c1ffa.size > 0)
	{
		node = getnode("hendricks_takedown_backup_node", "targetname");
		level.ai_hendricks setgoalnode(node);
		level.ai_hendricks ai::disable_pain();
		level.ai_hendricks thread function_44b7b533();
		while(level.var_e7c1ffa.size > 0)
		{
			level.var_e7c1ffa = array::remove_dead(level.var_e7c1ffa);
			wait(1);
		}
		level.ai_hendricks ai::enable_pain();
		level notify(#"hash_3d3af5a5");
	}
	level thread vengeance_killing_streets::function_9736d8c9();
	level thread vengeance_killing_streets::setup_killing_streets_intro_patroller_spawners();
	level.var_3d63f698 thread scene::play("cin_ven_03_11_gate_convo_vign");
	level notify(#"hash_d1668ed6");
	if(isdefined(level.bzm_vengeancedialogue3callback))
	{
		level thread [[level.bzm_vengeancedialogue3callback]]();
	}
	level.ai_hendricks setgoalpos(level.ai_hendricks.origin, 1);
	node = getnode("killing_streets_hendricks_node_03", "targetname");
	level.ai_hendricks setgoal(node, 1, 16);
	wait(15);
	level notify(#"hash_bfaac156");
	level.var_3d63f698 waittill(#"scene_done");
	level flag::set("takedown_complete");
}

/*
	Name: function_a2b65bd2
	Namespace: vengeance_intro
	Checksum: 0x24C76B74
	Offset: 0x7188
	Size: 0x11A
	Parameters: 1
	Flags: Linked
*/
function function_a2b65bd2(var_fde961b5)
{
	n_scene = 2;
	foreach(player in level.activeplayers)
	{
		if(player === var_fde961b5)
		{
			player.var_efe0572d = "cin_ven_03_10_takedown_intro_1st_p1";
			player.var_ac3f2f23 = "cin_ven_03_10_takedown_1st_p1";
			continue;
		}
		player.var_efe0572d = "cin_ven_03_10_takedown_intro_1st_p" + n_scene;
		player.var_ac3f2f23 = "cin_ven_03_10_takedown_1st_p" + n_scene;
		n_scene++;
		player.play_scene_transition_effect = 1;
	}
}

/*
	Name: function_ca15fd13
	Namespace: vengeance_intro
	Checksum: 0x525DBC0E
	Offset: 0x72B0
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function function_ca15fd13()
{
	foreach(player in level.activeplayers)
	{
		player thread function_b5ab443b();
	}
}

/*
	Name: function_b5ab443b
	Namespace: vengeance_intro
	Checksum: 0x78FCC2EC
	Offset: 0x7348
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_b5ab443b()
{
	self endon(#"death");
	level.var_3d63f698 scene::play(self.var_efe0572d, self);
	level.var_3d63f698 scene::play(self.var_ac3f2f23, self);
}

/*
	Name: function_497db06c
	Namespace: vengeance_intro
	Checksum: 0x90028EAA
	Offset: 0x73A8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_497db06c()
{
	level.var_3d63f698 thread scene::play("cin_ven_01_02_rooftop_1st_overlook", level.var_48158b2b);
	level.var_3d63f698 thread scene::play("cin_ven_03_10_takedown_intro_1st_props");
	level.var_3d63f698 scene::play("cin_ven_03_10_takedown_intro_1st_test", level.var_d60e1bf0);
	level.var_3d63f698 thread scene::play("cin_ven_03_10_takedown_1st_hendricks", level.ai_hendricks);
	level.var_3d63f698 thread scene::play("cin_ven_03_10_takedown_1st", level.var_fc109659);
}

/*
	Name: function_94b3c083
	Namespace: vengeance_intro
	Checksum: 0x1ED2B540
	Offset: 0x7478
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_94b3c083()
{
	level.ai_hendricks waittill(#"stop_slowmo");
	level vengeance_util::function_a084a58f();
}

/*
	Name: function_44b7b533
	Namespace: vengeance_intro
	Checksum: 0xE8B2FE42
	Offset: 0x74B0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_44b7b533()
{
	self.var_df53bc6 = self.script_accuracy;
	self.script_accuracy = 0.2;
	level util::waittill_notify_or_timeout("takedown_backup_enemies_dead", 8);
	self.script_accuracy = self.var_df53bc6;
}

/*
	Name: function_9c3eb25d
	Namespace: vengeance_intro
	Checksum: 0x8AA7BD4A
	Offset: 0x7510
	Size: 0x4DA
	Parameters: 0
	Flags: Linked
*/
function function_9c3eb25d()
{
	vehicle::add_spawn_function("takedown_backup_truck", &function_296cfddf);
	var_235588b9 = vehicle::simple_spawn_single_and_drive("takedown_backup_truck");
	var_235588b9 vehicle::lights_off();
	level.var_e7c1ffa = [];
	var_6d37ea3 = 5;
	for(i = 0; i < var_6d37ea3; i++)
	{
		spawner = spawner::simple_spawn_single("takedown_backup_right_ai");
		spawner.script_noteworthy = "takedown_backup_right_" + i;
		spawner thread function_4d5e399c();
	}
	level notify(#"hash_9c3eb25d");
	wait(0.25);
	level.var_e7c1ffa = array::remove_dead(level.var_e7c1ffa);
	ai::waittill_dead(level.var_e7c1ffa, 3);
	volume = getent("takedown_backup_volume", "targetname");
	foreach(ai in level.var_e7c1ffa)
	{
		if(isdefined(ai) && isalive(ai))
		{
			ai setgoalvolume(volume);
			wait(randomfloatrange(0.3, 0.75));
		}
	}
	if(level.activeplayers.size == 1)
	{
		var_67bf54e = 2;
	}
	if(level.activeplayers.size == 2)
	{
		var_67bf54e = 2;
	}
	if(level.activeplayers.size == 3)
	{
		var_67bf54e = 3;
	}
	if(level.activeplayers.size == 4)
	{
		var_67bf54e = 3;
	}
	if(isdefined(var_67bf54e))
	{
		for(i = 0; i < var_67bf54e; i++)
		{
			spawner = spawner::simple_spawn_single("takedown_backup_right_ai");
			spawner.script_noteworthy = "takedown_backup_right_extra_" + i;
			spawner thread function_4d5e399c();
		}
	}
	wait(0.25);
	level.var_e7c1ffa = array::remove_dead(level.var_e7c1ffa);
	ai::waittill_dead(level.var_e7c1ffa, 3);
	level notify(#"hash_c1a33016");
	while(level.var_e7c1ffa.size > 3)
	{
		level.var_e7c1ffa = array::remove_dead(level.var_e7c1ffa);
		wait(0.05);
	}
	volume = getent("takedown_backup_front_volume", "targetname");
	foreach(ai in level.var_e7c1ffa)
	{
		if(isdefined(ai) && isalive(ai))
		{
			ai setgoalvolume(volume);
			wait(randomfloatrange(0.3, 0.75));
		}
	}
}

/*
	Name: function_52c5929b
	Namespace: vengeance_intro
	Checksum: 0xAD4B7105
	Offset: 0x79F8
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function function_52c5929b()
{
	self waittill(#"goal");
	self ai::set_ignoreall(0);
	self ai::set_ignoreme(0);
}

/*
	Name: function_296cfddf
	Namespace: vengeance_intro
	Checksum: 0xDFA57CE1
	Offset: 0x7A40
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function function_296cfddf()
{
	self endon(#"death");
	self thread takedown_cleanup();
	var_ae407c5 = [];
	var_5ee71f72 = array("driver", "passenger1", "gunner1");
	for(i = 0; i < var_5ee71f72.size; i++)
	{
		var_ae407c5[i] = spawner::simple_spawn_single("takedown_backup_truck_ai");
		var_ae407c5[i] thread function_4d5e399c();
		if(isdefined(var_ae407c5[i]))
		{
			var_ae407c5[i].script_noteworthy = var_5ee71f72[i];
			var_ae407c5[i] vehicle::get_in(self, var_5ee71f72[i], 1);
		}
	}
	self thread function_8fb2d768();
	level waittill(#"hash_ea1f086f");
	level flag::set("takedown_backup_truck_stopped_flag");
	self disconnectpaths();
}

/*
	Name: function_8fb2d768
	Namespace: vengeance_intro
	Checksum: 0x2060CA76
	Offset: 0x7BD8
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_8fb2d768()
{
	self endon(#"death");
	self flag::init("gunner_position_occupied");
	self turret::set_burst_parameters(1, 2, 0.25, 0.75, 1);
	ai_gunner = self vehicle::get_rider("gunner1");
	if(isdefined(ai_gunner))
	{
		self turret::enable(1, 1);
		self flag::set("gunner_position_occupied");
		ai_gunner waittill(#"death");
	}
	self turret::disable(1);
	self flag::clear("gunner_position_occupied");
}

/*
	Name: function_4d5e399c
	Namespace: vengeance_intro
	Checksum: 0xEE174947
	Offset: 0x7D30
	Size: 0x574
	Parameters: 0
	Flags: Linked
*/
function function_4d5e399c()
{
	self endon(#"death");
	array::add(level.var_e7c1ffa, self);
	if(isdefined(self.targetname) && self.targetname == "takedown_backup_right_ai_ai")
	{
		self setgoalpos(self.origin, 1);
		self ai::set_ignoreall(1);
		self ai::set_ignoreme(1);
		if(!level flag::get("takedown_backup_truck_stopped_flag"))
		{
			level flag::wait_till("takedown_backup_truck_stopped_flag");
		}
		if(isdefined(self.script_noteworthy) && self.script_noteworthy == "takedown_backup_right_3" || self.script_noteworthy == "takedown_backup_right_4" || self.script_noteworthy == "takedown_backup_right_extra_2")
		{
			volume = getent("takedown_backup_middle_volume", "targetname");
			wait(randomfloatrange(1, 3));
		}
		else
		{
			volume = getent("takedown_backup_left_volume", "targetname");
			wait(randomfloatrange(0.3, 0.75));
		}
		self setgoalvolume(volume);
		self waittill(#"goal");
		self ai::set_ignoreall(0);
		self ai::set_ignoreme(0);
	}
	if(isdefined(self.targetname) && self.targetname == "takedown_backup_left_ai_ai")
	{
		self setgoalpos(self.origin, 1);
		self ai::set_ignoreall(1);
		self ai::set_ignoreme(1);
		if(isdefined(self.script_noteworthy) && self.script_noteworthy == "takedown_backup_left_extra_2")
		{
			volume = getent("takedown_backup_middle_volume", "targetname");
			wait(randomfloatrange(0.3, 0.5));
		}
		else
		{
			volume = getent("takedown_backup_right_volume", "targetname");
			wait(randomfloatrange(0.3, 0.5));
		}
		self setgoalvolume(volume);
		self waittill(#"goal");
		self ai::set_ignoreall(0);
		self ai::set_ignoreme(0);
		if(level.var_e7c1ffa.size > 3)
		{
			volume = getent("takedown_backup_volume", "targetname");
			self setgoalvolume(volume);
		}
	}
	if(isdefined(self.targetname) && self.targetname == "takedown_backup_truck_ai_ai")
	{
		if(isdefined(self.script_noteworthy) && self.script_noteworthy == "gunner1")
		{
			self.var_df53bc6 = self.script_accuracy;
			self.script_accuracy = 0.2;
		}
		level flag::wait_till("takedown_backup_truck_stopped_flag");
		if(isdefined(self.script_noteworthy))
		{
			if(self.script_noteworthy == "gunner1")
			{
				self.var_df53bc6 = self.script_accuracy;
				self.script_accuracy = 0.2;
				wait(5);
				self.script_accuracy = self.var_df53bc6;
			}
			if(self.script_noteworthy == "driver" || self.script_noteworthy == "passenger1")
			{
				self vehicle::get_out();
			}
		}
		volume = getent("takedown_backup_right_volume", "targetname");
		if(isdefined(self.script_noteworthy) && self.script_noteworthy != "gunner1")
		{
			self ai::set_ignoreall(0);
			self ai::set_ignoreme(0);
			self setgoalvolume(volume);
		}
	}
}

/*
	Name: function_64be6dbe
	Namespace: vengeance_intro
	Checksum: 0x8175B606
	Offset: 0x82B0
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function function_64be6dbe()
{
	level.ai_hendricks waittill(#"hash_ca6b3f19");
	playfxontag(level._effect["fx_exp_emp_siegebot_veng"], level.takedown_siegebot, "tag_eye");
	wait(0.5);
	if(isalive(level.takedown_rbot1))
	{
		playfxontag(level._effect["fx_elec_enemy_juiced_shotgun"], level.takedown_rbot1, "tag_eye");
	}
	if(isalive(level.takedown_rbot2))
	{
		playfxontag(level._effect["fx_elec_enemy_juiced_shotgun"], level.takedown_rbot2, "tag_eye");
	}
	wait(0.5);
	if(isalive(level.takedown_rbot1))
	{
		playfxontag(level._effect["fx_elec_enemy_juiced_shotgun"], level.takedown_rbot1, "tag_eye");
	}
	if(isalive(level.takedown_rbot2))
	{
		playfxontag(level._effect["fx_elec_enemy_juiced_shotgun"], level.takedown_rbot2, "tag_eye");
	}
}

/*
	Name: function_a339da70
	Namespace: vengeance_intro
	Checksum: 0xD67DAB05
	Offset: 0x8458
	Size: 0x9C
	Parameters: 0
	Flags: None
*/
function function_a339da70()
{
	setslowmotion(1, 0.3, 0.3);
	level thread function_8b1bdf0e();
	level.ai_hendricks util::waittill_either("stop_slowmo", "takedown_enemies_dead");
	thread cp_mi_sing_vengeance_sound::function_69fc18eb();
	setslowmotion(0.3, 1);
}

/*
	Name: function_8b1bdf0e
	Namespace: vengeance_intro
	Checksum: 0x20F5B5A9
	Offset: 0x8500
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_8b1bdf0e()
{
	while(level.takedown_enemies.size > 0)
	{
		level.takedown_enemies = array::remove_dead(level.takedown_enemies);
		wait(0.05);
	}
	level.ai_hendricks notify(#"hash_d6da3c26");
}

/*
	Name: takedown_scene_setup
	Namespace: vengeance_intro
	Checksum: 0x6F91F986
	Offset: 0x8560
	Size: 0x5CC
	Parameters: 0
	Flags: Linked
*/
function takedown_scene_setup()
{
	level.var_3d63f698 = struct::get("tag_align_takedown", "targetname");
	level.takedown_truck_54i = spawner::simple_spawn_single("truck_54i");
	level.takedown_truck_54i.animname = "truck_54i";
	level.takedown_truck_54i disconnectpaths();
	level.takedown_truck_54i thread takedown_cleanup();
	level.takedown_truck_54i vehicle::lights_off();
	level.takedown_siegebot = spawner::simple_spawn_single("takedown_siegebot");
	level.takedown_siegebot.animname = "takedown_siegebot";
	level.takedown_siegebot ai::set_ignoreall(1);
	level.takedown_siegebot ai::set_ignoreme(1);
	level.takedown_siegebot disableaimassist();
	level.takedown_siegebot.nocybercom = 1;
	level.takedown_siegebot vehicle_ai::start_scripted(1);
	level.takedown_siegebot thread takedown_cleanup();
	level.takedown_siegebot thread function_9d478f6a();
	level.outer_door = getent("outer_door", "targetname");
	level.outer_door thread takedown_cleanup();
	level.sign = getent("sign", "targetname");
	level.sign.animname = "sign";
	level.sign thread takedown_cleanup();
	var_320a972b = getent("sign_clip", "targetname");
	var_320a972b linkto(level.sign);
	var_320a972b thread takedown_cleanup();
	level.var_338fd2fb = getent("p1wire", "targetname");
	level.var_338fd2fb.animname = "p1wire";
	level.var_338fd2fb thread takedown_cleanup();
	if(level.players.size == 4)
	{
		level.var_639480c0 = getent("takedown_p4door_l", "targetname");
		level.var_639480c0.animname = "p4door_l";
		level.var_639480c0 thread takedown_cleanup();
		level.var_d7ded90e = getent("takedown_p4door_r", "targetname");
		level.var_d7ded90e.animname = "p4door_r";
		level.var_d7ded90e thread takedown_cleanup();
	}
	level.trashcan = getent("takedown_trashcan", "targetname");
	level.trashcan thread takedown_cleanup();
	level.var_efe271b8 = getent("takedown_trashcan_clip", "targetname");
	level.var_efe271b8 linkto(level.trashcan);
	level.var_efe271b8 thread takedown_cleanup();
	level.takedown_enemies = [];
	level.var_d9f6d6 = [];
	level.takedown_ai_spawners = getentarray("takedown_ai", "script_noteworthy");
	foreach(spawner in level.takedown_ai_spawners)
	{
		spawner spawner::add_spawn_function(&takedown_ai_setup);
		spawner spawner::spawn();
	}
	level notify(#"takedown_scene_setup");
	if(isdefined(level.var_b7e68311))
	{
		level waittill(#"hash_63d9e6f4");
	}
	if(isdefined(level.var_48158b2b))
	{
	}
	else
	{
		level.var_3d63f698 thread scene::init("cin_ven_03_10_takedown_intro_1st");
		level.var_3d63f698 thread scene::init("cin_ven_03_10_takedown_intro_1st_props");
		level.var_3d63f698 scene::init("cin_ven_01_02_rooftop_1st_overlook");
	}
}

/*
	Name: function_9d478f6a
	Namespace: vengeance_intro
	Checksum: 0xFDCA913D
	Offset: 0x8B38
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_9d478f6a()
{
	self endon(#"death");
	thread cp_mi_sing_vengeance_sound::takedown_siegebot(self);
	self waittill(#"hash_77e3a76");
	var_26993771 = getent("takedown_siegebot_death_clip", "targetname");
	var_26993771 delete();
	self.allowdeath = 1;
	self kill();
}

/*
	Name: function_b584dbf0
	Namespace: vengeance_intro
	Checksum: 0xF1BEAD21
	Offset: 0x8BD8
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function function_b584dbf0(params)
{
}

/*
	Name: takedown_ai_setup
	Namespace: vengeance_intro
	Checksum: 0xB67D64A3
	Offset: 0x8BF0
	Size: 0x74C
	Parameters: 0
	Flags: Linked
*/
function takedown_ai_setup()
{
	self ai::set_ignoreall(1);
	self ai::set_ignoreme(1);
	self cybercom::cybercom_aioptout("cybercom_fireflyswarm");
	if(isdefined(self.targetname))
	{
		if(self.targetname == "enemy_leader_ai")
		{
			level.var_56f5377 = self;
			array::add(level.takedown_enemies, self);
			array::add(level.var_d9f6d6, self);
		}
		if(self.targetname == "takedown_enemy1_ai")
		{
			level.takedown_enemy1 = self;
			array::add(level.takedown_enemies, self);
		}
		if(self.targetname == "takedown_enemy2_ai")
		{
			level.takedown_enemy2 = self;
			array::add(level.takedown_enemies, self);
			level.en2_machete = util::spawn_model("p7_54i_gear_knife");
			level.en2_machete.animname = "en2_machete";
			level.en2_machete thread takedown_cleanup();
		}
		if(self.targetname == "takedown_enemy3_ai")
		{
			level.takedown_enemy3 = self;
			array::add(level.takedown_enemies, self);
			level.var_38cff819 = util::spawn_model("wpn_t7_knife_combat_world");
			level.var_38cff819.animname = "p3knife";
			level.var_38cff819 thread takedown_cleanup();
		}
		if(self.targetname == "takedown_enemy4_ai")
		{
			level.takedown_enemy4 = self;
			array::add(level.takedown_enemies, self);
			level.var_a2e245f8 = util::spawn_model("wpn_t7_knife_combat_world");
			level.var_a2e245f8.animname = "p4knife";
			level.var_a2e245f8 thread takedown_cleanup();
		}
		if(self.targetname == "takedown_enemy5_ai")
		{
			level.takedown_enemy5 = self;
			array::add(level.takedown_enemies, self);
			array::add(level.var_d9f6d6, self);
			level.trashcan.animname = "trashcan";
		}
		if(self.targetname == "takedown_enemy6_ai")
		{
			level.takedown_enemy6 = self;
			array::add(level.takedown_enemies, self);
			array::add(level.var_d9f6d6, self);
		}
		if(self.targetname == "takedown_enemy7_ai")
		{
			level.takedown_enemy7 = self;
			array::add(level.takedown_enemies, self);
			array::add(level.var_d9f6d6, self);
		}
		if(self.targetname == "takedown_enemy8_ai")
		{
			level.takedown_enemy8 = self;
			array::add(level.takedown_enemies, self);
			array::add(level.var_d9f6d6, self);
		}
		if(self.targetname == "takedown_enemy9_ai")
		{
			level.takedown_enemy9 = self;
			array::add(level.takedown_enemies, self);
			array::add(level.var_d9f6d6, self);
		}
		if(self.targetname == "takedown_enemy10_ai")
		{
			level.takedown_enemy10 = self;
			array::add(level.takedown_enemies, self);
			array::add(level.var_d9f6d6, self);
		}
		if(self.targetname == "takedown_enemy11_ai")
		{
			level.takedown_enemy11 = self;
			array::add(level.takedown_enemies, self);
			array::add(level.var_d9f6d6, self);
		}
		if(self.targetname == "takedown_enemy12_ai")
		{
			level.takedown_enemy12 = self;
			array::add(level.takedown_enemies, self);
			array::add(level.var_d9f6d6, self);
		}
		if(self.targetname == "takedown_enemy13_ai")
		{
			level.takedown_enemy13 = self;
			array::add(level.takedown_enemies, self);
		}
		if(self.targetname == "takedown_enemy14_ai")
		{
			level.var_7a94367a = self;
			array::add(level.takedown_enemies, self);
			array::add(level.var_d9f6d6, self);
		}
		if(self.targetname == "takedown_enemy15_ai")
		{
			level.var_a096b0e3 = self;
			array::add(level.takedown_enemies, self);
			array::add(level.var_d9f6d6, self);
		}
		if(self.targetname == "takedown_enemy16_ai")
		{
			level.var_2e8f41a8 = self;
			array::add(level.takedown_enemies, self);
			array::add(level.var_d9f6d6, self);
			level.var_639480c0.animname = "p4door_l";
			level.var_d7ded90e.animname = "p4door_r";
		}
		if(self.targetname == "takedown_rbot1_ai")
		{
			level.takedown_rbot1 = self;
			array::add(level.takedown_enemies, self);
			array::add(level.var_d9f6d6, self);
			self.nocybercom = 1;
			self cybercom::cybercom_aioptout("cybercom_ravagecore");
		}
		if(self.targetname == "takedown_rbot2_ai")
		{
			level.takedown_rbot2 = self;
			array::add(level.takedown_enemies, self);
			self.nocybercom = 1;
			self cybercom::cybercom_aioptout("cybercom_ravagecore");
		}
	}
}

/*
	Name: takedown_cleanup
	Namespace: vengeance_intro
	Checksum: 0x55A00065
	Offset: 0x9348
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function takedown_cleanup()
{
	level flag::wait_till("start_dogleg_1_intro");
	wait(1);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: skipto_takedown_done
	Namespace: vengeance_intro
	Checksum: 0xDA6F81DE
	Offset: 0x9398
	Size: 0x1B4
	Parameters: 4
	Flags: Linked
*/
function skipto_takedown_done(str_objective, b_starting, b_direct, player)
{
	level struct::delete_script_bundle("scene", "cin_ven_hanging_body_loop_vign_civ02");
	level struct::delete_script_bundle("scene", "cin_ven_hanging_body_loop_vign_civ05");
	level struct::delete_script_bundle("scene", "cin_ven_hanging_body_loop_vign_civ07");
	level struct::delete_script_bundle("scene", "cin_ven_hanging_body_loop_vign_civ09");
	level struct::delete_script_bundle("scene", "cin_ven_01_20_introstreet_bodies_vign");
	level struct::delete_script_bundle("scene", "cin_ven_01_25_outside_apt_bodies_vign");
	level struct::delete_script_bundle("scene", "cin_ven_02_05_inside_apt_bodies_vign");
	level struct::delete_script_bundle("scene", "cin_ven_02_10_apthorror_enterbldg_vign");
	level struct::delete_script_bundle("scene", "cin_ven_02_10_apthorror_firstfloorapt_vign");
	level struct::delete_script_bundle("scene", "cin_ven_02_10_apthorror_secondfloorapt_vign");
}

/*
	Name: function_81f84c9c
	Namespace: vengeance_intro
	Checksum: 0x579BB98E
	Offset: 0x9558
	Size: 0x182
	Parameters: 2
	Flags: None
*/
function function_81f84c9c(str_objective, b_starting)
{
	/#
		level.var_b7e68311 = 1;
		vengeance_util::skipto_baseline(str_objective, b_starting);
		vengeance_util::init_hero("", str_objective);
		level.ai_hendricks ai::set_ignoreall(1);
		level.ai_hendricks ai::set_ignoreme(1);
		level.ai_hendricks.goalradius = 32;
		level.ai_hendricks battlechatter::function_d9f49fba(0);
		level flag::wait_till("");
		objectives::set("", struct::get(""));
		level flag::set("");
		level thread takedown_main();
		level waittill(#"takedown_scene_setup");
		level function_6fa5f384();
		level notify(#"hash_63d9e6f4");
	#/
}

/*
	Name: function_616e9ab6
	Namespace: vengeance_intro
	Checksum: 0x4304DF1F
	Offset: 0x96E8
	Size: 0x1EA
	Parameters: 2
	Flags: Linked
*/
function function_616e9ab6(str_objective, b_starting)
{
	/#
		level.var_b7e68311 = 1;
		vengeance_util::skipto_baseline(str_objective, b_starting);
		vengeance_util::init_hero("", str_objective);
		level.ai_hendricks ai::set_ignoreall(1);
		level.ai_hendricks ai::set_ignoreme(1);
		level.ai_hendricks.goalradius = 32;
		level.ai_hendricks battlechatter::function_d9f49fba(0);
		level flag::wait_till("");
		objectives::set("", struct::get(""));
		level flag::set("");
		setdvar("", "");
		wait(1);
		if(level.activeplayers.size == 1)
		{
			setdvar("", "");
		}
		wait(1);
		level thread takedown_main();
		level waittill(#"takedown_scene_setup");
		if(level.activeplayers.size == 2)
		{
			level function_6fa5f384();
		}
		level notify(#"hash_63d9e6f4");
	#/
}

/*
	Name: function_8771151f
	Namespace: vengeance_intro
	Checksum: 0xFCCA8C4
	Offset: 0x98E0
	Size: 0x1F2
	Parameters: 2
	Flags: Linked
*/
function function_8771151f(str_objective, b_starting)
{
	/#
		level.var_b7e68311 = 1;
		vengeance_util::skipto_baseline(str_objective, b_starting);
		vengeance_util::init_hero("", str_objective);
		level.ai_hendricks ai::set_ignoreall(1);
		level.ai_hendricks ai::set_ignoreme(1);
		level.ai_hendricks.goalradius = 32;
		level.ai_hendricks battlechatter::function_d9f49fba(0);
		level flag::wait_till("");
		objectives::set("", struct::get(""));
		level flag::set("");
		setdvar("", "");
		wait(1);
		while(level.activeplayers.size != 3)
		{
			setdvar("", "");
			wait(1);
		}
		level thread takedown_main();
		level waittill(#"takedown_scene_setup");
		if(level.activeplayers.size == 3)
		{
			level function_6fa5f384();
		}
		level notify(#"hash_63d9e6f4");
	#/
}

/*
	Name: function_7d5fbc40
	Namespace: vengeance_intro
	Checksum: 0x6D86FA83
	Offset: 0x9AE0
	Size: 0x1F2
	Parameters: 2
	Flags: Linked
*/
function function_7d5fbc40(str_objective, b_starting)
{
	/#
		level.var_b7e68311 = 1;
		vengeance_util::skipto_baseline(str_objective, b_starting);
		vengeance_util::init_hero("", str_objective);
		level.ai_hendricks ai::set_ignoreall(1);
		level.ai_hendricks ai::set_ignoreme(1);
		level.ai_hendricks.goalradius = 32;
		level.ai_hendricks battlechatter::function_d9f49fba(0);
		level flag::wait_till("");
		objectives::set("", struct::get(""));
		level flag::set("");
		setdvar("", "");
		wait(1);
		while(level.activeplayers.size != 4)
		{
			setdvar("", "");
			wait(1);
		}
		level thread takedown_main();
		level waittill(#"takedown_scene_setup");
		if(level.activeplayers.size == 4)
		{
			level function_6fa5f384();
		}
		level notify(#"hash_63d9e6f4");
	#/
}

/*
	Name: function_6fa5f384
	Namespace: vengeance_intro
	Checksum: 0xCE4E2CAA
	Offset: 0x9CE0
	Size: 0x1356
	Parameters: 0
	Flags: Linked
*/
function function_6fa5f384()
{
	/#
		level.var_48158b2b = [];
		level.var_7cd6979b = [];
		level.var_7cd6979b = arraycombine(level.var_7cd6979b, level.activeplayers, 0, 0);
		foreach(player in level.var_7cd6979b)
		{
			if(isdefined(player.pers) && isdefined(player.pers[""]) && player.pers[""] == 1)
			{
				level.var_48158b2b[0] = player;
				arrayremovevalue(level.var_7cd6979b, player);
				break;
			}
		}
		level.var_48158b2b[1] = level.ai_hendricks;
		level.var_d60e1bf0 = [];
		level.var_d60e1bf0[0] = level.takedown_siegebot;
		level.var_d60e1bf0[1] = level.takedown_truck_54i;
		level.var_d60e1bf0[2] = level.takedown_rbot1;
		level.var_d60e1bf0[3] = level.takedown_rbot2;
		level.var_d60e1bf0[4] = level.var_338fd2fb;
		level.var_d60e1bf0[5] = level.takedown_enemy1;
		level.var_d60e1bf0[6] = level.var_56f5377;
		level.var_d60e1bf0[7] = level.takedown_enemy8;
		level.var_d60e1bf0[8] = level.takedown_enemy10;
		if(level.activeplayers.size >= 2)
		{
			if(getdvarstring("") === "")
			{
				foreach(player in level.var_7cd6979b)
				{
					if(!isdefined(player.pers) || (isdefined(player.pers) && player.pers[""] == undefined))
					{
						level.var_d60e1bf0[9] = player;
						arrayremovevalue(level.var_7cd6979b, player);
						break;
					}
				}
			}
			else
			{
				foreach(player in level.var_7cd6979b)
				{
					if(isdefined(player.pers) && isdefined(player.pers[""]) && player.pers[""] == 1)
					{
						level.var_d60e1bf0[9] = player;
						arrayremovevalue(level.var_7cd6979b, player);
						break;
					}
				}
			}
			level.var_d60e1bf0[10] = level.takedown_enemy2;
			level.var_d60e1bf0[11] = level.en2_machete;
			level.var_d60e1bf0[12] = level.takedown_enemy13;
			level.var_d60e1bf0[13] = level.takedown_enemy7;
			level.var_d60e1bf0[14] = level.takedown_enemy11;
			level.var_d60e1bf0[15] = level.takedown_enemy12;
		}
		if(level.activeplayers.size >= 3)
		{
			if(getdvarstring("") === "")
			{
				foreach(player in level.var_7cd6979b)
				{
					if(!isdefined(player.pers) || (isdefined(player.pers) && player.pers[""] == undefined))
					{
						level.var_d60e1bf0[16] = player;
						arrayremovevalue(level.var_7cd6979b, player);
						break;
					}
				}
			}
			else
			{
				foreach(player in level.var_7cd6979b)
				{
					if(isdefined(player.pers) && isdefined(player.pers[""]) && player.pers[""] == 1)
					{
						level.var_d60e1bf0[16] = player;
						arrayremovevalue(level.var_7cd6979b, player);
						break;
					}
				}
			}
			level.var_d60e1bf0[17] = level.var_38cff819;
			level.var_d60e1bf0[18] = level.takedown_enemy3;
			level.var_d60e1bf0[19] = level.takedown_enemy5;
			level.var_d60e1bf0[20] = level.takedown_enemy6;
			level.var_d60e1bf0[21] = level.var_7a94367a;
		}
		if(level.activeplayers.size == 4)
		{
			if(getdvarstring("") === "")
			{
				foreach(player in level.var_7cd6979b)
				{
					if(!isdefined(player.pers) || (isdefined(player.pers) && player.pers[""] == undefined))
					{
						level.var_d60e1bf0[22] = player;
						arrayremovevalue(level.var_7cd6979b, player);
						break;
					}
				}
			}
			else
			{
				foreach(player in level.var_7cd6979b)
				{
					if(isdefined(player.pers) && isdefined(player.pers[""]) && player.pers[""] == 1)
					{
						level.var_d60e1bf0[22] = player;
						arrayremovevalue(level.var_7cd6979b, player);
						break;
					}
				}
			}
			level.var_d60e1bf0[23] = level.var_a2e245f8;
			level.var_d60e1bf0[24] = level.takedown_enemy4;
			level.var_d60e1bf0[25] = level.takedown_enemy9;
			level.var_d60e1bf0[26] = level.var_a096b0e3;
			level.var_d60e1bf0[27] = level.var_2e8f41a8;
		}
		level.var_fc109659 = [];
		level.var_fc109659[0] = level.takedown_siegebot;
		level.var_fc109659[1] = level.takedown_truck_54i;
		level.var_fc109659[2] = level.takedown_rbot1;
		level.var_fc109659[3] = level.takedown_rbot2;
		level.var_7cd6979b = [];
		level.var_7cd6979b = arraycombine(level.var_7cd6979b, level.activeplayers, 0, 0);
		foreach(player in level.var_7cd6979b)
		{
			if(isdefined(player.pers) && isdefined(player.pers[""]) && player.pers[""] == 1)
			{
				level.var_fc109659[4] = player;
				arrayremovevalue(level.var_7cd6979b, player);
				break;
			}
		}
		level.var_fc109659[5] = level.var_338fd2fb;
		level.var_fc109659[6] = level.takedown_enemy1;
		level.var_fc109659[7] = level.var_56f5377;
		level.var_fc109659[8] = level.takedown_enemy8;
		level.var_fc109659[9] = level.takedown_enemy10;
		if(level.activeplayers.size >= 2)
		{
			if(getdvarstring("") === "")
			{
				foreach(player in level.var_7cd6979b)
				{
					if(!isdefined(player.pers) || (isdefined(player.pers) && player.pers[""] == undefined))
					{
						level.var_fc109659[10] = player;
						arrayremovevalue(level.var_7cd6979b, player);
						break;
					}
				}
			}
			else
			{
				foreach(player in level.var_7cd6979b)
				{
					if(isdefined(player.pers) && isdefined(player.pers[""]) && player.pers[""] == 1)
					{
						level.var_fc109659[10] = player;
						arrayremovevalue(level.var_7cd6979b, player);
						break;
					}
				}
			}
			level.var_fc109659[11] = level.takedown_enemy2;
			level.var_fc109659[12] = level.en2_machete;
			level.var_fc109659[13] = level.takedown_enemy13;
			level.var_fc109659[14] = level.takedown_enemy7;
			level.var_fc109659[15] = level.takedown_enemy11;
			level.var_fc109659[16] = level.takedown_enemy12;
		}
		if(level.activeplayers.size >= 3)
		{
			if(getdvarstring("") === "")
			{
				foreach(player in level.var_7cd6979b)
				{
					if(!isdefined(player.pers) || (isdefined(player.pers) && player.pers[""] == undefined))
					{
						level.var_fc109659[17] = player;
						arrayremovevalue(level.var_7cd6979b, player);
						break;
					}
				}
			}
			else
			{
				foreach(player in level.var_7cd6979b)
				{
					if(isdefined(player.pers) && isdefined(player.pers[""]) && player.pers[""] == 1)
					{
						level.var_fc109659[17] = player;
						arrayremovevalue(level.var_7cd6979b, player);
						break;
					}
				}
			}
			level.var_fc109659[18] = level.var_38cff819;
			level.var_fc109659[19] = level.takedown_enemy3;
			level.var_fc109659[20] = level.takedown_enemy5;
			level.var_fc109659[21] = level.takedown_enemy6;
			level.var_fc109659[22] = level.var_7a94367a;
		}
		if(level.activeplayers.size == 4)
		{
			if(getdvarstring("") === "")
			{
				foreach(player in level.var_7cd6979b)
				{
					if(!isdefined(player.pers) || (isdefined(player.pers) && player.pers[""] == undefined))
					{
						level.var_fc109659[23] = player;
						arrayremovevalue(level.var_7cd6979b, player);
						break;
					}
				}
			}
			else
			{
				foreach(player in level.var_7cd6979b)
				{
					if(isdefined(player.pers) && isdefined(player.pers[""]) && player.pers[""] == 1)
					{
						level.var_fc109659[23] = player;
						arrayremovevalue(level.var_7cd6979b, player);
						break;
					}
				}
			}
			level.var_fc109659[24] = level.takedown_enemy2;
			level.var_fc109659[25] = level.takedown_enemy4;
			level.var_fc109659[26] = level.takedown_enemy9;
			level.var_fc109659[27] = level.var_a096b0e3;
			level.var_fc109659[28] = level.var_2e8f41a8;
		}
	#/
}

