// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_spawn_manager_debug;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\name_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace spawn_manager;

/*
	Name: __init__sytem__
	Namespace: spawn_manager
	Checksum: 0x27FC78A0
	Offset: 0x298
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("spawn_manager", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: spawn_manager
	Checksum: 0xA1862027
	Offset: 0x2D8
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.spawn_manager_total_count = 0;
	level.spawn_manager_max_ai = 50;
	level.spawn_manager_active_ai = 0;
	level.spawn_manager_auto_targetname_num = 0;
	level.spawn_managers = [];
	level.spawn_managers = getentarray("spawn_manager", "classname");
	array::thread_all(level.spawn_managers, &spawn_manager_think);
	start_triggers();
	/#
		callback::on_connect(&on_player_connect);
		level thread spawn_manager_debug();
	#/
}

/*
	Name: spawn_manager_setup
	Namespace: spawn_manager
	Checksum: 0x5B25470F
	Offset: 0x3C8
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_setup()
{
	/#
		assert(isdefined(self));
	#/
	/#
		assert(isdefined(self.target));
	#/
	/#
		assert(self.sm_group_size_max >= self.sm_group_size_min, "" + self.sm_id);
	#/
	if(!isdefined(self.sm_spawner_count_min) || self.sm_spawner_count_min > self.allspawners.size)
	{
		self.sm_spawner_count_min = self.allspawners.size;
	}
	if(!isdefined(self.sm_spawner_count_max) || self.sm_spawner_count_max > self.allspawners.size)
	{
		self.sm_spawner_count_max = self.allspawners.size;
	}
	/#
		assert(self.sm_spawner_count_max >= self.sm_spawner_count_min, "" + self.sm_id);
	#/
	self.sm_spawner_count = randomintrange(self.sm_spawner_count_min, self.sm_spawner_count_max + 1);
	self.spawners = self spawn_manager_get_spawners();
	update_for_coop();
	/#
		assert(self.sm_group_size_min <= self.sm_active_count_max, "");
	#/
	if(!isdefined(self.script_forcespawn))
	{
		self.script_forcespawn = 0;
	}
}

/*
	Name: spawn_manager_can_spawn
	Namespace: spawn_manager
	Checksum: 0xBEAF2174
	Offset: 0x598
	Size: 0x162
	Parameters: 1
	Flags: Linked
*/
function spawn_manager_can_spawn(spawngroupsize)
{
	totalfree = (self.count >= 0 ? self.count : level.spawn_manager_max_ai);
	activefree = self.sm_active_count_max - self.activeai.size;
	canspawngroup = activefree >= spawngroupsize && totalfree >= spawngroupsize && spawngroupsize > 0;
	globalfree = level.spawn_manager_max_ai - level.spawn_manager_active_ai;
	/#
		assert(self.enable == (level flag::get(("" + self.sm_id) + "")), "");
	#/
	if(self.script_forcespawn == 0)
	{
		return totalfree > 0 && activefree > 0 && globalfree > 0 && canspawngroup && self.enable;
	}
	return totalfree > 0 && activefree > 0 && self.enable;
}

/*
	Name: spawn_manager_spawn
	Namespace: spawn_manager
	Checksum: 0xBB9533CA
	Offset: 0x708
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function spawn_manager_spawn(maxdelay)
{
	self endon(#"death");
	start = gettime();
	while(true)
	{
		ai = self spawner::spawn();
		if(isdefined(ai) || (gettime() - start) > (1000 * maxdelay))
		{
			return ai;
		}
		wait(0.5);
	}
}

/*
	Name: spawn_manager_spawn_group
	Namespace: spawn_manager
	Checksum: 0x618CC10
	Offset: 0x798
	Size: 0x136
	Parameters: 2
	Flags: Linked
*/
function spawn_manager_spawn_group(spawner, spawngroupsize)
{
	for(i = 0; i < spawngroupsize; i++)
	{
		ai = undefined;
		if(isdefined(spawner) && isdefined(spawner.targetname))
		{
			ai = spawner spawn_manager_spawn(2);
			if(isdefined(ai))
			{
				ai.sm_id = self.sm_id;
			}
		}
		else
		{
			continue;
		}
		if(!spawner::spawn_failed(ai))
		{
			if(isdefined(self.script_radius))
			{
				ai.script_radius = self.script_radius;
			}
			if(isdefined(spawner.script_radius))
			{
				ai.script_radius = spawner.script_radius;
			}
			ai thread spawn_accounting(spawner, self);
		}
	}
}

