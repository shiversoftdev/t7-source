// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\behavior_zombie_dog;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_net;
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
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_annihilator;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\zm_sumpf_achievements;
#using scripts\zm\zm_sumpf_ffotd;
#using scripts\zm\zm_sumpf_fx;
#using scripts\zm\zm_sumpf_magic_box;
#using scripts\zm\zm_sumpf_zombie;
#using scripts\zm\zm_zmhd_cleanup_mgr;

#namespace zm_sumpf;

/*
	Name: opt_in
	Namespace: zm_sumpf
	Checksum: 0x6C36654
	Offset: 0x11A0
	Size: 0x1C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec opt_in()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
}

/*
	Name: main
	Namespace: zm_sumpf
	Checksum: 0xC368B186
	Offset: 0x11C8
	Size: 0x68C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread zm_sumpf_ffotd::main_start();
	level.default_game_mode = "zclassic";
	level.default_start_location = "default";
	level.use_water_risers = 1;
	level.sndzhdaudio = 1;
	level._zombie_custom_add_weapons = &custom_add_weapons;
	zm_sumpf_fx::main();
	zm::init_fx();
	level._zmbvoxlevelspecific = &init_level_specific_audio;
	level.randomize_perks = 0;
	level.pulls_since_last_ray_gun = 0;
	level.pulls_since_last_tesla_gun = 0;
	level.player_drops_tesla_gun = 0;
	level.door_dialog_function = &zm::play_door_dialog;
	level.dogs_enabled = 1;
	level.zombie_rise_spawners = [];
	level.burning_zombies = [];
	level.use_zombie_heroes = 1;
	level.kzmb_name = "sumpf_kzmb";
	level.custom_ai_type = [];
	if(!isdefined(level.custom_ai_type))
	{
		level.custom_ai_type = [];
	}
	else if(!isarray(level.custom_ai_type))
	{
		level.custom_ai_type = array(level.custom_ai_type);
	}
	level.custom_ai_type[level.custom_ai_type.size] = &zm_ai_dogs::init;
	level.register_offhand_weapons_for_level_defaults_override = &offhand_weapon_overrride;
	level.use_zombie_heroes = 1;
	level.givecustomcharacters = &givecustomcharacters;
	initcharacterstartindex();
	level._round_start_func = &zm::round_start;
	level._effect["zombie_grain"] = "misc/fx_zombie_grain_cloud";
	init_zombie_sumpf();
	clientfield::register("world", "SUMPF_VISIONSET_DOGS", 21000, 1, "int");
	clientfield::register("actor", "zombie_flogger_trap", 21000, 1, "int");
	clientfield::register("allplayers", "player_legs_hide", 21000, 1, "int");
	clientfield::register("clientuimodel", "player_lives", 1, 2, "int");
	include_perks_in_random_rotation();
	load::main();
	level.default_laststandpistol = getweapon("pistol_m1911");
	level.default_solo_laststandpistol = getweapon("pistol_m1911_upgraded");
	level.laststandpistol = level.default_laststandpistol;
	level.start_weapon = level.default_laststandpistol;
	level thread zm::last_stand_pistol_rank_init();
	function_12859198();
	level thread zm_perks::spare_change();
	_zm_weap_cymbal_monkey::init();
	_zm_weap_tesla::init();
	zm_ai_dogs::enable_dog_rounds();
	level.zones = [];
	level.zone_manager_init_func = &sumpf_zone_init;
	init_zones[0] = "center_building_upstairs";
	level thread zm_zonemgr::manage_zones(init_zones);
	level.zombie_ai_limit = 24;
	level.validate_poi_attractors = 1;
	level thread water_burst_overwrite();
	/#
		level.custom_devgui = &function_920754d;
	#/
	init_sounds();
	level thread setupmusic();
	level notify(#"setup_rope");
	level.has_pack_a_punch = 0;
	setculldist(2400);
	/#
		function_27cb39f1();
	#/
	setdvar("sv_maxPhysExplosionSpheres", 15);
	setdvar("r_lightGridEnableTweaks", 1);
	setdvar("r_lightGridIntensity", 1.25);
	setdvar("r_lightGridContrast", 0.1);
	level thread function_c283498();
	function_39a5be7e();
	level thread function_5b94e922();
	setdvar("player_shallowWaterWadeScale", 0.55);
	setdvar("player_waistWaterWadeScale", 0.55);
	scene::add_scene_func("p7_fxanim_zm_sumpf_zipline_down_bundle", &function_b87f949f, "init");
	level scene::init("p7_fxanim_zm_sumpf_zipline_down_bundle");
	level.var_9aaae7ae = &function_869d6f66;
	level.var_9cef605e = &function_3e7eb37b;
	level thread zm_sumpf_ffotd::main_end();
}

/*
	Name: function_12859198
	Namespace: zm_sumpf
	Checksum: 0x38AF74B4
	Offset: 0x1860
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function function_12859198()
{
	level._effect["doubletap2_light"] = "dlc5/zmhd/fx_perk_doubletap";
	level._effect["jugger_light"] = "dlc5/zmhd/fx_perk_juggernaut";
	level._effect["revive_light"] = "dlc5/zmhd/fx_perk_quick_revive";
	level._effect["sleight_light"] = "dlc5/zmhd/fx_perk_sleight_of_hand";
	level._effect["additionalprimaryweapon_light"] = "dlc5/zmhd/fx_perk_mule_kick";
}

/*
	Name: function_b87f949f
	Namespace: zm_sumpf
	Checksum: 0x4563A656
	Offset: 0x18F8
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function function_b87f949f(a_ents)
{
	foreach(ent in a_ents)
	{
		ent setignorepauseworld(1);
	}
}

/*
	Name: function_5b94e922
	Namespace: zm_sumpf
	Checksum: 0xF876005E
	Offset: 0x1998
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function function_5b94e922()
{
	level endon(#"end_game");
	var_6c4e714 = struct::get_array("hanging_dead_guy_force", "targetname");
	n_index = 0;
	while(true)
	{
		while(!(isdefined(zm_zonemgr::any_player_in_zone("center_building_upstairs")) && zm_zonemgr::any_player_in_zone("center_building_upstairs")))
		{
			wait(0.1);
		}
		physicsexplosionsphere(var_6c4e714[n_index].origin + vectorscale((0, 1, 0), 5), 20, 10, 0.09);
		n_index++;
		if(n_index >= var_6c4e714.size)
		{
			n_index = 0;
		}
		wait(1);
	}
}

/*
	Name: function_869d6f66
	Namespace: zm_sumpf
	Checksum: 0xE2514886
	Offset: 0x1AB0
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
	if(isdefined(self.on_zipline) && self.on_zipline)
	{
		return false;
	}
	return true;
}

/*
	Name: function_3e7eb37b
	Namespace: zm_sumpf
	Checksum: 0xB3091B18
	Offset: 0x1B00
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function function_3e7eb37b()
{
	if(isdefined(self.on_zipline) && self.on_zipline)
	{
		return false;
	}
	return true;
}

/*
	Name: function_39a5be7e
	Namespace: zm_sumpf
	Checksum: 0x91CFAC1E
	Offset: 0x1B30
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_39a5be7e()
{
	level flag::wait_till("start_zombie_round_logic");
	zm_power::turn_power_on_and_open_doors();
}

/*
	Name: function_c283498
	Namespace: zm_sumpf
	Checksum: 0x5D6F3231
	Offset: 0x1B70
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_c283498()
{
	while(true)
	{
		level flag::wait_till("dog_round");
		level clientfield::set("SUMPF_VISIONSET_DOGS", 1);
		level waittill(#"dog_round_ending");
		level clientfield::set("SUMPF_VISIONSET_DOGS", 0);
	}
}

/*
	Name: givecustomcharacters
	Namespace: zm_sumpf
	Checksum: 0x5D443CFC
	Offset: 0x1BF0
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
	Name: assign_lowest_unused_character_index
	Namespace: zm_sumpf
	Checksum: 0x8AA33263
	Offset: 0x1EF0
	Size: 0x154
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
	if(level.players.size == 1)
	{
		charindexarray = array::randomize(charindexarray);
		return charindexarray[0];
	}
	foreach(player in level.players)
	{
		if(isdefined(player.characterindex))
		{
			arrayremovevalue(charindexarray, player.characterindex, 0);
		}
	}
	if(charindexarray.size > 0)
	{
		return charindexarray[0];
	}
	return 0;
}

/*
	Name: initcharacterstartindex
	Namespace: zm_sumpf
	Checksum: 0x2D2005F8
	Offset: 0x2050
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
	Namespace: zm_sumpf
	Checksum: 0xDEBA4C3
	Offset: 0x2080
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
	Name: sumpf_zone_init
	Namespace: zm_sumpf
	Checksum: 0x2B8358A
	Offset: 0x20C8
	Size: 0x224
	Parameters: 0
	Flags: Linked
*/
function sumpf_zone_init()
{
	level flag::init("always_on");
	level flag::set("always_on");
	zm_zonemgr::add_adjacent_zone("center_building_upstairs", "center_building_upstairs_buy", "unlock_hospital_upstairs");
	zm_zonemgr::add_adjacent_zone("center_building_upstairs", "center_building_combined", "unlock_hospital_downstairs");
	zm_zonemgr::add_adjacent_zone("center_building_upstairs_buy", "center_building_combined", "unlock_hospital_upstairs");
	zm_zonemgr::add_adjacent_zone("center_building_upstairs_buy", "center_building_combined", "unlock_hospital_downstairs");
	zm_zonemgr::add_adjacent_zone("center_building_combined", "northeast_outside", "ne_magic_box");
	zm_zonemgr::add_adjacent_zone("center_building_combined", "northwest_outside", "nw_magic_box");
	zm_zonemgr::add_adjacent_zone("center_building_combined", "southeast_outside", "se_magic_box");
	zm_zonemgr::add_adjacent_zone("center_building_combined", "southwest_outside", "sw_magic_box");
	zm_zonemgr::add_adjacent_zone("northeast_outside", "northeast_building", "northeast_building_unlocked");
	zm_zonemgr::add_adjacent_zone("northwest_outside", "northwest_building", "northwest_building_unlocked");
	zm_zonemgr::add_adjacent_zone("southeast_outside", "southeast_building", "southeast_building_unlocked");
	zm_zonemgr::add_adjacent_zone("southwest_outside", "southwest_building", "southwest_building_unlocked");
}

