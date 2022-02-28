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
#using scripts\cp\cp_mi_zurich_coalescence_zurich_plaza_battle;
#using scripts\cp\cp_mi_zurich_coalescence_zurich_sacrifice;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zurich_hq;

/*
	Name: skipto_main
	Namespace: zurich_hq
	Checksum: 0x37C96F76
	Offset: 0xF08
	Size: 0x474
	Parameters: 2
	Flags: Linked
*/
function skipto_main(str_objective, b_starting)
{
	level flag::init("hq_decon_deactivated");
	level flag::init("hq_locker_room_open");
	level flag::init("hq_lmg_robots_destroyed");
	spawner::add_spawn_function_group("hq_turrets", "script_noteworthy", &function_5268b119);
	spawner::add_spawn_function_group("hq_stairs_robots_spawn_manager_guy", "targetname", &function_b87db3a3);
	spawner::add_spawn_function_group("hq_lmg_robots", "script_noteworthy", &function_b6d67e55);
	spawner::add_spawn_function_group("hq_defend_robots_spawn_manager_guy", "targetname", &function_56de520f);
	spawner::add_spawn_function_group("hq_stairs_siegebot", "targetname", &function_3b671c19);
	spawner::add_spawn_function_group("hq_elevator_siegebot", "targetname", &function_e877afeb);
	if(b_starting)
	{
		load::function_73adcefc();
		zurich_util::init_kane(str_objective, 0);
		level thread function_44ee5cb7();
		scene::add_scene_func("p7_fxanim_cp_zurich_coalescence_tower_door_open_bundle", &zurich_util::function_162b9ea0, "init");
		level scene::init("p7_fxanim_cp_zurich_coalescence_tower_door_open_bundle");
		level clientfield::set("hq_amb", 1);
		load::function_a2995f22();
	}
	if(isdefined(level.bzm_zurichdialogue1_4callback))
	{
		level thread [[level.bzm_zurichdialogue1_4callback]]();
	}
	level thread namespace_67110270::function_ce97ecac();
	umbragate_set("hq_entrance_umbra_gate", 1);
	var_306008cd = zurich_util::function_b0dd51f4("hq_iff_override_robots", "script_string");
	level.ai_kane thread function_87324847();
	exploder::stop_exploder("streets_tower_wasp_swarm");
	level thread function_371b16ae();
	level thread function_f8e4b283();
	level thread function_c5e1700c();
	level thread zurich_util::function_2361541e("hq");
	level thread zurich_util::function_c049667c(1);
	level thread function_f05c4095();
	level thread function_4cf537aa();
	level thread function_9006ed1d();
	level thread function_68b74f29();
	level thread function_c198b862();
	savegame::checkpoint_save();
	level thread function_19d7c072();
	level thread function_51e389ee(b_starting);
	level function_457da6c2();
	skipto::objective_completed(str_objective);
}

/*
	Name: function_44ee5cb7
	Namespace: zurich_hq
	Checksum: 0x194AFD98
	Offset: 0x1388
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function function_44ee5cb7()
{
	level endon(#"game_ended");
	while(true)
	{
		wait(1);
		playsoundatposition("amb_troop_alarm", (-8326, 37739, 559));
	}
}

/*
	Name: skipto_done
	Namespace: zurich_hq
	Checksum: 0xEBB41828
	Offset: 0x13D8
	Size: 0x3C
	Parameters: 4
	Flags: Linked
*/
function skipto_done(str_objective, b_starting, b_direct, player)
{
	zurich_util::enable_surreal_ai_fx(0);
}

