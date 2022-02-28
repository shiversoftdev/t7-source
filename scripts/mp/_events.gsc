// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\shared\util_shared;

#namespace events;

/*
	Name: add_timed_event
	Namespace: events
	Checksum: 0xD51A2C92
	Offset: 0x100
	Size: 0x6C
	Parameters: 3
	Flags: None
*/
function add_timed_event(seconds, notify_string, client_notify_string)
{
	/#
		assert(seconds >= 0);
	#/
	if(level.timelimit > 0)
	{
		level thread timed_event_monitor(seconds, notify_string, client_notify_string);
	}
}

/*
	Name: timed_event_monitor
	Namespace: events
	Checksum: 0x4FF4517E
	Offset: 0x178
	Size: 0x9A
	Parameters: 3
	Flags: None
*/
function timed_event_monitor(seconds, notify_string, client_notify_string)
{
	for(;;)
	{
		wait(0.5);
		if(!isdefined(level.starttime))
		{
			continue;
		}
		millisecs_remaining = globallogic_utils::gettimeremaining();
		seconds_remaining = millisecs_remaining / 1000;
		if(seconds_remaining <= seconds)
		{
			event_notify(notify_string, client_notify_string);
			return;
		}
	}
}

/*
	Name: add_score_event
	Namespace: events
	Checksum: 0x67F395E3
	Offset: 0x220
	Size: 0x9C
	Parameters: 3
	Flags: None
*/
function add_score_event(score, notify_string, client_notify_string)
{
	/#
		assert(score >= 0);
	#/
	if(level.scorelimit > 0)
	{
		if(level.teambased)
		{
			level thread score_team_event_monitor(score, notify_string, client_notify_string);
		}
		else
		{
			level thread score_event_monitor(score, notify_string, client_notify_string);
		}
	}
}

/*
	Name: add_round_score_event
	Namespace: events
	Checksum: 0x9FDF7685
	Offset: 0x2C8
	Size: 0xC4
	Parameters: 3
	Flags: None
*/
function add_round_score_event(score, notify_string, client_notify_string)
{
	/#
		assert(score >= 0);
	#/
	if(level.roundscorelimit > 0)
	{
		roundscoretobeat = (level.roundscorelimit * game["roundsplayed"]) + score;
		if(level.teambased)
		{
			level thread score_team_event_monitor(roundscoretobeat, notify_string, client_notify_string);
		}
		else
		{
			level thread score_event_monitor(roundscoretobeat, notify_string, client_notify_string);
		}
	}
}

/*
	Name: any_team_reach_score
	Namespace: events
	Checksum: 0x38156E6C
	Offset: 0x398
	Size: 0xA0
	Parameters: 1
	Flags: None
*/
function any_team_reach_score(score)
{
	foreach(team in level.teams)
	{
		if(game["teamScores"][team] >= score)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: score_team_event_monitor
	Namespace: events
	Checksum: 0xA5E0A35D
	Offset: 0x440
	Size: 0x62
	Parameters: 3
	Flags: None
*/
function score_team_event_monitor(score, notify_string, client_notify_string)
{
	for(;;)
	{
		wait(0.5);
		if(any_team_reach_score(score))
		{
			event_notify(notify_string, client_notify_string);
			return;
		}
	}
}

/*
	Name: score_event_monitor
	Namespace: events
	Checksum: 0x5076A8F
	Offset: 0x4B0
	Size: 0xBC
	Parameters: 3
	Flags: None
*/
function score_event_monitor(score, notify_string, client_notify_string)
{
	for(;;)
	{
		wait(0.5);
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(isdefined(players[i].score) && players[i].score >= score)
			{
				event_notify(notify_string, client_notify_string);
				return;
			}
		}
	}
}

/*
	Name: event_notify
	Namespace: events
	Checksum: 0x1D70FBDA
	Offset: 0x578
	Size: 0x4C
	Parameters: 2
	Flags: None
*/
function event_notify(notify_string, client_notify_string)
{
	if(isdefined(notify_string))
	{
		level notify(notify_string);
	}
	if(isdefined(client_notify_string))
	{
		util::clientnotify(client_notify_string);
	}
}

