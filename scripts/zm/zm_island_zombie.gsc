// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_utility;

#namespace zm_island_zombie;

/*
	Name: init
	Namespace: zm_island_zombie
	Checksum: 0x5821BC50
	Offset: 0x488
	Size: 0xBC
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initzmislandbehaviorsandasm();
	setdvar("scr_zm_use_code_enemy_selection", 0);
	level.closest_player_override = &island_closest_player;
	level thread update_closest_player();
	level.pathdist_type = 2;
	zm_utility::register_custom_spawner_entry("quick_riser_location", &function_50565360);
	spawner::add_archetype_spawn_function("zombie", &function_1d7e9058);
}

/*
	Name: initzmislandbehaviorsandasm
	Namespace: zm_island_zombie
	Checksum: 0xF58059DD
	Offset: 0x550
	Size: 0x2C
	Parameters: 0
	Flags: Linked, Private
*/
function private initzmislandbehaviorsandasm()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("ZmIslandAttackableObjectService", &zmislandattackableobjectservice);
}

/*
	Name: function_1d7e9058
	Namespace: zm_island_zombie
	Checksum: 0xDFF6E1BA
	Offset: 0x588
	Size: 0x3C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_1d7e9058()
{
	self ai::set_behavior_attribute("use_attackable", 1);
	self.cant_move_cb = &island_cant_move_cb;
}

/*
	Name: island_cant_move_cb
	Namespace: zm_island_zombie
	Checksum: 0xF4408998
	Offset: 0x5D0
	Size: 0x1BC
	Parameters: 0
	Flags: Linked, Private
*/
function private island_cant_move_cb()
{
	if(isdefined(self.attackable))
	{
		if(isdefined(self.attackable.is_active) && self.attackable.is_active)
		{
			self pushactors(0);
			self.enablepushtime = gettime() + 1000;
			return;
		}
	}
	a_ai = getaiteamarray(level.zombie_team);
	var_125a7575 = self array::filter(a_ai, 0, &function_b3de8aa4, 32);
	foreach(ai in var_125a7575)
	{
		if(isdefined(ai.attackable) && (isdefined(ai.attackable.is_active) && ai.attackable.is_active) && (isdefined(ai.is_at_attackable) && ai.is_at_attackable))
		{
			self pushactors(0);
			self.enablepushtime = gettime() + 1000;
			return;
		}
	}
}

/*
	Name: function_b3de8aa4
	Namespace: zm_island_zombie
	Checksum: 0xD876C509
	Offset: 0x798
	Size: 0x60
	Parameters: 2
	Flags: Linked, Private
*/
function private function_b3de8aa4(ent, radius)
{
	radius_sq = radius * radius;
	return ent != self && distancesquared(self.origin, ent.origin) <= radius_sq;
}

