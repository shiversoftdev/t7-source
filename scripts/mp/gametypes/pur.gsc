// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace pur;

/*
	Name: main
	Namespace: pur
	Checksum: 0x54A61887
	Offset: 0x410
	Size: 0x2D4
	Parameters: 0
	Flags: None
*/
function main()
{
	globallogic::init();
	util::registerroundswitch(0, 9);
	util::registertimelimit(0, 1440);
	util::registerscorelimit(0, 50000);
	util::registerroundlimit(0, 10);
	util::registerroundwinlimit(0, 10);
	util::registernumlives(0, 10);
	globallogic::registerfriendlyfiredelay(level.gametype, 15, 0, 1440);
	level.cumulativeroundscores = getgametypesetting("cumulativeRoundScores");
	level.teambased = 1;
	level.onstartgametype = &onstartgametype;
	level.onspawnplayer = &onspawnplayer;
	level.onroundendgame = &onroundendgame;
	level.onroundswitch = &onroundswitch;
	level.ondeadevent = &ondeadevent;
	level.onlastteamaliveevent = &onlastteamaliveevent;
	level.onalivecountchange = &onalivecountchange;
	level.spawnmessage = &pur_spawnmessage;
	level.onspawnspectator = &onspawnspectator;
	level.onrespawndelay = &getrespawndelay;
	gameobjects::register_allowed_gameobject("tdm");
	game["dialog"]["gametype"] = "tdm_start";
	game["dialog"]["gametype_hardcore"] = "hctdm_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	game["dialog"]["sudden_death"] = "generic_boost";
	globallogic::setvisiblescoreboardcolumns("score", "kills", "deaths", "kdratio", "assists");
}

/*
	Name: onstartgametype
	Namespace: pur
	Checksum: 0x930182AA
	Offset: 0x6F0
	Size: 0x39C
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
	setclientnamemode("auto_change");
	if(!isdefined(game["switchedsides"]))
	{
		game["switchedsides"] = 0;
	}
	if(game["switchedsides"])
	{
		oldattackers = game["attackers"];
		olddefenders = game["defenders"];
		game["attackers"] = olddefenders;
		game["defenders"] = oldattackers;
	}
	spawning::create_map_placed_influencers();
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	foreach(team in level.teams)
	{
		util::setobjectivetext(team, &"OBJECTIVES_TDM");
		util::setobjectivehinttext(team, &"OBJECTIVES_TDM_HINT");
		if(level.splitscreen)
		{
			util::setobjectivescoretext(team, &"OBJECTIVES_TDM");
		}
		else
		{
			util::setobjectivescoretext(team, &"OBJECTIVES_TDM_SCORE");
		}
		spawnlogic::place_spawn_points(spawning::gettdmstartspawnname(team));
		spawnlogic::add_spawn_points(team, "mp_tdm_spawn");
	}
	spawning::updateallspawnpoints();
	level.spawn_start = [];
	foreach(team in level.teams)
	{
		level.spawn_start[team] = spawnlogic::get_spawnpoint_array(spawning::gettdmstartspawnname(team));
	}
	level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
	setmapcenter(level.mapcenter);
	spawnpoint = spawnlogic::get_random_intermission_point();
	setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
	level.displayroundendtext = 0;
	if(!util::isoneround())
	{
		level.displayroundendtext = 1;
		if(level.scoreroundwinbased)
		{
			globallogic_score::resetteamscores();
		}
	}
}

/*
	Name: waitthenspawn
	Namespace: pur
	Checksum: 0x74146A10
	Offset: 0xA98
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function waitthenspawn()
{
	while(self.sessionstate == "dead")
	{
		wait(0.05);
	}
}

/*
	Name: onspawnplayer
	Namespace: pur
	Checksum: 0x664F3717
	Offset: 0xAC8
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function onspawnplayer(predictedspawn)
{
	self endon(#"disconnect");
	level endon(#"end_game");
	self.usingobj = undefined;
	self initplayerhud();
	self waitthenspawn();
	self util::clearlowermessage();
	spawning::onspawnplayer(predictedspawn);
}

/*
	Name: pur_endgamewithkillcam
	Namespace: pur
	Checksum: 0x71533485
	Offset: 0xB58
	Size: 0x2C
	Parameters: 2
	Flags: None
*/
function pur_endgamewithkillcam(winningteam, endreasontext)
{
	thread globallogic::endgame(winningteam, endreasontext);
}

/*
	Name: onalivecountchange
	Namespace: pur
	Checksum: 0x1D68FB80
	Offset: 0xB90
	Size: 0x24
	Parameters: 1
	Flags: None
*/
function onalivecountchange(team)
{
	level thread updatequeuemessage(team);
}

