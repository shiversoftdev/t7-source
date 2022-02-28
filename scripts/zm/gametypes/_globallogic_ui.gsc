// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_player;
#using scripts\zm\gametypes\_spectating;

#namespace globallogic_ui;

/*
	Name: __init__sytem__
	Namespace: globallogic_ui
	Checksum: 0x5A958BED
	Offset: 0x248
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("globallogic_ui", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: globallogic_ui
	Checksum: 0x99EC1590
	Offset: 0x288
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

/*
	Name: setupcallbacks
	Namespace: globallogic_ui
	Checksum: 0xE1C11B17
	Offset: 0x298
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function setupcallbacks()
{
	level.autoassign = &menuautoassign;
	level.spectator = &menuspectator;
	level.curclass = &menuclass;
	level.teammenu = &menuteam;
}

/*
	Name: freegameplayhudelems
	Namespace: globallogic_ui
	Checksum: 0x4F9FE9DF
	Offset: 0x308
	Size: 0x27C
	Parameters: 0
	Flags: Linked
*/
function freegameplayhudelems()
{
	if(isdefined(self.perkicon))
	{
		for(numspecialties = 0; numspecialties < level.maxspecialties; numspecialties++)
		{
			if(isdefined(self.perkicon[numspecialties]))
			{
				self.perkicon[numspecialties] hud::destroyelem();
				self.perkname[numspecialties] hud::destroyelem();
			}
		}
	}
	if(isdefined(self.perkhudelem))
	{
		self.perkhudelem hud::destroyelem();
	}
	if(isdefined(self.killstreakicon))
	{
		if(isdefined(self.killstreakicon[0]))
		{
			self.killstreakicon[0] hud::destroyelem();
		}
		if(isdefined(self.killstreakicon[1]))
		{
			self.killstreakicon[1] hud::destroyelem();
		}
		if(isdefined(self.killstreakicon[2]))
		{
			self.killstreakicon[2] hud::destroyelem();
		}
		if(isdefined(self.killstreakicon[3]))
		{
			self.killstreakicon[3] hud::destroyelem();
		}
		if(isdefined(self.killstreakicon[4]))
		{
			self.killstreakicon[4] hud::destroyelem();
		}
	}
	if(isdefined(self.lowermessage))
	{
		self.lowermessage hud::destroyelem();
	}
	if(isdefined(self.lowertimer))
	{
		self.lowertimer hud::destroyelem();
	}
	if(isdefined(self.proxbar))
	{
		self.proxbar hud::destroyelem();
	}
	if(isdefined(self.proxbartext))
	{
		self.proxbartext hud::destroyelem();
	}
	if(isdefined(self.carryicon))
	{
		self.carryicon hud::destroyelem();
	}
}

/*
	Name: teamplayercountsequal
	Namespace: globallogic_ui
	Checksum: 0xFB20DD7D
	Offset: 0x590
	Size: 0xC6
	Parameters: 1
	Flags: None
*/
function teamplayercountsequal(playercounts)
{
	count = undefined;
	foreach(team in level.teams)
	{
		if(!isdefined(count))
		{
			count = playercounts[team];
			continue;
		}
		if(count != playercounts[team])
		{
			return false;
		}
	}
	return true;
}

/*
	Name: teamwithlowestplayercount
	Namespace: globallogic_ui
	Checksum: 0xCBD00BF2
	Offset: 0x660
	Size: 0xDA
	Parameters: 2
	Flags: None
*/
function teamwithlowestplayercount(playercounts, ignore_team)
{
	count = 9999;
	lowest_team = undefined;
	foreach(team in level.teams)
	{
		if(count > playercounts[team])
		{
			count = playercounts[team];
			lowest_team = team;
		}
	}
	return lowest_team;
}

