// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\gametypes\_globallogic_utils;

#namespace globallogic_audio;

/*
	Name: __init__sytem__
	Namespace: globallogic_audio
	Checksum: 0x57B19B2F
	Offset: 0xC48
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("globallogic_audio", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: globallogic_audio
	Checksum: 0xA157E38E
	Offset: 0xC88
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: globallogic_audio
	Checksum: 0x27620DBC
	Offset: 0xCB8
	Size: 0x10C4
	Parameters: 0
	Flags: Linked
*/
function init()
{
	game["music"]["defeat"] = "mus_defeat";
	game["music"]["victory_spectator"] = "mus_defeat";
	game["music"]["winning"] = "mus_time_running_out_winning";
	game["music"]["losing"] = "mus_time_running_out_losing";
	game["music"]["match_end"] = "mus_match_end";
	game["music"]["victory_tie"] = "mus_defeat";
	game["music"]["suspense"] = [];
	game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_01";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_02";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_03";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_04";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_05";
	game["music"]["suspense"][game["music"]["suspense"].size] = "mus_suspense_06";
	game["dialog"]["mission_success"] = "mission_success";
	game["dialog"]["mission_failure"] = "mission_fail";
	game["dialog"]["mission_draw"] = "draw";
	game["dialog"]["round_success"] = "encourage_win";
	game["dialog"]["round_failure"] = "encourage_lost";
	game["dialog"]["round_draw"] = "draw";
	game["dialog"]["timesup"] = "timesup";
	game["dialog"]["winning"] = "winning";
	game["dialog"]["losing"] = "losing";
	game["dialog"]["min_draw"] = "min_draw";
	game["dialog"]["lead_lost"] = "lead_lost";
	game["dialog"]["lead_tied"] = "tied";
	game["dialog"]["lead_taken"] = "lead_taken";
	game["dialog"]["last_alive"] = "lastalive";
	game["dialog"]["boost"] = "generic_boost";
	if(!isdefined(game["dialog"]["offense_obj"]))
	{
		game["dialog"]["offense_obj"] = "generic_boost";
	}
	if(!isdefined(game["dialog"]["defense_obj"]))
	{
		game["dialog"]["defense_obj"] = "generic_boost";
	}
	game["dialog"]["hardcore"] = "hardcore";
	game["dialog"]["oldschool"] = "oldschool";
	game["dialog"]["highspeed"] = "highspeed";
	game["dialog"]["tactical"] = "tactical";
	game["dialog"]["challenge"] = "challengecomplete";
	game["dialog"]["promotion"] = "promotion";
	game["dialog"]["bomb_acquired"] = "sd_bomb_taken";
	game["dialog"]["bomb_taken"] = "sd_bomb_taken_taken";
	game["dialog"]["bomb_lost"] = "sd_bomb_drop";
	game["dialog"]["bomb_defused"] = "sd_bomb_defused";
	game["dialog"]["bomb_planted"] = "sd_bomb_planted";
	game["dialog"]["obj_taken"] = "securedobj";
	game["dialog"]["obj_lost"] = "lostobj";
	game["dialog"]["obj_defend"] = "defend_start";
	game["dialog"]["obj_destroy"] = "destroy_start";
	game["dialog"]["obj_capture"] = "capture_obj";
	game["dialog"]["objs_capture"] = "capture_objs";
	game["dialog"]["hq_located"] = "hq_located";
	game["dialog"]["hq_enemy_captured"] = "hq_capture";
	game["dialog"]["hq_enemy_destroyed"] = "hq_defend";
	game["dialog"]["hq_secured"] = "hq_secured";
	game["dialog"]["hq_offline"] = "hq_offline";
	game["dialog"]["hq_online"] = "hq_online";
	game["dialog"]["koth_located"] = "koth_located";
	game["dialog"]["koth_captured"] = "koth_captured";
	game["dialog"]["koth_lost"] = "koth_lost";
	game["dialog"]["koth_secured"] = "koth_secured";
	game["dialog"]["koth_contested"] = "koth_contest";
	game["dialog"]["koth_offline"] = "koth_offline";
	game["dialog"]["koth_online"] = "koth_online";
	game["dialog"]["move_to_new"] = "new_positions";
	game["dialog"]["attack"] = "attack";
	game["dialog"]["defend"] = "defend";
	game["dialog"]["offense"] = "offense";
	game["dialog"]["defense"] = "defense";
	game["dialog"]["halftime"] = "halftime";
	game["dialog"]["overtime"] = "overtime";
	game["dialog"]["side_switch"] = "switchingsides";
	game["dialog"]["flag_taken"] = "ourflag";
	game["dialog"]["flag_dropped"] = "ourflag_drop";
	game["dialog"]["flag_returned"] = "ourflag_return";
	game["dialog"]["flag_captured"] = "ourflag_capt";
	game["dialog"]["enemy_flag_taken"] = "enemyflag";
	game["dialog"]["enemy_flag_dropped"] = "enemyflag_drop";
	game["dialog"]["enemy_flag_returned"] = "enemyflag_return";
	game["dialog"]["enemy_flag_captured"] = "enemyflag_capt";
	game["dialog"]["securing_a"] = "dom_securing_a";
	game["dialog"]["securing_b"] = "dom_securing_b";
	game["dialog"]["securing_c"] = "dom_securing_c";
	game["dialog"]["securing_d"] = "dom_securing_d";
	game["dialog"]["securing_e"] = "dom_securing_e";
	game["dialog"]["securing_f"] = "dom_securing_f";
	game["dialog"]["secured_a"] = "dom_secured_a";
	game["dialog"]["secured_b"] = "dom_secured_b";
	game["dialog"]["secured_c"] = "dom_secured_c";
	game["dialog"]["secured_d"] = "dom_secured_d";
	game["dialog"]["secured_e"] = "dom_secured_e";
	game["dialog"]["secured_f"] = "dom_secured_f";
	game["dialog"]["losing_a"] = "dom_losing_a";
	game["dialog"]["losing_b"] = "dom_losing_b";
	game["dialog"]["losing_c"] = "dom_losing_c";
	game["dialog"]["losing_d"] = "dom_losing_d";
	game["dialog"]["losing_e"] = "dom_losing_e";
	game["dialog"]["losing_f"] = "dom_losing_f";
	game["dialog"]["lost_a"] = "dom_lost_a";
	game["dialog"]["lost_b"] = "dom_lost_b";
	game["dialog"]["lost_c"] = "dom_lost_c";
	game["dialog"]["lost_d"] = "dom_lost_d";
	game["dialog"]["lost_e"] = "dom_lost_e";
	game["dialog"]["lost_f"] = "dom_lost_f";
	game["dialog"]["secure_flag"] = "secure_flag";
	game["dialog"]["securing_flag"] = "securing_flag";
	game["dialog"]["losing_flag"] = "losing_flag";
	game["dialog"]["lost_flag"] = "lost_flag";
	game["dialog"]["oneflag_enemy"] = "oneflag_enemy";
	game["dialog"]["oneflag_friendly"] = "oneflag_friendly";
	game["dialog"]["lost_all"] = "dom_lock_theytake";
	game["dialog"]["secure_all"] = "dom_lock_wetake";
	game["dialog"]["squad_move"] = "squad_move";
	game["dialog"]["squad_30sec"] = "squad_30sec";
	game["dialog"]["squad_winning"] = "squad_onemin_vic";
	game["dialog"]["squad_losing"] = "squad_onemin_loss";
	game["dialog"]["squad_down"] = "squad_down";
	game["dialog"]["squad_bomb"] = "squad_bomb";
	game["dialog"]["squad_plant"] = "squad_plant";
	game["dialog"]["squad_take"] = "squad_takeobj";
	game["dialog"]["kicked"] = "player_kicked";
	game["dialog"]["sentry_destroyed"] = "dest_sentry";
	game["dialog"]["sentry_hacked"] = "kls_turret_hacked";
	game["dialog"]["microwave_destroyed"] = "dest_microwave";
	game["dialog"]["microwave_hacked"] = "kls_microwave_hacked";
	game["dialog"]["sam_destroyed"] = "dest_sam";
	game["dialog"]["tact_destroyed"] = "dest_tact";
	game["dialog"]["equipment_destroyed"] = "dest_equip";
	game["dialog"]["hacked_equip"] = "hacked_equip";
	game["dialog"]["uav_destroyed"] = "kls_u2_destroyed";
	game["dialog"]["cuav_destroyed"] = "kls_cu2_destroyed";
	level.dialoggroups = [];
	level thread post_match_snapshot_watcher();
}