/*
	Name: function_68b74f29
	Namespace: zurich_hq
	Checksum: 0x67CCF0F7
	Offset: 0x1420
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_68b74f29()
{
	level.ai_kane thread function_2436a71e();
	level.ai_kane dialog::say("kane_this_is_the_heart_of_0", 1);
	level dialog::player_say("plyr_it_won_t_come_to_tha_0", 1);
	level flag::wait_till("flag_hq_security_room_clear");
	level.ai_kane dialog::say("kane_how_could_hendricks_0", 1);
	level dialog::player_say("plyr_i_don_t_think_there_0", 1);
}

/*
	Name: function_c198b862
	Namespace: zurich_hq
	Checksum: 0xD9F280B3
	Offset: 0x1508
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_c198b862()
{
	zurich_util::function_1b3dfa61("enter_facility_vo_struct_trig", undefined, 256);
	level dialog::player_say("plyr_it_s_just_like_in_si_0");
}

/*
	Name: function_2436a71e
	Namespace: zurich_hq
	Checksum: 0x5C5AF85F
	Offset: 0x1558
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_2436a71e()
{
	self lookatpos(struct::get("hq_kane_lookat_pos").origin);
	wait(4);
	self lookatpos();
}

/*
	Name: function_19d7c072
	Namespace: zurich_hq
	Checksum: 0xF1A96A55
	Offset: 0x15B0
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function function_19d7c072()
{
	var_e26726e5 = getent("hq_atrium_door_01", "targetname");
	var_e26726e5.v_start = var_e26726e5.origin;
	var_9a7f401d = getent("hq_atrium_door_02", "targetname");
	var_9a7f401d.v_start = var_9a7f401d.origin;
	e_door_clip = getent("hq_atrium_door_clip", "targetname");
	var_e26726e5 moveto(var_e26726e5.origin + vectorscale((0, 0, 1), 44), 0.5);
	var_9a7f401d moveto(var_9a7f401d.origin + (vectorscale((0, 0, -1), 44)), 0.5);
	var_9a7f401d waittill(#"movedone");
	e_door_clip notsolid();
	e_door_clip connectpaths();
	trigger::wait_till("hq_exit_zone_trig");
	var_e26726e5 moveto(var_e26726e5.v_start, 0.05);
	var_9a7f401d moveto(var_9a7f401d.v_start, 0.05);
	e_door_clip solid();
	e_door_clip disconnectpaths();
}

/*
	Name: function_f05c4095
	Namespace: zurich_hq
	Checksum: 0x2DED8329
	Offset: 0x17C8
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_f05c4095()
{
	level thread function_6c64938e();
	trigger::wait_till("trig_hq_robots_start");
	level thread namespace_67110270::function_232f4de7();
	spawn_manager::enable("hq_defend_robots_spawn_manager");
	spawn_manager::wait_till_complete("hq_stairs_robots_spawn_manager");
	level flag::wait_till("hq_lmg_robots_destroyed");
	spawn_manager::wait_till_cleared("hq_stairs_robots_spawn_manager");
	level flag::set("flag_hq_security_room_move_upstairs");
	spawn_manager::wait_till_cleared("hq_defend_robots_spawn_manager");
	level flag::set("flag_hq_security_room_clear");
	savegame::checkpoint_save();
}

/*
	Name: function_4cf537aa
	Namespace: zurich_hq
	Checksum: 0xCB2DFD0E
	Offset: 0x18F0
	Size: 0x224
	Parameters: 0
	Flags: Linked
*/
function function_4cf537aa()
{
	level flag::wait_till("flag_hq_siege_bot_encounter_start");
	spawn_manager::enable("hq_stairs_siegebot_spawn_manager");
	spawn_manager::wait_till_complete("hq_stairs_siegebot_spawn_manager");
	array::thread_all(spawn_manager::get_ai("hq_stairs_siegebot_spawn_manager"), &function_47e79f7);
	level flag::wait_till("flag_start_elevator_siege_bot");
	spawn_manager::enable("hq_elevator_siegebot_spawn_manager");
	spawn_manager::wait_till_complete("hq_elevator_siegebot_spawn_manager");
	level function_66b77465();
	array::thread_all(spawn_manager::get_ai("hq_elevator_siegebot_spawn_manager"), &function_47e79f7);
	spawn_manager::wait_till_cleared("hq_elevator_siegebot_spawn_manager");
	spawn_manager::wait_till_cleared("hq_stairs_siegebot_spawn_manager");
	savegame::checkpoint_save();
	spawn_manager::enable("hq_robots_lab_reinforcement_spawn_manager");
	level flag::set("flag_hq_siege_bot_dead");
	spawn_manager::wait_till_complete("hq_robots_lab_reinforcement_spawn_manager");
	level thread function_e6db4b20();
	spawn_manager::wait_till_cleared("hq_robots_lab_reinforcement_spawn_manager");
	level thread namespace_67110270::function_bb8ce831();
	level flag::set("flag_hq_move_to_airlock");
}

