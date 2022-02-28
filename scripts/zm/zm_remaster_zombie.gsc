// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace zm_remaster_zombie;

/*
	Name: init
	Namespace: zm_remaster_zombie
	Checksum: 0x51794904
	Offset: 0x3F0
	Size: 0x64
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initzmbehaviorsandasm();
	setdvar("tu5_zmPathDistanceCheckTolarance", 20);
	setdvar("scr_zm_use_code_enemy_selection", 0);
	level.move_valid_poi_to_navmesh = 1;
	level.pathdist_type = 2;
}

/*
	Name: initzmbehaviorsandasm
	Namespace: zm_remaster_zombie
	Checksum: 0x192DB3C2
	Offset: 0x460
	Size: 0x84
	Parameters: 0
	Flags: Linked, Private
*/
function private initzmbehaviorsandasm()
{
	animationstatenetwork::registeranimationmocomp("mocomp_teleport_traversal@zombie", &teleporttraversalmocompstart, undefined, undefined);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodShouldMove", &shouldmove);
	spawner::add_archetype_spawn_function("zombie", &function_9fb7c76f);
}

/*
	Name: teleporttraversalmocompstart
	Namespace: zm_remaster_zombie
	Checksum: 0x304ADC98
	Offset: 0x4F0
	Size: 0x19C
	Parameters: 5
	Flags: Linked
*/
function teleporttraversalmocompstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity orientmode("face angle", entity.angles[1]);
	entity animmode("normal");
	if(isdefined(entity.traverseendnode))
	{
		/#
			print3d(entity.traversestartnode.origin, "", (1, 0, 0), 1, 1, 60);
			print3d(entity.traverseendnode.origin, "", (0, 1, 0), 1, 1, 60);
			line(entity.traversestartnode.origin, entity.traverseendnode.origin, (0, 1, 0), 1, 0, 60);
		#/
		entity forceteleport(entity.traverseendnode.origin, entity.traverseendnode.angles, 0);
	}
}

/*
	Name: shouldmove
	Namespace: zm_remaster_zombie
	Checksum: 0xDB831DFD
	Offset: 0x698
	Size: 0x18A
	Parameters: 1
	Flags: Linked
*/
function shouldmove(entity)
{
	if(isdefined(entity.zombie_tesla_hit) && entity.zombie_tesla_hit && (!(isdefined(entity.tesla_death) && entity.tesla_death)))
	{
		return false;
	}
	if(isdefined(entity.pushed) && entity.pushed)
	{
		return false;
	}
	if(isdefined(entity.knockdown) && entity.knockdown)
	{
		return false;
	}
	if(isdefined(entity.grapple_is_fatal) && entity.grapple_is_fatal)
	{
		return false;
	}
	if(level.wait_and_revive)
	{
		if(!(isdefined(entity.var_1e3fb1c) && entity.var_1e3fb1c))
		{
			return false;
		}
	}
	if(isdefined(entity.stumble))
	{
		return false;
	}
	if(zombiebehavior::zombieshouldmeleecondition(entity))
	{
		return false;
	}
	if(entity haspath())
	{
		return true;
	}
	if(isdefined(entity.keep_moving) && entity.keep_moving)
	{
		return true;
	}
	return false;
}

/*
	Name: function_9fb7c76f
	Namespace: zm_remaster_zombie
	Checksum: 0xE13E6074
	Offset: 0x830
	Size: 0x1C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_9fb7c76f()
{
	self.cant_move_cb = &function_f05a4eb4;
}

/*
	Name: function_f05a4eb4
	Namespace: zm_remaster_zombie
	Checksum: 0x6CBA3491
	Offset: 0x858
	Size: 0x2C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_f05a4eb4()
{
	self pushactors(0);
	self.enablepushtime = gettime() + 1000;
}

/*
	Name: remaster_validate_last_closest_player
	Namespace: zm_remaster_zombie
	Checksum: 0x688943FF
	Offset: 0x890
	Size: 0xFA
	Parameters: 1
	Flags: Linked, Private
*/
function private remaster_validate_last_closest_player(players)
{
	if(isdefined(self.last_closest_player) && (isdefined(self.last_closest_player.am_i_valid) && self.last_closest_player.am_i_valid))
	{
		return;
	}
	self.need_closest_player = 1;
	foreach(player in players)
	{
		if(isdefined(player.am_i_valid) && player.am_i_valid)
		{
			self.last_closest_player = player;
			return;
		}
	}
	self.last_closest_player = undefined;
}

/*
	Name: remaster_closest_player
	Namespace: zm_remaster_zombie
	Checksum: 0x5F28E87F
	Offset: 0x998
	Size: 0x27A
	Parameters: 2
	Flags: Linked
*/
function remaster_closest_player(origin, players)
{
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
		self.last_closest_player = players[0];
		return self.last_closest_player;
	}
	if(!isdefined(self.last_closest_player))
	{
		self.last_closest_player = players[0];
	}
	if(isdefined(self.v_zombie_custom_goal_pos))
	{
		return self.last_closest_player;
	}
	if(!isdefined(self.need_closest_player))
	{
		self.need_closest_player = 1;
	}
	if(isdefined(level.last_closest_time) && level.last_closest_time >= level.time)
	{
		self remaster_validate_last_closest_player(players);
		return self.last_closest_player;
	}
	if(isdefined(self.need_closest_player) && self.need_closest_player)
	{
		level.last_closest_time = level.time;
		self.need_closest_player = 0;
		closest = players[0];
		closest_dist = self zm_utility::approximate_path_dist(closest);
		if(!isdefined(closest_dist))
		{
			closest = undefined;
		}
		for(index = 1; index < players.size; index++)
		{
			dist = self zm_utility::approximate_path_dist(players[index]);
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
	self remaster_validate_last_closest_player(players);
	return self.last_closest_player;
}

/*
	Name: update_closest_player
	Namespace: zm_remaster_zombie
	Checksum: 0xF9C34E28
	Offset: 0xC20
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function update_closest_player()
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

