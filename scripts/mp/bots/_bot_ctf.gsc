// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_util;
#using scripts\mp\bots\_bot;
#using scripts\mp\bots\_bot_combat;
#using scripts\mp\gametypes\ctf;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace bot_ctf;

/*
	Name: init
	Namespace: bot_ctf
	Checksum: 0xA3AED79E
	Offset: 0x1A0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.onbotconnect = &on_bot_connect;
	level.botidle = &bot_idle;
}

/*
	Name: on_bot_connect
	Namespace: bot_ctf
	Checksum: 0x20AAD701
	Offset: 0x1E0
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function on_bot_connect()
{
	foreach(flag in level.flags)
	{
		if(flag gameobjects::get_owner_team() == self.team)
		{
			self.bot.flag = flag;
			continue;
		}
		self.bot.enemyflag = flag;
	}
	self bot::on_bot_connect();
}

/*
	Name: bot_idle
	Namespace: bot_ctf
	Checksum: 0x1A6DBF0B
	Offset: 0x2C0
	Size: 0x32C
	Parameters: 0
	Flags: Linked
*/
function bot_idle()
{
	carrier = self.bot.enemyflag gameobjects::get_carrier();
	if(isdefined(carrier) && carrier == self)
	{
		if(self.bot.flag gameobjects::is_object_away_from_home())
		{
			self bot::approach_point(self.bot.flag.flagbase.trigger.origin, 0, 1024);
		}
		else
		{
			self bot::approach_goal_trigger(self.bot.flag.flagbase.trigger);
		}
		self bot::sprint_to_goal();
		return;
	}
	if(distance2dsquared(self.origin, self.bot.flag.flagbase.trigger.origin) < 1048576 && randomint(100) < 80)
	{
		self bot::approach_point(self.bot.flag.flagbase.trigger.origin, 0, 1024);
		self bot::sprint_to_goal();
		return;
	}
	if(self.bot.flag gameobjects::is_object_away_from_home())
	{
		enemycarrier = self.bot.flag gameobjects::get_carrier();
		if(isdefined(enemycarrier))
		{
			self bot::approach_point(enemycarrier.origin, 250, 1000, 128);
			self bot::sprint_to_goal();
			return;
		}
		self botsetgoal(self.bot.flag.trigger.origin);
		self bot::sprint_to_goal();
		return;
	}
	if(!isdefined(carrier))
	{
		self bot::approach_goal_trigger(self.bot.enemyflag.trigger);
		self bot::sprint_to_goal();
		return;
	}
	self bot::bot_idle();
}

