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

#namespace _gadget_rapid_strike;

/*
	Name: __init__sytem__
	Namespace: _gadget_rapid_strike
	Checksum: 0xE6B83DE2
	Offset: 0x200
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_rapid_strike", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_rapid_strike
	Checksum: 0x7985C51E
	Offset: 0x240
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(30, &gadget_rapid_strike_on, &gadget_rapid_strike_off);
	ability_player::register_gadget_possession_callbacks(30, &gadget_rapid_strike_on_give, &gadget_rapid_strike_on_take);
	ability_player::register_gadget_flicker_callbacks(30, &gadget_rapid_strike_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(30, &gadget_rapid_strike_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(30, &gadget_rapid_strike_is_flickering);
	callback::on_connect(&gadget_rapid_strike_on_connect);
}

/*
	Name: gadget_rapid_strike_is_inuse
	Namespace: _gadget_rapid_strike
	Checksum: 0xF7353BF6
	Offset: 0x330
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_rapid_strike_is_inuse(slot)
{
	return self flagsys::get("gadget_rapid_strike_on");
}

/*
	Name: gadget_rapid_strike_is_flickering
	Namespace: _gadget_rapid_strike
	Checksum: 0xDE7AB590
	Offset: 0x368
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function gadget_rapid_strike_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.rapid_strike))
	{
		return self [[level.cybercom.rapid_strike._is_flickering]](slot);
	}
}

/*
	Name: gadget_rapid_strike_on_flicker
	Namespace: _gadget_rapid_strike
	Checksum: 0x646AADFD
	Offset: 0x3C0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_rapid_strike_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.rapid_strike))
	{
		self [[level.cybercom.rapid_strike._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_rapid_strike_on_give
	Namespace: _gadget_rapid_strike
	Checksum: 0x432496C4
	Offset: 0x428
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_rapid_strike_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.rapid_strike))
	{
		self [[level.cybercom.rapid_strike._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_rapid_strike_on_take
	Namespace: _gadget_rapid_strike
	Checksum: 0x14BDAE33
	Offset: 0x490
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_rapid_strike_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.rapid_strike))
	{
		self [[level.cybercom.rapid_strike._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_rapid_strike_on_connect
	Namespace: _gadget_rapid_strike
	Checksum: 0xCB5C1245
	Offset: 0x4F8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_rapid_strike_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.rapid_strike))
	{
		self [[level.cybercom.rapid_strike._on_connect]]();
	}
}

/*
	Name: gadget_rapid_strike_on
	Namespace: _gadget_rapid_strike
	Checksum: 0xBBADD973
	Offset: 0x548
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_rapid_strike_on(slot, weapon)
{
	self flagsys::set("gadget_rapid_strike_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.rapid_strike))
	{
		self [[level.cybercom.rapid_strike._on]](slot, weapon);
	}
}

/*
	Name: gadget_rapid_strike_off
	Namespace: _gadget_rapid_strike
	Checksum: 0xF8DDFB82
	Offset: 0x5D0
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_rapid_strike_off(slot, weapon)
{
	self flagsys::clear("gadget_rapid_strike_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.rapid_strike))
	{
		self [[level.cybercom.rapid_strike._off]](slot, weapon);
	}
}

