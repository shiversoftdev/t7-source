// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\zm_tomb_ee_lights;

#namespace zm_tomb_ee;

/*
	Name: init
	Namespace: zm_tomb_ee
	Checksum: 0xA7F49FE4
	Offset: 0x440
	Size: 0x2E4
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("world", "wagon_1_fire", 21000, 1, "int", &function_6db69694, 0, 0);
	clientfield::register("world", "wagon_2_fire", 21000, 1, "int", &function_6db69694, 0, 0);
	clientfield::register("world", "wagon_3_fire", 21000, 1, "int", &function_6db69694, 0, 0);
	clientfield::register("world", "ee_sam_portal", 21000, 2, "int", &function_aff1c5b2, 0, 0);
	clientfield::register("actor", "ee_zombie_fist_fx", 21000, 1, "int", &function_64b44f6b, 0, 0);
	clientfield::register("actor", "ee_zombie_soul_portal", 21000, 1, "int", &function_a8fdf631, 0, 0);
	clientfield::register("actor", "ee_zombie_tablet_fx", 21000, 1, "int", &function_74610c8a, 0, 0);
	clientfield::register("vehicle", "ee_plane_fx", 21000, 1, "int", &function_19452a40, 0, 0);
	clientfield::register("toplayer", "ee_beacon_reward", 21000, 1, "int", &function_b628a101, 0, 0);
	clientfield::register("world", "TombEndGameBlackScreen", 21000, 1, "int", &function_13792d2, 0, 0);
	zm_tomb_ee_lights::main();
}

/*
	Name: function_6db69694
	Namespace: zm_tomb_ee
	Checksum: 0x90458FDB
	Offset: 0x730
	Size: 0x134
	Parameters: 7
	Flags: Linked
*/
function function_6db69694(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	switch(fieldname)
	{
		case "wagon_1_fire":
		{
			str_exploder_name = "fxexp_211";
			break;
		}
		case "wagon_2_fire":
		{
			str_exploder_name = "fxexp_212";
			break;
		}
		case "wagon_3_fire":
		{
			str_exploder_name = "fxexp_213";
			break;
		}
		default:
		{
			str_exploder_name = "";
		}
	}
	if(newval == 1)
	{
		exploder::stop_exploder(str_exploder_name, localclientnum);
		level thread function_1ebf0afe(1, fieldname);
	}
	else
	{
		exploder::exploder(str_exploder_name, localclientnum);
		level thread function_1ebf0afe(0, fieldname);
	}
}

/*
	Name: function_6e543e40
	Namespace: zm_tomb_ee
	Checksum: 0x5BB96156
	Offset: 0x870
	Size: 0xE8
	Parameters: 2
	Flags: None
*/
function function_6e543e40(localclientnum, fieldname)
{
	level notify("stop_" + fieldname);
	self endon("stop_" + fieldname);
	s_pos = struct::get(fieldname, "targetname");
	while(true)
	{
		playfx(localclientnum, level._effect["wagon_fire"], s_pos.origin, anglestoforward(s_pos.angles), anglestoup(s_pos.angles));
		wait(0.5);
	}
}

/*
	Name: function_1ebf0afe
	Namespace: zm_tomb_ee
	Checksum: 0x32F14AA9
	Offset: 0x960
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function function_1ebf0afe(ison, fieldname)
{
	struct = struct::get(fieldname, "targetname");
	origin = struct.origin;
	if(ison)
	{
		audio::playloopat("amb_fire_xlg", origin);
	}
	else
	{
		audio::stoploopat("amb_fire_xlg", origin);
	}
}

/*
	Name: function_64b44f6b
	Namespace: zm_tomb_ee
	Checksum: 0xC51EE2F0
	Offset: 0xA10
	Size: 0x1D2
	Parameters: 7
	Flags: Linked
*/
function function_64b44f6b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		if(!isdefined(self.has_soul))
		{
			self.has_soul = 1;
			self.var_8020f50b = playfxontag(localclientnum, level._effect["fist_glow"], self, "J_Wrist_RI");
			self.var_9c121695 = playfxontag(localclientnum, level._effect["fist_glow"], self, "J_Wrist_LE");
		}
		if(!isdefined(self.var_3a8912f4))
		{
			self.var_3a8912f4 = spawn(0, self.origin, "script_origin");
			self.var_3a8912f4 linkto(self);
			self.var_3a8912f4 playloopsound("zmb_squest_punchtime_fist_loop", 1);
			self thread snddeletesndent(self.var_3a8912f4);
		}
	}
	else
	{
		if(isdefined(self.has_soul))
		{
			self.has_soul = undefined;
			stopfx(localclientnum, self.var_8020f50b);
			stopfx(localclientnum, self.var_9c121695);
		}
		self notify(#"snddeleteent");
	}
}

