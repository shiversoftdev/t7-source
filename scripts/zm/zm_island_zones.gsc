// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_spiders;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_island_skullweapon_quest;
#using scripts\zm\zm_island_transport;
#using scripts\zm\zm_island_vo;

#namespace zm_island_zones;

/*
	Name: __init__sytem__
	Namespace: zm_island_zones
	Checksum: 0x961B648D
	Offset: 0xB58
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_zones", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_island_zones
	Checksum: 0x9507A86D
	Offset: 0xB98
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "vine_door_play_fx", 9000, 1, "int");
	scene::add_scene_func("p7_fxanim_zm_island_vine_gate_bundle", &function_6ed87461, "init");
}

/*
	Name: main
	Namespace: zm_island_zones
	Checksum: 0xCF21DBB6
	Offset: 0xC08
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level.zones = [];
	level.zone_manager_init_func = &function_45a8888c;
	init_zones[0] = "zone_start_water";
	level thread zm_zonemgr::manage_zones(init_zones);
}

/*
	Name: function_45a8888c
	Namespace: zm_island_zones
	Checksum: 0xE91A074
	Offset: 0xC68
	Size: 0x8EC
	Parameters: 0
	Flags: Linked
*/
function function_45a8888c()
{
	level flag::init("always_on");
	level flag::set("always_on");
	zm_zonemgr::add_adjacent_zone("zone_start_water", "zone_start", "connect_start_water_to_start");
	zm_zonemgr::add_adjacent_zone("zone_start", "zone_start_2", "connect_start_to_start_2");
	zm_zonemgr::add_adjacent_zone("zone_start_2", "zone_jungle", "connect_start_2_to_jungle");
	zm_zonemgr::add_adjacent_zone("zone_start_2", "zone_swamp", "connect_start_2_to_swamp");
	zm_zonemgr::add_adjacent_zone("zone_jungle", "zone_jungle_lab", "connect_jungle_to_jungle_lab");
	zm_zonemgr::add_adjacent_zone("zone_jungle", "zone_crash_site", "connect_jungle_to_crash_site");
	zm_zonemgr::add_adjacent_zone("zone_crash_site", "zone_crash_site_2", "connect_jungle_to_crash_site");
	zm_zonemgr::add_adjacent_zone("zone_swamp", "zone_swamp_2", "connect_start_2_to_swamp");
	zm_zonemgr::add_adjacent_zone("zone_swamp_2", "zone_swamp_lab", "connect_swamp_to_swamp_lab");
	zm_zonemgr::add_adjacent_zone("zone_swamp_2", "zone_swamp", "connect_swamp_to_swamp_lab");
	zm_zonemgr::add_adjacent_zone("zone_swamp_2", "zone_ruins", "connect_swamp_to_ruins");
	zm_zonemgr::add_adjacent_zone("zone_ruins", "zone_swamp_lab_dropoff", "connect_swamp_to_swamp_lab", 1);
	zm_zonemgr::add_adjacent_zone("zone_ruins", "zone_ruins_underground_stairs", "connect_ruins_to_ruins_underground");
	zm_zonemgr::add_adjacent_zone("zone_ruins_underground_stairs", "zone_ruins_underground", "connect_ruins_to_ruins_underground");
	zm_zonemgr::add_adjacent_zone("zone_swamp_lab", "zone_meteor_site", "connect_swamp_lab_to_meteor_site");
	zm_zonemgr::add_adjacent_zone("zone_swamp_lab", "zone_bunker_exterior", "connect_swamp_lab_to_bunker_exterior");
	zm_zonemgr::add_adjacent_zone("zone_swamp_lab", "zone_swamp_lab_inside", "connect_swamp_lab_to_swamp_lab_inside");
	zm_zonemgr::add_adjacent_zone("zone_swamp_lab_underneath", "zone_swamp_lab", "connect_swamp_lab_to_bunker_exterior");
	zm_zonemgr::add_adjacent_zone("zone_swamp_lab_underneath", "zone_swamp_lab", "connect_swamp_to_swamp_lab");
	zm_zonemgr::add_adjacent_zone("zone_swamp_lab_underneath", "zone_swamp_lab_underneath_2", "connect_swamp_to_swamp_lab");
	zm_zonemgr::add_adjacent_zone("zone_swamp_lab_underneath", "zone_swamp_lab_underneath_2", "connect_swamp_lab_to_bunker_exterior");
	zm_zonemgr::add_adjacent_zone("zone_swamp_lab_dropoff", "zone_swamp_lab_underneath", "connect_swamp_lab_to_bunker_exterior");
	zm_zonemgr::add_adjacent_zone("zone_swamp_lab_dropoff", "zone_swamp_lab_underneath", "connect_swamp_to_swamp_lab");
	zm_zonemgr::add_adjacent_zone("zone_swamp_lab_underneath_2", "zone_meteor_site", "connect_swamp_lab_to_meteor_site");
	zm_zonemgr::add_adjacent_zone("zone_meteor_site", "zone_meteor_site_2", "connect_swamp_lab_to_meteor_site");
	zm_zonemgr::add_adjacent_zone("zone_jungle_lab", "zone_bunker_exterior", "connect_jungle_lab_to_bunker_exterior");
	zm_zonemgr::add_adjacent_zone("zone_jungle_lab", "zone_jungle_lab_upper", "connect_jungle_lab_to_jungle_lab_upper");
	zm_zonemgr::add_adjacent_zone("zone_jungle_lab", "zone_spider_lair", "connect_jungle_lab_to_spider_lair");
	zm_zonemgr::add_adjacent_zone("zone_jungle_lab_upper", "zone_jungle_lab_secret_room", "connect_jungle_lab_to_jungle_lab_upper");
	zm_zonemgr::add_adjacent_zone("zone_spider_lair", "zone_spider_boss", "connect_spider_lair_to_spider_boss");
	zm_zonemgr::add_adjacent_zone("zone_spider_boss", "zone_spider_boss_after", "spider_queen_dead");
	zm_zonemgr::add_adjacent_zone("zone_spider_boss_after", "zone_spider_lair", "spider_queen_dead");
	zm_zonemgr::add_adjacent_zone("zone_bunker_exterior", "zone_bunker_interior", "connect_bunker_exterior_to_bunker_interior");
	zm_zonemgr::add_adjacent_zone("zone_bunker_interior", "zone_bunker_interior_2", "connect_bunker_exterior_to_bunker_interior");
	zm_zonemgr::add_adjacent_zone("zone_bunker_interior", "zone_bunker_interior_elevator", "connect_bunker_exterior_to_bunker_interior");
	zm_zonemgr::add_adjacent_zone("zone_bunker_interior", "zone_bunker_upper_stairs", "connect_bunker_interior_to_bunker_upper");
	zm_zonemgr::add_adjacent_zone("zone_bunker_upper_stairs", "zone_bunker_upper", "connect_bunker_interior_to_bunker_upper");
	zm_zonemgr::add_adjacent_zone("zone_bunker_interior_2", "zone_bunker_pap_room", "connect_bunker_interior_to_bunker_pap_room");
	zm_zonemgr::add_adjacent_zone("zone_bunker_interior_2", "zone_bunker_left", "connect_bunker_interior_to_bunker_left");
	zm_zonemgr::add_adjacent_zone("zone_bunker_interior_2", "zone_bunker_right", "connect_bunker_interior_to_bunker_right");
	zm_zonemgr::add_adjacent_zone("zone_bunker_interior_2", "zone_operating_rooms", "connect_bunker_interior_to_operating_rooms");
	zm_zonemgr::add_adjacent_zone("zone_bunker_left", "zone_bunker_underwater_defend", "connect_bunker_left_to_underwater_defend");
	zm_zonemgr::add_adjacent_zone("zone_cliffside", "zone_bunker_left", "connect_cliffside_to_bunker_left");
	zm_zonemgr::add_adjacent_zone("zone_operating_rooms", "zone_flooded_bunker_right", "connect_operating_rooms_to_flooded_bunker_right");
	level thread zm_island_transport::function_3c997cb2("sewer");
	level thread zm_island_transport::function_3c997cb2("zip_line");
	level thread function_cd881f16();
	level thread function_2043d032();
	level thread function_87fe8382();
	a_t_doors = getentarray("zombie_door", "targetname");
	foreach(t_door in a_t_doors)
	{
		if(t_door.script_noteworthy === "vine_door")
		{
			t_door thread function_feb4ddde();
		}
	}
	var_7be3ca60 = getentarray("delete_door_model_when_finished", "script_noteworthy");
	array::thread_all(var_7be3ca60, &function_afc937e7);
	/#
		level thread function_8b7501aa();
	#/
}

