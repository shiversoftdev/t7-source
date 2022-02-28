// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_callbacks;
#using scripts\cp\_laststand;
#using scripts\cp\_tacticalinsertion;
#using scripts\cp\_util;
#using scripts\cp\gametypes\_spawnlogic;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_tacticalinsertion;

#namespace spawning;

/*
	Name: __init__sytem__
	Namespace: spawning
	Checksum: 0x540FC76F
	Offset: 0x3D0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("spawning", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: spawning
	Checksum: 0xB3039495
	Offset: 0x410
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level init_spawn_system();
	level.recently_deceased = [];
	foreach(team in level.teams)
	{
		level.recently_deceased[team] = util::spawn_array_struct();
	}
	callback::on_connecting(&onplayerconnect);
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
	Checksum: 0x9A62A900
	Offset: 0x608
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
	Name: onplayerconnect
	Namespace: spawning
	Checksum: 0x8581FB98
	Offset: 0x7C8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect()
{
	level endon(#"game_ended");
	self setentertime(gettime());
	self thread onplayerspawned();
	self thread onteamchange();
	self thread ongrenadethrow();
}

/*
	Name: onplayerspawned
	Namespace: spawning
	Checksum: 0x74004CDA
	Offset: 0x840
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function onplayerspawned()
{
	self endon(#"disconnect");
	self endon(#"killspawnmonitor");
	level endon(#"game_ended");
	self flag::init("player_has_red_flashing_overlay");
	self flag::init("player_is_invulnerable");
	for(;;)
	{
		self waittill(#"spawned_player");
		if(isdefined(self.pers["hasRadar"]) && self.pers["hasRadar"])
		{
			self.hasspyplane = 1;
		}
		self enable_player_influencers(1);
		self thread gameskill::playerhealthregen();
		self thread ondeath();
		self laststand::revive_hud_create();
	}
}

/*
	Name: ondeath
	Namespace: spawning
	Checksum: 0xCB9A2035
	Offset: 0x958
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function ondeath()
{
	self endon(#"disconnect");
	self endon(#"killspawnmonitor");
	level endon(#"game_ended");
	self waittill(#"death");
	self enable_player_influencers(0);
	level create_friendly_influencer("friend_dead", self.origin, self.team);
}

/*
	Name: onteamchange
	Namespace: spawning
	Checksum: 0x532D9359
	Offset: 0x9E0
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function onteamchange()
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	self endon(#"killteamchangemonitor");
	while(true)
	{
		self waittill(#"joined_team");
		self player_influencers_set_team();
		wait(0.05);
	}
}

/*
	Name: ongrenadethrow
	Namespace: spawning
	Checksum: 0xB030B128
	Offset: 0xA48
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function ongrenadethrow()
{
	self endon(#"disconnect");
	self endon(#"killgrenademonitor");
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
	Checksum: 0x440CA423
	Offset: 0xAE0
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
	Checksum: 0xA92E677C
	Offset: 0xB40
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
	Checksum: 0x859F2FAC
	Offset: 0xBA0
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
	Checksum: 0x369DE698
	Offset: 0xC10
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
	Checksum: 0xCE625553
	Offset: 0xC90
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
	Checksum: 0x4142A6B8
	Offset: 0xD10
	Size: 0x60
	Parameters: 2
	Flags: Linked
*/
function create_entity_influencer(name, team_mask)
{
	self.influencers[name] = addentityinfluencer(name, self, team_mask);
	self thread watch_remove_influencer();
	return self.influencers[name];
}

/*
	Name: create_entity_friendly_influencer
	Namespace: spawning
	Checksum: 0xACFB3DB
	Offset: 0xD78
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
	Checksum: 0x87F6F8FD
	Offset: 0xDD0
	Size: 0x52
	Parameters: 2
	Flags: Linked
*/
function create_entity_enemy_influencer(name, team)
{
	team_mask = self get_enemy_team_mask(team);
	return self create_entity_masked_enemy_influencer(name, team_mask);
}

/*
	Name: create_entity_masked_friendly_influencer
	Namespace: spawning
	Checksum: 0xBD462A64
	Offset: 0xE30
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
	Checksum: 0x5F67B743
	Offset: 0xE88
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
	Checksum: 0x4B5B2F5C
	Offset: 0xEE0
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
	Checksum: 0x7ABEF93A
	Offset: 0x1118
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
	Checksum: 0x20E411C5
	Offset: 0x11E8
	Size: 0xC4
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
	if(isdefined(self.influencersfriendly))
	{
		arrayremovevalue(self.influencersfriendly, index);
	}
	if(isdefined(self.influencersenemy))
	{
		arrayremovevalue(self.influencersenemy, index);
	}
	self thread watch_remove_influencer();
}

/*
	Name: enable_influencers
	Namespace: spawning
	Checksum: 0x569707BD
	Offset: 0x12B8
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
	Checksum: 0xE7718DE5
	Offset: 0x1360
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
	Checksum: 0x2C59CBAF
	Offset: 0x13B0
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
	Checksum: 0xE7627E1E
	Offset: 0x1588
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
	Checksum: 0x977BE2DA
	Offset: 0x16A8
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
	Checksum: 0x26A664DC
	Offset: 0x1738
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
	Checksum: 0xB6F71348
	Offset: 0x17F0
	Size: 0x2FA
	Parameters: 0
	Flags: Linked
*/
function updateallspawnpoints()
{
	foreach(team in level.teams)
	{
		function_db51ac16(team);
	}
	foreach(team in level.teams)
	{
		if(level.unified_spawn_points[team].a.size > 254)
		{
			level.unified_spawn_points[team].b = array::clamp_size(array::randomize(level.unified_spawn_points[team].a), 254);
			continue;
		}
		level.unified_spawn_points[team].b = level.unified_spawn_points[team].a;
	}
	clearspawnpoints();
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			addspawnpoints(team, level.unified_spawn_points[team].b);
		}
	}
	else
	{
		foreach(team in level.teams)
		{
			addspawnpoints("free", level.unified_spawn_points[team].b);
		}
	}
}

