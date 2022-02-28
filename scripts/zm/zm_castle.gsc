// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\behavior_zombie_dog;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_electroball_grenade;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_electric_cherry;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_random;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerup_bonus_points_team;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_castle_demonic_rune;
#using scripts\zm\_zm_powerup_castle_tram_token;
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
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_bowie;
#using scripts\zm\_zm_weap_castle_rocketshield;
#using scripts\zm\_zm_weap_claymore;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_elemental_bow;
#using scripts\zm\_zm_weap_elemental_bow_demongate;
#using scripts\zm\_zm_weap_elemental_bow_rune_prison;
#using scripts\zm\_zm_weap_elemental_bow_storm;
#using scripts\zm\_zm_weap_elemental_bow_wolf_howl;
#using scripts\zm\_zm_weap_gravityspikes;
#using scripts\zm\_zm_weap_plunger;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\craftables\_zm_craft_shield;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_castle_achievements;
#using scripts\zm\zm_castle_characters;
#using scripts\zm\zm_castle_cleanup_mgr;
#using scripts\zm\zm_castle_craftables;
#using scripts\zm\zm_castle_death_ray_trap;
#using scripts\zm\zm_castle_dogs;
#using scripts\zm\zm_castle_ee;
#using scripts\zm\zm_castle_ee_bossfight;
#using scripts\zm\zm_castle_ee_side;
#using scripts\zm\zm_castle_ffotd;
#using scripts\zm\zm_castle_flingers;
#using scripts\zm\zm_castle_fx;
#using scripts\zm\zm_castle_gamemodes;
#using scripts\zm\zm_castle_low_grav;
#using scripts\zm\zm_castle_masher_trap;
#using scripts\zm\zm_castle_mechz;
#using scripts\zm\zm_castle_pap_quest;
#using scripts\zm\zm_castle_perks;
#using scripts\zm\zm_castle_rocket_trap;
#using scripts\zm\zm_castle_teleporter;
#using scripts\zm\zm_castle_tram;
#using scripts\zm\zm_castle_util;
#using scripts\zm\zm_castle_vo;
#using scripts\zm\zm_castle_weap_quest;
#using scripts\zm\zm_castle_weap_quest_upgrade;
#using scripts\zm\zm_castle_zombie;
#using scripts\zm\zm_castle_zones;

#namespace zm_castle;