/*
	Name: onlastteamaliveevent
	Namespace: pur
	Checksum: 0x6104D4C8
	Offset: 0xBC0
	Size: 0xE4
	Parameters: 1
	Flags: None
*/
function onlastteamaliveevent(team)
{
	if(level.multiteam)
	{
		pur_endgamewithkillcam(team, &"MP_ALL_TEAMS_ELIMINATED");
	}
	else
	{
		if(team == game["attackers"])
		{
			pur_endgamewithkillcam(game["attackers"], game["strings"][game["defenders"] + "_eliminated"]);
		}
		else if(team == game["defenders"])
		{
			pur_endgamewithkillcam(game["defenders"], game["strings"][game["attackers"] + "_eliminated"]);
		}
	}
}

/*
	Name: ondeadevent
	Namespace: pur
	Checksum: 0xEDA0F431
	Offset: 0xCB0
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function ondeadevent(team)
{
	if(team == "all")
	{
		pur_endgamewithkillcam("tie", game["strings"]["round_draw"]);
	}
}

/*
	Name: onendgame
	Namespace: pur
	Checksum: 0xD34EA38C
	Offset: 0xD08
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function onendgame(winningteam)
{
	if(isdefined(winningteam) && isdefined(level.teams[winningteam]))
	{
		globallogic_score::giveteamscoreforobjective(winningteam, 1);
	}
}

/*
	Name: onroundswitch
	Namespace: pur
	Checksum: 0x781D1B6F
	Offset: 0xD58
	Size: 0xBA
	Parameters: 0
	Flags: None
*/
function onroundswitch()
{
	game["switchedsides"] = !game["switchedsides"];
	if(level.scoreroundwinbased)
	{
		foreach(team in level.teams)
		{
			[[level._setteamscore]](team, game["roundswon"][team]);
		}
	}
}

/*
	Name: onroundendgame
	Namespace: pur
	Checksum: 0xB73F6456
	Offset: 0xE20
	Size: 0xEC
	Parameters: 1
	Flags: None
*/
function onroundendgame(roundwinner)
{
	if(level.scoreroundwinbased)
	{
		foreach(team in level.teams)
		{
			[[level._setteamscore]](team, game["roundswon"][team]);
		}
		winner = globallogic::determineteamwinnerbygamestat("roundswon");
	}
	else
	{
		winner = globallogic::determineteamwinnerbyteamscore();
	}
	return winner;
}

/*
	Name: onscoreclosemusic
	Namespace: pur
	Checksum: 0xC10E2734
	Offset: 0xF18
	Size: 0x1D8
	Parameters: 0
	Flags: None
*/
function onscoreclosemusic()
{
	teamscores = [];
	while(!level.gameended)
	{
		scorelimit = level.scorelimit;
		scorethreshold = scorelimit * 0.1;
		scorethresholdstart = abs(scorelimit - scorethreshold);
		scorelimitcheck = scorelimit - 10;
		topscore = 0;
		runnerupscore = 0;
		foreach(team in level.teams)
		{
			score = [[level._getteamscore]](team);
			if(score > topscore)
			{
				runnerupscore = topscore;
				topscore = score;
				continue;
			}
			if(score > runnerupscore)
			{
				runnerupscore = score;
			}
		}
		scoredif = topscore - runnerupscore;
		if(scoredif <= scorethreshold && scorethresholdstart <= topscore)
		{
			thread globallogic_audio::set_music_on_team("timeOut");
			return;
		}
		wait(1);
	}
}

/*
	Name: initpurgatoryenemycountelem
	Namespace: pur
	Checksum: 0x4334DF6
	Offset: 0x10F8
	Size: 0x1C4
	Parameters: 2
	Flags: None
*/
function initpurgatoryenemycountelem(team, y_pos)
{
	self.purpurgatorycountelem[team] = newclienthudelem(self);
	self.purpurgatorycountelem[team].fontscale = 1.25;
	self.purpurgatorycountelem[team].x = 110;
	self.purpurgatorycountelem[team].y = y_pos;
	self.purpurgatorycountelem[team].alignx = "right";
	self.purpurgatorycountelem[team].aligny = "top";
	self.purpurgatorycountelem[team].horzalign = "left";
	self.purpurgatorycountelem[team].vertalign = "top";
	self.purpurgatorycountelem[team].foreground = 1;
	self.purpurgatorycountelem[team].hidewhendead = 0;
	self.purpurgatorycountelem[team].hidewheninmenu = 1;
	self.purpurgatorycountelem[team].archived = 0;
	self.purpurgatorycountelem[team].alpha = 1;
	self.purpurgatorycountelem[team].label = &"MP_PURGATORY_ENEMY_COUNT";
}

