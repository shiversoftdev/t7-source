// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;

#using_animtree("generic");

#namespace zm_island_skullquest;

/*
	Name: init
	Namespace: zm_island_skullquest
	Checksum: 0xD237F9CA
	Offset: 0x680
	Size: 0x31C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("world", "keeper_spawn_portals", 1, 1, "int", &keeper_spawn_portals, 0, 0);
	clientfield::register("actor", "keeper_fx", 1, 1, "int", &keeper_fx, 0, 0);
	clientfield::register("actor", "ritual_attacker_fx", 1, 1, "int", &ritual_attacker_fx, 0, 0);
	clientfield::register("world", "skullquest_ritual_1_fx", 1, 3, "int", &skullquest_ritual_1_fx, 0, 0);
	clientfield::register("world", "skullquest_ritual_2_fx", 1, 3, "int", &skullquest_ritual_2_fx, 0, 0);
	clientfield::register("world", "skullquest_ritual_3_fx", 1, 3, "int", &skullquest_ritual_3_fx, 0, 0);
	clientfield::register("world", "skullquest_ritual_4_fx", 1, 3, "int", &skullquest_ritual_4_fx, 0, 0);
	clientfield::register("scriptmover", "skullquest_finish_start_fx", 1, 1, "int", &skullquest_finish_start_fx, 0, 0);
	clientfield::register("scriptmover", "skullquest_finish_trail_fx", 1, 1, "int", &skullquest_finish_trail_fx, 0, 0);
	clientfield::register("scriptmover", "skullquest_finish_end_fx", 1, 1, "int", &skullquest_finish_end_fx, 0, 0);
	clientfield::register("scriptmover", "skullquest_finish_done_glow_fx", 1, 1, "int", &skullquest_finish_done_glow_fx, 0, 0);
}

/*
	Name: keeper_spawn_portals
	Namespace: zm_island_skullquest
	Checksum: 0x2389690D
	Offset: 0x9A8
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function keeper_spawn_portals(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_eebff756 = "s_spawnpt_skullroom";
	function_46df8306(localclientnum, var_eebff756, newval);
}

/*
	Name: function_46df8306
	Namespace: zm_island_skullquest
	Checksum: 0xB7E64CBA
	Offset: 0xA20
	Size: 0x252
	Parameters: 3
	Flags: Linked
*/
function function_46df8306(localclientnum, str_name, b_on = 1)
{
	a_s_spawn_points = struct::get_array(str_name, "targetname");
	foreach(s_spawn_point in a_s_spawn_points)
	{
		s_spawn_point function_267f859f(localclientnum, level._effect["keeper_spawn"], b_on);
		if(!isdefined(s_spawn_point.var_d52fc488))
		{
			s_spawn_point.var_d52fc488 = 0;
		}
		if(isdefined(b_on) && b_on)
		{
			if(!(isdefined(s_spawn_point.var_d52fc488) && s_spawn_point.var_d52fc488))
			{
				s_spawn_point.var_d52fc488 = 1;
				playsound(0, "evt_keeper_portal_start", s_spawn_point.origin);
				audio::playloopat("evt_keeper_portal_loop", s_spawn_point.origin);
			}
		}
		else if(isdefined(s_spawn_point.var_d52fc488) && s_spawn_point.var_d52fc488)
		{
			s_spawn_point.var_d52fc488 = 0;
			playsound(0, "evt_keeper_portal_end", s_spawn_point.origin);
			audio::stoploopat("evt_keeper_portal_loop", s_spawn_point.origin);
		}
		wait(0.2);
	}
}