/*
	Name: zmislandattackableobjectservice
	Namespace: zm_island_zombie
	Checksum: 0x16A49482
	Offset: 0x800
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private zmislandattackableobjectservice(entity)
{
	if(isdefined(entity.var_7d79a6) && entity.var_7d79a6)
	{
		entity.attackable = undefined;
		return false;
	}
	zm_behavior::zombieattackableobjectservice(entity);
}

/*
	Name: function_2d4f3007
	Namespace: zm_island_zombie
	Checksum: 0x8F0ED33C
	Offset: 0x868
	Size: 0x404
	Parameters: 1
	Flags: Linked
*/
function function_2d4f3007(player)
{
	var_6841e023 = "zone_spider_boss";
	var_930276ab = "zone_bunker_underwater_defend";
	var_1ac852d = "zone_ruins_underground";
	var_bae90b42 = "zone_flooded_bunker_tunnel";
	var_a2c1d9c5 = "zone_bunker_prison";
	var_101826e8 = "zone_bunker_prison_entrance";
	var_8ea2cdb6 = "zone_bunker_interior_elevator";
	str_player_zone = "";
	var_334f2464 = "";
	if(isdefined(player.var_90f735f8) && player.var_90f735f8)
	{
		return false;
	}
	if(isdefined(self.var_6eb9188d) && self.var_6eb9188d)
	{
		return true;
	}
	if(isdefined(self.zone_name))
	{
		switch(self.zone_name)
		{
			case "zone_spider_boss":
			{
				if(!level flag::get("spider_queen_dead"))
				{
					var_334f2464 = var_6841e023;
				}
				break;
			}
			case "zone_bunker_underwater_defend":
			{
				if(level flag::get("penstock_debris_cleared") && !level flag::get("defend_over"))
				{
					var_334f2464 = var_930276ab;
				}
				break;
			}
			case "zone_flooded_bunker_tunnel":
			{
				var_334f2464 = var_bae90b42;
				break;
			}
			case "zone_bunker_prison":
			case "zone_bunker_prison_entrance":
			{
				var_334f2464 = var_a2c1d9c5;
				break;
			}
			case "zone_bunker_interior_elevator":
			{
				if(level flag::get("elevator_door_closed"))
				{
					var_334f2464 = var_8ea2cdb6;
				}
				break;
			}
			case "zone_ruins_underground":
			{
				if(isdefined(level.var_a5db31a9) && level.var_a5db31a9 || (isdefined(self.var_2f846873) && self.var_2f846873))
				{
					var_334f2464 = var_1ac852d;
				}
				break;
			}
		}
	}
	if(isdefined(player.zone_name))
	{
		switch(player.zone_name)
		{
			case "zone_spider_boss":
			{
				if(!level flag::get("spider_queen_dead"))
				{
					str_player_zone = var_6841e023;
				}
				break;
			}
			case "zone_bunker_underwater_defend":
			{
				if(level flag::get("penstock_debris_cleared") && !level flag::get("defend_over"))
				{
					str_player_zone = var_930276ab;
				}
				break;
			}
			case "zone_flooded_bunker_tunnel":
			{
				str_player_zone = var_bae90b42;
				break;
			}
			case "zone_bunker_prison_entrance":
			{
				if(!level flag::get("prison_vines_cleared"))
				{
					str_player_zone = var_101826e8;
				}
				else
				{
					str_player_zone = var_a2c1d9c5;
				}
				break;
			}
			case "zone_bunker_prison":
			{
				str_player_zone = var_a2c1d9c5;
				break;
			}
			case "zone_bunker_interior_elevator":
			{
				if(level flag::get("elevator_door_closed"))
				{
					str_player_zone = var_8ea2cdb6;
				}
				break;
			}
			case "zone_ruins_underground":
			{
				if(isdefined(level.var_a5db31a9) && level.var_a5db31a9)
				{
					str_player_zone = var_1ac852d;
				}
				break;
			}
		}
	}
	if(str_player_zone != var_334f2464)
	{
		return false;
	}
	return true;
}

/*
	Name: function_f8e95ea2
	Namespace: zm_island_zombie
	Checksum: 0x9AD3EC5C
	Offset: 0xC78
	Size: 0xEE
	Parameters: 1
	Flags: Linked, Private
*/
function private function_f8e95ea2(players)
{
	if(isdefined(self.last_closest_player) && (isdefined(self.last_closest_player.am_i_valid) && self.last_closest_player.am_i_valid))
	{
		return;
	}
	self.need_closest_player = 1;
	foreach(player in players)
	{
		if(self function_2d4f3007(player))
		{
			self.last_closest_player = player;
			return;
		}
	}
	self.last_closest_player = undefined;
}

