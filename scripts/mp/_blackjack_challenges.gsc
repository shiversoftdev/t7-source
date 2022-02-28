// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_loadout;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\drown;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapon_utils;

#namespace blackjack_challenges;

/*
	Name: __init__sytem__
	Namespace: blackjack_challenges
	Checksum: 0xC2D5BB97
	Offset: 0x4D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("blackjack_challenges", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: blackjack_challenges
	Checksum: 0xF1116ABE
	Offset: 0x518
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&start_gametype);
}

/*
	Name: start_gametype
	Namespace: blackjack_challenges
	Checksum: 0xF65C330A
	Offset: 0x548
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function start_gametype()
{
	if(!isdefined(level.challengescallbacks))
	{
		level.challengescallbacks = [];
	}
	waittillframeend();
	if(challenges::canprocesschallenges())
	{
		challenges::registerchallengescallback("playerKilled", &challenge_kills);
		challenges::registerchallengescallback("roundEnd", &challenge_round_ended);
		challenges::registerchallengescallback("gameEnd", &challenge_game_ended);
		scoreevents::register_hero_ability_kill_event(&on_hero_ability_kill);
	}
	callback::on_connect(&on_player_connect);
}

/*
	Name: on_player_connect
	Namespace: blackjack_challenges
	Checksum: 0x5AF21772
	Offset: 0x640
	Size: 0x19A
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	player = self;
	if(challenges::canprocesschallenges())
	{
		specialistindex = player getspecialistindex();
		isblackjack = specialistindex == 9;
		if(isblackjack)
		{
			player thread track_blackjack_consumable();
			if(!isdefined(self.pers["blackjack_challenge_active"]))
			{
				remaining_time = player consumableget("blackjack", "awarded") - player consumableget("blackjack", "consumed");
				if(remaining_time > 0)
				{
					special_card_earned = player get_challenge_stat("special_card_earned");
					if(!special_card_earned)
					{
						player.pers["blackjack_challenge_active"] = 1;
						player.pers["blackjack_unique_specialist_kills"] = 0;
						player.pers["blackjack_specialist_kills"] = 0;
						player.pers["blackjack_unique_weapon_mask"] = 0;
						player.pers["blackjack_unique_ability_mask"] = 0;
					}
				}
			}
		}
	}
}

/*
	Name: is_challenge_active
	Namespace: blackjack_challenges
	Checksum: 0x2BCD7258
	Offset: 0x7E8
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function is_challenge_active()
{
	return self.pers["blackjack_challenge_active"] === 1;
}

/*
	Name: on_hero_ability_kill
	Namespace: blackjack_challenges
	Checksum: 0xA91FBDB2
	Offset: 0x810
	Size: 0x164
	Parameters: 2
	Flags: Linked
*/
function on_hero_ability_kill(ability, victimability)
{
	player = self;
	if(!isdefined(player) || !isplayer(player))
	{
		return;
	}
	if(!isdefined(player.isroulette) || !player.isroulette)
	{
		return;
	}
	if(player is_challenge_active())
	{
		player.pers["blackjack_specialist_kills"]++;
		currentheroabilitymask = player.pers["blackjack_unique_ability_mask"];
		heroabilitymask = get_hero_ability_mask(ability);
		newheroabilitymask = heroabilitymask | currentheroabilitymask;
		if(newheroabilitymask != currentheroabilitymask)
		{
			player.pers["blackjack_unique_specialist_kills"]++;
			player.pers["blackjack_unique_ability_mask"] = newheroabilitymask;
		}
		player check_blackjack_challenge();
	}
}

