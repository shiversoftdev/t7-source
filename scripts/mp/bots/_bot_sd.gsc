// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\bots\_bot;
#using scripts\mp\bots\_bot_combat;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace bot_sd;

/*
	Name: init
	Namespace: bot_sd
	Checksum: 0xFE20F631
	Offset: 0x1C8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.botidle = &bot_idle;
}

/*
	Name: bot_idle
	Namespace: bot_sd
	Checksum: 0x4C5C965D
	Offset: 0x1F0
	Size: 0x544
	Parameters: 0
	Flags: Linked
*/
function bot_idle()
{
	if(!level.bombplanted && !level.multibomb && self.team == game["attackers"])
	{
		carrier = level.sdbomb gameobjects::get_carrier();
		if(!isdefined(carrier))
		{
			self botsetgoal(level.sdbomb.trigger.origin);
			self bot::sprint_to_goal();
			return;
		}
	}
	approachradiussq = 562500;
	foreach(zone in level.bombzones)
	{
		if(isdefined(level.bombplanted) && level.bombplanted && (!(isdefined(zone.isplanted) && zone.isplanted)))
		{
			continue;
		}
		zonetrigger = self get_zone_trigger(zone);
		if(self istouching(zonetrigger))
		{
			if(self can_plant(zone) || self can_defuse(zone))
			{
				self bot::press_use_button();
				return;
			}
		}
		if(distancesquared(self.origin, zone.trigger.origin) < approachradiussq)
		{
			if(self can_plant(zone) || self can_defuse(zone))
			{
				self bot::path_to_trigger(zonetrigger);
				self bot::sprint_to_goal();
				return;
			}
		}
	}
	zones = array::randomize(level.bombzones);
	foreach(zone in zones)
	{
		if(isdefined(level.bombplanted) && level.bombplanted && (!(isdefined(zone.isplanted) && zone.isplanted)))
		{
			continue;
		}
		if(self can_defuse(zone))
		{
			self bot::approach_goal_trigger(zonetrigger, 750);
			self bot::sprint_to_goal();
			return;
		}
	}
	foreach(zone in zones)
	{
		if(isdefined(level.bombplanted) && level.bombplanted && (!(isdefined(zone.isplanted) && zone.isplanted)))
		{
			continue;
		}
		if(distancesquared(self.origin, zone.trigger.origin) < approachradiussq && randomint(100) < 70)
		{
			triggerradius = self bot::get_trigger_radius(zone.trigger);
			self bot::approach_point(zone.trigger.origin, triggerradius, 750);
			self bot::sprint_to_goal();
			return;
		}
	}
	self bot::bot_idle();
}

/*
	Name: get_zone_trigger
	Namespace: bot_sd
	Checksum: 0xA5C6B1D4
	Offset: 0x740
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function get_zone_trigger(zone)
{
	if(self.team == zone gameobjects::get_owner_team())
	{
		return zone.bombdefusetrig;
	}
	return zone.trigger;
}

/*
	Name: can_plant
	Namespace: bot_sd
	Checksum: 0x9B949B38
	Offset: 0x798
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function can_plant(zone)
{
	if(level.multibomb)
	{
		return !(isdefined(zone.isplanted) && zone.isplanted) && self.team != zone gameobjects::get_owner_team();
	}
	carrier = level.sdbomb gameobjects::get_carrier();
	return isdefined(carrier) && self == carrier;
}

/*
	Name: can_defuse
	Namespace: bot_sd
	Checksum: 0x5D98DE95
	Offset: 0x838
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function can_defuse(zone)
{
	return isdefined(zone.isplanted) && zone.isplanted && self.team == zone gameobjects::get_owner_team();
}

