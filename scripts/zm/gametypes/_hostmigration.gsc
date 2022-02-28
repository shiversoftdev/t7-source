// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace hostmigration;

/*
	Name: debug_script_structs
	Namespace: hostmigration
	Checksum: 0x66100F4E
	Offset: 0x268
	Size: 0x13C
	Parameters: 0
	Flags: None
*/
function debug_script_structs()
{
	/#
		if(isdefined(level.struct))
		{
			println("" + level.struct.size);
			println("");
			for(i = 0; i < level.struct.size; i++)
			{
				struct = level.struct[i];
				if(isdefined(struct.targetname))
				{
					println((("" + i) + "") + struct.targetname);
					continue;
				}
				println((("" + i) + "") + "");
			}
		}
		else
		{
			println("");
		}
	#/
}

/*
	Name: updatetimerpausedness
	Namespace: hostmigration
	Checksum: 0xC43D16B6
	Offset: 0x3B0
	Size: 0x88
	Parameters: 0
	Flags: None
*/
function updatetimerpausedness()
{
	shouldbestopped = isdefined(level.hostmigrationtimer);
	if(!level.timerstopped && shouldbestopped)
	{
		level.timerstopped = 1;
		level.timerpausetime = gettime();
	}
	else if(level.timerstopped && !shouldbestopped)
	{
		level.timerstopped = 0;
		level.discardtime = level.discardtime + (gettime() - level.timerpausetime);
	}
}

/*
	Name: callback_hostmigrationsave
	Namespace: hostmigration
	Checksum: 0x99EC1590
	Offset: 0x440
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function callback_hostmigrationsave()
{
}

/*
	Name: callback_prehostmigrationsave
	Namespace: hostmigration
	Checksum: 0x69B39178
	Offset: 0x450
	Size: 0xC6
	Parameters: 0
	Flags: Linked
*/
function callback_prehostmigrationsave()
{
	zm_utility::undo_link_changes();
	if(isdefined(level._hm_should_pause_spawning) && level._hm_should_pause_spawning)
	{
		level flag::set("spawn_zombies");
	}
	for(i = 0; i < level.players.size; i++)
	{
		level.players[i] enableinvulnerability();
		level.players[i] setdstat("AfterActionReportStats", "lobbyPopup", "summary");
	}
}

/*
	Name: pausetimer
	Namespace: hostmigration
	Checksum: 0xF05C517D
	Offset: 0x520
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function pausetimer()
{
	level.migrationtimerpausetime = gettime();
}

/*
	Name: resumetimer
	Namespace: hostmigration
	Checksum: 0xC45D5429
	Offset: 0x538
	Size: 0x20
	Parameters: 0
	Flags: None
*/
function resumetimer()
{
	level.discardtime = level.discardtime + (gettime() - level.migrationtimerpausetime);
}

