// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_melee_weapon;

/*
	Name: __init__sytem__
	Namespace: zm_melee_weapon
	Checksum: 0x9A7DE1D3
	Offset: 0x280
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("melee_weapon", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_melee_weapon
	Checksum: 0xEA98A32D
	Offset: 0x2C8
	Size: 0x1C
	Parameters: 0
	Flags: Linked, Private
*/
function private __init__()
{
	if(!isdefined(level._melee_weapons))
	{
		level._melee_weapons = [];
	}
}

/*
	Name: __main__
	Namespace: zm_melee_weapon
	Checksum: 0x99EC1590
	Offset: 0x2F0
	Size: 0x4
	Parameters: 0
	Flags: Linked, Private
*/
function private __main__()
{
}

/*
	Name: init
	Namespace: zm_melee_weapon
	Checksum: 0x69CEAC63
	Offset: 0x300
	Size: 0x404
	Parameters: 9
	Flags: Linked
*/
function init(weapon_name, flourish_weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name, cost, wallbuy_targetname, hint_string, vo_dialog_id, flourish_fn)
{
	weapon = getweapon(weapon_name);
	flourish_weapon = getweapon(flourish_weapon_name);
	ballistic_weapon = level.weaponnone;
	if(isdefined(ballistic_weapon_name))
	{
		ballistic_weapon = getweapon(ballistic_weapon_name);
	}
	ballistic_upgraded_weapon = level.weaponnone;
	if(isdefined(ballistic_upgraded_weapon_name))
	{
		ballistic_upgraded_weapon = getweapon(ballistic_upgraded_weapon_name);
	}
	add_melee_weapon(weapon, flourish_weapon, ballistic_weapon, ballistic_upgraded_weapon, cost, wallbuy_targetname, hint_string, vo_dialog_id, flourish_fn);
	melee_weapon_triggers = getentarray(wallbuy_targetname, "targetname");
	for(i = 0; i < melee_weapon_triggers.size; i++)
	{
		knife_model = getent(melee_weapon_triggers[i].target, "targetname");
		if(isdefined(knife_model))
		{
			knife_model hide();
		}
		melee_weapon_triggers[i] thread melee_weapon_think(weapon, cost, flourish_fn, vo_dialog_id, flourish_weapon, ballistic_weapon, ballistic_upgraded_weapon);
		melee_weapon_triggers[i] sethintstring(hint_string, cost);
		cursor_hint = "HINT_WEAPON";
		cursor_hint_weapon = weapon;
		melee_weapon_triggers[i] setcursorhint(cursor_hint, cursor_hint_weapon);
		melee_weapon_triggers[i] usetriggerrequirelookat();
	}
	melee_weapon_structs = struct::get_array(wallbuy_targetname, "targetname");
	for(i = 0; i < melee_weapon_structs.size; i++)
	{
		prepare_stub(melee_weapon_structs[i].trigger_stub, weapon, flourish_weapon, ballistic_weapon, ballistic_upgraded_weapon, cost, wallbuy_targetname, hint_string, vo_dialog_id, flourish_fn);
	}
	zm_utility::register_melee_weapon_for_level(weapon.name);
	if(!isdefined(level.ballistic_weapon))
	{
		level.ballistic_weapon = [];
	}
	level.ballistic_weapon[weapon] = ballistic_weapon;
	if(!isdefined(level.ballistic_upgraded_weapon))
	{
		level.ballistic_upgraded_weapon = [];
	}
	level.ballistic_upgraded_weapon[weapon] = ballistic_upgraded_weapon;
	/#
		if(!isdefined(level.zombie_weapons[weapon]))
		{
			if(isdefined(level.devgui_add_weapon))
			{
				[[level.devgui_add_weapon]](weapon, "", weapon_name, cost);
			}
		}
	#/
}

