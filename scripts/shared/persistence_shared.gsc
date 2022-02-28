// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\bots\_bot;
#using scripts\shared\callbacks_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace persistence;

/*
	Name: __init__sytem__
	Namespace: persistence
	Checksum: 0x49C3934F
	Offset: 0x2E0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("persistence", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: persistence
	Checksum: 0xB769779C
	Offset: 0x320
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
	callback::on_connect(&on_player_connect);
}

/*
	Name: init
	Namespace: persistence
	Checksum: 0x3744D723
	Offset: 0x370
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.can_set_aar_stat = 1;
	level.persistentdatainfo = [];
	level.maxrecentstats = 10;
	level.maxhitlocations = 19;
	level thread initialize_stat_tracking();
	level thread upload_global_stat_counters();
}

/*
	Name: on_player_connect
	Namespace: persistence
	Checksum: 0x47BCFEEB
	Offset: 0x3E0
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self.enabletext = 1;
}

/*
	Name: initialize_stat_tracking
	Namespace: persistence
	Checksum: 0x12EA8F85
	Offset: 0x3F8
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function initialize_stat_tracking()
{
	level.globalexecutions = 0;
	level.globalchallenges = 0;
	level.globalsharepackages = 0;
	level.globalcontractsfailed = 0;
	level.globalcontractspassed = 0;
	level.globalcontractscppaid = 0;
	level.globalkillstreakscalled = 0;
	level.globalkillstreaksdestroyed = 0;
	level.globalkillstreaksdeathsfrom = 0;
	level.globallarryskilled = 0;
	level.globalbuzzkills = 0;
	level.globalrevives = 0;
	level.globalafterlifes = 0;
	level.globalcomebacks = 0;
	level.globalpaybacks = 0;
	level.globalbackstabs = 0;
	level.globalbankshots = 0;
	level.globalskewered = 0;
	level.globalteammedals = 0;
	level.globalfeetfallen = 0;
	level.globaldistancesprinted = 0;
	level.globaldembombsprotected = 0;
	level.globaldembombsdestroyed = 0;
	level.globalbombsdestroyed = 0;
	level.globalfraggrenadesfired = 0;
	level.globalsatchelchargefired = 0;
	level.globalshotsfired = 0;
	level.globalcrossbowfired = 0;
	level.globalcarsdestroyed = 0;
	level.globalbarrelsdestroyed = 0;
	level.globalbombsdestroyedbyteam = [];
	foreach(team in level.teams)
	{
		level.globalbombsdestroyedbyteam[team] = 0;
	}
}

/*
	Name: upload_global_stat_counters
	Namespace: persistence
	Checksum: 0xCFF142CE
	Offset: 0x5F8
	Size: 0x64C
	Parameters: 0
	Flags: Linked
*/
function upload_global_stat_counters()
{
	level waittill(#"game_ended");
	if(!level.rankedmatch && !level.wagermatch)
	{
		return;
	}
	totalkills = 0;
	totaldeaths = 0;
	totalassists = 0;
	totalheadshots = 0;
	totalsuicides = 0;
	totaltimeplayed = 0;
	totalflagscaptured = 0;
	totalflagsreturned = 0;
	totalhqsdestroyed = 0;
	totalhqscaptured = 0;
	totalsddefused = 0;
	totalsdplants = 0;
	totalhumiliations = 0;
	totalsabdestroyedbyteam = [];
	foreach(team in level.teams)
	{
		totalsabdestroyedbyteam[team] = 0;
	}
	switch(level.gametype)
	{
		case "dem":
		{
			bombzonesleft = 0;
			for(index = 0; index < level.bombzones.size; index++)
			{
				if(!isdefined(level.bombzones[index].bombexploded) || !level.bombzones[index].bombexploded)
				{
					level.globaldembombsprotected++;
					continue;
				}
				level.globaldembombsdestroyed++;
			}
			break;
		}
		case "sab":
		{
			foreach(team in level.teams)
			{
				totalsabdestroyedbyteam[team] = level.globalbombsdestroyedbyteam[team];
			}
			break;
		}
	}
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(isdefined(player.timeplayed) && isdefined(player.timeplayed["total"]))
		{
			totaltimeplayed = totaltimeplayed + min(player.timeplayed["total"], level.timeplayedcap);
		}
	}
	if(!util::waslastround())
	{
		return;
	}
	wait(0.05);
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		totalkills = totalkills + player.kills;
		totaldeaths = totaldeaths + player.deaths;
		totalassists = totalassists + player.assists;
		totalheadshots = totalheadshots + player.headshots;
		totalsuicides = totalsuicides + player.suicides;
		totalhumiliations = totalhumiliations + player.humiliated;
		if(isdefined(player.timeplayed) && isdefined(player.timeplayed["alive"]))
		{
			totaltimeplayed = totaltimeplayed + int(min(player.timeplayed["alive"], level.timeplayedcap));
		}
		switch(level.gametype)
		{
			case "ctf":
			{
				totalflagscaptured = totalflagscaptured + player.captures;
				totalflagsreturned = totalflagsreturned + player.returns;
				break;
			}
			case "koth":
			{
				totalhqsdestroyed = totalhqsdestroyed + player.destructions;
				totalhqscaptured = totalhqscaptured + player.captures;
				break;
			}
			case "sd":
			{
				totalsddefused = totalsddefused + player.defuses;
				totalsdplants = totalsdplants + player.plants;
				break;
			}
			case "sab":
			{
				if(isdefined(player.team) && isdefined(level.teams[player.team]))
				{
					totalsabdestroyedbyteam[player.team] = totalsabdestroyedbyteam[player.team] + player.destructions;
				}
				break;
			}
		}
	}
}

