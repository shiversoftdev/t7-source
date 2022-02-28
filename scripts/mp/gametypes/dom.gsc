// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\teams\_teams;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\math_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;

#namespace dom;

/*
	Name: main
	Namespace: dom
	Checksum: 0xCE9C7C6C
	Offset: 0xDF8
	Size: 0x564
	Parameters: 0
	Flags: None
*/
function main()
{
	globallogic::init();
	util::registertimelimit(0, 1440);
	util::registerscorelimit(0, 2000);
	util::registerroundscorelimit(0, 2000);
	util::registerroundlimit(0, 10);
	util::registerroundwinlimit(0, 10);
	util::registerroundswitch(0, 9);
	util::registernumlives(0, 100);
	globallogic::registerfriendlyfiredelay(level.gametype, 15, 0, 1440);
	level.scoreroundwinbased = getgametypesetting("cumulativeRoundScores") == 0;
	level.teambased = 1;
	level.overrideteamscore = 1;
	level.onstartgametype = &onstartgametype;
	level.onplayerkilled = &onplayerkilled;
	level.onroundswitch = &onroundswitch;
	level.onprecachegametype = &onprecachegametype;
	level.onendgame = &onendgame;
	level.onroundendgame = &onroundendgame;
	gameobjects::register_allowed_gameobject(level.gametype);
	globallogic_audio::set_leader_gametype_dialog("startDomination", "hcStartDomination", "objCapture", "objCapture");
	game["dialog"]["securing_a"] = "domFriendlySecuringA";
	game["dialog"]["securing_b"] = "domFriendlySecuringB";
	game["dialog"]["securing_c"] = "domFriendlySecuringC";
	game["dialog"]["secured_a"] = "domFriendlySecuredA";
	game["dialog"]["secured_b"] = "domFriendlySecuredB";
	game["dialog"]["secured_c"] = "domFriendlySecuredC";
	game["dialog"]["secured_all"] = "domFriendlySecuredAll";
	game["dialog"]["losing_a"] = "domEnemySecuringA";
	game["dialog"]["losing_b"] = "domEnemySecuringB";
	game["dialog"]["losing_c"] = "domEnemySecuringC";
	game["dialog"]["lost_a"] = "domEnemySecuredA";
	game["dialog"]["lost_b"] = "domEnemySecuredB";
	game["dialog"]["lost_c"] = "domEnemySecuredC";
	game["dialog"]["lost_all"] = "domEnemySecuredAll";
	game["dialog"]["enemy_a"] = "domEnemyHasA";
	game["dialog"]["enemy_b"] = "domEnemyHasB";
	game["dialog"]["enemy_c"] = "domEnemyHasC";
	game["dialogTime"] = [];
	game["dialogTime"]["securing_a"] = 0;
	game["dialogTime"]["securing_b"] = 0;
	game["dialogTime"]["securing_c"] = 0;
	game["dialogTime"]["losing_a"] = 0;
	game["dialogTime"]["losing_b"] = 0;
	game["dialogTime"]["losing_c"] = 0;
	if(!sessionmodeissystemlink() && !sessionmodeisonlinegame() && issplitscreen())
	{
		globallogic::setvisiblescoreboardcolumns("score", "kills", "captures", "defends", "deaths");
	}
	else
	{
		globallogic::setvisiblescoreboardcolumns("score", "kills", "deaths", "captures", "defends");
	}
}

/*
	Name: onprecachegametype
	Namespace: dom
	Checksum: 0x99EC1590
	Offset: 0x1368
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function onprecachegametype()
{
}

/*
	Name: onstartgametype
	Namespace: dom
	Checksum: 0x8D25F54E
	Offset: 0x1378
	Size: 0x49C
	Parameters: 0
	Flags: Linked
*/
function onstartgametype()
{
	util::setobjectivetext("allies", &"OBJECTIVES_DOM");
	util::setobjectivetext("axis", &"OBJECTIVES_DOM");
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
	if(level.splitscreen)
	{
		util::setobjectivescoretext("allies", &"OBJECTIVES_DOM");
		util::setobjectivescoretext("axis", &"OBJECTIVES_DOM");
	}
	else
	{
		util::setobjectivescoretext("allies", &"OBJECTIVES_DOM_SCORE");
		util::setobjectivescoretext("axis", &"OBJECTIVES_DOM_SCORE");
	}
	util::setobjectivehinttext("allies", &"OBJECTIVES_DOM_HINT");
	util::setobjectivehinttext("axis", &"OBJECTIVES_DOM_HINT");
	level.flagbasefxid = [];
	setclientnamemode("auto_change");
	spawning::create_map_placed_influencers();
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	spawnlogic::place_spawn_points("mp_dom_spawn_allies_start");
	spawnlogic::place_spawn_points("mp_dom_spawn_axis_start");
	level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
	setmapcenter(level.mapcenter);
	spawnpoint = spawnlogic::get_random_intermission_point();
	setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
	level.spawn_all = spawnlogic::get_spawnpoint_array("mp_dom_spawn");
	level.spawn_start = [];
	foreach(team in level.teams)
	{
		level.spawn_start[team] = spawnlogic::get_spawnpoint_array(("mp_dom_spawn_" + team) + "_start");
	}
	flagspawns = spawnlogic::get_spawnpoint_array("mp_dom_spawn_flag_a");
	level.startpos["allies"] = level.spawn_start["allies"][0].origin;
	level.startpos["axis"] = level.spawn_start["axis"][0].origin;
	if(!util::isoneround() && level.scoreroundwinbased)
	{
		globallogic_score::resetteamscores();
	}
	level.spawnsystem.sideswitching = 0;
	level thread watchforbflagcap();
	updategametypedvars();
	thread domflags();
	thread updatedomscores();
	level change_dom_spawns();
}

/*
	Name: onendgame
	Namespace: dom
	Checksum: 0x73BF81A1
	Offset: 0x1820
	Size: 0xF6
	Parameters: 1
	Flags: Linked
*/
function onendgame(winningteam)
{
	for(i = 0; i < level.domflags.size; i++)
	{
		domflag = level.domflags[i];
		domflag gameobjects::allow_use("none");
		if(isdefined(domflag.singleowner) && domflag.singleowner == 1)
		{
			team = domflag gameobjects::get_owner_team();
			label = domflag gameobjects::get_label();
			challenges::holdflagentirematch(team, label);
		}
	}
}

/*
	Name: onroundendgame
	Namespace: dom
	Checksum: 0x5DBAF02A
	Offset: 0x1920
	Size: 0xB6
	Parameters: 1
	Flags: Linked
*/
function onroundendgame(roundwinner)
{
	if(level.scoreroundwinbased)
	{
		foreach(team in level.teams)
		{
			[[level._setteamscore]](team, game["roundswon"][team]);
		}
	}
	return [[level.determinewinner]]();
}

