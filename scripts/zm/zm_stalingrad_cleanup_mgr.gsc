// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace stalingrad_cleanup;

/*
	Name: __init__sytem__
	Namespace: stalingrad_cleanup
	Checksum: 0x69E8433
	Offset: 0x1E8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("stalingrad_cleanup", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: stalingrad_cleanup
	Checksum: 0xCB54C765
	Offset: 0x230
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
	Namespace: stalingrad_cleanup
	Checksum: 0xF3B1B5CC
	Offset: 0x248
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level thread cleanup_main();
}

/*
	Name: force_check_now
	Namespace: stalingrad_cleanup
	Checksum: 0x2AD5EB8F
	Offset: 0x270
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
	Namespace: stalingrad_cleanup
	Checksum: 0x520C75E1
	Offset: 0x290
	Size: 0x20E
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
		n_override_cleanup_dist_sq = undefined;
		n_next_eval = n_next_eval + 3000;
		a_ai_enemies = getaiteamarray("axis");
		foreach(ai_enemy in a_ai_enemies)
		{
			if(level.n_cleanups_processed_this_frame >= 1)
			{
				level.n_cleanups_processed_this_frame = 0;
				util::wait_network_frame();
			}
			ai_enemy do_cleanup_check(n_override_cleanup_dist_sq);
		}
	}
}

/*
	Name: do_cleanup_check
	Namespace: stalingrad_cleanup
	Checksum: 0x83C9465A
	Offset: 0x4A8
	Size: 0x274
	Parameters: 1
	Flags: Linked
*/
function do_cleanup_check(n_override_cleanup_dist)
{
	if(!isalive(self))
	{
		return;
	}
	if(isdefined(self.func_custom_cleanup_check))
	{
		return [[self.func_custom_cleanup_check]]();
	}
	if(self.b_ignore_cleanup === 1)
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
		if(isdefined(n_override_cleanup_dist))
		{
			n_cleanup_dist_sq = n_override_cleanup_dist;
		}
		else
		{
			if(isdefined(e_closest_player) && player_ahead_of_me(e_closest_player))
			{
				n_cleanup_dist_sq = 189225;
			}
			else
			{
				n_cleanup_dist_sq = 250000;
			}
		}
		if(n_dist_sq_min >= n_cleanup_dist_sq)
		{
			self thread cleanup_zombie();
		}
	}
}

