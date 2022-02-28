// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_sentinel_drone;
#using scripts\zm\_zm_ai_raz;
#using scripts\zm\_zm_ai_sentinel_drone;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_stalingrad_dragon;
#using scripts\zm\zm_stalingrad_drop_pods;
#using scripts\zm\zm_stalingrad_pap_quest;
#using scripts\zm\zm_stalingrad_timer;
#using scripts\zm\zm_stalingrad_util;
#using scripts\zm\zm_stalingrad_vo;

#namespace zm_stalingrad_ee_main;

/*
	Name: __init__sytem__
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xFDE696E1
	Offset: 0x27E0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_ee_main", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x5ADFBA35
	Offset: 0x2828
	Size: 0x554
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "ee_anomaly_hit", 12000, 1, "counter");
	clientfield::register("scriptmover", "ee_anomaly_loop", 12000, 1, "int");
	clientfield::register("scriptmover", "ee_cargo_explosion", 12000, 1, "int");
	clientfield::register("vehicle", "ee_drone_cam_override", 12000, 1, "int");
	clientfield::register("scriptmover", "ee_generator_kill", 12000, 1, "int");
	clientfield::register("scriptmover", "ee_generator_target", 12000, 1, "int");
	clientfield::register("scriptmover", "ee_koth_light_1", 12000, 2, "int");
	clientfield::register("scriptmover", "ee_koth_light_2", 12000, 2, "int");
	clientfield::register("scriptmover", "ee_koth_light_3", 12000, 2, "int");
	clientfield::register("scriptmover", "ee_koth_light_4", 12000, 2, "int");
	clientfield::register("toplayer", "ee_lockdown_fog", 12000, 1, "int");
	clientfield::register("actor", "ee_raz_eye_override", 12000, 1, "int");
	clientfield::register("scriptmover", "ee_sewer_switch", 12000, 1, "int");
	clientfield::register("world", "ee_eye_beam_rumble", 12000, 1, "int");
	clientfield::register("toplayer", "ee_hatch_strain_rumble", 12000, 1, "int");
	clientfield::register("scriptmover", "ee_hatch_break_rumble", 12000, 1, "int");
	clientfield::register("scriptmover", "ee_safe_smash_rumble", 12000, 1, "int");
	clientfield::register("scriptmover", "ee_timed_explosion_rumble", 12000, 1, "counter");
	clientfield::register("scriptmover", "post_outro_smoke", 12000, 1, "int");
	level flag::init("generator_charged");
	level flag::init("generator_on");
	level flag::init("tube_puzzle_complete");
	level flag::init("ee_cylinder_acquired");
	level flag::init("key_placement");
	level flag::init("keys_placed");
	level flag::init("scenario_active");
	level flag::init("ee_cargo_available");
	level flag::init("ee_lockdown_complete");
	level flag::init("scenarios_complete");
	level flag::init("weapon_cores_delivered");
	level flag::init("sophia_escaped");
	level flag::init("players_in_arena");
	level flag::init("ee_round");
}

/*
	Name: __main__
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x762FE39C
	Offset: 0x2D88
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	/#
		if(getdvarint("") > 0)
		{
			level thread function_d6026710();
		}
		level scene::add_scene_func("", &function_7e02b332, "", 0);
		level scene::add_scene_func("", &function_7e02b332, "", 1);
	#/
	array::add(level.wait_for_streamer_hint_scenes, "cin_sta_outro_3rd_sh020", 0);
	level thread function_c5f1b67();
	level thread function_7cde9a31();
	level thread function_999a19a7();
	level thread function_9bab94c2();
	level thread function_8d296a92();
	level thread function_72dd3113();
	level thread function_914bd2ef();
	level thread function_e0c4c3a8();
	level thread function_d47c68fb();
}

/*
	Name: function_c5f1b67
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x60BFF14F
	Offset: 0x2F30
	Size: 0x40C
	Parameters: 0
	Flags: Linked
*/
function function_c5f1b67()
{
	var_1a085458 = getentarray("hatch_slick_clip", "targetname");
	array::run_all(var_1a085458, &notsolid);
	var_cf5f1519 = getent("ee_map", "targetname");
	var_cf5f1519 hidepart("tag_map_screen_on");
	var_cf5f1519 hidepart("tag_map_screen_glow_text");
	var_cf5f1519 hidepart("tag_map_screen_glow_command");
	var_cf5f1519 hidepart("tag_map_screen_glow_barracks");
	var_cf5f1519 hidepart("tag_map_screen_glow_tank");
	var_cf5f1519 hidepart("tag_map_screen_glow_armory");
	var_cf5f1519 hidepart("tag_map_screen_glow_store");
	var_cf5f1519 hidepart("tag_map_screen_glow_supply");
	var_cf5f1519 hidepart("tag_map_screen_glow_square");
	var_78d02c88 = getent("ee_map_shelf", "targetname");
	var_78d02c88 hidepart("wall_map_shelf_button_green");
	var_78d02c88 hidepart("wall_map_shelf_figure_01");
	var_78d02c88 hidepart("wall_map_shelf_figure_02");
	var_78d02c88 hidepart("wall_map_shelf_figure_03");
	var_78d02c88 hidepart("wall_map_shelf_figure_04");
	var_78d02c88 hidepart("wall_map_shelf_figure_05");
	var_78d02c88 hidepart("wall_map_shelf_figure_06");
	var_dc6bf246 = getent("ee_koth_terminal", "targetname");
	var_dc6bf246 function_9906da8b(0);
	var_dc6bf246 hidepart("tag_dragon_network_console_terminal_light_green_01");
	var_dc6bf246 hidepart("tag_dragon_network_console_terminal_light_green_02");
	var_dc6bf246 hidepart("tag_dragon_network_console_terminal_light_green_03");
	var_dc6bf246 hidepart("tag_dragon_network_console_terminal_light_green_04");
	while(!isdefined(level.var_a090a655))
	{
		wait(2);
		level.var_a090a655 = getent("computer_sophia", "targetname");
	}
	level.var_a090a655 hidepart("slot_decoder_jnt");
	level.var_a090a655 hidepart("button_green_jnt");
	level.var_a090a655 scene::init("p7_fxanim_zm_stal_computer_sophia_code_door_open_bundle");
}

