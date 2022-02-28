// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_util;
#using scripts\mp\bots\_bot;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\bot_traversals;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapon_utils;
#using scripts\shared\weapons\_weapons;
#using scripts\shared\weapons_shared;

#namespace bot_combat;

/*
	Name: bot_ignore_threat
	Namespace: bot_combat
	Checksum: 0x7462DE04
	Offset: 0x258
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function bot_ignore_threat(entity)
{
	if(threat_requires_launcher(entity) && !self bot::has_launcher())
	{
		return true;
	}
	return false;
}

/*
	Name: mp_pre_combat
	Namespace: bot_combat
	Checksum: 0x1EA39EF
	Offset: 0x2A8
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function mp_pre_combat()
{
	self bot_pre_combat();
	if(self isreloading() || self isswitchingweapons() || self isthrowinggrenade() || self ismeleeing() || self isremotecontrolling() || self isinvehicle() || self isweaponviewonlylinked())
	{
		return;
	}
	if(self has_threat())
	{
		self threat_switch_weapon();
		return;
	}
	if(self switch_weapon())
	{
		return;
	}
	if(self reload_weapon())
	{
		return;
	}
	self bot::use_killstreak();
}

/*
	Name: mp_post_combat
	Namespace: bot_combat
	Checksum: 0xFB8DC5
	Offset: 0x3F0
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function mp_post_combat()
{
	if(!isdefined(level.dogtags))
	{
		return;
	}
	if(isdefined(self.bot.goaltag))
	{
		if(!self.bot.goaltag gameobjects::can_interact_with(self))
		{
			self.bot.goaltag = undefined;
			if(!self has_threat() && self botgoalset())
			{
				self botsetgoal(self.origin);
			}
		}
		else if(!self.bot.goaltagonground && !self has_threat() && self isonground() && distance2dsquared(self.origin, self.bot.goaltag.origin) < 16384 && self botsighttrace(self.bot.goaltag))
		{
			self thread bot::jump_to(self.bot.goaltag.origin);
		}
	}
	else if(!self botgoalset())
	{
		closesttag = self get_closest_tag();
		if(isdefined(closesttag))
		{
			self set_goal_tag(closesttag);
		}
	}
}

/*
	Name: threat_requires_launcher
	Namespace: bot_combat
	Checksum: 0x35148488
	Offset: 0x5E0
	Size: 0x100
	Parameters: 1
	Flags: Linked
*/
function threat_requires_launcher(enemy)
{
	if(!isdefined(enemy) || isplayer(enemy))
	{
		return false;
	}
	killstreaktype = undefined;
	if(isdefined(enemy.killstreaktype))
	{
		killstreaktype = enemy.killstreaktype;
	}
	else if(isdefined(enemy.parentstruct) && isdefined(enemy.parentstruct.killstreaktype))
	{
		killstreaktype = enemy.parentstruct.killstreaktype;
	}
	if(!isdefined(killstreaktype))
	{
		return false;
	}
	switch(killstreaktype)
	{
		case "counteruav":
		case "helicopter_gunner":
		case "satellite":
		case "uav":
		{
			return true;
		}
	}
	return false;
}

/*
	Name: combat_throw_proximity
	Namespace: bot_combat
	Checksum: 0x998272B4
	Offset: 0x6E8
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function combat_throw_proximity(origin)
{
}

/*
	Name: combat_throw_smoke
	Namespace: bot_combat
	Checksum: 0x986BDB02
	Offset: 0x700
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function combat_throw_smoke(origin)
{
}

/*
	Name: combat_throw_lethal
	Namespace: bot_combat
	Checksum: 0xDC59B920
	Offset: 0x718
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function combat_throw_lethal(origin)
{
}

/*
	Name: combat_throw_tactical
	Namespace: bot_combat
	Checksum: 0x3BAAD24E
	Offset: 0x730
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function combat_throw_tactical(origin)
{
}

/*
	Name: combat_toss_frag
	Namespace: bot_combat
	Checksum: 0xDAF54BC3
	Offset: 0x748
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function combat_toss_frag(origin)
{
}

/*
	Name: combat_toss_flash
	Namespace: bot_combat
	Checksum: 0xAEE3877D
	Offset: 0x760
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function combat_toss_flash(origin)
{
}

/*
	Name: combat_tactical_insertion
	Namespace: bot_combat
	Checksum: 0x1725CAEE
	Offset: 0x778
	Size: 0xE
	Parameters: 1
	Flags: Linked
*/
function combat_tactical_insertion(origin)
{
	return false;
}

/*
	Name: nearest_node
	Namespace: bot_combat
	Checksum: 0x861E3DB8
	Offset: 0x790
	Size: 0xE
	Parameters: 1
	Flags: None
*/
function nearest_node(origin)
{
	return undefined;
}

/*
	Name: dot_product
	Namespace: bot_combat
	Checksum: 0x17D8C4F5
	Offset: 0x7A8
	Size: 0x22
	Parameters: 1
	Flags: None
*/
function dot_product(origin)
{
	return bot::fwd_dot(origin);
}

/*
	Name: get_closest_tag
	Namespace: bot_combat
	Checksum: 0xC103BCEB
	Offset: 0x7D8
	Size: 0x118
	Parameters: 0
	Flags: Linked
*/
function get_closest_tag()
{
	closesttag = undefined;
	closesttagdistsq = undefined;
	foreach(tag in level.dogtags)
	{
		if(!tag gameobjects::can_interact_with(self))
		{
			continue;
		}
		distsq = distancesquared(self.origin, tag.origin);
		if(!isdefined(closesttag) || distsq < closesttagdistsq)
		{
			closesttag = tag;
			closesttagdistsq = distsq;
		}
	}
	return closesttag;
}

/*
	Name: set_goal_tag
	Namespace: bot_combat
	Checksum: 0xBEB4CE61
	Offset: 0x8F8
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function set_goal_tag(tag)
{
	self.bot.goaltag = tag;
	tracestart = tag.origin;
	traceend = tag.origin + (vectorscale((0, 0, -1), 64));
	trace = bullettrace(tracestart, traceend, 0, undefined);
	self.bot.goaltagonground = trace["fraction"] < 1;
	self bot::path_to_trigger(tag.trigger);
	self bot::sprint_to_goal();
}

