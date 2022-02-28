// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\raz;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\vehicles\_sentinel_drone;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_raz;
#using scripts\zm\_zm_ai_sentinel_drone;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
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
#using scripts\zm\_zm_placeable_mine;
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
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_bowie;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_dragon_gauntlet;
#using scripts\zm\_zm_weap_dragon_scale_shield;
#using scripts\zm\_zm_weap_dragon_strike;
#using scripts\zm\_zm_weap_raygun_mark3;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_siegebot_nikolai;
#using scripts\zm\zm_stalingrad_achievements;
#using scripts\zm\zm_stalingrad_ambient;
#using scripts\zm\zm_stalingrad_audio;
#using scripts\zm\zm_stalingrad_challenges;
#using scripts\zm\zm_stalingrad_cleanup_mgr;
#using scripts\zm\zm_stalingrad_craftables;
#using scripts\zm\zm_stalingrad_devgui;
#using scripts\zm\zm_stalingrad_dragon;
#using scripts\zm\zm_stalingrad_dragon_strike;
#using scripts\zm\zm_stalingrad_ee_main;
#using scripts\zm\zm_stalingrad_eye_beam_trap;
#using scripts\zm\zm_stalingrad_ffotd;
#using scripts\zm\zm_stalingrad_finger_trap;
#using scripts\zm\zm_stalingrad_fx;
#using scripts\zm\zm_stalingrad_gauntlet;
#using scripts\zm\zm_stalingrad_mounted_mg;
#using scripts\zm\zm_stalingrad_nikolai;
#using scripts\zm\zm_stalingrad_pap_quest;
#using scripts\zm\zm_stalingrad_pavlov_trap;
#using scripts\zm\zm_stalingrad_powered_bridge;
#using scripts\zm\zm_stalingrad_timer;
#using scripts\zm\zm_stalingrad_util;
#using scripts\zm\zm_stalingrad_vo;
#using scripts\zm\zm_stalingrad_wearables;
#using scripts\zm\zm_stalingrad_zombie;
#using scripts\zm\zm_stalingrad_zones;

#using_animtree("generic");

#namespace zm_stalingrad;

/*
	Name: opt_in
	Namespace: zm_stalingrad
	Checksum: 0x84B8CCB1
	Offset: 0x27E0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec opt_in()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
	level.pack_a_punch_camo_index = 84;
	level.pack_a_punch_camo_index_number_variants = 5;
}

/*
	Name: gamemode_callback_setup
	Namespace: zm_stalingrad
	Checksum: 0x99EC1590
	Offset: 0x2820
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function gamemode_callback_setup()
{
}

/*
	Name: setup_rex_starts
	Namespace: zm_stalingrad
	Checksum: 0x6495FF3B
	Offset: 0x2830
	Size: 0x84
	Parameters: 0
	Flags: None
*/
function setup_rex_starts()
{
	zm_utility::add_gametype("zclassic", &dummy, "zclassic", &dummy);
	zm_utility::add_gameloc("default", &dummy, "default", &dummy);
}