/*
	Name: stat_get_with_gametype
	Namespace: persistence
	Checksum: 0x1596B8A
	Offset: 0xC50
	Size: 0x6A
	Parameters: 1
	Flags: None
*/
function stat_get_with_gametype(dataname)
{
	if(isdefined(level.nopersistence) && level.nopersistence)
	{
		return 0;
	}
	if(!level.onlinegame)
	{
		return 0;
	}
	return self getdstat("PlayerStatsByGameType", get_gametype_name(), dataname, "StatValue");
}

/*
	Name: get_gametype_name
	Namespace: persistence
	Checksum: 0x9C5B71A6
	Offset: 0xCC8
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function get_gametype_name()
{
	if(!isdefined(level.fullgametypename))
	{
		if(isdefined(level.hardcoremode) && level.hardcoremode && is_party_gamemode() == 0)
		{
			prefix = "HC";
		}
		else
		{
			prefix = "";
		}
		level.fullgametypename = tolower(prefix + level.gametype);
	}
	return level.fullgametypename;
}

/*
	Name: is_party_gamemode
	Namespace: persistence
	Checksum: 0xD64314C3
	Offset: 0xD70
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function is_party_gamemode()
{
	switch(level.gametype)
	{
		case "gun":
		case "oic":
		case "sas":
		case "shrp":
		{
			return true;
			break;
		}
	}
	return false;
}

/*
	Name: is_stat_modifiable
	Namespace: persistence
	Checksum: 0xA64BA86B
	Offset: 0xDC0
	Size: 0x1E
	Parameters: 1
	Flags: Linked
*/
function is_stat_modifiable(dataname)
{
	return level.rankedmatch || level.wagermatch;
}

/*
	Name: stat_set_with_gametype
	Namespace: persistence
	Checksum: 0xC8CD075A
	Offset: 0xDE8
	Size: 0x9C
	Parameters: 3
	Flags: None
*/
function stat_set_with_gametype(dataname, value, incvalue)
{
	if(isdefined(level.nopersistence) && level.nopersistence)
	{
		return false;
	}
	if(!is_stat_modifiable(dataname))
	{
		return;
	}
	if(level.disablestattracking)
	{
		return;
	}
	self setdstat("PlayerStatsByGameType", get_gametype_name(), dataname, "StatValue", value);
}

