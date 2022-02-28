// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_zod;
#using scripts\zm\zm_zod_portals;
#using scripts\zm\zm_zod_vo;

#namespace zm_zod_zombie;

/*
	Name: init
	Namespace: zm_zod_zombie
	Checksum: 0x706B7615
	Offset: 0x358
	Size: 0xAC
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initzmzodbehaviorsandasm();
	level.zombie_init_done = &zod_zombie_init_done;
	setdvar("scr_zm_use_code_enemy_selection", 0);
	setdvar("tu5_zmPathDistanceCheckTolarance", 20);
	level.closest_player_override = &zod_closest_player;
	level thread update_closest_player();
	level.move_valid_poi_to_navmesh = 1;
	level.pathdist_type = 2;
}

/*
	Name: initzmzodbehaviorsandasm
	Namespace: zm_zod_zombie
	Checksum: 0xA71748A2
	Offset: 0x410
	Size: 0x5C
	Parameters: 0
	Flags: Linked, Private
*/
function private initzmzodbehaviorsandasm()
{
	animationstatenetwork::registeranimationmocomp("mocomp_teleport_traversal@zombie", &teleporttraversalmocompstart, undefined, undefined);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodShouldMove", &zodshouldmove);
}

/*
	Name: teleporttraversalmocompstart
	Namespace: zm_zod_zombie
	Checksum: 0x40247A63
	Offset: 0x478
	Size: 0x104
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
		level clientfield::increment("pulse_" + portal_trig.script_noteworthy);
		portal_trig thread zm_zod_portals::portal_teleport_ai(entity);
	}
}

/*
	Name: zodshouldmove
	Namespace: zm_zod_zombie
	Checksum: 0xC0A8F5B0
	Offset: 0x588
	Size: 0x192
	Parameters: 1
	Flags: Linked
*/
function zodshouldmove(entity)
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
		return false;
	}
	if(isdefined(entity.stumble))
	{
		return false;
	}
	if(zombiebehavior::zombieshouldmeleecondition(entity))
	{
		return false;
	}
	if(isdefined(entity.interdimensional_gun_kill) && !isdefined(entity.killby_interdimensional_gun_hole))
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
	Name: zod_zombie_init_done
	Namespace: zm_zod_zombie
	Checksum: 0xCFAB10C5
	Offset: 0x728
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function zod_zombie_init_done()
{
	self pushactors(0);
}

/*
	Name: zod_validate_last_closest_player
	Namespace: zm_zod_zombie
	Checksum: 0x47AB5626
	Offset: 0x750
	Size: 0xFA
	Parameters: 1
	Flags: Linked, Private
*/
function private zod_validate_last_closest_player(players)
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
	Name: zod_closest_player
	Namespace: zm_zod_zombie
	Checksum: 0x8502ECF4
	Offset: 0x858
	Size: 0x282
	Parameters: 2
	Flags: Linked, Private
*/
function private zod_closest_player(origin, players)
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
		self zod_validate_last_closest_player(players);
		return self.last_closest_player;
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
		self zod_validate_last_closest_player(players);
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
	self zod_validate_last_closest_player(players);
	return self.last_closest_player;
}

/*
	Name: update_closest_player
	Namespace: zm_zod_zombie
	Checksum: 0x47F0106F
	Offset: 0xAE8
	Size: 0x1EC
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
		margwa = getaiarchetypearray("margwa", level.zombie_team);
		if(margwa.size)
		{
			zombies = arraycombine(zombies, margwa, 0, 0);
		}
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

