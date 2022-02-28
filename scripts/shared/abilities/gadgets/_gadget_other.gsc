// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_other;

/*
	Name: __init__sytem__
	Namespace: _gadget_other
	Checksum: 0xADF710E8
	Offset: 0x218
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_other", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_other
	Checksum: 0xF02213D9
	Offset: 0x258
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(1, &gadget_other_on_activate, &gadget_other_on_off);
	ability_player::register_gadget_possession_callbacks(1, &gadget_other_on_give, &gadget_other_on_take);
	ability_player::register_gadget_flicker_callbacks(1, &gadget_other_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(1, &gadget_other_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(1, &gadget_other_is_flickering);
	ability_player::register_gadget_ready_callbacks(1, &gadget_other_ready);
}

/*
	Name: gadget_other_is_inuse
	Namespace: _gadget_other
	Checksum: 0x8D058F
	Offset: 0x348
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_other_is_inuse(slot)
{
	return self gadgetisactive(slot);
}

/*
	Name: gadget_other_is_flickering
	Namespace: _gadget_other
	Checksum: 0xEDF8B652
	Offset: 0x378
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_other_is_flickering(slot)
{
	return self gadgetflickering(slot);
}

/*
	Name: gadget_other_on_flicker
	Namespace: _gadget_other
	Checksum: 0x38321943
	Offset: 0x3A8
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_other_on_flicker(slot, weapon)
{
}

/*
	Name: gadget_other_on_give
	Namespace: _gadget_other
	Checksum: 0x3CAD2797
	Offset: 0x3C8
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_other_on_give(slot, weapon)
{
}

/*
	Name: gadget_other_on_take
	Namespace: _gadget_other
	Checksum: 0x9622AB3D
	Offset: 0x3E8
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_other_on_take(slot, weapon)
{
}

/*
	Name: gadget_other_on_connect
	Namespace: _gadget_other
	Checksum: 0x99EC1590
	Offset: 0x408
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function gadget_other_on_connect()
{
}

/*
	Name: gadget_other_on_spawn
	Namespace: _gadget_other
	Checksum: 0x99EC1590
	Offset: 0x418
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function gadget_other_on_spawn()
{
}

/*
	Name: gadget_other_on_activate
	Namespace: _gadget_other
	Checksum: 0xAAFBE343
	Offset: 0x428
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_other_on_activate(slot, weapon)
{
}

/*
	Name: gadget_other_on_off
	Namespace: _gadget_other
	Checksum: 0xBACA77C8
	Offset: 0x448
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_other_on_off(slot, weapon)
{
}

/*
	Name: gadget_other_ready
	Namespace: _gadget_other
	Checksum: 0xC990AE0A
	Offset: 0x468
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_other_ready(slot, weapon)
{
}

/*
	Name: set_gadget_other_status
	Namespace: _gadget_other
	Checksum: 0x993ADB86
	Offset: 0x488
	Size: 0xB4
	Parameters: 3
	Flags: None
*/
function set_gadget_other_status(weapon, status, time)
{
	timestr = "";
	if(isdefined(time))
	{
		timestr = (("^3") + ", time: ") + time;
	}
	if(getdvarint("scr_cpower_debug_prints") > 0)
	{
		self iprintlnbold(((("Gadget Other " + weapon.name) + ": ") + status) + timestr);
	}
}

