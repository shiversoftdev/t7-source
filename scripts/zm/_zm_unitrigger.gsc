// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace zm_unitrigger;

/*
	Name: __init__sytem__
	Namespace: zm_unitrigger
	Checksum: 0x6140A4A0
	Offset: 0x1D0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_unitrigger", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_unitrigger
	Checksum: 0x65117478
	Offset: 0x210
	Size: 0x186
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._unitriggers = spawnstruct();
	level._unitriggers._deferredinitlist = [];
	level._unitriggers.trigger_pool = [];
	level._unitriggers.trigger_stubs = [];
	level._unitriggers.dynamic_stubs = [];
	level._unitriggers.system_trigger_funcs = [];
	level._unitriggers.largest_radius = 64;
	stubs_keys = array("unitrigger_radius", "unitrigger_radius_use", "unitrigger_box", "unitrigger_box_use");
	stubs = [];
	for(i = 0; i < stubs_keys.size; i++)
	{
		stubs = arraycombine(stubs, struct::get_array(stubs_keys[i], "script_unitrigger_type"), 1, 0);
	}
	for(i = 0; i < stubs.size; i++)
	{
		register_unitrigger(stubs[i]);
	}
}

/*
	Name: register_unitrigger_system_func
	Namespace: zm_unitrigger
	Checksum: 0x53E903A9
	Offset: 0x3A0
	Size: 0x2E
	Parameters: 2
	Flags: None
*/
function register_unitrigger_system_func(system, trigger_func)
{
	level._unitriggers.system_trigger_funcs[system] = trigger_func;
}

/*
	Name: unitrigger_force_per_player_triggers
	Namespace: zm_unitrigger
	Checksum: 0xE95D81DE
	Offset: 0x3D8
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function unitrigger_force_per_player_triggers(unitrigger_stub, opt_on_off = 1)
{
	unitrigger_stub.trigger_per_player = opt_on_off;
}

/*
	Name: unitrigger_trigger
	Namespace: zm_unitrigger
	Checksum: 0xCF3A0DEA
	Offset: 0x420
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function unitrigger_trigger(player)
{
	if(self.trigger_per_player)
	{
		return self.playertrigger[player getentitynumber()];
	}
	return self.trigger;
}

/*
	Name: unitrigger_origin
	Namespace: zm_unitrigger
	Checksum: 0x86403248
	Offset: 0x470
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function unitrigger_origin()
{
	if(isdefined(self.originfunc))
	{
		origin = self [[self.originfunc]]();
	}
	else
	{
		origin = self.origin;
	}
	return origin;
}

/*
	Name: register_unitrigger_internal
	Namespace: zm_unitrigger
	Checksum: 0xE6F19965
	Offset: 0x4B8
	Size: 0x454
	Parameters: 2
	Flags: Linked
*/
function register_unitrigger_internal(unitrigger_stub, trigger_func)
{
	if(!isdefined(unitrigger_stub.script_unitrigger_type))
	{
		/#
			println("");
		#/
		return;
	}
	if(isdefined(trigger_func))
	{
		unitrigger_stub.trigger_func = trigger_func;
	}
	else if(isdefined(unitrigger_stub.unitrigger_system) && isdefined(level._unitriggers.system_trigger_funcs[unitrigger_stub.unitrigger_system]))
	{
		unitrigger_stub.trigger_func = level._unitriggers.system_trigger_funcs[unitrigger_stub.unitrigger_system];
	}
	switch(unitrigger_stub.script_unitrigger_type)
	{
		case "unitrigger_radius":
		case "unitrigger_radius_use":
		{
			if(!isdefined(unitrigger_stub.radius))
			{
				unitrigger_stub.radius = 32;
			}
			if(!isdefined(unitrigger_stub.script_height))
			{
				unitrigger_stub.script_height = 64;
			}
			unitrigger_stub.test_radius_sq = (unitrigger_stub.radius + 15) * (unitrigger_stub.radius + 15);
			break;
		}
		case "unitrigger_box":
		case "unitrigger_box_use":
		{
			if(!isdefined(unitrigger_stub.script_width))
			{
				unitrigger_stub.script_width = 64;
			}
			if(!isdefined(unitrigger_stub.script_height))
			{
				unitrigger_stub.script_height = 64;
			}
			if(!isdefined(unitrigger_stub.script_length))
			{
				unitrigger_stub.script_length = 64;
			}
			box_radius = length((unitrigger_stub.script_width / 2, unitrigger_stub.script_length / 2, unitrigger_stub.script_height / 2));
			if(!isdefined(unitrigger_stub.radius) || unitrigger_stub.radius < box_radius)
			{
				unitrigger_stub.radius = box_radius;
			}
			unitrigger_stub.test_radius_sq = (box_radius + 15) * (box_radius + 15);
			break;
		}
		default:
		{
			/#
				println(("" + unitrigger_stub.targetname) + "");
			#/
			return;
		}
	}
	if(unitrigger_stub.radius > level._unitriggers.largest_radius)
	{
		level._unitriggers.largest_radius = min(113, unitrigger_stub.radius);
		if(isdefined(level.fixed_max_player_use_radius))
		{
			if(level.fixed_max_player_use_radius > getdvarfloat("player_useRadius_zm"))
			{
				setdvar("player_useRadius_zm", level.fixed_max_player_use_radius);
			}
		}
		else if(level._unitriggers.largest_radius > getdvarfloat("player_useRadius_zm"))
		{
			setdvar("player_useRadius_zm", level._unitriggers.largest_radius);
		}
	}
	level._unitriggers.trigger_stubs[level._unitriggers.trigger_stubs.size] = unitrigger_stub;
	unitrigger_stub.registered = 1;
}

