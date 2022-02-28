// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_armor;
#using scripts\mp\_behavior_tracker;
#using scripts\mp\_challenges;
#using scripts\mp\_contracts;
#using scripts\mp\_gamerep;
#using scripts\mp\_laststand;
#using scripts\mp\_teamops;
#using scripts\mp\_util;
#using scripts\mp\_vehicle;
#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_deathicons;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_spawn;
#using scripts\mp\gametypes\_globallogic_ui;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_globallogic_vehicle;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_killcam;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\gametypes\_spectating;
#using scripts\mp\gametypes\_weapons;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\teams\_teams;
#using scripts\shared\_burnplayer;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\medals_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\player_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapon_utils;
#using scripts\shared\weapons\_weapons;
#using scripts\shared\weapons_shared;

#namespace globallogic_player;

/*
	Name: on_joined_team
	Namespace: globallogic_player
	Checksum: 0xFFF1B1C5
	Offset: 0x2210
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function on_joined_team()
{
	if(!level.rankedmatch && !level.teambased)
	{
		level thread update_ffa_top_scorers();
	}
}

/*
	Name: freezeplayerforroundend
	Namespace: globallogic_player
	Checksum: 0x421BF341
	Offset: 0x2250
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function freezeplayerforroundend()
{
	self util::clearlowermessage();
	self closeingamemenu();
	self util::freeze_player_controls(1);
	if(!sessionmodeiszombiesgame())
	{
		currentweapon = self getcurrentweapon();
		if(killstreaks::is_killstreak_weapon(currentweapon) && !currentweapon.iscarriedkillstreak)
		{
			self takeweapon(currentweapon);
		}
	}
}

/*
	Name: arraytostring
	Namespace: globallogic_player
	Checksum: 0x14A94C50
	Offset: 0x2320
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function arraytostring(inputarray)
{
	targetstring = "";
	for(i = 0; i < inputarray.size; i++)
	{
		targetstring = targetstring + inputarray[i];
		if(i != (inputarray.size - 1))
		{
			targetstring = targetstring + ",";
		}
	}
	return targetstring;
}

/*
	Name: recordendgamecomscoreeventforplayer
	Namespace: globallogic_player
	Checksum: 0x49EEB185
	Offset: 0x23B8
	Size: 0x120C
	Parameters: 2
	Flags: Linked
*/
function recordendgamecomscoreeventforplayer(player, result)
{
	lpselfnum = player getentitynumber();
	lpxuid = player getxuid(1);
	bbprint("global_leave", "name %s client %s xuid %s", player.name, lpselfnum, lpxuid);
	weeklyacontractid = 0;
	weeklyacontracttarget = 0;
	weeklyacontractcurrent = 0;
	weeklyacontractcompleted = 0;
	weeklybcontractid = 0;
	weeklybcontracttarget = 0;
	weeklybcontractcurrent = 0;
	weeklybcontractcompleted = 0;
	dailycontractid = 0;
	dailycontracttarget = 0;
	dailycontractcurrent = 0;
	dailycontractcompleted = 0;
	specialcontractid = 0;
	specialcontracttarget = 0;
	specialcontractcurent = 0;
	specialcontractcompleted = 0;
	if(player util::is_bot())
	{
		currxp = 0;
		prevxp = 0;
	}
	else
	{
		currxp = player rank::getrankxpstat();
		prevxp = player.pers["rankxp"];
		if(globallogic_score::canupdateweaponcontractstats(player))
		{
			specialcontractid = 1;
			specialcontracttarget = getdvarint("weapon_contract_target_value", 100);
			specialcontractcurent = player getdstat("weaponContractData", "currentValue");
			if((isdefined(player getdstat("weaponContractData", "completeTimestamp")) ? player getdstat("weaponContractData", "completeTimestamp") : 0) != 0)
			{
				specialcontractcompleted = 1;
			}
		}
		if(player contracts::can_process_contracts())
		{
			contractid = player contracts::get_contract_stat(0, "index");
			if(player contracts::is_contract_active(contractid))
			{
				weeklyacontractid = contractid;
				weeklyacontracttarget = player.pers["contracts"][weeklyacontractid].target_value;
				weeklyacontractcurrent = player contracts::get_contract_stat(0, "progress");
				weeklyacontractcompleted = player contracts::get_contract_stat(0, "award_given");
			}
			contractid = player contracts::get_contract_stat(1, "index");
			if(player contracts::is_contract_active(contractid))
			{
				weeklybcontractid = contractid;
				weeklybcontracttarget = player.pers["contracts"][weeklybcontractid].target_value;
				weeklybcontractcurrent = player contracts::get_contract_stat(1, "progress");
				weeklybcontractcompleted = player contracts::get_contract_stat(1, "award_given");
			}
			contractid = player contracts::get_contract_stat(2, "index");
			if(player contracts::is_contract_active(contractid))
			{
				dailycontractid = contractid;
				dailycontracttarget = player.pers["contracts"][dailycontractid].target_value;
				dailycontractcurrent = player contracts::get_contract_stat(2, "progress");
				dailycontractcompleted = player contracts::get_contract_stat(2, "award_given");
			}
		}
	}
	if(!isdefined(prevxp))
	{
		return;
	}
	resultstr = result;
	if(isdefined(player.team) && result == player.team)
	{
		resultstr = "win";
	}
	else if(result == "allies" || result == "axis")
	{
		resultstr = "lose";
	}
	xpearned = currxp - prevxp;
	perkstr = arraytostring(player getperks());
	primaryweaponname = "";
	primaryweaponattachstr = "";
	secondaryweaponname = "";
	secondaryweaponattachstr = "";
	grenadeprimaryname = "";
	grenadesecondaryname = "";
	if(isdefined(player.primaryloadoutweapon))
	{
		primaryweaponname = player.primaryloadoutweapon.name;
		primaryweaponattachstr = arraytostring(getarraykeys(player.primaryloadoutweapon.attachments));
	}
	if(isdefined(player.secondaryloadoutweapon))
	{
		secondaryweaponname = player.secondaryloadoutweapon.name;
		secondaryweaponattachstr = arraytostring(getarraykeys(player.secondaryloadoutweapon.attachments));
	}
	if(isdefined(player.grenadetypeprimary))
	{
		grenadeprimaryname = player.grenadetypeprimary.name;
	}
	if(isdefined(player.grenadetypesecondary))
	{
		grenadesecondaryname = player.grenadetypesecondary.name;
	}
	killstreakstr = arraytostring(player.killstreak);
	gamelength = game["timepassed"] / 1000;
	timeplayed = player globallogic::gettotaltimeplayed(gamelength);
	totalkills = 0;
	totalhits = 0;
	totaldeaths = 0;
	totalwins = 0;
	totalxp = 0;
	if(level.gametype != "fr")
	{
		totalkills = player getdstat("playerstatslist", "kills", "statValue");
		totalhits = player getdstat("playerstatslist", "hits", "statValue");
		totaldeaths = player getdstat("playerstatslist", "deaths", "statValue");
		totalwins = player getdstat("playerstatslist", "wins", "statValue");
		totalxp = player getdstat("playerstatslist", "rankxp", "statValue");
	}
	killcount = 0;
	hitcount = 0;
	if(level.mpcustommatch)
	{
		killcount = player.kills;
		hitcount = player.shotshit;
	}
	else
	{
		if(isdefined(player.startkills))
		{
			killcount = totalkills - player.startkills;
		}
		if(isdefined(player.starthits))
		{
			hitcount = totalhits - player.starthits;
		}
	}
	bestscore = "0";
	if(isdefined(player.pers["lastHighestScore"]) && player.score > player.pers["lastHighestScore"])
	{
		bestscore = "1";
	}
	bestkills = "0";
	if(isdefined(player.pers["lastHighestKills"]) && killcount > player.pers["lastHighestKills"])
	{
		bestkills = "1";
	}
	totalmatchshots = 0;
	if(isdefined(player.totalmatchshots))
	{
		totalmatchshots = player.totalmatchshots;
	}
	deaths = player.deaths;
	if(deaths == 0)
	{
		deaths = 1;
	}
	kdratio = (player.kills * 1000) / deaths;
	bestkdratio = "0";
	if(isdefined(player.pers["lastHighestKDRatio"]) && kdratio > player.pers["lastHighestKDRatio"])
	{
		bestkdratio = "1";
	}
	showcaseweapon = player getplayershowcaseweapon();
	recordcomscoreevent("end_match", "match_id", getdemofileid(), "game_variant", "mp", "game_mode", level.gametype, "private_match", sessionmodeisprivate(), "esports_flag", level.leaguematch, "ranked_play_flag", level.arenamatch, "league_team_id", player getleagueteamid(), "game_map", getdvarstring("mapname"), "player_xuid", player getxuid(1), "player_ip", player getipaddress(), "match_kills", killcount, "match_deaths", player.deaths, "match_xp", xpearned, "match_score", player.score, "match_streak", player.pers["best_kill_streak"], "match_captures", player.pers["captures"], "match_defends", player.pers["defends"], "match_headshots", player.pers["headshots"], "match_longshots", player.pers["longshots"], "match_objtime", player.pers["objtime"], "match_plants", player.pers["plants"], "match_defuses", player.pers["defuses"], "match_throws", player.pers["throws"], "match_carries", player.pers["carries"], "match_returns", player.pers["returns"], "prestige_max", player.pers["plevel"], "level_max", player.pers["rank"], "match_result", resultstr, "match_duration", timeplayed, "match_shots", totalmatchshots, "match_hits", hitcount, "player_gender", player getplayergendertype(currentsessionmode()), "specialist_kills", player.heroweaponkillcount, "specialist_used", player getmpdialogname(), "season_pass_owned", player hasseasonpass(0), "loadout_perks", perkstr, "loadout_lethal", grenadeprimaryname, "loadout_tactical", grenadesecondaryname, "loadout_scorestreaks", killstreakstr, "loadout_primary_weapon", primaryweaponname, "loadout_secondary_weapon", secondaryweaponname, "dlc_owned", player getdlcavailable(), "loadout_primary_attachments", primaryweaponattachstr, "loadout_secondary_attachments", secondaryweaponattachstr, "best_score", bestscore, "best_kills", bestkills, "best_kd", bestkdratio, "total_kills", totalkills, "total_deaths", totaldeaths, "total_wins", totalwins, "total_xp", totalxp, "daily_contract_id", dailycontractid, "daily_contract_target", dailycontracttarget, "daily_contract_current", dailycontractcurrent, "daily_contract_completed", dailycontractcompleted, "weeklyA_contract_id", weeklyacontractid, "weeklyA_contract_target", weeklyacontracttarget, "weeklyA_contract_current", weeklyacontractcurrent, "weeklyA_contract_completed", weeklyacontractcompleted, "weeklyB_contract_id", weeklybcontractid, "weeklyB_contract_target", weeklybcontracttarget, "weeklyB_contract_current", weeklybcontractcurrent, "weeklyB_contract_completed", weeklybcontractcompleted, "special_contract_id ", specialcontractid, "special_contract_target", specialcontracttarget, "special_contract_curent", specialcontractcurent, "special_contract_completed", specialcontractcompleted, "specialist_power", player.heroabilityname, "specialist_head", player getcharacterhelmetmodel(), "specialist_body", player getcharacterbodymodel(), "specialist_taunt", player getplayerselectedtauntname(0), "specialist_goodgame", player getplayerselectedgesturename(0), "specialist_threaten", player getplayerselectedgesturename(1), "specialist_boast", player getplayerselectedgesturename(2), "specialist_showcase", showcaseweapon.weapon.name);
}

