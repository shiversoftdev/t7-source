// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_castle;

#namespace zm_castle_zones;

/*
	Name: init
	Namespace: zm_castle_zones
	Checksum: 0xD893DA8A
	Offset: 0x838
	Size: 0x9CC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.custom_spawner_entry["crawl"] = &function_48cfc7df;
	level flag::init("always_on");
	level flag::set("always_on");
	level thread function_e9579b3e();
	zm_zonemgr::zone_init("zone_boss_arena");
	zm_zonemgr::zone_init("zone_past_laboratory");
	zm_zonemgr::add_adjacent_zone("zone_v10_pad", "zone_v10_pad_door", "castle_teleporter_used");
	zm_zonemgr::add_adjacent_zone("zone_v10_pad_door", "zone_v10_pad_exterior", "castle_teleporter_used");
	zm_zonemgr::add_adjacent_zone("zone_start", "zone_tram_high", "always_on");
	zm_zonemgr::add_adjacent_zone("zone_start", "zone_tram_to_gatehouse", "connect_start_to_tram2gatehouse");
	zm_zonemgr::add_adjacent_zone("zone_tram_high", "zone_tram_to_subclocktower_bot", "connect_start_to_subclocktower");
	zm_zonemgr::add_adjacent_zone("zone_tram_high", "zone_undercroft_jail", "connect_start_to_undercroft");
	zm_zonemgr::add_adjacent_zone("zone_tram_to_subclocktower", "zone_tram_to_subclocktower_top", "activate_tram_to_subclocktower");
	zm_zonemgr::add_adjacent_zone("zone_tram_to_subclocktower", "zone_tram_to_subclocktower_bot", "activate_tram_to_subclocktower");
	zm_zonemgr::add_adjacent_zone("zone_tram_to_subclocktower_top", "zone_courtyard", "connect_subclocktower_to_courtyard");
	zm_zonemgr::add_adjacent_zone("zone_clocktower", "zone_courtyard_edge", "activate_courtyard");
	zm_zonemgr::add_adjacent_zone("zone_clocktower", "zone_clocktower_rooftop", "activate_courtyard");
	zm_zonemgr::add_zone_flags("connect_subclocktower_to_courtyard", "activate_courtyard");
	zm_zonemgr::add_zone_flags("connect_courtyard_to_greathall_upper", "activate_courtyard");
	zm_zonemgr::add_zone_flags("connect_courtyard_to_rooftop", "activate_courtyard");
	zm_zonemgr::add_zone_flags("connect_greathall_to_courtyard", "activate_courtyard");
	zm_zonemgr::add_zone_flags("connect_start_to_subclocktower", "activate_tram_to_subclocktower");
	zm_zonemgr::add_zone_flags("connect_subclocktower_to_courtyard", "activate_tram_to_subclocktower");
	zm_zonemgr::add_adjacent_zone("zone_courtyard", "zone_courtyard_edge", "activate_courtyard");
	zm_zonemgr::add_adjacent_zone("zone_courtyard", "zone_clocktower_rooftop", "activate_courtyard");
	zm_zonemgr::add_adjacent_zone("zone_courtyard", "zone_great_hall", "connect_greathall_to_courtyard");
	zm_zonemgr::add_adjacent_zone("zone_courtyard_edge", "zone_great_hall_upper_left", "connect_courtyard_to_greathall_upper");
	zm_zonemgr::add_adjacent_zone("zone_courtyard", "zone_great_hall_upper", "connect_courtyard_to_greathall_upper");
	zm_zonemgr::add_zone_flags("connect_armory_to_rooftop", "activate_courtyard");
	zm_zonemgr::add_adjacent_zone("zone_gatehouse", "zone_lower_gatehouse", "buyable_dropdown_gatehouse_to_lowercourtyard");
	zm_zonemgr::add_adjacent_zone("zone_tram_to_gatehouse", "zone_lower_gatehouse", "connect_gatehouse_area");
	zm_zonemgr::add_zone_flags("connect_start_to_tram2gatehouse", "connect_gatehouse_area");
	zm_zonemgr::add_zone_flags("connect_gatehouse_to_lowercourtyard", "connect_gatehouse_area");
	zm_zonemgr::add_zone_flags("buyable_dropdown_gatehouse_to_lowercourtyard", "connect_gatehouse_area");
	zm_zonemgr::add_adjacent_zone("zone_gatehouse", "zone_lower_courtyard_upper", "connect_lower_courtyard");
	zm_zonemgr::add_zone_flags("connect_gatehouse_to_lowercourtyard", "connect_lower_courtyard");
	zm_zonemgr::add_zone_flags("connect_lowercourtyard_to_livingquarters", "connect_lower_courtyard");
	zm_zonemgr::add_zone_flags("connect_lowercoutryard_to_rooftop", "connect_lower_courtyard");
	zm_zonemgr::add_zone_flags("connect_lowercourtyard_to_undercroft", "connect_lower_courtyard");
	zm_zonemgr::add_adjacent_zone("zone_lower_courtyard", "zone_lower_courtyard_upper", "connect_lower_courtyard");
	zm_zonemgr::add_adjacent_zone("zone_lower_courtyard_upper", "zone_ramparts", "power_on");
	zm_zonemgr::add_adjacent_zone("zone_lower_courtyard", "zone_lower_gatehouse", "connect_gatehouse_to_lowercourtyard");
	zm_zonemgr::add_adjacent_zone("zone_lower_courtyard_upper", "zone_living_quarters", "connect_lowercourtyard_to_livingquarters");
	zm_zonemgr::add_adjacent_zone("zone_lower_courtyard_upper", "zone_lower_courtyard_back", "connect_lower_courtyard");
	zm_zonemgr::add_adjacent_zone("zone_lower_courtyard", "zone_lower_courtyard_back", "connect_lower_courtyard");
	zm_zonemgr::add_adjacent_zone("zone_lower_courtyard_back", "zone_undercroft_pap_hall", "connect_lowercourtyard_to_undercroft");
	zm_zonemgr::add_adjacent_zone("zone_great_hall_upper", "zone_armory", "connect_greathall_to_armory");
	zm_zonemgr::add_adjacent_zone("zone_great_hall", "zone_great_hall_upper_left", "activate_greathall");
	zm_zonemgr::add_adjacent_zone("zone_great_hall", "zone_great_hall_upper", "activate_greathall");
	zm_zonemgr::add_zone_flags("connect_greathall_to_armory", "activate_greathall");
	zm_zonemgr::add_zone_flags("connect_greathall_to_undercroft", "activate_greathall");
	zm_zonemgr::add_zone_flags("connect_courtyard_to_greathall_upper", "activate_greathall");
	zm_zonemgr::add_adjacent_zone("zone_armory", "zone_armory_back", "activate_armory");
	zm_zonemgr::add_adjacent_zone("zone_armory", "zone_living_quarters", "connect_armory_to_livingquarters");
	zm_zonemgr::add_zone_flags("connect_armory_to_livingquarters", "activate_armory");
	zm_zonemgr::add_zone_flags("connect_greathall_to_armory", "activate_armory");
	zm_zonemgr::add_adjacent_zone("zone_rooftop", "zone_ramparts", "power_on");
	zm_zonemgr::add_adjacent_zone("zone_rooftop", "zone_clocktower_rooftop", "power_on");
	zm_zonemgr::add_adjacent_zone("zone_rooftop", "zone_armory_back", "power_on");
	level thread function_8ead5cf5();
	zm_zonemgr::add_adjacent_zone("zone_undercroft_chapel", "zone_great_hall", "connect_greathall_to_undercroft");
	zm_zonemgr::add_adjacent_zone("zone_undercroft", "zone_undercroft_lab", "connect_undercroft_to_undercroft_lab");
	zm_zonemgr::add_adjacent_zone("zone_undercroft", "zone_undercroft_chapel", "activate_undercroft");
	zm_zonemgr::add_adjacent_zone("zone_undercroft", "zone_undercroft_jail", "activate_undercroft");
	zm_zonemgr::add_adjacent_zone("zone_undercroft", "zone_undercroft_pap", "activate_undercroft");
	zm_zonemgr::add_adjacent_zone("zone_undercroft_jail", "zone_undercroft_pap", "activate_undercroft");
	zm_zonemgr::add_adjacent_zone("zone_undercroft_pap", "zone_undercroft_pap_hall", "activate_undercroft");
	zm_zonemgr::add_zone_flags("connect_lowercourtyard_to_undercroft", "activate_undercroft");
	zm_zonemgr::add_zone_flags("connect_greathall_to_undercroft", "activate_undercroft");
}

/*
	Name: function_15166300
	Namespace: zm_castle_zones
	Checksum: 0x27FFAFC7
	Offset: 0x1210
	Size: 0xC4
	Parameters: 0
	Flags: None
*/
function function_15166300()
{
	var_49fa7253 = 0;
	var_565450eb = 0;
	var_565450eb = zombie_utility::get_current_zombie_count();
	var_32218d0b = min(level.activeplayers.size * 5, 10);
	var_49fa7253 = var_32218d0b - var_565450eb;
	var_e1bef548 = level.zombie_ai_limit - var_565450eb;
	var_49fa7253 = min(var_49fa7253, var_e1bef548);
	return var_49fa7253;
}

