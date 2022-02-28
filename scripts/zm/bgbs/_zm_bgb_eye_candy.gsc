// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_eye_candy;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_eye_candy
	Checksum: 0xA8463548
	Offset: 0x300
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_eye_candy", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_eye_candy
	Checksum: 0xFD7BE37
	Offset: 0x340
	Size: 0x3FC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_eye_candy", "activated", 5, undefined, undefined, &validation, &activation);
	if(!isdefined(level.vsmgr_prio_visionset_zm_bgb_eye_candy_1))
	{
		level.vsmgr_prio_visionset_zm_bgb_eye_candy_1 = 113;
	}
	visionset_mgr::register_info("visionset", "zm_bgb_eye_candy_vs_1", 21000, level.vsmgr_prio_visionset_zm_bgb_eye_candy_1, 31, 1);
	if(!isdefined(level.vsmgr_prio_overlay_zm_bgb_eye_candy_1))
	{
		level.vsmgr_prio_overlay_zm_bgb_eye_candy_1 = 113;
	}
	visionset_mgr::register_info("overlay", "zm_bgb_eye_candy_vs_1", 21000, level.vsmgr_prio_overlay_zm_bgb_eye_candy_1, 1, 1);
	if(!isdefined(level.vsmgr_prio_visionset_zm_bgb_eye_candy_2))
	{
		level.vsmgr_prio_visionset_zm_bgb_eye_candy_2 = 114;
	}
	visionset_mgr::register_info("visionset", "zm_bgb_eye_candy_vs_2", 21000, level.vsmgr_prio_visionset_zm_bgb_eye_candy_2, 31, 1);
	if(!isdefined(level.vsmgr_prio_overlay_zm_bgb_eye_candy_2))
	{
		level.vsmgr_prio_overlay_zm_bgb_eye_candy_2 = 114;
	}
	visionset_mgr::register_info("overlay", "zm_bgb_eye_candy_vs_2", 21000, level.vsmgr_prio_overlay_zm_bgb_eye_candy_2, 1, 1);
	if(!isdefined(level.vsmgr_prio_visionset_zm_bgb_eye_candy_3))
	{
		level.vsmgr_prio_visionset_zm_bgb_eye_candy_3 = 115;
	}
	visionset_mgr::register_info("visionset", "zm_bgb_eye_candy_vs_3", 21000, level.vsmgr_prio_visionset_zm_bgb_eye_candy_3, 31, 1);
	if(!isdefined(level.vsmgr_prio_overlay_zm_bgb_eye_candy_3))
	{
		level.vsmgr_prio_overlay_zm_bgb_eye_candy_3 = 115;
	}
	visionset_mgr::register_info("overlay", "zm_bgb_eye_candy_vs_3", 21000, level.vsmgr_prio_overlay_zm_bgb_eye_candy_3, 1, 1);
	if(!isdefined(level.vsmgr_prio_visionset_zm_bgb_eye_candy_4))
	{
		level.vsmgr_prio_visionset_zm_bgb_eye_candy_4 = 116;
	}
	visionset_mgr::register_info("visionset", "zm_bgb_eye_candy_vs_4", 21000, level.vsmgr_prio_visionset_zm_bgb_eye_candy_4, 31, 1);
	if(!isdefined(level.vsmgr_prio_overlay_zm_bgb_eye_candy_4))
	{
		level.vsmgr_prio_overlay_zm_bgb_eye_candy_4 = 116;
	}
	visionset_mgr::register_info("overlay", "zm_bgb_eye_candy_vs_4", 21000, level.vsmgr_prio_overlay_zm_bgb_eye_candy_4, 1, 1);
	level.var_29cebda6 = array("zm_bgb_eye_candy_vs_1", "zm_bgb_eye_candy_vs_2", "zm_bgb_eye_candy_vs_3", "zm_bgb_eye_candy_vs_4");
	n_bits = getminbitcountfornum(5);
	clientfield::register("toplayer", "eye_candy_render", 21000, n_bits, "int");
	clientfield::register("actor", "eye_candy_active", 21000, 1, "int");
	clientfield::register("vehicle", "eye_candy_active", 21000, 1, "int");
	spawner::add_global_spawn_function("axis", &function_b390826f);
}

