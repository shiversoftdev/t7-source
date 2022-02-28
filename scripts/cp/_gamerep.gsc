// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\rank_shared;

#namespace gamerep;

/*
	Name: init
	Namespace: gamerep
	Checksum: 0x4B2B4D9B
	Offset: 0x1D0
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function init()
{
	if(!isgamerepenabled())
	{
		return;
	}
	if(isgamerepinitialized())
	{
		return;
	}
	game["gameRepInitialized"] = 1;
	game["gameRep"]["players"] = [];
	game["gameRep"]["playerNames"] = [];
	game["gameRep"]["max"] = [];
	game["gameRep"]["playerCount"] = 0;
	gamerepinitializeparams();
}

/*
	Name: isgamerepinitialized
	Namespace: gamerep
	Checksum: 0x4B1A9B20
	Offset: 0x290
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function isgamerepinitialized()
{
	if(!isdefined(game["gameRepInitialized"]) || !game["gameRepInitialized"])
	{
		return false;
	}
	return true;
}

/*
	Name: isgamerepenabled
	Namespace: gamerep
	Checksum: 0xA2229568
	Offset: 0x2C8
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function isgamerepenabled()
{
	if(sessionmodeiszombiesgame())
	{
		return false;
	}
	if(!level.rankedmatch)
	{
		return false;
	}
	return true;
}

/*
	Name: gamerepinitializeparams
	Namespace: gamerep
	Checksum: 0x69D31229
	Offset: 0x300
	Size: 0xDDA
	Parameters: 0
	Flags: Linked
*/
function gamerepinitializeparams()
{
	threshold_exceeded_score = 0;
	threshold_exceeded_score_per_min = 1;
	threshold_exceeded_kills = 2;
	threshold_exceeded_deaths = 3;
	threshold_exceeded_kd_ratio = 4;
	threshold_exceeded_kills_per_min = 5;
	threshold_exceeded_plants = 6;
	threshold_exceeded_defuses = 7;
	threshold_exceeded_captures = 8;
	threshold_exceeded_defends = 9;
	threshold_exceeded_total_time_played = 10;
	threshold_exceeded_tactical_insertion_use = 11;
	threshold_exceeded_join_attempts = 12;
	threshold_exceeded_xp = 13;
	threshold_exceeded_splitscreen = 14;
	game["gameRep"]["params"] = [];
	game["gameRep"]["params"][0] = "score";
	game["gameRep"]["params"][1] = "scorePerMin";
	game["gameRep"]["params"][2] = "kills";
	game["gameRep"]["params"][3] = "deaths";
	game["gameRep"]["params"][4] = "killDeathRatio";
	game["gameRep"]["params"][5] = "killsPerMin";
	game["gameRep"]["params"][6] = "plants";
	game["gameRep"]["params"][7] = "defuses";
	game["gameRep"]["params"][8] = "captures";
	game["gameRep"]["params"][9] = "defends";
	game["gameRep"]["params"][10] = "totalTimePlayed";
	game["gameRep"]["params"][11] = "tacticalInsertions";
	game["gameRep"]["params"][12] = "joinAttempts";
	game["gameRep"]["params"][13] = "xp";
	game["gameRep"]["ignoreParams"] = [];
	game["gameRep"]["ignoreParams"][0] = "totalTimePlayed";
	game["gameRep"]["gameLimit"] = [];
	game["gameRep"]["gameLimit"]["default"] = [];
	game["gameRep"]["gameLimit"]["tdm"] = [];
	game["gameRep"]["gameLimit"]["dm"] = [];
	game["gameRep"]["gameLimit"]["dom"] = [];
	game["gameRep"]["gameLimit"]["hq"] = [];
	game["gameRep"]["gameLimit"]["sd"] = [];
	game["gameRep"]["gameLimit"]["dem"] = [];
	game["gameRep"]["gameLimit"]["ctf"] = [];
	game["gameRep"]["gameLimit"]["koth"] = [];
	game["gameRep"]["gameLimit"]["conf"] = [];
	game["gameRep"]["gameLimit"]["id"]["score"] = threshold_exceeded_score;
	game["gameRep"]["gameLimit"]["default"]["score"] = 20000;
	game["gameRep"]["gameLimit"]["id"]["scorePerMin"] = threshold_exceeded_score_per_min;
	game["gameRep"]["gameLimit"]["default"]["scorePerMin"] = 250;
	game["gameRep"]["gameLimit"]["dem"]["scorePerMin"] = 1000;
	game["gameRep"]["gameLimit"]["tdm"]["scorePerMin"] = 700;
	game["gameRep"]["gameLimit"]["dm"]["scorePerMin"] = 950;
	game["gameRep"]["gameLimit"]["dom"]["scorePerMin"] = 1000;
	game["gameRep"]["gameLimit"]["sd"]["scorePerMin"] = 200;
	game["gameRep"]["gameLimit"]["ctf"]["scorePerMin"] = 600;
	game["gameRep"]["gameLimit"]["hq"]["scorePerMin"] = 1000;
	game["gameRep"]["gameLimit"]["koth"]["scorePerMin"] = 1000;
	game["gameRep"]["gameLimit"]["conf"]["scorePerMin"] = 1000;
	game["gameRep"]["gameLimit"]["id"]["kills"] = threshold_exceeded_kills;
	game["gameRep"]["gameLimit"]["default"]["kills"] = 75;
	game["gameRep"]["gameLimit"]["tdm"]["kills"] = 40;
	game["gameRep"]["gameLimit"]["sd"]["kills"] = 15;
	game["gameRep"]["gameLimit"]["dm"]["kills"] = 31;
	game["gameRep"]["gameLimit"]["id"]["deaths"] = threshold_exceeded_deaths;
	game["gameRep"]["gameLimit"]["default"]["deaths"] = 50;
	game["gameRep"]["gameLimit"]["dm"]["deaths"] = 15;
	game["gameRep"]["gameLimit"]["tdm"]["deaths"] = 40;
	game["gameRep"]["gameLimit"]["id"]["killDeathRatio"] = threshold_exceeded_kd_ratio;
	game["gameRep"]["gameLimit"]["default"]["killDeathRatio"] = 30;
	game["gameRep"]["gameLimit"]["tdm"]["killDeathRatio"] = 50;
	game["gameRep"]["gameLimit"]["sd"]["killDeathRatio"] = 20;
	game["gameRep"]["gameLimit"]["id"]["killsPerMin"] = threshold_exceeded_kills_per_min;
	game["gameRep"]["gameLimit"]["default"]["killsPerMin"] = 15;
	game["gameRep"]["gameLimit"]["id"]["plants"] = threshold_exceeded_plants;
	game["gameRep"]["gameLimit"]["default"]["plants"] = 10;
	game["gameRep"]["gameLimit"]["id"]["defuses"] = threshold_exceeded_defuses;
	game["gameRep"]["gameLimit"]["default"]["defuses"] = 10;
	game["gameRep"]["gameLimit"]["id"]["captures"] = threshold_exceeded_captures;
	game["gameRep"]["gameLimit"]["default"]["captures"] = 30;
	game["gameRep"]["gameLimit"]["id"]["defends"] = threshold_exceeded_defends;
	game["gameRep"]["gameLimit"]["default"]["defends"] = 50;
	game["gameRep"]["gameLimit"]["id"]["totalTimePlayed"] = threshold_exceeded_total_time_played;
	game["gameRep"]["gameLimit"]["default"]["totalTimePlayed"] = 600;
	game["gameRep"]["gameLimit"]["dom"]["totalTimePlayed"] = 600;
	game["gameRep"]["gameLimit"]["dem"]["totalTimePlayed"] = 1140;
	game["gameRep"]["gameLimit"]["id"]["tacticalInsertions"] = threshold_exceeded_tactical_insertion_use;
	game["gameRep"]["gameLimit"]["default"]["tacticalInsertions"] = 20;
	game["gameRep"]["gameLimit"]["id"]["joinAttempts"] = threshold_exceeded_join_attempts;
	game["gameRep"]["gameLimit"]["default"]["joinAttempts"] = 3;
	game["gameRep"]["gameLimit"]["id"]["xp"] = threshold_exceeded_xp;
	game["gameRep"]["gameLimit"]["default"]["xp"] = 25000;
	game["gameRep"]["gameLimit"]["id"]["splitscreen"] = threshold_exceeded_splitscreen;
	game["gameRep"]["gameLimit"]["default"]["splitscreen"] = 8;
}

