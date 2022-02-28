// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\vehicles\_auto_turret;

#using_animtree("generic");

#namespace vehicle;

/*
	Name: __init__sytem__
	Namespace: vehicle
	Checksum: 0xA60EFE9
	Offset: 0x778
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("vehicle_shared", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: vehicle
	Checksum: 0x410B6DEB
	Offset: 0x7C0
	Size: 0x9DC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("vehicle", "toggle_lockon", 1, 1, "int");
	clientfield::register("vehicle", "toggle_sounds", 1, 1, "int");
	clientfield::register("vehicle", "use_engine_damage_sounds", 1, 2, "int");
	clientfield::register("vehicle", "toggle_treadfx", 1, 1, "int");
	clientfield::register("vehicle", "toggle_exhaustfx", 1, 1, "int");
	clientfield::register("vehicle", "toggle_lights", 1, 2, "int");
	clientfield::register("vehicle", "toggle_lights_group1", 1, 1, "int");
	clientfield::register("vehicle", "toggle_lights_group2", 1, 1, "int");
	clientfield::register("vehicle", "toggle_lights_group3", 1, 1, "int");
	clientfield::register("vehicle", "toggle_lights_group4", 1, 1, "int");
	clientfield::register("vehicle", "toggle_ambient_anim_group1", 1, 1, "int");
	clientfield::register("vehicle", "toggle_ambient_anim_group2", 1, 1, "int");
	clientfield::register("vehicle", "toggle_ambient_anim_group3", 1, 1, "int");
	clientfield::register("vehicle", "toggle_emp_fx", 1, 1, "int");
	clientfield::register("vehicle", "toggle_burn_fx", 1, 1, "int");
	clientfield::register("vehicle", "deathfx", 1, 2, "int");
	clientfield::register("vehicle", "alert_level", 1, 2, "int");
	clientfield::register("vehicle", "set_lighting_ent", 1, 1, "int");
	clientfield::register("vehicle", "use_lighting_ent", 1, 1, "int");
	clientfield::register("vehicle", "damage_level", 1, 3, "int");
	clientfield::register("vehicle", "spawn_death_dynents", 1, 2, "int");
	clientfield::register("vehicle", "spawn_gib_dynents", 1, 1, "int");
	clientfield::register("helicopter", "toggle_lockon", 1, 1, "int");
	clientfield::register("helicopter", "toggle_sounds", 1, 1, "int");
	clientfield::register("helicopter", "use_engine_damage_sounds", 1, 2, "int");
	clientfield::register("helicopter", "toggle_treadfx", 1, 1, "int");
	clientfield::register("helicopter", "toggle_exhaustfx", 1, 1, "int");
	clientfield::register("helicopter", "toggle_lights", 1, 2, "int");
	clientfield::register("helicopter", "toggle_lights_group1", 1, 1, "int");
	clientfield::register("helicopter", "toggle_lights_group2", 1, 1, "int");
	clientfield::register("helicopter", "toggle_lights_group3", 1, 1, "int");
	clientfield::register("helicopter", "toggle_lights_group4", 1, 1, "int");
	clientfield::register("helicopter", "toggle_ambient_anim_group1", 1, 1, "int");
	clientfield::register("helicopter", "toggle_ambient_anim_group2", 1, 1, "int");
	clientfield::register("helicopter", "toggle_ambient_anim_group3", 1, 1, "int");
	clientfield::register("helicopter", "toggle_emp_fx", 1, 1, "int");
	clientfield::register("helicopter", "toggle_burn_fx", 1, 1, "int");
	clientfield::register("helicopter", "deathfx", 1, 1, "int");
	clientfield::register("helicopter", "alert_level", 1, 2, "int");
	clientfield::register("helicopter", "set_lighting_ent", 1, 1, "int");
	clientfield::register("helicopter", "use_lighting_ent", 1, 1, "int");
	clientfield::register("helicopter", "damage_level", 1, 3, "int");
	clientfield::register("helicopter", "spawn_death_dynents", 1, 2, "int");
	clientfield::register("helicopter", "spawn_gib_dynents", 1, 1, "int");
	clientfield::register("plane", "toggle_treadfx", 1, 1, "int");
	clientfield::register("toplayer", "toggle_dnidamagefx", 1, 1, "int");
	clientfield::register("toplayer", "toggle_flir_postfx", 1, 2, "int");
	clientfield::register("toplayer", "static_postfx", 1, 1, "int");
	if(isdefined(level.bypassvehiclescripts))
	{
		return;
	}
	level.heli_default_decel = 10;
	setup_targetname_spawners();
	setup_dvars();
	setup_level_vars();
	setup_triggers();
	setup_nodes();
	level array::thread_all_ents(level.vehicle_processtriggers, &trigger_process);
	level.vehicle_processtriggers = undefined;
	level.vehicle_enemy_tanks = [];
	level.vehicle_enemy_tanks["vehicle_ger_tracked_king_tiger"] = 1;
	level thread _watch_for_hijacked_vehicles();
}

/*
	Name: __main__
	Namespace: vehicle
	Checksum: 0x5D8287B6
	Offset: 0x11A8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	a_all_spawners = getvehiclespawnerarray();
	setup_spawners(a_all_spawners);
	/#
		level thread vehicle_spawner_tool();
		level thread spline_debug();
	#/
}

/*
	Name: setup_script_gatetrigger
	Namespace: vehicle
	Checksum: 0x82676BC8
	Offset: 0x1218
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function setup_script_gatetrigger(trigger)
{
	gates = [];
	if(isdefined(trigger.script_gatetrigger))
	{
		return level.vehicle_gatetrigger[trigger.script_gatetrigger];
	}
	return gates;
}

/*
	Name: trigger_process
	Namespace: vehicle
	Checksum: 0x1121FA1C
	Offset: 0x1270
	Size: 0x61E
	Parameters: 1
	Flags: Linked
*/
function trigger_process(trigger)
{
	if(isdefined(trigger.classname) && (trigger.classname == "trigger_multiple" || trigger.classname == "trigger_radius" || trigger.classname == "trigger_lookat" || trigger.classname == "trigger_box"))
	{
		btriggeronce = 1;
	}
	else
	{
		btriggeronce = 0;
	}
	if(isdefined(trigger.script_noteworthy) && trigger.script_noteworthy == "trigger_multiple")
	{
		btriggeronce = 0;
	}
	trigger.processed_trigger = undefined;
	gates = setup_script_gatetrigger(trigger);
	script_vehicledetour = isdefined(trigger.script_vehicledetour) && (is_node_script_origin(trigger) || is_node_script_struct(trigger));
	detoured = isdefined(trigger.detoured) && (!(is_node_script_origin(trigger) || is_node_script_struct(trigger)));
	gotrigger = 1;
	while(gotrigger)
	{
		trigger trigger::wait_till();
		other = trigger.who;
		if(isdefined(trigger.enabled) && !trigger.enabled)
		{
			trigger waittill(#"enable");
		}
		if(isdefined(trigger.script_flag_set))
		{
			if(isdefined(other) && isdefined(other.vehicle_flags))
			{
				other.vehicle_flags[trigger.script_flag_set] = 1;
			}
			if(isdefined(other))
			{
				other notify(#"vehicle_flag_arrived", trigger.script_flag_set);
			}
			level flag::set(trigger.script_flag_set);
		}
		if(isdefined(trigger.script_flag_clear))
		{
			if(isdefined(other) && isdefined(other.vehicle_flags))
			{
				other.vehicle_flags[trigger.script_flag_clear] = 0;
			}
			level flag::clear(trigger.script_flag_clear);
		}
		if(isdefined(other) && script_vehicledetour)
		{
			other thread path_detour_script_origin(trigger);
		}
		else if(detoured && isdefined(other))
		{
			other thread path_detour(trigger);
		}
		trigger util::script_delay();
		if(btriggeronce)
		{
			gotrigger = 0;
		}
		if(isdefined(trigger.script_vehiclegroupdelete))
		{
			if(!isdefined(level.vehicle_deletegroup[trigger.script_vehiclegroupdelete]))
			{
				/#
					println("", trigger.script_vehiclegroupdelete);
				#/
				level.vehicle_deletegroup[trigger.script_vehiclegroupdelete] = [];
			}
			array::delete_all(level.vehicle_deletegroup[trigger.script_vehiclegroupdelete]);
		}
		if(isdefined(trigger.script_vehiclespawngroup))
		{
			level notify("spawnvehiclegroup" + trigger.script_vehiclespawngroup);
			level waittill("vehiclegroup spawned" + trigger.script_vehiclespawngroup);
		}
		if(gates.size > 0 && btriggeronce)
		{
			level array::thread_all_ents(gates, &path_gate_open);
		}
		if(isdefined(trigger) && isdefined(trigger.script_vehiclestartmove))
		{
			if(!isdefined(level.vehicle_startmovegroup[trigger.script_vehiclestartmove]))
			{
				/#
					println("", trigger.script_vehiclestartmove);
				#/
				return;
			}
			foreach(vehicle in arraycopy(level.vehicle_startmovegroup[trigger.script_vehiclestartmove]))
			{
				if(isdefined(vehicle))
				{
					vehicle thread go_path();
				}
			}
		}
	}
}

/*
	Name: path_detour_get_detourpath
	Namespace: vehicle
	Checksum: 0xC35A24E8
	Offset: 0x1898
	Size: 0xD6
	Parameters: 1
	Flags: Linked
*/
function path_detour_get_detourpath(detournode)
{
	detourpath = undefined;
	for(j = 0; j < level.vehicle_detourpaths[detournode.script_vehicledetour].size; j++)
	{
		if(level.vehicle_detourpaths[detournode.script_vehicledetour][j] != detournode)
		{
			if(!islastnode(level.vehicle_detourpaths[detournode.script_vehicledetour][j]))
			{
				detourpath = level.vehicle_detourpaths[detournode.script_vehicledetour][j];
			}
		}
	}
	return detourpath;
}

/*
	Name: path_detour_script_origin
	Namespace: vehicle
	Checksum: 0x99CA5C67
	Offset: 0x1978
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function path_detour_script_origin(detournode)
{
	detourpath = path_detour_get_detourpath(detournode);
	if(isdefined(detourpath))
	{
		self thread paths(detourpath);
	}
}

/*
	Name: crash_detour_check
	Namespace: vehicle
	Checksum: 0xDD85592F
	Offset: 0x19D8
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function crash_detour_check(detourpath)
{
	return isdefined(detourpath.script_crashtype) && (isdefined(self.deaddriver) || self.health <= 0 || detourpath.script_crashtype == "forced") && (!isdefined(detourpath.derailed) || (isdefined(detourpath.script_crashtype) && detourpath.script_crashtype == "plane"));
}

/*
	Name: crash_derailed_check
	Namespace: vehicle
	Checksum: 0xBC39A35A
	Offset: 0x1A78
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function crash_derailed_check(detourpath)
{
	return isdefined(detourpath.derailed) && detourpath.derailed;
}

/*
	Name: path_detour
	Namespace: vehicle
	Checksum: 0xCF31AEB8
	Offset: 0x1AB0
	Size: 0x15E
	Parameters: 1
	Flags: Linked
*/
function path_detour(node)
{
	detournode = getvehiclenode(node.target, "targetname");
	detourpath = path_detour_get_detourpath(detournode);
	if(!isdefined(detourpath))
	{
		return;
	}
	if(node.detoured && !isdefined(detourpath.script_vehicledetourgroup))
	{
		return;
	}
	if(crash_detour_check(detourpath))
	{
		self notify(#"crashpath", detourpath);
		detourpath.derailed = 1;
		self notify(#"newpath");
		self setswitchnode(node, detourpath);
		return;
	}
	if(crash_derailed_check(detourpath))
	{
		return;
	}
	if(isdefined(detourpath.script_vehicledetourgroup))
	{
		if(!isdefined(self.script_vehicledetourgroup))
		{
			return;
		}
		if(detourpath.script_vehicledetourgroup != self.script_vehicledetourgroup)
		{
			return;
		}
	}
}

/*
	Name: levelstuff
	Namespace: vehicle
	Checksum: 0x5FD58841
	Offset: 0x1C18
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function levelstuff(vehicle)
{
	if(isdefined(vehicle.script_linkname))
	{
		level.vehicle_link = array_2d_add(level.vehicle_link, vehicle.script_linkname, vehicle);
	}
	if(isdefined(vehicle.script_vehiclespawngroup))
	{
		level.vehicle_spawngroup = array_2d_add(level.vehicle_spawngroup, vehicle.script_vehiclespawngroup, vehicle);
	}
	if(isdefined(vehicle.script_vehiclestartmove))
	{
		level.vehicle_startmovegroup = array_2d_add(level.vehicle_startmovegroup, vehicle.script_vehiclestartmove, vehicle);
	}
	if(isdefined(vehicle.script_vehiclegroupdelete))
	{
		level.vehicle_deletegroup = array_2d_add(level.vehicle_deletegroup, vehicle.script_vehiclegroupdelete, vehicle);
	}
}

/*
	Name: _spawn_array
	Namespace: vehicle
	Checksum: 0x266D98E8
	Offset: 0x1D50
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function _spawn_array(spawners)
{
	ai = _remove_non_riders_from_array(spawner::simple_spawn(spawners));
	return ai;
}

/*
	Name: _remove_non_riders_from_array
	Namespace: vehicle
	Checksum: 0xEE3791AF
	Offset: 0x1DA0
	Size: 0x88
	Parameters: 1
	Flags: Linked
*/
function _remove_non_riders_from_array(ai)
{
	living_ai = [];
	for(i = 0; i < ai.size; i++)
	{
		if(!ai_should_be_added(ai[i]))
		{
			continue;
		}
		living_ai[living_ai.size] = ai[i];
	}
	return living_ai;
}

/*
	Name: ai_should_be_added
	Namespace: vehicle
	Checksum: 0xE872CD3C
	Offset: 0x1E30
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function ai_should_be_added(ai)
{
	if(isalive(ai))
	{
		return 1;
	}
	if(!isdefined(ai))
	{
		return 0;
	}
	if(!isdefined(ai.classname))
	{
		return 0;
	}
	return ai.classname == "script_model";
}

/*
	Name: sort_by_startingpos
	Namespace: vehicle
	Checksum: 0x1853FB6F
	Offset: 0x1EA0
	Size: 0xC2
	Parameters: 1
	Flags: None
*/
function sort_by_startingpos(guysarray)
{
	firstarray = [];
	secondarray = [];
	for(i = 0; i < guysarray.size; i++)
	{
		if(isdefined(guysarray[i].script_startingposition))
		{
			firstarray[firstarray.size] = guysarray[i];
			continue;
		}
		secondarray[secondarray.size] = guysarray[i];
	}
	return arraycombine(firstarray, secondarray, 1, 0);
}

/*
	Name: rider_walk_setup
	Namespace: vehicle
	Checksum: 0xA9A4F432
	Offset: 0x1F70
	Size: 0xA0
	Parameters: 1
	Flags: None
*/
function rider_walk_setup(vehicle)
{
	if(!isdefined(self.script_vehiclewalk))
	{
		return;
	}
	if(isdefined(self.script_followmode))
	{
		self.followmode = self.script_followmode;
	}
	else
	{
		self.followmode = "cover nodes";
	}
	if(!isdefined(self.target))
	{
		return;
	}
	node = getnode(self.target, "targetname");
	if(isdefined(node))
	{
		self.nodeaftervehiclewalk = node;
	}
}

/*
	Name: setup_groundnode_detour
	Namespace: vehicle
	Checksum: 0x754A82D3
	Offset: 0x2018
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function setup_groundnode_detour(node)
{
	realdetournode = getvehiclenode(node.targetname, "target");
	if(!isdefined(realdetournode))
	{
		return;
	}
	realdetournode.detoured = 0;
	add_proccess_trigger(realdetournode);
}

/*
	Name: add_proccess_trigger
	Namespace: vehicle
	Checksum: 0x27A7E0C4
	Offset: 0x2098
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function add_proccess_trigger(trigger)
{
	if(isdefined(trigger.processed_trigger))
	{
		return;
	}
	if(!isdefined(level.vehicle_processtriggers))
	{
		level.vehicle_processtriggers = [];
	}
	else if(!isarray(level.vehicle_processtriggers))
	{
		level.vehicle_processtriggers = array(level.vehicle_processtriggers);
	}
	level.vehicle_processtriggers[level.vehicle_processtriggers.size] = trigger;
	trigger.processed_trigger = 1;
}

/*
	Name: islastnode
	Namespace: vehicle
	Checksum: 0x69517D66
	Offset: 0x2148
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function islastnode(node)
{
	if(!isdefined(node.target))
	{
		return true;
	}
	if(!isdefined(getvehiclenode(node.target, "targetname")) && !isdefined(get_vehiclenode_any_dynamic(node.target)))
	{
		return true;
	}
	return false;
}

/*
	Name: paths
	Namespace: vehicle
	Checksum: 0x1EA903F9
	Offset: 0x21D8
	Size: 0xB84
	Parameters: 1
	Flags: Linked
*/
function paths(node)
{
	self endon(#"death");
	/#
		assert(isdefined(node) || isdefined(self.attachedpath), "");
	#/
	self notify(#"newpath");
	if(isdefined(node))
	{
		self.attachedpath = node;
	}
	pathstart = self.attachedpath;
	self.currentnode = self.attachedpath;
	if(!isdefined(pathstart))
	{
		return;
	}
	/#
		self thread debug_vehicle_paths();
	#/
	self endon(#"newpath");
	currentpoint = pathstart;
	while(isdefined(currentpoint))
	{
		self waittill(#"reached_node", currentpoint);
		currentpoint enable_turrets(self);
		if(!isdefined(self))
		{
			return;
		}
		self.currentnode = currentpoint;
		self.nextnode = (isdefined(currentpoint.target) ? getvehiclenode(currentpoint.target, "targetname") : undefined);
		if(isdefined(currentpoint.gateopen) && !currentpoint.gateopen)
		{
			self thread path_gate_wait_till_open(currentpoint);
		}
		currentpoint notify(#"trigger", self);
		if(isdefined(currentpoint.script_dropbombs) && currentpoint.script_dropbombs > 0)
		{
			amount = currentpoint.script_dropbombs;
			delay = 0;
			delaytrace = 0;
			if(isdefined(currentpoint.script_dropbombs_delay) && currentpoint.script_dropbombs_delay > 0)
			{
				delay = currentpoint.script_dropbombs_delay;
			}
			if(isdefined(currentpoint.script_dropbombs_delaytrace) && currentpoint.script_dropbombs_delaytrace > 0)
			{
				delaytrace = currentpoint.script_dropbombs_delaytrace;
			}
			self notify(#"drop_bombs", amount, delay, delaytrace);
		}
		if(isdefined(currentpoint.script_noteworthy))
		{
			self notify(currentpoint.script_noteworthy);
			self notify(#"noteworthy", currentpoint.script_noteworthy);
		}
		if(isdefined(currentpoint.script_notify))
		{
			self notify(currentpoint.script_notify);
			level notify(currentpoint.script_notify);
		}
		waittillframeend();
		if(!isdefined(self))
		{
			return;
		}
		if(isdefined(currentpoint.script_delete) && currentpoint.script_delete)
		{
			if(isdefined(self.riders) && self.riders.size > 0)
			{
				array::delete_all(self.riders);
			}
			self.delete_on_death = 1;
			self notify(#"death");
			if(!isalive(self))
			{
				self delete();
			}
			return;
		}
		if(isdefined(currentpoint.script_sound))
		{
			self playsound(currentpoint.script_sound);
		}
		if(isdefined(currentpoint.script_noteworthy))
		{
			if(currentpoint.script_noteworthy == "godon")
			{
				self god_on();
			}
			else
			{
				if(currentpoint.script_noteworthy == "godoff")
				{
					self god_off();
				}
				else
				{
					if(currentpoint.script_noteworthy == "drivepath")
					{
						self drivepath();
					}
					else
					{
						if(currentpoint.script_noteworthy == "lockpath")
						{
							self startpath();
						}
						else
						{
							if(currentpoint.script_noteworthy == "brake")
							{
								if(self.isphysicsvehicle)
								{
									self setbrake(1);
								}
								self setspeed(0, 60, 60);
							}
							else if(currentpoint.script_noteworthy == "resumespeed")
							{
								accel = 30;
								if(isdefined(currentpoint.script_float))
								{
									accel = currentpoint.script_float;
								}
								self resumespeed(accel);
							}
						}
					}
				}
			}
		}
		if(isdefined(currentpoint.script_crashtypeoverride))
		{
			self.script_crashtypeoverride = currentpoint.script_crashtypeoverride;
		}
		if(isdefined(currentpoint.script_badplace))
		{
			self.script_badplace = currentpoint.script_badplace;
		}
		if(isdefined(currentpoint.script_team))
		{
			self.team = currentpoint.script_team;
		}
		if(isdefined(currentpoint.script_turningdir))
		{
			self notify(#"turning", currentpoint.script_turningdir);
		}
		if(isdefined(currentpoint.script_deathroll))
		{
			if(currentpoint.script_deathroll == 0)
			{
				self thread vehicle_death::deathrolloff();
			}
			else
			{
				self thread vehicle_death::deathrollon();
			}
		}
		if(isdefined(currentpoint.script_exploder))
		{
			exploder::exploder(currentpoint.script_exploder);
		}
		if(isdefined(currentpoint.script_flag_set))
		{
			if(isdefined(self.vehicle_flags))
			{
				self.vehicle_flags[currentpoint.script_flag_set] = 1;
			}
			self notify(#"vehicle_flag_arrived", currentpoint.script_flag_set);
			level flag::set(currentpoint.script_flag_set);
		}
		if(isdefined(currentpoint.script_flag_clear))
		{
			if(isdefined(self.vehicle_flags))
			{
				self.vehicle_flags[currentpoint.script_flag_clear] = 0;
			}
			level flag::clear(currentpoint.script_flag_clear);
		}
		if(isdefined(self.vehicleclass) && self.vehicleclass == "helicopter" && isdefined(self.drivepath) && self.drivepath == 1)
		{
			if(isdefined(self.nextnode) && self.nextnode is_unload_node())
			{
				unload_node_helicopter(undefined);
				self.attachedpath = self.nextnode;
				self drivepath(self.attachedpath);
			}
		}
		else if(currentpoint is_unload_node())
		{
			unload_node(currentpoint);
		}
		if(isdefined(currentpoint.script_wait))
		{
			pause_path();
			currentpoint util::script_wait();
		}
		if(isdefined(currentpoint.script_waittill))
		{
			pause_path();
			util::waittill_any_ents(self, currentpoint.script_waittill, level, currentpoint.script_waittill);
		}
		if(isdefined(currentpoint.script_flag_wait))
		{
			if(!isdefined(self.vehicle_flags))
			{
				self.vehicle_flags = [];
			}
			self.vehicle_flags[currentpoint.script_flag_wait] = 1;
			self notify(#"vehicle_flag_arrived", currentpoint.script_flag_wait);
			self flag::set("waiting_for_flag");
			if(!level flag::get(currentpoint.script_flag_wait))
			{
				pause_path();
				level flag::wait_till(currentpoint.script_flag_wait);
			}
			self flag::clear("waiting_for_flag");
		}
		if(isdefined(self.set_lookat_point))
		{
			self.set_lookat_point = undefined;
			self clearlookatent();
		}
		if(isdefined(currentpoint.script_lights_on))
		{
			if(currentpoint.script_lights_on)
			{
				self lights_on();
			}
			else
			{
				self lights_off();
			}
		}
		if(isdefined(currentpoint.script_stopnode))
		{
			self set_goal_pos(currentpoint.origin, 1);
		}
		if(isdefined(self.switchnode))
		{
			if(currentpoint == self.switchnode)
			{
				self.switchnode = undefined;
			}
		}
		else if(!isdefined(currentpoint.target))
		{
			break;
		}
		resume_path();
	}
	self notify(#"reached_dynamic_path_end");
	if(isdefined(self.script_delete))
	{
		self delete();
	}
}

/*
	Name: pause_path
	Namespace: vehicle
	Checksum: 0xD13A6CAB
	Offset: 0x2D68
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function pause_path()
{
	if(!(isdefined(self.vehicle_paused) && self.vehicle_paused))
	{
		if(self.isphysicsvehicle)
		{
			self setbrake(1);
		}
		if(isdefined(self.vehicleclass) && self.vehicleclass == "helicopter")
		{
			if(isdefined(self.drivepath) && self.drivepath)
			{
				self setvehgoalpos(self.origin, 1);
			}
			else
			{
				self setspeed(0, 100, 100);
			}
		}
		else
		{
			self setspeed(0, 35, 35);
		}
		self.vehicle_paused = 1;
	}
}

/*
	Name: resume_path
	Namespace: vehicle
	Checksum: 0xC86E33EC
	Offset: 0x2E50
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function resume_path()
{
	if(isdefined(self.vehicle_paused) && self.vehicle_paused)
	{
		if(self.isphysicsvehicle)
		{
			self setbrake(0);
		}
		if(isdefined(self.vehicleclass) && self.vehicleclass == "helicopter")
		{
			if(isdefined(self.drivepath) && self.drivepath)
			{
				self drivepath(self.currentnode);
			}
			self resumespeed(100);
		}
		else
		{
			self resumespeed(35);
		}
		self.vehicle_paused = undefined;
	}
}

/*
	Name: get_on_path
	Namespace: vehicle
	Checksum: 0x708860E1
	Offset: 0x2F28
	Size: 0x1BC
	Parameters: 2
	Flags: Linked
*/
function get_on_path(path_start, str_key = "targetname")
{
	if(isstring(path_start))
	{
		path_start = getvehiclenode(path_start, str_key);
	}
	if(!isdefined(path_start))
	{
		if(isdefined(self.targetname))
		{
			/#
				assertmsg("" + self.targetname);
			#/
		}
		else
		{
			/#
				assertmsg("" + self.targetname);
			#/
		}
	}
	if(isdefined(self.hasstarted))
	{
		self.hasstarted = undefined;
	}
	self.attachedpath = path_start;
	if(!(isdefined(self.drivepath) && self.drivepath))
	{
		self attachpath(path_start);
	}
	if(self.disconnectpathonstop === 1 && !issentient(self))
	{
		self disconnect_paths(self.disconnectpathdetail);
	}
	if(isdefined(self.isphysicsvehicle) && self.isphysicsvehicle)
	{
		self setbrake(1);
	}
	self thread paths();
}

/*
	Name: get_off_path
	Namespace: vehicle
	Checksum: 0x5D764080
	Offset: 0x30F0
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function get_off_path()
{
	self cancelaimove();
	self clearvehgoalpos();
}

/*
	Name: create_from_spawngroup_and_go_path
	Namespace: vehicle
	Checksum: 0xEFD7E7E7
	Offset: 0x3130
	Size: 0x8A
	Parameters: 1
	Flags: None
*/
function create_from_spawngroup_and_go_path(spawngroup)
{
	vehiclearray = _scripted_spawn(spawngroup);
	for(i = 0; i < vehiclearray.size; i++)
	{
		if(isdefined(vehiclearray[i]))
		{
			vehiclearray[i] thread go_path();
		}
	}
	return vehiclearray;
}

/*
	Name: get_on_and_go_path
	Namespace: vehicle
	Checksum: 0x794A1227
	Offset: 0x31C8
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function get_on_and_go_path(path_start)
{
	self get_on_path(path_start);
	self go_path();
}

/*
	Name: go_path
	Namespace: vehicle
	Checksum: 0x3CA25D03
	Offset: 0x3210
	Size: 0x1C2
	Parameters: 0
	Flags: Linked
*/
function go_path()
{
	self endon(#"death");
	self endon(#"hash_117fe2f2");
	if(self.isphysicsvehicle)
	{
		self setbrake(0);
	}
	if(isdefined(self.script_vehiclestartmove))
	{
		arrayremovevalue(level.vehicle_startmovegroup[self.script_vehiclestartmove], self);
	}
	if(isdefined(self.hasstarted))
	{
		/#
			println("");
		#/
		return;
	}
	self.hasstarted = 1;
	self util::script_delay();
	self notify(#"start_vehiclepath");
	if(isdefined(self.drivepath) && self.drivepath)
	{
		self drivepath(self.attachedpath);
	}
	else
	{
		self startpath();
	}
	wait(0.05);
	self connect_paths();
	self waittill(#"reached_end_node");
	if(self.disconnectpathonstop === 1 && !issentient(self))
	{
		self disconnect_paths(self.disconnectpathdetail);
	}
	if(isdefined(self.currentnode) && isdefined(self.currentnode.script_noteworthy) && self.currentnode.script_noteworthy == "deleteme")
	{
		return;
	}
}

/*
	Name: path_gate_open
	Namespace: vehicle
	Checksum: 0xC00134F5
	Offset: 0x33E0
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function path_gate_open(node)
{
	node.gateopen = 1;
	node notify(#"hash_91ff5153");
}

/*
	Name: path_gate_wait_till_open
	Namespace: vehicle
	Checksum: 0x5A9CFC8F
	Offset: 0x3418
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function path_gate_wait_till_open(pathspot)
{
	self endon(#"death");
	self.waitingforgate = 1;
	self set_speed(0, 15, "path gate closed");
	pathspot waittill(#"hash_91ff5153");
	self.waitingforgate = 0;
	if(self.health > 0)
	{
		script_resume_speed("gate opened", level.vehicle_resumespeed);
	}
}

/*
	Name: _spawn_group
	Namespace: vehicle
	Checksum: 0x4C3843F4
	Offset: 0x34B0
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function _spawn_group(spawngroup)
{
	while(true)
	{
		level waittill("spawnvehiclegroup" + spawngroup);
		spawned_vehicles = [];
		for(i = 0; i < level.vehicle_spawners[spawngroup].size; i++)
		{
			spawned_vehicles[spawned_vehicles.size] = _vehicle_spawn(level.vehicle_spawners[spawngroup][i]);
		}
		level notify("vehiclegroup spawned" + spawngroup, spawned_vehicles);
	}
}

/*
	Name: _scripted_spawn
	Namespace: vehicle
	Checksum: 0x7739E092
	Offset: 0x3570
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function _scripted_spawn(group)
{
	thread _scripted_spawn_go(group);
	level waittill("vehiclegroup spawned" + group, vehicles);
	return vehicles;
}

/*
	Name: _scripted_spawn_go
	Namespace: vehicle
	Checksum: 0x4F574C20
	Offset: 0x35C0
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function _scripted_spawn_go(group)
{
	waittillframeend();
	level notify("spawnvehiclegroup" + group);
}

/*
	Name: set_variables
	Namespace: vehicle
	Checksum: 0x54D6AE4F
	Offset: 0x35E8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function set_variables(vehicle)
{
	if(isdefined(vehicle.script_deathflag))
	{
		if(!level flag::exists(vehicle.script_deathflag))
		{
			level flag::init(vehicle.script_deathflag);
		}
	}
}

/*
	Name: _vehicle_spawn
	Namespace: vehicle
	Checksum: 0x1EC913E8
	Offset: 0x3660
	Size: 0x220
	Parameters: 2
	Flags: Linked
*/
function _vehicle_spawn(vspawner, from)
{
	if(!isdefined(vspawner) || !vspawner.count)
	{
		return;
	}
	str_targetname = undefined;
	if(isdefined(vspawner.targetname))
	{
		str_targetname = vspawner.targetname + "_vh";
	}
	spawner::global_spawn_throttle(1);
	if(!isdefined(vspawner) || !vspawner.count)
	{
		return;
	}
	vehicle = vspawner spawnfromspawner(str_targetname, 1);
	if(!isdefined(vehicle))
	{
		return;
	}
	if(isdefined(vspawner.script_team))
	{
		vehicle setteam(vspawner.script_team);
	}
	if(isdefined(vehicle.lockheliheight))
	{
		vehicle setheliheightlock(vehicle.lockheliheight);
	}
	if(isdefined(vehicle.targetname))
	{
		level notify("new_vehicle_spawned" + vehicle.targetname, vehicle);
	}
	if(isdefined(vehicle.script_noteworthy))
	{
		level notify("new_vehicle_spawned" + vehicle.script_noteworthy, vehicle);
	}
	if(isdefined(vehicle.script_animname))
	{
		vehicle.animname = vehicle.script_animname;
	}
	if(isdefined(vehicle.script_animscripted))
	{
		vehicle.supportsanimscripted = vehicle.script_animscripted;
	}
	return vehicle;
}

/*
	Name: init
	Namespace: vehicle
	Checksum: 0xC6FECF87
	Offset: 0x3888
	Size: 0x8BC
	Parameters: 1
	Flags: None
*/
function init(vehicle)
{
	callback::callback(#"hash_bae82b92");
	vehicle useanimtree($generic);
	if(isdefined(vehicle.e_dyn_path))
	{
		vehicle.e_dyn_path linkto(vehicle);
	}
	vehicle flag::init("waiting_for_flag");
	vehicle.takedamage = !(isdefined(vehicle.script_godmode) && vehicle.script_godmode);
	vehicle.zerospeed = 1;
	if(!isdefined(vehicle.modeldummyon))
	{
		vehicle.modeldummyon = 0;
	}
	if(isdefined(vehicle.isphysicsvehicle) && vehicle.isphysicsvehicle)
	{
		if(isdefined(vehicle.script_brake) && vehicle.script_brake)
		{
			vehicle setbrake(1);
		}
	}
	type = vehicle.vehicletype;
	vehicle _vehicle_life();
	vehicle thread maingun_fx();
	vehicle.getoutrig = [];
	if(isdefined(level.vehicle_attachedmodels) && isdefined(level.vehicle_attachedmodels[type]))
	{
		rigs = level.vehicle_attachedmodels[type];
		strings = getarraykeys(rigs);
		for(i = 0; i < strings.size; i++)
		{
			vehicle.getoutrig[strings[i]] = undefined;
			vehicle.getoutriganimating[strings[i]] = 0;
		}
	}
	if(isdefined(self.script_badplace))
	{
		vehicle thread _vehicle_bad_place();
	}
	if(isdefined(vehicle.scriptbundlesettings))
	{
		settings = struct::get_script_bundle("vehiclecustomsettings", vehicle.scriptbundlesettings);
		if(isdefined(settings) && isdefined(settings.lightgroups_numgroups))
		{
			if(settings.lightgroups_numgroups >= 1 && settings.lightgroups_1_always_on === 1)
			{
				vehicle toggle_lights_group(1, 1);
			}
			if(settings.lightgroups_numgroups >= 2 && settings.lightgroups_2_always_on === 1)
			{
				vehicle toggle_lights_group(2, 1);
			}
			if(settings.lightgroups_numgroups >= 3 && settings.lightgroups_3_always_on === 1)
			{
				vehicle toggle_lights_group(3, 1);
			}
			if(settings.lightgroups_numgroups >= 4 && settings.lightgroups_4_always_on === 1)
			{
				vehicle toggle_lights_group(4, 1);
			}
		}
	}
	if(!vehicle is_cheap())
	{
		vehicle friendly_fire_shield();
	}
	levelstuff(vehicle);
	if(isdefined(vehicle.vehicleclass) && vehicle.vehicleclass == "artillery")
	{
		vehicle.disconnectpathonstop = undefined;
		self disconnect_paths(0);
	}
	else
	{
		vehicle.disconnectpathonstop = self.script_disconnectpaths;
	}
	vehicle.disconnectpathdetail = self.script_disconnectpath_detail;
	if(!isdefined(vehicle.disconnectpathdetail))
	{
		vehicle.disconnectpathdetail = 0;
	}
	if(!vehicle is_cheap() && (!(isdefined(vehicle.vehicleclass) && vehicle.vehicleclass == "plane")) && (!(isdefined(vehicle.vehicleclass) && vehicle.vehicleclass == "artillery")))
	{
		vehicle thread _disconnect_paths_when_stopped();
	}
	if(!isdefined(vehicle.script_nonmovingvehicle))
	{
		if(isdefined(vehicle.target))
		{
			path_start = getvehiclenode(vehicle.target, "targetname");
			if(!isdefined(path_start))
			{
				path_start = getent(vehicle.target, "targetname");
				if(!isdefined(path_start))
				{
					path_start = struct::get(vehicle.target, "targetname");
				}
			}
		}
		if(isdefined(path_start) && vehicle.vehicletype != "inc_base_jump_spotlight")
		{
			vehicle thread get_on_path(path_start);
		}
	}
	if(isdefined(vehicle.script_vehicleattackgroup))
	{
		vehicle thread attack_group_think();
	}
	/#
		if(isdefined(vehicle.script_recordent) && vehicle.script_recordent)
		{
			recordent(vehicle);
		}
	#/
	if(vehicle has_helicopter_dust_kickup())
	{
		if(!level.clientscripts)
		{
			vehicle thread aircraft_dust_kickup();
		}
	}
	/#
		vehicle thread debug_vehicle();
	#/
	vehicle thread vehicle_death::main();
	if(isdefined(vehicle.script_targetset) && vehicle.script_targetset == 1)
	{
		offset = (0, 0, 0);
		if(isdefined(vehicle.script_targetoffset))
		{
			offset = vehicle.script_targetoffset;
		}
		target_set(vehicle, offset);
	}
	if(isdefined(vehicle.script_vehicleavoidance) && vehicle.script_vehicleavoidance)
	{
		vehicle setvehicleavoidance(1);
	}
	vehicle enable_turrets();
	if(isdefined(level.vehiclespawncallbackthread))
	{
		level thread [[level.vehiclespawncallbackthread]](vehicle);
	}
}

/*
	Name: detach_getoutrigs
	Namespace: vehicle
	Checksum: 0x4C5BC4FF
	Offset: 0x4150
	Size: 0x96
	Parameters: 0
	Flags: None
*/
function detach_getoutrigs()
{
	if(!isdefined(self.getoutrig))
	{
		return;
	}
	if(!self.getoutrig.size)
	{
		return;
	}
	keys = getarraykeys(self.getoutrig);
	for(i = 0; i < keys.size; i++)
	{
		self.getoutrig[keys[i]] unlink();
	}
}

/*
	Name: enable_turrets
	Namespace: vehicle
	Checksum: 0x564C0A3C
	Offset: 0x41F0
	Size: 0x1FC
	Parameters: 1
	Flags: Linked
*/
function enable_turrets(veh = self)
{
	if(isdefined(self.script_enable_turret0) && self.script_enable_turret0)
	{
		veh turret::enable(0);
	}
	if(isdefined(self.script_enable_turret1) && self.script_enable_turret1)
	{
		veh turret::enable(1);
	}
	if(isdefined(self.script_enable_turret2) && self.script_enable_turret2)
	{
		veh turret::enable(2);
	}
	if(isdefined(self.script_enable_turret3) && self.script_enable_turret3)
	{
		veh turret::enable(3);
	}
	if(isdefined(self.script_enable_turret4) && self.script_enable_turret4)
	{
		veh turret::enable(4);
	}
	if(isdefined(self.script_enable_turret0) && !self.script_enable_turret0)
	{
		veh turret::disable(0);
	}
	if(isdefined(self.script_enable_turret1) && !self.script_enable_turret1)
	{
		veh turret::disable(1);
	}
	if(isdefined(self.script_enable_turret2) && !self.script_enable_turret2)
	{
		veh turret::disable(2);
	}
	if(isdefined(self.script_enable_turret3) && !self.script_enable_turret3)
	{
		veh turret::disable(3);
	}
	if(isdefined(self.script_enable_turret4) && !self.script_enable_turret4)
	{
		veh turret::disable(4);
	}
}

/*
	Name: enable_auto_disconnect_path
	Namespace: vehicle
	Checksum: 0xDB99331F
	Offset: 0x43F8
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function enable_auto_disconnect_path()
{
	self notify(#"kill_disconnect_paths_forever");
	self.disconnectpathonstop = 0;
	self thread _disconnect_paths_when_stopped();
}

/*
	Name: _disconnect_paths_when_stopped
	Namespace: vehicle
	Checksum: 0x15825851
	Offset: 0x4438
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function _disconnect_paths_when_stopped()
{
	if(ispathfinder(self))
	{
		self.disconnectpathonstop = 0;
		return;
	}
	if(isdefined(self.script_disconnectpaths) && !self.script_disconnectpaths)
	{
		self.disconnectpathonstop = 0;
		return;
	}
	self endon(#"death");
	self endon(#"kill_disconnect_paths_forever");
	wait(1);
	threshold = 3;
	while(isdefined(self))
	{
		if(lengthsquared(self.velocity) < (threshold * threshold))
		{
			if(self.disconnectpathonstop === 1)
			{
				self disconnect_paths(self.disconnectpathdetail);
				self notify(#"speed_zero_path_disconnect");
			}
			while(lengthsquared(self.velocity) < (threshold * threshold))
			{
				wait(0.05);
			}
		}
		self connect_paths();
		while(lengthsquared(self.velocity) >= (threshold * threshold))
		{
			wait(0.05);
		}
	}
}

/*
	Name: set_speed
	Namespace: vehicle
	Checksum: 0xD05836E7
	Offset: 0x45B8
	Size: 0x8C
	Parameters: 3
	Flags: Linked
*/
function set_speed(speed, rate, msg)
{
	if(self getspeedmph() == 0 && speed == 0)
	{
		return;
	}
	/#
		self thread debug_set_speed(speed, rate, msg);
	#/
	self setspeed(speed, rate);
}

/*
	Name: debug_set_speed
	Namespace: vehicle
	Checksum: 0x702521F7
	Offset: 0x4650
	Size: 0xDC
	Parameters: 3
	Flags: Linked
*/
function debug_set_speed(speed, rate, msg)
{
	/#
		self notify(#"hash_3790d3c8");
		self endon(#"hash_3790d3c8");
		self endon(#"hash_eeaec2a0");
		self endon(#"death");
		while(true)
		{
			while(getdvarstring("") != "")
			{
				print3d(self.origin + vectorscale((0, 0, 1), 192), "" + msg, (1, 1, 1), 1, 3);
				wait(0.05);
			}
			wait(0.5);
		}
	#/
}

/*
	Name: script_resume_speed
	Namespace: vehicle
	Checksum: 0x97563405
	Offset: 0x4738
	Size: 0x164
	Parameters: 2
	Flags: Linked
*/
function script_resume_speed(msg, rate)
{
	self endon(#"death");
	fsetspeed = 0;
	type = "resumespeed";
	if(!isdefined(self.resumemsgs))
	{
		self.resumemsgs = [];
	}
	if(isdefined(self.waitingforgate) && self.waitingforgate)
	{
		return;
	}
	if(isdefined(self.attacking) && self.attacking)
	{
		fsetspeed = self.attackspeed;
		type = "setspeed";
	}
	self.zerospeed = 0;
	if(fsetspeed == 0)
	{
		self.zerospeed = 1;
	}
	if(type == "resumespeed")
	{
		self resumespeed(rate);
	}
	else if(type == "setspeed")
	{
		self set_speed(fsetspeed, 15, "resume setspeed from attack");
	}
	self notify(#"hash_eeaec2a0");
	/#
		self thread debug_resume((msg + "") + type);
	#/
}

/*
	Name: debug_resume
	Namespace: vehicle
	Checksum: 0xE01AFE90
	Offset: 0x48A8
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function debug_resume(msg)
{
	/#
		if(getdvarstring("") == "")
		{
			return;
		}
		self endon(#"death");
		number = self.resumemsgs.size;
		self.resumemsgs[number] = msg;
		self thread print_resume_speed(gettime() + (3 * 1000));
		wait(3);
		newarray = [];
		for(i = 0; i < self.resumemsgs.size; i++)
		{
			if(i != number)
			{
				newarray[newarray.size] = self.resumemsgs[i];
			}
		}
		self.resumemsgs = newarray;
	#/
}

/*
	Name: print_resume_speed
	Namespace: vehicle
	Checksum: 0x8FB96E99
	Offset: 0x49C8
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function print_resume_speed(timer)
{
	self notify(#"newresumespeedmsag");
	self endon(#"newresumespeedmsag");
	self endon(#"death");
	while(gettime() < timer && isdefined(self.resumemsgs))
	{
		if(self.resumemsgs.size > 6)
		{
			start = self.resumemsgs.size - 5;
		}
		else
		{
			start = 0;
		}
		for(i = start; i < self.resumemsgs.size; i++)
		{
			position = i * 32;
			/#
				print3d(self.origin + (0, 0, position), "" + self.resumemsgs[i], (0, 1, 0), 1, 3);
			#/
		}
		wait(0.05);
	}
}

/*
	Name: god_on
	Namespace: vehicle
	Checksum: 0xA4A428F0
	Offset: 0x4B00
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function god_on()
{
	self.takedamage = 0;
}

/*
	Name: god_off
	Namespace: vehicle
	Checksum: 0x8D6DB416
	Offset: 0x4B18
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function god_off()
{
	self.takedamage = 1;
}

/*
	Name: get_normal_anim_time
	Namespace: vehicle
	Checksum: 0xF96FF649
	Offset: 0x4B30
	Size: 0x94
	Parameters: 1
	Flags: None
*/
function get_normal_anim_time(animation)
{
	animtime = self getanimtime(animation);
	animlength = getanimlength(animation);
	if(animtime == 0)
	{
		return 0;
	}
	return self getanimtime(animation) / getanimlength(animation);
}

/*
	Name: setup_dynamic_detour
	Namespace: vehicle
	Checksum: 0x4807908D
	Offset: 0x4BD0
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function setup_dynamic_detour(pathnode, get_func)
{
	prevnode = [[get_func]](pathnode.targetname);
	/#
		assert(isdefined(prevnode), "");
	#/
	prevnode.detoured = 0;
}

/*
	Name: array_2d_add
	Namespace: vehicle
	Checksum: 0x4C6502EE
	Offset: 0x4C48
	Size: 0x5C
	Parameters: 3
	Flags: Linked
*/
function array_2d_add(array, firstelem, newelem)
{
	if(!isdefined(array[firstelem]))
	{
		array[firstelem] = [];
	}
	array[firstelem][array[firstelem].size] = newelem;
	return array;
}

/*
	Name: is_node_script_origin
	Namespace: vehicle
	Checksum: 0x631496FF
	Offset: 0x4CB0
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function is_node_script_origin(pathnode)
{
	return isdefined(pathnode.classname) && pathnode.classname == "script_origin";
}

/*
	Name: node_trigger_process
	Namespace: vehicle
	Checksum: 0xA833E79
	Offset: 0x4CF0
	Size: 0x324
	Parameters: 0
	Flags: Linked
*/
function node_trigger_process()
{
	processtrigger = 0;
	if(isdefined(self.spawnflags) && (self.spawnflags & 1) == 1)
	{
		if(isdefined(self.script_crashtype))
		{
			level.vehicle_crashpaths[level.vehicle_crashpaths.size] = self;
		}
		level.vehicle_startnodes[level.vehicle_startnodes.size] = self;
	}
	if(isdefined(self.script_vehicledetour) && isdefined(self.targetname))
	{
		get_func = undefined;
		if(isdefined(get_from_entity(self.targetname)))
		{
			get_func = &get_from_entity_target;
		}
		if(isdefined(get_from_spawnstruct(self.targetname)))
		{
			get_func = &get_from_spawnstruct_target;
		}
		if(isdefined(get_func))
		{
			setup_dynamic_detour(self, get_func);
			processtrigger = 1;
		}
		else
		{
			setup_groundnode_detour(self);
		}
		level.vehicle_detourpaths = array_2d_add(level.vehicle_detourpaths, self.script_vehicledetour, self);
		/#
			if(level.vehicle_detourpaths[self.script_vehicledetour].size > 2)
			{
				println("", self.script_vehicledetour);
			}
		#/
	}
	if(isdefined(self.script_gatetrigger))
	{
		level.vehicle_gatetrigger = array_2d_add(level.vehicle_gatetrigger, self.script_gatetrigger, self);
		self.gateopen = 0;
	}
	if(isdefined(self.script_flag_set))
	{
		if(!isdefined(level.flag) || !isdefined(level.flag[self.script_flag_set]))
		{
			level flag::init(self.script_flag_set);
		}
	}
	if(isdefined(self.script_flag_clear))
	{
		if(!level flag::exists(self.script_flag_clear))
		{
			level flag::init(self.script_flag_clear);
		}
	}
	if(isdefined(self.script_flag_wait))
	{
		if(!level flag::exists(self.script_flag_wait))
		{
			level flag::init(self.script_flag_wait);
		}
	}
	if(isdefined(self.script_vehiclespawngroup) || isdefined(self.script_vehiclestartmove) || isdefined(self.script_gatetrigger) || isdefined(self.script_vehiclegroupdelete))
	{
		processtrigger = 1;
	}
	if(processtrigger)
	{
		add_proccess_trigger(self);
	}
}

/*
	Name: setup_triggers
	Namespace: vehicle
	Checksum: 0xFE7C03FF
	Offset: 0x5020
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function setup_triggers()
{
	level.vehicle_processtriggers = [];
	triggers = [];
	triggers = arraycombine(getallvehiclenodes(), getentarray("script_origin", "classname"), 1, 0);
	triggers = arraycombine(triggers, level.struct, 1, 0);
	triggers = arraycombine(triggers, trigger::get_all(), 1, 0);
	array::thread_all(triggers, &node_trigger_process);
}

/*
	Name: setup_nodes
	Namespace: vehicle
	Checksum: 0x5AAB4E77
	Offset: 0x5118
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function setup_nodes()
{
	a_nodes = getallvehiclenodes();
	foreach(node in a_nodes)
	{
		if(isdefined(node.script_flag_set))
		{
			if(!level flag::exists(node.script_flag_set))
			{
				level flag::init(node.script_flag_set);
			}
		}
	}
}

/*
	Name: is_node_script_struct
	Namespace: vehicle
	Checksum: 0x71242B34
	Offset: 0x5210
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function is_node_script_struct(node)
{
	if(!isdefined(node.targetname))
	{
		return 0;
	}
	return isdefined(struct::get(node.targetname, "targetname"));
}

/*
	Name: setup_spawners
	Namespace: vehicle
	Checksum: 0xD30A2687
	Offset: 0x5268
	Size: 0x3AA
	Parameters: 1
	Flags: Linked
*/
function setup_spawners(a_veh_spawners)
{
	spawnvehicles = [];
	groups = [];
	foreach(spawner in a_veh_spawners)
	{
		if(isdefined(spawner.script_vehiclespawngroup))
		{
			if(!isdefined(spawnvehicles[spawner.script_vehiclespawngroup]))
			{
				spawnvehicles[spawner.script_vehiclespawngroup] = [];
			}
			else if(!isarray(spawnvehicles[spawner.script_vehiclespawngroup]))
			{
				spawnvehicles[spawner.script_vehiclespawngroup] = array(spawnvehicles[spawner.script_vehiclespawngroup]);
			}
			spawnvehicles[spawner.script_vehiclespawngroup][spawnvehicles[spawner.script_vehiclespawngroup].size] = spawner;
			addgroup[0] = spawner.script_vehiclespawngroup;
			groups = arraycombine(groups, addgroup, 0, 0);
		}
	}
	waittillframeend();
	foreach(spawngroup in groups)
	{
		a_veh_spawners = spawnvehicles[spawngroup];
		level.vehicle_spawners[spawngroup] = [];
		foreach(sp in a_veh_spawners)
		{
			if(sp.count < 1)
			{
				sp.count = 1;
			}
			set_variables(sp);
			if(!isdefined(level.vehicle_spawners[spawngroup]))
			{
				level.vehicle_spawners[spawngroup] = [];
			}
			else if(!isarray(level.vehicle_spawners[spawngroup]))
			{
				level.vehicle_spawners[spawngroup] = array(level.vehicle_spawners[spawngroup]);
			}
			level.vehicle_spawners[spawngroup][level.vehicle_spawners[spawngroup].size] = sp;
		}
		level thread _spawn_group(spawngroup);
	}
}

/*
	Name: _vehicle_life
	Namespace: vehicle
	Checksum: 0x32ABBB8B
	Offset: 0x5620
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function _vehicle_life()
{
	if(isdefined(self.destructibledef))
	{
		self.health = 99999;
	}
	else
	{
		type = self.vehicletype;
		if(isdefined(self.script_startinghealth))
		{
			self.health = self.script_startinghealth;
		}
		else
		{
			if(self.healthdefault == -1)
			{
				return;
			}
			self.health = self.healthdefault;
		}
	}
}

/*
	Name: _vehicle_load_assets
	Namespace: vehicle
	Checksum: 0x99EC1590
	Offset: 0x56A8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function _vehicle_load_assets()
{
}

/*
	Name: is_cheap
	Namespace: vehicle
	Checksum: 0xA4671E65
	Offset: 0x56B8
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function is_cheap()
{
	if(!isdefined(self.script_cheap))
	{
		return false;
	}
	if(!self.script_cheap)
	{
		return false;
	}
	return true;
}

/*
	Name: has_helicopter_dust_kickup
	Namespace: vehicle
	Checksum: 0x77FC3AAD
	Offset: 0x56E8
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function has_helicopter_dust_kickup()
{
	if(!(isdefined(self.vehicleclass) && self.vehicleclass == "plane"))
	{
		return false;
	}
	if(is_cheap())
	{
		return false;
	}
	return true;
}

/*
	Name: play_looped_fx_on_tag
	Namespace: vehicle
	Checksum: 0x7EA7E806
	Offset: 0x5738
	Size: 0xCE
	Parameters: 3
	Flags: None
*/
function play_looped_fx_on_tag(effect, durration, tag)
{
	emodel = get_dummy();
	effectorigin = sys::spawn("script_origin", emodel.origin);
	self endon(#"fire_extinguish");
	thread _play_looped_fx_on_tag_origin_update(tag, effectorigin);
	while(true)
	{
		playfx(effect, effectorigin.origin, effectorigin.upvec);
		wait(durration);
	}
}

/*
	Name: _play_looped_fx_on_tag_origin_update
	Namespace: vehicle
	Checksum: 0x235AAEC7
	Offset: 0x5810
	Size: 0x1B4
	Parameters: 2
	Flags: Linked
*/
function _play_looped_fx_on_tag_origin_update(tag, effectorigin)
{
	effectorigin.angles = self gettagangles(tag);
	effectorigin.origin = self gettagorigin(tag);
	effectorigin.forwardvec = anglestoforward(effectorigin.angles);
	effectorigin.upvec = anglestoup(effectorigin.angles);
	while(isdefined(self) && self.classname == "script_vehicle" && self getspeedmph() > 0)
	{
		emodel = get_dummy();
		effectorigin.angles = emodel gettagangles(tag);
		effectorigin.origin = emodel gettagorigin(tag);
		effectorigin.forwardvec = anglestoforward(effectorigin.angles);
		effectorigin.upvec = anglestoup(effectorigin.angles);
		wait(0.05);
	}
}

/*
	Name: setup_dvars
	Namespace: vehicle
	Checksum: 0xA2CFA7DC
	Offset: 0x59D0
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function setup_dvars()
{
	/#
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
	#/
}

/*
	Name: setup_level_vars
	Namespace: vehicle
	Checksum: 0xC7FF180A
	Offset: 0x5A78
	Size: 0x2A4
	Parameters: 0
	Flags: Linked
*/
function setup_level_vars()
{
	level.vehicle_resumespeed = 5;
	level.vehicle_deletegroup = [];
	level.vehicle_spawngroup = [];
	level.vehicle_startmovegroup = [];
	level.vehicle_deathswitch = [];
	level.vehicle_gatetrigger = [];
	level.vehicle_crashpaths = [];
	level.vehicle_link = [];
	level.vehicle_detourpaths = [];
	level.vehicle_startnodes = [];
	level.vehicle_spawners = [];
	level.a_vehicle_types = [];
	level.a_vehicle_targetnames = [];
	level.vehicle_walkercount = [];
	level.helicopter_crash_locations = getentarray("helicopter_crash_location", "targetname");
	level.playervehicle = sys::spawn("script_origin", (0, 0, 0));
	level.playervehiclenone = level.playervehicle;
	if(!isdefined(level.vehicle_death_thread))
	{
		level.vehicle_death_thread = [];
	}
	if(!isdefined(level.vehicle_driveidle))
	{
		level.vehicle_driveidle = [];
	}
	if(!isdefined(level.vehicle_driveidle_r))
	{
		level.vehicle_driveidle_r = [];
	}
	if(!isdefined(level.attack_origin_condition_threadd))
	{
		level.attack_origin_condition_threadd = [];
	}
	if(!isdefined(level.vehiclefireanim))
	{
		level.vehiclefireanim = [];
	}
	if(!isdefined(level.vehiclefireanim_settle))
	{
		level.vehiclefireanim_settle = [];
	}
	if(!isdefined(level.vehicle_hasname))
	{
		level.vehicle_hasname = [];
	}
	if(!isdefined(level.vehicle_turret_requiresrider))
	{
		level.vehicle_turret_requiresrider = [];
	}
	if(!isdefined(level.vehicle_isstationary))
	{
		level.vehicle_isstationary = [];
	}
	if(!isdefined(level.vehicle_compassicon))
	{
		level.vehicle_compassicon = [];
	}
	if(!isdefined(level.vehicle_unloadgroups))
	{
		level.vehicle_unloadgroups = [];
	}
	if(!isdefined(level.vehicle_unloadwhenattacked))
	{
		level.vehicle_unloadwhenattacked = [];
	}
	if(!isdefined(level.vehicle_deckdust))
	{
		level.vehicle_deckdust = [];
	}
	if(!isdefined(level.vehicle_types))
	{
		level.vehicle_types = [];
	}
	if(!isdefined(level.vehicle_compass_types))
	{
		level.vehicle_compass_types = [];
	}
	if(!isdefined(level.vehicle_bulletshield))
	{
		level.vehicle_bulletshield = [];
	}
	if(!isdefined(level.vehicle_death_badplace))
	{
		level.vehicle_death_badplace = [];
	}
}

/*
	Name: attacker_is_on_my_team
	Namespace: vehicle
	Checksum: 0x2352A77B
	Offset: 0x5D28
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function attacker_is_on_my_team(attacker)
{
	if(isdefined(attacker) && isdefined(attacker.team) && isdefined(self.team) && attacker.team == self.team)
	{
		return true;
	}
	return false;
}

/*
	Name: attacker_troop_is_on_my_team
	Namespace: vehicle
	Checksum: 0x92051792
	Offset: 0x5D90
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function attacker_troop_is_on_my_team(attacker)
{
	if(isdefined(self.team) && self.team == "allies" && isdefined(attacker) && isdefined(level.player) && attacker == level.player)
	{
		return true;
	}
	if(isai(attacker) && attacker.team == self.team)
	{
		return true;
	}
	return false;
}

/*
	Name: bullet_shielded
	Namespace: vehicle
	Checksum: 0xF133E7AE
	Offset: 0x5E38
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function bullet_shielded(type)
{
	if(!isdefined(self.script_bulletshield))
	{
		return false;
	}
	type = tolower(type);
	if(!isdefined(type) || !issubstr(type, "bullet"))
	{
		return false;
	}
	if(self.script_bulletshield)
	{
		return true;
	}
	return false;
}

/*
	Name: friendly_fire_shield
	Namespace: vehicle
	Checksum: 0xA8936637
	Offset: 0x5EC8
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function friendly_fire_shield()
{
	self.friendlyfire_shield = 1;
	if(isdefined(level.vehicle_bulletshield[self.vehicletype]) && !isdefined(self.script_bulletshield))
	{
		self.script_bulletshield = level.vehicle_bulletshield[self.vehicletype];
	}
}

/*
	Name: friendly_fire_shield_callback
	Namespace: vehicle
	Checksum: 0x1420F818
	Offset: 0x5F20
	Size: 0xC6
	Parameters: 3
	Flags: None
*/
function friendly_fire_shield_callback(attacker, amount, type)
{
	if(!isdefined(self.friendlyfire_shield) || !self.friendlyfire_shield)
	{
		return false;
	}
	if(!isdefined(attacker) && self.team != "neutral" || attacker_is_on_my_team(attacker) || attacker_troop_is_on_my_team(attacker) || is_destructible() || bullet_shielded(type))
	{
		return true;
	}
	return false;
}

/*
	Name: _vehicle_bad_place
	Namespace: vehicle
	Checksum: 0xED5B4321
	Offset: 0x5FF0
	Size: 0x206
	Parameters: 0
	Flags: Linked
*/
function _vehicle_bad_place()
{
	self endon(#"kill_badplace_forever");
	self endon(#"death");
	self endon(#"delete");
	if(isdefined(level.custombadplacethread))
	{
		self thread [[level.custombadplacethread]]();
		return;
	}
	hasturret = isdefined(self.turretweapon) && self.turretweapon != level.weaponnone;
	while(true)
	{
		if(!self.script_badplace)
		{
			while(!self.script_badplace)
			{
				wait(0.5);
			}
		}
		speed = self getspeedmph();
		if(speed <= 0)
		{
			wait(0.5);
			continue;
		}
		if(speed < 5)
		{
			bp_radius = 200;
		}
		else
		{
			if(speed > 5 && speed < 8)
			{
				bp_radius = 350;
			}
			else
			{
				bp_radius = 500;
			}
		}
		if(isdefined(self.badplacemodifier))
		{
			bp_radius = bp_radius * self.badplacemodifier;
		}
		v_turret_angles = self gettagangles("tag_turret");
		if(hasturret && isdefined(v_turret_angles))
		{
			bp_direction = anglestoforward(v_turret_angles);
		}
		else
		{
			bp_direction = anglestoforward(self.angles);
		}
		wait(0.5 + 0.05);
	}
}

/*
	Name: get_vehiclenode_any_dynamic
	Namespace: vehicle
	Checksum: 0x507AB904
	Offset: 0x6200
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function get_vehiclenode_any_dynamic(target)
{
	path_start = getvehiclenode(target, "targetname");
	if(!isdefined(path_start))
	{
		path_start = getent(target, "targetname");
	}
	else if(isdefined(self.vehicleclass) && self.vehicleclass == "plane")
	{
		/#
			println("" + path_start.targetname);
			println("" + self.vehicletype);
		#/
		/#
			assertmsg("");
		#/
	}
	if(!isdefined(path_start))
	{
		path_start = struct::get(target, "targetname");
	}
	return path_start;
}

/*
	Name: resume_path_vehicle
	Namespace: vehicle
	Checksum: 0xF0C85CD4
	Offset: 0x6338
	Size: 0x84
	Parameters: 0
	Flags: None
*/
function resume_path_vehicle()
{
	if(isdefined(self.currentnode.target))
	{
		node = get_vehiclenode_any_dynamic(self.currentnode.target);
	}
	if(isdefined(node))
	{
		self resumespeed(35);
		paths(node);
	}
}

/*
	Name: land
	Namespace: vehicle
	Checksum: 0x446920EB
	Offset: 0x63C8
	Size: 0xE0
	Parameters: 0
	Flags: None
*/
function land()
{
	self setneargoalnotifydist(2);
	self sethoverparams(0, 0, 10);
	self cleargoalyaw();
	self settargetyaw((0, self.angles[1], 0)[1]);
	self set_goal_pos(bullettrace(self.origin, self.origin + (vectorscale((0, 0, -1), 100000)), 0, self)["position"], 1);
	self waittill(#"goal");
}

/*
	Name: set_goal_pos
	Namespace: vehicle
	Checksum: 0x31402E36
	Offset: 0x64B0
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function set_goal_pos(origin, bstop)
{
	if(self.health <= 0)
	{
		return;
	}
	if(isdefined(self.originheightoffset))
	{
		origin = origin + (0, 0, self.originheightoffset);
	}
	self setvehgoalpos(origin, bstop);
}

/*
	Name: liftoff
	Namespace: vehicle
	Checksum: 0x745AA242
	Offset: 0x6520
	Size: 0x88
	Parameters: 1
	Flags: None
*/
function liftoff(height = 512)
{
	dest = self.origin + (0, 0, height);
	self setneargoalnotifydist(10);
	self set_goal_pos(dest, 1);
	self waittill(#"goal");
}

/*
	Name: wait_till_stable
	Namespace: vehicle
	Checksum: 0x760857E7
	Offset: 0x65B0
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function wait_till_stable()
{
	timer = gettime() + 400;
	while(isdefined(self))
	{
		if(self.angles[0] > 12 || self.angles[0] < -1 * 12)
		{
			timer = gettime() + 400;
		}
		if(self.angles[2] > 12 || self.angles[2] < -1 * 12)
		{
			timer = gettime() + 400;
		}
		if(gettime() > timer)
		{
			break;
		}
		wait(0.05);
	}
}

/*
	Name: unload_node
	Namespace: vehicle
	Checksum: 0x4BA1EDCA
	Offset: 0x6688
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function unload_node(node)
{
	if(isdefined(self.custom_unload_function))
	{
		[[self.custom_unload_function]]();
		return;
	}
	pause_path();
	if(isdefined(self.vehicleclass) && self.vehicleclass == "plane")
	{
		wait_till_stable();
	}
	else if(isdefined(self.vehicleclass) && self.vehicleclass == "helicopter")
	{
		self sethoverparams(0, 0, 10);
		wait_till_stable();
	}
	if(node is_unload_node())
	{
		unload(node.script_unload);
	}
}

/*
	Name: is_unload_node
	Namespace: vehicle
	Checksum: 0xB5E6094F
	Offset: 0x6788
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function is_unload_node()
{
	return isdefined(self.script_unload) && self.script_unload != "none";
}

/*
	Name: unload_node_helicopter
	Namespace: vehicle
	Checksum: 0x528EE15D
	Offset: 0x67B0
	Size: 0x214
	Parameters: 1
	Flags: Linked
*/
function unload_node_helicopter(node)
{
	if(isdefined(self.custom_unload_function))
	{
		self thread [[self.custom_unload_function]]();
	}
	self sethoverparams(0, 0, 10);
	goal = self.nextnode.origin;
	start = self.nextnode.origin;
	end = start - vectorscale((0, 0, 1), 10000);
	trace = bullettrace(start, end, 0, undefined, 1);
	if(trace["fraction"] <= 1)
	{
		goal = (trace["position"][0], trace["position"][1], trace["position"][2] + self.fastropeoffset);
	}
	drop_offset_tag = "tag_fastrope_ri";
	if(isdefined(self.drop_offset_tag))
	{
		drop_offset_tag = self.drop_offset_tag;
	}
	drop_offset = self gettagorigin("tag_origin") - self gettagorigin(drop_offset_tag);
	goal = goal + (drop_offset[0], drop_offset[1], 0);
	self setvehgoalpos(goal, 1);
	self waittill(#"goal");
	self notify(#"unload", self.nextnode.script_unload);
	self waittill(#"unloaded");
}

/*
	Name: detach_path
	Namespace: vehicle
	Checksum: 0x7F7F9E4D
	Offset: 0x69D0
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function detach_path()
{
	self.attachedpath = undefined;
	self notify(#"newpath");
	self setgoalyaw((0, self.angles[1], 0)[1]);
	self setvehgoalpos(self.origin + vectorscale((0, 0, 1), 4), 1);
}

/*
	Name: setup_targetname_spawners
	Namespace: vehicle
	Checksum: 0x6CE3534A
	Offset: 0x6A58
	Size: 0x20E
	Parameters: 0
	Flags: Linked
*/
function setup_targetname_spawners()
{
	level.vehicle_targetname_array = [];
	vehicles = getentarray("script_vehicle", "classname");
	n_highest_group = 0;
	foreach(vh in vehicles)
	{
		if(isdefined(vh.script_vehiclespawngroup))
		{
			n_spawn_group = int(vh.script_vehiclespawngroup);
			if(n_spawn_group > n_highest_group)
			{
				n_highest_group = n_spawn_group;
			}
		}
	}
	for(i = 0; i < vehicles.size; i++)
	{
		vehicle = vehicles[i];
		if(isdefined(vehicle.targetname) && isvehiclespawner(vehicle))
		{
			if(!isdefined(vehicle.script_vehiclespawngroup))
			{
				n_highest_group++;
				vehicle.script_vehiclespawngroup = n_highest_group;
			}
			if(!isdefined(level.vehicle_targetname_array[vehicle.targetname]))
			{
				level.vehicle_targetname_array[vehicle.targetname] = [];
			}
			level.vehicle_targetname_array[vehicle.targetname][vehicle.script_vehiclespawngroup] = 1;
		}
	}
}

/*
	Name: simple_spawn
	Namespace: vehicle
	Checksum: 0x5F3AA380
	Offset: 0x6C70
	Size: 0x182
	Parameters: 2
	Flags: Linked
*/
function simple_spawn(name, b_supress_assert = 0)
{
	/#
		assert(b_supress_assert || isdefined(level.vehicle_targetname_array[name]), "" + name);
	#/
	vehicles = [];
	if(isdefined(level.vehicle_targetname_array[name]))
	{
		array = level.vehicle_targetname_array[name];
		if(array.size > 0)
		{
			keys = getarraykeys(array);
			foreach(key in keys)
			{
				vehicle_array = _scripted_spawn(key);
				vehicles = arraycombine(vehicles, vehicle_array, 1, 0);
			}
		}
	}
	return vehicles;
}

/*
	Name: simple_spawn_single
	Namespace: vehicle
	Checksum: 0x6429205E
	Offset: 0x6E00
	Size: 0xBC
	Parameters: 2
	Flags: None
*/
function simple_spawn_single(name, b_supress_assert = 0)
{
	vehicle_array = simple_spawn(name, b_supress_assert);
	/#
		assert(b_supress_assert || vehicle_array.size == 1, ((("" + name) + "") + vehicle_array.size) + "");
	#/
	if(vehicle_array.size > 0)
	{
		return vehicle_array[0];
	}
}

/*
	Name: simple_spawn_single_and_drive
	Namespace: vehicle
	Checksum: 0xD2315509
	Offset: 0x6EC8
	Size: 0x9C
	Parameters: 1
	Flags: None
*/
function simple_spawn_single_and_drive(name)
{
	vehiclearray = simple_spawn(name);
	/#
		assert(vehiclearray.size == 1, ((("" + name) + "") + vehiclearray.size) + "");
	#/
	vehiclearray[0] thread go_path();
	return vehiclearray[0];
}

/*
	Name: simple_spawn_and_drive
	Namespace: vehicle
	Checksum: 0x63B8258
	Offset: 0x6F70
	Size: 0x7A
	Parameters: 1
	Flags: None
*/
function simple_spawn_and_drive(name)
{
	vehiclearray = simple_spawn(name);
	for(i = 0; i < vehiclearray.size; i++)
	{
		vehiclearray[i] thread go_path();
	}
	return vehiclearray;
}

/*
	Name: spawn
	Namespace: vehicle
	Checksum: 0xA4535D12
	Offset: 0x6FF8
	Size: 0xDA
	Parameters: 6
	Flags: None
*/
function spawn(modelname, targetname, vehicletype, origin, angles, destructibledef)
{
	/#
		assert(isdefined(targetname));
	#/
	/#
		assert(isdefined(vehicletype));
	#/
	/#
		assert(isdefined(origin));
	#/
	/#
		assert(isdefined(angles));
	#/
	return spawnvehicle(vehicletype, origin, angles, targetname, destructibledef);
}

/*
	Name: aircraft_dust_kickup
	Namespace: vehicle
	Checksum: 0x55371F96
	Offset: 0x70E0
	Size: 0x390
	Parameters: 1
	Flags: Linked
*/
function aircraft_dust_kickup(model)
{
	self endon(#"death");
	self endon(#"death_finished");
	self endon(#"stop_kicking_up_dust");
	/#
		assert(isdefined(self.vehicletype));
	#/
	dotracethisframe = 3;
	repeatrate = 1;
	trace = undefined;
	d = undefined;
	trace_ent = self;
	if(isdefined(model))
	{
		trace_ent = model;
	}
	while(isdefined(self))
	{
		if(repeatrate <= 0)
		{
			repeatrate = 1;
		}
		wait(repeatrate);
		if(!isdefined(self))
		{
			return;
		}
		dotracethisframe--;
		if(dotracethisframe <= 0)
		{
			dotracethisframe = 3;
			trace = bullettrace(trace_ent.origin, trace_ent.origin - vectorscale((0, 0, 1), 100000), 0, trace_ent);
			d = distance(trace_ent.origin, trace["position"]);
			repeatrate = (d - 350) / (1200 - 350) * (0.15 - 0.05) + 0.05;
		}
		if(!isdefined(trace))
		{
			continue;
		}
		/#
			assert(isdefined(d));
		#/
		if(d > 1200)
		{
			repeatrate = 1;
			continue;
		}
		if(isdefined(trace["entity"]))
		{
			repeatrate = 1;
			continue;
		}
		if(!isdefined(trace["position"]))
		{
			repeatrate = 1;
			continue;
		}
		if(!isdefined(trace["surfacetype"]))
		{
			trace["surfacetype"] = "dirt";
		}
		/#
			assert(isdefined(level._vehicle_effect[self.vehicletype]), self.vehicletype + "");
		#/
		/#
			assert(isdefined(level._vehicle_effect[self.vehicletype][trace[""]]), "" + trace[""]);
		#/
		if(level._vehicle_effect[self.vehicletype][trace["surfacetype"]] != -1)
		{
			playfx(level._vehicle_effect[self.vehicletype][trace["surfacetype"]], trace["position"]);
		}
	}
}

/*
	Name: impact_fx
	Namespace: vehicle
	Checksum: 0x1DE37D03
	Offset: 0x7478
	Size: 0x1C4
	Parameters: 2
	Flags: Linked
*/
function impact_fx(fxname, surfacetypes)
{
	if(isdefined(fxname))
	{
		body = self gettagorigin("tag_body");
		if(!isdefined(body))
		{
			body = self.origin + vectorscale((0, 0, 1), 10);
		}
		trace = bullettrace(body, body - (0, 0, 2 * self.radius), 0, self);
		if(trace["fraction"] < 1 && !isdefined(trace["entity"]) && (!isdefined(surfacetypes) || array::contains(surfacetypes, trace["surfacetype"])))
		{
			pos = 0.5 * (self.origin + trace["position"]);
			up = 0.5 * (trace["normal"] + anglestoup(self.angles));
			forward = anglestoforward(self.angles);
			playfx(fxname, pos, up, forward);
		}
	}
}

/*
	Name: maingun_fx
	Namespace: vehicle
	Checksum: 0x1F593402
	Offset: 0x7648
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function maingun_fx()
{
	if(!isdefined(level.vehicle_deckdust[self.model]))
	{
		return;
	}
	self endon(#"death");
	while(true)
	{
		self waittill(#"weapon_fired");
		playfxontag(level.vehicle_deckdust[self.model], self, "tag_engine_exhaust");
		barrel_origin = self gettagorigin("tag_flash");
		ground = physicstrace(barrel_origin, barrel_origin + (vectorscale((0, 0, -1), 128)));
		physicsexplosionsphere(ground, 192, 100, 1);
	}
}

/*
	Name: lights_on
	Namespace: vehicle
	Checksum: 0xD5EB0447
	Offset: 0x7748
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function lights_on(team)
{
	if(isdefined(team))
	{
		if(team == "allies")
		{
			self clientfield::set("toggle_lights", 2);
		}
		else if(team == "axis")
		{
			self clientfield::set("toggle_lights", 3);
		}
	}
	else
	{
		self clientfield::set("toggle_lights", 0);
	}
}

/*
	Name: lights_off
	Namespace: vehicle
	Checksum: 0xCAE79F65
	Offset: 0x77F8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function lights_off()
{
	self clientfield::set("toggle_lights", 1);
}

/*
	Name: toggle_lights_group
	Namespace: vehicle
	Checksum: 0x6A105985
	Offset: 0x7828
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function toggle_lights_group(groupid, on)
{
	bit = 1;
	if(!on)
	{
		bit = 0;
	}
	self clientfield::set("toggle_lights_group" + groupid, bit);
}

/*
	Name: toggle_ambient_anim_group
	Namespace: vehicle
	Checksum: 0x7C8D6446
	Offset: 0x7890
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function toggle_ambient_anim_group(groupid, on)
{
	bit = 1;
	if(!on)
	{
		bit = 0;
	}
	self clientfield::set("toggle_ambient_anim_group" + groupid, bit);
}

/*
	Name: do_death_fx
	Namespace: vehicle
	Checksum: 0x56705A84
	Offset: 0x78F8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function do_death_fx()
{
	deathfxtype = (self.died_by_emp === 1 ? 2 : 1);
	self clientfield::set("deathfx", deathfxtype);
	self stopsounds();
}

/*
	Name: toggle_emp_fx
	Namespace: vehicle
	Checksum: 0xBEBA4671
	Offset: 0x7968
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function toggle_emp_fx(on)
{
	self clientfield::set("toggle_emp_fx", on);
}

/*
	Name: toggle_burn_fx
	Namespace: vehicle
	Checksum: 0x64C99A8C
	Offset: 0x79A0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function toggle_burn_fx(on)
{
	self clientfield::set("toggle_burn_fx", on);
}

/*
	Name: do_death_dynents
	Namespace: vehicle
	Checksum: 0x924B7C73
	Offset: 0x79D8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function do_death_dynents(special_status = 1)
{
	/#
		assert(special_status >= 0 && special_status <= 3);
	#/
	self clientfield::set("spawn_death_dynents", special_status);
}

/*
	Name: do_gib_dynents
	Namespace: vehicle
	Checksum: 0x3BC37FF9
	Offset: 0x7A50
	Size: 0xBE
	Parameters: 0
	Flags: Linked
*/
function do_gib_dynents()
{
	self clientfield::set("spawn_gib_dynents", 1);
	numdynents = 2;
	for(i = 0; i < numdynents; i++)
	{
		hidetag = getstructfield(self.settings, "servo_gib_tag" + i);
		if(isdefined(hidetag))
		{
			self hidepart(hidetag, "", 1);
		}
	}
}

/*
	Name: set_alert_fx_level
	Namespace: vehicle
	Checksum: 0x71F0A60B
	Offset: 0x7B18
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function set_alert_fx_level(alert_level)
{
	self clientfield::set("alert_level", alert_level);
}

/*
	Name: should_update_damage_fx_level
	Namespace: vehicle
	Checksum: 0x16A15E96
	Offset: 0x7B50
	Size: 0x3AC
	Parameters: 3
	Flags: Linked
*/
function should_update_damage_fx_level(currenthealth, damage, maxhealth)
{
	settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	if(!isdefined(settings))
	{
		return 0;
	}
	currentratio = math::clamp(float(currenthealth) / float(maxhealth), 0, 1);
	afterdamageratio = math::clamp((float(currenthealth - damage)) / float(maxhealth), 0, 1);
	currentlevel = undefined;
	afterdamagelevel = undefined;
	switch((isdefined(settings.damagestate_numstates) ? settings.damagestate_numstates : 0))
	{
		case 6:
		{
			if(settings.damagestate_lv6_ratio >= afterdamageratio)
			{
				afterdamagelevel = 6;
				currentlevel = 6;
				if(settings.damagestate_lv6_ratio < currentratio)
				{
					currentlevel = 5;
				}
				break;
			}
		}
		case 5:
		{
			if(settings.damagestate_lv5_ratio >= afterdamageratio)
			{
				afterdamagelevel = 5;
				currentlevel = 5;
				if(settings.damagestate_lv5_ratio < currentratio)
				{
					currentlevel = 4;
				}
				break;
			}
		}
		case 4:
		{
			if(settings.damagestate_lv4_ratio >= afterdamageratio)
			{
				afterdamagelevel = 4;
				currentlevel = 4;
				if(settings.damagestate_lv4_ratio < currentratio)
				{
					currentlevel = 3;
				}
				break;
			}
		}
		case 3:
		{
			if(settings.damagestate_lv3_ratio >= afterdamageratio)
			{
				afterdamagelevel = 3;
				currentlevel = 3;
				if(settings.damagestate_lv3_ratio < currentratio)
				{
					currentlevel = 2;
				}
				break;
			}
		}
		case 2:
		{
			if(settings.damagestate_lv2_ratio >= afterdamageratio)
			{
				afterdamagelevel = 2;
				currentlevel = 2;
				if(settings.damagestate_lv2_ratio < currentratio)
				{
					currentlevel = 1;
				}
				break;
			}
		}
		case 1:
		{
			if(settings.damagestate_lv1_ratio >= afterdamageratio)
			{
				afterdamagelevel = 1;
				currentlevel = 1;
				if(settings.damagestate_lv1_ratio < currentratio)
				{
					currentlevel = 0;
				}
				break;
			}
		}
		default:
		{
		}
	}
	if(!isdefined(currentlevel) || !isdefined(afterdamagelevel))
	{
		return 0;
	}
	if(currentlevel != afterdamagelevel)
	{
		return afterdamagelevel;
	}
	return 0;
}

/*
	Name: update_damage_fx_level
	Namespace: vehicle
	Checksum: 0x2D151FA6
	Offset: 0x7F08
	Size: 0x74
	Parameters: 3
	Flags: None
*/
function update_damage_fx_level(currenthealth, damage, maxhealth)
{
	newdamagelevel = should_update_damage_fx_level(currenthealth, damage, maxhealth);
	if(newdamagelevel > 0)
	{
		self set_damage_fx_level(newdamagelevel);
		return true;
	}
	return false;
}

/*
	Name: set_damage_fx_level
	Namespace: vehicle
	Checksum: 0x89959B06
	Offset: 0x7F88
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function set_damage_fx_level(damage_level)
{
	self clientfield::set("damage_level", damage_level);
}

/*
	Name: build_drive
	Namespace: vehicle
	Checksum: 0x2F931624
	Offset: 0x7FC0
	Size: 0xA6
	Parameters: 4
	Flags: None
*/
function build_drive(forward, reverse, normalspeed = 10, rate)
{
	level.vehicle_driveidle[self.model] = forward;
	if(isdefined(reverse))
	{
		level.vehicle_driveidle_r[self.model] = reverse;
	}
	level.vehicle_driveidle_normal_speed[self.model] = normalspeed;
	if(isdefined(rate))
	{
		level.vehicle_driveidle_animrate[self.model] = rate;
	}
}

/*
	Name: get_from_spawnstruct
	Namespace: vehicle
	Checksum: 0x507F770F
	Offset: 0x8070
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function get_from_spawnstruct(target)
{
	return struct::get(target, "targetname");
}

/*
	Name: get_from_entity
	Namespace: vehicle
	Checksum: 0xAC16740F
	Offset: 0x80A8
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function get_from_entity(target)
{
	return getent(target, "targetname");
}

/*
	Name: get_from_spawnstruct_target
	Namespace: vehicle
	Checksum: 0x9A529C78
	Offset: 0x80E0
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function get_from_spawnstruct_target(target)
{
	return struct::get(target, "target");
}

/*
	Name: get_from_entity_target
	Namespace: vehicle
	Checksum: 0x54CFB24D
	Offset: 0x8118
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function get_from_entity_target(target)
{
	return getent(target, "target");
}

/*
	Name: is_destructible
	Namespace: vehicle
	Checksum: 0xE70A7877
	Offset: 0x8150
	Size: 0xC
	Parameters: 0
	Flags: Linked
*/
function is_destructible()
{
	return isdefined(self.destructible_type);
}

/*
	Name: attack_group_think
	Namespace: vehicle
	Checksum: 0xBA8D2384
	Offset: 0x8168
	Size: 0x2CC
	Parameters: 0
	Flags: Linked
*/
function attack_group_think()
{
	self endon(#"death");
	self endon(#"hash_11675b4c");
	self endon(#"hash_9696a8ad");
	if(isdefined(self.script_vehicleattackgroupwait))
	{
		wait(self.script_vehicleattackgroupwait);
	}
	for(;;)
	{
		group = getentarray("script_vehicle", "classname");
		valid_targets = [];
		for(i = 0; i < group.size; i++)
		{
			if(!isdefined(group[i].script_vehiclespawngroup))
			{
				continue;
			}
			if(group[i].script_vehiclespawngroup == self.script_vehicleattackgroup)
			{
				if(group[i].team != self.team)
				{
					if(!isdefined(valid_targets))
					{
						valid_targets = [];
					}
					else if(!isarray(valid_targets))
					{
						valid_targets = array(valid_targets);
					}
					valid_targets[valid_targets.size] = group[i];
				}
			}
		}
		if(valid_targets.size == 0)
		{
			wait(0.5);
			continue;
		}
		for(;;)
		{
			current_target = undefined;
			if(valid_targets.size != 0)
			{
				current_target = self get_nearest_target(valid_targets);
			}
			else
			{
				self notify(#"hash_9696a8ad");
			}
			if(current_target.health <= 0)
			{
				arrayremovevalue(valid_targets, current_target);
				continue;
				continue;
			}
			self setturrettargetent(current_target, vectorscale((0, 0, 1), 50));
			if(isdefined(self.fire_delay_min) && isdefined(self.fire_delay_max))
			{
				if(self.fire_delay_max < self.fire_delay_min)
				{
					self.fire_delay_max = self.fire_delay_min;
				}
				wait(randomintrange(self.fire_delay_min, self.fire_delay_max));
			}
			else
			{
				wait(randomintrange(4, 6));
			}
			self fireweapon();
		}
	}
}

/*
	Name: get_nearest_target
	Namespace: vehicle
	Checksum: 0xA4A305EA
	Offset: 0x8440
	Size: 0xD6
	Parameters: 1
	Flags: Linked
*/
function get_nearest_target(valid_targets)
{
	nearest_distsq = 99999999;
	nearest = undefined;
	for(i = 0; i < valid_targets.size; i++)
	{
		if(!isdefined(valid_targets[i]))
		{
			continue;
		}
		current_distsq = distancesquared(self.origin, valid_targets[i].origin);
		if(current_distsq < nearest_distsq)
		{
			nearest_distsq = current_distsq;
			nearest = valid_targets[i];
		}
	}
	return nearest;
}

/*
	Name: debug_vehicle
	Namespace: vehicle
	Checksum: 0x6968E79E
	Offset: 0x8520
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function debug_vehicle()
{
	/#
		self endon(#"death");
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		while(true)
		{
			if(getdvarint("") > 0)
			{
				print3d(self.origin, "" + self.health, (1, 1, 1), 1, 3);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: debug_vehicle_paths
	Namespace: vehicle
	Checksum: 0xCCDD0C38
	Offset: 0x85E8
	Size: 0x140
	Parameters: 0
	Flags: Linked
*/
function debug_vehicle_paths()
{
	/#
		self endon(#"death");
		self endon(#"newpath");
		self endon(#"reached_dynamic_path_end");
		nextnode = self.currentnode;
		while(true)
		{
			if(getdvarint("") > 0)
			{
				recordline(self.origin, self.currentnode.origin, (1, 0, 0), "", self);
				recordline(self.origin, nextnode.origin, (0, 1, 0), "", self);
				recordline(self.currentnode.origin, nextnode.origin, (1, 1, 1), "", self);
			}
			wait(0.05);
			if(isdefined(self.nextnode) && self.nextnode != nextnode)
			{
				nextnode = self.nextnode;
			}
		}
	#/
}

/*
	Name: get_dummy
	Namespace: vehicle
	Checksum: 0xE9344D2E
	Offset: 0x8730
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function get_dummy()
{
	if(isdefined(self.modeldummyon) && self.modeldummyon)
	{
		emodel = self.modeldummy;
	}
	else
	{
		emodel = self;
	}
	return emodel;
}

/*
	Name: add_main_callback
	Namespace: vehicle
	Checksum: 0xD13E788E
	Offset: 0x8778
	Size: 0x7E
	Parameters: 2
	Flags: Linked
*/
function add_main_callback(vehicletype, main)
{
	if(!isdefined(level.vehicle_main_callback))
	{
		level.vehicle_main_callback = [];
	}
	/#
		if(isdefined(level.vehicle_main_callback[vehicletype]))
		{
			println(("" + vehicletype) + "");
		}
	#/
	level.vehicle_main_callback[vehicletype] = main;
}

/*
	Name: vehicle_get_occupant_team
	Namespace: vehicle
	Checksum: 0x78108709
	Offset: 0x8800
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function vehicle_get_occupant_team()
{
	occupants = self getvehoccupants();
	if(occupants.size != 0)
	{
		occupant = occupants[0];
		if(isplayer(occupant))
		{
			return occupant.team;
		}
	}
	return self.team;
}

/*
	Name: toggle_exhaust_fx
	Namespace: vehicle
	Checksum: 0x8EEC6F80
	Offset: 0x8888
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function toggle_exhaust_fx(on)
{
	if(!on)
	{
		self clientfield::set("toggle_exhaustfx", 1);
	}
	else
	{
		self clientfield::set("toggle_exhaustfx", 0);
	}
}

/*
	Name: toggle_tread_fx
	Namespace: vehicle
	Checksum: 0xF167DA92
	Offset: 0x88E8
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function toggle_tread_fx(on)
{
	if(on)
	{
		self clientfield::set("toggle_treadfx", 1);
	}
	else
	{
		self clientfield::set("toggle_treadfx", 0);
	}
}

/*
	Name: toggle_sounds
	Namespace: vehicle
	Checksum: 0x81E02204
	Offset: 0x8948
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function toggle_sounds(on)
{
	if(!on)
	{
		self clientfield::set("toggle_sounds", 1);
	}
	else
	{
		self clientfield::set("toggle_sounds", 0);
	}
}

/*
	Name: is_corpse
	Namespace: vehicle
	Checksum: 0x6B3793BC
	Offset: 0x89A8
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function is_corpse(veh)
{
	if(isdefined(veh))
	{
		if(isdefined(veh.isacorpse) && veh.isacorpse)
		{
			return true;
		}
		if(isdefined(veh.classname) && veh.classname == "script_vehicle_corpse")
		{
			return true;
		}
	}
	return false;
}

/*
	Name: is_on
	Namespace: vehicle
	Checksum: 0x1E70218C
	Offset: 0x8A30
	Size: 0x64
	Parameters: 1
	Flags: None
*/
function is_on(vehicle)
{
	if(!isdefined(self.viewlockedentity))
	{
		return false;
	}
	if(self.viewlockedentity == vehicle)
	{
		return true;
	}
	if(!isdefined(self.groundentity))
	{
		return false;
	}
	if(self.groundentity == vehicle)
	{
		return true;
	}
	return false;
}

/*
	Name: add_spawn_function
	Namespace: vehicle
	Checksum: 0x8E6C9390
	Offset: 0x8AA0
	Size: 0x158
	Parameters: 6
	Flags: None
*/
function add_spawn_function(veh_targetname, spawn_func, param1, param2, param3, param4)
{
	func = [];
	func["function"] = spawn_func;
	func["param1"] = param1;
	func["param2"] = param2;
	func["param3"] = param3;
	func["param4"] = param4;
	if(!isdefined(level.a_vehicle_targetnames))
	{
		level.a_vehicle_targetnames = [];
	}
	if(!isdefined(level.a_vehicle_targetnames[veh_targetname]))
	{
		level.a_vehicle_targetnames[veh_targetname] = [];
	}
	else if(!isarray(level.a_vehicle_targetnames[veh_targetname]))
	{
		level.a_vehicle_targetnames[veh_targetname] = array(level.a_vehicle_targetnames[veh_targetname]);
	}
	level.a_vehicle_targetnames[veh_targetname][level.a_vehicle_targetnames[veh_targetname].size] = func;
}

/*
	Name: add_spawn_function_by_type
	Namespace: vehicle
	Checksum: 0x94639992
	Offset: 0x8C00
	Size: 0x158
	Parameters: 6
	Flags: None
*/
function add_spawn_function_by_type(veh_type, spawn_func, param1, param2, param3, param4)
{
	func = [];
	func["function"] = spawn_func;
	func["param1"] = param1;
	func["param2"] = param2;
	func["param3"] = param3;
	func["param4"] = param4;
	if(!isdefined(level.a_vehicle_types))
	{
		level.a_vehicle_types = [];
	}
	if(!isdefined(level.a_vehicle_types[veh_type]))
	{
		level.a_vehicle_types[veh_type] = [];
	}
	else if(!isarray(level.a_vehicle_types[veh_type]))
	{
		level.a_vehicle_types[veh_type] = array(level.a_vehicle_types[veh_type]);
	}
	level.a_vehicle_types[veh_type][level.a_vehicle_types[veh_type].size] = func;
}

/*
	Name: add_hijack_function
	Namespace: vehicle
	Checksum: 0x76A27C14
	Offset: 0x8D60
	Size: 0x158
	Parameters: 6
	Flags: None
*/
function add_hijack_function(veh_targetname, spawn_func, param1, param2, param3, param4)
{
	func = [];
	func["function"] = spawn_func;
	func["param1"] = param1;
	func["param2"] = param2;
	func["param3"] = param3;
	func["param4"] = param4;
	if(!isdefined(level.a_vehicle_hijack_targetnames))
	{
		level.a_vehicle_hijack_targetnames = [];
	}
	if(!isdefined(level.a_vehicle_hijack_targetnames[veh_targetname]))
	{
		level.a_vehicle_hijack_targetnames[veh_targetname] = [];
	}
	else if(!isarray(level.a_vehicle_hijack_targetnames[veh_targetname]))
	{
		level.a_vehicle_hijack_targetnames[veh_targetname] = array(level.a_vehicle_hijack_targetnames[veh_targetname]);
	}
	level.a_vehicle_hijack_targetnames[veh_targetname][level.a_vehicle_hijack_targetnames[veh_targetname].size] = func;
}

/*
	Name: _watch_for_hijacked_vehicles
	Namespace: vehicle
	Checksum: 0x566BF525
	Offset: 0x8EC0
	Size: 0x18E
	Parameters: 0
	Flags: Linked, Private
*/
function private _watch_for_hijacked_vehicles()
{
	while(true)
	{
		level waittill(#"clonedentity", clone);
		str_targetname = clone.targetname;
		if(isdefined(str_targetname) && strendswith(str_targetname, "_ai"))
		{
			str_targetname = getsubstr(str_targetname, 0, str_targetname.size - 3);
		}
		waittillframeend();
		if(isdefined(str_targetname) && isdefined(level.a_vehicle_hijack_targetnames) && isdefined(level.a_vehicle_hijack_targetnames[str_targetname]))
		{
			foreach(func in level.a_vehicle_hijack_targetnames[str_targetname])
			{
				util::single_thread(clone, func["function"], func["param1"], func["param2"], func["param3"], func["param4"]);
			}
		}
	}
}

/*
	Name: disconnect_paths
	Namespace: vehicle
	Checksum: 0x8B1AD4C9
	Offset: 0x9058
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function disconnect_paths(detail_level = 2, move_allowed = 1)
{
	self disconnectpaths(detail_level, move_allowed);
	self enableobstacle(0);
}

/*
	Name: connect_paths
	Namespace: vehicle
	Checksum: 0x5EE00D34
	Offset: 0x90D8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function connect_paths()
{
	self connectpaths();
	self enableobstacle(1);
}

/*
	Name: init_target_group
	Namespace: vehicle
	Checksum: 0xD02D2CD0
	Offset: 0x9118
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function init_target_group()
{
	self.target_group = [];
}

/*
	Name: add_to_target_group
	Namespace: vehicle
	Checksum: 0x6B6DC23C
	Offset: 0x9130
	Size: 0xA2
	Parameters: 1
	Flags: None
*/
function add_to_target_group(target_ent)
{
	/#
		assert(isdefined(self.target_group), "");
	#/
	if(!isdefined(self.target_group))
	{
		self.target_group = [];
	}
	else if(!isarray(self.target_group))
	{
		self.target_group = array(self.target_group);
	}
	self.target_group[self.target_group.size] = target_ent;
}

/*
	Name: remove_from_target_group
	Namespace: vehicle
	Checksum: 0xD3B10DB0
	Offset: 0x91E0
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function remove_from_target_group(target_ent)
{
	/#
		assert(isdefined(self.target_group), "");
	#/
	arrayremovevalue(self.target_group, target_ent);
}

/*
	Name: monitor_missiles_locked_on_to_me
	Namespace: vehicle
	Checksum: 0x21F2016C
	Offset: 0x9240
	Size: 0xEE
	Parameters: 2
	Flags: None
*/
function monitor_missiles_locked_on_to_me(player, wait_time = 0.1)
{
	monitored_entity = self;
	monitored_entity endon(#"death");
	/#
		assert(isdefined(monitored_entity.target_group), "");
	#/
	player endon(#"stop_monitor_missile_locked_on_to_me");
	player endon(#"disconnect");
	player endon(#"joined_team");
	while(true)
	{
		closest_attacker = player get_closest_attacker_with_missile_locked_on_to_me(monitored_entity);
		player setvehiclelockedonbyent(closest_attacker);
		wait(wait_time);
	}
}

/*
	Name: stop_monitor_missiles_locked_on_to_me
	Namespace: vehicle
	Checksum: 0xBB900BC6
	Offset: 0x9338
	Size: 0x12
	Parameters: 0
	Flags: None
*/
function stop_monitor_missiles_locked_on_to_me()
{
	self notify(#"stop_monitor_missile_locked_on_to_me");
}

/*
	Name: get_closest_attacker_with_missile_locked_on_to_me
	Namespace: vehicle
	Checksum: 0x988C90AE
	Offset: 0x9358
	Size: 0x2AA
	Parameters: 1
	Flags: Linked
*/
function get_closest_attacker_with_missile_locked_on_to_me(monitored_entity)
{
	/#
		assert(isdefined(monitored_entity.target_group), "");
	#/
	player = self;
	closest_attacker = undefined;
	closest_attacker_dot = -999;
	view_origin = player getplayercamerapos();
	view_forward = anglestoforward(player getplayerangles());
	remaining_locked_on_flags = 0;
	foreach(target_ent in monitored_entity.target_group)
	{
		if(isdefined(target_ent) && isdefined(target_ent.locked_on))
		{
			remaining_locked_on_flags = remaining_locked_on_flags | target_ent.locked_on;
		}
	}
	for(i = 0; remaining_locked_on_flags && i < level.players.size; i++)
	{
		attacker = level.players[i];
		if(isdefined(attacker))
		{
			client_flag = 1 << attacker getentitynumber();
			if(client_flag & remaining_locked_on_flags)
			{
				to_attacker = vectornormalize(attacker.origin - view_origin);
				attacker_dot = vectordot(view_forward, to_attacker);
				if(attacker_dot > closest_attacker_dot)
				{
					closest_attacker = attacker;
					closest_attacker_dot = attacker_dot;
				}
				remaining_locked_on_flags = remaining_locked_on_flags & (~client_flag);
			}
		}
	}
	return closest_attacker;
}

/*
	Name: set_vehicle_drivable_time_starting_now
	Namespace: vehicle
	Checksum: 0x79449A
	Offset: 0x9610
	Size: 0x40
	Parameters: 1
	Flags: None
*/
function set_vehicle_drivable_time_starting_now(duration_ms)
{
	end_time_ms = gettime() + duration_ms;
	set_vehicle_drivable_time(duration_ms, end_time_ms);
	return end_time_ms;
}

/*
	Name: set_vehicle_drivable_time
	Namespace: vehicle
	Checksum: 0x92F02B0B
	Offset: 0x9658
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function set_vehicle_drivable_time(duration_ms, end_time_ms)
{
	self setvehicledrivableduration(duration_ms);
	self setvehicledrivableendtime(end_time_ms);
}

/*
	Name: update_damage_as_occupant
	Namespace: vehicle
	Checksum: 0x76CB8433
	Offset: 0x96A8
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function update_damage_as_occupant(damage_taken, max_health)
{
	damage_taken_normalized = math::clamp(damage_taken / max_health, 0, 1);
	self setvehicledamagemeter(damage_taken_normalized);
}

/*
	Name: stop_monitor_damage_as_occupant
	Namespace: vehicle
	Checksum: 0x73BF85B8
	Offset: 0x9720
	Size: 0x12
	Parameters: 0
	Flags: Linked
*/
function stop_monitor_damage_as_occupant()
{
	self notify(#"stop_monitor_damage_as_occupant");
}

/*
	Name: monitor_damage_as_occupant
	Namespace: vehicle
	Checksum: 0xA48FE1A1
	Offset: 0x9740
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function monitor_damage_as_occupant(player)
{
	player endon(#"disconnect");
	player notify(#"stop_monitor_damage_as_occupant");
	player endon(#"stop_monitor_damage_as_occupant");
	self endon(#"death");
	if(!isdefined(self.maxhealth))
	{
		self.maxhealth = self.healthdefault;
	}
	wait(0.1);
	player update_damage_as_occupant(self.maxhealth - self.health, self.maxhealth);
	while(true)
	{
		self waittill(#"damage");
		waittillframeend();
		player update_damage_as_occupant(self.maxhealth - self.health, self.maxhealth);
	}
}

/*
	Name: kill_vehicle
	Namespace: vehicle
	Checksum: 0x99A00F9
	Offset: 0x9828
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function kill_vehicle(attacker)
{
	damageorigin = self.origin + (0, 0, 1);
	self finishvehicleradiusdamage(attacker, attacker, 32000, 32000, 10, 0, "MOD_EXPLOSIVE", level.weaponnone, damageorigin, 400, -1, (0, 0, 1), 0);
}

/*
	Name: player_is_driver
	Namespace: vehicle
	Checksum: 0x3B9C13CA
	Offset: 0x98A8
	Size: 0x8E
	Parameters: 0
	Flags: None
*/
function player_is_driver()
{
	if(!isalive(self))
	{
		return false;
	}
	vehicle = self getvehicleoccupied();
	if(isdefined(vehicle))
	{
		seat = vehicle getoccupantseat(self);
		if(isdefined(seat) && seat == 0)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: vehicle_spawner_tool
	Namespace: vehicle
	Checksum: 0x2B7D6323
	Offset: 0x9940
	Size: 0x7F6
	Parameters: 0
	Flags: Linked
*/
function vehicle_spawner_tool()
{
	/#
		allvehicles = getentarray("", "");
		vehicletypes = [];
		foreach(veh in allvehicles)
		{
			vehicletypes[veh.vehicletype] = veh.model;
		}
		if(isassetloaded("", ""))
		{
			veh = spawnvehicle("", vectorscale((0, 0, 1), 10000), (0, 0, 0), "");
			vehicletypes[veh.vehicletype] = veh.model;
			veh delete();
		}
		if(isassetloaded("", ""))
		{
			veh = spawnvehicle("", vectorscale((0, 0, 1), 10000), (0, 0, 0), "");
			vehicletypes[veh.vehicletype] = veh.model;
			veh delete();
		}
		if(isassetloaded("", ""))
		{
			veh = spawnvehicle("", vectorscale((0, 0, 1), 10000), (0, 0, 0), "");
			vehicletypes[veh.vehicletype] = veh.model;
			veh delete();
		}
		if(isassetloaded("", ""))
		{
			veh = spawnvehicle("", vectorscale((0, 0, 1), 10000), (0, 0, 0), "");
			vehicletypes[veh.vehicletype] = veh.model;
			veh delete();
		}
		if(isassetloaded("", ""))
		{
			veh = spawnvehicle("", vectorscale((0, 0, 1), 10000), (0, 0, 0), "");
			vehicletypes[veh.vehicletype] = veh.model;
			veh delete();
		}
		types = getarraykeys(vehicletypes);
		if(types.size == 0)
		{
			return;
		}
		type_index = 0;
		while(true)
		{
			if(getdvarint("") > 0)
			{
				player = getplayers()[0];
				dynamic_spawn_hud = newclienthudelem(player);
				dynamic_spawn_hud.alignx = "";
				dynamic_spawn_hud.x = 20;
				dynamic_spawn_hud.y = 395;
				dynamic_spawn_hud.fontscale = 2;
				dynamic_spawn_dummy_model = sys::spawn("", (0, 0, 0));
				while(getdvarint("") > 0)
				{
					origin = player.origin + (anglestoforward(player getplayerangles()) * 270);
					origin = origin + vectorscale((0, 0, 1), 40);
					if(player usebuttonpressed())
					{
						dynamic_spawn_dummy_model hide();
						vehicle = spawnvehicle(types[type_index], origin, player.angles, "");
						vehicle makevehicleusable();
						if(getdvarint("") == 1)
						{
							setdvar("", "");
							continue;
						}
						wait(0.3);
					}
					if(player buttonpressed(""))
					{
						dynamic_spawn_dummy_model hide();
						type_index++;
						if(type_index >= types.size)
						{
							type_index = 0;
						}
						wait(0.3);
					}
					if(player buttonpressed(""))
					{
						dynamic_spawn_dummy_model hide();
						type_index--;
						if(type_index < 0)
						{
							type_index = types.size - 1;
						}
						wait(0.3);
					}
					type = types[type_index];
					dynamic_spawn_hud settext("" + type);
					dynamic_spawn_dummy_model setmodel(vehicletypes[type]);
					dynamic_spawn_dummy_model show();
					dynamic_spawn_dummy_model notsolid();
					dynamic_spawn_dummy_model.origin = origin;
					dynamic_spawn_dummy_model.angles = player.angles;
					wait(0.05);
				}
				dynamic_spawn_hud destroy();
				dynamic_spawn_dummy_model delete();
			}
			wait(2);
		}
	#/
}

/*
	Name: spline_debug
	Namespace: vehicle
	Checksum: 0x8C624A52
	Offset: 0xA140
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function spline_debug()
{
	/#
		level flag::init("");
		level thread _spline_debug();
		while(true)
		{
			level flag::set_val("", getdvarint(""));
			wait(0.05);
		}
	#/
}

/*
	Name: _spline_debug
	Namespace: vehicle
	Checksum: 0xD818B99
	Offset: 0xA1C8
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function _spline_debug()
{
	/#
		while(true)
		{
			level flag::wait_till("");
			foreach(nd in getallvehiclenodes())
			{
				nd show_node_debug_info();
			}
			wait(0.05);
		}
	#/
}

/*
	Name: show_node_debug_info
	Namespace: vehicle
	Checksum: 0x8C4F754B
	Offset: 0xA298
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function show_node_debug_info()
{
	/#
		self.n_debug_display_count = 0;
		if(is_unload_node())
		{
			print_debug_info(("" + self.script_unload) + "");
		}
		if(isdefined(self.script_notify))
		{
			print_debug_info(("" + self.script_notify) + "");
		}
		if(isdefined(self.script_delete) && self.script_delete)
		{
			print_debug_info("");
		}
	#/
}

/*
	Name: print_debug_info
	Namespace: vehicle
	Checksum: 0xB2D3D624
	Offset: 0xA360
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function print_debug_info(str_info)
{
	/#
		self.n_debug_display_count++;
		print3d(self.origin - (0, 0, self.n_debug_display_count * 20), str_info, (0, 0, 1), 1, 1);
	#/
}

