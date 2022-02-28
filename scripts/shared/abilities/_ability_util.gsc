// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\util_shared;

#namespace ability_util;

/*
	Name: gadget_is_type
	Namespace: ability_util
	Checksum: 0xED0AF001
	Offset: 0x140
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function gadget_is_type(slot, type)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return 0;
	}
	return self._gadgets_player[slot].gadget_type == type;
}

/*
	Name: gadget_slot_for_type
	Namespace: ability_util
	Checksum: 0xD401017C
	Offset: 0x190
	Size: 0x76
	Parameters: 1
	Flags: Linked
*/
function gadget_slot_for_type(type)
{
	invalid = 3;
	for(i = 0; i < 3; i++)
	{
		if(!self gadget_is_type(i, type))
		{
			continue;
		}
		return i;
	}
	return invalid;
}

/*
	Name: gadget_is_camo_suit_on
	Namespace: ability_util
	Checksum: 0xD45622EC
	Offset: 0x210
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function gadget_is_camo_suit_on()
{
	return gadget_is_active(2);
}

/*
	Name: gadget_combat_efficiency_enabled
	Namespace: ability_util
	Checksum: 0xB1EE0AB7
	Offset: 0x238
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function gadget_combat_efficiency_enabled()
{
	if(isdefined(self._gadget_combat_efficiency))
	{
		return self._gadget_combat_efficiency;
	}
	return 0;
}

/*
	Name: gadget_combat_efficiency_power_drain
	Namespace: ability_util
	Checksum: 0xE3FAF6FD
	Offset: 0x260
	Size: 0x94
	Parameters: 1
	Flags: None
*/
function gadget_combat_efficiency_power_drain(score)
{
	powerchange = -1 * score * getdvarfloat("scr_combat_efficiency_power_loss_scalar", 0.275);
	slot = gadget_slot_for_type(15);
	if(slot != 3)
	{
		self gadgetpowerchange(slot, powerchange);
	}
}

/*
	Name: gadget_is_camo_suit_flickering
	Namespace: ability_util
	Checksum: 0x138BF8A8
	Offset: 0x300
	Size: 0x66
	Parameters: 0
	Flags: None
*/
function gadget_is_camo_suit_flickering()
{
	slot = self gadget_slot_for_type(2);
	if(slot >= 0 && slot < 3)
	{
		if(self ability_player::gadget_is_flickering(slot))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: gadget_is_escort_drone_on
	Namespace: ability_util
	Checksum: 0xBF190DB7
	Offset: 0x370
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function gadget_is_escort_drone_on()
{
	return gadget_is_active(5);
}

/*
	Name: is_weapon_gadget
	Namespace: ability_util
	Checksum: 0xD5CDA0DC
	Offset: 0x398
	Size: 0x92
	Parameters: 1
	Flags: None
*/
function is_weapon_gadget(weapon)
{
	foreach(gadget_key, gadget_val in level._gadgets_level)
	{
		if(gadget_key == weapon)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: gadget_power_reset
	Namespace: ability_util
	Checksum: 0xA6596205
	Offset: 0x438
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function gadget_power_reset(gadgetweapon)
{
	slot = self gadgetgetslot(gadgetweapon);
	if(slot >= 0 && slot < 3)
	{
		self gadgetpowerreset(slot);
		self gadgetcharging(slot, 1);
	}
}

/*
	Name: gadget_reset
	Namespace: ability_util
	Checksum: 0xF48973F9
	Offset: 0x4C8
	Size: 0x33C
	Parameters: 4
	Flags: None
*/
function gadget_reset(gadgetweapon, changedclass, roundbased, firstround)
{
	if(getdvarint("gadgetEnabled") == 0)
	{
		return;
	}
	slot = self gadgetgetslot(gadgetweapon);
	if(slot >= 0 && slot < 3)
	{
		if(isdefined(self.pers["held_gadgets_power"]) && isdefined(self.pers["held_gadgets_power"][gadgetweapon]))
		{
			self gadgetpowerset(slot, self.pers["held_gadgets_power"][gadgetweapon]);
		}
		else
		{
			if(isdefined(self.pers["held_gadgets_power"]) && isdefined(self.pers[#"hash_c35f137f"]) && isdefined(self.pers["held_gadgets_power"][self.pers[#"hash_c35f137f"]]))
			{
				self gadgetpowerset(slot, self.pers["held_gadgets_power"][self.pers[#"hash_c35f137f"]]);
			}
			else if(isdefined(self.pers["held_gadgets_power"]) && isdefined(self.pers[#"hash_65987563"]) && isdefined(self.pers["held_gadgets_power"][self.pers[#"hash_65987563"]]))
			{
				self gadgetpowerset(slot, self.pers["held_gadgets_power"][self.pers[#"hash_65987563"]]);
			}
		}
		resetonclasschange = changedclass && gadgetweapon.gadget_power_reset_on_class_change;
		resetonfirstround = !isdefined(self.firstspawn) && (!roundbased || firstround);
		resetonroundswitch = !isdefined(self.firstspawn) && roundbased && !firstround && gadgetweapon.gadget_power_reset_on_round_switch;
		resetonteamchanged = isdefined(self.firstspawn) && (isdefined(self.switchedteamsresetgadgets) && self.switchedteamsresetgadgets) && gadgetweapon.gadget_power_reset_on_team_change;
		if(resetonclasschange || resetonfirstround || resetonroundswitch || resetonteamchanged)
		{
			self gadgetpowerreset(slot);
			self gadgetcharging(slot, 1);
		}
	}
}

/*
	Name: gadget_power_armor_on
	Namespace: ability_util
	Checksum: 0xDA8321D2
	Offset: 0x810
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function gadget_power_armor_on()
{
	return gadget_is_active(4);
}

/*
	Name: gadget_is_active
	Namespace: ability_util
	Checksum: 0x9807CFD6
	Offset: 0x838
	Size: 0x6E
	Parameters: 1
	Flags: Linked
*/
function gadget_is_active(gadgettype)
{
	slot = self gadget_slot_for_type(gadgettype);
	if(slot >= 0 && slot < 3)
	{
		if(self ability_player::gadget_is_in_use(slot))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: gadget_has_type
	Namespace: ability_util
	Checksum: 0xE203E3A9
	Offset: 0x8B0
	Size: 0x52
	Parameters: 1
	Flags: None
*/
function gadget_has_type(gadgettype)
{
	slot = self gadget_slot_for_type(gadgettype);
	if(slot >= 0 && slot < 3)
	{
		return true;
	}
	return false;
}

