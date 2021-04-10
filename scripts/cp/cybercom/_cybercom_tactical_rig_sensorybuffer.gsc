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

#namespace cybercom_tacrig_sensorybuffer;

/*
	Name: init
	Namespace: cybercom_tacrig_sensorybuffer
	Checksum: 0x99EC1590
	Offset: 0x298
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: main
	Namespace: cybercom_tacrig_sensorybuffer
	Checksum: 0x887217CD
	Offset: 0x2A8
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	cybercom_tacrig::register_cybercom_rig_ability("cybercom_sensorybuffer", 4);
	cybercom_tacrig::register_cybercom_rig_possession_callbacks("cybercom_sensorybuffer", &sensorybuffergive, &sensorybuffertake);
	cybercom_tacrig::register_cybercom_rig_activation_callbacks("cybercom_sensorybuffer", &sensorybufferactivate, &sensorybufferdeactivate);
}

/*
	Name: on_player_connect
	Namespace: cybercom_tacrig_sensorybuffer
	Checksum: 0x99EC1590
	Offset: 0x388
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
}

/*
	Name: on_player_spawned
	Namespace: cybercom_tacrig_sensorybuffer
	Checksum: 0x99EC1590
	Offset: 0x398
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
}

/*
	Name: sensorybuffergive
	Namespace: cybercom_tacrig_sensorybuffer
	Checksum: 0x46778232
	Offset: 0x3A8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function sensorybuffergive(type)
{
	self thread cybercom_tacrig::turn_rig_ability_on(type);
}

/*
	Name: sensorybuffertake
	Namespace: cybercom_tacrig_sensorybuffer
	Checksum: 0x7BD3152
	Offset: 0x3D8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function sensorybuffertake(type)
{
	self thread cybercom_tacrig::turn_rig_ability_off(type);
}

/*
	Name: sensorybufferactivate
	Namespace: cybercom_tacrig_sensorybuffer
	Checksum: 0xEE152609
	Offset: 0x408
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function sensorybufferactivate(type)
{
	self setperk("specialty_bulletflinch");
	self setperk("specialty_flashprotection");
	if(self hascybercomrig(type) == 2)
	{
		self setperk("specialty_flakjacket");
	}
}

/*
	Name: sensorybufferdeactivate
	Namespace: cybercom_tacrig_sensorybuffer
	Checksum: 0x2B53E040
	Offset: 0x4A0
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function sensorybufferdeactivate(type)
{
	self unsetperk("specialty_bulletflinch");
	self unsetperk("specialty_flashprotection");
	if(self hascybercomrig(type) == 2)
	{
		self unsetperk("specialty_flakjacket");
	}
}