/*
	Name: function_7cde9a31
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x89B698E0
	Offset: 0x3348
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_7cde9a31()
{
	level flag::wait_till("power_on");
	exploder::exploder("fxexp_604");
	var_cf5f1519 = getent("ee_map", "targetname");
	var_cf5f1519 showpart("tag_map_screen_on");
	level waittill(#"hash_423907c1");
	level thread function_b81d4eec();
	level thread function_3bd05213();
}

/*
	Name: function_b81d4eec
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xEF18BDCC
	Offset: 0x3410
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_b81d4eec()
{
	/#
		level endon(#"hash_72a2fa02");
		level endon(#"hash_7f7ecb53");
		level endon(#"hash_dae10c73");
	#/
	level endon(#"ee_cylinder_acquired");
	level function_fa7fbd4c(1);
	var_2200eb08 = struct::get("ee_sophia_struct", "targetname");
	e_player = var_2200eb08 function_6e3a6092(100, "", 0);
	e_player thread zm_stalingrad_vo::function_1f1e411c();
	level function_fa7fbd4c(0);
}

/*
	Name: function_3bd05213
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x44C9DA32
	Offset: 0x34F0
	Size: 0x66
	Parameters: 0
	Flags: Linked
*/
function function_3bd05213()
{
	/#
		level endon(#"hash_72a2fa02");
		level endon(#"hash_7f7ecb53");
		level endon(#"hash_dae10c73");
	#/
	level.var_2de93bbe = 1;
	level waittill(#"player_exited_sewer");
	wait(10);
	level zm_stalingrad_vo::function_19d97b43();
	level.var_2de93bbe = undefined;
}

/*
	Name: function_cbc0e672
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x9CC784B0
	Offset: 0x3560
	Size: 0x46
	Parameters: 3
	Flags: Linked
*/
function function_cbc0e672(str_vo_line, n_delay, str_notify)
{
	self zm_stalingrad_vo::function_e4acaa37(str_vo_line, n_delay);
	level notify(str_notify);
}

/*
	Name: function_dbdd2358
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xEE9F02F7
	Offset: 0x35B0
	Size: 0x120
	Parameters: 0
	Flags: Linked
*/
function function_dbdd2358()
{
	/#
		level endon(#"hash_72a2fa02");
		level endon(#"hash_7f7ecb53");
		level endon(#"hash_dae10c73");
	#/
	level endon(#"keys_placed");
	var_1f76714 = [];
	for(i = 0; i < 5; i++)
	{
		var_1f76714[i] = "vox_soph_general_misc_" + i;
	}
	for(n_current_line = 0; n_current_line < 5; n_current_line++)
	{
		wait(50);
		level function_9c8afe2b();
		str_notify = "sophia_general_complete";
		level.var_a090a655 thread function_cbc0e672(var_1f76714[n_current_line], 1, str_notify);
		level waittill(str_notify);
	}
}

/*
	Name: function_851880c
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xD7699082
	Offset: 0x36D8
	Size: 0x170
	Parameters: 0
	Flags: Linked
*/
function function_851880c()
{
	/#
		level endon(#"hash_7f7ecb53");
		level endon(#"hash_dae10c73");
	#/
	level endon(#"hash_8df52d90");
	var_f5badf05 = [];
	for(i = 0; i < 9; i++)
	{
		var_f5badf05[i] = "vox_soph_sophia_observes_" + i;
	}
	var_5dac1aa3 = 0;
	while(var_5dac1aa3 < 9)
	{
		wait(50);
		while(level flag::get("scenario_active"))
		{
			level flag::wait_till_clear("scenario_active");
			wait(20);
		}
		level function_9c8afe2b();
		if(var_5dac1aa3 < 9)
		{
			str_notify = "sophia_observation_complete";
			level.var_a090a655 thread function_cbc0e672(var_f5badf05[var_5dac1aa3], 1, str_notify);
			level waittill(str_notify);
			var_5dac1aa3++;
		}
	}
}

/*
	Name: function_811523a8
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xACCC8C0E
	Offset: 0x3850
	Size: 0x1A8
	Parameters: 0
	Flags: Linked
*/
function function_811523a8()
{
	/#
		level endon(#"hash_7f7ecb53");
		level endon(#"hash_dae10c73");
	#/
	level endon(#"scenarios_complete");
	level waittill(#"hash_8df52d90");
	var_68a6b7a1 = [];
	for(i = 0; i < 6; i++)
	{
		var_68a6b7a1[i] = "vox_soph_richtofen_trust_" + i;
	}
	var_983c388b = 0;
	while(var_983c388b < 6)
	{
		wait(50);
		while(level flag::get("scenario_active"))
		{
			level flag::wait_till_clear("scenario_active");
			wait(20);
		}
		level function_eaf82313();
		if(var_983c388b < 6 && function_8d6e71cf() && math::cointoss())
		{
			str_notify = "sophia_trust_complete";
			level.var_a090a655 thread function_cbc0e672(var_68a6b7a1[var_983c388b], 1, str_notify);
			level waittill(str_notify);
			var_983c388b++;
		}
	}
}

/*
	Name: function_8d6e71cf
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x476B0577
	Offset: 0x3A00
	Size: 0xE6
	Parameters: 0
	Flags: Linked
*/
function function_8d6e71cf()
{
	if(!(isdefined(level.has_richtofen) && level.has_richtofen))
	{
		return true;
	}
	foreach(e_player in level.activeplayers)
	{
		if(e_player.characterindex == 2 && zm_utility::is_player_valid(e_player) && !zm_stalingrad_util::function_86b1188c(1000, e_player, level.var_a090a655))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_4b5f4145
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xAB3F6B9D
	Offset: 0x3AF0
	Size: 0x120
	Parameters: 0
	Flags: Linked
*/
function function_4b5f4145()
{
	/#
		level endon(#"hash_dae10c73");
	#/
	level endon(#"weapon_cores_delivered");
	var_1f76714 = array::randomize(array("vox_soph_sophia_chatter_0", "vox_soph_sophia_chatter_1", "vox_soph_sophia_chatter_2", "vox_soph_sophia_chatter_3", "vox_soph_sophia_chatter_4", "vox_soph_sophia_chatter_5"));
	for(n_current_line = 0; n_current_line < 6; n_current_line++)
	{
		wait(50);
		level function_9c8afe2b();
		str_notify = "sophia_preparations_complete";
		level.var_a090a655 thread function_cbc0e672(var_1f76714[n_current_line], 1, str_notify);
		level waittill(str_notify);
	}
}

/*
	Name: function_957ac17d
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xA4560C79
	Offset: 0x3C18
	Size: 0x178
	Parameters: 0
	Flags: Linked
*/
function function_957ac17d()
{
	/#
		level endon(#"hash_dae10c73");
	#/
	level endon(#"weapon_cores_delivered");
	var_1f76714 = array("vox_soph_help_nikolai_sophia_attempt_1_0", "vox_soph_help_nikolai_sophia_attempt_2_0", "vox_soph_help_nikolai_sophia_attempt_3_0", "vox_soph_help_nikolai_sophia_attempt_4_0", "vox_soph_help_nikolai_sophia_attempt_5_0", "vox_soph_help_nikolai_sophia_attempt_6_0");
	n_current_line = 0;
	var_af8a18df = struct::get("ee_sophia_struct", "targetname");
	while(n_current_line < 6)
	{
		level function_fa7fbd4c(1);
		var_af8a18df waittill(#"trigger_activated", e_who);
		level function_fa7fbd4c(0);
		e_who clientfield::increment_to_player("interact_rumble");
		str_notify = "sophia_leave_alone_complete";
		level.var_a090a655 thread function_cbc0e672(var_1f76714[n_current_line], 1, str_notify);
		level waittill(str_notify);
		n_current_line++;
	}
}

/*
	Name: function_999a19a7
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x565B6958
	Offset: 0x3D98
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_999a19a7()
{
	level function_af4b355b();
	level function_8be3a840();
	level thread function_c78227f6();
	array::thread_all(level.var_57f8b6c5, &function_60619737);
	level flag::wait_till("tube_puzzle_complete");
	level thread function_830b8c18();
	level function_6a9560b6();
	level flag::set("ee_cylinder_acquired");
	level thread function_72d1d0bb();
}

/*
	Name: function_af4b355b
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x2DD1DF1A
	Offset: 0x3EA0
	Size: 0x3C4
	Parameters: 0
	Flags: Linked
*/
function function_af4b355b()
{
	level.var_57f8b6c5 = getentarray("ee_tube_terminal", "targetname");
	foreach(var_beb54dbd in level.var_57f8b6c5)
	{
		switch(var_beb54dbd.script_label)
		{
			case "armory":
			{
				var_beb54dbd.var_cd705a9 = array("library", "factory", "store");
				break;
			}
			case "barracks":
			{
				var_beb54dbd.var_cd705a9 = array("store", "factory", "command");
				break;
			}
			case "command":
			{
				var_beb54dbd.var_cd705a9 = array("library", "store", "barracks");
				break;
			}
			case "factory":
			{
				var_beb54dbd.var_cd705a9 = array("barracks", "library", "armory");
				break;
			}
			case "library":
			{
				var_beb54dbd.var_cd705a9 = array("command", "armory", "factory");
				break;
			}
			case "store":
			{
				var_beb54dbd.var_cd705a9 = array("armory", "barracks", "command");
				break;
			}
		}
	}
	level.var_57f8b6c5 = array::randomize(level.var_57f8b6c5);
	level.var_57f8b6c5[5] scene::init("p7_fxanim_zm_stal_pneumatic_tube_stuck_bundle");
	level.var_57f8b6c5[5] hidepart("tag_vacume_door");
	do
	{
		foreach(var_beb54dbd in level.var_57f8b6c5)
		{
			var_beb54dbd.var_1f3c0ca7 = randomint(3);
			var_beb54dbd.var_59c68a0b = 0;
			var_beb54dbd hidepart("tag_buttons_on");
			var_beb54dbd showpart("tag_buttons_off");
		}
	}
	while(function_797708de());
	array::run_all(level.var_57f8b6c5, &function_450d606e);
}

/*
	Name: function_450d606e
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xE2E74A9B
	Offset: 0x4270
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function function_450d606e()
{
	var_367b15e7 = getent(self.target, "targetname");
	v_origin = self gettagorigin("tag_lever");
	v_angles = self gettagangles("tag_lever");
	var_367b15e7.origin = v_origin;
	var_367b15e7.angles = v_angles;
	if(self.var_1f3c0ca7 == 0)
	{
		var_367b15e7 rotatepitch(240, 0.1);
	}
	else if(self.var_1f3c0ca7 == 2)
	{
		var_367b15e7 rotatepitch(120, 0.1);
	}
	var_6403853b = function_d6953423(self.var_cd705a9[self.var_1f3c0ca7]);
	var_6403853b.var_59c68a0b++;
}

/*
	Name: function_8be3a840
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x35B5EE35
	Offset: 0x43C8
	Size: 0x1A6
	Parameters: 0
	Flags: Linked
*/
function function_8be3a840()
{
	s_generator = struct::get("ee_generator", "targetname");
	s_generator.var_537b503a = util::spawn_model("tag_origin", s_generator.origin);
	s_generator.var_537b503a clientfield::set("ee_generator_target", 1);
	exploder::exploder("fxexp_702");
	zm_spawner::register_zombie_death_event_callback(&function_8b2dbe00);
	level flag::wait_till("generator_charged");
	zm_spawner::deregister_zombie_death_event_callback(&function_8b2dbe00);
	e_volume = getent("ee_generator_volume", "targetname");
	e_volume delete();
	s_generator.var_537b503a clientfield::set("ee_generator_target", 0);
	util::wait_network_frame();
	s_generator.var_537b503a delete();
	level.var_6d9026c9 = undefined;
}

/*
	Name: function_8b2dbe00
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xAD191C20
	Offset: 0x4578
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function function_8b2dbe00(e_attacker)
{
	e_volume = getent("ee_generator_volume", "targetname");
	if(isdefined(self) && self.archetype === "sentinel_drone" && self istouching(e_volume))
	{
		level thread function_1761de01(self gettagorigin("tag_origin_animate"), self gettagangles("tag_origin_animate"));
	}
}

/*
	Name: function_1761de01
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x2CD21617
	Offset: 0x4638
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function function_1761de01(var_ebb69637, var_2a65eda2)
{
	var_7e52585c = util::spawn_model("tag_origin", var_ebb69637, var_2a65eda2);
	var_7e52585c clientfield::set("ee_generator_kill", 1);
	wait(2);
	var_7e52585c delete();
	level flag::set("generator_charged");
}

/*
	Name: function_c78227f6
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xB4F15DC7
	Offset: 0x46E8
	Size: 0x230
	Parameters: 0
	Flags: Linked
*/
function function_c78227f6()
{
	level endon(#"tube_puzzle_complete");
	s_generator = struct::get("ee_generator", "targetname");
	s_generator.var_efb73168 = 0;
	s_generator zm_unitrigger::create_unitrigger("", 100, &function_a5764a2e);
	var_c1a6445a = getent("generator_tarp", "targetname");
	while(true)
	{
		level flag::set("generator_on");
		level thread scene::play("p7_fxanim_zm_stal_generator_start_tarp_bundle");
		exploder::stop_exploder("fxexp_702");
		level function_ef39c304(1);
		wait(360);
		level flag::clear("generator_on");
		exploder::exploder("fxexp_701");
		var_c1a6445a thread scene::play("p7_fxanim_zm_stal_generator_stop_tarp_bundle");
		level function_ef39c304(0);
		level waittill(#"between_round_over");
		s_generator.var_efb73168 = 1;
		exploder::exploder("fxexp_702");
		exploder::stop_exploder("fxexp_701");
		s_generator waittill(#"trigger_activated", e_who);
		e_who clientfield::increment_to_player("interact_rumble");
		s_generator.var_efb73168 = 0;
	}
}

/*
	Name: function_a5764a2e
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x46D93CE1
	Offset: 0x4920
	Size: 0x6E
	Parameters: 1
	Flags: Linked
*/
function function_a5764a2e(e_player)
{
	if(self.stub.related_parent.var_efb73168)
	{
		self sethintstring(&"ZM_STALINGRAD_GENERATOR");
		return true;
	}
	self sethintstring("");
	return false;
}

/*
	Name: function_ef39c304
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xE914228E
	Offset: 0x4998
	Size: 0x3B6
	Parameters: 1
	Flags: Linked
*/
function function_ef39c304(b_on)
{
	if(b_on)
	{
		level.var_57f8b6c5[5] thread scene::play("p7_fxanim_zm_stal_pneumatic_tube_stuck_bundle");
		exploder::exploder(("ex_tube_" + level.var_57f8b6c5[0].script_label) + "_green");
		level.var_57f8b6c5[0] playloopsound("zmb_tubesville_airflow", 0.5);
		level.var_57f8b6c5[0] showpart("tag_buttons_on");
		level.var_57f8b6c5[0] hidepart("tag_buttons_off");
		for(i = 1; i < level.var_57f8b6c5.size; i++)
		{
			if(level.var_57f8b6c5[i].var_59c68a0b > 0)
			{
				exploder::exploder(("ex_tube_" + level.var_57f8b6c5[i].script_label) + "_blue");
				level.var_57f8b6c5[i] playloopsound("zmb_tubesville_airflow", 0.5);
			}
			level.var_57f8b6c5[i] showpart("tag_buttons_on");
			level.var_57f8b6c5[i] hidepart("tag_buttons_off");
		}
	}
	else
	{
		level.var_57f8b6c5[5] scene::stop("p7_fxanim_zm_stal_pneumatic_tube_stuck_bundle");
		exploder::stop_exploder(("ex_tube_" + level.var_57f8b6c5[0].script_label) + "_green");
		level.var_57f8b6c5[0] stoploopsound(0.5);
		level.var_57f8b6c5[0] hidepart("tag_buttons_on");
		level.var_57f8b6c5[0] showpart("tag_buttons_off");
		for(i = 1; i < level.var_57f8b6c5.size; i++)
		{
			exploder::stop_exploder(("ex_tube_" + level.var_57f8b6c5[i].script_label) + "_blue");
			level.var_57f8b6c5[i] stoploopsound(0.5);
			level.var_57f8b6c5[i] hidepart("tag_buttons_on");
			level.var_57f8b6c5[i] showpart("tag_buttons_off");
		}
	}
}

/*
	Name: function_60619737
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x703FC0EF
	Offset: 0x4D58
	Size: 0x232
	Parameters: 0
	Flags: Linked
*/
function function_60619737()
{
	level endon(#"tube_puzzle_complete");
	var_4ae0fc9f = struct::get("ee_tube_use_" + self.script_label, "targetname");
	var_4ae0fc9f zm_unitrigger::create_unitrigger("");
	var_367b15e7 = getent(self.target, "targetname");
	while(true)
	{
		var_4ae0fc9f waittill(#"trigger_activated", e_who);
		if(!level flag::get("generator_on"))
		{
			continue;
		}
		e_who clientfield::increment_to_player("interact_rumble");
		var_a4e14a29 = function_d6953423(self.var_cd705a9[self.var_1f3c0ca7]);
		var_a4e14a29 function_5c0811bc(0);
		if(self.var_1f3c0ca7 == 2)
		{
			self.var_1f3c0ca7 = 0;
		}
		else
		{
			self.var_1f3c0ca7++;
		}
		var_367b15e7 rotatepitch(120, 0.5);
		var_367b15e7 playsound("zmb_tubesville_lever");
		var_367b15e7 waittill(#"rotatedone");
		var_5d1d7014 = function_d6953423(self.var_cd705a9[self.var_1f3c0ca7]);
		var_5d1d7014 function_5c0811bc(1);
		if(function_797708de())
		{
			level flag::set("tube_puzzle_complete");
			return;
		}
	}
}

/*
	Name: function_5c0811bc
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x8A6C7493
	Offset: 0x4F98
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function function_5c0811bc(var_dcb8ac46)
{
	if(var_dcb8ac46)
	{
		self.var_59c68a0b++;
		if(self.var_59c68a0b == 1 && self != level.var_57f8b6c5[0])
		{
			exploder::exploder(("ex_tube_" + self.script_label) + "_blue");
			self playloopsound("zmb_tubesville_airflow", 0.5);
		}
	}
	else
	{
		self.var_59c68a0b--;
		if(self.var_59c68a0b == 0 && self != level.var_57f8b6c5[0])
		{
			exploder::stop_exploder(("ex_tube_" + self.script_label) + "_blue");
			self stoploopsound(0.5);
		}
	}
}

/*
	Name: function_797708de
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xF81C68B9
	Offset: 0x50B0
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function function_797708de()
{
	var_a95dc9d9 = level.var_57f8b6c5[0];
	var_70172e4a = [];
	for(i = 0; i < 6; i++)
	{
		array::add(var_70172e4a, var_a95dc9d9, 0);
		var_a95dc9d9 = function_d6953423(var_a95dc9d9.var_cd705a9[var_a95dc9d9.var_1f3c0ca7]);
	}
	if(var_70172e4a.size != 6)
	{
		return false;
	}
	if(var_70172e4a[5] != level.var_57f8b6c5[5])
	{
		return false;
	}
	return true;
}

/*
	Name: function_6a9560b6
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x447831E4
	Offset: 0x51A0
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_6a9560b6()
{
	var_a477d63b = level.var_57f8b6c5[5];
	var_a477d63b scene::play("p7_fxanim_zm_stal_pneumatic_tube_drop_bundle");
	var_4ae0fc9f = struct::get("ee_tube_use_" + var_a477d63b.script_label, "targetname");
	var_4ae0fc9f.s_unitrigger.prompt_and_visibility_func = &function_7247a337;
	var_4ae0fc9f waittill(#"trigger_activated", e_who);
	e_who clientfield::increment_to_player("interact_rumble");
	e_who playsound("zmb_tubesville_pickup_cylinder");
	zm_unitrigger::unregister_unitrigger(var_4ae0fc9f.s_unitrigger);
	var_7e5dba8f = getent("pneumatic_tube", "targetname");
	var_7e5dba8f delete();
}

/*
	Name: function_830b8c18
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xD42DBE3B
	Offset: 0x52F8
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function function_830b8c18()
{
	foreach(var_beb54dbd in level.var_57f8b6c5)
	{
		var_beb54dbd stoploopsound(0.5);
	}
}

/*
	Name: function_7247a337
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x5A17C308
	Offset: 0x5398
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function function_7247a337(e_player)
{
	self sethintstring(&"ZM_STALINGRAD_MASTER_CYLINDER");
	return true;
}

/*
	Name: function_d6953423
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xB0CD2CCE
	Offset: 0x53D0
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function function_d6953423(str_location)
{
	foreach(var_beb54dbd in level.var_57f8b6c5)
	{
		if(var_beb54dbd.script_label == str_location)
		{
			return var_beb54dbd;
		}
	}
}

/*
	Name: function_72d1d0bb
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x3904865F
	Offset: 0x5470
	Size: 0x294
	Parameters: 0
	Flags: Linked
*/
function function_72d1d0bb()
{
	wait(1.5);
	level function_ef39c304(0);
	exploder::stop_exploder("fxexp_701");
	exploder::stop_exploder("fxexp_702");
	if(level flag::get("generator_on"))
	{
		var_c1a6445a = getent("generator_tarp", "targetname");
		var_c1a6445a scene::play("p7_fxanim_zm_stal_generator_stop_tarp_bundle");
	}
	struct::delete_script_bundle("scene", "p7_fxanim_zm_stal_generator_start_tarp_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_stal_generator_stop_tarp_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_stal_pneumatic_tube_stuck_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_stal_pneumatic_tube_drop_bundle");
	level.var_57f8b6c5 = undefined;
	var_4ace0f6b = struct::get_array("ee_tube_use", "script_label");
	foreach(var_a6de34cb in var_4ace0f6b)
	{
		zm_unitrigger::unregister_unitrigger(var_a6de34cb.s_unitrigger);
		var_a6de34cb.s_unitrigger = undefined;
		var_a6de34cb struct::delete();
	}
	s_generator = struct::get("ee_generator", "targetname");
	zm_unitrigger::unregister_unitrigger(s_generator.s_unitrigger);
	s_generator.s_unitrigger = undefined;
	s_generator struct::delete();
}

/*
	Name: function_9bab94c2
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x629484D5
	Offset: 0x5710
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_9bab94c2()
{
	level flag::wait_till("ee_cylinder_acquired");
	level function_fa7fbd4c(0);
	level function_96953619();
	level function_f352dd1b();
	level function_c6d84fe1();
	level function_2868b6f4();
	level zm_stalingrad_vo::function_85b7d5f1();
	wait(0.5);
	level flag::set("key_placement");
}

/*
	Name: function_96953619
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x68F9DB89
	Offset: 0x57F8
	Size: 0x26E
	Parameters: 0
	Flags: Linked
*/
function function_96953619()
{
	level.var_4c56821d = [];
	for(i = 1; i <= 6; i++)
	{
		n_index = i - 1;
		var_51a2f105 = level.var_a090a655 gettagorigin(("code_wheel_0" + i) + "_jnt");
		level.var_4c56821d[n_index] = util::spawn_model(("p7_fxanim_zm_stal_computer_sophia_code_ring_0" + i) + "_mod", var_51a2f105);
		level.var_4c56821d[n_index].takedamage = 1;
		util::wait_network_frame();
	}
	level.var_4c56821d[0].var_92f9e88c = 0;
	level.var_4c56821d[1].var_92f9e88c = 6;
	level.var_4c56821d[2].var_92f9e88c = 0;
	level.var_4c56821d[3].var_92f9e88c = 7;
	level.var_4c56821d[4].var_92f9e88c = 6;
	level.var_4c56821d[5].var_92f9e88c = 4;
	do
	{
		foreach(var_82fe6472 in level.var_4c56821d)
		{
			var_82fe6472.var_c957db9f = randomint(8);
			var_82fe6472.angles = (0, var_82fe6472.var_c957db9f * 45, 0);
		}
	}
	while(function_432361e1());
}

/*
	Name: function_432361e1
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x12CC5F87
	Offset: 0x5A70
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function function_432361e1()
{
	foreach(var_82fe6472 in level.var_4c56821d)
	{
		if(var_82fe6472.var_c957db9f != var_82fe6472.var_92f9e88c)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_f352dd1b
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x302380E8
	Offset: 0x5B18
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_f352dd1b()
{
	var_af8a18df = struct::get("ee_sophia_struct", "targetname");
	var_af8a18df function_6e3a6092(100, "", 0);
	level.var_a090a655 showpart("slot_decoder_jnt");
	level.var_a090a655 thread zm_stalingrad_vo::function_e4acaa37("vox_soph_amsel_need_auth_0", 0, 1, 0, 1);
	level.var_a090a655 scene::play("p7_fxanim_zm_stal_computer_sophia_code_door_open_bundle");
	level function_fa7fbd4c(1);
}

/*
	Name: function_c6d84fe1
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x53BF34D7
	Offset: 0x5C00
	Size: 0x282
	Parameters: 0
	Flags: Linked
*/
function function_c6d84fe1()
{
	var_2200eb08 = struct::get("ee_sophia_struct", "targetname");
	foreach(var_82fe6472 in level.var_4c56821d)
	{
		var_82fe6472 thread function_604cfbfb();
	}
	while(true)
	{
		var_2200eb08.s_unitrigger function_527f47cc(&"ZM_STALINGRAD_MASTER_PASSWORD");
		var_2200eb08 waittill(#"trigger_activated", e_who);
		level function_fa7fbd4c(0);
		var_2200eb08.s_unitrigger function_527f47cc("");
		e_who clientfield::increment_to_player("interact_rumble");
		if(function_432361e1())
		{
			break;
		}
		level.var_a090a655 thread zm_stalingrad_vo::function_e4acaa37("vox_soph_amsel_incorrect_0", 0, 1, 0, 1);
		level waittill(#"between_round_over");
		level function_fa7fbd4c(1);
	}
	level.var_a090a655 scene::play("p7_fxanim_zm_stal_computer_sophia_code_door_close_bundle");
	foreach(var_82fe6472 in level.var_4c56821d)
	{
		var_82fe6472 delete();
		util::wait_network_frame();
	}
	level.var_4c56821d = undefined;
}

/*
	Name: function_604cfbfb
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xE2FFF8B9
	Offset: 0x5E90
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function function_604cfbfb()
{
	level endon(#"hash_e84299b0");
	while(true)
	{
		self waittill(#"damage", amount, attacker, direction, point, mod, tagname, modelname, partname, weapon);
		if(isplayer(attacker) && mod != "MOD_EXPLOSIVE")
		{
			self.var_c957db9f++;
			if(self.var_c957db9f == 8)
			{
				self.var_c957db9f = 0;
			}
			self rotateyaw(45, 0.5);
			self playsound("zmb_sophia_code_door_wheel");
			self waittill(#"rotatedone");
		}
	}
}

/*
	Name: function_8d296a92
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xFD6CC0FA
	Offset: 0x5FC8
	Size: 0x156
	Parameters: 0
	Flags: Linked
*/
function function_8d296a92()
{
	level.var_ab1ca2f9 = [];
	level.var_4e272444 = 0;
	level.var_4e47b032 = 0;
	level function_928d903a();
	level flag::wait_till("key_placement");
	var_cf5f1519 = getent("ee_map", "targetname");
	var_cf5f1519 showpart("tag_map_screen_glow_text");
	level function_67cef48(1);
	level thread function_469f74c5();
	level zm_stalingrad_vo::function_38bc572f();
	level thread function_dbdd2358();
	level function_2868b6f4(0);
	level flag::wait_till("keys_placed");
	level.var_ab1ca2f9 = undefined;
	level.var_4e272444 = undefined;
	level.var_4e47b032 = undefined;
}

/*
	Name: function_928d903a
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xEA1DE2E1
	Offset: 0x6128
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_928d903a()
{
	level thread function_316026e4();
	level thread function_a1e863ea();
	level thread function_b96348ee();
	level thread function_ca8026e2();
	level thread function_71e9014a();
	level thread function_87bac664();
}

/*
	Name: function_316026e4
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xCC166F78
	Offset: 0x61C8
	Size: 0x172
	Parameters: 0
	Flags: Linked
*/
function function_316026e4()
{
	t_damage = getent("ee_keys_anomaly_damage_trig", "targetname");
	while(true)
	{
		t_damage waittill(#"damage", amount, attacker, direction, point, mod, tagname, modelname, partname, weapon);
		if(isplayer(attacker))
		{
			level scene::play("p7_fxanim_zm_stal_pickups_figure_blob_bundle");
			e_key = getent("pickup_blob", "targetname");
			e_key thread function_b68b6797("p7_zm_sta_wall_map_figure_01_blob");
			struct::delete_script_bundle("scene", "p7_fxanim_zm_stal_pickups_figure_blob_bundle");
			t_damage delete();
			return;
		}
	}
}

/*
	Name: function_a1e863ea
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x8BE31777
	Offset: 0x6348
	Size: 0x19A
	Parameters: 0
	Flags: Linked
*/
function function_a1e863ea()
{
	t_damage = getent("ee_keys_puddle_damage_trig", "targetname");
	while(true)
	{
		t_damage waittill(#"damage", amount, attacker, direction, point, mod, tagname, modelname, partname, weapon);
		if(weapon === getweapon("launcher_dragon_fire") || weapon === getweapon("launcher_dragon_fire_upgraded"))
		{
			wait(3);
			level scene::play("p7_fxanim_zm_stal_pickups_figure_nuke_bundle");
			e_key = getent("pickup_nuke", "targetname");
			e_key thread function_b68b6797("p7_zm_sta_wall_map_figure_02_nuke");
			struct::delete_script_bundle("scene", "p7_fxanim_zm_stal_pickups_figure_nuke_bundle");
			t_damage delete();
			return;
		}
	}
}

/*
	Name: function_b96348ee
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x42D1F5B3
	Offset: 0x64F0
	Size: 0x242
	Parameters: 0
	Flags: Linked
*/
function function_b96348ee()
{
	t_damage = getent("ee_keys_safe_damage_trig", "targetname");
	while(true)
	{
		t_damage waittill(#"damage", amount, attacker, direction, point, mod, tagname, modelname, partname, weapon);
		if(isdefined(attacker) && weapon === attacker.var_ae0fff53 && mod == "MOD_MELEE")
		{
			s_key = struct::get("ee_keys_pod_struct", "targetname");
			mdl_piece = util::spawn_model("p7_zm_sta_wall_map_figure_06_pod", s_key.origin + vectorscale((0, 1, 0), 20), s_key.angles);
			mdl_piece thread function_b68b6797();
			mdl_piece clientfield::set("ee_safe_smash_rumble", 1);
			mdl_piece playsound("zmb_keyskeyskeys_safe_punch");
			exploder::exploder("fxexp_705");
			var_8cf273a9 = getent("ee_safe_door", "targetname");
			var_8cf273a9 delete();
			s_key struct::delete();
			t_damage delete();
			return;
		}
	}
}

/*
	Name: function_ca8026e2
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x6D00D4F
	Offset: 0x6740
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function function_ca8026e2()
{
	array::thread_all(level.players, &function_35eed524);
	callback::on_connect(&function_35eed524);
	level waittill(#"hash_a8bfa21a", var_ac486a40);
	callback::remove_on_connect(&function_35eed524);
	if(var_ac486a40 == getweapon("dragonshield"))
	{
		exploder::exploder("fxexp_703");
	}
	else
	{
		exploder::exploder("fxexp_704");
	}
	level scene::play("p7_fxanim_zm_stal_pickups_figure_drone_bundle");
	e_key = getent("pickup_drone", "targetname");
	e_key thread function_b68b6797("p7_zm_sta_wall_map_figure_04_drone");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_stal_pickups_figure_drone_bundle");
}

/*
	Name: function_35eed524
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x375ECFB4
	Offset: 0x68B8
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function function_35eed524()
{
	level endon(#"hash_a8bfa21a");
	self endon(#"death");
	s_pipe = struct::get("ee_keys_pipe", "targetname");
	if(1)
	{
		for(;;)
		{
			self waittill(#"hash_10fa975d", var_ac486a40);
			var_7dda366c = self getweaponmuzzlepoint();
			var_9c5bd97c = self getweaponforwarddir();
			var_ae93125 = level.zombie_vars["dragonshield_knockdown_range"] * level.zombie_vars["dragonshield_knockdown_range"];
			var_cb78916d = s_pipe.origin;
			var_8112eb05 = distancesquared(var_7dda366c, var_cb78916d);
		}
		for(;;)
		{
			v_normal = vectornormalize(var_cb78916d - var_7dda366c);
			n_dot = vectordot(var_9c5bd97c, v_normal);
		}
		if(var_8112eb05 > var_ae93125)
		{
		}
		if(0 > n_dot)
		{
		}
		s_pipe struct::delete();
		level notify(#"hash_a8bfa21a", var_ac486a40);
		return;
	}
}

/*
	Name: function_71e9014a
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xDF453CBA
	Offset: 0x6A78
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_71e9014a()
{
	t_damage = getent("ee_sewer_damage_trig", "targetname");
	t_damage waittill(#"damage");
	t_damage delete();
	level scene::play("p7_fxanim_zm_stal_sewer_switch_bundle");
	exploder::exploder("sewer_switch");
	level thread function_2433fbc0();
	s_key = struct::get("ee_keys_935_struct", "targetname");
	mdl_piece = util::spawn_model("p7_zm_sta_wall_map_figure_05_symbol", s_key.origin, s_key.angles);
	mdl_piece thread function_b68b6797(undefined, "stop_swirly");
	s_key struct::delete();
}

/*
	Name: function_2433fbc0
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xD3C95719
	Offset: 0x6BD0
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function function_2433fbc0()
{
	level endon(#"stop_swirly");
	while(true)
	{
		exploder::exploder("fxexp_707");
		wait(6.5);
	}
}

/*
	Name: function_87bac664
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x358EE521
	Offset: 0x6C10
	Size: 0x1D2
	Parameters: 0
	Flags: Linked
*/
function function_87bac664()
{
	while(true)
	{
		level waittill(#"hash_278aa663", str_exploder);
		if(str_exploder == "fxexp_200")
		{
			var_4a6273cc = getent("ee_library_safe_debris", "targetname");
			exploder::exploder("fxexp_706");
			var_4a6273cc delete();
			s_key = struct::get("ee_keys_raz_struct", "targetname");
			mdl_piece = util::spawn_model("p7_zm_sta_wall_map_figure_03_soldier", s_key.origin + (vectorscale((0, 0, -1), 32)), s_key.angles);
			mdl_piece clientfield::set("ee_safe_smash_rumble", 1);
			mdl_piece playsound("zmb_keyskeyskeys_safe_explode");
			e_player = s_key function_6e3a6092();
			mdl_piece function_604c6e27(mdl_piece.model, e_player);
			mdl_piece delete();
			s_key struct::delete();
			return;
		}
	}
}

/*
	Name: function_b68b6797
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x198207F9
	Offset: 0x6DF0
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function function_b68b6797(str_model = undefined, str_notify = undefined)
{
	e_player = self function_6e3a6092();
	if(isdefined(str_notify))
	{
		level notify(str_notify);
	}
	if(!isdefined(str_model))
	{
		str_model = self.model;
	}
	self function_604c6e27(str_model, e_player);
	self delete();
}

/*
	Name: function_604c6e27
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x7EE5418D
	Offset: 0x6EB8
	Size: 0x124
	Parameters: 2
	Flags: Linked
*/
function function_604c6e27(str_model, e_player)
{
	self playsound("zmb_keyskeyskeys_pickup");
	if(!isdefined(level.var_ab1ca2f9))
	{
		level.var_ab1ca2f9 = [];
	}
	else if(!isarray(level.var_ab1ca2f9))
	{
		level.var_ab1ca2f9 = array(level.var_ab1ca2f9);
	}
	level.var_ab1ca2f9[level.var_ab1ca2f9.size] = str_model;
	level.var_4e272444++;
	if(level.var_4e272444 == 6 && level flag::get("key_placement") && !function_92de7ae0())
	{
		level thread zm_stalingrad_vo::function_931a3024();
	}
	else
	{
		e_player zm_stalingrad_vo::function_5adc22c7();
	}
}

/*
	Name: function_469f74c5
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x327A2D2C
	Offset: 0x6FE8
	Size: 0x256
	Parameters: 0
	Flags: Linked
*/
function function_469f74c5()
{
	var_66919a0f = getent("ee_map_shelf", "targetname");
	var_385ae3a2 = struct::get("ee_map_button_struct", "targetname");
	var_385ae3a2 zm_unitrigger::create_unitrigger("");
	while(true)
	{
		var_385ae3a2 waittill(#"trigger_activated", e_who);
		if(level.var_ab1ca2f9.size)
		{
			e_who clientfield::increment_to_player("interact_rumble");
			var_6d30388 = level.var_ab1ca2f9;
			level.var_ab1ca2f9 = [];
			foreach(var_66fe5441 in var_6d30388)
			{
				str_index = function_3c4d7664(var_66fe5441);
				str_tag_name = "wall_map_shelf_figure_" + str_index;
				var_66919a0f showpart(str_tag_name);
				var_cb153270 = var_66919a0f gettagorigin(str_tag_name);
				level.var_4e47b032++;
				if(level.var_4e47b032 == 6)
				{
					level flag::set("keys_placed");
					playsoundatposition("zmb_keyskeyskeys_place_final", var_cb153270);
					return;
				}
				playsoundatposition("zmb_keyskeyskeys_place", var_cb153270);
			}
		}
	}
}

/*
	Name: function_3c4d7664
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x9B78935C
	Offset: 0x7248
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function function_3c4d7664(str_key)
{
	a_str_tokens = strtok(str_key, "_");
	return a_str_tokens[6];
}

/*
	Name: function_72dd3113
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x48AD7D89
	Offset: 0x7298
	Size: 0x684
	Parameters: 0
	Flags: Linked
*/
function function_72dd3113()
{
	level flag::wait_till("keys_placed");
	level function_67cef48(0);
	level function_2868b6f4();
	level zm_stalingrad_vo::function_3a7b7b7b();
	level thread function_851880c();
	level thread function_811523a8();
	var_a25cea6f = 0;
	level function_2868b6f4(0);
	var_fa839427 = level function_3d77d2aa();
	level.var_adcde28f = 0;
	level.var_bd16d335 = 0;
	level.var_83edfb9 = 0;
	level.var_68a92652 = 0;
	level.var_8acfb18e = 0;
	level.var_9777b703 = 0;
	var_f4570d42 = 0;
	var_385ae3a2 = struct::get("ee_map_button_struct", "targetname");
	level.var_f0d11538 = spawn("script_origin", var_385ae3a2.origin);
	/#
		if(!isdefined(var_385ae3a2.s_unitrigger))
		{
			var_385ae3a2 zm_unitrigger::create_unitrigger("");
		}
	#/
	var_78d02c88 = getent("ee_map_shelf", "targetname");
	var_78d02c88 thread function_478d8886();
	var_2e214fe3 = 1;
	while(isdefined(var_fa839427[var_f4570d42]))
	{
		if(!level flag::get("special_round") && !level flag::get("lockdown_active"))
		{
			level function_67cef48(1);
		}
		var_4c390f6e = var_fa839427[var_f4570d42];
		var_385ae3a2 waittill(#"trigger_activated", e_who);
		if(level flag::get("special_round") || level flag::get("lockdown_active"))
		{
			level.var_f0d11538 playsound("zmb_scenarios_button_deny");
			continue;
		}
		level.var_f0d11538 playsound("zmb_scenarios_button_activate");
		level flag::set("scenario_active");
		level function_2868b6f4();
		e_who clientfield::increment_to_player("interact_rumble");
		if(var_f4570d42 == 0 && level.var_adcde28f == 0)
		{
			level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_phase2_intro_resp_2_0", 0, 1, 0, 1);
		}
		if(var_2e214fe3)
		{
			level function_5fa7e851();
		}
		var_7a5cc90a = level function_26d69198(var_4c390f6e);
		level flag::set("ee_round");
		level function_67cef48(0);
		var_2e214fe3 = level [[var_4c390f6e]]();
		level flag::clear("ee_round");
		level flag::clear("scenario_active");
		exploder::stop_exploder(var_7a5cc90a);
		if(var_2e214fe3)
		{
			var_f4570d42++;
			if(!(isdefined(var_a25cea6f) && var_a25cea6f) && var_f4570d42 >= (var_fa839427.size / 2))
			{
				level notify(#"hash_8df52d90");
				var_a25cea6f = 1;
			}
			if(isdefined(var_fa839427[var_f4570d42]))
			{
				level.var_f0d11538 playsound("zmb_scenarios_map_scenario_success");
			}
			else
			{
				level.var_f0d11538 playsound("zmb_scenarios_map_scenario_success_all");
			}
			level function_2868b6f4(0);
		}
		else
		{
			level thread function_60be32a4(var_4c390f6e);
			level.var_f0d11538 playsound("zmb_scenarios_map_scenario_fail");
			level.var_adcde28f++;
			level waittill(#"between_round_over");
		}
	}
	zm_unitrigger::unregister_unitrigger(var_385ae3a2.s_unitrigger);
	var_385ae3a2.s_unitrigger = undefined;
	var_385ae3a2 struct::delete();
	level.var_adcde28f = undefined;
	level.var_40917b16 = undefined;
	level.var_bd16d335 = undefined;
	level.var_83edfb9 = undefined;
	level.var_68a92652 = undefined;
	level.var_8acfb18e = undefined;
	level.var_9777b703 = undefined;
	level.var_e5f51155 = undefined;
	level flag::set("scenarios_complete");
}

/*
	Name: function_60be32a4
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x1ED74778
	Offset: 0x7928
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_60be32a4(var_4c390f6e)
{
	var_5411b44e = var_4c390f6e == (&function_6a1cc377);
	level zm_stalingrad_vo::function_dd5e5b43(level.var_adcde28f, var_5411b44e);
}

/*
	Name: function_3d77d2aa
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x89BB5AE0
	Offset: 0x7980
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function function_3d77d2aa()
{
	var_fa839427 = array(&function_4769ea02, &function_f5139aae, &function_62f0a233, &function_6a1cc377, &function_21284834);
	do
	{
		var_fa839427 = array::randomize(var_fa839427);
		foreach(n_index, var_ad364454 in var_fa839427)
		{
			if(var_ad364454 == (&function_f5139aae))
			{
				var_e0c8798d = n_index;
				continue;
			}
			if(var_ad364454 == (&function_62f0a233))
			{
				var_c1f2176c = n_index;
			}
		}
		var_9a5eed4d = abs(var_e0c8798d - var_c1f2176c);
	}
	while(var_9a5eed4d == 1);
	if(!isdefined(var_fa839427))
	{
		var_fa839427 = [];
	}
	else if(!isarray(var_fa839427))
	{
		var_fa839427 = array(var_fa839427);
	}
	var_fa839427[var_fa839427.size] = &function_101e5b38;
	return var_fa839427;
}

/*
	Name: function_478d8886
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xF60EFFF0
	Offset: 0x7B78
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function function_478d8886()
{
	level endon(#"scenarios_complete");
	var_7f5d5c6 = array("special_round", "lockdown_active");
	while(true)
	{
		level flag::wait_till_any(var_7f5d5c6);
		level function_67cef48(0);
		level flag::wait_till_clear_all(var_7f5d5c6);
		level function_67cef48(1);
	}
}

/*
	Name: function_5fa7e851
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x2150B4A5
	Offset: 0x7C28
	Size: 0x2B2
	Parameters: 0
	Flags: Linked
*/
function function_5fa7e851()
{
	for(i = 1; i <= 6; i++)
	{
		wait(0.05);
		exploder::exploder("map_display_" + i);
		level.var_f0d11538 playsound("zmb_scenarios_map_beep");
		wait(0.05);
		exploder::stop_exploder("map_display_" + i);
	}
	for(i = 6 - 1; i > 0; i--)
	{
		wait(0.05);
		exploder::exploder("map_display_" + i);
		level.var_f0d11538 playsound("zmb_scenarios_map_beep");
		wait(0.05);
		exploder::stop_exploder("map_display_" + i);
	}
	var_1f19614 = array::randomize(array(1, 2, 3, 4, 5, 6));
	for(i = 0; i < 2; i++)
	{
		foreach(var_5bc265e5 in var_1f19614)
		{
			str_exploder = "map_display_" + var_5bc265e5;
			wait(0.05);
			exploder::exploder(str_exploder);
			level.var_f0d11538 playsound("zmb_scenarios_map_beep");
			wait(0.05);
			exploder::stop_exploder(str_exploder);
		}
		var_1f19614 = array::randomize(var_1f19614);
	}
}

/*
	Name: function_26d69198
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x9295E340
	Offset: 0x7EE8
	Size: 0x120
	Parameters: 1
	Flags: Linked
*/
function function_26d69198(var_ad364454)
{
	if(var_ad364454 == (&function_21284834))
	{
		str_exploder = "map_display_1";
	}
	else
	{
		if(var_ad364454 == (&function_6a1cc377))
		{
			str_exploder = "map_display_2";
		}
		else
		{
			if(var_ad364454 == (&function_62f0a233))
			{
				str_exploder = "map_display_3";
			}
			else
			{
				if(var_ad364454 == (&function_f5139aae))
				{
					str_exploder = "map_display_4";
				}
				else
				{
					if(var_ad364454 == (&function_101e5b38))
					{
						str_exploder = "map_display_5";
					}
					else
					{
						str_exploder = "map_display_6";
					}
				}
			}
		}
	}
	exploder::exploder(str_exploder);
	level.var_f0d11538 playsound("zmb_scenarios_map_scenario_select");
	return str_exploder;
}

/*
	Name: function_4769ea02
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x6D7D51
	Offset: 0x8010
	Size: 0x29E
	Parameters: 0
	Flags: Linked
*/
function function_4769ea02()
{
	/#
		level.var_8b2f7f24 = "";
		if(!isdefined(level.var_bd16d335))
		{
			level.var_bd16d335 = 0;
		}
	#/
	if(level flag::get("drop_pod_spawned") || level flag::get("drop_pod_active"))
	{
		return false;
	}
	level function_b09a54a3();
	level.var_8cc024f2 = function_c324c7f6();
	/#
		if(isdefined(level.var_c47b244))
		{
			level.var_8cc024f2 = level.var_c47b244;
		}
	#/
	level dragon::dragon_console_global_disable();
	level function_db8a649e();
	level.var_bd16d335++;
	if(level.var_bd16d335 == 1)
	{
		level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_cargo_orders_0", 0, 1, 0, 1);
	}
	else if(level.var_bd16d335 == 2)
	{
		level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_cargo_orders_repeat_0", 0, 1, 0, 1);
	}
	level thread namespace_2e6e7fce::function_d1a91c4f(level.var_8cc024f2);
	level thread function_f858a27e();
	var_eb4d7ff3 = level util::waittill_any_return("ee_defend_complete", "ee_defend_failed");
	level dragon::function_d21f20fe();
	level.var_2b4b9c1f = undefined;
	level.var_79fa326a = undefined;
	if(var_eb4d7ff3 == "ee_defend_complete")
	{
		level function_2868b6f4();
		level zm_stalingrad_vo::function_e4acaa37("vox_soph_cargo_success_0", 0, 1, 0, 1);
		/#
			if(isdefined(level.var_c91c0e41) && level.var_c91c0e41)
			{
				level.var_c91c0e41 = undefined;
				return;
			}
		#/
		level thread function_4da4c438();
		return true;
	}
	level.var_4b419d38 = 1;
	return false;
}

/*
	Name: function_b09a54a3
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x2A92D6FD
	Offset: 0x82B8
	Size: 0x3E2
	Parameters: 0
	Flags: Linked
*/
function function_b09a54a3()
{
	level.var_583e4a97.var_4dfc9f38 = [];
	var_8f0097a0 = struct::get_array("ee_pod", "targetname");
	foreach(s_location in var_8f0097a0)
	{
		s_location.var_c5718719 = 1;
		str_location = s_location.script_string + s_location.script_int;
		level.var_583e4a97.var_4dfc9f38[str_location] = s_location;
	}
	var_2e36b699 = getentarray("ee_pod_score_volume", "targetname");
	foreach(e_volume in var_2e36b699)
	{
		str_location = e_volume.script_string;
		foreach(s_location in var_8f0097a0)
		{
			if(s_location.script_string == e_volume.script_string)
			{
				level.var_583e4a97.var_4dfc9f38[str_location + s_location.script_int].e_goal_volume = e_volume;
			}
		}
	}
	var_c746b61a = struct::get_array("ee_pod_attackable", "targetname");
	foreach(s_attack_point in var_c746b61a)
	{
		str_location = s_attack_point.script_string;
		level.var_583e4a97.var_4dfc9f38[str_location].var_b454101b = s_attack_point;
	}
	foreach(var_3d8a9064 in level.var_583e4a97.var_4dfc9f38)
	{
		var_3d8a9064 namespace_2e6e7fce::function_d4c6ea10();
	}
}

/*
	Name: function_c324c7f6
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xD20FE290
	Offset: 0x86A8
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function function_c324c7f6()
{
	while(true)
	{
		s_pod = array::random(level.var_583e4a97.var_4dfc9f38);
		var_181d95e = dragon::function_9a5142a();
		if(!isdefined(var_181d95e))
		{
			return s_pod;
		}
		switch(var_181d95e)
		{
			case "library":
			{
				if(s_pod.script_string != "ee_library")
				{
					return s_pod;
				}
				break;
			}
			case "factory":
			{
				if(s_pod.script_string != "ee_factory")
				{
					return s_pod;
				}
				break;
			}
			case "judicial":
			{
				if(s_pod.script_string != "ee_command")
				{
					return s_pod;
				}
				break;
			}
		}
		wait(0.5);
	}
}

/*
	Name: function_db8a649e
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xD7FE2208
	Offset: 0x87C0
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_db8a649e()
{
	switch(level.var_8cc024f2.script_string)
	{
		case "ee_command":
		{
			str_location = "command";
			break;
		}
		case "ee_factory":
		{
			str_location = "tank";
			break;
		}
		case "ee_library":
		{
			str_location = "supply";
			break;
		}
	}
	level thread function_15d9679d(str_location, 3);
}

/*
	Name: function_f858a27e
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x18B73898
	Offset: 0x8858
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_f858a27e()
{
	array::thread_all(level.players, &function_6485af5f);
	callback::on_connect(&function_6485af5f);
	level function_5b047f3f();
	callback::remove_on_connect(&function_6485af5f);
}

/*
	Name: function_5b047f3f
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xE9BF564A
	Offset: 0x88E8
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function function_5b047f3f()
{
	level endon(#"hash_94bb84a1");
	while(true)
	{
		level waittill(#"nuke_complete");
		level flag::set("spawn_ee_harassers");
	}
}

/*
	Name: function_6485af5f
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xED1A5723
	Offset: 0x8938
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_6485af5f()
{
	level endon(#"hash_94bb84a1");
	self endon(#"death");
	self waittill(#"nuke_triggered");
	level flag::clear("spawn_ee_harassers");
}

/*
	Name: function_7e6865e3
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x22A5A61E
	Offset: 0x8988
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function function_7e6865e3(var_9f36fb00)
{
	level function_2868b6f4(0);
	level flag::clear("ee_round");
	level.var_79fa326a = util::spawn_model("p7_conduit_metal_1_outlet_box", var_9f36fb00, vectorscale((0, 0, 1), 90));
	level.var_79fa326a.str_location = level.var_8cc024f2.script_string;
	level flag::set("ee_cargo_available");
	level.var_79fa326a thread function_61210287();
	if(!(isdefined(level.var_2b4b9c1f) && level.var_2b4b9c1f))
	{
		level.var_2b4b9c1f = 1;
		level thread zm_stalingrad_util::function_f8043960(&function_3f7226c0, undefined, 0, &function_bcea76ab);
	}
}

/*
	Name: function_61210287
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xA3197AA1
	Offset: 0x8AB8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_61210287()
{
	level endon(#"ee_cargo_retrieved");
	wait(30);
	level flag::clear("ee_cargo_available");
	self delete();
	level notify(#"ee_defend_failed");
	/#
		iprintlnbold("");
	#/
}

/*
	Name: function_3f7226c0
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xE776D6E3
	Offset: 0x8B40
	Size: 0x230
	Parameters: 0
	Flags: Linked
*/
function function_3f7226c0()
{
	level endon(#"ee_defend_failed");
	var_852a7c46 = self.var_4bd1ce6b getclosestpointonnavvolume(level.var_79fa326a.origin, 30);
	self.var_4bd1ce6b setvehgoalpos(var_852a7c46, 1, 1);
	if(self.var_4bd1ce6b vehicle_ai::waittill_pathresult())
	{
		self.var_4bd1ce6b vehicle_ai::waittill_pathing_done();
	}
	level.var_79fa326a.origin = self.var_4bd1ce6b gettagorigin("j_ankle_2_ri_anim");
	level.var_79fa326a linkto(self.var_4bd1ce6b, "j_ankle_2_ri_anim");
	level notify(#"ee_cargo_retrieved");
	self.var_4bd1ce6b thread function_948b1459();
	var_14b6e49e = struct::get("cargo_drop_" + level.var_79fa326a.str_location);
	var_1c1045d9 = self.var_4bd1ce6b getclosestpointonnavvolume(var_14b6e49e.origin, 30);
	self.var_4bd1ce6b setvehgoalpos(var_1c1045d9, 1, 1);
	if(self.var_4bd1ce6b vehicle_ai::waittill_pathresult())
	{
		self.var_4bd1ce6b vehicle_ai::waittill_pathing_done();
	}
	self.var_4bd1ce6b notify(#"cargo_dropped");
	level.var_79fa326a unlink();
	level thread function_e085d31();
	return true;
}

/*
	Name: function_948b1459
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x8DD749F8
	Offset: 0x8D78
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_948b1459()
{
	level.var_79fa326a endon(#"death");
	self endon(#"cargo_dropped");
	self waittill(#"death");
	level.var_79fa326a clientfield::set("ee_cargo_explosion", 1);
	util::wait_network_frame();
	level flag::clear("ee_cargo_available");
	level.var_79fa326a delete();
	level notify(#"ee_defend_failed");
	/#
		iprintlnbold("");
	#/
}

/*
	Name: function_bcea76ab
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x8B5A0CE5
	Offset: 0x8E48
	Size: 0xD6
	Parameters: 1
	Flags: Linked
*/
function function_bcea76ab(e_player)
{
	if(!level flag::get("ee_cargo_available"))
	{
		return false;
	}
	if(isdefined(level.var_8cc024f2) && (isdefined(level.var_8cc024f2.var_c5718719) && level.var_8cc024f2.var_c5718719))
	{
		var_e782bc88 = getent("fetch_volume_" + level.var_8cc024f2.script_string, "targetname");
		if(!e_player istouching(var_e782bc88))
		{
			return false;
		}
	}
	else
	{
		return false;
	}
	return true;
}

/*
	Name: function_e085d31
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x484374E3
	Offset: 0x8F28
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function function_e085d31()
{
	playfxontag(level._effect["drop_pod_reward_glow"], level.var_79fa326a, "tag_origin");
	level.var_79fa326a thread function_6cacaae5();
	level.var_79fa326a function_6e3a6092(100, &"ZM_STALINGRAD_DEFEND_CARGO");
	level.var_79fa326a delete();
	level function_d9d36a17("p7_conduit_metal_1_outlet_box", &"ZM_STALINGRAD_CARGO_DEPOSIT", vectorscale((0, 0, 1), 90), vectorscale((0, 0, 1), 1.5));
	level notify(#"ee_defend_complete");
}

/*
	Name: function_6cacaae5
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x6428406D
	Offset: 0x9018
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function function_6cacaae5()
{
	self endon(#"death");
	while(true)
	{
		n_wait_time = randomfloatrange(2.5, 5);
		n_yaw = randomint(360);
		if(n_yaw > 300)
		{
			n_yaw = 300;
		}
		else if(n_yaw < 60)
		{
			n_yaw = 60;
		}
		n_yaw = self.angles[1] + n_yaw;
		var_d9f4bdfd = (-60 + randomint(120), n_yaw, -45 + randomint(90));
		self rotateto(var_d9f4bdfd, n_wait_time, n_wait_time * 0.5, n_wait_time * 0.5);
		wait(randomfloat(n_wait_time - 0.1));
	}
}

/*
	Name: function_4da4c438
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xAF2EB085
	Offset: 0x9170
	Size: 0x192
	Parameters: 0
	Flags: Linked
*/
function function_4da4c438()
{
	array::run_all(level.var_583e4a97.var_4dfc9f38, &struct::delete);
	var_17788efc = struct::get_array("ee_harasser", "script_label");
	array::run_all(var_17788efc, &struct::delete);
	var_efb0cf3a = struct::get_array("ee_defend_cargo_drop", "script_label");
	array::run_all(var_efb0cf3a, &struct::delete);
	var_f54e06c3 = getentarray("ee_defend_fetch", "script_label");
	foreach(var_e782bc88 in var_f54e06c3)
	{
		var_e782bc88 delete();
		util::wait_network_frame();
	}
}

/*
	Name: function_f5139aae
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x7788E3F
	Offset: 0x9310
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function function_f5139aae()
{
	/#
		level.var_8b2f7f24 = "";
		if(!isdefined(level.var_83edfb9))
		{
			level.var_83edfb9 = 0;
		}
	#/
	s_spawn_location = struct::get("ee_escort_spawn", "targetname");
	if(level zm_ai_sentinel_drone::function_19d0b055(1, &function_de888a13, 1, s_spawn_location))
	{
		level thread function_591777cf();
		level thread function_15d9679d("square", 3);
		var_9f2ad2a7 = level util::waittill_any_return("ee_escort_complete", "ee_escort_failed");
		if(var_9f2ad2a7 == "ee_escort_complete")
		{
			level function_2868b6f4();
			level zm_stalingrad_vo::function_e4acaa37("vox_soph_sentinel_success_0", 0, 1, 0, 1);
			/#
				if(isdefined(level.var_c91c0e41) && level.var_c91c0e41)
				{
					level.var_c91c0e41 = undefined;
					return;
				}
			#/
			s_spawn_location struct::delete();
			return true;
		}
	}
	return false;
}

/*
	Name: function_591777cf
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xD9711ABB
	Offset: 0x94A8
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_591777cf()
{
	level.var_83edfb9++;
	if(level.var_83edfb9 == 1)
	{
		level zm_stalingrad_vo::function_e4acaa37("vox_soph_sentinel_orders_0", 0, 1, 0, 1);
	}
	else if(level.var_83edfb9 == 2)
	{
		level zm_stalingrad_vo::function_e4acaa37("vox_soph_sentinel_orders_repeat_1", 0, 1, 0, 1);
	}
	level function_2868b6f4(0);
}

/*
	Name: function_de888a13
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x682941F0
	Offset: 0x9550
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_de888a13()
{
	self endon(#"death");
	self thread function_8981cfc();
	self vehicle_ai::set_state("scripted");
	self.b_ignore_cleanup = 1;
	self.ignore_nuke = 1;
	self.ignore_round_robbin_death = 1;
	self.var_81e263d5 = 1;
	self._dragon_ignoreme = 1;
	self.ignore_enemy_count = 1;
	self waittill(#"completed_spawning");
	self disableaimassist();
	self sentinel_drone::sentinel_destroyallarms(1);
	self clientfield::set("ee_drone_cam_override", 1);
	self thread function_a6093653();
}

/*
	Name: function_a6093653
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xA3DEA4FC
	Offset: 0x9658
	Size: 0x28A
	Parameters: 0
	Flags: Linked
*/
function function_a6093653()
{
	/#
		level endon(#"hash_9546144d");
	#/
	level endon(#"ee_escort_failed");
	var_fe8b6de3 = getvehiclenode("ee_escort_entrance", "targetname");
	while(!zm_zonemgr::any_player_in_zone("start_A_zone") && !zm_zonemgr::any_player_in_zone("start_B_zone") && !zm_zonemgr::any_player_in_zone("start_C_zone"))
	{
		wait(1);
	}
	self vehicle::get_on_and_go_path(var_fe8b6de3);
	self thread function_8c3c41dc();
	self function_cd8abf88("store");
	if(!level flag::get("dept_to_yellow") && !level flag::get("department_floor3_to_red_brick_open"))
	{
		level flag::wait_till_any(array("dept_to_yellow", "department_floor3_to_red_brick_open"));
	}
	if(!level flag::get("dept_to_yellow"))
	{
		var_294b0130 = "barracks";
	}
	else
	{
		if(!level flag::get("department_floor3_to_red_brick_open"))
		{
			var_294b0130 = "armory";
		}
		else
		{
			if(math::cointoss())
			{
				var_294b0130 = "barracks";
			}
			else
			{
				var_294b0130 = "armory";
			}
		}
	}
	self function_cd8abf88(var_294b0130);
	self function_cd8abf88("command");
	level notify(#"hash_611549c5");
	level function_694a61ea(self);
	level notify(#"ee_escort_complete");
}

/*
	Name: function_cd8abf88
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x880E875D
	Offset: 0x98F0
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function function_cd8abf88(var_817b9791)
{
	var_cc0916c4 = getvehiclenode("ee_escort_" + var_817b9791, "targetname");
	self thread vehicle::get_on_and_go_path(var_cc0916c4);
	self vehicle::pause_path();
	self function_a9a92838();
}

/*
	Name: function_a9a92838
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x70D11943
	Offset: 0x9988
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function function_a9a92838()
{
	self endon(#"death");
	self endon(#"reached_end_node");
	b_moving = 0;
	while(true)
	{
		var_6de069e0 = self zm_stalingrad_util::function_1af75b1b(200);
		if(var_6de069e0 && !b_moving)
		{
			b_moving = 1;
			self vehicle::resume_path();
			self notify(#"hash_3751c122");
		}
		else if(!var_6de069e0 && b_moving)
		{
			b_moving = 0;
			self vehicle::pause_path();
			self thread function_8c3c41dc();
		}
		wait(1);
	}
}

/*
	Name: function_8981cfc
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x12D60824
	Offset: 0x9A88
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function function_8981cfc()
{
	level endon(#"hash_611549c5");
	self waittill(#"death");
	level notify(#"ee_escort_failed");
}

/*
	Name: function_8c3c41dc
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x3FEBA3C
	Offset: 0x9AC0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_8c3c41dc()
{
	level endon(#"hash_611549c5");
	self endon(#"hash_3751c122");
	self endon(#"death");
	wait(60);
	self kill();
}

/*
	Name: function_62f0a233
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x64878C5C
	Offset: 0x9B18
	Size: 0x2BC
	Parameters: 0
	Flags: Linked
*/
function function_62f0a233()
{
	/#
		level.var_8b2f7f24 = "";
		if(!isdefined(level.var_68a92652))
		{
			level.var_68a92652 = 0;
		}
	#/
	var_23424f41 = [];
	var_8338c325 = struct::get_array("raz_location", "script_noteworthy");
	foreach(var_1fc5be4a in var_8338c325)
	{
		switch(var_1fc5be4a.targetname)
		{
			case "factory_A_spawn":
			case "factory_C_spawn":
			case "factory_C_spawn_2":
			case "library_A_spawn":
			case "library_B_spawn":
			{
				if(!isdefined(var_23424f41))
				{
					var_23424f41 = [];
				}
				else if(!isarray(var_23424f41))
				{
					var_23424f41 = array(var_23424f41);
				}
				var_23424f41[var_23424f41.size] = var_1fc5be4a;
				break;
			}
		}
	}
	s_spawn = array::random(var_23424f41);
	if(zm_ai_raz::function_7ed6c714(1, &function_4d790672, 1, s_spawn))
	{
		level thread function_33803fac();
		var_71fb112c = level util::waittill_any_return("ee_kite_complete", "ee_kite_failed");
		/#
			level.var_9f752812 = undefined;
		#/
		if(var_71fb112c == "ee_kite_complete")
		{
			level function_2868b6f4();
			level zm_stalingrad_vo::function_e4acaa37("vox_soph_capture_raz_success_1", 0, 1, 0, 1);
			/#
				if(isdefined(level.var_c91c0e41) && level.var_c91c0e41)
				{
					level.var_c91c0e41 = undefined;
					return;
				}
			#/
			level function_2f418bbf();
			return true;
		}
	}
	return false;
}

/*
	Name: function_33803fac
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xC008A104
	Offset: 0x9DE0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_33803fac()
{
	level.var_68a92652++;
	if(level.var_68a92652 == 1)
	{
		level zm_stalingrad_vo::function_e4acaa37("vox_soph_capture_raz_orders_0", 0, 1, 0, 1);
	}
	level function_2868b6f4(0);
}

/*
	Name: function_4d790672
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xB9A758C7
	Offset: 0x9E48
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_4d790672()
{
	/#
		level endon(#"hash_9546144d");
	#/
	level endon(#"ee_kite_complete");
	level endon(#"ee_kite_failed");
	/#
		level.var_9f752812 = self;
	#/
	self.b_ignore_cleanup = 1;
	self.ignore_nuke = 1;
	self.ignore_round_robbin_death = 1;
	self.var_81e263d5 = 1;
	self._dragon_ignoreme = 1;
	self.ignore_enemy_count = 1;
	util::wait_network_frame();
	self clientfield::set("ee_raz_eye_override", 1);
	self thread function_4f067ff7();
	self waittill(#"completed_emerging_into_playable_area");
	self function_c54a2f4c();
}

/*
	Name: function_4f067ff7
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x49A9A774
	Offset: 0x9F40
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function function_4f067ff7()
{
	level endon(#"ee_kite_complete");
	level endon(#"ee_kite_failed");
	level endon(#"hash_e4034552");
	self waittill(#"death");
	level notify(#"ee_kite_failed");
}

/*
	Name: function_c54a2f4c
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x4F144D33
	Offset: 0x9F90
	Size: 0x140
	Parameters: 1
	Flags: Linked
*/
function function_c54a2f4c(var_6f4b86fb)
{
	/#
		level endon(#"hash_9546144d");
	#/
	level endon(#"ee_kite_complete");
	level endon(#"ee_kite_failed");
	self thread function_ceeaf112();
	var_4cdb4f77 = undefined;
	while(true)
	{
		wait(1);
		var_6de069e0 = self zm_stalingrad_util::function_1af75b1b(450);
		if(!isdefined(var_4cdb4f77) || (var_6de069e0 && !var_4cdb4f77))
		{
			self notify(#"hash_f1860bb1");
			self clearforcedgoal();
			self ai::set_ignoreall(0);
			var_4cdb4f77 = 1;
		}
		else if(!var_6de069e0 && var_4cdb4f77)
		{
			self thread function_96970289();
			self ai::set_ignoreall(1);
			var_4cdb4f77 = 0;
		}
	}
}

/*
	Name: function_96970289
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x8198BC10
	Offset: 0xA0D8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_96970289()
{
	/#
		level endon(#"hash_9546144d");
	#/
	self endon(#"death");
	self endon(#"hash_f1860bb1");
	level endon(#"ee_kite_complete");
	var_713bb408 = struct::get("ee_raz_escape", "targetname");
	self setgoal(var_713bb408.origin);
	self waittill(#"goal");
	level notify(#"ee_kite_failed");
	self ai::set_ignoreall(1);
	var_aa6f12ec = struct::get("ee_raz_delete", "targetname");
	self setgoal(var_aa6f12ec.origin);
	self waittill(#"goal");
	self kill();
}

/*
	Name: function_ceeaf112
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xC126E839
	Offset: 0xA208
	Size: 0x1F0
	Parameters: 0
	Flags: Linked
*/
function function_ceeaf112()
{
	/#
		level endon(#"hash_9546144d");
	#/
	level endon(#"ee_kite_failed");
	var_f80d6608 = getent("ee_raz_capture", "targetname");
	while(true)
	{
		var_f80d6608 waittill(#"trigger", e_who);
		if(e_who == self)
		{
			self clearforcedgoal();
			self ai::set_ignoreall(1);
			var_f80d6608 delete();
			s_capture_point = struct::get("ee_capture_point", "targetname");
			self setgoal(s_capture_point.origin);
			var_c1fbdc10 = util::spawn_model("tag_origin", s_capture_point.origin);
			self notsolid();
			self waittill(#"goal");
			wait(0.5);
			self linkto(var_c1fbdc10);
			self solid();
			level notify(#"hash_e4034552");
			level function_694a61ea(self);
			var_c1fbdc10 delete();
			level notify(#"ee_kite_complete");
			return;
		}
	}
}

/*
	Name: function_2f418bbf
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x7E87DCEF
	Offset: 0xA400
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_2f418bbf()
{
	var_a7e5eb7a = struct::get("ee_raz_entrance", "targetname");
	var_a7e5eb7a struct::delete();
	var_fc67abd = struct::get("ee_raz_escape", "targetname");
	var_fc67abd struct::delete();
	var_fffdb019 = struct::get("ee_raz_delete", "targetname");
	var_fffdb019 struct::delete();
}

/*
	Name: function_6a1cc377
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xCE9140AF
	Offset: 0xA4D0
	Size: 0x3BC
	Parameters: 0
	Flags: Linked
*/
function function_6a1cc377()
{
	/#
		level.var_8b2f7f24 = "";
		if(!isdefined(level.var_8acfb18e))
		{
			level.var_8acfb18e = 0;
		}
	#/
	level.var_8acfb18e++;
	if(level.var_8acfb18e == 1)
	{
		level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_security_system_orders_0", 0, 1, 0, 1);
	}
	var_4af7b97 = array("armory", "barracks", "command", "store", "supply", "tank");
	var_4af7b97 = array::randomize(var_4af7b97);
	level function_18375f27(var_4af7b97);
	level function_2868b6f4(0);
	level.var_178c3c6b = 0;
	level thread function_df3d4b2f();
	var_7953b28 = getentarray("ee_timed", "script_label");
	array::thread_all(var_7953b28, &function_82d88307, var_4af7b97);
	var_2635052a = level util::waittill_any_return("ee_timed_complete", "ee_timed_failed");
	foreach(mdl_button in var_7953b28)
	{
		zm_unitrigger::unregister_unitrigger(mdl_button.s_unitrigger);
		mdl_button.s_unitrigger = undefined;
	}
	level.var_178c3c6b = undefined;
	if(var_2635052a == "ee_timed_complete")
	{
		level.var_49799ac6 = undefined;
		level function_2868b6f4();
		level zm_stalingrad_vo::function_e4acaa37("vox_soph_security_system_success_0", 0, 1, 0, 1);
		/#
			if(isdefined(level.var_c91c0e41) && level.var_c91c0e41)
			{
				level.var_c91c0e41 = undefined;
				return;
			}
		#/
		level function_aeaa21eb();
		return true;
	}
	level function_f715c0b9(var_7953b28);
	wait(1);
	foreach(mdl_button in var_7953b28)
	{
		mdl_button thread scene::play("p7_fxanim_zm_stal_rigged_button_retract_bundle", array(mdl_button));
		mdl_button stoploopsound(2);
	}
	return false;
}

/*
	Name: function_18375f27
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x434E1671
	Offset: 0xA898
	Size: 0x5F4
	Parameters: 1
	Flags: Linked
*/
function function_18375f27(var_4af7b97)
{
	var_cf5f1519 = getent("ee_map", "targetname");
	/#
		if(!isdefined(level.var_f0d11538))
		{
			var_385ae3a2 = struct::get("", "");
			level.var_f0d11538 = spawn("", var_385ae3a2.origin);
		}
	#/
	level.var_f0d11538 playsound("zmb_scenarios_map_scenario_select");
	for(i = 0; i < 4; i++)
	{
		wait(0.4);
		foreach(str_location in var_4af7b97)
		{
			str_tag = "tag_map_screen_glow_" + str_location;
			var_cf5f1519 showpart(str_tag);
		}
		level.var_f0d11538 playsound("zmb_scenarios_map_beep_higher");
		wait(0.4);
		foreach(str_location in var_4af7b97)
		{
			str_tag = "tag_map_screen_glow_" + str_location;
			var_cf5f1519 hidepart(str_tag);
		}
	}
	var_bf616d4d = array::randomize(var_4af7b97);
	foreach(var_796743e2 in var_bf616d4d)
	{
		str_tag = "tag_map_screen_glow_" + var_796743e2;
		wait(0.1);
		var_cf5f1519 showpart(str_tag);
		var_cf5f1519 playsound("zmb_scenarios_map_beep_higher");
		wait(0.1);
		var_cf5f1519 hidepart(str_tag);
	}
	foreach(str_location in var_4af7b97)
	{
		str_tag = "tag_map_screen_glow_" + str_location;
		wait(0.3);
		var_cf5f1519 showpart(str_tag);
		var_cf5f1519 playsound("zmb_scenarios_map_beep_higher");
		wait(0.4);
		var_cf5f1519 hidepart(str_tag);
	}
	wait(0.1);
	for(i = 0; i < (4 - 1); i++)
	{
		foreach(str_location in var_4af7b97)
		{
			str_tag = "tag_map_screen_glow_" + str_location;
			var_cf5f1519 showpart(str_tag);
		}
		level.var_f0d11538 playsound("zmb_scenarios_map_beep_higher");
		wait(0.4);
		foreach(str_location in var_4af7b97)
		{
			str_tag = "tag_map_screen_glow_" + str_location;
			var_cf5f1519 hidepart(str_tag);
		}
		wait(0.4);
	}
	level.var_f0d11538 playsound("zmb_scenarios_map_scenario_select");
}

/*
	Name: function_df3d4b2f
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x74E7FD38
	Offset: 0xAE98
	Size: 0x24A
	Parameters: 0
	Flags: Linked
*/
function function_df3d4b2f()
{
	/#
		level endon(#"hash_9546144d");
	#/
	level endon(#"ee_timed_complete");
	level endon(#"ee_timed_failed");
	level.var_f0d11538 playloopsound("zmb_finalcountdown_timer_tick", 0.1);
	if(level.players.size == 1)
	{
		level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_security_system_counter_3min_0");
		wait(60);
	}
	if(level.players.size < 3)
	{
		level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_security_system_counter_2min_0");
		playsoundatposition("zmb_finalcountdown_timer_marker", (0, 0, 0));
		wait(60);
	}
	if(level.players.size == 3)
	{
		playsoundatposition("zmb_finalcountdown_timer_marker", (0, 0, 0));
		wait(30);
	}
	playsoundatposition("zmb_finalcountdown_timer_marker", (0, 0, 0));
	level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_security_system_counter_1min_0");
	wait(30);
	playsoundatposition("zmb_finalcountdown_timer_marker", (0, 0, 0));
	level.var_f0d11538 playloopsound("zmb_finalcountdown_timer_tick_serious", 0.1);
	level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_security_system_counter_30sec_0");
	wait(20);
	playsoundatposition("zmb_finalcountdown_timer_marker", (0, 0, 0));
	level thread function_845d9fe9();
	level waittill(#"hash_78a07bbf");
	level.var_f0d11538 stoploopsound(0.1);
	level notify(#"ee_timed_failed");
}

/*
	Name: function_845d9fe9
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x94FBEFD
	Offset: 0xB0F0
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function function_845d9fe9()
{
	for(i = 10; i > 0; i--)
	{
		level zm_stalingrad_vo::function_e4acaa37(("vox_soph_security_system_counter_" + i) + "sec_0", 0, 0, 0, 1);
		if(i == 3)
		{
			playsoundatposition("zmb_finalcountdown_timer_3secs", (0, 0, 0));
		}
		if(isdefined(level.var_e5f51155) && level.var_e5f51155)
		{
			level.var_e5f51155 = undefined;
			return;
		}
	}
	level notify(#"hash_78a07bbf");
}

/*
	Name: function_82d88307
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xAF9ACA5F
	Offset: 0xB1B0
	Size: 0x1F0
	Parameters: 1
	Flags: Linked
*/
function function_82d88307(var_4af7b97)
{
	/#
		level endon(#"hash_9546144d");
	#/
	level endon(#"ee_timed_failed");
	self scene::play("p7_fxanim_zm_stal_rigged_button_extend_bundle", array(self));
	self playloopsound("zmb_rigged_button_alarm_lp", 3);
	self function_6e3a6092();
	var_d1033754 = "ee_timed_" + var_4af7b97[level.var_178c3c6b];
	if(self.targetname != var_d1033754)
	{
		level.var_e5f51155 = 1;
		self playsound("zmb_rigged_button_press_bad");
		self stoploopsound(2);
		level.var_f0d11538 stoploopsound(0.1);
		level notify(#"ee_timed_failed");
		return;
	}
	self playsound("zmb_rigged_button_press_good");
	self stoploopsound(2);
	self scene::play("p7_fxanim_zm_stal_rigged_button_retract_bundle", array(self));
	if(level.var_178c3c6b == 5)
	{
		level.var_e5f51155 = 1;
		level notify(#"ee_timed_complete");
		level.var_f0d11538 stoploopsound(0.1);
		return;
	}
	level.var_178c3c6b++;
}

/*
	Name: function_f715c0b9
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x3344D91F
	Offset: 0xB3A8
	Size: 0x248
	Parameters: 1
	Flags: Linked
*/
function function_f715c0b9(var_7953b28)
{
	exploder::exploder("fxexp_708");
	foreach(mdl_button in var_7953b28)
	{
		mdl_button clientfield::increment("ee_timed_explosion_rumble");
		foreach(e_player in level.activeplayers)
		{
			if(isalive(e_player) && (!(isdefined(e_player.var_4a416e6a) && e_player.var_4a416e6a)))
			{
				if(zm_stalingrad_util::function_86b1188c(500, mdl_button, e_player))
				{
					e_player dodamage(e_player.health + 666, e_player.origin);
					e_player.var_4a416e6a = 1;
				}
			}
		}
	}
	foreach(e_player in level.players)
	{
		e_player.var_4a416e6a = undefined;
	}
}

/*
	Name: function_aeaa21eb
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x1446A9A
	Offset: 0xB5F8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_aeaa21eb()
{
	struct::delete_script_bundle("scene", "p7_fxanim_zm_stal_rigged_button_extend_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_stal_rigged_button_retract_bundle");
}

/*
	Name: function_21284834
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x53E75E42
	Offset: 0xB648
	Size: 0x2E0
	Parameters: 0
	Flags: Linked
*/
function function_21284834()
{
	/#
		level.var_8b2f7f24 = "";
		if(!isdefined(level.var_9777b703))
		{
			level.var_9777b703 = 0;
		}
	#/
	level.var_7f02c954 = struct::get_array("ee_pursue_position", "targetname");
	level.var_7f02c954 = array::randomize(level.var_7f02c954);
	var_4d7d0bda = array::pop_front(level.var_7f02c954, 0);
	level.var_a5fb1d00 = util::spawn_model("p7_fxanim_zm_stal_ray_gun_ball_mod", var_4d7d0bda.origin);
	level.var_a5fb1d00.takedamage = 1;
	level.var_a5fb1d00.var_92198510 = var_4d7d0bda;
	level.var_a5fb1d00.var_2b3fc782 = var_4d7d0bda;
	level.var_a5fb1d00.var_98b48961 = var_4d7d0bda;
	level.var_bce5f17f = 0;
	level.var_a5fb1d00.var_5149ab6f = 0;
	level.var_a5fb1d00 clientfield::set("ee_anomaly_loop", 1);
	loop_snd_ent = spawn("script_origin", var_4d7d0bda.origin);
	loop_snd_ent playloopsound("zmb_anomoly_loop", 0.5);
	loop_snd_ent linkto(level.var_a5fb1d00);
	loop_snd_ent thread function_2808099a();
	level.var_a5fb1d00 thread function_cfa09312();
	level.var_a5fb1d00 thread function_27541a6d();
	level thread function_6a47a4e9();
	var_e25d11fd = level util::waittill_any_return("ee_pursue_complete", "ee_pursue_failed");
	if(var_e25d11fd == "ee_pursue_complete")
	{
		level.var_7f02c954 = undefined;
		level.var_bce5f17f = undefined;
		level.var_a5fb1d00 = undefined;
		/#
			if(isdefined(level.var_c91c0e41) && level.var_c91c0e41)
			{
				level.var_c91c0e41 = undefined;
				return;
			}
		#/
		level function_9aede4e6();
		return true;
	}
	return false;
}

/*
	Name: function_6a47a4e9
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x4FA25D94
	Offset: 0xB938
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_6a47a4e9()
{
	level.var_9777b703++;
	if(level.var_9777b703 == 1)
	{
		level zm_stalingrad_vo::function_e4acaa37("vox_soph_anomaly_orders_0", 0, 1, 0, 1);
	}
	level function_2868b6f4(0);
}

/*
	Name: function_2808099a
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x4322416A
	Offset: 0xB9A0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_2808099a()
{
	level waittill(#"hash_2850c4f2");
	self stoploopsound(0.5);
	self delete();
}

/*
	Name: function_cfa09312
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x1EBE4CC5
	Offset: 0xB9F0
	Size: 0x294
	Parameters: 1
	Flags: Linked
*/
function function_cfa09312(var_cffe61ab = 0)
{
	/#
		level endon(#"hash_9546144d");
	#/
	self endon(#"step_complete");
	level endon(#"ee_pursue_failed");
	var_2e4b6485 = 0;
	self thread function_77e01bd0();
	while(true)
	{
		var_6db1518a = function_4981184b();
		self.var_98b48961 = self.var_2b3fc782;
		self.var_2b3fc782 = self.var_92198510;
		self.var_92198510 = var_6db1518a;
		if(var_cffe61ab)
		{
			var_cffe61ab = 0;
			var_46b0f218 = self function_5e9a73bf(300);
		}
		else
		{
			if(var_2e4b6485)
			{
				var_46b0f218 = self function_5e9a73bf(188);
			}
			else
			{
				var_1f1d4ae6 = distance(self.var_92198510.origin, self.var_2b3fc782.origin);
				var_46b0f218 = var_1f1d4ae6 / 148;
			}
		}
		if(var_46b0f218 < 2)
		{
			n_accel = var_46b0f218 * 0.5;
		}
		else
		{
			n_accel = 1;
		}
		self moveto(self.var_92198510.origin, var_46b0f218, n_accel, n_accel);
		self waittill(#"movedone");
		self thread function_54457756();
		str_notify = self util::waittill_any_return("pap_damage", "keep_wandering", "death", "step_complete", "ee_pursue_failed");
		if(str_notify === "pap_damage" || str_notify === "death")
		{
			var_2e4b6485 = 1;
			wait(0.75);
		}
		else
		{
			var_2e4b6485 = 0;
		}
	}
}

/*
	Name: function_4981184b
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xADA8A9A4
	Offset: 0xBC90
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_4981184b()
{
	if(function_4b3ee36b())
	{
		level.var_7f02c954 = struct::get_array("ee_pursue_position", "targetname");
		level.var_7f02c954 = array::randomize(level.var_7f02c954);
	}
	while(true)
	{
		if(level.var_bce5f17f >= level.var_7f02c954.size)
		{
			level.var_bce5f17f = 0;
		}
		var_6db1518a = level.var_7f02c954[level.var_bce5f17f];
		if(function_44084295(var_6db1518a))
		{
			arrayremovevalue(level.var_7f02c954, var_6db1518a);
			return var_6db1518a;
		}
		level.var_bce5f17f++;
	}
}

/*
	Name: function_4b3ee36b
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x8CDFCFFA
	Offset: 0xBD90
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_4b3ee36b()
{
	foreach(s_position in level.var_7f02c954)
	{
		if(function_44084295(s_position))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_44084295
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xD7041DDB
	Offset: 0xBE30
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function function_44084295(s_destination)
{
	if(level.var_a5fb1d00.var_2b3fc782.script_string == s_destination.script_string || level.var_a5fb1d00.var_98b48961.script_string == s_destination.script_string || level.var_a5fb1d00.var_92198510.script_string == s_destination.script_string)
	{
		return false;
	}
	if(zm_stalingrad_util::function_86b1188c(1750, level.var_a5fb1d00, s_destination))
	{
		return false;
	}
	return true;
}

/*
	Name: function_5e9a73bf
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x4FFD8C29
	Offset: 0xBEF8
	Size: 0x2BC
	Parameters: 1
	Flags: Linked
*/
function function_5e9a73bf(var_43a6be37)
{
	level endon(#"ee_pursue_failed");
	self endon(#"step_complete");
	var_430ccf88 = struct::get("ee_pursue_arrival_" + self.var_92198510.script_string, "targetname");
	self playsound("zmb_anomoly_takeoff");
	for(i = 0; i <= 8; i++)
	{
		var_979a6a0c = var_430ccf88.origin[0] + (randomfloatrange(-200, 200));
		var_bd9ce475 = var_430ccf88.origin[1] + (randomfloatrange(-200, 200));
		var_e39f5ede = var_430ccf88.origin[2] + (randomfloatrange(-200, 200));
		if(i == 0)
		{
			var_a29e3923 = distance(self.origin, (var_979a6a0c, var_bd9ce475, var_e39f5ede));
			var_add151b1 = var_a29e3923 / var_43a6be37;
			self moveto((var_979a6a0c, var_bd9ce475, var_e39f5ede), var_add151b1, 0.2);
		}
		else
		{
			if(i == 8)
			{
				self moveto((var_979a6a0c, var_bd9ce475, var_e39f5ede), 0.3, 0, 0.3);
			}
			else
			{
				self moveto((var_979a6a0c, var_bd9ce475, var_e39f5ede), 0.3);
			}
		}
		self waittill(#"movedone");
	}
	wait(1);
	var_8acc78ca = distance(self.origin, self.var_92198510.origin);
	var_46b0f218 = var_8acc78ca / 148;
	return var_46b0f218;
}

/*
	Name: function_54457756
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x207D77B2
	Offset: 0xC1C0
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function function_54457756()
{
	/#
		level endon(#"hash_9546144d");
	#/
	level endon(#"ee_pursue_failed");
	self endon(#"pap_damage");
	var_9add3f18 = randomfloatrange(20, 30);
	wait(var_9add3f18);
	self notify(#"keep_wandering");
}

/*
	Name: function_77e01bd0
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x71BEA39A
	Offset: 0xC230
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_77e01bd0()
{
	level endon(#"ee_pursue_failed");
	self endon(#"step_complete");
	if(self zm_stalingrad_util::function_1af75b1b(750))
	{
		wait(randomintrange(5, 10));
	}
	while(true)
	{
		if(self.var_5149ab6f >= 7)
		{
			return;
		}
		if(self zm_stalingrad_util::function_1af75b1b(750))
		{
			self thread zm_stalingrad_vo::function_e4acaa37("vox_gers_gersch_chatter_" + self.var_5149ab6f);
			self.var_5149ab6f++;
			wait(30);
		}
		wait(3);
	}
}

/*
	Name: function_27541a6d
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x6C10207E
	Offset: 0xC308
	Size: 0x300
	Parameters: 0
	Flags: Linked
*/
function function_27541a6d()
{
	/#
		level endon(#"hash_9546144d");
	#/
	level endon(#"ee_pursue_failed");
	n_damage_threshold = 6500 + (1000 * zm_utility::get_number_of_valid_players());
	/#
		if(isdefined(level.var_f9c3fe97) && level.var_f9c3fe97)
		{
			n_damage_threshold = 5;
		}
	#/
	n_current_health = n_damage_threshold;
	n_step = 0;
	while(true)
	{
		self.var_44b9cab5 = 0;
		self thread function_182fe200();
		self waittill(#"damage", amount, attacker, direction, point, mod, tagname, modelname, partname, weapon);
		if(isplayer(attacker) && zm_weapons::is_weapon_upgraded(weapon))
		{
			self notify(#"pap_damage");
			self.var_44b9cab5 = 1;
			n_current_health = n_current_health - amount;
			if(n_current_health <= 0)
			{
				self notify(#"step_complete");
				self moveto(self.origin, 0.1);
				self clientfield::set("ee_anomaly_loop", 0);
				self playsound("zmb_anomoly_dmg_hit");
				level thread function_4b5b4aeb(n_step);
				level waittill(#"hash_f9b2d970");
				level.var_a5fb1d00 clientfield::set("ee_anomaly_loop", 1);
				n_step++;
				n_current_health = n_damage_threshold;
				if(n_step == 3)
				{
					self function_48dcad89();
					level notify(#"ee_pursue_complete");
					return;
				}
				self thread function_cfa09312(1);
			}
			else
			{
				self clientfield::increment("ee_anomaly_hit");
				self playsound("zmb_anomoly_reg_hit");
			}
		}
	}
}

/*
	Name: function_4b5b4aeb
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xB0ACC0F9
	Offset: 0xC610
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function function_4b5b4aeb(n_step)
{
	switch(n_step)
	{
		case 0:
		{
			level zm_stalingrad_vo::function_e4acaa37("vox_gers_anomaly_shoot_first_0", 0, 1, 0, 1);
			break;
		}
		case 1:
		{
			level zm_stalingrad_vo::function_e4acaa37("vox_gers_anomaly_shoot_second_0", 0, 1, 0, 1);
			break;
		}
		case 2:
		{
			level zm_stalingrad_vo::function_460341f9();
			break;
		}
	}
	level notify(#"hash_f9b2d970");
}

/*
	Name: function_182fe200
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xE1889F5
	Offset: 0xC6D0
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_182fe200()
{
	self endon(#"step_complete");
	self endon(#"pap_damage");
	wait(120);
	if(isdefined(self.var_44b9cab5) && self.var_44b9cab5)
	{
		return;
	}
	level notify(#"ee_pursue_failed");
	self notify(#"ee_pursue_failed");
	self clientfield::set("ee_anomaly_loop", 0);
	util::wait_network_frame();
	self delete();
}

/*
	Name: function_48dcad89
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x5A699582
	Offset: 0xC780
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_48dcad89()
{
	var_ded11e7d = struct::get("ee_pursue_pre_capture", "targetname");
	self moveto(var_ded11e7d.origin, 12, 1, 1);
	level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_anomaly_success_0", 2.5, 1, 0, 1);
	self waittill(#"movedone");
	self clientfield::set("ee_anomaly_loop", 0);
	var_ded11e7d struct::delete();
	level function_9c8afe2b();
	level function_2868b6f4();
	s_capture_point = struct::get("ee_capture_point", "targetname");
	self moveto(s_capture_point.origin + vectorscale((0, 0, 1), 48), 4, 0.5);
	self waittill(#"movedone");
	level thread function_694a61ea(self, 0);
	level zm_stalingrad_vo::function_7c3ff8b2();
}

/*
	Name: function_9aede4e6
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x559499EE
	Offset: 0xC930
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_9aede4e6()
{
	a_s_positions = struct::get_array("ee_pursue_position", "targetname");
	array::run_all(a_s_positions, &struct::delete);
	var_952f535d = struct::get_array("ee_pursue_arrival", "script_label");
	array::run_all(var_952f535d, &struct::delete);
}

/*
	Name: function_101e5b38
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xDD386E58
	Offset: 0xC9E0
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function function_101e5b38()
{
	/#
		level.var_8b2f7f24 = "";
	#/
	callback::on_connect(&function_4e70c56d);
	array::run_all(level.players, &function_4e70c56d);
	level thread function_c6ed1025();
	level function_94d0ca21();
	callback::remove_on_connect(&function_4e70c56d);
	level function_858f4a7e();
	level function_600265ae();
	/#
		if(isdefined(level.var_c91c0e41) && level.var_c91c0e41)
		{
			level.var_c91c0e41 = undefined;
			return;
		}
	#/
	var_46273a16 = struct::get("ee_koth_terminal_use", "targetname");
	var_46273a16 struct::delete();
	return true;
}

/*
	Name: function_c6ed1025
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x54C02FBB
	Offset: 0xCB38
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_c6ed1025()
{
	level zm_stalingrad_vo::function_e4acaa37("vox_soph_data_orders_0", 0, 1, 0, 1);
	level function_2868b6f4(0);
}

/*
	Name: function_94d0ca21
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xAB0A9071
	Offset: 0xCB88
	Size: 0x28C
	Parameters: 0
	Flags: Linked
*/
function function_94d0ca21()
{
	var_385ae3a2 = struct::get("ee_map_button_struct", "targetname");
	var_78d02c88 = getent("ee_map_shelf", "targetname");
	var_b465a89c = var_78d02c88 gettagorigin("wall_map_shelf_door");
	mdl_key = util::spawn_model("p7_zm_ctl_keycard_ee", var_b465a89c + (-5, 0, -2), vectorscale((1, 0, 0), 90));
	mdl_key linkto(var_78d02c88, "wall_map_shelf_door");
	var_78d02c88 scene::play("p7_fxanim_zm_stal_wall_map_drawer_open_bundle", var_78d02c88);
	level thread function_978eeda3();
	mdl_key function_6e3a6092(100, &"ZM_STALINGRAD_KEY_CARD");
	level notify(#"hash_b9c7ec1b");
	mdl_key playsound("zmb_scenario_torrent_key_grab");
	mdl_key delete();
	var_78d02c88 thread scene::play("p7_fxanim_zm_stal_wall_map_drawer_close_bundle", var_78d02c88);
	var_46273a16 = struct::get("ee_koth_terminal_use", "targetname");
	var_dc6bf246 = getent("ee_koth_terminal", "targetname");
	var_46273a16 thread function_7eac301b();
	var_dc6bf246 function_1a5b6f26();
	var_dc6bf246 function_9906da8b(1);
	zm_unitrigger::unregister_unitrigger(var_46273a16.s_unitrigger);
	var_46273a16.s_unitrigger = undefined;
	level thread function_b7beb50b();
}

/*
	Name: function_978eeda3
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x24B3B32C
	Offset: 0xCE20
	Size: 0x76
	Parameters: 0
	Flags: Linked
*/
function function_978eeda3()
{
	level endon(#"hash_b9c7ec1b");
	for(n_nag = 0; n_nag < 2; n_nag++)
	{
		wait(30);
		level thread zm_stalingrad_vo::function_e4acaa37(("vox_soph_data_take_disk_" + n_nag) + "_0");
	}
}

/*
	Name: function_9906da8b
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xE7C6939F
	Offset: 0xCEA0
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function function_9906da8b(var_9217ed20)
{
	if(var_9217ed20)
	{
		exploder::exploder("dataterminal_on");
		self showpart("tag_dragon_network_console_terminal_screen_green");
		self hidepart("tag_dragon_network_console_terminal_screen_red");
	}
	else
	{
		exploder::stop_exploder("dataterminal_on");
		self hidepart("tag_dragon_network_console_terminal_screen_green");
		self showpart("tag_dragon_network_console_terminal_screen_red");
	}
}

/*
	Name: function_7eac301b
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xD407E234
	Offset: 0xCF78
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_7eac301b()
{
	level endon(#"hash_8cc49f44");
	self zm_unitrigger::create_unitrigger("", 100, &function_20cd9521, &function_8e92625b);
	zm_unitrigger::unitrigger_force_per_player_triggers(self.s_unitrigger, 1);
	self.var_ef53764e = 1;
}

/*
	Name: function_20cd9521
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x4B592F
	Offset: 0xCFF8
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function function_20cd9521(e_player)
{
	if(e_player flag::get("ee_koth_terminal_used"))
	{
		return false;
	}
	return true;
}

/*
	Name: function_8e92625b
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x15680A25
	Offset: 0xD040
	Size: 0x198
	Parameters: 0
	Flags: Linked
*/
function function_8e92625b()
{
	self endon(#"death");
	var_46273a16 = self.stub.related_parent;
	while(true)
	{
		self waittill(#"trigger", e_who);
		if(isdefined(var_46273a16.var_ef53764e) && var_46273a16.var_ef53764e)
		{
			var_46273a16.var_ef53764e = undefined;
			var_46273a16.mdl_key = util::spawn_model("p7_zm_ctl_keycard_ee", var_46273a16.origin + (0.25, 13, -14.75), var_46273a16.angles + (vectorscale((1, -1, 0), 90)));
			var_46273a16.mdl_key playsound("zmb_scenario_torrent_key_insert");
			var_46273a16.mdl_key movey(4, 1);
		}
		var_46273a16.mdl_key playsound("zmb_scenarios_button_activate");
		e_who thread function_3f204480();
		e_who flag::set("ee_koth_terminal_used");
	}
}

/*
	Name: function_3f204480
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x60EDDE8E
	Offset: 0xD1E0
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_3f204480(s_unitrigger)
{
	self endon(#"death");
	self endon(#"hash_8cc49f44");
	var_a0411846 = getent("ee_koth_terminal_volume", "targetname");
	while(true)
	{
		if(!self istouching(var_a0411846))
		{
			self flag::clear("ee_koth_terminal_used");
			break;
		}
		wait(0.1);
	}
}

/*
	Name: function_1a5b6f26
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x7889D381
	Offset: 0xD290
	Size: 0x28A
	Parameters: 0
	Flags: Linked
*/
function function_1a5b6f26()
{
	level endon(#"end_game");
	for(i = 1; i <= 4; i++)
	{
		self clientfield::set("ee_koth_light_" + i, 1);
	}
	util::wait_network_frame();
	while(true)
	{
		var_693be8d4 = 4 - level.players.size;
		var_cb91e1e5 = 0;
		foreach(e_player in level.players)
		{
			if(e_player flag::get("ee_koth_terminal_used"))
			{
				var_693be8d4++;
			}
		}
		for(i = 1; i <= var_693be8d4; i++)
		{
			self clientfield::set("ee_koth_light_" + i, 2);
			self showpart("tag_dragon_network_console_terminal_light_green_0" + i);
			self hidepart("tag_dragon_network_console_terminal_light_red_0" + i);
			var_cb91e1e5++;
		}
		if(var_693be8d4 == 4)
		{
			break;
		}
		for(i = var_cb91e1e5 + 1; i <= 4; i++)
		{
			self clientfield::set("ee_koth_light_" + i, 1);
			self showpart("tag_dragon_network_console_terminal_light_red_0" + i);
			self hidepart("tag_dragon_network_console_terminal_light_green_0" + i);
		}
		wait(0.05);
	}
	level notify(#"hash_8cc49f44");
}

/*
	Name: function_b7beb50b
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x3E221F49
	Offset: 0xD528
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_b7beb50b()
{
	/#
		level endon(#"hash_9546144d");
	#/
	level.var_2cd0f4a0 = 180;
	level.var_cd867f7a = 0;
	/#
		if(isdefined(level.var_f9c3fe97) && level.var_f9c3fe97)
		{
			level.var_2cd0f4a0 = 5;
		}
	#/
	array::thread_all(level.players, &function_7ef0d0cc);
	level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_data_lockdown_0", 0, 1, 0, 1);
	var_700aab72 = 0;
	var_17c47d04 = getent("ee_koth_terminal", "targetname");
	var_17c47d04 playsound("zmb_scenario_torrent_start");
	var_17c47d04 playloopsound("zmb_scenario_torrent_lp", 3);
	while(level.var_cd867f7a < level.var_2cd0f4a0)
	{
		wait(1);
		level.var_cd867f7a++;
	}
	var_17c47d04 playsound("zmb_scenario_torrent_end");
	var_17c47d04 stoploopsound(0.5);
	level flag::set("ee_lockdown_complete");
}

/*
	Name: function_858f4a7e
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x34230BB9
	Offset: 0xD6D8
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function function_858f4a7e()
{
	/#
		level endon(#"hash_9546144d");
	#/
	if(zm_utility::get_number_of_valid_players() == 1)
	{
		var_5fa4ff40 = 3.75;
		var_2bb91d99 = zm_utility::get_number_of_valid_players() + 2;
		var_77e8a424 = var_2bb91d99 * 2;
	}
	else
	{
		if(zm_utility::get_number_of_valid_players() == 2)
		{
			var_5fa4ff40 = 2.5;
			var_2bb91d99 = zm_utility::get_number_of_valid_players() + 3;
			var_77e8a424 = var_2bb91d99 + (zm_utility::get_number_of_valid_players() * 2);
		}
		else
		{
			var_5fa4ff40 = 1.5;
			var_2bb91d99 = zm_utility::get_number_of_valid_players() + 4;
			var_77e8a424 = var_2bb91d99 * 2;
		}
	}
	level.var_141e2500 = 1;
	level function_e394c743(1);
	level zm_stalingrad_pap::function_2c6fd7(var_77e8a424, var_2bb91d99, var_5fa4ff40, "ee_lockdown_complete");
	level.var_141e2500 = undefined;
	level function_e394c743(0);
	level thread zm_stalingrad_vo::function_e4acaa37("vox_soph_data_success_0", 0, 1, 0, 1);
}

/*
	Name: function_600265ae
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x2C5B4959
	Offset: 0xD8A0
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function function_600265ae()
{
	var_dc6bf246 = getent("ee_koth_terminal", "targetname");
	var_dc6bf246 function_9906da8b(0);
	for(i = 1; i <= 4; i++)
	{
		var_dc6bf246 clientfield::set("ee_koth_light_" + i, 0);
		var_dc6bf246 showpart("tag_dragon_network_console_terminal_light_red_0" + i);
		var_dc6bf246 hidepart("tag_dragon_network_console_terminal_light_green_0" + i);
	}
	var_46273a16 = struct::get("ee_koth_terminal_use", "targetname");
	var_46273a16 function_6e3a6092(100, &"ZM_STALINGRAD_KEY_CARD");
	var_46273a16.mdl_key playsound("zmb_scenario_torrent_key_grab");
	var_46273a16.mdl_key delete();
	level function_d9d36a17("p7_zm_ctl_keycard_ee", &"ZM_STALINGRAD_KEY_CARD_DEPOSIT", (-90, 180, 0));
}

/*
	Name: function_e394c743
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x367951BE
	Offset: 0xDA60
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function function_e394c743(var_f2469810)
{
	foreach(e_player in level.players)
	{
		e_player clientfield::set_to_player("ee_lockdown_fog", var_f2469810);
	}
}

/*
	Name: function_7ef0d0cc
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xCA687986
	Offset: 0xDB08
	Size: 0xF6
	Parameters: 2
	Flags: Linked
*/
function function_7ef0d0cc(n_start_time, var_2cd0f4a0)
{
	self endon(#"death");
	self.usebar = self function_64a35779();
	self.usebartext = self function_73e24bb9();
	self.usebartext settext(&"ZM_STALINGRAD_DOWNLOAD_PROGRESS");
	self function_6199ca7e();
	if(isdefined(self.usebartext))
	{
		self.usebartext hud::destroyelem();
		self.usebartext = undefined;
	}
	if(isdefined(self.usebar))
	{
		self.usebar hud::destroyelem();
		self.usebar = undefined;
	}
}

/*
	Name: function_6199ca7e
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x98B15289
	Offset: 0xDC08
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_6199ca7e()
{
	self endon(#"death");
	level endon(#"ee_lockdown_complete");
	level endon(#"end_game");
	while(true)
	{
		n_progress = level.var_cd867f7a / level.var_2cd0f4a0;
		if(n_progress < 0)
		{
			n_progress = 0;
		}
		if(n_progress > 1)
		{
			n_progress = 1;
		}
		self.usebar hud::updatebar(n_progress);
		wait(0.05);
	}
}

/*
	Name: function_64a35779
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xAC6E49C
	Offset: 0xDCB0
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function function_64a35779()
{
	if(self issplitscreen())
	{
		var_2cf8c6d2 = -75;
		var_52fb413b = 205;
		var_cf35e8e9 = "TOP";
		var_16d3e5b2 = 80;
		var_cb7f5b1b = 5;
	}
	else
	{
		var_2cf8c6d2 = 0;
		var_52fb413b = 175;
		var_cf35e8e9 = "CENTER";
		var_16d3e5b2 = level.primaryprogressbarwidth;
		var_cb7f5b1b = level.primaryprogressbarheight;
	}
	bar = hud::createbar((1, 1, 1), var_16d3e5b2, var_cb7f5b1b);
	bar hud::setpoint(var_cf35e8e9, undefined, var_2cf8c6d2, var_52fb413b);
	return bar;
}

/*
	Name: function_73e24bb9
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x9C8E5380
	Offset: 0xDDC0
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_73e24bb9()
{
	if(self issplitscreen())
	{
		var_a84ec5dc = -75;
		var_ce514045 = 191;
		var_cf35e8e9 = "TOP";
		var_2efa8e9 = 1;
	}
	else
	{
		var_a84ec5dc = 0;
		var_ce514045 = 161;
		var_cf35e8e9 = "CENTER";
		var_2efa8e9 = level.primaryprogressbarfontsize;
	}
	text = hud::createfontstring("objective", var_2efa8e9);
	text hud::setpoint(var_cf35e8e9, undefined, var_a84ec5dc, var_ce514045);
	text.sort = -1;
	return text;
}

/*
	Name: function_4e70c56d
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x63168B20
	Offset: 0xDED0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_4e70c56d()
{
	self flag::init("ee_koth_terminal_used");
}

/*
	Name: function_914bd2ef
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x70D9E65
	Offset: 0xDF00
	Size: 0x274
	Parameters: 0
	Flags: Linked
*/
function function_914bd2ef()
{
	level flag::wait_till("scenarios_complete");
	level function_2868b6f4();
	level zm_stalingrad_vo::function_ececbc4b();
	var_c6ca3fd9 = util::spawn_model("veh_t7_dlc3_mech_nikolai_weapon_core", level.var_a090a655 gettagorigin("tag_weapon_cores") + (0, 3, 2));
	var_c6ca3fd9 setscale(0.75);
	level thread function_777295a0();
	level.var_a090a655 scene::play("p7_fxanim_zm_stal_computer_sophia_core_door_open_bundle");
	var_c6ca3fd9 function_6e3a6092(100, &"ZM_STALINGRAD_WEAPON_CORES");
	var_c6ca3fd9 delete();
	level notify(#"hash_deeb3634");
	level clientfield::set("sophia_intro_outro", 0);
	level thread function_4b5f4145();
	level thread function_957ac17d();
	var_e782bc88 = getent("ee_weapon_cores_volume", "targetname");
	level zm_stalingrad_util::function_f8043960(&function_2a7e8fc9, var_e782bc88);
	level zm_stalingrad_vo::function_732b874f();
	level flag::set("weapon_cores_delivered");
	var_af8a18df = struct::get("ee_sophia_struct", "targetname");
	zm_unitrigger::unregister_unitrigger(var_af8a18df.s_unitrigger);
	var_af8a18df struct::delete();
}

/*
	Name: function_777295a0
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x7FC06D4B
	Offset: 0xE180
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_777295a0()
{
	level zm_stalingrad_vo::function_e4acaa37("vox_soph_ascension_complete_resp_1_0", 0, 1, 0, 1);
	level function_2868b6f4(0);
}

/*
	Name: function_2a7e8fc9
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xE08C32DA
	Offset: 0xE1D0
	Size: 0x1B0
	Parameters: 0
	Flags: Linked
*/
function function_2a7e8fc9()
{
	self clientfield::increment_to_player("interact_rumble");
	var_7694d290 = util::spawn_model("veh_t7_dlc3_mech_nikolai_weapon_core", self.var_4bd1ce6b gettagorigin("j_ankle_2_ri_anim") - vectorscale((0, 0, 1), 2));
	var_7694d290 setscale(0.75);
	var_7694d290 linkto(self.var_4bd1ce6b, "j_ankle_2_ri_anim");
	self.var_4bd1ce6b thread function_69e4f202(var_7694d290);
	var_1f3ae034 = struct::get("ee_core_end_struct", "targetname");
	var_57ae0247 = self.var_4bd1ce6b getclosestpointonnavvolume(var_1f3ae034.origin, 100);
	self.var_4bd1ce6b setvehgoalpos(var_57ae0247, 1, 1);
	if(self.var_4bd1ce6b vehicle_ai::waittill_pathresult())
	{
		self.var_4bd1ce6b vehicle_ai::waittill_pathing_done();
	}
	var_7694d290 delete();
	return true;
}

/*
	Name: function_69e4f202
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x6966B2B1
	Offset: 0xE388
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_69e4f202(var_7694d290)
{
	var_7694d290 endon(#"death");
	self waittill(#"death");
	var_7694d290 delete();
}

/*
	Name: function_e0c4c3a8
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x2C3BFB39
	Offset: 0xE3D0
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function function_e0c4c3a8()
{
	level flag::wait_till("weapon_cores_delivered");
	level function_fa7fbd4c(0);
	while(!level.var_a090a655 zm_stalingrad_util::function_1af75b1b(500))
	{
		wait(1);
	}
	level function_2868b6f4();
	exploder::stop_exploder("fxexp_604");
	level zm_stalingrad_vo::function_6f2aecbd();
	level thread scene::play("p7_fxanim_zm_stal_computer_sophia_bundle");
	level thread zm_stalingrad_vo::function_ea234d37();
	level waittill(#"hash_34e4b03f");
	level.var_a090a655 thread scene::play("p7_fxanim_zm_stal_computer_sophia_leave_bundle");
	level.var_a090a655 waittill(#"hash_6c477355");
	exploder::exploder("ex_sophia_end");
	var_4c895b30 = getent("ee_sophia_clip", "targetname");
	var_4c895b30 connectpaths();
	var_4c895b30 movex(114, 1);
	level function_2868b6f4(0);
	level flag::set("sophia_escaped");
	var_4c895b30 waittill(#"movedone");
	var_4c895b30 disconnectpaths();
}

/*
	Name: function_d47c68fb
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x7E27A8E8
	Offset: 0xE5D8
	Size: 0x322
	Parameters: 0
	Flags: Linked
*/
function function_d47c68fb()
{
	level flag::wait_till("sophia_escaped");
	var_5f255c08 = getent("ee_hatch_collision", "targetname");
	var_5f255c08 thread function_a9e72613();
	var_465422bb = struct::get("ee_boss_start", "targetname");
	var_465422bb thread function_e957e3bc();
	var_47ee7db6 = getent("ee_veh_sewer_cam", "targetname");
	nd_path_start = getvehiclenode("ee_sewer_rail_start", "targetname");
	var_a9352214 = getent("ee_sewer_to_arena_trig", "targetname");
	var_a9352214.var_9469fd43 = 0;
	while(var_a9352214.var_9469fd43 < level.players.size)
	{
		var_a9352214 waittill(#"trigger", e_who);
		if(!(isdefined(e_who.var_a0a9409e) && e_who.var_a0a9409e))
		{
			var_a9352214.var_9469fd43++;
			dragon::dragon_boss_intro_init();
			e_who.var_a0a9409e = 1;
			e_who thread zm_stalingrad_util::function_5eeabbe0(var_47ee7db6, nd_path_start, undefined, "player_enter_boss_arena");
		}
	}
	var_a9352214 delete();
	level thread function_deda2d7a();
	level scene::init("p7_fxanim_zm_stal_computer_sophia_base_bundle");
	var_5f255c08 solid();
	var_1a085458 = getentarray("hatch_slick_clip", "targetname");
	foreach(var_1a11e11 in var_1a085458)
	{
		var_1a11e11 delete();
		util::wait_network_frame();
	}
}

/*
	Name: function_a9e72613
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xFBBA6A22
	Offset: 0xE908
	Size: 0x220
	Parameters: 0
	Flags: Linked
*/
function function_a9e72613()
{
	var_af81398 = getent("ee_sewer_hatch_trig", "targetname");
	while(true)
	{
		if(var_af81398 function_2b042a95())
		{
			n_end_time = gettime() + (1 * 1000);
			wait(0.25);
			while(var_af81398 function_2b042a95())
			{
				if(gettime() >= n_end_time)
				{
					level thread function_2868b6f4(1, undefined, 0);
					self clientfield::set("ee_hatch_break_rumble", 1);
					level thread scene::play("p7_fxanim_zm_stal_computer_sophia_base_bundle");
					var_1a085458 = getentarray("hatch_slick_clip", "targetname");
					array::run_all(var_1a085458, &solid);
					foreach(e_player in level.players)
					{
						e_player.var_fa6d2a24 = 1;
					}
					wait(0.25);
					self notsolid();
					var_af81398 delete();
					return;
				}
				wait(0.25);
			}
		}
		wait(0.25);
	}
}

/*
	Name: function_2b042a95
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xBED68238
	Offset: 0xEB30
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function function_2b042a95()
{
	foreach(e_player in level.players)
	{
		if(!isalive(e_player) || !e_player istouching(self))
		{
			return false;
		}
		if(!(isdefined(e_player.var_35ea5b31) && e_player.var_35ea5b31))
		{
			e_player thread function_61f148a5(self);
		}
	}
	return true;
}

/*
	Name: function_61f148a5
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xCB0D7944
	Offset: 0xEC30
	Size: 0x9E
	Parameters: 1
	Flags: Linked
*/
function function_61f148a5(var_af81398)
{
	self endon(#"death");
	self.var_35ea5b31 = 1;
	self clientfield::set_to_player("ee_hatch_strain_rumble", 1);
	while(isdefined(var_af81398) && self istouching(var_af81398))
	{
		wait(0.4);
	}
	self clientfield::set_to_player("ee_hatch_strain_rumble", 0);
	self.var_35ea5b31 = undefined;
}

/*
	Name: function_deda2d7a
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x1988AB3A
	Offset: 0xECD8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_deda2d7a()
{
	if(!level flag::get("dragon_hazard_armory_once"))
	{
		level flag::set("dragon_hazard_armory_once");
		level scene::play("p7_fxanim_zm_stal_letters_a_r_bundle");
	}
}

/*
	Name: function_e957e3bc
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x89876976
	Offset: 0xED48
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_e957e3bc()
{
	level waittill(#"player_enter_boss_arena");
	level flag::set("players_in_arena");
	level thread function_2868b6f4(0);
	level thread zm_stalingrad_vo::function_e4acaa37("vox_nik1_help_nikolai_cores_1", 2);
	level zm_zonemgr::enable_zone("boss_arena_zone");
	self function_6e3a6092();
	playsoundatposition("zmb_scenarios_button_activate", self.origin);
	self struct::delete();
	level function_d6702e87();
	level thread zm_stalingrad_vo::function_e8e9cba8();
	level dragon::function_63326db4(0);
}

/*
	Name: function_d6702e87
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xAE96485
	Offset: 0xEE70
	Size: 0x1D2
	Parameters: 0
	Flags: Linked
*/
function function_d6702e87()
{
	mdl_head = getent("robot_head_clocktower", "targetname");
	var_2e8d47d3 = mdl_head.angles;
	var_86cbea2c = var_2e8d47d3 + (0, -28, -50);
	mdl_head rotateto(var_86cbea2c, 3, 0.5, 0.1);
	mdl_head playsound("zmb_robo_eye_head_move");
	mdl_head waittill(#"rotatedone");
	mdl_head playsound("zmb_robo_eye_head_start");
	mdl_head playloopsound("zmb_robo_eye_head_lp", 1.5);
	exploder::exploder("fxexp_700");
	wait(5);
	exploder::stop_exploder("fxexp_700");
	mdl_head playsound("zmb_robo_eye_head_stop");
	mdl_head stoploopsound(1);
	wait(1);
	mdl_head rotateto(var_2e8d47d3, 3, 0.5, 0.1);
	mdl_head playsound("zmb_robo_eye_head_move");
	wait(1);
}

/*
	Name: ee_outro
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xCF5EC7FF
	Offset: 0xF050
	Size: 0x2EC
	Parameters: 2
	Flags: Linked
*/
function ee_outro(n_wait = 0, var_d15ef3dd = 0)
{
	level function_2868b6f4(1, undefined, 0);
	level.var_2801f599 = int(((level.time - level.n_gameplay_start_time) + 500) / 1000);
	level clientfield::set("quest_complete_time", level.var_2801f599);
	if(var_d15ef3dd)
	{
		level scene::init("cin_sta_outro_3rd_sh020");
		level util::streamer_wait(undefined, 0.2, 15);
	}
	wait(n_wait);
	level notify(#"hash_6460283a");
	level zm_stalingrad_vo::function_6f2aecbd();
	level function_184114b9(undefined);
	if(!var_d15ef3dd)
	{
		level.var_cf6e9729.var_fa4643fb delete();
		level.var_cf6e9729 delete();
	}
	level function_6adaea27(0);
	zombie_utility::clear_all_corpses();
	level scene::add_scene_func("cin_sta_outro_3rd_sh020", &function_f3e1bda1);
	level scene::add_scene_func("cin_sta_outro_3rd_sh080", &function_f3e1bda1);
	level scene::add_scene_func("cin_sta_outro_3rd_sh132", &function_9c290325);
	level notify(#"hash_9b1cee4c");
	level scene::play("cin_sta_outro_3rd_sh020");
	level waittill(#"hash_196dc11");
	wait(7.5);
	level function_f885ecc6();
	level function_6adaea27(1);
	var_206fd092 = getent("mech", "targetname");
	var_206fd092 clientfield::set("post_outro_smoke", 1);
	level thread function_146501();
}

/*
	Name: function_184114b9
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xC1650C76
	Offset: 0xF348
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_184114b9(var_fdc919d5)
{
	level lui::screen_fade_out(0.2, "white", "pause_regular_zombies");
	level util::delay(0.7, undefined, &lui::screen_fade_in, 1, "white", "pause_regular_zombies");
}

/*
	Name: function_6adaea27
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x3F39937C
	Offset: 0xF3D0
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function function_6adaea27(b_show)
{
	if(b_show && isdefined(level.var_4d36bcd5))
	{
		level.var_4d36bcd5 zm_magicbox::show_chest();
		level.var_4d36bcd5 = undefined;
		return;
	}
	if(!b_show)
	{
		foreach(s_chest in level.chests)
		{
			if(s_chest.hidden === 0)
			{
				level.var_4d36bcd5 = s_chest;
				s_chest zm_magicbox::hide_chest();
				return;
			}
		}
	}
}

/*
	Name: function_f3e1bda1
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x2D1090D7
	Offset: 0xF4D8
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function function_f3e1bda1(a_ents)
{
	var_206fd092 = a_ents["mech"];
	var_206fd092 hidepart("tag_heat_vent_01_d0");
	var_206fd092 hidepart("tag_heat_vent_02_d0");
	var_206fd092 hidepart("tag_heat_vent_03_d0");
	var_206fd092 hidepart("tag_heat_vent_04_d0");
	var_206fd092 hidepart("tag_heat_vent_05_d0");
	var_206fd092 hidepart("tag_heat_vent_05_d1");
}

/*
	Name: function_9c290325
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x9C6E9453
	Offset: 0xF5C8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_9c290325(a_ents)
{
	level waittill(#"hash_83582d4d");
	level lui::screen_fade_out(0, "black");
	level waittill(#"hash_b512f707");
	level lui::screen_fade_in(2, "black");
}

/*
	Name: function_146501
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xDD09B5B4
	Offset: 0xF638
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_146501()
{
	level thread zm_stalingrad_util::function_e7c75cf0();
	wait(1);
	foreach(e_player in level.activeplayers)
	{
		e_player thread zm_utility::give_player_all_perks();
		e_player thread function_aa34f039();
		e_player.var_4222bc21 = 0;
	}
	level thread zm_stalingrad_timer::function_3d5b5002();
	level notify(#"hash_c1471acf");
	level zm_stalingrad_vo::function_568549ce();
	level function_2868b6f4(0);
}

/*
	Name: function_aa34f039
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x54DCE28C
	Offset: 0xF760
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_aa34f039()
{
	level scoreevents::processscoreevent("main_EE_quest_stalingrad", self);
	self zm_stats::increment_global_stat("DARKOPS_STALINGRAD_EE");
	self zm_stats::increment_global_stat("DARKOPS_STALINGRAD_SUPER_EE");
}

/*
	Name: function_f885ecc6
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x72E02F54
	Offset: 0xF7D0
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_f885ecc6()
{
	lui::prime_movie("zm_stalingrad", 0, "VIvR+pb5utWUBysldVJJQSj+DhzuxPYKm2r8qvF0IaIAAAAAAAAAAA==");
	function_1c04ad71(1);
	level lui::screen_fade_out(0.25);
	playsoundatposition("zmb_outro_tbc_start", (0, 0, 0));
	level notify(#"hash_19aa582d");
	level waittill(#"hash_cefef17d");
	level lui::play_movie("zm_stalingrad", "fullscreen", 0, 0, "VIvR+pb5utWUBysldVJJQSj+DhzuxPYKm2r8qvF0IaIAAAAAAAAAAA==");
	level lui::screen_fade_in(1);
	function_1c04ad71(0);
}

/*
	Name: function_1c04ad71
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x1B311167
	Offset: 0xF8D8
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function function_1c04ad71(var_a5efd39d = 1)
{
	foreach(e_player in level.activeplayers)
	{
		if(var_a5efd39d)
		{
			e_player enableinvulnerability();
		}
		else
		{
			e_player disableinvulnerability();
		}
		e_player util::freeze_player_controls(var_a5efd39d);
	}
}

/*
	Name: function_7e02b332
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xA103F37B
	Offset: 0xF9C8
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function function_7e02b332(a_ents, b_open)
{
	/#
		zm_stalingrad_util::function_4da6e8(b_open);
	#/
}

/*
	Name: function_6e3a6092
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x97237FDD
	Offset: 0xFA00
	Size: 0x140
	Parameters: 3
	Flags: Linked
*/
function function_6e3a6092(n_trigger_radius = 100, str_hint = "", var_6902ec85 = 1)
{
	if(!isdefined(self.s_unitrigger))
	{
		self zm_unitrigger::create_unitrigger(str_hint, n_trigger_radius, &function_44423ea2);
	}
	else
	{
		self.s_unitrigger function_527f47cc(str_hint);
	}
	self waittill(#"trigger_activated", e_who);
	e_who clientfield::increment_to_player("interact_rumble");
	if(var_6902ec85)
	{
		zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
		self.s_unitrigger = undefined;
	}
	else
	{
		self.s_unitrigger function_527f47cc("");
	}
	return e_who;
}

/*
	Name: function_527f47cc
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x319E872C
	Offset: 0xFB48
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_527f47cc(str_hint)
{
	self.hint_string = str_hint;
	self zm_unitrigger::run_visibility_function_for_all_triggers();
}

/*
	Name: function_44423ea2
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x2841FAAD
	Offset: 0xFB80
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function function_44423ea2(e_player)
{
	self sethintstring(self.stub.hint_string);
	return true;
}

/*
	Name: function_a73ce57c
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x2C828521
	Offset: 0xFBC0
	Size: 0x46
	Parameters: 1
	Flags: None
*/
function function_a73ce57c(e_player)
{
	if(e_player function_85d05129(self.stub.related_parent.origin))
	{
		return true;
	}
	return false;
}

/*
	Name: function_85d05129
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x55164874
	Offset: 0xFC10
	Size: 0xCA
	Parameters: 4
	Flags: Linked
*/
function function_85d05129(origin, arc_angle_degrees = 10, do_trace = 0, e_ignore)
{
	arc_angle_degrees = absangleclamp360(arc_angle_degrees);
	dot = cos(arc_angle_degrees * 0.5);
	if(self util::is_player_looking_at(origin, dot, do_trace, e_ignore))
	{
		return true;
	}
	return false;
}

/*
	Name: function_92de7ae0
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x1A97A136
	Offset: 0xFCE8
	Size: 0x3E
	Parameters: 0
	Flags: Linked
*/
function function_92de7ae0()
{
	if(zm_zonemgr::any_player_in_zone("judicial_A_zone") || zm_zonemgr::any_player_in_zone("judicial_B_zone"))
	{
		return true;
	}
	return false;
}

/*
	Name: function_9c8afe2b
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x63933946
	Offset: 0xFD30
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function function_9c8afe2b()
{
	while(!function_92de7ae0())
	{
		wait(2);
	}
}

/*
	Name: function_eaf82313
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xA703650B
	Offset: 0xFD58
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function function_eaf82313()
{
	while(true)
	{
		if(function_92de7ae0())
		{
			e_richtofen = zm_stalingrad_vo::function_fcea1c5c();
			if(isdefined(e_richtofen) && zm_utility::is_player_valid(e_richtofen))
			{
				var_2040fa70 = e_richtofen zm_utility::get_current_zone();
				if(!isdefined(var_2040fa70))
				{
					return;
				}
				if(var_2040fa70 != "judicial_A_zone" && var_2040fa70 != "judicial_B_zone" && var_2040fa70 != "judicial_street_zone" && var_2040fa70 != "judicial_street_b_zone")
				{
					return;
				}
			}
			return;
		}
		wait(2);
	}
}

/*
	Name: function_694a61ea
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x7005C142
	Offset: 0xFE48
	Size: 0x1CC
	Parameters: 2
	Flags: Linked
*/
function function_694a61ea(e_grabbed, var_c57c38fc = 1)
{
	if(var_c57c38fc)
	{
		util::magic_bullet_shield(e_grabbed);
	}
	exploder::exploder("fxexp_900");
	e_grabbed playsound("zmb_scenario_magneto_fx_start");
	e_grabbed playloopsound("zmb_scenario_magneto_fx_lp", 0.5);
	wait(2);
	level thread scene::play("p7_fxanim_zm_stal_raz_cage_sentinel_grab_bundle");
	level waittill(#"hash_d0ec645d");
	e_grabbed unlink();
	e_grabbed stoploopsound(0.5);
	e_grabbed playsound("zmb_scenario_magneto_fx_stop");
	exploder::stop_exploder("fxexp_900");
	var_bf681731 = getent("raz_cage", "targetname");
	e_grabbed linkto(var_bf681731, "link_jnt");
	level waittill(#"hash_2850c4f2");
	if(var_c57c38fc)
	{
		util::stop_magic_bullet_shield(e_grabbed);
	}
	e_grabbed delete();
}

/*
	Name: function_2868b6f4
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xE465EB91
	Offset: 0x10020
	Size: 0xE4
	Parameters: 3
	Flags: Linked
*/
function function_2868b6f4(b_pause = 1, var_c7f6657d = &function_3d1cdcf3, var_455239a2 = 1)
{
	if(b_pause)
	{
		level thread function_bbbebba6();
		if(isdefined(var_c7f6657d) && (isdefined(var_455239a2) && var_455239a2))
		{
			[[var_c7f6657d]]();
		}
	}
	else
	{
		level notify(#"hash_e8e96c72");
		level.disable_nuke_delay_spawning = 0;
		level flag::set("spawn_zombies");
	}
}

/*
	Name: function_bbbebba6
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x144DAB85
	Offset: 0x10110
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_bbbebba6()
{
	level endon(#"hash_e8e96c72");
	if(!level flag::get("spawn_zombies") && !level flag::get("lockdown_active"))
	{
		level flag::wait_till("spawn_zombies");
	}
	level.disable_nuke_delay_spawning = 1;
	level flag::clear("spawn_zombies");
	level zm_stalingrad_util::function_adf4d1d0();
}

/*
	Name: function_3d1cdcf3
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xDF433CFC
	Offset: 0x101C8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_3d1cdcf3()
{
	level thread lui::screen_flash(0.2, 0.5, 1, 0.8, "white");
	playsoundatposition("zmb_scenarios_whiteflash", (0, 0, 0));
	wait(0.5);
}

/*
	Name: function_15d9679d
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xCAFF7E96
	Offset: 0x10240
	Size: 0xE6
	Parameters: 2
	Flags: Linked
*/
function function_15d9679d(str_location, var_f48714a)
{
	var_cf5f1519 = getent("ee_map", "targetname");
	for(i = 0; i < var_f48714a; i++)
	{
		str_tag = "tag_map_screen_glow_" + str_location;
		wait(0.5);
		var_cf5f1519 showpart(str_tag);
		var_cf5f1519 playsound("zmb_scenarios_map_beep_higher");
		wait(0.75);
		var_cf5f1519 hidepart(str_tag);
	}
}

/*
	Name: function_d9d36a17
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xC6448E8E
	Offset: 0x10330
	Size: 0x1CC
	Parameters: 4
	Flags: Linked
*/
function function_d9d36a17(str_model, str_hint, v_angles = (0, 0, 0), var_c991b769 = (0, 0, 0))
{
	while(!level.var_a090a655 zm_stalingrad_util::function_1af75b1b(250))
	{
		wait(0.5);
	}
	level.var_a090a655 scene::play("p7_fxanim_zm_stal_computer_sophia_drawer_open_bundle");
	var_af8a18df = struct::get("ee_sophia_struct", "targetname");
	var_af8a18df function_6e3a6092(100, str_hint, 0);
	var_51a2f105 = level.var_a090a655 gettagorigin("drawer_link_jnt");
	var_b71f6be1 = util::spawn_model(str_model, var_51a2f105 + var_c991b769, v_angles);
	var_b71f6be1 linkto(level.var_a090a655, "drawer_link_jnt");
	var_b71f6be1 playsound("zmb_scenarios_sophia_drawer_return");
	wait(1);
	level.var_a090a655 scene::play("p7_fxanim_zm_stal_computer_sophia_drawer_close_bundle");
	var_b71f6be1 delete();
}

/*
	Name: function_67cef48
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xD7F34523
	Offset: 0x10508
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function function_67cef48(b_show)
{
	var_78d02c88 = getent("ee_map_shelf", "targetname");
	if(b_show)
	{
		var_78d02c88 showpart("wall_map_shelf_button_green");
		var_78d02c88 hidepart("wall_map_shelf_button_red");
		var_78d02c88 playsound("zmb_scenarios_button_activate");
	}
	else
	{
		var_78d02c88 hidepart("wall_map_shelf_button_green");
		var_78d02c88 showpart("wall_map_shelf_button_red");
	}
}

/*
	Name: function_fa7fbd4c
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x9187D9CF
	Offset: 0x105F0
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function function_fa7fbd4c(b_show)
{
	if(b_show)
	{
		level.var_a090a655 showpart("button_green_jnt");
		level.var_a090a655 hidepart("button_red_jnt");
		level.var_a090a655 playsound("zmb_scenarios_button_activate");
	}
	else
	{
		level.var_a090a655 hidepart("button_green_jnt");
		level.var_a090a655 showpart("button_red_jnt");
	}
}

/*
	Name: function_d6026710
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xBEBC5935
	Offset: 0x106B8
	Size: 0x7EC
	Parameters: 0
	Flags: Linked
*/
function function_d6026710()
{
	/#
		level thread function_a1f6ef06("", "", 1, &function_4fdd3e35);
		level thread function_a1f6ef06("", "", 1, &function_2ce0ea3d);
		level thread function_a1f6ef06("", "", 1, &function_96a879de);
		level thread function_a1f6ef06("", "", 1, &function_453d1020);
		level thread function_a1f6ef06("", "", 1, &function_43beec5a);
		level thread function_a1f6ef06("", "", 1, &function_5879102a);
		level thread function_a1f6ef06("", "", 1, &function_2be548b9);
		level thread function_a1f6ef06("", "", 1, &function_8265c377);
		level thread function_a1f6ef06("", "", 1, &function_da01ea0);
		level thread function_a1f6ef06("", "", 1, &function_d95ba8e4);
		level thread function_a1f6ef06("", "", 1, &function_81799b1b);
		level thread function_a1f6ef06("", "", 1, &function_15b02c6d);
		level thread function_a1f6ef06("", "", 1, &function_f8be6f86);
		level thread function_a1f6ef06("", "", 1, &function_126d3a92);
		level thread function_a1f6ef06("", "", 1, &function_1b02c173);
		level thread function_a1f6ef06("", "", 1, &function_98be294);
		level thread function_a1f6ef06("", "", 1, &function_90a2468c);
		level thread function_a1f6ef06("", "", 1, &function_63ef4ccd);
		level thread function_a1f6ef06("", "", 1, &function_474a5f0);
		level thread function_a1f6ef06("", "", 1, &function_d810756e);
		level thread function_a1f6ef06("", "", 1, &function_400ba4a5);
		level thread function_a1f6ef06("", "", 1, &function_c25033fa);
		level thread function_a1f6ef06("", "", 1, &function_e6dcb4c9);
		level thread function_a1f6ef06("", "", 1, &function_e7aa9b86);
		level thread function_a1f6ef06("", "", 1, &function_9d07a3ef);
		level thread function_a1f6ef06("", "", 1, &function_67c46c97);
		level thread function_a1f6ef06("", "", 1, &function_bbf6c2d0);
		level thread function_a1f6ef06("", "", 1, &function_22557cc3);
		level thread function_a1f6ef06("", "", 1, &function_3de60ba3);
		level thread function_a1f6ef06("", "", 1, &function_4f92d875);
		level thread function_a1f6ef06("", "", 1, &function_9b3c25cd);
		level thread function_a1f6ef06("", "", 1, &function_ff112fdc);
		level thread function_a1f6ef06("", "", 1, &function_5446a1da);
		level thread function_a1f6ef06("", "", 1, &function_10f1fb15);
		level thread function_a1f6ef06("", "", 1, &function_9cde71dd);
		level thread function_a1f6ef06("", "", 1, &function_bd5b4406);
	#/
}

/*
	Name: function_4fdd3e35
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xB55F671D
	Offset: 0x10EB0
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function function_4fdd3e35(n_value)
{
	/#
		if(!(isdefined(level.var_f9c3fe97) && level.var_f9c3fe97))
		{
			level.var_f9c3fe97 = 1;
		}
		else
		{
			level.var_f9c3fe97 = undefined;
		}
	#/
}

/*
	Name: function_2ce0ea3d
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xF42B41A9
	Offset: 0x10F00
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_2ce0ea3d(n_value)
{
	/#
		level flag::set("");
	#/
}

/*
	Name: function_96a879de
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x73F4B8E7
	Offset: 0x10F38
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_96a879de(n_value)
{
	/#
		level flag::set("");
		level function_ef39c304(1);
	#/
}

/*
	Name: function_453d1020
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xDA12D6CD
	Offset: 0x10F88
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_453d1020(n_value)
{
	/#
		level flag::set("");
		wait(0.5);
		level flag::set("");
	#/
}

/*
	Name: function_43beec5a
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x7B2EA9D4
	Offset: 0x10FE8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_43beec5a(n_value)
{
	/#
		level flag::set("");
	#/
}

/*
	Name: function_5879102a
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x3ABD89BD
	Offset: 0x11020
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_5879102a(n_value)
{
	/#
		level notify(#"hash_72a2fa02");
		level flag::set("");
	#/
}

/*
	Name: function_2be548b9
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x2EF0E6A4
	Offset: 0x11068
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_2be548b9(n_value)
{
	/#
		level notify(#"hash_72a2fa02");
		level flag::set("");
	#/
}

/*
	Name: function_da01ea0
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xB5DDBB79
	Offset: 0x110B0
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_da01ea0(n_value)
{
	/#
		level function_3cce99fb(&function_4769ea02);
	#/
}

/*
	Name: function_d95ba8e4
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x6725001F
	Offset: 0x110F0
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_d95ba8e4(n_value)
{
	/#
		level function_3cce99fb(&function_f5139aae);
	#/
}

/*
	Name: function_81799b1b
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x552187F4
	Offset: 0x11130
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_81799b1b(n_value)
{
	/#
		level function_3cce99fb(&function_62f0a233);
	#/
}

/*
	Name: function_15b02c6d
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x8C2D32F8
	Offset: 0x11170
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_15b02c6d(n_value)
{
	/#
		level function_3cce99fb(&function_6a1cc377);
	#/
}

/*
	Name: function_f8be6f86
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xDE07706B
	Offset: 0x111B0
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_f8be6f86(n_value)
{
	/#
		level function_3cce99fb(&function_21284834);
	#/
}

/*
	Name: function_126d3a92
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x626F0643
	Offset: 0x111F0
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_126d3a92(n_value)
{
	/#
		level function_3cce99fb(&function_101e5b38);
	#/
}

/*
	Name: function_3cce99fb
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xCB6D6FE8
	Offset: 0x11230
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_3cce99fb(var_ad364454)
{
	/#
		level.var_c91c0e41 = 1;
		level function_2868b6f4();
		[[var_ad364454]]();
		level function_2868b6f4(0);
	#/
}

/*
	Name: function_98be294
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x3208CD29
	Offset: 0x11290
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_98be294(n_value)
{
	/#
		if(isdefined(level.var_9f752812))
		{
			level.var_9f752812 thread zm_utility::print3d_ent("", (0, 1, 0), 3, vectorscale((0, 0, 1), 24));
		}
	#/
}

/*
	Name: function_1b02c173
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x9FF44DD2
	Offset: 0x112F0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_1b02c173(n_value)
{
	/#
		if(isdefined(level.var_a5fb1d00))
		{
			level.var_a5fb1d00.health = 99999;
			level.var_a5fb1d00 thread zm_utility::print3d_ent("", (0, 1, 0), 3, vectorscale((0, 0, 1), 24));
		}
	#/
}

/*
	Name: function_90a2468c
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x7295E196
	Offset: 0x11368
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function function_90a2468c(n_value)
{
	/#
		var_4af7b97 = array("", "", "", "", "", "");
		var_4af7b97 = array::randomize(var_4af7b97);
		level function_18375f27(var_4af7b97);
	#/
}

/*
	Name: function_63ef4ccd
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x78209B1
	Offset: 0x11408
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_63ef4ccd(n_value)
{
	/#
		level.var_c47b244 = function_c5c5f391("", 1);
	#/
}

/*
	Name: function_474a5f0
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x31783E83
	Offset: 0x11448
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_474a5f0(n_value)
{
	/#
		level.var_c47b244 = function_c5c5f391("", 2);
	#/
}

/*
	Name: function_d810756e
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x25A826C6
	Offset: 0x11488
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_d810756e(n_value)
{
	/#
		level.var_c47b244 = function_c5c5f391("", 1);
	#/
}

/*
	Name: function_400ba4a5
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x24B71C0
	Offset: 0x114C8
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_400ba4a5(n_value)
{
	/#
		level.var_c47b244 = function_c5c5f391("", 2);
	#/
}

/*
	Name: function_c25033fa
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xFCCCCF13
	Offset: 0x11508
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_c25033fa(n_value)
{
	/#
		level.var_c47b244 = function_c5c5f391("", 1);
	#/
}

/*
	Name: function_e6dcb4c9
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x804E1B56
	Offset: 0x11548
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_e6dcb4c9(n_value)
{
	/#
		level.var_c47b244 = function_c5c5f391("", 2);
	#/
}

/*
	Name: function_c5c5f391
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xDDA9C8CE
	Offset: 0x11588
	Size: 0xEC
	Parameters: 2
	Flags: Linked
*/
function function_c5c5f391(str_location, n_position)
{
	/#
		var_afe8026c = struct::get_array("", "");
		foreach(s_pod in var_afe8026c)
		{
			if(s_pod.script_string == str_location && s_pod.script_int == n_position)
			{
				return s_pod;
			}
		}
	#/
}

/*
	Name: function_8265c377
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x4ED5E075
	Offset: 0x11680
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function function_8265c377(n_value)
{
	/#
		var_fc275254 = ("" + level.var_8b2f7f24) + "";
		level notify(var_fc275254);
		level notify(#"hash_9546144d");
	#/
}

/*
	Name: function_e7aa9b86
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x15F7689E
	Offset: 0x116D8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_e7aa9b86(n_value)
{
	/#
		level notify(#"hash_7f7ecb53");
		level flag::set("");
	#/
}

/*
	Name: function_9d07a3ef
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xCB218142
	Offset: 0x11720
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_9d07a3ef(n_value)
{
	/#
		level notify(#"hash_dae10c73");
		level notify(#"hash_deeb3634");
		level clientfield::set("", 0);
		level flag::set("");
	#/
}

/*
	Name: function_67c46c97
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x844F44F8
	Offset: 0x11798
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_67c46c97(n_value)
{
	/#
		level flag::set("");
	#/
}

/*
	Name: function_bbf6c2d0
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x6A290808
	Offset: 0x117D0
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_bbf6c2d0(n_value)
{
	/#
		level notify(#"hash_dfaade1d");
		if(isdefined(level.var_357a65b))
		{
			level.var_357a65b scene::stop();
			level.var_357a65b delete();
			level.var_357a65b = undefined;
		}
		level ee_outro(0, 1);
	#/
}

/*
	Name: function_22557cc3
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x36A395BB
	Offset: 0x11860
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function function_22557cc3(n_value)
{
	/#
		level notify(#"hash_deeb3634");
		level clientfield::set("", 0);
		exploder::stop_exploder("");
		level thread scene::play("");
		level thread zm_stalingrad_vo::function_ea234d37();
		level waittill(#"hash_34e4b03f");
		level.var_a090a655 scene::play("");
	#/
}

/*
	Name: function_ff112fdc
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x83509C8B
	Offset: 0x11928
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_ff112fdc(n_value)
{
	/#
		level function_d6702e87();
	#/
}

/*
	Name: function_3de60ba3
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xE1B3A5AF
	Offset: 0x11958
	Size: 0xC2
	Parameters: 1
	Flags: Linked
*/
function function_3de60ba3(n_value)
{
	/#
		var_7953b28 = getentarray("", "");
		foreach(mdl_button in var_7953b28)
		{
			mdl_button thread function_2ffdc89();
		}
	#/
}

/*
	Name: function_2ffdc89
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xFBF9E728
	Offset: 0x11A28
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_2ffdc89()
{
	/#
		self scene::play("", array(self));
		wait(5);
		self scene::play("", array(self));
	#/
}

/*
	Name: function_4f92d875
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xB0854F98
	Offset: 0x11AA0
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function function_4f92d875(n_value)
{
	/#
		s_capture_point = struct::get("", "");
		var_663b2442 = zombie_utility::spawn_zombie(level.var_fda4b3f3[0], "", s_capture_point);
		var_663b2442 vehicle_ai::set_state("");
		var_663b2442 sentinel_drone::sentinel_destroyallarms(1);
		var_663b2442.origin = s_capture_point.origin + vectorscale((0, 0, 1), 30);
		wait(1);
		function_694a61ea(var_663b2442);
	#/
}

/*
	Name: function_9b3c25cd
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x3FA60669
	Offset: 0x11BA0
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function function_9b3c25cd(n_value)
{
	/#
		s_capture_point = struct::get("", "");
		var_1c963231 = zombie_utility::spawn_zombie(level.var_6bca5baa[0], "", s_capture_point);
		var_1c963231 ai::set_ignoreall(1);
		wait(1);
		function_694a61ea(var_1c963231);
	#/
}

/*
	Name: function_5446a1da
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xD63BCCAC
	Offset: 0x11C60
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_5446a1da(n_value)
{
	/#
		exploder::exploder("");
	#/
}

/*
	Name: function_10f1fb15
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x76ED46ED
	Offset: 0x11C98
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_10f1fb15(n_value)
{
	/#
		exploder::exploder("");
	#/
}

/*
	Name: function_9cde71dd
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x81053BC8
	Offset: 0x11CD0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_9cde71dd(n_value)
{
	/#
		exploder::exploder("");
	#/
}

/*
	Name: function_bd5b4406
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xE22DFDE6
	Offset: 0x11D08
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_bd5b4406(n_value)
{
	/#
		exploder::exploder("");
	#/
}

/*
	Name: function_a1f6ef06
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xB72CF780
	Offset: 0x11D40
	Size: 0x130
	Parameters: 5
	Flags: Linked
*/
function function_a1f6ef06(str_devgui_path, str_dvar, n_value, func, n_base_value)
{
	/#
		if(!isdefined(n_base_value))
		{
			n_base_value = -1;
		}
		setdvar(str_dvar, n_base_value);
		str_devgui_path = "" + str_devgui_path;
		adddebugcommand(((((("" + str_devgui_path) + "") + str_dvar) + "") + n_value) + "");
		while(true)
		{
			n_dvar = getdvarint(str_dvar);
			if(n_dvar > n_base_value)
			{
				[[func]](n_dvar);
				setdvar(str_dvar, n_base_value);
			}
			util::wait_network_frame();
		}
	#/
}

