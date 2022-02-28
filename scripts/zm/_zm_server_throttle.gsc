// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\zm\_zm_utility;

#namespace zm_server_throttle;

/*
	Name: server_choke_init
	Namespace: zm_server_throttle
	Checksum: 0x7BC7A003
	Offset: 0xB0
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function server_choke_init(id, max)
{
	if(!isdefined(level.zombie_server_choke_ids_max))
	{
		level.zombie_server_choke_ids_max = [];
		level.zombie_server_choke_ids_count = [];
	}
	level.zombie_server_choke_ids_max[id] = max;
	level.zombie_server_choke_ids_count[id] = 0;
	level thread server_choke_thread(id);
}

/*
	Name: server_choke_thread
	Namespace: zm_server_throttle
	Checksum: 0x638EF7D2
	Offset: 0x130
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function server_choke_thread(id)
{
	while(true)
	{
		wait(0.05);
		level.zombie_server_choke_ids_count[id] = 0;
	}
}

/*
	Name: server_choke_safe
	Namespace: zm_server_throttle
	Checksum: 0xCEF6E541
	Offset: 0x170
	Size: 0x26
	Parameters: 1
	Flags: Linked
*/
function server_choke_safe(id)
{
	return level.zombie_server_choke_ids_count[id] < level.zombie_server_choke_ids_max[id];
}

/*
	Name: server_choke_action
	Namespace: zm_server_throttle
	Checksum: 0xC82F66B4
	Offset: 0x1A0
	Size: 0xFE
	Parameters: 5
	Flags: Linked
*/
function server_choke_action(id, choke_action, arg1, arg2, arg3)
{
	/#
		assert(isdefined(level.zombie_server_choke_ids_max[id]), ("" + id) + "");
	#/
	while(!server_choke_safe(id))
	{
		wait(0.05);
	}
	level.zombie_server_choke_ids_count[id]++;
	if(!isdefined(arg1))
	{
		return [[choke_action]]();
	}
	if(!isdefined(arg2))
	{
		return [[choke_action]](arg1);
	}
	if(!isdefined(arg3))
	{
		return [[choke_action]](arg1, arg2);
	}
	return [[choke_action]](arg1, arg2, arg3);
}

/*
	Name: server_entity_valid
	Namespace: zm_server_throttle
	Checksum: 0xD87BA92A
	Offset: 0x2A8
	Size: 0x1E
	Parameters: 1
	Flags: None
*/
function server_entity_valid(entity)
{
	if(!isdefined(entity))
	{
		return false;
	}
	return true;
}

/*
	Name: server_safe_init
	Namespace: zm_server_throttle
	Checksum: 0xB249DA33
	Offset: 0x2D0
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function server_safe_init(id, max)
{
	if(!isdefined(level.zombie_server_choke_ids_max) || !isdefined(level.zombie_server_choke_ids_max[id]))
	{
		server_choke_init(id, max);
	}
	/#
		assert(max == level.zombie_server_choke_ids_max[id]);
	#/
}

/*
	Name: _server_safe_ground_trace
	Namespace: zm_server_throttle
	Checksum: 0xE52C4F7C
	Offset: 0x358
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function _server_safe_ground_trace(pos)
{
	return zm_utility::groundpos(pos);
}

/*
	Name: server_safe_ground_trace
	Namespace: zm_server_throttle
	Checksum: 0x7060EE1C
	Offset: 0x388
	Size: 0x5A
	Parameters: 3
	Flags: Linked
*/
function server_safe_ground_trace(id, max, origin)
{
	server_safe_init(id, max);
	return server_choke_action(id, &_server_safe_ground_trace, origin);
}

/*
	Name: _server_safe_ground_trace_ignore_water
	Namespace: zm_server_throttle
	Checksum: 0xBEA1832
	Offset: 0x3F0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function _server_safe_ground_trace_ignore_water(pos)
{
	return zm_utility::groundpos_ignore_water(pos);
}

/*
	Name: server_safe_ground_trace_ignore_water
	Namespace: zm_server_throttle
	Checksum: 0x924C085A
	Offset: 0x420
	Size: 0x5A
	Parameters: 3
	Flags: None
*/
function server_safe_ground_trace_ignore_water(id, max, origin)
{
	server_safe_init(id, max);
	return server_choke_action(id, &_server_safe_ground_trace_ignore_water, origin);
}

