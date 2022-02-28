// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\bots\_bot;
#using scripts\mp\bots\_bot_combat;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace bot_dem;

/*
	Name: init
	Namespace: bot_dem
	Checksum: 0x29839E8E
	Offset: 0x190
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.botidle = &bot_idle;
	level.botcombat = &combat_think;
	level.botthreatlost = &function_211bcdc;
}

/*
	Name: bot_idle
	Namespace: bot_dem
	Checksum: 0xDBD5F61F
	Offset: 0x1E8
	Size: 0x46C
	Parameters: 0
	Flags: Linked
*/
function bot_idle()
{
	approachradiussq = 562500;
	foreach(zone in level.bombzones)
	{
		if(isdefined(zone.bombexploded) && zone.bombexploded)
		{
			continue;
		}
		if(self istouching(zone.trigger))
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
				self bot::path_to_trigger(zone.trigger);
				self bot::sprint_to_goal();
				return;
			}
		}
	}
	zones = array::randomize(level.bombzones);
	foreach(zone in zones)
	{
		if(isdefined(zone.bombexploded) && zone.bombexploded)
		{
			continue;
		}
		if(self can_defuse(zone) && randomint(100) < 70)
		{
			self bot::approach_goal_trigger(zone.trigger, 750);
			self bot::sprint_to_goal();
			return;
		}
	}
	foreach(zone in zones)
	{
		if(isdefined(zone.bombexploded) && zone.bombexploded)
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
	Name: can_plant
	Namespace: bot_dem
	Checksum: 0x3E95B6FB
	Offset: 0x660
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function can_plant(zone)
{
	return !(isdefined(zone.bombplanted) && zone.bombplanted) && self.team != zone gameobjects::get_owner_team();
}

/*
	Name: can_defuse
	Namespace: bot_dem
	Checksum: 0x8CB6CDCA
	Offset: 0x6C0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function can_defuse(zone)
{
	return isdefined(zone.bombplanted) && zone.bombplanted && self.team == zone gameobjects::get_owner_team();
}

/*
	Name: combat_think
	Namespace: bot_dem
	Checksum: 0x18C6CAE4
	Offset: 0x720
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function combat_think()
{
	if(isdefined(self.isplanting) && self.isplanting || (isdefined(self.isdefusing) && self.isdefusing))
	{
		return;
	}
	self bot_combat::combat_think();
}

/*
	Name: function_211bcdc
	Namespace: bot_dem
	Checksum: 0x309587F4
	Offset: 0x778
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_211bcdc()
{
	approachradiussq = 562500;
	foreach(zone in level.bombzones)
	{
		if(isdefined(zone.bombexploded) && zone.bombexploded)
		{
			continue;
		}
		if(distancesquared(self.origin, zone.trigger.origin) < approachradiussq)
		{
			if(self can_plant(zone) || self can_defuse(zone))
			{
				return;
			}
		}
	}
	self bot_combat::chase_threat();
}

