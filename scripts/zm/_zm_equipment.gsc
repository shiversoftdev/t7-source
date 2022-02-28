// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_equipment;

/*
	Name: __init__sytem__
	Namespace: zm_equipment
	Checksum: 0x59B48D85
	Offset: 0x3B0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_equipment", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_equipment
	Checksum: 0x69A7E10D
	Offset: 0x3F8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.buildable_piece_count = 24;
	level._equipment_disappear_fx = "_t6/maps/zombie/fx_zmb_tranzit_electrap_explo";
	level.placeable_equipment_destroy_fn = [];
	if(!(isdefined(level._no_equipment_activated_clientfield) && level._no_equipment_activated_clientfield))
	{
		clientfield::register("scriptmover", "equipment_activated", 1, 4, "int");
	}
	/#
		level thread function_f30ee99e();
	#/
}

/*
	Name: __main__
	Namespace: zm_equipment
	Checksum: 0xB8D7699D
	Offset: 0x490
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	init_upgrade();
}

/*
	Name: signal_activated
	Namespace: zm_equipment
	Checksum: 0x8A45E980
	Offset: 0x4B0
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function signal_activated(val = 1)
{
	if(isdefined(level._no_equipment_activated_clientfield) && level._no_equipment_activated_clientfield)
	{
		return;
	}
	self endon(#"death");
	self clientfield::set("equipment_activated", val);
	for(i = 0; i < 2; i++)
	{
		util::wait_network_frame();
	}
	self clientfield::set("equipment_activated", 0);
}

/*
	Name: register
	Namespace: zm_equipment
	Checksum: 0xF5DD2E73
	Offset: 0x578
	Size: 0x214
	Parameters: 5
	Flags: Linked
*/
function register(equipment_name, hint, howto_hint, hint_icon, equipmentvo)
{
	equipment = getweapon(equipment_name);
	struct = spawnstruct();
	if(!isdefined(level.zombie_equipment))
	{
		level.zombie_equipment = [];
	}
	struct.equipment = equipment;
	struct.hint = hint;
	struct.howto_hint = howto_hint;
	struct.hint_icon = hint_icon;
	struct.vox = equipmentvo;
	struct.triggers = [];
	struct.models = [];
	struct.notify_strings = spawnstruct();
	struct.notify_strings.activate = equipment.name + "_activate";
	struct.notify_strings.deactivate = equipment.name + "_deactivate";
	struct.notify_strings.taken = equipment.name + "_taken";
	struct.notify_strings.pickup = equipment.name + "_pickup";
	level.zombie_equipment[equipment] = struct;
	/#
		level thread function_de79cac6(equipment);
	#/
}

/*
	Name: register_slot_watcher_override
	Namespace: zm_equipment
	Checksum: 0xC4BE46F9
	Offset: 0x798
	Size: 0x26
	Parameters: 2
	Flags: None
*/
function register_slot_watcher_override(str_equipment, func_slot_watcher_override)
{
	level.a_func_equipment_slot_watcher_override[str_equipment] = func_slot_watcher_override;
}

/*
	Name: is_included
	Namespace: zm_equipment
	Checksum: 0x810281D
	Offset: 0x7C8
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function is_included(equipment)
{
	if(!isdefined(level.zombie_include_equipment))
	{
		return 0;
	}
	if(isstring(equipment))
	{
		equipment = getweapon(equipment);
	}
	return isdefined(level.zombie_include_equipment[equipment.rootweapon]);
}

/*
	Name: include
	Namespace: zm_equipment
	Checksum: 0x3408EE79
	Offset: 0x840
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function include(equipment_name)
{
	if(!isdefined(level.zombie_include_equipment))
	{
		level.zombie_include_equipment = [];
	}
	level.zombie_include_equipment[getweapon(equipment_name)] = 1;
}

/*
	Name: set_ammo_driven
	Namespace: zm_equipment
	Checksum: 0x3A45C4A9
	Offset: 0x890
	Size: 0xC0
	Parameters: 3
	Flags: Linked
*/
function set_ammo_driven(equipment_name, start, refill_max_ammo = 0)
{
	level.zombie_equipment[getweapon(equipment_name)].notake = 1;
	level.zombie_equipment[getweapon(equipment_name)].start_ammo = start;
	level.zombie_equipment[getweapon(equipment_name)].refill_max_ammo = refill_max_ammo;
}

