// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_sing_vengeance_accolades;
#using scripts\cp\cp_mi_sing_vengeance_dogleg_1;
#using scripts\cp\cp_mi_sing_vengeance_sound;
#using scripts\cp\cp_mi_sing_vengeance_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_dev;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\stealth;
#using scripts\shared\stealth_aware;
#using scripts\shared\stealth_status;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

#namespace vengeance_killing_streets;

/*
	Name: skipto_killing_streets_init
	Namespace: vengeance_killing_streets
	Checksum: 0x7D1E695D
	Offset: 0x17E8
	Size: 0x1A4
	Parameters: 2
	Flags: Linked
*/
function skipto_killing_streets_init(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		vengeance_util::skipto_baseline(str_objective, b_starting);
		vengeance_util::init_hero("hendricks", str_objective);
		level thread vengeance_util::function_e3420328("killing_streets_ambient_anims", "dogleg_1_begin");
		objectives::set("cp_level_vengeance_rescue_kane");
		objectives::set("cp_level_vengeance_go_to_safehouse");
		level thread function_9736d8c9();
		level thread setup_killing_streets_intro_patroller_spawners();
		load::function_a2995f22();
		videostop("cp_vengeance_env_sign_dancer01");
		wait(0.05);
		level thread vengeance_util::function_ab876b5a("cp_vengeance_env_sign_dancer01", "strip_video_start", "strip_video_end");
		wait(0.05);
		level notify(#"hash_96cd3d20");
	}
	vengeance_util::function_4e8207e9("killing_streets");
	thread cp_mi_sing_vengeance_sound::function_749aad88();
	killing_streets_main(str_objective);
}

/*
	Name: killing_streets_main
	Namespace: vengeance_killing_streets
	Checksum: 0xBFA0905F
	Offset: 0x1998
	Size: 0x29C
	Parameters: 1
	Flags: Linked
*/
function killing_streets_main(str_objective)
{
	level flag::set("killing_streets_begin");
	exploder::exploder("killing_streets_butcher_fx");
	spawner::add_spawn_function_group("killing_streets_civilian_spawners", "script_noteworthy", &setup_killing_streets_civilian);
	level.ai_hendricks thread setup_killing_streets_alley_hendricks();
	level.ai_hendricks thread setup_killing_streets_alley_hendricks_stealth_broken();
	level thread function_4b7aea65();
	level thread function_ef12791();
	level.var_b40baa9d = struct::get("lineup_kill_doors_scripted_node", "targetname");
	level.lineup_kill_scripted_node = struct::get("lineup_kill_scripted_node", "targetname");
	level.var_b40baa9d thread scene::init("cin_ven_03_20_storelineup_vign_start_doors_only");
	level.var_b40baa9d thread scene::init("cin_ven_03_20_storelineup_vign_exit");
	level.var_5abaf57 = struct::get("dogleg_1_intro_org");
	s_scene = level.scriptbundles["scene"]["cin_ven_04_10_cafedoor_1st_sh010"];
	s_scene.objects[0].entitylerptime = 0.5;
	s_scene.objects[1].cameratween = 0.2;
	s_scene.objects[1].lerptime = 0.2;
	level.var_5abaf57 scene::init("cin_ven_04_10_cafedoor_1st_sh010");
	level thread function_71a7056();
	level thread function_999f0273();
	level thread function_9f0122b9();
	level thread function_28fa297f();
}

