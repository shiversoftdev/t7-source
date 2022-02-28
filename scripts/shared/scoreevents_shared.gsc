// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\callbacks_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace scoreevents;

/*
	Name: processscoreevent
	Namespace: scoreevents
	Checksum: 0x96EC284D
	Offset: 0x2B0
	Size: 0x3C8
	Parameters: 4
	Flags: Linked
*/
function processscoreevent(event, player, victim, weapon)
{
	pixbeginevent("processScoreEvent");
	scoregiven = 0;
	if(!isplayer(player))
	{
		/#
			assertmsg("" + event);
		#/
		return scoregiven;
	}
	if(getdvarint("teamOpsEnabled") == 1)
	{
		if(isdefined(level.teamopsonprocessplayerevent))
		{
			level [[level.teamopsonprocessplayerevent]](event, player);
		}
	}
	if(isdefined(level.challengesoneventreceived))
	{
		player thread [[level.challengesoneventreceived]](event);
	}
	if(isregisteredevent(event) && (!sessionmodeiszombiesgame() || level.onlinegame))
	{
		allowplayerscore = 0;
		if(!isdefined(weapon) || !killstreaks::is_killstreak_weapon(weapon))
		{
			allowplayerscore = 1;
		}
		else
		{
			allowplayerscore = killstreakweaponsallowedscore(event);
		}
		if(allowplayerscore)
		{
			if(isdefined(level.scoreongiveplayerscore))
			{
				scoregiven = [[level.scoreongiveplayerscore]](event, player, victim, undefined, weapon);
				isscoreevent = scoregiven > 0;
				if(isscoreevent)
				{
					hero_restricted = is_hero_score_event_restricted(event);
					player ability_power::power_gain_event_score(victim, scoregiven, weapon, hero_restricted);
				}
			}
		}
	}
	if(shouldaddrankxp(player) && getdvarint("teamOpsEnabled") == 0)
	{
		pickedup = 0;
		if(isdefined(weapon) && isdefined(player.pickedupweapons) && isdefined(player.pickedupweapons[weapon]))
		{
			pickedup = 1;
		}
		if(sessionmodeiscampaigngame())
		{
			xp_difficulty_multiplier = player gameskill::get_player_xp_difficulty_multiplier();
		}
		else
		{
			xp_difficulty_multiplier = 1;
		}
		player addrankxp(event, weapon, player.class_num, pickedup, isscoreevent, xp_difficulty_multiplier);
	}
	pixendevent();
	if(sessionmodeiscampaigngame() && isdefined(xp_difficulty_multiplier))
	{
		if(isdefined(victim) && isdefined(victim.team))
		{
			if(victim.team == "axis" || victim.team == "team3")
			{
				scoregiven = scoregiven * xp_difficulty_multiplier;
			}
		}
	}
	return scoregiven;
}

