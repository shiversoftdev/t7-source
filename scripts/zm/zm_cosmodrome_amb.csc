// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_audio;

#namespace zm_cosmodrome_amb;

/*
	Name: main
	Namespace: zm_cosmodrome_amb
	Checksum: 0xFE225B40
	Offset: 0x438
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread alarm_a_timer();
	level thread alarm_b_timer();
	level thread spawn_fx_loopers();
	level thread play_minigun_loop();
	level thread amb_power_up();
	level thread function_d19cb2f8();
	level thread function_c9207335();
}

/*
	Name: spawn_fx_loopers
	Namespace: zm_cosmodrome_amb
	Checksum: 0x80614AD8
	Offset: 0x4F0
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function spawn_fx_loopers()
{
	audio::snd_play_auto_fx("fx_fire_line_xsm", "amb_fire_medium");
	audio::snd_play_auto_fx("fx_fire_line_sm", "amb_fire_large");
	audio::snd_play_auto_fx("fx_fire_wall_back_sm", "amb_fire_large");
	audio::snd_play_auto_fx("fx_fire_destruction_lg", "amb_fire_extreme");
	audio::snd_play_auto_fx("fx_zmb_fire_sm_smolder", "amb_fire_medium");
	audio::snd_play_auto_fx("fx_elec_terminal", "amb_break_arc");
	audio::snd_play_auto_fx("fx_zmb_elec_terminal_bridge", "amb_break_arc");
	audio::snd_play_auto_fx("fx_zmb_pipe_steam_md", "amb_steam_medium");
	audio::snd_play_auto_fx("fx_zmb_pipe_steam_md_runner", "amb_steam_medium");
	audio::snd_play_auto_fx("fx_zmb_steam_hallway_md", "amb_steam_medium");
	audio::snd_play_auto_fx("fx_zmb_water_spray_leak_sm", "amb_water_spray_small");
	audio::playloopat("amb_secret_truck_iseverything", (-1419, 1506, -124));
}

/*
	Name: play_minigun_loop
	Namespace: zm_cosmodrome_amb
	Checksum: 0x1C0A880
	Offset: 0x688
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function play_minigun_loop()
{
	while(true)
	{
		level waittill(#"minis");
		ent = spawn(0, (0, 0, 0), "script_origin");
		ent playloopsound("zmb_insta_kill_loop");
		level waittill(#"minie");
		playsound(0, "zmb_insta_kill", (0, 0, 0));
		ent stoploopsound(0.5);
		wait(0.5);
		ent delete();
	}
}

/*
	Name: alarm_a_timer
	Namespace: zm_cosmodrome_amb
	Checksum: 0xD624FA65
	Offset: 0x768
	Size: 0x3E
	Parameters: 0
	Flags: Linked
*/
function alarm_a_timer()
{
	level waittill(#"power_on");
	wait(2.5);
	level thread alarm_a();
	wait(21);
	level notify(#"alarm_a_off");
}

/*
	Name: alarm_b_timer
	Namespace: zm_cosmodrome_amb
	Checksum: 0xB3CE7329
	Offset: 0x7B0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function alarm_b_timer()
{
	level waittill(#"power_on");
	wait(8.5);
	level thread alarm_b();
}

/*
	Name: play_alarm_a
	Namespace: zm_cosmodrome_amb
	Checksum: 0x5339836D
	Offset: 0x7E8
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function play_alarm_a()
{
	level endon(#"alarm_a_off");
	while(true)
	{
		playsound(0, "evt_alarm_a", self.origin);
		wait(1.1);
	}
}

/*
	Name: play_alarm_b
	Namespace: zm_cosmodrome_amb
	Checksum: 0x86B13FFF
	Offset: 0x838
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function play_alarm_b()
{
	alarm_bell = spawn(0, self.origin, "script.origin");
	alarm_bell.var_1875fe27 = alarm_bell playloopsound("evt_alarm_b_loop", 0.8);
	wait(8.8);
	playsound(0, "evt_alarm_b_end", self.origin);
	wait(0.1);
	alarm_bell stoploopsound(alarm_bell.var_1875fe27, 0.6);
	wait(3);
	alarm_bell delete();
}

/*
	Name: alarm_a
	Namespace: zm_cosmodrome_amb
	Checksum: 0xA32D8B73
	Offset: 0x928
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function alarm_a()
{
	array::thread_all(struct::get_array("amb_warning_siren", "targetname"), &play_alarm_a);
}

/*
	Name: alarm_b
	Namespace: zm_cosmodrome_amb
	Checksum: 0x66645AD2
	Offset: 0x978
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function alarm_b()
{
	array::thread_all(struct::get_array("amb_warning_bell", "targetname"), &play_alarm_b);
}

/*
	Name: play_pa_vox
	Namespace: zm_cosmodrome_amb
	Checksum: 0x7C7CA3C0
	Offset: 0x9C8
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function play_pa_vox()
{
	wait(2);
	playsound(0, "amb_vox_rus_PA", self.origin);
}

/*
	Name: samantha_is_angry_earthquake_and_rumbles
	Namespace: zm_cosmodrome_amb
	Checksum: 0xD47EEF
	Offset: 0xA00
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function samantha_is_angry_earthquake_and_rumbles(localclientnum)
{
	player = getlocalplayers()[localclientnum];
	audio::snd_set_snapshot("zmb_samantha_scream");
	player earthquake(0.4, 10, player.origin, 150);
	visionset_mgr::fog_vol_to_visionset_set_suffix("_nopower");
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zombie_cosmodrome", 2.5);
	player thread do_that_sam_rumble();
	wait(6);
	audio::snd_set_snapshot("default");
	visionset_mgr::fog_vol_to_visionset_set_suffix("_poweron");
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zombie_cosmodrome", 2.5);
}

/*
	Name: do_that_sam_rumble
	Namespace: zm_cosmodrome_amb
	Checksum: 0x6C6E64EE
	Offset: 0xB40
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function do_that_sam_rumble()
{
	self endon(#"disconnect");
	count = 0;
	while(count <= 4 && isdefined(self))
	{
		self playrumbleonentity(0, "damage_heavy");
		wait(0.1);
		count = count + 0.1;
	}
}

/*
	Name: function_c9207335
	Namespace: zm_cosmodrome_amb
	Checksum: 0xB4BD17E2
	Offset: 0xBC0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_c9207335()
{
	wait(3);
	level thread function_d667714e();
	var_13a52dfe = getentarray(0, "sndMusicTrig", "targetname");
	array::thread_all(var_13a52dfe, &function_60a32834);
}

/*
	Name: function_60a32834
	Namespace: zm_cosmodrome_amb
	Checksum: 0x7F3C610A
	Offset: 0xC40
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_60a32834()
{
	while(true)
	{
		self waittill(#"trigger", trigplayer);
		if(trigplayer islocalplayer())
		{
			level notify(#"hash_51d7bc7c", self.script_sound);
			while(isdefined(trigplayer) && trigplayer istouching(self))
			{
				wait(0.016);
			}
		}
		else
		{
			wait(0.016);
		}
	}
}

/*
	Name: function_d667714e
	Namespace: zm_cosmodrome_amb
	Checksum: 0x70431B36
	Offset: 0xCE0
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function function_d667714e()
{
	level.var_b6342abd = "mus_cosmo_underscore_default";
	level.var_6d9d81aa = "mus_cosmo_underscore_default";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 playloopsound(level.var_b6342abd, 2);
	while(true)
	{
		level waittill(#"hash_51d7bc7c", location);
		level.var_6d9d81aa = "mus_cosmo_underscore_" + location;
		if(level.var_6d9d81aa != level.var_b6342abd)
		{
			level thread function_b234849(level.var_6d9d81aa);
			level.var_b6342abd = level.var_6d9d81aa;
		}
	}
}

/*
	Name: function_b234849
	Namespace: zm_cosmodrome_amb
	Checksum: 0xA3B29F2
	Offset: 0xDE0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_b234849(var_6d9d81aa)
{
	level endon(#"hash_51d7bc7c");
	level.var_eb526c90 stopallloopsounds(2);
	wait(1);
	level.var_9433cf5a = level.var_eb526c90 playloopsound(var_6d9d81aa, 2);
}

/*
	Name: amb_power_up
	Namespace: zm_cosmodrome_amb
	Checksum: 0xECBACCD2
	Offset: 0xE50
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function amb_power_up()
{
	wait(2);
	level.var_41176517 = struct::get_array("amb_computer", "targetname");
	level waittill(#"power_on");
	level.var_39f6798 = struct::get("amb_power_up", "targetname");
	if(isdefined(level.var_39f6798))
	{
		playsound(0, level.var_39f6798.script_sound, level.var_39f6798.origin);
	}
	wait(4);
	if(isdefined(level.var_41176517))
	{
		for(i = 0; i < level.var_41176517.size; i++)
		{
			wait(randomfloatrange(0.1, 0.25));
			playsound(0, level.var_41176517[i].script_soundalias, level.var_41176517[i].origin);
		}
	}
	level notify(#"hash_562bd5c4");
	level thread function_729f3d20();
	if(isdefined(level.var_39f6798))
	{
		audio::playloopat("evt_power_loop", level.var_39f6798.origin);
	}
}

/*
	Name: function_729f3d20
	Namespace: zm_cosmodrome_amb
	Checksum: 0xF3E15566
	Offset: 0x1008
	Size: 0x96
	Parameters: 0
	Flags: Linked
*/
function function_729f3d20()
{
	level.var_9a2181e2 = struct::get_array("amb_power_surge", "targetname");
	for(i = 0; i < level.var_9a2181e2.size; i++)
	{
		audio::playloopat(level.var_9a2181e2[i].script_sound, level.var_9a2181e2[i].origin);
	}
}

/*
	Name: function_d19cb2f8
	Namespace: zm_cosmodrome_amb
	Checksum: 0x2D3AC81F
	Offset: 0x10A8
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function function_d19cb2f8()
{
	loopers = struct::get_array("exterior_goal", "targetname");
	if(isdefined(loopers) && loopers.size > 0)
	{
		delay = 0;
		/#
			if(getdvarint("") > 0)
			{
				println(("" + loopers.size) + "");
			}
		#/
		for(i = 0; i < loopers.size; i++)
		{
			loopers[i] thread soundloopthink();
			delay = delay + 1;
			if((delay % 20) == 0)
			{
				wait(0.016);
			}
		}
	}
	else
	{
		/#
			println("");
		#/
		if(getdvarint("") > 0)
		{
		}
	}
}

/*
	Name: soundloopthink
	Namespace: zm_cosmodrome_amb
	Checksum: 0x8109C1DE
	Offset: 0x1210
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function soundloopthink()
{
	if(!isdefined(self.origin))
	{
		return;
	}
	if(!isdefined(self.script_sound))
	{
		self.script_sound = "zmb_spawn_walla";
	}
	notifyname = "";
	/#
		assert(isdefined(notifyname));
	#/
	if(isdefined(self.script_string))
	{
		notifyname = self.script_string;
	}
	/#
		assert(isdefined(notifyname));
	#/
	started = 1;
	if(isdefined(self.script_int))
	{
		started = self.script_int != 0;
	}
	if(started)
	{
		soundloopemitter(self.script_sound, self.origin);
	}
	if(notifyname != "")
	{
		for(;;)
		{
			level waittill(notifyname);
			if(started)
			{
				soundstoploopemitter(self.script_sound, self.origin);
			}
			else
			{
				soundloopemitter(self.script_sound, self.origin);
			}
			started = !started;
		}
	}
}

