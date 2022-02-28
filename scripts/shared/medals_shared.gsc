// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace medals;

/*
	Name: __init__sytem__
	Namespace: medals
	Checksum: 0xA3EC32E4
	Offset: 0xF0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("medals", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: medals
	Checksum: 0xEA18E637
	Offset: 0x130
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: medals
	Checksum: 0xEF5E30A3
	Offset: 0x160
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.medalinfo = [];
	level.medalcallbacks = [];
	level.numkills = 0;
	callback::on_connect(&on_player_connect);
}

/*
	Name: on_player_connect
	Namespace: medals
	Checksum: 0x49CB5FB7
	Offset: 0x1B8
	Size: 0xE
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self.lastkilledby = undefined;
}

/*
	Name: setlastkilledby
	Namespace: medals
	Checksum: 0xEDD6078F
	Offset: 0x1D0
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function setlastkilledby(attacker)
{
	self.lastkilledby = attacker;
}

/*
	Name: offenseglobalcount
	Namespace: medals
	Checksum: 0x58D37075
	Offset: 0x1F0
	Size: 0xC
	Parameters: 0
	Flags: None
*/
function offenseglobalcount()
{
	level.globalteammedals++;
}

/*
	Name: defenseglobalcount
	Namespace: medals
	Checksum: 0x136DD30F
	Offset: 0x208
	Size: 0xC
	Parameters: 0
	Flags: None
*/
function defenseglobalcount()
{
	level.globalteammedals++;
}

/*
	Name: codecallback_medal
	Namespace: medals
	Checksum: 0x55D469D2
	Offset: 0x220
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function codecallback_medal(medalindex)
{
	self luinotifyevent(&"medal_received", 1, medalindex);
	self luinotifyeventtospectators(&"medal_received", 1, medalindex);
}

