// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\music_shared;

#namespace zm_factory_amb;

/*
	Name: main
	Namespace: zm_factory_amb
	Checksum: 0x24A0C2D2
	Offset: 0x410
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function main()
{
	thread start_lights();
	thread teleport_pad_init(0);
	thread teleport_pad_init(1);
	thread teleport_pad_init(2);
	thread teleport_2d();
	thread pa_init(0);
	thread pa_init(1);
	thread pa_init(2);
	thread pa_single_init();
	thread homepad_loop();
	thread power_audio_2d();
	thread linkall_2d();
	thread crazy_power();
	thread flip_sparks();
	thread play_added_ambience();
	thread play_flux_whispers();
	thread play_backwards_children();
}

/*
	Name: start_lights
	Namespace: zm_factory_amb
	Checksum: 0xC23D6FBB
	Offset: 0x560
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function start_lights()
{
	level waittill(#"pl1");
	array::thread_all(struct::get_array("dyn_light", "targetname"), &light_sound);
	array::thread_all(struct::get_array("switch_progress", "targetname"), &switch_progress_sound);
	array::thread_all(struct::get_array("dyn_generator", "targetname"), &generator_sound);
	array::thread_all(struct::get_array("dyn_breakers", "targetname"), &breakers_sound);
}

/*
	Name: light_sound
	Namespace: zm_factory_amb
	Checksum: 0x405D6FC8
	Offset: 0x680
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function light_sound()
{
	if(isdefined(self))
	{
		playsound(0, "evt_light_start", self.origin);
		e1 = audio::playloopat("amb_light_buzz", self.origin);
	}
}

/*
	Name: generator_sound
	Namespace: zm_factory_amb
	Checksum: 0x22B764B1
	Offset: 0x6E8
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function generator_sound()
{
	if(isdefined(self))
	{
		wait(3);
		playsound(0, "evt_switch_progress", self.origin);
		playsound(0, "evt_gen_start", self.origin);
		g1 = audio::playloopat("evt_gen_loop", self.origin);
	}
}

/*
	Name: breakers_sound
	Namespace: zm_factory_amb
	Checksum: 0x648FF3F0
	Offset: 0x778
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function breakers_sound()
{
	if(isdefined(self))
	{
		playsound(0, "evt_break_start", self.origin);
		b1 = audio::playloopat("evt_break_loop", self.origin);
	}
}

/*
	Name: switch_progress_sound
	Namespace: zm_factory_amb
	Checksum: 0xD093BAB3
	Offset: 0x7E0
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function switch_progress_sound()
{
	if(isdefined(self.script_noteworthy))
	{
		if(self.script_noteworthy == "1")
		{
			time = 0.5;
		}
		else
		{
			if(self.script_noteworthy == "2")
			{
				time = 1;
			}
			else
			{
				if(self.script_noteworthy == "3")
				{
					time = 1.5;
				}
				else
				{
					if(self.script_noteworthy == "4")
					{
						time = 2;
					}
					else
					{
						if(self.script_noteworthy == "5")
						{
							time = 2.5;
						}
						else
						{
							time = 0;
						}
					}
				}
			}
		}
		wait(time);
		playsound(0, "evt_switch_progress", self.origin);
	}
}

/*
	Name: homepad_loop
	Namespace: zm_factory_amb
	Checksum: 0x155EEA8B
	Offset: 0x8E8
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function homepad_loop()
{
	level waittill(#"pap1");
	homepad = struct::get("homepad_power_looper", "targetname");
	home_breaker = struct::get("homepad_breaker", "targetname");
	if(isdefined(homepad))
	{
		audio::playloopat("amb_homepad_power_loop", homepad.origin);
	}
	if(isdefined(home_breaker))
	{
		audio::playloopat("amb_break_arc", home_breaker.origin);
	}
}

/*
	Name: teleport_pad_init
	Namespace: zm_factory_amb
	Checksum: 0x127A9C24
	Offset: 0x9C8
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function teleport_pad_init(pad)
{
	telepad = struct::get_array("telepad_" + pad, "targetname");
	telepad_loop = struct::get_array(("telepad_" + pad) + "_looper", "targetname");
	homepad = struct::get_array("homepad", "targetname");
	level waittill("tp" + pad);
	array::thread_all(telepad_loop, &telepad_loop);
	array::thread_all(telepad, &teleportation_audio, pad);
	array::thread_all(homepad, &teleportation_audio, pad);
}

/*
	Name: telepad_loop
	Namespace: zm_factory_amb
	Checksum: 0x6B5370A1
	Offset: 0xB08
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function telepad_loop()
{
	audio::playloopat("amb_power_loop", self.origin);
}

/*
	Name: teleportation_audio
	Namespace: zm_factory_amb
	Checksum: 0xB8D9F8A1
	Offset: 0xB38
	Size: 0x138
	Parameters: 1
	Flags: Linked
*/
function teleportation_audio(pad)
{
	teleport_delay = 2;
	while(true)
	{
		level waittill("tpw" + pad);
		if(isdefined(self.script_sound))
		{
			if(self.targetname == ("telepad_" + pad))
			{
				playsound(0, self.script_sound + "_warmup", self.origin);
				wait(2);
				playsound(0, self.script_sound + "_cooldown", self.origin);
			}
			if(self.targetname == "homepad")
			{
				wait(2);
				playsound(0, self.script_sound + "_warmup", self.origin);
				playsound(0, self.script_sound + "_cooldown", self.origin);
			}
		}
	}
}