/*
	Name: validation
	Namespace: zm_bgb_eye_candy
	Checksum: 0x3B229375
	Offset: 0x748
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
	Namespace: zm_bgb_eye_candy
	Checksum: 0xC12D5E34
	Offset: 0x788
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	self endon(#"disconnect");
	if(!isdefined(self.var_e20073c4))
	{
		self.var_e20073c4 = 0;
		self.var_29cebda6 = arraycopy(level.var_29cebda6);
		self.var_29cebda6 = array::randomize(self.var_29cebda6);
	}
	else
	{
		wait(0.05);
		self.var_e20073c4++;
	}
	self notify(#"bgb_eye_candy_activation");
	if(self.var_e20073c4 >= 4)
	{
		return;
	}
	self playsoundtoplayer("zmb_bgb_eyecandy_" + self.var_e20073c4, self);
	visionset_mgr::activate("visionset", self.var_29cebda6[self.var_e20073c4], self);
	visionset_mgr::activate("overlay", self.var_29cebda6[self.var_e20073c4], self);
	var_78f89ecc = 0;
	switch(self.var_29cebda6[self.var_e20073c4])
	{
		case "zm_bgb_eye_candy_vs_1":
		{
			var_78f89ecc = 1;
			break;
		}
		case "zm_bgb_eye_candy_vs_2":
		{
			var_78f89ecc = 2;
			break;
		}
		case "zm_bgb_eye_candy_vs_3":
		{
			var_78f89ecc = 3;
			break;
		}
		case "zm_bgb_eye_candy_vs_4":
		{
			var_78f89ecc = 4;
			break;
		}
	}
	self thread clientfield::set_to_player("eye_candy_render", var_78f89ecc);
	self thread function_48adddeb(self.var_29cebda6[self.var_e20073c4]);
}

/*
	Name: function_48adddeb
	Namespace: zm_bgb_eye_candy
	Checksum: 0xB6F58F6F
	Offset: 0x980
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function function_48adddeb(str_vision)
{
	str_return = self util::waittill_any_return("bgb_eye_candy_activation", "end_game", "bgb_gumball_anim_give", "disconnect", "bled_out");
	visionset_mgr::deactivate("visionset", str_vision, self);
	visionset_mgr::deactivate("overlay", str_vision, self);
	if(str_return !== "bgb_eye_candy_activation" || self.var_e20073c4 >= 4)
	{
		self playsoundtoplayer("zmb_bgb_eyecandy_deactivate", self);
		self.var_e20073c4 = undefined;
		self thread clientfield::set_to_player("eye_candy_render", 0);
	}
	else if(self.var_e20073c4 == 3)
	{
		bgb::function_650ca64(6);
	}
}

/*
	Name: function_b390826f
	Namespace: zm_bgb_eye_candy
	Checksum: 0xBDFF86A5
	Offset: 0xAB0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_b390826f()
{
	self clientfield::set("eye_candy_active", 1);
	self thread function_3b5b1f1e();
}

/*
	Name: function_3b5b1f1e
	Namespace: zm_bgb_eye_candy
	Checksum: 0xF4F368B9
	Offset: 0xAF8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_3b5b1f1e()
{
	self endon(#"hash_67d0cc9f");
	self waittill(#"death");
	if(isdefined(self))
	{
		self function_67d0cc9f();
	}
}

/*
	Name: function_67d0cc9f
	Namespace: zm_bgb_eye_candy
	Checksum: 0xEB50C618
	Offset: 0xB40
	Size: 0x32
	Parameters: 0
	Flags: Linked
*/
function function_67d0cc9f()
{
	self clientfield::set("eye_candy_active", 0);
	self notify(#"hash_67d0cc9f");
}

