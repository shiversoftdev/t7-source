// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_zod_quest;
#using scripts\zm\zm_zod_util;

#namespace careadefend;

/*
	Name: init
	Namespace: careadefend
	Checksum: 0x8CE06DDE
	Offset: 0x3F8
	Size: 0x184
	Parameters: 2
	Flags: Linked
*/
function init(str_centerpoint, str_spawn)
{
	self.m_s_centerpoint = struct::get(str_centerpoint, "targetname");
	self.m_str_spawn = str_spawn;
	self.m_n_defend_duration = 30;
	self.m_n_defend_current_progress = 0;
	self.m_n_defend_progress_per_update_interval = 100 / self.m_n_defend_duration * 0.1;
	self.m_n_defend_grace_duration = 5;
	self.m_n_defend_grace_remaining = self.m_n_defend_grace_duration;
	self.m_n_defend_radius = 220;
	self.m_n_defend_radius_sq = self.m_n_defend_radius * self.m_n_defend_radius;
	self.m_n_rumble_radius = self.m_n_defend_radius;
	self.m_n_rumble_radius_sq = self.m_n_rumble_radius * self.m_n_rumble_radius;
	self.m_str_area_defend_unavailable = &"ZM_ZOD_DEFEND_AREA_UNAVAILABLE";
	self.m_str_area_defend_available = &"ZM_ZOD_DEFEND_AREA_AVAILABLE";
	self.m_str_area_defend_in_progress = &"ZM_ZOD_DEFEND_AREA_IN_PROGRESS";
	self.m_func_trigger_visibility = &ritual_start_prompt_and_visibility;
	m_func_trigger_thread = &usetrigger_think;
	populate_spawn_points();
	self.m_n_state = 0;
	self.m_b_started = 0;
	update_usetrigger_hintstring();
}

/*
	Name: populate_spawn_points
	Namespace: careadefend
	Checksum: 0xA0DBF1B5
	Offset: 0x588
	Size: 0x1B8
	Parameters: 0
	Flags: Linked
*/
function populate_spawn_points()
{
	self.m_a_e_zombie_spawners = getentarray("ritual_zombie_spawner", "targetname");
	a_s_spawn_points = struct::get_array(self.m_str_spawn, "targetname");
	foreach(var_518797a1, s_spawn_point in a_s_spawn_points)
	{
		e_deletable_spawn_point = spawn("script_model", s_spawn_point.origin);
		e_deletable_spawn_point setmodel("tag_origin");
		e_deletable_spawn_point.origin = s_spawn_point.origin;
		e_deletable_spawn_point.angles = s_spawn_point.angles;
		if(!isdefined(self.m_e_spawn_points))
		{
			self.m_e_spawn_points = [];
		}
		else if(!isarray(self.m_e_spawn_points))
		{
			self.m_e_spawn_points = array(self.m_e_spawn_points);
		}
		self.m_e_spawn_points[self.m_e_spawn_points.size] = e_deletable_spawn_point;
	}
}

/*
	Name: set_trigger_visibility_function
	Namespace: careadefend
	Checksum: 0x71FD5A1D
	Offset: 0x748
	Size: 0x18
	Parameters: 1
	Flags: Linked
*/
function set_trigger_visibility_function(func_trigger_visibility)
{
	self.m_func_trigger_visibility = func_trigger_visibility;
}

/*
	Name: set_external_functions
	Namespace: careadefend
	Checksum: 0xF7E639A7
	Offset: 0x768
	Size: 0x68
	Parameters: 5
	Flags: Linked
*/
function set_external_functions(func_prereq, func_start, func_succeed, func_fail, arg1)
{
	self.m_func_prereq = func_prereq;
	self.m_func_start = func_start;
	self.m_func_succeed = func_succeed;
	self.m_func_fail = func_fail;
	self.var_20a1be38 = arg1;
}

