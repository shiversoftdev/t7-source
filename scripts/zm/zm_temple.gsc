// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\behavior_zombie_dog;
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
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_napalm;
#using scripts\zm\_zm_ai_sonic;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
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
#using scripts\zm\_zm_radio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_server_throttle;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_annihilator;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_bowie;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_shrink_ray;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\zm_remaster_zombie;
#using scripts\zm\zm_temple_achievement;
#using scripts\zm\zm_temple_ai_monkey;
#using scripts\zm\zm_temple_amb;
#using scripts\zm\zm_temple_elevators;
#using scripts\zm\zm_temple_ffotd;
#using scripts\zm\zm_temple_fx;
#using scripts\zm\zm_temple_minecart;
#using scripts\zm\zm_temple_pack_a_punch;
#using scripts\zm\zm_temple_power;
#using scripts\zm\zm_temple_powerups;
#using scripts\zm\zm_temple_sq;
#using scripts\zm\zm_temple_traps;
#using scripts\zm\zm_temple_triggers;
#using scripts\zm\zm_temple_waterslide;
#using scripts\zm\zm_zmhd_cleanup_mgr;

#namespace zm_temple;

/*
	Name: opt_in
	Namespace: zm_temple
	Checksum: 0xDE247C7F
	Offset: 0x22B8
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
	Namespace: zm_temple
	Checksum: 0xD940F130
	Offset: 0x22E8
	Size: 0x834
	Parameters: 0
	Flags: Linked
*/
function main()
{
	zm_temple_ffotd::main_start();
	level.default_game_mode = "zclassic";
	level.default_start_location = "default";
	level._use_choke_weapon_hints = 1;
	level._use_choke_blockers = 1;
	level.zombiemode = 1;
	level._uses_sticky_grenades = 0;
	level._uses_taser_knuckles = 0;
	level.sndzhdaudio = 1;
	level.aat["zm_aat_blast_furnace"].validation_func = &function_339a163c;
	level.aat["zm_aat_dead_wire"].validation_func = &function_339a163c;
	level.aat["zm_aat_fire_works"].validation_func = &function_339a163c;
	level.aat["zm_aat_thunder_wall"].validation_func = &function_339a163c;
	level.aat["zm_aat_turned"].validation_func = &function_339a163c;
	level.random_pandora_box_start = 1;
	level._zombie_custom_add_weapons = &custom_add_weapons;
	level.register_offhand_weapons_for_level_defaults_override = &temple_offhand_weapon_overrride;
	level.riser_fx_on_client = 1;
	level.use_clientside_rock_tearin_fx = 1;
	level.use_clientside_board_fx = 1;
	function_80cb4231();
	zm_temple_sq::function_8a009481();
	level.var_e3a86334 = 121;
	visionset_mgr::register_info("overlay", "zm_ai_screecher_blur", 21000, level.var_e3a86334, 15, 1);
	level.check_for_alternate_poi = &check_if_should_avoid_poi;
	level._dontinitnotifymessage = 1;
	level._round_start_func = &zm::round_start;
	level.givecustomcharacters = &givecustomcharacters;
	initcharacterstartindex();
	level.shrink_ray_model_mapping_func = &temple_shrink_ray_model_mapping_func;
	level.use_zombie_heroes = 1;
	level flag::init("zm_temple_connected");
	init_sounds();
	setupmusic();
	zm_temple_fx::main();
	zm_temple_amb::main();
	init_random_perk_machines();
	zm::init_fx();
	load::main();
	level.default_laststandpistol = getweapon("pistol_m1911");
	level.default_solo_laststandpistol = getweapon("pistol_m1911_upgraded");
	level.laststandpistol = level.default_laststandpistol;
	level.start_weapon = level.default_laststandpistol;
	level thread zm::last_stand_pistol_rank_init();
	level.zombiemode = 1;
	level._zmbvoxlevelspecific = &init_level_specific_audio;
	level thread function_54bf648f();
	level thread spikemore_delete_all_on_end_game();
	include_weapons();
	level.pap_interaction_height = 47;
	level._allow_melee_weapon_switching = 1;
	level.player_intersection_tracker_override = &zombie_temple_player_intersection_tracker_override;
	level.deathcard_spawn_func = &temple_death_screen_cleanup;
	level.check_valid_spawn_override = &temple_check_valid_spawn;
	level.custom_ai_type = [];
	if(!isdefined(level.custom_ai_type))
	{
		level.custom_ai_type = [];
	}
	else if(!isarray(level.custom_ai_type))
	{
		level.custom_ai_type = array(level.custom_ai_type);
	}
	level.custom_ai_type[level.custom_ai_type.size] = &zm_temple_ai_monkey::init;
	level.max_perks = 4;
	level.max_solo_lives = 3;
	level.var_9aaae7ae = &function_869d6f66;
	level.var_48c4b2bf = &function_90b3897b;
	level.var_9e59cb5b = &function_f1ef26af;
	_zm_weap_cymbal_monkey::init();
	temple_sidequest_of_awesome();
	level thread zm::post_main();
	level thread zm::register_sidequest("EOA", "ZOMBIE_TEMPLE_SIDEQUEST");
	level.poi_positioning_func = &temple_poi_positioning_func;
	level.powerup_fx_func = &temple_powerup_fx_func;
	level.playerlaststand_func = &player_laststand_temple;
	level.zombie_total_set_func = &function_f10deff8;
	level.override_thundergun_damage_func = &zm_temple_traps::override_thundergun_damage_func;
	level thread zm_temple_power::init_electric_switch();
	zm_temple_powerups::init();
	level.zone_manager_init_func = &local_zone_init;
	init_zones[0] = "temple_start_zone";
	level thread zm_zonemgr::manage_zones(init_zones);
	level thread add_powerups_after_round_1();
	level thread zm_temple_elevators::init_elevator();
	level thread zm_temple_minecart::minecart_main();
	level thread zm_temple_waterslide::waterslide_main();
	level thread start_sparks();
	level thread zm_temple_traps::init_temple_traps();
	level thread zm_temple_pack_a_punch::init_pack_a_punch();
	level thread init_rolling_doors();
	level thread zm_temple_triggers::main();
	callback::on_connect(&temple_player_connect);
	level.player_out_of_playable_area_monitor_callback = &zombie_temple_player_out_of_playable_area_monitor_callback;
	level thread zm_temple_sq::start_temple_sidequest();
	level thread zm_perks::spare_change();
	/#
		adddebugcommand("");
		adddebugcommand("");
	#/
	scene::add_scene_func("cin_zmhd_sizzle_temple_cam", &cin_zmhd_sizzle_temple_cam, "play");
	zm_temple_ffotd::main_end();
}

