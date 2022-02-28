// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_behavior_utility;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_puppet;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_spawner;

/*
	Name: init
	Namespace: zm_spawner
	Checksum: 0x68AF279
	Offset: 0x10B0
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level._contextual_grab_lerp_time = 0.3;
	level.zombie_spawners = getentarray("zombie_spawner", "script_noteworthy");
	level.a_zombie_respawn_health = [];
	level.a_zombie_respawn_type = [];
	if(isdefined(level.use_multiple_spawns) && level.use_multiple_spawns)
	{
		level.zombie_spawn = [];
		for(i = 0; i < level.zombie_spawners.size; i++)
		{
			if(isdefined(level.zombie_spawners[i].script_int))
			{
				int = level.zombie_spawners[i].script_int;
				if(!isdefined(level.zombie_spawn[int]))
				{
					level.zombie_spawn[int] = [];
				}
				level.zombie_spawn[int][level.zombie_spawn[int].size] = level.zombie_spawners[i];
			}
		}
	}
	if(isdefined(level.ignore_spawner_func))
	{
		for(i = 0; i < level.zombie_spawners.size; i++)
		{
			ignore = [[level.ignore_spawner_func]](level.zombie_spawners[i]);
			if(ignore)
			{
				arrayremovevalue(level.zombie_spawners, level.zombie_spawners[i]);
			}
		}
	}
	if(!isdefined(level.attack_player_thru_boards_range))
	{
		level.attack_player_thru_boards_range = 109.8;
	}
	if(isdefined(level._game_module_custom_spawn_init_func))
	{
		[[level._game_module_custom_spawn_init_func]]();
	}
	/#
		level thread debug_show_exterior_goals();
	#/
}

/*
	Name: debug_show_exterior_goals
	Namespace: zm_spawner
	Checksum: 0x7F91A350
	Offset: 0x12C8
	Size: 0x468
	Parameters: 0
	Flags: Linked
*/
function debug_show_exterior_goals()
{
	/#
		while(true)
		{
			if(isdefined(level.toggle_show_exterior_goals) && level.toggle_show_exterior_goals)
			{
				color = (1, 1, 1);
				color_red = (1, 0, 0);
				color_blue = (0, 0, 1);
				foreach(zone in level.zones)
				{
					foreach(location in zone.a_loc_types[""])
					{
						recordstar(location.origin, color);
					}
				}
				foreach(zone in level.zones)
				{
					foreach(location in zone.a_loc_types[""])
					{
						foreach(goal in level.exterior_goals)
						{
							if(goal.script_string == location.script_string)
							{
								recordline(location.origin, goal.origin, color);
								goal.has_spawner = 1;
								break;
							}
						}
					}
				}
				foreach(goal in level.exterior_goals)
				{
					if(isdefined(goal.has_spawner) && goal.has_spawner)
					{
						recordcircle(goal.origin, 16, color);
						continue;
					}
					if(isdefined(goal.script_string) && goal.script_string == "")
					{
						recordcircle(goal.origin, 16, color_blue);
						continue;
					}
					recordcircle(goal.origin, 16, color_red);
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: player_attacks_enemy
	Namespace: zm_spawner
	Checksum: 0x60FCC9DC
	Offset: 0x1738
	Size: 0x1D4
	Parameters: 12
	Flags: Linked
*/
function player_attacks_enemy(player, amount, type, point, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel)
{
	team = undefined;
	if(isdefined(self._race_team))
	{
		team = self._race_team;
	}
	if(isdefined(player.allow_zombie_to_target_ai) && player.allow_zombie_to_target_ai || !player util::is_ads())
	{
		[[level.global_damage_func]](type, self.damagelocation, point, player, amount, team, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel);
		return false;
	}
	if(!zm_utility::bullet_attack(type))
	{
		[[level.global_damage_func]](type, self.damagelocation, point, player, amount, team, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel);
		return false;
	}
	[[level.global_damage_func_ads]](type, self.damagelocation, point, player, amount, team, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel);
	return true;
}

/*
	Name: player_attacker
	Namespace: zm_spawner
	Checksum: 0x4FC4F28D
	Offset: 0x1918
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function player_attacker(attacker)
{
	if(isplayer(attacker))
	{
		return true;
	}
	return false;
}

/*
	Name: enemy_death_detection
	Namespace: zm_spawner
	Checksum: 0xEBA0A10C
	Offset: 0x1950
	Size: 0x168
	Parameters: 0
	Flags: Linked
*/
function enemy_death_detection()
{
	self endon(#"death");
	for(;;)
	{
		self waittill(#"damage", amount, attacker, direction_vec, point, type, tagname, modelname, partname, weapon, dflags, inflictor, chargelevel);
		if(!isdefined(amount))
		{
			continue;
		}
		if(!isalive(self))
		{
			return;
		}
		if(!player_attacker(attacker) && (!(isdefined(attacker.allow_zombie_to_target_ai) && attacker.allow_zombie_to_target_ai)))
		{
			continue;
		}
		self.has_been_damaged_by_player = 1;
		self player_attacks_enemy(attacker, amount, type, point, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel);
	}
}

/*
	Name: is_spawner_targeted_by_blocker
	Namespace: zm_spawner
	Checksum: 0xF1E01209
	Offset: 0x1AC0
	Size: 0xFA
	Parameters: 1
	Flags: Linked
*/
function is_spawner_targeted_by_blocker(ent)
{
	if(isdefined(ent.targetname))
	{
		targeters = getentarray(ent.targetname, "target");
		for(i = 0; i < targeters.size; i++)
		{
			if(targeters[i].targetname == "zombie_door" || targeters[i].targetname == "zombie_debris")
			{
				return true;
			}
			result = is_spawner_targeted_by_blocker(targeters[i]);
			if(result)
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: add_custom_zombie_spawn_logic
	Namespace: zm_spawner
	Checksum: 0x238C77E2
	Offset: 0x1BC8
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function add_custom_zombie_spawn_logic(func)
{
	if(!isdefined(level._zombie_custom_spawn_logic))
	{
		level._zombie_custom_spawn_logic = [];
	}
	level._zombie_custom_spawn_logic[level._zombie_custom_spawn_logic.size] = func;
}

/*
	Name: zombie_spawn_init
	Namespace: zm_spawner
	Checksum: 0xFFA44670
	Offset: 0x1C10
	Size: 0x6CE
	Parameters: 1
	Flags: Linked
*/
function zombie_spawn_init(animname_set = 0)
{
	self.targetname = "zombie";
	self.script_noteworthy = undefined;
	zm_utility::recalc_zombie_array();
	if(!animname_set)
	{
		self.animname = "zombie";
	}
	if(isdefined(zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")))
	{
		self [[zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")]]();
	}
	self thread play_ambient_zombie_vocals();
	self thread zm_audio::zmbaivox_notifyconvert();
	self.zmb_vocals_attack = "zmb_vocals_zombie_attack";
	self.ignoreme = 0;
	self.allowdeath = 1;
	self.force_gib = 1;
	self.is_zombie = 1;
	self allowedstances("stand");
	self.attackercountthreatscale = 0;
	self.currentenemythreatscale = 0;
	self.recentattackerthreatscale = 0;
	self.coverthreatscale = 0;
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.zombie_damaged_by_bar_knockdown = 0;
	self.gibbed = 0;
	self.head_gibbed = 0;
	self setphysparams(15, 0, 72);
	self.goalradius = 32;
	self.disablearrivals = 1;
	self.disableexits = 1;
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoresuppression = 1;
	self.suppressionthreshold = 1;
	self.nododgemove = 1;
	self.dontshootwhilemoving = 1;
	self.pathenemylookahead = 0;
	self.holdfire = 1;
	self.badplaceawareness = 0;
	self.chatinitialized = 0;
	self.missinglegs = 0;
	if(!isdefined(self.zombie_arms_position))
	{
		if(randomint(2) == 0)
		{
			self.zombie_arms_position = "up";
		}
		else
		{
			self.zombie_arms_position = "down";
		}
	}
	if(randomint(100) < 25)
	{
		self.canstumble = 1;
	}
	self.a.disablepain = 1;
	self zm_utility::disable_react();
	if(isdefined(level.zombie_health))
	{
		self.maxhealth = level.zombie_health;
		if(isdefined(level.a_zombie_respawn_health[self.archetype]) && level.a_zombie_respawn_health[self.archetype].size > 0)
		{
			self.health = level.a_zombie_respawn_health[self.archetype][0];
			arrayremovevalue(level.a_zombie_respawn_health[self.archetype], level.a_zombie_respawn_health[self.archetype][0]);
		}
		else
		{
			self.health = level.zombie_health;
		}
	}
	else
	{
		self.maxhealth = level.zombie_vars["zombie_health_start"];
		self.health = self.maxhealth;
	}
	self.freezegun_damage = 0;
	self setavoidancemask("avoid none");
	self pathmode("dont move");
	level thread zombie_death_event(self);
	self zm_utility::init_zombie_run_cycle();
	self thread zombie_think();
	self thread zombie_utility::zombie_gib_on_damage();
	self thread zombie_damage_failsafe();
	self thread enemy_death_detection();
	if(isdefined(level._zombie_custom_spawn_logic))
	{
		if(isarray(level._zombie_custom_spawn_logic))
		{
			for(i = 0; i < level._zombie_custom_spawn_logic.size; i++)
			{
				self thread [[level._zombie_custom_spawn_logic[i]]]();
			}
		}
		else
		{
			self thread [[level._zombie_custom_spawn_logic]]();
		}
	}
	if(!isdefined(self.no_eye_glow) || !self.no_eye_glow)
	{
		if(!(isdefined(self.is_inert) && self.is_inert))
		{
			self thread zombie_utility::delayed_zombie_eye_glow();
		}
	}
	self.deathfunction = &zombie_death_animscript;
	self.flame_damage_time = 0;
	self.meleedamage = 60;
	self.no_powerups = 1;
	self zombie_history(("zombie_spawn_init -> Spawned = ") + self.origin);
	self.thundergun_knockdown_func = level.basic_zombie_thundergun_knockdown;
	self.tesla_head_gib_func = &zombie_tesla_head_gib;
	self.team = level.zombie_team;
	self.updatesight = 0;
	self.heroweapon_kill_power = 2;
	self.sword_kill_power = 2;
	if(isdefined(level.achievement_monitor_func))
	{
		self [[level.achievement_monitor_func]]();
	}
	if(isdefined(zm_utility::get_gamemode_var("post_init_zombie_spawn_func")))
	{
		self [[zm_utility::get_gamemode_var("post_init_zombie_spawn_func")]]();
	}
	if(isdefined(level.zombie_init_done))
	{
		self [[level.zombie_init_done]]();
	}
	self.zombie_init_done = 1;
	self notify(#"zombie_init_done");
}

/*
	Name: zombie_damage_failsafe
	Namespace: zm_spawner
	Checksum: 0x4972C634
	Offset: 0x22E8
	Size: 0x1DE
	Parameters: 0
	Flags: Linked
*/
function zombie_damage_failsafe()
{
	self endon(#"death");
	continue_failsafe_damage = 0;
	while(true)
	{
		wait(0.5);
		if(!isdefined(self.enemy) || !isplayer(self.enemy))
		{
			continue;
		}
		if(self istouching(self.enemy))
		{
			old_org = self.origin;
			if(!continue_failsafe_damage)
			{
				wait(5);
			}
			if(!isdefined(self.enemy) || !isplayer(self.enemy) || self.enemy hasperk("specialty_armorvest"))
			{
				continue;
			}
			if(self istouching(self.enemy) && !self.enemy laststand::player_is_in_laststand() && isalive(self.enemy))
			{
				if(distancesquared(old_org, self.origin) < 3600)
				{
					self.enemy dodamage(self.enemy.health + 1000, self.enemy.origin, self, self, "none", "MOD_RIFLE_BULLET");
					continue_failsafe_damage = 1;
				}
			}
		}
		else
		{
			continue_failsafe_damage = 0;
		}
	}
}

/*
	Name: should_skip_teardown
	Namespace: zm_spawner
	Checksum: 0xF413AA98
	Offset: 0x24D0
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function should_skip_teardown(find_flesh_struct_string)
{
	if(isdefined(find_flesh_struct_string) && find_flesh_struct_string == "find_flesh")
	{
		return true;
	}
	if(isdefined(self.script_string) && self.script_string == "find_flesh")
	{
		return true;
	}
	return false;
}

/*
	Name: zombie_findnodes
	Namespace: zm_spawner
	Checksum: 0x78776B08
	Offset: 0x2530
	Size: 0x3B0
	Parameters: 0
	Flags: None
*/
function zombie_findnodes()
{
	node = undefined;
	desired_nodes = [];
	self.entrance_nodes = [];
	if(isdefined(level.max_barrier_search_dist_override))
	{
		max_dist = level.max_barrier_search_dist_override;
	}
	else
	{
		max_dist = 500;
	}
	if(!isdefined(self.find_flesh_struct_string) && isdefined(self.target) && self.target != "")
	{
		desired_origin = zombie_utility::get_desired_origin();
		/#
			assert(isdefined(desired_origin), ("" + self.origin) + "");
		#/
		origin = desired_origin;
		node = arraygetclosest(origin, level.exterior_goals);
		self.entrance_nodes[self.entrance_nodes.size] = node;
		self zombie_history(("zombie_think -> #1 entrance (script_forcegoal) origin = ") + self.entrance_nodes[0].origin);
	}
	else
	{
		if(self should_skip_teardown(self.find_flesh_struct_string))
		{
			self zombie_setup_attack_properties();
			if(isdefined(self.target))
			{
				end_at_node = getnode(self.target, "targetname");
				if(isdefined(end_at_node))
				{
					self setgoalnode(end_at_node);
					self waittill(#"goal");
				}
			}
			if(isdefined(self.start_inert) && self.start_inert)
			{
				self zombie_complete_emerging_into_playable_area();
			}
			else
			{
				self thread zombie_entered_playable();
			}
			return;
		}
		if(isdefined(self.find_flesh_struct_string))
		{
			/#
				/#
					assert(isdefined(self.find_flesh_struct_string));
				#/
			#/
			for(i = 0; i < level.exterior_goals.size; i++)
			{
				if(isdefined(level.exterior_goals[i].script_string) && level.exterior_goals[i].script_string == self.find_flesh_struct_string)
				{
					node = level.exterior_goals[i];
					break;
				}
			}
			self.entrance_nodes[self.entrance_nodes.size] = node;
			self zombie_history(("zombie_think -> #1 entrance origin = ") + node.origin);
			self thread zombie_assure_node();
		}
	}
	/#
		assert(isdefined(node), "");
	#/
	level thread zm_utility::draw_line_ent_to_pos(self, node.origin, "goal");
	self.first_node = node;
}

/*
	Name: zombie_think
	Namespace: zm_spawner
	Checksum: 0xF66F38BF
	Offset: 0x28E8
	Size: 0x180
	Parameters: 0
	Flags: Linked
*/
function zombie_think()
{
	self endon(#"death");
	/#
		assert(!self.isdog);
	#/
	self.ai_state = "zombie_think";
	find_flesh_struct_string = undefined;
	if(isdefined(level.zombie_custom_think_logic))
	{
		shouldwait = self [[level.zombie_custom_think_logic]]();
		if(shouldwait)
		{
			self waittill(#"zombie_custom_think_done", find_flesh_struct_string);
		}
	}
	else
	{
		if(isdefined(self.start_inert) && self.start_inert)
		{
			find_flesh_struct_string = "find_flesh";
		}
		else
		{
			if(isdefined(self.custom_location))
			{
				self thread [[self.custom_location]]();
			}
			else
			{
				self thread do_zombie_spawn();
			}
			self waittill(#"risen", find_flesh_struct_string);
		}
	}
	self.find_flesh_struct_string = find_flesh_struct_string;
	/#
		self.backupnode = self.first_node;
		self thread zm_puppet::wait_for_puppet_pickup();
	#/
	self setgoal(self.origin);
	self pathmode("move allowed");
	self.zombie_think_done = 1;
}

/*
	Name: zombie_entered_playable
	Namespace: zm_spawner
	Checksum: 0xADDC3BD1
	Offset: 0x2A70
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function zombie_entered_playable()
{
	self endon(#"death");
	if(!isdefined(level.playable_areas))
	{
		level.playable_areas = getentarray("player_volume", "script_noteworthy");
	}
	while(true)
	{
		foreach(area in level.playable_areas)
		{
			if(self istouching(area))
			{
				self zombie_complete_emerging_into_playable_area();
				return;
			}
		}
		wait(1);
	}
}

/*
	Name: zombie_goto_entrance
	Namespace: zm_spawner
	Checksum: 0xF23E83CC
	Offset: 0x2B70
	Size: 0x278
	Parameters: 2
	Flags: Linked
*/
function zombie_goto_entrance(node, endon_bad_path)
{
	/#
		assert(!self.isdog);
	#/
	self endon(#"death");
	self endon(#"stop_zombie_goto_entrance");
	level endon(#"intermission");
	self.ai_state = "zombie_goto_entrance";
	if(isdefined(endon_bad_path) && endon_bad_path)
	{
		self endon(#"bad_path");
	}
	self zombie_history(("zombie_goto_entrance -> start goto entrance ") + node.origin);
	self.got_to_entrance = 0;
	self.goalradius = 128;
	self setgoal(node.origin);
	self waittill(#"goal");
	self.got_to_entrance = 1;
	self zombie_history(("zombie_goto_entrance -> reached goto entrance ") + node.origin);
	self tear_into_building();
	if(isdefined(level.pre_aggro_pathfinding_func))
	{
		self [[level.pre_aggro_pathfinding_func]]();
	}
	barrier_pos = [];
	barrier_pos[0] = "m";
	barrier_pos[1] = "r";
	barrier_pos[2] = "l";
	self.barricade_enter = 1;
	animstate = zombie_utility::append_missing_legs_suffix("zm_barricade_enter");
	self animscripted("barricade_enter_anim", self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, "ai_zombie_barricade_enter_m_v1");
	zombie_shared::donotetracks("barricade_enter_anim");
	self zombie_setup_attack_properties();
	self zombie_complete_emerging_into_playable_area();
	self.barricade_enter = 0;
}

/*
	Name: zombie_assure_node
	Namespace: zm_spawner
	Checksum: 0x48494AA9
	Offset: 0x2DF0
	Size: 0x3A4
	Parameters: 0
	Flags: Linked
*/
function zombie_assure_node()
{
	self endon(#"death");
	self endon(#"goal");
	level endon(#"intermission");
	start_pos = self.origin;
	if(isdefined(self.entrance_nodes))
	{
		for(i = 0; i < self.entrance_nodes.size; i++)
		{
			if(self zombie_bad_path())
			{
				self zombie_history(("zombie_assure_node -> assigned assured node = ") + self.entrance_nodes[i].origin);
				/#
					println((("" + self.origin) + "") + self.entrance_nodes[i].origin);
				#/
				level thread zm_utility::draw_line_ent_to_pos(self, self.entrance_nodes[i].origin, "goal");
				self.first_node = self.entrance_nodes[i];
				self setgoal(self.entrance_nodes[i].origin);
				continue;
			}
			return;
		}
	}
	wait(2);
	nodes = array::get_all_closest(self.origin, level.exterior_goals, undefined, 20);
	if(isdefined(nodes))
	{
		self.entrance_nodes = nodes;
		for(i = 0; i < self.entrance_nodes.size; i++)
		{
			if(self zombie_bad_path())
			{
				self zombie_history(("zombie_assure_node -> assigned assured node = ") + self.entrance_nodes[i].origin);
				/#
					println((("" + self.origin) + "") + self.entrance_nodes[i].origin);
				#/
				level thread zm_utility::draw_line_ent_to_pos(self, self.entrance_nodes[i].origin, "goal");
				self.first_node = self.entrance_nodes[i];
				self setgoal(self.entrance_nodes[i].origin);
				continue;
			}
			return;
		}
	}
	self zombie_history("zombie_assure_node -> failed to find a good entrance point");
	wait(20);
	self dodamage(self.health + 10, self.origin);
	if(isdefined(level.put_timed_out_zombies_back_in_queue) && level.put_timed_out_zombies_back_in_queue && (!(isdefined(self.has_been_damaged_by_player) && self.has_been_damaged_by_player)))
	{
		level.zombie_total++;
		level.zombie_total_subtract++;
	}
	level.zombies_timeout_spawn++;
}

/*
	Name: zombie_bad_path
	Namespace: zm_spawner
	Checksum: 0x9828A6EA
	Offset: 0x31A0
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function zombie_bad_path()
{
	self endon(#"death");
	self endon(#"goal");
	self thread zombie_bad_path_notify();
	self thread zombie_bad_path_timeout();
	self.zombie_bad_path = undefined;
	while(!isdefined(self.zombie_bad_path))
	{
		wait(0.05);
	}
	self notify(#"stop_zombie_bad_path");
	return self.zombie_bad_path;
}

/*
	Name: zombie_bad_path_notify
	Namespace: zm_spawner
	Checksum: 0x4FFD58BB
	Offset: 0x3228
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function zombie_bad_path_notify()
{
	self endon(#"death");
	self endon(#"stop_zombie_bad_path");
	self waittill(#"bad_path");
	self.zombie_bad_path = 1;
}

/*
	Name: zombie_bad_path_timeout
	Namespace: zm_spawner
	Checksum: 0x9C9D9A33
	Offset: 0x3268
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function zombie_bad_path_timeout()
{
	self endon(#"death");
	self endon(#"stop_zombie_bad_path");
	wait(2);
	self.zombie_bad_path = 0;
}

/*
	Name: tear_into_building
	Namespace: zm_spawner
	Checksum: 0x95122476
	Offset: 0x32A0
	Size: 0x790
	Parameters: 0
	Flags: Linked
*/
function tear_into_building()
{
	self endon(#"death");
	self endon(#"teleporting");
	self zombie_history("tear_into_building -> start");
	while(true)
	{
		if(isdefined(self.first_node.script_noteworthy))
		{
			if(self.first_node.script_noteworthy == "no_blocker")
			{
				return;
			}
		}
		if(!isdefined(self.first_node.target))
		{
			return;
		}
		if(zm_utility::all_chunks_destroyed(self.first_node, self.first_node.barrier_chunks))
		{
			self zombie_history("tear_into_building -> all chunks destroyed");
		}
		if(!get_attack_spot(self.first_node))
		{
			self zombie_history("tear_into_building -> Could not find an attack spot");
			self thread do_a_taunt();
			wait(0.5);
			continue;
		}
		self.goalradius = 2;
		self.at_entrance_tear_spot = 0;
		if(isdefined(level.tear_into_position))
		{
			self [[level.tear_into_position]]();
		}
		else
		{
			angles = self.first_node.zbarrier.angles;
			self setgoal(self.attacking_spot);
		}
		self waittill(#"goal");
		self.at_entrance_tear_spot = 1;
		if(isdefined(level.tear_into_wait))
		{
			self [[level.tear_into_wait]]();
		}
		else
		{
			self util::waittill_any_ex(1, "orientdone", "death", "teleporting");
		}
		self zombie_history("tear_into_building -> Reach position and orientated");
		if(zm_utility::all_chunks_destroyed(self.first_node, self.first_node.barrier_chunks))
		{
			self zombie_history("tear_into_building -> all chunks destroyed");
			for(i = 0; i < self.first_node.attack_spots_taken.size; i++)
			{
				self.first_node.attack_spots_taken[i] = 0;
			}
			return;
		}
		while(true)
		{
			if(isdefined(self.zombie_board_tear_down_callback))
			{
				self [[self.zombie_board_tear_down_callback]]();
			}
			self.chunk = zm_utility::get_closest_non_destroyed_chunk(self.origin, self.first_node, self.first_node.barrier_chunks);
			if(!isdefined(self.chunk))
			{
				if(!zm_utility::all_chunks_destroyed(self.first_node, self.first_node.barrier_chunks))
				{
					attack = self should_attack_player_thru_boards();
					if(isdefined(attack) && !attack && !self.missinglegs)
					{
						self do_a_taunt();
					}
					else
					{
						wait(0.1);
					}
					continue;
				}
				for(i = 0; i < self.first_node.attack_spots_taken.size; i++)
				{
					self.first_node.attack_spots_taken[i] = 0;
				}
				return;
			}
			self zombie_history("tear_into_building -> animating");
			self.first_node.zbarrier setzbarrierpiecestate(self.chunk, "targetted_by_zombie");
			self.first_node thread check_zbarrier_piece_for_zombie_inert(self.chunk, self.first_node.zbarrier, self);
			self.first_node thread check_zbarrier_piece_for_zombie_death(self.chunk, self.first_node.zbarrier, self);
			self notify(#"bhtn_action_notify", "teardown");
			self animscripted("tear_anim", self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, "ai_zombie_boardtear_aligned_m_1_grab");
			self zombie_tear_notetracks("tear_anim", self.chunk, self.first_node);
			while(0 < self.first_node.zbarrier.chunk_health[self.chunk])
			{
				self animscripted("tear_anim", self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, "ai_zombie_boardtear_aligned_m_1_hold");
				self zombie_tear_notetracks("tear_anim", self.chunk, self.first_node);
				self.first_node.zbarrier.chunk_health[self.chunk]--;
			}
			self animscripted("tear_anim", self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, "ai_zombie_boardtear_aligned_m_1_pull");
			self waittill(#"hash_cc2ddc9");
			self.lastchunk_destroy_time = gettime();
			attack = self should_attack_player_thru_boards();
			if(isdefined(attack) && !attack && !self.missinglegs)
			{
				self do_a_taunt();
			}
			if(zm_utility::all_chunks_destroyed(self.first_node, self.first_node.barrier_chunks))
			{
				for(i = 0; i < self.first_node.attack_spots_taken.size; i++)
				{
					self.first_node.attack_spots_taken[i] = 0;
				}
				level notify(#"last_board_torn", self.first_node.zbarrier.origin);
				return;
			}
		}
		self zombie_utility::reset_attack_spot();
	}
}

/*
	Name: do_a_taunt
	Namespace: zm_spawner
	Checksum: 0x31B2DAC2
	Offset: 0x3A38
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function do_a_taunt()
{
	self endon(#"death");
	if(self.missinglegs)
	{
		return false;
	}
	if(!self.first_node.zbarrier zbarriersupportszombietaunts())
	{
		return;
	}
	self.old_origin = self.origin;
	if(getdvarstring("zombie_taunt_freq") == "")
	{
		setdvar("zombie_taunt_freq", "5");
	}
	freq = getdvarint("zombie_taunt_freq");
	if(freq >= randomint(100))
	{
		self notify(#"bhtn_action_notify", "taunt");
		tauntstate = "zm_taunt";
		if(isdefined(self.first_node.zbarrier) && self.first_node.zbarrier getzbarriertauntanimstate() != "")
		{
			tauntstate = self.first_node.zbarrier getzbarriertauntanimstate();
		}
		self animscripted("taunt_anim", self.origin, self.angles, "ai_zombie_taunts_4");
		self taunt_notetracks("taunt_anim");
	}
}

/*
	Name: taunt_notetracks
	Namespace: zm_spawner
	Checksum: 0xCD4FF39D
	Offset: 0x3C10
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function taunt_notetracks(msg)
{
	self endon(#"death");
	while(true)
	{
		self waittill(msg, notetrack);
		if(notetrack == "end")
		{
			self forceteleport(self.old_origin);
			return;
		}
	}
}

/*
	Name: should_attack_player_thru_boards
	Namespace: zm_spawner
	Checksum: 0x4F13855A
	Offset: 0x3C88
	Size: 0x330
	Parameters: 0
	Flags: Linked
*/
function should_attack_player_thru_boards()
{
	if(self.missinglegs)
	{
		return false;
	}
	if(isdefined(self.first_node.zbarrier))
	{
		if(!self.first_node.zbarrier zbarriersupportszombiereachthroughattacks())
		{
			return false;
		}
	}
	if(getdvarstring("zombie_reachin_freq") == "")
	{
		setdvar("zombie_reachin_freq", "50");
	}
	freq = getdvarint("zombie_reachin_freq");
	players = getplayers();
	attack = 0;
	self.player_targets = [];
	for(i = 0; i < players.size; i++)
	{
		if(isalive(players[i]) && !isdefined(players[i].revivetrigger) && distance2d(self.origin, players[i].origin) <= level.attack_player_thru_boards_range && (!(isdefined(players[i].zombie_vars["zombie_powerup_zombie_blood_on"]) && players[i].zombie_vars["zombie_powerup_zombie_blood_on"])))
		{
			self.player_targets[self.player_targets.size] = players[i];
			attack = 1;
		}
	}
	if(!attack || freq < randomint(100))
	{
		return false;
	}
	self.old_origin = self.origin;
	attackanimstate = "zm_window_melee";
	if(isdefined(self.first_node.zbarrier) && self.first_node.zbarrier getzbarrierreachthroughattackanimstate() != "")
	{
		attackanimstate = self.first_node.zbarrier getzbarrierreachthroughattackanimstate();
	}
	self notify(#"bhtn_action_notify", "attack");
	self animscripted("window_melee_anim", self.origin, self.angles, "ai_zombie_window_attack_arm_l_out");
	self window_notetracks("window_melee_anim");
	return true;
}

/*
	Name: window_notetracks
	Namespace: zm_spawner
	Checksum: 0xC54A1E44
	Offset: 0x3FC0
	Size: 0x2D8
	Parameters: 1
	Flags: Linked
*/
function window_notetracks(msg)
{
	self endon(#"death");
	while(true)
	{
		self waittill(msg, notetrack);
		if(notetrack == "end")
		{
			self teleport(self.old_origin);
			return;
		}
		if(notetrack == "fire")
		{
			if(self.ignoreall)
			{
				self.ignoreall = 0;
			}
			if(isdefined(self.first_node))
			{
				_melee_dist_sq = 8100;
				if(isdefined(level.attack_player_thru_boards_range))
				{
					_melee_dist_sq = level.attack_player_thru_boards_range * level.attack_player_thru_boards_range;
				}
				_trigger_dist_sq = 2601;
				for(i = 0; i < self.player_targets.size; i++)
				{
					playerdistsq = distance2dsquared(self.player_targets[i].origin, self.origin);
					heightdiff = abs(self.player_targets[i].origin[2] - self.origin[2]);
					if(playerdistsq < _melee_dist_sq && (heightdiff * heightdiff) < _melee_dist_sq)
					{
						triggerdistsq = distance2dsquared(self.player_targets[i].origin, self.first_node.trigger_location.origin);
						heightdiff = abs(self.player_targets[i].origin[2] - self.first_node.trigger_location.origin[2]);
						if(triggerdistsq < _trigger_dist_sq && (heightdiff * heightdiff) < _trigger_dist_sq)
						{
							self.player_targets[i] dodamage(self.meleedamage, self.origin, self, self, "none", "MOD_MELEE");
							break;
						}
					}
				}
			}
			else
			{
				self melee();
			}
		}
	}
}

/*
	Name: get_attack_spot
	Namespace: zm_spawner
	Checksum: 0xA13F7DE6
	Offset: 0x42A0
	Size: 0xD0
	Parameters: 1
	Flags: Linked
*/
function get_attack_spot(node)
{
	index = get_attack_spot_index(node);
	if(!isdefined(index))
	{
		return false;
	}
	/#
		val = getdvarint("");
		if(val > -1)
		{
			index = val;
		}
	#/
	self.attacking_node = node;
	self.attacking_spot_index = index;
	node.attack_spots_taken[index] = 1;
	self.attacking_spot = node.attack_spots[index];
	return true;
}

/*
	Name: get_attack_spot_index
	Namespace: zm_spawner
	Checksum: 0x894F9735
	Offset: 0x4378
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function get_attack_spot_index(node)
{
	indexes = [];
	if(!isdefined(node.attack_spots))
	{
		node.attack_spots = [];
	}
	for(i = 0; i < node.attack_spots.size; i++)
	{
		if(!node.attack_spots_taken[i])
		{
			indexes[indexes.size] = i;
		}
	}
	if(indexes.size == 0)
	{
		return undefined;
	}
	return indexes[randomint(indexes.size)];
}

/*
	Name: zombie_tear_notetracks
	Namespace: zm_spawner
	Checksum: 0x5F01BB50
	Offset: 0x4448
	Size: 0xD8
	Parameters: 3
	Flags: Linked
*/
function zombie_tear_notetracks(msg, chunk, node)
{
	self endon(#"death");
	while(true)
	{
		self waittill(msg, notetrack);
		if(notetrack == "end")
		{
			return;
		}
		if(notetrack == "board" || notetrack == "destroy_piece" || notetrack == "bar")
		{
			if(isdefined(level.zbarrier_zombie_tear_notetrack_override))
			{
				self thread [[level.zbarrier_zombie_tear_notetrack_override]](node, chunk);
			}
			node.zbarrier setzbarrierpiecestate(chunk, "opening");
		}
	}
}

/*
	Name: zombie_boardtear_offset_fx_horizontle
	Namespace: zm_spawner
	Checksum: 0x2C7346F2
	Offset: 0x4528
	Size: 0x394
	Parameters: 2
	Flags: Linked
*/
function zombie_boardtear_offset_fx_horizontle(chunk, node)
{
	if(isdefined(chunk.script_parameters) && (chunk.script_parameters == "repair_board" || chunk.script_parameters == "board"))
	{
		if(isdefined(chunk.unbroken) && chunk.unbroken == 1)
		{
			if(isdefined(chunk.material) && chunk.material == "glass")
			{
				playfx(level._effect["glass_break"], chunk.origin, node.angles);
				chunk.unbroken = 0;
			}
			else
			{
				if(isdefined(chunk.material) && chunk.material == "metal")
				{
					playfx(level._effect["fx_zombie_bar_break"], chunk.origin);
					chunk.unbroken = 0;
				}
				else if(isdefined(chunk.material) && chunk.material == "rock")
				{
					if(isdefined(level.use_clientside_rock_tearin_fx) && level.use_clientside_rock_tearin_fx)
					{
						chunk clientfield::set("tearin_rock_fx", 1);
					}
					else
					{
						playfx(level._effect["wall_break"], chunk.origin);
					}
					chunk.unbroken = 0;
				}
			}
		}
	}
	if(isdefined(chunk.script_parameters) && chunk.script_parameters == "barricade_vents")
	{
		if(isdefined(level.use_clientside_board_fx) && level.use_clientside_board_fx)
		{
			chunk clientfield::set("tearin_board_vertical_fx", 1);
		}
		else
		{
			playfx(level._effect["fx_zombie_bar_break"], chunk.origin);
		}
	}
	else
	{
		if(isdefined(chunk.material) && chunk.material == "rock")
		{
			if(isdefined(level.use_clientside_rock_tearin_fx) && level.use_clientside_rock_tearin_fx)
			{
				chunk clientfield::set("tearin_rock_fx", 1);
			}
		}
		else
		{
			if(isdefined(level.use_clientside_board_fx))
			{
				chunk clientfield::set("tearin_board_vertical_fx", 1);
			}
			else
			{
				wait(randomfloatrange(0.2, 0.4));
			}
		}
	}
}

/*
	Name: zombie_boardtear_offset_fx_verticle
	Namespace: zm_spawner
	Checksum: 0x81F82B71
	Offset: 0x48C8
	Size: 0x38C
	Parameters: 2
	Flags: None
*/
function zombie_boardtear_offset_fx_verticle(chunk, node)
{
	if(isdefined(chunk.script_parameters) && (chunk.script_parameters == "repair_board" || chunk.script_parameters == "board"))
	{
		if(isdefined(chunk.unbroken) && chunk.unbroken == 1)
		{
			if(isdefined(chunk.material) && chunk.material == "glass")
			{
				playfx(level._effect["glass_break"], chunk.origin, node.angles);
				chunk.unbroken = 0;
			}
			else
			{
				if(isdefined(chunk.material) && chunk.material == "metal")
				{
					playfx(level._effect["fx_zombie_bar_break"], chunk.origin);
					chunk.unbroken = 0;
				}
				else if(isdefined(chunk.material) && chunk.material == "rock")
				{
					if(isdefined(level.use_clientside_rock_tearin_fx) && level.use_clientside_rock_tearin_fx)
					{
						chunk clientfield::set("tearin_rock_fx", 1);
					}
					else
					{
						playfx(level._effect["wall_break"], chunk.origin);
					}
					chunk.unbroken = 0;
				}
			}
		}
	}
	if(isdefined(chunk.script_parameters) && chunk.script_parameters == "barricade_vents")
	{
		if(isdefined(level.use_clientside_board_fx))
		{
			chunk clientfield::set("tearin_board_horizontal_fx", 1);
		}
		else
		{
			playfx(level._effect["fx_zombie_bar_break"], chunk.origin);
		}
	}
	else
	{
		if(isdefined(chunk.material) && chunk.material == "rock")
		{
			if(isdefined(level.use_clientside_rock_tearin_fx) && level.use_clientside_rock_tearin_fx)
			{
				chunk clientfield::set("tearin_rock_fx", 1);
			}
		}
		else
		{
			if(isdefined(level.use_clientside_board_fx))
			{
				chunk clientfield::set("tearin_board_horizontal_fx", 1);
			}
			else
			{
				wait(randomfloatrange(0.2, 0.4));
			}
		}
	}
}

/*
	Name: zombie_bartear_offset_fx_verticle
	Namespace: zm_spawner
	Checksum: 0x455F089C
	Offset: 0x4C60
	Size: 0x5AE
	Parameters: 1
	Flags: None
*/
function zombie_bartear_offset_fx_verticle(chunk)
{
	if(isdefined(chunk.script_parameters) && chunk.script_parameters == "bar" || chunk.script_noteworthy == "board")
	{
		possible_tag_array_1 = [];
		possible_tag_array_1[0] = "Tag_fx_top";
		possible_tag_array_1[1] = "";
		possible_tag_array_1[2] = "Tag_fx_top";
		possible_tag_array_1[3] = "";
		possible_tag_array_2 = [];
		possible_tag_array_2[0] = "";
		possible_tag_array_2[1] = "Tag_fx_bottom";
		possible_tag_array_2[2] = "";
		possible_tag_array_2[3] = "Tag_fx_bottom";
		possible_tag_array_2 = array::randomize(possible_tag_array_2);
		random_fx = [];
		random_fx[0] = level._effect["fx_zombie_bar_break"];
		random_fx[1] = level._effect["fx_zombie_bar_break_lite"];
		random_fx[2] = level._effect["fx_zombie_bar_break"];
		random_fx[3] = level._effect["fx_zombie_bar_break_lite"];
		random_fx = array::randomize(random_fx);
		switch(randomint(9))
		{
			case 0:
			{
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top");
				wait(randomfloatrange(0, 0.3));
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom");
				break;
			}
			case 1:
			{
				playfxontag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top");
				wait(randomfloatrange(0, 0.3));
				playfxontag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom");
				break;
			}
			case 2:
			{
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top");
				wait(randomfloatrange(0, 0.3));
				playfxontag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom");
				break;
			}
			case 3:
			{
				playfxontag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top");
				wait(randomfloatrange(0, 0.3));
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom");
				break;
			}
			case 4:
			{
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top");
				wait(randomfloatrange(0, 0.3));
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom");
				break;
			}
			case 5:
			{
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top");
				break;
			}
			case 6:
			{
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom");
				break;
			}
			case 7:
			{
				playfxontag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top");
				break;
			}
			case 8:
			{
				playfxontag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom");
				break;
			}
		}
	}
}

/*
	Name: zombie_bartear_offset_fx_horizontle
	Namespace: zm_spawner
	Checksum: 0x7BC1F402
	Offset: 0x5218
	Size: 0x446
	Parameters: 1
	Flags: None
*/
function zombie_bartear_offset_fx_horizontle(chunk)
{
	if(isdefined(chunk.script_parameters) && chunk.script_parameters == "bar" || chunk.script_noteworthy == "board")
	{
		switch(randomint(10))
		{
			case 0:
			{
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left");
				wait(randomfloatrange(0, 0.3));
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right");
				break;
			}
			case 1:
			{
				playfxontag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left");
				wait(randomfloatrange(0, 0.3));
				playfxontag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right");
				break;
			}
			case 2:
			{
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left");
				wait(randomfloatrange(0, 0.3));
				playfxontag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right");
				break;
			}
			case 3:
			{
				playfxontag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left");
				wait(randomfloatrange(0, 0.3));
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right");
				break;
			}
			case 4:
			{
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left");
				wait(randomfloatrange(0, 0.3));
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right");
				break;
			}
			case 5:
			{
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left");
				break;
			}
			case 6:
			{
				playfxontag(level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right");
				break;
			}
			case 7:
			{
				playfxontag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right");
				break;
			}
			case 8:
			{
				playfxontag(level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right");
				break;
			}
		}
	}
}

/*
	Name: check_zbarrier_piece_for_zombie_inert
	Namespace: zm_spawner
	Checksum: 0x535AE2C8
	Offset: 0x5668
	Size: 0x84
	Parameters: 3
	Flags: Linked
*/
function check_zbarrier_piece_for_zombie_inert(chunk_index, zbarrier, zombie)
{
	zombie endon(#"completed_emerging_into_playable_area");
	zombie waittill(#"stop_zombie_goto_entrance");
	if(zbarrier getzbarrierpiecestate(chunk_index) == "targetted_by_zombie")
	{
		zbarrier setzbarrierpiecestate(chunk_index, "closed");
	}
}

/*
	Name: check_zbarrier_piece_for_zombie_death
	Namespace: zm_spawner
	Checksum: 0x332C081
	Offset: 0x56F8
	Size: 0xA4
	Parameters: 3
	Flags: Linked
*/
function check_zbarrier_piece_for_zombie_death(chunk_index, zbarrier, zombie)
{
	while(true)
	{
		if(zbarrier getzbarrierpiecestate(chunk_index) != "targetted_by_zombie")
		{
			return;
		}
		if(!isdefined(zombie) || !isalive(zombie))
		{
			zbarrier setzbarrierpiecestate(chunk_index, "closed");
			return;
		}
		wait(0.05);
	}
}

/*
	Name: check_for_zombie_death
	Namespace: zm_spawner
	Checksum: 0xE9F4EEE5
	Offset: 0x57A8
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function check_for_zombie_death(zombie)
{
	self endon(#"destroyed");
	wait(2.5);
	self zm_blockers::update_states("repaired");
}

/*
	Name: player_can_score_from_zombies
	Namespace: zm_spawner
	Checksum: 0xC7361F41
	Offset: 0x57F0
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function player_can_score_from_zombies()
{
	if(isdefined(self) && (isdefined(self.inhibit_scoring_from_zombies) && self.inhibit_scoring_from_zombies))
	{
		return false;
	}
	return true;
}

/*
	Name: zombie_can_drop_powerups
	Namespace: zm_spawner
	Checksum: 0x77EF676B
	Offset: 0x5828
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function zombie_can_drop_powerups(zombie)
{
	if(zm_utility::is_tactical_grenade(zombie.damageweapon) || !level flag::get("zombie_drop_powerups"))
	{
		return false;
	}
	if(isdefined(zombie.no_powerups) && zombie.no_powerups)
	{
		return false;
	}
	if(isdefined(level.no_powerups) && level.no_powerups)
	{
		return false;
	}
	if(isdefined(level.use_powerup_volumes) && level.use_powerup_volumes)
	{
		volumes = getentarray("no_powerups", "targetname");
		foreach(volume in volumes)
		{
			if(zombie istouching(volume))
			{
				return false;
			}
		}
	}
	return true;
}

/*
	Name: zombie_delay_powerup_drop
	Namespace: zm_spawner
	Checksum: 0x595C1424
	Offset: 0x59A8
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function zombie_delay_powerup_drop(origin)
{
	util::wait_network_frame();
	level thread zm_powerups::powerup_drop(origin);
}

/*
	Name: zombie_death_points
	Namespace: zm_spawner
	Checksum: 0x59632AD0
	Offset: 0x59E8
	Size: 0x358
	Parameters: 6
	Flags: Linked
*/
function zombie_death_points(origin, mod, hit_location, attacker, zombie, team)
{
	if(!isdefined(attacker) || !isplayer(attacker))
	{
		return;
	}
	if(!attacker player_can_score_from_zombies())
	{
		zombie.marked_for_recycle = 1;
		return;
	}
	if(zombie_can_drop_powerups(zombie))
	{
		if(isdefined(zombie.in_the_ground) && zombie.in_the_ground == 1)
		{
			trace = bullettrace(zombie.origin + vectorscale((0, 0, 1), 100), zombie.origin + (vectorscale((0, 0, -1), 100)), 0, undefined);
			origin = trace["position"];
			level thread zombie_delay_powerup_drop(origin);
		}
		else
		{
			trace = groundtrace(zombie.origin + vectorscale((0, 0, 1), 5), zombie.origin + (vectorscale((0, 0, -1), 300)), 0, undefined);
			origin = trace["position"];
			level thread zombie_delay_powerup_drop(origin);
		}
	}
	level thread zm_audio::player_zombie_kill_vox(hit_location, attacker, mod, zombie);
	event = "death";
	if(zombie.damageweapon.isballisticknife && (mod == "MOD_MELEE" || mod == "MOD_IMPACT"))
	{
		event = "ballistic_knife_death";
	}
	if(isdefined(zombie.deathpoints_already_given) && zombie.deathpoints_already_given)
	{
		return;
	}
	zombie.deathpoints_already_given = 1;
	if(zm_equipment::is_equipment(zombie.damageweapon))
	{
		return;
	}
	death_weapon = attacker.currentweapon;
	if(isdefined(zombie.damageweapon))
	{
		death_weapon = zombie.damageweapon;
	}
	if(isdefined(attacker))
	{
		attacker zm_score::player_add_points(event, mod, hit_location, undefined, team, death_weapon);
	}
	if(isdefined(level.hero_power_update))
	{
		level thread [[level.hero_power_update]](attacker, zombie);
	}
}

/*
	Name: get_number_variants
	Namespace: zm_spawner
	Checksum: 0xC50DDD77
	Offset: 0x5D48
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function get_number_variants(aliasprefix)
{
	for(i = 0; i < 100; i++)
	{
		if(!soundexists((aliasprefix + "_") + i))
		{
			return i;
		}
	}
}

/*
	Name: dragons_breath_flame_death_fx
	Namespace: zm_spawner
	Checksum: 0x9CBB822D
	Offset: 0x5DB0
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function dragons_breath_flame_death_fx()
{
	if(self.isdog)
	{
		return;
	}
	if(!isdefined(level._effect) || !isdefined(level._effect["character_fire_death_sm"]))
	{
		/#
			println("");
		#/
		return;
	}
	playfxontag(level._effect["character_fire_death_sm"], self, "J_SpineLower");
	tagarray = [];
	if(!isdefined(self.a.gib_ref) || self.a.gib_ref != "left_arm")
	{
		tagarray[tagarray.size] = "J_Elbow_LE";
		tagarray[tagarray.size] = "J_Wrist_LE";
	}
	if(!isdefined(self.a.gib_ref) || self.a.gib_ref != "right_arm")
	{
		tagarray[tagarray.size] = "J_Elbow_RI";
		tagarray[tagarray.size] = "J_Wrist_RI";
	}
	if(!isdefined(self.a.gib_ref) || (self.a.gib_ref != "no_legs" && self.a.gib_ref != "left_leg"))
	{
		tagarray[tagarray.size] = "J_Knee_LE";
		tagarray[tagarray.size] = "J_Ankle_LE";
	}
	if(!isdefined(self.a.gib_ref) || (self.a.gib_ref != "no_legs" && self.a.gib_ref != "right_leg"))
	{
		tagarray[tagarray.size] = "J_Knee_RI";
		tagarray[tagarray.size] = "J_Ankle_RI";
	}
	tagarray = array::randomize(tagarray);
	playfxontag(level._effect["character_fire_death_sm"], self, tagarray[0]);
}

/*
	Name: zombie_ragdoll_then_explode
	Namespace: zm_spawner
	Checksum: 0xF2289E84
	Offset: 0x6040
	Size: 0x16C
	Parameters: 2
	Flags: None
*/
function zombie_ragdoll_then_explode(launchvector, attacker)
{
	if(!isdefined(self))
	{
		return;
	}
	self zombie_utility::zombie_eye_glow_stop();
	self clientfield::set("zombie_ragdoll_explode", 1);
	self notify(#"exploding");
	self notify(#"end_melee");
	self notify(#"death", attacker);
	self.dont_die_on_me = 1;
	self.exploding = 1;
	self.a.nodeath = 1;
	self.dont_throw_gib = 1;
	self startragdoll();
	self setplayercollision(0);
	self zombie_utility::reset_attack_spot();
	if(isdefined(launchvector))
	{
		self launchragdoll(launchvector);
	}
	wait(2.1);
	if(isdefined(self))
	{
		self ghost();
		self util::delay(0.25, undefined, &zm_utility::self_delete);
	}
}

/*
	Name: zombie_death_animscript
	Namespace: zm_spawner
	Checksum: 0xEA00CB7E
	Offset: 0x61B8
	Size: 0x39C
	Parameters: 8
	Flags: Linked
*/
function zombie_death_animscript(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	team = undefined;
	zm_utility::recalc_zombie_array();
	if(isdefined(self._race_team))
	{
		team = self._race_team;
	}
	self zombie_utility::reset_attack_spot();
	if(self check_zombie_death_animscript_callbacks())
	{
		return false;
	}
	if(isdefined(level.zombie_death_animscript_override))
	{
		self [[level.zombie_death_animscript_override]]();
	}
	self.grenadeammo = 0;
	if(isdefined(self.nuked))
	{
		if(zombie_can_drop_powerups(self))
		{
			if(isdefined(self.in_the_ground) && self.in_the_ground == 1)
			{
				trace = bullettrace(self.origin + vectorscale((0, 0, 1), 100), self.origin + (vectorscale((0, 0, -1), 100)), 0, undefined);
				origin = trace["position"];
				level thread zombie_delay_powerup_drop(origin);
			}
			else
			{
				trace = groundtrace(self.origin + vectorscale((0, 0, 1), 5), self.origin + (vectorscale((0, 0, -1), 300)), 0, undefined);
				origin = trace["position"];
				level thread zombie_delay_powerup_drop(self.origin);
			}
		}
	}
	else
	{
		level zombie_death_points(self.origin, self.damagemod, self.damagelocation, self.attacker, self, team);
	}
	if(isdefined(self.attacker) && isai(self.attacker))
	{
		self.attacker notify(#"killed", self);
	}
	if("rottweil72_upgraded" == self.damageweapon.name && "MOD_RIFLE_BULLET" == self.damagemod)
	{
		self thread dragons_breath_flame_death_fx();
	}
	if("tazer_knuckles" == self.damageweapon.name && "MOD_MELEE" == self.damagemod)
	{
		self.is_on_fire = 0;
		self notify(#"stop_flame_damage");
	}
	if(self.damagemod == "MOD_BURNED")
	{
		self thread zombie_death::flame_death_fx();
	}
	if(self.damagemod == "MOD_GRENADE" || self.damagemod == "MOD_GRENADE_SPLASH")
	{
		level notify(#"zombie_grenade_death", self.origin);
	}
	return false;
}

/*
	Name: check_zombie_death_animscript_callbacks
	Namespace: zm_spawner
	Checksum: 0xE0FB9317
	Offset: 0x6560
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function check_zombie_death_animscript_callbacks()
{
	if(!isdefined(level.zombie_death_animscript_callbacks))
	{
		return false;
	}
	for(i = 0; i < level.zombie_death_animscript_callbacks.size; i++)
	{
		if(self [[level.zombie_death_animscript_callbacks[i]]]())
		{
			return true;
		}
	}
	return false;
}

/*
	Name: register_zombie_death_animscript_callback
	Namespace: zm_spawner
	Checksum: 0xF16FFF1A
	Offset: 0x65D0
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function register_zombie_death_animscript_callback(func)
{
	if(!isdefined(level.zombie_death_animscript_callbacks))
	{
		level.zombie_death_animscript_callbacks = [];
	}
	level.zombie_death_animscript_callbacks[level.zombie_death_animscript_callbacks.size] = func;
}

/*
	Name: damage_on_fire
	Namespace: zm_spawner
	Checksum: 0x445CAE19
	Offset: 0x6618
	Size: 0x1C8
	Parameters: 1
	Flags: Linked
*/
function damage_on_fire(player)
{
	self endon(#"death");
	self endon(#"stop_flame_damage");
	wait(2);
	while(isdefined(self.is_on_fire) && self.is_on_fire)
	{
		if(level.round_number < 6)
		{
			dmg = level.zombie_health * randomfloatrange(0.2, 0.3);
		}
		else
		{
			if(level.round_number < 9)
			{
				dmg = level.zombie_health * randomfloatrange(0.15, 0.25);
			}
			else
			{
				if(level.round_number < 11)
				{
					dmg = level.zombie_health * randomfloatrange(0.1, 0.2);
				}
				else
				{
					dmg = level.zombie_health * randomfloatrange(0.1, 0.15);
				}
			}
		}
		if(isdefined(player) && isalive(player))
		{
			self dodamage(dmg, self.origin, player);
		}
		else
		{
			self dodamage(dmg, self.origin, level);
		}
		wait(randomfloatrange(1, 3));
	}
}

/*
	Name: player_using_hi_score_weapon
	Namespace: zm_spawner
	Checksum: 0xA235BF48
	Offset: 0x67E8
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function player_using_hi_score_weapon(player)
{
	if(isplayer(player))
	{
		weapon = player getcurrentweapon();
		return weapon == level.weaponnone || weapon.issemiauto;
	}
	return 0;
}

/*
	Name: zombie_damage
	Namespace: zm_spawner
	Checksum: 0x9D8E3DFE
	Offset: 0x6860
	Size: 0x724
	Parameters: 14
	Flags: Linked
*/
function zombie_damage(mod, hit_location, hit_origin, player, amount, team, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel)
{
	if(zm_utility::is_magic_bullet_shield_enabled(self))
	{
		return;
	}
	player.use_weapon_type = mod;
	if(isdefined(self.marked_for_death))
	{
		return;
	}
	if(!isdefined(player))
	{
		return;
	}
	if(isdefined(hit_origin))
	{
		self.damagehit_origin = hit_origin;
	}
	else
	{
		self.damagehit_origin = player getweaponmuzzlepoint();
	}
	if(self check_zombie_damage_callbacks(mod, hit_location, hit_origin, player, amount, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel))
	{
		return;
	}
	if(!player player_can_score_from_zombies())
	{
	}
	else
	{
		if(isdefined(weapon) && weapon.isriotshield)
		{
		}
		else
		{
			if(self zombie_flame_damage(mod, player))
			{
				if(self zombie_give_flame_damage_points())
				{
					player zm_score::player_add_points("damage", mod, hit_location, self.isdog, team);
				}
			}
			else
			{
				if(player_using_hi_score_weapon(player))
				{
					damage_type = "damage";
				}
				else
				{
					damage_type = "damage_light";
				}
				if(!(isdefined(self.no_damage_points) && self.no_damage_points))
				{
					player zm_score::player_add_points(damage_type, mod, hit_location, self.isdog, team, weapon);
				}
			}
		}
	}
	if(isdefined(self.zombie_damage_fx_func))
	{
		self [[self.zombie_damage_fx_func]](mod, hit_location, hit_origin, player, direction_vec);
	}
	if("MOD_IMPACT" != mod && zm_utility::is_placeable_mine(weapon))
	{
		if(isdefined(self.zombie_damage_claymore_func))
		{
			self [[self.zombie_damage_claymore_func]](mod, hit_location, hit_origin, player);
		}
		else
		{
			if(isdefined(player) && isalive(player))
			{
				self dodamage(level.round_number * randomintrange(100, 200), self.origin, player, self, hit_location, mod, 0, weapon);
			}
			else
			{
				self dodamage(level.round_number * randomintrange(100, 200), self.origin, undefined, self, hit_location, mod, 0, weapon);
			}
		}
	}
	else
	{
		if(mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH")
		{
			if(isdefined(player) && isalive(player))
			{
				player.grenade_multiattack_count++;
				player.grenade_multiattack_ent = self;
				self dodamage(level.round_number + randomintrange(100, 200), self.origin, player, self, hit_location, mod, 0, weapon);
			}
			else
			{
				self dodamage(level.round_number + randomintrange(100, 200), self.origin, undefined, self, hit_location, mod, 0, weapon);
			}
		}
		else if(mod == "MOD_PROJECTILE" || mod == "MOD_EXPLOSIVE" || mod == "MOD_PROJECTILE_SPLASH")
		{
			if(isdefined(player) && isalive(player))
			{
				self dodamage(level.round_number * randomintrange(0, 100), self.origin, player, self, hit_location, mod, 0, weapon);
			}
			else
			{
				self dodamage(level.round_number * randomintrange(0, 100), self.origin, undefined, self, hit_location, mod, 0, weapon);
			}
		}
	}
	if(isdefined(self.gibbed) && self.gibbed)
	{
		if(isdefined(self.missinglegs) && self.missinglegs && isalive(self))
		{
			if(isdefined(player))
			{
				player zm_audio::create_and_play_dialog("general", "crawl_spawn");
			}
		}
		else if(isdefined(self.a.gib_ref) && (self.a.gib_ref == "right_arm" || self.a.gib_ref == "left_arm"))
		{
			if(!self.missinglegs && isalive(self))
			{
				if(isdefined(player))
				{
					rand = randomintrange(0, 100);
					if(rand < 7)
					{
						player zm_audio::create_and_play_dialog("general", "shoot_arm");
					}
				}
			}
		}
	}
	self thread zm_powerups::check_for_instakill(player, mod, hit_location);
}

/*
	Name: zombie_damage_ads
	Namespace: zm_spawner
	Checksum: 0xA204560C
	Offset: 0x6F90
	Size: 0x28C
	Parameters: 14
	Flags: Linked
*/
function zombie_damage_ads(mod, hit_location, hit_origin, player, amount, team, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel)
{
	if(zm_utility::is_magic_bullet_shield_enabled(self))
	{
		return;
	}
	player.use_weapon_type = mod;
	if(!isdefined(player))
	{
		return;
	}
	if(isdefined(hit_origin))
	{
		self.damagehit_origin = hit_origin;
	}
	else
	{
		self.damagehit_origin = player getweaponmuzzlepoint();
	}
	if(self check_zombie_damage_callbacks(mod, hit_location, hit_origin, player, amount, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel))
	{
		return;
	}
	if(!player player_can_score_from_zombies())
	{
	}
	else
	{
		if(self zombie_flame_damage(mod, player))
		{
			if(self zombie_give_flame_damage_points())
			{
				player zm_score::player_add_points("damage_ads", mod, hit_location, undefined, team);
			}
		}
		else
		{
			if(player_using_hi_score_weapon(player))
			{
				damage_type = "damage";
			}
			else
			{
				damage_type = "damage_light";
			}
			if(!(isdefined(self.no_damage_points) && self.no_damage_points))
			{
				player zm_score::player_add_points(damage_type, mod, hit_location, undefined, team, weapon);
			}
		}
	}
	if(isdefined(self.zombie_damage_fx_func))
	{
		self [[self.zombie_damage_fx_func]](mod, hit_location, hit_origin, player, direction_vec);
	}
	self thread zm_powerups::check_for_instakill(player, mod, hit_location);
}

/*
	Name: check_zombie_damage_callbacks
	Namespace: zm_spawner
	Checksum: 0x257BEE37
	Offset: 0x7228
	Size: 0xFE
	Parameters: 13
	Flags: Linked
*/
function check_zombie_damage_callbacks(mod, hit_location, hit_origin, player, amount, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel)
{
	if(!isdefined(level.zombie_damage_callbacks))
	{
		return false;
	}
	for(i = 0; i < level.zombie_damage_callbacks.size; i++)
	{
		if(self [[level.zombie_damage_callbacks[i]]](mod, hit_location, hit_origin, player, amount, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: register_zombie_damage_callback
	Namespace: zm_spawner
	Checksum: 0x6902322F
	Offset: 0x7330
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function register_zombie_damage_callback(func)
{
	if(!isdefined(level.zombie_damage_callbacks))
	{
		level.zombie_damage_callbacks = [];
	}
	level.zombie_damage_callbacks[level.zombie_damage_callbacks.size] = func;
}

/*
	Name: zombie_give_flame_damage_points
	Namespace: zm_spawner
	Checksum: 0x2F053C8C
	Offset: 0x7378
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function zombie_give_flame_damage_points()
{
	if(!isdefined(self.flame_damage_time) || gettime() > self.flame_damage_time)
	{
		self.flame_damage_time = gettime() + level.zombie_vars["zombie_flame_dmg_point_delay"];
		return true;
	}
	return false;
}

/*
	Name: zombie_flame_damage
	Namespace: zm_spawner
	Checksum: 0x52986543
	Offset: 0x73C8
	Size: 0x16C
	Parameters: 2
	Flags: Linked
*/
function zombie_flame_damage(mod, player)
{
	if(mod == "MOD_BURNED")
	{
		if(!isdefined(self.is_on_fire) || (isdefined(self.is_on_fire) && !self.is_on_fire))
		{
			self thread damage_on_fire(player);
		}
		do_flame_death = 1;
		dist = 10000;
		ai = getaiteamarray(level.zombie_team);
		for(i = 0; i < ai.size; i++)
		{
			if(isdefined(ai[i].is_on_fire) && ai[i].is_on_fire)
			{
				if(distancesquared(ai[i].origin, self.origin) < dist)
				{
					do_flame_death = 0;
					break;
				}
			}
		}
		if(do_flame_death)
		{
			self thread zombie_death::flame_death_fx();
		}
		return true;
	}
	return false;
}

/*
	Name: is_weapon_shotgun
	Namespace: zm_spawner
	Checksum: 0xE9B9123A
	Offset: 0x7540
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function is_weapon_shotgun(weapon)
{
	return weapon.weapclass == "spread";
}

/*
	Name: zombie_explodes_intopieces
	Namespace: zm_spawner
	Checksum: 0x3EDC84E4
	Offset: 0x7570
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function zombie_explodes_intopieces(random_gibs)
{
	if(isdefined(self) && isactor(self))
	{
		if(!random_gibs || randomint(100) < 50)
		{
			gibserverutils::gibhead(self);
		}
		if(!random_gibs || randomint(100) < 50)
		{
			gibserverutils::gibleftarm(self);
		}
		if(!random_gibs || randomint(100) < 50)
		{
			gibserverutils::gibrightarm(self);
		}
		if(!random_gibs || randomint(100) < 50)
		{
			gibserverutils::giblegs(self);
		}
	}
}

/*
	Name: zombie_death_event
	Namespace: zm_spawner
	Checksum: 0xF0F342C3
	Offset: 0x76A8
	Size: 0xBEC
	Parameters: 1
	Flags: Linked
*/
function zombie_death_event(zombie)
{
	zombie.marked_for_recycle = 0;
	force_explode = 0;
	force_head_gib = 0;
	zombie waittill(#"death", attacker);
	time_of_death = gettime();
	if(isdefined(zombie))
	{
		zombie stopsounds();
	}
	if(isdefined(zombie) && isdefined(zombie.marked_for_insta_upgraded_death))
	{
		force_head_gib = 1;
	}
	if(isdefined(zombie) && !isdefined(zombie.damagehit_origin) && isdefined(attacker) && isalive(attacker) && !isvehicle(attacker))
	{
		zombie.damagehit_origin = attacker getweaponmuzzlepoint();
	}
	if(isdefined(attacker) && isplayer(attacker) && attacker player_can_score_from_zombies())
	{
		if(isdefined(zombie.script_parameters))
		{
			attacker notify(#"zombie_death_params", zombie.script_parameters, isdefined(zombie.completed_emerging_into_playable_area) && zombie.completed_emerging_into_playable_area);
		}
		if(isdefined(zombie.b_widows_wine_cocoon) && isdefined(zombie.e_widows_wine_player))
		{
			attacker notify(#"widows_wine_kill", zombie.e_widows_wine_player);
		}
		if(isdefined(level.pers_upgrade_carpenter) && level.pers_upgrade_carpenter)
		{
			zm_pers_upgrades::pers_zombie_death_location_check(attacker, zombie.origin);
		}
		if(isdefined(level.pers_upgrade_sniper) && level.pers_upgrade_sniper)
		{
			attacker zm_pers_upgrades_functions::pers_upgrade_sniper_kill_check(zombie, attacker);
		}
		if(isdefined(zombie) && isdefined(zombie.damagelocation))
		{
			if(zm_utility::is_headshot(zombie.damageweapon, zombie.damagelocation, zombie.damagemod))
			{
				attacker.headshots++;
				attacker zm_stats::increment_client_stat("headshots");
				attacker addweaponstat(zombie.damageweapon, "headshots", 1);
				attacker zm_stats::increment_player_stat("headshots");
				attacker zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_KILL_HEADSHOT");
				if(zm_utility::is_classic())
				{
					attacker zm_pers_upgrades_functions::pers_check_for_pers_headshot(time_of_death, zombie);
				}
			}
			else
			{
				attacker notify(#"zombie_death_no_headshot");
			}
		}
		if(isdefined(zombie) && isdefined(zombie.damagemod) && zombie.damagemod == "MOD_MELEE")
		{
			attacker zm_stats::increment_client_stat("melee_kills");
			attacker zm_stats::increment_player_stat("melee_kills");
			attacker notify(#"melee_kill");
			attacker zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_KILL_MELEE");
			if(attacker zm_pers_upgrades::is_insta_kill_upgraded_and_active())
			{
				force_explode = 1;
			}
		}
		attacker demo::add_actor_bookmark_kill_time();
		attacker.kills++;
		attacker zm_stats::increment_client_stat("kills");
		attacker zm_stats::increment_player_stat("kills");
		if(isdefined(level.pers_upgrade_pistol_points) && level.pers_upgrade_pistol_points)
		{
			attacker zm_pers_upgrades_functions::pers_upgrade_pistol_points_kill();
		}
		if(isdefined(zombie) && isdefined(zombie.damageweapon))
		{
			attacker addweaponstat(zombie.damageweapon, "kills", 1);
			if(zm_weapons::is_weapon_upgraded(zombie.damageweapon))
			{
				attacker zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_KILL_PACKAPUNCH");
			}
		}
		if(isdefined(zombie) && (isdefined(zombie.missinglegs) && zombie.missinglegs))
		{
			attacker zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_KILL_CRAWLER");
		}
		if(attacker zm_pers_upgrades_functions::pers_mulit_kill_headshot_active() || force_head_gib)
		{
			zombie zombie_utility::zombie_head_gib();
		}
		if(isdefined(level.pers_upgrade_nube) && level.pers_upgrade_nube)
		{
			attacker notify(#"pers_player_zombie_kill");
		}
	}
	zm_utility::recalc_zombie_array();
	if(!isdefined(zombie))
	{
		return;
	}
	level.global_zombies_killed++;
	if(isdefined(zombie.marked_for_death) && !isdefined(zombie.nuked))
	{
		level.zombie_trap_killed_count++;
	}
	zombie check_zombie_death_event_callbacks(attacker);
	zombie bgb::actor_death_override(attacker);
	if(!isdefined(zombie))
	{
		return;
	}
	name = zombie.animname;
	if(isdefined(zombie.sndname))
	{
		name = zombie.sndname;
	}
	self notify(#"bhtn_action_notify", "death");
	zombie thread zombie_utility::zombie_eye_glow_stop();
	if(isactor(zombie))
	{
		if(isdefined(zombie.damageweapon.doannihilate) && zombie.damageweapon.doannihilate)
		{
			zombie zombie_explodes_intopieces(0);
		}
		else if(is_weapon_shotgun(zombie.damageweapon) && zm_weapons::is_weapon_upgraded(zombie.damageweapon) || zm_utility::is_placeable_mine(zombie.damageweapon) || (zombie.damagemod === "MOD_GRENADE" || zombie.damagemod === "MOD_GRENADE_SPLASH" || zombie.damagemod === "MOD_EXPLOSIVE" || force_explode == 1))
		{
			splode_dist = 180;
			if(isdefined(zombie.damagehit_origin) && distancesquared(zombie.origin, zombie.damagehit_origin) < (splode_dist * splode_dist))
			{
				tag = "J_SpineLower";
				if(isdefined(zombie.isdog) && zombie.isdog)
				{
					tag = "tag_origin";
				}
				if(!(isdefined(zombie.is_on_fire) && zombie.is_on_fire) && (!(isdefined(zombie.guts_explosion) && zombie.guts_explosion)))
				{
					zombie thread zombie_utility::zombie_gut_explosion();
				}
			}
			if(isdefined(attacker) && isplayer(attacker) && !is_weapon_shotgun(zombie.damageweapon))
			{
				attacker zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_KILL_EXPLOSIVES");
			}
		}
		if(zombie.damagemod === "MOD_GRENADE" || zombie.damagemod === "MOD_GRENADE_SPLASH")
		{
			if(isdefined(attacker) && isalive(attacker) && isplayer(attacker))
			{
				attacker.grenade_multiattack_count++;
				attacker.grenade_multiattack_ent = zombie;
				attacker.grenade_multikill_count++;
			}
		}
	}
	if(!(isdefined(zombie.has_been_damaged_by_player) && zombie.has_been_damaged_by_player) && (isdefined(zombie.marked_for_recycle) && zombie.marked_for_recycle))
	{
		level.zombie_total++;
		level.zombie_total_subtract++;
	}
	else
	{
		if(isdefined(zombie.attacker) && isplayer(zombie.attacker))
		{
			level.zombie_player_killed_count++;
			if(isdefined(zombie.sound_damage_player) && zombie.sound_damage_player == zombie.attacker)
			{
				zombie.attacker zm_audio::create_and_play_dialog("kill", "damage");
			}
			zombie.attacker notify(#"zom_kill", zombie);
		}
		else if(zombie.ignoreall && (!(isdefined(zombie.marked_for_death) && zombie.marked_for_death)))
		{
			level.zombies_timeout_spawn++;
		}
	}
	level notify(#"zom_kill");
	level.total_zombies_killed++;
}

/*
	Name: check_zombie_death_event_callbacks
	Namespace: zm_spawner
	Checksum: 0xA7F7E799
	Offset: 0x82A0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function check_zombie_death_event_callbacks(attacker)
{
	if(!isdefined(level.zombie_death_event_callbacks))
	{
		return;
	}
	for(i = 0; i < level.zombie_death_event_callbacks.size; i++)
	{
		self [[level.zombie_death_event_callbacks[i]]](attacker);
	}
}

/*
	Name: register_zombie_death_event_callback
	Namespace: zm_spawner
	Checksum: 0x4EB7C596
	Offset: 0x8310
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function register_zombie_death_event_callback(func)
{
	if(!isdefined(level.zombie_death_event_callbacks))
	{
		level.zombie_death_event_callbacks = [];
	}
	level.zombie_death_event_callbacks[level.zombie_death_event_callbacks.size] = func;
}

/*
	Name: deregister_zombie_death_event_callback
	Namespace: zm_spawner
	Checksum: 0xB2B73F21
	Offset: 0x8358
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function deregister_zombie_death_event_callback(func)
{
	if(isdefined(level.zombie_death_event_callbacks))
	{
		arrayremovevalue(level.zombie_death_event_callbacks, func);
	}
}

/*
	Name: zombie_setup_attack_properties
	Namespace: zm_spawner
	Checksum: 0x35116976
	Offset: 0x8398
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function zombie_setup_attack_properties()
{
	self zombie_history("zombie_setup_attack_properties()");
	self.ignoreall = 0;
	self.meleeattackdist = 64;
	self.maxsightdistsqrd = 16384;
	self.disablearrivals = 1;
	self.disableexits = 1;
}

/*
	Name: attractors_generated_listener
	Namespace: zm_spawner
	Checksum: 0xF0BB20C1
	Offset: 0x8400
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function attractors_generated_listener()
{
	self endon(#"death");
	level endon(#"intermission");
	self endon(#"stop_find_flesh");
	self endon(#"path_timer_done");
	level waittill(#"attractor_positions_generated");
	self.zombie_path_timer = 0;
}

/*
	Name: zombie_pathing
	Namespace: zm_spawner
	Checksum: 0x5530C6DF
	Offset: 0x8458
	Size: 0x4AC
	Parameters: 0
	Flags: None
*/
function zombie_pathing()
{
	self endon(#"death");
	self endon(#"zombie_acquire_enemy");
	level endon(#"intermission");
	/#
		assert(isdefined(self.favoriteenemy) || isdefined(self.enemyoverride));
	#/
	self._skip_pathing_first_delay = 1;
	self thread zombie_follow_enemy();
	self waittill(#"bad_path");
	level.zombie_pathing_failed++;
	if(isdefined(self.enemyoverride))
	{
		zm_utility::debug_print(("Zombie couldn't path to point of interest at origin: " + self.enemyoverride[0]) + " Falling back to breadcrumb system");
		if(isdefined(self.enemyoverride[1]))
		{
			self.enemyoverride = self.enemyoverride[1] zm_utility::invalidate_attractor_pos(self.enemyoverride, self);
			self.zombie_path_timer = 0;
			return;
		}
	}
	else
	{
		if(isdefined(self.favoriteenemy))
		{
			zm_utility::debug_print(("Zombie couldn't path to player at origin: " + self.favoriteenemy.origin) + " Falling back to breadcrumb system");
		}
		else
		{
			zm_utility::debug_print("Zombie couldn't path to a player ( the other 'prefered' player might be ignored for encounters mode ). Falling back to breadcrumb system");
		}
	}
	if(!isdefined(self.favoriteenemy))
	{
		self.zombie_path_timer = 0;
		return;
	}
	self.favoriteenemy endon(#"disconnect");
	players = getplayers();
	valid_player_num = 0;
	for(i = 0; i < players.size; i++)
	{
		if(zm_utility::is_player_valid(players[i], 1))
		{
			valid_player_num = valid_player_num + 1;
		}
	}
	if(players.size > 1)
	{
		if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
		{
			self.zombie_path_timer = 0;
			return;
		}
		if(!isinarray(self.ignore_player, self.favoriteenemy))
		{
			self.ignore_player[self.ignore_player.size] = self.favoriteenemy;
		}
		if(self.ignore_player.size < valid_player_num)
		{
			self.zombie_path_timer = 0;
			return;
		}
	}
	crumb_list = self.favoriteenemy.zombie_breadcrumbs;
	bad_crumbs = [];
	while(true)
	{
		if(!zm_utility::is_player_valid(self.favoriteenemy, 1))
		{
			self.zombie_path_timer = 0;
			return;
		}
		goal = zombie_pathing_get_breadcrumb(self.favoriteenemy.origin, crumb_list, bad_crumbs, randomint(100) < 20);
		if(!isdefined(goal))
		{
			zm_utility::debug_print("Zombie exhausted breadcrumb search");
			level.zombie_breadcrumb_failed++;
			goal = self.favoriteenemy.spectator_respawn.origin;
		}
		zm_utility::debug_print("Setting current breadcrumb to " + goal);
		self.zombie_path_timer = self.zombie_path_timer + 100;
		self setgoal(goal);
		self waittill(#"bad_path");
		zm_utility::debug_print(("Zombie couldn't path to breadcrumb at " + goal) + " Finding next breadcrumb");
		for(i = 0; i < crumb_list.size; i++)
		{
			if(goal == crumb_list[i])
			{
				bad_crumbs[bad_crumbs.size] = i;
				break;
			}
		}
	}
}

/*
	Name: zombie_pathing_get_breadcrumb
	Namespace: zm_spawner
	Checksum: 0x9F832985
	Offset: 0x8910
	Size: 0x152
	Parameters: 4
	Flags: Linked
*/
function zombie_pathing_get_breadcrumb(origin, breadcrumbs, bad_crumbs, pick_random)
{
	/#
		assert(isdefined(origin));
	#/
	/#
		assert(isdefined(breadcrumbs));
	#/
	/#
		assert(isarray(breadcrumbs));
	#/
	/#
		if(pick_random)
		{
			zm_utility::debug_print("");
		}
	#/
	for(i = 0; i < breadcrumbs.size; i++)
	{
		if(pick_random)
		{
			crumb_index = randomint(breadcrumbs.size);
		}
		else
		{
			crumb_index = i;
		}
		if(crumb_is_bad(crumb_index, bad_crumbs))
		{
			continue;
		}
		return breadcrumbs[crumb_index];
	}
	return undefined;
}

/*
	Name: crumb_is_bad
	Namespace: zm_spawner
	Checksum: 0x8BA56A7
	Offset: 0x8A70
	Size: 0x5A
	Parameters: 2
	Flags: Linked
*/
function crumb_is_bad(crumb, bad_crumbs)
{
	for(i = 0; i < bad_crumbs.size; i++)
	{
		if(bad_crumbs[i] == crumb)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: jitter_enemies_bad_breadcrumbs
	Namespace: zm_spawner
	Checksum: 0x119E348D
	Offset: 0x8AD8
	Size: 0x278
	Parameters: 1
	Flags: None
*/
function jitter_enemies_bad_breadcrumbs(start_crumb)
{
	trace_distance = 35;
	jitter_distance = 2;
	index = start_crumb;
	while(isdefined(self.favoriteenemy.zombie_breadcrumbs[index + 1]))
	{
		current_crumb = self.favoriteenemy.zombie_breadcrumbs[index];
		next_crumb = self.favoriteenemy.zombie_breadcrumbs[index + 1];
		angles = vectortoangles(current_crumb - next_crumb);
		right = anglestoright(angles);
		left = anglestoright(angles + vectorscale((0, 1, 0), 180));
		dist_pos = current_crumb + vectorscale(right, trace_distance);
		trace = bullettrace(current_crumb, dist_pos, 1, undefined);
		vector = trace["position"];
		if(distance(vector, current_crumb) < 17)
		{
			self.favoriteenemy.zombie_breadcrumbs[index] = current_crumb + vectorscale(left, jitter_distance);
			continue;
		}
		dist_pos = current_crumb + vectorscale(left, trace_distance);
		trace = bullettrace(current_crumb, dist_pos, 1, undefined);
		vector = trace["position"];
		if(distance(vector, current_crumb) < 17)
		{
			self.favoriteenemy.zombie_breadcrumbs[index] = current_crumb + vectorscale(right, jitter_distance);
			continue;
		}
		index++;
	}
}

/*
	Name: zombie_repath_notifier
	Namespace: zm_spawner
	Checksum: 0x23EBD865
	Offset: 0x8D58
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function zombie_repath_notifier()
{
	note = 0;
	notes = [];
	for(i = 0; i < 4; i++)
	{
		notes[notes.size] = "zombie_repath_notify_" + i;
	}
	while(true)
	{
		level notify(notes[note]);
		note = (note + 1) % 4;
		wait(0.05);
	}
}

/*
	Name: zombie_follow_enemy
	Namespace: zm_spawner
	Checksum: 0xE2A530E4
	Offset: 0x8E08
	Size: 0x3E8
	Parameters: 0
	Flags: Linked
*/
function zombie_follow_enemy()
{
	self endon(#"death");
	self endon(#"zombie_acquire_enemy");
	self endon(#"bad_path");
	level endon(#"intermission");
	if(!isdefined(level.repathnotifierstarted))
	{
		level.repathnotifierstarted = 1;
		level thread zombie_repath_notifier();
	}
	if(!isdefined(self.zombie_repath_notify))
	{
		self.zombie_repath_notify = "zombie_repath_notify_" + (self getentitynumber() % 4);
	}
	while(true)
	{
		if(!isdefined(self._skip_pathing_first_delay))
		{
			level waittill(self.zombie_repath_notify);
		}
		else
		{
			self._skip_pathing_first_delay = undefined;
		}
		if(!(isdefined(self.ignore_enemyoverride) && self.ignore_enemyoverride) && isdefined(self.enemyoverride) && isdefined(self.enemyoverride[1]))
		{
			if(distancesquared(self.origin, self.enemyoverride[0]) > 1)
			{
				self orientmode("face motion");
			}
			else
			{
				self orientmode("face point", self.enemyoverride[1].origin);
			}
			self.ignoreall = 1;
			goalpos = self.enemyoverride[0];
			if(isdefined(level.adjust_enemyoverride_func))
			{
				goalpos = self [[level.adjust_enemyoverride_func]]();
			}
			self setgoal(goalpos);
		}
		else if(isdefined(self.favoriteenemy))
		{
			self.ignoreall = 0;
			if(isdefined(level.enemy_location_override_func))
			{
				goalpos = [[level.enemy_location_override_func]](self, self.favoriteenemy);
				if(isdefined(goalpos))
				{
					self setgoal(goalpos);
				}
				else
				{
					self zm_behavior::zombieupdategoal();
				}
			}
			else
			{
				if(isdefined(self.is_rat_test) && self.is_rat_test)
				{
				}
				else
				{
					if(zm_behavior::zombieshouldmoveawaycondition(self))
					{
						wait(0.05);
						continue;
					}
					else if(isdefined(self.favoriteenemy.last_valid_position))
					{
						self setgoal(self.favoriteenemy.last_valid_position);
					}
				}
			}
			if(!isdefined(level.ignore_path_delays))
			{
				else
				{
				}
				distsq = distancesquared(self.origin, self.favoriteenemy.origin);
				if(distsq > 10240000)
				{
					wait(2 + randomfloat(1));
				}
				else
				{
					if(distsq > 4840000)
					{
						wait(1 + randomfloat(0.5));
					}
					else if(distsq > 1440000)
					{
						wait(0.5 + randomfloat(0.5));
					}
				}
			}
		}
		if(isdefined(level.inaccesible_player_func))
		{
			self [[level.inaccessible_player_func]]();
		}
	}
}

/*
	Name: zombie_history
	Namespace: zm_spawner
	Checksum: 0xA0AB68BB
	Offset: 0x91F8
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function zombie_history(msg)
{
	/#
		if(!isdefined(self.zombie_history) || 32 <= self.zombie_history.size)
		{
			self.zombie_history = [];
		}
		self.zombie_history[self.zombie_history.size] = msg;
	#/
}

/*
	Name: do_zombie_spawn
	Namespace: zm_spawner
	Checksum: 0x7B9EE757
	Offset: 0x9258
	Size: 0x728
	Parameters: 0
	Flags: Linked
*/
function do_zombie_spawn()
{
	self endon(#"death");
	spots = [];
	if(isdefined(self._rise_spot))
	{
		spot = self._rise_spot;
		self thread do_zombie_rise(spot);
		return;
	}
	if(isdefined(level.use_multiple_spawns) && level.use_multiple_spawns && isdefined(self.script_int))
	{
		foreach(loc in level.zm_loc_types["zombie_location"])
		{
			if(!(isdefined(level.spawner_int) && level.spawner_int == self.script_int) && (!(isdefined(loc.script_int) || isdefined(level.zones[loc.zone_name].script_int))))
			{
				continue;
			}
			if(isdefined(loc.script_int) && loc.script_int != self.script_int)
			{
				continue;
			}
			else if(isdefined(level.zones[loc.zone_name].script_int) && level.zones[loc.zone_name].script_int != self.script_int)
			{
				continue;
			}
			spots[spots.size] = loc;
		}
	}
	else
	{
		spots = level.zm_loc_types["zombie_location"];
	}
	if(getdvarint("scr_zombie_spawn_in_view"))
	{
		player = getplayers()[0];
		spots = [];
		max_dot = 0;
		look_loc = undefined;
		foreach(loc in level.zm_loc_types["zombie_location"])
		{
			player_vec = vectornormalize(anglestoforward(player getplayerangles()));
			player_vec_2d = (player_vec[0], player_vec[1], 0);
			player_spawn = vectornormalize(loc.origin - player.origin);
			player_spawn_2d = (player_spawn[0], player_spawn[1], 0);
			dot = vectordot(player_vec_2d, player_spawn_2d);
			dist = distance(loc.origin, player.origin);
			if(dot > 0.707 && dist <= getdvarint("scr_zombie_spawn_in_view_dist"))
			{
				if(dot > max_dot)
				{
					look_loc = loc;
					max_dot = dot;
				}
				/#
					debugstar(loc.origin, 1000, (1, 1, 1));
				#/
			}
		}
		if(isdefined(look_loc))
		{
			spots[spots.size] = look_loc;
			/#
				debugstar(look_loc.origin, 1000, (0, 1, 0));
			#/
		}
		if(spots.size <= 0)
		{
			spots[spots.size] = level.zm_loc_types["zombie_location"][0];
			iprintln("no spawner in view");
		}
	}
	/#
		assert(spots.size > 0, "");
	#/
	if(isdefined(level.zm_custom_spawn_location_selection))
	{
		spot = [[level.zm_custom_spawn_location_selection]](spots);
	}
	else
	{
		spot = array::random(spots);
	}
	self.spawn_point = spot;
	/#
		if(getdvarint(""))
		{
			level.zones[spot.zone_name].total_spawn_count++;
			level.zones[spot.zone_name].round_spawn_count++;
			self.zone_spawned_from = spot.zone_name;
			self thread draw_zone_spawned_from();
		}
	#/
	/#
		if(isdefined(level.toggle_show_spawn_locations) && level.toggle_show_spawn_locations)
		{
			debugstar(spot.origin, getdvarint(""), (0, 1, 0));
			host_player = util::gethostplayer();
			distance = distance(spot.origin, host_player.origin);
			iprintln(("" + (distance / 12)) + "");
		}
	#/
	self thread [[level.move_spawn_func]](spot);
}

/*
	Name: draw_zone_spawned_from
	Namespace: zm_spawner
	Checksum: 0xCF13338C
	Offset: 0x9988
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function draw_zone_spawned_from()
{
	/#
		self endon(#"death");
		while(true)
		{
			print3d(self.origin + vectorscale((0, 0, 1), 64), self.zone_spawned_from, (1, 1, 1));
			wait(0.05);
		}
	#/
}

/*
	Name: do_zombie_rise
	Namespace: zm_spawner
	Checksum: 0x253E8D86
	Offset: 0x99E8
	Size: 0x446
	Parameters: 1
	Flags: Linked
*/
function do_zombie_rise(spot)
{
	self endon(#"death");
	self.in_the_ground = 1;
	if(isdefined(self.anchor))
	{
		self.anchor delete();
	}
	self.anchor = spawn("script_origin", self.origin);
	self.anchor.angles = self.angles;
	self linkto(self.anchor);
	if(!isdefined(spot.angles))
	{
		spot.angles = (0, 0, 0);
	}
	anim_org = spot.origin;
	anim_ang = spot.angles;
	anim_org = anim_org + (0, 0, 0);
	self ghost();
	self.anchor moveto(anim_org, 0.05);
	self.anchor waittill(#"movedone");
	target_org = zombie_utility::get_desired_origin();
	if(isdefined(target_org))
	{
		anim_ang = vectortoangles(target_org - self.origin);
		self.anchor rotateto((0, anim_ang[1], 0), 0.05);
		self.anchor waittill(#"rotatedone");
	}
	self unlink();
	if(isdefined(self.anchor))
	{
		self.anchor delete();
	}
	self thread zombie_utility::hide_pop();
	level thread zombie_utility::zombie_rise_death(self, spot);
	spot thread zombie_rise_fx(self);
	substate = 0;
	if(self.zombie_move_speed == "walk")
	{
		substate = randomint(2);
	}
	else
	{
		if(self.zombie_move_speed == "run")
		{
			substate = 2;
		}
		else if(self.zombie_move_speed == "sprint")
		{
			substate = 3;
		}
	}
	self orientmode("face default");
	if(isdefined(level.custom_riseanim))
	{
		self animscripted("rise_anim", self.origin, spot.angles, level.custom_riseanim);
	}
	else
	{
		if(isdefined(level.custom_rise_func))
		{
			self [[level.custom_rise_func]](spot);
		}
		else
		{
			self animscripted("rise_anim", self.origin, spot.angles, "ai_zombie_traverse_ground_climbout_fast");
		}
	}
	self zombie_shared::donotetracks("rise_anim", &zombie_utility::handle_rise_notetracks, spot);
	self notify(#"rise_anim_finished");
	spot notify(#"stop_zombie_rise_fx");
	self.in_the_ground = 0;
	self notify(#"risen", spot.script_string);
}

/*
	Name: zombie_rise_fx
	Namespace: zm_spawner
	Checksum: 0xC74592EA
	Offset: 0x9E38
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function zombie_rise_fx(zombie)
{
	if(!(isdefined(level.riser_fx_on_client) && level.riser_fx_on_client))
	{
		self thread zombie_rise_dust_fx(zombie);
		self thread zombie_rise_burst_fx(zombie);
	}
	else
	{
		self thread zombie_rise_burst_fx(zombie);
	}
	zombie endon(#"death");
	self endon(#"stop_zombie_rise_fx");
	wait(1);
	if(zombie.zombie_move_speed != "sprint")
	{
		wait(1);
	}
}

/*
	Name: zombie_rise_burst_fx
	Namespace: zm_spawner
	Checksum: 0x1700EE43
	Offset: 0x9EF8
	Size: 0x22C
	Parameters: 1
	Flags: Linked
*/
function zombie_rise_burst_fx(zombie)
{
	self endon(#"stop_zombie_rise_fx");
	self endon(#"rise_anim_finished");
	if(isdefined(self.script_parameters) && self.script_parameters == "in_water" && (!(isdefined(level._no_water_risers) && level._no_water_risers)))
	{
		zombie clientfield::set("zombie_riser_fx_water", 1);
	}
	else
	{
		if(isdefined(self.script_parameters) && self.script_parameters == "in_foliage" && (isdefined(level._foliage_risers) && level._foliage_risers))
		{
			zombie clientfield::set("zombie_riser_fx_foliage", 1);
		}
		else
		{
			if(isdefined(self.script_parameters) && self.script_parameters == "in_snow")
			{
				zombie clientfield::set("zombie_riser_fx", 1);
			}
			else
			{
				if(isdefined(zombie.zone_name) && isdefined(level.zones[zombie.zone_name]))
				{
					low_g_zones = getentarray(zombie.zone_name, "targetname");
					if(isdefined(low_g_zones[0].script_string) && low_g_zones[0].script_string == "lowgravity")
					{
						zombie clientfield::set("zombie_riser_fx_lowg", 1);
					}
					else
					{
						zombie clientfield::set("zombie_riser_fx", 1);
					}
				}
				else
				{
					zombie clientfield::set("zombie_riser_fx", 1);
				}
			}
		}
	}
}

/*
	Name: zombie_rise_dust_fx
	Namespace: zm_spawner
	Checksum: 0xEF582F9C
	Offset: 0xA130
	Size: 0x256
	Parameters: 1
	Flags: Linked
*/
function zombie_rise_dust_fx(zombie)
{
	dust_tag = "J_SpineUpper";
	self endon(#"stop_zombie_rise_dust_fx");
	self thread stop_zombie_rise_dust_fx(zombie);
	wait(2);
	dust_time = 5.5;
	dust_interval = 0.3;
	if(isdefined(self.script_parameters) && self.script_parameters == "in_water")
	{
		t = 0;
		while(t < dust_time)
		{
			playfxontag(level._effect["rise_dust_water"], zombie, dust_tag);
			wait(dust_interval);
			t = t + dust_interval;
		}
	}
	else
	{
		if(isdefined(self.script_parameters) && self.script_parameters == "in_snow")
		{
			t = 0;
			while(t < dust_time)
			{
				playfxontag(level._effect["rise_dust_snow"], zombie, dust_tag);
				wait(dust_interval);
				t = t + dust_interval;
			}
		}
		else
		{
			if(isdefined(self.script_parameters) && self.script_parameters == "in_foliage")
			{
				t = 0;
				while(t < dust_time)
				{
					playfxontag(level._effect["rise_dust_foliage"], zombie, dust_tag);
					wait(dust_interval);
					t = t + dust_interval;
				}
			}
			else
			{
				t = 0;
				while(t < dust_time)
				{
					playfxontag(level._effect["rise_dust"], zombie, dust_tag);
					wait(dust_interval);
					t = t + dust_interval;
				}
			}
		}
	}
}

/*
	Name: stop_zombie_rise_dust_fx
	Namespace: zm_spawner
	Checksum: 0xBBA038DF
	Offset: 0xA390
	Size: 0x26
	Parameters: 1
	Flags: Linked
*/
function stop_zombie_rise_dust_fx(zombie)
{
	zombie waittill(#"death");
	self notify(#"stop_zombie_rise_dust_fx");
}

/*
	Name: zombie_tesla_head_gib
	Namespace: zm_spawner
	Checksum: 0x65D65615
	Offset: 0xA3C0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function zombie_tesla_head_gib()
{
	self endon(#"death");
	if(self.animname == "quad_zombie")
	{
		return;
	}
	if(randomint(100) < level.zombie_vars["tesla_head_gib_chance"])
	{
		wait(randomfloatrange(0.53, 1));
		self zombie_utility::zombie_head_gib();
	}
	else
	{
		zm_net::network_safe_play_fx_on_tag("tesla_death_fx", 2, level._effect["tesla_shock_eyes"], self, "J_Eyeball_LE");
	}
}

/*
	Name: play_ambient_zombie_vocals
	Namespace: zm_spawner
	Checksum: 0x30BF2F57
	Offset: 0xA490
	Size: 0x1B8
	Parameters: 0
	Flags: Linked
*/
function play_ambient_zombie_vocals()
{
	self endon(#"death");
	while(true)
	{
		type = "ambient";
		float = 4;
		if(isdefined(self.zombie_move_speed))
		{
			switch(self.zombie_move_speed)
			{
				case "walk":
				{
					type = "ambient";
					float = 4;
					break;
				}
				case "run":
				{
					type = "sprint";
					float = 4;
					break;
				}
				case "sprint":
				{
					type = "sprint";
					float = 4;
					break;
				}
			}
		}
		if(self.animname == "zombie" && self.missinglegs)
		{
			type = "crawler";
		}
		else
		{
			if(self.animname == "thief_zombie" || self.animname == "leaper_zombie")
			{
				float = 1.2;
			}
			else if(self.voiceprefix == "keeper")
			{
				float = 1.2;
			}
		}
		name = self.animname;
		if(isdefined(self.sndname))
		{
			name = self.sndname;
		}
		self notify(#"bhtn_action_notify", type);
		wait(randomfloatrange(1, float));
	}
}

/*
	Name: zombie_complete_emerging_into_playable_area
	Namespace: zm_spawner
	Checksum: 0xC5FBC20F
	Offset: 0xA650
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function zombie_complete_emerging_into_playable_area()
{
	self.should_turn = 0;
	self.completed_emerging_into_playable_area = 1;
	self.no_powerups = 0;
	self notify(#"completed_emerging_into_playable_area");
	if(isdefined(self.backedupgoal))
	{
		self setgoal(self.backedupgoal);
		self.backedupgoal = undefined;
	}
	self thread zombie_free_cam_allowed();
	self thread zombie_push();
	self thread zm::update_zone_name();
}

/*
	Name: zombie_free_cam_allowed
	Namespace: zm_spawner
	Checksum: 0x33278B9C
	Offset: 0xA710
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function zombie_free_cam_allowed()
{
	self endon(#"death");
	wait(1.5);
	if(!isdefined(self))
	{
		return;
	}
	self setfreecameralockonallowed(1);
}

/*
	Name: zombie_push
	Namespace: zm_spawner
	Checksum: 0x92E4F341
	Offset: 0xA758
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function zombie_push()
{
	self endon(#"death");
	wait(5);
	if(!isdefined(self))
	{
		return;
	}
	self pushactors(1);
}

