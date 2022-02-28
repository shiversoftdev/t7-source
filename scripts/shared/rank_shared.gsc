// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace rank;

/*
	Name: __init__sytem__
	Namespace: rank
	Checksum: 0xAD97CE6B
	Offset: 0x6E0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("rank", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: rank
	Checksum: 0x51E9FE91
	Offset: 0x720
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: rank
	Checksum: 0x6C7A32A6
	Offset: 0x750
	Size: 0x584
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.scoreinfo = [];
	level.codpointsxpscale = getdvarfloat("scr_codpointsxpscale");
	level.codpointsmatchscale = getdvarfloat("scr_codpointsmatchscale");
	level.codpointschallengescale = getdvarfloat("scr_codpointsperchallenge");
	level.rankxpcap = getdvarint("scr_rankXpCap");
	level.codpointscap = getdvarint("scr_codPointsCap");
	level.usingmomentum = 1;
	level.usingscorestreaks = getdvarint("scr_scorestreaks") != 0;
	level.scorestreaksmaxstacking = getdvarint("scr_scorestreaks_maxstacking");
	level.maxinventoryscorestreaks = getdvarint("scr_maxinventory_scorestreaks", 3);
	level.usingrampage = !isdefined(level.usingscorestreaks) || !level.usingscorestreaks;
	level.rampagebonusscale = getdvarfloat("scr_rampagebonusscale");
	level.ranktable = [];
	if(sessionmodeiscampaigngame())
	{
		level.xpscale = getdvarfloat("scr_xpscalecp");
		level.ranktable_name = "gamedata/tables/cp/cp_ranktable.csv";
		level.rankicontable_name = "gamedata/tables/cp/cp_rankIconTable.csv";
	}
	else
	{
		if(sessionmodeiszombiesgame())
		{
			level.xpscale = getdvarfloat("scr_xpscalezm");
			level.ranktable_name = "gamedata/tables/zm/zm_ranktable.csv";
			level.rankicontable_name = "gamedata/tables/zm/zm_rankIconTable.csv";
		}
		else
		{
			level.xpscale = getdvarfloat("scr_xpscalemp");
			level.ranktable_name = "gamedata/tables/mp/mp_ranktable.csv";
			level.rankicontable_name = "gamedata/tables/mp/mp_rankIconTable.csv";
		}
	}
	initscoreinfo();
	level.maxrank = int(tablelookup(level.ranktable_name, 0, "maxrank", 1));
	level.maxrankstarterpack = int(tablelookup(level.ranktable_name, 0, "maxrankstarterpack", 1));
	level.maxprestige = int(tablelookup(level.rankicontable_name, 0, "maxprestige", 1));
	rankid = 0;
	rankname = tablelookup(level.ranktable_name, 0, rankid, 1);
	/#
		assert(isdefined(rankname) && rankname != "");
	#/
	while(isdefined(rankname) && rankname != "")
	{
		level.ranktable[rankid][1] = tablelookup(level.ranktable_name, 0, rankid, 1);
		level.ranktable[rankid][2] = tablelookup(level.ranktable_name, 0, rankid, 2);
		level.ranktable[rankid][3] = tablelookup(level.ranktable_name, 0, rankid, 3);
		level.ranktable[rankid][7] = tablelookup(level.ranktable_name, 0, rankid, 7);
		level.ranktable[rankid][14] = tablelookup(level.ranktable_name, 0, rankid, 14);
		if(sessionmodeiscampaigngame())
		{
			level.ranktable[rankid][18] = tablelookup(level.ranktable_name, 0, rankid, 18);
		}
		rankid++;
		rankname = tablelookup(level.ranktable_name, 0, rankid, 1);
	}
	callback::on_connect(&on_player_connect);
}

/*
	Name: initscoreinfo
	Namespace: rank
	Checksum: 0xBB4AFA63
	Offset: 0xCE0
	Size: 0x56C
	Parameters: 0
	Flags: Linked
*/
function initscoreinfo()
{
	scoreinfotableid = scoreevents::getscoreeventtableid();
	/#
		assert(isdefined(scoreinfotableid));
	#/
	if(!isdefined(scoreinfotableid))
	{
		return;
	}
	scorecolumn = scoreevents::getscoreeventcolumn(level.gametype);
	xpcolumn = scoreevents::getxpeventcolumn(level.gametype);
	/#
		assert(scorecolumn >= 0);
	#/
	if(scorecolumn < 0)
	{
		return;
	}
	/#
		assert(xpcolumn >= 0);
	#/
	if(xpcolumn < 0)
	{
		return;
	}
	for(row = 1; row < 512; row++)
	{
		type = tablelookupcolumnforrow(scoreinfotableid, row, 0);
		if(type != "")
		{
			labelstring = tablelookupcolumnforrow(scoreinfotableid, row, 1);
			label = undefined;
			if(labelstring != "")
			{
				label = tablelookupistring(scoreinfotableid, 0, type, 1);
			}
			teamscorestring = tablelookupcolumnforrow(scoreinfotableid, row, 4);
			teamscore_material = undefined;
			if(teamscorestring != "")
			{
				teamscore_material = tablelookupistring(scoreinfotableid, 0, type, 4);
			}
			scorevalue = int(tablelookupcolumnforrow(scoreinfotableid, row, scorecolumn));
			xpvalue = int(tablelookupcolumnforrow(scoreinfotableid, row, xpcolumn));
			registerscoreinfo(type, scorevalue, xpvalue, label, teamscore_material);
			if(!isdefined(game["ScoreInfoInitialized"]))
			{
				xpvalue = float(tablelookupcolumnforrow(scoreinfotableid, row, xpcolumn));
				setddlstat = tablelookupcolumnforrow(scoreinfotableid, row, 8);
				addplayerstat = 0;
				if(setddlstat == "TRUE")
				{
					addplayerstat = 1;
				}
				ismedal = 0;
				istring = tablelookupistring(scoreinfotableid, 0, type, 2);
				if(isdefined(istring) && istring != (&""))
				{
					ismedal = 1;
				}
				demobookmarkpriority = int(tablelookupcolumnforrow(scoreinfotableid, row, 9));
				if(!isdefined(demobookmarkpriority))
				{
					demobookmarkpriority = 0;
				}
				registerxp(type, xpvalue, addplayerstat, ismedal, demobookmarkpriority, row);
			}
			allowkillstreakweapons = tablelookupcolumnforrow(scoreinfotableid, row, 5);
			if(allowkillstreakweapons == "TRUE")
			{
				level.scoreinfo[type]["allowKillstreakWeapons"] = 1;
			}
			allowhero = tablelookupcolumnforrow(scoreinfotableid, row, 7);
			if(allowhero == "TRUE")
			{
				level.scoreinfo[type]["allow_hero"] = 1;
			}
			combatefficiencyevent = tablelookupcolumnforrow(scoreinfotableid, row, 6);
			if(isdefined(combatefficiencyevent) && combatefficiencyevent != "")
			{
				level.scoreinfo[type]["combat_efficiency_event"] = combatefficiencyevent;
			}
		}
	}
	game["ScoreInfoInitialized"] = 1;
}

