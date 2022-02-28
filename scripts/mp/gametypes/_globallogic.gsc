// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_arena;
#using scripts\mp\_behavior_tracker;
#using scripts\mp\_challenges;
#using scripts\mp\_gameadvertisement;
#using scripts\mp\_gamerep;
#using scripts\mp\_rat;
#using scripts\mp\_teamops;
#using scripts\mp\_util;
#using scripts\mp\bots\_bot;
#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_clientids;
#using scripts\mp\gametypes\_deathicons;
#using scripts\mp\gametypes\_dev;
#using scripts\mp\gametypes\_dogtags;
#using scripts\mp\gametypes\_friendicons;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_player;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_spawn;
#using scripts\mp\gametypes\_globallogic_ui;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_healthoverlay;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_killcam;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\gametypes\_menus;
#using scripts\mp\gametypes\_scoreboard;
#using scripts\mp\gametypes\_serversettings;
#using scripts\mp\gametypes\_shellshock;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\gametypes\_spectating;
#using scripts\mp\gametypes\_weapon_utils;
#using scripts\mp\gametypes\_weapons;
#using scripts\mp\killstreaks\_dogs;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\teams\_teams;
#using scripts\shared\bb_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\music_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\simple_hostmigration;
#using scripts\shared\system_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_hive_gun;
#using scripts\shared\weapons\_weapon_utils;
#using scripts\shared\weapons\_weapons;

#namespace globallogic;

