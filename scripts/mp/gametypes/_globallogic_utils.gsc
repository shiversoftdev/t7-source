// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\killstreaks_shared;

#namespace globallogic_utils;

/*
	Name: testmenu
	Namespace: globallogic_utils
	Checksum: 0x78448647
	Offset: 0x370
	Size: 0x98
	Parameters: 0
	Flags: None
*/
function testmenu()
{
	self endon(#"death");
	self endon(#"disconnect");
	for(;;)
	{
		wait(10);
		notifydata = spawnstruct();
		notifydata.titletext = &"MP_CHALLENGE_COMPLETED";
		notifydata.notifytext = "wheee";
		notifydata.sound = "mp_challenge_complete";
		self thread hud_message::notifymessage(notifydata);
	}
}

/*
	Name: testshock
	Namespace: globallogic_utils
	Checksum: 0x48824301
	Offset: 0x410
	Size: 0xBA
	Parameters: 0
	Flags: None
*/
function testshock()
{
	self endon(#"death");
	self endon(#"disconnect");
	for(;;)
	{
		wait(3);
		numshots = randomint(6);
		for(i = 0; i < numshots; i++)
		{
			iprintlnbold(numshots);
			self shellshock("frag_grenade_mp", 0.2);
			wait(0.1);
		}
	}
}

/*
	Name: testhps
	Namespace: globallogic_utils
	Checksum: 0xF5770FF7
	Offset: 0x4D8
	Size: 0xD0
	Parameters: 0
	Flags: None
*/
function testhps()
{
	self endon(#"death");
	self endon(#"disconnect");
	hps = [];
	hps[hps.size] = "radar";
	hps[hps.size] = "artillery";
	hps[hps.size] = "dogs";
	for(;;)
	{
		hp = "radar";
		if(self thread killstreaks::give(hp))
		{
			self playlocalsound(level.killstreaks[hp].informdialog);
		}
		wait(20);
	}
}

/*
	Name: timeuntilroundend
	Namespace: globallogic_utils
	Checksum: 0x70B3B9D7
	Offset: 0x5B0
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function timeuntilroundend()
{
	if(level.gameended)
	{
		timepassed = (gettime() - level.gameendtime) / 1000;
		timeremaining = level.postroundtime - timepassed;
		if(timeremaining < 0)
		{
			return 0;
		}
		return timeremaining;
	}
	if(level.inovertime)
	{
		return undefined;
	}
	if(level.timelimit <= 0)
	{
		return undefined;
	}
	if(!isdefined(level.starttime))
	{
		return undefined;
	}
	timepassed = (gettimepassed() - level.starttime) / 1000;
	timeremaining = (level.timelimit * 60) - timepassed;
	return timeremaining + level.postroundtime;
}

/*
	Name: gettimeremaining
	Namespace: globallogic_utils
	Checksum: 0x443A6E16
	Offset: 0x698
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function gettimeremaining()
{
	return ((level.timelimit * 60) * 1000) - gettimepassed();
}

/*
	Name: registerpostroundevent
	Namespace: globallogic_utils
	Checksum: 0xFC61B36B
	Offset: 0x6D0
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function registerpostroundevent(eventfunc)
{
	if(!isdefined(level.postroundevents))
	{
		level.postroundevents = [];
	}
	level.postroundevents[level.postroundevents.size] = eventfunc;
}

/*
	Name: executepostroundevents
	Namespace: globallogic_utils
	Checksum: 0x79DFEF9D
	Offset: 0x718
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function executepostroundevents()
{
	if(!isdefined(level.postroundevents))
	{
		return;
	}
	for(i = 0; i < level.postroundevents.size; i++)
	{
		[[level.postroundevents[i]]]();
	}
}

/*
	Name: getvalueinrange
	Namespace: globallogic_utils
	Checksum: 0x96B89138
	Offset: 0x778
	Size: 0x50
	Parameters: 3
	Flags: None
*/
function getvalueinrange(value, minvalue, maxvalue)
{
	if(value > maxvalue)
	{
		return maxvalue;
	}
	if(value < minvalue)
	{
		return minvalue;
	}
	return value;
}

/*
	Name: assertproperplacement
	Namespace: globallogic_utils
	Checksum: 0xFBD4A158
	Offset: 0x7D8
	Size: 0x2C2
	Parameters: 0
	Flags: Linked
*/
function assertproperplacement()
{
	/#
		numplayers = level.placement[""].size;
		if(level.teambased)
		{
			for(i = 0; i < (numplayers - 1); i++)
			{
				if(level.placement[""][i].score < (level.placement[""][i + 1].score))
				{
					println("");
					for(i = 0; i < numplayers; i++)
					{
						player = level.placement[""][i];
						println((((("" + i) + "") + player.name) + "") + player.score);
					}
					/#
						assertmsg("");
					#/
					break;
				}
			}
		}
		else
		{
			for(i = 0; i < (numplayers - 1); i++)
			{
				if(level.placement[""][i].pointstowin < (level.placement[""][i + 1].pointstowin))
				{
					println("");
					for(i = 0; i < numplayers; i++)
					{
						player = level.placement[""][i];
						println((((("" + i) + "") + player.name) + "") + player.pointstowin);
					}
					/#
						assertmsg("");
					#/
					break;
				}
			}
		}
	#/
}

/*
	Name: isvalidclass
	Namespace: globallogic_utils
	Checksum: 0x1370E195
	Offset: 0xAA8
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function isvalidclass(c)
{
	if(sessionmodeiszombiesgame())
	{
		/#
			assert(!isdefined(c));
		#/
		return 1;
	}
	return isdefined(c) && c != "";
}

/*
	Name: playtickingsound
	Namespace: globallogic_utils
	Checksum: 0xACB63D80
	Offset: 0xB08
	Size: 0x120
	Parameters: 1
	Flags: None
*/
function playtickingsound(gametype_tick_sound)
{
	self endon(#"death");
	self endon(#"stop_ticking");
	level endon(#"game_ended");
	time = level.bombtimer;
	while(true)
	{
		self playsound(gametype_tick_sound);
		if(time > 10)
		{
			time = time - 1;
			wait(1);
		}
		else
		{
			if(time > 4)
			{
				time = time - 0.5;
				wait(0.5);
			}
			else
			{
				if(time > 1)
				{
					time = time - 0.4;
					wait(0.4);
				}
				else
				{
					time = time - 0.3;
					wait(0.3);
				}
			}
		}
		hostmigration::waittillhostmigrationdone();
	}
}

/*
	Name: stoptickingsound
	Namespace: globallogic_utils
	Checksum: 0x643299AC
	Offset: 0xC30
	Size: 0x12
	Parameters: 0
	Flags: None
*/
function stoptickingsound()
{
	self notify(#"stop_ticking");
}

/*
	Name: gametimer
	Namespace: globallogic_utils
	Checksum: 0x43EA0048
	Offset: 0xC50
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function gametimer()
{
	level endon(#"game_ended");
	level waittill(#"prematch_over");
	level.starttime = gettime();
	level.discardtime = 0;
	if(isdefined(game["roundMillisecondsAlreadyPassed"]))
	{
		level.starttime = level.starttime - game["roundMillisecondsAlreadyPassed"];
		game["roundMillisecondsAlreadyPassed"] = undefined;
	}
	prevtime = gettime() - 1000;
	while(game["state"] == "playing")
	{
		if(!level.timerstopped)
		{
			game["timepassed"] = game["timepassed"] + (gettime() - prevtime);
		}
		if(!level.playabletimerstopped)
		{
			game["playabletimepassed"] = game["playabletimepassed"] + (gettime() - prevtime);
		}
		prevtime = gettime();
		wait(1);
	}
}

/*
	Name: disableplayerroundstartdelay
	Namespace: globallogic_utils
	Checksum: 0xF9C8D203
	Offset: 0xD60
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function disableplayerroundstartdelay()
{
	player = self;
	player endon(#"death");
	player endon(#"disconnect");
	if(getroundstartdelay())
	{
		wait(getroundstartdelay());
	}
	player disableroundstartdelay();
}

/*
	Name: getroundstartdelay
	Namespace: globallogic_utils
	Checksum: 0x95E19757
	Offset: 0xDD8
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function getroundstartdelay()
{
	waittime = level.roundstartexplosivedelay - ([[level.gettimepassed]]() / 1000);
	if(waittime > 0)
	{
		return waittime;
	}
	return 0;
}

/*
	Name: applyroundstartdelay
	Namespace: globallogic_utils
	Checksum: 0x1A89328A
	Offset: 0xE20
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function applyroundstartdelay()
{
	self endon(#"disconnect");
	self endon(#"joined_spectators");
	self endon(#"death");
	if(isdefined(level.prematch_over) && level.prematch_over)
	{
		wait(0.05);
	}
	else
	{
		level waittill(#"prematch_over");
	}
	self enableroundstartdelay();
	self thread disableplayerroundstartdelay();
}

/*
	Name: gettimepassed
	Namespace: globallogic_utils
	Checksum: 0x7C2C92FB
	Offset: 0xEB0
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function gettimepassed()
{
	if(!isdefined(level.starttime))
	{
		return 0;
	}
	if(level.timerstopped)
	{
		return (level.timerpausetime - level.starttime) - level.discardtime;
	}
	return (gettime() - level.starttime) - level.discardtime;
}

/*
	Name: pausetimer
	Namespace: globallogic_utils
	Checksum: 0x516FE48B
	Offset: 0xF10
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function pausetimer(pauseplayabletimer = 0)
{
	level.playabletimerstopped = pauseplayabletimer;
	if(level.timerstopped)
	{
		return;
	}
	level.timerstopped = 1;
	level.timerpausetime = gettime();
}

/*
	Name: resumetimer
	Namespace: globallogic_utils
	Checksum: 0xA169B763
	Offset: 0xF68
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function resumetimer()
{
	if(!level.timerstopped)
	{
		return;
	}
	level.timerstopped = 0;
	level.playabletimerstopped = 0;
	level.discardtime = level.discardtime + (gettime() - level.timerpausetime);
}

/*
	Name: resumetimerdiscardoverride
	Namespace: globallogic_utils
	Checksum: 0xB62DCE78
	Offset: 0xFB8
	Size: 0x30
	Parameters: 1
	Flags: None
*/
function resumetimerdiscardoverride(discardtime)
{
	if(!level.timerstopped)
	{
		return;
	}
	level.timerstopped = 0;
	level.discardtime = discardtime;
}

/*
	Name: getscoreremaining
	Namespace: globallogic_utils
	Checksum: 0xD6F38852
	Offset: 0xFF0
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function getscoreremaining(team)
{
	/#
		assert(isplayer(self) || isdefined(team));
	#/
	scorelimit = level.scorelimit;
	if(isplayer(self))
	{
		return scorelimit - globallogic_score::_getplayerscore(self);
	}
	return scorelimit - getteamscore(team);
}

/*
	Name: getteamscoreforround
	Namespace: globallogic_utils
	Checksum: 0x9E3DA6D0
	Offset: 0x1098
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function getteamscoreforround(team)
{
	if(level.cumulativeroundscores && isdefined(game["lastroundscore"][team]))
	{
		return getteamscore(team) - game["lastroundscore"][team];
	}
	return getteamscore(team);
}

/*
	Name: getscoreperminute
	Namespace: globallogic_utils
	Checksum: 0xD6BBFB19
	Offset: 0x1110
	Size: 0xB8
	Parameters: 1
	Flags: Linked
*/
function getscoreperminute(team)
{
	/#
		assert(isplayer(self) || isdefined(team));
	#/
	minutespassed = (gettimepassed() / 60000) + 0.0001;
	if(isplayer(self))
	{
		return globallogic_score::_getplayerscore(self) / minutespassed;
	}
	return getteamscoreforround(team) / minutespassed;
}

/*
	Name: getestimatedtimeuntilscorelimit
	Namespace: globallogic_utils
	Checksum: 0xD7E4B586
	Offset: 0x11D8
	Size: 0xA2
	Parameters: 1
	Flags: Linked
*/
function getestimatedtimeuntilscorelimit(team)
{
	/#
		assert(isplayer(self) || isdefined(team));
	#/
	scoreperminute = self getscoreperminute(team);
	scoreremaining = self getscoreremaining(team);
	if(!scoreperminute)
	{
		return 999999;
	}
	return scoreremaining / scoreperminute;
}

/*
	Name: rumbler
	Namespace: globallogic_utils
	Checksum: 0x702E6A95
	Offset: 0x1288
	Size: 0x40
	Parameters: 0
	Flags: None
*/
function rumbler()
{
	self endon(#"disconnect");
	while(true)
	{
		wait(0.1);
		self playrumbleonentity("damage_heavy");
	}
}

/*
	Name: waitfortimeornotify
	Namespace: globallogic_utils
	Checksum: 0x8C3DF4DA
	Offset: 0x12D0
	Size: 0x22
	Parameters: 2
	Flags: Linked
*/
function waitfortimeornotify(time, notifyname)
{
	self endon(notifyname);
	wait(time);
}

/*
	Name: waitfortimeornotifynoartillery
	Namespace: globallogic_utils
	Checksum: 0x9969F391
	Offset: 0x1300
	Size: 0x58
	Parameters: 2
	Flags: None
*/
function waitfortimeornotifynoartillery(time, notifyname)
{
	self endon(notifyname);
	wait(time);
	while(isdefined(level.artilleryinprogress))
	{
		/#
			assert(level.artilleryinprogress);
		#/
		wait(0.25);
	}
}

/*
	Name: isheadshot
	Namespace: globallogic_utils
	Checksum: 0x73D3D715
	Offset: 0x1360
	Size: 0xEA
	Parameters: 4
	Flags: Linked
*/
function isheadshot(weapon, shitloc, smeansofdeath, einflictor)
{
	if(shitloc != "head" && shitloc != "helmet")
	{
		return false;
	}
	switch(smeansofdeath)
	{
		case "MOD_MELEE":
		case "MOD_MELEE_ASSASSINATE":
		{
			return false;
		}
		case "MOD_IMPACT":
		{
			if(weapon.rootweapon != level.weaponballisticknife)
			{
				return false;
			}
		}
	}
	if(killstreaks::is_killstreak_weapon(weapon))
	{
		if(!isdefined(einflictor) || !isdefined(einflictor.controlled) || einflictor.controlled == 0)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: gethitlocheight
	Namespace: globallogic_utils
	Checksum: 0xAC8C6168
	Offset: 0x1458
	Size: 0xD6
	Parameters: 1
	Flags: None
*/
function gethitlocheight(shitloc)
{
	switch(shitloc)
	{
		case "head":
		case "helmet":
		case "neck":
		{
			return 60;
		}
		case "gun":
		case "left_arm_lower":
		case "left_arm_upper":
		case "left_hand":
		case "right_arm_lower":
		case "right_arm_upper":
		case "right_hand":
		case "torso_upper":
		{
			return 48;
		}
		case "torso_lower":
		{
			return 40;
		}
		case "left_leg_upper":
		case "right_leg_upper":
		{
			return 32;
		}
		case "left_leg_lower":
		case "right_leg_lower":
		{
			return 10;
		}
		case "left_foot":
		case "right_foot":
		{
			return 5;
		}
	}
	return 48;
}

/*
	Name: debugline
	Namespace: globallogic_utils
	Checksum: 0x81CBEE3E
	Offset: 0x1538
	Size: 0x66
	Parameters: 2
	Flags: None
*/
function debugline(start, end)
{
	/#
		for(i = 0; i < 50; i++)
		{
			line(start, end);
			wait(0.05);
		}
	#/
}

/*
	Name: isexcluded
	Namespace: globallogic_utils
	Checksum: 0x96EB2474
	Offset: 0x15A8
	Size: 0x5A
	Parameters: 2
	Flags: Linked
*/
function isexcluded(entity, entitylist)
{
	for(index = 0; index < entitylist.size; index++)
	{
		if(entity == entitylist[index])
		{
			return true;
		}
	}
	return false;
}

/*
	Name: waitfortimeornotifies
	Namespace: globallogic_utils
	Checksum: 0x93004806
	Offset: 0x1610
	Size: 0x60
	Parameters: 1
	Flags: None
*/
function waitfortimeornotifies(desireddelay)
{
	startedwaiting = gettime();
	waitedtime = (gettime() - startedwaiting) / 1000;
	if(waitedtime < desireddelay)
	{
		wait(desireddelay - waitedtime);
		return desireddelay;
	}
	return waitedtime;
}

/*
	Name: logteamwinstring
	Namespace: globallogic_utils
	Checksum: 0xA2F9C154
	Offset: 0x1680
	Size: 0x10C
	Parameters: 2
	Flags: Linked
*/
function logteamwinstring(wintype, winner)
{
	/#
		log_string = wintype;
		if(isdefined(winner))
		{
			log_string = (log_string + "") + winner;
		}
		foreach(team in level.teams)
		{
			log_string = (((log_string + "") + team) + "") + game[""][team];
		}
		print(log_string);
	#/
}

