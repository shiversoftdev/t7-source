// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace _zm_weapon_locker;

/*
	Name: main
	Namespace: _zm_weapon_locker
	Checksum: 0x6B94BF62
	Offset: 0x2A8
	Size: 0x8C
	Parameters: 0
	Flags: None
*/
function main()
{
	if(!isdefined(level.weapon_locker_map))
	{
		level.weapon_locker_map = level.script;
	}
	level.weapon_locker_online = sessionmodeisonlinegame();
	weapon_lockers = struct::get_array("weapons_locker", "targetname");
	array::thread_all(weapon_lockers, &triggerweaponslockerwatch);
}

/*
	Name: wl_has_stored_weapondata
	Namespace: _zm_weapon_locker
	Checksum: 0x39C2B763
	Offset: 0x340
	Size: 0x1E
	Parameters: 0
	Flags: None
*/
function wl_has_stored_weapondata()
{
	if(level.weapon_locker_online)
	{
	}
	else
	{
		return isdefined(self.stored_weapon_data);
	}
}

/*
	Name: wl_get_stored_weapondata
	Namespace: _zm_weapon_locker
	Checksum: 0xED6E3818
	Offset: 0x368
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function wl_get_stored_weapondata()
{
	if(level.weapon_locker_online)
	{
	}
	else
	{
		return self.stored_weapon_data;
	}
}

/*
	Name: wl_clear_stored_weapondata
	Namespace: _zm_weapon_locker
	Checksum: 0x91D1283
	Offset: 0x390
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function wl_clear_stored_weapondata()
{
	if(level.weapon_locker_online)
	{
	}
	else
	{
		self.stored_weapon_data = undefined;
	}
}

/*
	Name: wl_set_stored_weapondata
	Namespace: _zm_weapon_locker
	Checksum: 0xAC0BF029
	Offset: 0x3B8
	Size: 0x28
	Parameters: 1
	Flags: None
*/
function wl_set_stored_weapondata(weapondata)
{
	if(level.weapon_locker_online)
	{
	}
	else
	{
		self.stored_weapon_data = weapondata;
	}
}

/*
	Name: triggerweaponslockerwatch
	Namespace: _zm_weapon_locker
	Checksum: 0xFBD35371
	Offset: 0x3E8
	Size: 0x214
	Parameters: 0
	Flags: None
*/
function triggerweaponslockerwatch()
{
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = self.origin;
	if(isdefined(self.script_angles))
	{
		unitrigger_stub.angles = self.script_angles;
	}
	else
	{
		unitrigger_stub.angles = self.angles;
	}
	unitrigger_stub.script_angles = unitrigger_stub.angles;
	if(isdefined(self.script_length))
	{
		unitrigger_stub.script_length = self.script_length;
	}
	else
	{
		unitrigger_stub.script_length = 16;
	}
	if(isdefined(self.script_width))
	{
		unitrigger_stub.script_width = self.script_width;
	}
	else
	{
		unitrigger_stub.script_width = 32;
	}
	if(isdefined(self.script_height))
	{
		unitrigger_stub.script_height = self.script_height;
	}
	else
	{
		unitrigger_stub.script_height = 64;
	}
	unitrigger_stub.origin = unitrigger_stub.origin - (anglestoright(unitrigger_stub.angles) * (unitrigger_stub.script_length / 2));
	unitrigger_stub.targetname = "weapon_locker";
	unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	unitrigger_stub.clientfieldname = "weapon_locker";
	zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, 1);
	unitrigger_stub.prompt_and_visibility_func = &triggerweaponslockerthinkupdateprompt;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &triggerweaponslockerthink);
}

/*
	Name: triggerweaponslockerisvalidweapon
	Namespace: _zm_weapon_locker
	Checksum: 0x48A60A6D
	Offset: 0x608
	Size: 0x7E
	Parameters: 1
	Flags: None
*/
function triggerweaponslockerisvalidweapon(weapon)
{
	weapon = zm_weapons::get_base_weapon(weapon);
	if(!zm_weapons::is_weapon_included(weapon))
	{
		return false;
	}
	if(zm_utility::is_offhand_weapon(weapon) || zm_utility::is_limited_weapon(weapon))
	{
		return false;
	}
	return true;
}

