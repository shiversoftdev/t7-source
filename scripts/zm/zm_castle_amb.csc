// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace zm_castle_amb;

/*
	Name: main
	Namespace: zm_castle_amb
	Checksum: 0x8A20538A
	Offset: 0x238
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	thread function_d19cb2f8();
	thread function_163d3651();
	thread function_509ffc62();
	level thread function_bab3ea62();
}

/*
	Name: function_d19cb2f8
	Namespace: zm_castle_amb
	Checksum: 0x793F76CD
	Offset: 0x290
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
	Namespace: zm_castle_amb
	Checksum: 0x54ED277A
	Offset: 0x3F8
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

/*
	Name: function_163d3651
	Namespace: zm_castle_amb
	Checksum: 0x97737954
	Offset: 0x570
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_163d3651()
{
	soundloopemitter("zmb_spawn_undercroft_walla", (-508, 1615, 110));
	soundloopemitter("zmb_spawn_undercroft_walla", (607, 2189, 162));
	soundloopemitter("zmb_spawn_undercroft_walla", (-1771, 1924, 235));
	soundloopemitter("zmb_spawn_undercroft_walla", (-1730, 2565, 227));
	soundloopemitter("zmb_spawn_undercroft_walla", (-828, 2911, 261));
}

/*
	Name: function_509ffc62
	Namespace: zm_castle_amb
	Checksum: 0x32C06AA6
	Offset: 0x648
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_509ffc62()
{
	soundloopemitter("amb_radio_2", (-1080, 1625, 856));
	soundloopemitter("amb_radio_beep", (-1006, 1578, 856));
	soundloopemitter("amb_radio_3", (-1365, 1332, 856));
}

/*
	Name: function_bab3ea62
	Namespace: zm_castle_amb
	Checksum: 0x853C7F2A
	Offset: 0x6D0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_bab3ea62()
{
	wait(3);
	level thread function_53b9afad();
	var_29085ef = getentarray(0, "sndMusicTrig", "targetname");
	array::thread_all(var_29085ef, &sndmusictrig);
}

/*
	Name: sndmusictrig
	Namespace: zm_castle_amb
	Checksum: 0xA4F71712
	Offset: 0x750
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function sndmusictrig()
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
	Name: function_53b9afad
	Namespace: zm_castle_amb
	Checksum: 0x766FDE2D
	Offset: 0x7F0
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function function_53b9afad()
{
	var_b6342abd = "mus_castle_underscore_gondola";
	var_6d9d81aa = "mus_castle_underscore_gondola";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 playloopsound(var_b6342abd, 2);
	while(true)
	{
		level waittill(#"hash_51d7bc7c", location);
		var_6d9d81aa = "mus_castle_underscore_" + location;
		if(var_6d9d81aa != var_b6342abd)
		{
			level thread function_51d7bc7c(var_6d9d81aa);
			var_b6342abd = var_6d9d81aa;
		}
	}
}

/*
	Name: function_51d7bc7c
	Namespace: zm_castle_amb
	Checksum: 0xC60DC07C
	Offset: 0x8E0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_51d7bc7c(var_6d9d81aa)
{
	level endon(#"hash_51d7bc7c");
	level.var_eb526c90 stopallloopsounds(2);
	wait(1);
	level.var_9433cf5a = level.var_eb526c90 playloopsound(var_6d9d81aa, 2);
}

