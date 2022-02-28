// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\shared\demo_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\math_shared;
#using scripts\shared\medals_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;

#namespace sab;

/*
	Name: main
	Namespace: sab
	Checksum: 0x587C85A1
	Offset: 0xBA0
	Size: 0x48C
	Parameters: 0
	Flags: None
*/
function main()
{
	globallogic::init();
	level.teambased = 1;
	level.overrideteamscore = 1;
	util::registerroundswitch(0, 9);
	util::registertimelimit(0, 1440);
	util::registerscorelimit(0, 500);
	util::registerroundlimit(0, 10);
	util::registernumlives(0, 100);
	util::registerroundwinlimit(0, 10);
	globallogic::registerfriendlyfiredelay(level.gametype, 15, 0, 1440);
	level.onstartgametype = &onstartgametype;
	level.onspawnplayer = &onspawnplayer;
	level.onroundendgame = &onroundendgame;
	gameobjects::register_allowed_gameobject(level.gametype);
	if(!game["tiebreaker"])
	{
		level.onprecachegametype = &onprecachegametype;
		level.ontimelimit = &ontimelimit;
		level.ondeadevent = &ondeadevent;
		level.onroundswitch = &onroundswitch;
		level.onplayerkilled = &onplayerkilled;
		level.endgameonscorelimit = 0;
		game["dialog"]["gametype"] = "sab_start";
		game["dialog"]["gametype_hardcore"] = "hcsab_start";
		game["dialog"]["offense_obj"] = "destroy_start";
		game["dialog"]["defense_obj"] = "destroy_start";
		game["dialog"]["sudden_death"] = "suddendeath";
		game["dialog"]["sudden_death_boost"] = "generic_boost";
	}
	else
	{
		level.onendgame = &onendgame;
		level.endgameonscorelimit = 0;
		game["dialog"]["gametype"] = "sab_start";
		game["dialog"]["gametype_hardcore"] = "hcsab_start";
		game["dialog"]["offense_obj"] = "generic_boost";
		game["dialog"]["defense_obj"] = "generic_boost";
		game["dialog"]["sudden_death"] = "suddendeath";
		game["dialog"]["sudden_death_boost"] = "generic_boost";
		util::registernumlives(1, 1);
		util::registertimelimit(0, 0);
	}
	badtrig = getent("sab_bomb_defuse_allies", "targetname");
	if(isdefined(badtrig))
	{
		badtrig delete();
	}
	badtrig = getent("sab_bomb_defuse_axis", "targetname");
	if(isdefined(badtrig))
	{
		badtrig delete();
	}
	level.lastdialogtime = 0;
	globallogic::setvisiblescoreboardcolumns("score", "kills", "deaths", "plants", "defuses");
}

/*
	Name: onprecachegametype
	Namespace: sab
	Checksum: 0x875D226
	Offset: 0x1038
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function onprecachegametype()
{
	game["bomb_dropped_sound"] = "mp_war_objective_lost";
	game["bomb_recovered_sound"] = "mp_war_objective_taken";
}

/*
	Name: onroundswitch
	Namespace: sab
	Checksum: 0x524FFA1A
	Offset: 0x1070
	Size: 0xD0
	Parameters: 0
	Flags: None
*/
function onroundswitch()
{
	if(!isdefined(game["switchedsides"]))
	{
		game["switchedsides"] = 0;
	}
	if(game["teamScores"]["allies"] == (level.scorelimit - 1) && game["teamScores"]["axis"] == (level.scorelimit - 1))
	{
		level.halftimetype = "overtime";
		level.halftimesubcaption = &"MP_TIE_BREAKER";
		game["tiebreaker"] = 1;
	}
	else
	{
		level.halftimetype = "halftime";
		game["switchedsides"] = !game["switchedsides"];
	}
}

