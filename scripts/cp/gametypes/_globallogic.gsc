// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_bb;
#using scripts\cp\_challenges;
#using scripts\cp\_decoy;
#using scripts\cp\_gameadvertisement;
#using scripts\cp\_gamerep;
#using scripts\cp\_laststand;
#using scripts\cp\_load;
#using scripts\cp\_rat;
#using scripts\cp\_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_deathicons;
#using scripts\cp\gametypes\_dev;
#using scripts\cp\gametypes\_friendicons;
#using scripts\cp\gametypes\_globallogic_defaults;
#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_globallogic_spawn;
#using scripts\cp\gametypes\_globallogic_ui;
#using scripts\cp\gametypes\_globallogic_utils;
#using scripts\cp\gametypes\_healthoverlay;
#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_menus;
#using scripts\cp\gametypes\_save;
#using scripts\cp\gametypes\_scoreboard;
#using scripts\cp\gametypes\_serversettings;
#using scripts\cp\gametypes\_shellshock;
#using scripts\cp\gametypes\_spawnlogic;
#using scripts\cp\gametypes\_spectating;
#using scripts\cp\gametypes\_wager;
#using scripts\cp\gametypes\_weapon_utils;
#using scripts\cp\gametypes\_weapons;
#using scripts\cp\teams\_teams;
#using scripts\shared\_burnplayer;
#using scripts\shared\bb_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\music_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\player_shared;
#using scripts\shared\simple_hostmigration;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;
#using scripts\shared\weapons_shared;

#namespace globallogic;

/*
	Name: init
	Namespace: globallogic
	Checksum: 0x294C0BAB
	Offset: 0x17B0
	Size: 0x804
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.splitscreen = issplitscreen();
	level.xenon = getdvarstring("xenonGame") == "true";
	level.ps3 = getdvarstring("ps3Game") == "true";
	level.wiiu = getdvarstring("wiiuGame") == "true";
	level.orbis = getdvarstring("orbisGame") == "true";
	level.durango = getdvarstring("durangoGame") == "true";
	level.onlinegame = sessionmodeisonlinegame();
	level.systemlink = sessionmodeissystemlink();
	level.console = level.xenon || level.ps3 || level.wiiu || level.orbis || level.durango;
	level.rankedmatch = gamemodeisusingxp();
	level.leaguematch = 0;
	level.arenamatch = 0;
	level.contractsenabled = !getgametypesetting("disableContracts");
	level.contractsenabled = 0;
	/#
		if(getdvarint("") == 1)
		{
			level.rankedmatch = 1;
		}
	#/
	level.script = tolower(getdvarstring("mapname"));
	level.gametype = tolower(getdvarstring("g_gametype"));
	level.teambased = 0;
	level.teamcount = getgametypesetting("teamCount");
	level.multiteam = level.teamcount > 2;
	level.enemy_ai_team_index = level.teamcount + 1;
	if(2 == level.enemy_ai_team_index)
	{
		level.enemy_ai_team = "axis";
	}
	else
	{
		level.enemy_ai_team = "team" + level.enemy_ai_team_index;
	}
	level.teams = [];
	level.teamindex = [];
	level.playerteams = [];
	teamcount = level.teamcount;
	level.playerteams["allies"] = "allies";
	level.teams["allies"] = "allies";
	level.teams["axis"] = "axis";
	level.teamindex["neutral"] = 0;
	level.teamindex["allies"] = 1;
	level.teamindex["axis"] = 2;
	for(teamindex = 3; teamindex <= teamcount; teamindex++)
	{
		level.teams["team" + teamindex] = "team" + teamindex;
		level.teamindex["team" + teamindex] = teamindex;
	}
	level.overrideteamscore = 0;
	level.overrideplayerscore = 0;
	level.displayhalftimetext = 0;
	level.displayroundendtext = 1;
	level.endgameonscorelimit = 1;
	level.endgameontimelimit = 1;
	level.cumulativeroundscores = 1;
	level.scoreroundwinbased = 0;
	level.resetplayerscoreeveryround = 0;
	level.gameforfeited = 0;
	level.forceautoassign = 0;
	level.halftimetype = "halftime";
	level.halftimesubcaption = &"MP_SWITCHING_SIDES_CAPS";
	level.laststatustime = 0;
	level.waswinning = [];
	level.lastslowprocessframe = 0;
	level.placement = [];
	foreach(team in level.teams)
	{
		level.placement[team] = [];
	}
	level.placement["all"] = [];
	level.postroundtime = 7;
	level.inovertime = 0;
	level.var_d59daf8 = 1;
	level.defaultoffenseradius = 560;
	level.dropteam = getdvarint("sv_maxclients");
	globallogic_ui::init();
	registerdvars();
	loadout::initperkdvars();
	level.oldschool = getdvarint("scr_oldschool") == 1;
	if(level.oldschool)
	{
		/#
			print("");
		#/
		setdvar("jump_height", 64);
		setdvar("jump_slowdownEnable", 0);
		setdvar("bg_fallDamageMinHeight", 256);
		setdvar("bg_fallDamageMaxHeight", 512);
		setdvar("player_clipSizeMultiplier", 2);
	}
	precache_mp_leaderboards();
	if(!isdefined(game["tiebreaker"]))
	{
		game["tiebreaker"] = 0;
	}
	thread gameadvertisement::init();
	thread gamerep::init();
	level.disablechallenges = 0;
	if(level.leaguematch || getdvarint("scr_disableChallenges") > 0)
	{
		level.disablechallenges = 1;
	}
	level.disablestattracking = getdvarint("scr_disableStatTracking") > 0;
	level thread setupcallbacks();
	level.playersdrivingvehiclesbecomeinvulnerable = 1;
	level.figure_out_attacker = &globallogic_player::figureoutattacker;
	level.figure_out_friendly_fire = &globallogic_player::figureoutfriendlyfire;
	level.get_base_weapon_param = &weapon_utils::getbaseweaponparam;
}

/*
	Name: registerdvars
	Namespace: globallogic
	Checksum: 0x88871CCB
	Offset: 0x1FC0
	Size: 0x2A4
	Parameters: 0
	Flags: Linked
*/
function registerdvars()
{
	if(getdvarstring("scr_oldschool") == "")
	{
		setdvar("scr_oldschool", "0");
	}
	if(getdvarstring("ui_guncycle") == "")
	{
		setdvar("ui_guncycle", 0);
	}
	if(getdvarstring("ui_weapon_tiers") == "")
	{
		setdvar("ui_weapon_tiers", 0);
	}
	setdvar("ui_text_endreason", "");
	setmatchflag("bomb_timer", 0);
	if(getdvarstring("scr_vehicle_damage_scalar") == "")
	{
		setdvar("scr_vehicle_damage_scalar", "1");
	}
	level.vehicledamagescalar = getdvarfloat("scr_vehicle_damage_scalar");
	level.fire_audio_repeat_duration = getdvarint("fire_audio_repeat_duration");
	level.fire_audio_random_max_duration = getdvarint("fire_audio_random_max_duration");
	teamname = getcustomteamname(level.teamindex["allies"]);
	if(isdefined(teamname))
	{
		setdvar("g_customTeamName_Allies", teamname);
	}
	else
	{
		setdvar("g_customTeamName_Allies", "");
	}
	teamname = getcustomteamname(level.teamindex["axis"]);
	if(isdefined(teamname))
	{
		setdvar("g_customTeamName_Axis", teamname);
	}
	else
	{
		setdvar("g_customTeamName_Axis", "");
	}
}

