// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_teamops;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_dogtags;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_spawn;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace tdm;

/*
	Name: main
	Namespace: tdm
	Checksum: 0xD4F84CAD
	Offset: 0x388
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function main()
{
	globallogic::init();
	util::registerroundswitch(0, 9);
	util::registertimelimit(0, 1440);
	util::registerscorelimit(0, 50000);
	util::registerroundlimit(0, 10);
	util::registerroundwinlimit(0, 10);
	util::registernumlives(0, 100);
	globallogic::registerfriendlyfiredelay(level.gametype, 15, 0, 1440);
	level.scoreroundwinbased = getgametypesetting("cumulativeRoundScores") == 0;
	level.teamscoreperkill = getgametypesetting("teamScorePerKill");
	level.teamscoreperdeath = getgametypesetting("teamScorePerDeath");
	level.teamscoreperheadshot = getgametypesetting("teamScorePerHeadshot");
	level.killstreaksgivegamescore = getgametypesetting("killstreaksGiveGameScore");
	level.teambased = 1;
	level.overrideteamscore = 1;
	level.onstartgametype = &onstartgametype;
	level.onspawnplayer = &onspawnplayer;
	level.onroundendgame = &onroundendgame;
	level.onroundswitch = &onroundswitch;
	level.onplayerkilled = &onplayerkilled;
	gameobjects::register_allowed_gameobject(level.gametype);
	globallogic_audio::set_leader_gametype_dialog("startTeamDeathmatch", "hcStartTeamDeathmatch", "gameBoost", "gameBoost");
	globallogic::setvisiblescoreboardcolumns("score", "kills", "deaths", "kdratio", "assists");
}

/*
	Name: onstartgametype
	Namespace: tdm
	Checksum: 0x8187EB7D
	Offset: 0x618
	Size: 0x3D8
	Parameters: 0
	Flags: Linked
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
	level.displayroundendtext = 0;
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
		spawnlogic::add_spawn_points(team, "mp_tdm_spawn");
		spawnlogic::place_spawn_points(spawning::gettdmstartspawnname(team));
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
	level thread onscoreclosemusic();
	if(!util::isoneround())
	{
		level.displayroundendtext = 1;
		if(level.scoreroundwinbased)
		{
			globallogic_score::resetteamscores();
		}
	}
	if(isdefined(level.droppedtagrespawn) && level.droppedtagrespawn)
	{
		level.numlives = 1;
	}
}

/*
	Name: onspawnplayer
	Namespace: tdm
	Checksum: 0x16A7F1B4
	Offset: 0x9F8
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function onspawnplayer(predictedspawn)
{
	self.usingobj = undefined;
	if(level.usestartspawns && !level.ingraceperiod && !level.playerqueuedrespawn)
	{
		level.usestartspawns = 0;
	}
	spawning::onspawnplayer(predictedspawn);
}

/*
	Name: onendgame
	Namespace: tdm
	Checksum: 0x54D68A9B
	Offset: 0xA60
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
	Namespace: tdm
	Checksum: 0xE911D08
	Offset: 0xAB0
	Size: 0xBA
	Parameters: 0
	Flags: Linked
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
	Namespace: tdm
	Checksum: 0xC8F6E546
	Offset: 0xB78
	Size: 0xB6
	Parameters: 1
	Flags: Linked
*/
function onroundendgame(roundwinner)
{
	if(level.scoreroundwinbased)
	{
		foreach(team in level.teams)
		{
			[[level._setteamscore]](team, game["roundswon"][team]);
		}
	}
	return [[level.determinewinner]]();
}

/*
	Name: onscoreclosemusic
	Namespace: tdm
	Checksum: 0x320D4B1D
	Offset: 0xC38
	Size: 0x1C2
	Parameters: 0
	Flags: Linked
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
		if(topscore >= (scorelimit * 0.5))
		{
			level notify(#"sndmusichalfway");
			return;
		}
		wait(1);
	}
}

/*
	Name: onplayerkilled
	Namespace: tdm
	Checksum: 0x6EA1CD2A
	Offset: 0xE08
	Size: 0x204
	Parameters: 9
	Flags: Linked
*/
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	if(isdefined(level.droppedtagrespawn) && level.droppedtagrespawn)
	{
		thread dogtags::checkallowspectating();
		should_spawn_tags = self dogtags::should_spawn_tags(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration);
		should_spawn_tags = should_spawn_tags && !globallogic_spawn::mayspawn();
		if(should_spawn_tags)
		{
			level thread dogtags::spawn_dog_tag(self, attacker, &dogtags::onusedogtag, 0);
		}
	}
	if(isplayer(attacker) == 0 || attacker.team == self.team)
	{
		return;
	}
	if(!isdefined(killstreaks::get_killstreak_for_weapon(weapon)) || (isdefined(level.killstreaksgivegamescore) && level.killstreaksgivegamescore))
	{
		attacker globallogic_score::giveteamscoreforobjective(attacker.team, level.teamscoreperkill);
		self globallogic_score::giveteamscoreforobjective(self.team, level.teamscoreperdeath * -1);
		if(smeansofdeath == "MOD_HEAD_SHOT")
		{
			attacker globallogic_score::giveteamscoreforobjective(attacker.team, level.teamscoreperheadshot);
		}
	}
}

