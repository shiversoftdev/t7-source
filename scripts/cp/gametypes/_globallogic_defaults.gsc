// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_globallogic_utils;
#using scripts\cp\gametypes\_spawnlogic;
#using scripts\shared\math_shared;
#using scripts\shared\rank_shared;

#namespace globallogic_defaults;

/*
	Name: getwinningteamfromloser
	Namespace: globallogic_defaults
	Checksum: 0x1D8E98FB
	Offset: 0x2D8
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function getwinningteamfromloser(losing_team)
{
	if(level.multiteam)
	{
		return "tie";
	}
	return util::getotherteam(losing_team);
}

/*
	Name: default_onforfeit
	Namespace: globallogic_defaults
	Checksum: 0xEC77D729
	Offset: 0x318
	Size: 0x324
	Parameters: 1
	Flags: Linked
*/
function default_onforfeit(team)
{
	level.gameforfeited = 1;
	level notify(#"hash_d343f3a0");
	level endon(#"hash_d343f3a0");
	level endon(#"hash_577494dc");
	forfeit_delay = 20;
	announcement(game["strings"]["opponent_forfeiting_in"], forfeit_delay, 0);
	wait(10);
	announcement(game["strings"]["opponent_forfeiting_in"], 10, 0);
	wait(10);
	endreason = &"";
	if(level.multiteam)
	{
		setdvar("ui_text_endreason", game["strings"]["other_teams_forfeited"]);
		endreason = game["strings"]["other_teams_forfeited"];
		winner = team;
	}
	else
	{
		if(!isdefined(team))
		{
			setdvar("ui_text_endreason", game["strings"]["players_forfeited"]);
			endreason = game["strings"]["players_forfeited"];
			winner = level.players[0];
		}
		else
		{
			if(isdefined(level.teams[team]))
			{
				endreason = game["strings"][team + "_forfeited"];
				setdvar("ui_text_endreason", endreason);
				winner = getwinningteamfromloser(team);
			}
			else
			{
				/#
					assert(isdefined(team), "");
				#/
				/#
					assert(0, ("" + team) + "");
				#/
				winner = "tie";
			}
		}
	}
	level.forcedend = 1;
	/#
		if(isplayer(winner))
		{
			print(((("" + winner getxuid()) + "") + winner.name) + "");
		}
		else
		{
			globallogic_utils::logteamwinstring("", winner);
		}
	#/
	thread globallogic::endgame(winner, endreason);
}

/*
	Name: default_ondeadevent
	Namespace: globallogic_defaults
	Checksum: 0x8248F09F
	Offset: 0x648
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function default_ondeadevent(team)
{
	if(team == "all")
	{
		winner = level.enemy_ai_team;
		globallogic_utils::logteamwinstring("team eliminated", winner);
		thread globallogic::endgame(winner, &"SM_ALL_PLAYERS_KILLED");
	}
	else
	{
		winner = getwinningteamfromloser(team);
		globallogic_utils::logteamwinstring("team eliminated", winner);
		thread globallogic::endgame(winner, &"SM_ALL_PLAYERS_KILLED");
	}
}

/*
	Name: default_onlastteamaliveevent
	Namespace: globallogic_defaults
	Checksum: 0xB17C3EAF
	Offset: 0x718
	Size: 0x184
	Parameters: 1
	Flags: Linked
*/
function default_onlastteamaliveevent(team)
{
	if(isdefined(level.teams[team]))
	{
		eliminatedstring = game["strings"]["enemies_eliminated"];
		iprintln(eliminatedstring);
		setdvar("ui_text_endreason", eliminatedstring);
		winner = globallogic::determineteamwinnerbygamestat("teamScores");
		globallogic_utils::logteamwinstring("team eliminated", winner);
		thread globallogic::endgame(winner, eliminatedstring);
	}
	else
	{
		setdvar("ui_text_endreason", game["strings"]["tie"]);
		globallogic_utils::logteamwinstring("tie");
		if(level.teambased)
		{
			thread globallogic::endgame("tie", game["strings"]["tie"]);
		}
		else
		{
			thread globallogic::endgame(undefined, game["strings"]["tie"]);
		}
	}
}

/*
	Name: things_exist_which_could_revive_player
	Namespace: globallogic_defaults
	Checksum: 0x1C661E8A
	Offset: 0x8A8
	Size: 0xE
	Parameters: 1
	Flags: Linked
*/
function things_exist_which_could_revive_player(team)
{
	return false;
}

/*
	Name: team_can_be_revived
	Namespace: globallogic_defaults
	Checksum: 0x4D3D9222
	Offset: 0x8C0
	Size: 0xAE
	Parameters: 1
	Flags: Linked
*/
function team_can_be_revived(team)
{
	if(things_exist_which_could_revive_player(team))
	{
		return true;
	}
	if(level.playercount[team] == 1 && level.alivecount[team] == 1)
	{
		/#
			assert(level.aliveplayers[team].size == 1);
		#/
		if(level.aliveplayers[team][0].lives > 0)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: default_onlaststandevent
	Namespace: globallogic_defaults
	Checksum: 0xD888D4D
	Offset: 0x978
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function default_onlaststandevent(team)
{
	if(team_can_be_revived(team))
	{
		return;
	}
	if(team == "all")
	{
		thread globallogic::endgame(level.enemy_ai_team, &"SM_ALL_PLAYERS_KILLED");
	}
	else
	{
		thread globallogic::endgame(util::getotherteam(team), &"SM_ALL_PLAYERS_KILLED");
	}
}

/*
	Name: default_onalivecountchange
	Namespace: globallogic_defaults
	Checksum: 0x8B5C3696
	Offset: 0xA18
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function default_onalivecountchange(team)
{
}

/*
	Name: default_onroundendgame
	Namespace: globallogic_defaults
	Checksum: 0x302553B9
	Offset: 0xA30
	Size: 0x10
	Parameters: 1
	Flags: Linked
*/
function default_onroundendgame(winner)
{
	return winner;
}

/*
	Name: default_ononeleftevent
	Namespace: globallogic_defaults
	Checksum: 0x4DE415D7
	Offset: 0xA48
	Size: 0x154
	Parameters: 1
	Flags: Linked
*/
function default_ononeleftevent(team)
{
	if(!level.teambased)
	{
		winner = globallogic_score::gethighestscoringplayer();
		/#
			if(isdefined(winner))
			{
				print("" + winner.name);
			}
			else
			{
				print("");
			}
		#/
		thread globallogic::endgame(winner, &"MP_ENEMIES_ELIMINATED");
	}
	else
	{
		for(index = 0; index < level.players.size; index++)
		{
			player = level.players[index];
			if(!isalive(player))
			{
				continue;
			}
			if(!isdefined(player.pers["team"]) || player.pers["team"] != team)
			{
				continue;
			}
		}
	}
}

/*
	Name: default_ontimelimit
	Namespace: globallogic_defaults
	Checksum: 0x482C3A2B
	Offset: 0xBA8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function default_ontimelimit()
{
	winner = undefined;
	if(level.teambased)
	{
		winner = globallogic::determineteamwinnerbygamestat("teamScores");
		globallogic_utils::logteamwinstring("time limit", winner);
	}
	else
	{
		winner = globallogic_score::gethighestscoringplayer();
		/#
			if(isdefined(winner))
			{
				print("" + winner.name);
			}
			else
			{
				print("");
			}
		#/
	}
	setdvar("ui_text_endreason", game["strings"]["time_limit_reached"]);
	thread globallogic::endgame(winner, game["strings"]["time_limit_reached"]);
}

/*
	Name: default_onscorelimit
	Namespace: globallogic_defaults
	Checksum: 0x8419719F
	Offset: 0xCD8
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function default_onscorelimit()
{
	if(!level.endgameonscorelimit)
	{
		return false;
	}
	winner = undefined;
	if(level.teambased)
	{
		winner = globallogic::determineteamwinnerbygamestat("teamScores");
		globallogic_utils::logteamwinstring("scorelimit", winner);
	}
	else
	{
		winner = globallogic_score::gethighestscoringplayer();
		/#
			if(isdefined(winner))
			{
				print("" + winner.name);
			}
			else
			{
				print("");
			}
		#/
	}
	setdvar("ui_text_endreason", game["strings"]["score_limit_reached"]);
	thread globallogic::endgame(winner, game["strings"]["score_limit_reached"]);
	return true;
}

/*
	Name: default_onspawnspectator
	Namespace: globallogic_defaults
	Checksum: 0x52CBDF0E
	Offset: 0xE18
	Size: 0x1A4
	Parameters: 2
	Flags: Linked
*/
function default_onspawnspectator(origin, angles)
{
	if(isdefined(origin) && isdefined(angles))
	{
		self spawn(origin, angles);
		return;
	}
	spawnpointname = "cp_global_intermission";
	spawnpoints = struct::get_array(spawnpointname, "targetname");
	/#
		assert(spawnpoints.size, ("" + spawnpointname) + "");
	#/
	spawnpoint = spawnlogic::get_spawnpoint_random(spawnpoints);
	/#
		assert(isdefined(spawnpoint.origin), ("" + spawnpointname) + "");
	#/
	/#
		assert(isdefined(spawnpoint.angles), ((("" + spawnpointname) + "") + spawnpoint.origin) + "");
	#/
	self spawn(spawnpoint.origin, spawnpoint.angles);
}

/*
	Name: default_onspawnintermission
	Namespace: globallogic_defaults
	Checksum: 0x239EF23E
	Offset: 0xFC8
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function default_onspawnintermission()
{
	spawnpointname = "cp_global_intermission";
	spawnpoints = struct::get_array(spawnpointname, "targetname");
	spawnpoint = spawnpoints[0];
	if(isdefined(spawnpoint))
	{
		self spawn(spawnpoint.origin, spawnpoint.angles);
	}
	else
	{
		/#
			util::error(("" + spawnpointname) + "");
		#/
	}
}

/*
	Name: default_gettimelimit
	Namespace: globallogic_defaults
	Checksum: 0xEEEB70B4
	Offset: 0x1090
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function default_gettimelimit()
{
	return math::clamp(getgametypesetting("timeLimit"), level.timelimitmin, level.timelimitmax);
}

/*
	Name: default_getteamkillpenalty
	Namespace: globallogic_defaults
	Checksum: 0x6C66B424
	Offset: 0x10D8
	Size: 0x72
	Parameters: 4
	Flags: Linked
*/
function default_getteamkillpenalty(einflictor, attacker, smeansofdeath, weapon)
{
	teamkill_penalty = 1;
	score = globallogic_score::_getplayerscore(attacker);
	if(score == 0)
	{
		teamkill_penalty = 2;
	}
	return teamkill_penalty;
}

/*
	Name: default_getteamkillscore
	Namespace: globallogic_defaults
	Checksum: 0xCA25ED86
	Offset: 0x1158
	Size: 0x3A
	Parameters: 4
	Flags: Linked
*/
function default_getteamkillscore(einflictor, attacker, smeansofdeath, weapon)
{
	return rank::getscoreinfovalue("team_kill");
}

