// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_achievements;
#using scripts\cp\_bb;
#using scripts\cp\_callbacks;
#using scripts\cp\_laststand;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_globallogic_spawn;
#using scripts\cp\gametypes\_globallogic_ui;
#using scripts\cp\gametypes\_globallogic_utils;
#using scripts\cp\gametypes\_killcam;
#using scripts\cp\gametypes\_save;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\music_shared;
#using scripts\shared\player_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace coop;

/*
	Name: init
	Namespace: coop
	Checksum: 0x1019FAED
	Offset: 0x8A0
	Size: 0x64
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	clientfield::register("playercorpse", "hide_body", 1, 1, "int");
	clientfield::register("toplayer", "killcam_menu", 1, 1, "int");
}

/*
	Name: main
	Namespace: coop
	Checksum: 0x58B61659
	Offset: 0x910
	Size: 0x374
	Parameters: 0
	Flags: None
*/
function main()
{
	globallogic::init();
	level.gametype = tolower(getdvarstring("g_gametype"));
	util::registerroundswitch(0, 9);
	util::registertimelimit(0, 0);
	util::registerscorelimit(0, 0);
	util::registerroundlimit(0, 10);
	util::registerroundwinlimit(0, 0);
	util::registernumlives(0, 100);
	globallogic::registerfriendlyfiredelay(level.gametype, 15, 0, 1440);
	spawner::add_global_spawn_function("axis", &function_54ba8dfa);
	level.scoreroundwinbased = getgametypesetting("cumulativeRoundScores") == 0;
	level.teamscoreperkill = getgametypesetting("teamScorePerKill");
	level.teamscoreperdeath = getgametypesetting("teamScorePerDeath");
	level.teamscoreperheadshot = getgametypesetting("teamScorePerHeadshot");
	level.teambased = 1;
	level.overrideteamscore = 1;
	level.onstartgametype = &onstartgametype;
	level.onspawnplayer = &onspawnplayer;
	level.onspawnplayerunified = undefined;
	level.onplayerkilled = &onplayerkilled;
	level.gametypespawnwaiter = &wait_to_spawn;
	level.var_bdd4d5c2 = &spawnedasspectator;
	level thread function_a67d9d08();
	level.disableprematchmessages = 1;
	level.endgameonscorelimit = 0;
	level.endgameontimelimit = 0;
	level.ontimelimit = &globallogic::blank;
	level.onscorelimit = &globallogic::blank;
	gameobjects::register_allowed_gameobject(level.gametype);
	game["dialog"]["gametype"] = "coop_start";
	game["dialog"]["gametype_hardcore"] = "hccoop_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	setscoreboardcolumns("score", "kills", "assists", "incaps", "revives");
}

/*
	Name: function_54ba8dfa
	Namespace: coop
	Checksum: 0x67F88810
	Offset: 0xC90
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_54ba8dfa()
{
	level spawning::create_enemy_influencer("enemy_spawn", self.origin, "allies");
	self spawning::create_entity_enemy_influencer("enemy", "allies");
}

/*
	Name: function_79eba3d6
	Namespace: coop
	Checksum: 0x8F80E6A3
	Offset: 0xCF8
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_79eba3d6(time)
{
	self endon(#"death_or_disconnect");
	wait(time);
	self disableinvulnerability();
}

/*
	Name: function_642c1545
	Namespace: coop
	Checksum: 0xC268D551
	Offset: 0xD38
	Size: 0x204
	Parameters: 0
	Flags: Linked
*/
function function_642c1545()
{
	self matchrecordplayerspawned();
	if(skipto::function_52c50cb8() != -1)
	{
		self matchrecordsetcheckpointstat(skipto::function_52c50cb8(), "checkpoint_restores", 1);
	}
	primaryweapon = (isdefined(self.primaryweapon) ? self.primaryweapon : level.weaponnone);
	secondaryweapon = (isdefined(self.secondaryweapon) ? self.secondaryweapon : level.weaponnone);
	grenadetypeprimary = (isdefined(self.grenadetypeprimary) ? self.grenadetypeprimary : level.weaponnone);
	grenadetypesecondary = (isdefined(self.grenadetypesecondary) ? self.grenadetypesecondary : level.weaponnone);
	self.killstreak = [];
	for(i = 0; i < 3; i++)
	{
		if(level.loadoutkillstreaksenabled && isdefined(self.killstreak[i]) && isdefined(level.killstreakindices[self.killstreak[i]]))
		{
			killstreaks[i] = level.killstreakindices[self.killstreak[i]];
			continue;
		}
		killstreaks[i] = 0;
	}
	self recordloadoutperksandkillstreaks(primaryweapon, secondaryweapon, grenadetypeprimary, grenadetypesecondary, killstreaks[0], killstreaks[1], killstreaks[2]);
}

