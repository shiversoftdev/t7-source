// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\bots\_bot;
#using scripts\mp\bots\_bot_combat;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace bot_koth;

/*
	Name: init
	Namespace: bot_koth
	Checksum: 0x3FA050E8
	Offset: 0x148
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.onbotspawned = &on_bot_spawned;
	level.botupdatethreatgoal = &bot_update_threat_goal;
	level.botidle = &bot_idle;
}

/*
	Name: on_bot_spawned
	Namespace: bot_koth
	Checksum: 0x7F53E294
	Offset: 0x1A0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function on_bot_spawned()
{
	self thread wait_zone_moved();
	self bot::on_bot_spawned();
}

/*
	Name: wait_zone_moved
	Namespace: bot_koth
	Checksum: 0x23FEE3F3
	Offset: 0x1E0
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function wait_zone_moved()
{
	self endon(#"death");
	level endon(#"game_ended");
	while(true)
	{
		level waittill(#"zone_moved");
		if(!self bot_combat::has_threat() && self botgoalset())
		{
			self botsetgoal(self.origin);
		}
	}
}

/*
	Name: bot_update_threat_goal
	Namespace: bot_koth
	Checksum: 0x8C2B8AAE
	Offset: 0x268
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function bot_update_threat_goal()
{
	if(isdefined(level.zone) && self istouching(level.zone.gameobject.trigger))
	{
		if(self botgoalreached())
		{
			self bot::path_to_point_in_trigger(level.zone.gameobject.trigger);
		}
		return;
	}
	self bot_combat::update_threat_goal();
}

/*
	Name: bot_idle
	Namespace: bot_koth
	Checksum: 0x4A08FD45
	Offset: 0x310
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function bot_idle()
{
	if(isdefined(level.zone))
	{
		if(self istouching(level.zone.gameobject.trigger))
		{
			self bot::path_to_point_in_trigger(level.zone.gameobject.trigger);
		}
		else
		{
			self bot::approach_goal_trigger(level.zone.gameobject.trigger);
			self bot::sprint_to_goal();
		}
		return;
	}
	self bot::bot_idle();
}

