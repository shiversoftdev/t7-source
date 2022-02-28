// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_radio;

/*
	Name: __init__sytem__
	Namespace: zm_radio
	Checksum: 0x8EF60FCF
	Offset: 0x3B8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_radio", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_radio
	Checksum: 0x99EC1590
	Offset: 0x400
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

/*
	Name: __main__
	Namespace: zm_radio
	Checksum: 0x40DD47
	Offset: 0x410
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level.n_radio_index = -1;
	str_name = "kzmb";
	str_key = "targetname";
	if(isdefined(level.var_f3b142b3))
	{
		str_name = level.var_f3b142b3;
	}
	if(isdefined(level.kzmb_key))
	{
		key = level.kzmb_key;
	}
	var_903fae71 = getentarray(str_name, str_key);
	if(!isdefined(var_903fae71) || !var_903fae71.size)
	{
		/#
			println("");
		#/
		return;
	}
	/#
		println("" + var_903fae71.size);
	#/
	array::thread_all(var_903fae71, &function_8554d5da);
}

/*
	Name: function_8554d5da
	Namespace: zm_radio
	Checksum: 0x3D78D7B6
	Offset: 0x530
	Size: 0x172
	Parameters: 0
	Flags: Linked
*/
function function_8554d5da()
{
	self setcandamage(1);
	level thread function_4b776d12();
	self thread function_2d4f4459();
	self thread function_f184004e();
	while(true)
	{
		self waittill(#"damage", damage, attacker, dir, loc, type, model, tag, part, weapon, flags);
		if(!isdefined(attacker) || !isplayer(attacker))
		{
			continue;
		}
		if(type == "MOD_PROJECTILE")
		{
			continue;
		}
		if(type == "MOD_MELEE" || type == "MOD_GRENADE_SPLASH")
		{
			self notify(#"hash_dec13539");
		}
		else
		{
			self notify(#"hash_34d24635");
		}
	}
}

/*
	Name: function_2d4f4459
	Namespace: zm_radio
	Checksum: 0x7379BDDA
	Offset: 0x6B0
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function function_2d4f4459()
{
	self.trackname = undefined;
	self.tracknum = 0;
	while(true)
	{
		self waittill(#"hash_34d24635");
		if(isdefined(self.var_175c09e5))
		{
			self stopsound(self.var_175c09e5);
			wait(0.05);
		}
		self playsoundwithnotify("zmb_musicradio_switch", "sounddone");
		self waittill(#"sounddone");
		self thread function_c62f1c37();
	}
}

/*
	Name: function_c62f1c37
	Namespace: zm_radio
	Checksum: 0xBF1D032C
	Offset: 0x760
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function function_c62f1c37()
{
	self endon(#"hash_34d24635");
	self endon(#"hash_dec13539");
	self playsoundwithnotify(level.var_2ec01df2[self.tracknum], "songdone");
	self.var_175c09e5 = level.var_2ec01df2[self.tracknum];
	self.tracknum++;
	if(self.tracknum >= level.var_2ec01df2.size)
	{
		self.tracknum = 0;
	}
	self waittill(#"songdone");
	self notify(#"hash_34d24635");
}

/*
	Name: function_f184004e
	Namespace: zm_radio
	Checksum: 0x8931F149
	Offset: 0x808
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function function_f184004e()
{
	while(true)
	{
		self waittill(#"hash_dec13539");
		self playsoundwithnotify("zmb_musicradio_off", "sounddone");
		if(isdefined(self.var_175c09e5))
		{
			self stopsound(self.var_175c09e5);
		}
	}
}

/*
	Name: function_4b776d12
	Namespace: zm_radio
	Checksum: 0xE70A5F9F
	Offset: 0x878
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function function_4b776d12()
{
	level.var_2ec01df2 = array("mus_radio_track_1", "mus_radio_track_2", "mus_radio_track_3", "mus_radio_track_4", "mus_radio_track_5", "mus_radio_track_6", "mus_radio_track_7", "mus_radio_track_8", "mus_radio_track_9", "mus_radio_track_10", "mus_radio_track_11", "mus_radio_track_12", "mus_radio_track_13", "mus_radio_track_14", "mus_radio_track_15", "mus_radio_track_16", "mus_radio_track_17", "mus_radio_track_18", "mus_radio_track_19", "mus_radio_track_20", "mus_radio_track_21", "mus_radio_track_22", "mus_radio_track_23", "mus_radio_track_24", "mus_radio_track_25", "mus_radio_track_26", "mus_radio_track_27", "mus_radio_track_28", "mus_radio_track_29", "mus_radio_track_30", "mus_radio_track_31");
}