/*
	Name: function_2043d032
	Namespace: zm_island_zones
	Checksum: 0x84971E72
	Offset: 0x1560
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_2043d032()
{
	zm_zonemgr::add_adjacent_zone("zone_bunker_prison", "zone_bunker_prison_entrance", "enable_zone_bunker_prison");
}

/*
	Name: function_87fe8382
	Namespace: zm_island_zones
	Checksum: 0x8470047D
	Offset: 0x1598
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function function_87fe8382()
{
	zm_zonemgr::add_adjacent_zone("zone_flooded_bunker_right", "zone_flooded_bunker_tunnel", "connect_flooded_bunker_right_to_flooded_tunnel");
	level waittill(#"zone_flooded_bunker_tunnel");
	level.zones["zone_flooded_bunker_tunnel"].is_spawning_allowed = 0;
}

/*
	Name: function_8b7501aa
	Namespace: zm_island_zones
	Checksum: 0x8AA96F3C
	Offset: 0x15F8
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function function_8b7501aa()
{
	/#
		level waittill(#"open_sesame");
		level flag::set("");
		level flag::set("");
		level flag::set("");
		level flag::set("");
		level thread zm_island_skullquest::function_3bd86987("");
		level flag::set("");
		level flag::set("");
		level flag::set("");
	#/
}

/*
	Name: function_6ed87461
	Namespace: zm_island_zones
	Checksum: 0xFE59C314
	Offset: 0x1718
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function function_6ed87461(a_ents)
{
	self.var_4165e349 = a_ents["fxanim_vine_gate"];
}

/*
	Name: function_feb4ddde
	Namespace: zm_island_zones
	Checksum: 0xAC275B0F
	Offset: 0x1740
	Size: 0x25A
	Parameters: 0
	Flags: Linked
*/
function function_feb4ddde()
{
	self endon(#"death");
	level flag::wait_till(self.script_flag);
	var_4c616d31 = self.target + "_vine";
	var_593fa92c = struct::get_array(var_4c616d31 + "_fx", "targetname");
	var_9649126c = struct::get_array(var_4c616d31, "targetname");
	foreach(s_scene in var_9649126c)
	{
		if(isdefined(s_scene) && isdefined(s_scene.var_4165e349))
		{
			s_scene.var_4165e349 clientfield::set("vine_door_play_fx", 1);
			wait(0.25);
			s_scene thread scene::play();
		}
	}
	foreach(var_52d911b7 in var_593fa92c)
	{
		level fx::play("vine_door_electric_source_open_fx", var_52d911b7.origin, var_52d911b7.angles, 2);
		level fx::play("vine_door_electric_source_idle_fx", var_52d911b7.origin, var_52d911b7.angles);
	}
}

/*
	Name: function_cd881f16
	Namespace: zm_island_zones
	Checksum: 0xBAE01F88
	Offset: 0x19A8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_cd881f16()
{
	level flag::wait_till("connect_jungle_to_jungle_lab");
	exploder::exploder("fxexp_410");
}

/*
	Name: function_afc937e7
	Namespace: zm_island_zones
	Checksum: 0xB694A54F
	Offset: 0x19F0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_afc937e7()
{
	self endon(#"death");
	self util::waittill_either("rotatedone", "movedone");
	wait(2);
	self delete();
}

