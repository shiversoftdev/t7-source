// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#using_animtree("generic");

#namespace zm_zod_portals;

/*
	Name: __init__sytem__
	Namespace: zm_zod_portals
	Checksum: 0xDF0B9BB6
	Offset: 0x6C8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_portals", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_portals
	Checksum: 0x82D2D98F
	Offset: 0x708
	Size: 0x424
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	visionset_mgr::register_overlay_info_style_transported("zm_zod", 1, 15, 2);
	level._effect["portal_shortcut_closed"] = "zombie/fx_quest_portal_tear_zod_zmb";
	level._effect["portal_shortcut_open_border"] = "zombie/fx_quest_portal_edge_zod_zmb";
	level._effect["portal_shortcut_ambient"] = "zombie/fx_quest_portal_ambient_zod_zmb";
	level._effect["portal_shortcut_pulse"] = "zombie/fx_quest_portal_edge_flash_zod_zmb";
	level._effect["portal_shortcut_opening"] = "zombie/fx_quest_portal_expand_zod_zmb";
	level._effect["portal_shortcut_closed_base"] = "zombie/fx_quest_portal_closed_zod_zmb";
	level._effect["portal_shortcut_ending"] = "zombie/fx_quest_portal_close_igc_zod_zmb";
	n_bits = getminbitcountfornum(3);
	clientfield::register("toplayer", "player_stargate_fx", 1, 1, "int", &player_stargate_fx, 0, 0);
	clientfield::register("world", "portal_state_canal", 1, n_bits, "int", &portal_state_canal, 0, 1);
	clientfield::register("world", "portal_state_slums", 1, n_bits, "int", &portal_state_slums, 0, 1);
	clientfield::register("world", "portal_state_theater", 1, n_bits, "int", &portal_state_theater, 0, 1);
	clientfield::register("world", "portal_state_ending", 1, 1, "int", &portal_state_ending, 0, 0);
	clientfield::register("world", "pulse_canal_portal_top", 1, 1, "counter", &function_4bc7c0a1, 0, 0);
	clientfield::register("world", "pulse_canal_portal_bottom", 1, 1, "counter", &function_bd6fa919, 0, 0);
	clientfield::register("world", "pulse_slums_portal_top", 1, 1, "counter", &function_e66eb44e, 0, 0);
	clientfield::register("world", "pulse_slums_portal_bottom", 1, 1, "counter", &function_9be42b84, 0, 0);
	clientfield::register("world", "pulse_theater_portal_top", 1, 1, "counter", &function_7acc82f, 0, 0);
	clientfield::register("world", "pulse_theater_portal_bottom", 1, 1, "counter", &function_8fbd3c13, 0, 0);
}

/*
	Name: player_stargate_fx
	Namespace: zm_zod_portals
	Checksum: 0x584E3D2F
	Offset: 0xB38
	Size: 0xDE
	Parameters: 7
	Flags: Linked
*/
function player_stargate_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self notify(#"player_stargate_fx");
	self endon(#"player_stargate_fx");
	if(newval == 1)
	{
		if(isdemoplaying() && demoisanyfreemovecamera())
		{
			return;
		}
		self thread function_e7a8756e(localclientnum);
		self thread postfx::playpostfxbundle("pstfx_zm_wormhole");
	}
	else
	{
		self notify(#"player_portal_complete");
	}
}

/*
	Name: function_e7a8756e
	Namespace: zm_zod_portals
	Checksum: 0x13CA61A2
	Offset: 0xC20
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_e7a8756e(localclientnum)
{
	self util::waittill_any("player_stargate_fx", "player_portal_complete");
	self postfx::exitpostfxbundle();
}

/*
	Name: portal_3p
	Namespace: zm_zod_portals
	Checksum: 0x3B5EC4AD
	Offset: 0xC78
	Size: 0xAC
	Parameters: 7
	Flags: None
*/
function portal_3p(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"death");
	if(newval == 1)
	{
		self.fx_portal_3p = playfxontag(localclientnum, level._effect["portal_3p"], self, "j_spineupper");
	}
	else
	{
		stop_fx_if_defined(localclientnum, self.fx_portal_3p);
	}
}

/*
	Name: portal_state_canal
	Namespace: zm_zod_portals
	Checksum: 0x4B357997
	Offset: 0xD30
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function portal_state_canal(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	portal_state_internal(localclientnum, "canal", newval);
}

/*
	Name: portal_state_slums
	Namespace: zm_zod_portals
	Checksum: 0x8244DD64
	Offset: 0xD98
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function portal_state_slums(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	portal_state_internal(localclientnum, "slums", newval);
}

/*
	Name: portal_state_theater
	Namespace: zm_zod_portals
	Checksum: 0xB3B5EF43
	Offset: 0xE00
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function portal_state_theater(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	portal_state_internal(localclientnum, "theater", newval);
}

/*
	Name: portal_state_internal
	Namespace: zm_zod_portals
	Checksum: 0x241E96EF
	Offset: 0xE68
	Size: 0x2AE
	Parameters: 3
	Flags: Linked
*/
function portal_state_internal(localclientnum, str_areaname, newval)
{
	s_loc_upper = get_portal_fx_loc("teleport_effect_origin", str_areaname, 1);
	s_loc_lower = get_portal_fx_loc("teleport_effect_origin", str_areaname, 0);
	switch(newval)
	{
		case 0:
		{
			level thread function_c0c1771a(localclientnum, s_loc_upper, 0, 0);
			level thread function_c0c1771a(localclientnum, s_loc_lower, 0, 1);
			level thread function_a2d0d0e4(s_loc_upper.origin, s_loc_lower.origin, "amb_teleporter_off_lp", "amb_teleporter_on_lp");
			exploder::stop_exploder("lgt_portal_" + str_areaname);
			break;
		}
		case 1:
		{
			level thread function_c0c1771a(localclientnum, s_loc_upper, 1, 0);
			level thread function_c0c1771a(localclientnum, s_loc_lower, 1, 1);
			level thread function_a2d0d0e4(s_loc_upper.origin, s_loc_lower.origin, "amb_teleporter_on_lp", "amb_teleporter_off_lp", "amb_teleporter_activate");
			exploder::exploder("lgt_portal_" + str_areaname);
			break;
		}
		case 2:
		{
			level thread function_c0c1771a(localclientnum, s_loc_upper, 1, 0);
			level thread function_c0c1771a(localclientnum, s_loc_lower, 1, 1);
			level thread function_a2d0d0e4(s_loc_upper.origin, s_loc_lower.origin, "amb_teleporter_on_lp", "amb_teleporter_off_lp", "amb_teleporter_activate");
			exploder::exploder("lgt_portal_" + str_areaname);
			break;
		}
	}
}

/*
	Name: portal_state_ending
	Namespace: zm_zod_portals
	Checksum: 0x5665C2D9
	Offset: 0x1120
	Size: 0x334
	Parameters: 7
	Flags: Linked
*/
function portal_state_ending(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	s_loc = struct::get("ending_igc_portal", "targetname");
	v_fwd = anglestoforward(s_loc.angles);
	if(newval)
	{
		level.var_92f13ff4 = spawn(localclientnum, s_loc.origin, "script_model");
		level.var_92f13ff4.angles = s_loc.angles;
		level.var_92f13ff4 setmodel("p7_zm_zod_keeper_portal_01");
		level.var_120797a1 = [];
		for(i = 1; i < 25; i++)
		{
			fx_id = playfxontag(localclientnum, level._effect["portal_shortcut_open_border"], level.var_92f13ff4, "tag_fx_ring_" + i);
			if(!isdefined(level.var_120797a1))
			{
				level.var_120797a1 = [];
			}
			else if(!isarray(level.var_120797a1))
			{
				level.var_120797a1 = array(level.var_120797a1);
			}
			level.var_120797a1[level.var_120797a1.size] = fx_id;
		}
		level thread function_c968dcbc(s_loc.origin, "zmb_teleporter_igc_lp", "zmb_teleporter_igc_start", 1);
	}
	else
	{
		foreach(fx_id in level.var_120797a1)
		{
			stopfx(localclientnum, fx_id);
		}
		playfx(localclientnum, level._effect["portal_shortcut_ending"], s_loc.origin, v_fwd);
		level.var_92f13ff4 delete();
		level thread function_c968dcbc(s_loc.origin, "zmb_teleporter_igc_lp", "zmb_teleporter_igc_end");
	}
}

/*
	Name: function_4bc7c0a1
	Namespace: zm_zod_portals
	Checksum: 0x7C78EF5C
	Offset: 0x1460
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_4bc7c0a1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_11ac3c33(localclientnum, "canal", 1);
}

/*
	Name: function_bd6fa919
	Namespace: zm_zod_portals
	Checksum: 0xEDE0996A
	Offset: 0x14C8
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_bd6fa919(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_11ac3c33(localclientnum, "canal", 0);
}

/*
	Name: function_e66eb44e
	Namespace: zm_zod_portals
	Checksum: 0x6366097D
	Offset: 0x1530
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_e66eb44e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_11ac3c33(localclientnum, "slums", 1);
}

/*
	Name: function_9be42b84
	Namespace: zm_zod_portals
	Checksum: 0x6FFF9F4F
	Offset: 0x1598
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_9be42b84(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_11ac3c33(localclientnum, "slums", 0);
}

/*
	Name: function_7acc82f
	Namespace: zm_zod_portals
	Checksum: 0x2DB0B5A
	Offset: 0x1600
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_7acc82f(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_11ac3c33(localclientnum, "theater", 1);
}

/*
	Name: function_8fbd3c13
	Namespace: zm_zod_portals
	Checksum: 0x62B501C8
	Offset: 0x1668
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_8fbd3c13(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_11ac3c33(localclientnum, "theater", 0);
}

/*
	Name: function_11ac3c33
	Namespace: zm_zod_portals
	Checksum: 0xE0374E4E
	Offset: 0x16D0
	Size: 0xE6
	Parameters: 3
	Flags: Linked
*/
function function_11ac3c33(localclientnum, str_areaname, b_is_top)
{
	s_loc = get_portal_fx_loc("teleport_effect_origin", str_areaname, b_is_top);
	var_836f2873 = function_86743484(localclientnum, s_loc);
	for(i = 1; i < 25; i++)
	{
		if((i % 5) === 0)
		{
			playfxontag(localclientnum, level._effect["portal_shortcut_pulse"], var_836f2873, "tag_fx_ring_" + i);
		}
	}
}

/*
	Name: function_c0c1771a
	Namespace: zm_zod_portals
	Checksum: 0x86AD7E6D
	Offset: 0x17C0
	Size: 0x3C6
	Parameters: 4
	Flags: Linked
*/
function function_c0c1771a(localclientnum, s_loc, b_open, var_9c9cfb54 = 0)
{
	v_fwd = anglestoforward(s_loc.angles);
	if(!isdefined(s_loc.var_7c0ed442))
	{
		s_loc.var_7c0ed442 = [];
	}
	if(!isdefined(s_loc.var_20dc3b64))
	{
		s_loc.var_20dc3b64 = [];
	}
	if(!isdefined(s_loc.var_1db71ac6))
	{
		s_loc.var_1db71ac6 = [];
	}
	stop_fx_if_defined(localclientnum, s_loc.var_7c0ed442[localclientnum]);
	stop_fx_if_defined(localclientnum, s_loc.var_20dc3b64[localclientnum]);
	if(isdefined(b_open) && b_open)
	{
		s_loc.var_1db71ac6[localclientnum] = playfx(localclientnum, level._effect["portal_shortcut_opening"], s_loc.origin, v_fwd);
	}
	var_836f2873 = function_86743484(localclientnum, s_loc);
	var_836f2873 hidepart(localclientnum, "tag_portal_open");
	if(b_open)
	{
		wait(1.3);
		var_836f2873 showpart(localclientnum, "tag_portal_open");
		for(i = 1; i < 25; i++)
		{
			playfxontag(localclientnum, level._effect["portal_shortcut_open_border"], var_836f2873, "tag_fx_ring_" + i);
		}
	}
	else
	{
		var_836f2873 hidepart(localclientnum, "tag_portal_open");
	}
	stop_fx_if_defined(localclientnum, s_loc.var_1db71ac6[localclientnum]);
	if(isdefined(b_open) && b_open)
	{
		s_loc.var_7c0ed442[localclientnum] = playfx(localclientnum, level._effect["portal_shortcut_ambient"], s_loc.origin, v_fwd);
	}
	else
	{
		if(var_9c9cfb54)
		{
			s_loc.var_20dc3b64[localclientnum] = playfx(localclientnum, level._effect["portal_shortcut_closed_base"], s_loc.origin - vectorscale((0, 0, 1), 48), v_fwd);
		}
		else
		{
			s_loc.var_7c0ed442[localclientnum] = playfx(localclientnum, level._effect["portal_shortcut_closed"], s_loc.origin, v_fwd);
		}
	}
}

/*
	Name: function_86743484
	Namespace: zm_zod_portals
	Checksum: 0xAF1F3B38
	Offset: 0x1B90
	Size: 0x24E
	Parameters: 2
	Flags: Linked
*/
function function_86743484(localclientnum, s_loc)
{
	if(!isdefined(level.var_ef51ee6d))
	{
		level.var_ef51ee6d = [];
	}
	if(!isdefined(level.var_ef51ee6d[localclientnum]))
	{
		level.var_ef51ee6d[localclientnum] = [];
	}
	str_name = s_loc.script_noteworthy;
	if(isdefined(level.var_ef51ee6d[localclientnum][str_name]))
	{
		return level.var_ef51ee6d[localclientnum][str_name].var_836f2873;
	}
	level.var_ef51ee6d[localclientnum][str_name] = spawnstruct();
	level.var_ef51ee6d[localclientnum][str_name].var_836f2873 = spawn(localclientnum, s_loc.origin, "script_model");
	level.var_ef51ee6d[localclientnum][str_name].var_836f2873.angles = s_loc.angles;
	level.var_ef51ee6d[localclientnum][str_name].var_836f2873 setmodel("p7_zm_zod_keeper_portal_01");
	level.var_ef51ee6d[localclientnum][str_name].mdl_base = spawn(localclientnum, s_loc.origin - vectorscale((0, 0, 1), 48), "script_model");
	level.var_ef51ee6d[localclientnum][str_name].mdl_base.angles = s_loc.angles;
	level.var_ef51ee6d[localclientnum][str_name].mdl_base setmodel("p7_zm_zod_keeper_portal_base");
	return level.var_ef51ee6d[localclientnum][str_name].var_836f2873;
}

/*
	Name: get_portal_fx_loc
	Namespace: zm_zod_portals
	Checksum: 0x904FDAEF
	Offset: 0x1DE8
	Size: 0x13C
	Parameters: 3
	Flags: Linked
*/
function get_portal_fx_loc(str_targetname, str_areaname, b_is_top)
{
	a_s_portal_locs = struct::get_array(str_targetname, "targetname");
	s_return_loc = undefined;
	str_top_or_bottom = undefined;
	if(isdefined(b_is_top) && b_is_top)
	{
		str_top_or_bottom = "top";
	}
	else
	{
		str_top_or_bottom = "bottom";
	}
	foreach(s_portal_loc in a_s_portal_locs)
	{
		if(s_portal_loc.script_noteworthy === ((str_areaname + "_portal_") + str_top_or_bottom))
		{
			s_return_loc = s_portal_loc;
		}
	}
	return s_return_loc;
}

/*
	Name: stop_fx_if_defined
	Namespace: zm_zod_portals
	Checksum: 0xF0426A88
	Offset: 0x1F30
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function stop_fx_if_defined(localclientnum, fx_reference)
{
	if(isdefined(fx_reference))
	{
		stopfx(localclientnum, fx_reference);
	}
}

/*
	Name: function_a2d0d0e4
	Namespace: zm_zod_portals
	Checksum: 0x703BCBC
	Offset: 0x1F78
	Size: 0xE4
	Parameters: 5
	Flags: Linked
*/
function function_a2d0d0e4(origin1, origin2, var_4358f968, var_2978dbc6, activation)
{
	audio::playloopat(var_4358f968, origin1);
	audio::stoploopat(var_2978dbc6, origin1);
	if(isdefined(activation))
	{
		playsound(0, activation, origin1);
	}
	wait(0.05);
	audio::playloopat(var_4358f968, origin2);
	audio::stoploopat(var_2978dbc6, origin2);
	if(isdefined(activation))
	{
		playsound(0, activation, origin2);
	}
}

/*
	Name: function_c968dcbc
	Namespace: zm_zod_portals
	Checksum: 0xDE250584
	Offset: 0x2068
	Size: 0xA4
	Parameters: 4
	Flags: Linked
*/
function function_c968dcbc(origin1, var_4358f968, oneshot, activate = 0)
{
	if(isdefined(activate) && activate)
	{
		audio::playloopat(var_4358f968, origin1);
	}
	else
	{
		audio::stoploopat(var_4358f968, origin1);
	}
	playsound(0, oneshot, origin1);
}

