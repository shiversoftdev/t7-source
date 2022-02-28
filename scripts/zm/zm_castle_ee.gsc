// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_castle_dogs;
#using scripts\zm\zm_castle_mechz;
#using scripts\zm\zm_castle_teleporter;
#using scripts\zm\zm_castle_util;
#using scripts\zm\zm_castle_vo;
#using scripts\zm\zm_castle_weap_quest_upgrade;

#namespace zm_castle_ee;

/*
	Name: main
	Namespace: zm_castle_ee
	Checksum: 0x86A3762D
	Offset: 0x1858
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	init_flags();
	register_clientfields();
	function_70b74a2d();
	/#
		if(getdvarint("") > 0)
		{
			level thread function_d6026710();
		}
	#/
}

/*
	Name: register_clientfields
	Namespace: zm_castle_ee
	Checksum: 0x2A5889F8
	Offset: 0x18D0
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	n_bits = getminbitcountfornum(4);
	clientfield::register("toplayer", "player_ee_cs_circle", 5000, n_bits, "int");
	clientfield::register("actor", "ghost_actor", 1, 1, "int");
	clientfield::register("scriptmover", "channeling_stone_glow", 5000, 2, "int");
	clientfield::register("scriptmover", "pod_monitor_enable", 5000, 1, "int");
	clientfield::register("world", "flip_skybox", 5000, 1, "int");
	clientfield::register("world", "sndDeathRayToMoon", 5000, 1, "int");
	clientfield::register("toplayer", "outro_lighting_banks", 5000, 1, "int");
	clientfield::register("toplayer", "moon_explosion_bank", 5000, 1, "int");
}

/*
	Name: init_flags
	Namespace: zm_castle_ee
	Checksum: 0xFC8C81E1
	Offset: 0x1A88
	Size: 0x37C
	Parameters: 0
	Flags: Linked
*/
function init_flags()
{
	level flag::init("ee_start_done");
	level flag::init("choose_time_travel_target");
	level flag::init("reset_time_travel_target");
	level flag::init("time_travel_teleporter_ready");
	level flag::init("stop_time_travel");
	level flag::init("switch_to_death_ray");
	level flag::init("death_ray_trap_used");
	level flag::init("dimension_set");
	level flag::init("tesla_connector_launch_platform");
	level flag::init("tesla_connector_lower_tower");
	level flag::init("mpd_canister_replacement");
	level flag::init("end_simon");
	level flag::init("simon_press_check");
	level flag::init("simon_terminal_activated");
	level flag::init("simon_timed_out");
	level flag::init("channeling_stone_replacement");
	level flag::init("start_channeling_stone_step");
	level flag::init("next_channeling_stone");
	level flag::init("see_keeper");
	level flag::init("sent_rockets_to_the_moon");
	level flag::init("rockets_to_moon_vo_complete");
	level flag::init("ee_fuse_held_by_team");
	level flag::init("ee_fuse_placed");
	level flag::init("ee_safe_open");
	level flag::init("ee_golden_key");
	level flag::init("ee_outro");
	if(!level.rankedmatch && !getdvarint("zm_private_rankedmatch"))
	{
		level.var_dfc343e9 = 1;
	}
}

