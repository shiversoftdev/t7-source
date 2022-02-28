// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_immolation_liquidation;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_immolation_liquidation
	Checksum: 0x691467CC
	Offset: 0x188
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_immolation_liquidation", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_immolation_liquidation
	Checksum: 0x4C05325F
	Offset: 0x1C8
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
	bgb::register("zm_bgb_immolation_liquidation", "activated", 3, undefined, undefined, &function_3d1f600e, &activation);
}

/*
	Name: activation
	Namespace: zm_bgb_immolation_liquidation
	Checksum: 0x33C4332E
	Offset: 0x238
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	self thread bgb::function_dea74fb0("fire_sale");
}

/*
	Name: function_3d1f600e
	Namespace: zm_bgb_immolation_liquidation
	Checksum: 0xD54D9F7B
	Offset: 0x268
	Size: 0x3E
	Parameters: 0
	Flags: Linked
*/
function function_3d1f600e()
{
	if(level.zombie_vars["zombie_powerup_fire_sale_on"] === 1 || (isdefined(level.disable_firesale_drop) && level.disable_firesale_drop))
	{
		return false;
	}
	return true;
}

