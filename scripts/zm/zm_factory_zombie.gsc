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

#namespace zm_factory_zombie;

/*
	Name: init
	Namespace: zm_factory_zombie
	Checksum: 0x7E13F35D
	Offset: 0x300
	Size: 0x8C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initzmfactorybehaviorsandasm();
	level.zombie_init_done = &function_f06eec12;
	setdvar("scr_zm_use_code_enemy_selection", 0);
	level.closest_player_override = &factory_closest_player;
	level thread update_closest_player();
	level.move_valid_poi_to_navmesh = 1;
	level.pathdist_type = 2;
}

/*
	Name: initzmfactorybehaviorsandasm
	Namespace: zm_factory_zombie
	Checksum: 0x7BFDEC8C
	Offset: 0x398
	Size: 0x64
	Parameters: 0
	Flags: Linked, Private
*/
function private initzmfactorybehaviorsandasm()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("ZmFactoryTraversalService", &zmfactorytraversalservice);
	animationstatenetwork::registeranimationmocomp("mocomp_idle_special_factory", &mocompidlespecialfactorystart, undefined, &mocompidlespecialfactoryterminate);
}

/*
	Name: zmfactorytraversalservice
	Namespace: zm_factory_zombie
	Checksum: 0xA49E322C
	Offset: 0x408
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function zmfactorytraversalservice(entity)
{
	if(isdefined(entity.traversestartnode))
	{
		entity pushactors(0);
		return true;
	}
	return false;
}

/*
	Name: mocompidlespecialfactorystart
	Namespace: zm_factory_zombie
	Checksum: 0x31DE441A
	Offset: 0x458
	Size: 0x104
	Parameters: 5
	Flags: Linked, Private
*/
function private mocompidlespecialfactorystart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	if(isdefined(entity.enemyoverride) && isdefined(entity.enemyoverride[1]))
	{
		entity orientmode("face direction", entity.enemyoverride[1].origin - entity.origin);
		entity animmode("zonly_physics", 0);
	}
	else
	{
		entity orientmode("face current");
		entity animmode("zonly_physics", 0);
	}
}

/*
	Name: mocompidlespecialfactoryterminate
	Namespace: zm_factory_zombie
	Checksum: 0x1FD3E9E8
	Offset: 0x568
	Size: 0x2C
	Parameters: 5
	Flags: Linked, Private
*/
function private mocompidlespecialfactoryterminate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
}

/*
	Name: function_f06eec12
	Namespace: zm_factory_zombie
	Checksum: 0x6C30432E
	Offset: 0x5A0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_f06eec12()
{
	self pushactors(0);
}

/*
	Name: factory_validate_last_closest_player
	Namespace: zm_factory_zombie
	Checksum: 0xC6405D0A
	Offset: 0x5C8
	Size: 0xFA
	Parameters: 1
	Flags: Linked, Private
*/
function private factory_validate_last_closest_player(players)
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
	Name: factory_closest_player
	Namespace: zm_factory_zombie
	Checksum: 0xE248CEEF
	Offset: 0x6D0
	Size: 0x262
	Parameters: 2
	Flags: Linked, Private
*/
function private factory_closest_player(origin, players)
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
	if(!isdefined(self.need_closest_player))
	{
		self.need_closest_player = 1;
	}
	if(isdefined(level.last_closest_time) && level.last_closest_time >= level.time)
	{
		self factory_validate_last_closest_player(players);
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
	self factory_validate_last_closest_player(players);
	return self.last_closest_player;
}

/*
	Name: update_closest_player
	Namespace: zm_factory_zombie
	Checksum: 0xD4E0AD5C
	Offset: 0x940
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

