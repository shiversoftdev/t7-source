// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace cybercom_tacrig_multicore;

/*
	Name: init
	Namespace: cybercom_tacrig_multicore
	Checksum: 0x99EC1590
	Offset: 0x248
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: main
	Namespace: cybercom_tacrig_multicore
	Checksum: 0xAB333CE6
	Offset: 0x258
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	cybercom_tacrig::register_cybercom_rig_ability("cybercom_multicore", 7);
	cybercom_tacrig::register_cybercom_rig_possession_callbacks("cybercom_multicore", &multicoregive, &multicoretake);
}

/*
	Name: on_player_connect
	Namespace: cybercom_tacrig_multicore
	Checksum: 0x99EC1590
	Offset: 0x300
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
}

/*
	Name: on_player_spawned
	Namespace: cybercom_tacrig_multicore
	Checksum: 0x99EC1590
	Offset: 0x310
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
}

/*
	Name: multicoregive
	Namespace: cybercom_tacrig_multicore
	Checksum: 0x278A6CC2
	Offset: 0x320
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function multicoregive(type)
{
	self thread cybercom_tacrig::turn_rig_ability_on(type);
}

/*
	Name: multicoretake
	Namespace: cybercom_tacrig_multicore
	Checksum: 0xCD4DF2BA
	Offset: 0x350
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function multicoretake(type)
{
	self thread cybercom_tacrig::turn_rig_ability_off(type);
}

