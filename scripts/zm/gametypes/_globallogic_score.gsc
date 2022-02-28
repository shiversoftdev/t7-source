// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\bb_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\math_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_bb;
#using scripts\zm\_challenges;
#using scripts\zm\_util;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_audio;
#using scripts\zm\gametypes\_globallogic_utils;

#namespace globallogic_score;

/*
	Name: gethighestscoringplayer
	Namespace: globallogic_score
	Checksum: 0x2A16ED6E
	Offset: 0x4D8
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function gethighestscoringplayer()
{
	players = level.players;
	winner = undefined;
	tie = 0;
	for(i = 0; i < players.size; i++)
	{
		if(!isdefined(players[i].score))
		{
			continue;
		}
		if(players[i].score < 1)
		{
			continue;
		}
		if(!isdefined(winner) || players[i].score > winner.score)
		{
			winner = players[i];
			tie = 0;
			continue;
		}
		if(players[i].score == winner.score)
		{
			tie = 1;
		}
	}
	if(tie || !isdefined(winner))
	{
		return undefined;
	}
	return winner;
}

/*
	Name: resetscorechain
	Namespace: globallogic_score
	Checksum: 0xE0C8FDB6
	Offset: 0x620
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function resetscorechain()
{
	self notify(#"reset_score_chain");
	self.scorechain = 0;
	self.rankupdatetotal = 0;
}

/*
	Name: scorechaintimer
	Namespace: globallogic_score
	Checksum: 0x7544113C
	Offset: 0x650
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function scorechaintimer()
{
	self notify(#"score_chain_timer");
	self endon(#"reset_score_chain");
	self endon(#"score_chain_timer");
	self endon(#"death");
	self endon(#"disconnect");
	wait(20);
	self thread resetscorechain();
}

/*
	Name: roundtonearestfive
	Namespace: globallogic_score
	Checksum: 0xC76B841D
	Offset: 0x6B8
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function roundtonearestfive(score)
{
	rounding = score % 5;
	if(rounding <= 2)
	{
		return score - rounding;
	}
	return score + (5 - rounding);
}

/*
	Name: giveplayermomentumnotification
	Namespace: globallogic_score
	Checksum: 0xABBE78F2
	Offset: 0x718
	Size: 0x1E4
	Parameters: 4
	Flags: Linked
*/
function giveplayermomentumnotification(score, label, descvalue, countstowardrampage)
{
	rampagebonus = 0;
	if(isdefined(level.usingrampage) && level.usingrampage)
	{
		if(countstowardrampage)
		{
			if(!isdefined(self.scorechain))
			{
				self.scorechain = 0;
			}
			self.scorechain++;
			self thread scorechaintimer();
		}
		if(isdefined(self.scorechain) && self.scorechain >= 999)
		{
			rampagebonus = roundtonearestfive(int((score * level.rampagebonusscale) + 0.5));
		}
	}
	combat_efficiency_factor = 0;
	if(score != 0)
	{
		self luinotifyevent(&"score_event", 4, label, score, rampagebonus, combat_efficiency_factor);
	}
	score = score + rampagebonus;
	if(score > 0 && self hasperk("specialty_earnmoremomentum"))
	{
		score = roundtonearestfive(int((score * getdvarfloat("perk_killstreakMomentumMultiplier")) + 0.5));
	}
	_setplayermomentum(self, self.pers["momentum"] + score);
}

/*
	Name: resetplayermomentumondeath
	Namespace: globallogic_score
	Checksum: 0x37DB69F0
	Offset: 0x908
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function resetplayermomentumondeath()
{
	if(isdefined(level.usingscorestreaks) && level.usingscorestreaks)
	{
		_setplayermomentum(self, 0);
		self thread resetscorechain();
	}
}

/*
	Name: giveplayerxpdisplay
	Namespace: globallogic_score
	Checksum: 0xC39953E6
	Offset: 0x960
	Size: 0x170
	Parameters: 4
	Flags: Linked
*/
function giveplayerxpdisplay(event, player, victim, descvalue)
{
	score = rank::getscoreinfovalue(event);
	/#
		assert(isdefined(score));
	#/
	xp = rank::getscoreinfoxp(event);
	/#
		assert(isdefined(xp));
	#/
	label = rank::getscoreinfolabel(event);
	if(xp && !level.gameended && isdefined(label))
	{
		xpscale = player getxpscale();
		if(1 != xpscale)
		{
			xp = int((xp * xpscale) + 0.5);
		}
		player luinotifyevent(&"score_event", 2, label, xp);
	}
	return score;
}