/*
	Name: limit
	Namespace: zm_equipment
	Checksum: 0x9FA324D9
	Offset: 0x958
	Size: 0x94
	Parameters: 2
	Flags: None
*/
function limit(equipment_name, limited)
{
	if(!isdefined(level._limited_equipment))
	{
		level._limited_equipment = [];
	}
	if(limited)
	{
		level._limited_equipment[level._limited_equipment.size] = getweapon(equipment_name);
	}
	else
	{
		arrayremovevalue(level._limited_equipment, getweapon(equipment_name), 0);
	}
}

/*
	Name: init_upgrade
	Namespace: zm_equipment
	Checksum: 0xF1184D38
	Offset: 0x9F8
	Size: 0x186
	Parameters: 0
	Flags: Linked
*/
function init_upgrade()
{
	equipment_spawns = [];
	equipment_spawns = getentarray("zombie_equipment_upgrade", "targetname");
	for(i = 0; i < equipment_spawns.size; i++)
	{
		equipment_spawns[i].equipment = getweapon(equipment_spawns[i].zombie_equipment_upgrade);
		hint_string = get_hint(equipment_spawns[i].equipment);
		equipment_spawns[i] sethintstring(hint_string);
		equipment_spawns[i] setcursorhint("HINT_NOICON");
		equipment_spawns[i] usetriggerrequirelookat();
		equipment_spawns[i] add_to_trigger_list(equipment_spawns[i].equipment);
		equipment_spawns[i] thread equipment_spawn_think();
	}
}

/*
	Name: get_hint
	Namespace: zm_equipment
	Checksum: 0x8E1F0D08
	Offset: 0xB88
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function get_hint(equipment)
{
	/#
		assert(isdefined(level.zombie_equipment[equipment]), equipment.name + "");
	#/
	return level.zombie_equipment[equipment].hint;
}

/*
	Name: get_howto_hint
	Namespace: zm_equipment
	Checksum: 0x940ED5F8
	Offset: 0xBF0
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function get_howto_hint(equipment)
{
	/#
		assert(isdefined(level.zombie_equipment[equipment]), equipment.name + "");
	#/
	return level.zombie_equipment[equipment].howto_hint;
}

/*
	Name: get_icon
	Namespace: zm_equipment
	Checksum: 0x5484AC22
	Offset: 0xC58
	Size: 0x5A
	Parameters: 1
	Flags: None
*/
function get_icon(equipment)
{
	/#
		assert(isdefined(level.zombie_equipment[equipment]), equipment.name + "");
	#/
	return level.zombie_equipment[equipment].hint_icon;
}

/*
	Name: get_notify_strings
	Namespace: zm_equipment
	Checksum: 0x5A59121D
	Offset: 0xCC0
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function get_notify_strings(equipment)
{
	/#
		assert(isdefined(level.zombie_equipment[equipment]), equipment.name + "");
	#/
	return level.zombie_equipment[equipment].notify_strings;
}

/*
	Name: add_to_trigger_list
	Namespace: zm_equipment
	Checksum: 0x59EBEB44
	Offset: 0xD28
	Size: 0xCE
	Parameters: 1
	Flags: Linked
*/
function add_to_trigger_list(equipment)
{
	/#
		assert(isdefined(level.zombie_equipment[equipment]), equipment.name + "");
	#/
	level.zombie_equipment[equipment].triggers[level.zombie_equipment[equipment].triggers.size] = self;
	level.zombie_equipment[equipment].models[level.zombie_equipment[equipment].models.size] = getent(self.target, "targetname");
}

