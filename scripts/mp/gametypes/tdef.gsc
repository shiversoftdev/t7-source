// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\teams\_teams;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;

#namespace tdef;

/*
	Name: main
	Namespace: tdef
	Checksum: 0x2BA6227C
	Offset: 0x650
	Size: 0x2B6
	Parameters: 0
	Flags: None
*/
function main()
{
	globallogic::init();
	util::registerroundswitch(0, 9);
	util::registertimelimit(0, 1440);
	util::registerscorelimit(0, 10000);
	util::registerroundlimit(0, 10);
	util::registernumlives(0, 100);
	level.matchrules_enemyflagradar = 1;
	level.matchrules_damagemultiplier = 0;
	level.matchrules_vampirism = 0;
	setspecialloadouts();
	level.teambased = 1;
	level.initgametypeawards = &initgametypeawards;
	level.onprecachegametype = &onprecachegametype;
	level.onstartgametype = &onstartgametype;
	level.onplayerkilled = &onplayerkilled;
	level.onspawnplayer = &onspawnplayer;
	level.onroundendgame = &onroundendgame;
	level.onroundswitch = &onroundswitch;
	gameobjects::register_allowed_gameobject(level.gametype);
	gameobjects::register_allowed_gameobject("tdm");
	game["dialog"]["gametype"] = "team_def";
	if(getdvarint("g_hardcore"))
	{
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	}
	game["dialog"]["got_flag"] = "ctf_wetake";
	game["dialog"]["enemy_got_flag"] = "ctf_theytake";
	game["dialog"]["dropped_flag"] = "ctf_wedrop";
	game["dialog"]["enemy_dropped_flag"] = "ctf_theydrop";
	game["strings"]["overtime_hint"] = &"MP_FIRST_BLOOD";
}

/*
	Name: onprecachegametype
	Namespace: tdef
	Checksum: 0x99EC1590
	Offset: 0x910
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function onprecachegametype()
{
}

/*
	Name: onstartgametype
	Namespace: tdef
	Checksum: 0x4C2141DD
	Offset: 0x920
	Size: 0x31C
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
	util::setobjectivetext("allies", &"OBJECTIVES_TDEF");
	util::setobjectivetext("axis", &"OBJECTIVES_TDEF");
	if(level.splitscreen)
	{
		util::setobjectivescoretext("allies", &"OBJECTIVES_TDEF");
		util::setobjectivescoretext("axis", &"OBJECTIVES_TDEF");
	}
	else
	{
		util::setobjectivescoretext("allies", &"OBJECTIVES_TDEF_SCORE");
		util::setobjectivescoretext("axis", &"OBJECTIVES_TDEF_SCORE");
	}
	util::setobjectivehinttext("allies", &"OBJECTIVES_TDEF_ATTACKER_HINT");
	util::setobjectivehinttext("axis", &"OBJECTIVES_TDEF_ATTACKER_HINT");
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	spawnlogic::place_spawn_points("mp_tdm_spawn_allies_start");
	spawnlogic::place_spawn_points("mp_tdm_spawn_axis_start");
	spawnlogic::add_spawn_points("allies", "mp_tdm_spawn");
	spawnlogic::add_spawn_points("axis", "mp_tdm_spawn");
	spawning::updateallspawnpoints();
	level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
	setmapcenter(level.mapcenter);
	spawnpoint = spawnlogic::get_random_intermission_point();
	setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
	if(!util::isoneround())
	{
		level.displayroundendtext = 1;
		if(level.scoreroundwinbased)
		{
			globallogic_score::resetteamscores();
		}
	}
	tdef();
}

/*
	Name: tdef
	Namespace: tdef
	Checksum: 0x5AE1A7E1
	Offset: 0xC48
	Size: 0x86
	Parameters: 0
	Flags: None
*/
function tdef()
{
	level.carryflag["allies"] = teams::get_flag_carry_model("allies");
	level.carryflag["axis"] = teams::get_flag_carry_model("axis");
	level.carryflag["neutral"] = teams::get_flag_model("neutral");
	level.gameflag = undefined;
}