/*
	Name: locktimer
	Namespace: hostmigration
	Checksum: 0x29D6DFF4
	Offset: 0x560
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function locktimer()
{
	level endon(#"host_migration_begin");
	level endon(#"host_migration_end");
	for(;;)
	{
		currtime = gettime();
		wait(0.05);
		if(!level.timerstopped && isdefined(level.discardtime))
		{
			level.discardtime = level.discardtime + (gettime() - currtime);
		}
	}
}

/*
	Name: callback_hostmigration
	Namespace: hostmigration
	Checksum: 0x7FA55ABD
	Offset: 0x5D0
	Size: 0x89A
	Parameters: 0
	Flags: Linked
*/
function callback_hostmigration()
{
	zm_utility::redo_link_changes();
	setslowmotion(1, 1, 0);
	zm_utility::upload_zm_dash_counters();
	level.hostmigrationreturnedplayercount = 0;
	if(level.gameended)
	{
		/#
			println(("" + gettime()) + "");
		#/
		return;
	}
	sethostmigrationstatus(1);
	level notify(#"host_migration_begin");
	for(i = 0; i < level.players.size; i++)
	{
		if(isdefined(level.hostmigration_link_entity_callback))
		{
			if(!isdefined(level.players[i]._host_migration_link_entity))
			{
				level.players[i]._host_migration_link_entity = level.players[i] [[level.hostmigration_link_entity_callback]]();
			}
		}
		level.players[i] thread hostmigrationtimerthink();
	}
	if(isdefined(level.hostmigration_ai_link_entity_callback))
	{
		zombies = getaiteamarray(level.zombie_team);
		if(isdefined(zombies) && zombies.size > 0)
		{
			foreach(zombie in zombies)
			{
				if(!isdefined(zombie._host_migration_link_entity))
				{
					zombie._host_migration_link_entity = zombie [[level.hostmigration_ai_link_entity_callback]]();
				}
			}
		}
	}
	else
	{
		zombies = getaiteamarray(level.zombie_team);
		if(isdefined(zombies) && zombies.size > 0)
		{
			foreach(zombie in zombies)
			{
				zombie.no_powerups = 1;
				zombie.marked_for_recycle = 1;
				zombie.has_been_damaged_by_player = 0;
				zombie dodamage(zombie.health + 1000, zombie.origin, zombie);
			}
		}
	}
	if(level.inprematchperiod)
	{
		level waittill(#"prematch_over");
	}
	/#
		println("" + gettime());
	#/
	level.hostmigrationtimer = 1;
	thread locktimer();
	if(isdefined(level.b_host_migration_force_player_respawn) && level.b_host_migration_force_player_respawn)
	{
		foreach(player in level.players)
		{
			if(zm_utility::is_player_valid(player, 0, 0))
			{
				player host_migration_respawn();
			}
		}
	}
	zombies = getaiteamarray(level.zombie_team);
	if(isdefined(zombies) && zombies.size > 0)
	{
		foreach(zombie in zombies)
		{
			if(isdefined(zombie._host_migration_link_entity))
			{
				ent = spawn("script_origin", zombie.origin);
				ent.angles = zombie.angles;
				zombie linkto(ent);
				ent linkto(zombie._host_migration_link_entity, "tag_origin", zombie._host_migration_link_entity worldtolocalcoords(ent.origin), ent.angles + zombie._host_migration_link_entity.angles);
				zombie._host_migration_link_helper = ent;
				zombie linkto(zombie._host_migration_link_helper);
			}
		}
	}
	level endon(#"host_migration_begin");
	should_pause_spawning = level flag::get("spawn_zombies");
	if(should_pause_spawning)
	{
		level flag::clear("spawn_zombies");
	}
	hostmigrationwait();
	foreach(player in level.players)
	{
		player thread post_migration_invulnerability();
	}
	zombies = getaiteamarray(level.zombie_team);
	if(isdefined(zombies) && zombies.size > 0)
	{
		foreach(zombie in zombies)
		{
			if(isdefined(zombie._host_migration_link_entity))
			{
				zombie unlink();
				zombie._host_migration_link_helper delete();
				zombie._host_migration_link_helper = undefined;
				zombie._host_migration_link_entity = undefined;
			}
		}
	}
	if(should_pause_spawning)
	{
		level flag::set("spawn_zombies");
	}
	level.hostmigrationtimer = undefined;
	level._hm_should_pause_spawning = undefined;
	sethostmigrationstatus(0);
	/#
		println("" + gettime());
	#/
	level notify(#"host_migration_end");
}

/*
	Name: post_migration_become_vulnerable
	Namespace: hostmigration
	Checksum: 0xA9E37AB6
	Offset: 0xE78
	Size: 0xE
	Parameters: 0
	Flags: None
*/
function post_migration_become_vulnerable()
{
	self endon(#"disconnect");
}

/*
	Name: post_migration_invulnerability
	Namespace: hostmigration
	Checksum: 0x9C8798D9
	Offset: 0xE90
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function post_migration_invulnerability()
{
	self endon(#"disconnect");
	was_inv = self enableinvulnerability();
	wait(3);
	self disableinvulnerability();
}

/*
	Name: host_migration_respawn
	Namespace: hostmigration
	Checksum: 0x9B7FE140
	Offset: 0xEE8
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function host_migration_respawn()
{
	/#
		println("");
	#/
	new_origin = undefined;
	if(isdefined(level.check_valid_spawn_override))
	{
		new_origin = [[level.check_valid_spawn_override]](self);
	}
	if(!isdefined(new_origin))
	{
		new_origin = zm::check_for_valid_spawn_near_team(self, 1);
	}
	if(isdefined(new_origin))
	{
		if(!isdefined(new_origin.angles))
		{
			angles = (0, 0, 0);
		}
		else
		{
			angles = new_origin.angles;
		}
		self dontinterpolate();
		self setorigin(new_origin.origin);
		self setplayerangles(angles);
	}
	return true;
}

/*
	Name: matchstarttimerconsole_internal
	Namespace: hostmigration
	Checksum: 0x1462FFE2
	Offset: 0x1000
	Size: 0xB4
	Parameters: 2
	Flags: Linked
*/
function matchstarttimerconsole_internal(counttime, matchstarttimer)
{
	waittillframeend();
	level endon(#"match_start_timer_beginning");
	while(counttime > 0 && !level.gameended)
	{
		matchstarttimer thread hud::font_pulse(level);
		wait(matchstarttimer.inframes * 0.05);
		matchstarttimer setvalue(counttime);
		counttime--;
		wait(1 - (matchstarttimer.inframes * 0.05));
	}
}

/*
	Name: matchstarttimerconsole
	Namespace: hostmigration
	Checksum: 0x5E36ED5E
	Offset: 0x10C0
	Size: 0x264
	Parameters: 2
	Flags: Linked
*/
function matchstarttimerconsole(type, duration)
{
	thread matchstartblacscreen(duration);
	level notify(#"match_start_timer_beginning");
	wait(0.05);
	matchstarttext = hud::createserverfontstring("objective", 1.5);
	matchstarttext hud::setpoint("CENTER", "CENTER", 0, -40);
	matchstarttext.sort = 1001;
	matchstarttext settext(game["strings"]["waiting_for_teams"]);
	matchstarttext.foreground = 0;
	matchstarttext.hidewheninmenu = 1;
	matchstarttext settext(game["strings"][type]);
	matchstarttimer = hud::createserverfontstring("objective", 2.2);
	matchstarttimer hud::setpoint("CENTER", "CENTER", 0, 0);
	matchstarttimer.sort = 1001;
	matchstarttimer.color = (1, 1, 0);
	matchstarttimer.foreground = 0;
	matchstarttimer.hidewheninmenu = 1;
	matchstarttimer hud::font_pulse_init();
	counttime = int(duration);
	if(counttime >= 2)
	{
		matchstarttimerconsole_internal(counttime, matchstarttimer);
	}
	matchstarttimer hud::destroyelem();
	matchstarttext hud::destroyelem();
}

/*
	Name: matchstartblacscreen
	Namespace: hostmigration
	Checksum: 0xD4D8DE13
	Offset: 0x1330
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function matchstartblacscreen(duration)
{
	array::thread_all(getplayers(), &zm::initialblack);
	fade_time = 4;
	n_black_screen = duration - fade_time;
	level thread zm::fade_out_intro_screen_zm(n_black_screen, fade_time, 1);
	wait(fade_time);
}

/*
	Name: hostmigrationwait
	Namespace: hostmigration
	Checksum: 0x6D66783B
	Offset: 0x13D0
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function hostmigrationwait()
{
	level endon(#"game_ended");
	if(level.hostmigrationreturnedplayercount < ((level.players.size * 2) / 3))
	{
		thread matchstarttimerconsole("waiting_for_teams", 20);
		hostmigrationwaitforplayers();
	}
	thread matchstarttimerconsole("match_starting_in", 9);
	wait(5);
}

/*
	Name: hostmigrationwaitforplayers
	Namespace: hostmigration
	Checksum: 0xBF0D71D4
	Offset: 0x1468
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function hostmigrationwaitforplayers()
{
	level endon(#"hostmigration_enoughplayers");
	wait(15);
}

/*
	Name: hostmigrationtimerthink_internal
	Namespace: hostmigration
	Checksum: 0xB34A1481
	Offset: 0x1488
	Size: 0x190
	Parameters: 0
	Flags: Linked
*/
function hostmigrationtimerthink_internal()
{
	level endon(#"host_migration_begin");
	level endon(#"host_migration_end");
	self.hostmigrationcontrolsfrozen = 0;
	while(!isalive(self))
	{
		self waittill(#"spawned");
	}
	if(isdefined(self._host_migration_link_entity))
	{
		ent = spawn("script_origin", self.origin);
		ent.angles = self.angles;
		self linkto(ent);
		ent linkto(self._host_migration_link_entity, "tag_origin", self._host_migration_link_entity worldtolocalcoords(ent.origin), ent.angles + self._host_migration_link_entity.angles);
		self._host_migration_link_helper = ent;
		/#
			println("" + self._host_migration_link_entity.targetname);
		#/
	}
	self.hostmigrationcontrolsfrozen = 1;
	self freezecontrols(1);
	level waittill(#"host_migration_end");
}

/*
	Name: hostmigrationtimerthink
	Namespace: hostmigration
	Checksum: 0x1C86DC4E
	Offset: 0x1620
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function hostmigrationtimerthink()
{
	self endon(#"disconnect");
	level endon(#"host_migration_begin");
	hostmigrationtimerthink_internal();
	if(self.hostmigrationcontrolsfrozen)
	{
		self freezecontrols(0);
		self.hostmigrationcontrolsfrozen = 0;
		/#
			println("");
		#/
	}
	if(isdefined(self._host_migration_link_entity))
	{
		self unlink();
		self._host_migration_link_helper delete();
		self._host_migration_link_helper = undefined;
		if(isdefined(self._host_migration_link_entity._post_host_migration_thread))
		{
			self thread [[self._host_migration_link_entity._post_host_migration_thread]](self._host_migration_link_entity);
		}
		self._host_migration_link_entity = undefined;
	}
}

/*
	Name: waittillhostmigrationdone
	Namespace: hostmigration
	Checksum: 0xE10DA501
	Offset: 0x1720
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function waittillhostmigrationdone()
{
	if(!isdefined(level.hostmigrationtimer))
	{
		return 0;
	}
	starttime = gettime();
	level waittill(#"host_migration_end");
	return gettime() - starttime;
}

/*
	Name: waittillhostmigrationstarts
	Namespace: hostmigration
	Checksum: 0xEC32DD0D
	Offset: 0x1760
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function waittillhostmigrationstarts(duration)
{
	if(isdefined(level.hostmigrationtimer))
	{
		return;
	}
	level endon(#"host_migration_begin");
	wait(duration);
}

/*
	Name: waitlongdurationwithhostmigrationpause
	Namespace: hostmigration
	Checksum: 0x2CD505BD
	Offset: 0x1798
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function waitlongdurationwithhostmigrationpause(duration)
{
	if(duration == 0)
	{
		return;
	}
	/#
		assert(duration > 0);
	#/
	starttime = gettime();
	endtime = gettime() + (duration * 1000);
	while(gettime() < endtime)
	{
		waittillhostmigrationstarts((endtime - gettime()) / 1000);
		if(isdefined(level.hostmigrationtimer))
		{
			timepassed = waittillhostmigrationdone();
			endtime = endtime + timepassed;
		}
	}
	if(gettime() != endtime)
	{
		/#
			println((("" + gettime()) + "") + endtime);
		#/
	}
	waittillhostmigrationdone();
	return gettime() - starttime;
}

/*
	Name: waitlongdurationwithgameendtimeupdate
	Namespace: hostmigration
	Checksum: 0x6A917748
	Offset: 0x18D0
	Size: 0x17E
	Parameters: 1
	Flags: None
*/
function waitlongdurationwithgameendtimeupdate(duration)
{
	if(duration == 0)
	{
		return;
	}
	/#
		assert(duration > 0);
	#/
	starttime = gettime();
	endtime = gettime() + (duration * 1000);
	while(gettime() < endtime)
	{
		waittillhostmigrationstarts((endtime - gettime()) / 1000);
		while(isdefined(level.hostmigrationtimer))
		{
			endtime = endtime + 1000;
			setgameendtime(int(endtime));
			wait(1);
		}
	}
	/#
		if(gettime() != endtime)
		{
			println((("" + gettime()) + "") + endtime);
		}
	#/
	while(isdefined(level.hostmigrationtimer))
	{
		endtime = endtime + 1000;
		setgameendtime(int(endtime));
		wait(1);
	}
	return gettime() - starttime;
}

/*
	Name: find_alternate_player_place
	Namespace: hostmigration
	Checksum: 0xBF225FB1
	Offset: 0x1A58
	Size: 0x2AC
	Parameters: 5
	Flags: Linked
*/
function find_alternate_player_place(v_origin, min_radius, max_radius, max_height, ignore_targetted_nodes)
{
	found_node = undefined;
	a_nodes = getnodesinradiussorted(v_origin, max_radius, min_radius, max_height, "pathnodes");
	if(isdefined(a_nodes) && a_nodes.size > 0)
	{
		a_player_volumes = getentarray("player_volume", "script_noteworthy");
		index = a_nodes.size - 1;
		for(i = index; i >= 0; i--)
		{
			n_node = a_nodes[i];
			if(ignore_targetted_nodes == 1)
			{
				if(isdefined(n_node.target))
				{
					continue;
				}
			}
			if(!positionwouldtelefrag(n_node.origin))
			{
				if(zm_utility::check_point_in_enabled_zone(n_node.origin, 1, a_player_volumes))
				{
					v_start = (n_node.origin[0], n_node.origin[1], n_node.origin[2] + 30);
					v_end = (n_node.origin[0], n_node.origin[1], n_node.origin[2] - 30);
					trace = bullettrace(v_start, v_end, 0, undefined);
					if(trace["fraction"] < 1)
					{
						override_abort = 0;
						if(isdefined(level._whoswho_reject_node_override_func))
						{
							override_abort = [[level._whoswho_reject_node_override_func]](v_origin, n_node);
						}
						if(!override_abort)
						{
							found_node = n_node;
							break;
						}
					}
				}
			}
		}
	}
	return found_node;
}

/*
	Name: hostmigration_put_player_in_better_place
	Namespace: hostmigration
	Checksum: 0x933975CA
	Offset: 0x1D10
	Size: 0x394
	Parameters: 0
	Flags: None
*/
function hostmigration_put_player_in_better_place()
{
	spawnpoint = undefined;
	spawnpoint = find_alternate_player_place(self.origin, 50, 150, 64, 1);
	if(!isdefined(spawnpoint))
	{
		spawnpoint = find_alternate_player_place(self.origin, 150, 400, 64, 1);
	}
	if(!isdefined(spawnpoint))
	{
		spawnpoint = find_alternate_player_place(self.origin, 50, 400, 256, 0);
	}
	if(!isdefined(spawnpoint))
	{
		spawnpoint = zm::check_for_valid_spawn_near_team(self, 1);
	}
	if(!isdefined(spawnpoint))
	{
		match_string = "";
		location = level.scr_zm_map_start_location;
		if(location == "default" || location == "" && isdefined(level.default_start_location))
		{
			location = level.default_start_location;
		}
		match_string = (level.scr_zm_ui_gametype + "_") + location;
		spawnpoints = [];
		structs = struct::get_array("initial_spawn", "script_noteworthy");
		if(isdefined(structs))
		{
			foreach(struct in structs)
			{
				if(isdefined(struct.script_string))
				{
					tokens = strtok(struct.script_string, " ");
					foreach(token in tokens)
					{
						if(token == match_string)
						{
							spawnpoints[spawnpoints.size] = struct;
						}
					}
				}
			}
		}
		if(!isdefined(spawnpoints) || spawnpoints.size == 0)
		{
			spawnpoints = struct::get_array("initial_spawn_points", "targetname");
		}
		/#
			assert(isdefined(spawnpoints), "");
		#/
		spawnpoint = zm::getfreespawnpoint(spawnpoints, self);
	}
	if(isdefined(spawnpoint))
	{
		self setorigin(spawnpoint.origin);
	}
}

