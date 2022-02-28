// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace zm_powerup_nuke;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_nuke
	Checksum: 0x32EC6FB2
	Offset: 0x150
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_nuke", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_nuke
	Checksum: 0x79AAEE42
	Offset: 0x190
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_powerups::include_zombie_powerup("nuke");
	zm_powerups::add_zombie_powerup("nuke");
	clientfield::register("actor", "zm_nuked", 1000, 1, "counter", &zombie_nuked, 0, 0);
	clientfield::register("vehicle", "zm_nuked", 1000, 1, "counter", &zombie_nuked, 0, 0);
}

/*
	Name: zombie_nuked
	Namespace: zm_powerup_nuke
	Checksum: 0x24B21264
	Offset: 0x260
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function zombie_nuked(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self zombie_death::flame_death_fx(localclientnum);
}