/*
	Name: __init__sytem__
	Namespace: globallogic
	Checksum: 0xB0DF9F3
	Offset: 0x22F0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("globallogic", &__init__, undefined, "visionset_mgr");
}

/*
	Name: __init__
	Namespace: globallogic
	Checksum: 0xB35DFC5E
	Offset: 0x2330
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!isdefined(level.vsmgr_prio_visionset_mpintro))
	{
		level.vsmgr_prio_visionset_mpintro = 5;
	}
	visionset_mgr::register_info("visionset", "mpintro", 1, level.vsmgr_prio_visionset_mpintro, 31, 0, &visionset_mgr::ramp_in_out_thread, 0);
	level.host_migration_activate_visionset_func = &mpintro_visionset_activate_func;
	level.host_migration_deactivate_visionset_func = &mpintro_visionset_deactivate_func;
}

/*
	Name: init
	Namespace: globallogic
	Checksum: 0x334C45BD
	Offset: 0x23C8
	Size: 0xA9C
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
	level.custommatch = gamemodeismode(1);
	level.arenamatch = gamemodeisarena();
	level.mpcustommatch = level.custommatch;
	level.contractsenabled = !getgametypesetting("disableContracts");
	level.contractsenabled = 0;
	level.disablevehicleburndamage = 1;
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
	level.teams = [];
	level.teamindex = [];
	teamcount = level.teamcount;
	if(level.teamcount == 1)
	{
		teamcount = 18;
		level.teams["free"] = "free";
	}
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
	level.clampscorelimit = 1;
	level.endgameonscorelimit = 1;
	level.endgameontimelimit = 1;
	level.scoreroundwinbased = 0;
	level.resetplayerscoreeveryround = 0;
	level.doendgamescoreboard = 1;
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
	level.defaultoffenseradius = 560;
	level.defaultoffenseradiussq = level.defaultoffenseradius * level.defaultoffenseradius;
	level.dropteam = getdvarint("sv_maxclients");
	level.infinalkillcam = 0;
	globallogic_ui::init();
	registerdvars();
	loadout::initperkdvars();
	level.oldschool = getgametypesetting("oldschoolMode");
	precache_mp_leaderboards();
	if(!isdefined(game["tiebreaker"]))
	{
		game["tiebreaker"] = 0;
	}
	thread gameadvertisement::init();
	thread gamerep::init();
	thread teamops::init();
	level.disablechallenges = 0;
	if(level.leaguematch || getdvarint("scr_disableChallenges") > 0)
	{
		level.disablechallenges = 1;
	}
	level.disablestattracking = getdvarint("scr_disableStatTracking") > 0;
	setup_callbacks();
	clientfield::register("playercorpse", "firefly_effect", 1, 2, "int");
	clientfield::register("playercorpse", "annihilate_effect", 1, 1, "int");
	clientfield::register("playercorpse", "pineapplegun_effect", 1, 1, "int");
	clientfield::register("actor", "annihilate_effect", 1, 1, "int");
	clientfield::register("actor", "pineapplegun_effect", 1, 1, "int");
	clientfield::register("world", "game_ended", 1, 1, "int");
	clientfield::register("world", "post_game", 1, 1, "int");
	clientfield::register("world", "displayTop3Players", 1, 1, "int");
	clientfield::register("world", "triggerScoreboardCamera", 1, 1, "int");
	clientfield::register("clientuimodel", "hudItems.hideOutcomeUI", 1, 1, "int");
	clientfield::register("clientuimodel", "hudItems.remoteKillstreakActivated", 1, 1, "int");
	clientfield::register("world", "playTop0Gesture", 1000, 3, "int");
	clientfield::register("world", "playTop1Gesture", 1000, 3, "int");
	clientfield::register("world", "playTop2Gesture", 1000, 3, "int");
	clientfield::register("clientuimodel", "hudItems.captureCrateState", 5000, 2, "int");
	clientfield::register("clientuimodel", "hudItems.captureCrateTotalTime", 5000, 13, "int");
	level.playersdrivingvehiclesbecomeinvulnerable = 0;
	level.figure_out_attacker = &globallogic_player::figure_out_attacker;
	level.figure_out_friendly_fire = &globallogic_player::figure_out_friendly_fire;
	level.get_base_weapon_param = &weapon_utils::getbaseweaponparam;
	level thread function_aa9e547b();
}

/*
	Name: registerdvars
	Namespace: globallogic
	Checksum: 0x3025EA1D
	Offset: 0x2E70
	Size: 0x25C
	Parameters: 0
	Flags: Linked
*/
function registerdvars()
{
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
	Checksum: 0x92BF1FF4
	Offset: 0x30D8
	Size: 0x54
	Parameters: 10
	Flags: Linked
*/
function blank(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
{
}

/*
	Name: setup_callbacks
	Namespace: globallogic
	Checksum: 0xBEE5D4CF
	Offset: 0x3138
	Size: 0x4AC
	Parameters: 0
	Flags: Linked
*/
function setup_callbacks()
{
	level.spawnplayer = &globallogic_spawn::spawnplayer;
	level.spawnplayerprediction = &globallogic_spawn::spawnplayerprediction;
	level.spawnclient = &globallogic_spawn::spawnclient;
	level.spawnspectator = &globallogic_spawn::spawnspectator;
	level.spawnintermission = &globallogic_spawn::spawnintermission;
	level.scoreongiveplayerscore = &globallogic_score::giveplayerscore;
	level.onplayerscore = &globallogic_score::default_onplayerscore;
	level.onteamscore = &globallogic_score::default_onteamscore;
	level.wavespawntimer = &wavespawntimer;
	level.spawnmessage = &globallogic_spawn::default_spawnmessage;
	level.onspawnplayer = &blank;
	level.onspawnplayer = &spawning::onspawnplayer;
	level.onspawnspectator = &globallogic_defaults::default_onspawnspectator;
	level.onspawnintermission = &globallogic_defaults::default_onspawnintermission;
	level.onrespawndelay = &blank;
	level.onforfeit = &globallogic_defaults::default_onforfeit;
	level.ontimelimit = &globallogic_defaults::default_ontimelimit;
	level.onscorelimit = &globallogic_defaults::default_onscorelimit;
	level.onroundscorelimit = &globallogic_defaults::default_onroundscorelimit;
	level.onalivecountchange = &globallogic_defaults::default_onalivecountchange;
	level.ondeadevent = undefined;
	level.ononeleftevent = &globallogic_defaults::default_ononeleftevent;
	level.giveteamscore = &globallogic_score::giveteamscore;
	level.onlastteamaliveevent = &globallogic_defaults::default_onlastteamaliveevent;
	level.gettimepassed = &globallogic_utils::gettimepassed;
	level.gettimelimit = &globallogic_defaults::default_gettimelimit;
	level.getteamkillpenalty = &globallogic_defaults::default_getteamkillpenalty;
	level.getteamkillscore = &globallogic_defaults::default_getteamkillscore;
	level.iskillboosting = &globallogic_score::default_iskillboosting;
	level._setteamscore = &globallogic_score::_setteamscore;
	level._setplayerscore = &globallogic_score::_setplayerscore;
	level._getteamscore = &globallogic_score::_getteamscore;
	level._getplayerscore = &globallogic_score::_getplayerscore;
	level.resetplayerscorestreaks = &globallogic_score::resetplayerscorechainandmomentum;
	level.onprecachegametype = &blank;
	level.onstartgametype = &blank;
	level.onplayerconnect = &blank;
	level.onplayerdisconnect = &blank;
	level.onplayerdamage = &blank;
	level.onplayerkilled = &blank;
	level.onplayerkilledextraunthreadedcbs = [];
	level.onteamoutcomenotify = &hud_message::teamoutcomenotify;
	level.onoutcomenotify = &hud_message::outcomenotify;
	level.setmatchscorehudelemforteam = &hud_message::setmatchscorehudelemforteam;
	level.onendgame = &blank;
	level.onroundendgame = &globallogic_defaults::default_onroundendgame;
	level.determinewinner = &globallogic_defaults::default_determinewinner;
	level.onmedalawarded = &blank;
	level.dogmanagerongetdogs = &dogs::dog_manager_get_dogs;
	callback::on_joined_team(&globallogic_player::on_joined_team);
	globallogic_ui::setupcallbacks();
}

/*
	Name: precache_mp_friend_leaderboards
	Namespace: globallogic
	Checksum: 0x59196FAD
	Offset: 0x35F0
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function precache_mp_friend_leaderboards()
{
	hardcoremode = getgametypesetting("hardcoreMode");
	if(!isdefined(hardcoremode))
	{
		hardcoremode = 0;
	}
	arenamode = isarenamode();
	postfix = "";
	if(hardcoremode)
	{
		postfix = "_HC";
	}
	else if(arenamode)
	{
		postfix = "_ARENA";
	}
	friendleaderboarda = "LB_MP_FRIEND_A" + postfix;
	friendleaderboardb = " LB_MP_FRIEND_B" + postfix;
	precacheleaderboards(friendleaderboarda + friendleaderboardb);
}

/*
	Name: precache_mp_anticheat_leaderboards
	Namespace: globallogic
	Checksum: 0xA9531BBC
	Offset: 0x36E8
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function precache_mp_anticheat_leaderboards()
{
	hardcoremode = getgametypesetting("hardcoreMode");
	if(!isdefined(hardcoremode))
	{
		hardcoremode = 0;
	}
	arenamode = isarenamode();
	postfix = "";
	if(hardcoremode)
	{
		postfix = "_HC";
	}
	else if(arenamode)
	{
		postfix = "_ARENA";
	}
	anticheatleaderboard = ("LB_MP_ANTICHEAT_" + level.gametype) + postfix;
	if(level.gametype != "fr")
	{
		anticheatleaderboard = anticheatleaderboard + " LB_MP_ANTICHEAT_GLOBAL";
	}
	precacheleaderboards(anticheatleaderboard);
}

/*
	Name: precache_mp_public_leaderboards
	Namespace: globallogic
	Checksum: 0xCD948524
	Offset: 0x37F0
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function precache_mp_public_leaderboards()
{
	mapname = getdvarstring("mapname");
	hardcoremode = getgametypesetting("hardcoreMode");
	if(!isdefined(hardcoremode))
	{
		hardcoremode = 0;
	}
	arenamode = isarenamode();
	freerunmode = level.gametype == "fr";
	postfix = "";
	if(freerunmode)
	{
		frleaderboard = " LB_MP_GM_FR_" + getsubstr(mapname, 3, mapname.size);
		precacheleaderboards(frleaderboard);
		return;
	}
	if(hardcoremode)
	{
		postfix = "_HC";
	}
	else if(arenamode)
	{
		postfix = "_ARENA";
	}
	careerleaderboard = " LB_MP_GB_SCORE" + postfix;
	prestigelb = " LB_MP_GB_XPPRESTIGE";
	gamemodeleaderboard = ("LB_MP_GM_" + level.gametype) + postfix;
	arenaleaderboard = "";
	if(gamemodeismode(6))
	{
		arenaslot = arenagetslot();
		arenaleaderboard = " LB_MP_ARENA_MASTERS_0" + arenaslot;
	}
	precacheleaderboards(((gamemodeleaderboard + careerleaderboard) + prestigelb) + arenaleaderboard);
}

/*
	Name: precache_mp_custom_leaderboards
	Namespace: globallogic
	Checksum: 0x618BCE28
	Offset: 0x3A18
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function precache_mp_custom_leaderboards()
{
	customleaderboards = "LB_MP_CG_" + level.gametype;
	precacheleaderboards("LB_MP_CG_GENERAL " + customleaderboards);
}

/*
	Name: precache_mp_leaderboards
	Namespace: globallogic
	Checksum: 0xB3C645E4
	Offset: 0x3A68
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function precache_mp_leaderboards()
{
	if(bot::is_bot_ranked_match())
	{
		return;
	}
	if(level.rankedmatch || level.gametype == "fr")
	{
		precache_mp_public_leaderboards();
		precache_mp_friend_leaderboards();
		precache_mp_anticheat_leaderboards();
	}
	else
	{
		precache_mp_custom_leaderboards();
	}
}

/*
	Name: setvisiblescoreboardcolumns
	Namespace: globallogic
	Checksum: 0xC403DAF6
	Offset: 0x3AF8
	Size: 0xA4
	Parameters: 5
	Flags: Linked
*/
function setvisiblescoreboardcolumns(col1, col2, col3, col4, col5)
{
	if(!level.rankedmatch)
	{
		setscoreboardcolumns(col1, col2, col3, col4, col5, "sbtimeplayed", "shotshit", "shotsmissed", "victory");
	}
	else
	{
		setscoreboardcolumns(col1, col2, col3, col4, col5);
	}
}

/*
	Name: compareteambygamestat
	Namespace: globallogic
	Checksum: 0xADD59906
	Offset: 0x3BA8
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
	Checksum: 0x4B0F4639
	Offset: 0x3C98
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
	Checksum: 0x297548A2
	Offset: 0x3D88
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
	Checksum: 0x88972E16
	Offset: 0x3E80
	Size: 0xDE
	Parameters: 0
	Flags: Linked
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
	Checksum: 0xD1133DDA
	Offset: 0x3F68
	Size: 0x1B4
	Parameters: 1
	Flags: Linked
*/
function forceend(hostsucks = 0)
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
	Checksum: 0x906CF0A5
	Offset: 0x4128
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
	Checksum: 0x3034A4BE
	Offset: 0x4280
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
	Checksum: 0x2A3645C2
	Offset: 0x4340
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
	Checksum: 0xD04284A3
	Offset: 0x43A8
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
	Checksum: 0x542E5DFE
	Offset: 0x44D8
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
	Checksum: 0x90146AD0
	Offset: 0x4580
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
	Checksum: 0x81FD8CBC
	Offset: 0x45C8
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
	Checksum: 0xDE32C80E
	Offset: 0x4668
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
	Checksum: 0xCD8DCF98
	Offset: 0x4778
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
	Checksum: 0x4A3D425C
	Offset: 0x4928
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
	Checksum: 0x87846D75
	Offset: 0x4980
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
	Name: updategameevents
	Namespace: globallogic
	Checksum: 0x15D9B1E1
	Offset: 0x4AA8
	Size: 0x1F0
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
		if(level.teambased && !util::function_938b1b6b())
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
}

/*
	Name: mpintro_visionset_ramp_hold_func
	Namespace: globallogic
	Checksum: 0x86FBAE57
	Offset: 0x4CA0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function mpintro_visionset_ramp_hold_func()
{
	level endon(#"mpintro_ramp_out_notify");
	while(true)
	{
		for(player_index = 0; player_index < level.players.size; player_index++)
		{
			self visionset_mgr::set_state_active(level.players[player_index], 1);
		}
		wait(0.05);
	}
}

/*
	Name: mpintro_visionset_activate_func
	Namespace: globallogic
	Checksum: 0x7D7B9DC2
	Offset: 0x4D20
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function mpintro_visionset_activate_func()
{
	visionset_mgr::activate("visionset", "mpintro", undefined, 0, &mpintro_visionset_ramp_hold_func, 2);
}

/*
	Name: mpintro_visionset_deactivate_func
	Namespace: globallogic
	Checksum: 0x8F4B4B09
	Offset: 0x4D68
	Size: 0x12
	Parameters: 0
	Flags: Linked
*/
function mpintro_visionset_deactivate_func()
{
	level notify(#"mpintro_ramp_out_notify");
}

/*
	Name: matchstarttimer
	Namespace: globallogic
	Checksum: 0x330F70B0
	Offset: 0x4D88
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function matchstarttimer()
{
	mpintro_visionset_activate_func();
	level thread sndsetmatchsnapshot(1);
	waitforplayers();
	counttime = int(level.prematchperiod);
	if(counttime >= 2)
	{
		while(counttime > 0 && !level.gameended)
		{
			luinotifyevent(&"create_prematch_timer", 1, gettime() + (counttime * 1000));
			if(counttime == 2)
			{
				mpintro_visionset_deactivate_func();
			}
			if(counttime == 3)
			{
				level thread sndsetmatchsnapshot(0);
				foreach(player in level.players)
				{
					if(player.hasspawned || player.pers["team"] == "spectator")
					{
						player globallogic_audio::set_music_on_player("spawnPreRise");
					}
				}
			}
			counttime--;
			foreach(player in level.players)
			{
				player playlocalsound("uin_start_count_down");
			}
			wait(1);
		}
		luinotifyevent(&"prematch_timer_ended", 0);
	}
	else
	{
		mpintro_visionset_deactivate_func();
	}
}

/*
	Name: notifyendofgameplay
	Namespace: globallogic
	Checksum: 0x457FB134
	Offset: 0x5018
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function notifyendofgameplay()
{
	level waittill(#"game_ended");
	level clientfield::set("gameplay_started", 0);
}

/*
	Name: matchstarttimerskip
	Namespace: globallogic
	Checksum: 0x28C1B003
	Offset: 0x5050
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function matchstarttimerskip()
{
	visionsetnaked(getdvarstring("mapname"), 0);
}

/*
	Name: sndsetmatchsnapshot
	Namespace: globallogic
	Checksum: 0x5041B301
	Offset: 0x5090
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function sndsetmatchsnapshot(num)
{
	wait(0.05);
	level clientfield::set("sndMatchSnapshot", num);
}

/*
	Name: notifyteamwavespawn
	Namespace: globallogic
	Checksum: 0xD0222098
	Offset: 0x50D0
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
	Checksum: 0xA6EA260F
	Offset: 0x5150
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
	Checksum: 0x872C289C
	Offset: 0x5228
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
	Checksum: 0xA1ECE36
	Offset: 0x52D8
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
	Checksum: 0x55F1B442
	Offset: 0x5338
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
	Checksum: 0x5A5994EA
	Offset: 0x5398
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
	Checksum: 0x1DE130E5
	Offset: 0x5510
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
	Checksum: 0x8A4A171
	Offset: 0x55A8
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
	Name: recordplaystyleinformation
	Namespace: globallogic
	Checksum: 0xAABEC00D
	Offset: 0x5668
	Size: 0x3B4
	Parameters: 0
	Flags: Linked
*/
function recordplaystyleinformation()
{
	avgkilldistance = 0;
	percenttimemoving = 0;
	avgspeedofplayerwhenmoving = 0;
	totalkilldistances = float(self.pers["kill_distances"]);
	numkilldistanceentries = float(self.pers["num_kill_distance_entries"]);
	timeplayedmoving = float(self.pers["time_played_moving"]);
	timeplayedalive = float(self.pers["time_played_alive"]);
	totalspeedswhenmoving = float(self.pers["total_speeds_when_moving"]);
	numspeedswhenmovingentries = float(self.pers["num_speeds_when_moving_entries"]);
	totaldistancetravelled = float(self.pers["total_distance_travelled"]);
	movementupdatecount = float(self.pers["movement_Update_Count"]);
	if(numkilldistanceentries > 0)
	{
		avgkilldistance = totalkilldistances / numkilldistanceentries;
	}
	movementupdatedenom = int(movementupdatecount / 5);
	if(movementupdatedenom > 0)
	{
		percenttimemoving = (numspeedswhenmovingentries / movementupdatedenom) * 100;
	}
	if(numspeedswhenmovingentries > 0)
	{
		avgspeedofplayerwhenmoving = totalspeedswhenmoving / numspeedswhenmovingentries;
	}
	recordplayerstats(self, "totalKillDistances", totalkilldistances);
	recordplayerstats(self, "numKillDistanceEntries", numkilldistanceentries);
	recordplayerstats(self, "timePlayedMoving", timeplayedmoving);
	recordplayerstats(self, "timePlayedAlive", timeplayedalive);
	recordplayerstats(self, "totalSpeedsWhenMoving", totalspeedswhenmoving);
	recordplayerstats(self, "numSpeedsWhenMovingEntries", numspeedswhenmovingentries);
	recordplayerstats(self, "averageKillDistance", avgkilldistance);
	recordplayerstats(self, "percentageOfTimeMoving", percenttimemoving);
	recordplayerstats(self, "averageSpeedDuringMatch", avgspeedofplayerwhenmoving);
	recordplayerstats(self, "totalDistanceTravelled", totaldistancetravelled);
	bbprint("mpplaystyles", "averageKillDistance %f percentageOfTimeMoving %f averageSpeedDuringMatch %f", avgkilldistance, percenttimemoving, avgspeedofplayerwhenmoving);
}

/*
	Name: getplayerbyname
	Namespace: globallogic
	Checksum: 0x2BDC4765
	Offset: 0x5A28
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function getplayerbyname(name)
{
	for(index = 0; index < level.players.size; index++)
	{
		player = level.players[index];
		if(player util::is_bot())
		{
			continue;
		}
		if(player.name == name)
		{
			return player;
		}
	}
}

/*
	Name: sendafteractionreport
	Namespace: globallogic
	Checksum: 0xC2846391
	Offset: 0x5AC0
	Size: 0x746
	Parameters: 0
	Flags: Linked
*/
function sendafteractionreport()
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
		if(player util::is_bot())
		{
			continue;
		}
		nemesis = player.pers["nemesis_name"];
		if(!isdefined(player.pers["killed_players"][nemesis]))
		{
			player.pers["killed_players"][nemesis] = 0;
		}
		if(!isdefined(player.pers["killed_by"][nemesis]))
		{
			player.pers["killed_by"][nemesis] = 0;
		}
		spread = player.kills - player.deaths;
		if(player.pers["cur_kill_streak"] > player.pers["best_kill_streak"])
		{
			player.pers["best_kill_streak"] = player.pers["cur_kill_streak"];
		}
		if(level.rankedmatch || level.leaguematch)
		{
			player persistence::set_after_action_report_stat("privateMatch", 0);
		}
		else
		{
			player persistence::set_after_action_report_stat("privateMatch", 1);
		}
		player setnemesisxuid(player.pers["nemesis_xuid"]);
		player persistence::set_after_action_report_stat("nemesisName", nemesis);
		player persistence::set_after_action_report_stat("nemesisRank", player.pers["nemesis_rank"]);
		player persistence::set_after_action_report_stat("nemesisRankIcon", player.pers["nemesis_rankIcon"]);
		player persistence::set_after_action_report_stat("nemesisKills", player.pers["killed_players"][nemesis]);
		player persistence::set_after_action_report_stat("nemesisKilledBy", player.pers["killed_by"][nemesis]);
		nemesisplayerent = getplayerbyname(nemesis);
		if(isdefined(nemesisplayerent))
		{
			player persistence::set_after_action_report_stat("nemesisHeroIndex", nemesisplayerent getcharacterbodytype());
		}
		player persistence::set_after_action_report_stat("bestKillstreak", player.pers["best_kill_streak"]);
		player persistence::set_after_action_report_stat("kills", player.kills);
		player persistence::set_after_action_report_stat("deaths", player.deaths);
		player persistence::set_after_action_report_stat("headshots", player.headshots);
		player persistence::set_after_action_report_stat("score", player.score);
		player persistence::set_after_action_report_stat("xpEarned", int(player.pers["summary"]["xp"]));
		player persistence::set_after_action_report_stat("cpEarned", int(player.pers["summary"]["codpoints"]));
		player persistence::set_after_action_report_stat("miscBonus", int(player.pers["summary"]["challenge"] + player.pers["summary"]["misc"]));
		player persistence::set_after_action_report_stat("matchBonus", int(player.pers["summary"]["match"]));
		player persistence::set_after_action_report_stat("demoFileID", getdemofileid());
		player persistence::set_after_action_report_stat("leagueTeamID", player getleagueteamid());
		player persistence::set_after_action_report_stat("team", teams::getteamindex(player.team));
		alliesscore = globallogic_score::_getteamscore("allies");
		if(isdefined(alliesscore))
		{
			player persistence::set_after_action_report_stat("alliesScore", alliesscore);
		}
		axisscore = globallogic_score::_getteamscore("axis");
		if(isdefined(axisscore))
		{
			player persistence::set_after_action_report_stat("axisScore", axisscore);
		}
		player persistence::set_after_action_report_stat("gameTypeRef", level.gametype);
		player persistence::set_after_action_report_stat("mapname", getdvarstring("ui_mapname"));
	}
}

