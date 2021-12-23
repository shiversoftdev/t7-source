// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;

#namespace weapons;

/*
	Name: is_primary_weapon
	Namespace: weapons
	Checksum: 0xAA47FC6F
	Offset: 0x148
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function is_primary_weapon(weapon)
{
	root_weapon = weapon.rootweapon;
	return root_weapon != level.weaponnone && isdefined(level.primary_weapon_array[root_weapon]);
}

/*
	Name: is_side_arm
	Namespace: weapons
	Checksum: 0xB598AAC4
	Offset: 0x198
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function is_side_arm(weapon)
{
	root_weapon = weapon.rootweapon;
	return root_weapon != level.weaponnone && isdefined(level.side_arm_array[root_weapon]);
}

/*
	Name: is_inventory
	Namespace: weapons
	Checksum: 0xB2504E18
	Offset: 0x1E8
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function is_inventory(weapon)
{
	root_weapon = weapon.rootweapon;
	return root_weapon != level.weaponnone && isdefined(level.inventory_array[root_weapon]);
}

/*
	Name: is_grenade
	Namespace: weapons
	Checksum: 0xB59BADA3
	Offset: 0x238
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function is_grenade(weapon)
{
	root_weapon = weapon.rootweapon;
	return root_weapon != level.weaponnone && isdefined(level.grenade_array[root_weapon]);
}

/*
	Name: force_stowed_weapon_update
	Namespace: weapons
	Checksum: 0xC449641B
	Offset: 0x288
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function force_stowed_weapon_update()
{
	detach_all_weapons();
	stow_on_back();
	stow_on_hip();
}

/*
	Name: detach_carry_object_model
	Namespace: weapons
	Checksum: 0xA387F0BE
	Offset: 0x2C8
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function detach_carry_object_model()
{
	if(isdefined(self.carryobject) && isdefined(self.carryobject gameobjects::get_visible_carrier_model()))
	{
		if(isdefined(self.tag_stowed_back))
		{
			self detach(self.tag_stowed_back, "tag_stowed_back");
			self.tag_stowed_back = undefined;
		}
	}
}

/*
	Name: detach_all_weapons
	Namespace: weapons
	Checksum: 0x84C9E58E
	Offset: 0x340
	Size: 0x136
	Parameters: 0
	Flags: Linked
*/
function detach_all_weapons()
{
	if(isdefined(self.tag_stowed_back))
	{
		clear_weapon = 1;
		if(isdefined(self.carryobject))
		{
			carriermodel = self.carryobject gameobjects::get_visible_carrier_model();
			if(isdefined(carriermodel) && carriermodel == self.tag_stowed_back)
			{
				self detach(self.tag_stowed_back, "tag_stowed_back");
				clear_weapon = 0;
			}
		}
		if(clear_weapon)
		{
			self clearstowedweapon();
		}
		self.tag_stowed_back = undefined;
	}
	else
	{
		self clearstowedweapon();
	}
	if(isdefined(self.tag_stowed_hip))
	{
		detach_model = self.tag_stowed_hip.worldmodel;
		self detach(detach_model, "tag_stowed_hip_rear");
		self.tag_stowed_hip = undefined;
	}
}

/*
	Name: stow_on_back
	Namespace: weapons
	Checksum: 0xD8C6006E
	Offset: 0x480
	Size: 0x1D4
	Parameters: 1
	Flags: Linked
*/
function stow_on_back(current)
{
	currentweapon = self getcurrentweapon();
	currentaltweapon = currentweapon.altweapon;
	self.tag_stowed_back = undefined;
	weaponoptions = 0;
	index_weapon = level.weaponnone;
	if(isdefined(self.carryobject) && isdefined(self.carryobject gameobjects::get_visible_carrier_model()))
	{
		self.tag_stowed_back = self.carryobject gameobjects::get_visible_carrier_model();
		self attach(self.tag_stowed_back, "tag_stowed_back", 1);
		return;
	}
	if(currentweapon != level.weaponnone)
	{
		for(idx = 0; idx < self.weapon_array_primary.size; idx++)
		{
			temp_index_weapon = self.weapon_array_primary[idx];
			/#
				assert(isdefined(temp_index_weapon), "");
			#/
			if(temp_index_weapon == currentweapon)
			{
				continue;
			}
			if(temp_index_weapon == currentaltweapon)
			{
				continue;
			}
			if(temp_index_weapon.nonstowedweapon)
			{
				continue;
			}
			index_weapon = temp_index_weapon;
		}
	}
	self setstowedweapon(index_weapon);
}

