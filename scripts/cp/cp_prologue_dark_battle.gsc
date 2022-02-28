// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_eth_prologue_accolades;
#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;
#using scripts\cp\cp_prologue_apc;
#using scripts\cp\cp_prologue_cyber_soldiers;
#using scripts\cp\cp_prologue_hangars;
#using scripts\cp\cp_prologue_util;
#using scripts\cp\cybercom\_cybercom_gadget_firefly;
#using scripts\cp\cybercom\_cybercom_gadget_sensory_overload;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;

#namespace dark_battle;

/*
	Name: dark_battle_start
	Namespace: dark_battle
	Checksum: 0xEC557AA9
	Offset: 0xF30
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function dark_battle_start()
{
	dark_battle_precache();
	dark_battle_heros_init();
	level thread namespace_21b2c1f2::function_3c37ec50();
	level thread dark_battle_main();
}

/*
	Name: dark_battle_precache
	Namespace: dark_battle
	Checksum: 0xCEEF6BDE
	Offset: 0xF90
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function dark_battle_precache()
{
	level flag::init("flag_player_fired_early");
}

/*
	Name: dark_battle_heros_init
	Namespace: dark_battle
	Checksum: 0xEA2675E9
	Offset: 0xFC0
	Size: 0x26C
	Parameters: 0
	Flags: Linked
*/
function dark_battle_heros_init()
{
	battlechatter::function_d9f49fba(0);
	level.ai_khalil ai::set_ignoreall(1);
	level.ai_khalil ai::set_ignoreme(1);
	level.ai_khalil.goalradius = 32;
	level.ai_hyperion ai::set_ignoreall(1);
	level.ai_hyperion ai::set_ignoreme(1);
	level.ai_hyperion.goalradius = 32;
	level.ai_hyperion.allowpain = 0;
	level.ai_hyperion colors::set_force_color("p");
	level.ai_hyperion ai::set_behavior_attribute("cqb", 1);
	level.ai_hyperion ai::set_behavior_attribute("sprint", 0);
	level.ai_minister ai::set_ignoreall(1);
	level.ai_minister ai::set_ignoreme(1);
	level.ai_minister.goalradius = 32;
	level.ai_hendricks ai::set_ignoreall(1);
	level.ai_hendricks ai::set_ignoreme(1);
	level.ai_hendricks.goalradius = 16;
	level.ai_hendricks.allowpain = 0;
	level.ai_hendricks ai::set_behavior_attribute("cqb", 1);
	level.ai_hendricks ai::set_behavior_attribute("sprint", 0);
	if(isalive(level.ai_pallas))
	{
		level.ai_pallas delete();
	}
}

