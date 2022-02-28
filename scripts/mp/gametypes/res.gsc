// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\teams\_teams;
#using scripts\shared\callbacks_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\medals_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

#namespace res;

/*
	Name: main
	Namespace: res
	Checksum: 0xB39F8C9C
	Offset: 0x988
	Size: 0x294
	Parameters: 0
	Flags: None
*/
function main()
{
	globallogic::init();
	util::registerroundswitch(0, 9);
	util::registertimelimit(0, 2.5);
	util::registerscorelimit(0, 1000);
	util::registerroundlimit(0, 10);
	util::registerroundwinlimit(0, 10);
	util::registernumlives(0, 100);
	globallogic::registerfriendlyfiredelay(level.gametype, 15, 0, 1440);
	level.teambased = 1;
	level.overrideteamscore = 1;
	level.onstartgametype = &onstartgametype;
	level.onroundswitch = &onroundswitch;
	level.onplayerkilled = &onplayerkilled;
	level.onprecachegametype = &onprecachegametype;
	level.onendgame = &onendgame;
	level.onroundendgame = &onroundendgame;
	level.ontimelimit = &ontimelimit;
	level.gettimelimit = &gettimelimit;
	gameobjects::register_allowed_gameobject(level.gametype);
	game["dialog"]["gametype"] = "res_start";
	game["dialog"]["gametype_hardcore"] = "hcres_start";
	game["dialog"]["offense_obj"] = "cap_start";
	game["dialog"]["defense_obj"] = "defend_start";
	level.lastdialogtime = 0;
	level.iconoffset = vectorscale((0, 0, 1), 100);
	globallogic::setvisiblescoreboardcolumns("score", "kills", "deaths", "captures", "defends");
}

/*
	Name: onprecachegametype
	Namespace: res
	Checksum: 0x99EC1590
	Offset: 0xC28
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function onprecachegametype()
{
}

/*
	Name: onroundswitch
	Namespace: res
	Checksum: 0x65AB3AD2
	Offset: 0xC38
	Size: 0x10C
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
		else
		{
			level.halftimesubcaption = "";
		}
		level.halftimetype = "overtime";
	}
	else
	{
		level.halftimetype = "halftime";
		game["switchedsides"] = !game["switchedsides"];
	}
}

/*
	Name: getbetterteam
	Namespace: res
	Checksum: 0xE29E2E7B
	Offset: 0xD50
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
	Namespace: res
	Checksum: 0xC19D1332
	Offset: 0xF68
	Size: 0x684
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
	level.usingextratime = 0;
	game["strings"]["flags_capped"] = &"MP_TARGET_DESTROYED";
	util::setobjectivetext(game["attackers"], &"OBJECTIVES_RES_ATTACKER");
	util::setobjectivetext(game["defenders"], &"OBJECTIVES_RES_DEFENDER");
	if(level.splitscreen)
	{
		util::setobjectivescoretext(game["attackers"], &"OBJECTIVES_RES_ATTACKER");
		util::setobjectivescoretext(game["defenders"], &"OBJECTIVES_RES_DEFENDER");
	}
	else
	{
		util::setobjectivescoretext(game["attackers"], &"OBJECTIVES_RES_ATTACKER_SCORE");
		util::setobjectivescoretext(game["defenders"], &"OBJECTIVES_RES_DEFENDER_SCORE");
	}
	util::setobjectivehinttext(game["attackers"], &"OBJECTIVES_RES_ATTACKER_HINT");
	util::setobjectivehinttext(game["defenders"], &"OBJECTIVES_RES_DEFENDER_HINT");
	level.objectivehintpreparehq = &"MP_CONTROL_HQ";
	level.objectivehintcapturehq = &"MP_CAPTURE_HQ";
	level.objectivehintdefendhq = &"MP_DEFEND_HQ";
	level.flagbasefxid = [];
	level.flagbasefxid["allies"] = ("_t6/misc/fx_ui_flagbase_") + game["allies"];
	level.flagbasefxid["axis"] = ("_t6/misc/fx_ui_flagbase_") + game["axis"];
	setclientnamemode("auto_change");
	spawning::create_map_placed_influencers();
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	spawnlogic::place_spawn_points("mp_res_spawn_allies_start");
	spawnlogic::place_spawn_points("mp_res_spawn_axis_start");
	spawnlogic::add_spawn_points("allies", "mp_res_spawn_allies");
	spawnlogic::add_spawn_points("axis", "mp_res_spawn_axis");
	spawnlogic::add_spawn_points("axis", "mp_res_spawn_axis_a");
	spawnlogic::drop_spawn_points("mp_res_spawn_allies_a");
	spawning::updateallspawnpoints();
	level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
	setmapcenter(level.mapcenter);
	spawnpoint = spawnlogic::get_random_intermission_point();
	setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
	level.spawn_start = [];
	foreach(team in level.teams)
	{
		level.spawn_start[team] = spawnlogic::get_spawnpoint_array(("mp_res_spawn_" + team) + "_start");
	}
	hud_createflagprogressbar();
	updategametypedvars();
	thread createtimerdisplay();
	thread resflagsinit();
	level.overtime = 0;
	overtime = 0;
	if(game["teamScores"]["allies"] == (level.scorelimit - 1) && game["teamScores"]["axis"] == (level.scorelimit - 1))
	{
		overtime = 1;
	}
	if(overtime)
	{
		spawnlogic::clear_spawn_points();
	}
	spawnlogic::add_spawn_points("allies", "mp_res_spawn_allies_a");
	spawnlogic::add_spawn_points("axis", "mp_res_spawn_axis");
	spawning::updateallspawnpoints();
	if(overtime)
	{
		setupnextflag(int(level.resflags.size / 3));
	}
	else
	{
		setupnextflag(0);
	}
	level.overtime = overtime;
	if(level.flagactivatedelay)
	{
		updateobjectivehintmessages(level.objectivehintpreparehq, level.objectivehintpreparehq);
	}
	else
	{
		updateobjectivehintmessages(level.objectivehintcapturehq, level.objectivehintcapturehq);
	}
}

/*
	Name: onendgame
	Namespace: res
	Checksum: 0xFFE94DB4
	Offset: 0x15F8
	Size: 0x5E
	Parameters: 1
	Flags: None
*/
function onendgame(winningteam)
{
	for(i = 0; i < level.resflags.size; i++)
	{
		level.resflags[i] gameobjects::allow_use("none");
	}
}

