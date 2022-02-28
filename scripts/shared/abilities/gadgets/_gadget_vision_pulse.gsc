// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\abilities\gadgets\_gadget_camo;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_vision_pulse;

/*
	Name: __init__sytem__
	Namespace: _gadget_vision_pulse
	Checksum: 0xAE6A0676
	Offset: 0x330
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_vision_pulse", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_vision_pulse
	Checksum: 0xF61282E1
	Offset: 0x370
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(6, &gadget_vision_pulse_on, &gadget_vision_pulse_off);
	ability_player::register_gadget_possession_callbacks(6, &gadget_vision_pulse_on_give, &gadget_vision_pulse_on_take);
	ability_player::register_gadget_flicker_callbacks(6, &gadget_vision_pulse_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(6, &gadget_vision_pulse_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(6, &gadget_vision_pulse_is_flickering);
	callback::on_connect(&gadget_vision_pulse_on_connect);
	callback::on_spawned(&gadget_vision_pulse_on_spawn);
	clientfield::register("toplayer", "vision_pulse_active", 1, 1, "int");
	if(!isdefined(level.vsmgr_prio_visionset_visionpulse))
	{
		level.vsmgr_prio_visionset_visionpulse = 61;
	}
	visionset_mgr::register_info("visionset", "vision_pulse", 1, level.vsmgr_prio_visionset_visionpulse, 12, 1, &visionset_mgr::ramp_in_out_thread_per_player_death_shutdown, 0);
}

/*
	Name: gadget_vision_pulse_is_inuse
	Namespace: _gadget_vision_pulse
	Checksum: 0x7D450A1C
	Offset: 0x508
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_vision_pulse_is_inuse(slot)
{
	return self flagsys::get("gadget_vision_pulse_on");
}

/*
	Name: gadget_vision_pulse_is_flickering
	Namespace: _gadget_vision_pulse
	Checksum: 0xAD0BE0E1
	Offset: 0x540
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_vision_pulse_is_flickering(slot)
{
	return self gadgetflickering(slot);
}

/*
	Name: gadget_vision_pulse_on_flicker
	Namespace: _gadget_vision_pulse
	Checksum: 0xC7215618
	Offset: 0x570
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function gadget_vision_pulse_on_flicker(slot, weapon)
{
	self thread gadget_vision_pulse_flicker(slot, weapon);
}

/*
	Name: gadget_vision_pulse_on_give
	Namespace: _gadget_vision_pulse
	Checksum: 0x9806817F
	Offset: 0x5B0
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_vision_pulse_on_give(slot, weapon)
{
}

/*
	Name: gadget_vision_pulse_on_take
	Namespace: _gadget_vision_pulse
	Checksum: 0xC012E195
	Offset: 0x5D0
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_vision_pulse_on_take(slot, weapon)
{
}

/*
	Name: gadget_vision_pulse_on_connect
	Namespace: _gadget_vision_pulse
	Checksum: 0x99EC1590
	Offset: 0x5F0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function gadget_vision_pulse_on_connect()
{
}

/*
	Name: gadget_vision_pulse_on_spawn
	Namespace: _gadget_vision_pulse
	Checksum: 0x2BAC4722
	Offset: 0x600
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function gadget_vision_pulse_on_spawn()
{
	self.visionpulseactivatetime = 0;
	self.visionpulsearray = [];
	self.visionpulseorigin = undefined;
	self.visionpulseoriginarray = [];
	if(isdefined(self._pulse_ent))
	{
		self._pulse_ent delete();
	}
}

/*
	Name: gadget_vision_pulse_ramp_hold_func
	Namespace: _gadget_vision_pulse
	Checksum: 0xBD564A9C
	Offset: 0x660
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function gadget_vision_pulse_ramp_hold_func()
{
	self util::waittill_any_timeout(5, "ramp_out_visionset");
}

/*
	Name: gadget_vision_pulse_watch_death
	Namespace: _gadget_vision_pulse
	Checksum: 0x8444D48
	Offset: 0x698
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function gadget_vision_pulse_watch_death()
{
	self notify(#"vision_pulse_watch_death");
	self endon(#"vision_pulse_watch_death");
	self endon(#"disconnect");
	self waittill(#"death");
	visionset_mgr::deactivate("visionset", "vision_pulse", self);
	if(isdefined(self._pulse_ent))
	{
		self._pulse_ent delete();
	}
}

/*
	Name: gadget_vision_pulse_watch_emp
	Namespace: _gadget_vision_pulse
	Checksum: 0x22298A1B
	Offset: 0x728
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function gadget_vision_pulse_watch_emp()
{
	self notify(#"vision_pulse_watch_emp");
	self endon(#"vision_pulse_watch_emp");
	self endon(#"disconnect");
	while(true)
	{
		if(self isempjammed())
		{
			visionset_mgr::deactivate("visionset", "vision_pulse", self);
			self notify(#"emp_vp_jammed");
			break;
		}
		wait(0.05);
	}
	if(isdefined(self._pulse_ent))
	{
		self._pulse_ent delete();
	}
}

/*
	Name: gadget_vision_pulse_on
	Namespace: _gadget_vision_pulse
	Checksum: 0xC768C0D7
	Offset: 0x7E8
	Size: 0xEC
	Parameters: 2
	Flags: Linked
*/
function gadget_vision_pulse_on(slot, weapon)
{
	if(isdefined(self._pulse_ent))
	{
		return;
	}
	self flagsys::set("gadget_vision_pulse_on");
	self thread gadget_vision_pulse_start(slot, weapon);
	visionset_mgr::activate("visionset", "vision_pulse", self, 0.25, &gadget_vision_pulse_ramp_hold_func, 0.75);
	self thread gadget_vision_pulse_watch_death();
	self thread gadget_vision_pulse_watch_emp();
	self clientfield::set_to_player("vision_pulse_active", 1);
}