/*
	Name: cin_zmhd_sizzle_temple_cam
	Namespace: zm_temple
	Checksum: 0x64709982
	Offset: 0x2B28
	Size: 0xCA
	Parameters: 1
	Flags: Linked
*/
function cin_zmhd_sizzle_temple_cam(a_ents)
{
	level.disable_print3d_ent = 1;
	foreach(var_6cae1ad0 in a_ents)
	{
		if(issubstr(var_6cae1ad0.model, "body"))
		{
			var_6cae1ad0 clientfield::set("zombie_has_eyes", 1);
		}
	}
}

/*
	Name: function_80cb4231
	Namespace: zm_temple
	Checksum: 0x881126F9
	Offset: 0x2C00
	Size: 0x3F4
	Parameters: 0
	Flags: Linked
*/
function function_80cb4231()
{
	clientfield::register("actor", "ragimpactgib", 21000, 1, "int");
	clientfield::register("scriptmover", "spiketrap", 21000, 1, "int");
	clientfield::register("scriptmover", "mazewall", 21000, 1, "int");
	clientfield::register("scriptmover", "weaksauce", 21000, 1, "int");
	clientfield::register("scriptmover", "hotsauce", 21000, 1, "int");
	clientfield::register("scriptmover", "sauceend", 21000, 1, "int");
	clientfield::register("scriptmover", "watertrail", 21000, 1, "int");
	clientfield::register("toplayer", "floorrumble", 21000, 1, "int");
	clientfield::register("toplayer", "minecart_rumble", 21000, 1, "int");
	clientfield::register("allplayers", "geyserfakestand", 21000, 1, "int");
	clientfield::register("allplayers", "geyserfakeprone", 21000, 1, "int");
	clientfield::register("world", "papspinners", 21000, 4, "int");
	clientfield::register("world", "water_wheel_right", 21000, 1, "int");
	clientfield::register("world", "water_wheel_left", 21000, 1, "int");
	clientfield::register("world", "waterfall_trap", 21000, 1, "int");
	clientfield::register("world", "time_transition", 21000, 1, "int");
	clientfield::register("allplayers", "player_legs_hide", 21000, 1, "int");
	clientfield::register("clientuimodel", "player_lives", 21000, 2, "int");
	clientfield::register("scriptmover", "zombie_has_eyes", 21000, 1, "int");
	visionset_mgr::register_info("overlay", "zm_waterfall_postfx", 21000, 20, 32, 1);
	visionset_mgr::register_info("overlay", "zm_temple_eclipse", 21000, 21, 1, 1);
}

