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

#namespace zm_asylum_ffotd;

/*
	Name: main_start
	Namespace: zm_asylum_ffotd
	Checksum: 0x99EC1590
	Offset: 0x1F8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function main_start()
{
}

/*
	Name: main_end
	Namespace: zm_asylum_ffotd
	Checksum: 0x73C5CE6D
	Offset: 0x208
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function main_end()
{
	spawncollision("collision_player_wall_64x64x10", "collider", (1256, 355.5, 197), vectorscale((0, 1, 0), 270));
}

