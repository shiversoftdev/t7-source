// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_spawn;
#using scripts\mp\gametypes\_spectating;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\killcam_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_tacticalinsertion;

#namespace killcam;

/*
	Name: __init__sytem__
	Namespace: killcam
	Checksum: 0x5BE83AC7
	Offset: 0x4F0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("killcam", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: killcam
	Checksum: 0x3A195C76
	Offset: 0x530
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
	clientfield::register("clientuimodel", "hudItems.killcamAllowRespawn", 1, 1, "int");
}

/*
	Name: init
	Namespace: killcam
	Checksum: 0x3666793F
	Offset: 0x590
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.killcam = getgametypesetting("allowKillcam");
	level.finalkillcam = getgametypesetting("allowFinalKillcam");
	init_final_killcam();
}

/*
	Name: init_final_killcam
	Namespace: killcam
	Checksum: 0xD2995684
	Offset: 0x5F0
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function init_final_killcam()
{
	level.finalkillcamsettings = [];
	init_final_killcam_team("none");
	foreach(team in level.teams)
	{
		init_final_killcam_team(team);
	}
	level.finalkillcam_winner = undefined;
	level.finalkillcam_winnerpicked = undefined;
}

/*
	Name: init_final_killcam_team
	Namespace: killcam
	Checksum: 0x355FBA82
	Offset: 0x6C0
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function init_final_killcam_team(team)
{
	level.finalkillcamsettings[team] = spawnstruct();
	clear_final_killcam_team(team);
}

/*
	Name: clear_final_killcam_team
	Namespace: killcam
	Checksum: 0x388B6173
	Offset: 0x710
	Size: 0x112
	Parameters: 1
	Flags: Linked
*/
function clear_final_killcam_team(team)
{
	level.finalkillcamsettings[team].spectatorclient = undefined;
	level.finalkillcamsettings[team].weapon = undefined;
	level.finalkillcamsettings[team].meansofdeath = undefined;
	level.finalkillcamsettings[team].deathtime = undefined;
	level.finalkillcamsettings[team].deathtimeoffset = undefined;
	level.finalkillcamsettings[team].offsettime = undefined;
	level.finalkillcamsettings[team].killcam_entity_info = undefined;
	level.finalkillcamsettings[team].targetentityindex = undefined;
	level.finalkillcamsettings[team].perks = undefined;
	level.finalkillcamsettings[team].killstreaks = undefined;
	level.finalkillcamsettings[team].attacker = undefined;
}

/*
	Name: record_settings
	Namespace: killcam
	Checksum: 0x512C60F4
	Offset: 0x830
	Size: 0x344
	Parameters: 11
	Flags: Linked
*/
function record_settings(spectatorclient, targetentityindex, weapon, meansofdeath, deathtime, deathtimeoffset, offsettime, killcam_entity_info, perks, killstreaks, attacker)
{
	if(isdefined(attacker) && isdefined(attacker.team) && isdefined(level.teams[attacker.team]))
	{
		team = attacker.team;
		level.finalkillcamsettings[team].spectatorclient = spectatorclient;
		level.finalkillcamsettings[team].weapon = weapon;
		level.finalkillcamsettings[team].meansofdeath = meansofdeath;
		level.finalkillcamsettings[team].deathtime = deathtime;
		level.finalkillcamsettings[team].deathtimeoffset = deathtimeoffset;
		level.finalkillcamsettings[team].offsettime = offsettime;
		level.finalkillcamsettings[team].killcam_entity_info = killcam_entity_info;
		level.finalkillcamsettings[team].targetentityindex = targetentityindex;
		level.finalkillcamsettings[team].perks = perks;
		level.finalkillcamsettings[team].killstreaks = killstreaks;
		level.finalkillcamsettings[team].attacker = attacker;
	}
	level.finalkillcamsettings["none"].spectatorclient = spectatorclient;
	level.finalkillcamsettings["none"].weapon = weapon;
	level.finalkillcamsettings["none"].meansofdeath = meansofdeath;
	level.finalkillcamsettings["none"].deathtime = deathtime;
	level.finalkillcamsettings["none"].deathtimeoffset = deathtimeoffset;
	level.finalkillcamsettings["none"].offsettime = offsettime;
	level.finalkillcamsettings["none"].killcam_entity_info = killcam_entity_info;
	level.finalkillcamsettings["none"].targetentityindex = targetentityindex;
	level.finalkillcamsettings["none"].perks = perks;
	level.finalkillcamsettings["none"].killstreaks = killstreaks;
	level.finalkillcamsettings["none"].attacker = attacker;
}

