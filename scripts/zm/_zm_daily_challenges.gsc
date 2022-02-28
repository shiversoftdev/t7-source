// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\table_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\gametypes\_globallogic_score;

#namespace zm_daily_challenges;

/*
	Name: __init__sytem__
	Namespace: zm_daily_challenges
	Checksum: 0x3B10DBE6
	Offset: 0x860
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_daily_challenges", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_daily_challenges
	Checksum: 0x624E1FBF
	Offset: 0x8A8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_connect(&on_connect);
	callback::on_spawned(&on_spawned);
	callback::on_challenge_complete(&on_challenge_complete);
	zm_spawner::register_zombie_death_event_callback(&death_check_for_challenge_updates);
}

/*
	Name: __main__
	Namespace: zm_daily_challenges
	Checksum: 0xCD33AB48
	Offset: 0x938
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level thread spent_points_tracking();
	level thread earned_points_tracking();
}

/*
	Name: on_connect
	Namespace: zm_daily_challenges
	Checksum: 0xDD753B4B
	Offset: 0x978
	Size: 0x96
	Parameters: 0
	Flags: Linked
*/
function on_connect()
{
	self thread round_tracking();
	self thread perk_purchase_tracking();
	self thread perk_drink_tracking();
	self.a_daily_challenges = [];
	self.a_daily_challenges[0] = 0;
	self.a_daily_challenges[1] = 0;
	self.a_daily_challenges[2] = 0;
	self.a_daily_challenges[3] = 0;
}

