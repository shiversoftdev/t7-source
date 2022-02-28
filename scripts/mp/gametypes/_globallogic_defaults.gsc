// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\rank_shared;

#namespace globallogic_defaults;

/*
	Name: getwinningteamfromloser
	Namespace: globallogic_defaults
	Checksum: 0x8DF8B8F1
	Offset: 0x398
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
	Checksum: 0xFB1EA538
	Offset: 0x3D8
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
	Checksum: 0xB6C86EFE
	Offset: 0x708
	Size: 0x184
	Parameters: 1
	Flags: None
*/
function default_ondeadevent(team)
{
	if(isdefined(level.teams[team]))
	{
		eliminatedstring = game["strings"][team + "_eliminated"];
		iprintln(eliminatedstring);
		setdvar("ui_text_endreason", eliminatedstring);
		winner = getwinningteamfromloser(team);
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
	Name: default_onlastteamaliveevent
	Namespace: globallogic_defaults
	Checksum: 0x5C855532
	Offset: 0x898
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
	Name: default_onalivecountchange
	Namespace: globallogic_defaults
	Checksum: 0x4962028E
	Offset: 0xA28
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
	Checksum: 0x514CB902
	Offset: 0xA40
	Size: 0x10
	Parameters: 1
	Flags: Linked
*/
function default_onroundendgame(winner)
{
	return winner;
}

/*
	Name: default_determinewinner
	Namespace: globallogic_defaults
	Checksum: 0xB8C6ADC2
	Offset: 0xA58
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function default_determinewinner(roundwinner)
{
	if(isdefined(game["overtime_round"]))
	{
		if(isdefined(level.doubleovertime) && level.doubleovertime && isdefined(roundwinner) && roundwinner != "tie")
		{
			return roundwinner;
		}
		return globallogic::determineteamwinnerbygamestat("overtimeroundswon");
	}
	if(level.scoreroundwinbased)
	{
		winner = globallogic::determineteamwinnerbygamestat("roundswon");
	}
	else
	{
		winner = globallogic::determineteamwinnerbyteamscore();
	}
	return winner;
}

/*
	Name: default_ononeleftevent
	Namespace: globallogic_defaults
	Checksum: 0xAAFA2D5
	Offset: 0xB18
	Size: 0x16E
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
			player globallogic_audio::leader_dialog_on_player("sudden_death");
		}
	}
}

/*
	Name: default_ontimelimit
	Namespace: globallogic_defaults
	Checksum: 0xE8CA93A2
	Offset: 0xC90
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
	Checksum: 0x8744E956
	Offset: 0xDC0
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
	Name: default_onroundscorelimit
	Namespace: globallogic_defaults
	Checksum: 0xC38E51E7
	Offset: 0xF00
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function default_onroundscorelimit()
{
	winner = undefined;
	if(level.teambased)
	{
		winner = globallogic::determineteamwinnerbygamestat("teamScores");
		globallogic_utils::logteamwinstring("roundscorelimit", winner);
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
	setdvar("ui_text_endreason", game["strings"]["round_score_limit_reached"]);
	thread globallogic::endgame(winner, game["strings"]["round_score_limit_reached"]);
	return true;
}

/*
	Name: default_onspawnspectator
	Namespace: globallogic_defaults
	Checksum: 0x9CFE9988
	Offset: 0x1030
	Size: 0xDC
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
	spawnpoints = spawnlogic::_get_spawnpoint_array("mp_global_intermission");
	/#
		assert(spawnpoints.size, "");
	#/
	spawnpoint = spawnlogic::get_spawnpoint_random(spawnpoints);
	self spawn(spawnpoint.origin, spawnpoint.angles);
}

/*
	Name: default_onspawnintermission
	Namespace: globallogic_defaults
	Checksum: 0x1ADD1C18
	Offset: 0x1118
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function default_onspawnintermission(endgame)
{
	if(isdefined(endgame) && endgame)
	{
		return;
	}
	spawnpoint = spawnlogic::get_random_intermission_point();
	if(isdefined(spawnpoint))
	{
		self spawn(spawnpoint.origin, spawnpoint.angles);
	}
	else
	{
		/#
			util::error("");
		#/
	}
}

/*
	Name: default_gettimelimit
	Namespace: globallogic_defaults
	Checksum: 0xF0091284
	Offset: 0x11C0
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
	Checksum: 0x58CBC9F
	Offset: 0x1208
	Size: 0x76
	Parameters: 4
	Flags: Linked
*/
function default_getteamkillpenalty(einflictor, attacker, smeansofdeath, weapon)
{
	teamkill_penalty = 1;
	if(killstreaks::is_killstreak_weapon(weapon))
	{
		teamkill_penalty = teamkill_penalty * killstreaks::get_killstreak_team_kill_penalty_scale(weapon);
	}
	return teamkill_penalty;
}

/*
	Name: default_getteamkillscore
	Namespace: globallogic_defaults
	Checksum: 0x7D4FFA17
	Offset: 0x1288
	Size: 0x3A
	Parameters: 4
	Flags: Linked
*/
function default_getteamkillscore(einflictor, attacker, smeansofdeath, weapon)
{
	return rank::getscoreinfovalue("team_kill");
}

