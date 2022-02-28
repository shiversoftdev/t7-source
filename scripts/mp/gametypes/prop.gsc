// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_teamops;
#using scripts\mp\_util;
#using scripts\mp\bots\_bot;
#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_deathicons;
#using scripts\mp\gametypes\_dogtags;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_spawn;
#using scripts\mp\gametypes\_globallogic_ui;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_killcam;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\gametypes\_prop_controls;
#using scripts\mp\gametypes\_prop_dev;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\teams\_teams;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;

#namespace prop;

/*
	Name: __init__sytem__
	Namespace: prop
	Checksum: 0x92A36DF9
	Offset: 0xEB0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("prop", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: prop
	Checksum: 0x791D3167
	Offset: 0xEF0
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "hideTeamPlayer", 27000, 2, "int");
	clientfield::register("allplayers", "pingHighlight", 27000, 1, "int");
}

/*
	Name: main
	Namespace: prop
	Checksum: 0xA79EC2B8
	Offset: 0xF60
	Size: 0x6BC
	Parameters: 0
	Flags: None
*/
function main()
{
	globallogic::init();
	util::registerroundswitch(0, 9);
	util::registertimelimit(0, 4);
	util::registerscorelimit(0, 0);
	util::registerroundlimit(0, 4);
	util::registerroundwinlimit(0, 3);
	util::registernumlives(0, 1);
	level.phsettings = spawnstruct();
	level.phsettings.prophidetime = 30;
	level.phsettings.propwhistletime = function_fc1530ac();
	level.phsettings.propchangecount = 2;
	level.phsettings.propnumflashes = 1;
	level.phsettings.propnumclones = 3;
	level.phsettings.propspeedscale = 1.4;
	level.phsettings.var_60a20fdc = 2;
	level.phsettings.var_23bd3153 = 0;
	level.phsettings.var_e332c699 = level.script == "mp_nuketown_x";
	level.phsettings.var_78280ce0 = level.phsettings.var_e332c699;
	if(level.phsettings.var_78280ce0)
	{
		level.phsettings.propnumclones = 9;
	}
	globallogic::registerfriendlyfiredelay(level.gametype, 15, 0, 1440);
	level.isprophunt = 1;
	level.allow_teamchange = "1";
	level.killstreaksenabled = 0;
	level.teambased = 1;
	level.overrideteamscore = 1;
	level.alwaysusestartspawns = 1;
	level.scoreroundwinbased = getgametypesetting("cumulativeRoundScores") == 0;
	level.teamscoreperkill = getgametypesetting("teamScorePerKill");
	level.teamscoreperdeath = getgametypesetting("teamScorePerDeath");
	level.teamscoreperheadshot = getgametypesetting("teamScorePerHeadshot");
	level.killstreaksgivegamescore = getgametypesetting("killstreaksGiveGameScore");
	level.onstartgametype = &onstartgametype;
	level.onspawnplayer = &onspawnplayer;
	level.onplayerdisconnect = &onplayerdisconnect;
	level.onroundendgame = &onroundendgame;
	level.onroundswitch = &onroundswitch;
	level.var_7d4f8220 = &function_7d4f8220;
	level.onplayerkilled = &onplayerkilled;
	level.ononeleftevent = &ononeleftevent;
	level.ontimelimit = &ontimelimit;
	level.ondeadevent = &ondeadevent;
	level.var_b9fd53a3 = &function_470f21c5;
	level.var_a58db931 = &playdeathsoundph;
	level.overrideplayerdamage = &gamemodemodifyplayerdamage;
	level.var_c17c938d = &function_c17c938d;
	level.var_6f13f156 = &function_6f13f156;
	level.var_e0d16266 = &function_e0d16266;
	level.var_4fb47492 = &function_4fb47492;
	level.givecustomloadout = &givecustomloadout;
	level.var_a4623c17 = &function_e999d;
	level.var_dc6b46ed = &function_dc6b46ed;
	level.var_9bb11de9 = &function_9bb11de9;
	level.determinewinner = &determinewinner;
	level.var_64783fef = 1;
	gameobjects::register_allowed_gameobject(level.gametype);
	globallogic::setvisiblescoreboardcolumns("score", "objtime", "kills", "deaths", "assists");
	level.proplist = [];
	level.propindex = [];
	level.spawnproplist = [];
	level.abilities = array("FLASH", "CLONE");
	populateproplist();
	level.graceperiod = int(level.phsettings.prophidetime + 0.5);
	level thread onplayerconnect();
	level thread delayset();
	level thread function_1edf732a();
	if(level.phsettings.var_e332c699)
	{
		level thread function_7010fe7f();
	}
	shatterallglass();
	util::set_dvar_int_if_unset("scr_prop_minigame", 1);
	/#
		level.var_2898ef72 = 0;
		thread namespace_baba9b52::function_6c015e54();
	#/
}

/*
	Name: function_fc1530ac
	Namespace: prop
	Checksum: 0xA91946C
	Offset: 0x1628
	Size: 0x60
	Parameters: 0
	Flags: None
*/
function function_fc1530ac()
{
	if(level.script == "mp_chinatown")
	{
		return 18;
	}
	if(level.script == "mp_redwood")
	{
		return 20;
	}
	if(level.script == "mp_nuketown_x")
	{
		return 0;
	}
	return 30;
}

/*
	Name: delayset
	Namespace: prop
	Checksum: 0x324EAE9A
	Offset: 0x1690
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function delayset()
{
	wait(0.05);
	level.playstartconversation = 0;
	level.allowspecialistdialog = 0;
}

/*
	Name: onendgame
	Namespace: prop
	Checksum: 0x5812E593
	Offset: 0x16C0
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
	Namespace: prop
	Checksum: 0xD1A36CA9
	Offset: 0x1710
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
	Namespace: prop
	Checksum: 0xA92E100
	Offset: 0x17D8
	Size: 0x80
	Parameters: 1
	Flags: None
*/
function onroundendgame(var_18d04d1c)
{
	var_cc1b07b2 = var_18d04d1c;
	if(level.gameended)
	{
		var_cc1b07b2 = function_c7ac59e(var_cc1b07b2, 1);
	}
	if(var_cc1b07b2 == "allies" || var_cc1b07b2 == "axis")
	{
		ph_setfinalkillcamwinner(var_cc1b07b2);
	}
	return var_cc1b07b2;
}

/*
	Name: determinewinner
	Namespace: prop
	Checksum: 0x5913E0EC
	Offset: 0x1860
	Size: 0x22
	Parameters: 1
	Flags: None
*/
function determinewinner(roundwinner)
{
	return function_c7ac59e(roundwinner, 0);
}

/*
	Name: function_c7ac59e
	Namespace: prop
	Checksum: 0x36E87AE6
	Offset: 0x1890
	Size: 0x230
	Parameters: 2
	Flags: None
*/
function function_c7ac59e(roundwinner, var_6ea8eea4)
{
	var_cc1b07b2 = roundwinner;
	var_f432b51f = "roundswon";
	level.proptiebreaker = "none";
	if(game[var_f432b51f]["allies"] == game[var_f432b51f]["axis"])
	{
		level.proptiebreaker = "kills";
		if(game["propScore"]["axis"] == game["propScore"]["allies"])
		{
			level.proptiebreaker = "time";
			if(game["hunterKillTime"]["axis"] == game["hunterKillTime"]["allies"])
			{
				level.proptiebreaker = "tie";
				var_cc1b07b2 = "tie";
			}
			else
			{
				if(game["hunterKillTime"]["axis"] < game["hunterKillTime"]["allies"])
				{
					var_cc1b07b2 = "axis";
				}
				else
				{
					var_cc1b07b2 = "allies";
				}
			}
		}
		else
		{
			if(game["propScore"]["axis"] > game["propScore"]["allies"])
			{
				var_cc1b07b2 = "axis";
			}
			else
			{
				var_cc1b07b2 = "allies";
			}
		}
		if(var_cc1b07b2 != "tie" && var_6ea8eea4)
		{
			level thread givephteamscore(var_cc1b07b2);
		}
	}
	else
	{
		if(game[var_f432b51f]["axis"] > game[var_f432b51f]["allies"])
		{
			var_cc1b07b2 = "axis";
		}
		else
		{
			var_cc1b07b2 = "allies";
		}
	}
	return var_cc1b07b2;
}

