// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace zm_castle_death_ray_trap;

/*
	Name: main
	Namespace: zm_castle_death_ray_trap
	Checksum: 0xE332F20F
	Offset: 0x3D8
	Size: 0x264
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level._effect["console_green_light"] = "dlc1/castle/fx_glow_panel_green_castle";
	level._effect["console_red_light"] = "dlc1/castle/fx_glow_panel_red_castle";
	level._effect["tesla_zombie_shock"] = "dlc1/castle/fx_tesla_trap_body_shock";
	level._effect["tesla_zombie_explode"] = "dlc1/castle/fx_tesla_trap_body_exp";
	clientfield::register("actor", "death_ray_shock_fx", 5000, 1, "int", &death_ray_shock_fx, 0, 0);
	clientfield::register("actor", "death_ray_shock_eye_fx", 5000, 1, "int", &death_ray_shock_eye_fx, 0, 0);
	clientfield::register("actor", "death_ray_explode_fx", 5000, 1, "counter", &death_ray_explode_fx, 0, 0);
	clientfield::register("scriptmover", "death_ray_status_light", 5000, 2, "int", &death_ray_status_light, 0, 0);
	clientfield::register("actor", "tesla_beam_fx", 5000, 1, "counter", &function_200eea36, 0, 0);
	clientfield::register("toplayer", "tesla_beam_fx", 5000, 1, "counter", &function_200eea36, 0, 0);
	clientfield::register("actor", "tesla_beam_mechz", 5000, 1, "int", &tesla_beam_mechz, 0, 0);
}

/*
	Name: death_ray_shock_fx
	Namespace: zm_castle_death_ray_trap
	Checksum: 0x7E36BEDB
	Offset: 0x648
	Size: 0x124
	Parameters: 7
	Flags: Linked
*/
function death_ray_shock_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self function_51adc559(localclientnum);
	if(newval)
	{
		if(!isdefined(self.tesla_shock_fx))
		{
			tag = "J_SpineUpper";
			if(!self isai())
			{
				tag = "tag_origin";
			}
			self.tesla_shock_fx = playfxontag(localclientnum, level._effect["tesla_zombie_shock"], self, tag);
			self playsound(0, "zmb_electrocute_zombie");
		}
		if(isdemoplaying())
		{
			self thread function_7772592b(localclientnum);
		}
	}
}

/*
	Name: function_7772592b
	Namespace: zm_castle_death_ray_trap
	Checksum: 0xDC26AB0D
	Offset: 0x778
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_7772592b(localclientnum)
{
	self notify(#"hash_51adc559");
	self endon(#"hash_51adc559");
	level waittill(#"demo_jump");
	self function_51adc559(localclientnum);
}

/*
	Name: function_51adc559
	Namespace: zm_castle_death_ray_trap
	Checksum: 0xB62D7854
	Offset: 0x7D0
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function function_51adc559(localclientnum)
{
	if(isdefined(self.tesla_shock_fx))
	{
		deletefx(localclientnum, self.tesla_shock_fx, 1);
		self.tesla_shock_fx = undefined;
	}
	self notify(#"hash_51adc559");
}

/*
	Name: death_ray_shock_eye_fx
	Namespace: zm_castle_death_ray_trap
	Checksum: 0x68D17467
	Offset: 0x830
	Size: 0xC6
	Parameters: 7
	Flags: Linked
*/
function death_ray_shock_eye_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(!isdefined(self.var_5f35d5e4))
		{
			self.var_5f35d5e4 = playfxontag(localclientnum, level._effect["death_ray_shock_eyes"], self, "J_Eyeball_LE");
		}
	}
	else
	{
		deletefx(localclientnum, self.var_5f35d5e4, 1);
		self.var_5f35d5e4 = undefined;
	}
}

/*
	Name: death_ray_explode_fx
	Namespace: zm_castle_death_ray_trap
	Checksum: 0xC097A2B8
	Offset: 0x900
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function death_ray_explode_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["tesla_zombie_explode"], self, "j_spine4");
}

/*
	Name: death_ray_status_light
	Namespace: zm_castle_death_ray_trap
	Checksum: 0x2CC74244
	Offset: 0x978
	Size: 0x17C
	Parameters: 7
	Flags: Linked
*/
function death_ray_status_light(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	v_forward = anglestoright(self.angles);
	v_forward = v_forward * -1;
	v_up = anglestoup(self.angles);
	if(isdefined(self.status_fx))
	{
		deletefx(localclientnum, self.status_fx, 1);
		self.status_fx = undefined;
	}
	switch(newval)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			str_fx_name = "console_green_light";
			tag = "tag_fx_light_green";
			break;
		}
		case 2:
		{
			str_fx_name = "console_red_light";
			tag = "tag_fx_light_red";
			break;
		}
	}
	self.status_fx = playfxontag(localclientnum, level._effect[str_fx_name], self, tag);
}

