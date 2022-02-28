// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_bgb_token;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_score;

/*
	Name: __init__sytem__
	Namespace: zm_score
	Checksum: 0x3E892F09
	Offset: 0x6D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_score", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_score
	Checksum: 0x783F4106
	Offset: 0x718
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	score_cf_register_info("damage", 1, 7);
	score_cf_register_info("death_normal", 1, 3);
	score_cf_register_info("death_torso", 1, 3);
	score_cf_register_info("death_neck", 1, 3);
	score_cf_register_info("death_head", 1, 3);
	score_cf_register_info("death_melee", 1, 3);
	clientfield::register("clientuimodel", "hudItems.doublePointsActive", 1, 1, "int");
	clientfield::register("clientuimodel", "hudItems.showDpadUp", 1, 1, "int");
	clientfield::register("clientuimodel", "hudItems.showDpadDown", 1, 1, "int");
	clientfield::register("clientuimodel", "hudItems.showDpadLeft", 1, 1, "int");
	clientfield::register("clientuimodel", "hudItems.showDpadRight", 1, 1, "int");
	callback::on_spawned(&player_on_spawned);
	level.score_total = 0;
	level.a_func_score_events = [];
}

/*
	Name: register_score_event
	Namespace: zm_score
	Checksum: 0x91648EB7
	Offset: 0x910
	Size: 0x26
	Parameters: 2
	Flags: None
*/
function register_score_event(str_event, func_callback)
{
	level.a_func_score_events[str_event] = func_callback;
}

/*
	Name: reset_doublexp_timer
	Namespace: zm_score
	Checksum: 0xD3A8E937
	Offset: 0x940
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function reset_doublexp_timer()
{
	self notify(#"reset_doublexp_timer");
	self thread doublexp_timer();
}

/*
	Name: doublexp_timer
	Namespace: zm_score
	Checksum: 0x485763C5
	Offset: 0x970
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function doublexp_timer()
{
	self notify(#"doublexp_timer");
	self endon(#"doublexp_timer");
	self endon(#"reset_doublexp_timer");
	self endon(#"end_game");
	level flagsys::wait_till("start_zombie_round_logic");
	if(!level.onlinegame)
	{
		return;
	}
	wait(60);
	if(level.onlinegame)
	{
		if(!isdefined(self))
		{
			return;
		}
		self doublexptimerfired();
	}
	self thread reset_doublexp_timer();
}

/*
	Name: player_on_spawned
	Namespace: zm_score
	Checksum: 0xF1800B87
	Offset: 0xA28
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function player_on_spawned()
{
	util::wait_network_frame();
	self thread doublexp_timer();
	if(isdefined(self))
	{
		self.ready_for_score_events = 1;
	}
}

/*
	Name: score_cf_register_info
	Namespace: zm_score
	Checksum: 0x4F9DCFF8
	Offset: 0xA70
	Size: 0x9E
	Parameters: 3
	Flags: Linked
*/
function score_cf_register_info(name, version, max_count)
{
	for(i = 0; i < 4; i++)
	{
		clientfield::register("clientuimodel", (("PlayerList.client" + i) + ".score_cf_") + name, version, getminbitcountfornum(max_count), "counter");
	}
}

