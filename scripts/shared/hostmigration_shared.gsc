// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\util_shared;

#namespace hostmigration;

/*
	Name: debug_script_structs
	Namespace: hostmigration
	Checksum: 0x4000573A
	Offset: 0x160
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
	Checksum: 0xD27D2531
	Offset: 0x2A8
	Size: 0xA0
	Parameters: 0
	Flags: None
*/
function updatetimerpausedness()
{
	shouldbestopped = isdefined(level.hostmigrationtimer);
	if(!level.timerstopped && shouldbestopped)
	{
		level.timerstopped = 1;
		level.playabletimerstopped = 1;
		level.timerpausetime = gettime();
	}
	else if(level.timerstopped && !shouldbestopped)
	{
		level.timerstopped = 0;
		level.playabletimerstopped = 0;
		level.discardtime = level.discardtime + (gettime() - level.timerpausetime);
	}
}

/*
	Name: pausetimer
	Namespace: hostmigration
	Checksum: 0xE2660599
	Offset: 0x350
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
	Checksum: 0xD51A2B5B
	Offset: 0x368
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
	Checksum: 0x75C48429
	Offset: 0x390
	Size: 0x68
	Parameters: 0
	Flags: None
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
	Name: matchstarttimerconsole_internal
	Namespace: hostmigration
	Checksum: 0xF83530B
	Offset: 0x400
	Size: 0xF4
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
		if(counttime == 2)
		{
			visionsetnaked(getdvarstring("mapname"), 3);
		}
		counttime--;
		wait(1 - (matchstarttimer.inframes * 0.05));
	}
}

/*
	Name: matchstarttimerconsole
	Namespace: hostmigration
	Checksum: 0xC73E526C
	Offset: 0x500
	Size: 0x27C
	Parameters: 2
	Flags: Linked
*/
function matchstarttimerconsole(type, duration)
{
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
	if(isdefined(level.host_migration_activate_visionset_func))
	{
		level thread [[level.host_migration_activate_visionset_func]]();
	}
	if(counttime >= 2)
	{
		matchstarttimerconsole_internal(counttime, matchstarttimer);
	}
	if(isdefined(level.host_migration_deactivate_visionset_func))
	{
		level thread [[level.host_migration_deactivate_visionset_func]]();
	}
	matchstarttimer hud::destroyelem();
	matchstarttext hud::destroyelem();
}

/*
	Name: hostmigrationwait
	Namespace: hostmigration
	Checksum: 0xCA552724
	Offset: 0x788
	Size: 0x9A
	Parameters: 0
	Flags: None
*/
function hostmigrationwait()
{
	level endon(#"game_ended");
	if(level.hostmigrationreturnedplayercount < ((level.players.size * 2) / 3))
	{
		thread matchstarttimerconsole("waiting_for_teams", 20);
		hostmigrationwaitforplayers();
	}
	level notify(#"host_migration_countdown_begin");
	thread matchstarttimerconsole("match_starting_in", 5);
	wait(5);
}

/*
	Name: waittillhostmigrationcountdown
	Namespace: hostmigration
	Checksum: 0xB75EB330
	Offset: 0x830
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function waittillhostmigrationcountdown()
{
	level endon(#"host_migration_end");
	if(!isdefined(level.hostmigrationtimer))
	{
		return;
	}
	level waittill(#"host_migration_countdown_begin");
}

/*
	Name: hostmigrationwaitforplayers
	Namespace: hostmigration
	Checksum: 0xED5748DC
	Offset: 0x868
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
	Checksum: 0x5D666D2F
	Offset: 0x888
	Size: 0x80
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
	self.hostmigrationcontrolsfrozen = 1;
	self freezecontrols(1);
	level waittill(#"host_migration_end");
}

/*
	Name: hostmigrationtimerthink
	Namespace: hostmigration
	Checksum: 0xA4899C94
	Offset: 0x910
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function hostmigrationtimerthink()
{
	self endon(#"disconnect");
	level endon(#"host_migration_begin");
	hostmigrationtimerthink_internal();
	if(self.hostmigrationcontrolsfrozen)
	{
		self freezecontrols(0);
	}
}

/*
	Name: waittillhostmigrationdone
	Namespace: hostmigration
	Checksum: 0xBDE13E63
	Offset: 0x968
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
	Checksum: 0x8056C80D
	Offset: 0x9A8
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
	Checksum: 0x29CB3318
	Offset: 0x9E0
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
	/#
		if(gettime() != endtime)
		{
			println((("" + gettime()) + "") + endtime);
		}
	#/
	waittillhostmigrationdone();
	return gettime() - starttime;
}

/*
	Name: waitlongdurationwithhostmigrationpauseemp
	Namespace: hostmigration
	Checksum: 0x3577F787
	Offset: 0xB18
	Size: 0x14E
	Parameters: 1
	Flags: None
*/
function waitlongdurationwithhostmigrationpauseemp(duration)
{
	if(duration == 0)
	{
		return;
	}
	/#
		assert(duration > 0);
	#/
	starttime = gettime();
	empendtime = gettime() + (duration * 1000);
	level.empendtime = empendtime;
	while(gettime() < empendtime)
	{
		waittillhostmigrationstarts((empendtime - gettime()) / 1000);
		if(isdefined(level.hostmigrationtimer))
		{
			timepassed = waittillhostmigrationdone();
			if(isdefined(empendtime))
			{
				empendtime = empendtime + timepassed;
			}
		}
	}
	/#
		if(gettime() != empendtime)
		{
			println((("" + gettime()) + "") + empendtime);
		}
	#/
	waittillhostmigrationdone();
	level.empendtime = undefined;
	return gettime() - starttime;
}

/*
	Name: waitlongdurationwithgameendtimeupdate
	Namespace: hostmigration
	Checksum: 0x8E79BBDE
	Offset: 0xC70
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
	Name: migrationawarewait
	Namespace: hostmigration
	Checksum: 0xF7EA8BEE
	Offset: 0xDF8
	Size: 0xE8
	Parameters: 1
	Flags: Linked
*/
function migrationawarewait(durationms)
{
	waittillhostmigrationdone();
	endtime = gettime() + durationms;
	timeremaining = durationms;
	while(true)
	{
		event = level util::waittill_level_any_timeout(timeremaining / 1000, self, "game_ended", "host_migration_begin");
		if(!isdefined(event))
		{
			return;
		}
		if(event != "host_migration_begin")
		{
			return;
		}
		timeremaining = endtime - gettime();
		if(timeremaining <= 0)
		{
			return;
		}
		endtime = gettime() + durationms;
		waittillhostmigrationdone();
	}
}

