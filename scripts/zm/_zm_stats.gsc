// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_weapons;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_score;

#namespace zm_stats;

/*
	Name: __init__sytem__
	Namespace: zm_stats
	Checksum: 0x205FDF82
	Offset: 0xFA0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stats", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_stats
	Checksum: 0x7418303C
	Offset: 0xFE0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.player_stats_init = &player_stats_init;
	level.add_client_stat = &add_client_stat;
	level.increment_client_stat = &increment_client_stat;
}

/*
	Name: player_stats_init
	Namespace: zm_stats
	Checksum: 0x1785A5EB
	Offset: 0x1038
	Size: 0xCD4
	Parameters: 0
	Flags: Linked
*/
function player_stats_init()
{
	self globallogic_score::initpersstat("kills", 0);
	self globallogic_score::initpersstat("suicides", 0);
	self globallogic_score::initpersstat("downs", 0);
	self.downs = self globallogic_score::getpersstat("downs");
	self globallogic_score::initpersstat("revives", 0);
	self.revives = self globallogic_score::getpersstat("revives");
	self globallogic_score::initpersstat("perks_drank", 0);
	self globallogic_score::initpersstat("bgbs_chewed", 0);
	self globallogic_score::initpersstat("headshots", 0);
	self globallogic_score::initpersstat("bgb_tokens_gained_this_game", 0);
	self globallogic_score::initpersstat("melee_kills", 0);
	self globallogic_score::initpersstat("grenade_kills", 0);
	self globallogic_score::initpersstat("doors_purchased", 0);
	self globallogic_score::initpersstat("distance_traveled", 0);
	self.distance_traveled = self globallogic_score::getpersstat("distance_traveled");
	self globallogic_score::initpersstat("total_shots", 0);
	self.total_shots = self globallogic_score::getpersstat("total_shots");
	self globallogic_score::initpersstat("hits", 0);
	self.hits = self globallogic_score::getpersstat("hits");
	self globallogic_score::initpersstat("misses", 0);
	self.misses = self globallogic_score::getpersstat("misses");
	self globallogic_score::initpersstat("deaths", 0);
	self.deaths = self globallogic_score::getpersstat("deaths");
	self globallogic_score::initpersstat("boards", 0);
	self globallogic_score::initpersstat("failed_revives", 0);
	self globallogic_score::initpersstat("sacrifices", 0);
	self globallogic_score::initpersstat("failed_sacrifices", 0);
	self globallogic_score::initpersstat("drops", 0);
	self globallogic_score::initpersstat("nuke_pickedup", 0);
	self globallogic_score::initpersstat("insta_kill_pickedup", 0);
	self globallogic_score::initpersstat("full_ammo_pickedup", 0);
	self globallogic_score::initpersstat("double_points_pickedup", 0);
	self globallogic_score::initpersstat("meat_stink_pickedup", 0);
	self globallogic_score::initpersstat("carpenter_pickedup", 0);
	self globallogic_score::initpersstat("fire_sale_pickedup", 0);
	self globallogic_score::initpersstat("minigun_pickedup", 0);
	self globallogic_score::initpersstat("island_seed_pickedup", 0);
	self globallogic_score::initpersstat("bonus_points_team_pickedup", 0);
	self globallogic_score::initpersstat("ww_grenade_pickedup", 0);
	self globallogic_score::initpersstat("use_magicbox", 0);
	self globallogic_score::initpersstat("grabbed_from_magicbox", 0);
	self globallogic_score::initpersstat("use_perk_random", 0);
	self globallogic_score::initpersstat("grabbed_from_perk_random", 0);
	self globallogic_score::initpersstat("use_pap", 0);
	self globallogic_score::initpersstat("pap_weapon_grabbed", 0);
	self globallogic_score::initpersstat("pap_weapon_not_grabbed", 0);
	self globallogic_score::initpersstat("specialty_armorvest_drank", 0);
	self globallogic_score::initpersstat("specialty_quickrevive_drank", 0);
	self globallogic_score::initpersstat("specialty_fastreload_drank", 0);
	self globallogic_score::initpersstat("specialty_additionalprimaryweapon_drank", 0);
	self globallogic_score::initpersstat("specialty_staminup_drank", 0);
	self globallogic_score::initpersstat("specialty_doubletap2_drank", 0);
	self globallogic_score::initpersstat("specialty_widowswine_drank", 0);
	self globallogic_score::initpersstat("specialty_deadshot_drank", 0);
	self globallogic_score::initpersstat("specialty_electriccherry_drank", 0);
	self globallogic_score::initpersstat("claymores_planted", 0);
	self globallogic_score::initpersstat("claymores_pickedup", 0);
	self globallogic_score::initpersstat("bouncingbetty_planted", 0);
	self globallogic_score::initpersstat("bouncingbetty_pickedup", 0);
	self globallogic_score::initpersstat("bouncingbetty_devil_planted", 0);
	self globallogic_score::initpersstat("bouncingbetty_devil_pickedup", 0);
	self globallogic_score::initpersstat("bouncingbetty_holly_planted", 0);
	self globallogic_score::initpersstat("bouncingbetty_holly_pickedup", 0);
	self globallogic_score::initpersstat("ballistic_knives_pickedup", 0);
	self globallogic_score::initpersstat("wallbuy_weapons_purchased", 0);
	self globallogic_score::initpersstat("ammo_purchased", 0);
	self globallogic_score::initpersstat("upgraded_ammo_purchased", 0);
	self globallogic_score::initpersstat("power_turnedon", 0);
	self globallogic_score::initpersstat("power_turnedoff", 0);
	self globallogic_score::initpersstat("planted_buildables_pickedup", 0);
	self globallogic_score::initpersstat("buildables_built", 0);
	self globallogic_score::initpersstat("time_played_total", 0);
	self globallogic_score::initpersstat("weighted_rounds_played", 0);
	self globallogic_score::initpersstat("zdogs_killed", 0);
	self globallogic_score::initpersstat("zspiders_killed", 0);
	self globallogic_score::initpersstat("zthrashers_killed", 0);
	self globallogic_score::initpersstat("zraps_killed", 0);
	self globallogic_score::initpersstat("zwasp_killed", 0);
	self globallogic_score::initpersstat("zsentinel_killed", 0);
	self globallogic_score::initpersstat("zraz_killed", 0);
	self globallogic_score::initpersstat("zdog_rounds_finished", 0);
	self globallogic_score::initpersstat("zdog_rounds_lost", 0);
	self globallogic_score::initpersstat("killed_by_zdog", 0);
	self globallogic_score::initpersstat("cheat_too_many_weapons", 0);
	self globallogic_score::initpersstat("cheat_out_of_playable", 0);
	self globallogic_score::initpersstat("cheat_too_friendly", 0);
	self globallogic_score::initpersstat("cheat_total", 0);
	self globallogic_score::initpersstat("castle_tram_token_pickedup", 0);
	self globallogic_score::initpersstat("total_points", 0);
	self globallogic_score::initpersstat("rounds", 0);
	if(level.resetplayerscoreeveryround)
	{
		self.pers["score"] = 0;
	}
	self.pers["score"] = level.player_starting_points;
	self.score = self.pers["score"];
	self incrementplayerstat("score", self.score);
	self add_map_stat("score", self.score);
	self.bgb_tokens_gained_this_game = 0;
	self globallogic_score::initpersstat("zteam", 0);
	if(isdefined(level.level_specific_stats_init))
	{
		[[level.level_specific_stats_init]]();
	}
	if(!isdefined(self.stats_this_frame))
	{
		self.pers_upgrade_force_test = 1;
		self.stats_this_frame = [];
		self.pers_upgrades_awarded = [];
	}
	self globallogic_score::initpersstat("ZM_DAILY_CHALLENGE_INGAME_TIME", 1, 1);
	self add_global_stat("ZM_DAILY_CHALLENGE_GAMES_PLAYED", 1);
}

