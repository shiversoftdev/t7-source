// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace scoreboard;

/*
	Name: __init__sytem__
	Namespace: scoreboard
	Checksum: 0xF1B52ED3
	Offset: 0x130
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
	Checksum: 0xFEC1ECB7
	Offset: 0x170
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
	Checksum: 0xAC2E88AC
	Offset: 0x1A0
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function init()
{
	if(sessionmodeiszombiesgame())
	{
		setdvar("g_TeamIcon_Axis", "faction_cia");
		setdvar("g_TeamIcon_Allies", "faction_cdc");
	}
	else
	{
		setdvar("g_TeamIcon_Axis", game["icons"]["axis"]);
		setdvar("g_TeamIcon_Allies", game["icons"]["allies"]);
	}
}