/*
	Name: updateandfinalizematchrecord
	Namespace: globallogic
	Checksum: 0xFA95EBB0
	Offset: 0x6210
	Size: 0x534
	Parameters: 0
	Flags: Linked
*/
function updateandfinalizematchrecord()
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
		player globallogic_player::record_special_move_data_for_life(undefined);
		if(player util::is_bot())
		{
			continue;
		}
		player globallogic_player::record_global_mp_stats_for_player_at_match_end();
		nemesis = player.pers["nemesis_name"];
		if(!isdefined(player.pers["killed_players"][nemesis]))
		{
			player.pers["killed_players"][nemesis] = 0;
		}
		if(!isdefined(player.pers["killed_by"][nemesis]))
		{
			player.pers["killed_by"][nemesis] = 0;
		}
		spread = player.kills - player.deaths;
		if(player.pers["cur_kill_streak"] > player.pers["best_kill_streak"])
		{
			player.pers["best_kill_streak"] = player.pers["cur_kill_streak"];
		}
		if(level.onlinegame)
		{
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
			recordplayerstats(player, "highestKillStreak", player.pers["best_kill_streak"]);
			recordplayerstats(player, "numUavCalled", player killstreaks::get_killstreak_usage("uav_used"));
			recordplayerstats(player, "numDogsCalleD", player killstreaks::get_killstreak_usage("dogs_used"));
			recordplayerstats(player, "numDogsKills", player.pers["dog_kills"]);
			player recordplaystyleinformation();
			recordplayermatchend(player);
			recordplayerstats(player, "presentAtEnd", 1);
		}
	}
	finalizematchrecord();
}

/*
	Name: gamehistoryplayerkicked
	Namespace: globallogic
	Checksum: 0xEB4735DC
	Offset: 0x6750
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
	Checksum: 0x5F1E75DC
	Offset: 0x6928
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
	Checksum: 0xB6A8C722
	Offset: 0x6AC8
	Size: 0x2BC
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
			if(level.teambased)
			{
				player thread [[level.onteamoutcomenotify]](winner, "roundend", endreasontext);
				player globallogic_audio::set_music_on_player("roundEnd");
			}
			else
			{
				player thread [[level.onoutcomenotify]](winner, 1, endreasontext);
				player globallogic_audio::set_music_on_player("roundEnd");
			}
			player setclientuivisibilityflag("hud_visible", 0);
			player setclientuivisibilityflag("g_compassShowEnemies", 0);
		}
	}
	if(util::waslastround())
	{
		roundendwait(level.roundenddelay, 0);
	}
	else
	{
		thread globallogic_audio::announce_round_winner(winner, level.roundenddelay / 4);
		roundendwait(level.roundenddelay, 1);
	}
}

/*
	Name: displayroundswitch
	Namespace: globallogic
	Checksum: 0xC2BC3293
	Offset: 0x6D90
	Size: 0x284
	Parameters: 2
	Flags: Linked
*/
function displayroundswitch(winner, endreasontext)
{
	switchtype = level.halftimetype;
	level thread globallogic_audio::set_music_global("roundSwitch");
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
					if(isdefined(level.roundswitch) && level.roundswitch == 1)
					{
						switchtype = "intermission";
					}
					else
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
				}
				else
				{
					switchtype = "intermission";
				}
			}
		}
	}
	leaderdialog = globallogic_audio::get_round_switch_dialog(switchtype);
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
		player globallogic_audio::leader_dialog_on_player(leaderdialog);
		player thread [[level.onteamoutcomenotify]](winner, switchtype, level.halftimesubcaption);
		player setclientuivisibilityflag("hud_visible", 0);
	}
	roundendwait(level.halftimeroundenddelay, 0);
}

/*
	Name: displaygameend
	Namespace: globallogic
	Checksum: 0x232B9EE3
	Offset: 0x7020
	Size: 0x544
	Parameters: 2
	Flags: Linked
*/
function displaygameend(winner, endreasontext)
{
	setmatchtalkflag("EveryoneHearsEveryone", 1);
	setmatchflag("cg_drawSpectatorMessages", 0);
	level thread sndsetmatchsnapshot(2);
	util::setclientsysstate("levelNotify", "streamFKsl");
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
			player thread [[level.onteamoutcomenotify]](winner, "gameend", endreasontext);
		}
		else
		{
			if(!(isdefined(level.freerun) && level.freerun))
			{
				player thread [[level.onoutcomenotify]](winner, 0, endreasontext);
			}
			if(isdefined(level.freerun) && level.freerun)
			{
				player globallogic_audio::set_music_on_player("mp_freerun_gameover");
			}
			else
			{
				if(isdefined(winner) && player == winner)
				{
					player globallogic_audio::set_music_on_player("matchWin");
				}
				else if(!level.splitscreen)
				{
					player globallogic_audio::set_music_on_player("matchLose");
				}
			}
		}
		player setclientuivisibilityflag("hud_visible", 0);
		player setclientuivisibilityflag("g_compassShowEnemies", 0);
	}
	thread globallogic_audio::announce_game_winner(winner);
	if(level.teambased)
	{
		players = level.players;
		for(index = 0; index < players.size; index++)
		{
			player = players[index];
			team = player.pers["team"];
			if(level.splitscreen)
			{
				if(isdefined(level.freerun) && level.freerun)
				{
					player globallogic_audio::set_music_on_player("mp_freerun_gameover");
				}
				else
				{
					if(winner == "tie")
					{
						player globallogic_audio::set_music_on_player("matchDraw");
					}
					else
					{
						if(winner == team)
						{
							player globallogic_audio::set_music_on_player("matchWin");
						}
						else
						{
							player globallogic_audio::set_music_on_player("matchLose");
						}
					}
				}
				continue;
			}
			if(isdefined(level.freerun) && level.freerun)
			{
				player globallogic_audio::set_music_on_player("mp_freerun_gameover");
				continue;
			}
			if(winner == "tie")
			{
				player globallogic_audio::set_music_on_player("matchDraw");
				continue;
			}
			if(winner == team)
			{
				player globallogic_audio::set_music_on_player("matchWin");
				continue;
			}
			player globallogic_audio::set_music_on_player("matchLose");
		}
	}
	bbprint("global_session_epilogs", "reason %s", endreasontext);
	bbprint("mpmatchfacts", "gametime %d winner %s killstreakcount %d", gettime(), winner, level.globalkillstreakscalled);
	roundendwait(level.postroundtime, 1);
}

