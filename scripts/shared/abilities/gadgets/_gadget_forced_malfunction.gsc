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

#namespace _gadget_forced_malfunction;

/*
	Name: __init__sytem__
	Namespace: _gadget_forced_malfunction
	Checksum: 0xE82CB185
	Offset: 0x210
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_forced_malfunction", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_forced_malfunction
	Checksum: 0x6C35A947
	Offset: 0x250
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(26, &gadget_forced_malfunction_on, &gadget_forced_malfunction_off);
	ability_player::register_gadget_possession_callbacks(26, &gadget_forced_malfunction_on_give, &gadget_forced_malfunction_on_take);
	ability_player::register_gadget_flicker_callbacks(26, &gadget_forced_malfunction_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(26, &gadget_forced_malfunction_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(26, &gadget_forced_malfunction_is_flickering);
	ability_player::register_gadget_primed_callbacks(26, &gadget_forced_malfunction_is_primed);
	callback::on_connect(&gadget_forced_malfunction_on_connect);
}

/*
	Name: gadget_forced_malfunction_is_inuse
	Namespace: _gadget_forced_malfunction
	Checksum: 0x16E431EB
	Offset: 0x360
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_forced_malfunction_is_inuse(slot)
{
	return self flagsys::get("gadget_forced_malfunction_on");
}

/*
	Name: gadget_forced_malfunction_is_flickering
	Namespace: _gadget_forced_malfunction
	Checksum: 0xDE2D8B7B
	Offset: 0x398
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function gadget_forced_malfunction_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.forced_malfunction))
	{
		return self [[level.cybercom.forced_malfunction._is_flickering]](slot);
	}
	return 0;
}

/*
	Name: gadget_forced_malfunction_on_flicker
	Namespace: _gadget_forced_malfunction
	Checksum: 0xF1A12940
	Offset: 0x3F8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_forced_malfunction_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.forced_malfunction))
	{
		self [[level.cybercom.forced_malfunction._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_forced_malfunction_on_give
	Namespace: _gadget_forced_malfunction
	Checksum: 0x2C427BF9
	Offset: 0x460
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_forced_malfunction_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.forced_malfunction))
	{
		self [[level.cybercom.forced_malfunction._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_forced_malfunction_on_take
	Namespace: _gadget_forced_malfunction
	Checksum: 0x919A5368
	Offset: 0x4C8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_forced_malfunction_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.forced_malfunction))
	{
		self [[level.cybercom.forced_malfunction._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_forced_malfunction_on_connect
	Namespace: _gadget_forced_malfunction
	Checksum: 0x3F4A58B0
	Offset: 0x530
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_forced_malfunction_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.forced_malfunction))
	{
		self [[level.cybercom.forced_malfunction._on_connect]]();
	}
}

/*
	Name: gadget_forced_malfunction_on
	Namespace: _gadget_forced_malfunction
	Checksum: 0x538E7C3F
	Offset: 0x580
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_forced_malfunction_on(slot, weapon)
{
	self flagsys::set("gadget_forced_malfunction_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.forced_malfunction))
	{
		self [[level.cybercom.forced_malfunction._on]](slot, weapon);
	}
}

/*
	Name: gadget_forced_malfunction_off
	Namespace: _gadget_forced_malfunction
	Checksum: 0x568BC55
	Offset: 0x608
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_forced_malfunction_off(slot, weapon)
{
	self flagsys::clear("gadget_forced_malfunction_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.forced_malfunction))
	{
		self [[level.cybercom.forced_malfunction._off]](slot, weapon);
	}
}

/*
	Name: gadget_forced_malfunction_is_primed
	Namespace: _gadget_forced_malfunction
	Checksum: 0x72655020
	Offset: 0x690
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_forced_malfunction_is_primed(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.forced_malfunction))
	{
		self [[level.cybercom.forced_malfunction._is_primed]](slot, weapon);
	}
}