/*
	Name: equipment_spawn_think
	Namespace: zm_equipment
	Checksum: 0xED756491
	Offset: 0xE00
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function equipment_spawn_think()
{
	for(;;)
	{
		self waittill(#"trigger", player);
		if(player zm_utility::in_revive_trigger() || player.is_drinking > 0)
		{
			wait(0.1);
			continue;
		}
		if(!is_limited(self.equipment) || !limited_in_use(self.equipment))
		{
			if(is_limited(self.equipment))
			{
				player setup_limited(self.equipment);
				if(isdefined(level.hacker_tool_positions))
				{
					new_pos = array::random(level.hacker_tool_positions);
					self.origin = new_pos.trigger_org;
					model = getent(self.target, "targetname");
					model.origin = new_pos.model_org;
					model.angles = new_pos.model_ang;
				}
			}
			player give(self.equipment);
			continue;
		}
		wait(0.1);
	}
}

/*
	Name: set_equipment_invisibility_to_player
	Namespace: zm_equipment
	Checksum: 0x1554C7F1
	Offset: 0xFC0
	Size: 0x10E
	Parameters: 2
	Flags: Linked
*/
function set_equipment_invisibility_to_player(equipment, invisible)
{
	triggers = level.zombie_equipment[equipment].triggers;
	for(i = 0; i < triggers.size; i++)
	{
		if(isdefined(triggers[i]))
		{
			triggers[i] setinvisibletoplayer(self, invisible);
		}
	}
	models = level.zombie_equipment[equipment].models;
	for(i = 0; i < models.size; i++)
	{
		if(isdefined(models[i]))
		{
			models[i] setinvisibletoplayer(self, invisible);
		}
	}
}

/*
	Name: take
	Namespace: zm_equipment
	Checksum: 0x28CC6DCF
	Offset: 0x10D8
	Size: 0x2C4
	Parameters: 1
	Flags: Linked
*/
function take(equipment = self get_player_equipment())
{
	if(!isdefined(equipment))
	{
		return;
	}
	if(equipment == level.weaponnone)
	{
		return;
	}
	if(!self has_player_equipment(equipment))
	{
		return;
	}
	current = 0;
	current_weapon = 0;
	if(isdefined(self get_player_equipment()) && equipment == self get_player_equipment())
	{
		current = 1;
	}
	if(equipment == self getcurrentweapon())
	{
		current_weapon = 1;
	}
	/#
		println(((("" + self.name) + "") + equipment.name) + "");
	#/
	notify_strings = get_notify_strings(equipment);
	if(isdefined(self.current_equipment_active[equipment]) && self.current_equipment_active[equipment])
	{
		self.current_equipment_active[equipment] = 0;
		self notify(notify_strings.deactivate);
	}
	self notify(notify_strings.taken);
	self takeweapon(equipment);
	if(!is_limited(equipment) || (is_limited(equipment) && !limited_in_use(equipment)))
	{
		self set_equipment_invisibility_to_player(equipment, 0);
	}
	if(current)
	{
		self set_player_equipment(level.weaponnone);
		self setactionslot(2, "");
	}
	else
	{
		arrayremovevalue(self.deployed_equipment, equipment);
	}
	if(current_weapon)
	{
		self zm_weapons::switch_back_primary_weapon();
	}
}