/*
	Name: recordendgamecomscoreevent
	Namespace: globallogic
	Checksum: 0x16991BDB
	Offset: 0x7570
	Size: 0x6E
	Parameters: 1
	Flags: Linked
*/
function recordendgamecomscoreevent(result)
{
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		globallogic_player::recordendgamecomscoreeventforplayer(players[index], result);
	}
}

/*
	Name: getendreasontext
	Namespace: globallogic
	Checksum: 0x6839BC9C
	Offset: 0x75E8
	Size: 0x100
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
	if(util::hitroundscorelimit())
	{
		return game["strings"]["round_score_limit_reached"];
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
	Checksum: 0x648E9B4D
	Offset: 0x76F0
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
	Name: hideoutcomeuiforallplayers
	Namespace: globallogic
	Checksum: 0x9D01C6AB
	Offset: 0x7768
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function hideoutcomeuiforallplayers()
{
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		player clientfield::set_player_uimodel("hudItems.hideOutcomeUI", 1);
	}
}

/*
	Name: startnextround
	Namespace: globallogic
	Checksum: 0x4E5BC175
	Offset: 0x77F0
	Size: 0x2DC
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
				if(level.scoreroundwinbased)
				{
					foreach(team in level.teams)
					{
						[[level._setteamscore]](team, game["roundswon"][team]);
					}
				}
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
			map_restart(1);
			hideoutcomeuiforallplayers();
			return true;
		}
	}
	return false;
}

/*
	Name: settopplayerstats
	Namespace: globallogic
	Checksum: 0xDB1329A8
	Offset: 0x7AD8
	Size: 0x33A
	Parameters: 0
	Flags: Linked
*/
function settopplayerstats()
{
	if(level.rankedmatch)
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
	Checksum: 0x5D824629
	Offset: 0x7E20
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
	Name: figureoutwinningteam
	Namespace: globallogic
	Checksum: 0x1C03C1D3
	Offset: 0x7FA0
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function figureoutwinningteam(winner)
{
	if(!isdefined(winner))
	{
		return "tie";
	}
	if(isentity(winner))
	{
		return (isdefined(winner.team) ? winner.team : "none");
	}
	return winner;
}

/*
	Name: getroundlength
	Namespace: globallogic
	Checksum: 0xDD10C0E
	Offset: 0x8010
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function getroundlength()
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
	Name: awardlootxp
	Namespace: globallogic
	Checksum: 0x366D563D
	Offset: 0x8098
	Size: 0x66C
	Parameters: 0
	Flags: Linked
*/
function awardlootxp()
{
	if(!getdvarint("loot_enabled"))
	{
		return;
	}
	maxplayablegametime = game["playabletimepassed"] / 1000;
	timeplayed = self gettotaltimeplayed(maxplayablegametime);
	lootxpawarded = 0;
	if(self.pers["participation"] >= 1)
	{
		lootxpperkey = int(getdvarint("loot_cryptokeyCost", 100));
		avggamelen = int(getdvarint("loot_earnTime", 267));
		minplaytime = int(getdvarint("loot_earnPlayThreshold", 10));
		maxlootxp = int(getdvarint("loot_earnMax", 10000));
		minlootxp = int(getdvarint("loot_earnMin", 0));
		winmultiplier = int(getdvarint("loot_winBonusPercent", 30));
		var_9f63537b = -1;
		if(int(getdvarstring("bonus_crypto_earn_rate_enabled", "0")) == 1)
		{
			var_9f63537b = self experimentsgetvariant("jul_2017_small");
			if(var_9f63537b == 1 || var_9f63537b == 2)
			{
				avggamelen = int(getdvarstring("bonus_crypto_earn_rate", "184"));
			}
		}
		if(maxplayablegametime > 0 && timeplayed > minplaytime)
		{
			if(level.arenamatch)
			{
				draftenabled = getgametypesetting("pregameDraftEnabled") == 1;
				voteenabled = getgametypesetting("pregameItemVoteEnabled") == 1;
				if(draftenabled && voteenabled)
				{
					arenamin = getdvarint("arena_minPregameCryptoSeconds", 0);
					arenamax = getdvarint("arena_maxPregameCryptoSeconds", 0);
					if(arenamax > 0 && arenamin >= 0 && arenamin <= arenamax)
					{
						bonustime = randomintrange(arenamin, arenamax);
						timeplayed = timeplayed + bonustime;
					}
				}
			}
			lootxpscale = timeplayed / avggamelen;
			lootxpawarded = lootxpperkey * lootxpscale;
			var_fc7d444b = lootxpawarded;
			if(isdefined(self.lootxpmultiplier) && self.lootxpmultiplier == 1)
			{
				lootxpawarded = lootxpawarded + (lootxpawarded * (winmultiplier / 100));
			}
			lootxpawarded = lootxpawarded * math::clamp(self getcryptoscale(), 0, 4);
			lootxpawarded = int(lootxpawarded);
			if(lootxpawarded > maxlootxp)
			{
				lootxpawarded = maxlootxp;
			}
			else if(lootxpawarded < minlootxp)
			{
				lootxpawarded = minlootxp;
			}
			otherlootxpawarded = self awardotherlootxp();
			lootxpawarded = lootxpawarded + otherlootxpawarded;
			if(getdvarint("enable_bonus_earn_rate_tracking", 1))
			{
				xuid = self getxuid(1);
				recordcomscoreevent("bonus_crypto_earn_rate", "xuid", xuid, "game_len", avggamelen, "exp_group", var_9f63537b, "raw_loot_xp", var_fc7d444b, "final_loot_xp", lootxpawarded);
			}
			if(lootxpawarded > 0)
			{
				self reportlootreward(1, lootxpawarded);
			}
			if(otherlootxpawarded > 0)
			{
				level thread waitanduploadstats(self, getdvarfloat("src_other_lootxp_uploadstat_waittime", 1));
			}
		}
	}
	self setaarstat("lootXpEarned", lootxpawarded);
	recordplayerstats(self, "lootXpEarned", lootxpawarded);
	recordplayerstats(self, "lootTimePlayed", timeplayed);
}

/*
	Name: waitanduploadstats
	Namespace: globallogic
	Checksum: 0xA493B83E
	Offset: 0x8710
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function waitanduploadstats(player, waittime)
{
	wait(waittime);
	if(isplayer(player))
	{
		uploadstats(player);
	}
}

/*
	Name: registerotherlootxpawards
	Namespace: globallogic
	Checksum: 0x3895DA15
	Offset: 0x8768
	Size: 0x92
	Parameters: 1
	Flags: None
*/
function registerotherlootxpawards(func)
{
	if(!isdefined(level.awardotherlootxpfunctions))
	{
		level.awardotherlootxpfunctions = [];
	}
	if(!isdefined(level.awardotherlootxpfunctions))
	{
		level.awardotherlootxpfunctions = [];
	}
	else if(!isarray(level.awardotherlootxpfunctions))
	{
		level.awardotherlootxpfunctions = array(level.awardotherlootxpfunctions);
	}
	level.awardotherlootxpfunctions[level.awardotherlootxpfunctions.size] = func;
}

/*
	Name: awardotherlootxp
	Namespace: globallogic
	Checksum: 0xD6FBE874
	Offset: 0x8808
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function awardotherlootxp()
{
	player = self;
	if(!isdefined(level.awardotherlootxpfunctions))
	{
		return 0;
	}
	if(!isplayer(player))
	{
		return 0;
	}
	lootxp = 0;
	foreach(func in level.awardotherlootxpfunctions)
	{
		if(!isdefined(func))
		{
			continue;
		}
		lootxp = lootxp + player [[func]]();
	}
	return lootxp;
}

/*
	Name: endgame
	Namespace: globallogic
	Checksum: 0xD8787D26
	Offset: 0x8900
	Size: 0xCB4
	Parameters: 2
	Flags: Linked
*/
function endgame(winner, endreasontext)
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
	level clientfield::set("game_ended", 1);
	globallogic_audio::flush_dialog();
	foreach(team in level.teams)
	{
		game["lastroundscore"][team] = getteamscore(team);
	}
	if(util::isroundbased())
	{
		matchrecordroundend();
	}
	winning_team = figureoutwinningteam(winner);
	if(isdefined(game["overtime_round"]) && isdefined(game["overtimeroundswon"][winning_team]))
	{
		game["overtimeroundswon"][winning_team]++;
	}
	if(!isdefined(game["overtime_round"]) || util::waslastround())
	{
		game["roundsplayed"]++;
		game["roundwinner"][game["roundsplayed"]] = winner;
		if(isdefined(game["roundswon"][winning_team]))
		{
			game["roundswon"][winning_team]++;
		}
	}
	if(isdefined(winner) && isdefined(level.teams[winning_team]))
	{
		level.finalkillcam_winner = winner;
	}
	else
	{
		level.finalkillcam_winner = "none";
	}
	level.finalkillcam_winnerpicked = 1;
	setgameendtime(0);
	updateplacement();
	updaterankedmatch(winner);
	players = level.players;
	newtime = gettime();
	roundlength = getroundlength();
	setmatchtalkflag("EveryoneHearsEveryone", 1);
	bbgameover = 0;
	if(util::isoneround() || util::waslastround())
	{
		bbgameover = 1;
	}
	surveyid = 0;
	if(randomfloat(1) <= getdvarfloat("survey_chance"))
	{
		surveyid = randomintrange(1, getdvarint("survey_count") + 1);
	}
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		player globallogic_player::freezeplayerforroundend();
		player thread roundenddof(4);
		player globallogic_ui::freegameplayhudelems();
		player.pers["lastroundscore"] = player.pointstowin;
		player weapons::update_timings(newtime);
		if(bbgameover)
		{
			player behaviortracker::finalize();
		}
		player bbplayermatchend(roundlength, endreasontext, bbgameover);
		player.pers["totalTimePlayed"] = player.pers["totalTimePlayed"] + player.timeplayed["total"];
		if(bbgameover)
		{
			if(level.leaguematch)
			{
				player setaarstat("lobbyPopup", "leaguesummary");
			}
			else
			{
				player setaarstat("lobbyPopup", "summary");
			}
		}
		player setaarstat("surveyId", surveyid);
		player setaarstat("hardcore", level.hardcoremode);
	}
	gamerep::gamerepupdateinformationforround();
	thread challenges::roundend(winner);
	game_winner = winner;
	if(!util::isoneround())
	{
		game_winner = [[level.determinewinner]](winner);
	}
	update_top_scorers(game_winner);
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
	globallogic_score::updatewinlossstats(winner);
	if(level.rankedmatch || level.arenamatch)
	{
		thread awardlootxptoplayers(3, players);
	}
	if(level.arenamatch)
	{
		arena::match_end(winner);
	}
	result = "";
	if(level.teambased)
	{
		if(winner == "tie")
		{
			result = "draw";
		}
		else
		{
			result = winner;
		}
	}
	else
	{
		if(!isdefined(winner))
		{
			result = "draw";
		}
		else
		{
			result = winner.team;
		}
	}
	recordgameresult(result);
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		player globallogic_player::record_misc_player_stats();
	}
	skillupdate(winner, level.teambased);
	recordleaguewinner(winner);
	settopplayerstats();
	thread challenges::gameend(winner);
	updateandfinalizematchrecord();
	recordendgamecomscoreevent(result);
	if(getdvarint("ui_enablePromoTracking", 0) && (level.rankedmatch || level.arenamatch))
	{
		util::function_ad904acd();
	}
	if(getdvarint("ui_enable_community_challenge", 0) && (level.rankedmatch || level.arenamatch))
	{
		util::function_a4c90358(getdvarstring("community_challenge_counter_name"), 1);
		util::function_ad904acd();
	}
	level.finalgameend = 1;
	if(!isdefined(level.skipgameend) || !level.skipgameend)
	{
		displaygameend(winner, endreasontext);
	}
	level.finalgameend = undefined;
	if(util::isoneround())
	{
		globallogic_utils::executepostroundevents();
	}
	level.intermission = 1;
	gamerep::gamerepanalyzeandreport();
	util::setclientsysstate("levelNotify", "fkcs");
	if(persistence::can_set_aar_stat())
	{
		thread sendafteractionreport();
	}
	stopdemorecording();
	setmatchtalkflag("EveryoneHearsEveryone", 1);
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		player notify(#"reset_outcome", level.infinalkillcam);
		player thread [[level.spawnintermission]](0, level.usexcamsforendgame);
		player setclientuivisibilityflag("hud_visible", 1);
	}
	level clientfield::set("post_game", 1);
	doendgamesequence();
	if(isdefined(level.endgamefunction))
	{
		level thread [[level.endgamefunction]]();
	}
	level notify(#"sfade");
	/#
		print("");
	#/
	if(!isdefined(level.skipgameend) || !level.skipgameend)
	{
		wait(5);
	}
	if(isdefined(level.end_game_video))
	{
		level thread lui::play_movie(level.end_game_video.name, "fullscreen", 1);
		wait(level.end_game_video.duration + 4.5);
	}
	exit_level();
}

