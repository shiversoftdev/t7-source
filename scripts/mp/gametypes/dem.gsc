// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_dogtags;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_spawn;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\gametypes\_spectating;
#using scripts\shared\challenges_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\medals_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;

#namespace dem;

/*
	Name: main
	Namespace: dem
	Checksum: 0x16CBE8F6
	Offset: 0xE28
	Size: 0x394
	Parameters: 0
	Flags: None
*/
function main()
{
	globallogic::init();
	util::registerroundswitch(0, 9);
	util::registertimelimit(0, 1440);
	util::registerscorelimit(0, 500);
	util::registerroundlimit(0, 12);
	util::registerroundwinlimit(0, 10);
	util::registernumlives(0, 100);
	globallogic::registerfriendlyfiredelay(level.gametype, 15, 0, 1440);
	level.teambased = 1;
	level.overrideteamscore = 1;
	level.onprecachegametype = &onprecachegametype;
	level.onstartgametype = &onstartgametype;
	level.onspawnplayer = &onspawnplayer;
	level.playerspawnedcb = &dem_playerspawnedcb;
	level.onplayerkilled = &onplayerkilled;
	level.ondeadevent = &ondeadevent;
	level.ononeleftevent = &ononeleftevent;
	level.ontimelimit = &ontimelimit;
	level.onroundswitch = &onroundswitch;
	level.getteamkillpenalty = &dem_getteamkillpenalty;
	level.getteamkillscore = &dem_getteamkillscore;
	level.gettimelimit = &gettimelimit;
	level.shouldplayovertimeround = &shouldplayovertimeround;
	level.lastbombexplodetime = undefined;
	level.lastbombexplodebyteam = undefined;
	level.ddbombmodel = [];
	level.endgameonscorelimit = 0;
	level.dembombzonename = "bombzone_dem";
	gameobjects::register_allowed_gameobject(level.gametype);
	gameobjects::register_allowed_gameobject("sd");
	gameobjects::register_allowed_gameobject("blocker");
	gameobjects::register_allowed_gameobject(level.dembombzonename);
	globallogic_audio::set_leader_gametype_dialog("startDemolition", "hcStartDemolition", "objDestroy", "objDefend");
	if(!sessionmodeissystemlink() && !sessionmodeisonlinegame() && issplitscreen())
	{
		globallogic::setvisiblescoreboardcolumns("score", "kills", "plants", "defuses", "deaths");
	}
	else
	{
		globallogic::setvisiblescoreboardcolumns("score", "kills", "deaths", "plants", "defuses");
	}
}

/*
	Name: onprecachegametype
	Namespace: dem
	Checksum: 0x98C17885
	Offset: 0x11C8
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function onprecachegametype()
{
	game["bombmodelname"] = "t5_weapon_briefcase_bomb_world";
	game["bombmodelnameobj"] = "t5_weapon_briefcase_bomb_world";
	game["bomb_dropped_sound"] = "fly_bomb_drop_plr";
	game["bomb_recovered_sound"] = "fly_bomb_pickup_plr";
}

/*
	Name: dem_getteamkillpenalty
	Namespace: dem
	Checksum: 0xF7365E5C
	Offset: 0x1228
	Size: 0x96
	Parameters: 4
	Flags: None
*/
function dem_getteamkillpenalty(einflictor, attacker, smeansofdeath, weapon)
{
	teamkill_penalty = globallogic_defaults::default_getteamkillpenalty(einflictor, attacker, smeansofdeath, weapon);
	if(isdefined(self.isdefusing) && self.isdefusing || (isdefined(self.isplanting) && self.isplanting))
	{
		teamkill_penalty = teamkill_penalty * level.teamkillpenaltymultiplier;
	}
	return teamkill_penalty;
}

/*
	Name: dem_getteamkillscore
	Namespace: dem
	Checksum: 0x34D2E3D4
	Offset: 0x12C8
	Size: 0xA2
	Parameters: 4
	Flags: None
*/
function dem_getteamkillscore(einflictor, attacker, smeansofdeath, weapon)
{
	teamkill_score = rank::getscoreinfovalue("team_kill");
	if(isdefined(self.isdefusing) && self.isdefusing || (isdefined(self.isplanting) && self.isplanting))
	{
		teamkill_score = teamkill_score * level.teamkillscoremultiplier;
	}
	return int(teamkill_score);
}

/*
	Name: onroundswitch
	Namespace: dem
	Checksum: 0xC89257BC
	Offset: 0x1378
	Size: 0x128
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
		aheadteam = getbetterteam();
		if(aheadteam != game["defenders"])
		{
			game["switchedsides"] = !game["switchedsides"];
		}
		level.halftimetype = "overtime";
		if(isdefined(level.bombzones[1]))
		{
			level.bombzones[1] gameobjects::disable_object();
		}
	}
	else
	{
		level.halftimetype = "halftime";
		game["switchedsides"] = !game["switchedsides"];
	}
}

/*
	Name: getbetterteam
	Namespace: dem
	Checksum: 0xC43F6717
	Offset: 0x14A8
	Size: 0x20A
	Parameters: 0
	Flags: None
*/
function getbetterteam()
{
	kills["allies"] = 0;
	kills["axis"] = 0;
	deaths["allies"] = 0;
	deaths["axis"] = 0;
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		team = player.pers["team"];
		if(isdefined(team) && (team == "allies" || team == "axis"))
		{
			kills[team] = kills[team] + player.kills;
			deaths[team] = deaths[team] + player.deaths;
		}
	}
	if(kills["allies"] > kills["axis"])
	{
		return "allies";
	}
	if(kills["axis"] > kills["allies"])
	{
		return "axis";
	}
	if(deaths["allies"] < deaths["axis"])
	{
		return "allies";
	}
	if(deaths["axis"] < deaths["allies"])
	{
		return "axis";
	}
	if(randomint(2) == 0)
	{
		return "allies";
	}
	return "axis";
}