/*
	Name: blank
	Namespace: globallogic
	Checksum: 0xC89B9EFF
	Offset: 0x2270
	Size: 0x54
	Parameters: 10
	Flags: Linked
*/
function blank(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
{
}

/*
	Name: setupcallbacks
	Namespace: globallogic
	Checksum: 0x34EE0813
	Offset: 0x22D0
	Size: 0x424
	Parameters: 0
	Flags: Linked
*/
function setupcallbacks()
{
	level.spawnplayer = &globallogic_spawn::spawnplayer;
	level.spawnplayerprediction = &blank;
	level.spawnclient = &globallogic_spawn::spawnclient;
	level.spawnspectator = &globallogic_spawn::spawnspectator;
	level.spawnintermission = &globallogic_spawn::spawnintermission;
	level.scoreongiveplayerscore = &globallogic_score::giveplayerscore;
	level.onplayerscore = &globallogic_score::default_onplayerscore;
	level.onteamscore = &globallogic_score::default_onteamscore;
	level.wavespawntimer = &wavespawntimer;
	level.spawnmessage = &globallogic_spawn::default_spawnmessage;
	level.onspawnplayer = &blank;
	level.onspawnplayerunified = &blank;
	level.onspawnspectator = &globallogic_defaults::default_onspawnspectator;
	level.onspawnintermission = &globallogic_defaults::default_onspawnintermission;
	level.onrespawndelay = &blank;
	level.onforfeit = &globallogic_defaults::default_onforfeit;
	level.ontimelimit = &globallogic_defaults::default_ontimelimit;
	level.onscorelimit = &globallogic_defaults::default_onscorelimit;
	level.onalivecountchange = &globallogic_defaults::default_onalivecountchange;
	level.ondeadevent = &globallogic_defaults::default_ondeadevent;
	level.ononeleftevent = &globallogic_defaults::default_ononeleftevent;
	level.giveteamscore = &globallogic_score::giveteamscore;
	level.onlastteamaliveevent = &globallogic_defaults::default_onlastteamaliveevent;
	level.onlaststandevent = &globallogic_defaults::default_onlaststandevent;
	level.gettimepassed = &globallogic_utils::gettimepassed;
	level.gettimelimit = &globallogic_defaults::default_gettimelimit;
	level.getteamkillpenalty = &globallogic_defaults::default_getteamkillpenalty;
	level.getteamkillscore = &globallogic_defaults::default_getteamkillscore;
	level.iskillboosting = &globallogic_score::default_iskillboosting;
	level._setteamscore = &globallogic_score::_setteamscore;
	level._setplayerscore = &globallogic_score::_setplayerscore;
	level._getteamscore = &globallogic_score::_getteamscore;
	level._getplayerscore = &globallogic_score::_getplayerscore;
	level.onprecachegametype = &blank;
	level.onstartgametype = &blank;
	level.onplayerconnect = &blank;
	level.onplayerdisconnect = &blank;
	level.onplayerdamage = &blank;
	level.onplayerkilled = &blank;
	level.onplayerkilledextraunthreadedcbs = [];
	level.setmatchscorehudelemforteam = &hud_message::setmatchscorehudelemforteam;
	level.onendgame = &blank;
	level.onroundendgame = &globallogic_defaults::default_onroundendgame;
	level.onmedalawarded = &blank;
	globallogic_ui::setupcallbacks();
}

/*
	Name: precache_mp_leaderboards
	Namespace: globallogic
	Checksum: 0x5918F82A
	Offset: 0x2700
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function precache_mp_leaderboards()
{
	if(sessionmodeiszombiesgame())
	{
		return;
	}
	if(!level.rankedmatch)
	{
		return;
	}
	if(isdefined(level.var_e2c19907) && level.var_e2c19907)
	{
		return;
	}
	mapname = getdvarstring("mapname");
	globalleaderboards = "LB_MP_GB_XPPRESTIGE LB_MP_GB_SCORE LB_MP_GB_KDRATIO LB_MP_GB_KILLS LB_MP_GB_WINS LB_MP_GB_DEATHS LB_MP_GB_XPMAXPERGAME LB_MP_GB_TACTICALINSERTS LB_MP_GB_TACTICALINSERTSKILLS LB_MP_GB_PRESTIGEXP LB_MP_GB_HEADSHOTS LB_MP_GB_WEAPONS_PRIMARY LB_MP_GB_WEAPONS_SECONDARY";
	careerleaderboard = "";
	switch(level.gametype)
	{
		case "gun":
		case "oic":
		case "sas":
		case "shrp":
		{
			break;
		}
		default:
		{
			careerleaderboard = " LB_MP_GB_SCOREPERMINUTE";
			break;
		}
	}
	gamemodeleaderboard = " LB_MP_GM_" + level.gametype;
	gamemodeleaderboardext = (" LB_MP_GM_" + level.gametype) + "_EXT";
	gamemodehcleaderboard = "";
	gamemodehcleaderboardext = "";
	hardcoremode = getgametypesetting("hardcoreMode");
	if(isdefined(hardcoremode) && hardcoremode)
	{
		gamemodehcleaderboard = gamemodeleaderboard + "_HC";
		gamemodehcleaderboardext = gamemodeleaderboardext + "_HC";
	}
	mapleaderboard = " LB_MP_MAP_" + getsubstr(mapname, 3, mapname.size);
	precacheleaderboards((((((globalleaderboards + careerleaderboard) + gamemodeleaderboard) + gamemodeleaderboardext) + gamemodehcleaderboard) + gamemodehcleaderboardext) + mapleaderboard);
}

/*
	Name: compareteambygamestat
	Namespace: globallogic
	Checksum: 0xBE5BE4F
	Offset: 0x2928
	Size: 0xE6
	Parameters: 4
	Flags: Linked
*/
function compareteambygamestat(gamestat, teama, teamb, previous_winner_score)
{
	winner = undefined;
	if(teama == "tie")
	{
		winner = "tie";
		if(previous_winner_score < game[gamestat][teamb])
		{
			winner = teamb;
		}
	}
	else
	{
		if(game[gamestat][teama] == game[gamestat][teamb])
		{
			winner = "tie";
		}
		else
		{
			if(game[gamestat][teamb] > game[gamestat][teama])
			{
				winner = teamb;
			}
			else
			{
				winner = teama;
			}
		}
	}
	return winner;
}

/*
	Name: determineteamwinnerbygamestat
	Namespace: globallogic
	Checksum: 0xA97D1D27
	Offset: 0x2A18
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function determineteamwinnerbygamestat(gamestat)
{
	teamkeys = getarraykeys(level.teams);
	winner = teamkeys[0];
	previous_winner_score = game[gamestat][winner];
	for(teamindex = 1; teamindex < teamkeys.size; teamindex++)
	{
		winner = compareteambygamestat(gamestat, winner, teamkeys[teamindex], previous_winner_score);
		if(winner != "tie")
		{
			previous_winner_score = game[gamestat][winner];
		}
	}
	return winner;
}

/*
	Name: compareteambyteamscore
	Namespace: globallogic
	Checksum: 0xEF7DAAE8
	Offset: 0x2B08
	Size: 0xEE
	Parameters: 3
	Flags: Linked
*/
function compareteambyteamscore(teama, teamb, previous_winner_score)
{
	winner = undefined;
	teambscore = [[level._getteamscore]](teamb);
	if(teama == "tie")
	{
		winner = "tie";
		if(previous_winner_score < teambscore)
		{
			winner = teamb;
		}
		return winner;
	}
	teamascore = [[level._getteamscore]](teama);
	if(teambscore == teamascore)
	{
		winner = "tie";
	}
	else
	{
		if(teambscore > teamascore)
		{
			winner = teamb;
		}
		else
		{
			winner = teama;
		}
	}
	return winner;
}

/*
	Name: determineteamwinnerbyteamscore
	Namespace: globallogic
	Checksum: 0x69648BC9
	Offset: 0x2C00
	Size: 0xDE
	Parameters: 0
	Flags: None
*/
function determineteamwinnerbyteamscore()
{
	teamkeys = getarraykeys(level.teams);
	winner = teamkeys[0];
	previous_winner_score = [[level._getteamscore]](winner);
	for(teamindex = 1; teamindex < teamkeys.size; teamindex++)
	{
		winner = compareteambyteamscore(winner, teamkeys[teamindex], previous_winner_score);
		if(winner != "tie")
		{
			previous_winner_score = [[level._getteamscore]](winner);
		}
	}
	return winner;
}

/*
	Name: forceend
	Namespace: globallogic
	Checksum: 0x173ECA5C
	Offset: 0x2CE8
	Size: 0x1CC
	Parameters: 1
	Flags: Linked
*/
function forceend(hostsucks)
{
	level.nextbsptoload = undefined;
	level.nextbspgamemode = undefined;
	level.nextbsplightingstate = undefined;
	if(!isdefined(hostsucks))
	{
		hostsucks = 0;
	}
	if(level.hostforcedend || level.forcedend)
	{
		return;
	}
	winner = undefined;
	if(level.teambased)
	{
		winner = determineteamwinnerbygamestat("teamScores");
		globallogic_utils::logteamwinstring("host ended game", winner);
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
	level.forcedend = 1;
	level.hostforcedend = 1;
	if(hostsucks)
	{
		endstring = &"MP_HOST_SUCKS";
	}
	else
	{
		if(level.splitscreen)
		{
			endstring = &"MP_ENDED_GAME";
		}
		else
		{
			endstring = &"MP_HOST_ENDED_GAME";
		}
	}
	setmatchflag("disableIngameMenu", 1);
	setdvar("ui_text_endreason", endstring);
	thread endgame(winner, endstring);
}

/*
	Name: killserverpc
	Namespace: globallogic
	Checksum: 0xB84D1779
	Offset: 0x2EC0
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function killserverpc()
{
	if(level.hostforcedend || level.forcedend)
	{
		return;
	}
	winner = undefined;
	if(level.teambased)
	{
		winner = determineteamwinnerbygamestat("teamScores");
		globallogic_utils::logteamwinstring("host ended game", winner);
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
	level.forcedend = 1;
	level.hostforcedend = 1;
	level.killserver = 1;
	endstring = &"MP_HOST_ENDED_GAME";
	/#
		println("");
	#/
	thread endgame(winner, endstring);
}

/*
	Name: atleasttwoteams
	Namespace: globallogic
	Checksum: 0xF279230B
	Offset: 0x3018
	Size: 0xB6
	Parameters: 0
	Flags: Linked
*/
function atleasttwoteams()
{
	valid_count = 0;
	foreach(team in level.teams)
	{
		if(level.playercount[team] != 0)
		{
			valid_count++;
		}
	}
	if(valid_count < 2)
	{
		return false;
	}
	return true;
}

/*
	Name: checkifteamforfeits
	Namespace: globallogic
	Checksum: 0x84EC4BEF
	Offset: 0x30D8
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function checkifteamforfeits(team)
{
	if(!game["everExisted"][team])
	{
		return false;
	}
	if(level.playercount[team] < 1 && util::totalplayercount() > 0)
	{
		return true;
	}
	return false;
}

/*
	Name: checkforforfeit
	Namespace: globallogic
	Checksum: 0x31CC68AC
	Offset: 0x3140
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function checkforforfeit()
{
	forfeit_count = 0;
	valid_team = undefined;
	foreach(team in level.teams)
	{
		if(checkifteamforfeits(team))
		{
			forfeit_count++;
			if(!level.multiteam)
			{
				thread [[level.onforfeit]](team);
				return true;
			}
			continue;
		}
		valid_team = team;
	}
	if(level.multiteam && forfeit_count == (level.teams.size - 1))
	{
		thread [[level.onforfeit]](valid_team);
		return true;
	}
	return false;
}

/*
	Name: dospawnqueueupdates
	Namespace: globallogic
	Checksum: 0x11E627EE
	Offset: 0x3270
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function dospawnqueueupdates()
{
	foreach(team in level.teams)
	{
		if(level.spawnqueuemodified[team])
		{
			[[level.onalivecountchange]](team);
		}
	}
}

/*
	Name: isteamalldead
	Namespace: globallogic
	Checksum: 0x31D17981
	Offset: 0x3318
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function isteamalldead(team)
{
	return level.everexisted[team] && !level.alivecount[team] && !level.playerlives[team];
}

/*
	Name: areallteamsdead
	Namespace: globallogic
	Checksum: 0x4EAD2525
	Offset: 0x3360
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function areallteamsdead()
{
	foreach(team in level.teams)
	{
		if(!isteamalldead(team))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: getlastteamalive
	Namespace: globallogic
	Checksum: 0xF2C56CFF
	Offset: 0x3400
	Size: 0x106
	Parameters: 0
	Flags: Linked
*/
function getlastteamalive()
{
	count = 0;
	everexistedcount = 0;
	aliveteam = undefined;
	foreach(team in level.teams)
	{
		if(level.everexisted[team])
		{
			if(!isteamalldead(team))
			{
				aliveteam = team;
				count++;
			}
			everexistedcount++;
		}
	}
	if(everexistedcount > 1 && count == 1)
	{
		return aliveteam;
	}
	return undefined;
}

/*
	Name: dodeadeventupdates
	Namespace: globallogic
	Checksum: 0xFE3E7A7E
	Offset: 0x3510
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function dodeadeventupdates()
{
	if(level.teambased)
	{
		if(areallteamsdead())
		{
			[[level.ondeadevent]]("all");
			return true;
		}
		if(!isdefined(level.ondeadevent))
		{
			lastteamalive = getlastteamalive();
			if(isdefined(lastteamalive))
			{
				[[level.onlastteamaliveevent]](lastteamalive);
				return true;
			}
		}
		else
		{
			foreach(team in level.teams)
			{
				if(isteamalldead(team))
				{
					[[level.ondeadevent]](team);
					return true;
				}
			}
		}
	}
	else if(totalalivecount() == 0 && totalplayerlives() == 0 && level.maxplayercount > 1)
	{
		[[level.ondeadevent]]("all");
		return true;
	}
	return false;
}

/*
	Name: isonlyoneleftaliveonteam
	Namespace: globallogic
	Checksum: 0x97DADFB5
	Offset: 0x36C0
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function isonlyoneleftaliveonteam(team)
{
	return level.lastalivecount[team] > 1 && level.alivecount[team] == 1 && level.playerlives[team] == 1;
}

/*
	Name: doonelefteventupdates
	Namespace: globallogic
	Checksum: 0x629E97DD
	Offset: 0x3718
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function doonelefteventupdates()
{
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			if(isonlyoneleftaliveonteam(team))
			{
				[[level.ononeleftevent]](team);
				return true;
			}
		}
	}
	else if(totalalivecount() == 1 && totalplayerlives() == 1 && level.maxplayercount > 1)
	{
		[[level.ononeleftevent]]("all");
		return true;
	}
	return false;
}

/*
	Name: isteamalllaststand
	Namespace: globallogic
	Checksum: 0x3735117B
	Offset: 0x3840
	Size: 0x36
	Parameters: 1
	Flags: Linked
*/
function isteamalllaststand(team)
{
	return level.everexisted[team] && level.alivecount[team] == level.laststandcount[team];
}

/*
	Name: areallteamslaststand
	Namespace: globallogic
	Checksum: 0x338AD468
	Offset: 0x3880
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function areallteamslaststand()
{
	foreach(team in level.teams)
	{
		if(!isteamalllaststand(team))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: dolaststandeventupdates
	Namespace: globallogic
	Checksum: 0x3758906B
	Offset: 0x3920
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function dolaststandeventupdates()
{
	if(!isdefined(level.onlaststandevent))
	{
		return;
	}
	if(level.teambased)
	{
		if(areallteamslaststand())
		{
			[[level.onlaststandevent]]("all");
			return true;
		}
		foreach(team in level.teams)
		{
			if(isteamalllaststand(team))
			{
				[[level.onlaststandevent]](team);
				return true;
			}
		}
	}
	else
	{
		total_last_stand_count = totallaststandcount();
		if(total_last_stand_count > 0 && totalalivecount() == total_last_stand_count && level.maxplayercount > 1)
		{
			[[level.onlaststandevent]]("all");
			return true;
		}
	}
	return false;
}

/*
	Name: updategameevents
	Namespace: globallogic
	Checksum: 0x64426AF
	Offset: 0x3A98
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function updategameevents()
{
	/#
		if(getdvarint("") == 1)
		{
			return;
		}
	#/
	if(level.rankedmatch || level.wagermatch || level.leaguematch && !level.ingraceperiod)
	{
		if(level.teambased)
		{
			if(!level.gameforfeited)
			{
				if(game["state"] == "playing" && checkforforfeit())
				{
					return;
				}
			}
			else if(atleasttwoteams())
			{
				level.gameforfeited = 0;
				level notify(#"hash_577494dc");
			}
		}
		else
		{
			if(!level.gameforfeited)
			{
				if(util::totalplayercount() == 1 && level.maxplayercount > 1)
				{
					thread [[level.onforfeit]]();
					return;
				}
			}
			else if(util::totalplayercount() > 1)
			{
				level.gameforfeited = 0;
				level notify(#"hash_577494dc");
			}
		}
	}
	if(!level.playerqueuedrespawn && !level.numlives && !level.inovertime)
	{
		return;
	}
	if(level.ingraceperiod)
	{
		return;
	}
	if(level.playerqueuedrespawn)
	{
		dospawnqueueupdates();
	}
	if(dodeadeventupdates())
	{
		return;
	}
	if(doonelefteventupdates())
	{
		return;
	}
	if(dolaststandeventupdates())
	{
		return;
	}
}

/*
	Name: matchstarttimer
	Namespace: globallogic
	Checksum: 0xEC424636
	Offset: 0x3C98
	Size: 0x384
	Parameters: 0
	Flags: Linked
*/
function matchstarttimer()
{
	matchstarttext = hud::createserverfontstring("objective", 1.5);
	matchstarttext hud::setpoint("CENTER", "CENTER", 0, -40);
	matchstarttext.sort = 1001;
	matchstarttext settext(game["strings"]["waiting_for_teams"]);
	matchstarttext.foreground = 0;
	matchstarttext.hidewheninmenu = 1;
	waitforplayers();
	matchstarttext settext(game["strings"]["match_starting_in"]);
	matchstarttimer = hud::createserverfontstring("big", 2.2);
	matchstarttimer hud::setpoint("CENTER", "CENTER", 0, 0);
	matchstarttimer.sort = 1001;
	matchstarttimer.color = (1, 1, 0);
	matchstarttimer.foreground = 0;
	matchstarttimer.hidewheninmenu = 1;
	matchstarttimer hud::font_pulse_init();
	counttime = int(level.prematchperiod);
	if(counttime >= 2)
	{
		while(counttime > 0 && !level.gameended)
		{
			matchstarttimer setvalue(counttime);
			matchstarttimer thread hud::font_pulse(level);
			if(counttime == 2)
			{
				visionsetnaked(getdvarstring("mapname"), 3);
			}
			counttime--;
			foreach(player in level.players)
			{
				player playlocalsound("uin_start_count_down");
			}
			wait(1);
		}
	}
	else
	{
		visionsetnaked(getdvarstring("mapname"), 1);
	}
	matchstarttimer hud::destroyelem();
	matchstarttext hud::destroyelem();
}

/*
	Name: matchstarttimerskip
	Namespace: globallogic
	Checksum: 0xDAA84BA5
	Offset: 0x4028
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function matchstarttimerskip()
{
	visionsetnaked(getdvarstring("mapname"), 0);
}

/*
	Name: notifyteamwavespawn
	Namespace: globallogic
	Checksum: 0x7BDD2D09
	Offset: 0x4068
	Size: 0x76
	Parameters: 2
	Flags: Linked
*/
function notifyteamwavespawn(team, time)
{
	if((time - level.lastwave[team]) > (level.wavedelay[team] * 1000))
	{
		level notify("wave_respawn_" + team);
		level.lastwave[team] = time;
		level.waveplayerspawnindex[team] = 0;
	}
}

/*
	Name: wavespawntimer
	Namespace: globallogic
	Checksum: 0x642E5475
	Offset: 0x40E8
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function wavespawntimer()
{
	level endon(#"game_ended");
	while(game["state"] == "playing")
	{
		time = gettime();
		foreach(team in level.teams)
		{
			notifyteamwavespawn(team, time);
		}
		wait(0.05);
	}
}

/*
	Name: hostidledout
	Namespace: globallogic
	Checksum: 0x656A7C3B
	Offset: 0x41C0
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function hostidledout()
{
	hostplayer = util::gethostplayer();
	/#
		if(getdvarint("") == 1 || getdvarint("") == 1)
		{
			return false;
		}
	#/
	if(isdefined(hostplayer) && !hostplayer.hasspawned && !isdefined(hostplayer.selectedclass))
	{
		return true;
	}
	return false;
}

/*
	Name: incrementmatchcompletionstat
	Namespace: globallogic
	Checksum: 0x87179DD4
	Offset: 0x4270
	Size: 0x54
	Parameters: 3
	Flags: Linked
*/
function incrementmatchcompletionstat(gamemode, playedorhosted, stat)
{
	self adddstat("gameHistory", gamemode, "modeHistory", playedorhosted, stat, 1);
}

/*
	Name: setmatchcompletionstat
	Namespace: globallogic
	Checksum: 0xD86BC911
	Offset: 0x42D0
	Size: 0x54
	Parameters: 3
	Flags: None
*/
function setmatchcompletionstat(gamemode, playedorhosted, stat)
{
	self setdstat("gameHistory", gamemode, "modeHistory", playedorhosted, stat, 1);
}

/*
	Name: getteamscoreratio
	Namespace: globallogic
	Checksum: 0x75C899C6
	Offset: 0x4330
	Size: 0x16A
	Parameters: 0
	Flags: Linked
*/
function getteamscoreratio()
{
	playerteam = self.pers["team"];
	score = getteamscore(playerteam);
	otherteamscore = 0;
	foreach(team in level.teams)
	{
		if(team == playerteam)
		{
			continue;
		}
		otherteamscore = otherteamscore + getteamscore(team);
	}
	if(level.teams.size > 1)
	{
		otherteamscore = otherteamscore / (level.teams.size - 1);
	}
	if(otherteamscore != 0)
	{
		return float(score) / float(otherteamscore);
	}
	return score;
}

/*
	Name: gethighestscore
	Namespace: globallogic
	Checksum: 0x599E2635
	Offset: 0x44A8
	Size: 0x8E
	Parameters: 0
	Flags: None
*/
function gethighestscore()
{
	highestscore = -999999999;
	for(index = 0; index < level.players.size; index++)
	{
		player = level.players[index];
		if(player.score > highestscore)
		{
			highestscore = player.score;
		}
	}
	return highestscore;
}

/*
	Name: getnexthighestscore
	Namespace: globallogic
	Checksum: 0xA7489011
	Offset: 0x4540
	Size: 0xB2
	Parameters: 1
	Flags: None
*/
function getnexthighestscore(score)
{
	highestscore = -999999999;
	for(index = 0; index < level.players.size; index++)
	{
		player = level.players[index];
		if(player.score >= score)
		{
			continue;
		}
		if(player.score > highestscore)
		{
			highestscore = player.score;
		}
	}
	return highestscore;
}

/*
	Name: sendafteractionreport
	Namespace: globallogic
	Checksum: 0xEF8F83CF
	Offset: 0x4600
	Size: 0x8B6
	Parameters: 1
	Flags: Linked
*/
function sendafteractionreport(winner)
{
	/#
		if(getdvarint("") == 1)
		{
			return;
		}
	#/
	for(index = 0; index < level.players.size; index++)
	{
		player = level.players[index];
		spread = player.kills - player.deaths;
		if(player.pers["cur_kill_streak"] > player.pers["best_kill_streak"])
		{
			player.pers["best_kill_streak"] = player.pers["cur_kill_streak"];
		}
		if(level.rankedmatch)
		{
			player persistence::set_after_action_report_stat("privateMatch", 0);
		}
		else
		{
			player persistence::set_after_action_report_stat("privateMatch", 1);
		}
		player persistence::set_after_action_report_stat("demoFileID", getdemofileid());
		if(isdefined(winner) && winner == player.pers["team"])
		{
			player persistence::set_after_action_report_stat("matchWon", 1);
		}
		else
		{
			player persistence::set_after_action_report_stat("matchWon", 0);
		}
		revivemaster = 0;
		assistmaster = 0;
		killmaster = 0;
		for(index = 0; index < level.players.size; index++)
		{
			player persistence::set_after_action_report_player_stat(index, "isActive", 1);
			player persistence::set_after_action_report_player_stat(index, "name", level.players[index].name);
			player persistence::set_after_action_report_player_stat(index, "xuid", level.players[index] getxuid());
			player persistence::set_after_action_report_player_stat(index, "prvRank", int(level.players[index].pers["rank"]));
			player persistence::set_after_action_report_player_stat(index, "curRank", level.players[index] getdstat("playerstatslist", "rank", "StatValue"));
			player persistence::set_after_action_report_player_stat(index, "prvXP", int(level.players[index].pers["rankxp"]));
			player persistence::set_after_action_report_player_stat(index, "curXP", int(level.players[index] getdstat("playerstatslist", "rankxp", "StatValue")));
			player persistence::set_after_action_report_player_stat(index, "deaths", level.players[index].deaths);
			player persistence::set_after_action_report_player_stat(index, "kills", level.players[index].kills);
			if(level.players[index].kills > level.players[killmaster].kills)
			{
				killmaster = index;
			}
			player persistence::set_after_action_report_player_stat(index, "assists", level.players[index].assists);
			if(level.players[index].assists > level.players[assistmaster].assists)
			{
				assistmaster = index;
			}
			player persistence::set_after_action_report_player_stat(index, "revives", level.players[index].revives);
			if(level.players[index].revives > level.players[revivemaster].revives)
			{
				revivemaster = index;
			}
		}
		for(index = 0; index < level.players.size; index++)
		{
			player persistence::set_after_action_report_player_medal(index, 0, killmaster);
			player persistence::set_after_action_report_player_medal(index, 1, assistmaster);
			player persistence::set_after_action_report_player_medal(index, 2, revivemaster);
		}
		teamscoreratio = player getteamscoreratio();
		scoreboardposition = getplacementforplayer(player);
		if(scoreboardposition < 0)
		{
			scoreboardposition = level.players.size;
		}
		player gamehistoryfinishmatch(4, player.kills, player.deaths, player.score, scoreboardposition, teamscoreratio);
		placement = level.placement["all"];
		for(otherplayerindex = 0; otherplayerindex < placement.size; otherplayerindex++)
		{
			if(level.placement["all"][otherplayerindex] == player)
			{
				recordplayerstats(player, "position", otherplayerindex);
			}
		}
		player persistence::set_after_action_report_stat("valid", 1);
		player persistence::set_after_action_report_stat("viewed", 0);
		if(isdefined(player.pers["matchesPlayedStatsTracked"]))
		{
			gamemode = util::getcurrentgamemode();
			player incrementmatchcompletionstat(gamemode, "played", "completed");
			if(isdefined(player.pers["matchesHostedStatsTracked"]))
			{
				player incrementmatchcompletionstat(gamemode, "hosted", "completed");
				player.pers["matchesHostedStatsTracked"] = undefined;
			}
			player.pers["matchesPlayedStatsTracked"] = undefined;
		}
	}
}

/*
	Name: gamehistoryplayerkicked
	Namespace: globallogic
	Checksum: 0x1A2DF35C
	Offset: 0x4EC0
	Size: 0x1CA
	Parameters: 0
	Flags: Linked
*/
function gamehistoryplayerkicked()
{
	teamscoreratio = self getteamscoreratio();
	scoreboardposition = getplacementforplayer(self);
	if(scoreboardposition < 0)
	{
		scoreboardposition = level.players.size;
	}
	/#
		/#
			assert(isdefined(self.kills));
		#/
		/#
			assert(isdefined(self.deaths));
		#/
		/#
			assert(isdefined(self.score));
		#/
		/#
			assert(isdefined(scoreboardposition));
		#/
		/#
			assert(isdefined(teamscoreratio));
		#/
	#/
	self gamehistoryfinishmatch(2, self.kills, self.deaths, self.score, scoreboardposition, teamscoreratio);
	if(isdefined(self.pers["matchesPlayedStatsTracked"]))
	{
		gamemode = util::getcurrentgamemode();
		self incrementmatchcompletionstat(gamemode, "played", "kicked");
		self.pers["matchesPlayedStatsTracked"] = undefined;
	}
	uploadstats(self);
	wait(1);
}

/*
	Name: gamehistoryplayerquit
	Namespace: globallogic
	Checksum: 0x53D11759
	Offset: 0x5098
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function gamehistoryplayerquit()
{
	teamscoreratio = self getteamscoreratio();
	scoreboardposition = getplacementforplayer(self);
	if(scoreboardposition < 0)
	{
		scoreboardposition = level.players.size;
	}
	self gamehistoryfinishmatch(3, self.kills, self.deaths, self.score, scoreboardposition, teamscoreratio);
	if(isdefined(self.pers["matchesPlayedStatsTracked"]))
	{
		gamemode = util::getcurrentgamemode();
		self incrementmatchcompletionstat(gamemode, "played", "quit");
		if(isdefined(self.pers["matchesHostedStatsTracked"]))
		{
			self incrementmatchcompletionstat(gamemode, "hosted", "quit");
			self.pers["matchesHostedStatsTracked"] = undefined;
		}
		self.pers["matchesPlayedStatsTracked"] = undefined;
	}
	uploadstats(self);
	if(!self ishost())
	{
		wait(1);
	}
}

/*
	Name: displayroundend
	Namespace: globallogic
	Checksum: 0x313257F9
	Offset: 0x5238
	Size: 0x2A4
	Parameters: 2
	Flags: Linked
*/
function displayroundend(winner, endreasontext)
{
	if(level.displayroundendtext)
	{
		if(level.teambased)
		{
			if(winner == "tie")
			{
				demo::gameresultbookmark("round_result", level.teamindex["neutral"], level.teamindex["neutral"]);
			}
			else
			{
				demo::gameresultbookmark("round_result", level.teamindex[winner], level.teamindex["neutral"]);
			}
		}
		setmatchflag("cg_drawSpectatorMessages", 0);
		players = level.players;
		for(index = 0; index < players.size; index++)
		{
			player = players[index];
			if(!util::waslastround())
			{
				player notify(#"round_ended");
			}
			if(!isdefined(player.pers["team"]))
			{
				player [[level.spawnintermission]](1);
				continue;
			}
			if(level.wagermatch)
			{
				if(level.teambased)
				{
					player thread [[level.onteamwageroutcomenotify]](winner, 1, endreasontext);
				}
				else
				{
					player thread [[level.onwageroutcomenotify]](winner, endreasontext);
				}
			}
			else
			{
				if(level.teambased)
				{
					player thread [[level.onteamoutcomenotify]](winner, 1, endreasontext);
				}
				else
				{
					player thread [[level.onoutcomenotify]](winner, 1, endreasontext);
				}
			}
			player util::show_hud(0);
			player setclientuivisibilityflag("g_compassShowEnemies", 0);
		}
	}
	if(util::waslastround())
	{
		roundendwait(level.roundenddelay, 0);
	}
	else
	{
		roundendwait(level.roundenddelay, 1);
	}
}

/*
	Name: displayroundswitch
	Namespace: globallogic
	Checksum: 0x5783E69D
	Offset: 0x54E8
	Size: 0x22C
	Parameters: 2
	Flags: Linked
*/
function displayroundswitch(winner, endreasontext)
{
	switchtype = level.halftimetype;
	if(switchtype == "halftime")
	{
		if(isdefined(level.nextroundisovertime) && level.nextroundisovertime)
		{
			switchtype = "overtime";
		}
		else
		{
			if(level.roundlimit)
			{
				if((game["roundsplayed"] * 2) == level.roundlimit)
				{
					switchtype = "halftime";
				}
				else
				{
					switchtype = "intermission";
				}
			}
			else
			{
				if(level.scorelimit)
				{
					if(game["roundsplayed"] == (level.scorelimit - 1))
					{
						switchtype = "halftime";
					}
					else
					{
						switchtype = "intermission";
					}
				}
				else
				{
					switchtype = "intermission";
				}
			}
		}
	}
	setmatchtalkflag("EveryoneHearsEveryone", 1);
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		if(!isdefined(player.pers["team"]))
		{
			player [[level.spawnintermission]](1);
			continue;
		}
		if(level.wagermatch)
		{
			player thread [[level.onteamwageroutcomenotify]](switchtype, 1, level.halftimesubcaption);
		}
		else
		{
			player thread [[level.onteamoutcomenotify]](switchtype, 0, level.halftimesubcaption);
		}
		player util::show_hud(0);
	}
	roundendwait(level.halftimeroundenddelay, 0);
}

/*
	Name: displaygameend
	Namespace: globallogic
	Checksum: 0x1B7544AC
	Offset: 0x5720
	Size: 0x2E4
	Parameters: 3
	Flags: Linked
*/
function displaygameend(winner, endreasontext, endimage)
{
	setmatchtalkflag("EveryoneHearsEveryone", 1);
	setmatchflag("cg_drawSpectatorMessages", 0);
	if(level.teambased)
	{
		if(winner == "tie")
		{
			demo::gameresultbookmark("game_result", level.teamindex["neutral"], level.teamindex["neutral"]);
		}
		else
		{
			demo::gameresultbookmark("game_result", level.teamindex[winner], level.teamindex["neutral"]);
		}
	}
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		if(!isdefined(player.pers["team"]))
		{
			player [[level.spawnintermission]](1);
			continue;
		}
		if(level.teambased)
		{
			if(isdefined(level.onteamoutcomenotify))
			{
				player thread [[level.onteamoutcomenotify]](winner, 0, endreasontext);
			}
		}
		else if(isdefined(level.onoutcomenotify))
		{
			player thread [[level.onoutcomenotify]](winner, 0, endreasontext);
		}
		player util::show_hud(0);
		player setclientuivisibilityflag("g_compassShowEnemies", 0);
	}
	if(level.teambased)
	{
		players = level.players;
		for(index = 0; index < players.size; index++)
		{
			player = players[index];
			team = player.pers["team"];
		}
	}
	if(isdefined(level.gameenduicallback))
	{
		level thread [[level.gameenduicallback]](winner, endreasontext, endimage);
	}
	bbprint("global_session_epilogs", "reason %s", endreasontext);
	roundendwait(level.postroundtime, 1);
}

/*
	Name: getendreasontext
	Namespace: globallogic
	Checksum: 0x5FD324F5
	Offset: 0x5A10
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function getendreasontext()
{
	if(isdefined(level.endreasontext))
	{
		return level.endreasontext;
	}
	if(util::hitroundlimit() || util::hitroundwinlimit())
	{
		return game["strings"]["round_limit_reached"];
	}
	if(util::hitscorelimit())
	{
		return game["strings"]["score_limit_reached"];
	}
	if(level.forcedend)
	{
		if(level.hostforcedend)
		{
			return &"MP_HOST_ENDED_GAME";
		}
		return &"MP_ENDED_GAME";
	}
	return game["strings"]["time_limit_reached"];
}

/*
	Name: resetoutcomeforallplayers
	Namespace: globallogic
	Checksum: 0xA0BBFDB8
	Offset: 0x5AE8
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function resetoutcomeforallplayers()
{
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		player notify(#"reset_outcome");
	}
}

/*
	Name: startnextround
	Namespace: globallogic
	Checksum: 0x5D81E6BA
	Offset: 0x5B60
	Size: 0x25C
	Parameters: 2
	Flags: Linked
*/
function startnextround(winner, endreasontext)
{
	if(!util::isoneround())
	{
		displayroundend(winner, endreasontext);
		globallogic_utils::executepostroundevents();
		if(!util::waslastround())
		{
			if(checkroundswitch())
			{
				displayroundswitch(winner, endreasontext);
			}
			if(isdefined(level.nextroundisovertime) && level.nextroundisovertime)
			{
				if(!isdefined(game["overtime_round"]))
				{
					game["overtime_round"] = 1;
				}
				else
				{
					game["overtime_round"]++;
				}
			}
			setmatchtalkflag("DeadChatWithDead", level.voip.deadchatwithdead);
			setmatchtalkflag("DeadChatWithTeam", level.voip.deadchatwithteam);
			setmatchtalkflag("DeadHearTeamLiving", level.voip.deadhearteamliving);
			setmatchtalkflag("DeadHearAllLiving", level.voip.deadhearallliving);
			setmatchtalkflag("EveryoneHearsEveryone", level.voip.everyonehearseveryone);
			setmatchtalkflag("DeadHearKiller", level.voip.deadhearkiller);
			setmatchtalkflag("KillersHearVictim", level.voip.killershearvictim);
			game["state"] = "playing";
			level.allowbattlechatter["bc"] = getgametypesetting("allowBattleChatter");
			map_restart(1);
			return true;
		}
	}
	return false;
}

/*
	Name: settopplayerstats
	Namespace: globallogic
	Checksum: 0xDB32B331
	Offset: 0x5DC8
	Size: 0x342
	Parameters: 0
	Flags: Linked
*/
function settopplayerstats()
{
	if(level.rankedmatch || level.wagermatch)
	{
		placement = level.placement["all"];
		topthreeplayers = min(3, placement.size);
		for(index = 0; index < topthreeplayers; index++)
		{
			if(level.placement["all"][index].score)
			{
				if(!index)
				{
					level.placement["all"][index] addplayerstatwithgametype("TOPPLAYER", 1);
					level.placement["all"][index] notify(#"topplayer");
				}
				else
				{
					level.placement["all"][index] notify(#"nottopplayer");
				}
				level.placement["all"][index] addplayerstatwithgametype("TOP3", 1);
				level.placement["all"][index] addplayerstat("TOP3ANY", 1);
				if(level.hardcoremode)
				{
					level.placement["all"][index] addplayerstat("TOP3ANY_HC", 1);
				}
				if(level.multiteam)
				{
					level.placement["all"][index] addplayerstat("TOP3ANY_MULTITEAM", 1);
				}
				level.placement["all"][index] notify(#"top3");
			}
		}
		for(index = 3; index < placement.size; index++)
		{
			level.placement["all"][index] notify(#"nottop3");
			level.placement["all"][index] notify(#"nottopplayer");
		}
		if(level.teambased)
		{
			foreach(team in level.teams)
			{
				settopteamstats(team);
			}
		}
	}
}

/*
	Name: settopteamstats
	Namespace: globallogic
	Checksum: 0xC4B6BD4F
	Offset: 0x6118
	Size: 0x176
	Parameters: 1
	Flags: Linked
*/
function settopteamstats(team)
{
	placementteam = level.placement[team];
	topthreeteamplayers = min(3, placementteam.size);
	if(placementteam.size < 5)
	{
		return;
	}
	for(index = 0; index < topthreeteamplayers; index++)
	{
		if(placementteam[index].score)
		{
			placementteam[index] addplayerstat("TOP3TEAM", 1);
			placementteam[index] addplayerstat("TOP3ANY", 1);
			if(level.hardcoremode)
			{
				placementteam[index] addplayerstat("TOP3ANY_HC", 1);
			}
			if(level.multiteam)
			{
				placementteam[index] addplayerstat("TOP3ANY_MULTITEAM", 1);
			}
			placementteam[index] addplayerstatwithgametype("TOP3TEAM", 1);
		}
	}
}

/*
	Name: getgamelength
	Namespace: globallogic
	Checksum: 0x83EA325B
	Offset: 0x6298
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function getgamelength()
{
	if(!level.timelimit || level.forcedend)
	{
		gamelength = globallogic_utils::gettimepassed() / 1000;
		gamelength = min(gamelength, 1200);
	}
	else
	{
		gamelength = level.timelimit * 60;
	}
	return gamelength;
}

/*
	Name: function_f8e35b5
	Namespace: globallogic
	Checksum: 0x93534FEC
	Offset: 0x6320
	Size: 0x6E
	Parameters: 1
	Flags: Linked
*/
function function_f8e35b5(winner)
{
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		globallogic_player::function_be51e5e1(players[index], winner);
	}
}

/*
	Name: endgame
	Namespace: globallogic
	Checksum: 0x7987EF4E
	Offset: 0x6398
	Size: 0x9A4
	Parameters: 3
	Flags: Linked
*/
function endgame(winner, endreasontext, endimage)
{
	if(game["state"] == "postgame" || level.gameended)
	{
		return;
	}
	if(isdefined(level.onendgame))
	{
		[[level.onendgame]](winner);
	}
	if(!isdefined(level.disableoutrovisionset) || level.disableoutrovisionset == 0)
	{
		visionsetnaked("mpOutro", 2);
	}
	setmatchflag("cg_drawSpectatorMessages", 0);
	setmatchflag("game_ended", 1);
	game["state"] = "postgame";
	level.gameendtime = gettime();
	level.gameended = 1;
	setdvar("g_gameEnded", 1);
	level.ingraceperiod = 0;
	level notify(#"game_ended");
	level.allowbattlechatter = [];
	foreach(team in level.teams)
	{
		game["lastroundscore"][team] = getteamscore(team);
	}
	if(!isdefined(game["overtime_round"]) || util::waslastround())
	{
		game["roundsplayed"]++;
		game["roundwinner"][game["roundsplayed"]] = winner;
		if(level.teambased)
		{
			game["roundswon"][winner]++;
		}
	}
	setgameendtime(0);
	updateplacement();
	updaterankedmatch(winner);
	players = level.players;
	newtime = gettime();
	gamelength = getgamelength();
	setmatchtalkflag("EveryoneHearsEveryone", 1);
	bbgameover = 0;
	if(util::isoneround() || util::waslastround())
	{
		bbgameover = 1;
	}
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		player globallogic_player::freezeplayerforroundend();
		player thread roundenddof(4);
		player clearallnoncheckpointdata();
		player globallogic_ui::freegameplayhudelems();
		player weapons::update_timings(newtime);
		player bbplayermatchend(gamelength, endreasontext, bbgameover);
		if(level.rankedmatch || level.wagermatch || level.leaguematch && !player issplitscreen())
		{
			if(level.leaguematch)
			{
				player setdstat("AfterActionReportStats", "lobbyPopup", "leaguesummary");
				continue;
			}
			if(isdefined(player.setpromotion))
			{
				player setdstat("AfterActionReportStats", "lobbyPopup", "promotion");
				continue;
			}
			player setdstat("AfterActionReportStats", "lobbyPopup", "summary");
		}
	}
	music::setmusicstate("silent");
	gamerep::gamerepupdateinformationforround();
	thread challenges::roundend(winner);
	matchrecordsetleveldifficultyforindex(1, level.gameskill);
	function_f8e35b5(winner);
	recordgameresult("draw");
	globallogic_player::recordactiveplayersendgamematchrecordstats();
	finalizematchrecord();
	if(startnextround(winner, endreasontext))
	{
		return;
	}
	if(!util::isoneround())
	{
		if(isdefined(level.onroundendgame))
		{
			winner = [[level.onroundendgame]](winner);
		}
		endreasontext = getendreasontext();
	}
	skillupdate(winner, level.teambased);
	recordleaguewinner(winner);
	settopplayerstats();
	thread challenges::gameend(winner);
	level lui::screen_fade_out(1);
	wait(0.3);
	if(!isdefined(level.skipgameend) || !level.skipgameend)
	{
		displaygameend(winner, endreasontext, endimage);
	}
	if(util::isoneround())
	{
		globallogic_utils::executepostroundevents();
	}
	level.intermission = 1;
	gamerep::gamerepanalyzeandreport();
	thread sendafteractionreport(winner);
	setmatchflag("disableIngameMenu", 1);
	foreach(player in players)
	{
		player closeingamemenu();
	}
	setmatchtalkflag("EveryoneHearsEveryone", 1);
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		recordplayerstats(player, "presentAtEnd", 1);
		player notify(#"reset_outcome");
	}
	if(isdefined(level.endgamefunction))
	{
		level thread [[level.endgamefunction]]();
	}
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] setclientuivisibilityflag("weapon_hud_visible", 0);
		players[i] setclientminiscoreboardhide(1);
	}
	level notify(#"sfade");
	/#
		print("");
	#/
	if(isdefined(level.intermission_override_func))
	{
		[[level.intermission_override_func]]();
		level.intermission_override_func = undefined;
	}
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] cameraactivate(0);
	}
	exitlevel(0);
}

/*
	Name: bbplayermatchend
	Namespace: globallogic
	Checksum: 0xA339347E
	Offset: 0x6D48
	Size: 0xC0
	Parameters: 3
	Flags: Linked
*/
function bbplayermatchend(gamelength, endreasonstring, gameover)
{
	playerrank = getplacementforplayer(self);
	totaltimeplayed = 0;
	if(isdefined(self.timeplayed) && isdefined(self.timeplayed["total"]))
	{
		totaltimeplayed = self.timeplayed["total"];
		if(totaltimeplayed > gamelength)
		{
			totaltimeplayed = gamelength;
		}
	}
	xuid = self getxuid();
}

/*
	Name: roundendwait
	Namespace: globallogic
	Checksum: 0x85D70CD0
	Offset: 0x6E10
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function roundendwait(defaultdelay, matchbonus)
{
}

/*
	Name: roundenddof
	Namespace: globallogic
	Checksum: 0xB39336D5
	Offset: 0x6E30
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function roundenddof(time)
{
	self setdepthoffield(0, 128, 512, 4000, 6, 1.8);
}

/*
	Name: checktimelimit
	Namespace: globallogic
	Checksum: 0xE19C1DE
	Offset: 0x6E78
	Size: 0x130
	Parameters: 0
	Flags: Linked
*/
function checktimelimit()
{
	if(isdefined(level.timelimitoverride) && level.timelimitoverride)
	{
		return;
	}
	if(game["state"] != "playing")
	{
		setgameendtime(0);
		return;
	}
	if(level.timelimit <= 0)
	{
		setgameendtime(0);
		return;
	}
	if(level.inprematchperiod)
	{
		setgameendtime(0);
		return;
	}
	if(level.timerstopped)
	{
		setgameendtime(0);
		return;
	}
	if(!isdefined(level.starttime))
	{
		return;
	}
	timeleft = globallogic_utils::gettimeremaining();
	setgameendtime(gettime() + int(timeleft));
	if(timeleft > 0)
	{
		return;
	}
	[[level.ontimelimit]]();
}

/*
	Name: allteamsunderscorelimit
	Namespace: globallogic
	Checksum: 0xD2D1A752
	Offset: 0x6FB0
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function allteamsunderscorelimit()
{
	foreach(team in level.teams)
	{
		if(game["teamScores"][team] >= level.scorelimit)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: checkscorelimit
	Namespace: globallogic
	Checksum: 0x2FED31
	Offset: 0x7058
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function checkscorelimit()
{
	if(game["state"] != "playing")
	{
		return false;
	}
	if(level.scorelimit <= 0)
	{
		return false;
	}
	if(level.teambased)
	{
		if(allteamsunderscorelimit())
		{
			return false;
		}
	}
	else
	{
		if(!isplayer(self))
		{
			return false;
		}
		if(self.pointstowin < level.scorelimit)
		{
			return false;
		}
	}
	[[level.onscorelimit]]();
}

/*
	Name: updategametypedvars
	Namespace: globallogic
	Checksum: 0x1078E133
	Offset: 0x7108
	Size: 0x20E
	Parameters: 0
	Flags: Linked
*/
function updategametypedvars()
{
	level endon(#"game_ended");
	while(game["state"] == "playing")
	{
		roundlimit = math::clamp(getgametypesetting("roundLimit"), level.roundlimitmin, level.roundlimitmax);
		if(roundlimit != level.roundlimit)
		{
			level.roundlimit = roundlimit;
			level notify(#"update_roundlimit");
		}
		timelimit = [[level.gettimelimit]]();
		if(timelimit != level.timelimit)
		{
			level.timelimit = timelimit;
			setdvar("ui_timelimit", level.timelimit);
			level notify(#"update_timelimit");
		}
		thread checktimelimit();
		scorelimit = math::clamp(getgametypesetting("scoreLimit"), level.scorelimitmin, level.scorelimitmax);
		if(scorelimit != level.scorelimit)
		{
			level.scorelimit = scorelimit;
			setdvar("ui_scorelimit", level.scorelimit);
			level notify(#"update_scorelimit");
		}
		thread checkscorelimit();
		if(isdefined(level.starttime))
		{
			remaining_time = globallogic_utils::gettimeremaining();
			if(isdefined(remaining_time) && remaining_time < 3000)
			{
				wait(0.1);
				continue;
			}
		}
		wait(1);
	}
}

/*
	Name: removedisconnectedplayerfromplacement
	Namespace: globallogic
	Checksum: 0x1AD228A6
	Offset: 0x7320
	Size: 0x1D6
	Parameters: 0
	Flags: Linked
*/
function removedisconnectedplayerfromplacement()
{
	offset = 0;
	numplayers = level.placement["all"].size;
	found = 0;
	for(i = 0; i < numplayers; i++)
	{
		if(level.placement["all"][i] == self)
		{
			found = 1;
		}
		if(found)
		{
			level.placement["all"][i] = level.placement["all"][i + 1];
		}
	}
	if(!found)
	{
		return;
	}
	level.placement["all"][numplayers - 1] = undefined;
	/#
		assert(level.placement[""].size == (numplayers - 1));
	#/
	/#
		globallogic_utils::assertproperplacement();
	#/
	updateteamplacement();
	if(level.teambased)
	{
		return;
	}
	numplayers = level.placement["all"].size;
	for(i = 0; i < numplayers; i++)
	{
		player = level.placement["all"][i];
		player notify(#"update_outcome");
	}
}

/*
	Name: updateplacement
	Namespace: globallogic
	Checksum: 0xBD7F336C
	Offset: 0x7500
	Size: 0x37C
	Parameters: 0
	Flags: Linked
*/
function updateplacement()
{
	if(!level.players.size)
	{
		return;
	}
	level.placement["all"] = [];
	foreach(player in level.players)
	{
		if(!level.teambased || isdefined(level.teams[player.team]))
		{
			level.placement["all"][level.placement["all"].size] = player;
		}
	}
	placementall = level.placement["all"];
	if(level.teambased)
	{
		for(i = 1; i < placementall.size; i++)
		{
			player = placementall[i];
			playerscore = player.score;
			for(j = i - 1; j >= 0 && (playerscore > placementall[j].score || (playerscore == placementall[j].score && player.deaths < placementall[j].deaths)); j--)
			{
				placementall[j + 1] = placementall[j];
			}
			placementall[j + 1] = player;
		}
	}
	else
	{
		for(i = 1; i < placementall.size; i++)
		{
			player = placementall[i];
			playerscore = player.pointstowin;
			for(j = i - 1; j >= 0 && (playerscore > placementall[j].pointstowin || (playerscore == placementall[j].pointstowin && player.deaths < placementall[j].deaths)); j--)
			{
				placementall[j + 1] = placementall[j];
			}
			placementall[j + 1] = player;
		}
	}
	level.placement["all"] = placementall;
	/#
		globallogic_utils::assertproperplacement();
	#/
	updateteamplacement();
}

/*
	Name: updateteamplacement
	Namespace: globallogic
	Checksum: 0x87375B97
	Offset: 0x7888
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function updateteamplacement()
{
	foreach(team in level.teams)
	{
		placement[team] = [];
	}
	placement["spectator"] = [];
	if(!level.teambased)
	{
		return;
	}
	placementall = level.placement["all"];
	placementallsize = placementall.size;
	for(i = 0; i < placementallsize; i++)
	{
		player = placementall[i];
		team = player.pers["team"];
		placement[team][placement[team].size] = player;
	}
	foreach(team in level.teams)
	{
		level.placement[team] = placement[team];
	}
}

/*
	Name: getplacementforplayer
	Namespace: globallogic
	Checksum: 0x186DCFB6
	Offset: 0x7A68
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function getplacementforplayer(player)
{
	updateplacement();
	playerrank = -1;
	placement = level.placement["all"];
	for(placementindex = 0; placementindex < placement.size; placementindex++)
	{
		if(level.placement["all"][placementindex] == player)
		{
			playerrank = placementindex + 1;
			break;
		}
	}
	return playerrank;
}

/*
	Name: istopscoringplayer
	Namespace: globallogic
	Checksum: 0x26AF8EFC
	Offset: 0x7B28
	Size: 0x254
	Parameters: 1
	Flags: None
*/
function istopscoringplayer(player)
{
	topplayer = 0;
	updateplacement();
	/#
		assert(level.placement[""].size > 0);
	#/
	if(level.placement["all"].size == 0)
	{
		return 0;
	}
	if(level.teambased)
	{
		topscore = level.placement["all"][0].score;
		for(index = 0; index < level.placement["all"].size; index++)
		{
			if(level.placement["all"][index].score == 0)
			{
				break;
			}
			if(topscore > level.placement["all"][index].score)
			{
				break;
			}
			if(self == level.placement["all"][index])
			{
				topscoringplayer = 1;
				break;
			}
		}
	}
	else
	{
		topscore = level.placement["all"][0].pointstowin;
		for(index = 0; index < level.placement["all"].size; index++)
		{
			if(level.placement["all"][index].pointstowin == 0)
			{
				break;
			}
			if(topscore > level.placement["all"][index].pointstowin)
			{
				break;
			}
			if(self == level.placement["all"][index])
			{
				topplayer = 1;
				break;
			}
		}
	}
	return topplayer;
}

/*
	Name: sortdeadplayers
	Namespace: globallogic
	Checksum: 0xC7D7EAAB
	Offset: 0x7D88
	Size: 0x19A
	Parameters: 1
	Flags: Linked
*/
function sortdeadplayers(team)
{
	if(!level.playerqueuedrespawn)
	{
		return;
	}
	for(i = 1; i < level.deadplayers[team].size; i++)
	{
		player = level.deadplayers[team][i];
		for(j = i - 1; j >= 0 && player.deathtime < level.deadplayers[team][j].deathtime; j--)
		{
			level.deadplayers[team][j + 1] = level.deadplayers[team][j];
		}
		level.deadplayers[team][j + 1] = player;
	}
	for(i = 0; i < level.deadplayers[team].size; i++)
	{
		if(level.deadplayers[team][i].spawnqueueindex != i)
		{
			level.spawnqueuemodified[team] = 1;
		}
		level.deadplayers[team][i].spawnqueueindex = i;
	}
}

/*
	Name: totalalivecount
	Namespace: globallogic
	Checksum: 0x744F8469
	Offset: 0x7F30
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function totalalivecount()
{
	count = 0;
	foreach(team in level.teams)
	{
		count = count + level.alivecount[team];
	}
	return count;
}

/*
	Name: totalplayerlives
	Namespace: globallogic
	Checksum: 0x9CFBB13C
	Offset: 0x7FE0
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function totalplayerlives()
{
	count = 0;
	foreach(team in level.teams)
	{
		count = count + level.playerlives[team];
	}
	return count;
}

/*
	Name: totallaststandcount
	Namespace: globallogic
	Checksum: 0x712B71A6
	Offset: 0x8090
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function totallaststandcount()
{
	count = 0;
	foreach(team in level.teams)
	{
		count = count + level.laststandcount[team];
	}
	return count;
}

/*
	Name: initteamvariables
	Namespace: globallogic
	Checksum: 0xC4CD44D
	Offset: 0x8140
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function initteamvariables(team)
{
	if(!isdefined(level.alivecount))
	{
		level.alivecount = [];
	}
	if(!isdefined(level.laststandcount))
	{
		level.laststandcount = [];
	}
	level.alivecount[team] = 0;
	level.lastalivecount[team] = 0;
	level.laststandcount[team] = 0;
	if(!isdefined(game["everExisted"]))
	{
		game["everExisted"] = [];
	}
	if(!isdefined(game["everExisted"][team]))
	{
		game["everExisted"][team] = 0;
	}
	level.everexisted[team] = 0;
	level.wavedelay[team] = 0;
	level.lastwave[team] = 0;
	level.waveplayerspawnindex[team] = 0;
	resetteamvariables(team);
}

/*
	Name: resetteamvariables
	Namespace: globallogic
	Checksum: 0x7D5BE72C
	Offset: 0x8260
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function resetteamvariables(team)
{
	level.playercount[team] = 0;
	level.lastalivecount[team] = level.alivecount[team];
	level.alivecount[team] = 0;
	level.laststandcount[team] = 0;
	level.playerlives[team] = 0;
	level.aliveplayers[team] = [];
	level.deadplayers[team] = [];
	level.squads[team] = [];
	level.spawnqueuemodified[team] = 0;
}

/*
	Name: updateteamstatus
	Namespace: globallogic
	Checksum: 0x80FA82D2
	Offset: 0x8318
	Size: 0x3F4
	Parameters: 0
	Flags: Linked
*/
function updateteamstatus()
{
	if(game["state"] == "postgame")
	{
		return;
	}
	resettimeout();
	foreach(team in level.teams)
	{
		resetteamvariables(team);
	}
	level.activeplayers = [];
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!isdefined(player) && level.splitscreen)
		{
			continue;
		}
		team = player.team;
		playerclass = player.curclass;
		if(team != "spectator" && (isdefined(playerclass) && playerclass != ""))
		{
			level.playercount[team]++;
			if(player.sessionstate == "playing")
			{
				level.alivecount[team]++;
				level.playerlives[team]++;
				player.spawnqueueindex = -1;
				if(isalive(player))
				{
					level.aliveplayers[team][level.aliveplayers[team].size] = player;
					level.activeplayers[level.activeplayers.size] = player;
					if(isdefined(player.laststand) && player.laststand)
					{
						level.laststandcount[team]++;
					}
				}
				else
				{
					level.deadplayers[team][level.deadplayers[team].size] = player;
				}
				continue;
			}
			level.deadplayers[team][level.deadplayers[team].size] = player;
			if(player globallogic_spawn::mayspawn())
			{
				level.playerlives[team]++;
			}
		}
	}
	totalalive = totalalivecount();
	if(totalalive > level.maxplayercount)
	{
		level.maxplayercount = totalalive;
	}
	foreach(team in level.teams)
	{
		if(level.alivecount[team])
		{
			game["everExisted"][team] = 1;
			level.everexisted[team] = 1;
		}
		sortdeadplayers(team);
	}
	level updategameevents();
}

/*
	Name: checkteamscorelimitsoon
	Namespace: globallogic
	Checksum: 0x7A5EC269
	Offset: 0x8718
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function checkteamscorelimitsoon(team)
{
	/#
		assert(isdefined(team));
	#/
	if(level.scorelimit <= 0)
	{
		return;
	}
	if(!level.teambased)
	{
		return;
	}
	if(globallogic_utils::gettimepassed() < 60000)
	{
		return;
	}
	timeleft = globallogic_utils::getestimatedtimeuntilscorelimit(team);
	if(timeleft < 1)
	{
		level notify(#"match_ending_soon", "score");
	}
}

/*
	Name: checkplayerscorelimitsoon
	Namespace: globallogic
	Checksum: 0x85C4DEB6
	Offset: 0x87D8
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function checkplayerscorelimitsoon()
{
	/#
		assert(isplayer(self));
	#/
	if(level.scorelimit <= 0)
	{
		return;
	}
	if(level.teambased)
	{
		return;
	}
	if(globallogic_utils::gettimepassed() < 60000)
	{
		return;
	}
	timeleft = globallogic_utils::getestimatedtimeuntilscorelimit(undefined);
	if(timeleft < 1)
	{
		level notify(#"match_ending_soon", "score");
	}
}

/*
	Name: timelimitclock
	Namespace: globallogic
	Checksum: 0xBD358753
	Offset: 0x8890
	Size: 0x29C
	Parameters: 0
	Flags: Linked
*/
function timelimitclock()
{
	level endon(#"game_ended");
	wait(0.05);
	clockobject = spawn("script_origin", (0, 0, 0));
	while(game["state"] == "playing")
	{
		if(!level.timerstopped && level.timelimit)
		{
			timeleft = globallogic_utils::gettimeremaining() / 1000;
			timeleftint = int(timeleft + 0.5);
			if(timeleftint == 601)
			{
				util::clientnotify("notify_10");
			}
			if(timeleftint == 301)
			{
				util::clientnotify("notify_5");
			}
			if(timeleftint == 60)
			{
				util::clientnotify("notify_1");
			}
			if(timeleftint == 12)
			{
				util::clientnotify("notify_count");
			}
			if(timeleftint >= 40 && timeleftint <= 60)
			{
				level notify(#"match_ending_soon", "time");
			}
			if(timeleftint >= 30 && timeleftint <= 40)
			{
				level notify(#"match_ending_pretty_soon", "time");
			}
			if(timeleftint <= 32)
			{
				level notify(#"match_ending_vox");
			}
			if(timeleftint <= 10 || (timeleftint <= 30 && (timeleftint % 2) == 0))
			{
				level notify(#"match_ending_very_soon", "time");
				if(timeleftint == 0)
				{
					break;
				}
				clockobject playsound("mpl_ui_timer_countdown");
			}
			if((timeleft - floor(timeleft)) >= 0.05)
			{
				wait(timeleft - floor(timeleft));
			}
		}
		wait(1);
	}
}

/*
	Name: timelimitclock_intermission
	Namespace: globallogic
	Checksum: 0xF8E8C6B3
	Offset: 0x8B38
	Size: 0xB0
	Parameters: 1
	Flags: None
*/
function timelimitclock_intermission(waittime)
{
	setgameendtime(gettime() + (int(waittime * 1000)));
	clockobject = spawn("script_origin", (0, 0, 0));
	if(waittime >= 10)
	{
		wait(waittime - 10);
	}
	for(;;)
	{
		clockobject playsound("mpl_ui_timer_countdown");
		wait(1);
	}
}

/*
	Name: function_59b8efe0
	Namespace: globallogic
	Checksum: 0x18E2A8E4
	Offset: 0x8BF0
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_59b8efe0()
{
	level endon(#"game_ended");
	while(true)
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if(isalive(player))
			{
				recordbreadcrumbdataforplayer(player, undefined);
			}
		}
		wait(15);
	}
}

/*
	Name: startgame
	Namespace: globallogic
	Checksum: 0x2514E735
	Offset: 0x8C98
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function startgame()
{
	thread globallogic_utils::gametimer();
	level.timerstopped = 0;
	setmatchtalkflag("DeadChatWithDead", level.voip.deadchatwithdead);
	setmatchtalkflag("DeadChatWithTeam", level.voip.deadchatwithteam);
	setmatchtalkflag("DeadHearTeamLiving", level.voip.deadhearteamliving);
	setmatchtalkflag("DeadHearAllLiving", level.voip.deadhearallliving);
	setmatchtalkflag("EveryoneHearsEveryone", level.voip.everyonehearseveryone);
	setmatchtalkflag("DeadHearKiller", level.voip.deadhearkiller);
	setmatchtalkflag("KillersHearVictim", level.voip.killershearvictim);
	if(isdefined(level.custom_prematch_period))
	{
		[[level.custom_prematch_period]]();
	}
	else
	{
		prematchperiod();
	}
	level notify(#"prematch_over");
	thread timelimitclock();
	thread graceperiod();
	thread watchmatchendingsoon();
	recordmatchbegin();
	if(!(isdefined(level.is_safehouse) && level.is_safehouse))
	{
		thread function_59b8efe0();
		thread bb::recordblackboxbreadcrumbdata("cpbreadcrumb");
	}
}

/*
	Name: waitforplayers
	Namespace: globallogic
	Checksum: 0xDA0FC671
	Offset: 0x8EA0
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function waitforplayers()
{
	starttime = gettime();
	while(getnumconnectedplayers() < 1)
	{
		wait(0.05);
		if((gettime() - starttime) > 120000)
		{
			exitlevel(0);
		}
	}
}

/*
	Name: prematchperiod
	Namespace: globallogic
	Checksum: 0x589B1795
	Offset: 0x8F08
	Size: 0x136
	Parameters: 0
	Flags: Linked
*/
function prematchperiod()
{
	setmatchflag("hud_hardcore", level.hardcoremode);
	level endon(#"game_ended");
	if(level.prematchperiod > 0)
	{
		thread matchstarttimer();
		waitforplayers();
		wait(level.prematchperiod);
	}
	else
	{
		matchstarttimerskip();
		wait(0.05);
	}
	level.inprematchperiod = 0;
	for(index = 0; index < level.players.size; index++)
	{
		level.players[index] util::freeze_player_controls(0);
		level.players[index] enableweapons();
	}
	wager::prematch_period();
	if(game["state"] != "playing")
	{
		return;
	}
}

/*
	Name: graceperiod
	Namespace: globallogic
	Checksum: 0xA7736049
	Offset: 0x9048
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function graceperiod()
{
	level endon(#"game_ended");
	if(isdefined(level.graceperiodfunc))
	{
		[[level.graceperiodfunc]]();
	}
	else
	{
		wait(level.graceperiod);
	}
	level notify(#"grace_period_ending");
	wait(0.05);
	level.ingraceperiod = 0;
	if(game["state"] != "playing")
	{
		return;
	}
	if(level.numlives)
	{
		players = level.players;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player.hasspawned && player.sessionteam != "spectator" && !isalive(player))
			{
				player.statusicon = "hud_status_dead";
			}
		}
	}
	updateteamstatus();
}

/*
	Name: watchmatchendingsoon
	Namespace: globallogic
	Checksum: 0x32D8BA44
	Offset: 0x91A0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function watchmatchendingsoon()
{
	setdvar("xblive_matchEndingSoon", 0);
	level waittill(#"match_ending_soon", reason);
	setdvar("xblive_matchEndingSoon", 1);
}

/*
	Name: anyteamhaswavedelay
	Namespace: globallogic
	Checksum: 0x9D336D38
	Offset: 0x9200
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function anyteamhaswavedelay()
{
	foreach(team in level.teams)
	{
		if(level.wavedelay[team])
		{
			return true;
		}
	}
	return false;
}

/*
	Name: callback_startgametype
	Namespace: globallogic
	Checksum: 0xFB4E82E5
	Offset: 0x9298
	Size: 0x150C
	Parameters: 0
	Flags: Linked
*/
function callback_startgametype()
{
	level.prematchperiod = 0;
	level.intermission = 0;
	setmatchflag("cg_drawSpectatorMessages", 1);
	setmatchflag("game_ended", 0);
	if(!isdefined(game["gamestarted"]))
	{
		if(!isdefined(game["allies"]))
		{
			game["allies"] = "seals";
		}
		if(!isdefined(game["axis"]))
		{
			game["axis"] = "pmc";
		}
		if(!isdefined(game["attackers"]))
		{
			game["attackers"] = "allies";
		}
		if(!isdefined(game["defenders"]))
		{
			game["defenders"] = "axis";
		}
		/#
			assert(game[""] != game[""]);
		#/
		foreach(team in level.teams)
		{
			if(!isdefined(game[team]))
			{
				game[team] = "pmc";
			}
		}
		if(!isdefined(game["state"]))
		{
			game["state"] = "playing";
		}
		setdvar("cg_thirdPersonAngle", 354);
		game["strings"]["press_to_spawn"] = &"PLATFORM_PRESS_TO_SPAWN";
		if(level.teambased)
		{
			game["strings"]["waiting_for_teams"] = &"MP_WAITING_FOR_TEAMS";
			game["strings"]["opponent_forfeiting_in"] = &"MP_OPPONENT_FORFEITING_IN";
		}
		else
		{
			game["strings"]["waiting_for_teams"] = &"MP_WAITING_FOR_PLAYERS";
			game["strings"]["opponent_forfeiting_in"] = &"MP_OPPONENT_FORFEITING_IN";
		}
		game["strings"]["match_starting_in"] = &"MP_MATCH_STARTING_IN";
		game["strings"]["spawn_next_round"] = &"COOP_SPAWN_NEXT_ROUND";
		game["strings"]["waiting_to_spawn"] = &"MP_WAITING_TO_SPAWN";
		game["strings"]["waiting_to_spawn_ss"] = &"MP_WAITING_TO_SPAWN_SS";
		game["strings"]["you_will_spawn"] = &"MP_YOU_WILL_RESPAWN";
		game["strings"]["match_starting"] = &"MP_MATCH_STARTING";
		game["strings"]["change_class"] = &"MP_CHANGE_CLASS_NEXT_SPAWN";
		game["strings"]["last_stand"] = &"MPUI_LAST_STAND";
		game["strings"]["cowards_way"] = &"PLATFORM_COWARDS_WAY_OUT";
		game["strings"]["tie"] = &"MP_MATCH_TIE";
		game["strings"]["round_draw"] = &"MP_ROUND_DRAW";
		game["strings"]["enemies_eliminated"] = &"MP_ENEMIES_ELIMINATED";
		game["strings"]["score_limit_reached"] = &"MP_SCORE_LIMIT_REACHED";
		game["strings"]["round_limit_reached"] = &"MP_ROUND_LIMIT_REACHED";
		game["strings"]["time_limit_reached"] = &"MP_TIME_LIMIT_REACHED";
		game["strings"]["players_forfeited"] = &"MP_PLAYERS_FORFEITED";
		game["strings"]["other_teams_forfeited"] = &"MP_OTHER_TEAMS_FORFEITED";
		[[level.onprecachegametype]]();
		game["gamestarted"] = 1;
		game["totalKills"] = 0;
		foreach(team in level.teams)
		{
			game["teamScores"][team] = 0;
			game["totalKillsTeam"][team] = 0;
		}
		level.prematchperiod = getgametypesetting("prematchperiod");
		if(getdvarint("xblive_clanmatch") != 0)
		{
			foreach(team in level.teams)
			{
				game["icons"][team] = "composite_emblem_team_axis";
			}
			game["icons"]["allies"] = "composite_emblem_team_allies";
			game["icons"]["axis"] = "composite_emblem_team_axis";
		}
	}
	else if(!level.splitscreen)
	{
		level.prematchperiod = getgametypesetting("preroundperiod");
	}
	if(!isdefined(game["timepassed"]))
	{
		game["timepassed"] = 0;
	}
	if(!isdefined(game["roundsplayed"]))
	{
		game["roundsplayed"] = 0;
	}
	setroundsplayed(game["roundsplayed"]);
	if(isdefined(game["overtime_round"]))
	{
		setmatchflag("overtime", 1);
	}
	else
	{
		setmatchflag("overtime", 0);
	}
	if(!isdefined(game["roundwinner"]))
	{
		game["roundwinner"] = [];
	}
	if(!isdefined(game["lastroundscore"]))
	{
		game["lastroundscore"] = [];
	}
	if(!isdefined(game["roundswon"]))
	{
		game["roundswon"] = [];
	}
	if(!isdefined(game["roundswon"]["tie"]))
	{
		game["roundswon"]["tie"] = 0;
	}
	foreach(team in level.teams)
	{
		if(!isdefined(game["roundswon"][team]))
		{
			game["roundswon"][team] = 0;
		}
		level.teamspawnpoints[team] = [];
		level.spawn_point_team_class_names[team] = [];
	}
	level.skipvote = 0;
	level.gameended = 0;
	setdvar("g_gameEnded", 0);
	level.objidstart = 0;
	level.forcedend = 0;
	level.hostforcedend = 0;
	level.hardcoremode = getgametypesetting("hardcoreMode");
	if(level.hardcoremode)
	{
		/#
			print("");
		#/
		if(!isdefined(level.friendlyfiredelaytime))
		{
			level.friendlyfiredelaytime = 0;
		}
	}
	if(getdvarstring("scr_max_rank") == "")
	{
		setdvar("scr_max_rank", "0");
	}
	level.rankcap = getdvarint("scr_max_rank");
	if(getdvarstring("scr_min_prestige") == "")
	{
		setdvar("scr_min_prestige", "0");
	}
	level.minprestige = getdvarint("scr_min_prestige");
	level.usestartspawns = 1;
	level.cumulativeroundscores = getgametypesetting("cumulativeRoundScores");
	level.allowhitmarkers = getgametypesetting("allowhitmarkers");
	level.playerqueuedrespawn = getgametypesetting("playerQueuedRespawn");
	level.playerforcerespawn = getgametypesetting("playerForceRespawn");
	level.roundstartexplosivedelay = getgametypesetting("roundStartExplosiveDelay");
	level.roundstartkillstreakdelay = getgametypesetting("roundStartKillstreakDelay");
	level.perksenabled = getgametypesetting("perksEnabled");
	level.disableattachments = getgametypesetting("disableAttachments");
	level.disabletacinsert = getgametypesetting("disableTacInsert");
	level.disablecac = getgametypesetting("disableCAC");
	if(!isdefined(level.disableclassselection))
	{
		level.disableclassselection = getgametypesetting("disableClassSelection");
	}
	level.disableweapondrop = getgametypesetting("disableweapondrop");
	level.onlyheadshots = getgametypesetting("onlyHeadshots");
	level.minimumallowedteamkills = getgametypesetting("teamKillPunishCount") - 1;
	level.teamkillreducedpenalty = getgametypesetting("teamKillReducedPenalty");
	level.teamkillpointloss = getgametypesetting("teamKillPointLoss");
	level.teamkillspawndelay = getgametypesetting("teamKillSpawnDelay");
	level.deathpointloss = getgametypesetting("deathPointLoss");
	level.leaderbonus = getgametypesetting("leaderBonus");
	level.forceradar = getgametypesetting("forceRadar");
	level.playersprinttime = getgametypesetting("playerSprintTime");
	level.bulletdamagescalar = getgametypesetting("bulletDamageScalar");
	level.playermaxhealth = getgametypesetting("playerMaxHealth");
	level.playerhealthregentime = getgametypesetting("playerHealthRegenTime");
	level.playerrespawndelay = getgametypesetting("playerRespawnDelay");
	level.playerobjectiveheldrespawndelay = getgametypesetting("playerObjectiveHeldRespawnDelay");
	level.waverespawndelay = getgametypesetting("waveRespawnDelay");
	level.suicidespawndelay = getgametypesetting("spawnsuicidepenalty");
	level.teamkilledspawndelay = getgametypesetting("spawnteamkilledpenalty");
	level.maxsuicidesbeforekick = getgametypesetting("maxsuicidesbeforekick");
	level.spectatetype = getgametypesetting("spectateType");
	level.voip = spawnstruct();
	level.voip.deadchatwithdead = getgametypesetting("voipDeadChatWithDead");
	level.voip.deadchatwithteam = getgametypesetting("voipDeadChatWithTeam");
	level.voip.deadhearallliving = getgametypesetting("voipDeadHearAllLiving");
	level.voip.deadhearteamliving = getgametypesetting("voipDeadHearTeamLiving");
	level.voip.everyonehearseveryone = getgametypesetting("voipEveryoneHearsEveryone");
	level.voip.deadhearkiller = getgametypesetting("voipDeadHearKiller");
	level.voip.killershearvictim = getgametypesetting("voipKillersHearVictim");
	gameobjects::main();
	callback::callback(#"hash_cc62acca");
	foreach(team in level.teams)
	{
		initteamvariables(team);
	}
	level.maxplayercount = 0;
	level.activeplayers = [];
	level.allowannouncer = getgametypesetting("allowAnnouncer");
	if(!isdefined(level.timelimit))
	{
		util::registertimelimit(1, 1440);
	}
	if(!isdefined(level.scorelimit))
	{
		util::registerscorelimit(1, 500);
	}
	if(!isdefined(level.roundlimit))
	{
		util::registerroundlimit(0, 10);
	}
	if(!isdefined(level.roundwinlimit))
	{
		util::registerroundwinlimit(0, 10);
	}
	globallogic_utils::registerpostroundevent(&wager::post_round_side_bet);
	wavedelay = level.waverespawndelay;
	if(wavedelay)
	{
		foreach(team in level.teams)
		{
			level.wavedelay[team] = wavedelay;
			level.lastwave[team] = 0;
		}
		level thread [[level.wavespawntimer]]();
	}
	level.inprematchperiod = 1;
	if(level.prematchperiod > 2)
	{
		level.prematchperiod = level.prematchperiod + (randomfloat(4) - 2);
	}
	if(level.numlives || anyteamhaswavedelay() || level.playerqueuedrespawn)
	{
		level.graceperiod = 1500;
	}
	else
	{
		level.graceperiod = 1500;
	}
	level.ingraceperiod = 1;
	level.roundenddelay = 5;
	level.halftimeroundenddelay = 3;
	globallogic_score::updateallteamscores();
	level.killstreaksenabled = 1;
	if(getdvarstring("scr_game_rankenabled") == "")
	{
		setdvar("scr_game_rankenabled", 1);
	}
	level.rankenabled = getdvarint("scr_game_rankenabled");
	if(getdvarstring("scr_game_medalsenabled") == "")
	{
		setdvar("scr_game_medalsenabled", 1);
	}
	level.medalsenabled = getdvarint("scr_game_medalsenabled");
	if(level.hardcoremode && level.rankedmatch && getdvarstring("scr_game_friendlyFireDelay") == "")
	{
		setdvar("scr_game_friendlyFireDelay", 1);
	}
	level.friendlyfiredelay = getdvarint("scr_game_friendlyFireDelay");
	[[level.onstartgametype]]();
	if(getdvarint("custom_killstreak_mode") == 1)
	{
		level.killstreaksenabled = 0;
	}
	if(isdefined(level.gameskill))
	{
		matchrecordsetleveldifficultyforindex(0, level.gameskill);
	}
	thread startgame();
	level thread updategametypedvars();
	level thread simple_hostmigration::updatehostmigrationdata();
	/#
		if(getdvarint("") == 1)
		{
			level.skipgameend = 1;
			level.roundlimit = 1;
			wait(1);
			thread forceend(0);
		}
		if(getdvarint("") == 1)
		{
			thread forcedebughostmigration();
		}
	#/
}

/*
	Name: forcedebughostmigration
	Namespace: globallogic
	Checksum: 0x6DAC059C
	Offset: 0xA7B0
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function forcedebughostmigration()
{
	/#
		while(true)
		{
			hostmigration::waittillhostmigrationdone();
			wait(60);
			starthostmigration();
			hostmigration::waittillhostmigrationdone();
		}
	#/
}

/*
	Name: registerfriendlyfiredelay
	Namespace: globallogic
	Checksum: 0x634D1BDA
	Offset: 0xA808
	Size: 0x10C
	Parameters: 4
	Flags: Linked
*/
function registerfriendlyfiredelay(dvarstring, defaultvalue, minvalue, maxvalue)
{
	dvarstring = ("scr_" + dvarstring) + "_friendlyFireDelayTime";
	if(getdvarstring(dvarstring) == "")
	{
		setdvar(dvarstring, defaultvalue);
	}
	if(getdvarint(dvarstring) > maxvalue)
	{
		setdvar(dvarstring, maxvalue);
	}
	else if(getdvarint(dvarstring) < minvalue)
	{
		setdvar(dvarstring, minvalue);
	}
	level.friendlyfiredelaytime = getdvarint(dvarstring);
}

/*
	Name: checkroundswitch
	Namespace: globallogic
	Checksum: 0x5A5E1360
	Offset: 0xA920
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function checkroundswitch()
{
	if(!isdefined(level.roundswitch) || !level.roundswitch)
	{
		return false;
	}
	if(!isdefined(level.onroundswitch))
	{
		return false;
	}
	/#
		assert(game[""] > 0);
	#/
	if((game["roundsplayed"] % level.roundswitch) == 0)
	{
		[[level.onroundswitch]]();
		return true;
	}
	return false;
}

/*
	Name: listenforgameend
	Namespace: globallogic
	Checksum: 0x39069411
	Offset: 0xA9B8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function listenforgameend()
{
	self endon(#"killgameendmonitor");
	self waittill(#"host_sucks_end_game");
	level.skipvote = 1;
	if(!level.gameended)
	{
		level thread forceend(1);
	}
}

/*
	Name: getkillstreaks
	Namespace: globallogic
	Checksum: 0x6E9C3BE6
	Offset: 0xAA10
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function getkillstreaks(player)
{
	for(killstreaknum = 0; killstreaknum < level.maxkillstreaks; killstreaknum++)
	{
		killstreak[killstreaknum] = "killstreak_null";
	}
	if(isplayer(player) && !level.oldschool && level.disableclassselection != 1 && isdefined(player.killstreak))
	{
		currentkillstreak = 0;
		for(killstreaknum = 0; killstreaknum < level.maxkillstreaks; killstreaknum++)
		{
			if(isdefined(player.killstreak[killstreaknum]))
			{
				killstreak[currentkillstreak] = player.killstreak[killstreaknum];
				currentkillstreak++;
			}
		}
	}
	return killstreak;
}

/*
	Name: updaterankedmatch
	Namespace: globallogic
	Checksum: 0x43D67CDF
	Offset: 0xAB28
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function updaterankedmatch(winner)
{
	if(level.rankedmatch)
	{
		if(hostidledout())
		{
			level.hostforcedend = 1;
			/#
				print("");
			#/
			endlobby();
		}
	}
	if(!level.wagermatch && !sessionmodeiszombiesgame() && (!(isdefined(level.deadops) && level.deadops)))
	{
		globallogic_score::updatematchbonusscores(winner);
	}
}