/*
	Name: getrankxpcapped
	Namespace: rank
	Checksum: 0xCA12B509
	Offset: 0x1258
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function getrankxpcapped(inrankxp)
{
	if(isdefined(level.rankxpcap) && level.rankxpcap && level.rankxpcap <= inrankxp)
	{
		return level.rankxpcap;
	}
	return inrankxp;
}

/*
	Name: getcodpointscapped
	Namespace: rank
	Checksum: 0x543DAEEB
	Offset: 0x12A0
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function getcodpointscapped(incodpoints)
{
	if(isdefined(level.codpointscap) && level.codpointscap && level.codpointscap <= incodpoints)
	{
		return level.codpointscap;
	}
	return incodpoints;
}

/*
	Name: registerscoreinfo
	Namespace: rank
	Checksum: 0x2F451C23
	Offset: 0x12E8
	Size: 0x1B0
	Parameters: 5
	Flags: Linked
*/
function registerscoreinfo(type, value, xp, label, teamscore_material)
{
	overridedvar = (("scr_" + level.gametype) + "_score_") + type;
	if(getdvarstring(overridedvar) != "")
	{
		value = getdvarint(overridedvar);
	}
	if(type == "kill")
	{
		multiplier = getgametypesetting("killEventScoreMultiplier");
		level.scoreinfo[type]["value"] = value;
		if(multiplier > 0)
		{
			level.scoreinfo[type]["value"] = int(multiplier * value);
		}
	}
	else
	{
		level.scoreinfo[type]["value"] = value;
	}
	level.scoreinfo[type]["xp"] = xp;
	if(isdefined(label))
	{
		level.scoreinfo[type]["label"] = label;
	}
	if(isdefined(teamscore_material))
	{
		level.scoreinfo[type]["team_icon"] = teamscore_material;
	}
}