/*
	Name: setup_killing_streets_alley_hendricks
	Namespace: vengeance_killing_streets
	Checksum: 0xD30B3BFF
	Offset: 0x1C40
	Size: 0x274
	Parameters: 0
	Flags: Linked
*/
function setup_killing_streets_alley_hendricks()
{
	level endon(#"stealth_combat");
	level endon(#"stealth_alert");
	level endon(#"killing_streets_intro_patroller_spawners_cleared");
	self endon(#"death");
	self.holdfire = 1;
	self.ignoreall = 0;
	self.ignoreme = 1;
	self colors::disable();
	self ai::set_behavior_attribute("cqb", 1);
	self.goalradius = 32;
	self battlechatter::function_d9f49fba(0);
	node = getnode("killing_streets_hendricks_node_03", "targetname");
	self setgoal(node, 1, 16);
	if(!level flag::get("move_killing_streets_hendricks_node_05"))
	{
		level flag::wait_till("move_killing_streets_hendricks_node_05");
	}
	node = getnode("killing_streets_hendricks_node_05", "targetname");
	self setgoal(node, 1, 16);
	if(!level flag::get("move_killing_streets_hendricks_node_10") || !level flag::get("killing_streets_civilian_sniped"))
	{
		level flag::wait_till_all(array("move_killing_streets_hendricks_node_10", "killing_streets_civilian_sniped"));
	}
	node = getnode("killing_streets_hendricks_node_10", "targetname");
	self setgoal(node, 1, 16);
	self waittill(#"goal");
	wait(7);
	level flag::set("hendricks_break_ally_stealth");
}

/*
	Name: setup_killing_streets_alley_hendricks_stealth_broken
	Namespace: vengeance_killing_streets
	Checksum: 0x66BCFFF1
	Offset: 0x1EC0
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function setup_killing_streets_alley_hendricks_stealth_broken()
{
	level flag::wait_till_any(array("stealth_alert", "stealth_combat", "killing_streets_intro_patroller_spawners_cleared", "cin_ven_03_15_killingstreets_vign_done", "hendricks_break_ally_stealth"));
	self.var_df53bc6 = self.script_accuracy;
	self.script_accuracy = 0.1;
	self.ignoreme = 0;
	self.holdfire = 0;
	self ai::set_behavior_attribute("cqb", 0);
	self colors::enable();
	level flag::wait_till("killing_streets_intro_patroller_spawners_cleared");
	level flag::clear("stealth_discovered");
	self colors::disable();
	self.ignoreme = 1;
	self.ignoreall = 1;
	self.holdfire = 1;
	self battlechatter::function_d9f49fba(0);
	self.script_accuracy = self.var_df53bc6;
	self ai::set_behavior_attribute("cqb", 1);
	self ai::set_behavior_attribute("sprint", 0);
	stealth::reset();
	wait(0.05);
	self thread setup_killing_streets_lineup_hendricks();
}

/*
	Name: function_9736d8c9
	Namespace: vengeance_killing_streets
	Checksum: 0xCF63661F
	Offset: 0x2098
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function function_9736d8c9()
{
	killing_streets_intro_patroller_spawners = spawner::simple_spawn("killing_streets_intro_sniper_spawner", &vengeance_util::setup_patroller);
	level.var_abd93cb3 = killing_streets_intro_patroller_spawners[0];
	level.var_abd93cb3 thread function_68661375();
	scene::add_scene_func("cin_ven_03_15_killingstreets_vign_snipershot", &function_286754f2, "done");
	var_bba8f947 = struct::get("lineup_kill_doors_scripted_node");
	var_bba8f947 thread scene::init("cin_ven_03_15_killingstreets_vign_snipershot");
	level flag::wait_till("start_killing_streets_sniper_shoots_civilian");
	playsoundatposition("mus_alley_stinger", (0, 0, 0));
	util::clientnotify("sndLRstart");
	var_bba8f947 thread scene::play("cin_ven_03_15_killingstreets_vign_snipershot");
	thread cp_mi_sing_vengeance_sound::function_68da61d9();
	wait(0.1);
	while(true)
	{
		guy = getent("killing_streets_alley_civ_a_ai", "targetname");
		if(isdefined(guy))
		{
			break;
		}
		wait(0.05);
	}
	guy.perfectaim = 1;
	guy laseron();
	guy endon(#"death");
	guy waittill(#"sniper_fire");
	level.var_abd93cb3 notify(#"hash_55f87e20");
	guy animation::fire_weapon();
}

/*
	Name: function_286754f2
	Namespace: vengeance_killing_streets
	Checksum: 0x75EDBB98
	Offset: 0x22C0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_286754f2(a_ents)
{
	level flag::set("killing_streets_civilian_sniped");
}

/*
	Name: setup_killing_streets_lineup_hendricks
	Namespace: vengeance_killing_streets
	Checksum: 0xD3C3DCF2
	Offset: 0x22F8
	Size: 0x75C
	Parameters: 0
	Flags: Linked
*/
function setup_killing_streets_lineup_hendricks()
{
	level endon(#"killing_streets_lineup_patrollers_alerted");
	self endon(#"death");
	self thread setup_killing_streets_lineup_hendricks_stealth_broken();
	level flag::set("move_hendricks_to_meat_market");
	var_6e87e729 = struct::get("hendricks_open_alley_door_01_gather_org");
	objectives::set("cp_waypoint_breadcrumb", var_6e87e729);
	e_node = getnode("hendricks_pre_butcher_node", "targetname");
	self setgoal(e_node, 1);
	self waittill(#"goal");
	self ai::set_behavior_attribute("cqb", 0);
	self ai::set_behavior_attribute("forceTacticalWalk", 1);
	e_node = getnode("hendricks_pre_butcher_node_2", "targetname");
	self setgoal(e_node, 1);
	self waittill(#"goal");
	level.lineup_kill_scripted_node scene::init("cin_ven_03_20_storelineup_vign_start_hendricks_only");
	level flag::set("enable_hendricks_open_alley_door_01");
	self waittill(#"reach_done");
	level thread function_96d0d9ff();
	level flag::wait_till("start_hendricks_open_alley_door_01");
	if(isdefined(level.bzm_vengeancedialogue3_1callback))
	{
		level thread [[level.bzm_vengeancedialogue3_1callback]]();
	}
	savegame::checkpoint_save();
	objectives::complete("cp_waypoint_breadcrumb", var_6e87e729);
	objectives::hide("cp_level_vengeance_go_to_safehouse");
	self ai::set_behavior_attribute("forceTacticalWalk", 0);
	self ai::set_behavior_attribute("cqb", 1);
	level thread killing_streets_robots();
	spawner::add_spawn_function_group("killing_streets_lineup_patroller_spawners", "script_noteworthy", &setup_killing_streets_lineup_patroller_spawners);
	spawner::add_spawn_function_group("killing_streets_lineup_civilian_spawners", "script_noteworthy", &setup_killing_streets_civilian_lineup);
	storelineup_door1_clip = getent("storelineup_door1_clip", "targetname");
	storelineup_door1_clip thread storelineup_door1_clip();
	level thread lineup_kill_scene_manager();
	level thread lineup_kill_scene_stopper();
	level waittill(#"cin_ven_03_20_storelineup_vign_start_done");
	if(!level flag::get("move_killing_streets_hendricks_node_30"))
	{
		level flag::wait_till("move_killing_streets_hendricks_node_30");
	}
	level flag::set("hendricks_says_stay_down");
	level.lineup_kill_scripted_node scene::play("cin_ven_03_20_storelineup_vign_move1");
	if(!level flag::get("move_killing_streets_hendricks_node_35"))
	{
		level flag::wait_till("move_killing_streets_hendricks_node_35");
	}
	level.lineup_kill_scripted_node scene::play("cin_ven_03_20_storelineup_vign_move2");
	if(!level flag::get("move_killing_streets_hendricks_node_40") && !level flag::get("cin_ven_03_20_storelineup_vign_fire_done"))
	{
		level flag::wait_till_all(array("move_killing_streets_hendricks_node_40", "cin_ven_03_20_storelineup_vign_fire_done"));
	}
	level.lineup_kill_scripted_node scene::play("cin_ven_03_20_storelineup_vign_move3");
	level flag::set("enable_hendricks_open_alley_door_02");
	if(!level flag::get("start_hendricks_open_alley_door_02"))
	{
		level flag::wait_till("start_hendricks_open_alley_door_02");
	}
	savegame::checkpoint_save();
	storelineup_door3_clip = getent("storelineup_door3_clip", "targetname");
	if(isdefined(storelineup_door3_clip))
	{
		storelineup_door3_clip thread storelineup_door3_clip();
	}
	level.var_b40baa9d thread scene::play("cin_ven_03_20_storelineup_vign_exit");
	wait(0.5);
	self clearforcedgoal();
	node = getnode("killing_streets_hendricks_node_55", "targetname");
	self setgoal(node, 1, 16);
	level waittill(#"hash_2b5b2f5d");
	level flag::set("hendricks_cleared_meat_market_door");
	level flag::wait_till("move_killing_streets_hendricks_node_57");
	node = getnode("killing_streets_hendricks_node_57", "targetname");
	self setgoal(node, 1, 16);
	level flag::wait_till("clear_killing_streets_breadcrumb_07");
	level.ai_hendricks thread function_2adde689();
	node = getnode("killing_streets_hendricks_node_60", "targetname");
	self setgoal(node, 1, 16);
}

/*
	Name: setup_killing_streets_lineup_hendricks_stealth_broken
	Namespace: vengeance_killing_streets
	Checksum: 0x723D61EF
	Offset: 0x2A60
	Size: 0x394
	Parameters: 0
	Flags: Linked
*/
function setup_killing_streets_lineup_hendricks_stealth_broken()
{
	level flag::wait_till("killing_streets_lineup_patrollers_alerted");
	wait(0.05);
	self stopanimscripted();
	self.ignoreme = 0;
	self.ignoreall = 0;
	self.holdfire = 0;
	self battlechatter::function_d9f49fba(1);
	self ai::set_behavior_attribute("forceTacticalWalk", 0);
	self colors::enable();
	level flag::wait_till_all(array("killing_streets_lineup_patroller_spawners_cleared", "killing_streets_robots_cleared"));
	level flag::clear("stealth_discovered");
	self.ignoreme = 1;
	self.holdfire = 1;
	self battlechatter::function_d9f49fba(0);
	self ai::set_behavior_attribute("cqb", 1);
	self colors::disable();
	storelineup_door3_clip = getent("storelineup_door3_clip", "targetname");
	if(isdefined(storelineup_door3_clip))
	{
		storelineup_door3_clip thread storelineup_door3_clip();
	}
	if(!level flag::get("hendricks_cleared_meat_market_door"))
	{
		level.var_b40baa9d thread scene::play("cin_ven_03_20_storelineup_vign_exit_reach");
		self waittill(#"reach_done");
		wait(0.5);
	}
	self clearforcedgoal();
	node = getnode("killing_streets_hendricks_node_55", "targetname");
	self setgoal(node, 1, 16);
	if(!level flag::get("hendricks_cleared_meat_market_door"))
	{
		level waittill(#"hash_2b5b2f5d");
	}
	level flag::wait_till("move_killing_streets_hendricks_node_57");
	node = getnode("killing_streets_hendricks_node_57", "targetname");
	self setgoal(node, 1, 16);
	level flag::wait_till("clear_killing_streets_breadcrumb_07");
	level.ai_hendricks thread function_2adde689();
	node = getnode("killing_streets_hendricks_node_60", "targetname");
	self setgoal(node, 1, 16);
}

/*
	Name: function_2adde689
	Namespace: vengeance_killing_streets
	Checksum: 0x337F0D0B
	Offset: 0x2E00
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_2adde689()
{
	self endon(#"death");
	self ai::set_behavior_attribute("vignette_mode", "fast");
	self ai::set_behavior_attribute("coverIdleOnly", 1);
	level waittill(#"hash_f1a04aa0");
	self ai::set_behavior_attribute("vignette_mode", "off");
	self ai::set_behavior_attribute("coverIdleOnly", 0);
}

/*
	Name: function_96d0d9ff
	Namespace: vengeance_killing_streets
	Checksum: 0x407150FD
	Offset: 0x2EB0
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function function_96d0d9ff()
{
	foreach(e_player in level.activeplayers)
	{
		e_player thread function_a39cd1bb();
	}
}

/*
	Name: function_a39cd1bb
	Namespace: vengeance_killing_streets
	Checksum: 0x78E6D71E
	Offset: 0x2F48
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function function_a39cd1bb()
{
	level endon(#"killing_streets_lineup_patrollers_alerted");
	level endon(#"hash_f1a04aa0");
	self endon(#"disconnect");
	var_68586610 = getentarray("killing_streets_outside", "targetname");
	while(true)
	{
		foreach(e_vol in var_68586610)
		{
			if(self istouching(e_vol))
			{
				self.ignoreme = 1;
				continue;
			}
			self.ignoreme = 0;
		}
		wait(0.05);
	}
}

/*
	Name: lineup_kill_scene_manager
	Namespace: vengeance_killing_streets
	Checksum: 0x9BCC7645
	Offset: 0x3060
	Size: 0x392
	Parameters: 0
	Flags: Linked
*/
function lineup_kill_scene_manager()
{
	level endon(#"killing_streets_lineup_patrollers_alerted");
	level thread function_fd81381e("execution_blood_spray_lt", "lineup_civ_1_killed", "lineup_kill_decal_lt_window_broken");
	level thread function_fd81381e("execution_blood_spray_rt", "lineup_civ_2_killed", "lineup_kill_decal_rt_window_broken");
	level thread function_d864c642();
	level.lineup_kill_scripted_node thread scene::init("cin_ven_03_20_storelineup_vign_fire");
	level.var_b40baa9d thread scene::play("cin_ven_03_20_storelineup_vign_start_doors_only");
	level.lineup_kill_scripted_node scene::play("cin_ven_03_20_storelineup_vign_start_hendricks_only");
	level notify(#"cin_ven_03_20_storelineup_vign_start_done");
	level flag::wait_till("start_lineup_kill_execution");
	level.lineup_kill_scripted_node scene::play("cin_ven_03_20_storelineup_vign_fire");
	level flag::set("cin_ven_03_20_storelineup_vign_fire_done");
	node = getnode("killing_streets_lineup_patroller_spawners_exit_node", "targetname");
	guys = getentarray("killing_streets_robots", "script_noteworthy", 1);
	foreach(guy in guys)
	{
		if(isdefined(guy) && isalive(guy))
		{
			if(isdefined(guy.script_delay))
			{
				guy thread util::_delay(guy.script_delay, undefined, &vengeance_util::delete_ai_at_path_end, node, undefined, 1, 1024);
				continue;
			}
			guy thread vengeance_util::delete_ai_at_path_end(node, undefined, 1, 1024);
		}
	}
	wait(15);
	guys = getentarray("killing_streets_lineup_patroller_spawners", "script_noteworthy", 1);
	foreach(guy in guys)
	{
		if(isdefined(guy) && isalive(guy))
		{
			guy thread vengeance_util::delete_ai_at_path_end(node, undefined, 1, 1024);
		}
	}
}

/*
	Name: function_fd81381e
	Namespace: vengeance_killing_streets
	Checksum: 0x59360835
	Offset: 0x3400
	Size: 0xF4
	Parameters: 3
	Flags: Linked
*/
function function_fd81381e(var_210e7715, var_a9d6b8b7, var_734ef62a)
{
	var_f644fb29 = getent(var_210e7715, "targetname");
	var_f644fb29 clientfield::set("normal_hide", 1);
	var_f644fb29 notsolid();
	level waittill(var_a9d6b8b7);
	if(!level flag::get(var_734ef62a))
	{
		var_f644fb29 clientfield::set("mature_hide", 1);
	}
	level flag::wait_till(var_734ef62a);
	var_f644fb29 delete();
}

/*
	Name: function_d864c642
	Namespace: vengeance_killing_streets
	Checksum: 0x345B31DD
	Offset: 0x3500
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_d864c642()
{
	level flag::wait_till_any(array("killing_streets_lineup_patrollers_alerted", "lineup_kill_window_broken"));
	var_f4835685 = getent("storelineup_window_clip", "targetname");
	if(isdefined(var_f4835685))
	{
		var_f4835685 delete();
	}
}

/*
	Name: lineup_kill_scene_stopper
	Namespace: vengeance_killing_streets
	Checksum: 0x17E2C61D
	Offset: 0x3590
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function lineup_kill_scene_stopper()
{
	level flag::wait_till("killing_streets_lineup_patrollers_alerted");
	level.lineup_kill_scripted_node scene::stop();
}

/*
	Name: storelineup_door1_clip
	Namespace: vengeance_killing_streets
	Checksum: 0xCBC0F675
	Offset: 0x35D8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function storelineup_door1_clip()
{
	wait(2);
	self notsolid();
	self connectpaths();
	wait(1);
	self delete();
}

/*
	Name: storelineup_door3_clip
	Namespace: vengeance_killing_streets
	Checksum: 0xED1683FD
	Offset: 0x3640
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function storelineup_door3_clip()
{
	wait(0.75);
	self notsolid();
	self connectpaths();
}

/*
	Name: setup_killing_streets_intro_patroller_spawners
	Namespace: vengeance_killing_streets
	Checksum: 0xF76C7F99
	Offset: 0x3688
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function setup_killing_streets_intro_patroller_spawners()
{
	spawner::add_spawn_function_group("killing_streets_intro_patroller_spawners", "script_noteworthy", &function_a45594e6);
	var_6a07eb6c = [];
	var_6a07eb6c[0] = "killing_streets_alley_civ_b";
	var_6a07eb6c[1] = "killing_streets_alley_rope";
	scene::add_scene_func("cin_ven_03_15_killingstreets_vign", &vengeance_util::function_65a61b78, "play", var_6a07eb6c);
	scene::add_scene_func("cin_ven_03_15_killingstreets_vign_loop", &vengeance_util::function_65a61b78, "play", var_6a07eb6c);
	var_a9e0b15b = struct::get("lineup_kill_doors_scripted_node");
	var_a9e0b15b scene::init("cin_ven_03_15_killingstreets_vign");
	if(!level flag::get("move_killing_streets_hendricks_node_15"))
	{
		level flag::wait_till("move_killing_streets_hendricks_node_15");
	}
	var_a9e0b15b scene::play("cin_ven_03_15_killingstreets_vign");
}

/*
	Name: function_a45594e6
	Namespace: vengeance_killing_streets
	Checksum: 0x8C5556B4
	Offset: 0x3808
	Size: 0x1FA
	Parameters: 0
	Flags: Linked
*/
function function_a45594e6()
{
	self endon(#"death");
	self ai::set_ignoreme(1);
	self ai::set_ignoreall(1);
	setdvar("ai_awarenessEnabled", 0);
	self thread function_53a6540a();
	if(!level flag::get("move_killing_streets_hendricks_node_15"))
	{
		level flag::wait_till("move_killing_streets_hendricks_node_15");
	}
	self ai::set_ignoreall(0);
	setdvar("ai_awarenessEnabled", 1);
	while(true)
	{
		eventname = self util::waittill_any_return("killing_streets_intro_alerted", "scene_done", "done_shooting_civilian");
		if(eventname == "done_shooting_civilian")
		{
			self ai::set_ignoreme(0);
		}
		else
		{
			level flag::set("cin_ven_03_15_killingstreets_vign_done");
			var_c3b293c9 = getent("killing_streets_enemy_gv", "targetname");
			if(isdefined(var_c3b293c9))
			{
				if(isdefined(self.var_30dac0b5) && self.var_30dac0b5)
				{
					self waittill(#"hash_45b11ba2");
					self.var_30dac0b5 = undefined;
				}
				wait(0.05);
				self setgoal(var_c3b293c9);
			}
			return;
		}
	}
}

/*
	Name: function_68661375
	Namespace: vengeance_killing_streets
	Checksum: 0x5EEAA6B6
	Offset: 0x3A10
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_68661375()
{
	self endon(#"death");
	self ai::set_ignoreme(1);
	self ai::set_ignoreall(1);
	self waittill(#"hash_55f87e20");
	self ai::set_ignoreme(0);
	self ai::set_ignoreall(0);
}

/*
	Name: function_53a6540a
	Namespace: vengeance_killing_streets
	Checksum: 0x25E7C3B8
	Offset: 0x3A90
	Size: 0xB6
	Parameters: 0
	Flags: Linked
*/
function function_53a6540a()
{
	self endon(#"death");
	self waittill(#"alert");
	self notify(#"hash_30dac0b5");
	level.var_abd93cb3 notify(#"hash_55f87e20");
	level.var_abd93cb3 stealth::stop();
	if(isdefined(self.script_parameters))
	{
		self stealth::stop();
		self.var_30dac0b5 = 1;
		self scene::play(self.script_parameters);
		self waittill(#"scene_done");
		self notify(#"hash_45b11ba2");
	}
}

/*
	Name: setup_killing_streets_civilian
	Namespace: vengeance_killing_streets
	Checksum: 0x4692D38
	Offset: 0x3B50
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function setup_killing_streets_civilian()
{
	self endon(#"death");
	self.team = "allies";
	self ai::set_ignoreme(1);
	self ai::set_ignoreall(1);
	self.health = 1;
	if(self.targetname == "killing_streets_alley_civ_a_ai")
	{
		self.civilian = 1;
		self ai::set_behavior_attribute("panic", 0);
	}
	if(isdefined(self.target))
	{
		node = getnode(self.target, "targetname");
		self thread ai::force_goal(node, node.radius);
	}
	level waittill(#"hash_f4c7c788");
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: setup_killing_streets_civilian_lineup
	Namespace: vengeance_killing_streets
	Checksum: 0xF1539999
	Offset: 0x3C80
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function setup_killing_streets_civilian_lineup()
{
	self endon(#"death");
	self.team = "allies";
	self.civilian = 1;
	self ai::set_ignoreme(1);
	self ai::set_behavior_attribute("panic", 0);
	self thread function_cfede1cf();
	level flag::wait_till("killing_streets_lineup_patrollers_alerted");
	self stopanimscripted();
	self ai::set_ignoreme(0);
	self ai::set_behavior_attribute("panic", 1);
}

/*
	Name: function_cfede1cf
	Namespace: vengeance_killing_streets
	Checksum: 0xC47756B
	Offset: 0x3D78
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_cfede1cf()
{
	self endon(#"death");
	self waittill(#"kill_me");
	self.takedamage = 1;
	self.skipdeath = 1;
	self.allowdeath = 1;
	self kill();
}

/*
	Name: setup_killing_streets_lineup_patroller_spawners
	Namespace: vengeance_killing_streets
	Checksum: 0xA8A96CF8
	Offset: 0x3DD8
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function setup_killing_streets_lineup_patroller_spawners()
{
	self endon(#"death");
	self ai::set_ignoreme(1);
	self util::waittill_any("damage", "alert");
	self ai::set_ignoreme(0);
	level flag::set("killing_streets_lineup_patrollers_alerted");
	util::clientnotify("sndLRstop");
	level thread namespace_9fd035::function_6c2fa1d0();
	self stopanimscripted();
}

/*
	Name: killing_streets_robots
	Namespace: vengeance_killing_streets
	Checksum: 0x8BEE243C
	Offset: 0x3EB0
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function killing_streets_robots()
{
	killing_streets_robots = spawner::simple_spawn("killing_streets_robots", undefined, undefined, undefined, undefined, undefined, undefined, 1);
}

/*
	Name: skipto_killing_streets_done
	Namespace: vengeance_killing_streets
	Checksum: 0x9E240D64
	Offset: 0x3EF0
	Size: 0x694
	Parameters: 4
	Flags: Linked
*/
function skipto_killing_streets_done(str_objective, b_starting, b_direct, player)
{
	level flag::set("killing_streets_end");
	level cleanup_killing_streets();
	foreach(player in level.activeplayers)
	{
		player clientfield::set_to_player("play_client_igc", 2);
	}
	vengeance_util::function_e00864bd("dogleg_1_umbra_gate", 1, "dogleg_1_gate");
	level struct::delete_script_bundle("scene", "cin_ven_02_20_synckill_vign");
	level struct::delete_script_bundle("scene", "cin_ven_02_30_masterbedroom_vign");
	level struct::delete_script_bundle("scene", "cin_ven_hanging_body_loop_vign_civ03");
	level struct::delete_script_bundle("scene", "cin_ven_hanging_body_loop_vign_civ06");
	level struct::delete_script_bundle("scene", "cin_ven_hanging_body_loop_vign_civ08");
	level struct::delete_script_bundle("scene", "cin_ven_03_10_takedown_intro_1st");
	level struct::delete_script_bundle("scene", "cin_ven_03_10_takedown_intro_1st_props");
	level struct::delete_script_bundle("scene", "cin_ven_03_10_takedown_1st");
	level struct::delete_script_bundle("scene", "cin_ven_03_10_takedown_1st_props");
	level struct::delete_script_bundle("scene", "cin_ven_03_10_takedown_intro_1st_test");
	level struct::delete_script_bundle("scene", "cin_ven_01_02_rooftop_1st_overlook");
	level struct::delete_script_bundle("scene", "cin_ven_03_10_takedown_1st_hendricks");
	level struct::delete_script_bundle("scene", "cin_ven_03_11_gate_convo_vign");
	level struct::delete_script_bundle("scene", "cin_ven_03_15_killingstreets_vign_snipershot");
	level struct::delete_script_bundle("scene", "cin_ven_03_15_killingstreets_vign");
	level struct::delete_script_bundle("scene", "cin_ven_03_15_killingstreets_vign_loop");
	level struct::delete_script_bundle("scene", "cin_ven_03_15_killingstreets_vign_react_enemy_a");
	level struct::delete_script_bundle("scene", "cin_ven_03_15_killingstreets_vign_react_enemy_b");
	level struct::delete_script_bundle("scene", "cin_ven_03_15_killingstreets_vign_react_enemy_c");
	level struct::delete_script_bundle("scene", "cin_ven_03_15_killingstreets_vign_react_enemy_d");
	level struct::delete_script_bundle("scene", "cin_ven_03_20_storelineup_vign_start_hendricks_only");
	level struct::delete_script_bundle("scene", "cin_ven_03_20_storelineup_vign_move1");
	level struct::delete_script_bundle("scene", "cin_ven_03_20_storelineup_vign_move2");
	level struct::delete_script_bundle("scene", "cin_ven_03_20_storelineup_vign_move3");
	level struct::delete_script_bundle("scene", "cin_ven_03_20_storelineup_vign_fire");
	level struct::delete_script_bundle("scene", "cin_ven_03_20_storelineup_vign_loop");
	level struct::delete_script_bundle("scene", "cin_gen_f_floor_onfront_armdown_legstraight_deathpose_civ_sing");
	level struct::delete_script_bundle("scene", "cin_gen_m_floor_armup_legaskew_onfront_faceright_deathpose_civ_sing");
	level struct::delete_script_bundle("scene", "cin_gen_f_floor_onfront_armup_legstraight_deathpose_civ_sing");
	level struct::delete_script_bundle("scene", "cin_gen_f_floor_onleftside_armcurled_legcurled_deathpose_civ_sing");
	level struct::delete_script_bundle("scene", "cin_gen_m_wall_headonly_leanleft_deathpose_civ_sing");
	level struct::delete_script_bundle("scene", "cin_gen_m_floor_armstomach_onback_deathpose_civ_sing");
	level struct::delete_script_bundle("scene", "cin_gen_f_floor_onback_armup_legcurled_deathpose_civ_sing");
	level struct::delete_script_bundle("scene", "cin_gen_m_floor_armstretched_onrightside_deathpose_civ_sing");
	level struct::delete_script_bundle("scene", "cin_gen_m_armover_onrightside_deathpose_civ_sing");
	vengeance_util::function_4e8207e9("killing_streets", 0);
}

/*
	Name: cleanup_killing_streets
	Namespace: vengeance_killing_streets
	Checksum: 0x34D26997
	Offset: 0x4590
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function cleanup_killing_streets()
{
	array::thread_all(getentarray("killing_streets_lineup_patroller_spawners", "script_noteworthy"), &util::self_delete);
	array::thread_all(getentarray("killing_streets_robots", "targetname"), &util::self_delete);
	exploder::exploder_stop("killing_streets_butcher_fx");
	level notify(#"hash_85ae1ef3");
	wait(0.05);
	level notify(#"hash_92bd0e81");
}

/*
	Name: function_ef12791
	Namespace: vengeance_killing_streets
	Checksum: 0xC7544B2B
	Offset: 0x4660
	Size: 0x2E4
	Parameters: 0
	Flags: Linked
*/
function function_ef12791()
{
	level waittill(#"hash_2b5b2f5d");
	var_655205bf = struct::get("dogleg_1_intro_goto_obj_org", "targetname");
	objectives::show("cp_level_vengeance_go_to_safehouse");
	objectives::set("cp_waypoint_breadcrumb", var_655205bf);
	dogleg_1_intro_trigger = getent("dogleg_1_intro_trigger", "script_noteworthy");
	dogleg_1_intro_trigger triggerenable(0);
	level thread util::set_streamer_hint(3);
	msg = level util::waittill_any_return("dogleg_1_intro_goto_trigger_touched", "stealth_discovered");
	if(msg == "stealth_discovered")
	{
		objectives::hide("cp_waypoint_breadcrumb");
		if(level flag::get("stealth_discovered"))
		{
			level flag::wait_till_clear("stealth_discovered");
		}
		objectives::show("cp_waypoint_breadcrumb");
		level flag::wait_till("dogleg_1_intro_goto_trigger_touched");
	}
	objectives::complete("cp_waypoint_breadcrumb", var_655205bf);
	objectives::hide("cp_level_vengeance_go_to_safehouse");
	dogleg_1_intro_trigger triggerenable(1);
	e_door_use_object = util::init_interactive_gameobject(dogleg_1_intro_trigger, &"cp_prompt_enter_ven_door", &"CP_MI_SING_VENGEANCE_HINT_OPEN", &function_88762207);
	objectives::set("cp_level_vengeance_open_dogleg_1_menu");
	level thread vengeance_util::stealth_combat_toggle_trigger_and_objective(dogleg_1_intro_trigger, undefined, "cp_level_vengeance_open_dogleg_1_menu", "start_dogleg_1_intro", undefined, e_door_use_object);
	level waittill(#"hash_f1a04aa0");
	e_door_use_object gameobjects::disable_object();
	objectives::hide("cp_level_vengeance_open_dogleg_1_menu");
	wait(0.1);
	skipto::objective_completed("killing_streets");
}

/*
	Name: function_88762207
	Namespace: vengeance_killing_streets
	Checksum: 0x1F36A5DB
	Offset: 0x4950
	Size: 0x28
	Parameters: 1
	Flags: Linked
*/
function function_88762207(e_player)
{
	level notify(#"hash_f1a04aa0");
	level.var_4c62d05f = e_player;
}

/*
	Name: function_4b7aea65
	Namespace: vengeance_killing_streets
	Checksum: 0x2AB140DE
	Offset: 0x4980
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function function_4b7aea65()
{
	wait(0.05);
	level.var_29304913 = struct::get("killing_streets_breadcrumb_01");
	objectives::set("cp_waypoint_breadcrumb", level.var_29304913);
	level flag::wait_till("move_killing_streets_hendricks_node_05");
	objectives::complete("cp_waypoint_breadcrumb", level.var_29304913);
	level flag::wait_till("start_hendricks_open_alley_door_01");
	level thread function_ff499dd5();
	level flag::wait_till("hendricks_cleared_meat_market_door");
	if(!flag::get("clear_killing_streets_breadcrumb_06"))
	{
		level.var_29304913 = struct::get("killing_streets_breadcrumb_06");
		objectives::set("cp_waypoint_breadcrumb", level.var_29304913);
		level flag::wait_till("clear_killing_streets_breadcrumb_06");
		objectives::complete("cp_waypoint_breadcrumb", level.var_29304913);
	}
}

/*
	Name: function_ff499dd5
	Namespace: vengeance_killing_streets
	Checksum: 0x7300E20B
	Offset: 0x4B08
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_ff499dd5()
{
	level endon(#"start_hendricks_open_alley_door_02");
	wait(20);
	if(!flag::get("clear_killing_streets_breadcrumb_04"))
	{
		level.var_29304913 = struct::get("killing_streets_breadcrumb_04");
		objectives::set("cp_waypoint_breadcrumb", level.var_29304913);
		level flag::wait_till("clear_killing_streets_breadcrumb_04");
		objectives::complete("cp_waypoint_breadcrumb", level.var_29304913);
	}
}

/*
	Name: function_71a7056
	Namespace: vengeance_killing_streets
	Checksum: 0xF0BB287B
	Offset: 0x4BC0
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function function_71a7056()
{
	level flag::wait_till("start_killing_streets_sniper_shoots_civilian");
	wait(1.5);
	level.ai_hendricks vengeance_util::function_5fbec645("hend_shit_weapons_ready_0");
	if(!level flag::get("move_killing_streets_hendricks_node_15"))
	{
		level flag::wait_till("move_killing_streets_hendricks_node_15");
		level.ai_hendricks vengeance_util::function_5fbec645("hend_contact_1");
	}
	level flag::wait_till_any(array("stealth_alert", "stealth_combat", "killing_streets_intro_patroller_spawners_cleared", "cin_ven_03_15_killingstreets_vign_done", "hendricks_break_ally_stealth"));
	level.ai_hendricks vengeance_util::function_5fbec645("hend_weapons_free_0");
	wait(0.5);
	level.ai_hendricks battlechatter::function_d9f49fba(1);
	level flag::wait_till("move_hendricks_to_meat_market");
	wait(1.75);
	level.ai_hendricks vengeance_util::function_5fbec645("hend_what_the_fuck_is_wro_0");
	wait(0.5);
	level.ai_hendricks vengeance_util::function_5fbec645("hend_no_mission_is_worth_0");
}

/*
	Name: function_999f0273
	Namespace: vengeance_killing_streets
	Checksum: 0xCE0761E
	Offset: 0x4D78
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_999f0273()
{
	level flag::wait_till("hendricks_says_stay_down");
	level.ai_hendricks vengeance_util::function_5fbec645("hend_stay_down_1");
}

/*
	Name: function_9f0122b9
	Namespace: vengeance_killing_streets
	Checksum: 0x6818BC25
	Offset: 0x4DC8
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function function_9f0122b9()
{
	foreach(player in level.activeplayers)
	{
		player clientfield::set_to_player("play_client_igc", 1);
	}
}

/*
	Name: function_28fa297f
	Namespace: vengeance_killing_streets
	Checksum: 0x13706C24
	Offset: 0x4E68
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_28fa297f()
{
	var_8c8bdeb5 = getent("lineup_kill_exit_door", "targetname");
	if(isdefined(var_8c8bdeb5))
	{
		var_8c8bdeb5 hide();
		var_8c8bdeb5 notsolid();
	}
	var_1e51cc5a = getent("lineup_kill_exit_door_clip", "targetname");
	if(isdefined(var_1e51cc5a))
	{
		var_1e51cc5a notsolid();
		wait(0.1);
		var_1e51cc5a connectpaths();
		level flag::wait_till("killing_streets_end");
		var_1e51cc5a solid();
		wait(0.1);
		var_1e51cc5a disconnectpaths();
	}
}

