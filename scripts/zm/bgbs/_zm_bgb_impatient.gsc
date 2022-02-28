// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_impatient;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_impatient
	Checksum: 0x89F94FB2
	Offset: 0x1B0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_impatient", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_impatient
	Checksum: 0xF31290CF
	Offset: 0x1F0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_impatient", "event", &event, undefined, undefined, undefined);
}

/*
	Name: event
	Namespace: zm_bgb_impatient
	Checksum: 0x47ED6A2E
	Offset: 0x250
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function event()
{
	self endon(#"disconnect");
	self endon(#"bgb_update");
	self waittill(#"bgb_about_to_take_on_bled_out");
	self thread special_revive();
}

/*
	Name: special_revive
	Namespace: zm_bgb_impatient
	Checksum: 0xE0C33368
	Offset: 0x298
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function special_revive()
{
	self endon(#"disconnect");
	wait(1);
	while(level.zombie_total > 0)
	{
		wait(0.05);
	}
	self zm::spectator_respawn_player();
	self bgb::do_one_shot_use();
}

