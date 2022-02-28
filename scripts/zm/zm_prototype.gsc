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
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_bgb;
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
#using scripts\zm\_zm_radio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_annihilator;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_bowie;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_thundergun;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\zm_prototype_achievements;
#using scripts\zm\zm_prototype_amb;
#using scripts\zm\zm_prototype_barrels;
#using scripts\zm\zm_prototype_ffotd;
#using scripts\zm\zm_prototype_fx;
#using scripts\zm\zm_prototype_zombie;
#using scripts\zm\zm_remaster_zombie;
#using scripts\zm\zm_zmhd_cleanup_mgr;

#namespace zm_prototype;

/*
	Name: function_d9af860b
	Namespace: zm_prototype
	Checksum: 0xC504B49D
	Offset: 0xCB0
	Size: 0x4C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_d9af860b()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
	clientfield::register("clientuimodel", "player_lives", 1, 2, "int");
}

/*
	Name: main
	Namespace: zm_prototype
	Checksum: 0xFECBA81B
	Offset: 0xD08
	Size: 0x394
	Parameters: 0
	Flags: Linked
*/
function main()
{
	zm_prototype_ffotd::main_start();
	level.default_game_mode = "zclassic";
	level.default_start_location = "default";
	zm_prototype_fx::main();
	zm::init_fx();
	level.sndzhdaudio = 1;
	level._uses_sticky_grenades = 1;
	level.register_offhand_weapons_for_level_defaults_override = &offhand_weapon_overrride;
	level._zmbvoxlevelspecific = &init_level_specific_audio;
	zm_prototype_amb::main();
	level._round_start_func = &zm::round_start;
	level.precachecustomcharacters = &precachecustomcharacters;
	level.givecustomcharacters = &givecustomcharacters;
	initcharacterstartindex();
	level._zombie_custom_add_weapons = &custom_add_weapons;
	include_perks_in_random_rotation();
	spawner::add_archetype_spawn_function("zombie", &function_c86e49f5);
	load::main();
	level.default_laststandpistol = getweapon("pistol_m1911");
	level.default_solo_laststandpistol = getweapon("pistol_m1911_upgraded");
	level.laststandpistol = level.default_laststandpistol;
	level.start_weapon = level.default_laststandpistol;
	level thread zm::last_stand_pistol_rank_init();
	level thread init_weapon_cabinet();
	fx_overrides();
	_zm_weap_cymbal_monkey::init();
	_zm_weap_bowie::init();
	setdvar("magic_chest_movable", "0");
	level thread function_44c28e00();
	level thread function_54bf648f();
	level.zones = [];
	level.zone_manager_init_func = &prototype_zone_init;
	init_zones[0] = "start_zone";
	level thread zm_zonemgr::manage_zones(init_zones);
	level.zombie_ai_limit = 24;
	level thread init_sounds();
	level thread setupmusic();
	level thread function_9b3e5ee2();
	level flag::wait_till("start_zombie_round_logic");
	level notify(#"hash_d51af150");
	zm_power::turn_power_on_and_open_doors();
	level.var_9aaae7ae = &function_869d6f66;
	level thread zm_perks::spare_change();
	zm_prototype_ffotd::main_end();
}

/*
	Name: fx_overrides
	Namespace: zm_prototype
	Checksum: 0x81526767
	Offset: 0x10A8
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function fx_overrides()
{
	level._effect["perk_machine_light_yellow"] = "dlc5/zmhd/fx_wonder_fizz_light_yellow";
	level._effect["perk_machine_light_red"] = "dlc5/zmhd/fx_wonder_fizz_light_red";
	level._effect["perk_machine_light_green"] = "dlc5/zmhd/fx_wonder_fizz_light_green";
}

/*
	Name: function_869d6f66
	Namespace: zm_prototype
	Checksum: 0xD48D5AD
	Offset: 0x1108
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function function_869d6f66()
{
	if(!isdefined(self zm_bgb_anywhere_but_here::function_728dfe3()))
	{
		return false;
	}
	return true;
}

/*
	Name: function_44c28e00
	Namespace: zm_prototype
	Checksum: 0x19D32DC7
	Offset: 0x1138
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function function_44c28e00()
{
	var_c7d6c8d8 = 0;
	while(!var_c7d6c8d8)
	{
		var_c7d6c8d8 = 1;
		if(isdefined(level.chests))
		{
			for(i = 0; i < level.chests.size; i++)
			{
				var_1f4c3936 = level.chests[i];
				if(isdefined(var_1f4c3936.zbarrier))
				{
					var_5a1d4162 = var_1f4c3936.zbarrier;
					var_5a1d4162 clientfield::set("magicbox_closed_glow", 0);
					continue;
				}
				var_c7d6c8d8 = 0;
				break;
			}
		}
		else
		{
			var_c7d6c8d8 = 0;
		}
		wait(2);
	}
}

/*
	Name: precachecustomcharacters
	Namespace: zm_prototype
	Checksum: 0x99EC1590
	Offset: 0x1230
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precachecustomcharacters()
{
}

/*
	Name: initcharacterstartindex
	Namespace: zm_prototype
	Checksum: 0x92B11844
	Offset: 0x1240
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
	Namespace: zm_prototype
	Checksum: 0x74835FA3
	Offset: 0x1270
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
	Namespace: zm_prototype
	Checksum: 0x42EBBFEF
	Offset: 0x12B8
	Size: 0x2DC
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
	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
}

/*
	Name: assign_lowest_unused_character_index
	Namespace: zm_prototype
	Checksum: 0x18453AE0
	Offset: 0x15A0
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
	Name: offhand_weapon_overrride
	Namespace: zm_prototype
	Checksum: 0xFEC241E7
	Offset: 0x1700
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
	Name: init_sounds
	Namespace: zm_prototype
	Checksum: 0x11C87A02
	Offset: 0x17B0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function init_sounds()
{
	zm_utility::add_sound("zmb_heavy_door_open", "zmb_heavy_door_open");
}

/*
	Name: setupmusic
	Namespace: zm_prototype
	Checksum: 0x4680AD57
	Offset: 0x17E0
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function setupmusic()
{
	zm_audio::musicstate_create("round_start", 3, "round_start_prototype_1");
	zm_audio::musicstate_create("round_start_short", 3, "round_start_prototype_1");
	zm_audio::musicstate_create("round_start_first", 3, "round_start_prototype_1");
	zm_audio::musicstate_create("round_end", 3, "round_end_prototype_1");
	zm_audio::musicstate_create("undone", 4, "undone");
	zm_audio::musicstate_create("game_over", 5, "game_over_zhd_prototype");
	zm_audio::musicstate_create("none", 4, "none");
	zm_audio::musicstate_create("sam", 4, "sam");
}

/*
	Name: prototype_zone_init
	Namespace: zm_prototype
	Checksum: 0x262AB8F2
	Offset: 0x1930
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function prototype_zone_init()
{
	level flag::init("always_on");
	level flag::set("always_on");
	zm_zonemgr::add_adjacent_zone("start_zone", "box_zone", "start_2_box");
	zm_zonemgr::add_adjacent_zone("start_zone", "upstairs_zone", "start_2_upstairs");
	zm_zonemgr::add_adjacent_zone("box_zone", "upstairs_zone", "box_2_upstairs");
}

/*
	Name: function_54bf648f
	Namespace: zm_prototype
	Checksum: 0x7CDB6F5
	Offset: 0x19F8
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
	Namespace: zm_prototype
	Checksum: 0x87F61916
	Offset: 0x1A38
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
	Name: custom_add_weapons
	Namespace: zm_prototype
	Checksum: 0x30AD6755
	Offset: 0x1C48
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_prototype_weapons.csv", 1);
}

/*
	Name: init_level_specific_audio
	Namespace: zm_prototype
	Checksum: 0x6217AA7D
	Offset: 0x1C78
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function init_level_specific_audio()
{
	level.vox zm_audio::zmbvoxadd("player", "general", "intro", "level_start", undefined);
	level.vox zm_audio::zmbvoxadd("player", "general", "door_deny", "nomoney", undefined);
	level.vox zm_audio::zmbvoxadd("player", "general", "perk_deny", "nomoney", undefined);
	level.vox zm_audio::zmbvoxadd("player", "general", "no_money_weapon", "nomoney", undefined);
	level.vox zm_audio::zmbvoxadd("player", "eggs", "music_activate", "secret", undefined);
}

/*
	Name: init_weapon_cabinet
	Namespace: zm_prototype
	Checksum: 0xE5284620
	Offset: 0x1DA0
	Size: 0x26A
	Parameters: 0
	Flags: Linked
*/
function init_weapon_cabinet()
{
	level flag::wait_till("start_zombie_round_logic");
	var_68c121fd = undefined;
	for(i = 0; i < level._spawned_wallbuys.size; i++)
	{
		str_weapon_name = level._spawned_wallbuys[i].weapon.name;
		if(str_weapon_name == "sniper_fastbolt")
		{
			var_68c121fd = level._spawned_wallbuys[i];
			break;
		}
	}
	if(isdefined(var_68c121fd))
	{
		var_68c121fd.trigger_stub.script_height = 56;
		var_68c121fd.trigger_stub.script_width = 38;
		var_4e1a2d78 = 0;
		while(!var_4e1a2d78)
		{
			level waittill(#"weapon_bought");
			if(isdefined(var_68c121fd.trigger_stub.first_time_triggered))
			{
				if(isdefined(var_68c121fd.trigger_stub.first_time_triggered) && var_68c121fd.trigger_stub.first_time_triggered)
				{
					var_4e1a2d78 = 1;
				}
			}
		}
	}
	var_e453319 = struct::get(var_68c121fd.target, "targetname");
	var_e41aa7b8 = getentarray(var_e453319.target, "targetname");
	foreach(mdl_door in var_e41aa7b8)
	{
		mdl_door thread weapon_cabinet_door_open(mdl_door.script_noteworthy);
	}
}

/*
	Name: weapon_cabinet_door_open
	Namespace: zm_prototype
	Checksum: 0xBD8ED772
	Offset: 0x2018
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function weapon_cabinet_door_open(var_4ed1d865)
{
	if(var_4ed1d865 == "left")
	{
		self rotateyaw(120, 0.3, 0.2, 0.1);
	}
	else if(var_4ed1d865 == "right")
	{
		self rotateyaw(-120, 0.3, 0.2, 0.1);
	}
}

/*
	Name: include_perks_in_random_rotation
	Namespace: zm_prototype
	Checksum: 0x9895CB9
	Offset: 0x20B8
	Size: 0xC4
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
	zm_perk_random::include_perk_in_random_rotation("specialty_deadshot");
	zm_perk_random::include_perk_in_random_rotation("specialty_widowswine");
	level.custom_random_perk_weights = &function_c027d01d;
}

/*
	Name: function_c027d01d
	Namespace: zm_prototype
	Checksum: 0xADA43BBF
	Offset: 0x2188
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

/*
	Name: function_9b3e5ee2
	Namespace: zm_prototype
	Checksum: 0xEF810BB6
	Offset: 0x2238
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_9b3e5ee2()
{
	var_9f0c2e1d = 0;
	var_822cff7b = struct::get_array("zhdaudio_button", "targetname");
	array::thread_all(var_822cff7b, &function_ab3e14a3);
	while(true)
	{
		level waittill(#"hash_672c1b1a");
		var_9f0c2e1d++;
		if(var_9f0c2e1d == var_822cff7b.size)
		{
			break;
		}
	}
	level flag::set("snd_zhdegg_activate");
}

/*
	Name: function_ab3e14a3
	Namespace: zm_prototype
	Checksum: 0xF9DD62D5
	Offset: 0x22F8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_ab3e14a3()
{
	self zm_unitrigger::create_unitrigger();
	self waittill(#"trigger_activated");
	playsoundatposition("zmb_sam_egg_button", self.origin);
	level notify(#"hash_672c1b1a");
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
}

/*
	Name: function_c86e49f5
	Namespace: zm_prototype
	Checksum: 0x82C15099
	Offset: 0x2378
	Size: 0x1C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_c86e49f5()
{
	self.cant_move_cb = &function_e6b1e0be;
}

/*
	Name: function_e6b1e0be
	Namespace: zm_prototype
	Checksum: 0x4BB86ADA
	Offset: 0x23A0
	Size: 0x2C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_e6b1e0be()
{
	self pushactors(0);
	self.enablepushtime = gettime() + 1000;
}

