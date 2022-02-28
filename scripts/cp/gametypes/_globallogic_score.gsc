// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_bb;
#using scripts\cp\_challenges;
#using scripts\cp\_scoreevents;
#using scripts\cp\_util;
#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_globallogic_utils;
#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_wager;
#using scripts\shared\bb_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

#namespace globallogic_score;

/*
	Name: updatematchbonusscores
	Namespace: globallogic_score
	Checksum: 0xAD191013
	Offset: 0x9B8
	Size: 0x7F2
	Parameters: 1
	Flags: Linked
*/
function updatematchbonusscores(winner)
{
	if(!game["timepassed"])
	{
		return;
	}
	if(!level.rankedmatch)
	{
		return;
	}
	if(level.teambased && isdefined(winner))
	{
		if(winner == "endregulation")
		{
			return;
		}
	}
	if(!level.timelimit || level.forcedend)
	{
		gamelength = globallogic_utils::gettimepassed() / 1000;
		gamelength = min(gamelength, 1200);
		if(level.gametype == "twar" && game["roundsplayed"] > 0)
		{
			gamelength = gamelength + (level.timelimit * 60);
		}
	}
	else
	{
		gamelength = level.timelimit * 60;
	}
	if(level.teambased)
	{
		winningteam = "tie";
		foreach(team in level.teams)
		{
			if(winner == team)
			{
				winningteam = team;
				break;
			}
		}
		if(winningteam != "tie")
		{
			winnerscale = 1;
			loserscale = 0.5;
		}
		else
		{
			winnerscale = 0.75;
			loserscale = 0.75;
		}
		players = level.players;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(player.timeplayed["total"] < 1 || player.pers["participation"] < 1)
			{
				player thread rank::endgameupdate();
				continue;
			}
			totaltimeplayed = player.timeplayed["total"];
			if(totaltimeplayed > gamelength)
			{
				totaltimeplayed = gamelength;
			}
			if(level.hostforcedend && player ishost())
			{
				continue;
			}
			if(player.pers["score"] < 0)
			{
				continue;
			}
			spm = player rank::getspm();
			if(winningteam == "tie")
			{
				playerscore = int((winnerscale * ((gamelength / 60) * spm)) * (totaltimeplayed / gamelength));
				player thread givematchbonus("tie", playerscore);
				player.matchbonus = playerscore;
				continue;
			}
			if(isdefined(player.pers["team"]) && player.pers["team"] == winningteam)
			{
				playerscore = int((winnerscale * ((gamelength / 60) * spm)) * (totaltimeplayed / gamelength));
				player thread givematchbonus("win", playerscore);
				player.matchbonus = playerscore;
				continue;
			}
			if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator")
			{
				playerscore = int((loserscale * ((gamelength / 60) * spm)) * (totaltimeplayed / gamelength));
				player thread givematchbonus("loss", playerscore);
				player.matchbonus = playerscore;
			}
		}
	}
	else
	{
		if(isdefined(winner))
		{
			winnerscale = 1;
			loserscale = 0.5;
		}
		else
		{
			winnerscale = 0.75;
			loserscale = 0.75;
		}
		players = level.players;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(player.timeplayed["total"] < 1 || player.pers["participation"] < 1)
			{
				player thread rank::endgameupdate();
				continue;
			}
			totaltimeplayed = player.timeplayed["total"];
			if(totaltimeplayed > gamelength)
			{
				totaltimeplayed = gamelength;
			}
			spm = player rank::getspm();
			iswinner = 0;
			for(pidx = 0; pidx < min(level.placement["all"][0].size, 3); pidx++)
			{
				if(level.placement["all"][pidx] != player)
				{
					continue;
				}
				iswinner = 1;
			}
			if(iswinner)
			{
				playerscore = int((winnerscale * ((gamelength / 60) * spm)) * (totaltimeplayed / gamelength));
				player thread givematchbonus("win", playerscore);
				player.matchbonus = playerscore;
				continue;
			}
			playerscore = int((loserscale * ((gamelength / 60) * spm)) * (totaltimeplayed / gamelength));
			player thread givematchbonus("loss", playerscore);
			player.matchbonus = playerscore;
		}
	}
}