/*
	Name: updategametypedvars
	Namespace: dom
	Checksum: 0xFE35DF6A
	Offset: 0x19E0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function updategametypedvars()
{
	level.flagcapturetime = getgametypesetting("captureTime");
	level.playercapturelpm = getgametypesetting("maxPlayerEventsPerMinute");
	level.flagcapturelpm = getgametypesetting("maxObjectiveEventsPerMinute");
	level.playeroffensivemax = getgametypesetting("maxPlayerOffensive");
	level.playerdefensivemax = getgametypesetting("maxPlayerDefensive");
	level.flagcanbeneutralized = getgametypesetting("flagCanBeNeutralized");
}

/*
	Name: domflags
	Namespace: dom
	Checksum: 0xCA0DCB98
	Offset: 0x1AB0
	Size: 0x7E4
	Parameters: 0
	Flags: Linked
*/
function domflags()
{
	level.laststatus["allies"] = 0;
	level.laststatus["axis"] = 0;
	level.flagmodel["allies"] = "tag_origin";
	level.flagmodel["axis"] = "tag_origin";
	level.flagmodel["neutral"] = "tag_origin";
	primaryflags = getentarray("flag_primary", "targetname");
	if(primaryflags.size < 2)
	{
		/#
			println("");
		#/
		callback::abort_level();
		return;
	}
	level.flags = [];
	foreach(dom_flag in primaryflags)
	{
		if(isdefined(dom_flag.target))
		{
			trigger = getent(dom_flag.target, "targetname");
			if(isdefined(trigger))
			{
				trigger.visual = dom_flag;
				trigger.script_label = dom_flag.script_label;
			}
			else
			{
				/#
					util::error((("" + dom_flag.script_label) + "") + dom_flag.target);
				#/
			}
		}
		else
		{
			/#
				util::error("" + dom_flag.script_label);
			#/
		}
		level.flags[level.flags.size] = trigger;
	}
	level.domflags = [];
	foreach(trigger in level.flags)
	{
		trigger.visual setmodel(level.flagmodel["neutral"]);
		name = istring("dom" + trigger.visual.script_label);
		visuals = [];
		visuals[0] = trigger.visual;
		domflag = gameobjects::create_use_object("neutral", trigger, visuals, (0, 0, 0), name);
		domflag gameobjects::allow_use("enemy");
		if(level.flagcanbeneutralized)
		{
			domflag gameobjects::set_use_time(level.flagcapturetime / 2);
		}
		else
		{
			domflag gameobjects::set_use_time(level.flagcapturetime);
		}
		domflag gameobjects::set_use_text(&"MP_CAPTURING_FLAG");
		label = domflag gameobjects::get_label();
		domflag.label = label;
		domflag.flagindex = trigger.visual.script_index;
		domflag gameobjects::set_visible_team("any");
		domflag.onuse = &onuse;
		domflag.onbeginuse = &onbeginuse;
		domflag.onuseupdate = &onuseupdate;
		domflag.onenduse = &onenduse;
		domflag.onupdateuserate = &onupdateuserate;
		domflag.hasbeencaptured = 0;
		domflag gameobjects::set_objective_entity(visuals[0]);
		domflag gameobjects::set_owner_team("neutral");
		tracestart = visuals[0].origin + vectorscale((0, 0, 1), 32);
		traceend = visuals[0].origin + (vectorscale((0, 0, -1), 32));
		trace = bullettrace(tracestart, traceend, 0, undefined);
		upangles = vectortoangles(trace["normal"]);
		domflag.baseeffectforward = anglestoforward(upangles);
		domflag.baseeffectright = anglestoright(upangles);
		domflag.baseeffectpos = trace["position"];
		trigger.useobj = domflag;
		trigger.adjflags = [];
		trigger.nearbyspawns = [];
		domflag.levelflag = trigger;
		level.domflags[level.domflags.size] = domflag;
	}
	level.bestspawnflag = [];
	level.bestspawnflag["allies"] = getunownedflagneareststart("allies", undefined);
	level.bestspawnflag["axis"] = getunownedflagneareststart("axis", level.bestspawnflag["allies"]);
	for(index = 0; index < level.domflags.size; index++)
	{
		level.domflags[index] createflagspawninfluencers();
	}
	flagsetup();
	/#
		thread domdebug();
	#/
}

/*
	Name: getunownedflagneareststart
	Namespace: dom
	Checksum: 0x508061E7
	Offset: 0x22A0
	Size: 0x12E
	Parameters: 2
	Flags: Linked
*/
function getunownedflagneareststart(team, excludeflag)
{
	best = undefined;
	bestdistsq = undefined;
	for(i = 0; i < level.flags.size; i++)
	{
		flag = level.flags[i];
		if(flag getflagteam() != "neutral")
		{
			continue;
		}
		distsq = distancesquared(flag.origin, level.startpos[team]);
		if(!isdefined(excludeflag) || flag != excludeflag && (!isdefined(best) || distsq < bestdistsq))
		{
			bestdistsq = distsq;
			best = flag;
		}
	}
	return best;
}

/*
	Name: domdebug
	Namespace: dom
	Checksum: 0x3486B113
	Offset: 0x23D8
	Size: 0x288
	Parameters: 0
	Flags: Linked
*/
function domdebug()
{
	/#
		while(true)
		{
			if(getdvarstring("") != "")
			{
				wait(2);
				continue;
			}
			while(true)
			{
				if(getdvarstring("") != "")
				{
					break;
				}
				for(i = 0; i < level.flags.size; i++)
				{
					for(j = 0; j < level.flags[i].adjflags.size; j++)
					{
						line(level.flags[i].origin, level.flags[i].adjflags[j].origin, (1, 1, 1));
					}
					for(j = 0; j < level.flags[i].nearbyspawns.size; j++)
					{
						line(level.flags[i].origin, level.flags[i].nearbyspawns[j].origin, (0.2, 0.2, 0.6));
					}
					if(level.flags[i] == level.bestspawnflag[""])
					{
						print3d(level.flags[i].origin, "");
					}
					if(level.flags[i] == level.bestspawnflag[""])
					{
						print3d(level.flags[i].origin, "");
					}
				}
				wait(0.05);
			}
		}
	#/
}

/*
	Name: onbeginuse
	Namespace: dom
	Checksum: 0x7B18B183
	Offset: 0x2668
	Size: 0xFE
	Parameters: 1
	Flags: Linked
*/
function onbeginuse(player)
{
	ownerteam = self gameobjects::get_owner_team();
	self.didstatusnotify = 0;
	if(ownerteam == "allies")
	{
		otherteam = "axis";
	}
	else
	{
		otherteam = "allies";
	}
	if(ownerteam == "neutral")
	{
		otherteam = util::getotherteam(player.pers["team"]);
		statusdialog("securing" + self.label, player.pers["team"], "objective" + self.label);
		return;
	}
}