/*
	Name: adjust_recent_stats
	Namespace: persistence
	Checksum: 0x72473311
	Offset: 0xE90
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function adjust_recent_stats()
{
	/#
		if(getdvarint("") == 1 || getdvarint("") == 1)
		{
			return;
		}
	#/
	initialize_match_stats();
}

/*
	Name: get_recent_stat
	Namespace: persistence
	Checksum: 0x6A7ED652
	Offset: 0xF00
	Size: 0xEA
	Parameters: 3
	Flags: Linked
*/
function get_recent_stat(isglobal, index, statname)
{
	if(level.wagermatch)
	{
		return self getdstat("RecentEarnings", index, statname);
	}
	if(isglobal)
	{
		modename = util::getcurrentgamemode();
		return self getdstat("gameHistory", modename, "matchHistory", index, statname);
	}
	return self getdstat("PlayerStatsByGameType", get_gametype_name(), "prevScores", index, statname);
}

/*
	Name: set_recent_stat
	Namespace: persistence
	Checksum: 0x548D8952
	Offset: 0xFF8
	Size: 0x1A4
	Parameters: 4
	Flags: Linked
*/
function set_recent_stat(isglobal, index, statname, value)
{
	if(!isglobal)
	{
		index = self getdstat("PlayerStatsByGameType", get_gametype_name(), "prevScoreIndex");
		if(index < 0 || index > 9)
		{
			return;
		}
	}
	if(isdefined(level.nopersistence) && level.nopersistence)
	{
		return;
	}
	if(!level.onlinegame)
	{
		return;
	}
	if(!is_stat_modifiable(statname))
	{
		return;
	}
	if(level.wagermatch)
	{
		self setdstat("RecentEarnings", index, statname, value);
	}
	else
	{
		if(isglobal)
		{
			modename = util::getcurrentgamemode();
			self setdstat("gameHistory", modename, "matchHistory", "" + index, statname, value);
		}
		else
		{
			self setdstat("PlayerStatsByGameType", get_gametype_name(), "prevScores", index, statname, value);
		}
	}
}

/*
	Name: add_recent_stat
	Namespace: persistence
	Checksum: 0x2C7C70B1
	Offset: 0x11A8
	Size: 0x114
	Parameters: 4
	Flags: Linked
*/
function add_recent_stat(isglobal, index, statname, value)
{
	if(isdefined(level.nopersistence) && level.nopersistence)
	{
		return;
	}
	if(!level.onlinegame)
	{
		return;
	}
	if(!is_stat_modifiable(statname))
	{
		return;
	}
	if(!isglobal)
	{
		index = self getdstat("PlayerStatsByGameType", get_gametype_name(), "prevScoreIndex");
		if(index < 0 || index > 9)
		{
			return;
		}
	}
	currstat = get_recent_stat(isglobal, index, statname);
	set_recent_stat(isglobal, index, statname, currstat + value);
}

/*
	Name: set_match_history_stat
	Namespace: persistence
	Checksum: 0x7E27CAAD
	Offset: 0x12C8
	Size: 0x8C
	Parameters: 2
	Flags: None
*/
function set_match_history_stat(statname, value)
{
	modename = util::getcurrentgamemode();
	historyindex = self getdstat("gameHistory", modename, "currentMatchHistoryIndex");
	set_recent_stat(1, historyindex, statname, value);
}

/*
	Name: add_match_history_stat
	Namespace: persistence
	Checksum: 0x28B7481F
	Offset: 0x1360
	Size: 0x8C
	Parameters: 2
	Flags: None
*/
function add_match_history_stat(statname, value)
{
	modename = util::getcurrentgamemode();
	historyindex = self getdstat("gameHistory", modename, "currentMatchHistoryIndex");
	add_recent_stat(1, historyindex, statname, value);
}