/*
	Name: function_f10deff8
	Namespace: zm_temple
	Checksum: 0x17E38BBA
	Offset: 0x3000
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_f10deff8()
{
	level.monkeysspawnedthisround = 0;
	level.monkey_zombie_health = level.zombie_health;
	level.zombiesleftbeforenapalmspawn = randomintrange(int(level.zombie_total * 0.25), int(level.zombie_total * 0.75));
	level.zombiesleftbeforesonicspawn = randomintrange(int(level.zombie_total * 0.25), int(level.zombie_total * 0.75));
	level.zombiesleftbeforemonkeyspawn = randomintrange(int(level.zombie_total * 0.75), level.zombie_total);
}

/*
	Name: temple_player_connect
	Namespace: zm_temple
	Checksum: 0x8597DBDD
	Offset: 0x3130
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function temple_player_connect()
{
	self.movespeedscale = 1;
	level flag::set("zm_temple_connected");
}

/*
	Name: function_869d6f66
	Namespace: zm_temple
	Checksum: 0x557B036B
	Offset: 0x3170
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function function_869d6f66()
{
	if(!isdefined(self zm_bgb_anywhere_but_here::function_728dfe3()))
	{
		return false;
	}
	if(isdefined(self.on_slide) && self.on_slide)
	{
		return false;
	}
	if(isdefined(self.riding_geyser) && self.riding_geyser)
	{
		return false;
	}
	if(isdefined(self.is_on_minecart) && self.is_on_minecart)
	{
		return false;
	}
	return true;
}

/*
	Name: function_90b3897b
	Namespace: zm_temple
	Checksum: 0x4F126357
	Offset: 0x31F8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_90b3897b(ai)
{
	if(isdefined(ai.shrinked) && ai.shrinked)
	{
		return false;
	}
	if(isdefined(ai.animname) && ai.animname == "napalm_zombie")
	{
		return false;
	}
	return true;
}

/*
	Name: function_f1ef26af
	Namespace: zm_temple
	Checksum: 0x3B7EB3EE
	Offset: 0x3270
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_f1ef26af(ai)
{
	if(isdefined(ai.animname) && ai.animname == "napalm_zombie")
	{
		return false;
	}
	if(isalive(ai) && ai.archetype === "zombie" && ai.team === level.zombie_team)
	{
		return true;
	}
	return false;
}

/*
	Name: function_339a163c
	Namespace: zm_temple
	Checksum: 0x9E2022CD
	Offset: 0x3318
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function function_339a163c()
{
	if(isdefined(self) && (isdefined(self.shrinked) && self.shrinked))
	{
		return false;
	}
	return true;
}

/*
	Name: temple_sidequest_of_awesome
	Namespace: zm_temple
	Checksum: 0x64C45EBF
	Offset: 0x3350
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function temple_sidequest_of_awesome()
{
	zm_temple_sq::init();
}

/*
	Name: start_sparks
	Namespace: zm_temple
	Checksum: 0x556C2CEC
	Offset: 0x3370
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function start_sparks()
{
	wait(2);
	exploder::exploder("fxexp_25");
	exploder::exploder("fxexp_26");
}

/*
	Name: init_sounds
	Namespace: zm_temple
	Checksum: 0x58F77F59
	Offset: 0x33B8
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function init_sounds()
{
	zm_utility::add_sound("door_stone_disc", "zmb_door_stone_disc");
	zm_utility::add_sound("zmb_door_wood", "zmb_door_wood");
	zm_utility::add_sound("door_spike", "zmb_door_spike");
	level thread custom_add_vox();
	level.vox_response_override = 1;
}

/*
	Name: setupmusic
	Namespace: zm_temple
	Checksum: 0x253FEB69
	Offset: 0x3448
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function setupmusic()
{
	zm_audio::musicstate_create("round_start", 3, "round_start_temple_1", "round_start_temple_2", "round_start_temple_3", "round_start_temple_4");
	zm_audio::musicstate_create("round_start_short", 3, "round_start_temple_1", "round_start_temple_2", "round_start_temple_3", "round_start_temple_4");
	zm_audio::musicstate_create("round_start_first", 3, "round_start_temple_1");
	zm_audio::musicstate_create("round_end", 3, "round_end_temple_1");
	zm_audio::musicstate_create("game_over", 5, "game_over_zhd_temple");
	zm_audio::musicstate_create("pareidolia", 4, "pareidolia");
	zm_audio::musicstate_create("none", 4, "none");
	zm_audio::musicstate_create("sam", 4, "sam");
}

/*
	Name: assign_lowest_unused_character_index
	Namespace: zm_temple
	Checksum: 0x98E97943
	Offset: 0x35C8
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
	Name: givecustomcharacters
	Namespace: zm_temple
	Checksum: 0x5649BA3F
	Offset: 0x37E8
	Size: 0x2F4
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
		case 0:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("frag_grenade");
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("bouncingbetty");
			break;
		}
		case 1:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("870mcs");
			break;
		}
		case 2:
		{
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("hk416");
			break;
		}
		case 3:
		{
			self.talks_in_danger = 1;
			level.rich_sq_player = self;
			level.sndradioa = self;
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = getweapon("pistol_standard");
			break;
		}
	}
	level.vox zm_audio::zmbvoxinitspeaker("player", "vox_plr_", self);
	self thread zm_audio_zhd::set_exert_id();
	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
}

/*
	Name: initcharacterstartindex
	Namespace: zm_temple
	Checksum: 0xCC330BC8
	Offset: 0x3AE8
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
	Namespace: zm_temple
	Checksum: 0xEDF07805
	Offset: 0x3B18
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
	Name: local_zone_init
	Namespace: zm_temple
	Checksum: 0xE3C1B020
	Offset: 0x3B60
	Size: 0x2C4
	Parameters: 0
	Flags: Linked
*/
function local_zone_init()
{
	level flag::init("always_on");
	level flag::set("always_on");
	zm_zonemgr::add_adjacent_zone("temple_start_zone", "pressure_plate_zone", "start_to_pressure");
	zm_zonemgr::add_adjacent_zone("temple_start_zone", "waterfall_upper1_zone", "start_to_waterfall_upper");
	zm_zonemgr::add_adjacent_zone("pressure_plate_zone", "cave_tunnel_zone", "pressure_to_cave01");
	zm_zonemgr::add_adjacent_zone("caves1_zone", "cave_tunnel_zone", "pressure_to_cave01");
	zm_zonemgr::add_adjacent_zone("waterfall_lower_zone", "waterfall_tunnel_zone", "waterfall_to_tunnel");
	zm_zonemgr::add_adjacent_zone("waterfall_tunnel_zone", "waterfall_tunnel_a_zone", "waterfall_to_tunnel");
	zm_zonemgr::add_adjacent_zone("waterfall_tunnel_a_zone", "waterfall_upper_zone", "waterfall_to_tunnel");
	zm_zonemgr::add_adjacent_zone("waterfall_upper1_zone", "waterfall_upper_zone", "start_to_waterfall_upper");
	zm_zonemgr::add_adjacent_zone("waterfall_upper1_zone", "waterfall_upper_zone", "waterfall_to_tunnel");
	zm_zonemgr::add_adjacent_zone("caves1_zone", "caves2_zone", "cave01_to_cave02");
	zm_zonemgr::add_adjacent_zone("caves3_zone", "power_room_zone", "cave03_to_power");
	zm_zonemgr::add_adjacent_zone("caves_water_zone", "power_room_zone", "cave_water_to_power");
	zm_zonemgr::add_adjacent_zone("caves_water_zone", "waterfall_lower_zone", "cave_water_to_waterfall");
	zm_zonemgr::add_adjacent_zone("caves2_zone", "caves3_zone", "cave01_to_cave02");
	zm_zonemgr::add_adjacent_zone("caves2_zone", "caves3_zone", "cave02_to_cave_water");
	zm_zonemgr::add_adjacent_zone("caves2_zone", "caves3_zone", "cave03_to_power");
}