/*
	Name: registerdialoggroup
	Namespace: globallogic_audio
	Checksum: 0xAB839279
	Offset: 0x1D88
	Size: 0xE8
	Parameters: 2
	Flags: Linked
*/
function registerdialoggroup(group, skipifcurrentlyplayinggroup)
{
	if(!isdefined(level.dialoggroups))
	{
		level.dialoggroups = [];
	}
	else if(isdefined(level.dialoggroup[group]))
	{
		util::error(("registerDialogGroup:  Dialog group " + group) + " already registered.");
		return;
	}
	level.dialoggroup[group] = spawnstruct();
	level.dialoggroup[group].group = group;
	level.dialoggroup[group].skipifcurrentlyplayinggroup = skipifcurrentlyplayinggroup;
	level.dialoggroup[group].currentcount = 0;
}

/*
	Name: sndstartmusicsystem
	Namespace: globallogic_audio
	Checksum: 0x51859829
	Offset: 0x1E78
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function sndstartmusicsystem()
{
	self endon(#"disconnect");
	if(game["state"] == "postgame")
	{
		return;
	}
	if(!isdefined(level.nextmusicstate))
	{
		/#
			if(getdvarint("") > 0)
			{
				println("");
			}
		#/
		self.pers["music"].currentstate = "UNDERSCORE";
		self thread suspensemusic();
	}
}

/*
	Name: suspensemusicforplayer
	Namespace: globallogic_audio
	Checksum: 0x31B64C40
	Offset: 0x1F30
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function suspensemusicforplayer()
{
	self endon(#"disconnect");
	self thread set_music_on_player("UNDERSCORE", 0);
	/#
		if(getdvarint("") > 0)
		{
			println((("" + self.pers[""].returnstate) + "") + self getentitynumber());
		}
	#/
}

/*
	Name: suspensemusic
	Namespace: globallogic_audio
	Checksum: 0x7E5392BB
	Offset: 0x1FE0
	Size: 0x288
	Parameters: 1
	Flags: Linked
*/
function suspensemusic(random)
{
	level endon(#"game_ended");
	level endon(#"match_ending_soon");
	self endon(#"disconnect");
	/#
		if(getdvarint("") > 0)
		{
			println("");
		}
	#/
	while(true)
	{
		wait(randomintrange(25, 60));
		/#
			if(getdvarint("") > 0)
			{
				println("");
			}
		#/
		if(!isdefined(self.pers["music"].inque))
		{
			self.pers["music"].inque = 0;
		}
		if(self.pers["music"].inque)
		{
			/#
				if(getdvarint("") > 0)
				{
					println("");
				}
			#/
			continue;
		}
		if(!isdefined(self.pers["music"].currentstate))
		{
			self.pers["music"].currentstate = "SILENT";
		}
		if(randomint(100) < self.underscorechance && self.pers["music"].currentstate != "ACTION" && self.pers["music"].currentstate != "TIME_OUT")
		{
			self thread suspensemusicforplayer();
			self.underscorechance = self.underscorechance - 20;
			/#
				if(getdvarint("") > 0)
				{
					println("");
				}
			#/
		}
	}
}

/*
	Name: leaderdialogforotherteams
	Namespace: globallogic_audio
	Checksum: 0xCE9A39A1
	Offset: 0x2270
	Size: 0xBA
	Parameters: 3
	Flags: Linked
*/
function leaderdialogforotherteams(dialog, skip_team, squad_dialog)
{
	foreach(team in level.teams)
	{
		if(team != skip_team)
		{
			leaderdialog(dialog, team, undefined, undefined, squad_dialog);
		}
	}
}

/*
	Name: announceroundwinner
	Namespace: globallogic_audio
	Checksum: 0xAF97CD59
	Offset: 0x2338
	Size: 0x15C
	Parameters: 2
	Flags: Linked
*/
function announceroundwinner(winner, delay)
{
	if(delay > 0)
	{
		wait(delay);
	}
	if(!isdefined(winner) || isplayer(winner))
	{
		return;
	}
	if(isdefined(level.teams[winner]))
	{
		leaderdialog("round_success", winner);
		leaderdialogforotherteams("round_failure", winner);
	}
	else
	{
		foreach(team in level.teams)
		{
			thread util::playsoundonplayers(("mus_round_draw" + "_") + level.teampostfix[team]);
		}
		leaderdialog("round_draw");
	}
}

/*
	Name: announcegamewinner
	Namespace: globallogic_audio
	Checksum: 0xE131F084
	Offset: 0x24A0
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function announcegamewinner(winner, delay)
{
	if(delay > 0)
	{
		wait(delay);
	}
	if(!isdefined(winner) || isplayer(winner))
	{
		return;
	}
	if(isdefined(level.teams[winner]))
	{
		leaderdialog("mission_success", winner);
		leaderdialogforotherteams("mission_failure", winner);
	}
	else
	{
		leaderdialog("mission_draw");
	}
}

/*
	Name: doflameaudio
	Namespace: globallogic_audio
	Checksum: 0x52569C2C
	Offset: 0x2568
	Size: 0x98
	Parameters: 0
	Flags: None
*/
function doflameaudio()
{
	self endon(#"disconnect");
	waittillframeend();
	if(!isdefined(self.lastflamehurtaudio))
	{
		self.lastflamehurtaudio = 0;
	}
	currenttime = gettime();
	if((self.lastflamehurtaudio + level.fire_audio_repeat_duration) + randomint(level.fire_audio_random_max_duration) < currenttime)
	{
		self playlocalsound("vox_pain_small");
		self.lastflamehurtaudio = currenttime;
	}
}

/*
	Name: leaderdialog
	Namespace: globallogic_audio
	Checksum: 0x4236B373
	Offset: 0x2608
	Size: 0x2B6
	Parameters: 5
	Flags: Linked
*/
function leaderdialog(dialog, team, group, excludelist, squaddialog)
{
	/#
		assert(isdefined(level.players));
	#/
	if(level.splitscreen)
	{
		return;
	}
	if(level.wagermatch)
	{
		return;
	}
	if(!isdefined(team))
	{
		dialogs = [];
		foreach(team in level.teams)
		{
			dialogs[team] = dialog;
		}
		leaderdialogallteams(dialogs, group, excludelist);
		return;
	}
	if(level.splitscreen)
	{
		if(level.players.size)
		{
			level.players[0] leaderdialogonplayer(dialog, group);
		}
		return;
	}
	if(isdefined(excludelist))
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if(isdefined(player.pers["team"]) && player.pers["team"] == team && !globallogic_utils::isexcluded(player, excludelist))
			{
				player leaderdialogonplayer(dialog, group);
			}
		}
	}
	else
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if(isdefined(player.pers["team"]) && player.pers["team"] == team)
			{
				player leaderdialogonplayer(dialog, group);
			}
		}
	}
}