/*
	Name: function_457da6c2
	Namespace: zurich_hq
	Checksum: 0x57C0E88A
	Offset: 0x1B20
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function function_457da6c2()
{
	level flag::set("hq_locker_room_open");
	level thread function_2950b33d();
	trigger::wait_till("hq_exit_zone_trig");
	level waittill(#"hash_7871b80b");
}

/*
	Name: function_9006ed1d
	Namespace: zurich_hq
	Checksum: 0xB5644F1F
	Offset: 0x1B88
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_9006ed1d()
{
	array::thread_all(getentarray("trig_hq_break_glass", "targetname"), &function_187d0cba);
}

/*
	Name: function_187d0cba
	Namespace: zurich_hq
	Checksum: 0xDF62ED95
	Offset: 0x1BD8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_187d0cba()
{
	level endon(#"hash_13a0547d");
	self waittill(#"trigger", e_who);
	e_who util::break_glass(200);
}

/*
	Name: function_6c64938e
	Namespace: zurich_hq
	Checksum: 0x33F31C48
	Offset: 0x1C28
	Size: 0x182
	Parameters: 0
	Flags: Linked
*/
function function_6c64938e()
{
	trigger::wait_till("trig_hq_robots_start");
	for(i = 1; i < 3; i++)
	{
		var_6a2c8ee9 = getentarray("security_checkpoint_door_0" + i, "targetname");
		foreach(var_530f952d in var_6a2c8ee9)
		{
			if(isdefined(var_530f952d.target))
			{
				var_73c9db2b = struct::get(var_530f952d.target, "targetname");
				var_530f952d moveto(var_73c9db2b.origin, 1.5);
				var_530f952d thread function_eaedd1eb();
			}
		}
		wait(3);
	}
}

