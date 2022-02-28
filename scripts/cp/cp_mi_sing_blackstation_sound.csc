// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;

#namespace cp_mi_sing_blackstation_sound;

/*
	Name: main
	Namespace: cp_mi_sing_blackstation_sound
	Checksum: 0x6DFC0B30
	Offset: 0x2C8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread function_87c8026c();
	level thread function_ca589ae4();
	clientfield::register("toplayer", "slowmo_duck_active", 1, 2, "int", &function_41d671f5, 0, 0);
}

/*
	Name: sndwindsystem
	Namespace: cp_mi_sing_blackstation_sound
	Checksum: 0xD1F983D0
	Offset: 0x350
	Size: 0x27A
	Parameters: 7
	Flags: Linked
*/
function sndwindsystem(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(!isdefined(self.soundid1))
		{
			self stopallloopsounds();
			self.soundid1 = self playloopsound("amb_scripted_wind_normal", 2);
			setsoundvolume(self.soundid1, 1);
			setsoundvolumerate(self.soundid1, 0.5);
		}
		if(!isdefined(self.soundid2))
		{
			self.soundid2 = self playloopsound("amb_scripted_wind_heavy", 2);
			setsoundvolume(self.soundid2, 0);
			setsoundvolumerate(self.soundid2, 0.5);
		}
		self thread function_d84ed3d1();
		switch(newval)
		{
			case 1:
			{
				setsoundvolume(self.soundid1, 1);
				setsoundvolume(self.soundid2, 0);
				audio::snd_set_snapshot("default");
				break;
			}
			case 2:
			{
				setsoundvolume(self.soundid1, 0.5);
				setsoundvolume(self.soundid2, 1);
				audio::snd_set_snapshot("cp_blackstation_scripted_wind");
				break;
			}
		}
	}
	else
	{
		self notify(#"hash_450e1742");
		self stopallloopsounds();
		if(isdefined(self.soundid1))
		{
			self.soundid1 = undefined;
		}
		if(isdefined(self.soundid2))
		{
			self.soundid2 = undefined;
		}
	}
}

/*
	Name: function_d84ed3d1
	Namespace: cp_mi_sing_blackstation_sound
	Checksum: 0x59984D
	Offset: 0x5D8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_d84ed3d1()
{
	self notify(#"hash_d84ed3d1");
	self endon(#"hash_d84ed3d1");
	self endon(#"hash_450e1742");
	self waittill(#"entityshutdown");
	if(isdefined(self))
	{
		self stopallloopsounds();
	}
}

/*
	Name: function_87c8026c
	Namespace: cp_mi_sing_blackstation_sound
	Checksum: 0x16549F41
	Offset: 0x638
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_87c8026c()
{
	soundloopemitter("evt_barge_wave_looper", (1193, -8283, 193));
}

/*
	Name: function_ca589ae4
	Namespace: cp_mi_sing_blackstation_sound
	Checksum: 0x1B8A0CE7
	Offset: 0x670
	Size: 0x504
	Parameters: 0
	Flags: Linked
*/
function function_ca589ae4()
{
	audio::playloopat("amb_glass_shake_loop", (-8446, 10255, 419));
	audio::playloopat("amb_glass_shake_loop", (-9941, 11040, 452));
	audio::playloopat("amb_rain_on_windows", (-8347, 10197, 369));
	audio::playloopat("amb_wind_blend", (-8422, 9652, 382));
	audio::playloopat("amb_wind_blend", (-8161, 9575, 435));
	audio::playloopat("amb_subway_light", (-5813, 5559, 285));
	audio::playloopat("amb_subway_light", (-5509, 4875, 123));
	audio::playloopat("amb_subway_light", (-6675, 4978, 158));
	audio::playloopat("amb_subway_light", (3167, -3813, 126));
	audio::playloopat("amb_subway_light", (3497, -3427, 124));
	audio::playloopat("amb_river_debris", (-9133, 9903, 192));
	audio::playloopat("amb_river_debris", (-6101, 9777, 61));
	audio::playloopat("amb_wind_whistle_loud_right", (-8291, 9671, 378));
	audio::playloopat("amb_subway_light", (-7624, 9896, 406));
	audio::playloopat("amb_rain_on_concrete", (-6483, 6114, 550));
	audio::playloopat("amb_rain_on_concrete", (-6478, 6181, 551));
	audio::playloopat("amb_rain_on_concrete", (-6477, 6230, 548));
	audio::playloopat("amb_wind_whistle_left", (4552, 820, 695));
	audio::playloopat("amb_metal_debris_shake", (5238, 710, 699));
	audio::playloopat("amb_rain_on_concrete", (4698, 917, 656));
	audio::playloopat("amb_rain_on_concrete", (4767, 823, 632));
	audio::playloopat("amb_rain_on_concrete", (4871, 802, 636));
	audio::playloopat("amb_rain_on_concrete", (4659, 860, 663));
	audio::playloopat("amb_rain_on_metal_debris", (5075, 733, 650));
	audio::playloopat("amb_buoy", (436, -4077, 119));
	audio::playloopat("amb_sea_distant", (166, -3692, 177));
	audio::playloopat("amb_subway_light", (-1409, 10106, 395));
	audio::playloopat("amb_subway_light", (-1306, 9830, 19));
	audio::playloopat("amb_subway_light", (-1547, 10060, 19));
	audio::playloopat("amb_subway_light", (-288, 9298, 21));
	audio::playloopat("amb_subway_light", (-1058, 9718, 171));
	audio::playloopat("amb_subway_light", (-571, 9460, 30));
}

