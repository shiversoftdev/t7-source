// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace satchel_charge;

/*
	Name: init_shared
	Namespace: satchel_charge
	Checksum: 0xB6AC2D4A
	Offset: 0x1B0
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function init_shared(localclientnum)
{
	level._effect["satchel_charge_enemy_light"] = "weapon/fx_c4_light_orng";
	level._effect["satchel_charge_friendly_light"] = "weapon/fx_c4_light_blue";
	callback::add_weapon_type("satchel_charge", &satchel_spawned);
}

/*
	Name: satchel_spawned
	Namespace: satchel_charge
	Checksum: 0x25A4DDE6
	Offset: 0x228
	Size: 0x8C
	Parameters: 1
	Flags: None
*/
function satchel_spawned(localclientnum)
{
	self endon(#"entityshutdown");
	if(self isgrenadedud())
	{
		return;
	}
	self.equipmentfriendfx = level._effect["satchel_charge_friendly_light"];
	self.equipmentenemyfx = level._effect["satchel_charge_enemy_light"];
	self.equipmenttagfx = "tag_origin";
	self thread weaponobjects::equipmentteamobject(localclientnum);
}