/*
	Name: prepare_stub
	Namespace: zm_melee_weapon
	Checksum: 0xDD92B386
	Offset: 0x710
	Size: 0x164
	Parameters: 10
	Flags: Linked
*/
function prepare_stub(stub, weapon, flourish_weapon, ballistic_weapon, ballistic_upgraded_weapon, cost, wallbuy_targetname, hint_string, vo_dialog_id, flourish_fn)
{
	if(isdefined(stub))
	{
		stub.hint_string = hint_string;
		stub.cursor_hint = "HINT_WEAPON";
		stub.cursor_hint_weapon = weapon;
		stub.cost = cost;
		if(!(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled))
		{
			stub.hint_parm1 = cost;
		}
		stub.weapon = weapon;
		stub.vo_dialog_id = vo_dialog_id;
		stub.flourish_weapon = flourish_weapon;
		stub.ballistic_weapon = ballistic_weapon;
		stub.ballistic_upgraded_weapon = ballistic_upgraded_weapon;
		stub.trigger_func = &melee_weapon_think;
		stub.flourish_fn = flourish_fn;
	}
}

/*
	Name: find_melee_weapon
	Namespace: zm_melee_weapon
	Checksum: 0xEDAAEEC5
	Offset: 0x880
	Size: 0x7A
	Parameters: 1
	Flags: Linked
*/
function find_melee_weapon(weapon)
{
	melee_weapon = undefined;
	for(i = 0; i < level._melee_weapons.size; i++)
	{
		if(level._melee_weapons[i].weapon == weapon)
		{
			return level._melee_weapons[i];
		}
	}
	return undefined;
}

/*
	Name: add_stub
	Namespace: zm_melee_weapon
	Checksum: 0xD2855F80
	Offset: 0x908
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function add_stub(stub, weapon)
{
	melee_weapon = find_melee_weapon(weapon);
	if(isdefined(stub) && isdefined(melee_weapon))
	{
		prepare_stub(stub, melee_weapon.weapon, melee_weapon.flourish_weapon, melee_weapon.ballistic_weapon, melee_weapon.ballistic_upgraded_weapon, melee_weapon.cost, melee_weapon.wallbuy_targetname, melee_weapon.hint_string, melee_weapon.vo_dialog_id, melee_weapon.flourish_fn);
	}
}

/*
	Name: add_melee_weapon
	Namespace: zm_melee_weapon
	Checksum: 0xD01BF85E
	Offset: 0x9E0
	Size: 0x14A
	Parameters: 9
	Flags: Linked
*/
function add_melee_weapon(weapon, flourish_weapon, ballistic_weapon, ballistic_upgraded_weapon, cost, wallbuy_targetname, hint_string, vo_dialog_id, flourish_fn)
{
	melee_weapon = spawnstruct();
	melee_weapon.weapon = weapon;
	melee_weapon.flourish_weapon = flourish_weapon;
	melee_weapon.ballistic_weapon = ballistic_weapon;
	melee_weapon.ballistic_upgraded_weapon = ballistic_upgraded_weapon;
	melee_weapon.cost = cost;
	melee_weapon.wallbuy_targetname = wallbuy_targetname;
	melee_weapon.hint_string = hint_string;
	melee_weapon.vo_dialog_id = vo_dialog_id;
	melee_weapon.flourish_fn = flourish_fn;
	if(!isdefined(level._melee_weapons))
	{
		level._melee_weapons = [];
	}
	level._melee_weapons[level._melee_weapons.size] = melee_weapon;
}

/*
	Name: set_fallback_weapon
	Namespace: zm_melee_weapon
	Checksum: 0x552D9317
	Offset: 0xB38
	Size: 0x78
	Parameters: 2
	Flags: Linked
*/
function set_fallback_weapon(weapon_name, fallback_weapon_name)
{
	melee_weapon = find_melee_weapon(getweapon(weapon_name));
	if(isdefined(melee_weapon))
	{
		melee_weapon.fallback_weapon = getweapon(fallback_weapon_name);
	}
}