/*
	Name: initialize_match_stats
	Namespace: persistence
	Checksum: 0xB95F26C1
	Offset: 0x13F8
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function initialize_match_stats()
{
	if(isdefined(level.nopersistence) && level.nopersistence)
	{
		return;
	}
	if(!level.onlinegame)
	{
		return;
	}
	if(!(level.rankedmatch || level.wagermatch || level.leaguematch))
	{
		return;
	}
	self.pers["lastHighestScore"] = self getdstat("HighestStats", "highest_score");
	if(sessionmodeismultiplayergame())
	{
		self.pers["lastHighestKills"] = self getdstat("HighestStats", "highest_kills");
		self.pers["lastHighestKDRatio"] = self getdstat("HighestStats", "highest_kdratio");
	}
	currgametype = get_gametype_name();
	self gamehistorystartmatch(getgametypeenumfromname(currgametype, level.hardcoremode));
}

/*
	Name: can_set_aar_stat
	Namespace: persistence
	Checksum: 0xDBE4A28A
	Offset: 0x1560
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function can_set_aar_stat()
{
	return level.can_set_aar_stat;
}

/*
	Name: set_after_action_report_player_stat
	Namespace: persistence
	Checksum: 0x9B2523CB
	Offset: 0x1578
	Size: 0x5C
	Parameters: 3
	Flags: None
*/
function set_after_action_report_player_stat(playerindex, statname, value)
{
	if(can_set_aar_stat())
	{
		self setdstat("AfterActionReportStats", "playerStats", playerindex, statname, value);
	}
}

/*
	Name: set_after_action_report_player_medal
	Namespace: persistence
	Checksum: 0xC05153
	Offset: 0x15E0
	Size: 0x64
	Parameters: 3
	Flags: None
*/
function set_after_action_report_player_medal(playerindex, medalindex, value)
{
	if(can_set_aar_stat())
	{
		self setdstat("AfterActionReportStats", "playerStats", playerindex, "medals", medalindex, value);
	}
}

/*
	Name: set_after_action_report_stat
	Namespace: persistence
	Checksum: 0x54B78D3
	Offset: 0x1650
	Size: 0xE4
	Parameters: 3
	Flags: None
*/
function set_after_action_report_stat(statname, value, index)
{
	if(self util::is_bot())
	{
		return;
	}
	/#
		if(getdvarint("") == 1 || getdvarint("") == 1)
		{
			return;
		}
	#/
	if(can_set_aar_stat())
	{
		if(isdefined(index))
		{
			self setaarstat(statname, index, value);
		}
		else
		{
			self setaarstat(statname, value);
		}
	}
}

