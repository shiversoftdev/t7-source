// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\mp_spire_amb;
#using scripts\mp\mp_spire_fx;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\util_shared;

#namespace mp_spire;

/*
	Name: main
	Namespace: mp_spire
	Checksum: 0xD0FDF145
	Offset: 0x228
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function main()
{
	clientfield::register("world", "mpSpireExteriorBillboard", 1, 2, "int", &exteriorbillboard, 1, 1);
	level.disablefxaniminsplitscreencount = 3;
	load::main();
	level.domflagbasefxoverride = &dom_flag_base_fx_override;
	level.domflagcapfxoverride = &dom_flag_cap_fx_override;
	mp_spire_fx::main();
	thread mp_spire_amb::main();
	util::waitforclient(0);
	level.endgamexcamname = "ui_cam_endgame_mp_spire";
	/#
		println("");
	#/
}

/*
	Name: exteriorbillboard
	Namespace: mp_spire
	Checksum: 0x6ADAD077
	Offset: 0x338
	Size: 0x3C
	Parameters: 7
	Flags: Linked
*/
function exteriorbillboard(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
}

/*
	Name: dom_flag_base_fx_override
	Namespace: mp_spire
	Checksum: 0x38B39FC1
	Offset: 0x380
	Size: 0xC2
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
	Namespace: mp_spire
	Checksum: 0x75E2BB46
	Offset: 0x450
	Size: 0xC2
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

