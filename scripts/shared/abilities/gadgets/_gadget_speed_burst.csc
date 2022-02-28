// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_speed_burst;

/*
	Name: __init__sytem__
	Namespace: _gadget_speed_burst
	Checksum: 0x820F1323
	Offset: 0x248
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_speed_burst", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_speed_burst
	Checksum: 0xCC6C3066
	Offset: 0x288
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_localplayer_spawned(&on_localplayer_spawned);
	clientfield::register("toplayer", "speed_burst", 1, 1, "int", &player_speed_changed, 0, 1);
	visionset_mgr::register_visionset_info("speed_burst", 1, 9, undefined, "speed_burst_initialize");
}

/*
	Name: on_localplayer_spawned
	Namespace: _gadget_speed_burst
	Checksum: 0xB7E83340
	Offset: 0x328
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function on_localplayer_spawned(localclientnum)
{
	if(self != getlocalplayer(localclientnum))
	{
		return;
	}
	filter::init_filter_speed_burst(self);
	filter::disable_filter_speed_burst(self, 3);
}

/*
	Name: player_speed_changed
	Namespace: _gadget_speed_burst
	Checksum: 0x5DAC8861
	Offset: 0x388
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function player_speed_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(self == getlocalplayer(localclientnum))
		{
			filter::enable_filter_speed_burst(self, 3);
		}
	}
	else if(self == getlocalplayer(localclientnum))
	{
		filter::disable_filter_speed_burst(self, 3);
	}
}