/*
	Name: update_players_stats_at_match_end
	Namespace: zm_stats
	Checksum: 0xF69E65B8
	Offset: 0x1D18
	Size: 0x65E
	Parameters: 1
	Flags: Linked
*/
function update_players_stats_at_match_end(players)
{
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	game_mode = getdvarstring("ui_gametype");
	game_mode_group = level.scr_zm_ui_gametype_group;
	map_location_name = level.scr_zm_map_start_location;
	if(map_location_name == "")
	{
		map_location_name = "default";
	}
	if(isdefined(level.gamemodulewinningteam))
	{
		if(level.gamemodulewinningteam == "B")
		{
			matchrecorderincrementheaderstat("winningTeam", 1);
		}
		else if(level.gamemodulewinningteam == "A")
		{
			matchrecorderincrementheaderstat("winningTeam", 2);
		}
	}
	recordmatchsummaryzombieendgamedata(game_mode, game_mode_group, map_location_name, level.round_number);
	newtime = gettime();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(player util::is_bot())
		{
			continue;
		}
		distance = player get_stat_distance_traveled();
		player addplayerstat("distance_traveled", distance);
		player incrementplayerstat("time_played_total", player.pers["time_played_total"]);
		player add_map_stat("time_played_total", player.pers["time_played_total"]);
		recordplayermatchend(player);
		recordplayerstats(player, "presentAtEnd", 1);
		player zm_weapons::updateweapontimingszm(newtime);
		if(isdefined(level._game_module_stat_update_func))
		{
			player [[level._game_module_stat_update_func]]();
		}
		old_high_score = player get_global_stat("score");
		if(player.score_total > old_high_score)
		{
			player set_global_stat("score", player.score_total);
		}
		player set_global_stat("total_points", player.score_total);
		player set_global_stat("rounds", level.round_number);
		player set_global_stat("bgb_tokens_gained_this_game", player.bgb_tokens_gained_this_game);
		if(level.onlinegame)
		{
			player highwater_global_stat("HIGHEST_ROUND_REACHED", level.round_number);
			player highwater_map_stat("HIGHEST_ROUND_REACHED", level.round_number);
			player add_global_stat("TOTAL_ROUNDS_SURVIVED", level.round_number - 1);
			player add_map_stat("TOTAL_ROUNDS_SURVIVED", level.round_number - 1);
			player add_global_stat("TOTAL_GAMES_PLAYED", 1);
			player add_map_stat("TOTAL_GAMES_PLAYED", 1);
		}
		if(gamemodeismode(0))
		{
			player gamehistoryfinishmatch(4, 0, 0, 0, 0, 0);
			if(isdefined(player.pers["matchesPlayedStatsTracked"]))
			{
				gamemode = util::getcurrentgamemode();
				player globallogic::incrementmatchcompletionstat(gamemode, "played", "completed");
				if(isdefined(player.pers["matchesHostedStatsTracked"]))
				{
					player globallogic::incrementmatchcompletionstat(gamemode, "hosted", "completed");
					player.pers["matchesHostedStatsTracked"] = undefined;
				}
				player.pers["matchesPlayedStatsTracked"] = undefined;
			}
		}
		if(!isdefined(player.pers["previous_distance_traveled"]))
		{
			player.pers["previous_distance_traveled"] = 0;
		}
		distancethisround = int(player.pers["distance_traveled"] - player.pers["previous_distance_traveled"]);
		player.pers["previous_distance_traveled"] = player.pers["distance_traveled"];
		player incrementplayerstat("distance_traveled", distancethisround);
	}
}

