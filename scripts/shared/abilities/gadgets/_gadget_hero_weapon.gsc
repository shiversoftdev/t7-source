// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_hero_weapon;

/*
	Name: __init__sytem__
	Namespace: _gadget_hero_weapon
	Checksum: 0x3A7D22BD
	Offset: 0x240
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_hero_weapon", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_hero_weapon
	Checksum: 0x87386B55
	Offset: 0x280
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(14, &gadget_hero_weapon_on_activate, &gadget_hero_weapon_on_off);
	ability_player::register_gadget_possession_callbacks(14, &gadget_hero_weapon_on_give, &gadget_hero_weapon_on_take);
	ability_player::register_gadget_flicker_callbacks(14, &gadget_hero_weapon_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(14, &gadget_hero_weapon_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(14, &gadget_hero_weapon_is_flickering);
	ability_player::register_gadget_ready_callbacks(14, &gadget_hero_weapon_ready);
}

/*
	Name: gadget_hero_weapon_is_inuse
	Namespace: _gadget_hero_weapon
	Checksum: 0xA5D54BA9
	Offset: 0x370
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_hero_weapon_is_inuse(slot)
{
	return self gadgetisactive(slot);
}

/*
	Name: gadget_hero_weapon_is_flickering
	Namespace: _gadget_hero_weapon
	Checksum: 0x709D7D04
	Offset: 0x3A0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_hero_weapon_is_flickering(slot)
{
	return self gadgetflickering(slot);
}

/*
	Name: gadget_hero_weapon_on_flicker
	Namespace: _gadget_hero_weapon
	Checksum: 0xCE16C13B
	Offset: 0x3D0
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_hero_weapon_on_flicker(slot, weapon)
{
}

/*
	Name: gadget_hero_weapon_on_give
	Namespace: _gadget_hero_weapon
	Checksum: 0xAC8F379B
	Offset: 0x3F0
	Size: 0x194
	Parameters: 2
	Flags: Linked
*/
function gadget_hero_weapon_on_give(slot, weapon)
{
	if(!isdefined(self.pers["held_hero_weapon_ammo_count"]))
	{
		self.pers["held_hero_weapon_ammo_count"] = [];
	}
	if(weapon.gadget_power_consume_on_ammo_use || !isdefined(self.pers["held_hero_weapon_ammo_count"][weapon]))
	{
		self.pers["held_hero_weapon_ammo_count"][weapon] = 0;
	}
	self setweaponammoclip(weapon, self.pers["held_hero_weapon_ammo_count"][weapon]);
	n_ammo = self getammocount(weapon);
	if(n_ammo > 0)
	{
		stock = self.pers["held_hero_weapon_ammo_count"][weapon] - n_ammo;
		if(stock > 0 && !weapon.iscliponly)
		{
			self setweaponammostock(weapon, stock);
		}
		self hero_handle_ammo_save(slot, weapon);
	}
	else
	{
		self gadgetcharging(slot, 1);
	}
}

