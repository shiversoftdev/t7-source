// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_spiders;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_mirg2000;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_island_util;
#using scripts\zm\zm_island_ww_quest;

#namespace zm_island_spider_quest;

/*
	Name: init
	Namespace: zm_island_spider_quest
	Checksum: 0x85729DA2
	Offset: 0x1228
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level flag::init("spider_lair_webs_destroyed");
	if(!level flag::exists("spider_queen_dead"))
	{
		level flag::init("spider_queen_dead");
	}
	level thread function_83b9f02b();
	level thread function_2ff7183();
	level thread function_9c86c1bb();
	array::thread_all(getentarray("spider_lair_entrance_webs", "targetname"), &spider_lair_entrance_webs);
	/#
		function_4f46a12();
	#/
}

/*
	Name: function_83b9f02b
	Namespace: zm_island_spider_quest
	Checksum: 0x87B28B31
	Offset: 0x1338
	Size: 0x454
	Parameters: 0
	Flags: Linked
*/
function function_83b9f02b()
{
	trigger::wait_till("spider_queen_start_fight");
	level.var_4e5986ea = 2;
	level.var_e18ab0f2 = 0;
	level flag::init("spider_queen_spawn_babies");
	level flag::init("spider_queen_weak_spot_exposed");
	level flag::init("spider_queen_perform_leg_attack");
	level flag::init("spider_attack_done");
	level flag::init("spider_baby_round_done");
	level flag::init("spider_baby_round_timeout");
	level flag::init("spider_baby_hit_react");
	level flag::init("spider_queen_perform_spit_attack");
	level flag::init("spider_queen_stage_1");
	level flag::init("spider_queen_stage_2");
	level flag::init("spider_queen_stage_3");
	level flag::init("spider_queen_set_idle");
	level thread function_bccbf63c();
	if(level.players.size > 2)
	{
		level.var_5bb615cd = 100000;
		level.var_dd315d9c = 80000;
		level.var_f6f57e72 = 40000;
		level.var_7dc3717a = 6;
	}
	else
	{
		level.var_5bb615cd = 25000;
		level.var_dd315d9c = 20000;
		level.var_f6f57e72 = 10000;
		level.var_7dc3717a = 3;
	}
	level flag::clear("zombie_drop_powerups");
	var_85683d05 = util::spawn_anim_model("c_zom_dlc2_queen_spider");
	var_85683d05 clientfield::set("spider_queen_emissive_material", 1);
	var_85683d05 thread function_2a9d57ae();
	array::thread_all(getentarray("spider_leg_damage", "targetname"), &function_9d6e8018);
	array::thread_all(getentarray("spider_spit_damage", "targetname"), &function_1b11ad0);
	array::thread_all(getentarray("spider_spit_damage", "targetname"), &function_9ee2204c, var_85683d05);
	var_85683d05 function_c225d3aa();
	var_85683d05 thread function_f0c6c167();
	var_85683d05 thread function_7b31e716();
	var_85683d05 thread function_9b964659();
	var_85683d05 thread function_e2b5f12f();
	var_85683d05 thread function_b6ea5d0d();
	var_85683d05 thread function_e949d1d7();
	level thread function_65c52965();
}