/*
	Name: gadget_vision_pulse_off
	Namespace: _gadget_vision_pulse
	Checksum: 0xD588ACC0
	Offset: 0x8E0
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function gadget_vision_pulse_off(slot, weapon)
{
	self flagsys::clear("gadget_vision_pulse_on");
	self clientfield::set_to_player("vision_pulse_active", 0);
}

/*
	Name: gadget_vision_pulse_start
	Namespace: _gadget_vision_pulse
	Checksum: 0xAA4E3154
	Offset: 0x940
	Size: 0x37C
	Parameters: 2
	Flags: Linked
*/
function gadget_vision_pulse_start(slot, weapon)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"emp_vp_jammed");
	wait(0.1);
	if(isdefined(self._pulse_ent))
	{
		return;
	}
	self._pulse_ent = spawn("script_model", self.origin);
	self._pulse_ent setmodel("tag_origin");
	self gadgetsetentity(slot, self._pulse_ent);
	self gadgetsetactivatetime(slot, gettime());
	self set_gadget_vision_pulse_status("Activated");
	self.visionpulseactivatetime = gettime();
	enemyarray = level.players;
	gadget = getweapon("gadget_vision_pulse");
	visionpulsearray = arraysort(enemyarray, self._pulse_ent.origin, 1, undefined, gadget.gadget_pulse_max_range);
	self.visionpulseorigin = self._pulse_ent.origin;
	self.visionpulsearray = [];
	self.visionpulseoriginarray = [];
	spottedenemy = 0;
	self.visionpulsespottedenemy = [];
	self.visionpulsespottedenemytime = gettime();
	for(i = 0; i < visionpulsearray.size; i++)
	{
		if(visionpulsearray[i] _gadget_camo::camo_is_inuse() == 0)
		{
			self.visionpulsearray[self.visionpulsearray.size] = visionpulsearray[i];
			self.visionpulseoriginarray[self.visionpulseoriginarray.size] = visionpulsearray[i].origin;
			if(isalive(visionpulsearray[i]) && visionpulsearray[i].team != self.team)
			{
				spottedenemy = 1;
				self.visionpulsespottedenemy[self.visionpulsespottedenemy.size] = visionpulsearray[i];
			}
		}
	}
	self wait_until_is_done(slot, self._gadgets_player[slot].gadget_pulse_duration);
	if(spottedenemy && isdefined(level.playgadgetsuccess))
	{
		self [[level.playgadgetsuccess]](weapon);
	}
	else
	{
		self playsoundtoplayer("gdt_vision_pulse_no_hits", self);
		self notify(#"ramp_out_visionset");
	}
	self set_gadget_vision_pulse_status("Done");
	self._pulse_ent delete();
}

/*
	Name: wait_until_is_done
	Namespace: _gadget_vision_pulse
	Checksum: 0x3832DAC6
	Offset: 0xCC8
	Size: 0x5E
	Parameters: 2
	Flags: Linked
*/
function wait_until_is_done(slot, timepulse)
{
	starttime = gettime();
	while(true)
	{
		wait(0.25);
		currenttime = gettime();
		if(currenttime > (starttime + timepulse))
		{
			return;
		}
	}
}

/*
	Name: gadget_vision_pulse_flicker
	Namespace: _gadget_vision_pulse
	Checksum: 0x4E5FE86B
	Offset: 0xD30
	Size: 0xEC
	Parameters: 2
	Flags: Linked
*/
function gadget_vision_pulse_flicker(slot, weapon)
{
	self endon(#"disconnect");
	time = gettime();
	if(!self gadget_vision_pulse_is_inuse(slot))
	{
		return;
	}
	eventtime = self._gadgets_player[slot].gadget_flickertime;
	self set_gadget_vision_pulse_status(("^1") + "Flickering.", eventtime);
	while(true)
	{
		if(!self gadgetflickering(slot))
		{
			set_gadget_vision_pulse_status(("^2") + "Normal");
			return;
		}
		wait(0.25);
	}
}

/*
	Name: set_gadget_vision_pulse_status
	Namespace: _gadget_vision_pulse
	Checksum: 0xD4C6C904
	Offset: 0xE28
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function set_gadget_vision_pulse_status(status, time)
{
	timestr = "";
	if(isdefined(time))
	{
		timestr = (("^3") + ", time: ") + time;
	}
	if(getdvarint("scr_cpower_debug_prints") > 0)
	{
		self iprintlnbold(("Vision Pulse:" + status) + timestr);
	}
}