/*
	Name: function_200eea36
	Namespace: zm_castle_death_ray_trap
	Checksum: 0x1ABB6518
	Offset: 0xB00
	Size: 0x13C
	Parameters: 7
	Flags: Linked
*/
function function_200eea36(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_fda0d24 = [];
	array::add(var_fda0d24, struct::get("bolt_source_1"), 0);
	array::add(var_fda0d24, struct::get("bolt_source_2"), 0);
	s_source = arraygetclosest(self.origin, var_fda0d24);
	if(s_source.targetname === "bolt_source_1")
	{
		var_53106e7c = "electric_arc_beam_tesla_trap_1_primary";
	}
	else
	{
		var_53106e7c = "electric_arc_beam_tesla_trap_2_primary";
	}
	self thread function_ec4ecaed(localclientnum, s_source, var_53106e7c);
}

/*
	Name: function_ec4ecaed
	Namespace: zm_castle_death_ray_trap
	Checksum: 0x4E3EE856
	Offset: 0xC48
	Size: 0xFC
	Parameters: 3
	Flags: Linked
*/
function function_ec4ecaed(localclientnum, s_source, var_53106e7c)
{
	var_e43465f2 = util::spawn_model(localclientnum, "tag_origin", s_source.origin, s_source.angles);
	level beam::launch(var_e43465f2, "tag_origin", self, "j_spinelower", var_53106e7c);
	level util::waittill_any_timeout(1.5, "demo_jump");
	level beam::kill(var_e43465f2, "tag_origin", self, "j_spinelower", var_53106e7c);
	var_e43465f2 delete();
}

/*
	Name: tesla_beam_mechz
	Namespace: zm_castle_death_ray_trap
	Checksum: 0x8E946630
	Offset: 0xD50
	Size: 0x1D4
	Parameters: 7
	Flags: Linked
*/
function tesla_beam_mechz(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		var_fda0d24 = [];
		array::add(var_fda0d24, struct::get("bolt_source_1"), 0);
		array::add(var_fda0d24, struct::get("bolt_source_2"), 0);
		s_source = arraygetclosest(self.origin, var_fda0d24);
		if(s_source.targetname === "bolt_source_1")
		{
			self.var_53106e7c = "electric_arc_beam_tesla_trap_1_primary";
		}
		else
		{
			self.var_53106e7c = "electric_arc_beam_tesla_trap_2_primary";
		}
		self.var_e43465f2 = util::spawn_model(localclientnum, "tag_origin", s_source.origin, s_source.angles);
		level beam::launch(self.var_e43465f2, "tag_origin", self, "j_spinelower", self.var_53106e7c);
		if(isdemoplaying())
		{
			self thread function_3c5fc735(localclientnum);
		}
	}
	else
	{
		function_1139a457(localclientnum);
	}
}

/*
	Name: function_3c5fc735
	Namespace: zm_castle_death_ray_trap
	Checksum: 0xA92B0A90
	Offset: 0xF30
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_3c5fc735(localclientnum)
{
	self notify(#"hash_1139a457");
	self endon(#"hash_1139a457");
	level waittill(#"demo_jump");
	function_1139a457(localclientnum);
}

/*
	Name: function_1139a457
	Namespace: zm_castle_death_ray_trap
	Checksum: 0x6EC0DC46
	Offset: 0xF88
	Size: 0x8A
	Parameters: 1
	Flags: Linked
*/
function function_1139a457(localclientnum)
{
	if(isdefined(self.var_e43465f2) && isdefined(self.var_53106e7c))
	{
		level beam::kill(self.var_e43465f2, "tag_origin", self, "j_spinelower", self.var_53106e7c);
		self.var_e43465f2 delete();
		self.var_53106e7c = undefined;
		self notify(#"hash_1139a457");
	}
}