/*
	Name: register_unitrigger
	Namespace: zm_unitrigger
	Checksum: 0x135963CC
	Offset: 0x918
	Size: 0x52
	Parameters: 2
	Flags: Linked
*/
function register_unitrigger(unitrigger_stub, trigger_func)
{
	register_unitrigger_internal(unitrigger_stub, trigger_func);
	level._unitriggers.dynamic_stubs[level._unitriggers.dynamic_stubs.size] = unitrigger_stub;
}

/*
	Name: unregister_unitrigger
	Namespace: zm_unitrigger
	Checksum: 0xEEA88A3D
	Offset: 0x978
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function unregister_unitrigger(unitrigger_stub)
{
	thread unregister_unitrigger_internal(unitrigger_stub);
}

/*
	Name: unregister_unitrigger_internal
	Namespace: zm_unitrigger
	Checksum: 0xD5F889D8
	Offset: 0x9A8
	Size: 0x27C
	Parameters: 1
	Flags: Linked
*/
function unregister_unitrigger_internal(unitrigger_stub)
{
	if(!isdefined(unitrigger_stub))
	{
		return;
	}
	unitrigger_stub.registered = 0;
	if(isdefined(unitrigger_stub.trigger_per_player) && unitrigger_stub.trigger_per_player)
	{
		if(isdefined(unitrigger_stub.playertrigger) && unitrigger_stub.playertrigger.size > 0)
		{
			keys = getarraykeys(unitrigger_stub.playertrigger);
			foreach(key in keys)
			{
				trigger = unitrigger_stub.playertrigger[key];
				trigger notify(#"kill_trigger");
				if(isdefined(trigger))
				{
					trigger delete();
				}
			}
			unitrigger_stub.playertrigger = [];
		}
	}
	else if(isdefined(unitrigger_stub.trigger))
	{
		trigger = unitrigger_stub.trigger;
		trigger notify(#"kill_trigger");
		trigger.stub.trigger = undefined;
		trigger delete();
	}
	if(isdefined(unitrigger_stub.in_zone))
	{
		arrayremovevalue(level.zones[unitrigger_stub.in_zone].unitrigger_stubs, unitrigger_stub);
		unitrigger_stub.in_zone = undefined;
	}
	arrayremovevalue(level._unitriggers.trigger_stubs, unitrigger_stub);
	arrayremovevalue(level._unitriggers.dynamic_stubs, unitrigger_stub);
}

/*
	Name: delay_delete_contact_ent
	Namespace: zm_unitrigger
	Checksum: 0x90D1F616
	Offset: 0xC30
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function delay_delete_contact_ent()
{
	self.last_used_time = 0;
	while(true)
	{
		wait(1);
		if((gettime() - self.last_used_time) > 1000)
		{
			self delete();
			level._unitriggers.contact_ent = undefined;
			return;
		}
	}
}

/*
	Name: register_static_unitrigger
	Namespace: zm_unitrigger
	Checksum: 0xD510E196
	Offset: 0xC90
	Size: 0x2FC
	Parameters: 3
	Flags: Linked
*/
function register_static_unitrigger(unitrigger_stub, trigger_func, recalculate_zone)
{
	if(level.zones.size == 0)
	{
		unitrigger_stub.trigger_func = trigger_func;
		level._unitriggers._deferredinitlist[level._unitriggers._deferredinitlist.size] = unitrigger_stub;
		return;
	}
	if(!isdefined(level._unitriggers.contact_ent))
	{
		level._unitriggers.contact_ent = spawn("script_origin", (0, 0, 0));
		level._unitriggers.contact_ent thread delay_delete_contact_ent();
	}
	register_unitrigger_internal(unitrigger_stub, trigger_func);
	if(!isdefined(level._no_static_unitriggers))
	{
		level._unitriggers.contact_ent.last_used_time = gettime();
		level._unitriggers.contact_ent.origin = unitrigger_stub.origin;
		if(isdefined(unitrigger_stub.in_zone) && !isdefined(recalculate_zone))
		{
			level.zones[unitrigger_stub.in_zone].unitrigger_stubs[level.zones[unitrigger_stub.in_zone].unitrigger_stubs.size] = unitrigger_stub;
			return;
		}
		keys = getarraykeys(level.zones);
		for(i = 0; i < keys.size; i++)
		{
			if(level._unitriggers.contact_ent zm_zonemgr::entity_in_zone(keys[i], 1))
			{
				if(!isdefined(level.zones[keys[i]].unitrigger_stubs))
				{
					level.zones[keys[i]].unitrigger_stubs = [];
				}
				level.zones[keys[i]].unitrigger_stubs[level.zones[keys[i]].unitrigger_stubs.size] = unitrigger_stub;
				unitrigger_stub.in_zone = keys[i];
				return;
			}
		}
	}
	level._unitriggers.dynamic_stubs[level._unitriggers.dynamic_stubs.size] = unitrigger_stub;
	unitrigger_stub.registered = 1;
}

/*
	Name: register_dyn_unitrigger
	Namespace: zm_unitrigger
	Checksum: 0x5B53C926
	Offset: 0xF98
	Size: 0x11C
	Parameters: 3
	Flags: Linked
*/
function register_dyn_unitrigger(unitrigger_stub, trigger_func, recalculate_zone)
{
	if(level.zones.size == 0)
	{
		unitrigger_stub.trigger_func = trigger_func;
		level._unitriggers._deferredinitlist[level._unitriggers._deferredinitlist.size] = unitrigger_stub;
		return;
	}
	if(!isdefined(level._unitriggers.contact_ent))
	{
		level._unitriggers.contact_ent = spawn("script_origin", (0, 0, 0));
		level._unitriggers.contact_ent thread delay_delete_contact_ent();
	}
	register_unitrigger_internal(unitrigger_stub, trigger_func);
	level._unitriggers.dynamic_stubs[level._unitriggers.dynamic_stubs.size] = unitrigger_stub;
	unitrigger_stub.registered = 1;
}

/*
	Name: reregister_unitrigger_as_dynamic
	Namespace: zm_unitrigger
	Checksum: 0xEAAE30A3
	Offset: 0x10C0
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function reregister_unitrigger_as_dynamic(unitrigger_stub)
{
	unregister_unitrigger_internal(unitrigger_stub);
	register_unitrigger(unitrigger_stub, unitrigger_stub.trigger_func);
}

/*
	Name: debug_unitriggers
	Namespace: zm_unitrigger
	Checksum: 0xB652E09D
	Offset: 0x1110
	Size: 0x33C
	Parameters: 0
	Flags: Linked
*/
function debug_unitriggers()
{
	/#
		while(true)
		{
			if(getdvarint("") > 0)
			{
				for(i = 0; i < level._unitriggers.trigger_stubs.size; i++)
				{
					triggerstub = level._unitriggers.trigger_stubs[i];
					color = vectorscale((1, 0, 0), 0.75);
					if(!isdefined(triggerstub.in_zone))
					{
						color = vectorscale((1, 1, 0), 0.65);
					}
					else if(level.zones[triggerstub.in_zone].is_active)
					{
						color = (1, 1, 0);
					}
					if(isdefined(triggerstub.trigger) || (isdefined(triggerstub.playertrigger) && triggerstub.playertrigger.size > 0))
					{
						color = (0, 1, 0);
						if(isdefined(triggerstub.playertrigger) && triggerstub.playertrigger.size > 0)
						{
							print3d(triggerstub.origin, triggerstub.playertrigger.size, color, 1, 1, 1);
						}
					}
					origin = triggerstub unitrigger_origin();
					switch(triggerstub.script_unitrigger_type)
					{
						case "":
						case "":
						{
							if(triggerstub.radius)
							{
								circle(origin, triggerstub.radius, color, 0, 0, 1);
							}
							if(triggerstub.script_height)
							{
								line(origin, origin + (0, 0, triggerstub.script_height), color, 0, 1);
							}
							break;
						}
						case "":
						case "":
						{
							vec = (triggerstub.script_width / 2, triggerstub.script_length / 2, triggerstub.script_height / 2);
							box(origin, vec * -1, vec, triggerstub.angles[1], color, 1, 0, 1);
							break;
						}
					}
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: cleanup_trigger
	Namespace: zm_unitrigger
	Checksum: 0xD7AB0599
	Offset: 0x1458
	Size: 0xE4
	Parameters: 2
	Flags: Linked
*/
function cleanup_trigger(trigger, player)
{
	trigger notify(#"kill_trigger");
	if(isdefined(trigger.stub.trigger_per_player) && trigger.stub.trigger_per_player)
	{
		trigger.stub.playertrigger[player getentitynumber()] = undefined;
	}
	else
	{
		trigger.stub.trigger = undefined;
	}
	trigger delete();
	level._unitriggers.trigger_pool[player getentitynumber()] = undefined;
}

/*
	Name: assess_and_apply_visibility
	Namespace: zm_unitrigger
	Checksum: 0x1B7BE5E9
	Offset: 0x1548
	Size: 0x1C4
	Parameters: 4
	Flags: Linked
*/
function assess_and_apply_visibility(trigger, stub, player, default_keep)
{
	if(!isdefined(trigger) || !isdefined(stub))
	{
		return 0;
	}
	keep_thread = default_keep;
	if(!isdefined(stub.prompt_and_visibility_func) || trigger [[stub.prompt_and_visibility_func]](player))
	{
		keep_thread = 1;
		if(!(isdefined(trigger.thread_running) && trigger.thread_running))
		{
			trigger thread trigger_thread(trigger.stub.trigger_func);
		}
		trigger.thread_running = 1;
		if(isdefined(trigger.reassess_time) && trigger.reassess_time <= 0)
		{
			trigger.reassess_time = undefined;
		}
	}
	else
	{
		if(isdefined(trigger.thread_running) && trigger.thread_running)
		{
			keep_thread = 0;
		}
		trigger.thread_running = 0;
		if(isdefined(stub.inactive_reassess_time))
		{
			trigger.reassess_time = stub.inactive_reassess_time;
		}
		else
		{
			trigger.reassess_time = 1;
		}
	}
	return keep_thread;
}

/*
	Name: main
	Namespace: zm_unitrigger
	Checksum: 0x7723F0F5
	Offset: 0x1718
	Size: 0x9B4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread debug_unitriggers();
	if(level._unitriggers._deferredinitlist.size)
	{
		for(i = 0; i < level._unitriggers._deferredinitlist.size; i++)
		{
			register_static_unitrigger(level._unitriggers._deferredinitlist[i], level._unitriggers._deferredinitlist[i].trigger_func);
		}
		for(i = 0; i < level._unitriggers._deferredinitlist.size; i++)
		{
			level._unitriggers._deferredinitlist[i] = undefined;
		}
		level._unitriggers._deferredinitlist = undefined;
	}
	valid_range = level._unitriggers.largest_radius + 15;
	valid_range_sq = valid_range * valid_range;
	while(!isdefined(level.active_zone_names))
	{
		wait(0.1);
	}
	while(true)
	{
		waited = 0;
		active_zone_names = level.active_zone_names;
		candidate_list = [];
		for(j = 0; j < active_zone_names.size; j++)
		{
			if(isdefined(level.zones[active_zone_names[j]].unitrigger_stubs))
			{
				candidate_list = arraycombine(candidate_list, level.zones[active_zone_names[j]].unitrigger_stubs, 1, 0);
			}
		}
		candidate_list = arraycombine(candidate_list, level._unitriggers.dynamic_stubs, 1, 0);
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!isdefined(player))
			{
				continue;
			}
			player_origin = player.origin + vectorscale((0, 0, 1), 35);
			trigger = level._unitriggers.trigger_pool[player getentitynumber()];
			old_trigger = undefined;
			closest = [];
			if(isdefined(trigger))
			{
				dst = valid_range_sq;
				origin = trigger unitrigger_origin();
				dst = trigger.stub.test_radius_sq;
				time_to_ressess = 0;
				trigger_still_valid = 0;
				if(distance2dsquared(player_origin, origin) < dst)
				{
					if(isdefined(trigger.reassess_time))
					{
						trigger.reassess_time = trigger.reassess_time - 0.05;
						if(trigger.reassess_time > 0)
						{
							continue;
						}
						time_to_ressess = 1;
					}
					trigger_still_valid = 1;
				}
				closest = get_closest_unitriggers(player_origin, candidate_list, valid_range);
				if(isdefined(trigger) && time_to_ressess && (closest.size < 2 || (isdefined(trigger.thread_running) && trigger.thread_running)))
				{
					if(assess_and_apply_visibility(trigger, trigger.stub, player, 1))
					{
						continue;
					}
				}
				if(trigger_still_valid && closest.size < 2)
				{
					if(assess_and_apply_visibility(trigger, trigger.stub, player, 1))
					{
						continue;
					}
				}
				if(trigger_still_valid)
				{
					old_trigger = trigger;
					trigger = undefined;
					level._unitriggers.trigger_pool[player getentitynumber()] = undefined;
				}
				else if(isdefined(trigger))
				{
					cleanup_trigger(trigger, player);
				}
			}
			else
			{
				closest = get_closest_unitriggers(player_origin, candidate_list, valid_range);
			}
			index = 0;
			first_usable = undefined;
			first_visible = undefined;
			trigger_found = 0;
			while(index < closest.size)
			{
				if(!zm_utility::is_player_valid(player) && (!(isdefined(closest[index].ignore_player_valid) && closest[index].ignore_player_valid)))
				{
					index++;
					continue;
				}
				if(!(isdefined(closest[index].registered) && closest[index].registered))
				{
					index++;
					continue;
				}
				trigger = check_and_build_trigger_from_unitrigger_stub(closest[index], player);
				if(isdefined(trigger))
				{
					trigger.parent_player = player;
					if(assess_and_apply_visibility(trigger, closest[index], player, 0))
					{
						if(player zm_utility::is_player_looking_at(closest[index].origin, 0.9, 0))
						{
							if(!is_same_trigger(old_trigger, trigger) && isdefined(old_trigger))
							{
								cleanup_trigger(old_trigger, player);
							}
							level._unitriggers.trigger_pool[player getentitynumber()] = trigger;
							trigger_found = 1;
							break;
						}
						if(!isdefined(first_usable))
						{
							first_usable = index;
						}
					}
					if(!isdefined(first_visible))
					{
						first_visible = index;
					}
					if(isdefined(trigger))
					{
						if(is_same_trigger(old_trigger, trigger))
						{
							level._unitriggers.trigger_pool[player getentitynumber()] = undefined;
						}
						else
						{
							cleanup_trigger(trigger, player);
						}
					}
					last_trigger = trigger;
				}
				index++;
				waited = 1;
				wait(0.05);
			}
			if(!isdefined(player))
			{
				continue;
			}
			if(trigger_found)
			{
				continue;
			}
			if(isdefined(first_usable))
			{
				index = first_usable;
			}
			else if(isdefined(first_visible))
			{
				index = first_visible;
			}
			trigger = check_and_build_trigger_from_unitrigger_stub(closest[index], player);
			if(isdefined(trigger))
			{
				trigger.parent_player = player;
				level._unitriggers.trigger_pool[player getentitynumber()] = trigger;
				if(is_same_trigger(old_trigger, trigger))
				{
					continue;
				}
				if(isdefined(old_trigger))
				{
					cleanup_trigger(old_trigger, player);
				}
				if(isdefined(trigger))
				{
					assess_and_apply_visibility(trigger, trigger.stub, player, 0);
				}
			}
		}
		if(!waited)
		{
			wait(0.05);
		}
	}
}

/*
	Name: run_visibility_function_for_all_triggers
	Namespace: zm_unitrigger
	Checksum: 0x4BA63B8
	Offset: 0x20D8
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function run_visibility_function_for_all_triggers()
{
	if(!isdefined(self.prompt_and_visibility_func))
	{
		return;
	}
	if(isdefined(self.trigger_per_player) && self.trigger_per_player)
	{
		if(!isdefined(self.playertrigger))
		{
			return;
		}
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(isdefined(self.playertrigger[players[i] getentitynumber()]))
			{
				self.playertrigger[players[i] getentitynumber()] [[self.prompt_and_visibility_func]](players[i]);
			}
		}
	}
	else if(isdefined(self.trigger))
	{
		self.trigger [[self.prompt_and_visibility_func]](getplayers()[0]);
	}
}

/*
	Name: is_same_trigger
	Namespace: zm_unitrigger
	Checksum: 0x8A578FBD
	Offset: 0x2208
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function is_same_trigger(old_trigger, trigger)
{
	return isdefined(old_trigger) && old_trigger == trigger && trigger.parent_player == old_trigger.parent_player;
}

/*
	Name: check_and_build_trigger_from_unitrigger_stub
	Namespace: zm_unitrigger
	Checksum: 0x7CEAC4A9
	Offset: 0x2258
	Size: 0x190
	Parameters: 2
	Flags: Linked
*/
function check_and_build_trigger_from_unitrigger_stub(stub, player)
{
	if(!isdefined(stub))
	{
		return undefined;
	}
	if(isdefined(stub.trigger_per_player) && stub.trigger_per_player)
	{
		if(!isdefined(stub.playertrigger))
		{
			stub.playertrigger = [];
		}
		if(!isdefined(stub.playertrigger[player getentitynumber()]))
		{
			trigger = build_trigger_from_unitrigger_stub(stub, player);
			level._unitriggers.trigger_pool[player getentitynumber()] = trigger;
		}
		else
		{
			trigger = stub.playertrigger[player getentitynumber()];
		}
	}
	else
	{
		if(!isdefined(stub.trigger))
		{
			trigger = build_trigger_from_unitrigger_stub(stub, player);
			level._unitriggers.trigger_pool[player getentitynumber()] = trigger;
		}
		else
		{
			trigger = stub.trigger;
		}
	}
	return trigger;
}

/*
	Name: build_trigger_from_unitrigger_stub
	Namespace: zm_unitrigger
	Checksum: 0x39B46354
	Offset: 0x23F0
	Size: 0x5FC
	Parameters: 2
	Flags: Linked
*/
function build_trigger_from_unitrigger_stub(stub, player)
{
	if(isdefined(level._zm_build_trigger_from_unitrigger_stub_override))
	{
		if(stub [[level._zm_build_trigger_from_unitrigger_stub_override]](player))
		{
			return;
		}
	}
	radius = stub.radius;
	if(!isdefined(radius))
	{
		radius = 64;
	}
	script_height = stub.script_height;
	if(!isdefined(script_height))
	{
		script_height = 64;
	}
	script_width = stub.script_width;
	if(!isdefined(script_width))
	{
		script_width = 64;
	}
	script_length = stub.script_length;
	if(!isdefined(script_length))
	{
		script_length = 64;
	}
	trigger = undefined;
	origin = stub unitrigger_origin();
	switch(stub.script_unitrigger_type)
	{
		case "unitrigger_radius":
		{
			trigger = spawn("trigger_radius", origin, 0, radius, script_height);
			break;
		}
		case "unitrigger_radius_use":
		{
			trigger = spawn("trigger_radius_use", origin, 0, radius, script_height);
			break;
		}
		case "unitrigger_box":
		{
			trigger = spawn("trigger_box", origin, 0, script_width, script_length, script_height);
			break;
		}
		case "unitrigger_box_use":
		{
			trigger = spawn("trigger_box_use", origin, 0, script_width, script_length, script_height);
			break;
		}
	}
	if(isdefined(trigger))
	{
		if(isdefined(stub.angles))
		{
			trigger.angles = stub.angles;
		}
		if(isdefined(stub.onspawnfunc))
		{
			stub [[stub.onspawnfunc]](trigger);
		}
		if(isdefined(stub.cursor_hint))
		{
			if(stub.cursor_hint == "HINT_WEAPON" && isdefined(stub.cursor_hint_weapon))
			{
				trigger setcursorhint(stub.cursor_hint, stub.cursor_hint_weapon);
			}
			else
			{
				trigger setcursorhint(stub.cursor_hint);
			}
		}
		trigger triggerignoreteam();
		if(isdefined(stub.require_look_at) && stub.require_look_at)
		{
			trigger usetriggerrequirelookat();
		}
		if(isdefined(stub.require_look_toward) && stub.require_look_toward)
		{
			trigger usetriggerrequirelooktoward(1);
		}
		if(isdefined(stub.hint_string))
		{
			if(isdefined(stub.hint_parm2))
			{
				trigger sethintstring(stub.hint_string, stub.hint_parm1, stub.hint_parm2);
			}
			else
			{
				if(isdefined(stub.hint_parm1))
				{
					trigger sethintstring(stub.hint_string, stub.hint_parm1);
				}
				else
				{
					if(isdefined(stub.cost) && (!(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)))
					{
						trigger sethintstring(stub.hint_string, stub.cost);
					}
					else
					{
						trigger sethintstring(stub.hint_string);
					}
				}
			}
		}
		trigger.stub = stub;
	}
	copy_zombie_keys_onto_trigger(trigger, stub);
	if(isdefined(stub.trigger_per_player) && stub.trigger_per_player)
	{
		if(isdefined(trigger))
		{
			trigger setinvisibletoall();
			trigger setvisibletoplayer(player);
		}
		if(!isdefined(stub.playertrigger))
		{
			stub.playertrigger = [];
		}
		stub.playertrigger[player getentitynumber()] = trigger;
	}
	else
	{
		stub.trigger = trigger;
	}
	trigger.thread_running = 0;
	return trigger;
}

/*
	Name: copy_zombie_keys_onto_trigger
	Namespace: zm_unitrigger
	Checksum: 0x531403D8
	Offset: 0x29F8
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function copy_zombie_keys_onto_trigger(trig, stub)
{
	trig.script_noteworthy = stub.script_noteworthy;
	trig.targetname = stub.targetname;
	trig.target = stub.target;
	trig.weapon = stub.weapon;
	trig.clientfieldname = stub.clientfieldname;
	trig.usetime = stub.usetime;
}

/*
	Name: trigger_thread
	Namespace: zm_unitrigger
	Checksum: 0xA5A9A85
	Offset: 0x2AC0
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function trigger_thread(trigger_func)
{
	self endon(#"kill_trigger");
	if(isdefined(trigger_func))
	{
		self [[trigger_func]]();
	}
}

/*
	Name: get_closest_unitriggers
	Namespace: zm_unitrigger
	Checksum: 0xF11F5A46
	Offset: 0x2AF8
	Size: 0x1F2
	Parameters: 3
	Flags: Linked
*/
function get_closest_unitriggers(org, array, dist = 9999999)
{
	triggers = [];
	if(array.size < 1)
	{
		return triggers;
	}
	distsq = dist * dist;
	for(i = 0; i < array.size; i++)
	{
		if(!isdefined(array[i]))
		{
			continue;
		}
		origin = array[i] unitrigger_origin();
		radius_sq = array[i].test_radius_sq;
		newdistsq = distance2dsquared(origin, org);
		if(newdistsq >= radius_sq)
		{
			continue;
		}
		if((abs(origin[2] - org[2])) > 42)
		{
			continue;
		}
		array[i].dsquared = newdistsq;
		for(j = 0; j < triggers.size && newdistsq > triggers[j].dsquared; j++)
		{
		}
		arrayinsert(triggers, array[i], j);
	}
	return triggers;
}

/*
	Name: create_unitrigger
	Namespace: zm_unitrigger
	Checksum: 0x6CD670B
	Offset: 0x2CF8
	Size: 0x180
	Parameters: 5
	Flags: None
*/
function create_unitrigger(str_hint, n_radius = 64, func_prompt_and_visibility = &unitrigger_prompt_and_visibility, func_unitrigger_logic = &unitrigger_logic, s_trigger_type = "unitrigger_radius_use")
{
	s_unitrigger = spawnstruct();
	s_unitrigger.origin = self.origin;
	s_unitrigger.angles = self.angles;
	s_unitrigger.script_unitrigger_type = s_trigger_type;
	s_unitrigger.cursor_hint = "HINT_NOICON";
	s_unitrigger.hint_string = str_hint;
	s_unitrigger.prompt_and_visibility_func = func_prompt_and_visibility;
	s_unitrigger.related_parent = self;
	s_unitrigger.radius = n_radius;
	self.s_unitrigger = s_unitrigger;
	register_static_unitrigger(s_unitrigger, func_unitrigger_logic);
	return s_unitrigger;
}

/*
	Name: create_dyn_unitrigger
	Namespace: zm_unitrigger
	Checksum: 0x9532399F
	Offset: 0x2E80
	Size: 0x180
	Parameters: 5
	Flags: None
*/
function create_dyn_unitrigger(str_hint, n_radius = 64, func_prompt_and_visibility = &unitrigger_prompt_and_visibility, func_unitrigger_logic = &unitrigger_logic, s_trigger_type = "unitrigger_radius_use")
{
	s_unitrigger = spawnstruct();
	s_unitrigger.origin = self.origin;
	s_unitrigger.angles = self.angles;
	s_unitrigger.script_unitrigger_type = s_trigger_type;
	s_unitrigger.cursor_hint = "HINT_NOICON";
	s_unitrigger.hint_string = str_hint;
	s_unitrigger.prompt_and_visibility_func = func_prompt_and_visibility;
	s_unitrigger.related_parent = self;
	s_unitrigger.radius = n_radius;
	self.s_unitrigger = s_unitrigger;
	register_dyn_unitrigger(s_unitrigger, func_unitrigger_logic);
	return s_unitrigger;
}

/*
	Name: unitrigger_prompt_and_visibility
	Namespace: zm_unitrigger
	Checksum: 0xA74ECF5
	Offset: 0x3008
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function unitrigger_prompt_and_visibility(player)
{
	b_visible = 1;
	return b_visible;
}

/*
	Name: unitrigger_logic
	Namespace: zm_unitrigger
	Checksum: 0x27310E56
	Offset: 0x3038
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function unitrigger_logic()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger", player);
		if(player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(player.is_drinking > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(player))
		{
			continue;
		}
		self.stub.related_parent notify(#"trigger_activated", player);
	}
}

