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

#namespace _gadget_ravage_core;

/*
	Name: __init__sytem__
	Namespace: _gadget_ravage_core
	Checksum: 0x8F62AF98
	Offset: 0x1F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_ravage_core", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_ravage_core
	Checksum: 0xEFC8145A
	Offset: 0x238
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(22, &gadget_ravage_core_on, &gadget_ravage_core_off);
	ability_player::register_gadget_possession_callbacks(22, &gadget_ravage_core_on_give, &gadget_ravage_core_on_take);
	ability_player::register_gadget_flicker_callbacks(22, &gadget_ravage_core_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(22, &gadget_ravage_core_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(22, &gadget_ravage_core_is_flickering);
	callback::on_connect(&gadget_ravage_core_on_connect);
}

/*
	Name: gadget_ravage_core_is_inuse
	Namespace: _gadget_ravage_core
	Checksum: 0x8E262B77
	Offset: 0x328
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_ravage_core_is_inuse(slot)
{
	return self flagsys::get("gadget_ravage_core_on");
}

/*
	Name: gadget_ravage_core_is_flickering
	Namespace: _gadget_ravage_core
	Checksum: 0x7C3B204D
	Offset: 0x360
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function gadget_ravage_core_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.ravage_core))
	{
		return self [[level.cybercom.ravage_core._is_flickering]](slot);
	}
}

/*
	Name: gadget_ravage_core_on_flicker
	Namespace: _gadget_ravage_core
	Checksum: 0x4C97342E
	Offset: 0x3B8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_ravage_core_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.ravage_core))
	{
		self [[level.cybercom.ravage_core._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_ravage_core_on_give
	Namespace: _gadget_ravage_core
	Checksum: 0xC79CA8CE
	Offset: 0x420
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_ravage_core_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.ravage_core))
	{
		self [[level.cybercom.ravage_core._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_ravage_core_on_take
	Namespace: _gadget_ravage_core
	Checksum: 0x1BD19AF8
	Offset: 0x488
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_ravage_core_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.ravage_core))
	{
		self [[level.cybercom.ravage_core._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_ravage_core_on_connect
	Namespace: _gadget_ravage_core
	Checksum: 0x8C1CB25A
	Offset: 0x4F0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_ravage_core_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.ravage_core))
	{
		self [[level.cybercom.ravage_core._on_connect]]();
	}
}

/*
	Name: gadget_ravage_core_on
	Namespace: _gadget_ravage_core
	Checksum: 0x28F4C4A5
	Offset: 0x540
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_ravage_core_on(slot, weapon)
{
	self flagsys::set("gadget_ravage_core_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.ravage_core))
	{
		self [[level.cybercom.ravage_core._on]](slot, weapon);
	}
}

/*
	Name: gadget_ravage_core_off
	Namespace: _gadget_ravage_core
	Checksum: 0x8121CBD1
	Offset: 0x5C8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_ravage_core_off(slot, weapon)
{
	self flagsys::clear("gadget_ravage_core_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.ravage_core))
	{
		self [[level.cybercom.ravage_core._off]](slot, weapon);
	}
}

