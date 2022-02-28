// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace zm_stalingrad_ffotd;

/*
	Name: main_start
	Namespace: zm_stalingrad_ffotd
	Checksum: 0x932BA43E
	Offset: 0x230
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function main_start()
{
	spawncollision("collision_player_wall_256x256x10", "collider", (988, 3524, 380), vectorscale((0, 1, 0), 90));
	spawncollision("collision_player_wall_256x256x10", "collider", (988, 3524, 636), vectorscale((0, 1, 0), 90));
	spawncollision("collision_player_64x64x128", "collider", (-1184, 2947, 224), vectorscale((0, -1, 0), 45));
	spawncollision("collision_player_64x64x128", "collider", (-1224, 2971, 224), vectorscale((0, -1, 0), 17));
}

/*
	Name: main_end
	Namespace: zm_stalingrad_ffotd
	Checksum: 0xE7C00023
	Offset: 0x340
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function main_end()
{
	level function_30409839();
}

/*
	Name: function_30409839
	Namespace: zm_stalingrad_ffotd
	Checksum: 0x6FD428DF
	Offset: 0x368
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_30409839()
{
	var_5d655ddb = struct::get_array("intermission", "targetname");
	foreach(var_13e6937b in var_5d655ddb)
	{
		if(var_13e6937b.origin == (-3106, 2242, 653))
		{
			var_13e6937b struct::delete();
			return;
		}
	}
}