/*
	Name: erase_final_killcam
	Namespace: killcam
	Checksum: 0x62E20270
	Offset: 0xB80
	Size: 0xB2
	Parameters: 0
	Flags: None
*/
function erase_final_killcam()
{
	clear_final_killcam_team("none");
	foreach(team in level.teams)
	{
		clear_final_killcam_team(team);
	}
	level.finalkillcam_winner = undefined;
	level.finalkillcam_winnerpicked = undefined;
}

/*
	Name: final_killcam_waiter
	Namespace: killcam
	Checksum: 0xA0394982
	Offset: 0xC40
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function final_killcam_waiter()
{
	if(level.finalkillcam_winnerpicked === 1)
	{
		level waittill(#"final_killcam_done");
	}
}

/*
	Name: post_round_final_killcam
	Namespace: killcam
	Checksum: 0x69A05795
	Offset: 0xC68
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function post_round_final_killcam()
{
	if(isdefined(level.sidebet) && level.sidebet)
	{
		return;
	}
	level notify(#"play_final_killcam");
	globallogic::resetoutcomeforallplayers();
	final_killcam_waiter();
}

/*
	Name: do_final_killcam
	Namespace: killcam
	Checksum: 0xB592C350
	Offset: 0xCC0
	Size: 0x25C
	Parameters: 0
	Flags: Linked
*/
function do_final_killcam()
{
	level waittill(#"play_final_killcam");
	luinotifyevent(&"pre_killcam_transition");
	wait(0.35);
	level.infinalkillcam = 1;
	winner = "none";
	if(isdefined(level.finalkillcam_winner))
	{
		winner = level.finalkillcam_winner;
	}
	winning_team = globallogic::figureoutwinningteam(winner);
	if(!isdefined(level.finalkillcamsettings[winning_team].targetentityindex))
	{
		level.infinalkillcam = 0;
		level notify(#"final_killcam_done");
		return;
	}
	attacker = level.finalkillcamsettings[winning_team].attacker;
	if(isdefined(attacker) && isdefined(attacker.archetype) && attacker.archetype == "mannequin")
	{
		level.infinalkillcam = 0;
		level notify(#"final_killcam_done");
		return;
	}
	if(isdefined(attacker))
	{
		challenges::getfinalkill(attacker);
	}
	visionsetnaked(getdvarstring("mapname"), 0);
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		player closeingamemenu();
		player thread final_killcam(winner);
	}
	wait(0.1);
	while(are_any_players_watching())
	{
		wait(0.05);
	}
	level notify(#"final_killcam_done");
	level.infinalkillcam = 0;
}

/*
	Name: startlastkillcam
	Namespace: killcam
	Checksum: 0x99EC1590
	Offset: 0xF28
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function startlastkillcam()
{
}

/*
	Name: are_any_players_watching
	Namespace: killcam
	Checksum: 0xCDC36A84
	Offset: 0xF38
	Size: 0x76
	Parameters: 0
	Flags: Linked
*/
function are_any_players_watching()
{
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		if(isdefined(player.killcam))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: watch_for_skip_killcam
	Namespace: killcam
	Checksum: 0xF9282DB3
	Offset: 0xFB8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function watch_for_skip_killcam()
{
	self endon(#"begin_killcam");
	self util::waittill_any("disconnect", "spawned");
	wait(0.05);
	level.numplayerswaitingtoenterkillcam--;
}

/*
	Name: killcam
	Namespace: killcam
	Checksum: 0xE68895CB
	Offset: 0x1008
	Size: 0x68C
	Parameters: 14
	Flags: Linked
*/
function killcam(attackernum, targetnum, killcam_entity_info, weapon, meansofdeath, deathtime, deathtimeoffset, offsettime, respawn, maxtime, perks, killstreaks, attacker, keep_deathcam)
{
	self endon(#"disconnect");
	self endon(#"spawned");
	level endon(#"game_ended");
	if(attackernum < 0)
	{
		return;
	}
	self thread watch_for_skip_killcam();
	level.numplayerswaitingtoenterkillcam++;
	/#
		assert(level.numplayerswaitingtoenterkillcam < 20);
	#/
	if(level.numplayerswaitingtoenterkillcam > 1)
	{
		/#
			println("");
		#/
		wait(0.05 * (level.numplayerswaitingtoenterkillcam - 1));
	}
	wait(0.05);
	level.numplayerswaitingtoenterkillcam--;
	/#
		assert(level.numplayerswaitingtoenterkillcam > -1);
	#/
	postdeathdelay = (gettime() - deathtime) / 1000;
	predelay = postdeathdelay + deathtimeoffset;
	killcamentitystarttime = get_killcam_entity_info_starttime(killcam_entity_info);
	camtime = calc_time(weapon, killcamentitystarttime, predelay, respawn, maxtime);
	postdelay = calc_post_delay();
	killcamlength = camtime + postdelay;
	if(isdefined(maxtime) && killcamlength > maxtime)
	{
		if(maxtime < 2)
		{
			return;
		}
		if((maxtime - camtime) >= 1)
		{
			postdelay = maxtime - camtime;
		}
		else
		{
			postdelay = 1;
			camtime = maxtime - 1;
		}
		killcamlength = camtime + postdelay;
	}
	killcamoffset = camtime + predelay;
	self notify(#"begin_killcam", gettime());
	self util::clientnotify("sndDEDe");
	killcamstarttime = gettime() - (killcamoffset * 1000);
	self.sessionstate = "spectator";
	self.spectatekillcam = 1;
	self.spectatorclient = attackernum;
	self.killcamentity = -1;
	self thread set_killcam_entities(killcam_entity_info, killcamstarttime);
	self.killcamtargetentity = targetnum;
	self.killcamweapon = weapon;
	self.killcammod = meansofdeath;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = offsettime;
	foreach(team in level.teams)
	{
		self allowspectateteam(team, 1);
	}
	self allowspectateteam("freelook", 1);
	self allowspectateteam("none", 1);
	self thread ended_killcam_cleanup();
	wait(0.05);
	if(self.archivetime <= predelay)
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self.spectatekillcam = 0;
		self notify(#"end_killcam");
		return;
	}
	self thread check_for_abrupt_end();
	self.killcam = 1;
	self add_skip_text(respawn);
	if(!self issplitscreen() && level.perksenabled == 1)
	{
		self add_timer(camtime);
		self hud::showperks();
	}
	self thread spawned_killcam_cleanup();
	self thread wait_skip_killcam_button();
	self thread wait_team_change_end_killcam();
	self thread wait_killcam_time();
	self thread tacticalinsertion::cancel_button_think();
	self waittill(#"end_killcam");
	self end(0);
	if(isdefined(keep_deathcam) && keep_deathcam)
	{
		return;
	}
	self.sessionstate = "dead";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.spectatekillcam = 0;
}

/*
	Name: set_entity
	Namespace: killcam
	Checksum: 0xB8F502A6
	Offset: 0x16A0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function set_entity(killcamentityindex, delayms)
{
	self endon(#"disconnect");
	self endon(#"end_killcam");
	self endon(#"spawned");
	if(delayms > 0)
	{
		wait(delayms / 1000);
	}
	self.killcamentity = killcamentityindex;
}

/*
	Name: set_killcam_entities
	Namespace: killcam
	Checksum: 0xD1B240AB
	Offset: 0x1708
	Size: 0xAC
	Parameters: 2
	Flags: Linked
*/
function set_killcam_entities(entity_info, killcamstarttime)
{
	for(index = 0; index < entity_info.entity_indexes.size; index++)
	{
		delayms = (entity_info.entity_spawntimes[index] - killcamstarttime) - 100;
		thread set_entity(entity_info.entity_indexes[index], delayms);
		if(delayms <= 0)
		{
			return;
		}
	}
}

/*
	Name: wait_killcam_time
	Namespace: killcam
	Checksum: 0x6B524243
	Offset: 0x17C0
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function wait_killcam_time()
{
	self endon(#"disconnect");
	self endon(#"end_killcam");
	wait(self.killcamlength - 0.05);
	self notify(#"end_killcam");
}

/*
	Name: wait_final_killcam_slowdown
	Namespace: killcam
	Checksum: 0xD3AEAE4C
	Offset: 0x1808
	Size: 0x124
	Parameters: 2
	Flags: Linked
*/
function wait_final_killcam_slowdown(deathtime, starttime)
{
	self endon(#"disconnect");
	self endon(#"end_killcam");
	if(isdefined(level.var_fb8e299e) && level.var_fb8e299e)
	{
		return;
	}
	secondsuntildeath = (deathtime - starttime) / 1000;
	deathtime = gettime() + (secondsuntildeath * 1000);
	waitbeforedeath = 2;
	wait(max(0, secondsuntildeath - waitbeforedeath));
	util::setclientsysstate("levelNotify", "sndFKsl");
	setslowmotion(1, 0.25, waitbeforedeath);
	wait(waitbeforedeath + 0.5);
	setslowmotion(0.25, 1, 1);
	wait(0.5);
}

/*
	Name: wait_skip_killcam_button
	Namespace: killcam
	Checksum: 0xC6D64FB5
	Offset: 0x1938
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function wait_skip_killcam_button()
{
	self endon(#"disconnect");
	self endon(#"end_killcam");
	while(self usebuttonpressed())
	{
		wait(0.05);
	}
	while(!self usebuttonpressed())
	{
		wait(0.05);
	}
	if(isdefined(self.killcamsskipped))
	{
		self.killcamsskipped++;
	}
	else
	{
		self.killcamsskipped = 1;
	}
	self notify(#"end_killcam");
	self util::clientnotify("fkce");
}

/*
	Name: wait_team_change_end_killcam
	Namespace: killcam
	Checksum: 0x6CD927FB
	Offset: 0x19F8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function wait_team_change_end_killcam()
{
	self endon(#"disconnect");
	self endon(#"end_killcam");
	self waittill(#"changed_class");
	end(0);
}

/*
	Name: wait_skip_killcam_safe_spawn_button
	Namespace: killcam
	Checksum: 0xC2A33F18
	Offset: 0x1A40
	Size: 0x7E
	Parameters: 0
	Flags: None
*/
function wait_skip_killcam_safe_spawn_button()
{
	self endon(#"disconnect");
	self endon(#"end_killcam");
	while(self fragbuttonpressed())
	{
		wait(0.05);
	}
	while(!self fragbuttonpressed())
	{
		wait(0.05);
	}
	self.wantsafespawn = 1;
	self notify(#"end_killcam");
}

/*
	Name: end
	Namespace: killcam
	Checksum: 0x90110CF2
	Offset: 0x1AC8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function end(final)
{
	if(isdefined(self.kc_skiptext))
	{
		self.kc_skiptext.alpha = 0;
	}
	if(isdefined(self.kc_timer))
	{
		self.kc_timer.alpha = 0;
	}
	self.killcam = undefined;
	self thread spectating::set_permissions();
}

/*
	Name: check_for_abrupt_end
	Namespace: killcam
	Checksum: 0x9814C69D
	Offset: 0x1B40
	Size: 0x52
	Parameters: 0
	Flags: Linked
*/
function check_for_abrupt_end()
{
	self endon(#"disconnect");
	self endon(#"end_killcam");
	while(true)
	{
		if(self.archivetime <= 0)
		{
			break;
		}
		wait(0.05);
	}
	self notify(#"end_killcam");
}

/*
	Name: spawned_killcam_cleanup
	Namespace: killcam
	Checksum: 0x6B24D169
	Offset: 0x1BA0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function spawned_killcam_cleanup()
{
	self endon(#"end_killcam");
	self endon(#"disconnect");
	self waittill(#"spawned");
	self end(0);
}

/*
	Name: spectator_killcam_cleanup
	Namespace: killcam
	Checksum: 0x829A3
	Offset: 0x1BE8
	Size: 0x9C
	Parameters: 1
	Flags: None
*/
function spectator_killcam_cleanup(attacker)
{
	self endon(#"end_killcam");
	self endon(#"disconnect");
	attacker endon(#"disconnect");
	attacker waittill(#"begin_killcam", attackerkcstarttime);
	waittime = max(0, (attackerkcstarttime - self.deathtime) - 50);
	wait(waittime);
	self end(0);
}

/*
	Name: ended_killcam_cleanup
	Namespace: killcam
	Checksum: 0xDE81B980
	Offset: 0x1C90
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function ended_killcam_cleanup()
{
	self endon(#"end_killcam");
	self endon(#"disconnect");
	level waittill(#"game_ended");
	self end(0);
	self [[level.spawnintermission]](0);
}

/*
	Name: ended_final_killcam_cleanup
	Namespace: killcam
	Checksum: 0x1C268D7A
	Offset: 0x1CE8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function ended_final_killcam_cleanup()
{
	self endon(#"end_killcam");
	self endon(#"disconnect");
	level waittill(#"game_ended");
	self end(1);
}

/*
	Name: cancel_use_button
	Namespace: killcam
	Checksum: 0x439F6BA4
	Offset: 0x1D38
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function cancel_use_button()
{
	return self usebuttonpressed();
}

/*
	Name: cancel_safe_spawn_button
	Namespace: killcam
	Checksum: 0x2AABC237
	Offset: 0x1D60
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function cancel_safe_spawn_button()
{
	return self fragbuttonpressed();
}

/*
	Name: cancel_callback
	Namespace: killcam
	Checksum: 0x87CD6E4C
	Offset: 0x1D88
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function cancel_callback()
{
	self.cancelkillcam = 1;
}

/*
	Name: cancel_safe_spawn_callback
	Namespace: killcam
	Checksum: 0x73E8DC44
	Offset: 0x1DA0
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function cancel_safe_spawn_callback()
{
	self.cancelkillcam = 1;
	self.wantsafespawn = 1;
}

/*
	Name: cancel_on_use
	Namespace: killcam
	Checksum: 0x70023B43
	Offset: 0x1DC8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function cancel_on_use()
{
	self thread cancel_on_use_specific_button(&cancel_use_button, &cancel_callback);
}

/*
	Name: cancel_on_use_specific_button
	Namespace: killcam
	Checksum: 0x138B70FE
	Offset: 0x1E08
	Size: 0x11C
	Parameters: 2
	Flags: Linked
*/
function cancel_on_use_specific_button(pressingbuttonfunc, finishedfunc)
{
	self endon(#"death_delay_finished");
	self endon(#"disconnect");
	level endon(#"game_ended");
	for(;;)
	{
		if(!self [[pressingbuttonfunc]]())
		{
			wait(0.05);
			continue;
		}
		buttontime = 0;
		while(self [[pressingbuttonfunc]]())
		{
			buttontime = buttontime + 0.05;
			wait(0.05);
		}
		if(buttontime >= 0.5)
		{
			continue;
		}
		buttontime = 0;
		while(!self [[pressingbuttonfunc]]() && buttontime < 0.5)
		{
			buttontime = buttontime + 0.05;
			wait(0.05);
		}
		if(buttontime >= 0.5)
		{
			continue;
		}
		self [[finishedfunc]]();
		return;
	}
}

/*
	Name: final_killcam_internal
	Namespace: killcam
	Checksum: 0xE551E0A2
	Offset: 0x1F30
	Size: 0x470
	Parameters: 1
	Flags: Linked
*/
function final_killcam_internal(winner)
{
	winning_team = globallogic::figureoutwinningteam(winner);
	killcamsettings = level.finalkillcamsettings[winning_team];
	postdeathdelay = (gettime() - killcamsettings.deathtime) / 1000;
	predelay = postdeathdelay + killcamsettings.deathtimeoffset;
	killcamentitystarttime = get_killcam_entity_info_starttime(killcamsettings.killcam_entity_info);
	camtime = calc_time(killcamsettings.weapon, killcamentitystarttime, predelay, 0, undefined);
	postdelay = calc_post_delay();
	killcamoffset = camtime + predelay;
	killcamlength = (camtime + postdelay) - 0.05;
	killcamstarttime = gettime() - (killcamoffset * 1000);
	self notify(#"begin_killcam", gettime());
	util::setclientsysstate("levelNotify", "sndFKs");
	self.sessionstate = "spectator";
	self.spectatorclient = killcamsettings.spectatorclient;
	self.killcamentity = -1;
	self thread set_killcam_entities(killcamsettings.killcam_entity_info, killcamstarttime);
	self.killcamtargetentity = killcamsettings.targetentityindex;
	self.killcamweapon = killcamsettings.weapon;
	self.killcammod = killcamsettings.meansofdeath;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = killcamsettings.offsettime;
	foreach(team in level.teams)
	{
		self allowspectateteam(team, 1);
	}
	self allowspectateteam("freelook", 1);
	self allowspectateteam("none", 1);
	self thread ended_final_killcam_cleanup();
	wait(0.05);
	if(!util::isprophuntgametype() && self.archivetime <= predelay)
	{
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self.spectatekillcam = 0;
		self notify(#"end_killcam");
		return;
	}
	self thread check_for_abrupt_end();
	self.killcam = 1;
	if(!self issplitscreen())
	{
		self add_timer(camtime);
	}
	self thread wait_killcam_time();
	self thread wait_final_killcam_slowdown(level.finalkillcamsettings[winning_team].deathtime, killcamstarttime);
	self waittill(#"end_killcam");
}

/*
	Name: final_killcam
	Namespace: killcam
	Checksum: 0x80881B92
	Offset: 0x23A8
	Size: 0x254
	Parameters: 1
	Flags: Linked
*/
function final_killcam(winner)
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	if(util::waslastround())
	{
		setmatchflag("final_killcam", 1);
		setmatchflag("round_end_killcam", 0);
	}
	else
	{
		setmatchflag("final_killcam", 0);
		setmatchflag("round_end_killcam", 1);
	}
	/#
		if(getdvarint("") == 1)
		{
			setmatchflag("", 1);
			setmatchflag("", 0);
		}
	#/
	if(!util::isprophuntgametype() && level.console)
	{
		self globallogic_spawn::setthirdperson(0);
	}
	/#
		while(getdvarint("") == 1)
		{
			final_killcam_internal(winner);
		}
	#/
	final_killcam_internal(winner);
	util::setclientsysstate("levelNotify", "sndFKe");
	luinotifyevent(&"post_killcam_transition");
	self freezecontrols(1);
	wait(1.5);
	self end(1);
	setmatchflag("final_killcam", 0);
	setmatchflag("round_end_killcam", 0);
	self spawn_end_of_final_killcam();
}

/*
	Name: spawn_end_of_final_killcam
	Namespace: killcam
	Checksum: 0xC5845BC7
	Offset: 0x2608
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function spawn_end_of_final_killcam()
{
	[[level.spawnspectator]]();
	self freezecontrols(1);
	self visionset_mgr::player_shutdown();
}

/*
	Name: is_entity_weapon
	Namespace: killcam
	Checksum: 0xB2C1DCB3
	Offset: 0x2658
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function is_entity_weapon(weapon)
{
	if(weapon.name == "planemortar")
	{
		return true;
	}
	return false;
}

/*
	Name: calc_time
	Namespace: killcam
	Checksum: 0x66CEF2CF
	Offset: 0x2690
	Size: 0x154
	Parameters: 5
	Flags: Linked
*/
function calc_time(weapon, entitystarttime, predelay, respawn, maxtime)
{
	camtime = 0;
	if(getdvarstring("scr_killcam_time") == "")
	{
		if(is_entity_weapon(weapon))
		{
			camtime = (((gettime() - entitystarttime) / 1000) - predelay) - 0.1;
		}
		else
		{
			if(!respawn)
			{
				camtime = 5;
			}
			else
			{
				if(weapon.isgrenadeweapon)
				{
					camtime = 4.25;
				}
				else
				{
					camtime = 2.5;
				}
			}
		}
	}
	else
	{
		camtime = getdvarfloat("scr_killcam_time");
	}
	if(isdefined(maxtime))
	{
		if(camtime > maxtime)
		{
			camtime = maxtime;
		}
		if(camtime < 0.05)
		{
			camtime = 0.05;
		}
	}
	return camtime;
}

/*
	Name: calc_post_delay
	Namespace: killcam
	Checksum: 0x960FAC8C
	Offset: 0x27F0
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function calc_post_delay()
{
	postdelay = 0;
	if(getdvarstring("scr_killcam_posttime") == "")
	{
		postdelay = 2;
	}
	else
	{
		postdelay = getdvarfloat("scr_killcam_posttime");
		if(postdelay < 0.05)
		{
			postdelay = 0.05;
		}
	}
	return postdelay;
}

/*
	Name: add_skip_text
	Namespace: killcam
	Checksum: 0x7666F597
	Offset: 0x2878
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function add_skip_text(respawn)
{
	self clientfield::set_player_uimodel("hudItems.killcamAllowRespawn", respawn);
}

/*
	Name: add_timer
	Namespace: killcam
	Checksum: 0x393D0282
	Offset: 0x28B0
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function add_timer(camtime)
{
}

/*
	Name: init_kc_elements
	Namespace: killcam
	Checksum: 0xA8124B2F
	Offset: 0x28C8
	Size: 0x550
	Parameters: 0
	Flags: None
*/
function init_kc_elements()
{
	if(!isdefined(self.kc_skiptext))
	{
		self.kc_skiptext = newclienthudelem(self);
		self.kc_skiptext.archived = 0;
		self.kc_skiptext.x = 0;
		self.kc_skiptext.alignx = "center";
		self.kc_skiptext.aligny = "top";
		self.kc_skiptext.horzalign = "center_adjustable";
		self.kc_skiptext.vertalign = "top_adjustable";
		self.kc_skiptext.sort = 1;
		self.kc_skiptext.font = "default";
		self.kc_skiptext.foreground = 1;
		self.kc_skiptext.hidewheninmenu = 1;
		if(self issplitscreen())
		{
			self.kc_skiptext.y = 20;
			self.kc_skiptext.fontscale = 1.2;
		}
		else
		{
			self.kc_skiptext.y = 32;
			self.kc_skiptext.fontscale = 1.8;
		}
	}
	if(!isdefined(self.kc_othertext))
	{
		self.kc_othertext = newclienthudelem(self);
		self.kc_othertext.archived = 0;
		self.kc_othertext.y = 48;
		self.kc_othertext.alignx = "left";
		self.kc_othertext.aligny = "top";
		self.kc_othertext.horzalign = "center";
		self.kc_othertext.vertalign = "middle";
		self.kc_othertext.sort = 10;
		self.kc_othertext.font = "small";
		self.kc_othertext.foreground = 1;
		self.kc_othertext.hidewheninmenu = 1;
		if(self issplitscreen())
		{
			self.kc_othertext.x = 16;
			self.kc_othertext.fontscale = 1.2;
		}
		else
		{
			self.kc_othertext.x = 32;
			self.kc_othertext.fontscale = 1.6;
		}
	}
	if(!isdefined(self.kc_icon))
	{
		self.kc_icon = newclienthudelem(self);
		self.kc_icon.archived = 0;
		self.kc_icon.x = 16;
		self.kc_icon.y = 16;
		self.kc_icon.alignx = "left";
		self.kc_icon.aligny = "top";
		self.kc_icon.horzalign = "center";
		self.kc_icon.vertalign = "middle";
		self.kc_icon.sort = 1;
		self.kc_icon.foreground = 1;
		self.kc_icon.hidewheninmenu = 1;
	}
	if(!self issplitscreen())
	{
		if(!isdefined(self.kc_timer))
		{
			self.kc_timer = hud::createfontstring("hudbig", 1);
			self.kc_timer.archived = 0;
			self.kc_timer.x = 0;
			self.kc_timer.alignx = "center";
			self.kc_timer.aligny = "middle";
			self.kc_timer.horzalign = "center_safearea";
			self.kc_timer.vertalign = "top_adjustable";
			self.kc_timer.y = 42;
			self.kc_timer.sort = 1;
			self.kc_timer.font = "hudbig";
			self.kc_timer.foreground = 1;
			self.kc_timer.color = vectorscale((1, 1, 1), 0.85);
			self.kc_timer.hidewheninmenu = 1;
		}
	}
}

/*
	Name: get_closest_killcam_entity
	Namespace: killcam
	Checksum: 0x7C8359A2
	Offset: 0x2E20
	Size: 0x220
	Parameters: 3
	Flags: Linked
*/
function get_closest_killcam_entity(attacker, killcamentities, depth = 0)
{
	closestkillcament = undefined;
	closestkillcamentindex = undefined;
	closestkillcamentdist = undefined;
	origin = undefined;
	foreach(killcamentindex, killcament in killcamentities)
	{
		if(killcament == attacker)
		{
			continue;
		}
		origin = killcament.origin;
		if(isdefined(killcament.offsetpoint))
		{
			origin = origin + killcament.offsetpoint;
		}
		dist = distancesquared(self.origin, origin);
		if(!isdefined(closestkillcament) || dist < closestkillcamentdist)
		{
			closestkillcament = killcament;
			closestkillcamentdist = dist;
			closestkillcamentindex = killcamentindex;
		}
	}
	if(depth < 3 && isdefined(closestkillcament))
	{
		if(!bullettracepassed(closestkillcament.origin, self.origin, 0, self))
		{
			killcamentities[closestkillcamentindex] = undefined;
			betterkillcament = get_closest_killcam_entity(attacker, killcamentities, depth + 1);
			if(isdefined(betterkillcament))
			{
				closestkillcament = betterkillcament;
			}
		}
	}
	return closestkillcament;
}

/*
	Name: get_killcam_entity
	Namespace: killcam
	Checksum: 0x18C1A0C0
	Offset: 0x3048
	Size: 0x2E0
	Parameters: 3
	Flags: Linked
*/
function get_killcam_entity(attacker, einflictor, weapon)
{
	if(!isdefined(einflictor))
	{
		return undefined;
	}
	if(isdefined(self.killcamkilledbyent))
	{
		return self.killcamkilledbyent;
	}
	if(einflictor == attacker)
	{
		if(!isdefined(einflictor.ismagicbullet))
		{
			return undefined;
		}
		if(isdefined(einflictor.ismagicbullet) && !einflictor.ismagicbullet)
		{
			return undefined;
		}
	}
	else if(isdefined(level.levelspecifickillcam))
	{
		levelspecifickillcament = self [[level.levelspecifickillcam]]();
		if(isdefined(levelspecifickillcament))
		{
			return levelspecifickillcament;
		}
	}
	if(weapon.name == "hero_gravityspikes")
	{
		return undefined;
	}
	if(isdefined(attacker) && isplayer(attacker) && attacker isremotecontrolling() && (einflictor.controlled === 1 || einflictor.occupied === 1))
	{
		if(weapon.name == "sentinel_turret" || weapon.name == "helicopter_gunner_turret_primary" || weapon.name == "helicopter_gunner_turret_secondary" || weapon.name == "helicopter_gunner_turret_tertiary" || weapon.name == "amws_gun_turret_mp_player" || weapon.name == "auto_gun_turret")
		{
			return undefined;
		}
	}
	if(weapon.name == "dart")
	{
		return undefined;
	}
	if(isdefined(einflictor.killcament))
	{
		if(einflictor.killcament == attacker)
		{
			return undefined;
		}
		return einflictor.killcament;
	}
	if(isdefined(einflictor.killcamentities))
	{
		return get_closest_killcam_entity(attacker, einflictor.killcamentities);
	}
	if(isdefined(einflictor.script_gameobjectname) && einflictor.script_gameobjectname == "bombzone")
	{
		return einflictor.killcament;
	}
	return einflictor;
}

/*
	Name: get_secondary_killcam_entity
	Namespace: killcam
	Checksum: 0xF54DAF86
	Offset: 0x3330
	Size: 0x92
	Parameters: 2
	Flags: Linked
*/
function get_secondary_killcam_entity(entity, entity_info)
{
	if(!isdefined(entity) || !isdefined(entity.killcamentityindex))
	{
		return;
	}
	entity_info.entity_indexes[entity_info.entity_indexes.size] = entity.killcamentityindex;
	entity_info.entity_spawntimes[entity_info.entity_spawntimes.size] = entity.killcamentitystarttime;
}

/*
	Name: get_primary_killcam_entity
	Namespace: killcam
	Checksum: 0xA548F237
	Offset: 0x33D0
	Size: 0x10C
	Parameters: 4
	Flags: Linked
*/
function get_primary_killcam_entity(attacker, einflictor, weapon, entity_info)
{
	killcamentity = self get_killcam_entity(attacker, einflictor, weapon);
	killcamentitystarttime = get_killcam_entity_start_time(killcamentity);
	killcamentityindex = -1;
	if(isdefined(killcamentity))
	{
		killcamentityindex = killcamentity getentitynumber();
	}
	entity_info.entity_indexes[entity_info.entity_indexes.size] = killcamentityindex;
	entity_info.entity_spawntimes[entity_info.entity_spawntimes.size] = killcamentitystarttime;
	get_secondary_killcam_entity(killcamentity, entity_info);
}

/*
	Name: get_killcam_entity_info
	Namespace: killcam
	Checksum: 0x18DCB8C4
	Offset: 0x34E8
	Size: 0x80
	Parameters: 3
	Flags: Linked
*/
function get_killcam_entity_info(attacker, einflictor, weapon)
{
	entity_info = spawnstruct();
	entity_info.entity_indexes = [];
	entity_info.entity_spawntimes = [];
	get_primary_killcam_entity(attacker, einflictor, weapon, entity_info);
	return entity_info;
}

/*
	Name: get_killcam_entity_info_starttime
	Namespace: killcam
	Checksum: 0x91240D3C
	Offset: 0x3570
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function get_killcam_entity_info_starttime(entity_info)
{
	if(entity_info.entity_spawntimes.size == 0)
	{
		return 0;
	}
	return entity_info.entity_spawntimes[entity_info.entity_spawntimes.size - 1];
}