/*
	Name: opt_in
	Namespace: zm_castle
	Checksum: 0x28FDA671
	Offset: 0x21F8
	Size: 0x4C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec opt_in()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
	level.random_pandora_box_start = 1;
	level._no_vending_machine_auto_collision = 1;
	level.pack_a_punch_camo_index = 75;
	level.pack_a_punch_camo_index_number_variants = 5;
}

/*
	Name: main
	Namespace: zm_castle
	Checksum: 0xAAC5ADA3
	Offset: 0x2250
	Size: 0xABC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	zm_castle_ffotd::main_start();
	setclearanceceiling(28);
	clientfield::register("clientuimodel", "player_lives", 5000, 2, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_shield_parts", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_fuses", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_crafted_shield", 1, 1, "int");
	clientfield::register("toplayer", "player_snow_fx", 5000, 1, "counter");
	clientfield::register("world", "snd_low_gravity_state", 5000, 2, "int");
	clientfield::register("world", "castle_fog_bank_switch", 1, 1, "int");
	spawner::add_archetype_spawn_function("zombie", &function_59909697);
	level._uses_sticky_grenades = 1;
	level._uses_taser_knuckles = 1;
	level.var_1ae26ca5 = 5;
	level.var_bd64e31e = 5;
	level.fn_custom_zombie_spawner_selection = &function_4353b980;
	level.perk_random_idle_effects_override = &function_555e8704;
	level.str_elec_damage_shellshock_override = "castle_electrocution_zm";
	adddebugcommand("devgui_cmd \"ZM/Perks/Drink Dead Shot Daiquir (Castle)i:7\" \"zombie_devgui specialty_deadshot_castle\"\n");
	adddebugcommand("devgui_cmd \"ZM/Perks/Drink Widow's Wine (Castle):9\" \"zombie_devgui specialty_widowswine_castle\"\n");
	adddebugcommand("devgui_cmd \"ZM/Perks/Drink Electric Cherry (Castle):10\" \"zombie_devgui specialty_electriccherry_castle\"\n");
	adddebugcommand("devgui_cmd \"ZM/Perks/Remove All Perks (Castle):0\" \"zombie_devgui remove_perks_castle\"\n");
	adddebugcommand("devgui_cmd \"ZM/AI/Toggle_Skeletons (Castle):0\" \"zombie_devgui toggle_skeletons_castle\"\n");
	level.custom_devgui = &function_fcfd712e;
	level flag::init("rocket_firing");
	zm::init_fx();
	zm_castle_fx::main();
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["animscript_gib_fx"] = "weapon/bullet/fx_flesh_gib_fatal_01";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["raven_death_fx"] = "dlc1/castle/fx_raven_death";
	level._effect["raven_feather_fx"] = "dlc1/castle/fx_raven_death_feathers";
	level._effect["switch_sparks"] = "electric/fx_elec_sparks_directional_orange";
	level.default_start_location = "start_room";
	level.default_game_mode = "zclassic";
	callback::on_spawned(&on_player_spawned);
	callback::on_connect(&on_player_connect);
	level.has_richtofen = 0;
	level.precachecustomcharacters = &zm_castle_characters::precachecustomcharacters;
	level.givecustomcharacters = &zm_castle_characters::givecustomcharacters;
	level thread setup_personality_character_exerts();
	zm_castle_characters::initcharacterstartindex();
	level.register_offhand_weapons_for_level_defaults_override = &offhand_weapon_overrride;
	level.zombiemode_offhand_weapon_give_override = &offhand_weapon_give_override;
	level.sndweaponpickupoverride = array("elemental_bow", "elemental_bow_demongate", "elemental_bow_rune_prison", "elemental_bow_storm", "elemental_bow_wolf_howl");
	level.craft_shield_piece_pickup_vo_override = &zm_castle_vo::function_43b44df3;
	level._zombie_custom_add_weapons = &custom_add_weapons;
	level thread custom_add_vox();
	level._allow_melee_weapon_switching = 1;
	level.enemy_location_override_func = &enemy_location_override;
	level.no_target_override = &no_target_override;
	level.minigun_damage_adjust_override = &function_ec8a9331;
	level.var_2d0e5eb6 = &function_8921895f;
	level.var_9aaae7ae = &function_869d6f66;
	level.var_2d4e3645 = &function_d9e1ec4d;
	level.var_9cef605e = &function_98a0818e;
	level.gravityspike_position_check = &function_6190ec3f;
	level.player_score_override = &function_77b8a0f7;
	level.team_score_override = &function_5a64329b;
	level.var_4e84030d = &function_f9a3207d;
	level.gravityspikes_target_filter_callback = &function_862e966e;
	level._zombie_custom_spawn_logic = &function_639f3b62;
	level.zm_custom_spawn_location_selection = &function_c624f0b2;
	level.player_out_of_playable_area_monitor_callback = &player_out_of_playable_area_monitor_callback;
	level.debug_keyline_zombies = 0;
	zm_castle_flingers::function_976c9217();
	include_perks_in_random_rotation();
	zm_castle_death_ray_trap::main();
	zm_castle_rocket_trap::main();
	level thread zm_castle_masher_trap::main();
	level thread function_69573a4c();
	level thread function_e0836624();
	level thread zm_castle_ee::main();
	level thread zm_castle_ee_bossfight::init();
	level thread zm_castle_ee_side::main();
	zm_castle_perks::init();
	zm_craftables::init();
	zm_castle_craftables::randomize_craftable_spawns();
	zm_castle_craftables::include_craftables();
	zm_castle_craftables::init_craftables();
	load::main();
	level._powerup_grab_check = &function_9b56d76;
	level thread function_13fc99fa();
	level.dog_round_track_override = &zm_castle_dogs::dog_round_tracker;
	level.custom_dog_target_validity_check = &zm_castle_dogs::function_1aaa22b5;
	level.fn_custom_round_ai_spawn = &zm_castle_dogs::function_33aa4940;
	level.dog_spawn_func = &zm_castle_dogs::function_92e4eaff;
	level.dog_setup_func = &zm_castle_dogs::function_8cf500c9;
	level.dog_rounds_allowed = getgametypesetting("allowdogs");
	if(level.dog_rounds_allowed)
	{
		zm_ai_dogs::enable_dog_rounds();
	}
	zm_castle_mechz::enable_mechz_rounds();
	zombie_utility::set_zombie_var("below_world_check", -2500);
	level thread function_6058f34d();
	level thread function_a691b3f6();
	level thread power_electric_switch();
	level thread function_632e15ea();
	level thread function_a6477691();
	level thread function_9be4ecd1();
	_zm_weap_cymbal_monkey::init();
	level._round_start_func = &zm::round_start;
	level.powerup_fx_func = &function_c7d8dba7;
	init_sounds();
	level.zones = [];
	level.zone_manager_init_func = &zm_castle_zones::init;
	level thread zm_zonemgr::manage_zones(array("zone_start"));
	level thread intro_screen();
	level thread setupmusic();
	level.zone_occupied_func = &function_1ba33179;
	setdvar("hkai_pathfindIterationLimit", 1000);
	/#
		level thread function_287ae5ec();
	#/
	zm_castle_ffotd::main_end();
}

/*
	Name: function_59909697
	Namespace: zm_castle
	Checksum: 0x3C0A900A
	Offset: 0x2D18
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_59909697()
{
	if(issubstr(self.model, "skeleton"))
	{
		self hidepart("tag_weapon_left");
		self hidepart("tag_weapon_right");
	}
}

/*
	Name: function_4353b980
	Namespace: zm_castle
	Checksum: 0xA3EBF435
	Offset: 0x2D88
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function function_4353b980()
{
	if(!isdefined(level.var_2c78e44c))
	{
		level.var_a70b4aef = [];
		level.var_2c78e44c = [];
		foreach(e_spawner in level.zombie_spawners)
		{
			if(e_spawner.targetname === "skeleton_spawner")
			{
				if(!isdefined(level.var_2c78e44c))
				{
					level.var_2c78e44c = [];
				}
				else if(!isarray(level.var_2c78e44c))
				{
					level.var_2c78e44c = array(level.var_2c78e44c);
				}
				level.var_2c78e44c[level.var_2c78e44c.size] = e_spawner;
				continue;
			}
			if(!isdefined(level.var_a70b4aef))
			{
				level.var_a70b4aef = [];
			}
			else if(!isarray(level.var_a70b4aef))
			{
				level.var_a70b4aef = array(level.var_a70b4aef);
			}
			level.var_a70b4aef[level.var_a70b4aef.size] = e_spawner;
		}
	}
	if(level.var_9bf9e084 === 1)
	{
		sp_zombie = array::random(level.var_2c78e44c);
	}
	else
	{
		sp_zombie = array::random(level.var_a70b4aef);
	}
	return sp_zombie;
}

/*
	Name: function_1ba33179
	Namespace: zm_castle
	Checksum: 0xCC617185
	Offset: 0x2F80
	Size: 0x184
	Parameters: 1
	Flags: Linked
*/
function function_1ba33179(zone_name)
{
	if(!zm_zonemgr::zone_is_enabled(zone_name))
	{
		return false;
	}
	var_46ac7dc1 = 0;
	if(zone_name == "zone_v10_pad" || zone_name == "zone_v10_pad_exterior")
	{
		var_46ac7dc1 = 1;
	}
	zone = level.zones[zone_name];
	for(i = 0; i < zone.volumes.size; i++)
	{
		players = getplayers();
		for(j = 0; j < players.size; j++)
		{
			if(players[j] istouching(zone.volumes[i]) && !players[j].sessionstate == "spectator")
			{
				if(!var_46ac7dc1 || !players[j] laststand::player_is_in_laststand())
				{
					return true;
				}
			}
		}
	}
	return false;
}

/*
	Name: function_e0836624
	Namespace: zm_castle
	Checksum: 0xCF971DCA
	Offset: 0x3110
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_e0836624()
{
	level endon(#"end_game");
	level notify(#"hash_a3369c1f");
	level endon(#"hash_a3369c1f");
	while(true)
	{
		level waittill(#"host_migration_end");
		setdvar("doublejump_enabled", 1);
		setdvar("playerEnergy_enabled", 1);
		setdvar("wallrun_enabled", 1);
	}
}

/*
	Name: function_fcfd712e
	Namespace: zm_castle
	Checksum: 0x3C52D705
	Offset: 0x31B8
	Size: 0x356
	Parameters: 1
	Flags: Linked
*/
function function_fcfd712e(cmd)
{
	cmd_strings = strtok(cmd, " ");
	var_8ceb4930 = getent("specialty_doubletap2", "script_noteworthy");
	switch(cmd_strings[0])
	{
		case "specialty_deadshot_castle":
		{
			foreach(player in level.players)
			{
				var_8ceb4930 zm_perks::vending_trigger_post_think(player, "specialty_deadshot");
			}
			break;
		}
		case "specialty_widowswine_castle":
		{
			foreach(player in level.players)
			{
				var_8ceb4930 zm_perks::vending_trigger_post_think(player, "specialty_widowswine");
			}
			break;
		}
		case "specialty_electriccherry_castle":
		{
			foreach(player in level.players)
			{
				var_8ceb4930 zm_perks::vending_trigger_post_think(player, "specialty_electriccherry");
			}
			break;
		}
		case "remove_perks_castle":
		{
			zm_devgui::zombie_devgui_take_perks();
			foreach(player in level.players)
			{
				player notify("specialty_deadshot" + "_stop");
				player notify("specialty_widowswine" + "_stop");
				player notify("specialty_electriccherry" + "_stop");
			}
			break;
		}
		case "toggle_skeletons_castle":
		{
			if(level.var_9bf9e084 !== 1)
			{
				level.var_9bf9e084 = 1;
			}
			else
			{
				level.var_9bf9e084 = 0;
			}
			break;
		}
	}
}

