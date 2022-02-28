// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\gametypes\_spawnlogic;

#namespace spawning;

/*
	Name: __init__
	Namespace: spawning
	Checksum: 0x26A7CB93
	Offset: 0x3F0
	Size: 0x1EC
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level init_spawn_system();
	level.recently_deceased = [];
	foreach(team in level.teams)
	{
		level.recently_deceased[team] = util::spawn_array_struct();
	}
	callback::on_connecting(&on_player_connecting);
	level.spawnprotectiontime = getgametypesetting("spawnprotectiontime");
	level.spawnprotectiontimems = int((isdefined(level.spawnprotectiontime) ? level.spawnprotectiontime : 0) * 1000);
	/#
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		level.test_spawn_point_index = 0;
		setdvar("", "");
	#/
}

/*
	Name: init_spawn_system
	Namespace: spawning
	Checksum: 0x9B22C85F
	Offset: 0x5E8
	Size: 0x1B2
	Parameters: 0
	Flags: Linked
*/
function init_spawn_system()
{
	level.spawnsystem = spawnstruct();
	spawnsystem = level.spawnsystem;
	if(!isdefined(spawnsystem.unifiedsideswitching))
	{
		spawnsystem.unifiedsideswitching = 1;
	}
	spawnsystem.objective_facing_bonus = 0;
	spawnsystem.ispawn_teammask = [];
	spawnsystem.ispawn_teammask_free = 1;
	spawnsystem.ispawn_teammask["free"] = spawnsystem.ispawn_teammask_free;
	all = spawnsystem.ispawn_teammask_free;
	count = 1;
	foreach(team in level.teams)
	{
		spawnsystem.ispawn_teammask[team] = 1 << count;
		all = all | spawnsystem.ispawn_teammask[team];
		count++;
	}
	spawnsystem.ispawn_teammask["all"] = all;
}

/*
	Name: on_player_connecting
	Namespace: spawning
	Checksum: 0x5D0EB288
	Offset: 0x7A8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function on_player_connecting()
{
	level endon(#"game_ended");
	self setentertime(gettime());
	callback::on_spawned(&on_player_spawned);
	callback::on_joined_team(&on_joined_team);
	self thread ongrenadethrow();
}

/*
	Name: on_player_spawned
	Namespace: spawning
	Checksum: 0x7132A790
	Offset: 0x830
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	for(;;)
	{
		self waittill(#"spawned_player");
		self enable_player_influencers(1);
		self thread ondeath();
	}
}

/*
	Name: ondeath
	Namespace: spawning
	Checksum: 0xA7EB5A19
	Offset: 0x898
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function ondeath()
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	self waittill(#"death");
	self enable_player_influencers(0);
	level create_friendly_influencer("friend_dead", self.origin, self.team);
}

/*
	Name: on_joined_team
	Namespace: spawning
	Checksum: 0x4CF10D65
	Offset: 0x910
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function on_joined_team()
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	self player_influencers_set_team();
}

/*
	Name: ongrenadethrow
	Namespace: spawning
	Checksum: 0x4C5AD434
	Offset: 0x948
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function ongrenadethrow()
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	while(true)
	{
		self waittill(#"grenade_fire", grenade, weapon);
		level thread create_grenade_influencers(self.pers["team"], weapon, grenade);
		wait(0.05);
	}
}

/*
	Name: get_friendly_team_mask
	Namespace: spawning
	Checksum: 0x3463AC60
	Offset: 0x9D0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function get_friendly_team_mask(team)
{
	if(level.teambased)
	{
		team_mask = util::getteammask(team);
	}
	else
	{
		team_mask = level.spawnsystem.ispawn_teammask_free;
	}
	return team_mask;
}

/*
	Name: get_enemy_team_mask
	Namespace: spawning
	Checksum: 0xA05B3C3E
	Offset: 0xA30
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function get_enemy_team_mask(team)
{
	if(level.teambased)
	{
		team_mask = util::getotherteamsmask(team);
	}
	else
	{
		team_mask = level.spawnsystem.ispawn_teammask_free;
	}
	return team_mask;
}

/*
	Name: create_influencer
	Namespace: spawning
	Checksum: 0x865213FF
	Offset: 0xA90
	Size: 0x68
	Parameters: 3
	Flags: Linked
*/
function create_influencer(name, origin, team_mask)
{
	self.influencers[name] = addinfluencer(name, origin, team_mask);
	self thread watch_remove_influencer();
	return self.influencers[name];
}

