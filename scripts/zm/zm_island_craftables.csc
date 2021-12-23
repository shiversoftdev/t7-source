// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;

#namespace zm_island_craftables;

/*
	Name: init_craftables
	Namespace: zm_island_craftables
	Checksum: 0x5B982EEF
	Offset: 0x178
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function init_craftables()
{
	register_clientfields();
	zm_craftables::add_zombie_craftable("gasmask");
	level thread zm_craftables::set_clientfield_craftables_code_callbacks();
}

/*
	Name: include_craftables
	Namespace: zm_island_craftables
	Checksum: 0x1A9AFC8A
	Offset: 0x1C8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function include_craftables()
{
	zm_craftables::include_zombie_craftable("gasmask");
}

/*
	Name: register_clientfields
	Namespace: zm_island_craftables
	Checksum: 0x7829BFEA
	Offset: 0x1F0
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	shared_bits = 1;
	registerclientfield("world", ("gasmask" + "_") + "part_visor", 9000, shared_bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	registerclientfield("world", ("gasmask" + "_") + "part_filter", 9000, shared_bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	registerclientfield("world", ("gasmask" + "_") + "part_strap", 9000, shared_bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	clientfield::register("toplayer", "ZMUI_GRAVITYSPIKE_PART_PICKUP", 9000, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZMUI_GRAVITYSPIKE_CRAFTED", 9000, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
}

