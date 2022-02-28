// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_idle_eyes;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_idle_eyes
	Checksum: 0xF41D3D08
	Offset: 0x228
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_idle_eyes", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_idle_eyes
	Checksum: 0x694762A0
	Offset: 0x268
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
	bgb::register("zm_bgb_idle_eyes", "activated", 3, undefined, undefined, &validation, &activation);
	bgb::function_4cda71bf("zm_bgb_idle_eyes", 1);
	bgb::function_336ffc4e("zm_bgb_idle_eyes");
	if(!isdefined(level.vsmgr_prio_visionset_zm_bgb_idle_eyes))
	{
		level.vsmgr_prio_visionset_zm_bgb_idle_eyes = 112;
	}
	visionset_mgr::register_info("visionset", "zm_bgb_idle_eyes", 1, level.vsmgr_prio_visionset_zm_bgb_idle_eyes, 31, 1, &visionset_mgr::ramp_in_out_thread_per_player, 0);
	if(!isdefined(level.vsmgr_prio_overlay_zm_bgb_idle_eyes))
	{
		level.vsmgr_prio_overlay_zm_bgb_idle_eyes = 112;
	}
	visionset_mgr::register_info("overlay", "zm_bgb_idle_eyes", 1, level.vsmgr_prio_overlay_zm_bgb_idle_eyes, 1, 1);
}

/*
	Name: validation
	Namespace: zm_bgb_idle_eyes
	Checksum: 0x1689CC01
	Offset: 0x3B8
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
	Namespace: zm_bgb_idle_eyes
	Checksum: 0xD30DE441
	Offset: 0x3F8
	Size: 0x29C
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	self endon(#"disconnect");
	var_7092e170 = arraycopy(level.activeplayers);
	array::thread_all(var_7092e170, &zm_utility::increment_ignoreme);
	self.bgb_idle_eyes_active = 1;
	if(!bgb::increment_ref_count("zm_bgb_idle_eyes"))
	{
		if(isdefined(level.no_target_override))
		{
			if(!isdefined(level.var_4effcea9))
			{
				level.var_4effcea9 = level.no_target_override;
			}
			level.no_target_override = undefined;
		}
	}
	level thread function_1f57344e(self, var_7092e170);
	self playsound("zmb_bgb_idleeyes_start");
	self playloopsound("zmb_bgb_idleeyes_loop", 1);
	self thread bgb::run_timer(31);
	visionset_mgr::activate("visionset", "zm_bgb_idle_eyes", self, 0.5, 30, 0.5);
	visionset_mgr::activate("overlay", "zm_bgb_idle_eyes", self);
	ret = self util::waittill_any_timeout(30.5, "bgb_about_to_take_on_bled_out", "end_game", "bgb_update", "disconnect");
	self stoploopsound(1);
	self playsound("zmb_bgb_idleeyes_end");
	if("timeout" != ret)
	{
		visionset_mgr::deactivate("visionset", "zm_bgb_idle_eyes", self);
	}
	else
	{
		wait(0.5);
	}
	visionset_mgr::deactivate("overlay", "zm_bgb_idle_eyes", self);
	self.bgb_idle_eyes_active = undefined;
	self notify(#"hash_16ab3604");
	deactivate(var_7092e170);
}

/*
	Name: function_1f57344e
	Namespace: zm_bgb_idle_eyes
	Checksum: 0xBFF2A7B7
	Offset: 0x6A0
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function function_1f57344e(var_e04844d6, var_7092e170)
{
	var_e04844d6 endon(#"hash_16ab3604");
	var_e04844d6 waittill(#"disconnect");
	deactivate(var_7092e170);
}

/*
	Name: deactivate
	Namespace: zm_bgb_idle_eyes
	Checksum: 0x709C25E3
	Offset: 0x6F0
	Size: 0x8E
	Parameters: 1
	Flags: Linked
*/
function deactivate(var_7092e170)
{
	var_7092e170 = array::remove_undefined(var_7092e170);
	array::thread_all(var_7092e170, &zm_utility::decrement_ignoreme);
	if(bgb::decrement_ref_count("zm_bgb_idle_eyes"))
	{
		return;
	}
	if(isdefined(level.var_4effcea9))
	{
		level.no_target_override = level.var_4effcea9;
		level.var_4effcea9 = undefined;
	}
}

