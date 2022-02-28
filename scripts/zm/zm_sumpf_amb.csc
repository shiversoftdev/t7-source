// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\music_shared;
#using scripts\shared\util_shared;

#namespace zm_sumpf_amb;

/*
	Name: main
	Namespace: zm_sumpf_amb
	Checksum: 0x727516F6
	Offset: 0x248
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	thread play_meteor_loop();
	level thread function_d19cb2f8();
}

/*
	Name: play_meteor_loop
	Namespace: zm_sumpf_amb
	Checksum: 0xA36713C8
	Offset: 0x280
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function play_meteor_loop()
{
	meteor = audio::playloopat("amb_meteor_loop", (11264, -1920, -592));
}

/*
	Name: start_lights
	Namespace: zm_sumpf_amb
	Checksum: 0x52C171FC
	Offset: 0x2C0
	Size: 0x130
	Parameters: 0
	Flags: None
*/
function start_lights()
{
	level waittill(#"start_lights");
	wait(2);
	array::thread_all(struct::get_array("electrical_circuit", "targetname"), &circuit_sound);
	playsound(0, "zmb_turn_on", (0, 0, 0));
	wait(3);
	array::thread_all(struct::get_array("electrical_surge", "targetname"), &light_sound);
	array::thread_all(struct::get_array("low_buzz", "targetname"), &buzz_sound);
	playertrack = audio::playloopat("player_ambience", (0, 0, 0));
}

/*
	Name: light_sound
	Namespace: zm_sumpf_amb
	Checksum: 0x26F5CAAA
	Offset: 0x3F8
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function light_sound()
{
	wait(randomfloatrange(1, 4));
	playsound(0, "evt_electrical_surge", self.origin);
	playfx(0, level._effect["electric_short_oneshot"], self.origin);
	wait(randomfloatrange(1, 2));
	e1 = audio::playloopat("light", self.origin);
	self run_sparks_loop();
}

/*
	Name: run_sparks_loop
	Namespace: zm_sumpf_amb
	Checksum: 0xB636D4AE
	Offset: 0x4D0
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function run_sparks_loop()
{
	while(true)
	{
		wait(randomfloatrange(4, 15));
		if(randomfloatrange(0, 1) < 0.5)
		{
			playfx(0, level._effect["electric_short_oneshot"], self.origin);
			playsound(0, "evt_electrical_surge", self.origin);
		}
		wait(randomintrange(1, 4));
	}
}

/*
	Name: circuit_sound
	Namespace: zm_sumpf_amb
	Checksum: 0xCB0AECCD
	Offset: 0x590
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function circuit_sound()
{
	wait(1);
	playsound(0, "circuit", self.origin);
}

/*
	Name: buzz_sound
	Namespace: zm_sumpf_amb
	Checksum: 0x1F20FE22
	Offset: 0x5C8
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function buzz_sound()
{
	lowbuzz = audio::playloopat("low_arc", self.origin);
}

/*
	Name: function_c9207335
	Namespace: zm_sumpf_amb
	Checksum: 0xF21471DA
	Offset: 0x600
	Size: 0x74
	Parameters: 0
	Flags: None
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
	Namespace: zm_sumpf_amb
	Checksum: 0x55CDA395
	Offset: 0x680
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
	Namespace: zm_sumpf_amb
	Checksum: 0x2E908DC5
	Offset: 0x720
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function function_d667714e()
{
	level.var_b6342abd = "mus_sumpf_underscore_default";
	level.var_6d9d81aa = "mus_sumpf_underscore_default";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 playloopsound(level.var_b6342abd, 2);
	while(true)
	{
		level waittill(#"hash_51d7bc7c", location);
		level.var_6d9d81aa = "mus_sumpf_underscore_" + location;
		if(level.var_6d9d81aa != level.var_b6342abd)
		{
			level thread function_b234849(level.var_6d9d81aa);
			level.var_b6342abd = level.var_6d9d81aa;
		}
	}
}

/*
	Name: function_b234849
	Namespace: zm_sumpf_amb
	Checksum: 0xF20F6D7
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
	Namespace: zm_sumpf_amb
	Checksum: 0x5CF78C34
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
	Namespace: zm_sumpf_amb
	Checksum: 0xE3CAD9AE
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

