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

#namespace _gadget_cleanse;

/*
	Name: __init__sytem__
	Namespace: _gadget_cleanse
	Checksum: 0x27B72C60
	Offset: 0x208
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_cleanse", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_cleanse
	Checksum: 0x4C118825
	Offset: 0x248
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(17, &gadget_cleanse_on, &gadget_cleanse_off);
	ability_player::register_gadget_possession_callbacks(17, &gadget_cleanse_on_give, &gadget_cleanse_on_take);
	ability_player::register_gadget_flicker_callbacks(17, &gadget_cleanse_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(17, &gadget_cleanse_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(17, &gadget_cleanse_is_flickering);
	clientfield::register("allplayers", "gadget_cleanse_on", 1, 1, "int");
	callback::on_connect(&gadget_cleanse_on_connect);
}

/*
	Name: gadget_cleanse_is_inuse
	Namespace: _gadget_cleanse
	Checksum: 0x4AA20E2C
	Offset: 0x368
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gadget_cleanse_is_inuse(slot)
{
	return self flagsys::get("gadget_cleanse_on");
}

/*
	Name: gadget_cleanse_is_flickering
	Namespace: _gadget_cleanse
	Checksum: 0x5002E5CE
	Offset: 0x3A0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_cleanse_is_flickering(slot)
{
	return self gadgetflickering(slot);
}

/*
	Name: gadget_cleanse_on_flicker
	Namespace: _gadget_cleanse
	Checksum: 0x52484437
	Offset: 0x3D0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function gadget_cleanse_on_flicker(slot, weapon)
{
	self thread gadget_cleanse_flicker(slot, weapon);
}

/*
	Name: gadget_cleanse_on_give
	Namespace: _gadget_cleanse
	Checksum: 0x38D1EBD
	Offset: 0x410
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_cleanse_on_give(slot, weapon)
{
}

/*
	Name: gadget_cleanse_on_take
	Namespace: _gadget_cleanse
	Checksum: 0xD0D8EA22
	Offset: 0x430
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_cleanse_on_take(slot, weapon)
{
}

/*
	Name: gadget_cleanse_on_connect
	Namespace: _gadget_cleanse
	Checksum: 0x99EC1590
	Offset: 0x450
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function gadget_cleanse_on_connect()
{
}

/*
	Name: gadget_cleanse_on
	Namespace: _gadget_cleanse
	Checksum: 0xD56256F8
	Offset: 0x460
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function gadget_cleanse_on(slot, weapon)
{
	self flagsys::set("gadget_cleanse_on");
	self thread gadget_cleanse_start(slot, weapon);
	self clientfield::set("gadget_cleanse_on", 1);
}

/*
	Name: gadget_cleanse_off
	Namespace: _gadget_cleanse
	Checksum: 0x12146B61
	Offset: 0x4E0
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function gadget_cleanse_off(slot, weapon)
{
	self flagsys::clear("gadget_cleanse_on");
	self clientfield::set("gadget_cleanse_on", 0);
}

/*
	Name: gadget_cleanse_start
	Namespace: _gadget_cleanse
	Checksum: 0x38085CF0
	Offset: 0x540
	Size: 0xAA
	Parameters: 2
	Flags: Linked
*/
function gadget_cleanse_start(slot, weapon)
{
	self setempjammed(0);
	self gadgetsetactivatetime(slot, gettime());
	self setnormalhealth(self.maxhealth);
	self setdoublejumpenergy(1);
	self stopshellshock();
	self notify(#"gadget_cleanse_on");
}

/*
	Name: wait_until_is_done
	Namespace: _gadget_cleanse
	Checksum: 0xFC44388A
	Offset: 0x5F8
	Size: 0x14
	Parameters: 2
	Flags: None
*/
function wait_until_is_done(slot, timepulse)
{
}

/*
	Name: gadget_cleanse_flicker
	Namespace: _gadget_cleanse
	Checksum: 0x222DCCC7
	Offset: 0x618
	Size: 0x1E
	Parameters: 2
	Flags: Linked
*/
function gadget_cleanse_flicker(slot, weapon)
{
	self endon(#"disconnect");
}

/*
	Name: set_gadget_cleanse_status
	Namespace: _gadget_cleanse
	Checksum: 0xB5C40F2E
	Offset: 0x640
	Size: 0x14
	Parameters: 2
	Flags: None
*/
function set_gadget_cleanse_status(status, time)
{
}

