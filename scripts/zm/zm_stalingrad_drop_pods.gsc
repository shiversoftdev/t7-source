// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_attackables;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_stalingrad_ee_main;
#using scripts\zm\zm_stalingrad_pap_quest;
#using scripts\zm\zm_stalingrad_util;
#using scripts\zm\zm_stalingrad_vo;

#using_animtree("generic");

#namespace namespace_2e6e7fce;

/*
	Name: function_2bb254bb
	Namespace: namespace_2e6e7fce
	Checksum: 0x1E8ABC74
	Offset: 0xF48
	Size: 0x724
	Parameters: 0
	Flags: Linked
*/
function function_2bb254bb()
{
	level flag::init("spawn_ee_harassers");
	level flag::init("advance_drop_pod_round");
	level.var_583e4a97 = spawnstruct();
	level.var_583e4a97.var_5d8406ed = [];
	level.var_583e4a97.var_f2d794f3 = [];
	level.var_583e4a97.var_a622ee25 = 0;
	level.var_583e4a97.var_a43689b5 = 0;
	level thread function_6b964717();
	var_8f0097a0 = struct::get_array("drop_pod", "targetname");
	foreach(s_location in var_8f0097a0)
	{
		str_location = (s_location.script_string + "") + s_location.script_int;
		level.var_583e4a97.var_5d8406ed[str_location] = s_location;
		s_location.b_available = 0;
	}
	level thread function_6905fcad("department_store_upper_open", "department_store");
	level thread function_6905fcad("activate_red_brick", "red");
	level thread function_6905fcad("activate_yellow", "yellow");
	level thread function_6905fcad("activate_judicial", "judicial");
	level thread function_6905fcad("factory_open", "factory");
	level thread function_6905fcad("library_open", "library");
	level thread function_6905fcad("activate_bunker", "alley");
	var_aa0a923d = getentarray("drop_pod_score_volume", "targetname");
	foreach(volume in var_aa0a923d)
	{
		str_location = volume.script_string;
		level.var_583e4a97.var_5d8406ed[str_location].e_goal_volume = volume;
	}
	var_c746b61a = struct::get_array("drop_pod_attackable", "targetname");
	foreach(s_attack_point in var_c746b61a)
	{
		str_location = s_attack_point.script_string;
		level.var_583e4a97.var_5d8406ed[str_location].var_b454101b = s_attack_point;
	}
	level.var_583e4a97.var_365bcb3c = 0;
	flag::wait_till("start_zombie_round_logic");
	foreach(var_3d8a9064 in level.var_583e4a97.var_5d8406ed)
	{
		var_3d8a9064 thread function_d4c6ea10();
	}
	var_b8fe8638 = struct::get_array("drop_pod_radio", "targetname");
	foreach(s_radio in var_b8fe8638)
	{
		s_radio.b_used = 0;
		s_radio zm_unitrigger::create_unitrigger(&"ZM_STALINGRAD_DROP_POD_ACTIVATE", undefined, &function_f7b738bf);
		s_radio thread function_5f435187();
	}
	var_45b3db60 = getent("drop_pod_terminal_library", "targetname");
	var_45b3db60 thread function_ee55d7d6();
	var_23f1153b = getent("drop_pod_terminal_factory", "targetname");
	var_23f1153b thread function_ee55d7d6();
	var_4ebf9e26 = getent("drop_pod_terminal_judicial", "targetname");
	var_4ebf9e26 thread function_ee55d7d6();
	level flag::set("drop_pod_init_done");
	level flag::set("spawn_ee_harassers");
}

/*
	Name: function_f7b738bf
	Namespace: namespace_2e6e7fce
	Checksum: 0xBE8E6E86
	Offset: 0x1678
	Size: 0x286
	Parameters: 1
	Flags: Linked
*/
function function_f7b738bf(e_player)
{
	if(e_player zm_utility::in_revive_trigger())
	{
		self sethintstring(&"");
		return false;
	}
	if(e_player.is_drinking > 0)
	{
		self sethintstring(&"");
		return false;
	}
	if(!level flag::get("power_on"))
	{
		self sethintstring(&"ZM_STALINGRAD_POWER_REQUIRED");
		return false;
	}
	if(level flag::get("special_round") || level flag::get("ee_round"))
	{
		self sethintstring(&"ZM_STALINGRAD_CONSOLE_DISABLED");
		return false;
	}
	if(level flag::get("drop_pod_spawned"))
	{
		self sethintstring(&"ZM_STALINGRAD_DROP_POD_ACTIVE");
		return false;
	}
	if(!isdefined(level.var_583e4a97.var_caa5bc3e))
	{
		self sethintstring(&"ZM_STALINGRAD_DROP_POD_CYLINDER_REQUIRED");
		return true;
	}
	if(isdefined(level.var_583e4a97.var_caa5bc3e) && self.stub.related_parent.script_parameters != level.var_583e4a97.var_caa5bc3e)
	{
		self sethintstring(&"ZM_STALINGRAD_DROP_POD_INCORRECT_CYLINDER");
		return true;
	}
	if(self.stub.related_parent.script_parameters == level.var_583e4a97.var_caa5bc3e)
	{
		self sethintstring(&"ZM_STALINGRAD_DROP_POD_ACTIVATE");
		return true;
	}
	self sethintstring("");
	return false;
}

