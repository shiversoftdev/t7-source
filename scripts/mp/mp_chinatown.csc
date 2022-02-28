// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\mp_chinatown_fx;
#using scripts\mp\mp_chinatown_sound;
#using scripts\shared\util_shared;

#namespace mp_chinatown;

/*
	Name: main
	Namespace: mp_chinatown
	Checksum: 0xE7CE9C23
	Offset: 0x1E8
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	mp_chinatown_fx::main();
	mp_chinatown_sound::main();
	level.disablefxaniminsplitscreencount = 3;
	load::main();
	level.domflagbasefxoverride = &dom_flag_base_fx_override;
	level.domflagcapfxoverride = &dom_flag_cap_fx_override;
	util::waitforclient(0);
	level.endgamexcamname = "ui_cam_endgame_mp_chinatown";
	level.var_283122e6 = &function_ea38265c;
}

/*
	Name: function_ea38265c
	Namespace: mp_chinatown
	Checksum: 0xFE5BA942
	Offset: 0x2A8
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function function_ea38265c(scriptbundlename)
{
	if(isdefined(level.localplayers) && level.localplayers.size < 2)
	{
		return false;
	}
	if(issubstr(scriptbundlename, "p7_fxanim_gp_shutter"))
	{
		return true;
	}
	if(issubstr(scriptbundlename, "p7_fxanim_gp_trash"))
	{
		return true;
	}
	return false;
}

/*
	Name: dom_flag_base_fx_override
	Namespace: mp_chinatown
	Checksum: 0xC644D124
	Offset: 0x330
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
	Namespace: mp_chinatown
	Checksum: 0xA1F19B6A
	Offset: 0x400
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

