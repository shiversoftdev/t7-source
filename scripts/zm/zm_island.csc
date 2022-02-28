// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_spiders;
#using scripts\zm\_zm_ai_thrasher;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_powerup_bonus_points_player;
#using scripts\zm\_zm_powerup_bonus_points_team;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_empty_perk;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_island_seed;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_controllable_spider;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_island_shield;
#using scripts\zm\_zm_weap_keeper_skull;
#using scripts\zm\_zm_weap_mirg2000;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craft_shield;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_island_amb;
#using scripts\zm\zm_island_challenges;
#using scripts\zm\zm_island_craftables;
#using scripts\zm\zm_island_dogfights;
#using scripts\zm\zm_island_ffotd;
#using scripts\zm\zm_island_fx;
#using scripts\zm\zm_island_inventory;
#using scripts\zm\zm_island_main_ee_quest;
#using scripts\zm\zm_island_pap_quest;
#using scripts\zm\zm_island_perks;
#using scripts\zm\zm_island_planting;
#using scripts\zm\zm_island_portals;
#using scripts\zm\zm_island_power;
#using scripts\zm\zm_island_side_ee_distant_monster;
#using scripts\zm\zm_island_side_ee_doppleganger;
#using scripts\zm\zm_island_side_ee_golden_bucket;
#using scripts\zm\zm_island_side_ee_good_thrasher;
#using scripts\zm\zm_island_side_ee_secret_maxammo;
#using scripts\zm\zm_island_side_ee_spore_hallucinations;
#using scripts\zm\zm_island_skullweapon_quest;
#using scripts\zm\zm_island_spider_ee_quest;
#using scripts\zm\zm_island_spider_quest;
#using scripts\zm\zm_island_spores;
#using scripts\zm\zm_island_takeo_fight;
#using scripts\zm\zm_island_transport;
#using scripts\zm\zm_island_traps;
#using scripts\zm\zm_island_ww_quest;
#using scripts\zm\zm_island_zones;

#namespace zm_island;