/*
	Name: function_70b74a2d
	Namespace: zm_castle_ee
	Checksum: 0x4B04B444
	Offset: 0x1E10
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function function_70b74a2d()
{
	level thread dempsey_rocket_twinkle();
	level thread function_c21dcd15();
	level thread time_travel();
	level thread function_1ab64038();
	level thread function_82075ffb();
	level thread channeling_stone_replacement();
	level thread function_af12b9a4();
	level thread function_c460669e();
	level thread function_a4b7a410();
	level thread function_71568f8();
	level thread function_d2c78092();
	level thread ee_outro();
	level scene::init("p7_fxanim_zm_castle_rocket_bell_tower_bundle");
	level thread function_6cd00f33();
}

/*
	Name: dempsey_rocket_twinkle
	Namespace: zm_castle_ee
	Checksum: 0x484B0315
	Offset: 0x1F78
	Size: 0x12A
	Parameters: 0
	Flags: Linked
*/
function dempsey_rocket_twinkle()
{
	level waittill(#"hash_59e5a3dd");
	wait(60);
	var_effa4ac5 = struct::get("dempsey_rocket_twinkle");
	var_bfa03783 = fx::play("dempsey_rocket_twinkle", var_effa4ac5.origin, var_effa4ac5.angles, "delete_fx", 0, undefined, 1);
	while(!level flag::get("dimension_set"))
	{
		var_bcfda8b9 = struct::get(var_effa4ac5.target, "targetname");
		var_effa4ac5 = var_bcfda8b9;
		var_bfa03783 moveto(var_effa4ac5.origin, 60);
		var_bfa03783 waittill(#"movedone");
	}
	level notify(#"delete_fx");
}

/*
	Name: time_travel
	Namespace: zm_castle_ee
	Checksum: 0x5FA89D90
	Offset: 0x20B0
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function time_travel()
{
	function_3918d831("safe_code_past");
	function_3918d831("safe_code_present");
	level waittill(#"start_zombie_round_logic");
	var_1bdfdb3b = array("demon_gate_upgraded", "elemental_storm_upgraded", "rune_prison_upgraded", "wolf_howl_upgraded");
	level flag::wait_till_any(var_1bdfdb3b);
	var_be9116cc = getentarray("activate_targets_object", "targetname");
	foreach(var_4e591161 in var_be9116cc)
	{
		var_4e591161 setcandamage(1);
		var_4e591161.health = 999999;
		var_4e591161 thread function_676d98e4();
	}
	level flag::wait_till("ee_start_done");
	array::run_all(var_be9116cc, &delete);
	zm_zonemgr::enable_zone("zone_past_laboratory");
	level thread function_2634b833();
}

/*
	Name: function_676d98e4
	Namespace: zm_castle_ee
	Checksum: 0x7A6864CA
	Offset: 0x22A0
	Size: 0x1F0
	Parameters: 0
	Flags: Linked
*/
function function_676d98e4()
{
	while(!(isdefined(self.b_shot) && self.b_shot))
	{
		self waittill(#"damage", n_damage, e_attacker, v_direction, v_point, str_means_of_death, str_tag_name, str_model_name, str_part_name, w_weapon);
		if(issubstr(w_weapon.name, "elemental_bow"))
		{
			if(!issubstr(w_weapon.name, "elemental_bow_demongate") && !issubstr(w_weapon.name, "elemental_bow_rune_prison") && !issubstr(w_weapon.name, "elemental_bow_storm") && !issubstr(w_weapon.name, "elemental_bow_wolf_howl"))
			{
				s_fx = struct::get(self.target);
				self fx::play("summoning_key_glow", s_fx.origin, s_fx.angles, "delete_fx", 0, undefined, 1);
				self.b_shot = 1;
				function_9dd0cf1();
			}
		}
	}
}

/*
	Name: function_9dd0cf1
	Namespace: zm_castle_ee
	Checksum: 0xBB9F7258
	Offset: 0x2498
	Size: 0x1DC
	Parameters: 0
	Flags: Linked
*/
function function_9dd0cf1()
{
	var_be9116cc = getentarray("activate_targets_object", "targetname");
	var_64c4082d = 0;
	foreach(var_4e591161 in var_be9116cc)
	{
		if(isdefined(var_4e591161.b_shot) && var_4e591161.b_shot)
		{
			var_64c4082d++;
		}
	}
	if(var_64c4082d >= 6)
	{
		foreach(var_4e591161 in var_be9116cc)
		{
			s_fx = struct::get(self.target);
			var_4e591161 fx::play("summoning_key_done", s_fx.origin, s_fx.angles, undefined, 0, undefined, 1);
		}
		level flag::set("ee_start_done");
	}
}

/*
	Name: function_2634b833
	Namespace: zm_castle_ee
	Checksum: 0x39D92184
	Offset: 0x2680
	Size: 0x4C6
	Parameters: 0
	Flags: Linked
*/
function function_2634b833()
{
	a_targets = getentarray("activate_teleporter_object", "targetname");
	foreach(e_target in a_targets)
	{
		e_target setcandamage(1);
		e_target.health = 999999;
		e_target.var_ebeea021 = 0;
	}
	var_64c4082d = 0;
	level.var_a0ef3c5e = undefined;
	level thread function_98d9769f();
	while(!level flag::get("stop_time_travel"))
	{
		level.var_a0ef3c5e = function_ee0ff0d1(a_targets, level.var_a0ef3c5e);
		level.var_a0ef3c5e.var_ebeea021 = 1;
		level.var_a0ef3c5e thread function_7317cab3();
		foreach(e_target in a_targets)
		{
			if(!e_target.var_ebeea021)
			{
				e_target thread function_10a07e71();
			}
		}
		s_fx = struct::get(level.var_a0ef3c5e.target, "targetname");
		s_fx fx::play("battery_charge", s_fx.origin, undefined, "delete_fx", 0, undefined, 1);
		level thread function_d613eb57();
		level thread function_67147dcf();
		playsoundatposition("zmb_object_success", (0, 0, 0));
		a_flags = array("choose_time_travel_target", "reset_time_travel_target");
		level flag::wait_till_any(a_flags);
		s_fx notify(#"delete_fx");
		level.var_a0ef3c5e.var_ebeea021 = 0;
		level flag::clear("choose_time_travel_target");
		if(level flag::get("reset_time_travel_target"))
		{
			level.var_a0ef3c5e = undefined;
			function_dd452f0e(a_targets);
			level flag::clear("reset_time_travel_target");
			var_64c4082d = 0;
			level waittill(#"start_of_round");
		}
		else
		{
			level.var_a0ef3c5e.var_25a8b5d5 = 1;
			var_64c4082d++;
			if(var_64c4082d >= 4)
			{
				level.var_a0ef3c5e = undefined;
				function_dd452f0e(a_targets);
				level thread function_61036bd1();
				playsoundatposition("zmb_object_final_success", (0, 0, 0));
				level flag::set("time_travel_teleporter_ready");
				level waittill(#"start_of_round");
				var_64c4082d = 0;
				level notify(#"hash_a8200e36");
				level flag::clear("time_travel_teleporter_ready");
			}
		}
		wait(9);
	}
}

/*
	Name: function_98d9769f
	Namespace: zm_castle_ee
	Checksum: 0xB77F8F2C
	Offset: 0x2B50
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_98d9769f()
{
	level flag::wait_till("mpd_canister_replacement");
	level flag::wait_till("channeling_stone_replacement");
	level flag::set("stop_time_travel");
}

/*
	Name: function_61036bd1
	Namespace: zm_castle_ee
	Checksum: 0x481D39D9
	Offset: 0x2BC0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_61036bd1()
{
	level clientfield::set("ee_quest_time_travel_ready", 1);
	level flag::wait_till("time_travel_teleporter_ready");
	level flag::wait_till_clear("time_travel_teleporter_ready");
	level clientfield::set("ee_quest_time_travel_ready", 0);
}

/*
	Name: function_ee0ff0d1
	Namespace: zm_castle_ee
	Checksum: 0xF59E086F
	Offset: 0x2C50
	Size: 0x27C
	Parameters: 2
	Flags: Linked
*/
function function_ee0ff0d1(a_targets, e_target_current)
{
	var_4573b5e6 = undefined;
	if(!isdefined(e_target_current))
	{
		var_4573b5e6 = array::random(a_targets);
	}
	else
	{
		var_8717daa1 = [];
		foreach(e_target in a_targets)
		{
			if(!(isdefined(e_target.var_25a8b5d5) && e_target.var_25a8b5d5))
			{
				if(!isdefined(var_8717daa1))
				{
					var_8717daa1 = [];
				}
				else if(!isarray(var_8717daa1))
				{
					var_8717daa1 = array(var_8717daa1);
				}
				var_8717daa1[var_8717daa1.size] = e_target;
			}
		}
		if(var_8717daa1.size > level.activeplayers.size)
		{
			var_8717daa1 = arraysort(var_8717daa1, e_target_current.origin);
			var_fd3f8bfd = [];
			n_targets = level.activeplayers.size + 1;
			for(i = 0; i < n_targets; i++)
			{
				if(!isdefined(var_fd3f8bfd))
				{
					var_fd3f8bfd = [];
				}
				else if(!isarray(var_fd3f8bfd))
				{
					var_fd3f8bfd = array(var_fd3f8bfd);
				}
				var_fd3f8bfd[var_fd3f8bfd.size] = var_8717daa1[i];
			}
			var_4573b5e6 = array::random(var_fd3f8bfd);
		}
		else
		{
			var_4573b5e6 = array::random(var_8717daa1);
		}
	}
	return var_4573b5e6;
}

/*
	Name: function_dd452f0e
	Namespace: zm_castle_ee
	Checksum: 0x203C79A2
	Offset: 0x2ED8
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function function_dd452f0e(a_targets)
{
	var_64c4082d = 0;
	foreach(e_target in a_targets)
	{
		e_target.var_25a8b5d5 = 0;
	}
}

/*
	Name: function_7317cab3
	Namespace: zm_castle_ee
	Checksum: 0xFC3EEF08
	Offset: 0x2F80
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function function_7317cab3()
{
	level endon(#"reset_time_travel_target");
	level endon(#"choose_time_travel_target");
	self waittill(#"damage", n_damage, e_attacker, v_direction, v_point, str_means_of_death, str_tag_name, str_model_name, str_part_name, w_weapon);
	if(issubstr(w_weapon.name, "elemental_bow_demongate") || issubstr(w_weapon.name, "elemental_bow_rune_prison") || issubstr(w_weapon.name, "elemental_bow_storm") || issubstr(w_weapon.name, "elemental_bow_wolf_howl"))
	{
		level flag::set("choose_time_travel_target");
	}
	else
	{
		playsoundatposition("zmb_object_fail", (0, 0, 0));
		level flag::set("reset_time_travel_target");
	}
}

/*
	Name: function_10a07e71
	Namespace: zm_castle_ee
	Checksum: 0x757451F3
	Offset: 0x3120
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_10a07e71()
{
	level endon(#"choose_time_travel_target");
	level endon(#"reset_time_travel_target");
	self waittill(#"damage");
	playsoundatposition("zmb_object_fail", (0, 0, 0));
	level flag::set("reset_time_travel_target");
}

/*
	Name: function_d613eb57
	Namespace: zm_castle_ee
	Checksum: 0xAE47AE12
	Offset: 0x3190
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_d613eb57()
{
	level endon(#"choose_time_travel_target");
	level endon(#"reset_time_travel_target");
	wait(111);
	playsoundatposition("zmb_object_fail", (0, 0, 0));
	level flag::set("reset_time_travel_target");
}

/*
	Name: function_67147dcf
	Namespace: zm_castle_ee
	Checksum: 0xA775C227
	Offset: 0x31F8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_67147dcf()
{
	level endon(#"choose_time_travel_target");
	level endon(#"reset_time_travel_target");
	level waittill(#"between_round_over");
	playsoundatposition("zmb_object_fail", (0, 0, 0));
	level flag::set("reset_time_travel_target");
}

/*
	Name: channeling_stone_replacement
	Namespace: zm_castle_ee
	Checksum: 0x4EFB2858
	Offset: 0x3268
	Size: 0x2BC
	Parameters: 0
	Flags: Linked
*/
function channeling_stone_replacement()
{
	level flag::wait_till("ee_golden_key");
	level flag::wait_till("time_travel_teleporter_ready");
	level endon(#"hash_a8200e36");
	level thread function_f5156f29();
	s_key = struct::get("golden_key_slot_past");
	s_key zm_castle_util::create_unitrigger();
	s_key waittill(#"trigger_activated");
	zm_unitrigger::unregister_unitrigger(s_key.s_unitrigger);
	mdl_key = util::spawn_model("p7_zm_ctl_keycard_ee", s_key.origin, s_key.angles);
	mdl_key.targetname = "golden_key_past";
	s_stone = struct::get("cs_replacement");
	var_f12ee4c0 = util::spawn_model("p7_zm_ctl_channeling_stone", s_stone.origin, s_stone.angles);
	var_f12ee4c0.targetname = "stone_past";
	var_79488a88 = getent("lid_crate_stone", "targetname");
	var_79488a88 rotatepitch(-90, 1);
	var_79488a88.b_rotated = 1;
	var_79488a88 playsound("zmb_ee_lid_open");
	playsoundatposition("zmb_ee_lid_keyinsert", s_key.origin);
	var_f12ee4c0 zm_castle_util::create_unitrigger();
	var_f12ee4c0 waittill(#"trigger_activated");
	zm_unitrigger::unregister_unitrigger(var_f12ee4c0.s_unitrigger);
	var_f12ee4c0 delete();
	var_79488a88.b_rotated = undefined;
	level flag::set("channeling_stone_replacement");
}

/*
	Name: function_f5156f29
	Namespace: zm_castle_ee
	Checksum: 0x1E4C8EFE
	Offset: 0x3530
	Size: 0x23C
	Parameters: 0
	Flags: Linked
*/
function function_f5156f29()
{
	level waittill(#"hash_a8200e36");
	s_key = struct::get("golden_key_slot_past");
	if(isdefined(s_key.s_unitrigger))
	{
		zm_unitrigger::unregister_unitrigger(s_key.s_unitrigger);
	}
	mdl_key = getent("golden_key_past", "targetname");
	if(isdefined(mdl_key))
	{
		mdl_key delete();
	}
	var_f12ee4c0 = getent("stone_past", "targetname");
	if(isdefined(var_f12ee4c0) && isdefined(var_f12ee4c0.s_unitrigger))
	{
		zm_unitrigger::unregister_unitrigger(var_f12ee4c0.s_unitrigger);
	}
	var_f12ee4c0 = getent("stone_past", "targetname");
	if(isdefined(var_f12ee4c0))
	{
		var_f12ee4c0 delete();
	}
	var_79488a88 = getent("lid_crate_stone", "targetname");
	if(isdefined(var_79488a88.b_rotated) && var_79488a88.b_rotated)
	{
		var_79488a88 rotatepitch(90, 1);
		var_79488a88.b_rotated = undefined;
		var_79488a88 playsound("zmb_ee_lid_slide");
	}
	if(!level flag::get("channeling_stone_replacement"))
	{
		level thread channeling_stone_replacement();
	}
}

/*
	Name: function_eb855685
	Namespace: zm_castle_ee
	Checksum: 0xDD48F9E1
	Offset: 0x3778
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_eb855685(var_f63ec558)
{
	level flag::wait_till("channeling_stone_replacement");
	self zm_castle_util::create_unitrigger();
	self waittill(#"trigger_activated");
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
	self show();
	self flagsys::clear("channeling_stone_cracked");
}

/*
	Name: function_af12b9a4
	Namespace: zm_castle_ee
	Checksum: 0x91626296
	Offset: 0x3828
	Size: 0x3A4
	Parameters: 0
	Flags: Linked
*/
function function_af12b9a4()
{
	for(i = 1; i <= 4; i++)
	{
		var_4a9aea8a = getent("cs_glow_" + i, "targetname");
		var_4a9aea8a hide();
	}
	var_f12ee4c0 = getent("cs_stone_2", "targetname");
	var_f12ee4c0 hide();
	var_f12ee4c0 flagsys::set("channeling_stone_cracked");
	a_str_tokens = strtok(var_f12ee4c0.model, "p7_zm_ctl_channeling_stone");
	var_f63ec558 = undefined;
	if(a_str_tokens.size > 0)
	{
		var_f63ec558 = 1;
	}
	var_f12ee4c0 thread function_eb855685(var_f63ec558);
	level flag::wait_till("start_channeling_stone_step");
	level waittill(#"hash_4619f71b");
	zm_spawner::register_zombie_death_event_callback(&function_e8de9974);
	var_b2b5bc6e = struct::get("keeper_spawn_loc", "targetname");
	var_aae59061 = getent("keeper_archon", "targetname");
	var_747532f4 = zombie_utility::spawn_zombie(var_aae59061, "keeper_archon_ai", var_b2b5bc6e);
	var_747532f4 function_2d0c5aa1(var_b2b5bc6e);
	var_747532f4 playsound("zmb_ee_resurrect_keeper_spawn");
	var_747532f4 playloopsound("zmb_ee_resurrect_keeper_lp", 2);
	var_747532f4 fx::play("ghost_torso", var_747532f4.origin, var_747532f4.angles, "ghost_torso", 1, "j_spineupper", 1);
	var_747532f4 fx::play("ghost_trail", var_747532f4.origin, var_747532f4.angles, "ghost_trail", 1, "j_robe_front_03", 1);
	wait(0.15);
	var_747532f4 scene::play("cin_zm_dlc1_corrupted_keeper_charge_stone_intro", var_747532f4);
	var_747532f4 scene::play("cin_zm_dlc1_corrupted_keeper_charge_stone_outro", var_747532f4);
	level thread function_fb090902();
	function_3faf6b59(var_747532f4);
}

/*
	Name: vril_generator
	Namespace: zm_castle_ee
	Checksum: 0xBA19DCCC
	Offset: 0x3BD8
	Size: 0x3D2
	Parameters: 1
	Flags: Linked
*/
function vril_generator(var_e8245e5f)
{
	var_79b48eac = undefined;
	if(isdefined(var_e8245e5f) && var_e8245e5f)
	{
		level waittill(#"hash_b5927dd");
		var_79b48eac = getent("vril_generator", "targetname");
		var_79b48eac delete();
	}
	var_3b32e496 = struct::get("vril_generator");
	var_79b48eac = util::spawn_model("p7_zm_ctl_vril_generator", var_3b32e496.origin, var_3b32e496.angles);
	var_79b48eac setscale(1.7);
	var_79b48eac zm_castle_util::create_unitrigger();
	var_79b48eac waittill(#"trigger_activated");
	var_79b48eac playsound("zmb_ee_resurrect_vril_pickup");
	zm_unitrigger::unregister_unitrigger(var_79b48eac.s_unitrigger);
	var_79b48eac delete();
	var_ff02be4a = struct::get("vril_generator_family");
	var_ff02be4a zm_castle_util::create_unitrigger();
	var_ff02be4a waittill(#"trigger_activated");
	playsoundatposition("zmb_ee_resurrect_vril_place", var_ff02be4a.origin);
	zm_unitrigger::unregister_unitrigger(var_ff02be4a.s_unitrigger);
	var_79b48eac = util::spawn_model("p7_zm_ctl_vril_generator", var_ff02be4a.origin, var_ff02be4a.angles);
	var_79b48eac setscale(1.7);
	var_79b48eac fx::play("keeper_summon", var_79b48eac.origin + vectorscale((0, 0, 1), 12), var_79b48eac.angles, "delete_fx", 0, undefined, 1);
	wait(3);
	foreach(player in level.players)
	{
		str_player_zone = player zm_zonemgr::get_player_zone();
		if(zm_utility::is_player_valid(player) && str_player_zone === "zone_undercroft_chapel")
		{
			player thread lui::screen_flash(0.15, 1, 0.35, 0.95, "white");
		}
	}
	var_79b48eac notify(#"delete_fx");
	var_79b48eac playsound("zmb_ee_resurrect_vril_end");
	level notify(#"hash_4619f71b");
}

/*
	Name: function_2d0c5aa1
	Namespace: zm_castle_ee
	Checksum: 0x7BA35502
	Offset: 0x3FB8
	Size: 0x1EC
	Parameters: 1
	Flags: Linked
*/
function function_2d0c5aa1(s_spawn_point)
{
	self endon(#"death");
	self setphysparams(15, 0, 72);
	self.ignore_enemy_count = 1;
	self.no_eye_glow = 1;
	self.deathpoints_already_given = 1;
	self.exclude_distance_cleanup_adding_to_total = 1;
	self.exclude_cleanup_adding_to_total = 1;
	self.b_ignore_cleanup = 1;
	self.ignoreall = 1;
	self.ignoreme = 1;
	self util::magic_bullet_shield();
	self setcandamage(0);
	self setplayercollision(0);
	self setteam("allies");
	self.is_immune_to_knockdown = 1;
	self.var_3531cf2b = 1;
	self.var_e05d0be2 = 1;
	self.ignoremelee = 1;
	self.var_1e3fb1c = 1;
	self notsolid();
	self thread function_d1963bbd();
	self.start_inert = 1;
	self zm_spawner::zombie_think();
	if(self.zombie_move_speed === "walk")
	{
		self zombie_utility::set_zombie_run_cycle("run");
	}
	self.nocrawler = 1;
	self.no_powerups = 1;
	self clientfield::set("ghost_actor", 1);
}

/*
	Name: function_d1963bbd
	Namespace: zm_castle_ee
	Checksum: 0xF57B88F2
	Offset: 0x41B0
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function function_d1963bbd()
{
	self endon(#"death");
	self endon(#"entityshutdown");
	while(true)
	{
		self.knockdown = 0;
		wait(0.2);
	}
}

/*
	Name: function_e8de9974
	Namespace: zm_castle_ee
	Checksum: 0xDA0F5433
	Offset: 0x41F0
	Size: 0x364
	Parameters: 1
	Flags: Linked
*/
function function_e8de9974(e_attacker)
{
	if(self.archetype === "zombie")
	{
		if(zm_utility::is_player_valid(e_attacker) && (isdefined(e_attacker.var_babefc4c) && e_attacker.var_babefc4c) && (isdefined(e_attacker.var_507ad4a9) && e_attacker.var_507ad4a9))
		{
			if(issubstr(self.damageweapon.name, "elemental_bow_" + level.var_1f18338d))
			{
				var_f12ee4c0 = getent("cs_stone_" + level.var_f1b0baba, "targetname");
				if(!isdefined(var_f12ee4c0) || !var_f12ee4c0 flagsys::get("channeling_stone_cracked"))
				{
					e_volume = getent("cs_zone_" + level.var_f1b0baba, "targetname");
					if(self istouching(e_volume))
					{
						var_4a9aea8a = getent("cs_glow_" + level.var_f1b0baba, "targetname");
						var_25c1c42e = function_6fc08711();
						self thread zm_castle_weap_quest_upgrade::function_55c48922(self.origin, var_4a9aea8a.origin, var_25c1c42e, isdefined(self.missinglegs) && self.missinglegs);
						level.var_8bdb0713++;
						if(level.var_8bdb0713 == 1)
						{
							level waittill(#"hash_d8b279ab");
							var_4a9aea8a clientfield::set("channeling_stone_glow", 1);
							var_747532f4 = getent("keeper_archon_ai", "targetname");
							var_747532f4 notify(#"start_moving");
							var_747532f4 scene::play("cin_zm_dlc1_corrupted_keeper_charge_stone_intro", var_747532f4);
							var_747532f4 thread scene::play("cin_zm_dlc1_corrupted_keeper_charge_stone_loop", var_747532f4);
							var_747532f4 fx::play("keeper_charge", var_747532f4.origin, var_747532f4.angles, "keeper_charge", 1, "j_spineupper", 1);
							str_exploder = function_ac7d9299();
							exploder::exploder(str_exploder);
						}
						return true;
					}
				}
			}
		}
	}
	return false;
}

/*
	Name: function_6fc08711
	Namespace: zm_castle_ee
	Checksum: 0x971D69C7
	Offset: 0x4560
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function function_6fc08711()
{
	var_25c1c42e = undefined;
	switch(level.var_1f18338d)
	{
		case "demongate":
		{
			var_25c1c42e = "demon";
			break;
		}
		case "rune_prison":
		{
			var_25c1c42e = "rune";
			break;
		}
		case "storm":
		{
			var_25c1c42e = "storm";
			break;
		}
		case "wolf_howl":
		{
			var_25c1c42e = "wolf";
			break;
		}
		default:
		{
			break;
		}
	}
	return var_25c1c42e;
}

/*
	Name: function_ac7d9299
	Namespace: zm_castle_ee
	Checksum: 0xBC5F63AF
	Offset: 0x4608
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function function_ac7d9299()
{
	str_exploder = undefined;
	switch(level.var_f1b0baba)
	{
		case 1:
		{
			str_exploder = "fxexp_631";
			break;
		}
		case 2:
		{
			str_exploder = "fxexp_632";
			break;
		}
		case 3:
		{
			str_exploder = "fxexp_630";
			break;
		}
		case 4:
		{
			str_exploder = "fxexp_633";
			break;
		}
		default:
		{
			break;
		}
	}
	return str_exploder;
}

/*
	Name: function_a760f135
	Namespace: zm_castle_ee
	Checksum: 0xCA5CCC10
	Offset: 0x46B0
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_a760f135()
{
	level.a_elements = [];
	level thread function_afc77531("demon_gate_upgraded", "demongate");
	level thread function_afc77531("elemental_storm_upgraded", "storm");
	level thread function_afc77531("rune_prison_upgraded", "rune_prison");
	level thread function_afc77531("wolf_howl_upgraded", "wolf_howl");
}

/*
	Name: function_afc77531
	Namespace: zm_castle_ee
	Checksum: 0x37A05170
	Offset: 0x4768
	Size: 0xCA
	Parameters: 2
	Flags: Linked
*/
function function_afc77531(str_flag, var_61bcec7)
{
	if(!(isdefined(level.var_dfc343e9) && level.var_dfc343e9))
	{
		if(!level flag::get(str_flag))
		{
			level flag::wait_till(str_flag);
		}
	}
	if(!isdefined(level.a_elements))
	{
		level.a_elements = [];
	}
	else if(!isarray(level.a_elements))
	{
		level.a_elements = array(level.a_elements);
	}
	level.a_elements[level.a_elements.size] = var_61bcec7;
}

/*
	Name: function_4ce3eea5
	Namespace: zm_castle_ee
	Checksum: 0xD6379DA1
	Offset: 0x4840
	Size: 0x10E
	Parameters: 1
	Flags: Linked
*/
function function_4ce3eea5(var_bda73276)
{
	var_61bcec7 = level.a_elements[var_bda73276];
	if(!isdefined(var_61bcec7))
	{
		n_players = level.players.size;
		/#
			n_players = n_players + level.var_b5231dfb;
			if(n_players > 4)
			{
				n_players = 4;
			}
		#/
		if(var_bda73276 >= n_players)
		{
			n_index = var_bda73276 - n_players;
			var_61bcec7 = level.a_elements[n_index];
			while(!isdefined(var_61bcec7))
			{
				n_index = n_index - n_players;
				var_61bcec7 = level.a_elements[n_index];
			}
		}
		else
		{
			while(!isdefined(var_61bcec7))
			{
				wait(0.15);
				var_61bcec7 = level.a_elements[var_bda73276];
			}
		}
	}
	return var_61bcec7;
}

/*
	Name: function_3faf6b59
	Namespace: zm_castle_ee
	Checksum: 0x23699F88
	Offset: 0x4958
	Size: 0xA7C
	Parameters: 1
	Flags: Linked
*/
function function_3faf6b59(var_747532f4)
{
	a_zones = array(1, 2, 3, 4);
	function_a760f135();
	level.a_elements = array::randomize(level.a_elements);
	a_zones = array::randomize(a_zones);
	for(i = 0; i < a_zones.size; i++)
	{
		foreach(player in level.players)
		{
			player thread function_812faaaf();
		}
		level.var_f1b0baba = a_zones[i];
		level.var_8bdb0713 = 0;
		s_stone = struct::get("cs_keeper_pos_" + level.var_f1b0baba);
		var_747532f4 setgoal(s_stone.origin);
		var_747532f4 waittill(#"goal");
		var_747532f4 thread function_37fb253(s_stone);
		var_747532f4 playsound("zmb_ee_resurrect_start_circle");
		level.var_1f18338d = function_4ce3eea5(i);
		level thread function_99ac27a();
		if(i > 1)
		{
			if(!level flag::get("solo_game") || i > 2)
			{
				var_747532f4 thread function_88e260d();
			}
		}
		function_4f8445d7(a_zones[i]);
		playsoundatposition("zmb_ee_resurrect_circle_complete", (0, 0, 0));
		level flag::clear("next_channeling_stone");
		var_747532f4 scene::stop("cin_zm_dlc1_corrupted_keeper_charge_stone_loop");
		var_747532f4 scene::play("cin_zm_dlc1_corrupted_keeper_charge_stone_outro", var_747532f4);
		var_747532f4 playsound("zmb_ee_resurrect_power_complete");
		wait(0.15);
	}
	zm_spawner::deregister_zombie_death_event_callback(&function_e8de9974);
	var_82a4f07b = struct::get("keeper_end_loc");
	var_82a4f07b fx::play("mpd_fx", var_82a4f07b.origin, var_82a4f07b.angles, "delete_fx", 0, undefined, 1);
	level.var_8ef26cd9 = 1;
	foreach(player in level.players)
	{
		player thread zm_castle_util::function_fa7da172();
	}
	callback::on_connect(&zm_castle_util::function_fa7da172);
	var_57615f80 = getentarray("pyramid", "targetname");
	foreach(var_27fd0c6f in var_57615f80)
	{
		var_54a70b81 = (var_27fd0c6f.origin[0], var_27fd0c6f.origin[1], var_27fd0c6f.origin[2] - 96);
		var_27fd0c6f notsolid();
		var_27fd0c6f connectpaths();
		var_27fd0c6f moveto(var_54a70b81, 3);
	}
	var_747532f4 clientfield::set("ghost_actor", 0);
	var_747532f4 notify(#"ghost_torso");
	var_747532f4 notify(#"ghost_trail");
	var_747532f4 playsound("zmb_ee_resurrect_keeper_notghost");
	var_747532f4 playloopsound("zmb_ee_resurrect_keeper_notghost_lp");
	var_747532f4 fx::play("keeper_torso", var_747532f4.origin, var_747532f4.angles, "keeper_torso", 1, "j_spineupper", 1);
	var_747532f4 fx::play("keeper_mouth", var_747532f4.origin, var_747532f4.angles, "keeper_torso", 1, "j_head", 1);
	var_747532f4 fx::play("keeper_trail", var_747532f4.origin, var_747532f4.angles, "keeper_trail", 1, "j_robe_front_03", 1);
	wait(3);
	level.var_cc2ea6e8 = undefined;
	var_747532f4 notify(#"start_moving");
	s_stone = struct::get("keeper_end_loc");
	var_747532f4 setgoal(s_stone.origin);
	var_747532f4 waittill(#"goal");
	var_747532f4 playsound("zmb_ee_resurrect_end_warpaway");
	var_747532f4 fx::play("keeper_beam", var_747532f4.origin, var_747532f4.angles, undefined, 1, "j_mainroot", 1);
	exploder::exploder("fxexp_601");
	exploder::exploder("fxexp_602");
	exploder::exploder("fxexp_603");
	exploder::exploder("fxexp_604");
	foreach(player in level.players)
	{
		player thread function_6ff05666();
	}
	callback::on_connect(&function_6ff05666);
	level flag::wait_till("see_keeper");
	callback::remove_on_connect(&function_6ff05666);
	function_1c4bd669(1);
	var_747532f4 scene::play("cin_zm_dlc1_corrupted_keeper_float_emerge", var_747532f4);
	exploder::kill_exploder("fxexp_601");
	exploder::kill_exploder("fxexp_602");
	exploder::kill_exploder("fxexp_603");
	exploder::kill_exploder("fxexp_604");
	var_747532f4 delete();
	var_82a4f07b notify(#"delete_fx");
	callback::remove_on_connect(&zm_castle_util::function_fa7da172);
	level.var_8ef26cd9 = undefined;
	zm_castle_vo::function_70721c81();
	function_1c4bd669(0);
	level flag::set("boss_fight_ready");
}

/*
	Name: function_6ff05666
	Namespace: zm_castle_ee
	Checksum: 0xB940AA85
	Offset: 0x53E0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_6ff05666()
{
	self endon(#"death");
	var_747532f4 = getent("keeper_archon_ai", "targetname");
	str_player_zone = self zm_zonemgr::get_player_zone();
	while(!zm_utility::is_player_valid(self) || str_player_zone !== "zone_undercroft")
	{
		wait(0.15);
		str_player_zone = self zm_zonemgr::get_player_zone();
	}
	level flag::set("see_keeper");
}

/*
	Name: function_37fb253
	Namespace: zm_castle_ee
	Checksum: 0xF299EF06
	Offset: 0x54B0
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function function_37fb253(var_33b10d19)
{
	var_4811f4e0 = util::spawn_model("tag_origin", self.origin, self.angles);
	self linkto(var_4811f4e0);
	var_4811f4e0 rotateto(var_33b10d19.angles, 1);
	var_91e5f72f = (var_33b10d19.origin[0], var_33b10d19.origin[1], self.origin[2]);
	var_4811f4e0 moveto(var_91e5f72f, 1);
	self waittill(#"start_moving");
	self unlink();
	var_4811f4e0 delete();
}

/*
	Name: function_99ac27a
	Namespace: zm_castle_ee
	Checksum: 0xD6F18307
	Offset: 0x55D8
	Size: 0x1C8
	Parameters: 0
	Flags: Linked
*/
function function_99ac27a()
{
	level endon(#"next_channeling_stone");
	var_f12ee4c0 = getent("cs_stone_" + level.var_f1b0baba, "targetname");
	if(isdefined(var_f12ee4c0))
	{
		var_f12ee4c0 flagsys::wait_till_clear("channeling_stone_cracked");
	}
	var_4a9aea8a = getent("cs_glow_" + level.var_f1b0baba, "targetname");
	var_4a9aea8a show();
	level thread function_6bfbde41();
	var_dd155127 = function_f507c094();
	while(true)
	{
		if(function_1f8ca830())
		{
			var_747532f4 = getent("keeper_archon_ai", "targetname");
			var_747532f4 notify(#"keeper_charge");
			str_exploder = function_ac7d9299();
			exploder::kill_exploder(str_exploder);
			var_4a9aea8a clientfield::set("channeling_stone_glow", 2);
			level flag::set("next_channeling_stone");
		}
		wait(0.15);
	}
}

/*
	Name: function_4400f882
	Namespace: zm_castle_ee
	Checksum: 0xAEF7895D
	Offset: 0x57A8
	Size: 0x96
	Parameters: 0
	Flags: Linked
*/
function function_4400f882()
{
	var_dd155127 = 16;
	switch(level.var_1f18338d)
	{
		case "demongate":
		{
			var_dd155127 = 17;
			break;
		}
		case "rune_prison":
		{
			var_dd155127 = 16;
			break;
		}
		case "storm":
		{
			var_dd155127 = 20;
			break;
		}
		case "wolf_howl":
		{
			var_dd155127 = 18;
			break;
		}
		default:
		{
			break;
		}
	}
	return var_dd155127;
}

/*
	Name: function_f507c094
	Namespace: zm_castle_ee
	Checksum: 0xA7D29162
	Offset: 0x5848
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_f507c094()
{
	var_dd155127 = function_4400f882();
	n_players = level.players.size;
	/#
		n_players = n_players + level.var_b5231dfb;
		if(n_players > 4)
		{
			n_players = 4;
		}
	#/
	var_4b5cecfa = 4 - (n_players - 1);
	var_dd155127 = var_dd155127 * var_4b5cecfa;
	return var_dd155127;
}

/*
	Name: function_6bfbde41
	Namespace: zm_castle_ee
	Checksum: 0x1840CDD4
	Offset: 0x58F0
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function function_6bfbde41()
{
	level endon(#"next_channeling_stone");
	while(true)
	{
		level.var_f91118d9 = undefined;
		level waittill(#"end_of_round");
		level.var_f91118d9 = 1;
		level waittill(#"start_of_round");
	}
}

/*
	Name: function_1f8ca830
	Namespace: zm_castle_ee
	Checksum: 0x5F499735
	Offset: 0x5940
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function function_1f8ca830()
{
	var_7ec3e0eb = 0;
	if(level.var_8bdb0713 >= function_4400f882())
	{
		if(isdefined(level.var_f91118d9) && level.var_f91118d9)
		{
			var_7ec3e0eb = 1;
		}
		else if(level.var_8bdb0713 >= function_f507c094())
		{
			var_7ec3e0eb = 1;
		}
	}
	return var_7ec3e0eb;
}

/*
	Name: function_812faaaf
	Namespace: zm_castle_ee
	Checksum: 0xAF9643DA
	Offset: 0x59C8
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_812faaaf()
{
	self endon(#"death");
	level endon(#"next_channeling_stone");
	while(true)
	{
		self waittill(#"missile_fire", var_3fee16b8, var_e1041201);
		if(zm_utility::is_player_valid(self) && (isdefined(self.var_507ad4a9) && self.var_507ad4a9))
		{
			if(issubstr(var_e1041201.name, "elemental_bow_" + level.var_1f18338d))
			{
				self.var_babefc4c = 1;
			}
			else
			{
				self.var_babefc4c = undefined;
			}
		}
		else
		{
			self.var_babefc4c = undefined;
		}
		wait(0.05);
	}
}

/*
	Name: function_4f8445d7
	Namespace: zm_castle_ee
	Checksum: 0x797394F8
	Offset: 0x5AB0
	Size: 0x480
	Parameters: 1
	Flags: Linked
*/
function function_4f8445d7(n_zone)
{
	level.var_b5231dfb = 0;
	var_1171297b = function_f5a8624();
	var_d8c501d = var_1171297b.var_d8c501d;
	a_circles = var_1171297b.a_circles;
	var_d8702dd1 = [];
	for(i = 0; i < var_d8c501d.size; i++)
	{
		var_d8702dd1[i] = var_d8c501d[i] * var_d8c501d[i];
	}
	var_560e7570 = var_d8702dd1[0];
	var_6998342d = var_d8c501d[0];
	var_d139aee0 = "" + var_6998342d;
	var_1acc807d = struct::get_array("cscircle_" + n_zone);
	var_87367d4f = array::random(var_1acc807d);
	var_fcfee273 = ("lgt_channel_stones_" + n_zone) + a_circles[var_d139aee0];
	exploder::exploder(var_fcfee273);
	var_bffe8a31 = 0;
	while(!level flag::get("next_channeling_stone"))
	{
		var_470f6bc3 = 0;
		foreach(player in level.players)
		{
			if(zm_utility::is_player_valid(player) && distance2dsquared(player.origin, var_87367d4f.origin) < var_560e7570)
			{
				player.var_507ad4a9 = 1;
				var_470f6bc3++;
				player thread function_af71af0e();
				continue;
			}
			player.var_507ad4a9 = undefined;
		}
		if(level flag::get("solo_game"))
		{
			var_470f6bc3 = var_470f6bc3 + 2;
		}
		/#
			var_470f6bc3 = var_470f6bc3 + level.var_b5231dfb;
		#/
		if(var_470f6bc3 > 4)
		{
			var_470f6bc3 = 4;
		}
		if(var_470f6bc3 != var_bffe8a31)
		{
			exploder::kill_exploder(var_fcfee273);
			var_560e7570 = var_d8702dd1[var_470f6bc3];
			var_6998342d = var_d8c501d[var_470f6bc3];
			var_d139aee0 = "" + var_6998342d;
			var_fcfee273 = ("lgt_channel_stones_" + n_zone) + a_circles[var_d139aee0];
			exploder::exploder(var_fcfee273);
			var_bffe8a31 = var_470f6bc3;
		}
		wait(0.05);
	}
	exploder::kill_exploder(var_fcfee273);
	foreach(player in level.players)
	{
		player.var_507ad4a9 = undefined;
	}
}

/*
	Name: function_f5a8624
	Namespace: zm_castle_ee
	Checksum: 0x32B4C416
	Offset: 0x5F38
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_f5a8624()
{
	var_d8c501d = array(48, 80, 112, 192, 256);
	a_circles = [];
	for(i = 0; i < var_d8c501d.size; i++)
	{
		str_size = "" + var_d8c501d[i];
		a_circles[str_size] = "_" + (i + 1);
	}
	var_1171297b = spawnstruct();
	var_1171297b.var_d8c501d = var_d8c501d;
	var_1171297b.a_circles = a_circles;
	return var_1171297b;
}

/*
	Name: function_c460669e
	Namespace: zm_castle_ee
	Checksum: 0x72CF883F
	Offset: 0x6040
	Size: 0x3CC
	Parameters: 0
	Flags: Linked
*/
function function_c460669e()
{
	function_2925fac8();
	a_models = getentarray("script_model", "classname");
	foreach(var_568ffe7c in a_models)
	{
		if(var_568ffe7c.model === "veh_t7_dlc1_mil_halftrack_dead_snow")
		{
			var_568ffe7c setcontents(8192);
		}
	}
	var_ee79aaa6 = getent("uc_capsule_crash_after", "targetname");
	var_ee79aaa6 hide();
	var_c4556169 = getent("uc_crash_cryo_after", "targetname");
	var_c4556169 hide();
	level flag::wait_till("ee_golden_key");
	var_e7113aa6 = 0;
	level.var_cf5a713 = undefined;
	var_18b93ed0 = struct::get_array("golden_key_slot");
	while(var_e7113aa6 < 2)
	{
		var_18b93ed0[0] thread function_bb8e762c(var_18b93ed0[1]);
		var_18b93ed0[1] thread function_bb8e762c(var_18b93ed0[0]);
		var_b5aa6f14 = function_19abb192(var_e7113aa6);
		function_15752140(var_b5aa6f14);
		if(level.var_e3162591 && level flag::get("switch_to_death_ray") && level flag::get("tesla_connector_" + level.var_cf5a713.script_noteworthy))
		{
			var_e7113aa6++;
		}
		else
		{
			var_e7113aa6 = 0;
			foreach(var_4ae0fc9f in var_18b93ed0)
			{
				var_4ae0fc9f.b_done = undefined;
			}
			exploder::stop_exploder("fxexp_730");
			exploder::stop_exploder("fxexp_731");
		}
		level flag::clear("simon_terminal_activated");
	}
	function_7d8964c9();
	level flag::set("start_channeling_stone_step");
}

/*
	Name: function_6cd00f33
	Namespace: zm_castle_ee
	Checksum: 0x7061644B
	Offset: 0x6418
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_6cd00f33()
{
	var_37c17be6 = undefined;
	while(!isdefined(var_37c17be6))
	{
		wait(0.5);
		var_37c17be6 = getent("rocket_bell", "targetname");
	}
	var_37c17be6 thread function_c7c38164("stop_damage_loop");
	var_37c17be6 waittill(#"hash_7969a7d6");
	var_47017e15 = getent("fallen_bell_damage_trigger", "targetname");
	var_47017e15 function_c7c38164();
}

/*
	Name: function_c7c38164
	Namespace: zm_castle_ee
	Checksum: 0xAB723F22
	Offset: 0x64E8
	Size: 0xA0
	Parameters: 1
	Flags: Linked
*/
function function_c7c38164(str_endon = undefined)
{
	if(isdefined(str_endon))
	{
		self endon(str_endon);
	}
	while(true)
	{
		self waittill(#"damage", n_amount, e_attacker);
		if(isplayer(e_attacker))
		{
			self playsound("zmb_ee_rocketcrash_bell_imp_1");
			wait(0.1);
		}
	}
}

/*
	Name: function_7d8964c9
	Namespace: zm_castle_ee
	Checksum: 0x6AE17290
	Offset: 0x6590
	Size: 0x36C
	Parameters: 0
	Flags: Linked
*/
function function_7d8964c9()
{
	if(level scene::is_playing("p7_fxanim_zm_castle_rocket_bell_tower_bundle"))
	{
		level scene::stop("p7_fxanim_zm_castle_rocket_bell_tower_bundle");
	}
	if(level scene::is_playing("p7_fxanim_zm_castle_rocket_tip_bundle"))
	{
		level scene::stop("p7_fxanim_zm_castle_rocket_tip_bundle");
	}
	exploder::exploder("lgt_deathray_back");
	var_cf2402ea = struct::get("death_ray_button");
	var_cf2402ea zm_castle_util::create_unitrigger();
	var_cf2402ea waittill(#"trigger_activated");
	playsoundatposition("zmb_ee_rocketcrash_ray_button", var_cf2402ea.origin);
	level clientfield::set("sndDeathRayToMoon", 1);
	zm_unitrigger::unregister_unitrigger(var_cf2402ea.s_unitrigger);
	exploder::stop_exploder("lgt_deathray_back");
	exploder::exploder("fxexp_698");
	exploder::exploder("fxexp_740");
	playrumbleonposition("zm_castle_death_ray_ee_rumble", var_cf2402ea.origin);
	wait(3);
	exploder::stop_exploder("fxexp_698");
	exploder::stop_exploder("fxexp_740");
	exploder::stop_exploder("fxexp_730");
	exploder::stop_exploder("fxexp_731");
	level clientfield::set("sndDeathRayToMoon", 0);
	var_977dbe2f = struct::get("ee_rocket_explosion");
	var_977dbe2f fx::play("rocket_explosion", var_977dbe2f.origin, var_977dbe2f.angles);
	wait(2.5);
	level thread vril_generator(1);
	level flag::set("start_channeling_stone_step");
	scene::add_scene_func("p7_fxanim_zm_castle_rocket_tip_bundle", &function_1ca91be4);
	scene::add_scene_func("p7_fxanim_zm_castle_rocket_tip_bundle", &function_b404c31d);
	level thread scene::play("p7_fxanim_zm_castle_rocket_tip_bundle");
	level thread scene::play("p7_fxanim_zm_castle_rocket_bell_tower_bundle");
}

/*
	Name: function_1ca91be4
	Namespace: zm_castle_ee
	Checksum: 0x82B33A55
	Offset: 0x6908
	Size: 0x3AC
	Parameters: 1
	Flags: Linked
*/
function function_1ca91be4(a_ents)
{
	var_3e414a21 = a_ents["rocket_tip"];
	var_a723142d = a_ents["cryo_chamber"];
	e_dempsey = a_ents["dempsey_02"];
	e_dempsey ghost();
	wait(5);
	array::run_all(level.players, &playrumbleonentity, "zm_castle_rocket_tip");
	var_3e414a21 waittill(#"hash_43ba2284");
	array::run_all(level.players, &playrumbleonentity, "zm_castle_rocket_tip_tower_crash");
	var_3e414a21 waittill(#"hash_87acceea");
	array::run_all(level.players, &playrumbleonentity, "zm_castle_rocket_tip_ground_crash");
	var_a723142d clientfield::set("pod_monitor_enable", 1);
	e_dempsey show();
	var_ee79aaa6 = getent("uc_capsule_crash_after", "targetname");
	var_ee79aaa6 show();
	var_7385ffad = getentarray("uc_capsule_crash_before", "targetname");
	foreach(var_de31b779 in var_7385ffad)
	{
		var_de31b779 delete();
	}
	var_a723142d waittill(#"hash_9a7af34f");
	foreach(e_player in level.players)
	{
		e_player thread function_35c1d14d();
	}
	callback::on_connect(&function_d4be5c9f);
	level thread scene::play("cin_cas_01_outro_3rd_static_poses");
	wait(3);
	var_a723142d delete();
	var_165d49f6 = getent("pod", "targetname");
	var_165d49f6 clientfield::set("pod_monitor_enable", 1);
	zm_castle_vo::function_44c11f63();
}

/*
	Name: function_b404c31d
	Namespace: zm_castle_ee
	Checksum: 0x4A1754BE
	Offset: 0x6CC0
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function function_b404c31d(a_ents)
{
	var_a723142d = a_ents["cryo_chamber"];
	var_a723142d waittill(#"hash_225501ad");
	var_c4556169 = getent("uc_crash_cryo_after", "targetname");
	var_c4556169 show();
	var_e7d455cc = getent("uc_crash_cryo_before", "targetname");
	var_e7d455cc delete();
}

/*
	Name: function_35c1d14d
	Namespace: zm_castle_ee
	Checksum: 0x5F64AFBB
	Offset: 0x6D80
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function function_35c1d14d()
{
	self endon(#"death");
	level endon(#"ee_outro");
	var_6326f93a = getent("cryo_chamber_shock_volume", "targetname");
	while(true)
	{
		if(self istouching(var_6326f93a))
		{
			self setelectrified(1.5);
			self shellshock("electrocution", 1.5);
			self playsound("wpn_teslatrap_zap");
			self playrumbleonentity("zm_castle_tesla_electrocution");
			wait(1.5);
		}
		else
		{
			wait(0.25);
		}
	}
}

/*
	Name: function_d4be5c9f
	Namespace: zm_castle_ee
	Checksum: 0x5A77101C
	Offset: 0x6EA0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_d4be5c9f()
{
	self thread function_35c1d14d();
}

/*
	Name: function_19abb192
	Namespace: zm_castle_ee
	Checksum: 0xD20703AC
	Offset: 0x6EC8
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function function_19abb192(var_e7113aa6)
{
	var_b5aa6f14 = undefined;
	switch(var_e7113aa6)
	{
		case 0:
		{
			var_b5aa6f14 = 7;
			break;
		}
		case 1:
		{
			var_b5aa6f14 = 8;
			break;
		}
		default:
		{
			break;
		}
	}
	return var_b5aa6f14;
}

/*
	Name: function_bb8e762c
	Namespace: zm_castle_ee
	Checksum: 0x3E3DF18B
	Offset: 0x6F40
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function function_bb8e762c(var_ff508804)
{
	level endon(#"simon_terminal_activated");
	if(isdefined(self.b_done) && self.b_done)
	{
		return;
	}
	self zm_castle_util::create_unitrigger(undefined, 8);
	self waittill(#"trigger_activated");
	zm_unitrigger::unregister_unitrigger(var_ff508804.s_unitrigger);
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
	level.var_cf5a713 = self;
	level flag::set("simon_terminal_activated");
}

/*
	Name: function_15752140
	Namespace: zm_castle_ee
	Checksum: 0x1ED09234
	Offset: 0x7000
	Size: 0x7CC
	Parameters: 1
	Flags: Linked
*/
function function_15752140(var_b5aa6f14)
{
	level.var_e3162591 = 0;
	level flag::wait_till("simon_terminal_activated");
	var_d733da61 = 1;
	if(level.var_cf5a713.script_noteworthy == "launch_platform")
	{
		var_d733da61 = 2;
	}
	var_e131c06 = util::spawn_model("p7_zm_ctl_keycard_ee", level.var_cf5a713.origin, level.var_cf5a713.angles);
	var_4d74106b = getent("symbols_" + level.var_cf5a713.script_noteworthy, "targetname");
	var_4d74106b playsound("zmb_ee_simonsays_insertcard");
	var_c5ea7ad8 = array("1", "2", "3", "4");
	var_c5ea7ad8 = array::randomize(var_c5ea7ad8);
	var_a6116854 = [];
	for(i = 0; i < 4; i++)
	{
		var_a6116854[var_c5ea7ad8[i]] = struct::get((("monitor_" + level.var_cf5a713.script_noteworthy) + "_") + (i + 1));
		var_a6116854[var_c5ea7ad8[i]].var_73527aa3 = undefined;
		var_a6116854[var_c5ea7ad8[i]] zm_castle_util::create_unitrigger(undefined, 16);
		var_4d74106b showpart((("tag_scn" + (i + 1)) + "_sym") + var_c5ea7ad8[i]);
		level thread function_b76d0c45(var_a6116854[var_c5ea7ad8[i]], (("tag_scn" + (i + 1)) + "_sym") + var_c5ea7ad8[i], (("lgt_EE_consol" + var_d733da61) + "_monitor_") + (i + 1));
	}
	level waittill(#"hash_706f7f9a");
	level thread function_fb090902(1);
	var_1a972685 = spawnstruct();
	level.var_521b0bd1 = 0;
	while(!level flag::get("end_simon"))
	{
		var_2fe972c1 = array::random(var_c5ea7ad8);
		var_a6116854[var_2fe972c1].var_73527aa3 = 1;
		var_1a972685.var_94287343 = "tag_scn0_sym" + var_2fe972c1;
		var_4d74106b showpart("tag_scn0_sym" + var_2fe972c1);
		var_4d74106b playsound("zmb_ee_simonsays_show");
		exploder::exploder(("lgt_EE_consol" + var_d733da61) + "_monitor_main");
		level thread simon_timed_out(var_4d74106b, var_d733da61);
		a_flags = array("simon_timed_out", "simon_press_check");
		level flag::wait_till_any(a_flags);
		exploder::exploder(("lgt_EE_consol" + var_d733da61) + "_monitor_main");
		if(level flag::get("simon_timed_out"))
		{
			level flag::set("end_simon");
			level flag::clear("simon_timed_out");
			var_4d74106b playsound("zmb_ee_simonsays_nay");
		}
		else
		{
			level waittill(#"hash_b7f06cd9");
			level flag::clear("simon_press_check");
		}
		exploder::kill_exploder(("lgt_EE_consol" + var_d733da61) + "_monitor_main");
		var_4d74106b hidepart(var_1a972685.var_94287343);
		var_a6116854[var_2fe972c1].var_73527aa3 = undefined;
		if(level.var_521b0bd1 >= var_b5aa6f14)
		{
			level flag::set("end_simon");
			level.var_cf5a713.b_done = 1;
			level.var_e3162591 = 1;
			var_4d74106b playsound("zmb_ee_simonsays_complete");
			if(level.var_cf5a713.script_noteworthy == "lower_tower")
			{
				exploder::exploder("fxexp_730");
			}
			else if(level.var_cf5a713.script_noteworthy == "launch_platform")
			{
				exploder::exploder("fxexp_731");
			}
		}
		wait(0.25);
	}
	level notify(#"hash_b0b992fb");
	function_2925fac8();
	foreach(var_901d8fb2 in var_a6116854)
	{
		zm_unitrigger::unregister_unitrigger(var_901d8fb2.s_unitrigger);
	}
	level.var_cc2ea6e8 = undefined;
	var_e131c06 delete();
	level flag::clear("simon_press_check");
	level flag::clear("simon_timed_out");
	level flag::clear("end_simon");
}

/*
	Name: function_2925fac8
	Namespace: zm_castle_ee
	Checksum: 0xD3BEF49C
	Offset: 0x77D8
	Size: 0x166
	Parameters: 0
	Flags: Linked
*/
function function_2925fac8()
{
	var_91d3caa4 = struct::get_array("golden_key_slot");
	foreach(s_slot in var_91d3caa4)
	{
		var_4d74106b = getent("symbols_" + s_slot.script_noteworthy, "targetname");
		for(i = 0; i < 5; i++)
		{
			for(j = 1; j <= 4; j++)
			{
				var_4d74106b hidepart((("tag_scn" + i) + "_sym") + j);
			}
		}
	}
}

/*
	Name: function_b76d0c45
	Namespace: zm_castle_ee
	Checksum: 0x51C02FE4
	Offset: 0x7948
	Size: 0x258
	Parameters: 3
	Flags: Linked
*/
function function_b76d0c45(var_9ed14cca, var_2fe972c1, var_8d53d8ef)
{
	level endon(#"hash_b0b992fb");
	exploder::exploder(var_8d53d8ef);
	wait(6);
	exploder::kill_exploder(var_8d53d8ef);
	var_4d74106b = getent("symbols_" + level.var_cf5a713.script_noteworthy, "targetname");
	var_4d74106b hidepart(var_2fe972c1);
	level notify(#"hash_706f7f9a");
	while(true)
	{
		var_9ed14cca waittill(#"trigger_activated");
		if(!level flag::get("simon_press_check"))
		{
			level flag::set("simon_press_check");
			var_4d74106b showpart(var_2fe972c1);
			playsoundatposition("zmb_ee_simonsays_button", var_9ed14cca.origin);
			exploder::exploder(var_8d53d8ef);
			wait(3);
			exploder::kill_exploder(var_8d53d8ef);
			var_4d74106b hidepart(var_2fe972c1);
			if(isdefined(var_9ed14cca.var_73527aa3) && var_9ed14cca.var_73527aa3)
			{
				level.var_521b0bd1++;
				var_4d74106b playsound("zmb_ee_simonsays_yay");
			}
			else
			{
				level flag::set("end_simon");
				var_4d74106b playsound("zmb_ee_simonsays_nay");
			}
			level notify(#"hash_b7f06cd9");
		}
		wait(0.15);
	}
}

/*
	Name: simon_timed_out
	Namespace: zm_castle_ee
	Checksum: 0xECA7F81E
	Offset: 0x7BA8
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function simon_timed_out(var_4d74106b, var_d733da61)
{
	level endon(#"simon_press_check");
	for(i = 6; i != -1; i--)
	{
		var_4d74106b playsound("zmb_ee_simonsays_timer");
		wait(1);
		if(i % 2)
		{
			exploder::kill_exploder(("lgt_EE_consol" + var_d733da61) + "_monitor_main");
			continue;
		}
		exploder::exploder(("lgt_EE_consol" + var_d733da61) + "_monitor_main");
	}
	level flag::set("simon_timed_out");
}

/*
	Name: function_71152937
	Namespace: zm_castle_ee
	Checksum: 0xF96B1EE3
	Offset: 0x7CB0
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_71152937()
{
	level scene::stop("cin_zm_castle_drgroph_easteregg");
	level.sndvoxoverride = 0;
	var_5fbf9989 = getentarray("safe_uc_clean", "targetname");
	foreach(var_fba414fd in var_5fbf9989)
	{
		var_fba414fd show();
	}
	level notify(#"hash_a8200e36");
	level zm_castle_vo::function_8ac5430();
}

/*
	Name: function_2c1aa78f
	Namespace: zm_castle_ee
	Checksum: 0x59667DBA
	Offset: 0x7DC0
	Size: 0x2FE
	Parameters: 0
	Flags: Linked
*/
function function_2c1aa78f()
{
	if(!isdefined(level.var_ab58bca7))
	{
		level.var_ab58bca7 = array(0, 0, 0);
	}
	var_b873610a = level flag::get("ee_safe_open");
	if(var_b873610a == 0)
	{
		for(i = 0; i < 3; i++)
		{
			level.var_ab58bca7[i] = randomint(4);
		}
	}
	if(!level flag::get("dimension_set"))
	{
		var_5fbf9989 = getentarray("safe_uc_clean", "targetname");
		foreach(var_fba414fd in var_5fbf9989)
		{
			var_fba414fd hide();
		}
		s_scriptbundle = struct::get("cin_zm_castle_drgroph_easteregg", "scriptbundlename");
		s_scriptbundle.scene_played = 0;
		level thread scene::init("cin_zm_castle_drgroph_easteregg");
		level zm_castle_vo::function_8ac5430(1, s_scriptbundle.origin);
		level waittill(#"hash_59b7ed");
		level thread scene::play("cin_zm_castle_drgroph_easteregg");
		var_4bff825e = getent("safe_code_past", "targetname");
		for(i = 0; i < 3; i++)
		{
			if(!level flag::get("dimension_set"))
			{
				level waittill("ee_button_" + (i + 1));
			}
			var_4bff825e showpart((("tag_scn" + i) + "_sym") + (level.var_ab58bca7[i] + 1));
		}
	}
}

/*
	Name: function_1ab64038
	Namespace: zm_castle_ee
	Checksum: 0xDA2D7EF4
	Offset: 0x80C8
	Size: 0x2F8
	Parameters: 0
	Flags: Linked
*/
function function_1ab64038()
{
	level endon(#"dimension_set");
	var_cf2f0df8 = struct::get("ee_lab_fuse");
	var_7698e9a4 = getent("fuse_box", "targetname");
	while(true)
	{
		var_7698e9a4 hidepart("j_chip01");
		var_7698e9a4 hidepart("j_chip02");
		level flag::wait_till("time_travel_teleporter_ready");
		var_5a28c976 = util::spawn_model("p7_zm_ctl_console_deathray_relay_2x", var_cf2f0df8.origin, var_cf2f0df8.angles);
		var_5a28c976 zm_castle_util::create_unitrigger();
		var_5a28c976 waittill(#"trigger_activated");
		level flag::set("ee_fuse_held_by_team");
		zm_unitrigger::unregister_unitrigger(var_5a28c976.s_unitrigger);
		playsoundatposition("zmb_fuse_pickup", var_5a28c976.origin);
		var_5a28c976 delete();
		var_7698e9a4 zm_castle_util::create_unitrigger();
		var_7698e9a4 waittill(#"trigger_activated");
		zm_unitrigger::unregister_unitrigger(var_7698e9a4.s_unitrigger);
		var_7698e9a4 playsound("zmb_fuse_place");
		var_7698e9a4 showpart("j_chip01");
		var_7698e9a4 showpart("j_chip02");
		exploder::exploder("fxexp_750");
		level flag::set("ee_fuse_placed");
		level flag::clear("ee_fuse_held_by_team");
		level flag::wait_till_clear("ee_fuse_placed");
		var_7698e9a4 playsound("zmb_fuse_explo");
		exploder::stop_exploder("fxexp_750");
	}
}

/*
	Name: function_71568f8
	Namespace: zm_castle_ee
	Checksum: 0x89D74508
	Offset: 0x83C8
	Size: 0x2B4
	Parameters: 0
	Flags: Linked
*/
function function_71568f8()
{
	var_abee83e8 = getent("ee_death_ray_switch_pointer", "targetname");
	var_abee83e8 rotatepitch(45, 0.25);
	level flag::set("switch_to_death_ray");
	var_367b15e7 = getent("ee_death_ray_switch", "targetname");
	var_367b15e7 rotatepitch(-180, 0.25);
	level flag::wait_till("ee_fuse_placed");
	var_367b15e7 zm_castle_util::create_unitrigger(undefined, 32);
	while(true)
	{
		while(!level flag::get("switch_to_death_ray"))
		{
			var_367b15e7 waittill(#"trigger_activated");
			if(level flag::get("ee_fuse_placed"))
			{
				var_367b15e7 rotatepitch(-180, 0.25);
				var_abee83e8 rotatepitch(90, 0.25);
				var_abee83e8 playsound("zmb_deathray_switch");
				level flag::set("switch_to_death_ray");
			}
		}
		while(level flag::get("switch_to_death_ray"))
		{
			var_367b15e7 waittill(#"trigger_activated");
			if(level flag::get("ee_fuse_placed"))
			{
				var_367b15e7 rotatepitch(180, 0.25);
				var_abee83e8 rotatepitch(-90, 0.25);
				var_abee83e8 playsound("zmb_deathray_switch");
				level flag::clear("switch_to_death_ray");
			}
		}
	}
}

/*
	Name: function_d2c78092
	Namespace: zm_castle_ee
	Checksum: 0x8DEB68E6
	Offset: 0x8688
	Size: 0x6FA
	Parameters: 0
	Flags: Linked
*/
function function_d2c78092()
{
	var_c5ea7ad8 = array(1, 2, 3, 4);
	while(!level flag::get("ee_safe_open"))
	{
		level flag::wait_till("ee_fuse_placed");
		level flag::wait_till("death_ray_trap_used");
		level thread function_fb090902(1);
		var_c5ea7ad8 = array::randomize(var_c5ea7ad8);
		level.var_a44ebbe8 = [];
		var_ebbefa14 = [];
		var_91d3caa4 = struct::get_array("golden_key_slot");
		foreach(s_slot in var_91d3caa4)
		{
			var_d733da61 = 1;
			if(s_slot.script_noteworthy == "launch_platform")
			{
				var_d733da61 = 2;
			}
			var_4d74106b = getent("symbols_" + s_slot.script_noteworthy, "targetname");
			for(i = 1; i <= 4; i++)
			{
				var_4d74106b showpart((("tag_scn" + i) + "_sym") + (var_c5ea7ad8[i - 1]));
				exploder::exploder((("lgt_EE_consol" + var_d733da61) + "_monitor_") + i);
				s_monitor = struct::get((("monitor_" + s_slot.script_noteworthy) + "_") + i);
				s_monitor.var_a95f1f56 = i;
				s_monitor.var_d82c7c68 = var_c5ea7ad8[i - 1];
				s_monitor zm_castle_util::create_unitrigger(undefined, 16);
				level thread function_96ca12f5(s_monitor);
				if(!isdefined(var_ebbefa14))
				{
					var_ebbefa14 = [];
				}
				else if(!isarray(var_ebbefa14))
				{
					var_ebbefa14 = array(var_ebbefa14);
				}
				var_ebbefa14[var_ebbefa14.size] = s_monitor;
			}
		}
		level waittill(#"hash_a126360f");
		foreach(var_2bfe2eca in var_ebbefa14)
		{
			zm_unitrigger::unregister_unitrigger(var_2bfe2eca.s_unitrigger);
			exploder::kill_exploder("lgt_EE_consol1_monitor_" + var_2bfe2eca.var_a95f1f56);
			exploder::kill_exploder("lgt_EE_consol2_monitor_" + var_2bfe2eca.var_a95f1f56);
		}
		function_2925fac8();
		var_d9768e8b = 1;
		for(i = 0; i < level.var_a44ebbe8.size; i++)
		{
			n_input = level.var_a44ebbe8[i] - 1;
			if(n_input != level.var_ab58bca7[i])
			{
				var_d9768e8b = 0;
			}
		}
		if(var_d9768e8b && !level flag::get("switch_to_death_ray"))
		{
			foreach(slot in var_91d3caa4)
			{
				playsoundatposition("zmb_ee_simonsays_complete", slot.origin);
			}
			playsoundatposition("zmb_object_final_success", (0, 0, 0));
			level flag::set("dimension_set");
			level flag::set("ee_safe_open");
		}
		else
		{
			foreach(slot in var_91d3caa4)
			{
				playsoundatposition("zmb_ee_simonsays_nay", slot.origin);
			}
			playsoundatposition("zmb_object_fail", (0, 0, 0));
			function_3918d831("safe_code_present");
			level flag::clear("ee_fuse_placed");
		}
		level.var_cc2ea6e8 = undefined;
	}
}

/*
	Name: function_3918d831
	Namespace: zm_castle_ee
	Checksum: 0xA16A123A
	Offset: 0x8D90
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function function_3918d831(var_ff61ccd6)
{
	var_4bff825e = getent(var_ff61ccd6, "targetname");
	for(i = 0; i < 3; i++)
	{
		for(j = 1; j <= 4; j++)
		{
			var_4bff825e hidepart((("tag_scn" + i) + "_sym") + j);
		}
	}
}

/*
	Name: function_96ca12f5
	Namespace: zm_castle_ee
	Checksum: 0xA00C8B42
	Offset: 0x8E60
	Size: 0x508
	Parameters: 1
	Flags: Linked
*/
function function_96ca12f5(var_2bfe2eca)
{
	level endon(#"hash_a126360f");
	var_6589e15e = getent("symbols_lower_tower", "targetname");
	var_d665b72a = getent("symbols_launch_platform", "targetname");
	while(true)
	{
		var_2bfe2eca waittill(#"trigger_activated");
		playsoundatposition("zmb_ee_simonsays_button", var_2bfe2eca.origin);
		if(!level flag::get("simon_press_check"))
		{
			level flag::set("simon_press_check");
			var_6589e15e hidepart((("tag_scn" + var_2bfe2eca.var_a95f1f56) + "_sym") + var_2bfe2eca.var_d82c7c68);
			var_d665b72a hidepart((("tag_scn" + var_2bfe2eca.var_a95f1f56) + "_sym") + var_2bfe2eca.var_d82c7c68);
			exploder::kill_exploder("lgt_EE_consol1_monitor_" + var_2bfe2eca.var_a95f1f56);
			exploder::kill_exploder("lgt_EE_consol2_monitor_" + var_2bfe2eca.var_a95f1f56);
			var_6589e15e showpart("tag_scn0_sym" + var_2bfe2eca.var_d82c7c68);
			var_d665b72a showpart("tag_scn0_sym" + var_2bfe2eca.var_d82c7c68);
			exploder::exploder("lgt_EE_consol1_monitor_main");
			exploder::exploder("lgt_EE_consol2_monitor_main");
			var_4bff825e = getent("safe_code_present", "targetname");
			var_4bff825e showpart((("tag_scn" + level.var_a44ebbe8.size) + "_sym") + var_2bfe2eca.var_d82c7c68);
			wait(1);
			var_6589e15e showpart((("tag_scn" + var_2bfe2eca.var_a95f1f56) + "_sym") + var_2bfe2eca.var_d82c7c68);
			var_d665b72a showpart((("tag_scn" + var_2bfe2eca.var_a95f1f56) + "_sym") + var_2bfe2eca.var_d82c7c68);
			exploder::exploder("lgt_EE_consol1_monitor_" + var_2bfe2eca.var_a95f1f56);
			exploder::exploder("lgt_EE_consol2_monitor_" + var_2bfe2eca.var_a95f1f56);
			var_6589e15e hidepart("tag_scn0_sym" + var_2bfe2eca.var_d82c7c68);
			var_d665b72a hidepart("tag_scn0_sym" + var_2bfe2eca.var_d82c7c68);
			exploder::kill_exploder("lgt_EE_consol1_monitor_main");
			exploder::kill_exploder("lgt_EE_consol2_monitor_main");
			if(!isdefined(level.var_a44ebbe8))
			{
				level.var_a44ebbe8 = [];
			}
			else if(!isarray(level.var_a44ebbe8))
			{
				level.var_a44ebbe8 = array(level.var_a44ebbe8);
			}
			level.var_a44ebbe8[level.var_a44ebbe8.size] = var_2bfe2eca.var_d82c7c68;
			level flag::clear("simon_press_check");
			if(level.var_a44ebbe8.size == 3)
			{
				level notify(#"hash_a126360f");
				return;
			}
		}
		wait(0.15);
	}
}

/*
	Name: function_c21dcd15
	Namespace: zm_castle_ee
	Checksum: 0x93E02523
	Offset: 0x9370
	Size: 0x35C
	Parameters: 0
	Flags: Linked
*/
function function_c21dcd15()
{
	level flag::wait_till("ee_safe_open");
	var_f3f0fbd = [];
	var_726d0daa = struct::get_array("tesla_connector");
	foreach(var_47bafa4c in var_726d0daa)
	{
		var_bb46ee5a = util::spawn_model("p7_zm_ctl_deathray_base_part", var_47bafa4c.origin, var_47bafa4c.angles);
		if(!isdefined(var_f3f0fbd))
		{
			var_f3f0fbd = [];
		}
		else if(!isarray(var_f3f0fbd))
		{
			var_f3f0fbd = array(var_f3f0fbd);
		}
		var_f3f0fbd[var_f3f0fbd.size] = var_bb46ee5a;
	}
	var_176b8aac = struct::get("ee_gold_key");
	mdl_key = util::spawn_model("p7_zm_ctl_keycard_ee", var_176b8aac.origin, var_176b8aac.angles);
	mdl_key.targetname = "golden_key";
	mdl_key zm_castle_util::create_unitrigger();
	var_8cf273a9 = getent("safe_uc_dmg_door", "targetname");
	var_8cf273a9 rotateyaw(-135, 1);
	var_8cf273a9 playsound("zmb_safe_open");
	mdl_key waittill(#"trigger_activated");
	zm_unitrigger::unregister_unitrigger(mdl_key.s_unitrigger);
	mdl_key ghost();
	for(i = 0; i < var_f3f0fbd.size; i++)
	{
		var_f3f0fbd[i] delete();
	}
	level thread function_8d27746("launch_platform", 21);
	level thread function_8d27746("lower_tower", 11);
	level flag::set("ee_golden_key");
	zm_castle_vo::function_6184b9c1();
}

/*
	Name: function_8d27746
	Namespace: zm_castle_ee
	Checksum: 0x368AC576
	Offset: 0x96D8
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function function_8d27746(str_suffix, n_exploder_id)
{
	var_96a3d068 = struct::get("tc_" + str_suffix);
	var_96a3d068 zm_castle_util::create_unitrigger();
	var_96a3d068 waittill(#"trigger_activated");
	zm_unitrigger::unregister_unitrigger(var_96a3d068.s_unitrigger);
	util::spawn_model("p7_zm_ctl_deathray_base_part", var_96a3d068.origin, var_96a3d068.angles);
	exploder::exploder("fxexp_7" + n_exploder_id);
	level flag::set("tesla_connector_" + str_suffix);
}

/*
	Name: function_82075ffb
	Namespace: zm_castle_ee
	Checksum: 0x54A75F2D
	Offset: 0x97D8
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_82075ffb()
{
	level flag::wait_till("time_travel_teleporter_ready");
	s_canister = struct::get("mpd_canister");
	var_bcaed8fa = util::spawn_model("p7_zm_ctl_undercroft_pyramid_canister", s_canister.origin, s_canister.angles);
	var_bcaed8fa zm_castle_util::create_unitrigger();
	var_bcaed8fa waittill(#"trigger_activated");
	var_bcaed8fa playsound("zmb_ee_mpd_broken_canister_pickup");
	zm_unitrigger::unregister_unitrigger(var_bcaed8fa.s_unitrigger);
	var_bcaed8fa delete();
	level flag::set("mpd_canister_replacement");
}

/*
	Name: function_a4b7a410
	Namespace: zm_castle_ee
	Checksum: 0x9F287F73
	Offset: 0x9900
	Size: 0x7AA
	Parameters: 0
	Flags: Linked
*/
function function_a4b7a410()
{
	level flag::wait_till("start_channeling_stone_step");
	level flag::wait_till("boss_fight_completed");
	var_649d30e8 = struct::get("mpd_pos");
	var_293d02aa = util::spawn_model("p7_zm_ctl_undercroft_pyramid", var_649d30e8.origin, var_649d30e8.angles);
	var_293d02aa.targetname = "undercroft_pyramid";
	level scene::init("p7_fxanim_zm_castle_moon_rocket_front_bundle");
	s_summoning_key = struct::get("ee_mpd_summoning_key");
	s_summoning_key zm_castle_util::create_unitrigger();
	s_summoning_key fx::play("summoning_key_glow", s_summoning_key.origin, s_summoning_key.angles, "delete_fx", 0, undefined, 1);
	s_summoning_key waittill(#"trigger_activated");
	zm_unitrigger::unregister_unitrigger(s_summoning_key.s_unitrigger);
	level thread zm_castle_vo::function_3ed74336();
	var_530ae70 = util::spawn_model("p7_zm_ctl_summoning_key_small", s_summoning_key.origin, s_summoning_key.angles);
	var_530ae70 setscale(1.5);
	level.var_758b41e = 1;
	foreach(player in level.players)
	{
		player thread function_ca73b878(var_530ae70.origin, "zone_undercroft");
	}
	playsoundatposition("evt_sum_key_place", var_530ae70.origin);
	wait(3);
	level.var_758b41e = undefined;
	s_summoning_key notify(#"delete_fx");
	var_530ae70 fx::play("summoning_key_done", s_summoning_key.origin, s_summoning_key.angles, undefined, 0, undefined, 1);
	playsoundatposition("evt_sum_key_charged", s_summoning_key.origin);
	s_summoning_key zm_castle_util::create_unitrigger();
	s_summoning_key waittill(#"trigger_activated");
	zm_unitrigger::unregister_unitrigger(s_summoning_key.s_unitrigger);
	var_530ae70 notify(#"delete_fx");
	var_530ae70 hide();
	playsoundatposition("evt_sum_key_take", var_530ae70.origin);
	s_summoning_key = struct::get("terminal_summoning_key");
	s_summoning_key zm_castle_util::create_unitrigger();
	s_summoning_key waittill(#"trigger_activated");
	zm_unitrigger::unregister_unitrigger(s_summoning_key.s_unitrigger);
	var_530ae70.origin = s_summoning_key.origin;
	var_530ae70 show();
	playsoundatposition("zmb_fuse_place", var_530ae70.origin);
	var_530ae70 fx::play("summoning_key_glow", var_530ae70.origin, var_530ae70.angles, "delete_fx", 0, undefined, 1);
	var_530ae70 fx::play("summoning_key_source", var_530ae70.origin, var_530ae70.angles, "delete_fx", 1, "tag_fx", 1);
	exploder::exploder("fxexp_620");
	function_f6678e99();
	level.var_513683a6 = undefined;
	exploder::stop_exploder("fxexp_620");
	var_530ae70 delete();
	exploder::stop_exploder("lgt_MPD_exp");
	exploder::stop_exploder("lgt_MPD_broken_exp");
	var_76c91f56 = getentarray("undercroft_pyramid", "targetname");
	foreach(var_293d02aa in var_76c91f56)
	{
		var_293d02aa connectpaths();
		var_293d02aa delete();
	}
	var_57615f80 = getentarray("pyramid", "targetname");
	foreach(var_27fd0c6f in var_57615f80)
	{
		var_54a70b81 = (var_27fd0c6f.origin[0], var_27fd0c6f.origin[1], var_27fd0c6f.origin[2] + 96);
		var_27fd0c6f moveto(var_54a70b81, 3);
		var_27fd0c6f thread function_ea0d3a5d();
	}
}

/*
	Name: function_ea0d3a5d
	Namespace: zm_castle_ee
	Checksum: 0x8C6AA52F
	Offset: 0xA0B8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_ea0d3a5d()
{
	self waittill(#"movedone");
	self solid();
	self disconnectpaths();
}

/*
	Name: function_f6678e99
	Namespace: zm_castle_ee
	Checksum: 0xAA5865B4
	Offset: 0xA100
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function function_f6678e99()
{
	level flag::set("sent_rockets_to_the_moon");
	/#
		level.var_844f510c = 1;
	#/
	if(level scene::is_playing("p7_fxanim_zm_castle_moon_rockets_bundle"))
	{
		level scene::stop("p7_fxanim_zm_castle_moon_rockets_bundle");
	}
	if(level scene::is_playing("p7_fxanim_zm_castle_moon_rockets_bck_bundle"))
	{
		level scene::stop("p7_fxanim_zm_castle_moon_rockets_bck_bundle");
	}
	function_1c4bd669(1);
	level thread zm_castle_vo::function_f28fd307();
	array::run_all(level.players, &playrumbleonentity, "zm_castle_moon_rocket_launch");
	level thread scene::play("p7_fxanim_zm_castle_moon_rocket_front_bundle");
	level thread zm_audio::sndmusicsystem_playstate("moon_rockets");
	wait(1);
	scene::add_scene_func("p7_fxanim_zm_castle_moon_rockets_bundle", &function_6a8d41d1);
	level thread scene::play("p7_fxanim_zm_castle_moon_rockets_bundle");
	wait(5.5);
	level scene::play("p7_fxanim_zm_castle_moon_rockets_bck_bundle");
}

/*
	Name: function_6a8d41d1
	Namespace: zm_castle_ee
	Checksum: 0x45B8704B
	Offset: 0xA2D8
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function function_6a8d41d1(a_ents)
{
	var_abd3814e = a_ents["moon_rocket_02"];
	var_abd3814e waittill(#"hash_c79f61d1");
	level thread function_6d74c298();
	exploder::exploder("fxexp_610");
	level scene::init("cin_cas_01_outro_3rd_sh010");
	wait(4);
	level clientfield::set("flip_skybox", 1);
	level function_339377d6();
	level flag::wait_till_timeout(17, "rockets_to_moon_vo_complete");
	level flag::set("ee_outro");
}

/*
	Name: function_6d74c298
	Namespace: zm_castle_ee
	Checksum: 0x86887C33
	Offset: 0xA3E8
	Size: 0x18A
	Parameters: 1
	Flags: Linked
*/
function function_6d74c298(var_e0e0227e)
{
	wait(3.5);
	array::run_all(level.players, &playrumbleonentity, "zm_castle_moon_explosion_rumble");
	setlightingstate(1);
	foreach(e_player in level.players)
	{
		e_player clientfield::set_to_player("moon_explosion_bank", 1);
	}
	wait(1);
	setlightingstate(0);
	foreach(e_player in level.players)
	{
		e_player clientfield::set_to_player("moon_explosion_bank", 0);
	}
}

/*
	Name: function_821a61ed
	Namespace: zm_castle_ee
	Checksum: 0xB4791D41
	Offset: 0xA580
	Size: 0x92
	Parameters: 0
	Flags: None
*/
function function_821a61ed()
{
	foreach(e_player in level.activeplayers)
	{
		if(e_player.characterindex == 2)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_ca73b878
	Namespace: zm_castle_ee
	Checksum: 0x2AC0CEE3
	Offset: 0xA620
	Size: 0x1C4
	Parameters: 2
	Flags: Linked
*/
function function_ca73b878(var_6ec25e68, str_zone)
{
	self endon(#"death");
	var_77b9bd02 = 0;
	while(isdefined(level.var_758b41e) && level.var_758b41e)
	{
		str_player_zone = self zm_zonemgr::get_player_zone();
		if(zm_utility::is_player_valid(self) && str_player_zone === str_zone)
		{
			if(!(isdefined(var_77b9bd02) && var_77b9bd02) && distance2dsquared(var_6ec25e68, self.origin) <= 15129)
			{
				self clientfield::set_to_player("gravity_trap_rumble", 1);
				var_77b9bd02 = 1;
			}
			else if(isdefined(var_77b9bd02) && var_77b9bd02 && distance2dsquared(var_6ec25e68, self.origin) > 15129)
			{
				self clientfield::set_to_player("gravity_trap_rumble", 0);
				var_77b9bd02 = 0;
			}
		}
		else if(isdefined(var_77b9bd02) && var_77b9bd02)
		{
			self clientfield::set_to_player("gravity_trap_rumble", 0);
			var_77b9bd02 = 0;
		}
		wait(0.15);
	}
	self clientfield::set_to_player("gravity_trap_rumble", 0);
}

/*
	Name: ee_outro
	Namespace: zm_castle_ee
	Checksum: 0xC145FC79
	Offset: 0xA7F0
	Size: 0x324
	Parameters: 0
	Flags: Linked
*/
function ee_outro()
{
	level flag::wait_till("ee_outro");
	level.sndoutro = 1;
	var_6f038754 = struct::get("tag_align_outro", "targetname");
	level zm_castle_vo::function_8ac5430(1, var_6f038754.origin);
	/#
		level function_1c4bd669(1, 0);
	#/
	zm_castle_vo::function_218256bd(1);
	var_d7e14379 = level function_58db5243(0);
	callback::remove_on_connect(&function_d4be5c9f);
	scene::add_scene_func("cin_cas_01_outro_3rd_sh010", &function_a029a5f1);
	scene::add_scene_func("cin_cas_01_outro_3rd_sh195", &function_3c1114e8);
	level scene::play("cin_cas_01_outro_3rd_sh010");
	level waittill(#"hash_8478520");
	level thread function_605386ad(0);
	function_1c4bd669(0);
	zm_castle_vo::function_218256bd(0);
	level zm_castle_vo::function_8ac5430();
	if(var_d7e14379)
	{
		level function_58db5243(1);
	}
	level notify(#"hash_b39ccbbf");
	players = getplayers();
	foreach(player in players)
	{
		scoreevents::processscoreevent("main_EE_quest_castle", player);
		player zm_stats::increment_global_stat("DARKOPS_CASTLE_EE");
		player zm_stats::increment_global_stat("DARKOPS_CASTLE_SUPER_EE");
	}
	level.sndoutro = 0;
	array::thread_all(level.activeplayers, &zm_utility::give_player_all_perks);
}

/*
	Name: function_339377d6
	Namespace: zm_castle_ee
	Checksum: 0x66394900
	Offset: 0xAB20
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function function_339377d6()
{
	/#
		if(isdefined(level.var_9a9741a5) && level.var_9a9741a5)
		{
			return;
		}
		level.var_9a9741a5 = 1;
	#/
	var_fba08aba = util::spawn_model("wpn_t7_pistol_mr6_prop", (600, 600, -170));
	var_fba08aba.targetname = "mr6_demp_left";
	var_fba08aba = util::spawn_model("wpn_t7_pistol_mr6_prop", (600, 600, -170));
	var_fba08aba.targetname = "mr6_demp_right";
	var_fba08aba = util::spawn_model("wpn_t7_pistol_mr6_prop", (600, 600, -170));
	var_fba08aba.targetname = "mr6_richtofen";
	var_fba08aba = util::spawn_model("wpn_t7_pistol_mr6_prop", (600, 600, -170));
	var_fba08aba.targetname = "mr6_takeo";
	var_fba08aba = util::spawn_model("wpn_t7_shotgun_spartan_prop", (600, 600, -170));
	var_fba08aba.targetname = "spartan";
	var_fba08aba = util::spawn_model("p7_zm_ctl_summoning_key_small", (600, 600, -170));
	var_fba08aba.targetname = "key";
}

/*
	Name: function_a029a5f1
	Namespace: zm_castle_ee
	Checksum: 0x37AC1863
	Offset: 0xACE0
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_a029a5f1(a_ents)
{
	pod_monitor_enable(a_ents);
	level function_605386ad(1);
	wait(0.1);
	level thread function_36bef27a();
}

/*
	Name: pod_monitor_enable
	Namespace: zm_castle_ee
	Checksum: 0xACB9B5CB
	Offset: 0xAD48
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function pod_monitor_enable(a_ents)
{
	var_165d49f6 = a_ents["pod"];
	var_165d49f6 clientfield::set("pod_monitor_enable", 1);
}

/*
	Name: function_3c1114e8
	Namespace: zm_castle_ee
	Checksum: 0xD5E94308
	Offset: 0xAD98
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_3c1114e8(a_ents)
{
	var_165d49f6 = a_ents["pod"];
	var_165d49f6 clientfield::set("pod_monitor_enable", 0);
}

/*
	Name: function_605386ad
	Namespace: zm_castle_ee
	Checksum: 0x571F6097
	Offset: 0xADE8
	Size: 0x132
	Parameters: 1
	Flags: Linked
*/
function function_605386ad(var_1e73529b)
{
	if(var_1e73529b)
	{
		foreach(e_player in level.players)
		{
			e_player clientfield::set_to_player("outro_lighting_banks", 1);
		}
	}
	else
	{
		foreach(e_player in level.players)
		{
			e_player clientfield::set_to_player("outro_lighting_banks", 0);
		}
	}
}

/*
	Name: function_58db5243
	Namespace: zm_castle_ee
	Checksum: 0x98EBE603
	Offset: 0xAF28
	Size: 0x10E
	Parameters: 1
	Flags: Linked
*/
function function_58db5243(b_show)
{
	foreach(s_chest in level.chests)
	{
		if(s_chest.script_noteworthy == "courtyard_chest")
		{
			if(!b_show && s_chest.hidden === 0)
			{
				s_chest zm_magicbox::hide_chest();
				return true;
			}
			if(b_show && s_chest.hidden == 1)
			{
				s_chest zm_magicbox::show_chest();
			}
			return false;
		}
	}
}

/*
	Name: function_36bef27a
	Namespace: zm_castle_ee
	Checksum: 0x17292107
	Offset: 0xB040
	Size: 0x102
	Parameters: 0
	Flags: Linked
*/
function function_36bef27a()
{
	foreach(e_player in level.players)
	{
		str_position = "ee_outro_end_position_" + e_player.characterindex;
		s_spawn = struct::get(str_position, "targetname");
		e_player setorigin(s_spawn.origin);
		e_player setplayerangles(s_spawn.angles);
	}
}

/*
	Name: function_1c4bd669
	Namespace: zm_castle_ee
	Checksum: 0xCCE7C621
	Offset: 0xB150
	Size: 0xB4
	Parameters: 2
	Flags: Linked
*/
function function_1c4bd669(b_pause = 0, var_9d3d4d3f = 1)
{
	if(b_pause)
	{
		level.disable_nuke_delay_spawning = 1;
		level flag::clear("spawn_zombies");
		function_5db6ba34(var_9d3d4d3f);
	}
	else
	{
		level.disable_nuke_delay_spawning = 0;
		level flag::set("spawn_zombies");
	}
}

/*
	Name: function_5db6ba34
	Namespace: zm_castle_ee
	Checksum: 0xBF3A67D0
	Offset: 0xB210
	Size: 0x554
	Parameters: 1
	Flags: Linked
*/
function function_5db6ba34(var_1a60ad71 = 1)
{
	if(var_1a60ad71)
	{
		level thread lui::screen_flash(0.2, 0.5, 1, 0.8, "white");
	}
	wait(0.5);
	a_ai_zombies = getaiteamarray(level.zombie_team);
	var_6b1085eb = [];
	foreach(ai_zombie in a_ai_zombies)
	{
		ai_zombie.no_powerups = 1;
		ai_zombie.deathpoints_already_given = 1;
		if(isdefined(ai_zombie.ignore_nuke) && ai_zombie.ignore_nuke)
		{
			continue;
		}
		if(isdefined(ai_zombie.marked_for_death) && ai_zombie.marked_for_death)
		{
			continue;
		}
		if(isdefined(ai_zombie.nuke_damage_func))
		{
			ai_zombie thread [[ai_zombie.nuke_damage_func]]();
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(ai_zombie))
		{
			continue;
		}
		ai_zombie.marked_for_death = 1;
		ai_zombie.nuked = 1;
		var_6b1085eb[var_6b1085eb.size] = ai_zombie;
	}
	foreach(i, var_f92b3d80 in var_6b1085eb)
	{
		wait(randomfloatrange(0.1, 0.2));
		if(!isdefined(var_f92b3d80))
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(var_f92b3d80))
		{
			continue;
		}
		if(i < 5 && (!(isdefined(var_f92b3d80.isdog) && var_f92b3d80.isdog)))
		{
			var_f92b3d80 thread zombie_death::flame_death_fx();
		}
		if(!(isdefined(var_f92b3d80.isdog) && var_f92b3d80.isdog))
		{
			if(!(isdefined(var_f92b3d80.no_gib) && var_f92b3d80.no_gib))
			{
				var_f92b3d80 zombie_utility::zombie_head_gib();
			}
		}
		var_f92b3d80 dodamage(var_f92b3d80.health, var_f92b3d80.origin);
		if(!level flag::get("special_round"))
		{
			level.zombie_total++;
		}
	}
	var_6cbdc65 = [];
	var_c94c86a8 = getentarray("mechz", "targetname");
	foreach(ai_mechz in var_c94c86a8)
	{
		var_63b71acf = 0;
		if(isdefined(ai_mechz.no_damage_points) && ai_mechz.no_damage_points)
		{
			var_63b71acf = 1;
		}
		if(!isdefined(var_6cbdc65))
		{
			var_6cbdc65 = [];
		}
		else if(!isarray(var_6cbdc65))
		{
			var_6cbdc65 = array(var_6cbdc65);
		}
		var_6cbdc65[var_6cbdc65.size] = var_63b71acf;
		ai_mechz.no_powerups = 1;
		ai_mechz kill();
	}
	level thread function_3fade785(var_6cbdc65);
}

/*
	Name: function_3fade785
	Namespace: zm_castle_ee
	Checksum: 0xFCC7C465
	Offset: 0xB770
	Size: 0x182
	Parameters: 1
	Flags: Linked
*/
function function_3fade785(var_6cbdc65)
{
	level flag::wait_till("spawn_zombies");
	for(i = 0; i < var_6cbdc65.size; i++)
	{
		e_target = array::random(level.players);
		while(!zm_utility::is_player_valid(e_target))
		{
			wait(0.05);
			e_target = array::random(level.players);
		}
		s_spawn_pos = arraygetclosest(e_target.origin, level.zm_loc_types["mechz_location"]);
		if(isdefined(s_spawn_pos))
		{
			ai_mechz = zm_castle_mechz::function_314d744b(0, s_spawn_pos, 1);
			if(isdefined(var_6cbdc65[i]) && var_6cbdc65[i])
			{
				ai_mechz.no_damage_points = 1;
				ai_mechz.deathpoints_already_given = 1;
				ai_mechz.exclude_cleanup_adding_to_total = 1;
			}
		}
	}
}

/*
	Name: function_af71af0e
	Namespace: zm_castle_ee
	Checksum: 0x2EEE209C
	Offset: 0xB900
	Size: 0x156
	Parameters: 0
	Flags: Linked
*/
function function_af71af0e()
{
	if(!isdefined(level.var_1f18338d))
	{
		return;
	}
	if(isdefined(self.var_1ceefee5) && self.var_1ceefee5)
	{
		return;
	}
	self.var_1ceefee5 = 1;
	switch(level.var_1f18338d)
	{
		case "demongate":
		{
			self clientfield::set_to_player("player_ee_cs_circle", 1);
			break;
		}
		case "rune_prison":
		{
			self clientfield::set_to_player("player_ee_cs_circle", 2);
			break;
		}
		case "storm":
		{
			self clientfield::set_to_player("player_ee_cs_circle", 3);
			break;
		}
		case "wolf_howl":
		{
			self clientfield::set_to_player("player_ee_cs_circle", 4);
			break;
		}
	}
	while(isdefined(self.var_507ad4a9) && self.var_507ad4a9)
	{
		wait(0.1);
	}
	self clientfield::set_to_player("player_ee_cs_circle", 0);
	self.var_1ceefee5 = undefined;
}

/*
	Name: function_fb090902
	Namespace: zm_castle_ee
	Checksum: 0x6D8DA07A
	Offset: 0xBA60
	Size: 0x2BA
	Parameters: 1
	Flags: Linked
*/
function function_fb090902(var_f3afc16d)
{
	level notify(#"hash_dbc0b10c");
	level endon(#"hash_dbc0b10c");
	level.var_cc2ea6e8 = 1;
	var_fe586166 = 0;
	while(isdefined(level.var_cc2ea6e8) && level.var_cc2ea6e8)
	{
		if(function_dd1b044(var_f3afc16d))
		{
			var_565450eb = zombie_utility::get_current_zombie_count();
			var_fe586166 = function_36c5b9b9();
			var_c33cc7f2 = 8;
			if(level flag::get("solo_game"))
			{
				var_c33cc7f2 = 3;
			}
			if(var_fe586166 <= var_c33cc7f2 && (var_fe586166 + var_565450eb) < level.zombie_vars["zombie_max_ai"])
			{
				var_19764360 = zm_ai_dogs::get_favorite_enemy();
				s_spawn_pos = zm_castle_dogs::function_92e4eaff(level.dog_spawners[0], var_19764360);
				if(isdefined(s_spawn_pos))
				{
					ai_dog = zombie_utility::spawn_zombie(level.dog_spawners[0]);
					if(isdefined(ai_dog))
					{
						ai_dog.favoriteenemy = var_19764360;
						ai_dog.ignore_enemy_count = 1;
						ai_dog.no_damage_points = 1;
						ai_dog.deathpoints_already_given = 1;
						ai_dog.exclude_cleanup_adding_to_total = 1;
						s_spawn_pos thread zm_ai_dogs::dog_spawn_fx(ai_dog, s_spawn_pos);
						level flag::set("dog_clips");
						ai_dog.no_powerups = 1;
						ai_dog thread function_e5803575();
					}
				}
			}
		}
		n_wait = 3;
		if(level flag::get("solo_game"))
		{
			n_wait = 9;
		}
		wait(n_wait);
	}
}

/*
	Name: function_dd1b044
	Namespace: zm_castle_ee
	Checksum: 0xE51A09B7
	Offset: 0xBD28
	Size: 0x62
	Parameters: 1
	Flags: Linked
*/
function function_dd1b044(var_f3afc16d)
{
	var_d695363e = 1;
	if(isdefined(var_f3afc16d) && var_f3afc16d && level flag::get("solo_game"))
	{
		var_d695363e = 0;
	}
	return var_d695363e;
}

/*
	Name: function_36c5b9b9
	Namespace: zm_castle_ee
	Checksum: 0x76B0B9B3
	Offset: 0xBD98
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function function_36c5b9b9()
{
	var_1cea043e = getentarray("zombie_dog", "targetname");
	return var_1cea043e.size;
}

/*
	Name: function_e5803575
	Namespace: zm_castle_ee
	Checksum: 0x88667B42
	Offset: 0xBDD8
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function function_e5803575()
{
	self endon(#"death");
	v_start_pos = self.origin;
	var_20a609dc = 0;
	while(true)
	{
		wait(5);
		if(v_start_pos === self.origin)
		{
			if(var_20a609dc >= 2)
			{
				self kill();
			}
			self.favoriteenemy = zm_ai_dogs::get_favorite_enemy();
			v_start_pos = self.origin;
			var_20a609dc++;
		}
	}
}

/*
	Name: function_88e260d
	Namespace: zm_castle_ee
	Checksum: 0x31B4A817
	Offset: 0xBE90
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function function_88e260d()
{
	level waittill(#"hash_d8b279ab");
	s_spawn_pos = arraygetclosest(self.origin, level.zm_loc_types["mechz_location"]);
	if(!isdefined(s_spawn_pos))
	{
		var_79ed5347 = struct::get_array("mechz_location", "script_noteworthy");
		foreach(var_6000fab5 in var_79ed5347)
		{
			if(var_6000fab5.targetname == "zone_start_spawners")
			{
				s_spawn_pos = var_6000fab5;
			}
		}
	}
	ai_mechz = zm_castle_mechz::function_314d744b(0, s_spawn_pos, 1);
	ai_mechz.no_damage_points = 1;
	ai_mechz.deathpoints_already_given = 1;
	ai_mechz.exclude_cleanup_adding_to_total = 1;
}

/*
	Name: function_d6026710
	Namespace: zm_castle_ee
	Checksum: 0xEAEA441
	Offset: 0xC018
	Size: 0x42C
	Parameters: 0
	Flags: Linked
*/
function function_d6026710()
{
	/#
		level flag::init("");
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_690690ef);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_b1c42655);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_dc5045eb);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_c197b24a);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_3c8db42b);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_64783c5e);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_a1ac1452);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_bbf6c2d0);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_a9a41cbd);
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		level thread setup_devgui_func("", "", 1, &function_71b77de5);
		level thread setup_devgui_func("", "", 1, &function_d6a136ff);
		level thread setup_devgui_func("", "", 1, &function_f62f3c89);
		adddebugcommand("");
		adddebugcommand("");
		level thread function_ef5eaa6e();
		level thread function_dd0c3214();
		level thread function_b38b0751();
	#/
}

/*
	Name: function_690690ef
	Namespace: zm_castle_ee
	Checksum: 0x4E4FF8ED
	Offset: 0xC450
	Size: 0xBA
	Parameters: 1
	Flags: Linked
*/
function function_690690ef(n_val)
{
	/#
		level endon(#"hash_a8200e36");
		if(!level flag::get(""))
		{
			level thread function_61036bd1();
		}
		zm_zonemgr::enable_zone("");
		level flag::set("");
		level waittill(#"start_of_round");
		level flag::clear("");
		level notify(#"hash_a8200e36");
	#/
}

/*
	Name: function_a9a41cbd
	Namespace: zm_castle_ee
	Checksum: 0xCCD5333
	Offset: 0xC518
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_a9a41cbd(n_val)
{
	/#
		zm_castle_vo::function_70721c81();
	#/
}

/*
	Name: function_d6a136ff
	Namespace: zm_castle_ee
	Checksum: 0x36F4CB9D
	Offset: 0xC548
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_d6a136ff(n_val)
{
	/#
		zm_castle_vo::function_44c11f63();
	#/
}

/*
	Name: function_b1c42655
	Namespace: zm_castle_ee
	Checksum: 0xE549DFA3
	Offset: 0xC578
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_b1c42655(n_val)
{
	/#
		level flag::set("");
	#/
}

/*
	Name: function_dc5045eb
	Namespace: zm_castle_ee
	Checksum: 0xB85839CE
	Offset: 0xC5B0
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_dc5045eb(n_val)
{
	/#
		level scene::stop("");
		s_scriptbundle = struct::get("", "");
		s_scriptbundle.scene_played = 0;
		level thread scene::play("");
	#/
}

/*
	Name: function_c197b24a
	Namespace: zm_castle_ee
	Checksum: 0x546DB962
	Offset: 0xC640
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_c197b24a(n_val)
{
	/#
		level flag::set("");
	#/
}

/*
	Name: function_3c8db42b
	Namespace: zm_castle_ee
	Checksum: 0x8CA594F7
	Offset: 0xC678
	Size: 0xEA
	Parameters: 1
	Flags: Linked
*/
function function_3c8db42b(n_val)
{
	/#
		players = level.activeplayers;
		foreach(player in players)
		{
			b_on = player clientfield::get_to_player("");
			b_on = !b_on;
			player clientfield::set_to_player("", b_on);
		}
	#/
}

/*
	Name: function_ef5eaa6e
	Namespace: zm_castle_ee
	Checksum: 0x7FE5EE
	Offset: 0xC770
	Size: 0x178
	Parameters: 0
	Flags: Linked
*/
function function_ef5eaa6e()
{
	/#
		level waittill(#"start_zombie_round_logic");
		var_1bdfdb3b = array("", "", "", "");
		level flag::wait_till_any(var_1bdfdb3b);
		while(true)
		{
			if(getdvarint("") == 1 && isdefined(level.var_a0ef3c5e) && level.var_a0ef3c5e.var_ebeea021)
			{
				if(!level flag::get(""))
				{
					level flag::set("");
				}
				print3d(level.var_a0ef3c5e.origin, "", vectorscale((0, 1, 0), 255), 1, 3);
			}
			else if(level flag::get(""))
			{
				level flag::clear("");
			}
			wait(0.15);
		}
	#/
}

/*
	Name: function_64783c5e
	Namespace: zm_castle_ee
	Checksum: 0x697C9D02
	Offset: 0xC8F0
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_64783c5e(n_val)
{
	/#
		level flag::set("");
		wait(0.15);
		level.var_521b0bd1 = 9;
		level notify(#"hash_b7f06cd9");
		level.var_e3162591 = 1;
		level flag::set("");
	#/
}

/*
	Name: function_71b77de5
	Namespace: zm_castle_ee
	Checksum: 0x86A4640E
	Offset: 0xC978
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_71b77de5(n_val)
{
	/#
		function_7d8964c9();
	#/
}

/*
	Name: function_a1ac1452
	Namespace: zm_castle_ee
	Checksum: 0x1AF791C2
	Offset: 0xC9A8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_a1ac1452(n_val)
{
	/#
		function_f6678e99();
	#/
}

/*
	Name: function_f62f3c89
	Namespace: zm_castle_ee
	Checksum: 0x460D5B46
	Offset: 0xC9D8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_f62f3c89(n_val)
{
	/#
		level thread vril_generator();
		level flag::set("");
	#/
}

/*
	Name: function_dd0c3214
	Namespace: zm_castle_ee
	Checksum: 0xB85C191E
	Offset: 0xCA28
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_dd0c3214()
{
	/#
		while(true)
		{
			level.var_b5231dfb = getdvarint("");
			wait(0.15);
		}
	#/
}

/*
	Name: function_b38b0751
	Namespace: zm_castle_ee
	Checksum: 0xA3649FC3
	Offset: 0xCA70
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function function_b38b0751()
{
	/#
		while(true)
		{
			if(getdvarint("") == 1)
			{
				setdvar("", 0);
				var_747532f4 = getent("", "");
				var_747532f4 notify(#"keeper_charge");
				var_747532f4 notify(#"start_moving");
				str_exploder = function_ac7d9299();
				exploder::kill_exploder(str_exploder);
				level flag::set("");
			}
			wait(0.15);
		}
	#/
}

/*
	Name: function_bbf6c2d0
	Namespace: zm_castle_ee
	Checksum: 0x46C5AA05
	Offset: 0xCB70
	Size: 0x14C
	Parameters: 1
	Flags: Linked
*/
function function_bbf6c2d0(n_val)
{
	/#
		if(!(isdefined(level.var_844f510c) && level.var_844f510c))
		{
			level function_339377d6();
		}
		if(!level scene::is_playing(""))
		{
			level thread scene::play("");
		}
		var_c4556169 = getent("", "");
		var_c4556169 show();
		var_e7d455cc = getent("", "");
		if(isdefined(var_e7d455cc))
		{
			var_e7d455cc delete();
		}
		level scene::init("");
		wait(3);
		level flag::set("");
	#/
}

/*
	Name: setup_devgui_func
	Namespace: zm_castle_ee
	Checksum: 0x2B4EEC46
	Offset: 0xCCC8
	Size: 0x120
	Parameters: 5
	Flags: Linked
*/
function setup_devgui_func(str_devgui_path, str_dvar, n_value, func, n_base_value)
{
	/#
		if(!isdefined(n_base_value))
		{
			n_base_value = -1;
		}
		setdvar(str_dvar, n_base_value);
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

