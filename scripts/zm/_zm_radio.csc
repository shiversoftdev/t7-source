// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zm_radio;

/*
	Name: __init__sytem__
	Namespace: zm_radio
	Checksum: 0xCCC2054C
	Offset: 0xC0
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
	Offset: 0x108
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
	Checksum: 0x99EC1590
	Offset: 0x118
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
}

/*
	Name: next_song
	Namespace: zm_radio
	Checksum: 0xAB6375A6
	Offset: 0x128
	Size: 0x204
	Parameters: 7
	Flags: Linked
*/
function next_song(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	/#
		assert(isdefined(level.var_f3006fa7));
	#/
	/#
		assert(isdefined(level.var_c017e2d5));
	#/
	/#
		assert(isdefined(level.n_radio_index));
	#/
	/#
		assert(level.var_c017e2d5.size > 0);
	#/
	if(!isdefined(level.var_58522184))
	{
		level.var_58522184 = 0;
	}
	if(!level.var_58522184)
	{
		if(newval)
		{
			playsound(0, "static", self.origin);
			if(soundplaying(level.var_f3006fa7))
			{
				fade(level.var_f3006fa7, 1);
			}
			else
			{
				wait(0.5);
			}
			if(level.n_radio_index < level.var_c017e2d5.size)
			{
				/#
					println("" + level.var_c017e2d5[level.n_radio_index]);
				#/
				level.var_f3006fa7 = playsound(0, level.var_c017e2d5[level.n_radio_index], self.origin);
			}
			else
			{
				return;
			}
		}
	}
	else if(isdefined(level.var_f3006fa7))
	{
		stopsound(level.var_f3006fa7);
	}
}

/*
	Name: add_song
	Namespace: zm_radio
	Checksum: 0xE934308A
	Offset: 0x338
	Size: 0x3A
	Parameters: 1
	Flags: None
*/
function add_song(song)
{
	if(!isdefined(level.var_c017e2d5))
	{
		level.var_c017e2d5 = [];
	}
	level.var_c017e2d5[level.var_c017e2d5.size] = song;
}

/*
	Name: function_2b7f281d
	Namespace: zm_radio
	Checksum: 0x4889CDD6
	Offset: 0x380
	Size: 0x68
	Parameters: 7
	Flags: None
*/
function function_2b7f281d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	/#
		assert(isdefined(level.n_radio_index));
	#/
	level.n_radio_index = newval;
}

/*
	Name: fade
	Namespace: zm_radio
	Checksum: 0x242E17DE
	Offset: 0x3F0
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function fade(n_id, n_time)
{
	n_rate = 0;
	if(n_time != 0)
	{
		n_rate = 1 / n_time;
	}
	setsoundvolumerate(n_id, n_rate);
	setsoundvolume(n_id, 0);
	wait(n_time);
	stopsound(n_id);
}

/*
	Name: stop_radio_listener
	Namespace: zm_radio
	Checksum: 0x930D9791
	Offset: 0x498
	Size: 0x60
	Parameters: 0
	Flags: None
*/
function stop_radio_listener()
{
	while(true)
	{
		level waittill(#"ktr");
		level.var_58522184 = 1;
		level thread next_song();
		level waittill(#"rrd");
		level.var_58522184 = 0;
		wait(0.5);
	}
}