/*
	Name: update_playing_utc_time
	Namespace: zm_stats
	Checksum: 0x7A4847DB
	Offset: 0x2380
	Size: 0x1DC
	Parameters: 1
	Flags: Linked
*/
function update_playing_utc_time(matchendutctime)
{
	current_days = int(matchendutctime / 86400);
	last_days = self get_global_stat("TIMESTAMPLASTDAY1");
	last_days = int(last_days / 86400);
	diff_days = current_days - last_days;
	timestamp_name = "";
	if(diff_days > 0)
	{
		for(i = 5; i > diff_days; i--)
		{
			timestamp_name = "TIMESTAMPLASTDAY" + (i - diff_days);
			timestamp_name_to = "TIMESTAMPLASTDAY" + i;
			timestamp_value = self get_global_stat(timestamp_name);
			self set_global_stat(timestamp_name_to, timestamp_value);
		}
		for(i = 2; i <= diff_days && i < 6; i++)
		{
			timestamp_name = "TIMESTAMPLASTDAY" + i;
			self set_global_stat(timestamp_name, 0);
		}
		self set_global_stat("TIMESTAMPLASTDAY1", matchendutctime);
	}
}

/*
	Name: survival_classic_custom_stat_update
	Namespace: zm_stats
	Checksum: 0x99EC1590
	Offset: 0x2568
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function survival_classic_custom_stat_update()
{
}

/*
	Name: grief_custom_stat_update
	Namespace: zm_stats
	Checksum: 0x99EC1590
	Offset: 0x2578
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function grief_custom_stat_update()
{
}

/*
	Name: get_global_stat
	Namespace: zm_stats
	Checksum: 0x2DF621D2
	Offset: 0x2588
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function get_global_stat(stat_name)
{
	return self getdstat("PlayerStatsList", stat_name, "StatValue");
}

/*
	Name: set_global_stat
	Namespace: zm_stats
	Checksum: 0x51C49EB7
	Offset: 0x25C8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function set_global_stat(stat_name, value)
{
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	self setdstat("PlayerStatsList", stat_name, "StatValue", value);
}

/*
	Name: add_global_stat
	Namespace: zm_stats
	Checksum: 0x2B89A18F
	Offset: 0x2630
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function add_global_stat(stat_name, value)
{
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	self adddstat("PlayerStatsList", stat_name, "StatValue", value);
}

/*
	Name: increment_global_stat
	Namespace: zm_stats
	Checksum: 0x74D674FB
	Offset: 0x2698
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function increment_global_stat(stat_name)
{
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	self adddstat("PlayerStatsList", stat_name, "StatValue", 1);
}

/*
	Name: highwater_global_stat
	Namespace: zm_stats
	Checksum: 0xC017DCBF
	Offset: 0x26F8
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function highwater_global_stat(stat_name, value)
{
	if(value > get_global_stat(stat_name))
	{
		set_global_stat(stat_name, value);
	}
}

/*
	Name: add_client_stat
	Namespace: zm_stats
	Checksum: 0x7C071AC4
	Offset: 0x2750
	Size: 0x7E
	Parameters: 3
	Flags: Linked
*/
function add_client_stat(stat_name, stat_value, include_gametype)
{
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	if(!isdefined(include_gametype))
	{
		include_gametype = 1;
	}
	self globallogic_score::incpersstat(stat_name, stat_value, 0, include_gametype);
	self.stats_this_frame[stat_name] = 1;
}

