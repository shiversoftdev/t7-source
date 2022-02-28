// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_util;
#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_save;
#using scripts\cp\gametypes\_spectating;
#using scripts\cp\teams\_teams;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\string_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace globallogic_ui;

/*
	Name: init
	Namespace: globallogic_ui
	Checksum: 0xBCCF1CF4
	Offset: 0x658
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	callback::add_callback(#"hash_bc12b61f", &on_player_spawn);
	clientfield::register("clientuimodel", "hudItems.cybercoreSelectMenuDisabled", 1, 1, "int");
	clientfield::register("clientuimodel", "hudItems.playerInCombat", 1, 1, "int");
	clientfield::register("clientuimodel", "playerAbilities.repulsorIndicatorDirection", 1, 2, "int");
	clientfield::register("clientuimodel", "playerAbilities.repulsorIndicatorIntensity", 1, 2, "int");
	clientfield::register("clientuimodel", "playerAbilities.proximityIndicatorDirection", 1, 2, "int");
	clientfield::register("clientuimodel", "playerAbilities.proximityIndicatorIntensity", 1, 2, "int");
	clientfield::register("clientuimodel", "serverDifficulty", 1, 3, "int");
}

/*
	Name: on_player_spawn
	Namespace: globallogic_ui
	Checksum: 0xA330C9A5
	Offset: 0x7E0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function on_player_spawn()
{
	self thread watch_player_in_combat();
	/#
		assert(isdefined(level.gameskill));
	#/
	self clientfield::set_player_uimodel("serverDifficulty", level.gameskill);
}

/*
	Name: isanyaiattackingtheplayer
	Namespace: globallogic_ui
	Checksum: 0x6C74607D
	Offset: 0x850
	Size: 0x1A0
	Parameters: 1
	Flags: Linked
*/
function isanyaiattackingtheplayer(playerent)
{
	ais = getaiteamarray("axis");
	ais = arraycombine(ais, getaiteamarray("team3"), 0, 0);
	foreach(ai in ais)
	{
		if(issentient(ai))
		{
			if(ai attackedrecently(playerent, 10))
			{
				return true;
			}
			if(ai.enemy === playerent && isdefined(ai.weapon) && ai.weapon.name === "none" && distancesquared(ai.origin, playerent.origin) < (240 * 240))
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: isanyaiawareofplayer
	Namespace: globallogic_ui
	Checksum: 0x1D89981B
	Offset: 0x9F8
	Size: 0x116
	Parameters: 1
	Flags: None
*/
function isanyaiawareofplayer(playerent)
{
	ais = getaiteamarray("axis");
	ais = arraycombine(ais, getaiteamarray("team3"), 0, 0);
	foreach(ai in ais)
	{
		if(issentient(ai))
		{
			if((ai lastknowntime(playerent) + 4000) >= gettime())
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: isplayerhurt
	Namespace: globallogic_ui
	Checksum: 0x58DB2E83
	Offset: 0xB18
	Size: 0x28
	Parameters: 1
	Flags: Linked
*/
function isplayerhurt(playerent)
{
	return playerent.health < playerent.maxhealth;
}

/*
	Name: watch_player_in_combat
	Namespace: globallogic_ui
	Checksum: 0x35313C8A
	Offset: 0xB48
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function watch_player_in_combat()
{
	self endon(#"kill_watch_player_in_combat");
	self endon(#"disconnect");
	while(true)
	{
		if(isplayerhurt(self) || isanyaiattackingtheplayer(self))
		{
			self clientfield::set_player_uimodel("hudItems.playerInCombat", 1);
		}
		else
		{
			self clientfield::set_player_uimodel("hudItems.playerInCombat", 0);
		}
		wait(0.5);
	}
}

/*
	Name: setupcallbacks
	Namespace: globallogic_ui
	Checksum: 0x9D2CA19F
	Offset: 0xBE8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function setupcallbacks()
{
	level.autoassign = &menuautoassign;
	level.spectator = &menuspectator;
	level.curclass = &menuclass;
	level.teammenu = &menuteam;
}

/*
	Name: freegameplayhudelems
	Namespace: globallogic_ui
	Checksum: 0xE5B262B4
	Offset: 0xC58
	Size: 0x27C
	Parameters: 0
	Flags: Linked
*/
function freegameplayhudelems()
{
	if(isdefined(self.perkicon))
	{
		for(numspecialties = 0; numspecialties < level.maxspecialties; numspecialties++)
		{
			if(isdefined(self.perkicon[numspecialties]))
			{
				self.perkicon[numspecialties] hud::destroyelem();
				self.perkname[numspecialties] hud::destroyelem();
			}
		}
	}
	if(isdefined(self.perkhudelem))
	{
		self.perkhudelem hud::destroyelem();
	}
	if(isdefined(self.killstreakicon))
	{
		if(isdefined(self.killstreakicon[0]))
		{
			self.killstreakicon[0] hud::destroyelem();
		}
		if(isdefined(self.killstreakicon[1]))
		{
			self.killstreakicon[1] hud::destroyelem();
		}
		if(isdefined(self.killstreakicon[2]))
		{
			self.killstreakicon[2] hud::destroyelem();
		}
		if(isdefined(self.killstreakicon[3]))
		{
			self.killstreakicon[3] hud::destroyelem();
		}
		if(isdefined(self.killstreakicon[4]))
		{
			self.killstreakicon[4] hud::destroyelem();
		}
	}
	if(isdefined(self.lowermessage))
	{
		self.lowermessage hud::destroyelem();
	}
	if(isdefined(self.lowertimer))
	{
		self.lowertimer hud::destroyelem();
	}
	if(isdefined(self.proxbar))
	{
		self.proxbar hud::destroyelem();
	}
	if(isdefined(self.proxbartext))
	{
		self.proxbartext hud::destroyelem();
	}
	if(isdefined(self.carryicon))
	{
		self.carryicon hud::destroyelem();
	}
}

/*
	Name: teamplayercountsequal
	Namespace: globallogic_ui
	Checksum: 0x7FE78B3E
	Offset: 0xEE0
	Size: 0xC6
	Parameters: 1
	Flags: None
*/
function teamplayercountsequal(playercounts)
{
	count = undefined;
	foreach(team in level.teams)
	{
		if(!isdefined(count))
		{
			count = playercounts[team];
			continue;
		}
		if(count != playercounts[team])
		{
			return false;
		}
	}
	return true;
}

/*
	Name: teamwithlowestplayercount
	Namespace: globallogic_ui
	Checksum: 0xD24F32C3
	Offset: 0xFB0
	Size: 0xDA
	Parameters: 2
	Flags: None
*/
function teamwithlowestplayercount(playercounts, ignore_team)
{
	count = 9999;
	lowest_team = undefined;
	foreach(team in level.teams)
	{
		if(count > playercounts[team])
		{
			count = playercounts[team];
			lowest_team = team;
		}
	}
	return lowest_team;
}

/*
	Name: menuautoassign
	Namespace: globallogic_ui
	Checksum: 0xF699C3C7
	Offset: 0x1098
	Size: 0x36C
	Parameters: 1
	Flags: Linked
*/
function menuautoassign(comingfrommenu)
{
	teamkeys = getarraykeys(level.teams);
	assignment = teamkeys[randomint(teamkeys.size)];
	self closemenus();
	assignment = "allies";
	if(level.teambased)
	{
		if(assignment == self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead"))
		{
			self beginclasschoice();
			return;
		}
	}
	else if(getdvarint("party_autoteams") == 1)
	{
		if(level.allow_teamchange != "1" || (!self.hasspawned && !comingfrommenu))
		{
			team = getassignedteam(self);
			if(isdefined(level.teams[team]))
			{
				assignment = team;
			}
			else if(team == "spectator" && !level.forceautoassign)
			{
				self setclientscriptmainmenu(game["menu_start_menu"]);
				return;
			}
		}
	}
	if(assignment != self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead"))
	{
		self.switching_teams = 1;
		self.switchedteamsresetgadgets = 1;
		self.joining_team = assignment;
		self.leaving_team = self.pers["team"];
		self suicide();
	}
	self.pers["team"] = assignment;
	self.team = assignment;
	self.pers["class"] = undefined;
	self.curclass = undefined;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	self updateobjectivetext();
	self.sessionteam = assignment;
	if(!isalive(self))
	{
		self.statusicon = "hud_status_dead";
	}
	self notify(#"joined_team");
	level notify(#"joined_team");
	callback::callback(#"hash_95a6c4c0");
	self notify(#"end_respawn");
	self beginclasschoice();
	self setclientscriptmainmenu(game["menu_start_menu"]);
}

/*
	Name: teamscoresequal
	Namespace: globallogic_ui
	Checksum: 0xCE8ABEE3
	Offset: 0x1410
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function teamscoresequal()
{
	score = undefined;
	foreach(team in level.teams)
	{
		if(!isdefined(score))
		{
			score = getteamscore(team);
			continue;
		}
		if(score != getteamscore(team))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: teamwithlowestscore
	Namespace: globallogic_ui
	Checksum: 0x5A41CF0
	Offset: 0x14E8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function teamwithlowestscore()
{
	score = 99999999;
	lowest_team = undefined;
	foreach(team in level.teams)
	{
		if(score > getteamscore(team))
		{
			lowest_team = team;
		}
	}
	return lowest_team;
}

/*
	Name: pickteamfromscores
	Namespace: globallogic_ui
	Checksum: 0x5808531B
	Offset: 0x15B8
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function pickteamfromscores(teams)
{
	assignment = "allies";
	if(teamscoresequal())
	{
		assignment = teams[randomint(teams.size)];
	}
	else
	{
		assignment = teamwithlowestscore();
	}
	return assignment;
}

/*
	Name: get_splitscreen_team
	Namespace: globallogic_ui
	Checksum: 0x36A9D295
	Offset: 0x1638
	Size: 0xCE
	Parameters: 0
	Flags: None
*/
function get_splitscreen_team()
{
	for(index = 0; index < level.players.size; index++)
	{
		if(!isdefined(level.players[index]))
		{
			continue;
		}
		if(level.players[index] == self)
		{
			continue;
		}
		if(!self isplayeronsamemachine(level.players[index]))
		{
			continue;
		}
		team = level.players[index].sessionteam;
		if(team != "spectator")
		{
			return team;
		}
	}
	return "";
}

/*
	Name: updateobjectivetext
	Namespace: globallogic_ui
	Checksum: 0x9C684EA2
	Offset: 0x1710
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function updateobjectivetext()
{
	if(sessionmodeiszombiesgame() || self.pers["team"] == "spectator")
	{
		self setclientcgobjectivetext("");
		return;
	}
	if(level.scorelimit > 0)
	{
		self setclientcgobjectivetext(util::getobjectivescoretext(self.pers["team"]));
	}
	else
	{
		self setclientcgobjectivetext(util::getobjectivetext(self.pers["team"]));
	}
}

/*
	Name: closemenus
	Namespace: globallogic_ui
	Checksum: 0x2117FDCB
	Offset: 0x17F0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function closemenus()
{
	self closeingamemenu();
}

/*
	Name: beginclasschoice
	Namespace: globallogic_ui
	Checksum: 0x36E13DAD
	Offset: 0x1818
	Size: 0x2AC
	Parameters: 0
	Flags: Linked
*/
function beginclasschoice()
{
	/#
		assert(isdefined(level.teams[self.pers[""]]));
	#/
	team = self.pers["team"];
	self closemenu(game["menu_start_menu"]);
	if(!getdvarint("art_review", 0))
	{
		self thread fullscreen_black();
	}
	b_disable_cac = getdvarint("force_no_cac", 0);
	if(!getdvarint("force_cac", 0) || b_disable_cac)
	{
		prevclass = self savegame::get_player_data("playerClass", undefined);
		var_d47d35d1 = self savegame::get_player_data(savegame::get_mission_name() + "hero_weapon", undefined);
		if(isdefined(prevclass) || b_disable_cac || (isdefined(level.disableclassselection) && level.disableclassselection) || (isdefined(self.disableclassselection) && self.disableclassselection) || getdvarint("migration_soak") == 1)
		{
			self.curclass = (isdefined(prevclass) ? prevclass : level.defaultclass);
			self.pers["class"] = self.curclass;
			wait(0.05);
			if(self.sessionstate != "playing" && game["state"] == "playing")
			{
				self thread [[level.spawnclient]]();
			}
			globallogic::updateteamstatus();
			self thread spectating::set_permissions_for_machine();
			return;
		}
	}
	self closemenu(game["menu_changeclass"]);
	self openmenu(game["menu_changeclass_" + team]);
}

/*
	Name: fullscreen_black
	Namespace: globallogic_ui
	Checksum: 0x4D37E32B
	Offset: 0x1AD0
	Size: 0x38C
	Parameters: 0
	Flags: Linked
*/
function fullscreen_black()
{
	self endon(#"disconnect");
	util::show_hud(0);
	self closemenu("InitialBlack");
	self openmenu("InitialBlack");
	b_hot_joining = 0;
	if(level flag::get("all_players_spawned"))
	{
		b_hot_joining = 1;
	}
	self.fullscreen_black_active = 1;
	self thread fullscreen_black_checkpoint_restore();
	self hide();
	wait(0.05);
	if(isdefined(level.str_level_start_flag) || isdefined(level.str_player_start_flag))
	{
		init_start_flags();
		self thread fullscreen_black_freeze_controls();
		if(isdefined(level.str_level_start_flag))
		{
			level flag::wait_till(level.str_level_start_flag);
		}
		if(isdefined(level.str_player_start_flag))
		{
			self flag::wait_till(level.str_player_start_flag);
		}
	}
	if(b_hot_joining && (!(isdefined(level.is_safehouse) && level.is_safehouse)))
	{
		while(self.sessionstate !== "playing")
		{
			wait(0.05);
		}
		self thread fullscreen_black_freeze_controls();
		while(self isloadingcinematicplaying())
		{
			wait(0.05);
		}
		self flag::wait_till("loadout_given");
		waittillframeend();
		wait(2);
		self util::streamer_wait(undefined, 5, 5);
		self thread lui::screen_fade_in(0.3, "black", "hot_join");
	}
	if(!flagsys::get("shared_igc"))
	{
		self show();
	}
	self flagsys::set("kill_fullscreen_black");
	self clientfield::set_to_player("sndLevelStartSnapOff", 1);
	self closemenu("InitialBlack");
	self.fullscreen_black_active = undefined;
	util::show_hud(1);
	/#
		printtoprightln((("" + gettime()) + "") + self getentitynumber(), (1, 1, 1));
		streamerskiptodebug(getskiptos());
	#/
}

/*
	Name: fullscreen_black_checkpoint_restore
	Namespace: globallogic_ui
	Checksum: 0x18BEC12F
	Offset: 0x1E68
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function fullscreen_black_checkpoint_restore()
{
	self endon(#"disconnect");
	self endon(#"kill_fullscreen_black");
	b_fullscreen_black = self.fullscreen_black_active;
	level waittill(#"save_restore");
	if(isdefined(b_fullscreen_black) && b_fullscreen_black)
	{
		self closemenu("InitialBlack");
		self openmenu("InitialBlack");
	}
}

/*
	Name: init_start_flags
	Namespace: globallogic_ui
	Checksum: 0x4705F18A
	Offset: 0x1F00
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function init_start_flags()
{
	if(isdefined(level.str_player_start_flag) && !self flag::exists(level.str_player_start_flag))
	{
		self flag::init(level.str_player_start_flag);
	}
	if(isdefined(level.str_level_start_flag) && !level flag::exists(level.str_level_start_flag))
	{
		level flag::init(level.str_level_start_flag);
	}
}

/*
	Name: fullscreen_black_freeze_controls
	Namespace: globallogic_ui
	Checksum: 0x45100F1C
	Offset: 0x1FA0
	Size: 0xFE
	Parameters: 0
	Flags: Linked
*/
function fullscreen_black_freeze_controls()
{
	self endon(#"disconnect");
	self.b_game_start_invulnerability = 1;
	self flagsys::wait_till("loadout_given");
	self disableweapons();
	self freezecontrols(1);
	wait(0.1);
	waittillframeend();
	self freezecontrols(1);
	self disableweapons();
	self flagsys::wait_till("kill_fullscreen_black");
	self enableweapons();
	self freezecontrols(0);
	self.b_game_start_invulnerability = undefined;
}

/*
	Name: showmainmenuforteam
	Namespace: globallogic_ui
	Checksum: 0x40F1396B
	Offset: 0x20A8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function showmainmenuforteam()
{
	/#
		assert(isdefined(level.teams[self.pers[""]]));
	#/
	team = self.pers["team"];
	self openmenu(game["menu_changeclass_" + team]);
}

/*
	Name: menuteam
	Namespace: globallogic_ui
	Checksum: 0x26219D3C
	Offset: 0x2128
	Size: 0x234
	Parameters: 1
	Flags: Linked
*/
function menuteam(team)
{
	self closemenus();
	if(!level.console && level.allow_teamchange == "0" && (isdefined(self.hasdonecombat) && self.hasdonecombat))
	{
		return;
	}
	if(self.pers["team"] != team)
	{
		if(level.ingraceperiod && (!isdefined(self.hasdonecombat) || !self.hasdonecombat))
		{
			self.hasspawned = 0;
		}
		if(self.sessionstate == "playing")
		{
			self.switching_teams = 1;
			self.switchedteamsresetgadgets = 1;
			self.joining_team = team;
			self.leaving_team = self.pers["team"];
			self suicide();
		}
		self.pers["team"] = team;
		self.team = team;
		self.pers["class"] = undefined;
		self.curclass = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;
		self updateobjectivetext();
		if(!level.rankedmatch && !level.leaguematch)
		{
			self.sessionstate = "spectator";
		}
		self.sessionteam = team;
		self setclientscriptmainmenu(game["menu_start_menu"]);
		self notify(#"joined_team");
		level notify(#"joined_team");
		callback::callback(#"hash_95a6c4c0");
		self notify(#"end_respawn");
	}
	self beginclasschoice();
}

/*
	Name: menuspectator
	Namespace: globallogic_ui
	Checksum: 0x804ED8A2
	Offset: 0x2368
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function menuspectator()
{
	self closemenus();
	if(self.pers["team"] != "spectator")
	{
		if(isalive(self))
		{
			self.switching_teams = 1;
			self.switchedteamsresetgadgets = 1;
			self.joining_team = "spectator";
			self.leaving_team = self.pers["team"];
			self suicide();
		}
		self.pers["team"] = "spectator";
		self.team = "spectator";
		self.pers["class"] = undefined;
		self.curclass = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;
		self updateobjectivetext();
		self.sessionteam = "spectator";
		[[level.spawnspectator]]();
		self thread globallogic_player::spectate_player_watcher();
		self setclientscriptmainmenu(game["menu_start_menu"]);
		self notify(#"joined_spectators");
		callback::callback(#"hash_4c5ae192");
	}
}

/*
	Name: menuclass
	Namespace: globallogic_ui
	Checksum: 0xA546881A
	Offset: 0x2518
	Size: 0x68A
	Parameters: 1
	Flags: Linked
*/
function menuclass(response)
{
	self closemenus();
	if(!isdefined(self.pers["team"]) || !isdefined(level.teams[self.pers["team"]]))
	{
		return;
	}
	if(flagsys::get("mobile_armory_in_use"))
	{
		return;
	}
	playerclass = "";
	if(response == "cancel")
	{
		prevclass = self savegame::get_player_data("playerClass", undefined);
		if(isdefined(prevclass))
		{
			playerclass = prevclass;
		}
		else
		{
			playerclass = level.defaultclass;
		}
	}
	else
	{
		responsearray = strtok(response, ",");
		if(responsearray.size > 1)
		{
			str_class_chosen = responsearray[0];
			clientnum = int(responsearray[1]);
			altplayer = util::getplayerfromclientnum(clientnum);
		}
		else
		{
			str_class_chosen = response;
		}
		playerclass = self loadout::getclasschoice(str_class_chosen);
		if(isdefined(altplayer))
		{
			xuid = altplayer getxuid();
			self savegame::set_player_data("altPlayerID", xuid);
		}
		else
		{
			self savegame::set_player_data("altPlayerID", undefined);
		}
		self savegame::set_player_data("saved_weapon", undefined);
		self savegame::set_player_data("saved_weapondata", undefined);
		self savegame::set_player_data("lives", undefined);
		self savegame::set_player_data("saved_rig1", undefined);
		self savegame::set_player_data("saved_rig1_upgraded", undefined);
		self savegame::set_player_data("saved_rig2", undefined);
		self savegame::set_player_data("saved_rig2_upgraded", undefined);
	}
	if(isdefined(self.pers["class"]) && self.pers["class"] == playerclass)
	{
		return;
	}
	self.pers["changed_class"] = 1;
	self notify(#"changed_class");
	waittillframeend();
	if(isdefined(self.curclass) && self.curclass == playerclass)
	{
		self.pers["changed_class"] = 0;
	}
	if(self.sessionstate == "playing")
	{
		self savegame::set_player_data("playerClass", playerclass);
		self.pers["class"] = playerclass;
		self.curclass = playerclass;
		self.pers["weapon"] = undefined;
		if(game["state"] == "postgame")
		{
			return;
		}
		supplystationclasschange = isdefined(self.usingsupplystation) && self.usingsupplystation;
		self.usingsupplystation = 0;
		if(level.ingraceperiod && !self.hasdonecombat || supplystationclasschange)
		{
			self loadout::setclass(self.pers["class"]);
			self.tag_stowed_back = undefined;
			self.tag_stowed_hip = undefined;
			self loadout::giveloadout(self.pers["team"], self.pers["class"]);
		}
		else if(!self issplitscreen())
		{
			self iprintlnbold(game["strings"]["change_class"]);
		}
	}
	else
	{
		self savegame::set_player_data("playerClass", playerclass);
		self.pers["class"] = playerclass;
		self.curclass = playerclass;
		self.pers["weapon"] = undefined;
		if(game["state"] == "postgame")
		{
			return;
		}
		if(self.sessionstate != "spectator")
		{
			if(self isinvehicle())
			{
				return;
			}
			if(self isremotecontrolling())
			{
				return;
			}
			if(self isweaponviewonlylinked())
			{
				return false;
			}
		}
		if(game["state"] == "playing")
		{
			timepassed = undefined;
			if(isdefined(self.respawntimerstarttime))
			{
				timepassed = (gettime() - self.respawntimerstarttime) / 1000;
			}
			self thread [[level.spawnclient]](timepassed);
			self.respawntimerstarttime = undefined;
		}
	}
	globallogic::updateteamstatus();
	self thread spectating::set_permissions_for_machine();
	self notify(#"class_changed");
}

/*
	Name: removespawnmessageshortly
	Namespace: globallogic_ui
	Checksum: 0xD160DE01
	Offset: 0x2BB0
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function removespawnmessageshortly(delay)
{
	self endon(#"disconnect");
	waittillframeend();
	self endon(#"end_respawn");
	wait(delay);
	self util::clearlowermessage(2);
}

/*
	Name: weakpoint_anim_watch
	Namespace: globallogic_ui
	Checksum: 0x39576679
	Offset: 0x2C00
	Size: 0x108
	Parameters: 1
	Flags: Linked
*/
function weakpoint_anim_watch(precachedbonename)
{
	self endon(#"death");
	self endon(#"weakpoint_destroyed");
	while(true)
	{
		self waittill(#"weakpoint_update", bonename, event);
		if(bonename == precachedbonename)
		{
			if(event == "damage")
			{
				luinotifyevent(&"weakpoint_update", 3, 2, self getentitynumber(), precachedbonename);
			}
			else if(event == "repulse")
			{
				luinotifyevent(&"weakpoint_update", 3, 3, self getentitynumber(), precachedbonename);
			}
			wait(0.5);
		}
	}
}

/*
	Name: destroyweakpointwidget
	Namespace: globallogic_ui
	Checksum: 0xC7A0998F
	Offset: 0x2D10
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function destroyweakpointwidget(precachedbonename)
{
	luinotifyevent(&"weakpoint_update", 3, 0, self getentitynumber(), precachedbonename);
	self notify(#"weakpoint_destroyed");
}

/*
	Name: createweakpointwidget
	Namespace: globallogic_ui
	Checksum: 0x148772B
	Offset: 0x2D68
	Size: 0xEC
	Parameters: 3
	Flags: Linked
*/
function createweakpointwidget(precachedbonename, closestatemaxdistance = getdvarint("ui_weakpointIndicatorNear", 1050), mediumstatemaxdistance = getdvarint("ui_weakpointIndicatorMedium", 1900))
{
	luinotifyevent(&"weakpoint_update", 5, 1, self getentitynumber(), precachedbonename, closestatemaxdistance, mediumstatemaxdistance);
	self thread weakpoint_anim_watch(precachedbonename);
}

/*
	Name: triggerweakpointdamage
	Namespace: globallogic_ui
	Checksum: 0xEC2A034D
	Offset: 0x2E60
	Size: 0x26
	Parameters: 1
	Flags: Linked
*/
function triggerweakpointdamage(precachedbonename)
{
	self notify(#"weakpoint_update", precachedbonename, "damage");
}

/*
	Name: triggerweakpointrepulsed
	Namespace: globallogic_ui
	Checksum: 0xA0E41BC5
	Offset: 0x2E90
	Size: 0x26
	Parameters: 1
	Flags: None
*/
function triggerweakpointrepulsed(precachedbonename)
{
	self notify(#"weakpoint_update", precachedbonename, "repulse");
}

