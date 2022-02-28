// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\math_shared;
#using scripts\zm\_util;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_audio;
#using scripts\zm\gametypes\_globallogic_score;
#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_spawnlogic;

#namespace globallogic_defaults;

/*
	Name: getwinningteamfromloser
	Namespace: globallogic_defaults
	Checksum: 0x14D14D3D
	Offset: 0x2B0
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
	Checksum: 0xAE330B20
	Offset: 0x2F0
	Size: 0x2C4
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
	Checksum: 0x5FBEAD3
	Offset: 0x5C0
	Size: 0x184
	Parameters: 1
	Flags: Linked
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
	Name: default_onalivecountchange
	Namespace: globallogic_defaults
	Checksum: 0x4F978BC1
	Offset: 0x750
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
	Checksum: 0xCCD9333A
	Offset: 0x768
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
	Checksum: 0xB23BC7EE
	Offset: 0x780
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
			player globallogic_audio::leaderdialogonplayer("sudden_death");
		}
	}
}

/*
	Name: default_ontimelimit
	Namespace: globallogic_defaults
	Checksum: 0x49F6D004
	Offset: 0x8F8
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
	Checksum: 0x97EFAFFD
	Offset: 0xA28
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
	Checksum: 0x8CF46196
	Offset: 0xB68
	Size: 0xFC
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
	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	/#
		assert(spawnpoints.size, "");
	#/
	spawnpoint = spawnlogic::getspawnpoint_random(spawnpoints);
	self spawn(spawnpoint.origin, spawnpoint.angles);
}

/*
	Name: default_onspawnintermission
	Namespace: globallogic_defaults
	Checksum: 0x36A195A3
	Offset: 0xC70
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function default_onspawnintermission()
{
	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
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
	Checksum: 0xED10C520
	Offset: 0xD38
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function default_gettimelimit()
{
	return math::clamp(getgametypesetting("timeLimit"), level.timelimitmin, level.timelimitmax);
}

