// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\music_shared;
#using scripts\shared\util_shared;

#namespace zm_temple_amb;

/*
	Name: main
	Namespace: zm_temple_amb
	Checksum: 0x31D1FB4F
	Offset: 0x258
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread function_a96d8fc7();
	level thread function_28416c1e();
	level thread function_b11e8fe8();
	level thread wait_for_game_end();
	level thread snd_start_autofx_audio();
	level thread function_d19cb2f8();
	clientfield::register("scriptmover", "meteor_shrink", 21000, 1, "counter", &meteor_shrink, 0, 0);
}

/*
	Name: function_28416c1e
	Namespace: zm_temple_amb
	Checksum: 0x599C5C2A
	Offset: 0x340
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function function_28416c1e()
{
	level waittill(#"drb");
	level notify(#"hash_91064368");
}

/*
	Name: function_a96d8fc7
	Namespace: zm_temple_amb
	Checksum: 0x444C1DA6
	Offset: 0x368
	Size: 0xE
	Parameters: 0
	Flags: Linked
*/
function function_a96d8fc7()
{
	level.var_15e33496 = undefined;
}

/*
	Name: function_418a175a
	Namespace: zm_temple_amb
	Checksum: 0x34DC33DE
	Offset: 0x380
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_418a175a(var_ef677c68)
{
	playsound(0, "evt_sq_gen_transition", (0, 0, 0));
	setsoundcontext("aquifer_cockpit", "active");
	audio::playloopat("evt_sq_gen_bg", (0, 0, 0));
}

/*
	Name: function_e3a6a660
	Namespace: zm_temple_amb
	Checksum: 0xC24A6A0D
	Offset: 0x3F8
	Size: 0x9C
	Parameters: 3
	Flags: Linked
*/
function function_e3a6a660(bnewent, binitialsnap, bwasdemojump)
{
	if(!bnewent && !binitialsnap && !bwasdemojump)
	{
		playsound(0, "evt_sq_gen_transition", (0, 0, 0));
	}
	setsoundcontext("aquifer_cockpit", "");
	audio::stoploopat("evt_sq_gen_bg", (0, 0, 0));
}

/*
	Name: function_b11e8fe8
	Namespace: zm_temple_amb
	Checksum: 0xD232CC20
	Offset: 0x4A0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_b11e8fe8()
{
	level thread function_e2433f87(0);
	level thread function_e2433f87(1);
}

/*
	Name: function_e2433f87
	Namespace: zm_temple_amb
	Checksum: 0x80B4F551
	Offset: 0x4E0
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function function_e2433f87(num)
{
	while(true)
	{
		level waittill("ge" + num);
		level notify("evt_geyser_blast_" + num);
		wait(14.5);
		level notify("evt_geyser_blast_" + num);
	}
}

/*
	Name: meteor_shrink
	Namespace: zm_temple_amb
	Checksum: 0x737D4442
	Offset: 0x540
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function meteor_shrink(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	audio::snd_set_snapshot("zmb_temple_egg");
	level thread function_762642a6();
}

/*
	Name: function_762642a6
	Namespace: zm_temple_amb
	Checksum: 0xEEB455C4
	Offset: 0x5B8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_762642a6()
{
	wait(5.5);
	if(isdefined(level.var_15e33496))
	{
		audio::snd_set_snapshot("zmb_temple_sq");
	}
	else
	{
		audio::snd_set_snapshot("default");
	}
}

/*
	Name: wait_for_game_end
	Namespace: zm_temple_amb
	Checksum: 0x99A42B81
	Offset: 0x618
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function wait_for_game_end()
{
	level waittill(#"zesn");
	audio::snd_set_snapshot("zmb_temple_egg");
}

/*
	Name: snd_start_autofx_audio
	Namespace: zm_temple_amb
	Checksum: 0x7F6162AF
	Offset: 0x650
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function snd_start_autofx_audio()
{
	audio::snd_play_auto_fx("fx_ztem_torch", "amb_fire_medium");
}

/*
	Name: function_60a32834
	Namespace: zm_temple_amb
	Checksum: 0xE6879B3D
	Offset: 0x680
	Size: 0x94
	Parameters: 0
	Flags: None
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
	Namespace: zm_temple_amb
	Checksum: 0x9BEEA0CE
	Offset: 0x720
	Size: 0xF8
	Parameters: 0
	Flags: None
*/
function function_d667714e()
{
	level.var_b6342abd = "mus_temple_underscore_default";
	level.var_6d9d81aa = "mus_temple_underscore_default";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 playloopsound(level.var_b6342abd, 2);
	while(true)
	{
		level waittill(#"hash_51d7bc7c", location);
		level.var_6d9d81aa = "mus_temple_underscore_" + location;
		if(level.var_6d9d81aa != level.var_b6342abd)
		{
			level thread function_b234849(level.var_6d9d81aa);
			level.var_b6342abd = level.var_6d9d81aa;
		}
	}
}

/*
	Name: function_b234849
	Namespace: zm_temple_amb
	Checksum: 0x602551BA
	Offset: 0x820
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
	Name: function_d19cb2f8
	Namespace: zm_temple_amb
	Checksum: 0x1B4285B8
	Offset: 0x890
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
	Namespace: zm_temple_amb
	Checksum: 0x88D1E5A3
	Offset: 0x9F8
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