/*
	Name: codecallback_challengecomplete
	Namespace: persistence
	Checksum: 0x94783F53
	Offset: 0x1740
	Size: 0x4EC
	Parameters: 7
	Flags: Linked
*/
function codecallback_challengecomplete(rewardxp, maxval, row, tablenumber, challengetype, itemindex, challengeindex)
{
	params = spawnstruct();
	params.rewardxp = rewardxp;
	params.maxval = maxval;
	params.row = row;
	params.tablenumber = tablenumber;
	params.challengetype = challengetype;
	params.itemindex = itemindex;
	params.challengeindex = challengeindex;
	if(sessionmodeiscampaigngame())
	{
		if(isdefined(self.challenge_callback_cp))
		{
			[[self.challenge_callback_cp]](rewardxp, maxval, row, tablenumber, challengetype, itemindex, challengeindex);
		}
		return;
	}
	callback::callback(#"hash_b286c65c", params);
	self luinotifyevent(&"challenge_complete", 7, challengeindex, itemindex, challengetype, tablenumber, row, maxval, rewardxp);
	self luinotifyeventtospectators(&"challenge_complete", 7, challengeindex, itemindex, challengetype, tablenumber, row, maxval, rewardxp);
	tablenumber = tablenumber + 1;
	tablename = (("gamedata/stats/mp/statsmilestones") + tablenumber) + ".csv";
	challengestring = tablelookupcolumnforrow(tablename, row, 5);
	challengetier = int(tablelookupcolumnforrow(tablename, row, 1));
	matchrecordlogchallengecomplete(self, tablenumber, challengetier, itemindex, challengestring);
	/#
		if(getdvarint("", 0) != 0)
		{
			challengedescstring = challengestring + "";
			challengetiernext = int(tablelookupcolumnforrow(tablename, row + 1, 1));
			tiertext = "" + challengetier;
			statstablename = "";
			herostring = tablelookup(statstablename, 0, itemindex, 3);
			if(getdvarint("") == 1)
			{
				iprintlnbold((((makelocalizedstring(challengestring) + "") + maxval) + "") + makelocalizedstring(herostring));
			}
			else
			{
				if(getdvarint("") == 2)
				{
					self iprintlnbold((((makelocalizedstring(challengestring) + "") + maxval) + "") + makelocalizedstring(herostring));
				}
				else if(getdvarint("") == 3)
				{
					iprintln((((makelocalizedstring(challengestring) + "") + maxval) + "") + makelocalizedstring(herostring));
				}
			}
		}
	#/
}

/*
	Name: codecallback_gunchallengecomplete
	Namespace: persistence
	Checksum: 0x4B56AA13
	Offset: 0x1C38
	Size: 0xC4
	Parameters: 5
	Flags: Linked
*/
function codecallback_gunchallengecomplete(rewardxp, attachmentindex, itemindex, rankid, islastrank)
{
	if(sessionmodeiscampaigngame())
	{
		self notify(#"gun_level_complete", rewardxp, attachmentindex, itemindex, rankid, islastrank);
		return;
	}
	self luinotifyevent(&"gun_level_complete", 4, rankid, itemindex, attachmentindex, rewardxp);
	self luinotifyeventtospectators(&"gun_level_complete", 4, rankid, itemindex, attachmentindex, rewardxp);
}

/*
	Name: check_contract_expirations
	Namespace: persistence
	Checksum: 0x99EC1590
	Offset: 0x1D08
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function check_contract_expirations()
{
}

/*
	Name: increment_contract_times
	Namespace: persistence
	Checksum: 0xDA1ECC9A
	Offset: 0x1D18
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function increment_contract_times(timeinc)
{
}

/*
	Name: add_contract_to_queue
	Namespace: persistence
	Checksum: 0x1CF34034
	Offset: 0x1D30
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function add_contract_to_queue(index, passed)
{
}

/*
	Name: upload_stats_soon
	Namespace: persistence
	Checksum: 0x2BFC891E
	Offset: 0x1D50
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function upload_stats_soon()
{
	self notify(#"upload_stats_soon");
	self endon(#"upload_stats_soon");
	self endon(#"disconnect");
	wait(1);
	uploadstats(self);
}

/*
	Name: codecallback_onaddplayerstat
	Namespace: persistence
	Checksum: 0x18C2EE21
	Offset: 0x1DA0
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function codecallback_onaddplayerstat(dataname, value)
{
}

/*
	Name: codecallback_onaddweaponstat
	Namespace: persistence
	Checksum: 0xA2AD2F60
	Offset: 0x1DC0
	Size: 0x1C
	Parameters: 3
	Flags: Linked
*/
function codecallback_onaddweaponstat(weapon, dataname, value)
{
}

/*
	Name: process_contracts_on_add_stat
	Namespace: persistence
	Checksum: 0xA75F9D15
	Offset: 0x1DE8
	Size: 0x24
	Parameters: 4
	Flags: None
*/
function process_contracts_on_add_stat(stattype, dataname, value, weapon)
{
}