/*
	Name: gamerepplayerconnected
	Namespace: gamerep
	Checksum: 0x1A2329DB
	Offset: 0x10E8
	Size: 0x2C2
	Parameters: 0
	Flags: Linked
*/
function gamerepplayerconnected()
{
	if(!isgamerepenabled())
	{
		return;
	}
	name = self.name;
	/#
	#/
	if(!isdefined(game["gameRep"]["players"][name]))
	{
		game["gameRep"]["players"][name] = [];
		for(j = 0; j < game["gameRep"]["params"].size; j++)
		{
			paramname = game["gameRep"]["params"][j];
			game["gameRep"]["players"][name][paramname] = 0;
		}
		game["gameRep"]["players"][name]["splitscreen"] = self issplitscreen();
		game["gameRep"]["players"][name]["joinAttempts"] = 1;
		game["gameRep"]["players"][name]["connected"] = 1;
		game["gameRep"]["players"][name]["xpStart"] = self rank::getrankxpstat();
		game["gameRep"]["playerNames"][game["gameRep"]["playerCount"]] = name;
		game["gameRep"]["playerCount"]++;
	}
	else if(!game["gameRep"]["players"][name]["connected"])
	{
		game["gameRep"]["players"][name]["joinAttempts"]++;
		game["gameRep"]["players"][name]["connected"] = 1;
		game["gameRep"]["players"][name]["xpStart"] = self rank::getrankxpstat();
	}
}

