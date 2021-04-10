// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\cybercom\_cybercom_tactical_rig_proximitydeterrent;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\_save;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace cybercom_tacrig_emergencyreserve;

/*
	Name: init
	Namespace: cybercom_tacrig_emergencyreserve
	Checksum: 0x99EC1590
	Offset: 0x3B0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: main
	Namespace: cybercom_tacrig_emergencyreserve
	Checksum: 0x7CDE4F48
	Offset: 0x3C0
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function main()
{
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	setdvar("scr_emergency_reserve_timer", 5);
	setdvar("scr_emergency_reserve_timer_upgraded", 8);
	cybercom_tacrig::register_cybercom_rig_ability("cybercom_emergencyreserve", 3);
	cybercom_tacrig::register_cybercom_rig_possession_callbacks("cybercom_emergencyreserve", &emergencyreservegive, &emergencyreservetake);
	cybercom_tacrig::register_cybercom_rig_activation_callbacks("cybercom_emergencyreserve", &emergencyreserveactivate, &emergencyreservedeactivate);
}

/*
	Name: on_player_connect
	Namespace: cybercom_tacrig_emergencyreserve
	Checksum: 0x99EC1590
	Offset: 0x4E0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
}

/*
	Name: on_player_spawned
	Namespace: cybercom_tacrig_emergencyreserve
	Checksum: 0x99EC1590
	Offset: 0x4F0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
}

/*
	Name: emergencyreservegive
	Namespace: cybercom_tacrig_emergencyreserve
	Checksum: 0xF0F22155
	Offset: 0x500
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function emergencyreservegive(type)
{
	self.lives = self savegame::get_player_data("lives", 1);
	self clientfield::set_to_player("sndTacRig", 1);
}

/*
	Name: emergencyreservetake
	Namespace: cybercom_tacrig_emergencyreserve
	Checksum: 0x788928AB
	Offset: 0x560
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function emergencyreservetake(type)
{
	self.lives = 0;
	self clientfield::set_to_player("sndTacRig", 0);
}

/*
	Name: emergencyreserveactivate
	Namespace: cybercom_tacrig_emergencyreserve
	Checksum: 0x896EA942
	Offset: 0x5A0
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function emergencyreserveactivate(type)
{
	if(self.lives < 1)
	{
		return;
	}
	if(self hascybercomrig("cybercom_emergencyreserve") == 2)
	{
		level thread cybercom_tacrig_proximitydeterrent::function_c0ba5acc(self);
	}
	self cybercom_tacrig::turn_rig_ability_off("cybercom_emergencyreserve");
	self playlocalsound("gdt_cybercore_regen_godown");
	playfx("player/fx_plyr_ability_emergency_reserve_1p", self.origin);
}

/*
	Name: emergencyreservedeactivate
	Namespace: cybercom_tacrig_emergencyreserve
	Checksum: 0xE9EEE012
	Offset: 0x668
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function emergencyreservedeactivate(type)
{
}

/*
	Name: validdeathtypesforemergencyreserve
	Namespace: cybercom_tacrig_emergencyreserve
	Checksum: 0xE549A3DA
	Offset: 0x680
	Size: 0xA8
	Parameters: 1
	Flags: Linked
*/
function validdeathtypesforemergencyreserve(smeansofdeath)
{
	if(isdefined(smeansofdeath))
	{
		return issubstr(smeansofdeath, "_BULLET") || issubstr(smeansofdeath, "_GRENADE") || issubstr(smeansofdeath, "_MELEE") || smeansofdeath == "MOD_EXPLOSIVE" || smeansofdeath == "MOD_SUICIDE" || smeansofdeath == "MOD_HEAD_SHOT";
	}
	return 0;
}