/*
	Name: leaderdialogallteams
	Namespace: globallogic_audio
	Checksum: 0xA770B8FE
	Offset: 0x28C8
	Size: 0x17E
	Parameters: 3
	Flags: Linked
*/
function leaderdialogallteams(dialogs, group, excludelist)
{
	/#
		assert(isdefined(level.players));
	#/
	if(level.splitscreen)
	{
		return;
	}
	if(level.splitscreen)
	{
		if(level.players.size)
		{
			level.players[0] leaderdialogonplayer(dialogs[level.players[0].team], group);
		}
		return;
	}
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		team = player.pers["team"];
		if(!isdefined(team))
		{
			continue;
		}
		if(!isdefined(dialogs[team]))
		{
			continue;
		}
		if(isdefined(excludelist) && globallogic_utils::isexcluded(player, excludelist))
		{
			continue;
		}
		player leaderdialogonplayer(dialogs[team], group);
	}
}

/*
	Name: flushdialog
	Namespace: globallogic_audio
	Checksum: 0x49B0557C
	Offset: 0x2A50
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function flushdialog()
{
	foreach(player in level.players)
	{
		player flushdialogonplayer();
	}
}

/*
	Name: flushdialogonplayer
	Namespace: globallogic_audio
	Checksum: 0x8766FCCC
	Offset: 0x2AE8
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function flushdialogonplayer()
{
	self.leaderdialoggroups = [];
	self.leaderdialogqueue = [];
	self.leaderdialogactive = 0;
	self.currentleaderdialoggroup = "";
}

/*
	Name: flushgroupdialog
	Namespace: globallogic_audio
	Checksum: 0x2C8C089D
	Offset: 0x2B28
	Size: 0x9A
	Parameters: 1
	Flags: None
*/
function flushgroupdialog(group)
{
	foreach(player in level.players)
	{
		player flushgroupdialogonplayer(group);
	}
}