/*
	Name: givematchbonus
	Namespace: globallogic_score
	Checksum: 0xB0D30588
	Offset: 0x11B8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function givematchbonus(scoretype, score)
{
	self endon(#"disconnect");
	level waittill(#"give_match_bonus");
	if(scoreevents::shouldaddrankxp(self))
	{
		self addrankxpvalue(scoretype, score);
	}
	self rank::endgameupdate();
}

/*
	Name: gethighestscoringplayer
	Namespace: globallogic_score
	Checksum: 0xB7D5858C
	Offset: 0x1240
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
		if(!isdefined(players[i].pointstowin))
		{
			continue;
		}
		if(players[i].pointstowin < 1)
		{
			continue;
		}
		if(!isdefined(winner) || players[i].pointstowin > winner.pointstowin)
		{
			winner = players[i];
			tie = 0;
			continue;
		}
		if(players[i].pointstowin == winner.pointstowin)
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
	Checksum: 0x8F60D7A3
	Offset: 0x1388
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
	Checksum: 0x57456112
	Offset: 0x13B8
	Size: 0x5C
	Parameters: 0
	Flags: None
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
	Checksum: 0x23E16688
	Offset: 0x1420
	Size: 0x52
	Parameters: 1
	Flags: None
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
	Name: giveplayerscore
	Namespace: globallogic_score
	Checksum: 0xF94D9FFD
	Offset: 0x1480
	Size: 0x30C
	Parameters: 4
	Flags: Linked
*/
function giveplayerscore(event, player, victim, descvalue)
{
	scorediff = 0;
	if(level.overrideplayerscore)
	{
		return 0;
	}
	pixbeginevent("level.onPlayerScore");
	score = player.pers["score"];
	[[level.onplayerscore]](event, player, victim);
	newscore = player.pers["score"];
	pixendevent();
	player bb::add_to_stat("score", newscore - score);
	if(score == newscore)
	{
		return 0;
	}
	pixbeginevent("givePlayerScore");
	recordplayerstats(player, "score", newscore);
	scorediff = newscore - score;
	challengesenabled = !level.disablechallenges;
	player addplayerstatwithgametype("score", scorediff);
	if(challengesenabled)
	{
		player addplayerstat("CAREER_SCORE", scorediff);
	}
	if(level.hardcoremode)
	{
		player addplayerstat("SCORE_HC", scorediff);
		if(challengesenabled)
		{
			player addplayerstat("CAREER_SCORE_HC", scorediff);
		}
	}
	if(level.multiteam)
	{
		player addplayerstat("SCORE_MULTITEAM", scorediff);
		if(challengesenabled)
		{
			player addplayerstat("CAREER_SCORE_MULTITEAM", scorediff);
		}
	}
	if(!level.disablestattracking && isdefined(player.pers["lastHighestScore"]) && newscore > player.pers["lastHighestScore"])
	{
		player setdstat("HighestStats", "highest_score", newscore);
	}
	player persistence::add_recent_stat(0, 0, "score", scorediff);
	pixendevent();
	player notify(#"score_event", scorediff);
	return scorediff;
}

/*
	Name: default_onplayerscore
	Namespace: globallogic_score
	Checksum: 0x9BCEDA13
	Offset: 0x1798
	Size: 0xB4
	Parameters: 3
	Flags: Linked
*/
function default_onplayerscore(event, player, victim)
{
	score = rank::getscoreinfovalue(event);
	/#
		assert(isdefined(score));
	#/
	if(level.wagermatch)
	{
		player thread rank::updaterankscorehud(score);
	}
	_setplayerscore(player, player.pers["score"] + score);
}

/*
	Name: _setplayerscore
	Namespace: globallogic_score
	Checksum: 0xE0162BDB
	Offset: 0x1858
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function _setplayerscore(player, score)
{
	if(score == player.pers["score"])
	{
		return;
	}
	if(!level.rankedmatch)
	{
		player thread rank::updaterankscorehud(score - player.pers["score"]);
	}
	player.pers["score"] = score;
	player.score = player.pers["score"];
	recordplayerstats(player, "score", player.pers["score"]);
	if(level.wagermatch)
	{
		player thread wager::player_scored();
	}
}

/*
	Name: _getplayerscore
	Namespace: globallogic_score
	Checksum: 0x9FFDA43
	Offset: 0x1960
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function _getplayerscore(player)
{
	return player.pers["score"];
}

/*
	Name: playtop3sounds
	Namespace: globallogic_score
	Checksum: 0x92DCD2F4
	Offset: 0x1988
	Size: 0x176
	Parameters: 0
	Flags: Linked
*/
function playtop3sounds()
{
	wait(0.05);
	globallogic::updateplacement();
	for(i = 0; i < level.placement["all"].size; i++)
	{
		prevscoreplace = level.placement["all"][i].prevscoreplace;
		if(!isdefined(prevscoreplace))
		{
			prevscoreplace = 1;
		}
		currentscoreplace = i + 1;
		for(j = i - 1; j >= 0; j--)
		{
			if(level.placement["all"][i].score == level.placement["all"][j].score)
			{
				currentscoreplace--;
			}
		}
		wasinthemoney = prevscoreplace <= 3;
		isinthemoney = currentscoreplace <= 3;
		level.placement["all"][i].prevscoreplace = currentscoreplace;
	}
}

/*
	Name: setpointstowin
	Namespace: globallogic_score
	Checksum: 0x3E8CAB36
	Offset: 0x1B08
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function setpointstowin(points)
{
	self.pers["pointstowin"] = math::clamp(points, 0, 65000);
	self.pointstowin = self.pers["pointstowin"];
	self thread globallogic::checkscorelimit();
	self thread globallogic::checkplayerscorelimitsoon();
	level thread playtop3sounds();
}

/*
	Name: givepointstowin
	Namespace: globallogic_score
	Checksum: 0xA13C53D1
	Offset: 0x1BB0
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function givepointstowin(points)
{
	self setpointstowin(self.pers["pointstowin"] + points);
}

/*
	Name: giveteamscore
	Namespace: globallogic_score
	Checksum: 0x91BD1334
	Offset: 0x1BF8
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
	Name: giveteamscoreforobjective_delaypostprocessing
	Namespace: globallogic_score
	Checksum: 0x61A33D6F
	Offset: 0x1D28
	Size: 0x94
	Parameters: 2
	Flags: None
*/
function giveteamscoreforobjective_delaypostprocessing(team, score)
{
	teamscore = game["teamScores"][team];
	onteamscore_incrementscore(score, team);
	newscore = game["teamScores"][team];
	if(teamscore == newscore)
	{
		return;
	}
	updateteamscores(team);
}

/*
	Name: postprocessteamscores
	Namespace: globallogic_score
	Checksum: 0xD4AA1010
	Offset: 0x1DC8
	Size: 0xA4
	Parameters: 1
	Flags: None
*/
function postprocessteamscores(teams)
{
	foreach(team in teams)
	{
		onteamscore_postprocess(team);
	}
	thread globallogic::checkscorelimit();
}

/*
	Name: giveteamscoreforobjective
	Namespace: globallogic_score
	Checksum: 0xCFB22F95
	Offset: 0x1E78
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function giveteamscoreforobjective(team, score)
{
	if(!isdefined(level.teams[team]))
	{
		return;
	}
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
	Checksum: 0x897E89D4
	Offset: 0x1F40
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function _setteamscore(team, teamscore)
{
	if(teamscore == game["teamScores"][team])
	{
		return;
	}
	game["teamScores"][team] = math::clamp(teamscore, 0, 1000000);
	updateteamscores(team);
	thread globallogic::checkscorelimit();
}

/*
	Name: resetteamscores
	Namespace: globallogic_score
	Checksum: 0x7B63756D
	Offset: 0x1FD8
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
	Checksum: 0xBADEEF00
	Offset: 0x20A0
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
	Checksum: 0xED4FA3FD
	Offset: 0x20D0
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
	Checksum: 0x2031AE4C
	Offset: 0x2180
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
	Checksum: 0x9714EFB6
	Offset: 0x21D8
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
	Checksum: 0x237FD4D1
	Offset: 0x2270
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
	Checksum: 0x51614EA2
	Offset: 0x2298
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
	Checksum: 0x48FB0629
	Offset: 0x2398
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
	Checksum: 0x3A9F0DD5
	Offset: 0x2450
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function onteamscore(score, team)
{
	onteamscore_incrementscore(score, team);
	onteamscore_postprocess(team);
}

/*
	Name: onteamscore_incrementscore
	Namespace: globallogic_score
	Checksum: 0x272C69B8
	Offset: 0x24A0
	Size: 0xB2
	Parameters: 2
	Flags: Linked
*/
function onteamscore_incrementscore(score, team)
{
	game["teamScores"][team] = game["teamScores"][team] + score;
	if(game["teamScores"][team] < 0)
	{
		game["teamScores"][team] = 0;
	}
	if(level.scorelimit && game["teamScores"][team] > level.scorelimit)
	{
		game["teamScores"][team] = level.scorelimit;
	}
}

/*
	Name: onteamscore_postprocess
	Namespace: globallogic_score
	Checksum: 0x9A72E19D
	Offset: 0x2560
	Size: 0x208
	Parameters: 1
	Flags: Linked
*/
function onteamscore_postprocess(team)
{
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
	if(iswinning.size == 1)
	{
		level.laststatustime = gettime();
		foreach(team in iswinning)
		{
			if(isdefined(level.waswinning[team]))
			{
				if(level.waswinning.size == 1)
				{
					continue;
				}
			}
		}
	}
	else
	{
		return;
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
		}
	}
	level.waswinning = iswinning;
}