/*
	Name: function_54bf648f
	Namespace: zm_temple
	Checksum: 0x7266D540
	Offset: 0x3E30
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
	Namespace: zm_temple
	Checksum: 0x839D1F0F
	Offset: 0x3E70
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
	Name: include_weapons
	Namespace: zm_temple
	Checksum: 0x99EC1590
	Offset: 0x4080
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function include_weapons()
{
}

/*
	Name: custom_add_weapons
	Namespace: zm_temple
	Checksum: 0x7CAE88F9
	Offset: 0x4090
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_temple_weapons.csv", 1);
}

/*
	Name: custom_add_vox
	Namespace: zm_temple
	Checksum: 0x66CB42B9
	Offset: 0x40C0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function custom_add_vox()
{
	zm_audio::loadplayervoicecategories("gamedata/audio/zm/zm_temple_vox.csv");
	level thread init_level_specific_audio();
}

/*
	Name: add_powerups_after_round_1
	Namespace: zm_temple
	Checksum: 0xF5BAA6BA
	Offset: 0x4100
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function add_powerups_after_round_1()
{
	/#
		if(getdvarint("") > 0)
		{
			return;
		}
	#/
	level.zombie_powerup_array = array_remove(level.zombie_powerup_array, "nuke");
	level.zombie_powerup_array = array_remove(level.zombie_powerup_array, "fire_sale");
	while(true)
	{
		if(level.round_number > 1)
		{
			if(!isdefined(level.zombie_powerup_array))
			{
				level.zombie_powerup_array = [];
			}
			else if(!isarray(level.zombie_powerup_array))
			{
				level.zombie_powerup_array = array(level.zombie_powerup_array);
			}
			level.zombie_powerup_array[level.zombie_powerup_array.size] = "nuke";
			if(!isdefined(level.zombie_powerup_array))
			{
				level.zombie_powerup_array = [];
			}
			else if(!isarray(level.zombie_powerup_array))
			{
				level.zombie_powerup_array = array(level.zombie_powerup_array);
			}
			level.zombie_powerup_array[level.zombie_powerup_array.size] = "fire_sale";
			break;
		}
		wait(1);
	}
}

/*
	Name: mergesort
	Namespace: zm_temple
	Checksum: 0xDE0E2B7A
	Offset: 0x4290
	Size: 0x1CC
	Parameters: 2
	Flags: Linked
*/
function mergesort(current_list, less_than)
{
	if(current_list.size <= 1)
	{
		return current_list;
	}
	left = [];
	right = [];
	middle = current_list.size / 2;
	for(x = 0; x < middle; x++)
	{
		if(!isdefined(left))
		{
			left = [];
		}
		else if(!isarray(left))
		{
			left = array(left);
		}
		left[left.size] = current_list[x];
	}
	while(x < current_list.size)
	{
		if(!isdefined(right))
		{
			right = [];
		}
		else if(!isarray(right))
		{
			right = array(right);
		}
		right[right.size] = current_list[x];
		x++;
	}
	left = mergesort(left, less_than);
	right = mergesort(right, less_than);
	result = merge(left, right, less_than);
	return result;
}

/*
	Name: merge
	Namespace: zm_temple
	Checksum: 0x66664FF8
	Offset: 0x4468
	Size: 0x13A
	Parameters: 3
	Flags: Linked
*/
function merge(left, right, less_than)
{
	result = [];
	li = 0;
	ri = 0;
	while(li < left.size && ri < right.size)
	{
		if([[less_than]](left[li], right[ri]))
		{
			result[result.size] = left[li];
			li++;
		}
		else
		{
			result[result.size] = right[ri];
			ri++;
		}
	}
	while(li < left.size)
	{
		result[result.size] = left[li];
		li++;
	}
	while(ri < right.size)
	{
		result[result.size] = right[ri];
		ri++;
	}
	return result;
}