/*
	Name: player_out_of_playable_area_monitor_callback
	Namespace: zm_castle
	Checksum: 0x4E4A29D5
	Offset: 0x3518
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function player_out_of_playable_area_monitor_callback()
{
	if(isdefined(self.is_flung) && self.is_flung)
	{
		return false;
	}
	if(isdefined(self.teleport_origin))
	{
		return false;
	}
	return true;
}

/*
	Name: function_9b56d76
	Namespace: zm_castle
	Checksum: 0xC673219A
	Offset: 0x3558
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_9b56d76(player)
{
	if(self.powerup_name == "castle_tram_token" && player clientfield::get_to_player("has_castle_tram_token"))
	{
		player thread function_f42077ff();
		return false;
	}
	return true;
}

/*
	Name: function_f42077ff
	Namespace: zm_castle
	Checksum: 0x5206158
	Offset: 0x35C0
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function function_f42077ff()
{
	if(!(isdefined(self.var_378aff9e) && self.var_378aff9e))
	{
		self.var_378aff9e = 1;
		self thread zm_equipment::show_hint_text(&"ZM_CASTLE_TRAM_TOKEN_DENIED", 3);
		wait(6);
		self.var_378aff9e = undefined;
	}
}

/*
	Name: init_sounds
	Namespace: zm_castle
	Checksum: 0x516A46C3
	Offset: 0x3630
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function init_sounds()
{
	zm_utility::add_sound("break_stone", "evt_break_stone");
	zm_utility::add_sound("gate_door", "zmb_gate_slide_open");
	zm_utility::add_sound("heavy_door", "zmb_heavy_door_open");
	zm_utility::add_sound("zmb_heavy_door_open", "zmb_heavy_door_open");
}

/*
	Name: offhand_weapon_overrride
	Namespace: zm_castle
	Checksum: 0xD48D3001
	Offset: 0x36C0
	Size: 0xBE
	Parameters: 0
	Flags: Linked
*/
function offhand_weapon_overrride()
{
	zm_utility::register_lethal_grenade_for_level("frag_grenade");
	level.zombie_lethal_grenade_player_init = getweapon("frag_grenade");
	zm_utility::register_tactical_grenade_for_level("cymbal_monkey");
	zm_utility::register_melee_weapon_for_level(level.weaponbasemelee.name);
	zm_utility::register_melee_weapon_for_level("bowie_knife");
	zm_utility::register_melee_weapon_for_level("knife_plunger");
	level.zombie_melee_weapon_player_init = level.weaponbasemelee;
	level.zombie_equipment_player_init = undefined;
}

/*
	Name: offhand_weapon_give_override
	Namespace: zm_castle
	Checksum: 0x6FA2FF21
	Offset: 0x3788
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function offhand_weapon_give_override(str_weapon)
{
	self endon(#"death");
	if(zm_utility::is_tactical_grenade(str_weapon) && isdefined(self zm_utility::get_player_tactical_grenade()) && !self zm_utility::is_player_tactical_grenade(str_weapon))
	{
		self setweaponammoclip(self zm_utility::get_player_tactical_grenade(), 0);
		self takeweapon(self zm_utility::get_player_tactical_grenade());
	}
	return false;
}

/*
	Name: function_f9a3207d
	Namespace: zm_castle
	Checksum: 0x139A2232
	Offset: 0x3850
	Size: 0x138
	Parameters: 1
	Flags: Linked
*/
function function_f9a3207d(ai_enemy)
{
	return isdefined(ai_enemy) && !issubstr(ai_enemy.classname, "keeper") && (ai_enemy.archetype !== "mechz" || (ai_enemy.archetype == "mechz" && (isdefined(ai_enemy.b_flyin_done) && ai_enemy.b_flyin_done))) && (!(isdefined(ai_enemy.var_1ea49cd7) && ai_enemy.var_1ea49cd7)) && (!(isdefined(ai_enemy.var_bce6e774) && ai_enemy.var_bce6e774)) && (!(isdefined(ai_enemy.in_gravity_trap) && ai_enemy.in_gravity_trap)) && (!(isdefined(ai_enemy.b_melee_kill) && ai_enemy.b_melee_kill));
}