/*
	Name: function_fb96c813
	Namespace: cp_mi_sing_blackstation_sound
	Checksum: 0xD954F333
	Offset: 0xB80
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function function_fb96c813(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		audio::playloopat("amb_station_walla", (-4172, 4988, 40));
	}
	else
	{
		audio::stoploopat("amb_station_walla", (-4172, 4988, 40));
	}
}

/*
	Name: function_c6d82f9d
	Namespace: cp_mi_sing_blackstation_sound
	Checksum: 0x646F98CE
	Offset: 0xC20
	Size: 0x12C
	Parameters: 7
	Flags: Linked
*/
function function_c6d82f9d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	audio::playloopat("amb_computer_error", (84, 9455, 140));
	audio::playloopat("amb_computer_error", (-950, 1088, 220));
	audio::playloopat("amb_computer_error", (-1351, 9976, 220));
	audio::playloopat("amb_computer_future", (-672, 9640, 216));
	audio::playloopat("amb_computer_future", (-1136, 9630, 200));
	audio::playloopat("amb_computer_future", (-783, 9675, 220));
}

/*
	Name: function_598a3b92
	Namespace: cp_mi_sing_blackstation_sound
	Checksum: 0x608C6E71
	Offset: 0xD58
	Size: 0x47C
	Parameters: 7
	Flags: Linked
*/
function function_598a3b92(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		audio::stoploopat("amb_glass_shake_loop", (-8446, 10255, 419));
		audio::stoploopat("amb_glass_shake_loop", (-9941, 11040, 452));
		audio::stoploopat("amb_rain_on_windows", (-8347, 10197, 369));
		audio::stoploopat("amb_wind_blend", (-8422, 9652, 382));
		audio::stoploopat("amb_wind_blend", (-8161, 9575, 435));
		audio::stoploopat("amb_subway_light", (-5813, 5559, 285));
		audio::stoploopat("amb_subway_light", (-5509, 4875, 123));
		audio::stoploopat("amb_subway_light", (-6675, 4978, 158));
		audio::stoploopat("amb_subway_light", (3167, -3813, 126));
		audio::stoploopat("amb_subway_light", (3497, -3427, 124));
		audio::stoploopat("amb_river_debris", (-9133, 9903, 192));
		audio::stoploopat("amb_river_debris", (-6101, 9777, 61));
		audio::stoploopat("amb_wind_whistle_loud_right", (-8291, 9671, 378));
		audio::stoploopat("amb_subway_light", (-7624, 9896, 406));
		audio::stoploopat("amb_rain_on_concrete", (-6483, 6114, 550));
		audio::stoploopat("amb_rain_on_concrete", (-6478, 6181, 551));
		audio::stoploopat("amb_rain_on_concrete", (-6477, 6230, 548));
		audio::stoploopat("amb_computer_error", (84, 9455, 140));
		audio::stoploopat("amb_computer_error", (-950, 1088, 220));
		audio::stoploopat("amb_computer_error", (-1351, 9976, 220));
		audio::stoploopat("amb_computer_future", (-672, 9640, 216));
		audio::stoploopat("amb_computer_future", (-1136, 9630, 200));
		audio::stoploopat("amb_computer_future", (-783, 9675, 220));
		audio::playloopat("amb_drill_walla", (-968, 9589, 380));
		audio::playloopat("evt_drilling", (-968, 9589, 380));
	}
	else
	{
		audio::stoploopat("amb_drill_walla", (-968, 9589, 380));
		audio::stoploopat("evt_drilling", (-968, 9589, 380));
	}
}

/*
	Name: function_41d671f5
	Namespace: cp_mi_sing_blackstation_sound
	Checksum: 0x34DD995
	Offset: 0x11E0
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_41d671f5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval > 0)
	{
		audio::snd_set_snapshot("cp_barge_slowtime");
	}
	else
	{
		audio::snd_set_snapshot("default");
	}
}

