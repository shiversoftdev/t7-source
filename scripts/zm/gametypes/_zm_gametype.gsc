// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\music_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_game_module;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_defaults;
#using scripts\zm\gametypes\_globallogic_score;
#using scripts\zm\gametypes\_globallogic_spawn;
#using scripts\zm\gametypes\_globallogic_ui;
#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_hud_message;
#using scripts\zm\gametypes\_spawning;
#using scripts\zm\gametypes\_weapons;

#namespace zm_gametype;

/*
	Name: main
	Namespace: zm_gametype
	Checksum: 0x783FA47F
	Offset: 0xAF0
	Size: 0x654
	Parameters: 0
	Flags: Linked
*/
function main()
{
	globallogic::init();
	globallogic_setupdefault_zombiecallbacks();
	menu_init();
	util::registerroundlimit(1, 1);
	util::registertimelimit(0, 0);
	util::registerscorelimit(0, 0);
	util::registerroundwinlimit(0, 0);
	util::registernumlives(1, 1);
	weapons::registergrenadelauncherduddvar(level.gametype, 10, 0, 1440);
	weapons::registerthrowngrenadeduddvar(level.gametype, 0, 0, 1440);
	weapons::registerkillstreakdelay(level.gametype, 0, 0, 1440);
	globallogic::registerfriendlyfiredelay(level.gametype, 15, 0, 1440);
	level.takelivesondeath = 1;
	level.teambased = 1;
	level.disableprematchmessages = 1;
	level.disablemomentum = 1;
	level.overrideteamscore = 0;
	level.overrideplayerscore = 0;
	level.displayhalftimetext = 0;
	level.displayroundendtext = 0;
	level.allowannouncer = 0;
	level.endgameonscorelimit = 0;
	level.endgameontimelimit = 0;
	level.resetplayerscoreeveryround = 1;
	level.doprematch = 0;
	level.nopersistence = 1;
	level.cumulativeroundscores = 1;
	level.forceautoassign = 1;
	level.dontshowendreason = 1;
	level.forceallallies = 1;
	level.allow_teamchange = 0;
	setdvar("scr_disable_team_selection", 1);
	setdvar("scr_disable_weapondrop", 1);
	level.onstartgametype = &onstartgametype;
	level.onspawnplayer = &globallogic::blank;
	level.onspawnplayerunified = &onspawnplayerunified;
	level.onroundendgame = &onroundendgame;
	level.playermayspawn = &mayspawn;
	zm_utility::set_game_var("ZM_roundLimit", 1);
	zm_utility::set_game_var("ZM_scoreLimit", 1);
	zm_utility::set_game_var("_team1_num", 0);
	zm_utility::set_game_var("_team2_num", 0);
	map_name = level.script;
	mode = getdvarstring("ui_gametype");
	if(!isdefined(mode) || mode == "" && isdefined(level.default_game_mode))
	{
		mode = level.default_game_mode;
	}
	zm_utility::set_gamemode_var_once("mode", mode);
	zm_utility::set_game_var_once("side_selection", 1);
	location = level.default_start_location;
	zm_utility::set_gamemode_var_once("location", location);
	zm_utility::set_gamemode_var_once("randomize_mode", getdvarint("zm_rand_mode"));
	zm_utility::set_gamemode_var_once("randomize_location", getdvarint("zm_rand_loc"));
	zm_utility::set_gamemode_var_once("team_1_score", 0);
	zm_utility::set_gamemode_var_once("team_2_score", 0);
	zm_utility::set_gamemode_var_once("current_round", 0);
	zm_utility::set_gamemode_var_once("rules_read", 0);
	zm_utility::set_game_var_once("switchedsides", 0);
	gametype = getdvarstring("ui_gametype");
	game["dialog"]["gametype"] = gametype + "_start";
	game["dialog"]["gametype_hardcore"] = gametype + "_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	zm_utility::set_gamemode_var("pre_init_zombie_spawn_func", undefined);
	zm_utility::set_gamemode_var("post_init_zombie_spawn_func", undefined);
	zm_utility::set_gamemode_var("match_end_notify", undefined);
	zm_utility::set_gamemode_var("match_end_func", undefined);
	setscoreboardcolumns("score", "kills", "downs", "revives", "headshots");
	callback::on_connect(&onplayerconnect_check_for_hotjoin);
}