/*
	Name: onroundendgame
	Namespace: res
	Checksum: 0x2604AA9F
	Offset: 0x1660
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function onroundendgame(roundwinner)
{
	winner = globallogic::determineteamwinnerbygamestat("roundswon");
	return winner;
}

/*
	Name: res_endgame
	Namespace: res
	Checksum: 0xCE18C6B8
	Offset: 0x16A0
	Size: 0x64
	Parameters: 2
	Flags: None
*/
function res_endgame(winningteam, endreasontext)
{
	if(isdefined(winningteam) && winningteam != "tie")
	{
		globallogic_score::giveteamscoreforobjective(winningteam, 1);
	}
	thread globallogic::endgame(winningteam, endreasontext);
}

/*
	Name: ontimelimit
	Namespace: res
	Checksum: 0xEB2D9948
	Offset: 0x1710
	Size: 0xB4
	Parameters: 0
	Flags: None
*/
function ontimelimit()
{
	if(level.overtime)
	{
		if(isdefined(level.resprogressteam))
		{
			res_endgame(level.resprogressteam, game["strings"]["time_limit_reached"]);
		}
		else
		{
			res_endgame("tie", game["strings"]["time_limit_reached"]);
		}
	}
	else
	{
		res_endgame(game["defenders"], game["strings"]["time_limit_reached"]);
	}
}