/*
	Name: create_friendly_influencer
	Namespace: spawning
	Checksum: 0x275FDD8F
	Offset: 0xB00
	Size: 0x78
	Parameters: 3
	Flags: Linked
*/
function create_friendly_influencer(name, origin, team)
{
	team_mask = self get_friendly_team_mask(team);
	self.influencersfriendly[name] = create_influencer(name, origin, team_mask);
	return self.influencersfriendly[name];
}

/*
	Name: create_enemy_influencer
	Namespace: spawning
	Checksum: 0x89F20AE3
	Offset: 0xB80
	Size: 0x78
	Parameters: 3
	Flags: Linked
*/
function create_enemy_influencer(name, origin, team)
{
	team_mask = self get_enemy_team_mask(team);
	self.influencersenemy[name] = create_influencer(name, origin, team_mask);
	return self.influencersenemy[name];
}

/*
	Name: create_entity_influencer
	Namespace: spawning
	Checksum: 0x8C8245F8
	Offset: 0xC00
	Size: 0x50
	Parameters: 2
	Flags: Linked
*/
function create_entity_influencer(name, team_mask)
{
	self.influencers[name] = addentityinfluencer(name, self, team_mask);
	return self.influencers[name];
}

/*
	Name: create_entity_friendly_influencer
	Namespace: spawning
	Checksum: 0x1436A7CE
	Offset: 0xC58
	Size: 0x4A
	Parameters: 1
	Flags: None
*/
function create_entity_friendly_influencer(name)
{
	team_mask = self get_friendly_team_mask();
	return self create_entity_masked_friendly_influencer(name, team_mask);
}

/*
	Name: create_entity_enemy_influencer
	Namespace: spawning
	Checksum: 0x205ED741
	Offset: 0xCB0
	Size: 0x4A
	Parameters: 1
	Flags: None
*/
function create_entity_enemy_influencer(name)
{
	team_mask = self get_enemy_team_mask();
	return self create_entity_masked_enemy_influencer(name, team_mask);
}

/*
	Name: create_entity_masked_friendly_influencer
	Namespace: spawning
	Checksum: 0x8376247B
	Offset: 0xD08
	Size: 0x50
	Parameters: 2
	Flags: Linked
*/
function create_entity_masked_friendly_influencer(name, team_mask)
{
	self.influencersfriendly[name] = self create_entity_influencer(name, team_mask);
	return self.influencersfriendly[name];
}

/*
	Name: create_entity_masked_enemy_influencer
	Namespace: spawning
	Checksum: 0xC0152F10
	Offset: 0xD60
	Size: 0x50
	Parameters: 2
	Flags: Linked
*/
function create_entity_masked_enemy_influencer(name, team_mask)
{
	self.influencersenemy[name] = self create_entity_influencer(name, team_mask);
	return self.influencersenemy[name];
}

