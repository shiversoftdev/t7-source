// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\fx_shared;
#using scripts\shared\util_shared;

#namespace namespace_1a381543;

/*
	Name: init
	Namespace: namespace_1a381543
	Checksum: 0x9AC20445
	Offset: 0x998
	Size: 0xE6C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	function_ce931b57("zmb_pickup_nurgle", 1);
	function_ce931b57("zmb_pickup_money", 2);
	function_ce931b57("zmb_pickup_weapon", 3);
	function_ce931b57("zmb_pickup_powerup", 4);
	function_ce931b57("zmb_pickup_generic", 5);
	function_ce931b57("zmb_pickup_life", 6);
	function_ce931b57("zmb_pickup_boots", 7);
	function_ce931b57("zmb_pickup_ammo", 8);
	function_ce931b57("zmb_pickup_chicken", 9);
	function_ce931b57("zmb_pickup_vortex", 10);
	function_ce931b57("zmb_pickup_umbrella", 11);
	function_ce931b57("zmb_spawn_pickup_money", 12);
	function_ce931b57("zmb_teleporter_spawn", 13);
	function_ce931b57("zmb_teleporter_tele_out", 14);
	function_ce931b57("zmb_dblshot_squawk", 15);
	function_ce931b57("zmb_dblshot_end", 16);
	function_ce931b57("zmb_dblshot_wingflap", 18);
	function_ce931b57("zmb_dblshot_death", 17);
	function_ce931b57("zmb_explode", 19);
	function_ce931b57("zmb_egg_hatch", 20);
	function_ce931b57("zmb_simianaut_roar", 21);
	function_ce931b57("zmb_boss_shield_death", 23);
	function_ce931b57("zmb_boss_shield_damage", 22);
	function_ce931b57("zmb_stoneboss_died", 24);
	function_ce931b57("zmb_boss_sound_minion_summon", 25);
	function_ce931b57("zmb_ragdoll_launched", 26);
	function_ce931b57("zmb_hazard_water_death", 27);
	function_ce931b57("zmb_hazard_hit", 28);
	function_ce931b57("exp_barrel_explo", 29);
	function_ce931b57("zmb_timeshift_slowdown", 30);
	function_ce931b57("zmb_monkey_explo", 31);
	function_ce931b57("zmb_player_shield_half", 32);
	function_ce931b57("zmb_player_shield_full", 33);
	function_ce931b57("zmb_player_shield_half", 34);
	function_ce931b57("zmb_player_shield_end", 35);
	function_ce931b57("zmb_pwup_speed_end", 36);
	function_ce931b57("zmb_pwup_slow_speed_end", 37);
	function_ce931b57("zmb_speed_boost_activate", 38);
	function_ce931b57("zmb_weapon_upgraded", 39);
	function_ce931b57("zmb_weapon_downgraded", 40);
	function_ce931b57("zmb_player_death", 41);
	function_ce931b57("zmb_player_respawn", 42);
	function_ce931b57("zmb_pwup_barrel_impact", 43);
	function_ce931b57("zmb_pwup_barrel_loop", 44, 1);
	function_ce931b57("zmb_pwup_barrel_end", 45);
	function_ce931b57("zmb_pwup_barrel_fall_0", 46);
	function_ce931b57("zmb_pwup_barrel_fall_1", 46);
	function_ce931b57("zmb_pwup_bear_stun", 48);
	function_ce931b57("zmb_pwup_bear_ebd", 49);
	function_ce931b57("zmb_pwup_blade_impact", 50);
	function_ce931b57("zmb_pwup_blade_end", 51);
	function_ce931b57("zmb_pwup_blade_fall_0", 52);
	function_ce931b57("zmb_pwup_magnet_end", 53);
	function_ce931b57("zmb_pwup_magnet_loop", 54, 1);
	function_ce931b57("zmb_pwup_bear_loop", 55, 1, 1.5);
	function_ce931b57("zmb_pwup_blade_loop", 56, 1);
	function_ce931b57("zmb_pwup_speed_loop", 57, 1);
	function_ce931b57("zmb_pwup_slow_speed_loop", 58, 1);
	function_ce931b57("zmb_player_poisoned", 70);
	function_ce931b57("zmb_pickup_life_shimmer", 59, 1);
	function_ce931b57("zmb_pwup_coco_loop", 60, 1);
	function_ce931b57("zmb_pwup_coco_impact", 61);
	function_ce931b57("zmb_pwup_coco_bounce", 62);
	function_ce931b57("zmb_pwup_coco_end", 63);
	function_ce931b57("evt_turret_incoming", 64);
	function_ce931b57("evt_turret_land", 65);
	function_ce931b57("evt_turret_takeoff", 66);
	function_ce931b57("evt_sprinkler_incoming", 67);
	function_ce931b57("evt_sprinkler_land", 86);
	function_ce931b57("evt_sprinkler_takeoff", 87);
	function_ce931b57("evt_amws_incoming", 68);
	function_ce931b57("evt_amws_leaving", 69);
	function_ce931b57("zmb_stoneboss_damaged", 71);
	function_ce931b57("evt_robot_land", 72);
	function_ce931b57("wpn_incendiary_explode", 73);
	function_ce931b57("gdt_immolation_robot_countdown", 74);
	function_ce931b57("evt_skel_rise", 75);
	function_ce931b57("evt_skel_attack", 76);
	function_ce931b57("zmb_nuke_impact", 77);
	function_ce931b57("zmb_pwup_clock_start", 78);
	function_ce931b57("zmb_pwup_clock_end", 79);
	function_ce931b57("zmb_pwup_boxing_start", 80);
	function_ce931b57("zmb_pwup_boxing_punch", 81);
	function_ce931b57("zmb_pwup_boxing_end", 82);
	function_ce931b57("zmb_fate_rock_spawn", 83);
	function_ce931b57("zmb_fate_rock_imp", 84);
	function_ce931b57("zmb_fate_choose", 85);
	function_ce931b57("zmb_heart_pickup", 88);
	function_ce931b57("zmb_pickup_spawn", 89);
	function_ce931b57("zmb_enemy_incoming", 90);
	function_ce931b57("zmb_enemy_impact", 91);
	function_ce931b57("zmb_enemy_smokeman_wings", 92);
	function_ce931b57("zmb_enemy_smokeman_poof", 93);
	function_ce931b57("zmb_end_1stplace_1", 94);
	function_ce931b57("zmb_end_1stplace_2", 95);
	function_ce931b57("zmb_end_1stplace_3", 96);
	function_ce931b57("zmb_end_1stplace_4", 97);
	function_ce931b57("zmb_end_2ndplace_1", 98);
	function_ce931b57("zmb_end_2ndplace_2", 99);
	function_ce931b57("zmb_end_2ndplace_3", 100);
	function_ce931b57("zmb_end_3rdplace_1", 101);
	function_ce931b57("zmb_end_3rdplace_2", 102);
	function_ce931b57("zmb_end_3rdplace_3", 103);
	function_ce931b57("zmb_end_4thplace_1", 104);
	function_ce931b57("zmb_end_4thplace_2", 105);
	function_ce931b57("zmb_egg_shake", 106);
	function_ce931b57("zmb_golden_chicken_grow", 107);
	function_ce931b57("zmb_golden_chicken_pop", 108);
	function_ce931b57("zmb_golden_chicken_dance", 109);
	function_ce931b57("zmb_gem_quieter", 110);
	function_ce931b57("zmb_eggbowl_goal", 111);
	function_ce931b57("zmb_eggbowl_whistle", 112);
	function_ce931b57("zmb_army_skeleton", 113);
	function_ce931b57("zmb_army_robot", 114);
	function_ce931b57("zmb_coat_of_arms", 115);
}

/*
	Name: function_ce931b57
	Namespace: namespace_1a381543
	Checksum: 0x7EDE1AD5
	Offset: 0x1810
	Size: 0xF6
	Parameters: 4
	Flags: Linked
*/
function function_ce931b57(name, type, looping = 0, fadeout = 0.5)
{
	/#
		assert(type < 128, "");
	#/
	if(!isdefined(level.var_4a6df8b3))
	{
		level.var_4a6df8b3 = [];
	}
	sfx = spawnstruct();
	sfx.name = name;
	sfx.looping = looping;
	sfx.fadeout = fadeout;
	level.var_4a6df8b3[type] = sfx;
}