/*
	Name: gamerepplayerdisconnected
	Namespace: gamerep
	Checksum: 0x70A715F8
	Offset: 0x13B8
	Size: 0xC6
	Parameters: 0
	Flags: Linked
*/
function gamerepplayerdisconnected()
{
	if(!isgamerepenabled())
	{
		return;
	}
	name = self.name;
	if(!isdefined(game["gameRep"]["players"][name]) || !isdefined(self.pers["summary"]))
	{
		return;
	}
	/#
	#/
	self gamerepupdatenonpersistentplayerinformation();
	self gamerepupdatepersistentplayerinformation();
	game["gameRep"]["players"][name]["connected"] = 0;
}

/*
	Name: gamerepupdatenonpersistentplayerinformation
	Namespace: gamerep
	Checksum: 0xDD5F139C
	Offset: 0x1488
	Size: 0xFA
	Parameters: 0
	Flags: Linked
*/
function gamerepupdatenonpersistentplayerinformation()
{
	name = self.name;
	if(!isdefined(game["gameRep"]["players"][name]))
	{
		return;
	}
	game["gameRep"]["players"][name]["totalTimePlayed"] = game["gameRep"]["players"][name]["totalTimePlayed"] + self.timeplayed["total"];
	if(isdefined(self.tacticalinsertioncount))
	{
		game["gameRep"]["players"][name]["tacticalInsertions"] = game["gameRep"]["players"][name]["tacticalInsertions"] + self.tacticalinsertioncount;
	}
}

/*
	Name: gamerepupdatepersistentplayerinformation
	Namespace: gamerep
	Checksum: 0xDA523747
	Offset: 0x1590
	Size: 0x472
	Parameters: 0
	Flags: Linked
*/
function gamerepupdatepersistentplayerinformation()
{
	name = self.name;
	if(!isdefined(game["gameRep"]["players"][name]))
	{
		return;
	}
	if(game["gameRep"]["players"][name]["totalTimePlayed"] != 0)
	{
		timeplayed = game["gameRep"]["players"][name]["totalTimePlayed"];
	}
	else
	{
		timeplayed = 1;
	}
	game["gameRep"]["players"][name]["score"] = self.score;
	game["gameRep"]["players"][name]["scorePerMin"] = int(game["gameRep"]["players"][name]["score"] / (timeplayed / 60));
	game["gameRep"]["players"][name]["kills"] = self.kills;
	game["gameRep"]["players"][name]["deaths"] = self.deaths;
	if(game["gameRep"]["players"][name]["deaths"] != 0)
	{
		game["gameRep"]["players"][name]["killDeathRatio"] = int((game["gameRep"]["players"][name]["kills"] / game["gameRep"]["players"][name]["deaths"]) * 100);
	}
	else
	{
		game["gameRep"]["players"][name]["killDeathRatio"] = game["gameRep"]["players"][name]["kills"] * 100;
	}
	game["gameRep"]["players"][name]["killsPerMin"] = int(game["gameRep"]["players"][name]["kills"] / (timeplayed / 60));
	game["gameRep"]["players"][name]["plants"] = self.plants;
	game["gameRep"]["players"][name]["defuses"] = self.defuses;
	game["gameRep"]["players"][name]["captures"] = self.captures;
	game["gameRep"]["players"][name]["defends"] = self.defends;
	game["gameRep"]["players"][name]["xp"] = self rank::getrankxpstat() - game["gameRep"]["players"][name]["xpStart"];
	game["gameRep"]["players"][name]["xpStart"] = self rank::getrankxpstat();
}

