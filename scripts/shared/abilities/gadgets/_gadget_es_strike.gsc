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

#namespace _gadget_es_strike;

/*
	Name: __init__sytem__
	Namespace: _gadget_es_strike
	Checksum: 0xD576F1C2
	Offset: 0x1F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_es_strike", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_es_strike
	Checksum: 0xC609E697
	Offset: 0x238
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(33, &gadget_es_strike_on, &gadget_es_strike_off);
	ability_player::register_gadget_possession_callbacks(33, &gadget_es_strike_on_give, &gadget_es_strike_on_take);
	ability_player::register_gadget_flicker_callbacks(33, &gadget_es_strike_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(33, &gadget_es_strike_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(33, &gadget_es_strike_is_flickering);
	callback::on_connect(&gadget_es_strike_on_connect);
}

/*
	Name: gadget_es_strike_is_inuse
	Namespace: _gadget_es_strike
	Checksum: 0xFE413EA2
	Offset: 0x328
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_es_strike_is_inuse(slot)
{
	return self flagsys::get("gadget_es_strike_on");
}

/*
	Name: gadget_es_strike_is_flickering
	Namespace: _gadget_es_strike
	Checksum: 0x4870A517
	Offset: 0x360
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function gadget_es_strike_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.electro_strike))
	{
		return self [[level.cybercom.electro_strike._is_flickering]](slot);
	}
}

/*
	Name: gadget_es_strike_on_flicker
	Namespace: _gadget_es_strike
	Checksum: 0x47145958
	Offset: 0x3B8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_es_strike_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.electro_strike))
	{
		self [[level.cybercom.electro_strike._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_es_strike_on_give
	Namespace: _gadget_es_strike
	Checksum: 0x1102E94
	Offset: 0x420
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_es_strike_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.electro_strike))
	{
		self [[level.cybercom.electro_strike._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_es_strike_on_take
	Namespace: _gadget_es_strike
	Checksum: 0x2E144ACD
	Offset: 0x488
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_es_strike_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.electro_strike))
	{
		self [[level.cybercom.electro_strike._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_es_strike_on_connect
	Namespace: _gadget_es_strike
	Checksum: 0xE898DD73
	Offset: 0x4F0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_es_strike_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.electro_strike))
	{
		self [[level.cybercom.electro_strike._on_connect]]();
	}
}

/*
	Name: gadget_es_strike_on
	Namespace: _gadget_es_strike
	Checksum: 0x5932273A
	Offset: 0x540
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_es_strike_on(slot, weapon)
{
	self flagsys::set("gadget_es_strike_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.electro_strike))
	{
		self [[level.cybercom.electro_strike._on]](slot, weapon);
	}
}

/*
	Name: gadget_es_strike_off
	Namespace: _gadget_es_strike
	Checksum: 0xFA3D8DB
	Offset: 0x5C8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_es_strike_off(slot, weapon)
{
	self flagsys::clear("gadget_es_strike_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.electro_strike))
	{
		self [[level.cybercom.electro_strike._off]](slot, weapon);
	}
}