/*
	Name: opt_in
	Namespace: zm_island
	Checksum: 0xE58084F2
	Offset: 0x1B08
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
	Namespace: zm_island
	Checksum: 0x1F89A3F9
	Offset: 0x1B30
	Size: 0x29C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	zm_island_ffotd::main_start();
	zm_island_fx::main();
	callback::on_localplayer_spawned(&on_localplayer_spawned);
	level.setupcustomcharacterexerts = &setup_personality_character_exerts;
	level._uses_sticky_grenades = 1;
	level._uses_taser_knuckles = 1;
	register_clientfields();
	include_weapons();
	level thread function_be61cf5a();
	zm_island_craftables::include_craftables();
	zm_island_craftables::init_craftables();
	zm_island_dogfights::init();
	zm_island_ww_quest::function_30d4f164();
	zm_island_planting::init();
	zm_island_power::init();
	zm_island_traps::init();
	zm_island_transport::init();
	zm_island_spores::init();
	zm_island_perks::init();
	zm_island_skullquest::init();
	zm_island_main_ee_quest::function_30d4f164();
	zm_island_zones::init();
	zm_island_pap_quest::init();
	zm_island_inventory::init();
	zm_island_spider_quest::init();
	zm_island_challenges::init();
	zm_island_side_ee_distant_monster::init();
	zm_island_side_ee_doppleganger::init();
	zm_island_side_ee_good_thrasher::init();
	zm_island_spider_ee_quest::init();
	zm_island_side_ee_golden_bucket::init();
	zm_island_side_ee_secret_maxammo::init();
	load::main();
	level thread zm_island_amb::main();
	level thread zm_island_zones::main();
	util::waitforclient(0);
	level thread function_3a429aee();
	zm_island_ffotd::main_end();
}

/*
	Name: register_clientfields
	Namespace: zm_island
	Checksum: 0xAADA0DC2
	Offset: 0x1DD8
	Size: 0x364
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	var_ddba80d7 = getminbitcountfornum(3);
	clientfield::register("clientuimodel", "zmInventory.widget_shield_parts", 9000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_crafted_shield", 9000, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "postfx_futz_mild", 9000, 1, "counter", &postfx_futz_mild, 0, 0);
	clientfield::register("toplayer", "water_motes", 9000, 1, "int", &water_motes, 0, 0);
	clientfield::register("toplayer", "play_bubbles", 9000, 1, "int", &function_58e931d1, 0, 0);
	clientfield::register("toplayer", "set_world_fog", 9000, var_ddba80d7, "int", &function_346468e3, 0, 0);
	clientfield::register("toplayer", "speed_burst", 9000, 1, "int", &player_speed_changed, 0, 1);
	clientfield::register("toplayer", "tp_water_sheeting", 9000, 1, "int", &water_sheeting_toggle, 0, 0);
	clientfield::register("toplayer", "wind_blur", 9000, 1, "int", &function_4a01cc4e, 0, 0);
	clientfield::register("scriptmover", "set_heavy_web_fade_material", 9000, 1, "int", &set_heavy_web_fade_material, 0, 0);
	clientfield::register("world", "force_stream_spiders", 9001, 1, "int", &force_stream_spiders, 0, 0);
	clientfield::register("world", "force_stream_takeo_arms", 11001, 1, "int", &force_stream_takeo_arms, 0, 0);
}

/*
	Name: include_weapons
	Namespace: zm_island
	Checksum: 0x95533335
	Offset: 0x2148
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_island_weapons.csv", 1);
	zm_weapons::autofill_wallbuys_init();
}

/*
	Name: setup_personality_character_exerts
	Namespace: zm_island
	Checksum: 0xFC5D7CDD
	Offset: 0x2188
	Size: 0x1112
	Parameters: 0
	Flags: Linked
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["playerbreathinsound"][0] = "vox_plr_0_exert_inhale_0";
	level.exert_sounds[2]["playerbreathinsound"][0] = "vox_plr_1_exert_inhale_0";
	level.exert_sounds[3]["playerbreathinsound"][0] = "vox_plr_2_exert_inhale_0";
	level.exert_sounds[4]["playerbreathinsound"][0] = "vox_plr_3_exert_inhale_0";
	level.exert_sounds[1]["playerbreathoutsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[2]["playerbreathoutsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[3]["playerbreathoutsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[4]["playerbreathoutsound"][0] = "vox_plr_3_exert_exhale_0";
	level.exert_sounds[1]["playerbreathgaspsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[2]["playerbreathgaspsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[3]["playerbreathgaspsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[4]["playerbreathgaspsound"][0] = "vox_plr_3_exert_exhale_0";
	level.exert_sounds[1]["falldamage"][0] = "vox_plr_0_exert_pain_low_0";
	level.exert_sounds[1]["falldamage"][1] = "vox_plr_0_exert_pain_low_1";
	level.exert_sounds[1]["falldamage"][2] = "vox_plr_0_exert_pain_low_2";
	level.exert_sounds[1]["falldamage"][3] = "vox_plr_0_exert_pain_low_3";
	level.exert_sounds[1]["falldamage"][4] = "vox_plr_0_exert_pain_low_4";
	level.exert_sounds[1]["falldamage"][5] = "vox_plr_0_exert_pain_low_5";
	level.exert_sounds[1]["falldamage"][6] = "vox_plr_0_exert_pain_low_6";
	level.exert_sounds[1]["falldamage"][7] = "vox_plr_0_exert_pain_low_7";
	level.exert_sounds[2]["falldamage"][0] = "vox_plr_1_exert_pain_low_0";
	level.exert_sounds[2]["falldamage"][1] = "vox_plr_1_exert_pain_low_1";
	level.exert_sounds[2]["falldamage"][2] = "vox_plr_1_exert_pain_low_2";
	level.exert_sounds[2]["falldamage"][3] = "vox_plr_1_exert_pain_low_3";
	level.exert_sounds[2]["falldamage"][4] = "vox_plr_1_exert_pain_low_4";
	level.exert_sounds[2]["falldamage"][5] = "vox_plr_1_exert_pain_low_5";
	level.exert_sounds[2]["falldamage"][6] = "vox_plr_1_exert_pain_low_6";
	level.exert_sounds[2]["falldamage"][7] = "vox_plr_1_exert_pain_low_7";
	level.exert_sounds[3]["falldamage"][0] = "vox_plr_2_exert_pain_low_0";
	level.exert_sounds[3]["falldamage"][1] = "vox_plr_2_exert_pain_low_1";
	level.exert_sounds[3]["falldamage"][2] = "vox_plr_2_exert_pain_low_2";
	level.exert_sounds[3]["falldamage"][3] = "vox_plr_2_exert_pain_low_3";
	level.exert_sounds[3]["falldamage"][4] = "vox_plr_2_exert_pain_low_4";
	level.exert_sounds[3]["falldamage"][5] = "vox_plr_2_exert_pain_low_5";
	level.exert_sounds[3]["falldamage"][6] = "vox_plr_2_exert_pain_low_6";
	level.exert_sounds[3]["falldamage"][7] = "vox_plr_2_exert_pain_low_7";
	level.exert_sounds[4]["falldamage"][0] = "vox_plr_3_exert_pain_low_0";
	level.exert_sounds[4]["falldamage"][1] = "vox_plr_3_exert_pain_low_1";
	level.exert_sounds[4]["falldamage"][2] = "vox_plr_3_exert_pain_low_2";
	level.exert_sounds[4]["falldamage"][3] = "vox_plr_3_exert_pain_low_3";
	level.exert_sounds[4]["falldamage"][4] = "vox_plr_3_exert_pain_low_4";
	level.exert_sounds[4]["falldamage"][5] = "vox_plr_3_exert_pain_low_5";
	level.exert_sounds[4]["falldamage"][6] = "vox_plr_3_exert_pain_low_6";
	level.exert_sounds[4]["falldamage"][7] = "vox_plr_3_exert_pain_low_7";
	level.exert_sounds[1]["mantlesoundplayer"][0] = "vox_plr_0_exert_grunt_0";
	level.exert_sounds[1]["mantlesoundplayer"][1] = "vox_plr_0_exert_grunt_1";
	level.exert_sounds[1]["mantlesoundplayer"][2] = "vox_plr_0_exert_grunt_2";
	level.exert_sounds[1]["mantlesoundplayer"][3] = "vox_plr_0_exert_grunt_3";
	level.exert_sounds[1]["mantlesoundplayer"][4] = "vox_plr_0_exert_grunt_4";
	level.exert_sounds[1]["mantlesoundplayer"][5] = "vox_plr_0_exert_grunt_5";
	level.exert_sounds[1]["mantlesoundplayer"][6] = "vox_plr_0_exert_grunt_6";
	level.exert_sounds[2]["mantlesoundplayer"][0] = "vox_plr_1_exert_grunt_0";
	level.exert_sounds[2]["mantlesoundplayer"][1] = "vox_plr_1_exert_grunt_1";
	level.exert_sounds[2]["mantlesoundplayer"][2] = "vox_plr_1_exert_grunt_2";
	level.exert_sounds[2]["mantlesoundplayer"][3] = "vox_plr_1_exert_grunt_3";
	level.exert_sounds[2]["mantlesoundplayer"][4] = "vox_plr_1_exert_grunt_4";
	level.exert_sounds[2]["mantlesoundplayer"][5] = "vox_plr_1_exert_grunt_5";
	level.exert_sounds[2]["mantlesoundplayer"][6] = "vox_plr_1_exert_grunt_6";
	level.exert_sounds[3]["mantlesoundplayer"][0] = "vox_plr_2_exert_grunt_0";
	level.exert_sounds[3]["mantlesoundplayer"][1] = "vox_plr_2_exert_grunt_1";
	level.exert_sounds[3]["mantlesoundplayer"][2] = "vox_plr_2_exert_grunt_2";
	level.exert_sounds[3]["mantlesoundplayer"][3] = "vox_plr_2_exert_grunt_3";
	level.exert_sounds[3]["mantlesoundplayer"][4] = "vox_plr_2_exert_grunt_4";
	level.exert_sounds[3]["mantlesoundplayer"][5] = "vox_plr_2_exert_grunt_5";
	level.exert_sounds[3]["mantlesoundplayer"][6] = "vox_plr_2_exert_grunt_6";
	level.exert_sounds[4]["mantlesoundplayer"][0] = "vox_plr_3_exert_grunt_0";
	level.exert_sounds[4]["mantlesoundplayer"][1] = "vox_plr_3_exert_grunt_1";
	level.exert_sounds[4]["mantlesoundplayer"][2] = "vox_plr_3_exert_grunt_2";
	level.exert_sounds[4]["mantlesoundplayer"][3] = "vox_plr_3_exert_grunt_3";
	level.exert_sounds[4]["mantlesoundplayer"][4] = "vox_plr_3_exert_grunt_4";
	level.exert_sounds[4]["mantlesoundplayer"][5] = "vox_plr_3_exert_grunt_5";
	level.exert_sounds[4]["mantlesoundplayer"][6] = "vox_plr_3_exert_grunt_6";
	level.exert_sounds[1]["meleeswipesoundplayer"][0] = "vox_plr_0_exert_knife_swipe_0";
	level.exert_sounds[1]["meleeswipesoundplayer"][1] = "vox_plr_0_exert_knife_swipe_1";
	level.exert_sounds[1]["meleeswipesoundplayer"][2] = "vox_plr_0_exert_knife_swipe_2";
	level.exert_sounds[1]["meleeswipesoundplayer"][3] = "vox_plr_0_exert_knife_swipe_3";
	level.exert_sounds[1]["meleeswipesoundplayer"][4] = "vox_plr_0_exert_knife_swipe_4";
	level.exert_sounds[1]["meleeswipesoundplayer"][5] = "vox_plr_0_exert_knife_swipe_5";
	level.exert_sounds[2]["meleeswipesoundplayer"][0] = "vox_plr_1_exert_knife_swipe_0";
	level.exert_sounds[2]["meleeswipesoundplayer"][1] = "vox_plr_1_exert_knife_swipe_1";
	level.exert_sounds[2]["meleeswipesoundplayer"][2] = "vox_plr_1_exert_knife_swipe_2";
	level.exert_sounds[2]["meleeswipesoundplayer"][3] = "vox_plr_1_exert_knife_swipe_3";
	level.exert_sounds[2]["meleeswipesoundplayer"][4] = "vox_plr_1_exert_knife_swipe_4";
	level.exert_sounds[2]["meleeswipesoundplayer"][5] = "vox_plr_1_exert_knife_swipe_5";
	level.exert_sounds[3]["meleeswipesoundplayer"][0] = "vox_plr_2_exert_knife_swipe_0";
	level.exert_sounds[3]["meleeswipesoundplayer"][1] = "vox_plr_2_exert_knife_swipe_1";
	level.exert_sounds[3]["meleeswipesoundplayer"][2] = "vox_plr_2_exert_knife_swipe_2";
	level.exert_sounds[3]["meleeswipesoundplayer"][3] = "vox_plr_2_exert_knife_swipe_3";
	level.exert_sounds[3]["meleeswipesoundplayer"][4] = "vox_plr_2_exert_knife_swipe_4";
	level.exert_sounds[3]["meleeswipesoundplayer"][5] = "vox_plr_2_exert_knife_swipe_5";
	level.exert_sounds[4]["meleeswipesoundplayer"][0] = "vox_plr_3_exert_knife_swipe_0";
	level.exert_sounds[4]["meleeswipesoundplayer"][1] = "vox_plr_3_exert_knife_swipe_1";
	level.exert_sounds[4]["meleeswipesoundplayer"][2] = "vox_plr_3_exert_knife_swipe_2";
	level.exert_sounds[4]["meleeswipesoundplayer"][3] = "vox_plr_3_exert_knife_swipe_3";
	level.exert_sounds[4]["meleeswipesoundplayer"][4] = "vox_plr_3_exert_knife_swipe_4";
	level.exert_sounds[4]["meleeswipesoundplayer"][5] = "vox_plr_3_exert_knife_swipe_5";
	level.exert_sounds[1]["dtplandsoundplayer"][0] = "vox_plr_0_exert_pain_medium_0";
	level.exert_sounds[1]["dtplandsoundplayer"][1] = "vox_plr_0_exert_pain_medium_1";
	level.exert_sounds[1]["dtplandsoundplayer"][2] = "vox_plr_0_exert_pain_medium_2";
	level.exert_sounds[1]["dtplandsoundplayer"][3] = "vox_plr_0_exert_pain_medium_3";
	level.exert_sounds[2]["dtplandsoundplayer"][0] = "vox_plr_1_exert_pain_medium_0";
	level.exert_sounds[2]["dtplandsoundplayer"][1] = "vox_plr_1_exert_pain_medium_1";
	level.exert_sounds[2]["dtplandsoundplayer"][2] = "vox_plr_1_exert_pain_medium_2";
	level.exert_sounds[2]["dtplandsoundplayer"][3] = "vox_plr_1_exert_pain_medium_3";
	level.exert_sounds[3]["dtplandsoundplayer"][0] = "vox_plr_2_exert_pain_medium_0";
	level.exert_sounds[3]["dtplandsoundplayer"][1] = "vox_plr_2_exert_pain_medium_1";
	level.exert_sounds[3]["dtplandsoundplayer"][2] = "vox_plr_2_exert_pain_medium_2";
	level.exert_sounds[3]["dtplandsoundplayer"][3] = "vox_plr_2_exert_pain_medium_3";
	level.exert_sounds[4]["dtplandsoundplayer"][0] = "vox_plr_3_exert_pain_medium_0";
	level.exert_sounds[4]["dtplandsoundplayer"][1] = "vox_plr_3_exert_pain_medium_1";
	level.exert_sounds[4]["dtplandsoundplayer"][2] = "vox_plr_3_exert_pain_medium_2";
	level.exert_sounds[4]["dtplandsoundplayer"][3] = "vox_plr_3_exert_pain_medium_3";
}

/*
	Name: postfx_futz_mild
	Namespace: zm_island
	Checksum: 0x1D1ED365
	Offset: 0x32A8
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function postfx_futz_mild(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	player postfx::playpostfxbundle("pstfx_dni_interrupt_mild");
}

/*
	Name: water_motes
	Namespace: zm_island
	Checksum: 0x55B5F4EF
	Offset: 0x3330
	Size: 0xDE
	Parameters: 7
	Flags: Linked
*/
function water_motes(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	wait(0.1);
	if(newval)
	{
		if(isdefined(self) && !isdefined(self.var_8e8c7340))
		{
			self.var_8e8c7340 = playviewmodelfx(localclientnum, level._effect["water_motes"], "tag_camera");
		}
	}
	else if(isdefined(self) && isdefined(self.var_8e8c7340))
	{
		deletefx(localclientnum, self.var_8e8c7340, 1);
		self.var_8e8c7340 = undefined;
	}
}

