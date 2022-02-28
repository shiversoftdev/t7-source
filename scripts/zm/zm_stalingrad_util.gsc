// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_raz;
#using scripts\zm\_zm_ai_sentinel_drone;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_stalingrad_dragon;

#namespace zm_stalingrad_util;

/*
	Name: main
	Namespace: zm_stalingrad_util
	Checksum: 0xE2F3BF56
	Offset: 0x610
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread function_828240c9();
	level thread flag_init();
	level thread function_28c0c208();
}

/*
	Name: flag_init
	Namespace: zm_stalingrad_util
	Checksum: 0xD064ADFB
	Offset: 0x668
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function flag_init()
{
	level flag::init("wave_event_raz_spawning_active");
	level flag::init("wave_event_sentinel_spawning_active");
	level flag::init("wave_event_zombies_complete");
}

/*
	Name: function_828240c9
	Namespace: zm_stalingrad_util
	Checksum: 0x350CE5D5
	Offset: 0x6D8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_828240c9()
{
	level waittill(#"start_zombie_round_logic");
	if(isdefined(level._custom_powerups["shield_charge"]))
	{
		arrayremoveindex(level._custom_powerups, "shield_charge", 1);
	}
}

/*
	Name: function_e7c75cf0
	Namespace: zm_stalingrad_util
	Checksum: 0xD330D8FF
	Offset: 0x730
	Size: 0x76
	Parameters: 0
	Flags: Linked
*/
function function_e7c75cf0()
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		e_player = players[i];
		e_player zm::spectator_respawn_player();
	}
}

/*
	Name: function_3fbe7d5f
	Namespace: zm_stalingrad_util
	Checksum: 0xB6DE9779
	Offset: 0x7B0
	Size: 0x190
	Parameters: 0
	Flags: Linked
*/
function function_3fbe7d5f()
{
	while(isdefined(self))
	{
		waittime = randomfloatrange(2.5, 5);
		yaw = randomint(360);
		if(yaw > 300)
		{
			yaw = 300;
		}
		else if(yaw < 60)
		{
			yaw = 60;
		}
		yaw = self.angles[1] + yaw;
		new_angles = (-60 + randomint(120), yaw, -45 + randomint(90));
		self rotateto(new_angles, waittime, waittime * 0.5, waittime * 0.5);
		if(isdefined(self.worldgundw))
		{
			self.worldgundw rotateto(new_angles, waittime, waittime * 0.5, waittime * 0.5);
		}
		wait(randomfloat(waittime - 0.1));
	}
}

/*
	Name: function_acd04dc9
	Namespace: zm_stalingrad_util
	Checksum: 0xB3BBDC95
	Offset: 0x948
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_acd04dc9()
{
	self endon(#"death");
	if(!(isdefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area))
	{
		self waittill(#"completed_emerging_into_playable_area");
	}
	self.no_powerups = 1;
}

/*
	Name: function_1af75b1b
	Namespace: zm_stalingrad_util
	Checksum: 0x4ACA42CC
	Offset: 0x990
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_1af75b1b(n_distance)
{
	foreach(e_player in level.players)
	{
		if(zm_utility::is_player_valid(e_player, 0, 1) && function_86b1188c(n_distance, self, e_player))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_86b1188c
	Namespace: zm_stalingrad_util
	Checksum: 0xC6BB90F3
	Offset: 0xA60
	Size: 0x7E
	Parameters: 3
	Flags: Linked
*/
function function_86b1188c(n_distance, var_d21815c4, var_441f84ff)
{
	var_31dc18aa = n_distance * n_distance;
	var_2931dc75 = distancesquared(var_d21815c4.origin, var_441f84ff.origin);
	if(var_2931dc75 <= var_31dc18aa)
	{
		return true;
	}
	return false;
}