/*
	Name: getscoreinfovalue
	Namespace: rank
	Checksum: 0x2645D314
	Offset: 0x14A0
	Size: 0x7A
	Parameters: 1
	Flags: Linked
*/
function getscoreinfovalue(type)
{
	if(isdefined(level.scoreinfo[type]))
	{
		n_score = level.scoreinfo[type]["value"];
		if(isdefined(level.scoremodifiercallback) && isdefined(n_score))
		{
			n_score = [[level.scoremodifiercallback]](type, n_score);
		}
		return n_score;
	}
}

/*
	Name: getscoreinfoxp
	Namespace: rank
	Checksum: 0x3CEB7265
	Offset: 0x1528
	Size: 0x7A
	Parameters: 1
	Flags: Linked
*/
function getscoreinfoxp(type)
{
	if(isdefined(level.scoreinfo[type]))
	{
		n_xp = level.scoreinfo[type]["xp"];
		if(isdefined(level.xpmodifiercallback) && isdefined(n_xp))
		{
			n_xp = [[level.xpmodifiercallback]](type, n_xp);
		}
		return n_xp;
	}
}

/*
	Name: shouldskipmomentumdisplay
	Namespace: rank
	Checksum: 0x2ADC181E
	Offset: 0x15B0
	Size: 0x58
	Parameters: 1
	Flags: None
*/
function shouldskipmomentumdisplay(type)
{
	if(isdefined(level.disablemomentum) && level.disablemomentum)
	{
		return true;
	}
	if(isdefined(level.teamscoreuicallback) && isdefined(level.scoreinfo[type]["team_icon"]))
	{
		return true;
	}
	return false;
}

/*
	Name: getscoreinfolabel
	Namespace: rank
	Checksum: 0x3A8619FD
	Offset: 0x1610
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function getscoreinfolabel(type)
{
	return level.scoreinfo[type]["label"];
}

/*
	Name: getcombatefficiencyevent
	Namespace: rank
	Checksum: 0x41CC360
	Offset: 0x1640
	Size: 0x22
	Parameters: 1
	Flags: None
*/
function getcombatefficiencyevent(type)
{
	return level.scoreinfo[type]["combat_efficiency_event"];
}

/*
	Name: doesscoreinfocounttowardrampage
	Namespace: rank
	Checksum: 0x859BA387
	Offset: 0x1670
	Size: 0x3E
	Parameters: 1
	Flags: None
*/
function doesscoreinfocounttowardrampage(type)
{
	return isdefined(level.scoreinfo[type]["rampage"]) && level.scoreinfo[type]["rampage"];
}

/*
	Name: getrankinfominxp
	Namespace: rank
	Checksum: 0xAE52A085
	Offset: 0x16B8
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function getrankinfominxp(rankid)
{
	return int(level.ranktable[rankid][2]);
}

/*
	Name: getrankinfoxpamt
	Namespace: rank
	Checksum: 0xA9D64B95
	Offset: 0x16F8
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function getrankinfoxpamt(rankid)
{
	return int(level.ranktable[rankid][3]);
}

/*
	Name: getrankinfomaxxp
	Namespace: rank
	Checksum: 0x2E3B73E9
	Offset: 0x1738
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function getrankinfomaxxp(rankid)
{
	return int(level.ranktable[rankid][7]);
}

/*
	Name: getrankinfofull
	Namespace: rank
	Checksum: 0x692D9C7D
	Offset: 0x1778
	Size: 0x2A
	Parameters: 1
	Flags: None
*/
function getrankinfofull(rankid)
{
	return tablelookupistring(level.ranktable_name, 0, rankid, 16);
}

/*
	Name: getrankinfoicon
	Namespace: rank
	Checksum: 0xC8ABBFC0
	Offset: 0x17B0
	Size: 0x3A
	Parameters: 2
	Flags: None
*/
function getrankinfoicon(rankid, prestigeid)
{
	return tablelookup(level.rankicontable_name, 0, rankid, prestigeid + 1);
}

/*
	Name: getrankinfolevel
	Namespace: rank
	Checksum: 0xBEDDB22C
	Offset: 0x17F8
	Size: 0x42
	Parameters: 1
	Flags: None
*/
function getrankinfolevel(rankid)
{
	return int(tablelookup(level.ranktable_name, 0, rankid, 13));
}