/*
	Name: on_spawned
	Namespace: zm_daily_challenges
	Checksum: 0x52A51F75
	Offset: 0xA18
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_spawned()
{
	self thread challenge_ingame_time_tracking();
}

/*
	Name: round_tracking
	Namespace: zm_daily_challenges
	Checksum: 0x87879AF9
	Offset: 0xA40
	Size: 0x1BA
	Parameters: 0
	Flags: Linked
*/
function round_tracking()
{
	self endon(#"disconnect");
	while(true)
	{
		level waittill(#"end_of_round");
		self.a_daily_challenges[3]++;
		switch(self.a_daily_challenges[3])
		{
			case 10:
			{
				self zm_stats::increment_challenge_stat("ZM_DAILY_ROUND_10");
				/#
					debug_print("");
				#/
				break;
			}
			case 15:
			{
				self zm_stats::increment_challenge_stat("ZM_DAILY_ROUND_15");
				/#
					debug_print("");
				#/
				break;
			}
			case 20:
			{
				self zm_stats::increment_challenge_stat("ZM_DAILY_ROUND_20");
				/#
					debug_print("");
				#/
				break;
			}
			case 25:
			{
				self zm_stats::increment_challenge_stat("ZM_DAILY_ROUND_25");
				/#
					debug_print("");
				#/
				break;
			}
			case 30:
			{
				self zm_stats::increment_challenge_stat("ZM_DAILY_ROUND_30");
				/#
					debug_print("");
				#/
				break;
			}
		}
	}
}

/*
	Name: death_check_for_challenge_updates
	Namespace: zm_daily_challenges
	Checksum: 0x76520194
	Offset: 0xC08
	Size: 0x8E4
	Parameters: 1
	Flags: Linked
*/
function death_check_for_challenge_updates(e_attacker)
{
	if(!isdefined(e_attacker))
	{
		return;
	}
	if(isdefined(e_attacker._trap_type))
	{
		if(isdefined(e_attacker.activated_by_player))
		{
			e_attacker.activated_by_player zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_TRAPS");
			/#
				debug_print("");
			#/
		}
	}
	if(!isplayer(e_attacker))
	{
		return;
	}
	if(isvehicle(self))
	{
		str_damagemod = self.str_damagemod;
		w_damage = self.w_damage;
	}
	else
	{
		str_damagemod = self.damagemod;
		w_damage = self.damageweapon;
	}
	if(w_damage.isdualwield)
	{
		w_damage = w_damage.dualwieldweapon;
	}
	w_damage = zm_weapons::get_nonalternate_weapon(w_damage);
	if(zm_utility::is_headshot(w_damage, self.damagelocation, str_damagemod))
	{
		e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_HEADSHOTS");
		/#
			debug_print("");
		#/
		e_attacker.a_daily_challenges[0]++;
		if(e_attacker.a_daily_challenges[0] == 20)
		{
			e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_HEADSHOTS_IN_ROW");
			/#
				debug_print("");
			#/
		}
		if(getdvarint("ui_enablePromoTracking", 0) && sessionmodeisonlinegame())
		{
			util::function_522d8c7d(1);
		}
	}
	else
	{
		e_attacker.a_daily_challenges[0] = 0;
	}
	if(str_damagemod == "MOD_MELEE")
	{
		e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_MELEE");
		/#
			debug_print("");
		#/
	}
	if(isdefined(level.zombie_vars[e_attacker.team]) && (isdefined(level.zombie_vars[e_attacker.team]["zombie_insta_kill"]) && level.zombie_vars[e_attacker.team]["zombie_insta_kill"]))
	{
		e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_INSTAKILL");
		/#
			debug_print("");
		#/
		return;
	}
	if(zm_weapons::is_weapon_upgraded(w_damage))
	{
		e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_PACKED");
		/#
			debug_print("");
		#/
		if(level.zombie_weapons[level.start_weapon].upgrade === w_damage)
		{
			e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_PACKED_STARTING_PISTOL");
			/#
				debug_print("");
			#/
		}
		switch(w_damage.weapclass)
		{
			case "mg":
			{
				e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_PACKED_MG");
				/#
					debug_print("");
				#/
				break;
			}
			case "pistol":
			{
				e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_PACKED_PISTOL");
				/#
					debug_print("");
				#/
				break;
			}
			case "smg":
			{
				e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_PACKED_SMG");
				/#
					debug_print("");
				#/
				break;
			}
			case "spread":
			{
				e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_PACKED_SHOTGUN");
				/#
					debug_print("");
				#/
				break;
			}
			case "rifle":
			{
				if(w_damage.issniperweapon)
				{
					e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_PACKED_SNIPER");
					/#
						debug_print("");
					#/
				}
				else
				{
					e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_PACKED_RIFLE");
					/#
						debug_print("");
					#/
				}
				break;
			}
		}
	}
	switch(w_damage.weapclass)
	{
		case "mg":
		{
			e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_MG");
			/#
				debug_print("");
			#/
			break;
		}
		case "pistol":
		{
			e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_PISTOL");
			/#
				debug_print("");
			#/
			break;
		}
		case "rifle":
		{
			if(w_damage.issniperweapon)
			{
				e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_SNIPER");
				/#
					debug_print("");
				#/
			}
			else
			{
				e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_RIFLE");
				/#
					debug_print("");
				#/
			}
			break;
		}
		case "smg":
		{
			e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_SMG");
			/#
				debug_print("");
			#/
			break;
		}
		case "spread":
		{
			e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_SHOTGUN");
			/#
				debug_print("");
			#/
			break;
		}
	}
	switch(str_damagemod)
	{
		case "MOD_EXPLOSIVE":
		case "MOD_GRENADE":
		case "MOD_GRENADE_SPLASH":
		case "MOD_PROJECTILE":
		case "MOD_PROJECTILE_SPLASH":
		{
			e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_EXPLOSIVE");
			/#
				debug_print("");
			#/
			break;
		}
	}
	if(w_damage == getweapon("bowie_knife"))
	{
		e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_BOWIE");
		/#
			debug_print("");
		#/
	}
	if(w_damage == getweapon("bouncingbetty"))
	{
		e_attacker zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_BOUNCING_BETTY");
		/#
			debug_print("");
		#/
	}
}

/*
	Name: spent_points_tracking
	Namespace: zm_daily_challenges
	Checksum: 0xD9B5C95C
	Offset: 0x14F8
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function spent_points_tracking()
{
	level endon(#"end_game");
	while(true)
	{
		level waittill(#"spent_points", player, n_points);
		player.a_daily_challenges[1] = player.a_daily_challenges[1] + n_points;
		player zm_stats::increment_challenge_stat("ZM_DAILY_SPEND_25K", n_points);
		player zm_stats::increment_challenge_stat("ZM_DAILY_SPEND_50K", n_points);
		/#
			debug_print("");
		#/
	}
}

/*
	Name: earned_points_tracking
	Namespace: zm_daily_challenges
	Checksum: 0x826C28CD
	Offset: 0x15D0
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function earned_points_tracking()
{
	level endon(#"end_game");
	while(true)
	{
		level waittill(#"earned_points", player, n_points);
		if(level.zombie_vars[player.team]["zombie_point_scalar"] == 2)
		{
			player.a_daily_challenges[2] = player.a_daily_challenges[2] + n_points;
			player zm_stats::increment_challenge_stat("ZM_DAILY_EARN_5K_WITH_2X", n_points);
			/#
				debug_print("");
			#/
		}
	}
}

/*
	Name: challenge_ingame_time_tracking
	Namespace: zm_daily_challenges
	Checksum: 0x1815350A
	Offset: 0x16B0
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function challenge_ingame_time_tracking()
{
	self endon(#"disconnect");
	self notify(#"stop_challenge_ingame_time_tracking");
	self endon(#"stop_challenge_ingame_time_tracking");
	level flag::wait_till("start_zombie_round_logic");
	for(;;)
	{
		wait(1);
		zm_stats::increment_client_stat("ZM_DAILY_CHALLENGE_INGAME_TIME");
	}
}

/*
	Name: increment_windows_repaired
	Namespace: zm_daily_challenges
	Checksum: 0x5FF13B97
	Offset: 0x1720
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function increment_windows_repaired(s_barrier)
{
	if(!isdefined(self.n_dc_barriers_rebuilt))
	{
		self.n_dc_barriers_rebuilt = 0;
	}
	if(!(isdefined(self.b_dc_rebuild_timer_active) && self.b_dc_rebuild_timer_active))
	{
		self thread rebuild_timer();
		self.a_s_barriers_rebuilt = [];
	}
	if(!isinarray(self.a_s_barriers_rebuilt, s_barrier))
	{
		if(!isdefined(self.a_s_barriers_rebuilt))
		{
			self.a_s_barriers_rebuilt = [];
		}
		else if(!isarray(self.a_s_barriers_rebuilt))
		{
			self.a_s_barriers_rebuilt = array(self.a_s_barriers_rebuilt);
		}
		self.a_s_barriers_rebuilt[self.a_s_barriers_rebuilt.size] = s_barrier;
		self.n_dc_barriers_rebuilt++;
	}
}

/*
	Name: rebuild_timer
	Namespace: zm_daily_challenges
	Checksum: 0x9FDADA64
	Offset: 0x1818
	Size: 0x96
	Parameters: 0
	Flags: Linked, Private
*/
function private rebuild_timer()
{
	self endon(#"disconnect");
	self.b_dc_rebuild_timer_active = 1;
	wait(45);
	if(self.n_dc_barriers_rebuilt >= 5)
	{
		self zm_stats::increment_challenge_stat("ZM_DAILY_REBUILD_WINDOWS");
		/#
			debug_print("");
		#/
	}
	self.n_dc_barriers_rebuilt = 0;
	self.a_s_barriers_rebuilt = [];
	self.b_dc_rebuild_timer_active = undefined;
}

/*
	Name: increment_magic_box
	Namespace: zm_daily_challenges
	Checksum: 0x96C9415
	Offset: 0x18B8
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function increment_magic_box()
{
	if(isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"])
	{
		self zm_stats::increment_challenge_stat("ZM_DAILY_PURCHASE_FIRE_SALE_MAGIC_BOX");
		/#
			debug_print("");
		#/
	}
	self zm_stats::increment_challenge_stat("ZM_DAILY_PURCHASE_MAGIC_BOX");
	/#
		debug_print("");
	#/
}

/*
	Name: increment_nuked_zombie
	Namespace: zm_daily_challenges
	Checksum: 0xCEAB98C9
	Offset: 0x1970
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function increment_nuked_zombie()
{
	foreach(player in level.players)
	{
		if(player.sessionstate != "spectator")
		{
			player zm_stats::increment_challenge_stat("ZM_DAILY_KILLS_NUKED");
			/#
				debug_print("");
			#/
		}
	}
}

/*
	Name: perk_purchase_tracking
	Namespace: zm_daily_challenges
	Checksum: 0x32B774BB
	Offset: 0x1A48
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function perk_purchase_tracking()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"perk_purchased", str_perk);
		self zm_stats::increment_challenge_stat("ZM_DAILY_PURCHASE_PERKS");
		/#
			debug_print("");
		#/
	}
}

/*
	Name: perk_drink_tracking
	Namespace: zm_daily_challenges
	Checksum: 0x7BEEB60B
	Offset: 0x1AC0
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function perk_drink_tracking()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"perk_bought");
		self zm_stats::increment_challenge_stat("ZM_DAILY_DRINK_PERKS");
		/#
			debug_print("");
		#/
	}
}

/*
	Name: debug_print
	Namespace: zm_daily_challenges
	Checksum: 0x96518AE5
	Offset: 0x1B30
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function debug_print(str_line)
{
	/#
		println(str_line);
	#/
}

/*
	Name: on_challenge_complete
	Namespace: zm_daily_challenges
	Checksum: 0x46457839
	Offset: 0x1B60
	Size: 0x1FC
	Parameters: 1
	Flags: Linked
*/
function on_challenge_complete(params)
{
	n_challenge_index = params.challengeindex;
	if(is_daily_challenge(n_challenge_index))
	{
		if(isdefined(self))
		{
			uploadstats(self);
		}
		a_challenges = table::load("gamedata/stats/zm/statsmilestones4.csv", "a0");
		str_current_challenge = a_challenges[n_challenge_index]["e4"];
		n_players = level.players.size;
		n_time_played = game["timepassed"] / 1000;
		n_challenge_start_time = self zm_stats::get_global_stat("zm_daily_challenge_start_time");
		n_challenge_time_ingame = self globallogic_score::getpersstat("ZM_DAILY_CHALLENGE_INGAME_TIME");
		n_challenge_games_played = self zm_stats::get_global_stat("zm_daily_challenge_games_played");
		recordcomscoreevent("daily_challenge_complete", "challenge_id", n_challenge_index, "challenge_start_time", n_challenge_start_time, "player_id", self getxuid(), "challenge_time_ingame", n_challenge_time_ingame, "challenge_games_played", n_challenge_games_played, "map_name", level.script, "match_duration", n_time_played, "total_players", n_players, "match_id", getdemofileid());
	}
}

/*
	Name: is_daily_challenge
	Namespace: zm_daily_challenges
	Checksum: 0x7A5650F9
	Offset: 0x1D68
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function is_daily_challenge(n_challenge_index)
{
	n_row = tablelookuprownum("gamedata/stats/zm/statsmilestones4.csv", 0, n_challenge_index);
	if(n_row > -1)
	{
		return true;
	}
	return false;
}

