// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_light_zombie;
#using scripts\zm\_zm_shadow_zombie;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace genesis_cleanup;

/*
	Name: __init__sytem__
	Namespace: genesis_cleanup
	Checksum: 0x432ACFAD
	Offset: 0x2B0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("genesis_cleanup", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: genesis_cleanup
	Checksum: 0xBDC857C7
	Offset: 0x2F8
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.n_cleanups_processed_this_frame = 0;
}

/*
	Name: __main__
	Namespace: genesis_cleanup
	Checksum: 0xEE15352E
	Offset: 0x310
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level thread cleanup_main();
	level.no_target_override = &no_target_override;
}

/*
	Name: force_check_now
	Namespace: genesis_cleanup
	Checksum: 0xC6097D
	Offset: 0x350
	Size: 0x12
	Parameters: 0
	Flags: None
*/
function force_check_now()
{
	level notify(#"pump_distance_check");
}

/*
	Name: cleanup_main
	Namespace: genesis_cleanup
	Checksum: 0xA6449552
	Offset: 0x370
	Size: 0x1FE
	Parameters: 0
	Flags: Linked, Private
*/
function private cleanup_main()
{
	n_next_eval = 0;
	while(true)
	{
		util::wait_network_frame();
		n_time = gettime();
		if(n_time < n_next_eval)
		{
			continue;
		}
		if(isdefined(level.n_cleanup_manager_restart_time))
		{
			n_current_time = gettime() / 1000;
			n_delta_time = n_current_time - level.n_cleanup_manager_restart_time;
			if(n_delta_time < 0)
			{
				continue;
			}
			level.n_cleanup_manager_restart_time = undefined;
		}
		n_round_time = (n_time - level.round_start_time) / 1000;
		if(level.round_number <= 5 && n_round_time < 30)
		{
			continue;
		}
		else if(level.round_number > 5 && n_round_time < 20)
		{
			continue;
		}
		n_next_eval = n_next_eval + 3000;
		a_ai_enemies = getaiteamarray("axis");
		foreach(ai_enemy in a_ai_enemies)
		{
			if(level.n_cleanups_processed_this_frame >= 1)
			{
				level.n_cleanups_processed_this_frame = 0;
				util::wait_network_frame();
			}
			ai_enemy do_cleanup_check();
		}
	}
}

/*
	Name: function_37a5b776
	Namespace: genesis_cleanup
	Checksum: 0x70B6F908
	Offset: 0x578
	Size: 0x200
	Parameters: 0
	Flags: Linked, Private
*/
function private function_37a5b776()
{
	var_a8951c29 = [];
	var_9e84b959 = array("start_island", "apothicon_island", "temple_island", "prototype_island", "asylum_island", "prison_island", "arena_island");
	for(i = 0; i < var_9e84b959.size; i++)
	{
		e_island = getent(var_9e84b959[i], "targetname");
		for(j = 0; j < level.activeplayers.size; j++)
		{
			if(!isalive(level.activeplayers[j]))
			{
				continue;
			}
			if(isdefined(level.activeplayers[j].is_flung) && level.activeplayers[j].is_flung)
			{
				return true;
			}
			if(level.activeplayers[j] istouching(e_island))
			{
				array::add(var_a8951c29, e_island, 0);
			}
		}
	}
	if(!var_a8951c29.size)
	{
		return true;
	}
	for(k = 0; k < var_a8951c29.size; k++)
	{
		if(self istouching(var_a8951c29[k]))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: do_cleanup_check
	Namespace: genesis_cleanup
	Checksum: 0x10C53B9
	Offset: 0x780
	Size: 0x2F4
	Parameters: 0
	Flags: Linked
*/
function do_cleanup_check()
{
	if(!isalive(self))
	{
		return;
	}
	if(self.archetype === "margwa" || self.archetype === "mechz")
	{
		return;
	}
	if(self.b_ignore_cleanup === 1)
	{
		return;
	}
	if(isdefined(self.b_teleporting) && self.b_teleporting)
	{
		return;
	}
	if(isdefined(self.traversal))
	{
		return;
	}
	if(!self function_37a5b776())
	{
		self thread function_b4d588f5();
		return;
	}
	if(isdefined(self.var_6d2a9142) && self.var_6d2a9142)
	{
		return;
	}
	n_time_alive = gettime() - self.spawn_time;
	if(n_time_alive < 5000)
	{
		return;
	}
	if(self.archetype === "zombie")
	{
		if(n_time_alive < 45000 && self.script_string !== "find_flesh" && self.completed_emerging_into_playable_area !== 1)
		{
			return;
		}
	}
	b_in_active_zone = self zm_zonemgr::entity_in_active_zone();
	level.n_cleanups_processed_this_frame++;
	if(!b_in_active_zone)
	{
		n_dist_sq_min = 10000000;
		e_closest_player = level.activeplayers[0];
		foreach(player in level.activeplayers)
		{
			n_dist_sq = distancesquared(self.origin, player.origin);
			if(n_dist_sq < n_dist_sq_min)
			{
				n_dist_sq_min = n_dist_sq;
				e_closest_player = player;
			}
		}
		if(isdefined(level.n_override_cleanup_dist_sq))
		{
			n_cleanup_dist_sq = level.n_override_cleanup_dist_sq;
		}
		else
		{
			if(isdefined(e_closest_player) && player_ahead_of_me(e_closest_player))
			{
				n_cleanup_dist_sq = 176400;
			}
			else
			{
				n_cleanup_dist_sq = 230400;
			}
		}
		if(n_dist_sq_min >= n_cleanup_dist_sq)
		{
			self thread delete_zombie_noone_looking();
		}
	}
}

/*
	Name: delete_zombie_noone_looking
	Namespace: genesis_cleanup
	Checksum: 0x3B20B840
	Offset: 0xA80
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function delete_zombie_noone_looking()
{
	if(isdefined(self.in_the_ground) && self.in_the_ground)
	{
		return;
	}
	foreach(player in level.players)
	{
		if(player.sessionstate == "spectator")
		{
			continue;
		}
		if(self player_can_see_me(player))
		{
			return;
		}
	}
	self thread function_b4d588f5();
}

/*
	Name: function_b4d588f5
	Namespace: genesis_cleanup
	Checksum: 0xBA8C5DAF
	Offset: 0xB68
	Size: 0x24C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_b4d588f5()
{
	if(!(isdefined(self.exclude_cleanup_adding_to_total) && self.exclude_cleanup_adding_to_total))
	{
		level.zombie_total++;
		level.zombie_respawns++;
		self.var_4d11bb60 = 1;
		if(isdefined(self.maxhealth) && self.health < self.maxhealth)
		{
			if(!isdefined(level.a_zombie_respawn_health[self.archetype]))
			{
				level.a_zombie_respawn_health[self.archetype] = [];
			}
			if(!isdefined(level.a_zombie_respawn_health[self.archetype]))
			{
				level.a_zombie_respawn_health[self.archetype] = [];
			}
			else if(!isarray(level.a_zombie_respawn_health[self.archetype]))
			{
				level.a_zombie_respawn_health[self.archetype] = array(level.a_zombie_respawn_health[self.archetype]);
			}
			level.a_zombie_respawn_health[self.archetype][level.a_zombie_respawn_health[self.archetype].size] = self.health;
		}
		if(isdefined(self.var_9a02a614))
		{
			if(!isdefined(level.a_zombie_respawn_type[self.var_9a02a614]))
			{
				level.a_zombie_respawn_type[self.var_9a02a614] = 0;
			}
			level.a_zombie_respawn_type[self.var_9a02a614]++;
		}
		else
		{
			if(!isdefined(level.a_zombie_respawn_type[self.archetype]))
			{
				level.a_zombie_respawn_type[self.archetype] = 0;
			}
			level.a_zombie_respawn_type[self.archetype]++;
		}
	}
	self zombie_utility::reset_attack_spot();
	self kill();
	wait(0.05);
	if(isdefined(self))
	{
		/#
			debugstar(self.origin, 1000, (1, 1, 1));
		#/
		self delete();
	}
}

/*
	Name: player_can_see_me
	Namespace: genesis_cleanup
	Checksum: 0x767AD3AA
	Offset: 0xDC0
	Size: 0xD8
	Parameters: 1
	Flags: Linked
*/
function player_can_see_me(player)
{
	v_player_angles = player getplayerangles();
	v_player_forward = anglestoforward(v_player_angles);
	v_player_to_self = self.origin - player getorigin();
	v_player_to_self = vectornormalize(v_player_to_self);
	n_dot = vectordot(v_player_forward, v_player_to_self);
	if(n_dot < 0.766)
	{
		return false;
	}
	return true;
}

/*
	Name: player_ahead_of_me
	Namespace: genesis_cleanup
	Checksum: 0xC377FD5A
	Offset: 0xEA0
	Size: 0xB4
	Parameters: 1
	Flags: Linked, Private
*/
function private player_ahead_of_me(player)
{
	v_player_angles = player getplayerangles();
	v_player_forward = anglestoforward(v_player_angles);
	v_dir = player getorigin() - self.origin;
	n_dot = vectordot(v_player_forward, v_dir);
	if(n_dot < 0)
	{
		return false;
	}
	return true;
}

/*
	Name: get_adjacencies_to_zone
	Namespace: genesis_cleanup
	Checksum: 0xCECCE33D
	Offset: 0xF60
	Size: 0x11E
	Parameters: 1
	Flags: Linked
*/
function get_adjacencies_to_zone(str_zone)
{
	a_adjacencies = [];
	a_adjacencies[0] = str_zone;
	a_adjacent_zones = getarraykeys(level.zones[str_zone].adjacent_zones);
	for(i = 0; i < a_adjacent_zones.size; i++)
	{
		if(level.zones[str_zone].adjacent_zones[a_adjacent_zones[i]].is_connected)
		{
			if(!isdefined(a_adjacencies))
			{
				a_adjacencies = [];
			}
			else if(!isarray(a_adjacencies))
			{
				a_adjacencies = array(a_adjacencies);
			}
			a_adjacencies[a_adjacencies.size] = a_adjacent_zones[i];
		}
	}
	return a_adjacencies;
}

/*
	Name: get_farthest_wait_location
	Namespace: genesis_cleanup
	Checksum: 0x1881BC16
	Offset: 0x1088
	Size: 0xD6
	Parameters: 1
	Flags: Linked, Private
*/
function private get_farthest_wait_location(var_aabb7ed9)
{
	if(!isdefined(var_aabb7ed9) || var_aabb7ed9.size == 0)
	{
		return undefined;
	}
	n_farthest_index = 0;
	n_distance_farthest = 0;
	for(i = 0; i < var_aabb7ed9.size; i++)
	{
		n_distance_sq = distancesquared(self.origin, var_aabb7ed9[i].origin);
		if(n_distance_sq > n_distance_farthest)
		{
			n_distance_farthest = n_distance_sq;
			n_farthest_index = i;
		}
	}
	return var_aabb7ed9[n_farthest_index];
}

/*
	Name: get_wait_locations_in_zone
	Namespace: genesis_cleanup
	Checksum: 0x6F28E452
	Offset: 0x1168
	Size: 0x88
	Parameters: 1
	Flags: Linked, Private
*/
function private get_wait_locations_in_zone(zone)
{
	if(isdefined(level.zones[zone].a_loc_types["wait_location"]))
	{
		var_aabb7ed9 = [];
		var_aabb7ed9 = arraycombine(var_aabb7ed9, level.zones[zone].a_loc_types["wait_location"], 0, 0);
		return var_aabb7ed9;
	}
	return undefined;
}

/*
	Name: get_escape_position_in_current_zone
	Namespace: genesis_cleanup
	Checksum: 0xF160FC8D
	Offset: 0x11F8
	Size: 0x9C
	Parameters: 0
	Flags: None
*/
function get_escape_position_in_current_zone()
{
	self endon(#"death");
	str_zone = self.zone_name;
	if(!isdefined(str_zone))
	{
		str_zone = self.zone_name;
	}
	if(isdefined(str_zone))
	{
		var_aabb7ed9 = get_wait_locations_in_zone(str_zone);
		if(isdefined(var_aabb7ed9))
		{
			s_farthest = self get_farthest_wait_location(var_aabb7ed9);
		}
	}
	return s_farthest;
}

/*
	Name: no_target_override
	Namespace: genesis_cleanup
	Checksum: 0x5DEC02F8
	Offset: 0x12A0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function no_target_override(ai_zombie)
{
	if(isdefined(self.b_zombie_path_bad) && self.b_zombie_path_bad)
	{
		return;
	}
	var_b52b26b9 = ai_zombie get_escape_position();
	ai_zombie thread function_dc683d01(var_b52b26b9);
}

/*
	Name: get_escape_position
	Namespace: genesis_cleanup
	Checksum: 0xBF29485A
	Offset: 0x1310
	Size: 0x146
	Parameters: 0
	Flags: Linked, Private
*/
function private get_escape_position()
{
	str_zone = zm_zonemgr::get_zone_from_position(self.origin + vectorscale((0, 0, 1), 32), 1);
	if(!isdefined(str_zone))
	{
		str_zone = self.zone_name;
	}
	if(isdefined(str_zone))
	{
		a_str_zones = get_adjacencies_to_zone(str_zone);
		var_aabb7ed9 = get_wait_locations_in_zones(a_str_zones);
		arraysortclosest(var_aabb7ed9, self.origin);
		var_aabb7ed9 = array::reverse(var_aabb7ed9);
		for(i = 0; i < var_aabb7ed9.size; i++)
		{
			if(var_aabb7ed9[i] function_eadbcbdb())
			{
				return var_aabb7ed9[i].origin;
			}
		}
	}
	return self.origin;
}

/*
	Name: get_wait_locations_in_zones
	Namespace: genesis_cleanup
	Checksum: 0x9DCF6784
	Offset: 0x1460
	Size: 0xD2
	Parameters: 1
	Flags: Linked, Private
*/
function private get_wait_locations_in_zones(a_str_zones)
{
	var_aabb7ed9 = [];
	foreach(str_zone in a_str_zones)
	{
		var_aabb7ed9 = arraycombine(var_aabb7ed9, level.zones[str_zone].a_loc_types["wait_location"], 0, 0);
	}
	return var_aabb7ed9;
}

/*
	Name: function_eadbcbdb
	Namespace: genesis_cleanup
	Checksum: 0xC861F7A5
	Offset: 0x1540
	Size: 0x5C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_eadbcbdb()
{
	if(!isdefined(self))
	{
		return false;
	}
	if(!ispointonnavmesh(self.origin) || !zm_utility::check_point_in_playable_area(self.origin))
	{
		return false;
	}
	return true;
}

/*
	Name: function_dc683d01
	Namespace: genesis_cleanup
	Checksum: 0x41928988
	Offset: 0x15A8
	Size: 0xCA
	Parameters: 1
	Flags: Linked, Private
*/
function private function_dc683d01(var_b52b26b9)
{
	self endon(#"death");
	self notify(#"stop_find_flesh");
	self notify(#"zombie_acquire_enemy");
	self.ignoreall = 1;
	self.b_zombie_path_bad = 1;
	self thread check_player_available();
	self setgoal(var_b52b26b9);
	self util::waittill_any_timeout(30, "goal", "reaquire_player", "death");
	self.ai_state = "find_flesh";
	self.ignoreall = 0;
	self.b_zombie_path_bad = undefined;
}

/*
	Name: check_player_available
	Namespace: genesis_cleanup
	Checksum: 0x76D5C3E4
	Offset: 0x1680
	Size: 0x78
	Parameters: 0
	Flags: Linked, Private
*/
function private check_player_available()
{
	self endon(#"death");
	while(isdefined(self.b_zombie_path_bad) && self.b_zombie_path_bad)
	{
		wait(randomfloatrange(0.2, 0.5));
		if(self can_zombie_see_any_player())
		{
			self.b_zombie_path_bad = undefined;
			self notify(#"reaquire_player");
			return;
		}
	}
}

/*
	Name: can_zombie_see_any_player
	Namespace: genesis_cleanup
	Checksum: 0x44747D87
	Offset: 0x1700
	Size: 0x80
	Parameters: 0
	Flags: Linked, Private
*/
function private can_zombie_see_any_player()
{
	for(i = 0; i < level.activeplayers.size; i++)
	{
		if(zombie_utility::is_player_valid(level.activeplayers[i]))
		{
			if(self function_ca420408(level.activeplayers[i]))
			{
				return true;
			}
		}
		wait(0.1);
	}
	return false;
}

/*
	Name: function_ca420408
	Namespace: genesis_cleanup
	Checksum: 0x165D5985
	Offset: 0x1788
	Size: 0xE6
	Parameters: 1
	Flags: Linked
*/
function function_ca420408(player)
{
	var_334f2464 = undefined;
	str_player_zone = undefined;
	var_334f2464 = zm_zonemgr::get_zone_from_position(self.origin + vectorscale((0, 0, 1), 32), 1);
	if(isdefined(player.zone_name))
	{
		a_str_zones = get_adjacencies_to_zone(player.zone_name);
		for(i = 0; i < a_str_zones.size; i++)
		{
			if(var_334f2464 === a_str_zones[i])
			{
				return true;
			}
		}
	}
	return false;
}

