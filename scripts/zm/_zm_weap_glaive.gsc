// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\throttle_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_glaive;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weapons;

#namespace zm_weap_glaive;

/*
	Name: __init__sytem__
	Namespace: zm_weap_glaive
	Checksum: 0xC756E12B
	Offset: 0x700
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_glaive", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_glaive
	Checksum: 0x6E9D7651
	Offset: 0x740
	Size: 0x424
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("allplayers", "slam_fx", 1, 1, "counter");
	clientfield::register("toplayer", "throw_fx", 1, 1, "counter");
	clientfield::register("toplayer", "swipe_fx", 1, 1, "counter");
	clientfield::register("toplayer", "swipe_lv2_fx", 1, 1, "counter");
	clientfield::register("actor", "zombie_slice_r", 1, 2, "counter");
	clientfield::register("actor", "zombie_slice_l", 1, 2, "counter");
	level._effect["glaive_blood_spurt"] = "impacts/fx_flesh_hit_knife_lg_zmb";
	level.glaive_excalibur_aoe_range = 240;
	level.glaive_excalibur_aoe_range_sq = level.glaive_excalibur_aoe_range * level.glaive_excalibur_aoe_range;
	level.glaive_excalibur_cone_range = 100;
	level.glaive_excalibur_cone_range_sq = level.glaive_excalibur_cone_range * level.glaive_excalibur_cone_range;
	level.glaive_chop_cone_range = 120;
	level.glaive_chop_cone_range_sq = level.glaive_chop_cone_range * level.glaive_chop_cone_range;
	level.var_3e0110d = 160;
	level.var_42894cb8 = level.var_3e0110d * level.var_3e0110d;
	callback::on_connect(&watch_sword_equipped);
	for(i = 0; i < 4; i++)
	{
		zombie_utility::add_zombie_gib_weapon_callback(("glaive_apothicon" + "_") + i, &gib_check, &gib_head_check);
		zombie_utility::add_zombie_gib_weapon_callback(("glaive_keeper" + "_") + i, &gib_check, &gib_head_check);
		zm_hero_weapon::register_hero_weapon(("glaive_apothicon" + "_") + i);
		zm_hero_weapon::register_hero_weapon(("glaive_keeper" + "_") + i);
		zm_hero_weapon::register_hero_recharge_event(getweapon(("glaive_apothicon" + "_") + i), &function_4a948f8a);
		zm_hero_weapon::register_hero_recharge_event(getweapon(("glaive_keeper" + "_") + i), &function_4a948f8a);
	}
	level.glaive_damage_locations = array("left_arm_upper", "left_arm_lower", "left_hand", "right_arm_upper", "right_arm_lower", "right_hand");
	level thread function_e97f78f0();
	level.var_b31b9421 = new throttle();
	[[ level.var_b31b9421 ]]->initialize(6, 0.1);
}

/*
	Name: get_correct_sword_for_player_character_at_level
	Namespace: zm_weap_glaive
	Checksum: 0x5C4CC332
	Offset: 0xB70
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function get_correct_sword_for_player_character_at_level(n_upgrade_level)
{
	str_wpnname = undefined;
	if(n_upgrade_level == 1)
	{
		str_wpnname = "glaive_apothicon";
	}
	else
	{
		str_wpnname = "glaive_keeper";
	}
	str_wpnname = (str_wpnname + "_") + self.characterindex;
	wpn = getweapon(str_wpnname);
	return wpn;
}

/*
	Name: function_3f820ba7
	Namespace: zm_weap_glaive
	Checksum: 0xFD497DEF
	Offset: 0xC08
	Size: 0xD8
	Parameters: 1
	Flags: Linked
*/
function function_3f820ba7(var_9fd9c680)
{
	self endon(#"hash_b29853d8");
	while(isdefined(self))
	{
		self waittill(#"weapon_change", wpn_cur, wpn_prev);
		if(wpn_cur != level.weaponnone && wpn_cur != var_9fd9c680)
		{
			self.usingsword = 0;
			if(self.autokill_glaive_active)
			{
				self enableoffhandweapons();
				self thread function_762ff0b6(var_9fd9c680);
				self waittill(#"hash_8a993396");
			}
			self disabled_sword();
			self notify(#"hash_b29853d8");
			return;
		}
	}
}

/*
	Name: function_762ff0b6
	Namespace: zm_weap_glaive
	Checksum: 0x56BD8EDF
	Offset: 0xCE8
	Size: 0xD8
	Parameters: 1
	Flags: Linked
*/
function function_762ff0b6(wpn_prev)
{
	self endon(#"hash_8a993396");
	oldtime = gettime();
	while(isdefined(self) && (isdefined(self.autokill_glaive_active) && self.autokill_glaive_active))
	{
		rate = 1.667;
		if(isdefined(wpn_prev.gadget_power_usage_rate))
		{
			rate = wpn_prev.gadget_power_usage_rate;
		}
		self.sword_power = self.sword_power - (0.0005 * rate);
		self gadgetpowerset(0, self.sword_power * 100);
		wait(0.05);
	}
}

/*
	Name: function_50cf29d
	Namespace: zm_weap_glaive
	Checksum: 0x2844E7FF
	Offset: 0xDC8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_50cf29d(evt)
{
	self playrumbleonentity("lightninggun_charge");
}

/*
	Name: function_5c998ffc
	Namespace: zm_weap_glaive
	Checksum: 0x9894F53A
	Offset: 0xE00
	Size: 0x42C
	Parameters: 4
	Flags: Linked
*/
function function_5c998ffc(wpn_excalibur, wpn_autokill, wpn_cur, wpn_prev)
{
	if(self.sword_allowed && !self.usingsword)
	{
		if(wpn_cur == wpn_autokill)
		{
			self.current_sword = wpn_autokill;
			self.var_2ef815cf = 0;
			self disableoffhandweapons();
			self notify(#"altbody_end");
			self thread function_3f820ba7(wpn_cur);
			if(!(isdefined(self.usingsword) && self.usingsword))
			{
				self gadgetpowerset(0, 100);
				self clientfield::set_player_uimodel("zmhud.swordEnergy", 1);
				self clientfield::set_player_uimodel("zmhud.swordState", 2);
				self.sword_power = 1;
			}
			self notify(#"hash_b74ad0fb");
			self thread function_50cf29d("lv2start");
			self.usingsword = 1;
			self.autokill_glaive_active = 0;
			slot = self gadgetgetslot(wpn_autokill);
			self thread sword_power_hud(slot);
			self thread arc_attack_think(wpn_cur, 1);
			self thread autokill_think(wpn_autokill);
			self waittill(#"hash_b29853d8");
			self enableoffhandweapons();
			self allowmeleepowerleft(1);
			self.usingsword = 0;
			self disabled_sword();
		}
		else if(wpn_cur == wpn_excalibur)
		{
			self.current_sword = wpn_excalibur;
			self.var_2ef815cf = 1;
			self disableoffhandweapons();
			self notify(#"altbody_end");
			self thread function_3f820ba7(wpn_cur);
			if(!(isdefined(self.usingsword) && self.usingsword))
			{
				self gadgetpowerset(0, 100);
				self clientfield::set_player_uimodel("zmhud.swordEnergy", 1);
				self clientfield::set_player_uimodel("zmhud.swordState", 6);
				self.sword_power = 1;
			}
			self notify(#"hash_b74ad0fb");
			self thread function_50cf29d("lv1start");
			self.usingsword = 1;
			self.autokill_glaive_active = 0;
			slot = self gadgetgetslot(wpn_excalibur);
			self thread sword_power_hud(slot);
			self thread arc_attack_think(wpn_excalibur, 0);
			self thread excalibur_think(wpn_excalibur);
			self waittill(#"hash_b29853d8");
			self enableoffhandweapons();
			self allowmeleepowerleft(1);
			self.usingsword = 0;
			self disabled_sword();
		}
	}
}

/*
	Name: watch_sword_equipped
	Namespace: zm_weap_glaive
	Checksum: 0xD89FBDF
	Offset: 0x1238
	Size: 0xC8
	Parameters: 0
	Flags: Linked, Private
*/
function private watch_sword_equipped()
{
	self endon(#"disconnect");
	wpn_excalibur = self get_correct_sword_for_player_character_at_level(1);
	wpn_autokill = self get_correct_sword_for_player_character_at_level(2);
	self.sword_allowed = 1;
	self.usingsword = 0;
	while(true)
	{
		self waittill(#"weapon_change", wpn_cur, wpn_prev);
		self function_5c998ffc(wpn_excalibur, wpn_autokill, wpn_cur, wpn_prev);
	}
}

/*
	Name: gib_check
	Namespace: zm_weap_glaive
	Checksum: 0xBFBC337B
	Offset: 0x1308
	Size: 0x44
	Parameters: 1
	Flags: Linked, Private
*/
function private gib_check(damage_percent)
{
	self.override_damagelocation = "none";
	if(damage_percent > 99.8)
	{
		self.override_damagelocation = "neck";
		return true;
	}
	return false;
}

/*
	Name: gib_head_check
	Namespace: zm_weap_glaive
	Checksum: 0x437463AF
	Offset: 0x1358
	Size: 0x7C
	Parameters: 1
	Flags: Linked, Private
*/
function private gib_head_check(damage_location)
{
	if(self.override_damagelocation === "neck")
	{
		return true;
	}
	if(!isdefined(damage_location))
	{
		return false;
	}
	if(damage_location == "head")
	{
		return true;
	}
	if(damage_location == "helmet")
	{
		return true;
	}
	if(damage_location == "neck")
	{
		return true;
	}
	return false;
}

/*
	Name: excalibur_think
	Namespace: zm_weap_glaive
	Checksum: 0x584DF384
	Offset: 0x13E0
	Size: 0x98
	Parameters: 1
	Flags: Linked, Private
*/
function private excalibur_think(wpn_excalibur)
{
	self endon(#"hash_b29853d8");
	self endon(#"disconnect");
	self endon(#"bled_out");
	while(true)
	{
		self waittill(#"weapon_melee_power_left", weapon);
		if(weapon == wpn_excalibur)
		{
			self clientfield::increment("slam_fx");
			self thread do_excalibur(wpn_excalibur);
		}
	}
}

/*
	Name: do_excalibur
	Namespace: zm_weap_glaive
	Checksum: 0x725BDACF
	Offset: 0x1480
	Size: 0x2C2
	Parameters: 1
	Flags: Linked, Private
*/
function private do_excalibur(wpn_excalibur)
{
	view_pos = self getweaponmuzzlepoint();
	forward_view_angles = self getweaponforwarddir();
	zombie_list = getaiteamarray(level.zombie_team);
	foreach(ai in zombie_list)
	{
		if(!isdefined(ai) || !isalive(ai))
		{
			continue;
		}
		test_origin = ai getcentroid();
		dist_sq = distancesquared(view_pos, test_origin);
		if(dist_sq < level.glaive_excalibur_aoe_range_sq)
		{
			if(isdefined(ai.var_a3b60c68))
			{
				self thread [[ai.var_a3b60c68]](ai, wpn_excalibur);
			}
			else
			{
				self thread electrocute_actor(ai, wpn_excalibur);
			}
			continue;
		}
		if(dist_sq > level.glaive_excalibur_cone_range_sq)
		{
			continue;
		}
		normal = vectornormalize(test_origin - view_pos);
		dot = vectordot(forward_view_angles, normal);
		if(0.707 > dot)
		{
			continue;
		}
		if(0 == ai damageconetrace(view_pos, self))
		{
			continue;
		}
		if(isdefined(ai.var_a3b60c68))
		{
			self thread [[ai.var_a3b60c68]](ai, wpn_excalibur);
			continue;
		}
		self thread electrocute_actor(ai, wpn_excalibur);
	}
}

/*
	Name: electrocute_actor
	Namespace: zm_weap_glaive
	Checksum: 0xC02AAF17
	Offset: 0x1750
	Size: 0xE4
	Parameters: 2
	Flags: Linked
*/
function electrocute_actor(ai, wpn_excalibur)
{
	self endon(#"disconnect");
	if(!isdefined(ai) || !isalive(ai))
	{
		return;
	}
	if(!isdefined(self.tesla_enemies_hit))
	{
		self.tesla_enemies_hit = 1;
	}
	ai notify(#"bhtn_action_notify", "electrocute");
	function_72ca5a88();
	ai.tesla_death = 0;
	ai thread arc_damage_init(ai.origin, ai.origin, self);
	ai thread tesla_death(self);
}

/*
	Name: function_72ca5a88
	Namespace: zm_weap_glaive
	Checksum: 0x22B7069F
	Offset: 0x1840
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function function_72ca5a88()
{
	level.var_ba84a05b = lightning_chain::create_lightning_chain_params(1);
	level.var_ba84a05b.head_gib_chance = 100;
	level.var_ba84a05b.network_death_choke = 4;
	level.var_ba84a05b.should_kill_enemies = 0;
}

/*
	Name: tesla_death
	Namespace: zm_weap_glaive
	Checksum: 0x3B880FCF
	Offset: 0x18A8
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function tesla_death(player)
{
	self endon(#"death");
	self thread function_862aadab(1);
	wait(2);
	player thread zm_audio::create_and_play_dialog("kill", "sword_slam");
	self dodamage(self.health + 1, self.origin);
}

/*
	Name: arc_damage_init
	Namespace: zm_weap_glaive
	Checksum: 0xA990EBBD
	Offset: 0x1930
	Size: 0x64
	Parameters: 3
	Flags: Linked
*/
function arc_damage_init(hit_location, hit_origin, player)
{
	player endon(#"disconnect");
	if(isdefined(self.zombie_tesla_hit) && self.zombie_tesla_hit)
	{
		return;
	}
	self lightning_chain::arc_damage_ent(player, 1, level.var_ba84a05b);
}

/*
	Name: chop_actor
	Namespace: zm_weap_glaive
	Checksum: 0x755B2ED3
	Offset: 0x19A0
	Size: 0x1B4
	Parameters: 4
	Flags: Linked
*/
function chop_actor(ai, upgraded, leftswing, weapon = level.weaponnone)
{
	self endon(#"disconnect");
	if(!isdefined(ai) || !isalive(ai))
	{
		return;
	}
	if(isdefined(upgraded) && upgraded)
	{
		if(9317 >= ai.health)
		{
			ai.ignoremelee = 1;
		}
		[[ level.var_b31b9421 ]]->waitinqueue(ai);
		ai dodamage(9317, self.origin, self, self, "none", "MOD_UNKNOWN", 0, weapon);
	}
	else
	{
		if(3594 >= ai.health)
		{
			ai.ignoremelee = 1;
		}
		[[ level.var_b31b9421 ]]->waitinqueue(ai);
		ai dodamage(3594, self.origin, self, self, "none", "MOD_UNKNOWN", 0, weapon);
	}
	ai blood_death_fx(leftswing, upgraded);
	util::wait_network_frame();
}

/*
	Name: function_862aadab
	Namespace: zm_weap_glaive
	Checksum: 0x38E1D52D
	Offset: 0x1B60
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function function_862aadab(random_gibs)
{
	if(isdefined(self) && isactor(self))
	{
		if(!random_gibs || randomint(100) < 50)
		{
			gibserverutils::gibhead(self);
		}
		if(!random_gibs || randomint(100) < 50)
		{
			gibserverutils::gibleftarm(self);
		}
		if(!random_gibs || randomint(100) < 50)
		{
			gibserverutils::gibrightarm(self);
		}
		if(!random_gibs || randomint(100) < 50)
		{
			gibserverutils::giblegs(self);
		}
	}
}

/*
	Name: blood_death_fx
	Namespace: zm_weap_glaive
	Checksum: 0xF706AECF
	Offset: 0x1C98
	Size: 0xEC
	Parameters: 2
	Flags: Linked, Private
*/
function private blood_death_fx(var_d98455ab, var_26ba0d4c)
{
	if(self.archetype == "zombie")
	{
		if(var_d98455ab)
		{
			if(isdefined(var_26ba0d4c) && var_26ba0d4c)
			{
				self clientfield::increment("zombie_slice_l", 2);
			}
			else
			{
				self clientfield::increment("zombie_slice_l", 1);
			}
		}
		else
		{
			if(isdefined(var_26ba0d4c) && var_26ba0d4c)
			{
				self clientfield::increment("zombie_slice_r", 2);
			}
			else
			{
				self clientfield::increment("zombie_slice_r", 1);
			}
		}
	}
}

/*
	Name: chop_zombies
	Namespace: zm_weap_glaive
	Checksum: 0x8E742C1C
	Offset: 0x1D90
	Size: 0x30A
	Parameters: 4
	Flags: Linked
*/
function chop_zombies(first_time, var_10ee11e, leftswing, weapon = level.weaponnone)
{
	view_pos = self getweaponmuzzlepoint();
	forward_view_angles = self getweaponforwarddir();
	zombie_list = getaiteamarray(level.zombie_team);
	foreach(ai in zombie_list)
	{
		if(!isdefined(ai) || !isalive(ai))
		{
			continue;
		}
		if(first_time)
		{
			ai.chopped = 0;
		}
		else if(isdefined(ai.chopped) && ai.chopped)
		{
			continue;
		}
		test_origin = ai getcentroid();
		dist_sq = distancesquared(view_pos, test_origin);
		dist_to_check = level.glaive_chop_cone_range_sq;
		if(var_10ee11e)
		{
			dist_to_check = level.var_42894cb8;
		}
		if(dist_sq > dist_to_check)
		{
			continue;
		}
		normal = vectornormalize(test_origin - view_pos);
		dot = vectordot(forward_view_angles, normal);
		if(dot <= 0)
		{
			continue;
		}
		if(0 == ai damageconetrace(view_pos, self))
		{
			continue;
		}
		ai.chopped = 1;
		if(isdefined(ai.chop_actor_cb))
		{
			self thread [[ai.chop_actor_cb]](ai, self, weapon);
			continue;
		}
		self thread chop_actor(ai, var_10ee11e, leftswing, weapon);
	}
}

/*
	Name: swordarc_swipe
	Namespace: zm_weap_glaive
	Checksum: 0x5B4299FB
	Offset: 0x20A8
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function swordarc_swipe(player, var_10ee11e)
{
	if(var_10ee11e)
	{
		player clientfield::increment_to_player("swipe_lv2_fx");
	}
	else
	{
		player clientfield::increment_to_player("swipe_fx");
	}
	player thread chop_zombies(1, var_10ee11e, 1, self);
	wait(0.3);
	player thread chop_zombies(0, var_10ee11e, 1, self);
	wait(0.5);
	player thread chop_zombies(0, var_10ee11e, 0, self);
}

/*
	Name: arc_attack_think
	Namespace: zm_weap_glaive
	Checksum: 0x245A67A7
	Offset: 0x2188
	Size: 0x88
	Parameters: 2
	Flags: Linked, Private
*/
function private arc_attack_think(weapon, var_10ee11e)
{
	self endon(#"hash_b29853d8");
	self endon(#"disconnect");
	self endon(#"bled_out");
	while(true)
	{
		self util::waittill_any("weapon_melee_power", "weapon_melee");
		weapon thread swordarc_swipe(self, var_10ee11e);
	}
}

/*
	Name: autokill_think
	Namespace: zm_weap_glaive
	Checksum: 0x224C3688
	Offset: 0x2218
	Size: 0x88
	Parameters: 1
	Flags: Linked, Private
*/
function private autokill_think(wpn_autokill)
{
	self endon(#"hash_b29853d8");
	self endon(#"disconnect");
	self endon(#"bled_out");
	while(true)
	{
		self waittill(#"weapon_melee_power_left", weapon);
		if(weapon == wpn_autokill && self.autokill_glaive_active == 0)
		{
			self thread send_autokill_sword(wpn_autokill);
		}
	}
}

/*
	Name: function_86ee93a8
	Namespace: zm_weap_glaive
	Checksum: 0x8DC10D32
	Offset: 0x22A8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_86ee93a8()
{
	if(isdefined(self.var_8f6c69b8) && self.var_8f6c69b8)
	{
		return;
	}
	self.var_8f6c69b8 = 1;
	self notify(#"hide_equipment_hint_text");
	util::wait_network_frame();
	zm_equipment::show_hint_text(&"ZM_ZOD_SWORD_RECOVERY_HINT", 3.2);
}

/*
	Name: function_729af361
	Namespace: zm_weap_glaive
	Checksum: 0xAB305DD9
	Offset: 0x2320
	Size: 0xE4
	Parameters: 1
	Flags: Linked, Private
*/
function private function_729af361(vh_glaive)
{
	self endon(#"disconnect");
	self endon(#"hash_b29853d8");
	self endon(#"weapon_change");
	vh_glaive endon(#"returned_to_owner");
	vh_glaive endon(#"disconnect");
	self thread function_86ee93a8();
	self.var_c0d25105._glaive_must_return_to_owner = 0;
	while(isdefined(self) && self throwbuttonpressed())
	{
		wait(0.05);
	}
	while(isdefined(self))
	{
		if(self throwbuttonpressed())
		{
			self.var_c0d25105._glaive_must_return_to_owner = 1;
			return;
		}
		wait(0.05);
	}
}

/*
	Name: send_autokill_sword
	Namespace: zm_weap_glaive
	Checksum: 0x777D00D4
	Offset: 0x2410
	Size: 0x2D4
	Parameters: 1
	Flags: Linked, Private
*/
function private send_autokill_sword(wpn_autokill)
{
	a_sp_glaive = getspawnerarray("glaive_spawner", "script_noteworthy");
	sp_glaive = a_sp_glaive[0];
	sp_glaive.count = 1;
	vh_glaive = sp_glaive spawnfromspawner("player_glaive_" + self.characterindex, 1);
	self.var_c0d25105 = vh_glaive;
	if(isdefined(vh_glaive))
	{
		vh_glaive vehicle::lights_on();
		self clientfield::increment_to_player("throw_fx");
		vh_glaive.origin = (self.origin + (80 * anglestoforward(self.angles))) + vectorscale((0, 0, 1), 50);
		vh_glaive.angles = self getplayerangles();
		vh_glaive.owner = self;
		vh_glaive.weapon = wpn_autokill;
		vh_glaive._glaive_settings_lifetime = math::clamp(self.sword_power * 100, 10, 60);
		self.autokill_glaive_active = 1;
		self allowmeleepowerleft(0);
		self thread function_50cf29d("lv2launch");
		self thread function_729af361(vh_glaive);
		vh_glaive util::waittill_any("returned_to_owner", "disconnect");
		self thread function_50cf29d("lv2recover");
		self allowmeleepowerleft(1);
		self.autokill_glaive_active = 0;
		self notify(#"hash_8a993396");
		self.var_c0d25105 = undefined;
		if(isdefined(self))
		{
			util::wait_network_frame();
			self playsound("wpn_sword2_return");
		}
		vh_glaive delete();
	}
}

/*
	Name: function_e97f78f0
	Namespace: zm_weap_glaive
	Checksum: 0x67BDACB7
	Offset: 0x26F0
	Size: 0x2C8
	Parameters: 0
	Flags: Linked
*/
function function_e97f78f0()
{
	while(true)
	{
		foreach(player in getplayers())
		{
			if(isdefined(player.sword_power) && !player.sword_allowed)
			{
				player.sword_power = player gadgetpowerget(0) / 100;
				player clientfield::set_player_uimodel("zmhud.swordEnergy", player.sword_power);
				if(player.sword_power >= 1)
				{
					player.sword_allowed = 1;
					if(isdefined(player.current_sword) && (!(isdefined(player.usingsword) && player.usingsword)) && (!(isdefined(player.autokill_glaive_active) && player.autokill_glaive_active)))
					{
						player giveweapon(player.current_sword);
						player.sword_allowed = 1;
						player gadgetpowerset(0, 100);
						player clientfield::set_player_uimodel("zmhud.swordEnergy", 1);
						if(isdefined(player.var_2ef815cf) && player.var_2ef815cf)
						{
							player clientfield::set_player_uimodel("zmhud.swordState", 6);
						}
						else
						{
							player clientfield::set_player_uimodel("zmhud.swordState", 2);
						}
						player.sword_power = 1;
						player zm_equipment::show_hint_text(&"ZM_ZOD_SWORD_HINT", 2);
					}
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: disabled_sword
	Namespace: zm_weap_glaive
	Checksum: 0x332E9F18
	Offset: 0x29C0
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function disabled_sword()
{
	if(isdefined(self.usingsword) && self.usingsword)
	{
		return;
	}
	wpn_excalibur = self get_correct_sword_for_player_character_at_level(1);
	wpn_autokill = self get_correct_sword_for_player_character_at_level(2);
	/#
		if(isdefined(self.swordpreserve) && self.swordpreserve)
		{
			self.sword_allowed = 1;
			return;
		}
	#/
	self.sword_allowed = 0;
	if(self hasweapon(wpn_autokill))
	{
		self clientfield::set_player_uimodel("zmhud.swordState", 1);
		if(0)
		{
			self clientfield::set_player_uimodel("zmhud.swordEnergy", 0);
			self gadgetpowerset(0, 0);
			self.sword_power = 0;
		}
	}
	else if(self hasweapon(wpn_excalibur))
	{
		self clientfield::set_player_uimodel("zmhud.swordState", 5);
		if(0)
		{
			self clientfield::set_player_uimodel("zmhud.swordEnergy", 0);
			self gadgetpowerset(0, 0);
			self.sword_power = 0;
		}
	}
}

/*
	Name: sword_power_hud
	Namespace: zm_weap_glaive
	Checksum: 0x249BE0D
	Offset: 0x2B80
	Size: 0x2C2
	Parameters: 1
	Flags: Linked
*/
function sword_power_hud(slot)
{
	self endon(#"disconnect");
	self endon(#"hash_b29853d8");
	while(isdefined(self) && (isdefined(self.usingsword) && self.usingsword || (isdefined(self.autokill_glaive_active) && self.autokill_glaive_active)) && self.sword_power > 0)
	{
		if(isdefined(self.teleporting) && self.teleporting)
		{
			wait(0.05);
			continue;
		}
		self.sword_power = self gadgetpowerget(slot) / 100;
		self clientfield::set_player_uimodel("zmhud.swordEnergy", self.sword_power);
		if(isdefined(self.var_2ef815cf) && self.var_2ef815cf)
		{
			self clientfield::set_player_uimodel("zmhud.swordState", 7);
		}
		else
		{
			self clientfield::set_player_uimodel("zmhud.swordState", 3);
		}
		/#
			if(isdefined(self.swordpreserve) && self.swordpreserve)
			{
				self.sword_power = 1;
				self clientfield::set_player_uimodel("", 1);
				if(isdefined(self.var_2ef815cf) && self.var_2ef815cf)
				{
					self clientfield::set_player_uimodel("", 6);
				}
				else
				{
					self clientfield::set_player_uimodel("", 2);
				}
				self gadgetpowerset(0, 100);
			}
		#/
		wait(0.05);
	}
	self thread function_50cf29d("oopower");
	self.usingsword = 0;
	self.autokill_glaive_active = 0;
	self notify(#"hash_8a993396");
	if(isdefined(self.var_c0d25105))
	{
		self.var_c0d25105._glaive_must_return_to_owner = 1;
	}
	while(self isslamming())
	{
		wait(0.05);
	}
	self disabled_sword();
	self notify(#"hash_b29853d8");
}

/*
	Name: function_4a948f8a
	Namespace: zm_weap_glaive
	Checksum: 0x443C20E2
	Offset: 0x2E50
	Size: 0x1D4
	Parameters: 2
	Flags: Linked
*/
function function_4a948f8a(player, enemy)
{
	if(player laststand::player_is_in_laststand())
	{
		return;
	}
	if(isdefined(player) && (!(isdefined(player.usingsword) && player.usingsword) && (!(isdefined(player.autokill_glaive_active) && player.autokill_glaive_active))) && isdefined(player.current_sword))
	{
		if(isdefined(enemy.sword_kill_power))
		{
			perkfactor = 1;
			if(player hasperk("specialty_overcharge"))
			{
				perkfactor = getdvarfloat("gadgetPowerOverchargePerkScoreFactor");
			}
			temp = player.sword_power + (perkfactor * (enemy.sword_kill_power / 100));
			player.sword_power = math::clamp(temp, 0, 1);
			player clientfield::set_player_uimodel("zmhud.swordEnergy", player.sword_power);
			player gadgetpowerset(0, 100 * player.sword_power);
			player clientfield::increment_uimodel("zmhud.swordChargeUpdate");
		}
	}
}

/*
	Name: function_7855de72
	Namespace: zm_weap_glaive
	Checksum: 0x62106619
	Offset: 0x3030
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_7855de72(player)
{
	/#
		player ability_player::abilities_devgui_power_fill();
	#/
}

