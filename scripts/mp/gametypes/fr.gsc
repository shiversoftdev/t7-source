// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_pickup_items;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace fr;

/*
	Name: main
	Namespace: fr
	Checksum: 0xC216BCBE
	Offset: 0xA58
	Size: 0x6B4
	Parameters: 0
	Flags: None
*/
function main()
{
	level.trackweaponstats = 0;
	globallogic::init();
	clientfield::register("world", "freerun_state", 1, 3, "int");
	clientfield::register("world", "freerun_retries", 1, 16, "int");
	clientfield::register("world", "freerun_faults", 1, 16, "int");
	clientfield::register("world", "freerun_startTime", 1, 31, "int");
	clientfield::register("world", "freerun_finishTime", 1, 31, "int");
	clientfield::register("world", "freerun_bestTime", 1, 31, "int");
	clientfield::register("world", "freerun_timeAdjustment", 1, 31, "int");
	clientfield::register("world", "freerun_timeAdjustmentNegative", 1, 1, "int");
	clientfield::register("world", "freerun_bulletPenalty", 1, 16, "int");
	clientfield::register("world", "freerun_pausedTime", 1, 31, "int");
	clientfield::register("world", "freerun_checkpointIndex", 1, 7, "int");
	util::registertimelimit(0, 1440);
	util::registerscorelimit(0, 50000);
	util::registerroundlimit(0, 10);
	util::registerroundwinlimit(0, 10);
	util::registernumlives(0, 100);
	globallogic::registerfriendlyfiredelay(level.gametype, 0, 0, 1440);
	level.scoreroundwinbased = getgametypesetting("cumulativeRoundScores") == 0;
	level.teamscoreperkill = getgametypesetting("teamScorePerKill");
	level.teamscoreperdeath = getgametypesetting("teamScorePerDeath");
	level.teamscoreperheadshot = getgametypesetting("teamScorePerHeadshot");
	level.onstartgametype = &onstartgametype;
	level.onspawnplayer = &onspawnplayer;
	level.givecustomloadout = &givecustomloadout;
	level.postroundtime = 0.5;
	level.doendgamescoreboard = 0;
	callback::on_connect(&on_player_connect);
	gameobjects::register_allowed_gameobject("dm");
	gameobjects::register_allowed_gameobject(level.gametype);
	if(!isdefined(level.fr_target_impact_fx))
	{
		level.fr_target_impact_fx = "ui/fx_fr_target_impact";
	}
	if(!isdefined(level.fr_target_disable_fx))
	{
		level.fr_target_disable_fx = "ui/fx_fr_target_demat";
	}
	if(!isdefined(level.fr_target_disable_sound))
	{
		level.fr_target_disable_sound = "wpn_grenade_explode_default";
	}
	level.frgame = spawnstruct();
	level.frgame.activetrackindex = 0;
	level.frgame.tracks = [];
	for(i = 0; i < 1; i++)
	{
		level.frgame.tracks[i] = spawnstruct();
		level.frgame.tracks[i].starttrigger = getent("fr_start_0" + i, "targetname");
		/#
			assert(isdefined(level.frgame.tracks[i].starttrigger));
		#/
		level.frgame.tracks[i].goaltrigger = getent("fr_end_0" + i, "targetname");
		/#
			assert(isdefined(level.frgame.tracks[i].goaltrigger));
		#/
		level.frgame.tracks[i].highscores = [];
	}
	level.frgame.checkpointtriggers = getentarray("fr_checkpoint", "targetname");
	/#
		assert(level.frgame.checkpointtriggers.size);
	#/
	globallogic::setvisiblescoreboardcolumns("pointstowin", "kills", "deaths", "headshots", "score");
}

/*
	Name: setupteam
	Namespace: fr
	Checksum: 0x8FFB8AC1
	Offset: 0x1118
	Size: 0xB4
	Parameters: 1
	Flags: None
*/
function setupteam(team)
{
	util::setobjectivetext(team, &"OBJECTIVES_FR");
	if(level.splitscreen)
	{
		util::setobjectivescoretext(team, &"OBJECTIVES_FR");
	}
	else
	{
		util::setobjectivescoretext(team, &"OBJECTIVES_FR_SCORE");
	}
	util::setobjectivehinttext(team, &"OBJECTIVES_FR_SCORE");
	spawnlogic::add_spawn_points(team, "mp_dm_spawn");
}