/*
	Name: create_player_influencers
	Namespace: spawning
	Checksum: 0x67EB6933
	Offset: 0xDB8
	Size: 0x22C
	Parameters: 0
	Flags: Linked
*/
function create_player_influencers()
{
	/#
		assert(!isdefined(self.influencers));
	#/
	/#
		assert(!isdefined(self.influencers));
	#/
	if(!level.teambased)
	{
		team_mask = level.spawnsystem.ispawn_teammask_free;
		other_team_mask = level.spawnsystem.ispawn_teammask_free;
		weapon_team_mask = level.spawnsystem.ispawn_teammask_free;
	}
	else
	{
		if(isdefined(self.pers["team"]))
		{
			team = self.pers["team"];
			team_mask = util::getteammask(team);
			enemy_teams_mask = util::getotherteamsmask(team);
		}
		else
		{
			team_mask = 0;
			enemy_teams_mask = 0;
		}
	}
	angles = self.angles;
	origin = self.origin;
	up = (0, 0, 1);
	forward = (1, 0, 0);
	self.influencers = [];
	self.friendlyinfluencers = [];
	self.enemyinfluencers = [];
	self create_entity_masked_enemy_influencer("enemy", enemy_teams_mask);
	if(level.teambased)
	{
		self create_entity_masked_friendly_influencer("friend", team_mask);
	}
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator")
	{
		self enable_influencers(0);
	}
}

/*
	Name: remove_influencers
	Namespace: spawning
	Checksum: 0xA8693910
	Offset: 0xFF0
	Size: 0xC4
	Parameters: 0
	Flags: None
*/
function remove_influencers()
{
	foreach(influencer in self.influencers)
	{
		removeinfluencer(influencer);
	}
	self.influencers = [];
	if(isdefined(self.influencersfriendly))
	{
		self.influencersfriendly = [];
	}
	if(isdefined(self.influencersenemy))
	{
		self.influencersenemy = [];
	}
}

/*
	Name: watch_remove_influencer
	Namespace: spawning
	Checksum: 0xEF7624D3
	Offset: 0x10C0
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function watch_remove_influencer()
{
	self endon(#"death");
	self notify(#"watch_remove_influencer");
	self endon(#"watch_remove_influencer");
	self waittill(#"influencer_removed", index);
	arrayremovevalue(self.influencers, index);
	arrayremovevalue(self.influencersfriendly, index);
	arrayremovevalue(self.influencersenemy, index);
	self thread watch_remove_influencer();
}

/*
	Name: enable_influencers
	Namespace: spawning
	Checksum: 0x13865551
	Offset: 0x1180
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function enable_influencers(enabled)
{
	foreach(influencer in self.influencers)
	{
		enableinfluencer(influencer, enabled);
	}
}

/*
	Name: enable_player_influencers
	Namespace: spawning
	Checksum: 0xBD42F983
	Offset: 0x1228
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function enable_player_influencers(enabled)
{
	if(!isdefined(self.influencers))
	{
		self create_player_influencers();
	}
	self enable_influencers(enabled);
}

/*
	Name: player_influencers_set_team
	Namespace: spawning
	Checksum: 0xFD2B9C69
	Offset: 0x1278
	Size: 0x1CA
	Parameters: 0
	Flags: Linked
*/
function player_influencers_set_team()
{
	if(!level.teambased)
	{
		team_mask = level.spawnsystem.ispawn_teammask_free;
		enemy_teams_mask = level.spawnsystem.ispawn_teammask_free;
	}
	else
	{
		team = self.pers["team"];
		team_mask = util::getteammask(team);
		enemy_teams_mask = util::getotherteamsmask(team);
	}
	if(isdefined(self.influencersfriendly))
	{
		foreach(influencer in self.influencersfriendly)
		{
			setinfluencerteammask(influencer, team_mask);
		}
	}
	if(isdefined(self.influencersenemy))
	{
		foreach(influencer in self.influencersenemy)
		{
			setinfluencerteammask(influencer, enemy_teams_mask);
		}
	}
}

