// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\beam_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_stalingrad_ee_main;

/*
	Name: __init__sytem__
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xD950B922
	Offset: 0x670
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_ee_main", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xBF6C8032
	Offset: 0x6B0
	Size: 0x634
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["ee_anomaly_hit"] = "dlc3/stalingrad/fx_main_anomoly_hit";
	level._effect["ee_anomaly_pulse"] = "dlc3/stalingrad/fx_main_anomoly_emp_pulse";
	level._effect["ee_anomaly_loop"] = "dlc3/stalingrad/fx_main_anomoly_loop_trail";
	level._effect["ee_anomaly_talk"] = "dlc3/stalingrad/fx_main_anomoly_loop_trail_talk";
	level._effect["ee_drone_cam"] = "dlc3/stalingrad/fx_main_sentinel_drone_scanner";
	level._effect["ee_raz_eye"] = "dlc3/stalingrad/fx_main_raz_eye_glow_friendly";
	level._effect["ee_sewer_switch"] = "dlc3/stalingrad/fx_main_impact_success";
	level._effect["post_outro_smoke"] = "dlc3/stalingrad/fx_mech_vdest_smoke_column";
	clientfield::register("scriptmover", "ee_anomaly_hit", 12000, 1, "counter", &function_f5deabb1, 0, 0);
	clientfield::register("scriptmover", "ee_anomaly_loop", 12000, 1, "int", &function_d1216748, 0, 0);
	clientfield::register("scriptmover", "ee_cargo_explosion", 12000, 1, "int", &function_9a9410ac, 0, 0);
	clientfield::register("vehicle", "ee_drone_cam_override", 12000, 1, "int", &function_5bdec411, 0, 0);
	clientfield::register("scriptmover", "ee_generator_kill", 12000, 1, "int", &function_2a4222fe, 0, 0);
	clientfield::register("scriptmover", "ee_generator_target", 12000, 1, "int", &function_3a96f955, 0, 0);
	clientfield::register("scriptmover", "ee_koth_light_1", 12000, 2, "int", &function_ee9d73b7, 0, 0);
	clientfield::register("scriptmover", "ee_koth_light_2", 12000, 2, "int", &function_7c96047c, 0, 0);
	clientfield::register("scriptmover", "ee_koth_light_3", 12000, 2, "int", &function_a2987ee5, 0, 0);
	clientfield::register("scriptmover", "ee_koth_light_4", 12000, 2, "int", &function_30910faa, 0, 0);
	clientfield::register("toplayer", "ee_lockdown_fog", 12000, 1, "int", &function_1616098c, 0, 0);
	clientfield::register("actor", "ee_raz_eye_override", 12000, 1, "int", &function_17268d90, 0, 0);
	clientfield::register("scriptmover", "ee_sewer_switch", 12000, 1, "int", &function_f1804aa5, 0, 0);
	clientfield::register("world", "ee_eye_beam_rumble", 12000, 1, "int", &function_ae73f9d5, 0, 0);
	clientfield::register("toplayer", "ee_hatch_strain_rumble", 12000, 1, "int", &function_fb18b2da, 0, 0);
	clientfield::register("scriptmover", "ee_hatch_break_rumble", 12000, 1, "int", &function_ebc93656, 0, 0);
	clientfield::register("scriptmover", "ee_safe_smash_rumble", 12000, 1, "int", &function_61ba3846, 0, 0);
	clientfield::register("scriptmover", "ee_timed_explosion_rumble", 12000, 1, "counter", &function_fa9a5ecf, 0, 0);
	clientfield::register("scriptmover", "post_outro_smoke", 12000, 1, "int", &function_725d353b, 0, 0);
}

/*
	Name: function_f5deabb1
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x94C430C7
	Offset: 0xCF0
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_f5deabb1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["ee_anomaly_hit"], self.origin);
	}
}

/*
	Name: function_d1216748
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x8D7E4071
	Offset: 0xD70
	Size: 0x16C
	Parameters: 7
	Flags: Linked
*/
function function_d1216748(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfx(localclientnum, level._effect["ee_anomaly_pulse"], self.origin);
	playrumbleonposition(localclientnum, "zm_stalingrad_ee_pursue_pulse", self.origin);
	if(newval == 1)
	{
		if(isdefined(self.n_fx_id))
		{
			stopfx(localclientnum, self.n_fx_id);
		}
		self.n_fx_id = playfxontag(localclientnum, level._effect["ee_anomaly_loop"], self, "tag_origin");
	}
	else
	{
		if(isdefined(self.n_fx_id))
		{
			stopfx(localclientnum, self.n_fx_id);
		}
		self.n_fx_id = playfxontag(localclientnum, level._effect["ee_anomaly_talk"], self, "tag_origin");
	}
}

/*
	Name: function_9a9410ac
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xFB53C5F5
	Offset: 0xEE8
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_9a9410ac(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["generic_explosion"], self.origin);
	}
}

/*
	Name: function_5bdec411
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x80122B44
	Offset: 0xF68
	Size: 0x14E
	Parameters: 7
	Flags: Linked
*/
function function_5bdec411(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(isdefined(self.camerascannerfx))
		{
			stopfx(localclientnum, self.camerascannerfx);
		}
		if(!isdefined(self.var_734c069))
		{
			self.var_734c069 = self playloopsound("zmb_scenario_magneto_ping");
		}
		self.camerascannerfx = playfxontag(localclientnum, level._effect["ee_drone_cam"], self, "tag_flash");
	}
	else
	{
		if(isdefined(self.camerascannerfx))
		{
			stopfx(localclientnum, self.camerascannerfx);
			self.camerascannerfx = undefined;
		}
		if(isdefined(self.var_734c069))
		{
			self stoploopsound(self.var_734c069);
			self.var_734c069 = undefined;
		}
	}
}