/*
	Name: function_f58977cd
	Namespace: zm_island_skullquest
	Checksum: 0x79B67A64
	Offset: 0xC80
	Size: 0x2B2
	Parameters: 3
	Flags: Linked
*/
function function_f58977cd(localclientnum, str_name, b_on = 1)
{
	a_s_spawn_points = struct::get_array(str_name, "targetname");
	foreach(s_spawn_point in a_s_spawn_points)
	{
		s_spawn_point function_267f859f(localclientnum, level._effect["ritual_portal_start"], b_on);
		s_spawn_point function_267f859f(localclientnum, level._effect["ritual_portal_loop"], b_on);
		if(!isdefined(s_spawn_point.var_d52fc488))
		{
			s_spawn_point.var_d52fc488 = 0;
		}
		if(isdefined(b_on) && b_on)
		{
			if(!(isdefined(s_spawn_point.var_d52fc488) && s_spawn_point.var_d52fc488))
			{
				s_spawn_point.var_d52fc488 = 1;
				playsound(0, "zmb_skull_ritual_portal_start", s_spawn_point.origin);
				audio::playloopat("zmb_skull_ritual_portal_lp", s_spawn_point.origin);
			}
		}
		else
		{
			s_spawn_point function_267f859f(localclientnum, level._effect["ritual_portal_end"], b_on);
			if(isdefined(s_spawn_point.var_d52fc488) && s_spawn_point.var_d52fc488)
			{
				s_spawn_point.var_d52fc488 = 0;
				playsound(0, "zmb_skull_ritual_portal_end", s_spawn_point.origin);
				audio::stoploopat("zmb_skull_ritual_portal_lp", s_spawn_point.origin);
			}
		}
		wait(0.2);
	}
}

/*
	Name: skullquest_ritual_1_fx
	Namespace: zm_island_skullquest
	Checksum: 0x34401FF1
	Offset: 0xF40
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function skullquest_ritual_1_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_4dcbb3a6(localclientnum, 1, newval);
}

/*
	Name: skullquest_ritual_2_fx
	Namespace: zm_island_skullquest
	Checksum: 0x7EA0A920
	Offset: 0xFA8
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function skullquest_ritual_2_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_4dcbb3a6(localclientnum, 2, newval);
}

/*
	Name: skullquest_ritual_3_fx
	Namespace: zm_island_skullquest
	Checksum: 0x56E08271
	Offset: 0x1010
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function skullquest_ritual_3_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_4dcbb3a6(localclientnum, 3, newval);
}

/*
	Name: skullquest_ritual_4_fx
	Namespace: zm_island_skullquest
	Checksum: 0xF0E869E6
	Offset: 0x1078
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function skullquest_ritual_4_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_4dcbb3a6(localclientnum, 4, newval);
}

/*
	Name: function_4dcbb3a6
	Namespace: zm_island_skullquest
	Checksum: 0x481F07CF
	Offset: 0x10E0
	Size: 0x49C
	Parameters: 3
	Flags: Linked
*/
function function_4dcbb3a6(localclientnum, var_f2e38849, n_fx_type = 1)
{
	var_f4fc4e39[0] = "";
	var_f4fc4e39[1] = level._effect["ritual_progress_skull"];
	var_f4fc4e39[2] = level._effect["ritual_progress_skull_75"];
	var_f4fc4e39[3] = level._effect["ritual_progress_skull_50"];
	var_f4fc4e39[4] = level._effect["ritual_progress_skull_25"];
	var_d9cf2ecd = struct::get_array("s_skulltar_skull_pos", "targetname");
	foreach(var_89669ffb in var_d9cf2ecd)
	{
		if(var_89669ffb.script_special == var_f2e38849)
		{
			var_b9533b1f = var_89669ffb;
			break;
		}
	}
	var_14c8adef = struct::get_array("s_skulltar_base_pos", "targetname");
	foreach(var_9915798f in var_14c8adef)
	{
		if(var_9915798f.script_special == var_f2e38849)
		{
			var_4b429234 = var_9915798f;
		}
	}
	var_4a347901 = ("skulltar_" + var_f2e38849) + "_spawnpts";
	if(isdefined(n_fx_type) && n_fx_type >= 0 && n_fx_type < 5)
	{
		var_b9533b1f function_267f859f(localclientnum, var_f4fc4e39[n_fx_type], n_fx_type);
		var_4b429234 function_267f859f(localclientnum, level._effect["ritual_progress_skulltar"], n_fx_type);
		if(n_fx_type > 0)
		{
			if(n_fx_type === 1)
			{
				level thread function_f58977cd(localclientnum, var_4a347901, 1);
			}
			if(!(isdefined(var_b9533b1f.var_d52fc488) && var_b9533b1f.var_d52fc488))
			{
				var_b9533b1f.var_d52fc488 = 1;
			}
		}
		else if(isdefined(var_b9533b1f.var_d52fc488) && var_b9533b1f.var_d52fc488)
		{
			var_b9533b1f.var_d52fc488 = 0;
		}
	}
	else
	{
		level thread function_f58977cd(localclientnum, var_4a347901, 0);
		if(n_fx_type === 5)
		{
			var_b9533b1f function_267f859f(localclientnum, level._effect["ritual_success_skull"], 1);
			var_4b429234 function_267f859f(localclientnum, level._effect["ritual_progress_skulltar"], 0);
		}
		else if(n_fx_type === 6)
		{
			var_b9533b1f function_267f859f(localclientnum, level._effect["ritual_progress_skull_fail"], 1);
			var_4b429234 function_267f859f(localclientnum, level._effect["ritual_progress_skulltar"], 0);
		}
	}
	wait(0.2);
}

