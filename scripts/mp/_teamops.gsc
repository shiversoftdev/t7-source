// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\callbacks_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace teamops;

/*
	Name: getteamopstableid
	Namespace: teamops
	Checksum: 0x8D9382D6
	Offset: 0x290
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function getteamopstableid()
{
	teamopsinfotableloaded = 0;
	teamopsinfotableid = tablelookupfindcoreasset("gamedata/tables/mp/teamops.csv");
	if(isdefined(teamopsinfotableid))
	{
		teamopsinfotableloaded = 1;
	}
	/#
		assert(teamopsinfotableloaded, "" + "");
	#/
	return teamopsinfotableid;
}

/*
	Name: init
	Namespace: teamops
	Checksum: 0x3A383364
	Offset: 0x318
	Size: 0x47C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	game["teamops"] = spawnstruct();
	game["teamops"].data = [];
	game["teamops"].teamprogress = [];
	game["teamops"].teamopsname = undefined;
	foreach(team in level.teams)
	{
		game["teamops"].teamprogress[team] = 0;
	}
	level.teamopsonprocessplayerevent = &processplayerevent;
	tableid = getteamopstableid();
	/#
		assert(isdefined(tableid));
	#/
	if(!isdefined(tableid))
	{
		game["teamops"].teamopsinitialed = 0;
		return;
	}
	for(row = 1; row < 256; row++)
	{
		name = tablelookupcolumnforrow(tableid, row, 0);
		if(name != "")
		{
			game["teamops"].data[name] = spawnstruct();
			game["teamops"].data[name].description = tablelookupcolumnforrow(tableid, row, 1);
			game["teamops"].data[name].pushevent = tablelookupcolumnforrow(tableid, row, 2);
			game["teamops"].data[name].popevent = tablelookupcolumnforrow(tableid, row, 3);
			game["teamops"].data[name].resetevent = tablelookupcolumnforrow(tableid, row, 4);
			game["teamops"].data[name].count = int(tablelookupcolumnforrow(tableid, row, 5));
			game["teamops"].data[name].time = int(tablelookupcolumnforrow(tableid, row, 6));
			game["teamops"].data[name].modes = strtok(tablelookupcolumnforrow(tableid, row, 7), ",");
			game["teamops"].data[name].rewards = strtok(tablelookupcolumnforrow(tableid, row, 8), ",");
		}
	}
	game["teamops"].teamopsinitialized = 1;
}

/*
	Name: getid
	Namespace: teamops
	Checksum: 0x3EA0880F
	Offset: 0x7A0
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function getid(name)
{
	tableid = getteamopstableid();
	for(row = 1; row < 256; row++)
	{
		_name = tablelookupcolumnforrow(tableid, row, 0);
		if(name == _name)
		{
			return row;
		}
	}
	return 0;
}

/*
	Name: teamopsallowed
	Namespace: teamops
	Checksum: 0xFEEFF9D9
	Offset: 0x838
	Size: 0xA6
	Parameters: 1
	Flags: Linked
*/
function teamopsallowed(name)
{
	teamops = game["teamops"].data[name];
	if(teamops.modes.size == 0)
	{
		return true;
	}
	for(mi = 0; mi < teamops.modes.size; mi++)
	{
		if(teamops.modes[mi] == level.gametype)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: startteamops
	Namespace: teamops
	Checksum: 0xE7E88403
	Offset: 0x8E8
	Size: 0x3BC
	Parameters: 1
	Flags: Linked
*/
function startteamops(name)
{
	level notify(#"teamops_starting");
	level.teamopsonplayerkilled = undefined;
	if(!teamopsallowed(name))
	{
		return;
	}
	teamopsshowhud(0);
	preanouncetime = getdvarint("teamOpsPreanounceTime", 5);
	foreach(team in level.teams)
	{
		globallogic_audio::leader_dialog("teamops_preannounce", team);
	}
	wait(preanouncetime);
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(isdefined(player))
		{
			player playlocalsound("uin_objective_updated");
		}
	}
	teamops = game["teamops"].data[name];
	game["teamops"].teamopsname = name;
	game["teamops"].teamopsid = getid(name);
	game["teamops"].teamopsrewardindex = randomintrange(0, teamops.rewards.size);
	game["teamops"].teamopsreward = teamops.rewards[game["teamops"].teamopsrewardindex];
	game["teamops"].teamopsstarttime = gettime();
	foreach(team in level.teams)
	{
		game["teamops"].teamprogress[team] = 0;
	}
	wait(0.1);
	teamopsstart(game["teamops"].teamopsid, game["teamops"].teamopsrewardindex, game["teamops"].teamopsstarttime, teamops.time);
	wait(0.1);
	teamopsshowhud(1);
	teamopsupdateprogress("axis", 0);
	teamopsupdateprogress("allies", 0);
	level thread teamopswatcher();
}

/*
	Name: teamopswatcher
	Namespace: teamops
	Checksum: 0x7076C147
	Offset: 0xCB0
	Size: 0x158
	Parameters: 0
	Flags: Linked
*/
function teamopswatcher()
{
	while(isdefined(game["teamops"].teamopsname))
	{
		time = game["teamops"].data[game["teamops"].teamopsname].time;
		if(isdefined(time) && time > 0)
		{
			elapsed = gettime() - game["teamops"].teamopsstarttime;
			if(elapsed > (time * 1000))
			{
				stopteamops();
				foreach(team in level.teams)
				{
					globallogic_audio::leader_dialog("teamops_timeout", team);
				}
			}
		}
		wait(0.5);
	}
}

/*
	Name: stopteamops
	Namespace: teamops
	Checksum: 0x5A380DC
	Offset: 0xE10
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function stopteamops()
{
	teamopsshowhud(0);
	game["teamops"].teamopsname = undefined;
	game["teamops"].teamopsreward = undefined;
	game["teamops"].teamopsstarttime = undefined;
	foreach(team in level.teams)
	{
		game["teamops"].teamprogress[team] = 0;
	}
}

/*
	Name: processplayerevent
	Namespace: teamops
	Checksum: 0x4E480130
	Offset: 0xF00
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function processplayerevent(event, player)
{
	teamopsname = game["teamops"].teamopsname;
	if(isplayer(player) && isdefined(teamopsname))
	{
		level processteamevent(event, player, player.team);
	}
}

/*
	Name: processteamevent
	Namespace: teamops
	Checksum: 0x42BB0005
	Offset: 0xF90
	Size: 0x214
	Parameters: 3
	Flags: Linked
*/
function processteamevent(event, player, team)
{
	teamopsname = game["teamops"].teamopsname;
	teamops = game["teamops"].data[teamopsname];
	if(isdefined(teamops.pushevent) && event == teamops.pushevent)
	{
		game["teamops"].teamprogress[team] = game["teamops"].teamprogress[team] + 1;
		level updateteamops(event, player, team);
	}
	if(isdefined(teamops.popevent) && event == teamops.popevent)
	{
		game["teamops"].teamprogress[team] = game["teamops"].teamprogress[team] - 1;
		if(game["teamops"].teamprogress[team] < 0)
		{
			game["teamops"].teamprogress[team] = 0;
		}
		level updateteamops(event, player, team);
	}
	if(isdefined(teamops.resetevent) && event == teamops.resetevent)
	{
		game["teamops"].teamprogress[team] = 0;
		level updateteamops(event, player, team);
	}
}

/*
	Name: updateteamops
	Namespace: teamops
	Checksum: 0x48CD8F19
	Offset: 0x11B0
	Size: 0x12C
	Parameters: 3
	Flags: Linked
*/
function updateteamops(event, player, team)
{
	teamopsname = game["teamops"].teamopsname;
	teamops = game["teamops"].data[teamopsname];
	count_target = teamops.count;
	progress = int((100 * game["teamops"].teamprogress[team]) / count_target);
	teamopsupdateprogress(team, progress);
	if(game["teamops"].teamprogress[team] >= teamops.count)
	{
		if(isdefined(player))
		{
			level thread teamopsacheived(player, team);
		}
	}
}

/*
	Name: teamopsacheived
	Namespace: teamops
	Checksum: 0x387FC9F5
	Offset: 0x12E8
	Size: 0xE4
	Parameters: 2
	Flags: Linked
*/
function teamopsacheived(player, team)
{
	game["teamops"].teamopsname = undefined;
	wait(0.5);
	teamopsshowhud(0);
	wait(2);
	globallogic_audio::leader_dialog("teamops_win", team);
	globallogic_audio::leader_dialog_for_other_teams("teamops_lose", team);
	player killstreaks::give(game["teamops"].teamopsreward, 1);
	wait(2);
	player killstreaks::usekillstreak(game["teamops"].teamopsreward, 1);
}

/*
	Name: main
	Namespace: teamops
	Checksum: 0x70B72ADE
	Offset: 0x13D8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	thread watchteamopstime();
	level.teamopstargetkills = getdvarint("teamOpsKillsCountTrigger_" + level.gametype, 37);
	if(level.teamopstargetkills > 0)
	{
		level.teamopsonplayerkilled = &onplayerkilled;
	}
}

/*
	Name: getcompatibleoperation
	Namespace: teamops
	Checksum: 0x8EBD6507
	Offset: 0x1450
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function getcompatibleoperation()
{
	operations = strtok(getdvarstring("teamOpsName"), ",");
	for(i = 0; i < 20; i++)
	{
		operation = operations[randomintrange(0, operations.size)];
		if(teamopsallowed(operation))
		{
			return operation;
		}
	}
	for(i = 0; i < operations.size; i++)
	{
		operation = operations[i];
		if(teamopsallowed(operation))
		{
			return operation;
		}
	}
	return undefined;
}

/*
	Name: watchteamopstime
	Namespace: teamops
	Checksum: 0x577855D9
	Offset: 0x1560
	Size: 0x162
	Parameters: 0
	Flags: Linked
*/
function watchteamopstime()
{
	level endon(#"teamops_starting");
	if(isdefined(level.inprematchperiod) && level.inprematchperiod)
	{
		level waittill(#"prematch_over");
	}
	activeteamops = getcompatibleoperation();
	if(!isdefined(activeteamops))
	{
		return;
	}
	startdelay = getdvarint("teamOpsStartDelay_" + level.gametype, 300);
	while(true)
	{
		if(isdefined(game["teamops"].teamopsname))
		{
			if(getdvarint("scr_stop_teamops") == 1)
			{
				stopteamops();
				setdvar("scr_stop_teamops", 0);
			}
		}
		timepassed = globallogic_utils::gettimepassed() / 1000;
		startteamops = 0;
		if(timepassed > startdelay)
		{
			level thread startteamops(activeteamops);
			break;
		}
		wait(1);
	}
}

/*
	Name: onplayerkilled
	Namespace: teamops
	Checksum: 0xB32ABD91
	Offset: 0x16D0
	Size: 0x15C
	Parameters: 9
	Flags: Linked
*/
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	level endon(#"teamops_starting");
	if(isplayer(attacker) == 0 || attacker.team == self.team)
	{
		return;
	}
	if(!isdefined(level.teamopskilltracker))
	{
		level.teamopskilltracker = [];
	}
	if(!isdefined(level.teamopskilltracker[attacker.team]))
	{
		level.teamopskilltracker[attacker.team] = 0;
	}
	level.teamopskilltracker[attacker.team]++;
	if(level.teamopskilltracker[attacker.team] >= level.teamopstargetkills)
	{
		activeteamops = getcompatibleoperation();
		if(!isdefined(activeteamops))
		{
			return;
		}
		level thread startteamops(activeteamops);
	}
}