/*
	Name: triggerweaponslockerisvalidweaponpromptupdate
	Namespace: _zm_weapon_locker
	Checksum: 0x5DAC4E0E
	Offset: 0x690
	Size: 0x354
	Parameters: 2
	Flags: None
*/
function triggerweaponslockerisvalidweaponpromptupdate(player, weapon)
{
	retrievingweapon = player wl_has_stored_weapondata();
	if(!retrievingweapon)
	{
		weapon = player zm_weapons::get_nonalternate_weapon(weapon);
		if(weapon == level.weaponnone)
		{
			self setcursorhint("HINT_NOICON");
			if(!triggerweaponslockerisvalidweapon(weapon))
			{
				self sethintstring(&"ZOMBIE_WEAPON_LOCKER_DENY");
			}
			else
			{
				self sethintstring(&"ZOMBIE_WEAPON_LOCKER_STORE");
			}
		}
		else
		{
			self setcursorhint("HINT_WEAPON", weapon);
			if(!triggerweaponslockerisvalidweapon(weapon))
			{
				self sethintstring(&"ZOMBIE_WEAPON_LOCKER_DENY_FILL");
			}
			else
			{
				self sethintstring(&"ZOMBIE_WEAPON_LOCKER_STORE_FILL");
			}
		}
	}
	else
	{
		weapondata = player wl_get_stored_weapondata();
		if(isdefined(level.remap_weapon_locker_weapons))
		{
			weapondata = remap_weapon(weapondata, level.remap_weapon_locker_weapons);
		}
		weapontogive = weapondata["weapon"];
		primaries = player getweaponslistprimaries();
		maxweapons = zm_utility::get_player_weapon_limit(player);
		weapon = player zm_weapons::get_nonalternate_weapon(weapon);
		if(isdefined(primaries) && primaries.size >= maxweapons || weapontogive == weapon)
		{
			if(!triggerweaponslockerisvalidweapon(weapon))
			{
				if(weapon == level.weaponnone)
				{
					self setcursorhint("HINT_NOICON", weapon);
					self sethintstring(&"ZOMBIE_WEAPON_LOCKER_DENY");
				}
				else
				{
					self setcursorhint("HINT_WEAPON", weapon);
					self sethintstring(&"ZOMBIE_WEAPON_LOCKER_DENY_FILL");
				}
				return;
			}
		}
		self setcursorhint("HINT_WEAPON", weapontogive);
		self sethintstring(&"ZOMBIE_WEAPON_LOCKER_GRAB_FILL");
	}
}

/*
	Name: triggerweaponslockerthinkupdateprompt
	Namespace: _zm_weapon_locker
	Checksum: 0x29EC76EC
	Offset: 0x9F0
	Size: 0x40
	Parameters: 1
	Flags: None
*/
function triggerweaponslockerthinkupdateprompt(player)
{
	self triggerweaponslockerisvalidweaponpromptupdate(player, player getcurrentweapon());
	return true;
}