/*
	Name: awardlootxptoplayers
	Namespace: globallogic
	Checksum: 0x170DC6E4
	Offset: 0x95C0
	Size: 0xAA
	Parameters: 2
	Flags: Linked
*/
function awardlootxptoplayers(delay, players)
{
	wait(delay);
	foreach(player in players)
	{
		if(!isdefined(player))
		{
			continue;
		}
		player awardlootxp();
	}
}

/*
	Name: exit_level
	Namespace: globallogic
	Checksum: 0x3522BD6D
	Offset: 0x9678
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function exit_level()
{
	if(level.exitlevel)
	{
		return;
	}
	level.exitlevel = 1;
	exitlevel(0);
}

/*
	Name: update_top_scorers
	Namespace: globallogic
	Checksum: 0xA9401033
	Offset: 0x96B8
	Size: 0x2AE
	Parameters: 1
	Flags: Linked
*/
function update_top_scorers(winner)
{
	topscorers = [];
	winning_team = figureoutwinningteam(winner);
	if(level.teambased && isdefined(winner) && isdefined(level.placement[winning_team]))
	{
		topscorers = level.placement[winning_team];
	}
	else
	{
		topscorers = level.placement["all"];
	}
	if(topscorers.size)
	{
		level.dotopscorers = 1;
	}
	else
	{
		level.dotopscorers = 0;
	}
	cleartopscorers();
	for(i = 0; i < 3 && i < topscorers.size; i++)
	{
		player = topscorers[i];
		if(!isdefined(player))
		{
			continue;
		}
		player thread checkforgestures(i);
		showcase_weapon = player weapons::showcaseweapon_get();
		tauntindex = player getplayerselectedtaunt(0);
		gesture0index = player getplayerselectedgesture(0);
		gesture1index = player getplayerselectedgesture(1);
		gesture2index = player getplayerselectedgesture(2);
		if(!isdefined(showcase_weapon))
		{
			settopscorer(i, player, tauntindex, gesture0index, gesture1index, gesture2index, getweapon("ar_standard"));
			continue;
		}
		settopscorer(i, player, tauntindex, gesture0index, gesture1index, gesture2index, showcase_weapon["weapon"], showcase_weapon["options"], showcase_weapon["acvi"]);
	}
}

