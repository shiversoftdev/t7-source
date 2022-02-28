// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_resurrect;

/*
	Name: __init__sytem__
	Namespace: _gadget_resurrect
	Checksum: 0xDFF43C91
	Offset: 0x2F0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_resurrect", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_resurrect
	Checksum: 0x49398CDB
	Offset: 0x330
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("allplayers", "resurrecting", 1, 1, "int", &player_resurrect_changed, 0, 1);
	clientfield::register("toplayer", "resurrect_state", 1, 2, "int", &player_resurrect_state_changed, 0, 1);
	duplicate_render::set_dr_filter_offscreen("resurrecting", 99, "resurrecting", undefined, 2, "mc/hud_keyline_resurrect", 0);
	visionset_mgr::register_visionset_info("resurrect", 1, 16, undefined, "mp_ability_resurrection");
	visionset_mgr::register_visionset_info("resurrect_up", 1, 16, undefined, "mp_ability_wakeup");
}

/*
	Name: player_resurrect_changed
	Namespace: _gadget_resurrect
	Checksum: 0x6589AD80
	Offset: 0x450
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function player_resurrect_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self duplicate_render::update_dr_flag(localclientnum, "resurrecting", newval);
}

/*
	Name: resurrect_down_fx
	Namespace: _gadget_resurrect
	Checksum: 0x9C7B59F
	Offset: 0x4C0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function resurrect_down_fx(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"finish_rejack");
	self thread postfx::playpostfxbundle("pstfx_resurrection_close");
	wait(0.5);
	self thread postfx::playpostfxbundle("pstfx_resurrection_pus");
}

/*
	Name: resurrect_up_fx
	Namespace: _gadget_resurrect
	Checksum: 0xF86BBC03
	Offset: 0x530
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function resurrect_up_fx(localclientnum)
{
	self endon(#"entityshutdown");
	self notify(#"finish_rejack");
	self thread postfx::playpostfxbundle("pstfx_resurrection_open");
}

/*
	Name: player_resurrect_state_changed
	Namespace: _gadget_resurrect
	Checksum: 0xD1E9CC35
	Offset: 0x578
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function player_resurrect_state_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self thread resurrect_down_fx(localclientnum);
	}
	else
	{
		if(newval == 2)
		{
			self thread resurrect_up_fx(localclientnum);
		}
		else
		{
			self thread postfx::stoppostfxbundle();
		}
	}
}