/*
	Name: gettimelimit
	Namespace: res
	Checksum: 0x801CA362
	Offset: 0x17D0
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function gettimelimit()
{
	timelimit = globallogic_defaults::default_gettimelimit();
	if(level.usingextratime)
	{
		flagcount = 0;
		if(isdefined(level.currentflag))
		{
			flagcount = flagcount + level.currentflag.orderindex;
		}
		return timelimit + (level.extratime * flagcount);
	}
	return timelimit;
}

/*
	Name: updategametypedvars
	Namespace: res
	Checksum: 0x394EBD34
	Offset: 0x1858
	Size: 0x124
	Parameters: 0
	Flags: None
*/
function updategametypedvars()
{
	level.flagcapturetime = getgametypesetting("captureTime");
	level.flagdecaytime = getgametypesetting("flagDecayTime");
	level.flagactivatedelay = getgametypesetting("objectiveSpawnTime");
	level.flaginactiveresettime = getgametypesetting("idleFlagResetTime");
	level.flaginactivedecay = getgametypesetting("idleFlagDecay");
	level.extratime = getgametypesetting("extraTime");
	level.flagcapturegraceperiod = getgametypesetting("flagCaptureGracePeriod");
	level.playeroffensivemax = getgametypesetting("maxPlayerOffensive");
	level.playerdefensivemax = getgametypesetting("maxPlayerDefensive");
}

/*
	Name: resflagsinit
	Namespace: res
	Checksum: 0x7393574E
	Offset: 0x1988
	Size: 0x66E
	Parameters: 0
	Flags: None
*/
function resflagsinit()
{
	level.laststatus["allies"] = 0;
	level.laststatus["axis"] = 0;
	level.flagmodel["allies"] = teams::get_flag_model("allies");
	level.flagmodel["axis"] = teams::get_flag_model("axis");
	level.flagmodel["neutral"] = teams::get_flag_model("neutral");
	primaryflags = getentarray("res_flag_primary", "targetname");
	if(primaryflags.size < 2)
	{
		/#
			println("");
		#/
		callback::abort_level();
		return;
	}
	level.flags = [];
	for(index = 0; index < primaryflags.size; index++)
	{
		level.flags[level.flags.size] = primaryflags[index];
	}
	level.resflags = [];
	for(index = 0; index < level.flags.size; index++)
	{
		trigger = level.flags[index];
		if(isdefined(trigger.target))
		{
			visuals[0] = getent(trigger.target, "targetname");
		}
		else
		{
			visuals[0] = spawn("script_model", trigger.origin);
			visuals[0].angles = trigger.angles;
		}
		visuals[0] setmodel(level.flagmodel[game["defenders"]]);
		resflag = gameobjects::create_use_object(game["defenders"], trigger, visuals, level.iconoffset);
		resflag gameobjects::allow_use("none");
		resflag gameobjects::set_use_time(level.flagcapturetime);
		resflag gameobjects::set_use_text(&"MP_CAPTURING_FLAG");
		resflag gameobjects::set_decay_time(level.flagdecaytime);
		label = resflag gameobjects::get_label();
		resflag.label = label;
		resflag gameobjects::set_model_visibility(0);
		resflag.onuse = &onuse;
		resflag.onbeginuse = &onbeginuse;
		resflag.onuseupdate = &onuseupdate;
		resflag.onuseclear = &onuseclear;
		resflag.onenduse = &onenduse;
		resflag.claimgraceperiod = level.flagcapturegraceperiod;
		resflag.decayprogress = level.flaginactivedecay;
		tracestart = visuals[0].origin + vectorscale((0, 0, 1), 32);
		traceend = visuals[0].origin + (vectorscale((0, 0, -1), 32));
		trace = bullettrace(tracestart, traceend, 0, undefined);
		upangles = vectortoangles(trace["normal"]);
		resflag.baseeffectforward = anglestoforward(upangles);
		resflag.baseeffectright = anglestoright(upangles);
		resflag.baseeffectpos = trace["position"];
		level.flags[index].useobj = resflag;
		level.flags[index].nearbyspawns = [];
		resflag.levelflag = level.flags[index];
		level.resflags[level.resflags.size] = resflag;
	}
	sortflags();
	level.bestspawnflag = [];
	level.bestspawnflag["allies"] = getunownedflagneareststart("allies", undefined);
	level.bestspawnflag["axis"] = getunownedflagneareststart("axis", level.bestspawnflag["allies"]);
	for(index = 0; index < level.resflags.size; index++)
	{
		level.resflags[index] createflagspawninfluencers();
	}
}

