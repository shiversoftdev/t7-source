// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_monkey;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_auto_turret;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_random;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_trap_fire;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_annihilator;
#using scripts\zm\_zm_weap_black_hole_bomb;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_nesting_dolls;
#using scripts\zm\_zm_weap_sickle;
#using scripts\zm\_zm_weap_thundergun;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\zm_cosmodrome_achievement;
#using scripts\zm\zm_cosmodrome_ai_monkey;
#using scripts\zm\zm_cosmodrome_amb;
#using scripts\zm\zm_cosmodrome_eggs;
#using scripts\zm\zm_cosmodrome_ffotd;
#using scripts\zm\zm_cosmodrome_fx;
#using scripts\zm\zm_cosmodrome_lander;
#using scripts\zm\zm_cosmodrome_magic_box;
#using scripts\zm\zm_cosmodrome_pack_a_punch;
#using scripts\zm\zm_cosmodrome_traps;
#using scripts\zm\zm_remaster_zombie;
#using scripts\zm\zm_zmhd_cleanup_mgr;

#namespace zm_cosmodrome;

/*
	Name: opt_in
	Namespace: zm_cosmodrome
	Checksum: 0xC31141F4
	Offset: 0x1780
	Size: 0x28
	Parameters: 0
	Flags: AutoExec
*/
function autoexec opt_in()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
	level.pack_a_punch_camo_index = 132;
}

/*
	Name: main
	Namespace: zm_cosmodrome
	Checksum: 0x343D736F
	Offset: 0x17B0
	Size: 0x7AC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	zm_cosmodrome_ffotd::main_start();
	level.sndzhdaudio = 1;
	level.default_game_mode = "zclassic";
	level.default_start_location = "default";
	init_clientfields();
	level flag::init("lander_intro_done");
	visionset_mgr::register_info("visionset", "zm_cosmodrome_no_power", 21000, 100, 31, 1, &visionset_mgr::ramp_in_thread_per_player, 0);
	visionset_mgr::register_info("visionset", "zm_cosmodrome_power_antic", 21000, 102, 31, 1, &visionset_mgr::ramp_in_out_thread_per_player, 0);
	visionset_mgr::register_info("visionset", "zm_cosmodrome_power_flare", 21000, 103, 31, 1, &visionset_mgr::ramp_in_out_thread_per_player, 0);
	visionset_mgr::register_info("visionset", "zm_cosmodrome_monkey_on", 21000, 996, 31, 1, &visionset_mgr::ramp_in_thread_per_player, 0);
	visionset_mgr::register_info("visionset", "zm_cosmodrome_monkey_off", 21000, 995, 31, 1, &visionset_mgr::ramp_in_out_thread_per_player, 0);
	level.default_game_mode = "zclassic";
	zm_cosmodrome_fx::main();
	zm::init_fx();
	level.zombiemode = 1;
	level._zmbvoxlevelspecific = &init_level_specific_audio;
	level._round_start_func = &function_a4a54181;
	level.givecustomcharacters = &givecustomcharacters;
	initcharacterstartindex();
	level.random_pandora_box_start = 0;
	level.door_dialog_function = &zm::play_door_dialog;
	level._zombie_custom_add_weapons = &custom_add_weapons;
	level.register_offhand_weapons_for_level_defaults_override = &cosmodrome_offhand_weapon_overrride;
	level.zombiemode_offhand_weapon_give_override = &offhand_weapon_give_override;
	include_perks_in_random_rotation();
	load::main();
	zm_cosmodrome_amb::main();
	level.default_laststandpistol = getweapon("pistol_m1911");
	level.default_solo_laststandpistol = getweapon("pistol_m1911_upgraded");
	level.laststandpistol = level.default_laststandpistol;
	level.start_weapon = level.default_laststandpistol;
	level thread zm::last_stand_pistol_rank_init();
	level.var_9aaae7ae = &function_869d6f66;
	level.var_35efa94c = &function_f97e7fed;
	init_sounds();
	level thread setupmusic();
	if(getdvarint("artist") > 0)
	{
		return;
	}
	level.player_out_of_playable_area_monitor = 1;
	level.player_out_of_playable_area_monitor_callback = &zombie_cosmodrome_player_out_of_playable_area_monitor_callback;
	level thread zm_cosmodrome_ai_monkey::init();
	level.monkey_round_start = &function_2c076a5e;
	level.monkey_round_stop = &function_980a894b;
	level.pay_turret_cost = 1000;
	level.lander_cost = 250;
	level.custom_ai_type = [];
	if(!isdefined(level.custom_ai_type))
	{
		level.custom_ai_type = [];
	}
	else if(!isarray(level.custom_ai_type))
	{
		level.custom_ai_type = array(level.custom_ai_type);
	}
	level.custom_ai_type[level.custom_ai_type.size] = &zm_ai_monkey::function_4c8046f8;
	level.monkey_prespawn = &zm_cosmodrome_ai_monkey::monkey_cosmodrome_prespawn;
	level.max_perks = 5;
	level.max_solo_lives = 3;
	level thread zm_cosmodrome_lander::init();
	level thread zm_cosmodrome_lander::new_lander_intro();
	level._allow_melee_weapon_switching = 1;
	level zm_cosmodrome_magic_box::magic_box_init();
	level thread function_54bf648f();
	level.zone_manager_init_func = &cosmodrome_zone_init;
	init_zones[0] = "centrifuge_zone";
	init_zones[1] = "centrifuge_zone2";
	level thread zm_zonemgr::manage_zones(init_zones);
	level thread electric_switch();
	level thread zm_cosmodrome_eggs::init();
	level thread zm_cosmodrome_traps::init_traps();
	level thread centrifuge_jumpup_fix();
	level thread centrifuge_jumpdown_fix();
	level thread centrifuge_init();
	level thread zm_cosmodrome_pack_a_punch::pack_a_punch_main();
	level thread zm_cosmodrome_achievement::init();
	level thread zm::post_main();
	/#
		execdevgui("");
		level.custom_devgui = &function_161eeb8e;
		setup_devgui();
	#/
	level thread function_e509f24d();
	level thread spawn_kill_brushes();
	level thread function_9503fe88();
	level thread zm_perks::spare_change();
	scene::add_scene_func("cin_zmhd_sizzle_cosmodrome_cam", &cin_zmhd_sizzle_cosmodrome_cam, "play");
	scene::add_scene_func("cin_zmhd_sizzle_cosmodrome_cam2", &cin_zmhd_sizzle_cosmodrome_cam2, "play");
	zm_cosmodrome_ffotd::main_end();
}

/*
	Name: cin_zmhd_sizzle_cosmodrome_cam
	Namespace: zm_cosmodrome
	Checksum: 0x408BB0CE
	Offset: 0x1F68
	Size: 0x10A
	Parameters: 1
	Flags: Linked
*/
function cin_zmhd_sizzle_cosmodrome_cam(a_ents)
{
	level thread scene::play("cin_zmhd_sizzle_cosmodrome_cam2");
	foreach(var_6cae1ad0 in a_ents)
	{
		if(issubstr(var_6cae1ad0.model, "zombie") || issubstr(var_6cae1ad0.model, "cosmon"))
		{
			var_6cae1ad0 clientfield::set("zombie_has_eyes", 1);
		}
	}
}