/*
	Name: init_rolling_doors
	Namespace: zm_temple
	Checksum: 0x7285D8D8
	Offset: 0x45B0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function init_rolling_doors()
{
	rollingdoors = getentarray("rolling_door", "targetname");
	array::thread_all(rollingdoors, &rolling_door_think);
}

/*
	Name: rolling_door_think
	Namespace: zm_temple
	Checksum: 0x1A5F0448
	Offset: 0x4610
	Size: 0x224
	Parameters: 0
	Flags: Linked
*/
function rolling_door_think()
{
	self.door_movedir = anglestoforward(self.angles);
	self.door_movedist = self.script_float;
	self.door_movetime = self.script_timer;
	self.door_radius = self.script_radius;
	self.door_wait = self.script_string;
	if(self.script_string == "waterfall_to_tunnel")
	{
		str_exploder = "fxexp_2";
	}
	else
	{
		str_exploder = "fxexp_1";
	}
	level flag::wait_till(self.door_wait);
	playsoundatposition("evt_door_stone_disc", self.origin);
	self zm_utility::play_sound_on_ent("purchase");
	exploder::exploder(str_exploder);
	pi = 3.141593;
	endorigin = self.origin + (self.door_movedir * self.door_movedist);
	self moveto(endorigin, self.door_movetime, 0.1, 0.1);
	cir = (2 * pi) * self.door_radius;
	rotate = (self.door_movedist / cir) * 360;
	self rotateto(self.angles + (rotate, 0, 0), self.door_movetime, 0.1, 0.1);
	self connectpaths();
}

/*
	Name: player_laststand_temple
	Namespace: zm_temple
	Checksum: 0x76DCBC9F
	Offset: 0x4840
	Size: 0xAC
	Parameters: 9
	Flags: Linked
*/
function player_laststand_temple(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	if(isdefined(self.riding_geyser) && self.riding_geyser)
	{
		self unlink();
	}
	self zm::player_laststand(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration);
}

/*
	Name: temple_poi_positioning_func
	Namespace: zm_temple
	Checksum: 0xD16ECDE7
	Offset: 0x48F8
	Size: 0x4A
	Parameters: 2
	Flags: Linked
*/
function temple_poi_positioning_func(origin, forward)
{
	return zm_server_throttle::server_safe_ground_trace_ignore_water("poi_trace", 10, (self.origin + forward) + vectorscale((0, 0, 1), 10));
}

/*
	Name: temple_powerup_fx_func
	Namespace: zm_temple
	Checksum: 0xD2F543FD
	Offset: 0x4950
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function temple_powerup_fx_func()
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

/*
	Name: init_random_perk_machines
	Namespace: zm_temple
	Checksum: 0x713FDE07
	Offset: 0x4A10
	Size: 0x512
	Parameters: 0
	Flags: Linked
*/
function init_random_perk_machines()
{
	randmachines = [];
	randmachines = _add_machine(randmachines, "vending_jugg", "mus_perks_jugganog_sting", "specialty_armorvest", "mus_perks_jugganog_jingle", "jugg_perk", "p7_zm_vending_jugg");
	randmachines = _add_machine(randmachines, "vending_marathon", "mus_perks_stamin_sting", "specialty_staminup", "mus_perks_stamin_jingle", "marathon_perk", "p7_zm_vending_marathon");
	randmachines = _add_machine(randmachines, "vending_deadshot", "mus_perks_deadshot_sting", "specialty_deadshot", "mus_perks_deadshot_jingle", "deadshot_perk", "p7_zm_vending_three_gun");
	randmachines = _add_machine(randmachines, "vending_sleight", "mus_perks_speed_sting", "specialty_fastreload", "mus_perks_speed_jingle", "speedcola_perk", "p7_zm_vending_sleight");
	randmachines = _add_machine(randmachines, "vending_doubletap", "mus_perks_doubletap_sting", "specialty_doubletap2", "mus_perks_doubletap_jingle", "tap_perk", "p7_zm_vending_doubletap2");
	randmachines = _add_machine(randmachines, "vending_widowswine", "mus_perks_phd_sting", "specialty_widowswine", "mus_perks_phd_jingle", "widowswine_perk", "p7_zm_vending_widows_wine");
	machines = struct::get_array("zm_perk_machine", "targetname");
	for(i = machines.size - 1; i >= 0; i--)
	{
		if(isdefined(machines[i].script_noteworthy))
		{
			machines = array_remove(machines, machines[i]);
		}
	}
	for(i = 0; i < machines.size; i++)
	{
		machine = machines[i];
		machine.allowed = [];
		if(isdefined(machine.script_parameters))
		{
			machine.allowed = strtok(machine.script_parameters, ",");
		}
		if(machine.allowed.size == 0)
		{
			machine.allowed = array("jugg_perk", "marathon_perk", "widowswine_perk", "deadshot_perk", "speedcola_perk", "tap_perk");
		}
		machine.allowed = array::randomize(machine.allowed);
	}
	machines = mergesort(machines, &perk_machines_compare_func);
	for(i = 0; i < machines.size; i++)
	{
		machine = machines[i];
		randmachine = undefined;
		for(j = 0; j < machine.allowed.size; j++)
		{
			index = _rand_perk_index(randmachines, machine.allowed[j]);
			if(isdefined(index))
			{
				randmachine = randmachines[index];
				randmachines = array_remove(randmachines, randmachine);
				break;
			}
		}
		/#
			assert(isdefined(randmachine), "");
		#/
		machine.script_noteworthy = randmachine.script_noteworthy;
		machine.targetname = randmachine.targetname;
		machine.model = randmachine.model;
	}
}

