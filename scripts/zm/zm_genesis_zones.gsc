// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis_ffotd;
#using scripts\zm\zm_genesis_util;

#namespace zm_island_zones;

/*
	Name: __init__sytem__
	Namespace: zm_island_zones
	Checksum: 0x9D789247
	Offset: 0xBC8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_zones", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_island_zones
	Checksum: 0x8EDD9D66
	Offset: 0xC10
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level flag::init("activate_lower_asylum");
	level flag::init("activate_upper_asylum");
}

/*
	Name: __main__
	Namespace: zm_island_zones
	Checksum: 0xD4886B20
	Offset: 0xC60
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level.zones = [];
	level.zone_manager_init_func = &function_19a0be33;
	level.zone_occupied_func = &zm_genesis_ffotd::function_dce2d8a9;
	init_zones[0] = "start_zone";
	level thread zm_zonemgr::manage_zones(init_zones);
	level.player_out_of_playable_area_monitor_callback = &player_out_of_playable_area_override;
	level thread function_6b91d71();
}

/*
	Name: player_out_of_playable_area_override
	Namespace: zm_island_zones
	Checksum: 0x578AE467
	Offset: 0xD08
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function player_out_of_playable_area_override()
{
	if(isdefined(self.b_teleporting) && self.b_teleporting || (isdefined(self.b_teleported) && self.b_teleported) || (isdefined(self.var_5aef0317) && self.var_5aef0317) || (isdefined(self.is_flung) && self.is_flung))
	{
		return false;
	}
	b_result = zm_genesis_ffotd::function_d51867e();
	if(b_result)
	{
		return false;
	}
	return true;
}

/*
	Name: function_19a0be33
	Namespace: zm_island_zones
	Checksum: 0x23DCAB82
	Offset: 0xDA8
	Size: 0xF1C
	Parameters: 0
	Flags: Linked
*/
function function_19a0be33()
{
	level flag::init("always_on", 1);
	zm_zonemgr::zone_init("apothicon_interior_zone", 0);
	zm_zonemgr::zone_init("samanthas_room_zone");
	zm_zonemgr::add_adjacent_zone("start_zone", "start_power_zone", "always_on");
	zm_zonemgr::add_adjacent_zone("start_left_path_zone", "start_zone", "connect_start_to_left");
	zm_zonemgr::add_adjacent_zone("start_right_path_zone", "start_zone", "connect_start_to_right");
	level thread zm_genesis_util::function_42108922("start_left_path_zone", "connect_generator_to_trenches");
	level thread zm_genesis_util::function_42108922("start_right_path_zone", "connect_temple_to_temple_stairs");
	zm_zonemgr::add_adjacent_zone("zm_tomb_landing_zone", "zm_tomb_trench_zone", "activate_trenches");
	zm_zonemgr::add_adjacent_zone("zm_tomb_trench_zone", "zm_tomb_trench2_zone", "activate_trenches");
	zm_zonemgr::add_adjacent_zone("zm_tomb_trench2_zone", "zm_tomb_trench_center_zone", "connect_generator_to_trenches");
	zm_zonemgr::add_adjacent_zone("zm_tomb_trench2_zone", "zm_tomb_generator_zone", "connect_generator_to_trenches");
	zm_zonemgr::add_adjacent_zone("zm_tomb_generator_zone", "zm_tomb_trench_center_zone", "activate_ruins");
	zm_zonemgr::add_adjacent_zone("zm_tomb_trench_center_zone", "zm_tomb_footprint_zone", "activate_ruins");
	zm_zonemgr::add_adjacent_zone("zm_tomb_footprint_zone", "zm_tomb_trench_prison_zone", "activate_ruins");
	zm_zonemgr::add_adjacent_zone("zm_tomb_trench_prison_zone", "zm_tomb_ruins2_zone", "activate_ruins");
	zm_zonemgr::add_adjacent_zone("zm_tomb_generator_zone", "zm_tomb_ruins2_zone", "activate_ruins");
	zm_zonemgr::add_adjacent_zone("zm_tomb_ruins2_zone", "zm_tomb_ruins_zone", "activate_ruins");
	zm_zonemgr::add_adjacent_zone("zm_tomb_trench_prison_zone", "zm_prison_zone", "power_on1");
	zm_zonemgr::add_adjacent_zone("zm_prison_zone", "zm_prison_inner2_zone", "activate_cellblock");
	zm_zonemgr::add_adjacent_zone("zm_prison_inner2_zone", "zm_prison_inner_zone", "activate_cellblock");
	zm_zonemgr::add_adjacent_zone("zm_prison_inner_zone", "zm_prison_power_zone", "activate_cellblock");
	zm_zonemgr::add_adjacent_zone("zm_prison_mess_zone", "zm_prison_mess_hall_zone", "activate_cellblock_pad");
	zm_zonemgr::add_adjacent_zone("zm_prison_mess_hall_zone", "zm_prison_inner_zone", "connect_cellblock_to_messhall");
	zm_zonemgr::add_adjacent_zone("zm_tomb_ruins_zone", "zm_tomb_ruins_interior_zone", "connect_ruins_to_inner_ruins");
	zm_zonemgr::add_adjacent_zone("zm_tomb_ruins_interior_zone", "zm_tomb_ruins_tunnel_zone", "activate_cellblock");
	zm_zonemgr::add_adjacent_zone("zm_tomb_ruins_tunnel_zone", "zm_prison_ruins_interior_zone", "activate_cellblock");
	zm_zonemgr::add_adjacent_zone("zm_prison_ruins_interior_zone", "zm_prison_inner2_zone", "activate_ruins_inner");
	zm_zonemgr::add_zone_flags("activate_asylum_kitchen", "activate_cellblock_pad");
	zm_zonemgr::add_zone_flags("connect_cellblock_to_messhall", "activate_cellblock");
	zm_zonemgr::add_zone_flags("connect_ruins_to_inner_ruins", "activate_cellblock");
	zm_zonemgr::add_zone_flags("connect_generator_to_trenches", "activate_ruins");
	zm_zonemgr::add_zone_flags("connect_ruins_to_inner_ruins", "activate_ruins");
	zm_zonemgr::add_zone_flags("power_on1", "activate_ruins");
	zm_zonemgr::add_zone_flags("connect_start_to_left", "activate_trenches");
	zm_zonemgr::add_zone_flags("connect_generator_to_trenches", "activate_trenches");
	zm_zonemgr::add_zone_flags("connect_cellblock_to_messhall", "activate_ruins_inner");
	zm_zonemgr::add_zone_flags("connect_ruins_to_inner_ruins", "activate_ruins_inner");
	level thread zm_genesis_util::function_42108922("zm_prison_mess_zone", "connect_asylum_kitchen_to_upstairs");
	level thread zm_genesis_util::function_42108922("zm_prison_mess_hall_zone", "connect_asylum_kitchen_to_upstairs");
	zm_zonemgr::add_adjacent_zone("zm_temple_zone", "zm_temple2_zone", "activate_temple");
	zm_zonemgr::add_adjacent_zone("zm_temple2_zone", "zm_temple_stairs_zone", "connect_temple_to_temple_stairs");
	zm_zonemgr::add_adjacent_zone("zm_temple_stairs_zone", "zm_temple_interior_zone", "connect_temple_to_temple_stairs");
	zm_zonemgr::add_adjacent_zone("zm_temple_interior_zone", "zm_temple_box_zone", "activate_temple_interior");
	zm_zonemgr::add_adjacent_zone("zm_temple_box_zone", "zm_temple_undercroft_zone", "activate_temple_interior");
	zm_zonemgr::add_adjacent_zone("zm_temple_undercroft_zone", "zm_temple_undercroft2_zone", "activate_temple_interior");
	zm_zonemgr::add_adjacent_zone("zm_temple_undercroft2_zone", "zm_theater_hallway_zone", "activate_temple_interior");
	zm_zonemgr::add_adjacent_zone("zm_temple_undercroft2_zone", "zm_castle_undercroft_hallway_zone", "connect_undercroft_to_temple");
	zm_zonemgr::add_adjacent_zone("zm_temple_undercroft2_zone", "zm_castle_undercroft_hallway2_zone", "connect_undercroft_to_temple");
	zm_zonemgr::add_adjacent_zone("zm_castle_undercroft_hallway_zone", "zm_castle_undercroft_zone", "activate_undercroft");
	zm_zonemgr::add_adjacent_zone("zm_castle_undercroft_hallway2_zone", "zm_castle_undercroft_zone", "activate_undercroft");
	zm_zonemgr::add_adjacent_zone("zm_castle_undercroft_zone", "zm_castle_power_zone", "activate_undercroft");
	zm_zonemgr::add_adjacent_zone("zm_castle_undercroft_zone", "zm_castle_undercroft_airlock_zone", "connect_undercroft_to_theater");
	zm_zonemgr::add_adjacent_zone("zm_castle_undercroft_airlock_zone", "zm_theater_projection_zone", "connect_undercroft_to_theater");
	zm_zonemgr::add_adjacent_zone("zm_theater_hallway_zone", "zm_theater_hallway_airlock_zone", "connect_undercroft_to_foyer");
	zm_zonemgr::add_adjacent_zone("zm_theater_hallway_airlock_zone", "zm_theater_foyer_zone", "connect_undercroft_to_foyer");
	zm_zonemgr::add_adjacent_zone("zm_theater_projection_zone", "zm_theater_balcony_zone", "activate_theater");
	zm_zonemgr::add_adjacent_zone("zm_theater_balcony_zone", "zm_theater_jump_zone", "activate_theater");
	zm_zonemgr::add_adjacent_zone("zm_theater_balcony_zone", "zm_theater_foyer_zone", "activate_theater");
	zm_zonemgr::add_adjacent_zone("zm_theater_foyer_zone", "zm_theater_zone", "activate_theater");
	zm_zonemgr::add_adjacent_zone("zm_theater_zone", "zm_theater_stage_zone", "activate_theater");
	zm_zonemgr::add_zone_flags("connect_start_to_right", "activate_temple");
	zm_zonemgr::add_zone_flags("connect_temple_to_temple_stairs", "activate_temple");
	zm_zonemgr::add_zone_flags("connect_undercroft_to_temple", "activate_undercroft");
	zm_zonemgr::add_zone_flags("connect_undercroft_to_theater", "activate_undercroft");
	zm_zonemgr::add_zone_flags("connect_undercroft_to_foyer", "activate_undercroft");
	zm_zonemgr::add_zone_flags("connect_asylum_downstairs_to_upstairs", "activate_theater");
	zm_zonemgr::add_zone_flags("connect_undercroft_to_theater", "activate_theater");
	zm_zonemgr::add_zone_flags("connect_undercroft_to_foyer", "activate_theater");
	zm_zonemgr::add_zone_flags("connect_undercroft_to_temple", "activate_temple_interior");
	zm_zonemgr::add_zone_flags("connect_temple_to_temple_stairs", "activate_temple_interior");
	zm_zonemgr::add_zone_flags("connect_undercroft_to_foyer", "activate_temple_interior");
	/#
		level thread zm_genesis_util::function_d8db939b("");
	#/
	zm_zonemgr::add_adjacent_zone("zm_asylum_kitchen_landing_zone", "zm_asylum_kitchen_zone", "activate_asylum_kitchen");
	zm_zonemgr::add_adjacent_zone("zm_asylum_downstairs_zone", "zm_asylum_downstairs_landing_zone", "activate_lower_asylum");
	zm_zonemgr::add_adjacent_zone("zm_asylum_downstairs_zone", "zm_asylum_courtyard_zone", "connect_asylum_downstairs_to_upstairs");
	zm_zonemgr::add_adjacent_zone("zm_asylum_power_room_zone", "zm_asylum_courtyard_stairs_zone", "activate_asylum");
	zm_zonemgr::add_adjacent_zone("zm_asylum_courtyard_zone", "zm_asylum_courtyard_stairs_zone", "activate_asylum");
	zm_zonemgr::add_adjacent_zone("zm_asylum_courtyard_zone", "zm_asylum_power_zone", "activate_asylum");
	zm_zonemgr::add_adjacent_zone("zm_asylum_kitchen2_zone", "zm_asylum_kitchen_zone", "activate_asylum_kitchen");
	zm_zonemgr::add_adjacent_zone("zm_asylum_kitchen2_zone", "zm_asylum_upstairs_zone", "connect_asylum_kitchen_to_upstairs");
	zm_zonemgr::add_adjacent_zone("zm_asylum_upstairs_zone", "zm_asylum_balcony_zone", "activate_upper_asylum");
	zm_zonemgr::add_adjacent_zone("zm_asylum_upstairs_zone", "zm_asylum_interior_stairs_zone", "connect_asylum_downstairs_to_upstairs");
	zm_zonemgr::add_adjacent_zone("zm_asylum_downstairs_zone", "zm_asylum_interior_stairs_zone", "activate_lower_asylum");
	zm_zonemgr::add_adjacent_zone("zm_asylum_bridge_zone", "zm_asylum_kitchen_zone", "connect_asylum_kitchen_to_upstairs", 1);
	zm_zonemgr::add_adjacent_zone("zm_asylum_bridge_zone", "zm_asylum_power_room_zone", "activate_asylum", 1);
	zm_zonemgr::add_zone_flags("connect_undercroft_to_theater", "activate_asylum");
	zm_zonemgr::add_zone_flags("connect_asylum_kitchen_to_upstairs", array("activate_asylum", "activate_upper_asylum"));
	zm_zonemgr::add_zone_flags("connect_asylum_downstairs_to_upstairs", array("activate_asylum", "activate_lower_asylum", "activate_upper_asylum"));
	zm_zonemgr::add_zone_flags("activate_theater", "activate_lower_asylum");
	zm_zonemgr::add_zone_flags("connect_cellblock_to_messhall", "activate_asylum_kitchen");
	zm_zonemgr::add_zone_flags("connect_asylum_kitchen_to_upstairs", "activate_asylum_kitchen");
	zm_zonemgr::add_adjacent_zone("zm_prototype_apothicon_zone", "zm_prototype_outside_zone", "connect_prototype_upstairs_to_outside");
	zm_zonemgr::add_adjacent_zone("zm_prototype_balcony_zone", "zm_prototype_outside_zone", "connect_prototype_upstairs_to_outside");
	zm_zonemgr::add_adjacent_zone("zm_prototype_balcony_zone", "zm_prototype_start_zone", "connect_prototype_start_to_upstairs");
	zm_zonemgr::add_adjacent_zone("zm_prototype_box_zone", "zm_prototype_upstairs_zone", "connect_prototype_start_to_upstairs");
	zm_zonemgr::add_adjacent_zone("zm_prototype_start_zone", "zm_prototype_box_zone", "open_portals");
	zm_zonemgr::add_adjacent_zone("zm_prototype_start_zone", "zm_prototype_upstairs_zone", "connect_prototype_start_to_upstairs");
	level thread zm_genesis_util::function_42108922("apothicon_interior_zone", "connect_prototype_upstairs_to_outside");
	zm_zonemgr::add_adjacent_zone("dark_arena_zone", "dark_arena2_zone", "test_activate_arena");
	/#
		level thread zm_genesis_util::function_d8db939b("");
	#/
	level thread function_fb8b5806();
}