/*
	Name: skullquest_finish_start_fx
	Namespace: zm_island_skullquest
	Checksum: 0xA81AB803
	Offset: 0x1588
	Size: 0xBE
	Parameters: 7
	Flags: Linked
*/
function skullquest_finish_start_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_2c75d806 = playfxontag(localclientnum, level._effect["skullquest_finish_start"], self, "tag_origin");
	}
	else
	{
		if(isdefined(self.var_2c75d806))
		{
			stopfx(localclientnum, self.var_2c75d806);
		}
		self.var_2c75d806 = undefined;
	}
}

/*
	Name: skullquest_finish_trail_fx
	Namespace: zm_island_skullquest
	Checksum: 0x4F20FFDA
	Offset: 0x1650
	Size: 0xBE
	Parameters: 7
	Flags: Linked
*/
function skullquest_finish_trail_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_8d24a0fa = playfxontag(localclientnum, level._effect["skullquest_finish_trail"], self, "tag_origin");
	}
	else
	{
		if(isdefined(self.var_8d24a0fa))
		{
			stopfx(localclientnum, self.var_8d24a0fa);
		}
		self.var_8d24a0fa = undefined;
	}
}

/*
	Name: skullquest_finish_end_fx
	Namespace: zm_island_skullquest
	Checksum: 0x3870CE87
	Offset: 0x1718
	Size: 0xBE
	Parameters: 7
	Flags: Linked
*/
function skullquest_finish_end_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_f88006a5 = playfxontag(localclientnum, level._effect["skullquest_finish_end"], self, "tag_origin");
	}
	else
	{
		if(isdefined(self.var_f88006a5))
		{
			stopfx(localclientnum, self.var_f88006a5);
		}
		self.var_f88006a5 = undefined;
	}
}

/*
	Name: skullquest_finish_done_glow_fx
	Namespace: zm_island_skullquest
	Checksum: 0xD0B5E4D4
	Offset: 0x17E0
	Size: 0xBE
	Parameters: 7
	Flags: Linked
*/
function skullquest_finish_done_glow_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_f88006a5 = playfxontag(localclientnum, level._effect["skullquest_skull_done_glow"], self, "tag_origin");
	}
	else
	{
		if(isdefined(self.var_f88006a5))
		{
			stopfx(localclientnum, self.var_f88006a5);
		}
		self.var_f88006a5 = undefined;
	}
}

