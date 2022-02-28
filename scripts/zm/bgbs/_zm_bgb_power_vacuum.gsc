// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_power_vacuum;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_power_vacuum
	Checksum: 0xA3AEBFB3
	Offset: 0x168
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_power_vacuum", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_power_vacuum
	Checksum: 0x3550DE5F
	Offset: 0x1A8
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
	bgb::register("zm_bgb_power_vacuum", "rounds", 4, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: zm_bgb_power_vacuum
	Checksum: 0xF6C1E19D
	Offset: 0x210
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function enable()
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"bgb_update");
	level.powerup_drop_count = 0;
	while(true)
	{
		level waittill(#"powerup_dropped");
		self bgb::do_one_shot_use();
		level.powerup_drop_count = 0;
	}
}

/*
	Name: disable
	Namespace: zm_bgb_power_vacuum
	Checksum: 0x99EC1590
	Offset: 0x288
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function disable()
{
}