/*
	Name: spawn_accounting
	Namespace: spawn_manager
	Checksum: 0xF4AAB3FB
	Offset: 0x8D8
	Size: 0x15C
	Parameters: 2
	Flags: Linked
*/
function spawn_accounting(spawner, manager)
{
	targetname = manager.targetname;
	classname = spawner.classname;
	level.spawn_manager_total_count++;
	manager.spawncount++;
	if(manager.count > 0)
	{
		manager.count--;
	}
	level.spawn_manager_active_ai++;
	origin = spawner.origin;
	manager.activeai[manager.activeai.size] = self;
	spawner.activeai[spawner.activeai.size] = self;
	self waittill(#"death");
	if(isdefined(spawner))
	{
		arrayremovevalue(spawner.activeai, self);
	}
	if(isdefined(manager))
	{
		arrayremovevalue(manager.activeai, self);
	}
	level.spawn_manager_active_ai--;
}

/*
	Name: set_defaults
	Namespace: spawn_manager
	Checksum: 0xB2E51FDD
	Offset: 0xA40
	Size: 0x198
	Parameters: 0
	Flags: Linked
*/
function set_defaults()
{
	if(isdefined(self.name))
	{
		/#
			check_name(self.name);
		#/
		self.sm_id = self.name;
	}
	else
	{
		if(isdefined(self.targetname) && !strstartswith(self.targetname, "pf"))
		{
			/#
				check_name(self.targetname);
			#/
			self.sm_id = self.targetname;
		}
		else
		{
			auto_id();
		}
	}
	if(!isdefined(self.sm_count_1player))
	{
		self.sm_count_1player = self.count;
	}
	if(!isdefined(self.sm_active_count_min_1player))
	{
		self.sm_active_count_min_1player = (isdefined(self.sm_active_count_min) ? self.sm_active_count_min : level.spawn_manager_max_ai);
	}
	if(!isdefined(self.sm_active_count_max_1player))
	{
		self.sm_active_count_max_1player = (isdefined(self.sm_active_count_max) ? self.sm_active_count_max : level.spawn_manager_max_ai);
	}
	if(!isdefined(self.sm_group_size_min_1player))
	{
		self.sm_group_size_min_1player = (isdefined(self.sm_group_size_min) ? self.sm_group_size_min : 1);
	}
	if(!isdefined(self.sm_group_size_max_1player))
	{
		self.sm_group_size_max_1player = (isdefined(self.sm_group_size_max) ? self.sm_group_size_max : 1);
	}
}

/*
	Name: check_name
	Namespace: spawn_manager
	Checksum: 0x617D5545
	Offset: 0xBE0
	Size: 0x13A
	Parameters: 1
	Flags: Linked
*/
function check_name(str_name)
{
	/#
		a_spawn_managers = getentarray("", "");
		foreach(sm in a_spawn_managers)
		{
			if(sm != self)
			{
				if(sm.targetname === str_name || sm.name === str_name)
				{
					/#
						assertmsg((((("" + str_name) + "") + self.origin) + "") + sm.origin);
					#/
				}
			}
		}
	#/
}

/*
	Name: auto_id
	Namespace: spawn_manager
	Checksum: 0x36173650
	Offset: 0xD28
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function auto_id()
{
	if(!isdefined(level.sm_auto_id))
	{
		level.sm_auto_id = 0;
	}
	self.sm_id = "sm_auto" + level.sm_auto_id;
	level.sm_auto_id++;
}

/*
	Name: update_count_for_coop
	Namespace: spawn_manager
	Checksum: 0x4F2B672
	Offset: 0xD70
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function update_count_for_coop()
{
	if(level.players.size >= 4 && isdefined(self.sm_count_4player))
	{
		n_count = self.sm_count_4player;
	}
	else
	{
		if(level.players.size >= 3 && isdefined(self.sm_count_3player))
		{
			n_count = self.sm_count_3player;
		}
		else
		{
			if(level.players.size >= 2 && isdefined(self.sm_count_2player))
			{
				n_count = self.sm_count_2player;
			}
			else
			{
				n_count = self.sm_count_1player;
			}
		}
	}
	if(n_count > 0)
	{
		self.count = n_count;
	}
	else
	{
		self.count = -1;
	}
}

/*
	Name: update_active_count_min_for_coop
	Namespace: spawn_manager
	Checksum: 0x91F6D51C
	Offset: 0xE48
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function update_active_count_min_for_coop()
{
	if(level.players.size >= 4 && isdefined(self.sm_active_count_min_4player))
	{
		self.sm_active_count_min = self.sm_active_count_min_4player;
	}
	else
	{
		if(level.players.size >= 3 && isdefined(self.sm_active_count_min_3player))
		{
			self.sm_active_count_min = self.sm_active_count_min_3player;
		}
		else
		{
			if(level.players.size >= 2 && isdefined(self.sm_active_count_min_2player))
			{
				self.sm_active_count_min = self.sm_active_count_min_2player;
			}
			else
			{
				self.sm_active_count_min = self.sm_active_count_min_1player;
			}
		}
	}
}

/*
	Name: update_active_count_max_for_coop
	Namespace: spawn_manager
	Checksum: 0x6462833A
	Offset: 0xF00
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function update_active_count_max_for_coop()
{
	if(level.players.size >= 4 && isdefined(self.sm_active_count_max_4player))
	{
		self.sm_active_count_max = self.sm_active_count_max_4player;
	}
	else
	{
		if(level.players.size >= 3 && isdefined(self.sm_active_count_max_3player))
		{
			self.sm_active_count_max = self.sm_active_count_max_3player;
		}
		else
		{
			if(level.players.size >= 2 && isdefined(self.sm_active_count_max_2player))
			{
				self.sm_active_count_max = self.sm_active_count_max_2player;
			}
			else
			{
				self.sm_active_count_max = self.sm_active_count_max_1player;
			}
		}
	}
}

/*
	Name: update_group_size_min_for_coop
	Namespace: spawn_manager
	Checksum: 0x945F929C
	Offset: 0xFB8
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function update_group_size_min_for_coop()
{
	if(level.players.size >= 4 && isdefined(self.sm_group_size_min_4player))
	{
		self.sm_group_size_min = self.sm_group_size_min_4player;
	}
	else
	{
		if(level.players.size >= 3 && isdefined(self.sm_group_size_min_3player))
		{
			self.sm_group_size_min = self.sm_group_size_min_3player;
		}
		else
		{
			if(level.players.size >= 2 && isdefined(self.sm_group_size_min_2player))
			{
				self.sm_group_size_min = self.sm_group_size_min_2player;
			}
			else
			{
				self.sm_group_size_min = self.sm_group_size_min_1player;
			}
		}
	}
}

/*
	Name: update_group_size_max_for_coop
	Namespace: spawn_manager
	Checksum: 0x91B5F4FA
	Offset: 0x1070
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function update_group_size_max_for_coop()
{
	if(level.players.size >= 4 && isdefined(self.sm_group_size_max_4player))
	{
		self.sm_group_size_max = self.sm_group_size_max_4player;
	}
	else
	{
		if(level.players.size >= 3 && isdefined(self.sm_group_size_max_3player))
		{
			self.sm_group_size_max = self.sm_group_size_max_3player;
		}
		else
		{
			if(level.players.size >= 2 && isdefined(self.sm_group_size_max_2player))
			{
				self.sm_group_size_max = self.sm_group_size_max_2player;
			}
			else
			{
				self.sm_group_size_max = self.sm_group_size_max_1player;
			}
		}
	}
}

/*
	Name: update_for_coop
	Namespace: spawn_manager
	Checksum: 0xDC1046D0
	Offset: 0x1128
	Size: 0x10A
	Parameters: 0
	Flags: Linked
*/
function update_for_coop()
{
	update_count_for_coop();
	update_active_count_min_for_coop();
	update_active_count_max_for_coop();
	update_group_size_min_for_coop();
	update_group_size_max_for_coop();
	foreach(sp in self.spawners)
	{
		sp update_count_for_coop();
		sp update_active_count_min_for_coop();
		sp update_active_count_max_for_coop();
	}
}

/*
	Name: spawn_manager_wave_wait
	Namespace: spawn_manager
	Checksum: 0x2D2A4116
	Offset: 0x1240
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_wave_wait()
{
	if(!isdefined(self.sm_wave_wait_min))
	{
		self.sm_wave_wait_min = 0;
	}
	if(!isdefined(self.sm_wave_wait_max))
	{
		self.sm_wave_wait_max = 0;
	}
	if(self.sm_wave_wait_max > 0 && self.sm_wave_wait_max > self.sm_wave_wait_min)
	{
		wait(randomfloatrange(self.sm_wave_wait_min, self.sm_wave_wait_max));
	}
	else if(self.sm_wave_wait_min > 0)
	{
		wait(self.sm_wave_wait_min);
	}
}

/*
	Name: spawn_manager_think
	Namespace: spawn_manager
	Checksum: 0x75A9EA4A
	Offset: 0x12E0
	Size: 0x7C4
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_think()
{
	self endon(#"death");
	self set_defaults();
	self spawn_manager_flags_setup();
	self thread spawn_manager_enable_think();
	self thread spawn_manager_kill_think();
	self.enable = 0;
	self.activeai = [];
	self.spawncount = 0;
	isfirsttime = 1;
	self.allspawners = getentarray(self.target, "targetname");
	/#
		assert(self.allspawners.size, ("" + self.sm_id) + "");
	#/
	level flag::wait_till(("sm_" + self.sm_id) + "_enabled");
	util::script_delay();
	self spawn_manager_setup();
	b_spawn_up = 1;
	self spawn_manager_get_spawn_group_size();
	while(self.count != 0 && self.spawners.size > 0)
	{
		cleanup_spawners();
		n_active = self.activeai.size;
		n_active_budget = self.sm_active_count_max - n_active;
		if(!b_spawn_up && self.activeai.size <= self.sm_active_count_min)
		{
			b_spawn_up = 1;
			spawn_manager_wave_wait();
		}
		else if(b_spawn_up && n_active_budget < self.sm_group_size)
		{
			b_spawn_up = 0;
		}
		if(!b_spawn_up)
		{
			wait(0.05);
			continue;
		}
		self spawn_manager_get_spawn_group_size();
		if(self.count > 0)
		{
			if(self.sm_group_size > self.count)
			{
				self.sm_group_size = self.count;
			}
		}
		spawned = 0;
		while(!spawned)
		{
			cleanup_spawners();
			if(self.spawners.size <= 0)
			{
				break;
			}
			if(self spawn_manager_can_spawn(self.sm_group_size))
			{
				/#
					assert(self.sm_group_size > 0);
				#/
				potential_spawners = [];
				priority_spawners = [];
				for(i = 0; i < self.spawners.size; i++)
				{
					current_spawner = self.spawners[i];
					if(isdefined(current_spawner))
					{
						if(current_spawner.activeai.size > current_spawner.sm_active_count_min)
						{
							continue;
						}
						spawnerfree = current_spawner.sm_active_count_max - current_spawner.activeai.size;
						if(spawnerfree >= self.sm_group_size)
						{
							if(isdefined(current_spawner.spawnflags) && (current_spawner.spawnflags & 32) == 32)
							{
								priority_spawners[priority_spawners.size] = current_spawner;
								continue;
							}
							potential_spawners[potential_spawners.size] = current_spawner;
						}
					}
				}
				if(potential_spawners.size > 0 || priority_spawners.size > 0)
				{
					if(priority_spawners.size > 0)
					{
						spawner = array::random(priority_spawners);
					}
					else
					{
						spawner = array::random(potential_spawners);
					}
					if(!(isdefined(spawner.spawnflags) && (spawner.spawnflags & 64) == 64) && spawner.count < self.sm_group_size)
					{
						self.sm_group_size = spawner.count;
					}
					if(!isfirsttime)
					{
						spawn_manager_wait();
					}
					else
					{
						isfirsttime = 0;
					}
					if(!self.enable)
					{
						continue;
					}
					self spawn_manager_spawn_group(spawner, self.sm_group_size);
					spawned = 1;
				}
				else
				{
					spawner_max_active_count = 0;
					for(i = 0; i < self.spawners.size; i++)
					{
						current_spawner = self.spawners[i];
						if(isdefined(current_spawner))
						{
							if(current_spawner.sm_active_count_max > spawner_max_active_count)
							{
								spawner_max_active_count = current_spawner.sm_active_count_max;
							}
						}
					}
					if(spawner_max_active_count < self.sm_group_size_max)
					{
						self.sm_group_size_max = spawner_max_active_count;
						self spawn_manager_get_spawn_group_size();
					}
				}
			}
			wait(0.05);
		}
		wait(0.05);
		/#
			assert(!level flag::get(("" + self.sm_id) + ""), "");
		#/
		/#
			assert(!level flag::get(("" + self.sm_id) + ""), "");
		#/
		if(!(isdefined(self.script_forcespawn) && self.script_forcespawn))
		{
			numplayers = max(getplayers().size, 1);
			wait((laststand::player_num_in_laststand() / numplayers) * 8);
		}
	}
	self spawn_manager_flag_complete();
	if(isdefined(self.activeai) && self.activeai.size != 0)
	{
		array::wait_till(self.activeai, "death");
	}
	self delete();
}

/*
	Name: spawn_manager_enable_think
	Namespace: spawn_manager
	Checksum: 0x2BAB9B2A
	Offset: 0x1AB0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_enable_think()
{
	while(isdefined(self))
	{
		self waittill(#"enable");
		self.enable = 1;
		self spawn_manager_flag_enabled();
		self waittill(#"disable");
		self spawn_manager_flag_disabled();
	}
	self spawn_manager_flag_disabled();
}

/*
	Name: spawn_manager_enable_trigger_think
	Namespace: spawn_manager
	Checksum: 0x3B531811
	Offset: 0x1B30
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function spawn_manager_enable_trigger_think(spawn_manager)
{
	spawn_manager endon(#"death");
	spawn_manager endon(#"enable");
	self endon(#"death");
	self waittill(#"trigger");
	spawn_manager notify(#"enable");
}

/*
	Name: spawn_manager_kill_think
	Namespace: spawn_manager
	Checksum: 0xC2687FC9
	Offset: 0x1B88
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_kill_think()
{
	self waittill(#"death");
	sm_id = self.sm_id;
	a_spawners = self.allspawners;
	a_active_ai = self.activeai;
	level flag::clear(("sm_" + sm_id) + "_enabled");
	level flag::set(("sm_" + sm_id) + "_killed");
	level flag::set(("sm_" + sm_id) + "_complete");
	array::delete_all(a_spawners);
	if(a_active_ai.size)
	{
		array::wait_till(a_active_ai, "death");
	}
	level flag::set(("sm_" + sm_id) + "_cleared");
	level.spawn_managers = array::remove_undefined(level.spawn_managers);
}

/*
	Name: start_triggers
	Namespace: spawn_manager
	Checksum: 0x1266C6DE
	Offset: 0x1CE0
	Size: 0x198
	Parameters: 1
	Flags: Linked
*/
function start_triggers(trigger_type)
{
	triggers = trigger::get_all("trigger_multiple", "trigger_once", "trigger_use", "trigger_radius", "trigger_lookat", "trigger_damage", "trigger_box");
	foreach(trig in triggers)
	{
		if(isdefined(trig.target))
		{
			targets = get_spawn_manager_array(trig.target);
			foreach(target in targets)
			{
				trig thread spawn_manager_enable_trigger_think(target);
			}
		}
	}
}

/*
	Name: get_spawn_manager_array
	Namespace: spawn_manager
	Checksum: 0x12118E47
	Offset: 0x1E80
	Size: 0x11E
	Parameters: 1
	Flags: Linked
*/
function get_spawn_manager_array(targetname)
{
	if(isdefined(targetname))
	{
		spawn_manager_array = [];
		for(i = 0; i < level.spawn_managers.size; i++)
		{
			if(isdefined(level.spawn_managers[i]))
			{
				if(level.spawn_managers[i].targetname === targetname || level.spawn_managers[i].name === targetname)
				{
					if(!isdefined(spawn_manager_array))
					{
						spawn_manager_array = [];
					}
					else if(!isarray(spawn_manager_array))
					{
						spawn_manager_array = array(spawn_manager_array);
					}
					spawn_manager_array[spawn_manager_array.size] = level.spawn_managers[i];
				}
			}
		}
		return spawn_manager_array;
	}
	return level.spawn_managers;
}

/*
	Name: spawn_manager_get_spawners
	Namespace: spawn_manager
	Checksum: 0x751CBD0F
	Offset: 0x1FA8
	Size: 0x38C
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_get_spawners()
{
	arrayremovevalue(self.allspawners, undefined);
	exclude = [];
	for(i = 0; i < self.allspawners.size; i++)
	{
		if(isdefined(level._gamemode_norandomdogs) && self.allspawners[i].classname == "actor_enemy_dog_sp")
		{
			if(!isdefined(exclude))
			{
				exclude = [];
			}
			else if(!isarray(exclude))
			{
				exclude = array(exclude);
			}
			exclude[exclude.size] = self.allspawners[i];
		}
	}
	self.allspawners = array::exclude(self.allspawners, exclude);
	spawner_count_with_max_active = 0;
	foreach(sp in self.allspawners)
	{
		if(!isdefined(sp.sm_count_1player))
		{
			sp.sm_count_1player = sp.count;
		}
		if(!isdefined(sp.sm_active_count_max_1player))
		{
			sp.sm_active_count_max_1player = (isdefined(sp.sm_active_count_max) ? sp.sm_active_count_max : level.spawn_manager_max_ai);
		}
		if(!isdefined(sp.sm_active_count_min_1player))
		{
			sp.sm_active_count_min_1player = (isdefined(sp.sm_active_count_min) ? sp.sm_active_count_min : sp.sm_active_count_max_1player);
		}
		sp.activeai = [];
	}
	groupspawners = arraycopy(self.allspawners);
	spawner_count = self.sm_spawner_count;
	if(spawner_count > self.allspawners.size)
	{
		spawner_count = self.allspawners.size;
	}
	spawners = [];
	while(spawners.size < spawner_count)
	{
		spawner = array::random(groupspawners);
		if(!isdefined(spawners))
		{
			spawners = [];
		}
		else if(!isarray(spawners))
		{
			spawners = array(spawners);
		}
		spawners[spawners.size] = spawner;
		arrayremovevalue(groupspawners, spawner);
	}
	return spawners;
}

/*
	Name: spawn_manager_get_spawn_group_size
	Namespace: spawn_manager
	Checksum: 0xE70357D4
	Offset: 0x2340
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_get_spawn_group_size()
{
	if(self.sm_group_size_min < self.sm_group_size_max)
	{
		self.sm_group_size = randomintrange(self.sm_group_size_min, self.sm_group_size_max + 1);
	}
	else
	{
		self.sm_group_size = self.sm_group_size_min;
	}
	return self.sm_group_size;
}

/*
	Name: cleanup_spawners
	Namespace: spawn_manager
	Checksum: 0x77A52018
	Offset: 0x23A8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function cleanup_spawners()
{
	spawners = [];
	for(i = 0; i < self.spawners.size; i++)
	{
		if(isdefined(self.spawners[i]))
		{
			if(self.spawners[i].count != 0)
			{
				spawners[spawners.size] = self.spawners[i];
				continue;
			}
			self.spawners[i] delete();
		}
	}
	self.spawners = spawners;
}

/*
	Name: spawn_manager_wait
	Namespace: spawn_manager
	Checksum: 0x4EDB3063
	Offset: 0x2478
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_wait()
{
	if(isdefined(self.script_wait))
	{
		wait(self.script_wait);
		if(isdefined(self.script_wait_add))
		{
			self.script_wait = self.script_wait + self.script_wait_add;
		}
	}
	else if(isdefined(self.script_wait_min) && isdefined(self.script_wait_max))
	{
		coop_scalar = 1;
		players = getplayers();
		if(players.size == 2)
		{
			coop_scalar = 0.7;
		}
		else
		{
			if(players.size == 3)
			{
				coop_scalar = 0.5;
			}
			else if(players.size == 4)
			{
				coop_scalar = 0.3;
			}
		}
		diff = self.script_wait_max - self.script_wait_min;
		if(abs(diff) > 0)
		{
			wait(randomfloatrange(self.script_wait_min, self.script_wait_min + (diff * coop_scalar)));
		}
		else
		{
			wait(self.script_wait_min);
		}
		if(isdefined(self.script_wait_add))
		{
			self.script_wait_min = self.script_wait_min + self.script_wait_add;
			self.script_wait_max = self.script_wait_max + self.script_wait_add;
		}
	}
}

/*
	Name: spawn_manager_flags_setup
	Namespace: spawn_manager
	Checksum: 0x47CE8276
	Offset: 0x2618
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_flags_setup()
{
	level flag::init(("sm_" + self.sm_id) + "_enabled");
	level flag::init(("sm_" + self.sm_id) + "_complete");
	level flag::init(("sm_" + self.sm_id) + "_killed");
	level flag::init(("sm_" + self.sm_id) + "_cleared");
}

/*
	Name: spawn_manager_flag_enabled
	Namespace: spawn_manager
	Checksum: 0xD66492A6
	Offset: 0x26E8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_flag_enabled()
{
	/#
		assert(!level flag::get(("" + self.sm_id) + ""), "");
	#/
	level flag::set(("sm_" + self.sm_id) + "_enabled");
}

/*
	Name: spawn_manager_flag_disabled
	Namespace: spawn_manager
	Checksum: 0xBCCC0114
	Offset: 0x2770
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_flag_disabled()
{
	self.enable = 0;
	level flag::clear(("sm_" + self.sm_id) + "_enabled");
}

/*
	Name: spawn_manager_flag_killed
	Namespace: spawn_manager
	Checksum: 0x15DAA95C
	Offset: 0x27B8
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function spawn_manager_flag_killed()
{
	/#
		assert(!level flag::get(("" + self.sm_id) + ""), "");
	#/
	level flag::set(("sm_" + self.sm_id) + "_killed");
}

/*
	Name: spawn_manager_flag_complete
	Namespace: spawn_manager
	Checksum: 0xCD78F4A9
	Offset: 0x2840
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_flag_complete()
{
	/#
		assert(!level flag::get(("" + self.sm_id) + ""), "");
	#/
	level flag::set(("sm_" + self.sm_id) + "_complete");
}

/*
	Name: spawn_manager_flag_cleared
	Namespace: spawn_manager
	Checksum: 0xA0247FC5
	Offset: 0x28C8
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function spawn_manager_flag_cleared()
{
	/#
		assert(!level flag::get(("" + self.sm_id) + ""), "");
	#/
	level flag::set(("sm_" + self.sm_id) + "_cleared");
}

/*
	Name: set_global_active_count
	Namespace: spawn_manager
	Checksum: 0x646173E4
	Offset: 0x2950
	Size: 0x40
	Parameters: 1
	Flags: None
*/
function set_global_active_count(cnt)
{
	/#
		assert(cnt <= 32, "");
	#/
	level.spawn_manager_max_ai = cnt;
}

/*
	Name: use_trig_when_complete
	Namespace: spawn_manager
	Checksum: 0x53620539
	Offset: 0x2998
	Size: 0x14C
	Parameters: 4
	Flags: None
*/
function use_trig_when_complete(spawn_manager_targetname, trig_name, trig_key, once_only)
{
	if(isdefined(once_only) && once_only)
	{
		trigger = getent(trig_name, trig_key);
		/#
			assert(isdefined(trigger), ((("" + trig_key) + "") + trig_name) + "");
		#/
		trigger endon(#"trigger");
	}
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		level flag::wait_till(("sm_" + spawn_manager_targetname) + "_complete");
		trigger::use(trig_name, trig_key);
	}
	else
	{
		/#
			assertmsg(("" + spawn_manager_targetname) + "");
		#/
	}
}

/*
	Name: use_trig_when_cleared
	Namespace: spawn_manager
	Checksum: 0x8240C588
	Offset: 0x2AF0
	Size: 0x14C
	Parameters: 4
	Flags: None
*/
function use_trig_when_cleared(spawn_manager_targetname, trig_name, trig_key, once_only)
{
	if(isdefined(once_only) && once_only)
	{
		trigger = getent(trig_name, trig_key);
		/#
			assert(isdefined(trigger), ((("" + trig_key) + "") + trig_name) + "");
		#/
		trigger endon(#"trigger");
	}
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		level flag::wait_till(("sm_" + spawn_manager_targetname) + "_cleared");
		trigger::use(trig_name, trig_key);
	}
	else
	{
		/#
			assertmsg(("" + spawn_manager_targetname) + "");
		#/
	}
}

/*
	Name: use_trig_when_enabled
	Namespace: spawn_manager
	Checksum: 0x1E036BE0
	Offset: 0x2C48
	Size: 0x14C
	Parameters: 4
	Flags: None
*/
function use_trig_when_enabled(spawn_manager_targetname, trig_name, trig_key, once_only)
{
	if(isdefined(once_only) && once_only)
	{
		trigger = getent(trig_name, trig_key);
		/#
			assert(isdefined(trigger), ((("" + trig_key) + "") + trig_name) + "");
		#/
		trigger endon(#"trigger");
	}
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		level flag::wait_till(("sm_" + spawn_manager_targetname) + "_enabled");
		trigger::use(trig_name, trig_key);
	}
	else
	{
		/#
			assertmsg(("" + spawn_manager_targetname) + "");
		#/
	}
}

/*
	Name: run_func_when_complete
	Namespace: spawn_manager
	Checksum: 0x292CA172
	Offset: 0x2DA0
	Size: 0x10C
	Parameters: 8
	Flags: None
*/
function run_func_when_complete(spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5)
{
	/#
		assert(isdefined(process), "");
	#/
	/#
		assert(level flag::exists(("" + spawn_manager_targetname) + ""), ("" + spawn_manager_targetname) + "");
	#/
	wait_till_complete(spawn_manager_targetname);
	util::single_func(ent, process, var1, var2, var3, var4, var5);
}

/*
	Name: run_func_when_cleared
	Namespace: spawn_manager
	Checksum: 0xED260135
	Offset: 0x2EB8
	Size: 0x10C
	Parameters: 8
	Flags: None
*/
function run_func_when_cleared(spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5)
{
	/#
		assert(isdefined(process), "");
	#/
	/#
		assert(level flag::exists(("" + spawn_manager_targetname) + ""), ("" + spawn_manager_targetname) + "");
	#/
	wait_till_cleared(spawn_manager_targetname);
	util::single_func(ent, process, var1, var2, var3, var4, var5);
}

/*
	Name: run_func_when_enabled
	Namespace: spawn_manager
	Checksum: 0xA8013596
	Offset: 0x2FD0
	Size: 0x10C
	Parameters: 8
	Flags: None
*/
function run_func_when_enabled(spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5)
{
	/#
		assert(isdefined(process), "");
	#/
	/#
		assert(level flag::exists(("" + spawn_manager_targetname) + ""), ("" + spawn_manager_targetname) + "");
	#/
	wait_till_enabled(spawn_manager_targetname);
	util::single_func(ent, process, var1, var2, var3, var4, var5);
}

/*
	Name: enable
	Namespace: spawn_manager
	Checksum: 0x9C323A2D
	Offset: 0x30E8
	Size: 0x124
	Parameters: 2
	Flags: None
*/
function enable(spawn_manager_targetname, no_assert)
{
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		foreach(sm in level.spawn_managers)
		{
			if(isdefined(sm) && sm.sm_id == spawn_manager_targetname)
			{
				sm notify(#"enable");
				return;
			}
		}
	}
	else if(!(isdefined(no_assert) && no_assert))
	{
		/#
			assertmsg(("" + spawn_manager_targetname) + "");
		#/
	}
}

/*
	Name: disable
	Namespace: spawn_manager
	Checksum: 0x5145BF25
	Offset: 0x3218
	Size: 0x124
	Parameters: 2
	Flags: None
*/
function disable(spawn_manager_targetname, no_assert)
{
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		foreach(sm in level.spawn_managers)
		{
			if(isdefined(sm) && sm.sm_id == spawn_manager_targetname)
			{
				sm notify(#"disable");
				return;
			}
		}
	}
	else if(!(isdefined(no_assert) && no_assert))
	{
		/#
			assertmsg(("" + spawn_manager_targetname) + "");
		#/
	}
}

/*
	Name: kill
	Namespace: spawn_manager
	Checksum: 0x73FAB842
	Offset: 0x3348
	Size: 0x14C
	Parameters: 2
	Flags: None
*/
function kill(spawn_manager_targetname, no_assert)
{
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		foreach(sm in level.spawn_managers)
		{
			if(isdefined(sm) && sm.sm_id == spawn_manager_targetname)
			{
				sm delete();
				level.spawn_managers = array::remove_undefined(level.spawn_managers);
				return;
			}
		}
	}
	else if(!(isdefined(no_assert) && no_assert))
	{
		/#
			assertmsg(("" + spawn_manager_targetname) + "");
		#/
	}
}

