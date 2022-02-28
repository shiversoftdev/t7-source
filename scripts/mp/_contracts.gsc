// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_loadout;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\drown;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapon_utils;

#namespace contracts;

/*
	Name: __init__sytem__
	Namespace: contracts
	Checksum: 0x3249040E
	Offset: 0x6A0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("contracts", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: contracts
	Checksum: 0x850AAA27
	Offset: 0x6E0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&start_gametype);
	/#
		level thread watch_contract_debug();
	#/
}

/*
	Name: start_gametype
	Namespace: contracts
	Checksum: 0x89AA1D43
	Offset: 0x728
	Size: 0x2A4
	Parameters: 0
	Flags: Linked
*/
function start_gametype()
{
	if(!isdefined(level.challengescallbacks))
	{
		level.challengescallbacks = [];
	}
	util::init_player_contract_events();
	waittillframeend();
	if(can_process_contracts())
	{
		/#
			execdevgui("");
		#/
		challenges::registerchallengescallback("playerKilled", &contract_kills);
		challenges::registerchallengescallback("gameEnd", &contract_game_ended);
		globallogic_score::registercontractwinevent(&contract_win);
		scoreevents::register_hero_ability_kill_event(&on_hero_ability_kill);
		scoreevents::register_hero_ability_multikill_event(&on_hero_ability_multikill);
		scoreevents::register_hero_weapon_multikill_event(&on_hero_weapon_multikill);
		util::register_player_contract_event("score", &on_player_score, 1);
		util::register_player_contract_event("killstreak_score", &on_killstreak_score, 2);
		util::register_player_contract_event("offender_kill", &on_offender_kill);
		util::register_player_contract_event("defender_kill", &on_defender_kill);
		util::register_player_contract_event("headshot", &on_headshot_kill);
		util::register_player_contract_event("killed_hero_ability_enemy", &on_killed_hero_ability_enemy);
		util::register_player_contract_event("killed_hero_weapon_enemy", &on_killed_hero_weapon_enemy);
		util::register_player_contract_event("earned_specialist_ability_medal", &on_hero_ability_medal);
	}
	callback::on_connect(&on_player_connect);
}

/*
	Name: on_killed_hero_ability_enemy
	Namespace: contracts
	Checksum: 0xA83D543F
	Offset: 0x9D8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_killed_hero_ability_enemy()
{
	self add_stat(1014);
}

/*
	Name: on_killed_hero_weapon_enemy
	Namespace: contracts
	Checksum: 0x130E2875
	Offset: 0xA00
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_killed_hero_weapon_enemy()
{
	self add_stat(1014);
}

/*
	Name: on_player_connect
	Namespace: contracts
	Checksum: 0x6ED1C92C
	Offset: 0xA28
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	player = self;
	if(can_process_contracts())
	{
		player setup_player_contracts();
	}
}

/*
	Name: can_process_contracts
	Namespace: contracts
	Checksum: 0x160BBED6
	Offset: 0xA70
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function can_process_contracts()
{
	if(getdvarint("contracts_enabled_mp", 1) == 0)
	{
		return 0;
	}
	return challenges::canprocesschallenges();
}

/*
	Name: setup_player_contracts
	Namespace: contracts
	Checksum: 0xB6C88943
	Offset: 0xAC0
	Size: 0x2B2
	Parameters: 0
	Flags: Linked
*/
function setup_player_contracts()
{
	player = self;
	player.pers["contracts"] = [];
	if(player util::is_bot())
	{
		return;
	}
	for(slot = 0; slot < 10; slot++)
	{
		if(get_contract_stat(slot, "active") && !get_contract_stat(slot, "award_given"))
		{
			contract_index = get_contract_stat(slot, "index");
			player.pers["contracts"][contract_index] = spawnstruct();
			player.pers["contracts"][contract_index].slot = slot;
			table_row = tablelookuprownum("gamedata/tables/mp/mp_contractTable.csv", 0, contract_index);
			player.pers["contracts"][contract_index].table_row = table_row;
			player.pers["contracts"][contract_index].target_value = int(tablelookupcolumnforrow("gamedata/tables/mp/mp_contractTable.csv", table_row, 2));
			player.pers["contracts"][contract_index].calling_card_stat = tablelookupcolumnforrow("gamedata/tables/mp/mp_contractTable.csv", table_row, 7);
			player.pers["contracts"][contract_index].weapon_camo_stat = tablelookupcolumnforrow("gamedata/tables/mp/mp_contractTable.csv", table_row, 8);
			player.pers["contracts"][contract_index].absolute_stat_path = tablelookupcolumnforrow("gamedata/tables/mp/mp_contractTable.csv", table_row, 9);
		}
	}
}

