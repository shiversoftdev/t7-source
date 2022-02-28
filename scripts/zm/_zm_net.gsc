// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\util_shared;

#namespace zm_net;

/*
	Name: network_choke_init
	Namespace: zm_net
	Checksum: 0xA1DA08C3
	Offset: 0xA8
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function network_choke_init(id, max)
{
	if(!isdefined(level.zombie_network_choke_ids_max))
	{
		level.zombie_network_choke_ids_max = [];
		level.zombie_network_choke_ids_count = [];
	}
	level.zombie_network_choke_ids_max[id] = max;
	level.zombie_network_choke_ids_count[id] = 0;
	level thread network_choke_thread(id);
}

/*
	Name: network_choke_thread
	Namespace: zm_net
	Checksum: 0x73C8D11B
	Offset: 0x128
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function network_choke_thread(id)
{
	while(true)
	{
		util::wait_network_frame();
		util::wait_network_frame();
		level.zombie_network_choke_ids_count[id] = 0;
	}
}

/*
	Name: network_choke_safe
	Namespace: zm_net
	Checksum: 0x4BB00CEE
	Offset: 0x180
	Size: 0x26
	Parameters: 1
	Flags: Linked
*/
function network_choke_safe(id)
{
	return level.zombie_network_choke_ids_count[id] < level.zombie_network_choke_ids_max[id];
}

/*
	Name: network_choke_action
	Namespace: zm_net
	Checksum: 0x53E1A62C
	Offset: 0x1B0
	Size: 0xFE
	Parameters: 5
	Flags: Linked
*/
function network_choke_action(id, choke_action, arg1, arg2, arg3)
{
	/#
		assert(isdefined(level.zombie_network_choke_ids_max[id]), ("" + id) + "");
	#/
	while(!network_choke_safe(id))
	{
		wait(0.05);
	}
	level.zombie_network_choke_ids_count[id]++;
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
	Name: network_entity_valid
	Namespace: zm_net
	Checksum: 0x83EBE64A
	Offset: 0x2B8
	Size: 0x1E
	Parameters: 1
	Flags: Linked
*/
function network_entity_valid(entity)
{
	if(!isdefined(entity))
	{
		return false;
	}
	return true;
}

/*
	Name: network_safe_init
	Namespace: zm_net
	Checksum: 0x9EE5E724
	Offset: 0x2E0
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function network_safe_init(id, max)
{
	if(!isdefined(level.zombie_network_choke_ids_max) || !isdefined(level.zombie_network_choke_ids_max[id]))
	{
		network_choke_init(id, max);
	}
	/#
		assert(max == level.zombie_network_choke_ids_max[id]);
	#/
}

/*
	Name: _network_safe_spawn
	Namespace: zm_net
	Checksum: 0xB6A05505
	Offset: 0x368
	Size: 0x2A
	Parameters: 2
	Flags: Linked
*/
function _network_safe_spawn(classname, origin)
{
	return spawn(classname, origin);
}

/*
	Name: network_safe_spawn
	Namespace: zm_net
	Checksum: 0xB95F31D6
	Offset: 0x3A0
	Size: 0x62
	Parameters: 4
	Flags: Linked
*/
function network_safe_spawn(id, max, classname, origin)
{
	network_safe_init(id, max);
	return network_choke_action(id, &_network_safe_spawn, classname, origin);
}

/*
	Name: _network_safe_play_fx_on_tag
	Namespace: zm_net
	Checksum: 0x500E8AB9
	Offset: 0x410
	Size: 0x54
	Parameters: 3
	Flags: Linked
*/
function _network_safe_play_fx_on_tag(fx, entity, tag)
{
	if(network_entity_valid(entity))
	{
		playfxontag(fx, entity, tag);
	}
}

/*
	Name: network_safe_play_fx_on_tag
	Namespace: zm_net
	Checksum: 0xC9E60C48
	Offset: 0x470
	Size: 0x74
	Parameters: 5
	Flags: Linked
*/
function network_safe_play_fx_on_tag(id, max, fx, entity, tag)
{
	network_safe_init(id, max);
	network_choke_action(id, &_network_safe_play_fx_on_tag, fx, entity, tag);
}

