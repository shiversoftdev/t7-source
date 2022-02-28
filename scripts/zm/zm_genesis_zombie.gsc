// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_genesis_portals;

#namespace zm_genesis_zombie;

/*
	Name: init
	Namespace: zm_genesis_zombie
	Checksum: 0x975CF94D
	Offset: 0x4E0
	Size: 0x154
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initzmgenesisbehaviorsandasm();
	setdvar("scr_zm_use_code_enemy_selection", 0);
	level.closest_player_override = &genesis_closest_player;
	level.pathdist_type = 2;
	level.custom_rise_func = &genesis_custom_rise_func;
	level.zm_custom_spawn_location_selection = &genesis_custom_spawn_location_selection;
	level.should_zigzag = &genesis_should_zigzag;
	level.validate_on_navmesh = 1;
	level thread update_closest_player();
	level thread function_68528574();
	spawner::add_archetype_spawn_function("zombie", &function_e0c0cb69);
	spawner::add_archetype_spawn_function("spider", &function_6c5e4588);
	callback::on_spawned(&function_a11812c);
	level.octobomb_targets = &genesis_octobomb_targets;
}

/*
	Name: function_68528574
	Namespace: zm_genesis_zombie
	Checksum: 0x80D35B2A
	Offset: 0x640
	Size: 0x15C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_68528574()
{
	level.var_a397a77 = [];
	level.var_a397a77[level.var_a397a77.size] = "start_island";
	level.var_a397a77[level.var_a397a77.size] = "apothicon_island";
	level.var_a397a77[level.var_a397a77.size] = "temple_island";
	level.var_a397a77[level.var_a397a77.size] = "prototype_island";
	level.var_a397a77[level.var_a397a77.size] = "asylum_island";
	level.var_a397a77[level.var_a397a77.size] = "prison_island";
	level.var_15ba7eb8 = [];
	foreach(island in level.var_a397a77)
	{
		level.var_15ba7eb8[level.var_15ba7eb8.size] = getent(island, "targetname");
	}
}

/*
	Name: initzmgenesisbehaviorsandasm
	Namespace: zm_genesis_zombie
	Checksum: 0xD7518B
	Offset: 0x7A8
	Size: 0x5C
	Parameters: 0
	Flags: Linked, Private
*/
function private initzmgenesisbehaviorsandasm()
{
	animationstatenetwork::registeranimationmocomp("mocomp_teleport_traversal@zombie", &teleporttraversalmocompstart, undefined, undefined);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldMoveLowg", &shouldmovelowg);
}

/*
	Name: shouldmovelowg
	Namespace: zm_genesis_zombie
	Checksum: 0x5CF6507E
	Offset: 0x810
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function shouldmovelowg(entity)
{
	return isdefined(entity.low_gravity) && entity.low_gravity;
}

/*
	Name: function_6c5e4588
	Namespace: zm_genesis_zombie
	Checksum: 0x8FFF20AC
	Offset: 0x848
	Size: 0x34
	Parameters: 0
	Flags: Linked, Private
*/
function private function_6c5e4588()
{
	self thread zm::update_zone_name();
	self.can_reach_enemy = &function_2f50c929;
}

/*
	Name: function_2f50c929
	Namespace: zm_genesis_zombie
	Checksum: 0xC50498B6
	Offset: 0x888
	Size: 0x8C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_2f50c929()
{
	if(isdefined(self.enemy) && isdefined(self.enemy.zone_name))
	{
		if(isdefined(self.zone_name))
		{
			var_51042e52 = self.zone_name == "apothicon_interior_zone";
			var_be94e0a7 = self.enemy.zone_name == "apothicon_interior_zone";
			if(var_51042e52 != var_be94e0a7)
			{
				return false;
			}
		}
	}
	return true;
}

/*
	Name: function_e0c0cb69
	Namespace: zm_genesis_zombie
	Checksum: 0x417969E2
	Offset: 0x920
	Size: 0x4C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_e0c0cb69()
{
	self thread function_2fa8f151();
	self thread function_bb062ca5();
	self.traversalspeedboost = &function_1108488e;
}

/*
	Name: function_a11812c
	Namespace: zm_genesis_zombie
	Checksum: 0x69B05296
	Offset: 0x978
	Size: 0x1C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_a11812c()
{
	self thread function_dc84c8cc();
}

/*
	Name: genesis_octobomb_targets
	Namespace: zm_genesis_zombie
	Checksum: 0xEA2B5116
	Offset: 0x9A0
	Size: 0x134
	Parameters: 1
	Flags: Linked, Private
*/
function private genesis_octobomb_targets(targets)
{
	zombies = getactorteamarray(level.zombie_team);
	foreach(zombie in zombies)
	{
		if(zombie.archetype == "keeper" || zombie.archetype == "apothicon_fury")
		{
			if(!isdefined(targets))
			{
				targets = [];
			}
			else if(!isarray(targets))
			{
				targets = array(targets);
			}
			targets[targets.size] = zombie;
		}
	}
	return targets;
}

