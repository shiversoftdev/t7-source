// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;

#namespace weapon_utils;

/*
	Name: getbaseweaponparam
	Namespace: weapon_utils
	Checksum: 0x865397E5
	Offset: 0x98
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function getbaseweaponparam(weapon)
{
	return (weapon.rootweapon.altweapon != level.weaponnone ? weapon.rootweapon.altweapon.rootweapon : weapon.rootweapon);
}

