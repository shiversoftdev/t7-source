// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;

#namespace zm_island_zones;

/*
	Name: init
	Namespace: zm_island_zones
	Checksum: 0x3A38C980
	Offset: 0x190
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("scriptmover", "vine_door_play_fx", 9000, 1, "int", &vine_door_play_fx, 0, 0);
}

/*
	Name: vine_door_play_fx
	Namespace: zm_island_zones
	Checksum: 0x1E219594
	Offset: 0x1E8
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function vine_door_play_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["door_vine_fx"], self, "tag_fx_origin");
}

/*
	Name: main
	Namespace: zm_island_zones
	Checksum: 0x99EC1590
	Offset: 0x260
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function main()
{
}

