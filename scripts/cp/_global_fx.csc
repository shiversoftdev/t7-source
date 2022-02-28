// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;

#namespace global_fx;

/*
	Name: __init__sytem__
	Namespace: global_fx
	Checksum: 0xCD7F408A
	Offset: 0x150
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("global_fx", &__init__, &main, undefined);
}

/*
	Name: __init__
	Namespace: global_fx
	Checksum: 0x5F3548F0
	Offset: 0x198
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	wind_initial_setting();
}

/*
	Name: main
	Namespace: global_fx
	Checksum: 0x39559E9A
	Offset: 0x1B8
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function main()
{
	check_for_wind_override();
}

/*
	Name: wind_initial_setting
	Namespace: global_fx
	Checksum: 0x5F48EAD0
	Offset: 0x1D8
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function wind_initial_setting()
{
	setsaveddvar("enable_global_wind", 0);
	setsaveddvar("wind_global_vector", "0 0 0");
	setsaveddvar("wind_global_low_altitude", 0);
	setsaveddvar("wind_global_hi_altitude", 10000);
	setsaveddvar("wind_global_low_strength_percent", 0.5);
}

/*
	Name: check_for_wind_override
	Namespace: global_fx
	Checksum: 0x1F211F57
	Offset: 0x278
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function check_for_wind_override()
{
	if(isdefined(level.custom_wind_callback))
	{
		level thread [[level.custom_wind_callback]]();
	}
}