/*
	Name: giveplayerscore
	Namespace: globallogic_score
	Checksum: 0x3B8E8F04
	Offset: 0xAD8
	Size: 0x4A
	Parameters: 5
	Flags: Linked
*/
function giveplayerscore(event, player, victim, descvalue, weapon)
{
	return giveplayerxpdisplay(event, player, victim, descvalue);
}

/*
	Name: default_onplayerscore
	Namespace: globallogic_score
	Checksum: 0xD575D29B
	Offset: 0xB30
	Size: 0x1C
	Parameters: 3
	Flags: Linked
*/
function default_onplayerscore(event, player, victim)
{
}

/*
	Name: _setplayerscore
	Namespace: globallogic_score
	Checksum: 0x62423F7C
	Offset: 0xB58
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _setplayerscore(player, score)
{
}

/*
	Name: _getplayerscore
	Namespace: globallogic_score
	Checksum: 0x3BB427ED
	Offset: 0xB78
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function _getplayerscore(player)
{
	return player.pers["score"];
}

/*
	Name: _setplayermomentum
	Namespace: globallogic_score
	Checksum: 0xB66F0B5F
	Offset: 0xBA0
	Size: 0x120
	Parameters: 2
	Flags: Linked
*/
function _setplayermomentum(player, momentum)
{
	momentum = math::clamp(momentum, 0, 2000);
	oldmomentum = player.pers["momentum"];
	if(momentum == oldmomentum)
	{
		return;
	}
	player bb::add_to_stat("momentum", momentum - oldmomentum);
	if(momentum > oldmomentum)
	{
		highestmomentumcost = 0;
		numkillstreaks = player.killstreak.size;
		killstreaktypearray = [];
	}
	player.pers["momentum"] = momentum;
	player.momentum = player.pers["momentum"];
}

/*
	Name: _giveplayerkillstreakinternal
	Namespace: globallogic_score
	Checksum: 0x7AD64985
	Offset: 0xCC8
	Size: 0x24
	Parameters: 4
	Flags: None
*/
function _giveplayerkillstreakinternal(player, momentum, oldmomentum, killstreaktypearray)
{
}

/*
	Name: setplayermomentumdebug
	Namespace: globallogic_score
	Checksum: 0x9AF048A7
	Offset: 0xCF8
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function setplayermomentumdebug()
{
	/#
		setdvar("", 0);
		while(true)
		{
			wait(1);
			momentumpercent = getdvarfloat("", 0);
			if(momentumpercent != 0)
			{
				player = util::gethostplayer();
				if(!isdefined(player))
				{
					return;
				}
				if(isdefined(player.killstreak))
				{
					_setplayermomentum(player, int(2000 * (momentumpercent / 100)));
				}
			}
		}
	#/
}

/*
	Name: giveteamscore
	Namespace: globallogic_score
	Checksum: 0x7295D380
	Offset: 0xDF0
	Size: 0x124
	Parameters: 4
	Flags: Linked
*/
function giveteamscore(event, team, player, victim)
{
	if(level.overrideteamscore)
	{
		return;
	}
	pixbeginevent("level.onTeamScore");
	teamscore = game["teamScores"][team];
	[[level.onteamscore]](event, team);
	pixendevent();
	newscore = game["teamScores"][team];
	bbprint("mpteamscores", "gametime %d event %s team %d diff %d score %d", gettime(), event, team, newscore - teamscore, newscore);
	if(teamscore == newscore)
	{
		return;
	}
	updateteamscores(team);
	thread globallogic::checkscorelimit();
}

