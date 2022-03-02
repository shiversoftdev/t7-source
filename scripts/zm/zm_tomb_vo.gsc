// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\gametypes\_globallogic_score;

#namespace zm_tomb_vo;

/*
	Name: init_flags
	Namespace: zm_tomb_vo
	Checksum: 0xC9C53379
	Offset: 0x2BE0
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function init_flags()
{
	level flag::init("story_vo_playing");
	level flag::init("round_one_narrative_vo_complete");
	level flag::init("maxis_audiolog_gr0_playing");
	level flag::init("maxis_audiolog_gr1_playing");
	level flag::init("maxis_audiolog_gr2_playing");
	level flag::init("maxis_audio_log_1");
	level flag::init("maxis_audio_log_2");
	level flag::init("maxis_audio_log_3");
	level flag::init("maxis_audio_log_4");
	level flag::init("maxis_audio_log_5");
	level flag::init("maxis_audio_log_6");
	level flag::init("generator_find_vo_playing");
	level flag::init("samantha_intro_done");
	level flag::init("maxis_crafted_intro_done");
}

/*
	Name: init_level_specific_audio
	Namespace: zm_tomb_vo
	Checksum: 0x1255E567
	Offset: 0x2DB0
	Size: 0x1F0C
	Parameters: 0
	Flags: Linked
*/
function init_level_specific_audio()
{
	level.oh_shit_vo_cooldown = 0;
	level.remove_perk_vo_delay = 1;
	setdvar("zombie_kills", "5");
	setdvar("zombie_kill_timer", "6");
	if(zm_utility::is_classic())
	{
		level._audio_custom_response_line = &tomb_audio_custom_response_line;
		level.audio_get_mod_type = &tomb_audio_get_mod_type_override;
		level.custom_kill_damaged_vo = &zm_audio::custom_kill_damaged_vo;
		level._custom_zombie_oh_shit_vox_func = &tomb_custom_zombie_oh_shit_vox;
		level.gib_on_damage = &tomb_custom_crawler_spawned_vo;
		level._audio_custom_weapon_check = &tomb_audio_custom_weapon_check;
		level._magic_box_used_vo = &tomb_magic_box_used_vo;
		level thread start_narrative_vo();
		level thread first_magic_box_seen_vo();
		level thread start_samantha_intro_vo();
		level.zombie_custom_craftable_built_vo = &tomb_drone_built_vo;
		level thread discover_dig_site_vo();
		level thread maxis_audio_logs();
		level thread discover_pack_a_punch();
	}
	level thread zm_audio::sndannouncervoxadd("zombie_blood", "powerup_zombie_blood_0");
	level thread zm_audio::sndannouncervoxadd("bonus_points_player", "powerup_blood_money_0");
	level.vox_response_override = 1;
	tomb_add_player_dialogue("player", "general", "oh_shit", "oh_shit", 1, 100);
	tomb_add_player_dialogue("player", "general", "no_money_weapon", "nomoney_generic", undefined);
	tomb_add_player_dialogue("player", "general", "no_money_box", "nomoney_generic", undefined);
	tomb_add_player_dialogue("player", "general", "perk_deny", "nomoney_generic", undefined);
	tomb_add_player_dialogue("player", "general", "no_money_capture", "nomoney_generic", undefined);
	tomb_add_player_dialogue("player", "perk", "specialty_armorvest", "perk_jugga", undefined);
	tomb_add_player_dialogue("player", "perk", "specialty_quickrevive", "perk_revive", undefined);
	tomb_add_player_dialogue("player", "perk", "specialty_fastreload", "perk_speed", undefined);
	tomb_add_player_dialogue("player", "perk", "specialty_longersprint", "perk_stamine", undefined);
	tomb_add_player_dialogue("player", "perk", "specialty_additionalprimaryweapon", "perk_mule", undefined);
	tomb_add_player_dialogue("player", "kill", "closekill", "kill_close", undefined, 15);
	tomb_add_player_dialogue("player", "kill", "damage", "kill_damaged", undefined, 50);
	tomb_add_player_dialogue("player", "kill", "headshot", "kill_headshot", 1, 25);
	tomb_add_player_dialogue("player", "kill", "one_inch_punch", "kill_one_inch", undefined, 15);
	tomb_add_player_dialogue("player", "kill", "ice_staff", "kill_ice", undefined, 15);
	tomb_add_player_dialogue("player", "kill", "ice_staff_upgrade", "kill_ice_upgrade", undefined, 15);
	tomb_add_player_dialogue("player", "kill", "fire_staff", "kill_fire", undefined, 15);
	tomb_add_player_dialogue("player", "kill", "fire_staff_upgrade", "kill_fire_upgrade", undefined, 15);
	tomb_add_player_dialogue("player", "kill", "light_staff", "kill_light", undefined, 15);
	tomb_add_player_dialogue("player", "kill", "light_staff_upgrade", "kill_light_upgrade", undefined, 15);
	tomb_add_player_dialogue("player", "kill", "wind_staff", "kill_wind", undefined, 15);
	tomb_add_player_dialogue("player", "kill", "wind_staff_upgrade", "kill_wind_upgrade", undefined, 15);
	tomb_add_player_dialogue("player", "kill", "headshot_respond_to_plr_0_neg", "head_rspnd_to_plr_0_neg", undefined, 100);
	tomb_add_player_dialogue("player", "kill", "headshot_respond_to_plr_0_pos", "head_rspnd_to_plr_0_pos", undefined, 100);
	tomb_add_player_dialogue("player", "kill", "headshot_respond_to_plr_1_neg", "head_rspnd_to_plr_1_neg", undefined, 100);
	tomb_add_player_dialogue("player", "kill", "headshot_respond_to_plr_1_pos", "head_rspnd_to_plr_1_pos", undefined, 100);
	tomb_add_player_dialogue("player", "kill", "headshot_respond_to_plr_2_neg", "head_rspnd_to_plr_2_neg", undefined, 100);
	tomb_add_player_dialogue("player", "kill", "headshot_respond_to_plr_2_pos", "head_rspnd_to_plr_2_pos", undefined, 100);
	tomb_add_player_dialogue("player", "kill", "headshot_respond_to_plr_3_neg", "head_rspnd_to_plr_3_neg", undefined, 100);
	tomb_add_player_dialogue("player", "kill", "headshot_respond_to_plr_3_pos", "head_rspnd_to_plr_3_pos", undefined, 100);
	tomb_add_player_dialogue("player", "powerup", "zombie_blood", "powerup_zombie_blood", undefined, 100);
	tomb_add_player_dialogue("player", "general", "revive_up", "revive_player", 1, 100);
	tomb_add_player_dialogue("player", "general", "heal_revived_pos", "heal_revived_pos", undefined, 100);
	tomb_add_player_dialogue("player", "general", "heal_revived_neg", "heal_revived_neg", undefined, 100);
	tomb_add_player_dialogue("player", "general", "exert_sigh", "exert_sigh", undefined, 100);
	tomb_add_player_dialogue("player", "general", "exert_laugh", "exert_laugh", undefined, 100);
	tomb_add_player_dialogue("player", "general", "pain_high", "pain_high", undefined, 100);
	tomb_add_player_dialogue("player", "general", "build_dd_pickup", "build_dd_pickup", undefined, 100);
	tomb_add_player_dialogue("player", "general", "build_dd_brain_pickup", "pickup_brain", undefined, 100);
	tomb_add_player_dialogue("player", "general", "build_dd_final", "build_dd_final", undefined, 100);
	tomb_add_player_dialogue("player", "general", "build_dd_plc", "build_dd_take", undefined, 100);
	tomb_add_player_dialogue("player", "general", "build_zs_pickup", "build_zs_pickup", undefined, 100);
	tomb_add_player_dialogue("player", "general", "build_zs_final", "build_zs_final", undefined, 100);
	tomb_add_player_dialogue("player", "general", "build_zs_plc", "build_zs_take", undefined, 100);
	tomb_add_player_dialogue("player", "general", "record_pickup", "pickup_record", undefined, 100);
	tomb_add_player_dialogue("player", "general", "gramophone_pickup", "pickup_gramophone", undefined, 100);
	tomb_add_player_dialogue("player", "general", "place_gramophone", "place_gramophone", undefined, 100);
	tomb_add_player_dialogue("player", "general", "staff_part_pickup", "pickup_staff_part", undefined, 100);
	tomb_add_player_dialogue("player", "general", "crystal_pickup", "pickup_crystal", undefined, 100);
	tomb_add_player_dialogue("player", "general", "pickup_fire", "pickup_fire", undefined, 100);
	tomb_add_player_dialogue("player", "general", "pickup_ice", "pickup_ice", undefined, 100);
	tomb_add_player_dialogue("player", "general", "pickup_light", "pickup_light", undefined, 100);
	tomb_add_player_dialogue("player", "general", "pickup_wind", "pickup_wind", undefined, 100);
	tomb_add_player_dialogue("player", "puzzle", "try_puzzle", "activate_generic", undefined);
	tomb_add_player_dialogue("player", "puzzle", "puzzle_confused", "confusion_generic", undefined);
	tomb_add_player_dialogue("player", "puzzle", "puzzle_good", "outcome_yes_generic", undefined);
	tomb_add_player_dialogue("player", "puzzle", "puzzle_bad", "outcome_no_generic", undefined);
	tomb_add_player_dialogue("player", "puzzle", "berate_respond", "generic_chastise", undefined);
	tomb_add_player_dialogue("player", "puzzle", "encourage_respond", "generic_encourage", undefined);
	tomb_add_player_dialogue("player", "staff", "first_piece", "1st_staff_found", undefined);
	tomb_add_player_dialogue("player", "general", "build_pickup", "pickup_generic", undefined, 100);
	tomb_add_player_dialogue("player", "general", "reboard", "rebuild_boards", undefined, 100);
	tomb_add_player_dialogue("player", "weapon_pickup", "explo", "wpck_explo", undefined, 100);
	tomb_add_player_dialogue("player", "weapon_pickup", "raygun_mark2", "wpck_raymk2", undefined, 100);
	tomb_add_player_dialogue("player", "general", "use_box_intro", "use_box_intro", undefined, 100);
	tomb_add_player_dialogue("player", "general", "use_box_2nd_time", "use_box_2nd_time", undefined, 100);
	tomb_add_player_dialogue("player", "general", "take_weapon_intro", "take_weapon_intro", undefined, 100);
	tomb_add_player_dialogue("player", "general", "take_weapon_2nd_time", "take_weapon_2nd_time", undefined, 100);
	tomb_add_player_dialogue("player", "general", "discover_wall_buy", "discover_wall_buy", undefined, 100);
	tomb_add_player_dialogue("player", "general", "generic_wall_buy", "generic_wall_buy", undefined, 100);
	tomb_add_player_dialogue("player", "general", "pap_arm", "pap_arm", undefined, 100);
	tomb_add_player_dialogue("player", "general", "pap_discovered", "capture_zones", undefined, 100);
	tomb_add_player_dialogue("player", "tank", "discover_tank", "discover_tank", undefined);
	tomb_add_player_dialogue("player", "tank", "tank_flame_zombie", "kill_tank", undefined, 25);
	tomb_add_player_dialogue("player", "tank", "tank_buy", "buy_tank", undefined);
	tomb_add_player_dialogue("player", "tank", "tank_leave", "exit_tank", undefined);
	tomb_add_player_dialogue("player", "tank", "tank_cooling", "cool_tank", undefined);
	tomb_add_player_dialogue("player", "tank", "tank_left_behind", "miss_tank", undefined);
	tomb_add_player_dialogue("player", "general", "siren_1st_time", "siren_1st_time", undefined, 100);
	tomb_add_player_dialogue("player", "general", "siren_generic", "siren_generic", undefined, 100);
	tomb_add_player_dialogue("player", "general", "multiple_mechs", "multiple_mechs", undefined, 100);
	tomb_add_player_dialogue("player", "general", "discover_mech", "discover_mech", undefined, 100);
	tomb_add_player_dialogue("player", "general", "mech_defeated", "mech_defeated", undefined, 100);
	tomb_add_player_dialogue("player", "general", "mech_grab", "rspnd_mech_grab", undefined, 100);
	tomb_add_player_dialogue("player", "general", "shoot_mech_arm", "shoot_mech_arm", undefined, 100);
	tomb_add_player_dialogue("player", "general", "shoot_mech_head", "shoot_mech_head", undefined, 100);
	tomb_add_player_dialogue("player", "general", "shoot_mech_power", "shoot_mech_power", undefined, 100);
	tomb_add_player_dialogue("player", "general", "rspnd_mech_jump", "rspnd_mech_jump", undefined, 100);
	tomb_add_player_dialogue("player", "general", "enter_robot", "enter_robot", undefined, 100);
	tomb_add_player_dialogue("player", "general", "purge_robot", "purge_robot", undefined, 100);
	tomb_add_player_dialogue("player", "general", "exit_robot", "exit_robot", undefined, 100);
	tomb_add_player_dialogue("player", "general", "air_chute_landing", "air_chute_landing", undefined, 100);
	tomb_add_player_dialogue("player", "general", "robot_crush_golden", "robot_crush_golden", undefined, 100);
	tomb_add_player_dialogue("player", "general", "robot_crush_player", "robot_crush_player", undefined, 100);
	tomb_add_player_dialogue("player", "general", "discover_robot", "discover_robot", undefined, 100);
	tomb_add_player_dialogue("player", "general", "see_robots", "see_robots", undefined, 100);
	tomb_add_player_dialogue("player", "general", "robot_crush_zombie", "robot_crush_zombie", undefined, 100);
	tomb_add_player_dialogue("player", "general", "robot_crush_mech", "robot_crush_mech", undefined, 100);
	tomb_add_player_dialogue("player", "general", "shoot_robot", "shoot_robot", undefined, 100);
	tomb_add_player_dialogue("player", "general", "warn_robot_foot", "warn_robot_foot", undefined, 100);
	tomb_add_player_dialogue("player", "general", "warn_robot", "warn_robot", undefined, 100);
	tomb_add_player_dialogue("player", "general", "use_beacon", "use_beacon", undefined, 100);
	tomb_add_player_dialogue("player", "general", "srnd_rspnd_to_plr_0_neg", "srnd_rspnd_to_plr_0_neg", undefined, 100);
	tomb_add_player_dialogue("player", "general", "srnd_rspnd_to_plr_1_neg", "srnd_rspnd_to_plr_1_neg", undefined, 100);
	tomb_add_player_dialogue("player", "general", "srnd_rspnd_to_plr_2_neg", "srnd_rspnd_to_plr_2_neg", undefined, 100);
	tomb_add_player_dialogue("player", "general", "srnd_rspnd_to_plr_3_neg", "srnd_rspnd_to_plr_3_neg", undefined, 100);
	tomb_add_player_dialogue("player", "general", "srnd_rspnd_to_plr_0_pos", "srnd_rspnd_to_plr_0_pos", undefined, 100);
	tomb_add_player_dialogue("player", "general", "srnd_rspnd_to_plr_1_pos", "srnd_rspnd_to_plr_1_pos", undefined, 100);
	tomb_add_player_dialogue("player", "general", "srnd_rspnd_to_plr_2_pos", "srnd_rspnd_to_plr_2_pos", undefined, 100);
	tomb_add_player_dialogue("player", "general", "srnd_rspnd_to_plr_3_pos", "srnd_rspnd_to_plr_3_pos", undefined, 100);
	tomb_add_player_dialogue("player", "general", "achievement", "earn_acheivement", undefined, 100);
	tomb_add_player_dialogue("player", "quest", "find_secret", "find_secret", undefined, 100);
	tomb_add_player_dialogue("player", "perk", "one_inch", "perk_one_inch", undefined, 100);
	tomb_add_player_dialogue("player", "digging", "pickup_shovel", "pickup_shovel", undefined, 100);
	tomb_add_player_dialogue("player", "digging", "dig_gun", "dig_gun", undefined, 100);
	tomb_add_player_dialogue("player", "digging", "dig_grenade", "dig_grenade", undefined, 100);
	tomb_add_player_dialogue("player", "digging", "dig_zombie", "dig_zombie", undefined, 100);
	tomb_add_player_dialogue("player", "digging", "dig_staff_part", "dig_staff_part", undefined, 100);
	tomb_add_player_dialogue("player", "digging", "dig_powerup", "dig_powerup", undefined, 100);
	tomb_add_player_dialogue("player", "digging", "dig_cash", "dig_cash", undefined, 100);
	tomb_add_player_dialogue("player", "soul_box", "zm_box_encourage", "zm_box_encourage", undefined, 100);
	tomb_add_player_dialogue("player", "zone_capture", "capture_started", "capture_zombies", undefined, 100);
	tomb_add_player_dialogue("player", "zone_capture", "recapture_started", "roaming_zombies", undefined, 100);
	tomb_add_player_dialogue("player", "zone_capture", "recapture_generator_attacked", "recapture_initiated", undefined, 100);
	tomb_add_player_dialogue("player", "zone_capture", "recapture_prevented", "recapture_prevented", undefined, 100);
	tomb_add_player_dialogue("player", "zone_capture", "all_generators_captured", "zones_held", undefined, 100);
	tomb_add_player_dialogue("player", "lockdown", "power_off", "lockdown_generic", undefined, 100);
	tomb_add_player_dialogue("player", "general", "struggle_mud", "struggle_mud", undefined, 100);
	tomb_add_player_dialogue("player", "general", "discover_dig_site", "discover_dig_site", undefined, 100);
	tomb_add_player_dialogue("player", "quadrotor", "kill_drone", "kill_drone", undefined, 20);
	tomb_add_player_dialogue("player", "quadrotor", "rspnd_drone_revive", "rspnd_drone_revive", undefined, 100);
	tomb_add_player_dialogue("player", "wunderfizz", "perk_wonder", "perk_wonder", undefined, 100);
	tomb_add_player_dialogue("player", "samantha", "hear_samantha_1", "hear_samantha_1", undefined, 100);
	tomb_add_player_dialogue("player", "samantha", "heroes_confer", "heroes_confer", undefined, 100);
	tomb_add_player_dialogue("player", "samantha", "hear_samantha_3", "hear_samantha_3", undefined, 100);
	init_sam_promises();
}