/*
	Name: onplayerkilled
	Namespace: tdef
	Checksum: 0xDA79E75B
	Offset: 0xCD8
	Size: 0x39C
	Parameters: 9
	Flags: None
*/
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	if(!isplayer(attacker) || attacker.team == self.team)
	{
		return;
	}
	victim = self;
	score = rank::getscoreinfovalue("kill");
	/#
		assert(isdefined(score));
	#/
	if(isdefined(level.gameflag) && level.gameflag gameobjects::get_owner_team() == attacker.team)
	{
		if(isdefined(attacker.carryflag))
		{
			attacker addplayerstat("KILLSASFLAGCARRIER", 1);
		}
		score = score * 2;
	}
	else
	{
		if(!isdefined(level.gameflag) && cancreateflagatvictimorigin(victim))
		{
			level.gameflag = createflag(victim);
			score = score + rank::getscoreinfovalue("MEDAL_FIRST_BLOOD");
		}
		else if(isdefined(victim.carryflag))
		{
			killcarrierbonus = rank::getscoreinfovalue("kill_carrier");
			level thread popups::displayteammessagetoall(&"MP_KILLED_FLAG_CARRIER", attacker);
			scoreevents::processscoreevent("kill_flag_carrier", attacker);
			attacker recordgameevent("kill_carrier");
			attacker addplayerstat("FLAGCARRIERKILLS", 1);
			attacker notify(#"objective", "kill_carrier");
			score = score + killcarrierbonus;
		}
	}
	if(!isdefined(killstreaks::get_killstreak_for_weapon(weapon)) || (isdefined(level.killstreaksgivegamescore) && level.killstreaksgivegamescore))
	{
		attacker globallogic_score::giveteamscoreforobjective(attacker.team, score);
	}
	otherteam = util::getotherteam(attacker.team);
	if(game["state"] == "postgame" && game["teamScores"][attacker.team] > game["teamScores"][otherteam])
	{
		attacker.finalkill = 1;
	}
}