/*
	Name: onstartgametype
	Namespace: dem
	Checksum: 0x2CF1A558
	Offset: 0x16C0
	Size: 0x870
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
	setbombtimer("A", 0);
	setmatchflag("bomb_timer_a", 0);
	setbombtimer("B", 0);
	setmatchflag("bomb_timer_b", 0);
	level.usingextratime = 0;
	level.spawnsystem.sideswitching = 0;
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
	setclientnamemode("manual_change");
	game["strings"]["target_destroyed"] = &"MP_TARGET_DESTROYED";
	game["strings"]["bomb_defused"] = &"MP_BOMB_DEFUSED";
	level._effect["bombexplosion"] = "explosions/fx_exp_bomb_demo_mp";
	if(isdefined(game["overtime_round"]))
	{
		util::setobjectivetext(game["attackers"], &"OBJECTIVES_DEM_ATTACKER");
		util::setobjectivetext(game["defenders"], &"OBJECTIVES_DEM_ATTACKER");
		if(level.splitscreen)
		{
			util::setobjectivescoretext(game["attackers"], &"OBJECTIVES_DEM_ATTACKER");
			util::setobjectivescoretext(game["defenders"], &"OBJECTIVES_DEM_ATTACKER");
		}
		else
		{
			util::setobjectivescoretext(game["attackers"], &"OBJECTIVES_DEM_ATTACKER_SCORE");
			util::setobjectivescoretext(game["defenders"], &"OBJECTIVES_DEM_ATTACKER_SCORE");
		}
		util::setobjectivehinttext(game["attackers"], &"OBJECTIVES_DEM_ATTACKER_OVERTIME_HINT");
		util::setobjectivehinttext(game["defenders"], &"OBJECTIVES_DEM_ATTACKER_OVERTIME_HINT");
	}
	else
	{
		util::setobjectivetext(game["attackers"], &"OBJECTIVES_DEM_ATTACKER");
		util::setobjectivetext(game["defenders"], &"OBJECTIVES_SD_DEFENDER");
		if(level.splitscreen)
		{
			util::setobjectivescoretext(game["attackers"], &"OBJECTIVES_DEM_ATTACKER");
			util::setobjectivescoretext(game["defenders"], &"OBJECTIVES_SD_DEFENDER");
		}
		else
		{
			util::setobjectivescoretext(game["attackers"], &"OBJECTIVES_DEM_ATTACKER_SCORE");
			util::setobjectivescoretext(game["defenders"], &"OBJECTIVES_SD_DEFENDER_SCORE");
		}
		util::setobjectivehinttext(game["attackers"], &"OBJECTIVES_DEM_ATTACKER_HINT");
		util::setobjectivehinttext(game["defenders"], &"OBJECTIVES_SD_DEFENDER_HINT");
	}
	bombzones = getentarray(level.dembombzonename, "targetname");
	if(bombzones.size == 0)
	{
		level.dembombzonename = "bombzone";
	}
	spawning::create_map_placed_influencers();
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	spawnlogic::drop_spawn_points("mp_dem_spawn_attacker_a");
	spawnlogic::drop_spawn_points("mp_dem_spawn_attacker_b");
	spawnlogic::drop_spawn_points("mp_dem_spawn_defender_a");
	spawnlogic::drop_spawn_points("mp_dem_spawn_defender_b");
	if(!isdefined(game["overtime_round"]))
	{
		spawnlogic::place_spawn_points("mp_dem_spawn_defender_start");
		spawnlogic::place_spawn_points("mp_dem_spawn_attacker_start");
	}
	else
	{
		spawnlogic::place_spawn_points("mp_dem_spawn_attackerot_start");
		spawnlogic::place_spawn_points("mp_dem_spawn_defenderot_start");
	}
	spawnlogic::add_spawn_points(game["attackers"], "mp_dem_spawn_attacker");
	spawnlogic::add_spawn_points(game["defenders"], "mp_dem_spawn_defender");
	if(!isdefined(game["overtime_round"]))
	{
		spawnlogic::add_spawn_points(game["defenders"], "mp_dem_spawn_defender_a");
		spawnlogic::add_spawn_points(game["defenders"], "mp_dem_spawn_defender_b");
		spawnlogic::add_spawn_points(game["attackers"], "mp_dem_spawn_attacker_remove_a");
		spawnlogic::add_spawn_points(game["attackers"], "mp_dem_spawn_attacker_remove_b");
	}
	spawning::add_fallback_spawnpoints(game["attackers"], "mp_tdm_spawn");
	spawning::add_fallback_spawnpoints(game["defenders"], "mp_tdm_spawn");
	spawning::updateallspawnpoints();
	spawning::update_fallback_spawnpoints();
	level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
	setmapcenter(level.mapcenter);
	spawnpoint = spawnlogic::get_random_intermission_point();
	setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
	level.spawn_start = [];
	if(isdefined(game["overtime_round"]))
	{
		level.spawn_start["axis"] = spawnlogic::get_spawnpoint_array("mp_dem_spawn_defenderot_start");
		level.spawn_start["allies"] = spawnlogic::get_spawnpoint_array("mp_dem_spawn_attackerot_start");
	}
	else
	{
		level.spawn_start["axis"] = spawnlogic::get_spawnpoint_array("mp_dem_spawn_defender_start");
		level.spawn_start["allies"] = spawnlogic::get_spawnpoint_array("mp_dem_spawn_attacker_start");
	}
	thread updategametypedvars();
	thread bombs();
	if(isdefined(level.droppedtagrespawn) && level.droppedtagrespawn)
	{
		level.numlives = 1;
	}
}

/*
	Name: onspawnplayer
	Namespace: dem
	Checksum: 0x5E29C396
	Offset: 0x1F38
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function onspawnplayer(predictedspawn)
{
	self.isplanting = 0;
	self.isdefusing = 0;
	self.isbombcarrier = 0;
	spawning::onspawnplayer(predictedspawn);
}

/*
	Name: dem_playerspawnedcb
	Namespace: dem
	Checksum: 0x286E1E88
	Offset: 0x1F88
	Size: 0x12
	Parameters: 0
	Flags: None
*/
function dem_playerspawnedcb()
{
	level notify(#"spawned_player");
}

/*
	Name: onplayerkilled
	Namespace: dem
	Checksum: 0xA8A316E6
	Offset: 0x1FA8
	Size: 0x55C
	Parameters: 9
	Flags: None
*/
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	thread checkallowspectating();
	if(isdefined(level.droppedtagrespawn) && level.droppedtagrespawn)
	{
		should_spawn_tags = self dogtags::should_spawn_tags(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration);
		should_spawn_tags = should_spawn_tags && !globallogic_spawn::mayspawn();
		if(should_spawn_tags)
		{
			level thread dogtags::spawn_dog_tag(self, attacker, &dogtags::onusedogtag, 0);
		}
	}
	bombzone = undefined;
	for(index = 0; index < level.bombzones.size; index++)
	{
		if(!isdefined(level.bombzones[index].bombexploded) || !level.bombzones[index].bombexploded)
		{
			dist = distance2dsquared(self.origin, level.bombzones[index].curorigin);
			if(dist < level.defaultoffenseradiussq)
			{
				bombzone = level.bombzones[index];
				break;
			}
			dist = distance2dsquared(attacker.origin, level.bombzones[index].curorigin);
			if(dist < level.defaultoffenseradiussq)
			{
				inbombzone = 1;
				break;
			}
		}
	}
	if(isdefined(bombzone) && isplayer(attacker) && attacker.pers["team"] != self.pers["team"])
	{
		if(bombzone gameobjects::get_owner_team() != attacker.team)
		{
			if(!isdefined(attacker.dem_offends))
			{
				attacker.dem_offends = 0;
			}
			attacker.dem_offends++;
			if(level.playeroffensivemax >= attacker.dem_offends)
			{
				attacker medals::offenseglobalcount();
				attacker thread challenges::killedbasedefender(bombzone.trigger);
				self recordkillmodifier("defending");
				scoreevents::processscoreevent("killed_defender", attacker, self, weapon);
			}
			else
			{
				/#
					attacker iprintlnbold("");
				#/
			}
		}
		else
		{
			if(!isdefined(attacker.dem_defends))
			{
				attacker.dem_defends = 0;
			}
			attacker.dem_defends++;
			if(level.playerdefensivemax >= attacker.dem_defends)
			{
				if(isdefined(attacker.pers["defends"]))
				{
					attacker.pers["defends"]++;
					attacker.defends = attacker.pers["defends"];
				}
				attacker medals::defenseglobalcount();
				attacker thread challenges::killedbaseoffender(bombzone.trigger, weapon);
				self recordkillmodifier("assaulting");
				scoreevents::processscoreevent("killed_attacker", attacker, self, weapon);
			}
			else
			{
				/#
					attacker iprintlnbold("");
				#/
			}
		}
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
	Name: checkallowspectating
	Namespace: dem
	Checksum: 0x73E3536C
	Offset: 0x2510
	Size: 0x11C
	Parameters: 0
	Flags: None
*/
function checkallowspectating()
{
	self endon(#"disconnect");
	wait(0.05);
	update = 0;
	livesleft = !(level.numlives && !self.pers["lives"]);
	if(!level.alivecount[game["attackers"]] && !livesleft)
	{
		level.spectateoverride[game["attackers"]].allowenemyspectate = 1;
		update = 1;
	}
	if(!level.alivecount[game["defenders"]] && !livesleft)
	{
		level.spectateoverride[game["defenders"]].allowenemyspectate = 1;
		update = 1;
	}
	if(update)
	{
		spectating::update_settings();
	}
}

/*
	Name: dem_endgame
	Namespace: dem
	Checksum: 0x8C0D7D10
	Offset: 0x2638
	Size: 0xEC
	Parameters: 2
	Flags: None
*/
function dem_endgame(winningteam, endreasontext)
{
	foreach(bombzone in level.bombzones)
	{
		bombzone gameobjects::set_visible_team("none");
	}
	if(isdefined(winningteam) && winningteam != "tie")
	{
		globallogic_score::giveteamscoreforobjective(winningteam, 1);
	}
	thread globallogic::endgame(winningteam, endreasontext);
}

/*
	Name: ondeadevent
	Namespace: dem
	Checksum: 0x655E7268
	Offset: 0x2730
	Size: 0x174
	Parameters: 1
	Flags: None
*/
function ondeadevent(team)
{
	if(level.bombexploded || level.bombdefused)
	{
		return;
	}
	if(team == "all")
	{
		if(level.bombplanted)
		{
			dem_endgame(game["attackers"], game["strings"][game["defenders"] + "_eliminated"]);
		}
		else
		{
			dem_endgame(game["defenders"], game["strings"][game["attackers"] + "_eliminated"]);
		}
	}
	else
	{
		if(team == game["attackers"])
		{
			if(level.bombplanted)
			{
				return;
			}
			dem_endgame(game["defenders"], game["strings"][game["attackers"] + "_eliminated"]);
		}
		else if(team == game["defenders"])
		{
			dem_endgame(game["attackers"], game["strings"][game["defenders"] + "_eliminated"]);
		}
	}
}

/*
	Name: ononeleftevent
	Namespace: dem
	Checksum: 0x418B1DA2
	Offset: 0x28B0
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function ononeleftevent(team)
{
	if(level.bombexploded || level.bombdefused)
	{
		return;
	}
	warnlastplayer(team);
}

/*
	Name: ontimelimit
	Namespace: dem
	Checksum: 0x5914F7A9
	Offset: 0x28F8
	Size: 0x17C
	Parameters: 0
	Flags: None
*/
function ontimelimit()
{
	if(isdefined(game["overtime_round"]))
	{
		dem_endgame("tie", game["strings"]["time_limit_reached"]);
	}
	else
	{
		if(level.teambased)
		{
			bombzonesleft = 0;
			for(index = 0; index < level.bombzones.size; index++)
			{
				if(!isdefined(level.bombzones[index].bombexploded) || !level.bombzones[index].bombexploded)
				{
					bombzonesleft++;
				}
			}
			if(bombzonesleft == 0)
			{
				dem_endgame(game["attackers"], game["strings"]["target_destroyed"]);
			}
			else
			{
				dem_endgame(game["defenders"], game["strings"]["time_limit_reached"]);
			}
		}
		else
		{
			dem_endgame("tie", game["strings"]["time_limit_reached"]);
		}
	}
}

/*
	Name: warnlastplayer
	Namespace: dem
	Checksum: 0xCCB15C4E
	Offset: 0x2A80
	Size: 0x15C
	Parameters: 1
	Flags: None
*/
function warnlastplayer(team)
{
	if(!isdefined(level.warnedlastplayer))
	{
		level.warnedlastplayer = [];
	}
	if(isdefined(level.warnedlastplayer[team]))
	{
		return;
	}
	level.warnedlastplayer[team] = 1;
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(isdefined(player.pers["team"]) && player.pers["team"] == team && isdefined(player.pers["class"]))
		{
			if(player.sessionstate == "playing" && !player.afk)
			{
				break;
			}
		}
	}
	if(i == players.size)
	{
		return;
	}
	players[i] thread givelastattackerwarning();
}

/*
	Name: givelastattackerwarning
	Namespace: dem
	Checksum: 0x8814B12B
	Offset: 0x2BE8
	Size: 0xC4
	Parameters: 0
	Flags: None
*/
function givelastattackerwarning()
{
	self endon(#"death");
	self endon(#"disconnect");
	fullhealthtime = 0;
	interval = 0.05;
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
		if(self.health == self.maxhealth && fullhealthtime >= 3)
		{
			break;
		}
	}
	self globallogic_audio::leader_dialog_on_player("roundSuddenDeath");
}

/*
	Name: updategametypedvars
	Namespace: dem
	Checksum: 0xD29935C3
	Offset: 0x2CB8
	Size: 0x164
	Parameters: 0
	Flags: None
*/
function updategametypedvars()
{
	level.planttime = getgametypesetting("plantTime");
	level.defusetime = getgametypesetting("defuseTime");
	level.bombtimer = getgametypesetting("bombTimer");
	level.extratime = getgametypesetting("extraTime");
	level.overtimetimelimit = getgametypesetting("OvertimetimeLimit");
	level.teamkillpenaltymultiplier = getgametypesetting("teamKillPenalty");
	level.teamkillscoremultiplier = getgametypesetting("teamKillScore");
	level.playereventslpm = getgametypesetting("maxPlayerEventsPerMinute");
	level.bombeventslpm = getgametypesetting("maxObjectiveEventsPerMinute");
	level.playeroffensivemax = getgametypesetting("maxPlayerOffensive");
	level.playerdefensivemax = getgametypesetting("maxPlayerDefensive");
}

/*
	Name: resetbombzone
	Namespace: dem
	Checksum: 0x6AF0092D
	Offset: 0x2E28
	Size: 0x1F4
	Parameters: 0
	Flags: None
*/
function resetbombzone()
{
	if(isdefined(game["overtime_round"]))
	{
		self gameobjects::set_owner_team("neutral");
		self gameobjects::allow_use("any");
	}
	else
	{
		self gameobjects::allow_use("enemy");
	}
	self gameobjects::set_use_time(level.planttime);
	self gameobjects::set_use_text(&"MP_PLANTING_EXPLOSIVE");
	self gameobjects::set_use_hint_text(&"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES");
	self gameobjects::set_key_object(level.ddbomb);
	self gameobjects::set_2d_icon("friendly", "waypoint_defend" + self.label);
	self gameobjects::set_3d_icon("friendly", "waypoint_defend" + self.label);
	self gameobjects::set_2d_icon("enemy", "waypoint_target" + self.label);
	self gameobjects::set_3d_icon("enemy", "waypoint_target" + self.label);
	self gameobjects::set_visible_team("any");
	self.useweapon = getweapon("briefcase_bomb");
}

/*
	Name: setupfordefusing
	Namespace: dem
	Checksum: 0x164EAA84
	Offset: 0x3028
	Size: 0x17C
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
	self gameobjects::set_2d_icon("friendly", "compass_waypoint_defuse" + self.label);
	self gameobjects::set_3d_icon("friendly", "waypoint_defuse" + self.label);
	self gameobjects::set_2d_icon("enemy", "compass_waypoint_defend" + self.label);
	self gameobjects::set_3d_icon("enemy", "waypoint_defend" + self.label);
	self gameobjects::set_visible_team("any");
}

/*
	Name: bombs
	Namespace: dem
	Checksum: 0x47278EF9
	Offset: 0x31B0
	Size: 0x992
	Parameters: 0
	Flags: None
*/
function bombs()
{
	level.bombaplanted = 0;
	level.bombbplanted = 0;
	level.bombplanted = 0;
	level.bombdefused = 0;
	level.bombexploded = 0;
	sdbomb = getent("sd_bomb", "targetname");
	if(isdefined(sdbomb))
	{
		sdbomb delete();
	}
	level.bombzones = [];
	bombzones = getentarray(level.dembombzonename, "targetname");
	for(index = 0; index < bombzones.size; index++)
	{
		trigger = bombzones[index];
		scriptlabel = trigger.script_label;
		visuals = getentarray(bombzones[index].target, "targetname");
		clipbrushes = getentarray("bombzone_clip" + scriptlabel, "targetname");
		defusetrig = getent(visuals[0].target, "targetname");
		bombsiteteamowner = game["defenders"];
		bombsiteallowuse = "enemy";
		if(isdefined(game["overtime_round"]))
		{
			if(scriptlabel != "_overtime")
			{
				trigger delete();
				defusetrig delete();
				visuals[0] delete();
				foreach(clip in clipbrushes)
				{
					clip delete();
				}
				continue;
			}
			bombsiteteamowner = "neutral";
			bombsiteallowuse = "any";
			scriptlabel = "_a";
		}
		else if(scriptlabel == "_overtime")
		{
			trigger delete();
			defusetrig delete();
			visuals[0] delete();
			foreach(clip in clipbrushes)
			{
				clip delete();
			}
			continue;
		}
		name = istring("dem" + scriptlabel);
		bombzone = gameobjects::create_use_object(bombsiteteamowner, trigger, visuals, (0, 0, 0), name, 1, 1);
		bombzone gameobjects::allow_use(bombsiteallowuse);
		bombzone gameobjects::set_use_time(level.planttime);
		bombzone gameobjects::set_use_text(&"MP_PLANTING_EXPLOSIVE");
		bombzone gameobjects::set_use_hint_text(&"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES");
		bombzone gameobjects::set_key_object(level.ddbomb);
		bombzone.label = scriptlabel;
		bombzone.index = index;
		bombzone gameobjects::set_2d_icon("friendly", "compass_waypoint_defend" + scriptlabel);
		bombzone gameobjects::set_3d_icon("friendly", "waypoint_defend" + scriptlabel);
		bombzone gameobjects::set_2d_icon("enemy", "compass_waypoint_target" + scriptlabel);
		bombzone gameobjects::set_3d_icon("enemy", "waypoint_target" + scriptlabel);
		bombzone gameobjects::set_visible_team("any");
		bombzone.onbeginuse = &onbeginuse;
		bombzone.onenduse = &onenduse;
		bombzone.onuse = &onuseobject;
		bombzone.oncantuse = &oncantuse;
		bombzone.useweapon = getweapon("briefcase_bomb");
		bombzone.visuals[0].killcament = spawn("script_model", bombzone.visuals[0].origin + vectorscale((0, 0, 1), 128));
		if(isdefined(level.bomb_zone_fixup))
		{
			[[level.bomb_zone_fixup]](bombzone);
		}
		for(i = 0; i < visuals.size; i++)
		{
			if(isdefined(visuals[i].script_exploder))
			{
				bombzone.exploderindex = visuals[i].script_exploder;
				break;
			}
		}
		foreach(visual in bombzone.visuals)
		{
			visual.team = "free";
		}
		level.bombzones[level.bombzones.size] = bombzone;
		bombzone.bombdefusetrig = defusetrig;
		/#
			assert(isdefined(bombzone.bombdefusetrig));
		#/
		bombzone.bombdefusetrig.origin = bombzone.bombdefusetrig.origin + (vectorscale((0, 0, -1), 10000));
		bombzone.bombdefusetrig.label = scriptlabel;
		team_mask = util::getteammask(game["attackers"]);
		bombzone.spawninfluencer = bombzone spawning::create_influencer("dem_enemy_base", trigger.origin, team_mask);
	}
	for(index = 0; index < level.bombzones.size; index++)
	{
		array = [];
		for(otherindex = 0; otherindex < level.bombzones.size; otherindex++)
		{
			if(otherindex != index)
			{
				array[array.size] = level.bombzones[otherindex];
			}
		}
		level.bombzones[index].otherbombzones = array;
	}
}

/*
	Name: setbomboverheatingafterweaponchange
	Namespace: dem
	Checksum: 0x8B378748
	Offset: 0x3B50
	Size: 0x9C
	Parameters: 3
	Flags: None
*/
function setbomboverheatingafterweaponchange(useobject, overheated, heat)
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"joined_team");
	self endon(#"joined_spectators");
	self waittill(#"weapon_change", weapon);
	if(weapon == useobject.useweapon)
	{
		self setweaponoverheating(overheated, heat, weapon);
	}
}

/*
	Name: onbeginuse
	Namespace: dem
	Checksum: 0xD3E7E53D
	Offset: 0x3BF8
	Size: 0x2E4
	Parameters: 1
	Flags: None
*/
function onbeginuse(player)
{
	timeremaining = globallogic_utils::gettimeremaining();
	if(timeremaining <= (level.planttime * 1000))
	{
		globallogic_utils::pausetimer();
		level.haspausedtimer = 1;
	}
	if(self gameobjects::is_friendly_team(player.pers["team"]))
	{
		player playsound("mpl_sd_bomb_defuse");
		player.isdefusing = 1;
		player thread setbomboverheatingafterweaponchange(self, 0, 0);
		player thread battlechatter::gametype_specific_battle_chatter("sd_enemyplant", player.pers["team"]);
		bestdistance = 9000000;
		closestbomb = undefined;
		if(isdefined(level.ddbombmodel))
		{
			keys = getarraykeys(level.ddbombmodel);
			for(bomblabel = 0; bomblabel < keys.size; bomblabel++)
			{
				bomb = level.ddbombmodel[keys[bomblabel]];
				if(!isdefined(bomb))
				{
					continue;
				}
				dist = distancesquared(player.origin, bomb.origin);
				if(dist < bestdistance)
				{
					bestdistance = dist;
					closestbomb = bomb;
				}
			}
			/#
				assert(isdefined(closestbomb));
			#/
			player.defusing = closestbomb;
			closestbomb hide();
		}
	}
	else
	{
		player.isplanting = 1;
		player thread setbomboverheatingafterweaponchange(self, 0, 0);
		player thread battlechatter::gametype_specific_battle_chatter("sd_friendlyplant", player.pers["team"]);
	}
	player playsound("fly_bomb_raise_plr");
}

/*
	Name: onenduse
	Namespace: dem
	Checksum: 0xEA84883A
	Offset: 0x3EE8
	Size: 0xFC
	Parameters: 3
	Flags: None
*/
function onenduse(team, player, result)
{
	if(!isdefined(player))
	{
		return;
	}
	if(!level.bombaplanted && !level.bombbplanted)
	{
		globallogic_utils::resumetimer();
		level.haspausedtimer = 0;
	}
	player.isdefusing = 0;
	player.isplanting = 0;
	player notify(#"event_ended");
	if(self gameobjects::is_friendly_team(player.pers["team"]))
	{
		if(isdefined(player.defusing) && !result)
		{
			player.defusing show();
		}
	}
}

/*
	Name: oncantuse
	Namespace: dem
	Checksum: 0x4C1CB5B6
	Offset: 0x3FF0
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function oncantuse(player)
{
	player iprintlnbold(&"MP_CANT_PLANT_WITHOUT_BOMB");
}

/*
	Name: onuseobject
	Namespace: dem
	Checksum: 0x133D2C80
	Offset: 0x4028
	Size: 0x514
	Parameters: 1
	Flags: None
*/
function onuseobject(player)
{
	team = player.team;
	enemyteam = util::getotherteam(team);
	self updateeventsperminute();
	player updateeventsperminute();
	if(!self gameobjects::is_friendly_team(team))
	{
		self gameobjects::set_flags(1);
		level thread bombplanted(self, player);
		/#
			print("" + self.label);
		#/
		bbprint("mpobjective", "gametime %d objtype %s label %s team %s playerx %d playery %d playerz %d", gettime(), "dem_bombplant", self.label, team, player.origin);
		player notify(#"bomb_planted");
		thread globallogic_audio::set_music_on_team("DEM_WE_PLANT", team, 5);
		thread globallogic_audio::set_music_on_team("DEM_THEY_PLANT", enemyteam, 5);
		if(isdefined(player.pers["plants"]))
		{
			player.pers["plants"]++;
			player.plants = player.pers["plants"];
		}
		if(!isscoreboosting(player, self))
		{
			demo::bookmark("event", gettime(), player);
			player addplayerstatwithgametype("PLANTS", 1);
			scoreevents::processscoreevent("planted_bomb", player);
			player recordgameevent("plant");
		}
		else
		{
			/#
				player iprintlnbold("");
			#/
		}
		level thread popups::displayteammessagetoall(&"MP_EXPLOSIVES_PLANTED_BY", player);
		globallogic_audio::leader_dialog("bombPlanted");
	}
	else
	{
		self gameobjects::set_flags(0);
		player notify(#"bomb_defused");
		/#
			print("" + self.label);
		#/
		self thread bombdefused(player);
		self resetbombzone();
		bbprint("mpobjective", "gametime %d objtype %s label %s team %s playerx %d playery %d playerz %d", gettime(), "dem_bombdefused", self.label, team, player.origin);
		if(isdefined(player.pers["defuses"]))
		{
			player.pers["defuses"]++;
			player.defuses = player.pers["defuses"];
		}
		if(!isscoreboosting(player, self))
		{
			demo::bookmark("event", gettime(), player);
			player addplayerstatwithgametype("DEFUSES", 1);
			scoreevents::processscoreevent("defused_bomb", player);
			player recordgameevent("defuse");
		}
		else
		{
			/#
				player iprintlnbold("");
			#/
		}
		level thread popups::displayteammessagetoall(&"MP_EXPLOSIVES_DEFUSED_BY", player);
		thread globallogic_audio::set_music_on_team("DEM_WE_DEFUSE", team, 5);
		thread globallogic_audio::set_music_on_team("DEM_THEY_DEFUSE", enemyteam, 5);
		globallogic_audio::leader_dialog("bombDefused");
	}
}

/*
	Name: ondrop
	Namespace: dem
	Checksum: 0x3070A5C6
	Offset: 0x4548
	Size: 0xEC
	Parameters: 1
	Flags: None
*/
function ondrop(player)
{
	if(!level.bombplanted)
	{
		globallogic_audio::leader_dialog("bombFriendlyDropped", player.pers["team"]);
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
	}
	player notify(#"event_ended");
	self gameobjects::set_3d_icon("friendly", "waypoint_bomb");
	sound::play_on_players(game["bomb_dropped_sound"], game["attackers"]);
}

/*
	Name: onpickup
	Namespace: dem
	Checksum: 0x3CDCA151
	Offset: 0x4640
	Size: 0x11C
	Parameters: 1
	Flags: None
*/
function onpickup(player)
{
	player.isbombcarrier = 1;
	self gameobjects::set_3d_icon("friendly", "waypoint_defend");
	if(!level.bombdefused)
	{
		thread sound::play_on_players(("mus_sd_pickup" + "_") + level.teampostfix[player.pers["team"]], player.pers["team"]);
		globallogic_audio::leader_dialog("bombFriendlyTaken", player.pers["team"]);
		/#
			print("");
		#/
	}
	sound::play_on_players(game["bomb_recovered_sound"], game["attackers"]);
}

/*
	Name: onreset
	Namespace: dem
	Checksum: 0x99EC1590
	Offset: 0x4768
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function onreset()
{
}

/*
	Name: bombreset
	Namespace: dem
	Checksum: 0xF2CBC5E7
	Offset: 0x4778
	Size: 0xDC
	Parameters: 2
	Flags: None
*/
function bombreset(label, reason)
{
	if(label == "_a")
	{
		level.bombaplanted = 0;
		setbombtimer("A", 0);
	}
	else
	{
		level.bombbplanted = 0;
		setbombtimer("B", 0);
	}
	setmatchflag("bomb_timer" + label, 0);
	if(!level.bombaplanted && !level.bombbplanted)
	{
		globallogic_utils::resumetimer();
	}
	self.visuals[0] globallogic_utils::stoptickingsound();
}

/*
	Name: dropbombmodel
	Namespace: dem
	Checksum: 0x511F4CF1
	Offset: 0x4860
	Size: 0x25C
	Parameters: 2
	Flags: None
*/
function dropbombmodel(player, site)
{
	trace = bullettrace(player.origin + vectorscale((0, 0, 1), 20), player.origin - vectorscale((0, 0, 1), 2000), 0, player);
	tempangle = randomfloat(360);
	forward = (cos(tempangle), sin(tempangle), 0);
	forward = vectornormalize(forward - vectorscale(trace["normal"], vectordot(forward, trace["normal"])));
	dropangles = vectortoangles(forward);
	if(isdefined(trace["surfacetype"]) && trace["surfacetype"] == "water")
	{
		phystrace = playerphysicstrace(player.origin + vectorscale((0, 0, 1), 20), player.origin - vectorscale((0, 0, 1), 2000));
		if(isdefined(phystrace))
		{
			trace["position"] = phystrace;
		}
	}
	level.ddbombmodel[site] = spawn("script_model", trace["position"]);
	level.ddbombmodel[site].angles = dropangles;
	level.ddbombmodel[site] setmodel("p7_mp_suitcase_bomb");
}

/*
	Name: bombplanted
	Namespace: dem
	Checksum: 0xDC531F9F
	Offset: 0x4AC8
	Size: 0xB44
	Parameters: 2
	Flags: None
*/
function bombplanted(destroyedobj, player)
{
	level endon(#"game_ended");
	destroyedobj endon(#"bomb_defused");
	team = player.team;
	game["challenge"][team]["plantedBomb"] = 1;
	globallogic_utils::pausetimer();
	destroyedobj.bombplanted = 1;
	player setweaponoverheating(1, 100, destroyedobj.useweapon);
	player playbombplant();
	destroyedobj.visuals[0] thread globallogic_utils::playtickingsound("mpl_sab_ui_suitcasebomb_timer");
	destroyedobj.tickingobject = destroyedobj.visuals[0];
	label = destroyedobj.label;
	detonatetime = int(gettime() + (level.bombtimer * 1000));
	updatebombtimers(label, detonatetime);
	destroyedobj.detonatetime = detonatetime;
	trace = bullettrace(player.origin + vectorscale((0, 0, 1), 20), player.origin - vectorscale((0, 0, 1), 2000), 0, player);
	self dropbombmodel(player, destroyedobj.label);
	destroyedobj gameobjects::allow_use("none");
	destroyedobj gameobjects::set_visible_team("none");
	if(isdefined(game["overtime_round"]))
	{
		destroyedobj gameobjects::set_owner_team(util::getotherteam(player.team));
	}
	destroyedobj setupfordefusing();
	player.isbombcarrier = 0;
	game["challenge"][team]["plantedBomb"] = 1;
	destroyedobj waitlongdurationwithbombtimeupdate(label, level.bombtimer);
	destroyedobj bombreset(label, "bomb_exploded");
	if(level.gameended)
	{
		return;
	}
	origin = (0, 0, 0);
	if(isdefined(player))
	{
		origin = player.origin;
	}
	bbprint("mpobjective", "gametime %d objtype %s label %s team %s playerx %d playery %d playerz %d", gettime(), "dem_bombexplode", label, team, origin);
	destroyedobj.bombexploded = 1;
	game["challenge"][team]["destroyedBombSite"] = 1;
	explosionorigin = destroyedobj.curorigin;
	level.ddbombmodel[destroyedobj.label] delete();
	clips = getentarray("bombzone_clip" + destroyedobj.label, "targetname");
	foreach(clip in clips)
	{
		clip delete();
	}
	if(isdefined(player))
	{
		destroyedobj.visuals[0] radiusdamage(explosionorigin, 512, 200, 20, player, "MOD_EXPLOSIVE", getweapon("briefcase_bomb"));
		level thread popups::displayteammessagetoall(&"MP_EXPLOSIVES_BLOWUP_BY", player);
		if(player.team == team)
		{
			player addplayerstatwithgametype("DESTRUCTIONS", 1);
			player addplayerstatwithgametype("captures", 1);
			scoreevents::processscoreevent("bomb_detonated", player);
		}
		player recordgameevent("destroy");
	}
	else
	{
		destroyedobj.visuals[0] radiusdamage(explosionorigin, 512, 200, 20, undefined, "MOD_EXPLOSIVE", getweapon("briefcase_bomb"));
	}
	currenttime = gettime();
	if(isdefined(level.lastbombexplodetime) && level.lastbombexplodebyteam == team)
	{
		if((level.lastbombexplodetime + 10000) > currenttime)
		{
			for(i = 0; i < level.players.size; i++)
			{
				if(level.players[i].team == team)
				{
					level.players[i] challenges::bothbombsdetonatewithintime();
				}
			}
		}
	}
	level.lastbombexplodetime = currenttime;
	level.lastbombexplodebyteam = team;
	rot = randomfloat(360);
	explosioneffect = spawnfx(level._effect["bombexplosion"], explosionorigin + vectorscale((0, 0, 1), 50), (0, 0, 1), (cos(rot), sin(rot), 0));
	triggerfx(explosioneffect);
	thread sound::play_in_space("mpl_sd_exp_suitcase_bomb_main", explosionorigin);
	if(isdefined(destroyedobj.exploderindex))
	{
		exploder::exploder(destroyedobj.exploderindex);
	}
	bombzonesleft = 0;
	for(index = 0; index < level.bombzones.size; index++)
	{
		if(!isdefined(level.bombzones[index].bombexploded) || !level.bombzones[index].bombexploded)
		{
			bombzonesleft++;
		}
	}
	destroyedobj gameobjects::disable_object();
	if(bombzonesleft == 0)
	{
		globallogic_utils::pausetimer();
		level.haspausedtimer = 1;
		setgameendtime(0);
		wait(3);
		dem_endgame(team, game["strings"]["target_destroyed"]);
	}
	else
	{
		enemyteam = util::getotherteam(team);
		thread globallogic_audio::set_music_on_team("DEM_WE_SCORE", team, 5);
		thread globallogic_audio::set_music_on_team("DEM_THEY_SCORE", enemyteam, 5);
		if([[level.gettimelimit]]() > 0)
		{
			level.usingextratime = 1;
		}
		destroyedobj spawning::remove_influencer(destroyedobj.spawninfluencer);
		destroyedobj.spawninfluencer = undefined;
		spawnlogic::clear_spawn_points();
		spawnlogic::add_spawn_points(game["attackers"], "mp_dem_spawn_attacker");
		spawnlogic::add_spawn_points(game["defenders"], "mp_dem_spawn_defender");
		if(label == "_a")
		{
			spawnlogic::add_spawn_points(game["attackers"], "mp_dem_spawn_attacker_remove_b");
			spawnlogic::add_spawn_points(game["attackers"], "mp_dem_spawn_attacker_a");
			spawnlogic::add_spawn_points(game["defenders"], "mp_dem_spawn_defender_b");
		}
		else
		{
			spawnlogic::add_spawn_points(game["attackers"], "mp_dem_spawn_attacker_remove_a");
			spawnlogic::add_spawn_points(game["attackers"], "mp_dem_spawn_attacker_b");
			spawnlogic::add_spawn_points(game["defenders"], "mp_dem_spawn_defender_a");
		}
		spawning::updateallspawnpoints();
	}
}

/*
	Name: gettimelimit
	Namespace: dem
	Checksum: 0x5D105980
	Offset: 0x5618
	Size: 0x5A
	Parameters: 0
	Flags: None
*/
function gettimelimit()
{
	timelimit = globallogic_defaults::default_gettimelimit();
	if(isdefined(game["overtime_round"]))
	{
		timelimit = level.overtimetimelimit;
	}
	if(level.usingextratime)
	{
		return timelimit + level.extratime;
	}
	return timelimit;
}

/*
	Name: shouldplayovertimeround
	Namespace: dem
	Checksum: 0xCECC647E
	Offset: 0x5680
	Size: 0x6E
	Parameters: 0
	Flags: None
*/
function shouldplayovertimeround()
{
	if(isdefined(game["overtime_round"]))
	{
		return false;
	}
	if(game["teamScores"]["allies"] == (level.scorelimit - 1) && game["teamScores"]["axis"] == (level.scorelimit - 1))
	{
		return true;
	}
	return false;
}

/*
	Name: waitlongdurationwithbombtimeupdate
	Namespace: dem
	Checksum: 0x37DBFF0D
	Offset: 0x56F8
	Size: 0x170
	Parameters: 2
	Flags: None
*/
function waitlongdurationwithbombtimeupdate(whichbomb, duration)
{
	if(duration == 0)
	{
		return;
	}
	/#
		assert(duration > 0);
	#/
	starttime = gettime();
	endtime = gettime() + (duration * 1000);
	while(gettime() < endtime)
	{
		hostmigration::waittillhostmigrationstarts((endtime - gettime()) / 1000);
		while(isdefined(level.hostmigrationtimer))
		{
			endtime = endtime + 250;
			updatebombtimers(whichbomb, endtime);
			wait(0.25);
		}
	}
	/#
		if(gettime() != endtime)
		{
			println((("" + gettime()) + "") + endtime);
		}
	#/
	while(isdefined(level.hostmigrationtimer))
	{
		endtime = endtime + 250;
		updatebombtimers(whichbomb, endtime);
		wait(0.25);
	}
	return gettime() - starttime;
}

/*
	Name: updatebombtimers
	Namespace: dem
	Checksum: 0x1A74AF36
	Offset: 0x5870
	Size: 0xDC
	Parameters: 2
	Flags: None
*/
function updatebombtimers(whichbomb, detonatetime)
{
	if(whichbomb == "_a")
	{
		level.bombaplanted = 1;
		setbombtimer("A", int(detonatetime));
	}
	else
	{
		level.bombbplanted = 1;
		setbombtimer("B", int(detonatetime));
	}
	setmatchflag("bomb_timer" + whichbomb, int(detonatetime));
}

/*
	Name: bombdefused
	Namespace: dem
	Checksum: 0x1830A104
	Offset: 0x5958
	Size: 0xEC
	Parameters: 1
	Flags: None
*/
function bombdefused(player)
{
	self.tickingobject globallogic_utils::stoptickingsound();
	self gameobjects::allow_use("none");
	self gameobjects::set_visible_team("none");
	self.bombdefused = 1;
	self notify(#"bomb_defused");
	self.bombplanted = 0;
	self bombreset(self.label, "bomb_defused");
	player setweaponoverheating(1, 100, self.useweapon);
	player playbombdefuse();
}

/*
	Name: play_one_left_underscore
	Namespace: dem
	Checksum: 0x69217C5D
	Offset: 0x5A50
	Size: 0x74
	Parameters: 2
	Flags: None
*/
function play_one_left_underscore(team, enemyteam)
{
	wait(3);
	if(!isdefined(team) || !isdefined(enemyteam))
	{
		return;
	}
	thread globallogic_audio::set_music_on_team("DEM_ONE_LEFT_UNDERSCORE", team);
	thread globallogic_audio::set_music_on_team("DEM_ONE_LEFT_UNDERSCORE", enemyteam);
}

/*
	Name: updateeventsperminute
	Namespace: dem
	Checksum: 0x68DF5EF0
	Offset: 0x5AD0
	Size: 0xDC
	Parameters: 0
	Flags: None
*/
function updateeventsperminute()
{
	if(!isdefined(self.eventsperminute))
	{
		self.numbombevents = 0;
		self.eventsperminute = 0;
	}
	self.numbombevents++;
	minutespassed = globallogic_utils::gettimepassed() / 60000;
	if(isplayer(self) && isdefined(self.timeplayed["total"]))
	{
		minutespassed = self.timeplayed["total"] / 60;
	}
	self.eventsperminute = self.numbombevents / minutespassed;
	if(self.eventsperminute > self.numbombevents)
	{
		self.eventsperminute = self.numbombevents;
	}
}

/*
	Name: isscoreboosting
	Namespace: dem
	Checksum: 0x7A76EB75
	Offset: 0x5BB8
	Size: 0x64
	Parameters: 2
	Flags: None
*/
function isscoreboosting(player, flag)
{
	if(!level.rankedmatch)
	{
		return false;
	}
	if(player.eventsperminute > level.playereventslpm)
	{
		return true;
	}
	if(flag.eventsperminute > level.bombeventslpm)
	{
		return true;
	}
	return false;
}

