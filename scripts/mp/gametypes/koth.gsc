// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\medals_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;

#namespace koth;

/*
	Name: main
	Namespace: koth
	Checksum: 0x1A8F2329
	Offset: 0xA00
	Size: 0x512
	Parameters: 0
	Flags: None
*/
function main()
{
	globallogic::init();
	util::registertimelimit(0, 1440);
	util::registerscorelimit(0, 1000);
	util::registernumlives(0, 100);
	util::registerroundswitch(0, 9);
	util::registerroundwinlimit(0, 10);
	globallogic::registerfriendlyfiredelay(level.gametype, 15, 0, 1440);
	level.teambased = 1;
	level.doprematch = 1;
	level.overrideteamscore = 1;
	level.scoreroundwinbased = 1;
	level.kothstarttime = 0;
	level.onstartgametype = &onstartgametype;
	level.playerspawnedcb = &koth_playerspawnedcb;
	level.onroundswitch = &onroundswitch;
	level.onplayerkilled = &onplayerkilled;
	level.onendgame = &onendgame;
	clientfield::register("world", "hardpoint", 1, 5, "int");
	clientfield::register("world", "hardpointteam", 1, 5, "int");
	level.zoneautomovetime = getgametypesetting("autoDestroyTime");
	level.zonespawntime = getgametypesetting("objectiveSpawnTime");
	level.kothmode = getgametypesetting("kothMode");
	level.capturetime = getgametypesetting("captureTime");
	level.destroytime = getgametypesetting("destroyTime");
	level.delayplayer = getgametypesetting("delayPlayer");
	level.randomzonespawn = getgametypesetting("randomObjectiveLocations");
	level.scoreperplayer = getgametypesetting("scorePerPlayer");
	level.timepauseswheninzone = getgametypesetting("timePausesWhenInZone");
	level.iconoffset = vectorscale((0, 0, 1), 32);
	level.onrespawndelay = &getrespawndelay;
	gameobjects::register_allowed_gameobject(level.gametype);
	globallogic_audio::set_leader_gametype_dialog("startHardPoint", "hcStartHardPoint", "objCapture", "objCapture");
	game["objective_gained_sound"] = "mpl_flagcapture_sting_friend";
	game["objective_lost_sound"] = "mpl_flagcapture_sting_enemy";
	game["objective_contested_sound"] = "mpl_flagreturn_sting";
	level.lastdialogtime = 0;
	level.zonespawnqueue = [];
	if(!sessionmodeissystemlink() && !sessionmodeisonlinegame() && issplitscreen())
	{
		globallogic::setvisiblescoreboardcolumns("score", "kills", "objtime", "defends", "deaths");
	}
	else
	{
		globallogic::setvisiblescoreboardcolumns("score", "kills", "deaths", "objtime", "defends");
	}
	/#
		trigs = getentarray("", "");
		foreach(trig in trigs)
		{
			trig delete();
		}
	#/
}

/*
	Name: updateobjectivehintmessages
	Namespace: koth
	Checksum: 0x75D97DA5
	Offset: 0xF20
	Size: 0xDC
	Parameters: 3
	Flags: None
*/
function updateobjectivehintmessages(defenderteam, defendmessage, attackmessage)
{
	foreach(team in level.teams)
	{
		if(defenderteam == team)
		{
			game["strings"]["objective_hint_" + team] = defendmessage;
			continue;
		}
		game["strings"]["objective_hint_" + team] = attackmessage;
	}
}

/*
	Name: updateobjectivehintmessage
	Namespace: koth
	Checksum: 0x6E78DCD5
	Offset: 0x1008
	Size: 0x9C
	Parameters: 1
	Flags: None
*/
function updateobjectivehintmessage(message)
{
	foreach(team in level.teams)
	{
		game["strings"]["objective_hint_" + team] = message;
	}
}

/*
	Name: getrespawndelay
	Namespace: koth
	Checksum: 0x39CE228E
	Offset: 0x10B0
	Size: 0x114
	Parameters: 0
	Flags: None
*/
function getrespawndelay()
{
	self.lowermessageoverride = undefined;
	if(!isdefined(level.zone.gameobject))
	{
		return undefined;
	}
	zoneowningteam = level.zone.gameobject gameobjects::get_owner_team();
	if(self.pers["team"] == zoneowningteam)
	{
		if(!isdefined(level.zonemovetime))
		{
			return undefined;
		}
		timeremaining = (level.zonemovetime - gettime()) / 1000;
		if(!level.playerobjectiveheldrespawndelay)
		{
			return undefined;
		}
		if(level.playerobjectiveheldrespawndelay >= level.zoneautomovetime)
		{
			self.lowermessageoverride = &"MP_WAITING_FOR_HQ";
		}
		if(level.delayplayer)
		{
			return min(level.spawndelay, timeremaining);
		}
		return ceil(timeremaining);
	}
}

/*
	Name: onstartgametype
	Namespace: koth
	Checksum: 0x6A808D44
	Offset: 0x11D0
	Size: 0x4CC
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
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
	globallogic_score::resetteamscores();
	foreach(team in level.teams)
	{
		util::setobjectivetext(team, &"OBJECTIVES_KOTH");
		if(level.splitscreen)
		{
			util::setobjectivescoretext(team, &"OBJECTIVES_KOTH");
			continue;
		}
		util::setobjectivescoretext(team, &"OBJECTIVES_KOTH_SCORE");
	}
	level.kothtotalsecondsinzone = 0;
	level.objectivehintpreparezone = &"MP_CONTROL_KOTH";
	level.objectivehintcapturezone = &"MP_CAPTURE_KOTH";
	level.objectivehintdefendhq = &"MP_DEFEND_KOTH";
	if(level.zonespawntime)
	{
		updateobjectivehintmessage(level.objectivehintpreparezone);
	}
	else
	{
		updateobjectivehintmessage(level.objectivehintcapturezone);
	}
	setclientnamemode("auto_change");
	spawning::create_map_placed_influencers();
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	foreach(team in level.teams)
	{
		spawnlogic::add_spawn_points(team, "mp_tdm_spawn");
		spawnlogic::add_spawn_points(team, "mp_multi_team_spawn");
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
	level.spawn_all = spawnlogic::get_spawnpoint_array("mp_tdm_spawn");
	if(!level.spawn_all.size)
	{
		/#
			println("");
		#/
		callback::abort_level();
		return;
	}
	thread setupzones();
	updategametypedvars();
	thread kothmainloop();
}

/*
	Name: pause_time
	Namespace: koth
	Checksum: 0xF7FE91DA
	Offset: 0x16A8
	Size: 0x30
	Parameters: 0
	Flags: None
*/
function pause_time()
{
	if(level.timepauseswheninzone)
	{
		globallogic_utils::pausetimer();
		level.timerpaused = 1;
	}
}

