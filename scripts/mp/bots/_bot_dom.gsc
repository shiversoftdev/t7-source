// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\bots\_bot;
#using scripts\mp\bots\_bot_combat;
#using scripts\mp\gametypes\dom;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace bot_dom;

/*
	Name: init
	Namespace: bot_dom
	Checksum: 0xFCD9EB92
	Offset: 0x188
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.botupdate = &bot_update;
	level.botprecombat = &bot_pre_combat;
	level.botupdatethreatgoal = &bot_update_threat_goal;
	level.botidle = &bot_idle;
}

/*
	Name: bot_update
	Namespace: bot_dom
	Checksum: 0x72BFAB5B
	Offset: 0x1F8
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function bot_update()
{
	self.bot.capturingflag = self get_capturing_flag();
	self.bot.goalflag = undefined;
	if(!self botgoalreached())
	{
		foreach(flag in level.domflags)
		{
			if(self bot::goal_in_trigger(flag.trigger))
			{
				self.bot.goalflag = flag;
				break;
			}
		}
	}
	self bot::bot_update();
}

/*
	Name: bot_pre_combat
	Namespace: bot_dom
	Checksum: 0x18C9A380
	Offset: 0x318
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function bot_pre_combat()
{
	if(!self bot_combat::has_threat() && isdefined(self.bot.goalflag) && self.bot.goalflag gameobjects::get_owner_team() == self.team)
	{
		self botsetgoal(self.origin);
	}
	self bot_combat::mp_pre_combat();
}

/*
	Name: bot_idle
	Namespace: bot_dom
	Checksum: 0xBA0ACA38
	Offset: 0x3B8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function bot_idle()
{
	if(isdefined(self.bot.capturingflag))
	{
		self bot::path_to_point_in_trigger(self.bot.capturingflag.trigger);
		return;
	}
	bestflag = get_best_flag();
	if(isdefined(bestflag))
	{
		self bot::approach_goal_trigger(bestflag.trigger);
		self bot::sprint_to_goal();
		return;
	}
	self bot::bot_idle();
}

/*
	Name: bot_update_threat_goal
	Namespace: bot_dom
	Checksum: 0x8234ABA5
	Offset: 0x488
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function bot_update_threat_goal()
{
	if(isdefined(self.bot.capturingflag))
	{
		if(self botgoalreached())
		{
			self bot::path_to_point_in_trigger(self.bot.capturingflag.trigger);
		}
		return;
	}
	self bot_combat::update_threat_goal();
}

/*
	Name: get_capturing_flag
	Namespace: bot_dom
	Checksum: 0xDCE622E0
	Offset: 0x508
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function get_capturing_flag()
{
	foreach(flag in level.domflags)
	{
		if(self.team != flag gameobjects::get_owner_team() && self istouching(flag.trigger))
		{
			return flag;
		}
	}
	return undefined;
}

/*
	Name: get_best_flag
	Namespace: bot_dom
	Checksum: 0x190A3D78
	Offset: 0x5D8
	Size: 0x15E
	Parameters: 0
	Flags: Linked
*/
function get_best_flag()
{
	bestflag = undefined;
	bestflagdistsq = undefined;
	foreach(flag in level.domflags)
	{
		ownerteam = flag gameobjects::get_owner_team();
		contested = flag gameobjects::get_num_touching_except_team(ownerteam);
		distsq = distance2dsquared(self.origin, flag.origin);
		if(ownerteam == self.team && !contested)
		{
			continue;
		}
		if(!isdefined(bestflag) || distsq < bestflagdistsq)
		{
			bestflag = flag;
			bestflagdistsq = distsq;
		}
	}
	return bestflag;
}