/*
	Name: onstartgametype
	Namespace: sab
	Checksum: 0x6290521B
	Offset: 0x1148
	Size: 0x4DC
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
	if(!isdefined(game["switchedsides"]))
	{
		game["switchedsides"] = 0;
	}
	setclientnamemode("auto_change");
	game["strings"]["target_destroyed"] = &"MP_TARGET_DESTROYED";
	if(!game["tiebreaker"])
	{
		util::setobjectivetext("allies", &"OBJECTIVES_SAB");
		util::setobjectivetext("axis", &"OBJECTIVES_SAB");
		if(level.splitscreen)
		{
			util::setobjectivescoretext("allies", &"OBJECTIVES_SAB");
			util::setobjectivescoretext("axis", &"OBJECTIVES_SAB");
		}
		else
		{
			util::setobjectivescoretext("allies", &"OBJECTIVES_SAB_SCORE");
			util::setobjectivescoretext("axis", &"OBJECTIVES_SAB_SCORE");
		}
		util::setobjectivehinttext("allies", &"OBJECTIVES_SAB_HINT");
		util::setobjectivehinttext("axis", &"OBJECTIVES_SAB_HINT");
	}
	else
	{
		util::setobjectivetext("allies", &"OBJECTIVES_TDM");
		util::setobjectivetext("axis", &"OBJECTIVES_TDM");
		if(level.splitscreen)
		{
			util::setobjectivescoretext("allies", &"OBJECTIVES_TDM");
			util::setobjectivescoretext("axis", &"OBJECTIVES_TDM");
		}
		else
		{
			util::setobjectivescoretext("allies", &"OBJECTIVES_TDM_SCORE");
			util::setobjectivescoretext("axis", &"OBJECTIVES_TDM_SCORE");
		}
		util::setobjectivehinttext("allies", &"OBJECTIVES_TDM_HINT");
		util::setobjectivehinttext("axis", &"OBJECTIVES_TDM_HINT");
	}
	spawning::create_map_placed_influencers();
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	spawnlogic::place_spawn_points("mp_sab_spawn_allies_start");
	spawnlogic::place_spawn_points("mp_sab_spawn_axis_start");
	spawnlogic::add_spawn_points("allies", "mp_sab_spawn_allies");
	spawnlogic::add_spawn_points("axis", "mp_sab_spawn_axis");
	spawning::updateallspawnpoints();
	level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
	setmapcenter(level.mapcenter);
	spawnpoint = spawnlogic::get_random_intermission_point();
	setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
	level.spawn_axis = spawnlogic::get_spawnpoint_array("mp_sab_spawn_axis");
	level.spawn_allies = spawnlogic::get_spawnpoint_array("mp_sab_spawn_allies");
	level.spawn_start = [];
	foreach(team in level.teams)
	{
		level.spawn_start[team] = spawnlogic::get_spawnpoint_array(("mp_sab_spawn_" + team) + "_start");
	}
	thread updategametypedvars();
	thread sabotage();
}

/*
	Name: ontimelimit
	Namespace: sab
	Checksum: 0x65990BC4
	Offset: 0x1630
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function ontimelimit()
{
	if(level.inovertime)
	{
		return;
	}
	thread onovertime();
}

/*
	Name: onovertime
	Namespace: sab
	Checksum: 0x68937BBC
	Offset: 0x1660
	Size: 0x224
	Parameters: 0
	Flags: None
*/
function onovertime()
{
	level endon(#"game_ended");
	level.timelimitoverride = 1;
	level.inovertime = 1;
	globallogic_audio::leader_dialog("sudden_death");
	globallogic_audio::leader_dialog("sudden_death_boost");
	for(index = 0; index < level.players.size; index++)
	{
		level.players[index] notify(#"force_spawn");
		level.players[index] thread hud_message::oldnotifymessage(&"MP_SUDDEN_DEATH", &"MP_NO_RESPAWN", undefined, (1, 0, 0), "mp_last_stand");
		level.players[index] setclientuivisibilityflag("g_compassShowEnemies", 1);
	}
	setmatchtalkflag("DeadChatWithDead", 1);
	setmatchtalkflag("DeadChatWithTeam", 0);
	setmatchtalkflag("DeadHearTeamLiving", 0);
	setmatchtalkflag("DeadHearAllLiving", 0);
	setmatchtalkflag("EveryoneHearsEveryone", 0);
	waittime = 0;
	while(waittime < 90)
	{
		if(!level.bombplanted)
		{
			waittime = waittime + 1;
			setgameendtime(gettime() + ((90 - waittime) * 1000));
		}
		wait(1);
	}
	thread globallogic::endgame("tie", game["strings"]["tie"]);
}

/*
	Name: ondeadevent
	Namespace: sab
	Checksum: 0xFBDDCC73
	Offset: 0x1890
	Size: 0x1BC
	Parameters: 1
	Flags: None
*/
function ondeadevent(team)
{
	if(level.bombexploded)
	{
		return;
	}
	if(team == "all")
	{
		if(level.bombplanted)
		{
			globallogic_score::giveteamscoreforobjective(level.bombplantedby, 1);
			thread globallogic::endgame(level.bombplantedby, game["strings"][level.bombplantedby + "_mission_accomplished"]);
		}
		else
		{
			thread globallogic::endgame("tie", game["strings"]["tie"]);
		}
	}
	else
	{
		if(level.bombplanted)
		{
			if(team == level.bombplantedby)
			{
				level.plantingteamdead = 1;
				return;
			}
			otherteam = util::getotherteam(level.bombplantedby);
			globallogic_score::giveteamscoreforobjective(level.bombplantedby, 1);
			thread globallogic::endgame(level.bombplantedby, game["strings"][otherteam + "_eliminated"]);
		}
		else
		{
			otherteam = util::getotherteam(team);
			globallogic_score::giveteamscoreforobjective(otherteam, 1);
			thread globallogic::endgame(otherteam, game["strings"][team + "_eliminated"]);
		}
	}
}

/*
	Name: onspawnplayer
	Namespace: sab
	Checksum: 0xAB405A65
	Offset: 0x1A58
	Size: 0x124
	Parameters: 1
	Flags: None
*/
function onspawnplayer(predictedspawn)
{
	self.isplanting = 0;
	self.isdefusing = 0;
	self.isbombcarrier = 0;
	if(game["tiebreaker"])
	{
		self thread hud_message::oldnotifymessage(&"MP_TIE_BREAKER", &"MP_NO_RESPAWN", undefined, (1, 0, 0), "mp_last_stand");
		self setclientuivisibilityflag("g_compassShowEnemies", 1);
		setmatchtalkflag("DeadChatWithDead", 1);
		setmatchtalkflag("DeadChatWithTeam", 0);
		setmatchtalkflag("DeadHearTeamLiving", 0);
		setmatchtalkflag("DeadHearAllLiving", 0);
		setmatchtalkflag("EveryoneHearsEveryone", 0);
	}
	spawning::onspawnplayer(predictedspawn);
}

/*
	Name: updategametypedvars
	Namespace: sab
	Checksum: 0x279DAA23
	Offset: 0x1B88
	Size: 0x84
	Parameters: 0
	Flags: None
*/
function updategametypedvars()
{
	level.planttime = getgametypesetting("plantTime");
	level.defusetime = getgametypesetting("defuseTime");
	level.bombtimer = getgametypesetting("bombTimer");
	level.hotpotato = getgametypesetting("hotPotato");
}

/*
	Name: sabotage
	Namespace: sab
	Checksum: 0x1079BFF0
	Offset: 0x1C18
	Size: 0x4B6
	Parameters: 0
	Flags: None
*/
function sabotage()
{
	level.bombplanted = 0;
	level.bombexploded = 0;
	level._effect["bombexplosion"] = "_t6/maps/mp_maps/fx_mp_exp_bomb";
	trigger = getent("sab_bomb_pickup_trig", "targetname");
	if(!isdefined(trigger))
	{
		util::error("No sab_bomb_pickup_trig trigger found in map.");
		return;
	}
	visuals[0] = getent("sab_bomb", "targetname");
	if(!isdefined(visuals[0]))
	{
		util::error("No sab_bomb script_model found in map.");
		return;
	}
	level.sabbomb = gameobjects::create_carry_object("neutral", trigger, visuals, vectorscale((0, 0, 1), 32));
	level.sabbomb gameobjects::allow_carry("any");
	level.sabbomb gameobjects::set_2d_icon("enemy", "compass_waypoint_bomb");
	level.sabbomb gameobjects::set_3d_icon("enemy", "waypoint_bomb");
	level.sabbomb gameobjects::set_2d_icon("friendly", "compass_waypoint_bomb");
	level.sabbomb gameobjects::set_3d_icon("friendly", "waypoint_bomb");
	level.sabbomb gameobjects::set_carry_icon("hud_suitcase_bomb");
	level.sabbomb gameobjects::set_visible_team("any");
	level.sabbomb.objidpingenemy = 1;
	level.sabbomb.onpickup = &onpickup;
	level.sabbomb.ondrop = &ondrop;
	level.sabbomb.allowweapons = 1;
	level.sabbomb.objpoints["allies"].archived = 1;
	level.sabbomb.objpoints["axis"].archived = 1;
	level.sabbomb.autoresettime = 60;
	if(!isdefined(getent("sab_bomb_axis", "targetname")))
	{
		/#
			util::error("");
		#/
		return;
	}
	if(!isdefined(getent("sab_bomb_allies", "targetname")))
	{
		/#
			util::error("");
		#/
		return;
	}
	if(game["switchedsides"])
	{
		level.bombzones["allies"] = createbombzone("allies", getent("sab_bomb_axis", "targetname"));
		level.bombzones["axis"] = createbombzone("axis", getent("sab_bomb_allies", "targetname"));
	}
	else
	{
		level.bombzones["allies"] = createbombzone("allies", getent("sab_bomb_allies", "targetname"));
		level.bombzones["axis"] = createbombzone("axis", getent("sab_bomb_axis", "targetname"));
	}
}

/*
	Name: createbombzone
	Namespace: sab
	Checksum: 0xF05E3A92
	Offset: 0x20D8
	Size: 0x1EA
	Parameters: 2
	Flags: None
*/
function createbombzone(team, trigger)
{
	visuals = getentarray(trigger.target, "targetname");
	bombzone = gameobjects::create_use_object(team, trigger, visuals, vectorscale((0, 0, 1), 64));
	bombzone resetbombsite();
	bombzone.onuse = &onuse;
	bombzone.onbeginuse = &onbeginuse;
	bombzone.onenduse = &onenduse;
	bombzone.oncantuse = &oncantuse;
	bombzone.useweapon = getweapon("briefcase_bomb");
	bombzone.visuals[0].killcament = spawn("script_model", bombzone.visuals[0].origin + vectorscale((0, 0, 1), 128));
	for(i = 0; i < visuals.size; i++)
	{
		if(isdefined(visuals[i].script_exploder))
		{
			bombzone.exploderindex = visuals[i].script_exploder;
			break;
		}
	}
	return bombzone;
}

/*
	Name: onbeginuse
	Namespace: sab
	Checksum: 0x58D0200B
	Offset: 0x22D0
	Size: 0xE4
	Parameters: 1
	Flags: None
*/
function onbeginuse(player)
{
	if(!self gameobjects::is_friendly_team(player.pers["team"]))
	{
		player.isplanting = 1;
		player thread battlechatter::gametype_specific_battle_chatter("sd_friendlyplant", player.pers["team"]);
	}
	else
	{
		player.isdefusing = 1;
		player thread battlechatter::gametype_specific_battle_chatter("sd_enemyplant", player.pers["team"]);
	}
	player playsound("fly_bomb_raise_plr");
}

/*
	Name: onenduse
	Namespace: sab
	Checksum: 0x1E96BDC3
	Offset: 0x23C0
	Size: 0x68
	Parameters: 3
	Flags: None
*/
function onenduse(team, player, result)
{
	if(!isalive(player))
	{
		return;
	}
	player.isplanting = 0;
	player.isdefusing = 0;
	player notify(#"event_ended");
}

/*
	Name: onpickup
	Namespace: sab
	Checksum: 0xD55959EE
	Offset: 0x2430
	Size: 0x404
	Parameters: 1
	Flags: None
*/
function onpickup(player)
{
	level notify(#"bomb_picked_up");
	player recordgameevent("pickup");
	self.autoresettime = 60;
	level.usestartspawns = 0;
	team = player.pers["team"];
	if(team == "allies")
	{
		otherteam = "axis";
	}
	else
	{
		otherteam = "allies";
	}
	player playlocalsound("mp_suitcase_pickup");
	/#
		print("");
	#/
	excludelist[0] = player;
	if((gettime() - level.lastdialogtime) > 10000)
	{
		globallogic_audio::leader_dialog("bomb_acquired", team);
		player globallogic_audio::leader_dialog_on_player("obj_destroy", "bomb");
		if(!level.splitscreen)
		{
			globallogic_audio::leader_dialog("bomb_taken", otherteam);
			globallogic_audio::leader_dialog("obj_defend", otherteam);
		}
		level.lastdialogtime = gettime();
	}
	player.isbombcarrier = 1;
	player addplayerstatwithgametype("PICKUPS", 1);
	if(team == self gameobjects::get_owner_team())
	{
		util::printonteamarg(&"MP_EXPLOSIVES_RECOVERED_BY", team, player);
		sound::play_on_players(game["bomb_recovered_sound"], team);
	}
	else
	{
		util::printonteamarg(&"MP_EXPLOSIVES_RECOVERED_BY", team, player);
		sound::play_on_players(game["bomb_recovered_sound"]);
	}
	self gameobjects::set_owner_team(team);
	self gameobjects::set_visible_team("any");
	self gameobjects::set_2d_icon("enemy", "compass_waypoint_target");
	self gameobjects::set_3d_icon("enemy", "waypoint_kill");
	self gameobjects::set_2d_icon("friendly", "compass_waypoint_defend");
	self gameobjects::set_3d_icon("friendly", "waypoint_defend");
	level.bombzones[team] gameobjects::set_visible_team("none");
	level.bombzones[otherteam] gameobjects::set_visible_team("any");
	level.bombzones[otherteam].trigger setinvisibletoall();
	level.bombzones[otherteam].trigger setvisibletoplayer(player);
}

/*
	Name: ondrop
	Namespace: sab
	Checksum: 0xBBCD7960
	Offset: 0x2840
	Size: 0x184
	Parameters: 1
	Flags: None
*/
function ondrop(player)
{
	if(level.bombplanted)
	{
	}
	else
	{
		if(isdefined(player))
		{
			util::printonteamarg(&"MP_EXPLOSIVES_DROPPED_BY", self gameobjects::get_owner_team(), player);
		}
		sound::play_on_players(game["bomb_dropped_sound"], self gameobjects::get_owner_team());
		/#
			if(isdefined(player))
			{
				print("");
			}
			else
			{
				print("");
			}
		#/
		globallogic_audio::leader_dialog("bomb_lost", self gameobjects::get_owner_team());
		player notify(#"event_ended");
		level.bombzones["axis"].trigger setinvisibletoall();
		level.bombzones["allies"].trigger setinvisibletoall();
		thread abandonmentthink(0);
	}
}

/*
	Name: abandonmentthink
	Namespace: sab
	Checksum: 0xF1F0067F
	Offset: 0x29D0
	Size: 0x1CC
	Parameters: 1
	Flags: None
*/
function abandonmentthink(delay)
{
	level endon(#"bomb_picked_up");
	wait(delay);
	if(isdefined(self.carrier))
	{
		return;
	}
	if(self gameobjects::get_owner_team() == "allies")
	{
		otherteam = "axis";
	}
	else
	{
		otherteam = "allies";
	}
	sound::play_on_players(game["bomb_dropped_sound"], otherteam);
	self gameobjects::set_owner_team("neutral");
	self gameobjects::set_visible_team("any");
	self gameobjects::set_2d_icon("enemy", "compass_waypoint_bomb");
	self gameobjects::set_3d_icon("enemy", "waypoint_bomb");
	self gameobjects::set_2d_icon("friendly", "compass_waypoint_bomb");
	self gameobjects::set_3d_icon("friendly", "waypoint_bomb");
	level.bombzones["allies"] gameobjects::set_visible_team("none");
	level.bombzones["axis"] gameobjects::set_visible_team("none");
}

/*
	Name: onuse
	Namespace: sab
	Checksum: 0xF2333DBF
	Offset: 0x2BA8
	Size: 0x504
	Parameters: 1
	Flags: None
*/
function onuse(player)
{
	team = player.pers["team"];
	otherteam = util::getotherteam(team);
	if(!self gameobjects::is_friendly_team(player.pers["team"]))
	{
		player notify(#"bomb_planted");
		/#
			print("");
		#/
		if(isdefined(player.pers["plants"]))
		{
			player.pers["plants"]++;
			player.plants = player.pers["plants"];
		}
		demo::bookmark("event", gettime(), player);
		player addplayerstatwithgametype("PLANTS", 1);
		level thread popups::displayteammessagetoall(&"MP_EXPLOSIVES_PLANTED_BY", player);
		globallogic_audio::set_music_on_team("ACTION", "both", 1);
		globallogic_audio::leader_dialog("bomb_planted", team);
		globallogic_audio::leader_dialog("bomb_planted", otherteam);
		scoreevents::processscoreevent("planted_bomb", player);
		player recordgameevent("plant");
		level thread bombplanted(self, player.pers["team"]);
		level.bombowner = player;
		player.isbombcarrier = 0;
		level.sabbomb.autoresettime = undefined;
		level.sabbomb gameobjects::allow_carry("none");
		level.sabbomb gameobjects::set_visible_team("none");
		level.sabbomb gameobjects::set_dropped();
		self.useweapon = getweapon("briefcase_bomb_defuse");
		self setupfordefusing();
	}
	else
	{
		player notify(#"bomb_defused");
		/#
			print("");
		#/
		if(isdefined(player.pers["defuses"]))
		{
			player.pers["defuses"]++;
			player.defuses = player.pers["defuses"];
		}
		demo::bookmark("event", gettime(), player);
		player addplayerstatwithgametype("DEFUSES", 1);
		level thread popups::displayteammessagetoall(&"MP_EXPLOSIVES_DEFUSED_BY", player);
		globallogic_audio::leader_dialog("bomb_defused");
		scoreevents::processscoreevent("defused_bomb", player);
		player recordgameevent("defuse");
		level thread bombdefused(self);
		if(level.inovertime && isdefined(level.plantingteamdead))
		{
			thread globallogic::endgame(player.pers["team"], game["strings"][level.bombplantedby + "_eliminated"]);
			return;
		}
		self resetbombsite();
		level.sabbomb gameobjects::allow_carry("any");
		level.sabbomb gameobjects::set_picked_up(player);
	}
}

/*
	Name: oncantuse
	Namespace: sab
	Checksum: 0x22264E29
	Offset: 0x30B8
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function oncantuse(player)
{
	player iprintlnbold(&"MP_CANT_PLANT_WITHOUT_BOMB");
}

/*
	Name: bombplanted
	Namespace: sab
	Checksum: 0x72B78C22
	Offset: 0x30F0
	Size: 0x4DC
	Parameters: 2
	Flags: None
*/
function bombplanted(destroyedobj, team)
{
	game["challenge"][team]["plantedBomb"] = 1;
	globallogic_utils::pausetimer();
	level.bombplanted = 1;
	level.bombplantedby = team;
	level.timelimitoverride = 1;
	setmatchflag("bomb_timer", 1);
	setgameendtime(int(gettime() + (level.bombtimer * 1000)));
	destroyedobj.visuals[0] thread globallogic_utils::playtickingsound("mpl_sab_ui_suitcasebomb_timer");
	starttime = gettime();
	bombtimerwait();
	setmatchflag("bomb_timer", 0);
	destroyedobj.visuals[0] globallogic_utils::stoptickingsound();
	if(!level.bombplanted)
	{
		if(level.hotpotato)
		{
			timepassed = (gettime() - starttime) / 1000;
			level.bombtimer = level.bombtimer - timepassed;
		}
		return;
	}
	explosionorigin = level.sabbomb.visuals[0].origin + vectorscale((0, 0, 1), 12);
	level.bombexploded = 1;
	if(isdefined(level.bombowner))
	{
		destroyedobj.visuals[0] radiusdamage(explosionorigin, 512, 200, 20, level.bombowner, "MOD_EXPLOSIVE", getweapon("briefcase_bomb"));
		level thread popups::displayteammessagetoall(&"MP_EXPLOSIVES_BLOWUP_BY", level.bombowner);
		level.bombowner addplayerstatwithgametype("DESTRUCTIONS", 1);
		scoreevents::processscoreevent("bomb_detonated", level.bombowner);
	}
	else
	{
		destroyedobj.visuals[0] radiusdamage(explosionorigin, 512, 200, 20, undefined, "MOD_EXPLOSIVE", getweapon("briefcase_bomb"));
	}
	rot = randomfloat(360);
	explosioneffect = spawnfx(level._effect["bombexplosion"], explosionorigin + vectorscale((0, 0, 1), 50), (0, 0, 1), (cos(rot), sin(rot), 0));
	triggerfx(explosioneffect);
	thread sound::play_in_space("mpl_sab_exp_suitcase_bomb_main", explosionorigin);
	if(isdefined(destroyedobj.exploderindex))
	{
		exploder::exploder(destroyedobj.exploderindex);
	}
	[[level._setteamscore]](team, [[level._getteamscore]](team) + 1);
	setgameendtime(0);
	level.bombzones["allies"] gameobjects::set_visible_team("none");
	level.bombzones["axis"] gameobjects::set_visible_team("none");
	wait(3);
	thread globallogic::endgame(team, game["strings"]["target_destroyed"]);
}

/*
	Name: bombtimerwait
	Namespace: sab
	Checksum: 0xE35FB9CE
	Offset: 0x35D8
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function bombtimerwait()
{
	level endon(#"bomb_defused");
	hostmigration::waitlongdurationwithgameendtimeupdate(level.bombtimer);
}

/*
	Name: resetbombsite
	Namespace: sab
	Checksum: 0x24F39F4B
	Offset: 0x3608
	Size: 0x19C
	Parameters: 0
	Flags: None
*/
function resetbombsite()
{
	self gameobjects::allow_use("enemy");
	self gameobjects::set_use_time(level.planttime);
	self gameobjects::set_use_text(&"MP_PLANTING_EXPLOSIVE");
	self gameobjects::set_use_hint_text(&"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES");
	self gameobjects::set_key_object(level.sabbomb);
	self gameobjects::set_2d_icon("friendly", "compass_waypoint_defend");
	self gameobjects::set_3d_icon("friendly", "waypoint_defend");
	self gameobjects::set_2d_icon("enemy", "compass_waypoint_target");
	self gameobjects::set_3d_icon("enemy", "waypoint_target");
	self gameobjects::set_visible_team("none");
	self.trigger setinvisibletoall();
	self.useweapon = getweapon("briefcase_bomb");
}

/*
	Name: setupfordefusing
	Namespace: sab
	Checksum: 0xE0B3A417
	Offset: 0x37B0
	Size: 0x174
	Parameters: 0
	Flags: None
*/
function setupfordefusing()
{
	self gameobjects::allow_use("friendly");
	self gameobjects::set_use_time(level.defusetime);
	self gameobjects::set_use_text(&"MP_DEFUSING_EXPLOSIVE");
	self gameobjects::set_use_hint_text(&"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES");
	self gameobjects::set_key_object(undefined);
	self gameobjects::set_2d_icon("friendly", "compass_waypoint_defuse");
	self gameobjects::set_3d_icon("friendly", "waypoint_defuse");
	self gameobjects::set_2d_icon("enemy", "compass_waypoint_defend");
	self gameobjects::set_3d_icon("enemy", "waypoint_defend");
	self gameobjects::set_visible_team("any");
	self.trigger setvisibletoall();
}

/*
	Name: bombdefused
	Namespace: sab
	Checksum: 0x32872E04
	Offset: 0x3930
	Size: 0x62
	Parameters: 1
	Flags: None
*/
function bombdefused(object)
{
	setmatchflag("bomb_timer", 0);
	globallogic_utils::resumetimer();
	level.bombplanted = 0;
	if(!level.inovertime)
	{
		level.timelimitoverride = 0;
	}
	level notify(#"bomb_defused");
}

/*
	Name: onplayerkilled
	Namespace: sab
	Checksum: 0x5E2C4C9A
	Offset: 0x39A0
	Size: 0x3AC
	Parameters: 9
	Flags: None
*/
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	inbombzone = 0;
	inbombzoneteam = "none";
	if(isdefined(level.bombzones["allies"]))
	{
		dist = distance2dsquared(self.origin, level.bombzones["allies"].curorigin);
		if(dist < level.defaultoffenseradiussq)
		{
			inbombzoneteam = "allies";
			inbombzone = 1;
		}
	}
	if(isdefined(level.bombzones["axis"]))
	{
		dist = distance2dsquared(self.origin, level.bombzones["axis"].curorigin);
		if(dist < level.defaultoffenseradiussq)
		{
			inbombzoneteam = "axis";
			inbombzone = 1;
		}
	}
	if(inbombzone && isplayer(attacker) && attacker.pers["team"] != self.pers["team"])
	{
		if(inbombzoneteam == self.pers["team"])
		{
			attacker thread challenges::killedbaseoffender(level.bombzones[inbombzoneteam], weapon);
			self recordkillmodifier("defending");
		}
		else
		{
			if(isdefined(attacker.pers["defends"]))
			{
				attacker.pers["defends"]++;
				attacker.defends = attacker.pers["defends"];
			}
			attacker medals::defenseglobalcount();
			attacker thread challenges::killedbasedefender(level.bombzones[inbombzoneteam]);
			self recordkillmodifier("assaulting");
		}
	}
	if(isplayer(attacker) && attacker.pers["team"] != self.pers["team"] && isdefined(self.isbombcarrier) && self.isbombcarrier == 1)
	{
		self recordkillmodifier("carrying");
	}
	if(self.isplanting == 1)
	{
		self recordkillmodifier("planting");
	}
	if(self.isdefusing == 1)
	{
		self recordkillmodifier("defusing");
	}
}

/*
	Name: onendgame
	Namespace: sab
	Checksum: 0x1EDB1D67
	Offset: 0x3D58
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function onendgame(winningteam)
{
	if(isdefined(winningteam) && (winningteam == "allies" || winningteam == "axis"))
	{
		globallogic_score::giveteamscoreforobjective(winningteam, 1);
	}
}

/*
	Name: onroundendgame
	Namespace: sab
	Checksum: 0xD82A7B7F
	Offset: 0x3DB8
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function onroundendgame(roundwinner)
{
	winner = globallogic::determineteamwinnerbygamestat("roundswon");
	return winner;
}