/*
	Name: resume_time
	Namespace: koth
	Checksum: 0x5BA59B3C
	Offset: 0x16E0
	Size: 0x38
	Parameters: 0
	Flags: None
*/
function resume_time()
{
	if(level.timepauseswheninzone)
	{
		globallogic_utils::resumetimerdiscardoverride(level.kothtotalsecondsinzone * 1000);
		level.timerpaused = 0;
	}
}

/*
	Name: updategametypedvars
	Namespace: koth
	Checksum: 0xF62766A9
	Offset: 0x1720
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function updategametypedvars()
{
	level.playercapturelpm = getgametypesetting("maxPlayerEventsPerMinute");
	level.timepauseswheninzone = getgametypesetting("timePausesWhenInZone");
}

/*
	Name: spawn_first_zone
	Namespace: koth
	Checksum: 0xFEBEB18F
	Offset: 0x1770
	Size: 0x124
	Parameters: 1
	Flags: None
*/
function spawn_first_zone(delay)
{
	if(level.randomzonespawn == 1)
	{
		level.zone = getnextzonefromqueue();
	}
	else
	{
		level.zone = getfirstzone();
	}
	if(isdefined(level.zone))
	{
		/#
			print(((((("" + level.zone.trigorigin[0]) + "") + level.zone.trigorigin[1]) + "") + level.zone.trigorigin[2]) + "");
		#/
		level.zone spawning::enable_influencers(1);
	}
	level.zone.gameobject.trigger allowtacticalinsertion(0);
}

/*
	Name: spawn_next_zone
	Namespace: koth
	Checksum: 0xDC3C2E11
	Offset: 0x18A0
	Size: 0x14C
	Parameters: 0
	Flags: None
*/
function spawn_next_zone()
{
	level.zone.gameobject.trigger allowtacticalinsertion(1);
	if(level.randomzonespawn != 0)
	{
		level.zone = getnextzonefromqueue();
	}
	else
	{
		level.zone = getnextzone();
	}
	if(isdefined(level.zone))
	{
		/#
			print(((((("" + level.zone.trigorigin[0]) + "") + level.zone.trigorigin[1]) + "") + level.zone.trigorigin[2]) + "");
		#/
		level.zone spawning::enable_influencers(1);
	}
	level.zone.gameobject.trigger allowtacticalinsertion(0);
}

/*
	Name: getnumtouching
	Namespace: koth
	Checksum: 0x23F72B25
	Offset: 0x19F8
	Size: 0xA2
	Parameters: 0
	Flags: None
*/
function getnumtouching()
{
	numtouching = 0;
	foreach(team in level.teams)
	{
		numtouching = numtouching + self.numtouching[team];
	}
	return numtouching;
}

