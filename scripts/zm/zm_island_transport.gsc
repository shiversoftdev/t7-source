// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_island_main_ee_quest;
#using scripts\zm\zm_island_power;
#using scripts\zm\zm_island_vo;

#namespace zm_island_transport;

/*
	Name: init
	Namespace: zm_island_transport
	Checksum: 0x808D74E2
	Offset: 0x968
	Size: 0x2F4
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level flag::init("flag_zipline_in_use");
	level flag::init("flag_sewer_in_use_interior");
	level flag::init("flag_sewer_active_interior");
	level flag::init("flag_sewer_on_cooldown_interior");
	level flag::init("flag_sewer_in_use_exterior");
	level flag::init("flag_sewer_active_exterior");
	level flag::init("flag_sewer_on_cooldown_exterior");
	level flag::init("zipline_lightning_charge");
	level flag::init("sewer_lightning_charge_interior");
	level flag::init("sewer_lightning_charge_exterior");
	level thread function_14c7a7e("zip_line");
	level thread function_14c7a7e("sewer_interior");
	level thread function_14c7a7e("sewer_exterior");
	level thread function_daa052ec("zip_line", "flag_zipline_in_use", "ex_power_zipline");
	level thread function_daa052ec("sewer_interior", "flag_sewer_on_cooldown_interior", "ex_power_pipe_int");
	level thread function_daa052ec("sewer_exterior", "flag_sewer_on_cooldown_exterior", "ex_power_pipe");
	array::thread_all(struct::get_array("transport_zip_line", "targetname"), &spawn_unitrigger);
	array::thread_all(struct::get_array("transport_sewer_interior", "targetname"), &spawn_unitrigger);
	array::thread_all(struct::get_array("transport_sewer_exterior", "targetname"), &spawn_unitrigger);
}

/*
	Name: spawn_unitrigger
	Namespace: zm_island_transport
	Checksum: 0xB14BC943
	Offset: 0xC68
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function spawn_unitrigger()
{
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = self.origin;
	unitrigger_stub.angles = self.angles;
	unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	unitrigger_stub.radius = 64;
	unitrigger_stub.require_look_at = 0;
	unitrigger_stub.e_parent = self;
	if(self.targetname == "transport_zip_line")
	{
		unitrigger_stub.hint_parm1 = 250;
		unitrigger_stub.prompt_and_visibility_func = &function_1388fe2d;
		zm_unitrigger::register_static_unitrigger(unitrigger_stub, &function_727b0365);
	}
	else
	{
		unitrigger_stub.script_noteworthy = self.script_noteworthy;
		unitrigger_stub.hint_parm1 = 500;
		unitrigger_stub.prompt_and_visibility_func = &function_da8a0706;
		zm_unitrigger::register_static_unitrigger(unitrigger_stub, &function_32c54c4);
	}
}

/*
	Name: function_daa052ec
	Namespace: zm_island_transport
	Checksum: 0x8B88CD7D
	Offset: 0xDE8
	Size: 0x108
	Parameters: 3
	Flags: Linked
*/
function function_daa052ec(str_location, str_flag, str_exploder)
{
	level flag::wait_till("power_on");
	exploder::exploder(str_exploder);
	function_b708e2f9(str_location, 1);
	while(true)
	{
		level flag::wait_till(str_flag);
		exploder::exploder_stop(str_exploder);
		function_b708e2f9(str_location, 0);
		level flag::wait_till_clear(str_flag);
		exploder::exploder(str_exploder);
		function_b708e2f9(str_location, 1);
	}
}

/*
	Name: function_14c7a7e
	Namespace: zm_island_transport
	Checksum: 0xA0734281
	Offset: 0xEF8
	Size: 0xEE
	Parameters: 1
	Flags: Linked
*/
function function_14c7a7e(var_7d3faaf0)
{
	var_fae0d733 = struct::get_array("transport_" + var_7d3faaf0, "targetname");
	foreach(s_loc in var_fae0d733)
	{
		s_loc.var_1cdf0f7a = util::spawn_model("p7_zm_isl_control_panel_cage_off", s_loc.origin, s_loc.angles);
	}
}