/*
	Name: default_onteamscore
	Namespace: globallogic_score
	Checksum: 0xBD492797
	Offset: 0x2770
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function default_onteamscore(event, team)
{
	score = rank::getscoreinfovalue(event);
	/#
		assert(isdefined(score));
	#/
	onteamscore(score, team);
}

/*
	Name: initpersstat
	Namespace: globallogic_score
	Checksum: 0x270C706C
	Offset: 0x27E8
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function initpersstat(dataname, record_stats)
{
	if(!isdefined(self.pers[dataname]))
	{
		self.pers[dataname] = 0;
	}
	if(!isdefined(record_stats) || record_stats == 1)
	{
		recordplayerstats(self, dataname, int(self.pers[dataname]));
	}
}

/*
	Name: getpersstat
	Namespace: globallogic_score
	Checksum: 0x5921CD07
	Offset: 0x2880
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
	Checksum: 0x541FF97F
	Offset: 0x28A0
	Size: 0xEC
	Parameters: 4
	Flags: Linked
*/
function incpersstat(dataname, increment, record_stats, includegametype)
{
	pixbeginevent("incPersStat");
	self.pers[dataname] = self.pers[dataname] + increment;
	if(isdefined(includegametype) && includegametype)
	{
		self addplayerstatwithgametype(dataname, increment);
	}
	else
	{
		self addplayerstat(dataname, increment);
	}
	if(!isdefined(record_stats) || record_stats == 1)
	{
		self thread threadedrecordplayerstats(dataname);
	}
	pixendevent();
}

