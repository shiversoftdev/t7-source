// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_message_shared;

#namespace globallogic_utils;

/*
	Name: testmenu
	Namespace: globallogic_utils
	Checksum: 0xBFFAEEF0
	Offset: 0x2E0
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
	Checksum: 0xF6CB316B
	Offset: 0x380
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
	Name: timeuntilroundend
	Namespace: globallogic_utils
	Checksum: 0x80EE2051
	Offset: 0x448
	Size: 0xDC
	Parameters: 0
	Flags: None
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
	Checksum: 0x2BA9A328
	Offset: 0x530
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function gettimeremaining()
{
	if(level.timelimit == 0)
	{
		return undefined;
	}
	return ((level.timelimit * 60) * 1000) - gettimepassed();
}

/*
	Name: registerpostroundevent
	Namespace: globallogic_utils
	Checksum: 0xE3563218
	Offset: 0x578
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
	Checksum: 0xD24CAE61
	Offset: 0x5C0
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
	Checksum: 0xCA094853
	Offset: 0x620
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
	Checksum: 0xA739726B
	Offset: 0x680
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
	Checksum: 0xBC8ADE09
	Offset: 0x950
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function isvalidclass(c)
{
	if(level.oldschool || sessionmodeiszombiesgame())
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
	Checksum: 0x2F5AFE56
	Offset: 0x9C0
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
	Checksum: 0xF50CAE25
	Offset: 0xAE8
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
	Checksum: 0xB7EC2CA0
	Offset: 0xB08
	Size: 0xD4
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
	prevtime = gettime();
	while(game["state"] == "playing")
	{
		if(!level.timerstopped)
		{
			game["timepassed"] = game["timepassed"] + (gettime() - prevtime);
		}
		prevtime = gettime();
		wait(1);
	}
}

/*
	Name: gettimepassed
	Namespace: globallogic_utils
	Checksum: 0xA6A05CAB
	Offset: 0xBE8
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
	Checksum: 0xA6D0CED4
	Offset: 0xC48
	Size: 0x28
	Parameters: 0
	Flags: None
*/
function pausetimer()
{
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
	Checksum: 0xEC9776EF
	Offset: 0xC78
	Size: 0x38
	Parameters: 0
	Flags: None
*/
function resumetimer()
{
	if(!level.timerstopped)
	{
		return;
	}
	level.timerstopped = 0;
	level.discardtime = level.discardtime + (gettime() - level.timerpausetime);
}

/*
	Name: getscoreremaining
	Namespace: globallogic_utils
	Checksum: 0x457E681B
	Offset: 0xCB8
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
	Checksum: 0xEBE4D54D
	Offset: 0xD60
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
	Checksum: 0x7BC6649B
	Offset: 0xDD8
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function getscoreperminute(team)
{
	/#
		assert(isplayer(self) || isdefined(team));
	#/
	scorelimit = level.scorelimit;
	timelimit = level.timelimit;
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
	Checksum: 0x9013EC7
	Offset: 0xEC8
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
	Checksum: 0x84ECB8A4
	Offset: 0xF78
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
	Checksum: 0x7CC6DD55
	Offset: 0xFC0
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
	Checksum: 0x7012A40F
	Offset: 0xFF0
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
	Checksum: 0xB2365B75
	Offset: 0x1050
	Size: 0x96
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
		case "MOD_MELEE_WEAPON_BUTT":
		{
			return false;
		}
		case "MOD_IMPACT":
		{
			if(weapon != level.weaponballisticknife)
			{
				return false;
			}
		}
	}
	return true;
}

/*
	Name: gethitlocheight
	Namespace: globallogic_utils
	Checksum: 0x7C895ED6
	Offset: 0x10F0
	Size: 0xD6
	Parameters: 1
	Flags: Linked
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
	Checksum: 0x8DEAE826
	Offset: 0x11D0
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
	Checksum: 0x68AB2C73
	Offset: 0x1240
	Size: 0x5A
	Parameters: 2
	Flags: None
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
	Checksum: 0x32D3919
	Offset: 0x12A8
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
	Checksum: 0x4B2E0EC1
	Offset: 0x1318
	Size: 0x10C
	Parameters: 2
	Flags: Linked
*/
function logteamwinstring(wintype, winner)
{
	log_string = wintype;
	if(isdefined(winner))
	{
		log_string = (log_string + ", win: ") + winner;
	}
	foreach(team in level.teams)
	{
		log_string = (((log_string + ", ") + team) + ": ") + game["teamScores"][team];
	}
	/#
		print(log_string);
	#/
}