/*
	Name: ondrop
	Namespace: tdef
	Checksum: 0xA9387293
	Offset: 0x1080
	Size: 0x344
	Parameters: 1
	Flags: None
*/
function ondrop(player)
{
	if(isdefined(player) && isdefined(player.tdef_flagtime))
	{
		flagtime = int(gettime() - player.tdef_flagtime);
		player addplayerstat("HOLDINGTEAMDEFENDERFLAG", flagtime);
		if(((flagtime / 100) / 60) < 1)
		{
			flagminutes = 0;
		}
		else
		{
			flagminutes = int((flagtime / 100) / 60);
		}
		player addplayerstatwithgametype("DESTRUCTIONS", flagminutes);
		player.tdef_flagtime = undefined;
		player notify(#"dropped_flag");
	}
	team = self gameobjects::get_owner_team();
	otherteam = util::getotherteam(team);
	self.currentcarrier = undefined;
	self gameobjects::set_owner_team("neutral");
	self gameobjects::allow_carry("any");
	self gameobjects::set_visible_team("any");
	self gameobjects::set_2d_icon("friendly", level.iconcaptureflag2d);
	self gameobjects::set_3d_icon("friendly", level.iconcaptureflag3d);
	self gameobjects::set_2d_icon("enemy", level.iconcaptureflag2d);
	self gameobjects::set_3d_icon("enemy", level.iconcaptureflag3d);
	if(isdefined(player))
	{
		if(isdefined(player.carryflag))
		{
			player detachflag();
		}
		util::printandsoundoneveryone(team, undefined, &"MP_NEUTRAL_FLAG_DROPPED_BY", &"MP_NEUTRAL_FLAG_DROPPED_BY", "mp_war_objective_lost", "mp_war_objective_lost", player);
	}
	else
	{
		sound::play_on_players("mp_war_objective_lost", team);
		sound::play_on_players("mp_war_objective_lost", otherteam);
	}
	globallogic_audio::leader_dialog("dropped_flag", team);
	globallogic_audio::leader_dialog("enemy_dropped_flag", otherteam);
}

/*
	Name: onpickup
	Namespace: tdef
	Checksum: 0x34A4199A
	Offset: 0x13D0
	Size: 0x3BC
	Parameters: 1
	Flags: None
*/
function onpickup(player)
{
	self notify(#"picked_up");
	player.tdef_flagtime = gettime();
	player thread watchforendgame();
	score = rank::getscoreinfovalue("capture");
	/#
		assert(isdefined(score));
	#/
	team = player.team;
	otherteam = util::getotherteam(team);
	if(isdefined(level.tdef_loadouts) && isdefined(level.tdef_loadouts[team]))
	{
		player thread applyflagcarrierclass();
	}
	else
	{
		player attachflag();
	}
	self.currentcarrier = player;
	player.carryicon setshader(level.icon2d[team], player.carryicon.width, player.carryicon.height);
	self gameobjects::set_owner_team(team);
	self gameobjects::set_visible_team("any");
	self gameobjects::set_2d_icon("friendly", level.iconescort2d);
	self gameobjects::set_3d_icon("friendly", level.iconescort2d);
	self gameobjects::set_2d_icon("enemy", level.iconkill3d);
	self gameobjects::set_3d_icon("enemy", level.iconkill3d);
	globallogic_audio::leader_dialog("got_flag", team);
	globallogic_audio::leader_dialog("enemy_got_flag", otherteam);
	level thread popups::displayteammessagetoall(&"MP_CAPTURED_THE_FLAG", player);
	scoreevents::processscoreevent("flag_capture", player);
	player recordgameevent("pickup");
	player addplayerstatwithgametype("CAPTURES", 1);
	player notify(#"objective", "captured");
	util::printandsoundoneveryone(team, undefined, &"MP_NEUTRAL_FLAG_CAPTURED_BY", &"MP_NEUTRAL_FLAG_CAPTURED_BY", "mp_obj_captured", "mp_enemy_obj_captured", player);
	if(self.currentteam == otherteam)
	{
		player globallogic_score::giveteamscoreforobjective(team, score);
	}
	self.currentteam = team;
	if(level.matchrules_enemyflagradar)
	{
		self thread flagattachradar(otherteam);
	}
}

/*
	Name: applyflagcarrierclass
	Namespace: tdef
	Checksum: 0x31CA16F
	Offset: 0x1798
	Size: 0x16C
	Parameters: 0
	Flags: None
*/
function applyflagcarrierclass()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	if(isdefined(self.iscarrying) && self.iscarrying == 1)
	{
		self notify(#"force_cancel_placement");
		wait(0.05);
	}
	self.pers["gamemodeLoadout"] = level.tdef_loadouts[self.team];
	spawnpoint = spawn("script_model", self.origin);
	spawnpoint.angles = self.angles;
	spawnpoint.playerspawnpos = self.origin;
	spawnpoint.notti = 1;
	self.setspawnpoint = spawnpoint;
	self.gamemode_chosenclass = self.curclass;
	self.pers["class"] = "gamemode";
	self.pers["lastClass"] = "gamemode";
	self.curclass = "gamemode";
	self.lastclass = "gamemode";
	self thread waitattachflag();
}

/*
	Name: waitattachflag
	Namespace: tdef
	Checksum: 0x7017572A
	Offset: 0x1910
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function waitattachflag()
{
	level endon(#"game_ende");
	self endon(#"disconnect");
	self endon(#"death");
	self waittill(#"spawned_player");
	self attachflag();
}

/*
	Name: watchforendgame
	Namespace: tdef
	Checksum: 0xFA032E3E
	Offset: 0x1968
	Size: 0x104
	Parameters: 0
	Flags: None
*/
function watchforendgame()
{
	self endon(#"dropped_flag");
	self endon(#"disconnect");
	level waittill(#"game_ended");
	if(isdefined(self))
	{
		if(isdefined(self.tdef_flagtime))
		{
			flagtime = int(gettime() - self.tdef_flagtime);
			self addplayerstat("HOLDINGTEAMDEFENDERFLAG", flagtime);
			if(((flagtime / 100) / 60) < 1)
			{
				flagminutes = 0;
			}
			else
			{
				flagminutes = int((flagtime / 100) / 60);
			}
			self addplayerstatwithgametype("DESTRUCTIONS", flagminutes);
		}
	}
}

/*
	Name: cancreateflagatvictimorigin
	Namespace: tdef
	Checksum: 0x815FE153
	Offset: 0x1A78
	Size: 0x180
	Parameters: 1
	Flags: None
*/
function cancreateflagatvictimorigin(victim)
{
	minetriggers = getentarray("minefield", "targetname");
	hurttriggers = getentarray("trigger_hurt", "classname");
	radtriggers = getentarray("radiation", "targetname");
	for(index = 0; index < radtriggers.size; index++)
	{
		if(victim istouching(radtriggers[index]))
		{
			return false;
		}
	}
	for(index = 0; index < minetriggers.size; index++)
	{
		if(victim istouching(minetriggers[index]))
		{
			return false;
		}
	}
	for(index = 0; index < hurttriggers.size; index++)
	{
		if(victim istouching(hurttriggers[index]))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: createflag
	Namespace: tdef
	Checksum: 0x21F1D6F6
	Offset: 0x1C00
	Size: 0x2C0
	Parameters: 1
	Flags: None
*/
function createflag(victim)
{
	visuals[0] = spawn("script_model", victim.origin);
	visuals[0] setmodel(level.carryflag["neutral"]);
	trigger = spawn("trigger_radius", victim.origin, 0, 96, 72);
	gameflag = gameobjects::create_carry_object("neutral", trigger, visuals, vectorscale((0, 0, 1), 85));
	gameflag gameobjects::allow_carry("any");
	gameflag gameobjects::set_visible_team("any");
	gameflag gameobjects::set_2d_icon("enemy", level.iconcaptureflag2d);
	gameflag gameobjects::set_3d_icon("enemy", level.iconcaptureflag3d);
	gameflag gameobjects::set_2d_icon("friendly", level.iconcaptureflag2d);
	gameflag gameobjects::set_3d_icon("friendly", level.iconcaptureflag3d);
	gameflag gameobjects::set_carry_icon(level.icon2d["axis"]);
	gameflag.allowweapons = 1;
	gameflag.onpickup = &onpickup;
	gameflag.onpickupfailed = &onpickup;
	gameflag.ondrop = &ondrop;
	gameflag.oldradius = 96;
	gameflag.currentteam = "none";
	gameflag.requireslos = 1;
	level.favorclosespawnent = gameflag.trigger;
	level.favorclosespawnscalar = 3;
	gameflag thread updatebaseposition();
	return gameflag;
}

/*
	Name: updatebaseposition
	Namespace: tdef
	Checksum: 0xC6A090AB
	Offset: 0x1EC8
	Size: 0x74
	Parameters: 0
	Flags: None
*/
function updatebaseposition()
{
	level endon(#"game_ended");
	while(true)
	{
		if(isdefined(self.safeorigin))
		{
			self.baseorigin = self.safeorigin;
			self.trigger.baseorigin = self.safeorigin;
			self.visuals[0].baseorigin = self.safeorigin;
		}
		wait(0.05);
	}
}

/*
	Name: attachflag
	Namespace: tdef
	Checksum: 0xF9539497
	Offset: 0x1F48
	Size: 0x58
	Parameters: 0
	Flags: None
*/
function attachflag()
{
	self attach(level.carryflag[self.team], "J_spine4", 1);
	self.carryflag = level.carryflag[self.team];
	level.favorclosespawnent = self;
}

/*
	Name: detachflag
	Namespace: tdef
	Checksum: 0x7C14D5F1
	Offset: 0x1FA8
	Size: 0x50
	Parameters: 0
	Flags: None
*/
function detachflag()
{
	self detach(self.carryflag, "J_spine4");
	self.carryflag = undefined;
	level.favorclosespawnent = level.gameflag.trigger;
}

/*
	Name: flagattachradar
	Namespace: tdef
	Checksum: 0x3F6EB463
	Offset: 0x2000
	Size: 0x22
	Parameters: 1
	Flags: None
*/
function flagattachradar(team)
{
	level endon(#"game_ended");
	self endon(#"dropped");
}

/*
	Name: getflagradarowner
	Namespace: tdef
	Checksum: 0x2759AE18
	Offset: 0x2030
	Size: 0xDC
	Parameters: 1
	Flags: None
*/
function getflagradarowner(team)
{
	level endon(#"game_ended");
	self endon(#"dropped");
	while(true)
	{
		foreach(player in level.players)
		{
			if(isalive(player) && player.team == team)
			{
				return player;
			}
		}
		wait(0.05);
	}
}

/*
	Name: flagradarmover
	Namespace: tdef
	Checksum: 0x2E118DC
	Offset: 0x2118
	Size: 0x68
	Parameters: 0
	Flags: None
*/
function flagradarmover()
{
	level endon(#"game_ended");
	self endon(#"dropped");
	self.portable_radar endon(#"death");
	for(;;)
	{
		self.portable_radar moveto(self.currentcarrier.origin, 0.05);
		wait(0.05);
	}
}

/*
	Name: flagwatchradarownerlost
	Namespace: tdef
	Checksum: 0xD9E40943
	Offset: 0x2188
	Size: 0x8C
	Parameters: 0
	Flags: None
*/
function flagwatchradarownerlost()
{
	level endon(#"game_ended");
	self endon(#"dropped");
	radarteam = self.portable_radar.team;
	self.portable_radar.owner util::waittill_any("disconnect", "joined_team", "joined_spectators");
	flagattachradar(radarteam);
}

/*
	Name: onroundendgame
	Namespace: tdef
	Checksum: 0xBB0BE249
	Offset: 0x2220
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function onroundendgame(roundwinner)
{
	winner = globallogic::determineteamwinnerbygamestat("roundswon");
	return winner;
}

/*
	Name: onspawnplayer
	Namespace: tdef
	Checksum: 0x273A74F2
	Offset: 0x2260
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function onspawnplayer(predictedspawn)
{
	self.usingobj = undefined;
	if(level.usestartspawns && !level.ingraceperiod)
	{
		level.usestartspawns = 0;
	}
	spawning::onspawnplayer(predictedspawn);
}

/*
	Name: onroundswitch
	Namespace: tdef
	Checksum: 0x3A26DD0
	Offset: 0x22C0
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function onroundswitch()
{
	game["switchedsides"] = !game["switchedsides"];
}

/*
	Name: initgametypeawards
	Namespace: tdef
	Checksum: 0x99EC1590
	Offset: 0x22E8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function initgametypeawards()
{
}

/*
	Name: setspecialloadouts
	Namespace: tdef
	Checksum: 0x99EC1590
	Offset: 0x22F8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function setspecialloadouts()
{
}

