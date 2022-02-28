// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace scoreboard;

/*
	Name: __init__sytem__
	Namespace: scoreboard
	Checksum: 0x3E9D66A0
	Offset: 0x210
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
	Checksum: 0xD9487392
	Offset: 0x250
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&main);
}

/*
	Name: main
	Namespace: scoreboard
	Checksum: 0x47A2E9CC
	Offset: 0x280
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function main()
{
	setdvar("g_ScoresColor_Spectator", ".25 .25 .25");
	setdvar("g_ScoresColor_Free", ".76 .78 .10");
	setdvar("g_teamColor_MyTeam", ".4 .7 .4");
	setdvar("g_teamColor_EnemyTeam", "1 .315 0.35");
	setdvar("g_teamColor_MyTeamAlt", ".35 1 1");
	setdvar("g_teamColor_EnemyTeamAlt", "1 .5 0");
	setdvar("g_teamColor_Squad", ".315 0.35 1");
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