/*
	Name: debug_print_already_earned
	Namespace: blackjack_challenges
	Checksum: 0xD8E576B2
	Offset: 0x980
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function debug_print_already_earned()
{
	/#
		if(getdvarint("", 0) == 0)
		{
			return;
		}
		iprintln("");
	#/
}

/*
	Name: debug_print_kill_info
	Namespace: blackjack_challenges
	Checksum: 0x24C67F26
	Offset: 0x9D0
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function debug_print_kill_info()
{
	/#
		if(getdvarint("", 0) == 0)
		{
			return;
		}
		player = self;
		iprintln((("" + player.pers[""]) + "") + player.pers[""]);
	#/
}

/*
	Name: debug_print_earned
	Namespace: blackjack_challenges
	Checksum: 0x16F15520
	Offset: 0xA68
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function debug_print_earned()
{
	/#
		if(getdvarint("", 0) == 0)
		{
			return;
		}
		iprintln("");
	#/
}

/*
	Name: check_blackjack_challenge
	Namespace: blackjack_challenges
	Checksum: 0x21829FF7
	Offset: 0xAB8
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function check_blackjack_challenge()
{
	player = self;
	/#
		debug_print_kill_info();
	#/
	special_card_earned = player get_challenge_stat("special_card_earned");
	if(special_card_earned)
	{
		/#
			debug_print_already_earned();
		#/
		return;
	}
	if(player.pers["blackjack_specialist_kills"] >= 4 && player.pers["blackjack_unique_specialist_kills"] >= 2)
	{
		player set_challenge_stat("special_card_earned", 1);
		player addplayerstat("blackjack_challenge", 1);
		/#
			debug_print_earned();
		#/
	}
}

/*
	Name: challenge_kills
	Namespace: blackjack_challenges
	Checksum: 0x9AE37CB
	Offset: 0xBD0
	Size: 0x234
	Parameters: 1
	Flags: Linked
*/
function challenge_kills(data)
{
	attackeristhief = data.attackeristhief;
	attackerisroulette = data.attackerisroulette;
	attackeristhieforroulette = attackeristhief || attackerisroulette;
	if(!attackeristhieforroulette)
	{
		return;
	}
	victim = data.victim;
	attacker = data.attacker;
	player = attacker;
	weapon = data.weapon;
	if(!isdefined(weapon) || weapon == level.weaponnone)
	{
		return;
	}
	if(!isdefined(player) || !isplayer(player))
	{
		return;
	}
	if(attackeristhief)
	{
		if(weapon.isheroweapon === 1)
		{
			if(player is_challenge_active())
			{
				player.pers["blackjack_specialist_kills"]++;
				currentheroweaponmask = player.pers["blackjack_unique_weapon_mask"];
				heroweaponmask = get_hero_weapon_mask(attacker, weapon);
				newheroweaponmask = heroweaponmask | currentheroweaponmask;
				if(newheroweaponmask != currentheroweaponmask)
				{
					player.pers["blackjack_unique_specialist_kills"] = player.pers["blackjack_unique_specialist_kills"] + 1;
					player.pers["blackjack_unique_weapon_mask"] = newheroweaponmask;
				}
				player check_blackjack_challenge();
			}
		}
	}
}

/*
	Name: get_challenge_stat
	Namespace: blackjack_challenges
	Checksum: 0x850211DD
	Offset: 0xE10
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function get_challenge_stat(stat_name)
{
	return self getdstat("tenthspecialistcontract", stat_name);
}

/*
	Name: set_challenge_stat
	Namespace: blackjack_challenges
	Checksum: 0xB8464184
	Offset: 0xE48
	Size: 0x3A
	Parameters: 2
	Flags: Linked
*/
function set_challenge_stat(stat_name, stat_value)
{
	return self setdstat("tenthspecialistcontract", stat_name, stat_value);
}

/*
	Name: get_hero_weapon_mask
	Namespace: blackjack_challenges
	Checksum: 0xD6A558F2
	Offset: 0xE90
	Size: 0x14E
	Parameters: 2
	Flags: Linked
*/
function get_hero_weapon_mask(attacker, weapon)
{
	if(!isdefined(weapon))
	{
		return 0;
	}
	if(isdefined(weapon.isheroweapon) && !weapon.isheroweapon)
	{
		return 0;
	}
	switch(weapon.name)
	{
		case "hero_minigun":
		case "hero_minigun_body3":
		{
			return 1;
			break;
		}
		case "hero_flamethrower":
		{
			return 2;
			break;
		}
		case "hero_lightninggun":
		case "hero_lightninggun_arc":
		{
			return 4;
			break;
		}
		case "hero_chemicalgelgun":
		case "hero_firefly_swarm":
		{
			return 8;
			break;
		}
		case "hero_pineapple_grenade":
		case "hero_pineapplegun":
		{
			return 16;
			break;
		}
		case "hero_armblade":
		{
			return 32;
			break;
		}
		case "hero_bowlauncher":
		case "hero_bowlauncher2":
		case "hero_bowlauncher3":
		case "hero_bowlauncher4":
		{
			return 64;
			break;
		}
		case "hero_gravityspikes":
		{
			return 128;
			break;
		}
		case "hero_annihilator":
		{
			return 256;
			break;
		}
		default:
		{
			return 0;
		}
	}
}