/*
	Name: pa_init
	Namespace: zm_factory_amb
	Checksum: 0x3809990E
	Offset: 0xC78
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function pa_init(pad)
{
	pa_sys = struct::get_array("pa_system", "targetname");
}

/*
	Name: pa_single_init
	Namespace: zm_factory_amb
	Checksum: 0x4A951AAF
	Offset: 0xCB8
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function pa_single_init()
{
	pa_sys = struct::get_array("pa_system", "targetname");
}

/*
	Name: pa_countdown
	Namespace: zm_factory_amb
	Checksum: 0xC8C2FAF3
	Offset: 0xCF0
	Size: 0x186
	Parameters: 1
	Flags: None
*/
function pa_countdown(pad)
{
	level endon("scd" + pad);
	while(true)
	{
		level waittill("pac" + pad);
		playsound(0, "evt_pa_buzz", self.origin);
		self thread pa_play_dialog("vox_pa_audio_link_start");
		for(count = 30; count > 0; count--)
		{
			play = count == 20 || count == 15 || count <= 10;
			if(play)
			{
				playsound(0, "vox_pa_audio_link_" + count, self.origin);
			}
			playsound(0, "evt_clock_tick_1sec", (0, 0, 0));
			waitrealtime(1);
		}
		playsound(0, "evt_pa_buzz", self.origin);
		wait(1.2);
		self thread pa_play_dialog("vox_pa_audio_link_fail");
	}
	wait(1);
}

/*
	Name: pa_countdown_success
	Namespace: zm_factory_amb
	Checksum: 0xB18017F4
	Offset: 0xE80
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function pa_countdown_success(pad)
{
	level waittill("scd" + pad);
	playsound(0, "evt_pa_buzz", self.origin);
	wait(1.2);
	self pa_play_dialog("vox_pa_audio_act_pad_" + pad);
}

/*
	Name: pa_teleport
	Namespace: zm_factory_amb
	Checksum: 0xF57444A5
	Offset: 0xEF8
	Size: 0x80
	Parameters: 1
	Flags: None
*/
function pa_teleport(pad)
{
	while(true)
	{
		level waittill("tpc" + pad);
		wait(1);
		playsound(0, "evt_pa_buzz", self.origin);
		wait(1.2);
		self pa_play_dialog("vox_pa_teleport_finish");
	}
}

/*
	Name: pa_electric_trap
	Namespace: zm_factory_amb
	Checksum: 0xBD0CF2A4
	Offset: 0xF80
	Size: 0xC8
	Parameters: 1
	Flags: None
*/
function pa_electric_trap(location)
{
	while(true)
	{
		level waittill(location);
		playsound(0, "evt_pa_buzz", self.origin);
		wait(1.2);
		self thread pa_play_dialog("vox_pa_trap_inuse_" + location);
		waitrealtime(48.5);
		playsound(0, "evt_pa_buzz", self.origin);
		wait(1.2);
		self thread pa_play_dialog("vox_pa_trap_active_" + location);
	}
}

/*
	Name: pa_play_dialog
	Namespace: zm_factory_amb
	Checksum: 0xEA936CE2
	Offset: 0x1050
	Size: 0xA0
	Parameters: 1
	Flags: Linked
*/
function pa_play_dialog(alias)
{
	if(!isdefined(self.pa_is_speaking))
	{
		self.pa_is_speaking = 0;
	}
	if(self.pa_is_speaking != 1)
	{
		self.pa_is_speaking = 1;
		self.pa_id = playsound(0, alias, self.origin);
		while(soundplaying(self.pa_id))
		{
			wait(0.01);
		}
		self.pa_is_speaking = 0;
	}
}