/*
	Name: onscoreclosemusic
	Namespace: prop
	Checksum: 0xE1E19167
	Offset: 0x1AC8
	Size: 0x1C2
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
		if(topscore >= (scorelimit * 0.5))
		{
			level notify(#"sndmusichalfway");
			return;
		}
		wait(1);
	}
}

/*
	Name: onplayerconnect
	Namespace: prop
	Checksum: 0xFF7A20CA
	Offset: 0x1C98
	Size: 0xA2
	Parameters: 0
	Flags: None
*/
function onplayerconnect()
{
	while(true)
	{
		level waittill(#"connected", player);
		player.var_d1d70226 = 1;
		if(isdefined(level.allow_teamchange) && level.allow_teamchange == "0")
		{
			player.hasdonecombat = 1;
		}
		if(!isdefined(player.pers["objtime"]))
		{
			player.pers["objtime"] = 0;
		}
	}
}

/*
	Name: hidehudintermission
	Namespace: prop
	Checksum: 0xC0B6EE59
	Offset: 0x1D48
	Size: 0xFA
	Parameters: 0
	Flags: None
*/
function hidehudintermission()
{
	level waittill(#"game_ended");
	if(useprophudserver())
	{
		level.elim_hud.alpha = 0;
		if(level.phsettings.propwhistletime > 0)
		{
			level.phwhistletimer.alpha = 0;
			level.whistling.alpha = 0;
		}
	}
	foreach(player in level.players)
	{
		player namespace_4c773ed3::propabilitykeysvisible(0);
	}
}

/*
	Name: onstartgametype
	Namespace: prop
	Checksum: 0x24A9040E
	Offset: 0x1E50
	Size: 0x73C
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
	setclientnamemode("manual_change");
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
	util::setobjectivetext(game["attackers"], &"OBJECTIVES_PH_ATTACKER");
	util::setobjectivetext(game["defenders"], &"OBJECTIVES_PH_DEFENDER");
	util::setobjectivehinttext(game["attackers"], &"OBJECTIVES_PH_ATTACKER_HINT");
	util::setobjectivehinttext(game["defenders"], &"OBJECTIVES_PH_DEFENDER_HINT");
	if(level.splitscreen)
	{
		util::setobjectivescoretext(game["attackers"], &"OBJECTIVES_PH_ATTACKER");
		util::setobjectivescoretext(game["defenders"], &"OBJECTIVES_PH_DEFENDER");
	}
	else
	{
		util::setobjectivescoretext(game["attackers"], &"OBJECTIVES_PH_ATTACKER_SCORE");
		util::setobjectivescoretext(game["defenders"], &"OBJECTIVES_PH_DEFENDER_SCORE");
	}
	foreach(team in level.teams)
	{
		spawnlogic::add_spawn_points(team, "mp_tdm_spawn");
		spawnlogic::place_spawn_points(spawning::gettdmstartspawnname(team));
	}
	spawning::updateallspawnpoints();
	var_1210f0f7 = (game["roundsplayed"] % 4) == 2 || (game["roundsplayed"] % 4) == 3;
	if(var_1210f0f7)
	{
		game["switchedsides"] = !game["switchedsides"];
	}
	level.spawn_start = [];
	foreach(team in level.teams)
	{
		level.spawn_start[team] = spawnlogic::get_spawnpoint_array(spawning::gettdmstartspawnname(team));
	}
	if(var_1210f0f7)
	{
		game["switchedsides"] = !game["switchedsides"];
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
	level._effect["propFlash"] = "explosions/fx_exp_grenade_concussion";
	level._effect["propDeathFX"] = "explosions/fx_prop_exp";
	if(!isdefined(game["propScore"]))
	{
		game["propScore"] = [];
		game["propScore"]["allies"] = 0;
		game["propScore"]["axis"] = 0;
	}
	if(!isdefined(game["propSurvivalTime"]))
	{
		game["propSurvivalTime"] = [];
		game["propSurvivalTime"]["allies"] = 0;
		game["propSurvivalTime"]["axis"] = 0;
	}
	if(!isdefined(game["hunterKillTime"]))
	{
		game["hunterKillTime"] = [];
		game["hunterKillTime"]["allies"] = 0;
		game["hunterKillTime"]["axis"] = 0;
	}
	level flag::init("props_hide_over", 0);
	level thread setuproundstarthud();
	if(level.phsettings.propwhistletime > 0)
	{
		level thread propwhistle();
	}
	level thread hidehudintermission();
	level thread monitortimers();
	level thread setphteamscores();
	level thread stillalivexp();
	level thread function_4bdf92a7();
	level thread tracktimealive();
}

/*
	Name: function_eed17dac
	Namespace: prop
	Checksum: 0x2586AB21
	Offset: 0x2598
	Size: 0x8C
	Parameters: 1
	Flags: None
*/
function function_eed17dac(weapon)
{
	self.primaryweapon = weapon;
	self giveweapon(weapon);
	self switchtoweapon(weapon);
	self setspawnweapon(weapon);
	self.spawnweapon = weapon;
	self setblockweaponpickup(weapon, 1);
}

/*
	Name: function_f6c740a4
	Namespace: prop
	Checksum: 0x10CE3AD2
	Offset: 0x2630
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function function_f6c740a4(weapon)
{
	self.secondaryweapon = weapon;
	self giveweapon(weapon);
	self setblockweaponpickup(weapon, 1);
}

/*
	Name: function_c32f3fcc
	Namespace: prop
	Checksum: 0xD2271022
	Offset: 0x2690
	Size: 0x7C
	Parameters: 2
	Flags: None
*/
function function_c32f3fcc(primaryoffhand, primaryoffhandcount)
{
	self giveweapon(primaryoffhand);
	self setweaponammostock(primaryoffhand, primaryoffhandcount);
	self switchtooffhand(primaryoffhand);
	self.grenadetypeprimary = primaryoffhand;
	self.grenadetypeprimarycount = primaryoffhandcount;
}

/*
	Name: function_5ca26274
	Namespace: prop
	Checksum: 0x1CF56A48
	Offset: 0x2718
	Size: 0x7C
	Parameters: 2
	Flags: None
*/
function function_5ca26274(secondaryoffhand, secondaryoffhandcount)
{
	self giveweapon(secondaryoffhand);
	self setweaponammoclip(secondaryoffhand, secondaryoffhandcount);
	self switchtooffhand(secondaryoffhand);
	self.grenadetypesecondary = secondaryoffhand;
	self.grenadetypesecondarycount = secondaryoffhandcount;
}

/*
	Name: giveperk
	Namespace: prop
	Checksum: 0x8966626E
	Offset: 0x27A0
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function giveperk(perkname)
{
	if(!self hasperk(perkname))
	{
		self setperk(perkname);
	}
}

/*
	Name: givecustomloadout
	Namespace: prop
	Checksum: 0x8A8F4EC5
	Offset: 0x27E8
	Size: 0x3F6
	Parameters: 0
	Flags: None
*/
function givecustomloadout()
{
	loadout::giveloadout_init(1);
	loadout::setclassnum(self.curclass);
	self clearperks();
	weapon = undefined;
	if(self util::isprop())
	{
		weapon = getweapon("pistol_standard");
		self function_eed17dac(weapon);
		self function_c32f3fcc(getweapon("null_offhand_primary"), 0);
		self function_5ca26274(getweapon("null_offhand_secondary"), 0);
		self giveperk("specialty_quieter");
		self giveperk("specialty_fastladderclimb");
		self giveperk("specialty_fastmantle");
		self giveperk("specialty_jetcharger");
	}
	else
	{
		weapon = getweapon("pistol_standard");
		self function_f6c740a4(weapon);
		attachments = array();
		attachments[attachments.size] = "extclip";
		attachments[attachments.size] = "steadyaim";
		weapon = getweapon("smg_standard", attachments);
		self function_eed17dac(weapon);
		if(!function_503c9413())
		{
			self function_c32f3fcc(getweapon("concussion_grenade"), 2);
		}
		else
		{
			self function_c32f3fcc(getweapon("null_offhand_primary"), 0);
		}
		self function_5ca26274(getweapon("null_offhand_secondary"), 0);
		self attackerinitammo();
		self giveperk("specialty_twogrenades");
		self giveperk("specialty_fastladderclimb");
		self giveperk("specialty_fastmantle");
		self giveperk("specialty_longersprint");
		self giveperk("specialty_sprintfire");
		self giveperk("specialty_jetcharger");
	}
	self giveweapon(level.weaponbasemelee);
	self notify(#"hash_5ca37875");
	return weapon;
}

/*
	Name: is_player_gamepad_enabled
	Namespace: prop
	Checksum: 0xCF0C7165
	Offset: 0x2BE8
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function is_player_gamepad_enabled()
{
	return self gamepadusedlast();
}

/*
	Name: whistlestarttimer
	Namespace: prop
	Checksum: 0xE2BC55EB
	Offset: 0x2C10
	Size: 0x64
	Parameters: 1
	Flags: None
*/
function whistlestarttimer(duration)
{
	level notify(#"hash_8e0e8406");
	counttime = int(duration);
	if(counttime >= 0)
	{
		thread whistlestarttimer_internal(counttime);
	}
}

/*
	Name: whistlestarttimer_internal
	Namespace: prop
	Checksum: 0x96C8606
	Offset: 0x2C80
	Size: 0x40
	Parameters: 1
	Flags: None
*/
function whistlestarttimer_internal(counttime)
{
	level endon(#"hash_8e0e8406");
	waittillframeend();
	while(counttime > 0 && !level.gameended)
	{
		counttime--;
		wait(1);
	}
}

/*
	Name: useprophudserver
	Namespace: prop
	Checksum: 0xDEC30F7D
	Offset: 0x2CC8
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function useprophudserver()
{
	/#
		if(getdvarint("", 0) != 0)
		{
			return true;
		}
	#/
	return true;
}

/*
	Name: setuproundstarthud
	Namespace: prop
	Checksum: 0xB96C9259
	Offset: 0x2D08
	Size: 0x4C0
	Parameters: 0
	Flags: None
*/
function setuproundstarthud()
{
	level.phcountdowntimer = hud::createservertimer("default", 1.5);
	level.phcountdowntimer hud::setpoint("CENTER", undefined, 0, 50);
	level.phcountdowntimer.label = &"MP_PH_STARTS_IN";
	level.phcountdowntimer.alpha = 0;
	level.phcountdowntimer.archived = 0;
	level.phcountdowntimer.hidewheninmenu = 1;
	level.phcountdowntimer.sort = 1;
	if(useprophudserver())
	{
		var_62372e41 = 110;
		var_ff475784 = 20;
		if(!level.console)
		{
			var_62372e41 = 125;
			var_ff475784 = 15;
		}
		level.elim_hud = hud::createserverfontstring("default", 1.5);
		level.elim_hud.label = &"MP_PH_ALIVE";
		level.elim_hud setvalue(0);
		level.elim_hud.x = 5;
		level.elim_hud.y = var_62372e41;
		level.elim_hud.alignx = "left";
		level.elim_hud.aligny = "top";
		level.elim_hud.horzalign = "left";
		level.elim_hud.vertalign = "top";
		level.elim_hud.archived = 1;
		level.elim_hud.alpha = 0;
		level.elim_hud.glowalpha = 0;
		level.elim_hud.hidewheninmenu = 0;
		level thread eliminatedhudmonitor();
		if(level.phsettings.propwhistletime > 0)
		{
			level.phwhistletimer = hud::createservertimer("default", 1.5);
			level.phwhistletimer.x = 5;
			level.phwhistletimer.y = var_62372e41 + var_ff475784;
			level.phwhistletimer.alignx = "left";
			level.phwhistletimer.aligny = "top";
			level.phwhistletimer.horzalign = "left";
			level.phwhistletimer.vertalign = "top";
			level.phwhistletimer.label = &"MP_PH_WHISTLE_IN";
			level.phwhistletimer.alpha = 0;
			level.phwhistletimer.archived = 1;
			level.phwhistletimer.hidewheninmenu = 0;
			level.phwhistletimer settimer(120);
			level.whistling = hud::createserverfontstring("default", 1.5);
			level.whistling.label = &"MP_PH_WHISTLING";
			level.whistling.x = 5;
			level.whistling.y = var_62372e41 + var_ff475784;
			level.whistling.alignx = "left";
			level.whistling.aligny = "top";
			level.whistling.horzalign = "left";
			level.whistling.vertalign = "top";
			level.whistling.archived = 1;
			level.whistling.alpha = 0;
			level.whistling.glowalpha = 0.2;
			level.whistling.hidewheninmenu = 0;
		}
	}
}

/*
	Name: eliminatedhudmonitor
	Namespace: prop
	Checksum: 0x1A4126D1
	Offset: 0x31D0
	Size: 0xA8
	Parameters: 0
	Flags: None
*/
function eliminatedhudmonitor()
{
	level endon(#"game_ended");
	while(true)
	{
		props = get_alive_nonspecating_players(game["defenders"]);
		level.elim_hud setvalue(props.size);
		level util::waittill_any("player_spawned", "player_killed", "player_eliminated", "playerCountChanged", "propCountChanged", "playerDisconnected");
	}
}

/*
	Name: get_alive_nonspecating_players
	Namespace: prop
	Checksum: 0x8B99A61E
	Offset: 0x3280
	Size: 0x114
	Parameters: 1
	Flags: None
*/
function get_alive_nonspecating_players(team)
{
	var_184db3e = [];
	foreach(player in level.players)
	{
		if(isdefined(player) && isalive(player) && (!isdefined(player.sessionstate) || player.sessionstate == "playing"))
		{
			if(!isdefined(team) || player.team == team)
			{
				var_184db3e[var_184db3e.size] = player;
			}
		}
	}
	return var_184db3e;
}

/*
	Name: onplayerdisconnect
	Namespace: prop
	Checksum: 0x82F3CD94
	Offset: 0x33A0
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function onplayerdisconnect()
{
	level notify(#"playerdisconnected");
	if(function_503c9413())
	{
		thread function_c021720c(0.05);
	}
}

/*
	Name: function_45c842e9
	Namespace: prop
	Checksum: 0x7C5DD289
	Offset: 0x33E8
	Size: 0x28
	Parameters: 0
	Flags: None
*/
function function_45c842e9()
{
	while(!(isdefined(level.prematch_over) && level.prematch_over))
	{
		wait(0.05);
	}
}

/*
	Name: onspawnplayer
	Namespace: prop
	Checksum: 0x5C053775
	Offset: 0x3418
	Size: 0x35C
	Parameters: 1
	Flags: None
*/
function onspawnplayer(predictedspawn)
{
	self.breathingstoptime = 0;
	if(self util::isprop())
	{
		self.var_292246d3 = undefined;
		if(!isdefined(self.abilityleft))
		{
			self.abilityleft = 0;
		}
		if(!isdefined(self.clonesleft))
		{
			self.clonesleft = 0;
		}
		if(!isdefined(self.pers["ability"]))
		{
			self.pers["ability"] = 0;
		}
		self.currentability = level.abilities[self.pers["ability"]];
		if(useprophudserver())
		{
			self thread namespace_4c773ed3::propcontrolshud();
		}
		self.isangleoffset = 0;
		var_4cfdb40e = int(level.phsettings.propchangecount);
		var_461f13b6 = undefined;
		var_4a6a29c9 = undefined;
		if(isdefined(self.spawnedonce) && isdefined(self.changesleft))
		{
			var_4cfdb40e = self.changesleft;
			var_461f13b6 = self.abilityleft;
			var_4a6a29c9 = self.clonesleft;
		}
		self namespace_4c773ed3::propsetchangesleft(var_4cfdb40e);
		self namespace_4c773ed3::setnewabilitycount(self.currentability, var_461f13b6);
		self namespace_4c773ed3::setnewabilitycount("CLONE", var_4a6a29c9);
		self thread namespace_4c773ed3::cleanuppropcontrolshudondeath();
		self thread handleprop();
	}
	else
	{
		self.abilityleft = undefined;
		self.clonesleft = undefined;
		if(!isdefined(self.var_292246d3))
		{
			self.var_292246d3 = 0;
		}
		if(!isdefined(self.thrownspecialcount))
		{
			self.thrownspecialcount = 0;
		}
		if(useprophudserver())
		{
			self thread namespace_4c773ed3::function_bf45ce54();
		}
		var_292246d3 = level.phsettings.var_60a20fdc;
		if(isdefined(self.spawnedonce) && isdefined(self.var_292246d3))
		{
			var_292246d3 = self.var_292246d3;
		}
		self namespace_4c773ed3::function_afeda2bf(var_292246d3);
		self thread namespace_4c773ed3::function_227409a5();
		self thread function_346bdc3b();
	}
	self thread attackerswaittime();
	if(level.usestartspawns && !level.ingraceperiod && !level.playerqueuedrespawn)
	{
		level.usestartspawns = 0;
	}
	self.spawnedonce = 1;
	spawning::onspawnplayer(predictedspawn);
}

/*
	Name: monitortimers
	Namespace: prop
	Checksum: 0x4391EBD5
	Offset: 0x3780
	Size: 0x2A4
	Parameters: 0
	Flags: None
*/
function monitortimers()
{
	level endon(#"game_ended");
	function_45c842e9();
	level.allow_teamchange = "0";
	foreach(player in level.players)
	{
		player.hasdonecombat = 1;
	}
	level thread function_cdee7177();
	if(level.phsettings.prophidetime > 0)
	{
		level.phcountdowntimer settimer(level.phsettings.prophidetime);
		level.phcountdowntimer.alpha = 1;
	}
	if(useprophudserver() && level.phsettings.propwhistletime > 0)
	{
		level.phwhistletimer settimer(level.phsettings.propwhistletime + level.phsettings.prophidetime);
	}
	if(level.phsettings.prophidetime > 0 || level.phsettings.propwhistletime > 0)
	{
		whistlestarttimer(level.phsettings.propwhistletime + level.phsettings.prophidetime);
	}
	if(level.phsettings.prophidetime > 0)
	{
		function_da184fd(level.phsettings.prophidetime);
	}
	level flag::set("props_hide_over");
	if(useprophudserver())
	{
		if(level.phsettings.propwhistletime > 0)
		{
			level.phwhistletimer.alpha = 1;
		}
		level.elim_hud.alpha = 1;
	}
	level.phcountdowntimer.alpha = 0;
}

/*
	Name: function_cdee7177
	Namespace: prop
	Checksum: 0x2E075C78
	Offset: 0x3A30
	Size: 0x240
	Parameters: 0
	Flags: None
*/
function function_cdee7177()
{
	level endon(#"game_ended");
	level endon(#"props_hide_over");
	var_8cbf9eb6 = int(level.phsettings.prophidetime + (gettime() / 1000));
	totaltimepassed = 0;
	while(true)
	{
		level waittill(#"host_migration_begin");
		level.phcountdowntimer.alpha = 0;
		if(useprophudserver() && level.phsettings.propwhistletime > 0)
		{
			level.phwhistletimer.alpha = 0;
		}
		timepassed = int(hostmigration::waittillhostmigrationdone() / 1000);
		totaltimepassed = totaltimepassed + timepassed;
		timepassed = totaltimepassed;
		var_c1ce6993 = (var_8cbf9eb6 + timepassed) - (int(gettime() / 1000));
		level.phcountdowntimer settimer(var_c1ce6993);
		if(useprophudserver() && level.phsettings.propwhistletime > 0)
		{
			level.phwhistletimer settimer(level.phsettings.propwhistletime + var_c1ce6993);
		}
		whistlestarttimer(level.phsettings.propwhistletime + var_c1ce6993);
		level.phcountdowntimer.alpha = 1;
		if(useprophudserver() && level.phsettings.propwhistletime > 0)
		{
			level.phwhistletimer.alpha = 1;
		}
	}
}

/*
	Name: handleprop
	Namespace: prop
	Checksum: 0xE45D0321
	Offset: 0x3C78
	Size: 0x244
	Parameters: 0
	Flags: None
*/
function handleprop()
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	self endon(#"death");
	self waittill(#"hash_5ca37875");
	self allowprone(0);
	self allowcrouch(0);
	self allowsprint(0);
	self allowslide(0);
	self setmovespeedscale(level.phsettings.propspeedscale);
	self playerknockback(0);
	self takeallweapons();
	self allowspectateteam(game["attackers"], 1);
	self ghost();
	self setclientuivisibilityflag("weapon_hud_visible", 0);
	self.healthregendisabled = 1;
	self.concussionimmune = undefined;
	/#
		assert(!isdefined(self.prop));
	#/
	self thread setupprop();
	self thread namespace_4c773ed3::setupkeybindings();
	self thread setupdamage();
	self thread namespace_4c773ed3::propinputwatch();
	self thread propwatchdeath();
	self thread propwatchcleanupondisconnect();
	self thread propwatchcleanuponroundend();
	self thread propwatchprematchsettings();
}

/*
	Name: getthirdpersonrangeforsize
	Namespace: prop
	Checksum: 0xCA4E0F
	Offset: 0x3EC8
	Size: 0x9A
	Parameters: 1
	Flags: None
*/
function getthirdpersonrangeforsize(propsize)
{
	switch(propsize)
	{
		case 50:
		{
			return 120;
		}
		case 100:
		{
			return 150;
		}
		case 250:
		{
			return 180;
		}
		case 450:
		{
			return 260;
		}
		case 550:
		{
			return 320;
		}
		default:
		{
			/#
				assertmsg("" + propsize);
			#/
			break;
		}
	}
	return 120;
}

/*
	Name: getthirdpersonheightoffsetforsize
	Namespace: prop
	Checksum: 0x27DFC3C5
	Offset: 0x3F70
	Size: 0x90
	Parameters: 1
	Flags: None
*/
function getthirdpersonheightoffsetforsize(propsize)
{
	switch(propsize)
	{
		case 50:
		{
			return -30;
		}
		case 100:
		{
			return -20;
		}
		case 250:
		{
			return 0;
		}
		case 450:
		{
			return 20;
		}
		case 550:
		{
			return 40;
		}
		default:
		{
			/#
				assertmsg("" + propsize);
			#/
			break;
		}
	}
	return 0;
}

/*
	Name: applyxyzoffset
	Namespace: prop
	Checksum: 0x25ECC0D4
	Offset: 0x4008
	Size: 0x16C
	Parameters: 0
	Flags: None
*/
function applyxyzoffset()
{
	if(!isdefined(self.prop.xyzoffset))
	{
		return;
	}
	self.prop.angles = self.angles;
	forward = anglestoforward(self.prop.angles) * self.prop.xyzoffset[0];
	right = anglestoright(self.prop.angles) * self.prop.xyzoffset[1];
	up = anglestoup(self.prop.angles) * self.prop.xyzoffset[2];
	self.prop.origin = self.prop.origin + forward;
	self.prop.origin = self.prop.origin + right;
	self.prop.origin = self.prop.origin + up;
}

/*
	Name: applyanglesoffset
	Namespace: prop
	Checksum: 0xA9D99AB1
	Offset: 0x4180
	Size: 0x70
	Parameters: 0
	Flags: None
*/
function applyanglesoffset()
{
	if(!isdefined(self.prop.anglesoffset))
	{
		return;
	}
	self.prop.angles = self.angles;
	self.prop.angles = self.prop.angles + self.prop.anglesoffset;
	self.isangleoffset = 1;
}

/*
	Name: propwhistle
	Namespace: prop
	Checksum: 0x661124D9
	Offset: 0x41F8
	Size: 0x510
	Parameters: 0
	Flags: None
*/
function propwhistle()
{
	level endon(#"game_ended");
	function_45c842e9();
	time = gettime();
	var_33840fb2 = level.phsettings.propwhistletime * 1000;
	var_d97f029 = 20000;
	var_7335da26 = var_d97f029;
	var_defcb34f = 500;
	var_c3f83285 = 5000;
	var_2812d72a = 0;
	var_1bb1b603 = (0, 0, 0);
	var_170a102c = getentarray("minimap_corner", "targetname");
	if(var_170a102c.size > 0)
	{
		var_1bb1b603 = var_170a102c[0].origin;
	}
	hostmigration::waitlongdurationwithhostmigrationpause(level.phsettings.prophidetime + level.phsettings.propwhistletime);
	while(true)
	{
		if(((time + var_33840fb2) - var_defcb34f) < gettime())
		{
			var_2812d72a++;
			if(useprophudserver())
			{
				level.phwhistletimer.alpha = 0;
				level.whistling.alpha = 1;
				level.whistling fadeovertime(0.75);
				level.whistling.alpha = 0.6;
			}
			var_6b6cd2fc = arraysortclosest(level.players, var_1bb1b603);
			foreach(player in var_6b6cd2fc)
			{
				if(!isdefined(player))
				{
					continue;
				}
				if(player util::isprop() && isalive(player))
				{
					playsoundatposition("mpl_phunt_char_whistle", player.origin + vectorscale((0, 0, 1), 60));
					hostmigration::waitlongdurationwithhostmigrationpause(1.5);
				}
			}
			time = gettime();
			if((var_2812d72a % 2) == 0)
			{
				var_33840fb2 = max(var_33840fb2 - 5000, var_d97f029);
			}
			if(var_7335da26 >= (globallogic_utils::gettimeremaining() - var_c3f83285))
			{
				if(useprophudserver())
				{
					level.whistling.alpha = 0;
				}
				return;
			}
			if((var_7335da26 * 2) + (getteamplayersalive(game["defenders"]) * 2500) >= (globallogic_utils::gettimeremaining() - var_c3f83285))
			{
				if(useprophudserver())
				{
					level.phwhistletimer.label = &"MP_PH_FINAL_WHISTLE";
				}
				var_7335da26 = var_7335da26 + (getteamplayersalive(game["defenders"]) * 2500);
			}
			if(useprophudserver())
			{
				level.phwhistletimer settimer(int(var_33840fb2 / 1000));
			}
			whistlestarttimer(int(var_33840fb2 / 1000));
			if(useprophudserver())
			{
				level.whistling.alpha = 0;
				level.phwhistletimer.alpha = 1;
			}
		}
		hostmigration::waitlongdurationwithhostmigrationpause(0.5);
	}
}

/*
	Name: getlivingplayersonteam
	Namespace: prop
	Checksum: 0x8B04ABF0
	Offset: 0x4710
	Size: 0xE8
	Parameters: 1
	Flags: None
*/
function getlivingplayersonteam(team)
{
	players = [];
	foreach(player in level.players)
	{
		if(!isdefined(player.team))
		{
			continue;
		}
		if(isalive(player) && player.team == team)
		{
			players[players.size] = player;
		}
	}
	return players;
}

/*
	Name: setupdamage
	Namespace: prop
	Checksum: 0x362C1B42
	Offset: 0x4800
	Size: 0x94
	Parameters: 0
	Flags: None
*/
function setupdamage()
{
	level endon(#"game_ended");
	self endon(#"death");
	self endon(#"disconnect");
	hostmigration::waitlongdurationwithhostmigrationpause(0.5);
	self.prop.health = 99999;
	self.prop.maxhealth = 99999;
	self.prop thread function_500dc7d9(&damagewatch);
}

/*
	Name: function_500dc7d9
	Namespace: prop
	Checksum: 0xFFBAC6F4
	Offset: 0x48A0
	Size: 0xEA
	Parameters: 1
	Flags: None
*/
function function_500dc7d9(damagecallback)
{
	level endon(#"game_ended");
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage", damage, attacker, direction_vec, point, meansofdeath, modelname, tagname, partname, weapon, idflags);
		self thread [[damagecallback]](damage, attacker, direction_vec, point, meansofdeath, modelname, tagname, partname, weapon, idflags);
	}
}

/*
	Name: damagewatch
	Namespace: prop
	Checksum: 0xEA1DFA14
	Offset: 0x4998
	Size: 0x1A4
	Parameters: 10
	Flags: None
*/
function damagewatch(damage, attacker, direction_vec, point, meansofdeath, modelname, tagname, partname, weapon, idflags)
{
	if(!isdefined(attacker))
	{
		return;
	}
	if(!isdefined(self.owner))
	{
		return;
	}
	if(isplayer(attacker))
	{
		if(attacker.pers["team"] == self.owner.pers["team"])
		{
			return;
		}
		attacker thread damagefeedback::update();
		if(isdefined(weapon) && weapon.rootweapon.name == "concussion_grenade" && isdefined(meansofdeath) && meansofdeath != "MOD_IMPACT")
		{
			namespace_4c773ed3::function_770b4cfa(attacker, undefined, meansofdeath, damage, point, weapon);
		}
	}
	self.owner dodamage(damage, point, attacker, attacker, "none", meansofdeath, idflags, weapon);
	self.health = 99999;
	self.maxhealth = 99999;
}

/*
	Name: propcleanup
	Namespace: prop
	Checksum: 0xE0078065
	Offset: 0x4B48
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function propcleanup()
{
	array = array(self.prop, self.propanchor, self.propent);
	self thread propcleanupdelayed(array);
}

/*
	Name: propcleanupdelayed
	Namespace: prop
	Checksum: 0xCBECFA76
	Offset: 0x4BA8
	Size: 0x12A
	Parameters: 1
	Flags: None
*/
function propcleanupdelayed(propents)
{
	foreach(prop in propents)
	{
		if(isdefined(prop))
		{
			prop unlink();
		}
	}
	wait(0.05);
	foreach(prop in propents)
	{
		if(isdefined(prop))
		{
			prop delete();
		}
	}
}

/*
	Name: propwatchdeath
	Namespace: prop
	Checksum: 0x2E066590
	Offset: 0x4CE0
	Size: 0xF4
	Parameters: 0
	Flags: None
*/
function propwatchdeath()
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	self waittill(#"death");
	corpse = self.body;
	playsoundatposition("wpn_flash_grenade_explode", self.prop.origin + vectorscale((0, 0, 1), 4));
	playfx(fx::get("propDeathFX"), self.prop.origin + vectorscale((0, 0, 1), 4));
	if(isdefined(corpse))
	{
		corpse delete();
	}
	self propcleanup();
}

/*
	Name: propwatchcleanupondisconnect
	Namespace: prop
	Checksum: 0x68A2A40
	Offset: 0x4DE0
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function propwatchcleanupondisconnect()
{
	self notify(#"propwatchcleanupondisconnect");
	self endon(#"propwatchcleanupondisconnect");
	level endon(#"game_ended");
	self waittill(#"disconnect");
	self propcleanup();
	self propclonecleanup();
}

/*
	Name: propwatchcleanuponroundend
	Namespace: prop
	Checksum: 0xF7517C8E
	Offset: 0x4E50
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function propwatchcleanuponroundend()
{
	self notify(#"hash_739978c9");
	self endon(#"hash_739978c9");
	self endon(#"disconnect");
	level waittill(#"round_end_done");
	self propcleanup();
	self propclonecleanup();
}

/*
	Name: propclonecleanup
	Namespace: prop
	Checksum: 0x1EDAC8E7
	Offset: 0x4EC0
	Size: 0xA2
	Parameters: 0
	Flags: None
*/
function propclonecleanup()
{
	if(isdefined(self.propclones))
	{
		foreach(clone in self.propclones)
		{
			if(isdefined(clone))
			{
				clone delete();
			}
		}
	}
}

/*
	Name: propwatchprematchsettings
	Namespace: prop
	Checksum: 0x85A6B66D
	Offset: 0x4F70
	Size: 0x8C
	Parameters: 0
	Flags: None
*/
function propwatchprematchsettings()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"joined_team");
	self endon(#"joined_spectators");
	function_45c842e9();
	self allowprone(0);
	self allowcrouch(0);
	self allowsprint(0);
}

/*
	Name: organizeproplist
	Namespace: prop
	Checksum: 0x2F9A7EF5
	Offset: 0x5008
	Size: 0x22
	Parameters: 1
	Flags: None
*/
function organizeproplist(var_8f686d4b)
{
	return array::randomize(var_8f686d4b);
}

/*
	Name: randgetpropsizetoallocate
	Namespace: prop
	Checksum: 0xCBA70919
	Offset: 0x5038
	Size: 0x194
	Parameters: 0
	Flags: None
*/
function randgetpropsizetoallocate()
{
	var_77353f29 = 10 * isdefined(level.proplist[50]);
	var_9c7a2639 = 30 * isdefined(level.proplist[100]);
	var_ce32b3a9 = 40 * isdefined(level.proplist[250]);
	var_9e5e7c71 = 20 * isdefined(level.proplist[450]);
	var_ff0ae5a1 = 10 * isdefined(level.proplist[550]);
	randomrange = (((var_77353f29 + var_9c7a2639) + var_ce32b3a9) + var_9e5e7c71) + var_ff0ae5a1;
	randomval = randomint(randomrange);
	if(randomval < var_77353f29)
	{
		return 50;
	}
	randomval = randomval - var_77353f29;
	if(randomval < var_9c7a2639)
	{
		return 100;
	}
	randomval = randomval - var_9c7a2639;
	if(randomval < var_ce32b3a9)
	{
		return 250;
	}
	randomval = randomval - var_ce32b3a9;
	if(randomval < var_9e5e7c71)
	{
		return 450;
	}
	randomval = randomval - var_9e5e7c71;
	return 550;
}

/*
	Name: getnextprop
	Namespace: prop
	Checksum: 0xE4C7660C
	Offset: 0x51D8
	Size: 0x2AE
	Parameters: 1
	Flags: None
*/
function getnextprop(var_bc9de76b)
{
	var_951c47b8 = randgetpropsizetoallocate();
	var_5ed17249 = getarraykeys(level.proplist);
	var_5ed17249 = array::randomize(var_5ed17249);
	var_fb988098 = array(var_951c47b8);
	foreach(size in var_5ed17249)
	{
		if(size != var_951c47b8)
		{
			var_fb988098[var_fb988098.size] = size;
		}
	}
	prop = undefined;
	for(i = 0; i < var_fb988098.size; i++)
	{
		size = var_fb988098[i];
		if(!isdefined(level.proplist[size]) || !level.proplist[size].size)
		{
			continue;
		}
		var_ecfadf1a = array::randomize(level.proplist[size]);
		for(j = 0; j < var_ecfadf1a.size; j++)
		{
			prop = var_ecfadf1a[j];
			var_c8c6579 = 0;
			if(isdefined(var_bc9de76b.usedprops) && var_bc9de76b.usedprops.size)
			{
				for(index = 0; index < var_bc9de76b.usedprops.size; index++)
				{
					if(prop.modelname == var_bc9de76b.usedprops[index].modelname)
					{
						var_c8c6579 = 1;
						break;
					}
				}
			}
			if(!var_c8c6579)
			{
				return prop;
			}
		}
	}
	return prop;
}

/*
	Name: getmapname
	Namespace: prop
	Checksum: 0x4E2AB164
	Offset: 0x5490
	Size: 0xA
	Parameters: 0
	Flags: None
*/
function getmapname()
{
	return level.script;
}

/*
	Name: tablelookupbyrow
	Namespace: prop
	Checksum: 0x2957C57B
	Offset: 0x54A8
	Size: 0x62
	Parameters: 3
	Flags: None
*/
function tablelookupbyrow(var_8c6b47e7, rowindex, columnindex)
{
	columns = tablelookuprow(var_8c6b47e7, rowindex);
	if(columnindex < columns.size)
	{
		return columns[columnindex];
	}
	return "";
}

/*
	Name: populateproplist
	Namespace: prop
	Checksum: 0x215CDA39
	Offset: 0x5518
	Size: 0x52C
	Parameters: 0
	Flags: None
*/
function populateproplist()
{
	mapname = getmapname();
	var_8c6b47e7 = (("gamedata/tables/mp/") + mapname) + "_ph.csv";
	var_f89cb9d0 = tablelookuprowcount(var_8c6b47e7);
	for(rowindex = 0; rowindex < var_f89cb9d0; rowindex++)
	{
		modelname = tablelookupbyrow(var_8c6b47e7, rowindex, 0);
		propsizetext = tablelookupbyrow(var_8c6b47e7, rowindex, 1);
		var_bbac36c8 = float(tablelookupbyrow(var_8c6b47e7, rowindex, 2));
		offsetx = int(tablelookupbyrow(var_8c6b47e7, rowindex, 3));
		offsety = int(tablelookupbyrow(var_8c6b47e7, rowindex, 4));
		offsetz = int(tablelookupbyrow(var_8c6b47e7, rowindex, 5));
		var_e936d5f1 = int(tablelookupbyrow(var_8c6b47e7, rowindex, 6));
		rotationy = int(tablelookupbyrow(var_8c6b47e7, rowindex, 7));
		var_353bcac3 = int(tablelookupbyrow(var_8c6b47e7, rowindex, 8));
		propheight = tablelookupbyrow(var_8c6b47e7, rowindex, 9);
		proprange = tablelookupbyrow(var_8c6b47e7, rowindex, 10);
		offset = undefined;
		if(isdefined(offsetx) && isdefined(offsety) && isdefined(offsetz))
		{
			offset = (offsetx, offsety, offsetz);
		}
		rotation = undefined;
		if(isdefined(var_e936d5f1) && isdefined(rotationy) && isdefined(var_353bcac3))
		{
			rotation = (var_e936d5f1, rotationy, var_353bcac3);
		}
		if(!isdefined(var_bbac36c8) || var_bbac36c8 == 0)
		{
			var_bbac36c8 = 1;
		}
		propsize = getpropsize(propsizetext);
		if(!isdefined(propheight) || propheight == "")
		{
			propheight = getthirdpersonheightoffsetforsize(propsize);
		}
		else
		{
			propheight = int(propheight);
		}
		if(!isdefined(proprange) || proprange == "")
		{
			proprange = getthirdpersonrangeforsize(propsize);
		}
		else
		{
			proprange = int(proprange);
		}
		addproptolist(modelname, propsize, offset, rotation, propsizetext, var_bbac36c8, propheight, proprange);
	}
	if(var_f89cb9d0 == 0)
	{
		addproptolist("tag_origin", 250, (0, 0, 0), (0, 0, 0), "medium", 1, getthirdpersonheightoffsetforsize(250), getthirdpersonrangeforsize(250));
	}
	level.proplist = organizeproplist(level.proplist);
}

/*
	Name: setupprop
	Namespace: prop
	Checksum: 0x60986DB1
	Offset: 0x5A50
	Size: 0x514
	Parameters: 0
	Flags: None
*/
function setupprop()
{
	self notsolid();
	if(!isdefined(level.phsettings.var_8f9d0c7c) || level.phsettings.var_8f9d0c7c == 0)
	{
		level.phsettings.var_8f9d0c7c = self setcontents(0);
	}
	else
	{
		self setcontents(0);
	}
	self setplayercollision(0);
	propinfo = self.propinfo;
	if(!isdefined(self.propinfo))
	{
		propinfo = getnextprop(self);
	}
	self.propanchor = spawn("script_model", self.origin);
	self.propanchor.targetname = "propAnchor";
	self.propanchor linkto(self);
	self.propanchor setcontents(0);
	self.propanchor notsolid();
	self.propanchor setplayercollision(0);
	self.propent = spawn("script_model", self.origin);
	self.propent.targetname = "propEnt";
	self.propent linkto(self.propanchor);
	self.propent setcontents(0);
	self.propent notsolid();
	self.propent setplayercollision(0);
	self.prop = spawn("script_model", self.propent.origin);
	self.prop.targetname = "prop";
	self.prop setmodel(propinfo.modelname);
	self.prop setscale(propinfo.var_bbac36c8, 1);
	self.prop setcandamage(1);
	self.prop setowner(self);
	self.prop setteam(self.team);
	self.prop.xyzoffset = propinfo.xyzoffset;
	self.prop.anglesoffset = propinfo.anglesoffset;
	self applyxyzoffset();
	self applyanglesoffset();
	self.prop linkto(self.propent);
	self.prop.owner = self;
	self.prop.health = 10000;
	self.prop setplayercollision(0);
	self.prop notsolidcapsule();
	self.prop clientfield::set("enemyequip", 1);
	if(function_503c9413())
	{
		self thread function_f2704a3c(0);
	}
	self.thirdpersonrange = propinfo.proprange;
	self.thirdpersonheightoffset = propinfo.propheight;
	self setclientthirdperson(1, self.thirdpersonrange, self.thirdpersonheightoffset);
	self.prop.info = propinfo;
	self.propinfo = propinfo;
	if(!isdefined(self.spawnedonce))
	{
		self.usedprops = [];
	}
	self.health = getprophealth(propinfo);
	self.maxhealth = self.health;
}

/*
	Name: getprophealth
	Namespace: prop
	Checksum: 0x2101F25
	Offset: 0x5F70
	Size: 0x2A
	Parameters: 1
	Flags: None
*/
function getprophealth(propinfo)
{
	return int(propinfo.propsize);
}

/*
	Name: getpropsize
	Namespace: prop
	Checksum: 0xF2A22353
	Offset: 0x5FA8
	Size: 0x146
	Parameters: 1
	Flags: None
*/
function getpropsize(propsizetext)
{
	/#
		if(propsizetext == "")
		{
			return 0;
		}
	#/
	propsize = 0;
	switch(propsizetext)
	{
		case "xsmall":
		{
			propsize = 50;
			break;
		}
		case "small":
		{
			propsize = 100;
			break;
		}
		case "medium":
		{
			propsize = 250;
			break;
		}
		case "large":
		{
			propsize = 450;
			break;
		}
		case "xlarge":
		{
			propsize = 550;
			break;
		}
		default:
		{
			mapname = getmapname();
			var_8c6b47e7 = (("gamedata/tables/mp/") + mapname) + "_ph.csv";
			/#
				assertmsg(((("" + propsizetext) + "") + var_8c6b47e7) + "");
			#/
			propsize = 100;
			break;
		}
	}
	return propsize;
}

/*
	Name: addproptolist
	Namespace: prop
	Checksum: 0xBD9EFEB1
	Offset: 0x60F8
	Size: 0x1F8
	Parameters: 8
	Flags: None
*/
function addproptolist(modelname, propsize, xyzoffset, anglesoffset, propsizetext, var_bbac36c8, propheight, proprange)
{
	if(!isdefined(level.proplist))
	{
		level.proplist = [];
	}
	if(!isdefined(level.propindex))
	{
		level.propindex = [];
	}
	if(!isdefined(level.proplist[propsize]))
	{
		level.proplist[propsize] = [];
	}
	propinfo = spawnstruct();
	propinfo.modelname = modelname;
	propinfo.var_bbac36c8 = var_bbac36c8;
	propinfo.propsize = int(propsize);
	propinfo.propsizetext = propsizetext;
	if(isdefined(xyzoffset))
	{
		propinfo.xyzoffset = xyzoffset;
	}
	if(isdefined(anglesoffset))
	{
		propinfo.anglesoffset = anglesoffset;
	}
	propinfo.proprange = proprange;
	propinfo.propheight = propheight;
	index = level.propindex.size;
	level.propindex[index] = [];
	level.propindex[index][0] = propsize;
	level.propindex[index][1] = level.proplist[propsize].size;
	level.proplist[propsize][level.proplist[propsize].size] = propinfo;
}

/*
	Name: ph_endgame
	Namespace: prop
	Checksum: 0x6FDE2C98
	Offset: 0x62F8
	Size: 0x7C
	Parameters: 2
	Flags: None
*/
function ph_endgame(winningteam, endreasontext)
{
	if(isdefined(level.endingph) && level.endingph)
	{
		return;
	}
	level.endingph = 1;
	ph_setfinalkillcamwinner(winningteam);
	thread globallogic::endgame(winningteam, endreasontext);
	level thread givephteamscore(winningteam);
}

/*
	Name: ph_setfinalkillcamwinner
	Namespace: prop
	Checksum: 0xF0BB828C
	Offset: 0x6380
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function ph_setfinalkillcamwinner(winningteam)
{
	level.finalkillcam_winner = winningteam;
	if(level.finalkillcam_winner == game["defenders"])
	{
		level.var_fb8e299e = 1;
	}
}

/*
	Name: givephteamscore
	Namespace: prop
	Checksum: 0xC954610A
	Offset: 0x63C8
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function givephteamscore(team)
{
	level endon(#"game_ended");
	var_a307eca2 = 0;
	if(isdefined(game["roundswon"]))
	{
		var_a307eca2 = game["roundswon"][team];
	}
	setteamscore(team, var_a307eca2);
}

/*
	Name: setphteamscores
	Namespace: prop
	Checksum: 0xF0CF6065
	Offset: 0x6440
	Size: 0xBC
	Parameters: 0
	Flags: None
*/
function setphteamscores()
{
	level endon(#"game_ended");
	var_aa6bd9ef = 0;
	var_c586b70f = 0;
	if(isdefined(game["roundswon"]))
	{
		var_c586b70f = game["roundswon"][game["defenders"]];
		var_aa6bd9ef = game["roundswon"][game["attackers"]];
	}
	setteamscore(game["defenders"], var_c586b70f);
	setteamscore(game["attackers"], var_aa6bd9ef);
}

/*
	Name: ononeleftevent
	Namespace: prop
	Checksum: 0xE33482D2
	Offset: 0x6508
	Size: 0x154
	Parameters: 1
	Flags: None
*/
function ononeleftevent(team)
{
	if(isdefined(level.gameended) && level.gameended)
	{
		return;
	}
	if(team == game["attackers"])
	{
		return;
	}
	lastplayer = undefined;
	foreach(player in level.players)
	{
		if(isdefined(team) && player.team != team)
		{
			continue;
		}
		if(!isalive(player) && !player globallogic_spawn::mayspawn())
		{
			continue;
		}
		if(isdefined(lastplayer))
		{
			return;
		}
		lastplayer = player;
	}
	if(!isdefined(lastplayer))
	{
		return;
	}
	lastplayer thread givelastonteamwarning();
}

/*
	Name: waittillrecoveredhealth
	Namespace: prop
	Checksum: 0xED7AD3C7
	Offset: 0x6668
	Size: 0xCE
	Parameters: 2
	Flags: None
*/
function waittillrecoveredhealth(time, interval)
{
	self endon(#"death");
	self endon(#"disconnect");
	fullhealthtime = 0;
	if(!isdefined(interval))
	{
		interval = 0.05;
	}
	if(!isdefined(time))
	{
		time = 0;
	}
	while(true)
	{
		if(self.health != self.maxhealth)
		{
			fullhealthtime = 0;
		}
		else
		{
			fullhealthtime = fullhealthtime + interval;
		}
		wait(interval);
		if(self.health == self.maxhealth && fullhealthtime >= time)
		{
			break;
		}
	}
}

/*
	Name: givelastonteamwarning
	Namespace: prop
	Checksum: 0xB691D282
	Offset: 0x6740
	Size: 0x9E
	Parameters: 0
	Flags: None
*/
function givelastonteamwarning()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	self waittillrecoveredhealth(3);
	level thread function_435d5169(&"SCORE_LAST_ALIVE", self);
	if(self util::isprop())
	{
		level notify(#"hash_2cd007a4");
		level.nopropsspectate = 1;
	}
	level notify(#"last_alive", self);
}

/*
	Name: function_435d5169
	Namespace: prop
	Checksum: 0x6AF17534
	Offset: 0x67E8
	Size: 0x44
	Parameters: 2
	Flags: None
*/
function function_435d5169(var_eb4caf58, var_852860b4)
{
	luinotifyevent(&"player_callout", 2, var_eb4caf58, var_852860b4.entnum);
}

/*
	Name: ontimelimit
	Namespace: prop
	Checksum: 0x486DD509
	Offset: 0x6838
	Size: 0x6C
	Parameters: 0
	Flags: None
*/
function ontimelimit()
{
	if(!(isdefined(level.gameending) && level.gameending))
	{
		function_f666ecbf();
		choosefinalkillcam();
		ph_endgame(game["defenders"], game["strings"]["time_limit_reached"]);
	}
}

/*
	Name: function_f666ecbf
	Namespace: prop
	Checksum: 0xA5B11995
	Offset: 0x68B0
	Size: 0xF6
	Parameters: 0
	Flags: None
*/
function function_f666ecbf()
{
	var_de5f82e0 = (globallogic_defaults::default_gettimelimit() * 60) * 1000;
	timepassed = globallogic_utils::gettimepassed();
	var_fca3efa4 = int(min(var_de5f82e0, timepassed));
	game["propSurvivalTime"][game["defenders"]] = game["propSurvivalTime"][game["defenders"]] + var_fca3efa4;
	game["hunterKillTime"][game["attackers"]] = game["hunterKillTime"][game["attackers"]] + var_fca3efa4;
}

/*
	Name: choosefinalkillcam
	Namespace: prop
	Checksum: 0x3D5FEF46
	Offset: 0x69B0
	Size: 0x1BC
	Parameters: 0
	Flags: None
*/
function choosefinalkillcam()
{
	var_fdf4a4ec = getlivingplayersonteam(game["defenders"]);
	if(var_fdf4a4ec.size < 1)
	{
		return;
	}
	var_94ffcd5f = getlivingplayersonteam(game["attackers"]);
	if(var_94ffcd5f.size < 1)
	{
		return;
	}
	var_81790aa5 = choosebestpropforkillcam(var_fdf4a4ec, var_94ffcd5f);
	if(isplayer(var_81790aa5))
	{
		attackernum = var_81790aa5 getentitynumber();
	}
	else
	{
		attackernum = -1;
	}
	victim = var_94ffcd5f[0];
	victim.deathtime = gettime() - 1000;
	weap = getweapon("none");
	killcam_entity_info = killcam::get_killcam_entity_info(var_81790aa5, var_81790aa5, weap);
	level thread killcam::record_settings(attackernum, victim getentitynumber(), weap, "MOD_UNKNOWN", victim.deathtime, 0, 0, killcam_entity_info, [], [], var_81790aa5);
}

/*
	Name: choosebestpropforkillcam
	Namespace: prop
	Checksum: 0xB373EF88
	Offset: 0x6B78
	Size: 0x244
	Parameters: 2
	Flags: None
*/
function choosebestpropforkillcam(var_fdf4a4ec, var_94ffcd5f)
{
	var_b3b19664 = undefined;
	var_fd00913d = 1073741824;
	foreach(prop in var_fdf4a4ec)
	{
		/#
			assert(isalive(prop));
		#/
		var_7e7ea558 = undefined;
		var_d939e4ca = 1073741824;
		foreach(hunter in var_94ffcd5f)
		{
			pathdist = pathdistance(prop.origin, hunter.origin);
			if(!isdefined(pathdist))
			{
				pathdist = distance(prop.origin, hunter.origin);
			}
			if(pathdist < var_d939e4ca)
			{
				var_d939e4ca = pathdist;
				var_7e7ea558 = hunter;
			}
		}
		if(var_d939e4ca < var_fd00913d)
		{
			var_fd00913d = var_d939e4ca;
			var_b3b19664 = prop;
		}
	}
	if(!isdefined(var_b3b19664))
	{
		var_b3b19664 = array::random(var_fdf4a4ec);
	}
	return var_b3b19664;
}

/*
	Name: function_cd929fef
	Namespace: prop
	Checksum: 0x3C243927
	Offset: 0x6DC8
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function function_cd929fef(setclientfield)
{
	self show();
	self notify(#"hash_fe365ac1");
	if(setclientfield)
	{
		self clientfield::set("hideTeamPlayer", 0);
	}
}

/*
	Name: function_945f1c41
	Namespace: prop
	Checksum: 0xE533BE2A
	Offset: 0x6E30
	Size: 0xF4
	Parameters: 2
	Flags: None
*/
function function_945f1c41(team, setclientfield)
{
	self hide();
	if(setclientfield)
	{
		self thread function_c2dcc15d(team);
	}
	foreach(player in level.players)
	{
		self thread function_cb3d2d31(player, team);
	}
	self thread function_a8e0199(team);
}

/*
	Name: function_c2dcc15d
	Namespace: prop
	Checksum: 0x5C4DC50A
	Offset: 0x6F30
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function function_c2dcc15d(team)
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	self endon(#"hash_fe365ac1");
	wait(0.05);
	var_1c61204d = 1;
	if(team == "axis")
	{
		var_1c61204d = 2;
	}
	self clientfield::set("hideTeamPlayer", var_1c61204d);
}

/*
	Name: function_a8e0199
	Namespace: prop
	Checksum: 0x973A99EF
	Offset: 0x6FC0
	Size: 0x70
	Parameters: 1
	Flags: None
*/
function function_a8e0199(team)
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	self endon(#"hash_fe365ac1");
	while(true)
	{
		level waittill(#"connected", player);
		self thread function_cb3d2d31(player, team);
	}
}

/*
	Name: function_cb3d2d31
	Namespace: prop
	Checksum: 0xABC16FAB
	Offset: 0x7038
	Size: 0xE6
	Parameters: 2
	Flags: None
*/
function function_cb3d2d31(player, team)
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	self endon(#"hash_fe365ac1");
	player endon(#"disconnect");
	while(true)
	{
		if(isdefined(player.hasspawned) && player.hasspawned && player.team != team)
		{
			self showtoplayer(player);
			if(self util::isprop())
			{
				self ghost();
			}
		}
		player waittill(#"spawned");
	}
}

/*
	Name: function_346bdc3b
	Namespace: prop
	Checksum: 0x6044CA84
	Offset: 0x7128
	Size: 0x144
	Parameters: 0
	Flags: None
*/
function function_346bdc3b()
{
	self.thirdpersonrange = undefined;
	self setclientthirdperson(0, 0);
	self allowprone(1);
	self allowsprint(1);
	self setmovespeedscale(1);
	self playerknockback(1);
	self show();
	self setclientuivisibilityflag("weapon_hud_visible", 1);
	if(function_503c9413())
	{
		self function_543b1a75(0);
	}
	self thread namespace_4c773ed3::function_b6740059();
	self thread namespace_4c773ed3::function_1abcc66();
	self.concussionimmune = 1;
	self.healthregendisabled = 0;
	self thread attackerregenammo();
}

/*
	Name: stillalivexp
	Namespace: prop
	Checksum: 0xB00D9545
	Offset: 0x7278
	Size: 0x234
	Parameters: 0
	Flags: None
*/
function stillalivexp()
{
	level endon(#"game_ended");
	level.var_3c96f157["kill"]["value"] = 300;
	level waittill(#"props_hide_over");
	while(true)
	{
		hostmigration::waitlongdurationwithhostmigrationpause(10);
		/#
			if(getgametypesetting("") == 0)
			{
				continue;
			}
		#/
		foreach(player in level.players)
		{
			if(!isdefined(player.team))
			{
				continue;
			}
			if(player.team == game["attackers"])
			{
				continue;
			}
			if(!isalive(player))
			{
				continue;
			}
			if(!isdefined(player.prop))
			{
				continue;
			}
			scoreevents::processscoreevent("still_alive", player);
			switch(player.prop.info.propsize)
			{
				case 250:
				{
					scoreevents::processscoreevent("still_alive_medium_bonus", player);
					break;
				}
				case 450:
				{
					scoreevents::processscoreevent("still_alive_large_bonus", player);
					break;
				}
				case 550:
				{
					scoreevents::processscoreevent("still_alive_extra_large_bonus", player);
					break;
				}
				default:
				{
					break;
				}
			}
		}
	}
}

/*
	Name: tracktimealive
	Namespace: prop
	Checksum: 0x27B77A15
	Offset: 0x74B8
	Size: 0x170
	Parameters: 0
	Flags: None
*/
function tracktimealive()
{
	level endon(#"game_ended");
	function_45c842e9();
	while(true)
	{
		foreach(player in level.players)
		{
			if(!isdefined(player.team))
			{
				continue;
			}
			if(player.team == game["attackers"])
			{
				continue;
			}
			if(!isalive(player))
			{
				continue;
			}
			player.pers["objtime"]++;
			player.objtime = player.pers["objtime"];
			player addplayerstatwithgametype("OBJECTIVE_TIME", 1);
		}
		hostmigration::waitlongdurationwithhostmigrationpause(1);
	}
}

/*
	Name: gamemodemodifyplayerdamage
	Namespace: prop
	Checksum: 0x4FF11418
	Offset: 0x7630
	Size: 0xD0
	Parameters: 11
	Flags: None
*/
function gamemodemodifyplayerdamage(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	victim = self;
	if(isdefined(eattacker) && isplayer(eattacker) && isalive(eattacker))
	{
		if(!isdefined(eattacker.hashitplayer))
		{
			eattacker.hashitplayer = 1;
		}
	}
	return idamage;
}

/*
	Name: function_dc6b46ed
	Namespace: prop
	Checksum: 0x36DE1FE8
	Offset: 0x7708
	Size: 0xBE
	Parameters: 6
	Flags: None
*/
function function_dc6b46ed(idflags, shitloc, weapon, friendlyfire, attackerishittingself, smeansofdeath)
{
	if(isdefined(smeansofdeath) && smeansofdeath == "MOD_FALLING")
	{
		return true;
	}
	if(self function_e4b2f23())
	{
		if(weapon.name == "concussion_grenade")
		{
			return true;
		}
		if(issubstr(weapon.name, "destructible"))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: attackerswaittime
	Namespace: prop
	Checksum: 0x5076A21B
	Offset: 0x77D0
	Size: 0x148
	Parameters: 0
	Flags: None
*/
function attackerswaittime()
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	function_45c842e9();
	if(self.team == game["defenders"])
	{
		self notify(#"hash_b83e2d54");
		return;
	}
	while(!isdefined(level.starttime))
	{
		wait(0.05);
	}
	while(isdefined(self.controlsfrozen) && self.controlsfrozen)
	{
		wait(0.05);
	}
	var_e47d50e6 = function_d9c4b3d0();
	remainingtime = level.phsettings.prophidetime - var_e47d50e6;
	result = 0;
	if(remainingtime > 0)
	{
		if(!function_503c9413())
		{
			result = function_b00e098a(var_e47d50e6, remainingtime);
		}
		else
		{
			result = function_b1b25534(var_e47d50e6, remainingtime);
		}
	}
}

/*
	Name: function_b00e098a
	Namespace: prop
	Checksum: 0xA8E83FBF
	Offset: 0x7920
	Size: 0x110
	Parameters: 2
	Flags: None
*/
function function_b00e098a(var_e47d50e6, remainingtime)
{
	self freezecontrols(1);
	if(int(var_e47d50e6) > 0)
	{
		fadeintime = 0;
	}
	else
	{
		fadeintime = 1;
	}
	fadeouttime = 1;
	if((fadeintime + fadeouttime) > remainingtime)
	{
		fadeintime = 0;
		fadeouttime = 0;
	}
	self thread namespace_4c773ed3::function_7244ebc6(remainingtime, fadeintime, fadeouttime);
	result = self function_da184fd(remainingtime);
	self freezecontrols(0);
	return result;
}

/*
	Name: function_b1b25534
	Namespace: prop
	Checksum: 0xE6E153D9
	Offset: 0x7A38
	Size: 0x1E0
	Parameters: 2
	Flags: None
*/
function function_b1b25534(var_e47d50e6, remainingtime)
{
	var_27a8ec66 = 3;
	var_1006f499 = 1;
	fadeintime = 0;
	result = 0;
	var_b73ba41a = remainingtime - var_27a8ec66;
	self thread propwaitminigameinit(var_b73ba41a + var_1006f499);
	waittillframeend();
	self.var_11d543b4 = undefined;
	self.var_f806489a = undefined;
	if(remainingtime > 8)
	{
		self.var_11d543b4 = self.origin;
		self.var_f806489a = self.angles;
		result = self function_da184fd(var_b73ba41a);
		fadeintime = 1;
	}
	var_e47d50e6 = function_d9c4b3d0();
	remainingtime = level.phsettings.prophidetime - var_e47d50e6;
	if(remainingtime > 0)
	{
		self freezecontrols(1);
		fadeouttime = 1;
		if((fadeintime + fadeouttime) > remainingtime)
		{
			fadeintime = 0;
			fadeouttime = 0;
		}
		self thread namespace_4c773ed3::function_7244ebc6(remainingtime, fadeintime, fadeouttime);
		result = self function_da184fd(remainingtime);
		self freezecontrols(0);
	}
	return result;
}

/*
	Name: function_d9c4b3d0
	Namespace: prop
	Checksum: 0x6600A317
	Offset: 0x7C20
	Size: 0x20
	Parameters: 0
	Flags: None
*/
function function_d9c4b3d0()
{
	return ((gettime() - level.starttime) - level.var_f2aa1432) / 1000;
}

/*
	Name: function_1edf732a
	Namespace: prop
	Checksum: 0x9734FF41
	Offset: 0x7C48
	Size: 0x70
	Parameters: 0
	Flags: None
*/
function function_1edf732a()
{
	level.var_f2aa1432 = 0;
	while(true)
	{
		level waittill(#"host_migration_begin");
		starttime = gettime();
		level waittill(#"host_migration_end");
		var_1827a38e = gettime() - starttime;
		level.var_f2aa1432 = level.var_f2aa1432 + var_1827a38e;
	}
}

/*
	Name: function_da184fd
	Namespace: prop
	Checksum: 0x3BFA2135
	Offset: 0x7CC0
	Size: 0x64
	Parameters: 1
	Flags: None
*/
function function_da184fd(remainingtime)
{
	result = function_5eebce92(remainingtime);
	/#
		while(getdvarint("", 0) != 0)
		{
			wait(0.05);
		}
	#/
	return result;
}

/*
	Name: function_5eebce92
	Namespace: prop
	Checksum: 0xECE38EC2
	Offset: 0x7D30
	Size: 0x30
	Parameters: 1
	Flags: None
*/
function function_5eebce92(remainingtime)
{
	self endon(#"hash_b83e2d54");
	hostmigration::waitlongdurationwithhostmigrationpause(remainingtime);
	return true;
}

/*
	Name: function_e999d
	Namespace: prop
	Checksum: 0x2872313
	Offset: 0x7D68
	Size: 0x1B4
	Parameters: 0
	Flags: None
*/
function function_e999d()
{
	if(self.pers["team"] == game["attackers"])
	{
		self util::freeze_player_controls(1);
	}
	else
	{
		self thread function_320928f9();
	}
	team = self.pers["team"];
	if(isdefined(self.pers["music"].spawn) && self.pers["music"].spawn == 0)
	{
		if(level.wagermatch)
		{
			music = "SPAWN_WAGER";
		}
		else
		{
			music = game["music"]["spawn_" + team];
		}
		if(game["roundsplayed"] == 0)
		{
			self thread globallogic_spawn::snddelayedmusicstart("spawnFull");
		}
		else
		{
			self thread globallogic_spawn::snddelayedmusicstart("spawnShort");
		}
		self.pers["music"].spawn = 1;
	}
	if(level.splitscreen)
	{
		if(isdefined(level.playedstartingmusic))
		{
			music = undefined;
		}
		else
		{
			level.playedstartingmusic = 1;
		}
	}
	self thread globallogic_spawn::doinitialspawnmessaging();
}

/*
	Name: function_320928f9
	Namespace: prop
	Checksum: 0x25C1362D
	Offset: 0x7F28
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function function_320928f9()
{
	self endon(#"disconnect");
	self freezecontrolsallowlook(1);
	function_45c842e9();
	self freezecontrolsallowlook(0);
}

/*
	Name: attackerinitammo
	Namespace: prop
	Checksum: 0xC7D97680
	Offset: 0x7F80
	Size: 0x1C4
	Parameters: 0
	Flags: None
*/
function attackerinitammo()
{
	primaryweapons = self getweaponslistprimaries();
	foreach(weapon in primaryweapons)
	{
		self givemaxammo(weapon);
		self setweaponammoclip(weapon, 999);
	}
	if(!function_503c9413())
	{
		if(!isdefined(self.thrownspecialcount))
		{
			self.thrownspecialcount = 0;
		}
		weapon = getweapon("concussion_grenade");
		var_10f7466f = self getweaponammostock(weapon);
		var_10f7466f = var_10f7466f - self.thrownspecialcount;
		var_10f7466f = int(max(var_10f7466f, 0));
		self setweaponammostock(weapon, var_10f7466f);
		if(var_10f7466f > 0)
		{
			self thread namespace_4c773ed3::watchspecialgrenadethrow();
		}
	}
}

/*
	Name: attackerregenammo
	Namespace: prop
	Checksum: 0x65FAF60B
	Offset: 0x8150
	Size: 0x98
	Parameters: 0
	Flags: None
*/
function attackerregenammo()
{
	self endon(#"death");
	self endon(#"disconnect");
	self notify(#"attackerregenammo");
	self endon(#"attackerregenammo");
	level endon(#"game_ended");
	while(true)
	{
		self waittill(#"reload");
		primaryweapon = self getcurrentweapon();
		self givemaxammo(primaryweapon);
	}
}

/*
	Name: checkkillrespawn
	Namespace: prop
	Checksum: 0xF60B825B
	Offset: 0x81F0
	Size: 0x9C
	Parameters: 0
	Flags: None
*/
function checkkillrespawn()
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	hostmigration::waitlongdurationwithhostmigrationpause(0.1);
	if(self.pers["lives"] == 1)
	{
		self.pers["lives"]--;
		level.livescount[self.team]--;
		globallogic::updategameevents();
		level notify(#"propcountchanged");
		return;
	}
}

/*
	Name: function_7d4f8220
	Namespace: prop
	Checksum: 0x675406D3
	Offset: 0x8298
	Size: 0x4CA
	Parameters: 3
	Flags: None
*/
function function_7d4f8220(attacker, smeansofdeath, weapon)
{
	bestplayer = undefined;
	bestplayermeansofdeath = undefined;
	bestplayerweapon = undefined;
	if(!level flag::get("props_hide_over"))
	{
		return;
	}
	if(!isdefined(attacker) || attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn" || (isdefined(attacker.ismagicbullet) && attacker.ismagicbullet == 1) || attacker == self)
	{
		for(i = 0; i < self.attackers.size; i++)
		{
			player = self.attackers[i];
			if(!isdefined(player))
			{
				continue;
			}
			if(!isdefined(self.attackerdamage[player.clientid]) || !isdefined(self.attackerdamage[player.clientid].damage))
			{
				continue;
			}
			if(player == self || (level.teambased && player.team == self.team))
			{
				continue;
			}
			if(self.attackerdamage[player.clientid].damage > 1 && !isdefined(bestplayer))
			{
				bestplayer = player;
				bestplayermeansofdeath = self.attackerdamage[player.clientid].meansofdeath;
				bestplayerweapon = self.attackerdamage[player.clientid].weapon;
				continue;
			}
			if(isdefined(bestplayer) && self.attackerdamage[player.clientid].lasttimedamaged > self.attackerdamage[bestplayer.clientid].lasttimedamaged)
			{
				bestplayer = player;
				bestplayermeansofdeath = self.attackerdamage[player.clientid].meansofdeath;
				bestplayerweapon = self.attackerdamage[player.clientid].weapon;
			}
		}
		if(!isdefined(bestplayer) && self util::isprop())
		{
			bestdistsq = undefined;
			foreach(player in level.players)
			{
				if(isalive(player) && player.team != self.team)
				{
					distsq = distancesquared(player.origin, self.origin);
					if(!isdefined(bestdistsq) || distsq < bestdistsq)
					{
						bestplayer = player;
						bestdistsq = distsq;
					}
				}
			}
			if(isdefined(bestplayer))
			{
				bestplayermeansofdeath = "MOD_MELEE";
				bestplayerweapon = getweapon("none");
			}
		}
	}
	result = undefined;
	if(isdefined(bestplayer))
	{
		result = [];
		result["bestPlayer"] = bestplayer;
		result["bestPlayerWeapon"] = bestplayerweapon;
		result["bestMeansOfDeath"] = bestplayermeansofdeath;
	}
	return result;
}

/*
	Name: onplayerkilled
	Namespace: prop
	Checksum: 0x6C47998A
	Offset: 0x8770
	Size: 0x42A
	Parameters: 10
	Flags: None
*/
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration, lifeid)
{
	victim = self;
	killedbyenemy = 0;
	level notify(#"playercountchanged");
	if(victim.team == game["attackers"])
	{
		self thread respawnplayer();
	}
	else
	{
		if(!level flag::get("props_hide_over"))
		{
			self thread respawnplayer();
			return;
		}
		thread deathicons::add(victim.body, victim, victim.team, 5);
	}
	if(isdefined(attacker) && isplayer(attacker) && attacker != victim && victim.team != attacker.team)
	{
		killedbyenemy = 1;
	}
	if(killedbyenemy)
	{
		scoreevents::processscoreevent("prop_finalblow", attacker, victim);
		foreach(var_ee0888a5 in victim.attackers)
		{
			if(var_ee0888a5 == attacker)
			{
				var_ee0888a5 playhitmarker("mpl_hit_alert");
				continue;
			}
			var_ee0888a5 playhitmarker("mpl_hit_alert_escort");
		}
	}
	foreach(player in level.players)
	{
		if(player != attacker && player util::isprop() && isalive(player) && victim util::isprop())
		{
			scoreevents::processscoreevent("prop_survived", player);
			continue;
		}
		if(player != attacker && player function_e4b2f23() && victim.team == game["defenders"])
		{
			scoreevents::processscoreevent("prop_killed", player, victim);
		}
	}
	if(victim util::isprop())
	{
		attackerteam = util::getotherteam(victim.team);
		game["propScore"][attackerteam] = game["propScore"][attackerteam] + 1;
	}
}

/*
	Name: respawnplayer
	Namespace: prop
	Checksum: 0x7349378F
	Offset: 0x8BA8
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function respawnplayer()
{
	self thread waittillcanspawnclient();
}

/*
	Name: waittillcanspawnclient
	Namespace: prop
	Checksum: 0x230402AA
	Offset: 0x8BD0
	Size: 0xA6
	Parameters: 0
	Flags: None
*/
function waittillcanspawnclient()
{
	self endon(#"started_spawnplayer");
	self endon(#"disconnect");
	level endon(#"game_ended");
	for(;;)
	{
		wait(0.05);
		if(isdefined(self) && isdefined(self.curclass) && (self.sessionstate == "spectator" || !isalive(self)))
		{
			self.pers["lives"] = 1;
			self globallogic_spawn::spawnclient();
			continue;
		}
		return;
	}
}

/*
	Name: ondeadevent
	Namespace: prop
	Checksum: 0xE3885E05
	Offset: 0x8C80
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function ondeadevent(team)
{
	if(team == game["defenders"])
	{
		/#
			if(isdefined(level.allow_teamchange) && level.allow_teamchange == "")
			{
				return;
			}
		#/
		level thread propkilledend();
	}
}

/*
	Name: propkilledend
	Namespace: prop
	Checksum: 0x7DBC7BFC
	Offset: 0x8CE8
	Size: 0xB4
	Parameters: 0
	Flags: None
*/
function propkilledend()
{
	if(isdefined(level.hunterswonending) && level.hunterswonending)
	{
		return;
	}
	if(isdefined(level.gameending) && level.gameending)
	{
		return;
	}
	level.hunterswonending = 1;
	function_f666ecbf();
	level.gameending = 1;
	hostmigration::waitlongdurationwithhostmigrationpause(3);
	thread ph_endgame(game["attackers"], game["strings"][game["defenders"] + "_eliminated"]);
}

/*
	Name: function_470f21c5
	Namespace: prop
	Checksum: 0x17D68E67
	Offset: 0x8DA8
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function function_470f21c5(smeansofdeath)
{
	if(self.team == game["attackers"])
	{
		self battlechatter::pain_vox(smeansofdeath);
	}
}

/*
	Name: playdeathsoundph
	Namespace: prop
	Checksum: 0xC759FC00
	Offset: 0x8DF0
	Size: 0x6C
	Parameters: 4
	Flags: None
*/
function playdeathsoundph(body, attacker, weapon, smeansofdeath)
{
	if(self.team == game["attackers"] && isdefined(body))
	{
		self battlechatter::play_death_vox(body, attacker, weapon, smeansofdeath);
	}
}

/*
	Name: round
	Namespace: prop
	Checksum: 0xF8DF2B31
	Offset: 0x8E68
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function round(value)
{
	value = int(value + 0.5);
	return value;
}

/*
	Name: function_c17c938d
	Namespace: prop
	Checksum: 0xF03A5BB4
	Offset: 0x8EA8
	Size: 0x3CC
	Parameters: 8
	Flags: None
*/
function function_c17c938d(winner, endtype, endreasontext, outcometext, team, winnerenum, notifyroundendtoui, matchbonus)
{
	if(endtype == "gameend" && isdefined(level.proptiebreaker))
	{
		if(!isdefined(team) || team == "spectator")
		{
			if(isdefined(self.team) && self.team != "spectator" && isdefined(game["propScore"][self.team]))
			{
				team = self.team;
			}
			else if(isdefined(self.sessionteam) && self.sessionteam != "spectator" && isdefined(game["propScore"][self.sessionteam]))
			{
				team = self.sessionteam;
			}
			if(!isdefined(team))
			{
				return true;
			}
		}
		otherteam = util::getotherteam(team);
		if(level.proptiebreaker == "kills")
		{
			winnerscore = game["propScore"][team];
			loserscore = game["propScore"][otherteam];
			if(winnerscore < loserscore)
			{
				winnerscore = game["propScore"][otherteam];
				loserscore = game["propScore"][team];
			}
			var_be546bcd = (winnerscore << 8) + loserscore;
			self luinotifyevent(&"show_outcome", 6, outcometext, &"MP_PH_TIEBREAKER_KILL", int(matchbonus), winnerenum, notifyroundendtoui, var_be546bcd);
			return true;
		}
		if(level.proptiebreaker == "time")
		{
			var_f3258fd1 = game["hunterKillTime"][team] / 1000;
			otherteam = util::getotherteam(team);
			var_61cf9ec5 = game["hunterKillTime"][otherteam] / 1000;
			var_101aa528 = round(var_f3258fd1);
			var_b71f48d4 = round(var_61cf9ec5);
			if(var_101aa528 == var_b71f48d4)
			{
				if(var_f3258fd1 > var_61cf9ec5)
				{
					var_101aa528++;
				}
				else
				{
					var_b71f48d4++;
				}
			}
			var_cd0a6db3 = var_101aa528;
			var_7bdb281b = var_b71f48d4;
			if(var_cd0a6db3 < var_7bdb281b)
			{
				var_cd0a6db3 = var_b71f48d4;
				var_7bdb281b = var_101aa528;
			}
			self luinotifyevent(&"show_outcome", 7, outcometext, &"MP_PH_TIEBREAKER_TIME", int(matchbonus), winnerenum, notifyroundendtoui, var_cd0a6db3, var_7bdb281b);
			return true;
		}
	}
	return false;
}

/*
	Name: function_e0d16266
	Namespace: prop
	Checksum: 0x32F1A64C
	Offset: 0x9280
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function function_e0d16266(spawnpoint, predictedspawn)
{
	if(!predictedspawn)
	{
		self.var_953903c8 = spawnpoint;
	}
}

/*
	Name: function_6f13f156
	Namespace: prop
	Checksum: 0x9ABACB5D
	Offset: 0x92B0
	Size: 0xF6
	Parameters: 2
	Flags: None
*/
function function_6f13f156(spawnpoint, predictedspawn)
{
	foreach(player in level.players)
	{
		if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator")
		{
			if(isdefined(player.var_953903c8) && player.var_953903c8 == spawnpoint)
			{
				return false;
			}
		}
	}
	return true;
}

/*
	Name: gamehasstarted
	Namespace: prop
	Checksum: 0x7CC765E6
	Offset: 0x93B0
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function gamehasstarted()
{
	if(level.teambased)
	{
		return globallogic_spawn::allteamshaveexisted();
	}
	return level.maxplayercount > 1 || (!util::isoneround() && !util::isfirstround());
}

/*
	Name: function_4fb47492
	Namespace: prop
	Checksum: 0x8AC7CF4B
	Offset: 0x9420
	Size: 0x146
	Parameters: 0
	Flags: None
*/
function function_4fb47492()
{
	/#
		if(level.var_2898ef72)
		{
			return true;
		}
	#/
	if(level.inovertime)
	{
		return false;
	}
	if(level.playerqueuedrespawn && !isdefined(self.allowqueuespawn) && !level.ingraceperiod && !level.usestartspawns)
	{
		return false;
	}
	if(level.numlives || level.numteamlives)
	{
		gamehasstarted = gamehasstarted();
		if(gamehasstarted && (level.numlives && !self.pers["lives"]) || (level.numteamlives && !game[self.team + "_lives"]))
		{
			return false;
		}
		if(gamehasstarted)
		{
			if(!level.ingraceperiod && !self.hasspawned && !level.wagermatch)
			{
				return false;
			}
		}
		if(self disablespawningforplayer())
		{
			return false;
		}
	}
	return true;
}

/*
	Name: disablespawningforplayer
	Namespace: prop
	Checksum: 0x86AB1F8
	Offset: 0x9570
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function disablespawningforplayer()
{
	if(!gamehasstarted())
	{
		return 0;
	}
	if(self function_e4b2f23())
	{
		return 0;
	}
	if(self util::isprop())
	{
		return !level.ingraceperiod;
	}
	return 0;
}

/*
	Name: function_e4b2f23
	Namespace: prop
	Checksum: 0xD9476B1E
	Offset: 0x95D8
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function function_e4b2f23()
{
	return isdefined(self.team) && self.team == game["attackers"];
}

/*
	Name: function_4bdf92a7
	Namespace: prop
	Checksum: 0x8A09992A
	Offset: 0x9608
	Size: 0xB2
	Parameters: 0
	Flags: None
*/
function function_4bdf92a7()
{
	turrets = getentarray("misc_turret", "classname");
	foreach(turret in turrets)
	{
		turret delete();
	}
}

/*
	Name: function_9bb11de9
	Namespace: prop
	Checksum: 0x240EA49F
	Offset: 0x96C8
	Size: 0x9C
	Parameters: 6
	Flags: None
*/
function function_9bb11de9(eattacker, einflictor, weapon, smeansofdeath, idamage, vpoint)
{
	self thread function_b37cf698(eattacker, einflictor, weapon, smeansofdeath, idamage, vpoint);
	if(!self util::isusingremote())
	{
		self playrumbleonentity("damage_heavy");
	}
}

/*
	Name: function_b37cf698
	Namespace: prop
	Checksum: 0x1F6810F9
	Offset: 0x9770
	Size: 0x33A
	Parameters: 6
	Flags: None
*/
function function_b37cf698(eattacker, einflictor, weapon, meansofdeath, damage, point)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(isdefined(level._custom_weapon_damage_func))
	{
		is_weapon_registered = self [[level._custom_weapon_damage_func]](eattacker, einflictor, weapon, meansofdeath, damage);
		if(is_weapon_registered)
		{
			return;
		}
	}
	switch(weapon.rootweapon.name)
	{
		case "concussion_grenade":
		{
			if(isdefined(self.concussionimmune) && self.concussionimmune)
			{
				return;
			}
			radius = weapon.explosionradius;
			if(self == eattacker)
			{
				radius = radius * 0.5;
			}
			damageorigin = einflictor.origin;
			if(isdefined(point))
			{
				damageorigin = point;
			}
			if(self namespace_4c773ed3::function_94e1618c(damageorigin))
			{
				return;
			}
			scale = 1 - (distance(self.origin, damageorigin) / radius);
			if(scale < 0)
			{
				scale = 0;
			}
			time = 0.25 + (4 * scale);
			wait(0.05);
			if(meansofdeath != "MOD_IMPACT")
			{
				if(self hasperk("specialty_stunprotection"))
				{
					time = time * 0.1;
				}
				else if(self util::mayapplyscreeneffect())
				{
					self shellshock("concussion_grenade_mp", time, 0);
				}
				self thread weapons::play_concussion_sound(time);
				self.concussionendtime = gettime() + (time * 1000);
				self.lastconcussedby = eattacker;
				if(self util::isprop())
				{
					if(isdefined(self.lock) && self.lock)
					{
						self namespace_4c773ed3::unlockprop();
					}
					self namespace_4c773ed3::function_770b4cfa(einflictor, self, meansofdeath, damage, damageorigin, weapon);
				}
			}
			break;
		}
		default:
		{
			if(isdefined(level.shellshockonplayerdamage))
			{
				[[level.shellshockonplayerdamage]](meansofdeath, damage, weapon);
			}
			break;
		}
	}
}

/*
	Name: function_7010fe7f
	Namespace: prop
	Checksum: 0xA843D4F7
	Offset: 0x9AB8
	Size: 0x14A
	Parameters: 0
	Flags: None
*/
function function_7010fe7f()
{
	level endon(#"game_ended");
	wait(0.05);
	while(!isdefined(level.mannequins))
	{
		wait(0.05);
	}
	foreach(mannequin in level.mannequins)
	{
		mannequin notsolid();
	}
	level waittill(#"props_hide_over");
	foreach(mannequin in level.mannequins)
	{
		mannequin solid();
	}
}

/*
	Name: propwaitminigameinit
	Namespace: prop
	Checksum: 0x71AF1237
	Offset: 0x9C10
	Size: 0x104
	Parameters: 1
	Flags: None
*/
function propwaitminigameinit(time)
{
	if(!isdefined(level.var_e5ad813f))
	{
		level.var_e5ad813f = spawnstruct();
	}
	if(!(isdefined(level.var_e5ad813f.started) && level.var_e5ad813f.started))
	{
		level.var_e5ad813f.started = 1;
		self thread function_b408af2c(time);
	}
	self.var_efe75c2f = 0;
	self.var_61add00c = 0;
	if(level.var_e5ad813f.var_d504a1f4 && self function_e4b2f23() && time > 8)
	{
		waittillframeend();
		if(level.var_abcf2d12.size < 6)
		{
			self function_83efbfcf();
		}
	}
}

/*
	Name: function_b408af2c
	Namespace: prop
	Checksum: 0xB1F8FB72
	Offset: 0x9D20
	Size: 0x422
	Parameters: 1
	Flags: None
*/
function function_b408af2c(time)
{
	if(time <= 0)
	{
		level.var_e5ad813f.active = 0;
		return;
	}
	thread function_c91df86f();
	function_da184fd(time);
	level notify(#"hash_ea126364");
	level.var_e5ad813f.active = 0;
	foreach(player in level.players)
	{
		if(isdefined(player.pers["team"]) && player.pers["team"] == game["defenders"])
		{
			player function_2472fc6();
			continue;
		}
		if(isdefined(player.pers["team"]) && player.pers["team"] == game["attackers"])
		{
			player function_7d5b1fa6();
		}
	}
	if(isdefined(level.var_e5ad813f.var_d410e6e5))
	{
		level.var_e5ad813f.var_d410e6e5 destroy();
	}
	thread propminigameupdateshowwinner(level.var_e5ad813f.var_239c724[0], -80, 2);
	thread propminigameupdateshowwinner(level.var_e5ad813f.var_239c724[1], -50, 1.75);
	thread propminigameupdateshowwinner(level.var_e5ad813f.var_239c724[2], -20, 1.5);
	if(isdefined(level.var_e5ad813f.targets))
	{
		foreach(target in level.var_e5ad813f.targets)
		{
			if(isdefined(target))
			{
				target delete();
			}
		}
	}
	if(isdefined(level.var_abcf2d12))
	{
		foreach(clone in level.var_abcf2d12)
		{
			if(isdefined(clone))
			{
				if(isdefined(clone.var_9352d14f))
				{
					clone.var_9352d14f delete();
				}
				if(isdefined(clone.var_6f5f0e80))
				{
					gameobjects::release_obj_id(clone.var_6f5f0e80);
				}
				clone delete();
			}
		}
	}
}

/*
	Name: propminigameupdateshowwinner
	Namespace: prop
	Checksum: 0x42E7E3
	Offset: 0xA150
	Size: 0x11C
	Parameters: 3
	Flags: None
*/
function propminigameupdateshowwinner(hud, winyoffset, winfontscale)
{
	hud endon(#"death");
	movetime = 0.5;
	showtime = 2.5;
	fadetime = 0.5;
	hud hud::setpoint("BOTTOM", "CENTER", 0, winyoffset, movetime);
	hud changefontscaleovertime(movetime);
	hud.fontscale = winfontscale;
	wait(movetime + showtime);
	hud.alpha = 0;
	hud fadeovertime(fadetime);
	wait(fadetime);
	if(isdefined(hud))
	{
		hud destroy();
	}
}

/*
	Name: function_7d5b1fa6
	Namespace: prop
	Checksum: 0x34115605
	Offset: 0xA278
	Size: 0x8C
	Parameters: 0
	Flags: None
*/
function function_7d5b1fa6()
{
	self function_543b1a75(1);
	self takeweapon(getweapon("null_offhand_primary"));
	self function_c32f3fcc(getweapon("concussion_grenade"), 2);
	self attackerinitammo();
}

/*
	Name: function_2472fc6
	Namespace: prop
	Checksum: 0xC3EAE6F0
	Offset: 0xA310
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function function_2472fc6()
{
	self function_f2704a3c(1);
}

/*
	Name: function_503c9413
	Namespace: prop
	Checksum: 0x91E773AA
	Offset: 0xA338
	Size: 0x7A
	Parameters: 0
	Flags: None
*/
function function_503c9413()
{
	if(!isdefined(level.var_e5ad813f))
	{
		level.var_e5ad813f = spawnstruct();
	}
	if(!isdefined(level.var_e5ad813f.active))
	{
		level.var_e5ad813f.active = getdvarint("scr_prop_minigame", 0);
	}
	return level.var_e5ad813f.active;
}

/*
	Name: function_543b1a75
	Namespace: prop
	Checksum: 0x103A6023
	Offset: 0xA3C0
	Size: 0x13C
	Parameters: 1
	Flags: None
*/
function function_543b1a75(isvisible)
{
	if(isvisible)
	{
		self solid();
		self solidcapsule();
		self function_cd929fef(1);
		if(isdefined(self.var_11d543b4))
		{
			self setorigin(self.var_11d543b4);
			self setplayerangles(self.var_f806489a);
		}
		if(isdefined(self.var_c83b06b4))
		{
			self.var_c83b06b4 delete();
		}
	}
	else
	{
		self notsolid();
		self notsolidcapsule();
		self thread function_945f1c41(game["defenders"], 1);
		self thread function_471ff19e(self);
	}
}

/*
	Name: function_471ff19e
	Namespace: prop
	Checksum: 0x1D4DBAD9
	Offset: 0xA508
	Size: 0x16C
	Parameters: 1
	Flags: None
*/
function function_471ff19e(player)
{
	player endon(#"disconnect");
	level endon(#"game_ended");
	if(!isdefined(player.var_c83b06b4))
	{
		function_45c842e9();
		wait(0.1);
		clone = util::spawn_player_clone(player, "pb_stand_alert");
		weapon = player getcurrentweapon();
		if(isdefined(weapon.worldmodel))
		{
			clone attach(weapon.worldmodel, "tag_weapon_right");
		}
		clone notsolid();
		clone notsolidcapsule();
		clone hidefromteam(player.pers["team"]);
		player.var_c83b06b4 = clone;
		player thread function_84edfab0(player, player.var_c83b06b4);
	}
}

/*
	Name: function_84edfab0
	Namespace: prop
	Checksum: 0xFB1CBFE9
	Offset: 0xA680
	Size: 0x5C
	Parameters: 2
	Flags: None
*/
function function_84edfab0(player, clone)
{
	clone endon(#"entityshutdown");
	clone endon(#"death");
	player waittill(#"disconnect");
	if(isdefined(clone))
	{
		clone delete();
	}
}

/*
	Name: function_f2704a3c
	Namespace: prop
	Checksum: 0x2B910F13
	Offset: 0xA6E8
	Size: 0x1A4
	Parameters: 1
	Flags: None
*/
function function_f2704a3c(isvisible)
{
	if(isvisible)
	{
		if(isdefined(self.prop))
		{
			self.prop show();
			self.prop solid();
		}
		self function_cd929fef(0);
		self ghost();
		if(isdefined(self.propclones))
		{
			foreach(clone in self.propclones)
			{
				clone show();
				clone solid();
			}
		}
	}
	else
	{
		if(isdefined(self.prop))
		{
			self.prop notsolid();
			self.prop hidefromteam(game["attackers"]);
		}
		self thread function_945f1c41(game["attackers"], 0);
	}
}

/*
	Name: function_c91df86f
	Namespace: prop
	Checksum: 0xB8D3005A
	Offset: 0xA898
	Size: 0x29A
	Parameters: 0
	Flags: None
*/
function function_c91df86f()
{
	level.var_e5ad813f.var_d504a1f4 = 0;
	label = &"MP_PH_PREGAME_HUNT";
	if(randomfloat(1) < 0.5)
	{
		level.var_e5ad813f.var_d504a1f4 = 1;
		label = &"MP_PH_PREGAME_CHASE";
	}
	/#
		if(getdvarint("", 0) == 2 && level.var_e5ad813f.var_d504a1f4)
		{
			level.var_e5ad813f.var_d504a1f4 = 0;
			label = &"";
		}
		else if(getdvarint("", 0) == 1 && !level.var_e5ad813f.var_d504a1f4)
		{
			level.var_e5ad813f.var_d504a1f4 = 1;
			label = &"";
		}
	#/
	thread function_9b0f77c4(label);
	level.var_e5ad813f.var_753abe12 = function_1450fc18();
	level.var_e5ad813f.var_753abe12 = array::randomize(level.var_e5ad813f.var_753abe12);
	level.var_e5ad813f.nextindex = 0;
	if(!level.var_e5ad813f.var_d504a1f4)
	{
		thread function_f26960c8();
	}
	else
	{
		level.var_abcf2d12 = [];
	}
	foreach(player in level.players)
	{
		if(isdefined(player.pers["team"]) && player.pers["team"] == game["attackers"])
		{
			player thread function_89acdf0d(&"MP_PH_EMPTY");
		}
	}
}

/*
	Name: function_1450fc18
	Namespace: prop
	Checksum: 0xA3960799
	Offset: 0xAB40
	Size: 0x15A
	Parameters: 0
	Flags: None
*/
function function_1450fc18()
{
	var_f5af7250 = 90000;
	var_753abe12 = [];
	alllocations = spawnlogic::get_spawnpoint_array("mp_tdm_spawn");
	hunters = getlivingplayersonteam(game["attackers"]);
	hunter = hunters[0];
	foreach(location in alllocations)
	{
		distsq = distancesquared(location.origin, hunter.origin);
		if(distsq > var_f5af7250)
		{
			var_753abe12[var_753abe12.size] = location;
		}
	}
	return var_753abe12;
}

/*
	Name: function_5f1e8e1b
	Namespace: prop
	Checksum: 0x99CBCC12
	Offset: 0xACA8
	Size: 0xA
	Parameters: 0
	Flags: None
*/
function function_5f1e8e1b()
{
	return "wpn_t7_uplink_ball_world";
}

/*
	Name: function_f26960c8
	Namespace: prop
	Checksum: 0xFC7BE020
	Offset: 0xACC0
	Size: 0x15E
	Parameters: 0
	Flags: None
*/
function function_f26960c8()
{
	var_8eb640f2 = 40;
	var_8ba71423 = 4;
	model = function_5f1e8e1b();
	numtargets = min(level.var_e5ad813f.var_753abe12.size, var_8eb640f2);
	level.var_e5ad813f.targets = [];
	num = 0;
	for(i = 0; i < numtargets; i++)
	{
		origin = function_8e704405();
		target = function_98636e21(origin, model);
		level.var_e5ad813f.targets[level.var_e5ad813f.targets.size] = target;
		num++;
		if(num >= var_8ba71423)
		{
			wait(0.05);
			num = 0;
		}
	}
}

/*
	Name: function_7d3dbc54
	Namespace: prop
	Checksum: 0x7336442D
	Offset: 0xAE28
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function function_7d3dbc54(targetent)
{
	wait(0.05);
	if(isdefined(targetent))
	{
		playfxontag("ui/fx_uplink_ball_vanish", targetent, "tag_origin");
	}
}

/*
	Name: function_98636e21
	Namespace: prop
	Checksum: 0xB88718F9
	Offset: 0xAE78
	Size: 0x1B0
	Parameters: 2
	Flags: None
*/
function function_98636e21(origin, model)
{
	target = spawn("script_model", origin);
	target setmodel(model);
	target.targetname = "propTarget";
	target setcandamage(1);
	target.fakehealth = 50;
	target.health = 99999;
	target.maxhealth = 99999;
	target thread function_500dc7d9(&function_8d5e52a2);
	target setplayercollision(0);
	target makesentient();
	target notsolidcapsule();
	target setteam(game["defenders"]);
	target hidefromteam(game["defenders"]);
	target setscale(2, 1);
	thread function_7d3dbc54(target);
	return target;
}

/*
	Name: function_8d5e52a2
	Namespace: prop
	Checksum: 0x26E010FC
	Offset: 0xB030
	Size: 0x118
	Parameters: 10
	Flags: None
*/
function function_8d5e52a2(damage, attacker, direction_vec, point, meansofdeath, modelname, tagname, partname, weapon, idflags)
{
	if(!isdefined(attacker))
	{
		return;
	}
	if(isplayer(attacker))
	{
		if(isdefined(self.isdying) && self.isdying)
		{
			return;
		}
		attacker thread damagefeedback::update();
		self.lastattacker = attacker;
		self.fakehealth = self.fakehealth - damage;
		if(self.fakehealth <= 0)
		{
			function_a88142c8(attacker);
			self thread movetarget();
		}
	}
	self.health = self.health + damage;
}

/*
	Name: movetarget
	Namespace: prop
	Checksum: 0xFB2B762
	Offset: 0xB150
	Size: 0x190
	Parameters: 0
	Flags: None
*/
function movetarget()
{
	self.isdying = 1;
	wait(0.05);
	self.fakehealth = 50;
	fxent = playfx(fx::get("propDeathFX"), self.origin + vectorscale((0, 0, 1), 4));
	fxent hide();
	foreach(player in level.players)
	{
		if(player function_e4b2f23())
		{
			fxent showtoplayer(player);
		}
	}
	fxent playsoundtoteam("wpn_flash_grenade_explode", game["attackers"]);
	self.origin = function_8e704405();
	self dontinterpolate();
	self.isdying = 0;
}

/*
	Name: function_5e31e74e
	Namespace: prop
	Checksum: 0x4E9DEBE3
	Offset: 0xB2E8
	Size: 0xDC
	Parameters: 1
	Flags: None
*/
function function_5e31e74e(location)
{
	var_cc2c9630 = 90000;
	foreach(target in level.var_e5ad813f.targets)
	{
		distsq = distancesquared(target.origin, location);
		if(distsq < var_cc2c9630)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_8e704405
	Namespace: prop
	Checksum: 0xED251C34
	Offset: 0xB3D0
	Size: 0x290
	Parameters: 0
	Flags: None
*/
function function_8e704405()
{
	if(level.var_e5ad813f.nextindex >= level.var_e5ad813f.var_753abe12.size)
	{
		level.var_e5ad813f.nextindex = 0;
	}
	location = level.var_e5ad813f.var_753abe12[level.var_e5ad813f.nextindex];
	if(!isdefined(location.var_54fb921c))
	{
		dir = level.mapcenter - location.origin;
		dist = distance(level.mapcenter, location.origin);
		if(dist > 0)
		{
			dir = (dir[0] / dist, dir[1] / dist, dir[2] / dist);
		}
		attempts = 9;
		newlocation = location.origin;
		rand = randomfloat(1);
		while(attempts > 0)
		{
			var_911938e0 = dist * rand;
			newlocation = location.origin + (dir * var_911938e0);
			if(!function_5e31e74e(newlocation))
			{
				break;
			}
			rand = rand - 0.1;
			if(rand < 0)
			{
				newlocation = location.origin;
				break;
			}
			attempts--;
		}
		newlocation = getclosestpointonnavmesh(newlocation, 100);
		if(!isdefined(newlocation))
		{
			newlocation = location.origin;
		}
		location.var_54fb921c = newlocation;
	}
	origin = location.var_54fb921c + vectorscale((0, 0, 1), 40);
	level.var_e5ad813f.nextindex++;
	return origin;
}

/*
	Name: function_249fb651
	Namespace: prop
	Checksum: 0x753280B4
	Offset: 0xB668
	Size: 0x15C
	Parameters: 4
	Flags: None
*/
function function_249fb651(x, y, label, color)
{
	var_f2d1d7d5 = hud::createserverfontstring("default", 1.5, game["attackers"]);
	var_f2d1d7d5.label = label;
	var_f2d1d7d5.x = x;
	var_f2d1d7d5.y = y;
	var_f2d1d7d5.alignx = "left";
	var_f2d1d7d5.aligny = "top";
	var_f2d1d7d5.horzalign = "left";
	var_f2d1d7d5.vertalign = "top";
	var_f2d1d7d5.color = color;
	var_f2d1d7d5.archived = 1;
	var_f2d1d7d5.alpha = 0;
	var_f2d1d7d5.glowalpha = 0;
	var_f2d1d7d5.hidewheninmenu = 0;
	var_f2d1d7d5.sort = 1001;
	return var_f2d1d7d5;
}

/*
	Name: function_9b0f77c4
	Namespace: prop
	Checksum: 0xA685371A
	Offset: 0xB7D0
	Size: 0x2CC
	Parameters: 1
	Flags: None
*/
function function_9b0f77c4(titlelabel)
{
	level.var_e5ad813f.var_239c724 = [];
	var_62372e41 = 110;
	var_ff475784 = 20;
	if(!level.console)
	{
		var_62372e41 = 125;
		var_ff475784 = 15;
	}
	x = 5;
	y = var_62372e41;
	level.var_e5ad813f.var_239c724[level.var_e5ad813f.var_239c724.size] = function_249fb651(x, y, &"MP_PH_MINIGAME_FIRST", (1, 0.843, 0));
	y = y + var_ff475784;
	level.var_e5ad813f.var_239c724[level.var_e5ad813f.var_239c724.size] = function_249fb651(x, y, &"MP_PH_MINIGAME_SECOND", vectorscale((1, 1, 1), 0.3));
	y = y + var_ff475784;
	level.var_e5ad813f.var_239c724[level.var_e5ad813f.var_239c724.size] = function_249fb651(x, y, &"MP_PH_MINIGAME_THIRD", (0.804, 0.498, 0.196));
	level.var_e5ad813f.var_d410e6e5 = hud::createserverfontstring("default", 2.5, game["attackers"]);
	level.var_e5ad813f.var_d410e6e5 hud::setpoint("CENTER", undefined, 0, -30);
	level.var_e5ad813f.var_d410e6e5.label = titlelabel;
	level.var_e5ad813f.var_d410e6e5.x = 0;
	level.var_e5ad813f.var_d410e6e5.archived = 1;
	level.var_e5ad813f.var_d410e6e5.alpha = 1;
	level.var_e5ad813f.var_d410e6e5.glowalpha = 0;
	level.var_e5ad813f.var_d410e6e5.hidewheninmenu = 0;
	thread function_e14e11c4();
}

/*
	Name: function_e14e11c4
	Namespace: prop
	Checksum: 0x6458C37A
	Offset: 0xBAA8
	Size: 0x110
	Parameters: 0
	Flags: None
*/
function function_e14e11c4()
{
	level endon(#"game_ended");
	wait(5.5);
	level.var_e5ad813f.var_d410e6e5 moveovertime(1);
	level.var_e5ad813f.var_d410e6e5 hud::setpoint("CENTER", undefined, 0, -100);
	wait(1);
	level.var_e5ad813f.var_d410e6e5 fadeovertime(1);
	level.var_e5ad813f.var_d410e6e5.color = (0, 1, 0);
	wait(1);
	level.var_e5ad813f.var_d410e6e5 fadeovertime(1);
	level.var_e5ad813f.var_d410e6e5.color = (1, 1, 1);
}

/*
	Name: function_a88142c8
	Namespace: prop
	Checksum: 0x6BCB5A2D
	Offset: 0xBBC0
	Size: 0xB4
	Parameters: 1
	Flags: None
*/
function function_a88142c8(player)
{
	var_47b5687d = (gettime() - level.starttime) - level.var_f2aa1432;
	player.var_efe75c2f++;
	player.var_61add00c = player.var_61add00c + var_47b5687d;
	player.var_24edba04 setvalue(player.var_efe75c2f);
	player thread function_1cda54();
	function_c021720c();
}

/*
	Name: function_c021720c
	Namespace: prop
	Checksum: 0x30238F7C
	Offset: 0xBC80
	Size: 0x1C2
	Parameters: 1
	Flags: None
*/
function function_c021720c(delaytime)
{
	level endon(#"game_ended");
	if(isdefined(delaytime))
	{
		wait(delaytime);
	}
	hunters = getlivingplayersonteam(game["attackers"]);
	var_711fc677 = array::quicksort(hunters, &function_69596636);
	for(i = 0; i < 3; i++)
	{
		if(isdefined(var_711fc677[i]) && isdefined(var_711fc677[i].var_efe75c2f) && var_711fc677[i].var_efe75c2f > 0)
		{
			level.var_e5ad813f.var_239c724[i].alpha = 1;
			level.var_e5ad813f.var_239c724[i] setplayernamestring(var_711fc677[i]);
			continue;
		}
		if(isdefined(level.var_e5ad813f.var_239c724) && isdefined(level.var_e5ad813f.var_239c724[i]) && level.var_e5ad813f.var_239c724[i].alpha > 0)
		{
			level.var_e5ad813f.var_239c724[i].alpha = 0;
		}
	}
}

/*
	Name: function_69596636
	Namespace: prop
	Checksum: 0xB342A759
	Offset: 0xBE50
	Size: 0xC0
	Parameters: 2
	Flags: None
*/
function function_69596636(p1, p2)
{
	if(!isdefined(p1) || !isdefined(p1.var_efe75c2f))
	{
		return 0;
	}
	if(!isdefined(p2) || !isdefined(p2.var_efe75c2f))
	{
		return 1;
	}
	if(p1.var_efe75c2f > p2.var_efe75c2f)
	{
		return 1;
	}
	return p1.var_efe75c2f == p2.var_efe75c2f && p1.var_61add00c <= p2.var_61add00c;
}

/*
	Name: function_ae94b584
	Namespace: prop
	Checksum: 0xA9EA3A53
	Offset: 0xBF18
	Size: 0x138
	Parameters: 1
	Flags: None
*/
function function_ae94b584(label)
{
	self.var_24edba04 = hud::createfontstring("objective", 1);
	self.var_24edba04.label = label;
	self.var_24edba04.x = 0;
	self.var_24edba04.y = 20;
	self.var_24edba04.alignx = "center";
	self.var_24edba04.aligny = "middle";
	self.var_24edba04.horzalign = "user_center";
	self.var_24edba04.vertalign = "middle";
	self.var_24edba04.archived = 1;
	self.var_24edba04.fontscale = 1;
	self.var_24edba04.alpha = 0;
	self.var_24edba04.glowalpha = 0.5;
	self.var_24edba04.hidewheninmenu = 0;
}

/*
	Name: function_89acdf0d
	Namespace: prop
	Checksum: 0xA6047F54
	Offset: 0xC058
	Size: 0x24
	Parameters: 1
	Flags: None
*/
function function_89acdf0d(label)
{
	self function_ae94b584(label);
}

/*
	Name: function_1cda54
	Namespace: prop
	Checksum: 0xD60FA716
	Offset: 0xC088
	Size: 0x48
	Parameters: 0
	Flags: None
*/
function function_1cda54()
{
	self.var_24edba04.alpha = 1;
	self.var_24edba04 fadeovertime(3);
	self.var_24edba04.alpha = 0;
}

/*
	Name: function_83efbfcf
	Namespace: prop
	Checksum: 0x431AA739
	Offset: 0xC0D8
	Size: 0x13C
	Parameters: 0
	Flags: None
*/
function function_83efbfcf()
{
	forward = anglestoforward(self getangles());
	origin = self.origin + vectorscale(forward, 100);
	origin = getclosestpointonnavmesh(origin, 600);
	clone = spawnactor("spawner_bo3_robot_grunt_assault_mp", origin, self.angles, "", 1);
	clone.var_9352d14f = function_16efb8e6(origin + vectorscale((0, 0, 1), 40));
	clone.var_9352d14f linkto(clone);
	level.var_abcf2d12[level.var_abcf2d12.size] = clone;
	function_ec41bbd2(clone, self, forward);
}

/*
	Name: function_ec41bbd2
	Namespace: prop
	Checksum: 0x7B8E3CB
	Offset: 0xC220
	Size: 0x454
	Parameters: 3
	Flags: None
*/
function function_ec41bbd2(clone, player, forward)
{
	clone.isaiclone = 1;
	clone.propername = "";
	clone.ignoretriggerdamage = 1;
	clone.minwalkdistance = 125;
	clone.overrideactordamage = &clonedamageoverride;
	clone.spawntime = gettime();
	clone.var_132756fd = 1;
	clone setmaxhealth(9999);
	clone pushactors(1);
	clone pushplayer(1);
	clone setcontents(8192);
	clone setavoidancemask("avoid none");
	clone.var_6f5f0e80 = gameobjects::get_next_obj_id();
	objective_add(clone.var_6f5f0e80, "active");
	objective_team(clone.var_6f5f0e80, game["attackers"]);
	objective_position(clone.var_6f5f0e80, clone.origin);
	objective_icon(clone.var_6f5f0e80, "t7_hud_waypoints_safeguard_location");
	objective_setcolor(clone.var_6f5f0e80, &"FriendlyBlue");
	objective_onentity(clone.var_6f5f0e80, clone);
	clone asmsetanimationrate(1.2);
	clone setclone();
	clone._goal_center_point = function_176b694c();
	queryresult = undefined;
	if(isdefined(clone._goal_center_point) && clone findpath(clone.origin, clone._goal_center_point, 1, 0))
	{
		queryresult = positionquery_source_navigation(clone._goal_center_point, 0, 450, 450, 100, clone);
	}
	else
	{
		queryresult = positionquery_source_navigation(clone.origin, 500, 750, 750, 50, clone);
	}
	if(queryresult.data.size > 0)
	{
		clone setgoalpos(queryresult.data[0].origin, 1);
		clone._clone_goal = queryresult.data[0].origin;
		clone._clone_goal_max_dist = 450;
	}
	else
	{
		clone._goal_center_point = clone.origin;
	}
	clone thread _updateclonepathing();
	clone hidefromteam(game["defenders"]);
	clone ghost();
	_configurecloneteam(clone, player);
}

/*
	Name: clonedamageoverride
	Namespace: prop
	Checksum: 0x68B21C91
	Offset: 0xC680
	Size: 0x7E
	Parameters: 15
	Flags: None
*/
function clonedamageoverride(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, boneindex, modelindex, surfacetype, surfacenormal)
{
	return false;
}

/*
	Name: _configurecloneteam
	Namespace: prop
	Checksum: 0x70555C38
	Offset: 0xC708
	Size: 0x80
	Parameters: 2
	Flags: None
*/
function _configurecloneteam(clone, player)
{
	team = util::getotherteam(player.team);
	clone.ignoreall = 1;
	clone setteam(team);
	clone.team = team;
}

/*
	Name: function_41d2c44e
	Namespace: prop
	Checksum: 0x10F4D074
	Offset: 0xC790
	Size: 0xFA
	Parameters: 0
	Flags: None
*/
function function_41d2c44e()
{
	var_b71aa5e8 = 10000;
	var_ae1cb2e9 = [];
	foreach(clone in level.var_abcf2d12)
	{
		if(self == clone)
		{
			continue;
		}
		distsq = distancesquared(clone.origin, self.origin);
		if(distsq < var_b71aa5e8)
		{
			var_ae1cb2e9[var_ae1cb2e9.size] = clone;
		}
	}
	return var_ae1cb2e9;
}

/*
	Name: _updateclonepathing
	Namespace: prop
	Checksum: 0x975EEAFF
	Offset: 0xC898
	Size: 0x3D4
	Parameters: 0
	Flags: None
*/
function _updateclonepathing()
{
	self endon(#"death");
	clone_not_moving_dist_sq = 576;
	clone_not_moving_poll_time = 2000;
	var_38da5046 = 1500;
	if(!isdefined(level.var_e5ad813f.var_dffd326e))
	{
		level.var_e5ad813f.var_dffd326e = 0;
	}
	while(true)
	{
		if(!isdefined(self.lastknownpos))
		{
			self.lastknownpos = self.origin;
			self.lastknownpostime = gettime();
		}
		if(!isdefined(self.var_20143a0c))
		{
			self.var_20143a0c = gettime();
		}
		distance = 0;
		if(isdefined(self._clone_goal))
		{
			distance = distancesquared(self._clone_goal, self.origin);
		}
		var_9bac6f63 = 0;
		if(distance < 14400)
		{
			var_9bac6f63 = 1;
		}
		else
		{
			if(!self haspath())
			{
				var_9bac6f63 = 1;
			}
			else
			{
				if((self.lastknownpostime + clone_not_moving_poll_time) <= gettime())
				{
					if(distancesquared(self.lastknownpos, self.origin) < clone_not_moving_dist_sq)
					{
						var_9bac6f63 = 1;
					}
					self.lastknownpos = self.origin;
					self.lastknownpostime = gettime();
				}
				else if((self.var_20143a0c + var_38da5046) <= gettime() && level.var_e5ad813f.var_dffd326e != gettime())
				{
					clones = function_41d2c44e();
					if(clones.size > 0)
					{
						var_9bac6f63 = 1;
					}
					for(i = 0; i < clones.size; i++)
					{
						clones[i].var_20143a0c = gettime();
					}
					self.var_20143a0c = gettime();
				}
			}
		}
		if(var_9bac6f63)
		{
			level.var_e5ad813f.var_dffd326e = gettime();
			self._goal_center_point = function_176b694c();
			queryresult = positionquery_source_navigation(self._goal_center_point, 500, 750, 750, 100, self);
			if(queryresult.data.size == 0)
			{
				queryresult = positionquery_source_navigation(self.origin, 500, 750, 750, 100, self);
			}
			if(queryresult.data.size > 0)
			{
				randindex = randomintrange(0, queryresult.data.size);
				self setgoalpos(queryresult.data[randindex].origin, 1);
				self._clone_goal = queryresult.data[randindex].origin;
				self._clone_goal_max_dist = 750;
			}
		}
		wait(0.5);
	}
}

/*
	Name: function_176b694c
	Namespace: prop
	Checksum: 0xF28BCA49
	Offset: 0xCC78
	Size: 0x8A
	Parameters: 0
	Flags: None
*/
function function_176b694c()
{
	if(level.var_e5ad813f.nextindex >= level.var_e5ad813f.var_753abe12.size)
	{
		level.var_e5ad813f.nextindex = 0;
	}
	location = level.var_e5ad813f.var_753abe12[level.var_e5ad813f.nextindex];
	level.var_e5ad813f.nextindex++;
	return location.origin;
}

/*
	Name: function_16efb8e6
	Namespace: prop
	Checksum: 0x20DC11B7
	Offset: 0xCD10
	Size: 0x1C0
	Parameters: 1
	Flags: None
*/
function function_16efb8e6(origin)
{
	model = function_5f1e8e1b();
	target = spawn("script_model", origin);
	target setmodel(model);
	target.targetname = "propTarget";
	target setcandamage(1);
	target.fakehealth = 50;
	target.health = 99999;
	target.maxhealth = 99999;
	target thread function_500dc7d9(&function_12f9ab17);
	target setplayercollision(0);
	target makesentient();
	target notsolidcapsule();
	target setteam(game["defenders"]);
	target hidefromteam(game["defenders"]);
	target setscale(2, 1);
	thread function_7d3dbc54(target);
	return target;
}

/*
	Name: function_12f9ab17
	Namespace: prop
	Checksum: 0x9A653A5B
	Offset: 0xCED8
	Size: 0xC0
	Parameters: 10
	Flags: None
*/
function function_12f9ab17(damage, attacker, direction_vec, point, meansofdeath, modelname, tagname, partname, weapon, idflags)
{
	if(!isdefined(attacker))
	{
		return;
	}
	if(isplayer(attacker))
	{
		attacker thread damagefeedback::update();
		self.lastattacker = attacker;
		function_a88142c8(attacker);
	}
	self.health = self.health + damage;
}