/*
	Name: function_736ce6da
	Namespace: namespace_1a381543
	Checksum: 0x6B6E0717
	Offset: 0x1910
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function function_736ce6da(type)
{
	/#
		assert(isdefined(level.var_4a6df8b3[type]), "");
	#/
	return level.var_4a6df8b3[type].name;
}

/*
	Name: function_72f9305c
	Namespace: namespace_1a381543
	Checksum: 0xA66AF5E6
	Offset: 0x1970
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function function_72f9305c(type)
{
	/#
		assert(isdefined(level.var_4a6df8b3[type]), "");
	#/
	return level.var_4a6df8b3[type].looping;
}

/*
	Name: function_229b9d9e
	Namespace: namespace_1a381543
	Checksum: 0x854DAEA2
	Offset: 0x19D0
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function function_229b9d9e(type)
{
	/#
		assert(isdefined(level.var_4a6df8b3[type]), "");
	#/
	return level.var_4a6df8b3[type].fadeout;
}

/*
	Name: function_1f085aea
	Namespace: namespace_1a381543
	Checksum: 0xB5693108
	Offset: 0x1A30
	Size: 0x16E
	Parameters: 3
	Flags: Linked
*/
function function_1f085aea(localclientnum, type, off)
{
	if(localclientnum != 0)
	{
		return;
	}
	self endon(#"entityshutdown");
	while(!clienthassnapshot(localclientnum))
	{
		wait(0.016);
	}
	while(!self hasdobj(localclientnum))
	{
		wait(0.016);
	}
	looping = function_72f9305c(type);
	alias = function_736ce6da(type);
	if(!off)
	{
		if(!looping)
		{
			self playsound(localclientnum, alias);
		}
		else
		{
			self.var_7aa99fd0 = self playloopsound(alias);
		}
	}
	else if(looping && isdefined(self.var_7aa99fd0))
	{
		self stoploopsound(self.var_7aa99fd0, function_229b9d9e(type));
		self.var_7aa99fd0 = undefined;
	}
}