/*
	Name: globallogic_setupdefault_zombiecallbacks
	Namespace: zm_gametype
	Checksum: 0x9F68562F
	Offset: 0x1150
	Size: 0x4D4
	Parameters: 0
	Flags: Linked
*/
function globallogic_setupdefault_zombiecallbacks()
{
	level.spawnplayer = &globallogic_spawn::spawnplayer;
	level.spawnplayerprediction = &globallogic_spawn::spawnplayerprediction;
	level.spawnclient = &globallogic_spawn::spawnclient;
	level.spawnspectator = &globallogic_spawn::spawnspectator;
	level.spawnintermission = &globallogic_spawn::spawnintermission;
	level.scoreongiveplayerscore = &globallogic_score::giveplayerscore;
	level.onplayerscore = &globallogic::blank;
	level.onteamscore = &globallogic::blank;
	level.wavespawntimer = &globallogic::wavespawntimer;
	level.onspawnplayer = &globallogic::blank;
	level.onspawnplayerunified = &globallogic::blank;
	level.onspawnspectator = &onspawnspectator;
	level.onspawnintermission = &onspawnintermission;
	level.onrespawndelay = &globallogic::blank;
	level.onforfeit = &globallogic::blank;
	level.ontimelimit = &globallogic::blank;
	level.onscorelimit = &globallogic::blank;
	level.ondeadevent = &ondeadevent;
	level.ononeleftevent = &globallogic::blank;
	level.giveteamscore = &globallogic::blank;
	level.gettimepassed = &globallogic_utils::gettimepassed;
	level.gettimelimit = &globallogic_defaults::default_gettimelimit;
	level.getteamkillpenalty = &globallogic::blank;
	level.getteamkillscore = &globallogic::blank;
	level.iskillboosting = &globallogic::blank;
	level._setteamscore = &globallogic_score::_setteamscore;
	level._setplayerscore = &globallogic::blank;
	level._getteamscore = &globallogic::blank;
	level._getplayerscore = &globallogic::blank;
	level.onprecachegametype = &globallogic::blank;
	level.onstartgametype = &globallogic::blank;
	level.onplayerconnect = &globallogic::blank;
	level.onplayerdisconnect = &onplayerdisconnect;
	level.onplayerdamage = &globallogic::blank;
	level.onplayerkilled = &globallogic::blank;
	level.onplayerkilledextraunthreadedcbs = [];
	level.onteamoutcomenotify = &hud_message::teamoutcomenotifyzombie;
	level.onoutcomenotify = &globallogic::blank;
	level.onteamwageroutcomenotify = &globallogic::blank;
	level.onwageroutcomenotify = &globallogic::blank;
	level.onendgame = &onendgame;
	level.onroundendgame = &globallogic::blank;
	level.onmedalawarded = &globallogic::blank;
	level.dogmanagerongetdogs = &globallogic::blank;
	level.autoassign = &globallogic_ui::menuautoassign;
	level.spectator = &globallogic_ui::menuspectator;
	level.curclass = &globallogic_ui::menuclass;
	level.allies = &menuallieszombies;
	level.teammenu = &globallogic_ui::menuteam;
	level.callbackactorkilled = &globallogic::blank;
	level.callbackvehicledamage = &globallogic::blank;
	level.callbackvehiclekilled = &globallogic::blank;
}

