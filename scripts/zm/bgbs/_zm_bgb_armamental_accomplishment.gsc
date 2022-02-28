// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_armamental_accomplishment;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_armamental_accomplishment
	Checksum: 0xB735FB7A
	Offset: 0x1E8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_armamental_accomplishment", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_armamental_accomplishment
	Checksum: 0x75406CC4
	Offset: 0x228
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_armamental_accomplishment", "rounds", 3, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: zm_bgb_armamental_accomplishment
	Checksum: 0x403E80BF
	Offset: 0x290
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function enable()
{
	self setperk("specialty_fastmeleerecovery");
	self setperk("specialty_fastweaponswitch");
	self setperk("specialty_fastequipmentuse");
	self setperk("specialty_fasttoss");
}

/*
	Name: disable
	Namespace: zm_bgb_armamental_accomplishment
	Checksum: 0x7BBA458A
	Offset: 0x320
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function disable()
{
	self unsetperk("specialty_fastmeleerecovery");
	self unsetperk("specialty_fastweaponswitch");
	self unsetperk("specialty_fastequipmentuse");
	self unsetperk("specialty_fasttoss");
}

