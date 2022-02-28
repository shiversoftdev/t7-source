// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_head_drama;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_head_drama
	Checksum: 0x9FE15EBA
	Offset: 0x188
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_head_drama", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_head_drama
	Checksum: 0xB61B5B28
	Offset: 0x1C8
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
	bgb::register("zm_bgb_head_drama", "rounds", 0, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: zm_bgb_head_drama
	Checksum: 0x292EE1E3
	Offset: 0x230
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function enable()
{
	self setperk("specialty_locdamagecountsasheadshot");
}

/*
	Name: disable
	Namespace: zm_bgb_head_drama
	Checksum: 0x12CC76E3
	Offset: 0x260
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function disable()
{
	self unsetperk("specialty_locdamagecountsasheadshot");
}

