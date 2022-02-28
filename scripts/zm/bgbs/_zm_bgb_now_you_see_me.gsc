// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_bgb_now_you_see_me;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_now_you_see_me
	Checksum: 0xB21C2874
	Offset: 0x280
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_now_you_see_me", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_now_you_see_me
	Checksum: 0xF98B2AA8
	Offset: 0x2C0
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_now_you_see_me", "activated", 2, undefined, undefined, &validation, &activation);
	bgb::function_336ffc4e("zm_bgb_now_you_see_me");
	if(!isdefined(level.vsmgr_prio_visionset_zm_bgb_now_you_see_me))
	{
		level.vsmgr_prio_visionset_zm_bgb_now_you_see_me = 111;
	}
	visionset_mgr::register_info("visionset", "zm_bgb_now_you_see_me", 1, level.vsmgr_prio_visionset_zm_bgb_now_you_see_me, 31, 1, &visionset_mgr::ramp_in_out_thread_per_player, 0);
	if(!isdefined(level.vsmgr_prio_overlay_zm_bgb_now_you_see_me))
	{
		level.vsmgr_prio_overlay_zm_bgb_now_you_see_me = 111;
	}
	visionset_mgr::register_info("overlay", "zm_bgb_now_you_see_me", 1, level.vsmgr_prio_overlay_zm_bgb_now_you_see_me, 1, 1);
}

/*
	Name: validation
	Namespace: zm_bgb_now_you_see_me
	Checksum: 0xC8DCA0E6
	Offset: 0x3F0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function validation()
{
	return !(isdefined(self bgb::get_active()) && self bgb::get_active());
}

/*
	Name: activation
	Namespace: zm_bgb_now_you_see_me
	Checksum: 0x6A0E9869
	Offset: 0x430
	Size: 0x1C8
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	self endon(#"disconnect");
	self.b_is_designated_target = 1;
	self thread bgb::run_timer(10);
	self playsound("zmb_bgb_nysm_start");
	self playloopsound("zmb_bgb_nysm_loop", 1);
	visionset_mgr::activate("visionset", "zm_bgb_now_you_see_me", self, 0.5, 9, 0.5);
	visionset_mgr::activate("overlay", "zm_bgb_now_you_see_me", self);
	ret = self util::waittill_any_timeout(9.5, "bgb_about_to_take_on_bled_out", "end_game", "bgb_update", "disconnect");
	self stoploopsound(1);
	self playsound("zmb_bgb_nysm_end");
	if("timeout" != ret)
	{
		visionset_mgr::deactivate("visionset", "zm_bgb_now_you_see_me", self);
	}
	else
	{
		wait(0.5);
	}
	visionset_mgr::deactivate("overlay", "zm_bgb_now_you_see_me", self);
	self.b_is_designated_target = 0;
}

