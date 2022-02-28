// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\bots\bot_traversals;
#using scripts\shared\system_shared;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_actor;
#using scripts\zm\gametypes\_globallogic_player;
#using scripts\zm\gametypes\_globallogic_vehicle;
#using scripts\zm\gametypes\_hostmigration;

#namespace callback;

/*
	Name: __init__sytem__
	Namespace: callback
	Checksum: 0x8A9E0809
	Offset: 0x1E8
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
	Checksum: 0x9E4FDC6A
	Offset: 0x228
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level thread setup_callbacks();
}

/*
	Name: setup_callbacks
	Namespace: callback
	Checksum: 0xEECC2927
	Offset: 0x250
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function setup_callbacks()
{
	setdefaultcallbacks();
	level.idflags_noflag = 0;
	level.idflags_radius = 1;
	level.idflags_no_armor = 2;
	level.idflags_no_knockback = 4;
	level.idflags_penetration = 8;
	level.idflags_destructible_entity = 16;
	level.idflags_shield_explosive_impact = 32;
	level.idflags_shield_explosive_impact_huge = 64;
	level.idflags_shield_explosive_splash = 128;
	level.idflags_hurt_trigger_allow_laststand = 256;
	level.idflags_disable_ragdoll_skip = 512;
	level.idflags_no_team_protection = 1024;
	level.idflags_no_protection = 2048;
	level.idflags_passthru = 4096;
}

/*
	Name: setdefaultcallbacks
	Namespace: callback
	Checksum: 0x879E00A8
	Offset: 0x318
	Size: 0x1DC
	Parameters: 0
	Flags: Linked
*/
function setdefaultcallbacks()
{
	level.callbackstartgametype = &globallogic::callback_startgametype;
	level.callbackplayerconnect = &globallogic_player::callback_playerconnect;
	level.callbackplayerdisconnect = &globallogic_player::callback_playerdisconnect;
	level.callbackplayerdamage = &globallogic_player::callback_playerdamage;
	level.callbackplayerkilled = &globallogic_player::callback_playerkilled;
	level.callbackplayermelee = &globallogic_player::callback_playermelee;
	level.callbackplayerlaststand = &globallogic_player::callback_playerlaststand;
	level.callbackactordamage = &globallogic_actor::callback_actordamage;
	level.callbackactorspawned = &globallogic_actor::callback_actorspawned;
	level.callbackactorkilled = &globallogic_actor::callback_actorkilled;
	level.callbackactorcloned = &globallogic_actor::callback_actorcloned;
	level.callbackvehiclespawned = &globallogic_vehicle::callback_vehiclespawned;
	level.callbackvehicledamage = &globallogic_vehicle::callback_vehicledamage;
	level.callbackvehicleradiusdamage = &globallogic_vehicle::callback_vehicleradiusdamage;
	level.callbackplayermigrated = &globallogic_player::callback_playermigrated;
	level.callbackhostmigration = &hostmigration::callback_hostmigration;
	level.callbackhostmigrationsave = &hostmigration::callback_hostmigrationsave;
	level.callbackprehostmigrationsave = &hostmigration::callback_prehostmigrationsave;
	level.callbackbotentereduseredge = &bot::callback_botentereduseredge;
	level._gametype_default = "zclassic";
}