/*
	Name: shouldaddrankxp
	Namespace: scoreevents
	Checksum: 0x81884CBA
	Offset: 0x680
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function shouldaddrankxp(player)
{
	if(sessionmodeiscampaignzombiesgame())
	{
		return false;
	}
	if(level.gametype == "fr")
	{
		return false;
	}
	if(!isdefined(level.rankcap) || level.rankcap == 0)
	{
		return true;
	}
	if(player.pers["plevel"] > 0 || player.pers["rank"] > level.rankcap)
	{
		return false;
	}
	return true;
}

/*
	Name: uninterruptedobitfeedkills
	Namespace: scoreevents
	Checksum: 0xE2352C0A
	Offset: 0x730
	Size: 0x64
	Parameters: 2
	Flags: None
*/
function uninterruptedobitfeedkills(attacker, weapon)
{
	self endon(#"disconnect");
	wait(0.1);
	util::waittillslowprocessallowed();
	wait(0.1);
	processscoreevent("uninterrupted_obit_feed_kills", attacker, self, weapon);
}

/*
	Name: isregisteredevent
	Namespace: scoreevents
	Checksum: 0x2BA82723
	Offset: 0x7A0
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function isregisteredevent(type)
{
	if(isdefined(level.scoreinfo[type]))
	{
		return true;
	}
	return false;
}

/*
	Name: decrementlastobituaryplayercountafterfade
	Namespace: scoreevents
	Checksum: 0x2107D27E
	Offset: 0x7D8
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function decrementlastobituaryplayercountafterfade()
{
	level endon(#"reset_obituary_count");
	wait(5);
	level.lastobituaryplayercount--;
	/#
		assert(level.lastobituaryplayercount >= 0);
	#/
}

/*
	Name: getscoreeventtablename
	Namespace: scoreevents
	Checksum: 0x95F44F5
	Offset: 0x820
	Size: 0x4A
	Parameters: 0
	Flags: Linked
*/
function getscoreeventtablename()
{
	if(sessionmodeiscampaigngame())
	{
		return "gamedata/tables/cp/scoreInfo.csv";
	}
	if(sessionmodeiszombiesgame())
	{
		return "gamedata/tables/zm/scoreInfo.csv";
	}
	return "gamedata/tables/mp/scoreInfo.csv";
}

/*
	Name: getscoreeventtableid
	Namespace: scoreevents
	Checksum: 0xE86D5F70
	Offset: 0x878
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function getscoreeventtableid()
{
	scoreinfotableloaded = 0;
	scoreinfotableid = tablelookupfindcoreasset(getscoreeventtablename());
	if(isdefined(scoreinfotableid))
	{
		scoreinfotableloaded = 1;
	}
	/#
		assert(scoreinfotableloaded, "" + getscoreeventtablename());
	#/
	return scoreinfotableid;
}

/*
	Name: getscoreeventcolumn
	Namespace: scoreevents
	Checksum: 0xB9267F2C
	Offset: 0x918
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function getscoreeventcolumn(gametype)
{
	columnoffset = getcolumnoffsetforgametype(gametype);
	/#
		assert(columnoffset >= 0);
	#/
	if(columnoffset >= 0)
	{
		columnoffset = columnoffset + 0;
	}
	return columnoffset;
}

/*
	Name: getxpeventcolumn
	Namespace: scoreevents
	Checksum: 0xD5027DF8
	Offset: 0x990
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function getxpeventcolumn(gametype)
{
	columnoffset = getcolumnoffsetforgametype(gametype);
	/#
		assert(columnoffset >= 0);
	#/
	if(columnoffset >= 0)
	{
		columnoffset = columnoffset + 1;
	}
	return columnoffset;
}

/*
	Name: getcolumnoffsetforgametype
	Namespace: scoreevents
	Checksum: 0xB0DFFB9E
	Offset: 0xA08
	Size: 0x138
	Parameters: 1
	Flags: Linked
*/
function getcolumnoffsetforgametype(gametype)
{
	foundgamemode = 0;
	if(!isdefined(level.scoreeventtableid))
	{
		level.scoreeventtableid = getscoreeventtableid();
	}
	/#
		assert(isdefined(level.scoreeventtableid));
	#/
	if(!isdefined(level.scoreeventtableid))
	{
		return -1;
	}
	gamemodecolumn = 14;
	for(;;)
	{
		column_header = tablelookupcolumnforrow(level.scoreeventtableid, 0, gamemodecolumn);
		if(column_header == "")
		{
			gamemodecolumn = 14;
			break;
		}
		if(column_header == (level.gametype + " score"))
		{
			foundgamemode = 1;
			break;
		}
		gamemodecolumn = gamemodecolumn + 2;
	}
	/#
		assert(foundgamemode, "" + gametype);
	#/
	return gamemodecolumn;
}

/*
	Name: killstreakweaponsallowedscore
	Namespace: scoreevents
	Checksum: 0xBC263923
	Offset: 0xB48
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function killstreakweaponsallowedscore(type)
{
	if(getdvarint("teamOpsEnabled") == 1)
	{
		return false;
	}
	if(isdefined(level.scoreinfo[type]["allowKillstreakWeapons"]) && level.scoreinfo[type]["allowKillstreakWeapons"] == 1)
	{
		return true;
	}
	return false;
}

/*
	Name: is_hero_score_event_restricted
	Namespace: scoreevents
	Checksum: 0x14C99E5B
	Offset: 0xBD0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function is_hero_score_event_restricted(event)
{
	if(!isdefined(level.scoreinfo[event]["allow_hero"]) || level.scoreinfo[event]["allow_hero"] != 1)
	{
		return true;
	}
	return false;
}

/*
	Name: givecratecapturemedal
	Namespace: scoreevents
	Checksum: 0x389972ED
	Offset: 0xC30
	Size: 0x1EC
	Parameters: 2
	Flags: Linked
*/
function givecratecapturemedal(crate, capturer)
{
	if(isdefined(crate) && isdefined(capturer) && isdefined(crate.owner) && isplayer(crate.owner))
	{
		if(level.teambased)
		{
			if(capturer.team != crate.owner.team)
			{
				crate.owner playlocalsound("mpl_crate_enemy_steals");
				if(!isdefined(crate.hacker))
				{
					processscoreevent("capture_enemy_crate", capturer);
				}
			}
			else if(isdefined(crate.owner) && capturer != crate.owner)
			{
				crate.owner playlocalsound("mpl_crate_friendly_steals");
				if(!isdefined(crate.hacker))
				{
					level.globalsharepackages++;
					processscoreevent("share_care_package", crate.owner);
				}
			}
		}
		else if(capturer != crate.owner)
		{
			crate.owner playlocalsound("mpl_crate_enemy_steals");
			if(!isdefined(crate.hacker))
			{
				processscoreevent("capture_enemy_crate", capturer);
			}
		}
	}
}

/*
	Name: register_hero_ability_kill_event
	Namespace: scoreevents
	Checksum: 0x7417FA2F
	Offset: 0xE28
	Size: 0x3A
	Parameters: 1
	Flags: None
*/
function register_hero_ability_kill_event(event_func)
{
	if(!isdefined(level.hero_ability_kill_events))
	{
		level.hero_ability_kill_events = [];
	}
	level.hero_ability_kill_events[level.hero_ability_kill_events.size] = event_func;
}

/*
	Name: register_hero_ability_multikill_event
	Namespace: scoreevents
	Checksum: 0x8FBB5A80
	Offset: 0xE70
	Size: 0x3A
	Parameters: 1
	Flags: None
*/
function register_hero_ability_multikill_event(event_func)
{
	if(!isdefined(level.hero_ability_multikill_events))
	{
		level.hero_ability_multikill_events = [];
	}
	level.hero_ability_multikill_events[level.hero_ability_multikill_events.size] = event_func;
}

/*
	Name: register_hero_weapon_multikill_event
	Namespace: scoreevents
	Checksum: 0x76E4F673
	Offset: 0xEB8
	Size: 0x3A
	Parameters: 1
	Flags: None
*/
function register_hero_weapon_multikill_event(event_func)
{
	if(!isdefined(level.hero_weapon_multikill_events))
	{
		level.hero_weapon_multikill_events = [];
	}
	level.hero_weapon_multikill_events[level.hero_weapon_multikill_events.size] = event_func;
}

/*
	Name: register_thief_shutdown_enemy_event
	Namespace: scoreevents
	Checksum: 0x90F82B17
	Offset: 0xF00
	Size: 0x3A
	Parameters: 1
	Flags: None
*/
function register_thief_shutdown_enemy_event(event_func)
{
	if(!isdefined(level.thief_shutdown_enemy_events))
	{
		level.thief_shutdown_enemy_events = [];
	}
	level.thief_shutdown_enemy_events[level.thief_shutdown_enemy_events.size] = event_func;
}

/*
	Name: hero_ability_kill_event
	Namespace: scoreevents
	Checksum: 0x33BAD423
	Offset: 0xF48
	Size: 0xB4
	Parameters: 2
	Flags: None
*/
function hero_ability_kill_event(ability, victim_ability)
{
	if(!isdefined(level.hero_ability_kill_events))
	{
		return;
	}
	foreach(event_func in level.hero_ability_kill_events)
	{
		if(isdefined(event_func))
		{
			self [[event_func]](ability, victim_ability);
		}
	}
}

/*
	Name: hero_ability_multikill_event
	Namespace: scoreevents
	Checksum: 0xD58684A
	Offset: 0x1008
	Size: 0xB4
	Parameters: 2
	Flags: None
*/
function hero_ability_multikill_event(killcount, ability)
{
	if(!isdefined(level.hero_ability_multikill_events))
	{
		return;
	}
	foreach(event_func in level.hero_ability_multikill_events)
	{
		if(isdefined(event_func))
		{
			self [[event_func]](killcount, ability);
		}
	}
}

/*
	Name: hero_weapon_multikill_event
	Namespace: scoreevents
	Checksum: 0x52BE2291
	Offset: 0x10C8
	Size: 0xB4
	Parameters: 2
	Flags: None
*/
function hero_weapon_multikill_event(killcount, weapon)
{
	if(!isdefined(level.hero_weapon_multikill_events))
	{
		return;
	}
	foreach(event_func in level.hero_weapon_multikill_events)
	{
		if(isdefined(event_func))
		{
			self [[event_func]](killcount, weapon);
		}
	}
}

/*
	Name: thief_shutdown_enemy_event
	Namespace: scoreevents
	Checksum: 0x34FF785A
	Offset: 0x1188
	Size: 0x9C
	Parameters: 0
	Flags: None
*/
function thief_shutdown_enemy_event()
{
	if(!isdefined(level.thief_shutdown_enemy_event))
	{
		return;
	}
	foreach(event_func in level.thief_shutdown_enemy_event)
	{
		if(isdefined(event_func))
		{
			self [[event_func]]();
		}
	}
}

