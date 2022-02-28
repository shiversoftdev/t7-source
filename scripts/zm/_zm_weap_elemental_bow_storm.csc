// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weap_elemental_bow;

#namespace _zm_weap_elemental_bow_storm;

/*
	Name: __init__sytem__
	Namespace: _zm_weap_elemental_bow_storm
	Checksum: 0xE5BF068
	Offset: 0x538
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("_zm_weap_elemental_bow_storm", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _zm_weap_elemental_bow_storm
	Checksum: 0xF0C12582
	Offset: 0x578
	Size: 0x372
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "elemental_bow_storm" + "_ambient_bow_fx", 5000, 1, "int", &function_e73829fb, 0, 0);
	clientfield::register("missile", "elemental_bow_storm" + "_arrow_impact_fx", 5000, 1, "int", &function_93740776, 0, 0);
	clientfield::register("missile", "elemental_bow_storm4" + "_arrow_impact_fx", 5000, 1, "int", &function_c50a03db, 0, 0);
	clientfield::register("scriptmover", "elem_storm_fx", 5000, 1, "int", &elem_storm_fx, 0, 0);
	clientfield::register("toplayer", "elem_storm_whirlwind_rumble", 1, 1, "int", &elem_storm_whirlwind_rumble, 0, 0);
	clientfield::register("scriptmover", "elem_storm_bolt_fx", 5000, 1, "int", &elem_storm_bolt_fx, 0, 0);
	clientfield::register("scriptmover", "elem_storm_zap_ambient", 5000, 1, "int", &elem_storm_zap_ambient, 0, 0);
	clientfield::register("actor", "elem_storm_shock_fx", 5000, 2, "int", &elem_storm_shock_fx, 0, 0);
	level._effect["elem_storm_ambient_bow"] = "dlc1/zmb_weapon/fx_bow_storm_ambient_1p_zmb";
	level._effect["elem_storm_arrow_impact"] = "dlc1/zmb_weapon/fx_bow_storm_impact_zmb";
	level._effect["elem_storm_arrow_charged_impact"] = "dlc1/zmb_weapon/fx_bow_storm_impact_ug_zmb";
	level._effect["elem_storm_whirlwind_loop"] = "dlc1/zmb_weapon/fx_bow_storm_funnel_loop_zmb";
	level._effect["elem_storm_whirlwind_end"] = "dlc1/zmb_weapon/fx_bow_storm_funnel_end_zmb";
	level._effect["elem_storm_zap_ambient"] = "dlc1/zmb_weapon/fx_bow_storm_orb_zmb";
	level._effect["elem_storm_zap_bolt"] = "dlc1/zmb_weapon/fx_bow_storm_bolt_zap_zmb";
	level._effect["elem_storm_shock_eyes"] = "zombie/fx_tesla_shock_eyes_zmb";
	level._effect["elem_storm_shock"] = "zombie/fx_tesla_shock_zmb";
	level._effect["elem_storm_shock_nonfatal"] = "zombie/fx_bmode_shock_os_zod_zmb";
}

/*
	Name: function_e73829fb
	Namespace: _zm_weap_elemental_bow_storm
	Checksum: 0x6825C11E
	Offset: 0x8F8
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_e73829fb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self zm_weap_elemental_bow::function_3158b481(localclientnum, newval, "elem_storm_ambient_bow");
}

/*
	Name: function_93740776
	Namespace: _zm_weap_elemental_bow_storm
	Checksum: 0x58223664
	Offset: 0x968
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_93740776(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["elem_storm_arrow_impact"], self.origin);
	}
}

/*
	Name: function_c50a03db
	Namespace: _zm_weap_elemental_bow_storm
	Checksum: 0xF325DA09
	Offset: 0x9E8
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_c50a03db(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["elem_storm_arrow_charged_impact"], self.origin);
	}
}

/*
	Name: elem_storm_fx
	Namespace: _zm_weap_elemental_bow_storm
	Checksum: 0x3C0431D5
	Offset: 0xA68
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function elem_storm_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(newval)
	{
		self.var_53f7dac0 = playfxontag(localclientnum, level._effect["elem_storm_whirlwind_loop"], self, "tag_origin");
	}
	else
	{
		if(isdefined(self.var_53f7dac0))
		{
			deletefx(localclientnum, self.var_53f7dac0, 0);
			self.var_53f7dac0 = undefined;
		}
		wait(0.4);
		playfx(localclientnum, level._effect["elem_storm_whirlwind_end"], self.origin);
	}
}

/*
	Name: elem_storm_whirlwind_rumble
	Namespace: _zm_weap_elemental_bow_storm
	Checksum: 0xB5894B1
	Offset: 0xB70
	Size: 0x6E
	Parameters: 7
	Flags: Linked
*/
function elem_storm_whirlwind_rumble(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self thread function_4d18057(localclientnum);
	}
	else
	{
		self notify(#"hash_171d986a");
	}
}