/*
	Name: flushgroupdialogonplayer
	Namespace: globallogic_audio
	Checksum: 0xFCCF40A5
	Offset: 0x2BD0
	Size: 0xA2
	Parameters: 1
	Flags: Linked
*/
function flushgroupdialogonplayer(group)
{
	self.leaderdialoggroups[group] = undefined;
	foreach(key, dialog in self.leaderdialogqueue)
	{
		if(dialog == group)
		{
			self.leaderdialogqueue[key] = undefined;
		}
	}
}

/*
	Name: addgroupdialogtoplayer
	Namespace: globallogic_audio
	Checksum: 0x2537C82B
	Offset: 0x2C80
	Size: 0x1EA
	Parameters: 2
	Flags: Linked
*/
function addgroupdialogtoplayer(dialog, group)
{
	if(!isdefined(level.dialoggroup[group]))
	{
		util::error(("leaderDialogOnPlayer:  Dialog group " + group) + " is not registered");
		return 0;
	}
	addtoqueue = 0;
	if(!isdefined(self.leaderdialoggroups[group]))
	{
		addtoqueue = 1;
	}
	if(!level.dialoggroup[group].skipifcurrentlyplayinggroup)
	{
		if(self.currentleaderdialog == dialog && (self.currentleaderdialogtime + 2000) > gettime())
		{
			self.leaderdialoggroups[group] = undefined;
			foreach(key, leader_dialog in self.leaderdialogqueue)
			{
				if(leader_dialog == group)
				{
					for(i = key + 1; i < self.leaderdialogqueue.size; i++)
					{
						self.leaderdialogqueue[i - 1] = self.leaderdialogqueue[i];
					}
					self.leaderdialogqueue[i - 1] = undefined;
					break;
				}
			}
			return 0;
		}
	}
	else if(self.currentleaderdialoggroup == group)
	{
		return 0;
	}
	self.leaderdialoggroups[group] = dialog;
	return addtoqueue;
}

