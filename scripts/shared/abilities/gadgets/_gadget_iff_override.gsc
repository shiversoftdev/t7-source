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

#namespace _gadget_iff_override;

/*
	Name: __init__sytem__
	Namespace: _gadget_iff_override
	Checksum: 0xAA3EBFBF
	Offset: 0x200
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_iff_override", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_iff_override
	Checksum: 0x8E026F0F
	Offset: 0x240
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(24, &gadget_iff_override_on, &gadget_iff_override_off);
	ability_player::register_gadget_possession_callbacks(24, &gadget_iff_override_on_give, &gadget_iff_override_on_take);
	ability_player::register_gadget_flicker_callbacks(24, &gadget_iff_override_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(24, &gadget_iff_override_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(24, &gadget_iff_override_is_flickering);
	ability_player::register_gadget_primed_callbacks(24, &gadget_iff_override_is_primed);
	callback::on_connect(&gadget_iff_override_on_connect);
}

/*
	Name: gadget_iff_override_is_inuse
	Namespace: _gadget_iff_override
	Checksum: 0xC7E626E1
	Offset: 0x350
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_iff_override_is_inuse(slot)
{
	return self flagsys::get("gadget_iff_override_on");
}

/*
	Name: gadget_iff_override_is_flickering
	Namespace: _gadget_iff_override
	Checksum: 0xA0C72C4
	Offset: 0x388
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function gadget_iff_override_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.iff_override))
	{
		return self [[level.cybercom.iff_override._is_flickering]](slot);
	}
	return 0;
}

/*
	Name: gadget_iff_override_on_flicker
	Namespace: _gadget_iff_override
	Checksum: 0xC8B79216
	Offset: 0x3E8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_iff_override_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.iff_override))
	{
		self [[level.cybercom.iff_override._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_iff_override_on_give
	Namespace: _gadget_iff_override
	Checksum: 0x3C891C08
	Offset: 0x450
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_iff_override_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.iff_override))
	{
		self [[level.cybercom.iff_override._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_iff_override_on_take
	Namespace: _gadget_iff_override
	Checksum: 0x851AADBB
	Offset: 0x4B8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_iff_override_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.iff_override))
	{
		self [[level.cybercom.iff_override._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_iff_override_on_connect
	Namespace: _gadget_iff_override
	Checksum: 0x4C291B07
	Offset: 0x520
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_iff_override_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.iff_override))
	{
		self [[level.cybercom.iff_override._on_connect]]();
	}
}

/*
	Name: gadget_iff_override_on
	Namespace: _gadget_iff_override
	Checksum: 0xEBD41DF2
	Offset: 0x570
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_iff_override_on(slot, weapon)
{
	self flagsys::set("gadget_iff_override_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.iff_override))
	{
		self [[level.cybercom.iff_override._on]](slot, weapon);
	}
}

/*
	Name: gadget_iff_override_off
	Namespace: _gadget_iff_override
	Checksum: 0x91EB604
	Offset: 0x5F8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_iff_override_off(slot, weapon)
{
	self flagsys::clear("gadget_iff_override_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.iff_override))
	{
		self [[level.cybercom.iff_override._off]](slot, weapon);
	}
}

/*
	Name: gadget_iff_override_is_primed
	Namespace: _gadget_iff_override
	Checksum: 0xF8CAD14C
	Offset: 0x680
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_iff_override_is_primed(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.iff_override))
	{
		self [[level.cybercom.iff_override._is_primed]](slot, weapon);
	}
}