/*
	Name: player_monitor_travel_dist
	Namespace: globallogic_player
	Checksum: 0xB45950F7
	Offset: 0x35D0
	Size: 0x1FE
	Parameters: 0
	Flags: Linked
*/
function player_monitor_travel_dist()
{
	self endon(#"death");
	self endon(#"disconnect");
	waittime = 1;
	minimummovedistance = 16;
	wait(4);
	prevpos = self.origin;
	positionptm = self.origin;
	while(true)
	{
		wait(waittime);
		if(self util::isusingremote())
		{
			self waittill(#"stopped_using_remote");
			prevpos = self.origin;
			positionptm = self.origin;
			continue;
		}
		distance = distance(self.origin, prevpos);
		self.pers["total_distance_travelled"] = self.pers["total_distance_travelled"] + distance;
		self.pers["movement_Update_Count"]++;
		prevpos = self.origin;
		if((self.pers["movement_Update_Count"] % 5) == 0)
		{
			distancemoving = distance(self.origin, positionptm);
			positionptm = self.origin;
			if(distancemoving > minimummovedistance)
			{
				self.pers["num_speeds_when_moving_entries"]++;
				self.pers["total_speeds_when_moving"] = self.pers["total_speeds_when_moving"] + (distancemoving / waittime);
				self.pers["time_played_moving"] = self.pers["time_played_moving"] + waittime;
			}
		}
	}
}

/*
	Name: record_special_move_data_for_life
	Namespace: globallogic_player
	Checksum: 0xA52A58B
	Offset: 0x37D8
	Size: 0x204
	Parameters: 1
	Flags: Linked
*/
function record_special_move_data_for_life(killer)
{
	if(!isdefined(self.lastswimmingstarttime) || !isdefined(self.lastwallrunstarttime) || !isdefined(self.lastslidestarttime) || !isdefined(self.lastdoublejumpstarttime) || !isdefined(self.timespentswimminginlife) || !isdefined(self.timespentwallrunninginlife) || !isdefined(self.numberofdoublejumpsinlife) || !isdefined(self.numberofslidesinlife))
	{
		/#
			println("");
		#/
		return;
	}
	if(isdefined(killer))
	{
		if(!isdefined(killer.lastswimmingstarttime) || !isdefined(killer.lastwallrunstarttime) || !isdefined(killer.lastslidestarttime) || !isdefined(killer.lastdoublejumpstarttime))
		{
			/#
				println("");
			#/
			return;
		}
		matchrecordlogspecialmovedataforlife(self, self.lastswimmingstarttime, self.lastwallrunstarttime, self.lastslidestarttime, self.lastdoublejumpstarttime, self.timespentswimminginlife, self.timespentwallrunninginlife, self.numberofdoublejumpsinlife, self.numberofslidesinlife, killer, killer.lastswimmingstarttime, killer.lastwallrunstarttime, killer.lastslidestarttime, killer.lastdoublejumpstarttime);
	}
	else
	{
		matchrecordlogspecialmovedataforlife(self, self.lastswimmingstarttime, self.lastwallrunstarttime, self.lastslidestarttime, self.lastdoublejumpstarttime, self.timespentswimminginlife, self.timespentwallrunninginlife, self.numberofdoublejumpsinlife, self.numberofslidesinlife);
	}
}

/*
	Name: player_monitor_wall_run
	Namespace: globallogic_player
	Checksum: 0x36317591
	Offset: 0x39E8
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function player_monitor_wall_run()
{
	self endon(#"disconnect");
	self notify(#"stop_player_monitor_wall_run");
	self endon(#"stop_player_monitor_wall_run");
	self.lastwallrunstarttime = 0;
	self.timespentwallrunninginlife = 0;
	while(true)
	{
		notification = self util::waittill_any_return("wallrun_begin", "death", "disconnect", "stop_player_monitor_wall_run");
		if(notification == "death")
		{
			break;
		}
		self.lastwallrunstarttime = gettime();
		notification = self util::waittill_any_return("wallrun_end", "death", "disconnect", "stop_player_monitor_wall_run");
		self.timespentwallrunninginlife = self.timespentwallrunninginlife + (gettime() - self.lastwallrunstarttime);
		if(notification == "death")
		{
			break;
		}
	}
}

/*
	Name: player_monitor_swimming
	Namespace: globallogic_player
	Checksum: 0x653361B2
	Offset: 0x3B08
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function player_monitor_swimming()
{
	self endon(#"disconnect");
	self notify(#"stop_player_monitor_swimming");
	self endon(#"stop_player_monitor_swimming");
	self.lastswimmingstarttime = 0;
	self.timespentswimminginlife = 0;
	while(true)
	{
		notification = self util::waittill_any_return("swimming_begin", "death", "disconnect", "stop_player_monitor_swimming");
		if(notification == "death")
		{
			break;
		}
		self.lastswimmingstarttime = gettime();
		notification = self util::waittill_any_return("swimming_end", "death", "disconnect", "stop_player_monitor_swimming");
		self.timespentswimminginlife = self.timespentswimminginlife + (gettime() - self.lastswimmingstarttime);
		if(notification == "death")
		{
			break;
		}
	}
}

/*
	Name: player_monitor_slide
	Namespace: globallogic_player
	Checksum: 0x160AD765
	Offset: 0x3C28
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function player_monitor_slide()
{
	self endon(#"disconnect");
	self notify(#"stop_player_monitor_slide");
	self endon(#"stop_player_monitor_slide");
	self.lastslidestarttime = 0;
	self.numberofslidesinlife = 0;
	while(true)
	{
		notification = self util::waittill_any_return("slide_begin", "death", "disconnect", "stop_player_monitor_slide");
		if(notification == "death")
		{
			break;
		}
		self.lastslidestarttime = gettime();
		self.numberofslidesinlife++;
		notification = self util::waittill_any_return("slide_end", "death", "disconnect", "stop_player_monitor_slide");
		if(notification == "death")
		{
			break;
		}
	}
}

/*
	Name: player_monitor_doublejump
	Namespace: globallogic_player
	Checksum: 0xBD4AC2CB
	Offset: 0x3D30
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function player_monitor_doublejump()
{
	self endon(#"disconnect");
	self notify(#"stop_player_monitor_doublejump");
	self endon(#"stop_player_monitor_doublejump");
	self.lastdoublejumpstarttime = 0;
	self.numberofdoublejumpsinlife = 0;
	while(true)
	{
		notification = self util::waittill_any_return("doublejump_begin", "death", "disconnect", "stop_player_monitor_doublejump");
		if(notification == "death")
		{
			break;
		}
		self.lastdoublejumpstarttime = gettime();
		self.numberofdoublejumpsinlife++;
		notification = self util::waittill_any_return("doublejump_end", "death", "disconnect", "stop_player_monitor_doublejump");
		if(notification == "death")
		{
			break;
		}
	}
}

/*
	Name: player_monitor_inactivity
	Namespace: globallogic_player
	Checksum: 0x49B1626F
	Offset: 0x3E38
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function player_monitor_inactivity()
{
	self endon(#"disconnect");
	self notify(#"player_monitor_inactivity");
	self endon(#"player_monitor_inactivity");
	wait(10);
	while(true)
	{
		if(isdefined(self))
		{
			if(self isremotecontrolling() || self util::isusingremote())
			{
				self resetinactivitytimer();
			}
		}
		wait(5);
	}
}

/*
	Name: callback_playerconnect
	Namespace: globallogic_player
	Checksum: 0x17916F3A
	Offset: 0x3ED0
	Size: 0x232C
	Parameters: 0
	Flags: Linked
*/
function callback_playerconnect()
{
	thread notifyconnecting();
	self.statusicon = "hud_status_connecting";
	self waittill(#"begin");
	if(isdefined(level.reset_clientdvars))
	{
		self [[level.reset_clientdvars]]();
	}
	waittillframeend();
	self.statusicon = "";
	self.guid = self getguid();
	self.killstreak = [];
	self.leaderdialogqueue = [];
	self.killstreakdialogqueue = [];
	profilelog_begintiming(4, "ship");
	level notify(#"connected", self);
	callback::callback(#"hash_eaffea17");
	if(self ishost())
	{
		self thread globallogic::listenforgameend();
	}
	if(!level.splitscreen && !isdefined(self.pers["score"]))
	{
		iprintln(&"MP_CONNECTED", self);
	}
	if(!isdefined(self.pers["score"]))
	{
		self thread persistence::adjust_recent_stats();
		self persistence::set_after_action_report_stat("valid", 0);
		if(gamemodeismode(3) && !self ishost())
		{
			self persistence::set_after_action_report_stat("wagerMatchFailed", 1);
		}
		else
		{
			self persistence::set_after_action_report_stat("wagerMatchFailed", 0);
		}
	}
	if(level.rankedmatch || level.wagermatch || level.leaguematch && !isdefined(self.pers["matchesPlayedStatsTracked"]))
	{
		gamemode = util::getcurrentgamemode();
		self globallogic::incrementmatchcompletionstat(gamemode, "played", "started");
		if(!isdefined(self.pers["matchesHostedStatsTracked"]) && self islocaltohost())
		{
			self globallogic::incrementmatchcompletionstat(gamemode, "hosted", "started");
			self.pers["matchesHostedStatsTracked"] = 1;
		}
		self.pers["matchesPlayedStatsTracked"] = 1;
		self thread persistence::upload_stats_soon();
	}
	self gamerep::gamerepplayerconnected();
	lpselfnum = self getentitynumber();
	lpguid = self getguid();
	lpxuid = self getxuid(1);
	/#
		logprint(((((("" + lpguid) + "") + lpselfnum) + "") + self.name) + "");
	#/
	bbprint("global_joins", "name %s client %s xuid %s", self.name, lpselfnum, lpxuid);
	recordplayerstats(self, "codeClientNum", lpselfnum);
	if(!sessionmodeiszombiesgame())
	{
		self setclientuivisibilityflag("hud_visible", 1);
		self setclientuivisibilityflag("weapon_hud_visible", 1);
	}
	self setclientplayersprinttime(level.playersprinttime);
	self setclientnumlives(level.numlives);
	if(level.hardcoremode)
	{
		self setclientdrawtalk(3);
	}
	if(sessionmodeiszombiesgame())
	{
		self [[level.player_stats_init]]();
	}
	else
	{
		self globallogic_score::initpersstat("score");
		if(level.resetplayerscoreeveryround)
		{
			self.pers["score"] = 0;
		}
		self.score = self.pers["score"];
		self globallogic_score::initpersstat("pointstowin");
		if(level.scoreroundwinbased)
		{
			self.pers["pointstowin"] = 0;
		}
		self.pointstowin = self.pers["pointstowin"];
		self globallogic_score::initpersstat("momentum", 0);
		self.momentum = self globallogic_score::getpersstat("momentum");
		self globallogic_score::initpersstat("suicides");
		self.suicides = self globallogic_score::getpersstat("suicides");
		self globallogic_score::initpersstat("headshots");
		self.headshots = self globallogic_score::getpersstat("headshots");
		self globallogic_score::initpersstat("challenges");
		self.challenges = self globallogic_score::getpersstat("challenges");
		self globallogic_score::initpersstat("kills");
		self.kills = self globallogic_score::getpersstat("kills");
		self globallogic_score::initpersstat("deaths");
		self.deaths = self globallogic_score::getpersstat("deaths");
		self globallogic_score::initpersstat("assists");
		self.assists = self globallogic_score::getpersstat("assists");
		self globallogic_score::initpersstat("defends", 0);
		self.defends = self globallogic_score::getpersstat("defends");
		self globallogic_score::initpersstat("offends", 0);
		self.offends = self globallogic_score::getpersstat("offends");
		self globallogic_score::initpersstat("plants", 0);
		self.plants = self globallogic_score::getpersstat("plants");
		self globallogic_score::initpersstat("defuses", 0);
		self.defuses = self globallogic_score::getpersstat("defuses");
		self globallogic_score::initpersstat("returns", 0);
		self.returns = self globallogic_score::getpersstat("returns");
		self globallogic_score::initpersstat("captures", 0);
		self.captures = self globallogic_score::getpersstat("captures");
		self globallogic_score::initpersstat("objtime", 0);
		self.objtime = self globallogic_score::getpersstat("objtime");
		self globallogic_score::initpersstat("carries", 0);
		self.carries = self globallogic_score::getpersstat("carries");
		self globallogic_score::initpersstat("throws", 0);
		self.throws = self globallogic_score::getpersstat("throws");
		self globallogic_score::initpersstat("destructions", 0);
		self.destructions = self globallogic_score::getpersstat("destructions");
		self globallogic_score::initpersstat("disables", 0);
		self.disables = self globallogic_score::getpersstat("disables");
		self globallogic_score::initpersstat("escorts", 0);
		self.escorts = self globallogic_score::getpersstat("escorts");
		self globallogic_score::initpersstat("infects", 0);
		self.infects = self globallogic_score::getpersstat("infects");
		self globallogic_score::initpersstat("sbtimeplayed", 0);
		self.sbtimeplayed = self globallogic_score::getpersstat("sbtimeplayed");
		self globallogic_score::initpersstat("backstabs", 0);
		self.backstabs = self globallogic_score::getpersstat("backstabs");
		self globallogic_score::initpersstat("longshots", 0);
		self.longshots = self globallogic_score::getpersstat("longshots");
		self globallogic_score::initpersstat("survived", 0);
		self.survived = self globallogic_score::getpersstat("survived");
		self globallogic_score::initpersstat("stabs", 0);
		self.stabs = self globallogic_score::getpersstat("stabs");
		self globallogic_score::initpersstat("tomahawks", 0);
		self.tomahawks = self globallogic_score::getpersstat("tomahawks");
		self globallogic_score::initpersstat("humiliated", 0);
		self.humiliated = self globallogic_score::getpersstat("humiliated");
		self globallogic_score::initpersstat("x2score", 0);
		self.x2score = self globallogic_score::getpersstat("x2score");
		self globallogic_score::initpersstat("agrkills", 0);
		self.x2score = self globallogic_score::getpersstat("agrkills");
		self globallogic_score::initpersstat("hacks", 0);
		self.x2score = self globallogic_score::getpersstat("hacks");
		self globallogic_score::initpersstat("killsconfirmed", 0);
		self.killsconfirmed = self globallogic_score::getpersstat("killsconfirmed");
		self globallogic_score::initpersstat("killsdenied", 0);
		self.killsdenied = self globallogic_score::getpersstat("killsdenied");
		self globallogic_score::initpersstat("rescues", 0);
		self.rescues = self globallogic_score::getpersstat("rescues");
		self globallogic_score::initpersstat("shotsfired", 0);
		self.shotsfired = self globallogic_score::getpersstat("shotsfired");
		self globallogic_score::initpersstat("shotshit", 0);
		self.shotshit = self globallogic_score::getpersstat("shotshit");
		self globallogic_score::initpersstat("shotsmissed", 0);
		self.shotsmissed = self globallogic_score::getpersstat("shotsmissed");
		self globallogic_score::initpersstat("cleandeposits", 0);
		self.cleandeposits = self globallogic_score::getpersstat("cleandeposits");
		self globallogic_score::initpersstat("cleandenies", 0);
		self.cleandenies = self globallogic_score::getpersstat("cleandenies");
		self globallogic_score::initpersstat("victory", 0);
		self.victory = self globallogic_score::getpersstat("victory");
		self globallogic_score::initpersstat("sessionbans", 0);
		self.sessionbans = self globallogic_score::getpersstat("sessionbans");
		self globallogic_score::initpersstat("gametypeban", 0);
		self globallogic_score::initpersstat("time_played_total", 0);
		self globallogic_score::initpersstat("time_played_alive", 0);
		self globallogic_score::initpersstat("teamkills", 0);
		self globallogic_score::initpersstat("teamkills_nostats", 0);
		self globallogic_score::initpersstat("kill_distances", 0);
		self globallogic_score::initpersstat("num_kill_distance_entries", 0);
		self globallogic_score::initpersstat("time_played_moving", 0);
		self globallogic_score::initpersstat("total_speeds_when_moving", 0);
		self globallogic_score::initpersstat("num_speeds_when_moving_entries", 0);
		self globallogic_score::initpersstat("total_distance_travelled", 0);
		self globallogic_score::initpersstat("movement_Update_Count", 0);
		self.teamkillpunish = 0;
		if(level.minimumallowedteamkills >= 0 && self.pers["teamkills_nostats"] > level.minimumallowedteamkills)
		{
			self thread reduceteamkillsovertime();
		}
		self behaviortracker::initialize();
	}
	self.killedplayerscurrent = [];
	if(!isdefined(self.pers["totalTimePlayed"]))
	{
		self setentertime(gettime());
		self.pers["totalTimePlayed"] = 0;
	}
	if(!isdefined(self.pers["totalMatchBonus"]))
	{
		self.pers["totalMatchBonus"] = 0;
	}
	if(!isdefined(self.pers["best_kill_streak"]))
	{
		self.pers["killed_players"] = [];
		self.pers["killed_by"] = [];
		self.pers["nemesis_tracking"] = [];
		self.pers["artillery_kills"] = 0;
		self.pers["dog_kills"] = 0;
		self.pers["nemesis_name"] = "";
		self.pers["nemesis_rank"] = 0;
		self.pers["nemesis_rankIcon"] = 0;
		self.pers["nemesis_xp"] = 0;
		self.pers["nemesis_xuid"] = "";
		self.pers["killed_players_with_specialist"] = [];
		self.pers["best_kill_streak"] = 0;
	}
	if(!isdefined(self.pers["music"]))
	{
		self.pers["music"] = spawnstruct();
		self.pers["music"].spawn = 0;
		self.pers["music"].inque = 0;
		self.pers["music"].currentstate = "SILENT";
		self.pers["music"].previousstate = "SILENT";
		self.pers["music"].nextstate = "UNDERSCORE";
		self.pers["music"].returnstate = "UNDERSCORE";
	}
	if(self.team != "spectator")
	{
		self thread globallogic_audio::set_music_on_player("spawnPreLoop");
	}
	if(!isdefined(self.pers["cur_kill_streak"]))
	{
		self.pers["cur_kill_streak"] = 0;
	}
	if(!isdefined(self.pers["cur_total_kill_streak"]))
	{
		self.pers["cur_total_kill_streak"] = 0;
		self setplayercurrentstreak(0);
	}
	if(!isdefined(self.pers["totalKillstreakCount"]))
	{
		self.pers["totalKillstreakCount"] = 0;
	}
	if(!isdefined(self.pers["killstreaksEarnedThisKillstreak"]))
	{
		self.pers["killstreaksEarnedThisKillstreak"] = 0;
	}
	if(isdefined(level.usingscorestreaks) && level.usingscorestreaks && !isdefined(self.pers["killstreak_quantity"]))
	{
		self.pers["killstreak_quantity"] = [];
	}
	if(isdefined(level.usingscorestreaks) && level.usingscorestreaks && !isdefined(self.pers["held_killstreak_ammo_count"]))
	{
		self.pers["held_killstreak_ammo_count"] = [];
	}
	if(isdefined(level.usingscorestreaks) && level.usingscorestreaks && !isdefined(self.pers["held_killstreak_clip_count"]))
	{
		self.pers["held_killstreak_clip_count"] = [];
	}
	if(!isdefined(self.pers["changed_class"]))
	{
		self.pers["changed_class"] = 0;
	}
	if(!isdefined(self.pers["lastroundscore"]))
	{
		self.pers["lastroundscore"] = 0;
	}
	self.lastkilltime = 0;
	self.cur_death_streak = 0;
	self disabledeathstreak();
	self.death_streak = 0;
	self.kill_streak = 0;
	self.gametype_kill_streak = 0;
	self.spawnqueueindex = -1;
	self.deathtime = 0;
	self.alivetimes = [];
	for(index = 0; index < level.alivetimemaxcount; index++)
	{
		self.alivetimes[index] = 0;
	}
	self.alivetimecurrentindex = 0;
	if(level.onlinegame && (!(isdefined(level.freerun) && level.freerun)))
	{
		self.death_streak = self getdstat("HighestStats", "death_streak");
		self.kill_streak = self getdstat("HighestStats", "kill_streak");
		self.gametype_kill_streak = self persistence::stat_get_with_gametype("kill_streak");
	}
	self.lastgrenadesuicidetime = -1;
	self.teamkillsthisround = 0;
	if(!isdefined(level.livesdonotreset) || !level.livesdonotreset || !isdefined(self.pers["lives"]))
	{
		self.pers["lives"] = level.numlives;
	}
	if(!level.teambased)
	{
		self.pers["team"] = undefined;
	}
	self.hasspawned = 0;
	self.waitingtospawn = 0;
	self.wantsafespawn = 0;
	self.deathcount = 0;
	self.wasaliveatmatchstart = 0;
	level.players[level.players.size] = self;
	if(level.splitscreen)
	{
		setdvar("splitscreen_playerNum", level.players.size);
	}
	if(game["state"] == "postgame")
	{
		self.pers["needteam"] = 1;
		self.pers["team"] = "spectator";
		self.team = self.sessionteam;
		self setclientuivisibilityflag("hud_visible", 0);
		self [[level.spawnintermission]]();
		self closeingamemenu();
		profilelog_endtiming(4, (("gs=" + game["state"]) + " zom=") + sessionmodeiszombiesgame());
		return;
	}
	if(level.rankedmatch || level.wagermatch || level.leaguematch && !isdefined(self.pers["lossAlreadyReported"]))
	{
		if(level.leaguematch)
		{
			self recordleaguepreloser();
		}
		globallogic_score::updatelossstats(self);
		self.pers["lossAlreadyReported"] = 1;
	}
	if(level.rankedmatch || level.leaguematch && !isdefined(self.pers["lateJoin"]))
	{
		if(game["state"] == "playing" && !level.inprematchperiod)
		{
			self.pers["lateJoin"] = 1;
		}
		else
		{
			self.pers["lateJoin"] = 0;
		}
	}
	if(!isdefined(self.pers["winstreakAlreadyCleared"]))
	{
		self globallogic_score::backupandclearwinstreaks();
		self.pers["winstreakAlreadyCleared"] = 1;
	}
	if(self istestclient())
	{
		self.pers["isBot"] = 1;
		recordplayerstats(self, "isBot", 1);
	}
	if(level.rankedmatch || level.leaguematch)
	{
		self persistence::set_after_action_report_stat("demoFileID", "0");
	}
	level endon(#"game_ended");
	if(isdefined(level.hostmigrationtimer))
	{
		self thread hostmigration::hostmigrationtimerthink();
	}
	if(isdefined(self.pers["team"]))
	{
		self.team = self.pers["team"];
	}
	if(isdefined(self.pers["class"]))
	{
		self.curclass = self.pers["class"];
	}
	if(!isdefined(self.pers["team"]) || isdefined(self.pers["needteam"]))
	{
		self.pers["needteam"] = undefined;
		self.pers["team"] = "spectator";
		self.team = "spectator";
		self.sessionstate = "dead";
		self globallogic_ui::updateobjectivetext();
		[[level.spawnspectator]]();
		[[level.autoassign]](0);
		if(level.rankedmatch || level.leaguematch)
		{
			self thread globallogic_spawn::kickifdontspawn();
		}
		if(self.pers["team"] == "spectator")
		{
			self.sessionteam = "spectator";
			self thread spectate_player_watcher();
		}
		if(level.teambased)
		{
			self.sessionteam = self.pers["team"];
			if(!isalive(self))
			{
				self.statusicon = "hud_status_dead";
			}
			self thread spectating::set_permissions();
		}
	}
	else
	{
		if(self.pers["team"] == "spectator")
		{
			self setclientscriptmainmenu(game["menu_start_menu"]);
			[[level.spawnspectator]]();
			self.sessionteam = "spectator";
			self.sessionstate = "spectator";
			self thread spectate_player_watcher();
		}
		else
		{
			self.sessionteam = self.pers["team"];
			self.sessionstate = "dead";
			self globallogic_ui::updateobjectivetext();
			[[level.spawnspectator]]();
			if(globallogic_utils::isvalidclass(self.pers["class"]) || util::isprophuntgametype())
			{
				if(!globallogic_utils::isvalidclass(self.pers["class"]))
				{
					self.pers["class"] = level.defaultclass;
					self.curclass = level.defaultclass;
					self setclientscriptmainmenu(game["menu_start_menu"]);
				}
				self thread [[level.spawnclient]]();
			}
			else
			{
				self globallogic_ui::showmainmenuforteam();
			}
			self thread spectating::set_permissions();
		}
	}
	if(self.sessionteam != "spectator")
	{
		self thread spawning::onspawnplayer(1);
	}
	if(level.forceradar == 1)
	{
		self.pers["hasRadar"] = 1;
		self.hasspyplane = 1;
		if(level.teambased)
		{
			level.activeuavs[self.team]++;
		}
		else
		{
			level.activeuavs[self getentitynumber()]++;
		}
		level.activeplayeruavs[self getentitynumber()]++;
	}
	if(level.forceradar == 2)
	{
		self setclientuivisibilityflag("g_compassShowEnemies", level.forceradar);
	}
	else
	{
		self setclientuivisibilityflag("g_compassShowEnemies", 0);
	}
	profilelog_endtiming(4, (("gs=" + game["state"]) + " zom=") + sessionmodeiszombiesgame());
	if(isdefined(self.pers["isBot"]))
	{
		return;
	}
	self record_global_mp_stats_for_player_at_match_start();
	num_con = getnumconnectedplayers();
	num_exp = getnumexpectedplayers();
	/#
		println("", num_con, "", num_exp);
	#/
	if(num_con == num_exp && num_exp != 0)
	{
		level flag::set("all_players_connected");
		setdvar("all_players_are_connected", "1");
	}
	globallogic_score::updateweaponcontractstart(self);
}

/*
	Name: record_global_mp_stats_for_player_at_match_start
	Namespace: globallogic_player
	Checksum: 0xE6B643C7
	Offset: 0x6208
	Size: 0x4C4
	Parameters: 0
	Flags: Linked
*/
function record_global_mp_stats_for_player_at_match_start()
{
	if(isdefined(level.disablestattracking) && level.disablestattracking == 1)
	{
		return;
	}
	startkills = self getdstat("playerstatslist", "kills", "statValue");
	startdeaths = self getdstat("playerstatslist", "deaths", "statValue");
	startwins = self getdstat("playerstatslist", "wins", "statValue");
	startlosses = self getdstat("playerstatslist", "losses", "statValue");
	starthits = self getdstat("playerstatslist", "hits", "statValue");
	startmisses = self getdstat("playerstatslist", "misses", "statValue");
	starttimeplayedtotal = self getdstat("playerstatslist", "time_played_total", "statValue");
	startscore = self getdstat("playerstatslist", "score", "statValue");
	startprestige = self getdstat("playerstatslist", "plevel", "statValue");
	startunlockpoints = self getdstat("unlocks", 0);
	ties = self getdstat("playerstatslist", "ties", "statValue");
	startgamesplayed = (startwins + startlosses) + ties;
	self.startkills = startkills;
	self.starthits = starthits;
	self.totalmatchshots = 0;
	recordplayerstats(self, "startKills", startkills);
	recordplayerstats(self, "startDeaths", startdeaths);
	recordplayerstats(self, "startWins", startwins);
	recordplayerstats(self, "startLosses", startlosses);
	recordplayerstats(self, "startHits", starthits);
	recordplayerstats(self, "startMisses", startmisses);
	recordplayerstats(self, "startTimePlayedTotal", starttimeplayedtotal);
	recordplayerstats(self, "startScore", startscore);
	recordplayerstats(self, "startPrestige", startprestige);
	recordplayerstats(self, "startUnlockPoints", startunlockpoints);
	recordplayerstats(self, "startGamesPlayed", startgamesplayed);
	lootxpbeforematch = self getdstat("AfterActionReportStats", "lootXPBeforeMatch");
	cryptokeysbeforematch = self getdstat("AfterActionReportStats", "cryptoKeysBeforeMatch");
	recordplayerstats(self, "lootXPBeforeMatch", lootxpbeforematch);
	recordplayerstats(self, "cryptoKeysBeforeMatch", cryptokeysbeforematch);
}

/*
	Name: record_global_mp_stats_for_player_at_match_end
	Namespace: globallogic_player
	Checksum: 0x2DF1BDDB
	Offset: 0x66D8
	Size: 0x3F4
	Parameters: 0
	Flags: Linked
*/
function record_global_mp_stats_for_player_at_match_end()
{
	if(isdefined(level.disablestattracking) && level.disablestattracking == 1)
	{
		return;
	}
	endkills = self getdstat("playerstatslist", "kills", "statValue");
	enddeaths = self getdstat("playerstatslist", "deaths", "statValue");
	endwins = self getdstat("playerstatslist", "wins", "statValue");
	endlosses = self getdstat("playerstatslist", "losses", "statValue");
	endhits = self getdstat("playerstatslist", "hits", "statValue");
	endmisses = self getdstat("playerstatslist", "misses", "statValue");
	endtimeplayedtotal = self getdstat("playerstatslist", "time_played_total", "statValue");
	endscore = self getdstat("playerstatslist", "score", "statValue");
	endprestige = self getdstat("playerstatslist", "plevel", "statValue");
	endunlockpoints = self getdstat("unlocks", 0);
	ties = self getdstat("playerstatslist", "ties", "statValue");
	endgamesplayed = (endwins + endlosses) + ties;
	recordplayerstats(self, "endKills", endkills);
	recordplayerstats(self, "endDeaths", enddeaths);
	recordplayerstats(self, "endWins", endwins);
	recordplayerstats(self, "endLosses", endlosses);
	recordplayerstats(self, "endHits", endhits);
	recordplayerstats(self, "endMisses", endmisses);
	recordplayerstats(self, "endTimePlayedTotal", endtimeplayedtotal);
	recordplayerstats(self, "endScore", endscore);
	recordplayerstats(self, "endPrestige", endprestige);
	recordplayerstats(self, "endUnlockPoints", endunlockpoints);
	recordplayerstats(self, "endGamesPlayed", endgamesplayed);
}

/*
	Name: record_misc_player_stats
	Namespace: globallogic_player
	Checksum: 0x966CE09F
	Offset: 0x6AD8
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function record_misc_player_stats()
{
	if(isdefined(level.disablestattracking) && level.disablestattracking == 1)
	{
		return;
	}
	recordplayerstats(self, "UTCEndTimeSeconds", getutc());
	if(isdefined(self.weaponpickupscount))
	{
		recordplayerstats(self, "weaponPickupsCount", self.weaponpickupscount);
	}
	if(isdefined(self.killcamsskipped))
	{
		recordplayerstats(self, "totalKillcamsSkipped", self.killcamsskipped);
	}
	if(isdefined(self.matchbonus))
	{
		recordplayerstats(self, "matchXp", self.matchbonus);
	}
	if(isdefined(self.killsdenied))
	{
		recordplayerstats(self, "killsDenied", self.killsdenied);
	}
	if(isdefined(self.killsconfirmed))
	{
		recordplayerstats(self, "killsConfirmed", self.killsconfirmed);
	}
	if(self issplitscreen())
	{
		recordplayerstats(self, "isSplitscreen", 1);
	}
	if(self.objtime)
	{
		recordplayerstats(self, "objectiveTime", self.objtime);
	}
	if(self.escorts)
	{
		recordplayerstats(self, "escortTime", self.escorts);
	}
}

/*
	Name: spectate_player_watcher
	Namespace: globallogic_player
	Checksum: 0xA9B6F402
	Offset: 0x6CB8
	Size: 0x274
	Parameters: 0
	Flags: Linked
*/
function spectate_player_watcher()
{
	self endon(#"disconnect");
	if(!level.splitscreen && !level.hardcoremode && getdvarint("scr_showperksonspawn") == 1 && game["state"] != "postgame" && !isdefined(self.perkhudelem))
	{
		if(level.perksenabled == 1)
		{
			self hud::showperks();
		}
	}
	self.watchingactiveclient = 1;
	self.waitingforplayerstext = undefined;
	while(true)
	{
		if(self.pers["team"] != "spectator" || level.gameended)
		{
			self hud_message::clearshoutcasterwaitingmessage();
			if(!(isdefined(level.inprematchperiod) && level.inprematchperiod))
			{
				self freezecontrols(0);
			}
			self.watchingactiveclient = 0;
			break;
		}
		else
		{
			count = 0;
			for(i = 0; i < level.players.size; i++)
			{
				if(level.players[i].team != "spectator")
				{
					count++;
					break;
				}
			}
			if(count > 0)
			{
				if(!self.watchingactiveclient)
				{
					self hud_message::clearshoutcasterwaitingmessage();
					self freezecontrols(0);
					self luinotifyevent(&"player_spawned", 0);
				}
				self.watchingactiveclient = 1;
			}
			else
			{
				if(self.watchingactiveclient)
				{
					[[level.onspawnspectator]]();
					self freezecontrols(1);
					self hud_message::setshoutcasterwaitingmessage();
				}
				self.watchingactiveclient = 0;
			}
			wait(0.5);
		}
	}
}

/*
	Name: callback_playermigrated
	Namespace: globallogic_player
	Checksum: 0xF6E6B200
	Offset: 0x6F38
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function callback_playermigrated()
{
	/#
		println((("" + self.name) + "") + gettime());
	#/
	if(isdefined(self.connected) && self.connected)
	{
		self globallogic_ui::updateobjectivetext();
	}
	level.hostmigrationreturnedplayercount++;
	if(level.hostmigrationreturnedplayercount >= ((level.players.size * 2) / 3))
	{
		/#
			println("");
		#/
		level notify(#"hostmigration_enoughplayers");
	}
}

/*
	Name: callback_playerdisconnect
	Namespace: globallogic_player
	Checksum: 0x8FD86A50
	Offset: 0x7000
	Size: 0x73C
	Parameters: 0
	Flags: Linked
*/
function callback_playerdisconnect()
{
	profilelog_begintiming(5, "ship");
	if(game["state"] != "postgame" && !level.gameended)
	{
		gamelength = game["timepassed"];
		self globallogic::bbplayermatchend(gamelength, "MP_PLAYER_DISCONNECT", 0);
		if(util::isroundbased())
		{
			recordplayerstats(self, "playerQuitRoundNumber", game["roundsplayed"] + 1);
		}
		if(level.teambased)
		{
			ourteam = self.team;
			if(ourteam == "allies" || ourteam == "axis")
			{
				theirteam = "";
				if(ourteam == "allies")
				{
					theirteam = "axis";
				}
				else if(ourteam == "axis")
				{
					theirteam = "allies";
				}
				recordplayerstats(self, "playerQuitTeamScore", getteamscore(ourteam));
				recordplayerstats(self, "playerQuitOpposingTeamScore", getteamscore(theirteam));
			}
		}
		recordendgamecomscoreeventforplayer(self, "disconnect");
	}
	self behaviortracker::finalize();
	arrayremovevalue(level.players, self);
	if(level.splitscreen)
	{
		players = level.players;
		if(players.size <= 1)
		{
			level thread globallogic::forceend();
		}
		setdvar("splitscreen_playerNum", players.size);
	}
	if(isdefined(self.score) && isdefined(self.pers["team"]))
	{
		/#
			print((("" + self.pers[""]) + "") + self.score);
		#/
		level.dropteam = level.dropteam + 1;
	}
	[[level.onplayerdisconnect]]();
	lpselfnum = self getentitynumber();
	lpguid = self getguid();
	/#
		logprint(((((("" + lpguid) + "") + lpselfnum) + "") + self.name) + "");
	#/
	self record_global_mp_stats_for_player_at_match_end();
	self record_special_move_data_for_life(undefined);
	self record_misc_player_stats();
	self gamerep::gamerepplayerdisconnected();
	for(entry = 0; entry < level.players.size; entry++)
	{
		if(level.players[entry] == self)
		{
			while(entry < (level.players.size - 1))
			{
				level.players[entry] = level.players[entry + 1];
				entry++;
			}
			level.players[entry] = undefined;
			break;
		}
	}
	for(entry = 0; entry < level.players.size; entry++)
	{
		if(isdefined(level.players[entry].pers["killed_players"][self.name]))
		{
			level.players[entry].pers["killed_players"][self.name] = undefined;
		}
		if(isdefined(level.players[entry].pers["killed_players_with_specialist"][self.name]))
		{
			level.players[entry].pers["killed_players_with_specialist"][self.name] = undefined;
		}
		if(isdefined(level.players[entry].killedplayerscurrent[self.name]))
		{
			level.players[entry].killedplayerscurrent[self.name] = undefined;
		}
		if(isdefined(level.players[entry].pers["killed_by"][self.name]))
		{
			level.players[entry].pers["killed_by"][self.name] = undefined;
		}
		if(isdefined(level.players[entry].pers["nemesis_tracking"][self.name]))
		{
			level.players[entry].pers["nemesis_tracking"][self.name] = undefined;
		}
		if(level.players[entry].pers["nemesis_name"] == self.name)
		{
			level.players[entry] choosenextbestnemesis();
		}
	}
	if(level.gameended)
	{
		self globallogic::removedisconnectedplayerfromplacement();
	}
	level thread globallogic::updateteamstatus();
	level thread globallogic::updateallalivetimes();
	profilelog_endtiming(5, (("gs=" + game["state"]) + " zom=") + sessionmodeiszombiesgame());
}

/*
	Name: callback_playermelee
	Namespace: globallogic_player
	Checksum: 0x228F0E6E
	Offset: 0x7748
	Size: 0xC4
	Parameters: 8
	Flags: Linked
*/
function callback_playermelee(eattacker, idamage, weapon, vorigin, vdir, boneindex, shieldhit, frombehind)
{
	hit = 1;
	if(level.teambased && self.team == eattacker.team)
	{
		if(level.friendlyfire == 0)
		{
			hit = 0;
		}
	}
	self finishmeleehit(eattacker, weapon, vorigin, vdir, boneindex, shieldhit, hit, frombehind);
}

/*
	Name: choosenextbestnemesis
	Namespace: globallogic_player
	Checksum: 0xCC2C735A
	Offset: 0x7818
	Size: 0x242
	Parameters: 0
	Flags: Linked
*/
function choosenextbestnemesis()
{
	nemesisarray = self.pers["nemesis_tracking"];
	nemesisarraykeys = getarraykeys(nemesisarray);
	nemesisamount = 0;
	nemesisname = "";
	if(nemesisarraykeys.size > 0)
	{
		for(i = 0; i < nemesisarraykeys.size; i++)
		{
			nemesisarraykey = nemesisarraykeys[i];
			if(nemesisarray[nemesisarraykey] > nemesisamount)
			{
				nemesisname = nemesisarraykey;
				nemesisamount = nemesisarray[nemesisarraykey];
			}
		}
	}
	self.pers["nemesis_name"] = nemesisname;
	if(nemesisname != "")
	{
		for(playerindex = 0; playerindex < level.players.size; playerindex++)
		{
			if(level.players[playerindex].name == nemesisname)
			{
				nemesisplayer = level.players[playerindex];
				self.pers["nemesis_rank"] = nemesisplayer.pers["rank"];
				self.pers["nemesis_rankIcon"] = nemesisplayer.pers["rankxp"];
				self.pers["nemesis_xp"] = nemesisplayer.pers["prestige"];
				self.pers["nemesis_xuid"] = nemesisplayer getxuid();
				break;
			}
		}
	}
	else
	{
		self.pers["nemesis_xuid"] = "";
	}
}

/*
	Name: custom_gamemodes_modified_damage
	Namespace: globallogic_player
	Checksum: 0x85B87834
	Offset: 0x7A68
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function custom_gamemodes_modified_damage(victim, eattacker, idamage, smeansofdeath, weapon, einflictor, shitloc)
{
	if(level.onlinegame && !sessionmodeisprivate())
	{
		return idamage;
	}
	if(isdefined(eattacker) && isdefined(eattacker.damagemodifier))
	{
		idamage = idamage * eattacker.damagemodifier;
	}
	if(smeansofdeath == "MOD_PISTOL_BULLET" || smeansofdeath == "MOD_RIFLE_BULLET")
	{
		idamage = int(idamage * level.bulletdamagescalar);
	}
	return idamage;
}

/*
	Name: figure_out_attacker
	Namespace: globallogic_player
	Checksum: 0xA76C6D2C
	Offset: 0x7B60
	Size: 0x160
	Parameters: 1
	Flags: Linked
*/
function figure_out_attacker(eattacker)
{
	if(isdefined(eattacker))
	{
		if(isai(eattacker) && isdefined(eattacker.script_owner))
		{
			team = self.team;
			if(eattacker.script_owner.team != team)
			{
				eattacker = eattacker.script_owner;
			}
		}
		if(eattacker.classname == "script_vehicle" && isdefined(eattacker.owner))
		{
			eattacker = eattacker.owner;
		}
		else
		{
			if(eattacker.classname == "auto_turret" && isdefined(eattacker.owner))
			{
				eattacker = eattacker.owner;
			}
			else if(eattacker.classname == "actor_spawner_bo3_robot_grunt_assault_mp" && isdefined(eattacker.owner))
			{
				eattacker = eattacker.owner;
			}
		}
	}
	return eattacker;
}

/*
	Name: player_damage_figure_out_weapon
	Namespace: globallogic_player
	Checksum: 0x27357D6D
	Offset: 0x7CC8
	Size: 0x174
	Parameters: 2
	Flags: Linked
*/
function player_damage_figure_out_weapon(weapon, einflictor)
{
	if(weapon == level.weaponnone && isdefined(einflictor))
	{
		if(isdefined(einflictor.targetname) && einflictor.targetname == "explodable_barrel")
		{
			weapon = getweapon("explodable_barrel");
		}
		else
		{
			if(isdefined(einflictor.destructible_type) && issubstr(einflictor.destructible_type, "vehicle_"))
			{
				weapon = getweapon("destructible_car");
			}
			else if(isdefined(einflictor.scriptvehicletype))
			{
				veh_weapon = getweapon(einflictor.scriptvehicletype);
				if(isdefined(veh_weapon))
				{
					weapon = veh_weapon;
				}
			}
		}
	}
	if(isdefined(einflictor) && isdefined(einflictor.script_noteworthy))
	{
		if(isdefined(level.overrideweaponfunc))
		{
			weapon = [[level.overrideweaponfunc]](weapon, einflictor.script_noteworthy);
		}
	}
	return weapon;
}

/*
	Name: figure_out_friendly_fire
	Namespace: globallogic_player
	Checksum: 0xBA49235D
	Offset: 0x7E48
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function figure_out_friendly_fire(victim)
{
	if(level.hardcoremode && level.friendlyfire > 0 && isdefined(victim) && victim.is_capturing_own_supply_drop === 1)
	{
		return 2;
	}
	if(killstreaks::is_ricochet_protected(victim))
	{
		return 2;
	}
	if(isdefined(level.figure_out_gametype_friendly_fire))
	{
		return [[level.figure_out_gametype_friendly_fire]](victim);
	}
	return level.friendlyfire;
}

/*
	Name: isplayerimmunetokillstreak
	Namespace: globallogic_player
	Checksum: 0x8EE28525
	Offset: 0x7EE8
	Size: 0x4E
	Parameters: 2
	Flags: Linked
*/
function isplayerimmunetokillstreak(eattacker, weapon)
{
	if(level.hardcoremode)
	{
		return 0;
	}
	if(!isdefined(eattacker))
	{
		return 0;
	}
	if(self != eattacker)
	{
		return 0;
	}
	return weapon.donotdamageowner;
}

/*
	Name: should_do_player_damage
	Namespace: globallogic_player
	Checksum: 0xA08460DE
	Offset: 0x7F40
	Size: 0x196
	Parameters: 4
	Flags: Linked
*/
function should_do_player_damage(eattacker, weapon, smeansofdeath, idflags)
{
	if(game["state"] == "postgame")
	{
		return false;
	}
	if(self.sessionteam == "spectator")
	{
		return false;
	}
	if(isdefined(self.candocombat) && !self.candocombat)
	{
		return false;
	}
	if(isdefined(eattacker) && isplayer(eattacker) && isdefined(eattacker.candocombat) && !eattacker.candocombat)
	{
		return false;
	}
	if(isdefined(level.hostmigrationtimer))
	{
		return false;
	}
	if(level.onlyheadshots)
	{
		if(smeansofdeath == "MOD_PISTOL_BULLET" || smeansofdeath == "MOD_RIFLE_BULLET")
		{
			return false;
		}
	}
	if(self vehicle::player_is_occupant_invulnerable(smeansofdeath))
	{
		return false;
	}
	if(weapon.issupplydropweapon && !weapon.isgrenadeweapon && smeansofdeath != "MOD_TRIGGER_HURT")
	{
		return false;
	}
	if(self.scene_takedamage === 0)
	{
		return false;
	}
	if(idflags & 8 && self player::is_spawn_protected())
	{
		return false;
	}
	return true;
}

/*
	Name: apply_damage_to_armor
	Namespace: globallogic_player
	Checksum: 0xBB182FE
	Offset: 0x80E0
	Size: 0x210
	Parameters: 8
	Flags: Linked
*/
function apply_damage_to_armor(einflictor, eattacker, idamage, smeansofdeath, weapon, shitloc, friendlyfire, ignore_round_start_friendly_fire)
{
	victim = self;
	if(friendlyfire && !player_damage_does_friendly_fire_damage_victim(ignore_round_start_friendly_fire))
	{
		return idamage;
	}
	if(isdefined(victim.lightarmorhp))
	{
		if(weapon.ignoreslightarmor && smeansofdeath != "MOD_MELEE")
		{
			return idamage;
		}
		if(weapon.meleeignoreslightarmor && smeansofdeath == "MOD_MELEE")
		{
			return idamage;
		}
		if(isdefined(einflictor) && isdefined(einflictor.stucktoplayer) && einflictor.stucktoplayer == victim)
		{
			idamage = victim.health;
		}
		else if(smeansofdeath != "MOD_FALLING" && !weapon_utils::ismeleemod(smeansofdeath) && !globallogic_utils::isheadshot(weapon, shitloc, smeansofdeath, eattacker))
		{
			victim armor::setlightarmorhp(victim.lightarmorhp - idamage);
			idamage = 0;
			if(victim.lightarmorhp <= 0)
			{
				idamage = abs(victim.lightarmorhp);
				armor::unsetlightarmor();
			}
		}
	}
	return idamage;
}

/*
	Name: make_sure_damage_is_not_zero
	Namespace: globallogic_player
	Checksum: 0xBE6F0525
	Offset: 0x82F8
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function make_sure_damage_is_not_zero(idamage)
{
	if(idamage < 1)
	{
		if(self ability_util::gadget_power_armor_on() && isdefined(self.maxhealth) && self.health < self.maxhealth)
		{
			self.health = self.health + 1;
		}
		idamage = 1;
	}
	return int(idamage);
}

/*
	Name: modify_player_damage_friendlyfire
	Namespace: globallogic_player
	Checksum: 0xCFEB1E82
	Offset: 0x8388
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function modify_player_damage_friendlyfire(idamage)
{
	friendlyfire = [[level.figure_out_friendly_fire]](self);
	if(friendlyfire == 2 || friendlyfire == 3)
	{
		idamage = int(idamage * 0.5);
	}
	return idamage;
}

/*
	Name: modify_player_damage
	Namespace: globallogic_player
	Checksum: 0xBB932040
	Offset: 0x8400
	Size: 0x342
	Parameters: 11
	Flags: Linked
*/
function modify_player_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	if(isdefined(self.overrideplayerdamage))
	{
		idamage = self [[self.overrideplayerdamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex);
	}
	else if(isdefined(level.overrideplayerdamage))
	{
		idamage = self [[level.overrideplayerdamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex);
	}
	/#
		assert(isdefined(idamage), "");
	#/
	if(isdefined(eattacker))
	{
		idamage = loadout::cac_modified_damage(self, eattacker, idamage, smeansofdeath, weapon, einflictor, shitloc);
		if(isdefined(eattacker.pickup_damage_scale) && eattacker.pickup_damage_scale_time > gettime())
		{
			idamage = idamage * eattacker.pickup_damage_scale;
		}
	}
	idamage = custom_gamemodes_modified_damage(self, eattacker, idamage, smeansofdeath, weapon, einflictor, shitloc);
	if(level.onplayerdamage != (&globallogic::blank))
	{
		modifieddamage = [[level.onplayerdamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime);
		if(isdefined(modifieddamage))
		{
			if(modifieddamage <= 0)
			{
				return;
			}
			idamage = modifieddamage;
		}
	}
	if(level.onlyheadshots)
	{
		if(smeansofdeath == "MOD_HEAD_SHOT")
		{
			idamage = 150;
		}
	}
	if(weapon.damagealwayskillsplayer)
	{
		idamage = self.maxhealth + 1;
	}
	if(shitloc == "riotshield")
	{
		if(idflags & 32)
		{
			if(!idflags & 64)
			{
				idamage = idamage * 0;
			}
		}
		else if(idflags & 128)
		{
			if(isdefined(einflictor) && isdefined(einflictor.stucktoplayer) && einflictor.stucktoplayer == self)
			{
				idamage = self.maxhealth + 1;
			}
		}
	}
	return int(idamage);
}

/*
	Name: modify_player_damage_meansofdeath
	Namespace: globallogic_player
	Checksum: 0xB6320344
	Offset: 0x8750
	Size: 0xD4
	Parameters: 5
	Flags: Linked
*/
function modify_player_damage_meansofdeath(einflictor, eattacker, smeansofdeath, weapon, shitloc)
{
	if(globallogic_utils::isheadshot(weapon, shitloc, smeansofdeath, einflictor) && isplayer(eattacker) && !weapon_utils::ismeleemod(smeansofdeath))
	{
		smeansofdeath = "MOD_HEAD_SHOT";
	}
	if(isdefined(einflictor) && isdefined(einflictor.script_noteworthy))
	{
		if(einflictor.script_noteworthy == "ragdoll_now")
		{
			smeansofdeath = "MOD_FALLING";
		}
	}
	return smeansofdeath;
}

/*
	Name: player_damage_update_attacker
	Namespace: globallogic_player
	Checksum: 0x31FE0B0E
	Offset: 0x8830
	Size: 0xBE
	Parameters: 3
	Flags: Linked
*/
function player_damage_update_attacker(einflictor, eattacker, smeansofdeath)
{
	if(isdefined(einflictor) && isplayer(eattacker) && eattacker == einflictor)
	{
		if(smeansofdeath == "MOD_HEAD_SHOT" || smeansofdeath == "MOD_PISTOL_BULLET" || smeansofdeath == "MOD_RIFLE_BULLET")
		{
			eattacker.hits++;
		}
	}
	if(isplayer(eattacker))
	{
		eattacker.pers["participation"]++;
	}
}

/*
	Name: player_is_spawn_protected_from_explosive
	Namespace: globallogic_player
	Checksum: 0xE2497BF9
	Offset: 0x88F8
	Size: 0x146
	Parameters: 3
	Flags: Linked
*/
function player_is_spawn_protected_from_explosive(einflictor, weapon, smeansofdeath)
{
	if(!self player::is_spawn_protected())
	{
		return false;
	}
	if(weapon.explosionradius == 0)
	{
		return false;
	}
	distsqr = (isdefined(self.lastspawnpoint) ? distancesquared(einflictor.origin, self.lastspawnpoint.origin) : 0);
	if(distsqr < (250 * 250))
	{
		if(smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH")
		{
			return true;
		}
		if(smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_PROJECTILE_SPLASH")
		{
			return true;
		}
		if(smeansofdeath == "MOD_EXPLOSIVE")
		{
			return true;
		}
	}
	if(killstreaks::is_killstreak_weapon(weapon))
	{
		return true;
	}
	return false;
}

/*
	Name: player_damage_update_explosive_info
	Namespace: globallogic_player
	Checksum: 0x2AC4FF93
	Offset: 0x8A48
	Size: 0x5A6
	Parameters: 11
	Flags: Linked
*/
function player_damage_update_explosive_info(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	is_explosive_damage = loadout::isexplosivedamage(smeansofdeath);
	if(is_explosive_damage)
	{
		if(self player_is_spawn_protected_from_explosive(einflictor, weapon, smeansofdeath))
		{
			return false;
		}
		if(self isplayerimmunetokillstreak(eattacker, weapon))
		{
			return false;
		}
	}
	if(isdefined(einflictor) && (smeansofdeath == "MOD_GAS" || is_explosive_damage))
	{
		self.explosiveinfo = [];
		self.explosiveinfo["damageTime"] = gettime();
		self.explosiveinfo["damageId"] = einflictor getentitynumber();
		self.explosiveinfo["originalOwnerKill"] = 0;
		self.explosiveinfo["bulletPenetrationKill"] = 0;
		self.explosiveinfo["chainKill"] = 0;
		self.explosiveinfo["damageExplosiveKill"] = 0;
		self.explosiveinfo["chainKill"] = 0;
		self.explosiveinfo["cookedKill"] = 0;
		self.explosiveinfo["weapon"] = weapon;
		self.explosiveinfo["originalowner"] = einflictor.originalowner;
		isfrag = weapon.rootweapon.name == "frag_grenade";
		if(isdefined(eattacker) && eattacker != self)
		{
			if(isdefined(eattacker) && isdefined(einflictor.owner) && (weapon.name == "satchel_charge" || weapon.name == "claymore" || weapon.name == "bouncingbetty"))
			{
				self.explosiveinfo["originalOwnerKill"] = einflictor.owner == self;
				self.explosiveinfo["damageExplosiveKill"] = isdefined(einflictor.wasdamaged);
				self.explosiveinfo["chainKill"] = isdefined(einflictor.waschained);
				self.explosiveinfo["wasJustPlanted"] = isdefined(einflictor.wasjustplanted);
				self.explosiveinfo["bulletPenetrationKill"] = isdefined(einflictor.wasdamagedfrombulletpenetration);
				self.explosiveinfo["cookedKill"] = 0;
			}
			if(isdefined(einflictor) && isdefined(einflictor.stucktoplayer) && weapon.projexplosiontype == "grenade")
			{
				self.explosiveinfo["stuckToPlayer"] = einflictor.stucktoplayer;
			}
			if(weapon.dostun)
			{
				self.laststunnedby = eattacker;
				self.laststunnedtime = self.idflagstime;
			}
			if(isdefined(eattacker.lastgrenadesuicidetime) && eattacker.lastgrenadesuicidetime >= (gettime() - 50) && isfrag)
			{
				self.explosiveinfo["suicideGrenadeKill"] = 1;
			}
			else
			{
				self.explosiveinfo["suicideGrenadeKill"] = 0;
			}
		}
		if(isfrag)
		{
			self.explosiveinfo["cookedKill"] = isdefined(einflictor.iscooked);
			self.explosiveinfo["throwbackKill"] = isdefined(einflictor.threwback);
		}
		if(isdefined(eattacker) && isplayer(eattacker) && eattacker != self)
		{
			self globallogic_score::setinflictorstat(einflictor, eattacker, weapon);
		}
	}
	if(smeansofdeath == "MOD_IMPACT" && isdefined(eattacker) && isplayer(eattacker) && eattacker != self)
	{
		if(weapon != level.weaponballisticknife)
		{
			self globallogic_score::setinflictorstat(einflictor, eattacker, weapon);
		}
		if(weapon.rootweapon.name == "hatchet" && isdefined(einflictor))
		{
			self.explosiveinfo["projectile_bounced"] = isdefined(einflictor.bounced);
		}
	}
	return true;
}

/*
	Name: player_damage_is_friendly_fire_at_round_start
	Namespace: globallogic_player
	Checksum: 0x9D97334F
	Offset: 0x8FF8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function player_damage_is_friendly_fire_at_round_start()
{
	if(level.friendlyfiredelay && level.friendlyfiredelaytime >= (((gettime() - level.starttime) - level.discardtime) / 1000))
	{
		return true;
	}
	return false;
}

/*
	Name: player_damage_does_friendly_fire_damage_attacker
	Namespace: globallogic_player
	Checksum: 0x97E2BAFE
	Offset: 0x9040
	Size: 0xB2
	Parameters: 2
	Flags: Linked
*/
function player_damage_does_friendly_fire_damage_attacker(eattacker, ignore_round_start_friendly_fire)
{
	if(!isalive(eattacker))
	{
		return false;
	}
	friendlyfire = [[level.figure_out_friendly_fire]](self);
	if(friendlyfire == 1)
	{
		if(player_damage_is_friendly_fire_at_round_start() && ignore_round_start_friendly_fire == 0)
		{
			return true;
		}
	}
	if(friendlyfire == 2)
	{
		return true;
	}
	if(friendlyfire == 3)
	{
		return true;
	}
	return false;
}

/*
	Name: player_damage_does_friendly_fire_damage_victim
	Namespace: globallogic_player
	Checksum: 0x6053B5BB
	Offset: 0x9100
	Size: 0x7A
	Parameters: 1
	Flags: Linked
*/
function player_damage_does_friendly_fire_damage_victim(ignore_round_start_friendly_fire)
{
	friendlyfire = [[level.figure_out_friendly_fire]](self);
	if(friendlyfire == 1)
	{
		if(player_damage_is_friendly_fire_at_round_start() && ignore_round_start_friendly_fire == 0)
		{
			return false;
		}
		return true;
	}
	if(friendlyfire == 3)
	{
		return true;
	}
	return false;
}

/*
	Name: player_damage_riotshield_hit
	Namespace: globallogic_player
	Checksum: 0x1F67A35
	Offset: 0x9188
	Size: 0x19C
	Parameters: 5
	Flags: Linked
*/
function player_damage_riotshield_hit(eattacker, idamage, smeansofdeath, weapon, attackerishittingteammate)
{
	if(smeansofdeath == "MOD_PISTOL_BULLET" || smeansofdeath == "MOD_RIFLE_BULLET" && !killstreaks::is_killstreak_weapon(weapon) && !attackerishittingteammate)
	{
		if(self.hasriotshieldequipped)
		{
			if(isplayer(eattacker))
			{
				eattacker.lastattackedshieldplayer = self;
				eattacker.lastattackedshieldtime = gettime();
			}
			previous_shield_damage = self.shielddamageblocked;
			self.shielddamageblocked = self.shielddamageblocked + idamage;
			if((self.shielddamageblocked % 400) < (previous_shield_damage % 400))
			{
				score_event = "shield_blocked_damage";
				if(self.shielddamageblocked > 2000)
				{
					score_event = "shield_blocked_damage_reduced";
				}
				if(isdefined(level.scoreinfo[score_event]["value"]))
				{
					self addweaponstat(level.weaponriotshield, "score_from_blocked_damage", level.scoreinfo[score_event]["value"]);
				}
				scoreevents::processscoreevent(score_event, self);
			}
		}
	}
}

/*
	Name: does_player_completely_avoid_damage
	Namespace: globallogic_player
	Checksum: 0x99745533
	Offset: 0x9330
	Size: 0x112
	Parameters: 6
	Flags: Linked
*/
function does_player_completely_avoid_damage(idflags, shitloc, weapon, friendlyfire, attackerishittingself, smeansofdeath)
{
	if(idflags & 2048)
	{
		return true;
	}
	if(friendlyfire && level.friendlyfire == 0)
	{
		return true;
	}
	if(shitloc == "riotshield")
	{
		if(!idflags & 160)
		{
			return true;
		}
	}
	if(weapon.isemp && smeansofdeath == "MOD_GRENADE_SPLASH")
	{
		if(self hasperk("specialty_immuneemp"))
		{
			return true;
		}
	}
	if(isdefined(level.var_dc6b46ed) && self [[level.var_dc6b46ed]](idflags, shitloc, weapon, friendlyfire, attackerishittingself, smeansofdeath))
	{
		return true;
	}
	return false;
}

/*
	Name: player_damage_log
	Namespace: globallogic_player
	Checksum: 0x9EDCFE31
	Offset: 0x9450
	Size: 0x494
	Parameters: 11
	Flags: Linked
*/
function player_damage_log(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	pixbeginevent("PlayerDamage log");
	/#
		if(getdvarint(""))
		{
			println(((((((((("" + self getentitynumber()) + "") + self.health) + "") + eattacker.clientid) + "") + isplayer(einflictor) + "") + idamage) + "") + shitloc);
		}
	#/
	if(self.sessionstate != "dead")
	{
		lpselfnum = self getentitynumber();
		lpselfname = self.name;
		lpselfteam = self.team;
		lpselfguid = self getguid();
		lpattackerteam = "";
		lpattackerorigin = (0, 0, 0);
		if(isplayer(eattacker))
		{
			lpattacknum = eattacker getentitynumber();
			lpattackguid = eattacker getguid();
			lpattackname = eattacker.name;
			lpattackerteam = eattacker.team;
			lpattackerorigin = eattacker.origin;
			isusingheropower = 0;
			if(eattacker ability_player::is_using_any_gadget())
			{
				isusingheropower = 1;
			}
			bbprint("mpattacks", "gametime %d attackerspawnid %d attackerweapon %s attackerx %d attackery %d attackerz %d victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d isusingheropower %d", gettime(), getplayerspawnid(eattacker), weapon.name, lpattackerorigin, getplayerspawnid(self), self.origin, idamage, smeansofdeath, shitloc, 0, isusingheropower);
		}
		else
		{
			lpattacknum = -1;
			lpattackguid = "";
			lpattackname = "";
			lpattackerteam = "world";
			bbprint("mpattacks", "gametime %d attackerweapon %s victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d isusingheropower %d", gettime(), weapon.name, getplayerspawnid(self), self.origin, idamage, smeansofdeath, shitloc, 0, 0);
		}
		/#
			logprint(((((((((((((((((((((((("" + lpselfguid) + "") + lpselfnum) + "") + lpselfteam) + "") + lpselfname) + "") + lpattackguid) + "") + lpattacknum) + "") + lpattackerteam) + "") + lpattackname) + "") + weapon.name) + "") + idamage) + "") + smeansofdeath) + "") + shitloc) + "");
		#/
	}
	pixendevent();
}

/*
	Name: should_allow_postgame_damage
	Namespace: globallogic_player
	Checksum: 0x423E32EA
	Offset: 0x98F0
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function should_allow_postgame_damage(smeansofdeath)
{
	if(smeansofdeath == "MOD_TRIGGER_HURT" || smeansofdeath == "MOD_CRUSH")
	{
		return true;
	}
	return false;
}

/*
	Name: do_post_game_damage
	Namespace: globallogic_player
	Checksum: 0x99A011D1
	Offset: 0x9930
	Size: 0xEC
	Parameters: 13
	Flags: Linked
*/
function do_post_game_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, vsurfacenormal)
{
	if(game["state"] != "postgame")
	{
		return;
	}
	if(!should_allow_postgame_damage(smeansofdeath))
	{
		return;
	}
	self finishplayerdamage(einflictor, eattacker, idamage, idflags, "MOD_POST_GAME", weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, vsurfacenormal);
}

/*
	Name: callback_playerdamage
	Namespace: globallogic_player
	Checksum: 0x3B4C5C6E
	Offset: 0x9A28
	Size: 0xBE4
	Parameters: 13
	Flags: Linked
*/
function callback_playerdamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, vsurfacenormal)
{
	profilelog_begintiming(6, "ship");
	do_post_game_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, vsurfacenormal);
	if(smeansofdeath == "MOD_CRUSH" && isdefined(einflictor) && einflictor.deal_no_crush_damage === 1)
	{
		return;
	}
	if(isdefined(einflictor) && einflictor.killstreaktype === "siegebot")
	{
		if(einflictor.team === "neutral")
		{
			return;
		}
	}
	self.idflags = idflags;
	self.idflagstime = gettime();
	if(!isplayer(eattacker) && isdefined(eattacker) && eattacker.owner === self)
	{
		treat_self_damage_as_friendly_fire = eattacker.treat_owner_damage_as_friendly_fire;
	}
	ignore_round_start_friendly_fire = isdefined(einflictor) && smeansofdeath == "MOD_CRUSH" || smeansofdeath == "MOD_HIT_BY_OBJECT";
	eattacker = figure_out_attacker(eattacker);
	if(isplayer(eattacker) && (isdefined(eattacker.laststand) && eattacker.laststand))
	{
		return;
	}
	smeansofdeath = modify_player_damage_meansofdeath(einflictor, eattacker, smeansofdeath, weapon, shitloc);
	if(!self should_do_player_damage(eattacker, weapon, smeansofdeath, idflags))
	{
		return;
	}
	player_damage_update_attacker(einflictor, eattacker, smeansofdeath);
	weapon = player_damage_figure_out_weapon(weapon, einflictor);
	pixbeginevent("PlayerDamage flags/tweaks");
	if(!isdefined(vdir))
	{
		idflags = idflags | 4;
	}
	attackerishittingteammate = isplayer(eattacker) && self util::isenemyplayer(eattacker) == 0;
	attackerishittingself = isplayer(eattacker) && self == eattacker;
	friendlyfire = attackerishittingself && treat_self_damage_as_friendly_fire === 1 || (level.teambased && !attackerishittingself && attackerishittingteammate);
	pixendevent();
	idamage = modify_player_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex);
	if(friendlyfire)
	{
		idamage = modify_player_damage_friendlyfire(idamage);
	}
	if(isdefined(self.power_armor_took_damage) && self.power_armor_took_damage)
	{
		idflags = idflags | 1024;
	}
	if(shitloc == "riotshield")
	{
		player_damage_riotshield_hit(eattacker, idamage, smeansofdeath, weapon, attackerishittingteammate);
	}
	if(self does_player_completely_avoid_damage(idflags, shitloc, weapon, friendlyfire, attackerishittingself, smeansofdeath))
	{
		return;
	}
	self callback::callback(#"hash_ab5ecf6c");
	armor = self armor::getarmor();
	idamage = apply_damage_to_armor(einflictor, eattacker, idamage, smeansofdeath, weapon, shitloc, friendlyfire, ignore_round_start_friendly_fire);
	idamage = make_sure_damage_is_not_zero(idamage);
	armor_damaged = armor != self armor::getarmor();
	if(shitloc == "riotshield")
	{
		shitloc = "none";
	}
	if(!player_damage_update_explosive_info(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex))
	{
		return;
	}
	prevhealthratio = self.health / self.maxhealth;
	if(friendlyfire)
	{
		pixmarker("BEGIN: PlayerDamage player");
		if(player_damage_does_friendly_fire_damage_victim(ignore_round_start_friendly_fire))
		{
			self.lastdamagewasfromenemy = 0;
			self finishplayerdamagewrapper(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, vsurfacenormal);
		}
		else if(weapon.forcedamageshellshockandrumble)
		{
			self damageshellshockandrumble(eattacker, einflictor, weapon, smeansofdeath, idamage);
		}
		if(player_damage_does_friendly_fire_damage_attacker(eattacker, ignore_round_start_friendly_fire))
		{
			eattacker.lastdamagewasfromenemy = 0;
			eattacker.friendlydamage = 1;
			eattacker finishplayerdamagewrapper(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, vsurfacenormal);
			eattacker.friendlydamage = undefined;
		}
		pixmarker("END: PlayerDamage player");
	}
	else
	{
		behaviortracker::updateplayerdamage(eattacker, self, idamage);
		self.lastattackweapon = weapon;
		giveattackerandinflictorownerassist(eattacker, einflictor, idamage, smeansofdeath, weapon);
		if(isdefined(eattacker))
		{
			level.lastlegitimateattacker = eattacker;
		}
		if(smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH" && isdefined(einflictor) && isdefined(einflictor.iscooked))
		{
			self.wascooked = gettime();
		}
		else
		{
			self.wascooked = undefined;
		}
		self.lastdamagewasfromenemy = isdefined(eattacker) && eattacker != self;
		if(self.lastdamagewasfromenemy)
		{
			if(isplayer(eattacker))
			{
				if(isdefined(eattacker.damagedplayers[self.clientid]) == 0)
				{
					eattacker.damagedplayers[self.clientid] = spawnstruct();
				}
				eattacker.damagedplayers[self.clientid].time = gettime();
				eattacker.damagedplayers[self.clientid].entity = self;
			}
		}
		if(isplayer(eattacker) && isdefined(weapon.gadget_type) && weapon.gadget_type == 14)
		{
			if(isdefined(eattacker.heroweaponhits))
			{
				eattacker.heroweaponhits++;
			}
		}
		self finishplayerdamagewrapper(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, vsurfacenormal);
	}
	if(isdefined(eattacker) && !attackerishittingself)
	{
		if(damagefeedback::dodamagefeedback(weapon, einflictor, idamage, smeansofdeath))
		{
			if(idamage > 0 && self.health > 0)
			{
				perkfeedback = doperkfeedback(self, weapon, smeansofdeath, einflictor, armor_damaged);
			}
			eattacker thread damagefeedback::update(smeansofdeath, einflictor, perkfeedback, weapon, self, psoffsettime, shitloc);
		}
	}
	if(!isdefined(eattacker) || !friendlyfire || (isdefined(level.hardcoremode) && level.hardcoremode))
	{
		if(isdefined(level.var_b9fd53a3))
		{
			self [[level.var_b9fd53a3]](smeansofdeath);
		}
		else
		{
			self battlechatter::pain_vox(smeansofdeath);
		}
	}
	self.hasdonecombat = 1;
	if(weapon.isemp && smeansofdeath == "MOD_GRENADE_SPLASH")
	{
		if(!self hasperk("specialty_immuneemp"))
		{
			self notify(#"emp_grenaded", eattacker, vpoint);
		}
	}
	if(isdefined(eattacker) && eattacker != self && !friendlyfire)
	{
		level.usestartspawns = 0;
	}
	player_damage_log(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex);
	profilelog_endtiming(6, (("gs=" + game["state"]) + " zom=") + sessionmodeiszombiesgame());
}

/*
	Name: resetattackerlist
	Namespace: globallogic_player
	Checksum: 0x7B0F50DC
	Offset: 0xA618
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function resetattackerlist()
{
	self.attackers = [];
	self.attackerdata = [];
	self.attackerdamage = [];
	self.firsttimedamaged = 0;
}

/*
	Name: resetattackersthisspawnlist
	Namespace: globallogic_player
	Checksum: 0x90E555E2
	Offset: 0xA658
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function resetattackersthisspawnlist()
{
	self.attackersthisspawn = [];
}

/*
	Name: doperkfeedback
	Namespace: globallogic_player
	Checksum: 0xF1F1EDC3
	Offset: 0xA670
	Size: 0x1A8
	Parameters: 5
	Flags: Linked
*/
function doperkfeedback(player, weapon, smeansofdeath, einflictor, armor_damaged)
{
	perkfeedback = undefined;
	hastacticalmask = loadout::hastacticalmask(player);
	hasflakjacket = player hasperk("specialty_flakjacket");
	isexplosivedamage = loadout::isexplosivedamage(smeansofdeath);
	isflashorstundamage = weapon_utils::isflashorstundamage(weapon, smeansofdeath);
	if(isflashorstundamage && hastacticalmask)
	{
		perkfeedback = "tacticalMask";
	}
	else
	{
		if(player hasperk("specialty_fireproof") && loadout::isfiredamage(weapon, smeansofdeath))
		{
			perkfeedback = "flakjacket";
		}
		else
		{
			if(isexplosivedamage && hasflakjacket && !weapon.ignoresflakjacket && !isaikillstreakdamage(weapon, einflictor))
			{
				perkfeedback = "flakjacket";
			}
			else if(armor_damaged)
			{
				perkfeedback = "armor";
			}
		}
	}
	return perkfeedback;
}

/*
	Name: isaikillstreakdamage
	Namespace: globallogic_player
	Checksum: 0xDF28BA10
	Offset: 0xA820
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function isaikillstreakdamage(weapon, einflictor)
{
	if(weapon.isaikillstreakdamage)
	{
		if(weapon.name != "ai_tank_drone_rocket" || isdefined(einflictor.firedbyai))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: finishplayerdamagewrapper
	Namespace: globallogic_player
	Checksum: 0xC2ADA007
	Offset: 0xA888
	Size: 0x314
	Parameters: 13
	Flags: Linked
*/
function finishplayerdamagewrapper(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, vsurfacenormal)
{
	pixbeginevent("finishPlayerDamageWrapper");
	if(!level.console && idflags & 8 && isplayer(eattacker))
	{
		/#
			println(((((((((("" + self getentitynumber()) + "") + self.health) + "") + eattacker.clientid) + "") + isplayer(einflictor) + "") + idamage) + "") + shitloc);
		#/
		eattacker addplayerstat("penetration_shots", 1);
	}
	if(getdvarstring("scr_csmode") != "")
	{
		self shellshock("damage_mp", 0.2);
	}
	if(isdefined(level.var_9bb11de9))
	{
		self [[level.var_9bb11de9]](eattacker, einflictor, weapon, smeansofdeath, idamage, vpoint);
	}
	else
	{
		self damageshellshockandrumble(eattacker, einflictor, weapon, smeansofdeath, idamage);
	}
	self ability_power::power_loss_event_took_damage(eattacker, einflictor, weapon, smeansofdeath, idamage);
	if(isplayer(eattacker))
	{
		self.lastshotby = eattacker.clientid;
	}
	if(smeansofdeath == "MOD_BURNED")
	{
		self burnplayer::takingburndamage(eattacker, weapon, smeansofdeath);
	}
	self.gadget_was_active_last_damage = self gadgetisactive(0);
	self finishplayerdamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, vsurfacenormal);
	pixendevent();
}

/*
	Name: allowedassistweapon
	Namespace: globallogic_player
	Checksum: 0xB4416E86
	Offset: 0xABA8
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function allowedassistweapon(weapon)
{
	if(!killstreaks::is_killstreak_weapon(weapon))
	{
		return true;
	}
	if(killstreaks::is_killstreak_weapon_assist_allowed(weapon))
	{
		return true;
	}
	return false;
}

/*
	Name: playerkilled_killstreaks
	Namespace: globallogic_player
	Checksum: 0x48D6BA19
	Offset: 0xAC00
	Size: 0x340
	Parameters: 2
	Flags: Linked
*/
function playerkilled_killstreaks(attacker, weapon)
{
	if(!isdefined(self.switching_teams))
	{
		if(isplayer(attacker) && level.teambased && attacker != self && self.team == attacker.team)
		{
			self.pers["cur_kill_streak"] = 0;
			self.pers["cur_total_kill_streak"] = 0;
			self.pers["totalKillstreakCount"] = 0;
			self.pers["killstreaksEarnedThisKillstreak"] = 0;
			self setplayercurrentstreak(0);
		}
		else
		{
			self globallogic_score::incpersstat("deaths", 1, 1, 1);
			self.deaths = self globallogic_score::getpersstat("deaths");
			self updatestatratio("kdratio", "kills", "deaths");
			if(self.pers["cur_kill_streak"] > self.pers["best_kill_streak"])
			{
				self.pers["best_kill_streak"] = self.pers["cur_kill_streak"];
			}
			self.pers["kill_streak_before_death"] = self.pers["cur_kill_streak"];
			self.pers["cur_kill_streak"] = 0;
			self.pers["cur_total_kill_streak"] = 0;
			self.pers["totalKillstreakCount"] = 0;
			self.pers["killstreaksEarnedThisKillstreak"] = 0;
			self setplayercurrentstreak(0);
			self.cur_death_streak++;
			if(self.cur_death_streak > self.death_streak)
			{
				if(level.rankedmatch && !level.disablestattracking)
				{
					self setdstat("HighestStats", "death_streak", self.cur_death_streak);
				}
				self.death_streak = self.cur_death_streak;
			}
			if(self.cur_death_streak >= getdvarint("perk_deathStreakCountRequired"))
			{
				self enabledeathstreak();
			}
		}
	}
	else
	{
		self.pers["totalKillstreakCount"] = 0;
		self.pers["killstreaksEarnedThisKillstreak"] = 0;
	}
	if(!sessionmodeiszombiesgame() && killstreaks::is_killstreak_weapon(weapon))
	{
		level.globalkillstreaksdeathsfrom++;
	}
}

/*
	Name: playerkilled_weaponstats
	Namespace: globallogic_player
	Checksum: 0x683D510B
	Offset: 0xAF48
	Size: 0x4DC
	Parameters: 6
	Flags: Linked
*/
function playerkilled_weaponstats(attacker, weapon, smeansofdeath, wasinlaststand, lastweaponbeforedroppingintolaststand, inflictor)
{
	if(isplayer(attacker) && attacker != self && (!level.teambased || (level.teambased && self.team != attacker.team)))
	{
		attackerweaponpickedup = 0;
		if(isdefined(attacker.pickedupweapons) && isdefined(attacker.pickedupweapons[weapon]))
		{
			attackerweaponpickedup = 1;
		}
		self addweaponstat(weapon, "deaths", 1, self.class_num, attackerweaponpickedup, undefined, self.primaryloadoutgunsmithvariantindex, self.secondaryloadoutgunsmithvariantindex);
		if(wasinlaststand && isdefined(lastweaponbeforedroppingintolaststand))
		{
			victim_weapon = lastweaponbeforedroppingintolaststand;
		}
		else
		{
			victim_weapon = self.lastdroppableweapon;
		}
		if(isdefined(victim_weapon))
		{
			victimweaponpickedup = 0;
			if(isdefined(self.pickedupweapons) && isdefined(self.pickedupweapons[victim_weapon]))
			{
				victimweaponpickedup = 1;
			}
			self addweaponstat(victim_weapon, "deathsDuringUse", 1, self.class_num, victimweaponpickedup, undefined, self.primaryloadoutgunsmithvariantindex, self.secondaryloadoutgunsmithvariantindex);
		}
		recordweaponstatkills = 1;
		if(attacker.isthief === 1 && isdefined(weapon) && weapon.isheroweapon === 1)
		{
			recordweaponstatkills = 0;
		}
		if(smeansofdeath != "MOD_FALLING" && recordweaponstatkills)
		{
			if(weapon.name == "explosive_bolt" && isdefined(inflictor) && isdefined(inflictor.ownerweaponatlaunch) && inflictor.owneradsatlaunch)
			{
				inflictorownerweaponatlaunchpickedup = 0;
				if(isdefined(attacker.pickedupweapons) && isdefined(attacker.pickedupweapons[inflictor.ownerweaponatlaunch]))
				{
					inflictorownerweaponatlaunchpickedup = 1;
				}
				attacker addweaponstat(inflictor.ownerweaponatlaunch, "kills", 1, attacker.class_num, inflictorownerweaponatlaunchpickedup, 1, attacker.primaryloadoutgunsmithvariantindex, attacker.secondaryloadoutgunsmithvariantindex);
			}
			else if(isdefined(attacker) && isdefined(attacker.class_num))
			{
				attacker addweaponstat(weapon, "kills", 1, attacker.class_num, attackerweaponpickedup, undefined, attacker.primaryloadoutgunsmithvariantindex, attacker.secondaryloadoutgunsmithvariantindex);
			}
		}
		if(smeansofdeath == "MOD_HEAD_SHOT")
		{
			attacker addweaponstat(weapon, "headshots", 1, attacker.class_num, attackerweaponpickedup, undefined, attacker.primaryloadoutgunsmithvariantindex, attacker.secondaryloadoutgunsmithvariantindex);
		}
		if(smeansofdeath == "MOD_PROJECTILE" || (smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_IMPACT" && weapon.rootweapon.statindex == level.weaponlauncherex41.statindex))
		{
			attacker addweaponstat(weapon, "direct_hit_kills", 1);
		}
		victimisroulette = self.isroulette === 1;
		if(self ability_player::gadget_checkheroabilitykill(attacker) && !victimisroulette)
		{
			attacker addweaponstat(attacker.heroability, "kills_while_active", 1);
		}
	}
}

/*
	Name: playerkilled_obituary
	Namespace: globallogic_player
	Checksum: 0xE2D0F880
	Offset: 0xB430
	Size: 0x32C
	Parameters: 4
	Flags: Linked
*/
function playerkilled_obituary(attacker, einflictor, weapon, smeansofdeath)
{
	if(!isplayer(attacker) || self util::isenemyplayer(attacker) == 0 || (isdefined(weapon) && killstreaks::is_killstreak_weapon(weapon)))
	{
		level notify(#"reset_obituary_count");
		level.lastobituaryplayercount = 0;
		level.lastobituaryplayer = undefined;
	}
	else
	{
		if(isdefined(level.lastobituaryplayer) && level.lastobituaryplayer == attacker)
		{
			level.lastobituaryplayercount++;
		}
		else
		{
			level notify(#"reset_obituary_count");
			level.lastobituaryplayer = attacker;
			level.lastobituaryplayercount = 1;
		}
		level thread scoreevents::decrementlastobituaryplayercountafterfade();
		if(level.lastobituaryplayercount >= 4)
		{
			level notify(#"reset_obituary_count");
			level.lastobituaryplayercount = 0;
			level.lastobituaryplayer = undefined;
			self thread scoreevents::uninterruptedobitfeedkills(attacker, weapon);
		}
	}
	if(!isplayer(attacker) || (isdefined(weapon) && !killstreaks::is_killstreak_weapon(weapon)))
	{
		behaviortracker::updateplayerkilled(attacker, self);
	}
	overrideentitycamera = killstreaks::should_override_entity_camera_in_demo(attacker, weapon);
	if(isdefined(einflictor) && einflictor.archetype === "robot")
	{
		if(smeansofdeath == "MOD_HIT_BY_OBJECT")
		{
			weapon = getweapon("combat_robot_marker");
		}
		smeansofdeath = "MOD_RIFLE_BULLET";
	}
	if(level.teambased && isdefined(attacker.pers) && self.team == attacker.team && smeansofdeath == "MOD_GRENADE" && level.friendlyfire == 0)
	{
		obituary(self, self, weapon, smeansofdeath);
		demo::bookmark("kill", gettime(), self, self, 0, einflictor, overrideentitycamera);
	}
	else
	{
		obituary(self, attacker, weapon, smeansofdeath);
		demo::bookmark("kill", gettime(), attacker, self, 0, einflictor, overrideentitycamera);
	}
}

/*
	Name: playerkilled_suicide
	Namespace: globallogic_player
	Checksum: 0x43F7B83
	Offset: 0xB768
	Size: 0x378
	Parameters: 5
	Flags: Linked
*/
function playerkilled_suicide(einflictor, attacker, smeansofdeath, weapon, shitloc)
{
	awardassists = 0;
	self.suicide = 0;
	if(isdefined(self.switching_teams))
	{
		if(!level.teambased && (isdefined(level.teams[self.leaving_team]) && isdefined(level.teams[self.joining_team]) && level.teams[self.leaving_team] != level.teams[self.joining_team]))
		{
			playercounts = self teams::count_players();
			playercounts[self.leaving_team]--;
			playercounts[self.joining_team]++;
			if((playercounts[self.joining_team] - playercounts[self.leaving_team]) > 1)
			{
				scoreevents::processscoreevent("suicide", self);
				self thread rank::giverankxp("suicide");
				self globallogic_score::incpersstat("suicides", 1);
				self.suicides = self globallogic_score::getpersstat("suicides");
				self.suicide = 1;
			}
		}
	}
	else
	{
		scoreevents::processscoreevent("suicide", self);
		self globallogic_score::incpersstat("suicides", 1);
		self.suicides = self globallogic_score::getpersstat("suicides");
		if(smeansofdeath == "MOD_SUICIDE" && shitloc == "none" && self.throwinggrenade)
		{
			self.lastgrenadesuicidetime = gettime();
		}
		if(level.maxsuicidesbeforekick > 0 && level.maxsuicidesbeforekick <= self.suicides)
		{
			self notify(#"teamkillkicked");
			self suicidekick();
		}
		thread battlechatter::on_player_suicide_or_team_kill(self, "suicide");
		awardassists = 1;
		self.suicide = 1;
	}
	if(isdefined(self.friendlydamage))
	{
		self iprintln(&"MP_FRIENDLY_FIRE_WILL_NOT");
		if(level.teamkillpointloss)
		{
			scoresub = self [[level.getteamkillscore]](einflictor, attacker, smeansofdeath, weapon);
			score = globallogic_score::_getplayerscore(attacker) - scoresub;
			if(score < 0)
			{
				score = 0;
			}
			globallogic_score::_setplayerscore(attacker, score);
		}
	}
	return awardassists;
}

/*
	Name: playerkilled_teamkill
	Namespace: globallogic_player
	Checksum: 0x50944F1D
	Offset: 0xBAE8
	Size: 0x2F4
	Parameters: 5
	Flags: Linked
*/
function playerkilled_teamkill(einflictor, attacker, smeansofdeath, weapon, shitloc)
{
	scoreevents::processscoreevent("team_kill", attacker);
	self.teamkilled = 1;
	if(!ignoreteamkills(weapon, smeansofdeath, einflictor))
	{
		teamkill_penalty = self [[level.getteamkillpenalty]](einflictor, attacker, smeansofdeath, weapon);
		attacker globallogic_score::incpersstat("teamkills_nostats", teamkill_penalty, 0);
		attacker globallogic_score::incpersstat("teamkills", 1);
		attacker.teamkillsthisround++;
		if(level.teamkillpointloss)
		{
			scoresub = self [[level.getteamkillscore]](einflictor, attacker, smeansofdeath, weapon);
			score = globallogic_score::_getplayerscore(attacker) - scoresub;
			if(score < 0)
			{
				score = 0;
			}
			globallogic_score::_setplayerscore(attacker, score);
		}
		if(globallogic_utils::gettimepassed() < 5000)
		{
			teamkilldelay = 1;
		}
		else
		{
			if(attacker.pers["teamkills_nostats"] > 1 && globallogic_utils::gettimepassed() < (8000 + (attacker.pers["teamkills_nostats"] * 1000)))
			{
				teamkilldelay = 1;
			}
			else
			{
				teamkilldelay = attacker teamkilldelay();
			}
		}
		if(teamkilldelay > 0)
		{
			attacker.teamkillpunish = 1;
			attacker thread wait_and_suicide();
			if(attacker shouldteamkillkick(teamkilldelay))
			{
				attacker notify(#"teamkillkicked");
				attacker thread teamkillkick();
			}
			attacker thread reduceteamkillsovertime();
		}
		if(isplayer(attacker))
		{
			thread battlechatter::on_player_suicide_or_team_kill(attacker, "teamkill");
		}
	}
}

/*
	Name: wait_and_suicide
	Namespace: globallogic_player
	Checksum: 0x5AB96D65
	Offset: 0xBDE8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function wait_and_suicide()
{
	self endon(#"disconnect");
	self util::freeze_player_controls(1);
	wait(0.25);
	self suicide();
}

/*
	Name: playerkilled_awardassists
	Namespace: globallogic_player
	Checksum: 0x65535D5F
	Offset: 0xBE38
	Size: 0x1CC
	Parameters: 4
	Flags: Linked
*/
function playerkilled_awardassists(einflictor, attacker, weapon, lpattackteam)
{
	pixbeginevent("PlayerKilled assists");
	if(isdefined(self.attackers))
	{
		for(j = 0; j < self.attackers.size; j++)
		{
			player = self.attackers[j];
			if(!isdefined(player))
			{
				continue;
			}
			if(player == attacker)
			{
				continue;
			}
			if(player.team != lpattackteam)
			{
				continue;
			}
			damage_done = self.attackerdamage[player.clientid].damage;
			player thread globallogic_score::processassist(self, damage_done, self.attackerdamage[player.clientid].weapon);
		}
	}
	if(level.teambased)
	{
		self globallogic_score::processkillstreakassists(attacker, einflictor, weapon);
	}
	if(isdefined(self.lastattackedshieldplayer) && isdefined(self.lastattackedshieldtime) && self.lastattackedshieldplayer != attacker)
	{
		if((gettime() - self.lastattackedshieldtime) < 4000)
		{
			self.lastattackedshieldplayer thread globallogic_score::processshieldassist(self);
		}
	}
	pixendevent();
}

/*
	Name: playerkilled_kill
	Namespace: globallogic_player
	Checksum: 0xAA601A14
	Offset: 0xC010
	Size: 0x854
	Parameters: 5
	Flags: Linked
*/
function playerkilled_kill(einflictor, attacker, smeansofdeath, weapon, shitloc)
{
	if(!isdefined(killstreaks::get_killstreak_for_weapon(weapon)) || (isdefined(level.killstreaksgivegamescore) && level.killstreaksgivegamescore))
	{
		globallogic_score::inctotalkills(attacker.team);
	}
	if(getdvarint("teamOpsEnabled") == 1)
	{
		if(isdefined(einflictor) && (isdefined(einflictor.teamops) && einflictor.teamops))
		{
			if(!isdefined(killstreaks::get_killstreak_for_weapon(weapon)) || (isdefined(level.killstreaksgivegamescore) && level.killstreaksgivegamescore))
			{
				globallogic_score::giveteamscore("kill", attacker.team, undefined, self);
			}
			return;
		}
	}
	attacker thread globallogic_score::givekillstats(smeansofdeath, weapon, self);
	if(isalive(attacker))
	{
		pixbeginevent("killstreak");
		if(!isdefined(einflictor) || !isdefined(einflictor.requireddeathcount) || attacker.deathcount == einflictor.requireddeathcount)
		{
			shouldgivekillstreak = killstreaks::should_give_killstreak(weapon);
			if(shouldgivekillstreak)
			{
				attacker killstreaks::add_to_killstreak_count(weapon);
			}
			attacker.pers["cur_total_kill_streak"]++;
			attacker setplayercurrentstreak(attacker.pers["cur_total_kill_streak"]);
			if(isdefined(level.killstreaks) && shouldgivekillstreak)
			{
				attacker.pers["cur_kill_streak"]++;
				if(attacker.pers["cur_kill_streak"] >= 2)
				{
					if(attacker.pers["cur_kill_streak"] == 10)
					{
						attacker challenges::killstreakten();
					}
					if(attacker.pers["cur_kill_streak"] <= 30)
					{
						scoreevents::processscoreevent("killstreak_" + attacker.pers["cur_kill_streak"], attacker, self, weapon);
						if(attacker.pers["cur_kill_streak"] == 30)
						{
							attacker challenges::killstreak_30_noscorestreaks();
						}
					}
					else
					{
						scoreevents::processscoreevent("killstreak_more_than_30", attacker, self, weapon);
					}
				}
				if(!isdefined(level.usingmomentum) || !level.usingmomentum)
				{
					if(getdvarint("teamOpsEnabled") == 0)
					{
						attacker thread killstreaks::give_for_streak();
					}
				}
			}
		}
		pixendevent();
	}
	if(attacker.pers["cur_kill_streak"] > attacker.kill_streak)
	{
		if(level.rankedmatch && !level.disablestattracking)
		{
			attacker setdstat("HighestStats", "kill_streak", attacker.pers["totalKillstreakCount"]);
		}
		attacker.kill_streak = attacker.pers["cur_kill_streak"];
	}
	if(attacker.pers["cur_kill_streak"] > attacker.gametype_kill_streak)
	{
		attacker persistence::stat_set_with_gametype("kill_streak", attacker.pers["cur_kill_streak"]);
		attacker.gametype_kill_streak = attacker.pers["cur_kill_streak"];
	}
	killstreak = killstreaks::get_killstreak_for_weapon(weapon);
	if(isdefined(killstreak))
	{
		if(scoreevents::isregisteredevent(killstreak))
		{
			scoreevents::processscoreevent(killstreak, attacker, self, weapon);
		}
		if(isdefined(einflictor) && (killstreak == "dart" || killstreak == "inventory_dart"))
		{
			einflictor notify(#"veh_collision");
		}
	}
	else
	{
		scoreevents::processscoreevent("kill", attacker, self, weapon);
		if(smeansofdeath == "MOD_HEAD_SHOT")
		{
			scoreevents::processscoreevent("headshot", attacker, self, weapon);
			attacker util::player_contract_event("headshot");
		}
		else if(weapon_utils::ismeleemod(smeansofdeath))
		{
			scoreevents::processscoreevent("melee_kill", attacker, self, weapon);
		}
	}
	attacker thread globallogic_score::trackattackerkill(self.name, self.pers["rank"], self.pers["rankxp"], self.pers["prestige"], self getxuid(), weapon);
	attackername = attacker.name;
	self thread globallogic_score::trackattackeedeath(attackername, attacker.pers["rank"], attacker.pers["rankxp"], attacker.pers["prestige"], attacker getxuid());
	self thread medals::setlastkilledby(attacker);
	attacker thread globallogic_score::inckillstreaktracker(weapon);
	if(level.teambased && attacker.team != "spectator")
	{
		if(!isdefined(killstreak) || (isdefined(level.killstreaksgivegamescore) && level.killstreaksgivegamescore))
		{
			globallogic_score::giveteamscore("kill", attacker.team, attacker, self);
		}
	}
	scoresub = level.deathpointloss;
	if(scoresub != 0)
	{
		globallogic_score::_setplayerscore(self, globallogic_score::_getplayerscore(self) - scoresub);
	}
	level thread playkillbattlechatter(attacker, weapon, self, einflictor);
}

/*
	Name: should_allow_postgame_death
	Namespace: globallogic_player
	Checksum: 0x5F5317B7
	Offset: 0xC870
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function should_allow_postgame_death(smeansofdeath)
{
	if(smeansofdeath == "MOD_POST_GAME")
	{
		return true;
	}
	return false;
}

/*
	Name: do_post_game_death
	Namespace: globallogic_player
	Checksum: 0xD2541A45
	Offset: 0xC8A0
	Size: 0x17C
	Parameters: 9
	Flags: Linked
*/
function do_post_game_death(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	if(!should_allow_postgame_death(smeansofdeath))
	{
		return;
	}
	self weapons::detach_carry_object_model();
	self.sessionstate = "dead";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	clone_weapon = weapon;
	if(weapon_utils::ismeleemod(smeansofdeath) && clone_weapon.type != "melee")
	{
		clone_weapon = level.weaponnone;
	}
	body = self cloneplayer(deathanimduration, clone_weapon, attacker);
	if(isdefined(body))
	{
		self createdeadbody(attacker, idamage, smeansofdeath, weapon, shitloc, vdir, (0, 0, 0), deathanimduration, einflictor, body);
	}
}

/*
	Name: callback_playerkilled
	Namespace: globallogic_player
	Checksum: 0xD6D6CED8
	Offset: 0xCA28
	Size: 0x288A
	Parameters: 10
	Flags: Linked
*/
function callback_playerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration, enteredresurrect = 0)
{
	profilelog_begintiming(7, "ship");
	self endon(#"spawned");
	if(game["state"] == "postgame")
	{
		do_post_game_death(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration);
		return;
	}
	if(self.sessionteam == "spectator")
	{
		return;
	}
	self notify(#"killed_player");
	self callback::callback(#"hash_bc435202");
	self needsrevive(0);
	if(isdefined(self.burning) && self.burning == 1)
	{
		self setburn(0);
	}
	self.suicide = 0;
	self.teamkilled = 0;
	if(isdefined(level.takelivesondeath) && level.takelivesondeath == 1)
	{
		if(self.pers["lives"])
		{
			self.pers["lives"]--;
			if(self.pers["lives"] == 0)
			{
				level notify(#"player_eliminated");
				self notify(#"player_eliminated");
			}
		}
		if(game[self.team + "_lives"])
		{
			game[self.team + "_lives"]--;
			if((game[self.team + "_lives"]) == 0)
			{
				level notify(#"player_eliminated");
				self notify(#"player_eliminated");
			}
		}
	}
	self thread globallogic_audio::flush_leader_dialog_key_on_player("equipmentDestroyed");
	weapon = updateweapon(einflictor, weapon);
	pixbeginevent("PlayerKilled pre constants");
	wasinlaststand = 0;
	bledout = 0;
	deathtimeoffset = 0;
	lastweaponbeforedroppingintolaststand = undefined;
	attackerstance = undefined;
	self.laststandthislife = undefined;
	self.vattackerorigin = undefined;
	weapon_at_time_of_death = self getcurrentweapon();
	if(isdefined(self.uselaststandparams) && enteredresurrect == 0)
	{
		self.uselaststandparams = undefined;
		/#
			assert(isdefined(self.laststandparams));
		#/
		if(!level.teambased || (!isdefined(attacker) || !isplayer(attacker) || attacker.team != self.team || attacker == self))
		{
			einflictor = self.laststandparams.einflictor;
			attacker = self.laststandparams.attacker;
			attackerstance = self.laststandparams.attackerstance;
			idamage = self.laststandparams.idamage;
			smeansofdeath = self.laststandparams.smeansofdeath;
			weapon = self.laststandparams.sweapon;
			vdir = self.laststandparams.vdir;
			shitloc = self.laststandparams.shitloc;
			self.vattackerorigin = self.laststandparams.vattackerorigin;
			self.killcam_entity_info_cached = self.laststandparams.killcam_entity_info_cached;
			deathtimeoffset = (gettime() - self.laststandparams.laststandstarttime) / 1000;
			bledout = 1;
			if(isdefined(self.previousprimary))
			{
				wasinlaststand = 1;
				lastweaponbeforedroppingintolaststand = self.previousprimary;
			}
		}
		self.laststandparams = undefined;
	}
	self stopsounds();
	bestplayer = undefined;
	bestplayermeansofdeath = undefined;
	obituarymeansofdeath = undefined;
	bestplayerweapon = undefined;
	obituaryweapon = weapon;
	assistedsuicide = 0;
	if(isdefined(level.var_7d4f8220))
	{
		result = self [[level.var_7d4f8220]](attacker, smeansofdeath, weapon);
		if(isdefined(result))
		{
			bestplayer = result["bestPlayer"];
			bestplayermeansofdeath = result["bestPlayerMeansOfDeath"];
			bestplayerweapon = result["bestPlayerWeapon"];
		}
	}
	if(!isdefined(attacker) || attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn" || (isdefined(attacker.ismagicbullet) && attacker.ismagicbullet == 1) || attacker == self && isdefined(self.attackers) && !self isplayerunderwater())
	{
		if(!isdefined(bestplayer))
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
				if((self.attackerdamage[player.clientid].lasttimedamaged + 2500) < gettime())
				{
					continue;
				}
				if(!allowedassistweapon(self.attackerdamage[player.clientid].weapon))
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
				if(isdefined(bestplayer) && self.attackerdamage[player.clientid].damage > self.attackerdamage[bestplayer.clientid].damage)
				{
					bestplayer = player;
					bestplayermeansofdeath = self.attackerdamage[player.clientid].meansofdeath;
					bestplayerweapon = self.attackerdamage[player.clientid].weapon;
				}
			}
		}
		if(isdefined(bestplayer))
		{
			scoreevents::processscoreevent("assisted_suicide", bestplayer, self, weapon);
			self recordkillmodifier("assistedsuicide");
			assistedsuicide = 1;
		}
	}
	if(isdefined(bestplayer))
	{
		attacker = bestplayer;
		obituarymeansofdeath = bestplayermeansofdeath;
		obituaryweapon = bestplayerweapon;
		if(isdefined(bestplayerweapon))
		{
			weapon = bestplayerweapon;
		}
	}
	if(isplayer(attacker) && isdefined(attacker.damagedplayers))
	{
		attacker.damagedplayers[self.clientid] = undefined;
	}
	if(enteredresurrect == 0)
	{
		globallogic::doweaponspecifickilleffects(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime);
	}
	self.deathtime = gettime();
	if(attacker != self && (!level.teambased || attacker.team != self.team))
	{
		/#
			assert(isdefined(self.lastspawntime));
		#/
		self.alivetimes[self.alivetimecurrentindex] = self.deathtime - self.lastspawntime;
		self.alivetimecurrentindex = (self.alivetimecurrentindex + 1) % level.alivetimemaxcount;
	}
	attacker = updateattacker(attacker, weapon);
	einflictor = updateinflictor(einflictor);
	smeansofdeath = self playerkilled_updatemeansofdeath(attacker, einflictor, weapon, smeansofdeath, shitloc);
	if(!isdefined(obituarymeansofdeath))
	{
		obituarymeansofdeath = smeansofdeath;
	}
	self.hasriotshield = 0;
	self.hasriotshieldequipped = 0;
	self thread updateglobalbotkilledcounter();
	self playerkilled_weaponstats(attacker, weapon, smeansofdeath, wasinlaststand, lastweaponbeforedroppingintolaststand, einflictor);
	if(bledout == 0)
	{
		if(getdvarint("teamOpsEnabled") == 1 && (isdefined(einflictor) && (isdefined(einflictor.teamops) && einflictor.teamops)))
		{
			self playerkilled_obituary(einflictor, einflictor, obituaryweapon, obituarymeansofdeath);
		}
		else
		{
			self playerkilled_obituary(attacker, einflictor, obituaryweapon, obituarymeansofdeath);
		}
	}
	if(enteredresurrect == 0)
	{
		self.sessionstate = "dead";
		self.statusicon = "hud_status_dead";
	}
	self.pers["weapon"] = undefined;
	self.killedplayerscurrent = [];
	self.deathcount++;
	/#
		println((("" + self.clientid) + "") + self.deathcount);
	#/
	if(bledout == 0)
	{
		self playerkilled_killstreaks(attacker, weapon);
	}
	lpselfnum = self getentitynumber();
	lpselfname = self.name;
	lpattackguid = "";
	lpattackname = "";
	lpselfteam = self.team;
	lpselfguid = self getguid();
	lpattackteam = "";
	lpattackorigin = (0, 0, 0);
	lpattacknum = -1;
	awardassists = 0;
	wasteamkill = 0;
	wassuicide = 0;
	pixendevent();
	scoreevents::processscoreevent("death", self, self, weapon);
	self.pers["resetMomentumOnSpawn"] = level.scoreresetondeath;
	if(isplayer(attacker))
	{
		lpattackguid = attacker getguid();
		lpattackname = attacker.name;
		lpattackteam = attacker.team;
		lpattackorigin = attacker.origin;
		if(attacker == self || assistedsuicide == 1)
		{
			dokillcam = 0;
			wassuicide = 1;
			awardassists = self playerkilled_suicide(einflictor, attacker, smeansofdeath, weapon, shitloc);
			if(assistedsuicide == 1)
			{
				attacker thread globallogic_score::givekillstats(smeansofdeath, weapon, self);
			}
		}
		else
		{
			pixbeginevent("PlayerKilled attacker");
			lpattacknum = attacker getentitynumber();
			dokillcam = 1;
			if(level.teambased && self.team == attacker.team && smeansofdeath == "MOD_GRENADE" && level.friendlyfire == 0)
			{
			}
			else
			{
				if(level.teambased && self.team == attacker.team)
				{
					wasteamkill = 1;
					self playerkilled_teamkill(einflictor, attacker, smeansofdeath, weapon, shitloc);
				}
				else if(bledout == 0)
				{
					self playerkilled_kill(einflictor, attacker, smeansofdeath, weapon, shitloc);
					if(level.teambased)
					{
						awardassists = 1;
					}
				}
			}
			pixendevent();
		}
	}
	else
	{
		if(isdefined(attacker) && (attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn"))
		{
			dokillcam = 0;
			lpattacknum = -1;
			lpattackguid = "";
			lpattackname = "";
			lpattackteam = "world";
			scoreevents::processscoreevent("suicide", self);
			self globallogic_score::incpersstat("suicides", 1);
			self.suicides = self globallogic_score::getpersstat("suicides");
			self.suicide = 1;
			thread battlechatter::on_player_suicide_or_team_kill(self, "suicide");
			awardassists = 1;
			if(level.maxsuicidesbeforekick > 0 && level.maxsuicidesbeforekick <= self.suicides)
			{
				self notify(#"teamkillkicked");
				self suicidekick();
			}
		}
		else
		{
			dokillcam = 0;
			lpattacknum = -1;
			lpattackguid = "";
			lpattackname = "";
			lpattackteam = "world";
			wassuicide = 1;
			if(isdefined(einflictor) && isdefined(einflictor.killcament))
			{
				dokillcam = 1;
				lpattacknum = self getentitynumber();
				wassuicide = 0;
			}
			if(isdefined(attacker) && isdefined(attacker.team) && isdefined(level.teams[attacker.team]))
			{
				if(attacker.team != self.team)
				{
					if(level.teambased)
					{
						if(!isdefined(killstreaks::get_killstreak_for_weapon(weapon)) || (isdefined(level.killstreaksgivegamescore) && level.killstreaksgivegamescore))
						{
							globallogic_score::giveteamscore("kill", attacker.team, attacker, self);
						}
					}
					wassuicide = 0;
				}
			}
			awardassists = 1;
		}
	}
	if(!level.ingraceperiod && enteredresurrect == 0)
	{
		if(smeansofdeath != "MOD_GRENADE" && smeansofdeath != "MOD_GRENADE_SPLASH" && smeansofdeath != "MOD_EXPLOSIVE" && smeansofdeath != "MOD_EXPLOSIVE_SPLASH" && smeansofdeath != "MOD_PROJECTILE_SPLASH" && smeansofdeath != "MOD_FALLING")
		{
			if(weapon.name != "incendiary_fire")
			{
				self weapons::drop_scavenger_for_death(attacker);
			}
		}
		if(should_drop_weapon_on_death(wasteamkill, wassuicide, weapon_at_time_of_death, smeansofdeath))
		{
			self weapons::drop_for_death(attacker, weapon, smeansofdeath);
		}
	}
	if(awardassists)
	{
		self playerkilled_awardassists(einflictor, attacker, weapon, lpattackteam);
	}
	pixbeginevent("PlayerKilled post constants");
	self.lastattacker = attacker;
	self.lastdeathpos = self.origin;
	if(isdefined(attacker) && isplayer(attacker) && attacker != self && (!level.teambased || attacker.team != self.team))
	{
		attacker notify(#"killed_enemy_player", self, weapon);
		if(isdefined(attacker.gadget_thief_kill_callback))
		{
			attacker [[attacker.gadget_thief_kill_callback]](self, weapon);
		}
		self thread challenges::playerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, shitloc, attackerstance, bledout);
	}
	else
	{
		self notify(#"playerkilledchallengesprocessed");
	}
	if(isdefined(self.attackers))
	{
		self.attackers = [];
	}
	killerheropoweractive = 0;
	killer = undefined;
	killerloadoutindex = -1;
	killerwasads = 0;
	killerinvictimfov = 0;
	victiminkillerfov = 0;
	if(isplayer(attacker))
	{
		attacker.lastkilltime = gettime();
		killer = attacker;
		if(isdefined(attacker.class_num))
		{
			killerloadoutindex = attacker.class_num;
		}
		killerwasads = attacker playerads() >= 1;
		killerinvictimfov = util::within_fov(self.origin, self.angles, attacker.origin, self.fovcosine);
		victiminkillerfov = util::within_fov(attacker.origin, attacker.angles, self.origin, attacker.fovcosine);
		if(attacker ability_player::is_using_any_gadget())
		{
			killerheropoweractive = 1;
		}
		if(killstreaks::is_killstreak_weapon(weapon))
		{
			killstreak = killstreaks::get_killstreak_for_weapon_for_stats(weapon);
			bbprint("mpattacks", "gametime %d attackerspawnid %d attackerweapon %s attackerx %d attackery %d attackerz %d victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d isusingheropower %d killstreak %s", gettime(), getplayerspawnid(attacker), weapon.name, lpattackorigin, getplayerspawnid(self), self.origin, idamage, smeansofdeath, shitloc, 1, killerheropoweractive, killstreak);
		}
		else
		{
			bbprint("mpattacks", "gametime %d attackerspawnid %d attackerweapon %s attackerx %d attackery %d attackerz %d victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d isusingheropower %d", gettime(), getplayerspawnid(attacker), weapon.name, lpattackorigin, getplayerspawnid(self), self.origin, idamage, smeansofdeath, shitloc, 1, killerheropoweractive);
		}
		attacker thread weapons::bestweapon_kill(weapon);
	}
	else
	{
		bbprint("mpattacks", "gametime %d attackerweapon %s victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d isusingheropower %d", gettime(), weapon.name, getplayerspawnid(self), self.origin, idamage, smeansofdeath, shitloc, 1, 0);
	}
	victimweapon = undefined;
	victimweaponpickedup = 0;
	victimkillstreakweaponindex = 0;
	if(isdefined(weapon_at_time_of_death))
	{
		victimweapon = weapon_at_time_of_death;
		if(isdefined(self.pickedupweapons) && isdefined(self.pickedupweapons[victimweapon]))
		{
			victimweaponpickedup = 1;
		}
		if(killstreaks::is_killstreak_weapon(victimweapon))
		{
			killstreak = killstreaks::get_killstreak_for_weapon_for_stats(victimweapon);
			if(isdefined(level.killstreaks[killstreak].menuname))
			{
				victimkillstreakweaponindex = level.killstreakindices[level.killstreaks[killstreak].menuname];
			}
		}
	}
	victimwasads = self playerads() >= 1;
	victimheropoweractive = self ability_player::is_using_any_gadget();
	killerweaponpickedup = 0;
	killerkillstreakweaponindex = 0;
	killerkillstreakeventindex = 125;
	if(isdefined(weapon))
	{
		if(isdefined(killer) && isdefined(killer.pickedupweapons) && isdefined(killer.pickedupweapons[weapon]))
		{
			killerweaponpickedup = 1;
		}
		if(killstreaks::is_killstreak_weapon(weapon))
		{
			killstreak = killstreaks::get_killstreak_for_weapon_for_stats(weapon);
			if(isdefined(level.killstreaks[killstreak].menuname))
			{
				killerkillstreakweaponindex = level.killstreakindices[level.killstreaks[killstreak].menuname];
				if(isdefined(killer.killstreakevents) && isdefined(killer.killstreakevents[killerkillstreakweaponindex]))
				{
					killerkillstreakeventindex = killer.killstreakevents[killerkillstreakweaponindex];
				}
				else
				{
					killerkillstreakeventindex = 126;
				}
			}
		}
	}
	matchrecordlogadditionaldeathinfo(self, killer, victimweapon, weapon, self.class_num, victimweaponpickedup, victimwasads, killerloadoutindex, killerweaponpickedup, killerwasads, victimheropoweractive, killerheropoweractive, victiminkillerfov, killerinvictimfov, killerkillstreakweaponindex, victimkillstreakweaponindex, killerkillstreakeventindex);
	self record_special_move_data_for_life(killer);
	self.pickedupweapons = [];
	/#
		logprint(((((((((((((((((((((((("" + lpselfguid) + "") + lpselfnum) + "") + lpselfteam) + "") + lpselfname) + "") + lpattackguid) + "") + lpattacknum) + "") + lpattackteam) + "") + lpattackname) + "") + weapon.name) + "") + idamage) + "") + smeansofdeath) + "") + shitloc) + "");
	#/
	attackerstring = "none";
	if(isplayer(attacker))
	{
		attackerstring = ((attacker getxuid() + "(") + lpattackname) + ")";
	}
	/#
		print((((((((((((("" + smeansofdeath) + "") + weapon.name) + "") + attackerstring) + "") + idamage) + "") + shitloc) + "") + int(self.origin[0]) + "") + int(self.origin[1]) + "") + int(self.origin[2]));
	#/
	if(!level.rankedmatch && !level.teambased)
	{
		level thread update_ffa_top_scorers();
	}
	level thread globallogic::updateteamstatus();
	level thread globallogic::updatealivetimes(self.team);
	if(isdefined(self.killcam_entity_info_cached))
	{
		killcam_entity_info = self.killcam_entity_info_cached;
		self.killcam_entity_info_cached = undefined;
	}
	else
	{
		killcam_entity_info = killcam::get_killcam_entity_info(attacker, einflictor, weapon);
	}
	if(isdefined(self.killstreak_delay_killcam))
	{
		dokillcam = 0;
	}
	self weapons::detach_carry_object_model();
	pixendevent();
	pixbeginevent("PlayerKilled body and gibbing");
	vattackerorigin = undefined;
	if(isdefined(attacker))
	{
		vattackerorigin = attacker.origin;
	}
	if(enteredresurrect == 0)
	{
		clone_weapon = weapon;
		if(weapon_utils::ismeleemod(smeansofdeath) && clone_weapon.type != "melee")
		{
			clone_weapon = level.weaponnone;
		}
		body = self cloneplayer(deathanimduration, clone_weapon, attacker);
		if(isdefined(body))
		{
			self createdeadbody(attacker, idamage, smeansofdeath, weapon, shitloc, vdir, vattackerorigin, deathanimduration, einflictor, body);
			if(isdefined(level.var_a58db931))
			{
				self [[level.var_a58db931]](body, attacker, weapon, smeansofdeath);
			}
			else
			{
				self battlechatter::play_death_vox(body, attacker, weapon, smeansofdeath);
			}
			globallogic::doweaponspecificcorpseeffects(body, einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime);
		}
	}
	pixendevent();
	if(enteredresurrect)
	{
		thread globallogic_spawn::spawnqueuedclient(self.team, attacker);
	}
	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;
	if(bledout == 0)
	{
		self thread [[level.onplayerkilled]](einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration);
	}
	if(isdefined(level.teamopsonplayerkilled))
	{
		self [[level.teamopsonplayerkilled]](einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration);
	}
	for(icb = 0; icb < level.onplayerkilledextraunthreadedcbs.size; icb++)
	{
		self [[level.onplayerkilledextraunthreadedcbs[icb]]](einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration);
	}
	self.wantsafespawn = 0;
	perks = [];
	killstreaks = globallogic::getkillstreaks(attacker);
	if(!isdefined(self.killstreak_delay_killcam))
	{
		self thread [[level.spawnplayerprediction]]();
	}
	profilelog_endtiming(7, (("gs=" + game["state"]) + " zom=") + sessionmodeiszombiesgame());
	if(wasteamkill == 0 && assistedsuicide == 0 && smeansofdeath != "MOD_SUICIDE" && (!(!isdefined(attacker) || attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn" || attacker == self || isdefined(attacker.disablefinalkillcam))))
	{
		level thread killcam::record_settings(lpattacknum, self getentitynumber(), weapon, smeansofdeath, self.deathtime, deathtimeoffset, psoffsettime, killcam_entity_info, perks, killstreaks, attacker);
	}
	if(enteredresurrect)
	{
		return;
	}
	wait(0.25);
	weaponclass = util::getweaponclass(weapon);
	if(isdefined(weaponclass) && weaponclass == "weapon_sniper")
	{
		self thread battlechatter::killed_by_sniper(attacker);
	}
	else
	{
		self thread battlechatter::player_killed(attacker, killstreak);
	}
	self.cancelkillcam = 0;
	self thread killcam::cancel_on_use();
	self playerkilled_watch_death(weapon, smeansofdeath, deathanimduration);
	/#
		if(getdvarint("") != 0)
		{
			dokillcam = 1;
			if(lpattacknum < 0)
			{
				lpattacknum = self getentitynumber();
			}
		}
	#/
	if(game["state"] != "playing")
	{
		return;
	}
	self.respawntimerstarttime = gettime();
	keep_deathcam = 0;
	if(isdefined(self.overrideplayerdeadstatus))
	{
		keep_deathcam = self [[self.overrideplayerdeadstatus]]();
	}
	if(!self.cancelkillcam && dokillcam && level.killcam && wasteamkill == 0)
	{
		livesleft = !(level.numlives && !self.pers["lives"]) && (!(level.numteamlives && !game[self.team + "_lives"]));
		timeuntilspawn = globallogic_spawn::timeuntilspawn(1);
		willrespawnimmediately = livesleft && timeuntilspawn <= 0 && !level.playerqueuedrespawn;
		self killcam::killcam(lpattacknum, self getentitynumber(), killcam_entity_info, weapon, smeansofdeath, self.deathtime, deathtimeoffset, psoffsettime, willrespawnimmediately, globallogic_utils::timeuntilroundend(), perks, killstreaks, attacker, keep_deathcam);
	}
	else if(self.cancelkillcam)
	{
		if(isdefined(self.killcamsskipped))
		{
			self.killcamsskipped++;
		}
		else
		{
			self.killcamsskipped = 1;
		}
	}
	secondary_deathcam = 0;
	timeuntilspawn = globallogic_spawn::timeuntilspawn(1);
	shoulddoseconddeathcam = timeuntilspawn > 0;
	if(shoulddoseconddeathcam && isdefined(self.secondarydeathcamtime))
	{
		secondary_deathcam = self [[self.secondarydeathcamtime]]();
	}
	if(secondary_deathcam > 0 && !self.cancelkillcam)
	{
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self.spectatekillcam = 0;
		globallogic_utils::waitfortimeornotify(secondary_deathcam, "end_death_delay");
		self notify(#"death_delay_finished");
	}
	if(!self.cancelkillcam && dokillcam && level.killcam && keep_deathcam)
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self.spectatekillcam = 0;
	}
	if(game["state"] != "playing")
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamtargetentity = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self.spectatekillcam = 0;
		return;
	}
	waittillkillstreakdone();
	userespawntime = 1;
	if(isdefined(level.hostmigrationtimer))
	{
		userespawntime = 0;
	}
	hostmigration::waittillhostmigrationcountdown();
	if(globallogic_utils::isvalidclass(self.curclass))
	{
		timepassed = undefined;
		if(isdefined(self.respawntimerstarttime) && userespawntime)
		{
			timepassed = (gettime() - self.respawntimerstarttime) / 1000;
		}
		self thread [[level.spawnclient]](timepassed);
		self.respawntimerstarttime = undefined;
	}
}

/*
	Name: update_ffa_top_scorers
	Namespace: globallogic_player
	Checksum: 0x4A3FF5E5
	Offset: 0xF2C0
	Size: 0x2C6
	Parameters: 0
	Flags: Linked
*/
function update_ffa_top_scorers()
{
	waittillframeend();
	if(!level.players.size || level.gameended)
	{
		return;
	}
	placement = [];
	foreach(player in level.players)
	{
		if(player.team != "spectator")
		{
			placement[placement.size] = player;
		}
	}
	for(i = 1; i < placement.size; i++)
	{
		player = placement[i];
		playerscore = player.pointstowin;
		for(j = i - 1; j >= 0 && (playerscore > placement[j].pointstowin || (playerscore == placement[j].pointstowin && player.deaths < placement[j].deaths) || (playerscore == placement[j].pointstowin && player.deaths == placement[j].deaths && player.lastkilltime > placement[j].lastkilltime)); j--)
		{
			placement[j + 1] = placement[j];
		}
		placement[j + 1] = player;
	}
	cleartopscorers();
	for(i = 0; i < placement.size && i < 3; i++)
	{
		settopscorer(i, placement[i], 0, 0, 0, 0, level.weaponnone);
	}
}

/*
	Name: playerkilled_watch_death
	Namespace: globallogic_player
	Checksum: 0xC6322B1C
	Offset: 0xF590
	Size: 0xEA
	Parameters: 3
	Flags: Linked
*/
function playerkilled_watch_death(weapon, smeansofdeath, deathanimduration)
{
	defaultplayerdeathwatchtime = 1.75;
	if(smeansofdeath == "MOD_MELEE_ASSASSINATE" || 0 > weapon.deathcamtime)
	{
		defaultplayerdeathwatchtime = (deathanimduration * 0.001) + 0.5;
	}
	else if(0 < weapon.deathcamtime)
	{
		defaultplayerdeathwatchtime = weapon.deathcamtime;
	}
	if(isdefined(level.overrideplayerdeathwatchtimer))
	{
		defaultplayerdeathwatchtime = [[level.overrideplayerdeathwatchtimer]](defaultplayerdeathwatchtime);
	}
	globallogic_utils::waitfortimeornotify(defaultplayerdeathwatchtime, "end_death_delay");
	self notify(#"death_delay_finished");
}

/*
	Name: should_drop_weapon_on_death
	Namespace: globallogic_player
	Checksum: 0x221628DA
	Offset: 0xF688
	Size: 0x8E
	Parameters: 4
	Flags: Linked
*/
function should_drop_weapon_on_death(wasteamkill, wassuicide, current_weapon, smeansofdeath)
{
	if(wasteamkill)
	{
		return false;
	}
	if(wassuicide)
	{
		return false;
	}
	if(smeansofdeath == "MOD_TRIGGER_HURT" && !self isonground())
	{
		return false;
	}
	if(isdefined(current_weapon) && current_weapon.isheroweapon)
	{
		return false;
	}
	return true;
}

/*
	Name: updateglobalbotkilledcounter
	Namespace: globallogic_player
	Checksum: 0xE969E41E
	Offset: 0xF720
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function updateglobalbotkilledcounter()
{
	if(isdefined(self.pers["isBot"]))
	{
		level.globallarryskilled++;
	}
}

/*
	Name: waittillkillstreakdone
	Namespace: globallogic_player
	Checksum: 0x8CE6966F
	Offset: 0xF750
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function waittillkillstreakdone()
{
	if(isdefined(self.killstreak_delay_killcam))
	{
		while(isdefined(self.killstreak_delay_killcam))
		{
			wait(0.1);
		}
		wait(2);
		self killstreaks::reset_killstreak_delay_killcam();
	}
}

/*
	Name: suicidekick
	Namespace: globallogic_player
	Checksum: 0xABC98346
	Offset: 0xF7A0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function suicidekick()
{
	self globallogic_score::incpersstat("sessionbans", 1);
	self endon(#"disconnect");
	waittillframeend();
	globallogic::gamehistoryplayerkicked();
	ban(self getentitynumber());
	globallogic_audio::leader_dialog("gamePlayerKicked");
}

/*
	Name: teamkillkick
	Namespace: globallogic_player
	Checksum: 0x50F91B18
	Offset: 0xF830
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function teamkillkick()
{
	self globallogic_score::incpersstat("sessionbans", 1);
	self endon(#"disconnect");
	waittillframeend();
	playlistbanquantum = tweakables::gettweakablevalue("team", "teamkillerplaylistbanquantum");
	playlistbanpenalty = tweakables::gettweakablevalue("team", "teamkillerplaylistbanpenalty");
	if(playlistbanquantum > 0 && playlistbanpenalty > 0)
	{
		timeplayedtotal = self getdstat("playerstatslist", "time_played_total", "StatValue");
		minutesplayed = timeplayedtotal / 60;
		freebees = 2;
		banallowance = (int(floor(minutesplayed / playlistbanquantum))) + freebees;
		if(self.sessionbans > banallowance)
		{
			self setdstat("playerstatslist", "gametypeban", "StatValue", timeplayedtotal + (playlistbanpenalty * 60));
		}
	}
	globallogic::gamehistoryplayerkicked();
	ban(self getentitynumber());
	globallogic_audio::leader_dialog("gamePlayerKicked");
}

/*
	Name: teamkilldelay
	Namespace: globallogic_player
	Checksum: 0x882523CF
	Offset: 0xFA28
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function teamkilldelay()
{
	teamkills = self.pers["teamkills_nostats"];
	if(level.minimumallowedteamkills < 0 || teamkills <= level.minimumallowedteamkills)
	{
		return 0;
	}
	exceeded = teamkills - level.minimumallowedteamkills;
	return level.teamkillspawndelay * exceeded;
}

/*
	Name: shouldteamkillkick
	Namespace: globallogic_player
	Checksum: 0x1450EC50
	Offset: 0xFAA0
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function shouldteamkillkick(teamkilldelay)
{
	if(teamkilldelay && level.minimumallowedteamkills >= 0)
	{
		if(globallogic_utils::gettimepassed() >= 5000)
		{
			return true;
		}
		if(self.pers["teamkills_nostats"] > 1)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: reduceteamkillsovertime
	Namespace: globallogic_player
	Checksum: 0xC8CEA91
	Offset: 0xFB10
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function reduceteamkillsovertime()
{
	timeperoneteamkillreduction = 20;
	reductionpersecond = 1 / timeperoneteamkillreduction;
	while(true)
	{
		if(isalive(self))
		{
			self.pers["teamkills_nostats"] = self.pers["teamkills_nostats"] - reductionpersecond;
			if(self.pers["teamkills_nostats"] < level.minimumallowedteamkills)
			{
				self.pers["teamkills_nostats"] = level.minimumallowedteamkills;
				break;
			}
		}
		wait(1);
	}
}

/*
	Name: ignoreteamkills
	Namespace: globallogic_player
	Checksum: 0x6BB74DAD
	Offset: 0xFBD8
	Size: 0xFC
	Parameters: 3
	Flags: Linked
*/
function ignoreteamkills(weapon, smeansofdeath, einflictor)
{
	if(weapon_utils::ismeleemod(smeansofdeath))
	{
		return false;
	}
	if(weapon.ignoreteamkills)
	{
		return true;
	}
	if(isdefined(einflictor) && einflictor.ignore_team_kills === 1)
	{
		return true;
	}
	if(isdefined(einflictor) && isdefined(einflictor.destroyedby) && isdefined(einflictor.owner) && einflictor.destroyedby != einflictor.owner)
	{
		return true;
	}
	if(isdefined(einflictor) && einflictor.classname == "worldspawn")
	{
		return true;
	}
	return false;
}

/*
	Name: callback_playerlaststand
	Namespace: globallogic_player
	Checksum: 0xD683CB65
	Offset: 0xFCE0
	Size: 0x84
	Parameters: 9
	Flags: Linked
*/
function callback_playerlaststand(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	laststand::playerlaststand(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration);
}

/*
	Name: damageshellshockandrumble
	Namespace: globallogic_player
	Checksum: 0x2C1E9A4A
	Offset: 0xFD70
	Size: 0x8C
	Parameters: 5
	Flags: Linked
*/
function damageshellshockandrumble(eattacker, einflictor, weapon, smeansofdeath, idamage)
{
	self thread weapons::on_damage(eattacker, einflictor, weapon, smeansofdeath, idamage);
	if(!self util::isusingremote())
	{
		self playrumbleonentity("damage_heavy");
	}
}

/*
	Name: createdeadbody
	Namespace: globallogic_player
	Checksum: 0xAEFF5946
	Offset: 0xFE08
	Size: 0x354
	Parameters: 10
	Flags: Linked
*/
function createdeadbody(attacker, idamage, smeansofdeath, weapon, shitloc, vdir, vattackerorigin, deathanimduration, einflictor, body)
{
	if(smeansofdeath == "MOD_HIT_BY_OBJECT" && self getstance() == "prone")
	{
		self.body = body;
		if(!isdefined(self.switching_teams))
		{
			thread deathicons::add(body, self, self.team, 5);
		}
		return;
	}
	ragdoll_now = 0;
	if(isdefined(self.usingvehicle) && self.usingvehicle && isdefined(self.vehicleposition) && self.vehicleposition == 1)
	{
		ragdoll_now = 1;
	}
	if(isdefined(level.ragdoll_override) && self [[level.ragdoll_override]](idamage, smeansofdeath, weapon, shitloc, vdir, vattackerorigin, deathanimduration, einflictor, ragdoll_now, body))
	{
		return;
	}
	if(ragdoll_now || self isonladder() || self ismantling() || smeansofdeath == "MOD_CRUSH" || smeansofdeath == "MOD_HIT_BY_OBJECT")
	{
		body startragdoll();
	}
	if(!self isonground() && smeansofdeath != "MOD_FALLING")
	{
		if(getdvarint("scr_disable_air_death_ragdoll") == 0)
		{
			body startragdoll();
		}
	}
	if(smeansofdeath == "MOD_MELEE_ASSASSINATE" && !attacker isonground())
	{
		body start_death_from_above_ragdoll(vdir);
	}
	if(self is_explosive_ragdoll(weapon, einflictor))
	{
		body start_explosive_ragdoll(vdir, weapon);
	}
	thread delaystartragdoll(body, shitloc, vdir, weapon, einflictor, smeansofdeath);
	if(smeansofdeath == "MOD_CRUSH")
	{
		body globallogic_vehicle::vehiclecrush();
	}
	self.body = body;
	if(!isdefined(self.switching_teams))
	{
		thread deathicons::add(body, self, self.team, 5);
	}
}

/*
	Name: is_explosive_ragdoll
	Namespace: globallogic_player
	Checksum: 0x5898B4E1
	Offset: 0x10168
	Size: 0xB2
	Parameters: 2
	Flags: Linked
*/
function is_explosive_ragdoll(weapon, inflictor)
{
	if(!isdefined(weapon))
	{
		return false;
	}
	if(weapon.name == "destructible_car" || weapon.name == "explodable_barrel")
	{
		return true;
	}
	if(weapon.projexplosiontype == "grenade")
	{
		if(isdefined(inflictor) && isdefined(inflictor.stucktoplayer))
		{
			if(inflictor.stucktoplayer == self)
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: start_explosive_ragdoll
	Namespace: globallogic_player
	Checksum: 0x561FF4F8
	Offset: 0x10228
	Size: 0x1B4
	Parameters: 2
	Flags: Linked
*/
function start_explosive_ragdoll(dir, weapon)
{
	if(!isdefined(self))
	{
		return;
	}
	x = randomintrange(50, 100);
	y = randomintrange(50, 100);
	z = randomintrange(10, 20);
	if(isdefined(weapon) && (weapon.name == "sticky_grenade" || weapon.name == "explosive_bolt"))
	{
		if(isdefined(dir) && lengthsquared(dir) > 0)
		{
			x = dir[0] * x;
			y = dir[1] * y;
		}
	}
	else
	{
		if(math::cointoss())
		{
			x = x * -1;
		}
		if(math::cointoss())
		{
			y = y * -1;
		}
	}
	self startragdoll();
	self launchragdoll((x, y, z));
}

/*
	Name: start_death_from_above_ragdoll
	Namespace: globallogic_player
	Checksum: 0x7ABC2C15
	Offset: 0x103E8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function start_death_from_above_ragdoll(dir)
{
	if(!isdefined(self))
	{
		return;
	}
	self startragdoll();
	self launchragdoll(vectorscale((0, 0, -1), 100));
}

/*
	Name: notifyconnecting
	Namespace: globallogic_player
	Checksum: 0xEAAA8E03
	Offset: 0x10440
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function notifyconnecting()
{
	waittillframeend();
	if(isdefined(self))
	{
		level notify(#"connecting", self);
	}
	callback::callback(#"hash_fefe13f5");
}

/*
	Name: delaystartragdoll
	Namespace: globallogic_player
	Checksum: 0xDDC561FA
	Offset: 0x10480
	Size: 0x194
	Parameters: 6
	Flags: Linked
*/
function delaystartragdoll(ent, shitloc, vdir, weapon, einflictor, smeansofdeath)
{
	if(isdefined(ent))
	{
		deathanim = ent getcorpseanim();
		if(animhasnotetrack(deathanim, "ignore_ragdoll"))
		{
			return;
		}
	}
	waittillframeend();
	if(!isdefined(ent))
	{
		return;
	}
	if(ent isragdoll())
	{
		return;
	}
	deathanim = ent getcorpseanim();
	startfrac = 0.35;
	if(animhasnotetrack(deathanim, "start_ragdoll"))
	{
		times = getnotetracktimes(deathanim, "start_ragdoll");
		if(isdefined(times))
		{
			startfrac = times[0];
		}
	}
	waittime = startfrac * getanimlength(deathanim);
	if(waittime > 0)
	{
		wait(waittime);
	}
	if(isdefined(ent))
	{
		ent startragdoll();
	}
}

/*
	Name: trackattackerdamage
	Namespace: globallogic_player
	Checksum: 0x570DEE0C
	Offset: 0x10620
	Size: 0x2F2
	Parameters: 4
	Flags: Linked
*/
function trackattackerdamage(eattacker, idamage, smeansofdeath, weapon)
{
	if(!isdefined(eattacker))
	{
		return;
	}
	if(!isplayer(eattacker))
	{
		return;
	}
	if(self.attackerdata.size == 0)
	{
		self.firsttimedamaged = gettime();
	}
	if(!isdefined(self.attackerdata[eattacker.clientid]))
	{
		self.attackerdamage[eattacker.clientid] = spawnstruct();
		self.attackerdamage[eattacker.clientid].damage = idamage;
		self.attackerdamage[eattacker.clientid].meansofdeath = smeansofdeath;
		self.attackerdamage[eattacker.clientid].weapon = weapon;
		self.attackerdamage[eattacker.clientid].time = gettime();
		self.attackers[self.attackers.size] = eattacker;
		self.attackerdata[eattacker.clientid] = 0;
	}
	else
	{
		self.attackerdamage[eattacker.clientid].damage = self.attackerdamage[eattacker.clientid].damage + idamage;
		self.attackerdamage[eattacker.clientid].meansofdeath = smeansofdeath;
		self.attackerdamage[eattacker.clientid].weapon = weapon;
		if(!isdefined(self.attackerdamage[eattacker.clientid].time))
		{
			self.attackerdamage[eattacker.clientid].time = gettime();
		}
	}
	if(isarray(self.attackersthisspawn))
	{
		self.attackersthisspawn[eattacker.clientid] = eattacker;
	}
	self.attackerdamage[eattacker.clientid].lasttimedamaged = gettime();
	if(weapons::is_primary_weapon(weapon))
	{
		self.attackerdata[eattacker.clientid] = 1;
	}
}

/*
	Name: giveattackerandinflictorownerassist
	Namespace: globallogic_player
	Checksum: 0x7F835B52
	Offset: 0x10920
	Size: 0x104
	Parameters: 5
	Flags: Linked
*/
function giveattackerandinflictorownerassist(eattacker, einflictor, idamage, smeansofdeath, weapon)
{
	if(!allowedassistweapon(weapon))
	{
		return;
	}
	self trackattackerdamage(eattacker, idamage, smeansofdeath, weapon);
	if(!isdefined(einflictor))
	{
		return;
	}
	if(!isdefined(einflictor.owner))
	{
		return;
	}
	if(!isdefined(einflictor.ownergetsassist))
	{
		return;
	}
	if(!einflictor.ownergetsassist)
	{
		return;
	}
	if(isdefined(eattacker) && eattacker == einflictor.owner)
	{
		return;
	}
	self trackattackerdamage(einflictor.owner, idamage, smeansofdeath, weapon);
}

/*
	Name: playerkilled_updatemeansofdeath
	Namespace: globallogic_player
	Checksum: 0x71D08CC9
	Offset: 0x10A30
	Size: 0xF2
	Parameters: 5
	Flags: Linked
*/
function playerkilled_updatemeansofdeath(attacker, einflictor, weapon, smeansofdeath, shitloc)
{
	if(globallogic_utils::isheadshot(weapon, shitloc, smeansofdeath, einflictor) && isplayer(attacker) && !weapon_utils::ismeleemod(smeansofdeath))
	{
		return "MOD_HEAD_SHOT";
	}
	switch(weapon.name)
	{
		case "dog_bite":
		{
			smeansofdeath = "MOD_PISTOL_BULLET";
			break;
		}
		case "destructible_car":
		{
			smeansofdeath = "MOD_EXPLOSIVE";
			break;
		}
		case "explodable_barrel":
		{
			smeansofdeath = "MOD_EXPLOSIVE";
			break;
		}
	}
	return smeansofdeath;
}

/*
	Name: updateattacker
	Namespace: globallogic_player
	Checksum: 0xC0032988
	Offset: 0x10B30
	Size: 0x2E4
	Parameters: 2
	Flags: Linked
*/
function updateattacker(attacker, weapon)
{
	if(isai(attacker) && isdefined(attacker.script_owner))
	{
		if(!level.teambased || attacker.script_owner.team != self.team)
		{
			attacker = attacker.script_owner;
		}
	}
	if(attacker.classname == "script_vehicle" && isdefined(attacker.owner))
	{
		attacker notify(#"killed", self);
		attacker = attacker.owner;
	}
	if(isai(attacker))
	{
		attacker notify(#"killed", self);
	}
	if(isdefined(self.capturinglastflag) && self.capturinglastflag == 1)
	{
		attacker.lastcapkiller = 1;
	}
	if(isdefined(attacker) && attacker != self && isdefined(weapon))
	{
		if(weapon.name == "planemortar")
		{
			if(!isdefined(attacker.planemortarbda))
			{
				attacker.planemortarbda = 0;
			}
			attacker.planemortarbda++;
		}
		else
		{
			if(weapon.name == "dart" || weapon.name == "dart_turret")
			{
				if(!isdefined(attacker.dartbda))
				{
					attacker.dartbda = 0;
				}
				attacker.dartbda++;
			}
			else
			{
				if(weapon.name == "straferun_rockets" || weapon.name == "straferun_gun")
				{
					if(isdefined(attacker.straferunbda))
					{
						attacker.straferunbda++;
					}
				}
				else if(weapon.name == "remote_missile_missile" || weapon.name == "remote_missile_bomblet")
				{
					if(!isdefined(attacker.remotemissilebda))
					{
						attacker.remotemissilebda = 0;
					}
					attacker.remotemissilebda++;
				}
			}
		}
	}
	return attacker;
}

/*
	Name: updateinflictor
	Namespace: globallogic_player
	Checksum: 0x7F9A22CA
	Offset: 0x10E20
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function updateinflictor(einflictor)
{
	if(isdefined(einflictor) && einflictor.classname == "script_vehicle")
	{
		einflictor notify(#"killed", self);
		if(isdefined(einflictor.bda))
		{
			einflictor.bda++;
		}
	}
	return einflictor;
}

/*
	Name: updateweapon
	Namespace: globallogic_player
	Checksum: 0xA5A09171
	Offset: 0x10E90
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function updateweapon(einflictor, weapon)
{
	if(weapon == level.weaponnone && isdefined(einflictor))
	{
		if(isdefined(einflictor.targetname) && einflictor.targetname == "explodable_barrel")
		{
			weapon = getweapon("explodable_barrel");
		}
		else if(isdefined(einflictor.destructible_type) && issubstr(einflictor.destructible_type, "vehicle_"))
		{
			weapon = getweapon("destructible_car");
		}
	}
	return weapon;
}

/*
	Name: playkillbattlechatter
	Namespace: globallogic_player
	Checksum: 0xB73CD326
	Offset: 0x10F70
	Size: 0x9C
	Parameters: 4
	Flags: Linked
*/
function playkillbattlechatter(attacker, weapon, victim, einflictor)
{
	if(isplayer(attacker))
	{
		if(!killstreaks::is_killstreak_weapon(weapon))
		{
			level thread battlechatter::say_kill_battle_chatter(attacker, weapon, victim, einflictor);
		}
	}
	if(isdefined(einflictor))
	{
		einflictor notify(#"bhtn_action_notify", "attack_kill");
	}
}