/*
	Name: teleport_2d
	Namespace: zm_factory_amb
	Checksum: 0xA79AFEFD
	Offset: 0x10F8
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function teleport_2d()
{
	while(true)
	{
		level waittill(#"t2d");
		playsound(0, "evt_teleport_2d_fnt", (0, 0, 0));
		playsound(0, "evt_teleport_2d_rear", (0, 0, 0));
	}
}

/*
	Name: power_audio_2d
	Namespace: zm_factory_amb
	Checksum: 0x824EA3F8
	Offset: 0x1160
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function power_audio_2d()
{
	level waittill(#"pl1");
	playsound(0, "evt_power_up_2d", (0, 0, 0));
}

/*
	Name: linkall_2d
	Namespace: zm_factory_amb
	Checksum: 0x4586D826
	Offset: 0x11A0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function linkall_2d()
{
	level waittill(#"pap1");
	playsound(0, "evt_linkall_2d", (0, 0, 0));
}

/*
	Name: pa_level_start
	Namespace: zm_factory_amb
	Checksum: 0x99EC1590
	Offset: 0x11E0
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function pa_level_start()
{
}

/*
	Name: pa_power_on
	Namespace: zm_factory_amb
	Checksum: 0x8F88C43D
	Offset: 0x11F0
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function pa_power_on()
{
	level waittill(#"pl1");
	playsound(0, "evt_pa_buzz", self.origin);
	wait(1.2);
	self pa_play_dialog("vox_pa_power_on");
}

/*
	Name: crazy_power
	Namespace: zm_factory_amb
	Checksum: 0xE893BDC7
	Offset: 0x1258
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function crazy_power()
{
	level waittill(#"pl1");
	playsound(0, "evt_crazy_power_left", (-510, 394, 102));
	playsound(0, "evt_crazy_power_right", (554, -1696, 156));
}

/*
	Name: flip_sparks
	Namespace: zm_factory_amb
	Checksum: 0xE2E155F9
	Offset: 0x12C8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function flip_sparks()
{
	level waittill(#"pl1");
	playsound(0, "evt_flip_sparks_left", (511, -1771, 116));
	playsound(0, "evt_flip_sparks_right", (550, -1771, 116));
}

/*
	Name: play_added_ambience
	Namespace: zm_factory_amb
	Checksum: 0x5DE2B921
	Offset: 0x1338
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function play_added_ambience()
{
	audio::playloopat("amb_snow_transitions", (-181, -455, 6));
	audio::playloopat("amb_snow_transitions", (1315, -1428, 227));
	audio::playloopat("amb_snow_transitions", (-1365, -1597, 295));
	audio::playloopat("amb_extreme_fire_dist", (1892, -2563, 1613));
	audio::playloopat("amb_extreme_fire_dist", (1441, -1622, 1603));
	audio::playloopat("amb_extreme_fire_dist", (-1561, 410, 1559));
	audio::playloopat("amb_extreme_fire_dist", (844, 2038, 915));
	audio::playloopat("amb_small_fire", (779, -2249, 326));
	audio::playloopat("amb_small_fire", (-2, -1417, 124));
	audio::playloopat("amb_small_fire", (1878, 911, 189));
}

/*
	Name: play_flux_whispers
	Namespace: zm_factory_amb
	Checksum: 0xFC07904F
	Offset: 0x14D8
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function play_flux_whispers()
{
	while(true)
	{
		playsound(0, "amb_creepy_whispers", (-339, 271, 207));
		playsound(0, "amb_creepy_whispers", (234, 110, 310));
		playsound(0, "amb_creepy_whispers", (-17, -564, 255));
		playsound(0, "amb_creepy_whispers", (743, -1859, 210));
		playsound(0, "amb_creepy_whispers", (790, -748, 181));
		wait(randomintrange(1, 4));
	}
}

/*
	Name: play_backwards_children
	Namespace: zm_factory_amb
	Checksum: 0xCB1F9F96
	Offset: 0x15D0
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function play_backwards_children()
{
	while(true)
	{
		wait(60);
		playsound(0, "amb_creepy_children", (-2637, -2403, 413));
	}
}