/*
	Name: init_sounds
	Namespace: zm_sumpf
	Checksum: 0xFBF69BC8
	Offset: 0x22F8
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function init_sounds()
{
	zm_utility::add_sound("zmb_wooden_door", "zmb_door_wood_open");
	zm_utility::add_sound("zmb_heavy_door_open", "zmb_heavy_door_open");
	level thread custom_add_vox();
	level.vox_response_override = 1;
	/#
		iprintlnbold("");
	#/
	level thread function_c06f4240();
	level thread function_5a36831b();
	level thread function_34a348fc();
	level thread function_8aa785e();
	level thread radio_eggs();
	level thread meteor_trigger();
	level thread book_useage();
	level thread super_egg();
	level thread function_d166ac07();
}

/*
	Name: setupmusic
	Namespace: zm_sumpf
	Checksum: 0xF14133FB
	Offset: 0x2460
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function setupmusic()
{
	zm_audio::musicstate_create("round_start", 3, "sumpf_roundstart_1", "sumpf_roundstart_2", "sumpf_roundstart_3", "sumpf_roundstart_4");
	zm_audio::musicstate_create("round_start_short", 3, "sumpf_roundstart_1", "sumpf_roundstart_2", "sumpf_roundstart_3", "sumpf_roundstart_4");
	zm_audio::musicstate_create("round_start_first", 3, "sumpf_roundstart_1", "sumpf_roundstart_2", "sumpf_roundstart_3", "sumpf_roundstart_4");
	zm_audio::musicstate_create("round_end", 3, "sumpf_roundend_1", "sumpf_roundend_2", "sumpf_roundend_3", "sumpf_roundend_4");
	zm_audio::musicstate_create("dog_start", 3, "dog_start_1");
	zm_audio::musicstate_create("dog_end", 3, "dog_end_1");
	zm_audio::musicstate_create("the_one", 4, "the_one");
	zm_audio::musicstate_create("game_over", 5, "game_over_zhd_sumpf");
	zm_audio::musicstate_create("none", 4, "none");
	zm_audio::musicstate_create("sam", 4, "sam");
}

/*
	Name: offhand_weapon_overrride
	Namespace: zm_sumpf
	Checksum: 0x9DE34E95
	Offset: 0x2660
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function offhand_weapon_overrride()
{
	zm_utility::register_lethal_grenade_for_level("frag_grenade");
	level.zombie_lethal_grenade_player_init = getweapon("frag_grenade");
	zm_utility::register_tactical_grenade_for_level("cymbal_monkey");
	zm_utility::register_tactical_grenade_for_level("cymbal_monkey_upgraded");
	zm_utility::register_melee_weapon_for_level(level.weaponbasemelee.name);
	level.zombie_melee_weapon_player_init = level.weaponbasemelee;
	level.zombie_equipment_player_init = undefined;
}

/*
	Name: custom_add_weapons
	Namespace: zm_sumpf
	Checksum: 0xF164470D
	Offset: 0x2710
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_sumpf_weapons.csv", 1);
}

/*
	Name: custom_add_vox
	Namespace: zm_sumpf
	Checksum: 0xC7A0E312
	Offset: 0x2740
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function custom_add_vox()
{
	zm_audio::loadplayervoicecategories("gamedata/audio/zm/zm_prototype_vox.csv");
}

/*
	Name: init_zombie_sumpf
	Namespace: zm_sumpf
	Checksum: 0xDDA96718
	Offset: 0x2768
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function init_zombie_sumpf()
{
	thread zm_sumpf_magic_box::magic_box_init();
	ziphintdeactivated = getent("zipline_deactivated_hint_trigger", "targetname");
	ziphintdeactivated sethintstring(&"ZOMBIE_ZIPLINE_DEACTIVATED");
	ziphintdeactivated setcursorhint("HINT_NOICON");
}

/*
	Name: turnlightgreen
	Namespace: zm_sumpf
	Checksum: 0xE1D77230
	Offset: 0x27F0
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function turnlightgreen(name)
{
	str_light_red = name + "_red";
	str_light_green = name + "_green";
	exploder::stop_exploder(str_light_red);
	exploder::exploder(str_light_green);
}

/*
	Name: turnlightred
	Namespace: zm_sumpf
	Checksum: 0xF2F6A652
	Offset: 0x2870
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function turnlightred(name)
{
	str_light_red = name + "_red";
	str_light_green = name + "_green";
	exploder::stop_exploder(str_light_green);
	exploder::exploder(str_light_red);
}

/*
	Name: book_useage
	Namespace: zm_sumpf
	Checksum: 0xC0A14D84
	Offset: 0x28F0
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function book_useage()
{
	book_counter = 0;
	book_trig = getent("book_trig", "targetname");
	book_trig setcursorhint("HINT_NOICON");
	book_trig usetriggerrequirelookat();
	/#
		level thread function_620401c0((11308, 3635, -582), "", book_trig, "");
	#/
	if(isdefined(book_trig))
	{
		maniac_l = getent("maniac_l", "targetname");
		maniac_r = getent("maniac_r", "targetname");
		book_trig waittill(#"trigger", player);
		if(isdefined(maniac_l))
		{
			maniac_l playsound("evt_maniac_l");
		}
		if(isdefined(maniac_r))
		{
			maniac_r playsound("evt_maniac_r");
		}
	}
}

/*
	Name: function_c06f4240
	Namespace: zm_sumpf
	Checksum: 0xC4F8591F
	Offset: 0x2A78
	Size: 0x2DC
	Parameters: 0
	Flags: Linked
*/
function function_c06f4240()
{
	s_phone_egg = struct::get("s_phone_egg", "targetname");
	if(!isdefined(s_phone_egg))
	{
		return;
	}
	s_phone_egg zm_unitrigger::create_unitrigger(undefined, 256);
	var_e5549a81 = spawn("script_origin", s_phone_egg.origin);
	var_fd0167be = 0;
	while(var_fd0167be < 4)
	{
		s_phone_egg waittill(#"trigger_activated");
		if(isdefined(level.musicsystem.currentplaytype) && level.musicsystem.currentplaytype >= 4 || (isdefined(level.musicsystemoverride) && level.musicsystemoverride))
		{
			continue;
		}
		else
		{
			switch(var_fd0167be)
			{
				case 0:
				{
					var_e5549a81 playloopsound("evt_phone_dialtone");
					wait(1);
					break;
				}
				case 1:
				{
					var_e5549a81 stoploopsound(0.5);
					var_e5549a81 playsound("evt_dial_9");
					wait(0.25);
					break;
				}
				case 2:
				{
					var_e5549a81 playsound("evt_dial_1");
					wait(0.25);
					break;
				}
				case 3:
				{
					var_e5549a81 playsound("evt_dial_1");
					wait(0.5);
					var_e5549a81 playsound("evt_riiing");
					wait(2.5);
					var_e5549a81 playsound("evt_riiing");
					wait(2);
					var_e5549a81 playsound("evt_phone_answer");
					wait(3.7);
					break;
				}
			}
			var_fd0167be++;
		}
	}
	playsoundatposition("zmb_cha_ching", s_phone_egg.origin);
	zm_unitrigger::unregister_unitrigger(s_phone_egg.s_unitrigger);
	level thread zm_audio::sndmusicsystem_playstate("the_one");
}

/*
	Name: play_radio_sounds
	Namespace: zm_sumpf
	Checksum: 0xF83522D0
	Offset: 0x2D60
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function play_radio_sounds()
{
	/#
		iprintlnbold("");
	#/
	pa_system = getent("speaker_in_attic", "targetname");
	wait(0.05);
	pa_system playsoundwithnotify("evt_secret_message", "message_complete");
	pa_system waittill(#"message_complete");
}

/*
	Name: radio_eggs
	Namespace: zm_sumpf
	Checksum: 0x5309A920
	Offset: 0x2DF8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function radio_eggs()
{
	if(!isdefined(level.radio_counter))
	{
		level.radio_counter = 0;
	}
	while(level.radio_counter < 3)
	{
		wait(1);
	}
	level thread play_radio_sounds();
	/#
		iprintlnbold("");
	#/
}

/*
	Name: function_34a348fc
	Namespace: zm_sumpf
	Checksum: 0x33F5CE11
	Offset: 0x2E70
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function function_34a348fc()
{
	level.var_34a348fc = getentarray("super_egg_radio", "targetname");
	if(isdefined(level.var_34a348fc))
	{
		for(i = 0; i < level.var_34a348fc.size; i++)
		{
			level.var_34a348fc[i] thread function_53e56ac8();
		}
	}
}

/*
	Name: function_53e56ac8
	Namespace: zm_sumpf
	Checksum: 0x696F0A17
	Offset: 0x2F00
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_53e56ac8()
{
	if(!isdefined(level.superegg_counter))
	{
		level.superegg_counter = 0;
	}
	self zm_unitrigger::create_unitrigger(undefined, 128);
	/#
	#/
	self waittill(#"trigger_activated");
	self zm_unitrigger::unregister_unitrigger(self.unitrigger);
	level.superegg_counter = level.superegg_counter + 1;
	self playloopsound(self.script_sound);
}

/*
	Name: play_super_egg_radio_pa_sounds
	Namespace: zm_sumpf
	Checksum: 0xB7978A4F
	Offset: 0x2FA0
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function play_super_egg_radio_pa_sounds()
{
	pa_system = getent("speaker_in_attic", "targetname");
	wait(0.05);
	pa_system playsoundwithnotify("vox_superegg_secret_message", "message_complete");
	pa_system waittill(#"message_complete");
}

/*
	Name: super_egg
	Namespace: zm_sumpf
	Checksum: 0x79A48340
	Offset: 0x3018
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function super_egg()
{
	if(!isdefined(level.superegg_counter))
	{
		level.superegg_counter = 0;
	}
	while(level.superegg_counter < 3)
	{
		wait(2);
	}
	level thread play_super_egg_radio_pa_sounds();
}

/*
	Name: function_8aa785e
	Namespace: zm_sumpf
	Checksum: 0xAD290428
	Offset: 0x3070
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function function_8aa785e()
{
	level.var_34a348fc = getentarray("sur_radio", "targetname");
	if(isdefined(level.var_34a348fc))
	{
		for(i = 0; i < level.var_34a348fc.size; i++)
		{
			level.var_34a348fc[i] thread function_4deca569();
		}
	}
}

/*
	Name: function_4deca569
	Namespace: zm_sumpf
	Checksum: 0x80E30B38
	Offset: 0x3100
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_4deca569()
{
	if(!isdefined(level.superegg_counter))
	{
		level.superegg_counter = 0;
	}
	self thread zm_sidequests::fake_use("sur_radio_activated");
	/#
	#/
	self waittill(#"sur_radio_activated");
	self playsound(self.script_sound);
}

/*
	Name: function_5a36831b
	Namespace: zm_sumpf
	Checksum: 0x5747F54E
	Offset: 0x3178
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function function_5a36831b()
{
	level.var_5a36831b = getentarray("radio_hut", "targetname");
	if(isdefined(level.var_5a36831b))
	{
		for(i = 0; i < level.var_5a36831b.size; i++)
		{
			level.var_5a36831b[i] thread function_2fa9f915();
		}
	}
}

/*
	Name: function_2fa9f915
	Namespace: zm_sumpf
	Checksum: 0xF4B403B9
	Offset: 0x3208
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_2fa9f915()
{
	if(!isdefined(level.radio_counter))
	{
		level.radio_counter = 0;
	}
	self zm_unitrigger::create_unitrigger(undefined, 128);
	/#
	#/
	self waittill(#"trigger_activated");
	self zm_unitrigger::unregister_unitrigger(self.unitrigger);
	level.radio_counter = level.radio_counter + 1;
	self playloopsound(self.script_sound);
}

/*
	Name: meteor_trigger
	Namespace: zm_sumpf
	Checksum: 0x3C850CBC
	Offset: 0x32A8
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function meteor_trigger()
{
	player = getplayers();
	level endon(#"meteor_triggered");
	dmgtrig = getent("meteor", "targetname");
	/#
		level thread function_620401c0((11260.5, -2091, -634), "", dmgtrig, "", 3);
	#/
	while(true)
	{
		dmgtrig waittill(#"trigger", player);
		if(distancesquared(player.origin, dmgtrig.origin) < 100000000)
		{
			player thread zm_audio::create_and_play_dialog("level", "meteor");
			level notify(#"meteor_triggered");
		}
		else
		{
			wait(0.1);
		}
	}
}

/*
	Name: setup_custom_vox
	Namespace: zm_sumpf
	Checksum: 0x99EC1590
	Offset: 0x33E8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function setup_custom_vox()
{
}

/*
	Name: sumpf_player_spawn_placement
	Namespace: zm_sumpf
	Checksum: 0x3C590FF5
	Offset: 0x33F8
	Size: 0x116
	Parameters: 0
	Flags: None
*/
function sumpf_player_spawn_placement()
{
	structs = struct::get_array("initial_spawn_points", "targetname");
	level flag::wait_till("start_zombie_round_logic");
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] setorigin(structs[i].origin);
		players[i] setplayerangles(structs[i].angles);
		players[i].spectator_respawn = structs[i];
	}
}

