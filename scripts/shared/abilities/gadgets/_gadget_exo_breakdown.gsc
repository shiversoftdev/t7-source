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

#namespace _gadget_exo_breakdown;

/*
	Name: __init__sytem__
	Namespace: _gadget_exo_breakdown
	Checksum: 0x9C7487B6
	Offset: 0x200
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_exo_breakdown", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_exo_breakdown
	Checksum: 0xA95C1BC1
	Offset: 0x240
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(20, &gadget_exo_breakdown_on, &gadget_exo_breakdown_off);
	ability_player::register_gadget_possession_callbacks(20, &gadget_exo_breakdown_on_give, &gadget_exo_breakdown_on_take);
	ability_player::register_gadget_flicker_callbacks(20, &gadget_exo_breakdown_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(20, &gadget_exo_breakdown_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(20, &gadget_exo_breakdown_is_flickering);
	ability_player::register_gadget_primed_callbacks(20, &gadget_exo_breakdown_is_primed);
	callback::on_connect(&gadget_exo_breakdown_on_connect);
}

/*
	Name: gadget_exo_breakdown_is_inuse
	Namespace: _gadget_exo_breakdown
	Checksum: 0x5CE3502E
	Offset: 0x350
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_exo_breakdown_is_inuse(slot)
{
	return self flagsys::get("gadget_exo_breakdown_on");
}

/*
	Name: gadget_exo_breakdown_is_flickering
	Namespace: _gadget_exo_breakdown
	Checksum: 0xF27C9B01
	Offset: 0x388
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function gadget_exo_breakdown_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.exo_breakdown))
	{
		return self [[level.cybercom.exo_breakdown._is_flickering]](slot);
	}
	return 0;
}

/*
	Name: gadget_exo_breakdown_on_flicker
	Namespace: _gadget_exo_breakdown
	Checksum: 0x8A842248
	Offset: 0x3E8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_exo_breakdown_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.exo_breakdown))
	{
		self [[level.cybercom.exo_breakdown._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_exo_breakdown_on_give
	Namespace: _gadget_exo_breakdown
	Checksum: 0x560D446C
	Offset: 0x450
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_exo_breakdown_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.exo_breakdown))
	{
		self [[level.cybercom.exo_breakdown._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_exo_breakdown_on_take
	Namespace: _gadget_exo_breakdown
	Checksum: 0xCC9DFA1F
	Offset: 0x4B8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_exo_breakdown_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.exo_breakdown))
	{
		self [[level.cybercom.exo_breakdown._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_exo_breakdown_on_connect
	Namespace: _gadget_exo_breakdown
	Checksum: 0x1DB99D0E
	Offset: 0x520
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_exo_breakdown_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.exo_breakdown))
	{
		self [[level.cybercom.exo_breakdown._on_connect]]();
	}
}

/*
	Name: gadget_exo_breakdown_on
	Namespace: _gadget_exo_breakdown
	Checksum: 0x54AC308B
	Offset: 0x570
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_exo_breakdown_on(slot, weapon)
{
	self flagsys::set("gadget_exo_breakdown_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.exo_breakdown))
	{
		self [[level.cybercom.exo_breakdown._on]](slot, weapon);
	}
}

/*
	Name: gadget_exo_breakdown_off
	Namespace: _gadget_exo_breakdown
	Checksum: 0x1456BB05
	Offset: 0x5F8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_exo_breakdown_off(slot, weapon)
{
	self flagsys::clear("gadget_exo_breakdown_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.exo_breakdown))
	{
		self [[level.cybercom.exo_breakdown._off]](slot, weapon);
	}
}

/*
	Name: gadget_exo_breakdown_is_primed
	Namespace: _gadget_exo_breakdown
	Checksum: 0x5D2E5CAE
	Offset: 0x680
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_exo_breakdown_is_primed(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.exo_breakdown))
	{
		self [[level.cybercom.exo_breakdown._is_primed]](slot, weapon);
	}
}

