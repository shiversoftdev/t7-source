// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;

#namespace zm_power;

/*
	Name: __init__sytem__
	Namespace: zm_power
	Checksum: 0x9D24991
	Offset: 0x348
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_power", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_power
	Checksum: 0x1C217DAA
	Offset: 0x390
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.powered_items = [];
	level.local_power = [];
}

/*
	Name: __main__
	Namespace: zm_power
	Checksum: 0x288A06E2
	Offset: 0x3B8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	thread standard_powered_items();
	level thread electric_switch_init();
	/#
		thread debug_powered_items();
	#/
}

/*
	Name: debug_powered_items
	Namespace: zm_power
	Checksum: 0xEFB921AF
	Offset: 0x408
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function debug_powered_items()
{
	/#
		while(true)
		{
			if(getdvarint(""))
			{
				if(isdefined(level.local_power))
				{
					foreach(localpower in level.local_power)
					{
						circle(localpower.origin, localpower.radius, (1, 0, 0), 0, 1, 1);
					}
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: electric_switch_init
	Namespace: zm_power
	Checksum: 0xFE37E5D
	Offset: 0x500
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function electric_switch_init()
{
	trigs = getentarray("use_elec_switch", "targetname");
	if(isdefined(level.temporary_power_switch_logic))
	{
		array::thread_all(trigs, level.temporary_power_switch_logic, trigs);
	}
	else
	{
		array::thread_all(trigs, &electric_switch, trigs);
	}
}

/*
	Name: electric_switch
	Namespace: zm_power
	Checksum: 0x2D686987
	Offset: 0x590
	Size: 0x558
	Parameters: 1
	Flags: Linked
*/
function electric_switch(switch_array)
{
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.target))
	{
		ent_parts = getentarray(self.target, "targetname");
		struct_parts = struct::get_array(self.target, "targetname");
		foreach(ent in ent_parts)
		{
			if(isdefined(ent.script_noteworthy) && ent.script_noteworthy == "elec_switch")
			{
				master_switch = ent;
				master_switch notsolid();
			}
		}
		foreach(struct in struct_parts)
		{
			if(isdefined(struct.script_noteworthy) && struct.script_noteworthy == "elec_switch_fx")
			{
				fx_pos = struct;
			}
		}
	}
	while(isdefined(self))
	{
		self sethintstring(&"ZOMBIE_ELECTRIC_SWITCH");
		self setvisibletoall();
		self waittill(#"trigger", user);
		self setinvisibletoall();
		if(isdefined(master_switch))
		{
			master_switch rotateroll(-90, 0.3);
			master_switch playsound("zmb_switch_flip");
		}
		power_zone = undefined;
		if(isdefined(self.script_int))
		{
			power_zone = self.script_int;
		}
		level thread zm_perks::perk_unpause_all_perks(power_zone);
		if(isdefined(master_switch))
		{
			master_switch waittill(#"rotatedone");
			playfx(level._effect["switch_sparks"], fx_pos.origin);
			master_switch playsound("zmb_turn_on");
		}
		level turn_power_on_and_open_doors(power_zone);
		switchentnum = self getentitynumber();
		if(isdefined(switchentnum) && isdefined(user))
		{
			user recordmapevent(17, gettime(), user.origin, level.round_number, switchentnum);
		}
		if(!isdefined(self.script_noteworthy) || self.script_noteworthy != "allow_power_off")
		{
			self delete();
			return;
		}
		self sethintstring(&"ZOMBIE_ELECTRIC_SWITCH_OFF");
		self setvisibletoall();
		self waittill(#"trigger", user);
		self setinvisibletoall();
		if(isdefined(master_switch))
		{
			master_switch rotateroll(90, 0.3);
			master_switch playsound("zmb_switch_flip");
		}
		level thread zm_perks::perk_pause_all_perks(power_zone);
		if(isdefined(master_switch))
		{
			master_switch waittill(#"rotatedone");
		}
		if(isdefined(switchentnum) && isdefined(user))
		{
			user recordmapevent(18, gettime(), user.origin, level.round_number, switchentnum);
		}
		level turn_power_off_and_close_doors(power_zone);
	}
}

/*
	Name: watch_global_power
	Namespace: zm_power
	Checksum: 0xF25715A
	Offset: 0xAF0
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function watch_global_power()
{
	while(true)
	{
		level flag::wait_till("power_on");
		level thread set_global_power(1);
		level flag::wait_till_clear("power_on");
		level thread set_global_power(0);
	}
}

/*
	Name: standard_powered_items
	Namespace: zm_power
	Checksum: 0xB9327CEE
	Offset: 0xB78
	Size: 0x394
	Parameters: 0
	Flags: Linked
*/
function standard_powered_items()
{
	level flag::wait_till("start_zombie_round_logic");
	vending_triggers = getentarray("zombie_vending", "targetname");
	foreach(trigger in vending_triggers)
	{
		powered_on = zm_perks::get_perk_machine_start_state(trigger.script_noteworthy);
		powered_perk = add_powered_item(&perk_power_on, &perk_power_off, &perk_range, &cost_low_if_local, 0, powered_on, trigger);
		if(isdefined(trigger.script_int))
		{
			powered_perk thread zone_controlled_perk(trigger.script_int);
		}
	}
	zombie_doors = getentarray("zombie_door", "targetname");
	foreach(door in zombie_doors)
	{
		if(isdefined(door.script_noteworthy) && (door.script_noteworthy == "electric_door" || door.script_noteworthy == "electric_buyable_door"))
		{
			add_powered_item(&door_power_on, &door_power_off, &door_range, &cost_door, 0, 0, door);
			continue;
		}
		if(isdefined(door.script_noteworthy) && door.script_noteworthy == "local_electric_door")
		{
			power_sources = 0;
			if(!(isdefined(level.power_local_doors_globally) && level.power_local_doors_globally))
			{
				power_sources = 1;
			}
			add_powered_item(&door_local_power_on, &door_local_power_off, &door_range, &cost_door, power_sources, 0, door);
		}
	}
	thread watch_global_power();
}

/*
	Name: zone_controlled_perk
	Namespace: zm_power
	Checksum: 0x5178115D
	Offset: 0xF18
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function zone_controlled_perk(zone)
{
	while(true)
	{
		power_flag = "power_on" + zone;
		level flag::wait_till(power_flag);
		self thread perk_power_on();
		level flag::wait_till_clear(power_flag);
		self thread perk_power_off();
	}
}

/*
	Name: add_powered_item
	Namespace: zm_power
	Checksum: 0xA4EE2AB8
	Offset: 0xFB0
	Size: 0x136
	Parameters: 7
	Flags: Linked
*/
function add_powered_item(power_on_func, power_off_func, range_func, cost_func, power_sources, self_powered, target)
{
	powered = spawnstruct();
	powered.power_on_func = power_on_func;
	powered.power_off_func = power_off_func;
	powered.range_func = range_func;
	powered.power_sources = power_sources;
	powered.self_powered = self_powered;
	powered.target = target;
	powered.cost_func = cost_func;
	powered.power = self_powered;
	powered.powered_count = self_powered;
	powered.depowered_count = 0;
	level.powered_items[level.powered_items.size] = powered;
	return powered;
}

/*
	Name: remove_powered_item
	Namespace: zm_power
	Checksum: 0x4D2FF890
	Offset: 0x10F0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function remove_powered_item(powered)
{
	arrayremovevalue(level.powered_items, powered, 0);
}

/*
	Name: add_temp_powered_item
	Namespace: zm_power
	Checksum: 0x59EBE7C1
	Offset: 0x1128
	Size: 0x1C8
	Parameters: 7
	Flags: None
*/
function add_temp_powered_item(power_on_func, power_off_func, range_func, cost_func, power_sources, self_powered, target)
{
	powered = add_powered_item(power_on_func, power_off_func, range_func, cost_func, power_sources, self_powered, target);
	if(isdefined(level.local_power))
	{
		foreach(localpower in level.local_power)
		{
			if(powered [[powered.range_func]](1, localpower.origin, localpower.radius))
			{
				powered change_power(1, localpower.origin, localpower.radius);
				if(!isdefined(localpower.added_list))
				{
					localpower.added_list = [];
				}
				localpower.added_list[localpower.added_list.size] = powered;
			}
		}
	}
	thread watch_temp_powered_item(powered);
	return powered;
}

/*
	Name: watch_temp_powered_item
	Namespace: zm_power
	Checksum: 0xB11C6E5
	Offset: 0x12F8
	Size: 0x12A
	Parameters: 1
	Flags: Linked
*/
function watch_temp_powered_item(powered)
{
	powered.target waittill(#"death");
	remove_powered_item(powered);
	if(isdefined(level.local_power))
	{
		foreach(localpower in level.local_power)
		{
			if(isdefined(localpower.added_list))
			{
				arrayremovevalue(localpower.added_list, powered, 0);
			}
			if(isdefined(localpower.enabled_list))
			{
				arrayremovevalue(localpower.enabled_list, powered, 0);
			}
		}
	}
}

/*
	Name: change_power_in_radius
	Namespace: zm_power
	Checksum: 0x64CC3CEE
	Offset: 0x1430
	Size: 0xEC
	Parameters: 3
	Flags: Linked
*/
function change_power_in_radius(delta, origin, radius)
{
	changed_list = [];
	for(i = 0; i < level.powered_items.size; i++)
	{
		powered = level.powered_items[i];
		if(powered.power_sources != 2)
		{
			if(powered [[powered.range_func]](delta, origin, radius))
			{
				powered change_power(delta, origin, radius);
				changed_list[changed_list.size] = powered;
			}
		}
	}
	return changed_list;
}

/*
	Name: change_power
	Namespace: zm_power
	Checksum: 0x522DA944
	Offset: 0x1528
	Size: 0xA4
	Parameters: 3
	Flags: Linked
*/
function change_power(delta, origin, radius)
{
	if(delta > 0)
	{
		if(!self.power)
		{
			self.power = 1;
			self [[self.power_on_func]](origin, radius);
		}
		self.powered_count++;
	}
	else if(delta < 0)
	{
		if(self.power)
		{
			self.power = 0;
			self [[self.power_off_func]](origin, radius);
		}
		self.depowered_count++;
	}
}

/*
	Name: revert_power_to_list
	Namespace: zm_power
	Checksum: 0xFFB25B9C
	Offset: 0x15D8
	Size: 0x86
	Parameters: 4
	Flags: Linked
*/
function revert_power_to_list(delta, origin, radius, powered_list)
{
	for(i = 0; i < powered_list.size; i++)
	{
		powered = powered_list[i];
		powered revert_power(delta, origin, radius);
	}
}

/*
	Name: revert_power
	Namespace: zm_power
	Checksum: 0xB1BF899B
	Offset: 0x1668
	Size: 0x130
	Parameters: 4
	Flags: Linked
*/
function revert_power(delta, origin, radius, powered_list)
{
	if(delta > 0)
	{
		self.depowered_count--;
		/#
			assert(self.depowered_count >= 0, "");
		#/
		if(self.depowered_count == 0 && self.powered_count > 0 && !self.power)
		{
			self.power = 1;
			self [[self.power_on_func]](origin, radius);
		}
	}
	else if(delta < 0)
	{
		self.powered_count--;
		/#
			assert(self.powered_count >= 0, "");
		#/
		if(self.powered_count == 0 && self.power)
		{
			self.power = 0;
			self [[self.power_off_func]](origin, radius);
		}
	}
}

/*
	Name: add_local_power
	Namespace: zm_power
	Checksum: 0x51C24384
	Offset: 0x17A0
	Size: 0xDA
	Parameters: 2
	Flags: None
*/
function add_local_power(origin, radius)
{
	localpower = spawnstruct();
	/#
		println(((("" + origin) + "") + radius) + "");
	#/
	localpower.origin = origin;
	localpower.radius = radius;
	localpower.enabled_list = change_power_in_radius(1, origin, radius);
	level.local_power[level.local_power.size] = localpower;
	return localpower;
}

/*
	Name: move_local_power
	Namespace: zm_power
	Checksum: 0xA5430C8D
	Offset: 0x1888
	Size: 0x1DC
	Parameters: 2
	Flags: None
*/
function move_local_power(localpower, origin)
{
	changed_list = [];
	for(i = 0; i < level.powered_items.size; i++)
	{
		powered = level.powered_items[i];
		if(powered.power_sources == 2)
		{
			continue;
		}
		waspowered = isinarray(localpower.enabled_list, powered);
		ispowered = powered [[powered.range_func]](1, origin, localpower.radius);
		if(ispowered && !waspowered)
		{
			powered change_power(1, origin, localpower.radius);
			localpower.enabled_list[localpower.enabled_list.size] = powered;
			continue;
		}
		if(!ispowered && waspowered)
		{
			powered revert_power(-1, localpower.origin, localpower.radius, localpower.enabled_list);
			arrayremovevalue(localpower.enabled_list, powered, 0);
		}
	}
	localpower.origin = origin;
	return localpower;
}

/*
	Name: end_local_power
	Namespace: zm_power
	Checksum: 0xF495497B
	Offset: 0x1A70
	Size: 0x134
	Parameters: 1
	Flags: None
*/
function end_local_power(localpower)
{
	/#
		println(((("" + localpower.origin) + "") + localpower.radius) + "");
	#/
	if(isdefined(localpower.enabled_list))
	{
		revert_power_to_list(-1, localpower.origin, localpower.radius, localpower.enabled_list);
	}
	localpower.enabled_list = undefined;
	if(isdefined(localpower.added_list))
	{
		revert_power_to_list(-1, localpower.origin, localpower.radius, localpower.added_list);
	}
	localpower.added_list = undefined;
	arrayremovevalue(level.local_power, localpower, 0);
}

/*
	Name: has_local_power
	Namespace: zm_power
	Checksum: 0xEC5B16DA
	Offset: 0x1BB0
	Size: 0xD0
	Parameters: 1
	Flags: None
*/
function has_local_power(origin)
{
	if(isdefined(level.local_power))
	{
		foreach(localpower in level.local_power)
		{
			if(distancesquared(localpower.origin, origin) < (localpower.radius * localpower.radius))
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: get_powered_item_cost
	Namespace: zm_power
	Checksum: 0xF227A709
	Offset: 0x1C88
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function get_powered_item_cost()
{
	if(!(isdefined(self.power) && self.power))
	{
		return 0;
	}
	if(isdefined(level._power_global) && level._power_global && !self.power_sources == 1)
	{
		return 0;
	}
	cost = [[self.cost_func]]();
	power_sources = self.powered_count;
	if(power_sources < 1)
	{
		power_sources = 1;
	}
	return cost / power_sources;
}

/*
	Name: get_local_power_cost
	Namespace: zm_power
	Checksum: 0x256F808B
	Offset: 0x1D30
	Size: 0x184
	Parameters: 1
	Flags: None
*/
function get_local_power_cost(localpower)
{
	cost = 0;
	if(isdefined(localpower) && isdefined(localpower.enabled_list))
	{
		foreach(powered in localpower.enabled_list)
		{
			cost = cost + powered get_powered_item_cost();
		}
	}
	if(isdefined(localpower) && isdefined(localpower.added_list))
	{
		foreach(powered in localpower.added_list)
		{
			cost = cost + powered get_powered_item_cost();
		}
	}
	return cost;
}

/*
	Name: set_global_power
	Namespace: zm_power
	Checksum: 0xB59CD9B4
	Offset: 0x1EC0
	Size: 0xD6
	Parameters: 1
	Flags: Linked
*/
function set_global_power(on_off)
{
	demo::bookmark("zm_power", gettime(), undefined, undefined, 1);
	level._power_global = on_off;
	for(i = 0; i < level.powered_items.size; i++)
	{
		powered = level.powered_items[i];
		if(isdefined(powered.target) && powered.power_sources != 1)
		{
			powered global_power(on_off);
			util::wait_network_frame();
		}
	}
}

/*
	Name: global_power
	Namespace: zm_power
	Checksum: 0x358B3B94
	Offset: 0x1FA0
	Size: 0xE8
	Parameters: 1
	Flags: Linked
*/
function global_power(on_off)
{
	if(on_off)
	{
		/#
			println("");
		#/
		if(!self.power)
		{
			self.power = 1;
			self [[self.power_on_func]]();
		}
		self.powered_count++;
	}
	else
	{
		/#
			println("");
		#/
		self.powered_count--;
		/#
			assert(self.powered_count >= 0, "");
		#/
		if(self.powered_count == 0 && self.power)
		{
			self.power = 0;
			self [[self.power_off_func]]();
		}
	}
}

/*
	Name: never_power_on
	Namespace: zm_power
	Checksum: 0xFE136BE2
	Offset: 0x2090
	Size: 0x14
	Parameters: 2
	Flags: None
*/
function never_power_on(origin, radius)
{
}

/*
	Name: never_power_off
	Namespace: zm_power
	Checksum: 0xF9BF478E
	Offset: 0x20B0
	Size: 0x14
	Parameters: 2
	Flags: None
*/
function never_power_off(origin, radius)
{
}

/*
	Name: cost_negligible
	Namespace: zm_power
	Checksum: 0x95F32F82
	Offset: 0x20D0
	Size: 0x36
	Parameters: 0
	Flags: None
*/
function cost_negligible()
{
	if(isdefined(self.one_time_cost))
	{
		cost = self.one_time_cost;
		self.one_time_cost = undefined;
		return cost;
	}
	return 0;
}

/*
	Name: cost_low_if_local
	Namespace: zm_power
	Checksum: 0xAAA78D1C
	Offset: 0x2110
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function cost_low_if_local()
{
	if(isdefined(self.one_time_cost))
	{
		cost = self.one_time_cost;
		self.one_time_cost = undefined;
		return cost;
	}
	if(isdefined(level._power_global) && level._power_global)
	{
		return 0;
	}
	if(isdefined(self.self_powered) && self.self_powered)
	{
		return 0;
	}
	return 1;
}

/*
	Name: cost_high
	Namespace: zm_power
	Checksum: 0x3513DFB0
	Offset: 0x2188
	Size: 0x38
	Parameters: 0
	Flags: None
*/
function cost_high()
{
	if(isdefined(self.one_time_cost))
	{
		cost = self.one_time_cost;
		self.one_time_cost = undefined;
		return cost;
	}
	return 10;
}

/*
	Name: door_range
	Namespace: zm_power
	Checksum: 0xBEB4323D
	Offset: 0x21C8
	Size: 0x6A
	Parameters: 3
	Flags: Linked
*/
function door_range(delta, origin, radius)
{
	if(delta < 0)
	{
		return false;
	}
	if(distancesquared(self.target.origin, origin) < (radius * radius))
	{
		return true;
	}
	return false;
}

/*
	Name: door_power_on
	Namespace: zm_power
	Checksum: 0xC771F54D
	Offset: 0x2240
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function door_power_on(origin, radius)
{
	/#
		println("");
	#/
	self.target.power_on = 1;
	self.target notify(#"power_on");
}

/*
	Name: door_power_off
	Namespace: zm_power
	Checksum: 0xC649F6
	Offset: 0x22A8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function door_power_off(origin, radius)
{
	/#
		println("");
	#/
	self.target notify(#"power_off");
	self.target.power_on = 0;
}

/*
	Name: door_local_power_on
	Namespace: zm_power
	Checksum: 0x2210BC04
	Offset: 0x2310
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function door_local_power_on(origin, radius)
{
	/#
		println("");
	#/
	self.target.local_power_on = 1;
	self.target notify(#"local_power_on");
}

/*
	Name: door_local_power_off
	Namespace: zm_power
	Checksum: 0x4E5D2EB9
	Offset: 0x2378
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function door_local_power_off(origin, radius)
{
	/#
		println("");
	#/
	self.target notify(#"local_power_off");
	self.target.local_power_on = 0;
}

/*
	Name: cost_door
	Namespace: zm_power
	Checksum: 0x564679F6
	Offset: 0x23E0
	Size: 0x96
	Parameters: 0
	Flags: Linked
*/
function cost_door()
{
	if(isdefined(self.target.power_cost))
	{
		if(!isdefined(self.one_time_cost))
		{
			self.one_time_cost = 0;
		}
		self.one_time_cost = self.one_time_cost + self.target.power_cost;
		self.target.power_cost = 0;
	}
	if(isdefined(self.one_time_cost))
	{
		cost = self.one_time_cost;
		self.one_time_cost = undefined;
		return cost;
	}
	return 0;
}

/*
	Name: zombie_range
	Namespace: zm_power
	Checksum: 0x9CE183F0
	Offset: 0x2480
	Size: 0x84
	Parameters: 3
	Flags: None
*/
function zombie_range(delta, origin, radius)
{
	if(delta > 0)
	{
		return false;
	}
	self.zombies = array::get_all_closest(origin, zombie_utility::get_round_enemy_array(), undefined, undefined, radius);
	if(!isdefined(self.zombies))
	{
		return false;
	}
	self.power = 1;
	return true;
}

/*
	Name: zombie_power_off
	Namespace: zm_power
	Checksum: 0x6937EC36
	Offset: 0x2510
	Size: 0x86
	Parameters: 2
	Flags: None
*/
function zombie_power_off(origin, radius)
{
	/#
		println("");
	#/
	for(i = 0; i < self.zombies.size; i++)
	{
		self.zombies[i] thread stun_zombie();
		wait(0.05);
	}
}

/*
	Name: stun_zombie
	Namespace: zm_power
	Checksum: 0xD03C1990
	Offset: 0x25A0
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function stun_zombie()
{
	self endon(#"death");
	self notify(#"stun_zombie");
	self endon(#"stun_zombie");
	if(self.health <= 0)
	{
		/#
			iprintln("");
		#/
		return;
	}
	if(isdefined(self.ignore_inert) && self.ignore_inert)
	{
		return;
	}
	if(isdefined(self.stun_zombie))
	{
		self thread [[self.stun_zombie]]();
		return;
	}
}

/*
	Name: perk_range
	Namespace: zm_power
	Checksum: 0xC04CE1D3
	Offset: 0x2638
	Size: 0xF2
	Parameters: 3
	Flags: Linked
*/
function perk_range(delta, origin, radius)
{
	if(isdefined(self.target))
	{
		perkorigin = self.target.origin;
		if(isdefined(self.target.trigger_off) && self.target.trigger_off)
		{
			perkorigin = self.target.realorigin;
		}
		else if(isdefined(self.target.disabled) && self.target.disabled)
		{
			perkorigin = perkorigin + vectorscale((0, 0, 1), 10000);
		}
		if(distancesquared(perkorigin, origin) < (radius * radius))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: perk_power_on
	Namespace: zm_power
	Checksum: 0x8BAD1C29
	Offset: 0x2738
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function perk_power_on(origin, radius)
{
	/#
		println(("" + self.target zm_perks::getvendingmachinenotify()) + "");
	#/
	level notify(self.target zm_perks::getvendingmachinenotify() + "_on");
	zm_perks::perk_unpause(self.target.script_noteworthy);
}

/*
	Name: perk_power_off
	Namespace: zm_power
	Checksum: 0x37E84189
	Offset: 0x27E0
	Size: 0x180
	Parameters: 2
	Flags: Linked
*/
function perk_power_off(origin, radius)
{
	notify_name = self.target zm_perks::getvendingmachinenotify();
	if(isdefined(notify_name) && notify_name == "revive")
	{
		if(level flag::exists("solo_game") && level flag::get("solo_game"))
		{
			return;
		}
	}
	/#
		println(("" + self.target.script_noteworthy) + "");
	#/
	self.target notify(#"death");
	self.target thread zm_perks::vending_trigger_think();
	if(isdefined(self.target.perk_hum))
	{
		self.target.perk_hum delete();
	}
	zm_perks::perk_pause(self.target.script_noteworthy);
	level notify(self.target zm_perks::getvendingmachinenotify() + "_off");
}

/*
	Name: turn_power_on_and_open_doors
	Namespace: zm_power
	Checksum: 0x8D4D5068
	Offset: 0x2968
	Size: 0x2AE
	Parameters: 1
	Flags: Linked
*/
function turn_power_on_and_open_doors(power_zone)
{
	level.local_doors_stay_open = 1;
	level.power_local_doors_globally = 1;
	if(!isdefined(power_zone))
	{
		level flag::set("power_on");
		level clientfield::set("zombie_power_on", 0);
	}
	else
	{
		level flag::set("power_on" + power_zone);
		level clientfield::set("zombie_power_on", power_zone);
	}
	zombie_doors = getentarray("zombie_door", "targetname");
	foreach(door in zombie_doors)
	{
		if(!isdefined(door.script_noteworthy))
		{
			continue;
		}
		if(!isdefined(power_zone) && (door.script_noteworthy == "electric_door" || door.script_noteworthy == "electric_buyable_door"))
		{
			door notify(#"power_on");
			continue;
		}
		if(isdefined(door.script_int) && door.script_int == power_zone && (door.script_noteworthy == "electric_door" || door.script_noteworthy == "electric_buyable_door"))
		{
			door notify(#"power_on");
			if(isdefined(level.temporary_power_switch_logic))
			{
				door.power_on = 1;
			}
			continue;
		}
		if(isdefined(door.script_int) && door.script_int == power_zone && door.script_noteworthy === "local_electric_door")
		{
			door notify(#"local_power_on");
		}
	}
}

/*
	Name: turn_power_off_and_close_doors
	Namespace: zm_power
	Checksum: 0x62AC6B9C
	Offset: 0x2C20
	Size: 0x2D6
	Parameters: 1
	Flags: Linked
*/
function turn_power_off_and_close_doors(power_zone)
{
	level.local_doors_stay_open = 0;
	level.power_local_doors_globally = 0;
	if(!isdefined(power_zone))
	{
		level flag::clear("power_on");
		level clientfield::set("zombie_power_off", 0);
	}
	else
	{
		level flag::clear("power_on" + power_zone);
		level clientfield::set("zombie_power_off", power_zone);
	}
	zombie_doors = getentarray("zombie_door", "targetname");
	foreach(door in zombie_doors)
	{
		if(!isdefined(door.script_noteworthy))
		{
			continue;
		}
		if(!isdefined(power_zone) && (door.script_noteworthy == "electric_door" || door.script_noteworthy == "electric_buyable_door"))
		{
			door notify(#"power_on");
			continue;
		}
		if(isdefined(door.script_int) && door.script_int == power_zone && (door.script_noteworthy == "electric_door" || door.script_noteworthy == "electric_buyable_door"))
		{
			door notify(#"power_on");
			if(isdefined(level.temporary_power_switch_logic))
			{
				door.power_on = 0;
				door sethintstring(&"ZOMBIE_NEED_POWER");
				door notify(#"kill_door_think");
				door thread zm_blockers::door_think();
			}
			continue;
		}
		if(isdefined(door.script_noteworthy) && door.script_noteworthy == "local_electric_door")
		{
			door notify(#"local_power_on");
		}
	}
}

