// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_util;
#using scripts\mp\bots\_bot;
#using scripts\mp\teams\_teams;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\bots\bot_traversals;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_ebd80b8b;

/*
	Name: init
	Namespace: namespace_ebd80b8b
	Checksum: 0x11DCAEAC
	Offset: 0x1F8
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
	Namespace: namespace_ebd80b8b
	Checksum: 0xE007FE44
	Offset: 0x220
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function bot_idle()
{
	if(self.team == game["attackers"])
	{
		self function_69879c50();
	}
	else
	{
		self function_16ce4b24();
	}
}

/*
	Name: function_69879c50
	Namespace: namespace_ebd80b8b
	Checksum: 0x8B74385B
	Offset: 0x278
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_69879c50()
{
	if(isdefined(level.moveobject) && (level.robot.active || level.rebootplayers > 0))
	{
		if(!level.robot.moving || math::cointoss())
		{
			self bot::path_to_point_in_trigger(level.moveobject.trigger);
		}
		else
		{
			self bot::approach_point(level.moveobject.trigger.origin, 160, 400);
		}
		self bot::sprint_to_goal();
		return;
	}
	self bot::bot_idle();
}

/*
	Name: function_16ce4b24
	Namespace: namespace_ebd80b8b
	Checksum: 0x203A2CFE
	Offset: 0x370
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_16ce4b24()
{
	if(isdefined(level.moveobject) && level.robot.active)
	{
		self bot::approach_point(level.moveobject.trigger.origin, 160, 400);
		self bot::sprint_to_goal();
		return;
	}
	self bot::bot_idle();
}