/*
	Name: determine_fallback_weapon
	Namespace: zm_melee_weapon
	Checksum: 0xB95C5400
	Offset: 0xBB8
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function determine_fallback_weapon()
{
	fallback_weapon = level.weaponzmfists;
	if(isdefined(self zm_utility::get_player_melee_weapon()) && self hasweapon(self zm_utility::get_player_melee_weapon()))
	{
		melee_weapon = find_melee_weapon(self zm_utility::get_player_melee_weapon());
		if(isdefined(melee_weapon) && isdefined(melee_weapon.fallback_weapon))
		{
			return melee_weapon.fallback_weapon;
		}
	}
	return fallback_weapon;
}

/*
	Name: give_fallback_weapon
	Namespace: zm_melee_weapon
	Checksum: 0x8FDCA476
	Offset: 0xC78
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function give_fallback_weapon(immediate = 0)
{
	fallback_weapon = self determine_fallback_weapon();
	had_weapon = self hasweapon(fallback_weapon);
	self giveweapon(fallback_weapon);
	if(immediate && had_weapon)
	{
		self switchtoweaponimmediate(fallback_weapon);
	}
	else
	{
		self switchtoweapon(fallback_weapon);
	}
}

/*
	Name: take_fallback_weapon
	Namespace: zm_melee_weapon
	Checksum: 0x3D84E3C
	Offset: 0xD50
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function take_fallback_weapon()
{
	fallback_weapon = self determine_fallback_weapon();
	had_weapon = self hasweapon(fallback_weapon);
	self zm_weapons::weapon_take(fallback_weapon);
	return had_weapon;
}

/*
	Name: player_can_see_weapon_prompt
	Namespace: zm_melee_weapon
	Checksum: 0xBBD14C45
	Offset: 0xDC8
	Size: 0x66
	Parameters: 0
	Flags: Linked
*/
function player_can_see_weapon_prompt()
{
	if(isdefined(level._allow_melee_weapon_switching) && level._allow_melee_weapon_switching)
	{
		return true;
	}
	if(isdefined(self zm_utility::get_player_melee_weapon()) && self hasweapon(self zm_utility::get_player_melee_weapon()))
	{
		return false;
	}
	return true;
}

/*
	Name: spectator_respawn_all
	Namespace: zm_melee_weapon
	Checksum: 0x7106C360
	Offset: 0xE38
	Size: 0x76
	Parameters: 0
	Flags: Linked
*/
function spectator_respawn_all()
{
	for(i = 0; i < level._melee_weapons.size; i++)
	{
		self spectator_respawn(level._melee_weapons[i].wallbuy_targetname, level._melee_weapons[i].weapon);
	}
}

/*
	Name: spectator_respawn
	Namespace: zm_melee_weapon
	Checksum: 0x7A5A2924
	Offset: 0xEB8
	Size: 0x128
	Parameters: 2
	Flags: Linked
*/
function spectator_respawn(wallbuy_targetname, weapon)
{
	melee_triggers = getentarray(wallbuy_targetname, "targetname");
	players = getplayers();
	for(i = 0; i < melee_triggers.size; i++)
	{
		melee_triggers[i] setvisibletoall();
		if(!(isdefined(level._allow_melee_weapon_switching) && level._allow_melee_weapon_switching))
		{
			for(j = 0; j < players.size; j++)
			{
				if(!players[j] player_can_see_weapon_prompt())
				{
					melee_triggers[i] setinvisibletoplayer(players[j]);
				}
			}
		}
	}
}

/*
	Name: trigger_hide_all
	Namespace: zm_melee_weapon
	Checksum: 0x34B95186
	Offset: 0xFE8
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function trigger_hide_all()
{
	for(i = 0; i < level._melee_weapons.size; i++)
	{
		self trigger_hide(level._melee_weapons[i].wallbuy_targetname);
	}
}

/*
	Name: trigger_hide
	Namespace: zm_melee_weapon
	Checksum: 0xBE4F1451
	Offset: 0x1050
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function trigger_hide(wallbuy_targetname)
{
	melee_triggers = getentarray(wallbuy_targetname, "targetname");
	for(i = 0; i < melee_triggers.size; i++)
	{
		melee_triggers[i] setinvisibletoplayer(self);
	}
}

/*
	Name: has_any_ballistic_knife
	Namespace: zm_melee_weapon
	Checksum: 0xED60EBE7
	Offset: 0x10D8
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function has_any_ballistic_knife()
{
	primaryweapons = self getweaponslistprimaries();
	for(i = 0; i < primaryweapons.size; i++)
	{
		if(primaryweapons[i].isballisticknife)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: has_upgraded_ballistic_knife
	Namespace: zm_melee_weapon
	Checksum: 0x9C70B984
	Offset: 0x1150
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function has_upgraded_ballistic_knife()
{
	primaryweapons = self getweaponslistprimaries();
	for(i = 0; i < primaryweapons.size; i++)
	{
		if(primaryweapons[i].isballisticknife && zm_weapons::is_weapon_upgraded(primaryweapons[i]))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: give_ballistic_knife
	Namespace: zm_melee_weapon
	Checksum: 0x83E1B7B9
	Offset: 0x11E8
	Size: 0xBE
	Parameters: 2
	Flags: Linked
*/
function give_ballistic_knife(weapon, upgraded)
{
	current_melee_weapon = self zm_utility::get_player_melee_weapon();
	if(isdefined(current_melee_weapon))
	{
		if(upgraded && isdefined(level.ballistic_upgraded_weapon) && isdefined(level.ballistic_upgraded_weapon[current_melee_weapon]))
		{
			weapon = level.ballistic_upgraded_weapon[current_melee_weapon];
		}
		if(!upgraded && isdefined(level.ballistic_weapon) && isdefined(level.ballistic_weapon[current_melee_weapon]))
		{
			weapon = level.ballistic_weapon[current_melee_weapon];
		}
	}
	return weapon;
}