/*
	Name: set_luimenus
	Namespace: careadefend
	Checksum: 0x4D1ABDB8
	Offset: 0x7D8
	Size: 0x54
	Parameters: 4
	Flags: Linked
*/
function set_luimenus(str_luimenu_progress, str_luimenu_return, str_luimenu_succeeded, str_luimenu_failed)
{
	self.m_str_luimenu_progress = str_luimenu_progress;
	self.m_str_luimenu_return = str_luimenu_return;
	self.m_str_luimenu_succeeded = str_luimenu_succeeded;
	self.m_str_luimenu_failed = str_luimenu_failed;
}

/*
	Name: set_volumes
	Namespace: careadefend
	Checksum: 0x58CBDD78
	Offset: 0x838
	Size: 0xB4
	Parameters: 2
	Flags: Linked
*/
function set_volumes(str_defend_volume, str_rumble_volume)
{
	self.m_e_defend_volume = getent(str_defend_volume, "targetname");
	self.m_e_rumble_volume = getent(str_rumble_volume, "targetname");
	/#
		assert(isdefined(self.m_e_defend_volume), "");
	#/
	/#
		assert(isdefined(self.m_e_rumble_volume), "");
	#/
}

/*
	Name: set_duration
	Namespace: careadefend
	Checksum: 0x82F5A088
	Offset: 0x8F8
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function set_duration(n_duration)
{
	self.m_n_defend_duration = n_duration;
	self.m_n_defend_progress_per_update_interval = 100 / self.m_n_defend_duration * 0.1;
}

/*
	Name: start
	Namespace: careadefend
	Checksum: 0xD8419F75
	Offset: 0x938
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function start()
{
	ritual_start_dims = (110, 110, 128);
	self.m_t_use = zm_zod_util::spawn_trigger_box(self.m_s_centerpoint.origin, self.m_s_centerpoint.angles, ritual_start_dims, 1);
	self.m_t_use.o_defend_area = self;
	self.m_t_use.prompt_and_visibility_func = self.m_func_trigger_visibility;
	self.m_b_started = 1;
	update_usetrigger_hintstring();
	self thread usetrigger_think();
}

/*
	Name: set_availability
	Namespace: careadefend
	Checksum: 0x2BCE6B1E
	Offset: 0xA08
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function set_availability(b_is_available)
{
	if(b_is_available && self.m_n_state == 0)
	{
		self.m_n_state = 1;
	}
	else if(!b_is_available && self.m_n_state == 1)
	{
		self.m_n_state = 0;
	}
	update_usetrigger_hintstring();
}

/*
	Name: ritual_start_message_internal
	Namespace: careadefend
	Checksum: 0x27E6D9F
	Offset: 0xA80
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function ritual_start_message_internal(player)
{
	if(!self.m_b_started)
	{
		return &"";
	}
	switch(self.m_n_state)
	{
		case 0:
		{
			return self.m_str_area_defend_unavailable;
		}
		case 1:
		{
			return self.m_str_area_defend_available;
		}
		default
		{
			return &"";
		}
	}
}

/*
	Name: ritual_start_visible_internal
	Namespace: careadefend
	Checksum: 0x8E2E5971
	Offset: 0xAF0
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function ritual_start_visible_internal(player)
{
	if(isdefined(player.beastmode) && player.beastmode)
	{
		return 0;
	}
	if(isdefined(level.var_522a1f61) && level.var_522a1f61)
	{
		return 0;
	}
	if(self.m_b_started)
	{
		switch(self.m_n_state)
		{
			case 0:
			case 1:
			{
				return 1;
			}
			default
			{
				break;
			}
		}
	}
	return 0;
}

/*
	Name: ritual_start_prompt_and_visibility
	Namespace: careadefend
	Checksum: 0xC818E23F
	Offset: 0xB90
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function ritual_start_prompt_and_visibility(player)
{
	b_is_visible = [[ self.stub.o_defend_area ]]->ritual_start_visible_internal(player);
	if(b_is_visible)
	{
		str_msg = [[ self.stub.o_defend_area ]]->ritual_start_message_internal(player);
		self sethintstring(str_msg);
		thread function_4e035595(player);
	}
	else
	{
		self sethintstring(&"");
	}
	return b_is_visible;
}

/*
	Name: function_4e035595
	Namespace: careadefend
	Checksum: 0x391EFB7F
	Offset: 0xC58
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function function_4e035595(player)
{
	self endon(#"disconnect");
	if(isdefined(player.var_b999c630) && player.var_b999c630 || !level flag::get("ritual_in_progress"))
	{
		return;
	}
	player.var_b999c630 = 1;
	if(zm_utility::is_player_valid(player))
	{
		player thread zm_zod_util::function_55f114f9("zmInventory.widget_quest_items", 3.5);
		player thread zm_zod_util::show_infotext_for_duration("ZM_ZOD_UI_RITUAL_BUSY", 3.5);
	}
	wait(3.5);
	player.var_b999c630 = 0;
}

/*
	Name: update_usetrigger_hintstring
	Namespace: careadefend
	Checksum: 0x8F9FF512
	Offset: 0xD58
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function update_usetrigger_hintstring()
{
	if(isdefined(self.m_t_use))
	{
		self.m_t_use zm_unitrigger::run_visibility_function_for_all_triggers();
	}
}

/*
	Name: usetrigger_think
	Namespace: careadefend
	Checksum: 0x96CCCB54
	Offset: 0xD90
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function usetrigger_think()
{
	self endon(#"area_defend_completed");
	while(1)
	{
		self.m_t_use waittill(#"trigger", e_triggerer);
		if(e_triggerer zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_triggerer, 1, 1))
		{
			continue;
		}
		if(self.m_n_state != 1)
		{
			continue;
		}
		if(isdefined(self.m_func_prereq) && [[self.m_func_prereq]](self.var_20a1be38) == 0)
		{
			continue;
		}
		self.m_n_state = 2;
		self.m_triggerer = e_triggerer;
		update_usetrigger_hintstring();
		[[self.m_func_start]](self.var_20a1be38, self.m_triggerer);
		self thread progress_think();
		self thread monitor_defend_event_zombies();
		while(self.m_n_state != 1)
		{
			wait(1);
		}
	}
}

/*
	Name: progress_think
	Namespace: careadefend
	Checksum: 0x4EB6C0E1
	Offset: 0xEF8
	Size: 0x404
	Parameters: 0
	Flags: Linked
*/
function progress_think()
{
	/#
		println("");
	#/
	self.m_n_defend_current_progress = 0;
	self.m_n_defend_grace_remaining = self.m_n_defend_grace_duration;
	self.m_a_players_involved = [];
	var_db69778c = level.activeplayers.size;
	a_players_in_defend_area = get_players_in_defend_area();
	n_players_in_defend_area = a_players_in_defend_area.size;
	self.m_n_defend_duration = function_d9a5609b(var_db69778c, n_players_in_defend_area);
	while(self.m_n_defend_current_progress < 100 && self.m_n_defend_grace_remaining > 0)
	{
		a_players_in_defend_area = get_players_in_defend_area();
		n_players_in_defend_area = a_players_in_defend_area.size;
		foreach(var_448cf024, player in level.activeplayers)
		{
			if(!zm_utility::is_player_valid(player, 1, 1))
			{
				continue;
			}
			if(is_player_in_defend_area(player))
			{
				if(!isdefined(player.is_in_defend_area))
				{
					player thread zm_zod_util::set_rumble_to_player(5);
					array::add(self.m_a_players_involved, player, 0);
					player.is_in_defend_area = 1;
				}
				if(!player.is_in_defend_area)
				{
					player thread zm_zod_util::set_rumble_to_player(5);
					player.is_in_defend_area = 1;
					self reset_hud(player);
				}
				continue;
			}
			if(zm_utility::is_player_valid(player, 1, 1))
			{
				if(isdefined(player.is_in_defend_area) && player.is_in_defend_area)
				{
					player thread zm_zod_util::set_rumble_to_player(0);
					player.is_in_defend_area = 0;
					self reset_hud(player);
					player.defend_area_luimenu_status = player openluimenu(self.m_str_luimenu_return);
				}
			}
		}
		n_current_progress_rate = self.m_n_defend_progress_per_update_interval;
		self.m_n_defend_current_progress = self.m_n_defend_current_progress + n_current_progress_rate;
		if(n_players_in_defend_area > 0)
		{
			self.m_n_defend_current_progress = math::clamp(self.m_n_defend_current_progress, 0, 100);
			self.m_n_defend_grace_remaining = self.m_n_defend_grace_duration;
		}
		else
		{
			self.m_n_defend_grace_remaining = self.m_n_defend_grace_remaining - 0.1;
		}
		wait(0.1);
	}
	if(self.m_n_defend_current_progress == 100)
	{
		defend_succeeded();
	}
	else
	{
		defend_failed();
	}
}

