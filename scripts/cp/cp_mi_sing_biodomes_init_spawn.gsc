// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

#namespace sm_initial_spawns;

/*
	Name: __init__sytem__
	Namespace: sm_initial_spawns
	Checksum: 0xB35ADECF
	Offset: 0x250
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("sm_initial_spawns", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: sm_initial_spawns
	Checksum: 0x99EC1590
	Offset: 0x298
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

/*
	Name: __main__
	Namespace: sm_initial_spawns
	Checksum: 0x4B6C0DAE
	Offset: 0x2A8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level thread sm_infil_zone_setup();
}

/*
	Name: sm_axis_initial_spawn_func
	Namespace: sm_initial_spawns
	Checksum: 0x65424C34
	Offset: 0x2D0
	Size: 0x7C
	Parameters: 1
	Flags: None
*/
function sm_axis_initial_spawn_func(spawn_struct)
{
	self endon(#"death");
	wait(1);
	if(!level flag::get("sm_combat_started"))
	{
		wait(randomfloatrange(0.5, 1));
		level flag::set("sm_combat_started");
	}
}

/*
	Name: start_wave_spawning_on_combat
	Namespace: sm_initial_spawns
	Checksum: 0x8A94750D
	Offset: 0x358
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function start_wave_spawning_on_combat()
{
	level waittill(#"sm_combat_started");
}

/*
	Name: sm_infil_zone_setup
	Namespace: sm_initial_spawns
	Checksum: 0x9AE0C2D3
	Offset: 0x370
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function sm_infil_zone_setup()
{
	wait(1);
	a_infil_zones = struct::get_array("infil_manager", "targetname");
	foreach(zone in a_infil_zones)
	{
		zone infil_zone_selection();
	}
}

/*
	Name: infil_zone_selection
	Namespace: sm_initial_spawns
	Checksum: 0xF955D8CD
	Offset: 0x438
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function infil_zone_selection()
{
	a_volume_list = getentarray(self.target, "targetname");
	/#
		assert(a_volume_list.size != 0, "");
	#/
	a_volume_list[0] thread spawn_infil_zones();
}

/*
	Name: get_infil_activity
	Namespace: sm_initial_spawns
	Checksum: 0xB0F03F24
	Offset: 0x4B8
	Size: 0x19E
	Parameters: 1
	Flags: None
*/
function get_infil_activity(a_volume_list)
{
	for(i = 0; i < a_volume_list.size; i++)
	{
		if(isdefined(a_volume_list[i].script_noteworthy) && isdefined(level.gametype))
		{
			if(a_volume_list[i].script_noteworthy == level.gametype)
			{
				s_spawn_manager = a_volume_list[i];
				continue;
			}
			a_volume_list[i] infil_clean_up();
			array::remove_index(a_volume_list, i, 1);
		}
	}
	if(a_volume_list.size == 0)
	{
		return;
	}
	if(!isdefined(s_spawn_manager))
	{
		s_spawn_manager = array::random(a_volume_list);
	}
	foreach(volume in a_volume_list)
	{
		if(volume != s_spawn_manager)
		{
			volume infil_clean_up();
		}
	}
	return s_spawn_manager;
}

/*
	Name: spawn_infil_zones
	Namespace: sm_initial_spawns
	Checksum: 0x37058842
	Offset: 0x660
	Size: 0x1AE
	Parameters: 0
	Flags: Linked
*/
function spawn_infil_zones()
{
	while(true)
	{
		self waittill(#"trigger", ent);
		if(isdefined(ent.sessionstate) && ent.sessionstate != "spectator")
		{
			break;
		}
		wait(0.05);
	}
	target = self.target;
	a_entities = getentarray(target, "targetname");
	/#
		assert(a_entities.size != 0, "");
	#/
	s_handler = self;
	wait(1);
	foreach(entity in a_entities)
	{
		if(isspawner(entity) && !isdefined(level._infil_actor_off) && isdefined(s_handler))
		{
			entity handle_role_assignment(s_handler);
		}
	}
	self notify(#"infil_spawn_complete");
}

/*
	Name: handle_role_assignment
	Namespace: sm_initial_spawns
	Checksum: 0x46A5F607
	Offset: 0x818
	Size: 0x24C
	Parameters: 1
	Flags: Linked
*/
function handle_role_assignment(handler_struct)
{
	defend_volume = getent("street_battle_volume", "targetname");
	if(isdefined(level.free_targeting) || isdefined(level.target_volume))
	{
		if(isdefined(self.script_noteworthy) && self.script_noteworthy != "wasp_swarm" && self.script_noteworthy != "hunter_swarm")
		{
			self.target = undefined;
		}
	}
	if(!isdefined(self.script_noteworthy))
	{
		camp_guard = spawner::simple_spawn_single(self);
		if(isdefined(level.target_volume) && isactor(camp_guard))
		{
			camp_guard setgoal(defend_volume);
		}
		return;
	}
	if(self.script_noteworthy == "wasp_swarm")
	{
		self thread wasp_swarm_logic();
		return;
	}
	if(self.script_noteworthy == "hunter_swarm")
	{
		self thread hunter_swarm_logic();
		return;
	}
	camp_guard = spawner::simple_spawn_single(self);
	if(self.script_noteworthy == "patrol")
	{
		camp_guard thread infil_patrol_logic(self.target);
	}
	else
	{
		if(self.script_noteworthy == "defend")
		{
			if(isdefined(camp_guard.target))
			{
			}
		}
		else
		{
			if(self.script_noteworthy == "guard")
			{
				if(isdefined(camp_guard.target))
				{
				}
			}
			else if(self.script_noteworthy == "scene")
			{
				camp_guard thread script_scene_setup(self, handler_struct);
			}
		}
	}
}

/*
	Name: wasp_swarm_logic
	Namespace: sm_initial_spawns
	Checksum: 0xABBDA6A1
	Offset: 0xA70
	Size: 0xB6
	Parameters: 0
	Flags: Linked
*/
function wasp_swarm_logic()
{
	path_start = getvehiclenode(self.target, "targetname");
	offset = vectorscale((0, 1, 0), 60);
	for(i = 0; i < self.script_int; i++)
	{
		wasp = spawner::simple_spawn_single(self);
		wasp thread handle_spline(path_start, i);
	}
}

/*
	Name: hunter_swarm_logic
	Namespace: sm_initial_spawns
	Checksum: 0xE235EED6
	Offset: 0xB30
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function hunter_swarm_logic()
{
	path_start = getvehiclenode(self.target, "targetname");
	hunter = spawner::simple_spawn_single(self);
	hunter vehicle_ai::start_scripted();
	hunter vehicle::get_on_path(path_start);
	hunter.drivepath = 1;
	hunter vehicle::go_path();
	hunter setgoal(level.players[0], 0, 1000);
	hunter vehicle_ai::stop_scripted();
	hunter.lockontarget = level.players[0];
}

/*
	Name: handle_spline
	Namespace: sm_initial_spawns
	Checksum: 0xFFD35537
	Offset: 0xC38
	Size: 0x110
	Parameters: 2
	Flags: Linked
*/
function handle_spline(path_start, index)
{
	offset = vectorscale((0, 1, 0), 30);
	self vehicle_ai::start_scripted();
	self vehicle::get_on_path(path_start);
	self.drivepath = 1;
	offset_scale = get_offset_scale(index);
	self pathfixedoffset(offset * offset_scale);
	self vehicle::go_path();
	self setgoal(level.players[0], 0, 600, 150);
	self vehicle_ai::stop_scripted();
	self.lockontarget = level.players[0];
}

/*
	Name: get_offset_scale
	Namespace: sm_initial_spawns
	Checksum: 0x274C93F0
	Offset: 0xD50
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function get_offset_scale(i)
{
	if((i % 2) == 0)
	{
		return (i / 2) * -1;
	}
	return (i - (i / 2)) + 0.5;
}

/*
	Name: infil_patrol_logic
	Namespace: sm_initial_spawns
	Checksum: 0x2CC09275
	Offset: 0xDA8
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function infil_patrol_logic(str_start_node)
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"patrol_wp_reached", node);
		if(isdefined(node.script_wait) || (isdefined(node.script_wait_min) && isdefined(node.script_wait_max)))
		{
			node util::script_wait();
		}
	}
}

/*
	Name: script_scene_setup
	Namespace: sm_initial_spawns
	Checksum: 0xCC13D254
	Offset: 0xE40
	Size: 0x13C
	Parameters: 2
	Flags: Linked
*/
function script_scene_setup(align_node, handler_struct)
{
	if(isdefined(self.target))
	{
		node = getnode(self.target, "targetname");
		if(isdefined(node))
		{
		}
		else
		{
			defend_volume = getent(self.target, "targetname");
		}
	}
	else
	{
		if(isdefined(handler_struct.height))
		{
			self.goalheight = handler_struct.height;
		}
		if(isdefined(handler_struct.radius))
		{
			self.goalradius = handler_struct.radius;
		}
	}
	wait(0.05);
	/#
		assert(isdefined(self.script_string), "");
	#/
	align_node thread scene::init(self.script_string, self);
}

/*
	Name: infil_clean_up
	Namespace: sm_initial_spawns
	Checksum: 0x8423BA4C
	Offset: 0xF88
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function infil_clean_up()
{
	a_entities = getentarray(self.target, "targetname");
	foreach(entity in a_entities)
	{
		if(isspawner(entity))
		{
			entity delete();
			continue;
		}
		if(isdefined(entity.target))
		{
			nd_cover_nodes = getnodearray(entity.target, "targetname");
			foreach(node in nd_cover_nodes)
			{
				setenablenode(node, 0);
			}
		}
		entity connectpaths();
		entity delete();
	}
	self delete();
}

/*
	Name: kill_infil_actor_spawn
	Namespace: sm_initial_spawns
	Checksum: 0x62D0040E
	Offset: 0x1178
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function kill_infil_actor_spawn()
{
	if(!isdefined(level._infil_actor_off))
	{
		level._infil_actor_off = 1;
	}
}

