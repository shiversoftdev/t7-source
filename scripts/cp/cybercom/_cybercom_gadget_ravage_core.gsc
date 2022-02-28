// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_challenges;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_gadget_system_overload;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_9cc756f9;

/*
	Name: init
	Namespace: namespace_9cc756f9
	Checksum: 0x99EC1590
	Offset: 0x418
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: main
	Namespace: namespace_9cc756f9
	Checksum: 0x4EAB8102
	Offset: 0x428
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	cybercom_gadget::registerability(0, 16);
	level.cybercom.ravage_core = spawnstruct();
	level.cybercom.ravage_core._is_flickering = &_is_flickering;
	level.cybercom.ravage_core._on_flicker = &_on_flicker;
	level.cybercom.ravage_core._on_give = &_on_give;
	level.cybercom.ravage_core._on_take = &_on_take;
	level.cybercom.ravage_core._on_connect = &_on_connect;
	level.cybercom.ravage_core._on = &_on;
	level.cybercom.ravage_core._off = &_off;
	level.cybercom.ravage_core.weapon = getweapon("gadget_ravage_core");
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: namespace_9cc756f9
	Checksum: 0x99EC1590
	Offset: 0x5D8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
}

/*
	Name: _is_flickering
	Namespace: namespace_9cc756f9
	Checksum: 0x7251EF06
	Offset: 0x5E8
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function _is_flickering(slot)
{
}

/*
	Name: _on_flicker
	Namespace: namespace_9cc756f9
	Checksum: 0x3DD06780
	Offset: 0x600
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_flicker(slot, weapon)
{
}

/*
	Name: _on_give
	Namespace: namespace_9cc756f9
	Checksum: 0x2A23B567
	Offset: 0x620
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function _on_give(slot, weapon)
{
	self thread function_677ed44f(weapon);
}

/*
	Name: _on_take
	Namespace: namespace_9cc756f9
	Checksum: 0x8DF9590C
	Offset: 0x658
	Size: 0x22
	Parameters: 2
	Flags: Linked
*/
function _on_take(slot, weapon)
{
	self notify(#"hash_343d4580");
}

/*
	Name: _on_connect
	Namespace: namespace_9cc756f9
	Checksum: 0x99EC1590
	Offset: 0x688
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _on_connect()
{
}

/*
	Name: _on
	Namespace: namespace_9cc756f9
	Checksum: 0x72F03944
	Offset: 0x698
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on(slot, weapon)
{
}

/*
	Name: _off
	Namespace: namespace_9cc756f9
	Checksum: 0xB6821936
	Offset: 0x6B8
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _off(slot, weapon)
{
}

/*
	Name: function_677ed44f
	Namespace: namespace_9cc756f9
	Checksum: 0xD6E69F2B
	Offset: 0x6D8
	Size: 0x24A
	Parameters: 1
	Flags: Linked
*/
function function_677ed44f(weapon)
{
	self notify(#"hash_677ed44f");
	self endon(#"hash_677ed44f");
	self endon(#"hash_343d4580");
	self endon(#"disconnect");
	while(true)
	{
		level waittill(#"ravage_core", target, attacker, damage, weapon, hitorigin);
		self notify(#"ravage_core", target, damage, weapon);
		destructserverutils::destructhitlocpieces(target, "torso_upper");
		self notify(weapon.name + "_fired");
		level notify(weapon.name + "_fired");
		target hidepart("j_chest_door");
		target thread _corpsewatcher();
		target ai::set_behavior_attribute("robot_lights", 1);
		attacker thread challenges::function_96ed590f("cybercom_uses_control");
		if(isplayer(self))
		{
			itemindex = getitemindexfromref("cybercom_ravagecore");
			if(isdefined(itemindex))
			{
				self adddstat("ItemStats", itemindex, "stats", "kills", "statValue", 1);
				self adddstat("ItemStats", itemindex, "stats", "used", "statValue", 1);
			}
		}
		self waittill(#"grenade_fire");
		self notify(#"hash_65afc94f");
	}
}

/*
	Name: _corpsewatcher
	Namespace: namespace_9cc756f9
	Checksum: 0xB50B5C32
	Offset: 0x930
	Size: 0x44
	Parameters: 0
	Flags: Linked, Private
*/
function private _corpsewatcher()
{
	self waittill(#"actor_corpse", corpse);
	if(isdefined(corpse))
	{
		corpse hidepart("j_chest_door");
	}
}