/*
	Name: function_862e966e
	Namespace: zm_castle
	Checksum: 0x55FF21BE
	Offset: 0x3990
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function function_862e966e(ai_enemy)
{
	return !(isdefined(ai_enemy.var_98056717) && ai_enemy.var_98056717);
}

/*
	Name: intro_screen
	Namespace: zm_castle
	Checksum: 0x211A01EA
	Offset: 0x39C8
	Size: 0x244
	Parameters: 0
	Flags: Linked
*/
function intro_screen()
{
	if(1 == getdvarint("movie_intro"))
	{
		return;
	}
	level flag::wait_till("start_zombie_round_logic");
	wait(2);
	level.intro_hud = newhudelem();
	level.intro_hud.x = 0;
	level.intro_hud.y = 0;
	level.intro_hud.alignx = "left";
	level.intro_hud.aligny = "bottom";
	level.intro_hud.horzalign = "left";
	level.intro_hud.vertalign = "bottom";
	level.intro_hud.foreground = 1;
	if(level.splitscreen && !level.hidef)
	{
		level.intro_hud.fontscale = 2.75;
	}
	else
	{
		level.intro_hud.fontscale = 1.75;
	}
	level.intro_hud.alpha = 0;
	level.intro_hud.color = (1, 1, 1);
	level.intro_hud.inuse = 0;
	level.intro_hud.y = -110;
	level.intro_hud fadeovertime(3.5);
	level.intro_hud.alpha = 1;
	level notify(#"hash_59e5a3dd");
	wait(6);
	level.intro_hud fadeovertime(3.5);
	level.intro_hud.alpha = 0;
	wait(4.5);
	level.intro_hud destroy();
}

/*
	Name: custom_add_weapons
	Namespace: zm_castle
	Checksum: 0x7AE90265
	Offset: 0x3C18
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_castle_weapons.csv", 1);
	zm_weapons::autofill_wallbuys_init();
}

/*
	Name: custom_add_vox
	Namespace: zm_castle
	Checksum: 0x15223B0F
	Offset: 0x3C58
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function custom_add_vox()
{
	zm_audio::loadplayervoicecategories("gamedata/audio/zm/zm_castle_vox.csv");
}

/*
	Name: setupmusic
	Namespace: zm_castle
	Checksum: 0x618ACB38
	Offset: 0x3C80
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function setupmusic()
{
	zm_audio::musicstate_create("round_start", 3, "castle_roundstart_1");
	zm_audio::musicstate_create("round_start_short", 3, "castle_roundstart_1");
	zm_audio::musicstate_create("round_start_first", 3, "castle_roundstart_1");
	zm_audio::musicstate_create("round_end", 3, "castle_roundend_1", "castle_roundend_2", "castle_roundend_3");
	zm_audio::musicstate_create("game_over", 5, "castle_gameover");
	zm_audio::musicstate_create("location_lab", 4, "castle_location_lab");
	zm_audio::musicstate_create("requiem", 4, "requiem");
	zm_audio::musicstate_create("dead_again", 4, "dead_again");
	zm_audio::musicstate_create("moon_rockets", 4, "moon_rockets");
	zm_audio::musicstate_create("none", 4, "none");
	array = getentarray("sndMusicLocationTrig", "targetname");
	array::thread_all(array, &function_44dc3fb4);
}

/*
	Name: function_44dc3fb4
	Namespace: zm_castle
	Checksum: 0xC5C236C2
	Offset: 0x3E80
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function function_44dc3fb4()
{
	while(true)
	{
		self waittill(#"trigger", trigplayer);
		if(isplayer(trigplayer))
		{
			if(self.script_sound == "richtofen")
			{
				return;
			}
			zm_audio::sndmusicsystem_playstate("location_" + self.script_sound);
			return;
		}
		wait(0.016);
	}
}

/*
	Name: on_player_spawned
	Namespace: zm_castle
	Checksum: 0xCF98B747
	Offset: 0x3F18
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self allowwallrun(0);
	self allowdoublejump(0);
	self.var_7dd18a0 = 0;
	self.tesla_network_death_choke = 0;
	self.var_b94b5f2f = 1;
	if(!level flag::get("pap_reformed"))
	{
		self thread zm_castle_pap_quest::function_b9cca08f();
	}
	level flag::wait_till("start_zombie_round_logic");
	wait(0.05);
	self clientfield::increment_to_player("player_snow_fx");
}

/*
	Name: on_player_connect
	Namespace: zm_castle
	Checksum: 0x53EDF0E4
	Offset: 0x3FF8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self thread zm_castle_low_grav::function_c3f6aa22();
	self thread function_30cebef9();
}

/*
	Name: include_perks_in_random_rotation
	Namespace: zm_castle
	Checksum: 0x48B5CC2B
	Offset: 0x4038
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function include_perks_in_random_rotation()
{
	zm_perk_random::include_perk_in_random_rotation("specialty_armorvest");
	zm_perk_random::include_perk_in_random_rotation("specialty_quickrevive");
	zm_perk_random::include_perk_in_random_rotation("specialty_fastreload");
	zm_perk_random::include_perk_in_random_rotation("specialty_doubletap2");
	zm_perk_random::include_perk_in_random_rotation("specialty_staminup");
	zm_perk_random::include_perk_in_random_rotation("specialty_additionalprimaryweapon");
	zm_perk_random::include_perk_in_random_rotation("specialty_deadshot");
	zm_perk_random::include_perk_in_random_rotation("specialty_electriccherry");
	zm_perk_random::include_perk_in_random_rotation("specialty_widowswine");
	level.custom_random_perk_weights = &function_798c5d1a;
}

/*
	Name: function_798c5d1a
	Namespace: zm_castle
	Checksum: 0x5B599423
	Offset: 0x4138
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_798c5d1a()
{
	temp_array = [];
	if(randomint(4) == 0)
	{
		arrayinsert(temp_array, "specialty_doubletap2", 0);
	}
	if(randomint(4) == 0)
	{
		arrayinsert(temp_array, "specialty_deadshot", 0);
	}
	if(randomint(4) == 0)
	{
		arrayinsert(temp_array, "specialty_additionalprimaryweapon", 0);
	}
	if(randomint(4) == 0)
	{
		arrayinsert(temp_array, "specialty_electriccherry", 0);
	}
	temp_array = array::randomize(temp_array);
	level._random_perk_machine_perk_list = array::randomize(level._random_perk_machine_perk_list);
	level._random_perk_machine_perk_list = arraycombine(level._random_perk_machine_perk_list, temp_array, 1, 0);
	keys = getarraykeys(level._random_perk_machine_perk_list);
	return keys;
}

/*
	Name: enemy_location_override
	Namespace: zm_castle
	Checksum: 0x820A6223
	Offset: 0x42E8
	Size: 0x10E
	Parameters: 2
	Flags: Linked
*/
function enemy_location_override(ai_zombie, ai_enemy)
{
	aiprofile_beginentry("castle-enemy_location_override");
	if(isplayer(ai_enemy) && ai_enemy zm_zonemgr::entity_in_zone("zone_undercroft") && (ai_enemy iswallrunning() || !ai_enemy isonground()))
	{
		if(!isdefined(ai_enemy.v_ground_pos))
		{
			ai_enemy thread function_d578bf1a();
		}
		if(isdefined(ai_enemy.v_ground_pos))
		{
			aiprofile_endentry();
			return ai_enemy.v_ground_pos;
		}
	}
	aiprofile_endentry();
	return undefined;
}

/*
	Name: function_d578bf1a
	Namespace: zm_castle
	Checksum: 0x27EB61E7
	Offset: 0x4400
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function function_d578bf1a()
{
	self endon(#"death");
	while(self zm_zonemgr::entity_in_zone("zone_undercroft") && (self iswallrunning() || !self isonground()))
	{
		var_24ab58cb = groundtrace(self.origin, self.origin + (vectorscale((0, 0, -1), 10000)), 0, undefined)["position"];
		self.v_ground_pos = getclosestpointonnavmesh(var_24ab58cb, 256);
		wait(0.5);
	}
	self.v_ground_pos = undefined;
}

/*
	Name: function_c7d8dba7
	Namespace: zm_castle
	Checksum: 0x153EECDE
	Offset: 0x44F0
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function function_c7d8dba7()
{
	if(self.powerup_name === "castle_tram_token")
	{
		self clientfield::set("powerup_fuse_fx", 1);
	}
	else
	{
		if(issubstr(self.powerup_name, "demonic_rune"))
		{
			self clientfield::set("demonic_rune_fx", 1);
		}
		else
		{
			if(self.only_affects_grabber)
			{
				self clientfield::set("powerup_fx", 2);
			}
			else
			{
				if(self.any_team)
				{
					self clientfield::set("powerup_fx", 4);
				}
				else
				{
					if(self.zombie_grabbable)
					{
						self clientfield::set("powerup_fx", 3);
					}
					else
					{
						self clientfield::set("powerup_fx", 1);
					}
				}
			}
		}
	}
}

/*
	Name: function_632e15ea
	Namespace: zm_castle
	Checksum: 0x83FCBBF4
	Offset: 0x4638
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_632e15ea()
{
	level thread function_814261d();
	level thread function_4da48892();
	level thread function_9c99c6db();
	level thread function_5dd2bbf1();
	var_b549e63 = getent("great_hall_outer_door", "script_noteworthy");
	var_8907f940 = getent("great_hall_inner_door", "script_noteworthy");
	var_8907f940 linkto(var_b549e63);
}

/*
	Name: function_814261d
	Namespace: zm_castle
	Checksum: 0x780BDCF6
	Offset: 0x4720
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_814261d()
{
	level thread scene::init("p7_fxanim_zm_castle_barricade_great_hall_left_bundle");
	level thread scene::init("p7_fxanim_zm_castle_barricade_great_hall_right_bundle");
	exploder::exploder("fxexp_112");
	level flag::wait_till("connect_courtyard_to_greathall_upper");
	level thread scene::play("p7_fxanim_zm_castle_barricade_great_hall_left_bundle");
	level thread scene::play("p7_fxanim_zm_castle_barricade_great_hall_right_bundle");
	exploder::exploder_stop("fxexp_112");
}

/*
	Name: function_4da48892
	Namespace: zm_castle
	Checksum: 0x1B8574A5
	Offset: 0x4800
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_4da48892()
{
	level thread scene::init("p7_fxanim_zm_castle_barricade_living_quart_bundle");
	exploder::exploder("fxexp_110");
	level flag::wait_till("connect_lowercourtyard_to_livingquarters");
	level thread scene::play("p7_fxanim_zm_castle_barricade_living_quart_bundle");
	exploder::exploder_stop("fxexp_110");
}

/*
	Name: function_9c99c6db
	Namespace: zm_castle
	Checksum: 0x8CB1DF24
	Offset: 0x48A0
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_9c99c6db()
{
	level thread scene::init("p7_fxanim_zm_castle_barricade_trophy_room_bundle");
	exploder::exploder("fxexp_111");
	level flag::wait_till("connect_subclocktower_to_courtyard");
	level thread scene::play("p7_fxanim_zm_castle_barricade_trophy_room_bundle");
	exploder::exploder_stop("fxexp_111");
}

/*
	Name: function_5dd2bbf1
	Namespace: zm_castle
	Checksum: 0xAA40E61B
	Offset: 0x4940
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function function_5dd2bbf1()
{
	level flag::wait_till("power_on");
	e_door_clip = getent("dungeon_door_clip", "targetname");
	e_door_clip delete();
	e_door_left = getent("dungeon_door_left", "targetname");
	e_door_right = getent("dungeon_door_right", "targetname");
	e_door_left movex(-40, 2, 0, 1);
	e_door_right movex(40, 2, 0, 1);
}

/*
	Name: function_8921895f
	Namespace: zm_castle
	Checksum: 0x26DF79A3
	Offset: 0x4A58
	Size: 0x1B0
	Parameters: 0
	Flags: Linked
*/
function function_8921895f()
{
	var_cdb0f86b = getarraykeys(level.zombie_powerups);
	var_b4442b55 = array("bonus_points_team", "shield_charge", "ww_grenade", "demonic_rune_lor", "demonic_rune_mar", "demonic_rune_oth", "demonic_rune_uja", "demonic_rune_ulla", "demonic_rune_zor");
	var_d7a75a6e = [];
	for(i = 0; i < var_cdb0f86b.size; i++)
	{
		var_77917a61 = 0;
		foreach(var_68de493a in var_b4442b55)
		{
			if(var_cdb0f86b[i] == var_68de493a)
			{
				var_77917a61 = 1;
			}
		}
		if(var_77917a61)
		{
			continue;
			continue;
		}
		var_d7a75a6e[var_d7a75a6e.size] = var_cdb0f86b[i];
	}
	var_d7a75a6e = array::randomize(var_d7a75a6e);
	return var_d7a75a6e[0];
}

/*
	Name: function_98a0818e
	Namespace: zm_castle
	Checksum: 0xE78157FE
	Offset: 0x4C10
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function function_98a0818e()
{
	if(isdefined(self.is_flung) && self.is_flung || (isdefined(self.var_9a017681) && self.var_9a017681) || (isdefined(self.var_c7a6615d) && self.var_c7a6615d))
	{
		return false;
	}
	if(isdefined(self.b_teleporting) && self.b_teleporting)
	{
		return false;
	}
	return true;
}

/*
	Name: function_869d6f66
	Namespace: zm_castle
	Checksum: 0x83B36AFF
	Offset: 0x4C88
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function function_869d6f66()
{
	if(!isdefined(self zm_bgb_anywhere_but_here::function_728dfe3()))
	{
		return false;
	}
	if(level flag::get("boss_fight_begin") && !level flag::get("boss_fight_completed"))
	{
		return false;
	}
	return true;
}

/*
	Name: function_d9e1ec4d
	Namespace: zm_castle
	Checksum: 0x5D82E55D
	Offset: 0x4D00
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function function_d9e1ec4d(var_bbf77908)
{
	if(level flag::get("rocket_firing"))
	{
		var_ea555b15 = struct::get("zone_v10_pad_exterior", "script_noteworthy");
		arrayremovevalue(var_bbf77908, var_ea555b15);
	}
	return var_bbf77908;
}

/*
	Name: function_6190ec3f
	Namespace: zm_castle
	Checksum: 0x6767E5C3
	Offset: 0x4D80
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_6190ec3f()
{
	var_3592813c = getent("player_tram_car_interior", "targetname");
	var_a799f077 = getent("docked_tram_car_interior", "targetname");
	if(!ispointonnavmesh(self.origin, self) || self istouching(var_3592813c) || self istouching(var_a799f077))
	{
		self thread zm_equipment::show_hint_text(&"ZM_CASTLE_GRAVITYSPIKE_BAD_LOCATION", 3);
		return false;
	}
	return true;
}

/*
	Name: function_77b8a0f7
	Namespace: zm_castle
	Checksum: 0x65FBFF6C
	Offset: 0x4E68
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function function_77b8a0f7(var_2f7fd5db, n_points)
{
	if(!isdefined(n_points))
	{
		return 0;
	}
	if(var_2f7fd5db === getweapon("hero_gravityspikes_melee") && n_points > 20)
	{
		n_points = 20;
	}
	return n_points;
}

/*
	Name: function_5a64329b
	Namespace: zm_castle
	Checksum: 0x9DA01FF
	Offset: 0x4ED0
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function function_5a64329b(var_2f7fd5db, n_points)
{
	if(var_2f7fd5db === getweapon("hero_gravityspikes_melee"))
	{
		n_points = 0;
	}
	return n_points;
}

/*
	Name: no_target_override
	Namespace: zm_castle
	Checksum: 0x56E64A74
	Offset: 0x4F20
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function no_target_override(ai_zombie)
{
	if(isdefined(self.b_zombie_path_bad) && self.b_zombie_path_bad)
	{
		return;
	}
	var_b52b26b9 = ai_zombie get_escape_position();
	ai_zombie thread function_dc683d01(var_b52b26b9);
}

/*
	Name: get_escape_position
	Namespace: zm_castle
	Checksum: 0x1D9C2041
	Offset: 0x4F90
	Size: 0x146
	Parameters: 0
	Flags: Linked, Private
*/
function private get_escape_position()
{
	str_zone = zm_zonemgr::get_zone_from_position(self.origin + vectorscale((0, 0, 1), 32), 1);
	if(!isdefined(str_zone))
	{
		str_zone = self.zone_name;
	}
	if(isdefined(str_zone))
	{
		a_zones = castle_cleanup::get_adjacencies_to_zone(str_zone);
		a_wait_locations = get_wait_locations_in_zones(a_zones);
		arraysortclosest(a_wait_locations, self.origin);
		a_wait_locations = array::reverse(a_wait_locations);
		for(i = 0; i < a_wait_locations.size; i++)
		{
			if(a_wait_locations[i] function_eadbcbdb())
			{
				return a_wait_locations[i].origin;
			}
		}
	}
	return self.origin;
}

/*
	Name: get_wait_locations_in_zones
	Namespace: zm_castle
	Checksum: 0xDDE154DA
	Offset: 0x50E0
	Size: 0xD2
	Parameters: 1
	Flags: Linked, Private
*/
function private get_wait_locations_in_zones(a_zones)
{
	a_wait_locations = [];
	foreach(zone in a_zones)
	{
		a_wait_locations = arraycombine(a_wait_locations, level.zones[zone].a_loc_types["wait_location"], 0, 0);
	}
	return a_wait_locations;
}

/*
	Name: function_eadbcbdb
	Namespace: zm_castle
	Checksum: 0x7D5CAA67
	Offset: 0x51C0
	Size: 0x5C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_eadbcbdb()
{
	if(!isdefined(self))
	{
		return false;
	}
	if(!ispointonnavmesh(self.origin) || !zm_utility::check_point_in_playable_area(self.origin))
	{
		return false;
	}
	return true;
}

/*
	Name: function_dc683d01
	Namespace: zm_castle
	Checksum: 0x65126481
	Offset: 0x5228
	Size: 0xCA
	Parameters: 1
	Flags: Linked, Private
*/
function private function_dc683d01(var_b52b26b9)
{
	self endon(#"death");
	self notify(#"stop_find_flesh");
	self notify(#"zombie_acquire_enemy");
	self.ignoreall = 1;
	self.b_zombie_path_bad = 1;
	self thread check_player_available();
	self setgoal(var_b52b26b9);
	self util::waittill_any_timeout(30, "goal", "reaquire_player", "death");
	self.ai_state = "find_flesh";
	self.ignoreall = 0;
	self.b_zombie_path_bad = undefined;
}

/*
	Name: check_player_available
	Namespace: zm_castle
	Checksum: 0xE2BF1D0C
	Offset: 0x5300
	Size: 0x78
	Parameters: 0
	Flags: Linked, Private
*/
function private check_player_available()
{
	self endon(#"death");
	while(isdefined(self.b_zombie_path_bad) && self.b_zombie_path_bad)
	{
		wait(randomfloatrange(0.2, 0.5));
		if(self can_zombie_see_any_player())
		{
			self.b_zombie_path_bad = undefined;
			self notify(#"reaquire_player");
			return;
		}
	}
}

/*
	Name: can_zombie_see_any_player
	Namespace: zm_castle
	Checksum: 0xA9A4174B
	Offset: 0x5380
	Size: 0x80
	Parameters: 0
	Flags: Linked, Private
*/
function private can_zombie_see_any_player()
{
	for(i = 0; i < level.activeplayers.size; i++)
	{
		if(zombie_utility::is_player_valid(level.activeplayers[i]))
		{
			if(self zm_castle_zombie::function_7b63bf24(level.activeplayers[i]))
			{
				return true;
			}
		}
		wait(0.1);
	}
	return false;
}

/*
	Name: function_c624f0b2
	Namespace: zm_castle
	Checksum: 0x94DB125E
	Offset: 0x5408
	Size: 0x16C
	Parameters: 1
	Flags: Linked
*/
function function_c624f0b2(a_spots)
{
	if(math::cointoss())
	{
		if(!isdefined(level.n_player_spawn_selection_index))
		{
			level.n_player_spawn_selection_index = 0;
		}
		e_player = level.players[level.n_player_spawn_selection_index];
		level.n_player_spawn_selection_index++;
		if(level.n_player_spawn_selection_index > (level.players.size - 1))
		{
			level.n_player_spawn_selection_index = 0;
		}
		if(!zm_utility::is_player_valid(e_player))
		{
			s_spot = array::random(a_spots);
			return s_spot;
		}
		var_e8c67fc0 = array::get_all_closest(e_player.origin, a_spots, undefined, 5);
		if(var_e8c67fc0.size)
		{
			s_spot = array::random(var_e8c67fc0);
		}
		else
		{
			s_spot = array::random(a_spots);
		}
	}
	else
	{
		s_spot = array::random(a_spots);
	}
	return s_spot;
}

/*
	Name: function_69573a4c
	Namespace: zm_castle
	Checksum: 0x48CFDB36
	Offset: 0x5580
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_69573a4c()
{
	scene::add_scene_func("p7_fxanim_gp_raven_idle_eating_bundle", &function_f7046db2, "play");
}

/*
	Name: function_f7046db2
	Namespace: zm_castle
	Checksum: 0x344EA73A
	Offset: 0x55C0
	Size: 0x164
	Parameters: 1
	Flags: Linked
*/
function function_f7046db2(a_ents)
{
	var_9be38c79 = a_ents["raven_idle"];
	if(isdefined(var_9be38c79))
	{
		var_9be38c79 setcandamage(1);
		var_9be38c79.health = 100000;
		var_9be38c79 thread function_a8aef7fe();
		var_9be38c79 waittill(#"damage", n_amount, e_attacker, v_direction, v_point, str_type);
		var_9be38c79 playsound("amb_castle_raven_death");
		playfxontag(level._effect["raven_death_fx"], var_9be38c79, "j_pelvis");
		playfxontag(level._effect["raven_feather_fx"], var_9be38c79, "j_pelvis");
		util::wait_network_frame();
		var_9be38c79 delete();
	}
}

/*
	Name: function_a8aef7fe
	Namespace: zm_castle
	Checksum: 0x7A570D8A
	Offset: 0x5730
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_a8aef7fe()
{
	self endon(#"damage");
	self endon(#"death");
	wait(randomintrange(3, 9));
	while(true)
	{
		self playsound("amb_castle_raven_caw");
		wait(randomintrange(11, 21));
	}
}

/*
	Name: function_6058f34d
	Namespace: zm_castle
	Checksum: 0x9AE15467
	Offset: 0x57B0
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function function_6058f34d()
{
	exploder::exploder("power_door_lgts");
	level flag::wait_till("power_on");
	exploder::exploder("exp_lgt_power_on");
	exploder::exploder("lgt_vending_doubletap2_castle");
	exploder::exploder("lgt_vending_juggernaut_castle");
	exploder::exploder("lgt_vending_mule_kick_castle");
	exploder::exploder("lgt_vending_quick_revive_castle");
	exploder::exploder("lgt_vending_sleight_of_hand_castle");
	exploder::exploder("lgt_vending_stamina_up_castle");
	playsoundatposition("zmb_castle_poweron", (0, 0, 0));
	exploder::exploder_stop("power_door_lgts");
	level thread scene::play("p7_fxanim_zm_castle_door_sliding_bundle");
}

/*
	Name: function_a691b3f6
	Namespace: zm_castle
	Checksum: 0x6720595F
	Offset: 0x58F8
	Size: 0x1E2
	Parameters: 0
	Flags: Linked
*/
function function_a691b3f6()
{
	level scene::init("p7_fxanim_zm_castle_rocket_01_bundle");
	level scene::add_scene_func("p7_fxanim_zm_castle_rocket_01_bundle", &function_7aae0fb2, "play");
	level waittill(#"hash_59e5a3dd");
	level thread scene::play("p7_fxanim_zm_castle_rocket_01_bundle");
	level waittill(#"start_of_round");
	var_d16e2136 = struct::get_array("initial_spawn_points");
	foreach(player in level.players)
	{
		player zm_utility::create_streamer_hint(var_d16e2136[0].origin, var_d16e2136[0].angles, 1);
	}
	wait(9);
	foreach(player in level.players)
	{
		player zm_utility::clear_streamer_hint();
	}
}

/*
	Name: function_7aae0fb2
	Namespace: zm_castle
	Checksum: 0xBFED8C71
	Offset: 0x5AE8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_7aae0fb2(a_ents)
{
	array::run_all(level.players, &playrumbleonentity, "zm_castle_opening_rocket_launch");
}

/*
	Name: power_electric_switch
	Namespace: zm_castle
	Checksum: 0x79765153
	Offset: 0x5B30
	Size: 0x204
	Parameters: 0
	Flags: Linked
*/
function power_electric_switch()
{
	level scene::init("p7_fxanim_zm_power_switch_bundle");
	trig = getent("use_power_switch", "targetname");
	trig sethintstring(&"ZOMBIE_ELECTRIC_SWITCH");
	trig setcursorhint("HINT_NOICON");
	cheat = 0;
	user = undefined;
	if(cheat != 1)
	{
		trig waittill(#"trigger", user);
		if(isdefined(user))
		{
			user zm_audio::create_and_play_dialog("general", "power_on");
		}
	}
	level thread scene::play("power_switch", "targetname");
	level flag::set("power_on");
	util::clientnotify("ZPO");
	util::wait_network_frame();
	wait(1);
	exploder::exploder("fxexp_400");
	forward = anglestoforward(trig.origin);
	playfx(level._effect["switch_sparks"], trig.origin, forward);
	trig delete();
}

/*
	Name: function_639f3b62
	Namespace: zm_castle
	Checksum: 0xF2DA1BE7
	Offset: 0x5D40
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_639f3b62()
{
	self thread zm_castle_low_grav::function_3ccd9604();
}

/*
	Name: function_30cebef9
	Namespace: zm_castle
	Checksum: 0xC4A7C3FA
	Offset: 0x5D68
	Size: 0x2C4
	Parameters: 0
	Flags: Linked
*/
function function_30cebef9()
{
	if(level flag::get("power_on"))
	{
		exploder::exploder("exp_lgt_power_on");
		exploder::exploder("lgt_vending_doubletap2_castle");
		exploder::exploder("lgt_vending_juggernaut_castle");
		exploder::exploder("lgt_vending_mule_kick_castle");
		exploder::exploder("lgt_vending_quick_revive_castle");
		exploder::exploder("lgt_vending_sleight_of_hand_castle");
		exploder::exploder("lgt_vending_stamina_up_castle");
		exploder::exploder("fxexp_400");
		exploder::exploder("fxexp_710");
		exploder::exploder("fxexp_720");
		if(!level flag::get("tesla_coil_on"))
		{
			exploder::exploder("lgt_deathray_green");
		}
		exploder::exploder("fxexp_100");
		if(level flag::get("castle_teleporter_used") && !level flag::get("rocket_firing"))
		{
			exploder::exploder("lgt_rocket_green");
		}
	}
	else
	{
		exploder::exploder("power_door_lgts");
	}
	if(level flag::get("upper_courtyard_pad_flag"))
	{
		exploder::exploder("lgt_upper_courtyard_nolink");
	}
	if(level flag::get("lower_courtyard_pad_flag"))
	{
		exploder::exploder("lgt_lower_courtyard_nolink");
	}
	if(level flag::get("rooftop_pad_flag"))
	{
		exploder::exploder("lgt_roof_nolink");
	}
	if(level flag::get("v10_rocket_pad_flag"))
	{
		exploder::exploder("lgt_v10_nolink");
	}
}

/*
	Name: function_a6477691
	Namespace: zm_castle
	Checksum: 0x99D6D678
	Offset: 0x6038
	Size: 0x278
	Parameters: 0
	Flags: Linked
*/
function function_a6477691()
{
	level waittill(#"start_zombie_round_logic");
	sndent = spawn("script_origin", (611, 3496, 699));
	sndent playloopsound("zmb_projector_hum", 0.25);
	while(true)
	{
		exploder::exploder("lgt_castle_slide_one");
		sndent playsound("zmb_projector_slide");
		wait(randomfloatrange(4, 5));
		exploder::stop_exploder("lgt_castle_slide_one");
		exploder::exploder("lgt_castle_slide_two");
		sndent playsound("zmb_projector_slide");
		wait(randomfloatrange(4, 5));
		exploder::stop_exploder("lgt_castle_slide_two");
		exploder::exploder("lgt_castle_slide_three");
		sndent playsound("zmb_projector_slide");
		wait(randomfloatrange(4, 5));
		exploder::stop_exploder("lgt_castle_slide_three");
		exploder::exploder("lgt_castle_slide_four");
		sndent playsound("zmb_projector_slide");
		wait(randomfloatrange(4, 5));
		exploder::stop_exploder("lgt_castle_slide_four");
		exploder::exploder("lgt_castle_slide_five");
		sndent playsound("zmb_projector_slide");
		wait(randomfloatrange(4, 5));
		exploder::stop_exploder("lgt_castle_slide_five");
	}
}

/*
	Name: function_555e8704
	Namespace: zm_castle
	Checksum: 0xE212D569
	Offset: 0x62B8
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_555e8704()
{
	switch(self.unitrigger_stub.in_zone)
	{
		case "zone_v10_pad_door":
		{
			str_exploder = "fxexp_900";
			break;
		}
		case "zone_clocktower_rooftop":
		{
			str_exploder = "fxexp_901";
			break;
		}
		case "zone_lower_courtyard_back":
		{
			str_exploder = "fxexp_902";
			break;
		}
		case "zone_living_quarters":
		{
			str_exploder = "fxexp_903";
			break;
		}
		case "zone_great_hall_upper_left":
		{
			str_exploder = "fxexp_904";
			break;
		}
	}
	exploder::exploder(str_exploder);
	while(self.state == "idle")
	{
		wait(0.05);
	}
	exploder::exploder_stop(str_exploder);
}

/*
	Name: function_9be4ecd1
	Namespace: zm_castle
	Checksum: 0x5C45C447
	Offset: 0x63B8
	Size: 0x212
	Parameters: 0
	Flags: Linked
*/
function function_9be4ecd1()
{
	n_start_time = undefined;
	while(true)
	{
		if(level.zombie_total <= 0)
		{
			a_zombies = getaiteamarray(level.zombie_team);
			var_565450eb = zombie_utility::get_current_zombie_count();
			if(var_565450eb <= 3 && level.round_number > 3)
			{
				a_zombies = getaiteamarray(level.zombie_team);
				foreach(e_zombie in a_zombies)
				{
					if(e_zombie.zombie_move_speed == "walk")
					{
						e_zombie zombie_utility::set_zombie_run_cycle("run");
					}
				}
			}
			if(var_565450eb == 1)
			{
				if(!isdefined(n_start_time))
				{
					n_start_time = gettime();
				}
				n_time = gettime();
				var_be13851f = (n_time - n_start_time) / 1000;
				if(var_be13851f >= 25)
				{
					a_zombies[0] zombie_utility::set_zombie_run_cycle("sprint");
					util::waittill_any_ents(self, "death", level, "start_of_round");
				}
			}
			else
			{
				n_start_time = undefined;
			}
		}
		wait(1);
	}
}

/*
	Name: setup_personality_character_exerts
	Namespace: zm_castle
	Checksum: 0x378C0534
	Offset: 0x65D8
	Size: 0x622
	Parameters: 0
	Flags: Linked
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["hitmed"][0] = "vox_plr_0_exert_pain_0";
	level.exert_sounds[1]["hitmed"][1] = "vox_plr_0_exert_pain_1";
	level.exert_sounds[1]["hitmed"][2] = "vox_plr_0_exert_pain_2";
	level.exert_sounds[1]["hitmed"][3] = "vox_plr_0_exert_pain_3";
	level.exert_sounds[1]["hitmed"][4] = "vox_plr_0_exert_pain_4";
	level.exert_sounds[2]["hitmed"][0] = "vox_plr_1_exert_pain_0";
	level.exert_sounds[2]["hitmed"][1] = "vox_plr_1_exert_pain_1";
	level.exert_sounds[2]["hitmed"][2] = "vox_plr_1_exert_pain_2";
	level.exert_sounds[2]["hitmed"][3] = "vox_plr_1_exert_pain_3";
	level.exert_sounds[2]["hitmed"][4] = "vox_plr_1_exert_pain_4";
	level.exert_sounds[3]["hitmed"][0] = "vox_plr_2_exert_pain_0";
	level.exert_sounds[3]["hitmed"][1] = "vox_plr_2_exert_pain_1";
	level.exert_sounds[3]["hitmed"][2] = "vox_plr_2_exert_pain_2";
	level.exert_sounds[3]["hitmed"][3] = "vox_plr_2_exert_pain_3";
	level.exert_sounds[3]["hitmed"][4] = "vox_plr_2_exert_pain_4";
	level.exert_sounds[4]["hitmed"][0] = "vox_plr_3_exert_pain_0";
	level.exert_sounds[4]["hitmed"][1] = "vox_plr_3_exert_pain_1";
	level.exert_sounds[4]["hitmed"][2] = "vox_plr_3_exert_pain_2";
	level.exert_sounds[4]["hitmed"][3] = "vox_plr_3_exert_pain_3";
	level.exert_sounds[4]["hitmed"][4] = "vox_plr_3_exert_pain_4";
	level.exert_sounds[1]["hitlrg"][0] = "vox_plr_0_exert_pain_0";
	level.exert_sounds[1]["hitlrg"][1] = "vox_plr_0_exert_pain_1";
	level.exert_sounds[1]["hitlrg"][2] = "vox_plr_0_exert_pain_2";
	level.exert_sounds[1]["hitlrg"][3] = "vox_plr_0_exert_pain_3";
	level.exert_sounds[1]["hitlrg"][4] = "vox_plr_0_exert_pain_4";
	level.exert_sounds[2]["hitlrg"][0] = "vox_plr_1_exert_pain_0";
	level.exert_sounds[2]["hitlrg"][1] = "vox_plr_1_exert_pain_1";
	level.exert_sounds[2]["hitlrg"][2] = "vox_plr_1_exert_pain_2";
	level.exert_sounds[2]["hitlrg"][3] = "vox_plr_1_exert_pain_3";
	level.exert_sounds[2]["hitlrg"][4] = "vox_plr_1_exert_pain_4";
	level.exert_sounds[3]["hitlrg"][0] = "vox_plr_2_exert_pain_0";
	level.exert_sounds[3]["hitlrg"][1] = "vox_plr_2_exert_pain_1";
	level.exert_sounds[3]["hitlrg"][2] = "vox_plr_2_exert_pain_2";
	level.exert_sounds[3]["hitlrg"][3] = "vox_plr_2_exert_pain_3";
	level.exert_sounds[3]["hitlrg"][4] = "vox_plr_2_exert_pain_4";
	level.exert_sounds[4]["hitlrg"][0] = "vox_plr_3_exert_pain_0";
	level.exert_sounds[4]["hitlrg"][1] = "vox_plr_3_exert_pain_1";
	level.exert_sounds[4]["hitlrg"][2] = "vox_plr_3_exert_pain_2";
	level.exert_sounds[4]["hitlrg"][3] = "vox_plr_3_exert_pain_3";
	level.exert_sounds[4]["hitlrg"][4] = "vox_plr_3_exert_pain_4";
}

/*
	Name: function_13fc99fa
	Namespace: zm_castle
	Checksum: 0xFE088D48
	Offset: 0x6C08
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_13fc99fa()
{
	zombie_utility::set_zombie_var("zombie_powerup_drop_max_per_round", 3);
	level flag::wait_till("start_zombie_round_logic");
	while(level.round_number < 10)
	{
		level waittill(#"between_round_over");
	}
	zombie_utility::set_zombie_var("zombie_powerup_drop_max_per_round", 4);
}

/*
	Name: function_ec8a9331
	Namespace: zm_castle
	Checksum: 0xCD4BD18A
	Offset: 0x6C98
	Size: 0x7C
	Parameters: 12
	Flags: Linked
*/
function function_ec8a9331(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	if(self.archetype == "mechz")
	{
		return false;
	}
}

/*
	Name: detect_reentry
	Namespace: zm_castle
	Checksum: 0xFDEDA4C4
	Offset: 0x6D20
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function detect_reentry()
{
	/#
		if(isdefined(self.var_8665ab89))
		{
			if(self.var_8665ab89 == gettime())
			{
				return true;
			}
		}
		self.var_8665ab89 = gettime();
		return false;
	#/
}

/*
	Name: function_287ae5ec
	Namespace: zm_castle
	Checksum: 0xC27BA03
	Offset: 0x6D60
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_287ae5ec()
{
	/#
		level flagsys::wait_till("");
		wait(1);
		zm_devgui::add_custom_devgui_callback(&function_f04119b5);
		adddebugcommand("");
	#/
}

/*
	Name: function_f04119b5
	Namespace: zm_castle
	Checksum: 0x65ACB937
	Offset: 0x6DD0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_f04119b5(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				if(level detect_reentry())
				{
					return true;
				}
				level thread super_sesame();
				return true;
			}
		}
		return false;
	#/
}

/*
	Name: super_sesame
	Namespace: zm_castle
	Checksum: 0xF773CC0B
	Offset: 0x6E40
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function super_sesame()
{
	/#
		zm_devgui::zombie_devgui_open_sesame();
		level flag::set("");
		var_15ed352b = getentarray("", "");
		foreach(var_3b9a12e0 in var_15ed352b)
		{
			var_3b9a12e0 delete();
		}
		level notify(#"pressure_pads_activated");
		var_a6e47643 = struct::get_array("", "");
		array::thread_all(var_a6e47643, &function_e9162f72);
	#/
}

/*
	Name: function_e9162f72
	Namespace: zm_castle
	Checksum: 0x83D1C7DB
	Offset: 0x6F90
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_e9162f72()
{
	/#
		var_1143aa58 = getent(self.target, "");
		var_9ca35935 = self.script_noteworthy;
		level flag::set(var_9ca35935);
		var_1143aa58 setmodel("");
	#/
}

