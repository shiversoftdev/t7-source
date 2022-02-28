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

#namespace _gadget_immolation;

/*
	Name: __init__sytem__
	Namespace: _gadget_immolation
	Checksum: 0x7386A8E4
	Offset: 0x1F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_immolation", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_immolation
	Checksum: 0x59833E95
	Offset: 0x238
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(34, &gadget_immolation_on, &gadget_immolation_off);
	ability_player::register_gadget_possession_callbacks(34, &gadget_immolation_on_give, &gadget_immolation_on_take);
	ability_player::register_gadget_flicker_callbacks(34, &gadget_immolation_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(34, &gadget_immolation_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(34, &gadget_immolation_is_flickering);
	ability_player::register_gadget_primed_callbacks(34, &gadget_immolation_is_primed);
	callback::on_connect(&gadget_immolation_on_connect);
}

/*
	Name: gadget_immolation_is_inuse
	Namespace: _gadget_immolation
	Checksum: 0x1E575EA3
	Offset: 0x348
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_immolation_is_inuse(slot)
{
	return self flagsys::get("gadget_immolation_on");
}

/*
	Name: gadget_immolation_is_flickering
	Namespace: _gadget_immolation
	Checksum: 0x820D46FB
	Offset: 0x380
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function gadget_immolation_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.immolation))
	{
		return self [[level.cybercom.immolation._is_flickering]](slot);
	}
	return 0;
}

/*
	Name: gadget_immolation_on_flicker
	Namespace: _gadget_immolation
	Checksum: 0x531734BA
	Offset: 0x3E0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_immolation_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.immolation))
	{
		self [[level.cybercom.immolation._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_immolation_on_give
	Namespace: _gadget_immolation
	Checksum: 0xA6F7DE5C
	Offset: 0x448
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_immolation_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.immolation))
	{
		self [[level.cybercom.immolation._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_immolation_on_take
	Namespace: _gadget_immolation
	Checksum: 0xB09F633C
	Offset: 0x4B0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_immolation_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.immolation))
	{
		self [[level.cybercom.immolation._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_immolation_on_connect
	Namespace: _gadget_immolation
	Checksum: 0x628157DD
	Offset: 0x518
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_immolation_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.immolation))
	{
		self [[level.cybercom.immolation._on_connect]]();
	}
}

/*
	Name: gadget_immolation_on
	Namespace: _gadget_immolation
	Checksum: 0x42C86D5E
	Offset: 0x568
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_immolation_on(slot, weapon)
{
	self flagsys::set("gadget_immolation_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.immolation))
	{
		self [[level.cybercom.immolation._on]](slot, weapon);
	}
}

/*
	Name: gadget_immolation_off
	Namespace: _gadget_immolation
	Checksum: 0xD44C22CD
	Offset: 0x5F0
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_immolation_off(slot, weapon)
{
	self flagsys::clear("gadget_immolation_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.immolation))
	{
		self [[level.cybercom.immolation._off]](slot, weapon);
	}
}

/*
	Name: gadget_immolation_is_primed
	Namespace: _gadget_immolation
	Checksum: 0x77610FCB
	Offset: 0x678
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_immolation_is_primed(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.immolation))
	{
		self [[level.cybercom.immolation._is_primed]](slot, weapon);
	}
}

