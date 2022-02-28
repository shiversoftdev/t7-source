// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_powerup_island_seed;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_island_seed
	Checksum: 0x4A0F53F6
	Offset: 0x1B0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_island_seed", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_island_seed
	Checksum: 0x7F371EBF
	Offset: 0x1F0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	register_clientfields();
	zm_powerups::include_zombie_powerup("island_seed");
	zm_powerups::add_zombie_powerup("island_seed");
}

/*
	Name: register_clientfields
	Namespace: zm_powerup_island_seed
	Checksum: 0xA130375C
	Offset: 0x240
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("toplayer", "has_island_seed", 1, 2, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_seed_parts", 9000, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "bucket_seed_01", 9000, 1, "int", &zm_utility::setinventoryuimodels, 0, 1);
	clientfield::register("toplayer", "bucket_seed_02", 9000, 1, "int", &zm_utility::setinventoryuimodels, 0, 1);
	clientfield::register("toplayer", "bucket_seed_03", 9000, 1, "int", &zm_utility::setinventoryuimodels, 0, 1);
}

