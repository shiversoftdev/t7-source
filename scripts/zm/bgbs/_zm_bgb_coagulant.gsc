// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_coagulant;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_coagulant
	Checksum: 0xA8C7AF2D
	Offset: 0x1A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_coagulant", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_coagulant
	Checksum: 0x2DD2054A
	Offset: 0x1E8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_coagulant", "time", 1200, &enable, &disable, undefined, undefined);
}

/*
	Name: enable
	Namespace: zm_bgb_coagulant
	Checksum: 0x7C9767BA
	Offset: 0x258
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function enable()
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"bgb_update");
	self.n_bleedout_time_multiplier = 3;
	while(true)
	{
		self waittill(#"player_downed");
		self bgb::do_one_shot_use(1);
	}
}

/*
	Name: disable
	Namespace: zm_bgb_coagulant
	Checksum: 0x62D30F54
	Offset: 0x2C8
	Size: 0xE
	Parameters: 0
	Flags: Linked
*/
function disable()
{
	self.n_bleedout_time_multiplier = undefined;
}