/*
	Name: function_58e931d1
	Namespace: zm_island
	Checksum: 0x52D7E579
	Offset: 0x3418
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_58e931d1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self thread function_6e954d4(localclientnum);
	}
	else
	{
		self thread function_6fb5501(localclientnum);
	}
}

/*
	Name: function_6e954d4
	Namespace: zm_island
	Checksum: 0x759D7927
	Offset: 0x34A0
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_6e954d4(localclientnum)
{
	self endon(#"death");
	if(!isdefined(self.var_b5e2500e))
	{
		self.var_b5e2500e = playfxoncamera(localclientnum, level._effect["bubbles"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
		self thread function_738868d4(localclientnum);
	}
}

/*
	Name: function_6fb5501
	Namespace: zm_island
	Checksum: 0xF59468BC
	Offset: 0x3528
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function function_6fb5501(localclientnum)
{
	if(isdefined(self.var_b5e2500e))
	{
		deletefx(localclientnum, self.var_b5e2500e, 1);
		self.var_b5e2500e = undefined;
	}
	self notify(#"hash_a48959b9");
}

/*
	Name: function_738868d4
	Namespace: zm_island
	Checksum: 0x7FAB9966
	Offset: 0x3588
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_738868d4(localclientnum)
{
	self endon(#"hash_a48959b9");
	self waittill(#"death");
	self function_6fb5501(localclientnum);
}

/*
	Name: function_346468e3
	Namespace: zm_island
	Checksum: 0x767F9287
	Offset: 0x35D0
	Size: 0xF4
	Parameters: 7
	Flags: Linked
*/
function function_346468e3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		setlitfogbank(localclientnum, -1, 1, -1);
		setworldfogactivebank(localclientnum, 2);
	}
	else
	{
		if(newval == 2)
		{
			setworldfogactivebank(localclientnum, 3);
		}
		else
		{
			setlitfogbank(localclientnum, -1, 0, -1);
			setworldfogactivebank(localclientnum, 1);
		}
	}
}