/*
	Name: function_5f435187
	Namespace: namespace_2e6e7fce
	Checksum: 0x35A0E648
	Offset: 0x1908
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function function_5f435187()
{
	while(true)
	{
		self waittill(#"trigger_activated", e_who);
		if(level flag::get("special_round") || level flag::get("ee_round"))
		{
			continue;
		}
		else
		{
			if(!isdefined(level.var_583e4a97.var_caa5bc3e))
			{
				level thread zm_stalingrad_vo::function_eaf2cef3();
				continue;
			}
			else if(isdefined(level.var_583e4a97.var_caa5bc3e) && self.script_parameters != level.var_583e4a97.var_caa5bc3e)
			{
				level thread zm_stalingrad_vo::function_c0135bef();
				continue;
			}
		}
		e_who clientfield::increment_to_player("interact_rumble");
		self thread function_8aebb789();
	}
}

/*
	Name: function_8aebb789
	Namespace: namespace_2e6e7fce
	Checksum: 0xE48FDF91
	Offset: 0x1A38
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function function_8aebb789()
{
	level.var_583e4a97.s_radio = self;
	var_cc373138 = getent(self.target, "targetname");
	var_cc373138 thread function_f5212f09();
	level thread zm_stalingrad_pap::function_809fbbff(self.script_string);
	level flag::set("drop_pod_active");
	level flag::clear("ambient_mortar_fire_on");
	foreach(player in level.activeplayers)
	{
		player clientfield::set_player_uimodel("zmInventory.piece_cylinder", 0);
	}
	switch(level.var_583e4a97.var_caa5bc3e)
	{
		case "code_cylinder_blue":
		{
			level.var_583e4a97.var_4bf647dc = "yellow";
			break;
		}
		case "code_cylinder_yellow":
		{
			level.var_583e4a97.var_4bf647dc = "red";
			break;
		}
		case "code_cylinder_red":
		{
			level.var_583e4a97.var_4bf647dc = "blue";
			break;
		}
	}
	level.var_583e4a97.var_caa5bc3e = undefined;
	level.var_583e4a97.var_a622ee25 = 0;
}

/*
	Name: function_ee55d7d6
	Namespace: namespace_2e6e7fce
	Checksum: 0xD2B98F13
	Offset: 0x1C38
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_ee55d7d6()
{
	self hidepart("tag_code_cylinder");
	self hidepart("tag_screen_main_green");
}

/*
	Name: function_f5212f09
	Namespace: namespace_2e6e7fce
	Checksum: 0x9093D37D
	Offset: 0x1C88
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_f5212f09()
{
	self showpart("tag_code_cylinder");
	self playsoundontag("zmb_stalingrad_pod_cylinder_insert", "tag_code_cylinder");
	self hidepart("tag_screen_main_green");
	self showpart("tag_screen_main_red");
	wait(3);
	self hidepart("tag_code_cylinder");
	self playsoundontag("zmb_stalingrad_pod_cylinder_explo", "tag_code_cylinder");
}

/*
	Name: function_d4c6ea10
	Namespace: namespace_2e6e7fce
	Checksum: 0x93911D66
	Offset: 0x1D68
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_d4c6ea10()
{
	self.n_current_progress = 0;
	self.var_d2e1ce53 = 0;
}

/*
	Name: function_6905fcad
	Namespace: namespace_2e6e7fce
	Checksum: 0xD64212B6
	Offset: 0x1D90
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function function_6905fcad(var_f3bda498, str_zone)
{
	level waittill(var_f3bda498);
	level function_830313d1(str_zone);
}

/*
	Name: function_830313d1
	Namespace: namespace_2e6e7fce
	Checksum: 0x857A642F
	Offset: 0x1DD0
	Size: 0x22A
	Parameters: 1
	Flags: Linked
*/
function function_830313d1(str_zone)
{
	switch(str_zone)
	{
		case "department_store":
		{
			level.var_583e4a97.var_5d8406ed["department_store1"].b_available = 1;
			break;
		}
		case "alley":
		{
			level.var_583e4a97.var_5d8406ed["alley1"].b_available = 1;
			break;
		}
		case "red":
		{
			level.var_583e4a97.var_5d8406ed["red1"].b_available = 1;
			break;
		}
		case "yellow":
		{
			level.var_583e4a97.var_5d8406ed["yellow1"].b_available = 1;
			break;
		}
		case "judicial":
		{
			level.var_583e4a97.var_5d8406ed["judicial1"].b_available = 1;
			level.var_583e4a97.var_5d8406ed["judicial2"].b_available = 1;
			level.var_583e4a97.var_5d8406ed["judicial3"].b_available = 1;
			break;
		}
		case "library":
		{
			level.var_583e4a97.var_5d8406ed["library1"].b_available = 1;
			level.var_583e4a97.var_5d8406ed["library2"].b_available = 1;
			break;
		}
		case "factory":
		{
			level.var_583e4a97.var_5d8406ed["factory1"].b_available = 1;
			level.var_583e4a97.var_5d8406ed["factory2"].b_available = 1;
			break;
		}
	}
}

/*
	Name: function_6b964717
	Namespace: namespace_2e6e7fce
	Checksum: 0x742F9FD
	Offset: 0x2008
	Size: 0x26C
	Parameters: 0
	Flags: Linked
*/
function function_6b964717()
{
	level flag::init("between_rounds");
	level flag::wait_till("power_on");
	level thread function_855f59cb();
	level.var_583e4a97.var_cac771d3 = 0;
	level.var_583e4a97.var_a622ee25 = 0;
	level.var_583e4a97.var_4bf647dc = "blue";
	level.var_583e4a97.var_a43689b5 = 10;
	zm_powerups::register_powerup("code_cylinder_red", &function_86d9efb0);
	zm_powerups::register_powerup("code_cylinder_yellow", &function_86d9efb0);
	zm_powerups::register_powerup("code_cylinder_blue", &function_86d9efb0);
	zm_powerups::add_zombie_powerup("code_cylinder_red", "p7_zm_sta_code_cylinder_red", &"ZM_STALINGRAD_CODE_CYLINER_HINT", undefined, 0, 0, 0);
	zm_powerups::add_zombie_powerup("code_cylinder_yellow", "p7_zm_sta_code_cylinder_yellow", &"ZM_STALINGRAD_CODE_CYLINER_HINT", undefined, 0, 0, 0);
	zm_powerups::add_zombie_powerup("code_cylinder_blue", "p7_zm_sta_code_cylinder", &"ZM_STALINGRAD_CODE_CYLINER_HINT", undefined, 0, 0, 0);
	zm_powerups::powerup_remove_from_regular_drops("code_cylinder_red");
	zm_powerups::powerup_remove_from_regular_drops("code_cylinder_yellow");
	zm_powerups::powerup_remove_from_regular_drops("code_cylinder_blue");
	zm_powerups::powerup_set_statless_powerup("code_cylinder_red");
	zm_powerups::powerup_set_statless_powerup("code_cylinder_yellow");
	zm_powerups::powerup_set_statless_powerup("code_cylinder_blue");
	zm_spawner::register_zombie_death_event_callback(&function_1389d425);
}