/*
	Name: water_burst_overwrite
	Namespace: zm_sumpf
	Checksum: 0x7F38733D
	Offset: 0x3518
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function water_burst_overwrite()
{
	level waittill(#"between_round_over");
	level._effect["rise_burst_water"] = "maps/zombie/fx_zombie_body_wtr_burst_smpf";
	level._effect["rise_billow_water"] = "maps/zombie/fx_zombie_body_wtr_billow_smpf";
}

/*
	Name: function_920754d
	Namespace: zm_sumpf
	Checksum: 0x11C803E8
	Offset: 0x3568
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function function_920754d(cmd)
{
	/#
		cmd_strings = strtok(cmd, "");
		switch(cmd_strings[0])
		{
			case "":
			{
				function_22476936();
				break;
			}
			case "":
			{
				function_c54ccb33();
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
	Name: function_22476936
	Namespace: zm_sumpf
	Checksum: 0x4C98A1D5
	Offset: 0x3610
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_22476936()
{
	/#
		if(level.round_number <= 1)
		{
			level flag::wait_till("");
			iprintln("");
			wait(12);
		}
		var_307510ba = level.round_number + 1;
		level.next_dog_round = var_307510ba;
		iprintln("" + var_307510ba);
		zm_devgui::zombie_devgui_goto_round(var_307510ba);
		iprintln("" + var_307510ba);
	#/
}

/*
	Name: function_c54ccb33
	Namespace: zm_sumpf
	Checksum: 0x55AC1BA2
	Offset: 0x36F0
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_c54ccb33()
{
	/#
		var_4d028102 = getent("", "");
		if(isdefined(var_4d028102))
		{
			zm_devgui::zombie_devgui_open_sesame();
			var_4d028102 notify(#"trigger", getplayers()[0]);
		}
	#/
}

/*
	Name: function_27cb39f1
	Namespace: zm_sumpf
	Checksum: 0xB39A1A5
	Offset: 0x3770
	Size: 0xBE
	Parameters: 0
	Flags: Linked
*/
function function_27cb39f1()
{
	/#
		if(!getdvarint(""))
		{
			return;
		}
		all_nodes = getallnodes();
		for(i = 0; i < all_nodes.size; i++)
		{
			node = all_nodes[i];
			if(node.type == "")
			{
				node thread debug_display();
			}
		}
	#/
}