/*
	Name: gadget_hero_weapon_on_take
	Namespace: _gadget_hero_weapon
	Checksum: 0x8AC5DCB9
	Offset: 0x590
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_hero_weapon_on_take(slot, weapon)
{
}

/*
	Name: gadget_hero_weapon_on_connect
	Namespace: _gadget_hero_weapon
	Checksum: 0x99EC1590
	Offset: 0x5B0
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function gadget_hero_weapon_on_connect()
{
}

/*
	Name: gadget_hero_weapon_on_spawn
	Namespace: _gadget_hero_weapon
	Checksum: 0x99EC1590
	Offset: 0x5C0
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function gadget_hero_weapon_on_spawn()
{
}

/*
	Name: gadget_hero_weapon_on_activate
	Namespace: _gadget_hero_weapon
	Checksum: 0xABB89C15
	Offset: 0x5D0
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function gadget_hero_weapon_on_activate(slot, weapon)
{
	self.heroweaponkillcount = 0;
	self.heroweaponshots = 0;
	self.heroweaponhits = 0;
	if(!weapon.gadget_power_consume_on_ammo_use)
	{
		self hero_give_ammo(slot, weapon);
		self hero_handle_ammo_save(slot, weapon);
	}
}

/*
	Name: gadget_hero_weapon_on_off
	Namespace: _gadget_hero_weapon
	Checksum: 0x63FF5311
	Offset: 0x660
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function gadget_hero_weapon_on_off(slot, weapon)
{
	if(weapon.gadget_power_consume_on_ammo_use)
	{
		self setweaponammoclip(weapon, 0);
	}
}

/*
	Name: gadget_hero_weapon_ready
	Namespace: _gadget_hero_weapon
	Checksum: 0x5B045B9A
	Offset: 0x6B0
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function gadget_hero_weapon_ready(slot, weapon)
{
	if(weapon.gadget_power_consume_on_ammo_use)
	{
		hero_give_ammo(slot, weapon);
	}
}

/*
	Name: hero_give_ammo
	Namespace: _gadget_hero_weapon
	Checksum: 0xDAA9A4EF
	Offset: 0x700
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function hero_give_ammo(slot, weapon)
{
	self givemaxammo(weapon);
	self setweaponammoclip(weapon, weapon.clipsize);
}

/*
	Name: hero_handle_ammo_save
	Namespace: _gadget_hero_weapon
	Checksum: 0x48A25928
	Offset: 0x760
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function hero_handle_ammo_save(slot, weapon)
{
	self thread hero_wait_for_out_of_ammo(slot, weapon);
	self thread hero_wait_for_game_end(slot, weapon);
	self thread hero_wait_for_death(slot, weapon);
}

/*
	Name: hero_wait_for_game_end
	Namespace: _gadget_hero_weapon
	Checksum: 0xECE65A54
	Offset: 0x7E0
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function hero_wait_for_game_end(slot, weapon)
{
	self endon(#"disconnect");
	self notify(#"hero_ongameend");
	self endon(#"hero_ongameend");
	level waittill(#"game_ended");
	if(isalive(self))
	{
		self hero_save_ammo(slot, weapon);
	}
}

/*
	Name: hero_wait_for_death
	Namespace: _gadget_hero_weapon
	Checksum: 0xA86036A7
	Offset: 0x868
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function hero_wait_for_death(slot, weapon)
{
	self endon(#"disconnect");
	self notify(#"hero_ondeath");
	self endon(#"hero_ondeath");
	self waittill(#"death");
	self hero_save_ammo(slot, weapon);
}

/*
	Name: hero_save_ammo
	Namespace: _gadget_hero_weapon
	Checksum: 0xD369C5FB
	Offset: 0x8D8
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function hero_save_ammo(slot, weapon)
{
	self.pers["held_hero_weapon_ammo_count"][weapon] = self getammocount(weapon);
}

/*
	Name: hero_wait_for_out_of_ammo
	Namespace: _gadget_hero_weapon
	Checksum: 0xB33D04FA
	Offset: 0x928
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function hero_wait_for_out_of_ammo(slot, weapon)
{
	self endon(#"disconnect");
	self endon(#"death");
	self notify(#"hero_noammo");
	self endon(#"hero_noammo");
	while(true)
	{
		wait(0.1);
		n_ammo = self getammocount(weapon);
		if(n_ammo == 0)
		{
			break;
		}
	}
	self gadgetpowerreset(slot);
	self gadgetcharging(slot, 1);
}

/*
	Name: set_gadget_hero_weapon_status
	Namespace: _gadget_hero_weapon
	Checksum: 0x7E8D0856
	Offset: 0x9F8
	Size: 0xB4
	Parameters: 3
	Flags: None
*/
function set_gadget_hero_weapon_status(weapon, status, time)
{
	timestr = "";
	if(isdefined(time))
	{
		timestr = (("^3") + ", time: ") + time;
	}
	if(getdvarint("scr_cpower_debug_prints") > 0)
	{
		self iprintlnbold(((("Hero Weapon " + weapon.name) + ": ") + status) + timestr);
	}
}