/*
	Name: function_4d18057
	Namespace: _zm_weap_elemental_bow_storm
	Checksum: 0xE46D7C5B
	Offset: 0xBE8
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function function_4d18057(localclientnum)
{
	level endon(#"demo_jump");
	self endon(#"hash_171d986a");
	self endon(#"death");
	while(isdefined(self))
	{
		self playrumbleonentity(localclientnum, "zod_idgun_vortex_interior");
		wait(0.075);
	}
}

/*
	Name: elem_storm_bolt_fx
	Namespace: _zm_weap_elemental_bow_storm
	Checksum: 0x542B354B
	Offset: 0xC50
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function elem_storm_bolt_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(isdefined(self.var_ca6ae14c))
		{
			deletefx(localclientnum, self.var_ca6ae14c, 0);
			self.var_ca6ae14c = undefined;
		}
		v_forward = anglestoforward(self.angles);
		v_up = anglestoup(self.angles);
		self.var_ca6ae14c = playfxontag(localclientnum, level._effect["elem_storm_zap_bolt"], self, "tag_origin");
	}
}

/*
	Name: elem_storm_zap_ambient
	Namespace: _zm_weap_elemental_bow_storm
	Checksum: 0xF60246DD
	Offset: 0xD58
	Size: 0xA6
	Parameters: 7
	Flags: Linked
*/
function elem_storm_zap_ambient(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.var_dab5ed7 = playfxontag(localclientnum, level._effect["elem_storm_zap_ambient"], self, "tag_origin");
	}
	else
	{
		deletefx(localclientnum, self.var_dab5ed7, 0);
		self.var_dab5ed7 = undefined;
	}
}

/*
	Name: elem_storm_shock_fx
	Namespace: _zm_weap_elemental_bow_storm
	Checksum: 0x44F5A072
	Offset: 0xE08
	Size: 0x25E
	Parameters: 7
	Flags: Linked
*/
function elem_storm_shock_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	tag = (self isai() ? "J_SpineUpper" : "tag_origin");
	switch(newval)
	{
		case 0:
		{
			if(isdefined(self.var_a9b1ee1b))
			{
				deletefx(localclientnum, self.var_a9b1ee1b, 1);
			}
			if(isdefined(self.var_ae1320f9))
			{
				deletefx(localclientnum, self.var_ae1320f9, 1);
			}
			if(isdefined(self.var_523596b1))
			{
				deletefx(localclientnum, self.var_523596b1, 1);
			}
			self.var_a9b1ee1b = undefined;
			self.var_ae1320f9 = undefined;
			self.var_bb955880 = undefined;
			break;
		}
		case 1:
		{
			if(!isdefined(self.var_ae1320f9))
			{
				self.var_ae1320f9 = playfxontag(localclientnum, level._effect["elem_storm_shock"], self, tag);
			}
			break;
		}
		case 2:
		{
			if(!isdefined(self.var_a9b1ee1b))
			{
				self.var_111812ed = playfxontag(localclientnum, level._effect["elem_storm_shock_eyes"], self, "J_Eyeball_LE");
			}
			if(!isdefined(self.var_ae1320f9))
			{
				self.var_ae1320f9 = playfxontag(localclientnum, level._effect["elem_storm_shock"], self, tag);
			}
			if(!isdefined(self.var_523596b1))
			{
				self.var_523596b1 = playfxontag(localclientnum, level._effect["elem_storm_shock_nonfatal"], self, tag);
			}
			break;
		}
	}
}