/*
	Name: function_a67d9d08
	Namespace: coop
	Checksum: 0xC2B65F4D
	Offset: 0xF48
	Size: 0x2B6
	Parameters: 0
	Flags: Linked
*/
function function_a67d9d08()
{
	while(true)
	{
		level waittill(#"save_restore");
		music::setmusicstate("death");
		util::cleanupactorcorpses();
		level thread lui::screen_fade(1.25, 0, 1, "black", 1);
		matchrecorderincrementheaderstat("checkpointRestoreCount", 1);
		foreach(player in level.players)
		{
			player closemenu(game["menu_start_menu"]);
			if(player flagsys::get("mobile_armory_in_use"))
			{
				player notify(#"menuresponse", "ChooseClass_InGame", "cancel");
			}
			player closemenu(game["menu_changeclass"]);
			player closemenu(game["menu_changeclass_offline"]);
			if(player.sessionstate == "spectator")
			{
				if(!isdefined(player.curclass))
				{
					player thread globallogic_ui::beginclasschoice();
				}
				else
				{
					player thread globallogic_spawn::waitandspawnclient();
				}
			}
			else if(player laststand::player_is_in_laststand())
			{
				player notify(#"auto_revive");
			}
			var_a7283d73 = player enableinvulnerability();
			if(!var_a7283d73)
			{
				player thread function_79eba3d6(3);
			}
			if(!(isdefined(world.var_bf966ebd) && world.var_bf966ebd))
			{
				world.var_bf966ebd = 1;
			}
			player function_642c1545();
		}
	}
}

/*
	Name: onstartgametype
	Namespace: coop
	Checksum: 0x2458E6C8
	Offset: 0x1208
	Size: 0x3B2
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
	foreach(team in level.playerteams)
	{
		util::setobjectivetext(team, &"OBJECTIVES_COOP");
		util::setobjectivehinttext(team, &"OBJECTIVES_COOP_HINT");
		util::setobjectivescoretext(team, &"OBJECTIVES_COOP");
	}
	level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
	setmapcenter(level.mapcenter);
	spawnpoint = spawnlogic::get_random_intermission_point();
	setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
	level thread respawn_spectators_on_objective_change();
	spawnlogic::add_spawn_points("allies", "cp_coop_spawn");
	spawning::updateallspawnpoints();
	level flag::wait_till("first_player_spawned");
	if(!level flagsys::get("level_has_skiptos"))
	{
		spawnlogic::clear_spawn_points();
		spawnlogic::add_spawn_points("allies", "cp_coop_spawn");
		spawnlogic::add_spawn_points("allies", "cp_coop_respawn");
		spawning::updateallspawnpoints();
	}
	foreach(player in level.players)
	{
		bb::logobjectivestatuschange("_level", player, "start");
	}
}

/*
	Name: onspawnplayer
	Namespace: coop
	Checksum: 0x536B7693
	Offset: 0x15C8
	Size: 0x184
	Parameters: 2
	Flags: Linked
*/
function onspawnplayer(predictedspawn = 0, question)
{
	pixbeginevent("COOP:onSpawnPlayer");
	self.usingobj = undefined;
	if(isdefined(question))
	{
		question = 1;
	}
	if(isdefined(question))
	{
		question = -1;
	}
	spawnpoint = spawning::getspawnpoint(self, predictedspawn);
	if(predictedspawn)
	{
		self predictspawnpoint(spawnpoint["origin"], spawnpoint["angles"]);
		self.predicted_spawn_point = spawnpoint;
	}
	else
	{
		if(isdefined(self.var_10aaa336))
		{
			spawnpoint["origin"] = self.var_10aaa336;
			self.var_10aaa336 = undefined;
		}
		if(isdefined(self.var_7e4a3c90))
		{
			spawnpoint["angles"] = self.var_7e4a3c90;
			self.var_7e4a3c90 = undefined;
		}
		self spawn(spawnpoint["origin"], spawnpoint["angles"], "coop");
	}
	self thread function_51525e38();
	pixendevent();
}

/*
	Name: onscoreclosemusic
	Namespace: coop
	Checksum: 0x7ACA4115
	Offset: 0x1758
	Size: 0x1BC
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
		if(scoredif <= scorethreshold && scorethresholdstart <= topscore)
		{
			return;
		}
		wait(1);
	}
}

/*
	Name: onplayerkilled
	Namespace: coop
	Checksum: 0xA513346D
	Offset: 0x1920
	Size: 0x454
	Parameters: 9
	Flags: Linked
*/
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	self closemenu(game["menu_changeclass"]);
	attacker globallogic_score::giveteamscoreforobjective(attacker.team, level.teamscoreperkill);
	self globallogic_score::giveteamscoreforobjective(self.team, level.teamscoreperdeath * -1);
	if(smeansofdeath == "MOD_HEAD_SHOT")
	{
		attacker globallogic_score::giveteamscoreforobjective(attacker.team, level.teamscoreperheadshot);
	}
	if(!sessionmodeiscampaignzombiesgame() && (!(isdefined(level.is_safehouse) && level.is_safehouse)))
	{
		/#
			assert(isdefined(level.laststandpistol));
		#/
		self takeweapon(level.laststandpistol);
		primaries = self getweaponslistprimaries();
		if(isdefined(primaries))
		{
			foreach(primary_weapon in primaries)
			{
				if(primary_weapon !== self.secondaryloadoutweapon)
				{
					self._current_weapon = primary_weapon;
					break;
				}
			}
		}
		self player::take_weapons();
		self savegame::set_player_data("saved_weapon", self._current_weapon.name);
		self savegame::set_player_data("saved_weapondata", self._weapons);
		self._weapons = undefined;
		self.gun_removed = undefined;
	}
	if(!(isdefined(level.is_safehouse) && level.is_safehouse))
	{
		if(isdefined(level.var_ad1a71f5))
		{
			return;
		}
		level.dead_player = self;
		if(self.lives === 0 && self hascybercomrig("cybercom_emergencyreserve") != 0)
		{
			self.lives = 1;
			self setnoncheckpointdata("lives", self.lives);
		}
		if(level.players.size == 1)
		{
			self playsoundtoplayer("evt_death_down", self);
			if(isdefined(level.var_d59daf8) && level.var_d59daf8)
			{
				self.var_e8880dea = 1;
				if(isdefined(level.var_3a9f9a38) && level.var_3a9f9a38 && (isdefined(self.var_ebd83169) && self.var_ebd83169))
				{
					self thread function_c14603ce();
				}
				self util::waittill_any_timeout(5, "cp_deathcam_ended");
			}
			level thread function_5ed5738a(undefined, undefined);
		}
		else if(level.gameskill >= 2)
		{
			playsoundatposition("evt_death_down", (0, 0, 0));
			level thread function_5ed5738a(&"GAME_YOU_DIED");
		}
	}
}

/*
	Name: function_5ed5738a
	Namespace: coop
	Checksum: 0x7719132D
	Offset: 0x1D80
	Size: 0x59C
	Parameters: 2
	Flags: Linked
*/
function function_5ed5738a(var_b90e5c2c, var_c878636f)
{
	level.var_ad1a71f5 = 1;
	foreach(player in level.players)
	{
		player util::show_hud(0);
		bb::logobjectivestatuschange(level.skipto_point, player, "restart");
		player util::freeze_player_controls(1);
		player.var_c8430b0a = 1;
		if(isdefined(var_b90e5c2c))
		{
			var_e13f49eb = 1;
			player.var_c8656312 = player openluimenu("CPMissionFailed");
			if(var_b90e5c2c == (&"GAME_YOU_DIED"))
			{
				if(player == level.dead_player)
				{
					player thread displayplayerdead();
				}
				else
				{
					player thread displayteammatedead(level.dead_player);
				}
				player setluimenudata(player.var_c8656312, "MissionFailReason", "");
			}
			else
			{
				player setluimenudata(player.var_c8656312, "MissionFailReason", var_b90e5c2c);
			}
			if(!isdefined(var_c878636f))
			{
				var_c878636f = "";
			}
			player setluimenudata(player.var_c8656312, "MissionFailHint", var_c878636f);
		}
	}
	if(isdefined(var_e13f49eb))
	{
		wait(3.8);
	}
	var_d5b5f12 = 1.25;
	if(isdefined(level.dead_player))
	{
		if(isdefined(level.var_3a9f9a38) && level.var_3a9f9a38)
		{
			foreach(player in level.players)
			{
				if(isdefined(player.var_acfedf1c) && player.var_acfedf1c)
				{
					level.dead_player util::waittill_any("end_killcam", "fade_out_killcam");
					if(isdefined(level.dead_player.var_1c362abb))
					{
						var_d5b5f12 = level.dead_player.var_1c362abb;
					}
				}
			}
		}
		level thread lui::screen_fade(var_d5b5f12, 1, 0, "black", 0);
		wait(var_d5b5f12);
		screen_faded = 1;
		if(isdefined(level.var_3a9f9a38) && level.var_3a9f9a38)
		{
			foreach(player in level.players)
			{
				if(isdefined(player.var_acfedf1c) && player.var_acfedf1c)
				{
					player clientfield::set_to_player("killcam_menu", 0);
				}
			}
		}
	}
	if(!isdefined(screen_faded))
	{
		level thread lui::screen_fade(var_d5b5f12, 1, 0, "black", 0);
		wait(var_d5b5f12);
	}
	if(isdefined(level.gameended) && level.gameended)
	{
		wait(1000);
	}
	foreach(player in level.players)
	{
		player notify(#"hash_1528244e");
		player cameraactivate(0);
		player util::freeze_player_controls(0);
	}
	checkpointrestore();
	wait(0.5);
	map_restart();
}

/*
	Name: displayplayerdead
	Namespace: coop
	Checksum: 0xCB4A30DD
	Offset: 0x2328
	Size: 0x130
	Parameters: 0
	Flags: Linked
*/
function displayplayerdead()
{
	wait(1.2);
	self.player_dead = newclienthudelem(self);
	self.player_dead.alignx = "center";
	self.player_dead.aligny = "middle";
	self.player_dead.horzalign = "center";
	self.player_dead.vertalign = "middle";
	self.player_dead.foreground = 1;
	self.player_dead.fontscale = 2;
	self.player_dead.alpha = 0;
	self.player_dead.color = (1, 1, 1);
	self.player_dead settext(&"GAME_YOU_DIED");
	self.player_dead fadeovertime(1);
	self.player_dead.alpha = 1;
}

/*
	Name: displayteammatedead
	Namespace: coop
	Checksum: 0xA259A4E0
	Offset: 0x2460
	Size: 0x140
	Parameters: 1
	Flags: Linked
*/
function displayteammatedead(dead_teammate)
{
	wait(1);
	self.teammate_dead = newclienthudelem(self);
	self.teammate_dead.alignx = "center";
	self.teammate_dead.aligny = "middle";
	self.teammate_dead.horzalign = "center";
	self.teammate_dead.vertalign = "middle";
	self.teammate_dead.foreground = 1;
	self.teammate_dead.fontscale = 2;
	self.teammate_dead.alpha = 0;
	self.teammate_dead.color = (1, 1, 1);
	self.teammate_dead settext(&"GAME_TEAMMATE_DIED", dead_teammate);
	self.teammate_dead fadeovertime(1);
	self.teammate_dead.alpha = 1;
}

/*
	Name: function_c14603ce
	Namespace: coop
	Checksum: 0x1649B21E
	Offset: 0x25A8
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function function_c14603ce()
{
	self endon(#"disconnect");
	self endon(#"hash_1528244e");
	level endon(#"game_ended");
	self clientfield::set_to_player("killcam_menu", 1);
	/#
		printtoprightln("", (1, 0, 1));
	#/
	while(self usebuttonpressed())
	{
		wait(0.05);
	}
	while(!self usebuttonpressed())
	{
		wait(0.05);
	}
	self.var_acfedf1c = 1;
	self clientfield::set_to_player("killcam_menu", 0);
	self notify(#"hash_261f3a82");
}

/*
	Name: function_e82a1210
	Namespace: coop
	Checksum: 0x578E4791
	Offset: 0x26A0
	Size: 0x188
	Parameters: 0
	Flags: Linked
*/
function function_e82a1210()
{
	if(!isdefined(self.var_ee8c475a))
	{
		self.var_ee8c475a = newclienthudelem(self);
		self.var_ee8c475a.archived = 0;
		self.var_ee8c475a.x = 0;
		self.var_ee8c475a.alignx = "center";
		self.var_ee8c475a.aligny = "middle";
		self.var_ee8c475a.horzalign = "center";
		self.var_ee8c475a.vertalign = "bottom";
		self.var_ee8c475a.sort = 1;
		self.var_ee8c475a.font = "objective";
	}
	if(self issplitscreen())
	{
		self.var_ee8c475a.y = -100;
		self.var_ee8c475a.fontscale = 1;
	}
	else
	{
		self.var_ee8c475a.y = -180;
		self.var_ee8c475a.fontscale = 1.5;
	}
	self.var_ee8c475a settext(&"MENU_CP_KILLCAM_PROMPT");
	self.var_ee8c475a.alpha = 1;
}

/*
	Name: function_44e35f1a
	Namespace: coop
	Checksum: 0x2C0E4C8A
	Offset: 0x2830
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function function_44e35f1a()
{
	self endon(#"disconnect");
	self endon(#"hash_1528244e");
	self endon(#"end_respawn");
	level endon(#"game_ended");
	self function_e82a1210();
	/#
		printtoprightln("", (1, 0, 1));
	#/
	while(self usebuttonpressed())
	{
		wait(0.05);
	}
	while(!self usebuttonpressed())
	{
		wait(0.05);
	}
	self.var_acfedf1c = 1;
	self.var_ee8c475a.alpha = 0;
	if(isdefined(level.var_3a9f9a38) && level.var_3a9f9a38)
	{
		killcamentitystarttime = 0;
		perks = [];
		killstreaks = [];
		self killcam::killcam(self getentitynumber(), self getentitynumber(), self.var_ca78829f, self.var_1b7a74aa, killcamentitystarttime, self.killcamweapon, self.deathtime, self.var_8c0347ee, self.var_2b1ad8b, 1, undefined, perks, killstreaks, self);
	}
}

/*
	Name: onplayerbleedout
	Namespace: coop
	Checksum: 0xADC7C4BE
	Offset: 0x29D0
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function onplayerbleedout()
{
	if(!(isdefined(level.var_ee7cb602) && level.var_ee7cb602))
	{
		foreach(player in level.players)
		{
			if(player != self && player.sessionstate != "dead" && player.sessionstate != "spectator" && (!(isdefined(player.laststand) && player.laststand)))
			{
				return;
			}
		}
	}
	if(!(isdefined(level.level_ending) && level.level_ending))
	{
		if(isdefined(self) && self.lives === 0 && self hascybercomrig("cybercom_emergencyreserve") != 0)
		{
			self.lives = 1;
			self setnoncheckpointdata("lives", self.lives);
		}
		level thread function_5ed5738a();
	}
	level.level_ending = 1;
	/#
		if(!(isdefined(level.level_ending) && level.level_ending))
		{
			errormsg("");
		}
	#/
}

/*
	Name: wait_to_spawn
	Namespace: coop
	Checksum: 0x2E80BC7C
	Offset: 0x2BB0
	Size: 0x120
	Parameters: 0
	Flags: Linked
*/
function wait_to_spawn()
{
	self notify(#"hash_e5088dc8");
	self endon(#"hash_e5088dc8");
	if(isdefined(level.is_safehouse) && level.is_safehouse || (isdefined(level.inprematchperiod) && level.inprematchperiod) || !isdefined(self.var_a90a3829))
	{
		self.var_a90a3829 = 1;
		return true;
	}
	if(self issplitscreen())
	{
		util::setlowermessage(game["strings"]["waiting_to_spawn_ss"], 15, 1);
	}
	else
	{
		util::setlowermessage(game["strings"]["waiting_to_spawn"], 15);
	}
	level util::waittill_any_timeout(15, "objective_changed");
	return true;
}

/*
	Name: respawn_spectators_on_objective_change
	Namespace: coop
	Checksum: 0xB4AF9A96
	Offset: 0x2CD8
	Size: 0xFE
	Parameters: 0
	Flags: Linked
*/
function respawn_spectators_on_objective_change()
{
	level flag::wait_till("all_players_spawned");
	while(true)
	{
		level waittill(#"objective_changed");
		foreach(player in level.players)
		{
			if(player.sessionstate == "spectator" && globallogic_utils::isvalidclass(player.curclass))
			{
				player globallogic_spawn::waitandspawnclient();
			}
		}
	}
}

/*
	Name: spawnedasspectator
	Namespace: coop
	Checksum: 0x824977DE
	Offset: 0x2DE0
	Size: 0x18
	Parameters: 0
	Flags: Linked
*/
function spawnedasspectator()
{
	if(!isdefined(self.var_a90a3829))
	{
		return true;
	}
	return false;
}

/*
	Name: function_e9f7384d
	Namespace: coop
	Checksum: 0xC7BFB4C9
	Offset: 0x2E00
	Size: 0x2B6
	Parameters: 0
	Flags: None
*/
function function_e9f7384d()
{
	self endon(#"death");
	self endon(#"disconnect");
	if(isdefined(self.currentweapon.isheroweapon) && self.currentweapon.isheroweapon)
	{
		return;
	}
	a_weaponlist = self getweaponslist();
	a_heroweapons = [];
	foreach(weapon in a_weaponlist)
	{
		if(isdefined(weapon.isheroweapon) && weapon.isheroweapon)
		{
			if(!isdefined(a_heroweapons))
			{
				a_heroweapons = [];
			}
			else if(!isarray(a_heroweapons))
			{
				a_heroweapons = array(a_heroweapons);
			}
			a_heroweapons[a_heroweapons.size] = weapon;
		}
	}
	w_hero = a_heroweapons[0];
	if(isdefined(w_hero))
	{
		if((self getweaponammoclip(w_hero) + self getweaponammostock(w_hero)) > 0)
		{
			if(isdefined(self.var_928b1776))
			{
				if((gettime() - self.var_928b1776) > 90000)
				{
					switch(w_hero.rootweapon.name)
					{
						case "launcher_standard":
						{
							if(self.var_9b416318 < 5)
							{
								self util::show_hint_text(&"COOP_EQUIP_XM53");
							}
							break;
						}
						case "spike_launcher":
						{
							if(self.var_9b416318 < 10)
							{
								self util::show_hint_text(&"COOP_EQUIP_SPIKE_LAUNCHER");
							}
							break;
						}
						case "micromissile_launcher":
						{
							if(self.var_9b416318 < 10)
							{
								self util::show_hint_text(&"COOP_EQUIP_MICROMISSILE");
							}
							break;
						}
					}
				}
			}
		}
	}
}

/*
	Name: function_51525e38
	Namespace: coop
	Checksum: 0x8DA56E8A
	Offset: 0x30C0
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function function_51525e38()
{
	self notify(#"hash_dc0f8e82");
	self endon(#"death");
	self endon(#"hash_dc0f8e82");
	var_a151e229 = 0;
	while(true)
	{
		self waittill(#"weapon_change", e_weapon);
		if(isdefined(e_weapon))
		{
			if(isdefined(e_weapon.isheroweapon) && e_weapon.isheroweapon)
			{
				if(!isdefined(self.var_9b416318))
				{
					self.var_9b416318 = 0;
				}
				self thread function_e9b4a63b();
				var_a151e229 = 1;
			}
			else
			{
				if(var_a151e229)
				{
					self.var_928b1776 = gettime();
				}
				self notify(#"hash_79135cb3");
				var_a151e229 = 0;
			}
		}
	}
}

/*
	Name: function_e9b4a63b
	Namespace: coop
	Checksum: 0x91BFA7B
	Offset: 0x31C0
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function function_e9b4a63b()
{
	self endon(#"death");
	self endon(#"hash_79135cb3");
	while(true)
	{
		self waittill(#"weapon_fired", e_weapon);
		if(isdefined(e_weapon.isheroweapon) && e_weapon.isheroweapon)
		{
			self.var_9b416318++;
		}
	}
}

