// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_challenges;
#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_actor;
#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\gametypes\_globallogic_vehicle;
#using scripts\cp\gametypes\_hostmigration;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\audio_shared;
#using scripts\shared\bots\bot_traversals;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace callback;

/*
	Name: __init__sytem__
	Namespace: callback
	Checksum: 0xFC21A354
	Offset: 0x240
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("callback", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: callback
	Checksum: 0xFDD26222
	Offset: 0x280
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	set_default_callbacks();
}

/*
	Name: set_default_callbacks
	Namespace: callback
	Checksum: 0xB374937
	Offset: 0x2A0
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function set_default_callbacks()
{
	level.callbackstartgametype = &globallogic::callback_startgametype;
	level.callbackplayerconnect = &globallogic_player::callback_playerconnect;
	level.callbackplayerdisconnect = &globallogic_player::callback_playerdisconnect;
	level.callbackplayerdamage = &globallogic_player::callback_playerdamage;
	level.callbackplayerkilled = &globallogic_player::callback_playerkilled;
	level.callbackplayermelee = &globallogic_player::callback_playermelee;
	level.callbackplayerlaststand = &globallogic_player::callback_playerlaststand;
	level.callbackactorspawned = &globallogic_actor::callback_actorspawned;
	level.callbackactordamage = &globallogic_actor::callback_actordamage;
	level.callbackactorkilled = &globallogic_actor::callback_actorkilled;
	level.callbackactorcloned = &globallogic_actor::callback_actorcloned;
	level.callbackvehiclespawned = &globallogic_vehicle::callback_vehiclespawned;
	level.callbackvehicledamage = &globallogic_vehicle::callback_vehicledamage;
	level.callbackvehiclekilled = &globallogic_vehicle::callback_vehiclekilled;
	level.callbackvehicleradiusdamage = &globallogic_vehicle::callback_vehicleradiusdamage;
	level.callbackplayermigrated = &globallogic_player::callback_playermigrated;
	level.callbackhostmigration = &hostmigration::callback_hostmigration;
	level.callbackhostmigrationsave = &hostmigration::callback_hostmigrationsave;
	level.callbackprehostmigrationsave = &hostmigration::callback_prehostmigrationsave;
	level.callbackbotentereduseredge = &bot::callback_botentereduseredge;
	level.callbackdecorationawarded = &challenges::function_85ec34dc;
	level._gametype_default = "coop";
}