/*
	Name: sortflags
	Namespace: res
	Checksum: 0x7541C0C2
	Offset: 0x2000
	Size: 0x1EA
	Parameters: 0
	Flags: None
*/
function sortflags()
{
	flagorder["_a"] = 0;
	flagorder["_b"] = 1;
	flagorder["_c"] = 2;
	flagorder["_d"] = 3;
	flagorder["_e"] = 4;
	for(i = 0; i < level.resflags.size; i++)
	{
		level.resflags[i].orderindex = flagorder[level.resflags[i].label];
		/#
			assert(isdefined(level.resflags[i].orderindex));
		#/
	}
	for(i = 1; i < level.resflags.size; i++)
	{
		for(j = 0; j < (level.resflags.size - i); j++)
		{
			if(level.resflags[j].orderindex > (level.resflags[j + 1].orderindex))
			{
				temp = level.resflags[j];
				level.resflags[j] = level.resflags[j + 1];
				level.resflags[j + 1] = temp;
			}
		}
	}
}

/*
	Name: setupnextflag
	Namespace: res
	Checksum: 0x60AA1357
	Offset: 0x21F8
	Size: 0xA4
	Parameters: 1
	Flags: None
*/
function setupnextflag(flagindex)
{
	prevflagindex = flagindex - 1;
	if(prevflagindex >= 0)
	{
		thread hideflag(prevflagindex);
	}
	if(flagindex < level.resflags.size && !level.overtime)
	{
		thread showflag(flagindex);
	}
	else
	{
		globallogic_utils::resumetimer();
		hud_hideflagprogressbar();
	}
}

/*
	Name: createtimerdisplay
	Namespace: res
	Checksum: 0x980CC4AE
	Offset: 0x22A8
	Size: 0x274
	Parameters: 0
	Flags: None
*/
function createtimerdisplay()
{
	flagspawninginstr = &"MP_HQ_AVAILABLE_IN";
	level.locationobjid = gameobjects::get_next_obj_id();
	level.timerdisplay = [];
	level.timerdisplay["allies"] = hud::createservertimer("objective", 1.4, "allies");
	level.timerdisplay["allies"] hud::setpoint("TOPCENTER", "TOPCENTER", 0, 0);
	level.timerdisplay["allies"].label = flagspawninginstr;
	level.timerdisplay["allies"].alpha = 0;
	level.timerdisplay["allies"].archived = 0;
	level.timerdisplay["allies"].hidewheninmenu = 1;
	level.timerdisplay["axis"] = hud::createservertimer("objective", 1.4, "axis");
	level.timerdisplay["axis"] hud::setpoint("TOPCENTER", "TOPCENTER", 0, 0);
	level.timerdisplay["axis"].label = flagspawninginstr;
	level.timerdisplay["axis"].alpha = 0;
	level.timerdisplay["axis"].archived = 0;
	level.timerdisplay["axis"].hidewheninmenu = 1;
	thread hidetimerdisplayongameend(level.timerdisplay["allies"]);
	thread hidetimerdisplayongameend(level.timerdisplay["axis"]);
}

