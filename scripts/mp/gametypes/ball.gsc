// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_armor;
#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_player;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_ui;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\teams\_teams;
#using scripts\shared\_oob;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace ball;

/*
	Name: __init__sytem__
	Namespace: ball
	Checksum: 0x59390AF2
	Offset: 0xDF0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ball", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ball
	Checksum: 0x313E53D9
	Offset: 0xE30
	Size: 0xF4
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "ballcarrier", 1, 1, "int");
	clientfield::register("allplayers", "passoption", 1, 1, "int");
	clientfield::register("world", "ball_away", 1, 1, "int");
	clientfield::register("world", "ball_score_allies", 1, 1, "int");
	clientfield::register("world", "ball_score_axis", 1, 1, "int");
}

/*
	Name: main
	Namespace: ball
	Checksum: 0xB5BB28F0
	Offset: 0xF30
	Size: 0x51C
	Parameters: 0
	Flags: None
*/
function main()
{
	globallogic::init();
	util::registertimelimit(0, 1440);
	util::registerroundlimit(0, 10);
	util::registerroundwinlimit(0, 10);
	util::registerroundswitch(0, 9);
	util::registernumlives(0, 100);
	util::registerroundscorelimit(0, 5000);
	util::registerscorelimit(0, 5000);
	level.scoreroundwinbased = getgametypesetting("cumulativeRoundScores") == 0;
	level.teamkillpenaltymultiplier = getgametypesetting("teamKillPenalty");
	level.teamkillscoremultiplier = getgametypesetting("teamKillScore");
	level.enemyobjectivepingtime = getgametypesetting("objectivePingTime");
	if(level.roundscorelimit)
	{
		level.carryscore = math::clamp(getgametypesetting("carryScore"), 0, level.roundscorelimit);
		level.throwscore = math::clamp(getgametypesetting("throwScore"), 0, level.roundscorelimit);
	}
	else
	{
		level.carryscore = getgametypesetting("carryScore");
		level.throwscore = getgametypesetting("throwScore");
	}
	level.carryarmor = getgametypesetting("carrierArmor");
	level.ballcount = getgametypesetting("ballCount");
	level.enemycarriervisible = getgametypesetting("enemyCarrierVisible");
	level.idleflagreturntime = getgametypesetting("idleFlagResetTime");
	globallogic::registerfriendlyfiredelay(level.gametype, 15, 0, 1440);
	level.teambased = 1;
	level.overrideteamscore = 1;
	level.clampscorelimit = 0;
	level.doubleovertime = 1;
	level.onprecachegametype = &onprecachegametype;
	level.onstartgametype = &onstartgametype;
	level.onspawnplayer = &onspawnplayer;
	level.onplayerkilled = &onplayerkilled;
	level.onroundswitch = &onroundswitch;
	level.onroundscorelimit = &onroundscorelimit;
	level.onendgame = &onendgame;
	level.onroundendgame = &onroundendgame;
	level.getteamkillpenalty = &ball_getteamkillpenalty;
	level.getteamkillscore = &ball_getteamkillscore;
	level.setmatchscorehudelemforteam = &setmatchscorehudelemforteam;
	level.shouldplayovertimeround = &shouldplayovertimeround;
	level.ontimelimit = &ball_ontimelimit;
	gameobjects::register_allowed_gameobject(level.gametype);
	globallogic_audio::set_leader_gametype_dialog("startUplink", "hcStartUplink", "uplOrders", "uplOrders");
	if(!sessionmodeissystemlink() && !sessionmodeisonlinegame() && issplitscreen())
	{
		globallogic::setvisiblescoreboardcolumns("score", "kills", "carries", "throws", "deaths");
	}
	else
	{
		globallogic::setvisiblescoreboardcolumns("score", "kills", "deaths", "carries", "throws");
	}
}

/*
	Name: onprecachegametype
	Namespace: ball
	Checksum: 0x4F9896F7
	Offset: 0x1458
	Size: 0x22
	Parameters: 0
	Flags: None
*/
function onprecachegametype()
{
	game["strings"]["score_limit_reached"] = &"MP_CAP_LIMIT_REACHED";
}

/*
	Name: onstartgametype
	Namespace: ball
	Checksum: 0xEAB60EF9
	Offset: 0x1488
	Size: 0x76C
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
	level.usestartspawns = 1;
	level.ballworldweapon = getweapon("ball_world");
	level.passingballweapon = getweapon("ball_world_pass");
	if(!isdefined(game["switchedsides"]))
	{
		game["switchedsides"] = 0;
	}
	setclientnamemode("auto_change");
	if(level.scoreroundwinbased)
	{
		globallogic_score::resetteamscores();
	}
	util::setobjectivetext("allies", &"OBJECTIVES_BALL");
	util::setobjectivetext("axis", &"OBJECTIVES_BALL");
	if(level.splitscreen)
	{
		util::setobjectivescoretext("allies", &"OBJECTIVES_BALL");
		util::setobjectivescoretext("axis", &"OBJECTIVES_BALL");
	}
	else
	{
		util::setobjectivescoretext("allies", &"OBJECTIVES_BALL_SCORE");
		util::setobjectivescoretext("axis", &"OBJECTIVES_BALL_SCORE");
	}
	util::setobjectivehinttext("allies", &"OBJECTIVES_BALL_HINT");
	util::setobjectivehinttext("axis", &"OBJECTIVES_BALL_HINT");
	if(isdefined(game["overtime_round"]))
	{
		if(!isdefined(game["ball_game_score"]))
		{
			game["ball_game_score"] = [];
			game["ball_game_score"]["allies"] = [[level._getteamscore]]("allies");
			game["ball_game_score"]["axis"] = [[level._getteamscore]]("axis");
		}
		[[level._setteamscore]]("allies", 0);
		[[level._setteamscore]]("axis", 0);
		if(isdefined(game["ball_overtime_score_to_beat"]))
		{
			util::registerscorelimit(game["ball_overtime_score_to_beat"], game["ball_overtime_score_to_beat"]);
		}
		else
		{
			util::registerscorelimit(1, 1);
		}
		if(isdefined(game["ball_overtime_time_to_beat"]))
		{
			util::registertimelimit(game["ball_overtime_time_to_beat"] / 60000, game["ball_overtime_time_to_beat"] / 60000);
		}
		else
		{
			util::registertimelimit(0, 1440);
		}
		if(game["overtime_round"] == 1)
		{
			util::setobjectivehinttext("allies", &"MP_BALL_OVERTIME_ROUND_1");
			util::setobjectivehinttext("axis", &"MP_BALL_OVERTIME_ROUND_1");
		}
		else
		{
			if(isdefined(game["ball_overtime_first_winner"]))
			{
				level.ontimelimit = &ballovertimeround2_ontimelimit;
				game["teamSuddenDeath"][game["ball_overtime_first_winner"]] = 1;
				util::setobjectivehinttext(game["ball_overtime_first_winner"], &"MP_BALL_OVERTIME_ROUND_2_WINNER");
				util::setobjectivehinttext(util::getotherteam(game["ball_overtime_first_winner"]), &"MP_BALL_OVERTIME_ROUND_2_LOSER");
			}
			else
			{
				level.ontimelimit = &ballovertimeround2_ontimelimit;
				util::setobjectivehinttext("allies", &"MP_BALL_OVERTIME_ROUND_2_TIE");
				util::setobjectivehinttext("axis", &"MP_BALL_OVERTIME_ROUND_2_TIE");
			}
		}
	}
	else if(isdefined(game["round_time_to_beat"]))
	{
		util::registertimelimit(game["round_time_to_beat"] / 60000, game["round_time_to_beat"] / 60000);
	}
	spawning::create_map_placed_influencers();
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	spawnlogic::place_spawn_points("mp_ctf_spawn_allies_start");
	spawnlogic::place_spawn_points("mp_ctf_spawn_axis_start");
	spawnlogic::add_spawn_points("allies", "mp_ctf_spawn_allies");
	spawnlogic::add_spawn_points("axis", "mp_ctf_spawn_axis");
	spawning::add_fallback_spawnpoints("allies", "mp_tdm_spawn");
	spawning::add_fallback_spawnpoints("axis", "mp_tdm_spawn");
	spawning::updateallspawnpoints();
	spawning::update_fallback_spawnpoints();
	level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
	setmapcenter(level.mapcenter);
	spawnpoint = spawnlogic::get_random_intermission_point();
	setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
	level.spawn_axis = spawnlogic::get_spawnpoint_array("mp_ctf_spawn_axis");
	level.spawn_allies = spawnlogic::get_spawnpoint_array("mp_ctf_spawn_allies");
	level.spawn_start = [];
	foreach(team in level.teams)
	{
		level.spawn_start[team] = spawnlogic::get_spawnpoint_array(("mp_ctf_spawn_" + team) + "_start");
	}
	level thread setup_objectives();
}

/*
	Name: anyballsintheair
	Namespace: ball
	Checksum: 0xE9BB7B1A
	Offset: 0x1C00
	Size: 0xC2
	Parameters: 0
	Flags: None
*/
function anyballsintheair()
{
	foreach(ball in level.balls)
	{
		if(isdefined(ball.carrier))
		{
			continue;
		}
		if(isdefined(ball.projectile))
		{
			if(!ball.projectile isonground())
			{
				return ball;
			}
		}
	}
}