/*
	Name: onspawnplayer_unified
	Namespace: spawning
	Checksum: 0x3668EBCC
	Offset: 0x1AF8
	Size: 0x338
	Parameters: 1
	Flags: None
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
	use_new_spawn_system = 1;
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
	spawnoverride = self tacticalinsertion::overridespawn(predictedspawn);
	if(use_new_spawn_system || getdvarint("scr_spawn_force_unified") != 0)
	{
		if(!spawnoverride)
		{
			spawn_point = getspawnpoint(self, predictedspawn);
			if(isdefined(spawn_point))
			{
				origin = spawn_point["origin"];
				angles = spawn_point["angles"];
				if(predictedspawn)
				{
					self predictspawnpoint(origin, angles);
				}
				else
				{
					level create_enemy_influencer("enemy_spawn", origin, self.pers["team"]);
					self spawn(origin, angles);
				}
			}
			else
			{
				/#
					println("");
				#/
				callback::abort_level();
			}
		}
		else if(predictedspawn && isdefined(self.tacticalinsertion))
		{
			self predictspawnpoint(self.tacticalinsertion.origin, self.tacticalinsertion.angles);
		}
		if(!predictedspawn)
		{
			self.lastspawntime = gettime();
			self enable_player_influencers(1);
		}
	}
	else if(!spawnoverride)
	{
		[[level.onspawnplayer]](predictedspawn);
	}
	if(!predictedspawn)
	{
		self.uspawn_already_spawned = 1;
	}
}

/*
	Name: getspawnpoint
	Namespace: spawning
	Checksum: 0xD9DF1758
	Offset: 0x1E40
	Size: 0x148
	Parameters: 2
	Flags: Linked
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
	Checksum: 0x3954692E
	Offset: 0x1F90
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
	Checksum: 0xC03231C1
	Offset: 0x2218
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
	Name: function_db51ac16
	Namespace: spawning
	Checksum: 0x4A8E881A
	Offset: 0x2308
	Size: 0xC2
	Parameters: 1
	Flags: Linked
*/
function function_db51ac16(player_team)
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
	spawn_entities_s.a = spawnlogic::get_team_spawnpoints(player_team);
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
	Checksum: 0x2B1CA5F9
	Offset: 0x23D8
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
	Checksum: 0x3E96C146
	Offset: 0x23F8
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
	Name: delete_all_spawns
	Namespace: spawning
	Checksum: 0xFAC80733
	Offset: 0x2478
	Size: 0x56
	Parameters: 1
	Flags: None
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
	Checksum: 0x2D1FB159
	Offset: 0x24D8
	Size: 0x68
	Parameters: 1
	Flags: None
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
	Checksum: 0xD0D50385
	Offset: 0x2548
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function codecallback_updatespawnpoints()
{
	foreach(team in level.teams)
	{
		spawnlogic::rebuild_spawn_points(team);
	}
	level.unified_spawn_points = undefined;
	updateallspawnpoints();
}

/*
	Name: getteamstartspawnname
	Namespace: spawning
	Checksum: 0xFFECC0DB
	Offset: 0x25F8
	Size: 0x158
	Parameters: 2
	Flags: Linked
*/
function getteamstartspawnname(team, spawnpointnamebase)
{
	spawn_point_team_name = team;
	if(!level.multiteam && game["switchedsides"])
	{
		spawn_point_team_name = util::getotherteam(team);
	}
	if(level.multiteam)
	{
		if(team == "axis")
		{
			spawn_point_team_name = "team1";
		}
		else if(team == "allies")
		{
			spawn_point_team_name = "team2";
		}
		if(!util::isoneround())
		{
			number = int(getsubstr(spawn_point_team_name, 4, 5)) - 1;
			number = ((number + game["roundsplayed"]) % level.teams.size) + 1;
			spawn_point_team_name = "team" + number;
		}
	}
	return ((spawnpointnamebase + "_") + spawn_point_team_name) + "_start";
}

/*
	Name: gettdmstartspawnname
	Namespace: spawning
	Checksum: 0x9DF47E96
	Offset: 0x2758
	Size: 0x2A
	Parameters: 1
	Flags: None
*/
function gettdmstartspawnname(team)
{
	return getteamstartspawnname(team, "mp_tdm_spawn");
}