/*
	Name: function_eaedd1eb
	Namespace: zurich_hq
	Checksum: 0xC06FAAE6
	Offset: 0x1DB8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_eaedd1eb()
{
	trigger::wait_till("hq_exit_zone_trig");
	self delete();
}

/*
	Name: function_66b77465
	Namespace: zurich_hq
	Checksum: 0x5C2C9C5A
	Offset: 0x1DF8
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function function_66b77465()
{
	e_door = getent("siegebot_elevator_door", "targetname");
	e_door movez(140, 3);
	e_door playsound("evt_siegebot_elevator_door");
	e_door thread function_a8bf6ebc();
	e_door waittill(#"movedone");
	level notify(#"doors_open");
}

/*
	Name: function_a8bf6ebc
	Namespace: zurich_hq
	Checksum: 0x9028CE7F
	Offset: 0x1EA8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_a8bf6ebc()
{
	trigger::wait_till("hq_exit_zone_trig");
	self delete();
}

/*
	Name: function_51e389ee
	Namespace: zurich_hq
	Checksum: 0xDA3AF1BF
	Offset: 0x1EE8
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function function_51e389ee(b_starting)
{
	objectives::set("cp_level_zurich_apprehend_obj");
	objectives::breadcrumb("hq_security_approach_breadcrumb_trigger");
	level function_196e4f52();
	level flag::wait_till("flag_hq_siege_bot_dead");
	objectives::breadcrumb("hq_lab_exit_breadcrumb_trig");
	objectives::breadcrumb("hq_locker_room_breadcrumb_trig");
	objectives::breadcrumb("hq_decon_breadcrumb_trig");
	level flag::wait_till_all(array("flag_hq_set_sacrifice_obj", "sacrifice_kane_activation_ready"));
	objectives::hide("cp_level_zurich_apprehend_obj");
	objectives::set("cp_level_zurich_use_terminal_obj");
}

/*
	Name: function_196e4f52
	Namespace: zurich_hq
	Checksum: 0x99F29EAC
	Offset: 0x2010
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_196e4f52()
{
	level endon(#"hash_ad88abee");
	level flag::wait_till("flag_hq_security_room_move_upstairs");
	objectives::breadcrumb("hq_lab_approach_breadcrumb_trig");
}

/*
	Name: function_47e79f7
	Namespace: zurich_hq
	Checksum: 0xB50330FF
	Offset: 0x2060
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_47e79f7()
{
	objectives::hide("cp_level_zurich_apprehend_obj");
	objectives::set("cp_level_zurich_destroy_pawws_obj", self);
	objectives::set("cp_level_zurich_low_destroy", self);
	self waittill(#"death");
	objectives::hide_for_target("cp_level_zurich_destroy_pawws_obj", self);
	objectives::complete("cp_level_zurich_low_destroy", self);
	objectives::show("cp_level_zurich_apprehend_obj");
}

/*
	Name: function_c5e1700c
	Namespace: zurich_hq
	Checksum: 0x884BF8A6
	Offset: 0x2110
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_c5e1700c()
{
	getent("trig_zurich_hq_door_hack", "targetname") setcursorhint("HINT_NOICON");
}

/*
	Name: function_e2ca7f8f
	Namespace: zurich_hq
	Checksum: 0x525ADF50
	Offset: 0x2158
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function function_e2ca7f8f()
{
	var_5cca3f31 = getent("trig_zurich_hq_door_hack", "targetname");
	var_5cca3f31 zurich_util::function_d1996775();
	level function_e6db4b20();
	level flag::set("flag_hq_hack_door_open");
}

/*
	Name: function_e6db4b20
	Namespace: zurich_hq
	Checksum: 0x184D3819
	Offset: 0x21E0
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function function_e6db4b20()
{
	mdl_door = getent("hq_siegebot_exitdoor", "targetname");
	mdl_door.v_start = mdl_door.origin;
	mdl_door.v_end = mdl_door.origin + vectorscale((0, 0, 1), 128);
	n_open_time = 2;
	mdl_door playsound("evt_decon_door_open");
	mdl_door moveto(mdl_door.v_end, n_open_time);
	mdl_door thread function_45d5a571();
	wait(n_open_time / 2);
}

/*
	Name: function_45d5a571
	Namespace: zurich_hq
	Checksum: 0x492AD9D1
	Offset: 0x22D8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_45d5a571()
{
	trigger::wait_till("hq_exit_zone_trig");
	self delete();
}

/*
	Name: function_2950b33d
	Namespace: zurich_hq
	Checksum: 0x96D88223
	Offset: 0x2318
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_2950b33d()
{
	level thread function_ae937789();
	level flag::wait_till("hq_decon_active");
	level clientfield::set("decon_spray", 1);
	wait(12);
	level function_3319c9ae();
	level flag::set("flag_decon_door_open");
	level clientfield::set("decon_spray", 0);
	level zurich_sacrifice::function_d3eae9b7();
}

/*
	Name: function_ae937789
	Namespace: zurich_hq
	Checksum: 0x34360400
	Offset: 0x23F0
	Size: 0x16A
	Parameters: 0
	Flags: Linked
*/
function function_ae937789()
{
	mdl_door = getent("hq_decon_door_entrance", "targetname");
	e_clip = getent("hq_decon_door_entrance_clip", "targetname");
	e_clip notsolid();
	level flag::wait_till("hq_decon_active");
	e_clip solid();
	mdl_door movez(-86, 2);
	mdl_door playsound("evt_decon_door_close");
	wait(2);
	spawn_manager::kill("hq_stairs_robots_spawn_manager", 1);
	a_ai_enemies = getaiteamarray();
	array::thread_all(a_ai_enemies, &zurich_util::function_48463818);
	level notify(#"hash_7871b80b");
}

/*
	Name: function_3319c9ae
	Namespace: zurich_hq
	Checksum: 0x7563F763
	Offset: 0x2568
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_3319c9ae()
{
	mdl_door = getent("hq_decon_door", "targetname");
	mdl_door.v_start = mdl_door.origin;
	mdl_door.v_end = mdl_door.origin + vectorscale((0, 0, 1), 128);
	n_open_time = 2;
	mdl_door playsound("evt_decon_door_open");
	mdl_door moveto(mdl_door.v_end, n_open_time);
}

/*
	Name: function_b52a0060
	Namespace: zurich_hq
	Checksum: 0x4B98673C
	Offset: 0x2640
	Size: 0x74
	Parameters: 0
	Flags: None
*/
function function_b52a0060()
{
	mdl_door = getent("hq_decon_door", "targetname");
	mdl_door playsound("evt_decon_door_close");
	mdl_door moveto(mdl_door.v_start, 0.5);
}

/*
	Name: function_8cb99e45
	Namespace: zurich_hq
	Checksum: 0xAE950EAF
	Offset: 0x26C0
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_8cb99e45()
{
	var_107d713c = getent("hq_decon_door", "targetname");
	var_2049505e = getent("hq_decon_door_entrance", "targetname");
	e_clip = getent("hq_decon_door_entrance_clip", "targetname");
	var_107d713c delete();
	var_2049505e delete();
	e_clip delete();
}

/*
	Name: function_b87db3a3
	Namespace: zurich_hq
	Checksum: 0x680ADA65
	Offset: 0x27A0
	Size: 0xB6
	Parameters: 0
	Flags: Linked
*/
function function_b87db3a3()
{
	self endon(#"death");
	self endon(#"hash_63f76929");
	self thread function_ee7e8dd7();
	if(isdefined(self.script_noteworthy))
	{
		for(i = 1; i < 3; i++)
		{
			if(self.script_noteworthy == ("security_robot_0" + i))
			{
				self waittill(#"goal");
				self ai::set_goal("security_room_attack_node_0" + i, "targetname");
			}
		}
	}
}

/*
	Name: function_b6d67e55
	Namespace: zurich_hq
	Checksum: 0xE5B109B4
	Offset: 0x2860
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_b6d67e55()
{
	if(!isdefined(level.var_64f4feb8))
	{
		level.var_64f4feb8 = 0;
	}
	self waittill(#"death");
	level.var_64f4feb8++;
	if(level.var_64f4feb8 == 2)
	{
		level flag::set("hq_lmg_robots_destroyed");
	}
}

/*
	Name: function_56de520f
	Namespace: zurich_hq
	Checksum: 0xB2F39724
	Offset: 0x28C8
	Size: 0xBE
	Parameters: 0
	Flags: Linked
*/
function function_56de520f()
{
	self endon(#"death");
	self endon(#"hash_63f76929");
	self thread function_ee7e8dd7();
	if(isdefined(self.script_noteworthy))
	{
		for(i = 1; i < 3; i++)
		{
			if(self.script_noteworthy == ("security_defend_robot_0" + i))
			{
				level flag::wait_till("flag_hq_security_room_move_upstairs");
				self ai::set_goal("security_room_defend_node_0" + i, "script_noteworthy");
			}
		}
	}
}

/*
	Name: function_ee7e8dd7
	Namespace: zurich_hq
	Checksum: 0xD6A788AB
	Offset: 0x2990
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_ee7e8dd7()
{
	self endon(#"death");
	trigger::wait_till("trig_move_to_lab");
	self notify(#"hash_63f76929");
	self ai::set_goal("hq_lab_defend_volume", "targetname");
}

/*
	Name: function_3b671c19
	Namespace: zurich_hq
	Checksum: 0x452DFFAC
	Offset: 0x29F0
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_3b671c19()
{
	level endon(#"hash_ae9347d9");
	if(level.players.size < 3)
	{
		n_health_threshold = self.health / 2;
		while(self.health > n_health_threshold)
		{
			wait(1);
		}
	}
	else
	{
		self waittill(#"death");
	}
	level flag::set("flag_start_elevator_siege_bot");
}

/*
	Name: function_e877afeb
	Namespace: zurich_hq
	Checksum: 0x494C013F
	Offset: 0x2A88
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_e877afeb()
{
	self ai::set_ignoreall(1);
	self ai::set_ignoreme(1);
	self scene::init("cin_zur_02_001_siegebot_elevator_entrance", self);
	level waittill(#"doors_open");
	self scene::play("cin_zur_02_001_siegebot_elevator_entrance", self);
	self ai::set_ignoreall(0);
	self ai::set_ignoreme(0);
}

/*
	Name: function_5268b119
	Namespace: zurich_hq
	Checksum: 0xD6F45F5E
	Offset: 0x2B40
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_5268b119()
{
	self thread turret_deactivate();
}

/*
	Name: turret_deactivate
	Namespace: zurich_hq
	Checksum: 0x332C6C6B
	Offset: 0x2B68
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function turret_deactivate()
{
	self ai::set_ignoreall(1);
	self cybercom::cybercom_aioptout("cybercom_hijack");
}

/*
	Name: turret_activate
	Namespace: zurich_hq
	Checksum: 0x8C4282CF
	Offset: 0x2BB0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function turret_activate()
{
	self ai::set_ignoreall(0);
	self cybercom::cybercom_aiclearoptout("cybercom_hijack");
}

/*
	Name: spawn_turrets
	Namespace: zurich_hq
	Checksum: 0x5C7D45AB
	Offset: 0x2BF8
	Size: 0x10E
	Parameters: 0
	Flags: None
*/
function spawn_turrets()
{
	var_f765f588 = self;
	if(!isarray(self))
	{
		var_f765f588 = array(self);
	}
	a_vh_turrets = [];
	foreach(n_index, sp_turret in var_f765f588)
	{
		a_vh_turrets[n_index] = spawner::simple_spawn_single(sp_turret);
		a_vh_turrets[n_index] thread turret_think();
		wait(0.05);
	}
	return a_vh_turrets;
}

/*
	Name: turret_think
	Namespace: zurich_hq
	Checksum: 0x2D2D980
	Offset: 0x2D10
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function turret_think()
{
	self endon(#"death");
	n_min = 0.3;
	n_max = 1.3;
	var_39178da3 = randomfloatrange(n_min, n_max);
	n_move_time = 2;
	self.var_61ba68c8 = util::spawn_model("tag_origin", self.origin, self.angles);
	self.var_61ba68c8.script_objective = self.script_objective;
	s_moveto = struct::get(self.target);
	self linkto(self.var_61ba68c8, "tag_origin");
	self.var_61ba68c8 moveto(s_moveto.origin, n_move_time);
	self.var_61ba68c8 waittill(#"movedone");
	wait(var_39178da3);
	self turret_activate();
}

/*
	Name: function_525e4268
	Namespace: zurich_hq
	Checksum: 0x92BD22AC
	Offset: 0x2E78
	Size: 0x11A
	Parameters: 0
	Flags: None
*/
function function_525e4268()
{
	a_vh_turrets = self;
	if(!isarray(self))
	{
		a_vh_turrets = array(self);
	}
	foreach(vh_turret in self)
	{
		if(isalive(vh_turret))
		{
			vh_turret.delete_on_death = 1;
			vh_turret notify(#"death");
			if(!isalive(vh_turret))
			{
				vh_turret delete();
			}
		}
	}
}

/*
	Name: function_87324847
	Namespace: zurich_hq
	Checksum: 0x5FFF067C
	Offset: 0x2FA0
	Size: 0x2FC
	Parameters: 0
	Flags: Linked
*/
function function_87324847()
{
	self thread function_f3b250de();
	self ai::set_behavior_attribute("forceTacticalWalk", 1);
	self setgoalnode(getnode("plaza_battle_kane_lobby_node", "targetname"));
	wait(3);
	self colors::set_force_color("r");
	trigger::use("trig_color_kane_hq_start");
	level flag::wait_till("flag_hq_kane_enter_security_room");
	self ai::set_behavior_attribute("forceTacticalWalk", 0);
	trigger::use("trig_color_kane_hq_lobby");
	level flag::wait_till("flag_hq_robots_start");
	trigger::use("trig_color_kane_hq_lobby_fight");
	level function_ee4479b3();
	level flag::wait_till_any(array("flag_hq_security_room_clear", "flag_hq_passed_turrets"));
	trigger::use("trig_color_kane_hq_siege_bot_fight");
	level flag::wait_till("flag_hq_siege_bot_dead");
	trigger::use("trig_color_kane_hq_siege_bot_fight_done");
	level flag::wait_till_any(array("flag_hq_move_to_airlock", "flag_hq_move_kane_to_locker_room"));
	trigger::use("trig_color_kane_hq_door_hack");
	self battlechatter::function_d9f49fba(0);
	if(level flag::get("flag_hq_move_kane_to_locker_room"))
	{
		wait(1);
	}
	else
	{
		level flag::wait_till("flag_hq_move_kane_to_locker_room");
	}
	trigger::use("trig_color_kane_hq_decon");
	level flag::wait_till("flag_hq_move_kane_into_decon");
	trigger::use("trig_color_kane_hq_in_decon");
	level flag::wait_till("flag_decon_door_open");
	trigger::use("trig_color_kane_lab_interior");
}

/*
	Name: function_ee4479b3
	Namespace: zurich_hq
	Checksum: 0x89A84EA5
	Offset: 0x32A8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_ee4479b3()
{
	level endon(#"hash_ad88abee");
	level endon(#"hash_f95b7888");
	level flag::wait_till("flag_hq_security_room_move_upstairs");
	trigger::use("trig_color_kane_hq_security_room_upstairs");
}

/*
	Name: function_f3b250de
	Namespace: zurich_hq
	Checksum: 0x3A74B1CF
	Offset: 0x3300
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_f3b250de()
{
	level flag::wait_till("flag_hq_set_kane_ignoreall");
	self ai::set_ignoreall(1);
	self ai::set_ignoreme(1);
}

/*
	Name: function_371b16ae
	Namespace: zurich_hq
	Checksum: 0x4FCF3DB4
	Offset: 0x3360
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_371b16ae()
{
	zurich_util::function_1b3dfa61("hq_start_ravens_struct_trig", undefined, 600, 512);
	playsoundatposition("mus_coalescence_theme_lobby", (-8698, 38395, 594));
}

/*
	Name: function_f8e4b283
	Namespace: zurich_hq
	Checksum: 0x5CC79A3A
	Offset: 0x33B8
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_f8e4b283()
{
	level scene::add_scene_func("cin_gen_ambient_raven_idle_eating_raven", &zurich_util::function_e547724d, "init");
	level scene::add_scene_func("cin_gen_ambient_raven_idle", &zurich_util::function_e547724d, "init");
	level scene::add_scene_func("cin_gen_traversal_raven_fly_away", &zurich_util::function_86b1cd8a);
	level thread function_762c95f0("hq_start_ravens", 600, 512);
	level thread function_762c95f0("hq_locker_room_ravens", 466, 128);
	level thread function_6e7da34e();
}

/*
	Name: function_762c95f0
	Namespace: zurich_hq
	Checksum: 0xA637EFA6
	Offset: 0x34B8
	Size: 0x28A
	Parameters: 3
	Flags: Linked
*/
function function_762c95f0(var_af782668, var_4d9cdec3, var_9895c1a4)
{
	zurich_util::function_1b3dfa61(var_af782668 + "_struct_trig", undefined, var_4d9cdec3, var_9895c1a4);
	a_scenes = struct::get_array(var_af782668);
	foreach(s_scene in a_scenes)
	{
		s_scene util::delay(randomfloat(0.15), undefined, &scene::play);
	}
	wait(0.5);
	array::thread_all(level.players, &clientfield::increment_to_player, "postfx_hallucinations", 1);
	wait(0.5);
	foreach(player in level.players)
	{
		visionset_mgr::activate("visionset", "cp_zurich_hallucination", player);
	}
	wait(1.8);
	foreach(player in level.players)
	{
		visionset_mgr::deactivate("visionset", "cp_zurich_hallucination", player);
	}
}

/*
	Name: function_6e7da34e
	Namespace: zurich_hq
	Checksum: 0xEC60EBBA
	Offset: 0x3750
	Size: 0x314
	Parameters: 0
	Flags: Linked
*/
function function_6e7da34e()
{
	a_scenes = struct::get_array("hq_airlock_ravens");
	array::thread_all(a_scenes, &scene::init);
	level flag::wait_till("hq_decon_active");
	wait(7);
	array::thread_all(level.players, &clientfield::increment_to_player, "postfx_hallucinations", 1);
	wait(0.8);
	foreach(player in level.players)
	{
		visionset_mgr::activate("visionset", "cp_zurich_hallucination", player);
	}
	level notify(#"hash_755edaa4");
	foreach(s_scene in a_scenes)
	{
		s_scene util::delay(randomfloat(1), undefined, &scene::play);
	}
	level flag::wait_till("flag_decon_door_open");
	array::thread_all(level.players, &clientfield::increment_to_player, "postfx_hallucinations", 1);
	wait(0.8);
	foreach(player in level.players)
	{
		visionset_mgr::deactivate("visionset", "cp_zurich_hallucination", player);
	}
	wait(0.5);
	array::thread_all(a_scenes, &scene::stop);
}