/*
	Name: testdialogqueue
	Namespace: globallogic_audio
	Checksum: 0x7EB2B86E
	Offset: 0x2E78
	Size: 0xC2
	Parameters: 1
	Flags: Linked
*/
function testdialogqueue(group)
{
	/#
		count = 0;
		foreach(temp in self.leaderdialogqueue)
		{
			if(temp == group)
			{
				count++;
			}
		}
		if(count > 1)
		{
			shit = 0;
		}
	#/
}

/*
	Name: leaderdialogonplayer
	Namespace: globallogic_audio
	Checksum: 0xD8651EEB
	Offset: 0x2F48
	Size: 0xE6
	Parameters: 2
	Flags: Linked
*/
function leaderdialogonplayer(dialog, group)
{
	team = self.pers["team"];
	if(level.splitscreen)
	{
		return;
	}
	if(!isdefined(team))
	{
		return;
	}
	if(!isdefined(level.teams[team]))
	{
		return;
	}
	if(isdefined(group))
	{
		if(!addgroupdialogtoplayer(dialog, group))
		{
			self testdialogqueue(group);
			return;
		}
		dialog = group;
	}
	if(!self.leaderdialogactive)
	{
		self thread playleaderdialogonplayer(dialog);
	}
	else
	{
		self.leaderdialogqueue[self.leaderdialogqueue.size] = dialog;
	}
}

