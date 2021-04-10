// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\teams\_teamset;

#namespace _teamset_axis;

/*
	Name: main
	Namespace: _teamset_axis
	Checksum: 0xD26A60AE
	Offset: 0x2B8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	init("axis");
	_teamset::customteam_init();
	precache();
}

/*
	Name: init
	Namespace: _teamset_axis
	Checksum: 0xB0E82F6A
	Offset: 0x300
	Size: 0x30A
	Parameters: 1
	Flags: Linked
*/
function init(team)
{
	_teamset::init();
	game[team] = "axis";
	game["defenders"] = team;
	game["entity_headicon_" + team] = "faction_axis";
	game["headicon_" + team] = "faction_axis";
	level.teamprefix[team] = "vox_pm";
	level.teampostfix[team] = "axis";
	setdvar("g_TeamName_" + team, &"MPUI_AXIS_SHORT");
	setdvar("g_FactionName_" + team, "axis");
	game["strings"][team + "_win"] = &"MP_CDP_WIN_MATCH";
	game["strings"][team + "_win_round"] = &"MP_CDP_WIN_ROUND";
	game["strings"][team + "_mission_accomplished"] = &"MP_CDP_MISSION_ACCOMPLISHED";
	game["strings"][team + "_eliminated"] = &"MP_CDP_ELIMINATED";
	game["strings"][team + "_forfeited"] = &"MP_CDP_FORFEITED";
	game["strings"][team + "_name"] = &"MP_CDP_NAME";
	game["music"]["spawn_" + team] = "SPAWN_PMC";
	game["music"]["spawn_short" + team] = "SPAWN_SHORT_PMC";
	game["music"]["victory_" + team] = "VICTORY_PMC";
	game["icons"][team] = "faction_axis";
	game["voice"][team] = "vox_pmc_";
	setdvar("scr_" + team, "ussr");
	level.heli_vo[team]["hit"] = "vox_rus_0_kls_attackheli_hit";
	game["flagmodels"][team] = "p7_mp_flag_axis";
	game["carry_flagmodels"][team] = "p7_mp_flag_axis_carry";
	game["flagmodels"]["neutral"] = "p7_mp_flag_neutral";
}

/*
	Name: precache
	Namespace: _teamset_axis
	Checksum: 0x99EC1590
	Offset: 0x618
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache()
{
}