/*
	Name: score_cf_increment_info
	Namespace: zm_score
	Checksum: 0xDA6FB307
	Offset: 0xB18
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function score_cf_increment_info(name)
{
	foreach(player in level.players)
	{
		thread wait_score_cf_increment_info(player, (("PlayerList.client" + self.entity_num) + ".score_cf_") + name);
	}
}

/*
	Name: wait_score_cf_increment_info
	Namespace: zm_score
	Checksum: 0xB5F8F17C
	Offset: 0xBD8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function wait_score_cf_increment_info(player, cf)
{
	if(isdefined(player) && (isdefined(player.ready_for_score_events) && player.ready_for_score_events))
	{
		player clientfield::increment_uimodel(cf);
	}
}

/*
	Name: player_add_points
	Namespace: zm_score
	Checksum: 0xA56108CA
	Offset: 0xC40
	Size: 0x890
	Parameters: 6
	Flags: Linked
*/
function player_add_points(event, mod, hit_location, is_dog, zombie_team, damage_weapon)
{
	if(level.intermission)
	{
		return;
	}
	if(!zm_utility::is_player_valid(self))
	{
		return;
	}
	player_points = 0;
	team_points = 0;
	multiplier = get_points_multiplier(self);
	if(isdefined(level.a_func_score_events[event]))
	{
		player_points = [[level.a_func_score_events[event]]](event, mod, hit_location, zombie_team, damage_weapon);
	}
	else
	{
		switch(event)
		{
			case "death_raps":
			case "death_wasp":
			{
				player_points = mod;
				scoreevents::processscoreevent("kill", self, undefined, damage_weapon);
				break;
			}
			case "death_spider":
			{
				player_points = get_zombie_death_player_points();
				team_points = get_zombie_death_team_points();
				scoreevents::processscoreevent("kill_spider", self, undefined, damage_weapon);
				break;
			}
			case "death_thrasher":
			{
				player_points = get_zombie_death_player_points();
				team_points = get_zombie_death_team_points();
				points = self player_add_points_kill_bonus(mod, hit_location, damage_weapon);
				if(level.zombie_vars[self.team]["zombie_powerup_insta_kill_on"] == 1 && mod == "MOD_UNKNOWN")
				{
					points = points * 2;
				}
				player_points = player_points + points;
				player_points = player_points * 2;
				if(team_points > 0)
				{
					team_points = team_points + points;
				}
				if(mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH")
				{
					self zm_stats::increment_client_stat("grenade_kills");
					self zm_stats::increment_player_stat("grenade_kills");
				}
				scoreevents::processscoreevent("kill_thrasher", self, undefined, damage_weapon);
				break;
			}
			case "death":
			{
				player_points = get_zombie_death_player_points();
				team_points = get_zombie_death_team_points();
				points = self player_add_points_kill_bonus(mod, hit_location, damage_weapon, player_points);
				if(level.zombie_vars[self.team]["zombie_powerup_insta_kill_on"] == 1 && mod == "MOD_UNKNOWN")
				{
					points = points * 2;
				}
				player_points = player_points + points;
				if(team_points > 0)
				{
					team_points = team_points + points;
				}
				if(mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH")
				{
					self zm_stats::increment_client_stat("grenade_kills");
					self zm_stats::increment_player_stat("grenade_kills");
				}
				break;
			}
			case "death_mechz":
			{
				player_points = mod;
				scoreevents::processscoreevent("kill_mechz", self, undefined, damage_weapon);
				break;
			}
			case "ballistic_knife_death":
			{
				player_points = get_zombie_death_player_points() + level.zombie_vars["zombie_score_bonus_melee"];
				self score_cf_increment_info("death_melee");
				break;
			}
			case "damage_light":
			{
				player_points = level.zombie_vars["zombie_score_damage_light"];
				self score_cf_increment_info("damage");
				break;
			}
			case "damage":
			{
				player_points = level.zombie_vars["zombie_score_damage_normal"];
				self score_cf_increment_info("damage");
				break;
			}
			case "damage_ads":
			{
				player_points = int(level.zombie_vars["zombie_score_damage_normal"] * 1.25);
				self score_cf_increment_info("damage");
				break;
			}
			case "carpenter_powerup":
			case "rebuild_board":
			{
				player_points = mod;
				break;
			}
			case "bonus_points_powerup":
			{
				player_points = mod;
				break;
			}
			case "nuke_powerup":
			{
				player_points = mod;
				team_points = mod;
				break;
			}
			case "jetgun_fling":
			case "riotshield_fling":
			case "thundergun_fling":
			{
				player_points = mod;
				scoreevents::processscoreevent("kill", self, undefined, damage_weapon);
				break;
			}
			case "hacker_transfer":
			{
				player_points = mod;
				break;
			}
			case "reviver":
			{
				player_points = mod;
				break;
			}
			case "vulture":
			{
				player_points = mod;
				break;
			}
			case "build_wallbuy":
			{
				player_points = mod;
				break;
			}
			case "ww_webbed":
			{
				player_points = mod;
				break;
			}
			default:
			{
				/#
					assert(0, "");
				#/
				break;
			}
		}
	}
	if(isdefined(level.player_score_override))
	{
		player_points = self [[level.player_score_override]](damage_weapon, player_points);
	}
	if(isdefined(level.team_score_override))
	{
		team_points = self [[level.team_score_override]](damage_weapon, team_points);
	}
	player_points = multiplier * zm_utility::round_up_score(player_points, 10);
	team_points = multiplier * zm_utility::round_up_score(team_points, 10);
	if(isdefined(self.point_split_receiver) && (event == "death" || event == "ballistic_knife_death"))
	{
		split_player_points = player_points - (zm_utility::round_up_score(player_points * self.point_split_keep_percent, 10));
		self.point_split_receiver add_to_player_score(split_player_points);
		player_points = player_points - split_player_points;
	}
	if(isdefined(level.pers_upgrade_pistol_points) && level.pers_upgrade_pistol_points)
	{
		player_points = self zm_pers_upgrades_functions::pers_upgrade_pistol_points_set_score(player_points, event, mod, damage_weapon);
	}
	self add_to_player_score(player_points, 1, event);
	self.pers["score"] = self.score;
	if(isdefined(level._game_module_point_adjustment))
	{
		level [[level._game_module_point_adjustment]](self, zombie_team, player_points);
	}
}

/*
	Name: get_points_multiplier
	Namespace: zm_score
	Checksum: 0x7E9FECE7
	Offset: 0x14D8
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function get_points_multiplier(player)
{
	multiplier = level.zombie_vars[player.team]["zombie_point_scalar"];
	if(isdefined(level.current_game_module) && level.current_game_module == 2)
	{
		if(isdefined(level._race_team_double_points) && level._race_team_double_points == player._race_team)
		{
			return multiplier;
		}
		return 1;
	}
	return multiplier;
}

/*
	Name: get_zombie_death_player_points
	Namespace: zm_score
	Checksum: 0x61EE3752
	Offset: 0x1570
	Size: 0xC6
	Parameters: 0
	Flags: Linked
*/
function get_zombie_death_player_points()
{
	players = getplayers();
	if(players.size == 1)
	{
		points = level.zombie_vars["zombie_score_kill_1player"];
	}
	else
	{
		if(players.size == 2)
		{
			points = level.zombie_vars["zombie_score_kill_2player"];
		}
		else
		{
			if(players.size == 3)
			{
				points = level.zombie_vars["zombie_score_kill_3player"];
			}
			else
			{
				points = level.zombie_vars["zombie_score_kill_4player"];
			}
		}
	}
	return points;
}

/*
	Name: get_zombie_death_team_points
	Namespace: zm_score
	Checksum: 0x1C06FDA4
	Offset: 0x1640
	Size: 0x6
	Parameters: 0
	Flags: Linked
*/
function get_zombie_death_team_points()
{
	return false;
}

/*
	Name: player_add_points_kill_bonus
	Namespace: zm_score
	Checksum: 0xA7C39CDA
	Offset: 0x1650
	Size: 0x2CA
	Parameters: 4
	Flags: Linked
*/
function player_add_points_kill_bonus(mod, hit_location, weapon, player_points = undefined)
{
	if(mod != "MOD_MELEE")
	{
		if("head" == hit_location || "helmet" == hit_location)
		{
			scoreevents::processscoreevent("headshot", self, undefined, weapon);
		}
		else
		{
			scoreevents::processscoreevent("kill", self, undefined, weapon);
		}
	}
	if(isdefined(level.player_score_override))
	{
		new_points = self [[level.player_score_override]](weapon, player_points);
		if(new_points > 0 && new_points != player_points)
		{
			return 0;
		}
	}
	if(mod == "MOD_MELEE")
	{
		self score_cf_increment_info("death_melee");
		scoreevents::processscoreevent("melee_kill", self, undefined, weapon);
		return level.zombie_vars["zombie_score_bonus_melee"];
	}
	if(mod == "MOD_BURNED")
	{
		self score_cf_increment_info("death_torso");
		return level.zombie_vars["zombie_score_bonus_burn"];
	}
	score = 0;
	if(isdefined(hit_location))
	{
		switch(hit_location)
		{
			case "head":
			case "helmet":
			{
				self score_cf_increment_info("death_head");
				score = level.zombie_vars["zombie_score_bonus_head"];
				break;
			}
			case "neck":
			{
				self score_cf_increment_info("death_neck");
				score = level.zombie_vars["zombie_score_bonus_neck"];
				break;
			}
			case "torso_lower":
			case "torso_upper":
			{
				self score_cf_increment_info("death_torso");
				score = level.zombie_vars["zombie_score_bonus_torso"];
				break;
			}
			default:
			{
				self score_cf_increment_info("death_normal");
				break;
			}
		}
	}
	return score;
}

/*
	Name: player_reduce_points
	Namespace: zm_score
	Checksum: 0x99C33277
	Offset: 0x1928
	Size: 0x214
	Parameters: 2
	Flags: Linked
*/
function player_reduce_points(event, n_amount)
{
	if(level.intermission)
	{
		return;
	}
	points = 0;
	switch(event)
	{
		case "take_all":
		{
			points = self.score;
			break;
		}
		case "take_half":
		{
			points = int(self.score / 2);
			break;
		}
		case "take_specified":
		{
			points = n_amount;
			break;
		}
		case "no_revive_penalty":
		{
			percent = level.zombie_vars["penalty_no_revive"];
			points = self.score * percent;
			break;
		}
		case "died":
		{
			percent = level.zombie_vars["penalty_died"];
			points = self.score * percent;
			break;
		}
		case "downed":
		{
			percent = level.zombie_vars["penalty_downed"];
			self notify(#"i_am_down");
			points = self.score * percent;
			self.score_lost_when_downed = zm_utility::round_up_to_ten(int(points));
			break;
		}
		default:
		{
			/#
				assert(0, "");
			#/
			break;
		}
	}
	points = self.score - zm_utility::round_up_to_ten(int(points));
	if(points < 0)
	{
		points = 0;
	}
	self.score = points;
}

/*
	Name: add_to_player_score
	Namespace: zm_score
	Checksum: 0x6AC0D6A6
	Offset: 0x1B48
	Size: 0x138
	Parameters: 3
	Flags: Linked
*/
function add_to_player_score(points, b_add_to_total = 1, str_awarded_by = "")
{
	if(!isdefined(points) || level.intermission)
	{
		return;
	}
	points = zm_utility::round_up_score(points, 10);
	n_points_to_add_to_currency = bgb::add_to_player_score_override(points, str_awarded_by);
	self.score = self.score + n_points_to_add_to_currency;
	self.pers["score"] = self.score;
	self incrementplayerstat("scoreEarned", n_points_to_add_to_currency);
	level notify(#"earned_points", self, points);
	if(b_add_to_total)
	{
		self.score_total = self.score_total + points;
		level.score_total = level.score_total + points;
	}
}

/*
	Name: minus_to_player_score
	Namespace: zm_score
	Checksum: 0x9B24402B
	Offset: 0x1C88
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function minus_to_player_score(points)
{
	if(!isdefined(points) || level.intermission)
	{
		return;
	}
	if(self bgb::is_enabled("zm_bgb_shopping_free"))
	{
		self bgb::do_one_shot_use();
		self playsoundtoplayer("zmb_bgb_shoppingfree_coinreturn", self);
		return;
	}
	self.score = self.score - points;
	self.pers["score"] = self.score;
	self incrementplayerstat("scoreSpent", points);
	level notify(#"spent_points", self, points);
	if(isdefined(level.bgb_in_use) && level.bgb_in_use && level.onlinegame)
	{
		self bgb_token::function_51cf4361(points);
	}
}

/*
	Name: add_to_team_score
	Namespace: zm_score
	Checksum: 0x78584A02
	Offset: 0x1DB0
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function add_to_team_score(points)
{
}

/*
	Name: minus_to_team_score
	Namespace: zm_score
	Checksum: 0x1B93DF85
	Offset: 0x1DC8
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function minus_to_team_score(points)
{
}

/*
	Name: player_died_penalty
	Namespace: zm_score
	Checksum: 0xE69D43F9
	Offset: 0x1DE0
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function player_died_penalty()
{
	players = getplayers(self.team);
	for(i = 0; i < players.size; i++)
	{
		if(players[i] != self && !players[i].is_zombie)
		{
			players[i] player_reduce_points("no_revive_penalty");
		}
	}
}

/*
	Name: player_downed_penalty
	Namespace: zm_score
	Checksum: 0x2586A463
	Offset: 0x1E90
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function player_downed_penalty()
{
	/#
		println("");
	#/
	self player_reduce_points("downed");
}

/*
	Name: can_player_purchase
	Namespace: zm_score
	Checksum: 0x77A3BEE6
	Offset: 0x1EE0
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function can_player_purchase(n_cost)
{
	if(self.score >= n_cost)
	{
		return true;
	}
	if(self bgb::is_enabled("zm_bgb_shopping_free"))
	{
		return true;
	}
	return false;
}

