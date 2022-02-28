// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_shoutcaster;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#namespace koth;

/*
	Name: main
	Namespace: koth
	Checksum: 0x334AB77D
	Offset: 0x2F0
	Size: 0x2AC
	Parameters: 0
	Flags: None
*/
function main()
{
	level.current_zone = [];
	level.current_state = [];
	for(i = 0; i < 4; i++)
	{
		level.current_zone[i] = 0;
		level.current_state[i] = 0;
	}
	level.hardpoints = [];
	level.visuals = [];
	level.hardpointfx = [];
	clientfield::register("world", "hardpoint", 1, 5, "int", &hardpoint, 0, 0);
	clientfield::register("world", "hardpointteam", 1, 5, "int", &hardpoint_state, 0, 0);
	level.effect_scriptbundles = [];
	level.effect_scriptbundles["zoneEdgeMarker"] = struct::get_script_bundle("teamcolorfx", "teamcolorfx_koth_edge_marker");
	level.effect_scriptbundles["zoneEdgeMarkerWndw"] = struct::get_script_bundle("teamcolorfx", "teamcolorfx_koth_edge_marker_window");
	level._effect["zoneEdgeMarker"] = [];
	level._effect["zoneEdgeMarker"][0] = "ui/fx_koth_marker_neutral";
	level._effect["zoneEdgeMarker"][1] = "ui/fx_koth_marker_blue";
	level._effect["zoneEdgeMarker"][2] = "ui/fx_koth_marker_orng";
	level._effect["zoneEdgeMarker"][3] = "ui/fx_koth_marker_contested";
	level._effect["zoneEdgeMarkerWndw"] = [];
	level._effect["zoneEdgeMarkerWndw"][0] = "ui/fx_koth_marker_neutral_window";
	level._effect["zoneEdgeMarkerWndw"][1] = "ui/fx_koth_marker_blue_window";
	level._effect["zoneEdgeMarkerWndw"][2] = "ui/fx_koth_marker_orng_window";
	level._effect["zoneEdgeMarkerWndw"][3] = "ui/fx_koth_marker_contested_window";
}

/*
	Name: get_shoutcaster_fx
	Namespace: koth
	Checksum: 0xAB465E27
	Offset: 0x5A8
	Size: 0x288
	Parameters: 1
	Flags: None
*/
function get_shoutcaster_fx(local_client_num)
{
	effects = [];
	effects["zoneEdgeMarker"][0] = level._effect["zoneEdgeMarker"][0];
	effects["zoneEdgeMarker"][3] = level._effect["zoneEdgeMarker"][3];
	effects["zoneEdgeMarkerWndw"][0] = level._effect["zoneEdgeMarkerWndw"][0];
	effects["zoneEdgeMarkerWndw"][3] = level._effect["zoneEdgeMarkerWndw"][3];
	if(getdvarint("tu11_programaticallyColoredGameFX"))
	{
		effects["zoneEdgeMarker"][1] = "ui/fx_koth_marker_white";
		effects["zoneEdgeMarker"][2] = "ui/fx_koth_marker_white";
		effects["zoneEdgeMarkerWndw"][1] = "ui/fx_koth_marker_white_window";
		effects["zoneEdgeMarkerWndw"][2] = "ui/fx_koth_marker_white_window";
	}
	else
	{
		caster_effects = [];
		caster_effects["zoneEdgeMarker"] = shoutcaster::get_color_fx(local_client_num, level.effect_scriptbundles["zoneEdgeMarker"]);
		caster_effects["zoneEdgeMarkerWndw"] = shoutcaster::get_color_fx(local_client_num, level.effect_scriptbundles["zoneEdgeMarkerWndw"]);
		effects["zoneEdgeMarker"][1] = caster_effects["zoneEdgeMarker"]["allies"];
		effects["zoneEdgeMarker"][2] = caster_effects["zoneEdgeMarker"]["axis"];
		effects["zoneEdgeMarkerWndw"][1] = caster_effects["zoneEdgeMarkerWndw"]["allies"];
		effects["zoneEdgeMarkerWndw"][2] = caster_effects["zoneEdgeMarkerWndw"]["axis"];
	}
	return effects;
}

