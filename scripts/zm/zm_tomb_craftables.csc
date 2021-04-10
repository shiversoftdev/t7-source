// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;

#namespace zm_tomb_craftables;

/*
	Name: init_craftables
	Namespace: zm_tomb_craftables
	Checksum: 0x4FA199F3
	Offset: 0x680
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function init_craftables()
{
	level.craftable_piece_count = 4;
	zm_craftables::add_zombie_craftable("equip_dieseldrone");
	zm_craftables::add_zombie_craftable("shovel");
	zm_craftables::add_zombie_craftable("elemental_staff_fire");
	zm_craftables::add_zombie_craftable("elemental_staff_air");
	zm_craftables::add_zombie_craftable("elemental_staff_water");
	zm_craftables::add_zombie_craftable("elemental_staff_lightning");
	zm_craftables::add_zombie_craftable("gramophone");
	include_craftables();
	register_clientfields();
	level thread zm_craftables::set_clientfield_craftables_code_callbacks();
}

/*
	Name: include_craftables
	Namespace: zm_tomb_craftables
	Checksum: 0x848867A4
	Offset: 0x780
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function include_craftables()
{
	zm_craftables::include_zombie_craftable("equip_dieseldrone");
	zm_craftables::include_zombie_craftable("shovel");
	zm_craftables::include_zombie_craftable("elemental_staff_fire");
	zm_craftables::include_zombie_craftable("elemental_staff_air");
	zm_craftables::include_zombie_craftable("elemental_staff_water");
	zm_craftables::include_zombie_craftable("elemental_staff_lightning");
	zm_craftables::include_zombie_craftable("gramophone");
}

/*
	Name: register_clientfields
	Namespace: zm_tomb_craftables
	Checksum: 0x9A15B3B8
	Offset: 0x838
	Size: 0xBCC
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	bits = 1;
	clientfield::register("world", "piece_quadrotor_zm_body", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "piece_quadrotor_zm_brain", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "piece_quadrotor_zm_engine", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "air_staff.piece_zm_gem", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "air_staff.piece_zm_ustaff", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "air_staff.piece_zm_mstaff", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "air_staff.piece_zm_lstaff", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.air_staff.visible", 21000, bits, "int", undefined, 0, 0);
	clientfield::register("world", "fire_staff.piece_zm_gem", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "fire_staff.piece_zm_ustaff", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "fire_staff.piece_zm_mstaff", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "fire_staff.piece_zm_lstaff", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.fire_staff.visible", 21000, bits, "int", undefined, 0, 0);
	clientfield::register("world", "lightning_staff.piece_zm_gem", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "lightning_staff.piece_zm_ustaff", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "lightning_staff.piece_zm_mstaff", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "lightning_staff.piece_zm_lstaff", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.lightning_staff.visible", 21000, bits, "int", undefined, 0, 0);
	clientfield::register("world", "water_staff.piece_zm_gem", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "water_staff.piece_zm_ustaff", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "water_staff.piece_zm_mstaff", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "water_staff.piece_zm_lstaff", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.water_staff.visible", 21000, bits, "int", undefined, 0, 0);
	clientfield::register("world", "piece_record_zm_player", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "piece_record_zm_vinyl_master", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "piece_record_zm_vinyl_air", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "piece_record_zm_vinyl_water", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "piece_record_zm_vinyl_fire", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "piece_record_zm_vinyl_lightning", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	bits = getminbitcountfornum(5);
	clientfield::register("world", "air_staff.holder", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "fire_staff.holder", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "lightning_staff.holder", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "water_staff.holder", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	bits = getminbitcountfornum(5);
	clientfield::register("world", "fire_staff.quest_state", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	clientfield::register("world", "air_staff.quest_state", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	clientfield::register("world", "lightning_staff.quest_state", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	clientfield::register("world", "water_staff.quest_state", 21000, bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	clientfield::register("clientuimodel", "zmInventory.show_maxis_drone_parts_widget", 21000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.current_gem", 21000, getminbitcountfornum(5), "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.show_musical_parts_widget", 21000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "hudItems.showDpadRight_Drone", 21000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "hudItems.showDpadLeft_Staff", 21000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "hudItems.dpadLeftAmmo", 21000, 2, "int", undefined, 0, 0);
}

