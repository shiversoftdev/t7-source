// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\mp_sector_fx;
#using scripts\mp\mp_sector_sound;
#using scripts\shared\util_shared;

#namespace mp_sector;

/*
	Name: main
	Namespace: mp_sector
	Checksum: 0x48D2DFE5
	Offset: 0x260
	Size: 0x2AC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	hour_hand = getentarray(0, "hour_hand", "targetname");
	minute_hand = getentarray(0, "minute_hand", "targetname");
	second_hand = getentarray(0, "second_hand", "targetname");
	foreach(hand in hour_hand)
	{
		hand.targetname = "second_hand";
	}
	foreach(hand in minute_hand)
	{
		hand.targetname = "hour_hand";
	}
	foreach(hand in second_hand)
	{
		hand.targetname = "minute_hand";
	}
	mp_sector_fx::main();
	mp_sector_sound::main();
	level.disablefxaniminsplitscreencount = 3;
	load::main();
	level.domflagbasefxoverride = &dom_flag_base_fx_override;
	level.domflagcapfxoverride = &dom_flag_cap_fx_override;
	util::waitforclient(0);
	level.endgamexcamname = "ui_cam_endgame_mp_sector";
}

/*
	Name: dom_flag_base_fx_override
	Namespace: mp_sector
	Checksum: 0x278AF17B
	Offset: 0x518
	Size: 0x9E
	Parameters: 2
	Flags: Linked
*/
function dom_flag_base_fx_override(flag, team)
{
	switch(flag.name)
	{
		case "a":
		{
			break;
		}
		case "b":
		{
			if(team == "neutral")
			{
				return "ui/fx_dom_marker_neutral_r90";
			}
			else
			{
				return "ui/fx_dom_marker_team_r90";
			}
			break;
		}
		case "c":
		{
			if(team == "neutral")
			{
				return "ui/fx_dom_marker_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_marker_team_r120";
			}
			break;
		}
	}
}

/*
	Name: dom_flag_cap_fx_override
	Namespace: mp_sector
	Checksum: 0x1DBB70C9
	Offset: 0x5C0
	Size: 0x9E
	Parameters: 2
	Flags: Linked
*/
function dom_flag_cap_fx_override(flag, team)
{
	switch(flag.name)
	{
		case "a":
		{
			break;
		}
		case "b":
		{
			if(team == "neutral")
			{
				return "ui/fx_dom_cap_indicator_neutral_r90";
			}
			else
			{
				return "ui/fx_dom_cap_indicator_team_r90";
			}
			break;
		}
		case "c":
		{
			if(team == "neutral")
			{
				return "ui/fx_dom_cap_indicator_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_cap_indicator_team_r120";
			}
			break;
		}
	}
}