/*
	Name: dummy
	Namespace: zm_stalingrad
	Checksum: 0x99EC1590
	Offset: 0x28C0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function dummy()
{
}

/*
	Name: main
	Namespace: zm_stalingrad
	Checksum: 0xC3511ADA
	Offset: 0x28D0
	Size: 0x1054
	Parameters: 0
	Flags: Linked
*/
function main()
{
	zm_stalingrad_ffotd::main_start();
	level._uses_sticky_grenades = 1;
	level._uses_taser_knuckles = 1;
	level.var_bd64e31e = 20;
	level.debug_keyline_zombies = 0;
	setdvar("dlc3_veh_UpdateYawEvenWhileStationary", 1);
	zm::init_fx();
	zm_stalingrad_fx::init();
	dragon::init_clientfields();
	zm_stalingrad_wearables::function_ad78a144();
	clientfield::register("clientuimodel", "player_lives", 12000, 2, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_shield_parts", 12000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_dragon_strike", 12000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_crafted_shield", 12000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_cylinder", 12000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.piece_cylinder", 12000, 2, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_egg", 12000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.piece_egg", 12000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.progress_egg", 12000, 4, "float");
	clientfield::register("actor", "drop_pod_score_beam_fx", 12000, 1, "counter");
	clientfield::register("scriptmover", "drop_pod_active", 12000, 1, "int");
	clientfield::register("scriptmover", "drop_pod_hp_light", 12000, 2, "int");
	clientfield::register("world", "drop_pod_streaming", 12000, 1, "int");
	clientfield::register("clientuimodel", "trialWidget.visible", 9000, 1, "int");
	clientfield::register("clientuimodel", "trialWidget.progress", 9000, 7, "float");
	clientfield::register("clientuimodel", "trialWidget.icon", 12000, 2, "int");
	clientfield::register("clientuimodel", "trialWidget.challenge1state", 12000, 2, "int");
	clientfield::register("clientuimodel", "trialWidget.challenge2state", 12000, 2, "int");
	clientfield::register("clientuimodel", "trialWidget.challenge3state", 12000, 2, "int");
	clientfield::register("toplayer", "tp_water_sheeting", 12000, 1, "int");
	clientfield::register("toplayer", "sewer_landing_rumble", 12000, 1, "counter");
	clientfield::register("scriptmover", "dragon_egg_heat_fx", 12000, 1, "int");
	clientfield::register("scriptmover", "dragon_egg_placed", 12000, 1, "counter");
	clientfield::register("actor", "dragon_egg_score_beam_fx", 12000, 1, "counter");
	clientfield::register("world", "force_stream_dragon_egg", 12000, 1, "int");
	clientfield::register("scriptmover", "ethereal_audio_log_fx", 12000, 1, "int");
	clientfield::register("world", "deactivate_ai_vox", 12000, 1, "int");
	clientfield::register("world", "sophia_intro_outro", 12000, 1, "int");
	clientfield::register("allplayers", "sophia_follow", 12000, 3, "int");
	clientfield::register("scriptmover", "sophia_eye_shader", 12000, 1, "int");
	clientfield::register("world", "sophia_main_waveform", 12000, 1, "int");
	clientfield::register("toplayer", "interact_rumble", 12000, 1, "counter");
	level._effect["eye_glow"] = "dlc3/stalingrad/fx_glow_eye_red_stal";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "weapon/bullet/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["switch_sparks"] = "env/electrical/fx_elec_wire_spark_burst";
	level flag::init("is_coop_door_price");
	level.default_start_location = "start_room";
	level.default_game_mode = "zclassic";
	level.b_crossbow_bolt_destroy_on_impact = 1;
	level.b_create_upgraded_crossbow_watchers = 1;
	callback::on_connect(&on_player_connect);
	level.precachecustomcharacters = &precachecustomcharacters;
	level.givecustomcharacters = &givecustomcharacters;
	initcharacterstartindex();
	level.custom_game_over_hud_elem = &function_f7b7d070;
	level.register_offhand_weapons_for_level_defaults_override = &function_c2cd1f49;
	level.zombiemode_offhand_weapon_give_override = &offhand_weapon_give_override;
	level._zombie_custom_add_weapons = &custom_add_weapons;
	level._allow_melee_weapon_switching = 1;
	level.zombiemode_reusing_pack_a_punch = 1;
	level._no_vending_machine_auto_collision = 1;
	level.var_36b5dab = 1;
	level.b_show_single_intermission = 1;
	level.hotjoin_extra_blackscreen_time = 1.5;
	level.check_player_is_ready_for_ammo = &check_player_is_ready_for_ammo;
	level.no_target_override = &no_target_override;
	zm_craftables::init();
	zm_stalingrad_craftables::include_craftables();
	zm_stalingrad_craftables::init_craftables();
	level.var_9cef605e = &dragon::function_aaf7e575;
	level thread dragon::function_90d81e44();
	include_weapons();
	function_42795aca();
	include_perks_in_random_rotation();
	level thread function_965d1d83("p7_fxanim_zm_stal_door_buy_factory_floor_bundle", "factory_open");
	level thread function_965d1d83("p7_fxanim_zm_stal_door_buy_barracks_bridge_bundle", "department_floor3_to_red_brick_open");
	level thread function_965d1d83("p7_fxanim_zm_stal_door_buy_armory_bundle", "dept_to_yellow");
	level thread function_965d1d83("p7_fxanim_zm_stal_door_buy_barracks_to_judicial_bundle", "red_brick_to_judicial_street_open", "yellow_to_judicial_street_open");
	level thread function_965d1d83("p7_fxanim_zm_stal_door_buy_dept_store_2f_bundle", "department_store_2f_to_3f");
	level thread function_965d1d83("p7_fxanim_zm_stal_door_buy_armory_judicial_bundle", "yellow_to_judicial_street_open", "red_brick_to_judicial_street_open");
	level thread function_965d1d83("p7_fxanim_zm_stal_door_buy_library_bundle", "library_open");
	level thread function_9c2d9678();
	level thread zm_stalingrad_gauntlet::function_622ad391();
	level thread zm_stalingrad_pap::transport_pavlovs_to_fountain();
	level thread function_de23a4cc();
	var_58b5275a = getentarray("sewer_exploder_trigger", "targetname");
	foreach(trigger in var_58b5275a)
	{
		trigger thread zm_stalingrad_util::function_eda4b163();
	}
	/#
		level thread zm_stalingrad_devgui::function_91912a79();
	#/
	level.do_randomized_zigzag_path = 1;
	zombie_utility::set_zombie_var("zombie_powerup_drop_max_per_round", 4);
	zm_stalingrad_util::function_4da6e8(1);
	umbragate_set("umbragate1", 1);
	level.round_wait_func = &function_df57d237;
	load::main();
	level thread zm_stalingrad_fx::fx_overrides();
	level thread function_80eaf8a();
	level.var_2c12d9a6 = &function_277575cc;
	level.var_2d0e5eb6 = &function_2d0e5eb6;
	level.var_b6d13a4e = &function_13df0656;
	level.var_464197de = &function_90cae0a9;
	level thread zm_stalingrad_wearables::function_eed58360();
	level thread zm_stalingrad_audio::main();
	level thread namespace_19e79ea1::function_56059128();
	level thread namespace_5132b4d6::function_19458e73();
	_zm_weap_cymbal_monkey::init();
	level._round_start_func = &zm::round_start;
	level.fn_custom_round_ai_spawn = &function_33aa4940;
	level.var_c7da0559 = &function_58a468e4;
	level.func_custom_sentinel_drone_cleanup_check = &function_b9d3803a;
	level thread zm_ai_sentinel_drone::function_2f7416e5();
	level.player_intersection_tracker_override = &dragon::player_intersection_tracker_override;
	level.powerup_grab_get_players_override = &powerup_grab_get_players_override;
	level.zones = [];
	level.zone_manager_init_func = &zm_stalingrad_zones::init;
	init_zones[0] = "start_A_zone";
	thread zm_stalingrad_powered_bridge::main();
	level thread zm_zonemgr::manage_zones(init_zones);
	level thread dragon::dragon_hazard_fx_anim_init();
	level thread dragon::function_b4d22afe();
	level thread dragon::function_285a7d29();
	/#
		level.disable_kill_thread = 1;
	#/
	level.player_out_of_playable_area_monitor_callback = &function_f9248bb;
	level thread sndfunctions();
	level thread zm_stalingrad_pap::function_2fcaffe2();
	level thread zm_stalingrad_util::main();
	level thread function_cd541d08();
	level thread function_d1b24ba4(0);
	level thread zm_stalingrad_pavlov_trap::main();
	level thread zm_stalingrad_finger_trap::main();
	level thread zm_stalingrad_nikolai::main();
	level thread function_897d1ccc();
	level.zm_custom_spawn_location_selection = &function_ff18dfdd;
	level thread function_12a6d70c();
	level thread function_9273a671();
	/#
		level thread zm_stalingrad_pap::function_5efc91a4();
	#/
	level thread function_ba96daeb();
	setdvar("hkai_pathfindIterationLimit", 1200);
	zm_stalingrad_ffotd::main_end();
}

