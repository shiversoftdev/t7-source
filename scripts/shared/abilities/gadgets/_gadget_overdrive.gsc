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
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_overdrive;

/*
	Name: __init__sytem__
	Namespace: _gadget_overdrive
	Checksum: 0xEEDDCBC6
	Offset: 0x250
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_overdrive", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_overdrive
	Checksum: 0xABBC3641
	Offset: 0x290
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(28, &gadget_overdrive_on, &gadget_overdrive_off);
	ability_player::register_gadget_possession_callbacks(28, &gadget_overdrive_on_give, &gadget_overdrive_on_take);
	ability_player::register_gadget_flicker_callbacks(28, &gadget_overdrive_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(28, &gadget_overdrive_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(28, &gadget_overdrive_is_flickering);
	if(!isdefined(level.vsmgr_prio_visionset_overdrive))
	{
		level.vsmgr_prio_visionset_overdrive = 65;
	}
	visionset_mgr::register_info("visionset", "overdrive", 1, level.vsmgr_prio_visionset_overdrive, 15, 1, &visionset_mgr::ramp_in_out_thread_per_player, 0);
	callback::on_connect(&gadget_overdrive_on_connect);
	clientfield::register("toplayer", "overdrive_state", 1, 1, "int");
}

/*
	Name: gadget_overdrive_is_inuse
	Namespace: _gadget_overdrive
	Checksum: 0x51505205
	Offset: 0x408
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_overdrive_is_inuse(slot)
{
	return self flagsys::get("gadget_overdrive_on");
}

/*
	Name: gadget_overdrive_is_flickering
	Namespace: _gadget_overdrive
	Checksum: 0x5C698B63
	Offset: 0x440
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function gadget_overdrive_is_flickering(slot)
{
}

/*
	Name: gadget_overdrive_on_flicker
	Namespace: _gadget_overdrive
	Checksum: 0x56CC9F2
	Offset: 0x458
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_overdrive_on_flicker(slot, weapon)
{
}

/*
	Name: gadget_overdrive_on_give
	Namespace: _gadget_overdrive
	Checksum: 0xA2D7E72E
	Offset: 0x478
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_overdrive_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.overdrive))
	{
		self [[level.cybercom.overdrive._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_overdrive_on_take
	Namespace: _gadget_overdrive
	Checksum: 0x12FEE31A
	Offset: 0x4E0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_overdrive_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.overdrive))
	{
		self [[level.cybercom.overdrive._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_overdrive_on_connect
	Namespace: _gadget_overdrive
	Checksum: 0x99EC1590
	Offset: 0x548
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function gadget_overdrive_on_connect()
{
}

/*
	Name: gadget_overdrive_on
	Namespace: _gadget_overdrive
	Checksum: 0xB972E8A2
	Offset: 0x558
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_overdrive_on(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.overdrive))
	{
		self thread [[level.cybercom.overdrive._on]](slot, weapon);
		self flagsys::set("gadget_overdrive_on");
	}
}

/*
	Name: gadget_overdrive_off
	Namespace: _gadget_overdrive
	Checksum: 0xEC528C8
	Offset: 0x5E0
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function gadget_overdrive_off(slot, weapon)
{
	self flagsys::clear("gadget_overdrive_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.overdrive))
	{
		self thread [[level.cybercom.overdrive._off]](slot, weapon);
	}
}

