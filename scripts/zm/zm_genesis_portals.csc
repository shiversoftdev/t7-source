// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
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

#namespace zm_genesis_portals;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_portals
	Checksum: 0x146EC814
	Offset: 0x568
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_portals", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_portals
	Checksum: 0x970E7E6F
	Offset: 0x5A8
	Size: 0x464
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	visionset_mgr::register_overlay_info_style_transported("zm_zod", 15000, 15, 2);
	clientfield::register("toplayer", "player_stargate_fx", 15000, 1, "int", &player_stargate_fx, 0, 0);
	clientfield::register("toplayer", "player_light_exploder", 15000, 4, "int", &player_light_exploder, 0, 0);
	clientfield::register("world", "genesis_light_exposure", 15000, 1, "int", &genesis_light_exposure, 0, 0);
	clientfield::register("world", "power_pad_sheffield", 15000, 1, "int", &function_7e1ae25a, 0, 0);
	clientfield::register("world", "power_pad_prison", 15000, 1, "int", &function_7e1ae25a, 0, 0);
	clientfield::register("world", "power_pad_asylum", 15000, 1, "int", &function_7e1ae25a, 0, 0);
	clientfield::register("world", "power_pad_temple", 15000, 1, "int", &function_7e1ae25a, 0, 0);
	clientfield::register("toplayer", "hint_verruckt_portal_top", 15000, 1, "int", &function_44c843d5, 0, 0);
	clientfield::register("toplayer", "hint_verruckt_portal_bottom", 15000, 1, "int", &function_44c843d5, 0, 0);
	clientfield::register("toplayer", "hint_temple_portal_top", 15000, 1, "int", &function_44c843d5, 0, 0);
	clientfield::register("toplayer", "hint_temple_portal_bottom", 15000, 1, "int", &function_44c843d5, 0, 0);
	clientfield::register("toplayer", "hint_sheffield_portal_top", 15000, 1, "int", &function_44c843d5, 0, 0);
	clientfield::register("toplayer", "hint_sheffield_portal_bottom", 15000, 1, "int", &function_44c843d5, 0, 0);
	clientfield::register("toplayer", "hint_prison_portal_top", 15000, 1, "int", &function_44c843d5, 0, 0);
	clientfield::register("toplayer", "hint_prison_portal_bottom", 15000, 1, "int", &function_44c843d5, 0, 0);
}

/*
	Name: player_stargate_fx
	Namespace: zm_genesis_portals
	Checksum: 0x5B09EDD
	Offset: 0xA18
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
	Namespace: zm_genesis_portals
	Checksum: 0x5924945F
	Offset: 0xB00
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
	Name: player_light_exploder
	Namespace: zm_genesis_portals
	Checksum: 0x90F4CA8C
	Offset: 0xB58
	Size: 0x1DE
	Parameters: 7
	Flags: Linked
*/
function player_light_exploder(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 1:
		{
			exploder::exploder("lgt_island_underside_sheff", localclientnum);
			break;
		}
		case 2:
		{
			exploder::stop_exploder("lgt_island_underside_sheff", localclientnum);
			break;
		}
		case 3:
		{
			exploder::exploder("lgt_island_underside_prison", localclientnum);
			break;
		}
		case 4:
		{
			exploder::stop_exploder("lgt_island_underside_prison", localclientnum);
			break;
		}
		case 5:
		{
			exploder::exploder("lgt_island_underside_asylum", localclientnum);
			break;
		}
		case 6:
		{
			exploder::stop_exploder("lgt_island_underside_asylum", localclientnum);
			break;
		}
		case 7:
		{
			exploder::exploder("lgt_island_underside_temple", localclientnum);
			break;
		}
		case 8:
		{
			exploder::stop_exploder("lgt_island_underside_temple", localclientnum);
			break;
		}
		case 9:
		{
			exploder::exploder("lgt_island_underside_proto", localclientnum);
			break;
		}
		case 10:
		{
			exploder::stop_exploder("lgt_island_underside_proto", localclientnum);
			break;
		}
	}
}

/*
	Name: genesis_light_exposure
	Namespace: zm_genesis_portals
	Checksum: 0x146146C6
	Offset: 0xD40
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function genesis_light_exposure(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		setpbgactivebank(localclientnum, 2);
		setexposureactivebank(localclientnum, 2);
	}
	else
	{
		setpbgactivebank(localclientnum, 1);
		setexposureactivebank(localclientnum, 1);
	}
}

/*
	Name: function_44c843d5
	Namespace: zm_genesis_portals
	Checksum: 0x25B6EC63
	Offset: 0xE00
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_44c843d5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		setstreamerrequest(localclientnum, fieldname);
	}
	else
	{
		clearstreamerrequest(localclientnum);
	}
}

/*
	Name: function_7e1ae25a
	Namespace: zm_genesis_portals
	Checksum: 0xDC270E20
	Offset: 0xE88
	Size: 0x262
	Parameters: 7
	Flags: Linked
*/
function function_7e1ae25a(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(fieldname)
	{
		case "power_pad_prison":
		{
			var_2cedcd81 = array("fxexp_220", "fxexp_222", "fxexp_223", "lgt_power_prison");
			break;
		}
		case "power_pad_sheffield":
		{
			var_2cedcd81 = array("fxexp_210", "fxexp_212", "fxexp_213", "lgt_power_sheffield");
			break;
		}
		case "power_pad_temple":
		{
			var_2cedcd81 = array("fxexp_240", "fxexp_242", "fxexp_243", "lgt_power_temple");
			break;
		}
		case "power_pad_asylum":
		{
			var_2cedcd81 = array("fxexp_230", "fxexp_232", "fxexp_233", "lgt_power_asylum");
			break;
		}
	}
	if(newval)
	{
		foreach(str_exploder in var_2cedcd81)
		{
			exploder::exploder(str_exploder);
		}
	}
	else
	{
		foreach(str_exploder in var_2cedcd81)
		{
			exploder::stop_exploder(str_exploder);
		}
	}
}