/*
	Name: function_3409f322
	Namespace: zm_stalingrad
	Checksum: 0xC53CF4C9
	Offset: 0x3930
	Size: 0x1DE
	Parameters: 0
	Flags: Linked
*/
function function_3409f322()
{
	self endon(#"death");
	self endon(#"disconnect");
	level waittill(#"hash_9a634383");
	primary_weapons = self getweaponslist(1);
	self notify(#"zmb_max_ammo");
	self notify(#"zmb_lost_knife");
	self zm_placeable_mine::disable_all_prompts_for_player();
	for(x = 0; x < primary_weapons.size; x++)
	{
		if(level.headshots_only && zm_utility::is_lethal_grenade(primary_weapons[x]))
		{
			continue;
		}
		if(isdefined(level.zombie_include_equipment) && isdefined(level.zombie_include_equipment[primary_weapons[x]]) && (!(isdefined(level.zombie_equipment[primary_weapons[x]].refill_max_ammo) && level.zombie_equipment[primary_weapons[x]].refill_max_ammo)))
		{
			continue;
		}
		if(isdefined(level.zombie_weapons_no_max_ammo) && isdefined(level.zombie_weapons_no_max_ammo[primary_weapons[x].name]))
		{
			continue;
		}
		if(zm_utility::is_hero_weapon(primary_weapons[x]))
		{
			continue;
		}
		if(self hasweapon(primary_weapons[x]))
		{
			self givemaxammo(primary_weapons[x]);
		}
	}
}

/*
	Name: check_player_is_ready_for_ammo
	Namespace: zm_stalingrad
	Checksum: 0xB0F0FA5B
	Offset: 0x3B18
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function check_player_is_ready_for_ammo(player)
{
	if(isdefined(level.var_163a43e4) && array::contains(level.var_163a43e4, player))
	{
		player thread function_3409f322();
		return false;
	}
	return true;
}

/*
	Name: function_ba96daeb
	Namespace: zm_stalingrad
	Checksum: 0x4EB65BC4
	Offset: 0x3B78
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_ba96daeb()
{
	level flag::wait_till("start_zombie_round_logic");
	level function_52211d40(0);
	level thread zm_perks::spare_change();
}

/*
	Name: function_c2cd1f49
	Namespace: zm_stalingrad
	Checksum: 0x70A2172A
	Offset: 0x3BD8
	Size: 0xBE
	Parameters: 0
	Flags: Linked
*/
function function_c2cd1f49()
{
	zm_utility::register_lethal_grenade_for_level("frag_grenade");
	level.zombie_lethal_grenade_player_init = getweapon("frag_grenade");
	zm_utility::register_tactical_grenade_for_level("cymbal_monkey");
	zm_utility::register_tactical_grenade_for_level("cymbal_monkey_upgraded");
	zm_utility::register_melee_weapon_for_level(level.weaponbasemelee.name);
	zm_utility::register_melee_weapon_for_level("bowie_knife");
	level.zombie_melee_weapon_player_init = level.weaponbasemelee;
	level.zombie_equipment_player_init = undefined;
}

/*
	Name: offhand_weapon_give_override
	Namespace: zm_stalingrad
	Checksum: 0xC79C4DF1
	Offset: 0x3CA0
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
	Name: function_438bb72b
	Namespace: zm_stalingrad
	Checksum: 0xC0BB2C9E
	Offset: 0x3D68
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function function_438bb72b()
{
	level flag::init("always_on");
	level flag::set("always_on");
}

/*
	Name: include_weapons
	Namespace: zm_stalingrad
	Checksum: 0x99EC1590
	Offset: 0x3DB8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function include_weapons()
{
}

/*
	Name: function_9273a671
	Namespace: zm_stalingrad
	Checksum: 0x29BCA935
	Offset: 0x3DC8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_9273a671()
{
	var_ac878678 = getent("use_elec_switch", "targetname");
	var_ac878678 setcursorhint("HINT_NOICON");
}

/*
	Name: precachecustomcharacters
	Namespace: zm_stalingrad
	Checksum: 0x99EC1590
	Offset: 0x3E20
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precachecustomcharacters()
{
}

/*
	Name: initcharacterstartindex
	Namespace: zm_stalingrad
	Checksum: 0x8CA3D304
	Offset: 0x3E30
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
	Namespace: zm_stalingrad
	Checksum: 0x8756A187
	Offset: 0x3E60
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
	Name: function_be9932bc
	Namespace: zm_stalingrad
	Checksum: 0x87924A92
	Offset: 0x3EA8
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function function_be9932bc()
{
	var_9b100591 = [];
	var_9b100591[0] = 0;
	var_9b100591[1] = 1;
	var_9b100591[2] = 2;
	var_9b100591[3] = 3;
	a_e_players = getplayers();
	if(a_e_players.size == 1)
	{
		var_9b100591 = array::randomize(var_9b100591);
		if(var_9b100591[0] == 2)
		{
			level.has_richtofen = 1;
		}
		return var_9b100591[0];
	}
	n_characters_defined = 0;
	foreach(e_player in a_e_players)
	{
		if(isdefined(e_player.characterindex))
		{
			arrayremovevalue(var_9b100591, e_player.characterindex, 0);
			n_characters_defined++;
		}
	}
	if(var_9b100591.size > 0)
	{
		if(n_characters_defined == (a_e_players.size - 1))
		{
			if(!(isdefined(level.has_richtofen) && level.has_richtofen))
			{
				level.has_richtofen = 1;
				return 2;
			}
		}
		var_9b100591 = array::randomize(var_9b100591);
		if(var_9b100591[0] == 2)
		{
			level.has_richtofen = 1;
		}
		return var_9b100591[0];
	}
	return 0;
}

/*
	Name: givecustomcharacters
	Namespace: zm_stalingrad
	Checksum: 0xF4AB025B
	Offset: 0x40C8
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
		self.characterindex = function_be9932bc();
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
	if(self.characterindex != 2)
	{
		self setcharacterbodystyle(1);
	}
	self setcharacterhelmetstyle(0);
	switch(self.characterindex)
	{
		case 0:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("frag_grenade");
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("bouncingbetty");
			break;
		}
		case 1:
		{
			self.talks_in_danger = 1;
			level.rich_sq_player = self;
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("pistol_standard");
			break;
		}
		case 2:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("870mcs");
			break;
		}
		case 3:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("hk416");
			break;
		}
	}
	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
	self thread set_exert_id();
}

/*
	Name: set_exert_id
	Namespace: zm_stalingrad
	Checksum: 0x9C24690F
	Offset: 0x43A0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function set_exert_id()
{
	self endon(#"disconnect");
	util::wait_network_frame();
	util::wait_network_frame();
	self zm_audio::setexertvoice(self.characterindex + 1);
}

/*
	Name: setup_personality_character_exerts
	Namespace: zm_stalingrad
	Checksum: 0xE7839DF3
	Offset: 0x4400
	Size: 0x113A
	Parameters: 0
	Flags: Linked
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["burp"][0] = "vox_plr_0_exert_burp_0";
	level.exert_sounds[1]["burp"][1] = "vox_plr_0_exert_burp_1";
	level.exert_sounds[1]["burp"][2] = "vox_plr_0_exert_burp_2";
	level.exert_sounds[1]["burp"][3] = "vox_plr_0_exert_burp_3";
	level.exert_sounds[1]["burp"][4] = "vox_plr_0_exert_burp_4";
	level.exert_sounds[1]["burp"][5] = "vox_plr_0_exert_burp_5";
	level.exert_sounds[1]["burp"][6] = "vox_plr_0_exert_burp_6";
	level.exert_sounds[2]["burp"][0] = "vox_plr_1_exert_burp_0";
	level.exert_sounds[2]["burp"][1] = "vox_plr_1_exert_burp_1";
	level.exert_sounds[2]["burp"][2] = "vox_plr_1_exert_burp_2";
	level.exert_sounds[2]["burp"][3] = "vox_plr_1_exert_burp_3";
	level.exert_sounds[3]["burp"][0] = "vox_plr_2_exert_burp_0";
	level.exert_sounds[3]["burp"][1] = "vox_plr_2_exert_burp_1";
	level.exert_sounds[3]["burp"][2] = "vox_plr_2_exert_burp_2";
	level.exert_sounds[3]["burp"][3] = "vox_plr_2_exert_burp_3";
	level.exert_sounds[3]["burp"][4] = "vox_plr_2_exert_burp_4";
	level.exert_sounds[3]["burp"][5] = "vox_plr_2_exert_burp_5";
	level.exert_sounds[3]["burp"][6] = "vox_plr_2_exert_burp_6";
	level.exert_sounds[4]["burp"][0] = "vox_plr_3_exert_burp_0";
	level.exert_sounds[4]["burp"][1] = "vox_plr_3_exert_burp_1";
	level.exert_sounds[4]["burp"][2] = "vox_plr_3_exert_burp_2";
	level.exert_sounds[4]["burp"][3] = "vox_plr_3_exert_burp_3";
	level.exert_sounds[4]["burp"][4] = "vox_plr_3_exert_burp_4";
	level.exert_sounds[4]["burp"][5] = "vox_plr_3_exert_burp_5";
	level.exert_sounds[4]["burp"][6] = "vox_plr_3_exert_burp_6";
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
	level.exert_sounds[4]["hitmed"][3] = "vox_plr_3_exert_pain_4";
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
	level.exert_sounds[1]["drowning"][0] = "vox_plr_0_exert_underwater_air_low_0";
	level.exert_sounds[1]["drowning"][1] = "vox_plr_0_exert_underwater_air_low_1";
	level.exert_sounds[1]["drowning"][2] = "vox_plr_0_exert_underwater_air_low_2";
	level.exert_sounds[1]["drowning"][3] = "vox_plr_0_exert_underwater_air_low_3";
	level.exert_sounds[2]["drowning"][0] = "vox_plr_1_exert_underwater_air_low_0";
	level.exert_sounds[2]["drowning"][1] = "vox_plr_1_exert_underwater_air_low_1";
	level.exert_sounds[2]["drowning"][2] = "vox_plr_1_exert_underwater_air_low_2";
	level.exert_sounds[2]["drowning"][3] = "vox_plr_1_exert_underwater_air_low_3";
	level.exert_sounds[3]["drowning"][0] = "vox_plr_2_exert_underwater_air_low_0";
	level.exert_sounds[3]["drowning"][1] = "vox_plr_2_exert_underwater_air_low_1";
	level.exert_sounds[3]["drowning"][2] = "vox_plr_2_exert_underwater_air_low_2";
	level.exert_sounds[3]["drowning"][3] = "vox_plr_2_exert_underwater_air_low_3";
	level.exert_sounds[4]["drowning"][0] = "vox_plr_3_exert_underwater_air_low_0";
	level.exert_sounds[4]["drowning"][1] = "vox_plr_3_exert_underwater_air_low_1";
	level.exert_sounds[4]["drowning"][2] = "vox_plr_3_exert_underwater_air_low_2";
	level.exert_sounds[4]["drowning"][3] = "vox_plr_3_exert_underwater_air_low_3";
	level.exert_sounds[1]["cough"][0] = "vox_plr_0_exert_cough_0";
	level.exert_sounds[1]["cough"][1] = "vox_plr_0_exert_cough_1";
	level.exert_sounds[1]["cough"][2] = "vox_plr_0_exert_cough_2";
	level.exert_sounds[1]["cough"][3] = "vox_plr_0_exert_cough_3";
	level.exert_sounds[2]["cough"][0] = "vox_plr_1_exert_cough_0";
	level.exert_sounds[2]["cough"][1] = "vox_plr_1_exert_cough_1";
	level.exert_sounds[2]["cough"][2] = "vox_plr_1_exert_cough_2";
	level.exert_sounds[2]["cough"][3] = "vox_plr_1_exert_cough_3";
	level.exert_sounds[3]["cough"][0] = "vox_plr_2_exert_cough_0";
	level.exert_sounds[3]["cough"][1] = "vox_plr_2_exert_cough_1";
	level.exert_sounds[3]["cough"][2] = "vox_plr_2_exert_cough_2";
	level.exert_sounds[3]["cough"][3] = "vox_plr_2_exert_cough_3";
	level.exert_sounds[4]["cough"][0] = "vox_plr_3_exert_cough_0";
	level.exert_sounds[4]["cough"][1] = "vox_plr_3_exert_cough_1";
	level.exert_sounds[4]["cough"][2] = "vox_plr_3_exert_cough_2";
	level.exert_sounds[4]["cough"][3] = "vox_plr_3_exert_cough_3";
	level.exert_sounds[1]["underwater_emerge"][0] = "vox_plr_0_exert_underwater_emerge_0";
	level.exert_sounds[1]["underwater_emerge"][1] = "vox_plr_0_exert_underwater_emerge_1";
	level.exert_sounds[2]["underwater_emerge"][0] = "vox_plr_1_exert_underwater_emerge_0";
	level.exert_sounds[2]["underwater_emerge"][1] = "vox_plr_1_exert_underwater_emerge_1";
	level.exert_sounds[3]["underwater_emerge"][0] = "vox_plr_2_exert_underwater_emerge_0";
	level.exert_sounds[3]["underwater_emerge"][1] = "vox_plr_2_exert_underwater_emerge_1";
	level.exert_sounds[4]["underwater_emerge"][0] = "vox_plr_3_exert_underwater_emerge_0";
	level.exert_sounds[4]["underwater_emerge"][1] = "vox_plr_3_exert_underwater_emerge_1";
	level.exert_sounds[1]["underwater_gasp"][0] = "vox_plr_0_exert_underwater_gasp_0";
	level.exert_sounds[1]["underwater_gasp"][1] = "vox_plr_0_exert_underwater_gasp_1";
	level.exert_sounds[2]["underwater_gasp"][0] = "vox_plr_1_exert_underwater_gasp_0";
	level.exert_sounds[2]["underwater_gasp"][1] = "vox_plr_1_exert_underwater_gasp_1";
	level.exert_sounds[3]["underwater_gasp"][0] = "vox_plr_2_exert_underwater_gasp_0";
	level.exert_sounds[3]["underwater_gasp"][1] = "vox_plr_2_exert_underwater_gasp_1";
	level.exert_sounds[4]["underwater_gasp"][0] = "vox_plr_3_exert_underwater_gasp_0";
	level.exert_sounds[4]["underwater_gasp"][1] = "vox_plr_3_exert_underwater_gasp_1";
}

/*
	Name: custom_add_weapons
	Namespace: zm_stalingrad
	Checksum: 0x64D3AE1C
	Offset: 0x5548
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_stalingrad_weapons.csv", 1);
	zm_weapons::autofill_wallbuys_init();
}

/*
	Name: custom_add_vox
	Namespace: zm_stalingrad
	Checksum: 0xA001A03B
	Offset: 0x5588
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function custom_add_vox()
{
	zm_audio::loadplayervoicecategories("gamedata/audio/zm/zm_stalingrad_vox.csv");
}

/*
	Name: sndfunctions
	Namespace: zm_stalingrad
	Checksum: 0x91782A05
	Offset: 0x55B0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function sndfunctions()
{
	level thread setupmusic();
	level thread init_sounds();
	level thread custom_add_vox();
	level thread setup_personality_character_exerts();
}

/*
	Name: init_sounds
	Namespace: zm_stalingrad
	Checksum: 0x22CE1001
	Offset: 0x5620
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
	Name: setupmusic
	Namespace: zm_stalingrad
	Checksum: 0x1560DE04
	Offset: 0x56B0
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function setupmusic()
{
	zm_audio::musicstate_create("round_start", 3, "stalingrad_roundstart_1", "stalingrad_roundstart_2", "stalingrad_roundstart_3");
	zm_audio::musicstate_create("round_start_short", 3, "stalingrad_roundstart_1", "stalingrad_roundstart_2", "stalingrad_roundstart_3");
	zm_audio::musicstate_create("round_start_first", 3, "stalingrad_roundstart_first");
	zm_audio::musicstate_create("round_end", 3, "stalingrad_roundend_1", "stalingrad_roundend_2", "stalingrad_roundend_3", "stalingrad_roundend_4");
	zm_audio::musicstate_create("sentinel_roundstart", 3, "stalingrad_sentinel_roundstart_1");
	zm_audio::musicstate_create("sentinel_roundend", 3, "stalingrad_sentinel_roundend_1");
	zm_audio::musicstate_create("game_over", 5, "stalingrad_gameover");
	zm_audio::musicstate_create("dead_ended", 4, "dead_ended");
	zm_audio::musicstate_create("ace_of_spades", 4, "ace_of_spades");
	zm_audio::musicstate_create("sam", 4, "sam");
	zm_audio::musicstate_create("none", 4, "none");
}

/*
	Name: on_player_connect
	Namespace: zm_stalingrad
	Checksum: 0xF28A3DC1
	Offset: 0x58B0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	if(level.players.size > 1 && !level flag::get("is_coop_door_price"))
	{
		function_898d7758();
	}
}

/*
	Name: function_898d7758
	Namespace: zm_stalingrad
	Checksum: 0xB6031A
	Offset: 0x5908
	Size: 0x282
	Parameters: 0
	Flags: Linked
*/
function function_898d7758()
{
	level flag::set("is_coop_door_price");
	var_667e2b8a = getentarray("zombie_door", "targetname");
	foreach(var_12248b8b in var_667e2b8a)
	{
		if(isdefined(var_12248b8b.zombie_cost))
		{
			var_12248b8b.zombie_cost = var_12248b8b.zombie_cost + 250;
			if(isdefined(var_12248b8b.script_label) && var_12248b8b.script_label == "debris_using_door_trigger")
			{
				var_12248b8b zm_utility::set_hint_string(var_12248b8b, "default_buy_debris", var_12248b8b.zombie_cost);
				continue;
			}
			var_12248b8b zm_utility::set_hint_string(var_12248b8b, "default_buy_door", var_12248b8b.zombie_cost);
		}
	}
	var_bd25e1ce = getentarray("zombie_debris", "targetname");
	foreach(var_53d72eae in var_bd25e1ce)
	{
		if(isdefined(var_53d72eae.zombie_cost))
		{
			var_53d72eae.zombie_cost = var_53d72eae.zombie_cost + 250;
			var_53d72eae zm_utility::set_hint_string(var_53d72eae, "default_buy_debris", var_53d72eae.zombie_cost);
		}
	}
}

/*
	Name: function_42795aca
	Namespace: zm_stalingrad
	Checksum: 0xDB2E4658
	Offset: 0x5B98
	Size: 0xEE
	Parameters: 0
	Flags: Linked
*/
function function_42795aca()
{
	level.random_pandora_box_start = 1;
	level.start_chest_name = "dept_store_upper_chest";
	level.magicbox_should_upgrade_weapon_override = &function_87a3ff60;
	level.customrandomweaponweights = &function_659c2324;
	level.var_12d3a848 = 0;
	level.open_chest_location = [];
	level.open_chest_location[0] = "dept_store_upper_chest";
	level.open_chest_location[1] = "red_brick_chest";
	level.open_chest_location[2] = "basement_chest";
	level.open_chest_location[3] = "museum_chest";
	level.open_chest_location[4] = "factory_chest";
	level.open_chest_location[5] = "judicial_chest";
}

/*
	Name: function_87a3ff60
	Namespace: zm_stalingrad
	Checksum: 0x17314A6D
	Offset: 0x5C90
	Size: 0x96
	Parameters: 2
	Flags: Linked
*/
function function_87a3ff60(e_player, w_weapon)
{
	if(e_player bgb::is_enabled("zm_bgb_crate_power"))
	{
		return true;
	}
	if(w_weapon == level.weaponzmcymbalmonkey && (isdefined(e_player flag::get("flag_player_collected_reward_5")) && e_player flag::get("flag_player_collected_reward_5")))
	{
		return true;
	}
	return false;
}

/*
	Name: function_659c2324
	Namespace: zm_stalingrad
	Checksum: 0xD903B3DB
	Offset: 0x5D30
	Size: 0x184
	Parameters: 1
	Flags: Linked
*/
function function_659c2324(a_keys)
{
	var_b45fbf8c = zm_pap_util::get_triggers();
	if(a_keys[0] === level.w_raygun_mark3)
	{
		level.var_12d3a848 = 0;
		return a_keys;
	}
	n_chance = 0;
	if(zm_weapons::limited_weapon_below_quota(level.w_raygun_mark3))
	{
		level.var_12d3a848++;
		if(level.var_12d3a848 <= 12)
		{
			n_chance = 5;
		}
		else
		{
			if(level.var_12d3a848 > 12 && level.var_12d3a848 <= 17)
			{
				n_chance = 8;
			}
			else if(level.var_12d3a848 > 17)
			{
				n_chance = 12;
			}
		}
	}
	else
	{
		level.var_12d3a848 = 0;
	}
	if(randomint(100) <= n_chance && zm_magicbox::treasure_chest_canplayerreceiveweapon(self, level.w_raygun_mark3, var_b45fbf8c) && !self hasweapon(level.w_raygun_mark3_upgraded))
	{
		arrayinsert(a_keys, level.w_raygun_mark3, 0);
		level.var_12d3a848 = 0;
	}
	return a_keys;
}

/*
	Name: function_80eaf8a
	Namespace: zm_stalingrad
	Checksum: 0xA58856E
	Offset: 0x5EC0
	Size: 0x82
	Parameters: 0
	Flags: Linked
*/
function function_80eaf8a()
{
	level.initial_quick_revive_power_off = 1;
	wait(1);
	level flag::wait_till("start_zombie_round_logic");
	wait(1);
	if(!level flag::get("solo_game"))
	{
		level flag::wait_till("power_on");
	}
	level notify(#"revive_on");
}

/*
	Name: include_perks_in_random_rotation
	Namespace: zm_stalingrad
	Checksum: 0x1308C140
	Offset: 0x5F50
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
	level.custom_random_perk_weights = &function_dded17b1;
}

/*
	Name: function_dded17b1
	Namespace: zm_stalingrad
	Checksum: 0x3581DF57
	Offset: 0x6050
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_dded17b1()
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
	Name: function_277575cc
	Namespace: zm_stalingrad
	Checksum: 0x6989EBA6
	Offset: 0x6200
	Size: 0x2DC
	Parameters: 0
	Flags: Linked
*/
function function_277575cc()
{
	if(level flag::get("lockdown_active"))
	{
		var_a6abcc5d = zm_zonemgr::get_zone_from_position(self.origin + vectorscale((0, 0, 1), 32), 0);
		if(var_a6abcc5d == "pavlovs_A_zone")
		{
			n_index = self getentitynumber();
			var_40d229f9 = struct::get_array("gauntlet_bgb_teleport_" + n_index, "targetname");
			s_player_respawn = arraygetfarthest(self.origin, var_40d229f9);
		}
		else if(var_a6abcc5d == "pavlovs_B_zone" || var_a6abcc5d == "pavlovs_C_zone")
		{
			s_player_respawn = undefined;
			var_18fcbdf4 = struct::get("pavlovs_master_respawn", "script_label");
			var_46b9bbf8 = struct::get_array(var_18fcbdf4.target, "targetname");
			n_script_int = self getentitynumber() + 1;
			foreach(var_dbd59eb2 in var_46b9bbf8)
			{
				if(var_dbd59eb2.script_int === n_script_int)
				{
					s_player_respawn = var_dbd59eb2;
				}
			}
		}
	}
	else
	{
		if(level flag::get("players_in_arena"))
		{
			n_index = self getentitynumber();
			var_5381866c = struct::get_array("player_respawn_point_arena", "targetname");
			s_player_respawn = arraygetfarthest(self.origin, var_5381866c);
		}
		else
		{
			s_player_respawn = self zm_bgb_anywhere_but_here::function_728dfe3();
		}
	}
	return s_player_respawn;
}

/*
	Name: function_2d0e5eb6
	Namespace: zm_stalingrad
	Checksum: 0x751A3895
	Offset: 0x64E8
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function function_2d0e5eb6()
{
	var_cdb0f86b = getarraykeys(level.zombie_powerups);
	var_b4442b55 = array("shield_charge", "ww_grenade", "bonus_points_team", "code_cylinder_red", "code_cylinder_yellow", "code_cylinder_blue");
	var_62e2eaf2 = [];
	for(i = 0; i < var_cdb0f86b.size; i++)
	{
		var_77917a61 = 0;
		foreach(var_68de493a in var_b4442b55)
		{
			if(var_cdb0f86b[i] == var_68de493a)
			{
				var_77917a61 = 1;
				break;
			}
		}
		if(var_77917a61)
		{
			continue;
			continue;
		}
		if(!isdefined(var_62e2eaf2))
		{
			var_62e2eaf2 = [];
		}
		else if(!isarray(var_62e2eaf2))
		{
			var_62e2eaf2 = array(var_62e2eaf2);
		}
		var_62e2eaf2[var_62e2eaf2.size] = var_cdb0f86b[i];
	}
	str_powerup = array::random(var_62e2eaf2);
	return str_powerup;
}

/*
	Name: function_13df0656
	Namespace: zm_stalingrad
	Checksum: 0xB383837D
	Offset: 0x66E0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_13df0656()
{
	if(isdefined(level.var_163a43e4) && array::contains(level.var_163a43e4, self))
	{
		self waittill(#"hash_2e47bc4a");
	}
}

/*
	Name: function_90cae0a9
	Namespace: zm_stalingrad
	Checksum: 0x710171FC
	Offset: 0x6728
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function function_90cae0a9()
{
	if(isdefined(level.var_163a43e4) && array::contains(level.var_163a43e4, self))
	{
		return true;
	}
	return false;
}

/*
	Name: function_33aa4940
	Namespace: zm_stalingrad
	Checksum: 0x83EAE6F7
	Offset: 0x6768
	Size: 0x32C
	Parameters: 0
	Flags: Linked
*/
function function_33aa4940()
{
	if(level.players.size == 1)
	{
		if(level.round_number < 9)
		{
			return false;
		}
	}
	else if(level.round_number < 6)
	{
		return false;
	}
	if(isdefined(level.a_zombie_respawn_health["raz"]) && level.a_zombie_respawn_health["raz"].size > 0)
	{
		if(zm_ai_raz::function_7ed6c714(1) == 1)
		{
			level.zombie_total--;
			return true;
		}
	}
	else if(isdefined(level.a_zombie_respawn_health["sentinel_drone"]) && level.a_zombie_respawn_health["sentinel_drone"].size > 0)
	{
		if(zm_ai_sentinel_drone::function_19d0b055(1) == 1)
		{
			level.zombie_total--;
			return true;
		}
	}
	if(level.zombie_total <= 10)
	{
		return false;
	}
	var_c0692329 = 0;
	n_random = randomfloat(100);
	if(level.round_number > 25)
	{
		if(n_random < 5)
		{
			var_c0692329 = 1;
		}
	}
	else
	{
		if(level.round_number > 20)
		{
			if(n_random < 4)
			{
				var_c0692329 = 1;
			}
		}
		else
		{
			if(level.round_number > 15)
			{
				if(n_random < 3)
				{
					var_c0692329 = 1;
				}
			}
			else if(n_random < 2)
			{
				var_c0692329 = 1;
			}
		}
	}
	if(var_c0692329)
	{
		n_roll = randomint(100);
		if(level.round_number < 11 || n_roll < 50)
		{
			if(zm_ai_raz::function_ea911683() && level.var_88fe7b16 < level.var_d60a655e && zm_ai_raz::function_7ed6c714(1) == 1)
			{
				level.var_88fe7b16++;
				level.zombie_total--;
				return true;
			}
			return false;
		}
		if(zm_ai_sentinel_drone::function_74ab7484() && level.var_bd1e3d02 < level.var_b23e9e3a && zm_ai_sentinel_drone::function_19d0b055(1) == 1)
		{
			level.var_bd1e3d02++;
			level.zombie_total--;
			return true;
		}
		return false;
	}
	return false;
}

/*
	Name: function_58a468e4
	Namespace: zm_stalingrad
	Checksum: 0xF4237C87
	Offset: 0x6AA0
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_58a468e4()
{
	if(self.b_ignore_cleanup === 1)
	{
		return;
	}
	foreach(player in level.activeplayers)
	{
		n_dist_sq = distancesquared(self.origin, player.origin);
		if(n_dist_sq < 6250000)
		{
			return;
		}
	}
	self thread stalingrad_cleanup::cleanup_zombie(0);
}

/*
	Name: function_b9d3803a
	Namespace: zm_stalingrad
	Checksum: 0xB4E6F3DE
	Offset: 0x6B98
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_b9d3803a()
{
	if(self.b_ignore_cleanup === 1)
	{
		return;
	}
	foreach(player in level.activeplayers)
	{
		n_dist_sq = distancesquared(self.origin, player.origin);
		if(n_dist_sq < 49000000)
		{
			return;
		}
	}
	self thread stalingrad_cleanup::cleanup_zombie(0);
}

/*
	Name: function_cd541d08
	Namespace: zm_stalingrad
	Checksum: 0x386D7E1A
	Offset: 0x6C90
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function function_cd541d08()
{
	var_8fcfe322 = getentarray("zombie_trap", "targetname");
	foreach(var_60532813 in var_8fcfe322)
	{
		if(var_60532813.script_noteworthy === "electric")
		{
			var_60532813 thread function_78c017aa();
		}
	}
}

/*
	Name: function_78c017aa
	Namespace: zm_stalingrad
	Checksum: 0xD810FE6E
	Offset: 0x6D70
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function function_78c017aa()
{
	while(true)
	{
		self waittill(#"trap_activate");
		if(isdefined(self.activated_by_player))
		{
			self.activated_by_player clientfield::increment_to_player("interact_rumble");
		}
		self zm_stalingrad_util::function_903f6b36(1, self.target);
		self waittill(#"trap_done");
		self zm_stalingrad_util::function_903f6b36(0, self.target);
	}
}

/*
	Name: function_897d1ccc
	Namespace: zm_stalingrad
	Checksum: 0x2E9B748D
	Offset: 0x6E08
	Size: 0x2B2
	Parameters: 0
	Flags: Linked
*/
function function_897d1ccc()
{
	n_start_time = undefined;
	while(level.round_number < 4)
	{
		level waittill(#"start_of_round");
	}
	while(level.round_number < 20)
	{
		if(level.zombie_total <= 0)
		{
			a_zombies = getaiteamarray(level.zombie_team);
			var_565450eb = zombie_utility::get_current_zombie_count();
			if(var_565450eb <= 3)
			{
				a_zombies = getaiteamarray(level.zombie_team);
				foreach(e_zombie in a_zombies)
				{
					if(isdefined(e_zombie.zombie_move_speed) && e_zombie.zombie_move_speed == "walk")
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
					if(a_zombies[0].archetype === "raz" && (isdefined(a_zombies[0].razhasgunattached) && a_zombies[0].razhasgunattached))
					{
						blackboard::setblackboardattribute(a_zombies[0], "_locomotion_speed", "locomotion_speed_sprint");
					}
					else
					{
						a_zombies[0] zombie_utility::set_zombie_run_cycle("sprint");
					}
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
	Name: powerup_grab_get_players_override
	Namespace: zm_stalingrad
	Checksum: 0x86085193
	Offset: 0x70C8
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function powerup_grab_get_players_override()
{
	players = getplayers();
	foreach(player in players)
	{
		if(isalive(player.var_4bd1ce6b))
		{
			players[players.size] = player.var_4bd1ce6b;
		}
	}
	return players;
}

/*
	Name: function_ff18dfdd
	Namespace: zm_stalingrad
	Checksum: 0x43151632
	Offset: 0x71A0
	Size: 0x184
	Parameters: 1
	Flags: Linked
*/
function function_ff18dfdd(a_spots)
{
	if(math::cointoss() && level.players.size > 1)
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
	Name: function_df57d237
	Namespace: zm_stalingrad
	Checksum: 0x1BB9DB16
	Offset: 0x7330
	Size: 0x330
	Parameters: 0
	Flags: Linked
*/
function function_df57d237()
{
	level endon(#"restart_round");
	/#
		level endon(#"kill_round");
	#/
	/#
		if(getdvarint(""))
		{
			level waittill(#"forever");
		}
	#/
	if(zm::cheat_enabled(2))
	{
		level waittill(#"forever");
	}
	level.var_88fe7b16 = 0;
	level.var_bd1e3d02 = 0;
	if(level.players.size == 1)
	{
		level.var_d60a655e = (level.round_number + 1) - 9;
		level.var_b23e9e3a = (level.round_number + 1) - 14;
	}
	else
	{
		level.var_d60a655e = (level.round_number + 1) - 6;
		level.var_b23e9e3a = (level.round_number + 1) - 11;
	}
	/#
		if(getdvarint("") == 0)
		{
			level waittill(#"forever");
		}
	#/
	wait(1);
	/#
		level thread zm::print_zombie_counts();
		level thread zm::sndmusiconkillround();
	#/
	while(true)
	{
		if(level flag::get("ee_round"))
		{
			var_377730f = level.zombie_total > 0 || level.intermission;
			if(!var_377730f && level.var_a78effc7 == (level.round_number + 1))
			{
				level.var_a78effc7++;
			}
		}
		else
		{
			if(level flag::get("drop_pod_active"))
			{
				var_377730f = level.zombie_total > 0 || level.intermission || !level flag::get("advance_drop_pod_round");
				if(!var_377730f && level.var_a78effc7 == (level.round_number + 1))
				{
					level.var_a78effc7++;
				}
			}
			else
			{
				var_377730f = zombie_utility::get_current_zombie_count() > 0 || level.zombie_total > 0 || level.intermission;
			}
		}
		if(!var_377730f)
		{
			level thread zm_audio::sndmusicsystem_playstate("round_end");
			return;
		}
		if(level flag::get("end_round_wait"))
		{
			level thread zm_audio::sndmusicsystem_playstate("round_end");
			return;
		}
		wait(1);
	}
}

/*
	Name: function_965d1d83
	Namespace: zm_stalingrad
	Checksum: 0xA611E18E
	Offset: 0x7668
	Size: 0xB4
	Parameters: 3
	Flags: Linked
*/
function function_965d1d83(str_scene, str_flag, var_38cd507c = undefined)
{
	level scene::init(str_scene);
	if(isdefined(var_38cd507c))
	{
		level flag::wait_till_any(array(str_flag, var_38cd507c));
	}
	else
	{
		level flag::wait_till(str_flag);
	}
	level scene::play(str_scene);
}

/*
	Name: function_9c2d9678
	Namespace: zm_stalingrad
	Checksum: 0xE163FDB0
	Offset: 0x7728
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function function_9c2d9678()
{
	var_97e8ec5c = getentarray("debris_using_door_trigger", "script_label");
	foreach(var_81072907 in var_97e8ec5c)
	{
		var_81072907 zm_utility::set_hint_string(var_81072907, "default_buy_debris", var_81072907.zombie_cost);
	}
}

/*
	Name: function_a4a19f50
	Namespace: zm_stalingrad
	Checksum: 0x42A423ED
	Offset: 0x7800
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_a4a19f50()
{
	level thread scene::play("p7_fxanim_zm_stal_robot_arm_aperture_door_front_bundle");
	wait(0.66);
	level thread scene::play("p7_fxanim_zm_stal_robot_arm_aperture_door_bundle");
}

/*
	Name: function_f7b7d070
	Namespace: zm_stalingrad
	Checksum: 0x55C84B73
	Offset: 0x7858
	Size: 0x2A8
	Parameters: 3
	Flags: Linked
*/
function function_f7b7d070(player, var_65df0562, var_daaea4ad)
{
	var_65df0562.alignx = "center";
	var_65df0562.aligny = "middle";
	var_65df0562.horzalign = "center";
	var_65df0562.vertalign = "middle";
	var_65df0562.y = var_65df0562.y - 180;
	var_65df0562.foreground = 1;
	var_65df0562.fontscale = 3;
	var_65df0562.alpha = 0;
	var_65df0562.color = (1, 1, 1);
	var_65df0562.hidewheninmenu = 1;
	var_65df0562 settext(&"ZOMBIE_GAME_OVER");
	var_65df0562 fadeovertime(1);
	var_65df0562.alpha = 1;
	if(player issplitscreen())
	{
		var_65df0562.fontscale = 2;
		var_65df0562.y = var_65df0562.y + 40;
	}
	var_daaea4ad.alignx = "center";
	var_daaea4ad.aligny = "middle";
	var_daaea4ad.horzalign = "center";
	var_daaea4ad.vertalign = "middle";
	var_daaea4ad.y = var_daaea4ad.y - 150;
	var_daaea4ad.foreground = 1;
	var_daaea4ad.fontscale = 2;
	var_daaea4ad.alpha = 0;
	var_daaea4ad.color = (1, 1, 1);
	var_daaea4ad.hidewheninmenu = 1;
	if(player issplitscreen())
	{
		var_daaea4ad.fontscale = 1.5;
		var_daaea4ad.y = var_daaea4ad.y + 40;
	}
}

/*
	Name: function_12a6d70c
	Namespace: zm_stalingrad
	Checksum: 0xDAA4B7AC
	Offset: 0x7B08
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_12a6d70c()
{
	level waittill(#"start_zombie_round_logic");
	if(getdvarint("splitscreen_playerCount") >= 2)
	{
		return;
	}
	exploder::exploder("fxexp_945");
}

/*
	Name: function_de23a4cc
	Namespace: zm_stalingrad
	Checksum: 0xCC903C93
	Offset: 0x7B60
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function function_de23a4cc()
{
	level waittill(#"power_on");
	playsoundatposition("zmb_stalingrad_main_power_on", (0, 0, 0));
	exploder::exploder("power_on");
	exploder::exploder("eye_beam_factory_green");
	exploder::exploder("eye_beam_library_green");
	exploder::exploder("street_flinger_green");
	exploder::exploder("pavlov_flinger_right_green");
	exploder::exploder("pavlov_flinger_left_green");
	exploder::exploder("trap_finger_green");
	exploder::exploder("trap_bunker_green");
	exploder::exploder("trap_store_green");
	exploder::exploder("bridge_trap_green");
	level function_d1b24ba4(1);
	level function_52211d40(1);
	level function_a4a19f50();
	level thread function_cde49635();
}

/*
	Name: function_52211d40
	Namespace: zm_stalingrad
	Checksum: 0x340EF9A9
	Offset: 0x7CE8
	Size: 0x1B2
	Parameters: 1
	Flags: Linked
*/
function function_52211d40(var_7afe5e99)
{
	var_358abd8e = getentarray("sophia_vo_eye", "script_noteworthy");
	foreach(var_1c7b6837 in var_358abd8e)
	{
		switch(var_1c7b6837.model)
		{
			case "p7_zm_sta_drop_pod_console_blue":
			case "p7_zm_sta_drop_pod_console_red":
			case "p7_zm_sta_drop_pod_console_yellow":
			{
				var_cc8e7aaf = "tag_screen_eye_bg";
				var_f329b7ad = "tag_screen_eye_flatline";
				break;
			}
			case "p7_zm_sta_dragon_console":
			{
				var_cc8e7aaf = "tag_eye_bg_animate";
				var_f329b7ad = "tag_eye_flatline_animate";
				break;
			}
			default:
			{
				return;
			}
		}
		if(var_7afe5e99)
		{
			var_1c7b6837 clientfield::set("sophia_eye_shader", 1);
			var_1c7b6837 showpart(var_f329b7ad);
			continue;
		}
		var_1c7b6837 hidepart(var_cc8e7aaf);
		var_1c7b6837 hidepart(var_f329b7ad);
	}
}

/*
	Name: function_d1b24ba4
	Namespace: zm_stalingrad
	Checksum: 0xFD7EA14E
	Offset: 0x7EA8
	Size: 0x192
	Parameters: 1
	Flags: Linked
*/
function function_d1b24ba4(var_7afe5e99)
{
	var_eba08983 = getentarray("trap_switch", "script_string");
	if(var_7afe5e99)
	{
		foreach(var_cfa7c517 in var_eba08983)
		{
			var_cfa7c517 hidepart("tag_red_light");
			var_cfa7c517 showpart("tag_green_light");
		}
	}
	else
	{
		foreach(var_cfa7c517 in var_eba08983)
		{
			var_cfa7c517 showpart("tag_red_light");
			var_cfa7c517 hidepart("tag_green_light");
		}
	}
}

/*
	Name: function_cde49635
	Namespace: zm_stalingrad
	Checksum: 0x42B3DF9D
	Offset: 0x8048
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function function_cde49635()
{
	level endon(#"hash_deeb3634");
	wait(3);
	level clientfield::set("sophia_intro_outro", 1);
	wait(1);
	level zm_stalingrad_vo::function_8141c730();
	level notify(#"hash_423907c1");
	wait(0.75);
	callback::on_spawned(&function_c2ad8318);
	level thread function_a1369011();
	while(true)
	{
		e_player = arraygetclosest(level.var_a090a655.origin, level.activeplayers);
		e_player function_a9536aec();
		wait(4);
	}
}

/*
	Name: function_a9536aec
	Namespace: zm_stalingrad
	Checksum: 0xE916C8B9
	Offset: 0x8148
	Size: 0xEE
	Parameters: 0
	Flags: Linked
*/
function function_a9536aec()
{
	self endon(#"death");
	b_first_loop = 1;
	while(zm_utility::is_player_valid(self) && zm_stalingrad_util::function_86b1188c(750, level.var_a090a655, self))
	{
		if(b_first_loop)
		{
			b_first_loop = 0;
			level.var_f4f5346d = self;
			n_clientfield_val = self getentitynumber() + 1;
			self clientfield::set("sophia_follow", n_clientfield_val);
		}
		wait(1);
	}
	self clientfield::set("sophia_follow", 0);
	level.var_f4f5346d = undefined;
}

/*
	Name: function_c2ad8318
	Namespace: zm_stalingrad
	Checksum: 0x8270F64A
	Offset: 0x8240
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_c2ad8318()
{
	level thread function_fa9b2a93();
}

/*
	Name: function_fa9b2a93
	Namespace: zm_stalingrad
	Checksum: 0x37AF2158
	Offset: 0x8268
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_fa9b2a93()
{
	if(isdefined(level.var_f4f5346d))
	{
		n_clientfield_val = level.var_f4f5346d getentitynumber() + 1;
		level.var_f4f5346d clientfield::set("sophia_follow", n_clientfield_val);
	}
}

/*
	Name: function_a1369011
	Namespace: zm_stalingrad
	Checksum: 0xFA7D47DB
	Offset: 0x82D8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_a1369011()
{
	level waittill(#"hash_deeb3634");
	callback::remove_on_spawned(&function_c2ad8318);
}

/*
	Name: function_f9248bb
	Namespace: zm_stalingrad
	Checksum: 0x8D823A6D
	Offset: 0x8318
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function function_f9248bb()
{
	if(isdefined(self.var_fa6d2a24) && self.var_fa6d2a24)
	{
		return false;
	}
	return true;
}

/*
	Name: no_target_override
	Namespace: zm_stalingrad
	Checksum: 0x50BEBF07
	Offset: 0x8348
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function no_target_override(ai_zombie)
{
	if(isdefined(self.b_zombie_path_bad) && self.b_zombie_path_bad)
	{
		return;
	}
	if(isdefined(self.var_a779ca57) && self.var_a779ca57)
	{
		return;
	}
	var_6c8e700c = ai_zombie stalingrad_cleanup::get_escape_position_in_current_zone();
	if(isalive(ai_zombie) && isdefined(var_6c8e700c) && isdefined(var_6c8e700c.origin))
	{
		ai_zombie thread function_dc683d01(var_6c8e700c.origin);
	}
}

/*
	Name: function_dc683d01
	Namespace: zm_stalingrad
	Checksum: 0xAB5AD6F3
	Offset: 0x8408
	Size: 0xD6
	Parameters: 1
	Flags: Linked, Private
*/
function private function_dc683d01(var_b52b26b9)
{
	self endon(#"death");
	self notify(#"stop_find_flesh");
	self notify(#"zombie_acquire_enemy");
	self ai::set_ignoreall(1);
	self.b_zombie_path_bad = 1;
	self thread check_player_available();
	self setgoal(var_b52b26b9);
	self util::waittill_any("goal", "reaquire_player");
	self.ai_state = "find_flesh";
	self ai::set_ignoreall(0);
	self.b_zombie_path_bad = undefined;
}

/*
	Name: check_player_available
	Namespace: zm_stalingrad
	Checksum: 0xF8FA9A0D
	Offset: 0x84E8
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
	Namespace: zm_stalingrad
	Checksum: 0xDB7EC6FC
	Offset: 0x8568
	Size: 0x98
	Parameters: 0
	Flags: Linked, Private
*/
function private can_zombie_see_any_player()
{
	for(i = 0; i < level.activeplayers.size; i++)
	{
		if(zombie_utility::is_player_valid(level.activeplayers[i]) && self findpath(self.origin, level.activeplayers[i].origin, 1, 0))
		{
			return true;
		}
	}
	return false;
}