/*
	Name: getrankinfocodpointsearned
	Namespace: rank
	Checksum: 0x4FF70D3E
	Offset: 0x1848
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function getrankinfocodpointsearned(rankid)
{
	return int(tablelookup(level.ranktable_name, 0, rankid, 17));
}

/*
	Name: shouldkickbyrank
	Namespace: rank
	Checksum: 0x4140A883
	Offset: 0x1898
	Size: 0xBE
	Parameters: 0
	Flags: Linked
*/
function shouldkickbyrank()
{
	if(self ishost())
	{
		return false;
	}
	if(level.rankcap > 0 && self.pers["rank"] > level.rankcap)
	{
		return true;
	}
	if(level.rankcap > 0 && level.minprestige == 0 && self.pers["plevel"] > 0)
	{
		return true;
	}
	if(level.minprestige > self.pers["plevel"])
	{
		return true;
	}
	return false;
}

/*
	Name: getcodpointsstat
	Namespace: rank
	Checksum: 0xD867DB71
	Offset: 0x1960
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function getcodpointsstat()
{
	codpoints = self getdstat("playerstatslist", "CODPOINTS", "StatValue");
	codpointscapped = getcodpointscapped(codpoints);
	if(codpoints > codpointscapped)
	{
		self setcodpointsstat(codpointscapped);
	}
	return codpointscapped;
}

/*
	Name: setcodpointsstat
	Namespace: rank
	Checksum: 0xCC1A9CC
	Offset: 0x19F0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function setcodpointsstat(codpoints)
{
	self setdstat("PlayerStatsList", "CODPOINTS", "StatValue", getcodpointscapped(codpoints));
}

/*
	Name: getrankxpstat
	Namespace: rank
	Checksum: 0x5D49367
	Offset: 0x1A48
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function getrankxpstat()
{
	rankxp = self getdstat("playerstatslist", "RANKXP", "StatValue");
	rankxpcapped = getrankxpcapped(rankxp);
	if(rankxp > rankxpcapped)
	{
		self setdstat("playerstatslist", "RANKXP", "StatValue", rankxpcapped);
	}
	return rankxpcapped;
}

/*
	Name: getarenapointsstat
	Namespace: rank
	Checksum: 0x96D8F505
	Offset: 0x1AF0
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function getarenapointsstat()
{
	arenaslot = arenagetslot();
	arenapoints = self getdstat("arenaStats", arenaslot, "points");
	return arenapoints + 1;
}

/*
	Name: on_player_connect
	Namespace: rank
	Checksum: 0x41400E7B
	Offset: 0x1B60
	Size: 0x68C
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self.pers["rankxp"] = self getrankxpstat();
	self.pers["codpoints"] = self getcodpointsstat();
	self.pers["currencyspent"] = self getdstat("playerstatslist", "currencyspent", "StatValue");
	rankid = self getrankforxp(self getrankxp());
	self.pers["rank"] = rankid;
	self.pers["plevel"] = self getdstat("playerstatslist", "PLEVEL", "StatValue");
	if(self shouldkickbyrank())
	{
		kick(self getentitynumber());
		return;
	}
	if(!isdefined(self.pers["participation"]))
	{
		self.pers["participation"] = 0;
	}
	self.rankupdatetotal = 0;
	self.cur_ranknum = rankid;
	/#
		assert(isdefined(self.cur_ranknum), (("" + rankid) + "") + level.ranktable_name);
	#/
	prestige = self getdstat("playerstatslist", "plevel", "StatValue");
	self setrank(rankid, prestige);
	self.pers["prestige"] = prestige;
	if(sessionmodeismultiplayergame() && gamemodeisusingstats() || (sessionmodeiszombiesgame() && sessionmodeisonlinegame()))
	{
		paragonrank = self getdstat("playerstatslist", "paragon_rank", "StatValue");
		self setparagonrank(paragonrank);
		self.pers["paragonrank"] = paragonrank;
		paragoniconid = self getdstat("playerstatslist", "paragon_icon_id", "StatValue");
		self setparagoniconid(paragoniconid);
		self.pers["paragoniconid"] = paragoniconid;
	}
	if(!isdefined(self.pers["summary"]))
	{
		self.pers["summary"] = [];
		self.pers["summary"]["xp"] = 0;
		self.pers["summary"]["score"] = 0;
		self.pers["summary"]["challenge"] = 0;
		self.pers["summary"]["match"] = 0;
		self.pers["summary"]["misc"] = 0;
		self.pers["summary"]["codpoints"] = 0;
	}
	if(gamemodeismode(6) && !self util::is_bot())
	{
		arenapoints = self getarenapointsstat();
		arenapoints = int(min(arenapoints, 100));
		self.pers["arenapoints"] = arenapoints;
		self setarenapoints(arenapoints);
	}
	if(level.rankedmatch)
	{
		self setdstat("playerstatslist", "rank", "StatValue", rankid);
		self setdstat("playerstatslist", "minxp", "StatValue", getrankinfominxp(rankid));
		self setdstat("playerstatslist", "maxxp", "StatValue", getrankinfomaxxp(rankid));
		self setdstat("playerstatslist", "lastxp", "StatValue", getrankxpcapped(self.pers["rankxp"]));
	}
	self.explosivekills[0] = 0;
	callback::on_spawned(&on_player_spawned);
	callback::on_joined_team(&on_joined_team);
	callback::on_joined_spectate(&on_joined_spectators);
}

/*
	Name: on_joined_team
	Namespace: rank
	Checksum: 0x4EC3D9C4
	Offset: 0x21F8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function on_joined_team()
{
	self endon(#"disconnect");
	self thread removerankhud();
}

/*
	Name: on_joined_spectators
	Namespace: rank
	Checksum: 0x51D8B29
	Offset: 0x2228
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function on_joined_spectators()
{
	self endon(#"disconnect");
	self thread removerankhud();
}

/*
	Name: on_player_spawned
	Namespace: rank
	Checksum: 0x57EF742D
	Offset: 0x2258
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self endon(#"disconnect");
	if(!isdefined(self.hud_rankscroreupdate))
	{
		self.hud_rankscroreupdate = newscorehudelem(self);
		self.hud_rankscroreupdate.horzalign = "center";
		self.hud_rankscroreupdate.vertalign = "middle";
		self.hud_rankscroreupdate.alignx = "center";
		self.hud_rankscroreupdate.aligny = "middle";
		self.hud_rankscroreupdate.x = 0;
		if(self issplitscreen())
		{
			self.hud_rankscroreupdate.y = -15;
		}
		else
		{
			self.hud_rankscroreupdate.y = -60;
		}
		self.hud_rankscroreupdate.font = "default";
		self.hud_rankscroreupdate.fontscale = 2;
		self.hud_rankscroreupdate.archived = 0;
		self.hud_rankscroreupdate.color = (1, 1, 0.5);
		self.hud_rankscroreupdate.alpha = 0;
		self.hud_rankscroreupdate.sort = 50;
		self.hud_rankscroreupdate hud::font_pulse_init();
	}
}

/*
	Name: inccodpoints
	Namespace: rank
	Checksum: 0x11480C1D
	Offset: 0x2400
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function inccodpoints(amount)
{
	if(!util::isrankenabled())
	{
		return;
	}
	if(!level.rankedmatch)
	{
		return;
	}
	newcodpoints = getcodpointscapped(self.pers["codpoints"] + amount);
	if(newcodpoints > self.pers["codpoints"])
	{
		self.pers["summary"]["codpoints"] = self.pers["summary"]["codpoints"] + (newcodpoints - self.pers["codpoints"]);
	}
	self.pers["codpoints"] = newcodpoints;
	setcodpointsstat(int(newcodpoints));
}

/*
	Name: atleastoneplayeroneachteam
	Namespace: rank
	Checksum: 0xCB10DC5B
	Offset: 0x2518
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function atleastoneplayeroneachteam()
{
	foreach(team in level.teams)
	{
		if(!level.playercount[team])
		{
			return false;
		}
	}
	return true;
}

/*
	Name: giverankxp
	Namespace: rank
	Checksum: 0x5FEF201E
	Offset: 0x25B0
	Size: 0x66C
	Parameters: 3
	Flags: None
*/
function giverankxp(type, value, devadd)
{
	self endon(#"disconnect");
	if(sessionmodeiszombiesgame())
	{
		return;
	}
	if(level.teambased && !atleastoneplayeroneachteam() && !isdefined(devadd))
	{
		return;
	}
	if(!level.teambased && util::totalplayercount() < 2 && !isdefined(devadd))
	{
		return;
	}
	if(!util::isrankenabled())
	{
		return;
	}
	pixbeginevent("giveRankXP");
	if(!isdefined(value))
	{
		value = getscoreinfovalue(type);
	}
	if(level.rankedmatch)
	{
		bbprint("mpplayerxp", "gametime %d, player %s, type %s, delta %d", gettime(), self.name, type, value);
	}
	switch(type)
	{
		case "assault":
		case "assault_assist":
		case "assist":
		case "assist_25":
		case "assist_50":
		case "assist_75":
		case "capture":
		case "defend":
		case "defuse":
		case "destroyer":
		case "dogassist":
		case "dogkill":
		case "headshot":
		case "helicopterassist":
		case "helicopterassist_25":
		case "helicopterassist_50":
		case "helicopterassist_75":
		case "helicopterkill":
		case "kill":
		case "medal":
		case "pickup":
		case "plant":
		case "rcbombdestroy":
		case "return":
		case "revive":
		case "spyplaneassist":
		case "spyplanekill":
		{
			value = int(value * level.xpscale);
			break;
		}
		default:
		{
			if(level.xpscale == 0)
			{
				value = 0;
			}
			break;
		}
	}
	xpincrease = self incrankxp(value);
	if(level.rankedmatch)
	{
		self updaterank();
	}
	if(value != 0)
	{
		self syncxpstat();
	}
	if(isdefined(self.enabletext) && self.enabletext && !level.hardcoremode)
	{
		if(type == "teamkill")
		{
			self thread updaterankscorehud(0 - getscoreinfovalue("kill"));
		}
		else
		{
			self thread updaterankscorehud(value);
		}
	}
	switch(type)
	{
		case "assault":
		case "assist":
		case "assist_25":
		case "assist_50":
		case "assist_75":
		case "capture":
		case "defend":
		case "headshot":
		case "helicopterassist":
		case "helicopterassist_25":
		case "helicopterassist_50":
		case "helicopterassist_75":
		case "kill":
		case "medal":
		case "pickup":
		case "return":
		case "revive":
		case "suicide":
		case "teamkill":
		{
			self.pers["summary"]["score"] = self.pers["summary"]["score"] + value;
			inccodpoints(round_this_number(value * level.codpointsxpscale));
			break;
		}
		case "loss":
		case "tie":
		case "win":
		{
			self.pers["summary"]["match"] = self.pers["summary"]["match"] + value;
			inccodpoints(round_this_number(value * level.codpointsmatchscale));
			break;
		}
		case "challenge":
		{
			self.pers["summary"]["challenge"] = self.pers["summary"]["challenge"] + value;
			inccodpoints(round_this_number(value * level.codpointschallengescale));
			break;
		}
		default:
		{
			self.pers["summary"]["misc"] = self.pers["summary"]["misc"] + value;
			self.pers["summary"]["match"] = self.pers["summary"]["match"] + value;
			inccodpoints(round_this_number(value * level.codpointsmatchscale));
			break;
		}
	}
	self.pers["summary"]["xp"] = self.pers["summary"]["xp"] + xpincrease;
	pixendevent();
}

/*
	Name: round_this_number
	Namespace: rank
	Checksum: 0xF5305A17
	Offset: 0x2C28
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function round_this_number(value)
{
	value = int(value + 0.5);
	return value;
}

/*
	Name: updaterank
	Namespace: rank
	Checksum: 0x6E180D2B
	Offset: 0x2C68
	Size: 0x310
	Parameters: 0
	Flags: Linked
*/
function updaterank()
{
	newrankid = self getrank();
	if(newrankid == self.pers["rank"])
	{
		return false;
	}
	oldrank = self.pers["rank"];
	rankid = self.pers["rank"];
	self.pers["rank"] = newrankid;
	while(rankid <= newrankid)
	{
		self setdstat("playerstatslist", "rank", "StatValue", rankid);
		self setdstat("playerstatslist", "minxp", "StatValue", int(level.ranktable[rankid][2]));
		self setdstat("playerstatslist", "maxxp", "StatValue", int(level.ranktable[rankid][7]));
		self.setpromotion = 1;
		if(level.rankedmatch && level.gameended && !self issplitscreen())
		{
			self setdstat("AfterActionReportStats", "lobbyPopup", "promotion");
		}
		if(rankid != oldrank)
		{
			codpointsearnedforrank = getrankinfocodpointsearned(rankid);
			inccodpoints(codpointsearnedforrank);
			if(!isdefined(self.pers["rankcp"]))
			{
				self.pers["rankcp"] = 0;
			}
			self.pers["rankcp"] = self.pers["rankcp"] + codpointsearnedforrank;
		}
		rankid++;
	}
	/#
		print((((("" + oldrank) + "") + newrankid) + "") + self getdstat("", "", ""));
	#/
	self setrank(newrankid);
	return true;
}

/*
	Name: codecallback_rankup
	Namespace: rank
	Checksum: 0x627FFA57
	Offset: 0x2F80
	Size: 0x198
	Parameters: 3
	Flags: Linked
*/
function codecallback_rankup(rank, prestige, unlocktokensadded)
{
	if(sessionmodeiscampaigngame())
	{
		n_extra_tokens = level.ranktable[rank][18];
		if(isdefined(n_extra_tokens) && n_extra_tokens != "")
		{
			self giveunlocktoken(int(n_extra_tokens));
		}
		uploadstats(self);
		return;
	}
	if(sessionmodeismultiplayergame())
	{
		if(rank > 53)
		{
			self giveachievement("MP_REACH_ARENA");
		}
		if(rank > 8)
		{
			self giveachievement("MP_REACH_SERGEANT");
		}
	}
	self luinotifyevent(&"rank_up", 3, rank, prestige, unlocktokensadded);
	self luinotifyeventtospectators(&"rank_up", 3, rank, prestige, unlocktokensadded);
	if(isdefined(level.playpromotionreaction))
	{
		self thread [[level.playpromotionreaction]]();
	}
}

/*
	Name: getitemindex
	Namespace: rank
	Checksum: 0x1A2D6973
	Offset: 0x3120
	Size: 0xA8
	Parameters: 1
	Flags: None
*/
function getitemindex(refstring)
{
	statstablename = util::getstatstablename();
	itemindex = int(tablelookup(statstablename, 4, refstring, 0));
	/#
		assert(itemindex > 0, (("" + refstring) + "") + itemindex);
	#/
	return itemindex;
}

/*
	Name: endgameupdate
	Namespace: rank
	Checksum: 0xC8810436
	Offset: 0x31D0
	Size: 0x14
	Parameters: 0
	Flags: None
*/
function endgameupdate()
{
	player = self;
}

/*
	Name: updaterankscorehud
	Namespace: rank
	Checksum: 0xD49D78CD
	Offset: 0x31F0
	Size: 0x1BC
	Parameters: 1
	Flags: Linked
*/
function updaterankscorehud(amount)
{
	self endon(#"disconnect");
	self endon(#"joined_team");
	self endon(#"joined_spectators");
	if(isdefined(level.usingmomentum) && level.usingmomentum)
	{
		return;
	}
	if(amount == 0)
	{
		return;
	}
	self notify(#"update_score");
	self endon(#"update_score");
	self.rankupdatetotal = self.rankupdatetotal + amount;
	wait(0.05);
	if(isdefined(self.hud_rankscroreupdate))
	{
		if(self.rankupdatetotal < 0)
		{
			self.hud_rankscroreupdate.label = &"";
			self.hud_rankscroreupdate.color = (0.73, 0.19, 0.19);
		}
		else
		{
			self.hud_rankscroreupdate.label = &"MP_PLUS";
			self.hud_rankscroreupdate.color = (1, 1, 0.5);
		}
		self.hud_rankscroreupdate setvalue(self.rankupdatetotal);
		self.hud_rankscroreupdate.alpha = 0.85;
		self.hud_rankscroreupdate thread hud::font_pulse(self);
		wait(1);
		self.hud_rankscroreupdate fadeovertime(0.75);
		self.hud_rankscroreupdate.alpha = 0;
		self.rankupdatetotal = 0;
	}
}

/*
	Name: updatemomentumhud
	Namespace: rank
	Checksum: 0xCA282A52
	Offset: 0x33B8
	Size: 0x2EC
	Parameters: 3
	Flags: None
*/
function updatemomentumhud(amount, reason, reasonvalue)
{
	self endon(#"disconnect");
	self endon(#"joined_team");
	self endon(#"joined_spectators");
	if(amount == 0)
	{
		return;
	}
	self notify(#"update_score");
	self endon(#"update_score");
	self.rankupdatetotal = self.rankupdatetotal + amount;
	if(isdefined(self.hud_rankscroreupdate))
	{
		if(self.rankupdatetotal < 0)
		{
			self.hud_rankscroreupdate.label = &"";
			self.hud_rankscroreupdate.color = (0.73, 0.19, 0.19);
		}
		else
		{
			self.hud_rankscroreupdate.label = &"MP_PLUS";
			self.hud_rankscroreupdate.color = (1, 1, 0.5);
		}
		self.hud_rankscroreupdate setvalue(self.rankupdatetotal);
		self.hud_rankscroreupdate.alpha = 0.85;
		self.hud_rankscroreupdate thread hud::font_pulse(self);
		if(isdefined(self.hud_momentumreason))
		{
			if(isdefined(reason))
			{
				if(isdefined(reasonvalue))
				{
					self.hud_momentumreason.label = reason;
					self.hud_momentumreason setvalue(reasonvalue);
				}
				else
				{
					self.hud_momentumreason.label = reason;
					self.hud_momentumreason setvalue(amount);
				}
				self.hud_momentumreason.alpha = 0.85;
				self.hud_momentumreason thread hud::font_pulse(self);
			}
			else
			{
				self.hud_momentumreason fadeovertime(0.01);
				self.hud_momentumreason.alpha = 0;
			}
		}
		wait(1);
		self.hud_rankscroreupdate fadeovertime(0.75);
		self.hud_rankscroreupdate.alpha = 0;
		if(isdefined(self.hud_momentumreason) && isdefined(reason))
		{
			self.hud_momentumreason fadeovertime(0.75);
			self.hud_momentumreason.alpha = 0;
		}
		wait(0.75);
		self.rankupdatetotal = 0;
	}
}

/*
	Name: removerankhud
	Namespace: rank
	Checksum: 0x1F443B49
	Offset: 0x36B0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function removerankhud()
{
	if(isdefined(self.hud_rankscroreupdate))
	{
		self.hud_rankscroreupdate.alpha = 0;
	}
	if(isdefined(self.hud_momentumreason))
	{
		self.hud_momentumreason.alpha = 0;
	}
}

/*
	Name: getrank
	Namespace: rank
	Checksum: 0x359B8374
	Offset: 0x3700
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function getrank()
{
	rankxp = getrankxpcapped(self.pers["rankxp"]);
	rankid = self.pers["rank"];
	if(rankxp < (getrankinfominxp(rankid) + getrankinfoxpamt(rankid)))
	{
		return rankid;
	}
	return self getrankforxp(rankxp);
}

/*
	Name: getrankforxp
	Namespace: rank
	Checksum: 0xE146AE37
	Offset: 0x37C0
	Size: 0x106
	Parameters: 1
	Flags: Linked
*/
function getrankforxp(xpval)
{
	rankid = 0;
	rankname = level.ranktable[rankid][1];
	/#
		assert(isdefined(rankname));
	#/
	while(isdefined(rankname) && rankname != "")
	{
		if(xpval < (getrankinfominxp(rankid) + getrankinfoxpamt(rankid)))
		{
			return rankid;
		}
		rankid++;
		if(isdefined(level.ranktable[rankid]))
		{
			rankname = level.ranktable[rankid][1];
		}
		else
		{
			rankname = undefined;
		}
	}
	rankid--;
	return rankid;
}

/*
	Name: getspm
	Namespace: rank
	Checksum: 0x5C7CF053
	Offset: 0x38D0
	Size: 0x48
	Parameters: 0
	Flags: None
*/
function getspm()
{
	ranklevel = self getrank() + 1;
	return (3 + (ranklevel * 0.5)) * 10;
}

/*
	Name: getrankxp
	Namespace: rank
	Checksum: 0xA3C8BB4A
	Offset: 0x3920
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function getrankxp()
{
	return getrankxpcapped(self.pers["rankxp"]);
}

/*
	Name: incrankxp
	Namespace: rank
	Checksum: 0xD911516E
	Offset: 0x3958
	Size: 0x1AA
	Parameters: 1
	Flags: Linked
*/
function incrankxp(amount)
{
	if(!level.rankedmatch)
	{
		return 0;
	}
	xp = self getrankxp();
	newxp = getrankxpcapped(xp + amount);
	if(self.pers["rank"] == level.maxrank && newxp >= getrankinfomaxxp(level.maxrank))
	{
		newxp = getrankinfomaxxp(level.maxrank);
	}
	if(self isstarterpack() && self.pers["rank"] >= level.maxrankstarterpack && newxp >= getrankinfominxp(level.maxrankstarterpack))
	{
		newxp = getrankinfominxp(level.maxrankstarterpack);
	}
	xpincrease = getrankxpcapped(newxp) - self.pers["rankxp"];
	if(xpincrease < 0)
	{
		xpincrease = 0;
	}
	self.pers["rankxp"] = getrankxpcapped(newxp);
	return xpincrease;
}

/*
	Name: syncxpstat
	Namespace: rank
	Checksum: 0xFC596716
	Offset: 0x3B10
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function syncxpstat()
{
	xp = getrankxpcapped(self getrankxp());
	cp = getcodpointscapped(int(self.pers["codpoints"]));
	self setdstat("playerstatslist", "rankxp", "StatValue", xp);
	self setdstat("playerstatslist", "codpoints", "StatValue", cp);
}

