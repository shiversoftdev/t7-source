// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_theater_amb;

/*
	Name: __init__sytem__
	Namespace: zm_theater_amb
	Checksum: 0x5BD6209
	Offset: 0x278
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_theater_amb", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_theater_amb
	Checksum: 0x3A47970D
	Offset: 0x2B8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "player_dust_mote", 21000, 1, "int", &function_9a4cfd8d, 0, 0);
}

/*
	Name: main
	Namespace: zm_theater_amb
	Checksum: 0x7BD2CC66
	Offset: 0x310
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	thread power_on_all();
	level thread function_c9207335();
}

/*
	Name: power_on_all
	Namespace: zm_theater_amb
	Checksum: 0xA00E73AE
	Offset: 0x348
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function power_on_all()
{
	wait(0.016);
	if(!level clientfield::get("zombie_power_on"))
	{
		level waittill(#"zpo");
	}
	level thread telepad_loop();
	level thread teleport_2d();
	level thread teleport_2d_nopad();
	level thread teleport_beam_fx_2d();
	level thread teleport_specialroom_start();
	level thread teleport_specialroom_go();
	level thread function_24ac75e();
}

/*
	Name: telepad_loop
	Namespace: zm_theater_amb
	Checksum: 0x6CA9990A
	Offset: 0x438
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function telepad_loop()
{
	telepad = struct::get_array("telepad", "targetname");
	array::thread_all(telepad, &teleportation_audio);
}

/*
	Name: teleportation_audio
	Namespace: zm_theater_amb
	Checksum: 0x3282F914
	Offset: 0x498
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function teleportation_audio()
{
	teleport_delay = 2;
	while(true)
	{
		level waittill(#"tpa");
		if(isdefined(self.script_sound))
		{
			playsound(0, ("evt_" + self.script_sound) + "_warmup", self.origin);
			wait(teleport_delay);
			playsound(0, ("evt_" + self.script_sound) + "_cooldown", self.origin);
		}
	}
}

/*
	Name: teleport_2d
	Namespace: zm_theater_amb
	Checksum: 0x206C4E12
	Offset: 0x548
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
	Name: teleport_2d_nopad
	Namespace: zm_theater_amb
	Checksum: 0x75C2A0D0
	Offset: 0x5B0
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function teleport_2d_nopad()
{
	while(true)
	{
		level waittill(#"t2dn");
		playsound(0, "evt_pad_warmup_2d", (0, 0, 0));
		wait(1.3);
		playsound(0, "evt_teleport_2d_fnt", (0, 0, 0));
		playsound(0, "evt_teleport_2d_rear", (0, 0, 0));
	}
}

/*
	Name: teleport_beam_fx_2d
	Namespace: zm_theater_amb
	Checksum: 0x360D298F
	Offset: 0x640
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function teleport_beam_fx_2d()
{
	while(true)
	{
		level waittill(#"t2bfx");
		playsound(0, "evt_beam_fx_2d", (0, 0, 0));
	}
}

/*
	Name: teleport_specialroom_start
	Namespace: zm_theater_amb
	Checksum: 0xD0228348
	Offset: 0x688
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function teleport_specialroom_start()
{
	while(true)
	{
		level waittill(#"tss");
		playsound(0, "evt_pad_warmup_2d", (0, 0, 0));
	}
}

/*
	Name: teleport_specialroom_go
	Namespace: zm_theater_amb
	Checksum: 0xFB472EF0
	Offset: 0x6D0
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function teleport_specialroom_go()
{
	while(true)
	{
		level waittill(#"tsg");
		playsound(0, "evt_teleport_2d_fnt", (0, 0, 0));
		playsound(0, "evt_teleport_2d_rear", (0, 0, 0));
	}
}

/*
	Name: function_c9207335
	Namespace: zm_theater_amb
	Checksum: 0x3E14252C
	Offset: 0x738
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
	Namespace: zm_theater_amb
	Checksum: 0x82A3FED4
	Offset: 0x7B8
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
	Namespace: zm_theater_amb
	Checksum: 0xE85F7801
	Offset: 0x858
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function function_d667714e()
{
	level.var_b6342abd = "mus_theater_underscore_default";
	level.var_6d9d81aa = "mus_theater_underscore_default";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 playloopsound(level.var_b6342abd, 2);
	while(true)
	{
		level waittill(#"hash_51d7bc7c", location);
		level.var_6d9d81aa = "mus_theater_underscore_" + location;
		if(level.var_6d9d81aa != level.var_b6342abd)
		{
			level thread function_b234849(level.var_6d9d81aa);
			level.var_b6342abd = level.var_6d9d81aa;
		}
	}
}

/*
	Name: function_b234849
	Namespace: zm_theater_amb
	Checksum: 0xEFEB6E0F
	Offset: 0x958
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
	Name: function_24ac75e
	Namespace: zm_theater_amb
	Checksum: 0x6600C761
	Offset: 0x9C8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_24ac75e()
{
	audio::playloopat("amb_kino_movie", (-1, 1185, 474));
}

/*
	Name: function_9a4cfd8d
	Namespace: zm_theater_amb
	Checksum: 0xCD376BD1
	Offset: 0xA00
	Size: 0xAE
	Parameters: 7
	Flags: Linked
*/
function function_9a4cfd8d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		self.var_5fb5b46e = playfxoncamera(localclientnum, level._effect["player_dust_motes"]);
	}
	else if(isdefined(self.var_5fb5b46e))
	{
		killfx(localclientnum, self.var_5fb5b46e);
		self.var_5fb5b46e = undefined;
	}
}