/*
	Name: function_6b91d71
	Namespace: zm_island_zones
	Checksum: 0x4B0F402
	Offset: 0x1CD0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_6b91d71()
{
	var_25778c2d = getnodearray("blocker_traversal", "script_noteworthy");
	array::thread_all(var_25778c2d, &function_9ce5da3b);
}

/*
	Name: function_9ce5da3b
	Namespace: zm_island_zones
	Checksum: 0x29EF9FBB
	Offset: 0x1D30
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_9ce5da3b()
{
	/#
		assert(isdefined(self.script_flag), ("" + self.origin) + "");
	#/
	if(self.script_string === "start_disabled")
	{
		unlinktraversal(self);
	}
	level flag::wait_till(self.script_flag);
	if(self.script_string === "start_disabled")
	{
		linktraversal(self);
		return;
	}
	unlinktraversal(self);
}

/*
	Name: function_fb8b5806
	Namespace: zm_island_zones
	Checksum: 0xA3C85703
	Offset: 0x1E00
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function function_fb8b5806()
{
	while(true)
	{
		level flag::wait_till("test_activate_arena");
		zm_genesis_util::function_342295d8("dark_arena2_zone");
		zm_genesis_util::function_342295d8("dark_arena_zone");
		level flag::wait_till_clear("test_activate_arena");
		zm_genesis_util::function_342295d8("dark_arena_zone", 0);
		zm_genesis_util::function_342295d8("dark_arena2_zone", 0);
	}
}