/*
	Name: threadedrecordplayerstats
	Namespace: globallogic_score
	Checksum: 0x847B5AF8
	Offset: 0x2998
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
	Name: updatewinstats
	Namespace: globallogic_score
	Checksum: 0x8ED52756
	Offset: 0x29E0
	Size: 0x234
	Parameters: 1
	Flags: Linked
*/
function updatewinstats(winner)
{
	winner addplayerstatwithgametype("losses", -1);
	winner addplayerstatwithgametype("wins", 1);
	if(level.hardcoremode)
	{
		winner addplayerstat("wins_HC", 1);
	}
	if(level.multiteam)
	{
		winner addplayerstat("wins_MULTITEAM", 1);
	}
	winner updatestatratio("wlratio", "wins", "losses");
	restorewinstreaks(winner);
	winner addplayerstatwithgametype("cur_win_streak", 1);
	winner notify(#"win");
	cur_gamemode_win_streak = winner persistence::stat_get_with_gametype("cur_win_streak");
	gamemode_win_streak = winner persistence::stat_get_with_gametype("win_streak");
	cur_win_streak = winner getdstat("playerstatslist", "cur_win_streak", "StatValue");
	if(!level.disablestattracking && cur_win_streak > winner getdstat("HighestStats", "win_streak"))
	{
		winner setdstat("HighestStats", "win_streak", cur_win_streak);
	}
	if(cur_gamemode_win_streak > gamemode_win_streak)
	{
		winner persistence::stat_set_with_gametype("win_streak", cur_gamemode_win_streak);
	}
}

/*
	Name: updatelossstats
	Namespace: globallogic_score
	Checksum: 0x786B76D3
	Offset: 0x2C20
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function updatelossstats(loser)
{
	loser addplayerstatwithgametype("losses", 1);
	loser updatestatratio("wlratio", "wins", "losses");
	loser notify(#"loss");
}

/*
	Name: updatetiestats
	Namespace: globallogic_score
	Checksum: 0x745F448A
	Offset: 0x2C98
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function updatetiestats(loser)
{
	loser addplayerstatwithgametype("losses", -1);
	loser addplayerstatwithgametype("ties", 1);
	loser updatestatratio("wlratio", "wins", "losses");
	if(!level.disablestattracking)
	{
		loser setdstat("playerstatslist", "cur_win_streak", "StatValue", 0);
	}
	loser notify(#"tie");
}

/*
	Name: updatewinlossstats
	Namespace: globallogic_score
	Checksum: 0xE32AEBC0
	Offset: 0x2D68
	Size: 0x366
	Parameters: 1
	Flags: None
*/
function updatewinlossstats(winner)
{
	if(!util::waslastround() && !level.hostforcedend)
	{
		return;
	}
	players = level.players;
	if(!isdefined(winner) || (isdefined(winner) && !isplayer(winner) && winner == "tie"))
	{
		for(i = 0; i < players.size; i++)
		{
			if(!isdefined(players[i].pers["team"]))
			{
				continue;
			}
			if(level.hostforcedend && players[i] ishost())
			{
				continue;
			}
			updatetiestats(players[i]);
		}
	}
	else
	{
		if(isplayer(winner))
		{
			if(level.hostforcedend && winner ishost())
			{
				return;
			}
			updatewinstats(winner);
			if(!level.teambased)
			{
				placement = level.placement["all"];
				topthreeplayers = min(3, placement.size);
				for(index = 1; index < topthreeplayers; index++)
				{
					nexttopplayer = placement[index];
					updatewinstats(nexttopplayer);
				}
			}
		}
		else
		{
			for(i = 0; i < players.size; i++)
			{
				if(!isdefined(players[i].pers["team"]))
				{
					continue;
				}
				if(level.hostforcedend && players[i] ishost())
				{
					continue;
				}
				if(winner == "tie")
				{
					updatetiestats(players[i]);
					continue;
				}
				if(players[i].pers["team"] == winner)
				{
					updatewinstats(players[i]);
					continue;
				}
				if(!level.disablestattracking)
				{
					players[i] setdstat("playerstatslist", "cur_win_streak", "StatValue", 0);
				}
			}
		}
	}
}

/*
	Name: backupandclearwinstreaks
	Namespace: globallogic_score
	Checksum: 0x43637901
	Offset: 0x30D8
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function backupandclearwinstreaks()
{
	self.pers["winStreak"] = self getdstat("playerstatslist", "cur_win_streak", "StatValue");
	if(!level.disablestattracking)
	{
		self setdstat("playerstatslist", "cur_win_streak", "StatValue", 0);
	}
	self.pers["winStreakForGametype"] = persistence::stat_get_with_gametype("cur_win_streak");
	self persistence::stat_set_with_gametype("cur_win_streak", 0);
}

/*
	Name: restorewinstreaks
	Namespace: globallogic_score
	Checksum: 0x8FF4054E
	Offset: 0x31B0
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function restorewinstreaks(winner)
{
	if(!level.disablestattracking)
	{
		winner setdstat("playerstatslist", "cur_win_streak", "StatValue", winner.pers["winStreak"]);
	}
	winner persistence::stat_set_with_gametype("cur_win_streak", winner.pers["winStreakForGametype"]);
}

/*
	Name: inckillstreaktracker
	Namespace: globallogic_score
	Checksum: 0xEB8F5327
	Offset: 0x3240
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
	Checksum: 0x216623F7
	Offset: 0x32C0
	Size: 0x42C
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
	if(!isdefined(attacker.lastkilledvictim) || !isdefined(attacker.lastkilledvictimcount))
	{
		attacker.lastkilledvictim = name;
		attacker.lastkilledvictimcount = 0;
	}
	if(attacker.lastkilledvictim == name)
	{
		attacker.lastkilledvictimcount++;
		if(attacker.lastkilledvictimcount >= 5)
		{
			attacker.lastkilledvictimcount = 0;
			attacker addplayerstat("streaker", 1);
		}
	}
	else
	{
		attacker.lastkilledvictim = name;
		attacker.lastkilledvictimcount = 1;
	}
	pixendevent();
}

/*
	Name: trackattackeedeath
	Namespace: globallogic_score
	Checksum: 0xB7C94182
	Offset: 0x36F8
	Size: 0x264
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
	pixendevent();
}

/*
	Name: default_iskillboosting
	Namespace: globallogic_score
	Checksum: 0xFE7FC4D0
	Offset: 0x3968
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
	Checksum: 0x516D742E
	Offset: 0x3978
	Size: 0xA0C
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
		if(isdefined(evictim) && isplayer(evictim))
		{
			evictim recordkillmodifier("headshot");
		}
	}
	if(isdefined(evictim.lastflashedtime))
	{
		if((evictim.lastflashedtime + 2000) >= gettime())
		{
			self addweaponstat(getweapon("flash_grenade"), "CombatRecordStat", 1);
		}
	}
	if(isdefined(evictim.var_63fb6c7d))
	{
		if((evictim.var_63fb6c7d + 2000) >= gettime())
		{
			self addweaponstat(getweapon("proximity_grenade"), "CombatRecordStat", 1);
		}
	}
	if(isdefined(evictim.var_4d6fef21))
	{
		if((evictim.var_4d6fef21 + 2000) >= gettime())
		{
			self addweaponstat(getweapon("emp_grenade"), "CombatRecordStat", 1);
		}
	}
	if(isdefined(evictim.var_7097b5af))
	{
		if((evictim.var_7097b5af + 2000) >= gettime())
		{
			function_28c6cf9e(getitemindexfromref("cybercom_ravagecore"));
		}
	}
	if(isdefined(weapon))
	{
		weaponpickedup = 0;
		if(isdefined(attacker.pickedupweapons) && isdefined(attacker.pickedupweapons[weapon]))
		{
			weaponpickedup = 1;
		}
		attacker addweaponstat(weapon, "kills", 1, attacker.class_num, weaponpickedup, undefined, attacker.primaryloadoutgunsmithvariantindex, attacker.secondaryloadoutgunsmithvariantindex);
		if(smeansofdeath == "MOD_HEAD_SHOT")
		{
			attacker addweaponstat(weapon, "headshots", 1, attacker.class_num, weaponpickedup, undefined, attacker.primaryloadoutgunsmithvariantindex, attacker.secondaryloadoutgunsmithvariantindex);
		}
		if(weapon.name == "launcher_standard_df" || weapon.name == "launcher_standard")
		{
			if(weapon.name == "launcher_standard_df")
			{
				weapon = getweapon("launcher_standard");
			}
			else
			{
				weapon = getweapon("launcher_standard_df");
			}
			attacker addweaponstat(weapon, "kills", 1, attacker.class_num, weaponpickedup, undefined, attacker.primaryloadoutgunsmithvariantindex, attacker.secondaryloadoutgunsmithvariantindex);
			if(smeansofdeath == "MOD_HEAD_SHOT")
			{
				attacker addweaponstat(weapon, "headshots", 1, attacker.class_num, weaponpickedup, undefined, attacker.primaryloadoutgunsmithvariantindex, attacker.secondaryloadoutgunsmithvariantindex);
			}
		}
	}
	if(isplayer(attacker))
	{
		itemindex = undefined;
		if(weapon.name == "gadget_firefly_swarm" || weapon.name == "gadget_firefly_swarm_upgraded")
		{
			itemindex = getitemindexfromref("cybercom_fireflyswarm");
		}
		else
		{
			if(weapon.name == "hero_gravityspikes_cybercom" || weapon.name == "hero_gravityspikes_cybercom_upgraded")
			{
				itemindex = getitemindexfromref("cybercom_concussive");
			}
			else
			{
				if(weapon.name == "gadget_unstoppable_force" || weapon.name == "gadget_unstoppable_force_upgraded")
				{
					itemindex = getitemindexfromref("cybercom_unstoppableforce");
				}
				else
				{
					if(weapon.name == "gadget_es_strike")
					{
						itemindex = getitemindexfromref("cybercom_es_strike");
					}
					else if(weapon.name == "amws_gun_turret_player" || weapon.name == "hunter_main_turret_player" || weapon.name == "hunter_side_turret_player" || weapon.name == "pamws_gun_turret_player" || weapon.name == "quadtank_side_turret_player" || weapon.name == "siegebot_gun_turret_player" || weapon.name == "wasp_main_turret_player" || weapon.name == "amws_launcher_turret_player" || weapon.name == "hunter_rocket_turret_player" || weapon.name == "pamws_launcher_turret_player" || weapon.name == "quadtank_main_turret_player" || weapon.name == "rocket_wasp_launcher_turret_player" || weapon.name == "siegebot_launcher_turret_player")
					{
						itemindex = getitemindexfromref("cybercom_hijack");
					}
				}
			}
		}
		function_28c6cf9e(itemindex);
		if(isdefined(attacker.active_camo) && attacker.active_camo)
		{
			function_28c6cf9e(getitemindexfromref("cybercom_camo"));
		}
		if(isdefined(evictim.enemy) && isdefined(evictim.enemy.var_e42818a3) && evictim.enemy.var_e42818a3)
		{
			function_28c6cf9e(getitemindexfromref("cybercom_misdirection"));
		}
		if(attacker flagsys::get("gadget_overdrive_on"))
		{
			function_28c6cf9e(getitemindexfromref("cybercom_overdrive"));
		}
		if(isdefined(evictim.var_d90f9ddb) && evictim.var_d90f9ddb)
		{
			function_28c6cf9e(getitemindexfromref("cybercom_smokescreen"));
		}
	}
	pixendevent();
}

/*
	Name: function_28c6cf9e
	Namespace: globallogic_score
	Checksum: 0x837E9E53
	Offset: 0x4390
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_28c6cf9e(itemindex)
{
	if(isdefined(itemindex))
	{
		self adddstat("ItemStats", itemindex, "stats", "kills", "statValue", 1);
	}
}

/*
	Name: inctotalkills
	Namespace: globallogic_score
	Checksum: 0x6F84E06C
	Offset: 0x43F0
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
	Checksum: 0x2EDD3C55
	Offset: 0x4448
	Size: 0x194
	Parameters: 3
	Flags: Linked
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
		if(weapon.name == "concussion_grenade" || weapon.name == "tabun_gas")
		{
			eattacker addweaponstat(weapon, "used", 1);
		}
		eattacker addweaponstat(weapon, "hits", 1);
	}
}

/*
	Name: processshieldassist
	Namespace: globallogic_score
	Checksum: 0x61651588
	Offset: 0x45E8
	Size: 0x10C
	Parameters: 1
	Flags: Linked
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
	scoreevents::processscoreevent("shield_assist", self, killedplayer, "riotshield");
}

/*
	Name: processassist
	Namespace: globallogic_score
	Checksum: 0x3FC4CDDA
	Offset: 0x4700
	Size: 0x20C
	Parameters: 4
	Flags: Linked
*/
function processassist(killed_sentient, damagedone, weapon, assist_level)
{
	self endon(#"disconnect");
	killed_sentient endon(#"disconnect");
	wait(0.05);
	util::waittillslowprocessallowed();
	if(!isdefined(level.teams[self.team]))
	{
		return;
	}
	if(isdefined(killed_sentient) && isdefined(killed_sentient.team) && self.team == killed_sentient.team)
	{
		return;
	}
	if(!level.teambased)
	{
		return;
	}
	if(!isdefined(assist_level))
	{
		assist_level = "assist";
	}
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
	if(isdefined(weapon))
	{
		self addweaponstat(weapon, "assists", 1);
	}
	self challenges::assisted();
	scoreevents::processscoreevent(assist_level, self, killed_sentient, weapon);
}

/*
	Name: xpratethread
	Namespace: globallogic_score
	Checksum: 0x574E664D
	Offset: 0x4918
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function xpratethread()
{
	/#
		self endon(#"death");
		self endon(#"disconnect");
		level endon(#"game_ended");
		while(level.inprematchperiod)
		{
			wait(0.05);
		}
		for(;;)
		{
			wait(5);
			if(isdefined(level.teams[level.players[0].pers[""]]))
			{
				self rank::giverankxp("", int(min(getdvarint(""), 50)));
			}
		}
	#/
}