/*
	Name: on_localplayer_spawned
	Namespace: zm_island
	Checksum: 0x5F01FD23
	Offset: 0x36D0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function on_localplayer_spawned(localclientnum)
{
	if(self != getlocalplayer(localclientnum))
	{
		return;
	}
	filter::init_filter_speed_burst(self);
	filter::disable_filter_speed_burst(self, 3);
}

/*
	Name: player_speed_changed
	Namespace: zm_island
	Checksum: 0x29AC8F53
	Offset: 0x3730
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function player_speed_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(self == getlocalplayer(localclientnum))
		{
			filter::enable_filter_speed_burst(self, 3);
		}
	}
	else if(self == getlocalplayer(localclientnum))
	{
		filter::disable_filter_speed_burst(self, 3);
	}
}

/*
	Name: mapped_material_id
	Namespace: zm_island
	Checksum: 0x78E4714E
	Offset: 0x37F8
	Size: 0x30
	Parameters: 1
	Flags: None
*/
function mapped_material_id(materialname)
{
	if(!isdefined(level.filter_matid))
	{
		level.filter_matid = [];
	}
	return level.filter_matid[materialname];
}

/*
	Name: water_sheeting_toggle
	Namespace: zm_island
	Checksum: 0xAB0F059D
	Offset: 0x3830
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function water_sheeting_toggle(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		startwatersheetingfx(localclientnum, 1);
		playsound(localclientnum, "evt_sewer_transport_start");
		self.var_14108ea4 = self playloopsound("evt_sewer_transport_loop", 0.3);
	}
	else
	{
		stopwatersheetingfx(localclientnum, 0);
		self stoploopsound(self.var_14108ea4);
	}
}

/*
	Name: function_4a01cc4e
	Namespace: zm_island
	Checksum: 0xD9B3ED15
	Offset: 0x3928
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function function_4a01cc4e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		enablespeedblur(localclientnum, 0.07, 0.55, 0.9, 0, 100, 100);
	}
	else
	{
		disablespeedblur(localclientnum);
	}
}

/*
	Name: set_heavy_web_fade_material
	Namespace: zm_island
	Checksum: 0xE9EE77A
	Offset: 0x39C8
	Size: 0x16C
	Parameters: 7
	Flags: Linked
*/
function set_heavy_web_fade_material(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 1, 1, 1, 0);
	}
	else
	{
		var_b05b3457 = 0.01;
		var_bbfa5d7d = newval;
		self playsound(0, "zmb_spider_web_hero_destroy");
		i = 1;
		while(i > var_bbfa5d7d)
		{
			if(isdefined(self))
			{
				self mapshaderconstant(localclientnum, 0, "scriptVector2", i, i, i, 0);
				wait(var_b05b3457);
			}
			else
			{
				break;
			}
			i = i - var_b05b3457;
		}
		if(isdefined(self))
		{
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 0, 0, 0);
		}
	}
}