/*
	Name: initplayerhud
	Namespace: pur
	Checksum: 0x17465B07
	Offset: 0x12C8
	Size: 0x394
	Parameters: 0
	Flags: None
*/
function initplayerhud()
{
	if(isdefined(self.purpurgatorycountelem))
	{
		if(self.pers["team"] == self.purhudteam)
		{
			return;
		}
		foreach(elem in self.purpurgatorycountelem)
		{
			elem destroy();
		}
	}
	self.purpurgatorycountelem = [];
	y_pos = 115;
	y_inc = 15;
	team = self.pers["team"];
	self.purhudteam = team;
	self.purpurgatorycountelem[team] = newclienthudelem(self);
	self.purpurgatorycountelem[team].fontscale = 1.25;
	self.purpurgatorycountelem[team].x = 110;
	self.purpurgatorycountelem[team].y = y_pos;
	self.purpurgatorycountelem[team].alignx = "right";
	self.purpurgatorycountelem[team].aligny = "top";
	self.purpurgatorycountelem[team].horzalign = "left";
	self.purpurgatorycountelem[team].vertalign = "top";
	self.purpurgatorycountelem[team].foreground = 1;
	self.purpurgatorycountelem[team].hidewhendead = 0;
	self.purpurgatorycountelem[team].hidewheninmenu = 1;
	self.purpurgatorycountelem[team].archived = 0;
	self.purpurgatorycountelem[team].alpha = 1;
	self.purpurgatorycountelem[team].label = &"MP_PURGATORY_TEAMMATE_COUNT";
	foreach(team in level.teams)
	{
		if(team == self.team)
		{
			continue;
		}
		y_pos = y_pos + y_inc;
		initpurgatoryenemycountelem(team, y_pos);
	}
	self thread hideplayerhudongameend();
	self thread updateplayerhud();
}

/*
	Name: updateplayerhud
	Namespace: pur
	Checksum: 0x15D6C360
	Offset: 0x1668
	Size: 0x138
	Parameters: 0
	Flags: None
*/
function updateplayerhud()
{
	self endon(#"disconnect");
	level endon(#"end_game");
	while(true)
	{
		if(self.team != "spectator")
		{
			self.purpurgatorycountelem[self.team] setvalue(level.deadplayers[self.team].size);
			foreach(team in level.teams)
			{
				if(self.team == team)
				{
					continue;
				}
				self.purpurgatorycountelem[team] setvalue(level.alivecount[team]);
			}
		}
		wait(0.25);
	}
}

/*
	Name: hideplayerhudongameend
	Namespace: pur
	Checksum: 0xCF227ED3
	Offset: 0x17A8
	Size: 0x92
	Parameters: 0
	Flags: None
*/
function hideplayerhudongameend()
{
	level waittill(#"game_ended");
	foreach(elem in self.purpurgatorycountelem)
	{
		elem.alpha = 0;
	}
}

/*
	Name: displayspawnmessage
	Namespace: pur
	Checksum: 0xF5633AE2
	Offset: 0x1848
	Size: 0x94
	Parameters: 0
	Flags: None
*/
function displayspawnmessage()
{
	if(self.waitingtospawn)
	{
		return;
	}
	if(self.name == "TolucaLake")
	{
		shit = 0;
	}
	if(self.spawnqueueindex != 0)
	{
		self util::setlowermessagevalue(&"MP_PURGATORY_QUEUE_POSITION", self.spawnqueueindex + 1, 1);
	}
	else
	{
		self util::setlowermessagevalue(&"MP_PURGATORY_NEXT_SPAWN", undefined, 0);
	}
}

/*
	Name: pur_spawnmessage
	Namespace: pur
	Checksum: 0x83A81FB8
	Offset: 0x18E8
	Size: 0x14
	Parameters: 0
	Flags: None
*/
function pur_spawnmessage()
{
	util::waittillslowprocessallowed();
}

/*
	Name: onspawnspectator
	Namespace: pur
	Checksum: 0x9966A59
	Offset: 0x1908
	Size: 0x44
	Parameters: 2
	Flags: None
*/
function onspawnspectator(origin, angles)
{
	self displayspawnmessage();
	globallogic_defaults::default_onspawnspectator(origin, angles);
}

/*
	Name: updatequeuemessage
	Namespace: pur
	Checksum: 0x932F4E0E
	Offset: 0x1958
	Size: 0xF6
	Parameters: 1
	Flags: None
*/
function updatequeuemessage(team)
{
	self notify(#"updatequeuemessage");
	self endon(#"updatequeuemessage");
	util::waittillslowprocessallowed();
	players = level.deadplayers[team];
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!player.waitingtospawn && player.sessionstate != "dead" && !isdefined(player.killcam))
		{
			player displayspawnmessage();
		}
	}
}

/*
	Name: getrespawndelay
	Namespace: pur
	Checksum: 0x5525F0B1
	Offset: 0x1A58
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function getrespawndelay()
{
	self.lowermessageoverride = undefined;
	return level.playerrespawndelay;
}