/*
	Name: tomb_add_player_dialogue
	Namespace: zm_tomb_vo
	Checksum: 0x2E0CB10
	Offset: 0x4CC8
	Size: 0xAC
	Parameters: 6
	Flags: Linked
*/
function tomb_add_player_dialogue(speaker, category, type, alias, response = 0, chance = 100)
{
	level.vox zm_audio::zmbvoxadd(category, type, alias, chance, response);
	if(isdefined(chance))
	{
		zm_utility::add_vox_response_chance(type, chance);
	}
}

/*
	Name: tomb_audio_get_mod_type_override
	Namespace: zm_tomb_vo
	Checksum: 0x424CE2DD
	Offset: 0x4D80
	Size: 0x78E
	Parameters: 7
	Flags: Linked
*/
function tomb_audio_get_mod_type_override(impact, mod, weapon, zombie, instakill, dist, player)
{
	var_adac242b = 4096;
	var_2c1bd1bd = 15376;
	var_af03c4a6 = 160000;
	a_str_mod = [];
	if(isdefined(zombie.staff_dmg))
	{
		weapon = zombie.staff_dmg;
	}
	else if(isdefined(zombie) && isdefined(zombie.damageweapon))
	{
		weapon = zombie.damageweapon;
	}
	if(zombie.damageweapon.name == "sticky_grenade_widows_wine")
	{
		return "default";
	}
	str_weapon = weapon.name;
	switch(str_weapon)
	{
		case "staff_water":
		case "staff_water_upgraded":
		{
			return "ice_staff";
			break;
		}
		case "staff_water_upgraded2":
		case "staff_water_upgraded3":
		{
			return "ice_staff_upgrade";
			break;
		}
		case "staff_fire":
		case "staff_fire_upgraded":
		{
			return "fire_staff";
			break;
		}
		case "staff_fire_upgraded2":
		case "staff_fire_upgraded3":
		{
			return "fire_staff_upgrade";
			break;
		}
		case "staff_lightning":
		case "staff_lightning_upgraded":
		{
			return "lightning_staff";
			break;
		}
		case "staff_lightning_upgraded2":
		case "staff_lightning_upgraded3":
		{
			return "lightning_staff_upgrade";
			break;
		}
		case "staff_air":
		case "staff_air_upgraded":
		{
			return "air_staff";
			break;
		}
		case "staff_air_upgraded2":
		case "staff_air_upgraded3":
		{
			return "air_staff_upgrade";
			break;
		}
	}
	if(zombie.damageweapon.name == "dragonshield" || zombie.damageweapon.name == "dragonshield_upgraded")
	{
		return "rocketshield";
	}
	if(zombie.damageweapon.name == "hero_gravityspikes_melee")
	{
		if(zombie.damageweapon.firetype == "Melee" && (!(isdefined(player isslamming()) && player isslamming())))
		{
			return "default";
		}
		return "dg4";
	}
	if(zombie.damageweapon.name == "octobomb")
	{
		return "octobomb";
	}
	if(zombie.damageweapon.name == "idgun_genesis_0")
	{
		return "servant";
	}
	if(zombie.damageweapon.name == "thundergun")
	{
		return "thundergun";
	}
	if(zombie.damageweapon.name == ("shotgun_energy+holo+quickdraw") || zombie.damageweapon.name == ("pistol_energy+fastreload+reddot+steadyaim") || zombie.damageweapon.name == ("shotgun_energy_upgraded+extclip+holo+quickdraw") || zombie.damageweapon.name == ("pistol_energy_upgraded+extclip+fastreload+reddot+steadyaim"))
	{
		return "default";
	}
	if(zm_utility::is_placeable_mine(weapon))
	{
		if(!instakill)
		{
			return "betty";
		}
		return "weapon_instakill";
	}
	if(zombie.damageweapon.name == "cymbal_monkey")
	{
		if(instakill)
		{
			return "weapon_instakill";
		}
		return "monkey";
	}
	if(zombie.damageweapon.name == "ray_gun" || zombie.damageweapon.name == "ray_gun_upgraded" && dist > var_af03c4a6)
	{
		if(!instakill)
		{
			return "raygun";
		}
		return "weapon_instakill";
	}
	if(zombie.damageweapon.name == "raygun_mark2" || zombie.damageweapon.name == "raygun_mark2_upgraded")
	{
		if(!instakill)
		{
			return "raygunmk2";
		}
		return "weapon_instakill";
	}
	if(zm_utility::is_headshot(weapon, impact, mod) && dist >= var_af03c4a6)
	{
		return "headshot";
	}
	if(mod == "MOD_MELEE" || mod == "MOD_UNKNOWN" && dist < var_adac242b)
	{
		if(!instakill)
		{
			return "melee";
		}
		return "melee_instakill";
	}
	if(zm_utility::is_explosive_damage(mod) && weapon.name != "ray_gun" && weapon.name != "ray_gun_upgraded" && (!(isdefined(zombie.is_on_fire) && zombie.is_on_fire)))
	{
		if(!instakill)
		{
			return "explosive";
		}
		return "weapon_instakill";
	}
	if(weapon.doesfiredamage && (mod == "MOD_BURNED" || mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH"))
	{
		if(!instakill)
		{
			return "flame";
		}
		return "weapon_instakill";
	}
	if(!isdefined(impact))
	{
		impact = "";
	}
	if(mod != "MOD_MELEE" && zombie.missinglegs)
	{
		return "crawler";
	}
	if(mod != "MOD_BURNED" && dist < var_adac242b)
	{
		return "close";
	}
	if(mod == "MOD_RIFLE_BULLET" || mod == "MOD_PISTOL_BULLET")
	{
		if(!instakill)
		{
			return "bullet";
		}
		return "weapon_instakill";
	}
	if(instakill)
	{
		return "default";
	}
	return "default";
}

/*
	Name: tomb_custom_zombie_oh_shit_vox
	Namespace: zm_tomb_vo
	Checksum: 0x6FF5FEF4
	Offset: 0x5518
	Size: 0x256
	Parameters: 0
	Flags: Linked
*/
function tomb_custom_zombie_oh_shit_vox()
{
	self endon(#"death_or_disconnect");
	while(true)
	{
		wait(1);
		if(isdefined(self.oh_shit_vo_cooldown) && self.oh_shit_vo_cooldown)
		{
			continue;
		}
		players = getplayers();
		zombs = zombie_utility::get_round_enemy_array();
		if(players.size <= 1)
		{
			n_distance = 250;
			n_zombies = 5;
			n_chance = 30;
			n_cooldown_time = 20;
		}
		else
		{
			n_distance = 250;
			n_zombies = 5;
			n_chance = 30;
			n_cooldown_time = 15;
		}
		close_zombs = 0;
		for(i = 0; i < zombs.size; i++)
		{
			if(isdefined(zombs[i].favoriteenemy) && zombs[i].favoriteenemy == self || !isdefined(zombs[i].favoriteenemy))
			{
				if(distancesquared(zombs[i].origin, self.origin) < (n_distance * n_distance))
				{
					close_zombs++;
				}
			}
		}
		if(close_zombs >= n_zombies)
		{
			if(randomint(100) < n_chance && (!(isdefined(self.giant_robot_transition) && self.giant_robot_transition)) && !isdefined(self.in_giant_robot_head))
			{
				self zm_audio::create_and_play_dialog("general", "oh_shit");
				self thread global_oh_shit_cooldown_timer(n_cooldown_time);
				wait(n_cooldown_time);
			}
		}
	}
}

/*
	Name: global_oh_shit_cooldown_timer
	Namespace: zm_tomb_vo
	Checksum: 0xCBAF82C9
	Offset: 0x5778
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function global_oh_shit_cooldown_timer(n_cooldown_time)
{
	self endon(#"disconnect");
	self.oh_shit_vo_cooldown = 1;
	wait(n_cooldown_time);
	self.oh_shit_vo_cooldown = 0;
}

/*
	Name: tomb_custom_crawler_spawned_vo
	Namespace: zm_tomb_vo
	Checksum: 0x6D9F00C9
	Offset: 0x57B8
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function tomb_custom_crawler_spawned_vo()
{
	self endon(#"death");
	if(isdefined(self.a.gib_ref) && isalive(self))
	{
		if(self.a.gib_ref == "no_legs" || self.a.gib_ref == "right_leg" || self.a.gib_ref == "left_leg")
		{
			if(isdefined(self.attacker) && isplayer(self.attacker))
			{
				if(isdefined(self.attacker.crawler_created_vo_cooldown) && self.attacker.crawler_created_vo_cooldown)
				{
					return;
				}
				rand = randomintrange(0, 100);
				if(rand < 15)
				{
					self.attacker zm_audio::create_and_play_dialog("general", "crawl_spawn");
					self.attacker thread crawler_created_vo_cooldown();
				}
			}
		}
	}
}

/*
	Name: crawler_created_vo_cooldown
	Namespace: zm_tomb_vo
	Checksum: 0xAAF09214
	Offset: 0x5920
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function crawler_created_vo_cooldown()
{
	self endon(#"disconnect");
	self.crawler_created_vo_cooldown = 1;
	wait(30);
	self.crawler_created_vo_cooldown = 0;
}

/*
	Name: tomb_audio_custom_weapon_check
	Namespace: zm_tomb_vo
	Checksum: 0xCFD67C2C
	Offset: 0x5958
	Size: 0x3B2
	Parameters: 2
	Flags: Linked
*/
function tomb_audio_custom_weapon_check(weapon, magic_box)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(weapon.name == "hero_annihilator" || weapon.name == "equip_dieseldrone")
	{
		return "crappy";
	}
	str_weapon = weapon.name;
	if(isdefined(magic_box) && magic_box)
	{
		if(isdefined(self.magic_box_uses) && self.magic_box_uses == 1)
		{
			self thread zm_audio::create_and_play_dialog("general", "take_weapon_intro");
		}
		else
		{
			if(isdefined(self.magic_box_uses) && self.magic_box_uses == 2)
			{
				self thread zm_audio::create_and_play_dialog("general", "take_weapon_2nd_time");
			}
			else
			{
				type = self zm_weapons::weapon_type_check(weapon);
				return type;
			}
		}
	}
	else
	{
		if(issubstr(str_weapon, "staff"))
		{
			if(str_weapon == "staff_fire")
			{
				self zm_audio::create_and_play_dialog("general", "pickup_fire");
				level notify(#"staff_crafted_vo", self, 1);
			}
			else
			{
				if(str_weapon == "staff_water")
				{
					self zm_audio::create_and_play_dialog("general", "pickup_ice");
					level notify(#"staff_crafted_vo", self, 4);
				}
				else
				{
					if(str_weapon == "staff_air")
					{
						self zm_audio::create_and_play_dialog("general", "pickup_wind");
						level notify(#"staff_crafted_vo", self, 2);
					}
					else if(str_weapon == "staff_lightning")
					{
						self zm_audio::create_and_play_dialog("general", "pickup_light");
						level notify(#"staff_crafted_vo", self, 3);
					}
				}
			}
		}
		else
		{
			if(zm_weapons::is_weapon_upgraded(weapon))
			{
				self thread zm_audio::create_and_play_dialog("general", "pap_arm");
			}
			else
			{
				if(!isdefined(self.wallbuys_purchased))
				{
					self thread zm_audio::create_and_play_dialog("general", "discover_wall_buy");
					self.wallbuys_purchased = 1;
				}
				else
				{
					if(str_weapon == "sticky_grenade" || str_weapon == "claymore")
					{
						self zm_audio::create_and_play_dialog("weapon_pickup", "explo");
					}
					else
					{
						self thread zm_audio::create_and_play_dialog("general", "generic_wall_buy");
					}
				}
			}
		}
	}
	return "crappy";
}

/*
	Name: tomb_magic_box_used_vo
	Namespace: zm_tomb_vo
	Checksum: 0x30727C30
	Offset: 0x5D18
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function tomb_magic_box_used_vo()
{
	if(!isdefined(self.magic_box_uses))
	{
		self.magic_box_uses = 1;
	}
	else
	{
		self.magic_box_uses++;
	}
	if(self.magic_box_uses == 1)
	{
		self thread zm_audio::create_and_play_dialog("general", "use_box_intro");
	}
	else if(self.magic_box_uses == 2)
	{
		self thread zm_audio::create_and_play_dialog("general", "use_box_2nd_time");
	}
}

/*
	Name: easter_egg_song_vo
	Namespace: zm_tomb_vo
	Checksum: 0x1D477937
	Offset: 0x5DB8
	Size: 0x150
	Parameters: 1
	Flags: None
*/
function easter_egg_song_vo(player)
{
	wait(3.5);
	if(isalive(player))
	{
		player thread zm_audio::create_and_play_dialog("quest", "find_secret");
	}
	else
	{
		while(true)
		{
			a_players = getplayers();
			foreach(player in a_players)
			{
				if(isalive(player))
				{
					if(!(isdefined(player.dontspeak) && player.dontspeak))
					{
						player thread zm_audio::create_and_play_dialog("quest", "find_secret");
					}
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: play_gramophone_place_vo
	Namespace: zm_tomb_vo
	Checksum: 0xDF9B48C8
	Offset: 0x5F10
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function play_gramophone_place_vo()
{
	if(!(isdefined(self.dontspeak) && self.dontspeak))
	{
		if(!(isdefined(self.gramophone_place_vo) && self.gramophone_place_vo))
		{
			self zm_audio::create_and_play_dialog("general", "place_gramophone");
			self.gramophone_place_vo = 1;
		}
	}
}

/*
	Name: setup_personality_character_exerts
	Namespace: zm_tomb_vo
	Checksum: 0xA8D8F997
	Offset: 0x5F78
	Size: 0x8BA
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
	level.exert_sounds[1]["hitmed"][0] = "vox_plr_0_exert_pain_medium_0";
	level.exert_sounds[1]["hitmed"][1] = "vox_plr_0_exert_pain_medium_1";
	level.exert_sounds[1]["hitmed"][2] = "vox_plr_0_exert_pain_medium_2";
	level.exert_sounds[1]["hitmed"][3] = "vox_plr_0_exert_pain_medium_3";
	level.exert_sounds[2]["hitmed"][0] = "vox_plr_1_exert_pain_medium_0";
	level.exert_sounds[2]["hitmed"][1] = "vox_plr_1_exert_pain_medium_1";
	level.exert_sounds[2]["hitmed"][2] = "vox_plr_1_exert_pain_medium_2";
	level.exert_sounds[2]["hitmed"][3] = "vox_plr_1_exert_pain_medium_3";
	level.exert_sounds[3]["hitmed"][0] = "vox_plr_2_exert_pain_medium_0";
	level.exert_sounds[3]["hitmed"][1] = "vox_plr_2_exert_pain_medium_1";
	level.exert_sounds[3]["hitmed"][2] = "vox_plr_2_exert_pain_medium_2";
	level.exert_sounds[3]["hitmed"][3] = "vox_plr_2_exert_pain_medium_3";
	level.exert_sounds[4]["hitmed"][0] = "vox_plr_3_exert_pain_medium_0";
	level.exert_sounds[4]["hitmed"][1] = "vox_plr_3_exert_pain_medium_1";
	level.exert_sounds[4]["hitmed"][2] = "vox_plr_3_exert_pain_medium_2";
	level.exert_sounds[4]["hitmed"][3] = "vox_plr_3_exert_pain_medium_3";
	level.exert_sounds[1]["hitlrg"][0] = "vox_plr_0_exert_pain_high_0";
	level.exert_sounds[1]["hitlrg"][1] = "vox_plr_0_exert_pain_high_1";
	level.exert_sounds[1]["hitlrg"][2] = "vox_plr_0_exert_pain_high_2";
	level.exert_sounds[1]["hitlrg"][3] = "vox_plr_0_exert_pain_high_3";
	level.exert_sounds[2]["hitlrg"][0] = "vox_plr_1_exert_pain_high_0";
	level.exert_sounds[2]["hitlrg"][1] = "vox_plr_1_exert_pain_high_1";
	level.exert_sounds[2]["hitlrg"][2] = "vox_plr_1_exert_pain_high_2";
	level.exert_sounds[2]["hitlrg"][3] = "vox_plr_1_exert_pain_high_3";
	level.exert_sounds[3]["hitlrg"][0] = "vox_plr_2_exert_pain_high_0";
	level.exert_sounds[3]["hitlrg"][1] = "vox_plr_2_exert_pain_high_1";
	level.exert_sounds[3]["hitlrg"][2] = "vox_plr_2_exert_pain_high_2";
	level.exert_sounds[3]["hitlrg"][3] = "vox_plr_2_exert_pain_high_3";
	level.exert_sounds[4]["hitlrg"][0] = "vox_plr_3_exert_pain_high_0";
	level.exert_sounds[4]["hitlrg"][1] = "vox_plr_3_exert_pain_high_1";
	level.exert_sounds[4]["hitlrg"][2] = "vox_plr_3_exert_pain_high_2";
	level.exert_sounds[4]["hitlrg"][3] = "vox_plr_3_exert_pain_high_3";
}

/*
	Name: tomb_audio_custom_response_line
	Namespace: zm_tomb_vo
	Checksum: 0xD889E157
	Offset: 0x6840
	Size: 0x114
	Parameters: 3
	Flags: Linked
*/
function tomb_audio_custom_response_line(player, category, type)
{
	if(type == "revive_up")
	{
		player thread play_pos_neg_response_on_closest_player("general", "heal_revived", "kills");
	}
	else
	{
		if(type == "headshot")
		{
			player thread play_pos_neg_response_on_closest_player("kill", "headshot_respond_to_plr_" + player.characterindex, "kills");
		}
		else if(type == "oh_shit")
		{
			player thread play_pos_neg_response_on_closest_player("general", "srnd_rspnd_to_plr_" + player.characterindex, "kills");
			player thread global_oh_shit_cooldown_timer(15);
		}
	}
}

/*
	Name: play_vo_category_on_closest_player
	Namespace: zm_tomb_vo
	Checksum: 0xA1526DA6
	Offset: 0x6960
	Size: 0x104
	Parameters: 2
	Flags: None
*/
function play_vo_category_on_closest_player(category, type)
{
	a_players = getplayers();
	if(a_players.size <= 1)
	{
		return;
	}
	arrayremovevalue(a_players, self);
	a_closest = arraysort(a_players, self.origin, 1);
	if(distancesquared(self.origin, a_closest[0].origin) <= 250000)
	{
		if(isalive(a_closest[0]))
		{
			a_closest[0] zm_audio::create_and_play_dialog(category, type);
		}
	}
}

/*
	Name: play_pos_neg_response_on_closest_player
	Namespace: zm_tomb_vo
	Checksum: 0x3965A268
	Offset: 0x6A70
	Size: 0x1AE
	Parameters: 3
	Flags: Linked
*/
function play_pos_neg_response_on_closest_player(category, type, str_stat)
{
	a_players = getplayers();
	if(a_players.size <= 1)
	{
		return;
	}
	arrayremovevalue(a_players, self);
	a_closest = arraysort(a_players, self.origin, 1);
	foreach(player in a_closest)
	{
		if(distancesquared(self.origin, player.origin) <= 250000)
		{
			if(isalive(player))
			{
				str_suffix = get_positive_or_negative_suffix(self, player, str_stat);
				if(isdefined(str_suffix))
				{
					type = type + str_suffix;
				}
				player zm_audio::create_and_play_dialog(category, type);
				break;
			}
		}
	}
}

/*
	Name: get_positive_or_negative_suffix
	Namespace: zm_tomb_vo
	Checksum: 0x6C7456D9
	Offset: 0x6C28
	Size: 0xBC
	Parameters: 3
	Flags: Linked
*/
function get_positive_or_negative_suffix(e_player1, e_player2, str_stat)
{
	n_player1_stat = e_player1 globallogic_score::getpersstat(str_stat);
	n_player2_stat = e_player2 globallogic_score::getpersstat(str_stat);
	if(!isdefined(n_player1_stat) || !isdefined(n_player2_stat))
	{
		return undefined;
	}
	if(n_player1_stat >= n_player2_stat)
	{
		str_result = "_pos";
	}
	else
	{
		str_result = "_neg";
	}
	return str_result;
}

/*
	Name: struggle_mud_vo
	Namespace: zm_tomb_vo
	Checksum: 0x40BFA4E6
	Offset: 0x6CF0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function struggle_mud_vo()
{
	self endon(#"disconnect");
	self.played_mud_vo = 1;
	self zm_audio::create_and_play_dialog("general", "struggle_mud");
	self waittill(#"mud_slowdown_cleared");
	self thread struggle_mud_vo_cooldown();
}

/*
	Name: struggle_mud_vo_cooldown
	Namespace: zm_tomb_vo
	Checksum: 0x90AF32BE
	Offset: 0x6D60
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function struggle_mud_vo_cooldown()
{
	self endon(#"disconnect");
	wait(600);
	self.played_mud_vo = 0;
}

/*
	Name: discover_dig_site_vo
	Namespace: zm_tomb_vo
	Checksum: 0x3D1E2F8C
	Offset: 0x6D88
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function discover_dig_site_vo()
{
	level flag::wait_till("activate_zone_nml");
	s_origin = struct::get("discover_dig_site_vo_trigger", "targetname");
	s_origin.unitrigger_stub = spawnstruct();
	s_origin.unitrigger_stub.origin = s_origin.origin;
	s_origin.unitrigger_stub.script_width = 320;
	s_origin.unitrigger_stub.script_length = 88;
	s_origin.unitrigger_stub.script_height = 256;
	s_origin.unitrigger_stub.script_unitrigger_type = "unitrigger_box";
	s_origin.unitrigger_stub.angles = (0, 0, 0);
	zm_unitrigger::register_static_unitrigger(s_origin.unitrigger_stub, &discover_dig_site_trigger_touch);
}

/*
	Name: discover_dig_site_trigger_touch
	Namespace: zm_tomb_vo
	Checksum: 0x6372E0CF
	Offset: 0x6EE0
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function discover_dig_site_trigger_touch()
{
	while(true)
	{
		self waittill(#"trigger", player);
		if(isplayer(player))
		{
			if(!(isdefined(player.dontspeak) && player.dontspeak))
			{
				player thread zm_audio::create_and_play_dialog("general", "discover_dig_site");
				zm_unitrigger::unregister_unitrigger(self.stub);
				break;
			}
		}
	}
}

/*
	Name: maxis_audio_logs
	Namespace: zm_tomb_vo
	Checksum: 0xBFE69A94
	Offset: 0x6F90
	Size: 0x1DA
	Parameters: 0
	Flags: Linked
*/
function maxis_audio_logs()
{
	a_s_radios = struct::get_array("maxis_audio_log", "targetname");
	foreach(s_origin in a_s_radios)
	{
		s_origin.unitrigger_stub = spawnstruct();
		s_origin.unitrigger_stub.origin = s_origin.origin;
		s_origin.unitrigger_stub.radius = 36;
		s_origin.unitrigger_stub.height = 256;
		s_origin.unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
		s_origin.unitrigger_stub.hint_string = &"ZM_TOMB_MAXIS_AUDIOLOG";
		s_origin.unitrigger_stub.cursor_hint = "HINT_NOICON";
		s_origin.unitrigger_stub.require_look_at = 1;
		s_origin.unitrigger_stub.script_int = s_origin.script_int;
		zm_unitrigger::register_static_unitrigger(s_origin.unitrigger_stub, &maxis_audio_log_think);
	}
}

/*
	Name: discover_pack_a_punch
	Namespace: zm_tomb_vo
	Checksum: 0x10C2FC52
	Offset: 0x7178
	Size: 0x252
	Parameters: 0
	Flags: Linked
*/
function discover_pack_a_punch()
{
	t_pap_intro = getent("pack_a_punch_intro_trigger", "targetname");
	if(!isdefined(t_pap_intro))
	{
		return;
	}
	s_lookat = struct::get(t_pap_intro.target, "targetname");
	while(true)
	{
		t_pap_intro waittill(#"trigger", e_player);
		if(!isdefined(e_player.discover_pap_vo_played))
		{
			e_player.discover_pap_vo_played = 0;
		}
		if(!e_player.discover_pap_vo_played)
		{
			if((vectordot(anglestoforward(e_player getplayerangles()), vectornormalize(s_lookat.origin - e_player.origin))) > 0.8 && e_player can_player_speak())
			{
				e_player.discover_pap_vo_played = 1;
				e_player zm_audio::create_and_play_dialog("general", "pap_discovered");
				foreach(player in getplayers())
				{
					if(distance(player.origin, e_player.origin) < 800)
					{
						player.discover_pap_vo_played = 1;
					}
				}
			}
		}
	}
}

/*
	Name: can_player_speak
	Namespace: zm_tomb_vo
	Checksum: 0x659594B2
	Offset: 0x73D8
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function can_player_speak()
{
	return isplayer(self) && (!(isdefined(self.dontspeak) && self.dontspeak)) && self clientfield::get_to_player("isspeaking") == 0;
}

/*
	Name: maxis_audio_log_think
	Namespace: zm_tomb_vo
	Checksum: 0xBB4F01B8
	Offset: 0x7438
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function maxis_audio_log_think()
{
	self waittill(#"trigger", player);
	if(!isplayer(player) || !zombie_utility::is_player_valid(player))
	{
		return;
	}
	level thread play_maxis_audio_log(self.stub.origin, self.stub.script_int);
}

/*
	Name: play_maxis_audio_log
	Namespace: zm_tomb_vo
	Checksum: 0xA7B90476
	Offset: 0x74C8
	Size: 0x344
	Parameters: 2
	Flags: Linked
*/
function play_maxis_audio_log(v_trigger_origin, n_audiolog_id)
{
	a_audiolog = get_audiolog_vo();
	a_audiolog_to_play = a_audiolog[n_audiolog_id];
	if(n_audiolog_id == 4)
	{
		level flag::set("maxis_audiolog_gr0_playing");
	}
	else
	{
		if(n_audiolog_id == 5)
		{
			level flag::set("maxis_audiolog_gr1_playing");
		}
		else if(n_audiolog_id == 6)
		{
			level flag::set("maxis_audiolog_gr2_playing");
		}
	}
	e_vo_origin = spawn("script_origin", v_trigger_origin);
	level flag::set("maxis_audio_log_" + n_audiolog_id);
	a_s_triggers = struct::get_array("maxis_audio_log", "targetname");
	foreach(s_trigger in a_s_triggers)
	{
		if(s_trigger.script_int == n_audiolog_id)
		{
			break;
		}
	}
	level thread zm_unitrigger::unregister_unitrigger(s_trigger.unitrigger_stub);
	for(i = 0; i < a_audiolog_to_play.size; i++)
	{
		e_vo_origin playsoundwithnotify(a_audiolog_to_play[i], a_audiolog_to_play[i] + "_done");
		e_vo_origin waittill(a_audiolog_to_play[i] + "_done");
	}
	e_vo_origin delete();
	if(n_audiolog_id == 4)
	{
		level flag::clear("maxis_audiolog_gr0_playing");
	}
	else
	{
		if(n_audiolog_id == 5)
		{
			level flag::clear("maxis_audiolog_gr1_playing");
		}
		else if(n_audiolog_id == 6)
		{
			level flag::clear("maxis_audiolog_gr2_playing");
		}
	}
	level thread zm_unitrigger::register_static_unitrigger(s_trigger.unitrigger_stub, &maxis_audio_log_think);
}

/*
	Name: reset_maxis_audiolog_unitrigger
	Namespace: zm_tomb_vo
	Checksum: 0x7181D169
	Offset: 0x7818
	Size: 0x172
	Parameters: 1
	Flags: Linked
*/
function reset_maxis_audiolog_unitrigger(n_robot_id)
{
	if(n_robot_id == 0)
	{
		n_script_int = 4;
	}
	else
	{
		if(n_robot_id == 1)
		{
			n_script_int = 5;
		}
		else if(n_robot_id == 2)
		{
			n_script_int = 6;
		}
	}
	if(level flag::get("maxis_audio_log_" + n_script_int))
	{
		return;
	}
	a_s_radios = struct::get_array("maxis_audio_log", "targetname");
	foreach(s_origin in a_s_radios)
	{
		if(s_origin.script_int == n_script_int)
		{
			if(isdefined(s_origin.unitrigger_stub))
			{
				zm_unitrigger::unregister_unitrigger(s_origin.unitrigger_stub);
			}
		}
	}
}

/*
	Name: restart_maxis_audiolog_unitrigger
	Namespace: zm_tomb_vo
	Checksum: 0x22BFEC35
	Offset: 0x7998
	Size: 0x152
	Parameters: 1
	Flags: Linked
*/
function restart_maxis_audiolog_unitrigger(n_robot_id)
{
	if(n_robot_id == 0)
	{
		n_script_int = 4;
	}
	else
	{
		if(n_robot_id == 1)
		{
			n_script_int = 5;
		}
		else if(n_robot_id == 2)
		{
			n_script_int = 6;
		}
	}
	a_s_radios = struct::get_array("maxis_audio_log", "targetname");
	foreach(s_origin in a_s_radios)
	{
		if(s_origin.script_int == n_script_int)
		{
			if(isdefined(s_origin.unitrigger_stub))
			{
				zm_unitrigger::register_static_unitrigger(s_origin.unitrigger_stub, &maxis_audio_log_think);
			}
		}
	}
}

/*
	Name: get_audiolog_vo
	Namespace: zm_tomb_vo
	Checksum: 0xF4EE8E78
	Offset: 0x7AF8
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function get_audiolog_vo()
{
	a_audiologs = [];
	a_audiologs[1] = [];
	a_audiologs[1][0] = "vox_maxi_audio_log_1_1_0";
	a_audiologs[1][1] = "vox_maxi_audio_log_1_2_0";
	a_audiologs[1][2] = "vox_maxi_audio_log_1_3_0";
	a_audiologs[2] = [];
	a_audiologs[2][0] = "vox_maxi_audio_log_2_1_0";
	a_audiologs[2][1] = "vox_maxi_audio_log_2_2_0";
	a_audiologs[3] = [];
	a_audiologs[3][0] = "vox_maxi_audio_log_3_1_0";
	a_audiologs[3][1] = "vox_maxi_audio_log_3_2_0";
	a_audiologs[3][2] = "vox_maxi_audio_log_3_3_0";
	a_audiologs[4] = [];
	a_audiologs[4][0] = "vox_maxi_audio_log_4_1_0";
	a_audiologs[4][1] = "vox_maxi_audio_log_4_2_0";
	a_audiologs[4][2] = "vox_maxi_audio_log_4_3_0";
	a_audiologs[5] = [];
	a_audiologs[5][0] = "vox_maxi_audio_log_5_1_0";
	a_audiologs[5][1] = "vox_maxi_audio_log_5_2_0";
	a_audiologs[5][2] = "vox_maxi_audio_log_5_3_0";
	a_audiologs[6] = [];
	a_audiologs[6][0] = "vox_maxi_audio_log_6_1_0";
	a_audiologs[6][1] = "vox_maxi_audio_log_6_2_0";
	return a_audiologs;
}

/*
	Name: start_narrative_vo
	Namespace: zm_tomb_vo
	Checksum: 0xB3EE6EF0
	Offset: 0x7CF8
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function start_narrative_vo()
{
	level flag::wait_till("start_zombie_round_logic");
	set_players_dontspeak(1);
	wait(10);
	if(is_game_solo())
	{
		game_start_solo_vo();
	}
	else
	{
		game_start_vo();
	}
	level waittill(#"end_of_round");
	level thread round_two_end_narrative_vo();
	if(is_game_solo())
	{
		round_one_end_solo_vo();
	}
	else
	{
		round_one_end_vo();
	}
	level flag::set("round_one_narrative_vo_complete");
}

/*
	Name: start_samantha_intro_vo
	Namespace: zm_tomb_vo
	Checksum: 0x1CAC129B
	Offset: 0x7E08
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function start_samantha_intro_vo()
{
	while(true)
	{
		level waittill(#"start_of_round");
		if(level.round_number == 5)
		{
			samantha_intro_1();
		}
		else
		{
			if(level.round_number == 6)
			{
				samantha_intro_2();
			}
			else if(level.round_number == 7)
			{
				samantha_intro_3();
				level flag::set("samantha_intro_done");
				break;
			}
		}
	}
}

/*
	Name: samantha_intro_1
	Namespace: zm_tomb_vo
	Checksum: 0xEDE3ABE6
	Offset: 0x7EC8
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function samantha_intro_1()
{
	/#
		iprintln("");
	#/
	players = getplayers();
	if(!isdefined(players[0]))
	{
		return;
	}
	level flag::wait_till_clear("story_vo_playing");
	level flag::set("story_vo_playing");
	set_players_dontspeak(1);
	samanthasay("vox_sam_sam_help_5_0", players[0], 1, 1);
	players = getplayers();
	foreach(player in players)
	{
		if(player.character_name != "Richtofen")
		{
			player play_category_on_player_character_if_present("hear_samantha_1", player.character_name);
			wait(1);
			play_line_on_player_character_if_present("vox_plr_2_hear_samantha_1_0", "Richtofen");
			break;
		}
	}
	set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
}

/*
	Name: samantha_intro_2
	Namespace: zm_tomb_vo
	Checksum: 0x4E2919D6
	Offset: 0x80C8
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function samantha_intro_2()
{
	/#
		iprintln("");
	#/
	player_richtofen = get_player_character_if_present("Richtofen");
	if(!isdefined(player_richtofen))
	{
		return;
	}
	level flag::wait_till_clear("story_vo_playing");
	level flag::set("story_vo_playing");
	set_players_dontspeak(1);
	if(isdefined(player_richtofen))
	{
		nearest_friend = get_nearest_friend_within_speaking_distance(player_richtofen);
		if(isdefined(nearest_friend))
		{
			nearest_friend play_category_on_player_character_if_present("heroes_confer", nearest_friend.character_name);
			wait(1);
			play_line_on_player_character_if_present("vox_plr_2_heroes_confer_0", "Richtofen");
		}
	}
	set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
}

/*
	Name: samantha_intro_3
	Namespace: zm_tomb_vo
	Checksum: 0xD7834B0F
	Offset: 0x8240
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function samantha_intro_3()
{
	/#
		iprintln("");
	#/
	players = getplayers();
	if(!isdefined(players[0]))
	{
		return;
	}
	level flag::wait_till_clear("story_vo_playing");
	level flag::set("story_vo_playing");
	set_players_dontspeak(1);
	samanthasay("vox_sam_hear_samantha_3_0", players[0], 1, 1);
	players = getplayers();
	player = players[randomintrange(0, players.size)];
	if(isdefined(player))
	{
		player play_category_on_player_character_if_present("hear_samantha_3", player.character_name);
	}
	set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
}

/*
	Name: play_category_on_player_character_if_present
	Namespace: zm_tomb_vo
	Checksum: 0xCD6AFB23
	Offset: 0x83C8
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function play_category_on_player_character_if_present(category, character_name)
{
	vox_line_prefix = undefined;
	switch(character_name)
	{
		case "Dempsey":
		{
			vox_line_prefix = "vox_plr_0_";
			break;
		}
		case "Nikolai":
		{
			vox_line_prefix = "vox_plr_1_";
			break;
		}
		case "Richtofen":
		{
			vox_line_prefix = "vox_plr_2_";
			break;
		}
		case "Takeo":
		{
			vox_line_prefix = "vox_plr_3_";
			break;
		}
	}
	vox_line = (vox_line_prefix + category) + "_0";
	play_line_on_player_character_if_present(vox_line, character_name);
}

/*
	Name: get_nearest_friend_within_speaking_distance
	Namespace: zm_tomb_vo
	Checksum: 0xE4D079DA
	Offset: 0x84A8
	Size: 0x13C
	Parameters: 1
	Flags: Linked
*/
function get_nearest_friend_within_speaking_distance(other_player)
{
	distance_nearest = 800;
	nearest_friend = undefined;
	players = getplayers();
	foreach(player in players)
	{
		distance_between_players = distance(player.origin, other_player.origin);
		if(player != other_player && distance_between_players < distance_nearest)
		{
			nearest_friend = player;
			distance_nearest = distance_between_players;
		}
	}
	if(isdefined(nearest_friend))
	{
		return nearest_friend;
	}
	return undefined;
}

/*
	Name: play_line_on_player_character_if_present
	Namespace: zm_tomb_vo
	Checksum: 0x3ADFE94B
	Offset: 0x85F0
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function play_line_on_player_character_if_present(vox_line, character_name)
{
	player_character = get_player_character_if_present(character_name);
	if(isdefined(player_character))
	{
		/#
			iprintln((("" + character_name) + "") + vox_line);
		#/
		player_character playsoundwithnotify(vox_line, "sound_done" + vox_line);
		player_character waittill("sound_done" + vox_line);
		return true;
	}
	return false;
}

/*
	Name: get_player_character_if_present
	Namespace: zm_tomb_vo
	Checksum: 0x2DD2CC34
	Offset: 0x86B8
	Size: 0xB6
	Parameters: 1
	Flags: Linked
*/
function get_player_character_if_present(character_name)
{
	players = getplayers();
	foreach(player in players)
	{
		if(player.character_name == character_name)
		{
			return player;
		}
	}
	return undefined;
}

/*
	Name: round_two_end_narrative_vo
	Namespace: zm_tomb_vo
	Checksum: 0xFE193631
	Offset: 0x8778
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function round_two_end_narrative_vo()
{
	level waittill(#"end_of_round");
	level flag::wait_till("round_one_narrative_vo_complete");
	if(level flag::get("generator_find_vo_playing"))
	{
		level flag::wait_till_clear("generator_find_vo_playing");
		wait(3);
	}
	if(is_game_solo())
	{
		round_two_end_solo_vo();
	}
}

/*
	Name: game_start_solo_vo
	Namespace: zm_tomb_vo
	Checksum: 0x640FF320
	Offset: 0x8820
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function game_start_solo_vo()
{
	if(level flag::get("story_vo_playing"))
	{
		return;
	}
	players = getplayers();
	e_speaker = players[0];
	if(!isdefined(e_speaker))
	{
		return;
	}
	a_convo = build_game_start_solo_convo();
	level flag::set("story_vo_playing");
	set_players_dontspeak(1);
	lines = a_convo[e_speaker.character_name];
	if(isarray(lines))
	{
		for(i = 0; i < lines.size; i++)
		{
			e_speaker playsoundwithnotify(lines[i], "sound_done" + lines[i]);
			e_speaker waittill("sound_done" + lines[i]);
			wait(1);
		}
	}
	else
	{
		e_speaker playsoundwithnotify(a_convo[e_speaker.character_name], "sound_done" + a_convo[e_speaker.character_name]);
		e_speaker waittill("sound_done" + a_convo[e_speaker.character_name]);
	}
	set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
}

/*
	Name: build_game_start_solo_convo
	Namespace: zm_tomb_vo
	Checksum: 0xF2A82FB
	Offset: 0x8A48
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function build_game_start_solo_convo()
{
	a_game_start_solo_convo = [];
	a_game_start_solo_convo["Dempsey"] = "vox_plr_0_game_start_0";
	a_game_start_solo_convo["Nikolai"] = "vox_plr_1_game_start_0";
	a_game_start_solo_convo["Richtofen"] = [];
	a_game_start_solo_convo["Richtofen"][0] = "vox_plr_2_game_start_0";
	a_game_start_solo_convo["Richtofen"][1] = "vox_plr_2_game_start_1";
	a_game_start_solo_convo["Takeo"] = "vox_plr_3_game_start_0";
	return a_game_start_solo_convo;
}

/*
	Name: game_start_vo
	Namespace: zm_tomb_vo
	Checksum: 0x85BC9278
	Offset: 0x8AF8
	Size: 0x454
	Parameters: 0
	Flags: Linked
*/
function game_start_vo()
{
	players = getplayers();
	if(players.size <= 1)
	{
		return;
	}
	if(level flag::get("story_vo_playing"))
	{
		return;
	}
	a_game_start_convo = build_game_start_convo();
	level flag::set("story_vo_playing");
	e_dempsey = undefined;
	e_nikolai = undefined;
	e_richtofen = undefined;
	e_takeo = undefined;
	foreach(player in players)
	{
		if(isdefined(player))
		{
			switch(player.character_name)
			{
				case "Dempsey":
				{
					e_dempsey = player;
					break;
				}
				case "Nikolai":
				{
					e_nikolai = player;
					break;
				}
				case "Richtofen":
				{
					e_richtofen = player;
					break;
				}
				case "Takeo":
				{
					e_takeo = player;
					break;
				}
			}
		}
	}
	set_players_dontspeak(1);
	for(i = 0; i < a_game_start_convo.size; i++)
	{
		players = getplayers();
		if(players.size <= 1)
		{
			set_players_dontspeak(0);
			level flag::clear("story_vo_playing");
			return;
		}
		if(!isdefined(e_richtofen))
		{
			continue;
		}
		line_number = i + 1;
		if(line_number == 2)
		{
			a_richtofen_lines = a_game_start_convo["line_" + line_number];
			for(j = 0; j < a_richtofen_lines.size; j++)
			{
				e_richtofen playsoundwithnotify(a_richtofen_lines[j], "sound_done" + a_richtofen_lines[j]);
				e_richtofen waittill("sound_done" + a_richtofen_lines[j]);
			}
			continue;
		}
		arrayremovevalue(players, e_richtofen);
		players = util::get_array_of_closest(e_richtofen.origin, players);
		e_speaker = players[0];
		if(!isdefined(e_speaker))
		{
			continue;
		}
		e_speaker playsoundwithnotify(a_game_start_convo["line_" + line_number][e_speaker.character_name], "sound_done" + (a_game_start_convo["line_" + line_number][e_speaker.character_name]));
		e_speaker waittill("sound_done" + (a_game_start_convo["line_" + line_number][e_speaker.character_name]));
	}
	set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
}

/*
	Name: build_game_start_convo
	Namespace: zm_tomb_vo
	Checksum: 0x2ADDD75C
	Offset: 0x8F58
	Size: 0x148
	Parameters: 0
	Flags: Linked
*/
function build_game_start_convo()
{
	a_game_start_convo = [];
	a_game_start_convo["line_1"] = [];
	a_game_start_convo["line_1"]["Dempsey"] = "vox_plr_0_game_start_meet_2_0";
	a_game_start_convo["line_1"]["Nikolai"] = "vox_plr_1_game_start_meet_1_0";
	a_game_start_convo["line_1"]["Takeo"] = "vox_plr_3_game_start_meet_3_0";
	a_game_start_convo["line_2"] = [];
	a_game_start_convo["line_2"][0] = "vox_plr_2_game_start_meet_4_0";
	a_game_start_convo["line_2"][1] = "vox_plr_2_generator_find_0";
	a_game_start_convo["line_3"] = [];
	a_game_start_convo["line_3"]["Dempsey"] = "vox_plr_0_generator_find_0";
	a_game_start_convo["line_3"]["Nikolai"] = "vox_plr_1_generator_find_0";
	a_game_start_convo["line_3"]["Takeo"] = "vox_plr_3_generator_find_0";
	return a_game_start_convo;
}

/*
	Name: run_staff_crafted_vo
	Namespace: zm_tomb_vo
	Checksum: 0xC726A922
	Offset: 0x90A8
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function run_staff_crafted_vo(str_sam_line)
{
	wait(1);
	while(isdefined(self.isspeaking) && self.isspeaking)
	{
		util::wait_network_frame();
	}
	if(level.n_staffs_crafted == 4)
	{
		all_staffs_crafted_vo();
	}
	else if(isdefined(str_sam_line))
	{
		level flag::wait_till_clear("story_vo_playing");
		level flag::set("story_vo_playing");
		set_players_dontspeak(1);
		samanthasay(str_sam_line, self, 1);
		set_players_dontspeak(0);
		level flag::clear("story_vo_playing");
	}
}

/*
	Name: staff_craft_vo
	Namespace: zm_tomb_vo
	Checksum: 0x589509CC
	Offset: 0x91D0
	Size: 0xE8
	Parameters: 0
	Flags: None
*/
function staff_craft_vo()
{
	staff_crafted = [];
	lines = array("vox_sam_1st_staff_crafted_0", "vox_sam_2nd_staff_crafted_0", "vox_sam_3rd_staff_crafted_0");
	while(staff_crafted.size < 4)
	{
		level waittill(#"staff_crafted_vo", e_crafter, n_element);
		if(!(isdefined(staff_crafted[n_element]) && staff_crafted[n_element]))
		{
			staff_crafted[n_element] = 1;
			line = lines[level.n_staffs_crafted - 1];
			e_crafter thread run_staff_crafted_vo(line);
		}
	}
}

/*
	Name: all_staffs_crafted_vo
	Namespace: zm_tomb_vo
	Checksum: 0x9FE70590
	Offset: 0x92C0
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function all_staffs_crafted_vo()
{
	while(level flag::get("story_vo_playing"))
	{
		util::wait_network_frame();
	}
	a_convo = build_all_staffs_crafted_vo();
	level flag::set("story_vo_playing");
	set_players_dontspeak(1);
	for(i = 0; i < a_convo.size; i++)
	{
		line_number = i + 1;
		index = "line_" + line_number;
		if(isdefined(a_convo[index]["Sam"]))
		{
			samanthasay(a_convo[index]["Sam"], self);
			continue;
		}
		line = a_convo[index][self.character_name];
		self playsoundwithnotify(line, "sound_done" + line);
		self waittill("sound_done" + line);
	}
	set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
}

/*
	Name: build_all_staffs_crafted_vo
	Namespace: zm_tomb_vo
	Checksum: 0x9B658B5
	Offset: 0x9488
	Size: 0x1DC
	Parameters: 0
	Flags: Linked
*/
function build_all_staffs_crafted_vo()
{
	a_staff_convo = [];
	a_staff_convo["line_1"] = [];
	a_staff_convo["line_1"]["Sam"] = "vox_sam_4th_staff_crafted_0";
	a_staff_convo["line_2"] = [];
	a_staff_convo["line_2"]["Dempsey"] = "vox_plr_0_4th_staff_crafted_0";
	a_staff_convo["line_2"]["Nikolai"] = "vox_plr_1_4th_staff_crafted_0";
	a_staff_convo["line_2"]["Richtofen"] = "vox_plr_2_4th_staff_crafted_0";
	a_staff_convo["line_2"]["Takeo"] = "vox_plr_3_4th_staff_crafted_0";
	a_staff_convo["line_3"] = [];
	a_staff_convo["line_3"]["Sam"] = "vox_sam_4th_staff_crafted_1";
	a_staff_convo["line_4"] = [];
	a_staff_convo["line_4"]["Dempsey"] = "vox_plr_0_4th_staff_crafted_1";
	a_staff_convo["line_4"]["Nikolai"] = "vox_plr_1_4th_staff_crafted_1";
	a_staff_convo["line_4"]["Richtofen"] = "vox_plr_2_4th_staff_crafted_1";
	a_staff_convo["line_4"]["Takeo"] = "vox_plr_3_4th_staff_crafted_1";
	a_staff_convo["line_5"] = [];
	a_staff_convo["line_5"]["Sam"] = "vox_sam_generic_encourage_6";
	return a_staff_convo;
}

/*
	Name: get_left_behind_plea
	Namespace: zm_tomb_vo
	Checksum: 0x79BABA5C
	Offset: 0x9670
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function get_left_behind_plea()
{
	pl_num = 0;
	if(self.character_name == "Nikolai")
	{
		pl_num = 1;
	}
	else
	{
		if(self.character_name == "Richtofen")
		{
			pl_num = 2;
		}
		else if(self.character_name == "Takeo")
		{
			pl_num = 3;
		}
	}
	return (("vox_plr_" + pl_num) + "_miss_tank_") + randomint(3);
}

/*
	Name: get_left_behind_response
	Namespace: zm_tomb_vo
	Checksum: 0x7395AD6B
	Offset: 0x9720
	Size: 0x2CA
	Parameters: 1
	Flags: Linked
*/
function get_left_behind_response(e_victim)
{
	if(self.character_name == "Dempsey")
	{
		if(math::cointoss())
		{
			return "vox_plr_0_tank_rspnd_generic_0";
		}
		if(e_victim.character_name == "Nikolai")
		{
			return "vox_plr_0_tank_rspnd_to_plr_1_0";
		}
		if(e_victim.character_name == "Richtofen")
		{
			return "vox_plr_0_tank_rspnd_to_plr_2_0";
		}
		if(e_victim.character_name == "Takeo")
		{
			return "vox_plr_0_tank_rspnd_to_plr_3_0";
		}
	}
	else
	{
		if(self.character_name == "Nikolai")
		{
			if(math::cointoss())
			{
				return "vox_plr_1_tank_rspnd_generic_0";
			}
			if(e_victim.character_name == "Dempsey")
			{
				return "vox_plr_1_tank_rspnd_to_plr_0_0";
			}
			if(e_victim.character_name == "Richtofen")
			{
				return "vox_plr_1_tank_rspnd_to_plr_2_0";
			}
			if(e_victim.character_name == "Takeo")
			{
				return "vox_plr_1_tank_rspnd_to_plr_3_0";
			}
		}
		else
		{
			if(self.character_name == "Richtofen")
			{
				if(math::cointoss())
				{
					return "vox_plr_2_tank_rspnd_generic_0";
				}
				if(e_victim.character_name == "Dempsey")
				{
					return "vox_plr_2_tank_rspnd_to_plr_0_0";
				}
				if(e_victim.character_name == "Nikolai")
				{
					return "vox_plr_2_tank_rspnd_to_plr_1_0";
				}
				if(e_victim.character_name == "Takeo")
				{
					return "vox_plr_2_tank_rspnd_to_plr_3_0";
				}
			}
			else if(self.character_name == "Takeo")
			{
				if(math::cointoss())
				{
					return "vox_plr_3_tank_rspnd_generic_0";
				}
				if(e_victim.character_name == "Dempsey")
				{
					return "vox_plr_3_tank_rspnd_to_plr_0_0";
				}
				if(e_victim.character_name == "Nikolai")
				{
					return "vox_plr_3_tank_rspnd_to_plr_1_0";
				}
				if(e_victim.character_name == "Richtofen")
				{
					return "vox_plr_3_tank_rspnd_to_plr_2_0";
				}
			}
		}
	}
	return undefined;
}

/*
	Name: tank_left_behind_vo
	Namespace: zm_tomb_vo
	Checksum: 0xB33F8D01
	Offset: 0x99F8
	Size: 0x1CC
	Parameters: 2
	Flags: Linked
*/
function tank_left_behind_vo(e_victim, e_rider)
{
	if(!isdefined(e_victim) || !isdefined(e_rider))
	{
		return;
	}
	if(level flag::get("story_vo_playing"))
	{
		return;
	}
	level flag::set("story_vo_playing");
	set_players_dontspeak(1);
	e_victim.isspeaking = 1;
	e_rider.isspeaking = 1;
	str_plea_line = e_victim get_left_behind_plea();
	e_victim playsoundwithnotify(str_plea_line, "sound_done" + str_plea_line);
	e_victim waittill("sound_done" + str_plea_line);
	str_rider_line = e_rider get_left_behind_response(e_victim);
	e_victim playsoundwithnotify(str_rider_line, "sound_done" + str_rider_line);
	e_victim waittill("sound_done" + str_rider_line);
	e_victim.isspeaking = 0;
	e_rider.isspeaking = 0;
	set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
}

/*
	Name: round_one_end_solo_vo
	Namespace: zm_tomb_vo
	Checksum: 0xB7870F3D
	Offset: 0x9BD0
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function round_one_end_solo_vo()
{
	if(level flag::get("story_vo_playing"))
	{
		return;
	}
	players = getplayers();
	e_speaker = players[0];
	if(!isdefined(e_speaker))
	{
		return;
	}
	a_convo = build_round_one_end_solo_convo();
	level flag::set("story_vo_playing");
	set_players_dontspeak(1);
	lines = a_convo[e_speaker.character_name];
	if(isarray(lines))
	{
		for(i = 0; i < lines.size; i++)
		{
			e_speaker playsoundwithnotify(lines[i], "sound_done" + lines[i]);
			e_speaker waittill("sound_done" + lines[i]);
			wait(1);
		}
	}
	else
	{
		e_speaker playsoundwithnotify(a_convo[e_speaker.character_name], "sound_done" + a_convo[e_speaker.character_name]);
		e_speaker waittill("sound_done" + a_convo[e_speaker.character_name]);
	}
	set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
}

/*
	Name: build_round_one_end_solo_convo
	Namespace: zm_tomb_vo
	Checksum: 0xE55666DF
	Offset: 0x9DF8
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function build_round_one_end_solo_convo()
{
	a_round_one_end_solo_convo = [];
	a_round_one_end_solo_convo["Dempsey"] = [];
	a_round_one_end_solo_convo["Dempsey"][0] = "vox_plr_0_end_round_1_5_0";
	a_round_one_end_solo_convo["Dempsey"][1] = "vox_plr_0_end_round_1_6_1";
	a_round_one_end_solo_convo["Nikolai"] = "vox_plr_1_end_round_1_9_0";
	a_round_one_end_solo_convo["Richtofen"] = "vox_plr_2_end_round_1_7_0";
	a_round_one_end_solo_convo["Takeo"] = "vox_plr_3_end_round_1_8_0";
	return a_round_one_end_solo_convo;
}

/*
	Name: round_one_end_vo
	Namespace: zm_tomb_vo
	Checksum: 0x5CBBF9E7
	Offset: 0x9EA8
	Size: 0x454
	Parameters: 0
	Flags: Linked
*/
function round_one_end_vo()
{
	players = getplayers();
	if(players.size <= 1)
	{
		return;
	}
	if(level flag::get("story_vo_playing"))
	{
		return;
	}
	a_convo = build_round_one_end_convo();
	level flag::set("story_vo_playing");
	e_dempsey = undefined;
	e_nikolai = undefined;
	e_richtofen = undefined;
	e_takeo = undefined;
	foreach(player in players)
	{
		if(isdefined(player))
		{
			switch(player.character_name)
			{
				case "Dempsey":
				{
					e_dempsey = player;
					break;
				}
				case "Nikolai":
				{
					e_nikolai = player;
					break;
				}
				case "Richtofen":
				{
					e_richtofen = player;
					break;
				}
				case "Takeo":
				{
					e_takeo = player;
					break;
				}
			}
		}
	}
	set_players_dontspeak(1);
	for(i = 0; i < a_convo.size; i++)
	{
		players = getplayers();
		if(players.size <= 1)
		{
			set_players_dontspeak(0);
			level flag::clear("story_vo_playing");
			return;
		}
		if(!isdefined(e_richtofen))
		{
			continue;
		}
		line_number = i + 1;
		if(line_number == 2)
		{
			a_richtofen_lines = a_convo["line_" + line_number];
			for(j = 0; j < a_richtofen_lines.size; j++)
			{
				e_richtofen playsoundwithnotify(a_richtofen_lines[j], "sound_done" + a_richtofen_lines[j]);
				e_richtofen waittill("sound_done" + a_richtofen_lines[j]);
			}
			continue;
		}
		arrayremovevalue(players, e_richtofen);
		players = util::get_array_of_closest(e_richtofen.origin, players);
		e_speaker = players[0];
		if(!isdefined(e_speaker))
		{
			continue;
		}
		e_speaker playsoundwithnotify(a_convo["line_" + line_number][e_speaker.character_name], "sound_done" + (a_convo["line_" + line_number][e_speaker.character_name]));
		e_speaker waittill("sound_done" + (a_convo["line_" + line_number][e_speaker.character_name]));
	}
	set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
}

/*
	Name: build_round_one_end_convo
	Namespace: zm_tomb_vo
	Checksum: 0xA89167F3
	Offset: 0xA308
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function build_round_one_end_convo()
{
	a_round_one_end_convo = [];
	a_round_one_end_convo["line_1"] = [];
	a_round_one_end_convo["line_1"]["Dempsey"] = "vox_plr_0_end_round_1_1_0";
	a_round_one_end_convo["line_1"]["Nikolai"] = "vox_plr_1_end_round_1_3_0";
	a_round_one_end_convo["line_1"]["Takeo"] = "vox_plr_3_end_round_1_2_0";
	a_round_one_end_convo["line_2"] = [];
	a_round_one_end_convo["line_2"][0] = "vox_plr_2_story_exposition_4_0";
	a_round_one_end_convo["line_3"] = [];
	a_round_one_end_convo["line_3"]["Dempsey"] = "vox_plr_0_during_round_1_0";
	a_round_one_end_convo["line_3"]["Nikolai"] = "vox_plr_1_during_round_2_0";
	a_round_one_end_convo["line_3"]["Takeo"] = "vox_plr_3_during_round_2_0";
	return a_round_one_end_convo;
}

/*
	Name: round_two_end_solo_vo
	Namespace: zm_tomb_vo
	Checksum: 0x9E1771D0
	Offset: 0xA440
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function round_two_end_solo_vo()
{
	if(level flag::get("story_vo_playing"))
	{
		return;
	}
	players = getplayers();
	e_speaker = players[0];
	if(!isdefined(e_speaker))
	{
		return;
	}
	a_convo = build_round_two_end_solo_convo();
	level flag::set("story_vo_playing");
	set_players_dontspeak(1);
	lines = a_convo[e_speaker.character_name];
	if(isarray(lines))
	{
		for(i = 0; i < lines.size; i++)
		{
			e_speaker playsoundwithnotify(lines[i], "sound_done" + lines[i]);
			e_speaker waittill("sound_done" + lines[i]);
			wait(1);
		}
	}
	else
	{
		e_speaker playsoundwithnotify(a_convo[e_speaker.character_name], "sound_done" + a_convo[e_speaker.character_name]);
		e_speaker waittill("sound_done" + a_convo[e_speaker.character_name]);
	}
	set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
}

/*
	Name: build_round_two_end_solo_convo
	Namespace: zm_tomb_vo
	Checksum: 0x4884771C
	Offset: 0xA668
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function build_round_two_end_solo_convo()
{
	a_round_two_end_solo_convo = [];
	a_round_two_end_solo_convo["Dempsey"] = "vox_plr_0_end_round_2_1_0";
	a_round_two_end_solo_convo["Nikolai"] = "vox_plr_1_end_round_2_5_0";
	a_round_two_end_solo_convo["Richtofen"] = [];
	a_round_two_end_solo_convo["Richtofen"][0] = "vox_plr_2_end_round_2_2_0";
	a_round_two_end_solo_convo["Richtofen"][1] = "vox_plr_2_end_round_2_3_1";
	a_round_two_end_solo_convo["Takeo"] = "vox_plr_3_end_round_2_4_0";
	return a_round_two_end_solo_convo;
}

/*
	Name: first_magic_box_seen_vo
	Namespace: zm_tomb_vo
	Checksum: 0x1AF80BD0
	Offset: 0xA718
	Size: 0xF2
	Parameters: 0
	Flags: Linked
*/
function first_magic_box_seen_vo()
{
	level flag::wait_till("start_zombie_round_logic");
	magicbox = level.chests[level.chest_index];
	a_players = getplayers();
	foreach(player in a_players)
	{
		player thread wait_and_play_first_magic_box_seen_vo(magicbox.unitrigger_stub);
	}
}

/*
	Name: wait_and_play_first_magic_box_seen_vo
	Namespace: zm_tomb_vo
	Checksum: 0x11A15772
	Offset: 0xA818
	Size: 0x5EC
	Parameters: 1
	Flags: Linked
*/
function wait_and_play_first_magic_box_seen_vo(struct)
{
	self endon(#"disconnect");
	level endon(#"first_maigc_box_discovered");
	while(true)
	{
		if(distancesquared(self.origin, struct.origin) < 40000)
		{
			if(self zm_utility::is_player_looking_at(struct.origin, 0.75))
			{
				if(!(isdefined(self.dontspeak) && self.dontspeak))
				{
					if(level flag::get("story_vo_playing"))
					{
						wait(0.1);
						continue;
					}
					players = getplayers();
					a_speakers = [];
					foreach(player in players)
					{
						if(isdefined(player) && distance2dsquared(player.origin, self.origin) <= 1000000)
						{
							switch(player.character_name)
							{
								case "Dempsey":
								{
									e_dempsey = player;
									a_speakers[a_speakers.size] = e_dempsey;
									break;
								}
								case "Nikolai":
								{
									e_nikolai = player;
									a_speakers[a_speakers.size] = e_nikolai;
									break;
								}
								case "Richtofen":
								{
									e_richtofen = player;
									a_speakers[a_speakers.size] = e_richtofen;
									break;
								}
								case "Takeo":
								{
									e_takeo = player;
									a_speakers[a_speakers.size] = e_takeo;
									break;
								}
							}
						}
					}
					if(!isdefined(e_richtofen))
					{
						wait(0.1);
						continue;
					}
					if(a_speakers.size < 2)
					{
						wait(0.1);
						continue;
					}
					level flag::set("story_vo_playing");
					set_players_dontspeak(1);
					a_convo = build_first_magic_box_seen_vo();
					if(isdefined(e_richtofen))
					{
						e_richtofen playsoundwithnotify(a_convo[0][e_richtofen.character_name], "sound_done" + a_convo[0][e_richtofen.character_name]);
						e_richtofen waittill("sound_done" + a_convo[0][e_richtofen.character_name]);
					}
					if(isdefined(struct.trigger_target) && isdefined(struct.trigger_target.is_locked))
					{
						arrayremovevalue(a_speakers, e_richtofen);
						a_speakers = util::get_array_of_closest(e_richtofen.origin, a_speakers);
						e_speaker = a_speakers[0];
						if(distancesquared(e_speaker.origin, e_richtofen.origin) < 2250000)
						{
							if(isdefined(e_speaker))
							{
								e_speaker playsoundwithnotify(a_convo[1][e_speaker.character_name], "sound_done" + a_convo[1][e_speaker.character_name]);
								e_speaker waittill("sound_done" + a_convo[1][e_speaker.character_name]);
							}
						}
					}
					if(isdefined(struct.trigger_target) && isdefined(struct.trigger_target.is_locked))
					{
						if(struct.trigger_target.is_locked == 1)
						{
							if(isdefined(e_richtofen))
							{
								e_richtofen playsoundwithnotify(a_convo[2][e_richtofen.character_name], "sound_done" + a_convo[2][e_richtofen.character_name]);
								e_richtofen waittill("sound_done" + a_convo[2][e_richtofen.character_name]);
							}
						}
					}
					set_players_dontspeak(0);
					level flag::clear("story_vo_playing");
					level notify(#"first_maigc_box_discovered");
					break;
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: build_first_magic_box_seen_vo
	Namespace: zm_tomb_vo
	Checksum: 0x53667BC1
	Offset: 0xAE10
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function build_first_magic_box_seen_vo()
{
	a_first_magic_box_seen_convo = [];
	a_first_magic_box_seen_convo[0] = [];
	a_first_magic_box_seen_convo[0]["Richtofen"] = "vox_plr_2_respond_maxis_1_0";
	a_first_magic_box_seen_convo[1] = [];
	a_first_magic_box_seen_convo[1]["Dempsey"] = "vox_plr_0_respond_maxis_2_0";
	a_first_magic_box_seen_convo[1]["Takeo"] = "vox_plr_3_respond_maxis_3_0";
	a_first_magic_box_seen_convo[1]["Nikolai"] = "vox_plr_1_respond_maxis_4_0";
	a_first_magic_box_seen_convo[2] = [];
	a_first_magic_box_seen_convo[2]["Richtofen"] = "vox_plr_2_respond_maxis_5_0";
	return a_first_magic_box_seen_convo;
}

/*
	Name: tomb_drone_built_vo
	Namespace: zm_tomb_vo
	Checksum: 0xCD5D3CFE
	Offset: 0xAEE8
	Size: 0x2DC
	Parameters: 1
	Flags: Linked
*/
function tomb_drone_built_vo(s_craftable)
{
	if(s_craftable.weaponname.name != "equip_dieseldrone")
	{
		return;
	}
	level flag::wait_till_clear("story_vo_playing");
	level flag::set("story_vo_playing");
	set_players_dontspeak(1);
	wait(1);
	e_vo_origin = get_speaking_location_maxis_drone(self, s_craftable);
	vox_line = "vox_maxi_maxis_drone_1_0";
	e_vo_origin playsoundwithnotify(vox_line, "sound_done" + vox_line);
	/#
		iprintln("" + vox_line);
	#/
	e_vo_origin waittill("sound_done" + vox_line);
	e_vo_origin delete();
	wait(1);
	e_vo_origin = get_speaking_location_maxis_drone(self, s_craftable);
	vox_line = "vox_maxi_maxis_drone_4_0";
	e_vo_origin playsoundwithnotify(vox_line, "sound_done" + vox_line);
	/#
		iprintln("" + vox_line);
	#/
	e_vo_origin waittill("sound_done" + vox_line);
	e_vo_origin delete();
	wait(1);
	if(isdefined(self) && self.character_name == "Richtofen")
	{
		vox_line = "vox_plr_2_maxis_drone_5_0";
		/#
			iprintln((("" + self.character_name) + "") + vox_line);
		#/
		self playsoundwithnotify(vox_line, "sound_done" + vox_line);
		self waittill("sound_done" + vox_line);
	}
	set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
	level flag::set("maxis_crafted_intro_done");
}

/*
	Name: get_speaking_location_maxis_drone
	Namespace: zm_tomb_vo
	Checksum: 0x580B6392
	Offset: 0xB1D0
	Size: 0x11C
	Parameters: 2
	Flags: Linked
*/
function get_speaking_location_maxis_drone(player, s_craftable)
{
	e_vo_origin = undefined;
	if(isdefined(level.maxis_quadrotor))
	{
		e_vo_origin = spawn("script_origin", level.maxis_quadrotor.origin);
		e_vo_origin linkto(level.maxis_quadrotor);
	}
	else
	{
		player = b_player_has_dieseldrone_weapon();
		if(isdefined(player))
		{
			e_vo_origin = spawn("script_origin", player.origin);
			e_vo_origin linkto(player);
		}
		else
		{
			e_vo_origin = spawn("script_origin", s_craftable.origin);
		}
	}
	return e_vo_origin;
}

/*
	Name: b_player_has_dieseldrone_weapon
	Namespace: zm_tomb_vo
	Checksum: 0xC8740FE5
	Offset: 0xB2F8
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function b_player_has_dieseldrone_weapon()
{
	a_players = getplayers();
	var_703e6a13 = getweapon("equip_dieseldrone");
	foreach(player in a_players)
	{
		if(player hasweapon(var_703e6a13))
		{
			return player;
		}
	}
	return undefined;
}

/*
	Name: set_players_dontspeak
	Namespace: zm_tomb_vo
	Checksum: 0xC08C2B44
	Offset: 0xB3E0
	Size: 0x222
	Parameters: 1
	Flags: Linked
*/
function set_players_dontspeak(bool)
{
	players = getplayers();
	if(bool)
	{
		foreach(player in players)
		{
			if(isdefined(player))
			{
				player.dontspeak = 1;
				player clientfield::set_to_player("isspeaking", 1);
			}
		}
		foreach(player in players)
		{
			while(isdefined(player) && (isdefined(player.isspeaking) && player.isspeaking))
			{
				wait(0.1);
			}
		}
	}
	else
	{
		foreach(player in players)
		{
			if(isdefined(player))
			{
				player.dontspeak = 0;
				player clientfield::set_to_player("isspeaking", 0);
			}
		}
	}
}

/*
	Name: set_player_dontspeak
	Namespace: zm_tomb_vo
	Checksum: 0xEA6B7D74
	Offset: 0xB610
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function set_player_dontspeak(bool)
{
	if(bool)
	{
		self.dontspeak = 1;
		self clientfield::set_to_player("isspeaking", 1);
		while(isdefined(self) && (isdefined(self.isspeaking) && self.isspeaking))
		{
			wait(0.1);
		}
	}
	else
	{
		self.dontspeak = 0;
		self clientfield::set_to_player("isspeaking", 0);
	}
}

/*
	Name: is_game_solo
	Namespace: zm_tomb_vo
	Checksum: 0x5E328D43
	Offset: 0xB6B8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function is_game_solo()
{
	players = getplayers();
	if(players.size == 1)
	{
		return true;
	}
	return false;
}

/*
	Name: add_puzzle_completion_line
	Namespace: zm_tomb_vo
	Checksum: 0x2A7EC1F6
	Offset: 0xB700
	Size: 0x108
	Parameters: 2
	Flags: Linked
*/
function add_puzzle_completion_line(n_element_enum, str_line)
{
	if(!isdefined(level.puzzle_completion_lines))
	{
		level.puzzle_completion_lines = [];
		level.puzzle_completion_lines_count = [];
	}
	if(!isdefined(level.puzzle_completion_lines[n_element_enum]))
	{
		level.puzzle_completion_lines[n_element_enum] = [];
		level.puzzle_completion_lines_count[n_element_enum] = 0;
	}
	if(!isdefined(level.puzzle_completion_lines[n_element_enum]))
	{
		level.puzzle_completion_lines[n_element_enum] = [];
	}
	else if(!isarray(level.puzzle_completion_lines[n_element_enum]))
	{
		level.puzzle_completion_lines[n_element_enum] = array(level.puzzle_completion_lines[n_element_enum]);
	}
	level.puzzle_completion_lines[n_element_enum][level.puzzle_completion_lines[n_element_enum].size] = str_line;
}

/*
	Name: say_puzzle_completion_line
	Namespace: zm_tomb_vo
	Checksum: 0x69C0A4A3
	Offset: 0xB810
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function say_puzzle_completion_line(n_element_enum)
{
	level notify(#"quest_progressed");
	wait(4);
	if(level.puzzle_completion_lines_count[n_element_enum] >= level.puzzle_completion_lines[n_element_enum].size)
	{
		/#
			iprintlnbold("" + n_element_enum);
		#/
		return;
	}
	str_line = level.puzzle_completion_lines[n_element_enum][level.puzzle_completion_lines_count[n_element_enum]];
	level.puzzle_completion_lines_count[n_element_enum]++;
	set_players_dontspeak(1);
	level samanthasay(str_line, self);
	set_players_dontspeak(0);
}

/*
	Name: watch_occasional_line
	Namespace: zm_tomb_vo
	Checksum: 0x3355B15E
	Offset: 0xB908
	Size: 0xC4
	Parameters: 5
	Flags: Linked
*/
function watch_occasional_line(str_category, str_line, str_notify, n_time_between = 30, n_times_to_play = 100)
{
	for(i = 0; i < n_times_to_play; i++)
	{
		level waittill(str_notify, e_player);
		if(isdefined(e_player))
		{
			e_player zm_audio::create_and_play_dialog(str_category, str_line);
			wait(n_time_between);
		}
	}
}

/*
	Name: watch_one_shot_line
	Namespace: zm_tomb_vo
	Checksum: 0x8F561DE2
	Offset: 0xB9D8
	Size: 0x6A
	Parameters: 3
	Flags: Linked
*/
function watch_one_shot_line(str_category, str_line, str_notify)
{
	while(true)
	{
		level waittill(str_notify, e_player);
		if(isdefined(e_player))
		{
			e_player zm_audio::create_and_play_dialog(str_category, str_line);
			return;
		}
	}
}

/*
	Name: watch_one_shot_samantha_line
	Namespace: zm_tomb_vo
	Checksum: 0x2248FB5F
	Offset: 0xBA50
	Size: 0xA0
	Parameters: 2
	Flags: Linked
*/
function watch_one_shot_samantha_line(str_line, str_notify)
{
	while(true)
	{
		level waittill(str_notify, e_play_on);
		if(isdefined(e_play_on))
		{
			set_players_dontspeak(1);
			if(samanthasay(str_line, e_play_on))
			{
				set_players_dontspeak(0);
				return;
			}
			set_players_dontspeak(0);
		}
	}
}

/*
	Name: watch_one_shot_samantha_clue
	Namespace: zm_tomb_vo
	Checksum: 0x5C311956
	Offset: 0xBAF8
	Size: 0x372
	Parameters: 3
	Flags: Linked
*/
function watch_one_shot_samantha_clue(str_line, str_notify, str_endon)
{
	if(isdefined(str_endon))
	{
		level endon(str_endon);
	}
	if(!isdefined(level.next_samantha_clue_time))
	{
		level.next_samantha_clue_time = gettime();
	}
	while(true)
	{
		level waittill(str_notify, e_player);
		wait(10);
		if(isdefined(e_player) && (isdefined(e_player.vo_promises_playing) && e_player.vo_promises_playing))
		{
			continue;
		}
		while(isdefined(level.sam_talking) && level.sam_talking)
		{
			util::wait_network_frame();
		}
		if(level.next_samantha_clue_time > gettime())
		{
			continue;
		}
		if(!isplayer(e_player))
		{
			a_players = getplayers();
			foreach(player in a_players)
			{
				if(player.zombie_vars["zombie_powerup_zombie_blood_on"])
				{
					e_player = player;
					break;
				}
			}
		}
		if(isdefined(e_player) && isplayer(e_player) && e_player.zombie_vars["zombie_powerup_zombie_blood_on"] && level flag::get("samantha_intro_done"))
		{
			level flag::wait_till_clear("story_vo_playing");
			level flag::set("story_vo_playing");
			while(isdefined(e_player.isspeaking) && e_player.isspeaking)
			{
				util::wait_network_frame();
			}
			if(!zombie_utility::is_player_valid(e_player))
			{
				continue;
			}
			set_players_dontspeak(1);
			level.sam_talking = 1;
			e_player playsoundtoplayer(str_line, e_player);
			n_duration = soundgetplaybacktime(str_line);
			wait(n_duration / 1000);
			level.sam_talking = 0;
			level.next_samantha_clue_time = gettime() + 300000;
			level flag::clear("story_vo_playing");
			set_players_dontspeak(0);
			return;
		}
	}
}

/*
	Name: samantha_discourage_reset
	Namespace: zm_tomb_vo
	Checksum: 0xCE1BC6F7
	Offset: 0xBE78
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function samantha_discourage_reset()
{
	n_min_time = 60000 * 5;
	n_max_time = 60000 * 10;
	level.sam_next_beratement = gettime() + randomintrange(n_min_time, n_max_time);
}

/*
	Name: samantha_encourage_watch_good_lines
	Namespace: zm_tomb_vo
	Checksum: 0xDD7058FA
	Offset: 0xBEE0
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function samantha_encourage_watch_good_lines()
{
	while(true)
	{
		level waittill(#"vo_puzzle_good", e_player);
		wait(1);
		level notify(#"quest_progressed", e_player, 1);
	}
}

/*
	Name: samantha_encourage_think
	Namespace: zm_tomb_vo
	Checksum: 0xA6C1C564
	Offset: 0xBF30
	Size: 0x2E8
	Parameters: 0
	Flags: None
*/
function samantha_encourage_think()
{
	original_list = array("vox_sam_generic_encourage_0", "vox_sam_generic_encourage_1", "vox_sam_generic_encourage_2", "vox_sam_generic_encourage_3", "vox_sam_generic_encourage_4", "vox_sam_generic_encourage_5");
	available_list = [];
	n_min_time = 60000 * 5;
	n_max_time = 60000 * 10;
	next_encouragement = 0;
	level thread samantha_encourage_watch_good_lines();
	while(true)
	{
		if(available_list.size == 0)
		{
			available_list = arraycopy(original_list);
		}
		e_player = undefined;
		say_something = 0;
		level waittill(#"quest_progressed", e_player, say_something);
		samantha_discourage_reset();
		if(gettime() < next_encouragement)
		{
			continue;
		}
		if(!(isdefined(say_something) && say_something))
		{
			continue;
		}
		if(!isdefined(e_player))
		{
			continue;
		}
		if(!zombie_utility::is_player_valid(e_player))
		{
			continue;
		}
		if(isdefined(level.sam_talking) && level.sam_talking)
		{
			continue;
		}
		while(level flag::get("story_vo_playing") || (isdefined(e_player.isspeaking) && e_player.isspeaking))
		{
			util::wait_network_frame();
		}
		line = array::random(available_list);
		arrayremovevalue(available_list, line);
		set_players_dontspeak(1);
		if(samanthasay(line, e_player, 1))
		{
			set_players_dontspeak(0);
			e_player zm_audio::create_and_play_dialog("puzzle", "encourage_respond");
			next_encouragement = gettime() + randomintrange(n_min_time, n_max_time);
		}
		set_players_dontspeak(0);
	}
}

/*
	Name: samantha_discourage_think
	Namespace: zm_tomb_vo
	Checksum: 0xC4C12AB5
	Offset: 0xC220
	Size: 0x200
	Parameters: 0
	Flags: None
*/
function samantha_discourage_think()
{
	level endon(#"ee_all_staffs_upgraded");
	original_list = array("vox_sam_generic_chastise_0", "vox_sam_generic_chastise_1", "vox_sam_generic_chastise_2", "vox_sam_generic_chastise_3", "vox_sam_generic_chastise_4", "vox_sam_generic_chastise_5", "vox_sam_generic_chastise_6");
	available_list = [];
	level flag::wait_till("samantha_intro_done");
	while(true)
	{
		if(available_list.size == 0)
		{
			available_list = arraycopy(original_list);
		}
		samantha_discourage_reset();
		while(gettime() < level.sam_next_beratement)
		{
			wait(1);
		}
		line = array::random(available_list);
		arrayremovevalue(available_list, line);
		a_players = getplayers();
		while(a_players.size > 0)
		{
			e_player = array::random(a_players);
			arrayremovevalue(a_players, e_player);
			if(zombie_utility::is_player_valid(e_player))
			{
				samanthasay(line, e_player, 1);
				e_player zm_audio::create_and_play_dialog("puzzle", "berate_respond");
				break;
			}
		}
	}
}

/*
	Name: samanthasay
	Namespace: zm_tomb_vo
	Checksum: 0x44BE4FD6
	Offset: 0xC428
	Size: 0x224
	Parameters: 4
	Flags: Linked
*/
function samanthasay(vox_line, e_source, b_wait_for_nearby_speakers = 0, intro_line = 0)
{
	level endon(#"end_game");
	if(!intro_line && !level flag::get("samantha_intro_done"))
	{
		return false;
	}
	if(intro_line && level flag::get("samantha_intro_done"))
	{
		return false;
	}
	while(isdefined(level.sam_talking) && level.sam_talking)
	{
		util::wait_network_frame();
	}
	level.sam_talking = 1;
	if(b_wait_for_nearby_speakers)
	{
		nearbyplayers = util::get_array_of_closest(e_source.origin, getplayers(), undefined, undefined, 256);
		if(isdefined(nearbyplayers) && nearbyplayers.size > 0)
		{
			foreach(player in nearbyplayers)
			{
				while(isdefined(player) && (isdefined(player.isspeaking) && player.isspeaking))
				{
					wait(0.05);
				}
			}
		}
	}
	level thread samanthasayvoplay(e_source, vox_line);
	level waittill(#"samanthasay_vo_finished");
	return true;
}

/*
	Name: samanthasayvoplay
	Namespace: zm_tomb_vo
	Checksum: 0x77FF12E9
	Offset: 0xC658
	Size: 0x6A
	Parameters: 2
	Flags: Linked
*/
function samanthasayvoplay(e_source, vox_line)
{
	e_source playsoundwithnotify(vox_line, "sound_done" + vox_line);
	e_source waittill("sound_done" + vox_line);
	level.sam_talking = 0;
	level notify(#"samanthasay_vo_finished");
}

/*
	Name: maxissay
	Namespace: zm_tomb_vo
	Checksum: 0x2FB50B41
	Offset: 0xC6D0
	Size: 0x218
	Parameters: 3
	Flags: Linked
*/
function maxissay(vox_line, m_spot_override, b_wait_for_nearby_speakers)
{
	level endon(#"end_game");
	level endon(#"intermission");
	if(isdefined(level.intermission) && level.intermission)
	{
		return;
	}
	if(!level flag::get("maxis_crafted_intro_done"))
	{
		return;
	}
	while(isdefined(level.maxis_talking) && level.maxis_talking)
	{
		wait(0.05);
	}
	level.maxis_talking = 1;
	/#
		iprintlnbold("" + vox_line);
	#/
	if(isdefined(m_spot_override))
	{
		m_vo_spot = m_spot_override;
	}
	if(isdefined(b_wait_for_nearby_speakers) && b_wait_for_nearby_speakers)
	{
		nearbyplayers = util::get_array_of_closest(m_vo_spot.origin, getplayers(), undefined, undefined, 256);
		if(isdefined(nearbyplayers) && nearbyplayers.size > 0)
		{
			foreach(player in nearbyplayers)
			{
				while(isdefined(player) && (isdefined(player.isspeaking) && player.isspeaking))
				{
					wait(0.05);
				}
			}
		}
	}
	level thread maxissayvoplay(m_vo_spot, vox_line);
	level waittill(#"maxissay_vo_finished");
}

/*
	Name: maxissayvoplay
	Namespace: zm_tomb_vo
	Checksum: 0xBD8EC137
	Offset: 0xC8F0
	Size: 0x86
	Parameters: 2
	Flags: Linked
*/
function maxissayvoplay(m_vo_spot, vox_line)
{
	m_vo_spot playsoundwithnotify(vox_line, "sound_done" + vox_line);
	m_vo_spot util::waittill_either("sound_done" + vox_line, "death");
	level.maxis_talking = 0;
	level notify(#"maxissay_vo_finished");
}

/*
	Name: richtofenrespondvoplay
	Namespace: zm_tomb_vo
	Checksum: 0xCEEEE21B
	Offset: 0xC980
	Size: 0x724
	Parameters: 3
	Flags: Linked
*/
function richtofenrespondvoplay(vox_category, b_richtofen_first = 0, str_flag)
{
	if(level flag::get("story_vo_playing"))
	{
		return;
	}
	level flag::set("story_vo_playing");
	set_players_dontspeak(1);
	if(b_richtofen_first)
	{
		if(self.character_name == "Richtofen")
		{
			str_vox_line = ((("vox_plr_" + self.characterindex) + "_") + vox_category) + "_0";
			self playsoundwithnotify(str_vox_line, "rich_done");
			self waittill(#"rich_done");
			wait(0.5);
			foreach(player in getplayers())
			{
				if(player.character_name != "Richtofen" && distance2d(player.origin, self.origin) < 800)
				{
					str_vox_line = ((("vox_plr_" + player.characterindex) + "_") + vox_category) + "_0";
					player playsoundwithnotify(str_vox_line, "rich_done");
					player waittill(#"rich_done");
				}
			}
		}
		else
		{
			foreach(player in getplayers())
			{
				if(player.character_name == "Richtofen" && distance2d(player.origin, self.origin) < 800)
				{
					str_vox_line = ((("vox_plr_" + player.characterindex) + "_") + vox_category) + "_0";
					player playsoundwithnotify(str_vox_line, "rich_done");
					player waittill(#"rich_done");
					wait(0.5);
				}
			}
			if(isdefined(self))
			{
				str_vox_line = ((("vox_plr_" + self.characterindex) + "_") + vox_category) + "_0";
				self playsoundwithnotify(str_vox_line, "rich_response");
				self waittill(#"rich_response");
			}
		}
	}
	else
	{
		if(self.characterindex == 2)
		{
			foreach(player in getplayers())
			{
				if(player.character_name != "Richtofen" && distance2d(player.origin, self.origin) < 800)
				{
					str_vox_line = ((("vox_plr_" + player.characterindex) + "_") + vox_category) + "_0";
					player playsoundwithnotify(str_vox_line, "rich_done");
					player waittill(#"rich_done");
					wait(0.5);
				}
			}
			if(isdefined(self))
			{
				str_vox_line = ((("vox_plr_" + self.characterindex) + "_") + vox_category) + "_0";
				self playsoundwithnotify(str_vox_line, "rich_done");
				self waittill(#"rich_done");
			}
		}
		else
		{
			str_vox_line = ((("vox_plr_" + self.characterindex) + "_") + vox_category) + "_0";
			self playsoundwithnotify(str_vox_line, "rich_response");
			self waittill(#"rich_response");
			wait(0.5);
			foreach(player in getplayers())
			{
				if(player.character_name == "Richtofen" && distance2d(player.origin, self.origin) < 800)
				{
					str_vox_line = ((("vox_plr_" + player.characterindex) + "_") + vox_category) + "_0";
					player playsoundwithnotify(str_vox_line, "rich_done");
					player waittill(#"rich_done");
				}
			}
		}
	}
	if(isdefined(str_flag))
	{
		level flag::set(str_flag);
	}
	set_players_dontspeak(0);
	level flag::clear("story_vo_playing");
}

/*
	Name: wunderfizz_used_vo
	Namespace: zm_tomb_vo
	Checksum: 0x607C8A7F
	Offset: 0xD0B0
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function wunderfizz_used_vo()
{
	self endon(#"death");
	self endon(#"disconnect");
	if(isdefined(self.has_used_perk_random) && self.has_used_perk_random)
	{
		return;
	}
	if(isdefined(self.character_name) && self.character_name != "Richtofen")
	{
		return;
	}
	if(level flag::get("story_vo_playing"))
	{
		return;
	}
	if(isdefined(self.dontspeak) && self.dontspeak)
	{
		return;
	}
	set_players_dontspeak(1);
	self.has_used_perk_random = 1;
	for(i = 1; i < 4; i++)
	{
		vox_line = ("vox_plr_2_discover_wonder_" + i) + "_0";
		self playsoundwithnotify(vox_line, "sound_done" + vox_line);
		self waittill("sound_done" + vox_line);
		wait(0.1);
	}
	set_players_dontspeak(0);
}

/*
	Name: init_sam_promises
	Namespace: zm_tomb_vo
	Checksum: 0x66EC1BAE
	Offset: 0xD208
	Size: 0x3EC
	Parameters: 0
	Flags: Linked
*/
function init_sam_promises()
{
	level.vo_promises["Richtofen_1"][0] = "vox_sam_hear_samantha_2_plr_2_0";
	level.vo_promises["Richtofen_1"][1] = "vox_plr_2_hear_samantha_2_0";
	level.vo_promises["Richtofen_2"][0] = "vox_sam_sam_richtofen_1_0";
	level.vo_promises["Richtofen_2"][1] = "vox_sam_sam_richtofen_2_0";
	level.vo_promises["Richtofen_2"][2] = "vox_plr_2_sam_richtofen_3_0";
	level.vo_promises["Richtofen_3"][0] = "vox_sam_sam_richtofen_4_0";
	level.vo_promises["Richtofen_3"][1] = "vox_plr_2_sam_richtofen_5_0";
	level.vo_promises["Richtofen_3"][2] = "vox_plr_2_sam_richtofen_6_0";
	level.vo_promises["Dempsey_1"][0] = "vox_sam_hear_samantha_2_plr_0_0";
	level.vo_promises["Dempsey_1"][1] = "vox_plr_0_hear_samantha_2_0";
	level.vo_promises["Dempsey_2"][0] = "vox_sam_sam_dempsey_1_0";
	level.vo_promises["Dempsey_2"][1] = "vox_sam_sam_dempsey_1_1";
	level.vo_promises["Dempsey_2"][2] = "vox_plr_0_sam_dempsey_1_0";
	level.vo_promises["Dempsey_3"][0] = "vox_sam_sam_dempsey_2_0";
	level.vo_promises["Dempsey_3"][1] = "vox_sam_sam_dempsey_2_1";
	level.vo_promises["Dempsey_3"][2] = "vox_plr_0_sam_dempsey_2_0";
	level.vo_promises["Nikolai_1"][0] = "vox_sam_hear_samantha_2_plr_1_0";
	level.vo_promises["Nikolai_1"][1] = "vox_plr_1_hear_samantha_2_0";
	level.vo_promises["Nikolai_2"][0] = "vox_sam_sam_nikolai_1_0";
	level.vo_promises["Nikolai_2"][1] = "vox_sam_sam_nikolai_1_1";
	level.vo_promises["Nikolai_2"][2] = "vox_plr_1_sam_nikolai_1_0";
	level.vo_promises["Nikolai_3"][0] = "vox_sam_sam_nikolai_2_0";
	level.vo_promises["Nikolai_3"][1] = "vox_sam_sam_nikolai_2_1";
	level.vo_promises["Nikolai_3"][2] = "vox_plr_1_sam_nikolai_2_0";
	level.vo_promises["Takeo_1"][0] = "vox_sam_hear_samantha_2_plr_3_0";
	level.vo_promises["Takeo_1"][1] = "vox_plr_3_hear_samantha_2_0";
	level.vo_promises["Takeo_2"][0] = "vox_sam_sam_takeo_1_0";
	level.vo_promises["Takeo_2"][1] = "vox_sam_sam_takeo_1_1";
	level.vo_promises["Takeo_2"][2] = "vox_plr_3_sam_takeo_1_0";
	level.vo_promises["Takeo_3"][0] = "vox_sam_sam_takeo_2_0";
	level.vo_promises["Takeo_3"][1] = "vox_sam_sam_takeo_2_1";
	level.vo_promises["Takeo_3"][2] = "vox_plr_3_sam_takeo_2_0";
	level thread sam_promises_watch();
}

/*
	Name: sam_promises_watch
	Namespace: zm_tomb_vo
	Checksum: 0x1F36BF92
	Offset: 0xD600
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function sam_promises_watch()
{
	level flag::wait_till("samantha_intro_done");
	while(true)
	{
		level waittill(#"player_zombie_blood", e_player);
		a_players = getplayers();
		if(randomint(100) < 20)
		{
			e_player thread sam_promises_conversation();
		}
	}
}

/*
	Name: sam_promises_conversation
	Namespace: zm_tomb_vo
	Checksum: 0xA66EA7C3
	Offset: 0xD6A0
	Size: 0x17E
	Parameters: 0
	Flags: Linked
*/
function sam_promises_conversation()
{
	self endon(#"disconnect");
	self.vo_promises_playing = 1;
	wait(3);
	if(!isdefined(self.n_vo_promises))
	{
		self.n_vo_promises = 1;
	}
	if(self.n_vo_promises > 3 || (isdefined(self.b_promise_cooldown) && self.b_promise_cooldown) || level flag::get("story_vo_playing"))
	{
		self.vo_promises_playing = undefined;
		return;
	}
	a_promises = level.vo_promises[(self.character_name + "_") + self.n_vo_promises];
	self.n_vo_promises++;
	self thread sam_promises_cooldown();
	level.sam_talking = 1;
	self set_player_dontspeak(1);
	level flag::set("story_vo_playing");
	self play_sam_promises_conversation(a_promises);
	level.sam_talking = 0;
	self set_player_dontspeak(0);
	level flag::clear("story_vo_playing");
	self.vo_promises_playing = undefined;
}

/*
	Name: play_sam_promises_conversation
	Namespace: zm_tomb_vo
	Checksum: 0x8AEDDF88
	Offset: 0xD828
	Size: 0x15A
	Parameters: 1
	Flags: Linked
*/
function play_sam_promises_conversation(a_promises)
{
	for(i = 0; i < a_promises.size; i++)
	{
		self endon(#"zombie_blood_over");
		self endon(#"disconnect");
		if(issubstr(a_promises[i], "sam_sam") || issubstr(a_promises[i], "samantha"))
		{
			self thread sam_promises_conversation_ended_early(a_promises[i]);
			self playsoundtoplayer(a_promises[i], self);
			n_duration = soundgetplaybacktime(a_promises[i]);
			wait(n_duration / 1000);
			self notify(#"promises_vo_end_early");
		}
		else
		{
			self playsoundwithnotify(a_promises[i], "player_done");
			self waittill(#"player_done");
		}
		wait(0.3);
	}
}

/*
	Name: sam_promises_conversation_ended_early
	Namespace: zm_tomb_vo
	Checksum: 0x74E22504
	Offset: 0xD990
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function sam_promises_conversation_ended_early(str_alias)
{
	self notify(#"promises_vo_end_early");
	self endon(#"promises_vo_end_early");
	while(self.zombie_vars["zombie_powerup_zombie_blood_on"])
	{
		wait(0.05);
	}
	self stoplocalsound(str_alias);
}

/*
	Name: sam_promises_cooldown
	Namespace: zm_tomb_vo
	Checksum: 0x88327BB4
	Offset: 0xDA00
	Size: 0x32
	Parameters: 0
	Flags: Linked
*/
function sam_promises_cooldown()
{
	self endon(#"disconnect");
	self.b_promise_cooldown = 1;
	level waittill(#"end_of_round");
	self.b_promise_cooldown = undefined;
}

/*
	Name: function_860b0710
	Namespace: zm_tomb_vo
	Checksum: 0xA6728923
	Offset: 0xDA40
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_860b0710()
{
	self endon(#"death");
	if(randomintrange(0, 100) < 20)
	{
		str_vox_line = "vox_maxi_drone_killed_" + randomintrange(0, 3);
		self maxissay(str_vox_line, self);
		var_f813a897 = util::get_array_of_closest(self.origin, getplayers(), undefined, undefined, 256);
		if(isdefined(var_f813a897[0]))
		{
			var_f813a897[0] zm_audio::create_and_play_dialog("quadrotor", "kill_drone");
		}
	}
}

/*
	Name: function_a808bc8e
	Namespace: zm_tomb_vo
	Checksum: 0x9C205EDC
	Offset: 0xDB38
	Size: 0x118
	Parameters: 0
	Flags: Linked
*/
function function_a808bc8e()
{
	self endon(#"death");
	if(!isdefined(level.var_450ee971))
	{
		level.var_450ee971 = [];
		for(i = 0; i < 9; i++)
		{
			level.var_450ee971[i] = i;
		}
		level.var_450ee971 = array::randomize(level.var_450ee971);
	}
	while(true)
	{
		if(!isdefined(level.var_450ee971[0]))
		{
			return;
		}
		wait(randomintrange(20, 40));
		str_vox_line = "vox_maxi_drone_ambient_" + level.var_450ee971[0];
		self maxissay(str_vox_line, self);
		level.var_450ee971 = array::remove_index(level.var_450ee971, 0);
	}
}