/*
	Name: snddeletesndent
	Namespace: zm_tomb_ee
	Checksum: 0x5BA95816
	Offset: 0xBF0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function snddeletesndent(ent)
{
	self util::waittill_any("death", "entityshutdown", "sndDeleteEnt");
	ent delete();
}

/*
	Name: function_a8fdf631
	Namespace: zm_tomb_ee
	Checksum: 0x2289C365
	Offset: 0xC50
	Size: 0x20C
	Parameters: 7
	Flags: Linked
*/
function function_a8fdf631(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	v_dest = getent(localclientnum, "ee_sam_portal", "targetname").origin;
	e_fx = spawn(localclientnum, self gettagorigin("J_SpineUpper"), "script_model");
	e_fx setmodel("tag_origin");
	playsound(localclientnum, "zmb_squest_charge_soul_leave", self.origin);
	e_fx playloopsound("zmb_squest_charge_soul_lp");
	playfxontag(localclientnum, level._effect["staff_soul"], e_fx, "tag_origin");
	e_fx moveto(v_dest + vectorscale((0, 0, 1), 5), 1);
	e_fx waittill(#"movedone");
	playsound(localclientnum, "zmb_squest_charge_soul_impact", v_dest);
	playfxontag(localclientnum, level._effect["staff_charge"], e_fx, "tag_origin");
	wait(0.3);
	e_fx delete();
}

/*
	Name: function_aff1c5b2
	Namespace: zm_tomb_ee
	Checksum: 0x9A1D1C0B
	Offset: 0xE68
	Size: 0x1BC
	Parameters: 7
	Flags: Linked
*/
function function_aff1c5b2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	e_fx = getent(localclientnum, "ee_sam_portal", "targetname");
	if(isdefined(e_fx.fx_id))
	{
		e_fx stoploopsound(5);
		stopfx(localclientnum, e_fx.fx_id);
	}
	if(newval == 1)
	{
		e_fx.fx_id = playfxontag(localclientnum, level._effect["foot_box_glow"], e_fx, "tag_origin");
		e_fx playloopsound("zmb_squest_sam_portal_closed_loop", 1);
	}
	else if(newval == 2)
	{
		if(isdefined(e_fx.fx_id))
		{
			stopfx(localclientnum, e_fx.fx_id);
		}
		playsound(0, "zmb_squest_sam_portal_open", e_fx.origin);
		e_fx playloopsound("zmb_squest_sam_portal_open_loop", 1);
	}
}

/*
	Name: function_19452a40
	Namespace: zm_tomb_ee
	Checksum: 0xBF792F42
	Offset: 0x1030
	Size: 0x16C
	Parameters: 7
	Flags: Linked
*/
function function_19452a40(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	while(true)
	{
		e_player = getlocalplayer(localclientnum);
		if(isdefined(e_player) && (isdefined(e_player.var_c5eb485f) && e_player.var_c5eb485f) && !isdefined(self.plane_fx))
		{
			self.plane_fx = playfxontag(localclientnum, level._effect["biplane_glow"], self, "tag_origin");
		}
		if(isdefined(e_player) && (!(isdefined(e_player.var_c5eb485f) && e_player.var_c5eb485f)) && isdefined(self.plane_fx))
		{
			stopfx(localclientnum, self.plane_fx);
			self.plane_fx = undefined;
		}
		wait(0.05);
	}
}

/*
	Name: function_74610c8a
	Namespace: zm_tomb_ee
	Checksum: 0xC2BF3970
	Offset: 0x11A8
	Size: 0x21C
	Parameters: 7
	Flags: Linked
*/
function function_74610c8a(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	a_structs = struct::get_array("tablet_charge_pos", "targetname");
	s_box = arraygetclosest(self.origin, a_structs);
	e_fx = spawn(localclientnum, self gettagorigin("J_SpineUpper"), "script_model");
	e_fx setmodel("tag_origin");
	e_fx playsound(localclientnum, "zmb_squest_charge_soul_leave");
	e_fx playloopsound("zmb_squest_charge_soul_lp");
	playfxontag(localclientnum, level._effect["staff_soul"], e_fx, "tag_origin");
	e_fx moveto(s_box.origin, 1);
	e_fx waittill(#"movedone");
	playsound(localclientnum, "zmb_squest_charge_soul_impact", e_fx.origin);
	playfxontag(localclientnum, level._effect["staff_charge"], e_fx, "tag_origin");
	wait(0.3);
	e_fx delete();
}

/*
	Name: function_b628a101
	Namespace: zm_tomb_ee
	Checksum: 0x8AB4C4B2
	Offset: 0x13D0
	Size: 0x12C
	Parameters: 7
	Flags: Linked
*/
function function_b628a101(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		if(!isdefined(self.var_e6c8ca8e))
		{
			self.var_e6c8ca8e = 1;
			self thread function_4e9276ed(localclientnum);
			self.m_reward = util::spawn_model(localclientnum, level.w_beacon.worldmodel, (-141, 4464, -322) + (8, 35, 20), self.angles);
			self.m_reward thread function_17bc361f(localclientnum);
		}
	}
	else if(isdefined(self.var_e6c8ca8e))
	{
		self.var_e6c8ca8e = 0;
		self notify(#"hash_7066982d");
		self.m_reward delete();
	}
}

/*
	Name: function_17bc361f
	Namespace: zm_tomb_ee
	Checksum: 0x38A003A0
	Offset: 0x1508
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function function_17bc361f(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"death");
	self util::waittill_dobj(localclientnum);
	playfxontag(localclientnum, level._effect["staff_soul"], self, "tag_origin");
	self playsound(localclientnum, "zmb_spawn_powerup");
	self playloopsound("zmb_spawn_powerup_loop", 0.5);
	self movey(-50, 2, 0, 1);
	self waittill(#"movedone");
	while(true)
	{
		self rotateyaw(360, 4);
		self waittill(#"rotatedone");
	}
}

/*
	Name: function_4e9276ed
	Namespace: zm_tomb_ee
	Checksum: 0x65AE7554
	Offset: 0x1628
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function function_4e9276ed(localclientnum)
{
	self endon(#"disconnect");
	self endon(#"hash_7066982d");
	while(true)
	{
		playfx(localclientnum, level._effect["bottle_glow"], (-141, 4464, -322) + (60, 10, 25));
		wait(0.1);
	}
}

/*
	Name: function_13792d2
	Namespace: zm_tomb_ee
	Checksum: 0xF654A93B
	Offset: 0x16B0
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_13792d2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	setuimodelvalue(getuimodel(getuimodelforcontroller(localclientnum), "TombEndGameBlackScreen"), newval);
}

