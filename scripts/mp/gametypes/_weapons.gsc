// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_challenges;
#using scripts\mp\_scoreevents;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\gametypes\_shellshock;
#using scripts\mp\gametypes\_weapon_utils;
#using scripts\mp\gametypes\_weaponobjects;
#using scripts\mp\killstreaks\_dogs;
#using scripts\mp\killstreaks\_killstreak_weapons;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_supplydrop;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;
#using scripts\shared\weapons_shared;

#namespace weapons;

/*
	Name: __init__sytem__
	Namespace: weapons
	Checksum: 0x6ACEAD72
	Offset: 0x3A0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("weapons", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: weapons
	Checksum: 0x8E70BB25
	Offset: 0x3E0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

/*
	Name: bestweapon_kill
	Namespace: weapons
	Checksum: 0x7736F1DF
	Offset: 0x400
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function bestweapon_kill(weapon)
{
}

/*
	Name: bestweapon_spawn
	Namespace: weapons
	Checksum: 0x6D3A70D9
	Offset: 0x418
	Size: 0x1C
	Parameters: 3
	Flags: Linked
*/
function bestweapon_spawn(weapon, options, acvi)
{
}

/*
	Name: bestweapon_init
	Namespace: weapons
	Checksum: 0x1D0DC094
	Offset: 0x440
	Size: 0xE6
	Parameters: 3
	Flags: None
*/
function bestweapon_init(weapon, options, acvi)
{
	weapon_data = [];
	weapon_data["weapon"] = weapon;
	weapon_data["options"] = options;
	weapon_data["acvi"] = acvi;
	weapon_data["kill_count"] = 0;
	weapon_data["spawned_with"] = 0;
	key = self.pers["bestWeapon"][weapon.name].size;
	self.pers["bestWeapon"][weapon.name][key] = weapon_data;
	return key;
}

/*
	Name: bestweapon_find
	Namespace: weapons
	Checksum: 0xFBD35E31
	Offset: 0x530
	Size: 0x192
	Parameters: 3
	Flags: None
*/
function bestweapon_find(weapon, options, acvi)
{
	if(!isdefined(self.pers["bestWeapon"]))
	{
		self.pers["bestWeapon"] = [];
	}
	if(!isdefined(self.pers["bestWeapon"][weapon.name]))
	{
		self.pers["bestWeapon"][weapon.name] = [];
	}
	name = weapon.name;
	size = self.pers["bestWeapon"][name].size;
	for(index = 0; index < size; index++)
	{
		if(self.pers["bestWeapon"][name][index]["weapon"] == weapon && self.pers["bestWeapon"][name][index]["options"] == options && self.pers["bestWeapon"][name][index]["acvi"] == acvi)
		{
			return index;
		}
	}
	return undefined;
}

/*
	Name: bestweapon_get
	Namespace: weapons
	Checksum: 0xDCC9FE36
	Offset: 0x6D0
	Size: 0x224
	Parameters: 0
	Flags: None
*/
function bestweapon_get()
{
	most_kills = 0;
	most_spawns = 0;
	if(!isdefined(self.pers["bestWeapon"]))
	{
		return;
	}
	best_key = 0;
	best_index = 0;
	weapon_keys = getarraykeys(self.pers["bestWeapon"]);
	for(key_index = 0; key_index < weapon_keys.size; key_index++)
	{
		key = weapon_keys[key_index];
		size = self.pers["bestWeapon"][key].size;
		for(index = 0; index < size; index++)
		{
			kill_count = self.pers["bestWeapon"][key][index]["kill_count"];
			spawned_with = self.pers["bestWeapon"][key][index]["spawned_with"];
			if(kill_count > most_kills)
			{
				best_index = index;
				best_key = key;
				most_kills = kill_count;
				most_spawns = spawned_with;
				continue;
			}
			if(kill_count == most_kills && spawned_with > most_spawns)
			{
				best_index = index;
				best_key = key;
				most_kills = kill_count;
				most_spawns = spawned_with;
			}
		}
	}
	return self.pers["bestWeapon"][best_key][best_index];
}

/*
	Name: showcaseweapon_get
	Namespace: weapons
	Checksum: 0xD2203524
	Offset: 0x900
	Size: 0x38E
	Parameters: 0
	Flags: Linked
*/
function showcaseweapon_get()
{
	showcaseweapondata = self getplayershowcaseweapon();
	if(!isdefined(showcaseweapondata))
	{
		return undefined;
	}
	showcase_weapon = [];
	showcase_weapon["weapon"] = showcaseweapondata.weapon;
	attachmentnames = [];
	attachmentindices = [];
	tokenizedattachmentinfo = strtok(showcaseweapondata.attachmentinfo, ",");
	index = 0;
	while((index + 1) < tokenizedattachmentinfo.size)
	{
		attachmentnames[attachmentnames.size] = tokenizedattachmentinfo[index];
		attachmentindices[attachmentindices.size] = int(tokenizedattachmentinfo[index + 1]);
		index = index + 2;
	}
	index = tokenizedattachmentinfo.size;
	while((index + 1) < 16)
	{
		attachmentnames[attachmentnames.size] = "none";
		attachmentindices[attachmentindices.size] = 0;
		index = index + 2;
	}
	showcase_weapon["acvi"] = getattachmentcosmeticvariantindexes(showcaseweapondata.weapon, attachmentnames[0], attachmentindices[0], attachmentnames[1], attachmentindices[1], attachmentnames[2], attachmentindices[2], attachmentnames[3], attachmentindices[3], attachmentnames[4], attachmentindices[4], attachmentnames[5], attachmentindices[5], attachmentnames[6], attachmentindices[6], attachmentnames[7], attachmentindices[7]);
	camoindex = 0;
	paintjobslot = 15;
	paintjobindex = 15;
	showpaintshop = 0;
	tokenizedweaponrenderoptions = strtok(showcaseweapondata.weaponrenderoptions, ",");
	if(tokenizedweaponrenderoptions.size > 2)
	{
		camoindex = int(tokenizedweaponrenderoptions[0]);
		paintjobslot = int(tokenizedweaponrenderoptions[1]);
		paintjobindex = int(tokenizedweaponrenderoptions[2]);
		showpaintshop = paintjobslot != 15 && paintjobindex != 15;
	}
	showcase_weapon["options"] = self calcweaponoptions(camoindex, 0, 0, 0, 0, showpaintshop, 1);
	return showcase_weapon;
}

