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

#namespace _gadget_sensory_overload;

/*
	Name: __init__sytem__
	Namespace: _gadget_sensory_overload
	Checksum: 0xF277F895
	Offset: 0x208
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_sensory_overload", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_sensory_overload
	Checksum: 0x43AEF0C1
	Offset: 0x248
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(32, &gadget_sensory_overload_on, &gadget_sensory_overload_off);
	ability_player::register_gadget_possession_callbacks(32, &gadget_sensory_overload_on_give, &gadget_sensory_overload_on_take);
	ability_player::register_gadget_flicker_callbacks(32, &gadget_sensory_overload_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(32, &gadget_sensory_overload_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(32, &gadget_sensory_overload_is_flickering);
	ability_player::register_gadget_primed_callbacks(32, &gadget_sensory_overload_is_primed);
	callback::on_connect(&gadget_sensory_overload_on_connect);
}

/*
	Name: gadget_sensory_overload_is_inuse
	Namespace: _gadget_sensory_overload
	Checksum: 0x7E9DCDFA
	Offset: 0x358
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_sensory_overload_is_inuse(slot)
{
	return self flagsys::get("gadget_sensory_overload_on");
}

/*
	Name: gadget_sensory_overload_is_flickering
	Namespace: _gadget_sensory_overload
	Checksum: 0x439F93ED
	Offset: 0x390
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function gadget_sensory_overload_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.sensory_overload))
	{
		return self [[level.cybercom.sensory_overload._is_flickering]](slot);
	}
}

/*
	Name: gadget_sensory_overload_on_flicker
	Namespace: _gadget_sensory_overload
	Checksum: 0x703C057D
	Offset: 0x3E8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_sensory_overload_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.sensory_overload))
	{
		self [[level.cybercom.sensory_overload._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_sensory_overload_on_give
	Namespace: _gadget_sensory_overload
	Checksum: 0x52CB46D2
	Offset: 0x450
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_sensory_overload_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.sensory_overload))
	{
		self [[level.cybercom.sensory_overload._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_sensory_overload_on_take
	Namespace: _gadget_sensory_overload
	Checksum: 0xD0450BBE
	Offset: 0x4B8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_sensory_overload_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.sensory_overload))
	{
		self [[level.cybercom.sensory_overload._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_sensory_overload_on_connect
	Namespace: _gadget_sensory_overload
	Checksum: 0xA60E45DD
	Offset: 0x520
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_sensory_overload_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.sensory_overload))
	{
		self [[level.cybercom.sensory_overload._on_connect]]();
	}
}

/*
	Name: gadget_sensory_overload_on
	Namespace: _gadget_sensory_overload
	Checksum: 0xAC573097
	Offset: 0x570
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_sensory_overload_on(slot, weapon)
{
	self flagsys::set("gadget_sensory_overload_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.sensory_overload))
	{
		self [[level.cybercom.sensory_overload._on]](slot, weapon);
	}
}

/*
	Name: gadget_sensory_overload_off
	Namespace: _gadget_sensory_overload
	Checksum: 0xFBC541F9
	Offset: 0x5F8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_sensory_overload_off(slot, weapon)
{
	self flagsys::clear("gadget_sensory_overload_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.sensory_overload))
	{
		self [[level.cybercom.sensory_overload._off]](slot, weapon);
	}
}

/*
	Name: gadget_sensory_overload_is_primed
	Namespace: _gadget_sensory_overload
	Checksum: 0xFD203C50
	Offset: 0x680
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_sensory_overload_is_primed(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.sensory_overload))
	{
		self [[level.cybercom.sensory_overload._is_primed]](slot, weapon);
	}
}