/*
	Name: create_grenade_influencers
	Namespace: spawning
	Checksum: 0x8BE8A0B0
	Offset: 0x1450
	Size: 0x114
	Parameters: 3
	Flags: Linked
*/
function create_grenade_influencers(parent_team, weapon, grenade)
{
	pixbeginevent("create_grenade_influencers");
	spawn_influencer = weapon.spawninfluencer;
	if(isdefined(grenade.origin) && spawn_influencer != "")
	{
		if(!level.teambased)
		{
			weapon_team_mask = level.spawnsystem.ispawn_teammask_free;
		}
		else
		{
			weapon_team_mask = util::getotherteamsmask(parent_team);
			if(level.friendlyfire)
			{
				weapon_team_mask = weapon_team_mask | util::getteammask(parent_team);
			}
		}
		grenade create_entity_masked_enemy_influencer(spawn_influencer, weapon_team_mask);
	}
	pixendevent();
}

/*
	Name: create_map_placed_influencers
	Namespace: spawning
	Checksum: 0x8DFF2EB
	Offset: 0x1570
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function create_map_placed_influencers()
{
	staticinfluencerents = getentarray("mp_uspawn_influencer", "classname");
	for(i = 0; i < staticinfluencerents.size; i++)
	{
		staticinfluencerent = staticinfluencerents[i];
		create_map_placed_influencer(staticinfluencerent);
	}
}

/*
	Name: create_map_placed_influencer
	Namespace: spawning
	Checksum: 0x1DF0B7
	Offset: 0x1600
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function create_map_placed_influencer(influencer_entity)
{
	influencer_id = -1;
	if(isdefined(influencer_entity.script_noteworty))
	{
		team_mask = util::getteammask(influencer_entity.script_team);
		level create_enemy_influencer(influencer_entity.script_noteworty, influencer_entity.origin, team_mask);
	}
	else
	{
		/#
			assertmsg("");
		#/
	}
	return influencer_id;
}

/*
	Name: updateallspawnpoints
	Namespace: spawning
	Checksum: 0xDD5D62C1
	Offset: 0x16B8
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function updateallspawnpoints()
{
	foreach(team in level.teams)
	{
		gatherspawnpoints(team);
	}
	spawnlogic::clearspawnpoints();
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			spawnlogic::addspawnpoints(team, level.unified_spawn_points[team].a);
		}
	}
	else
	{
		foreach(team in level.teams)
		{
			spawnlogic::addspawnpoints("free", level.unified_spawn_points[team].a);
		}
	}
	remove_unused_spawn_entities();
}

/*
	Name: onspawnplayer_unified
	Namespace: spawning
	Checksum: 0x53C3D24F
	Offset: 0x18B0
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function onspawnplayer_unified(predictedspawn = 0)
{
	/#
		if(getdvarint("") != 0)
		{
			spawn_point = get_debug_spawnpoint(self);
			self spawn(spawn_point.origin, spawn_point.angles);
			return;
		}
	#/
	use_new_spawn_system = 0;
	initial_spawn = 1;
	if(isdefined(self.uspawn_already_spawned))
	{
		initial_spawn = !self.uspawn_already_spawned;
	}
	if(level.usestartspawns)
	{
		use_new_spawn_system = 0;
	}
	if(level.gametype == "sd")
	{
		use_new_spawn_system = 0;
	}
	util::set_dvar_if_unset("scr_spawn_force_unified", "0");
	[[level.onspawnplayer]](predictedspawn);
	if(!predictedspawn)
	{
		self.uspawn_already_spawned = 1;
	}
}

/*
	Name: getspawnpoint
	Namespace: spawning
	Checksum: 0x82C1BC6E
	Offset: 0x1A00
	Size: 0x148
	Parameters: 2
	Flags: None
*/
function getspawnpoint(player_entity, predictedspawn = 0)
{
	if(level.teambased)
	{
		point_team = player_entity.pers["team"];
		influencer_team = player_entity.pers["team"];
	}
	else
	{
		point_team = "free";
		influencer_team = "free";
	}
	if(level.teambased && isdefined(game["switchedsides"]) && game["switchedsides"] && level.spawnsystem.unifiedsideswitching)
	{
		point_team = util::getotherteam(point_team);
	}
	best_spawn = get_best_spawnpoint(point_team, influencer_team, player_entity, predictedspawn);
	if(!predictedspawn)
	{
		player_entity.last_spawn_origin = best_spawn["origin"];
	}
	return best_spawn;
}

