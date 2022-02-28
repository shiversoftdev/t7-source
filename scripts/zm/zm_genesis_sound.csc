// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_genesis_sound;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_sound
	Checksum: 0x7607E26C
	Offset: 0x240
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_sound", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_sound
	Checksum: 0x75AFE19E
	Offset: 0x280
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level thread function_bab3ea62();
	level thread function_849aa028();
	level thread play_generator();
	level thread function_37010187();
}

/*
	Name: function_bab3ea62
	Namespace: zm_genesis_sound
	Checksum: 0x56DDFB18
	Offset: 0x2F0
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_bab3ea62()
{
	wait(3);
	level thread function_53b9afad();
	level thread function_c959aa5f();
	var_29085ef = getentarray(0, "sndMusicTrig", "targetname");
	array::thread_all(var_29085ef, &sndmusictrig);
}

/*
	Name: sndmusictrig
	Namespace: zm_genesis_sound
	Checksum: 0xFF495FB2
	Offset: 0x388
	Size: 0xC4
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
			if(self.script_sound == "pavlov")
			{
				level notify(#"hash_51d7bc7c", level.var_98f2b64e);
			}
			else
			{
				level notify(#"hash_51d7bc7c", self.script_sound);
			}
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
	Namespace: zm_genesis_sound
	Checksum: 0x860128DE
	Offset: 0x458
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function function_53b9afad()
{
	level.var_b6342abd = "mus_genesis_underscore_default";
	level.var_6d9d81aa = "mus_genesis_underscore_default";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 playloopsound(level.var_b6342abd, 2);
	while(true)
	{
		level waittill(#"hash_51d7bc7c", location);
		level.var_6d9d81aa = "mus_genesis_underscore_" + location;
		if(level.var_6d9d81aa != level.var_b6342abd)
		{
			level thread function_51d7bc7c(level.var_6d9d81aa);
			level.var_b6342abd = level.var_6d9d81aa;
		}
	}
}

/*
	Name: function_51d7bc7c
	Namespace: zm_genesis_sound
	Checksum: 0xAAAC21E1
	Offset: 0x558
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

/*
	Name: function_c959aa5f
	Namespace: zm_genesis_sound
	Checksum: 0x20F86463
	Offset: 0x5C8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_c959aa5f()
{
	level waittill(#"zesn");
	level notify(#"stpthm");
	if(isdefined(level.var_eb526c90))
	{
		level.var_eb526c90 stopallloopsounds(2);
	}
}

/*
	Name: function_849aa028
	Namespace: zm_genesis_sound
	Checksum: 0xE86CEC22
	Offset: 0x620
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_849aa028()
{
	level.var_6191a71d = undefined;
	level.var_232ff65c = 0;
	level.var_f860f73b = 1;
	level thread function_899d68c0();
	var_29085ef = getentarray(0, "sndMusicTrig", "targetname");
	array::thread_all(var_29085ef, &function_ad9a8fa6);
}

/*
	Name: function_ad9a8fa6
	Namespace: zm_genesis_sound
	Checksum: 0x83D160AC
	Offset: 0x6C0
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function function_ad9a8fa6()
{
	level endon("musThemeTriggered" + self.script_sound);
	while(true)
	{
		self waittill(#"trigger", trigplayer);
		if(self.script_sound == "default" && (!(isdefined(level.var_232ff65c) && level.var_232ff65c)))
		{
			continue;
		}
		if(isdefined(level.var_6191a71d))
		{
			continue;
		}
		if(!(isdefined(level.var_f860f73b) && level.var_f860f73b))
		{
			continue;
		}
		if(trigplayer islocalplayer())
		{
			level thread function_1401492e(trigplayer, self.script_sound);
			level.var_232ff65c = 1;
			level notify("musThemeTriggered" + self.script_sound);
			return;
		}
	}
}

/*
	Name: function_1401492e
	Namespace: zm_genesis_sound
	Checksum: 0x51467EF2
	Offset: 0x7C0
	Size: 0x6A
	Parameters: 2
	Flags: Linked
*/
function function_1401492e(trigplayer, location)
{
	level endon(#"stpthm");
	alias = "mus_genesis_entrytheme_" + location;
	level.var_6191a71d = playsound(0, alias, (0, 0, 0));
	wait(90);
	level.var_6191a71d = undefined;
}

/*
	Name: function_899d68c0
	Namespace: zm_genesis_sound
	Checksum: 0x249BF102
	Offset: 0x838
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_899d68c0()
{
	while(true)
	{
		level waittill(#"stpthm");
		if(isdefined(level.var_6191a71d))
		{
			stopsound(level.var_6191a71d);
			level.var_6191a71d = undefined;
		}
		level.var_f860f73b = 0;
		level waittill(#"strtthm");
		level.var_f860f73b = 1;
	}
}

/*
	Name: play_generator
	Namespace: zm_genesis_sound
	Checksum: 0xA7A1CB4E
	Offset: 0x8B0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function play_generator()
{
	audio::playloopat("amb_gen_arc_loop", (5014, -1169, 429));
}

/*
	Name: function_37010187
	Namespace: zm_genesis_sound
	Checksum: 0xFF1DEC77
	Offset: 0x8E8
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function function_37010187()
{
	while(true)
	{
		wait(randomintrange(2, 6));
		playsound(0, "amb_comp_sweets", (4737, -1043, 424));
	}
}

