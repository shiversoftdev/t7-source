// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;

#namespace weapon_utils;

/*
	Name: ispistol
	Namespace: weapon_utils
	Checksum: 0x180C1CF2
	Offset: 0x108
	Size: 0x1A
	Parameters: 1
	Flags: None
*/
function ispistol(weapon)
{
	return isdefined(level.side_arm_array[weapon]);
}

/*
	Name: isflashorstunweapon
	Namespace: weapon_utils
	Checksum: 0x85DF2E2F
	Offset: 0x130
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function isflashorstunweapon(weapon)
{
	return weapon.isflash || weapon.isstun;
}

/*
	Name: isflashorstundamage
	Namespace: weapon_utils
	Checksum: 0xFC3F9FA0
	Offset: 0x168
	Size: 0x4C
	Parameters: 2
	Flags: None
*/
function isflashorstundamage(weapon, meansofdeath)
{
	return isflashorstunweapon(weapon) && (meansofdeath == "MOD_GRENADE_SPLASH" || meansofdeath == "MOD_GAS");
}

/*
	Name: ismeleemod
	Namespace: weapon_utils
	Checksum: 0x973E275C
	Offset: 0x1C0
	Size: 0x38
	Parameters: 1
	Flags: None
*/
function ismeleemod(mod)
{
	return mod == "MOD_MELEE" || mod == "MOD_MELEE_WEAPON_BUTT" || mod == "MOD_MELEE_ASSASSINATE";
}

/*
	Name: ispunch
	Namespace: weapon_utils
	Checksum: 0xF47D39A2
	Offset: 0x200
	Size: 0x48
	Parameters: 1
	Flags: None
*/
function ispunch(weapon)
{
	return weapon.type == "melee" && weapon.rootweapon.name == "bare_hands";
}

/*
	Name: isknife
	Namespace: weapon_utils
	Checksum: 0x2C58E787
	Offset: 0x250
	Size: 0x48
	Parameters: 1
	Flags: None
*/
function isknife(weapon)
{
	return weapon.type == "melee" && weapon.rootweapon.name == "knife_loadout";
}

/*
	Name: isnonbarehandsmelee
	Namespace: weapon_utils
	Checksum: 0xF7F9B479
	Offset: 0x2A0
	Size: 0x5A
	Parameters: 1
	Flags: None
*/
function isnonbarehandsmelee(weapon)
{
	return weapon.type == "melee" && weapon.rootweapon.name != "bare_hands" || weapon.isballisticknife;
}

