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

#namespace _gadget_mrpukey;

/*
	Name: __init__sytem__
	Namespace: _gadget_mrpukey
	Checksum: 0x3059694E
	Offset: 0x1F0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_mrpukey", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_mrpukey
	Checksum: 0xC3277878
	Offset: 0x230
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(38, &gadget_mrpukey_on, &gadget_mrpukey_off);
	ability_player::register_gadget_possession_callbacks(38, &gadget_mrpukey_on_give, &gadget_mrpukey_on_take);
	ability_player::register_gadget_flicker_callbacks(38, &gadget_mrpukey_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(38, &gadget_mrpukey_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(38, &gadget_mrpukey_is_flickering);
	ability_player::register_gadget_primed_callbacks(38, &gadget_mrpukey_is_primed);
}

/*
	Name: gadget_mrpukey_is_inuse
	Namespace: _gadget_mrpukey
	Checksum: 0x5320560F
	Offset: 0x320
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_mrpukey_is_inuse(slot)
{
	return self flagsys::get("gadget_mrpukey_on");
}

/*
	Name: gadget_mrpukey_is_flickering
	Namespace: _gadget_mrpukey
	Checksum: 0xC50C3CA2
	Offset: 0x358
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function gadget_mrpukey_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.mrpukey))
	{
		return self [[level.cybercom.mrpukey._is_flickering]](slot);
	}
}

/*
	Name: gadget_mrpukey_on_flicker
	Namespace: _gadget_mrpukey
	Checksum: 0xC810AD
	Offset: 0x3B0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_mrpukey_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.mrpukey))
	{
		self [[level.cybercom.mrpukey._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_mrpukey_on_give
	Namespace: _gadget_mrpukey
	Checksum: 0xAB1CCD16
	Offset: 0x418
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_mrpukey_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.mrpukey))
	{
		self [[level.cybercom.mrpukey._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_mrpukey_on_take
	Namespace: _gadget_mrpukey
	Checksum: 0xE9FE21A9
	Offset: 0x480
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_mrpukey_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.mrpukey))
	{
		self [[level.cybercom.mrpukey._on_take]](slot, weapon);
	}
}

/*
	Name: gadge_mrpukey_on_connect
	Namespace: _gadget_mrpukey
	Checksum: 0x3662DA1B
	Offset: 0x4E8
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function gadge_mrpukey_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.mrpukey))
	{
		self [[level.cybercom.mrpukey._on_connect]]();
	}
}

/*
	Name: gadget_mrpukey_on
	Namespace: _gadget_mrpukey
	Checksum: 0x262DA596
	Offset: 0x538
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_mrpukey_on(slot, weapon)
{
	self flagsys::set("gadget_mrpukey_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.mrpukey))
	{
		self [[level.cybercom.mrpukey._on]](slot, weapon);
	}
}

/*
	Name: gadget_mrpukey_off
	Namespace: _gadget_mrpukey
	Checksum: 0xEE2CD722
	Offset: 0x5C0
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_mrpukey_off(slot, weapon)
{
	self flagsys::clear("gadget_mrpukey_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.mrpukey))
	{
		self [[level.cybercom.mrpukey._off]](slot, weapon);
	}
}

/*
	Name: gadget_mrpukey_is_primed
	Namespace: _gadget_mrpukey
	Checksum: 0x65F01284
	Offset: 0x648
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_mrpukey_is_primed(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.mrpukey))
	{
		self [[level.cybercom.mrpukey._is_primed]](slot, weapon);
	}
}

