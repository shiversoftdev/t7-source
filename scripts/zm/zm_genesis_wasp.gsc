// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_parasite;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_genesis_wasp;

/*
	Name: init
	Namespace: zm_genesis_wasp
	Checksum: 0x7301
	Offset: 0x748
	Size: 0x37C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.wasp_enabled = 1;
	level.wasp_rounds_enabled = 0;
	level.wasp_round_count = 1;
	level.wasp_spawners = [];
	level.a_wasp_priority_targets = [];
	level flag::init("wasp_round");
	level flag::init("wasp_round_in_progress");
	level.melee_range_sav = getdvarstring("ai_meleeRange");
	level.melee_width_sav = getdvarstring("ai_meleeWidth");
	level.melee_height_sav = getdvarstring("ai_meleeHeight");
	if(!isdefined(level.vsmgr_prio_overlay_zm_wasp_round))
	{
		level.vsmgr_prio_overlay_zm_wasp_round = 22;
	}
	clientfield::register("toplayer", "parasite_round_fx", 15000, 1, "counter");
	clientfield::register("toplayer", "parasite_round_ring_fx", 15000, 1, "counter");
	clientfield::register("world", "toggle_on_parasite_fog", 15000, 2, "int");
	clientfield::register("toplayer", "genesis_parasite_damage", 15000, 1, "counter");
	visionset_mgr::register_info("visionset", "zm_wasp_round_visionset", 15000, level.vsmgr_prio_overlay_zm_wasp_round, 31, 0, &visionset_mgr::ramp_in_out_thread, 0);
	level._effect["lightning_wasp_spawn"] = "zombie/fx_parasite_spawn_buildup_zod_zmb";
	callback::on_connect(&watch_player_melee_events);
	callback::on_spawned(&genesis_parasite_damage);
	callback::on_ai_spawned(&function_a0684cd2);
	level thread aat::register_immunity("zm_aat_blast_furnace", "parasite", 1, 1, 1);
	level thread aat::register_immunity("zm_aat_dead_wire", "parasite", 1, 1, 1);
	level thread aat::register_immunity("zm_aat_fire_works", "parasite", 1, 1, 1);
	level thread aat::register_immunity("zm_aat_thunder_wall", "parasite", 1, 1, 1);
	level thread aat::register_immunity("zm_aat_turned", "parasite", 1, 1, 1);
	wasp_spawner_init();
	function_eb2708d6();
}

/*
	Name: function_a0684cd2
	Namespace: zm_genesis_wasp
	Checksum: 0x111FE24F
	Offset: 0xAD0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_a0684cd2()
{
	if(self.archetype == "parasite")
	{
		self.squelch_damage_overlay = 1;
		self.idgun_death_speed = 4;
		self.ignore_zombie_lift = 1;
		self.is_target_valid_cb = &function_64f645c3;
	}
}

/*
	Name: function_64f645c3
	Namespace: zm_genesis_wasp
	Checksum: 0x4B5794B9
	Offset: 0xB30
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_64f645c3(target)
{
	self.zone_name = zm_utility::get_current_zone();
	if(isdefined(self.zone_name) && self.zone_name == "apothicon_interior_zone")
	{
		if(isdefined(target.zone_name) && target.zone_name != "apothicon_interior_zone")
		{
			return false;
		}
	}
	return true;
}

/*
	Name: enable_wasp_rounds
	Namespace: zm_genesis_wasp
	Checksum: 0x8A9954F4
	Offset: 0xBB8
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function enable_wasp_rounds()
{
	level.wasp_rounds_enabled = 1;
	if(!isdefined(level.wasp_round_track_override))
	{
		level.wasp_round_track_override = &wasp_round_tracker;
	}
	level thread [[level.wasp_round_track_override]]();
}

/*
	Name: wasp_spawner_init
	Namespace: zm_genesis_wasp
	Checksum: 0xA1CBF790
	Offset: 0xC08
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function wasp_spawner_init()
{
	level.wasp_spawners = getentarray("zombie_wasp_spawner", "script_noteworthy");
	if(level.wasp_spawners.size == 0)
	{
		return;
	}
	for(i = 0; i < level.wasp_spawners.size; i++)
	{
		if(zm_spawner::is_spawner_targeted_by_blocker(level.wasp_spawners[i]))
		{
			level.wasp_spawners[i].is_enabled = 0;
			continue;
		}
		level.wasp_spawners[i].is_enabled = 1;
		level.wasp_spawners[i].script_forcespawn = 1;
	}
	/#
		assert(level.wasp_spawners.size > 0);
	#/
	level.wasp_health = 100;
	vehicle::add_main_callback("spawner_bo3_parasite_enemy_tool", &wasp_init);
}

/*
	Name: function_eb2708d6
	Namespace: zm_genesis_wasp
	Checksum: 0x4A9D9B92
	Offset: 0xD58
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_eb2708d6()
{
	level.var_c200ab6 = getentarray("zombie_wasp_elite_spawner", "script_noteworthy");
	for(i = 0; i < level.var_c200ab6.size; i++)
	{
		level.var_c200ab6[i].is_enabled = 1;
		level.var_c200ab6[i].script_forcespawn = 1;
	}
	/#
		assert(level.var_c200ab6.size > 0);
	#/
	level.wasp_health = 100;
	vehicle::add_main_callback("spawner_bo3_parasite_elite_enemy_tool", &function_7353fa6d);
}

/*
	Name: get_current_wasp_count
	Namespace: zm_genesis_wasp
	Checksum: 0x1C0542B1
	Offset: 0xE50
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function get_current_wasp_count()
{
	wasps = getentarray("zombie_wasp", "targetname");
	num_alive_wasps = wasps.size;
	foreach(wasp in wasps)
	{
		if(!isalive(wasp))
		{
			num_alive_wasps--;
		}
	}
	return num_alive_wasps;
}

/*
	Name: wasp_round_spawning
	Namespace: zm_genesis_wasp
	Checksum: 0x15D7E4D9
	Offset: 0xF30
	Size: 0x390
	Parameters: 0
	Flags: Linked
*/
function wasp_round_spawning()
{
	level endon(#"intermission");
	level endon(#"wasp_round");
	level.wasp_targets = level.players;
	for(i = 0; i < level.wasp_targets.size; i++)
	{
		level.wasp_targets[i].hunted_by = 0;
	}
	level endon(#"restart_round");
	level endon(#"kill_round");
	/#
		if(getdvarint("") == 2 || getdvarint("") >= 4)
		{
			return;
		}
	#/
	if(level.intermission)
	{
		return;
	}
	array::thread_all(level.players, &play_wasp_round);
	n_wave_count = 10;
	if(level.players.size > 1)
	{
		n_wave_count = n_wave_count * (level.players.size * 0.75);
	}
	wasp_health_increase();
	level.zombie_total = int(n_wave_count * 1);
	/#
		if(getdvarstring("") != "" && getdvarint("") > 0)
		{
			level.zombie_total = getdvarint("");
			setdvar("", 0);
		}
	#/
	wait(1);
	parasite_round_fx();
	visionset_mgr::activate("visionset", "zm_wasp_round_visionset", undefined, 1.5, 1.5, 2);
	level clientfield::set("toggle_on_parasite_fog", 1);
	playsoundatposition("vox_zmba_event_waspstart_0", (0, 0, 0));
	wait(6);
	n_wasps_alive = 0;
	level flag::set("wasp_round_in_progress");
	level endon(#"last_ai_down");
	level thread wasp_round_aftermath();
	while(true)
	{
		while(level.zombie_total > 0)
		{
			if(isdefined(level.bzm_worldpaused) && level.bzm_worldpaused)
			{
				util::wait_network_frame();
				continue;
			}
			if(isdefined(level.zm_mixed_wasp_raps_spawning))
			{
				[[level.zm_mixed_wasp_raps_spawning]]();
			}
			else
			{
				spawn_wasp(1);
			}
			util::wait_network_frame();
		}
		util::wait_network_frame();
	}
}

/*
	Name: spawn_wasp
	Namespace: zm_genesis_wasp
	Checksum: 0x8DF7561D
	Offset: 0x12C8
	Size: 0x5F0
	Parameters: 2
	Flags: Linked
*/
function spawn_wasp(var_6237035c, var_eecf48f9)
{
	b_swarm_spawned = 0;
	while(!b_swarm_spawned)
	{
		if(isdefined(var_6237035c) && var_6237035c)
		{
			while(!ready_to_spawn_wasp())
			{
				wait(1);
			}
		}
		spawn_point = undefined;
		while(!isdefined(spawn_point))
		{
			favorite_enemy = get_favorite_enemy();
			spawn_enemy = favorite_enemy;
			if(!isdefined(spawn_enemy))
			{
				spawn_enemy = getplayers()[0];
			}
			if(isdefined(level.wasp_spawn_func))
			{
				spawn_point = [[level.wasp_spawn_func]](spawn_enemy);
			}
			else
			{
				spawn_point = wasp_spawn_logic(spawn_enemy);
			}
			if(!isdefined(spawn_point))
			{
				wait(randomfloatrange(0.6666666, 1.333333));
			}
		}
		v_spawn_origin = spawn_point.origin;
		v_ground = bullettrace(spawn_point.origin + vectorscale((0, 0, 1), 60), (spawn_point.origin + vectorscale((0, 0, 1), 60)) + (vectorscale((0, 0, -1), 100000)), 0, undefined)["position"];
		if(distancesquared(v_ground, spawn_point.origin) < 3600)
		{
			v_spawn_origin = v_ground + vectorscale((0, 0, 1), 60);
		}
		queryresult = positionquery_source_navigation(v_spawn_origin, 0, 80, 80, 15, "navvolume_small");
		a_points = array::randomize(queryresult.data);
		a_spawn_origins = [];
		n_points_found = 0;
		foreach(point in a_points)
		{
			if(bullettracepassed(point.origin, spawn_point.origin, 0, spawn_enemy))
			{
				if(!isdefined(a_spawn_origins))
				{
					a_spawn_origins = [];
				}
				else if(!isarray(a_spawn_origins))
				{
					a_spawn_origins = array(a_spawn_origins);
				}
				a_spawn_origins[a_spawn_origins.size] = point.origin;
				n_points_found++;
				if(n_points_found >= 1)
				{
					break;
				}
			}
		}
		if(a_spawn_origins.size >= 1)
		{
			n_spawn = 0;
			while(n_spawn < 1 && level.zombie_total > 0)
			{
				for(i = a_spawn_origins.size - 1; i >= 0; i--)
				{
					v_origin = a_spawn_origins[i];
					if(isdefined(var_eecf48f9) && var_eecf48f9)
					{
						sp_wasp = level.var_c200ab6[0];
					}
					else
					{
						sp_wasp = level.wasp_spawners[0];
					}
					sp_wasp.origin = v_origin;
					ai = zombie_utility::spawn_zombie(sp_wasp);
					if(isdefined(ai))
					{
						ai parasite::set_parasite_enemy(favorite_enemy);
						level thread wasp_spawn_init(ai, v_origin);
						arrayremoveindex(a_spawn_origins, i);
						if(isdefined(level.zm_wasp_spawn_callback))
						{
							ai thread [[level.zm_wasp_spawn_callback]]();
						}
						ai.ignore_nuke = 1;
						ai.heroweapon_kill_power = 2;
						n_spawn++;
						level.zombie_total--;
						wait(randomfloatrange(0.06666666, 0.1333333));
						if(isdefined(ai))
						{
							ai.ignore_nuke = undefined;
						}
						break;
					}
					wait(randomfloatrange(0.06666666, 0.1333333));
				}
			}
			b_swarm_spawned = 1;
		}
		util::wait_network_frame();
	}
}

/*
	Name: parasite_round_fx
	Namespace: zm_genesis_wasp
	Checksum: 0xF1B8FDE8
	Offset: 0x18C0
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function parasite_round_fx()
{
	foreach(player in level.players)
	{
		player clientfield::increment_to_player("parasite_round_fx");
		player clientfield::increment_to_player("parasite_round_ring_fx");
	}
}

/*
	Name: show_hit_marker
	Namespace: zm_genesis_wasp
	Checksum: 0x895EF1BB
	Offset: 0x1980
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function show_hit_marker()
{
	if(isdefined(self) && isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback setshader("damage_feedback", 24, 48);
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeovertime(1);
		self.hud_damagefeedback.alpha = 0;
	}
}

/*
	Name: waspdamage
	Namespace: zm_genesis_wasp
	Checksum: 0x3E015BF1
	Offset: 0x1A10
	Size: 0x88
	Parameters: 12
	Flags: None
*/
function waspdamage(inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex)
{
	if(isdefined(attacker))
	{
		attacker show_hit_marker();
	}
	return damage;
}

/*
	Name: ready_to_spawn_wasp
	Namespace: zm_genesis_wasp
	Checksum: 0xFA4D64CA
	Offset: 0x1AA0
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function ready_to_spawn_wasp()
{
	n_wasps_alive = get_current_wasp_count();
	b_wasp_count_at_max = n_wasps_alive >= 16;
	b_wasp_count_per_player_at_max = n_wasps_alive >= (level.players.size * 5);
	if(b_wasp_count_at_max || b_wasp_count_per_player_at_max || !level flag::get("spawn_zombies"))
	{
		return false;
	}
	return true;
}

/*
	Name: wasp_round_aftermath
	Namespace: zm_genesis_wasp
	Checksum: 0xC193161F
	Offset: 0x1B38
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function wasp_round_aftermath()
{
	level waittill(#"last_ai_down", e_wasp);
	level thread zm_audio::sndmusicsystem_playstate("parasite_over");
	if(isdefined(level.zm_override_ai_aftermath_powerup_drop))
	{
		[[level.zm_override_ai_aftermath_powerup_drop]](e_wasp, level.last_ai_origin);
	}
	else if(isdefined(level.last_ai_origin))
	{
		enemy = e_wasp.favoriteenemy;
		if(!isdefined(enemy))
		{
			enemy = array::random(level.players);
		}
		enemy parasite_drop_item(level.last_ai_origin);
	}
	wait(2);
	level clientfield::set("toggle_on_parasite_fog", 2);
	level.sndmusicspecialround = 0;
	wait(6);
	level flag::clear("wasp_round_in_progress");
}

/*
	Name: parasite_drop_item
	Namespace: zm_genesis_wasp
	Checksum: 0x15564F0
	Offset: 0x1C70
	Size: 0x38C
	Parameters: 1
	Flags: Linked
*/
function parasite_drop_item(v_parasite_origin)
{
	if(!zm_utility::check_point_in_enabled_zone(v_parasite_origin, 1, level.active_zones))
	{
		e_parasite_drop = level zm_powerups::specific_powerup_drop("full_ammo", v_parasite_origin);
		current_zone = self zm_utility::get_current_zone();
		if(isdefined(current_zone))
		{
			v_start = e_parasite_drop.origin;
			e_closest_player = arraygetclosest(v_start, level.activeplayers);
			if(isdefined(e_closest_player))
			{
				v_target = e_closest_player.origin + (0, 0, 20);
				n_distance_to_target = distance(v_start, v_target);
				v_dir = vectornormalize(v_target - v_start);
				n_step = 50;
				n_distance_moved = 0;
				v_position = v_start;
				while(n_distance_moved <= n_distance_to_target)
				{
					v_position = v_position + (v_dir * n_step);
					if(zm_utility::check_point_in_enabled_zone(v_position, 1, level.active_zones))
					{
						n_height_diff = abs(v_target[2] - v_position[2]);
						if(n_height_diff < 60)
						{
							break;
						}
					}
					n_distance_moved = n_distance_moved + n_step;
				}
				trace = bullettrace(v_position, v_position + (vectorscale((0, 0, -1), 256)), 0, undefined);
				v_ground_position = trace["position"];
				if(isdefined(v_ground_position))
				{
					v_position = (v_position[0], v_position[1], v_ground_position[2] + 20);
				}
				n_flight_time = distance(v_start, v_position) / 100;
				if(n_flight_time > 4)
				{
					n_flight_time = 4;
				}
				e_parasite_drop moveto(v_position, n_flight_time);
			}
			else
			{
				v_nav_check = getclosestpointonnavmesh(e_parasite_drop.origin, 2000, 32);
			}
		}
	}
	else
	{
		level zm_powerups::specific_powerup_drop("full_ammo", getclosestpointonnavmesh(v_parasite_origin, 1000, 30));
	}
}

/*
	Name: wasp_spawn_init
	Namespace: zm_genesis_wasp
	Checksum: 0x2618AA7
	Offset: 0x2008
	Size: 0x2AC
	Parameters: 3
	Flags: Linked
*/
function wasp_spawn_init(ai, origin, should_spawn_fx = 1)
{
	ai endon(#"death");
	ai setinvisibletoall();
	if(isdefined(origin))
	{
		v_origin = origin;
	}
	else
	{
		v_origin = ai.origin;
	}
	if(should_spawn_fx)
	{
		playfx(level._effect["lightning_wasp_spawn"], v_origin);
	}
	wait(1.5);
	earthquake(0.3, 0.5, v_origin, 256);
	if(isdefined(ai.favoriteenemy))
	{
		angle = vectortoangles(ai.favoriteenemy.origin - v_origin);
	}
	else
	{
		angle = ai.angles;
	}
	angles = (ai.angles[0], angle[1], ai.angles[2]);
	ai.origin = v_origin;
	ai.angles = angles;
	/#
		assert(isdefined(ai), "");
	#/
	/#
		assert(isalive(ai), "");
	#/
	ai thread zombie_setup_attack_properties_wasp();
	if(isdefined(level._wasp_death_cb))
	{
		ai callback::add_callback(#"hash_acb66515", level._wasp_death_cb);
	}
	ai.overridevehicledamage = &function_7085a2e4;
	ai setvisibletoall();
	ai.ignoreme = 0;
	ai notify(#"visible");
}

/*
	Name: create_global_wasp_spawn_locations_list
	Namespace: zm_genesis_wasp
	Checksum: 0xC7349723
	Offset: 0x22C0
	Size: 0x17A
	Parameters: 0
	Flags: Linked
*/
function create_global_wasp_spawn_locations_list()
{
	if(!isdefined(level.enemy_wasp_global_locations))
	{
		level.enemy_wasp_global_locations = [];
		keys = getarraykeys(level.zones);
		for(i = 0; i < keys.size; i++)
		{
			zone = level.zones[keys[i]];
			foreach(loc in zone.a_locs["wasp_location"])
			{
				if(!isdefined(level.enemy_wasp_global_locations))
				{
					level.enemy_wasp_global_locations = [];
				}
				else if(!isarray(level.enemy_wasp_global_locations))
				{
					level.enemy_wasp_global_locations = array(level.enemy_wasp_global_locations);
				}
				level.enemy_wasp_global_locations[level.enemy_wasp_global_locations.size] = loc;
			}
		}
	}
}

/*
	Name: wasp_find_closest_in_global_pool
	Namespace: zm_genesis_wasp
	Checksum: 0x1390720B
	Offset: 0x2448
	Size: 0x118
	Parameters: 1
	Flags: Linked
*/
function wasp_find_closest_in_global_pool(favorite_enemy)
{
	index_to_use = 0;
	closest_distance_squared = distancesquared(level.enemy_wasp_global_locations[index_to_use].origin, favorite_enemy.origin);
	for(i = 0; i < level.enemy_wasp_global_locations.size; i++)
	{
		if(level.enemy_wasp_global_locations[i].is_enabled)
		{
			dist_squared = distancesquared(level.enemy_wasp_global_locations[i].origin, favorite_enemy.origin);
			if(dist_squared < closest_distance_squared)
			{
				index_to_use = i;
				closest_distance_squared = dist_squared;
			}
		}
	}
	return level.enemy_wasp_global_locations[index_to_use];
}

/*
	Name: wasp_spawn_logic
	Namespace: zm_genesis_wasp
	Checksum: 0x7340252B
	Offset: 0x2568
	Size: 0x398
	Parameters: 1
	Flags: Linked
*/
function wasp_spawn_logic(favorite_enemy)
{
	if(!getdvarint("zm_wasp_open_spawning", 0))
	{
		wasp_locs = level.zm_loc_types["wasp_location"];
		if(wasp_locs.size == 0)
		{
			create_global_wasp_spawn_locations_list();
			return wasp_find_closest_in_global_pool(favorite_enemy);
		}
		if(isdefined(level.old_wasp_spawn))
		{
			dist_squared = distancesquared(level.old_wasp_spawn.origin, favorite_enemy.origin);
			if(dist_squared > 160000 && dist_squared < 360000)
			{
				return level.old_wasp_spawn;
			}
		}
		foreach(loc in wasp_locs)
		{
			dist_squared = distancesquared(loc.origin, favorite_enemy.origin);
			if(dist_squared > 160000 && dist_squared < 360000)
			{
				level.old_wasp_spawn = loc;
				return loc;
			}
		}
	}
	switch(level.players.size)
	{
		case 4:
		{
			spawn_dist_max = 600;
			break;
		}
		case 3:
		{
			spawn_dist_max = 700;
			break;
		}
		case 2:
		{
			spawn_dist_max = 900;
			break;
		}
		case 1:
		default:
		{
			spawn_dist_max = 1200;
			break;
		}
	}
	queryresult = positionquery_source_navigation(favorite_enemy.origin + (0, 0, randomintrange(40, 100)), 300, spawn_dist_max, 10, 10, "navvolume_small");
	a_points = array::randomize(queryresult.data);
	foreach(point in a_points)
	{
		if(bullettracepassed(point.origin, favorite_enemy.origin, 0, favorite_enemy))
		{
			level.old_wasp_spawn = point;
			return point;
		}
	}
	return a_points[0];
}

/*
	Name: get_favorite_enemy
	Namespace: zm_genesis_wasp
	Checksum: 0x79686C79
	Offset: 0x2908
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function get_favorite_enemy()
{
	if(level.a_wasp_priority_targets.size > 0)
	{
		e_enemy = level.a_wasp_priority_targets[0];
		if(isdefined(e_enemy))
		{
			arrayremovevalue(level.a_wasp_priority_targets, e_enemy);
			return e_enemy;
		}
	}
	if(isdefined(level.fn_custom_wasp_favourate_enemy))
	{
		e_enemy = [[level.fn_custom_wasp_favourate_enemy]]();
		return e_enemy;
	}
	target = parasite::get_parasite_enemy();
	return target;
}

/*
	Name: wasp_health_increase
	Namespace: zm_genesis_wasp
	Checksum: 0x2EBAFCC0
	Offset: 0x29B8
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function wasp_health_increase()
{
	players = getplayers();
	level.wasp_health = level.round_number * 50;
	if(level.wasp_health > 1600)
	{
		level.wasp_health = 1600;
	}
}

/*
	Name: wasp_round_wait_func
	Namespace: zm_genesis_wasp
	Checksum: 0x305DEEA3
	Offset: 0x2A10
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function wasp_round_wait_func()
{
	level endon(#"restart_round");
	level endon(#"kill_round");
	if(level flag::get("wasp_round"))
	{
		level flag::wait_till("wasp_round_in_progress");
		level flag::wait_till_clear("wasp_round_in_progress");
	}
}

/*
	Name: wasp_round_tracker
	Namespace: zm_genesis_wasp
	Checksum: 0x527F304B
	Offset: 0x2A90
	Size: 0x22C
	Parameters: 0
	Flags: Linked
*/
function wasp_round_tracker()
{
	level.wasp_round_count = 1;
	level.next_wasp_round = level.round_number + randomintrange(7, 10);
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;
	while(true)
	{
		level waittill(#"between_round_over");
		/#
			if(getdvarint("") > 0)
			{
				level.next_wasp_round = level.round_number;
			}
		#/
		if(level.round_number == level.next_wasp_round)
		{
			level.sndmusicspecialround = 1;
			old_spawn_func = level.round_spawn_func;
			old_wait_func = level.round_wait_func;
			wasp_round_start();
			level.round_spawn_func = &wasp_round_spawning;
			level.round_wait_func = &wasp_round_wait_func;
			if(isdefined(level.zm_custom_get_next_wasp_round))
			{
				level.next_wasp_round = [[level.zm_custom_get_next_wasp_round]]();
			}
			else
			{
				level.next_wasp_round = (5 + (level.wasp_round_count * 10)) + (randomintrange(-1, 1));
			}
			/#
				getplayers()[0] iprintln("" + level.next_wasp_round);
			#/
		}
		else if(level flag::get("wasp_round"))
		{
			wasp_round_stop();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
			level.wasp_round_count = level.wasp_round_count + 1;
		}
	}
}

/*
	Name: wasp_round_start
	Namespace: zm_genesis_wasp
	Checksum: 0x545056F6
	Offset: 0x2CC8
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function wasp_round_start()
{
	level flag::set("wasp_round");
	level flag::set("special_round");
	if(!isdefined(level.waspround_nomusic))
	{
		level.waspround_nomusic = 0;
	}
	level.waspround_nomusic = 1;
	level notify(#"wasp_round_starting");
	level thread zm_audio::sndmusicsystem_playstate("parasite_start");
	if(isdefined(level.wasp_melee_range))
	{
		setdvar("ai_meleeRange", level.wasp_melee_range);
	}
	else
	{
		setdvar("ai_meleeRange", 100);
	}
}

/*
	Name: wasp_round_stop
	Namespace: zm_genesis_wasp
	Checksum: 0xD7C2F236
	Offset: 0x2DB8
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function wasp_round_stop()
{
	level flag::clear("wasp_round");
	level flag::clear("special_round");
	if(!isdefined(level.waspround_nomusic))
	{
		level.waspround_nomusic = 0;
	}
	level.waspround_nomusic = 0;
	level notify(#"wasp_round_ending");
	setdvar("ai_meleeRange", level.melee_range_sav);
	setdvar("ai_meleeWidth", level.melee_width_sav);
	setdvar("ai_meleeHeight", level.melee_height_sav);
}

/*
	Name: play_wasp_round
	Namespace: zm_genesis_wasp
	Checksum: 0x55075A3F
	Offset: 0x2E98
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function play_wasp_round()
{
	self playlocalsound("zmb_wasp_round_start");
	variation_count = 5;
	wait(4.5);
}

/*
	Name: wasp_init
	Namespace: zm_genesis_wasp
	Checksum: 0xBA9BB318
	Offset: 0x2EE0
	Size: 0x400
	Parameters: 0
	Flags: Linked
*/
function wasp_init()
{
	self.targetname = "zombie_wasp";
	self.script_noteworthy = undefined;
	self.animname = "zombie_wasp";
	self.ignoreall = 1;
	self.ignoreme = 1;
	self.allowdeath = 1;
	self.allowpain = 0;
	self.no_gib = 1;
	self.is_zombie = 1;
	self.gibbed = 0;
	self.head_gibbed = 0;
	self.default_goalheight = 40;
	self.ignore_inert = 1;
	self.no_eye_glow = 1;
	self.lightning_chain_immune = 1;
	self.holdfire = 0;
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoresuppression = 1;
	self.suppressionthreshold = 1;
	self.nododgemove = 1;
	self.dontshootwhilemoving = 1;
	self.pathenemylookahead = 0;
	self.badplaceawareness = 0;
	self.chatinitialized = 0;
	self.missinglegs = 0;
	self.isdog = 0;
	self.teslafxtag = "tag_origin";
	self.grapple_type = 2;
	self setgrapplabletype(self.grapple_type);
	self.team = level.zombie_team;
	self.sword_kill_power = 2;
	if(!isdefined(self.heroweapon_kill_power))
	{
		self.heroweapon_kill_power = 2;
	}
	parasite::parasite_initialize();
	health_multiplier = 1;
	if(getdvarstring("scr_wasp_health_walk_multiplier") != "")
	{
		health_multiplier = getdvarfloat("scr_wasp_health_walk_multiplier");
	}
	self.maxhealth = int(level.wasp_health * health_multiplier);
	if(isdefined(level.a_zombie_respawn_health[self.archetype]) && level.a_zombie_respawn_health[self.archetype].size > 0)
	{
		self.health = level.a_zombie_respawn_health[self.archetype][0];
		arrayremovevalue(level.a_zombie_respawn_health[self.archetype], level.a_zombie_respawn_health[self.archetype][0]);
	}
	else
	{
		self.health = int(level.wasp_health * health_multiplier);
	}
	self thread wasp_run_think();
	self thread watch_player_melee();
	self setinvisibletoall();
	self thread wasp_death();
	self thread wasp_cleanup_failsafe();
	level thread zm_spawner::zombie_death_event(self);
	self thread zm_spawner::enemy_death_detection();
	self zm_spawner::zombie_history(("zombie_wasp_spawn_init -> Spawned = ") + self.origin);
	if(isdefined(level.achievement_monitor_func))
	{
		self [[level.achievement_monitor_func]]();
	}
}

/*
	Name: function_7353fa6d
	Namespace: zm_genesis_wasp
	Checksum: 0x6068B3D8
	Offset: 0x32E8
	Size: 0x420
	Parameters: 0
	Flags: Linked
*/
function function_7353fa6d()
{
	self.targetname = "zombie_wasp";
	self.script_noteworthy = undefined;
	self.animname = "zombie_wasp";
	self.ignoreall = 1;
	self.ignoreme = 1;
	self.allowdeath = 1;
	self.allowpain = 0;
	self.no_gib = 1;
	self.is_zombie = 1;
	self.gibbed = 0;
	self.head_gibbed = 0;
	self.default_goalheight = 40;
	self.ignore_inert = 1;
	self.no_eye_glow = 1;
	self.var_18ee8d81 = 1;
	self.lightning_chain_immune = 1;
	self.holdfire = 0;
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoresuppression = 1;
	self.suppressionthreshold = 1;
	self.nododgemove = 1;
	self.dontshootwhilemoving = 1;
	self.pathenemylookahead = 0;
	self.badplaceawareness = 0;
	self.chatinitialized = 0;
	self.missinglegs = 0;
	self.isdog = 0;
	self.teslafxtag = "tag_origin";
	self.grapple_type = 2;
	self setgrapplabletype(self.grapple_type);
	self.team = level.zombie_team;
	self.sword_kill_power = 2;
	if(!isdefined(self.heroweapon_kill_power))
	{
		self.heroweapon_kill_power = 2;
	}
	parasite::parasite_initialize();
	health_multiplier = 2;
	if(getdvarstring("scr_wasp_health_walk_multiplier") != "")
	{
		health_multiplier = getdvarfloat("scr_wasp_health_walk_multiplier");
	}
	self.maxhealth = int(level.wasp_health * health_multiplier);
	if(isdefined(level.a_zombie_respawn_health[self.archetype]) && level.a_zombie_respawn_health[self.archetype].size > 0)
	{
		self.health = level.a_zombie_respawn_health[self.archetype][0];
		arrayremovevalue(level.a_zombie_respawn_health[self.archetype], level.a_zombie_respawn_health[self.archetype][0]);
	}
	else
	{
		self.health = int(level.wasp_health * health_multiplier);
	}
	self thread wasp_run_think();
	self thread watch_player_melee();
	self setinvisibletoall();
	self thread wasp_death();
	self thread wasp_cleanup_failsafe();
	level thread zm_spawner::zombie_death_event(self);
	self thread zm_spawner::enemy_death_detection();
	self.thundergun_knockdown_func = &wasp_thundergun_knockdown;
	self zm_spawner::zombie_history(("zombie_wasp_spawn_init -> Spawned = ") + self.origin);
	if(isdefined(level.achievement_monitor_func))
	{
		self [[level.achievement_monitor_func]]();
	}
}

/*
	Name: wasp_cleanup_failsafe
	Namespace: zm_genesis_wasp
	Checksum: 0xD777320B
	Offset: 0x3710
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function wasp_cleanup_failsafe()
{
	self endon(#"death");
	n_wasp_created_time = gettime();
	n_check_time = n_wasp_created_time;
	v_check_position = self.origin;
	while(true)
	{
		n_current_time = gettime();
		if(isdefined(level.bzm_worldpaused) && level.bzm_worldpaused)
		{
			n_check_time = n_current_time;
			wait(1);
			continue;
		}
		n_dist = distance(v_check_position, self.origin);
		if(n_dist > 100)
		{
			n_check_time = n_current_time;
			v_check_position = self.origin;
		}
		else
		{
			n_delta_time = (n_current_time - n_check_time) / 1000;
			if(n_delta_time >= 20)
			{
				break;
			}
		}
		n_delta_time = (n_current_time - n_wasp_created_time) / 1000;
		if(n_delta_time >= 150)
		{
			break;
		}
		wait(1);
	}
	self dodamage(self.health + 100, self.origin);
}

/*
	Name: wasp_death
	Namespace: zm_genesis_wasp
	Checksum: 0xCEB0DE95
	Offset: 0x3880
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function wasp_death()
{
	self waittill(#"death", attacker);
	if(get_current_wasp_count() == 0 && level.zombie_total == 0)
	{
		if(!isdefined(level.zm_ai_round_over) || [[level.zm_ai_round_over]]())
		{
			level.last_ai_origin = self.origin;
			level notify(#"last_ai_down", self);
		}
	}
	if(isplayer(attacker))
	{
		if(isdefined(attacker.on_train) && attacker.on_train)
		{
			attacker notify(#"wasp_train_kill");
		}
		attacker zm_score::player_add_points("death_wasp", 70);
		if(isdefined(level.hero_power_update))
		{
			[[level.hero_power_update]](attacker, self);
		}
		attacker zm_stats::increment_client_stat("zwasp_killed");
		attacker zm_stats::increment_player_stat("zwasp_killed");
	}
	if(isdefined(attacker) && isai(attacker))
	{
		attacker notify(#"killed", self);
	}
	self stoploopsound();
}

/*
	Name: zombie_setup_attack_properties_wasp
	Namespace: zm_genesis_wasp
	Checksum: 0xFF84372F
	Offset: 0x3A28
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function zombie_setup_attack_properties_wasp()
{
	self zm_spawner::zombie_history("zombie_setup_attack_properties()");
	self thread wasp_behind_audio();
	self.ignoreall = 0;
	self.meleeattackdist = 64;
	self.disablearrivals = 1;
	self.disableexits = 1;
	if(level.wasp_round_count == 2)
	{
		self ai::set_behavior_attribute("firing_rate", "medium");
	}
	else if(level.wasp_round_count > 2)
	{
		self ai::set_behavior_attribute("firing_rate", "fast");
	}
}

/*
	Name: stop_wasp_sound_on_death
	Namespace: zm_genesis_wasp
	Checksum: 0x1D723D41
	Offset: 0x3B10
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function stop_wasp_sound_on_death()
{
	self waittill(#"death");
	self stopsounds();
}

/*
	Name: wasp_behind_audio
	Namespace: zm_genesis_wasp
	Checksum: 0x1190D382
	Offset: 0x3B40
	Size: 0x1B0
	Parameters: 0
	Flags: Linked
*/
function wasp_behind_audio()
{
	self thread stop_wasp_sound_on_death();
	self endon(#"death");
	self util::waittill_any("wasp_running", "wasp_combat");
	wait(3);
	while(true)
	{
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			waspangle = angleclamp180((vectortoangles(self.origin - players[i].origin)[1]) - players[i].angles[1]);
			if(isalive(players[i]) && !isdefined(players[i].revivetrigger))
			{
				if(abs(waspangle) > 90 && distance2d(self.origin, players[i].origin) > 100)
				{
					wait(3);
				}
			}
		}
		wait(0.75);
	}
}

/*
	Name: special_wasp_spawn
	Namespace: zm_genesis_wasp
	Checksum: 0xB3030567
	Offset: 0x3CF8
	Size: 0x34C
	Parameters: 7
	Flags: Linked
*/
function special_wasp_spawn(n_to_spawn = 1, spawn_point, n_radius = 32, n_half_height = 32, b_non_round, spawn_fx = 1, b_return_ai = 0)
{
	wasp = getentarray("zombie_wasp", "targetname");
	if(isdefined(wasp) && wasp.size >= 9)
	{
		return 0;
	}
	count = 0;
	while(count < n_to_spawn)
	{
		players = getplayers();
		favorite_enemy = get_favorite_enemy();
		spawn_enemy = favorite_enemy;
		if(!isdefined(spawn_enemy))
		{
			spawn_enemy = players[0];
		}
		if(isdefined(level.wasp_spawn_func))
		{
			spawn_point = [[level.wasp_spawn_func]](spawn_enemy);
		}
		while(!isdefined(spawn_point))
		{
			if(!isdefined(spawn_point))
			{
				spawn_point = wasp_spawn_logic(spawn_enemy);
			}
			if(isdefined(spawn_point))
			{
				break;
			}
			wait(0.05);
		}
		ai = zombie_utility::spawn_zombie(level.wasp_spawners[0]);
		v_spawn_origin = spawn_point.origin;
		if(isdefined(ai))
		{
			queryresult = positionquery_source_navigation(v_spawn_origin, 0, n_radius, n_half_height, 15, "navvolume_small");
			if(queryresult.data.size)
			{
				point = queryresult.data[randomint(queryresult.data.size)];
				v_spawn_origin = point.origin;
			}
			ai parasite::set_parasite_enemy(favorite_enemy);
			ai.does_not_count_to_round = b_non_round;
			level thread wasp_spawn_init(ai, v_spawn_origin, spawn_fx);
			count++;
		}
		wait(level.zombie_vars["zombie_spawn_delay"]);
	}
	if(b_return_ai)
	{
		return ai;
	}
	return 1;
}

/*
	Name: wasp_run_think
	Namespace: zm_genesis_wasp
	Checksum: 0x922B9F9C
	Offset: 0x4050
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function wasp_run_think()
{
	self endon(#"death");
	self waittill(#"visible");
	if(self.health > level.wasp_health)
	{
		self.maxhealth = level.wasp_health;
		self.health = level.wasp_health;
	}
	while(true)
	{
		wait(0.2);
	}
}

/*
	Name: watch_player_melee
	Namespace: zm_genesis_wasp
	Checksum: 0x1C230C9
	Offset: 0x40E0
	Size: 0x1D8
	Parameters: 0
	Flags: Linked
*/
function watch_player_melee()
{
	self endon(#"death");
	self waittill(#"visible");
	while(isdefined(self))
	{
		level waittill(#"player_melee", player, weapon);
		peye = player geteye();
		dist2 = distance2dsquared(peye, self.origin);
		if(dist2 > 5184)
		{
			continue;
		}
		if((abs(peye[2] - self.origin[2])) > 64)
		{
			continue;
		}
		pfwd = player getweaponforwarddir();
		tome = self.origin - peye;
		tome = vectornormalize(tome);
		dot = vectordot(pfwd, tome);
		if(dot < 0.5)
		{
			continue;
		}
		damage = 150;
		if(isdefined(weapon))
		{
			damage = weapon.meleedamage;
		}
		self dodamage(damage, peye, player, player, "none", "MOD_MELEE", 0, weapon);
	}
}

/*
	Name: watch_player_melee_events
	Namespace: zm_genesis_wasp
	Checksum: 0x1E8DFB32
	Offset: 0x42C0
	Size: 0x3E
	Parameters: 0
	Flags: Linked
*/
function watch_player_melee_events()
{
	self endon(#"disconnect");
	for(;;)
	{
		self waittill(#"weapon_melee", weapon);
		level notify(#"player_melee", self, weapon);
	}
}

/*
	Name: wasp_stalk_audio
	Namespace: zm_genesis_wasp
	Checksum: 0xBA673E02
	Offset: 0x4308
	Size: 0x50
	Parameters: 0
	Flags: None
*/
function wasp_stalk_audio()
{
	self endon(#"death");
	self endon(#"wasp_running");
	self endon(#"wasp_combat");
	while(true)
	{
		wait(randomfloatrange(3, 6));
	}
}

/*
	Name: wasp_thundergun_knockdown
	Namespace: zm_genesis_wasp
	Checksum: 0xA63C7213
	Offset: 0x4360
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function wasp_thundergun_knockdown(player, gib)
{
	self endon(#"death");
	damage = int(self.maxhealth * 0.5);
	self dodamage(damage, player.origin, player);
}

/*
	Name: wasp_add_to_spawn_pool
	Namespace: zm_genesis_wasp
	Checksum: 0x401BCEF4
	Offset: 0x43E8
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function wasp_add_to_spawn_pool(optional_player_target)
{
	if(isdefined(optional_player_target))
	{
		array::add(level.a_wasp_priority_targets, optional_player_target);
	}
	level.zombie_total++;
}

/*
	Name: function_7085a2e4
	Namespace: zm_genesis_wasp
	Checksum: 0x81EAE405
	Offset: 0x4430
	Size: 0xE4
	Parameters: 15
	Flags: Linked
*/
function function_7085a2e4(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(isplayer(eattacker) && (isdefined(eattacker.var_e8e8daad) && eattacker.var_e8e8daad))
	{
		idamage = int(idamage * 1.5);
	}
	return idamage;
}

/*
	Name: genesis_parasite_damage
	Namespace: zm_genesis_wasp
	Checksum: 0xF6933090
	Offset: 0x4520
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function genesis_parasite_damage()
{
	self notify(#"hash_ca45e24c");
	self endon(#"hash_ca45e24c");
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage", n_ammount, e_attacker);
		if(isdefined(e_attacker.is_parasite) && e_attacker.is_parasite)
		{
			self clientfield::increment_to_player("genesis_parasite_damage");
		}
	}
}

