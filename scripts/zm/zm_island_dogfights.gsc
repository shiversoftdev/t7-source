// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace zm_island_dogfights;

/*
	Name: init
	Namespace: zm_island_dogfights
	Checksum: 0x15D9EE4A
	Offset: 0x2C0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("world", "play_dogfight_scenes", 9000, 3, "int");
}

/*
	Name: main
	Namespace: zm_island_dogfights
	Checksum: 0x4BD68594
	Offset: 0x300
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	if(getdvarint("splitscreen_playerCount") >= 3)
	{
		return;
	}
	level waittill(#"hash_5574fd9b");
	level thread function_5daf587e();
	level thread function_2737bcd8();
	level thread function_99236d51();
	level thread function_b9d547c();
	level clientfield::set("play_dogfight_scenes", 0);
	level clientfield::set("play_dogfight_scenes", 5);
}

/*
	Name: function_5daf587e
	Namespace: zm_island_dogfights
	Checksum: 0x17C068F4
	Offset: 0x3E0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_5daf587e()
{
	wait(4);
	level clientfield::set("play_dogfight_scenes", 1);
}

/*
	Name: function_2737bcd8
	Namespace: zm_island_dogfights
	Checksum: 0xFA83D40E
	Offset: 0x418
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_2737bcd8()
{
	level flag::wait_till_any(array("connect_swamp_to_swamp_lab", "connect_swamp_lab_to_bunker_exterior"));
	level clientfield::set("play_dogfight_scenes", 2);
}

/*
	Name: function_99236d51
	Namespace: zm_island_dogfights
	Checksum: 0x6E32F7A9
	Offset: 0x478
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_99236d51()
{
	level flag::wait_till_any(array("connect_jungle_to_jungle_lab", "connect_jungle_lab_to_bunker_exterior"));
	wait(2);
	level clientfield::set("play_dogfight_scenes", 3);
}

/*
	Name: function_b9d547c
	Namespace: zm_island_dogfights
	Checksum: 0x54EC9CE8
	Offset: 0x4E0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_b9d547c()
{
	level flag::wait_till("connect_bunker_interior_to_bunker_upper");
	wait(2);
	level clientfield::set("play_dogfight_scenes", 4);
}