/*
	Name: checkforgestures
	Namespace: globallogic
	Checksum: 0x8CC3426A
	Offset: 0x9970
	Size: 0x120
	Parameters: 1
	Flags: Linked
*/
function checkforgestures(topplayerindex)
{
	self endon(#"disconnect");
	fieldname = ("playTop" + topplayerindex) + "Gesture";
	level clientfield::set(fieldname, 7);
	wait(0.05);
	while(true)
	{
		if(isdefined(self))
		{
			if(self actionslotonebuttonpressed())
			{
				self setgestureclientfield(fieldname, 0);
			}
			else
			{
				if(self actionslotthreebuttonpressed())
				{
					self setgestureclientfield(fieldname, 1);
				}
				else if(self actionslotfourbuttonpressed())
				{
					self setgestureclientfield(fieldname, 2);
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: setgestureclientfield
	Namespace: globallogic
	Checksum: 0x2A330C0B
	Offset: 0x9A98
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function setgestureclientfield(fieldname, gesturetype)
{
	self notify(#"setgestureclientfield");
	self endon(#"setgestureclientfield");
	level clientfield::set(fieldname, gesturetype);
	wait(0.05);
	level clientfield::set(fieldname, 7);
}

/*
	Name: doendgamesequence
	Namespace: globallogic
	Checksum: 0xD4F8F4B9
	Offset: 0x9B18
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function doendgamesequence()
{
	level notify(#"endgame_sequence");
	preloadingenabled = getdvarint("sv_mapSwitchPreloadFrontend", 0);
	if(level.dotopscorers && isdefined(struct::get("endgame_top_players_struct", "targetname")))
	{
		setmatchflag("enable_popups", 1);
		clearplayercorpses();
		level thread sndsetmatchsnapshot(3);
		level thread globallogic_audio::set_music_global("endmatch");
		level clientfield::set("displayTop3Players", 1);
		if(preloadingenabled)
		{
			switchmap_preload("core_frontend");
		}
		/#
			while(getdvarint("", 0))
			{
				wait(0.05);
			}
		#/
		wait(15);
		level clientfield::set("triggerScoreboardCamera", 1);
		wait(5);
		setmatchflag("enable_popups", 0);
	}
	else if(level.doendgamescoreboard)
	{
		if(preloadingenabled)
		{
			switchmap_preload("core_frontend");
		}
		luinotifyevent(&"force_scoreboard", 0);
	}
}

/*
	Name: gettotaltimeplayed
	Namespace: globallogic
	Checksum: 0xD0038204
	Offset: 0x9CF0
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function gettotaltimeplayed(maxlength)
{
	totaltimeplayed = 0;
	if(isdefined(self.pers["totalTimePlayed"]))
	{
		totaltimeplayed = self.pers["totalTimePlayed"];
		if(totaltimeplayed > maxlength)
		{
			totaltimeplayed = maxlength;
		}
	}
	return totaltimeplayed;
}

/*
	Name: getroundtimeplayed
	Namespace: globallogic
	Checksum: 0x6C8C8069
	Offset: 0x9D60
	Size: 0x72
	Parameters: 1
	Flags: Linked
*/
function getroundtimeplayed(roundlength)
{
	totaltimeplayed = 0;
	if(isdefined(self.timeplayed) && isdefined(self.timeplayed["total"]))
	{
		totaltimeplayed = self.timeplayed["total"];
		if(totaltimeplayed > roundlength)
		{
			totaltimeplayed = roundlength;
		}
	}
	return totaltimeplayed;
}

/*
	Name: bbplayermatchend
	Namespace: globallogic
	Checksum: 0xB1DDC63A
	Offset: 0x9DE0
	Size: 0xEC
	Parameters: 3
	Flags: Linked
*/
function bbplayermatchend(gamelength, endreasonstring, gameover)
{
	playerrank = getplacementforplayer(self);
	totaltimeplayed = self getroundtimeplayed(gamelength);
	xuid = self getxuid();
	bbprint("mpplayermatchfacts", "score %d momentum %d endreason %s sessionrank %d playtime %d xuid %s gameover %d team %s", self.pers["score"], self.pers["momentum"], endreasonstring, playerrank, totaltimeplayed, xuid, gameover, self.pers["team"]);
}

/*
	Name: roundendwait
	Namespace: globallogic
	Checksum: 0x6414B5B5
	Offset: 0x9ED8
	Size: 0x1AE
	Parameters: 2
	Flags: Linked
*/
function roundendwait(defaultdelay, matchbonus)
{
	notifiesdone = 0;
	while(!notifiesdone)
	{
		players = level.players;
		notifiesdone = 1;
		for(index = 0; index < players.size; index++)
		{
			if(!isdefined(players[index].doingnotify) || !players[index].doingnotify)
			{
				continue;
			}
			notifiesdone = 0;
		}
		wait(0.5);
	}
	if(!matchbonus)
	{
		wait(defaultdelay);
		level notify(#"round_end_done");
		return;
	}
	wait(defaultdelay / 2);
	level notify(#"give_match_bonus");
	wait(defaultdelay / 2);
	notifiesdone = 0;
	while(!notifiesdone)
	{
		players = level.players;
		notifiesdone = 1;
		for(index = 0; index < players.size; index++)
		{
			if(!isdefined(players[index].doingnotify) || !players[index].doingnotify)
			{
				continue;
			}
			notifiesdone = 0;
		}
		wait(0.5);
	}
	level notify(#"round_end_done");
}

/*
	Name: roundenddof
	Namespace: globallogic
	Checksum: 0xE5BFE1E0
	Offset: 0xA090
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
	Checksum: 0xA4804BEE
	Offset: 0xA0D8
	Size: 0x1E8
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
	if(isdefined(level.timerpaused) && level.timerpaused)
	{
		timeremaining = globallogic_utils::gettimeremaining();
		if(timeremaining > 30000)
		{
			setgameendtime((int(timeremaining - 999)) * -1);
		}
		else
		{
			setgameendtime((int(timeremaining - 99)) * -1);
		}
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
	Name: checkscorelimit
	Namespace: globallogic
	Checksum: 0xC6B9EB78
	Offset: 0xA2C8
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
		if(!util::any_team_hit_score_limit())
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
	Name: checksuddendeathscorelimit
	Namespace: globallogic
	Checksum: 0x47B7A029
	Offset: 0xA378
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function checksuddendeathscorelimit(team)
{
	if(game["state"] != "playing")
	{
		return false;
	}
	if(level.roundscorelimit <= 0)
	{
		return false;
	}
	if(level.teambased)
	{
		if(!game["teamSuddenDeath"][team])
		{
			return false;
		}
	}
	else
	{
		return false;
	}
	[[level.onscorelimit]]();
}

/*
	Name: checkroundscorelimit
	Namespace: globallogic
	Checksum: 0xDDC67EA9
	Offset: 0xA3F8
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function checkroundscorelimit()
{
	if(game["state"] != "playing")
	{
		return false;
	}
	if(level.roundscorelimit <= 0)
	{
		return false;
	}
	if(level.teambased)
	{
		if(!util::any_team_hit_round_score_limit())
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
		roundscorelimit = util::get_current_round_score_limit();
		if(self.pointstowin < roundscorelimit)
		{
			return false;
		}
	}
	[[level.onroundscorelimit]]();
}

/*
	Name: updategametypedvars
	Namespace: globallogic
	Checksum: 0xFF7DC79D
	Offset: 0xA4C0
	Size: 0x272
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
		roundscorelimit = math::clamp(getgametypesetting("roundScoreLimit"), level.roundscorelimitmin, level.roundscorelimitmax);
		if(roundscorelimit != level.roundscorelimit)
		{
			level.roundscorelimit = roundscorelimit;
			level notify(#"update_roundscorelimit");
		}
		thread checkroundscorelimit();
		if(isdefined(level.starttime))
		{
			if(globallogic_utils::gettimeremaining() < 3000)
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
	Checksum: 0x6BD95857
	Offset: 0xA740
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
	Checksum: 0xAF4B16EA
	Offset: 0xA920
	Size: 0x3E4
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
			for(j = i - 1; j >= 0 && (playerscore > placementall[j].pointstowin || (playerscore == placementall[j].pointstowin && player.deaths < placementall[j].deaths) || (playerscore == placementall[j].pointstowin && player.deaths == placementall[j].deaths && player.lastkilltime > placementall[j].lastkilltime)); j--)
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
	Checksum: 0x934000E0
	Offset: 0xAD10
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
	Checksum: 0x7607AE90
	Offset: 0xAEF0
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
	Checksum: 0xA3CBB575
	Offset: 0xAFB0
	Size: 0x24C
	Parameters: 1
	Flags: None
*/
function istopscoringplayer(player)
{
	topscoringplayer = 0;
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
			if(player == level.placement["all"][index])
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
			if(player == level.placement["all"][index])
			{
				topscoringplayer = 1;
				break;
			}
		}
	}
	return topscoringplayer;
}

/*
	Name: sortdeadplayers
	Namespace: globallogic
	Checksum: 0xE8F8B51
	Offset: 0xB208
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
	Checksum: 0xAA14EC25
	Offset: 0xB3B0
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
	Checksum: 0x8098D11C
	Offset: 0xB460
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
	Name: initteamvariables
	Namespace: globallogic
	Checksum: 0x392C6686
	Offset: 0xB510
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function initteamvariables(team)
{
	if(!isdefined(level.alivecount))
	{
		level.alivecount = [];
	}
	level.alivecount[team] = 0;
	level.lastalivecount[team] = 0;
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
	Checksum: 0xA51C4554
	Offset: 0xB608
	Size: 0xBA
	Parameters: 1
	Flags: Linked
*/
function resetteamvariables(team)
{
	level.playercount[team] = 0;
	level.botscount[team] = 0;
	level.lastalivecount[team] = level.alivecount[team];
	level.alivecount[team] = 0;
	level.playerlives[team] = 0;
	level.aliveplayers[team] = [];
	level.spawningplayers[team] = [];
	level.deadplayers[team] = [];
	level.squads[team] = [];
	level.spawnqueuemodified[team] = 0;
}

/*
	Name: updateteamstatus
	Namespace: globallogic
	Checksum: 0xFA660B9B
	Offset: 0xB6D0
	Size: 0x504
	Parameters: 0
	Flags: Linked
*/
function updateteamstatus()
{
	level notify(#"updating_team_status");
	level endon(#"updating_team_status");
	level endon(#"game_ended");
	waittillframeend();
	wait(0);
	if(game["state"] == "postgame")
	{
		return;
	}
	resettimeout();
	foreach(team in level.teams)
	{
		resetteamvariables(team);
	}
	if(!level.teambased)
	{
		resetteamvariables("free");
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
		if(level.teambased || player.team == "spectator")
		{
			team = player.team;
		}
		else
		{
			team = "free";
		}
		playerclass = player.curclass;
		if(team != "spectator" && (isdefined(playerclass) && playerclass != ""))
		{
			level.playercount[team]++;
			if(isdefined(player.pers["isBot"]))
			{
				level.botscount[team]++;
			}
			not_quite_dead = 0;
			if(isdefined(player.overrideplayerdeadstatus))
			{
				not_quite_dead = player [[player.overrideplayerdeadstatus]]();
			}
			if(player.sessionstate == "playing")
			{
				level.alivecount[team]++;
				level.playerlives[team]++;
				player.spawnqueueindex = -1;
				if(isalive(player))
				{
					level.aliveplayers[team][level.aliveplayers[team].size] = player;
					level.activeplayers[level.activeplayers.size] = player;
				}
				else
				{
					level.deadplayers[team][level.deadplayers[team].size] = player;
				}
				continue;
			}
			if(not_quite_dead)
			{
				level.alivecount[team]++;
				level.playerlives[team]++;
				level.aliveplayers[team][level.aliveplayers[team].size] = player;
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
	Name: updatealivetimes
	Namespace: globallogic
	Checksum: 0xB618A7ED
	Offset: 0xBBE0
	Size: 0x3BC
	Parameters: 1
	Flags: Linked
*/
function updatealivetimes(team)
{
	level.alivetimesaverage[team] = 0;
	if(game["state"] == "postgame")
	{
		return;
	}
	total_player_count = 0;
	average_player_spawn_time = 0;
	total_value_count = 0;
	foreach(player in level.aliveplayers[team])
	{
		average_time = 0;
		count = 0;
		foreach(time in player.alivetimes)
		{
			if(time != 0)
			{
				average_time = average_time + time;
				count++;
			}
		}
		if(count)
		{
			total_value_count = total_value_count + count;
			average_player_spawn_time = average_player_spawn_time + (average_time / count);
			total_player_count++;
		}
	}
	foreach(player in level.deadplayers[team])
	{
		average_time = 0;
		count = 0;
		foreach(time in player.alivetimes)
		{
			if(time != 0)
			{
				average_time = average_time + time;
				count++;
			}
		}
		if(count)
		{
			total_value_count = total_value_count + count;
			average_player_spawn_time = average_player_spawn_time + (average_time / count);
			total_player_count++;
		}
	}
	if(total_player_count == 0 || total_value_count < 3)
	{
		level.alivetimesaverage[team] = 0;
		return;
	}
	level.alivetimesaverage[team] = average_player_spawn_time / total_player_count;
	/#
		if(getdvarint(""))
		{
			iprintln((("" + level.alivetimesaverage[""]) + "") + level.alivetimesaverage[""]);
		}
	#/
}

/*
	Name: updateallalivetimes
	Namespace: globallogic
	Checksum: 0x3A6C6A94
	Offset: 0xBFA8
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function updateallalivetimes()
{
	foreach(team in level.teams)
	{
		updatealivetimes(team);
	}
}

/*
	Name: checkteamscorelimitsoon
	Namespace: globallogic
	Checksum: 0xD1739D5B
	Offset: 0xC040
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
	Checksum: 0xB912D1D2
	Offset: 0xC100
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
	Checksum: 0x9A62DF16
	Offset: 0xC1B8
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
	Checksum: 0x12DBDC25
	Offset: 0xC460
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
	Name: recordbreadcrumbdata
	Namespace: globallogic
	Checksum: 0x8B78151D
	Offset: 0xC518
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function recordbreadcrumbdata()
{
	level endon(#"game_ended");
	while(true)
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if(isalive(player))
			{
				recordbreadcrumbdataforplayer(player, player.lastshotby);
			}
		}
		wait(2);
	}
}

/*
	Name: startgame
	Namespace: globallogic
	Checksum: 0x88B6D22E
	Offset: 0xC5D0
	Size: 0x2BC
	Parameters: 0
	Flags: Linked
*/
function startgame()
{
	thread globallogic_utils::gametimer();
	level.timerstopped = 0;
	level.playabletimerstopped = 0;
	setmatchtalkflag("DeadChatWithDead", level.voip.deadchatwithdead);
	setmatchtalkflag("DeadChatWithTeam", level.voip.deadchatwithteam);
	setmatchtalkflag("DeadHearTeamLiving", level.voip.deadhearteamliving);
	setmatchtalkflag("DeadHearAllLiving", level.voip.deadhearallliving);
	setmatchtalkflag("EveryoneHearsEveryone", level.voip.everyonehearseveryone);
	setmatchtalkflag("DeadHearKiller", level.voip.deadhearkiller);
	setmatchtalkflag("KillersHearVictim", level.voip.killershearvictim);
	cleartopscorers();
	if(isdefined(level.custom_prematch_period))
	{
		[[level.custom_prematch_period]]();
	}
	else
	{
		prematchperiod();
	}
	level notify(#"prematch_over");
	level.prematch_over = 1;
	level clientfield::set("gameplay_started", 1);
	thread notifyendofgameplay();
	thread timelimitclock();
	thread graceperiod();
	thread watchmatchendingsoon();
	thread globallogic_audio::announcercontroller();
	thread globallogic_audio::sndmusicfunctions();
	thread recordbreadcrumbdata();
	if(util::isroundbased())
	{
		if(util::getroundsplayed() == 0)
		{
			recordmatchbegin();
		}
		matchrecordroundstart();
		if(isdefined(game["overtime_round"]))
		{
			matchrecordovertimeround();
		}
	}
	else
	{
		recordmatchbegin();
	}
}

/*
	Name: function_1d225b5
	Namespace: globallogic
	Checksum: 0xB0368042
	Offset: 0xC898
	Size: 0x19C
	Parameters: 2
	Flags: Linked
*/
function function_1d225b5(activeteamcount, starttime)
{
	/#
		if(!isdefined(level.prematchrequirement))
		{
			println("");
			return;
		}
		str = "" + level.prematchrequirement;
		if(isdefined(level.prematchrequirementtime))
		{
			str = str + ("" + level.prematchrequirementtime);
		}
		if(isdefined(starttime))
		{
			str = str + (("" + starttime) + "") + (gettime() - starttime);
		}
		if(isdefined(activeteamcount))
		{
			str = str + ("" + activeteamcount.size);
			if(activeteamcount.size > 1)
			{
				foreach(team, teamcount in activeteamcount)
				{
					str = str + ((("" + team) + "") + teamcount);
				}
			}
		}
		println(str);
	#/
}

/*
	Name: isprematchrequirementconditionmet
	Namespace: globallogic
	Checksum: 0x6F4B4EF1
	Offset: 0xCA40
	Size: 0x2A4
	Parameters: 2
	Flags: Linked
*/
function isprematchrequirementconditionmet(activeteamcount, starttime)
{
	/#
		function_1d225b5(activeteamcount, starttime);
	#/
	if(level.prematchrequirement == 0)
	{
		return true;
	}
	if(level.prematchrequirementtime > 0 && (gettime() - starttime) > (level.prematchrequirementtime * 1000))
	{
		return true;
	}
	if(util::function_938b1b6b())
	{
		var_e9ed40ff = 0;
		foreach(teamcount in activeteamcount)
		{
			var_e9ed40ff = var_e9ed40ff + teamcount;
		}
		if(var_e9ed40ff != level.prematchrequirement)
		{
			return false;
		}
	}
	else
	{
		if(level.teambased && level.prematchrequirementtime > 0)
		{
			if(activeteamcount.size <= 1)
			{
				return false;
			}
			foreach(teamcount in activeteamcount)
			{
				if(teamcount < level.prematchrequirement)
				{
					return false;
				}
			}
		}
		else
		{
			if(level.teambased)
			{
				if(activeteamcount.size <= 1)
				{
					return false;
				}
				foreach(teamcount in activeteamcount)
				{
					if(teamcount != level.prematchrequirement)
					{
						return false;
					}
				}
			}
			else if(activeteamcount["free"] != level.prematchrequirement)
			{
				return false;
			}
		}
	}
	return true;
}

/*
	Name: waitforplayers
	Namespace: globallogic
	Checksum: 0x7C551B67
	Offset: 0xCCF0
	Size: 0x3FA
	Parameters: 0
	Flags: Linked
*/
function waitforplayers()
{
	level endon(#"game_ended");
	starttime = gettime();
	playerready = 0;
	activeplayercount = 0;
	accepttestclient = 0;
	activeteamcount = [];
	player_ready = [];
	var_6b989ec4 = undefined;
	while(!playerready || activeplayercount == 0 || !isprematchrequirementconditionmet(activeteamcount, var_6b989ec4))
	{
		activeplayercount = 0;
		if(level.teambased)
		{
			foreach(team in level.teams)
			{
				activeteamcount[team] = 0;
			}
		}
		else
		{
			activeteamcount["free"] = 0;
		}
		temp_player_ready = [];
		foreach(player in level.players)
		{
			if(player istestclient() && accepttestclient == 0)
			{
				continue;
			}
			if(player.team != "spectator")
			{
				activeplayercount++;
				player_num = player getentitynumber();
				if(isdefined(player_ready[player_num]))
				{
					temp_player_ready[player_num] = player_ready[player_num];
				}
				else
				{
					temp_player_ready[player_num] = gettime();
				}
				if((temp_player_ready[player_num] + 5000) < gettime() || player isstreamerready(-1, 1))
				{
					if(level.teambased)
					{
						activeteamcount[player.team]++;
					}
					else
					{
						activeteamcount["free"]++;
					}
				}
			}
			if(player isstreamerready(-1, 1))
			{
				if(playerready == 0)
				{
					level notify(#"first_player_ready", player);
				}
				playerready = 1;
			}
		}
		player_read = temp_player_ready;
		wait(0.05);
		if((gettime() - starttime) > 20000)
		{
			if(level.rankedmatch == 0 && level.arenamatch == 0)
			{
				accepttestclient = 1;
			}
		}
		if(level.rankedmatch && (gettime() - starttime) > 120000)
		{
			exit_level();
			while(true)
			{
				wait(10);
			}
		}
		if(!isdefined(var_6b989ec4) && playerready && activeplayercount != 0)
		{
			var_6b989ec4 = gettime();
		}
	}
}

/*
	Name: prematchwaitingforplayers
	Namespace: globallogic
	Checksum: 0x9700B566
	Offset: 0xD0F8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function prematchwaitingforplayers()
{
	if(level.prematchrequirement != 0)
	{
		level waittill(#"first_player_ready", player);
		thread function_27cab3b4();
	}
}

/*
	Name: function_27cab3b4
	Namespace: globallogic
	Checksum: 0x9B137271
	Offset: 0xD140
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_27cab3b4()
{
	foreach(player in level.players)
	{
		thread function_d95d1608(player);
	}
	thread function_53995bbb();
}

/*
	Name: function_53995bbb
	Namespace: globallogic
	Checksum: 0xCD216207
	Offset: 0xD1E8
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function function_53995bbb()
{
	level endon(#"game_ended");
	level endon(#"hash_32c1c011");
	while(true)
	{
		level waittill(#"connected", player);
		self thread function_d95d1608(player);
	}
}

/*
	Name: function_d95d1608
	Namespace: globallogic
	Checksum: 0x6F9113EA
	Offset: 0xD248
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function function_d95d1608(player)
{
	level endon(#"game_ended");
	level endon(#"hash_32c1c011");
	player endon(#"disconnect");
	while(true)
	{
		if(isdefined(player.hasspawned) && player.hasspawned)
		{
			wait(2);
			player luinotifyevent(&"prematch_waiting_for_players");
			return;
		}
		player waittill(#"spawned");
	}
}

/*
	Name: prematchperiod
	Namespace: globallogic
	Checksum: 0xC049D933
	Offset: 0xD2F0
	Size: 0x16A
	Parameters: 0
	Flags: Linked
*/
function prematchperiod()
{
	setmatchflag("hud_hardcore", level.hardcoremode);
	level endon(#"game_ended");
	globallogic_audio::sndmusicsetrandomizer();
	if(level.prematchperiod > 0)
	{
		thread matchstarttimer();
		thread prematchwaitingforplayers();
		waitforplayers();
		level notify(#"hash_32c1c011");
		wait(level.prematchperiod);
	}
	else
	{
		matchstarttimerskip();
		wait(0.05);
	}
	level.inprematchperiod = 0;
	level thread sndsetmatchsnapshot(0);
	for(index = 0; index < level.players.size; index++)
	{
		level.players[index] util::freeze_player_controls(0);
		level.players[index] enableweapons();
	}
	if(game["state"] != "playing")
	{
		return;
	}
}

/*
	Name: graceperiod
	Namespace: globallogic
	Checksum: 0x95F1B12
	Offset: 0xD468
	Size: 0x164
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
	level thread updateteamstatus();
	level thread updateallalivetimes();
}

/*
	Name: watchmatchendingsoon
	Namespace: globallogic
	Checksum: 0x946FC2A3
	Offset: 0xD5D8
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
	Name: assertteamvariables
	Namespace: globallogic
	Checksum: 0x737D50A3
	Offset: 0xD638
	Size: 0x332
	Parameters: 0
	Flags: Linked
*/
function assertteamvariables()
{
	foreach(team in level.teams)
	{
		/#
			assert(isdefined(game[""][team + ""]), ("" + team) + "");
		#/
		/#
			assert(isdefined(game[""][team + ""]), ("" + team) + "");
		#/
		/#
			assert(isdefined(game[""][team + ""]), ("" + team) + "");
		#/
		/#
			assert(isdefined(game[""][team + ""]), ("" + team) + "");
		#/
		/#
			assert(isdefined(game[""][team + ""]), ("" + team) + "");
		#/
		/#
			assert(isdefined(game[""][team + ""]), ("" + team) + "");
		#/
		/#
			assert(isdefined(game[""]["" + team]), ("" + team) + "");
		#/
		/#
			assert(isdefined(game[""]["" + team]), ("" + team) + "");
		#/
		/#
			assert(isdefined(game[""][team]), ("" + team) + "");
		#/
		/#
			assert(isdefined(game[""][team]), ("" + team) + "");
		#/
	}
}

/*
	Name: anyteamhaswavedelay
	Namespace: globallogic
	Checksum: 0x4E596F46
	Offset: 0xD978
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
	Checksum: 0xA1770E4E
	Offset: 0xDA10
	Size: 0x18D4
	Parameters: 0
	Flags: Linked
*/
function callback_startgametype()
{
	level.prematchrequirement = 0;
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
		game["strings"]["spawn_next_round"] = &"MP_SPAWN_NEXT_ROUND";
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
		game["strings"]["round_score_limit_reached"] = &"MP_SCORE_LIMIT_REACHED";
		game["strings"]["round_limit_reached"] = &"MP_ROUND_LIMIT_REACHED";
		game["strings"]["time_limit_reached"] = &"MP_TIME_LIMIT_REACHED";
		game["strings"]["players_forfeited"] = &"MP_PLAYERS_FORFEITED";
		game["strings"]["other_teams_forfeited"] = &"MP_OTHER_TEAMS_FORFEITED";
		assertteamvariables();
		[[level.onprecachegametype]]();
		game["gamestarted"] = 1;
		game["totalKills"] = 0;
		foreach(team in level.teams)
		{
			if(!isdefined(game["migratedHost"]))
			{
				game["teamScores"][team] = 0;
			}
			game["teamSuddenDeath"][team] = 0;
			game["totalKillsTeam"][team] = 0;
		}
		level.prematchrequirement = getgametypesetting("prematchRequirement");
		level.prematchrequirementtime = getgametypesetting("prematchRequirementTime");
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
	if(!isdefined(game["playabletimepassed"]))
	{
		game["playabletimepassed"] = 0;
	}
	if(!isdefined(game["roundsplayed"]))
	{
		game["roundsplayed"] = 0;
	}
	setroundsplayed(game["roundsplayed"]);
	if(isdefined(game["overtime_round"]))
	{
		setroundsplayed((game["roundsplayed"] + game["overtime_round"]) - 1);
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
	if(!isdefined(game["overtimeroundswon"]))
	{
		game["overtimeroundswon"] = [];
	}
	if(!isdefined(game["overtimeroundswon"]["tie"]))
	{
		game["overtimeroundswon"]["tie"] = 0;
	}
	foreach(team in level.teams)
	{
		if(!isdefined(game["roundswon"][team]))
		{
			game["roundswon"][team] = 0;
		}
		if(!isdefined(game["overtimeroundswon"][team]))
		{
			game["overtimeroundswon"][team] = 0;
		}
		level.teamspawnpoints[team] = [];
		level.spawn_point_team_class_names[team] = [];
	}
	level.skipvote = 0;
	level.gameended = 0;
	level.exitlevel = 0;
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
	level.alwaysusestartspawns = 0;
	level.usexcamsforendgame = 1;
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
	level.disableclassselection = getgametypesetting("disableClassSelection");
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
	level.scoreresetondeath = getgametypesetting("scoreResetOnDeath");
	level.playerrespawndelay = getgametypesetting("playerRespawnDelay");
	level.playerincrementalrespawndelay = getgametypesetting("incrementalSpawnDelay");
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
	level.droppedtagrespawn = getgametypesetting("droppedTagRespawn");
	level.disablevehiclespawners = getgametypesetting("disableVehicleSpawners");
	if(isdefined(level.droppedtagrespawn) && level.droppedtagrespawn)
	{
		dogtags::init();
	}
	gameobjects::main();
	callback::callback(#"hash_cc62acca");
	thread hud_message::init();
	foreach(team in level.teams)
	{
		initteamvariables(team);
	}
	if(!level.teambased)
	{
		initteamvariables("free");
	}
	level.maxplayercount = 0;
	level.activeplayers = [];
	level.alivetimemaxcount = 3;
	level.alivetimesaverage = [];
	foreach(team in level.teams)
	{
		level.alivetimesaverage[team] = 0;
	}
	if(!isdefined(level.livesdonotreset) || !level.livesdonotreset)
	{
		foreach(team in level.teams)
		{
			game[team + "_lives"] = level.numteamlives;
		}
	}
	level.allowannouncer = getgametypesetting("allowAnnouncer");
	if(!isdefined(level.timelimit))
	{
		util::registertimelimit(1, 1440);
	}
	if(!isdefined(level.scorelimit))
	{
		util::registerscorelimit(1, 500);
	}
	if(!isdefined(level.roundscorelimit))
	{
		util::registerroundscorelimit(0, 500);
	}
	if(!isdefined(level.roundlimit))
	{
		util::registerroundlimit(0, 10);
	}
	if(!isdefined(level.roundwinlimit))
	{
		util::registerroundwinlimit(0, 10);
	}
	globallogic_utils::registerpostroundevent(&killcam::post_round_final_killcam);
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
	if(level.prematchperiod > 2 && level.rankedmatch)
	{
		level.prematchperiod = level.prematchperiod + (randomfloat(4) - 2);
	}
	if(!isdefined(level.graceperiod))
	{
		if(level.numlives || anyteamhaswavedelay() || level.playerqueuedrespawn)
		{
			level.graceperiod = 15;
		}
		else
		{
			level.graceperiod = 5;
		}
	}
	level.ingraceperiod = 1;
	level.roundenddelay = 5;
	level.halftimeroundenddelay = 3;
	globallogic_score::updateallteamscores();
	level.killstreaksenabled = 1;
	level.missilelockplayspacecheckenabled = 1;
	level.missilelockplayspacecheckextraradius = 5000;
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
	level thread killcam::do_final_killcam();
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
	Checksum: 0xA5D44204
	Offset: 0xF2F0
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
	Checksum: 0x90506090
	Offset: 0xF348
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
	Checksum: 0x99AF73CD
	Offset: 0xF460
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
	Name: function_aa9e547b
	Namespace: globallogic
	Checksum: 0x2B28724E
	Offset: 0xF4F8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_aa9e547b()
{
	while(true)
	{
		endmatch = getdvarint("sv_endmatch", 0);
		if(isdefined(endmatch) && endmatch != 0)
		{
			setdvar("sv_endmatch", 0);
			level thread forceend();
			return;
		}
		wait(0.05);
	}
}

/*
	Name: listenforgameend
	Namespace: globallogic
	Checksum: 0x80E2F054
	Offset: 0xF590
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function listenforgameend()
{
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
	Checksum: 0xF6088D28
	Offset: 0xF5D8
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function getkillstreaks(player)
{
	for(killstreaknum = 0; killstreaknum < level.maxkillstreaks; killstreaknum++)
	{
		killstreak[killstreaknum] = "killstreak_null";
	}
	if(isplayer(player) && level.disableclassselection != 1 && !isdefined(player.pers["isBot"]) && isdefined(player.killstreak))
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
	Checksum: 0x76F943A5
	Offset: 0xF700
	Size: 0x84
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
	globallogic_score::updatematchbonusscores(winner);
}

/*
	Name: annihilatorgunplayerkilleffect
	Namespace: globallogic
	Checksum: 0x57CC37D7
	Offset: 0xF790
	Size: 0x124
	Parameters: 2
	Flags: Linked
*/
function annihilatorgunplayerkilleffect(attacker, weapon)
{
	if(weapon.fusetime != 0)
	{
		wait(weapon.fusetime * 0.001);
	}
	else
	{
		wait(0.45);
	}
	if(!isdefined(self))
	{
		return;
	}
	self playsoundtoplayer("evt_annihilation", attacker);
	self playsoundtoallbutplayer("evt_annihilation_npc", attacker);
	codesetclientfield(self, "annihilate_effect", 1);
	self shake_and_rumble(0, 0.3, 0.75, 1);
	wait(0.1);
	if(!isdefined(self))
	{
		return;
	}
	self notsolid();
	self ghost();
}

/*
	Name: annihilatorgunactorkilleffect
	Namespace: globallogic
	Checksum: 0x94E2CD86
	Offset: 0xF8C0
	Size: 0x144
	Parameters: 2
	Flags: Linked
*/
function annihilatorgunactorkilleffect(attacker, weapon)
{
	self waittill(#"actor_corpse", body);
	if(weapon.fusetime != 0)
	{
		wait(weapon.fusetime * 0.001);
	}
	else
	{
		wait(0.45);
	}
	if(!isdefined(self))
	{
		return;
	}
	self playsoundtoplayer("evt_annihilation", attacker);
	self playsoundtoallbutplayer("evt_annihilation_npc", attacker);
	if(!isdefined(body))
	{
		return;
	}
	codesetclientfield(body, "annihilate_effect", 1);
	body shake_and_rumble(0, 0.6, 0.2, 1);
	body notsolid();
	body ghost();
}

/*
	Name: pineapplegunplayerkilleffect
	Namespace: globallogic
	Checksum: 0x41821D
	Offset: 0xFA10
	Size: 0xC4
	Parameters: 1
	Flags: None
*/
function pineapplegunplayerkilleffect(attacker)
{
	wait(0.1);
	if(!isdefined(self))
	{
		return;
	}
	playsoundatposition("evt_annihilation_npc", self.origin);
	codesetclientfield(self, "pineapplegun_effect", 1);
	self shake_and_rumble(0, 0.3, 0.35, 1);
	wait(0.1);
	if(!isdefined(self))
	{
		return;
	}
	self notsolid();
	self ghost();
}

/*
	Name: bowplayerkilleffect
	Namespace: globallogic
	Checksum: 0x2F05D9F8
	Offset: 0xFAE0
	Size: 0xB4
	Parameters: 0
	Flags: None
*/
function bowplayerkilleffect()
{
	wait(0.05);
	if(!isdefined(self))
	{
		return;
	}
	playsoundatposition("evt_annihilation_npc", self.origin);
	codesetclientfield(self, "annihilate_effect", 1);
	self shake_and_rumble(0, 0.3, 0.35, 1);
	if(!isdefined(self))
	{
		return;
	}
	self notsolid();
	self ghost();
}

/*
	Name: pineapplegunactorkilleffect
	Namespace: globallogic
	Checksum: 0xE2278304
	Offset: 0xFBA0
	Size: 0xDC
	Parameters: 0
	Flags: None
*/
function pineapplegunactorkilleffect()
{
	self waittill(#"actor_corpse", body);
	wait(0.75);
	if(!isdefined(self))
	{
		return;
	}
	playsoundatposition("evt_annihilation_npc", self.origin);
	if(!isdefined(body))
	{
		return;
	}
	codesetclientfield(body, "pineapplegun_effect", 1);
	body shake_and_rumble(0, 0.3, 0.75, 1);
	body notsolid();
	body ghost();
}

/*
	Name: shake_and_rumble
	Namespace: globallogic
	Checksum: 0x534EAAF1
	Offset: 0xFC88
	Size: 0xF6
	Parameters: 4
	Flags: Linked
*/
function shake_and_rumble(n_delay, shake_size, shake_time, rumble_num)
{
	if(isdefined(n_delay) && n_delay > 0)
	{
		wait(n_delay);
	}
	nmagnitude = shake_size;
	nduration = shake_time;
	nradius = 500;
	v_pos = self.origin;
	earthquake(nmagnitude, nduration, v_pos, nradius);
	for(i = 0; i < rumble_num; i++)
	{
		self playrumbleonentity("damage_heavy");
		wait(0.1);
	}
}

/*
	Name: doweaponspecifickilleffects
	Namespace: globallogic
	Checksum: 0xD08B3924
	Offset: 0xFD88
	Size: 0xA4
	Parameters: 8
	Flags: Linked
*/
function doweaponspecifickilleffects(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	if(weapon.name == "hero_pineapplegun" && isplayer(attacker) && smeansofdeath == "MOD_GRENADE")
	{
		attacker playlocalsound("wpn_pineapple_grenade_explode_flesh_2D");
	}
}

/*
	Name: doweaponspecificcorpseeffects
	Namespace: globallogic
	Checksum: 0xD8100F94
	Offset: 0xFE38
	Size: 0x1D4
	Parameters: 9
	Flags: Linked
*/
function doweaponspecificcorpseeffects(body, einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	if(weapon.doannihilate && isplayer(attacker) && (smeansofdeath == "MOD_IMPACT" || smeansofdeath == "MOD_GRENADE"))
	{
		if(isactor(body))
		{
			body thread annihilatorgunactorkilleffect(attacker, weapon);
		}
		else
		{
			body thread annihilatorgunplayerkilleffect(attacker, weapon);
		}
	}
	else
	{
		if(smeansofdeath == "MOD_BURNED")
		{
			if(!isactor(body))
			{
				body thread burncorpse();
			}
		}
		else if(weapon.isheroweapon == 1 && isplayer(attacker))
		{
			if(weapon.name == "hero_firefly_swarm")
			{
				value = randomint(2) + 1;
				if(!isactor(body))
				{
					codesetclientfield(body, "firefly_effect", value);
				}
			}
		}
	}
}

/*
	Name: burncorpse
	Namespace: globallogic
	Checksum: 0xC4486624
	Offset: 0x10018
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function burncorpse()
{
	self endon(#"death");
	codesetclientfield(self, "burned_effect", 1);
	wait(3);
	codesetclientfield(self, "burned_effect", 0);
}

