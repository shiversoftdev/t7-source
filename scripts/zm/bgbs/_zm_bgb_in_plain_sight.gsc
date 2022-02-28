// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_in_plain_sight;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_in_plain_sight
	Checksum: 0x98545D42
	Offset: 0x218
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_in_plain_sight", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_in_plain_sight
	Checksum: 0xA5ABA10A
	Offset: 0x258
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_in_plain_sight", "activated", 2, undefined, undefined, &validation, &activation);
	bgb::function_4cda71bf("zm_bgb_in_plain_sight", 1);
	bgb::function_336ffc4e("zm_bgb_in_plain_sight");
	if(!isdefined(level.vsmgr_prio_visionset_zm_bgb_in_plain_sight))
	{
		level.vsmgr_prio_visionset_zm_bgb_in_plain_sight = 110;
	}
	visionset_mgr::register_info("visionset", "zm_bgb_in_plain_sight", 1, level.vsmgr_prio_visionset_zm_bgb_in_plain_sight, 31, 1, &visionset_mgr::ramp_in_out_thread_per_player, 0);
	if(!isdefined(level.vsmgr_prio_overlay_zm_bgb_in_plain_sight))
	{
		level.vsmgr_prio_overlay_zm_bgb_in_plain_sight = 110;
	}
	visionset_mgr::register_info("overlay", "zm_bgb_in_plain_sight", 1, level.vsmgr_prio_overlay_zm_bgb_in_plain_sight, 1, 1);
}

/*
	Name: validation
	Namespace: zm_bgb_in_plain_sight
	Checksum: 0x3249E9B2
	Offset: 0x3A8
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
	Namespace: zm_bgb_in_plain_sight
	Checksum: 0x40E53E86
	Offset: 0x3E8
	Size: 0x1EE
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	self endon(#"disconnect");
	self zm_utility::increment_ignoreme();
	self.bgb_in_plain_sight_active = 1;
	self playsound("zmb_bgb_plainsight_start");
	self playloopsound("zmb_bgb_plainsight_loop", 1);
	self thread bgb::run_timer(10);
	visionset_mgr::activate("visionset", "zm_bgb_in_plain_sight", self, 0.5, 9, 0.5);
	visionset_mgr::activate("overlay", "zm_bgb_in_plain_sight", self);
	ret = self util::waittill_any_timeout(9.5, "bgb_about_to_take_on_bled_out", "end_game", "bgb_update", "disconnect");
	self stoploopsound(1);
	self playsound("zmb_bgb_plainsight_end");
	if("timeout" != ret)
	{
		visionset_mgr::deactivate("visionset", "zm_bgb_in_plain_sight", self);
	}
	else
	{
		wait(0.5);
	}
	visionset_mgr::deactivate("overlay", "zm_bgb_in_plain_sight", self);
	self zm_utility::decrement_ignoreme();
	self.bgb_in_plain_sight_active = undefined;
}