/*
	Name: increment_player_stat
	Namespace: zm_stats
	Checksum: 0x83097ECA
	Offset: 0x27D8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function increment_player_stat(stat_name)
{
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	self incrementplayerstat(stat_name, 1);
}

/*
	Name: increment_root_stat
	Namespace: zm_stats
	Checksum: 0xB51A0380
	Offset: 0x2828
	Size: 0x4C
	Parameters: 2
	Flags: None
*/
function increment_root_stat(stat_name, stat_value)
{
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	self adddstat(stat_name, stat_value);
}

/*
	Name: increment_client_stat
	Namespace: zm_stats
	Checksum: 0x971DCCFB
	Offset: 0x2880
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function increment_client_stat(stat_name, include_gametype)
{
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	add_client_stat(stat_name, 1, include_gametype);
}

/*
	Name: set_client_stat
	Namespace: zm_stats
	Checksum: 0xD4111DE9
	Offset: 0x28D8
	Size: 0x96
	Parameters: 3
	Flags: Linked
*/
function set_client_stat(stat_name, stat_value, include_gametype)
{
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	current_stat_count = self globallogic_score::getpersstat(stat_name);
	self globallogic_score::incpersstat(stat_name, stat_value - current_stat_count, 0, include_gametype);
	self.stats_this_frame[stat_name] = 1;
}

/*
	Name: zero_client_stat
	Namespace: zm_stats
	Checksum: 0x8BFC54BC
	Offset: 0x2978
	Size: 0x8E
	Parameters: 2
	Flags: Linked
*/
function zero_client_stat(stat_name, include_gametype)
{
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	current_stat_count = self globallogic_score::getpersstat(stat_name);
	self globallogic_score::incpersstat(stat_name, current_stat_count * -1, 0, include_gametype);
	self.stats_this_frame[stat_name] = 1;
}

