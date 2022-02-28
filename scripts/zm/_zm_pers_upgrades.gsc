// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_pers_upgrades;

/*
	Name: pers_upgrade_init
	Namespace: zm_pers_upgrades
	Checksum: 0xF069E25A
	Offset: 0x3B8
	Size: 0xEC
	Parameters: 0
	Flags: None
*/
function pers_upgrade_init()
{
	setup_pers_upgrade_boards();
	setup_pers_upgrade_revive();
	setup_pers_upgrade_multi_kill_headshots();
	setup_pers_upgrade_cash_back();
	setup_pers_upgrade_insta_kill();
	setup_pers_upgrade_jugg();
	setup_pers_upgrade_carpenter();
	setup_pers_upgrade_perk_lose();
	setup_pers_upgrade_pistol_points();
	setup_pers_upgrade_double_points();
	setup_pers_upgrade_sniper();
	setup_pers_upgrade_box_weapon();
	setup_pers_upgrade_nube();
	level thread zm_pers_upgrades_system::pers_upgrades_monitor();
}

/*
	Name: pers_abilities_init_globals
	Namespace: zm_pers_upgrades
	Checksum: 0x502AC88D
	Offset: 0x4B0
	Size: 0xA4
	Parameters: 0
	Flags: None
*/
function pers_abilities_init_globals()
{
	self.successful_revives = 0;
	self.failed_revives = 0;
	self.failed_cash_back_prones = 0;
	self.pers["last_headshot_kill_time"] = gettime();
	self.pers["zombies_multikilled"] = 0;
	self.non_headshot_kill_counter = 0;
	if(isdefined(level.pers_upgrade_box_weapon) && level.pers_upgrade_box_weapon)
	{
		self.pers_box_weapon_awarded = undefined;
	}
	if(isdefined(level.pers_upgrade_nube) && level.pers_upgrade_nube)
	{
		self thread zm_pers_upgrades_functions::pers_nube_unlock_watcher();
	}
}

/*
	Name: is_pers_system_active
	Namespace: zm_pers_upgrades
	Checksum: 0xCA89964
	Offset: 0x560
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function is_pers_system_active()
{
	if(!zm_utility::is_classic())
	{
		return false;
	}
	if(is_pers_system_disabled())
	{
		return false;
	}
	return false;
}

/*
	Name: is_pers_system_disabled
	Namespace: zm_pers_upgrades
	Checksum: 0xDF03D28B
	Offset: 0x5A0
	Size: 0x6
	Parameters: 0
	Flags: Linked
*/
function is_pers_system_disabled()
{
	return false;
}

