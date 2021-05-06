// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace zm_zod_amb;

/*
	Name: main
	Namespace: zm_zod_amb
	Checksum: 0x93CA3E02
	Offset: 0x1D0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread function_bab3ea62();
}

/*
	Name: function_bab3ea62
	Namespace: zm_zod_amb
	Checksum: 0x9B5E5B47
	Offset: 0x1F8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_bab3ea62()
{
	level thread function_53b9afad();
	var_29085ef = getentarray(0, "sndMusicTrig", "targetname");
	array::thread_all(var_29085ef, &sndmusictrig);
}

/*
	Name: sndmusictrig
	Namespace: zm_zod_amb
	Checksum: 0xB9F418FE
	Offset: 0x278
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
	Namespace: zm_zod_amb
	Checksum: 0x64BBB2D
	Offset: 0x318
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function function_53b9afad()
{
	var_b6342abd = "mus_zod_underscore_default";
	var_6d9d81aa = "mus_zod_underscore_default";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 playloopsound(var_b6342abd, 2);
	while(true)
	{
		level waittill(#"hash_51d7bc7c", location);
		var_6d9d81aa = "mus_zod_underscore_" + location;
		if(var_6d9d81aa != var_b6342abd)
		{
			level thread function_51d7bc7c(var_6d9d81aa);
			var_b6342abd = var_6d9d81aa;
		}
	}
}

/*
	Name: function_51d7bc7c
	Namespace: zm_zod_amb
	Checksum: 0xE9EF3E6D
	Offset: 0x408
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