/*
	Name: get_map_stat
	Namespace: zm_stats
	Checksum: 0xB1C5B003
	Offset: 0x2A10
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function get_map_stat(stat_name)
{
	return self getdstat("PlayerStatsByMap", level.script, "stats", stat_name, "StatValue");
}

/*
	Name: set_map_stat
	Namespace: zm_stats
	Checksum: 0xF76A9A96
	Offset: 0x2A60
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function set_map_stat(stat_name, value)
{
	if(!level.onlinegame || (isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats))
	{
		return;
	}
	self setdstat("PlayerStatsByMap", level.script, "stats", stat_name, "StatValue", value);
}

/*
	Name: add_map_stat
	Namespace: zm_stats
	Checksum: 0x3DE567AB
	Offset: 0x2AE0
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function add_map_stat(stat_name, value)
{
	if(!level.onlinegame || (isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats))
	{
		return;
	}
	self adddstat("PlayerStatsByMap", level.script, "stats", stat_name, "StatValue", value);
}

/*
	Name: increment_map_stat
	Namespace: zm_stats
	Checksum: 0x3783D560
	Offset: 0x2B60
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function increment_map_stat(stat_name)
{
	if(!level.onlinegame || (isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats))
	{
		return;
	}
	self adddstat("PlayerStatsByMap", level.script, "stats", stat_name, "StatValue", 1);
}

/*
	Name: highwater_map_stat
	Namespace: zm_stats
	Checksum: 0xB8037726
	Offset: 0x2BD8
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function highwater_map_stat(stat_name, value)
{
	if(value > get_map_stat(stat_name))
	{
		set_map_stat(stat_name, value);
	}
}

/*
	Name: increment_map_cheat_stat
	Namespace: zm_stats
	Checksum: 0x1DCCFBD8
	Offset: 0x2C30
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function increment_map_cheat_stat(stat_name)
{
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	self adddstat("PlayerStatsByMap", level.script, "cheats", stat_name, 1);
}

/*
	Name: increment_challenge_stat
	Namespace: zm_stats
	Checksum: 0xD73691F7
	Offset: 0x2C98
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function increment_challenge_stat(stat_name, amount = 1)
{
	if(!level.onlinegame || (isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats))
	{
		return;
	}
	self addplayerstat(stat_name, amount);
}

/*
	Name: get_stat_distance_traveled
	Namespace: zm_stats
	Checksum: 0xB68FBA3C
	Offset: 0x2D10
	Size: 0xB6
	Parameters: 0
	Flags: Linked
*/
function get_stat_distance_traveled()
{
	miles = int(self.pers["distance_traveled"] / 63360);
	remainder = (self.pers["distance_traveled"] / 63360) - miles;
	if(miles < 1 && remainder < 0.5)
	{
		miles = 1;
	}
	else if(remainder >= 0.5)
	{
		miles++;
	}
	return miles;
}

/*
	Name: get_stat_round_number
	Namespace: zm_stats
	Checksum: 0x97E9D24A
	Offset: 0x2DD0
	Size: 0x12
	Parameters: 0
	Flags: Linked
*/
function get_stat_round_number()
{
	return zm::get_round_number();
}