/*
	Name: change_melee_weapon
	Namespace: zm_melee_weapon
	Checksum: 0xB5A06E8B
	Offset: 0x12B0
	Size: 0x278
	Parameters: 2
	Flags: Linked
*/
function change_melee_weapon(weapon, current_weapon)
{
	had_fallback_weapon = self take_fallback_weapon();
	current_melee_weapon = self zm_utility::get_player_melee_weapon();
	if(current_melee_weapon != level.weaponnone && current_melee_weapon != weapon)
	{
		self takeweapon(current_melee_weapon);
	}
	self zm_utility::set_player_melee_weapon(weapon);
	had_ballistic = 0;
	had_ballistic_upgraded = 0;
	ballistic_was_primary = 0;
	primaryweapons = self getweaponslistprimaries();
	for(i = 0; i < primaryweapons.size; i++)
	{
		primary_weapon = primaryweapons[i];
		if(primary_weapon.isballisticknife)
		{
			had_ballistic = 1;
			if(primary_weapon == current_weapon)
			{
				ballistic_was_primary = 1;
			}
			self notify(#"zmb_lost_knife");
			self takeweapon(primary_weapon);
			if(zm_weapons::is_weapon_upgraded(primary_weapon))
			{
				had_ballistic_upgraded = 1;
			}
		}
	}
	if(had_ballistic)
	{
		if(had_ballistic_upgraded)
		{
			new_ballistic = level.ballistic_upgraded_weapon[weapon];
			if(ballistic_was_primary)
			{
				current_weapon = new_ballistic;
			}
			self zm_weapons::give_build_kit_weapon(new_ballistic);
		}
		else
		{
			new_ballistic = level.ballistic_weapon[weapon];
			if(ballistic_was_primary)
			{
				current_weapon = new_ballistic;
			}
			self giveweapon(new_ballistic, 0);
		}
	}
	if(had_fallback_weapon)
	{
		self give_fallback_weapon();
	}
	return current_weapon;
}

/*
	Name: melee_weapon_think
	Namespace: zm_melee_weapon
	Checksum: 0x5D150929
	Offset: 0x1530
	Size: 0x5E8
	Parameters: 7
	Flags: Linked
*/
function melee_weapon_think(weapon, cost, flourish_fn, vo_dialog_id, flourish_weapon, ballistic_weapon, ballistic_upgraded_weapon)
{
	self.first_time_triggered = 0;
	if(isdefined(self.stub))
	{
		self endon(#"kill_trigger");
		if(isdefined(self.stub.first_time_triggered))
		{
			self.first_time_triggered = self.stub.first_time_triggered;
		}
		weapon = self.stub.weapon;
		cost = self.stub.cost;
		flourish_fn = self.stub.flourish_fn;
		vo_dialog_id = self.stub.vo_dialog_id;
		flourish_weapon = self.stub.flourish_weapon;
		ballistic_weapon = self.stub.ballistic_weapon;
		ballistic_upgraded_weapon = self.stub.ballistic_upgraded_weapon;
		players = getplayers();
		if(!(isdefined(level._allow_melee_weapon_switching) && level._allow_melee_weapon_switching))
		{
			for(i = 0; i < players.size; i++)
			{
				if(!players[i] player_can_see_weapon_prompt())
				{
					self setinvisibletoplayer(players[i]);
				}
			}
		}
	}
	for(;;)
	{
		self waittill(#"trigger", player);
		if(!zm_utility::is_player_valid(player))
		{
			player thread zm_utility::ignore_triggers(0.5);
			continue;
		}
		if(player zm_utility::in_revive_trigger())
		{
			wait(0.1);
			continue;
		}
		if(player isthrowinggrenade())
		{
			wait(0.1);
			continue;
		}
		if(player.is_drinking > 0)
		{
			wait(0.1);
			continue;
		}
		player_has_weapon = player hasweapon(weapon);
		if(player_has_weapon || player zm_utility::has_powerup_weapon())
		{
			wait(0.1);
			continue;
		}
		if(player isswitchingweapons())
		{
			wait(0.1);
			continue;
		}
		current_weapon = player getcurrentweapon();
		if(zm_utility::is_placeable_mine(current_weapon) || zm_equipment::is_equipment(current_weapon))
		{
			wait(0.1);
			continue;
		}
		if(player laststand::player_is_in_laststand() || (isdefined(player.intermission) && player.intermission))
		{
			wait(0.1);
			continue;
		}
		if(isdefined(player.check_override_melee_wallbuy_purchase))
		{
			if(player [[player.check_override_melee_wallbuy_purchase]](vo_dialog_id, flourish_weapon, weapon, ballistic_weapon, ballistic_upgraded_weapon, flourish_fn, self))
			{
				continue;
			}
		}
		if(!player_has_weapon)
		{
			cost = self.stub.cost;
			if(player zm_pers_upgrades_functions::is_pers_double_points_active())
			{
				cost = int(cost / 2);
			}
			if(player zm_score::can_player_purchase(cost))
			{
				if(self.first_time_triggered == 0)
				{
					model = getent(self.target, "targetname");
					if(isdefined(model))
					{
						model thread melee_weapon_show(player);
					}
					else if(isdefined(self.clientfieldname))
					{
						level clientfield::set(self.clientfieldname, 1);
					}
					self.first_time_triggered = 1;
					if(isdefined(self.stub))
					{
						self.stub.first_time_triggered = 1;
					}
				}
				player zm_score::minus_to_player_score(cost);
				player thread give_melee_weapon(vo_dialog_id, flourish_weapon, weapon, ballistic_weapon, ballistic_upgraded_weapon, flourish_fn, self);
			}
			else
			{
				zm_utility::play_sound_on_ent("no_purchase");
				player zm_audio::create_and_play_dialog("general", "outofmoney", 1);
			}
			continue;
		}
		if(!(isdefined(level._allow_melee_weapon_switching) && level._allow_melee_weapon_switching))
		{
			self setinvisibletoplayer(player);
		}
	}
}

/*
	Name: melee_weapon_show
	Namespace: zm_melee_weapon
	Checksum: 0x23C93ADF
	Offset: 0x1B20
	Size: 0x184
	Parameters: 1
	Flags: Linked
*/
function melee_weapon_show(player)
{
	player_angles = vectortoangles(player.origin - self.origin);
	player_yaw = player_angles[1];
	weapon_yaw = self.angles[1];
	yaw_diff = angleclamp180(player_yaw - weapon_yaw);
	if(yaw_diff > 0)
	{
		yaw = weapon_yaw - 90;
	}
	else
	{
		yaw = weapon_yaw + 90;
	}
	self.og_origin = self.origin;
	self.origin = self.origin + (anglestoforward((0, yaw, 0)) * 8);
	wait(0.05);
	self show();
	zm_utility::play_sound_at_pos("weapon_show", self.origin, self);
	time = 1;
	self moveto(self.og_origin, time);
}

/*
	Name: award_melee_weapon
	Namespace: zm_melee_weapon
	Checksum: 0xC586C5B5
	Offset: 0x1CB0
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function award_melee_weapon(weapon_name)
{
	weapon = getweapon(weapon_name);
	melee_weapon = find_melee_weapon(weapon);
	if(isdefined(melee_weapon))
	{
		self give_melee_weapon(melee_weapon.vo_dialog_id, melee_weapon.flourish_weapon, melee_weapon.weapon, melee_weapon.ballistic_weapon, melee_weapon.ballistic_upgraded_weapon, melee_weapon.flourish_fn, undefined);
	}
}

/*
	Name: give_melee_weapon
	Namespace: zm_melee_weapon
	Checksum: 0xFCE404A5
	Offset: 0x1D78
	Size: 0x184
	Parameters: 7
	Flags: Linked
*/
function give_melee_weapon(vo_dialog_id, flourish_weapon, weapon, ballistic_weapon, ballistic_upgraded_weapon, flourish_fn, trigger)
{
	if(isdefined(flourish_fn))
	{
		self thread [[flourish_fn]]();
	}
	original_weapon = self do_melee_weapon_flourish_begin(flourish_weapon);
	self zm_audio::create_and_play_dialog("weapon_pickup", vo_dialog_id);
	self util::waittill_any("fake_death", "death", "player_downed", "weapon_change_complete");
	self do_melee_weapon_flourish_end(original_weapon, flourish_weapon, weapon, ballistic_weapon, ballistic_upgraded_weapon);
	if(self laststand::player_is_in_laststand() || (isdefined(self.intermission) && self.intermission))
	{
		return;
	}
	if(!(isdefined(level._allow_melee_weapon_switching) && level._allow_melee_weapon_switching))
	{
		if(isdefined(trigger))
		{
			trigger setinvisibletoplayer(self);
		}
		self trigger_hide_all();
	}
}

/*
	Name: do_melee_weapon_flourish_begin
	Namespace: zm_melee_weapon
	Checksum: 0x26783D8A
	Offset: 0x1F08
	Size: 0xA8
	Parameters: 1
	Flags: Linked
*/
function do_melee_weapon_flourish_begin(flourish_weapon)
{
	self zm_utility::increment_is_drinking();
	self zm_utility::disable_player_move_states(1);
	original_weapon = self getcurrentweapon();
	weapon = flourish_weapon;
	self zm_weapons::give_build_kit_weapon(weapon);
	self switchtoweapon(weapon);
	return original_weapon;
}

/*
	Name: do_melee_weapon_flourish_end
	Namespace: zm_melee_weapon
	Checksum: 0x4C0DF75B
	Offset: 0x1FB8
	Size: 0x2BC
	Parameters: 5
	Flags: Linked
*/
function do_melee_weapon_flourish_end(original_weapon, flourish_weapon, weapon, ballistic_weapon, ballistic_upgraded_weapon)
{
	/#
		assert(!original_weapon.isperkbottle);
	#/
	/#
		assert(original_weapon != level.weaponrevivetool);
	#/
	self zm_utility::enable_player_move_states();
	if(self laststand::player_is_in_laststand() || (isdefined(self.intermission) && self.intermission))
	{
		self takeweapon(weapon);
		self.lastactiveweapon = level.weaponnone;
		return;
	}
	self takeweapon(flourish_weapon);
	self zm_weapons::give_build_kit_weapon(weapon);
	original_weapon = change_melee_weapon(weapon, original_weapon);
	if(self hasweapon(level.weaponbasemelee))
	{
		self takeweapon(level.weaponbasemelee);
	}
	if(self zm_utility::is_multiple_drinking())
	{
		self zm_utility::decrement_is_drinking();
		return;
	}
	if(original_weapon == level.weaponbasemelee)
	{
		self switchtoweapon(weapon);
		self zm_utility::decrement_is_drinking();
		return;
	}
	if(original_weapon != level.weaponbasemelee && !zm_utility::is_placeable_mine(original_weapon) && !zm_equipment::is_equipment(original_weapon))
	{
		self zm_weapons::switch_back_primary_weapon(original_weapon);
	}
	else
	{
		self zm_weapons::switch_back_primary_weapon();
	}
	self waittill(#"weapon_change_complete");
	if(!self laststand::player_is_in_laststand() && (!(isdefined(self.intermission) && self.intermission)))
	{
		self zm_utility::decrement_is_drinking();
	}
}