/*
	Name: is_enabled
	Namespace: spawn_manager
	Checksum: 0xE35129A3
	Offset: 0x34A0
	Size: 0x9C
	Parameters: 1
	Flags: None
*/
function is_enabled(spawn_manager_targetname)
{
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		if(level flag::get(("sm_" + spawn_manager_targetname) + "_enabled"))
		{
			return true;
		}
		return false;
	}
	/#
		assertmsg(("" + spawn_manager_targetname) + "");
	#/
}

/*
	Name: is_complete
	Namespace: spawn_manager
	Checksum: 0x53B0AC1F
	Offset: 0x3548
	Size: 0x9C
	Parameters: 1
	Flags: None
*/
function is_complete(spawn_manager_targetname)
{
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		if(level flag::get(("sm_" + spawn_manager_targetname) + "_complete"))
		{
			return true;
		}
		return false;
	}
	/#
		assertmsg(("" + spawn_manager_targetname) + "");
	#/
}

/*
	Name: is_cleared
	Namespace: spawn_manager
	Checksum: 0x139C59AA
	Offset: 0x35F0
	Size: 0x9C
	Parameters: 1
	Flags: None
*/
function is_cleared(spawn_manager_targetname)
{
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		if(level flag::get(("sm_" + spawn_manager_targetname) + "_cleared"))
		{
			return true;
		}
		return false;
	}
	/#
		assertmsg(("" + spawn_manager_targetname) + "");
	#/
}

