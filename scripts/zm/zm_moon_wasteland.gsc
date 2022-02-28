// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_equip_hacker;
#using scripts\zm\_zm_hackables_perks;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_moon_teleporter;

#namespace zm_moon_wasteland;

/*
	Name: init_no_mans_land
	Namespace: zm_moon_wasteland
	Checksum: 0xD6F064A
	Offset: 0x538
	Size: 0x314
	Parameters: 0
	Flags: Linked
*/
function init_no_mans_land()
{
	level flag::init("enter_nml");
	level flag::init("teleporter_used");
	level flag::init("start_supersprint");
	level flag::init("between_rounds");
	level flag::init("teleported_to_nml");
	var_cd70fc20 = getentarray("nml_area1_spawners", "targetname");
	var_3f786b5b = getentarray("nml_area2_spawners", "targetname");
	array::thread_all(var_cd70fc20, &spawner::add_spawn_function, &zm_spawner::zombie_spawn_init);
	array::thread_all(var_cd70fc20, &spawner::add_spawn_function, &zombie_utility::round_spawn_failsafe);
	array::thread_all(var_3f786b5b, &spawner::add_spawn_function, &zm_spawner::zombie_spawn_init);
	array::thread_all(var_3f786b5b, &spawner::add_spawn_function, &zombie_utility::round_spawn_failsafe);
	level.on_the_moon = 0;
	level.ever_been_on_the_moon = 0;
	level.initial_spawn = 1;
	level.nml_didteleport = 0;
	level.nml_dog_health = 100;
	level._effect["lightning_dog_spawn"] = "zombie/fx_dog_lightning_buildup_zmb";
	init_teleporter_message();
	zm_zonemgr::zone_init("nml_zone");
	zm_moon_teleporter::teleporter_to_nml_init();
	ent = getent("nml_dogs_volume", "targetname");
	ent thread check_players_in_nml_dogs_volume();
	level.num_nml_dog_targets = 0;
	get_perk_machine_ents();
	level.last_perk_index = -1;
	level thread zombie_moon_start_init();
	level thread zm_moon_teleporter::function_6454df1b();
	level.nml_reaction_interval = 2000;
	level.nml_min_reaction_dist_sq = 1024;
	level.nml_max_reaction_dist_sq = 5760000;
}

/*
	Name: zombie_moon_start_init
	Namespace: zm_moon_wasteland
	Checksum: 0xF2762CA9
	Offset: 0x858
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function zombie_moon_start_init()
{
	level flag::wait_till("begin_spawning");
	level thread nml_dogs_init();
	level thread zm_moon_teleporter::function_78f5cb79();
	teleporter = getent("generator_teleporter", "targetname");
	zm_moon_teleporter::teleporter_ending(teleporter, 0);
}

/*
	Name: nml_dogs_init
	Namespace: zm_moon_wasteland
	Checksum: 0xEB51D92A
	Offset: 0x900
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function nml_dogs_init()
{
	level.nml_dogs_enabled = 0;
	wait(30);
	level.nml_dogs_enabled = 1;
}

/*
	Name: nml_setup_round_spawner
	Namespace: zm_moon_wasteland
	Checksum: 0x80753610
	Offset: 0x930
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function nml_setup_round_spawner()
{
	if(isdefined(level.round_number))
	{
		if(level flag::get("between_rounds"))
		{
			level.nml_last_round = level.round_number + 1;
			level.prev_round_zombies = [[level.max_zombie_func]](level.zombie_vars["zombie_max_ai"]);
		}
		else
		{
			level.nml_last_round = level.round_number;
		}
	}
	else
	{
		level.nml_last_round = 1;
	}
	level.round_spawn_func = &nml_round_manager;
	init_moon_nml_round(level.nml_last_round);
}

/*
	Name: num_players_touching_volume
	Namespace: zm_moon_wasteland
	Checksum: 0x408EBB49
	Offset: 0x9F8
	Size: 0xF2
	Parameters: 1
	Flags: Linked
*/
function num_players_touching_volume(volume)
{
	players = getplayers();
	num_players_inside = 0;
	for(i = 0; i < players.size; i++)
	{
		ent = players[i];
		if(!isalive(ent) || !isplayer(ent) || ent.sessionstate == "spectator")
		{
			continue;
		}
		if(ent istouching(volume))
		{
			num_players_inside++;
		}
	}
	return num_players_inside;
}