/*
	Name: dark_battle_main
	Namespace: dark_battle
	Checksum: 0xCAF36E10
	Offset: 0x1238
	Size: 0x5EC
	Parameters: 0
	Flags: Linked
*/
function dark_battle_main()
{
	objectives::set("cp_level_prologue_escort_data_center");
	array::thread_all(level.players, &function_2909799b);
	array::thread_all(level.players, &function_b7634680);
	callback::on_ai_killed(&function_e2b1615a);
	level thread vtol_guards_handler();
	array::thread_all(level.players, &clientfield::set_to_player, "turn_off_tacmode_vfx", 1);
	level scene::init("p7_fxanim_cp_prologue_vtol_tackle_windows_bundle");
	level thread objectives::breadcrumb("dark_battle_breadcrumb_3");
	level thread dark_battle_behavior_handler();
	level thread function_4d2734fa();
	level thread function_c2326e34();
	level thread dark_room_confusion_dialog();
	level thread function_edbf19b4();
	level thread function_312ac345();
	level.ai_hyperion thread function_43d5fd7a();
	level.ai_khalil ai::set_behavior_attribute("coverIdleOnly", 1);
	level.ai_minister ai::set_behavior_attribute("coverIdleOnly", 1);
	if(isdefined(level.bzm_prologuedialogue5_2callback))
	{
		level thread [[level.bzm_prologuedialogue5_2callback]]();
	}
	function_f7eee26d();
	while(!spawn_manager::is_cleared("sm_darkroom_spawner"))
	{
		wait(0.5);
	}
	level thread namespace_21b2c1f2::function_973b77f9();
	level notify(#"hash_a9e3188");
	level notify(#"hash_bd74d007");
	level util::clientnotify("sndDBW");
	level thread function_4e24163f();
	level thread function_7bd8c5a3();
	battlechatter::function_d9f49fba(0);
	level scene::init("cin_pro_13_01_vtoltackle_vign_takedown");
	wait(0.05);
	level.ai_hyperion setgoal(getnode("hyperion_dark_battle_final", "targetname"), 1);
	level.ai_hendricks setgoal(getnode("hendricks_dark_battle_final", "targetname"), 1);
	level.ai_hendricks waittill(#"goal");
	level thread objectives::breadcrumb("dark_battle_breadcrumb_4");
	callback::remove_on_ai_killed(&function_e2b1615a);
	foreach(player in level.players)
	{
		if(isalive(player))
		{
			player thread function_63222c73();
			player thread function_4933d21a();
		}
	}
	playsoundatposition("evt_doorhack_dooropen", (13437, 2216, 252));
	function_62e89023(1, 0);
	level thread function_b3666179();
	level.ai_hyperion clearforcedgoal();
	level.ai_khalil ai::set_behavior_attribute("coverIdleOnly", 0);
	level.ai_minister ai::set_behavior_attribute("coverIdleOnly", 0);
	level.ai_hendricks ai::set_behavior_attribute("cqb", 0);
	level.ai_hyperion ai::set_behavior_attribute("cqb", 0);
	objectives::complete("cp_level_prologue_escort_data_center");
	objectives::set("cp_level_prologue_find_vehicle");
	skipto::objective_completed("skipto_dark_battle");
}

/*
	Name: function_7cd37960
	Namespace: dark_battle
	Checksum: 0x1AF7C2DB
	Offset: 0x1830
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function function_7cd37960()
{
	level endon(#"hash_7a9811b7");
	self waittill(#"weapon_fired");
	level notify(#"hash_9babf62");
}

/*
	Name: function_997d6fdc
	Namespace: dark_battle
	Checksum: 0xCE981172
	Offset: 0x1868
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function function_997d6fdc()
{
	level endon(#"hash_7a9811b7");
	self waittill(#"grenade_fire", grenade, weapon);
	level notify(#"hash_9babf62");
}

/*
	Name: function_f7eee26d
	Namespace: dark_battle
	Checksum: 0x415ADD12
	Offset: 0x18B8
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function function_f7eee26d()
{
	level endon(#"hash_b1b6677a");
	level endon(#"hash_9babf62");
	array::thread_all(level.players, &function_7cd37960);
	array::thread_all(level.players, &function_997d6fdc);
	trigger::wait_till("t_dark_battle_glass");
	level notify(#"hash_9babf62");
}

/*
	Name: function_e6296f02
	Namespace: dark_battle
	Checksum: 0x9F7FEA9E
	Offset: 0x1958
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_e6296f02(a_ents)
{
	array::thread_all(a_ents, &function_dabc0173);
}

/*
	Name: function_dabc0173
	Namespace: dark_battle
	Checksum: 0x69B58F1D
	Offset: 0x1990
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_dabc0173()
{
	self endon(#"death");
	self ai::set_ignoreall(1);
	self ai::set_ignoreme(1);
	self.firing_at_something = 0;
	level flag::wait_till("flag_player_fired_early");
	self stopanimscripted();
	self ai::set_ignoreme(0);
	self thread dark_battle_spawner_init();
}

/*
	Name: function_4d2734fa
	Namespace: dark_battle
	Checksum: 0xE8F4D990
	Offset: 0x1A48
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_4d2734fa()
{
	spawner::add_spawn_function_group("darkroom_spawner", "targetname", &dark_battle_spawner_init);
	function_62e89023();
	spawn_manager::enable("sm_darkroom_spawner");
	spawn_manager::wait_till_complete("sm_darkroom_spawner");
	var_5ca9a217 = getent("outside_dark_battle_room", "targetname");
	b_clear = 0;
	while(!b_clear)
	{
		b_clear = 1;
		a_ai = spawner::get_ai_group_ai("aig_darkroom");
		foreach(ai in a_ai)
		{
			if(ai istouching(var_5ca9a217))
			{
				b_clear = 0;
				break;
			}
		}
		wait(0.5);
	}
	function_62e89023(0, 0);
}

/*
	Name: function_4e24163f
	Namespace: dark_battle
	Checksum: 0x653651A7
	Offset: 0x1BF8
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_4e24163f()
{
	door_l = getent("intelstation_bottom_door_l", "targetname");
	door_r = getent("intelstation_bottom_door_r", "targetname");
	v_move = vectorscale((1, 0, 0), 54);
	move_time = 0.5;
	v_door_destination = door_l.origin + v_move;
	door_l moveto(v_door_destination, move_time);
	v_door_destination = door_r.origin - v_move;
	door_r moveto(v_door_destination, move_time);
	door_l waittill(#"movedone");
	level.ai_khalil setgoal(getnode("khalil_dark_battle_final", "targetname"), 1);
	wait(1);
	level.ai_minister setgoal(getnode("minister_dark_battle_final", "targetname"), 1);
}

/*
	Name: function_b3666179
	Namespace: dark_battle
	Checksum: 0x39A33272
	Offset: 0x1DA8
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_b3666179()
{
	t_door = getent("t_vtol_tackle_doors", "targetname");
	a_friendly_ai = array(level.ai_minister, level.ai_hendricks, level.ai_khalil, level.ai_hyperion);
	level thread cp_prologue_util::function_21f52196("vtol_tackle_doors", t_door);
	level thread cp_prologue_util::function_2e61b3e8("vtol_tackle_doors", t_door, a_friendly_ai);
	while(!cp_prologue_util::function_cdd726fb("vtol_tackle_doors"))
	{
		wait(0.05);
	}
	function_62e89023(0, 0);
}

/*
	Name: function_62e89023
	Namespace: dark_battle
	Checksum: 0xE7EC0AE5
	Offset: 0x1EB0
	Size: 0x23A
	Parameters: 2
	Flags: Linked
*/
function function_62e89023(b_open = 1, var_abf03d83 = 1)
{
	var_280d5f68 = getent("dark_battle_door_l", "targetname");
	var_3c301126 = getent("dark_battle_door_r", "targetname");
	n_open_time = 1;
	if(!b_open)
	{
		n_open_time = 0.4;
	}
	if(var_abf03d83)
	{
		n_open_time = 0.05;
	}
	v_side = anglestoright(var_280d5f68.angles);
	if(b_open)
	{
		v_pos_left = var_280d5f68.origin + (v_side * (52 * -1));
		var_280d5f68 moveto(v_pos_left, n_open_time);
		v_pos_right = var_3c301126.origin + (v_side * 52);
		var_3c301126 moveto(v_pos_right, n_open_time);
	}
	else
	{
		v_pos_left = var_280d5f68.origin + (v_side * 52);
		var_280d5f68 moveto(v_pos_left, n_open_time);
		v_pos_right = var_3c301126.origin + (v_side * (52 * -1));
		var_3c301126 moveto(v_pos_right, n_open_time);
	}
	var_3c301126 waittill(#"movedone");
}

/*
	Name: function_43d5fd7a
	Namespace: dark_battle
	Checksum: 0x24F6F07F
	Offset: 0x20F8
	Size: 0x27C
	Parameters: 0
	Flags: Linked
*/
function function_43d5fd7a()
{
	level scene::add_scene_func("cin_pro_12_01_darkbattle_vign_dive_kill_enemyloop", &function_e6296f02);
	level thread dialog::remote("hall_heads_up_we_have_m_0", undefined, "normal");
	level thread scene::play("cin_pro_12_01_darkbattle_vign_dive_kill_enemyloop");
	level thread function_356b8cd9();
	level.ai_hyperion colors::disable();
	level.ai_hendricks colors::disable();
	level.ai_hendricks setgoal(getnode("hendricks_dark_battle_start", "targetname"), 1);
	level.ai_hyperion setgoal(getnode("diaz_dark_battle_start", "targetname"), 1);
	util::waittill_multiple_ents(level.ai_hyperion, "goal", level.ai_hendricks, "goal");
	wait(1);
	level flag::wait_till_any(array("dark_battle_player_upstairs", "flag_player_fired_early"));
	level scene::play("cin_pro_12_01_darkbattle_vign_dive_kill_start");
	level.ai_hyperion thread function_619c28d();
	level notify(#"hash_307c99bd");
	if(!level flag::get("flag_player_fired_early"))
	{
		level notify(#"hash_b1b6677a");
		level scene::play("cin_pro_12_01_darkbattle_vign_dive_kill_attack");
	}
	level.ai_hyperion ai::set_ignoreall(0);
	level.ai_hendricks battlechatter::function_d9f49fba(1);
	level thread hyperion_movement();
}

/*
	Name: function_619c28d
	Namespace: dark_battle
	Checksum: 0x7B43FE6F
	Offset: 0x2380
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_619c28d()
{
	level endon(#"hash_a9e3188");
	self dialog::say("mare_remember_they_ain_0");
	wait(5);
	self dialog::say("mare_take_it_slow_pick_0");
	wait(10);
	self dialog::say("mare_use_your_advantage_0");
}

/*
	Name: function_356b8cd9
	Namespace: dark_battle
	Checksum: 0xD9486519
	Offset: 0x23F8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_356b8cd9()
{
	level endon(#"hash_b1b6677a");
	level flag::wait_till("flag_player_fired_early");
	level scene::stop("cin_pro_12_01_darkbattle_vign_dive_kill_enemyloop");
}

/*
	Name: hyperion_movement
	Namespace: dark_battle
	Checksum: 0x81CE57F6
	Offset: 0x2450
	Size: 0x1A6
	Parameters: 0
	Flags: Linked
*/
function hyperion_movement()
{
	self endon(#"hash_a9e3188");
	var_72069915 = getnode("hyperion_dark_battle_1", "targetname");
	level.ai_hyperion setgoal(var_72069915, 1);
	level.ai_hyperion waittill(#"goal");
	wait(5);
	var_9809137e = getnode("hyperion_dark_battle_2", "targetname");
	level.ai_hyperion setgoal(var_9809137e, 1);
	level.ai_hyperion waittill(#"goal");
	wait(5);
	var_be0b8de7 = getnode("hyperion_dark_battle_3", "targetname");
	level.ai_hyperion setgoal(var_be0b8de7, 1);
	level.ai_hyperion waittill(#"goal");
	wait(5);
	var_b3fa3508 = getnode("hyperion_dark_battle_4", "targetname");
	level.ai_hyperion setgoal(var_b3fa3508, 1);
	level.ai_hyperion waittill(#"goal");
}

/*
	Name: function_312ac345
	Namespace: dark_battle
	Checksum: 0x8EE44502
	Offset: 0x2600
	Size: 0x186
	Parameters: 0
	Flags: Linked
*/
function function_312ac345()
{
	self endon(#"hash_a9e3188");
	level waittill(#"hash_307c99bd");
	level.ai_hendricks battlechatter::function_d9f49fba(1);
	level.ai_hendricks ai::set_ignoreall(0);
	var_900c9df2 = getnode("hendricks_dark_battle_1", "targetname");
	level.ai_hendricks setgoal(var_900c9df2, 1);
	level.ai_hendricks waittill(#"goal");
	wait(6);
	var_6a0a2389 = getnode("hendricks_dark_battle_2", "targetname");
	level.ai_hendricks setgoal(var_6a0a2389, 1);
	level.ai_hendricks waittill(#"goal");
	wait(6);
	var_4407a920 = getnode("hendricks_dark_battle_3", "targetname");
	level.ai_hendricks setgoal(var_4407a920, 1);
	level.ai_hendricks waittill(#"goal");
}

/*
	Name: function_c2326e34
	Namespace: dark_battle
	Checksum: 0x3416D9E7
	Offset: 0x2790
	Size: 0x2B4
	Parameters: 0
	Flags: Linked
*/
function function_c2326e34()
{
	level endon(#"hash_c63a5f38");
	var_94ace873 = getentarray("dark_wall_logo_off", "targetname");
	var_cd29e581 = getentarray("dark_wall_logo_on", "targetname");
	foreach(e_sign in var_94ace873)
	{
		e_sign ghost();
	}
	level waittill(#"hash_400d768d");
	exploder::stop_exploder("light_exploder_darkbattle");
	level util::clientnotify("sndDBB");
	foreach(e_sign in var_cd29e581)
	{
		e_sign ghost();
	}
	foreach(e_sign in var_94ace873)
	{
		e_sign show();
	}
	level waittill(#"hash_113f3cd3");
	array::thread_all(level.activeplayers, &oed::set_player_ev, 1);
	level flag::set("ev_enabled");
	wait(1);
	level notify(#"lights_out");
	level thread namespace_21b2c1f2::function_a0f24f9b();
}

/*
	Name: function_edbf19b4
	Namespace: dark_battle
	Checksum: 0xF450F73F
	Offset: 0x2A50
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function function_edbf19b4()
{
	level waittill(#"hash_7a9811b7");
	var_280d5f68 = getent("intelstation_balcony_door_l", "targetname");
	var_3c301126 = getent("intelstation_balcony_door_r", "targetname");
	playsoundatposition("evt_doorhack_dooropen", var_3c301126.origin);
	v_move = vectorscale((1, 0, 0), 54);
	n_move_time = 0.5;
	v_door_destination = var_280d5f68.origin + v_move;
	var_280d5f68 moveto(v_door_destination, n_move_time);
	v_door_destination = var_3c301126.origin - v_move;
	var_3c301126 moveto(v_door_destination, n_move_time);
	var_3c301126 waittill(#"movedone");
	var_3c301126 connectpaths();
	var_280d5f68 connectpaths();
}

/*
	Name: function_7bd8c5a3
	Namespace: dark_battle
	Checksum: 0xA1DFED8
	Offset: 0x2BD8
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_7bd8c5a3()
{
	level.ai_hyperion dialog::say("mare_clear_0", 1);
	level.ai_hyperion thread dialog::say("mare_disabling_tactical_f_0", 0.5);
	wait(1);
	array::thread_all(level.players, &oed::set_player_ev, 0);
	level flag::clear("ev_enabled");
	wait(1);
	exploder::exploder("light_exploder_darkbattle");
	level util::clientnotify("sndDBBe");
	level thread namespace_21b2c1f2::function_2a66b344();
}

/*
	Name: dark_room_confusion_dialog
	Namespace: dark_battle
	Checksum: 0xC97FA59C
	Offset: 0x2CE0
	Size: 0x278
	Parameters: 0
	Flags: Linked
*/
function dark_room_confusion_dialog()
{
	level waittill(#"hash_400d768d");
	wait(0.5);
	while(spawner::get_ai_group_count("aig_darkroom") > 6)
	{
		a_ai_array = getaiteamarray("axis");
		var_e248524d = array::get_all_closest(level.players[0].origin, a_ai_array, undefined, 4);
		var_1f76714 = array("hear_that", "cannot_hide", "happened_lights", "power_on");
		for(i = 0; i < var_e248524d.size; i++)
		{
			if(isalive(var_e248524d[0]))
			{
				var_e248524d[i] function_11c60e29(var_1f76714[i]);
			}
		}
		wait(1);
	}
	while(spawner::get_ai_group_count("aig_darkroom") > 1)
	{
		a_ai_array = getaiteamarray("axis");
		var_e248524d = array::get_all_closest(level.players[0].origin, a_ai_array, undefined, 4);
		var_1f76714 = array("cant_see", "please_no", "dont_take", "screw_this");
		for(i = 0; i < var_e248524d.size; i++)
		{
			if(isalive(var_e248524d[0]))
			{
				var_e248524d[i] function_11c60e29(var_1f76714[i]);
			}
		}
		wait(1);
	}
}

/*
	Name: function_11c60e29
	Namespace: dark_battle
	Checksum: 0xC806BD22
	Offset: 0x2F60
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function function_11c60e29(s_vo)
{
	n_wait_time = randomfloatrange(0.4, 1);
	wait(n_wait_time);
	if(isalive(self))
	{
		self notify(#"scriptedbc", s_vo);
	}
}

/*
	Name: dark_battle_behavior_handler
	Namespace: dark_battle
	Checksum: 0x6EC1F347
	Offset: 0x2FD0
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function dark_battle_behavior_handler()
{
	foreach(player in level.players)
	{
		player thread dark_battle_player_firing_check();
	}
	level.ai_hyperion thread dark_battle_ai_firing_check();
	level.ai_hendricks thread dark_battle_ai_firing_check();
}

/*
	Name: dark_battle_spawner_init
	Namespace: dark_battle
	Checksum: 0x736DF4D6
	Offset: 0x3098
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function dark_battle_spawner_init()
{
	self endon(#"hash_bd74d007");
	self endon(#"death");
	self.firing_at_something = 0;
	self ai::set_behavior_attribute("cqb", 1);
	self ai::set_ignoreall(1);
	self.goalradius = 32;
	self thread function_494e04e8();
	level waittill(#"lights_out");
	self ai::set_ignoreall(0);
	self.goalradius = 32;
	self.maxsightdistsqrd = 4096;
	choice = randomintrange(1, 4);
	switch(choice)
	{
		case 1:
		{
			str_anim = "cin_gen_vign_confusion_01";
			break;
		}
		case 2:
		{
			str_anim = "cin_gen_vign_confusion_02";
			break;
		}
		case 3:
		{
			str_anim = "cin_gen_vign_confusion_03";
			break;
		}
		default:
		{
			/#
				assert(0, "");
			#/
			break;
		}
	}
	delay = randomfloatrange(0.1, 0.5);
	wait(delay);
	self thread scene::play(str_anim, self);
	level waittill(#"hash_307c99bd");
	if(self scene::is_playing(str_anim))
	{
		self scene::stop(str_anim);
	}
}

/*
	Name: function_494e04e8
	Namespace: dark_battle
	Checksum: 0xF426FC71
	Offset: 0x3298
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_494e04e8()
{
	self endon(#"hash_b1b6677a");
	self endon(#"lights_out");
	self endon(#"death");
	level waittill(#"hash_9babf62");
	level flag::set("flag_player_fired_early");
	self ai::set_ignoreall(0);
	self.goalradius = 96;
}

/*
	Name: dark_battle_player_firing_check
	Namespace: dark_battle
	Checksum: 0x56BDB462
	Offset: 0x3318
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function dark_battle_player_firing_check()
{
	self endon(#"hash_bd74d007");
	self endon(#"death");
	while(true)
	{
		self waittill(#"weapon_fired");
		self thread dark_battle_shots_fired(1);
		wait(3);
	}
}

/*
	Name: dark_battle_ai_firing_check
	Namespace: dark_battle
	Checksum: 0x68554026
	Offset: 0x3378
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function dark_battle_ai_firing_check()
{
	self endon(#"hash_bd74d007");
	self endon(#"death");
	while(true)
	{
		self waittill(#"about_to_fire");
		self thread dark_battle_shots_fired(0.25);
		wait(3);
	}
}

/*
	Name: dark_battle_shots_fired
	Namespace: dark_battle
	Checksum: 0x87F56B33
	Offset: 0x33D8
	Size: 0x122
	Parameters: 1
	Flags: Linked
*/
function dark_battle_shots_fired(n_chance)
{
	self endon(#"death");
	self endon(#"hash_bd74d007");
	a_enemies = getentarray("darkroom_enemy", "script_noteworthy");
	foreach(cur_enemy in a_enemies)
	{
		if(isalive(cur_enemy) && n_chance > randomfloatrange(0, 1))
		{
			if(cur_enemy.firing_at_something == 0)
			{
				cur_enemy thread fire_at_location(self);
			}
		}
	}
}

/*
	Name: fire_at_location
	Namespace: dark_battle
	Checksum: 0xE751DED0
	Offset: 0x3508
	Size: 0x256
	Parameters: 2
	Flags: Linked
*/
function fire_at_location(e_target, duration = 5)
{
	self endon(#"death");
	self.firing_at_something = 1;
	if(isplayer(e_target))
	{
		var_a03ca40a = e_target;
	}
	else
	{
		var_a03ca40a = spawn("script_model", e_target.origin + vectorscale((0, 0, 1), 32));
		var_a03ca40a setmodel("tag_origin");
		var_a03ca40a.health = 1000;
		var_a03ca40a.takedamage = 0;
		var_a03ca40a thread move_target(e_target, self);
		var_a03ca40a thread dark_battle_ai_delete_target(duration + 1);
	}
	self setgoal(self.origin, 1);
	self thread ai::shoot_at_target("shoot_until_target_dead", var_a03ca40a, undefined, duration);
	wait(duration);
	self thread ai::stop_shoot_at_target();
	self.firing_at_something = 0;
	a_nodes = getcovernodearray(self.origin, 192);
	foreach(node in a_nodes)
	{
		if(!isnodeoccupied(node))
		{
			self setgoal(node);
			break;
		}
	}
}

/*
	Name: move_target
	Namespace: dark_battle
	Checksum: 0xE586D545
	Offset: 0x3768
	Size: 0x1CC
	Parameters: 2
	Flags: Linked
*/
function move_target(e_target, e_shooter)
{
	v_right = anglestoright(e_target.angles);
	var_7dad3ff1 = v_right * 50;
	var_a0d5e21e = var_7dad3ff1 + e_target.origin;
	var_58670eab = (var_7dad3ff1 * -1) + e_target.origin;
	var_67766dec = e_target.origin;
	var_20b9665f = e_target.origin + vectorscale((0, 0, 1), 50);
	while(isdefined(e_shooter) && e_shooter.firing_at_something == 1)
	{
		self moveto(var_58670eab, 0.5);
		self waittill(#"movedone");
		self moveto(var_67766dec, 0.5);
		self waittill(#"movedone");
		self moveto(var_a0d5e21e, 0.5);
		self waittill(#"movedone");
		self moveto(var_20b9665f, 0.5);
		self waittill(#"movedone");
	}
}

/*
	Name: dark_battle_ai_delete_target
	Namespace: dark_battle
	Checksum: 0xCB07E299
	Offset: 0x3940
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function dark_battle_ai_delete_target(duration)
{
	wait(duration);
	self delete();
}

/*
	Name: fire_random_direction
	Namespace: dark_battle
	Checksum: 0x2670F7F3
	Offset: 0x3970
	Size: 0x208
	Parameters: 1
	Flags: None
*/
function fire_random_direction(height_offset)
{
	self endon(#"death");
	height_offset = 48 + height_offset;
	self.firing_at_something = 1;
	distance = 64 + height_offset;
	for(i = 0; i < 3; i++)
	{
		myangles = self.angles;
		random_yaw = randomfloatrange(myangles[1] + 30, myangles[1] + 90);
		new_angles = (0, random_yaw, 0);
		vector = anglestoforward(new_angles);
		height_offset_vector = (0, 0, height_offset);
		end_point = (self.origin + height_offset_vector) + (vector * distance);
		var_a03ca40a = spawn("script_origin", end_point);
		var_a03ca40a.health = 1000;
		duration = 1.5;
		self setgoal(self.origin, 1);
		self ai::shoot_at_target("normal", var_a03ca40a, undefined, duration);
		wait(duration);
		var_a03ca40a delete();
	}
	self.firing_at_something = 0;
}

/*
	Name: vtol_guards_handler
	Namespace: dark_battle
	Checksum: 0x4E71109B
	Offset: 0x3B80
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function vtol_guards_handler()
{
	spawner::add_spawn_function_group("vtol_tackle_guy", "script_noteworthy", &cp_prologue_util::ai_idle_then_alert, "vtol_guards_alerted");
	spawn_manager::enable("vtol_tackle_spwn_mgr2");
}

/*
	Name: function_2909799b
	Namespace: dark_battle
	Checksum: 0x7469BC7E
	Offset: 0x3BE0
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_2909799b()
{
	if(!self flag::exists("no_damage_taken"))
	{
		self flag::init("no_damage_taken");
	}
	self flag::set("no_damage_taken");
	self waittill(#"damage");
	self flag::clear("no_damage_taken");
}

/*
	Name: function_4933d21a
	Namespace: dark_battle
	Checksum: 0xA61DE96F
	Offset: 0x3C78
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_4933d21a()
{
	self endon(#"death");
	if(self flag::exists("no_damage_taken") && self flag::get("no_damage_taken"))
	{
		namespace_61c634f2::function_b9175513(self);
	}
}

/*
	Name: function_b7634680
	Namespace: dark_battle
	Checksum: 0x33412DC
	Offset: 0x3CE8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_b7634680()
{
	self flag::init("used_only_melee", 1);
	self flag::init("melee_killed_ai");
	self thread function_b12285b9();
	self thread function_5f41b7ea();
}

/*
	Name: function_e2b1615a
	Namespace: dark_battle
	Checksum: 0xCEECC8AA
	Offset: 0x3D68
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_e2b1615a(params)
{
	if(isplayer(params.eattacker))
	{
		if(params.eattacker flag::exists("melee_killed_ai") && !params.eattacker flag::get("melee_killed_ai"))
		{
			params.eattacker flag::set("melee_killed_ai");
		}
	}
}

/*
	Name: function_b12285b9
	Namespace: dark_battle
	Checksum: 0x9214A0EF
	Offset: 0x3E18
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_b12285b9()
{
	self waittill(#"grenade_fire", grenade, weapon);
	self flag::clear("used_only_melee");
}

/*
	Name: function_5f41b7ea
	Namespace: dark_battle
	Checksum: 0x4B413ED9
	Offset: 0x3E68
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_5f41b7ea()
{
	self waittill(#"weapon_fired");
	self flag::clear("used_only_melee");
}

/*
	Name: function_63222c73
	Namespace: dark_battle
	Checksum: 0x8BDC5066
	Offset: 0x3EA0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_63222c73()
{
	self endon(#"death");
	if(self flag::exists("used_only_melee") && self flag::get("used_only_melee") && self flag::get("melee_killed_ai"))
	{
		namespace_61c634f2::function_df19cf7c(self);
	}
}

#namespace vtol_tackle;

/*
	Name: vtol_tackle_main
	Namespace: vtol_tackle
	Checksum: 0xE401CD8A
	Offset: 0x3F30
	Size: 0x3BC
	Parameters: 1
	Flags: Linked
*/
function vtol_tackle_main(b_starting)
{
	var_6cf84815 = array(level.ai_hyperion, level.ai_prometheus, level.ai_khalil, level.ai_minister, level.ai_hendricks);
	array::thread_all(var_6cf84815, &function_b243f34);
	if(!b_starting)
	{
		level flag::wait_till("dark_battle_end");
	}
	vtol_tackle_scene(b_starting);
	trigger::use("post_vtol_tackle_colors");
	level.ai_hendricks colors::enable();
	savegame::checkpoint_save();
	level thread vtol_tackle_enemies();
	level waittill(#"hash_147f8c7");
	level cp_prologue_util::spawn_coop_player_replacement("skipto_vtol_tackle_ai");
	foreach(ai_ally in level.var_681ad194)
	{
		ai_ally thread hangar::ai_teleport(("ally_0" + ai_ally.var_a89679b6) + "_vtol_tackle_node");
		ai_ally function_b243f34();
	}
	level thread objectives::breadcrumb("dark_battle_breadcrumb_5");
	array::thread_all(var_6cf84815, &function_b243f34, 0);
	array::thread_all(level.var_681ad194, &function_b243f34, 0);
	if(isdefined(level.ai_pallas))
	{
		level.ai_pallas colors::disable();
	}
	level.ai_prometheus colors::set_force_color("o");
	n_node = getnode("theia_vtol_tackle_node", "targetname");
	level.ai_hyperion setgoal(n_node, 1);
	level.ai_hendricks thread hendricks_vtol_tackle_path();
	level thread hendricks_vtol_snark();
	level flag::wait_till("vtol_tackle_move_allies");
	thread dark_battle_cleanup();
	spawn_manager::kill("vtol_tackle_spwn_mgr", 1);
	level thread enemies_killed_timeout();
	level flag::wait_till("robot_reveal");
	skipto::objective_completed("skipto_vtol_tackle");
}

/*
	Name: vtol_tackle_enemies
	Namespace: vtol_tackle
	Checksum: 0x84318EA6
	Offset: 0x42F8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function vtol_tackle_enemies()
{
	spawn_manager::enable("vtol_tackle_spwn_mgr_door");
	spawner::simple_spawn_single("vtol_tackle_staircase_guard");
}

/*
	Name: function_b243f34
	Namespace: vtol_tackle
	Checksum: 0x8FB1A16F
	Offset: 0x4338
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function function_b243f34(b_state = 1)
{
	if(b_state)
	{
		self ai::set_ignoreall(1);
		self ai::set_ignoreme(1);
		self.goalradius = 32;
	}
	else
	{
		self battlechatter::function_d9f49fba(1);
		self ai::set_ignoreall(0);
		self ai::set_ignoreme(0);
	}
}

/*
	Name: vtol_tackle_scene
	Namespace: vtol_tackle
	Checksum: 0x4EBAABA6
	Offset: 0x43F8
	Size: 0x27C
	Parameters: 1
	Flags: Linked
*/
function vtol_tackle_scene(b_starting)
{
	array::thread_all(level.players, &function_236046c4);
	level scene::add_scene_func("cin_pro_13_01_vtoltackle_vign_takedown", &function_b007992c, "play");
	if(b_starting)
	{
		level thread scene::skipto_end("cin_pro_13_01_vtoltackle_vign_takedown", undefined, undefined, 0.2);
		level thread scene::skipto_end("cin_pro_13_01_vtoltackle_vign_takedown_khalil", undefined, undefined, 0.2);
		level thread scene::skipto_end("cin_pro_13_01_vtoltackle_vign_takedown_minister", undefined, undefined, 0.2);
	}
	else
	{
		level thread scene::play("cin_pro_13_01_vtoltackle_vign_takedown");
		level thread scene::play("cin_pro_13_01_vtoltackle_vign_takedown_khalil");
		level thread scene::play("cin_pro_13_01_vtoltackle_vign_takedown_minister");
	}
	level.ai_hyperion setgoal(getnode("hyperion_post_dark_battle", "targetname"), 1);
	vehicle::simple_spawn_single_and_drive("vtol_vehicle");
	level thread function_623731e2();
	level thread function_321578a8();
	level thread function_1e5dba01();
	level waittill(#"hash_7ab4e268");
	level flag::set("vtol_has_crashed");
	level flag::set("vtol_guards_alerted");
	node = getnode("prometheus_vtol_tackle_node2", "targetname");
	level.ai_prometheus thread ai::force_goal(node, 32);
}

/*
	Name: function_b007992c
	Namespace: vtol_tackle
	Checksum: 0x61634651
	Offset: 0x4680
	Size: 0x16C
	Parameters: 1
	Flags: Linked
*/
function function_b007992c(a_ents)
{
	vh_vtol = a_ents["vtol"];
	vh_vtol.script_crashtypeoverride = "none";
	vh_vtol thread cp_prologue_util::vehicle_rumble("buzz_high", "stop_vh_rumble", 0.05, 0.1, 3000, 20);
	vh_vtol thread cp_prologue_util::function_c56034b7();
	level waittill(#"hash_3af3e792");
	vh_vtol notify(#"death");
	vh_vtol notify(#"hash_c5b436ee");
	vh_vtol setmodel("veh_t7_mil_vtol_nrc_no_interior_d");
	level thread cp_prologue_util::function_2a0bc326(vh_vtol.origin, 0.6, 2, 5000, 6);
	exploder::exploder("light_exploder_vtol_tackle_fire");
	wait(1);
	level thread cp_prologue_util::function_2a0bc326(vh_vtol.origin, 0.3, 2, 5000, 6);
}

/*
	Name: function_1e5dba01
	Namespace: vtol_tackle
	Checksum: 0x2C19415C
	Offset: 0x47F8
	Size: 0x162
	Parameters: 0
	Flags: Linked
*/
function function_1e5dba01()
{
	level waittill(#"hash_ec873a98");
	var_280d5f68 = getent("intelstation_exit_door_l", "targetname");
	var_3c301126 = getent("intelstation_exit_door_r", "targetname");
	v_move = (54, 0, 0);
	v_door_destination = var_280d5f68.origin + v_move;
	var_280d5f68 moveto(v_door_destination, 0.5);
	v_door_destination = var_3c301126.origin - v_move;
	var_3c301126 moveto(v_door_destination, 0.5);
	var_3c301126 waittill(#"movedone");
	var_3c301126 connectpaths();
	var_280d5f68 connectpaths();
	level notify(#"hash_147f8c7");
}

/*
	Name: function_321578a8
	Namespace: vtol_tackle
	Checksum: 0xA0E73D1D
	Offset: 0x4968
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_321578a8()
{
	level waittill(#"hash_41679010");
	level scene::play("p7_fxanim_cp_prologue_vtol_tackle_windows_bundle");
}

/*
	Name: function_623731e2
	Namespace: vtol_tackle
	Checksum: 0xDC0D2BC1
	Offset: 0x49A0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_623731e2()
{
	level waittill(#"hash_13ea3fcf");
	level thread namespace_21b2c1f2::function_f573bcb9();
	level dialog::remote("tayr_easy_hold_your_fire_0", undefined, "normal");
}

/*
	Name: hendricks_vtol_snark
	Namespace: vtol_tackle
	Checksum: 0xE62D562C
	Offset: 0x49F8
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function hendricks_vtol_snark()
{
	level thread namespace_21b2c1f2::function_49fef8f4();
	level.ai_hendricks dialog::say("hend_taylor_alpha_two_te_0", 2);
	level.ai_hendricks dialog::say("hend_comes_easy_now_hu_0", 1.5);
	level.ai_prometheus dialog::say("tayr_extract_is_the_satel_0", 0.5);
	level.ai_hendricks dialog::say("hend_you_didn_t_answer_me_0", 0.5);
	level.ai_hyperion dialog::say("mare_keep_up_secondary_r_0", 3);
}

/*
	Name: hendricks_vtol_tackle_path
	Namespace: vtol_tackle
	Checksum: 0x4176C7C1
	Offset: 0x4AE8
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function hendricks_vtol_tackle_path()
{
	self ai::set_ignoreall(0);
	self ai::set_ignoreme(0);
	node = getnode("hendricks_vtol_tackle_node2", "targetname");
	self setgoal(node, 1);
	self.goalradius = 500;
}

/*
	Name: ai_setgoal
	Namespace: vtol_tackle
	Checksum: 0xA96365F1
	Offset: 0x4B78
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function ai_setgoal(ai_node)
{
	node = getnode(ai_node, "targetname");
	self setgoal(node, 1);
}

/*
	Name: dark_battle_cleanup
	Namespace: vtol_tackle
	Checksum: 0xEDFCE9B8
	Offset: 0x4BD8
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function dark_battle_cleanup()
{
	a_ai_db_guys = getaiarray("dark_battle_guy", "targetname");
	foreach(ai_guy in a_ai_db_guys)
	{
		if(isalive(ai_guy))
		{
			ai_guy kill();
		}
	}
}

/*
	Name: enemies_killed_timeout
	Namespace: vtol_tackle
	Checksum: 0x91E5947D
	Offset: 0x4CB0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function enemies_killed_timeout()
{
	level spawner::waittill_ai_group_cleared("vtol_tackle_enemies");
	trigger::use("robot_reveal_trig");
}

/*
	Name: function_236046c4
	Namespace: vtol_tackle
	Checksum: 0xEC57F130
	Offset: 0x4CF8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_236046c4()
{
	level endon(#"hash_51bc43cb");
	self waittill(#"weapon_fired");
	level flag::set("vtol_guards_alerted");
	self thread function_ecf2e565();
}

/*
	Name: function_ecf2e565
	Namespace: vtol_tackle
	Checksum: 0x602C0766
	Offset: 0x4D58
	Size: 0x120
	Parameters: 0
	Flags: Linked
*/
function function_ecf2e565()
{
	level endon(#"hash_51bc43cb");
	veh_vtol = getent("vtol", "animname");
	while(true)
	{
		if(!isdefined(veh_vtol))
		{
			wait(0.5);
			continue;
		}
		var_30299a05 = (randomintrange(-150, 150), randomintrange(-150, 150), randomintrange(-150, 150));
		magicbullet(getweapon("turret_bo3_mil_vtol_nrc"), veh_vtol gettagorigin("tag_gunner_barrel3") + (vectorscale((0, -1, 0), 40)), self.origin + var_30299a05);
		wait(0.05);
	}
}

#namespace prologue_util;

/*
	Name: remove_grenades
	Namespace: prologue_util
	Checksum: 0x55E4F2BC
	Offset: 0x4E80
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function remove_grenades()
{
	self.grenadeammo = 0;
}