/*
	Name: get_fx_state
	Namespace: koth
	Checksum: 0xF2B196B7
	Offset: 0x838
	Size: 0xAA
	Parameters: 3
	Flags: None
*/
function get_fx_state(local_client_num, state, is_shoutcaster)
{
	if(is_shoutcaster)
	{
		return state;
	}
	if(state == 1)
	{
		if(util::friend_not_foe_team(local_client_num, "allies"))
		{
			return 1;
		}
		return 2;
	}
	if(state == 2)
	{
		if(util::friend_not_foe_team(local_client_num, "axis"))
		{
			return 1;
		}
		return 2;
	}
	return state;
}

/*
	Name: get_fx
	Namespace: koth
	Checksum: 0xF87151C9
	Offset: 0x8F0
	Size: 0x2C
	Parameters: 3
	Flags: None
*/
function get_fx(fx_name, fx_state, effects)
{
	return effects[fx_name][fx_state];
}

/*
	Name: setup_hardpoint_fx
	Namespace: koth
	Checksum: 0x2AA1351
	Offset: 0x928
	Size: 0x3C4
	Parameters: 3
	Flags: None
*/
function setup_hardpoint_fx(local_client_num, zone_index, state)
{
	effects = [];
	if(shoutcaster::is_shoutcaster_using_team_identity(local_client_num))
	{
		effects = get_shoutcaster_fx(local_client_num);
	}
	else
	{
		effects["zoneEdgeMarker"] = level._effect["zoneEdgeMarker"];
		effects["zoneEdgeMarkerWndw"] = level._effect["zoneEdgeMarkerWndw"];
	}
	if(isdefined(level.hardpointfx[local_client_num]))
	{
		foreach(fx in level.hardpointfx[local_client_num])
		{
			stopfx(local_client_num, fx);
		}
	}
	level.hardpointfx[local_client_num] = [];
	if(zone_index)
	{
		if(isdefined(level.visuals[zone_index]))
		{
			fx_state = get_fx_state(local_client_num, state, shoutcaster::is_shoutcaster(local_client_num));
			foreach(visual in level.visuals[zone_index])
			{
				if(!isdefined(visual.script_fxid))
				{
					continue;
				}
				fxid = get_fx(visual.script_fxid, fx_state, effects);
				if(isdefined(visual.angles))
				{
					forward = anglestoforward(visual.angles);
				}
				else
				{
					forward = (0, 0, 0);
				}
				fxhandle = playfx(local_client_num, fxid, visual.origin, forward);
				level.hardpointfx[local_client_num][level.hardpointfx[local_client_num].size] = fxhandle;
				if(isdefined(fxhandle))
				{
					if(state == 1)
					{
						setfxteam(local_client_num, fxhandle, "allies");
						continue;
					}
					if(state == 2)
					{
						setfxteam(local_client_num, fxhandle, "axis");
						continue;
					}
					setfxteam(local_client_num, fxhandle, "free");
				}
			}
		}
	}
	thread watch_for_team_change(local_client_num);
}

/*
	Name: hardpoint
	Namespace: koth
	Checksum: 0xC67818F0
	Offset: 0xCF8
	Size: 0x1FC
	Parameters: 7
	Flags: None
*/
function hardpoint(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(level.hardpoints.size == 0)
	{
		hardpoints = struct::get_array("koth_zone_center", "targetname");
		foreach(point in hardpoints)
		{
			level.hardpoints[point.script_index] = point;
		}
		foreach(point in level.hardpoints)
		{
			level.visuals[point.script_index] = struct::get_array(point.target, "targetname");
		}
	}
	level.current_zone[localclientnum] = newval;
	level.current_state[localclientnum] = 0;
	setup_hardpoint_fx(localclientnum, level.current_zone[localclientnum], level.current_state[localclientnum]);
}

/*
	Name: hardpoint_state
	Namespace: koth
	Checksum: 0xE3518DFB
	Offset: 0xF00
	Size: 0x94
	Parameters: 7
	Flags: None
*/
function hardpoint_state(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval != level.current_state[localclientnum])
	{
		level.current_state[localclientnum] = newval;
		setup_hardpoint_fx(localclientnum, level.current_zone[localclientnum], level.current_state[localclientnum]);
	}
}

/*
	Name: watch_for_team_change
	Namespace: koth
	Checksum: 0x7B9C241
	Offset: 0xFA0
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function watch_for_team_change(localclientnum)
{
	level notify(#"end_team_change_watch");
	level endon(#"end_team_change_watch");
	level waittill(#"team_changed");
	wait(0.05);
	thread setup_hardpoint_fx(localclientnum, level.current_zone[localclientnum], level.current_state[localclientnum]);
}