/*
	Name: function_2a4222fe
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x1475D7E0
	Offset: 0x10C0
	Size: 0x104
	Parameters: 7
	Flags: Linked
*/
function function_2a4222fe(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		var_b4349698 = level.var_346f70b8[localclientnum];
		level beam::launch(self, "tag_origin", var_b4349698, "tag_origin", "electric_arc_zombie_to_drop_pod");
		var_b4349698 playsound(0, "zmb_pod_electrocute");
		wait(0.2);
		level beam::kill(self, "tag_origin", var_b4349698, "tag_origin", "electric_arc_zombie_to_drop_pod");
		self playsound(0, "zmb_pod_electrocute_zmb");
	}
}

/*
	Name: function_3a96f955
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x927A044A
	Offset: 0x11D0
	Size: 0x62
	Parameters: 7
	Flags: Linked
*/
function function_3a96f955(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level.var_346f70b8[localclientnum] = self;
	}
	else
	{
		level.var_346f70b8 = undefined;
	}
}

/*
	Name: function_ee9d73b7
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xDC55E5F2
	Offset: 0x1240
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_ee9d73b7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self function_b1ffcb5c(localclientnum, 0, newval);
}

/*
	Name: function_7c96047c
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xE5283CC6
	Offset: 0x12A8
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_7c96047c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self function_b1ffcb5c(localclientnum, 1, newval);
}

/*
	Name: function_a2987ee5
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xBDF2A043
	Offset: 0x1310
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_a2987ee5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self function_b1ffcb5c(localclientnum, 2, newval);
}

/*
	Name: function_30910faa
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x88C02C66
	Offset: 0x1378
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_30910faa(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self function_b1ffcb5c(localclientnum, 3, newval);
}

/*
	Name: function_b1ffcb5c
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xEE444E37
	Offset: 0x13E0
	Size: 0x15A
	Parameters: 3
	Flags: Linked
*/
function function_b1ffcb5c(localclientnum, var_46ab6018, newval)
{
	if(!isdefined(self.var_b3ab5e19))
	{
		self.var_b3ab5e19 = [];
	}
	if(isdefined(self.var_b3ab5e19[var_46ab6018]))
	{
		stopfx(localclientnum, self.var_b3ab5e19[var_46ab6018]);
	}
	if(newval == 0)
	{
		return;
	}
	if(newval == 1)
	{
		str_fx = "dlc3/stalingrad/fx_glow_red_dragonstrike";
	}
	else if(newval == 2)
	{
		str_fx = "dlc3/stalingrad/fx_glow_green_dragonstrike";
	}
	n_tag_index = var_46ab6018 + 1;
	str_tag = "tag_dragon_network_console_terminal_light_green_0" + n_tag_index;
	v_position = self gettagorigin(str_tag) + (1.25, -1.25, -0.25);
	self.var_b3ab5e19[var_46ab6018] = playfx(localclientnum, str_fx, v_position);
}

/*
	Name: function_1616098c
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xF4E1E49D
	Offset: 0x1548
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function function_1616098c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		setlitfogbank(localclientnum, -1, 2, -1);
		setworldfogactivebank(localclientnum, 4);
	}
	else
	{
		setlitfogbank(localclientnum, -1, 0, -1);
		setworldfogactivebank(localclientnum, 1);
	}
}

/*
	Name: function_17268d90
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xB9414636
	Offset: 0x1610
	Size: 0xD2
	Parameters: 7
	Flags: Linked
*/
function function_17268d90(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(isdefined(self._eyearray))
		{
			if(isdefined(self._eyearray[localclientnum]))
			{
				deletefx(localclientnum, self._eyearray[localclientnum], 1);
			}
		}
		self._eyearray[localclientnum] = playfxontag(localclientnum, level._effect["ee_raz_eye"], self, "tag_eye_glow");
	}
}

/*
	Name: function_f1804aa5
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x5999BFF8
	Offset: 0x16F0
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_f1804aa5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		playfx(localclientnum, level._effect["ee_sewer_switch"], self.origin);
	}
}

/*
	Name: function_ae73f9d5
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xD062AC1C
	Offset: 0x1778
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function function_ae73f9d5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		var_1f9211a4 = struct::get("ee_core_end_struct", "targetname");
		playrumbleonposition(localclientnum, "zm_stalingrad_ee_eye_beam", var_1f9211a4.origin);
	}
}

/*
	Name: function_fb18b2da
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xDB1071F1
	Offset: 0x1820
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function function_fb18b2da(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self playrumblelooponentity(localclientnum, "zm_stalingrad_ee_hatch");
	}
	else
	{
		self stoprumble(localclientnum, "zm_stalingrad_ee_hatch");
	}
}

/*
	Name: function_ebc93656
	Namespace: zm_stalingrad_ee_main
	Checksum: 0x465C545A
	Offset: 0x18B8
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function function_ebc93656(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playrumbleonposition(localclientnum, "zm_stalingrad_ee_sophia_small", self.origin);
	}
}

/*
	Name: function_61ba3846
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xB9151C28
	Offset: 0x1930
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function function_61ba3846(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playrumbleonposition(localclientnum, "zm_stalingrad_ee_safe_smash", self.origin);
	}
}

/*
	Name: function_fa9a5ecf
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xD7C69494
	Offset: 0x19A8
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function function_fa9a5ecf(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playrumbleonposition(localclientnum, "zm_stalingrad_drop_pod_explosion", self.origin);
	}
}

/*
	Name: function_725d353b
	Namespace: zm_stalingrad_ee_main
	Checksum: 0xD745BA0F
	Offset: 0x1A20
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_725d353b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfxontag(localclientnum, level._effect["post_outro_smoke"], self, "tag_body");
	}
}