/*
	Name: waitforsound
	Namespace: globallogic_audio
	Checksum: 0xEEDF1044
	Offset: 0x3038
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function waitforsound(sound, extratime = 0.1)
{
	time = soundgetplaybacktime(sound);
	if(time < 0)
	{
		wait(3 + extratime);
	}
	else
	{
		wait((time * 0.001) + extratime);
	}
}

/*
	Name: playleaderdialogonplayer
	Namespace: globallogic_audio
	Checksum: 0xD23669E6
	Offset: 0x30C8
	Size: 0x294
	Parameters: 1
	Flags: Linked
*/
function playleaderdialogonplayer(dialog)
{
	if(isdefined(level.allowannouncer) && !level.allowannouncer)
	{
		return;
	}
	team = self.pers["team"];
	self endon(#"disconnect");
	self.leaderdialogactive = 1;
	if(isdefined(self.leaderdialoggroups[dialog]))
	{
		group = dialog;
		dialog = self.leaderdialoggroups[group];
		self.leaderdialoggroups[group] = undefined;
		self.currentleaderdialoggroup = group;
		self testdialogqueue(group);
	}
	if(level.wagermatch || !isdefined(game["voice"]))
	{
		faction = "vox_wm_";
	}
	else
	{
		faction = game["voice"][team];
	}
	sound_name = faction + game["dialog"][dialog];
	if(level.allowannouncer)
	{
		self playlocalsound(sound_name);
		self.currentleaderdialog = dialog;
		self.currentleaderdialogtime = gettime();
	}
	waitforsound(sound_name);
	self.leaderdialogactive = 0;
	self.currentleaderdialoggroup = "";
	self.currentleaderdialog = "";
	if(self.leaderdialogqueue.size > 0)
	{
		nextdialog = self.leaderdialogqueue[0];
		for(i = 1; i < self.leaderdialogqueue.size; i++)
		{
			self.leaderdialogqueue[i - 1] = self.leaderdialogqueue[i];
		}
		self.leaderdialogqueue[i - 1] = undefined;
		if(isdefined(self.leaderdialoggroups[dialog]))
		{
			self testdialogqueue(dialog);
		}
		self thread playleaderdialogonplayer(nextdialog);
	}
}

/*
	Name: isteamwinning
	Namespace: globallogic_audio
	Checksum: 0x5E34189F
	Offset: 0x3368
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function isteamwinning(checkteam)
{
	score = game["teamScores"][checkteam];
	foreach(team in level.teams)
	{
		if(team != checkteam)
		{
			if(game["teamScores"][team] >= score)
			{
				return false;
			}
		}
	}
	return true;
}

/*
	Name: announceteamiswinning
	Namespace: globallogic_audio
	Checksum: 0xCF1FA321
	Offset: 0x3440
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function announceteamiswinning()
{
	foreach(team in level.teams)
	{
		if(isteamwinning(team))
		{
			leaderdialog("winning", team, undefined, undefined, "squad_winning");
			leaderdialogforotherteams("losing", team, "squad_losing");
			return true;
		}
	}
	return false;
}

/*
	Name: musiccontroller
	Namespace: globallogic_audio
	Checksum: 0xD17F15DF
	Offset: 0x3530
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function musiccontroller()
{
	level endon(#"game_ended");
	level thread musictimesout();
	level waittill(#"match_ending_soon");
	if(util::islastround() || util::isoneround())
	{
		if(!level.splitscreen)
		{
			if(level.teambased)
			{
				if(!announceteamiswinning())
				{
					leaderdialog("min_draw");
				}
			}
			level waittill(#"match_ending_very_soon");
			foreach(team in level.teams)
			{
				leaderdialog("timesup", team, undefined, undefined, "squad_30sec");
			}
		}
	}
	else
	{
		level waittill(#"match_ending_vox");
		leaderdialog("timesup");
	}
}

/*
	Name: musictimesout
	Namespace: globallogic_audio
	Checksum: 0xEEF964E9
	Offset: 0x36B0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function musictimesout()
{
	level endon(#"game_ended");
	level waittill(#"match_ending_very_soon");
	thread set_music_on_team("TIME_OUT", "both", 1, 0);
}

/*
	Name: actionmusicset
	Namespace: globallogic_audio
	Checksum: 0xF48B64E4
	Offset: 0x3700
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function actionmusicset()
{
	level endon(#"game_ended");
	level.playingactionmusic = 1;
	wait(45);
	level.playingactionmusic = 0;
}

/*
	Name: play_2d_on_team
	Namespace: globallogic_audio
	Checksum: 0xF0F66B03
	Offset: 0x3738
	Size: 0xD6
	Parameters: 2
	Flags: None
*/
function play_2d_on_team(alias, team)
{
	/#
		assert(isdefined(level.players));
	#/
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(isdefined(player.pers["team"]) && player.pers["team"] == team)
		{
			player playlocalsound(alias);
		}
	}
}

