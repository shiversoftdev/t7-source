// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;

#namespace cp_mi_zurich_newworld_sound;

/*
	Name: main
	Namespace: cp_mi_zurich_newworld_sound
	Checksum: 0x4F54B8DD
	Offset: 0x158
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread function_9f9f219();
	level thread function_cfd80c1b();
	level thread function_166fca02();
	level thread function_694458bd();
}

/*
	Name: function_9f9f219
	Namespace: cp_mi_zurich_newworld_sound
	Checksum: 0x853C4AE
	Offset: 0x1C8
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_9f9f219()
{
	trigger = getent(0, "security_det", "targetname");
	if(!isdefined(trigger))
	{
		return;
	}
	while(true)
	{
		trigger waittill(#"trigger", who);
		if(who isplayer())
		{
			playsound(0, "amb_security_detector", (-10363, -24283, 9450));
			break;
		}
	}
}

/*
	Name: function_cfd80c1b
	Namespace: cp_mi_zurich_newworld_sound
	Checksum: 0x436033A7
	Offset: 0x288
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_cfd80c1b()
{
	trigger = getent(0, "horn", "targetname");
	if(!isdefined(trigger))
	{
		return;
	}
	while(true)
	{
		trigger waittill(#"trigger", who);
		if(who isplayer())
		{
			playsound(0, "amb_train_horn_distant", (21054, -3421, -6031));
			break;
		}
	}
}

/*
	Name: function_166fca02
	Namespace: cp_mi_zurich_newworld_sound
	Checksum: 0x917A0B21
	Offset: 0x348
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_166fca02()
{
	trigger = getent(0, "train_horn_dist", "targetname");
	if(!isdefined(trigger))
	{
		return;
	}
	while(true)
	{
		trigger waittill(#"trigger", who);
		if(who isplayer())
		{
			playsound(0, "amb_train_horn_distant", (-13099, -18453, 10228));
			break;
		}
	}
}

/*
	Name: function_694458bd
	Namespace: cp_mi_zurich_newworld_sound
	Checksum: 0xD5AA6127
	Offset: 0x408
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_694458bd()
{
	soundloopemitter("amb_wind_tarp", (-17754, 15606, 4288));
	soundloopemitter("amb_wind_door", (-12556, 15887, 4201));
	soundloopemitter("amb_wind_door", (-12164, 15338, 4207));
	soundloopemitter("anb_snow_plow", (-14268, 15963, 4248));
	soundloopemitter("anb_snow_plow", (-14281, 15331, 4235));
}

/*
	Name: function_98d2df25
	Namespace: cp_mi_zurich_newworld_sound
	Checksum: 0x48B38D9F
	Offset: 0x4E0
	Size: 0xC8
	Parameters: 7
	Flags: Linked
*/
function function_98d2df25(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		setsoundcontext("train", "country");
	}
	else
	{
		if(newval == 2)
		{
			setsoundcontext("train", "city");
			return;
		}
		else
		{
			setsoundcontext("train", "tunnel");
			return;
		}
	}
}

