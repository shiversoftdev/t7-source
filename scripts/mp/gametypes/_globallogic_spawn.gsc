// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_teamops;
#using scripts\mp\_util;
#using scripts\mp\_vehicle;
#using scripts\mp\bots\_bot;
#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_player;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_ui;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\gametypes\_spectating;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\util_shared;

#namespace globallogic_spawn;

/*
	Name: timeuntilspawn
	Namespace: globallogic_spawn
	Checksum: 0x4BE705E5
	Offset: 0x760
	Size: 0x1C2
	Parameters: 1
	Flags: Linked
*/
function timeuntilspawn(includeteamkilldelay)
{
	if(level.ingraceperiod && !self.hasspawned)
	{
		return 0;
	}
	respawndelay = 0;
	if(self.hasspawned)
	{
		result = self [[level.onrespawndelay]]();
		if(isdefined(result))
		{
			respawndelay = result;
		}
		else
		{
			respawndelay = level.playerrespawndelay;
		}
		if(isdefined(level.playerincrementalrespawndelay) && isdefined(self.pers["spawns"]))
		{
			respawndelay = respawndelay + (level.playerincrementalrespawndelay * self.pers["spawns"]);
		}
		if(self.suicide && level.suicidespawndelay > 0)
		{
			respawndelay = respawndelay + level.suicidespawndelay;
		}
		if(self.teamkilled && level.teamkilledspawndelay > 0)
		{
			respawndelay = respawndelay + level.teamkilledspawndelay;
		}
		if(includeteamkilldelay && (isdefined(self.teamkillpunish) && self.teamkillpunish))
		{
			respawndelay = respawndelay + globallogic_player::teamkilldelay();
		}
	}
	wavebased = level.waverespawndelay > 0;
	if(wavebased)
	{
		return self timeuntilwavespawn(respawndelay);
	}
	if(isdefined(self.usedresurrect) && self.usedresurrect)
	{
		return 0;
	}
	return respawndelay;
}

/*
	Name: allteamshaveexisted
	Namespace: globallogic_spawn
	Checksum: 0x133ED8D
	Offset: 0x930
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function allteamshaveexisted()
{
	foreach(team in level.teams)
	{
		if(!level.everexisted[team])
		{
			return false;
		}
	}
	return true;
}

/*
	Name: mayspawn
	Namespace: globallogic_spawn
	Checksum: 0xD1637EA9
	Offset: 0x9C8
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function mayspawn()
{
	if(isdefined(level.mayspawn) && !self [[level.mayspawn]]())
	{
		return 0;
	}
	if(isdefined(level.var_4fb47492))
	{
		return self [[level.var_4fb47492]]();
	}
	if(level.inovertime)
	{
		return 0;
	}
	if(level.playerqueuedrespawn && !isdefined(self.allowqueuespawn) && !level.ingraceperiod && !level.usestartspawns)
	{
		return 0;
	}
	if(level.numlives || level.numteamlives)
	{
		if(level.teambased)
		{
			gamehasstarted = allteamshaveexisted();
		}
		else
		{
			gamehasstarted = level.maxplayercount > 1 || (!util::isoneround() && !util::isfirstround());
		}
		if(level.numlives && !self.pers["lives"] || (level.numteamlives && !game[self.team + "_lives"]))
		{
			return 0;
		}
		if(gamehasstarted)
		{
			if(!level.ingraceperiod && !self.hasspawned && !level.wagermatch)
			{
				return 0;
			}
		}
	}
	return 1;
}

/*
	Name: timeuntilwavespawn
	Namespace: globallogic_spawn
	Checksum: 0x3FC3C25B
	Offset: 0xB70
	Size: 0x122
	Parameters: 1
	Flags: Linked
*/
function timeuntilwavespawn(minimumwait)
{
	earliestspawntime = gettime() + (minimumwait * 1000);
	lastwavetime = level.lastwave[self.pers["team"]];
	wavedelay = level.wavedelay[self.pers["team"]] * 1000;
	if(wavedelay == 0)
	{
		return 0;
	}
	numwavespassedearliestspawntime = (earliestspawntime - lastwavetime) / wavedelay;
	numwaves = ceil(numwavespassedearliestspawntime);
	timeofspawn = lastwavetime + (numwaves * wavedelay);
	if(isdefined(self.wavespawnindex))
	{
		timeofspawn = timeofspawn + (50 * self.wavespawnindex);
	}
	return (timeofspawn - gettime()) / 1000;
}

