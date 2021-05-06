// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
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

#namespace namespace_328b6406;

/*
	Name: init
	Namespace: namespace_328b6406
	Checksum: 0x99EC1590
	Offset: 0x340
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: main
	Namespace: namespace_328b6406
	Checksum: 0xE0DCC19C
	Offset: 0x350
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function main()
{
	cybercom_gadget::registerability(1, 64);
	callback::on_spawned(&on_player_spawned);
	level.cybercom.rapid_strike = spawnstruct();
	level.cybercom.rapid_strike._is_flickering = &_is_flickering;
	level.cybercom.rapid_strike._on_flicker = &_on_flicker;
	level.cybercom.rapid_strike._on_give = &_on_give;
	level.cybercom.rapid_strike._on_take = &_on_take;
	level.cybercom.rapid_strike._on_connect = &_on_connect;
	level.cybercom.rapid_strike._on = &_on;
	level.cybercom.rapid_strike._off = &_off;
}

/*
	Name: on_player_spawned
	Namespace: namespace_328b6406
	Checksum: 0x99EC1590
	Offset: 0x4D0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
}

/*
	Name: _is_flickering
	Namespace: namespace_328b6406
	Checksum: 0x847BB4E8
	Offset: 0x4E0
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function _is_flickering(slot)
{
}

/*
	Name: _on_flicker
	Namespace: namespace_328b6406
	Checksum: 0x3A188EF5
	Offset: 0x4F8
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_flicker(slot, weapon)
{
}

/*
	Name: _on_give
	Namespace: namespace_328b6406
	Checksum: 0xF5FFACC3
	Offset: 0x518
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
	Namespace: namespace_328b6406
	Checksum: 0x46483F67
	Offset: 0x550
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
	Namespace: namespace_328b6406
	Checksum: 0x99EC1590
	Offset: 0x580
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _on_connect()
{
}

/*
	Name: _on
	Namespace: namespace_328b6406
	Checksum: 0x833DF0B
	Offset: 0x590
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on(slot, weapon)
{
}

/*
	Name: _off
	Namespace: namespace_328b6406
	Checksum: 0x7E5E915C
	Offset: 0x5B0
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _off(slot, weapon)
{
}

/*
	Name: function_677ed44f
	Namespace: namespace_328b6406
	Checksum: 0x5E0D018A
	Offset: 0x5D0
	Size: 0x190
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
		level waittill(#"rapid_strike", target, attacker, damage, weapon, hitorigin);
		self notify(weapon.name + "_fired");
		level notify(weapon.name + "_fired");
		wait(0.05);
		if(isplayer(self))
		{
			itemindex = getitemindexfromref("cybercom_rapidstrike");
			if(isdefined(itemindex))
			{
				self adddstat("ItemStats", itemindex, "stats", "kills", "statValue", 1);
				self adddstat("ItemStats", itemindex, "stats", "used", "statValue", 1);
			}
		}
	}
}

