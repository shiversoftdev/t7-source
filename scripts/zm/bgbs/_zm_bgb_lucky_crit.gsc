// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_lucky_crit;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_lucky_crit
	Checksum: 0xAE8AC95E
	Offset: 0x178
	Size: 0x4C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_lucky_crit", &__init__, undefined, array("aat", "bgb"));
}

/*
	Name: __init__
	Namespace: zm_bgb_lucky_crit
	Checksum: 0xB37E3ABF
	Offset: 0x1D0
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use) || (!(isdefined(level.bgb_in_use) && level.bgb_in_use)))
	{
		return;
	}
	bgb::register("zm_bgb_lucky_crit", "rounds", 1, undefined, undefined, undefined);
	aat::register_reroll("zm_bgb_lucky_crit", 2, &active, "t7_hud_zm_aat_bgb");
}

/*
	Name: active
	Namespace: zm_bgb_lucky_crit
	Checksum: 0xE867DF8D
	Offset: 0x270
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function active()
{
	return bgb::is_enabled("zm_bgb_lucky_crit");
}