/*
	Name: stow_on_hip
	Namespace: weapons
	Checksum: 0x255225CE
	Offset: 0x660
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function stow_on_hip()
{
	currentweapon = self getcurrentweapon();
	self.tag_stowed_hip = undefined;
	for(idx = 0; idx < self.weapon_array_inventory.size; idx++)
	{
		if(self.weapon_array_inventory[idx] == currentweapon)
		{
			continue;
		}
		if(!self getweaponammostock(self.weapon_array_inventory[idx]))
		{
			continue;
		}
		self.tag_stowed_hip = self.weapon_array_inventory[idx];
	}
	if(!isdefined(self.tag_stowed_hip))
	{
		return;
	}
	self attach(self.tag_stowed_hip.worldmodel, "tag_stowed_hip_rear", 1);
}

/*
	Name: weapondamagetracepassed
	Namespace: weapons
	Checksum: 0xC0D88EB3
	Offset: 0x768
	Size: 0x62
	Parameters: 4
	Flags: Linked
*/
function weapondamagetracepassed(from, to, startradius, ignore)
{
	trace = weapondamagetrace(from, to, startradius, ignore);
	return trace["fraction"] == 1;
}

/*
	Name: weapondamagetrace
	Namespace: weapons
	Checksum: 0x5E48222D
	Offset: 0x7D8
	Size: 0x1E0
	Parameters: 4
	Flags: Linked
*/
function weapondamagetrace(from, to, startradius, ignore)
{
	midpos = undefined;
	diff = to - from;
	if(lengthsquared(diff) < (startradius * startradius))
	{
		midpos = to;
	}
	dir = vectornormalize(diff);
	midpos = from + (dir[0] * startradius, dir[1] * startradius, dir[2] * startradius);
	trace = bullettrace(midpos, to, 0, ignore);
	if(getdvarint("scr_damage_debug") != 0)
	{
		if(trace["fraction"] == 1)
		{
			thread debugline(midpos, to, (1, 1, 1));
		}
		else
		{
			thread debugline(midpos, trace["position"], (1, 0.9, 0.8));
			thread debugline(trace["position"], to, (1, 0.4, 0.3));
		}
	}
	return trace;
}

/*
	Name: has_lmg
	Namespace: weapons
	Checksum: 0x67A3FC62
	Offset: 0x9C0
	Size: 0x40
	Parameters: 0
	Flags: None
*/
function has_lmg()
{
	weapon = self getcurrentweapon();
	return weapon.weapclass == "mg";
}

/*
	Name: has_launcher
	Namespace: weapons
	Checksum: 0x2A71F790
	Offset: 0xA08
	Size: 0x36
	Parameters: 0
	Flags: None
*/
function has_launcher()
{
	weapon = self getcurrentweapon();
	return weapon.isrocketlauncher;
}

/*
	Name: has_hero_weapon
	Namespace: weapons
	Checksum: 0x5595CE02
	Offset: 0xA48
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function has_hero_weapon()
{
	weapon = self getcurrentweapon();
	return weapon.gadget_type == 14;
}

/*
	Name: has_lockon
	Namespace: weapons
	Checksum: 0xC42C8FB4
	Offset: 0xA90
	Size: 0x6E
	Parameters: 1
	Flags: None
*/
function has_lockon(target)
{
	player = self;
	clientnum = player getentitynumber();
	return isdefined(target.locked_on) && target.locked_on & (1 << clientnum);
}