/*
	Name: get_debug_spawnpoint
	Namespace: spawning
	Checksum: 0x4D4178F9
	Offset: 0x1B50
	Size: 0x27A
	Parameters: 1
	Flags: Linked
*/
function get_debug_spawnpoint(player)
{
	if(level.teambased)
	{
		team = player.pers["team"];
	}
	else
	{
		team = "free";
	}
	index = level.test_spawn_point_index;
	level.test_spawn_point_index++;
	if(team == "free")
	{
		spawn_counts = 0;
		foreach(team in level.teams)
		{
			spawn_counts = spawn_counts + level.unified_spawn_points[team].a.size;
		}
		if(level.test_spawn_point_index >= spawn_counts)
		{
			level.test_spawn_point_index = 0;
		}
		count = 0;
		foreach(team in level.teams)
		{
			size = level.unified_spawn_points[team].a.size;
			if(level.test_spawn_point_index < (count + size))
			{
				return level.unified_spawn_points[team].a[level.test_spawn_point_index - count];
			}
			count = count + size;
		}
	}
	else
	{
		if(level.test_spawn_point_index >= level.unified_spawn_points[team].a.size)
		{
			level.test_spawn_point_index = 0;
		}
		return level.unified_spawn_points[team].a[level.test_spawn_point_index];
	}
}

/*
	Name: get_best_spawnpoint
	Namespace: spawning
	Checksum: 0x57D47B9D
	Offset: 0x1DD8
	Size: 0xE8
	Parameters: 4
	Flags: Linked
*/
function get_best_spawnpoint(point_team, influencer_team, player, predictedspawn)
{
	if(level.teambased)
	{
		vis_team_mask = util::getotherteamsmask(player.pers["team"]);
	}
	else
	{
		vis_team_mask = level.spawnsystem.ispawn_teammask_free;
	}
	spawn_point = getbestspawnpoint(point_team, influencer_team, vis_team_mask, player, predictedspawn);
	if(!predictedspawn)
	{
		bbprint("mpspawnpointsused", "reason %s x %d y %d z %d", "point used", spawn_point["origin"]);
	}
	return spawn_point;
}

/*
	Name: gatherspawnpoints
	Namespace: spawning
	Checksum: 0xDF2D315
	Offset: 0x1EC8
	Size: 0xC2
	Parameters: 1
	Flags: Linked
*/
function gatherspawnpoints(player_team)
{
	if(!isdefined(level.unified_spawn_points))
	{
		level.unified_spawn_points = [];
	}
	else if(isdefined(level.unified_spawn_points[player_team]))
	{
		return level.unified_spawn_points[player_team];
	}
	spawn_entities_s = util::spawn_array_struct();
	spawn_entities_s.a = spawnlogic::getteamspawnpoints(player_team);
	if(!isdefined(spawn_entities_s.a))
	{
		spawn_entities_s.a = [];
	}
	level.unified_spawn_points[player_team] = spawn_entities_s;
	return spawn_entities_s;
}

/*
	Name: is_hardcore
	Namespace: spawning
	Checksum: 0xF710A2C9
	Offset: 0x1F98
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function is_hardcore()
{
	return isdefined(level.hardcoremode) && level.hardcoremode;
}

/*
	Name: teams_have_enmity
	Namespace: spawning
	Checksum: 0x7ED98DDC
	Offset: 0x1FB8
	Size: 0x72
	Parameters: 2
	Flags: None
*/
function teams_have_enmity(team1, team2)
{
	if(!isdefined(team1) || !isdefined(team2) || level.gametype == "dm")
	{
		return 1;
	}
	return team1 != "neutral" && team2 != "neutral" && team1 != team2;
}

