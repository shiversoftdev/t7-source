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

#namespace _gadget_smokescreen;

/*
	Name: __init__sytem__
	Namespace: _gadget_smokescreen
	Checksum: 0x950EF401
	Offset: 0x1F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_smokescreen", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_smokescreen
	Checksum: 0x542E3F35
	Offset: 0x238
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(36, &gadget_smokescreen_on, &gadget_smokescreen_off);
	ability_player::register_gadget_possession_callbacks(36, &gadget_smokescreen_on_give, &gadget_smokescreen_on_take);
	ability_player::register_gadget_flicker_callbacks(36, &gadget_smokescreen_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(36, &gadget_smokescreen_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(36, &gadget_smokescreen_is_flickering);
	ability_player::register_gadget_primed_callbacks(36, &gadget_smokescreen_is_primed);
	callback::on_connect(&gadget_smokescreen_on_connect);
}

/*
	Name: gadget_smokescreen_is_inuse
	Namespace: _gadget_smokescreen
	Checksum: 0x64D4AD85
	Offset: 0x348
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_smokescreen_is_inuse(slot)
{
	return self flagsys::get("gadget_smokescreen_on");
}

/*
	Name: gadget_smokescreen_is_flickering
	Namespace: _gadget_smokescreen
	Checksum: 0x3162B952
	Offset: 0x380
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function gadget_smokescreen_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.smokescreen))
	{
		return self [[level.cybercom.smokescreen._is_flickering]](slot);
	}
	return 0;
}

/*
	Name: gadget_smokescreen_on_flicker
	Namespace: _gadget_smokescreen
	Checksum: 0xFCE089FB
	Offset: 0x3E0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_smokescreen_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.smokescreen))
	{
		self [[level.cybercom.smokescreen._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_smokescreen_on_give
	Namespace: _gadget_smokescreen
	Checksum: 0xFEE3F793
	Offset: 0x448
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_smokescreen_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.smokescreen))
	{
		self [[level.cybercom.smokescreen._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_smokescreen_on_take
	Namespace: _gadget_smokescreen
	Checksum: 0x475FC9D3
	Offset: 0x4B0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_smokescreen_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.smokescreen))
	{
		self [[level.cybercom.smokescreen._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_smokescreen_on_connect
	Namespace: _gadget_smokescreen
	Checksum: 0xE9880BCA
	Offset: 0x518
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_smokescreen_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.smokescreen))
	{
		self [[level.cybercom.smokescreen._on_connect]]();
	}
}

/*
	Name: gadget_smokescreen_on
	Namespace: _gadget_smokescreen
	Checksum: 0xA7C80E55
	Offset: 0x568
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_smokescreen_on(slot, weapon)
{
	self flagsys::set("gadget_smokescreen_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.smokescreen))
	{
		self [[level.cybercom.smokescreen._on]](slot, weapon);
	}
}

/*
	Name: gadget_smokescreen_off
	Namespace: _gadget_smokescreen
	Checksum: 0xFC69ED78
	Offset: 0x5F0
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_smokescreen_off(slot, weapon)
{
	self flagsys::clear("gadget_smokescreen_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.smokescreen))
	{
		self [[level.cybercom.smokescreen._off]](slot, weapon);
	}
}

/*
	Name: gadget_smokescreen_is_primed
	Namespace: _gadget_smokescreen
	Checksum: 0x7C07E269
	Offset: 0x678
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_smokescreen_is_primed(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.smokescreen))
	{
		self [[level.cybercom.smokescreen._is_primed]](slot, weapon);
	}
}