/*
	Name: onuseupdate
	Namespace: dom
	Checksum: 0xED96CCF9
	Offset: 0x2770
	Size: 0x168
	Parameters: 3
	Flags: Linked
*/
function onuseupdate(team, progress, change)
{
	if(progress > 0.05 && change && !self.didstatusnotify)
	{
		ownerteam = self gameobjects::get_owner_team();
		if(ownerteam == "neutral")
		{
			otherteam = util::getotherteam(team);
			statusdialog("securing" + self.label, team, "objective" + self.label);
		}
		else
		{
			statusdialog("losing" + self.label, ownerteam, "objective" + self.label);
			statusdialog("securing" + self.label, team, "objective" + self.label);
			globallogic_audio::flush_objective_dialog("objective_all");
		}
		self.didstatusnotify = 1;
	}
}

/*
	Name: flushobjectiveflagdialog
	Namespace: dom
	Checksum: 0xEA65F701
	Offset: 0x28E0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function flushobjectiveflagdialog()
{
	globallogic_audio::flush_objective_dialog("objective_a");
	globallogic_audio::flush_objective_dialog("objective_b");
	globallogic_audio::flush_objective_dialog("objective_c");
}

/*
	Name: statusdialog
	Namespace: dom
	Checksum: 0x3C842EE5
	Offset: 0x2938
	Size: 0xF4
	Parameters: 3
	Flags: Linked
*/
function statusdialog(dialog, team, objectivekey)
{
	dialogtime = game["dialogTime"][dialog];
	if(isdefined(dialogtime))
	{
		time = gettime();
		if(dialogtime > time)
		{
			return;
		}
		game["dialogTime"][dialog] = time + 10000;
	}
	dialogkey = game["dialog"][dialog];
	if(isdefined(objectivekey))
	{
		if(objectivekey != "objective_all")
		{
			dialogbufferkey = "domPointDialogBuffer";
		}
	}
	globallogic_audio::leader_dialog(dialogkey, team, undefined, objectivekey, undefined, dialogbufferkey);
}

/*
	Name: onenduse
	Namespace: dom
	Checksum: 0x2D2D1980
	Offset: 0x2A38
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function onenduse(team, player, success)
{
	if(!success)
	{
		globallogic_audio::flush_objective_dialog("objective" + self.label);
	}
}

/*
	Name: flagcapturedfromneutral
	Namespace: dom
	Checksum: 0x92960FF0
	Offset: 0x2A90
	Size: 0x1E4
	Parameters: 1
	Flags: Linked
*/
function flagcapturedfromneutral(team)
{
	self.singleowner = 1;
	otherteam = util::getotherteam(team);
	thread util::printandsoundoneveryone(team, undefined, &"", undefined, "mp_war_objective_taken");
	thread sound::play_on_players(("mus_dom_captured" + "_") + level.teampostfix[team]);
	if(getteamflagcount(team) == level.flags.size)
	{
		statusdialog("secured_all", team, "objective_all");
		statusdialog("lost_all", otherteam, "objective_all");
		flushobjectiveflagdialog();
	}
	else
	{
		statusdialog("secured" + self.label, team, "objective" + self.label);
		statusdialog("enemy" + self.label, otherteam, "objective" + self.label);
		globallogic_audio::flush_objective_dialog("objective_all");
		globallogic_audio::play_2d_on_team("mpl_flagcapture_sting_enemy", otherteam);
		globallogic_audio::play_2d_on_team("mpl_flagcapture_sting_friend", team);
	}
}

/*
	Name: flagcapturedfromteam
	Namespace: dom
	Checksum: 0xE7ED2D85
	Offset: 0x2C80
	Size: 0x222
	Parameters: 2
	Flags: Linked
*/
function flagcapturedfromteam(team, oldteam)
{
	self.singleowner = 0;
	thread util::printandsoundoneveryone(team, oldteam, &"", &"", "mp_war_objective_taken", "mp_war_objective_lost", "");
	if(getteamflagcount(team) == level.flags.size)
	{
		statusdialog("secured_all", team, "objective_all");
		statusdialog("lost_all", oldteam, "objective_all");
		flushobjectiveflagdialog();
	}
	else
	{
		statusdialog("secured" + self.label, team, "objective" + self.label);
		if(randomint(2))
		{
			statusdialog("lost" + self.label, oldteam, "objective" + self.label);
		}
		else
		{
			statusdialog("enemy" + self.label, oldteam, "objective" + self.label);
		}
		globallogic_audio::flush_objective_dialog("objective_all");
		globallogic_audio::play_2d_on_team("mpl_flagcapture_sting_enemy", oldteam);
		globallogic_audio::play_2d_on_team("mpl_flagcapture_sting_friend", team);
	}
	level.bestspawnflag[oldteam] = self.levelflag;
}

/*
	Name: flagneutralized
	Namespace: dom
	Checksum: 0xA5E57FBD
	Offset: 0x2EB0
	Size: 0x134
	Parameters: 2
	Flags: Linked
*/
function flagneutralized(team, oldteam)
{
	self.singleowner = 1;
	thread util::printandsoundoneveryone("neutral", oldteam, &"", &"", "mp_war_objective_neutralized", "mp_war_objective_lost", "");
	if(getteamflagcount(team) == level.flags.size)
	{
		statusdialog("lost_all", oldteam, "objective_all");
		flushobjectiveflagdialog();
	}
	else
	{
		statusdialog("lost" + self.label, oldteam, "objective" + self.label);
		globallogic_audio::flush_objective_dialog("objective_all");
		globallogic_audio::play_2d_on_team("mpl_flagcapture_sting_enemy", oldteam);
	}
}

/*
	Name: getdomflagusestring
	Namespace: dom
	Checksum: 0x60926AD6
	Offset: 0x2FF0
	Size: 0x166
	Parameters: 2
	Flags: Linked
*/
function getdomflagusestring(label, neutralized)
{
	string = &"";
	if(neutralized)
	{
		switch(label)
		{
			case "_a":
			{
				string = &"MP_DOM_FLAG_A_NEUTRALIZED_BY";
				break;
			}
			case "_b":
			{
				string = &"MP_DOM_FLAG_B_NEUTRALIZED_BY";
				break;
			}
			case "_c":
			{
				string = &"MP_DOM_FLAG_C_NEUTRALIZED_BY";
				break;
			}
			case "_d":
			{
				string = &"MP_DOM_FLAG_D_NEUTRALIZED_BY";
				break;
			}
			case "_e":
			{
				string = &"MP_DOM_FLAG_E_NEUTRALIZED_BY";
				break;
			}
			default:
			{
				break;
			}
		}
	}
	else
	{
		switch(label)
		{
			case "_a":
			{
				string = &"MP_DOM_FLAG_A_CAPTURED_BY";
				break;
			}
			case "_b":
			{
				string = &"MP_DOM_FLAG_B_CAPTURED_BY";
				break;
			}
			case "_c":
			{
				string = &"MP_DOM_FLAG_C_CAPTURED_BY";
				break;
			}
			case "_d":
			{
				string = &"MP_DOM_FLAG_D_CAPTURED_BY";
				break;
			}
			case "_e":
			{
				string = &"MP_DOM_FLAG_E_CAPTURED_BY";
				break;
			}
			default:
			{
				break;
			}
		}
	}
	return string;
}