/*
	Name: hidetimerdisplayongameend
	Namespace: res
	Checksum: 0xF868B4FC
	Offset: 0x2528
	Size: 0x28
	Parameters: 1
	Flags: None
*/
function hidetimerdisplayongameend(timerdisplay)
{
	level waittill(#"game_ended");
	timerdisplay.alpha = 0;
}

/*
	Name: showflag
	Namespace: res
	Checksum: 0xB8D74C09
	Offset: 0x2558
	Size: 0x4DC
	Parameters: 1
	Flags: None
*/
function showflag(flagindex)
{
	/#
		assert(flagindex < level.resflags.size);
	#/
	resflag = level.resflags[flagindex];
	label = resflag.label;
	resflag gameobjects::set_visible_team("any");
	resflag gameobjects::set_model_visibility(1);
	level.currentflag = resflag;
	if(level.flagactivatedelay)
	{
		hud_hideflagprogressbar();
		if(level.prematchperiod > 0 && level.inprematchperiod == 1)
		{
			level waittill(#"prematch_over");
		}
		nextobjpoint = objpoints::create("objpoint_next_hq", resflag.curorigin + level.iconoffset, "all", "waypoint_targetneutral");
		nextobjpoint setwaypoint(1, "waypoint_targetneutral");
		objective_position(level.locationobjid, resflag.curorigin);
		objective_icon(level.locationobjid, "waypoint_targetneutral");
		objective_state(level.locationobjid, "active");
		updateobjectivehintmessages(level.objectivehintpreparehq, level.objectivehintdefendhq);
		flagspawninginstr = &"MP_HQ_AVAILABLE_IN";
		level.timerdisplay["allies"].label = flagspawninginstr;
		level.timerdisplay["allies"] settimer(level.flagactivatedelay);
		level.timerdisplay["allies"].alpha = 1;
		level.timerdisplay["axis"].label = flagspawninginstr;
		level.timerdisplay["axis"] settimer(level.flagactivatedelay);
		level.timerdisplay["axis"].alpha = 1;
		wait(level.flagactivatedelay);
		objpoints::delete(nextobjpoint);
		objective_state(level.locationobjid, "invisible");
		globallogic_audio::leader_dialog("hq_online");
		hud_showflagprogressbar();
	}
	level.timerdisplay["allies"].alpha = 0;
	level.timerdisplay["axis"].alpha = 0;
	resflag gameobjects::set_2d_icon("friendly", "compass_waypoint_defend" + label);
	resflag gameobjects::set_3d_icon("friendly", "waypoint_defend" + label);
	resflag gameobjects::set_2d_icon("enemy", "compass_waypoint_capture" + label);
	resflag gameobjects::set_3d_icon("enemy", "waypoint_capture" + label);
	if(level.overtime)
	{
		resflag gameobjects::allow_use("enemy");
		resflag gameobjects::set_visible_team("any");
		resflag gameobjects::set_owner_team("neutral");
		resflag gameobjects::set_decay_time(level.flagcapturetime);
	}
	else
	{
		resflag gameobjects::allow_use("enemy");
	}
	resflag resetflagbaseeffect();
}

/*
	Name: hideflag
	Namespace: res
	Checksum: 0x15A96523
	Offset: 0x2A40
	Size: 0xA4
	Parameters: 1
	Flags: None
*/
function hideflag(flagindex)
{
	/#
		assert(flagindex < level.resflags.size);
	#/
	resflag = level.resflags[flagindex];
	resflag gameobjects::allow_use("none");
	resflag gameobjects::set_visible_team("none");
	resflag gameobjects::set_model_visibility(0);
}

/*
	Name: getunownedflagneareststart
	Namespace: res
	Checksum: 0x14418355
	Offset: 0x2AF0
	Size: 0x12E
	Parameters: 2
	Flags: None
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
	Name: onbeginuse
	Namespace: res
	Checksum: 0x574FE7AA
	Offset: 0x2C28
	Size: 0x1CC
	Parameters: 1
	Flags: None
*/
function onbeginuse(player)
{
	ownerteam = self gameobjects::get_owner_team();
	setdvar(("scr_obj" + self gameobjects::get_label()) + "_flash", 1);
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
		if((gettime() - level.lastdialogtime) > 5000)
		{
			otherteam = util::getotherteam(player.pers["team"]);
			statusdialog("securing" + self.label, player.pers["team"]);
			level.lastdialogtime = gettime();
		}
		self.objpoints[player.pers["team"]] thread objpoints::start_flashing();
		return;
	}
	self.objpoints["allies"] thread objpoints::start_flashing();
	self.objpoints["axis"] thread objpoints::start_flashing();
}

/*
	Name: onuseupdate
	Namespace: res
	Checksum: 0xB2290E39
	Offset: 0x2E00
	Size: 0x174
	Parameters: 3
	Flags: None
*/
function onuseupdate(team, progress, change)
{
	if(!isdefined(level.resprogress))
	{
		level.resprogress = progress;
	}
	if(progress > 0.05 && change && !self.didstatusnotify)
	{
		ownerteam = self gameobjects::get_owner_team();
		if((gettime() - level.lastdialogtime) > 10000)
		{
			statusdialog("losing" + self.label, ownerteam);
			statusdialog("securing" + self.label, team);
			level.lastdialogtime = gettime();
		}
		self.didstatusnotify = 1;
	}
	if(level.resprogress < progress)
	{
		globallogic_utils::pausetimer();
		setgameendtime(0);
		level.resprogressteam = team;
	}
	else
	{
		globallogic_utils::resumetimer();
	}
	level.resprogress = progress;
	hud_setflagprogressbar(progress, team);
}

/*
	Name: onuseclear
	Namespace: res
	Checksum: 0xAE54133F
	Offset: 0x2F80
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function onuseclear()
{
	globallogic_utils::resumetimer();
	hud_setflagprogressbar(0);
}

/*
	Name: statusdialog
	Namespace: res
	Checksum: 0x3C59C3BE
	Offset: 0x2FB8
	Size: 0x6E
	Parameters: 2
	Flags: None
*/
function statusdialog(dialog, team)
{
	time = gettime();
	if(gettime() < (level.laststatus[team] + 6000))
	{
		return;
	}
	thread delayedleaderdialog(dialog, team);
	level.laststatus[team] = gettime();
}

/*
	Name: onenduse
	Namespace: res
	Checksum: 0x4DF20EC4
	Offset: 0x3030
	Size: 0xA4
	Parameters: 3
	Flags: None
*/
function onenduse(team, player, success)
{
	setdvar(("scr_obj" + self gameobjects::get_label()) + "_flash", 0);
	self.objpoints["allies"] thread objpoints::stop_flashing();
	self.objpoints["axis"] thread objpoints::stop_flashing();
}

/*
	Name: resetflagbaseeffect
	Namespace: res
	Checksum: 0xBA315371
	Offset: 0x30E0
	Size: 0xBC
	Parameters: 0
	Flags: None
*/
function resetflagbaseeffect()
{
	if(isdefined(self.baseeffect))
	{
		return;
	}
	team = self gameobjects::get_owner_team();
	if(team != "axis" && team != "allies")
	{
		return;
	}
	fxid = level.flagbasefxid[team];
	self.baseeffect = spawnfx(fxid, self.baseeffectpos, self.baseeffectforward, self.baseeffectright);
	triggerfx(self.baseeffect);
}

/*
	Name: onuse
	Namespace: res
	Checksum: 0x7581182
	Offset: 0x31A8
	Size: 0x5C4
	Parameters: 2
	Flags: None
*/
function onuse(player, team)
{
	team = player.pers["team"];
	oldteam = self gameobjects::get_owner_team();
	label = self gameobjects::get_label();
	/#
		print("" + self.label);
	#/
	setupnextflag(self.orderindex + 1);
	if((self.orderindex + 1) == level.resflags.size || level.overtime)
	{
		setgameendtime(0);
		wait(1);
		res_endgame(player.team, game["strings"]["flags_capped"]);
	}
	else
	{
		level.usestartspawns = 0;
		/#
			assert(team != "");
		#/
		if([[level.gettimelimit]]() > 0 && level.extratime)
		{
			level.usingextratime = 1;
			if(!level.hardcoremode)
			{
				iprintln(&"MP_TIME_EXTENDED");
			}
		}
		spawnlogic::clear_spawn_points();
		spawnlogic::add_spawn_points("allies", "mp_res_spawn_allies");
		spawnlogic::add_spawn_points("axis", "mp_res_spawn_axis");
		if(label == "_a")
		{
			spawnlogic::clear_spawn_points();
			spawnlogic::add_spawn_points("allies", "mp_res_spawn_allies_a");
			spawnlogic::add_spawn_points("axis", "mp_res_spawn_axis");
		}
		else
		{
			if(label == "_b")
			{
				spawnlogic::add_spawn_points(game["attackers"], "mp_res_spawn_allies_b");
				spawnlogic::add_spawn_points(game["defenders"], "mp_res_spawn_axis");
			}
			else
			{
				spawnlogic::add_spawn_points("allies", "mp_res_spawn_allies_c");
				spawnlogic::add_spawn_points("allies", "mp_res_spawn_axis");
			}
		}
		spawning::updateallspawnpoints();
		string = &"";
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
		/#
			assert(string != (&""));
		#/
		touchlist = [];
		touchkeys = getarraykeys(self.touchlist[team]);
		for(i = 0; i < touchkeys.size; i++)
		{
			touchlist[touchkeys[i]] = self.touchlist[team][touchkeys[i]];
		}
		thread give_capture_credit(touchlist, string);
		thread util::printandsoundoneveryone(team, oldteam, &"", &"", "mp_war_objective_taken", "mp_war_objective_lost", "");
		if(getteamflagcount(team) == level.flags.size)
		{
			statusdialog("secure_all", team);
			statusdialog("lost_all", oldteam);
		}
		else
		{
			statusdialog("secured" + self.label, team);
			statusdialog("lost" + self.label, oldteam);
		}
		level.bestspawnflag[oldteam] = self.levelflag;
		self update_spawn_influencers(team);
	}
}

/*
	Name: give_capture_credit
	Namespace: res
	Checksum: 0xD4BF53F0
	Offset: 0x3778
	Size: 0x176
	Parameters: 2
	Flags: None
*/
function give_capture_credit(touchlist, string)
{
	wait(0.05);
	util::waittillslowprocessallowed();
	players = getarraykeys(touchlist);
	for(i = 0; i < players.size; i++)
	{
		player_from_touchlist = touchlist[players[i]].player;
		player_from_touchlist recordgameevent("capture");
		if(isdefined(player_from_touchlist.pers["captures"]))
		{
			player_from_touchlist.pers["captures"]++;
			player_from_touchlist.captures = player_from_touchlist.pers["captures"];
		}
		demo::bookmark("event", gettime(), player_from_touchlist);
		player_from_touchlist addplayerstatwithgametype("CAPTURES", 1);
		level thread popups::displayteammessagetoall(string, player_from_touchlist);
	}
}

/*
	Name: delayedleaderdialog
	Namespace: res
	Checksum: 0x3F1C2BA6
	Offset: 0x38F8
	Size: 0x44
	Parameters: 2
	Flags: None
*/
function delayedleaderdialog(sound, team)
{
	wait(0.1);
	util::waittillslowprocessallowed();
	globallogic_audio::leader_dialog(sound, team);
}

/*
	Name: onscoreclosemusic
	Namespace: res
	Checksum: 0x9E2AE65D
	Offset: 0x3948
	Size: 0x292
	Parameters: 0
	Flags: None
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
	if(alliedscore > axisscore)
	{
		currentscore = alliedscore;
	}
	else
	{
		currentscore = axisscore;
	}
	if(getdvarint("debug_music") > 0)
	{
		/#
			println("" + scoredif);
			println("" + axisscore);
			println("" + alliedscore);
			println("" + scorelimit);
			println("" + currentscore);
			println("" + scorethreshold);
			println("" + scoredif);
			println("" + scorethresholdstart);
		#/
	}
	if(scoredif <= scorethreshold && scorethresholdstart <= currentscore && level.playingactionmusic != 1)
	{
		thread globallogic_audio::set_music_on_team("timeOut");
	}
	else
	{
		return;
	}
}

/*
	Name: onplayerkilled
	Namespace: res
	Checksum: 0xA3A7F56A
	Offset: 0x3BE8
	Size: 0x314
	Parameters: 9
	Flags: None
*/
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	if(self.touchtriggers.size && isplayer(attacker) && attacker.pers["team"] != self.pers["team"])
	{
		triggerids = getarraykeys(self.touchtriggers);
		ownerteam = self.touchtriggers[triggerids[0]].useobj.ownerteam;
		team = self.pers["team"];
		if(team == ownerteam)
		{
			if(!isdefined(attacker.res_offends))
			{
				attacker.res_offends = 0;
			}
			attacker.res_offends++;
			if(level.playeroffensivemax >= attacker.res_offends)
			{
				attacker medals::offenseglobalcount();
				attacker thread challenges::killedbaseoffender(self.touchtriggers[triggerids[0]], weapon);
				scoreevents::processscoreevent("killed_defender", attacker);
				self recordkillmodifier("defending");
			}
		}
		else
		{
			if(!isdefined(attacker.res_defends))
			{
				attacker.res_defends = 0;
			}
			attacker.res_defends++;
			if(level.playerdefensivemax >= attacker.res_defends)
			{
				attacker medals::defenseglobalcount();
				attacker thread challenges::killedbasedefender(self.touchtriggers[triggerids[0]]);
				if(isdefined(attacker.pers["defends"]))
				{
					attacker.pers["defends"]++;
					attacker.defends = attacker.pers["defends"];
				}
				scoreevents::processscoreevent("killed_attacker", attacker, undefined, weapon);
				self recordkillmodifier("assaulting");
			}
		}
	}
}