/*
	Name: give
	Namespace: zm_equipment
	Checksum: 0xAACB9B56
	Offset: 0x13A8
	Size: 0x1FE
	Parameters: 1
	Flags: Linked
*/
function give(equipment)
{
	if(!isdefined(equipment))
	{
		return;
	}
	if(!isdefined(level.zombie_equipment[equipment]))
	{
		return;
	}
	if(self has_player_equipment(equipment))
	{
		return;
	}
	/#
		println(((("" + self.name) + "") + equipment.name) + "");
	#/
	curr_weapon = self getcurrentweapon();
	curr_weapon_was_curr_equipment = self is_player_equipment(curr_weapon);
	self take();
	self set_player_equipment(equipment);
	self giveweapon(equipment);
	self start_ammo(equipment);
	self thread show_hint(equipment);
	self set_equipment_invisibility_to_player(equipment, 1);
	self setactionslot(2, "weapon", equipment);
	self thread slot_watcher(equipment);
	self zm_audio::create_and_play_dialog("weapon_pickup", level.zombie_equipment[equipment].vox);
	self notify(#"player_given", equipment);
}

/*
	Name: buy
	Namespace: zm_equipment
	Checksum: 0xB057E5FC
	Offset: 0x15B0
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function buy(equipment)
{
	if(isstring(equipment))
	{
		equipment = getweapon(equipment);
	}
	/#
		println(((("" + self.name) + "") + equipment.name) + "");
	#/
	if(isdefined(self.current_equipment) && equipment != self.current_equipment && self.current_equipment != level.weaponnone)
	{
		self take(self.current_equipment);
	}
	self notify(#"player_bought", equipment);
	self give(equipment);
	if(equipment.isriotshield && isdefined(self.player_shield_reset_health))
	{
		self [[self.player_shield_reset_health]]();
	}
}

/*
	Name: slot_watcher
	Namespace: zm_equipment
	Checksum: 0x4E3E4753
	Offset: 0x16F0
	Size: 0x1FE
	Parameters: 1
	Flags: Linked
*/
function slot_watcher(equipment)
{
	self notify(#"kill_equipment_slot_watcher");
	self endon(#"kill_equipment_slot_watcher");
	self endon(#"disconnect");
	notify_strings = get_notify_strings(equipment);
	while(true)
	{
		self waittill(#"weapon_change", curr_weapon, prev_weapon);
		if(self.sessionstate != "spectator")
		{
			self.prev_weapon_before_equipment_change = undefined;
			if(isdefined(prev_weapon) && level.weaponnone != prev_weapon)
			{
				prev_weapon_type = prev_weapon.inventorytype;
				if("primary" == prev_weapon_type || "altmode" == prev_weapon_type)
				{
					self.prev_weapon_before_equipment_change = prev_weapon;
				}
			}
			if(!isdefined(level.a_func_equipment_slot_watcher_override))
			{
				level.a_func_equipment_slot_watcher_override = [];
			}
			if(isdefined(level.a_func_equipment_slot_watcher_override[equipment.name]))
			{
				self [[level.a_func_equipment_slot_watcher_override[equipment.name]]](equipment, curr_weapon, prev_weapon, notify_strings);
			}
			else
			{
				if(curr_weapon == equipment && !self.current_equipment_active[equipment])
				{
					self notify(notify_strings.activate);
					self.current_equipment_active[equipment] = 1;
				}
				else if(curr_weapon != equipment && self.current_equipment_active[equipment])
				{
					self notify(notify_strings.deactivate);
					self.current_equipment_active[equipment] = 0;
				}
			}
		}
	}
}

/*
	Name: is_limited
	Namespace: zm_equipment
	Checksum: 0x5C64FE1A
	Offset: 0x18F8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function is_limited(equipment)
{
	if(isdefined(level._limited_equipment))
	{
		for(i = 0; i < level._limited_equipment.size; i++)
		{
			if(level._limited_equipment[i] == equipment)
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: limited_in_use
	Namespace: zm_equipment
	Checksum: 0x80407886
	Offset: 0x1968
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function limited_in_use(equipment)
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		current_equipment = players[i] get_player_equipment();
		if(isdefined(current_equipment) && current_equipment == equipment)
		{
			return true;
		}
	}
	if(isdefined(level.dropped_equipment) && isdefined(level.dropped_equipment[equipment]))
	{
		return true;
	}
	return false;
}

/*
	Name: setup_limited
	Namespace: zm_equipment
	Checksum: 0xBF106B9F
	Offset: 0x1A30
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function setup_limited(equipment)
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] set_equipment_invisibility_to_player(equipment, 1);
	}
	self thread release_limited_on_disconnect(equipment);
	self thread release_limited_on_taken(equipment);
}

/*
	Name: release_limited_on_taken
	Namespace: zm_equipment
	Checksum: 0x6025489A
	Offset: 0x1AE0
	Size: 0xCE
	Parameters: 1
	Flags: Linked
*/
function release_limited_on_taken(equipment)
{
	self endon(#"disconnect");
	notify_strings = get_notify_strings(equipment);
	self util::waittill_either(notify_strings.taken, "spawned_spectator");
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] set_equipment_invisibility_to_player(equipment, 0);
	}
}

/*
	Name: release_limited_on_disconnect
	Namespace: zm_equipment
	Checksum: 0xE822426D
	Offset: 0x1BB8
	Size: 0xDE
	Parameters: 1
	Flags: Linked
*/
function release_limited_on_disconnect(equipment)
{
	notify_strings = get_notify_strings(equipment);
	self endon(notify_strings.taken);
	self waittill(#"disconnect");
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(isalive(players[i]))
		{
			players[i] set_equipment_invisibility_to_player(equipment, 0);
		}
	}
}

/*
	Name: is_active
	Namespace: zm_equipment
	Checksum: 0xA213C068
	Offset: 0x1CA0
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function is_active(equipment)
{
	if(!isdefined(self.current_equipment_active) || !isdefined(self.current_equipment_active[equipment]))
	{
		return 0;
	}
	return self.current_equipment_active[equipment];
}

/*
	Name: init_hint_hudelem
	Namespace: zm_equipment
	Checksum: 0x6208E859
	Offset: 0x1CE8
	Size: 0x88
	Parameters: 6
	Flags: Linked
*/
function init_hint_hudelem(x, y, alignx, aligny, fontscale, alpha)
{
	self.x = x;
	self.y = y;
	self.alignx = alignx;
	self.aligny = aligny;
	self.fontscale = fontscale;
	self.alpha = alpha;
	self.sort = 20;
}

/*
	Name: setup_client_hintelem
	Namespace: zm_equipment
	Checksum: 0x330CCD4E
	Offset: 0x1D78
	Size: 0x184
	Parameters: 2
	Flags: Linked
*/
function setup_client_hintelem(ypos = 220, font_scale = 1.25)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(!isdefined(self.hintelem))
	{
		self.hintelem = newclienthudelem(self);
	}
	if(self issplitscreen())
	{
		if(getdvarint("splitscreen_playerCount") >= 3)
		{
			self.hintelem init_hint_hudelem(160, 90, "center", "middle", font_scale * 0.8, 1);
		}
		else
		{
			self.hintelem init_hint_hudelem(160, 90, "center", "middle", font_scale, 1);
		}
	}
	else
	{
		self.hintelem init_hint_hudelem(320, ypos, "center", "bottom", font_scale, 1);
	}
}

/*
	Name: show_hint
	Namespace: zm_equipment
	Checksum: 0x802E970A
	Offset: 0x1F08
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function show_hint(equipment)
{
	self notify(#"kill_previous_show_equipment_hint_thread");
	self endon(#"kill_previous_show_equipment_hint_thread");
	self endon(#"death");
	self endon(#"disconnect");
	if(isdefined(self.do_not_display_equipment_pickup_hint) && self.do_not_display_equipment_pickup_hint)
	{
		return;
	}
	wait(0.5);
	text = get_howto_hint(equipment);
	self show_hint_text(text);
}

/*
	Name: show_hint_text
	Namespace: zm_equipment
	Checksum: 0xC37718B9
	Offset: 0x1FB0
	Size: 0x204
	Parameters: 4
	Flags: Linked
*/
function show_hint_text(text, show_for_time = 3.2, font_scale = 1.25, ypos = 220)
{
	self notify(#"hide_equipment_hint_text");
	wait(0.05);
	self setup_client_hintelem(ypos, font_scale);
	self.hintelem settext(text);
	self.hintelem.alpha = 1;
	self.hintelem.font = "small";
	self.hintelem.hidewheninmenu = 1;
	time = self util::waittill_any_timeout(show_for_time, "hide_equipment_hint_text", "death", "disconnect");
	if(isdefined(time) && isdefined(self) && isdefined(self.hintelem))
	{
		self.hintelem fadeovertime(0.25);
		self.hintelem.alpha = 0;
		self util::waittill_any_timeout(0.25, "hide_equipment_hint_text");
	}
	if(isdefined(self) && isdefined(self.hintelem))
	{
		self.hintelem settext("");
		self.hintelem destroy();
	}
}

/*
	Name: start_ammo
	Namespace: zm_equipment
	Checksum: 0x1E644DA1
	Offset: 0x21C0
	Size: 0xC6
	Parameters: 1
	Flags: Linked
*/
function start_ammo(equipment)
{
	if(self hasweapon(equipment))
	{
		maxammo = 1;
		if(isdefined(level.zombie_equipment[equipment].notake) && level.zombie_equipment[equipment].notake)
		{
			maxammo = level.zombie_equipment[equipment].start_ammo;
		}
		self setweaponammoclip(equipment, maxammo);
		self notify(#"equipment_ammo_changed", equipment);
		return maxammo;
	}
	return 0;
}

/*
	Name: change_ammo
	Namespace: zm_equipment
	Checksum: 0x259F0B05
	Offset: 0x2290
	Size: 0x13E
	Parameters: 2
	Flags: Linked
*/
function change_ammo(equipment, change)
{
	if(self hasweapon(equipment))
	{
		oldammo = self getweaponammoclip(equipment);
		maxammo = 1;
		if(isdefined(level.zombie_equipment[equipment].notake) && level.zombie_equipment[equipment].notake)
		{
			maxammo = level.zombie_equipment[equipment].start_ammo;
		}
		newammo = int(min(maxammo, max(0, oldammo + change)));
		self setweaponammoclip(equipment, newammo);
		self notify(#"equipment_ammo_changed", equipment);
		return newammo;
	}
	return 0;
}

/*
	Name: disappear_fx
	Namespace: zm_equipment
	Checksum: 0x72D1DB37
	Offset: 0x23D8
	Size: 0xA4
	Parameters: 3
	Flags: Linked
*/
function disappear_fx(origin, fx, angles)
{
	effect = level._equipment_disappear_fx;
	if(isdefined(fx))
	{
		effect = fx;
	}
	if(isdefined(angles))
	{
		playfx(effect, origin, anglestoforward(angles));
	}
	else
	{
		playfx(effect, origin);
	}
	wait(1.1);
}

/*
	Name: register_for_level
	Namespace: zm_equipment
	Checksum: 0x9F63B46A
	Offset: 0x2488
	Size: 0x72
	Parameters: 1
	Flags: Linked
*/
function register_for_level(weaponname)
{
	weapon = getweapon(weaponname);
	if(is_equipment(weapon))
	{
		return;
	}
	if(!isdefined(level.zombie_equipment_list))
	{
		level.zombie_equipment_list = [];
	}
	level.zombie_equipment_list[weapon] = weapon;
}

/*
	Name: is_equipment
	Namespace: zm_equipment
	Checksum: 0x5FA83105
	Offset: 0x2508
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function is_equipment(weapon)
{
	if(!isdefined(weapon) || !isdefined(level.zombie_equipment_list))
	{
		return 0;
	}
	return isdefined(level.zombie_equipment_list[weapon]);
}

/*
	Name: is_equipment_that_blocks_purchase
	Namespace: zm_equipment
	Checksum: 0x1457048A
	Offset: 0x2550
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function is_equipment_that_blocks_purchase(weapon)
{
	return is_equipment(weapon);
}

/*
	Name: is_player_equipment
	Namespace: zm_equipment
	Checksum: 0xA5F65DD1
	Offset: 0x2580
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function is_player_equipment(weapon)
{
	if(!isdefined(weapon) || !isdefined(self.current_equipment))
	{
		return 0;
	}
	return self.current_equipment == weapon;
}

/*
	Name: has_deployed_equipment
	Namespace: zm_equipment
	Checksum: 0xEF940F56
	Offset: 0x25C0
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function has_deployed_equipment(weapon)
{
	if(!isdefined(weapon) || !isdefined(self.deployed_equipment) || self.deployed_equipment.size < 1)
	{
		return false;
	}
	for(i = 0; i < self.deployed_equipment.size; i++)
	{
		if(self.deployed_equipment[i] == weapon)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: has_player_equipment
	Namespace: zm_equipment
	Checksum: 0xC142B145
	Offset: 0x2658
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function has_player_equipment(weapon)
{
	return self is_player_equipment(weapon) || self has_deployed_equipment(weapon);
}

/*
	Name: get_player_equipment
	Namespace: zm_equipment
	Checksum: 0x2E468E0E
	Offset: 0x26A0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function get_player_equipment()
{
	equipment = level.weaponnone;
	if(isdefined(self.current_equipment))
	{
		equipment = self.current_equipment;
	}
	return equipment;
}

/*
	Name: hacker_active
	Namespace: zm_equipment
	Checksum: 0x4F7D3DE2
	Offset: 0x26E0
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function hacker_active()
{
	return self is_active(getweapon("equip_hacker"));
}

/*
	Name: set_player_equipment
	Namespace: zm_equipment
	Checksum: 0xEC523A7E
	Offset: 0x2718
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function set_player_equipment(weapon)
{
	if(!isdefined(self.current_equipment_active))
	{
		self.current_equipment_active = [];
	}
	if(isdefined(weapon))
	{
		self.current_equipment_active[weapon] = 0;
	}
	if(!isdefined(self.equipment_got_in_round))
	{
		self.equipment_got_in_round = [];
	}
	if(isdefined(weapon))
	{
		self.equipment_got_in_round[weapon] = level.round_number;
	}
	self notify(#"new_equipment", weapon);
	self.current_equipment = weapon;
}

/*
	Name: init_player_equipment
	Namespace: zm_equipment
	Checksum: 0x9DB95F43
	Offset: 0x27B8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function init_player_equipment()
{
	self set_player_equipment(level.zombie_equipment_player_init);
}

/*
	Name: function_f30ee99e
	Namespace: zm_equipment
	Checksum: 0x43D090F1
	Offset: 0x27E8
	Size: 0x1E0
	Parameters: 0
	Flags: Linked
*/
function function_f30ee99e()
{
	/#
		setdvar("", "");
		wait(0.05);
		level flag::wait_till("");
		wait(0.05);
		str_cmd = ("" + "") + "";
		adddebugcommand(str_cmd);
		while(true)
		{
			equipment_id = getdvarstring("");
			if(equipment_id != "")
			{
				foreach(player in getplayers())
				{
					if(equipment_id == "")
					{
						player take();
						continue;
					}
					if(is_included(equipment_id))
					{
						player buy(equipment_id);
					}
				}
				setdvar("", "");
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_de79cac6
	Namespace: zm_equipment
	Checksum: 0x373F622D
	Offset: 0x29D0
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_de79cac6(equipment)
{
	/#
		wait(0.05);
		level flag::wait_till("");
		wait(0.05);
		if(isdefined(equipment))
		{
			equipment_id = equipment.name;
			str_cmd = ((("" + equipment_id) + "") + equipment_id) + "";
			adddebugcommand(str_cmd);
		}
	#/
}