/*
	Name: debug_display
	Namespace: zm_sumpf
	Checksum: 0x860E7D40
	Offset: 0x3838
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function debug_display()
{
	/#
		while(true)
		{
			print3d(self.origin, self.animscript, (1, 0, 0), 1, 0.2, 1);
			wait(0.05);
		}
	#/
}

/*
	Name: function_620401c0
	Namespace: zm_sumpf
	Checksum: 0x5FB76797
	Offset: 0x3890
	Size: 0xD8
	Parameters: 5
	Flags: Linked
*/
function function_620401c0(v_org, str_msg, var_5d64a595, str_ender, n_scale)
{
	/#
		if(!isdefined(n_scale))
		{
			n_scale = 1;
		}
		var_5d64a595 endon(str_ender);
		level thread function_9a889da5(str_msg, var_5d64a595, str_ender);
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
	Namespace: zm_sumpf
	Checksum: 0x4710426F
	Offset: 0x3970
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function function_9a889da5(str_msg, var_5d64a595, str_ender)
{
	/#
		var_5d64a595 waittill(str_ender);
		iprintlnbold(str_msg);
	#/
}

/*
	Name: init_level_specific_audio
	Namespace: zm_sumpf
	Checksum: 0x99EC1590
	Offset: 0x39C0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init_level_specific_audio()
{
}

/*
	Name: function_d166ac07
	Namespace: zm_sumpf
	Checksum: 0xDA8C3352
	Offset: 0x39D0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_d166ac07()
{
	level.var_8ec97b54 = 0;
	var_5e490b83 = getentarray("sndzhd_plates", "targetname");
	array::thread_all(var_5e490b83, &function_4bb6626e);
}

/*
	Name: function_4bb6626e
	Namespace: zm_sumpf
	Checksum: 0x40D12982
	Offset: 0x3A40
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_4bb6626e()
{
	while(true)
	{
		self waittill(#"damage", damage, attacker, dir, loc, str_type, model, tag, part, weapon, flags);
		if(!isplayer(attacker))
		{
			continue;
		}
		if(weapon != level.start_weapon)
		{
			continue;
		}
		if(str_type != "MOD_PISTOL_BULLET")
		{
			continue;
		}
		level.var_8ec97b54++;
		playsoundatposition("zmb_zhd_plate_hit", self.origin);
		break;
	}
	if(level.var_8ec97b54 >= 4)
	{
		level flag::set("snd_zhdegg_activate");
	}
}

/*
	Name: include_perks_in_random_rotation
	Namespace: zm_sumpf
	Checksum: 0xED9A0A56
	Offset: 0x3B80
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function include_perks_in_random_rotation()
{
	zm_perk_random::include_perk_in_random_rotation("specialty_staminup");
	zm_perk_random::include_perk_in_random_rotation("specialty_deadshot");
	zm_perk_random::include_perk_in_random_rotation("specialty_widowswine");
	level.custom_random_perk_weights = &function_c027d01d;
}

/*
	Name: function_c027d01d
	Namespace: zm_sumpf
	Checksum: 0x5393DA01
	Offset: 0x3BF0
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