/*
	Name: set_music_on_team
	Namespace: globallogic_audio
	Checksum: 0x9E3D3CFD
	Offset: 0x3818
	Size: 0x2FE
	Parameters: 5
	Flags: Linked
*/
function set_music_on_team(state, team, save_state, return_state, wait_time)
{
	if(sessionmodeiszombiesgame())
	{
		return;
	}
	/#
		assert(isdefined(level.players));
	#/
	if(!isdefined(team))
	{
		team = "both";
		/#
			if(getdvarint("") > 0)
			{
				println("");
			}
		#/
	}
	if(!isdefined(save_state))
	{
		save_sate = 0;
		/#
			if(getdvarint("") > 0)
			{
				println("");
			}
		#/
	}
	if(!isdefined(return_state))
	{
		return_state = 0;
		/#
			if(getdvarint("") > 0)
			{
				println("");
			}
		#/
	}
	if(!isdefined(wait_time))
	{
		wait_time = 0;
		/#
			if(getdvarint("") > 0)
			{
				println("");
			}
		#/
	}
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(team == "both")
		{
			player thread set_music_on_player(state, save_state, return_state, wait_time);
			continue;
		}
		if(isdefined(player.pers["team"]) && player.pers["team"] == team)
		{
			player thread set_music_on_player(state, save_state, return_state, wait_time);
			/#
				if(getdvarint("") > 0)
				{
					println((("" + state) + "") + player getentitynumber());
				}
			#/
		}
	}
}

