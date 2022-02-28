// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_quantum_bomb;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#namespace zm_weap_quantum_bomb;

/*
	Name: __init__sytem__
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xDAF2B833
	Offset: 0x718
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_quantum_bomb", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x30E25D27
	Offset: 0x758
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.quantum_bomb_register_result_func = &quantum_bomb_register_result;
	level.quantum_bomb_deregister_result_func = &quantum_bomb_deregister_result;
	level.quantum_bomb_in_playable_area_validation_func = &quantum_bomb_in_playable_area_validation;
	level.w_quantum_bomb = getweapon("quantum_bomb");
	init();
}

/*
	Name: init
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x81E73F90
	Offset: 0x7E0
	Size: 0x2CC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	/#
		level.zombiemode_devgui_quantum_bomb_give = &player_give_quantum_bomb;
	#/
	quantum_bomb_register_result("random_lethal_grenade", &quantum_bomb_lethal_grenade_result, 50);
	quantum_bomb_register_result("random_weapon_starburst", &quantum_bomb_random_weapon_starburst_result, 75);
	quantum_bomb_register_result("pack_or_unpack_current_weapon", &quantum_bomb_pack_or_unpack_current_weapon_result, 10, &quantum_bomb_pack_or_unpack_current_weapon_validation);
	quantum_bomb_register_result("auto_revive", &quantum_bomb_auto_revive_result, 60, &quantum_bomb_auto_revive_validation);
	quantum_bomb_register_result("player_teleport", &quantum_bomb_player_teleport_result, 20);
	quantum_bomb_register_result("zombie_speed_buff", &quantum_bomb_zombie_speed_buff_result, 2);
	quantum_bomb_register_result("zombie_add_to_total", &quantum_bomb_zombie_add_to_total_result, 70, &quantum_bomb_zombie_add_to_total_validation);
	level._effect["zombie_fling_result"] = "dlc5/moon/fx_moon_qbomb_explo_distort";
	quantum_bomb_register_result("zombie_fling", &quantum_bomb_zombie_fling_result);
	level._effect["quantum_bomb_viewmodel_twist"] = "dlc5/zmb_weapon/fx_twist";
	level._effect["quantum_bomb_viewmodel_press"] = "dlc5/zmb_weapon/fx_press";
	level._effect["quantum_bomb_area_effect"] = "dlc5/zmb_weapon/fx_area_effect";
	level._effect["quantum_bomb_player_effect"] = "dlc5/zmb_weapon/fx_player_effect";
	level._effect["quantum_bomb_player_position_effect"] = "dlc5/zmb_weapon/fx_player_position_effect";
	level._effect["quantum_bomb_mystery_effect"] = "dlc5/zmb_weapon/fx_mystery_effect";
	level.quantum_bomb_play_area_effect_func = &quantum_bomb_play_area_effect;
	level.quantum_bomb_play_player_effect_func = &quantum_bomb_play_player_effect;
	level.quantum_bomb_play_player_effect_at_position_func = &quantum_bomb_play_player_effect_at_position;
	level.quantum_bomb_play_mystery_effect_func = &quantum_bomb_play_mystery_effect;
}

/*
	Name: quantum_bomb_debug_print_ln
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x8ED76024
	Offset: 0xAB8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_debug_print_ln(msg)
{
	/#
		if(!getdvarint(""))
		{
			return;
		}
		iprintlnbold(msg);
	#/
}

/*
	Name: quantum_bomb_debug_print_bold
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xF8F23A85
	Offset: 0xB08
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_debug_print_bold(msg)
{
	/#
		if(!getdvarint(""))
		{
			return;
		}
		iprintlnbold(msg);
	#/
}

/*
	Name: quantum_bomb_debug_print_3d
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x35DD8A68
	Offset: 0xB58
	Size: 0x8C
	Parameters: 2
	Flags: None
*/
function quantum_bomb_debug_print_3d(msg, color)
{
	/#
		if(!getdvarint(""))
		{
			return;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		print3d(self.origin + vectorscale((0, 0, 1), 60), msg, color, 1, 1, 40);
	#/
}

/*
	Name: quantum_bomb_register_result
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xEC7E7C30
	Offset: 0xBF0
	Size: 0x15A
	Parameters: 4
	Flags: Linked
*/
function quantum_bomb_register_result(name, result_func, chance, validation_func)
{
	if(!isdefined(level.quantum_bomb_results))
	{
		level.quantum_bomb_results = [];
	}
	if(isdefined(level.quantum_bomb_results[name]))
	{
		quantum_bomb_debug_print_ln(("quantum_bomb_register_result(): '" + name) + "' is already registered as a quantum bomb result.\n");
		return;
	}
	result = spawnstruct();
	result.name = name;
	result.result_func = result_func;
	if(!isdefined(chance))
	{
		result.chance = 100;
	}
	else
	{
		result.chance = math::clamp(chance, 1, 100);
	}
	if(!isdefined(validation_func))
	{
		result.validation_func = &quantum_bomb_default_validation;
	}
	else
	{
		result.validation_func = validation_func;
	}
	level.quantum_bomb_results[name] = result;
}

/*
	Name: quantum_bomb_deregister_result
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x2801F3B5
	Offset: 0xD58
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_deregister_result(name)
{
	if(!isdefined(level.quantum_bomb_results))
	{
		level.quantum_bomb_results = [];
	}
	if(!isdefined(level.quantum_bomb_results[name]))
	{
		quantum_bomb_debug_print_ln(("quantum_bomb_deregister_result(): '" + name) + "' is not registered as a quantum bomb result.\n");
		return;
	}
	level.quantum_bomb_results[name] = undefined;
}

/*
	Name: quantum_bomb_play_area_effect
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x8CF37F30
	Offset: 0xDD0
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_play_area_effect(position)
{
	playfx(level._effect["quantum_bomb_area_effect"], position);
}

/*
	Name: quantum_bomb_play_player_effect
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x55443B79
	Offset: 0xE10
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function quantum_bomb_play_player_effect()
{
	playfxontag(level._effect["quantum_bomb_player_effect"], self, "tag_origin");
}

/*
	Name: quantum_bomb_play_player_effect_at_position
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x1ED6FF0D
	Offset: 0xE50
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_play_player_effect_at_position(position)
{
	playfx(level._effect["quantum_bomb_player_position_effect"], position);
}

/*
	Name: quantum_bomb_play_mystery_effect
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x2CD50A4B
	Offset: 0xE90
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_play_mystery_effect(position)
{
	playfx(level._effect["quantum_bomb_mystery_effect"], position);
}

/*
	Name: quantum_bomb_clear_cached_data
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xB9063A63
	Offset: 0xED0
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function quantum_bomb_clear_cached_data()
{
	level.quantum_bomb_cached_in_playable_area = undefined;
	level.quantum_bomb_cached_closest_zombies = undefined;
}

/*
	Name: quantum_bomb_select_result
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xDF9BCDC4
	Offset: 0xEF0
	Size: 0x198
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_select_result(position)
{
	quantum_bomb_clear_cached_data();
	/#
		result_name = getdvarstring("");
		if(result_name != "" && isdefined(level.quantum_bomb_results[result_name]))
		{
			return level.quantum_bomb_results[result_name];
		}
	#/
	eligible_results = [];
	chance = randomint(100);
	keys = getarraykeys(level.quantum_bomb_results);
	for(i = 0; i < keys.size; i++)
	{
		result = level.quantum_bomb_results[keys[i]];
		if(result.chance > chance && self [[result.validation_func]](position))
		{
			eligible_results[eligible_results.size] = result.name;
		}
	}
	return level.quantum_bomb_results[eligible_results[randomint(eligible_results.size)]];
}

/*
	Name: player_give_quantum_bomb
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xD32AA7CA
	Offset: 0x1090
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function player_give_quantum_bomb()
{
	self giveweapon(level.w_quantum_bomb);
	self zm_utility::set_player_tactical_grenade(level.w_quantum_bomb);
	self thread player_handle_quantum_bomb();
}

/*
	Name: player_handle_quantum_bomb
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x126E7C45
	Offset: 0x10F8
	Size: 0x158
	Parameters: 0
	Flags: Linked
*/
function player_handle_quantum_bomb()
{
	self notify(#"starting_quantum_bomb");
	self endon(#"disconnect");
	self endon(#"starting_quantum_bomb");
	level endon(#"end_game");
	while(true)
	{
		grenade = self get_thrown_quantum_bomb();
		if(isdefined(grenade))
		{
			if(self laststand::player_is_in_laststand())
			{
				grenade delete();
				continue;
			}
			grenade waittill(#"explode", position);
			playsoundatposition("wpn_quantum_exp", position);
			result = self quantum_bomb_select_result(position);
			self thread [[result.result_func]](position);
			quantum_bomb_debug_print_bold(((("quantum_bomb exploded at " + position) + ", result: '") + result.name) + "'.\n");
		}
		wait(0.05);
	}
}

/*
	Name: quantum_bomb_exists
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x9AAA88E8
	Offset: 0x1258
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function quantum_bomb_exists()
{
	return isdefined(level.zombie_weapons["quantum_bomb"]);
}

/*
	Name: get_thrown_quantum_bomb
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x93D0BF86
	Offset: 0x1278
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function get_thrown_quantum_bomb()
{
	self endon(#"disconnect");
	self endon(#"starting_quantum_bomb");
	while(true)
	{
		self waittill(#"grenade_fire", grenade, weapname);
		if(weapname == level.w_quantum_bomb)
		{
			return grenade;
		}
		wait(0.05);
	}
}

/*
	Name: quantum_bomb_default_validation
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x90E2D0B6
	Offset: 0x12F0
	Size: 0x10
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_default_validation(position)
{
	return true;
}

/*
	Name: quantum_bomb_get_cached_closest_zombies
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x590205C6
	Offset: 0x1308
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_get_cached_closest_zombies(position)
{
	if(!isdefined(level.quantum_bomb_cached_closest_zombies))
	{
		level.quantum_bomb_cached_closest_zombies = util::get_array_of_closest(position, zombie_utility::get_round_enemy_array());
	}
	return level.quantum_bomb_cached_closest_zombies;
}

/*
	Name: quantum_bomb_get_cached_in_playable_area
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x75EED8EE
	Offset: 0x1360
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_get_cached_in_playable_area(position)
{
	if(!isdefined(level.quantum_bomb_cached_in_playable_area))
	{
		level.quantum_bomb_cached_in_playable_area = zm_utility::check_point_in_playable_area(position);
	}
	return level.quantum_bomb_cached_in_playable_area;
}

/*
	Name: quantum_bomb_in_playable_area_validation
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x4F51DF2A
	Offset: 0x13A8
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_in_playable_area_validation(position)
{
	return quantum_bomb_get_cached_in_playable_area(position);
}

/*
	Name: quantum_bomb_lethal_grenade_result
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xAC5A8A34
	Offset: 0x13D8
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_lethal_grenade_result(position)
{
	self thread zm_audio::create_and_play_dialog("kill", "quant_good");
	a_keys = getarraykeys(level.zombie_lethal_grenade_list);
	self magicgrenadetype(level.zombie_lethal_grenade_list[a_keys[randomint(a_keys.size)]], position, (0, 0, 0), 0.35);
}

/*
	Name: function_29e8b3fc
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x210C017D
	Offset: 0x1488
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function function_29e8b3fc(w_weapon)
{
	if(w_weapon == level.weaponnone)
	{
		return true;
	}
	if(w_weapon.type == "projectile")
	{
		if(w_weapon.weapclass == "pistol" || w_weapon.weapclass == "pistol spread")
		{
			return false;
		}
		return true;
	}
	return false;
}

/*
	Name: quantum_bomb_random_weapon_starburst_result
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xE9AC8C50
	Offset: 0x1510
	Size: 0x414
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_random_weapon_starburst_result(position)
{
	self thread zm_audio::create_and_play_dialog("kill", "quant_good");
	/#
		starburst_debug = getdvarint("");
		if(starburst_debug)
		{
			rand = starburst_debug;
		}
	#/
	a_weapons_list = [];
	var_dd341085 = getarraykeys(level.zombie_weapons);
	foreach(var_134a15b0 in var_dd341085)
	{
		if(!var_134a15b0.ismeleeweapon && !var_134a15b0.isgrenadeweapon && !var_134a15b0.islauncher && !function_29e8b3fc(var_134a15b0))
		{
			array::add(a_weapons_list, var_134a15b0, 0);
		}
	}
	weapon = array::random(a_weapons_list);
	var_46d0740e = zm_weapons::get_upgrade_weapon(weapon);
	if(!function_29e8b3fc(var_46d0740e))
	{
		weapon = var_46d0740e;
	}
	/#
		println("" + weapon.name);
	#/
	quantum_bomb_play_player_effect_at_position(position);
	base_pos = position + vectorscale((0, 0, 1), 40);
	start_yaw = vectortoangles(base_pos - self.origin);
	start_yaw = (0, start_yaw[1], 0);
	weapon_model = zm_utility::spawn_weapon_model(weapon, undefined, position, start_yaw);
	weapon_model moveto(base_pos, 1, 0.25, 0.25);
	weapon_model waittill(#"movedone");
	for(i = 0; i < 36; i++)
	{
		yaw = start_yaw + (randomintrange(-3, 3), i * 10, 0);
		weapon_model.angles = yaw;
		flash_pos = weapon_model gettagorigin("tag_flash");
		target_pos = flash_pos + vectorscale(anglestoforward(yaw), 40);
		magicbullet(weapon, flash_pos, target_pos, undefined);
		util::wait_network_frame();
	}
	weapon_model delete();
}

/*
	Name: quantum_bomb_pack_or_unpack_current_weapon_validation
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x1B2C46A3
	Offset: 0x1930
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_pack_or_unpack_current_weapon_validation(position)
{
	if(!quantum_bomb_get_cached_in_playable_area(position))
	{
		return 0;
	}
	pack_triggers = getentarray("specialty_weapupgrade", "script_noteworthy");
	range_squared = 32400;
	for(i = 0; i < pack_triggers.size; i++)
	{
		if(distancesquared(pack_triggers[i].origin, position) < range_squared)
		{
			return 1;
		}
	}
	return !randomint(5);
}

/*
	Name: quantum_bomb_pack_or_unpack_current_weapon_result
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x62A3113D
	Offset: 0x1A20
	Size: 0x38E
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_pack_or_unpack_current_weapon_result(position)
{
	quantum_bomb_play_mystery_effect(position);
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(player.sessionstate == "spectator" || player laststand::player_is_in_laststand())
		{
			continue;
		}
		weapon = player getcurrentweapon();
		if(!weapon.isprimary || !isdefined(level.zombie_weapons[weapon]))
		{
			continue;
		}
		if(zm_weapons::is_weapon_upgraded(weapon))
		{
			if(randomint(5))
			{
				continue;
			}
			ziw_keys = getarraykeys(level.zombie_weapons);
			for(weaponindex = 0; weaponindex < level.zombie_weapons.size; weaponindex++)
			{
				if(isdefined(level.zombie_weapons[ziw_keys[weaponindex]].upgrade_name) && level.zombie_weapons[ziw_keys[weaponindex]].upgrade_name == weapon)
				{
					if(player == self)
					{
						self thread zm_audio::create_and_play_dialog("kill", "quant_bad");
					}
					player thread zm_weapons::weapon_give(ziw_keys[weaponindex]);
					player quantum_bomb_play_player_effect();
					break;
				}
			}
			continue;
		}
		if(zm_weapons::can_upgrade_weapon(weapon))
		{
			if(!randomint(4))
			{
				continue;
			}
			weapon_limit = 2;
			if(player hasperk("specialty_additionalprimaryweapon"))
			{
				weapon_limit = 3;
			}
			primaries = player getweaponslistprimaries();
			if(isdefined(primaries) && primaries.size < weapon_limit)
			{
				player takeweapon(weapon);
			}
			if(player == self)
			{
				player thread zm_audio::create_and_play_dialog("kill", "quant_good");
			}
			player thread zm_weapons::weapon_give(level.zombie_weapons[weapon].upgrade);
			player quantum_bomb_play_player_effect();
		}
	}
}

/*
	Name: quantum_bomb_auto_revive_validation
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xCE50BA47
	Offset: 0x1DB8
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_auto_revive_validation(position)
{
	if(level flag::get("solo_game"))
	{
		return false;
	}
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(player laststand::player_is_in_laststand())
		{
			return true;
		}
	}
	return false;
}

/*
	Name: quantum_bomb_auto_revive_result
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x70D4CF2C
	Offset: 0x1E70
	Size: 0xDE
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_auto_revive_result(position)
{
	quantum_bomb_play_mystery_effect(position);
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(player laststand::player_is_in_laststand() && randomint(3))
		{
			player zm_laststand::auto_revive(self);
			player quantum_bomb_play_player_effect();
		}
	}
}

/*
	Name: quantum_bomb_player_teleport_result
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xE75EF138
	Offset: 0x1F58
	Size: 0x196
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_player_teleport_result(position)
{
	quantum_bomb_play_mystery_effect(position);
	players = getplayers();
	players_to_teleport = [];
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(player.sessionstate == "spectator" || player laststand::player_is_in_laststand())
		{
			continue;
		}
		if(isdefined(level.quantum_bomb_prevent_player_getting_teleported) && player [[level.quantum_bomb_prevent_player_getting_teleported]](position))
		{
			continue;
		}
		players_to_teleport[players_to_teleport.size] = player;
	}
	players_to_teleport = array::randomize(players_to_teleport);
	for(i = 0; i < players_to_teleport.size; i++)
	{
		player = players_to_teleport[i];
		if(i && randomint(5))
		{
			continue;
		}
		level thread quantum_bomb_teleport_player(player);
	}
}

/*
	Name: quantum_bomb_teleport_player
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xA277764B
	Offset: 0x20F8
	Size: 0x194
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_teleport_player(player)
{
	black_hole_teleport_structs = struct::get_array("struct_black_hole_teleport", "targetname");
	chosen_spot = undefined;
	if(isdefined(level._special_blackhole_bomb_structs))
	{
		black_hole_teleport_structs = [[level._special_blackhole_bomb_structs]]();
	}
	player_current_zone = player zm_utility::get_current_zone();
	if(!isdefined(black_hole_teleport_structs) || black_hole_teleport_structs.size == 0 || !isdefined(player_current_zone))
	{
		return;
	}
	black_hole_teleport_structs = array::randomize(black_hole_teleport_structs);
	if(isdefined(level._override_blackhole_destination_logic))
	{
		chosen_spot = [[level._override_blackhole_destination_logic]](black_hole_teleport_structs, player);
	}
	else
	{
		for(i = 0; i < black_hole_teleport_structs.size; i++)
		{
			if(black_hole_teleport_structs[i] zm_zonemgr::entity_in_active_zone() && player_current_zone != black_hole_teleport_structs[i].script_string)
			{
				chosen_spot = black_hole_teleport_structs[i];
				break;
			}
		}
	}
	if(isdefined(chosen_spot))
	{
		player thread quantum_bomb_teleport(chosen_spot);
	}
}

/*
	Name: quantum_bomb_teleport
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x9664512E
	Offset: 0x2298
	Size: 0x284
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_teleport(struct_dest)
{
	self endon(#"death");
	if(!isdefined(struct_dest))
	{
		return;
	}
	prone_offset = vectorscale((0, 0, 1), 49);
	crouch_offset = vectorscale((0, 0, 1), 20);
	stand_offset = (0, 0, 0);
	destination = undefined;
	if(self getstance() == "prone")
	{
		destination = struct_dest.origin + prone_offset;
	}
	else
	{
		if(self getstance() == "crouch")
		{
			destination = struct_dest.origin + crouch_offset;
		}
		else
		{
			destination = struct_dest.origin + stand_offset;
		}
	}
	if(isdefined(level._black_hole_teleport_override))
	{
		level [[level._black_hole_teleport_override]](self);
	}
	quantum_bomb_play_player_effect_at_position(self.origin);
	self freezecontrols(1);
	self disableoffhandweapons();
	self disableweapons();
	self playsoundtoplayer("zmb_gersh_teleporter_go_2d", self);
	self dontinterpolate();
	self setorigin(destination);
	self setplayerangles(struct_dest.angles);
	self enableoffhandweapons();
	self enableweapons();
	self freezecontrols(0);
	self quantum_bomb_play_player_effect();
	self thread quantum_bomb_slightly_delayed_player_response();
}

/*
	Name: quantum_bomb_slightly_delayed_player_response
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x4EF43EAB
	Offset: 0x2528
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function quantum_bomb_slightly_delayed_player_response()
{
	wait(1);
	self zm_audio::create_and_play_dialog("general", "teleport_gersh");
}

/*
	Name: quantum_bomb_zombie_speed_buff_result
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x78128DC
	Offset: 0x2560
	Size: 0x196
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_zombie_speed_buff_result(position)
{
	quantum_bomb_play_mystery_effect(position);
	self thread zm_audio::create_and_play_dialog("kill", "quant_bad");
	zombies = quantum_bomb_get_cached_closest_zombies(position);
	for(i = 0; i < zombies.size; i++)
	{
		zombie = zombies[i];
		if(isdefined(zombie.fastsprintfunc))
		{
			fast_sprint = zombie [[zombie.fastsprintfunc]]();
		}
		else
		{
			if(isdefined(zombie.in_low_gravity) && zombie.in_low_gravity)
			{
				if(zombie.missinglegs)
				{
					fast_sprint = "crawl_low_g_super_sprint";
				}
				else
				{
					fast_sprint = "low_g_super_sprint";
				}
			}
			else if(zombie.missinglegs)
			{
				fast_sprint = "crawl_super_sprint";
			}
		}
		if(zombie.isdog)
		{
			continue;
		}
		zombie zombie_utility::set_zombie_run_cycle("super_sprint");
	}
}

/*
	Name: quantum_bomb_zombie_fling_result
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x9A08EB4
	Offset: 0x2700
	Size: 0x276
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_zombie_fling_result(position)
{
	playfx(level._effect["zombie_fling_result"], position);
	self thread zm_audio::create_and_play_dialog("kill", "quant_good");
	range = 300;
	range_squared = range * range;
	zombies = quantum_bomb_get_cached_closest_zombies(position);
	for(i = 0; i < zombies.size; i++)
	{
		zombie = zombies[i];
		if(!isdefined(zombie) || !isalive(zombie))
		{
			continue;
		}
		test_origin = zombie.origin + vectorscale((0, 0, 1), 40);
		test_origin_squared = distancesquared(position, test_origin);
		if(test_origin_squared > range_squared)
		{
			break;
		}
		dist_mult = (range_squared - test_origin_squared) / range_squared;
		fling_vec = vectornormalize(test_origin - position);
		fling_vec = (fling_vec[0], fling_vec[1], abs(fling_vec[2]));
		fling_vec = vectorscale(fling_vec, 100 + (100 * dist_mult));
		zombie quantum_bomb_fling_zombie(self, fling_vec);
		if(i && !i % 10)
		{
			util::wait_network_frame();
			util::wait_network_frame();
			util::wait_network_frame();
		}
	}
}

/*
	Name: quantum_bomb_fling_zombie
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xAED1575A
	Offset: 0x2980
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function quantum_bomb_fling_zombie(player, fling_vec)
{
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	self dodamage(self.health + 666, player.origin, player, player, 0, "MOD_UNKNOWN", 0, level.w_quantum_bomb);
	if(self.health <= 0)
	{
		self startragdoll();
		self launchragdoll(fling_vec);
	}
}

/*
	Name: quantum_bomb_zombie_add_to_total_validation
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x87932D93
	Offset: 0x2A48
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_zombie_add_to_total_validation(position)
{
	if(level.zombie_total)
	{
		return 0;
	}
	zombies = quantum_bomb_get_cached_closest_zombies(position);
	return zombies.size < level.zombie_ai_limit;
}

/*
	Name: quantum_bomb_zombie_add_to_total_result
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xC3E35D6E
	Offset: 0x2AA0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_zombie_add_to_total_result(position)
{
	quantum_bomb_play_mystery_effect(position);
	self thread zm_audio::create_and_play_dialog("kill", "quant_bad");
	level.zombie_total = level.zombie_total + level.zombie_ai_limit;
}

/*
	Name: function_61f28336
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xE897A9EA
	Offset: 0x2B10
	Size: 0x176
	Parameters: 0
	Flags: None
*/
function function_61f28336()
{
	level.quantum_bomb_results["player_teleport"] = undefined;
	origin = self.origin;
	while(isdefined(self))
	{
		direction = self getplayerangles();
		direction_vec = anglestoforward(direction);
		eye = self geteye();
		scale = 8000;
		direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
		trace = bullettrace(eye, eye + direction_vec, 0, undefined);
		if(isdefined(trace["position"]))
		{
			origin = trace["position"];
		}
		result = self quantum_bomb_select_result(origin);
		self thread [[result.result_func]](origin);
		wait(5);
	}
}