/*
	Name: get_stat_combined_rank_value_survival_classic
	Namespace: zm_stats
	Checksum: 0x9BDD147
	Offset: 0x2DF0
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function get_stat_combined_rank_value_survival_classic()
{
	rounds = get_stat_round_number();
	kills = self.pers["kills"];
	if(rounds > 99)
	{
		rounds = 99;
	}
	result = (rounds * 10000000) + kills;
	return result;
}

/*
	Name: update_global_counters_on_match_end
	Namespace: zm_stats
	Checksum: 0x4CE04057
	Offset: 0x2E78
	Size: 0x12AC
	Parameters: 0
	Flags: Linked
*/
function update_global_counters_on_match_end()
{
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	deaths = 0;
	kills = 0;
	melee_kills = 0;
	headshots = 0;
	suicides = 0;
	downs = 0;
	revives = 0;
	perks_drank = 0;
	doors_purchased = 0;
	distance_traveled = 0;
	total_shots = 0;
	boards = 0;
	sacrifices = 0;
	drops = 0;
	nuke_pickedup = 0;
	insta_kill_pickedup = 0;
	full_ammo_pickedup = 0;
	double_points_pickedup = 0;
	meat_stink_pickedup = 0;
	carpenter_pickedup = 0;
	fire_sale_pickedup = 0;
	minigun_pickedup = 0;
	island_seed_pickedup = 0;
	bonus_points_team_pickedup = 0;
	ww_grenade_pickedup = 0;
	zombie_blood_pickedup = 0;
	use_magicbox = 0;
	grabbed_from_magicbox = 0;
	use_perk_random = 0;
	grabbed_from_perk_random = 0;
	use_pap = 0;
	pap_weapon_grabbed = 0;
	specialty_armorvest_drank = 0;
	specialty_quickrevive_drank = 0;
	specialty_fastreload_drank = 0;
	specialty_additionalprimaryweapon_drank = 0;
	specialty_staminup_drank = 0;
	specialty_doubletap2_drank = 0;
	specialty_widowswine_drank = 0;
	specialty_deadshot_drank = 0;
	claymores_planted = 0;
	claymores_pickedup = 0;
	bouncingbetty_planted = 0;
	ballistic_knives_pickedup = 0;
	wallbuy_weapons_purchased = 0;
	power_turnedon = 0;
	power_turnedoff = 0;
	planted_buildables_pickedup = 0;
	ammo_purchased = 0;
	upgraded_ammo_purchased = 0;
	buildables_built = 0;
	time_played = 0;
	cheat_too_many_weapons = 0;
	cheat_out_of_playable_area = 0;
	cheat_too_friendly = 0;
	cheat_total = 0;
	players = getplayers();
	foreach(player in players)
	{
		deaths = deaths + player.pers["deaths"];
		kills = kills + player.pers["kills"];
		headshots = headshots + player.pers["headshots"];
		suicides = suicides + player.pers["suicides"];
		melee_kills = melee_kills + player.pers["melee_kills"];
		downs = downs + player.pers["downs"];
		revives = revives + player.pers["revives"];
		perks_drank = perks_drank + player.pers["perks_drank"];
		specialty_armorvest_drank = specialty_armorvest_drank + player.pers["specialty_armorvest_drank"];
		specialty_quickrevive_drank = specialty_quickrevive_drank + player.pers["specialty_quickrevive_drank"];
		specialty_fastreload_drank = specialty_fastreload_drank + player.pers["specialty_fastreload_drank"];
		specialty_additionalprimaryweapon_drank = specialty_additionalprimaryweapon_drank + player.pers["specialty_additionalprimaryweapon_drank"];
		specialty_staminup_drank = specialty_staminup_drank + player.pers["specialty_staminup_drank"];
		specialty_doubletap2_drank = specialty_doubletap2_drank + player.pers["specialty_doubletap2_drank"];
		specialty_widowswine_drank = specialty_widowswine_drank + player.pers["specialty_widowswine_drank"];
		specialty_deadshot_drank = specialty_deadshot_drank + player.pers["specialty_deadshot_drank"];
		doors_purchased = doors_purchased + player.pers["doors_purchased"];
		distance_traveled = distance_traveled + player get_stat_distance_traveled();
		boards = boards + player.pers["boards"];
		sacrifices = sacrifices + player.pers["sacrifices"];
		drops = drops + player.pers["drops"];
		nuke_pickedup = nuke_pickedup + player.pers["nuke_pickedup"];
		insta_kill_pickedup = insta_kill_pickedup + player.pers["insta_kill_pickedup"];
		full_ammo_pickedup = full_ammo_pickedup + player.pers["full_ammo_pickedup"];
		double_points_pickedup = double_points_pickedup + player.pers["double_points_pickedup"];
		meat_stink_pickedup = meat_stink_pickedup + player.pers["meat_stink_pickedup"];
		carpenter_pickedup = carpenter_pickedup + player.pers["carpenter_pickedup"];
		fire_sale_pickedup = fire_sale_pickedup + player.pers["fire_sale_pickedup"];
		minigun_pickedup = minigun_pickedup + player.pers["minigun_pickedup"];
		island_seed_pickedup = island_seed_pickedup + player.pers["island_seed_pickedup"];
		bonus_points_team_pickedup = bonus_points_team_pickedup + player.pers["bonus_points_team_pickedup"];
		ww_grenade_pickedup = ww_grenade_pickedup + player.pers["ww_grenade_pickedup"];
		use_magicbox = use_magicbox + player.pers["use_magicbox"];
		grabbed_from_magicbox = grabbed_from_magicbox + player.pers["grabbed_from_magicbox"];
		use_perk_random = use_perk_random + player.pers["use_perk_random"];
		grabbed_from_perk_random = grabbed_from_perk_random + player.pers["grabbed_from_perk_random"];
		use_pap = use_pap + player.pers["use_pap"];
		pap_weapon_grabbed = pap_weapon_grabbed + player.pers["pap_weapon_grabbed"];
		claymores_planted = claymores_planted + player.pers["claymores_planted"];
		claymores_pickedup = claymores_pickedup + player.pers["claymores_pickedup"];
		bouncingbetty_planted = bouncingbetty_planted + player.pers["bouncingbetty_planted"];
		ballistic_knives_pickedup = ballistic_knives_pickedup + player.pers["ballistic_knives_pickedup"];
		wallbuy_weapons_purchased = wallbuy_weapons_purchased + player.pers["wallbuy_weapons_purchased"];
		power_turnedon = power_turnedon + player.pers["power_turnedon"];
		power_turnedoff = power_turnedoff + player.pers["power_turnedoff"];
		planted_buildables_pickedup = planted_buildables_pickedup + player.pers["planted_buildables_pickedup"];
		buildables_built = buildables_built + player.pers["buildables_built"];
		ammo_purchased = ammo_purchased + player.pers["ammo_purchased"];
		upgraded_ammo_purchased = upgraded_ammo_purchased + player.pers["upgraded_ammo_purchased"];
		total_shots = total_shots + player.total_shots;
		time_played = time_played + player.pers["time_played_total"];
		cheat_too_many_weapons = cheat_too_many_weapons + player.pers["cheat_too_many_weapons"];
		cheat_out_of_playable_area = cheat_out_of_playable_area + player.pers["cheat_out_of_playable"];
		cheat_too_friendly = cheat_too_friendly + player.pers["cheat_too_friendly"];
		cheat_total = cheat_total + player.pers["cheat_total"];
	}
	game_mode = getdvarstring("ui_gametype");
	incrementcounter("global_zm_" + game_mode, 1);
	incrementcounter("global_zm_games", 1);
	if("zclassic" == game_mode || "zm_nuked" == level.script)
	{
		incrementcounter("global_zm_games_" + level.script, 1);
	}
	incrementcounter("global_zm_killed", level.global_zombies_killed);
	incrementcounter("global_zm_killed_by_players", kills);
	incrementcounter("global_zm_killed_by_traps", level.zombie_trap_killed_count);
	incrementcounter("global_zm_headshots", headshots);
	incrementcounter("global_zm_suicides", suicides);
	incrementcounter("global_zm_melee_kills", melee_kills);
	incrementcounter("global_zm_downs", downs);
	incrementcounter("global_zm_deaths", deaths);
	incrementcounter("global_zm_revives", revives);
	incrementcounter("global_zm_perks_drank", perks_drank);
	incrementcounter("global_zm_specialty_armorvest_drank", specialty_armorvest_drank);
	incrementcounter("global_zm_specialty_quickrevive_drank", specialty_quickrevive_drank);
	incrementcounter("global_zm_specialty_fastreload_drank", specialty_fastreload_drank);
	incrementcounter("global_zm_specialty_additionalprimaryweapon_drank", specialty_additionalprimaryweapon_drank);
	incrementcounter("global_zm_specialty_staminup_drank", specialty_staminup_drank);
	incrementcounter("global_zm_specialty_doubletap2_drank", specialty_doubletap2_drank);
	incrementcounter("global_zm_specialty_widowswine_drank", specialty_widowswine_drank);
	incrementcounter("global_zm_specialty_deadshot_drank", specialty_deadshot_drank);
	incrementcounter("global_zm_distance_traveled", int(distance_traveled));
	incrementcounter("global_zm_doors_purchased", doors_purchased);
	incrementcounter("global_zm_boards", boards);
	incrementcounter("global_zm_sacrifices", sacrifices);
	incrementcounter("global_zm_drops", drops);
	incrementcounter("global_zm_total_nuke_pickedup", nuke_pickedup);
	incrementcounter("global_zm_total_insta_kill_pickedup", insta_kill_pickedup);
	incrementcounter("global_zm_total_full_ammo_pickedup", full_ammo_pickedup);
	incrementcounter("global_zm_total_double_points_pickedup", double_points_pickedup);
	incrementcounter("global_zm_total_meat_stink_pickedup", double_points_pickedup);
	incrementcounter("global_zm_total_carpenter_pickedup", carpenter_pickedup);
	incrementcounter("global_zm_total_fire_sale_pickedup", fire_sale_pickedup);
	incrementcounter("global_zm_total_minigun_pickedup", minigun_pickedup);
	incrementcounter("global_zm_total_island_seed_pickedup", island_seed_pickedup);
	incrementcounter("global_zm_total_zombie_blood_pickedup", zombie_blood_pickedup);
	incrementcounter("global_zm_use_magicbox", use_magicbox);
	incrementcounter("global_zm_grabbed_from_magicbox", grabbed_from_magicbox);
	incrementcounter("global_zm_use_perk_random", use_perk_random);
	incrementcounter("global_zm_grabbed_from_perk_random", grabbed_from_perk_random);
	incrementcounter("global_zm_use_pap", use_pap);
	incrementcounter("global_zm_pap_weapon_grabbed", pap_weapon_grabbed);
	incrementcounter("global_zm_claymores_planted", claymores_planted);
	incrementcounter("global_zm_claymores_pickedup", claymores_pickedup);
	incrementcounter("global_zm_ballistic_knives_pickedup", ballistic_knives_pickedup);
	incrementcounter("global_zm_wallbuy_weapons_purchased", wallbuy_weapons_purchased);
	incrementcounter("global_zm_power_turnedon", power_turnedon);
	incrementcounter("global_zm_power_turnedoff", power_turnedoff);
	incrementcounter("global_zm_planted_buildables_pickedup", planted_buildables_pickedup);
	incrementcounter("global_zm_buildables_built", buildables_built);
	incrementcounter("global_zm_ammo_purchased", ammo_purchased);
	incrementcounter("global_zm_upgraded_ammo_purchased", upgraded_ammo_purchased);
	incrementcounter("global_zm_total_shots", total_shots);
	incrementcounter("global_zm_time_played", time_played);
	incrementcounter("global_zm_cheat_players_too_friendly", cheat_too_friendly);
	incrementcounter("global_zm_cheats_cheat_too_many_weapons", cheat_too_many_weapons);
	incrementcounter("global_zm_cheats_out_of_playable", cheat_out_of_playable_area);
	incrementcounter("global_zm_total_cheats", cheat_total);
}