/*
	Name: function_2a9d57ae
	Namespace: zm_island_spider_quest
	Checksum: 0xEAAF8C27
	Offset: 0x1798
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_2a9d57ae()
{
	self clientfield::set("spider_queen_mouth_weakspot", 2);
}

/*
	Name: function_9c86c1bb
	Namespace: zm_island_spider_quest
	Checksum: 0xB92233F0
	Offset: 0x17C8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_9c86c1bb()
{
	level flag::wait_till("spider_lair_webs_destroyed");
	getent("clip_spider_lair_entrance", "targetname") delete();
	level scene::init("p7_fxanim_zm_island_spider_queen_lair_rocks_bundle");
}

/*
	Name: spider_lair_entrance_webs
	Namespace: zm_island_spider_quest
	Checksum: 0x1E155D2D
	Offset: 0x1848
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function spider_lair_entrance_webs()
{
	self setcandamage(1);
	self clientfield::set("set_heavy_web_fade_material", 1);
	self thread function_83953ff7();
	level flag::wait_till("spider_lair_webs_destroyed");
	self clientfield::set("set_heavy_web_fade_material", 0);
	self notsolid();
	wait(3);
	self delete();
}

/*
	Name: function_83953ff7
	Namespace: zm_island_spider_quest
	Checksum: 0x2EB7EA77
	Offset: 0x1918
	Size: 0x158
	Parameters: 0
	Flags: Linked
*/
function function_83953ff7()
{
	level endon(#"spider_lair_webs_destroyed");
	while(true)
	{
		self waittill(#"damage", damage, attacker, direction_vec, point, type, modelname, tagname, partname, weapon, idflags);
		if(mirg2000::is_wonder_weapon(weapon))
		{
			if(mirg2000::is_wonder_weapon(weapon, "upgraded"))
			{
				self thread fx::play("special_web_dissolve_ug", self.origin, self.angles);
			}
			else
			{
				self thread fx::play("special_web_dissolve", self.origin, self.angles);
			}
			level flag::set("spider_lair_webs_destroyed");
		}
	}
}

/*
	Name: function_c225d3aa
	Namespace: zm_island_spider_quest
	Checksum: 0x43CD6359
	Offset: 0x1A78
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_c225d3aa()
{
	wait(1.5);
	level thread function_f7244a06(1);
	playsoundatposition("zmb_vocals_squeen_roar_start", (-5000, 932, -157));
	wait(1.5);
	level util::delay(1, undefined, &function_f7244a06, 2);
	level util::delay(5.23, undefined, &function_f7244a06, 3);
	level scene::play("cin_t7_ai_zm_dlc2_spider_queen_entrance", self);
	level thread scene::play("cin_t7_ai_zm_dlc2_spider_queen_idle", self);
}

/*
	Name: function_f7244a06
	Namespace: zm_island_spider_quest
	Checksum: 0x8853E1E5
	Offset: 0x1B78
	Size: 0x162
	Parameters: 1
	Flags: Linked
*/
function function_f7244a06(n_index)
{
	var_297c6282 = getent("spider_queen_start_fight", "targetname");
	foreach(player in level.players)
	{
		if(zm_utility::is_player_valid(player) && player istouching(var_297c6282))
		{
			if(n_index == 1)
			{
				player playrumbleonentity("zm_island_rumble_spider_queen_intro_01");
				continue;
			}
			if(n_index == 2)
			{
				player playrumbleonentity("zm_island_rumble_spider_queen_intro_02");
				continue;
			}
			player playrumbleonentity("zm_island_rumble_spider_queen_intro_03");
		}
	}
}

/*
	Name: function_65c52965
	Namespace: zm_island_spider_quest
	Checksum: 0x8E12B9F9
	Offset: 0x1CE8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_65c52965()
{
	level endon(#"hash_2dc546da");
	/#
		level endon(#"hash_9a8b82c3");
	#/
	function_4af05c8a();
	function_24ede221();
	function_feeb67b8();
}

/*
	Name: function_4af05c8a
	Namespace: zm_island_spider_quest
	Checksum: 0xB213480C
	Offset: 0x1D48
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function function_4af05c8a()
{
	level endon(#"hash_2dc546da");
	/#
		level endon(#"hash_9a8b82c3");
	#/
	while(level flag::get("spider_queen_stage_1"))
	{
		function_f033c56a();
		function_f033c56a();
		function_3f6b6cb4();
		function_f033c56a();
		function_57b6770a();
		function_f033c56a();
		function_f033c56a();
		function_3f6b6cb4();
		function_3f6b6cb4();
		function_f033c56a();
		function_57b6770a();
	}
}

/*
	Name: function_24ede221
	Namespace: zm_island_spider_quest
	Checksum: 0x85384662
	Offset: 0x1E48
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function function_24ede221()
{
	level endon(#"hash_2dc546da");
	/#
		level endon(#"hash_9a8b82c3");
	#/
	while(level flag::get("spider_queen_stage_2"))
	{
		function_3f6b6cb4();
		function_3f6b6cb4();
		function_f033c56a();
		function_f033c56a();
		function_57b6770a();
		function_f033c56a();
		function_3f6b6cb4();
		function_3f6b6cb4();
		function_f033c56a();
		function_f033c56a();
		function_57b6770a();
	}
}

/*
	Name: function_feeb67b8
	Namespace: zm_island_spider_quest
	Checksum: 0x885FD846
	Offset: 0x1F48
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function function_feeb67b8()
{
	level endon(#"hash_2dc546da");
	/#
		level endon(#"hash_9a8b82c3");
	#/
	while(level flag::get("spider_queen_stage_3"))
	{
		function_f033c56a();
		function_f033c56a();
		function_3f6b6cb4();
		function_3f6b6cb4();
		function_f033c56a();
		function_3f6b6cb4();
		function_57b6770a();
		function_f033c56a();
		function_f033c56a();
		function_3f6b6cb4();
		function_3f6b6cb4();
		function_3f6b6cb4();
		function_f033c56a();
		function_57b6770a();
	}
}

/*
	Name: function_f033c56a
	Namespace: zm_island_spider_quest
	Checksum: 0x85DCBBA4
	Offset: 0x2078
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_f033c56a()
{
	level flag::wait_till_clear("spider_queen_set_idle");
	level flag::set("spider_queen_perform_leg_attack");
	function_2152712c();
}

/*
	Name: function_3f6b6cb4
	Namespace: zm_island_spider_quest
	Checksum: 0xFF8C9094
	Offset: 0x20D8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_3f6b6cb4()
{
	level flag::wait_till_clear("spider_queen_set_idle");
	level flag::set("spider_queen_perform_spit_attack");
	function_2152712c();
}

/*
	Name: function_57b6770a
	Namespace: zm_island_spider_quest
	Checksum: 0x5B7B1FB7
	Offset: 0x2138
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_57b6770a()
{
	level flag::wait_till_clear("spider_queen_set_idle");
	if(level.var_e18ab0f2 < level.var_7dc3717a)
	{
		level flag::set("spider_queen_spawn_babies");
		function_2152712c();
	}
}

/*
	Name: function_2152712c
	Namespace: zm_island_spider_quest
	Checksum: 0x33527DA0
	Offset: 0x21A8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_2152712c()
{
	level flag::wait_till("spider_attack_done");
	wait(randomfloatrange(0.5, 1.5));
	level flag::clear("spider_attack_done");
}

/*
	Name: function_7b31e716
	Namespace: zm_island_spider_quest
	Checksum: 0x9B418D08
	Offset: 0x2218
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function function_7b31e716()
{
	self thread function_5a50e7f();
	level flag::set("spider_queen_stage_1");
	while(level.var_5bb615cd > level.var_dd315d9c)
	{
		wait(0.05);
	}
	level flag::clear("spider_queen_stage_1");
	level flag::set("spider_queen_stage_2");
	self function_82ae321c(2);
	while(level.var_5bb615cd > level.var_f6f57e72)
	{
		wait(0.05);
	}
	level flag::clear("spider_queen_stage_2");
	level flag::set("spider_queen_stage_3");
	self function_82ae321c(3);
	while(level.var_5bb615cd > 0)
	{
		wait(0.05);
	}
	level flag::set("spider_queen_dead");
}

/*
	Name: function_e949d1d7
	Namespace: zm_island_spider_quest
	Checksum: 0x22E4F2D8
	Offset: 0x2388
	Size: 0x1B6
	Parameters: 0
	Flags: Linked
*/
function function_e949d1d7()
{
	level endon(#"hash_2dc546da");
	var_297c6282 = getent("spider_queen_start_fight", "targetname");
	while(true)
	{
		var_c0d42e55 = [];
		foreach(player in level.players)
		{
			if(zm_utility::is_player_valid(player) && player istouching(var_297c6282))
			{
				array::add(var_c0d42e55, player);
			}
		}
		if(var_c0d42e55.size == 0)
		{
			if(!level flag::get("spider_queen_set_idle"))
			{
				level flag::set("spider_queen_set_idle");
			}
		}
		else if(level flag::get("spider_queen_set_idle"))
		{
			level flag::clear("spider_queen_set_idle");
		}
		var_c0d42e55 = undefined;
		wait(5);
	}
}

/*
	Name: function_82ae321c
	Namespace: zm_island_spider_quest
	Checksum: 0x7B975DC0
	Offset: 0x2548
	Size: 0x2EC
	Parameters: 1
	Flags: Linked
*/
function function_82ae321c(n_stage)
{
	/#
		level endon(#"hash_9a8b82c3");
	#/
	level notify(#"hash_c69c8ddc");
	self clientfield::set("spider_queen_stage_bleed", n_stage);
	level flag::clear("spider_queen_weak_spot_exposed");
	if(level flag::get("spider_queen_spawn_babies"))
	{
		level flag::set("spider_baby_hit_react");
		if(n_stage == 2)
		{
			level scene::play("cin_t7_ai_zm_dlc2_spider_queen_baby_drop_pain_react_phase_2", self);
		}
		else
		{
			level scene::play("cin_t7_ai_zm_dlc2_spider_queen_baby_drop_pain_react_phase_3", self);
		}
		level flag::clear("spider_queen_spawn_babies");
		if(!level flag::get("spider_baby_round_done") || !level flag::get("spider_baby_round_timeout"))
		{
			level scene::play("cin_t7_ai_zm_dlc2_spider_queen_baby_drop_outro", self);
			level thread scene::play("cin_t7_ai_zm_dlc2_spider_queen_backwall_idle", self);
			level flag::wait_till_any(array("spider_baby_round_done", "spider_baby_round_timeout"));
			level scene::play("cin_t7_ai_zm_dlc2_spider_queen_backwall_outro", self);
		}
	}
	else
	{
		if(n_stage == 2)
		{
			level scene::play("cin_t7_ai_zm_dlc2_spider_queen_arm_attack_pain_react_phase_2", self);
		}
		else
		{
			level scene::play("cin_t7_ai_zm_dlc2_spider_queen_arm_attack_pain_react_phase_3", self);
		}
		level flag::clear("spider_queen_perform_leg_attack");
	}
	self thread function_9b964659();
	self thread function_b6ea5d0d();
	level thread scene::play("cin_t7_ai_zm_dlc2_spider_queen_idle", self);
	if(n_stage == 2)
	{
		level.var_4e5986ea = 3;
	}
	else
	{
		level.var_4e5986ea = 4;
	}
	level flag::set("spider_attack_done");
}

/*
	Name: function_f0c6c167
	Namespace: zm_island_spider_quest
	Checksum: 0xF9FF3FBE
	Offset: 0x2840
	Size: 0x254
	Parameters: 0
	Flags: Linked
*/
function function_f0c6c167()
{
	level flag::wait_till("spider_queen_dead");
	self clientfield::set("spider_queen_stage_bleed", 1);
	level flag::clear("spider_queen_weak_spot_exposed");
	level notify(#"hash_2dc546da");
	level util::clientnotify("sndLair");
	level thread function_7ed6256d();
	self thread function_a38800f6();
	if(level flag::get("spider_queen_spawn_babies"))
	{
		level scene::play("cin_t7_ai_zm_dlc2_spider_queen_death_from_baby_drop", self);
	}
	else
	{
		level scene::play("cin_t7_ai_zm_dlc2_spider_queen_death_from_arm_attack", self);
	}
	self clientfield::set("spider_queen_mouth_weakspot", 0);
	level flag::set("zombie_drop_powerups");
	var_8b5cd120 = getent("volume_thrasher_non_teleport_spider_boss", "targetname");
	var_8b5cd120 delete();
	var_794ac17c = getent("clip_monster_spider_queen_entrance", "targetname");
	var_794ac17c delete();
	level thread function_199d01b5();
	self thread zm_island_ww_quest::function_bc717528();
	self notsolid();
	self notify(#"hash_aaf78b5");
	self clientfield::set("spider_queen_emissive_material", 0);
}

/*
	Name: function_a38800f6
	Namespace: zm_island_spider_quest
	Checksum: 0x9B45EE2E
	Offset: 0x2AA0
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function function_a38800f6()
{
	self endon(#"hash_aaf78b5");
	var_297c6282 = getent("spider_queen_start_fight", "targetname");
	while(true)
	{
		foreach(player in level.players)
		{
			if(zm_utility::is_player_valid(player) && player istouching(var_297c6282))
			{
				player playrumbleonentity("tank_damage_heavy_mp");
				earthquake(0.35, 0.5, player.origin, 325);
			}
		}
		wait(0.15);
	}
}

/*
	Name: function_7ed6256d
	Namespace: zm_island_spider_quest
	Checksum: 0xF2829744
	Offset: 0x2BF8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_7ed6256d()
{
	level thread scene::play("p7_fxanim_zm_island_spider_queen_lair_rocks_bundle");
	wait(4);
	getent("spiderlair_pathblocker", "targetname") notsolid();
}

/*
	Name: function_5a50e7f
	Namespace: zm_island_spider_quest
	Checksum: 0x706A2A70
	Offset: 0x2C60
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function function_5a50e7f()
{
	level endon(#"hash_2dc546da");
	self setcandamage(1);
	while(true)
	{
		self waittill(#"damage", n_damage, attacker, direction_vec, point, type, modelname, tagname, partname, weapon, idflags);
		if(partname == "tag_mouth_hit")
		{
			if(level flag::get("spider_queen_weak_spot_exposed"))
			{
				if(mirg2000::is_wonder_weapon(weapon, "upgraded"))
				{
					n_damage = 750;
				}
				else if(mirg2000::is_wonder_weapon(weapon, "default"))
				{
					n_damage = 500;
				}
				self clientfield::increment("spider_queen_bleed");
				attacker damagefeedback::update();
				level.var_5bb615cd = level.var_5bb615cd - n_damage;
			}
		}
	}
}

/*
	Name: spider_queen_weakspot
	Namespace: zm_island_spider_quest
	Checksum: 0xB69E6143
	Offset: 0x2DF0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function spider_queen_weakspot()
{
	self clientfield::set("spider_queen_mouth_weakspot", 1);
	level flag::wait_till_clear("spider_queen_weak_spot_exposed");
	self clientfield::set("spider_queen_mouth_weakspot", 2);
}

/*
	Name: function_9b964659
	Namespace: zm_island_spider_quest
	Checksum: 0x6B92FFB9
	Offset: 0x2E60
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_9b964659()
{
	level endon(#"hash_2dc546da");
	var_a857d88e = [];
	var_27730eaa = [];
	for(i = 0; i < 5; i++)
	{
		var_a857d88e[i] = getent("spider_queen_arm_0" + i, "targetname");
		var_27730eaa[i] = getent("spider_leg_damage_0" + i, "targetname");
	}
	self thread function_291b262e(var_a857d88e, var_27730eaa);
}

/*
	Name: function_291b262e
	Namespace: zm_island_spider_quest
	Checksum: 0x962500AE
	Offset: 0x2F40
	Size: 0x420
	Parameters: 2
	Flags: Linked
*/
function function_291b262e(var_a857d88e, var_27730eaa)
{
	level endon(#"hash_2dc546da");
	level endon(#"hash_c69c8ddc");
	var_dc084637 = [];
	var_6a00d6fc = [];
	var_90035165 = [];
	array::add(var_dc084637, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_a_1_3");
	array::add(var_dc084637, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_a_1_4");
	array::add(var_dc084637, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_a_2_3");
	array::add(var_dc084637, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_a_3_1");
	array::add(var_dc084637, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_a_4_2");
	array::add(var_6a00d6fc, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_b_1_4_2");
	array::add(var_6a00d6fc, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_b_2_3_1");
	array::add(var_6a00d6fc, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_b_3_1_4");
	array::add(var_6a00d6fc, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_b_3_4_2");
	array::add(var_6a00d6fc, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_b_4_1_3");
	array::add(var_90035165, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_c_1_3_4_2");
	array::add(var_90035165, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_c_2_3_1_4");
	array::add(var_90035165, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_c_3_1_2_4");
	array::add(var_90035165, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_c_4_1_3_2");
	array::add(var_90035165, "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_c_4_2_1_3");
	while(true)
	{
		level flag::wait_till("spider_queen_perform_leg_attack");
		level scene::play("cin_t7_ai_zm_dlc2_spider_queen_arm_attack_intro", self);
		level thread scene::play("cin_t7_ai_zm_dlc2_spider_queen_arm_attack_loop", self);
		level flag::set("spider_queen_weak_spot_exposed");
		self thread spider_queen_weakspot();
		if(level.var_4e5986ea == 2)
		{
			var_679258c3 = array::random(var_dc084637);
		}
		else
		{
			if(level.var_4e5986ea == 3)
			{
				var_679258c3 = array::random(var_6a00d6fc);
			}
			else
			{
				var_679258c3 = array::random(var_90035165);
			}
		}
		level scene::play(var_679258c3, self);
		level scene::play("cin_t7_ai_zm_dlc2_spider_queen_arm_attack_outro", self);
		level thread scene::play("cin_t7_ai_zm_dlc2_spider_queen_idle", self);
		level flag::set("spider_attack_done");
		level flag::clear("spider_queen_weak_spot_exposed");
		level flag::clear("spider_queen_perform_leg_attack");
		wait(0.05);
	}
}

/*
	Name: function_9d6e8018
	Namespace: zm_island_spider_quest
	Checksum: 0x2B4EEBE0
	Offset: 0x3368
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function function_9d6e8018()
{
	level endon(#"hash_2dc546da");
	while(true)
	{
		level waittill(self.script_noteworthy + "_hitground");
		self thread function_9d331ff6();
		a_e_players = self array::get_touching(level.players);
		array::thread_all(a_e_players, &function_8e1549bd);
	}
}

/*
	Name: function_9d331ff6
	Namespace: zm_island_spider_quest
	Checksum: 0x513AC9E
	Offset: 0x3408
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_9d331ff6()
{
	s_org = struct::get("spider_leg_hit_" + self.script_noteworthy);
	e_pos = util::spawn_model("tag_origin", s_org.origin);
	e_pos playrumbleonentity("tank_damage_heavy_mp");
	screenshake(e_pos.origin, 5, 2, 2, 0.5, 0, -1, 150, 7, 1, 1, 1);
	wait(3);
	e_pos delete();
}

/*
	Name: function_8e1549bd
	Namespace: zm_island_spider_quest
	Checksum: 0xB3A3048D
	Offset: 0x3500
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_8e1549bd()
{
	self dodamage(90, self.origin, undefined, undefined, undefined, "MOD_MELEE");
	self playrumbleonentity("tank_damage_heavy_mp");
}

/*
	Name: function_e2b5f12f
	Namespace: zm_island_spider_quest
	Checksum: 0xAF749F29
	Offset: 0x3560
	Size: 0x1E0
	Parameters: 0
	Flags: Linked
*/
function function_e2b5f12f()
{
	level endon(#"hash_2dc546da");
	level.var_1bf7f6a1 = [];
	array::add(level.var_1bf7f6a1, "cin_t7_ai_zm_dlc2_spider_queen_attack_spit_straight");
	array::add(level.var_1bf7f6a1, "cin_t7_ai_zm_dlc2_spider_queen_attack_spit_left");
	array::add(level.var_1bf7f6a1, "cin_t7_ai_zm_dlc2_spider_queen_attack_spit_right");
	while(true)
	{
		level flag::wait_till("spider_queen_perform_spit_attack");
		level flag::set("spider_queen_weak_spot_exposed");
		self thread spider_queen_weakspot();
		var_9c85831c = array::random(level.var_1bf7f6a1);
		level thread function_29454161(var_9c85831c);
		level scene::play(var_9c85831c, self);
		level scene::play("cin_t7_ai_zm_dlc2_spider_queen_arm_attack_outro", self);
		level thread scene::play("cin_t7_ai_zm_dlc2_spider_queen_idle", self);
		level flag::set("spider_attack_done");
		level flag::clear("spider_queen_perform_spit_attack");
		level flag::clear("spider_queen_weak_spot_exposed");
		wait(0.05);
	}
}

/*
	Name: function_29454161
	Namespace: zm_island_spider_quest
	Checksum: 0x3D03ABC
	Offset: 0x3748
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_29454161(var_e2556d9e)
{
	level endon(#"hash_2dc546da");
	arrayremovevalue(level.var_1bf7f6a1, var_e2556d9e);
	wait(8);
	array::add(level.var_1bf7f6a1, var_e2556d9e);
}

/*
	Name: function_1b11ad0
	Namespace: zm_island_spider_quest
	Checksum: 0x247D0C1
	Offset: 0x37A8
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function function_1b11ad0()
{
	level endon(#"hash_2dc546da");
	while(true)
	{
		var_4c01b049 = 8;
		level waittill(self.script_noteworthy + "_spit");
		self playsound("zmb_foley_squeen_spit_impact");
		while(var_4c01b049 > 0)
		{
			a_e_players = self array::get_touching(level.players);
			array::thread_all(a_e_players, &function_ae6c3ac5);
			var_4c01b049 = var_4c01b049 - 1;
			wait(1);
		}
	}
}

/*
	Name: function_9ee2204c
	Namespace: zm_island_spider_quest
	Checksum: 0x81528E51
	Offset: 0x3888
	Size: 0x188
	Parameters: 1
	Flags: Linked
*/
function function_9ee2204c(var_85683d05)
{
	level endon(#"hash_2dc546da");
	s_left = struct::get("spider_spit_org_left");
	s_center = struct::get("spider_spit_org_center");
	s_right = struct::get("spider_spit_org_right");
	while(true)
	{
		level waittill(self.script_noteworthy + "_spit");
		if(self.script_noteworthy == "left")
		{
			var_e70fce50 = "fxexp_712";
			var_e066ed22 = s_left;
		}
		else
		{
			if(self.script_noteworthy == "center")
			{
				var_e70fce50 = "fxexp_711";
				var_e066ed22 = s_center;
			}
			else
			{
				var_e70fce50 = "fxexp_710";
				var_e066ed22 = s_right;
			}
		}
		var_e066ed22 function_bcafc53d(var_85683d05);
		exploder::exploder(var_e70fce50);
		level thread function_fcb8aed2(var_e70fce50);
		var_e066ed22 = undefined;
	}
}

/*
	Name: function_bcafc53d
	Namespace: zm_island_spider_quest
	Checksum: 0x20014C46
	Offset: 0x3A18
	Size: 0x1B4
	Parameters: 1
	Flags: Linked
*/
function function_bcafc53d(var_85683d05)
{
	s_org = spawn("script_model", var_85683d05 gettagorigin("tag_turret"));
	s_org setmodel("tag_origin");
	s_org enablelinkto();
	s_org fx::play("spider_queen_spit_attack", s_org.origin, undefined, 0.5, 1, "tag_origin");
	s_org moveto(self.origin, 0.5);
	s_org util::waittill_any_timeout(0.5, "movedone");
	self fx::play("spider_queen_spit_impact", self.origin, undefined);
	s_org playrumbleonentity("tank_damage_heavy_mp");
	earthquake(0.35, 0.5, s_org.origin, 325);
	wait(1);
	s_org delete();
}

/*
	Name: function_fcb8aed2
	Namespace: zm_island_spider_quest
	Checksum: 0x410D765D
	Offset: 0x3BD8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_fcb8aed2(var_e70fce50)
{
	wait(8);
	exploder::stop_exploder(var_e70fce50);
}

/*
	Name: function_ae6c3ac5
	Namespace: zm_island_spider_quest
	Checksum: 0x2F9F1DE1
	Offset: 0x3C10
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_ae6c3ac5()
{
	self dodamage(40, self.origin, undefined, undefined, undefined, "MOD_MELEE");
	self shellshock("default", 2);
	self playrumbleonentity("tank_damage_heavy_mp");
}

/*
	Name: function_b6ea5d0d
	Namespace: zm_island_spider_quest
	Checksum: 0x9D47804
	Offset: 0x3C98
	Size: 0x408
	Parameters: 0
	Flags: Linked
*/
function function_b6ea5d0d()
{
	level endon(#"hash_2dc546da");
	level endon(#"hash_c69c8ddc");
	level thread function_9a7e7358();
	while(true)
	{
		level flag::wait_till("spider_queen_spawn_babies");
		level scene::play("cin_t7_ai_zm_dlc2_spider_queen_baby_drop_intro", self);
		level thread scene::play("cin_t7_ai_zm_dlc2_spider_queen_baby_drop_loop", self);
		level flag::set("spider_queen_weak_spot_exposed");
		level flag::clear("spider_baby_round_done");
		level flag::clear("spider_baby_round_timeout");
		level flag::clear("spider_baby_hit_react");
		self thread spider_queen_weakspot();
		n_count = 0;
		if(level.players.size > 2)
		{
			n_count = 10;
		}
		else
		{
			n_count = 5;
		}
		level thread function_fb907799(n_count);
		level thread spider_baby_round_timeout(n_count);
		level thread function_dd902934();
		var_cc724e2d = struct::get_array("spider_body_spawn_point");
		var_4e46d51e = struct::get_array("spider_env_spawn_point");
		for(i = 0; i < n_count; i++)
		{
			if(var_cc724e2d.size != 0)
			{
				var_54219006 = array::random(var_cc724e2d);
				arrayremovevalue(var_cc724e2d, var_54219006);
			}
			else
			{
				var_54219006 = array::random(var_4e46d51e);
				arrayremovevalue(var_4e46d51e, var_54219006);
			}
			var_54219006 thread function_3d4c345d();
			wait(randomfloatrange(0.5, 1));
		}
		var_cc724e2d = undefined;
		var_4e46d51e = undefined;
		level scene::play("cin_t7_ai_zm_dlc2_spider_queen_baby_drop_outro", self);
		level thread scene::play("cin_t7_ai_zm_dlc2_spider_queen_backwall_idle", self);
		level flag::clear("spider_queen_weak_spot_exposed");
		level flag::wait_till_any(array("spider_baby_round_done", "spider_baby_round_timeout"));
		level scene::play("cin_t7_ai_zm_dlc2_spider_queen_backwall_outro", self);
		level thread scene::play("cin_t7_ai_zm_dlc2_spider_queen_idle", self);
		level flag::set("spider_attack_done");
		level flag::clear("spider_queen_spawn_babies");
		wait(0.05);
	}
}

/*
	Name: function_9a7e7358
	Namespace: zm_island_spider_quest
	Checksum: 0xB328CA70
	Offset: 0x40A8
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function function_9a7e7358()
{
	level endon(#"hash_2dc546da");
	level.var_e18ab0f2 = 0;
	while(true)
	{
		level waittill(#"hash_7e0a837a");
		level.var_e18ab0f2--;
	}
}

/*
	Name: function_dd902934
	Namespace: zm_island_spider_quest
	Checksum: 0x1334D729
	Offset: 0x40E8
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function function_dd902934()
{
	level endon(#"spider_baby_round_timeout");
	level endon(#"spider_baby_round_done");
	while(true)
	{
		level waittill(#"hash_7e0a837a");
		if(level flag::get("spider_baby_hit_react"))
		{
			if(level.var_e18ab0f2 == 0)
			{
				level flag::set("spider_baby_round_done");
			}
		}
	}
}

/*
	Name: function_fb907799
	Namespace: zm_island_spider_quest
	Checksum: 0x427E05C
	Offset: 0x4170
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_fb907799(n_count)
{
	level endon(#"spider_baby_round_timeout");
	level endon(#"hash_c69c8ddc");
	var_d67f0d95 = 0;
	while(var_d67f0d95 != n_count)
	{
		level waittill(#"hash_7e0a837a");
		var_d67f0d95 = var_d67f0d95 + 1;
	}
	level flag::set("spider_baby_round_done");
}

/*
	Name: spider_baby_round_timeout
	Namespace: zm_island_spider_quest
	Checksum: 0x943CA725
	Offset: 0x41F8
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function spider_baby_round_timeout(n_count)
{
	level endon(#"spider_baby_round_done");
	if(n_count > 5)
	{
		wait(15);
	}
	else
	{
		wait(10);
	}
	level flag::set("spider_baby_round_timeout");
}

/*
	Name: function_3d4c345d
	Namespace: zm_island_spider_quest
	Checksum: 0x75B1024E
	Offset: 0x4258
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_3d4c345d()
{
	level endon(#"hash_2dc546da");
	var_c79d3f71 = zombie_utility::spawn_zombie(level.var_c38a4fee[0], "spider_baby", self);
	var_c79d3f71 thread function_5d1bd65f();
	var_c79d3f71.favoriteenemy = zm_ai_spiders::get_favorite_enemy();
	self thread zm_ai_spiders::function_49e57a3b(var_c79d3f71, self);
	var_c79d3f71 thread function_46c109d1();
	playsoundatposition("zmb_foley_squeen_birth_spider", self.origin);
	level.var_e18ab0f2++;
}

/*
	Name: function_5d1bd65f
	Namespace: zm_island_spider_quest
	Checksum: 0xB992EB78
	Offset: 0x4330
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function function_5d1bd65f()
{
	level endon(#"hash_2dc546da");
	self waittill(#"death");
	level notify(#"hash_7e0a837a");
}

/*
	Name: function_46c109d1
	Namespace: zm_island_spider_quest
	Checksum: 0xD949A390
	Offset: 0x4368
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_46c109d1()
{
	self waittill(#"death");
	if(!isdefined(level.var_ce29fb51))
	{
		level.var_ce29fb51 = 0;
	}
	if(!isdefined(level.var_511c2e79))
	{
		level.var_511c2e79 = 5;
	}
	if(randomint(100) < 20 && !level.var_ce29fb51 && level.var_511c2e79 > 0)
	{
		level thread function_81898ad7();
		level thread zm_powerups::specific_powerup_drop("full_ammo", self.origin);
	}
}

/*
	Name: function_81898ad7
	Namespace: zm_island_spider_quest
	Checksum: 0x63D36067
	Offset: 0x4428
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function function_81898ad7()
{
	level.var_ce29fb51 = 1;
	wait(25);
	level.var_ce29fb51 = 0;
	level.var_511c2e79--;
}

/*
	Name: function_2ff7183
	Namespace: zm_island_spider_quest
	Checksum: 0x16EF3013
	Offset: 0x4458
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function function_2ff7183()
{
	level endon(#"hash_2dc546da");
	trigger = getent("sndEnterLair", "targetname");
	if(!isdefined(trigger))
	{
		return;
	}
	while(true)
	{
		trigger waittill(#"trigger", who);
		if(isdefined(who) && isplayer(who))
		{
			if(zm_audio::sndmusicsystem_isabletoplay())
			{
				who playsoundtoplayer("mus_island_lair_entry_oneshot", who);
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_199d01b5
	Namespace: zm_island_spider_quest
	Checksum: 0x9BD8CB65
	Offset: 0x4528
	Size: 0x444
	Parameters: 0
	Flags: Linked
*/
function function_199d01b5()
{
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_a_1_3");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_a_1_4");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_a_2_3");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_a_3_1");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_a_4_2");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_b_1_4_2");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_b_2_3_1");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_b_3_1_4");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_b_3_4_2");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_b_4_1_3");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_c_1_3_4_2");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_c_2_3_1_4");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_c_3_1_2_4");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_c_4_1_3_2");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_phase_c_4_2_1_3");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_entrance");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_idle");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_intro");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_loop");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_outro");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_baby_drop_intro");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_baby_drop_loop");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_baby_drop_outro");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_backwall_idle");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_backwall_outro");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_pain_react_phase_1");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_pain_react_phase_2");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_arm_attack_pain_react_phase_3");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_baby_drop_pain_react_phase_1");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_baby_drop_pain_react_phase_2");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_baby_drop_pain_react_phase_3");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_attack_spit_straight");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_attack_spit_left");
	struct::delete_script_bundle("scene", "cin_t7_ai_zm_dlc2_spider_queen_attack_spit_right");
}

/*
	Name: function_4f46a12
	Namespace: zm_island_spider_quest
	Checksum: 0x4918DA50
	Offset: 0x4978
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_4f46a12()
{
	/#
		zm_devgui::add_custom_devgui_callback(&function_a4e9dacc);
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
	#/
}

/*
	Name: function_a4e9dacc
	Namespace: zm_island_spider_quest
	Checksum: 0x23312076
	Offset: 0x4A88
	Size: 0x1AC
	Parameters: 1
	Flags: Linked
*/
function function_a4e9dacc(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				level flag::set("");
				return true;
			}
			case "":
			{
				level.var_5bb615cd = level.var_dd315d9c;
				return true;
			}
			case "":
			{
				level.var_5bb615cd = level.var_f6f57e72;
				return true;
			}
			case "":
			{
				level notify(#"hash_9a8b82c3");
				level thread function_bd62f75b();
				return true;
			}
			case "":
			{
				level notify(#"hash_9a8b82c3");
				level thread function_31e22463();
				return true;
			}
			case "":
			{
				level notify(#"hash_9a8b82c3");
				level thread function_11d7e2b1();
				return true;
			}
			case "":
			{
				level notify(#"hash_9a8b82c3");
				level thread function_14f05ea8();
				return true;
			}
			case "":
			{
				level flag::set("");
				return true;
			}
			case "":
			{
				array::thread_all(level.players, &function_10abb15e);
				return true;
			}
		}
		return false;
	#/
}

/*
	Name: function_bd62f75b
	Namespace: zm_island_spider_quest
	Checksum: 0x2BA3CD53
	Offset: 0x4C40
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_bd62f75b()
{
	/#
		level endon(#"hash_2dc546da");
		level endon(#"hash_9a8b82c3");
		while(true)
		{
			function_f033c56a();
		}
	#/
}

/*
	Name: function_11d7e2b1
	Namespace: zm_island_spider_quest
	Checksum: 0x29AA6348
	Offset: 0x4C88
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_11d7e2b1()
{
	/#
		level endon(#"hash_2dc546da");
		level endon(#"hash_9a8b82c3");
		while(true)
		{
			function_3f6b6cb4();
		}
	#/
}

/*
	Name: function_31e22463
	Namespace: zm_island_spider_quest
	Checksum: 0xCB679E5E
	Offset: 0x4CD0
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_31e22463()
{
	/#
		level endon(#"hash_2dc546da");
		level endon(#"hash_9a8b82c3");
		while(true)
		{
			function_57b6770a();
		}
	#/
}

/*
	Name: function_14f05ea8
	Namespace: zm_island_spider_quest
	Checksum: 0x1313F2B9
	Offset: 0x4D18
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function function_14f05ea8()
{
	/#
		level endon(#"hash_2dc546da");
		level endon(#"hash_9a8b82c3");
		while(true)
		{
			function_f033c56a();
			function_3f6b6cb4();
			function_57b6770a();
		}
	#/
}

/*
	Name: function_10abb15e
	Namespace: zm_island_spider_quest
	Checksum: 0x54BC5ECE
	Offset: 0x4D80
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_10abb15e()
{
	/#
		e_weapon = getweapon("");
		self swap_weapon(e_weapon);
		wait(2);
		self upgrade_weapon();
		wait(2);
		self thread function_f77f0da9();
	#/
}

/*
	Name: swap_weapon
	Namespace: zm_island_spider_quest
	Checksum: 0x3F8E138E
	Offset: 0x4E08
	Size: 0x154
	Parameters: 1
	Flags: Linked
*/
function swap_weapon(wpn_new)
{
	/#
		wpn_current = self getcurrentweapon();
		if(!zm_utility::is_player_valid(self))
		{
			return;
		}
		if(self.is_drinking > 0)
		{
			return;
		}
		if(zm_utility::is_placeable_mine(wpn_current) || zm_equipment::is_equipment(wpn_current) || wpn_current == level.weaponnone)
		{
			return;
		}
		if(!self hasweapon(wpn_new.rootweapon, 1))
		{
			if(wpn_new.type === "")
			{
				self function_3420bc2f(wpn_new);
			}
			else
			{
				self take_old_weapon_and_give_new(wpn_current, wpn_new);
			}
		}
		else
		{
			self givemaxammo(wpn_new);
		}
		self switchtoweaponimmediate(wpn_new);
	#/
}

/*
	Name: take_old_weapon_and_give_new
	Namespace: zm_island_spider_quest
	Checksum: 0x18824C74
	Offset: 0x4F68
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function take_old_weapon_and_give_new(current_weapon, weapon)
{
	/#
		a_weapons = self getweaponslistprimaries();
		if(isdefined(a_weapons) && a_weapons.size >= zm_utility::get_player_weapon_limit(self))
		{
			self takeweapon(current_weapon);
		}
		var_7b9ca68 = self zm_weapons::give_build_kit_weapon(weapon);
		self giveweapon(var_7b9ca68);
		self switchtoweapon(var_7b9ca68);
	#/
}

/*
	Name: function_3420bc2f
	Namespace: zm_island_spider_quest
	Checksum: 0x27880C63
	Offset: 0x5048
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function function_3420bc2f(wpn_new)
{
	/#
		var_c5716cdc = self getweaponslist(1);
		foreach(weapon in var_c5716cdc)
		{
			if(weapon.type === "")
			{
				self takeweapon(weapon);
				break;
			}
		}
		var_7b9ca68 = self zm_weapons::give_build_kit_weapon(wpn_new);
		self giveweapon(var_7b9ca68);
	#/
}

/*
	Name: upgrade_weapon
	Namespace: zm_island_spider_quest
	Checksum: 0x8B9C4D7A
	Offset: 0x5170
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function upgrade_weapon()
{
	/#
		var_1d94ca2b = self getcurrentweapon();
		var_a08320d8 = self getweaponammoclip(var_1d94ca2b);
		var_7298c138 = self getweaponammostock(var_1d94ca2b);
		var_19dc14f6 = zm_weapons::get_upgrade_weapon(var_1d94ca2b);
		var_19dc14f6 = self zm_weapons::give_build_kit_weapon(var_19dc14f6);
		self givestartammo(var_19dc14f6);
		self switchtoweaponimmediate(var_19dc14f6);
		self takeweapon(var_1d94ca2b, 1);
	#/
}

/*
	Name: function_f77f0da9
	Namespace: zm_island_spider_quest
	Checksum: 0x4232F756
	Offset: 0x5288
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_f77f0da9()
{
	/#
		self endon(#"disconnect");
		var_6c9b76cd = self zm_perks::perk_give_bottle_begin("");
		str_notify = self util::waittill_any_return("", "", "", "", "");
		if(str_notify == "")
		{
			self thread zm_perks::wait_give_perk("", 1);
		}
		self zm_perks::perk_give_bottle_end(var_6c9b76cd, "");
	#/
}

/*
	Name: function_bccbf63c
	Namespace: zm_island_spider_quest
	Checksum: 0x1FEB6D6E
	Offset: 0x5368
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_bccbf63c()
{
	level.var_86ceb983 = struct::get("s_utrig_spiderqueen_free_ww", "targetname");
	level.var_86ceb983 zm_unitrigger::create_unitrigger(&"ZM_ISLAND_SPIDER_QUEEN_WINE", 96, &function_65f4b50, &function_3039a61d);
}

/*
	Name: function_65f4b50
	Namespace: zm_island_spider_quest
	Checksum: 0x592199D1
	Offset: 0x53E0
	Size: 0x108
	Parameters: 1
	Flags: Linked
*/
function function_65f4b50(player)
{
	if(player hasperk("specialty_widowswine"))
	{
		self sethintstring("");
		player zm_audio::create_and_play_dialog("general", "sigh");
		return false;
	}
	if(!player zm_utility::can_player_purchase_perk())
	{
		self sethintstring("");
		player zm_audio::create_and_play_dialog("general", "sigh");
		return false;
	}
	self sethintstring(&"ZM_ISLAND_SPIDER_QUEEN_WINE");
	return true;
}

/*
	Name: function_3039a61d
	Namespace: zm_island_spider_quest
	Checksum: 0xF108FFDB
	Offset: 0x54F8
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function function_3039a61d()
{
	while(true)
	{
		self waittill(#"trigger", player);
		if(zm_utility::is_player_valid(player))
		{
			player thread function_25762e4();
			player notify(#"hash_6c020c33");
			player notify(#"perk_purchased", "specialty_widowswine");
		}
		wait(60);
	}
}

/*
	Name: function_25762e4
	Namespace: zm_island_spider_quest
	Checksum: 0x7D5A283
	Offset: 0x5588
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function function_25762e4()
{
	self endon(#"disconnect");
	if(!(isdefined(self.var_9b95533e) && self.var_9b95533e))
	{
		self.var_9b95533e = 1;
		var_6c9b76cd = self zm_perks::perk_give_bottle_begin("specialty_widowswine");
		str_notify = self util::waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete", "disconnect");
		if(str_notify == "weapon_change_complete")
		{
			self thread zm_perks::wait_give_perk("specialty_widowswine", 1);
		}
		self zm_perks::perk_give_bottle_end(var_6c9b76cd, "specialty_widowswine");
		wait(15);
		self.var_9b95533e = 0;
	}
}

