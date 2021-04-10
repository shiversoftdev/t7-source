// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;

#namespace zm_tomb_dig;

/*
	Name: init
	Namespace: zm_tomb_dig
	Checksum: 0x21F714DD
	Offset: 0x1C0
	Size: 0x244
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("world", "player0hasItem", 15000, 2, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "player1hasItem", 15000, 2, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "player2hasItem", 15000, 2, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "player3hasItem", 15000, 2, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "player0wearableItem", 15000, 1, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "player1wearableItem", 15000, 1, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "player2wearableItem", 15000, 1, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "player3wearableItem", 15000, 1, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
}