/*
	Name: waitforballtocometorest
	Namespace: ball
	Checksum: 0x453FCB10
	Offset: 0x1CD0
	Size: 0x8A
	Parameters: 0
	Flags: None
*/
function waitforballtocometorest()
{
	self endon(#"reset");
	self endon(#"pickup_object");
	if(isdefined(self.projectile))
	{
		if(self.projectile isonground())
		{
			return;
		}
		self.projectile endon(#"death");
		self.projectile endon(#"stationary");
		self.projectile endon(#"grenade_bounce");
		while(true)
		{
			wait(1);
		}
	}
}

/*
	Name: freezeplayersforroundend
	Namespace: ball
	Checksum: 0xF1BA8231
	Offset: 0x1D68
	Size: 0x9C
	Parameters: 0
	Flags: None
*/
function freezeplayersforroundend()
{
	self endon(#"disconnect");
	self globallogic_player::freezeplayerforroundend();
	self thread globallogic::roundenddof(4);
	self waittill(#"spawned");
	if(self.sessionstate == "playing")
	{
		self globallogic_player::freezeplayerforroundend();
		self thread globallogic::roundenddof(4);
	}
}

/*
	Name: waitforallballstocometorest
	Namespace: ball
	Checksum: 0xFB2E7CA2
	Offset: 0x1E10
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function waitforallballstocometorest()
{
	ball = anyballsintheair();
	if(isdefined(ball))
	{
		level.ontimelimit = &ball_ontimelimit_donothing;
		ball waitforballtocometorest();
	}
}

/*
	Name: ball_ontimelimit
	Namespace: ball
	Checksum: 0x3AEA020B
	Offset: 0x1E78
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function ball_ontimelimit()
{
	waitforallballstocometorest();
	globallogic_defaults::default_ontimelimit();
}

/*
	Name: ball_ontimelimit_donothing
	Namespace: ball
	Checksum: 0x99EC1590
	Offset: 0x1EA8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function ball_ontimelimit_donothing()
{
}

/*
	Name: ballovertimeround2_ontimelimit
	Namespace: ball
	Checksum: 0xF60CA9E7
	Offset: 0x1EB8
	Size: 0x1D4
	Parameters: 0
	Flags: None
*/
function ballovertimeround2_ontimelimit()
{
	waitforallballstocometorest();
	winner = undefined;
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			if(game["teamSuddenDeath"][team])
			{
				winner = team;
				break;
			}
		}
		if(!isdefined(winner))
		{
			winner = globallogic::determineteamwinnerbygamestat("teamScores");
		}
		globallogic_utils::logteamwinstring("time limit", winner);
	}
	else
	{
		winner = globallogic_score::gethighestscoringplayer();
		/#
			if(isdefined(winner))
			{
				print("" + winner.name);
			}
			else
			{
				print("");
			}
		#/
	}
	setdvar("ui_text_endreason", game["strings"]["time_limit_reached"]);
	thread globallogic::endgame(winner, game["strings"]["time_limit_reached"]);
}

/*
	Name: onspawnplayer
	Namespace: ball
	Checksum: 0xAFACD58D
	Offset: 0x2098
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function onspawnplayer(predictedspawn)
{
	self.isballcarrier = 0;
	self.ballcarried = undefined;
	self clientfield::set("ctf_flag_carrier", 0);
	self thread ballconsistencyswitchthread();
	spawning::onspawnplayer(predictedspawn);
}

/*
	Name: ballconsistencyswitchthread
	Namespace: ball
	Checksum: 0x42EEE9AD
	Offset: 0x2118
	Size: 0x1A8
	Parameters: 0
	Flags: None
*/
function ballconsistencyswitchthread()
{
	self endon(#"death");
	self endon(#"delete");
	player = self;
	ball = getweapon("ball");
	while(true)
	{
		if(isdefined(ball) && player hasweapon(ball))
		{
			curweapon = player getcurrentweapon();
			if(isdefined(curweapon) && curweapon != ball && !player isswitchingweapons())
			{
				if(curweapon.isheroweapon)
				{
					slot = self gadgetgetslot(curweapon);
					if(!self ability_player::gadget_is_in_use(slot))
					{
						wait(0.05);
						continue;
					}
				}
				/#
					println("");
				#/
				player switchtoweapon(ball);
				player disableweaponcycling();
				player disableoffhandweapons();
			}
		}
		wait(0.05);
	}
}

/*
	Name: onplayerkilled
	Namespace: ball
	Checksum: 0xC619453
	Offset: 0x22C8
	Size: 0x5F2
	Parameters: 9
	Flags: None
*/
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	if(isdefined(self.carryobject))
	{
		otherteam = util::getotherteam(self.team);
		self recordgameevent("return");
		if(isdefined(attacker) && isplayer(attacker) && attacker != self)
		{
			attacker recordgameevent("kill_carrier");
			if(attacker.team != self.team)
			{
				scoreevents::processscoreevent("kill_ball_carrier", attacker, undefined, weapon);
				attacker addplayerstat("kill_carrier", 1);
			}
			globallogic_audio::leader_dialog("uplWeDrop", self.team, undefined, "uplink_ball");
			globallogic_audio::leader_dialog("uplTheyDrop", otherteam, undefined, "uplink_ball");
			globallogic_audio::play_2d_on_team("mpl_balldrop_sting_friend", self.team);
			globallogic_audio::play_2d_on_team("mpl_balldrop_sting_enemy", otherteam);
			level thread popups::displayteammessagetoteam(&"MP_BALL_DROPPED", self, self.team);
			level thread popups::displayteammessagetoteam(&"MP_BALL_DROPPED", self, otherteam);
		}
	}
	else if(isdefined(attacker.carryobject) && attacker.team != self.team)
	{
		scoreevents::processscoreevent("kill_enemy_while_carrying_ball", attacker, undefined, weapon);
	}
	foreach(ball in level.balls)
	{
		ballcarrier = ball.carrier;
		if(isdefined(ballcarrier))
		{
			ballorigin = ball.carrier.origin;
			iscarried = 1;
		}
		else
		{
			ballorigin = ball.curorigin;
			iscarried = 0;
		}
		if(iscarried && isdefined(attacker) && isdefined(attacker.team) && attacker != self && ballcarrier != attacker)
		{
			if(attacker.team == ball.carrier.team)
			{
				dist = distance2dsquared(self.origin, ballorigin);
				if(dist < level.defaultoffenseradiussq)
				{
					attacker addplayerstat("defend_carrier", 1);
					break;
				}
			}
		}
	}
	victim = self;
	foreach(ball_goal in level.ball_goals)
	{
		if(isdefined(attacker) && isdefined(attacker.team) && attacker != victim && isdefined(victim.team) && isplayer(attacker))
		{
			dist_to_goal = distance2dsquared(attacker.origin, ball_goal.origin);
			victim_dist_to_goal = distance2dsquared(victim.origin, ball_goal.origin);
			if(dist_to_goal < level.defaultoffenseradiussq || victim_dist_to_goal < level.defaultoffenseradiussq)
			{
				if(victim.team == ball_goal.team)
				{
					attacker thread challenges::killedbasedefender(ball_goal.trigger);
					continue;
				}
				attacker thread challenges::killedbaseoffender(ball_goal.trigger, weapon);
			}
		}
	}
}

/*
	Name: onroundswitch
	Namespace: ball
	Checksum: 0x4A11970D
	Offset: 0x28C8
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function onroundswitch()
{
	if(!isdefined(game["switchedsides"]))
	{
		game["switchedsides"] = 0;
	}
	level.halftimetype = "halftime";
	game["switchedsides"] = !game["switchedsides"];
}

/*
	Name: onroundscorelimit
	Namespace: ball
	Checksum: 0x1E0AFFC1
	Offset: 0x2920
	Size: 0x9A
	Parameters: 0
	Flags: None
*/
function onroundscorelimit()
{
	if(!isdefined(game["overtime_round"]))
	{
		timelimit = getgametypesetting("timeLimit") * 60000;
		timetobeat = globallogic_utils::gettimepassed();
		if(timelimit > 0 && timetobeat < timelimit)
		{
			game["round_time_to_beat"] = timetobeat;
		}
	}
	return globallogic_defaults::default_onroundscorelimit();
}

/*
	Name: onendgame
	Namespace: ball
	Checksum: 0x39DEC839
	Offset: 0x29C8
	Size: 0xF8
	Parameters: 1
	Flags: None
*/
function onendgame(winningteam)
{
	if(!isdefined(winningteam) || winningteam == "tie")
	{
		return;
	}
	if(isdefined(game["overtime_round"]))
	{
		if(game["overtime_round"] == 1)
		{
			game["ball_overtime_first_winner"] = winningteam;
			game["ball_overtime_score_to_beat"] = getteamscore(winningteam);
			game["ball_overtime_time_to_beat"] = globallogic_utils::gettimepassed();
		}
		else
		{
			game["ball_overtime_second_winner"] = winningteam;
			game["ball_overtime_best_score"] = getteamscore(winningteam);
			game["ball_overtime_best_time"] = globallogic_utils::gettimepassed();
		}
	}
}

/*
	Name: updateteamscorebyroundswon
	Namespace: ball
	Checksum: 0xC68A2ABD
	Offset: 0x2AC8
	Size: 0xA2
	Parameters: 0
	Flags: None
*/
function updateteamscorebyroundswon()
{
	if(level.scoreroundwinbased)
	{
		foreach(team in level.teams)
		{
			[[level._setteamscore]](team, game["roundswon"][team]);
		}
	}
}

/*
	Name: onroundendgame
	Namespace: ball
	Checksum: 0x27B6687B
	Offset: 0x2B78
	Size: 0x33C
	Parameters: 1
	Flags: None
*/
function onroundendgame(winningteam)
{
	if(isdefined(game["overtime_round"]))
	{
		if(isdefined(game["ball_overtime_first_winner"]))
		{
			losing_team_score = 0;
			if(!isdefined(winningteam) || winningteam == "tie")
			{
				winningteam = game["ball_overtime_first_winner"];
			}
			if(game["ball_overtime_first_winner"] == winningteam)
			{
				level.endvictoryreasontext = &"MPUI_BALL_OVERTIME_FASTEST_CAP_TIME";
				level.enddefeatreasontext = &"MPUI_BALL_OVERTIME_DEFEAT_TIMELIMIT";
			}
			else
			{
				level.endvictoryreasontext = &"MPUI_BALL_OVERTIME_FASTEST_CAP_TIME";
				level.enddefeatreasontext = &"MPUI_BALL_OVERTIME_DEFEAT_DID_NOT_DEFEND";
			}
		}
		else if(!isdefined(winningteam) || winningteam == "tie")
		{
			updateteamscorebyroundswon();
			return "tie";
		}
		if(level.scoreroundwinbased)
		{
			foreach(team in level.teams)
			{
				score = game["roundswon"][team];
				if(team === winningteam)
				{
					score++;
				}
				[[level._setteamscore]](team, score);
			}
		}
		else
		{
			if(isdefined(game["ball_overtime_score_to_beat"]) && game["ball_overtime_score_to_beat"] > game["ball_overtime_best_score"])
			{
				added_score = game["ball_overtime_score_to_beat"];
			}
			else
			{
				added_score = game["ball_overtime_best_score"];
			}
			foreach(team in level.teams)
			{
				score = game["ball_game_score"][team];
				if(team === winningteam)
				{
					score = score + added_score;
				}
				[[level._setteamscore]](team, score);
			}
		}
		return winningteam;
	}
	if(level.scoreroundwinbased)
	{
		updateteamscorebyroundswon();
		winner = globallogic::determineteamwinnerbygamestat("roundswon");
	}
	else
	{
		winner = globallogic::determineteamwinnerbyteamscore();
	}
	return winner;
}

/*
	Name: setmatchscorehudelemforteam
	Namespace: ball
	Checksum: 0xABC3D2A0
	Offset: 0x2EC0
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function setmatchscorehudelemforteam()
{
	self settext(&"");
}

/*
	Name: shouldplayovertimeround
	Namespace: ball
	Checksum: 0x62044837
	Offset: 0x2EF0
	Size: 0x17C
	Parameters: 0
	Flags: None
*/
function shouldplayovertimeround()
{
	if(isdefined(game["overtime_round"]))
	{
		if(game["overtime_round"] == 1 || !level.gameended)
		{
			return true;
		}
		return false;
	}
	if(!level.scoreroundwinbased)
	{
		if(game["teamScores"]["allies"] == game["teamScores"]["axis"] && (util::hitroundlimit() || game["teamScores"]["allies"] == (level.scorelimit - 1)))
		{
			return true;
		}
	}
	else
	{
		alliesroundswon = util::getroundswon("allies");
		axisroundswon = util::getroundswon("axis");
		if(level.roundwinlimit > 0 && axisroundswon == (level.roundwinlimit - 1) && alliesroundswon == (level.roundwinlimit - 1))
		{
			return true;
		}
		if(util::hitroundlimit() && alliesroundswon == axisroundswon)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: ball_getteamkillpenalty
	Namespace: ball
	Checksum: 0x2B6946BE
	Offset: 0x3078
	Size: 0x7E
	Parameters: 4
	Flags: None
*/
function ball_getteamkillpenalty(einflictor, attacker, smeansofdeath, weapon)
{
	teamkill_penalty = globallogic_defaults::default_getteamkillpenalty(einflictor, attacker, smeansofdeath, weapon);
	if(isdefined(self.isballcarrier) && self.isballcarrier)
	{
		teamkill_penalty = teamkill_penalty * level.teamkillpenaltymultiplier;
	}
	return teamkill_penalty;
}

/*
	Name: ball_getteamkillscore
	Namespace: ball
	Checksum: 0xF82F3834
	Offset: 0x3100
	Size: 0x8A
	Parameters: 4
	Flags: None
*/
function ball_getteamkillscore(einflictor, attacker, smeansofdeath, weapon)
{
	teamkill_score = rank::getscoreinfovalue("kill");
	if(isdefined(self.isballcarrier) && self.isballcarrier)
	{
		teamkill_score = teamkill_score * level.teamkillscoremultiplier;
	}
	return int(teamkill_score);
}

/*
	Name: get_real_ball_location
	Namespace: ball
	Checksum: 0xCA56900F
	Offset: 0x3198
	Size: 0x154
	Parameters: 6
	Flags: None
*/
function get_real_ball_location(startpos, startangles, index, count, defaultdistance, rotation)
{
	currentangle = startangles[1] + ((360 / count) * 0.5) + ((360 / count) * index);
	coscurrent = cos(currentangle + rotation);
	sincurrent = sin(currentangle + rotation);
	new_position = startpos + (defaultdistance * coscurrent, defaultdistance * sincurrent, 0);
	clip_mask = 1 | 8;
	trace = physicstrace(startpos, new_position, vectorscale((-1, -1, -1), 5), vectorscale((1, 1, 1), 5), self, clip_mask);
	return trace["position"];
}

/*
	Name: setup_objectives
	Namespace: ball
	Checksum: 0xE17E5C79
	Offset: 0x32F8
	Size: 0x348
	Parameters: 0
	Flags: None
*/
function setup_objectives()
{
	level.ball_goals = [];
	level.ball_starts = [];
	level.balls = [];
	level.ball_starts = getentarray("ball_start", "targetname");
	foreach(ball_start in level.ball_starts)
	{
		level.balls[level.balls.size] = spawn_ball(ball_start);
	}
	if(level.ballcount > level.ball_starts.size)
	{
		width = 48;
		height = 48;
		count = level.ballcount - level.ball_starts.size;
		for(index = 0; index < count; index++)
		{
			position = get_real_ball_location(level.ball_starts[0].origin, level.ball_starts[0].angles, index, count, width, 0);
			trigger = spawn("trigger_radius", position, 0, width, height);
			level.ball_starts[level.ball_starts.size] = trigger;
			level.balls[level.balls.size] = spawn_ball(trigger);
		}
	}
	foreach(team in level.teams)
	{
		if(!game["switchedsides"])
		{
			trigger = getent("ball_goal_" + team, "targetname");
		}
		else
		{
			trigger = getent("ball_goal_" + util::getotherteam(team), "targetname");
		}
		level.ball_goals[team] = setup_goal(trigger, team);
	}
}

/*
	Name: setup_goal
	Namespace: ball
	Checksum: 0x6A75C76A
	Offset: 0x3648
	Size: 0x224
	Parameters: 2
	Flags: None
*/
function setup_goal(trigger, team)
{
	useobj = gameobjects::create_use_object(team, trigger, [], (0, 0, trigger.height * 0.5), istring("ball_goal_" + team));
	useobj gameobjects::set_visible_team("any");
	useobj gameobjects::set_model_visibility(1);
	useobj gameobjects::allow_use("enemy");
	useobj gameobjects::set_use_time(0);
	foreach(ball in level.balls)
	{
		useobj gameobjects::set_key_object(ball);
	}
	useobj.canuseobj = &can_use_goal;
	useobj.onuse = &on_use_goal;
	useobj.ball_in_goal = 0;
	useobj.radiussq = trigger.radius * trigger.radius;
	useobj.center = trigger.origin + (0, 0, trigger.height * 0.5);
	return useobj;
}

/*
	Name: can_use_goal
	Namespace: ball
	Checksum: 0xBAA9B3F3
	Offset: 0x3878
	Size: 0x14
	Parameters: 1
	Flags: None
*/
function can_use_goal(player)
{
	return !self.ball_in_goal;
}

/*
	Name: on_use_goal
	Namespace: ball
	Checksum: 0xE5418B89
	Offset: 0x3898
	Size: 0x3FC
	Parameters: 1
	Flags: None
*/
function on_use_goal(player)
{
	if(!isdefined(player) || !isdefined(player.carryobject))
	{
		return;
	}
	if(isdefined(player.carryobject.scorefrozenuntil) && player.carryobject.scorefrozenuntil > gettime())
	{
		return;
	}
	self play_goal_score_fx();
	player.carryobject.scorefrozenuntil = gettime() + 10000;
	ball_check_assist(player, 1);
	team = self.team;
	otherteam = util::getotherteam(team);
	globallogic_audio::flush_objective_dialog("uplink_ball");
	globallogic_audio::leader_dialog("uplWeUplink", otherteam);
	globallogic_audio::leader_dialog("uplTheyUplink", team);
	globallogic_audio::play_2d_on_team("mpl_ballcapture_sting_friend", otherteam);
	globallogic_audio::play_2d_on_team("mpl_ballcapture_sting_enemy", team);
	level thread popups::displayteammessagetoteam(&"MP_BALL_CAPTURE", player, team);
	level thread popups::displayteammessagetoteam(&"MP_BALL_CAPTURE", player, otherteam);
	if(isdefined(player.shoot_charge_bar))
	{
		player.shoot_charge_bar.inuse = 0;
	}
	ball = player.carryobject;
	ball.lastcarrierscored = 1;
	player gameobjects::take_carry_weapon(ball.carryweapon);
	ball ball_set_dropped(1);
	ball thread upload_ball(self);
	if(isdefined(player.pers["carries"]))
	{
		player.pers["carries"]++;
		player.carries = player.pers["carries"];
	}
	bbprint("mpobjective", "gametime %d objtype %s team %s playerx %d playery %d playerz %d", gettime(), "ball_capture", team, player.origin);
	player recordgameevent("capture");
	player challenges::capturedobjective(gettime(), self.trigger);
	player addplayerstatwithgametype("CARRIES", 1);
	player addplayerstatwithgametype("captures", 1);
	scoreevents::processscoreevent("ball_capture_carry", player);
	ball_give_score(otherteam, level.carryscore);
}

/*
	Name: spawn_ball
	Namespace: ball
	Checksum: 0x391D964D
	Offset: 0x3CA0
	Size: 0x378
	Parameters: 1
	Flags: None
*/
function spawn_ball(trigger)
{
	visuals = [];
	visuals[0] = spawn("script_model", trigger.origin);
	visuals[0] setmodel("wpn_t7_uplink_ball_world");
	visuals[0] notsolid();
	trigger enablelinkto();
	trigger linkto(visuals[0]);
	trigger.no_moving_platfrom_unlink = 1;
	ballobj = gameobjects::create_carry_object("neutral", trigger, visuals, (0, 0, 0), istring("ball_ball"), "mpl_hit_alert_ballholder");
	ballobj gameobjects::allow_carry("any");
	ballobj gameobjects::set_visible_team("any");
	ballobj gameobjects::set_drop_offset(8);
	ballobj.objectiveonvisuals = 1;
	ballobj.allowweapons = 0;
	ballobj.carryweapon = getweapon("ball");
	ballobj.keepcarryweapon = 1;
	ballobj.waterbadtrigger = 0;
	ballobj.disallowremotecontrol = 1;
	ballobj.disallowplaceablepickup = 1;
	ballobj gameobjects::update_objective();
	ballobj.canuseobject = &can_use_ball;
	ballobj.onpickup = &on_pickup_ball;
	ballobj.setdropped = &ball_set_dropped;
	ballobj.onreset = &on_reset_ball;
	ballobj.pickuptimeoutoverride = &ball_physics_timeout;
	ballobj.carryweaponthink = &carry_think_ball;
	ballobj.in_goal = 0;
	ballobj.lastcarrierscored = 0;
	ballobj.lastcarrierteam = "neutral";
	if(level.enemycarriervisible == 2)
	{
		ballobj.objidpingfriendly = 1;
	}
	if(level.idleflagreturntime > 0)
	{
		ballobj.autoresettime = level.idleflagreturntime;
	}
	else
	{
		ballobj.autoresettime = undefined;
	}
	playfxontag("ui/fx_uplink_ball_trail", ballobj.visuals[0], "tag_origin");
	return ballobj;
}

/*
	Name: can_use_ball
	Namespace: ball
	Checksum: 0xA881EC7A
	Offset: 0x4020
	Size: 0x3DE
	Parameters: 1
	Flags: None
*/
function can_use_ball(player)
{
	if(!isdefined(player))
	{
		return false;
	}
	if(!self gameobjects::can_interact_with(player))
	{
		return false;
	}
	if(isdefined(self.droptime) && self.droptime >= gettime())
	{
		return false;
	}
	if(isdefined(player.resurrect_weapon) && player getcurrentweapon() == player.resurrect_weapon)
	{
		return false;
	}
	if(player iscarryingturret())
	{
		return false;
	}
	currentweapon = player getcurrentweapon();
	if(isdefined(currentweapon))
	{
		if(!valid_ball_pickup_weapon(currentweapon))
		{
			return false;
		}
	}
	nextweapon = player.changingweapon;
	if(isdefined(nextweapon) && player isswitchingweapons())
	{
		if(!valid_ball_pickup_weapon(nextweapon))
		{
			return false;
		}
	}
	if(player player_no_pickup_time())
	{
		return false;
	}
	ball = self.visuals[0];
	thresh = 15;
	dist2 = distance2dsquared(ball.origin, player.origin);
	if(dist2 < (thresh * thresh))
	{
		return true;
	}
	start = player geteye();
	end = (self.curorigin[0], self.curorigin[1], self.curorigin[2] + 5);
	if(isdefined(ball))
	{
		end = (ball.origin[0], ball.origin[1], ball.origin[2] + 5);
	}
	if(isdefined(self.carrier) && isplayer(self.carrier))
	{
		end = self.carrier geteye();
	}
	first_skip_ent = ball;
	second_skip_ent = ball;
	if(isdefined(self.projectile))
	{
		first_skip_ent = self.projectile;
	}
	if(isdefined(self.lastprojectile))
	{
		second_skip_ent = self.lastprojectile;
	}
	if(!bullettracepassed(end, start, 0, first_skip_ent, second_skip_ent, 0, 0))
	{
		player_origin = (player.origin[0], player.origin[1], player.origin[2] + 10);
		if(!bullettracepassed(end, player_origin, 0, first_skip_ent, second_skip_ent, 0, 0))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: chief_mammal_reset
	Namespace: ball
	Checksum: 0x5FFC5B0A
	Offset: 0x4408
	Size: 0x1A8
	Parameters: 0
	Flags: None
*/
function chief_mammal_reset()
{
	self.isresetting = 1;
	self notify(#"reset");
	origin = self.curorigin;
	if(isdefined(self.projectile))
	{
		origin = self.projectile.origin;
	}
	foreach(visual in self.visuals)
	{
		visual.origin = origin;
		visual.angles = visual.baseangles;
		visual dontinterpolate();
		visual show();
	}
	if(isdefined(self.projectile))
	{
		self.projectile delete();
		self.lastprojectile = undefined;
	}
	self gameobjects::clear_carrier();
	gameobjects::update_world_icons();
	gameobjects::update_compass_icons();
	gameobjects::update_objective();
	self.isresetting = 0;
}

/*
	Name: on_pickup_ball
	Namespace: ball
	Checksum: 0xFED7917
	Offset: 0x45B8
	Size: 0x514
	Parameters: 1
	Flags: None
*/
function on_pickup_ball(player)
{
	self gameobjects::set_flags(0);
	if(!isalive(player))
	{
		self chief_mammal_reset();
		return;
	}
	player disableusability();
	player disableoffhandweapons();
	level.usestartspawns = 0;
	level clientfield::set("ball_away", 1);
	linkedparent = self.visuals[0] getlinkedent();
	if(isdefined(linkedparent))
	{
		self.visuals[0] unlink();
	}
	player resetflashback();
	pass = 0;
	ball_velocity = 0;
	if(isdefined(self.projectile))
	{
		pass = 1;
		ball_velocity = self.projectile getvelocity();
		self.projectile delete();
		self.lastprojectile = undefined;
	}
	if(pass)
	{
		if(self.lastcarrierteam == player.team)
		{
			if(self.lastcarrier != player)
			{
				player.passtime = gettime();
				player.passplayer = self.lastcarrier;
				globallogic_audio::leader_dialog("uplTransferred", player.team, undefined, "uplink_ball");
			}
		}
		else if(length(ball_velocity) > 0.1)
		{
			scoreevents::processscoreevent("ball_intercept", player);
		}
	}
	otherteam = util::getotherteam(player.team);
	if(self.lastcarrierteam != player.team)
	{
		globallogic_audio::leader_dialog("uplWeTake", player.team, undefined, "uplink_ball");
		globallogic_audio::leader_dialog("uplTheyTake", otherteam, undefined, "uplink_ball");
	}
	globallogic_audio::play_2d_on_team("mpl_ballget_sting_friend", player.team);
	globallogic_audio::play_2d_on_team("mpl_ballget_sting_enemy", otherteam);
	level thread popups::displayteammessagetoteam(&"MP_BALL_PICKED_UP", player, player.team);
	level thread popups::displayteammessagetoteam(&"MP_BALL_PICKED_UP", player, otherteam);
	self.lastcarrierscored = 0;
	self.lastcarrier = player;
	self.lastcarrierteam = player.team;
	self gameobjects::set_owner_team(player.team);
	player.balldropdelay = getdvarint("scr_ball_water_drop_delay", 10);
	player.objective = 1;
	player.hasperksprintfire = player hasperk("specialty_sprintfire");
	player setperk("specialty_sprintfire");
	player clientfield::set("ballcarrier", 1);
	if(level.carryarmor > 0)
	{
		player thread armor::setlightarmor(level.carryarmor);
	}
	else
	{
		player thread armor::unsetlightarmor();
	}
	player thread player_update_pass_target(self);
	player recordgameevent("pickup");
}

/*
	Name: ball_carrier_cleanup
	Namespace: ball
	Checksum: 0x42005CDE
	Offset: 0x4AD8
	Size: 0x150
	Parameters: 0
	Flags: None
*/
function ball_carrier_cleanup()
{
	self gameobjects::set_owner_team("neutral");
	if(isdefined(self.carrier))
	{
		self.carrier clientfield::set("ballcarrier", 0);
		self.carrier.balldropdelay = undefined;
		self.carrier.nopickuptime = gettime() + 500;
		self.carrier player_clear_pass_target();
		self.carrier notify(#"cancel_update_pass_target");
		self.carrier thread armor::unsetlightarmor();
		if(!self.carrier.hasperksprintfire)
		{
			self.carrier unsetperk("specialty_sprintfire");
		}
		self.carrier enableusability();
		self.carrier enableoffhandweapons();
		self.carrier setballpassallowed(0);
		self.carrier.objective = 0;
	}
}

/*
	Name: ball_set_dropped
	Namespace: ball
	Checksum: 0x9B860A47
	Offset: 0x4C30
	Size: 0x250
	Parameters: 1
	Flags: None
*/
function ball_set_dropped(skip_physics = 0)
{
	self.isresetting = 1;
	self.droptime = gettime();
	self notify(#"dropped");
	dropangles = (0, 0, 0);
	carrier = self.carrier;
	if(isdefined(carrier) && carrier.team != "spectator")
	{
		droporigin = carrier.origin;
		dropangles = carrier.angles;
	}
	else
	{
		droporigin = self.origin;
	}
	if(!isdefined(droporigin))
	{
		droporigin = self.safeorigin;
	}
	droporigin = droporigin + vectorscale((0, 0, 1), 40);
	if(isdefined(self.projectile))
	{
		self.projectile delete();
	}
	self ball_carrier_cleanup();
	self gameobjects::clear_carrier();
	self gameobjects::set_position(droporigin, dropangles);
	self gameobjects::update_icons_and_objective();
	self thread gameobjects::pickup_timeout(droporigin[2], droporigin[2] - 40);
	self.isresetting = 0;
	if(!skip_physics)
	{
		angles = (0, dropangles[1], 0);
		forward = anglestoforward(angles);
		velocity = (forward * 200) + vectorscale((0, 0, 1), 80);
		ball_physics_launch(velocity);
	}
	return true;
}

/*
	Name: on_reset_ball
	Namespace: ball
	Checksum: 0xDA30032
	Offset: 0x4E88
	Size: 0x16C
	Parameters: 1
	Flags: None
*/
function on_reset_ball(prev_origin)
{
	if(isdefined(level.gameended) && level.gameended)
	{
		return;
	}
	visual = self.visuals[0];
	linkedparent = visual getlinkedent();
	if(isdefined(linkedparent))
	{
		visual unlink();
	}
	if(isdefined(self.projectile))
	{
		self.projectile delete();
	}
	if(!self gameobjects::get_flags(1))
	{
		playfx("ui/fx_uplink_ball_vanish", prev_origin);
		self play_return_vo();
	}
	self.lastcarrierteam = "none";
	self thread download_ball();
	if(isdefined(self.killcament) && isentity(self.killcament))
	{
		self.killcament recordgameeventnonplayer("ball_reset");
	}
}

/*
	Name: reset_ball
	Namespace: ball
	Checksum: 0x860B615
	Offset: 0x5000
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function reset_ball()
{
	self thread gameobjects::return_home();
}

/*
	Name: upload_ball
	Namespace: ball
	Checksum: 0xD26F3717
	Offset: 0x5028
	Size: 0x24C
	Parameters: 1
	Flags: None
*/
function upload_ball(goal)
{
	self notify(#"score_event");
	self.in_goal = 1;
	goal.ball_in_goal = 1;
	if(isdefined(self.projectile))
	{
		self.projectile delete();
	}
	self gameobjects::allow_carry("none");
	move_to_center_time = 0.4;
	move_up_time = 1.2;
	rotate_time = 1;
	in_enemygoal_time = move_to_center_time + rotate_time;
	total_time = in_enemygoal_time + move_up_time;
	self gameobjects::set_flags(1);
	visual = self.visuals[0];
	visual moveto(goal.center, move_to_center_time, 0, move_to_center_time);
	visual rotatevelocity(vectorscale((1, 1, 0), 1080), total_time, total_time, 0);
	wait(in_enemygoal_time);
	goal.ball_in_goal = 0;
	self.visibleteam = "neutral";
	self gameobjects::update_world_icon("friendly", 0);
	self gameobjects::update_world_icon("enemy", 0);
	self gameobjects::update_objective();
	visual movez(4000, move_up_time, move_up_time * 0.1, 0);
	wait(move_up_time);
	self thread gameobjects::return_home();
}

/*
	Name: download_ball
	Namespace: ball
	Checksum: 0x39FCCAC0
	Offset: 0x5280
	Size: 0x228
	Parameters: 0
	Flags: None
*/
function download_ball()
{
	self endon(#"pickup_object");
	self gameobjects::allow_carry("any");
	self gameobjects::set_owner_team("neutral");
	self gameobjects::set_flags(2);
	visual = self.visuals[0];
	visual.origin = visual.baseorigin + vectorscale((0, 0, 1), 4000);
	visual dontinterpolate();
	fall_time = 3;
	visual moveto(visual.baseorigin, fall_time, 0, fall_time);
	visual rotatevelocity(vectorscale((0, 1, 0), 720), fall_time, 0, fall_time);
	self.visibleteam = "any";
	self gameobjects::update_world_icon("friendly", 1);
	self gameobjects::update_world_icon("enemy", 1);
	self gameobjects::update_objective();
	wait(fall_time);
	self gameobjects::set_flags(0);
	level clientfield::set("ball_away", 0);
	playfxontag("ui/fx_uplink_ball_trail", visual, "tag_origin");
	self thread ball_download_fx(visual, fall_time);
	self.in_goal = 0;
}

/*
	Name: carry_think_ball
	Namespace: ball
	Checksum: 0xAEDBF88F
	Offset: 0x54B0
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function carry_think_ball()
{
	self endon(#"disconnect");
	self thread ball_pass_watch();
	self thread ball_shoot_watch();
	self thread ball_weapon_change_watch();
}

/*
	Name: ball_pass_watch
	Namespace: ball
	Checksum: 0x80849EBE
	Offset: 0x5510
	Size: 0x254
	Parameters: 0
	Flags: None
*/
function ball_pass_watch()
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"drop_object");
	while(true)
	{
		self waittill(#"ball_pass", weapon);
		if(!isdefined(self.pass_target))
		{
			playerangles = self getplayerangles();
			playerangles = (math::clamp(playerangles[0], -85, 85), playerangles[1], playerangles[2]);
			dir = anglestoforward(playerangles);
			force = 90;
			self.carryobject thread ball_physics_launch_drop(dir * force, self);
			return;
		}
		break;
	}
	if(isdefined(self.carryobject))
	{
		self thread ball_pass_or_throw_active();
		pass_target = self.pass_target;
		last_target_origin = self.pass_target.origin;
		wait(0.15);
		if(isdefined(self.pass_target))
		{
			pass_target = self.pass_target;
			self.carryobject thread ball_pass_projectile(self, pass_target, last_target_origin);
		}
		else
		{
			playerangles = self getplayerangles();
			playerangles = (math::clamp(playerangles[0], -85, 85), playerangles[1], playerangles[2]);
			dir = anglestoforward(playerangles);
			force = 90;
			self.carryobject thread ball_physics_launch_drop(dir * force, self);
		}
	}
}

/*
	Name: ball_shoot_watch
	Namespace: ball
	Checksum: 0x851718C5
	Offset: 0x5770
	Size: 0x1E4
	Parameters: 0
	Flags: None
*/
function ball_shoot_watch()
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"drop_object");
	extra_pitch = getdvarfloat("scr_ball_shoot_extra_pitch", 0);
	force = getdvarfloat("scr_ball_shoot_force", 900);
	while(true)
	{
		self waittill(#"weapon_fired", weapon);
		if(weapon != getweapon("ball"))
		{
			continue;
		}
		break;
	}
	if(isdefined(self.carryobject))
	{
		playerangles = self getplayerangles();
		playerangles = playerangles + (extra_pitch, 0, 0);
		playerangles = (math::clamp(playerangles[0], -85, 85), playerangles[1], playerangles[2]);
		dir = anglestoforward(playerangles);
		self thread ball_pass_or_throw_active();
		self thread ball_check_pass_kill_pickup(self.carryobject);
		self.carryobject ball_create_killcam_ent();
		self.carryobject thread ball_physics_launch_drop(dir * force, self, 1);
	}
}

/*
	Name: ball_weapon_change_watch
	Namespace: ball
	Checksum: 0xC63C2CA6
	Offset: 0x5960
	Size: 0x1D4
	Parameters: 0
	Flags: None
*/
function ball_weapon_change_watch()
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"drop_object");
	ballweapon = getweapon("ball");
	while(true)
	{
		if(ballweapon == self getcurrentweapon())
		{
			break;
		}
		self waittill(#"weapon_change");
	}
	while(true)
	{
		self waittill(#"weapon_change", weapon, lastweapon);
		if(isdefined(weapon) && weapon.gadget_type == 14)
		{
			break;
		}
		if(weapon === level.weaponnone && lastweapon === ballweapon)
		{
			break;
		}
	}
	playerangles = self getplayerangles();
	playerangles = (math::clamp(playerangles[0], -85, 85), absangleclamp360(playerangles[1] + 20), playerangles[2]);
	dir = anglestoforward(playerangles);
	force = 90;
	self.carryobject thread ball_physics_launch_drop(dir * force, self);
}

/*
	Name: valid_ball_pickup_weapon
	Namespace: ball
	Checksum: 0xBB5E9B2
	Offset: 0x5B40
	Size: 0x66
	Parameters: 1
	Flags: None
*/
function valid_ball_pickup_weapon(weapon)
{
	if(weapon == level.weaponnone)
	{
		return false;
	}
	if(weapon == getweapon("ball"))
	{
		return false;
	}
	if(killstreaks::is_killstreak_weapon(weapon))
	{
		return false;
	}
	return true;
}

/*
	Name: player_no_pickup_time
	Namespace: ball
	Checksum: 0xC91D27AE
	Offset: 0x5BB0
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function player_no_pickup_time()
{
	return isdefined(self.nopickuptime) && self.nopickuptime > gettime();
}

/*
	Name: watchunderwater
	Namespace: ball
	Checksum: 0xB206613
	Offset: 0x5BD8
	Size: 0x10C
	Parameters: 1
	Flags: None
*/
function watchunderwater(trigger)
{
	self endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		if(self isplayerunderwater())
		{
			foreach(ball in level.balls)
			{
				if(isdefined(ball.carrier) && ball.carrier == self)
				{
					ball gameobjects::set_dropped();
					return;
				}
			}
		}
		self.balldropdelay = undefined;
		wait(0.05);
	}
}

/*
	Name: ball_physics_launch_drop
	Namespace: ball
	Checksum: 0xC839A79A
	Offset: 0x5CF0
	Size: 0x7C
	Parameters: 3
	Flags: None
*/
function ball_physics_launch_drop(force, droppingplayer, switchweapon)
{
	ball_set_dropped(1);
	ball_physics_launch(force, droppingplayer);
	if(isdefined(switchweapon) && switchweapon)
	{
		droppingplayer killstreaks::switch_to_last_non_killstreak_weapon(undefined, 1);
	}
}

/*
	Name: ball_check_pass_kill_pickup
	Namespace: ball
	Checksum: 0x6CBBBB7D
	Offset: 0x5D78
	Size: 0x1A4
	Parameters: 1
	Flags: None
*/
function ball_check_pass_kill_pickup(carryobj)
{
	self endon(#"death");
	self endon(#"disconnect");
	carryobj endon(#"reset");
	timer = spawnstruct();
	timer endon(#"timer_done");
	timer thread timer_run(1.5);
	carryobj waittill(#"pickup_object");
	timer timer_cancel();
	if(!isdefined(carryobj.carrier) || carryobj.carrier.team == self.team)
	{
		return;
	}
	carryobj.carrier endon(#"disconnect");
	timer thread timer_run(5);
	carryobj.carrier waittill(#"death", attacker);
	timer timer_cancel();
	if(!isdefined(attacker) || attacker != self)
	{
		return;
	}
	timer thread timer_run(2);
	carryobj waittill(#"pickup_object");
	timer timer_cancel();
}

/*
	Name: timer_run
	Namespace: ball
	Checksum: 0x62F7FF82
	Offset: 0x5F28
	Size: 0x2A
	Parameters: 1
	Flags: None
*/
function timer_run(time)
{
	self endon(#"cancel_timer");
	wait(time);
	self notify(#"timer_done");
}

/*
	Name: timer_cancel
	Namespace: ball
	Checksum: 0xC6369A75
	Offset: 0x5F60
	Size: 0x12
	Parameters: 0
	Flags: None
*/
function timer_cancel()
{
	self notify(#"cancel_timer");
}

/*
	Name: adjust_for_stance
	Namespace: ball
	Checksum: 0x3969AB1
	Offset: 0x5F80
	Size: 0xFC
	Parameters: 1
	Flags: None
*/
function adjust_for_stance(ball)
{
	target = self;
	target endon(#"pass_end");
	offs = 0;
	while(isdefined(target) && isdefined(ball))
	{
		newoffs = 50;
		switch(target getstance())
		{
			case "crouch":
			{
				newoffs = 30;
				break;
			}
			case "prone":
			{
				newoffs = 15;
				break;
			}
		}
		if(newoffs != offs)
		{
			ball ballsettarget(target, (0, 0, newoffs));
			newoffs = offs;
		}
		wait(0.05);
	}
}

/*
	Name: ball_pass_projectile
	Namespace: ball
	Checksum: 0x513675C6
	Offset: 0x6088
	Size: 0x454
	Parameters: 3
	Flags: None
*/
function ball_pass_projectile(passer, target, last_target_origin)
{
	ball_set_dropped(1);
	if(isdefined(target))
	{
		last_target_origin = target.origin;
	}
	offset = vectorscale((0, 0, 1), 60);
	if(target getstance() == "prone")
	{
		offset = vectorscale((0, 0, 1), 15);
	}
	else if(target getstance() == "crouch")
	{
		offset = vectorscale((0, 0, 1), 30);
	}
	playerangles = passer getplayerangles();
	playerangles = (0, playerangles[1], 0);
	dir = anglestoforward(playerangles);
	delta = dir * 50;
	origin = self.visuals[0].origin + delta;
	size = 5;
	trace = physicstrace(self.visuals[0].origin, origin, (size * -1, size * -1, size * -1), (size, size, size), passer, 1);
	if(trace["fraction"] < 1)
	{
		t = 0.7 * trace["fraction"];
		self gameobjects::set_position(self.visuals[0].origin + (delta * t), self.visuals[0].angles);
	}
	else
	{
		self gameobjects::set_position(trace["position"], self.visuals[0].angles);
	}
	pass_dir = vectornormalize((last_target_origin + offset) - self.visuals[0].origin);
	pass_vel = pass_dir * 850;
	self.lastprojectile = self.projectile;
	self.projectile = passer magicmissile(level.passingballweapon, self.visuals[0].origin, pass_vel);
	target thread adjust_for_stance(self.projectile);
	self.visuals[0] linkto(self.projectile);
	self gameobjects::ghost_visuals();
	self ball_create_killcam_ent();
	self ball_clear_contents();
	self thread ball_on_projectile_hit_client(passer);
	self thread ball_on_projectile_death();
	self thread ball_watch_touch_enemy_goal();
	passer killstreaks::switch_to_last_non_killstreak_weapon(undefined, 1);
}

/*
	Name: ball_on_projectile_death
	Namespace: ball
	Checksum: 0x29DF13E8
	Offset: 0x64E8
	Size: 0xC4
	Parameters: 0
	Flags: None
*/
function ball_on_projectile_death()
{
	self.projectile waittill(#"death");
	ball = self.visuals[0];
	if(!isdefined(self.carrier) && !self.in_goal)
	{
		if(ball.origin != (ball.baseorigin + vectorscale((0, 0, 1), 4000)))
		{
			self ball_physics_launch(vectorscale((0, 0, 1), 10));
		}
	}
	self ball_restore_contents();
	ball notify(#"pass_end");
}

/*
	Name: ball_restore_contents
	Namespace: ball
	Checksum: 0xD0F27E4
	Offset: 0x65B8
	Size: 0x6A
	Parameters: 0
	Flags: None
*/
function ball_restore_contents()
{
	if(isdefined(self.visuals[0].old_contents))
	{
		self.visuals[0] setcontents(self.visuals[0].old_contents);
		self.visuals[0].old_contents = undefined;
	}
}

/*
	Name: ball_on_projectile_hit_client
	Namespace: ball
	Checksum: 0x2A7D6C3E
	Offset: 0x6630
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function ball_on_projectile_hit_client(passer)
{
	self endon(#"pass_end");
	self.projectile waittill(#"projectile_impact_player", player);
	self.trigger notify(#"trigger", player);
	self.projectile notify(#"kill_ball_on_projectile_death");
	if(isdefined(passer))
	{
		passer recordgameevent("pass");
	}
}

/*
	Name: ball_clear_contents
	Namespace: ball
	Checksum: 0x9A14F112
	Offset: 0x66C0
	Size: 0x38
	Parameters: 0
	Flags: None
*/
function ball_clear_contents()
{
	self.visuals[0].old_contents = self.visuals[0] setcontents(0);
}

/*
	Name: ball_create_killcam_ent
	Namespace: ball
	Checksum: 0x8E4DA7C0
	Offset: 0x6700
	Size: 0x9C
	Parameters: 0
	Flags: None
*/
function ball_create_killcam_ent()
{
	if(isdefined(self.killcament))
	{
		self.killcament delete();
	}
	self.killcament = spawn("script_model", self.visuals[0].origin);
	self.killcament linkto(self.visuals[0]);
	self.killcament setcontents(0);
}

/*
	Name: ball_pass_or_throw_active
	Namespace: ball
	Checksum: 0x91FCBD90
	Offset: 0x67A8
	Size: 0x98
	Parameters: 0
	Flags: None
*/
function ball_pass_or_throw_active()
{
	self endon(#"death");
	self endon(#"disconnect");
	self.pass_or_throw_active = 1;
	self allowmelee(0);
	while(getweapon("ball") == self getcurrentweapon())
	{
		wait(0.05);
	}
	self allowmelee(1);
	self.pass_or_throw_active = 0;
}

/*
	Name: ball_download_fx
	Namespace: ball
	Checksum: 0x7765C9C6
	Offset: 0x6848
	Size: 0x20
	Parameters: 2
	Flags: None
*/
function ball_download_fx(ball_model, waittime)
{
	self.scorefrozenuntil = 0;
}

/*
	Name: ball_assign_random_start
	Namespace: ball
	Checksum: 0x9805E33A
	Offset: 0x6870
	Size: 0xEC
	Parameters: 0
	Flags: None
*/
function ball_assign_random_start()
{
	new_start = undefined;
	rand_starts = array::randomize(level.ball_starts);
	foreach(start in rand_starts)
	{
		if(start.in_use)
		{
			continue;
		}
		new_start = start;
		break;
	}
	if(!isdefined(new_start))
	{
		return;
	}
	ball_assign_start(new_start);
}

/*
	Name: ball_assign_start
	Namespace: ball
	Checksum: 0xFCFFE9C2
	Offset: 0x6968
	Size: 0xD4
	Parameters: 1
	Flags: None
*/
function ball_assign_start(start)
{
	foreach(vis in self.visuals)
	{
		vis.baseorigin = start.origin;
	}
	self.trigger.baseorigin = start.origin;
	self.current_start = start;
	start.in_use = 1;
}

/*
	Name: ball_physics_launch
	Namespace: ball
	Checksum: 0x15335C42
	Offset: 0x6A48
	Size: 0x32C
	Parameters: 2
	Flags: None
*/
function ball_physics_launch(force, droppingplayer)
{
	visuals = self.visuals[0];
	visuals.origin_prev = undefined;
	origin = visuals.origin;
	owner = visuals;
	if(isdefined(droppingplayer))
	{
		owner = droppingplayer;
		origin = droppingplayer getweaponmuzzlepoint();
		right = anglestoright(force);
		origin = origin + ((right[0], right[1], 0) * 7);
		startpos = origin;
		delta = vectornormalize(force) * 80;
		size = 5;
		trace = physicstrace(startpos, startpos + delta, (size * -1, size * -1, size * -1), (size, size, size), droppingplayer, 1);
		if(trace["fraction"] < 1)
		{
			t = 0.7 * trace["fraction"];
			self gameobjects::set_position(startpos + (delta * t), visuals.angles);
		}
		else
		{
			self gameobjects::set_position(trace["position"], visuals.angles);
		}
	}
	grenade = owner magicmissile(level.ballworldweapon, visuals.origin, force);
	visuals linkto(grenade);
	self gameobjects::ghost_visuals();
	self.lastprojectile = self.projectile;
	self.projectile = grenade;
	visuals dontinterpolate();
	self thread ball_physics_out_of_level();
	self thread ball_watch_touch_enemy_goal();
	self thread ball_physics_touch_cant_pickup_player(droppingplayer);
	self thread ball_check_oob();
}

/*
	Name: ball_check_oob
	Namespace: ball
	Checksum: 0x2F4A12A9
	Offset: 0x6D80
	Size: 0x11C
	Parameters: 0
	Flags: None
*/
function ball_check_oob()
{
	self endon(#"reset");
	self endon(#"pickup_object");
	visual = self.visuals[0];
	while(true)
	{
		skip_oob_check = isdefined(self.in_goal) && self.in_goal || (isdefined(self.isresetting) && self.isresetting);
		if(!skip_oob_check)
		{
			if(visual oob::istouchinganyoobtrigger() || visual is_touching_any_ball_return_trigger() || self gameobjects::should_be_reset(visual.origin[2], visual.origin[2] + 10, 1))
			{
				self reset_ball();
				return;
			}
		}
		wait(0.05);
	}
}

/*
	Name: ball_physics_touch_cant_pickup_player
	Namespace: ball
	Checksum: 0x68F19B88
	Offset: 0x6EA8
	Size: 0xF4
	Parameters: 1
	Flags: None
*/
function ball_physics_touch_cant_pickup_player(droppingplayer)
{
	self endon(#"reset");
	self endon(#"pickup_object");
	ball = self.visuals[0];
	trigger = self.trigger;
	while(true)
	{
		trigger waittill(#"trigger", player);
		if(isdefined(droppingplayer) && droppingplayer == player && player player_no_pickup_time())
		{
			continue;
		}
		if(self.droptime >= gettime())
		{
			continue;
		}
		if(ball.origin == (ball.baseorigin + vectorscale((0, 0, 1), 4000)))
		{
			continue;
		}
	}
}

/*
	Name: ball_physics_fake_bounce
	Namespace: ball
	Checksum: 0xFAFBCF8A
	Offset: 0x6FA8
	Size: 0x92
	Parameters: 0
	Flags: None
*/
function ball_physics_fake_bounce()
{
	ball = self.visuals[0];
	vel = ball getvelocity();
	bounceforce = length(vel) / 10;
	bouncedir = -1 * vectornormalize(vel);
}

/*
	Name: ball_watch_touch_enemy_goal
	Namespace: ball
	Checksum: 0xEF61C6A5
	Offset: 0x7048
	Size: 0x1A4
	Parameters: 0
	Flags: None
*/
function ball_watch_touch_enemy_goal()
{
	self endon(#"reset");
	self endon(#"pickup_object");
	enemygoal = level.ball_goals[util::getotherteam(self.lastcarrierteam)];
	while(true)
	{
		if(!enemygoal can_use_goal())
		{
			wait(0.05);
			continue;
		}
		ballvisual = self.visuals[0];
		distsq = distancesquared(ballvisual.origin, enemygoal.center);
		if(distsq <= enemygoal.radiussq)
		{
			self thread ball_touched_goal(enemygoal);
			return;
		}
		if(isdefined(ballvisual.origin_prev))
		{
			result = line_intersect_sphere(ballvisual.origin_prev, ballvisual.origin, enemygoal.center, enemygoal.trigger.radius);
			if(result)
			{
				self thread ball_touched_goal(enemygoal);
				return;
			}
		}
		wait(0.05);
	}
}

/*
	Name: line_intersect_sphere
	Namespace: ball
	Checksum: 0x5D076EB5
	Offset: 0x71F8
	Size: 0xE4
	Parameters: 4
	Flags: None
*/
function line_intersect_sphere(line_start, line_end, sphere_center, sphere_radius)
{
	dir = vectornormalize(line_end - line_start);
	a = vectordot(dir, line_start - sphere_center);
	a = a * a;
	b = line_start - sphere_center;
	b = b * b;
	c = sphere_radius * sphere_radius;
	return ((a - b) + c) >= 0;
}

/*
	Name: ball_touched_goal
	Namespace: ball
	Checksum: 0x9C7FA449
	Offset: 0x72E8
	Size: 0x3B4
	Parameters: 1
	Flags: None
*/
function ball_touched_goal(goal)
{
	if(isdefined(self.claimplayer))
	{
		return;
	}
	if(isdefined(self.scorefrozenuntil) && self.scorefrozenuntil > gettime())
	{
		return;
	}
	self gameobjects::allow_carry("none");
	goal play_goal_score_fx();
	self.scorefrozenuntil = gettime() + 10000;
	team = goal.team;
	otherteam = util::getotherteam(team);
	globallogic_audio::flush_objective_dialog("uplink_ball");
	globallogic_audio::leader_dialog("uplWeUplinkRemote", otherteam);
	globallogic_audio::leader_dialog("uplTheyUplinkRemote", team);
	globallogic_audio::play_2d_on_team("mpl_ballcapture_sting_friend", otherteam);
	globallogic_audio::play_2d_on_team("mpl_ballcapture_sting_enemy", team);
	if(isdefined(self.lastcarrier))
	{
		level thread popups::displayteammessagetoteam(&"MP_BALL_CAPTURE", self.lastcarrier, team);
		level thread popups::displayteammessagetoteam(&"MP_BALL_CAPTURE", self.lastcarrier, otherteam);
		if(isdefined(self.lastcarrier.pers["throws"]))
		{
			self.lastcarrier.pers["throws"]++;
			self.lastcarrier.throws = self.lastcarrier.pers["throws"];
		}
		bbprint("mpobjective", "gametime %d objtype %s team %s playerx %d playery %d playerz %d", gettime(), "ball_throw", team, self.lastcarrier.origin);
		self.lastcarrier recordgameevent("throw");
		self.lastcarrier addplayerstatwithgametype("THROWS", 1);
		scoreevents::processscoreevent("ball_capture_throw", self.lastcarrier);
		self.lastcarrierscored = 1;
		ball_check_assist(self.lastcarrier, 0);
		self.lastcarrier challenges::capturedobjective(gettime(), self.trigger);
		self.lastcarrier addplayerstatwithgametype("CAPTURES", 1);
	}
	if(isdefined(self.killcament))
	{
		self.killcament unlink();
	}
	self thread upload_ball(goal);
	ball_give_score(otherteam, level.throwscore);
}

/*
	Name: ball_give_score
	Namespace: ball
	Checksum: 0x594041C8
	Offset: 0x76A8
	Size: 0xEC
	Parameters: 2
	Flags: None
*/
function ball_give_score(team, score)
{
	level globallogic_score::giveteamscoreforobjective(team, score);
	if(isdefined(game["overtime_round"]))
	{
		if(game["overtime_round"] == 1)
		{
		}
		else
		{
			if(game["ball_overtime_first_winner"] === team)
			{
				thread globallogic::endgame(team, game["strings"]["score_limit_reached"]);
			}
			team_score = [[level._getteamscore]](team);
			other_team_score = [[level._getteamscore]](util::getotherteam(team));
		}
	}
}

/*
	Name: should_record_final_score_cam
	Namespace: ball
	Checksum: 0xE50000C7
	Offset: 0x77A0
	Size: 0x74
	Parameters: 2
	Flags: None
*/
function should_record_final_score_cam(team, score_to_add)
{
	team_score = [[level._getteamscore]](team);
	other_team_score = [[level._getteamscore]](util::getotherteam(team));
	return (team_score + score_to_add) >= other_team_score;
}

/*
	Name: ball_check_assist
	Namespace: ball
	Checksum: 0x428F0AFA
	Offset: 0x7820
	Size: 0x84
	Parameters: 2
	Flags: None
*/
function ball_check_assist(player, wasdunk)
{
	if(!isdefined(player.passtime) || !isdefined(player.passplayer))
	{
		return;
	}
	if((player.passtime + 3000) < gettime())
	{
		return;
	}
	scoreevents::processscoreevent("ball_capture_assist", player.passplayer);
}

/*
	Name: function_6746e980
	Namespace: ball
	Checksum: 0x81A5299A
	Offset: 0x78B0
	Size: 0x88
	Parameters: 2
	Flags: None
*/
function function_6746e980(projectile, timeout)
{
	projectile endon(#"stationary");
	ret = self util::waittill_any_timeout(timeout, "reset", "pickup_object", "score_event");
	if(ret != "timeout" && isdefined(projectile))
	{
		projectile notify(#"abort_ball_physics");
	}
}

/*
	Name: ball_physics_timeout
	Namespace: ball
	Checksum: 0x9A8517C7
	Offset: 0x7940
	Size: 0x124
	Parameters: 0
	Flags: None
*/
function ball_physics_timeout()
{
	self endon(#"reset");
	self endon(#"pickup_object");
	self endon(#"score_event");
	if(isdefined(self.autoresettime) && self.autoresettime > 15)
	{
		physicstime = self.autoresettime;
	}
	else
	{
		physicstime = 15;
	}
	if(isdefined(self.projectile))
	{
		self.projectile endon(#"abort_ball_physics");
		self thread function_6746e980(self.projectile, physicstime);
		timeoutreason = self.projectile util::waittill_any_timeout(physicstime, "stationary", "abort_ball_physics");
		if(!isdefined(timeoutreason))
		{
			return;
		}
		if(timeoutreason == "stationary")
		{
			if(isdefined(self.autoresettime))
			{
				wait(self.autoresettime);
			}
		}
	}
	self reset_ball();
}

/*
	Name: ball_physics_out_of_level
	Namespace: ball
	Checksum: 0xC5F7222F
	Offset: 0x7A70
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function ball_physics_out_of_level()
{
	self endon(#"reset");
	self endon(#"pickup_object");
	ball = self.visuals[0];
	self waittill(#"entity_oob");
	self reset_ball();
}

/*
	Name: player_update_pass_target
	Namespace: ball
	Checksum: 0x4306D814
	Offset: 0x7AD0
	Size: 0x3A8
	Parameters: 1
	Flags: None
*/
function player_update_pass_target(ballobj)
{
	self notify(#"update_pass_target");
	self endon(#"update_pass_target");
	self endon(#"disconnect");
	self endon(#"cancel_update_pass_target");
	test_dot = 0.8;
	while(true)
	{
		new_target = undefined;
		if(!self isonladder())
		{
			playerdir = anglestoforward(self getplayerangles());
			playereye = self geteye();
			possible_pass_targets = [];
			foreach(target in level.players)
			{
				if(self == target)
				{
					continue;
				}
				if(target.team != self.team)
				{
					continue;
				}
				if(!isalive(target))
				{
					continue;
				}
				if(!ballobj can_use_ball(target))
				{
					continue;
				}
				targeteye = target geteye();
				distsq = distancesquared(targeteye, playereye);
				if(distsq > 1000000)
				{
					continue;
				}
				dirtotarget = vectornormalize(targeteye - playereye);
				dot = vectordot(playerdir, dirtotarget);
				if(dot > test_dot)
				{
					target.pass_dot = dot;
					target.pass_origin = targeteye;
					possible_pass_targets[possible_pass_targets.size] = target;
				}
			}
			possible_pass_targets = array::quicksort(possible_pass_targets, &compare_player_pass_dot);
			foreach(target in possible_pass_targets)
			{
				if(sighttracepassed(playereye, target.pass_origin, 0, target))
				{
					new_target = target;
					break;
				}
			}
		}
		self player_set_pass_target(new_target);
		wait(0.05);
	}
}

/*
	Name: play_return_vo
	Namespace: ball
	Checksum: 0x99B405F9
	Offset: 0x7E80
	Size: 0xBA
	Parameters: 0
	Flags: None
*/
function play_return_vo()
{
	foreach(team in level.teams)
	{
		globallogic_audio::play_2d_on_team("mpl_ballreturn_sting", team);
		globallogic_audio::leader_dialog("uplReset", team, undefined, "uplink_ball");
	}
}

/*
	Name: compare_player_pass_dot
	Namespace: ball
	Checksum: 0x2B0ECF81
	Offset: 0x7F48
	Size: 0x30
	Parameters: 2
	Flags: None
*/
function compare_player_pass_dot(left, right)
{
	return left.pass_dot >= right.pass_dot;
}

/*
	Name: player_set_pass_target
	Namespace: ball
	Checksum: 0xC5BD22EC
	Offset: 0x7F80
	Size: 0x19C
	Parameters: 1
	Flags: None
*/
function player_set_pass_target(new_target)
{
	if(isdefined(self.pass_target) && isdefined(new_target) && self.pass_target == new_target)
	{
		return;
	}
	if(!isdefined(self.pass_target) && !isdefined(new_target))
	{
		return;
	}
	self player_clear_pass_target();
	if(isdefined(new_target))
	{
		offset = vectorscale((0, 0, 1), 80);
		new_target clientfield::set("passoption", 1);
		self.pass_target = new_target;
		team_players = [];
		foreach(player in level.players)
		{
			if(player.team == self.team && player != self && player != new_target)
			{
				team_players[team_players.size] = player;
			}
		}
		self setballpassallowed(1);
	}
}

/*
	Name: player_clear_pass_target
	Namespace: ball
	Checksum: 0x90C69813
	Offset: 0x8128
	Size: 0x134
	Parameters: 0
	Flags: None
*/
function player_clear_pass_target()
{
	if(isdefined(self.pass_icon))
	{
		self.pass_icon destroy();
	}
	team_players = [];
	foreach(player in level.players)
	{
		if(player.team == self.team && player != self)
		{
			team_players[team_players.size] = player;
		}
	}
	if(isdefined(self.pass_target))
	{
		self.pass_target clientfield::set("passoption", 0);
	}
	self.pass_target = undefined;
	self setballpassallowed(0);
}

/*
	Name: ball_create_start
	Namespace: ball
	Checksum: 0xC5DC5EDB
	Offset: 0x8268
	Size: 0x22E
	Parameters: 1
	Flags: None
*/
function ball_create_start(minstartingballs)
{
	ball_starts = getentarray("ball_start", "targetname");
	ball_starts = array::randomize(ball_starts);
	foreach(new_start in ball_starts)
	{
		balladdstart(new_start.origin);
	}
	default_ball_height = 30;
	if(ball_starts.size == 0)
	{
		origin = level.default_ball_origin;
		if(!isdefined(origin))
		{
			origin = (0, 0, 0);
		}
		balladdstart(origin);
	}
	add_num = minstartingballs - level.ball_starts.size;
	if(add_num <= 0)
	{
		return;
	}
	default_start = level.ball_starts[0].origin;
	near_nodes = getnodesinradius(default_start, 200, 20, 50);
	near_nodes = array::randomize(near_nodes);
	for(i = 0; i < add_num && i < near_nodes.size; i++)
	{
		balladdstart(near_nodes[i].origin);
	}
}

/*
	Name: balladdstart
	Namespace: ball
	Checksum: 0xE82EFC29
	Offset: 0x84A0
	Size: 0xBA
	Parameters: 1
	Flags: None
*/
function balladdstart(origin)
{
	ball_spawn_height = 30;
	new_start = spawnstruct();
	new_start.origin = origin;
	new_start ballfindground();
	new_start.origin = new_start.ground_origin + (0, 0, ball_spawn_height);
	new_start.in_use = 0;
	level.ball_starts[level.ball_starts.size] = new_start;
}

/*
	Name: ballfindground
	Namespace: ball
	Checksum: 0x5637D785
	Offset: 0x8568
	Size: 0xBA
	Parameters: 1
	Flags: None
*/
function ballfindground(z_offset)
{
	tracestart = self.origin + vectorscale((0, 0, 1), 32);
	traceend = self.origin + (vectorscale((0, 0, -1), 1000));
	trace = bullettrace(tracestart, traceend, 0, undefined);
	self.ground_origin = trace["position"];
	return trace["fraction"] != 0 && trace["fraction"] != 1;
}

/*
	Name: play_goal_score_fx
	Namespace: ball
	Checksum: 0x5747626B
	Offset: 0x8630
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function play_goal_score_fx()
{
	key = "ball_score_" + self.team;
	level clientfield::set(key, !level clientfield::get(key));
}

/*
	Name: is_touching_any_ball_return_trigger
	Namespace: ball
	Checksum: 0x4543A745
	Offset: 0x8690
	Size: 0x1E6
	Parameters: 0
	Flags: None
*/
function is_touching_any_ball_return_trigger()
{
	if(!isdefined(level.ball_return_trigger))
	{
		return 0;
	}
	triggers_to_remove = [];
	result = 0;
	foreach(trigger in level.ball_return_trigger)
	{
		if(!isdefined(trigger))
		{
			if(!isdefined(triggers_to_remove))
			{
				triggers_to_remove = [];
			}
			else if(!isarray(triggers_to_remove))
			{
				triggers_to_remove = array(triggers_to_remove);
			}
			triggers_to_remove[triggers_to_remove.size] = trigger;
			continue;
		}
		if(!trigger istriggerenabled())
		{
			continue;
		}
		if(self istouching(trigger))
		{
			result = 1;
			break;
		}
	}
	foreach(trigger in triggers_to_remove)
	{
		arrayremovevalue(level.ball_return_trigger, trigger);
	}
	triggers_to_remove = [];
	triggers_to_remove = undefined;
	return result;
}