/*
	Name: do_game_mode_shellshock
	Namespace: zm_gametype
	Checksum: 0xE2FEFFD6
	Offset: 0x1630
	Size: 0x58
	Parameters: 0
	Flags: None
*/
function do_game_mode_shellshock()
{
	self endon(#"disconnect");
	self._being_shellshocked = 1;
	self shellshock("grief_stab_zm", 0.75);
	wait(0.75);
	self._being_shellshocked = 0;
}

/*
	Name: canplayersuicide
	Namespace: zm_gametype
	Checksum: 0x19B751C5
	Offset: 0x1690
	Size: 0x6
	Parameters: 0
	Flags: Linked
*/
function canplayersuicide()
{
	return false;
}

/*
	Name: onplayerdisconnect
	Namespace: zm_gametype
	Checksum: 0xF848057E
	Offset: 0x16A0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function onplayerdisconnect()
{
	if(isdefined(level.game_mode_custom_onplayerdisconnect))
	{
		level [[level.game_mode_custom_onplayerdisconnect]](self);
	}
	if(isdefined(level.check_quickrevive_hotjoin))
	{
		level thread [[level.check_quickrevive_hotjoin]]();
	}
	self zm_laststand::add_weighted_down();
	level zm::checkforalldead(self);
}

/*
	Name: ondeadevent
	Namespace: zm_gametype
	Checksum: 0xED8BF7D9
	Offset: 0x1718
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function ondeadevent(team)
{
	thread globallogic::endgame(level.zombie_team, "");
}

/*
	Name: onspawnintermission
	Namespace: zm_gametype
	Checksum: 0xEBE2A04
	Offset: 0x1750
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function onspawnintermission()
{
	spawnpointname = "info_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	if(spawnpoints.size < 1)
	{
		/#
			println(("" + spawnpointname) + "");
		#/
		return;
	}
	spawnpoint = spawnpoints[randomint(spawnpoints.size)];
	if(isdefined(spawnpoint))
	{
		self spawn(spawnpoint.origin, spawnpoint.angles);
	}
}

/*
	Name: onspawnspectator
	Namespace: zm_gametype
	Checksum: 0x61458BE8
	Offset: 0x1838
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function onspawnspectator(origin, angles)
{
}

/*
	Name: mayspawn
	Namespace: zm_gametype
	Checksum: 0x28F4AD58
	Offset: 0x1858
	Size: 0x5A
	Parameters: 0
	Flags: Linked
*/
function mayspawn()
{
	if(isdefined(level.custommayspawnlogic))
	{
		return self [[level.custommayspawnlogic]]();
	}
	if(self.pers["lives"] == 0)
	{
		level notify(#"player_eliminated");
		self notify(#"player_eliminated");
		return 0;
	}
	return 1;
}

/*
	Name: onstartgametype
	Namespace: zm_gametype
	Checksum: 0x1A23C67B
	Offset: 0x18C0
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function onstartgametype()
{
	setclientnamemode("auto_change");
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	structs = struct::get_array("player_respawn_point", "targetname");
	foreach(struct in structs)
	{
		level.spawnmins = math::expand_mins(level.spawnmins, struct.origin);
		level.spawnmaxs = math::expand_maxs(level.spawnmaxs, struct.origin);
	}
	level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
	setmapcenter(level.mapcenter);
	level.displayroundendtext = 0;
	spawning::create_map_placed_influencers();
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
	Name: onspawnplayerunified
	Namespace: zm_gametype
	Checksum: 0xA9D6F9D0
	Offset: 0x1A98
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function onspawnplayerunified()
{
	onspawnplayer(0);
}

/*
	Name: onfindvalidspawnpoint
	Namespace: zm_gametype
	Checksum: 0xA136A1F9
	Offset: 0x1AC0
	Size: 0x31C
	Parameters: 0
	Flags: Linked
*/
function onfindvalidspawnpoint()
{
	/#
		println("");
	#/
	if(level flag::get("begin_spawning"))
	{
		spawnpoint = zm::check_for_valid_spawn_near_team(self, 1);
		/#
			if(!isdefined(spawnpoint))
			{
				println("");
			}
		#/
	}
	if(!isdefined(spawnpoint))
	{
		match_string = "";
		location = level.scr_zm_map_start_location;
		if(location == "default" || location == "" && isdefined(level.default_start_location))
		{
			location = level.default_start_location;
		}
		match_string = (level.scr_zm_ui_gametype + "_") + location;
		spawnpoints = [];
		structs = struct::get_array("initial_spawn", "script_noteworthy");
		if(isdefined(structs))
		{
			foreach(struct in structs)
			{
				if(isdefined(struct.script_string))
				{
					tokens = strtok(struct.script_string, " ");
					foreach(token in tokens)
					{
						if(token == match_string)
						{
							spawnpoints[spawnpoints.size] = struct;
						}
					}
				}
			}
		}
		if(!isdefined(spawnpoints) || spawnpoints.size == 0)
		{
			spawnpoints = struct::get_array("initial_spawn_points", "targetname");
		}
		/#
			assert(isdefined(spawnpoints), "");
		#/
		spawnpoint = zm::getfreespawnpoint(spawnpoints, self);
	}
	return spawnpoint;
}

/*
	Name: onspawnplayer
	Namespace: zm_gametype
	Checksum: 0xACBE64EA
	Offset: 0x1DE8
	Size: 0x374
	Parameters: 1
	Flags: Linked
*/
function onspawnplayer(predictedspawn = 0)
{
	pixbeginevent("ZSURVIVAL:onSpawnPlayer");
	self.usingobj = undefined;
	self.is_zombie = 0;
	zm::updateplayernum(self);
	if(isdefined(level.custom_spawnplayer) && (isdefined(self.player_initialized) && self.player_initialized))
	{
		self [[level.custom_spawnplayer]]();
		return;
	}
	if(isdefined(level.customspawnlogic))
	{
		/#
			println("");
		#/
		spawnpoint = self [[level.customspawnlogic]](predictedspawn);
		if(predictedspawn)
		{
			return;
		}
	}
	else
	{
		/#
			println("");
		#/
		spawnpoint = self onfindvalidspawnpoint();
		if(predictedspawn)
		{
			self predictspawnpoint(spawnpoint.origin, spawnpoint.angles);
			return;
		}
		self spawn(spawnpoint.origin, spawnpoint.angles, "zsurvival");
	}
	self.entity_num = self getentitynumber();
	self thread zm::onplayerspawned();
	self thread zm::player_revive_monitor();
	self freezecontrols(1);
	self.spectator_respawn = spawnpoint;
	self.score = self globallogic_score::getpersstat("score");
	self.pers["participation"] = 0;
	/#
		if(getdvarint("") >= 1)
		{
			self.score = 100000;
		}
	#/
	self.score_total = self.score;
	self.old_score = self.score;
	self.player_initialized = 0;
	self.zombification_time = 0;
	self.enabletext = 1;
	self thread zm_blockers::rebuild_barrier_reward_reset();
	if(!(isdefined(level.host_ended_game) && level.host_ended_game))
	{
		self util::freeze_player_controls(0);
		self enableweapons();
	}
	if(isdefined(level.game_mode_spawn_player_logic))
	{
		spawn_in_spectate = [[level.game_mode_spawn_player_logic]]();
		if(spawn_in_spectate)
		{
			self util::delay(0.05, undefined, &zm::spawnspectator);
		}
	}
	pixendevent();
}

/*
	Name: get_player_spawns_for_gametype
	Namespace: zm_gametype
	Checksum: 0x42F8595A
	Offset: 0x2168
	Size: 0x21E
	Parameters: 0
	Flags: Linked
*/
function get_player_spawns_for_gametype()
{
	match_string = "";
	location = level.scr_zm_map_start_location;
	if(location == "default" || location == "" && isdefined(level.default_start_location))
	{
		location = level.default_start_location;
	}
	match_string = (level.scr_zm_ui_gametype + "_") + location;
	player_spawns = [];
	structs = struct::get_array("player_respawn_point", "targetname");
	foreach(struct in structs)
	{
		if(isdefined(struct.script_string))
		{
			tokens = strtok(struct.script_string, " ");
			foreach(token in tokens)
			{
				if(token == match_string)
				{
					player_spawns[player_spawns.size] = struct;
				}
			}
			continue;
		}
		player_spawns[player_spawns.size] = struct;
	}
	return player_spawns;
}

/*
	Name: onendgame
	Namespace: zm_gametype
	Checksum: 0x296DDE4C
	Offset: 0x2390
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function onendgame(winningteam)
{
}

/*
	Name: onroundendgame
	Namespace: zm_gametype
	Checksum: 0x119131E8
	Offset: 0x23A8
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function onroundendgame(roundwinner)
{
	if(game["roundswon"]["allies"] == game["roundswon"]["axis"])
	{
		winner = "tie";
	}
	else
	{
		if(game["roundswon"]["axis"] > game["roundswon"]["allies"])
		{
			winner = "axis";
		}
		else
		{
			winner = "allies";
		}
	}
	return winner;
}

/*
	Name: menu_init
	Namespace: zm_gametype
	Checksum: 0x8EBF43F3
	Offset: 0x2458
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function menu_init()
{
	game["menu_team"] = "ChangeTeam";
	game["menu_changeclass_allies"] = "ChooseClass_InGame";
	game["menu_initteam_allies"] = "initteam_marines";
	game["menu_changeclass_axis"] = "ChooseClass_InGame";
	game["menu_initteam_axis"] = "initteam_opfor";
	game["menu_class"] = "class";
	game["menu_start_menu"] = "StartMenu_Main";
	game["menu_changeclass"] = "ChooseClass_InGame";
	game["menu_changeclass_offline"] = "ChooseClass_InGame";
	game["menu_wager_side_bet"] = "sidebet";
	game["menu_wager_side_bet_player"] = "sidebet_player";
	game["menu_changeclass_wager"] = "changeclass_wager";
	game["menu_changeclass_custom"] = "changeclass_custom";
	game["menu_changeclass_barebones"] = "changeclass_barebones";
	game["menu_controls"] = "ingame_controls";
	game["menu_options"] = "ingame_options";
	game["menu_leavegame"] = "popup_leavegame";
	game["menu_restartgamepopup"] = "restartgamepopup";
	level thread menu_onplayerconnect();
}

/*
	Name: menu_onplayerconnect
	Namespace: zm_gametype
	Checksum: 0xB7A889FB
	Offset: 0x25E8
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function menu_onplayerconnect()
{
	for(;;)
	{
		level waittill(#"connecting", player);
		player thread menu_onmenuresponse();
	}
}

/*
	Name: menu_onmenuresponse
	Namespace: zm_gametype
	Checksum: 0x1A981B2D
	Offset: 0x2628
	Size: 0x75C
	Parameters: 0
	Flags: Linked
*/
function menu_onmenuresponse()
{
	self endon(#"disconnect");
	for(;;)
	{
		self waittill(#"menuresponse", menu, response);
		if(response == "back")
		{
			self closeingamemenu();
			if(level.console)
			{
				if(menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_team"] || menu == game["menu_controls"])
				{
					if(self.pers["team"] == "allies")
					{
						self openmenu(game["menu_start_menu"]);
					}
					if(self.pers["team"] == "axis")
					{
						self openmenu(game["menu_start_menu"]);
					}
				}
			}
			continue;
		}
		if(response == "changeteam" && level.allow_teamchange == "1")
		{
			self closeingamemenu();
			self openmenu(game["menu_team"]);
		}
		if(response == "changeclass_marines")
		{
			self closeingamemenu();
			self openmenu(game["menu_changeclass_allies"]);
			continue;
		}
		if(response == "changeclass_opfor")
		{
			self closeingamemenu();
			self openmenu(game["menu_changeclass_axis"]);
			continue;
		}
		if(response == "changeclass_wager")
		{
			self closeingamemenu();
			self openmenu(game["menu_changeclass_wager"]);
			continue;
		}
		if(response == "changeclass_custom")
		{
			self closeingamemenu();
			self openmenu(game["menu_changeclass_custom"]);
			continue;
		}
		if(response == "changeclass_barebones")
		{
			self closeingamemenu();
			self openmenu(game["menu_changeclass_barebones"]);
			continue;
		}
		if(response == "changeclass_marines_splitscreen")
		{
			self openmenu("changeclass_marines_splitscreen");
		}
		if(response == "changeclass_opfor_splitscreen")
		{
			self openmenu("changeclass_opfor_splitscreen");
		}
		if(response == "endgame")
		{
			if(self issplitscreen())
			{
				level.skipvote = 1;
				if(!(isdefined(level.gameended) && level.gameended))
				{
					self zm_laststand::add_weighted_down();
					self zm_stats::increment_client_stat("deaths");
					self zm_stats::increment_player_stat("deaths");
					self zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
					level.host_ended_game = 1;
					zm_game_module::freeze_players(1);
					level notify(#"end_game");
				}
			}
			continue;
		}
		if(response == "restart_level_zm")
		{
			self zm_laststand::add_weighted_down();
			self zm_stats::increment_client_stat("deaths");
			self zm_stats::increment_player_stat("deaths");
			self zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
			missionfailed();
		}
		if(response == "killserverpc")
		{
			level thread globallogic::killserverpc();
			continue;
		}
		if(response == "endround")
		{
			if(!(isdefined(level.gameended) && level.gameended))
			{
				self globallogic::gamehistoryplayerquit();
				self zm_laststand::add_weighted_down();
				self closeingamemenu();
				level.host_ended_game = 1;
				zm_game_module::freeze_players(1);
				level notify(#"end_game");
			}
			else
			{
				self closeingamemenu();
				self iprintln(&"MP_HOST_ENDGAME_RESPONSE");
			}
			continue;
		}
		if(menu == game["menu_team"] && level.allow_teamchange == "1")
		{
			switch(response)
			{
				case "allies":
				{
					self [[level.allies]]();
					break;
				}
				case "axis":
				{
					self [[level.teammenu]](response);
					break;
				}
				case "autoassign":
				{
					self [[level.autoassign]](1);
					break;
				}
				case "spectator":
				{
					self [[level.spectator]]();
					break;
				}
			}
			continue;
		}
		if(menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_changeclass_wager"] || menu == game["menu_changeclass_custom"] || menu == game["menu_changeclass_barebones"])
		{
			self closeingamemenu();
			self.selectedclass = 1;
			self [[level.curclass]](response);
		}
	}
}

/*
	Name: menuallieszombies
	Namespace: zm_gametype
	Checksum: 0x7E41310C
	Offset: 0x2D90
	Size: 0x1FA
	Parameters: 0
	Flags: Linked
*/
function menuallieszombies()
{
	self globallogic_ui::closemenus();
	if(!level.console && level.allow_teamchange == "0" && (isdefined(self.hasdonecombat) && self.hasdonecombat))
	{
		return;
	}
	if(self.pers["team"] != "allies")
	{
		if(level.ingraceperiod && (!isdefined(self.hasdonecombat) || !self.hasdonecombat))
		{
			self.hasspawned = 0;
		}
		if(self.sessionstate == "playing")
		{
			self.switching_teams = 1;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			self suicide();
		}
		self.pers["team"] = "allies";
		self.team = "allies";
		self.pers["class"] = undefined;
		self.curclass = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;
		self globallogic_ui::updateobjectivetext();
		self.sessionteam = "allies";
		self setclientscriptmainmenu(game["menu_start_menu"]);
		self notify(#"joined_team");
		level notify(#"joined_team");
		self callback::callback(#"hash_95a6c4c0");
		self notify(#"end_respawn");
	}
}

/*
	Name: custom_spawn_init_func
	Namespace: zm_gametype
	Checksum: 0x6395C280
	Offset: 0x2F98
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function custom_spawn_init_func()
{
	array::thread_all(level.zombie_spawners, &spawner::add_spawn_function, &zm_spawner::zombie_spawn_init);
	array::thread_all(level.zombie_spawners, &spawner::add_spawn_function, level._zombies_round_spawn_failsafe);
}

/*
	Name: init
	Namespace: zm_gametype
	Checksum: 0x9CDD9EA3
	Offset: 0x3010
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function init()
{
	level flag::init("pregame");
	level flag::set("pregame");
	level thread onplayerconnect();
}

/*
	Name: onplayerconnect
	Namespace: zm_gametype
	Checksum: 0x4B694B63
	Offset: 0x3078
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect()
{
	for(;;)
	{
		level waittill(#"connected", player);
		player thread onplayerspawned();
		if(isdefined(level.game_module_onplayerconnect))
		{
			player [[level.game_module_onplayerconnect]]();
		}
	}
}

/*
	Name: onplayerspawned
	Namespace: zm_gametype
	Checksum: 0x6B82615A
	Offset: 0x30D8
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function onplayerspawned()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	for(;;)
	{
		self util::waittill_either("spawned_player", "fake_spawned_player");
		if(isdefined(level.match_is_ending) && level.match_is_ending)
		{
			return;
		}
		if(self laststand::player_is_in_laststand())
		{
			self thread zm_laststand::auto_revive(self);
		}
		if(isdefined(level.custom_player_fake_death_cleanup))
		{
			self [[level.custom_player_fake_death_cleanup]]();
		}
		self setstance("stand");
		self.zmbdialogqueue = [];
		self.zmbdialogactive = 0;
		self.zmbdialoggroups = [];
		self.zmbdialoggroup = "";
		self takeallweapons();
		if(isdefined(level.givecustomcharacters))
		{
			self [[level.givecustomcharacters]]();
		}
		self giveweapon(level.weaponbasemelee);
		if(isdefined(level.onplayerspawned_restore_previous_weapons) && (isdefined(level.isresetting_grief) && level.isresetting_grief))
		{
			weapons_restored = self [[level.onplayerspawned_restore_previous_weapons]]();
		}
		if(!(isdefined(weapons_restored) && weapons_restored))
		{
			self zm_utility::give_start_weapon(1);
		}
		weapons_restored = 0;
		if(isdefined(level._team_loadout))
		{
			self giveweapon(level._team_loadout);
			self switchtoweapon(level._team_loadout);
		}
		if(isdefined(level.gamemode_post_spawn_logic))
		{
			self [[level.gamemode_post_spawn_logic]]();
		}
	}
}

/*
	Name: onplayerconnect_check_for_hotjoin
	Namespace: zm_gametype
	Checksum: 0x3BB5EE96
	Offset: 0x32F8
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect_check_for_hotjoin()
{
	/#
		if(getdvarint("") > 0)
		{
			return;
		}
	#/
	map_logic_exists = level flag::exists("start_zombie_round_logic");
	map_logic_started = level flag::get("start_zombie_round_logic");
	if(map_logic_exists && map_logic_started)
	{
		self thread player_hotjoin();
	}
}

/*
	Name: player_hotjoin
	Namespace: zm_gametype
	Checksum: 0xB8D9C228
	Offset: 0x33A8
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function player_hotjoin()
{
	self endon(#"disconnect");
	self initialblack();
	self.rebuild_barrier_reward = 1;
	self.is_hotjoining = 1;
	wait(0.5);
	if(isdefined(level.givecustomcharacters))
	{
		self [[level.givecustomcharacters]]();
	}
	self zm::spawnspectator();
	music::setmusicstate("none");
	self.is_hotjoining = 0;
	self.is_hotjoin = 1;
	self thread wait_fade_in();
	if(isdefined(level.intermission) && level.intermission || (isdefined(level.host_ended_game) && level.host_ended_game))
	{
		self setclientthirdperson(0);
		self resetfov();
		self.health = 100;
		self thread [[level.custom_intermission]]();
	}
}

/*
	Name: wait_fade_in
	Namespace: zm_gametype
	Checksum: 0xB4B3DEA8
	Offset: 0x34E8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function wait_fade_in()
{
	self util::streamer_wait(undefined, 0, 30);
	if(isdefined(level.hotjoin_extra_blackscreen_time))
	{
		wait(level.hotjoin_extra_blackscreen_time);
	}
	initialblackend();
}

/*
	Name: initialblack
	Namespace: zm_gametype
	Checksum: 0xCC42AF6B
	Offset: 0x3540
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function initialblack()
{
	self closemenu("InitialBlack");
	self openmenu("InitialBlack");
}

/*
	Name: initialblackend
	Namespace: zm_gametype
	Checksum: 0xBFDBF3DE
	Offset: 0x3590
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function initialblackend()
{
	self closemenu("InitialBlack");
}

