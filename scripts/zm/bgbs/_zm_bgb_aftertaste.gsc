// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_aftertaste;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_aftertaste
	Checksum: 0xCF8D4385
	Offset: 0x1D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_aftertaste", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_aftertaste
	Checksum: 0xE0ECA87A
	Offset: 0x218
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_aftertaste", "rounds", 3, &event, undefined, undefined, undefined);
	bgb::register_lost_perk_override("zm_bgb_aftertaste", &lost_perk_override, 0);
}

/*
	Name: lost_perk_override
	Namespace: zm_bgb_aftertaste
	Checksum: 0x259233DE
	Offset: 0x2A0
	Size: 0x9A
	Parameters: 3
	Flags: Linked
*/
function lost_perk_override(perk, var_2488e46a = undefined, var_24df4040 = undefined)
{
	if(zm_perks::use_solo_revive() && perk == "specialty_quickrevive")
	{
		return false;
	}
	if(isdefined(var_2488e46a) && isdefined(var_24df4040) && var_2488e46a == var_24df4040)
	{
		return true;
	}
	return false;
}

/*
	Name: event
	Namespace: zm_bgb_aftertaste
	Checksum: 0x7705807E
	Offset: 0x348
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function event()
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"bgb_update");
	while(true)
	{
		self waittill(#"player_downed");
		self bgb::do_one_shot_use(1);
	}
}