/*
	Name: function_d9a5609b
	Namespace: careadefend
	Checksum: 0x2D8C6303
	Offset: 0x1308
	Size: 0x15E
	Parameters: 2
	Flags: Linked
*/
function function_d9a5609b(n_players_total, n_players_in_defend_area)
{
	if(n_players_total == 1)
	{
		return 20;
	}
	if(n_players_total == 2 && n_players_in_defend_area == 1)
	{
		return 30;
	}
	if(n_players_total == 2 && n_players_in_defend_area == 2)
	{
		return 20;
	}
	if(n_players_total == 3 && n_players_in_defend_area == 1)
	{
		return 40;
	}
	if(n_players_total == 3 && n_players_in_defend_area == 2)
	{
		return 30;
	}
	if(n_players_total == 3 && n_players_in_defend_area == 3)
	{
		return 20;
	}
	if(n_players_total == 4 && n_players_in_defend_area == 1)
	{
		return 60;
	}
	if(n_players_total == 4 && n_players_in_defend_area == 2)
	{
		return 40;
	}
	if(n_players_total == 4 && n_players_in_defend_area == 3)
	{
		return 30;
	}
	if(n_players_total == 4 && n_players_in_defend_area == 4)
	{
		return 20;
	}
	return 30;
}

/*
	Name: monitor_defend_event_zombies
	Namespace: careadefend
	Checksum: 0x500FF50D
	Offset: 0x1470
	Size: 0x1A2
	Parameters: 0
	Flags: Linked
*/
function monitor_defend_event_zombies()
{
	self.m_a_defend_event_zombies = [];
	while(self.m_n_state == 2)
	{
		self.m_a_defend_event_zombies = array::remove_dead(self.m_a_defend_event_zombies, 0);
		n_defend_event_zombie_limit = 4;
		if(level.round_number < 4)
		{
			n_defend_event_zombie_limit = 6;
		}
		else if(level.round_number < 6)
		{
			n_defend_event_zombie_limit = 5;
		}
		if(self.m_a_defend_event_zombies.size < n_defend_event_zombie_limit)
		{
			s_spawn_point = get_unused_spawn_point();
			ai = zombie_utility::spawn_zombie(self.m_a_e_zombie_spawners[0], "defend_event_zombie", s_spawn_point);
			if(!isdefined(ai))
			{
				/#
					println("");
				#/
				continue;
			}
			ai.var_81ac9e79 = 1;
			ai thread zm_zod_quest::function_2d0c5aa1(s_spawn_point);
			ai thread function_877a7365();
			array::add(self.m_a_defend_event_zombies, ai, 0);
		}
		wait(level.zombie_vars["zombie_spawn_delay"]);
	}
}

