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

#namespace _gadget_concussive_wave;

/*
	Name: __init__sytem__
	Namespace: _gadget_concussive_wave
	Checksum: 0x64D5294A
	Offset: 0x208
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_concussive_wave", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_concussive_wave
	Checksum: 0xB71919AA
	Offset: 0x248
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(27, &gadget_concussive_wave_on, &gadget_concussive_wave_off);
	ability_player::register_gadget_possession_callbacks(27, &gadget_concussive_wave_on_give, &gadget_concussive_wave_on_take);
	ability_player::register_gadget_flicker_callbacks(27, &gadget_concussive_wave_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(27, &gadget_concussive_wave_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(27, &gadget_concussive_wave_is_flickering);
	ability_player::register_gadget_primed_callbacks(27, &gadget_concussive_wave_is_primed);
	callback::on_connect(&gadget_concussive_wave_on_connect);
}

/*
	Name: gadget_concussive_wave_is_inuse
	Namespace: _gadget_concussive_wave
	Checksum: 0xA1F9988A
	Offset: 0x358
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_concussive_wave_is_inuse(slot)
{
	return self flagsys::get("gadget_concussive_wave_on");
}

/*
	Name: gadget_concussive_wave_is_flickering
	Namespace: _gadget_concussive_wave
	Checksum: 0x49C1803
	Offset: 0x390
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function gadget_concussive_wave_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.concussive_wave))
	{
		return self [[level.cybercom.concussive_wave._is_flickering]](slot);
	}
	return 0;
}

/*
	Name: gadget_concussive_wave_on_flicker
	Namespace: _gadget_concussive_wave
	Checksum: 0x9A0380CE
	Offset: 0x3F0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_concussive_wave_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.concussive_wave))
	{
		self [[level.cybercom.concussive_wave._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_concussive_wave_on_give
	Namespace: _gadget_concussive_wave
	Checksum: 0xC9B81509
	Offset: 0x458
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_concussive_wave_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.concussive_wave))
	{
		self [[level.cybercom.concussive_wave._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_concussive_wave_on_take
	Namespace: _gadget_concussive_wave
	Checksum: 0x6C92F5F8
	Offset: 0x4C0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_concussive_wave_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.concussive_wave))
	{
		self [[level.cybercom.concussive_wave._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_concussive_wave_on_connect
	Namespace: _gadget_concussive_wave
	Checksum: 0xDD2C0E16
	Offset: 0x528
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gadget_concussive_wave_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.concussive_wave))
	{
		self [[level.cybercom.concussive_wave._on_connect]]();
	}
}

/*
	Name: gadget_concussive_wave_on
	Namespace: _gadget_concussive_wave
	Checksum: 0x236D6DD8
	Offset: 0x578
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_concussive_wave_on(slot, weapon)
{
	self flagsys::set("gadget_concussive_wave_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.concussive_wave))
	{
		self [[level.cybercom.concussive_wave._on]](slot, weapon);
	}
}

/*
	Name: gadget_concussive_wave_off
	Namespace: _gadget_concussive_wave
	Checksum: 0x1F32F8A9
	Offset: 0x600
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_concussive_wave_off(slot, weapon)
{
	self flagsys::clear("gadget_concussive_wave_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.concussive_wave))
	{
		self [[level.cybercom.concussive_wave._off]](slot, weapon);
	}
}

/*
	Name: gadget_concussive_wave_is_primed
	Namespace: _gadget_concussive_wave
	Checksum: 0xAA8B8870
	Offset: 0x688
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_concussive_wave_is_primed(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.concussive_wave))
	{
		self [[level.cybercom.concussive_wave._is_primed]](slot, weapon);
	}
}