/*
	Name: cleanup_zombie
	Namespace: stalingrad_cleanup
	Checksum: 0x216E4666
	Offset: 0x728
	Size: 0x3CC
	Parameters: 1
	Flags: Linked
*/
function cleanup_zombie(var_1503b3f8 = 1)
{
	if(isdefined(self.in_the_ground) && self.in_the_ground || (isdefined(self.var_f3f07a33) && self.var_f3f07a33))
	{
		return;
	}
	if(var_1503b3f8)
	{
		foreach(player in level.players)
		{
			var_c3cc60d3 = 0;
			var_4d53d2ae = 0;
			if(isdefined(player.zone_name))
			{
				if(player.zone_name == "pavlovs_A_zone" || player.zone_name == "pavlovs_B_zone" || player.zone_name == "pavlovs_C_zone")
				{
					var_c3cc60d3 = 1;
				}
			}
			if(isdefined(self.zone_name))
			{
				if(self.zone_name == "pavlovs_A_zone" || self.zone_name == "pavlovs_B_zone" || self.zone_name == "pavlovs_C_zone")
				{
					var_4d53d2ae = 1;
				}
			}
			if(isdefined(self.var_edfdda83) && self.var_edfdda83)
			{
				var_4d53d2ae = 1;
			}
			if(var_c3cc60d3 != var_4d53d2ae)
			{
				continue;
			}
			if(player.sessionstate == "spectator")
			{
				continue;
			}
			if(self player_can_see_me(player))
			{
				return;
			}
		}
	}
	if(!(isdefined(self.exclude_cleanup_adding_to_total) && self.exclude_cleanup_adding_to_total))
	{
		level.zombie_total++;
		level.zombie_respawns++;
		if(self.health < self.maxhealth)
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
	}
	self zombie_utility::reset_attack_spot();
	self.var_4d11bb60 = 1;
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
	Namespace: stalingrad_cleanup
	Checksum: 0x28B3C664
	Offset: 0xB00
	Size: 0xD8
	Parameters: 1
	Flags: Linked, Private
*/
function private player_can_see_me(player)
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
	Namespace: stalingrad_cleanup
	Checksum: 0x9047645F
	Offset: 0xBE0
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
	Name: get_escape_position
	Namespace: stalingrad_cleanup
	Checksum: 0x94DF6DE3
	Offset: 0xCA0
	Size: 0xB4
	Parameters: 0
	Flags: None
*/
function get_escape_position()
{
	self endon(#"death");
	str_zone = self.zone_name;
	if(!isdefined(str_zone))
	{
		str_zone = self.zone_name;
	}
	if(isdefined(str_zone))
	{
		a_zones = get_adjacencies_to_zone(str_zone);
		a_wait_locations = get_wait_locations_in_zones(a_zones);
		s_farthest = self get_farthest_wait_location(a_wait_locations);
	}
	return s_farthest;
}

/*
	Name: get_adjacencies_to_zone
	Namespace: stalingrad_cleanup
	Checksum: 0x59D63F4A
	Offset: 0xD60
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
	Name: get_wait_locations_in_zones
	Namespace: stalingrad_cleanup
	Checksum: 0x6AF466AE
	Offset: 0xE88
	Size: 0xD2
	Parameters: 1
	Flags: Linked, Private
*/
function private get_wait_locations_in_zones(a_zones)
{
	a_wait_locations = [];
	foreach(zone in a_zones)
	{
		a_wait_locations = arraycombine(a_wait_locations, level.zones[zone].a_loc_types["wait_location"], 0, 0);
	}
	return a_wait_locations;
}

/*
	Name: get_farthest_wait_location
	Namespace: stalingrad_cleanup
	Checksum: 0xAE1EA513
	Offset: 0xF68
	Size: 0xD6
	Parameters: 1
	Flags: Linked, Private
*/
function private get_farthest_wait_location(a_wait_locations)
{
	if(!isdefined(a_wait_locations) || a_wait_locations.size == 0)
	{
		return undefined;
	}
	n_farthest_index = 0;
	n_distance_farthest = 0;
	for(i = 0; i < a_wait_locations.size; i++)
	{
		n_distance_sq = distancesquared(self.origin, a_wait_locations[i].origin);
		if(n_distance_sq > n_distance_farthest)
		{
			n_distance_farthest = n_distance_sq;
			n_farthest_index = i;
		}
	}
	return a_wait_locations[n_farthest_index];
}

/*
	Name: get_wait_locations_in_zone
	Namespace: stalingrad_cleanup
	Checksum: 0xDF5EEBA0
	Offset: 0x1048
	Size: 0x88
	Parameters: 1
	Flags: Linked, Private
*/
function private get_wait_locations_in_zone(zone)
{
	if(isdefined(level.zones[zone].a_loc_types["wait_location"]))
	{
		a_wait_locations = [];
		a_wait_locations = arraycombine(a_wait_locations, level.zones[zone].a_loc_types["wait_location"], 0, 0);
		return a_wait_locations;
	}
	return undefined;
}

/*
	Name: get_escape_position_in_current_zone
	Namespace: stalingrad_cleanup
	Checksum: 0x612642B6
	Offset: 0x10D8
	Size: 0x9C
	Parameters: 0
	Flags: Linked
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
		a_wait_locations = get_wait_locations_in_zone(str_zone);
		if(isdefined(a_wait_locations))
		{
			s_farthest = self get_farthest_wait_location(a_wait_locations);
		}
	}
	return s_farthest;
}

