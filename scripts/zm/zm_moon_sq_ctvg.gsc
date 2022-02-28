// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_black_hole_bomb;
#using scripts\zm\_zm_weap_quantum_bomb;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_moon_amb;
#using scripts\zm\zm_moon_sq;

#namespace zm_moon_sq_ctvg;

/*
	Name: init
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xF1FD9EF6
	Offset: 0x808
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level flag::init("w_placed");
	level flag::init("vg_placed");
	level flag::init("cvg_picked_up");
	zm_sidequests::declare_sidequest_stage("ctvg", "build", &build_init, &build_stage_logic, &build_exit_stage);
	zm_sidequests::declare_stage_asset_from_struct("ctvg", "build", "sq_cassimir_plates", &plate_thread);
	zm_sidequests::declare_sidequest_stage("ctvg", "charge", &charge_init, &charge_stage_logic, &charge_exit_stage);
}

/*
	Name: plate_thread
	Namespace: zm_moon_sq_ctvg
	Checksum: 0x7C37C02A
	Offset: 0x950
	Size: 0x142
	Parameters: 0
	Flags: Linked
*/
function plate_thread()
{
	level waittill(#"stage_1");
	target = self.target;
	while(isdefined(target))
	{
		struct = struct::get(target, "targetname");
		time = struct.script_float;
		if(!isdefined(time))
		{
			time = 1;
		}
		self moveto(struct.origin, time, time / 10);
		self rotateto(struct.angles, time, time / 10);
		self waittill(#"movedone");
		playsoundatposition("evt_clank", self.origin);
		target = struct.target;
	}
	level notify(#"stage_1_done");
}

/*
	Name: build_init
	Namespace: zm_moon_sq_ctvg
	Checksum: 0x99EC1590
	Offset: 0xAA0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function build_init()
{
}

/*
	Name: plates
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xE48973F3
	Offset: 0xAB0
	Size: 0x47C
	Parameters: 0
	Flags: Linked
*/
function plates()
{
	plates = getentarray("sq_cassimir_plates", "targetname");
	trig = getent("sq_cassimir_trigger", "targetname");
	while(true)
	{
		trig waittill(#"damage", amount, attacker, direction, point, dmg_type, modelname, tagname);
		if(isplayer(attacker) && (dmg_type == "MOD_PROJECTILE" || dmg_type == "MOD_PROJECTILE_SPLASH" || dmg_type == "MOD_EXPLOSIVE" || dmg_type == "MOD_EXPLOSIVE_SPLASH" || dmg_type == "MOD_GRENADE" || dmg_type == "MOD_GRENADE_SPLASH"))
		{
			attacker thread zm_audio::create_and_play_dialog("eggs", "quest5", randomintrange(0, 2));
			break;
		}
	}
	trig delete();
	level notify(#"stage_1");
	level waittill(#"stage_1_done");
	level.teleport_target_trigger = spawn("trigger_radius", plates[0].origin + (vectorscale((0, 0, -1), 70)), 0, 125, 100);
	level.black_hole_bomb_loc_check_func = &bhb_teleport_loc_check;
	level waittill(#"ctvg_tp_done");
	level.black_hole_bomb_loc_check_func = undefined;
	level waittill(#"restart_round");
	targs = struct::get_array("sq_ctvg_tp2", "targetname");
	for(i = 0; i < plates.size; i++)
	{
		plates[i] dontinterpolate();
		plates[i].origin = targs[i].origin;
		plates[i].angles = targs[i].angles;
	}
	zm_weap_quantum_bomb::quantum_bomb_register_result("ctvg", &dud_func, 100, &ctvg_validation);
	level._ctvg_pos = targs[0].origin;
	level waittill(#"ctvg_validation");
	zm_weap_quantum_bomb::quantum_bomb_deregister_result("ctvg");
	players = getplayers();
	players[randomintrange(0, players.size)] thread zm_audio::create_and_play_dialog("eggs", "quest5", randomintrange(4, 6));
	for(i = 0; i < plates.size; i++)
	{
		plates[i] ghost();
	}
	level clientfield::set("charge_vril_init", 1);
	level flag::set("c_built");
}

/*
	Name: wire_qualifier
	Namespace: zm_moon_sq_ctvg
	Checksum: 0x3915D1C0
	Offset: 0xF38
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function wire_qualifier()
{
	if(isdefined(self._has_wire) && self._has_wire)
	{
		return true;
	}
	return false;
}

/*
	Name: monitor_wire_disconnect
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xB38C976C
	Offset: 0xF68
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function monitor_wire_disconnect()
{
	level endon(#"w_placed");
	self waittill(#"disconnect");
	level notify(#"wire_restart");
	level thread wire();
}

/*
	Name: wire
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xFBA95ADA
	Offset: 0xFB0
	Size: 0x324
	Parameters: 0
	Flags: Linked
*/
function wire()
{
	level endon(#"wire_restart");
	wires = struct::get_array("sq_wire_pos", "targetname");
	wires = array::randomize(wires);
	wire_struct = wires[0];
	wire = spawn("script_model", wire_struct.origin);
	if(isdefined(wire_struct.angles))
	{
		wire.angles = wire_struct.angles;
	}
	wire setmodel("p7_zm_moo_computer_rocket_launch_wire");
	wire thread zm_sidequests::fake_use("pickedup_wire");
	wire waittill(#"pickedup_wire", who);
	who thread monitor_wire_disconnect();
	who thread zm_audio::create_and_play_dialog("eggs", "quest5", 7);
	who playsound("evt_grab_wire");
	who._has_wire = 1;
	wire delete();
	who zm_sidequests::add_sidequest_icon("sq", "wire");
	level flag::wait_till("c_built");
	wire_struct = struct::get("sq_wire_final", "targetname");
	wire_struct thread zm_sidequests::fake_use("placed_wire", &wire_qualifier);
	wire_struct waittill(#"placed_wire", who);
	who thread zm_audio::create_and_play_dialog("eggs", "quest5", 8);
	who playsound("evt_casimir_charge");
	who playsound("evt_sq_rbs_light_on");
	who._has_wire = undefined;
	who zm_sidequests::remove_sidequest_icon("sq", "wire");
	level clientfield::set("sq_wire_init", 1);
	level flag::set("w_placed");
}

/*
	Name: dud_func
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xFD192772
	Offset: 0x12E0
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function dud_func(position)
{
}

/*
	Name: vg_qualifier
	Namespace: zm_moon_sq_ctvg
	Checksum: 0x6CC98ECF
	Offset: 0x12F8
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function vg_qualifier()
{
	num = self.characterindex;
	if(isdefined(self.zm_random_char))
	{
		num = self.zm_random_char;
	}
	return num == 2 && level._all_previous_done;
}

/*
	Name: vg
	Namespace: zm_moon_sq_ctvg
	Checksum: 0x8A461E48
	Offset: 0x1348
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function vg()
{
	level flag::wait_till("w_placed");
	level flag::wait_till("power_on");
	vg_struct = struct::get("sq_charge_vg_pos", "targetname");
	vg_struct thread zm_sidequests::fake_use("vg_placed", &vg_qualifier);
	vg_struct waittill(#"vg_placed", who);
	who thread zm_audio::create_and_play_dialog("eggs", "quest5", 9);
	level.vg_struct_sound = spawn("script_origin", vg_struct.origin);
	level.vg_struct_sound playsound("evt_vril_connect");
	level.vg_struct_sound playloopsound("evt_vril_loop_lvl1", 1);
	who zm_sidequests::remove_sidequest_icon("sq", "generator");
	level clientfield::set("vril_generator", 1);
	level flag::set("vg_placed");
}

/*
	Name: build_stage_logic
	Namespace: zm_moon_sq_ctvg
	Checksum: 0x94153A0D
	Offset: 0x1510
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function build_stage_logic()
{
	level thread plates();
	level thread wire();
	level thread vg();
	level flag::wait_till("c_built");
	level flag::wait_till("w_placed");
	level flag::wait_till("vg_placed");
	zm_sidequests::stage_completed("ctvg", "build");
}

/*
	Name: ctvg_validation
	Namespace: zm_moon_sq_ctvg
	Checksum: 0x33F77C24
	Offset: 0x15E8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function ctvg_validation(position)
{
	if(distancesquared(level._ctvg_pos, position) < 16384)
	{
		level notify(#"ctvg_validation");
	}
	return false;
}

/*
	Name: delete_soon
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xA7D75624
	Offset: 0x1638
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function delete_soon()
{
	wait(4.5);
	self delete();
}

/*
	Name: bhb_teleport_loc_check
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xA5459FAB
	Offset: 0x1668
	Size: 0x124
	Parameters: 3
	Flags: Linked
*/
function bhb_teleport_loc_check(grenade, model, info)
{
	if(isdefined(level.teleport_target_trigger) && grenade istouching(level.teleport_target_trigger))
	{
		plates = getentarray("sq_cassimir_plates", "targetname");
		spot = spawn("script_model", plates[0].origin);
		spot setmodel("tag_origin");
		spot clientfield::set("toggle_black_hole_deployed", 1);
		spot thread delete_soon();
		level thread teleport_target(grenade, plates);
		return true;
	}
	return false;
}

/*
	Name: teleport_target
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xE53B8111
	Offset: 0x1798
	Size: 0x302
	Parameters: 2
	Flags: Linked
*/
function teleport_target(grenade, models)
{
	level.teleport_target_trigger delete();
	level.teleport_target_trigger = undefined;
	wait(1);
	time = 3;
	for(i = 0; i < models.size; i++)
	{
		models[i] moveto(grenade.origin + vectorscale((0, 0, 1), 50), time, time - 0.05);
	}
	wait(time);
	teleport_targets = struct::get_array("sq_ctvg_tp", "targetname");
	for(i = 0; i < models.size; i++)
	{
		models[i] ghost();
	}
	playsoundatposition("zmb_gersh_teleporter_out", grenade.origin + vectorscale((0, 0, 1), 50));
	wait(0.5);
	for(i = 0; i < models.size; i++)
	{
		models[i] dontinterpolate();
		models[i].angles = teleport_targets[i].angles;
		models[i].origin = teleport_targets[i].origin;
		models[i] stoploopsound(1);
	}
	wait(0.5);
	for(i = 0; i < models.size; i++)
	{
		models[i] show();
	}
	playfxontag(level._effect["black_hole_bomb_event_horizon"], models[0], "tag_origin");
	models[0] playsound("zmb_gersh_teleporter_go");
	models[0] playsound("evt_clank");
	wait(2);
	level notify(#"ctvg_tp_done");
}

/*
	Name: build_exit_stage
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xDB931B30
	Offset: 0x1AA8
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function build_exit_stage(success)
{
}

/*
	Name: build_charge_stage
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xB8A7B953
	Offset: 0x1AC0
	Size: 0x106
	Parameters: 2
	Flags: Linked
*/
function build_charge_stage(num_presses, lines)
{
	stage = spawnstruct();
	stage.num_presses = num_presses;
	stage.lines = [];
	i = 0;
	while(i < lines.size)
	{
		l = spawnstruct();
		l.who = lines[i];
		l.what = lines[i + 1];
		stage.lines[stage.lines.size] = l;
		i = i + 2;
	}
	return stage;
}

/*
	Name: speak_charge_lines
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xAA32D195
	Offset: 0x1BD0
	Size: 0x2D8
	Parameters: 1
	Flags: Linked
*/
function speak_charge_lines(lines)
{
	level.skit_vox_override = 1;
	for(i = 0; i < lines.size; i++)
	{
		l = lines[i];
		sound_ent = undefined;
		switch(l.who)
		{
			case "rictofen":
			{
				players = getplayers();
				for(j = 0; j < players.size; j++)
				{
					ent_num = players[j].characterindex;
					if(isdefined(players[j].zm_random_char))
					{
						ent_num = players[j].zm_random_char;
					}
					if(ent_num == 2)
					{
						sound_ent = players[j];
						break;
					}
				}
				break;
			}
			case "computer":
			case "maxis":
			{
				sound_ent = level._charge_sound_ent;
				break;
			}
		}
		if(l.what == "vox_mcomp_quest_step5_15" || l.what == "vox_mcomp_quest_step5_26")
		{
			level._charge_terminal setmodel("p7_zm_moo_computer_rocket_launch_green");
		}
		else if(l.what == "vox_xcomp_quest_step5_16")
		{
			level._charge_terminal setmodel("p7_zm_moo_computer_rocket_launch_red");
		}
		if(zombie_utility::is_player_valid(sound_ent) && sound_ent zm_equipment::is_active(level.var_f486078e))
		{
			sound_ent playsoundwithnotify(l.what + "_f", "line_spoken");
		}
		else
		{
			sound_ent playsoundwithnotify(l.what, "line_spoken");
		}
		sound_ent waittill(#"line_spoken");
	}
	level._charge_sound_ent stoploopsound();
	level.skit_vox_override = 0;
}

/*
	Name: charge_init
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xB5211EA
	Offset: 0x1EB0
	Size: 0x274
	Parameters: 0
	Flags: Linked
*/
function charge_init()
{
	level._charge_stages = array(build_charge_stage(1, array("rictofen", "vox_plr_2_quest_step5_12")), build_charge_stage(15, array("computer", "vox_mcomp_quest_step5_13", "rictofen", "vox_plr_2_quest_step5_14")), build_charge_stage(15, array("computer", "vox_mcomp_quest_step5_15", "maxis", "vox_xcomp_quest_step5_16", "rictofen", "vox_plr_2_quest_step5_17")), build_charge_stage(10, array("maxis", "vox_xcomp_quest_step5_18", "rictofen", "vox_plr_2_quest_step5_19")), build_charge_stage(15, array("maxis", "vox_xcomp_quest_step5_20", "rictofen", "vox_plr_2_quest_step5_21", "maxis", "vox_xcomp_quest_step5_22", "rictofen", "vox_plr_2_quest_step5_23")), build_charge_stage(10, array("maxis", "vox_xcomp_quest_step5_24", "rictofen", "vox_plr_2_quest_step5_25", "computer", "vox_mcomp_quest_step5_26")));
	sound_struct = struct::get("sq_charge_terminal", "targetname");
	level._charge_sound_ent = spawn("script_origin", sound_struct.origin);
	level._charge_terminal = getent("sq_ctvg_terminal", "targetname");
	level._charge_terminal setmodel("p7_zm_moo_computer_rocket_launch_red");
}

/*
	Name: bucket_qualifier
	Namespace: zm_moon_sq_ctvg
	Checksum: 0x47D56E36
	Offset: 0x2130
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function bucket_qualifier()
{
	ent_num = self.characterindex;
	if(isdefined(self.zm_random_char))
	{
		ent_num = self.zm_random_char;
	}
	if(ent_num == 2)
	{
		return true;
	}
	return false;
}

/*
	Name: wrong_press_qualifier
	Namespace: zm_moon_sq_ctvg
	Checksum: 0x58D35888
	Offset: 0x2180
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function wrong_press_qualifier()
{
	ent_num = self.characterindex;
	if(isdefined(self.zm_random_char))
	{
		ent_num = self.zm_random_char;
	}
	if(ent_num != 2)
	{
		return true;
	}
	return false;
}

/*
	Name: typing_sound_thread
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xAC2F44E3
	Offset: 0x21D0
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function typing_sound_thread()
{
	level endon(#"kill_typing_thread");
	level._charge_sound_ent playloopsound("evt_typing_loop");
	typing = 1;
	level._typing_time = gettime();
	while(true)
	{
		if(typing)
		{
			if((gettime() - level._typing_time) > 250)
			{
				typing = 0;
				level._charge_sound_ent stoploopsound();
			}
		}
		else if((gettime() - level._typing_time) < 100)
		{
			typing = 1;
			level._charge_sound_ent playloopsound("evt_typing_loop");
		}
		wait(0.1);
	}
}

/*
	Name: do_bucket_fill
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xE28381AD
	Offset: 0x22B8
	Size: 0x1AE
	Parameters: 1
	Flags: Linked
*/
function do_bucket_fill(target)
{
	presses = 0;
	players = getplayers();
	richtofen = undefined;
	level thread typing_sound_thread();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		ent_num = player.characterindex;
		if(isdefined(player.zm_random_char))
		{
			ent_num = player.zm_random_char;
		}
		if(ent_num == 2)
		{
			richtofen = players[i];
			break;
		}
	}
	while(presses < target)
	{
		level._charge_sound_ent thread zm_sidequests::fake_use("press", &bucket_qualifier);
		level._charge_sound_ent waittill(#"press");
		presses++;
		level._typing_time = gettime();
		while(isdefined(richtofen) && richtofen usebuttonpressed())
		{
			wait(0.05);
		}
	}
	level notify(#"kill_typing_thread");
}

/*
	Name: wrong_presser_thread
	Namespace: zm_moon_sq_ctvg
	Checksum: 0x1D1F68B3
	Offset: 0x2470
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function wrong_presser_thread()
{
	level endon(#"kill_press_monitor");
	while(true)
	{
		if(isdefined(level._charge_sound_ent))
		{
			level._charge_sound_ent thread zm_sidequests::fake_use("wrong_press", &wrong_press_qualifier);
			level._charge_sound_ent waittill(#"wrong_press", who);
			who thread zm_audio::create_and_play_dialog("eggs", "quest5", 11);
		}
		wait(1);
	}
}

/*
	Name: wrong_collector
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xE50BD4E1
	Offset: 0x2520
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function wrong_collector()
{
	level endon(#"collected");
	while(true)
	{
		self thread zm_sidequests::fake_use("wrong_collector", &wrong_press_qualifier);
		self waittill(#"wrong_collector", who);
		who thread zm_audio::create_and_play_dialog("eggs", "quest5", 27);
		wait(1);
	}
}

/*
	Name: charge_stage_logic
	Namespace: zm_moon_sq_ctvg
	Checksum: 0x5455527A
	Offset: 0x25B0
	Size: 0x2AC
	Parameters: 0
	Flags: Linked
*/
function charge_stage_logic()
{
	stage_index = 0;
	level thread wrong_presser_thread();
	level thread prevent_other_vox_while_here();
	while(stage_index < level._charge_stages.size)
	{
		stage = level._charge_stages[stage_index];
		do_bucket_fill(stage.num_presses);
		speak_charge_lines(stage.lines);
		stage_index++;
	}
	level clientfield::set("vril_generator", 2);
	level.vg_struct_sound playsound("evt_extra_charge");
	level.vg_struct_sound playloopsound("evt_vril_loop_lvl2", 1);
	level thread start_player_vox_again();
	vg = struct::get("sq_charge_vg_pos", "targetname");
	level notify(#"kill_press_monitor");
	vg thread wrong_collector();
	vg thread zm_sidequests::fake_use("collect", &bucket_qualifier);
	vg waittill(#"collect", who);
	who thread zm_audio::create_and_play_dialog("eggs", "quest5", 27);
	who playsound("evt_vril_remove");
	level.vg_struct_sound delete();
	level.vg_struct_sound = undefined;
	level clientfield::set("vril_generator", 3);
	who zm_sidequests::add_sidequest_icon("sq", "cgenerator");
	level notify(#"collected");
	zm_sidequests::stage_completed("ctvg", "charge");
}

/*
	Name: charge_exit_stage
	Namespace: zm_moon_sq_ctvg
	Checksum: 0x16D3D161
	Offset: 0x2868
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function charge_exit_stage(success)
{
	level._charge_sound_ent delete();
	level._charge_sound_ent = undefined;
	level flag::set("vg_charged");
}

/*
	Name: prevent_other_vox_while_here
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xA368AB25
	Offset: 0x28C0
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function prevent_other_vox_while_here()
{
	level endon(#"start_player_vox_again");
	while(true)
	{
		while(level.zones["bridge_zone"].is_occupied)
		{
			level.skit_vox_override = 1;
			wait(1);
		}
		level.skit_vox_override = 0;
		wait(1);
	}
}

/*
	Name: start_player_vox_again
	Namespace: zm_moon_sq_ctvg
	Checksum: 0xA56C55A7
	Offset: 0x2930
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function start_player_vox_again()
{
	level notify(#"start_player_vox_again");
	wait(1);
	level.skit_vox_override = 0;
}