/*
	Name: get_hero_ability_mask
	Namespace: blackjack_challenges
	Checksum: 0x22012578
	Offset: 0xFE8
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function get_hero_ability_mask(ability)
{
	if(!isdefined(ability))
	{
		return 0;
	}
	switch(ability.name)
	{
		case "gadget_clone":
		{
			return 1;
			break;
		}
		case "gadget_heat_wave":
		{
			return 2;
			break;
		}
		case "gadget_flashback":
		{
			return 4;
			break;
		}
		case "gadget_resurrect":
		{
			return 8;
			break;
		}
		case "gadget_armor":
		{
			return 16;
			break;
		}
		case "gadget_camo":
		{
			return 32;
			break;
		}
		case "gadget_vision_pulse":
		{
			return 64;
			break;
		}
		case "gadget_speed_burst":
		{
			return 128;
			break;
		}
		case "gadget_combat_efficiency":
		{
			return 256;
			break;
		}
		default:
		{
			return 0;
		}
	}
}

/*
	Name: challenge_game_ended
	Namespace: blackjack_challenges
	Checksum: 0xDD4CA033
	Offset: 0x10D8
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function challenge_game_ended(data)
{
	if(!isdefined(data))
	{
		return;
	}
	player = data.player;
	if(!isdefined(player))
	{
		return;
	}
	if(!isplayer(player))
	{
		return;
	}
	if(player util::is_bot())
	{
		return;
	}
	if(!player is_challenge_active())
	{
		return;
	}
	player report_consumable();
}

/*
	Name: challenge_round_ended
	Namespace: blackjack_challenges
	Checksum: 0xD4C7E9BD
	Offset: 0x1180
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function challenge_round_ended(data)
{
	if(!isdefined(data))
	{
		return;
	}
	player = data.player;
	if(!isdefined(player))
	{
		return;
	}
	if(!isplayer(player))
	{
		return;
	}
	if(player util::is_bot())
	{
		return;
	}
	if(!player is_challenge_active())
	{
		return;
	}
	player report_consumable();
}

/*
	Name: track_blackjack_consumable
	Namespace: blackjack_challenges
	Checksum: 0x872BF806
	Offset: 0x1228
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function track_blackjack_consumable()
{
	level endon(#"game_ended");
	self notify(#"track_blackjack_consumable_singleton");
	self endon(#"track_blackjack_consumable_singleton");
	self endon(#"disconnect");
	player = self;
	if(!isdefined(player.last_blackjack_consumable_time))
	{
		player.last_blackjack_consumable_time = 0;
	}
	while(isdefined(player))
	{
		random_wait_time = getdvarfloat("mp_blackjack_consumable_wait", 20) + (randomfloatrange(-5, 5));
		wait(random_wait_time);
		player report_consumable();
	}
}

/*
	Name: report_consumable
	Namespace: blackjack_challenges
	Checksum: 0xAECF943D
	Offset: 0x1308
	Size: 0x178
	Parameters: 0
	Flags: Linked
*/
function report_consumable()
{
	player = self;
	if(!isdefined(player))
	{
		return;
	}
	if(!isdefined(player.timeplayed) || !isdefined(player.timeplayed["total"]))
	{
		return;
	}
	current_time_played = player.timeplayed["total"];
	time_to_report = current_time_played - player.last_blackjack_consumable_time;
	if(time_to_report > 0)
	{
		max_time_to_report = player consumableget("blackjack", "awarded") - player consumableget("blackjack", "consumed");
		consumable_increment = int(min(time_to_report, max_time_to_report));
		if(consumable_increment > 0)
		{
			player consumableincrement("blackjack", "consumed", consumable_increment);
		}
	}
	player.last_blackjack_consumable_time = current_time_played;
}

