// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\teams\_teamset;

#namespace _teamset_allies;

/*
	Name: main
	Namespace: _teamset_allies
	Checksum: 0x5DC4FF5C
	Offset: 0x2F8
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	init("free");
	foreach(team in level.teams)
	{
		if(team == "axis")
		{
			continue;
		}
		init(team);
	}
	_teamset::customteam_init();
	precache();
}

/*
	Name: init
	Namespace: _teamset_allies
	Checksum: 0x9B5C461F
	Offset: 0x3E0
	Size: 0x30A
	Parameters: 1
	Flags: Linked
*/
function init(team)
{
	_teamset::init();
	game[team] = "allies";
	game["attackers"] = team;
	game["entity_headicon_" + team] = "faction_allies";
	game["headicon_" + team] = "faction_allies";
	level.teamprefix[team] = "vox_st";
	level.teampostfix[team] = "st6";
	setdvar("g_TeamName_" + team, &"MPUI_ALLIES_SHORT");
	setdvar("g_FactionName_" + team, "allies");
	game["strings"][team + "_win"] = &"MP_BLACK_OPS_WIN_MATCH";
	game["strings"][team + "_win_round"] = &"MP_BLACK_OPS_WIN_ROUND";
	game["strings"][team + "_mission_accomplished"] = &"MP_BLACK_OPS_MISSION_ACCOMPLISHED";
	game["strings"][team + "_eliminated"] = &"MP_BLACK_OPS_ELIMINATED";
	game["strings"][team + "_forfeited"] = &"MP_BLACK_OPS_FORFEITED";
	game["strings"][team + "_name"] = &"MP_BLACK_OPS_NAME";
	game["music"]["spawn_" + team] = "SPAWN_ST6";
	game["music"]["spawn_short" + team] = "SPAWN_SHORT_ST6";
	game["music"]["victory_" + team] = "VICTORY_ST6";
	game["icons"][team] = "faction_allies";
	game["voice"][team] = "vox_st6_";
	setdvar("scr_" + team, "marines");
	level.heli_vo[team]["hit"] = "vox_ops_2_kls_attackheli_hit";
	game["flagmodels"][team] = "p7_mp_flag_allies";
	game["carry_flagmodels"][team] = "p7_mp_flag_allies_carry";
	game["flagmodels"]["neutral"] = "p7_mp_flag_neutral";
}

/*
	Name: precache
	Namespace: _teamset_allies
	Checksum: 0x99EC1590
	Offset: 0x6F8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache()
{
}