/*
	Name: keeper_fx
	Namespace: zm_island_skullquest
	Checksum: 0x4B7DC518
	Offset: 0x18A8
	Size: 0x29C
	Parameters: 7
	Flags: Linked
*/
function keeper_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self util::waittill_dobj(localclientnum);
	if(isdefined(self))
	{
		if(newval === 1)
		{
			self.var_341f7209 = playfxontag(localclientnum, level._effect["keeper_glow"], self, "j_spineupper");
			self.var_c5e3cf4b = playfxontag(localclientnum, level._effect["keeper_mouth"], self, "j_head");
			self.var_2d3cc156 = playfxontag(localclientnum, level._effect["keeper_trail"], self, "j_robe_front_03");
			if(!isdefined(self.sndlooper))
			{
				self.sndlooper = self playloopsound("zmb_keeper_looper");
			}
		}
		else
		{
			if(isdefined(self.var_341f7209))
			{
				stopfx(localclientnum, self.var_341f7209);
			}
			self.var_341f7209 = undefined;
			if(isdefined(self.var_c5e3cf4b))
			{
				stopfx(localclientnum, self.var_c5e3cf4b);
			}
			self.var_c5e3cf4b = undefined;
			if(isdefined(self.var_2d3cc156))
			{
				stopfx(localclientnum, self.var_2d3cc156);
			}
			self.var_2d3cc156 = undefined;
			v_origin = self gettagorigin("j_spineupper");
			v_angles = self gettagangles("j_spineupper");
			if(isdefined(v_origin) && isdefined(v_angles))
			{
				playfx(localclientnum, level._effect["keeper_death"], v_origin, v_angles);
			}
			self stopallloopsounds(1);
		}
	}
}

/*
	Name: ritual_attacker_fx
	Namespace: zm_island_skullquest
	Checksum: 0xA5F91755
	Offset: 0x1B50
	Size: 0x214
	Parameters: 7
	Flags: Linked
*/
function ritual_attacker_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self util::waittill_dobj(localclientnum);
	if(isdefined(self))
	{
		if(newval === 1)
		{
			if(self.archetype === "zombie")
			{
				self.var_341f7209 = playfxontag(localclientnum, level._effect["ritual_attacker"], self, "j_spine4");
			}
			else
			{
				self.var_341f7209 = playfxontag(localclientnum, level._effect["ritual_attacker"], self, "tag_origin");
			}
			if(!isdefined(self.sndlooper))
			{
				self.sndlooper = self playloopsound("zmb_keeper_looper");
			}
		}
		else
		{
			if(isdefined(self.var_341f7209))
			{
				stopfx(localclientnum, self.var_341f7209);
				self.var_341f7209 = undefined;
			}
			v_origin = self gettagorigin("tag_origin");
			v_angles = self gettagangles("tag_origin");
			if(isdefined(v_origin) && isdefined(v_angles))
			{
				playfx(localclientnum, level._effect["keeper_death"], v_origin, v_angles);
			}
			self stopallloopsounds(1);
		}
	}
}

/*
	Name: function_267f859f
	Namespace: zm_island_skullquest
	Checksum: 0x858EA291
	Offset: 0x1D70
	Size: 0x1A8
	Parameters: 5
	Flags: Linked
*/
function function_267f859f(localclientnum, fx_id = undefined, b_on = 1, var_afcc5d76 = 0, str_tag = "tag_origin")
{
	if(!isdefined(self.vfx_ref))
	{
		self.vfx_ref = [];
	}
	if(b_on)
	{
		if(!isdefined(self))
		{
			return;
		}
		if(isdefined(self.vfx_ref[localclientnum]))
		{
			stopfx(localclientnum, self.vfx_ref[localclientnum]);
		}
		if(var_afcc5d76)
		{
			self.vfx_ref[localclientnum] = playfxontag(localclientnum, fx_id, self, str_tag);
		}
		else
		{
			self.vfx_ref[localclientnum] = playfx(localclientnum, fx_id, self.origin, anglestoforward(self.angles));
		}
	}
	else if(isdefined(self.vfx_ref[localclientnum]))
	{
		stopfx(localclientnum, self.vfx_ref[localclientnum]);
		self.vfx_ref[localclientnum] = undefined;
	}
}

