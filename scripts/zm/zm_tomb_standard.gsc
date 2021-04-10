// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_game_module;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\gametypes\_zm_gametype;

#namespace namespace_a026fc99;

/*
	Name: precache
	Namespace: namespace_a026fc99
	Checksum: 0x99EC1590
	Offset: 0x1B8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function precache()
{
}

/*
	Name: main
	Namespace: namespace_a026fc99
	Checksum: 0xC5F36992
	Offset: 0x1C8
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function main()
{
	level flag::wait_till("initial_blackscreen_passed");
	level flag::set("power_on");
	zm_treasure_chest_init();
}

/*
	Name: zm_treasure_chest_init
	Namespace: namespace_a026fc99
	Checksum: 0x6B5EF0A4
	Offset: 0x228
	Size: 0xC4
	Parameters: 0
	Flags: None
*/
function zm_treasure_chest_init()
{
	chest1 = struct::get("start_chest", "script_noteworthy");
	level.chests = [];
	if(!isdefined(level.chests))
	{
		level.chests = [];
	}
	else if(!isarray(level.chests))
	{
		level.chests = array(level.chests);
	}
	level.chests[level.chests.size] = chest1;
	zm_magicbox::treasure_chest_init("start_chest");
}