/*
	Name: island_closest_player
	Namespace: zm_island_zombie
	Checksum: 0xB7C70C19
	Offset: 0xD70
	Size: 0x312
	Parameters: 2
	Flags: Linked, Private
*/
function private island_closest_player(origin, players)
{
	if(self.ignoreall === 1)
	{
		return undefined;
	}
	if(players.size == 0)
	{
		return undefined;
	}
	if(isdefined(self.zombie_poi))
	{
		return undefined;
	}
	if(players.size == 1)
	{
		if(self function_2d4f3007(players[0]))
		{
			self.last_closest_player = players[0];
			return self.last_closest_player;
		}
		return undefined;
	}
	if(!isdefined(self.last_closest_player))
	{
		self.last_closest_player = players[0];
	}
	if(isdefined(self.v_zombie_custom_goal_pos) || isdefined(self.attackable_slot))
	{
		return self.last_closest_player;
	}
	if(!isdefined(self.need_closest_player))
	{
		self.need_closest_player = 1;
	}
	if(isdefined(level.last_closest_time) && level.last_closest_time >= level.time)
	{
		self function_f8e95ea2(players);
		return self.last_closest_player;
	}
	if(isdefined(self.need_closest_player) && self.need_closest_player)
	{
		level.last_closest_time = level.time;
		self.need_closest_player = 0;
		closest = players[0];
		closest_dist = undefined;
		if(self function_2d4f3007(players[0]))
		{
			closest_dist = self zm_utility::approximate_path_dist(closest);
		}
		if(!isdefined(closest_dist))
		{
			closest = undefined;
		}
		for(index = 1; index < players.size; index++)
		{
			dist = undefined;
			if(self function_2d4f3007(players[index]))
			{
				dist = self zm_utility::approximate_path_dist(players[index]);
			}
			if(isdefined(dist))
			{
				if(isdefined(closest_dist))
				{
					if(dist < closest_dist)
					{
						closest = players[index];
						closest_dist = dist;
					}
					continue;
				}
				closest = players[index];
				closest_dist = dist;
			}
		}
		self.last_closest_player = closest;
	}
	if(players.size > 1 && isdefined(closest))
	{
		self zm_utility::approximate_path_dist(closest);
	}
	self function_f8e95ea2(players);
	return self.last_closest_player;
}

/*
	Name: update_closest_player
	Namespace: zm_island_zombie
	Checksum: 0x596C4655
	Offset: 0x1090
	Size: 0x18C
	Parameters: 0
	Flags: Linked, Private
*/
function private update_closest_player()
{
	level waittill(#"start_of_round");
	while(true)
	{
		reset_closest_player = 1;
		zombies = zombie_utility::get_round_enemy_array();
		foreach(zombie in zombies)
		{
			if(isdefined(zombie.need_closest_player) && zombie.need_closest_player)
			{
				reset_closest_player = 0;
				break;
			}
		}
		if(reset_closest_player)
		{
			foreach(zombie in zombies)
			{
				if(isdefined(zombie.need_closest_player))
				{
					zombie.need_closest_player = 1;
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_50565360
	Namespace: zm_island_zombie
	Checksum: 0xAA9DBBE6
	Offset: 0x1228
	Size: 0x1D4
	Parameters: 1
	Flags: Linked
*/
function function_50565360(s_spot)
{
	self endon(#"death");
	self.in_the_ground = 1;
	mdl_anchor = util::spawn_model("tag_origin", self.origin, self.angles);
	self linkto(mdl_anchor);
	self thread function_cd5d6101();
	mdl_anchor moveto(s_spot.origin, 0.05);
	mdl_anchor waittill(#"movedone");
	var_ac82e424 = zombie_utility::get_desired_origin();
	if(isdefined(var_ac82e424))
	{
		var_585cefca = vectortoangles(var_ac82e424 - self.origin);
		mdl_anchor rotateto((0, var_585cefca[1], 0), 0.05);
		mdl_anchor waittill(#"rotatedone");
	}
	self unlink();
	mdl_anchor thread scene::play("scene_zm_dlc2_zombie_quick_rise_v2", self);
	self notify(#"risen", s_spot.script_string);
	self.in_the_ground = 0;
	mdl_anchor waittill(#"scene_done");
	if(isdefined(mdl_anchor))
	{
		mdl_anchor delete();
	}
}

/*
	Name: function_cd5d6101
	Namespace: zm_island_zombie
	Checksum: 0x7D97FEE3
	Offset: 0x1408
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function function_cd5d6101()
{
	self endon(#"death");
	self ghost();
	wait(0.4);
	if(isdefined(self))
	{
		self show();
		util::wait_network_frame();
		if(isdefined(self))
		{
			self.create_eyes = 1;
		}
	}
}