/*
	Name: check_players_in_nml_dogs_volume
	Namespace: zm_moon_wasteland
	Checksum: 0xA8E9E154
	Offset: 0xAF8
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function check_players_in_nml_dogs_volume()
{
	while(true)
	{
		level.num_nml_dog_targets = num_players_touching_volume(self);
		wait(1.3);
	}
}

/*
	Name: init_hint_hudelem
	Namespace: zm_moon_wasteland
	Checksum: 0x2F1FB5AC
	Offset: 0xB38
	Size: 0x88
	Parameters: 6
	Flags: Linked
*/
function init_hint_hudelem(x, y, alignx, aligny, fontscale, alpha)
{
	self.x = x;
	self.y = y;
	self.alignx = alignx;
	self.aligny = aligny;
	self.fontscale = fontscale;
	self.alpha = alpha;
	self.sort = 20;
}

/*
	Name: init_teleporter_message
	Namespace: zm_moon_wasteland
	Checksum: 0xEF3B4106
	Offset: 0xBC8
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function init_teleporter_message()
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player.teleporter_message = function_25deb972(player);
		player.teleporter_message settext(&"NULL_EMPTY");
	}
	level.lastmessagetime = 0;
}

/*
	Name: function_25deb972
	Namespace: zm_moon_wasteland
	Checksum: 0xD5B94683
	Offset: 0xC80
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function function_25deb972(player)
{
	teleporter_message = newclienthudelem(player);
	teleporter_message init_hint_hudelem(320, 140, "center", "bottom", 1.6, 1);
	return teleporter_message;
}

/*
	Name: set_teleporter_message
	Namespace: zm_moon_wasteland
	Checksum: 0x7107694
	Offset: 0xCF8
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function set_teleporter_message(message)
{
}

/*
	Name: init_moon_nml_round
	Namespace: zm_moon_wasteland
	Checksum: 0x83A0E7F8
	Offset: 0xD10
	Size: 0x1D4
	Parameters: 1
	Flags: Linked
*/
function init_moon_nml_round(target_round)
{
	zombies = getaiarray();
	if(isdefined(zombies))
	{
		for(i = 0; i < zombies.size; i++)
		{
			if(isdefined(zombies[i].ignore_nml_delete) && zombies[i].ignore_nml_delete)
			{
				continue;
			}
			if(isdefined(zombies[i].fx_quad_trail))
			{
				zombies[i].fx_quad_trail delete();
			}
			zombies[i] zombie_utility::reset_attack_spot();
			zombies[i] notify(#"zombie_delete");
			zombies[i] delete();
		}
	}
	level.zombie_health = level.zombie_vars["zombie_health_start"];
	zombie_utility::ai_calculate_health(level.nml_last_round);
	level.zombie_total = 0;
	zm::set_round_number(level.nml_last_round);
	level.round_number = zm::get_round_number();
	level.chalk_override = " ";
	level thread clear_nml_rounds();
	level waittill(#"between_round_over");
}

/*
	Name: clear_nml_rounds
	Namespace: zm_moon_wasteland
	Checksum: 0x6DC56176
	Offset: 0xEF0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function clear_nml_rounds()
{
	level endon(#"restart_round");
	while(isdefined(level.chalk_override))
	{
		if(isdefined(level.chalk_override))
		{
		}
		wait(1);
	}
}

/*
	Name: resume_moon_rounds
	Namespace: zm_moon_wasteland
	Checksum: 0xB544DB29
	Offset: 0xF48
	Size: 0x20E
	Parameters: 1
	Flags: Linked
*/
function resume_moon_rounds(target_round)
{
	if(target_round < 1)
	{
		target_round = 1;
	}
	level.chalk_override = undefined;
	level.zombie_health = level.zombie_vars["zombie_health_start"];
	level.zombie_total = 0;
	zombie_utility::ai_calculate_health(target_round);
	level notify(#"restart_round");
	level._from_nml = 1;
	zombies = getaispeciesarray(level.zombie_team, "all");
	if(isdefined(zombies))
	{
		for(i = 0; i < zombies.size; i++)
		{
			if(isdefined(zombies[i].ignore_nml_delete) && zombies[i].ignore_nml_delete)
			{
				continue;
			}
			if(zombies[i].isdog)
			{
				zombies[i] dodamage(zombies[i].health + 10, zombies[i].origin);
				continue;
			}
			if(isdefined(zombies[i].fx_quad_trail))
			{
				zombies[i].fx_quad_trail delete();
			}
			zombies[i] zombie_utility::reset_attack_spot();
			zombies[i] notify(#"zombie_delete");
			zombies[i] delete();
		}
	}
}

/*
	Name: nml_round_manager
	Namespace: zm_moon_wasteland
	Checksum: 0x29E13313
	Offset: 0x1160
	Size: 0x950
	Parameters: 0
	Flags: Linked
*/
function nml_round_manager()
{
	level endon(#"restart_round");
	level.dog_targets = getplayers();
	for(i = 0; i < level.dog_targets.size; i++)
	{
		level.dog_targets[i].hunted_by = 0;
	}
	level.nml_start_time = gettime();
	dog_round_start_time = 2000;
	dog_can_spawn_time = -10000;
	dog_difficulty_min_time = 3000;
	dog_difficulty_max_time = 9500;
	wave_1st_attack_time = 25000;
	prepare_attack_time = 2100;
	wave_attack_time = 35000;
	cooldown_time = 16000;
	next_attack_time = 26000;
	max_zombies = 20;
	next_round_time = level.nml_start_time + wave_1st_attack_time;
	mode = "normal_spawning";
	area = 1;
	level thread nml_round_never_ends();
	while(true)
	{
		current_time = gettime();
		wait_override = 0;
		zombies = getaispeciesarray(level.zombie_team, "all");
		while(zombies.size >= max_zombies)
		{
			zombies = getaispeciesarray(level.zombie_team, "all");
			wait(0.5);
		}
		switch(mode)
		{
			case "normal_spawning":
			{
				if(level.initial_spawn == 1)
				{
					spawn_a_zombie(10, "nml_zone_spawner", 0.01, 1);
				}
				else
				{
					ai = spawn_a_zombie(max_zombies, "nml_zone_spawner", 0.01, 1);
					if(isdefined(ai))
					{
						move_speed = "sprint";
						if(level flag::get("start_supersprint"))
						{
							move_speed = "super_sprint";
						}
						ai function_3eb8ebf9(move_speed);
						if(isdefined(ai.pre_black_hole_bomb_run_combatanim))
						{
							ai.pre_black_hole_bomb_run_combatanim = move_speed;
						}
					}
				}
				if(current_time > next_round_time)
				{
					next_round_time = current_time + prepare_attack_time;
					mode = "preparing_spawn_wave";
					level thread screen_shake_manager(next_round_time);
				}
				break;
			}
			case "preparing_spawn_wave":
			{
				zombies = getaispeciesarray(level.zombie_team);
				for(i = 0; i < zombies.size; i++)
				{
					if(!zombies[i].missinglegs && zombies[i].animname == "zombie")
					{
						move_speed = "sprint";
						if(level flag::get("start_supersprint"))
						{
							move_speed = "super_sprint";
						}
						zombies[i] zombie_utility::set_zombie_run_cycle(move_speed);
						level.initial_spawn = 0;
						level notify(#"start_nml_ramp");
						if(isdefined(zombies[i].pre_black_hole_bomb_run_combatanim))
						{
							zombies[i].pre_black_hole_bomb_run_combatanim = move_speed;
						}
					}
				}
				if(current_time > next_round_time)
				{
					level notify(#"nml_attack_wave");
					mode = "spawn_wave_active";
					if(area == 1)
					{
						area = 2;
						level thread nml_wave_attack(max_zombies, "nml_area2_spawners");
					}
					else
					{
						area = 1;
						level thread nml_wave_attack(max_zombies, "nml_area1_spawners");
					}
					next_round_time = current_time + wave_attack_time;
				}
				wait_override = 0.1;
				break;
			}
			case "spawn_wave_active":
			{
				if(current_time < next_round_time)
				{
					if(randomfloatrange(0, 1) < 0.05)
					{
						ai = spawn_a_zombie(max_zombies, "nml_zone_spawner", 0.01, 1);
						if(isdefined(ai))
						{
							ai.ignore_gravity = 1;
							move_speed = "sprint";
							if(level flag::get("start_supersprint"))
							{
								move_speed = "super_sprint";
							}
							ai function_3eb8ebf9(move_speed);
							if(isdefined(ai.pre_black_hole_bomb_run_combatanim))
							{
								ai.pre_black_hole_bomb_run_combatanim = move_speed;
							}
						}
					}
				}
				else
				{
					level notify(#"wave_attack_finished");
					mode = "wave_finished_cooldown";
					next_round_time = current_time + cooldown_time;
				}
				break;
			}
			case "wave_finished_cooldown":
			{
				if(current_time > next_round_time)
				{
					next_round_time = current_time + next_attack_time;
					mode = "normal_spawning";
				}
				wait_override = 0.01;
				break;
			}
		}
		num_dog_targets = 0;
		if((current_time - level.nml_start_time) > dog_round_start_time)
		{
			skip_dogs = 0;
			players = getplayers();
			if(players.size <= 1)
			{
				dt = current_time - dog_can_spawn_time;
				if(dt < 0)
				{
					skip_dogs = 1;
				}
				else
				{
					dog_can_spawn_time = current_time + randomfloatrange(dog_difficulty_min_time, dog_difficulty_max_time);
				}
			}
			if(mode == "preparing_spawn_wave")
			{
				skip_dogs = 1;
			}
			if(!skip_dogs && level.nml_dogs_enabled == 1)
			{
				num_dog_targets = level.num_nml_dog_targets;
				if(num_dog_targets)
				{
					dogs = getaispeciesarray(level.zombie_team, "zombie_dog");
					num_dog_targets = num_dog_targets * 2;
					if(dogs.size < num_dog_targets)
					{
						ai = zm_ai_dogs::special_dog_spawn();
						zombie_dogs = getaispeciesarray(level.zombie_team, "zombie_dog");
						if(isdefined(zombie_dogs))
						{
							for(i = 0; i < zombie_dogs.size; i++)
							{
								zombie_dogs[i].maxhealth = int(level.nml_dog_health);
								zombie_dogs[i].health = int(level.nml_dog_health);
							}
						}
					}
				}
			}
		}
		if(wait_override != 0)
		{
			wait(wait_override);
		}
		else
		{
			wait(randomfloatrange(0.1, 0.8));
		}
	}
}

/*
	Name: function_3eb8ebf9
	Namespace: zm_moon_wasteland
	Checksum: 0x9B1F0938
	Offset: 0x1AB8
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_3eb8ebf9(move_speed)
{
	self endon(#"death");
	time = gettime();
	while(true)
	{
		if(isdefined(self.zombie_init_done) && self.zombie_init_done)
		{
			break;
		}
		if(gettime() > (time + 500))
		{
			break;
		}
		wait(0.05);
	}
	self zombie_utility::set_zombie_run_cycle(move_speed);
}

/*
	Name: nml_wave_attack
	Namespace: zm_moon_wasteland
	Checksum: 0x253FB15C
	Offset: 0x1B48
	Size: 0x160
	Parameters: 2
	Flags: Linked
*/
function nml_wave_attack(num_in_wave, var_c194e88d)
{
	level endon(#"wave_attack_finished");
	level endon(#"restart_round");
	while(true)
	{
		zombies = getaispeciesarray(level.zombie_team, "all");
		if(zombies.size < num_in_wave)
		{
			ai = spawn_a_zombie(num_in_wave, var_c194e88d, 0.01, 1);
			if(isdefined(ai))
			{
				ai.ignore_gravity = 1;
				move_speed = "sprint";
				if(level flag::get("start_supersprint"))
				{
					move_speed = "super_sprint";
				}
				ai function_3eb8ebf9(move_speed);
				if(isdefined(ai.pre_black_hole_bomb_run_combatanim))
				{
					ai.pre_black_hole_bomb_run_combatanim = move_speed;
				}
			}
		}
		wait(randomfloatrange(0.3, 1));
	}
}

/*
	Name: spawn_a_zombie
	Namespace: zm_moon_wasteland
	Checksum: 0x678B6B69
	Offset: 0x1CB0
	Size: 0x18C
	Parameters: 4
	Flags: Linked
*/
function spawn_a_zombie(max_zombies, var_c194e88d, wait_delay, ignoregravity)
{
	zombies = getaispeciesarray(level.zombie_team);
	if(zombies.size >= max_zombies)
	{
		return undefined;
	}
	var_71aee853 = getentarray("nml_zone_spawner", "targetname");
	e_spawner = array::random(var_71aee853);
	var_50f2968b = struct::get_array(var_c194e88d, "targetname");
	s_spawn_loc = array::random(var_50f2968b);
	ai = zombie_utility::spawn_zombie(e_spawner, var_c194e88d, s_spawn_loc);
	if(isdefined(ai))
	{
		if(isdefined(ignoregravity) && ignoregravity)
		{
			ai.ignore_gravity = 1;
		}
		if(isdefined(level.mp_side_step) && level.mp_side_step)
		{
			ai.shouldsidestepfunc = &nml_shouldsidestep;
			ai.sidestepanims = [];
		}
	}
	return ai;
}

/*
	Name: screen_shake_manager
	Namespace: zm_moon_wasteland
	Checksum: 0xD14D700F
	Offset: 0x1E48
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function screen_shake_manager(next_round_time)
{
	level endon(#"nml_attack_wave");
	level endon(#"restart_round");
	time = 0;
	while(time < next_round_time)
	{
		level thread attack_wave_screen_shake();
		wait_time = randomfloatrange(0.25, 0.35);
		wait(wait_time);
		time = gettime();
	}
}

/*
	Name: attack_wave_screen_shake
	Namespace: zm_moon_wasteland
	Checksum: 0x51905871
	Offset: 0x1EE8
	Size: 0x156
	Parameters: 0
	Flags: Linked
*/
function attack_wave_screen_shake()
{
	num_valid = 0;
	players = getplayers();
	pos = (0, 0, 0);
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(zombie_utility::is_player_valid(player))
		{
			pos = pos + player.origin;
			num_valid++;
		}
	}
	if(!num_valid)
	{
		return;
	}
	shake_position = (pos[0] / num_valid, pos[1] / num_valid, pos[2] / num_valid);
	thread rumble_all_players("damage_heavy");
	scale = 0.4;
	duration = 1;
	radius = 16800;
}

/*
	Name: rumble_all_players
	Namespace: zm_moon_wasteland
	Checksum: 0xC92D6F51
	Offset: 0x2048
	Size: 0x15E
	Parameters: 5
	Flags: Linked
*/
function rumble_all_players(high_rumble_string, low_rumble_string, rumble_org, high_rumble_range, low_rumble_range)
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(high_rumble_range) && isdefined(low_rumble_range) && isdefined(rumble_org))
		{
			if(distance(players[i].origin, rumble_org) < high_rumble_range)
			{
				players[i] playrumbleonentity(high_rumble_string);
			}
			else if(distance(players[i].origin, rumble_org) < low_rumble_range)
			{
				players[i] playrumbleonentity(low_rumble_string);
			}
			continue;
		}
		players[i] playrumbleonentity(high_rumble_string);
	}
}

/*
	Name: get_perk_machine_ents
	Namespace: zm_moon_wasteland
	Checksum: 0xEB639E61
	Offset: 0x21B0
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function get_perk_machine_ents()
{
	nml_position_helper = struct::get("nml_perk_location_helper", "script_noteworthy");
	nml_dist = 4200;
	level.speed_cola_ents = get_vending_ents("vending_sleight", "speedcola_perk", nml_position_helper.origin, nml_dist);
	level.jugg_ents = get_vending_ents("vending_jugg", "jugg_perk", nml_position_helper.origin, nml_dist);
}

/*
	Name: get_vending_ents
	Namespace: zm_moon_wasteland
	Checksum: 0x2F2D7972
	Offset: 0x2270
	Size: 0x1EE
	Parameters: 4
	Flags: Linked
*/
function get_vending_ents(vending_name, perk_script_string, nml_pos, nml_radius)
{
	names = [];
	names[0] = vending_name;
	names[1] = "zombie_vending";
	ent_array = [];
	for(i = 0; i < names.size; i++)
	{
		ents = getentarray(names[i], "targetname");
		for(j = 0; j < ents.size; j++)
		{
			ent = ents[j];
			if(isdefined(ent.script_string) && ent.script_string == perk_script_string)
			{
				if((abs(nml_pos[0] - ent.origin[0])) < nml_radius && (abs(nml_pos[1] - ent.origin[1])) < nml_radius && (abs(nml_pos[2] - ent.origin[2])) < nml_radius)
				{
					ent_array[ent_array.size] = ent;
				}
			}
		}
	}
	return ent_array;
}

/*
	Name: move_perk
	Namespace: zm_moon_wasteland
	Checksum: 0xF1ED20A9
	Offset: 0x2468
	Size: 0x15C
	Parameters: 3
	Flags: Linked
*/
function move_perk(dist, time, accel)
{
	ent = level.speed_cola_ents[0];
	pos = (ent.origin[0], ent.origin[1], ent.origin[2] + dist);
	ent moveto(pos, time, accel, accel);
	level.speed_cola_ents[1] triggerenable(0);
	ent = level.jugg_ents[0];
	pos = (ent.origin[0], ent.origin[1], ent.origin[2] + dist);
	ent moveto(pos, time, accel, accel);
	level.jugg_ents[1] triggerenable(0);
}

/*
	Name: perk_machines_hide
	Namespace: zm_moon_wasteland
	Checksum: 0x1C322213
	Offset: 0x25D0
	Size: 0x29C
	Parameters: 3
	Flags: Linked
*/
function perk_machines_hide(cola, jug, moving = 0)
{
	if(cola)
	{
		level.speed_cola_ents[0] hide();
	}
	else
	{
		level.speed_cola_ents[0] show();
	}
	if(jug)
	{
		level.jugg_ents[0] hide();
	}
	else
	{
		level.jugg_ents[0] show();
	}
	if(moving)
	{
		level.speed_cola_ents[1] triggerenable(0);
		level.jugg_ents[1] triggerenable(0);
		if(isdefined(level.speed_cola_ents[1].hackable))
		{
			zm_equip_hacker::deregister_hackable_struct(level.speed_cola_ents[1].hackable);
		}
		if(isdefined(level.jugg_ents[1].hackable))
		{
			zm_equip_hacker::deregister_hackable_struct(level.jugg_ents[1].hackable);
		}
	}
	else
	{
		hackable = undefined;
		if(cola)
		{
			level.jugg_ents[1] triggerenable(1);
			if(isdefined(level.jugg_ents[1].hackable))
			{
				hackable = level.jugg_ents[1].hackable;
			}
		}
		else
		{
			level.speed_cola_ents[1] triggerenable(1);
			if(isdefined(level.speed_cola_ents[1].hackable))
			{
				hackable = level.speed_cola_ents[1].hackable;
			}
		}
		zm_equip_hacker::register_pooled_hackable_struct(hackable, &zm_hackables_perks::perk_hack, &zm_hackables_perks::perk_hack_qualifier);
	}
}

/*
	Name: perk_machine_show_selected
	Namespace: zm_moon_wasteland
	Checksum: 0xD3D69435
	Offset: 0x2878
	Size: 0x76
	Parameters: 2
	Flags: Linked
*/
function perk_machine_show_selected(perk_index, moving)
{
	switch(perk_index)
	{
		case 0:
		{
			perk_machines_hide(0, 1, moving);
			break;
		}
		case 1:
		{
			perk_machines_hide(1, 0, moving);
			break;
		}
	}
}

/*
	Name: perk_machine_arrival_update
	Namespace: zm_moon_wasteland
	Checksum: 0x521C7385
	Offset: 0x28F8
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function perk_machine_arrival_update()
{
	top_height = 1200;
	fall_time = 4;
	num_model_swaps = 20;
	perk_index = randomintrange(0, 2);
	ent = level.speed_cola_ents[0];
	level thread perk_arrive_fx(ent.origin);
	move_perk(top_height, 0.01, 0.001);
	wait(0.3);
	perk_machines_hide(0, 0, 1);
	wait(1);
	move_perk(top_height * -1, fall_time, 1.5);
	wait_step = fall_time / num_model_swaps;
	for(i = 0; i < num_model_swaps; i++)
	{
		perk_machine_show_selected(perk_index, 1);
		wait(wait_step);
		perk_index++;
		if(perk_index > 1)
		{
			perk_index = 0;
		}
	}
	while(perk_index == level.last_perk_index)
	{
		perk_index = randomintrange(0, 2);
	}
	level.last_perk_index = perk_index;
	perk_machine_show_selected(perk_index, 0);
}

/*
	Name: perk_arrive_fx
	Namespace: zm_moon_wasteland
	Checksum: 0x13C07103
	Offset: 0x2AF0
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function perk_arrive_fx(pos)
{
	wait(0.15);
	playfx(level._effect["lightning_dog_spawn"], pos);
	playsoundatposition("zmb_hellhound_bolt", pos);
	wait(1.1);
	playfx(level._effect["lightning_dog_spawn"], pos);
	playsoundatposition("zmb_hellhound_bolt", pos);
}

/*
	Name: nml_round_never_ends
	Namespace: zm_moon_wasteland
	Checksum: 0x396C1ED4
	Offset: 0x2BA8
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function nml_round_never_ends()
{
	wait(2);
	level endon(#"restart_round");
	while(level flag::get("enter_nml"))
	{
		zombies = getaispeciesarray(level.zombie_team, "all");
		if(zombies.size >= 2)
		{
			level.zombie_total = 100;
			return;
		}
		wait(1);
	}
}

/*
	Name: nml_side_stepping_zombies
	Namespace: zm_moon_wasteland
	Checksum: 0x21F8672
	Offset: 0x2C38
	Size: 0x28
	Parameters: 0
	Flags: None
*/
function nml_side_stepping_zombies()
{
	level.mp_side_step = 0;
	level waittill(#"nml_attack_wave");
	level.mp_side_step = 1;
}

/*
	Name: nml_ramp_up_zombies
	Namespace: zm_moon_wasteland
	Checksum: 0x14193E0D
	Offset: 0x2C68
	Size: 0x388
	Parameters: 0
	Flags: Linked
*/
function nml_ramp_up_zombies()
{
	self endon(#"stop_ramp");
	level waittill(#"start_nml_ramp");
	level.nml_timer = level.nml_last_round;
	while(level flag::get("enter_nml"))
	{
		if(!level.on_the_moon)
		{
			level.nml_timer++;
			level thread zm_utility::play_sound_2d("evt_nomans_warning");
			zombies = getaispeciesarray(level.zombie_team, "zombie");
			for(i = 0; i < zombies.size; i++)
			{
				if(zombies[i].health != level.zombie_health || (isdefined(zombies[i].gibbed) && zombies[i].gibbed) || (isdefined(zombies[i].head_gibbed) && zombies[i].head_gibbed))
				{
					arrayremovevalue(zombies, zombies[i]);
				}
			}
			zombie_utility::ai_calculate_health(level.nml_timer);
			for(i = 0; i < zombies.size; i++)
			{
				if(isdefined(zombies[i].gibbed) && zombies[i].gibbed || (isdefined(zombies[i].head_gibbed) && zombies[i].head_gibbed))
				{
					continue;
				}
				zombies[i].health = level.zombie_health;
				if(isdefined(level.mp_side_step) && level.mp_side_step)
				{
					zombies[i].shouldsidestepfunc = &nml_shouldsidestep;
					zombies[i].sidestepanims = [];
				}
			}
			level thread nml_dog_health_increase();
			zombie_dogs = getaispeciesarray(level.zombie_team, "zombie_dog");
			if(isdefined(zombie_dogs))
			{
				for(i = 0; i < zombie_dogs.size; i++)
				{
					zombie_dogs[i].maxhealth = int(level.nml_dog_health);
					zombie_dogs[i].health = int(level.nml_dog_health);
				}
			}
		}
		if(level.nml_timer == 6)
		{
			level flag::set("start_supersprint");
		}
		wait(20);
	}
}

/*
	Name: nml_dog_health_increase
	Namespace: zm_moon_wasteland
	Checksum: 0xB87F4F5D
	Offset: 0x2FF8
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function nml_dog_health_increase()
{
	if(level.nml_timer < 4)
	{
		level.nml_dog_health = 100;
	}
	else
	{
		if(level.nml_timer >= 4 && level.nml_timer < 6)
		{
			level.nml_dog_health = 400;
		}
		else
		{
			if(level.nml_timer >= 6 && level.nml_timer < 15)
			{
				level.nml_dog_health = 800;
			}
			else
			{
				if(level.nml_timer >= 15 && level.nml_timer < 30)
				{
					level.nml_dog_health = 1200;
				}
				else if(level.nml_timer >= 30)
				{
					level.nml_dog_health = 1600;
				}
			}
		}
	}
}

/*
	Name: nml_shouldsidestep
	Namespace: zm_moon_wasteland
	Checksum: 0xA5A5B073
	Offset: 0x30D0
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function nml_shouldsidestep()
{
	if(self nml_cansidestep())
	{
		return "step";
	}
	return "none";
}

/*
	Name: nml_cansidestep
	Namespace: zm_moon_wasteland
	Checksum: 0xB04EDE6E
	Offset: 0x3108
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function nml_cansidestep()
{
	if((gettime() - self.a.lastsidesteptime) < level.nml_reaction_interval)
	{
		return false;
	}
	if(!isdefined(self.enemy))
	{
		return false;
	}
	if(self.a.pose != "stand")
	{
		return false;
	}
	distsqfromenemy = distancesquared(self.origin, self.enemy.origin);
	if(distsqfromenemy < level.nml_min_reaction_dist_sq)
	{
		return false;
	}
	if(distsqfromenemy > level.nml_max_reaction_dist_sq)
	{
		return false;
	}
	if(!isdefined(self.pathgoalpos) || distancesquared(self.origin, self.pathgoalpos) < level.nml_min_reaction_dist_sq)
	{
		return false;
	}
	if(abs(self getmotionangle()) > 15)
	{
		return false;
	}
	return true;
}

