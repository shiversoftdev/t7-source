// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_cosmodrome;
#using scripts\zm\zm_cosmodrome_amb;
#using scripts\zm\zm_cosmodrome_eggs;

#namespace zm_cosmodrome_eggs;

/*
	Name: init
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x7E63E63F
	Offset: 0xA30
	Size: 0x4BC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level flag::init("target_teleported");
	level flag::init("rerouted_power");
	level flag::init("switches_synced");
	level flag::init("pressure_sustained");
	level flag::init("passkey_confirmed");
	level flag::init("weapons_combined");
	level.casimir_lights = [];
	level.lander_letters["a"] = getent("letter_a", "targetname");
	level.lander_letters["e"] = getent("letter_e", "targetname");
	level.lander_letters["h"] = getent("letter_h", "targetname");
	level.lander_letters["i"] = getent("letter_i", "targetname");
	level.lander_letters["l"] = getent("letter_l", "targetname");
	level.lander_letters["m"] = getent("letter_m", "targetname");
	level.lander_letters["n"] = getent("letter_n", "targetname");
	level.lander_letters["r"] = getent("letter_r", "targetname");
	level.lander_letters["s"] = getent("letter_s", "targetname");
	level.lander_letters["t"] = getent("letter_t", "targetname");
	level.lander_letters["u"] = getent("letter_u", "targetname");
	level.lander_letters["y"] = getent("letter_y", "targetname");
	keys = getarraykeys(level.lander_letters);
	for(i = 0; i < keys.size; i++)
	{
		level.lander_letters[keys[i]] ghost();
	}
	monitor = getent("casimir_monitor", "targetname");
	monitor setmodel("p7_zm_asc_monitor_screen_off");
	teleport_target_event();
	reroute_power_event();
	sync_switch_event();
	pressure_plate_event();
	lander_passkey_event();
	weapon_combo_event();
	level notify(#"help_found");
	monitor = getent("casimir_monitor", "targetname");
	monitor setmodel("p7_zm_asc_monitor_screen_off");
	monitor stoploopsound(0.1);
	monitor playsound("zmb_ee_monitor_off");
}

/*
	Name: play_easter_egg_audio
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xDA9BC137
	Offset: 0xEF8
	Size: 0x72
	Parameters: 3
	Flags: None
*/
function play_easter_egg_audio(alias, sound_ent, text)
{
	if(alias == undefined)
	{
		/#
			iprintlnbold(text);
		#/
		return;
	}
	sound_ent playsoundwithnotify(alias, "sounddone");
	sound_ent waittill(#"sounddone");
}

/*
	Name: activate_casimir_light
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x76077CD9
	Offset: 0xF78
	Size: 0x10E
	Parameters: 1
	Flags: Linked
*/
function activate_casimir_light(num)
{
	spot = struct::get("casimir_light_" + num, "targetname");
	if(isdefined(spot))
	{
		light = spawn("script_model", spot.origin);
		light setmodel("tag_origin");
		light.angles = spot.angles;
		fx = playfxontag(level._effect["fx_light_ee_progress"], light, "tag_origin");
		level.casimir_lights[level.casimir_lights.size] = light;
	}
}

/*
	Name: teleport_target_event
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x20C0495
	Offset: 0x1090
	Size: 0x2AC
	Parameters: 0
	Flags: Linked
*/
function teleport_target_event()
{
	teleport_target_start = struct::get("teleport_target_start", "targetname");
	teleport_target_spark = struct::get("teleport_target_spark", "targetname");
	var_1dc1d30a = teleport_target_spark.angles;
	level.teleport_target = spawn("script_model", teleport_target_start.origin);
	level.teleport_target setmodel("p7_zm_asc_transformer_electrical");
	level.teleport_target.angles = teleport_target_start.angles;
	teleport_target_spark = spawn("script_model", teleport_target_spark.origin);
	teleport_target_spark setmodel("tag_origin");
	teleport_target_spark.angles = var_1dc1d30a;
	playfxontag(level._effect["generator_ee_sparks"], teleport_target_spark, "tag_origin");
	level.teleport_target_trigger = spawn("trigger_radius", teleport_target_start.origin + (vectorscale((0, 0, -1), 70)), 0, 125, 100);
	/#
		if(!isdefined(level.var_74eed1d3) || !level.var_74eed1d3)
		{
			level.teleport_target thread zm_cosmodrome::function_620401c0(level.teleport_target.origin, "", "", 2);
		}
	#/
	level.black_hole_bomb_loc_check_func = &bhb_teleport_loc_check;
	level waittill(#"hash_2a49912");
	teleport_target_spark delete();
	level flag::wait_till("target_teleported");
	level.black_hole_bomb_loc_check_func = undefined;
	level thread play_egg_vox("vox_ann_egg1_success", "vox_gersh_egg1", 1);
}

/*
	Name: bhb_teleport_loc_check
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x348C9816
	Offset: 0x1348
	Size: 0x8C
	Parameters: 3
	Flags: Linked
*/
function bhb_teleport_loc_check(grenade, model, info)
{
	if(isdefined(level.teleport_target_trigger) && grenade istouching(level.teleport_target_trigger))
	{
		model clientfield::set("toggle_black_hole_deployed", 1);
		level thread teleport_target(grenade, model);
		return true;
	}
	return false;
}

/*
	Name: teleport_target
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xAEAD40EA
	Offset: 0x13E0
	Size: 0x244
	Parameters: 2
	Flags: Linked
*/
function teleport_target(grenade, model)
{
	level.teleport_target_trigger delete();
	level.teleport_target_trigger = undefined;
	wait(1);
	level notify(#"hash_2a49912");
	time = 3;
	level.teleport_target moveto(grenade.origin + vectorscale((0, 0, 1), 50), time, time - 0.05);
	wait(time);
	teleport_target_end = struct::get("teleport_target_end", "targetname");
	level.teleport_target ghost();
	playsoundatposition("zmb_gersh_teleporter_out", grenade.origin + vectorscale((0, 0, 1), 50));
	wait(0.5);
	level.teleport_target.angles = teleport_target_end.angles;
	level.teleport_target moveto(teleport_target_end.origin, 0.05);
	wait(0.5);
	level.teleport_target show();
	playfxontag(level._effect["black_hole_bomb_event_horizon"], level.teleport_target, "tag_origin");
	level.teleport_target playsound("zmb_gersh_teleporter_go");
	wait(2);
	model delete();
	level flag::set("target_teleported");
}

/*
	Name: reroute_power_event
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x89C2963C
	Offset: 0x1630
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function reroute_power_event()
{
	monitor = getent("casimir_monitor", "targetname");
	location = struct::get("casimir_monitor_struct", "targetname");
	monitor playsound("zmb_ee_monitor_on");
	monitor playloopsound("zmb_ee_monitor_whitenoise", 1);
	monitor setmodel("p7_zm_asc_monitor_screen_on");
	trig = spawn("trigger_radius", location.origin, 0, 32, 60);
	/#
		if(!isdefined(level.var_4058a336) || !level.var_4058a336)
		{
			trig thread zm_cosmodrome::function_620401c0(monitor.origin, "", "");
		}
	#/
	trig wait_for_use(monitor);
	trig delete();
	level flag::set("rerouted_power");
	monitor setmodel("p7_zm_asc_monitor_screen_logo");
	monitor playloopsound("zmb_ee_monitor_active", 1);
	level thread play_egg_vox("vox_ann_egg2_success", "vox_gersh_egg2", 2);
	level thread activate_casimir_light(1);
}

/*
	Name: wait_for_use
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x12A32001
	Offset: 0x1858
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function wait_for_use(monitor)
{
	/#
		if(isdefined(level.var_4058a336) && level.var_4058a336)
		{
			return;
		}
	#/
	while(true)
	{
		self waittill(#"trigger", who);
		while(isplayer(who) && who istouching(self))
		{
			if(who usebuttonpressed())
			{
				level flag::set("rerouted_power");
				monitor playsound("zmb_ee_monitor_button");
				return;
			}
			wait(0.05);
		}
	}
}

/*
	Name: sync_switch_event
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x1D34EF7C
	Offset: 0x1940
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function sync_switch_event()
{
	switches = struct::get_array("sync_switch_start", "targetname");
	self function_27c6e567(switches);
	level thread play_egg_vox("vox_ann_egg3_success", "vox_gersh_egg3", 3);
	level thread activate_casimir_light(2);
}

/*
	Name: function_27c6e567
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x2BE59079
	Offset: 0x19D8
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function function_27c6e567(switches)
{
	/#
		if(isdefined(level.var_dc7eef87) && level.var_dc7eef87)
		{
			return;
		}
	#/
	while(!level flag::get("switches_synced"))
	{
		level flag::wait_till("monkey_round");
		array::thread_all(switches, &reveal_switch);
		self thread switch_watcher();
		level util::waittill_either("between_round_over", "switches_synced");
	}
}

/*
	Name: reveal_switch
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x32C79B62
	Offset: 0x1AA8
	Size: 0x26C
	Parameters: 0
	Flags: Linked
*/
function reveal_switch()
{
	button = spawn("script_model", self.origin);
	button setmodel("p7_zm_asc_switch_electric_05");
	button.angles = self.angles + vectorscale((0, 1, 0), 90);
	offset = anglestoforward(self.angles) * 8;
	time = 1;
	button moveto(button.origin + offset, 1);
	wait(1);
	if(level flag::get("monkey_round"))
	{
		trig = spawn("trigger_radius", button.origin, 0, 32, 72);
		/#
			if(!isdefined(level.var_dc7eef87) || !level.var_dc7eef87)
			{
				trig thread zm_cosmodrome::function_620401c0(button.origin, "", "");
			}
		#/
		trig thread wait_for_sync_use(self, button);
		level util::waittill_either("between_round_over", "switches_synced");
		/#
			if(!isdefined(level.var_dc7eef87) || !level.var_dc7eef87)
			{
				trig zm_cosmodrome::function_bb831d("");
			}
		#/
		trig delete();
	}
	button moveto(self.origin, time);
	wait(time);
	button delete();
}

/*
	Name: wait_for_sync_use
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xAC8A09A5
	Offset: 0x1D20
	Size: 0x134
	Parameters: 2
	Flags: Linked
*/
function wait_for_sync_use(ss, button)
{
	level endon(#"between_round_over");
	level endon(#"switches_synced");
	ss.pressed = 0;
	while(true)
	{
		self waittill(#"trigger", who);
		while(isplayer(who) && who istouching(self))
		{
			if(who usebuttonpressed())
			{
				level notify(#"sync_button_pressed");
				button playsound("zmb_ee_syncbutton_button");
				ss.pressed = 1;
				/#
					iprintlnbold("");
				#/
				while(who usebuttonpressed())
				{
					wait(0.05);
				}
			}
			wait(0.05);
		}
	}
}

/*
	Name: switch_watcher
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x1DBD00F8
	Offset: 0x1E60
	Size: 0x266
	Parameters: 0
	Flags: Linked
*/
function switch_watcher()
{
	level endon(#"between_round_over");
	pressed = 0;
	switches = struct::get_array("sync_switch_start", "targetname");
	while(true)
	{
		level waittill(#"sync_button_pressed");
		timeout = gettime() + 500;
		/#
			if(isdefined(level.var_ee92e6f7) && level.var_ee92e6f7)
			{
				timeout = timeout + 100000;
			}
		#/
		while(gettime() < timeout)
		{
			pressed = 0;
			for(i = 0; i < switches.size; i++)
			{
				if(isdefined(switches[i].pressed) && switches[i].pressed)
				{
					pressed++;
				}
			}
			if(pressed == 4)
			{
				level flag::set("switches_synced");
				level notify(#"switches_synced");
				for(i = 0; i < switches.size; i++)
				{
					playsoundatposition("zmb_ee_syncbutton_success", switches[i].origin);
				}
				return;
			}
			wait(0.05);
		}
		switch(pressed)
		{
			case 1:
			case 2:
			case 3:
			{
				for(i = 0; i < switches.size; i++)
				{
					playsoundatposition("zmb_ee_syncbutton_deny", switches[i].origin);
				}
				break;
			}
		}
		for(i = 0; i < switches.size; i++)
		{
			switches[i].pressed = 0;
		}
	}
}

/*
	Name: pressure_plate_event
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x9326816A
	Offset: 0x20D0
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function pressure_plate_event()
{
	area = struct::get("pressure_pad", "targetname");
	trig = spawn("trigger_radius", area.origin, 0, 300, 100);
	n_timer = 120;
	/#
		if(isdefined(level.var_4a2af85f) && level.var_4a2af85f)
		{
			n_timer = 30;
		}
	#/
	trig area_timer(n_timer);
	trig delete();
	level thread play_egg_vox("vox_ann_egg4_success", "vox_gersh_egg4", 4);
	level thread activate_casimir_light(3);
}

/*
	Name: area_timer
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x89F6BB6D
	Offset: 0x21F8
	Size: 0x5EA
	Parameters: 1
	Flags: Linked
*/
function area_timer(time)
{
	clock_loc = struct::get("pressure_timer", "targetname");
	clock = spawn("script_model", clock_loc.origin);
	clock setmodel("p7_zm_tra_wall_clock");
	clock.angles = clock_loc.angles;
	var_b07ae42e = struct::get("clock_timer_hand", "targetname");
	timer_hand_angles_init = vectorscale((0, 1, 0), 90);
	timer_hand = util::spawn_model("p7_zm_kin_clock_second_hand", var_b07ae42e.origin, timer_hand_angles_init);
	/#
		if(!isdefined(level.var_c28796c3) || !level.var_c28796c3)
		{
			self thread zm_cosmodrome::function_620401c0(self.origin, "", "");
		}
		else if(isdefined(level.var_c28796c3) && level.var_c28796c3)
		{
			self thread function_1129ebfe();
		}
	#/
	step = 1;
	while(!level flag::get("pressure_sustained"))
	{
		self waittill(#"trigger");
		stop_timer = 0;
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] istouching(self))
			{
				wait(step);
				stop_timer = 1;
				/#
					if(isdefined(level.var_c28796c3) && level.var_c28796c3)
					{
						stop_timer = 0;
					}
				#/
			}
		}
		if(stop_timer)
		{
			continue;
		}
		self playsound("zmb_ee_pressure_plate_down");
		time_remaining = time;
		timer_hand rotatepitch(-360, time);
		/#
			if(isdefined(level.var_c28796c3) && level.var_c28796c3)
			{
				time_remaining = 0;
			}
		#/
		while(time_remaining)
		{
			players = getplayers();
			for(i = 0; i < players.size; i++)
			{
				if(!players[i] istouching(self))
				{
					wait(step);
					time_remaining = time;
					stop_timer = 1;
					self playsound("zmb_ee_pressure_plate_up");
					timer_hand rotateto(timer_hand_angles_init, 0.5);
					timer_hand playsound("zmb_ee_pressure_deny");
					wait(0.5);
					break;
				}
			}
			if(stop_timer)
			{
				break;
			}
			wait(step);
			time_remaining = time_remaining - step;
			timer_hand playsound("zmb_ee_pressure_timer");
		}
		if(time_remaining <= 0)
		{
			level flag::set("pressure_sustained");
			players = getplayers();
			temp_fx = undefined;
			if(isdefined(players[0].fx))
			{
				temp_fx = players[0].fx;
			}
			timer_hand playsound("zmb_perks_packa_ready");
			players[0].fx = level.zombie_powerups["nuke"].fx;
			level thread zm_powerup_nuke::nuke_powerup(players[0], players[0].team);
			clock stoploopsound(1);
			wait(1);
			if(isdefined(temp_fx))
			{
				players[0].fx = temp_fx;
			}
			else
			{
				players[0].fx = undefined;
			}
			/#
				if(!isdefined(level.var_c28796c3) || !level.var_c28796c3)
				{
					self zm_cosmodrome::function_bb831d("");
				}
			#/
			clock delete();
			timer_hand delete();
			return;
		}
	}
}

/*
	Name: function_1129ebfe
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x235E7242
	Offset: 0x27F0
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function function_1129ebfe()
{
	/#
		wait(1);
		self notify(#"trigger");
	#/
}

/*
	Name: lander_passkey_event
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x2F453967
	Offset: 0x2818
	Size: 0x344
	Parameters: 0
	Flags: Linked
*/
function lander_passkey_event()
{
	level flag::init("letter_acquired");
	level.lander_key = [];
	level.lander_key["lander_station1"]["lander_station3"] = "s";
	level.lander_key["lander_station1"]["lander_station4"] = "r";
	level.lander_key["lander_station1"]["lander_station5"] = "e";
	level.lander_key["lander_station3"]["lander_station1"] = "y";
	level.lander_key["lander_station3"]["lander_station4"] = "a";
	level.lander_key["lander_station3"]["lander_station5"] = "i";
	level.lander_key["lander_station4"]["lander_station1"] = "m";
	level.lander_key["lander_station4"]["lander_station3"] = "h";
	level.lander_key["lander_station4"]["lander_station5"] = "u";
	level.lander_key["lander_station5"]["lander_station1"] = "t";
	level.lander_key["lander_station5"]["lander_station3"] = "n";
	level.lander_key["lander_station5"]["lander_station4"] = "l";
	level.passkey = array("l", "u", "n", "a");
	level.passkey_progress = 0;
	level.var_b505a146 = array("h", "i", "t", "s", "a", "m");
	level.var_66e412e8 = 0;
	level.var_8f0326dd = array("h", "y", "e", "n", "a");
	level.var_fd63aa69 = 0;
	level thread lander_monitor();
	level flag::wait_till("passkey_confirmed");
	level thread play_egg_vox("vox_ann_egg5_success", "vox_gersh_egg5", 5);
	level thread activate_casimir_light(4);
}

/*
	Name: lander_monitor
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x64AE7ABF
	Offset: 0x2B68
	Size: 0x358
	Parameters: 0
	Flags: Linked
*/
function lander_monitor()
{
	lander = getent("lander", "targetname");
	/#
		if(isdefined(level.var_c0e05145) && level.var_c0e05145)
		{
			return;
		}
		lander thread function_33078896();
	#/
	while(!level flag::get("passkey_confirmed"))
	{
		level waittill(#"lander_launched");
		if(lander.called)
		{
			start = lander.depart_station;
			dest = lander.station;
			letter = level.lander_key[start][dest];
			model = level.lander_letters[letter];
			model show();
			model playsound("zmb_spawn_powerup");
			model thread spin_letter();
			model playloopsound("zmb_spawn_powerup_loop", 0.5);
			trig = spawn("trigger_radius", model.origin, 0, 200, 150);
			/#
				trig function_362373ab(model);
			#/
			trig thread letter_grab(letter, model);
			level flag::wait_till("lander_grounded");
			if(!level flag::get("letter_acquired"))
			{
				function_874d06b6();
				/#
					lander thread function_33078896();
					trig thread zm_cosmodrome::function_bb831d("");
				#/
			}
			else
			{
				level flag::clear("letter_acquired");
			}
			trig delete();
			model ghost();
			model stoploopsound(0.5);
		}
		else
		{
			function_874d06b6();
			/#
				lander thread function_33078896();
				trig thread zm_cosmodrome::function_bb831d("");
			#/
		}
	}
}

/*
	Name: function_362373ab
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x45AE0F1E
	Offset: 0x2EC8
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function function_362373ab(model)
{
	/#
		if(level flag::get(""))
		{
			v_player_angles = getplayers()[0] getplayerangles();
			v_player_origin = getplayers()[0] getorigin();
			var_ab7c1d7f = v_player_origin + (anglestoforward(v_player_angles) * 128);
			model.origin = level.var_40705128.origin + vectorscale((0, 0, 1), 32);
			self.origin = model.origin;
		}
		self thread zm_cosmodrome::function_620401c0(model.origin, "", "", 3);
	#/
}

/*
	Name: function_874d06b6
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x47496ED
	Offset: 0x3018
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function function_874d06b6()
{
	/#
		level notify(#"hash_eeefde1f");
	#/
	level.passkey_progress = 0;
	level.var_66e412e8 = 0;
	level.var_fd63aa69 = 0;
}

/*
	Name: function_33078896
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xBE135435
	Offset: 0x3058
	Size: 0x126
	Parameters: 0
	Flags: Linked
*/
function function_33078896()
{
	/#
		if(!isdefined(level.var_c0e05145) || !level.var_c0e05145)
		{
			level endon(#"hash_eeefde1f");
			var_1fc8b439 = array("", "", "", "", "");
			for(i = 0; i < var_1fc8b439.size; i++)
			{
				level.var_40705128 = struct::get(var_1fc8b439[i], "");
				level.var_40705128 thread zm_cosmodrome::function_620401c0(level.var_40705128.origin, "", "", 3);
				self function_e07806c9(level.var_40705128);
			}
		}
	#/
}

/*
	Name: function_e07806c9
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x272545F8
	Offset: 0x3188
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_e07806c9(s_station)
{
	/#
		while(self.station != s_station.targetname)
		{
			wait(0.25);
		}
		s_station notify(#"hash_9465652d");
		util::wait_network_frame();
	#/
}

/*
	Name: spin_letter
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xFA0519E2
	Offset: 0x31E8
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function spin_letter()
{
	level endon(#"lander_grounded");
	level endon(#"letter_acquired");
	while(true)
	{
		self rotateyaw(90, 5);
		wait(5);
	}
}

/*
	Name: letter_grab
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xF16BDC23
	Offset: 0x3238
	Size: 0x1EC
	Parameters: 2
	Flags: Linked
*/
function letter_grab(letter, model)
{
	level endon(#"lander_grounded");
	self waittill(#"trigger", e_player);
	level flag::set("letter_acquired");
	playsoundatposition("zmb_powerup_grabbed", model.origin);
	model ghost();
	/#
		self zm_cosmodrome::function_bb831d("");
	#/
	if(letter == level.passkey[level.passkey_progress])
	{
		level.passkey_progress++;
		if(level.passkey_progress == level.passkey.size)
		{
			level flag::set("passkey_confirmed");
		}
	}
	else
	{
		level.passkey_progress = 0;
	}
	if(letter == level.var_b505a146[level.var_66e412e8])
	{
		level.var_66e412e8++;
		if(level.var_66e412e8 == level.var_b505a146.size)
		{
			e_player playsoundtoplayer("evt_letter_pickup_secret_1", e_player);
		}
	}
	else
	{
		level.var_66e412e8 = 0;
	}
	if(letter == level.var_8f0326dd[level.var_fd63aa69])
	{
		level.var_fd63aa69++;
		if(level.var_fd63aa69 == level.var_8f0326dd.size)
		{
			e_player playsoundtoplayer("evt_letter_pickup_secret_2", e_player);
		}
	}
	else
	{
		level.var_fd63aa69 = 0;
	}
}

/*
	Name: weapon_combo_event
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xC96906AC
	Offset: 0x3430
	Size: 0x1EE
	Parameters: 0
	Flags: Linked
*/
function weapon_combo_event()
{
	level flag::init("thundergun_hit");
	weapon_combo_spot = struct::get("weapon_combo_spot", "targetname");
	focal_point = spawn("script_model", weapon_combo_spot.origin);
	focal_point setmodel("tag_origin");
	fx = playfxontag(level._effect["gersh_spark"], focal_point, "tag_origin");
	level.black_hold_bomb_target_trig = spawn("trigger_radius", weapon_combo_spot.origin, 0, 50, 72);
	level.black_hole_bomb_loc_check_func = &bhb_combo_loc_check;
	/#
		focal_point thread function_a0ad103c(weapon_combo_spot);
	#/
	level flag::wait_till("weapons_combined");
	level.black_hold_bomb_target_trig delete();
	level.black_hole_bomb_loc_check_func = undefined;
	focal_point delete();
	for(i = 0; i < level.casimir_lights.size; i++)
	{
		level.casimir_lights[i] delete();
	}
}

/*
	Name: function_a0ad103c
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xD69D8FD4
	Offset: 0x3628
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_a0ad103c(weapon_combo_spot)
{
	/#
		if(isdefined(level.var_55336afe) && level.var_55336afe)
		{
			self thread function_510c4845();
			wait(1);
			self notify(#"death");
		}
		else
		{
			weapon_combo_spot thread function_8172c64e();
		}
	#/
}

/*
	Name: function_8172c64e
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x25741739
	Offset: 0x36A0
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_8172c64e()
{
	/#
		self thread zm_cosmodrome::function_620401c0(self.origin, "", "");
		level flag::wait_till("");
		self thread zm_cosmodrome::function_bb831d("");
	#/
}

/*
	Name: bhb_combo_loc_check
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xF39A4078
	Offset: 0x3728
	Size: 0x5E
	Parameters: 3
	Flags: Linked
*/
function bhb_combo_loc_check(grenade, model, info)
{
	if(isdefined(level.black_hold_bomb_target_trig) && grenade istouching(level.black_hold_bomb_target_trig))
	{
		grenade function_510c4845();
	}
	return false;
}

/*
	Name: function_510c4845
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x286B70FE
	Offset: 0x3790
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_510c4845()
{
	trig = spawn("trigger_damage", self.origin, 0, 15, 72);
	self thread wait_for_combo(trig);
}

/*
	Name: wait_for_combo
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xF5AD32C6
	Offset: 0x37F0
	Size: 0x28A
	Parameters: 1
	Flags: Linked
*/
function wait_for_combo(trig)
{
	self endon(#"death");
	self thread kill_trig_on_death(trig);
	weapon_combo_spot = struct::get("weapon_combo_spot", "targetname");
	ray_gun_hit = 0;
	doll_hit = 0;
	/#
		if(isdefined(level.var_55336afe) && level.var_55336afe)
		{
			ray_gun_hit = 1;
			doll_hit = 1;
		}
	#/
	players = getplayers();
	array::thread_all(players, &thundergun_check, self, trig, weapon_combo_spot);
	while(true)
	{
		trig waittill(#"damage", amount, inflictor, direction, point, type, tagname, modelname, partname, weapon);
		if(isdefined(inflictor))
		{
			if(type == "MOD_PROJECTILE" && (weapon.name == "ray_gun_upgraded" || weapon.name == "raygun_mark2_upgraded"))
			{
				ray_gun_hit = 1;
			}
			else if(weapon.name == "nesting_dolls" || weapon.name == "nesting_dolls_single")
			{
				doll_hit = 1;
			}
			if(ray_gun_hit && doll_hit && level flag::get("thundergun_hit"))
			{
				level flag::set("weapons_combined");
				level thread soul_release(self, trig.origin);
				return;
			}
		}
	}
}

/*
	Name: thundergun_check
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xB534131B
	Offset: 0x3A88
	Size: 0x1B8
	Parameters: 3
	Flags: Linked
*/
function thundergun_check(model, trig, weapon_combo_spot)
{
	/#
		if(isdefined(level.var_55336afe) && level.var_55336afe)
		{
			util::wait_network_frame();
			self function_30d8de55(trig);
			return;
		}
	#/
	model endon(#"death");
	while(true)
	{
		self waittill(#"weapon_fired");
		var_ca8d49bb = self getcurrentweapon();
		if(var_ca8d49bb.name == "thundergun_upgraded")
		{
			if(distancesquared(self.origin, weapon_combo_spot.origin) < 90000)
			{
				vector_to_spot = vectornormalize(weapon_combo_spot.origin - self getweaponmuzzlepoint());
				vector_player_facing = self getweaponforwarddir();
				angle_diff = acos(vectordot(vector_to_spot, vector_player_facing));
				if(angle_diff <= 20)
				{
					self function_30d8de55(trig);
				}
			}
		}
	}
}

/*
	Name: function_30d8de55
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xED7CDC56
	Offset: 0x3C48
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_30d8de55(trig)
{
	level flag::set("thundergun_hit");
	radiusdamage(trig.origin, 5, 1, 1, self);
}

/*
	Name: kill_trig_on_death
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x9A59AA6E
	Offset: 0x3CB0
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function kill_trig_on_death(trig)
{
	self waittill(#"death");
	trig delete();
	if(level flag::get("thundergun_hit") && !level flag::get("weapons_combined"))
	{
		level thread play_egg_vox("vox_ann_egg6p1_success", "vox_gersh_egg6_fail2", 7);
	}
	else if(!level flag::get("weapons_combined"))
	{
		level thread play_egg_vox(undefined, "vox_gersh_egg6_fail1", 6);
	}
	level flag::clear("thundergun_hit");
}

/*
	Name: soul_release
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xCA277015
	Offset: 0x3DB8
	Size: 0x17C
	Parameters: 2
	Flags: Linked
*/
function soul_release(model, origin)
{
	soul = spawn("script_model", origin);
	soul setmodel("tag_origin");
	soul playloopsound("zmb_egg_soul");
	fx = playfxontag(level._effect["gersh_spark"], soul, "tag_origin");
	time = 20;
	model waittill(#"death");
	level thread play_egg_vox("vox_ann_egg6_success", "vox_gersh_egg6_success", 9);
	level thread wait_for_gersh_vox();
	soul movez(2500, time, time - 1);
	wait(time);
	soul delete();
	wait(2);
	level thread samantha_is_angry();
}

/*
	Name: wait_for_gersh_vox
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xEEBAFA53
	Offset: 0x3F40
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function wait_for_gersh_vox()
{
	wait(12.5);
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread reward_wait();
	}
}

/*
	Name: reward_wait
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x10D4E2A3
	Offset: 0x3FB8
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function reward_wait()
{
	while(!zombie_utility::is_player_valid(self) || (self usebuttonpressed() && self zm_utility::in_revive_trigger()))
	{
		wait(1);
	}
	if(!self bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		level thread zm_powerup_weapon_minigun::minigun_weapon_powerup(self, 90);
	}
	self zm_utility::give_player_all_perks();
}

/*
	Name: play_egg_vox
	Namespace: zm_cosmodrome_eggs
	Checksum: 0xB7648028
	Offset: 0x4078
	Size: 0x1BC
	Parameters: 3
	Flags: Linked
*/
function play_egg_vox(ann_alias, gersh_alias, plr_num)
{
	if(isdefined(ann_alias))
	{
		level zm_cosmodrome_amb::play_cosmo_announcer_vox(ann_alias);
	}
	if(isdefined(plr_num) && !isdefined(level.var_92ed253c))
	{
		players = getplayers();
		rand = randomintrange(0, players.size);
		players[rand] playsoundwithnotify((("vox_plr_" + players[rand].characterindex) + "_level_start_") + randomintrange(0, 4), "level_start_vox_done");
		players[rand] waittill(#"level_start_vox_done");
		level.var_92ed253c = 1;
	}
	if(isdefined(gersh_alias))
	{
		level zm_cosmodrome_amb::play_gersh_vox(gersh_alias);
	}
	if(isdefined(plr_num))
	{
		players = getplayers();
		rand = randomintrange(0, players.size);
		players[rand] zm_audio::create_and_play_dialog("eggs", "gersh_response", plr_num);
	}
}

/*
	Name: samantha_is_angry
	Namespace: zm_cosmodrome_eggs
	Checksum: 0x2F0A3798
	Offset: 0x4240
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function samantha_is_angry()
{
	playsoundatposition("zmb_samantha_earthquake", (0, 0, 0));
	playsoundatposition("zmb_samantha_whispers", (0, 0, 0));
	wait(6);
	level clientfield::set("COSMO_EGG_SAM_ANGRY", 1);
	playsoundatposition("zmb_samantha_scream", (0, 0, 0));
	wait(6);
	level clientfield::set("COSMO_EGG_SAM_ANGRY", 0);
}

