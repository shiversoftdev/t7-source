// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spectating;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace dogtags;

/*
	Name: init
	Namespace: dogtags
	Checksum: 0xBB7D614
	Offset: 0x3D0
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.antiboostdistance = getgametypesetting("antiBoostDistance");
	level.dogtags = [];
}

/*
	Name: spawn_dog_tag
	Namespace: dogtags
	Checksum: 0x47172174
	Offset: 0x408
	Size: 0xA42
	Parameters: 4
	Flags: Linked
*/
function spawn_dog_tag(victim, attacker, on_use_function, objectives_for_attacker_and_victim_only)
{
	if(isdefined(level.dogtags[victim.entnum]))
	{
		playfx("ui/fx_kill_confirmed_vanish", level.dogtags[victim.entnum].curorigin);
		level.dogtags[victim.entnum] notify(#"reset");
	}
	else
	{
		visuals[0] = spawn("script_model", (0, 0, 0));
		visuals[0] setmodel(victim getenemydogtagmodel());
		visuals[1] = spawn("script_model", (0, 0, 0));
		visuals[1] setmodel(victim getfriendlydogtagmodel());
		trigger = spawn("trigger_radius", (0, 0, 0), 0, 32, 32);
		level.dogtags[victim.entnum] = gameobjects::create_use_object("any", trigger, visuals, vectorscale((0, 0, 1), 16));
		level.dogtags[victim.entnum] gameobjects::set_use_time(0);
		level.dogtags[victim.entnum].onuse = &onuse;
		level.dogtags[victim.entnum].custom_onuse = on_use_function;
		level.dogtags[victim.entnum].victim = victim;
		level.dogtags[victim.entnum].victimteam = victim.team;
		level thread clear_on_victim_disconnect(victim);
		victim thread team_updater(level.dogtags[victim.entnum]);
		foreach(team in level.teams)
		{
			objective_add(level.dogtags[victim.entnum].objid[team], "invisible", (0, 0, 0));
			objective_icon(level.dogtags[victim.entnum].objid[team], "waypoint_dogtags");
			objective_team(level.dogtags[victim.entnum].objid[team], team);
			if(team == attacker.team)
			{
				objective_setcolor(level.dogtags[victim.entnum].objid[team], &"EnemyOrange");
				continue;
			}
			objective_setcolor(level.dogtags[victim.entnum].objid[team], &"FriendlyBlue");
		}
	}
	pos = victim.origin + vectorscale((0, 0, 1), 14);
	level.dogtags[victim.entnum].curorigin = pos;
	level.dogtags[victim.entnum].trigger.origin = pos;
	level.dogtags[victim.entnum].visuals[0].origin = pos;
	level.dogtags[victim.entnum].visuals[1].origin = pos;
	level.dogtags[victim.entnum].visuals[0] dontinterpolate();
	level.dogtags[victim.entnum].visuals[1] dontinterpolate();
	level.dogtags[victim.entnum] gameobjects::allow_use("any");
	level.dogtags[victim.entnum].visuals[0] thread show_to_team(level.dogtags[victim.entnum], attacker.team);
	level.dogtags[victim.entnum].visuals[1] thread show_to_enemy_teams(level.dogtags[victim.entnum], attacker.team);
	level.dogtags[victim.entnum].attacker = attacker;
	level.dogtags[victim.entnum].attackerteam = attacker.team;
	level.dogtags[victim.entnum].unreachable = undefined;
	level.dogtags[victim.entnum].tacinsert = 0;
	foreach(team in level.teams)
	{
		if(isdefined(level.dogtags[victim.entnum].objid[team]))
		{
			objective_position(level.dogtags[victim.entnum].objid[team], pos);
			objective_state(level.dogtags[victim.entnum].objid[team], "active");
		}
	}
	if(objectives_for_attacker_and_victim_only)
	{
		objective_setinvisibletoall(level.dogtags[victim.entnum].objid[attacker.team]);
		if(isplayer(attacker))
		{
			objective_setvisibletoplayer(level.dogtags[victim.entnum].objid[attacker.team], attacker);
		}
		objective_setinvisibletoall(level.dogtags[victim.entnum].objid[victim.team]);
		if(isplayer(victim))
		{
			objective_setvisibletoplayer(level.dogtags[victim.entnum].objid[victim.team], victim);
		}
	}
	level.dogtags[victim.entnum] thread bounce();
	level notify(#"dogtag_spawned");
}

/*
	Name: show_to_team
	Namespace: dogtags
	Checksum: 0x8317DFCD
	Offset: 0xE58
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function show_to_team(gameobject, show_team)
{
	self show();
	foreach(team in level.teams)
	{
		self hidefromteam(team);
	}
	self showtoteam(show_team);
}

/*
	Name: show_to_enemy_teams
	Namespace: dogtags
	Checksum: 0x4DAB9581
	Offset: 0xF30
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function show_to_enemy_teams(gameobject, friend_team)
{
	self show();
	foreach(team in level.teams)
	{
		self showtoteam(team);
	}
	self hidefromteam(friend_team);
}

/*
	Name: onuse
	Namespace: dogtags
	Checksum: 0x51914709
	Offset: 0x1008
	Size: 0x224
	Parameters: 1
	Flags: Linked
*/
function onuse(player)
{
	self.visuals[0] playsound("mpl_killconfirm_tags_pickup");
	tacinsertboost = 0;
	if(player.team != self.attackerteam)
	{
		player addplayerstat("KILLSDENIED", 1);
		player recordgameevent("return");
		if(self.victim == player)
		{
			if(self.tacinsert == 0)
			{
				event = "retrieve_own_tags";
			}
			else
			{
				tacinsertboost = 1;
			}
		}
		else
		{
			event = "kill_denied";
		}
		if(!tacinsertboost)
		{
			player.pers["killsdenied"]++;
			player.killsdenied = player.pers["killsdenied"];
		}
	}
	else
	{
		event = "kill_confirmed";
		player addplayerstat("KILLSCONFIRMED", 1);
		player recordgameevent("capture");
		if(isdefined(self.attacker) && self.attacker != player)
		{
			self.attacker onpickup("teammate_kill_confirmed");
		}
	}
	if(!tacinsertboost && isdefined(player))
	{
		player onpickup(event);
	}
	[[self.custom_onuse]](player);
	self reset_tags();
}

/*
	Name: reset_tags
	Namespace: dogtags
	Checksum: 0xDE9EF2C0
	Offset: 0x1238
	Size: 0x19A
	Parameters: 0
	Flags: Linked
*/
function reset_tags()
{
	self.attacker = undefined;
	self.unreachable = undefined;
	self notify(#"reset");
	self.visuals[0] hide();
	self.visuals[1] hide();
	self.curorigin = vectorscale((0, 0, 1), 1000);
	self.trigger.origin = vectorscale((0, 0, 1), 1000);
	self.visuals[0].origin = vectorscale((0, 0, 1), 1000);
	self.visuals[1].origin = vectorscale((0, 0, 1), 1000);
	self.tacinsert = 0;
	self gameobjects::allow_use("none");
	foreach(team in level.teams)
	{
		objective_state(self.objid[team], "invisible");
	}
}

/*
	Name: onpickup
	Namespace: dogtags
	Checksum: 0x951D25CB
	Offset: 0x13E0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function onpickup(event)
{
	scoreevents::processscoreevent(event, self);
}

/*
	Name: clear_on_victim_disconnect
	Namespace: dogtags
	Checksum: 0x10B97ABE
	Offset: 0x1410
	Size: 0x23C
	Parameters: 1
	Flags: Linked
*/
function clear_on_victim_disconnect(victim)
{
	level endon(#"game_ended");
	guid = victim.entnum;
	victim waittill(#"disconnect");
	if(isdefined(level.dogtags[guid]))
	{
		level.dogtags[guid] gameobjects::allow_use("none");
		playfx("ui/fx_kill_confirmed_vanish", level.dogtags[guid].curorigin);
		level.dogtags[guid] notify(#"reset");
		wait(0.05);
		if(isdefined(level.dogtags[guid]))
		{
			foreach(team in level.teams)
			{
				objective_delete(level.dogtags[guid].objid[team]);
			}
			level.dogtags[guid].trigger delete();
			for(i = 0; i < level.dogtags[guid].visuals.size; i++)
			{
				level.dogtags[guid].visuals[i] delete();
			}
			level.dogtags[guid] notify(#"deleted");
			level.dogtags[guid] = undefined;
		}
	}
}

/*
	Name: on_spawn_player
	Namespace: dogtags
	Checksum: 0xA88F5EC8
	Offset: 0x1658
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function on_spawn_player()
{
	if(level.rankedmatch || level.leaguematch)
	{
		if(isdefined(self.tacticalinsertiontime) && (self.tacticalinsertiontime + 100) > gettime())
		{
			mindist = level.antiboostdistance;
			mindistsqr = mindist * mindist;
			distsqr = distancesquared(self.origin, level.dogtags[self.entnum].curorigin);
			if(distsqr < mindistsqr)
			{
				level.dogtags[self.entnum].tacinsert = 1;
			}
		}
	}
}

/*
	Name: team_updater
	Namespace: dogtags
	Checksum: 0x3C0599AF
	Offset: 0x1738
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function team_updater(tags)
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"joined_team");
		tags.victimteam = self.team;
		tags reset_tags();
	}
}

/*
	Name: time_out
	Namespace: dogtags
	Checksum: 0x93320338
	Offset: 0x17A8
	Size: 0x13C
	Parameters: 1
	Flags: None
*/
function time_out(victim)
{
	level endon(#"game_ended");
	victim endon(#"disconnect");
	self notify(#"timeout");
	self endon(#"timeout");
	level hostmigration::waitlongdurationwithhostmigrationpause(30);
	self.visuals[0] hide();
	self.visuals[1] hide();
	self.curorigin = vectorscale((0, 0, 1), 1000);
	self.trigger.origin = vectorscale((0, 0, 1), 1000);
	self.visuals[0].origin = vectorscale((0, 0, 1), 1000);
	self.visuals[1].origin = vectorscale((0, 0, 1), 1000);
	self.tacinsert = 0;
	self gameobjects::allow_use("none");
}

/*
	Name: bounce
	Namespace: dogtags
	Checksum: 0x5507278D
	Offset: 0x18F0
	Size: 0x210
	Parameters: 0
	Flags: Linked
*/
function bounce()
{
	level endon(#"game_ended");
	self endon(#"reset");
	bottompos = self.curorigin;
	toppos = self.curorigin + vectorscale((0, 0, 1), 12);
	while(true)
	{
		self.visuals[0] moveto(toppos, 0.5, 0.15, 0.15);
		self.visuals[0] rotateyaw(180, 0.5);
		self.visuals[1] moveto(toppos, 0.5, 0.15, 0.15);
		self.visuals[1] rotateyaw(180, 0.5);
		wait(0.5);
		self.visuals[0] moveto(bottompos, 0.5, 0.15, 0.15);
		self.visuals[0] rotateyaw(180, 0.5);
		self.visuals[1] moveto(bottompos, 0.5, 0.15, 0.15);
		self.visuals[1] rotateyaw(180, 0.5);
		wait(0.5);
	}
}

/*
	Name: checkallowspectating
	Namespace: dogtags
	Checksum: 0x2C8D1E11
	Offset: 0x1B08
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function checkallowspectating()
{
	self endon(#"disconnect");
	wait(0.05);
	spectating::update_settings();
}

/*
	Name: should_spawn_tags
	Namespace: dogtags
	Checksum: 0x4D66E993
	Offset: 0x1B40
	Size: 0x158
	Parameters: 9
	Flags: Linked
*/
function should_spawn_tags(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	if(isalive(self))
	{
		return false;
	}
	if(isdefined(self.switching_teams))
	{
		return false;
	}
	if(isdefined(attacker) && attacker == self)
	{
		return false;
	}
	if(level.teambased && isdefined(attacker) && isdefined(attacker.team) && attacker.team == self.team)
	{
		return false;
	}
	if(isdefined(attacker) && (!isdefined(attacker.team) || attacker.team == "free") && (attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn"))
	{
		return false;
	}
	return true;
}

/*
	Name: onusedogtag
	Namespace: dogtags
	Checksum: 0xA7000A0E
	Offset: 0x1CA0
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function onusedogtag(player)
{
	if(player.pers["team"] == self.victimteam)
	{
		player.pers["rescues"]++;
		player.rescues = player.pers["rescues"];
		if(isdefined(self.victim))
		{
			if(!level.gameended)
			{
				self.victim thread dt_respawn();
			}
		}
	}
}

/*
	Name: dt_respawn
	Namespace: dogtags
	Checksum: 0xC6782A6F
	Offset: 0x1D40
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function dt_respawn()
{
	self thread waittillcanspawnclient();
}

/*
	Name: waittillcanspawnclient
	Namespace: dogtags
	Checksum: 0x81ED23B3
	Offset: 0x1D68
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function waittillcanspawnclient()
{
	for(;;)
	{
		wait(0.05);
		if(isdefined(self) && (self.sessionstate == "spectator" || !isalive(self)))
		{
			self.pers["lives"] = 1;
			self thread [[level.spawnclient]]();
			continue;
		}
		return;
	}
}

