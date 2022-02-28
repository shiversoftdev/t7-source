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

#namespace _gadget_unstoppable_force;

/*
	Name: __init__sytem__
	Namespace: _gadget_unstoppable_force
	Checksum: 0x67136C8F
	Offset: 0x230
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_unstoppable_force", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_unstoppable_force
	Checksum: 0x1FE5976A
	Offset: 0x270
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(29, &gadget_unstoppable_force_on, &gadget_unstoppable_force_off);
	ability_player::register_gadget_possession_callbacks(29, &gadget_unstoppable_force_on_give, &gadget_unstoppable_force_on_take);
	ability_player::register_gadget_flicker_callbacks(29, &gadget_unstoppable_force_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(29, &gadget_unstoppable_force_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(29, &gadget_unstoppable_force_is_flickering);
	callback::on_connect(&gadget_unstoppable_force_on_connect);
	clientfield::register("toplayer", "unstoppableforce_state", 1, 1, "int");
}

/*
	Name: gadget_unstoppable_force_is_inuse
	Namespace: _gadget_unstoppable_force
	Checksum: 0x8B370A0D
	Offset: 0x390
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_unstoppable_force_is_inuse(slot)
{
	return self flagsys::get("gadget_unstoppable_force_on");
}

/*
	Name: gadget_unstoppable_force_is_flickering
	Namespace: _gadget_unstoppable_force
	Checksum: 0x5269CB30
	Offset: 0x3C8
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function gadget_unstoppable_force_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.unstoppable_force))
	{
		return self [[level.cybercom.unstoppable_force._is_flickering]](slot);
	}
	return 0;
}

/*
	Name: gadget_unstoppable_force_on_flicker
	Namespace: _gadget_unstoppable_force
	Checksum: 0xED6D25CC
	Offset: 0x428
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_unstoppable_force_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.unstoppable_force))
	{
		self [[level.cybercom.unstoppable_force._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_unstoppable_force_on_give
	Namespace: _gadget_unstoppable_force
	Checksum: 0x8BE54724
	Offset: 0x490
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_unstoppable_force_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.unstoppable_force))
	{
		self [[level.cybercom.unstoppable_force._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_unstoppable_force_on_take
	Namespace: _gadget_unstoppable_force
	Checksum: 0x8F8ED0DF
	Offset: 0x4F8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_unstoppable_force_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.unstoppable_force))
	{
		self [[level.cybercom.unstoppable_force._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_unstoppable_force_on_connect
	Namespace: _gadget_unstoppable_force
	Checksum: 0x9033941A
	Offset: 0x560
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_unstoppable_force_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.unstoppable_force))
	{
		self [[level.cybercom.unstoppable_force._on_connect]]();
	}
}

/*
	Name: gadget_unstoppable_force_on
	Namespace: _gadget_unstoppable_force
	Checksum: 0xEAC59ACB
	Offset: 0x5B0
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_unstoppable_force_on(slot, weapon)
{
	self flagsys::set("gadget_unstoppable_force_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.unstoppable_force))
	{
		self [[level.cybercom.unstoppable_force._on]](slot, weapon);
	}
}

/*
	Name: gadget_unstoppable_force_off
	Namespace: _gadget_unstoppable_force
	Checksum: 0x2BE1B544
	Offset: 0x638
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_unstoppable_force_off(slot, weapon)
{
	self flagsys::clear("gadget_unstoppable_force_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.unstoppable_force))
	{
		self [[level.cybercom.unstoppable_force._off]](slot, weapon);
	}
}

/*
	Name: gadget_firefly_is_primed
	Namespace: _gadget_unstoppable_force
	Checksum: 0xAE7FC097
	Offset: 0x6C0
	Size: 0x5C
	Parameters: 2
	Flags: None
*/
function gadget_firefly_is_primed(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.unstoppable_force))
	{
		self [[level.cybercom.unstoppable_force._is_primed]](slot, weapon);
	}
}