/*
	Name: onusewithneutralizingflag
	Namespace: dom
	Checksum: 0xFE5D8ED
	Offset: 0x3160
	Size: 0x47C
	Parameters: 1
	Flags: Linked
*/
function onusewithneutralizingflag(player)
{
	team = player.pers["team"];
	oldteam = self gameobjects::get_owner_team();
	label = self gameobjects::get_label();
	/#
		print("" + self.label);
	#/
	level.usestartspawns = 0;
	/#
		assert(team != "");
	#/
	string = &"";
	if(oldteam == "neutral")
	{
		level notify(#"flag_captured");
		string = getdomflagusestring(label, 0);
		level.bestspawnflag[oldteam] = self.levelflag;
		self gameobjects::set_owner_team(team);
		self.visuals[0] setmodel(level.flagmodel[team]);
		setdvar("scr_obj" + self gameobjects::get_label(), team);
		self update_spawn_influencers(team);
		self flagcapturedfromneutral(team);
	}
	else
	{
		level notify(#"flag_neutralized");
		string = getdomflagusestring(label, 1);
		self gameobjects::set_owner_team("neutral");
		self.visuals[0] setmodel(level.flagmodel["neutral"]);
		setdvar("scr_obj" + self gameobjects::get_label(), "neutral");
		self update_spawn_influencers("neutral");
		self flagneutralized(team, oldteam);
	}
	/#
		assert(string != (&""));
	#/
	touchlist = [];
	touchkeys = getarraykeys(self.touchlist[team]);
	for(i = 0; i < touchkeys.size; i++)
	{
		touchlist[touchkeys[i]] = self.touchlist[team][touchkeys[i]];
	}
	isbflag = 0;
	if(label == "_b")
	{
		isbflag = 1;
	}
	if(oldteam == "neutral")
	{
		thread give_capture_credit(touchlist, string, oldteam, isbflag, 1);
	}
	else
	{
		thread give_neutralized_credit(touchlist, string, oldteam, isbflag);
	}
	bbprint("mpobjective", "gametime %d objtype %s label %s team %s playerx %d playery %d playerz %d", gettime(), "dom_capture", label, team, player.origin);
	if(dominated_challenge_check())
	{
		level thread totaldomination(team);
	}
}

/*
	Name: onusewithoutneutralizingflag
	Namespace: dom
	Checksum: 0x4F81DC62
	Offset: 0x35E8
	Size: 0x344
	Parameters: 1
	Flags: Linked
*/
function onusewithoutneutralizingflag(player)
{
	level notify(#"flag_captured");
	team = player.pers["team"];
	oldteam = self gameobjects::get_owner_team();
	label = self gameobjects::get_label();
	/#
		print("" + self.label);
	#/
	self gameobjects::set_owner_team(team);
	self.visuals[0] setmodel(level.flagmodel[team]);
	setdvar("scr_obj" + self gameobjects::get_label(), team);
	level.usestartspawns = 0;
	/#
		assert(team != "");
	#/
	isbflag = 0;
	if(label == "_b")
	{
		isbflag = 1;
	}
	string = getdomflagusestring(label, 0);
	/#
		assert(string != (&""));
	#/
	touchlist = [];
	touchkeys = getarraykeys(self.touchlist[team]);
	for(i = 0; i < touchkeys.size; i++)
	{
		touchlist[touchkeys[i]] = self.touchlist[team][touchkeys[i]];
	}
	thread give_capture_credit(touchlist, string, oldteam, isbflag, 0);
	bbprint("mpobjective", "gametime %d objtype %s label %s team %s playerx %d playery %d playerz %d", gettime(), "dom_capture", label, team, player.origin);
	if(oldteam == "neutral")
	{
		self flagcapturedfromneutral(team);
	}
	else
	{
		self flagcapturedfromteam(team, oldteam);
	}
	if(dominated_challenge_check())
	{
		level thread totaldomination(team);
	}
	self update_spawn_influencers(team);
}

/*
	Name: onuse
	Namespace: dom
	Checksum: 0x9807362D
	Offset: 0x3938
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function onuse(player)
{
	if(level.flagcanbeneutralized)
	{
		self onusewithneutralizingflag(player);
	}
	else
	{
		self onusewithoutneutralizingflag(player);
	}
	level change_dom_spawns();
}

/*
	Name: totaldomination
	Namespace: dom
	Checksum: 0x935F8F28
	Offset: 0x39A8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function totaldomination(team)
{
	level endon(#"flag_captured");
	level endon(#"game_ended");
	wait(180);
	challenges::totaldomination(team);
}

/*
	Name: watchforbflagcap
	Namespace: dom
	Checksum: 0xE4DDF2E2
	Offset: 0x39F0
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function watchforbflagcap()
{
	level endon(#"game_ended");
	level endon(#"endwatchforbflagcapaftertime");
	level thread endwatchforbflagcapaftertime(60);
	for(;;)
	{
		level waittill(#"b_flag_captured", player);
		player challenges::capturedbfirstminute();
	}
}

/*
	Name: endwatchforbflagcapaftertime
	Namespace: dom
	Checksum: 0xDA4206BA
	Offset: 0x3A60
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function endwatchforbflagcapaftertime(time)
{
	level endon(#"game_ended");
	wait(60);
	level notify(#"endwatchforbflagcapaftertime");
}

/*
	Name: give_capture_credit
	Namespace: dom
	Checksum: 0xF1E6A320
	Offset: 0x3A98
	Size: 0x316
	Parameters: 5
	Flags: Linked
*/
function give_capture_credit(touchlist, string, lastownerteam, isbflag, neutralizing)
{
	time = gettime();
	wait(0.05);
	util::waittillslowprocessallowed();
	self updatecapsperminute(lastownerteam);
	players = getarraykeys(touchlist);
	for(i = 0; i < players.size; i++)
	{
		player_from_touchlist = touchlist[players[i]].player;
		player_from_touchlist updatecapsperminute(lastownerteam);
		if(!isscoreboosting(player_from_touchlist, self))
		{
			player_from_touchlist challenges::capturedobjective(time, self.levelflag);
			if(lastownerteam == "neutral" && neutralizing && (isdefined(self.hasbeencaptured) && self.hasbeencaptured))
			{
				scoreevents::processscoreevent("dom_point_secured_neutralizing", player_from_touchlist);
			}
			else
			{
				if(lastownerteam == "neutral")
				{
					if(isbflag)
					{
						scoreevents::processscoreevent("dom_point_neutral_b_secured", player_from_touchlist);
					}
					else
					{
						scoreevents::processscoreevent("dom_point_neutral_secured", player_from_touchlist);
					}
				}
				else
				{
					scoreevents::processscoreevent("dom_point_secured", player_from_touchlist);
				}
			}
			self.hasbeencaptured = 1;
			player_from_touchlist recordgameevent("capture");
			if(isbflag)
			{
				level notify(#"b_flag_captured", player_from_touchlist);
			}
			if(isdefined(player_from_touchlist.pers["captures"]))
			{
				player_from_touchlist.pers["captures"]++;
				player_from_touchlist.captures = player_from_touchlist.pers["captures"];
			}
			demo::bookmark("event", gettime(), player_from_touchlist);
			player_from_touchlist addplayerstatwithgametype("CAPTURES", 1);
		}
		else
		{
			/#
				player_from_touchlist iprintlnbold("");
			#/
		}
		level thread popups::displayteammessagetoall(string, player_from_touchlist);
	}
}

/*
	Name: give_neutralized_credit
	Namespace: dom
	Checksum: 0xE139C33
	Offset: 0x3DB8
	Size: 0x1F6
	Parameters: 4
	Flags: Linked
*/
function give_neutralized_credit(touchlist, string, lastownerteam, isbflag)
{
	time = gettime();
	wait(0.05);
	util::waittillslowprocessallowed();
	players = getarraykeys(touchlist);
	for(i = 0; i < players.size; i++)
	{
		player_from_touchlist = touchlist[players[i]].player;
		player_from_touchlist updatecapsperminute(lastownerteam);
		if(!isscoreboosting(player_from_touchlist, self))
		{
			scoreevents::processscoreevent("dom_point_neutralized_neutralizing", player_from_touchlist);
			player_from_touchlist recordgameevent("neutralized");
			if(isdefined(player_from_touchlist.pers["neutralizes"]))
			{
				player_from_touchlist.pers["neutralizes"]++;
				player_from_touchlist.captures = player_from_touchlist.pers["neutralizes"];
			}
			demo::bookmark("event", gettime(), player_from_touchlist);
		}
		else
		{
			/#
				player_from_touchlist iprintlnbold("");
			#/
		}
		level thread popups::displayteammessagetoall(string, player_from_touchlist);
	}
}

/*
	Name: updatedomscores
	Namespace: dom
	Checksum: 0x5379CA4
	Offset: 0x3FB8
	Size: 0x530
	Parameters: 0
	Flags: Linked
*/
function updatedomscores()
{
	if(level.roundscorelimit && !level.timelimit)
	{
		warningscore = max(0, level.roundscorelimit - 12);
	}
	else
	{
		warningscore = 0;
	}
	playednearendvo = 0;
	alliesroundstartscore = [[level._getteamscore]]("allies");
	axisroundstartscore = [[level._getteamscore]]("axis");
	while(!level.gameended)
	{
		numownedflags = 0;
		scoring_teams = [];
		round_score_limit = util::get_current_round_score_limit();
		totalflags = getteamflagcount("allies") + getteamflagcount("axis");
		if(totalflags == 3 && game["teamScores"]["allies"] == (round_score_limit - 1) && game["teamScores"]["axis"] == (round_score_limit - 1))
		{
			level.clampscorelimit = 0;
		}
		numflags = getteamflagcount("allies");
		numownedflags = numownedflags + numflags;
		if(numflags)
		{
			scoring_teams[scoring_teams.size] = "allies";
			globallogic_score::giveteamscoreforobjective_delaypostprocessing("allies", numflags);
		}
		numflags = getteamflagcount("axis");
		numownedflags = numownedflags + numflags;
		if(numflags)
		{
			scoring_teams[scoring_teams.size] = "axis";
			globallogic_score::giveteamscoreforobjective_delaypostprocessing("axis", numflags);
		}
		if(numownedflags)
		{
			globallogic_score::postprocessteamscores(scoring_teams);
		}
		if(warningscore && !playednearendvo)
		{
			winningteam = undefined;
			alliesroundscore = [[level._getteamscore]]("allies") - alliesroundstartscore;
			axisroundscore = [[level._getteamscore]]("axis") - axisroundstartscore;
			if(alliesroundscore >= warningscore)
			{
				winningteam = "allies";
			}
			else if(axisroundscore >= warningscore)
			{
				winningteam = "axis";
			}
			if(isdefined(winningteam))
			{
				nearwinning = "nearWinning";
				nearlosing = "nearLosing";
				if(util::isoneround() || util::islastround())
				{
					nearwinning = "nearWinningFinal";
					nearlosing = "nearLosingFinal";
				}
				else
				{
					if(randomint(4) < 3)
					{
						nearwinning = "nearWinningFinal";
					}
					if(randomint(4) < 1)
					{
						nearlosing = "nearLosingFinal";
					}
				}
				globallogic_audio::leader_dialog(nearwinning, winningteam);
				globallogic_audio::leader_dialog_for_other_teams(nearlosing, winningteam);
				playednearendvo = 1;
			}
		}
		onscoreclosemusic();
		timepassed = globallogic_utils::gettimepassed();
		if((timepassed / 1000) > 120 && numownedflags < 2 || ((timepassed / 1000) > 300 && numownedflags < 3) && gamemodeismode(0))
		{
			thread globallogic::endgame("tie", game["strings"]["time_limit_reached"]);
			return;
		}
		wait(5);
		hostmigration::waittillhostmigrationdone();
	}
}

/*
	Name: onscoreclosemusic
	Namespace: dom
	Checksum: 0xE4CDB33B
	Offset: 0x44F0
	Size: 0x33C
	Parameters: 0
	Flags: Linked
*/
function onscoreclosemusic()
{
	axisscore = [[level._getteamscore]]("axis");
	alliedscore = [[level._getteamscore]]("allies");
	scorelimit = level.scorelimit;
	scorethreshold = scorelimit * 0.1;
	scoredif = abs(axisscore - alliedscore);
	scorethresholdstart = abs(scorelimit - scorethreshold);
	scorelimitcheck = scorelimit - 10;
	if(!isdefined(level.playingactionmusic))
	{
		level.playingactionmusic = 0;
	}
	if(!isdefined(level.sndhalfway))
	{
		level.sndhalfway = 0;
	}
	if(alliedscore > axisscore)
	{
		currentscore = alliedscore;
	}
	else
	{
		currentscore = axisscore;
	}
	/#
		if(getdvarint("") > 0)
		{
			println("" + scoredif);
			println("" + axisscore);
			println("" + alliedscore);
			println("" + scorelimit);
			println("" + currentscore);
			println("" + scorethreshold);
			println("" + scoredif);
			println("" + scorethresholdstart);
		}
	#/
	halfwayscore = scorelimit * 0.5;
	if(isdefined(level.roundscorelimit))
	{
		halfwayscore = level.roundscorelimit * 0.5;
		if(game["roundsplayed"] == 1)
		{
			halfwayscore = halfwayscore + level.roundscorelimit;
		}
	}
	if(axisscore >= halfwayscore || alliedscore >= halfwayscore && !level.sndhalfway)
	{
		level notify(#"sndmusichalfway", scoredif <= scorethreshold && scorethresholdstart <= currentscore && level.playingactionmusic != 1);
		level.sndhalfway = 1;
	}
}

/*
	Name: onroundswitch
	Namespace: dom
	Checksum: 0x55F0BC78
	Offset: 0x4838
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function onroundswitch()
{
	if(!isdefined(game["switchedsides"]))
	{
		game["switchedsides"] = 0;
	}
	game["switchedsides"] = !game["switchedsides"];
	if(level.scoreroundwinbased)
	{
		[[level._setteamscore]]("allies", game["roundswon"]["allies"]);
		[[level._setteamscore]]("axis", game["roundswon"]["axis"]);
	}
}

/*
	Name: onplayerkilled
	Namespace: dom
	Checksum: 0xBBE5D5FD
	Offset: 0x48E0
	Size: 0x764
	Parameters: 9
	Flags: Linked
*/
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	if(isdefined(attacker) && isplayer(attacker))
	{
		scoreeventprocessed = 0;
		if(attacker.touchtriggers.size && attacker.pers["team"] != self.pers["team"])
		{
			triggerids = getarraykeys(attacker.touchtriggers);
			ownerteam = attacker.touchtriggers[triggerids[0]].useobj.ownerteam;
			team = attacker.pers["team"];
			if(team != ownerteam)
			{
				scoreevents::processscoreevent("kill_enemy_while_capping_dom", attacker, undefined, weapon);
				scoreeventprocessed = 1;
			}
		}
		for(index = 0; index < level.flags.size; index++)
		{
			flagteam = "invalidTeam";
			inflagzone = 0;
			defendedflag = 0;
			offendedflag = 0;
			flagorigin = level.flags[index].origin;
			offenseradiussq = 90000;
			dist = distance2dsquared(self.origin, flagorigin);
			if(dist < offenseradiussq)
			{
				inflagzone = 1;
				if(level.flags[index] getflagteam() == attacker.pers["team"] || level.flags[index] getflagteam() == "neutral")
				{
					defendedflag = 1;
				}
				else
				{
					offendedflag = 1;
				}
			}
			dist = distance2dsquared(attacker.origin, flagorigin);
			if(dist < offenseradiussq)
			{
				inflagzone = 1;
				if(level.flags[index] getflagteam() == attacker.pers["team"] || level.flags[index] getflagteam() == "neutral")
				{
					defendedflag = 1;
				}
				else
				{
					offendedflag = 1;
				}
			}
			if(inflagzone && isplayer(attacker) && attacker.pers["team"] != self.pers["team"])
			{
				if(offendedflag)
				{
					if(!isdefined(attacker.dom_defends))
					{
						attacker.dom_defends = 0;
					}
					attacker.dom_defends++;
					if(level.playerdefensivemax >= attacker.dom_defends)
					{
						attacker thread challenges::killedbasedefender(level.flags[index]);
						if(!scoreeventprocessed)
						{
							scoreevents::processscoreevent("killed_defender", attacker, undefined, weapon);
						}
						self recordkillmodifier("defending");
						break;
					}
					else
					{
						/#
							attacker iprintlnbold("");
						#/
					}
				}
				if(defendedflag)
				{
					if(!isdefined(attacker.dom_offends))
					{
						attacker.dom_offends = 0;
					}
					attacker thread updateattackermultikills();
					attacker.dom_offends++;
					if(level.playeroffensivemax >= attacker.dom_offends)
					{
						attacker.pers["defends"]++;
						attacker.defends = attacker.pers["defends"];
						attacker thread challenges::killedbaseoffender(level.flags[index], weapon);
						attacker recordgameevent("return");
						attacker challenges::killedzoneattacker(weapon);
						if(!scoreeventprocessed)
						{
							scoreevents::processscoreevent("killed_attacker", attacker, undefined, weapon);
						}
						self recordkillmodifier("assaulting");
						break;
						continue;
					}
					/#
						attacker iprintlnbold("");
					#/
				}
			}
		}
		if(self.touchtriggers.size && attacker.pers["team"] != self.pers["team"])
		{
			triggerids = getarraykeys(self.touchtriggers);
			ownerteam = self.touchtriggers[triggerids[0]].useobj.ownerteam;
			team = self.pers["team"];
			if(team != ownerteam)
			{
				flag = self.touchtriggers[triggerids[0]].useobj;
				if(isdefined(flag.contested) && flag.contested == 1)
				{
					attacker killwhilecontesting(flag);
				}
			}
		}
	}
}

/*
	Name: killwhilecontesting
	Namespace: dom
	Checksum: 0x431E0460
	Offset: 0x5050
	Size: 0x168
	Parameters: 1
	Flags: Linked
*/
function killwhilecontesting(flag)
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
	flag waittill(#"contest_over");
	if(playerteam != self.pers["team"] || (isdefined(self.spawntime) && killtime < self.spawntime))
	{
		self.clearenemycount = 0;
		return;
	}
	if(flag.ownerteam != playerteam && flag.ownerteam != "neutral")
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
	Name: updateattackermultikills
	Namespace: dom
	Checksum: 0x5A6296BA
	Offset: 0x51C0
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function updateattackermultikills()
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	self notify(#"updatedomrecentkills");
	self endon(#"updatedomrecentkills");
	if(!isdefined(self.recentdomattackerkillcount))
	{
		self.recentdomattackerkillcount = 0;
	}
	self.recentdomattackerkillcount++;
	wait(4);
	if(self.recentdomattackerkillcount > 1)
	{
		self challenges::domattackermultikill(self.recentdomattackerkillcount);
	}
	self.recentdomattackerkillcount = 0;
}

/*
	Name: getteamflagcount
	Namespace: dom
	Checksum: 0x3AB29EAD
	Offset: 0x5260
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function getteamflagcount(team)
{
	score = 0;
	for(i = 0; i < level.flags.size; i++)
	{
		if(level.domflags[i] gameobjects::get_owner_team() == team)
		{
			score++;
		}
	}
	return score;
}

/*
	Name: getflagteam
	Namespace: dom
	Checksum: 0xC3F6200
	Offset: 0x52E0
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function getflagteam()
{
	return self.useobj gameobjects::get_owner_team();
}

/*
	Name: getboundaryflags
	Namespace: dom
	Checksum: 0x39039275
	Offset: 0x5308
	Size: 0x106
	Parameters: 0
	Flags: Linked
*/
function getboundaryflags()
{
	bflags = [];
	for(i = 0; i < level.flags.size; i++)
	{
		for(j = 0; j < level.flags[i].adjflags.size; j++)
		{
			if(level.flags[i].useobj gameobjects::get_owner_team() != level.flags[i].adjflags[j].useobj gameobjects::get_owner_team())
			{
				bflags[bflags.size] = level.flags[i];
				break;
			}
		}
	}
	return bflags;
}

/*
	Name: getboundaryflagspawns
	Namespace: dom
	Checksum: 0x8495472B
	Offset: 0x5418
	Size: 0xF6
	Parameters: 1
	Flags: None
*/
function getboundaryflagspawns(team)
{
	spawns = [];
	bflags = getboundaryflags();
	for(i = 0; i < bflags.size; i++)
	{
		if(isdefined(team) && bflags[i] getflagteam() != team)
		{
			continue;
		}
		for(j = 0; j < bflags[i].nearbyspawns.size; j++)
		{
			spawns[spawns.size] = bflags[i].nearbyspawns[j];
		}
	}
	return spawns;
}

/*
	Name: getspawnsboundingflag
	Namespace: dom
	Checksum: 0x18189A90
	Offset: 0x5518
	Size: 0x13E
	Parameters: 1
	Flags: None
*/
function getspawnsboundingflag(avoidflag)
{
	spawns = [];
	for(i = 0; i < level.flags.size; i++)
	{
		flag = level.flags[i];
		if(flag == avoidflag)
		{
			continue;
		}
		isbounding = 0;
		for(j = 0; j < flag.adjflags.size; j++)
		{
			if(flag.adjflags[j] == avoidflag)
			{
				isbounding = 1;
				break;
			}
		}
		if(!isbounding)
		{
			continue;
		}
		for(j = 0; j < flag.nearbyspawns.size; j++)
		{
			spawns[spawns.size] = flag.nearbyspawns[j];
		}
	}
	return spawns;
}

/*
	Name: getownedandboundingflagspawns
	Namespace: dom
	Checksum: 0x871F7943
	Offset: 0x5660
	Size: 0x1B8
	Parameters: 1
	Flags: None
*/
function getownedandboundingflagspawns(team)
{
	spawns = [];
	for(i = 0; i < level.flags.size; i++)
	{
		if(level.flags[i] getflagteam() == team)
		{
			for(s = 0; s < level.flags[i].nearbyspawns.size; s++)
			{
				spawns[spawns.size] = level.flags[i].nearbyspawns[s];
			}
			continue;
		}
		for(j = 0; j < level.flags[i].adjflags.size; j++)
		{
			if(level.flags[i].adjflags[j] getflagteam() == team)
			{
				for(s = 0; s < level.flags[i].nearbyspawns.size; s++)
				{
					spawns[spawns.size] = level.flags[i].nearbyspawns[s];
				}
				break;
			}
		}
	}
	return spawns;
}

/*
	Name: getownedflagspawns
	Namespace: dom
	Checksum: 0xA3142BE5
	Offset: 0x5820
	Size: 0xDA
	Parameters: 1
	Flags: None
*/
function getownedflagspawns(team)
{
	spawns = [];
	for(i = 0; i < level.flags.size; i++)
	{
		if(level.flags[i] getflagteam() == team)
		{
			for(s = 0; s < level.flags[i].nearbyspawns.size; s++)
			{
				spawns[spawns.size] = level.flags[i].nearbyspawns[s];
			}
		}
	}
	return spawns;
}

/*
	Name: flagsetup
	Namespace: dom
	Checksum: 0xA85C26B3
	Offset: 0x5908
	Size: 0x68E
	Parameters: 0
	Flags: Linked
*/
function flagsetup()
{
	maperrors = [];
	descriptorsbylinkname = [];
	descriptors = getentarray("flag_descriptor", "targetname");
	flags = level.flags;
	for(i = 0; i < level.domflags.size; i++)
	{
		closestdist = undefined;
		closestdesc = undefined;
		for(j = 0; j < descriptors.size; j++)
		{
			dist = distance(flags[i].origin, descriptors[j].origin);
			if(!isdefined(closestdist) || dist < closestdist)
			{
				closestdist = dist;
				closestdesc = descriptors[j];
			}
		}
		if(!isdefined(closestdesc))
		{
			maperrors[maperrors.size] = "there is no flag_descriptor in the map! see explanation in dom.gsc";
			break;
		}
		if(isdefined(closestdesc.flag))
		{
			maperrors[maperrors.size] = ("flag_descriptor with script_linkname \"" + closestdesc.script_linkname) + "\" is nearby more than one flag; is there a unique descriptor near each flag?";
			continue;
		}
		flags[i].descriptor = closestdesc;
		closestdesc.flag = flags[i];
		descriptorsbylinkname[closestdesc.script_linkname] = closestdesc;
	}
	if(maperrors.size == 0)
	{
		for(i = 0; i < flags.size; i++)
		{
			if(isdefined(flags[i].descriptor.script_linkto))
			{
				adjdescs = strtok(flags[i].descriptor.script_linkto, " ");
			}
			else
			{
				adjdescs = [];
			}
			for(j = 0; j < adjdescs.size; j++)
			{
				otherdesc = descriptorsbylinkname[adjdescs[j]];
				if(!isdefined(otherdesc) || otherdesc.targetname != "flag_descriptor")
				{
					maperrors[maperrors.size] = ((("flag_descriptor with script_linkname \"" + flags[i].descriptor.script_linkname) + "\" linked to \"") + adjdescs[j]) + "\" which does not exist as a script_linkname of any other entity with a targetname of flag_descriptor (or, if it does, that flag_descriptor has not been assigned to a flag)";
					continue;
				}
				adjflag = otherdesc.flag;
				if(adjflag == flags[i])
				{
					maperrors[maperrors.size] = ("flag_descriptor with script_linkname \"" + flags[i].descriptor.script_linkname) + "\" linked to itself";
					continue;
				}
				flags[i].adjflags[flags[i].adjflags.size] = adjflag;
			}
		}
	}
	spawnpoints = spawnlogic::get_spawnpoint_array("mp_dom_spawn");
	for(i = 0; i < spawnpoints.size; i++)
	{
		if(isdefined(spawnpoints[i].script_linkto))
		{
			desc = descriptorsbylinkname[spawnpoints[i].script_linkto];
			if(!isdefined(desc) || desc.targetname != "flag_descriptor")
			{
				maperrors[maperrors.size] = ((("Spawnpoint at " + spawnpoints[i].origin) + "\" linked to \"") + spawnpoints[i].script_linkto) + "\" which does not exist as a script_linkname of any entity with a targetname of flag_descriptor (or, if it does, that flag_descriptor has not been assigned to a flag)";
				continue;
			}
			nearestflag = desc.flag;
		}
		else
		{
			nearestflag = undefined;
			nearestdist = undefined;
			for(j = 0; j < flags.size; j++)
			{
				dist = distancesquared(flags[j].origin, spawnpoints[i].origin);
				if(!isdefined(nearestflag) || dist < nearestdist)
				{
					nearestflag = flags[j];
					nearestdist = dist;
				}
			}
		}
		nearestflag.nearbyspawns[nearestflag.nearbyspawns.size] = spawnpoints[i];
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
}

/*
	Name: createflagspawninfluencers
	Namespace: dom
	Checksum: 0x789F2A79
	Offset: 0x5FA0
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function createflagspawninfluencers()
{
	ss = level.spawnsystem;
	for(flag_index = 0; flag_index < level.flags.size; flag_index++)
	{
		if(level.domflags[flag_index] == self)
		{
			break;
		}
	}
	self.owned_flag_influencer = self spawning::create_influencer("dom_friendly", self.trigger.origin, 0);
	self.neutral_flag_influencer = self spawning::create_influencer("dom_neutral", self.trigger.origin, 0);
	self.enemy_flag_influencer = self spawning::create_influencer("dom_enemy", self.trigger.origin, 0);
	self update_spawn_influencers("neutral");
}

/*
	Name: update_spawn_influencers
	Namespace: dom
	Checksum: 0x24D885FB
	Offset: 0x60D0
	Size: 0x18C
	Parameters: 1
	Flags: Linked
*/
function update_spawn_influencers(team)
{
	/#
		assert(isdefined(self.neutral_flag_influencer));
	#/
	/#
		assert(isdefined(self.owned_flag_influencer));
	#/
	/#
		assert(isdefined(self.enemy_flag_influencer));
	#/
	if(team == "neutral")
	{
		enableinfluencer(self.neutral_flag_influencer, 1);
		enableinfluencer(self.owned_flag_influencer, 0);
		enableinfluencer(self.enemy_flag_influencer, 0);
	}
	else
	{
		enableinfluencer(self.neutral_flag_influencer, 0);
		enableinfluencer(self.owned_flag_influencer, 1);
		enableinfluencer(self.enemy_flag_influencer, 1);
		setinfluencerteammask(self.owned_flag_influencer, util::getteammask(team));
		setinfluencerteammask(self.enemy_flag_influencer, util::getotherteamsmask(team));
	}
}

/*
	Name: addspawnpointsforflag
	Namespace: dom
	Checksum: 0x380975C4
	Offset: 0x6268
	Size: 0x94
	Parameters: 3
	Flags: Linked
*/
function addspawnpointsforflag(team, flag_team, flagspawnname)
{
	if(game["switchedsides"])
	{
		team = util::getotherteam(team);
	}
	otherteam = util::getotherteam(team);
	if(flag_team != otherteam)
	{
		spawnlogic::add_spawn_points(team, flagspawnname);
	}
}

/*
	Name: change_dom_spawns
	Namespace: dom
	Checksum: 0xF3D6624B
	Offset: 0x6308
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function change_dom_spawns()
{
	spawnlogic::clear_spawn_points();
	spawnlogic::add_spawn_points("allies", "mp_dom_spawn");
	spawnlogic::add_spawn_points("axis", "mp_dom_spawn");
	flag_number = level.flags.size;
	if(dominated_check())
	{
		for(i = 0; i < flag_number; i++)
		{
			label = level.flags[i].useobj gameobjects::get_label();
			flagspawnname = "mp_dom_spawn_flag" + label;
			spawnlogic::add_spawn_points("allies", flagspawnname);
			spawnlogic::add_spawn_points("axis", flagspawnname);
		}
	}
	else
	{
		for(i = 0; i < flag_number; i++)
		{
			label = level.flags[i].useobj gameobjects::get_label();
			flagspawnname = "mp_dom_spawn_flag" + label;
			flag_team = level.flags[i] getflagteam();
			addspawnpointsforflag("allies", flag_team, flagspawnname);
			addspawnpointsforflag("axis", flag_team, flagspawnname);
		}
	}
	spawning::updateallspawnpoints();
}

/*
	Name: dominated_challenge_check
	Namespace: dom
	Checksum: 0x3B5D02B4
	Offset: 0x6530
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function dominated_challenge_check()
{
	num_flags = level.flags.size;
	allied_flags = 0;
	axis_flags = 0;
	for(i = 0; i < num_flags; i++)
	{
		flag_team = level.flags[i] getflagteam();
		if(flag_team == "allies")
		{
			allied_flags++;
		}
		else
		{
			if(flag_team == "axis")
			{
				axis_flags++;
			}
			else
			{
				return false;
			}
		}
		if(allied_flags > 0 && axis_flags > 0)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: dominated_check
	Namespace: dom
	Checksum: 0x644AA30F
	Offset: 0x6628
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function dominated_check()
{
	num_flags = level.flags.size;
	allied_flags = 0;
	axis_flags = 0;
	for(i = 0; i < num_flags; i++)
	{
		flag_team = level.flags[i] getflagteam();
		if(flag_team == "allies")
		{
			allied_flags++;
		}
		else if(flag_team == "axis")
		{
			axis_flags++;
		}
		if(allied_flags > 0 && axis_flags > 0)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: updatecapsperminute
	Namespace: dom
	Checksum: 0x892875E5
	Offset: 0x6718
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function updatecapsperminute(lastownerteam)
{
	if(!isdefined(self.capsperminute))
	{
		self.numcaps = 0;
		self.capsperminute = 0;
	}
	if(lastownerteam == "neutral")
	{
		return;
	}
	self.numcaps++;
	minutespassed = globallogic_utils::gettimepassed() / 60000;
	if(isplayer(self) && isdefined(self.timeplayed["total"]))
	{
		minutespassed = self.timeplayed["total"] / 60;
	}
	self.capsperminute = self.numcaps / minutespassed;
	if(self.capsperminute > self.numcaps)
	{
		self.capsperminute = self.numcaps;
	}
}

/*
	Name: isscoreboosting
	Namespace: dom
	Checksum: 0x644FCE4D
	Offset: 0x6818
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function isscoreboosting(player, flag)
{
	if(!level.rankedmatch)
	{
		return false;
	}
	if(player.capsperminute > level.playercapturelpm)
	{
		return true;
	}
	if(flag.capsperminute > level.flagcapturelpm)
	{
		return true;
	}
	return false;
}

/*
	Name: onupdateuserate
	Namespace: dom
	Checksum: 0xB87325E
	Offset: 0x6888
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function onupdateuserate()
{
	if(!isdefined(self.contested))
	{
		self.contested = 0;
	}
	numother = gameobjects::get_num_touching_except_team(self.ownerteam);
	numowners = self.numtouching[self.claimteam];
	previousstate = self.contested;
	if(numother > 0 && numowners > 0)
	{
		self.contested = 1;
	}
	else
	{
		if(previousstate == 1)
		{
			self notify(#"contest_over");
		}
		self.contested = 0;
	}
}