/*
	Name: function_be61cf5a
	Namespace: zm_island
	Checksum: 0xA75DFB9B
	Offset: 0x3B40
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function function_be61cf5a()
{
	var_f47aa4cf = getdynentarray();
	foreach(dyn_ent in var_f47aa4cf)
	{
		setdynentenabled(dyn_ent, 0);
	}
}

/*
	Name: function_3a429aee
	Namespace: zm_island
	Checksum: 0xB6E996FE
	Offset: 0x3BF8
	Size: 0x304
	Parameters: 0
	Flags: Linked
*/
function function_3a429aee()
{
	forcestreamxmodel("p7_zm_isl_bucket_115");
	forcestreamxmodel("p7_fxanim_zm_island_vine_gate_mod");
	forcestreamxmodel("p7_zm_vending_jugg");
	forcestreamxmodel("p7_zm_vending_doubletap2");
	forcestreamxmodel("p7_zm_vending_revive");
	forcestreamxmodel("p7_zm_vending_sleight");
	forcestreamxmodel("p7_zm_vending_three_gun");
	forcestreamxmodel("p7_zm_vending_marathon");
	forcestreamxmodel("p7_zm_isl_web_vending_jugg");
	forcestreamxmodel("p7_zm_isl_web_vending_doubletap2");
	forcestreamxmodel("p7_zm_isl_web_vending_revive");
	forcestreamxmodel("p7_zm_isl_web_vending_sleight");
	forcestreamxmodel("p7_zm_isl_web_vending_three_gun");
	forcestreamxmodel("p7_zm_isl_web_vending_marathon");
	forcestreamxmodel("p7_zm_isl_web_buy_door");
	forcestreamxmodel("p7_zm_isl_web_buy_door_110");
	forcestreamxmodel("p7_zm_isl_web_buy_door_112");
	forcestreamxmodel("p7_zm_isl_web_buy_door_114");
	forcestreamxmodel("p7_zm_isl_web_buy_door_132");
	forcestreamxmodel("p7_zm_isl_web_buy_door_146");
	forcestreamxmodel("p7_zm_isl_web_penstock");
	forcestreamxmodel("p7_zm_isl_web_bubblegum_machine");
	forcestreamxmodel("p7_zm_power_up_max_ammo");
	forcestreamxmodel("p7_zm_power_up_carpenter");
	forcestreamxmodel("p7_zm_power_up_double_points");
	forcestreamxmodel("p7_zm_power_up_firesale");
	forcestreamxmodel("p7_zm_power_up_insta_kill");
	forcestreamxmodel("p7_zm_power_up_nuke");
	forcestreamxmodel("zombie_pickup_minigun");
	forcestreamxmodel("zombie_pickup_perk_bottle");
	forcestreamxmodel("zombie_z_money_icon");
	forcestreamxmodel("p7_zm_isl_plant_seed_pod_01");
}

