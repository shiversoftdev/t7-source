// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\mp_havoc_fx;
#using scripts\mp\mp_havoc_sound;
#using scripts\shared\util_shared;

#namespace mp_havoc;

/*
	Name: main
	Namespace: mp_havoc
	Checksum: 0xAEE7CCC6
	Offset: 0x1D8
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	mp_havoc_fx::main();
	mp_havoc_sound::main();
	load::main();
	level.domflagbasefxoverride = &dom_flag_base_fx_override;
	level.domflagcapfxoverride = &dom_flag_cap_fx_override;
	setdvar("phys_buoyancy", 1);
	setdvar("phys_ragdoll_buoyancy", 1);
	util::waitforclient(0);
	level.endgamexcamname = "ui_cam_endgame_mp_havoc";
}

/*
	Name: dom_flag_base_fx_override
	Namespace: mp_havoc
	Checksum: 0x73D45F78
	Offset: 0x2B0
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
		case "b":
		{
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
	Namespace: mp_havoc
	Checksum: 0xA6735B8F
	Offset: 0x358
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
		case "b":
		{
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

