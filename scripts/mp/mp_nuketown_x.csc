// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\mp_nuketown_x_fx;
#using scripts\mp\mp_nuketown_x_sound;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#namespace mp_nuketown_x;

/*
	Name: main
	Namespace: mp_nuketown_x
	Checksum: 0x9D9744A4
	Offset: 0x250
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function main()
{
	clientfield::register("scriptmover", "nuketown_population_ones", 1, 4, "int", &function_a3fc1001, 0, 0);
	clientfield::register("scriptmover", "nuketown_population_tens", 1, 4, "int", &function_a3fc1001, 0, 0);
	clientfield::register("world", "nuketown_endgame", 1, 1, "int", &function_db2629eb, 0, 0);
	namespace_6044bb60::main();
	namespace_4cda09f7::main();
	load::main();
	level.domflagbasefxoverride = &dom_flag_base_fx_override;
	level.domflagcapfxoverride = &dom_flag_cap_fx_override;
	util::waitforclient(0);
	level.endgamexcamname = "ui_cam_endgame_mp_nuketown";
}

/*
	Name: function_db2629eb
	Namespace: mp_nuketown_x
	Checksum: 0x81ECE742
	Offset: 0x3C0
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function function_db2629eb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	/#
		if(newval)
		{
			setdvar("", 0);
			setdvar("", 10.64);
		}
		else
		{
			setdvar("", 1);
		}
	#/
}

/*
	Name: function_a3fc1001
	Namespace: mp_nuketown_x
	Checksum: 0x1198DB0D
	Offset: 0x470
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_a3fc1001(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self mapshaderconstant(localclientnum, 0, "scriptVector0", newval, 0, 0, 0);
}

/*
	Name: dom_flag_base_fx_override
	Namespace: mp_nuketown_x
	Checksum: 0x332A9C1
	Offset: 0x4E0
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
	Namespace: mp_nuketown_x
	Checksum: 0xB4B45F83
	Offset: 0x5B0
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