/*
	Name: function_df5ae14e
	Namespace: careadefend
	Checksum: 0xDC74743C
	Offset: 0x1620
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_df5ae14e(ai_zombie)
{
	ai_zombie waittill(#"death");
	ai_zombie clientfield::set("keeper_fx", 0);
}

/*
	Name: function_877a7365
	Namespace: careadefend
	Checksum: 0x726908E6
	Offset: 0x1668
	Size: 0x1E0
	Parameters: 0
	Flags: Linked
*/
function function_877a7365()
{
	self endon(#"death");
	while(1)
	{
		var_c7ca004c = [];
		foreach(var_7967c090, player in level.activeplayers)
		{
			if(zm_utility::is_player_valid(player) && (isdefined(player.is_in_defend_area) && player.is_in_defend_area))
			{
				if(!isdefined(var_c7ca004c))
				{
					var_c7ca004c = [];
				}
				else if(!isarray(var_c7ca004c))
				{
					var_c7ca004c = array(var_c7ca004c);
				}
				var_c7ca004c[var_c7ca004c.size] = player;
			}
		}
		while(isalive(e_target_player) && (!(isdefined(e_target_player.beastmode) && e_target_player.beastmode)) && !e_target_player laststand::player_is_in_laststand())
		{
			self setgoal(e_target_player);
			self waittill(#"goal");
		}
		wait(0.1);
	}
}

/*
	Name: get_unused_spawn_point
	Namespace: careadefend
	Checksum: 0xA8776FA2
	Offset: 0x1850
	Size: 0x148
	Parameters: 0
	Flags: Linked
*/
function get_unused_spawn_point()
{
	a_valid_spawn_points = [];
	while(!a_valid_spawn_points.size)
	{
		foreach(var_a7e794ae, s_spawn_point in self.m_e_spawn_points)
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
	}
	s_spawn_point = array::random(a_valid_spawn_points);
	s_spawn_point.spawned_zombie = 1;
	return s_spawn_point;
}

/*
	Name: defend_succeeded
	Namespace: careadefend
	Checksum: 0x421A8147
	Offset: 0x19A0
	Size: 0x216
	Parameters: 0
	Flags: Linked
*/
function defend_succeeded()
{
	/#
		println("");
	#/
	self.m_n_state = 3;
	kill_all_defend_event_zombies();
	foreach(var_9c9809d6, s_spawn_point in self.m_e_spawn_points)
	{
		s_spawn_point delete();
	}
	self.m_e_spawn_points = [];
	self thread ritual_nuke();
	zm_unitrigger::unregister_unitrigger(self.m_t_use);
	self.m_t_use = undefined;
	foreach(var_f52cf598, player in self.m_a_players_involved)
	{
		if(!isdefined(player))
		{
			continue;
		}
		player thread zm_zod_util::set_rumble_to_player(6);
		player.is_in_defend_area = undefined;
		self thread defend_succeeded_hud(player);
		player zm_score::add_to_player_score(500);
	}
	[[self.m_func_succeed]](self.var_20a1be38, self.m_a_players_involved);
	self notify(#"area_defend_completed");
}

/*
	Name: defend_failed
	Namespace: careadefend
	Checksum: 0x1A3A4BD8
	Offset: 0x1BC0
	Size: 0x148
	Parameters: 0
	Flags: Linked
*/
function defend_failed()
{
	/#
		println("");
	#/
	self.m_n_state = 1;
	update_usetrigger_hintstring();
	kill_all_defend_event_zombies();
	self.m_e_spawn_points = [];
	self thread populate_spawn_points();
	foreach(var_118bc267, player in self.m_a_players_involved)
	{
		if(!isdefined(player))
		{
			continue;
		}
		player thread zm_zod_util::set_rumble_to_player(0);
		player.is_in_defend_area = undefined;
		self thread defend_failed_hud(player);
	}
	[[self.m_func_fail]](self.var_20a1be38);
}

/*
	Name: kill_all_defend_event_zombies
	Namespace: careadefend
	Checksum: 0xB6C9E505
	Offset: 0x1D10
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function kill_all_defend_event_zombies()
{
	foreach(var_dfe3eff5, zombie in self.m_a_defend_event_zombies)
	{
		if(isalive(zombie) && (isdefined(zombie.allowdeath) && zombie.allowdeath))
		{
			zombie kill();
		}
	}
}

/*
	Name: get_progress_rate
	Namespace: careadefend
	Checksum: 0x50673FE9
	Offset: 0x1DE8
	Size: 0x3A
	Parameters: 2
	Flags: Linked
*/
function get_progress_rate(n_players_in_defend_area, n_players_total)
{
	n_current_update_rate = n_players_in_defend_area / n_players_total * self.m_n_defend_progress_per_update_interval;
	return n_current_update_rate;
}

/*
	Name: get_state
	Namespace: careadefend
	Checksum: 0x14CBC257
	Offset: 0x1E30
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_state()
{
	return self.m_n_state;
}

/*
	Name: get_players_in_defend_area
	Namespace: careadefend
	Checksum: 0x1A05B52F
	Offset: 0x1E48
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function get_players_in_defend_area()
{
	a_players_in_defend_area = [];
	foreach(var_9c1b1634, player in level.activeplayers)
	{
		if(zm_utility::is_player_valid(player) && is_player_in_defend_area(player))
		{
			array::add(a_players_in_defend_area, player);
		}
	}
	return a_players_in_defend_area;
}

/*
	Name: is_player_in_defend_area
	Namespace: careadefend
	Checksum: 0x6DED2910
	Offset: 0x1F28
	Size: 0x100
	Parameters: 1
	Flags: Linked
*/
function is_player_in_defend_area(player)
{
	if(isdefined(self.m_e_defend_volume))
	{
		if(zm_utility::is_player_valid(player, 1, 1) && player istouching(self.m_e_defend_volume))
		{
			return 1;
		}
		return 0;
	}
	if(zm_utility::is_player_valid(player, 1, 1) && distance2dsquared(player.origin, self.m_s_centerpoint.origin) < self.m_n_defend_radius_sq && player.origin[2] > self.m_s_centerpoint.origin[2] + -20)
	{
		return 1;
	}
	return 0;
}

/*
	Name: get_current_progress
	Namespace: careadefend
	Checksum: 0xC02B5ADB
	Offset: 0x2038
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function get_current_progress()
{
	return self.m_n_defend_current_progress / 100;
}

/*
	Name: defend_succeeded_hud
	Namespace: careadefend
	Checksum: 0x30A4562C
	Offset: 0x2050
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function defend_succeeded_hud(player)
{
	self reset_hud(player);
	if(isdefined(player) && isdefined(player.sessionstate) && player.sessionstate == "spectator")
	{
		return;
	}
	wait(3);
	self reset_hud(player);
}

/*
	Name: defend_failed_hud
	Namespace: careadefend
	Checksum: 0x6908AEEB
	Offset: 0x20D8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function defend_failed_hud(player)
{
	self reset_hud(player);
	if(isdefined(player) && player.sessionstate === "spectator")
	{
		return;
	}
	wait(3);
	self reset_hud(player);
}

/*
	Name: reset_hud
	Namespace: careadefend
	Checksum: 0x835059C9
	Offset: 0x2150
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function reset_hud(player)
{
	if(isdefined(player) && player.sessionstate === "spectator")
	{
		return;
	}
	if(isdefined(player) && isdefined(player.defend_area_luimenu_status))
	{
		progress_menu_status = player getluimenu(self.m_str_luimenu_progress);
		return_menu_status = player getluimenu(self.m_str_luimenu_return);
		if(isdefined(progress_menu_status) || isdefined(return_menu_status))
		{
			player closeluimenu(player.defend_area_luimenu_status);
			player.defend_area_luimenu_status = undefined;
		}
	}
}

/*
	Name: ritual_nuke
	Namespace: careadefend
	Checksum: 0x4378E3F1
	Offset: 0x2240
	Size: 0x37A
	Parameters: 0
	Flags: Linked
*/
function ritual_nuke()
{
	level lui::screen_flash(0.2, 0.5, 1, 0.8, "white");
	wait(0.2);
	a_ai_zombies = function_a5e2032d();
	var_6b1085eb = [];
	foreach(var_d2e02d2, ai_zombie in a_ai_zombies)
	{
		if(isdefined(ai_zombie.ignore_nuke) && ai_zombie.ignore_nuke)
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
	foreach(i, var_f92b3d80 in var_6b1085eb)
	{
		if(!isdefined(var_f92b3d80))
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(var_f92b3d80))
		{
			continue;
		}
		if(i < 5 && (!(isdefined(var_f92b3d80.isdog) && var_f92b3d80.isdog)))
		{
			var_f92b3d80 thread zombie_death::flame_death_fx();
		}
		if(!(isdefined(var_f92b3d80.isdog) && var_f92b3d80.isdog))
		{
			if(!(isdefined(var_f92b3d80.no_gib) && var_f92b3d80.no_gib))
			{
				var_f92b3d80 zombie_utility::zombie_head_gib();
			}
		}
		var_f92b3d80 dodamage(var_f92b3d80.health, var_f92b3d80.origin);
		if(!level flag::get("special_round"))
		{
			if(var_f92b3d80.archetype == "margwa")
			{
				level.var_e0191376++;
				continue;
			}
			level.zombie_total++;
		}
	}
}

/*
	Name: function_a5e2032d
	Namespace: careadefend
	Checksum: 0xAFC1AB88
	Offset: 0x25C8
	Size: 0x35C
	Parameters: 0
	Flags: Linked
*/
function function_a5e2032d()
{
	var_7591ca03 = zm_zonemgr::get_zone_from_position(self.m_s_centerpoint.origin);
	if(issubstr(var_7591ca03, "burlesque"))
	{
		var_b42fba6b = "burlesque";
	}
	else if(issubstr(var_7591ca03, "gym"))
	{
		var_b42fba6b = "gym";
	}
	else if(issubstr(var_7591ca03, "brothel"))
	{
		var_b42fba6b = "brothel";
	}
	else if(issubstr(var_7591ca03, "magician"))
	{
		var_b42fba6b = "magician";
	}
	else
	{
		var_b42fba6b = "pap";
	}
	var_b5a606c0 = [];
	foreach(var_8944cdad, str_zone_name in level.active_zone_names)
	{
		if(issubstr(str_zone_name, var_b42fba6b))
		{
			if(!isdefined(var_b5a606c0))
			{
				var_b5a606c0 = [];
			}
			else if(!isarray(var_b5a606c0))
			{
				var_b5a606c0 = array(var_b5a606c0);
			}
			var_b5a606c0[var_b5a606c0.size] = str_zone_name;
		}
	}
	a_ai_zombies = getaiteamarray(level.zombie_team);
	a_ai_zombies = arraysort(a_ai_zombies, self.m_s_centerpoint.origin);
	while(i < a_ai_zombies.size)
	{
		var_31a4faf3 = 0;
		foreach(var_be64e894, var_7da234a9 in var_b5a606c0)
		{
			if(a_ai_zombies[i] zm_zonemgr::entity_in_zone(var_7da234a9))
			{
				var_31a4faf3 = 1;
				i++;
				break;
			}
		}
		if(!var_31a4faf3)
		{
			arrayremovevalue(a_ai_zombies, a_ai_zombies[i]);
		}
	}
	return a_ai_zombies;
}

/*
	Name: __constructor
	Namespace: careadefend
	Checksum: 0x99EC1590
	Offset: 0x2930
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
}

/*
	Name: __destructor
	Namespace: careadefend
	Checksum: 0x99EC1590
	Offset: 0x2940
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __destructor()
{
}

#namespace zm_zod_defend_areas;

/*
	Name: careadefend
	Namespace: zm_zod_defend_areas
	Checksum: 0xC823682
	Offset: 0x2950
	Size: 0x6E6
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function careadefend()
{
	classes.careadefend[0] = spawnstruct();
	classes.careadefend[0].__vtable[1606033458] = &careadefend::__destructor;
	classes.careadefend[0].__vtable[-1690805083] = &careadefend::__constructor;
	classes.careadefend[0].__vtable[-1511914707] = &careadefend::function_a5e2032d;
	classes.careadefend[0].__vtable[-1923305968] = &careadefend::ritual_nuke;
	classes.careadefend[0].__vtable[433562392] = &careadefend::reset_hud;
	classes.careadefend[0].__vtable[-767271243] = &careadefend::defend_failed_hud;
	classes.careadefend[0].__vtable[1451499541] = &careadefend::defend_succeeded_hud;
	classes.careadefend[0].__vtable[74587917] = &careadefend::get_current_progress;
	classes.careadefend[0].__vtable[445954494] = &careadefend::is_player_in_defend_area;
	classes.careadefend[0].__vtable[-444119125] = &careadefend::get_players_in_defend_area;
	classes.careadefend[0].__vtable[1194857509] = &careadefend::get_state;
	classes.careadefend[0].__vtable[168524620] = &careadefend::get_progress_rate;
	classes.careadefend[0].__vtable[-911371447] = &careadefend::kill_all_defend_event_zombies;
	classes.careadefend[0].__vtable[392761027] = &careadefend::defend_failed;
	classes.careadefend[0].__vtable[1236590819] = &careadefend::defend_succeeded;
	classes.careadefend[0].__vtable[2124353455] = &careadefend::get_unused_spawn_point;
	classes.careadefend[0].__vtable[-2022018203] = &careadefend::function_877a7365;
	classes.careadefend[0].__vtable[-547692210] = &careadefend::function_df5ae14e;
	classes.careadefend[0].__vtable[-625606323] = &careadefend::monitor_defend_event_zombies;
	classes.careadefend[0].__vtable[-643473253] = &careadefend::function_d9a5609b;
	classes.careadefend[0].__vtable[1992713433] = &careadefend::progress_think;
	classes.careadefend[0].__vtable[-2044694817] = &careadefend::usetrigger_think;
	classes.careadefend[0].__vtable[-191567787] = &careadefend::update_usetrigger_hintstring;
	classes.careadefend[0].__vtable[1308841365] = &careadefend::function_4e035595;
	classes.careadefend[0].__vtable[-1127564701] = &careadefend::ritual_start_prompt_and_visibility;
	classes.careadefend[0].__vtable[-910062678] = &careadefend::ritual_start_visible_internal;
	classes.careadefend[0].__vtable[1493130507] = &careadefend::ritual_start_message_internal;
	classes.careadefend[0].__vtable[-1476488829] = &careadefend::set_availability;
	classes.careadefend[0].__vtable[55554463] = &careadefend::start;
	classes.careadefend[0].__vtable[657603382] = &careadefend::set_duration;
	classes.careadefend[0].__vtable[-1176656885] = &careadefend::set_volumes;
	classes.careadefend[0].__vtable[1535958020] = &careadefend::set_luimenus;
	classes.careadefend[0].__vtable[1287716801] = &careadefend::set_external_functions;
	classes.careadefend[0].__vtable[-338368872] = &careadefend::set_trigger_visibility_function;
	classes.careadefend[0].__vtable[2055383879] = &careadefend::populate_spawn_points;
	classes.careadefend[0].__vtable[-1017222485] = &careadefend::init;
}