/*
	Name: array_remove
	Namespace: zm_temple
	Checksum: 0xB8546148
	Offset: 0x4F30
	Size: 0x11C
	Parameters: 2
	Flags: Linked
*/
function array_remove(array, object)
{
	if(!isdefined(array) && !isdefined(object))
	{
		return;
	}
	new_array = [];
	foreach(item in array)
	{
		if(item != object)
		{
			if(!isdefined(new_array))
			{
				new_array = [];
			}
			else if(!isarray(new_array))
			{
				new_array = array(new_array);
			}
			new_array[new_array.size] = item;
		}
	}
	return new_array;
}

/*
	Name: _rand_perk_index
	Namespace: zm_temple
	Checksum: 0x5224AB44
	Offset: 0x5058
	Size: 0x62
	Parameters: 2
	Flags: Linked
*/
function _rand_perk_index(randmachines, name)
{
	for(i = 0; i < randmachines.size; i++)
	{
		if(randmachines[i].script_string == name)
		{
			return i;
		}
	}
	return undefined;
}

/*
	Name: perk_machines_compare_func
	Namespace: zm_temple
	Checksum: 0x39C4D33D
	Offset: 0x50C8
	Size: 0x36
	Parameters: 2
	Flags: Linked
*/
function perk_machines_compare_func(m1, m2)
{
	return m1.allowed.size < m2.allowed.size;
}

/*
	Name: _add_machine
	Namespace: zm_temple
	Checksum: 0xAD904A2F
	Offset: 0x5108
	Size: 0xAA
	Parameters: 7
	Flags: Linked
*/
function _add_machine(machines, target, script_label, script_noteworthy, script_sound, script_string, model)
{
	s = spawnstruct();
	s.script_noteworthy = script_noteworthy;
	s.script_string = script_string;
	s.model = model;
	machines[machines.size] = s;
	return machines;
}

/*
	Name: random_node_toggle
	Namespace: zm_temple
	Checksum: 0xF1BCC547
	Offset: 0x51C0
	Size: 0xC8
	Parameters: 4
	Flags: None
*/
function random_node_toggle(minon, maxon, minoff, maxoff)
{
	target = getnode(self.target, "targetname");
	if(!isdefined(target))
	{
		return;
	}
	while(true)
	{
		wait(randomfloatrange(minon, maxoff));
		unlinknodes(self, target);
		wait(randomfloatrange(minoff, maxoff));
		linknodes(self, target);
	}
}