/*
	Name: function_e9579b3e
	Namespace: zm_castle_zones
	Checksum: 0xF001CDD4
	Offset: 0x12E0
	Size: 0x1A6
	Parameters: 0
	Flags: Linked
*/
function function_e9579b3e()
{
	level flag::wait_till("zones_initialized");
	var_874b8995 = struct::get_array("zone_start_spawners", "targetname");
	foreach(e_spawner in var_874b8995)
	{
		if(e_spawner.script_int === 1)
		{
			e_spawner.is_enabled = 0;
		}
	}
	while(true)
	{
		level waittill(#"end_of_round");
		if(level.round_number >= 5)
		{
			break;
		}
	}
	foreach(e_spawner in var_874b8995)
	{
		if(e_spawner.script_int === 1)
		{
			e_spawner.is_enabled = 1;
		}
	}
}

/*
	Name: function_8ead5cf5
	Namespace: zm_castle_zones
	Checksum: 0xE8C5082E
	Offset: 0x1490
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function function_8ead5cf5()
{
	var_405e4f24 = struct::get_array("zone_wizards_tower_spawners", "targetname");
	foreach(s_spawner in var_405e4f24)
	{
		if(s_spawner.script_noteworthy === "spawn_location")
		{
			s_spawner.script_noteworthy = "riser_location";
		}
		s_spawner.targetname = "zone_rooftop_spawners";
		s_spawner.zone_name = "zone_rooftop";
		s_spawner.is_enabled = 1;
		array::add(level.zones["zone_rooftop"].a_loc_types["zombie_location"], s_spawner, 0);
	}
	level thread function_affecb53(var_405e4f24);
}

/*
	Name: function_affecb53
	Namespace: zm_castle_zones
	Checksum: 0x7E01306
	Offset: 0x1600
	Size: 0x19A
	Parameters: 1
	Flags: Linked
*/
function function_affecb53(var_405e4f24)
{
	level flag::wait_till("zones_initialized");
	while(true)
	{
		level flag::wait_till("tesla_coil_on");
		foreach(e_spawner in var_405e4f24)
		{
			if(e_spawner.script_int === 1)
			{
				e_spawner.is_enabled = 0;
			}
		}
		level flag::wait_till_clear("tesla_coil_on");
		foreach(e_spawner in var_405e4f24)
		{
			if(e_spawner.script_int === 1)
			{
				e_spawner.is_enabled = 1;
			}
		}
	}
}

/*
	Name: function_48cfc7df
	Namespace: zm_castle_zones
	Checksum: 0x59E55E6D
	Offset: 0x17A8
	Size: 0x236
	Parameters: 1
	Flags: Linked
*/
function function_48cfc7df(spot)
{
	self endon(#"death");
	self.var_2be9fa75 = 1;
	if(isdefined(self.mdl_anchor))
	{
		self.mdl_anchor delete();
	}
	self.mdl_anchor = util::spawn_model("tag_origin", self.origin, self.angles);
	self ghost();
	if(!isdefined(spot.angles))
	{
		spot.angles = (0, 0, 0);
	}
	self thread anchor_delete_watcher();
	self.mdl_anchor moveto(spot.origin, 0.05);
	self.mdl_anchor rotateto(spot.angles, 0.05);
	self.mdl_anchor waittill(#"movedone");
	wait(0.05);
	if(!isdefined(self) || !isdefined(self.mdl_anchor))
	{
		return;
	}
	self.create_eyes = 1;
	self show();
	if(isdefined(self.mdl_anchor))
	{
		if(isdefined(spot.scriptbundlename))
		{
			self.mdl_anchor scene::play(spot.scriptbundlename, self);
		}
		else
		{
			self.mdl_anchor scene::play("cin_zm_dlc1_zombie_undercroft_spawn_1", self);
		}
	}
	self.var_2be9fa75 = 0;
	self thread function_27a6dd5f();
	self notify(#"risen", spot.script_string);
}

/*
	Name: function_27a6dd5f
	Namespace: zm_castle_zones
	Checksum: 0x8C3C5793
	Offset: 0x19E8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_27a6dd5f()
{
	self endon(#"death");
	util::wait_network_frame();
	if(isdefined(self.mdl_anchor))
	{
		self.mdl_anchor delete();
	}
}

/*
	Name: anchor_delete_watcher
	Namespace: zm_castle_zones
	Checksum: 0xA6CB66B5
	Offset: 0x1A40
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function anchor_delete_watcher()
{
	self waittill(#"death");
	if(isdefined(self.mdl_anchor))
	{
		wait(0.05);
		if(isdefined(self.mdl_anchor))
		{
			self.mdl_anchor delete();
		}
	}
}