/*
	Name: is_killed
	Namespace: spawn_manager
	Checksum: 0x417F75C4
	Offset: 0x3698
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function is_killed(spawn_manager_targetname)
{
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		if(level flag::get(("sm_" + spawn_manager_targetname) + "_killed"))
		{
			return true;
		}
		return false;
	}
	/#
		assertmsg(("" + spawn_manager_targetname) + "");
	#/
}

/*
	Name: wait_till_cleared
	Namespace: spawn_manager
	Checksum: 0x1E8A7DAB
	Offset: 0x3740
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function wait_till_cleared(spawn_manager_targetname)
{
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		level flag::wait_till(("sm_" + spawn_manager_targetname) + "_cleared");
	}
	else
	{
		/#
			assertmsg(("" + spawn_manager_targetname) + "");
		#/
	}
}

/*
	Name: wait_till_ai_remaining
	Namespace: spawn_manager
	Checksum: 0x42954BA5
	Offset: 0x37D8
	Size: 0x134
	Parameters: 2
	Flags: None
*/
function wait_till_ai_remaining(spawn_manager_targetname, count_to_reach)
{
	/#
		assert(isdefined(count_to_reach), "");
	#/
	/#
		assert(count_to_reach, "");
	#/
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		level flag::wait_till(("sm_" + spawn_manager_targetname) + "_complete");
	}
	else
	{
		/#
			assertmsg(("" + spawn_manager_targetname) + "");
		#/
	}
	if(level flag::get(("sm_" + spawn_manager_targetname) + "_cleared"))
	{
		return;
	}
	while(get_ai(spawn_manager_targetname).size > count_to_reach)
	{
		wait(0.1);
	}
}