/*
	Name: force_stream_spiders
	Namespace: zm_island
	Checksum: 0xD960D244
	Offset: 0x3F08
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function force_stream_spiders(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		forcestreamxmodel("c_zom_dlc2_spider");
	}
	else
	{
		stopforcestreamingxmodel("c_zom_dlc2_spider");
	}
}

/*
	Name: force_stream_takeo_arms
	Namespace: zm_island
	Checksum: 0xA5B5D80D
	Offset: 0x3F90
	Size: 0x10C
	Parameters: 7
	Flags: Linked
*/
function force_stream_takeo_arms(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		forcestreamxmodel("p7_fxanim_zm_island_takeo_arm1_mod");
		forcestreamxmodel("p7_fxanim_zm_island_takeo_arm2_mod");
		forcestreamxmodel("p7_fxanim_zm_island_takeo_arm3_mod");
		forcestreamxmodel("p7_fxanim_zm_island_takeo_arm4_mod");
	}
	else
	{
		stopforcestreamingxmodel("p7_fxanim_zm_island_takeo_arm1_mod");
		stopforcestreamingxmodel("p7_fxanim_zm_island_takeo_arm2_mod");
		stopforcestreamingxmodel("p7_fxanim_zm_island_takeo_arm3_mod");
		stopforcestreamingxmodel("p7_fxanim_zm_island_takeo_arm4_mod");
	}
}