/*
	Name: watch_contract_debug
	Namespace: contracts
	Checksum: 0x7858D105
	Offset: 0xD80
	Size: 0x658
	Parameters: 0
	Flags: Linked
*/
function watch_contract_debug()
{
	/#
		level notify(#"watch_contract_debug_singleton");
		level endon(#"watch_contract_debug_singleton");
		level endon(#"game_ended");
		while(true)
		{
			if(getdvarint("") > 0)
			{
				if(isdefined(level.players))
				{
					new_index = getdvarint("", 0);
					foreach(player in level.players)
					{
						if(!isdefined(player))
						{
							continue;
						}
						if(player util::is_bot())
						{
							continue;
						}
						for(slot = 0; slot < 10; slot++)
						{
							player set_contract_stat(slot, "", 0);
						}
						iprintln("" + player.name);
						player setup_player_contracts();
					}
				}
				setdvar("", 0);
			}
			if(getdvarint("", 0) > 0)
			{
				if(isdefined(level.players))
				{
					new_index = getdvarint("", 0);
					foreach(player in level.players)
					{
						if(!isdefined(player))
						{
							continue;
						}
						if(player util::is_bot())
						{
							continue;
						}
						test_slot = getdvarint("", 9);
						player set_contract_stat(test_slot, "", 1);
						player set_contract_stat(test_slot, "", new_index);
						player set_contract_stat(test_slot, "", 0);
						player set_contract_stat(test_slot, "", 0);
						player setup_player_contracts();
						iprintln(((((("" + test_slot) + "") + new_index) + "") + player.name) + "");
					}
				}
				setdvar("", 0);
			}
			if(getdvarint("", 0) > 0)
			{
				if(isdefined(level.players))
				{
					test_slot = getdvarint("", 9);
					iprintln("");
					foreach(player in level.players)
					{
						if(!isdefined(player))
						{
							continue;
						}
						if(player util::is_bot())
						{
							continue;
						}
						if(test_slot >= 3)
						{
							player set_contract_stat(test_slot, "", 0);
							player setup_player_contracts();
							iprintln((("" + test_slot) + "") + player.name);
							continue;
						}
						iprintln((("" + test_slot) + "") + player.name);
					}
				}
				setdvar("", 0);
			}
			if(getdvarint("", 0) > 0)
			{
				iprintln("");
				setdvar("", 0);
			}
			if(getdvarint("", 0) > 0)
			{
				iprintln("");
				setdvar("", 0);
			}
			wait(0.5);
		}
	#/
}

/*
	Name: is_contract_active
	Namespace: contracts
	Checksum: 0x7F21C2AF
	Offset: 0x13E0
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function is_contract_active(challenge_index)
{
	if(!isplayer(self))
	{
		return false;
	}
	if(!isdefined(self.pers["contracts"]))
	{
		return false;
	}
	if(!isdefined(self.pers["contracts"][challenge_index]))
	{
		return false;
	}
	if(self.pers["contracts"][challenge_index].table_row == -1)
	{
		return false;
	}
	return true;
}

/*
	Name: on_hero_ability_kill
	Namespace: contracts
	Checksum: 0xEFF8A2D9
	Offset: 0x1480
	Size: 0x4A
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
}

/*
	Name: on_hero_ability_medal
	Namespace: contracts
	Checksum: 0xAB2A75B7
	Offset: 0x14D8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function on_hero_ability_medal()
{
	player = self;
	if(!isdefined(player) || !isplayer(player))
	{
		return;
	}
	player add_stat(1013);
	player add_stat(3);
}

/*
	Name: on_hero_ability_multikill
	Namespace: contracts
	Checksum: 0x807D2E7C
	Offset: 0x1550
	Size: 0x4A
	Parameters: 2
	Flags: Linked
*/
function on_hero_ability_multikill(killcount, ability)
{
	player = self;
	if(!isdefined(player) || !isplayer(player))
	{
		return;
	}
}

/*
	Name: on_hero_weapon_multikill
	Namespace: contracts
	Checksum: 0xBD1CCE6
	Offset: 0x15A8
	Size: 0x4A
	Parameters: 2
	Flags: Linked
*/
function on_hero_weapon_multikill(killcount, weapon)
{
	player = self;
	if(!isdefined(player) || !isplayer(player))
	{
		return;
	}
}

/*
	Name: on_player_score
	Namespace: contracts
	Checksum: 0xA516D792
	Offset: 0x1600
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function on_player_score(delta_score)
{
	self add_stat(1009, delta_score);
	self add_stat(5, delta_score);
}

/*
	Name: on_killstreak_score
	Namespace: contracts
	Checksum: 0x3E45FBFE
	Offset: 0x1658
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function on_killstreak_score(delta_score, killstreak_purchased)
{
	if(killstreak_purchased)
	{
		self add_stat(1011, delta_score);
	}
}

/*
	Name: contract_kills
	Namespace: contracts
	Checksum: 0x63EF2311
	Offset: 0x16A0
	Size: 0x474
	Parameters: 1
	Flags: Linked
*/
function contract_kills(data)
{
	victim = data.victim;
	attacker = data.attacker;
	player = attacker;
	weapon = data.weapon;
	time = data.time;
	if(!isdefined(weapon) || weapon == level.weaponnone)
	{
		return;
	}
	if(!isdefined(player) || !isplayer(player))
	{
		return;
	}
	player add_stat(1015);
	player add_stat(4);
	if(weapon.isheroweapon === 1)
	{
		player add_stat(1012);
		player add_stat(7);
		player add_stat(3006);
	}
	iskillstreak = isdefined(data.einflictor) && isdefined(data.einflictor.killstreakid);
	if(!iskillstreak && isdefined(level.iskillstreakweapon))
	{
		iskillstreakweapon = [[level.iskillstreakweapon]](weapon);
	}
	if(iskillstreak || iskillstreakweapon === 1)
	{
		player add_stat(1010);
		player add_stat(8);
	}
	statitemindex = weapon.statindex;
	if(player isitempurchased(statitemindex))
	{
		weaponclass = util::getweaponclass(weapon);
		switch(weaponclass)
		{
			case "weapon_assault":
			{
				player add_stat(1019);
				player add_stat(3001);
				break;
			}
			case "weapon_smg":
			{
				player add_stat(1020);
				player add_stat(3000);
				break;
			}
			case "weapon_sniper":
			{
				player add_stat(1021);
				player add_stat(3004);
				break;
			}
			case "weapon_lmg":
			{
				player add_stat(1022);
				player add_stat(3003);
				break;
			}
			case "weapon_cqb":
			{
				player add_stat(1023);
				player add_stat(3002);
				break;
			}
			case "weapon_pistol":
			{
				player add_stat(1024);
				break;
			}
			case "weapon_knife":
			{
				player add_stat(3005);
				break;
			}
			default:
			{
				break;
			}
		}
		total_unlocked = player gettotalunlockedweaponattachments(weapon);
		if(total_unlocked >= 4)
		{
			player add_stat(1025);
		}
	}
}

/*
	Name: add_stat
	Namespace: contracts
	Checksum: 0x42B9B06F
	Offset: 0x1B20
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function add_stat(contract_index, delta)
{
	if(self is_contract_active(contract_index))
	{
		self add_active_stat(contract_index, delta);
	}
}

/*
	Name: add_active_stat
	Namespace: contracts
	Checksum: 0x2F24C64F
	Offset: 0x1B78
	Size: 0x5FC
	Parameters: 2
	Flags: Linked
*/
function add_active_stat(contract_index, delta = 1)
{
	slot = self.pers["contracts"][contract_index].slot;
	target_value = self.pers["contracts"][contract_index].target_value;
	/#
		if(getdvarint("", 0) > 0)
		{
			delta = delta * getdvarint("", 1);
		}
	#/
	old_progress = get_contract_stat(slot, "progress");
	new_progress = old_progress + delta;
	if(new_progress > target_value)
	{
		new_progress = target_value;
	}
	if(new_progress != old_progress)
	{
		self set_contract_stat(slot, "progress", new_progress);
	}
	just_completed = 0;
	if(old_progress < target_value && target_value <= new_progress)
	{
		just_completed = 1;
		event = &"mp_weekly_challenge_complete";
		display_rewards = 0;
		if(slot == 2)
		{
			event = &"mp_daily_challenge_complete";
			display_rewards = 1;
			self award_loot_xp_due(award_daily_contract());
			self set_contract_stat(2, "award_given", 1);
		}
		else
		{
			if(slot == 0 || slot == 1)
			{
				other_slot = 1;
				if(slot == 1)
				{
					other_slot = 0;
				}
				foreach(c_data in self.pers["contracts"])
				{
					if(c_data.slot == other_slot)
					{
						if(c_data.target_value <= get_contract_stat(other_slot, "progress"))
						{
							display_rewards = 1;
							self award_loot_xp_due(award_weekly_contract());
							self set_contract_stat(0, "award_given", 1);
							self set_contract_stat(1, "award_given", 1);
						}
						break;
					}
				}
			}
			else if(slot == 3)
			{
				event = &"mp_special_contract_complete";
				display_rewards = 1;
				absolute_stat_path = self.pers["contracts"][contract_index].absolute_stat_path;
				if(absolute_stat_path != "")
				{
					set_contract_award_stat_from_path(absolute_stat_path, 1);
				}
				calling_card_stat = self.pers["contracts"][contract_index].calling_card_stat;
				if(calling_card_stat != "")
				{
					set_contract_award_stat("calling_card", calling_card_stat);
				}
				weapon_camo_stat = self.pers["contracts"][contract_index].weapon_camo_stat;
				if(weapon_camo_stat != "")
				{
					set_contract_award_stat("weapon_camo", weapon_camo_stat);
				}
				self set_contract_stat(3, "award_given", 1);
			}
		}
		/#
			test_slot = getdvarint("", 9);
			if(slot == test_slot)
			{
				if(contract_index >= 1000 && contract_index <= 2999)
				{
					event = &"";
				}
				display_rewards = 1;
			}
		#/
		self luinotifyevent(event, 2, contract_index, display_rewards);
	}
	/#
		if(getdvarint("", 0) > 0)
		{
			iprintln((((((("" + slot) + "") + contract_index) + "") + new_progress) + "") + target_value);
		}
	#/
}

/*
	Name: get_contract_stat
	Namespace: contracts
	Checksum: 0xAFAB6906
	Offset: 0x2180
	Size: 0x3A
	Parameters: 2
	Flags: Linked
*/
function get_contract_stat(slot, stat_name)
{
	return self getdstat("contracts", slot, stat_name);
}

/*
	Name: set_contract_stat
	Namespace: contracts
	Checksum: 0xAACED76D
	Offset: 0x21C8
	Size: 0x42
	Parameters: 3
	Flags: Linked
*/
function set_contract_stat(slot, stat_name, stat_value)
{
	return self setdstat("contracts", slot, stat_name, stat_value);
}

/*
	Name: set_contract_award_stat
	Namespace: contracts
	Checksum: 0x3FC6FE7A
	Offset: 0x2218
	Size: 0x4A
	Parameters: 3
	Flags: Linked
*/
function set_contract_award_stat(award_type, stat_name, stat_value = 1)
{
	return self addplayerstat(stat_name, stat_value);
}

/*
	Name: set_contract_award_stat_from_path
	Namespace: contracts
	Checksum: 0xA578165B
	Offset: 0x2270
	Size: 0x36E
	Parameters: 2
	Flags: Linked
*/
function set_contract_award_stat_from_path(stat_path, stat_value)
{
	stat_path_array = strtok(stat_path, " ");
	string_path_1 = "";
	string_path_2 = "";
	string_path_3 = "";
	string_path_4 = "";
	string_path_5 = "";
	switch(stat_path_array.size)
	{
		case 5:
		{
			string_path_5 = stat_path_array[4];
			if(strisnumber(string_path_5))
			{
				string_path_5 = int(string_path_5);
			}
		}
		case 4:
		{
			string_path_4 = stat_path_array[3];
			if(strisnumber(string_path_4))
			{
				string_path_4 = int(string_path_4);
			}
		}
		case 3:
		{
			string_path_3 = stat_path_array[2];
			if(strisnumber(string_path_3))
			{
				string_path_3 = int(string_path_3);
			}
		}
		case 2:
		{
			string_path_2 = stat_path_array[1];
			if(strisnumber(string_path_2))
			{
				string_path_2 = int(string_path_2);
			}
		}
		case 1:
		{
			string_path_1 = stat_path_array[0];
			if(strisnumber(string_path_1))
			{
				string_path_1 = int(string_path_1);
			}
		}
	}
	switch(stat_path_array.size)
	{
		case 1:
		{
			return self setdstat(string_path_1, stat_value);
			break;
		}
		case 2:
		{
			return self setdstat(string_path_1, string_path_2, stat_value);
			break;
		}
		case 3:
		{
			return self setdstat(string_path_1, string_path_2, string_path_3, stat_value);
			break;
		}
		case 4:
		{
			return self setdstat(string_path_1, string_path_2, string_path_3, string_path_4, stat_value);
			break;
		}
		case 5:
		{
			return self setdstat(string_path_1, string_path_2, string_path_3, string_path_4, string_path_5, stat_value);
			break;
		}
		default:
		{
			/#
				assertmsg(("" + stat_path_array.size) + "");
			#/
			break;
		}
	}
}

/*
	Name: award_loot_xp_due
	Namespace: contracts
	Checksum: 0xF17A2E27
	Offset: 0x25E8
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function award_loot_xp_due(amount)
{
	if(!isdefined(self))
	{
		return;
	}
	if(amount <= 0)
	{
		return;
	}
	current_amount = (isdefined(self getdstat("mp_loot_xp_due")) ? self getdstat("mp_loot_xp_due") : 0);
	new_amount = current_amount + amount;
	self setdstat("mp_loot_xp_due", new_amount);
}

/*
	Name: get_hero_weapon_mask
	Namespace: contracts
	Checksum: 0x982BDD84
	Offset: 0x26A0
	Size: 0x14E
	Parameters: 2
	Flags: None
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
	Namespace: contracts
	Checksum: 0x9A4837AF
	Offset: 0x27F8
	Size: 0xE2
	Parameters: 1
	Flags: None
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
	Name: contract_game_ended
	Namespace: contracts
	Checksum: 0x46C035A5
	Offset: 0x28E8
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function contract_game_ended(data)
{
}

/*
	Name: contract_win
	Namespace: contracts
	Checksum: 0xE8179616
	Offset: 0x2900
	Size: 0x2CC
	Parameters: 1
	Flags: Linked
*/
function contract_win(winner)
{
	winner add_stat(1000);
	winner add_stat(1);
	winner add_stat(3007);
	winner add_stat(3008);
	winner add_stat(3009);
	winner add_stat(3010);
	winner add_stat(3011);
	winner add_stat(3012);
	winner add_stat(3013);
	winner add_stat(3014);
	winner add_stat(3015);
	winner add_stat(3016);
	winner add_stat(3017);
	winner add_stat(3018);
	winner add_stat(3019);
	winner add_stat(3020);
	winner add_stat(3021);
	winner add_stat(3022);
	winner add_stat(3023);
	winner add_stat(3024);
	winner add_stat(3025);
	winner add_stat(3026);
	winner add_stat(3027);
	winner add_stat(3028);
	if(util::is_objective_game(level.gametype))
	{
		winner add_stat(2);
	}
	if(isarenamode())
	{
		winner add_stat(1001);
	}
	gametype_win(winner);
}

/*
	Name: gametype_win
	Namespace: contracts
	Checksum: 0x89B99D78
	Offset: 0x2BD8
	Size: 0x1E2
	Parameters: 1
	Flags: Linked
*/
function gametype_win(winner)
{
	switch(level.gametype)
	{
		case "tdm":
		{
			winner add_stat(1002);
			break;
		}
		case "ball":
		{
			winner add_stat(1003);
			break;
		}
		case "escort":
		{
			winner add_stat(1004);
			break;
		}
		case "conf":
		{
			winner add_stat(1005);
			break;
		}
		case "sd":
		{
			winner add_stat(1006);
			break;
		}
		case "koth":
		{
			winner add_stat(1007);
			break;
		}
		case "dom":
		{
			winner add_stat(1008);
			break;
		}
		case "ctf":
		{
			winner add_stat(1026);
			break;
		}
		case "dem":
		{
			winner add_stat(1027);
			break;
		}
		case "dm":
		{
			winner add_stat(1028);
			break;
		}
		case "clean":
		{
			winner add_stat(1029);
			break;
		}
		default:
		{
			break;
		}
	}
}

/*
	Name: on_offender_kill
	Namespace: contracts
	Checksum: 0x6FF8581E
	Offset: 0x2DC8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function on_offender_kill()
{
	self add_stat(1018);
	self add_stat(6);
}

/*
	Name: on_defender_kill
	Namespace: contracts
	Checksum: 0xEA689751
	Offset: 0x2E08
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function on_defender_kill()
{
	self add_stat(1017);
	self add_stat(6);
}

/*
	Name: on_headshot_kill
	Namespace: contracts
	Checksum: 0xBD3E0955
	Offset: 0x2E48
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function on_headshot_kill()
{
	self add_stat(1016, 1);
}

/*
	Name: award_loot_xp
	Namespace: contracts
	Checksum: 0x3CB0B94F
	Offset: 0x2E78
	Size: 0x238
	Parameters: 0
	Flags: None
*/
function award_loot_xp()
{
	player = self;
	if(!isdefined(player.pers["contracts"]))
	{
		return 0;
	}
	loot_xp = 0;
	daily_slot = 2;
	if(get_contract_stat(daily_slot, "active") && !get_contract_stat(daily_slot, "award_given"))
	{
		if(contract_slot_met(daily_slot))
		{
			loot_xp = loot_xp + player award_daily_contract();
			player set_contract_stat(daily_slot, "award_given", 1);
		}
	}
	weekly_slot_a = 0;
	weekly_slot_b = 1;
	if(get_contract_stat(weekly_slot_a, "active") && !get_contract_stat(weekly_slot_a, "award_given") && get_contract_stat(weekly_slot_b, "active") && !get_contract_stat(weekly_slot_b, "award_given"))
	{
		if(contract_slot_met(weekly_slot_a) && contract_slot_met(weekly_slot_b))
		{
			loot_xp = loot_xp + player award_weekly_contract();
			player set_contract_stat(weekly_slot_a, "award_given", 1);
			player set_contract_stat(weekly_slot_b, "award_given", 1);
		}
	}
	return loot_xp;
}

/*
	Name: contract_slot_met
	Namespace: contracts
	Checksum: 0xBB1C970B
	Offset: 0x30B8
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function contract_slot_met(slot)
{
	player = self;
	contract_index = get_contract_stat(slot, "index");
	if(!isdefined(player.pers["contracts"][contract_index]))
	{
		return 0;
	}
	progress = player get_contract_stat(slot, "progress");
	target_value = player.pers["contracts"][contract_index].target_value;
	return progress >= target_value;
}

/*
	Name: award_daily_contract
	Namespace: contracts
	Checksum: 0x8FA08BB7
	Offset: 0x3198
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function award_daily_contract()
{
	return getdvarint("daily_contract_cryptokey_reward_count", 10) * getdvarint("loot_cryptokeyCost", 100);
}

/*
	Name: award_weekly_contract
	Namespace: contracts
	Checksum: 0xF8853F7C
	Offset: 0x31E0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function award_weekly_contract()
{
	self award_blackjack_contract();
	return getdvarint("weekly_contract_cryptokey_reward_count", 30) * getdvarint("loot_cryptokeyCost", 100);
}

/*
	Name: award_blackjack_contract
	Namespace: contracts
	Checksum: 0x7C0478B8
	Offset: 0x3240
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function award_blackjack_contract()
{
	contract_count = self getdstat("blackjack_contract_count");
	reward_count = getdvarint("weekly_contract_blackjack_contract_reward_count", 1);
	self setdstat("blackjack_contract_count", contract_count + reward_count);
}