/*
	Name: temple_offhand_weapon_overrride
	Namespace: zm_temple
	Checksum: 0xCA4D0052
	Offset: 0x5290
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function temple_offhand_weapon_overrride()
{
	zm_utility::register_lethal_grenade_for_level("frag_grenade");
	level.zombie_lethal_grenade_player_init = getweapon("frag_grenade");
	zm_utility::register_tactical_grenade_for_level("cymbal_monkey");
	zm_utility::register_tactical_grenade_for_level("cymbal_monkey_upgraded");
	zm_utility::register_tactical_grenade_for_level("emp_grenade");
	zm_utility::register_melee_weapon_for_level(level.weaponbasemelee.name);
	zm_utility::register_melee_weapon_for_level("bowie_knife");
	level.zombie_melee_weapon_player_init = level.weaponbasemelee;
	level.zombie_equipment_player_init = undefined;
}

/*
	Name: temple_shrink_ray_model_mapping_func
	Namespace: zm_temple
	Checksum: 0xBAA75036
	Offset: 0x5370
	Size: 0x42A
	Parameters: 0
	Flags: Linked
*/
function temple_shrink_ray_model_mapping_func()
{
	level.shrink_models["c_t7_zm_dlchd_shangrila_napalm_body"] = "c_t7_zm_dlchd_shangrila_napalm_mini_fb";
	level.shrink_models["c_t7_zm_dlchd_shangrila_sonic_body"] = "c_t7_zm_dlchd_shangrila_sonic_mini_fb";
	level.shrink_models["c_t7_zm_dlchd_shangrila_vietcong_head"] = "c_t7_zm_dlchd_shangrila_vietcong_mini_head";
	level.shrink_models["c_t7_zm_dlchd_shangrila_vietcong_body"] = "c_t7_zm_dlchd_shangrila_vietcong_mini_body";
	level.shrink_models["c_t7_zm_dlchd_shangrila_nva_head"] = "c_t7_zm_dlchd_shangrila_nva_mini_head";
	level.shrink_models["c_t7_zm_dlchd_shangrila_nva_head2"] = "c_t7_zm_dlchd_shangrila_nva_mini_head2";
	level.shrink_models["c_t7_zm_dlchd_shangrila_nva_body"] = "c_t7_zm_dlchd_shangrila_nva_mini_body";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_head"] = "c_t7_zm_dlchd_shangrila_fem_mini_head";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_body"] = "c_t7_zm_dlchd_shangrila_fem_mini_body";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_body2"] = "c_t7_zm_dlchd_shangrila_fem_mini_body2";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_g_blegsoff2"] = "c_t7_zm_dlchd_shangrila_mini_fem_g_blegsoff2";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_g_llegoff2"] = "c_t7_zm_dlchd_shangrila_mini_fem_g_llegoff2";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_g_loclean2"] = "c_t7_zm_dlchd_shangrila_mini_fem_g_loclean2";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_g_rarmoff2"] = "c_t7_zm_dlchd_shangrila_mini_fem_g_rarmoff2";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_g_rlegoff2"] = "c_t7_zm_dlchd_shangrila_mini_fem_g_rlegoff2";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_g_upclean2"] = "c_t7_zm_dlchd_shangrila_mini_fem_g_upclean2";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_g_larmoff2"] = "c_t7_zm_dlchd_shangrila_mini_fem_g_larmoff2";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_g_blegsoff"] = "c_t7_zm_dlchd_shangrila_mini_fem_g_blegsoff";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_g_llegoff"] = "c_t7_zm_dlchd_shangrila_mini_fem_g_llegoff";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_g_loclean"] = "c_t7_zm_dlchd_shangrila_mini_fem_g_loclean";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_g_rarmoff"] = "c_t7_zm_dlchd_shangrila_mini_fem_g_rarmoff";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_g_rlegoff"] = "c_t7_zm_dlchd_shangrila_mini_fem_g_rlegoff";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_g_upclean"] = "c_t7_zm_dlchd_shangrila_mini_fem_g_upclean";
	level.shrink_models["c_t7_zm_dlchd_shangrila_fem_g_larmoff"] = "c_t7_zm_dlchd_shangrila_mini_fem_g_larmoff";
	level.shrink_models["c_t7_zm_dlchd_shangrila_nva_g_blegsoff"] = "c_t7_zm_dlchd_shangrila_nva_mini_g_blegsoff";
	level.shrink_models["c_t7_zm_dlchd_shangrila_nva_g_llegoff"] = "c_t7_zm_dlchd_shangrila_nva_mini_g_llegoff";
	level.shrink_models["c_t7_zm_dlchd_shangrila_nva_g_loclean"] = "c_t7_zm_dlchd_shangrila_nva_mini_g_loclean";
	level.shrink_models["c_t7_zm_dlchd_shangrila_nva_g_rarmoff"] = "c_t7_zm_dlchd_shangrila_nva_mini_g_rarmoff";
	level.shrink_models["c_t7_zm_dlchd_shangrila_nva_g_rlegoff"] = "c_t7_zm_dlchd_shangrila_nva_mini_g_rlegoff";
	level.shrink_models["c_t7_zm_dlchd_shangrila_nva_g_upclean"] = "c_t7_zm_dlchd_shangrila_nva_mini_g_upclean";
	level.shrink_models["c_t7_zm_dlchd_shangrila_nva_g_larmoff"] = "c_t7_zm_dlchd_shangrila_nva_mini_g_larmoff";
	level.shrink_models["c_t7_zm_dlchd_shangrila_vietcong_g_blegsoff"] = "c_t7_zm_dlchd_shangrila_vietcong_mini_g_blegsoff";
	level.shrink_models["c_t7_zm_dlchd_shangrila_vietcong_g_llegoff"] = "c_t7_zm_dlchd_shangrila_vietcong_mini_g_llegoff";
	level.shrink_models["c_t7_zm_dlchd_shangrila_vietcong_g_loclean"] = "c_t7_zm_dlchd_shangrila_vietcong_mini_g_loclean";
	level.shrink_models["c_t7_zm_dlchd_shangrila_vietcong_g_rarmoff"] = "c_t7_zm_dlchd_shangrila_vietcong_mini_g_rarmoff";
	level.shrink_models["c_t7_zm_dlchd_shangrila_vietcong_g_rlegoff"] = "c_t7_zm_dlchd_shangrila_vietcong_mini_g_rlegoff";
	level.shrink_models["c_t7_zm_dlchd_shangrila_vietcong_g_upclean"] = "c_t7_zm_dlchd_shangrila_vietcong_mini_g_upclean";
	level.shrink_models["c_t7_zm_dlchd_shangrila_vietcong_g_larmoff"] = "c_t7_zm_dlchd_shangrila_vietcong_mini_g_larmoff";
}

/*
	Name: check_if_should_avoid_poi
	Namespace: zm_temple
	Checksum: 0x3E2AA6A5
	Offset: 0x57A8
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function check_if_should_avoid_poi()
{
	if(isdefined(self.sliding) && self.sliding)
	{
		return true;
	}
	return false;
}

/*
	Name: zombie_temple_player_intersection_tracker_override
	Namespace: zm_temple
	Checksum: 0xECAA5BFA
	Offset: 0x57D8
	Size: 0x56
	Parameters: 1
	Flags: Linked
*/
function zombie_temple_player_intersection_tracker_override(other_player)
{
	if(isdefined(self.riding_geyser) && self.riding_geyser)
	{
		return true;
	}
	if(isdefined(other_player.riding_geyser) && other_player.riding_geyser)
	{
		return true;
	}
	return false;
}

/*
	Name: zombie_temple_player_out_of_playable_area_monitor_callback
	Namespace: zm_temple
	Checksum: 0x92CAFF0
	Offset: 0x5838
	Size: 0x5A
	Parameters: 0
	Flags: Linked
*/
function zombie_temple_player_out_of_playable_area_monitor_callback()
{
	if(isdefined(self.on_slide) && self.on_slide)
	{
		return false;
	}
	if(isdefined(self.riding_geyser) && self.riding_geyser)
	{
		return false;
	}
	if(isdefined(self.is_on_minecart) && self.is_on_minecart)
	{
		return false;
	}
	return true;
}

