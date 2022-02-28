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

#namespace _gadget_security_breach;

/*
	Name: __init__sytem__
	Namespace: _gadget_security_breach
	Checksum: 0x325425CD
	Offset: 0x208
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_security_breach", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_security_breach
	Checksum: 0x261418FB
	Offset: 0x248
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(23, &gadget_security_breach_on, &gadget_security_breach_off);
	ability_player::register_gadget_possession_callbacks(23, &gadget_security_breach_on_give, &gadget_security_breach_on_take);
	ability_player::register_gadget_flicker_callbacks(23, &gadget_security_breach_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(23, &gadget_security_breach_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(23, &gadget_security_breach_is_flickering);
	ability_player::register_gadget_primed_callbacks(23, &gadget_security_breach_is_primed);
	callback::on_connect(&gadget_security_breach_on_connect);
}

/*
	Name: gadget_security_breach_is_inuse
	Namespace: _gadget_security_breach
	Checksum: 0x59B207FF
	Offset: 0x358
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_security_breach_is_inuse(slot)
{
	return self flagsys::get("gadget_security_breach_on");
}

/*
	Name: gadget_security_breach_is_flickering
	Namespace: _gadget_security_breach
	Checksum: 0xE942B942
	Offset: 0x390
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function gadget_security_breach_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.security_breach))
	{
		return self [[level.cybercom.security_breach._is_flickering]](slot);
	}
}

/*
	Name: gadget_security_breach_on_flicker
	Namespace: _gadget_security_breach
	Checksum: 0xB4356E45
	Offset: 0x3E8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_security_breach_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.security_breach))
	{
		self [[level.cybercom.security_breach._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_security_breach_on_give
	Namespace: _gadget_security_breach
	Checksum: 0x5B44ABA4
	Offset: 0x450
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_security_breach_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.security_breach))
	{
		return self [[level.cybercom.security_breach._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_security_breach_on_take
	Namespace: _gadget_security_breach
	Checksum: 0x1E55DFB7
	Offset: 0x4B8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_security_breach_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.security_breach))
	{
		return self [[level.cybercom.security_breach._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_security_breach_on_connect
	Namespace: _gadget_security_breach
	Checksum: 0x60F5FC23
	Offset: 0x520
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_security_breach_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.security_breach))
	{
		return self [[level.cybercom.security_breach._on_connect]]();
	}
}

/*
	Name: gadget_security_breach_on
	Namespace: _gadget_security_breach
	Checksum: 0xE829D52C
	Offset: 0x570
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_security_breach_on(slot, weapon)
{
	self flagsys::set("gadget_security_breach_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.security_breach))
	{
		return self [[level.cybercom.security_breach._on]](slot, weapon);
	}
}

/*
	Name: gadget_security_breach_off
	Namespace: _gadget_security_breach
	Checksum: 0x233804A1
	Offset: 0x5F8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_security_breach_off(slot, weapon)
{
	self flagsys::clear("gadget_security_breach_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.security_breach))
	{
		return self [[level.cybercom.security_breach._off]](slot, weapon);
	}
}

/*
	Name: gadget_security_breach_is_primed
	Namespace: _gadget_security_breach
	Checksum: 0xFC9F1239
	Offset: 0x680
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_security_breach_is_primed(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.security_breach))
	{
		self [[level.cybercom.security_breach._is_primed]](slot, weapon);
	}
}