/*
	Name: function_dc84c8cc
	Namespace: zm_genesis_zombie
	Checksum: 0x2EB06116
	Offset: 0xAE0
	Size: 0x250
	Parameters: 0
	Flags: Linked
*/
function function_dc84c8cc()
{
	self endon(#"death");
	self endon(#"disconnnect");
	var_c17e74e6 = gettime();
	var_eaacaebf = level.round_number;
	var_e274e0c3 = undefined;
	var_a83e7943 = 900000;
	var_320b8666 = 900000;
	var_ed78383b = 7;
	while(isdefined(self))
	{
		self.var_a3d40b8 = undefined;
		foreach(volume in level.var_15ba7eb8)
		{
			if(self istouching(volume))
			{
				var_7da7c388 = gettime() - var_c17e74e6;
				if(var_7da7c388 > var_a83e7943)
				{
					level notify(#"hash_b1d69866", self);
				}
				if(var_7da7c388 > var_320b8666)
				{
					if(var_e274e0c3 == "apothicon_island")
					{
						level notify(#"hash_8dbe1895", self);
					}
				}
				var_42215f9c = level.round_number - var_eaacaebf;
				if(var_42215f9c > var_ed78383b)
				{
					if(var_e274e0c3 == "prototype_island")
					{
						level notify(#"hash_e15c8839", self);
					}
				}
				if(isdefined(var_e274e0c3) && var_e274e0c3 != volume.targetname)
				{
					var_c17e74e6 = gettime();
					var_eaacaebf = level.round_number;
				}
				self.var_a3d40b8 = volume.targetname;
				var_e274e0c3 = self.var_a3d40b8;
				break;
			}
		}
		wait(randomfloatrange(0.5, 1));
	}
}

/*
	Name: function_2fa8f151
	Namespace: zm_genesis_zombie
	Checksum: 0x2997E025
	Offset: 0xD38
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function function_2fa8f151()
{
	self endon(#"death");
	self endon(#"disconnnect");
	while(isdefined(self))
	{
		self.var_a3d40b8 = undefined;
		foreach(volume in level.var_15ba7eb8)
		{
			if(self istouching(volume))
			{
				self.var_a3d40b8 = volume.targetname;
				break;
			}
		}
		wait(randomfloatrange(0.5, 1));
	}
}

/*
	Name: function_bb062ca5
	Namespace: zm_genesis_zombie
	Checksum: 0xDD05D293
	Offset: 0xE30
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_bb062ca5()
{
	self pushactors(0);
}

/*
	Name: function_1108488e
	Namespace: zm_genesis_zombie
	Checksum: 0xE08F991B
	Offset: 0xE58
	Size: 0xAE
	Parameters: 0
	Flags: Linked, Private
*/
function private function_1108488e()
{
	traversal = self.traversal;
	speedboost = 0;
	if(traversal.abslengthtoend > 200)
	{
		speedboost = 32;
	}
	else
	{
		if(traversal.abslengthtoend > 120)
		{
			speedboost = 16;
		}
		else if(traversal.abslengthtoend > 80 || traversal.absheighttoend > 80)
		{
			speedboost = 8;
		}
	}
	return speedboost;
}

/*
	Name: teleporttraversalmocompstart
	Namespace: zm_genesis_zombie
	Checksum: 0x38147028
	Offset: 0xF10
	Size: 0xEC
	Parameters: 5
	Flags: Linked
*/
function teleporttraversalmocompstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity.is_teleporting = 1;
	entity orientmode("face angle", entity.angles[1]);
	entity animmode("normal");
	if(isdefined(entity.traversestartnode))
	{
		portal_trig = entity.traversestartnode.portal_trig;
		if(isdefined(portal_trig))
		{
			portal_trig thread zm_genesis_portals::portal_teleport_ai(entity);
		}
	}
}

/*
	Name: function_ca420408
	Namespace: zm_genesis_zombie
	Checksum: 0xD21B0F42
	Offset: 0x1008
	Size: 0x1EE
	Parameters: 1
	Flags: Linked
*/
function function_ca420408(player)
{
	if(isdefined(self.b_ignore_cleanup) && self.b_ignore_cleanup)
	{
		return true;
	}
	if(isdefined(player.b_teleporting) && player.b_teleporting)
	{
		return false;
	}
	if(isdefined(player.var_a393601c) && player.var_a393601c)
	{
		return false;
	}
	var_bc4ca8d7 = 0;
	var_85d379f2 = 0;
	player_in_apothicon = 0;
	var_a70fdedb = 0;
	if(isdefined(player.zone_name))
	{
		if(player.zone_name == "dark_arena_zone" || player.zone_name == "dark_arena2_zone")
		{
			var_bc4ca8d7 = 1;
		}
		if(player.zone_name == "apothicon_interior_zone")
		{
			player_in_apothicon = 1;
		}
	}
	if(isdefined(self.zone_name))
	{
		if(self.zone_name == "dark_arena_zone" || self.zone_name == "dark_arena2_zone")
		{
			var_85d379f2 = 1;
		}
		if(self.zone_name == "apothicon_interior_zone")
		{
			var_a70fdedb = 1;
		}
	}
	if(var_bc4ca8d7 && !var_85d379f2)
	{
		return false;
	}
	if(!var_bc4ca8d7 && var_85d379f2)
	{
		return false;
	}
	if(player_in_apothicon && !var_a70fdedb)
	{
		return false;
	}
	if(!player_in_apothicon && var_a70fdedb)
	{
		return false;
	}
	return true;
}

/*
	Name: function_f01c3337
	Namespace: zm_genesis_zombie
	Checksum: 0xDCD59196
	Offset: 0x1200
	Size: 0x10E
	Parameters: 1
	Flags: Linked, Private
*/
function private function_f01c3337(players)
{
	if(isdefined(self.last_closest_player) && (isdefined(self.last_closest_player.am_i_valid) && self.last_closest_player.am_i_valid) && self function_ca420408(self.last_closest_player))
	{
		return;
	}
	self.need_closest_player = 1;
	foreach(player in players)
	{
		if(self function_ca420408(player))
		{
			self.last_closest_player = player;
			return;
		}
	}
	self.last_closest_player = undefined;
}

/*
	Name: genesis_custom_rise_func
	Namespace: zm_genesis_zombie
	Checksum: 0x88562F39
	Offset: 0x1318
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function genesis_custom_rise_func(s_spot)
{
	str_anim = "ai_zombie_traverse_ground_climbout_fast";
	if(isdefined(s_spot.speed))
	{
		var_a1df9af9 = array("ai_zm_dlc2_zombie_quick_rise_v1", "ai_zm_dlc2_zombie_quick_rise_v2", "ai_zm_dlc2_zombie_quick_rise_v3");
		str_anim = array::random(var_a1df9af9);
		self show();
	}
	self animscripted("rise_anim", self.origin, s_spot.angles, str_anim);
}

/*
	Name: genesis_closest_player
	Namespace: zm_genesis_zombie
	Checksum: 0x7EA00C02
	Offset: 0x13F0
	Size: 0x39A
	Parameters: 2
	Flags: Linked, Private
*/
function private genesis_closest_player(origin, players)
{
	keepers = getactorteamarray("allies");
	foreach(keeper in keepers)
	{
		if(isdefined(keeper.allow_zombie_to_target_ai) && keeper.allow_zombie_to_target_ai)
		{
			return keeper;
		}
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
		if(self function_ca420408(players[0]))
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
	if(!isdefined(self.need_closest_player))
	{
		self.need_closest_player = 1;
	}
	if(isdefined(level.last_closest_time) && level.last_closest_time >= level.time)
	{
		self function_f01c3337(players);
		return self.last_closest_player;
	}
	if(isdefined(self.need_closest_player) && self.need_closest_player)
	{
		level.last_closest_time = level.time;
		self.need_closest_player = 0;
		closest = players[0];
		closest_dist = undefined;
		if(self function_ca420408(players[0]))
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
			if(self function_ca420408(players[index]))
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
	self function_f01c3337(players);
	return self.last_closest_player;
}

/*
	Name: update_closest_player
	Namespace: zm_genesis_zombie
	Checksum: 0x783AB177
	Offset: 0x1798
	Size: 0x194
	Parameters: 0
	Flags: Linked, Private
*/
function private update_closest_player()
{
	level waittill(#"start_of_round");
	while(true)
	{
		reset_closest_player = 1;
		zombies = getactorteamarray(level.zombie_team);
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
	Name: genesis_custom_spawn_location_selection
	Namespace: zm_genesis_zombie
	Checksum: 0xC197807
	Offset: 0x1938
	Size: 0x274
	Parameters: 1
	Flags: Linked
*/
function genesis_custom_spawn_location_selection(a_spots)
{
	if(math::cointoss())
	{
		if(!isdefined(level.n_player_spawn_selection_index))
		{
			level.n_player_spawn_selection_index = 0;
		}
		e_player = level.players[level.n_player_spawn_selection_index];
		level.n_player_spawn_selection_index++;
		if(level.n_player_spawn_selection_index > (level.players.size - 1))
		{
			level.n_player_spawn_selection_index = 0;
		}
		if(!zm_utility::is_player_valid(e_player))
		{
			s_spot = array::random(a_spots);
			return s_spot;
		}
		var_e8c67fc0 = array::get_all_closest(e_player.origin, a_spots, undefined, 5);
		var_b008ef9a = [];
		v_player_dir = anglestoforward(e_player.angles);
		for(i = 0; i < var_e8c67fc0.size; i++)
		{
			v_dir = var_e8c67fc0[i].origin - e_player.origin;
			n_dp = vectordot(v_player_dir, v_dir);
			if(n_dp >= 0)
			{
				var_b008ef9a[var_b008ef9a.size] = var_e8c67fc0[i];
			}
		}
		if(var_b008ef9a.size)
		{
			s_spot = array::random(var_b008ef9a);
		}
		else
		{
			if(var_e8c67fc0.size)
			{
				s_spot = array::random(var_e8c67fc0);
			}
			else
			{
				s_spot = array::random(a_spots);
			}
		}
	}
	else
	{
		s_spot = array::random(a_spots);
	}
	return s_spot;
}

/*
	Name: genesis_should_zigzag
	Namespace: zm_genesis_zombie
	Checksum: 0xEF703AE
	Offset: 0x1BB8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function genesis_should_zigzag()
{
	if(isdefined(self.var_b6b1080c) && self.var_b6b1080c)
	{
		return false;
	}
	if(isdefined(self.var_a3d40b8))
	{
		player = self.favoriteenemy;
		if(isdefined(player) && isdefined(player.var_a3d40b8))
		{
			if(self.var_a3d40b8 != player.var_a3d40b8)
			{
				return false;
			}
		}
	}
	return true;
}

/*
	Name: set_gravity
	Namespace: zm_genesis_zombie
	Checksum: 0x66425383
	Offset: 0x1C40
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function set_gravity(gravity)
{
	if(gravity == "low")
	{
		self.low_gravity = 1;
		if(isdefined(self.missinglegs) && self.missinglegs)
		{
			self.low_gravity_variant = randomint(level.var_4fb25bb9["crawl"]);
		}
		else
		{
			self.low_gravity_variant = randomint(level.var_4fb25bb9[self.zombie_move_speed]);
		}
	}
	else if(gravity == "normal")
	{
		self.low_gravity = 0;
	}
}