/*
	Name: onstartgametype
	Namespace: fr
	Checksum: 0xC817BB6F
	Offset: 0x11D8
	Size: 0x8E4
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
	setclientnamemode("auto_change");
	level.usexcamsforendgame = 0;
	level.can_set_aar_stat = 0;
	level.disablebehaviortracker = 1;
	level.disablestattracking = 1;
	spawning::create_map_placed_influencers();
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	foreach(team in level.teams)
	{
		setupteam(team);
	}
	spawns = spawnlogic::get_spawnpoint_array("mp_dm_spawn");
	spawning::updateallspawnpoints();
	foreach(index, trigger in level.frgame.checkpointtriggers)
	{
		level.frgame.checkpointtimes[index] = 0;
		trigger.checkpointindex = index;
		trigger thread watchcheckpointtrigger();
		closest = 99999999;
		foreach(spawn in spawns)
		{
			dist = distancesquared(spawn.origin, trigger.origin);
			if(dist < closest)
			{
				closest = dist;
				trigger.spawnpoint = spawn;
			}
		}
		/#
			assert(isdefined(trigger.spawnpoint));
		#/
	}
	player_starts = spawnlogic::_get_spawnpoint_array("info_player_start");
	/#
		assert(player_starts.size);
	#/
	foreach(track in level.frgame.tracks)
	{
		closest = 99999999;
		foreach(start in player_starts)
		{
			dist = distancesquared(start.origin, track.starttrigger.origin);
			if(dist < closest)
			{
				closest = dist;
				track.playerstart = start;
			}
		}
		/#
			assert(isdefined(track.playerstart));
		#/
	}
	level.frgame.deathtriggers = getentarray("fr_die", "targetname");
	/#
		assert(level.frgame.deathtriggers.size);
	#/
	foreach(trigger in level.frgame.deathtriggers)
	{
		trigger thread watchdeathtrigger();
	}
	setup_tutorial();
	if(!isdefined(level.freerun))
	{
		level.freerun = 1;
	}
	level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
	setmapcenter(level.mapcenter);
	spawnpoint = spawnlogic::get_random_intermission_point();
	setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
	level.usestartspawns = 0;
	level.displayroundendtext = 0;
	if(!util::isoneround())
	{
		level.displayroundendtext = 1;
	}
	foreach(item in level.pickup_items)
	{
		closest = 99999999;
		foreach(trigger in level.frgame.checkpointtriggers)
		{
			dist = distancesquared(item.origin, trigger.origin);
			if(dist < closest)
			{
				closest = dist;
				item.checkpoint = trigger;
			}
		}
		/#
			assert(isdefined(item.checkpoint));
		#/
		item.checkpoint.weapon = item.visuals[0].items[0].weapon;
		item.checkpoint.weaponobject = item;
		item.checkpoint setup_weapon_targets();
	}
	thread watch_for_game_end();
	level.frgame.trackindex = getfreeruntrackindex();
	level.frgame.mapuniqueid = getmissionuniqueid();
	level.frgame.mapversion = getmissionversion();
}

/*
	Name: watch_for_game_end
	Namespace: fr
	Checksum: 0xA8E227E7
	Offset: 0x1AC8
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function watch_for_game_end()
{
	level waittill(#"game_ended");
	if(!end_game_state())
	{
		level clientfield::set("freerun_finishTime", 0);
	}
	self stop_tutorial_vo();
	level clientfield::set("freerun_state", 4);
}

/*
	Name: on_player_connect
	Namespace: fr
	Checksum: 0xDFFDC193
	Offset: 0x1B50
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self thread on_menu_response();
}

/*
	Name: on_menu_response
	Namespace: fr
	Checksum: 0xEE616712
	Offset: 0x1B78
	Size: 0xA0
	Parameters: 0
	Flags: None
*/
function on_menu_response()
{
	self endon(#"disconnect");
	for(;;)
	{
		self waittill(#"menuresponse", menu, response);
		if(response == "fr_restart")
		{
			self playsoundtoplayer("uin_freerun_reset", self);
			self thread freerunmusic();
			activatetrack(level.frgame.activetrackindex);
		}
	}
}

/*
	Name: onspawnplayer
	Namespace: fr
	Checksum: 0xF0646073
	Offset: 0x1C20
	Size: 0x13C
	Parameters: 1
	Flags: None
*/
function onspawnplayer(predictedspawn)
{
	spawning::onspawnplayer(predictedspawn);
	if(predictedspawn)
	{
		return;
	}
	if(isdefined(self.frinited))
	{
		self.body hide();
		faultdeath();
		return;
	}
	self.frinited = 1;
	self thread activate_tutorial_mode();
	self thread activatetrack(level.frgame.activetrackindex);
	self thread watchtrackswitch();
	self thread watchweaponfire();
	self thread freerunmusic();
	self thread trackplayerorigin();
	level.frgame.lastplayedfaultvotime = 0;
	self disableweaponcycling();
}

/*
	Name: on_player_damage
	Namespace: fr
	Checksum: 0xF9062BB5
	Offset: 0x1D68
	Size: 0x9C
	Parameters: 11
	Flags: None
*/
function on_player_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, modelindex, psoffsettime)
{
	if(idamage >= self.health)
	{
		self.health = self.maxhealth + 1;
		faultdeath();
		return 0;
	}
	return idamage;
}

/*
	Name: trackplayerorigin
	Namespace: fr
	Checksum: 0x14441C47
	Offset: 0x1E10
	Size: 0x42
	Parameters: 0
	Flags: None
*/
function trackplayerorigin()
{
	self endon(#"disconnect");
	while(true)
	{
		self.prev_origin = self.origin;
		self.prev_time = gettime();
		wait(0.05);
		waittillframeend();
	}
}

/*
	Name: readhighscores
	Namespace: fr
	Checksum: 0xA3831552
	Offset: 0x1E60
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function readhighscores()
{
	get_top_scores_stats();
	updatehighscores();
}

/*
	Name: updatehighscores
	Namespace: fr
	Checksum: 0xDFF01670
	Offset: 0x1E90
	Size: 0xCC
	Parameters: 0
	Flags: None
*/
function updatehighscores()
{
	self freerunsethighscores(level.frgame.activetrack.highscores[0].time, level.frgame.activetrack.highscores[1].time, level.frgame.activetrack.highscores[2].time);
	level clientfield::set("freerun_bestTime", level.frgame.activetrack.highscores[0].time);
}

/*
	Name: activatetrack
	Namespace: fr
	Checksum: 0xD48063
	Offset: 0x1F68
	Size: 0x4C4
	Parameters: 1
	Flags: None
*/
function activatetrack(trackindex)
{
	level notify(#"activate_track");
	/#
		if(level.frgame.tracks.size > 1)
		{
			iprintln("" + trackindex);
		}
	#/
	if(!isdefined(level.frgame.tutorials) || !level.frgame.tutorials)
	{
		self playlocalsound("vox_tuto_tutorial_sequence_27");
	}
	level.frgame.lastplayedfaultvocheckpoint = -1;
	level.frgame.activetrackindex = trackindex;
	level.frgame.activetrack = level.frgame.tracks[trackindex];
	level.frgame.activespawnpoint = level.frgame.activetrack.playerstart;
	level.frgame.activespawnlocation = level.frgame.activetrack.playerstart.origin;
	level.frgame.activespawnangles = level.frgame.activetrack.playerstart.angles;
	level.frgame.activetrack.goaltrigger thread watchgoaltrigger();
	level.frgame.activespawnpoint.checkpointindex = 0;
	level.frgame.faults = 0;
	level.frgame.userspawns = 0;
	level.frgame.checkpointtimes = [];
	foreach(index, trigger in level.frgame.checkpointtriggers)
	{
		level.frgame.checkpointtimes[index] = 0;
	}
	level clientfield::set("freerun_faults", 0);
	level clientfield::set("freerun_retries", 0);
	level clientfield::set("freerun_state", 0);
	level clientfield::set("freerun_bulletPenalty", 0);
	level clientfield::set("freerun_pausedTime", 0);
	level clientfield::set("freerun_checkpointIndex", 0);
	self readhighscores();
	self givecustomloadout();
	self setorigin(level.frgame.activetrack.playerstart.origin);
	self setplayerangles(level.frgame.activetrack.playerstart.angles);
	self setvelocity((0, 0, 0));
	self recordgameevent("start");
	resetglass();
	reset_all_targets();
	pickup_items::respawn_all_pickups();
	self unfreeze();
	self.respawn_position = undefined;
	enable_all_tutorial_triggers();
	take_players_out_of_tutorial_mode();
	level.frgame.activetrack.starttrigger thread watchstartrun(self);
}

/*
	Name: startrun
	Namespace: fr
	Checksum: 0x6922E96
	Offset: 0x2438
	Size: 0x114
	Parameters: 0
	Flags: None
*/
function startrun()
{
	level.frgame.totalpausedtime = 0;
	level.frgame.pausedattime = 0;
	level.frgame.bulletpenalty = 0;
	level.frgame.hasbeenpaused = 0;
	level.frgame.trackstarttime = 0;
	level.frgame.trackstarttime = get_current_track_time(self);
	level clientfield::set("freerun_startTime", level.frgame.trackstarttime);
	level clientfield::set("freerun_state", 1);
	self playsoundtoplayer("uin_freerun_start", self);
	self thread watchuserrespawn();
}

/*
	Name: oncheckpointtrigger
	Namespace: fr
	Checksum: 0x214B0005
	Offset: 0x2558
	Size: 0xEC
	Parameters: 2
	Flags: None
*/
function oncheckpointtrigger(player, endonstring)
{
	self endon(endonstring);
	level.frgame.activespawnlocation = getgroundpointfororigin(player.origin);
	level.frgame.activespawnangles = player.angles;
	if(level.frgame.activespawnpoint != self)
	{
		level.frgame.activespawnpoint = self;
		player take_all_player_weapons(0, 0);
		if(isdefined(self.weaponobject))
		{
			self.weaponobject reset_targets();
			self.weaponobject pickup_items::respawn_pickup();
		}
	}
}

/*
	Name: leavecheckpointtrigger
	Namespace: fr
	Checksum: 0x1C59A07A
	Offset: 0x2650
	Size: 0x24
	Parameters: 1
	Flags: None
*/
function leavecheckpointtrigger(player)
{
	self thread watchcheckpointtrigger();
}

/*
	Name: get_current_track_time
	Namespace: fr
	Checksum: 0xDE565B8A
	Offset: 0x2680
	Size: 0x10A
	Parameters: 1
	Flags: None
*/
function get_current_track_time(player)
{
	curtime = gettime();
	dt = curtime - player.prev_time;
	frac = getfirsttouchfraction(player, self, player.prev_origin, player.origin);
	current_time = (curtime - level.frgame.trackstarttime) + (level.frgame.bulletpenalty * 1000) + (level.frgame.userspawns * 5000) - level.frgame.totalpausedtime;
	return int(current_time - (dt * (1 - frac)));
}

/*
	Name: watchcheckpointtrigger
	Namespace: fr
	Checksum: 0xECEE3E93
	Offset: 0x2798
	Size: 0x284
	Parameters: 0
	Flags: None
*/
function watchcheckpointtrigger()
{
	self waittill(#"trigger", player);
	if(isplayer(player))
	{
		if(level.frgame.activespawnpoint != self)
		{
			checkpoint_index = self.checkpointindex;
			current_time = get_current_track_time(player);
			first_time = 0;
			if(!isdefined(level.frgame.checkpointtimes[checkpoint_index]) || level.frgame.checkpointtimes[checkpoint_index] == 0)
			{
				level.frgame.checkpointtimes[checkpoint_index] = current_time;
				first_time = 1;
			}
			if(first_time)
			{
				if(isdefined(level.frgame.activetrack.fastestruncheckpointtimes))
				{
					if(isdefined(level.frgame.activetrack.fastestruncheckpointtimes[checkpoint_index]) && level.frgame.activetrack.fastestruncheckpointtimes[checkpoint_index])
					{
						delta_time = current_time - level.frgame.activetrack.fastestruncheckpointtimes[checkpoint_index];
						if(delta_time < 0)
						{
							delta_time = delta_time * -1;
							sign = 1;
						}
						else
						{
							sign = 0;
						}
						level clientfield::set("freerun_timeAdjustment", delta_time);
						level clientfield::set("freerun_timeAdjustmentNegative", sign);
					}
				}
				level clientfield::set("freerun_checkpointIndex", checkpoint_index + 1);
				player playsoundtoplayer("uin_freerun_checkpoint", player);
			}
		}
		self thread util::trigger_thread(player, &oncheckpointtrigger, &leavecheckpointtrigger);
	}
}

/*
	Name: watchdeathtrigger
	Namespace: fr
	Checksum: 0x62BC6FFA
	Offset: 0x2A28
	Size: 0x58
	Parameters: 0
	Flags: None
*/
function watchdeathtrigger()
{
	while(true)
	{
		self waittill(#"trigger", player);
		if(isplayer(player))
		{
			player faultdeath();
		}
	}
}

/*
	Name: add_current_run_to_high_scores
	Namespace: fr
	Checksum: 0x9F0AE12A
	Offset: 0x2A88
	Size: 0x258
	Parameters: 1
	Flags: None
*/
function add_current_run_to_high_scores(player)
{
	active_track = level.frgame.activetrack;
	run_data = create_high_score_struct(get_current_track_time(player), level.frgame.faults, level.frgame.userspawns, level.frgame.bulletpenalty);
	push_score = 1;
	new_record = 0;
	if(active_track.highscores.size > 0)
	{
		for(i = 0; i < active_track.highscores.size; i++)
		{
			if(run_data.time < active_track.highscores[i].time || active_track.highscores[i].time == 0)
			{
				push_score = 0;
				arrayinsert(active_track.highscores, run_data, i);
				if(i == 0)
				{
					new_record = 1;
				}
				if(i < 3)
				{
					player write_high_scores_stats(i);
				}
				break;
			}
		}
	}
	else
	{
		new_record = 1;
	}
	if(push_score)
	{
		arrayinsert(active_track.highscores, run_data, active_track.highscores.size);
		player write_high_scores_stats(active_track.highscores.size - 1);
	}
	if(new_record)
	{
		player write_checkpoint_times();
	}
	return new_record;
}

/*
	Name: watchgoaltrigger
	Namespace: fr
	Checksum: 0x3F91BF70
	Offset: 0x2CE8
	Size: 0x32C
	Parameters: 0
	Flags: None
*/
function watchgoaltrigger()
{
	level notify(#"watch_goal_trigger");
	level endon(#"watch_goal_trigger");
	self waittill(#"trigger", player);
	if(isplayer(player))
	{
		player playsoundtoplayer("uin_freerun_finish", player);
		player take_all_player_weapons(1, 0);
		new_record = add_current_run_to_high_scores(player);
		trackscompleted = player getdstat("freerunTracksCompleted");
		if(trackscompleted < level.frgame.trackindex)
		{
			player setdstat("freerunTracksCompleted", level.frgame.trackindex);
		}
		player recordgameevent("completion");
		player.respawn_position = self.origin;
		player thread freeze();
		player thread freerunmusic(0);
		player updatehighscores();
		level clientfield::set("freerun_finishTime", get_current_track_time(player));
		level clientfield::set("freerun_state", 2);
		level notify(#"finished_track");
		if(player ishost())
		{
			level notify(#"stop_tutorials");
			take_players_out_of_tutorial_mode();
			level.frgame.tutorials = 0;
			setlocalprofilevar("com_firsttime_freerun", 1);
			highest_track = getlocalprofileint("freerunHighestTrack");
			if(highest_track < level.frgame.trackindex)
			{
				setlocalprofilevar("freerunHighestTrack", level.frgame.trackindex);
			}
		}
		/#
			dumphighscores();
		#/
		wait(1.5);
		uploadstats();
		player uploadleaderboards();
		level clientfield::set("freerun_state", 5);
	}
}

/*
	Name: freeze
	Namespace: fr
	Checksum: 0xEE209073
	Offset: 0x3020
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function freeze()
{
	self util::freeze_player_controls(1);
}

/*
	Name: unfreeze
	Namespace: fr
	Checksum: 0xC837FE1B
	Offset: 0x3048
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function unfreeze()
{
	self util::freeze_player_controls(0);
}

/*
	Name: setup_weapon_targets
	Namespace: fr
	Checksum: 0xF2538684
	Offset: 0x3070
	Size: 0x41A
	Parameters: 0
	Flags: None
*/
function setup_weapon_targets()
{
	target_name = self.weaponobject.visuals[0].target;
	if(!isdefined(target_name))
	{
		return;
	}
	self.weaponobject.targetshottime = 0;
	self.weaponobject.targets = [];
	self.weaponobject.target_visuals = [];
	targets = getentarray(target_name, "targetname");
	foreach(target in targets)
	{
		if(target.script_noteworthy == "fr_target")
		{
			self.weaponobject.targets[self.weaponobject.targets.size] = target;
		}
		if(target.script_noteworthy == "fr_target_visual")
		{
			self.weaponobject.target_visuals[self.weaponobject.target_visuals.size] = target;
		}
	}
	foreach(target in self.weaponobject.targets)
	{
		foreach(visual in self.weaponobject.target_visuals)
		{
			if(target.origin == visual.origin)
			{
				target.visual = visual;
			}
		}
	}
	foreach(target in self.weaponobject.targets)
	{
		target.blocker = getent(target.target, "targetname");
		if(isdefined(target.blocker))
		{
			if(!isdefined(target.blocker.targetcount))
			{
				target.blocker.targetcount = 0;
				target.blocker.activetargetcount = 0;
			}
			target.blocker.targetcount++;
			target.blocker.activetargetcount++;
			target.checkpoint = self;
			target.disabled = 0;
			target thread watch_target_trigger_thread(self.weaponobject);
		}
	}
}

/*
	Name: watch_target_trigger_thread
	Namespace: fr
	Checksum: 0xD0E83923
	Offset: 0x3498
	Size: 0x130
	Parameters: 1
	Flags: None
*/
function watch_target_trigger_thread(weaponobject)
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage", damage, attacker, direction_vec, point, type, modelname, tagname, partname, weapon, idflags);
		if(level.frgame.activespawnpoint != self.checkpoint)
		{
			continue;
		}
		if(weapon == level.weaponbasemeleeheld)
		{
			continue;
		}
		if(self.disabled)
		{
			continue;
		}
		self turn_off_target(weapon);
		playfx(level.fr_target_impact_fx, point, direction_vec);
		weaponobject.targetshottime = gettime();
	}
}

/*
	Name: turn_off_target
	Namespace: fr
	Checksum: 0x2E3C4E0B
	Offset: 0x35D0
	Size: 0xA4
	Parameters: 1
	Flags: None
*/
function turn_off_target(weapon)
{
	self.disabled = 1;
	self.visual ghost();
	self.visual notsolid();
	self.blocker blocker_disable();
	playfx(level.fr_target_disable_fx, self.origin);
	playsoundatposition(level.fr_target_disable_sound, self.origin);
}

/*
	Name: blocker_enable
	Namespace: fr
	Checksum: 0xF4C0F48D
	Offset: 0x3680
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function blocker_enable()
{
	self.activetargetcount = self.targetcount;
	self.disabled = 0;
	self show();
	self solid();
}

/*
	Name: blocker_disable
	Namespace: fr
	Checksum: 0xAB6E8611
	Offset: 0x36D8
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function blocker_disable()
{
	self.activetargetcount--;
	if(self.activetargetcount == 0)
	{
		self.disabled = 1;
		self ghost();
		self notsolid();
	}
}

/*
	Name: reset_targets
	Namespace: fr
	Checksum: 0x8022BB2D
	Offset: 0x3738
	Size: 0xE2
	Parameters: 0
	Flags: None
*/
function reset_targets()
{
	foreach(target in self.targets)
	{
		target.blocker blocker_enable();
		target.visual show();
		target.visual solid();
		target.disabled = 0;
	}
}

/*
	Name: reset_all_targets
	Namespace: fr
	Checksum: 0xC8BC2FDC
	Offset: 0x3828
	Size: 0xAA
	Parameters: 0
	Flags: None
*/
function reset_all_targets()
{
	foreach(trigger in level.frgame.checkpointtriggers)
	{
		if(isdefined(trigger.weaponobject))
		{
			trigger.weaponobject reset_targets();
		}
	}
}

/*
	Name: dumphighscores
	Namespace: fr
	Checksum: 0x89A9A1CB
	Offset: 0x38E0
	Size: 0x120
	Parameters: 0
	Flags: None
*/
function dumphighscores()
{
	/#
		for(i = 0; i < level.frgame.activetrack.highscores.size; i++)
		{
			println(((i + 1) + "") + level.frgame.activetrack.highscores[i].time);
			if(i == 0)
			{
				for(j = 0; j < level.frgame.activetrack.fastestruncheckpointtimes.size; j++)
				{
					println((("" + j) + "") + level.frgame.activetrack.fastestruncheckpointtimes[j]);
				}
			}
		}
	#/
}

/*
	Name: play_fault_vo
	Namespace: fr
	Checksum: 0xCDD71091
	Offset: 0x3A08
	Size: 0xE4
	Parameters: 0
	Flags: None
*/
function play_fault_vo()
{
	current_time = gettime();
	fault_vo_interval = 20000;
	if((current_time - level.frgame.lastplayedfaultvotime) < fault_vo_interval)
	{
		return;
	}
	if(isdefined(self.lasttutorialvoplayed))
	{
		return;
	}
	if(level.frgame.lastplayedfaultvocheckpoint == level.frgame.activespawnpoint.checkpointindex)
	{
		return;
	}
	level.frgame.lastplayedfaultvocheckpoint = level.frgame.activespawnpoint.checkpointindex;
	level.frgame.lastplayedfaultvotime = current_time;
	self playlocalsound("vox_tuto_tutorial_fail");
}

/*
	Name: faultdeath
	Namespace: fr
	Checksum: 0xD46742E6
	Offset: 0x3AF8
	Size: 0xB4
	Parameters: 0
	Flags: None
*/
function faultdeath()
{
	self play_fault_vo();
	level.frgame.faults++;
	self recordgameevent("fault");
	level clientfield::set("freerun_faults", level.frgame.faults);
	self playsoundtoplayer("uin_freerun_reset", self);
	self respawnatactivecheckpoint();
}

/*
	Name: dpad_up_pressed
	Namespace: fr
	Checksum: 0xFEE01DB
	Offset: 0x3BB8
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function dpad_up_pressed()
{
	return self actionslotonebuttonpressed();
}

/*
	Name: dpad_down_pressed
	Namespace: fr
	Checksum: 0xDBFE34BC
	Offset: 0x3BE0
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function dpad_down_pressed()
{
	return self actionslottwobuttonpressed();
}

/*
	Name: dpad_right_pressed
	Namespace: fr
	Checksum: 0xCCA71874
	Offset: 0x3C08
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function dpad_right_pressed()
{
	return self actionslotfourbuttonpressed();
}

/*
	Name: dpad_left_pressed
	Namespace: fr
	Checksum: 0xA8DA6C19
	Offset: 0x3C30
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function dpad_left_pressed()
{
	return self actionslotthreebuttonpressed();
}

/*
	Name: end_game_state
	Namespace: fr
	Checksum: 0xF86A5E94
	Offset: 0x3C58
	Size: 0x62
	Parameters: 0
	Flags: None
*/
function end_game_state()
{
	state = level clientfield::get("freerun_state");
	if(state == 2 || state == 4 || state == 5)
	{
		return true;
	}
	return false;
}

/*
	Name: watchtrackswitch
	Namespace: fr
	Checksum: 0xB47F34F1
	Offset: 0x3CC8
	Size: 0x232
	Parameters: 0
	Flags: None
*/
function watchtrackswitch()
{
	track_count = level.frgame.tracks.size;
	while(true)
	{
		wait(0.05);
		switch_track = 0;
		if(end_game_state())
		{
			continue;
		}
		/#
			if(self dpad_right_pressed() && track_count > 1)
			{
				switch_track = 1;
				curr_track_index = level.frgame.activetrackindex;
				curr_track_index++;
			}
			else if(self dpad_left_pressed() && track_count > 1)
			{
				switch_track = 1;
				curr_track_index = level.frgame.activetrackindex;
				curr_track_index--;
			}
		#/
		if(!switch_track && self dpad_up_pressed())
		{
			switch_track = 1;
			curr_track_index = level.frgame.activetrackindex;
			self thread freerunmusic();
		}
		if(switch_track)
		{
			if(curr_track_index == 1)
			{
				curr_track_index = 0;
			}
			else if(curr_track_index < 0)
			{
				curr_track_index = 0;
			}
			self playsoundtoplayer("uin_freerun_reset", self);
			activatetrack(curr_track_index);
			while(true)
			{
				wait(0.05);
				if(!(self dpad_right_pressed() || self dpad_left_pressed() || self dpad_up_pressed()))
				{
					break;
				}
			}
		}
	}
}

/*
	Name: watchuserrespawn
	Namespace: fr
	Checksum: 0x853DDDF1
	Offset: 0x3F08
	Size: 0x19A
	Parameters: 0
	Flags: None
*/
function watchuserrespawn()
{
	level endon(#"activate_track");
	level endon(#"finished_track");
	/#
		wasinnoclip = 0;
	#/
	while(true)
	{
		wait(0.05);
		if(end_game_state())
		{
			continue;
		}
		/#
			if(self isinmovemode(""))
			{
				wasinnoclip = 1;
				continue;
			}
			if(wasinnoclip && self dpad_down_pressed())
			{
				continue;
			}
			wasinnoclip = 0;
		#/
		if(self dpad_down_pressed())
		{
			level.frgame.userspawns++;
			self recordgameevent("retry");
			level clientfield::set("freerun_retries", level.frgame.userspawns);
			self playsoundtoplayer("uin_freerun_reset", self);
			self respawnatactivecheckpoint();
			while(true)
			{
				wait(0.05);
				if(!self dpad_down_pressed())
				{
					break;
				}
			}
		}
	}
}

/*
	Name: ignorebulletsfired
	Namespace: fr
	Checksum: 0x6F2B9882
	Offset: 0x40B0
	Size: 0x140
	Parameters: 1
	Flags: None
*/
function ignorebulletsfired(weapon)
{
	if(!isdefined(level.frgame.activespawnpoint))
	{
		return false;
	}
	if(!isdefined(level.frgame.activespawnpoint.weaponobject))
	{
		return false;
	}
	grace_period = (weapon.firetime * 4) * 1000;
	if((level.frgame.activespawnpoint.weaponobject.targetshottime + grace_period) >= gettime())
	{
		return true;
	}
	foreach(target in level.frgame.activespawnpoint.weaponobject.targets)
	{
		if(!target.disabled)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: watchweaponfire
	Namespace: fr
	Checksum: 0x2A19272F
	Offset: 0x41F8
	Size: 0xA8
	Parameters: 0
	Flags: None
*/
function watchweaponfire()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"weapon_fired", weapon);
		if(weapon == level.weaponbasemeleeheld)
		{
			continue;
		}
		if(ignorebulletsfired(weapon))
		{
			continue;
		}
		level.frgame.bulletpenalty++;
		level clientfield::set("freerun_bulletPenalty", level.frgame.bulletpenalty);
	}
}

/*
	Name: getgroundpointfororigin
	Namespace: fr
	Checksum: 0x8674DB0D
	Offset: 0x42A8
	Size: 0x64
	Parameters: 1
	Flags: None
*/
function getgroundpointfororigin(position)
{
	trace = bullettrace(position + vectorscale((0, 0, 1), 10), position - vectorscale((0, 0, 1), 1000), 0, undefined);
	return trace["position"];
}

/*
	Name: watchstartrun
	Namespace: fr
	Checksum: 0xB7A10D1E
	Offset: 0x4318
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function watchstartrun(player)
{
	level endon(#"activate_track");
	self waittill(#"trigger", trigger_ent);
	if(trigger_ent == player)
	{
		player startrun();
	}
}

/*
	Name: respawnatactivecheckpoint
	Namespace: fr
	Checksum: 0x9652A0AD
	Offset: 0x4378
	Size: 0x21C
	Parameters: 0
	Flags: None
*/
function respawnatactivecheckpoint()
{
	resetglass();
	reset_all_targets();
	pickup_items::respawn_all_pickups();
	take_players_out_of_tutorial_mode();
	self playsoundtoplayer("evt_freerun_respawn", self);
	if(isdefined(self.respawn_position))
	{
		self setorigin(self.respawn_position);
		self setvelocity((0, 0, 0));
	}
	else
	{
		if(isdefined(level.frgame.activespawnpoint.spawnpoint))
		{
			self setorigin(level.frgame.activespawnpoint.spawnpoint.origin);
			self setplayerangles(level.frgame.activespawnpoint.spawnpoint.angles);
			self setvelocity((0, 0, 0));
		}
		else
		{
			spawn_origin = level.frgame.activespawnlocation;
			spawn_origin = spawn_origin + vectorscale((0, 0, 1), 5);
			self setorigin(spawn_origin);
			self setplayerangles(level.frgame.activespawnangles);
			self setvelocity((0, 0, 0));
		}
	}
	self setdoublejumpenergy(1);
	self take_all_player_weapons(1, 1);
}

/*
	Name: givecustomloadout
	Namespace: fr
	Checksum: 0xECAF7197
	Offset: 0x45A0
	Size: 0x9A
	Parameters: 0
	Flags: None
*/
function givecustomloadout()
{
	self takeallweapons();
	self clearperks();
	self setperk("specialty_fallheight");
	self giveweapon(level.weaponbasemeleeheld);
	self setspawnweapon(level.weaponbasemeleeheld);
	return level.weaponbasemeleeheld;
}

/*
	Name: set_high_score_stat
	Namespace: fr
	Checksum: 0xB6DDD27D
	Offset: 0x4648
	Size: 0x64
	Parameters: 4
	Flags: None
*/
function set_high_score_stat(trackindex, slot, stat, value)
{
	self setdstat("freerunTrackTimes", "track", trackindex, "topTimes", slot, stat, value);
}

/*
	Name: write_high_scores_stats
	Namespace: fr
	Checksum: 0xDA1866A6
	Offset: 0x46B8
	Size: 0x20E
	Parameters: 1
	Flags: None
*/
function write_high_scores_stats(start_index)
{
	active_track = level.frgame.activetrack;
	self setdstat("freerunTrackTimes", "track", level.frgame.trackindex, "mapUniqueId", level.frgame.mapuniqueid);
	self setdstat("freerunTrackTimes", "track", level.frgame.trackindex, "mapVersion", level.frgame.mapversion);
	for(slot = start_index; slot < 3; slot++)
	{
		set_high_score_stat(level.frgame.trackindex, slot, "time", active_track.highscores[slot].time);
		set_high_score_stat(level.frgame.trackindex, slot, "faults", active_track.highscores[slot].faults);
		set_high_score_stat(level.frgame.trackindex, slot, "retries", active_track.highscores[slot].retries);
		set_high_score_stat(level.frgame.trackindex, slot, "bulletPenalty", active_track.highscores[slot].bulletpenalty);
	}
}

/*
	Name: write_checkpoint_times
	Namespace: fr
	Checksum: 0xE6CA5445
	Offset: 0x48D0
	Size: 0xBE
	Parameters: 0
	Flags: None
*/
function write_checkpoint_times()
{
	level.frgame.activetrack.fastestruncheckpointtimes = level.frgame.checkpointtimes;
	for(i = 0; i < level.frgame.checkpointtriggers.size; i++)
	{
		self setdstat("freerunTrackTimes", "track", level.frgame.trackindex, "checkPointTimes", "time", i, level.frgame.checkpointtimes[i]);
	}
}

/*
	Name: get_high_score_stat
	Namespace: fr
	Checksum: 0xC6B5872B
	Offset: 0x4998
	Size: 0x52
	Parameters: 3
	Flags: None
*/
function get_high_score_stat(trackindex, slot, stat)
{
	return self getdstat("freerunTrackTimes", "track", trackindex, "topTimes", slot, stat);
}

/*
	Name: create_high_score_struct
	Namespace: fr
	Checksum: 0x6D77342
	Offset: 0x49F8
	Size: 0x94
	Parameters: 4
	Flags: None
*/
function create_high_score_struct(time, faults, retries, bulletpenalty)
{
	score_set = spawnstruct();
	score_set.time = time;
	score_set.faults = faults;
	score_set.retries = retries;
	score_set.bulletpenalty = bulletpenalty;
	return score_set;
}

/*
	Name: get_stats_for_track
	Namespace: fr
	Checksum: 0xAF9041FA
	Offset: 0x4A98
	Size: 0xFA
	Parameters: 2
	Flags: None
*/
function get_stats_for_track(trackindex, slot)
{
	time = self get_high_score_stat(trackindex, slot, "time");
	faults = self get_high_score_stat(trackindex, slot, "faults");
	retries = self get_high_score_stat(trackindex, slot, "retries");
	bulletpenalty = self get_high_score_stat(trackindex, slot, "bulletPenalty");
	return create_high_score_struct(time, faults, retries, bulletpenalty);
}

/*
	Name: get_checkpoint_times_for_track
	Namespace: fr
	Checksum: 0x44EFB5B7
	Offset: 0x4BA0
	Size: 0x9C
	Parameters: 1
	Flags: None
*/
function get_checkpoint_times_for_track(trackindex)
{
	for(i = 0; i < level.frgame.checkpointtriggers.size; i++)
	{
		level.frgame.activetrack.fastestruncheckpointtimes[i] = self getdstat("freerunTrackTimes", "track", trackindex, "checkPointTimes", "time", i);
	}
}

/*
	Name: get_top_scores_stats
	Namespace: fr
	Checksum: 0x95A5960
	Offset: 0x4C48
	Size: 0x230
	Parameters: 0
	Flags: None
*/
function get_top_scores_stats()
{
	if(isdefined(level.frgame.activetrack.statsread))
	{
		return;
	}
	mapid = self getdstat("freerunTrackTimes", "track", level.frgame.trackindex, "mapUniqueId");
	mapversion = self getdstat("freerunTrackTimes", "track", level.frgame.trackindex, "mapVersion");
	if(level.frgame.mapuniqueid != mapid || level.frgame.mapversion != mapversion)
	{
		for(i = 0; i < 3; i++)
		{
			level.frgame.activetrack.highscores[i] = create_high_score_struct(0, 0, 0, 0);
		}
		for(i = 0; i < level.frgame.checkpointtriggers.size; i++)
		{
			level.frgame.activetrack.fastestruncheckpointtimes[i] = 0;
		}
	}
	else
	{
		for(i = 0; i < 3; i++)
		{
			level.frgame.activetrack.highscores[i] = get_stats_for_track(level.frgame.trackindex, i);
		}
		get_checkpoint_times_for_track(level.frgame.trackindex);
	}
	level.frgame.activetrack.statsread = 1;
}

/*
	Name: take_all_player_weapons
	Namespace: fr
	Checksum: 0xD3279D06
	Offset: 0x4E80
	Size: 0x22A
	Parameters: 2
	Flags: None
*/
function take_all_player_weapons(only_default, immediate)
{
	self endon(#"disconnect");
	self endon(#"death");
	keep_weapon = level.weaponnone;
	if(isdefined(level.frgame.activespawnpoint.weapon) && !only_default)
	{
		keep_weapon = level.frgame.activespawnpoint.weapon;
	}
	if(immediate)
	{
		self switchtoweaponimmediate(level.weaponbasemeleeheld);
	}
	else
	{
		while(self isswitchingweapons())
		{
			wait(0.05);
		}
		current_weapon = self getcurrentweapon();
		if(current_weapon != level.weaponbasemeleeheld && keep_weapon != current_weapon)
		{
			self switchtoweapon(level.weaponbasemeleeheld);
			while(self getcurrentweapon() != level.weaponbasemeleeheld)
			{
				wait(0.05);
			}
		}
	}
	weaponslist = self getweaponslist();
	foreach(weapon in weaponslist)
	{
		if(weapon != level.weaponbasemeleeheld && keep_weapon != weapon)
		{
			self takeweapon(weapon);
		}
	}
}

/*
	Name: freerunmusic
	Namespace: fr
	Checksum: 0x2DD3E657
	Offset: 0x50B8
	Size: 0xF4
	Parameters: 1
	Flags: None
*/
function freerunmusic(start = 1)
{
	player = self;
	if(start && (!(isdefined(player.musicstart) && player.musicstart)))
	{
		mapname = getdvarstring("mapname");
		player globallogic_audio::set_music_on_player(mapname);
		player.musicstart = 1;
	}
	else if(!start)
	{
		player globallogic_audio::set_music_on_player("mp_freerun_finish");
		player.musicstart = 0;
	}
}

/*
	Name: _tutorial_mode
	Namespace: fr
	Checksum: 0x7C6D8881
	Offset: 0x51B8
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function _tutorial_mode(b_tutorial_mode)
{
}

/*
	Name: take_players_out_of_tutorial_mode
	Namespace: fr
	Checksum: 0xBDD3D0DC
	Offset: 0x51D0
	Size: 0xC2
	Parameters: 0
	Flags: None
*/
function take_players_out_of_tutorial_mode()
{
	if(level.frgame.tutorials)
	{
		foreach(player in level.players)
		{
			player _tutorial_mode(0);
		}
	}
}

/*
	Name: put_players_in_tutorial_mode
	Namespace: fr
	Checksum: 0xF2A919
	Offset: 0x52A0
	Size: 0xCA
	Parameters: 0
	Flags: None
*/
function put_players_in_tutorial_mode()
{
	if(level.frgame.tutorials)
	{
		foreach(player in level.players)
		{
			player _tutorial_mode(1);
		}
	}
}

/*
	Name: enable_all_tutorial_triggers
	Namespace: fr
	Checksum: 0xC7F5E1
	Offset: 0x5378
	Size: 0xAA
	Parameters: 0
	Flags: None
*/
function enable_all_tutorial_triggers()
{
	if(level.frgame.tutorials)
	{
		foreach(trigger in level.frgame.tutorialtriggers)
		{
			trigger triggerenable(1);
		}
	}
}

/*
	Name: activate_tutorial_mode
	Namespace: fr
	Checksum: 0xD1140893
	Offset: 0x5430
	Size: 0x10A
	Parameters: 0
	Flags: None
*/
function activate_tutorial_mode()
{
	if(!self ishost() || getlocalprofileint("com_firsttime_freerun") && !getdvarint("freerun_tutorial"))
	{
		return;
	}
	level.frgame.tutorials = 1;
	wait(1);
	foreach(trigger in level.frgame.tutorialtriggers)
	{
		trigger thread watchtutorialtrigger();
	}
}

/*
	Name: setup_tutorial
	Namespace: fr
	Checksum: 0xA2A11DD6
	Offset: 0x5548
	Size: 0x74
	Parameters: 0
	Flags: None
*/
function setup_tutorial()
{
	level.frgame.tutorials = 0;
	level.frgame.tutorialtriggers = getentarray("fr_tutorial", "targetname");
	level.frgame.tutorialfunctions = [];
	register_tutorials();
}

/*
	Name: watchtutorialtrigger
	Namespace: fr
	Checksum: 0x5B7F9A25
	Offset: 0x55C8
	Size: 0x80
	Parameters: 0
	Flags: None
*/
function watchtutorialtrigger()
{
	level endon(#"stop_tutorials");
	while(true)
	{
		self waittill(#"trigger", player);
		if(isplayer(player))
		{
			player thread start_tutorial(self.script_noteworthy);
			self triggerenable(0);
		}
	}
}

/*
	Name: stop_tutorial_when_restarting_track
	Namespace: fr
	Checksum: 0x56719FC8
	Offset: 0x5650
	Size: 0x84
	Parameters: 0
	Flags: None
*/
function stop_tutorial_when_restarting_track()
{
	self notify(#"stop_tutorial_when_restarting_track");
	self waittill(#"stop_tutorial_when_restarting_track");
	level waittill(#"activate_track");
	take_players_out_of_tutorial_mode();
	self util::hide_hint_text(0);
	self stop_tutorial_vo();
	self stopsounds();
}

/*
	Name: start_tutorial
	Namespace: fr
	Checksum: 0xAC97C340
	Offset: 0x56E0
	Size: 0xCC
	Parameters: 1
	Flags: None
*/
function start_tutorial(tutorial)
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	level endon(#"activate_track");
	if(!isdefined(level.frgame.tutorialfunctions[tutorial]))
	{
		return;
	}
	level notify(#"playing_tutorial");
	level endon(#"playing_tutorial");
	self thread stop_tutorial_when_restarting_track();
	put_players_in_tutorial_mode();
	wait(0.5);
	[[level.frgame.tutorialfunctions[tutorial]]]();
	take_players_out_of_tutorial_mode();
}

/*
	Name: stop_tutorial_vo
	Namespace: fr
	Checksum: 0xFED16844
	Offset: 0x57B8
	Size: 0x36
	Parameters: 0
	Flags: None
*/
function stop_tutorial_vo()
{
	if(isdefined(self.lasttutorialvoplayed))
	{
		self stopsound(self.lasttutorialvoplayed);
		self.lasttutorialvoplayed = undefined;
	}
}

/*
	Name: play_tutorial_vo
	Namespace: fr
	Checksum: 0xC4B8205C
	Offset: 0x57F8
	Size: 0x68
	Parameters: 1
	Flags: None
*/
function play_tutorial_vo(aliasstring)
{
	self stop_tutorial_vo();
	self.lasttutorialvoplayed = aliasstring;
	self playsoundwithnotify(aliasstring, "sounddone");
	self waittill(#"sounddone");
	wait(1);
}

/*
	Name: play_tutorial_vo_with_hint
	Namespace: fr
	Checksum: 0xE0F49472
	Offset: 0x5868
	Size: 0x88
	Parameters: 2
	Flags: None
*/
function play_tutorial_vo_with_hint(aliasstring, text)
{
	self stop_tutorial_vo();
	self thread _show_tutorial_hint_with_vo(text);
	self.lasttutorialvoplayed = aliasstring;
	self playsoundwithnotify(aliasstring, "sounddone");
	self waittill(#"sounddone");
	wait(1);
}

/*
	Name: _show_tutorial_hint_with_vo
	Namespace: fr
	Checksum: 0xD667BD3D
	Offset: 0x58F8
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function _show_tutorial_hint_with_vo(text, time, unlock_player)
{
	wait(0.5);
	show_tutorial_hint(text, time, unlock_player);
}

/*
	Name: show_tutorial_hint
	Namespace: fr
	Checksum: 0x46192B0A
	Offset: 0x5948
	Size: 0x84
	Parameters: 3
	Flags: None
*/
function show_tutorial_hint(text, time, unlock_player)
{
	if(isdefined(unlock_player))
	{
		take_players_out_of_tutorial_mode();
	}
	if(!isdefined(time))
	{
		time = 4;
	}
	self util::show_hint_text(text, 0, "activate_track", 4);
	wait(4.5);
}

/*
	Name: show_tutorial_hint_with_full_movement
	Namespace: fr
	Checksum: 0x1B254FFF
	Offset: 0x59D8
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function show_tutorial_hint_with_full_movement(text, time)
{
	show_tutorial_hint(text, time, 1);
}

/*
	Name: register_tutorials
	Namespace: fr
	Checksum: 0xBD79C9F3
	Offset: 0x5A18
	Size: 0x2FE
	Parameters: 0
	Flags: None
*/
function register_tutorials()
{
	level.frgame.tutorialfunctions["tutorial_01"] = &tutorial_01;
	level.frgame.tutorialfunctions["tutorial_02"] = &tutorial_02;
	level.frgame.tutorialfunctions["tutorial_03"] = &tutorial_03;
	level.frgame.tutorialfunctions["tutorial_06"] = &tutorial_06;
	level.frgame.tutorialfunctions["tutorial_08"] = &tutorial_08;
	level.frgame.tutorialfunctions["tutorial_09"] = &tutorial_09;
	level.frgame.tutorialfunctions["tutorial_10"] = &tutorial_10;
	level.frgame.tutorialfunctions["tutorial_10a"] = &tutorial_10a;
	level.frgame.tutorialfunctions["tutorial_12"] = &tutorial_12;
	level.frgame.tutorialfunctions["tutorial_12a"] = &tutorial_12a;
	level.frgame.tutorialfunctions["tutorial_13"] = &tutorial_13;
	level.frgame.tutorialfunctions["tutorial_14"] = &tutorial_14;
	level.frgame.tutorialfunctions["tutorial_15"] = &tutorial_15;
	level.frgame.tutorialfunctions["tutorial_16"] = &tutorial_16;
	level.frgame.tutorialfunctions["tutorial_17"] = &tutorial_17;
	level.frgame.tutorialfunctions["tutorial_17a"] = &tutorial_17a;
	level.frgame.tutorialfunctions["tutorial_18"] = &tutorial_18;
	level.frgame.tutorialfunctions["tutorial_19"] = &tutorial_19;
	level.frgame.tutorialfunctions["tutorial_20"] = &tutorial_20;
}

/*
	Name: tutorial_01
	Namespace: fr
	Checksum: 0xC1028871
	Offset: 0x5D20
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function tutorial_01()
{
	self play_tutorial_vo("vox_tuto_tutorial_sequence_1");
	self play_tutorial_vo("vox_tuto_tutorial_sequence_2");
	self play_tutorial_vo("vox_tuto_tutorial_sequence_6");
}

/*
	Name: tutorial_02
	Namespace: fr
	Checksum: 0x6F6F781A
	Offset: 0x5D90
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function tutorial_02()
{
	self show_tutorial_hint_with_full_movement(&"FREERUN_TUTORIAL_02");
}

/*
	Name: tutorial_03
	Namespace: fr
	Checksum: 0x767DAFB2
	Offset: 0x5DC0
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function tutorial_03()
{
	self show_tutorial_hint_with_full_movement(&"FREERUN_TUTORIAL_03");
}

/*
	Name: tutorial_06
	Namespace: fr
	Checksum: 0x8ABBA870
	Offset: 0x5DF0
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function tutorial_06()
{
	self thread play_tutorial_vo("vox_tuto_tutorial_sequence_11");
	self show_tutorial_hint_with_full_movement(&"FREERUN_TUTORIAL_09");
}

/*
	Name: tutorial_08
	Namespace: fr
	Checksum: 0xF1BA9BCB
	Offset: 0x5E40
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function tutorial_08()
{
	self show_tutorial_hint_with_full_movement(&"FREERUN_TUTORIAL_11");
}

/*
	Name: tutorial_09
	Namespace: fr
	Checksum: 0xE08273EC
	Offset: 0x5E70
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function tutorial_09()
{
	self play_tutorial_vo_with_hint("vox_tuto_tutorial_sequence_28", &"FREERUN_TUTORIAL_12");
}

/*
	Name: tutorial_10
	Namespace: fr
	Checksum: 0xD9920DF4
	Offset: 0x5EA8
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function tutorial_10()
{
	self play_tutorial_vo("vox_tuto_tutorial_sequence_10");
}

/*
	Name: tutorial_10a
	Namespace: fr
	Checksum: 0x265EE480
	Offset: 0x5ED8
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function tutorial_10a()
{
	self show_tutorial_hint_with_full_movement(&"FREERUN_TUTORIAL_13");
}

/*
	Name: tutorial_12
	Namespace: fr
	Checksum: 0xD758F00A
	Offset: 0x5F08
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function tutorial_12()
{
	self play_tutorial_vo("vox_tuto_tutorial_sequence_16");
}

/*
	Name: tutorial_12a
	Namespace: fr
	Checksum: 0x1D1D61C0
	Offset: 0x5F38
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function tutorial_12a()
{
	self show_tutorial_hint_with_full_movement(&"FREERUN_TUTORIAL_14");
}

/*
	Name: tutorial_13
	Namespace: fr
	Checksum: 0xCE082E55
	Offset: 0x5F68
	Size: 0x6C
	Parameters: 0
	Flags: None
*/
function tutorial_13()
{
	self play_tutorial_vo_with_hint("vox_tuto_tutorial_sequence_17", &"FREERUN_TUTORIAL_14a");
	self play_tutorial_vo("vox_tuto_tutorial_sequence_18");
	self show_tutorial_hint_with_full_movement(&"FREERUN_TUTORIAL_16");
}

/*
	Name: tutorial_14
	Namespace: fr
	Checksum: 0x44EDBFDD
	Offset: 0x5FE0
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function tutorial_14()
{
	self play_tutorial_vo("vox_tuto_tutorial_sequence_19");
	self show_tutorial_hint_with_full_movement(&"FREERUN_TUTORIAL_18");
}

/*
	Name: tutorial_15
	Namespace: fr
	Checksum: 0x8884FC08
	Offset: 0x6030
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function tutorial_15()
{
	self play_tutorial_vo("vox_tuto_tutorial_sequence_20");
}

/*
	Name: tutorial_16
	Namespace: fr
	Checksum: 0x3BF14A7E
	Offset: 0x6060
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function tutorial_16()
{
	self play_tutorial_vo("vox_tuto_tutorial_sequence_29");
}

/*
	Name: tutorial_17
	Namespace: fr
	Checksum: 0x55F2CB53
	Offset: 0x6090
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function tutorial_17()
{
	self play_tutorial_vo("vox_tuto_tutorial_sequence_21");
}

/*
	Name: tutorial_17a
	Namespace: fr
	Checksum: 0xF99E60AC
	Offset: 0x60C0
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function tutorial_17a()
{
	self show_tutorial_hint_with_full_movement(&"FREERUN_TUTORIAL_22");
}

/*
	Name: tutorial_18
	Namespace: fr
	Checksum: 0xCCEE1919
	Offset: 0x60F0
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function tutorial_18()
{
	self play_tutorial_vo_with_hint("vox_tuto_tutorial_sequence_23", &"FREERUN_TUTORIAL_23");
	self show_tutorial_hint_with_full_movement(&"FREERUN_TUTORIAL_22a");
}

/*
	Name: tutorial_19
	Namespace: fr
	Checksum: 0xCD6D3988
	Offset: 0x6148
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function tutorial_19()
{
	self play_tutorial_vo("vox_tuto_tutorial_sequence_25");
}

/*
	Name: tutorial_20
	Namespace: fr
	Checksum: 0xF0D6F866
	Offset: 0x6178
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function tutorial_20()
{
	self play_tutorial_vo("vox_tuto_tutorial_sequence_26");
}