/*
	Name: function_b708e2f9
	Namespace: zm_island_transport
	Checksum: 0x8B49E8AD
	Offset: 0xFF0
	Size: 0x122
	Parameters: 2
	Flags: Linked
*/
function function_b708e2f9(var_7d3faaf0, var_7afe5e99 = 1)
{
	var_fae0d733 = struct::get_array("transport_" + var_7d3faaf0, "targetname");
	foreach(s_loc in var_fae0d733)
	{
		if(var_7afe5e99)
		{
			s_loc.var_1cdf0f7a setmodel("p7_zm_isl_control_panel_cage");
			continue;
		}
		s_loc.var_1cdf0f7a setmodel("p7_zm_isl_control_panel_cage_off");
	}
}

/*
	Name: function_727b0365
	Namespace: zm_island_transport
	Checksum: 0xE74C4FC1
	Offset: 0x1120
	Size: 0x160
	Parameters: 0
	Flags: Linked
*/
function function_727b0365()
{
	var_ff0e60dd = arraygetclosest(self.origin, struct::get_array("transport_zip_line", "targetname"));
	while(true)
	{
		self waittill(#"trigger", e_who);
		if(!level flag::get("flag_zipline_in_use"))
		{
			if(level flag::get("zipline_lightning_charge"))
			{
				n_cost = int(125);
			}
			else
			{
				n_cost = 250;
			}
			if(!e_who zm_score::can_player_purchase(n_cost))
			{
				e_who zm_audio::create_and_play_dialog("general", "outofmoney");
			}
			else
			{
				e_who zm_score::minus_to_player_score(n_cost);
				self thread function_7fdc1c82(e_who, var_ff0e60dd);
			}
		}
	}
}

/*
	Name: function_7fdc1c82
	Namespace: zm_island_transport
	Checksum: 0xF0E9AC9B
	Offset: 0x1288
	Size: 0xE4
	Parameters: 2
	Flags: Linked
*/
function function_7fdc1c82(e_who, var_ff0e60dd)
{
	level flag::set("flag_zipline_in_use");
	if(!level flag::get("connect_cliffside_to_jungle_lab_upper"))
	{
		level flag::set("connect_cliffside_to_jungle_lab_upper");
	}
	e_who thread function_8fda04e6(var_ff0e60dd, 0);
	e_who thread player_rail_sequence_init(var_ff0e60dd, 0);
	e_who waittill(#"hash_329f91e1");
	wait(3);
	level flag::clear("flag_zipline_in_use");
}

/*
	Name: function_1388fe2d
	Namespace: zm_island_transport
	Checksum: 0x373C0242
	Offset: 0x1378
	Size: 0x138
	Parameters: 1
	Flags: Linked
*/
function function_1388fe2d(player)
{
	if(!level flag::get("power_on"))
	{
		self sethintstring(&"ZM_ISLAND_MAIN_POWER_OFF");
		return false;
	}
	if(level flag::get("flag_zipline_in_use"))
	{
		self sethintstring(&"ZM_ISLAND_ZIPLINE_IN_USE");
		return false;
	}
	if(level flag::get("zipline_lightning_charge"))
	{
		self sethintstring(&"ZM_ISLAND_BUY_ZIPLINE", int(self.stub.hint_parm1 * 0.5));
	}
	else
	{
		self sethintstring(&"ZM_ISLAND_BUY_ZIPLINE", self.stub.hint_parm1);
	}
	return true;
}

/*
	Name: function_32c54c4
	Namespace: zm_island_transport
	Checksum: 0x49BDFCDD
	Offset: 0x14B8
	Size: 0x1E8
	Parameters: 0
	Flags: Linked
*/
function function_32c54c4()
{
	var_f7516332 = self.stub.e_parent;
	while(true)
	{
		self waittill(#"trigger", e_who);
		if(level flag::get("flag_sewer_on_cooldown_" + self.script_noteworthy))
		{
			continue;
		}
		if(!level flag::get("flag_sewer_active_" + self.script_noteworthy))
		{
			if(level flag::get("sewer_lightning_charge_" + self.script_noteworthy))
			{
				n_cost = int(250);
			}
			else
			{
				n_cost = 500;
			}
			if(!e_who zm_score::can_player_purchase(n_cost))
			{
				e_who zm_audio::create_and_play_dialog("general", "outofmoney");
			}
			else
			{
				e_who zm_score::minus_to_player_score(n_cost);
				self thread function_51885f3b(e_who, var_f7516332);
				level thread function_60b7284f(self.stub.e_parent.script_noteworthy);
			}
		}
		else if(!level flag::get("flag_sewer_in_use_" + self.script_noteworthy))
		{
			self thread function_51885f3b(e_who, var_f7516332);
		}
	}
}

/*
	Name: function_60b7284f
	Namespace: zm_island_transport
	Checksum: 0x20D1B64E
	Offset: 0x16A8
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function function_60b7284f(str_location)
{
	level flag::set("flag_sewer_active_" + str_location);
	if(str_location == "interior")
	{
		str_exploder = "fxexp_115";
	}
	else
	{
		str_exploder = "fxexp_114";
	}
	exploder::exploder(str_exploder);
	wait(15);
	level flag::clear("flag_sewer_active_" + str_location);
	exploder::stop_exploder(str_exploder);
	level flag::set("flag_sewer_on_cooldown_" + str_location);
	wait(30);
	level flag::clear("flag_sewer_on_cooldown_" + str_location);
}

/*
	Name: function_51885f3b
	Namespace: zm_island_transport
	Checksum: 0x327B4216
	Offset: 0x17B0
	Size: 0x1AC
	Parameters: 2
	Flags: Linked
*/
function function_51885f3b(e_who, var_f7516332)
{
	level flag::set("flag_sewer_in_use_" + var_f7516332.script_noteworthy);
	if(!level flag::get("connect_meteor_site_to_operating_rooms"))
	{
		level flag::set("connect_meteor_site_to_operating_rooms");
	}
	if(var_f7516332.script_noteworthy === "interior")
	{
		var_5d0d54e9 = struct::get("transport_sewer_exterior");
	}
	else
	{
		var_5d0d54e9 = struct::get("transport_sewer_interior");
	}
	e_who zm_utility::create_streamer_hint(var_5d0d54e9.origin, var_5d0d54e9.angles, 1);
	e_who thread function_8fda04e6(var_f7516332, 1);
	e_who thread player_rail_sequence_init(var_f7516332, 1);
	e_who thread zm_island_power::function_a7a30925();
	level util::delay(3, undefined, &flag::clear, "flag_sewer_in_use_" + var_f7516332.script_noteworthy);
}

/*
	Name: player_rail_sequence_init
	Namespace: zm_island_transport
	Checksum: 0x31ED2612
	Offset: 0x1968
	Size: 0x2E4
	Parameters: 2
	Flags: Linked
*/
function player_rail_sequence_init(s_start, var_b4b1932b)
{
	var_47ee7db6 = getent(s_start.target, "targetname");
	nd_path_start = getvehiclenode(var_47ee7db6.target, "targetname");
	self.var_53539670 = spawner::simple_spawn_single(var_47ee7db6);
	self.var_53539670 setignorepauseworld(1);
	self hideviewmodel();
	self util::magic_bullet_shield();
	self freezecontrols(1);
	self allowsprint(0);
	self allowjump(0);
	self disableweapons();
	if(level flag::get("solo_game") && !var_b4b1932b)
	{
		self.var_5eb06498 = self.origin;
	}
	wait(0.35);
	self setorigin(nd_path_start.origin);
	self setplayerangles(nd_path_start.angles);
	self.var_53539670.origin = self.origin;
	self.var_53539670.angles = self.angles;
	self.var_53539670.e_parent = self;
	self.var_53539670 setacceleration(1000);
	self playerlinktodelta(self.var_53539670, undefined, 1, 20, 20, 15, 60);
	if(var_b4b1932b)
	{
		self thread animation::play("cp_mi_sing_blackstation_water_flail");
	}
	else
	{
		self thread animation::play("pb_zipline_loop_island");
	}
	self.var_53539670 vehicle::get_on_path(nd_path_start);
	self thread player_rail_sequence(var_b4b1932b);
}

/*
	Name: player_rail_sequence
	Namespace: zm_island_transport
	Checksum: 0x5506C0CB
	Offset: 0x1C58
	Size: 0x35C
	Parameters: 1
	Flags: Linked
*/
function player_rail_sequence(var_b4b1932b)
{
	self endon(#"disconnect");
	self endon(#"switch_rail");
	if(var_b4b1932b)
	{
		self.var_53539670 thread play_current_fx();
		self clientfield::set_to_player("tp_water_sheeting", 1);
		level thread zm_island_vo::function_3bf2d62a("sewer", 1, 1, 1);
		self.var_7a36438e = 1;
	}
	else
	{
		self notify(#"zipline_start");
		self clientfield::set_to_player("wind_blur", 1);
		self playsound("evt_zipline_attach");
		self playloopsound("evt_zipline_move", 0.3);
		self.is_ziplining = 1;
		self thread function_f027bda7();
		if(!level flag::get("solo_game"))
		{
			self.no_revive_trigger = 1;
		}
	}
	self showviewmodel();
	self.var_53539670 vehicle::go_path();
	self.var_53539670 notify(#"rail_over");
	if(!var_b4b1932b)
	{
		self stoploopsound(0.4);
	}
	self unlink();
	self animation::stop();
	if(var_b4b1932b)
	{
		self zm_utility::clear_streamer_hint();
		self clientfield::set_to_player("tp_water_sheeting", 0);
		self notify(#"sewer_over");
	}
	else
	{
		self playsound("evt_zipline_detach");
		self clientfield::set_to_player("wind_blur", 0);
		self notify(#"hash_329f91e1");
	}
	self util::stop_magic_bullet_shield();
	self freezecontrols(0);
	self allowsprint(1);
	self allowjump(1);
	self enableweapons();
	wait(2);
	self.var_53539670 delete();
	self.no_revive_trigger = 0;
	if(var_b4b1932b)
	{
		self.var_7a36438e = 0;
	}
	else
	{
		self.is_ziplining = 0;
	}
}

/*
	Name: function_f027bda7
	Namespace: zm_island_transport
	Checksum: 0x3763387A
	Offset: 0x1FC0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_f027bda7()
{
	self endon(#"disconnect");
	self playrumbleonentity("zm_island_rumble_zipline");
	self waittill(#"hash_329f91e1");
	self stoprumble("zm_island_rumble_zipline");
}

/*
	Name: play_current_fx
	Namespace: zm_island_transport
	Checksum: 0x50591279
	Offset: 0x2020
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function play_current_fx()
{
	self clientfield::set("sewer_current_fx", 1);
	self waittill(#"rail_over");
	self clientfield::set("sewer_current_fx", 0);
}

/*
	Name: function_8fda04e6
	Namespace: zm_island_transport
	Checksum: 0x5F8F9963
	Offset: 0x2078
	Size: 0x32C
	Parameters: 2
	Flags: Linked
*/
function function_8fda04e6(s_start, var_b4b1932b)
{
	if(var_b4b1932b)
	{
		if(s_start.script_noteworthy === "exterior")
		{
			var_9c4f4858 = getent("hatch_04", "targetname");
			var_fcf7bffb = getent("hatch_02", "targetname");
			var_99552fbd = getent("sewer_interior_door_open", "targetname");
		}
		else
		{
			var_9c4f4858 = getent("hatch_01", "targetname");
			var_fcf7bffb = getent("hatch_03", "targetname");
			var_99552fbd = getent("sewer_exterior_door_open", "targetname");
		}
		var_f70ad1d7 = "p7_fxanim_zm_island_pipe_hatch_open_bundle";
		var_240b3589 = "p7_fxanim_zm_island_pipe_hatch_close_bundle";
	}
	else
	{
		if(s_start.script_noteworthy === "jungle")
		{
			var_9c4f4858 = getent("zipline_gate_upper", "targetname");
			var_fcf7bffb = getent("zipline_gate_lower", "targetname");
			var_99552fbd = undefined;
		}
		else
		{
			var_9c4f4858 = getent("zipline_gate_lower", "targetname");
			var_fcf7bffb = getent("zipline_gate_upper", "targetname");
			var_99552fbd = undefined;
		}
		var_f70ad1d7 = "p7_fxanim_zm_island_zipline_gate_open_bundle";
		var_240b3589 = "p7_fxanim_zm_island_zipline_gate_close_bundle";
	}
	var_9c4f4858 setignorepauseworld(1);
	var_fcf7bffb setignorepauseworld(1);
	var_9c4f4858 scene::play(var_f70ad1d7, var_9c4f4858);
	wait(0.5);
	var_9c4f4858 scene::play(var_240b3589, var_9c4f4858);
	if(isdefined(var_99552fbd))
	{
		var_99552fbd waittill(#"touch");
	}
	var_fcf7bffb scene::play(var_f70ad1d7, var_fcf7bffb);
	wait(0.5);
	var_fcf7bffb scene::play(var_240b3589, var_fcf7bffb);
}

/*
	Name: function_da8a0706
	Namespace: zm_island_transport
	Checksum: 0x2EF8E149
	Offset: 0x23B0
	Size: 0x1B8
	Parameters: 1
	Flags: Linked
*/
function function_da8a0706(player)
{
	if(!level flag::get("power_on"))
	{
		self sethintstring(&"ZM_ISLAND_MAIN_POWER_OFF");
		return false;
	}
	if(level flag::get("flag_sewer_in_use_" + self.script_noteworthy) || level flag::get("flag_sewer_on_cooldown_" + self.script_noteworthy))
	{
		self sethintstring(&"ZM_ISLAND_SEWER_IN_USE");
		return false;
	}
	if(level flag::get("flag_sewer_active_" + self.script_noteworthy))
	{
		self sethintstring(&"ZM_ISLAND_USE_SEWER");
	}
	else
	{
		if(level flag::get("sewer_lightning_charge_" + self.script_noteworthy))
		{
			self sethintstring(&"ZM_ISLAND_BUY_SEWER", int(self.stub.hint_parm1 * 0.5));
		}
		else
		{
			self sethintstring(&"ZM_ISLAND_BUY_SEWER", self.stub.hint_parm1);
		}
	}
	return true;
}

/*
	Name: function_3c997cb2
	Namespace: zm_island_transport
	Checksum: 0xFF86ADC6
	Offset: 0x2570
	Size: 0x10E
	Parameters: 1
	Flags: Linked
*/
function function_3c997cb2(var_b2c1d9af)
{
	switch(var_b2c1d9af)
	{
		case "sewer":
		{
			level flag::wait_till("connect_meteor_site_to_operating_rooms");
			zm_zonemgr::enable_zone("zone_meteor_site");
			zm_zonemgr::enable_zone("zone_meteor_site_2");
			zm_zonemgr::enable_zone("zone_operating_rooms");
			break;
		}
		case "zip_line":
		{
			level flag::wait_till("connect_cliffside_to_jungle_lab_upper");
			zm_zonemgr::enable_zone("zone_cliffside");
			zm_zonemgr::enable_zone("zone_jungle_lab_upper");
			break;
		}
		default:
		{
			/#
				assertmsg("");
			#/
			break;
		}
	}
}

