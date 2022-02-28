// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_cleanse;

/*
	Name: __init__sytem__
	Namespace: _gadget_cleanse
	Checksum: 0x69ED21A6
	Offset: 0x290
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_cleanse", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_cleanse
	Checksum: 0x38DBF947
	Offset: 0x2D0
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("allplayers", "gadget_cleanse_on", 1, 1, "int", &has_cleanse_changed, 0, 1);
	duplicate_render::set_dr_filter_offscreen("cleanse_pl", 50, "cleanse_player", undefined, 2, "mc/hud_outline_model_z_green");
}

/*
	Name: has_cleanse_changed
	Namespace: _gadget_cleanse
	Checksum: 0x144BAB3B
	Offset: 0x358
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function has_cleanse_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval != oldval)
	{
		self duplicate_render::update_dr_flag(localclientnum, "cleanse_player", newval);
	}
}