/*
	Name: triggerweaponslockerthink
	Namespace: _zm_weapon_locker
	Checksum: 0xF9DCB9B5
	Offset: 0xA38
	Size: 0x6C0
	Parameters: 0
	Flags: None
*/
function triggerweaponslockerthink()
{
	self.parent_player thread triggerweaponslockerweaponchangethink(self);
	while(true)
	{
		self waittill(#"trigger", player);
		retrievingweapon = player wl_has_stored_weapondata();
		if(!retrievingweapon)
		{
			curweapon = player getcurrentweapon();
			curweapon = player zm_weapons::switch_from_alt_weapon(curweapon);
			if(!triggerweaponslockerisvalidweapon(curweapon))
			{
				continue;
			}
			weapondata = player zm_weapons::get_player_weapondata(player);
			player wl_set_stored_weapondata(weapondata);
			/#
				assert(curweapon == weapondata[""], "");
			#/
			player takeweapon(curweapon);
			primaries = player getweaponslistprimaries();
			if(isdefined(primaries[0]))
			{
				player switchtoweapon(primaries[0]);
			}
			else
			{
				player zm_weapons::give_fallback_weapon();
			}
			self triggerweaponslockerisvalidweaponpromptupdate(player, player getcurrentweapon());
			player playsoundtoplayer("evt_fridge_locker_close", player);
			player thread zm_audio::create_and_play_dialog("general", "weapon_storage");
		}
		else
		{
			curweapon = player getcurrentweapon();
			primaries = player getweaponslistprimaries();
			weapondata = player wl_get_stored_weapondata();
			if(isdefined(level.remap_weapon_locker_weapons))
			{
				weapondata = remap_weapon(weapondata, level.remap_weapon_locker_weapons);
			}
			weapontogive = weapondata["weapon"];
			if(!triggerweaponslockerisvalidweapon(weapontogive))
			{
				player playlocalsound(level.zmb_laugh_alias);
				player wl_clear_stored_weapondata();
				self triggerweaponslockerisvalidweaponpromptupdate(player, player getcurrentweapon());
				continue;
			}
			curweap_base = zm_weapons::get_base_weapon(curweapon);
			weap_base = zm_weapons::get_base_weapon(weapontogive);
			if(player zm_weapons::has_weapon_or_upgrade(weap_base) && weap_base != curweap_base)
			{
				self sethintstring(&"ZOMBIE_WEAPON_LOCKER_DENY");
				wait(3);
				self triggerweaponslockerisvalidweaponpromptupdate(player, player getcurrentweapon());
				continue;
			}
			maxweapons = zm_utility::get_player_weapon_limit(player);
			if(isdefined(primaries) && primaries.size >= maxweapons || weapontogive == curweapon)
			{
				curweapon = player zm_weapons::switch_from_alt_weapon(curweapon);
				if(!triggerweaponslockerisvalidweapon(curweapon))
				{
					self sethintstring(&"ZOMBIE_WEAPON_LOCKER_DENY");
					wait(3);
					self triggerweaponslockerisvalidweaponpromptupdate(player, player getcurrentweapon());
					continue;
				}
				curweapondata = player zm_weapons::get_player_weapondata(player);
				player takeweapon(curweapondata["weapon"]);
				player zm_weapons::weapondata_give(weapondata);
				player wl_clear_stored_weapondata();
				player wl_set_stored_weapondata(curweapondata);
				player switchtoweapon(weapondata["weapon"]);
				self triggerweaponslockerisvalidweaponpromptupdate(player, player getcurrentweapon());
			}
			else
			{
				player thread zm_audio::create_and_play_dialog("general", "wall_withdrawl");
				player wl_clear_stored_weapondata();
				player zm_weapons::weapondata_give(weapondata);
				player switchtoweapon(weapondata["weapon"]);
				self triggerweaponslockerisvalidweaponpromptupdate(player, player getcurrentweapon());
			}
			level notify(#"weapon_locker_grab");
			player playsoundtoplayer("evt_fridge_locker_open", player);
		}
		wait(0.5);
	}
}

/*
	Name: triggerweaponslockerweaponchangethink
	Namespace: _zm_weapon_locker
	Checksum: 0x5877EC12
	Offset: 0x1100
	Size: 0x70
	Parameters: 1
	Flags: None
*/
function triggerweaponslockerweaponchangethink(trigger)
{
	self endon(#"disconnect");
	self endon(#"death");
	trigger endon(#"kill_trigger");
	while(true)
	{
		self waittill(#"weapon_change", newweapon);
		trigger triggerweaponslockerisvalidweaponpromptupdate(self, newweapon);
	}
}

/*
	Name: add_weapon_locker_mapping
	Namespace: _zm_weapon_locker
	Checksum: 0x9991D4B7
	Offset: 0x1178
	Size: 0x3E
	Parameters: 2
	Flags: None
*/
function add_weapon_locker_mapping(fromweapon, toweapon)
{
	if(!isdefined(level.remap_weapon_locker_weapons))
	{
		level.remap_weapon_locker_weapons = [];
	}
	level.remap_weapon_locker_weapons[fromweapon] = toweapon;
}

/*
	Name: remap_weapon
	Namespace: _zm_weapon_locker
	Checksum: 0xE8B5956D
	Offset: 0x11C0
	Size: 0x456
	Parameters: 2
	Flags: None
*/
function remap_weapon(weapondata, maptable)
{
	weapon = weapondata["weapon"].rootweapon;
	att = undefined;
	if(weapondata["weapon"].attachments.size)
	{
		att = weapondata["weapon"].attachments[0];
	}
	if(!isdefined(maptable[weapon]))
	{
		return weapondata;
	}
	weapondata["weapon"] = maptable[weapon];
	weapon = weapondata["weapon"];
	if(zm_weapons::is_weapon_upgraded(weapon))
	{
		if(isdefined(att) && zm_weapons::weapon_supports_attachments(weapon))
		{
			base = zm_weapons::get_base_weapon(weapon);
			if(!zm_weapons::weapon_supports_this_attachment(base, att))
			{
				att = zm_weapons::random_attachment(base);
			}
			weapondata["weapon"] = getweapon(weapondata["weapon"], att);
		}
		else if(zm_weapons::weapon_supports_default_attachment(weapon))
		{
			att = zm_weapons::default_attachment(weapon);
			weapondata["weapon"] = getweapon(weapondata["weapon"], att);
		}
	}
	weapon = weapondata["weapon"];
	if(weapon != level.weaponnone)
	{
		weapondata["clip"] = int(min(weapondata["clip"], weapon.clipsize));
		weapondata["stock"] = int(min(weapondata["stock"], weapon.maxammo));
		weapondata["fuel"] = int(min(weapondata["fuel"], weapon.fuellife));
	}
	dw_weapon = weapon.dualwieldweapon;
	if(dw_weapon != level.weaponnone)
	{
		weapondata["lh_clip"] = int(min(weapondata["lh_clip"], dw_weapon.clipsize));
	}
	alt_weapon = weapon.altweapon;
	if(alt_weapon != level.weaponnone)
	{
		weapondata["alt_clip"] = int(min(weapondata["alt_clip"], alt_weapon.clipsize));
		weapondata["alt_stock"] = int(min(weapondata["alt_stock"], alt_weapon.maxammo));
	}
	return weapondata;
}