/*
	Name: menuautoassign
	Namespace: globallogic_ui
	Checksum: 0xE330584F
	Offset: 0x748
	Size: 0x56C
	Parameters: 1
	Flags: Linked
*/
function menuautoassign(comingfrommenu)
{
	teamkeys = getarraykeys(level.teams);
	assignment = teamkeys[randomint(teamkeys.size)];
	self closemenus();
	if(isdefined(level.forceallallies) && level.forceallallies)
	{
		assignment = "allies";
	}
	else
	{
		if(level.teambased)
		{
			if(getdvarint("party_autoteams") == 1)
			{
				if(level.allow_teamchange == "1" && (self.hasspawned || comingfrommenu))
				{
					assignment = "";
				}
				else
				{
					team = getassignedteam(self);
					switch(team)
					{
						case 1:
						{
							assignment = teamkeys[1];
							break;
						}
						case 2:
						{
							assignment = teamkeys[0];
							break;
						}
						case 3:
						{
							assignment = teamkeys[2];
							break;
						}
						case 4:
						{
							if(!isdefined(level.forceautoassign) || !level.forceautoassign)
							{
								self setclientscriptmainmenu(game["menu_start_menu"]);
								return;
							}
						}
						default:
						{
							assignment = "";
							if(isdefined(level.teams[team]))
							{
								assignment = team;
							}
							else if(team == "spectator" && !level.forceautoassign)
							{
								self setclientscriptmainmenu(game["menu_start_menu"]);
								return;
							}
						}
					}
				}
			}
			if(assignment == "" || getdvarint("party_autoteams") == 0)
			{
				if(sessionmodeiszombiesgame())
				{
					assignment = "allies";
				}
			}
			if(assignment == self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead"))
			{
				self beginclasschoice();
				return;
			}
		}
		else if(getdvarint("party_autoteams") == 1)
		{
			if(level.allow_teamchange != "1" || (!self.hasspawned && !comingfrommenu))
			{
				team = getassignedteam(self);
				if(isdefined(level.teams[team]))
				{
					assignment = team;
				}
				else if(team == "spectator" && !level.forceautoassign)
				{
					self setclientscriptmainmenu(game["menu_start_menu"]);
					return;
				}
			}
		}
	}
	if(assignment != self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead"))
	{
		self.switching_teams = 1;
		self.joining_team = assignment;
		self.leaving_team = self.pers["team"];
		self suicide();
	}
	self.pers["team"] = assignment;
	self.team = assignment;
	self.pers["class"] = undefined;
	self.curclass = undefined;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	self updateobjectivetext();
	self.sessionteam = assignment;
	if(!isalive(self))
	{
		self.statusicon = "hud_status_dead";
	}
	self notify(#"joined_team");
	level notify(#"joined_team");
	self callback::callback(#"hash_95a6c4c0");
	self notify(#"end_respawn");
	self beginclasschoice();
	self setclientscriptmainmenu(game["menu_start_menu"]);
}

/*
	Name: teamscoresequal
	Namespace: globallogic_ui
	Checksum: 0xFF84DAC
	Offset: 0xCC0
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function teamscoresequal()
{
	score = undefined;
	foreach(team in level.teams)
	{
		if(!isdefined(score))
		{
			score = getteamscore(team);
			continue;
		}
		if(score != getteamscore(team))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: teamwithlowestscore
	Namespace: globallogic_ui
	Checksum: 0xC3AAB7DC
	Offset: 0xD98
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function teamwithlowestscore()
{
	score = 99999999;
	lowest_team = undefined;
	foreach(team in level.teams)
	{
		if(score > getteamscore(team))
		{
			lowest_team = team;
		}
	}
	return lowest_team;
}

/*
	Name: pickteamfromscores
	Namespace: globallogic_ui
	Checksum: 0x29E3FCCD
	Offset: 0xE68
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function pickteamfromscores(teams)
{
	assignment = "allies";
	if(teamscoresequal())
	{
		assignment = teams[randomint(teams.size)];
	}
	else
	{
		assignment = teamwithlowestscore();
	}
	return assignment;
}

/*
	Name: getsplitscreenteam
	Namespace: globallogic_ui
	Checksum: 0x45C3EB7E
	Offset: 0xEE8
	Size: 0xCE
	Parameters: 0
	Flags: None
*/
function getsplitscreenteam()
{
	for(index = 0; index < level.players.size; index++)
	{
		if(!isdefined(level.players[index]))
		{
			continue;
		}
		if(level.players[index] == self)
		{
			continue;
		}
		if(!self isplayeronsamemachine(level.players[index]))
		{
			continue;
		}
		team = level.players[index].sessionteam;
		if(team != "spectator")
		{
			return team;
		}
	}
	return "";
}

/*
	Name: updateobjectivetext
	Namespace: globallogic_ui
	Checksum: 0xC3C4A600
	Offset: 0xFC0
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function updateobjectivetext()
{
	if(sessionmodeiszombiesgame() || self.pers["team"] == "spectator")
	{
		self setclientcgobjectivetext("");
		return;
	}
	if(level.scorelimit > 0)
	{
		self setclientcgobjectivetext(util::getobjectivescoretext(self.pers["team"]));
	}
	else
	{
		self setclientcgobjectivetext(util::getobjectivetext(self.pers["team"]));
	}
}

/*
	Name: closemenus
	Namespace: globallogic_ui
	Checksum: 0x51601F7A
	Offset: 0x10A0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function closemenus()
{
	self closeingamemenu();
}

/*
	Name: beginclasschoice
	Namespace: globallogic_ui
	Checksum: 0xA82BA665
	Offset: 0x10C8
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function beginclasschoice(forcenewchoice)
{
	/#
		assert(isdefined(level.teams[self.pers[""]]));
	#/
	team = self.pers["team"];
	if(level.disablecac == 1)
	{
		self.pers["class"] = level.defaultclass;
		self.curclass = level.defaultclass;
		if(self.sessionstate != "playing" && game["state"] == "playing")
		{
			self thread [[level.spawnclient]]();
		}
		level thread globallogic::updateteamstatus();
		self thread spectating::setspectatepermissionsformachine();
		return;
	}
	self openmenu(game["menu_changeclass_" + team]);
}

/*
	Name: showmainmenuforteam
	Namespace: globallogic_ui
	Checksum: 0x28668455
	Offset: 0x1200
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function showmainmenuforteam()
{
	/#
		assert(isdefined(level.teams[self.pers[""]]));
	#/
	team = self.pers["team"];
	self openmenu(game["menu_changeclass_" + team]);
}

/*
	Name: menuteam
	Namespace: globallogic_ui
	Checksum: 0xD64FA18
	Offset: 0x1280
	Size: 0x204
	Parameters: 1
	Flags: Linked
*/
function menuteam(team)
{
	self closemenus();
	if(!level.console && level.allow_teamchange == "0" && (isdefined(self.hasdonecombat) && self.hasdonecombat))
	{
		return;
	}
	if(self.pers["team"] != team)
	{
		if(level.ingraceperiod && (!isdefined(self.hasdonecombat) || !self.hasdonecombat))
		{
			self.hasspawned = 0;
		}
		if(self.sessionstate == "playing")
		{
			self.switching_teams = 1;
			self.joining_team = team;
			self.leaving_team = self.pers["team"];
			self suicide();
		}
		self.pers["team"] = team;
		self.team = team;
		self.pers["class"] = undefined;
		self.curclass = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;
		self updateobjectivetext();
		self.sessionteam = team;
		self setclientscriptmainmenu(game["menu_start_menu"]);
		self notify(#"joined_team");
		level notify(#"joined_team");
		self callback::callback(#"hash_95a6c4c0");
		self notify(#"end_respawn");
	}
	self beginclasschoice();
}

/*
	Name: menuspectator
	Namespace: globallogic_ui
	Checksum: 0x4384B87A
	Offset: 0x1490
	Size: 0x182
	Parameters: 0
	Flags: Linked
*/
function menuspectator()
{
	self closemenus();
	if(self.pers["team"] != "spectator")
	{
		if(isalive(self))
		{
			self.switching_teams = 1;
			self.joining_team = "spectator";
			self.leaving_team = self.pers["team"];
			self suicide();
		}
		self.pers["team"] = "spectator";
		self.team = "spectator";
		self.pers["class"] = undefined;
		self.curclass = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;
		self updateobjectivetext();
		self.sessionteam = "spectator";
		[[level.spawnspectator]]();
		self thread globallogic_player::spectate_player_watcher();
		self setclientscriptmainmenu(game["menu_start_menu"]);
		self notify(#"joined_spectators");
	}
}

/*
	Name: menuclass
	Namespace: globallogic_ui
	Checksum: 0x310E6512
	Offset: 0x1620
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function menuclass(response)
{
	self closemenus();
}

/*
	Name: removespawnmessageshortly
	Namespace: globallogic_ui
	Checksum: 0xE5CDE140
	Offset: 0x1650
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function removespawnmessageshortly(delay)
{
	self endon(#"disconnect");
	waittillframeend();
	self endon(#"end_respawn");
	wait(delay);
	self util::clearlowermessage(2);
}