/*
	Name: cin_zmhd_sizzle_cosmodrome_cam2
	Namespace: zm_cosmodrome
	Checksum: 0x9C1ED8FB
	Offset: 0x2080
	Size: 0xEA
	Parameters: 1
	Flags: Linked
*/
function cin_zmhd_sizzle_cosmodrome_cam2(a_ents)
{
	foreach(var_6cae1ad0 in a_ents)
	{
		if(issubstr(var_6cae1ad0.model, "zombie") || issubstr(var_6cae1ad0.model, "cosmon"))
		{
			var_6cae1ad0 clientfield::set("zombie_has_eyes", 1);
		}
	}
}

/*
	Name: init_clientfields
	Namespace: zm_cosmodrome
	Checksum: 0xA704B468
	Offset: 0x2178
	Size: 0x514
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	clientfield::register("scriptmover", "zombie_has_eyes", 21000, 1, "int");
	clientfield::register("actor", "COSMO_SOULPULL", 21000, 1, "int");
	clientfield::register("scriptmover", "COSMO_ROCKET_FX", 21000, 1, "int");
	clientfield::register("scriptmover", "COSMO_MONKEY_LANDER_FX", 21000, 1, "int");
	clientfield::register("world", "COSMO_EGG_SAM_ANGRY", 21000, 1, "int");
	clientfield::register("scriptmover", "COSMO_LANDER_ENGINE_FX", 21000, 1, "int");
	clientfield::register("allplayers", "COSMO_PLAYER_LANDER_FOG", 21000, 1, "int");
	clientfield::register("scriptmover", "COSMO_LANDER_MOVE_FX", 21000, 1, "int");
	clientfield::register("scriptmover", "COSMO_LANDER_RUMBLE_AND_QUAKE", 21000, 1, "int");
	clientfield::register("world", "COSMO_LANDER_STATUS_LIGHTS", 21000, 2, "int");
	clientfield::register("world", "COSMO_LANDER_STATION", 21000, 3, "int");
	clientfield::register("world", "COSMO_LANDER_DEST", 21000, 3, "int");
	clientfield::register("world", "COSMO_LANDER_CATWALK_BAY", 21000, 3, "int");
	clientfield::register("world", "COSMO_LANDER_BASE_ENTRY_BAY", 21000, 3, "int");
	clientfield::register("world", "COSMO_LANDER_CENTRIFUGE_BAY", 21000, 3, "int");
	clientfield::register("world", "COSMO_LANDER_STORAGE_BAY", 21000, 3, "int");
	clientfield::register("scriptmover", "COSMO_LAUNCH_PANEL_CENTRIFUGE_STATUS", 21000, 1, "int");
	clientfield::register("scriptmover", "COSMO_LAUNCH_PANEL_BASEENTRY_STATUS", 21000, 1, "int");
	clientfield::register("scriptmover", "COSMO_LAUNCH_PANEL_STORAGE_STATUS", 21000, 1, "int");
	clientfield::register("scriptmover", "COSMO_LAUNCH_PANEL_CATWALK_STATUS", 21000, 1, "int");
	clientfield::register("scriptmover", "COSMO_CENTRIFUGE_RUMBLE", 21000, 1, "int");
	clientfield::register("scriptmover", "COSMO_CENTRIFUGE_LIGHTS", 21000, 1, "int");
	clientfield::register("world", "COSMO_VISIONSET_BEGIN", 21000, 1, "int");
	clientfield::register("world", "COSMO_VISIONSET_NOPOWER", 21000, 1, "int");
	clientfield::register("world", "COSMO_VISIONSET_POWERON", 21000, 1, "int");
	clientfield::register("world", "COSMO_VISIONSET_MONKEY", 21000, 1, "int");
	clientfield::register("clientuimodel", "player_lives", 1, 2, "int");
}

/*
	Name: function_a4a54181
	Namespace: zm_cosmodrome
	Checksum: 0x94CFBB68
	Offset: 0x2698
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_a4a54181()
{
	level notify(#"hash_fd9adc1e");
	level flag::wait_till("lander_intro_done");
	zm::round_start();
}

/*
	Name: function_869d6f66
	Namespace: zm_cosmodrome
	Checksum: 0xC0E382DC
	Offset: 0x26E0
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function function_869d6f66()
{
	if(!isdefined(self zm_bgb_anywhere_but_here::function_728dfe3()))
	{
		return false;
	}
	if(isdefined(self.lander) && self.lander)
	{
		return false;
	}
	return true;
}

/*
	Name: function_f97e7fed
	Namespace: zm_cosmodrome
	Checksum: 0x4633DA75
	Offset: 0x2730
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function function_f97e7fed()
{
	if(level flag::get("monkey_round"))
	{
		return false;
	}
	return true;
}

/*
	Name: spawn_kill_brushes
	Namespace: zm_cosmodrome
	Checksum: 0x1A3C2425
	Offset: 0x2768
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function spawn_kill_brushes()
{
	zm::spawn_kill_brush((-672, -152, 0), 200, 1000);
	zm::spawn_kill_brush((-2272, 1768, 130), 200, 1000);
	zm::spawn_kill_brush((160, -2320, 50), 400, 1000);
	zm::spawn_kill_brush((1760, 1256, 490), 400, 1000);
}

/*
	Name: zombie_cosmodrome_player_out_of_playable_area_monitor_callback
	Namespace: zm_cosmodrome
	Checksum: 0xF1B4F082
	Offset: 0x2818
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function zombie_cosmodrome_player_out_of_playable_area_monitor_callback()
{
	if(isdefined(self.lander) && self.lander || (isdefined(self.on_lander_last_stand) && self.on_lander_last_stand))
	{
		return false;
	}
	return true;
}

/*
	Name: centrifuge_jumpup_fix
	Namespace: zm_cosmodrome
	Checksum: 0x271A0A99
	Offset: 0x2860
	Size: 0x166
	Parameters: 0
	Flags: Linked
*/
function centrifuge_jumpup_fix()
{
	var_157ff899 = getent("centrifuge_jumpup", "targetname");
	if(!isdefined(var_157ff899))
	{
		return;
	}
	jump_pos = var_157ff899.origin;
	var_b9bd08ae = 0;
	while(true)
	{
		if(level.zones["centrifuge_zone"].is_occupied && var_b9bd08ae == 0)
		{
			var_157ff899 movex(jump_pos[0] + 64, 0.1);
			var_157ff899 disconnectpaths();
			var_b9bd08ae = 1;
		}
		else if(!level.zones["centrifuge_zone"].is_occupied && var_b9bd08ae == 1)
		{
			var_157ff899 moveto(jump_pos, 0.1);
			var_157ff899 connectpaths();
			var_b9bd08ae = 0;
		}
		wait(1);
	}
}

