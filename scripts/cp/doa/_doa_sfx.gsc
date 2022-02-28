// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\doa\_doa_gibs;
#using scripts\cp\doa\_doa_utility;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\util_shared;

#namespace namespace_1a381543;

/*
	Name: init
	Namespace: namespace_1a381543
	Checksum: 0xE87EEA7B
	Offset: 0xA18
	Size: 0xE64
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
	function_ce931b57("zmb_pwup_barrel_loop", 44);
	function_ce931b57("zmb_pwup_barrel_end", 45);
	function_ce931b57("zmb_pwup_barrel_fall_0", 46);
	function_ce931b57("zmb_pwup_barrel_fall_1", 46);
	function_ce931b57("zmb_pwup_bear_stun", 48);
	function_ce931b57("zmb_pwup_bear_end", 49);
	function_ce931b57("zmb_pwup_blade_impact", 50);
	function_ce931b57("zmb_pwup_blade_end", 51);
	function_ce931b57("zmb_pwup_blade_fall_0", 52);
	function_ce931b57("zmb_pwup_magnet_end", 53);
	function_ce931b57("zmb_pwup_magnet_loop", 54);
	function_ce931b57("zmb_pwup_bear_loop", 55);
	function_ce931b57("zmb_pwup_blade_loop", 56);
	function_ce931b57("zmb_pwup_speed_loop", 57);
	function_ce931b57("zmb_pwup_slow_speed_loop", 58);
	function_ce931b57("zmb_player_poisoned", 70);
	function_ce931b57("zmb_pickup_life_shimmer", 59);
	function_ce931b57("zmb_pwup_coco_loop", 60);
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
	Checksum: 0x334835C5
	Offset: 0x1888
	Size: 0x7E
	Parameters: 2
	Flags: Linked
*/
function function_ce931b57(name, type)
{
	/#
		assert(type < 128, "");
	#/
	if(!isdefined(level.doa.var_4a6df8b3))
	{
		level.doa.var_4a6df8b3 = [];
	}
	level.doa.var_4a6df8b3[name] = type;
}

/*
	Name: function_7ad8eb52
	Namespace: namespace_1a381543
	Checksum: 0x67DBBB33
	Offset: 0x1910
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function function_7ad8eb52(name)
{
	/#
		assert(isdefined(level.doa.var_4a6df8b3[name]), "");
	#/
	return level.doa.var_4a6df8b3[name];
}

/*
	Name: function_9ab759da
	Namespace: namespace_1a381543
	Checksum: 0xABEC4B68
	Offset: 0x1970
	Size: 0x1FC
	Parameters: 3
	Flags: Linked
*/
function function_9ab759da(&queue, flag, var_a6cc22d4 = 0)
{
	self endon(#"death");
	if(!var_a6cc22d4)
	{
		self notify("sfxProcessQueue_" + flag);
		self endon("sfxProcessQueue_" + flag);
	}
	if(queue.size >= 64)
	{
		/#
			foreach(item in queue)
			{
				doa_utility::debugmsg("" + item);
			}
		#/
		/#
			assert(0, "" + queue[63]);
		#/
	}
	if(queue.size == 0)
	{
		self notify(#"hash_99963757");
		return;
	}
	var_1a41b083 = function_7ad8eb52(queue[0]);
	arrayremoveindex(queue, 0, 0);
	self clientfield::set(flag, var_1a41b083);
	util::wait_network_frame();
	self clientfield::set(flag, 0);
	self function_9ab759da(queue, flag, 1);
}

/*
	Name: function_4f06fb8
	Namespace: namespace_1a381543
	Checksum: 0xD5E62182
	Offset: 0x1B78
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function function_4f06fb8(name)
{
	if(!isdefined(name) || !isdefined(self))
	{
		return;
	}
	self notify(#"hash_89ed98");
	self endon(#"hash_89ed98");
	self endon(#"death");
	if(!isdefined(self.var_14f92b68))
	{
		self.var_14f92b68 = [];
	}
	self.var_14f92b68[self.var_14f92b68.size] = name;
	self function_9ab759da(self.var_14f92b68, "off_sfx");
	level notify(#"hash_f0851749");
}

/*
	Name: function_90118d8c
	Namespace: namespace_1a381543
	Checksum: 0x12D08646
	Offset: 0x1C30
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_90118d8c(name)
{
	if(!isdefined(name) || !isdefined(self))
	{
		return;
	}
	self notify(#"hash_42bd4d44");
	self endon(#"hash_42bd4d44");
	self endon(#"death");
	if(!isdefined(self.var_60026b2))
	{
		self.var_60026b2 = [];
	}
	self.var_60026b2[self.var_60026b2.size] = name;
	self function_9ab759da(self.var_60026b2, "play_sfx");
}