/*
	Name: stoppoisoningandflareonspawn
	Namespace: globallogic_spawn
	Checksum: 0x8602131F
	Offset: 0xCA0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function stoppoisoningandflareonspawn()
{
	self endon(#"disconnect");
	self.inpoisonarea = 0;
	self.inburnarea = 0;
	self.inflarevisionarea = 0;
	self.ingroundnapalm = 0;
}

/*
	Name: spawnplayerprediction
	Namespace: globallogic_spawn
	Checksum: 0x5C62ABE8
	Offset: 0xCE8
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function spawnplayerprediction()
{
	self endon(#"disconnect");
	self endon(#"end_respawn");
	self endon(#"game_ended");
	self endon(#"joined_spectators");
	self endon(#"spawned");
	livesleft = !(level.numlives && !self.pers["lives"]) && (!(level.numteamlives && !game[self.team + "_lives"]));
	if(!livesleft)
	{
		return;
	}
	while(true)
	{
		wait(0.5);
		spawning::onspawnplayer(1);
	}
}

/*
	Name: doinitialspawnmessaging
	Namespace: globallogic_spawn
	Checksum: 0x5BE20E89
	Offset: 0xDB8
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function doinitialspawnmessaging()
{
	self endon(#"disconnect");
	self.playleaderdialog = 1;
	if(isdefined(level.disableprematchmessages) && level.disableprematchmessages)
	{
		return;
	}
	team = self.pers["team"];
	thread hud_message::showinitialfactionpopup(team);
	while(level.inprematchperiod)
	{
		wait(0.05);
	}
	hintmessage = util::getobjectivehinttext(team);
	if(isdefined(hintmessage))
	{
		self luinotifyevent(&"show_gametype_objective_hint", 1, hintmessage);
	}
	if(isdefined(level.leaderdialog))
	{
		if(self.pers["playedGameMode"] !== 1)
		{
			if(level.hardcoremode)
			{
				self globallogic_audio::leader_dialog_on_player(level.leaderdialog.starthcgamedialog);
			}
			else
			{
				self globallogic_audio::leader_dialog_on_player(level.leaderdialog.startgamedialog);
			}
		}
		if(team == game["attackers"])
		{
			self globallogic_audio::leader_dialog_on_player(level.leaderdialog.offenseorderdialog);
		}
		else
		{
			self globallogic_audio::leader_dialog_on_player(level.leaderdialog.defenseorderdialog);
		}
	}
}

/*
	Name: spawnplayer
	Namespace: globallogic_spawn
	Checksum: 0x4A7C6038
	Offset: 0xF78
	Size: 0xE4C
	Parameters: 0
	Flags: Linked
*/
function spawnplayer()
{
	pixbeginevent("spawnPlayer_preUTS");
	self endon(#"disconnect");
	self endon(#"joined_spectators");
	self notify(#"spawned");
	level notify(#"player_spawned");
	self notify(#"end_respawn");
	self notify(#"started_spawnplayer");
	self setspawnvariables();
	self luinotifyevent(&"player_spawned", 0);
	self luinotifyeventtospectators(&"player_spawned", 0);
	if(!isdefined(self.pers["resetMomentumOnSpawn"]) || self.pers["resetMomentumOnSpawn"])
	{
		self globallogic_score::resetplayermomentumonspawn();
		self.pers["resetMomentumOnSpawn"] = 0;
	}
	if(globallogic_utils::getroundstartdelay())
	{
		self thread globallogic_utils::applyroundstartdelay();
	}
	self.sessionteam = self.team;
	hadspawned = self.hasspawned;
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.spectatekillcam = 0;
	self.statusicon = "";
	self.damagedplayers = [];
	if(getdvarint("scr_csmode") > 0)
	{
		self.maxhealth = getdvarint("scr_csmode");
	}
	else
	{
		self.maxhealth = level.playermaxhealth;
	}
	self.health = self.maxhealth;
	self.friendlydamage = undefined;
	self.laststunnedby = undefined;
	self.hasspawned = 1;
	self.spawntime = gettime();
	self.afk = 0;
	if(self.pers["lives"] && (!isdefined(level.takelivesondeath) || level.takelivesondeath == 0))
	{
		self.pers["lives"]--;
		if(self.pers["lives"] == 0)
		{
			level notify(#"player_eliminated");
			self notify(#"player_eliminated");
		}
	}
	if(game[self.team + "_lives"] && (!isdefined(level.takelivesondeath) || level.takelivesondeath == 0))
	{
		game[self.team + "_lives"]--;
		if((game[self.team + "_lives"]) == 0)
		{
			level notify(#"player_eliminated");
			self notify(#"player_eliminated");
		}
	}
	self.laststand = undefined;
	self.resurrect_not_allowed_by = undefined;
	self.revivingteammate = 0;
	self.burning = undefined;
	self.nextkillstreakfree = undefined;
	self.deathmachinekills = 0;
	self.disabledweapon = 0;
	self util::resetusability();
	self globallogic_player::resetattackerlist();
	self globallogic_player::resetattackersthisspawnlist();
	self.diedonvehicle = undefined;
	self.lastshotby = 127;
	if(!self.wasaliveatmatchstart)
	{
		if(level.ingraceperiod || globallogic_utils::gettimepassed() < 20000)
		{
			self.wasaliveatmatchstart = 1;
		}
	}
	self setdepthoffield(0, 0, 512, 512, 4, 0);
	self resetfov();
	pixbeginevent("onSpawnPlayer");
	self [[level.onspawnplayer]](0);
	if(isdefined(game["teamops"].teamopsname))
	{
		teamops = game["teamops"].data[game["teamops"].teamopsname];
		teamopsstart(game["teamops"].teamopsid, game["teamops"].teamopsrewardindex, game["teamops"].teamopsstarttime, teamops.time);
		teamops::updateteamops(undefined, undefined, self.team);
	}
	if(isdefined(level.playerspawnedcb))
	{
		self [[level.playerspawnedcb]]();
	}
	pixendevent();
	pixendevent();
	level thread globallogic::updateteamstatus();
	pixbeginevent("spawnPlayer_postUTS");
	self thread stoppoisoningandflareonspawn();
	self.sensorgrenadedata = undefined;
	/#
		assert(globallogic_utils::isvalidclass(self.curclass));
	#/
	self.pers["momentum_at_spawn_or_game_end"] = (isdefined(self.pers["momentum"]) ? self.pers["momentum"] : 0);
	if(sessionmodeiszombiesgame())
	{
		self loadout::giveloadoutlevelspecific(self.team, self.curclass);
	}
	else
	{
		self loadout::setclass(self.curclass);
		self loadout::giveloadout(self.team, self.curclass);
		if(getdvarint("tu11_enableClassicMode") == 1)
		{
			if(self.team == "allies")
			{
				self setcharacterbodytype(0);
			}
			else
			{
				self setcharacterbodytype(2);
			}
		}
	}
	if(level.inprematchperiod)
	{
		if(isdefined(level.var_a4623c17))
		{
			self [[level.var_a4623c17]]();
		}
		else
		{
			self util::freeze_player_controls(1);
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
					self thread snddelayedmusicstart("spawnFull");
				}
				else
				{
					self thread snddelayedmusicstart("spawnShort");
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
			self thread doinitialspawnmessaging();
		}
	}
	else
	{
		self util::freeze_player_controls(0);
		self enableweapons();
		if(!hadspawned && game["state"] == "playing")
		{
			pixbeginevent("sound");
			team = self.team;
			if(isdefined(self.pers["music"].spawn) && self.pers["music"].spawn == 0)
			{
				music = game["music"]["spawn_" + team];
				self thread snddelayedmusicstart("spawnShort");
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
			self thread doinitialspawnmessaging();
			pixendevent();
		}
	}
	if(self hasperk("specialty_anteup"))
	{
		anteup_bonus = getdvarint("perk_killstreakAnteUpResetValue");
		if(self.pers["momentum_at_spawn_or_game_end"] < anteup_bonus)
		{
			globallogic_score::_setplayermomentum(self, anteup_bonus, 0);
		}
	}
	if(getdvarstring("scr_showperksonspawn") == "")
	{
		setdvar("scr_showperksonspawn", "0");
	}
	if(level.hardcoremode)
	{
		setdvar("scr_showperksonspawn", "0");
	}
	if(getdvarint("scr_showperksonspawn") == 1 && game["state"] != "postgame")
	{
		pixbeginevent("showperksonspawn");
		if(level.perksenabled == 1)
		{
			self hud::showperks();
		}
		pixendevent();
	}
	if(isdefined(self.pers["momentum"]))
	{
		self.momentum = self.pers["momentum"];
	}
	self thread notemomentumongameended();
	pixendevent();
	waittillframeend();
	self notify(#"spawned_player");
	callback::callback(#"hash_bc12b61f");
	self thread globallogic_player::player_monitor_travel_dist();
	self thread globallogic_player::player_monitor_wall_run();
	self thread globallogic_player::player_monitor_swimming();
	self thread globallogic_player::player_monitor_slide();
	self thread globallogic_player::player_monitor_doublejump();
	self thread globallogic_player::player_monitor_inactivity();
	/#
		print(((((("" + self.origin[0]) + "") + self.origin[1]) + "") + self.origin[2]) + "");
	#/
	setdvar("scr_selecting_location", "");
	if(!sessionmodeiszombiesgame())
	{
		self thread killstreaks::killstreak_waiter();
	}
	/#
		if(getdvarint("") > 0)
		{
			self thread globallogic_score::xpratethread();
		}
	#/
	if(game["state"] == "postgame")
	{
		/#
			assert(!level.intermission);
		#/
		self globallogic_player::freezeplayerforroundend();
	}
	self util::set_lighting_state();
}

/*
	Name: notemomentumongameended
	Namespace: globallogic_spawn
	Checksum: 0x74F41757
	Offset: 0x1DD0
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function notemomentumongameended()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"joined_spectators");
	self endon(#"joined_team");
	self notify(#"notemomentumongameended");
	self endon(#"notemomentumongameended");
	level waittill(#"game_ended");
	self.pers["momentum_at_spawn_or_game_end"] = (isdefined(self.pers["momentum"]) ? self.pers["momentum"] : 0);
}

/*
	Name: snddelayedmusicstart
	Namespace: globallogic_spawn
	Checksum: 0x7CCEFF6
	Offset: 0x1E78
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function snddelayedmusicstart(music)
{
	self endon(#"death");
	self endon(#"disconnect");
	while(level.inprematchperiod)
	{
		wait(0.05);
	}
	if(!(isdefined(level.freerun) && level.freerun))
	{
		self thread globallogic_audio::set_music_on_player(music);
	}
}

/*
	Name: spawnspectator
	Namespace: globallogic_spawn
	Checksum: 0x2265AF7F
	Offset: 0x1EF0
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function spawnspectator(origin, angles)
{
	self notify(#"spawned");
	self notify(#"end_respawn");
	in_spawnspectator(origin, angles);
}

/*
	Name: respawn_asspectator
	Namespace: globallogic_spawn
	Checksum: 0x8C7D2B0B
	Offset: 0x1F48
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function respawn_asspectator(origin, angles)
{
	in_spawnspectator(origin, angles);
}

/*
	Name: in_spawnspectator
	Namespace: globallogic_spawn
	Checksum: 0x7E69E83D
	Offset: 0x1F80
	Size: 0x194
	Parameters: 2
	Flags: Linked
*/
function in_spawnspectator(origin, angles)
{
	pixmarker("BEGIN: in_spawnSpectator");
	self setspawnvariables();
	if(self.pers["team"] == "spectator")
	{
		self util::clearlowermessage();
	}
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.spectatekillcam = 0;
	self.friendlydamage = undefined;
	if(self.pers["team"] == "spectator")
	{
		self.statusicon = "";
	}
	else
	{
		self.statusicon = "hud_status_dead";
	}
	spectating::set_permissions_for_machine();
	[[level.onspawnspectator]](origin, angles);
	if(level.teambased && !level.splitscreen)
	{
		self thread spectatorthirdpersonness();
	}
	level thread globallogic::updateteamstatus();
	pixmarker("END: in_spawnSpectator");
}

/*
	Name: spectatorthirdpersonness
	Namespace: globallogic_spawn
	Checksum: 0x7016011A
	Offset: 0x2120
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function spectatorthirdpersonness()
{
	self endon(#"disconnect");
	self endon(#"spawned");
	self notify(#"spectator_thirdperson_thread");
	self endon(#"spectator_thirdperson_thread");
	self.spectatingthirdperson = 0;
}

/*
	Name: forcespawn
	Namespace: globallogic_spawn
	Checksum: 0xC1058D4B
	Offset: 0x2168
	Size: 0xF4
	Parameters: 1
	Flags: None
*/
function forcespawn(time)
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"spawned");
	if(!isdefined(time))
	{
		time = 60;
	}
	wait(time);
	if(self.hasspawned)
	{
		return;
	}
	if(self.pers["team"] == "spectator")
	{
		return;
	}
	if(!globallogic_utils::isvalidclass(self.pers["class"]))
	{
		self.pers["class"] = "CLASS_CUSTOM1";
		self.curclass = self.pers["class"];
	}
	self globallogic_ui::closemenus();
	self thread [[level.spawnclient]]();
}

/*
	Name: kickifdontspawn
	Namespace: globallogic_spawn
	Checksum: 0x15E21384
	Offset: 0x2268
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function kickifdontspawn()
{
	/#
		if(getdvarint("") == 1)
		{
			return;
		}
	#/
	if(self ishost())
	{
		return;
	}
	self kickifidontspawninternal();
}

/*
	Name: kickifidontspawninternal
	Namespace: globallogic_spawn
	Checksum: 0xD15B2892
	Offset: 0x22D0
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function kickifidontspawninternal()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"spawned");
	waittime = 90;
	if(getdvarstring("scr_kick_time") != "")
	{
		waittime = getdvarfloat("scr_kick_time");
	}
	mintime = 45;
	if(getdvarstring("scr_kick_mintime") != "")
	{
		mintime = getdvarfloat("scr_kick_mintime");
	}
	starttime = gettime();
	kickwait(waittime);
	timepassed = (gettime() - starttime) / 1000;
	if(timepassed < (waittime - 0.1) && timepassed < mintime)
	{
		return;
	}
	if(self.hasspawned)
	{
		return;
	}
	if(sessionmodeisprivate())
	{
		return;
	}
	if(self.pers["team"] == "spectator")
	{
		return;
	}
	if(!mayspawn() && (self.pers["time_played_total"] > 0 || util::isprophuntgametype()))
	{
		return;
	}
	globallogic::gamehistoryplayerkicked();
	kick(self getentitynumber(), "EXE_PLAYERKICKED_NOTSPAWNED");
}

/*
	Name: kickwait
	Namespace: globallogic_spawn
	Checksum: 0xC3EAEFD6
	Offset: 0x24E8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function kickwait(waittime)
{
	level endon(#"game_ended");
	hostmigration::waitlongdurationwithhostmigrationpause(waittime);
}

/*
	Name: spawninterroundintermission
	Namespace: globallogic_spawn
	Checksum: 0x56104739
	Offset: 0x2520
	Size: 0x13C
	Parameters: 0
	Flags: None
*/
function spawninterroundintermission()
{
	self notify(#"spawned");
	self notify(#"end_respawn");
	self setspawnvariables();
	self util::clearlowermessage();
	self util::freeze_player_controls(0);
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.spectatekillcam = 0;
	self.friendlydamage = undefined;
	self globallogic_defaults::default_onspawnintermission();
	self setorigin(self.origin);
	self setplayerangles(self.angles);
	self setdepthoffield(0, 128, 512, 4000, 6, 1.8);
}

/*
	Name: spawnintermission
	Namespace: globallogic_spawn
	Checksum: 0x464BCFD6
	Offset: 0x2668
	Size: 0x13C
	Parameters: 2
	Flags: Linked
*/
function spawnintermission(usedefaultcallback, endgame)
{
	self notify(#"spawned");
	self notify(#"end_respawn");
	self endon(#"disconnect");
	self setspawnvariables();
	self util::clearlowermessage();
	self util::freeze_player_controls(0);
	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.spectatekillcam = 0;
	self.friendlydamage = undefined;
	if(isdefined(usedefaultcallback) && usedefaultcallback)
	{
		globallogic_defaults::default_onspawnintermission();
	}
	else
	{
		[[level.onspawnintermission]](endgame);
	}
	self setdepthoffield(0, 128, 512, 4000, 6, 1.8);
}

/*
	Name: spawnqueuedclientonteam
	Namespace: globallogic_spawn
	Checksum: 0x75AF9F0D
	Offset: 0x27B0
	Size: 0xD8
	Parameters: 1
	Flags: Linked
*/
function spawnqueuedclientonteam(team)
{
	player_to_spawn = undefined;
	for(i = 0; i < level.deadplayers[team].size; i++)
	{
		player = level.deadplayers[team][i];
		if(player.waitingtospawn)
		{
			continue;
		}
		player_to_spawn = player;
		break;
	}
	if(isdefined(player_to_spawn))
	{
		player_to_spawn.allowqueuespawn = 1;
		player_to_spawn globallogic_ui::closemenus();
		player_to_spawn thread [[level.spawnclient]]();
	}
}

/*
	Name: spawnqueuedclient
	Namespace: globallogic_spawn
	Checksum: 0x554A5A3
	Offset: 0x2890
	Size: 0x152
	Parameters: 2
	Flags: Linked
*/
function spawnqueuedclient(dead_player_team, killer)
{
	if(!level.playerqueuedrespawn)
	{
		return;
	}
	util::waittillslowprocessallowed();
	spawn_team = undefined;
	if(isdefined(killer) && isdefined(killer.team) && isdefined(level.teams[killer.team]))
	{
		spawn_team = killer.team;
	}
	if(isdefined(spawn_team))
	{
		spawnqueuedclientonteam(spawn_team);
		return;
	}
	foreach(team in level.teams)
	{
		if(team == dead_player_team)
		{
			continue;
		}
		spawnqueuedclientonteam(team);
	}
}

/*
	Name: allteamsnearscorelimit
	Namespace: globallogic_spawn
	Checksum: 0xFCCD6A23
	Offset: 0x29F0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function allteamsnearscorelimit()
{
	if(!level.teambased)
	{
		return false;
	}
	if(level.scorelimit <= 1)
	{
		return false;
	}
	foreach(team in level.teams)
	{
		if(!game["teamScores"][team] >= (level.scorelimit - 1))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: shouldshowrespawnmessage
	Namespace: globallogic_spawn
	Checksum: 0xA8575C1A
	Offset: 0x2AC0
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function shouldshowrespawnmessage()
{
	if(util::waslastround())
	{
		return false;
	}
	if(util::isoneround())
	{
		return false;
	}
	if(isdefined(level.livesdonotreset) && level.livesdonotreset)
	{
		return false;
	}
	if(allteamsnearscorelimit())
	{
		return false;
	}
	return true;
}

/*
	Name: default_spawnmessage
	Namespace: globallogic_spawn
	Checksum: 0xDBF8CF33
	Offset: 0x2B38
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function default_spawnmessage()
{
	util::setlowermessage(game["strings"]["spawn_next_round"]);
	self thread globallogic_ui::removespawnmessageshortly(3);
}

/*
	Name: showspawnmessage
	Namespace: globallogic_spawn
	Checksum: 0x529475C1
	Offset: 0x2B88
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function showspawnmessage()
{
	if(shouldshowrespawnmessage())
	{
		self thread [[level.spawnmessage]]();
	}
}

/*
	Name: spawnclient
	Namespace: globallogic_spawn
	Checksum: 0xCAC8ABF5
	Offset: 0x2BB8
	Size: 0x194
	Parameters: 1
	Flags: Linked
*/
function spawnclient(timealreadypassed)
{
	pixbeginevent("spawnClient");
	/#
		assert(isdefined(self.team));
	#/
	/#
		assert(globallogic_utils::isvalidclass(self.curclass));
	#/
	if(!self mayspawn() && (!(isdefined(self.usedresurrect) && self.usedresurrect)))
	{
		currentorigin = self.origin;
		currentangles = self.angles;
		self showspawnmessage();
		self thread [[level.spawnspectator]](currentorigin + vectorscale((0, 0, 1), 60), currentangles);
		pixendevent();
		return;
	}
	if(self.waitingtospawn)
	{
		pixendevent();
		return;
	}
	self.waitingtospawn = 1;
	self.allowqueuespawn = undefined;
	self waitandspawnclient(timealreadypassed);
	if(isdefined(self))
	{
		self.waitingtospawn = 0;
	}
	pixendevent();
}

/*
	Name: waitandspawnclient
	Namespace: globallogic_spawn
	Checksum: 0x680AC454
	Offset: 0x2D58
	Size: 0x5CC
	Parameters: 1
	Flags: Linked
*/
function waitandspawnclient(timealreadypassed)
{
	self endon(#"disconnect");
	self endon(#"end_respawn");
	level endon(#"game_ended");
	if(!isdefined(timealreadypassed))
	{
		timealreadypassed = 0;
	}
	spawnedasspectator = 0;
	if(isdefined(self.teamkillpunish) && self.teamkillpunish)
	{
		teamkilldelay = globallogic_player::teamkilldelay();
		if(teamkilldelay > timealreadypassed)
		{
			teamkilldelay = teamkilldelay - timealreadypassed;
			timealreadypassed = 0;
		}
		else
		{
			timealreadypassed = timealreadypassed - teamkilldelay;
			teamkilldelay = 0;
		}
		if(teamkilldelay > 0)
		{
			util::setlowermessage(&"MP_FRIENDLY_FIRE_WILL_NOT", teamkilldelay);
			self thread respawn_asspectator(self.origin + vectorscale((0, 0, 1), 60), self.angles);
			spawnedasspectator = 1;
			wait(teamkilldelay);
		}
		self.teamkillpunish = 0;
	}
	if(!isdefined(self.wavespawnindex) && isdefined(level.waveplayerspawnindex[self.team]))
	{
		self.wavespawnindex = level.waveplayerspawnindex[self.team];
		level.waveplayerspawnindex[self.team]++;
	}
	timeuntilspawn = timeuntilspawn(0);
	if(timeuntilspawn > timealreadypassed)
	{
		timeuntilspawn = timeuntilspawn - timealreadypassed;
		timealreadypassed = 0;
	}
	else
	{
		timealreadypassed = timealreadypassed - timeuntilspawn;
		timeuntilspawn = 0;
	}
	if(timeuntilspawn > 0)
	{
		if(level.playerqueuedrespawn)
		{
			util::setlowermessage(game["strings"]["you_will_spawn"], timeuntilspawn);
		}
		else
		{
			if(self issplitscreen())
			{
				util::setlowermessage(game["strings"]["waiting_to_spawn_ss"], timeuntilspawn, 1);
			}
			else
			{
				util::setlowermessage(game["strings"]["waiting_to_spawn"], timeuntilspawn);
			}
		}
		if(!spawnedasspectator)
		{
			spawnorigin = self.origin + vectorscale((0, 0, 1), 60);
			spawnangles = self.angles;
			if(isdefined(level.useintermissionpointsonwavespawn) && [[level.useintermissionpointsonwavespawn]]() == 1)
			{
				spawnpoint = spawnlogic::get_random_intermission_point();
				if(isdefined(spawnpoint))
				{
					spawnorigin = spawnpoint.origin;
					spawnangles = spawnpoint.angles;
				}
			}
			self thread respawn_asspectator(spawnorigin, spawnangles);
		}
		spawnedasspectator = 1;
		self globallogic_utils::waitfortimeornotify(timeuntilspawn, "force_spawn");
		self notify(#"stop_wait_safe_spawn_button");
	}
	if(isdefined(level.gametypespawnwaiter))
	{
		if(!spawnedasspectator)
		{
			self thread respawn_asspectator(self.origin + vectorscale((0, 0, 1), 60), self.angles);
		}
		spawnedasspectator = 1;
		if(!self [[level.gametypespawnwaiter]]())
		{
			self.waitingtospawn = 0;
			self util::clearlowermessage();
			self.wavespawnindex = undefined;
			self.respawntimerstarttime = undefined;
			return;
		}
	}
	wavebased = level.waverespawndelay > 0;
	if(!level.playerforcerespawn && self.hasspawned && !wavebased && !self.wantsafespawn && !level.playerqueuedrespawn)
	{
		util::setlowermessage(game["strings"]["press_to_spawn"]);
		if(!spawnedasspectator)
		{
			self thread respawn_asspectator(self.origin + vectorscale((0, 0, 1), 60), self.angles);
		}
		spawnedasspectator = 1;
		self waitrespawnorsafespawnbutton();
	}
	self.waitingtospawn = 0;
	self util::clearlowermessage();
	self.wavespawnindex = undefined;
	self.respawntimerstarttime = undefined;
	if(isdefined(level.playerincrementalrespawndelay))
	{
		if(isdefined(self.pers["spawns"]))
		{
			self.pers["spawns"]++;
		}
		else
		{
			self.pers["spawns"] = 1;
		}
	}
	self thread [[level.spawnplayer]]();
}

/*
	Name: waitrespawnorsafespawnbutton
	Namespace: globallogic_spawn
	Checksum: 0x4DF04495
	Offset: 0x3330
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function waitrespawnorsafespawnbutton()
{
	self endon(#"disconnect");
	self endon(#"end_respawn");
	while(true)
	{
		if(self usebuttonpressed())
		{
			break;
		}
		wait(0.05);
	}
}

/*
	Name: waitinspawnqueue
	Namespace: globallogic_spawn
	Checksum: 0xD8019057
	Offset: 0x3380
	Size: 0x90
	Parameters: 0
	Flags: None
*/
function waitinspawnqueue()
{
	self endon(#"disconnect");
	self endon(#"end_respawn");
	if(!level.ingraceperiod && !level.usestartspawns)
	{
		currentorigin = self.origin;
		currentangles = self.angles;
		self thread [[level.spawnspectator]](currentorigin + vectorscale((0, 0, 1), 60), currentangles);
		self waittill(#"queue_respawn");
	}
}

/*
	Name: setthirdperson
	Namespace: globallogic_spawn
	Checksum: 0x8D3D9EF6
	Offset: 0x3418
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function setthirdperson(value)
{
	if(!level.console)
	{
		return;
	}
	if(!isdefined(self.spectatingthirdperson) || value != self.spectatingthirdperson)
	{
		self.spectatingthirdperson = value;
		if(value)
		{
			self setclientthirdperson(1);
			self setdepthoffield(0, 128, 512, 4000, 6, 1.8);
		}
		else
		{
			self setclientthirdperson(0);
			self setdepthoffield(0, 0, 512, 4000, 4, 0);
		}
		self resetfov();
	}
}

/*
	Name: setspawnvariables
	Namespace: globallogic_spawn
	Checksum: 0xD9D7A8F8
	Offset: 0x3510
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function setspawnvariables()
{
	resettimeout();
	self stopshellshock();
	self stoprumble("damage_heavy");
}