/*
	Name: function_2f621485
	Namespace: zm_stalingrad_util
	Checksum: 0x6E3E2CA0
	Offset: 0xAE8
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_2f621485(b_disable = 1)
{
	if(b_disable && level flag::get("pack_machine_in_use"))
	{
		level flag::wait_till_clear("pack_machine_in_use");
	}
	var_1ac74da9 = getent("pack_a_punch", "script_noteworthy");
	var_1ac74da9 triggerenable(!b_disable);
}

/*
	Name: function_f8043960
	Namespace: zm_stalingrad_util
	Checksum: 0xC5D6DD9A
	Offset: 0xBA0
	Size: 0x14A
	Parameters: 4
	Flags: Linked
*/
function function_f8043960(var_57216c49, e_volume = undefined, var_50efb072 = 1, var_2f65a401 = undefined)
{
	while(true)
	{
		level waittill(#"hash_fbd59317", e_player);
		if(isdefined(var_2f65a401) && ![[var_2f65a401]](e_player))
		{
			continue;
		}
		if(isdefined(e_volume) && !e_player istouching(e_volume))
		{
			continue;
		}
		var_5572b89 = e_player function_7fbdcc5f(var_57216c49);
		if(isdefined(e_player))
		{
			e_player.var_9d9ac25d = undefined;
		}
		if(isdefined(var_5572b89) && var_5572b89)
		{
			if(isdefined(e_volume) && var_50efb072)
			{
				e_volume delete();
			}
			return;
		}
	}
}

/*
	Name: function_7fbdcc5f
	Namespace: zm_stalingrad_util
	Checksum: 0x1C2701B7
	Offset: 0xCF8
	Size: 0x96
	Parameters: 1
	Flags: Linked
*/
function function_7fbdcc5f(var_57216c49)
{
	self endon(#"death");
	self.var_4bd1ce6b endon(#"death");
	self.var_9d9ac25d = 1;
	self.var_4bd1ce6b vehicle_ai::start_scripted();
	var_5572b89 = self [[var_57216c49]]();
	self.var_4bd1ce6b vehicle_ai::stop_scripted();
	if(isdefined(var_5572b89) && var_5572b89)
	{
		return true;
	}
	return false;
}

/*
	Name: function_adf4d1d0
	Namespace: zm_stalingrad_util
	Checksum: 0x610A1BB
	Offset: 0xD98
	Size: 0x5A2
	Parameters: 1
	Flags: Linked
*/
function function_adf4d1d0(a_ai_zombies)
{
	var_63baafec = !isdefined(a_ai_zombies);
	if(var_63baafec)
	{
		a_ai_zombies = getaiteamarray(level.zombie_team);
	}
	var_6b1085eb = [];
	foreach(ai_zombie in a_ai_zombies)
	{
		ai_zombie.no_powerups = 1;
		ai_zombie.deathpoints_already_given = 1;
		if(isdefined(ai_zombie.var_81e263d5) && ai_zombie.var_81e263d5)
		{
			continue;
		}
		if(isdefined(ai_zombie.marked_for_death) && ai_zombie.marked_for_death)
		{
			continue;
		}
		if(isdefined(ai_zombie.nuke_damage_func))
		{
			ai_zombie thread [[ai_zombie.nuke_damage_func]]();
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(ai_zombie))
		{
			continue;
		}
		ai_zombie.marked_for_death = 1;
		ai_zombie.nuked = 1;
		var_6b1085eb[var_6b1085eb.size] = ai_zombie;
	}
	foreach(var_f92b3d80 in var_6b1085eb)
	{
		if(!isdefined(var_f92b3d80))
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(var_f92b3d80))
		{
			continue;
		}
		if(isdefined(var_f92b3d80.var_81e263d5) && var_f92b3d80.var_81e263d5)
		{
			continue;
		}
		var_f92b3d80 dodamage(var_f92b3d80.health, var_f92b3d80.origin);
		if(!(isdefined(var_f92b3d80.exclude_cleanup_adding_to_total) && var_f92b3d80.exclude_cleanup_adding_to_total) && !level flag::get("special_round"))
		{
			level.zombie_total++;
		}
		wait(randomfloatrange(0.05, 0.15));
	}
	if(var_63baafec)
	{
		var_89de5b91 = getaiarchetypearray("raz");
		foreach(var_1c963231 in var_89de5b91)
		{
			if(isdefined(var_1c963231.var_81e263d5) && var_1c963231.var_81e263d5)
			{
				continue;
			}
			if(!(isdefined(var_1c963231.exclude_cleanup_adding_to_total) && var_1c963231.exclude_cleanup_adding_to_total) && !level flag::get("special_round"))
			{
				level.zombie_total++;
			}
			var_1c963231.no_powerups = 1;
			var_1c963231 kill();
		}
		var_1916d2ed = getaiarchetypearray("sentinel_drone");
		foreach(var_663b2442 in var_1916d2ed)
		{
			if(isdefined(var_663b2442.var_81e263d5) && var_663b2442.var_81e263d5)
			{
				continue;
			}
			if(!(isdefined(var_663b2442.exclude_cleanup_adding_to_total) && var_663b2442.exclude_cleanup_adding_to_total) && !level flag::get("special_round"))
			{
				level.zombie_total++;
			}
			var_663b2442.no_powerups = 1;
			var_663b2442 kill();
		}
	}
}

/*
	Name: function_3804dbf1
	Namespace: zm_stalingrad_util
	Checksum: 0x6A2FA752
	Offset: 0x1348
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function function_3804dbf1(b_stop = 1, str_endon = undefined)
{
	if(b_stop)
	{
		if(isdefined(str_endon))
		{
			level endon(str_endon);
		}
		if(!level flag::get("spawn_zombies"))
		{
			level flag::wait_till("spawn_zombies");
		}
		level.disable_nuke_delay_spawning = 1;
		level flag::clear("spawn_zombies");
	}
	else
	{
		if(isdefined(str_endon))
		{
			level notify(str_endon);
		}
		level.disable_nuke_delay_spawning = 1;
		level flag::set("spawn_zombies");
	}
}

/*
	Name: function_f70dde0b
	Namespace: zm_stalingrad_util
	Checksum: 0x2723446F
	Offset: 0x1450
	Size: 0x544
	Parameters: 8
	Flags: Linked
*/
function function_f70dde0b(var_f328e82, a_s_spawnpoints, var_9c84987b, var_2494b61e = 24, var_dc7b7a0f = 0.05, n_max_zombies, str_notify, var_d965b1c7 = 0)
{
	/#
		assert(isdefined(var_f328e82), "");
	#/
	/#
		assert(isdefined(a_s_spawnpoints), "");
	#/
	/#
		assert(isdefined(var_9c84987b), "");
	#/
	level notify(#"hash_91fef4b1");
	level endon(#"hash_91fef4b1");
	level flag::clear("wave_event_zombies_complete");
	if(isdefined(str_notify))
	{
		level endon(str_notify);
	}
	if(!isdefined(n_max_zombies))
	{
		/#
			assert(isdefined(str_notify), "");
		#/
		var_54939bf3 = 1;
	}
	var_9a8fc4a4 = [];
	var_613bb82b = 0;
	if(isdefined(level.var_c3c3ffc5))
	{
		level.var_c3c3ffc5 = array::filter(level.var_c3c3ffc5, 0, &function_91d64824);
		var_9a8fc4a4 = arraycopy(level.var_c3c3ffc5);
		var_9a8fc4a4 = array::filter(var_9a8fc4a4, 0, &function_46cd1314);
		level.var_b1d4e9a1 = var_9a8fc4a4.size;
	}
	else
	{
		level.var_c3c3ffc5 = [];
		level.var_b1d4e9a1 = 0;
	}
	level.var_258441ba = 0;
	if(isarray(var_f328e82))
	{
		e_spawner = array::random(var_f328e82);
	}
	else
	{
		e_spawner = var_f328e82;
	}
	while(isdefined(var_54939bf3) && var_54939bf3 || var_613bb82b < n_max_zombies)
	{
		var_9a8fc4a4 = array::filter(var_9a8fc4a4, 0, &function_91d64824);
		while(var_9a8fc4a4.size < var_2494b61e && (isdefined(var_54939bf3) && var_54939bf3 || var_613bb82b < n_max_zombies))
		{
			var_9a8fc4a4 = array::filter(var_9a8fc4a4, 0, &function_91d64824);
			level function_58cdc394();
			level function_9b76f612("zombie");
			s_spawn_point = get_unused_spawn_point(a_s_spawnpoints);
			ai = zombie_utility::spawn_zombie(e_spawner, var_9c84987b, s_spawn_point);
			if(isdefined(ai))
			{
				if(!isdefined(var_9a8fc4a4))
				{
					var_9a8fc4a4 = [];
				}
				else if(!isarray(var_9a8fc4a4))
				{
					var_9a8fc4a4 = array(var_9a8fc4a4);
				}
				var_9a8fc4a4[var_9a8fc4a4.size] = ai;
				if(!isdefined(level.var_c3c3ffc5))
				{
					level.var_c3c3ffc5 = [];
				}
				else if(!isarray(level.var_c3c3ffc5))
				{
					level.var_c3c3ffc5 = array(level.var_c3c3ffc5);
				}
				level.var_c3c3ffc5[level.var_c3c3ffc5.size] = ai;
				var_613bb82b++;
				ai thread function_ff194e31(var_d965b1c7);
			}
			wait(var_dc7b7a0f);
		}
		wait(0.05);
	}
	while(var_9a8fc4a4.size > 0)
	{
		var_9a8fc4a4 = array::filter(var_9a8fc4a4, 0, &function_91d64824);
		wait(0.5);
	}
	level flag::set("wave_event_zombies_complete");
}

/*
	Name: function_9b76f612
	Namespace: zm_stalingrad_util
	Checksum: 0xB7BBB461
	Offset: 0x19A0
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_9b76f612(var_56d259ba)
{
	var_eec0f058 = 0;
	if(isdefined(level.var_9ddab511))
	{
		var_eec0f058 = level [[level.var_9ddab511]](var_56d259ba);
	}
	while(isdefined(level.var_4209c599) && level.var_4209c599 || var_eec0f058)
	{
		wait(randomfloatrange(0.1, 0.2));
		if(var_eec0f058)
		{
			var_eec0f058 = level [[level.var_9ddab511]](var_56d259ba);
		}
	}
	level.var_4209c599 = 1;
}

/*
	Name: function_28c0c208
	Namespace: zm_stalingrad_util
	Checksum: 0x2E2A638A
	Offset: 0x1A58
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_28c0c208()
{
	while(true)
	{
		util::wait_network_frame();
		level.var_4209c599 = 0;
	}
}

/*
	Name: function_91d64824
	Namespace: zm_stalingrad_util
	Checksum: 0xA39409DF
	Offset: 0x1A90
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function function_91d64824(val)
{
	return isalive(val) && (!(isdefined(val.aat_turned) && val.aat_turned)) && (!(isdefined(val.var_1d3a1f9e) && val.var_1d3a1f9e));
}

/*
	Name: function_46cd1314
	Namespace: zm_stalingrad_util
	Checksum: 0x6864F0E1
	Offset: 0x1B08
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function function_46cd1314(val)
{
	return isalive(val) && (!(isdefined(val.aat_turned) && val.aat_turned)) && isdefined(val.archetype) && val.archetype == "zombie";
}

/*
	Name: function_412874e
	Namespace: zm_stalingrad_util
	Checksum: 0xCE31D24A
	Offset: 0x1B88
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function function_412874e(val)
{
	return isalive(val) && isdefined(val.archetype) && val.archetype == "raz";
}

/*
	Name: function_f0610596
	Namespace: zm_stalingrad_util
	Checksum: 0x642C5BD5
	Offset: 0x1BE0
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function function_f0610596(val)
{
	return isalive(val) && isdefined(val.archetype) && val.archetype == "sentinel_drone";
}

/*
	Name: function_ff194e31
	Namespace: zm_stalingrad_util
	Checksum: 0x7FB587C4
	Offset: 0x1C38
	Size: 0xF0
	Parameters: 1
	Flags: Linked
*/
function function_ff194e31(var_d965b1c7)
{
	self endon(#"death");
	self thread function_b74ff7d4();
	self setphysparams(15, 0, 72);
	self.ignore_enemy_count = 1;
	self.exclude_cleanup_adding_to_total = 1;
	self.sword_kill_power = 2;
	self.heroweapon_kill_power = 2;
	util::wait_network_frame();
	if(!var_d965b1c7)
	{
		self.no_damage_points = 1;
		self.deathpoints_already_given = 1;
		self thread function_acd04dc9();
	}
	self zombie_utility::set_zombie_run_cycle("sprint");
	self.nocrawler = 1;
}

/*
	Name: function_b74ff7d4
	Namespace: zm_stalingrad_util
	Checksum: 0x8206D0E3
	Offset: 0x1D30
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_b74ff7d4()
{
	ai_zombie = self;
	ai_zombie waittill(#"death", e_attacker);
	if(isplayer(e_attacker))
	{
		[[level.hero_power_update]](e_attacker, ai_zombie);
	}
}

/*
	Name: function_d182335a
	Namespace: zm_stalingrad_util
	Checksum: 0xD7799767
	Offset: 0x1D98
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function function_d182335a(ai_zombie)
{
	level.var_b1d4e9a1++;
	ai_zombie waittill(#"death");
	level.var_258441ba++;
}

/*
	Name: get_unused_spawn_point
	Namespace: zm_stalingrad_util
	Checksum: 0xD38D5A5A
	Offset: 0x1DD0
	Size: 0x158
	Parameters: 1
	Flags: Linked
*/
function get_unused_spawn_point(a_s_spawnpoints)
{
	b_all_points_used = 0;
	a_valid_spawn_points = [];
	while(!a_valid_spawn_points.size)
	{
		foreach(s_spawn_point in a_s_spawnpoints)
		{
			if(!isdefined(s_spawn_point.spawned_zombie) || b_all_points_used)
			{
				s_spawn_point.spawned_zombie = 0;
			}
			if(!s_spawn_point.spawned_zombie)
			{
				array::add(a_valid_spawn_points, s_spawn_point, 0);
			}
		}
		if(!a_valid_spawn_points.size)
		{
			b_all_points_used = 1;
		}
		wait(0.05);
	}
	s_spawn_point = array::random(a_valid_spawn_points);
	s_spawn_point.spawned_zombie = 1;
	return s_spawn_point;
}

/*
	Name: function_b55ebb81
	Namespace: zm_stalingrad_util
	Checksum: 0x12CF87BD
	Offset: 0x1F30
	Size: 0x5EA
	Parameters: 7
	Flags: Linked
*/
function function_b55ebb81(a_spawnpoints, var_2b71b5b4, var_15eb9a52, var_f92c3865, var_b4fcee85, str_notify_end, var_ee8c6a82 = 0)
{
	level notify(#"turbine_idle");
	level endon(#"turbine_idle");
	if(isdefined(str_notify_end))
	{
		level endon(str_notify_end);
		level thread function_4334972f("wave_event_raz_complete", str_notify_end, "wave_event_raz_spawning_active");
	}
	if(!isdefined(var_2b71b5b4))
	{
		/#
			assert(isdefined(str_notify_end), "");
		#/
		var_54939bf3 = 1;
	}
	if(var_f92c3865 < 0.1)
	{
		var_f92c3865 = 0.1;
	}
	if(isdefined(var_ee8c6a82) && var_ee8c6a82)
	{
		var_60d8c6a2 = 0;
	}
	level flag::set("wave_event_raz_spawning_active");
	var_4751753a = [];
	var_766273f0 = 0;
	while(isdefined(var_b4fcee85) && !isdefined(level.var_c3c3ffc5))
	{
		wait(0.05);
	}
	if(isdefined(level.var_c3c3ffc5))
	{
		level.var_c3c3ffc5 = array::filter(level.var_c3c3ffc5, 0, &function_91d64824);
		var_4751753a = arraycopy(level.var_c3c3ffc5);
		var_4751753a = array::filter(var_4751753a, 0, &function_412874e);
		var_766273f0 = var_4751753a.size;
	}
	util::wait_network_frame();
	while(isdefined(var_54939bf3) && var_54939bf3 || var_766273f0 < var_2b71b5b4 && level flag::get("wave_event_raz_spawning_active"))
	{
		var_4751753a = array::remove_dead(var_4751753a, 0);
		while(var_4751753a.size < var_15eb9a52 && (isdefined(var_54939bf3) && var_54939bf3 || var_766273f0 < var_2b71b5b4) && level flag::get("wave_event_raz_spawning_active"))
		{
			var_4751753a = array::remove_dead(var_4751753a, 0);
			level function_9b76f612("raz");
			var_1c963231 = function_432cdad9(a_spawnpoints);
			if(isalive(var_1c963231))
			{
				var_1c963231.no_powerups = 1;
				var_1c963231.no_damage_points = 1;
				var_1c963231.deathpoints_already_given = 1;
				if(!isdefined(var_4751753a))
				{
					var_4751753a = [];
				}
				else if(!isarray(var_4751753a))
				{
					var_4751753a = array(var_4751753a);
				}
				var_4751753a[var_4751753a.size] = var_1c963231;
				if(!isdefined(level.var_c3c3ffc5))
				{
					level.var_c3c3ffc5 = [];
				}
				else if(!isarray(level.var_c3c3ffc5))
				{
					level.var_c3c3ffc5 = array(level.var_c3c3ffc5);
				}
				level.var_c3c3ffc5[level.var_c3c3ffc5.size] = var_1c963231;
				var_1c963231 function_d48ad6b4();
				var_766273f0++;
				if(isdefined(var_ee8c6a82) && var_ee8c6a82)
				{
					if(isdefined(level.var_141e2500) && level.var_141e2500 && var_60d8c6a2 >= 3)
					{
						level.var_141e2500 = 0;
						var_60d8c6a2 = 0;
					}
					else
					{
						level.var_141e2500 = 1;
						var_60d8c6a2++;
					}
				}
				if(isdefined(level.var_141e2500) && level.var_141e2500)
				{
					var_1c963231.invoke_sprint_time = gettime();
				}
			}
			level function_a03df69f(var_f92c3865, var_b4fcee85, str_notify_end);
		}
		util::wait_network_frame();
		if(isdefined(var_2b71b5b4) && level flag::get("wave_event_zombies_complete"))
		{
			var_15eb9a52 = var_2b71b5b4;
		}
	}
	while(var_4751753a.size > 0 && level flag::get("wave_event_raz_spawning_active"))
	{
		var_4751753a = array::remove_dead(var_4751753a, 0);
		wait(0.05);
	}
	level flag::clear("wave_event_raz_spawning_active");
	level notify(#"wave_event_raz_complete");
}

/*
	Name: function_4334972f
	Namespace: zm_stalingrad_util
	Checksum: 0x9589E0F
	Offset: 0x2528
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function function_4334972f(str_endon, str_notify_end, var_1d9f5031)
{
	level endon(str_endon);
	level waittill(str_notify_end);
	level flag::clear(var_1d9f5031);
}

/*
	Name: function_432cdad9
	Namespace: zm_stalingrad_util
	Checksum: 0xC2A181F6
	Offset: 0x2578
	Size: 0x24C
	Parameters: 2
	Flags: Linked
*/
function function_432cdad9(a_spawnpoints, var_e41e673a)
{
	players = getplayers();
	var_19764360 = zm_ai_raz::get_favorite_enemy();
	if(isdefined(level.var_a3559c05))
	{
		s_spawn_loc = [[level.var_a3559c05]](level.var_6bca5baa, var_19764360);
	}
	else
	{
		if(isdefined(a_spawnpoints))
		{
			s_spawn_loc = function_77b29938(a_spawnpoints);
		}
		else if(level.zm_loc_types["raz_location"].size > 0)
		{
			s_spawn_loc = array::random(level.zm_loc_types["raz_location"]);
		}
	}
	if(!isdefined(s_spawn_loc))
	{
		return undefined;
	}
	ai = zm_ai_raz::function_665a13cd(level.var_6bca5baa[0]);
	if(isdefined(ai))
	{
		ai forceteleport(s_spawn_loc.origin, s_spawn_loc.angles);
		ai.script_string = s_spawn_loc.script_string;
		ai.find_flesh_struct_string = ai.script_string;
		ai.sword_kill_power = 4;
		ai.heroweapon_kill_power = 4;
		if(isdefined(var_19764360))
		{
			ai.favoriteenemy = var_19764360;
			ai.favoriteenemy.hunted_by++;
		}
		if(isdefined(var_e41e673a))
		{
			ai thread [[var_e41e673a]]();
		}
		playsoundatposition("zmb_raz_spawn", s_spawn_loc.origin);
		return ai;
	}
	return undefined;
}

/*
	Name: function_a03df69f
	Namespace: zm_stalingrad_util
	Checksum: 0xFA040559
	Offset: 0x27D0
	Size: 0x118
	Parameters: 3
	Flags: Linked
*/
function function_a03df69f(var_f92c3865, var_b4fcee85, str_notify_end)
{
	level notify(#"hash_7794a855");
	level endon(#"hash_7794a855");
	if(isdefined(str_notify_end))
	{
		level endon(str_notify_end);
	}
	if(!isdefined(var_b4fcee85))
	{
		wait(var_f92c3865);
		return;
	}
	var_c0068ac4 = level.var_258441ba;
	level.var_c3c3ffc5 = array::remove_dead(level.var_c3c3ffc5, 0);
	n_time_start = gettime() / 1000;
	do
	{
		var_bd4301c0 = level.var_258441ba - var_c0068ac4;
		n_time_current = gettime() / 1000;
		n_time_elapsed = n_time_current - n_time_start;
		wait(0.05);
	}
	while(var_bd4301c0 < var_b4fcee85 && n_time_elapsed < var_f92c3865);
}

/*
	Name: function_77b29938
	Namespace: zm_stalingrad_util
	Checksum: 0x333D667
	Offset: 0x28F0
	Size: 0x1B8
	Parameters: 2
	Flags: Linked
*/
function function_77b29938(a_spawners, var_19764360)
{
	b_all_points_used = 0;
	if(isdefined(a_spawners))
	{
		a_spawnpoints = arraycopy(a_spawners);
	}
	else
	{
		a_spawnpoints = arraycopy(level.zm_loc_types["raz_location"]);
	}
	a_valid_spawn_points = [];
	while(!a_valid_spawn_points.size)
	{
		foreach(s_spawn_point in a_spawnpoints)
		{
			if(!isdefined(s_spawn_point.spawned_zombie) || b_all_points_used)
			{
				s_spawn_point.spawned_zombie = 0;
			}
			if(!s_spawn_point.spawned_zombie)
			{
				array::add(a_valid_spawn_points, s_spawn_point, 0);
			}
		}
		if(!a_valid_spawn_points.size)
		{
			b_all_points_used = 1;
		}
		wait(0.05);
	}
	s_spawn_point = array::random(a_valid_spawn_points);
	s_spawn_point.spawned_zombie = 1;
	return s_spawn_point;
}

/*
	Name: function_923f7f72
	Namespace: zm_stalingrad_util
	Checksum: 0x38AC350A
	Offset: 0x2AB0
	Size: 0x4BA
	Parameters: 5
	Flags: Linked
*/
function function_923f7f72(var_af22dd13, var_ed448d3b, var_e25e1ccc, var_b4fcee85, str_notify_end)
{
	level notify(#"hash_93ef69e7");
	level endon(#"hash_93ef69e7");
	if(isdefined(str_notify_end))
	{
		level endon(str_notify_end);
		level thread function_4334972f("wave_event_sentinels_complete", str_notify_end, "wave_event_sentinel_spawning_active");
	}
	if(var_e25e1ccc < 0.1)
	{
		var_e25e1ccc = 0.1;
	}
	if(!isdefined(var_af22dd13))
	{
		var_54939bf3 = 1;
	}
	level flag::set("wave_event_sentinel_spawning_active");
	var_5e8e8152 = [];
	var_469adf27 = 0;
	while(!isdefined(level.var_c3c3ffc5))
	{
		wait(0.05);
	}
	if(isdefined(level.var_c3c3ffc5))
	{
		level.var_c3c3ffc5 = array::filter(level.var_c3c3ffc5, 0, &function_91d64824);
		var_5e8e8152 = arraycopy(level.var_c3c3ffc5);
		var_5e8e8152 = array::filter(var_5e8e8152, 0, &function_f0610596);
		var_469adf27 = var_5e8e8152.size;
	}
	util::wait_network_frame();
	while(isdefined(var_54939bf3) && var_54939bf3 || var_469adf27 < var_af22dd13 && level flag::get("wave_event_sentinel_spawning_active"))
	{
		var_5e8e8152 = array::remove_dead(var_5e8e8152, 0);
		while(var_5e8e8152.size < var_ed448d3b && (isdefined(var_54939bf3) && var_54939bf3 || var_469adf27 < var_af22dd13) && level flag::get("wave_event_sentinel_spawning_active"))
		{
			var_5e8e8152 = array::remove_dead(var_5e8e8152, 0);
			level function_9b76f612("sentinel");
			var_663b2442 = function_70e59bda();
			if(isalive(var_663b2442))
			{
				var_663b2442.no_powerups = 1;
				var_663b2442.no_damage_points = 1;
				var_663b2442.deathpoints_already_given = 1;
				if(!isdefined(var_5e8e8152))
				{
					var_5e8e8152 = [];
				}
				else if(!isarray(var_5e8e8152))
				{
					var_5e8e8152 = array(var_5e8e8152);
				}
				var_5e8e8152[var_5e8e8152.size] = var_663b2442;
				if(!isdefined(level.var_c3c3ffc5))
				{
					level.var_c3c3ffc5 = [];
				}
				else if(!isarray(level.var_c3c3ffc5))
				{
					level.var_c3c3ffc5 = array(level.var_c3c3ffc5);
				}
				level.var_c3c3ffc5[level.var_c3c3ffc5.size] = var_663b2442;
				var_663b2442 function_d48ad6b4();
				var_469adf27++;
			}
			wait(var_e25e1ccc);
			if(level flag::get("wave_event_zombies_complete"))
			{
				var_ed448d3b = var_af22dd13;
			}
		}
		util::wait_network_frame();
	}
	while(var_5e8e8152.size > 0 && level flag::get("wave_event_sentinel_spawning_active"))
	{
		var_5e8e8152 = array::remove_dead(var_5e8e8152, 0);
		wait(0.05);
	}
	level flag::clear("wave_event_sentinel_spawning_active");
	level notify(#"wave_event_sentinels_complete");
}

/*
	Name: function_70e59bda
	Namespace: zm_stalingrad_util
	Checksum: 0x4D606F55
	Offset: 0x2F78
	Size: 0x124
	Parameters: 2
	Flags: Linked
*/
function function_70e59bda(var_e41e673a, var_1d8ab289)
{
	if(isdefined(var_1d8ab289))
	{
		s_spawn_loc = var_1d8ab289;
	}
	else
	{
		if(isdefined(level.var_809d579e))
		{
			s_spawn_loc = [[level.var_809d579e]](level.var_fda4b3f3);
		}
		else
		{
			s_spawn_loc = zm_ai_sentinel_drone::function_f9c9e7e0();
		}
	}
	if(!isdefined(s_spawn_loc))
	{
		return undefined;
	}
	ai = zm_ai_sentinel_drone::function_fded8158(level.var_fda4b3f3[0]);
	if(isdefined(ai))
	{
		ai thread zm_ai_sentinel_drone::function_b27530eb(s_spawn_loc.origin);
		if(isdefined(var_e41e673a))
		{
			ai thread [[var_e41e673a]]();
		}
		ai.sword_kill_power = 4;
		ai.heroweapon_kill_power = 4;
		return ai;
	}
	return undefined;
}

/*
	Name: function_383b110b
	Namespace: zm_stalingrad_util
	Checksum: 0xA6F2A445
	Offset: 0x30A8
	Size: 0x1B0
	Parameters: 1
	Flags: None
*/
function function_383b110b(a_spawners)
{
	b_all_points_used = 0;
	if(isdefined(a_spawners))
	{
		a_spawnpoints = arraycopy(a_spawners);
	}
	else
	{
		a_spawnpoints = arraycopy(level.zm_loc_types["sentinel_location"]);
	}
	a_valid_spawn_points = [];
	while(!a_valid_spawn_points.size)
	{
		foreach(s_spawn_point in a_spawnpoints)
		{
			if(!isdefined(s_spawn_point.var_1565f394) || b_all_points_used)
			{
				s_spawn_point.var_1565f394 = 0;
			}
			if(!s_spawn_point.var_1565f394)
			{
				array::add(a_valid_spawn_points, s_spawn_point, 0);
			}
		}
		if(!a_valid_spawn_points.size)
		{
			b_all_points_used = 1;
		}
		wait(0.05);
	}
	s_spawn_point = array::random(a_valid_spawn_points);
	s_spawn_point.var_1565f394 = 1;
	return s_spawn_point;
}

/*
	Name: function_d48ad6b4
	Namespace: zm_stalingrad_util
	Checksum: 0x38DB81AC
	Offset: 0x3260
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_d48ad6b4()
{
	level.var_c3c3ffc5 = array::remove_dead(level.var_c3c3ffc5, 0);
	if(isdefined(level.var_5fe02c5a))
	{
		var_456e8c26 = level.var_5fe02c5a;
	}
	else
	{
		var_456e8c26 = level.zombie_ai_limit;
	}
	if(level.var_c3c3ffc5.size > var_456e8c26)
	{
		n_to_kill = level.var_c3c3ffc5.size - var_456e8c26;
		if(isvehicle(self))
		{
			n_to_kill++;
		}
		for(i = 0; i < n_to_kill; i++)
		{
			do
			{
				ai_target = array::random(level.var_c3c3ffc5);
				wait(0.05);
			}
			while(!level function_4614e0e9(ai_target));
			ai_target.var_1d3a1f9e = 1;
			wait(0.05);
			if(function_4614e0e9(ai_target))
			{
				ai_target kill();
			}
			level.var_c3c3ffc5 = array::remove_dead(level.var_c3c3ffc5, 0);
			if(level.var_c3c3ffc5.size <= var_456e8c26)
			{
				break;
			}
		}
		return true;
	}
	return false;
}

/*
	Name: function_4614e0e9
	Namespace: zm_stalingrad_util
	Checksum: 0x4611A9C4
	Offset: 0x3410
	Size: 0x56
	Parameters: 1
	Flags: Linked
*/
function function_4614e0e9(ai_target)
{
	if(!isdefined(ai_target))
	{
		return false;
	}
	if(ai_target.archetype !== "zombie" || zm_utility::is_magic_bullet_shield_enabled(ai_target))
	{
		return false;
	}
	return true;
}

/*
	Name: function_58cdc394
	Namespace: zm_stalingrad_util
	Checksum: 0x6717F33D
	Offset: 0x3470
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function function_58cdc394()
{
	while(level.var_c3c3ffc5.size >= level.zombie_ai_limit)
	{
		level.var_c3c3ffc5 = array::remove_dead(level.var_c3c3ffc5, 0);
		wait(0.05);
	}
}

/*
	Name: function_5eeabbe0
	Namespace: zm_stalingrad_util
	Checksum: 0x8A215CE9
	Offset: 0x34C0
	Size: 0x334
	Parameters: 4
	Flags: Linked
*/
function function_5eeabbe0(var_47ee7db6, nd_path_start, var_f08b56c6, str_notify)
{
	self.var_fa6d2a24 = 1;
	self zm_utility::increment_ignoreme();
	self bgb::suspend_weapon_cycling();
	self.var_4222bc21 = 1;
	self.var_13f86a82 = spawner::simple_spawn_single(var_47ee7db6);
	self.var_13f86a82 setignorepauseworld(1);
	self.var_13f86a82 setacceleration(500);
	self.var_13f86a82 setturningability(0.3);
	self.var_13f86a82.origin = self.origin;
	self setplayerangles(self.var_13f86a82.angles);
	self.var_13f86a82.e_parent = self;
	self notify(#"hash_94217b77");
	switch(nd_path_start.targetname)
	{
		case "sewer_ride_start":
		{
			exploder::exploder("fxexp_501");
			break;
		}
		case "ee_sewer_rail_start":
		{
			exploder::exploder("fxexp_503");
		}
		default:
		{
			break;
		}
	}
	self playerlinktodelta(self.var_13f86a82, undefined, 1, 20, 20, 15, 60);
	self.var_13f86a82 vehicle::get_on_path(nd_path_start);
	self playsound("evt_zipline_attach");
	self thread function_6efec755(var_f08b56c6);
	self util::magic_bullet_shield();
	self.var_13f86a82 waittill(#"rail_over");
	self.var_fa6d2a24 = 0;
	self zm_utility::decrement_ignoreme();
	self.var_4222bc21 = 0;
	self bgb::resume_weapon_cycling();
	if(isdefined(str_notify))
	{
		level notify(str_notify);
	}
	if(!(isdefined(level.var_2de93bbe) && level.var_2de93bbe) && nd_path_start.targetname != "ee_sewer_rail_start")
	{
		self zm_audio::create_and_play_dialog("transport", "sewer");
	}
	self util::stop_magic_bullet_shield();
}

/*
	Name: function_6efec755
	Namespace: zm_stalingrad_util
	Checksum: 0x9D2CFD3A
	Offset: 0x3800
	Size: 0x1DE
	Parameters: 1
	Flags: Linked
*/
function function_6efec755(var_f08b56c6)
{
	self endon(#"disconnect");
	self endon(#"switch_rail");
	self.var_13f86a82 thread play_current_fx();
	self clientfield::set_to_player("tp_water_sheeting", 1);
	self.var_13f86a82 vehicle::go_path();
	if(isdefined(var_f08b56c6))
	{
		self.var_13f86a82.origin = var_f08b56c6.origin;
		self.origin = var_f08b56c6.origin;
		self setplayerangles(var_f08b56c6.angles);
		self.var_13f86a82 vehicle::get_on_path(var_f08b56c6);
		self.var_13f86a82 vehicle::go_path();
	}
	self.var_13f86a82 notify(#"rail_over");
	self clientfield::increment_to_player("sewer_landing_rumble");
	self playsound("zmb_stalingrad_sewer_air_land");
	self stoploopsound(0.4);
	self unlink();
	self clientfield::set_to_player("tp_water_sheeting", 0);
	wait(0.3);
	self.var_13f86a82 delete();
	self.var_a0a9409e = undefined;
}

/*
	Name: function_ab2df0ca
	Namespace: zm_stalingrad_util
	Checksum: 0xF57CBC5E
	Offset: 0x39E8
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function function_ab2df0ca()
{
	self endon(#"rail_over");
	self endon(#"disconnect");
	self waittill(#"hash_94217b77");
	self.var_13f86a82 waittill(#"hash_c4eac163");
	self clientfield::set_to_player("drown_stage", 4);
	wait(0.5);
	self lui::screen_fade_out(1.5);
	self.var_13f86a82 util::waittill_notify_or_timeout("sewer_fade_up", 3);
	self lui::screen_fade_in(1);
	self clientfield::set_to_player("drown_stage", 0);
}

/*
	Name: play_current_fx
	Namespace: zm_stalingrad_util
	Checksum: 0x89BB7519
	Offset: 0x3AD8
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function play_current_fx()
{
	self endon(#"rail_over");
	while(true)
	{
		playfxontag(level._effect["current_effect"], self, "tag_origin");
		wait(0.1);
	}
}

/*
	Name: function_eda4b163
	Namespace: zm_stalingrad_util
	Checksum: 0x6E04E75D
	Offset: 0x3B30
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_eda4b163()
{
	while(true)
	{
		self trigger::wait_till();
		exploder::exploder(self.script_string);
	}
}

/*
	Name: function_4da6e8
	Namespace: zm_stalingrad_util
	Checksum: 0xBFBC9F26
	Offset: 0x3B78
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function function_4da6e8(b_open)
{
	var_2e1f1409 = getent("dept_occluder", "targetname");
	if(b_open)
	{
		var_2e1f1409 ghost();
		var_2e1f1409 notsolid();
		umbragate_set("umbragate1", 1);
	}
	else
	{
		var_2e1f1409 show();
		var_2e1f1409 solid();
		umbragate_set("umbragate1", 0);
	}
}

/*
	Name: function_903f6b36
	Namespace: zm_stalingrad_util
	Checksum: 0x77AFD827
	Offset: 0x3C58
	Size: 0x1E4
	Parameters: 2
	Flags: Linked
*/
function function_903f6b36(b_turn_on, str_identifier = undefined)
{
	if(!isdefined(str_identifier))
	{
		str_identifier = self.script_noteworthy;
		var_144a9df9 = getentarray(str_identifier, "targetname");
	}
	else
	{
		var_144a9df9 = getentarray(str_identifier + "_switch", "targetname");
	}
	if(b_turn_on)
	{
		str_scene = "p7_fxanim_zm_stal_power_switch_on_bundle";
		exploder::exploder(str_identifier + "_red");
		exploder::stop_exploder(str_identifier + "_green");
	}
	else
	{
		str_scene = "p7_fxanim_zm_stal_power_switch_reset_bundle";
	}
	foreach(e_switch in var_144a9df9)
	{
		e_switch thread scene::play(str_scene, e_switch);
	}
	wait(1);
	if(!b_turn_on)
	{
		exploder::exploder(str_identifier + "_green");
		exploder::stop_exploder(str_identifier + "_red");
	}
}

/*
	Name: function_c66f2957
	Namespace: zm_stalingrad_util
	Checksum: 0x704789EC
	Offset: 0x3E48
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function function_c66f2957(s_point)
{
	return s_point.script_noteworthy === "spawn_location" || s_point.script_noteworthy === "riser_location";
}