/*
	Name: function_855f59cb
	Namespace: namespace_2e6e7fce
	Checksum: 0xB0A87090
	Offset: 0x2280
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_855f59cb()
{
	level endon(#"end_game");
	while(true)
	{
		level waittill(#"end_of_round");
		level flag::set("between_rounds");
		level thread function_a3d6f85c();
		level waittill(#"start_of_round");
		level flag::clear("between_rounds");
		level.var_583e4a97.var_cac771d3 = 0;
	}
}

/*
	Name: function_86d9efb0
	Namespace: namespace_2e6e7fce
	Checksum: 0x32E815E4
	Offset: 0x2328
	Size: 0x1F2
	Parameters: 1
	Flags: Linked
*/
function function_86d9efb0(e_player)
{
	level.var_583e4a97.var_caa5bc3e = self.powerup_name;
	foreach(player in level.activeplayers)
	{
		switch(self.powerup_name)
		{
			case "code_cylinder_red":
			{
				var_130c4ab2 = 1;
				var_5f982950 = "drop_pod_terminal_factory";
				break;
			}
			case "code_cylinder_blue":
			{
				var_130c4ab2 = 2;
				var_5f982950 = "drop_pod_terminal_judicial";
				break;
			}
			case "code_cylinder_yellow":
			{
				var_130c4ab2 = 3;
				var_5f982950 = "drop_pod_terminal_library";
				break;
			}
		}
		player clientfield::set_player_uimodel("zmInventory.piece_cylinder", var_130c4ab2);
		player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.piece_cylinder", "zmInventory.widget_cylinder", 0);
		var_cc373138 = getent(var_5f982950, "targetname");
		var_cc373138 showpart("tag_screen_main_green");
		var_cc373138 hidepart("tag_screen_main_red");
		player function_8df46779(1, self.powerup_name);
	}
}

/*
	Name: function_1389d425
	Namespace: namespace_2e6e7fce
	Checksum: 0x683DE903
	Offset: 0x2528
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_1389d425(e_attacker)
{
	if(isdefined(self.var_4d11bb60) && self.var_4d11bb60 || isdefined(level.var_583e4a97.var_caa5bc3e) || level flag::get("drop_pod_spawned") || level flag::get("drop_pod_active") || (isdefined(self.no_powerups) && self.no_powerups))
	{
		return false;
	}
	self thread function_aa168b7a();
}

/*
	Name: function_aa168b7a
	Namespace: namespace_2e6e7fce
	Checksum: 0x3F521D02
	Offset: 0x25D8
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function function_aa168b7a()
{
	var_f31bd832 = level.powerup_drop_count;
	var_f1c825f6 = self.origin;
	var_988bbfc2 = isdefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area;
	wait(0.5);
	if(var_f31bd832 != level.powerup_drop_count || level.var_583e4a97.var_a622ee25)
	{
		return false;
	}
	n_rate = level.var_583e4a97.var_a43689b5;
	n_roll = randomint(100);
	if(n_roll <= n_rate && var_988bbfc2)
	{
		var_10fdad27 = function_a9d4f2ec();
		s_powerup = zm_powerups::specific_powerup_drop("code_cylinder_" + var_10fdad27, var_f1c825f6);
		level.var_583e4a97.var_a622ee25 = 1;
		level.var_583e4a97.var_a43689b5 = 10;
		s_powerup thread function_9411a0ff();
	}
	else
	{
		level.var_583e4a97.var_a43689b5 = level.var_583e4a97.var_a43689b5 + 2;
	}
}

/*
	Name: function_a9d4f2ec
	Namespace: namespace_2e6e7fce
	Checksum: 0xF4F885D9
	Offset: 0x2768
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_a9d4f2ec()
{
	if(level flag::get("dragonride_crafted"))
	{
		var_446e72fb = randomint(2);
		switch(var_446e72fb)
		{
			case 1:
			{
				return "blue";
			}
			case 2:
			{
				return "yellow";
			}
			case 0:
			{
				return "red";
			}
		}
	}
	else
	{
		return level.var_583e4a97.var_4bf647dc;
	}
}

/*
	Name: function_9411a0ff
	Namespace: namespace_2e6e7fce
	Checksum: 0x56818ED7
	Offset: 0x2810
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function function_9411a0ff()
{
	self util::waittill_any("powerup_timedout", "death", "powerup_grabbed", "powerup_reset");
	level.var_583e4a97.var_a622ee25 = 0;
}

/*
	Name: function_d1a91c4f
	Namespace: namespace_2e6e7fce
	Checksum: 0x9F67BFA8
	Offset: 0x2868
	Size: 0x804
	Parameters: 1
	Flags: Linked
*/
function function_d1a91c4f(var_e7a36389)
{
	var_b0a4c740 = 50;
	a_players = getplayers();
	if(a_players.size == 1)
	{
		var_b0a4c740 = 65;
	}
	level.var_8cc024f2.var_b454101b.health = var_b0a4c740 * 45;
	level.var_8cc024f2.n_health_max = level.var_8cc024f2.var_b454101b.health;
	str_location = (var_e7a36389.script_string + "") + var_e7a36389.script_int;
	if(isdefined(level.var_8cc024f2.var_c5718719) && level.var_8cc024f2.var_c5718719)
	{
		level.var_3947d49c = 25 + (5 * zm_utility::get_number_of_valid_players());
		/#
			if(isdefined(level.var_f9c3fe97) && level.var_f9c3fe97)
			{
				level.var_3947d49c = 1;
			}
		#/
	}
	else
	{
		level.var_3947d49c = 15;
	}
	level.var_583e4a97.var_f76fd560 = 1;
	var_a57aee42 = var_e7a36389.origin + vectorscale((0, 0, 1), 3000);
	var_d60b6fd1 = var_e7a36389.angles + vectorscale((1, 0, 0), 270);
	level.var_8cc024f2.var_165d49f6 = spawn("script_model", var_a57aee42);
	var_165d49f6 = level.var_8cc024f2.var_165d49f6;
	var_165d49f6 setmodel("p7_fxanim_zm_stal_pack_a_punch_pod_mod");
	var_165d49f6 useanimtree($generic);
	var_165d49f6.angles = var_e7a36389.angles;
	foreach(e_player in level.activeplayers)
	{
		e_player function_7400750d();
	}
	callback::on_connect(&function_7400750d);
	level clientfield::set("drop_pod_streaming", 1);
	level.var_8cc024f2.var_b454101b thread function_e677d12();
	level scene::play("drop_pod_landing_" + str_location, "targetname", var_165d49f6);
	var_165d49f6 setmodel("p7_fxanim_zm_stal_pack_a_punch_base_mod");
	var_165d49f6 disconnectpaths();
	var_165d49f6 clientfield::set("drop_pod_hp_light", 1);
	level.var_8cc024f2.var_2d41c802 = spawn("script_model", var_e7a36389.origin);
	var_2d41c802 = level.var_8cc024f2.var_2d41c802;
	var_2d41c802 setmodel("p7_fxanim_zm_stal_pack_a_punch_umbrella_mod");
	var_2d41c802 thread scene::play("p7_fxanim_zm_stal_pack_a_punch_dp_spin_loop_bundle", var_2d41c802);
	foreach(player in level.activeplayers)
	{
		player playrumbleonentity("zm_stalingrad_drop_pod_landing");
	}
	level.var_8cc024f2 scene::play("p7_fxanim_zm_stal_pack_a_punch_dp_meter_10_bundle", var_165d49f6);
	level fx::play("drop_pod_marker", level.var_8cc024f2.origin, var_d60b6fd1, "drop_pod_boom");
	n_obj_id = gameobjects::get_next_obj_id();
	objective_add(n_obj_id, "current", level.var_8cc024f2.var_165d49f6, istring("zm_dlc3_objective"));
	objective_setvisibletoall(n_obj_id);
	var_e7a36389 thread function_943a35e3();
	level.var_8cc024f2.var_b454101b zm_attackables::activate();
	attackable = level.var_8cc024f2.var_b454101b;
	if(!(isdefined(level.var_c3de02e0) && level.var_c3de02e0))
	{
		if(isdefined(attackable.script_string) && attackable.script_string == "yellow1")
		{
			bad_pos = (742, 2900, 160);
			foreach(slot in attackable.slot)
			{
				var_1dd2d452 = distance2dsquared(slot.origin, bad_pos);
				if(var_1dd2d452 < 64)
				{
					slot.origin = (739, 2888, 164);
					level.var_c3de02e0 = 1;
				}
			}
		}
	}
	level flag::set("ambient_mortar_fire_on");
	level flag::set("drop_pod_spawned");
	level thread function_306f40e1(str_location);
	level thread function_ba5071c4();
	zm_spawner::register_zombie_death_event_callback(&function_737e2ef4);
}