/*
	Name: togglezoneeffects
	Namespace: koth
	Checksum: 0x403CE815
	Offset: 0x1AA8
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function togglezoneeffects(enabled)
{
	index = 0;
	if(enabled)
	{
		index = self.script_index;
	}
	level clientfield::set("hardpoint", index);
	level clientfield::set("hardpointteam", 0);
}

/*
	Name: kothcaptureloop
	Namespace: koth
	Checksum: 0xC6B4EA92
	Offset: 0x1B28
	Size: 0x480
	Parameters: 0
	Flags: None
*/
function kothcaptureloop()
{
	level endon(#"game_ended");
	level endon(#"zone_moved");
	level.kothstarttime = gettime();
	while(true)
	{
		level.zone.gameobject gameobjects::allow_use("any");
		level.zone.gameobject gameobjects::set_use_time(level.capturetime);
		level.zone.gameobject gameobjects::set_use_text(&"MP_CAPTURING_OBJECTIVE");
		numtouching = level.zone.gameobject getnumtouching();
		level.zone.gameobject gameobjects::set_visible_team("any");
		level.zone.gameobject gameobjects::set_model_visibility(1);
		level.zone.gameobject gameobjects::must_maintain_claim(0);
		level.zone.gameobject gameobjects::can_contest_claim(1);
		level.zone.gameobject.onuse = &onzonecapture;
		level.zone.gameobject.onbeginuse = &onbeginuse;
		level.zone.gameobject.onenduse = &onenduse;
		level.zone togglezoneeffects(1);
		msg = level util::waittill_any_return("zone_captured", "zone_destroyed", "game_ended", "zone_moved");
		if(msg == "zone_destroyed")
		{
			continue;
		}
		ownerteam = level.zone.gameobject gameobjects::get_owner_team();
		foreach(team in level.teams)
		{
			updateobjectivehintmessages(ownerteam, level.objectivehintdefendhq, level.objectivehintcapturezone);
		}
		level.zone.gameobject gameobjects::allow_use("none");
		level.zone.gameobject.onuse = undefined;
		level.zone.gameobject.onunoccupied = &onzoneunoccupied;
		level.zone.gameobject.oncontested = &onzonecontested;
		level.zone.gameobject.onuncontested = &onzoneuncontested;
		level waittill(#"zone_destroyed", destroy_team);
		if(!level.kothmode || level.zonedestroyedbytimer)
		{
			break;
		}
		thread forcespawnteam(ownerteam);
		if(isdefined(destroy_team))
		{
			level.zone.gameobject gameobjects::set_owner_team(destroy_team);
		}
		else
		{
			level.zone.gameobject gameobjects::set_owner_team("none");
		}
	}
}

/*
	Name: kothmainloop
	Namespace: koth
	Checksum: 0xA7C540E8
	Offset: 0x1FB0
	Size: 0x6A8
	Parameters: 0
	Flags: None
*/
function kothmainloop()
{
	level endon(#"game_ended");
	level.zonerevealtime = -100000;
	zonespawninginstr = &"MP_KOTH_AVAILABLE_IN";
	if(level.kothmode)
	{
		zonedestroyedinfriendlystr = &"MP_HQ_DESPAWN_IN";
		zonedestroyedinenemystr = &"MP_KOTH_MOVING_IN";
	}
	else
	{
		zonedestroyedinfriendlystr = &"MP_HQ_REINFORCEMENTS_IN";
		zonedestroyedinenemystr = &"MP_HQ_DESPAWN_IN";
	}
	spawn_first_zone();
	while(level.inprematchperiod)
	{
		wait(0.05);
	}
	pause_time();
	wait(5);
	setbombtimer("A", 0);
	setmatchflag("bomb_timer_a", 0);
	thread hidetimerdisplayongameend();
	while(true)
	{
		resume_time();
		sound::play_on_players("mp_suitcase_pickup");
		globallogic_audio::leader_dialog("kothLocated", undefined, undefined, "gamemode_objective", undefined, "kothActiveDialogBuffer");
		level.zone.gameobject gameobjects::set_model_visibility(1);
		level.zonerevealtime = gettime();
		if(level.zonespawntime)
		{
			level.zone.gameobject gameobjects::set_visible_team("any");
			level.zone.gameobject gameobjects::set_flags(1);
			updateobjectivehintmessage(level.objectivehintpreparezone);
			setmatchflag("bomb_timer_a", 1);
			setbombtimer("A", int((gettime() + 1000) + (level.zonespawntime * 1000)));
			wait(level.zonespawntime);
			level.zone.gameobject gameobjects::set_flags(0);
			globallogic_audio::leader_dialog("kothOnline", undefined, undefined, "gamemode_objective", undefined, "kothActiveDialogBuffer");
		}
		setmatchflag("bomb_timer_a", 0);
		waittillframeend();
		updateobjectivehintmessage(level.objectivehintcapturezone);
		sound::play_on_players("mpl_hq_cap_us");
		level.zone.gameobject gameobjects::enable_object();
		objective_onentity(level.zone.gameobject.objectiveid, level.zone.objectiveanchor);
		level.zone.gameobject.capturecount = 0;
		if(level.zoneautomovetime)
		{
			thread movezoneaftertime(level.zoneautomovetime);
			setmatchflag("bomb_timer_a", 1);
			setbombtimer("A", int((gettime() + 1000) + (level.zoneautomovetime * 1000)));
		}
		else
		{
			level.zonedestroyedbytimer = 0;
		}
		kothcaptureloop();
		ownerteam = level.zone.gameobject gameobjects::get_owner_team();
		if(level.zone.gameobject.capturecount == 1)
		{
			touchlist = [];
			touchkeys = getarraykeys(level.zone.gameobject.touchlist[ownerteam]);
			for(i = 0; i < touchkeys.size; i++)
			{
				touchlist[touchkeys[i]] = level.zone.gameobject.touchlist[ownerteam][touchkeys[i]];
			}
			thread give_held_credit(touchlist);
		}
		pause_time();
		level.zone spawning::enable_influencers(0);
		level.zone.gameobject.lastcaptureteam = undefined;
		level.zone.gameobject gameobjects::disable_object();
		level.zone.gameobject gameobjects::allow_use("none");
		level.zone.gameobject gameobjects::set_owner_team("neutral");
		level.zone.gameobject gameobjects::set_model_visibility(0);
		level.zone.gameobject gameobjects::must_maintain_claim(0);
		level.zone togglezoneeffects(0);
		level notify(#"zone_reset");
		setmatchflag("bomb_timer_a", 0);
		spawn_next_zone();
		wait(0.5);
		thread forcespawnteam(ownerteam);
		wait(0.5);
	}
}

/*
	Name: hidetimerdisplayongameend
	Namespace: koth
	Checksum: 0x9DB0C64A
	Offset: 0x2660
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function hidetimerdisplayongameend()
{
	level waittill(#"game_ended");
	setmatchflag("bomb_timer_a", 0);
}

/*
	Name: forcespawnteam
	Namespace: koth
	Checksum: 0x5CE0FF71
	Offset: 0x2698
	Size: 0xA6
	Parameters: 1
	Flags: None
*/
function forcespawnteam(team)
{
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!isdefined(player))
		{
			continue;
		}
		if(player.pers["team"] == team)
		{
			player notify(#"force_spawn");
			wait(0.1);
		}
	}
}

/*
	Name: updateteamclientfield
	Namespace: koth
	Checksum: 0x75DBD846
	Offset: 0x2748
	Size: 0xEC
	Parameters: 0
	Flags: None
*/
function updateteamclientfield()
{
	ownerteam = self gameobjects::get_owner_team();
	if(isdefined(self.iscontested) && self.iscontested)
	{
		level clientfield::set("hardpointteam", 3);
	}
	else
	{
		if(ownerteam == "neutral")
		{
			level clientfield::set("hardpointteam", 0);
		}
		else
		{
			if(ownerteam == "allies")
			{
				level clientfield::set("hardpointteam", 1);
			}
			else
			{
				level clientfield::set("hardpointteam", 2);
			}
		}
	}
}

/*
	Name: onbeginuse
	Namespace: koth
	Checksum: 0x458D3B58
	Offset: 0x2840
	Size: 0xAC
	Parameters: 1
	Flags: None
*/
function onbeginuse(player)
{
	ownerteam = self gameobjects::get_owner_team();
	if(ownerteam == "neutral")
	{
		player thread battlechatter::gametype_specific_battle_chatter("hq_protect", player.pers["team"]);
	}
	else
	{
		player thread battlechatter::gametype_specific_battle_chatter("hq_attack", player.pers["team"]);
	}
}

/*
	Name: onenduse
	Namespace: koth
	Checksum: 0x55E6292D
	Offset: 0x28F8
	Size: 0x2C
	Parameters: 3
	Flags: None
*/
function onenduse(team, player, success)
{
	player notify(#"event_ended");
}

/*
	Name: onzonecapture
	Namespace: koth
	Checksum: 0x4C69CA03
	Offset: 0x2930
	Size: 0x4AC
	Parameters: 1
	Flags: None
*/
function onzonecapture(player)
{
	capture_team = player.pers["team"];
	capturetime = gettime();
	/#
		print("");
	#/
	pause_time();
	string = &"MP_KOTH_CAPTURED_BY";
	level.zone.gameobject.iscontested = 0;
	level.usestartspawns = 0;
	if(!isdefined(self.lastcaptureteam) || self.lastcaptureteam != capture_team)
	{
		touchlist = [];
		touchkeys = getarraykeys(self.touchlist[capture_team]);
		for(i = 0; i < touchkeys.size; i++)
		{
			touchlist[touchkeys[i]] = self.touchlist[capture_team][touchkeys[i]];
		}
		thread give_capture_credit(touchlist, string, capturetime, capture_team, self.lastcaptureteam);
	}
	level.kothcapteam = capture_team;
	self gameobjects::set_owner_team(capture_team);
	if(!level.kothmode)
	{
		self gameobjects::set_use_time(level.destroytime);
	}
	foreach(team in level.teams)
	{
		if(team == capture_team)
		{
			if(!isdefined(self.lastcaptureteam) || self.lastcaptureteam != team)
			{
				globallogic_audio::leader_dialog("kothSecured", team, undefined, "gamemode_objective", undefined, "kothActiveDialogBuffer");
				for(index = 0; index < level.players.size; index++)
				{
					player = level.players[index];
					if(player.pers["team"] == team)
					{
						if((player.lastkilltime + 500) > gettime())
						{
							player challenges::killedlastcontester();
						}
					}
				}
			}
			thread sound::play_on_players(game["objective_gained_sound"], team);
			continue;
		}
		if(!isdefined(self.lastcaptureteam))
		{
			globallogic_audio::leader_dialog("kothCaptured", team, undefined, "gamemode_objective", undefined, "kothActiveDialogBuffer");
		}
		else if(self.lastcaptureteam == team)
		{
			globallogic_audio::leader_dialog("kothLost", team, undefined, "gamemode_objective", undefined, "kothActiveDialogBuffer");
		}
		thread sound::play_on_players(game["objective_lost_sound"], team);
	}
	self thread awardcapturepoints(capture_team, self.lastcaptureteam);
	self.capturecount++;
	self.lastcaptureteam = capture_team;
	self gameobjects::must_maintain_claim(1);
	self updateteamclientfield();
	player recordgameevent("hardpoint_captured");
	level notify(#"zone_captured");
	level notify("zone_captured" + capture_team);
	player notify(#"event_ended");
}

/*
	Name: track_capture_time
	Namespace: koth
	Checksum: 0x99EC1590
	Offset: 0x2DE8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function track_capture_time()
{
}

/*
	Name: give_capture_credit
	Namespace: koth
	Checksum: 0x1E384F58
	Offset: 0x2DF8
	Size: 0x2A6
	Parameters: 5
	Flags: None
*/
function give_capture_credit(touchlist, string, capturetime, capture_team, lastcaptureteam)
{
	wait(0.05);
	util::waittillslowprocessallowed();
	players = getarraykeys(touchlist);
	for(i = 0; i < players.size; i++)
	{
		player = touchlist[players[i]].player;
		player updatecapsperminute(lastcaptureteam);
		if(!isscoreboosting(player))
		{
			player challenges::capturedobjective(capturetime, self.trigger);
			if((level.kothstarttime + 3000) > capturetime && level.kothcapteam == capture_team)
			{
				scoreevents::processscoreevent("quickly_secure_point", player);
			}
			scoreevents::processscoreevent("koth_secure", player);
			player recordgameevent("capture");
			level thread popups::displayteammessagetoall(string, player);
			if(isdefined(player.pers["captures"]))
			{
				player.pers["captures"]++;
				player.captures = player.pers["captures"];
			}
			if((level.kothstarttime + 500) > capturetime)
			{
				player challenges::immediatecapture();
			}
			demo::bookmark("event", gettime(), player);
			player addplayerstatwithgametype("CAPTURES", 1);
			continue;
		}
		/#
			player iprintlnbold("");
		#/
	}
}

/*
	Name: give_held_credit
	Namespace: koth
	Checksum: 0xA0B33F20
	Offset: 0x30A8
	Size: 0xA2
	Parameters: 2
	Flags: None
*/
function give_held_credit(touchlist, team)
{
	wait(0.05);
	util::waittillslowprocessallowed();
	players = getarraykeys(touchlist);
	for(i = 0; i < players.size; i++)
	{
		player = touchlist[players[i]].player;
	}
}

/*
	Name: onzonedestroy
	Namespace: koth
	Checksum: 0x95607239
	Offset: 0x3158
	Size: 0x27C
	Parameters: 1
	Flags: None
*/
function onzonedestroy(player)
{
	destroyed_team = player.pers["team"];
	/#
		print("");
	#/
	scoreevents::processscoreevent("zone_destroyed", player);
	player recordgameevent("destroy");
	player addplayerstatwithgametype("DESTRUCTIONS", 1);
	if(isdefined(player.pers["destructions"]))
	{
		player.pers["destructions"]++;
		player.destructions = player.pers["destructions"];
	}
	destroyteammessage = &"MP_HQ_DESTROYED_BY";
	otherteammessage = &"MP_HQ_DESTROYED_BY_ENEMY";
	if(level.kothmode)
	{
		destroyteammessage = &"MP_KOTH_CAPTURED_BY";
		otherteammessage = &"MP_KOTH_CAPTURED_BY_ENEMY";
	}
	level thread popups::displayteammessagetoall(destroyteammessage, player);
	foreach(team in level.teams)
	{
		if(team == destroyed_team)
		{
			globallogic_audio::leader_dialog("koth_secured", team, undefined, "gamemode_objective");
			continue;
		}
		globallogic_audio::leader_dialog("koth_destroyed", team, undefined, "gamemode_objective");
	}
	level notify(#"zone_destroyed", destroyed_team);
	if(level.kothmode)
	{
		level thread awardcapturepoints(destroyed_team);
	}
	player notify(#"event_ended");
}

/*
	Name: onzoneunoccupied
	Namespace: koth
	Checksum: 0x1729B5CC
	Offset: 0x33E0
	Size: 0xAC
	Parameters: 0
	Flags: None
*/
function onzoneunoccupied()
{
	level notify(#"zone_destroyed");
	level.kothcapteam = "neutral";
	level.zone.gameobject.wasleftunoccupied = 1;
	level.zone.gameobject.iscontested = 0;
	level.zone.gameobject recordgameeventnonplayer("hardpoint_empty");
	resume_time();
	self updateteamclientfield();
}

/*
	Name: onzonecontested
	Namespace: koth
	Checksum: 0xFD977AE3
	Offset: 0x3498
	Size: 0x152
	Parameters: 0
	Flags: None
*/
function onzonecontested()
{
	zoneowningteam = self gameobjects::get_owner_team();
	self.wascontested = 1;
	self.iscontested = 1;
	self updateteamclientfield();
	self recordgameeventnonplayer("hardpoint_contested");
	resume_time();
	foreach(team in level.teams)
	{
		if(team == zoneowningteam)
		{
			thread sound::play_on_players(game["objective_contested_sound"], team);
			globallogic_audio::leader_dialog("kothContested", team, undefined, "gamemode_objective", undefined, "kothActiveDialogBuffer");
		}
	}
}

/*
	Name: onzoneuncontested
	Namespace: koth
	Checksum: 0x451FE5AE
	Offset: 0x35F8
	Size: 0xB4
	Parameters: 1
	Flags: None
*/
function onzoneuncontested(lastclaimteam)
{
	/#
		assert(lastclaimteam == level.zone.gameobject gameobjects::get_owner_team());
	#/
	self.iscontested = 0;
	pause_time();
	self gameobjects::set_claim_team(lastclaimteam);
	self updateteamclientfield();
	self recordgameeventnonplayer("hardpoint_uncontested");
}

/*
	Name: movezoneaftertime
	Namespace: koth
	Checksum: 0x5A1579CE
	Offset: 0x36B8
	Size: 0x152
	Parameters: 1
	Flags: None
*/
function movezoneaftertime(time)
{
	level endon(#"game_ended");
	level endon(#"zone_reset");
	level.zonemovetime = gettime() + (time * 1000);
	level.zonedestroyedbytimer = 0;
	wait(time);
	if(!isdefined(level.zone.gameobject.wascontested) || level.zone.gameobject.wascontested == 0)
	{
		if(!isdefined(level.zone.gameobject.wasleftunoccupied) || level.zone.gameobject.wasleftunoccupied == 0)
		{
			zoneowningteam = level.zone.gameobject gameobjects::get_owner_team();
			challenges::controlzoneentirely(zoneowningteam);
		}
	}
	level.zonedestroyedbytimer = 1;
	level.zone.gameobject recordgameeventnonplayer("hardpoint_moved");
	level notify(#"zone_moved");
}

/*
	Name: awardcapturepoints
	Namespace: koth
	Checksum: 0x7293F491
	Offset: 0x3818
	Size: 0x226
	Parameters: 2
	Flags: None
*/
function awardcapturepoints(team, lastcaptureteam)
{
	level endon(#"game_ended");
	level endon(#"zone_destroyed");
	level endon(#"zone_reset");
	level endon(#"zone_moved");
	level notify(#"awardcapturepointsrunning");
	level endon(#"awardcapturepointsrunning");
	seconds = 1;
	score = 1;
	while(!level.gameended)
	{
		wait(seconds);
		hostmigration::waittillhostmigrationdone();
		if(!level.zone.gameobject.iscontested)
		{
			if(level.scoreperplayer)
			{
				score = level.zone.gameobject.numtouching[team];
			}
			globallogic_score::giveteamscoreforobjective(team, score);
			level.kothtotalsecondsinzone++;
			foreach(player in level.aliveplayers[team])
			{
				if(!isdefined(player.touchtriggers[self.entnum]))
				{
					continue;
				}
				if(isdefined(player.pers["objtime"]))
				{
					player.pers["objtime"]++;
					player.objtime = player.pers["objtime"];
				}
				player addplayerstatwithgametype("OBJECTIVE_TIME", 1);
			}
		}
	}
}

/*
	Name: koth_playerspawnedcb
	Namespace: koth
	Checksum: 0x229817D7
	Offset: 0x3A48
	Size: 0xE
	Parameters: 0
	Flags: None
*/
function koth_playerspawnedcb()
{
	self.lowermessageoverride = undefined;
}

/*
	Name: comparezoneindexes
	Namespace: koth
	Checksum: 0xC24EAA0
	Offset: 0x3A60
	Size: 0x10E
	Parameters: 2
	Flags: None
*/
function comparezoneindexes(zone_a, zone_b)
{
	script_index_a = zone_a.script_index;
	script_index_b = zone_b.script_index;
	if(!isdefined(script_index_a) && !isdefined(script_index_b))
	{
		return false;
	}
	if(!isdefined(script_index_a) && isdefined(script_index_b))
	{
		/#
			println("" + zone_a.origin);
		#/
		return true;
	}
	if(isdefined(script_index_a) && !isdefined(script_index_b))
	{
		/#
			println("" + zone_b.origin);
		#/
		return false;
	}
	if(script_index_a > script_index_b)
	{
		return true;
	}
	return false;
}

/*
	Name: getzonearray
	Namespace: koth
	Checksum: 0x7E268296
	Offset: 0x3B78
	Size: 0x132
	Parameters: 0
	Flags: None
*/
function getzonearray()
{
	zones = getentarray("koth_zone_center", "targetname");
	if(!isdefined(zones))
	{
		return undefined;
	}
	swapped = 1;
	n = zones.size;
	while(swapped)
	{
		swapped = 0;
		for(i = 0; i < (n - 1); i++)
		{
			if(comparezoneindexes(zones[i], zones[i + 1]))
			{
				temp = zones[i];
				zones[i] = zones[i + 1];
				zones[i + 1] = temp;
				swapped = 1;
			}
		}
		n--;
	}
	return zones;
}

/*
	Name: setupzones
	Namespace: koth
	Checksum: 0xAFA7D42
	Offset: 0x3CB8
	Size: 0x4E8
	Parameters: 0
	Flags: None
*/
function setupzones()
{
	maperrors = [];
	zones = getzonearray();
	trigs = getentarray("koth_zone_trigger", "targetname");
	for(i = 0; i < zones.size; i++)
	{
		errored = 0;
		zone = zones[i];
		zone.trig = undefined;
		for(j = 0; j < trigs.size; j++)
		{
			if(zone istouching(trigs[j]))
			{
				if(isdefined(zone.trig))
				{
					maperrors[maperrors.size] = ("Zone at " + zone.origin) + " is touching more than one \"zonetrigger\" trigger";
					errored = 1;
					break;
				}
				zone.trig = trigs[j];
				break;
			}
		}
		if(!isdefined(zone.trig))
		{
			if(!errored)
			{
				maperrors[maperrors.size] = ("Zone at " + zone.origin) + " is not inside any \"zonetrigger\" trigger";
				continue;
			}
		}
		/#
			assert(!errored);
		#/
		zone.trigorigin = zone.trig.origin;
		zone.objectiveanchor = spawn("script_model", zone.origin);
		visuals = [];
		visuals[0] = zone;
		if(isdefined(zone.target))
		{
			othervisuals = getentarray(zone.target, "targetname");
			for(j = 0; j < othervisuals.size; j++)
			{
				visuals[visuals.size] = othervisuals[j];
			}
		}
		objective_name = istring("hardpoint");
		zone.gameobject = gameobjects::create_use_object("neutral", zone.trig, visuals, (0, 0, 0), objective_name);
		zone.gameobject gameobjects::set_objective_entity(zone);
		zone.gameobject gameobjects::disable_object();
		zone.gameobject gameobjects::set_model_visibility(0);
		zone.trig.useobj = zone.gameobject;
		zone.trig.remote_control_player_can_trigger = 1;
		zone setupnearbyspawns();
		zone createzonespawninfluencer();
	}
	if(maperrors.size > 0)
	{
		/#
			println("");
			for(i = 0; i < maperrors.size; i++)
			{
				println(maperrors[i]);
			}
			println("");
			util::error("");
		#/
		callback::abort_level();
		return;
	}
	level.zones = zones;
	level.prevzone = undefined;
	level.prevzone2 = undefined;
	setupzoneexclusions();
	return true;
}

/*
	Name: setupzoneexclusions
	Namespace: koth
	Checksum: 0x2DD0A9
	Offset: 0x41A8
	Size: 0x1E8
	Parameters: 0
	Flags: None
*/
function setupzoneexclusions()
{
	if(!isdefined(level.levelkothdisable))
	{
		return;
	}
	foreach(nullzone in level.levelkothdisable)
	{
		mindist = 1410065408;
		foundzone = undefined;
		foreach(zone in level.zones)
		{
			distance = distancesquared(nullzone.origin, zone.origin);
			if(distance < mindist)
			{
				foundzone = zone;
				mindist = distance;
			}
		}
		if(isdefined(foundzone))
		{
			if(!isdefined(foundzone.gameobject.exclusions))
			{
				foundzone.gameobject.exclusions = [];
			}
			foundzone.gameobject.exclusions[foundzone.gameobject.exclusions.size] = nullzone;
		}
	}
}

/*
	Name: setupnearbyspawns
	Namespace: koth
	Checksum: 0xF4D04889
	Offset: 0x4398
	Size: 0x2A4
	Parameters: 0
	Flags: None
*/
function setupnearbyspawns()
{
	spawns = level.spawn_all;
	for(i = 0; i < spawns.size; i++)
	{
		spawns[i].distsq = distancesquared(spawns[i].origin, self.origin);
	}
	for(i = 1; i < spawns.size; i++)
	{
		thespawn = spawns[i];
		for(j = i - 1; j >= 0 && thespawn.distsq < spawns[j].distsq; j--)
		{
			spawns[j + 1] = spawns[j];
		}
		spawns[j + 1] = thespawn;
	}
	first = [];
	second = [];
	var_d9ac65f8 = [];
	outer = [];
	thirdsize = spawns.size / 3;
	for(i = 0; i <= thirdsize; i++)
	{
		first[first.size] = spawns[i];
	}
	while(i < spawns.size)
	{
		outer[outer.size] = spawns[i];
		if(i <= (thirdsize * 2))
		{
			second[second.size] = spawns[i];
		}
		else
		{
			var_d9ac65f8[var_d9ac65f8.size] = spawns[i];
		}
		i++;
	}
	self.gameobject.nearspawns = first;
	self.gameobject.midspawns = second;
	self.gameobject.farspawns = var_d9ac65f8;
	self.gameobject.outerspawns = outer;
}

/*
	Name: getfirstzone
	Namespace: koth
	Checksum: 0xCB81A096
	Offset: 0x4648
	Size: 0x80
	Parameters: 0
	Flags: None
*/
function getfirstzone()
{
	zone = level.zones[0];
	level.prevzone2 = level.prevzone;
	level.prevzone = zone;
	level.prevzoneindex = 0;
	shufflezones();
	arrayremovevalue(level.zonespawnqueue, zone);
	return zone;
}

/*
	Name: getnextzone
	Namespace: koth
	Checksum: 0x14F4BFEB
	Offset: 0x46D0
	Size: 0x70
	Parameters: 0
	Flags: None
*/
function getnextzone()
{
	nextzoneindex = (level.prevzoneindex + 1) % level.zones.size;
	zone = level.zones[nextzoneindex];
	level.prevzone2 = level.prevzone;
	level.prevzone = zone;
	level.prevzoneindex = nextzoneindex;
	return zone;
}

/*
	Name: pickrandomzonetospawn
	Namespace: koth
	Checksum: 0xE92FAF7A
	Offset: 0x4748
	Size: 0x6C
	Parameters: 0
	Flags: None
*/
function pickrandomzonetospawn()
{
	level.prevzoneindex = randomint(level.zones.size);
	zone = level.zones[level.prevzoneindex];
	level.prevzone2 = level.prevzone;
	level.prevzone = zone;
	return zone;
}

/*
	Name: shufflezones
	Namespace: koth
	Checksum: 0x1F80713E
	Offset: 0x47C0
	Size: 0x146
	Parameters: 0
	Flags: None
*/
function shufflezones()
{
	level.zonespawnqueue = [];
	spawnqueue = arraycopy(level.zones);
	for(total_left = spawnqueue.size; total_left > 0; total_left--)
	{
		index = randomint(total_left);
		valid_zones = 0;
		for(zone = 0; zone < level.zones.size; zone++)
		{
			if(!isdefined(spawnqueue[zone]))
			{
				continue;
			}
			if(valid_zones == index)
			{
				if(level.zonespawnqueue.size == 0 && isdefined(level.zone) && level.zone == spawnqueue[zone])
				{
					continue;
				}
				level.zonespawnqueue[level.zonespawnqueue.size] = spawnqueue[zone];
				spawnqueue[zone] = undefined;
				break;
			}
			valid_zones++;
		}
	}
}

/*
	Name: getnextzonefromqueue
	Namespace: koth
	Checksum: 0xA047282E
	Offset: 0x4910
	Size: 0x88
	Parameters: 0
	Flags: None
*/
function getnextzonefromqueue()
{
	if(level.zonespawnqueue.size == 0)
	{
		shufflezones();
	}
	/#
		assert(level.zonespawnqueue.size > 0);
	#/
	next_zone = level.zonespawnqueue[0];
	arrayremoveindex(level.zonespawnqueue, 0);
	return next_zone;
}

/*
	Name: getcountofteamswithplayers
	Namespace: koth
	Checksum: 0xAF9ECFA6
	Offset: 0x49A0
	Size: 0xA8
	Parameters: 1
	Flags: None
*/
function getcountofteamswithplayers(num)
{
	has_players = 0;
	foreach(team in level.teams)
	{
		if(num[team] > 0)
		{
			has_players++;
		}
	}
	return has_players;
}

/*
	Name: getpointcost
	Namespace: koth
	Checksum: 0x554A1C5
	Offset: 0x4A50
	Size: 0x19A
	Parameters: 2
	Flags: None
*/
function getpointcost(avgpos, origin)
{
	avg_distance = 0;
	total_error = 0;
	distances = [];
	foreach(team, position in avgpos)
	{
		distances[team] = distance(origin, avgpos[team]);
		avg_distance = avg_distance + distances[team];
	}
	avg_distance = avg_distance / distances.size;
	foreach(team, dist in distances)
	{
		err = distances[team] - avg_distance;
		total_error = total_error + (err * err);
	}
	return total_error;
}

/*
	Name: pickzonetospawn
	Namespace: koth
	Checksum: 0x7294687F
	Offset: 0x4BF8
	Size: 0x43C
	Parameters: 0
	Flags: None
*/
function pickzonetospawn()
{
	foreach(team in level.teams)
	{
		avgpos[team] = (0, 0, 0);
		num[team] = 0;
	}
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(isalive(player))
		{
			avgpos[player.pers["team"]] = avgpos[player.pers["team"]] + player.origin;
			num[player.pers["team"]]++;
		}
	}
	if(getcountofteamswithplayers(num) <= 1)
	{
		zone = level.zones[randomint(level.zones.size)];
		while(isdefined(level.prevzone) && zone == level.prevzone)
		{
			zone = level.zones[randomint(level.zones.size)];
		}
		level.prevzone2 = level.prevzone;
		level.prevzone = zone;
		return zone;
	}
	foreach(team in level.teams)
	{
		if(num[team] == 0)
		{
			avgpos[team] = undefined;
			continue;
		}
		avgpos[team] = avgpos[team] / num[team];
	}
	bestzone = undefined;
	lowestcost = undefined;
	for(i = 0; i < level.zones.size; i++)
	{
		zone = level.zones[i];
		cost = getpointcost(avgpos, zone.origin);
		if(isdefined(level.prevzone) && zone == level.prevzone)
		{
			continue;
		}
		if(isdefined(level.prevzone2) && zone == level.prevzone2)
		{
			if(level.zones.size > 2)
			{
				continue;
			}
			else
			{
				cost = cost + 262144;
			}
		}
		if(!isdefined(lowestcost) || cost < lowestcost)
		{
			lowestcost = cost;
			bestzone = zone;
		}
	}
	/#
		assert(isdefined(bestzone));
	#/
	level.prevzone2 = level.prevzone;
	level.prevzone = bestzone;
	return bestzone;
}

/*
	Name: onroundswitch
	Namespace: koth
	Checksum: 0x3A1EBDDD
	Offset: 0x5040
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function onroundswitch()
{
	game["switchedsides"] = !game["switchedsides"];
}

/*
	Name: onplayerkilled
	Namespace: koth
	Checksum: 0x8162B882
	Offset: 0x5068
	Size: 0x714
	Parameters: 9
	Flags: None
*/
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	if(!isplayer(attacker) || (level.capturetime && !self.touchtriggers.size && !attacker.touchtriggers.size) || attacker.pers["team"] == self.pers["team"])
	{
		return;
	}
	medalgiven = 0;
	scoreeventprocessed = 0;
	ownerteam = undefined;
	if(level.capturetime == 0)
	{
		if(!isdefined(level.zone))
		{
			return;
		}
		ownerteam = level.zone.gameobject.ownerteam;
		if(!isdefined(ownerteam) || ownerteam == "neutral")
		{
			return;
		}
	}
	if(self.touchtriggers.size || (level.capturetime == 0 && self istouching(level.zone.trig)))
	{
		if(level.capturetime > 0)
		{
			triggerids = getarraykeys(self.touchtriggers);
			ownerteam = self.touchtriggers[triggerids[0]].useobj.ownerteam;
		}
		if(ownerteam != "neutral")
		{
			attacker.lastkilltime = gettime();
			team = attacker.pers["team"];
			if(team == ownerteam)
			{
				if(!medalgiven)
				{
					attacker medals::offenseglobalcount();
					attacker thread challenges::killedbaseoffender(level.zone.trig, weapon);
					medalgiven = 1;
				}
				scoreevents::processscoreevent("hardpoint_kill", attacker, undefined, weapon);
				self recordkillmodifier("defending");
				scoreeventprocessed = 1;
			}
			else
			{
				if(!medalgiven)
				{
					if(isdefined(attacker.pers["defends"]))
					{
						attacker.pers["defends"]++;
						attacker.defends = attacker.pers["defends"];
					}
					attacker medals::defenseglobalcount();
					medalgiven = 1;
					attacker thread challenges::killedbasedefender(level.zone.trig);
					attacker recordgameevent("defending");
				}
				attacker challenges::killedzoneattacker(weapon);
				scoreevents::processscoreevent("hardpoint_kill", attacker, undefined, weapon);
				self recordkillmodifier("assaulting");
				scoreeventprocessed = 1;
			}
		}
	}
	if(attacker.touchtriggers.size || (level.capturetime == 0 && attacker istouching(level.zone.trig)))
	{
		if(level.capturetime > 0)
		{
			triggerids = getarraykeys(attacker.touchtriggers);
			ownerteam = attacker.touchtriggers[triggerids[0]].useobj.ownerteam;
		}
		if(ownerteam != "neutral")
		{
			team = self.pers["team"];
			if(team == ownerteam)
			{
				if(!medalgiven)
				{
					if(isdefined(attacker.pers["defends"]))
					{
						attacker.pers["defends"]++;
						attacker.defends = attacker.pers["defends"];
					}
					attacker medals::defenseglobalcount();
					medalgiven = 1;
					attacker thread challenges::killedbasedefender(level.zone.trig);
					attacker recordgameevent("defending");
				}
				if(scoreeventprocessed == 0)
				{
					attacker challenges::killedzoneattacker(weapon);
					scoreevents::processscoreevent("hardpoint_kill", attacker, undefined, weapon);
					self recordkillmodifier("assaulting");
				}
			}
			else
			{
				if(!medalgiven)
				{
					attacker medals::offenseglobalcount();
					medalgiven = 1;
					attacker thread challenges::killedbaseoffender(level.zone.trig, weapon);
				}
				if(scoreeventprocessed == 0)
				{
					scoreevents::processscoreevent("hardpoint_kill", attacker, undefined, weapon);
					self recordkillmodifier("defending");
				}
			}
		}
	}
	if(medalgiven == 1)
	{
		if(isdefined(level.zone.gameobject.iscontested) && level.zone.gameobject.iscontested)
		{
			attacker thread killwhilecontesting();
		}
	}
}

/*
	Name: watchkillwhilecontesting
	Namespace: koth
	Checksum: 0x4345BDE2
	Offset: 0x5788
	Size: 0x6A
	Parameters: 1
	Flags: None
*/
function watchkillwhilecontesting(zone_captured_team)
{
	level endon(zone_captured_team);
	level endon(#"zone_destroyed");
	level endon(#"zone_captured");
	level endon(#"death");
	self util::waittill_any_return("killWhileContesting", "disconnect");
	level notify(#"abortkillwhilecontesting");
}

/*
	Name: killwhilecontesting
	Namespace: koth
	Checksum: 0xFC535923
	Offset: 0x5800
	Size: 0x170
	Parameters: 0
	Flags: None
*/
function killwhilecontesting()
{
	self notify(#"killwhilecontesting");
	self endon(#"killwhilecontesting");
	self endon(#"disconnect");
	killtime = gettime();
	playerteam = self.pers["team"];
	if(!isdefined(self.clearenemycount))
	{
		self.clearenemycount = 0;
	}
	self.clearenemycount++;
	zone_captured_team = "zone_captured" + playerteam;
	self thread watchkillwhilecontesting(zone_captured_team);
	zonereturn = level util::waittill_any_return(zone_captured_team, "zone_destroyed", "zone_captured", "death", "abortKillWhileContesting");
	if(zonereturn == "death" || playerteam != self.pers["team"])
	{
		self.clearenemycount = 0;
		return;
	}
	if(self.clearenemycount >= 2 && (killtime + 200) > gettime())
	{
		scoreevents::processscoreevent("clear_2_attackers", self);
	}
	self.clearenemycount = 0;
}

/*
	Name: onendgame
	Namespace: koth
	Checksum: 0x1EE6E1C7
	Offset: 0x5978
	Size: 0x66
	Parameters: 1
	Flags: None
*/
function onendgame(winningteam)
{
	for(i = 0; i < level.zones.size; i++)
	{
		level.zones[i].gameobject gameobjects::allow_use("none");
	}
}

/*
	Name: createzonespawninfluencer
	Namespace: koth
	Checksum: 0xFF95F58D
	Offset: 0x59E8
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function createzonespawninfluencer()
{
	self spawning::create_influencer("koth_large", self.gameobject.curorigin, 0);
	self spawning::create_influencer("koth_small", self.gameobject.curorigin, 0);
	self spawning::enable_influencers(0);
}

/*
	Name: updatecapsperminute
	Namespace: koth
	Checksum: 0xF1DE8493
	Offset: 0x5A70
	Size: 0x114
	Parameters: 1
	Flags: None
*/
function updatecapsperminute(lastownerteam)
{
	if(!isdefined(self.capsperminute))
	{
		self.numcaps = 0;
		self.capsperminute = 0;
	}
	if(!isdefined(lastownerteam) || lastownerteam == "neutral")
	{
		return;
	}
	self.numcaps++;
	minutespassed = globallogic_utils::gettimepassed() / 60000;
	if(isplayer(self) && isdefined(self.timeplayed["total"]))
	{
		minutespassed = self.timeplayed["total"] / 60;
	}
	self.capsperminute = (minutespassed ? self.numcaps / minutespassed : 0);
	if(self.capsperminute > self.numcaps)
	{
		self.capsperminute = self.numcaps;
	}
}

/*
	Name: isscoreboosting
	Namespace: koth
	Checksum: 0x210A14C
	Offset: 0x5B90
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function isscoreboosting(player)
{
	if(!level.rankedmatch)
	{
		return false;
	}
	if(player.capsperminute > level.playercapturelpm)
	{
		return true;
	}
	return false;
}