/*
	Name: remove_unused_spawn_entities
	Namespace: spawning
	Checksum: 0x2C185004
	Offset: 0x2038
	Size: 0x22E
	Parameters: 0
	Flags: Linked
*/
function remove_unused_spawn_entities()
{
	spawn_entity_types = [];
	spawn_entity_types[spawn_entity_types.size] = "mp_dm_spawn";
	spawn_entity_types[spawn_entity_types.size] = "mp_tdm_spawn_allies_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_tdm_spawn_axis_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_tdm_spawn";
	spawn_entity_types[spawn_entity_types.size] = "mp_ctf_spawn_allies_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_ctf_spawn_axis_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_ctf_spawn_allies";
	spawn_entity_types[spawn_entity_types.size] = "mp_ctf_spawn_axis";
	spawn_entity_types[spawn_entity_types.size] = "mp_dom_spawn_allies_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_dom_spawn_axis_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_dom_spawn";
	spawn_entity_types[spawn_entity_types.size] = "mp_sab_spawn_allies_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_sab_spawn_axis_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_sab_spawn_allies";
	spawn_entity_types[spawn_entity_types.size] = "mp_sab_spawn_axis";
	spawn_entity_types[spawn_entity_types.size] = "mp_sd_spawn_attacker";
	spawn_entity_types[spawn_entity_types.size] = "mp_sd_spawn_defender";
	spawn_entity_types[spawn_entity_types.size] = "mp_twar_spawn_axis_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_twar_spawn_allies_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_twar_spawn";
	for(i = 0; i < spawn_entity_types.size; i++)
	{
		if(spawn_point_class_name_being_used(spawn_entity_types[i]))
		{
			continue;
		}
		spawnpoints = spawnlogic::getspawnpointarray(spawn_entity_types[i]);
		delete_all_spawns(spawnpoints);
	}
}

/*
	Name: delete_all_spawns
	Namespace: spawning
	Checksum: 0xCDE1D01D
	Offset: 0x2270
	Size: 0x56
	Parameters: 1
	Flags: Linked
*/
function delete_all_spawns(spawnpoints)
{
	for(i = 0; i < spawnpoints.size; i++)
	{
		spawnpoints[i] delete();
	}
}

/*
	Name: spawn_point_class_name_being_used
	Namespace: spawning
	Checksum: 0xC47E94B0
	Offset: 0x22D0
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function spawn_point_class_name_being_used(name)
{
	if(!isdefined(level.spawn_point_class_names))
	{
		return false;
	}
	for(i = 0; i < level.spawn_point_class_names.size; i++)
	{
		if(level.spawn_point_class_names[i] == name)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: codecallback_updatespawnpoints
	Namespace: spawning
	Checksum: 0x6F654D0A
	Offset: 0x2340
	Size: 0xA4
	Parameters: 0
	Flags: None
*/
function codecallback_updatespawnpoints()
{
	foreach(team in level.teams)
	{
		spawnlogic::rebuildspawnpoints(team);
	}
	level.unified_spawn_points = undefined;
	updateallspawnpoints();
}

/*
	Name: initialspawnprotection
	Namespace: spawning
	Checksum: 0xA0A91454
	Offset: 0x23F0
	Size: 0xCC
	Parameters: 2
	Flags: None
*/
function initialspawnprotection(specialtyname, spawnmonitorspeed)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(!isdefined(level.spawnprotectiontime) || level.spawnprotectiontime == 0)
	{
		return;
	}
	if(specialtyname == "specialty_nottargetedbyairsupport")
	{
		self.specialty_nottargetedbyairsupport = 1;
		wait(level.spawnprotectiontime);
		self.specialty_nottargetedbyairsupport = undefined;
	}
	else if(!self hasperk(specialtyname))
	{
		self setperk(specialtyname);
		wait(level.spawnprotectiontime);
		self unsetperk(specialtyname);
	}
}

