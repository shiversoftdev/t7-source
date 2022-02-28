// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;

#namespace _gadget_active_camo;

/*
	Name: __init__sytem__
	Namespace: _gadget_active_camo
	Checksum: 0x7D4C23DD
	Offset: 0x1E8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_active_camo", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_active_camo
	Checksum: 0x3682D3B3
	Offset: 0x228
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(31, &camo_gadget_on, &camo_gadget_off);
	ability_player::register_gadget_possession_callbacks(31, &camo_on_give, &camo_on_take);
	ability_player::register_gadget_flicker_callbacks(31, &camo_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(31, &camo_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(31, &camo_is_flickering);
	callback::on_connect(&camo_on_connect);
	callback::on_spawned(&camo_on_spawn);
	callback::on_disconnect(&camo_on_disconnect);
}

/*
	Name: camo_on_connect
	Namespace: _gadget_active_camo
	Checksum: 0xCAC32374
	Offset: 0x358
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function camo_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.active_camo))
	{
		self [[level.cybercom.active_camo._on_connect]]();
	}
}

/*
	Name: camo_on_disconnect
	Namespace: _gadget_active_camo
	Checksum: 0x99EC1590
	Offset: 0x3A8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function camo_on_disconnect()
{
}

/*
	Name: camo_on_spawn
	Namespace: _gadget_active_camo
	Checksum: 0x42AC512D
	Offset: 0x3B8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function camo_on_spawn()
{
	self flagsys::clear("camo_suit_on");
	self notify(#"camo_off");
	self clientfield::set("camo_shader", 0);
}

/*
	Name: camo_is_inuse
	Namespace: _gadget_active_camo
	Checksum: 0x6ACBA577
	Offset: 0x418
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function camo_is_inuse(slot)
{
	return self flagsys::get("camo_suit_on");
}

/*
	Name: camo_is_flickering
	Namespace: _gadget_active_camo
	Checksum: 0xA4D695D2
	Offset: 0x450
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function camo_is_flickering(slot)
{
	return self gadgetflickering(slot);
}

/*
	Name: camo_on_give
	Namespace: _gadget_active_camo
	Checksum: 0x8C7EDC40
	Offset: 0x480
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function camo_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.active_camo))
	{
		self [[level.cybercom.active_camo._on_give]](slot, weapon);
	}
}

/*
	Name: camo_on_take
	Namespace: _gadget_active_camo
	Checksum: 0x9A713E1C
	Offset: 0x4E8
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function camo_on_take(slot, weapon)
{
	self notify(#"camo_removed");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.active_camo))
	{
		self [[level.cybercom.active_camo._on_take]](slot, weapon);
	}
}

/*
	Name: camo_on_flicker
	Namespace: _gadget_active_camo
	Checksum: 0x770E5F3B
	Offset: 0x560
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function camo_on_flicker(slot, weapon)
{
	self thread suspend_camo_suit(slot, weapon);
	if(isdefined(level.cybercom) && isdefined(level.cybercom.active_camo))
	{
		self thread [[level.cybercom.active_camo._on_flicker]](slot, weapon);
	}
}

/*
	Name: camo_gadget_on
	Namespace: _gadget_active_camo
	Checksum: 0x8C79D2E8
	Offset: 0x5E8
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function camo_gadget_on(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.active_camo))
	{
		self thread [[level.cybercom.active_camo._on]](slot, weapon);
	}
	else
	{
		self clientfield::set("camo_shader", 1);
	}
	self flagsys::set("camo_suit_on");
}

/*
	Name: camo_gadget_off
	Namespace: _gadget_active_camo
	Checksum: 0x901995F2
	Offset: 0x698
	Size: 0xAC
	Parameters: 2
	Flags: Linked
*/
function camo_gadget_off(slot, weapon)
{
	self flagsys::clear("camo_suit_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.active_camo))
	{
		self thread [[level.cybercom.active_camo._off]](slot, weapon);
	}
	self notify(#"camo_off");
	self clientfield::set("camo_shader", 0);
}

/*
	Name: suspend_camo_suit
	Namespace: _gadget_active_camo
	Checksum: 0x99E18047
	Offset: 0x750
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function suspend_camo_suit(slot, weapon)
{
	self endon(#"disconnect");
	self endon(#"camo_off");
	self clientfield::set("camo_shader", 2);
	suspend_camo_suit_wait(slot, weapon);
	if(self camo_is_inuse(slot))
	{
		self clientfield::set("camo_shader", 1);
	}
}

/*
	Name: suspend_camo_suit_wait
	Namespace: _gadget_active_camo
	Checksum: 0x24113E8A
	Offset: 0x7F8
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function suspend_camo_suit_wait(slot, weapon)
{
	self endon(#"death");
	self endon(#"camo_off");
	while(self camo_is_flickering(slot))
	{
		wait(0.5);
	}
}

