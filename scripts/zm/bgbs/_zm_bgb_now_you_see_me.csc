// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_now_you_see_me;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_now_you_see_me
	Checksum: 0xCE329ACC
	Offset: 0x1A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_now_you_see_me", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_bgb_now_you_see_me
	Checksum: 0x1607A289
	Offset: 0x1E8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_now_you_see_me", "activated");
	visionset_mgr::register_visionset_info("zm_bgb_now_you_see_me", 1, 31, undefined, "zm_bgb_in_plain_sight");
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_bgb_now_you_see_me", 1, 1, "pstfx_zm_bgb_now_you_see_me");
}