/*
	Name: set_music_on_player
	Namespace: globallogic_audio
	Checksum: 0x51F55112
	Offset: 0x3B20
	Size: 0x424
	Parameters: 4
	Flags: Linked
*/
function set_music_on_player(state, save_state, return_state, wait_time)
{
	self endon(#"disconnect");
	if(sessionmodeiszombiesgame())
	{
		return;
	}
	/#
		assert(isplayer(self));
	#/
	if(!isdefined(save_state))
	{
		save_state = 0;
		/#
			if(getdvarint("") > 0)
			{
				println("");
			}
		#/
	}
	if(!isdefined(return_state))
	{
		return_state = 0;
		/#
			if(getdvarint("") > 0)
			{
				println("");
			}
		#/
	}
	if(!isdefined(wait_time))
	{
		wait_time = 0;
		/#
			if(getdvarint("") > 0)
			{
				println("");
			}
		#/
	}
	if(!isdefined(state))
	{
		state = "UNDERSCORE";
		/#
			if(getdvarint("") > 0)
			{
				println("");
			}
		#/
	}
	music::setmusicstate(state, self);
	if(isdefined(self.pers["music"].currentstate) && save_state)
	{
		self.pers["music"].returnstate = state;
		/#
			if(getdvarint("") > 0)
			{
				println((("" + self.pers[""].returnstate) + "") + self getentitynumber());
			}
		#/
	}
	self.pers["music"].previousstate = self.pers["music"].currentstate;
	self.pers["music"].currentstate = state;
	/#
		if(getdvarint("") > 0)
		{
			println((("" + state) + "") + self getentitynumber());
		}
	#/
	if(isdefined(self.pers["music"].returnstate) && return_state)
	{
		/#
			if(getdvarint("") > 0)
			{
				println((("" + self.pers[""].returnstate) + "") + self getentitynumber());
			}
		#/
		self set_next_music_state(self.pers["music"].returnstate, wait_time);
	}
}

/*
	Name: return_music_state_player
	Namespace: globallogic_audio
	Checksum: 0x8CED2F82
	Offset: 0x3F50
	Size: 0x94
	Parameters: 1
	Flags: None
*/
function return_music_state_player(wait_time)
{
	if(!isdefined(wait_time))
	{
		wait_time = 0;
		/#
			if(getdvarint("") > 0)
			{
				println("");
			}
		#/
	}
	self set_next_music_state(self.pers["music"].returnstate, wait_time);
}

/*
	Name: return_music_state_team
	Namespace: globallogic_audio
	Checksum: 0xAA3E54F5
	Offset: 0x3FF0
	Size: 0x1DE
	Parameters: 2
	Flags: None
*/
function return_music_state_team(team, wait_time)
{
	if(!isdefined(wait_time))
	{
		wait_time = 0;
		/#
			if(getdvarint("") > 0)
			{
				println("");
			}
		#/
	}
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(team == "both")
		{
			player thread set_next_music_state(self.pers["music"].returnstate, wait_time);
			continue;
		}
		if(isdefined(player.pers["team"]) && player.pers["team"] == team)
		{
			player thread set_next_music_state(self.pers["music"].returnstate, wait_time);
			/#
				if(getdvarint("") > 0)
				{
					println((("" + self.pers[""].returnstate) + "") + player getentitynumber());
				}
			#/
		}
	}
}

/*
	Name: set_next_music_state
	Namespace: globallogic_audio
	Checksum: 0xEC443CF2
	Offset: 0x41D8
	Size: 0x1BC
	Parameters: 2
	Flags: Linked
*/
function set_next_music_state(nextstate, wait_time)
{
	self endon(#"disconnect");
	self.pers["music"].nextstate = nextstate;
	/#
		if(getdvarint("") > 0)
		{
			println((("" + self.pers[""].nextstate) + "") + self getentitynumber());
		}
	#/
	if(!isdefined(self.pers["music"].inque))
	{
		self.pers["music"].inque = 0;
	}
	if(self.pers["music"].inque)
	{
		return;
	}
	self.pers["music"].inque = 1;
	if(wait_time)
	{
		wait(wait_time);
	}
	self set_music_on_player(self.pers["music"].nextstate, 0);
	self.pers["music"].inque = 0;
}

/*
	Name: getroundswitchdialog
	Namespace: globallogic_audio
	Checksum: 0xC7C47AAF
	Offset: 0x43A0
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function getroundswitchdialog(switchtype)
{
	switch(switchtype)
	{
		case "halftime":
		{
			return "halftime";
		}
		case "overtime":
		{
			return "overtime";
		}
		default:
		{
			return "side_switch";
		}
	}
}

/*
	Name: post_match_snapshot_watcher
	Namespace: globallogic_audio
	Checksum: 0x4BEEF10F
	Offset: 0x43F8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function post_match_snapshot_watcher()
{
	level waittill(#"game_ended");
	level util::clientnotify("pm");
	level waittill(#"sfade");
	level util::clientnotify("pmf");
}

