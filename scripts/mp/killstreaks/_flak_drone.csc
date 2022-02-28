// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_helicopter_sounds;
#using scripts\mp\_util;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace flak_drone;

/*
	Name: __init__sytem__
	Namespace: flak_drone
	Checksum: 0x26A39A67
	Offset: 0x208
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("flak_drone", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: flak_drone
	Checksum: 0x5030F90B
	Offset: 0x248
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("vehicle", "flak_drone_camo", 1, 3, "int", &active_camo_changed, 0, 0);
}

/*
	Name: active_camo_changed
	Namespace: flak_drone
	Checksum: 0x1901F080
	Offset: 0x2A0
	Size: 0x11C
	Parameters: 7
	Flags: Linked
*/
function active_camo_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	flags_changed = self duplicate_render::set_dr_flag("active_camo_flicker", newval == 2);
	flags_changed = self duplicate_render::set_dr_flag("active_camo_on", 0) || flags_changed;
	flags_changed = self duplicate_render::set_dr_flag("active_camo_reveal", 1) || flags_changed;
	if(flags_changed)
	{
		self duplicate_render::update_dr_filters(localclientnum);
	}
	self notify(#"endtest");
	self thread doreveal(localclientnum, newval != 0);
}

/*
	Name: doreveal
	Namespace: flak_drone
	Checksum: 0xE68D7DC8
	Offset: 0x3C8
	Size: 0x164
	Parameters: 2
	Flags: Linked
*/
function doreveal(localclientnum, direction)
{
	self notify(#"endtest");
	self endon(#"endtest");
	self endon(#"entityshutdown");
	if(direction)
	{
		startval = 1;
	}
	else
	{
		startval = 0;
	}
	while(startval >= 0 && startval <= 1)
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector0", startval, 0, 0, 0);
		if(direction)
		{
			startval = startval - 0.032;
		}
		else
		{
			startval = startval + 0.032;
		}
		wait(0.016);
	}
	flags_changed = self duplicate_render::set_dr_flag("active_camo_reveal", 0);
	flags_changed = self duplicate_render::set_dr_flag("active_camo_on", direction) || flags_changed;
	if(flags_changed)
	{
		self duplicate_render::update_dr_filters(localclientnum);
	}
}

