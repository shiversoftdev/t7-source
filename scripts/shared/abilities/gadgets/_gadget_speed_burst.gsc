// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace speedburst;

/*
	Name: __init__sytem__
	Namespace: speedburst
	Checksum: 0x17D41454
	Offset: 0x2C8
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
	Namespace: speedburst
	Checksum: 0x93C543C5
	Offset: 0x308
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "speed_burst", 1, 1, "int");
	ability_player::register_gadget_activation_callbacks(13, &gadget_speed_burst_on, &gadget_speed_burst_off);
	ability_player::register_gadget_possession_callbacks(13, &gadget_speed_burst_on_give, &gadget_speed_burst_on_take);
	ability_player::register_gadget_flicker_callbacks(13, &gadget_speed_burst_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(13, &gadget_speed_burst_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(13, &gadget_speed_burst_is_flickering);
	if(!isdefined(level.vsmgr_prio_visionset_speedburst))
	{
		level.vsmgr_prio_visionset_speedburst = 60;
	}
	visionset_mgr::register_info("visionset", "speed_burst", 1, level.vsmgr_prio_visionset_speedburst, 9, 1, &visionset_mgr::ramp_in_out_thread_per_player_death_shutdown, 0);
	callback::on_connect(&gadget_speed_burst_on_connect);
}

/*
	Name: gadget_speed_burst_is_inuse
	Namespace: speedburst
	Checksum: 0xDB301688
	Offset: 0x480
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_speed_burst_is_inuse(slot)
{
	return self flagsys::get("gadget_speed_burst_on");
}

/*
	Name: gadget_speed_burst_is_flickering
	Namespace: speedburst
	Checksum: 0x4B9CE329
	Offset: 0x4B8
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_speed_burst_is_flickering(slot)
{
	return self gadgetflickering(slot);
}

/*
	Name: gadget_speed_burst_on_flicker
	Namespace: speedburst
	Checksum: 0xDE6B0911
	Offset: 0x4E8
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function gadget_speed_burst_on_flicker(slot, weapon)
{
	self thread gadget_speed_burst_flicker(slot, weapon);
}

/*
	Name: gadget_speed_burst_on_give
	Namespace: speedburst
	Checksum: 0x7C825F71
	Offset: 0x528
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function gadget_speed_burst_on_give(slot, weapon)
{
	flagsys::set("speed_burst_on");
	self clientfield::set_to_player("speed_burst", 0);
}

/*
	Name: gadget_speed_burst_on_take
	Namespace: speedburst
	Checksum: 0x995C19E4
	Offset: 0x580
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function gadget_speed_burst_on_take(slot, weapon)
{
	flagsys::clear("speed_burst_on");
	self clientfield::set_to_player("speed_burst", 0);
}

/*
	Name: gadget_speed_burst_on_connect
	Namespace: speedburst
	Checksum: 0x99EC1590
	Offset: 0x5D8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function gadget_speed_burst_on_connect()
{
}

/*
	Name: gadget_speed_burst_on
	Namespace: speedburst
	Checksum: 0x81291A6A
	Offset: 0x5E8
	Size: 0xC8
	Parameters: 2
	Flags: Linked
*/
function gadget_speed_burst_on(slot, weapon)
{
	self flagsys::set("gadget_speed_burst_on");
	self gadgetsetactivatetime(slot, gettime());
	self clientfield::set_to_player("speed_burst", 1);
	visionset_mgr::activate("visionset", "speed_burst", self, 0.4, 0.1, 1.35);
	self.speedburstlastontime = gettime();
	self.speedburston = 1;
	self.speedburstkill = 0;
}

/*
	Name: gadget_speed_burst_off
	Namespace: speedburst
	Checksum: 0x76B9A15
	Offset: 0x6B8
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function gadget_speed_burst_off(slot, weapon)
{
	self notify(#"gadget_speed_burst_off");
	self flagsys::clear("gadget_speed_burst_on");
	self clientfield::set_to_player("speed_burst", 0);
	self.speedburstlastontime = gettime();
	self.speedburston = 0;
	if(isalive(self) && (isdefined(self.speedburstkill) && self.speedburstkill) && isdefined(level.playgadgetsuccess))
	{
		self [[level.playgadgetsuccess]](weapon);
	}
	self.speedburstkill = 0;
}

/*
	Name: gadget_speed_burst_flicker
	Namespace: speedburst
	Checksum: 0x91476243
	Offset: 0x798
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function gadget_speed_burst_flicker(slot, weapon)
{
	self endon(#"disconnect");
	if(!self gadget_speed_burst_is_inuse(slot))
	{
		return;
	}
	eventtime = self._gadgets_player[slot].gadget_flickertime;
	self set_gadget_status("Flickering", eventtime);
	while(true)
	{
		if(!self gadgetflickering(slot))
		{
			self set_gadget_status("Normal");
			return;
		}
		wait(0.5);
	}
}

/*
	Name: set_gadget_status
	Namespace: speedburst
	Checksum: 0x948E74E
	Offset: 0x870
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function set_gadget_status(status, time)
{
	timestr = "";
	if(isdefined(time))
	{
		timestr = (("^3") + ", time: ") + time;
	}
	if(getdvarint("scr_cpower_debug_prints") > 0)
	{
		self iprintlnbold(("Vision Speed burst: " + status) + timestr);
	}
}

