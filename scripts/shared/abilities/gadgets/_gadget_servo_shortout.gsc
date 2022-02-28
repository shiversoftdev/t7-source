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

#namespace _gadget_servo_shortout;

/*
	Name: __init__sytem__
	Namespace: _gadget_servo_shortout
	Checksum: 0xFC351738
	Offset: 0x200
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_servo_shortout", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_servo_shortout
	Checksum: 0xF5AC2B60
	Offset: 0x240
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(19, &gadget_servo_shortout_on, &gadget_servo_shortout_off);
	ability_player::register_gadget_possession_callbacks(19, &gadget_servo_shortout_on_give, &gadget_servo_shortout_on_take);
	ability_player::register_gadget_flicker_callbacks(19, &gadget_servo_shortout_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(19, &gadget_servo_shortout_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(19, &gadget_servo_shortout_is_flickering);
	ability_player::register_gadget_primed_callbacks(19, &gadget_servo_shortout_is_primed);
	callback::on_connect(&gadget_servo_shortout_on_connect);
}

/*
	Name: gadget_servo_shortout_is_inuse
	Namespace: _gadget_servo_shortout
	Checksum: 0xA1947CE
	Offset: 0x350
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_servo_shortout_is_inuse(slot)
{
	return self flagsys::get("gadget_servo_shortout_on");
}

/*
	Name: gadget_servo_shortout_is_flickering
	Namespace: _gadget_servo_shortout
	Checksum: 0x7CE502BD
	Offset: 0x388
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function gadget_servo_shortout_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.servo_shortout))
	{
		return self [[level.cybercom.servo_shortout._is_flickering]](slot);
	}
	return 0;
}

/*
	Name: gadget_servo_shortout_on_flicker
	Namespace: _gadget_servo_shortout
	Checksum: 0x3ECD3087
	Offset: 0x3E8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_servo_shortout_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.servo_shortout))
	{
		self [[level.cybercom.servo_shortout._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_servo_shortout_on_give
	Namespace: _gadget_servo_shortout
	Checksum: 0x8F975B93
	Offset: 0x450
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_servo_shortout_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.servo_shortout))
	{
		self [[level.cybercom.servo_shortout._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_servo_shortout_on_take
	Namespace: _gadget_servo_shortout
	Checksum: 0xA7719E19
	Offset: 0x4B8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_servo_shortout_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.servo_shortout))
	{
		self [[level.cybercom.servo_shortout._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_servo_shortout_on_connect
	Namespace: _gadget_servo_shortout
	Checksum: 0x1AB08158
	Offset: 0x520
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_servo_shortout_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.servo_shortout))
	{
		self [[level.cybercom.servo_shortout._on_connect]]();
	}
}

/*
	Name: gadget_servo_shortout_on
	Namespace: _gadget_servo_shortout
	Checksum: 0xFE610AB3
	Offset: 0x570
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_servo_shortout_on(slot, weapon)
{
	self flagsys::set("gadget_servo_shortout_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.servo_shortout))
	{
		self [[level.cybercom.servo_shortout._on]](slot, weapon);
	}
}

/*
	Name: gadget_servo_shortout_off
	Namespace: _gadget_servo_shortout
	Checksum: 0x8E79DD3C
	Offset: 0x5F8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_servo_shortout_off(slot, weapon)
{
	self flagsys::clear("gadget_servo_shortout_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.servo_shortout))
	{
		self [[level.cybercom.servo_shortout._off]](slot, weapon);
	}
}

/*
	Name: gadget_servo_shortout_is_primed
	Namespace: _gadget_servo_shortout
	Checksum: 0x634BF8A0
	Offset: 0x680
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_servo_shortout_is_primed(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.servo_shortout))
	{
		self [[level.cybercom.servo_shortout._is_primed]](slot, weapon);
	}
}