/*
	Name: setup_pers_upgrade_boards
	Namespace: zm_pers_upgrades
	Checksum: 0x21539D0B
	Offset: 0x5B0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function setup_pers_upgrade_boards()
{
	if(isdefined(level.pers_upgrade_boards) && level.pers_upgrade_boards)
	{
		level.pers_boarding_round_start = 10;
		level.pers_boarding_number_of_boards_required = 74;
		zm_pers_upgrades_system::pers_register_upgrade("board", &pers_upgrade_boards_active, "pers_boarding", level.pers_boarding_number_of_boards_required, 0);
	}
}

/*
	Name: setup_pers_upgrade_revive
	Namespace: zm_pers_upgrades
	Checksum: 0x1129EBBC
	Offset: 0x628
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function setup_pers_upgrade_revive()
{
	if(isdefined(level.pers_upgrade_revive) && level.pers_upgrade_revive)
	{
		level.pers_revivenoperk_number_of_revives_required = 17;
		level.pers_revivenoperk_number_of_chances_to_keep = 1;
		zm_pers_upgrades_system::pers_register_upgrade("revive", &pers_upgrade_revive_active, "pers_revivenoperk", level.pers_revivenoperk_number_of_revives_required, 1);
	}
}

/*
	Name: setup_pers_upgrade_multi_kill_headshots
	Namespace: zm_pers_upgrades
	Checksum: 0xF2C7DDB8
	Offset: 0x6A8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function setup_pers_upgrade_multi_kill_headshots()
{
	if(isdefined(level.pers_upgrade_multi_kill_headshots) && level.pers_upgrade_multi_kill_headshots)
	{
		level.pers_multikill_headshots_required = 5;
		level.pers_multikill_headshots_upgrade_reset_counter = 25;
		zm_pers_upgrades_system::pers_register_upgrade("multikill_headshots", &pers_upgrade_headshot_active, "pers_multikill_headshots", level.pers_multikill_headshots_required, 0);
	}
}

/*
	Name: setup_pers_upgrade_cash_back
	Namespace: zm_pers_upgrades
	Checksum: 0xB11726EA
	Offset: 0x720
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function setup_pers_upgrade_cash_back()
{
	if(isdefined(level.pers_upgrade_cash_back) && level.pers_upgrade_cash_back)
	{
		level.pers_cash_back_num_perks_required = 50;
		level.pers_cash_back_perk_buys_prone_required = 15;
		level.pers_cash_back_failed_prones = 1;
		level.pers_cash_back_money_reward = 1000;
		zm_pers_upgrades_system::pers_register_upgrade("cash_back", &pers_upgrade_cash_back_active, "pers_cash_back_bought", level.pers_cash_back_num_perks_required, 0);
		zm_pers_upgrades_system::add_pers_upgrade_stat("cash_back", "pers_cash_back_prone", level.pers_cash_back_perk_buys_prone_required);
	}
}

/*
	Name: setup_pers_upgrade_insta_kill
	Namespace: zm_pers_upgrades
	Checksum: 0x5BD2F3A9
	Offset: 0x7D8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function setup_pers_upgrade_insta_kill()
{
	if(isdefined(level.pers_upgrade_insta_kill) && level.pers_upgrade_insta_kill)
	{
		level.pers_insta_kill_num_required = 2;
		level.pers_insta_kill_upgrade_active_time = 18;
		zm_pers_upgrades_system::pers_register_upgrade("insta_kill", &pers_upgrade_insta_kill_active, "pers_insta_kill", level.pers_insta_kill_num_required, 0);
	}
}

/*
	Name: setup_pers_upgrade_jugg
	Namespace: zm_pers_upgrades
	Checksum: 0x9E6DA8C
	Offset: 0x850
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function setup_pers_upgrade_jugg()
{
	if(isdefined(level.pers_upgrade_jugg) && level.pers_upgrade_jugg)
	{
		level.pers_jugg_hit_and_die_total = 3;
		level.pers_jugg_hit_and_die_round_limit = 2;
		level.pers_jugg_round_reached_max = 1;
		level.pers_jugg_round_lose_target = 15;
		level.pers_jugg_upgrade_health_bonus = 90;
		zm_pers_upgrades_system::pers_register_upgrade("jugg", &pers_upgrade_jugg_active, "pers_jugg", level.pers_jugg_hit_and_die_total, 0);
	}
}

/*
	Name: setup_pers_upgrade_carpenter
	Namespace: zm_pers_upgrades
	Checksum: 0x390D2C19
	Offset: 0x8F0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function setup_pers_upgrade_carpenter()
{
	if(isdefined(level.pers_upgrade_carpenter) && level.pers_upgrade_carpenter)
	{
		level.pers_carpenter_zombie_kills = 1;
		zm_pers_upgrades_system::pers_register_upgrade("carpenter", &pers_upgrade_carpenter_active, "pers_carpenter", level.pers_carpenter_zombie_kills, 0);
	}
}

/*
	Name: setup_pers_upgrade_perk_lose
	Namespace: zm_pers_upgrades
	Checksum: 0x94160E9
	Offset: 0x960
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function setup_pers_upgrade_perk_lose()
{
	if(isdefined(level.pers_upgrade_perk_lose) && level.pers_upgrade_perk_lose)
	{
		level.pers_perk_round_reached_max = 6;
		level.pers_perk_lose_counter = 3;
		zm_pers_upgrades_system::pers_register_upgrade("perk_lose", &pers_upgrade_perk_lose_active, "pers_perk_lose_counter", level.pers_perk_lose_counter, 0);
	}
}

/*
	Name: setup_pers_upgrade_pistol_points
	Namespace: zm_pers_upgrades
	Checksum: 0x35A35F31
	Offset: 0x9D8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function setup_pers_upgrade_pistol_points()
{
	if(isdefined(level.pers_upgrade_pistol_points) && level.pers_upgrade_pistol_points)
	{
		level.pers_pistol_points_num_kills_in_game = 8;
		level.pers_pistol_points_accuracy = 0.25;
		level.pers_pistol_points_counter = 1;
		zm_pers_upgrades_system::pers_register_upgrade("pistol_points", &pers_upgrade_pistol_points_active, "pers_pistol_points_counter", level.pers_pistol_points_counter, 0);
	}
}

/*
	Name: setup_pers_upgrade_double_points
	Namespace: zm_pers_upgrades
	Checksum: 0x95222E62
	Offset: 0xA60
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function setup_pers_upgrade_double_points()
{
	if(isdefined(level.pers_upgrade_double_points) && level.pers_upgrade_double_points)
	{
		level.pers_double_points_score = 2500;
		level.pers_double_points_counter = 1;
		zm_pers_upgrades_system::pers_register_upgrade("double_points", &pers_upgrade_double_points_active, "pers_double_points_counter", level.pers_double_points_counter, 0);
	}
}

/*
	Name: setup_pers_upgrade_sniper
	Namespace: zm_pers_upgrades
	Checksum: 0x491CD130
	Offset: 0xAD8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function setup_pers_upgrade_sniper()
{
	if(isdefined(level.pers_upgrade_sniper) && level.pers_upgrade_sniper)
	{
		level.pers_sniper_round_kills_counter = 5;
		level.pers_sniper_kill_distance = 800;
		level.pers_sniper_counter = 1;
		level.pers_sniper_misses = 3;
		zm_pers_upgrades_system::pers_register_upgrade("sniper", &pers_upgrade_sniper_active, "pers_sniper_counter", level.pers_sniper_counter, 0);
	}
}

/*
	Name: setup_pers_upgrade_box_weapon
	Namespace: zm_pers_upgrades
	Checksum: 0x9D39D1EF
	Offset: 0xB68
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function setup_pers_upgrade_box_weapon()
{
	if(isdefined(level.pers_upgrade_box_weapon) && level.pers_upgrade_box_weapon)
	{
		level.pers_box_weapon_counter = 5;
		level.pers_box_weapon_lose_round = 10;
		zm_pers_upgrades_system::pers_register_upgrade("box_weapon", &pers_upgrade_box_weapon_active, "pers_box_weapon_counter", level.pers_box_weapon_counter, 0);
	}
}

/*
	Name: setup_pers_upgrade_nube
	Namespace: zm_pers_upgrades
	Checksum: 0x60153DF5
	Offset: 0xBE0
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function setup_pers_upgrade_nube()
{
	if(isdefined(level.pers_upgrade_nube) && level.pers_upgrade_nube)
	{
		level.pers_nube_counter = 1;
		level.pers_nube_lose_round = 10;
		level.pers_numb_num_kills_unlock = 5;
		zm_pers_upgrades_system::pers_register_upgrade("nube", &pers_upgrade_nube_active, "pers_nube_counter", level.pers_nube_counter, 0);
	}
}

/*
	Name: pers_upgrade_boards_active
	Namespace: zm_pers_upgrades
	Checksum: 0xABD8812D
	Offset: 0xC68
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function pers_upgrade_boards_active()
{
	self endon(#"disconnect");
	last_round_number = level.round_number;
	while(true)
	{
		self waittill(#"pers_stats_end_of_round");
		if(level.round_number >= last_round_number)
		{
			if(is_pers_system_active())
			{
				if(self.rebuild_barrier_reward == 0)
				{
					self zm_stats::zero_client_stat("pers_boarding", 0);
					return;
				}
			}
		}
		last_round_number = level.round_number;
	}
}

/*
	Name: pers_upgrade_revive_active
	Namespace: zm_pers_upgrades
	Checksum: 0x3B4E8B1A
	Offset: 0xD10
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function pers_upgrade_revive_active()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"player_failed_revive");
		if(is_pers_system_active())
		{
			if(self.failed_revives >= level.pers_revivenoperk_number_of_chances_to_keep)
			{
				self zm_stats::zero_client_stat("pers_revivenoperk", 0);
				self.failed_revives = 0;
				return;
			}
		}
	}
}

/*
	Name: pers_upgrade_headshot_active
	Namespace: zm_pers_upgrades
	Checksum: 0x881A1220
	Offset: 0xD98
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function pers_upgrade_headshot_active()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"zombie_death_no_headshot");
		if(is_pers_system_active())
		{
			self.non_headshot_kill_counter++;
			if(self.non_headshot_kill_counter >= level.pers_multikill_headshots_upgrade_reset_counter)
			{
				self zm_stats::zero_client_stat("pers_multikill_headshots", 0);
				self.non_headshot_kill_counter = 0;
				return;
			}
		}
	}
}

/*
	Name: pers_upgrade_cash_back_active
	Namespace: zm_pers_upgrades
	Checksum: 0x55F61829
	Offset: 0xE28
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function pers_upgrade_cash_back_active()
{
	self endon(#"disconnect");
	wait(0.5);
	/#
	#/
	wait(0.5);
	while(true)
	{
		self waittill(#"cash_back_failed_prone");
		wait(0.1);
		/#
		#/
		if(is_pers_system_active())
		{
			self.failed_cash_back_prones++;
			if(self.failed_cash_back_prones >= level.pers_cash_back_failed_prones)
			{
				self zm_stats::zero_client_stat("pers_cash_back_bought", 0);
				self zm_stats::zero_client_stat("pers_cash_back_prone", 0);
				self.failed_cash_back_prones = 0;
				wait(0.4);
				/#
				#/
				return;
			}
		}
	}
}

/*
	Name: pers_upgrade_insta_kill_active
	Namespace: zm_pers_upgrades
	Checksum: 0xB0C3E7CA
	Offset: 0xF08
	Size: 0x158
	Parameters: 0
	Flags: Linked
*/
function pers_upgrade_insta_kill_active()
{
	self endon(#"disconnect");
	wait(0.2);
	/#
	#/
	wait(0.2);
	while(true)
	{
		self waittill(#"pers_melee_swipe");
		if(is_pers_system_active())
		{
			if(isdefined(level.pers_melee_swipe_zombie_swiper))
			{
				e_zombie = level.pers_melee_swipe_zombie_swiper;
				if(isalive(e_zombie) && (isdefined(e_zombie.is_zombie) && e_zombie.is_zombie))
				{
					e_zombie.marked_for_insta_upgraded_death = 1;
					e_zombie dodamage(e_zombie.health + 666, e_zombie.origin, self, self, "none", "MOD_PISTOL_BULLET", 0);
				}
				level.pers_melee_swipe_zombie_swiper = undefined;
			}
			break;
		}
	}
	self zm_stats::zero_client_stat("pers_insta_kill", 0);
	self kill_insta_kill_upgrade_hud_icon();
	wait(0.4);
	/#
	#/
}

/*
	Name: is_insta_kill_upgraded_and_active
	Namespace: zm_pers_upgrades
	Checksum: 0x4E6BA02B
	Offset: 0x1068
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function is_insta_kill_upgraded_and_active()
{
	if(is_pers_system_active())
	{
		if(self zm_powerups::is_insta_kill_active())
		{
			if(isdefined(self.pers_upgrades_awarded["insta_kill"]) && self.pers_upgrades_awarded["insta_kill"])
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: pers_upgrade_jugg_active
	Namespace: zm_pers_upgrades
	Checksum: 0xFA10CE0A
	Offset: 0x10D8
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function pers_upgrade_jugg_active()
{
	self endon(#"disconnect");
	wait(0.5);
	/#
	#/
	wait(0.5);
	self zm_perks::perk_set_max_health_if_jugg("jugg_upgrade", 1, 0);
	while(true)
	{
		level waittill(#"start_of_round");
		if(is_pers_system_active())
		{
			if(level.round_number == level.pers_jugg_round_lose_target)
			{
				/#
				#/
				self zm_stats::increment_client_stat("pers_jugg_downgrade_count", 0);
				wait(0.5);
				if(self.pers["pers_jugg_downgrade_count"] >= level.pers_jugg_round_reached_max)
				{
					break;
				}
			}
		}
	}
	self zm_perks::perk_set_max_health_if_jugg("jugg_upgrade", 1, 1);
	/#
	#/
	self zm_stats::zero_client_stat("pers_jugg", 0);
	self zm_stats::zero_client_stat("pers_jugg_downgrade_count", 0);
}

/*
	Name: pers_upgrade_carpenter_active
	Namespace: zm_pers_upgrades
	Checksum: 0xCE114927
	Offset: 0x1218
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function pers_upgrade_carpenter_active()
{
	self endon(#"disconnect");
	wait(0.2);
	/#
	#/
	wait(0.2);
	level waittill(#"carpenter_finished");
	self.pers_carpenter_kill = undefined;
	while(true)
	{
		self waittill(#"carpenter_zombie_killed_check_finished");
		if(is_pers_system_active())
		{
			if(!isdefined(self.pers_carpenter_kill))
			{
				break;
			}
			/#
			#/
		}
		self.pers_carpenter_kill = undefined;
	}
	self zm_stats::zero_client_stat("pers_carpenter", 0);
	wait(0.4);
	/#
	#/
}

/*
	Name: persistent_carpenter_ability_check
	Namespace: zm_pers_upgrades
	Checksum: 0xCD6FEA34
	Offset: 0x12D8
	Size: 0x1B6
	Parameters: 0
	Flags: Linked
*/
function persistent_carpenter_ability_check()
{
	if(isdefined(level.pers_upgrade_carpenter) && level.pers_upgrade_carpenter)
	{
		self endon(#"disconnect");
		/#
		#/
		if(isdefined(self.pers_upgrades_awarded["carpenter"]) && self.pers_upgrades_awarded["carpenter"])
		{
			level.pers_carpenter_boards_active = 1;
		}
		self.pers_carpenter_zombie_check_active = 1;
		self.pers_carpenter_kill = undefined;
		carpenter_extra_time = 3;
		carpenter_finished_start_time = undefined;
		level.carpenter_finished_start_time = undefined;
		while(true)
		{
			if(!is_pers_system_disabled())
			{
				if(!isdefined(level.carpenter_powerup_active))
				{
					if(!isdefined(level.carpenter_finished_start_time))
					{
						level.carpenter_finished_start_time = gettime();
					}
					time = gettime();
					dt = (time - level.carpenter_finished_start_time) / 1000;
					if(dt >= carpenter_extra_time)
					{
						break;
					}
				}
				if(isdefined(self.pers_carpenter_kill))
				{
					if(isdefined(self.pers_upgrades_awarded["carpenter"]) && self.pers_upgrades_awarded["carpenter"])
					{
						break;
					}
					else
					{
						self zm_stats::increment_client_stat("pers_carpenter", 0);
					}
				}
			}
			wait(0.01);
		}
		self notify(#"carpenter_zombie_killed_check_finished");
		self.pers_carpenter_zombie_check_active = undefined;
		level.pers_carpenter_boards_active = undefined;
	}
}

/*
	Name: pers_zombie_death_location_check
	Namespace: zm_pers_upgrades
	Checksum: 0xF6878A2F
	Offset: 0x1498
	Size: 0x78
	Parameters: 2
	Flags: Linked
*/
function pers_zombie_death_location_check(attacker, v_pos)
{
	if(is_pers_system_active())
	{
		if(zm_utility::is_player_valid(attacker))
		{
			if(isdefined(attacker.pers_carpenter_zombie_check_active))
			{
				if(!zm_utility::check_point_in_playable_area(v_pos))
				{
					attacker.pers_carpenter_kill = 1;
				}
			}
		}
	}
}

/*
	Name: insta_kill_pers_upgrade_icon
	Namespace: zm_pers_upgrades
	Checksum: 0xFD8D30E4
	Offset: 0x1518
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function insta_kill_pers_upgrade_icon()
{
	if(self.zombie_vars["zombie_powerup_insta_kill_ug_on"])
	{
		self.zombie_vars["zombie_powerup_insta_kill_ug_time"] = level.pers_insta_kill_upgrade_active_time;
		return;
	}
	self.zombie_vars["zombie_powerup_insta_kill_ug_on"] = 1;
	self._show_solo_hud = 1;
	self thread time_remaining_pers_upgrade();
}

/*
	Name: time_remaining_pers_upgrade
	Namespace: zm_pers_upgrades
	Checksum: 0x4490C489
	Offset: 0x1590
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function time_remaining_pers_upgrade()
{
	self endon(#"disconnect");
	self endon(#"kill_insta_kill_upgrade_hud_icon");
	while(self.zombie_vars["zombie_powerup_insta_kill_ug_time"] >= 0)
	{
		wait(0.05);
		self.zombie_vars["zombie_powerup_insta_kill_ug_time"] = self.zombie_vars["zombie_powerup_insta_kill_ug_time"] - 0.05;
	}
	self kill_insta_kill_upgrade_hud_icon();
}

/*
	Name: kill_insta_kill_upgrade_hud_icon
	Namespace: zm_pers_upgrades
	Checksum: 0xA5566DF1
	Offset: 0x1618
	Size: 0x4A
	Parameters: 0
	Flags: Linked
*/
function kill_insta_kill_upgrade_hud_icon()
{
	self.zombie_vars["zombie_powerup_insta_kill_ug_on"] = 0;
	self._show_solo_hud = 0;
	self.zombie_vars["zombie_powerup_insta_kill_ug_time"] = level.pers_insta_kill_upgrade_active_time;
	self notify(#"kill_insta_kill_upgrade_hud_icon");
}

/*
	Name: pers_upgrade_perk_lose_active
	Namespace: zm_pers_upgrades
	Checksum: 0x25C3E0FB
	Offset: 0x1670
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function pers_upgrade_perk_lose_active()
{
	self endon(#"disconnect");
	wait(0.5);
	/#
		iprintlnbold("");
	#/
	wait(0.5);
	self.pers_perk_lose_start_round = level.round_number;
	self waittill(#"pers_perk_lose_lost");
	/#
		iprintlnbold("");
	#/
	self zm_stats::zero_client_stat("pers_perk_lose_counter", 0);
}

/*
	Name: pers_upgrade_pistol_points_active
	Namespace: zm_pers_upgrades
	Checksum: 0xDB8A6008
	Offset: 0x1710
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function pers_upgrade_pistol_points_active()
{
	self endon(#"disconnect");
	wait(0.5);
	/#
		iprintlnbold("");
	#/
	wait(0.5);
	while(true)
	{
		self waittill(#"pers_pistol_points_kill");
		accuracy = self zm_pers_upgrades_functions::pers_get_player_accuracy();
		if(accuracy > level.pers_pistol_points_accuracy)
		{
			break;
		}
	}
	/#
		iprintlnbold("");
	#/
	self zm_stats::zero_client_stat("pers_pistol_points_counter", 0);
}

/*
	Name: pers_upgrade_double_points_active
	Namespace: zm_pers_upgrades
	Checksum: 0x76DBA4D3
	Offset: 0x17E0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function pers_upgrade_double_points_active()
{
	self endon(#"disconnect");
	wait(0.5);
	/#
		iprintlnbold("");
	#/
	wait(0.5);
	self waittill(#"double_points_lost");
	/#
		iprintlnbold("");
	#/
	self zm_stats::zero_client_stat("pers_double_points_counter", 0);
}

/*
	Name: pers_upgrade_sniper_active
	Namespace: zm_pers_upgrades
	Checksum: 0x881B71DD
	Offset: 0x1870
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function pers_upgrade_sniper_active()
{
	self endon(#"disconnect");
	wait(0.5);
	/#
		iprintlnbold("");
	#/
	wait(0.5);
	self waittill(#"pers_sniper_lost");
	/#
		iprintlnbold("");
	#/
	self zm_stats::zero_client_stat("pers_sniper_counter", 0);
}

/*
	Name: pers_upgrade_box_weapon_active
	Namespace: zm_pers_upgrades
	Checksum: 0xAC48035D
	Offset: 0x1900
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function pers_upgrade_box_weapon_active()
{
	self endon(#"disconnect");
	wait(0.5);
	/#
		iprintlnbold("");
	#/
	self thread zm_pers_upgrades_functions::pers_magic_box_teddy_bear();
	wait(0.5);
	self.pers_box_weapon_awarded = 1;
	while(true)
	{
		level waittill(#"start_of_round");
		if(is_pers_system_active())
		{
			if(level.round_number >= level.pers_box_weapon_lose_round)
			{
				break;
			}
		}
	}
	/#
		iprintlnbold("");
	#/
	self zm_stats::zero_client_stat("pers_box_weapon_counter", 0);
}

/*
	Name: pers_upgrade_nube_active
	Namespace: zm_pers_upgrades
	Checksum: 0x5663F4
	Offset: 0x19F0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function pers_upgrade_nube_active()
{
	self endon(#"disconnect");
	wait(0.5);
	/#
		iprintlnbold("");
	#/
	wait(0.5);
	while(true)
	{
		level waittill(#"start_of_round");
		if(is_pers_system_active())
		{
			if(level.round_number >= level.pers_nube_lose_round)
			{
				break;
			}
		}
	}
	/#
		iprintlnbold("");
	#/
	self zm_stats::zero_client_stat("pers_nube_counter", 0);
}

