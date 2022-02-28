// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace _gadget_firefly_swarm;

/*
	Name: __init__sytem__
	Namespace: _gadget_firefly_swarm
	Checksum: 0xED6C97B6
	Offset: 0x200
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_firefly_swarm", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_firefly_swarm
	Checksum: 0xB4F0F09D
	Offset: 0x240
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(35, &gadget_firefly_swarm_on, &gadget_firefly_swarm_off);
	ability_player::register_gadget_possession_callbacks(35, &gadget_firefly_swarm_on_give, &gadget_firefly_swarm_on_take);
	ability_player::register_gadget_flicker_callbacks(35, &gadget_firefly_swarm_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(35, &gadget_firefly_swarm_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(35, &gadget_firefly_swarm_is_flickering);
	ability_player::register_gadget_primed_callbacks(35, &gadget_firefly_is_primed);
	callback::on_connect(&gadget_firefly_swarm_on_connect);
}

/*
	Name: gadget_firefly_swarm_is_inuse
	Namespace: _gadget_firefly_swarm
	Checksum: 0xC4F078D8
	Offset: 0x350
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_firefly_swarm_is_inuse(slot)
{
	return self flagsys::get("gadget_firefly_swarm_on");
}

/*
	Name: gadget_firefly_swarm_is_flickering
	Namespace: _gadget_firefly_swarm
	Checksum: 0x1279F92D
	Offset: 0x388
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function gadget_firefly_swarm_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.firefly_swarm))
	{
		return self [[level.cybercom.firefly_swarm._is_flickering]](slot);
	}
	return 0;
}

/*
	Name: gadget_firefly_swarm_on_flicker
	Namespace: _gadget_firefly_swarm
	Checksum: 0xF7620F68
	Offset: 0x3E8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_firefly_swarm_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.firefly_swarm))
	{
		self [[level.cybercom.firefly_swarm._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_firefly_swarm_on_give
	Namespace: _gadget_firefly_swarm
	Checksum: 0xBF0287B7
	Offset: 0x450
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_firefly_swarm_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.firefly_swarm))
	{
		self [[level.cybercom.firefly_swarm._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_firefly_swarm_on_take
	Namespace: _gadget_firefly_swarm
	Checksum: 0xD9BCDEF9
	Offset: 0x4B8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_firefly_swarm_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.firefly_swarm))
	{
		self [[level.cybercom.firefly_swarm._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_firefly_swarm_on_connect
	Namespace: _gadget_firefly_swarm
	Checksum: 0xE438E0C7
	Offset: 0x520
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_firefly_swarm_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.firefly_swarm))
	{
		self [[level.cybercom.firefly_swarm._on_connect]]();
	}
}

/*
	Name: gadget_firefly_swarm_on
	Namespace: _gadget_firefly_swarm
	Checksum: 0xEB4FD8E
	Offset: 0x570
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_firefly_swarm_on(slot, weapon)
{
	self flagsys::set("gadget_firefly_swarm_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.firefly_swarm))
	{
		self [[level.cybercom.firefly_swarm._on]](slot, weapon);
	}
}

/*
	Name: gadget_firefly_swarm_off
	Namespace: _gadget_firefly_swarm
	Checksum: 0x4FC65ED3
	Offset: 0x5F8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_firefly_swarm_off(slot, weapon)
{
	self flagsys::clear("gadget_firefly_swarm_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.firefly_swarm))
	{
		self [[level.cybercom.firefly_swarm._off]](slot, weapon);
	}
}

/*
	Name: gadget_firefly_is_primed
	Namespace: _gadget_firefly_swarm
	Checksum: 0xE7BEE8A2
	Offset: 0x680
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_firefly_is_primed(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.firefly_swarm))
	{
		self [[level.cybercom.firefly_swarm._is_primed]](slot, weapon);
	}
}

