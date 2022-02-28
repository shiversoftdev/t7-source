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

#namespace _gadget_misdirection;

/*
	Name: __init__sytem__
	Namespace: _gadget_misdirection
	Checksum: 0x366F72B5
	Offset: 0x200
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_misdirection", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_misdirection
	Checksum: 0xBA529D87
	Offset: 0x240
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(37, &gadget_misdirection_on, &gadget_misdirection_off);
	ability_player::register_gadget_possession_callbacks(37, &gadget_misdirection_on_give, &gadget_misdirection_on_take);
	ability_player::register_gadget_flicker_callbacks(37, &gadget_misdirection_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(37, &gadget_misdirection_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(37, &gadget_misdirection_is_flickering);
	ability_player::register_gadget_primed_callbacks(37, &gadget_misdirection_is_primed);
	callback::on_connect(&gadget_misdirection_on_connect);
}

/*
	Name: gadget_misdirection_is_inuse
	Namespace: _gadget_misdirection
	Checksum: 0x810594CA
	Offset: 0x350
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_misdirection_is_inuse(slot)
{
	return self flagsys::get("gadget_misdirection_on");
}

/*
	Name: gadget_misdirection_is_flickering
	Namespace: _gadget_misdirection
	Checksum: 0xB6BA7D7E
	Offset: 0x388
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function gadget_misdirection_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.misdirection))
	{
		return self [[level.cybercom.misdirection._is_flickering]](slot);
	}
	return 0;
}

/*
	Name: gadget_misdirection_on_flicker
	Namespace: _gadget_misdirection
	Checksum: 0xD2B46ED1
	Offset: 0x3E8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_misdirection_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.misdirection))
	{
		self [[level.cybercom.misdirection._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_misdirection_on_give
	Namespace: _gadget_misdirection
	Checksum: 0xCD4741D1
	Offset: 0x450
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_misdirection_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.misdirection))
	{
		self [[level.cybercom.misdirection._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_misdirection_on_take
	Namespace: _gadget_misdirection
	Checksum: 0x77169789
	Offset: 0x4B8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_misdirection_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.misdirection))
	{
		self [[level.cybercom.misdirection._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_misdirection_on_connect
	Namespace: _gadget_misdirection
	Checksum: 0xA5F3AE98
	Offset: 0x520
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_misdirection_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.misdirection))
	{
		self [[level.cybercom.misdirection._on_connect]]();
	}
}

/*
	Name: gadget_misdirection_on
	Namespace: _gadget_misdirection
	Checksum: 0xC4A7CA46
	Offset: 0x570
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_misdirection_on(slot, weapon)
{
	self flagsys::set("gadget_misdirection_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.misdirection))
	{
		self [[level.cybercom.misdirection._on]](slot, weapon);
	}
}

/*
	Name: gadget_misdirection_off
	Namespace: _gadget_misdirection
	Checksum: 0xDBBA940
	Offset: 0x5F8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_misdirection_off(slot, weapon)
{
	self flagsys::clear("gadget_misdirection_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.misdirection))
	{
		self [[level.cybercom.misdirection._off]](slot, weapon);
	}
}

/*
	Name: gadget_misdirection_is_primed
	Namespace: _gadget_misdirection
	Checksum: 0x852BE4F8
	Offset: 0x680
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_misdirection_is_primed(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.misdirection))
	{
		self [[level.cybercom.misdirection._is_primed]](slot, weapon);
	}
}