/*
	Name: function_317895cd
	Namespace: zm_temple
	Checksum: 0xE9B65F37
	Offset: 0x58A0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_317895cd()
{
	util::wait_network_frame();
	util::wait_network_frame();
	self setblur(0, 0.1);
}

/*
	Name: temple_death_screen_cleanup
	Namespace: zm_temple
	Checksum: 0x15DF980A
	Offset: 0x58F0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function temple_death_screen_cleanup()
{
	self clientfield::set_to_player("floorrumble", 0);
	self thread function_317895cd();
}

/*
	Name: spikemore_delete_all_on_end_game
	Namespace: zm_temple
	Checksum: 0xAFB68EA3
	Offset: 0x5938
	Size: 0x76
	Parameters: 0
	Flags: Linked
*/
function spikemore_delete_all_on_end_game()
{
	level waittill(#"end_game");
	if(!isdefined(level.spikemores))
	{
		return;
	}
	for(i = level.spikemores.size - 1; i >= 0; i--)
	{
		level.spikemores[i] delete();
	}
}

/*
	Name: temple_check_valid_spawn
	Namespace: zm_temple
	Checksum: 0x6B3C54A2
	Offset: 0x59B8
	Size: 0x1A8
	Parameters: 1
	Flags: Linked
*/
function temple_check_valid_spawn(revivee)
{
	spawn_points = struct::get_array("player_respawn_point", "targetname");
	zkeys = getarraykeys(level.zones);
	for(z = 0; z < zkeys.size; z++)
	{
		zone_str = zkeys[z];
		if(level.zones[zone_str].is_occupied)
		{
			for(i = 0; i < spawn_points.size; i++)
			{
				if(spawn_points[i].script_noteworthy == zone_str)
				{
					spawn_array = struct::get_array(spawn_points[i].target, "targetname");
					for(j = 0; j < spawn_array.size; j++)
					{
						if(spawn_array[j].script_int == (revivee.entity_num + 1))
						{
							return spawn_array[j];
						}
					}
					return spawn_array[0];
				}
			}
		}
	}
	return undefined;
}

/*
	Name: init_level_specific_audio
	Namespace: zm_temple
	Checksum: 0xF299B5E2
	Offset: 0x5B68
	Size: 0x854
	Parameters: 0
	Flags: Linked
*/
function init_level_specific_audio()
{
	level.vox zm_audio::zmbvoxadd("general", "intro", "level_start", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "door_deny", "nomoney", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "perk_deny", "nomoney", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "no_money_weapon", "nomoney", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "location_maze", "location_maze", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "location_waterfall", "location_waterfall", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "mine_see", "mine_see", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "mine_ride", "mine_ride", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "spikes_close", "spikes_close", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "spikes_damage", "spikes_dmg", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "geyser", "geyser", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "slide", "slide", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "poweron", "power_on", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "sonic_spawn", "sonic_spawn", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "sonic_hit", "sonic_dmg", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "napalm_spawn", "napalm_spawn", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "thief_steal", "thief_steal", 100, 0);
	level.vox zm_audio::zmbvoxadd("general", "start", "start", 100, 0);
	level.vox zm_audio::zmbvoxadd("kill", "sonic", "sonic_kill", 100, 0, 60);
	level.vox zm_audio::zmbvoxadd("kill", "napalm", "napalm_kill", 100, 0, 60);
	level.vox zm_audio::zmbvoxadd("kill", "shrink", "kill_shrink", 100, 0, 60);
	level.vox zm_audio::zmbvoxadd("kill", "shrunken", "kill_shrunken", 100, 0, 120);
	level.vox zm_audio::zmbvoxadd("kill", "spikemore", "kill_spikemore", 100, 0, 60);
	level.vox zm_audio::zmbvoxadd("kill", "thief", "kill_thief", 100, 0);
	level.vox zm_audio::zmbvoxadd("weapon_pickup", "shrink", "wpck_shrink", 100, 0);
	level.vox zm_audio::zmbvoxadd("box_pickup", "shrink_ray", "wpck_shrink", 100, 0);
	level.vox zm_audio::zmbvoxadd("weapon_pickup", "spikemore", "wpck_spikemore", 100, 0);
	level.vox zm_audio::zmbvoxadd("eggs", "quest1", "quest_step1", 100, 0);
	level.vox zm_audio::zmbvoxadd("eggs", "quest2", "quest_step2", 100, 0);
	level.vox zm_audio::zmbvoxadd("eggs", "quest3", "quest_step3", 100, 0);
	level.vox zm_audio::zmbvoxadd("eggs", "quest4", "quest_step4", 100, 0);
	level.vox zm_audio::zmbvoxadd("eggs", "quest5", "quest_step5", 100, 0);
	level.vox zm_audio::zmbvoxadd("eggs", "quest6", "quest_step6", 100, 0);
	level.vox zm_audio::zmbvoxadd("eggs", "quest7", "quest_step7", 100, 0);
	level.vox zm_audio::zmbvoxadd("eggs", "quest8", "quest_step8", 100, 0);
	level.vox zm_audio::zmbvoxadd("eggs", "rod", "rod", 100, 0);
	level.vox zm_audio::zmbvoxadd("eggs", "meteors", "egg_pedastool", 100, 0);
	level.vox zm_audio::zmbvoxadd("eggs", "music_activate", "secret", 100, 0);
}

