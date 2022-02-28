// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace scoreboard;

/*
	Name: __init__sytem__
	Namespace: scoreboard
	Checksum: 0xFBF33D4C
	Offset: 0xE8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("scoreboard", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: scoreboard
	Checksum: 0x918C5E48
	Offset: 0x128
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
	Namespace: scoreboard
	Checksum: 0xDF909AF1
	Offset: 0x158
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function init()
{
	if(sessionmodeiszombiesgame())
	{
	}
}