/*
	Name: getteamflagcount
	Namespace: res
	Checksum: 0x46AA31EF
	Offset: 0x3F08
	Size: 0x78
	Parameters: 1
	Flags: None
*/
function getteamflagcount(team)
{
	score = 0;
	for(i = 0; i < level.flags.size; i++)
	{
		if(level.resflags[i] gameobjects::get_owner_team() == team)
		{
			score++;
		}
	}
	return score;
}

/*
	Name: getflagteam
	Namespace: res
	Checksum: 0x2674AA4D
	Offset: 0x3F88
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function getflagteam()
{
	return self.useobj gameobjects::get_owner_team();
}

/*
	Name: updateobjectivehintmessages
	Namespace: res
	Checksum: 0x18F957F5
	Offset: 0x3FB0
	Size: 0x4A
	Parameters: 2
	Flags: None
*/
function updateobjectivehintmessages(alliesobjective, axisobjective)
{
	game["strings"]["objective_hint_allies"] = alliesobjective;
	game["strings"]["objective_hint_axis"] = axisobjective;
}

/*
	Name: createflagspawninfluencers
	Namespace: res
	Checksum: 0x21FEF450
	Offset: 0x4008
	Size: 0x124
	Parameters: 0
	Flags: None
*/
function createflagspawninfluencers()
{
	ss = level.spawnsystem;
	for(flag_index = 0; flag_index < level.flags.size; flag_index++)
	{
		if(level.resflags[flag_index] == self)
		{
			break;
		}
	}
	self.owned_flag_influencer = self spawning::create_influencer("res_friendly", self.trigger.origin, 0);
	self.neutral_flag_influencer = self spawning::create_influencer("res_neutral", self.trigger.origin, 0);
	self.enemy_flag_influencer = self spawning::create_influencer("res_enemy", self.trigger.origin, 0);
	self update_spawn_influencers("neutral");
}