/*
	Name: centrifuge_jumpdown_fix
	Namespace: zm_cosmodrome
	Checksum: 0x46B6C402
	Offset: 0x29D0
	Size: 0x16E
	Parameters: 0
	Flags: Linked
*/
function centrifuge_jumpdown_fix()
{
	var_157ff899 = getent("centrifuge_jumpdown", "targetname");
	if(!isdefined(var_157ff899))
	{
		return;
	}
	jump_pos = var_157ff899.origin;
	var_ac214666 = 1;
	while(true)
	{
		if(level.zones["centrifuge_zone2"].is_occupied && var_ac214666 == 0)
		{
			var_157ff899 movex(jump_pos[0] + 64, 0.1);
			var_157ff899 disconnectpaths();
			var_ac214666 = 1;
		}
		else if(!level.zones["centrifuge_zone2"].is_occupied && var_ac214666 == 1)
		{
			var_157ff899 moveto(jump_pos, 0.1);
			var_157ff899 connectpaths();
			var_ac214666 = 0;
		}
		wait(1);
	}
}

/*
	Name: custom_add_weapons
	Namespace: zm_cosmodrome
	Checksum: 0x5E6C7BED
	Offset: 0x2B48
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_cosmodrome_weapons.csv", 1);
}

/*
	Name: custom_add_vox
	Namespace: zm_cosmodrome
	Checksum: 0x5A46D173
	Offset: 0x2B78
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function custom_add_vox()
{
	zm_audio::loadplayervoicecategories("gamedata/audio/zm/zm_cosmodrome_vox.csv");
	init_level_specific_audio();
}

/*
	Name: function_7eea24df
	Namespace: zm_cosmodrome
	Checksum: 0x8204D5DB
	Offset: 0x2BB0
	Size: 0x126
	Parameters: 0
	Flags: None
*/
function function_7eea24df()
{
	level flag::wait_till("all_players_connected");
	players = getplayers();
	level.chest_min_move_usage = players.size;
	chest = level.chests[level.chest_index];
	while(level.chest_accessed < level.chest_min_move_usage)
	{
		chest waittill(#"chest_accessed");
	}
	chest triggerenable(0);
	chest.chest_lid zm_magicbox::treasure_chest_lid_open();
	chest thread zm_magicbox::treasure_chest_move();
	wait(0.5);
	level notify(#"weapon_fly_away_start");
	wait(2);
	chest notify(#"box_moving");
	level notify(#"weapon_fly_away_end");
	level.chest_min_move_usage = undefined;
}

/*
	Name: cosmodrome_zone_init
	Namespace: zm_cosmodrome
	Checksum: 0x1C0BA76E
	Offset: 0x2CE0
	Size: 0x49C
	Parameters: 0
	Flags: Linked
*/
function cosmodrome_zone_init()
{
	level flag::init("centrifuge");
	level flag::set("centrifuge");
	zm_zonemgr::add_adjacent_zone("access_tunnel_zone", "base_entry_zone", "base_entry_group");
	zm_zonemgr::add_adjacent_zone("storage_zone", "storage_zone2", "storage_group");
	zm_zonemgr::add_adjacent_zone("power_building", "base_entry_zone2", "power_group");
	zm_zonemgr::add_adjacent_zone("north_path_zone", "roof_connector_zone", "roof_connector_dropoff");
	zm_zonemgr::add_adjacent_zone("north_path_zone", "under_rocket_zone", "rocket_group");
	zm_zonemgr::add_adjacent_zone("control_room_zone", "under_rocket_zone", "rocket_group");
	zm_zonemgr::add_adjacent_zone("centrifuge_zone", "centrifuge_zone2", "centrifuge");
	zm_zonemgr::add_adjacent_zone("centrifuge_zone", "centrifuge2power_zone", "centrifuge2power");
	zm_zonemgr::add_adjacent_zone("base_entry_zone2", "centrifuge2power_zone", "power2centrifuge");
	zm_zonemgr::add_zone_flags("power2centrifuge", "power_group");
	zm_zonemgr::add_adjacent_zone("access_tunnel_zone", "centrifuge_zone", "tunnel_centrifuge_entry");
	zm_zonemgr::add_zone_flags("tunnel_centrifuge_entry", "base_entry_group");
	zm_zonemgr::add_adjacent_zone("base_entry_zone", "base_entry_zone2", "base_entry_2_power");
	zm_zonemgr::add_zone_flags("base_entry_2_power", "base_entry_group");
	zm_zonemgr::add_zone_flags("base_entry_2_power", "power_group");
	zm_zonemgr::add_adjacent_zone("power_building", "power_building_roof", "power_interior_2_roof");
	zm_zonemgr::add_zone_flags("power_interior_2_roof", "power_group");
	zm_zonemgr::add_adjacent_zone("north_catwalk_zone3", "roof_connector_zone", "catwalks_2_shed");
	zm_zonemgr::add_zone_flags("catwalks_2_shed", "roof_connector_dropoff");
	zm_zonemgr::add_adjacent_zone("access_tunnel_zone", "storage_zone", "base_entry_2_storage");
	zm_zonemgr::add_adjacent_zone("access_tunnel_zone", "storage_zone2", "base_entry_2_storage");
	zm_zonemgr::add_zone_flags("base_entry_2_storage", "storage_group");
	zm_zonemgr::add_zone_flags("base_entry_2_storage", "base_entry_group");
	zm_zonemgr::add_adjacent_zone("storage_lander_zone", "storage_zone", "storage_lander_area");
	zm_zonemgr::add_adjacent_zone("storage_lander_zone", "storage_zone2", "storage_lander_area");
	zm_zonemgr::add_adjacent_zone("north_path_zone", "base_entry_zone2", "base_entry_2_north_path");
	zm_zonemgr::add_zone_flags("base_entry_2_north_path", "power_group");
	zm_zonemgr::add_zone_flags("base_entry_2_north_path", "roof_connector_dropoff");
	zm_zonemgr::add_adjacent_zone("power_building_roof", "roof_connector_zone", "power_catwalk_access");
	zm_zonemgr::add_zone_flags("power_catwalk_access", "roof_connector_dropoff");
}

/*
	Name: function_54bf648f
	Namespace: zm_cosmodrome
	Checksum: 0x31AF023C
	Offset: 0x3188
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_54bf648f()
{
	level.use_multiple_spawns = 1;
	level.spawner_int = 1;
	level.fn_custom_zombie_spawner_selection = &function_54da140a;
}

/*
	Name: function_54da140a
	Namespace: zm_cosmodrome
	Checksum: 0x7643EA79
	Offset: 0x31C8
	Size: 0x204
	Parameters: 0
	Flags: Linked
*/
function function_54da140a()
{
	var_6af221a2 = [];
	a_s_spots = array::randomize(level.zm_loc_types["zombie_location"]);
	for(i = 0; i < a_s_spots.size; i++)
	{
		if(!isdefined(a_s_spots[i].script_int))
		{
			var_343b1937 = 1;
		}
		else
		{
			var_343b1937 = a_s_spots[i].script_int;
		}
		var_c15b2128 = [];
		foreach(sp_zombie in level.zombie_spawners)
		{
			if(sp_zombie.script_int == var_343b1937)
			{
				if(!isdefined(var_c15b2128))
				{
					var_c15b2128 = [];
				}
				else if(!isarray(var_c15b2128))
				{
					var_c15b2128 = array(var_c15b2128);
				}
				var_c15b2128[var_c15b2128.size] = sp_zombie;
			}
		}
		if(var_c15b2128.size)
		{
			sp_zombie = array::random(var_c15b2128);
			return sp_zombie;
		}
	}
	/#
		assert(isdefined(sp_zombie), "" + var_343b1937);
	#/
}

/*
	Name: electric_switch
	Namespace: zm_cosmodrome
	Checksum: 0x29F00E00
	Offset: 0x33D8
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function electric_switch()
{
	trig = getent("use_elec_switch", "targetname");
	trig sethintstring(&"ZOMBIE_ELECTRIC_SWITCH");
	trig setcursorhint("HINT_NOICON");
	level thread wait_for_power();
	trig waittill(#"trigger", user);
	playsoundatposition("zmb_poweron_front", (0, 0, 0));
}

/*
	Name: wait_for_power
	Namespace: zm_cosmodrome
	Checksum: 0x95278E78
	Offset: 0x34A0
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function wait_for_power()
{
	var_cf413835 = struct::get("power_switch", "targetname");
	level flag::wait_till("power_on");
	playsoundatposition("zmb_switch_flip_start", var_cf413835.origin);
	var_cf413835 scene::play("p7_fxanim_zmhd_power_switch_bundle");
	playfx(level._effect["switch_sparks"], struct::get("elec_switch_fx", "targetname").origin);
	playsoundatposition("zmb_switch_flip", var_cf413835.origin);
	level thread zm_cosmodrome_amb::power_clangs();
	level thread zm_cosmodrome_amb::play_cosmo_announcer_vox("vox_ann_power_switch");
	level flag::set("lander_power");
	level clientfield::set("zombie_power_on", 1);
	exploder::exploder("lgt_exploder_power_on");
	wait(31);
	exploder::kill_exploder("lgt_exploder_power_alt_off");
}

/*
	Name: function_98fe9c46
	Namespace: zm_cosmodrome
	Checksum: 0x3D9247A2
	Offset: 0x3660
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function function_98fe9c46()
{
	level clientfield::set("COSMO_VISIONSET_POWERON", 1);
	wait(31);
	exploder::kill_exploder("lgt_exploder_power_alt_off");
}

/*
	Name: custom_pandora_show_func
	Namespace: zm_cosmodrome
	Checksum: 0x8733C7DF
	Offset: 0x36B0
	Size: 0xB4
	Parameters: 3
	Flags: None
*/
function custom_pandora_show_func(anchor, anchortarget, pieces)
{
	level.pandora_light.angles = (-90, anchortarget.angles[1] + 180, 0);
	level.pandora_light moveto(anchortarget.origin, 0.05);
	wait(1);
	playfx(level._effect["lght_marker_flare"], level.pandora_light.origin);
}

/*
	Name: custom_pandora_fx_func
	Namespace: zm_cosmodrome
	Checksum: 0x52082EEA
	Offset: 0x3770
	Size: 0x144
	Parameters: 0
	Flags: None
*/
function custom_pandora_fx_func()
{
	start_chest = getent("start_chest", "script_noteworthy");
	anchor = getent(start_chest.target, "targetname");
	anchortarget = getent(anchor.target, "targetname");
	level.pandora_light = spawn("script_model", anchortarget.origin);
	level.pandora_light.angles = anchortarget.angles + (vectorscale((-1, 0, 0), 90));
	level.pandora_light setmodel("tag_origin");
	playfxontag(level._effect["lght_marker"], level.pandora_light, "tag_origin");
}

/*
	Name: centrifuge_init
	Namespace: zm_cosmodrome
	Checksum: 0x994F0712
	Offset: 0x38C0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function centrifuge_init()
{
	centrifuge = getent("centrifuge", "targetname");
	if(isdefined(centrifuge))
	{
		centrifuge function_c6807eeb();
	}
}

/*
	Name: function_a97cb654
	Namespace: zm_cosmodrome
	Checksum: 0x3CF1089
	Offset: 0x3920
	Size: 0x9C
	Parameters: 0
	Flags: None
*/
function function_a97cb654()
{
	pieces = getentarray(self.target, "targetname");
	if(isdefined(pieces))
	{
		for(i = 0; i < pieces.size; i++)
		{
			pieces[i] linkto(self);
		}
	}
	self thread function_c6807eeb();
}

/*
	Name: function_c6807eeb
	Namespace: zm_cosmodrome
	Checksum: 0x5FDA2F15
	Offset: 0x39C8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_c6807eeb()
{
	while(true)
	{
		self rotateyaw(360, 20);
		self waittill(#"rotatedone");
	}
}

/*
	Name: initcharacterstartindex
	Namespace: zm_cosmodrome
	Checksum: 0x336CB8CF
	Offset: 0x3A10
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function initcharacterstartindex()
{
	level.characterstartindex = randomint(4);
}

/*
	Name: selectcharacterindextouse
	Namespace: zm_cosmodrome
	Checksum: 0xC48DB998
	Offset: 0x3A40
	Size: 0x3E
	Parameters: 0
	Flags: None
*/
function selectcharacterindextouse()
{
	if(level.characterstartindex >= 4)
	{
		level.characterstartindex = 0;
	}
	self.characterindex = level.characterstartindex;
	level.characterstartindex++;
	return self.characterindex;
}

/*
	Name: givecustomcharacters
	Namespace: zm_cosmodrome
	Checksum: 0xEADC1241
	Offset: 0x3A88
	Size: 0x2CC
	Parameters: 0
	Flags: Linked
*/
function givecustomcharacters()
{
	if(isdefined(level.hotjoin_player_setup) && [[level.hotjoin_player_setup]]("c_zom_farmgirl_viewhands"))
	{
		return;
	}
	self detachall();
	if(!isdefined(self.characterindex))
	{
		self.characterindex = assign_lowest_unused_character_index();
	}
	self.favorite_wall_weapons_list = [];
	self.talks_in_danger = 0;
	/#
		if(getdvarstring("") != "")
		{
			self.characterindex = getdvarint("");
		}
	#/
	self setcharacterbodytype(self.characterindex);
	self setcharacterbodystyle(0);
	self setcharacterhelmetstyle(0);
	switch(self.characterindex)
	{
		case 1:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("870mcs");
			break;
		}
		case 0:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("frag_grenade");
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("bouncingbetty");
			break;
		}
		case 3:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("hk416");
			break;
		}
		case 2:
		{
			self.talks_in_danger = 1;
			level.rich_sq_player = self;
			level.sndradioa = self;
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("pistol_standard");
			break;
		}
	}
	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
	self thread zm_audio_zhd::set_exert_id();
}

/*
	Name: assign_lowest_unused_character_index
	Namespace: zm_cosmodrome
	Checksum: 0x69260FA3
	Offset: 0x3D60
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function assign_lowest_unused_character_index()
{
	charindexarray = [];
	charindexarray[0] = 0;
	charindexarray[1] = 1;
	charindexarray[2] = 2;
	charindexarray[3] = 3;
	players = getplayers();
	if(players.size == 1)
	{
		charindexarray = array::randomize(charindexarray);
		if(charindexarray[0] == 2)
		{
			level.has_richtofen = 1;
		}
		return charindexarray[0];
	}
	n_characters_defined = 0;
	foreach(player in players)
	{
		if(isdefined(player.characterindex))
		{
			arrayremovevalue(charindexarray, player.characterindex, 0);
			n_characters_defined++;
		}
	}
	if(charindexarray.size > 0)
	{
		if(n_characters_defined == (players.size - 1))
		{
			if(!(isdefined(level.has_richtofen) && level.has_richtofen))
			{
				level.has_richtofen = 1;
				return 2;
			}
		}
		charindexarray = array::randomize(charindexarray);
		if(charindexarray[0] == 2)
		{
			level.has_richtofen = 1;
		}
		return charindexarray[0];
	}
	return 0;
}

/*
	Name: cosmodrome_offhand_weapon_overrride
	Namespace: zm_cosmodrome
	Checksum: 0x697D9492
	Offset: 0x3F80
	Size: 0xBE
	Parameters: 0
	Flags: Linked
*/
function cosmodrome_offhand_weapon_overrride()
{
	zm_utility::register_lethal_grenade_for_level("frag_grenade");
	level.zombie_lethal_grenade_player_init = getweapon("frag_grenade");
	zm_utility::register_tactical_grenade_for_level("black_hole_bomb");
	zm_utility::register_tactical_grenade_for_level("nesting_dolls");
	zm_utility::register_melee_weapon_for_level(level.weaponbasemelee.name);
	zm_utility::register_melee_weapon_for_level("sickle_knife");
	level.zombie_melee_weapon_player_init = level.weaponbasemelee;
	level.zombie_equipment_player_init = undefined;
}

/*
	Name: offhand_weapon_give_override
	Namespace: zm_cosmodrome
	Checksum: 0x1DFB743C
	Offset: 0x4048
	Size: 0x15C
	Parameters: 1
	Flags: Linked
*/
function offhand_weapon_give_override(w_current_weapon)
{
	self endon(#"death");
	if(zm_utility::is_tactical_grenade(w_current_weapon) && isdefined(self zm_utility::get_player_tactical_grenade()) && !self zm_utility::is_player_tactical_grenade(w_current_weapon))
	{
		self setweaponammoclip(self zm_utility::get_player_tactical_grenade(), 0);
		self takeweapon(self zm_utility::get_player_tactical_grenade());
	}
	if(w_current_weapon.name == "black_hole_bomb")
	{
		self zm_weap_black_hole_bomb::player_give_black_hole_bomb();
		self zm_weapons::play_weapon_vo(w_current_weapon);
		return true;
	}
	if(w_current_weapon.name == "nesting_dolls")
	{
		self _zm_weap_nesting_dolls::player_give_nesting_dolls();
		self zm_weapons::play_weapon_vo(w_current_weapon);
		return true;
	}
	return false;
}

/*
	Name: init_sounds
	Namespace: zm_cosmodrome
	Checksum: 0xEEF9A36
	Offset: 0x41B0
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function init_sounds()
{
	zm_utility::add_sound("zmb_electric_metal_big", "zmb_heavy_door_open");
	zm_utility::add_sound("zmb_gate_swing", "zmb_door_fence_open");
	zm_utility::add_sound("zmb_electric_metal_small", "zmb_lab_door_slide");
	zm_utility::add_sound("zmb_gate_slide", "zmb_cosmo_gate_slide");
	zm_utility::add_sound("zmb_door_swing", "zmb_cosmo_door_swing");
	zm_utility::add_sound("zmb_heavy_door_open", "zmb_heavy_door_open");
	level thread custom_add_vox();
	level.vox_response_override = 1;
}

/*
	Name: setupmusic
	Namespace: zm_cosmodrome
	Checksum: 0xDF33B615
	Offset: 0x42A0
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function setupmusic()
{
	zm_audio::musicstate_create("round_start", 3, "round_start_cosmo_1", "round_start_cosmo_2", "round_start_cosmo_3", "round_start_cosmo_4");
	zm_audio::musicstate_create("round_start_short", 3, "round_start_cosmo_1", "round_start_cosmo_2", "round_start_cosmo_3", "round_start_cosmo_4");
	zm_audio::musicstate_create("round_start_first_lander", 3, "round_start_cosmo_first");
	zm_audio::musicstate_create("round_end", 3, "round_end_cosmo_1", "round_end_cosmo_2", "round_end_cosmo_3");
	zm_audio::musicstate_create("game_over", 5, "game_over_zhd_cosmodrome");
	zm_audio::musicstate_create("abracadavre", 4, "abracadavre");
	zm_audio::musicstate_create("none", 4, "none");
	zm_audio::musicstate_create("sam", 4, "sam");
	zm_audio::musicstate_create("not_ready_to_die", 4, "not_ready_to_die");
	zm_audio::musicstate_create("monkey_round_start", 3, "monkey_round_start");
	zm_audio::musicstate_create("monkey_round_end", 3, "monkey_round_end");
}

/*
	Name: function_9503fe88
	Namespace: zm_cosmodrome
	Checksum: 0xB0AA645D
	Offset: 0x44A8
	Size: 0x132
	Parameters: 0
	Flags: Linked
*/
function function_9503fe88()
{
	perk_machines = getentarray("zombie_vending", "targetname");
	new_revive_clip = getent("new_revive_clip", "targetname");
	foreach(perk_machine in perk_machines)
	{
		if(isdefined(perk_machine.clip))
		{
			perk_machine.clip delete();
			if(perk_machine.script_noteworthy == "specialty_quickrevive")
			{
				perk_machine.clip = new_revive_clip;
			}
		}
	}
}

/*
	Name: function_161eeb8e
	Namespace: zm_cosmodrome
	Checksum: 0x95711123
	Offset: 0x45E8
	Size: 0x21A
	Parameters: 1
	Flags: Linked
*/
function function_161eeb8e(cmd)
{
	/#
		level.var_6708aa9c = 0;
		cmd_strings = strtok(cmd, "");
		switch(cmd_strings[0])
		{
			case "":
			{
				function_797b2641();
				break;
			}
			case "":
			{
				function_f0357d95();
				break;
			}
			case "":
			{
				function_d360e7c6();
				break;
			}
			case "":
			{
				function_d9e82452();
				break;
			}
			case "":
			{
				function_b8df7e30(1);
				break;
			}
			case "":
			{
				function_b8df7e30(0);
				break;
			}
			case "":
			{
				function_83393018(0);
				break;
			}
			case "":
			{
				function_83393018(1);
				break;
			}
			case "":
			{
				function_55336afe();
			}
			case "":
			{
				function_c0e05145();
			}
			case "":
			{
				function_c28796c3();
			}
			case "":
			{
				function_f567fa2e();
			}
			case "":
			{
				function_502e7927();
			}
			case "":
			{
				function_a53ed1da();
			}
			case "":
			{
				function_8a5ca1ef();
				break;
			}
			default:
			{
				break;
			}
		}
	#/
}

/*
	Name: setup_devgui
	Namespace: zm_cosmodrome
	Checksum: 0xB77233D5
	Offset: 0x4810
	Size: 0x4C4
	Parameters: 0
	Flags: Linked
*/
function setup_devgui()
{
	/#
		level.var_6708aa9c = 0;
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		level thread function_58ab8a92();
	#/
}

/*
	Name: function_58ab8a92
	Namespace: zm_cosmodrome
	Checksum: 0x9FB9A407
	Offset: 0x4CE0
	Size: 0x9D8
	Parameters: 0
	Flags: Linked
*/
function function_58ab8a92()
{
	/#
		while(true)
		{
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
				function_797b2641();
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
				function_9d5d7bb3(0);
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
				function_9d5d7bb3(1);
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
				function_9d5d7bb3(2);
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
				function_9d5d7bb3(3);
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
				function_9d5d7bb3(4);
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
				level thread function_5b312f();
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
				function_f0357d95();
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
				function_d360e7c6();
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
				function_d9e82452();
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
				function_b8df7e30(1);
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
				function_b8df7e30(0);
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
				function_83393018(0);
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
				function_83393018(1);
			}
			if(getdvarstring("") == "")
			{
				level.var_ee92e6f7 = 1;
				setdvar("", "");
				iprintlnbold("");
				function_55336afe();
			}
			if(getdvarstring("") == "")
			{
				level.var_ee92e6f7 = 1;
				setdvar("", "");
				iprintlnbold("");
				function_c0e05145();
			}
			if(getdvarstring("") == "")
			{
				level.var_ee92e6f7 = 1;
				setdvar("", "");
				iprintlnbold("");
				function_c28796c3();
			}
			if(getdvarstring("") == "")
			{
				level.var_ee92e6f7 = 1;
				setdvar("", "");
				iprintlnbold("");
				function_f567fa2e();
			}
			if(getdvarstring("") == "")
			{
				level.var_ee92e6f7 = 1;
				setdvar("", "");
				iprintlnbold("");
				function_502e7927();
			}
			if(getdvarstring("") == "")
			{
				level.var_ee92e6f7 = 1;
				setdvar("", "");
				iprintlnbold("");
				function_a53ed1da();
			}
			if(getdvarstring("") == "")
			{
				level.var_ee92e6f7 = 1;
				setdvar("", "");
				iprintlnbold("");
				function_8a5ca1ef();
			}
			wait(0.5);
		}
	#/
}

/*
	Name: function_797b2641
	Namespace: zm_cosmodrome
	Checksum: 0xFC2E3B31
	Offset: 0x56C0
	Size: 0x2F4
	Parameters: 0
	Flags: Linked
*/
function function_797b2641()
{
	/#
		if(!level flag::get(""))
		{
			iprintln("");
			zm_devgui::zombie_devgui_open_sesame();
		}
		if(!level flag::exists(""))
		{
			level flag::init("");
		}
		if(!level flag::get(""))
		{
			iprintln("");
			zm_devgui::zombie_devgui_give_perk("");
		}
		else
		{
			var_2921da00 = array("", "", "", "", "", "", "");
			e_player = getplayers()[0];
			var_18253ec9 = randomintrange(0, var_2921da00.size - 1);
			while(e_player hasperk(var_2921da00[var_18253ec9]))
			{
				var_18253ec9 = randomintrange(0, var_2921da00.size - 1);
				util::wait_network_frame();
			}
			zm_devgui::zombie_devgui_give_perk(var_2921da00[var_18253ec9]);
		}
		if(!level flag::get(""))
		{
			iprintln("");
			level flag::wait_till("");
			iprintln("");
			wait(12);
		}
		level flag::wait_till("");
		wait(0.05);
		var_307510ba = level.round_number + 1;
		iprintln("" + var_307510ba);
		level.next_monkey_round = var_307510ba;
		zm_devgui::zombie_devgui_goto_round(var_307510ba);
	#/
}

/*
	Name: function_9d5d7bb3
	Namespace: zm_cosmodrome
	Checksum: 0xB58FFB3D
	Offset: 0x59C0
	Size: 0x544
	Parameters: 1
	Flags: Linked
*/
function function_9d5d7bb3(choose)
{
	/#
		vending_triggers = zm_ai_monkey::function_5b9c3e11();
		target_trigger = vending_triggers[0];
		player = getplayers()[0];
		closest_dist_sq = distancesquared(player.origin, target_trigger.origin);
		foreach(var_807754d1 in vending_triggers)
		{
			if(var_807754d1 == target_trigger)
			{
				continue;
			}
			dist_sq = distancesquared(player.origin, var_807754d1.origin);
			if(dist_sq < closest_dist_sq)
			{
				closest_dist_sq = dist_sq;
				target_trigger = var_807754d1;
			}
		}
		if(!isdefined(level.var_93621cb))
		{
			level.var_93621cb = zombie_utility::spawn_zombie(level.monkey_zombie_spawners[0]);
		}
		if(isdefined(level.var_93621cb))
		{
			perk_attack_anim = undefined;
			if(choose == 0)
			{
				if(isdefined(level.monkey_perk_attack_anims[target_trigger.script_noteworthy]))
				{
					perk_attack_anim = level.monkey_perk_attack_anims[target_trigger.script_noteworthy][""];
				}
			}
			else
			{
				if(choose == 1)
				{
					if(isdefined(level.monkey_perk_attack_anims[target_trigger.script_noteworthy]))
					{
						perk_attack_anim = level.monkey_perk_attack_anims[target_trigger.script_noteworthy][""];
					}
				}
				else
				{
					if(choose == 2)
					{
						if(isdefined(level.monkey_perk_attack_anims[target_trigger.script_noteworthy]))
						{
							perk_attack_anim = level.monkey_perk_attack_anims[target_trigger.script_noteworthy][""];
						}
					}
					else
					{
						if(choose == 3)
						{
							if(isdefined(level.monkey_perk_attack_anims[target_trigger.script_noteworthy]))
							{
								perk_attack_anim = level.monkey_perk_attack_anims[target_trigger.script_noteworthy][""];
							}
						}
						else if(choose == 4)
						{
							if(isdefined(level.monkey_perk_attack_anims[target_trigger.script_noteworthy]))
							{
								perk_attack_anim = level.monkey_perk_attack_anims[target_trigger.script_noteworthy][""];
							}
						}
					}
				}
			}
			if(!isdefined(perk_attack_anim))
			{
				perk_attack_anim = level.monkey_perk_attack_anims[choose];
			}
			attack_spots = struct::get_array(target_trigger.machine.target, "");
			spot = undefined;
			foreach(attack_spot in attack_spots)
			{
				if(attack_spot.script_int == 1)
				{
					if(choose == 1 || choose == 2)
					{
						spot = attack_spot;
						break;
					}
				}
				if(attack_spot.script_int == 2)
				{
					if(choose == 0)
					{
						spot = attack_spot;
						break;
					}
				}
				if(attack_spot.script_int == 3)
				{
					if(choose == 3 || choose == 4)
					{
						spot = attack_spot;
						break;
					}
				}
			}
			level.var_93621cb stopanimscripted();
			level.var_93621cb notify(#"hash_cb63b091");
			level.var_93621cb thread function_a15d765e(spot, perk_attack_anim);
		}
	#/
}

/*
	Name: function_a15d765e
	Namespace: zm_cosmodrome
	Checksum: 0x1CC592ED
	Offset: 0x5F10
	Size: 0xB6
	Parameters: 2
	Flags: Linked
*/
function function_a15d765e(spot, perk_attack_anim)
{
	/#
		self endon(#"death");
		self notify(#"hash_cb63b091");
		self endon(#"hash_cb63b091");
		if(isdefined(spot))
		{
			while(true)
			{
				time = getanimlength(perk_attack_anim);
				level.var_93621cb animscripted("", spot.origin, spot.angles, perk_attack_anim);
				wait(time);
			}
		}
	#/
}

/*
	Name: function_5b312f
	Namespace: zm_cosmodrome
	Checksum: 0x3A5739D9
	Offset: 0x5FD0
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function function_5b312f()
{
	/#
		level notify(#"hash_c7d06422");
		level endon(#"hash_c7d06422");
		while(true)
		{
			foreach(spawn in level.monkey_zombie_spawners)
			{
				/#
					debugstar(spawn.origin, 6, (1, 1, 1));
				#/
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_f0357d95
	Namespace: zm_cosmodrome
	Checksum: 0x675F7C1A
	Offset: 0x60B0
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function function_f0357d95()
{
	/#
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			players[i] zm_weap_black_hole_bomb::player_give_black_hole_bomb();
		}
	#/
}

/*
	Name: function_d360e7c6
	Namespace: zm_cosmodrome
	Checksum: 0x314C3727
	Offset: 0x6128
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function function_d360e7c6()
{
	/#
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			players[i] _zm_weap_nesting_dolls::player_give_nesting_dolls();
		}
	#/
}

/*
	Name: function_d9e82452
	Namespace: zm_cosmodrome
	Checksum: 0x6013858D
	Offset: 0x61A0
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_d9e82452()
{
	/#
		level flag::wait_till("");
		zm_devgui::zombie_devgui_open_sesame();
		wait(2);
		level flag::set("");
		iprintlnbold("");
		wait(5);
		level flag::set("");
		level thread zm_cosmodrome_pack_a_punch::pack_a_punch_open_door();
	#/
}

/*
	Name: function_b8df7e30
	Namespace: zm_cosmodrome
	Checksum: 0xF16E330B
	Offset: 0x6250
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function function_b8df7e30(var_416e7c7f)
{
	/#
		level.var_6708aa9c = var_416e7c7f;
	#/
}

/*
	Name: function_83393018
	Namespace: zm_cosmodrome
	Checksum: 0xD71278A8
	Offset: 0x6278
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function function_83393018(b_cooldown)
{
	/#
		level.var_a1879e28 = b_cooldown;
	#/
}

/*
	Name: function_8a5ca1ef
	Namespace: zm_cosmodrome
	Checksum: 0xB4ADAC6E
	Offset: 0x62A0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_8a5ca1ef()
{
	/#
		if(!isdefined(level.var_ee92e6f7))
		{
			level.var_ee92e6f7 = 1;
			level.var_4a2af85f = 1;
			function_83393018(0);
		}
	#/
}

/*
	Name: function_a53ed1da
	Namespace: zm_cosmodrome
	Checksum: 0x8BEED1CF
	Offset: 0x62F0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_a53ed1da()
{
	/#
		level thread zm_cosmodrome_eggs::teleport_target(level.teleport_target, level.teleport_target);
		level flag::set("");
		util::wait_network_frame();
	#/
}

/*
	Name: function_502e7927
	Namespace: zm_cosmodrome
	Checksum: 0x6F2DC450
	Offset: 0x6358
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_502e7927()
{
	/#
		level.var_4058a336 = 1;
		level flag::set("");
		util::wait_network_frame();
	#/
}

/*
	Name: function_f567fa2e
	Namespace: zm_cosmodrome
	Checksum: 0x7D024F0B
	Offset: 0x63A8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_f567fa2e()
{
	/#
		level.var_dc7eef87 = 1;
		util::wait_network_frame();
	#/
}

/*
	Name: function_c28796c3
	Namespace: zm_cosmodrome
	Checksum: 0x4645F6AA
	Offset: 0x63D8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_c28796c3()
{
	/#
		level.var_c28796c3 = 1;
		util::wait_network_frame();
	#/
}

/*
	Name: function_c0e05145
	Namespace: zm_cosmodrome
	Checksum: 0xBB0BC511
	Offset: 0x6408
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_c0e05145()
{
	/#
		level.var_c0e05145 = 1;
		level flag::set("");
		util::wait_network_frame();
	#/
}

/*
	Name: function_55336afe
	Namespace: zm_cosmodrome
	Checksum: 0x2E7E8E25
	Offset: 0x6458
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_55336afe()
{
	/#
		level.var_55336afe = 1;
		util::wait_network_frame();
	#/
}

/*
	Name: function_620401c0
	Namespace: zm_cosmodrome
	Checksum: 0x12CA6904
	Offset: 0x6488
	Size: 0xD0
	Parameters: 4
	Flags: Linked
*/
function function_620401c0(v_org, str_msg, str_ender, n_scale)
{
	/#
		if(!isdefined(n_scale))
		{
			n_scale = 1;
		}
		self endon(str_ender);
		self thread function_9a889da5(str_msg, str_ender);
		var_ded2b0d1 = v_org - vectorscale((0, 0, 1), 16);
		while(true)
		{
			print3d(var_ded2b0d1, "", vectorscale((0, 1, 0), 255), 1, n_scale, 1);
			wait(0.1);
		}
	#/
}

/*
	Name: function_9a889da5
	Namespace: zm_cosmodrome
	Checksum: 0x9F701AB5
	Offset: 0x6560
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function function_9a889da5(str_msg, str_ender)
{
	/#
		self waittill(str_ender);
		iprintlnbold(str_msg);
	#/
}

/*
	Name: function_bb831d
	Namespace: zm_cosmodrome
	Checksum: 0x2986CF87
	Offset: 0x65A8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_bb831d(str_ender)
{
	/#
		self notify(str_ender);
		wait(0.1);
	#/
}

/*
	Name: init_level_specific_audio
	Namespace: zm_cosmodrome
	Checksum: 0xB44DAEFC
	Offset: 0x65D8
	Size: 0x384
	Parameters: 0
	Flags: Linked
*/
function init_level_specific_audio()
{
	level.vox zm_audio::zmbvoxadd("general", "door_deny", "nomoney", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "perk_deny", "nomoney", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "no_money_weapon", "nomoney", 100, 0);
	level.vox zm_audio::zmbvoxadd("eggs", "gersh_response", "cosmo_egg", 100, 0);
	level.vox zm_audio::zmbvoxadd("eggs", "meteors", "egg_pedastool", 100, 0);
	level.vox zm_audio::zmbvoxadd("eggs", "music_activate", "secret", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "teleport_gersh", "teleport_gersh_device", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "monkey_spawn", "monkey_start", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "monkey_hit", "space_monkey_hit", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "sigh", "sigh", 100, 0);
	level.vox zm_audio::zmbvoxadd("kill", "space_monkey", "kill_space_monkey", 100, 0);
	level.vox zm_audio::zmbvoxadd("kill", "gersh_device", "kill_gersh_device", 100, 0);
	level.vox zm_audio::zmbvoxadd("kill", "sickle", "kill_sickle", 100, 0);
	level.vox zm_audio::zmbvoxadd("weapon_pickup", "sickle", "wpck_sickle", 100, 0);
	level.vox zm_audio::zmbvoxadd("weapon_pickup", "dolls", "wpck_dolls", 100, 0);
	level.vox zm_audio::zmbvoxadd("weapon_pickup", "gersh", "wpck_gersh_device", 100, 0);
}

/*
	Name: function_f9572b4e
	Namespace: zm_cosmodrome
	Checksum: 0xB26F72F9
	Offset: 0x6968
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function function_f9572b4e()
{
	self notify(#"hash_f9572b4e");
	self endon(#"hash_f9572b4e");
	level flag::wait_till("initial_blackscreen_passed");
	if(!level flag::get("lander_power"))
	{
		visionset_mgr::activate("visionset", "zm_cosmodrome_no_power", self, 1);
		level flag::wait_till("lander_power");
		visionset_mgr::activate("visionset", "zm_cosmodrome_power_antic", self, 0.1, 0.01, 0.5);
		wait(0.2);
		visionset_mgr::deactivate("visionset", "zm_cosmodrome_no_power", self);
		wait(0.4);
		visionset_mgr::activate("visionset", "zm_cosmodrome_power_flare", self, 0.4, 1, 1);
	}
}

/*
	Name: function_e509f24d
	Namespace: zm_cosmodrome
	Checksum: 0x2598B1DA
	Offset: 0x6AB0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_e509f24d()
{
	callback::on_spawned(&function_f9572b4e);
}

/*
	Name: function_2c076a5e
	Namespace: zm_cosmodrome
	Checksum: 0x124F32A8
	Offset: 0x6AE0
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_2c076a5e()
{
	level clientfield::set("COSMO_VISIONSET_MONKEY", 1);
	foreach(e_player in level.players)
	{
		visionset_mgr::activate("visionset", "zm_cosmodrome_monkey_on", e_player, 3);
	}
	level clientfield::set("COSMO_VISIONSET_POWERON", 0);
}

/*
	Name: function_980a894b
	Namespace: zm_cosmodrome
	Checksum: 0xD2A7585F
	Offset: 0x6BC8
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function function_980a894b()
{
	foreach(e_player in level.players)
	{
		visionset_mgr::activate("visionset", "zm_cosmodrome_monkey_off", e_player, 0.1, 0.9, 3);
	}
	wait(0.5);
	foreach(e_player in level.players)
	{
		visionset_mgr::deactivate("visionset", "zm_cosmodrome_monkey_on", e_player);
	}
	level clientfield::set("COSMO_VISIONSET_POWERON", 1);
	level clientfield::set("COSMO_VISIONSET_MONKEY", 0);
}

/*
	Name: include_perks_in_random_rotation
	Namespace: zm_cosmodrome
	Checksum: 0x6B95D9ED
	Offset: 0x6D60
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function include_perks_in_random_rotation()
{
	zm_perk_random::include_perk_in_random_rotation("specialty_doubletap2");
	zm_perk_random::include_perk_in_random_rotation("specialty_deadshot");
	level.custom_random_perk_weights = &function_c027d01d;
}

/*
	Name: function_c027d01d
	Namespace: zm_cosmodrome
	Checksum: 0x4371387F
	Offset: 0x6DB8
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_c027d01d()
{
	temp_array = [];
	temp_array = array::randomize(temp_array);
	level._random_perk_machine_perk_list = array::randomize(level._random_perk_machine_perk_list);
	level._random_perk_machine_perk_list = arraycombine(level._random_perk_machine_perk_list, temp_array, 1, 0);
	keys = getarraykeys(level._random_perk_machine_perk_list);
	return keys;
}