/*
	Name: giveteamscoreforobjective
	Namespace: globallogic_score
	Checksum: 0xE5B8F6FC
	Offset: 0xF20
	Size: 0xA4
	Parameters: 2
	Flags: None
*/
function giveteamscoreforobjective(team, score)
{
	teamscore = game["teamScores"][team];
	onteamscore(score, team);
	newscore = game["teamScores"][team];
	if(teamscore == newscore)
	{
		return;
	}
	updateteamscores(team);
	thread globallogic::checkscorelimit();
}

/*
	Name: _setteamscore
	Namespace: globallogic_score
	Checksum: 0x2F0FFF95
	Offset: 0xFD0
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function _setteamscore(team, teamscore)
{
	if(teamscore == game["teamScores"][team])
	{
		return;
	}
	game["teamScores"][team] = teamscore;
	updateteamscores(team);
	thread globallogic::checkscorelimit();
}

/*
	Name: resetteamscores
	Namespace: globallogic_score
	Checksum: 0x88D04600
	Offset: 0x1048
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function resetteamscores()
{
	if(level.scoreroundwinbased || util::isfirstround())
	{
		foreach(team in level.teams)
		{
			game["teamScores"][team] = 0;
		}
	}
	updateallteamscores();
}

/*
	Name: resetallscores
	Namespace: globallogic_score
	Checksum: 0x88E70510
	Offset: 0x1110
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function resetallscores()
{
	resetteamscores();
	resetplayerscores();
}

/*
	Name: resetplayerscores
	Namespace: globallogic_score
	Checksum: 0x8ACD1904
	Offset: 0x1140
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function resetplayerscores()
{
	players = level.players;
	winner = undefined;
	tie = 0;
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i].pers["score"]))
		{
			_setplayerscore(players[i], 0);
		}
	}
}

/*
	Name: updateteamscores
	Namespace: globallogic_score
	Checksum: 0xB434DFB5
	Offset: 0x11F0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function updateteamscores(team)
{
	setteamscore(team, game["teamScores"][team]);
	level thread globallogic::checkteamscorelimitsoon(team);
}

/*
	Name: updateallteamscores
	Namespace: globallogic_score
	Checksum: 0x2549CE5
	Offset: 0x1248
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function updateallteamscores()
{
	foreach(team in level.teams)
	{
		updateteamscores(team);
	}
}

/*
	Name: _getteamscore
	Namespace: globallogic_score
	Checksum: 0xC28803F3
	Offset: 0x12E0
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function _getteamscore(team)
{
	return game["teamScores"][team];
}

/*
	Name: gethighestteamscoreteam
	Namespace: globallogic_score
	Checksum: 0x67C280D6
	Offset: 0x1308
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function gethighestteamscoreteam()
{
	score = 0;
	winning_teams = [];
	foreach(team in level.teams)
	{
		team_score = game["teamScores"][team];
		if(team_score > score)
		{
			score = team_score;
			winning_teams = [];
		}
		if(team_score == score)
		{
			winning_teams[team] = team;
		}
	}
	return winning_teams;
}

/*
	Name: areteamarraysequal
	Namespace: globallogic_score
	Checksum: 0xA556DC6A
	Offset: 0x1408
	Size: 0xB0
	Parameters: 2
	Flags: Linked
*/
function areteamarraysequal(teamsa, teamsb)
{
	if(teamsa.size != teamsb.size)
	{
		return false;
	}
	foreach(team in teamsa)
	{
		if(!isdefined(teamsb[team]))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: onteamscore
	Namespace: globallogic_score
	Checksum: 0xA76F163A
	Offset: 0x14C0
	Size: 0x2C8
	Parameters: 2
	Flags: Linked
*/
function onteamscore(score, team)
{
	game["teamScores"][team] = game["teamScores"][team] + score;
	if(level.scorelimit && game["teamScores"][team] > level.scorelimit)
	{
		game["teamScores"][team] = level.scorelimit;
	}
	if(level.splitscreen)
	{
		return;
	}
	if(level.scorelimit == 1)
	{
		return;
	}
	iswinning = gethighestteamscoreteam();
	if(iswinning.size == 0)
	{
		return;
	}
	if((gettime() - level.laststatustime) < 5000)
	{
		return;
	}
	if(areteamarraysequal(iswinning, level.waswinning))
	{
		return;
	}
	level.laststatustime = gettime();
	if(iswinning.size == 1)
	{
		foreach(team in iswinning)
		{
			if(isdefined(level.waswinning[team]))
			{
				if(level.waswinning.size == 1)
				{
					continue;
				}
			}
			globallogic_audio::leaderdialog("lead_taken", team, "status");
		}
	}
	if(level.waswinning.size == 1)
	{
		foreach(team in level.waswinning)
		{
			if(isdefined(iswinning[team]))
			{
				if(iswinning.size == 1)
				{
					continue;
				}
				if(level.waswinning.size > 1)
				{
					continue;
				}
			}
			globallogic_audio::leaderdialog("lead_lost", team, "status");
		}
	}
	level.waswinning = iswinning;
}

/*
	Name: default_onteamscore
	Namespace: globallogic_score
	Checksum: 0x3FFB2FB1
	Offset: 0x1790
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function default_onteamscore(event, team)
{
}

/*
	Name: initpersstat
	Namespace: globallogic_score
	Checksum: 0x73A11619
	Offset: 0x17B0
	Size: 0xE2
	Parameters: 3
	Flags: Linked
*/
function initpersstat(dataname, record_stats, init_to_stat_value)
{
	if(!isdefined(self.pers[dataname]))
	{
		self.pers[dataname] = 0;
	}
	if(!isdefined(record_stats) || record_stats == 1)
	{
		recordplayerstats(self, dataname, int(self.pers[dataname]));
	}
	if(isdefined(init_to_stat_value) && init_to_stat_value == 1)
	{
		self.pers[dataname] = self getdstat("PlayerStatsList", dataname, "StatValue");
	}
}

/*
	Name: getpersstat
	Namespace: globallogic_score
	Checksum: 0xDE0FE12
	Offset: 0x18A0
	Size: 0x18
	Parameters: 1
	Flags: Linked
*/
function getpersstat(dataname)
{
	return self.pers[dataname];
}

/*
	Name: incpersstat
	Namespace: globallogic_score
	Checksum: 0x58F005DC
	Offset: 0x18C0
	Size: 0xBC
	Parameters: 4
	Flags: Linked
*/
function incpersstat(dataname, increment, record_stats, includegametype)
{
	pixbeginevent("incPersStat");
	self.pers[dataname] = self.pers[dataname] + increment;
	self addplayerstat(dataname, increment);
	if(!isdefined(record_stats) || record_stats == 1)
	{
		self thread threadedrecordplayerstats(dataname);
	}
	pixendevent();
}

/*
	Name: threadedrecordplayerstats
	Namespace: globallogic_score
	Checksum: 0xA6430CFA
	Offset: 0x1988
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function threadedrecordplayerstats(dataname)
{
	self endon(#"disconnect");
	waittillframeend();
	recordplayerstats(self, dataname, self.pers[dataname]);
}

/*
	Name: inckillstreaktracker
	Namespace: globallogic_score
	Checksum: 0xB1FE0A37
	Offset: 0x19D0
	Size: 0x72
	Parameters: 1
	Flags: Linked
*/
function inckillstreaktracker(weapon)
{
	self endon(#"disconnect");
	waittillframeend();
	if(weapon.name == "artillery")
	{
		self.pers["artillery_kills"]++;
	}
	if(weapon.name == "dog_bite")
	{
		self.pers["dog_kills"]++;
	}
}

/*
	Name: trackattackerkill
	Namespace: globallogic_score
	Checksum: 0xC8BC6CD1
	Offset: 0x1A50
	Size: 0x344
	Parameters: 5
	Flags: Linked
*/
function trackattackerkill(name, rank, xp, prestige, xuid)
{
	self endon(#"disconnect");
	attacker = self;
	waittillframeend();
	pixbeginevent("trackAttackerKill");
	if(!isdefined(attacker.pers["killed_players"][name]))
	{
		attacker.pers["killed_players"][name] = 0;
	}
	if(!isdefined(attacker.killedplayerscurrent[name]))
	{
		attacker.killedplayerscurrent[name] = 0;
	}
	if(!isdefined(attacker.pers["nemesis_tracking"][name]))
	{
		attacker.pers["nemesis_tracking"][name] = 0;
	}
	attacker.pers["killed_players"][name]++;
	attacker.killedplayerscurrent[name]++;
	attacker.pers["nemesis_tracking"][name] = attacker.pers["nemesis_tracking"][name] + 1;
	if(attacker.pers["nemesis_name"] == name)
	{
		attacker challenges::killednemesis();
	}
	if(attacker.pers["nemesis_name"] == "" || attacker.pers["nemesis_tracking"][name] > attacker.pers["nemesis_tracking"][attacker.pers["nemesis_name"]])
	{
		attacker.pers["nemesis_name"] = name;
		attacker.pers["nemesis_rank"] = rank;
		attacker.pers["nemesis_rankIcon"] = prestige;
		attacker.pers["nemesis_xp"] = xp;
		attacker.pers["nemesis_xuid"] = xuid;
	}
	else if(isdefined(attacker.pers["nemesis_name"]) && attacker.pers["nemesis_name"] == name)
	{
		attacker.pers["nemesis_rank"] = rank;
		attacker.pers["nemesis_xp"] = xp;
	}
	pixendevent();
}

/*
	Name: trackattackeedeath
	Namespace: globallogic_score
	Checksum: 0x7FF2117F
	Offset: 0x1DA0
	Size: 0x2DC
	Parameters: 5
	Flags: Linked
*/
function trackattackeedeath(attackername, rank, xp, prestige, xuid)
{
	self endon(#"disconnect");
	waittillframeend();
	pixbeginevent("trackAttackeeDeath");
	if(!isdefined(self.pers["killed_by"][attackername]))
	{
		self.pers["killed_by"][attackername] = 0;
	}
	self.pers["killed_by"][attackername]++;
	if(!isdefined(self.pers["nemesis_tracking"][attackername]))
	{
		self.pers["nemesis_tracking"][attackername] = 0;
	}
	self.pers["nemesis_tracking"][attackername] = self.pers["nemesis_tracking"][attackername] + 1.5;
	if(self.pers["nemesis_name"] == "" || self.pers["nemesis_tracking"][attackername] > self.pers["nemesis_tracking"][self.pers["nemesis_name"]])
	{
		self.pers["nemesis_name"] = attackername;
		self.pers["nemesis_rank"] = rank;
		self.pers["nemesis_rankIcon"] = prestige;
		self.pers["nemesis_xp"] = xp;
		self.pers["nemesis_xuid"] = xuid;
	}
	else if(isdefined(self.pers["nemesis_name"]) && self.pers["nemesis_name"] == attackername)
	{
		self.pers["nemesis_rank"] = rank;
		self.pers["nemesis_xp"] = xp;
	}
	if(self.pers["nemesis_name"] == attackername && self.pers["nemesis_tracking"][attackername] >= 2)
	{
		self setclientuivisibilityflag("killcam_nemesis", 1);
	}
	else
	{
		self setclientuivisibilityflag("killcam_nemesis", 0);
	}
	pixendevent();
}

/*
	Name: default_iskillboosting
	Namespace: globallogic_score
	Checksum: 0xCEB59323
	Offset: 0x2088
	Size: 0x6
	Parameters: 0
	Flags: Linked
*/
function default_iskillboosting()
{
	return false;
}

/*
	Name: givekillstats
	Namespace: globallogic_score
	Checksum: 0xC5CF0200
	Offset: 0x2098
	Size: 0x194
	Parameters: 3
	Flags: Linked
*/
function givekillstats(smeansofdeath, weapon, evictim)
{
	self endon(#"disconnect");
	waittillframeend();
	if(level.rankedmatch && self [[level.iskillboosting]]())
	{
		/#
			self iprintlnbold("");
		#/
		return;
	}
	pixbeginevent("giveKillStats");
	self incpersstat("kills", 1, 1, 1);
	self.kills = self getpersstat("kills");
	self updatestatratio("kdratio", "kills", "deaths");
	attacker = self;
	if(smeansofdeath == "MOD_HEAD_SHOT")
	{
		attacker thread incpersstat("headshots", 1, 1, 0);
		attacker.headshots = attacker.pers["headshots"];
		evictim recordkillmodifier("headshot");
	}
	pixendevent();
}

/*
	Name: inctotalkills
	Namespace: globallogic_score
	Checksum: 0x2B68BCF3
	Offset: 0x2238
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function inctotalkills(team)
{
	if(level.teambased && isdefined(level.teams[team]))
	{
		game["totalKillsTeam"][team]++;
	}
	game["totalKills"]++;
}

/*
	Name: setinflictorstat
	Namespace: globallogic_score
	Checksum: 0x964B3F67
	Offset: 0x2290
	Size: 0x17C
	Parameters: 3
	Flags: None
*/
function setinflictorstat(einflictor, eattacker, weapon)
{
	if(!isdefined(eattacker))
	{
		return;
	}
	if(!isdefined(einflictor))
	{
		eattacker addweaponstat(weapon, "hits", 1);
		return;
	}
	if(!isdefined(einflictor.playeraffectedarray))
	{
		einflictor.playeraffectedarray = [];
	}
	foundnewplayer = 1;
	for(i = 0; i < einflictor.playeraffectedarray.size; i++)
	{
		if(einflictor.playeraffectedarray[i] == self)
		{
			foundnewplayer = 0;
			break;
		}
	}
	if(foundnewplayer)
	{
		einflictor.playeraffectedarray[einflictor.playeraffectedarray.size] = self;
		if(weapon == "concussion_grenade" || weapon == "tabun_gas")
		{
			eattacker addweaponstat(weapon, "used", 1);
		}
		eattacker addweaponstat(weapon, "hits", 1);
	}
}

/*
	Name: processshieldassist
	Namespace: globallogic_score
	Checksum: 0x9648CB23
	Offset: 0x2418
	Size: 0xE4
	Parameters: 1
	Flags: None
*/
function processshieldassist(killedplayer)
{
	self endon(#"disconnect");
	killedplayer endon(#"disconnect");
	wait(0.05);
	util::waittillslowprocessallowed();
	if(!isdefined(level.teams[self.pers["team"]]))
	{
		return;
	}
	if(self.pers["team"] == killedplayer.pers["team"])
	{
		return;
	}
	if(!level.teambased)
	{
		return;
	}
	self incpersstat("assists", 1, 1, 1);
	self.assists = self getpersstat("assists");
}

/*
	Name: processassist
	Namespace: globallogic_score
	Checksum: 0x8C62DCC3
	Offset: 0x2508
	Size: 0x22C
	Parameters: 3
	Flags: None
*/
function processassist(killedplayer, damagedone, weapon)
{
	self endon(#"disconnect");
	killedplayer endon(#"disconnect");
	wait(0.05);
	util::waittillslowprocessallowed();
	if(!isdefined(level.teams[self.pers["team"]]))
	{
		return;
	}
	if(self.pers["team"] == killedplayer.pers["team"])
	{
		return;
	}
	if(!level.teambased)
	{
		return;
	}
	assist_level = "assist";
	assist_level_value = int(ceil(damagedone / 25));
	if(assist_level_value < 1)
	{
		assist_level_value = 1;
	}
	else if(assist_level_value > 3)
	{
		assist_level_value = 3;
	}
	assist_level = (assist_level + "_") + (assist_level_value * 25);
	self incpersstat("assists", 1, 1, 1);
	self.assists = self getpersstat("assists");
	switch(weapon.name)
	{
		case "concussion_grenade":
		{
			assist_level = "assist_concussion";
			break;
		}
		case "flash_grenade":
		{
			assist_level = "assist_flash";
			break;
		}
		case "emp_grenade":
		{
			assist_level = "assist_emp";
			break;
		}
		case "proximity_grenade":
		case "proximity_grenade_aoe":
		{
			assist_level = "assist_proximity";
			break;
		}
	}
	self challenges::assisted();
}

/*
	Name: xpratethread
	Namespace: globallogic_score
	Checksum: 0x662CEBCE
	Offset: 0x2740
	Size: 0x8
	Parameters: 0
	Flags: Linked
*/
function xpratethread()
{
	/#
	#/
}