/*
	Name: update_spawn_influencers
	Namespace: res
	Checksum: 0xB8A020C2
	Offset: 0x4138
	Size: 0x18C
	Parameters: 1
	Flags: None
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
	Name: hud_createflagprogressbar
	Namespace: res
	Checksum: 0x4C71CF1
	Offset: 0x42D0
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function hud_createflagprogressbar()
{
	level.attackerscaptureprogresshud = hud::createteamprogressbar(game["attackers"]);
	level.defenderscaptureprogresshud = hud::createteamprogressbar(game["defenders"]);
	hud_hideflagprogressbar();
}

/*
	Name: hud_hideflagprogressbar
	Namespace: res
	Checksum: 0x81E7EC2
	Offset: 0x4340
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function hud_hideflagprogressbar()
{
	hud_setflagprogressbar(0);
	level.attackerscaptureprogresshud hud::hideelem();
	level.defenderscaptureprogresshud hud::hideelem();
}

/*
	Name: hud_showflagprogressbar
	Namespace: res
	Checksum: 0x5A5E1D2A
	Offset: 0x4398
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function hud_showflagprogressbar()
{
	level.attackerscaptureprogresshud hud::showelem();
	level.defenderscaptureprogresshud hud::showelem();
}

/*
	Name: hud_setflagprogressbar
	Namespace: res
	Checksum: 0x6479D38C
	Offset: 0x43D8
	Size: 0x13C
	Parameters: 2
	Flags: None
*/
function hud_setflagprogressbar(value, cappingteam)
{
	if(value < 0)
	{
		value = 0;
	}
	if(value > 1)
	{
		value = 1;
	}
	if(isdefined(cappingteam))
	{
		if(cappingteam == game["attackers"])
		{
			level.attackerscaptureprogresshud.bar.color = vectorscale((1, 1, 1), 255);
			level.defenderscaptureprogresshud.bar.color = vectorscale((1, 0, 0), 255);
		}
		else
		{
			level.attackerscaptureprogresshud.bar.color = vectorscale((1, 0, 0), 255);
			level.defenderscaptureprogresshud.bar.color = vectorscale((1, 1, 1), 255);
		}
	}
	level.attackerscaptureprogresshud hud::updatebar(value);
	level.defenderscaptureprogresshud hud::updatebar(value);
}