/*
	Name: get_specific_stat
	Namespace: zm_stats
	Checksum: 0x16A3727A
	Offset: 0x4130
	Size: 0x3A
	Parameters: 2
	Flags: None
*/
function get_specific_stat(stat_category, stat_name)
{
	return self getdstat(stat_category, stat_name, "StatValue");
}

/*
	Name: initializematchstats
	Namespace: zm_stats
	Checksum: 0x937E02E3
	Offset: 0x4178
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function initializematchstats()
{
	if(!level.onlinegame || !gamemodeismode(0))
	{
		return;
	}
	self.pers["lastHighestScore"] = self getdstat("HighestStats", "highest_score");
	currgametype = level.gametype;
	self gamehistorystartmatch(getgametypeenumfromname(currgametype, 0));
}

/*
	Name: adjustrecentstats
	Namespace: zm_stats
	Checksum: 0x666EEB34
	Offset: 0x4220
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function adjustrecentstats()
{
	/#
		if(getdvarint("") == 1 || getdvarint("") == 1)
		{
			return;
		}
	#/
	initializematchstats();
}

/*
	Name: uploadstatssoon
	Namespace: zm_stats
	Checksum: 0xEA9AAA5A
	Offset: 0x4290
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function uploadstatssoon()
{
	self notify(#"upload_stats_soon");
	self endon(#"upload_stats_soon");
	self endon(#"disconnect");
	wait(1);
	uploadstats(self);
}