/*
	Name: function_7400750d
	Namespace: namespace_2e6e7fce
	Checksum: 0xC4C00A38
	Offset: 0x3078
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_7400750d()
{
	if(isdefined(level.var_8cc024f2) && isdefined(level.var_8cc024f2.var_165d49f6))
	{
		level.var_8cc024f2.var_165d49f6 clientfield::set("drop_pod_active", 1);
	}
}

/*
	Name: function_943a35e3
	Namespace: namespace_2e6e7fce
	Checksum: 0x33950FDE
	Offset: 0x30D8
	Size: 0x76
	Parameters: 0
	Flags: Linked
*/
function function_943a35e3()
{
	self fx::play("drop_pod_smoke", self.origin + vectorscale((0, 0, 1), 24), self.angles + vectorscale((0, 1, 0), 180), "drop_pod_smoke_kill");
	level waittill(#"hash_5ddea7af");
	self notify(#"drop_pod_smoke_kill");
}

/*
	Name: function_5cf8b853
	Namespace: namespace_2e6e7fce
	Checksum: 0x78648993
	Offset: 0x3158
	Size: 0x326
	Parameters: 1
	Flags: Linked
*/
function function_5cf8b853(str_location)
{
	var_8da17f38 = 0;
	if(isdefined(level.var_8cc024f2.var_c5718719) && level.var_8cc024f2.var_c5718719)
	{
		switch(str_location)
		{
			case "ee_factory1":
			case "ee_factory2":
			{
				var_8da17f38 = 15;
				break;
			}
			case "ee_library1":
			case "ee_library2":
			{
				var_8da17f38 = 20;
				break;
			}
			case "ee_command1":
			case "ee_command2":
			{
				var_8da17f38 = 2;
				break;
			}
		}
	}
	else
	{
		var_a2a7678a = level.var_583e4a97.s_radio.script_string;
		switch(var_a2a7678a)
		{
			case "judicial":
			{
				if(str_location == "factory1" || str_location == "library1" || str_location == "alley1")
				{
					var_8da17f38 = 5;
				}
				else
				{
					if(str_location == "factory2" || str_location == "library2" || str_location == "department_store1")
					{
						var_8da17f38 = 8;
					}
					else if(str_location == "fountain1")
					{
						var_8da17f38 = 10;
					}
				}
				break;
			}
			case "factory":
			{
				if(str_location == "judicial1" || str_location == "judicial2" || str_location == "alley1" || str_location == "yellow1")
				{
					var_8da17f38 = 5;
				}
				else
				{
					if(str_location == "judicial3" || str_location == "department_store1" || str_location == "library1")
					{
						var_8da17f38 = 8;
					}
					else if(str_location == "fountain1" || str_location == "library2")
					{
						var_8da17f38 = 10;
					}
				}
				break;
			}
			case "library":
			{
				if(str_location == "judicial1" || str_location == "judicial2" || str_location == "alley1" || str_location == "red1")
				{
					var_8da17f38 = 5;
				}
				else
				{
					if(str_location == "judicial3" || str_location == "department_store1" || str_location == "factory1")
					{
						var_8da17f38 = 8;
					}
					else if(str_location == "fountain1" || str_location == "factory2")
					{
						var_8da17f38 = 10;
					}
				}
				break;
			}
		}
	}
	return var_8da17f38;
}

/*
	Name: function_306f40e1
	Namespace: namespace_2e6e7fce
	Checksum: 0xA151CE3F
	Offset: 0x3488
	Size: 0x2D0
	Parameters: 1
	Flags: Linked
*/
function function_306f40e1(str_location)
{
	level endon(#"hash_94bb84a1");
	if(isdefined(level.var_8cc024f2.var_c5718719) && level.var_8cc024f2.var_c5718719)
	{
		var_a42f2fa9 = 2 + (4 * zm_utility::get_number_of_valid_players());
	}
	else
	{
		var_a42f2fa9 = 3 + (1 * zm_utility::get_number_of_valid_players());
	}
	var_14799ce0 = array::random(level.zombie_spawners);
	var_d41655e8 = struct::get_array("drop_pod_harraser_" + str_location, "targetname");
	if(isdefined(level.var_583e4a97.s_radio) || (isdefined(level.var_8cc024f2.var_c5718719) && level.var_8cc024f2.var_c5718719))
	{
		var_8da17f38 = function_5cf8b853(str_location);
		wait(var_8da17f38);
	}
	level.var_8cc024f2.n_round_zombies = (zombie_utility::get_current_zombie_count() + level.zombie_total) + level.zombie_respawns;
	while(true)
	{
		if(level.var_8cc024f2.var_d2e1ce53 < var_a42f2fa9)
		{
			if(isdefined(level.var_8cc024f2.var_c5718719) && level.var_8cc024f2.var_c5718719)
			{
				level flag::wait_till("spawn_ee_harassers");
			}
			else
			{
				level flag::wait_till("spawn_zombies");
			}
			s_spawn = array::random(var_d41655e8);
			ai = zombie_utility::spawn_zombie(var_14799ce0, "drop_pod_harraser", s_spawn);
			if(isdefined(ai))
			{
				level.zombie_total--;
				if(level.zombie_respawns > 0)
				{
					level.zombie_respawns--;
				}
				level.var_8cc024f2.var_d2e1ce53++;
				ai thread function_51837de8();
			}
		}
		wait(0.3);
	}
}

/*
	Name: function_51837de8
	Namespace: namespace_2e6e7fce
	Checksum: 0x8C35013B
	Offset: 0x3760
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_51837de8()
{
	level endon(#"hash_94bb84a1");
	self.var_a779ca57 = 1;
	self setphysparams(15, 0, 72);
	if(isdefined(level.var_8cc024f2.var_c5718719) && level.var_8cc024f2.var_c5718719)
	{
		self.b_ignore_cleanup = 1;
		self.var_9d6ece1a = 1;
	}
	util::wait_network_frame();
	if(self.zombie_move_speed === "walk" || self.zombie_move_speed === "run")
	{
		self zombie_utility::set_zombie_run_cycle("sprint");
	}
	self.nocrawler = 1;
	self thread function_bb390883();
}

/*
	Name: function_bb390883
	Namespace: namespace_2e6e7fce
	Checksum: 0xEC8AC1C5
	Offset: 0x3860
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_bb390883()
{
	level endon(#"hash_94bb84a1");
	self waittill(#"death");
	if(level flag::get("between_rounds"))
	{
		level.var_583e4a97.var_cac771d3++;
	}
	level.var_8cc024f2.var_d2e1ce53 = level.var_8cc024f2.var_d2e1ce53 - 1;
}

/*
	Name: function_a3d6f85c
	Namespace: namespace_2e6e7fce
	Checksum: 0xF210CB6E
	Offset: 0x38E0
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function function_a3d6f85c()
{
	level waittill(#"zombie_total_set");
	if(level.var_583e4a97.var_cac771d3 > 0)
	{
		level.zombie_total = level.zombie_total - level.var_583e4a97.var_cac771d3;
	}
}

/*
	Name: function_e677d12
	Namespace: namespace_2e6e7fce
	Checksum: 0xEAEF4F7F
	Offset: 0x3930
	Size: 0x4E0
	Parameters: 0
	Flags: Linked
*/
function function_e677d12()
{
	level endon(#"hash_94bb84a1");
	var_165d49f6 = level.var_8cc024f2.var_165d49f6;
	var_165d49f6 thread function_cdc52f02();
	var_165d49f6.var_94093c25 = 0;
	var_165d49f6.var_16f934b6 = 0;
	var_165d49f6.var_2b44423b = "green";
	var_3d2bc4d9 = 0.66;
	var_1ee0bdfc = 0.33;
	var_165d49f6 showpart("tag_health_green");
	var_165d49f6 hidepart("tag_health_yellow");
	var_165d49f6 hidepart("tag_health_red");
	var_603f1f19 = 1;
	while(true)
	{
		self waittill(#"attackable_damaged");
		if(var_603f1f19)
		{
			var_603f1f19 = 0;
			if(!var_165d49f6 zm_stalingrad_util::function_1af75b1b(600))
			{
				level thread zm_stalingrad_vo::function_90ce0342();
			}
		}
		var_165d49f6 playsound("zmb_pod_zombie_melee_hit");
		n_health_percent = self.health / level.var_8cc024f2.n_health_max;
		if(n_health_percent >= var_3d2bc4d9)
		{
			var_165d49f6 showpart("tag_health_green");
			var_165d49f6 hidepart("tag_health_yellow");
			var_165d49f6 hidepart("tag_health_red");
		}
		else
		{
			if(n_health_percent < var_3d2bc4d9 && n_health_percent >= var_1ee0bdfc)
			{
				if(var_165d49f6.var_2b44423b != "yellow")
				{
					var_165d49f6.var_2b44423b = "yellow";
					var_165d49f6 clientfield::set("drop_pod_hp_light", 2);
				}
				var_165d49f6 hidepart("tag_health_green");
				var_165d49f6 showpart("tag_health_yellow");
				var_165d49f6 hidepart("tag_health_red");
				var_165d49f6.var_2d5af28c = 1;
				if(!(isdefined(var_165d49f6.var_94093c25) && var_165d49f6.var_94093c25))
				{
					var_165d49f6 playsound("zmb_pod_alarm_health_change");
					var_165d49f6.var_94093c25 = 1;
				}
			}
			else if(n_health_percent < var_1ee0bdfc)
			{
				if(var_165d49f6.var_2b44423b != "red")
				{
					var_165d49f6.var_2b44423b = "red";
					var_165d49f6 clientfield::set("drop_pod_hp_light", 3);
				}
				var_165d49f6 hidepart("tag_health_green");
				var_165d49f6 hidepart("tag_health_yellow");
				var_165d49f6 showpart("tag_health_red");
				var_165d49f6 notify(#"start_flashing");
				var_165d49f6.var_2d5af28c = 1;
				if(!(isdefined(var_165d49f6.var_16f934b6) && var_165d49f6.var_16f934b6))
				{
					var_165d49f6 playsound("zmb_pod_alarm_health_critical");
					var_165d49f6.var_16f934b6 = 1;
				}
			}
		}
		if(self.health <= 0)
		{
			var_165d49f6 notify(#"hash_b9ff0fe2");
			var_51d4ce0d = 1;
			level thread function_94bb84a1(level.var_8cc024f2, var_51d4ce0d);
		}
	}
}

/*
	Name: function_cdc52f02
	Namespace: namespace_2e6e7fce
	Checksum: 0xDB0F0223
	Offset: 0x3E18
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function function_cdc52f02()
{
	level endon(#"hash_94bb84a1");
	self waittill(#"start_flashing");
	var_b454101b = level.var_8cc024f2.var_b454101b;
	var_e975a0cb = 0;
	self thread function_1ce76e16();
	while(true)
	{
		n_health_percent = var_b454101b.health / level.var_8cc024f2.n_health_max;
		if(n_health_percent > 0.15)
		{
			wait(0.5);
		}
		else
		{
			if(var_e975a0cb)
			{
				self hidepart("tag_health_green");
				self hidepart("tag_health_yellow");
				self showpart("tag_health_red");
				var_e975a0cb = 0;
			}
			else
			{
				self hidepart("tag_health_green");
				self hidepart("tag_health_yellow");
				self hidepart("tag_health_red");
				var_e975a0cb = 1;
			}
			if(n_health_percent < 0.06)
			{
				wait(0.1);
			}
			else
			{
				if(n_health_percent < 0.1)
				{
					wait(0.25);
				}
				else
				{
					wait(0.5);
				}
			}
		}
	}
}

/*
	Name: function_1ce76e16
	Namespace: namespace_2e6e7fce
	Checksum: 0xA5CD5F9A
	Offset: 0x3FF0
	Size: 0x3E
	Parameters: 0
	Flags: Linked
*/
function function_1ce76e16()
{
	level endon(#"hash_94bb84a1");
	while(isdefined(self))
	{
		self playsound("zmb_pod_alarm_health_repeating");
		wait(1);
	}
}

/*
	Name: function_94bb84a1
	Namespace: namespace_2e6e7fce
	Checksum: 0x7C2E79AD
	Offset: 0x4038
	Size: 0x76C
	Parameters: 2
	Flags: Linked
*/
function function_94bb84a1(var_e7a36389, var_51d4ce0d)
{
	level notify(#"hash_94bb84a1");
	level flag::clear("drop_pod_active");
	level flag::clear("advance_drop_pod_round");
	zm_spawner::deregister_zombie_death_event_callback(&function_737e2ef4);
	level.var_8cc024f2.var_b454101b zm_attackables::deactivate();
	if(!var_51d4ce0d)
	{
		/#
			iprintlnbold("");
			if(level.var_583e4a97.var_365bcb3c >= 3 && !level flag::get(""))
			{
				iprintlnbold("");
			}
		#/
		var_165d49f6 = level.var_8cc024f2.var_165d49f6;
		var_2d41c802 = level.var_8cc024f2.var_2d41c802;
		var_2d41c802 scene::play("p7_fxanim_zm_stal_pack_a_punch_dp_spin_end_bundle", var_2d41c802);
		var_e7a36389 thread function_78a4f940();
		var_165d49f6 stoprumble("zm_stalingrad_drop_pod_ambient");
		wait(2);
		var_165d49f6 thread scene::play("p7_fxanim_zm_stal_pack_a_punch_dp_hatch_bundle", var_165d49f6);
		if(isdefined(var_e7a36389.var_c5718719) && var_e7a36389.var_c5718719)
		{
			var_fb6d6762 = var_e7a36389.origin + vectorscale((0, 0, 1), 32);
			level thread zm_stalingrad_ee_main::function_7e6865e3(var_fb6d6762);
		}
		else
		{
			if(level.var_583e4a97.var_365bcb3c < 3)
			{
				str_part = zm_stalingrad_pap::function_d32eac7f();
				mdl_part = level zm_craftables::get_craftable_piece_model("dragonride", str_part);
				mdl_part.origin = var_e7a36389.origin + vectorscale((0, 0, 1), 32);
				mdl_part setvisibletoall();
				mdl_part thread fx::play("drop_pod_reward_glow", mdl_part.origin, undefined, (("dragonride" + "_") + str_part) + "_found", 1);
				mdl_part thread zm_stalingrad_util::function_3fbe7d5f();
				level.var_583e4a97.var_19c5f310 = mdl_part;
			}
			else
			{
				str_powerup = zm_powerups::get_regular_random_powerup_name();
				var_93eb638b = zm_powerups::specific_powerup_drop(str_powerup, var_165d49f6.origin - vectorscale((0, 0, 1), 8));
				var_93eb638b setscale(0.5);
				var_93eb638b thread function_8f66c62a();
			}
			foreach(player in level.activeplayers)
			{
				player zm_score::add_to_player_score(500, 1);
				if(!(isdefined(var_165d49f6.var_2d5af28c) && var_165d49f6.var_2d5af28c))
				{
					player notify(#"hash_2d087eca");
				}
			}
			level thread zm_stalingrad_vo::function_73928e79(var_e7a36389.origin);
			level function_503cfe0f(var_e7a36389);
		}
	}
	else
	{
		level thread zm_stalingrad_vo::function_2b34512a(level.var_8cc024f2.var_165d49f6.origin);
		if(isdefined(var_e7a36389.var_c5718719) && var_e7a36389.var_c5718719)
		{
			var_e7a36389 thread function_78a4f940();
			level notify(#"ee_defend_failed");
		}
		else
		{
			var_e7a36389 thread function_4843856e();
		}
	}
	t_explosion = spawn("trigger_radius", level.var_8cc024f2.origin, 0, 115, 115);
	t_explosion function_3653ea22(var_51d4ce0d, var_e7a36389);
	level.var_7d59e517 = level.var_8cc024f2;
	level.var_8cc024f2.n_current_progress = 0;
	level.var_8cc024f2.var_d2e1ce53 = 0;
	level.var_583e4a97.var_caa5bc3e = undefined;
	level.var_583e4a97.var_a622ee25 = 0;
	level notify(#"drop_pod_boom");
	level.var_8cc024f2.var_165d49f6 notify(#"score_change");
	level.var_8cc024f2.var_165d49f6 connectpaths();
	level.var_8cc024f2.var_165d49f6 delete();
	level.var_8cc024f2.var_2d41c802 delete();
	level notify((("pod_" + var_e7a36389.script_string) + var_e7a36389.script_int) + "_lower");
	util::wait_network_frame();
	level.var_8cc024f2 = undefined;
	level notify(#"hash_5ddea7af");
	level clientfield::set("drop_pod_streaming", 0);
	level flag::clear("drop_pod_spawned");
}

/*
	Name: function_3653ea22
	Namespace: namespace_2e6e7fce
	Checksum: 0x3733D93
	Offset: 0x47B0
	Size: 0x3CC
	Parameters: 2
	Flags: Linked
*/
function function_3653ea22(var_51d4ce0d, var_e7a36389)
{
	if(!var_51d4ce0d)
	{
		if(isdefined(var_e7a36389.var_c5718719) && var_e7a36389.var_c5718719)
		{
			str_result = level util::waittill_any_return("ee_defend_failed", "ee_cargo_retrieved");
			if(str_result == "ee_cargo_retrieved")
			{
				wait(1.5);
			}
		}
		else
		{
			level waittill(#"hash_8d3f0071");
			wait(3);
			if(isdefined(level.var_583e4a97.var_19c5f310))
			{
				level.var_583e4a97.var_19c5f310.origin = vectorscale((0, 0, -1), 273);
				level.var_583e4a97.var_19c5f310 = undefined;
			}
		}
	}
	var_4ee51f42 = self array::get_touching(getaiteamarray("axis"));
	a_e_players = self array::get_touching(level.activeplayers);
	var_e7a36389 thread fx::play("drop_pod_go_boom", var_e7a36389.origin);
	playrumbleonposition("zm_stalingrad_drop_pod_explosion", var_e7a36389.origin);
	playsoundatposition("zmb_pod_explode", var_e7a36389.origin);
	for(i = 0; i < var_4ee51f42.size; i++)
	{
		if(isdefined(var_4ee51f42[i]))
		{
			var_4ee51f42[i] dodamage(var_4ee51f42[i].health, self.origin);
			if(i < 3)
			{
				n_random_x = randomfloatrange(-3, 3);
				n_random_y = randomfloatrange(-3, 3);
				var_4ee51f42[i] startragdoll(1);
				var_4ee51f42[i] launchragdoll(300 * (vectornormalize((var_4ee51f42[i].origin - var_e7a36389.origin) + (n_random_x, n_random_y, 30))), "torso_lower");
			}
		}
	}
	foreach(e_target in a_e_players)
	{
		if(isdefined(e_target))
		{
			e_target dodamage(15, self.origin);
		}
	}
	self delete();
}

/*
	Name: function_8f66c62a
	Namespace: namespace_2e6e7fce
	Checksum: 0x60CF9054
	Offset: 0x4B88
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function function_8f66c62a()
{
	while(isdefined(self))
	{
		wait(1);
	}
	level notify(#"hash_8d3f0071");
}

/*
	Name: function_78a4f940
	Namespace: namespace_2e6e7fce
	Checksum: 0x153F0DDE
	Offset: 0x4BB8
	Size: 0x3EC
	Parameters: 0
	Flags: Linked
*/
function function_78a4f940()
{
	var_5f1a4e03 = "countermeasures_spawns";
	level thread zm_stalingrad_util::function_3804dbf1(1, var_5f1a4e03);
	level flag::clear("spawn_ee_harassers");
	wait(0.5);
	a_ai_enemy = getaiteamarray("axis");
	var_31c9e19 = level.players[0].team;
	foreach(zombie in a_ai_enemy)
	{
		if(isdefined(zombie.marked_for_death) && zombie.marked_for_death)
		{
			continue;
		}
		zombie.marked_for_death = 1;
		zombie clientfield::increment("zm_nuked");
		if(!(isdefined(zombie.exclude_cleanup_adding_to_total) && zombie.exclude_cleanup_adding_to_total))
		{
			level.zombie_total++;
			if(zombie.health < zombie.maxhealth)
			{
				if(!isdefined(level.a_zombie_respawn_health[zombie.archetype]))
				{
					level.a_zombie_respawn_health[zombie.archetype] = [];
				}
				if(!isdefined(level.a_zombie_respawn_health[zombie.archetype]))
				{
					level.a_zombie_respawn_health[zombie.archetype] = [];
				}
				else if(!isarray(level.a_zombie_respawn_health[zombie.archetype]))
				{
					level.a_zombie_respawn_health[zombie.archetype] = array(level.a_zombie_respawn_health[zombie.archetype]);
				}
				level.a_zombie_respawn_health[zombie.archetype][level.a_zombie_respawn_health[zombie.archetype].size] = zombie.health;
			}
		}
	}
	foreach(zombie in a_ai_enemy)
	{
		wait(randomfloatrange(0.1, 0.3));
		if(!isdefined(zombie))
		{
			break;
		}
		zombie zombie_utility::reset_attack_spot();
		zombie.var_4d11bb60 = 1;
		zombie kill();
	}
	level thread zm_stalingrad_util::function_3804dbf1(0, var_5f1a4e03);
	level flag::set("spawn_ee_harassers");
}

/*
	Name: function_503cfe0f
	Namespace: namespace_2e6e7fce
	Checksum: 0xFEB9C708
	Offset: 0x4FB0
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function function_503cfe0f(var_e7a36389)
{
	str_location = (var_e7a36389.script_string + "") + var_e7a36389.script_int;
	if(str_location == "judicial1" || str_location == "judicial2")
	{
		level.var_583e4a97.var_5d8406ed["judicial1"].b_available = 0;
		level.var_583e4a97.var_5d8406ed["judicial2"].b_available = 0;
	}
	else
	{
		level.var_583e4a97.var_5d8406ed[str_location].b_available = 0;
	}
}

/*
	Name: function_4843856e
	Namespace: namespace_2e6e7fce
	Checksum: 0x4B9BD386
	Offset: 0x5098
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_4843856e()
{
	str_location = (self.script_string + "") + self.script_int;
	level.var_583e4a97.var_5d8406ed[str_location].b_available = 0;
	wait(120);
	level.var_583e4a97.var_5d8406ed[str_location].b_available = 1;
}

/*
	Name: function_ba5071c4
	Namespace: namespace_2e6e7fce
	Checksum: 0x94ABB760
	Offset: 0x5118
	Size: 0x190
	Parameters: 0
	Flags: Linked
*/
function function_ba5071c4()
{
	level endon(#"hash_94bb84a1");
	while(true)
	{
		var_9b6a75aa = 1;
		foreach(e_player in level.players)
		{
			if(!zm_utility::is_player_valid(e_player, 0, 1))
			{
				continue;
			}
			if(isdefined(e_player.zone_name))
			{
				if(e_player.zone_name != "pavlovs_A_zone" && e_player.zone_name != "pavlovs_B_zone" && e_player.zone_name != "pavlovs_C_zone")
				{
					var_9b6a75aa = 0;
					break;
				}
				continue;
			}
			if(!array::contains(level.var_163a43e4, e_player))
			{
				var_9b6a75aa = 0;
				break;
			}
		}
		if(var_9b6a75aa)
		{
			level thread function_94bb84a1(level.var_8cc024f2, 1);
			return;
		}
		wait(1);
	}
}

/*
	Name: function_737e2ef4
	Namespace: namespace_2e6e7fce
	Checksum: 0xD0D1CE43
	Offset: 0x52B0
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function function_737e2ef4()
{
	if(isdefined(self.var_4d11bb60) && self.var_4d11bb60 || self.archetype === "sentinel_drone")
	{
		return;
	}
	var_71588c92 = level.var_8cc024f2.n_round_zombies;
	if(isdefined(var_71588c92))
	{
		level.var_8cc024f2.n_round_zombies--;
		if(level.var_8cc024f2.n_round_zombies == 0)
		{
			level flag::set("advance_drop_pod_round");
		}
	}
	e_pod = level.var_8cc024f2.var_165d49f6;
	e_goal = level.var_8cc024f2.e_goal_volume;
	if(self istouching(e_goal))
	{
		self clientfield::increment("drop_pod_score_beam_fx", 1);
		level.var_8cc024f2.n_current_progress++;
		level function_53482422();
		/#
			println((("" + level.var_8cc024f2.n_current_progress) + "") + level.var_3947d49c);
		#/
		if(level.var_8cc024f2.n_current_progress >= level.var_3947d49c && level.var_583e4a97.var_f76fd560)
		{
			level.var_583e4a97.var_f76fd560 = 0;
			var_5af77991 = 0;
			level thread function_94bb84a1(level.var_8cc024f2, var_5af77991);
		}
	}
}

/*
	Name: function_53482422
	Namespace: namespace_2e6e7fce
	Checksum: 0xA987DA08
	Offset: 0x54A0
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_53482422()
{
	level endon(#"hash_94bb84a1");
	var_165d49f6 = level.var_8cc024f2.var_165d49f6;
	var_1e808310 = level.var_8cc024f2.n_current_progress / level.var_3947d49c;
	n_score = int(var_1e808310 * 100);
	var_545b3160 = zm_utility::round_up_to_ten(n_score);
	if(var_545b3160 <= 100)
	{
		level.var_8cc024f2 scene::play(("p7_fxanim_zm_stal_pack_a_punch_dp_meter_" + var_545b3160) + "_bundle", var_165d49f6);
	}
}

/*
	Name: function_a0a37968
	Namespace: namespace_2e6e7fce
	Checksum: 0xD34D22C5
	Offset: 0x5580
	Size: 0xDE
	Parameters: 1
	Flags: None
*/
function function_a0a37968(var_db0ac3dc)
{
	var_8aa74c19 = [];
	foreach(s_location in level.var_583e4a97.var_5d8406ed)
	{
		if(s_location.script_string != var_db0ac3dc && s_location.b_available == 1)
		{
			array::add(var_8aa74c19, s_location);
		}
	}
	return var_8aa74c19;
}

/*
	Name: function_8df46779
	Namespace: namespace_2e6e7fce
	Checksum: 0xA52ACBE7
	Offset: 0x5668
	Size: 0x270
	Parameters: 2
	Flags: Linked
*/
function function_8df46779(var_304415d7, var_57a3fb53)
{
	self endon(#"disconnect");
	if(!isdefined(self.var_9e067339))
	{
		self.var_9e067339 = newclienthudelem(self);
		self.var_9e067339.location = 0;
		self.var_9e067339.alignx = "center";
		self.var_9e067339.aligny = "bottom";
		self.var_9e067339.x = 0;
		self.var_9e067339.y = 80;
		self.var_9e067339.foreground = 1;
		self.var_9e067339.fontscale = 1.5;
		self.var_9e067339.horzalign = "center";
		self.var_9e067339.vertalign = "center_safearea";
		self.var_9e067339.sort = 20;
		self.var_9e067339.og_scale = 1;
		self.var_9e067339.color = (1, 1, 1);
		self.var_9e067339.alpha = 0;
	}
	switch(var_57a3fb53)
	{
		case "code_cylinder_red":
		{
			self.var_9e067339 settext(&"ZM_STALINGRAD_DROP_POD_CYLINDER_ACQUIRED_RED");
			break;
		}
		case "code_cylinder_yellow":
		{
			self.var_9e067339 settext(&"ZM_STALINGRAD_DROP_POD_CYLINDER_ACQUIRED_YELLOW");
			break;
		}
		case "code_cylinder_blue":
		{
			self.var_9e067339 settext(&"ZM_STALINGRAD_DROP_POD_CYLINDER_ACQUIRED_BLUE");
			break;
		}
		default:
		{
			self.var_9e067339 settext("");
		}
	}
	self.var_9e067339.alpha = 1;
	self.var_9e067339 fadeovertime(5);
	self.var_9e067339.alpha = 0;
}

