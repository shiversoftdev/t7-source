// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace player;

/*
	Name: __init__sytem__
	Namespace: player
	Checksum: 0x662C3511
	Offset: 0x200
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("player", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: player
	Checksum: 0x770BA8EB
	Offset: 0x240
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_spawned(&on_player_spawned);
	clientfield::register("world", "gameplay_started", 4000, 1, "int");
}

/*
	Name: on_player_spawned
	Namespace: player
	Checksum: 0x36853D18
	Offset: 0x2A0
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	mapname = getdvarstring("mapname");
	if(mapname === "core_frontend")
	{
		return;
	}
	if(sessionmodeiszombiesgame() || sessionmodeiscampaigngame())
	{
		snappedorigin = self get_snapped_spot_origin(self.origin);
		if(!self flagsys::get("shared_igc"))
		{
			self setorigin(snappedorigin);
		}
	}
	ismultiplayer = !sessionmodeiszombiesgame() && !sessionmodeiscampaigngame();
	if(!ismultiplayer || (isdefined(level._enablelastvalidposition) && level._enablelastvalidposition))
	{
		self thread last_valid_position();
	}
}

/*
	Name: last_valid_position
	Namespace: player
	Checksum: 0xE399B5E8
	Offset: 0x3D8
	Size: 0x22C
	Parameters: 0
	Flags: Linked
*/
function last_valid_position()
{
	self endon(#"disconnect");
	self notify(#"stop_last_valid_position");
	self endon(#"stop_last_valid_position");
	while(!isdefined(self.last_valid_position))
	{
		self.last_valid_position = getclosestpointonnavmesh(self.origin, 2048, 0);
		wait(0.1);
	}
	while(true)
	{
		if(distance2dsquared(self.origin, self.last_valid_position) < (15 * 15) && (self.origin[2] - self.last_valid_position[2]) * (self.origin[2] - self.last_valid_position[2]) < (16 * 16))
		{
			wait(0.1);
			continue;
		}
		if(isdefined(level.last_valid_position_override) && self [[level.last_valid_position_override]]())
		{
			wait(0.1);
			continue;
		}
		else
		{
			if(ispointonnavmesh(self.origin, self))
			{
				self.last_valid_position = self.origin;
			}
			else
			{
				if(!ispointonnavmesh(self.origin, self) && ispointonnavmesh(self.last_valid_position, self) && distance2dsquared(self.origin, self.last_valid_position) < (32 * 32))
				{
					wait(0.1);
					continue;
				}
				else
				{
					position = getclosestpointonnavmesh(self.origin, 100, 15);
					if(isdefined(position))
					{
						self.last_valid_position = position;
					}
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: take_weapons
	Namespace: player
	Checksum: 0xBA0B2581
	Offset: 0x610
	Size: 0x212
	Parameters: 0
	Flags: Linked
*/
function take_weapons()
{
	if(!(isdefined(self.gun_removed) && self.gun_removed))
	{
		self.gun_removed = 1;
		self._weapons = [];
		if(!isdefined(self._current_weapon))
		{
			self._current_weapon = level.weaponnone;
		}
		w_current = self getcurrentweapon();
		if(w_current != level.weaponnone)
		{
			self._current_weapon = w_current;
		}
		a_weapon_list = self getweaponslist();
		if(self._current_weapon == level.weaponnone)
		{
			if(isdefined(a_weapon_list[0]))
			{
				self._current_weapon = a_weapon_list[0];
			}
		}
		foreach(weapon in a_weapon_list)
		{
			if(isdefined(weapon.dniweapon) && weapon.dniweapon)
			{
				continue;
			}
			if(!isdefined(self._weapons))
			{
				self._weapons = [];
			}
			else if(!isarray(self._weapons))
			{
				self._weapons = array(self._weapons);
			}
			self._weapons[self._weapons.size] = get_weapondata(weapon);
			self takeweapon(weapon);
		}
	}
}

/*
	Name: generate_weapon_data
	Namespace: player
	Checksum: 0xE3A5CC14
	Offset: 0x830
	Size: 0x234
	Parameters: 0
	Flags: None
*/
function generate_weapon_data()
{
	self._generated_weapons = [];
	if(!isdefined(self._generated_current_weapon))
	{
		self._generated_current_weapon = level.weaponnone;
	}
	if(isdefined(self.gun_removed) && self.gun_removed && isdefined(self._weapons))
	{
		self._generated_weapons = arraycopy(self._weapons);
		self._generated_current_weapon = self._current_weapon;
	}
	else
	{
		w_current = self getcurrentweapon();
		if(w_current != level.weaponnone)
		{
			self._generated_current_weapon = w_current;
		}
		a_weapon_list = self getweaponslist();
		if(self._generated_current_weapon == level.weaponnone)
		{
			if(isdefined(a_weapon_list[0]))
			{
				self._generated_current_weapon = a_weapon_list[0];
			}
		}
		foreach(weapon in a_weapon_list)
		{
			if(isdefined(weapon.dniweapon) && weapon.dniweapon)
			{
				continue;
			}
			if(!isdefined(self._generated_weapons))
			{
				self._generated_weapons = [];
			}
			else if(!isarray(self._generated_weapons))
			{
				self._generated_weapons = array(self._generated_weapons);
			}
			self._generated_weapons[self._generated_weapons.size] = get_weapondata(weapon);
		}
	}
}

/*
	Name: give_back_weapons
	Namespace: player
	Checksum: 0x45CFC367
	Offset: 0xA70
	Size: 0x176
	Parameters: 1
	Flags: Linked
*/
function give_back_weapons(b_immediate = 0)
{
	if(isdefined(self._weapons))
	{
		foreach(weapondata in self._weapons)
		{
			weapondata_give(weapondata);
		}
		if(isdefined(self._current_weapon) && self._current_weapon != level.weaponnone)
		{
			if(b_immediate)
			{
				self switchtoweaponimmediate(self._current_weapon);
			}
			else
			{
				self switchtoweapon(self._current_weapon);
			}
		}
		else if(isdefined(self.primaryloadoutweapon) && self hasweapon(self.primaryloadoutweapon))
		{
			switch_to_primary_weapon(b_immediate);
		}
	}
	self._weapons = undefined;
	self.gun_removed = undefined;
}

/*
	Name: get_weapondata
	Namespace: player
	Checksum: 0xD3F45951
	Offset: 0xBF0
	Size: 0x30A
	Parameters: 1
	Flags: Linked
*/
function get_weapondata(weapon)
{
	weapondata = [];
	if(!isdefined(weapon))
	{
		weapon = self getcurrentweapon();
	}
	weapondata["weapon"] = weapon.name;
	if(weapon != level.weaponnone)
	{
		weapondata["clip"] = self getweaponammoclip(weapon);
		weapondata["stock"] = self getweaponammostock(weapon);
		weapondata["fuel"] = self getweaponammofuel(weapon);
		weapondata["heat"] = self isweaponoverheating(1, weapon);
		weapondata["overheat"] = self isweaponoverheating(0, weapon);
		weapondata["renderOptions"] = self getweaponoptions(weapon);
		weapondata["acvi"] = self getplayerattachmentcosmeticvariantindexes(weapon);
		if(weapon.isriotshield)
		{
			weapondata["health"] = self.weaponhealth;
		}
	}
	else
	{
		weapondata["clip"] = 0;
		weapondata["stock"] = 0;
		weapondata["fuel"] = 0;
		weapondata["heat"] = 0;
		weapondata["overheat"] = 0;
	}
	if(weapon.dualwieldweapon != level.weaponnone)
	{
		weapondata["lh_clip"] = self getweaponammoclip(weapon.dualwieldweapon);
	}
	else
	{
		weapondata["lh_clip"] = 0;
	}
	if(weapon.altweapon != level.weaponnone)
	{
		weapondata["alt_clip"] = self getweaponammoclip(weapon.altweapon);
		weapondata["alt_stock"] = self getweaponammostock(weapon.altweapon);
	}
	else
	{
		weapondata["alt_clip"] = 0;
		weapondata["alt_stock"] = 0;
	}
	return weapondata;
}

/*
	Name: weapondata_give
	Namespace: player
	Checksum: 0x644277D1
	Offset: 0xF08
	Size: 0x264
	Parameters: 1
	Flags: Linked
*/
function weapondata_give(weapondata)
{
	weapon = util::get_weapon_by_name(weapondata["weapon"]);
	self giveweapon(weapon, weapondata["renderOptions"], weapondata["acvi"]);
	if(weapon != level.weaponnone)
	{
		self setweaponammoclip(weapon, weapondata["clip"]);
		self setweaponammostock(weapon, weapondata["stock"]);
		if(isdefined(weapondata["fuel"]))
		{
			self setweaponammofuel(weapon, weapondata["fuel"]);
		}
		if(isdefined(weapondata["heat"]) && isdefined(weapondata["overheat"]))
		{
			self setweaponoverheating(weapondata["overheat"], weapondata["heat"], weapon);
		}
		if(weapon.isriotshield && isdefined(weapondata["health"]))
		{
			self.weaponhealth = weapondata["health"];
		}
	}
	if(weapon.dualwieldweapon != level.weaponnone)
	{
		self setweaponammoclip(weapon.dualwieldweapon, weapondata["lh_clip"]);
	}
	if(weapon.altweapon != level.weaponnone)
	{
		self setweaponammoclip(weapon.altweapon, weapondata["alt_clip"]);
		self setweaponammostock(weapon.altweapon, weapondata["alt_stock"]);
	}
}

/*
	Name: switch_to_primary_weapon
	Namespace: player
	Checksum: 0xD1E657B6
	Offset: 0x1178
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function switch_to_primary_weapon(b_immediate = 0)
{
	if(is_valid_weapon(self.primaryloadoutweapon))
	{
		if(b_immediate)
		{
			self switchtoweaponimmediate(self.primaryloadoutweapon);
		}
		else
		{
			self switchtoweapon(self.primaryloadoutweapon);
		}
	}
}

/*
	Name: fill_current_clip
	Namespace: player
	Checksum: 0x27CBE6A9
	Offset: 0x1200
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function fill_current_clip()
{
	w_current = self getcurrentweapon();
	if(w_current.isheroweapon)
	{
		w_current = self.primaryloadoutweapon;
	}
	if(isdefined(w_current) && self hasweapon(w_current))
	{
		self setweaponammoclip(w_current, w_current.clipsize);
	}
}

/*
	Name: is_valid_weapon
	Namespace: player
	Checksum: 0xCAD2BE8B
	Offset: 0x12A0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function is_valid_weapon(weaponobject)
{
	return isdefined(weaponobject) && weaponobject != level.weaponnone;
}

/*
	Name: is_spawn_protected
	Namespace: player
	Checksum: 0x52846471
	Offset: 0x12D0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function is_spawn_protected()
{
	return (gettime() - (isdefined(self.spawntime) ? self.spawntime : 0)) <= level.spawnprotectiontimems;
}

/*
	Name: simple_respawn
	Namespace: player
	Checksum: 0x15A9F39B
	Offset: 0x1308
	Size: 0x18
	Parameters: 0
	Flags: None
*/
function simple_respawn()
{
	self [[level.onspawnplayer]](0);
}

/*
	Name: get_snapped_spot_origin
	Namespace: player
	Checksum: 0x940B8FC8
	Offset: 0x1328
	Size: 0x142
	Parameters: 1
	Flags: Linked
*/
function get_snapped_spot_origin(spot_position)
{
	snap_max_height = 100;
	size = 15;
	height = size * 2;
	mins = (-1 * size, -1 * size, 0);
	maxs = (size, size, height);
	spot_position = (spot_position[0], spot_position[1], spot_position[2] + 5);
	new_spot_position = (spot_position[0], spot_position[1], spot_position[2] - snap_max_height);
	trace = physicstrace(spot_position, new_spot_position, mins, maxs, self);
	if(trace["fraction"] < 1)
	{
		return trace["position"];
	}
	return spot_position;
}

/*
	Name: allow_stance_change
	Namespace: player
	Checksum: 0x41B17CBE
	Offset: 0x1478
	Size: 0x19E
	Parameters: 1
	Flags: None
*/
function allow_stance_change(b_allow = 1)
{
	if(b_allow)
	{
		self allowprone(1);
		self allowcrouch(1);
		self allowstand(1);
	}
	else
	{
		str_stance = self getstance();
		switch(str_stance)
		{
			case "prone":
			{
				self allowprone(1);
				self allowcrouch(0);
				self allowstand(0);
				break;
			}
			case "crouch":
			{
				self allowprone(0);
				self allowcrouch(1);
				self allowstand(0);
				break;
			}
			case "stand":
			{
				self allowprone(0);
				self allowcrouch(0);
				self allowstand(1);
				break;
			}
		}
	}
}