/*
	Name: getparamvalueforplayer
	Namespace: gamerep
	Checksum: 0x764F7141
	Offset: 0x1A10
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function getparamvalueforplayer(playername, paramname)
{
	if(isdefined(game["gameRep"]["players"][playername][paramname]))
	{
		return game["gameRep"]["players"][playername][paramname];
	}
	/#
		assertmsg(("" + paramname) + "");
	#/
}

/*
	Name: isgamerepparamvalid
	Namespace: gamerep
	Checksum: 0x44C6B45D
	Offset: 0x1AA8
	Size: 0x100
	Parameters: 1
	Flags: Linked
*/
function isgamerepparamvalid(paramname)
{
	gametype = level.gametype;
	if(!isdefined(game["gameRep"]))
	{
		return false;
	}
	if(!isdefined(game["gameRep"]["gameLimit"]))
	{
		return false;
	}
	if(!isdefined(game["gameRep"]["gameLimit"][gametype]))
	{
		return false;
	}
	if(!isdefined(game["gameRep"]["gameLimit"][gametype][paramname]))
	{
		return false;
	}
	if(!isdefined(game["gameRep"]["gameLimit"][gametype][paramname]) && !isdefined(game["gameRep"]["gameLimit"]["default"][paramname]))
	{
		return false;
	}
	return true;
}

/*
	Name: isgamerepparamignoredforreporting
	Namespace: gamerep
	Checksum: 0x63A8764
	Offset: 0x1BB0
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function isgamerepparamignoredforreporting(paramname)
{
	if(isdefined(game["gameRep"]["ignoreParams"][paramname]))
	{
		return true;
	}
	return false;
}

/*
	Name: getgamerepparamlimit
	Namespace: gamerep
	Checksum: 0x20DC4892
	Offset: 0x1BF0
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function getgamerepparamlimit(paramname)
{
	gametype = level.gametype;
	if(isdefined(game["gameRep"]["gameLimit"][gametype]))
	{
		if(isdefined(game["gameRep"]["gameLimit"][gametype][paramname]))
		{
			return game["gameRep"]["gameLimit"][gametype][paramname];
		}
	}
	if(isdefined(game["gameRep"]["gameLimit"]["default"][paramname]))
	{
		return game["gameRep"]["gameLimit"]["default"][paramname];
	}
	/#
		assertmsg(("" + paramname) + "");
	#/
}

/*
	Name: setmaximumparamvalueforcurrentgame
	Namespace: gamerep
	Checksum: 0xB8B2D30F
	Offset: 0x1D08
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function setmaximumparamvalueforcurrentgame(paramname, value)
{
	if(!isdefined(game["gameRep"]["max"][paramname]))
	{
		game["gameRep"]["max"][paramname] = value;
		return;
	}
	if(game["gameRep"]["max"][paramname] < value)
	{
		game["gameRep"]["max"][paramname] = value;
	}
}

/*
	Name: gamerepupdateinformationforround
	Namespace: gamerep
	Checksum: 0x4D039CD7
	Offset: 0x1DB0
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function gamerepupdateinformationforround()
{
	if(!isgamerepenabled())
	{
		return;
	}
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player gamerepupdatenonpersistentplayerinformation();
	}
}

/*
	Name: gamerepanalyzeandreport
	Namespace: gamerep
	Checksum: 0xD9F5AF7A
	Offset: 0x1E48
	Size: 0x2FC
	Parameters: 0
	Flags: Linked
*/
function gamerepanalyzeandreport()
{
	if(!isgamerepenabled())
	{
		return;
	}
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player gamerepupdatepersistentplayerinformation();
	}
	splitscreenplayercount = 0;
	for(i = 0; i < game["gameRep"]["playerNames"].size; i++)
	{
		playername = game["gameRep"]["playerNames"][i];
		for(j = 0; j < game["gameRep"]["params"].size; j++)
		{
			paramname = game["gameRep"]["params"][j];
			if(isgamerepparamvalid(paramname))
			{
				setmaximumparamvalueforcurrentgame(paramname, getparamvalueforplayer(playername, paramname));
			}
		}
		paramname = "splitscreen";
		splitscreenplayercount = splitscreenplayercount + getparamvalueforplayer(playername, paramname);
	}
	setmaximumparamvalueforcurrentgame(paramname, splitscreenplayercount);
	for(j = 0; j < game["gameRep"]["params"].size; j++)
	{
		paramname = game["gameRep"]["params"][j];
		if(isgamerepparamvalid(paramname) && game["gameRep"]["max"][paramname] >= getgamerepparamlimit(paramname))
		{
			gamerepprepareandreport(paramname);
		}
	}
	paramname = "splitscreen";
	if(game["gameRep"]["max"][paramname] >= getgamerepparamlimit(paramname))
	{
		gamerepprepareandreport(paramname);
	}
}

/*
	Name: gamerepprepareandreport
	Namespace: gamerep
	Checksum: 0xBD950AC7
	Offset: 0x2150
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function gamerepprepareandreport(paramname)
{
	if(!isdefined(game["gameRep"]["gameLimit"]["id"][paramname]))
	{
		return;
	}
	if(isgamerepparamignoredforreporting(paramname))
	{
		return;
	}
	gamerepthresholdexceeded(game["gameRep"]["gameLimit"]["id"][paramname]);
}