/*
	Name: wait_till_complete
	Namespace: spawn_manager
	Checksum: 0xE9DDF758
	Offset: 0x3918
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function wait_till_complete(spawn_manager_targetname)
{
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		level flag::wait_till(("sm_" + spawn_manager_targetname) + "_complete");
	}
	else
	{
		/#
			assertmsg(("" + spawn_manager_targetname) + "");
		#/
	}
}

/*
	Name: wait_till_enabled
	Namespace: spawn_manager
	Checksum: 0xB3D03906
	Offset: 0x39B0
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function wait_till_enabled(spawn_manager_targetname)
{
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		level flag::wait_till(("sm_" + spawn_manager_targetname) + "_enabled");
	}
	else
	{
		/#
			assertmsg(("" + spawn_manager_targetname) + "");
		#/
	}
}

/*
	Name: wait_till_spawned_count
	Namespace: spawn_manager
	Checksum: 0x6F9CFC62
	Offset: 0x3A48
	Size: 0x16C
	Parameters: 2
	Flags: None
*/
function wait_till_spawned_count(spawn_manager_targetname, count)
{
	if(level flag::exists(("sm_" + spawn_manager_targetname) + "_enabled"))
	{
		level flag::wait_till(("sm_" + spawn_manager_targetname) + "_enabled");
	}
	else
	{
		/#
			assertmsg(("" + spawn_manager_targetname) + "");
		#/
	}
	spawn_manager = get_spawn_manager_array(spawn_manager_targetname);
	/#
		assert(spawn_manager.size, "");
	#/
	/#
		assert(spawn_manager.size == 1, "");
	#/
	while(true)
	{
		if(isdefined(spawn_manager[0].spawncount) && spawn_manager[0].spawncount < count && !is_killed(spawn_manager_targetname))
		{
			wait(0.5);
		}
		else
		{
			break;
		}
	}
}

/*
	Name: get_ai
	Namespace: spawn_manager
	Checksum: 0x964E17D3
	Offset: 0x3BC0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function get_ai(spawn_manager_targetname)
{
	a_ai = getaiarray(spawn_manager_targetname, "sm_id");
	return a_ai;
}

