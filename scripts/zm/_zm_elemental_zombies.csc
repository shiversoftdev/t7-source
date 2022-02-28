// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_elemental_zombie;

/*
	Name: __init__sytem__
	Namespace: zm_elemental_zombie
	Checksum: 0x5FC02860
	Offset: 0x460
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_elemental_zombie", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_elemental_zombie
	Checksum: 0xE383E8E9
	Offset: 0x4A0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_fx();
	register_clientfields();
}

/*
	Name: init_fx
	Namespace: zm_elemental_zombie
	Checksum: 0x2BCD3D02
	Offset: 0x4D0
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function init_fx()
{
	level._effect["elemental_zombie_sparky"] = "electric/fx_ability_elec_surge_short_robot_optim";
	level._effect["elemental_sparky_zombie_suicide"] = "explosions/fx_ability_exp_ravage_core_optim";
	level._effect["elemental_zombie_fire_damage"] = "fire/fx_embers_burst_optim";
	level._effect["elemental_napalm_zombie_suicide"] = "explosions/fx_exp_dest_barrel_concussion_sm_optim";
	level._effect["elemental_zombie_spark_light"] = "light/fx_light_spark_chest_zombie_optim";
	level._effect["elemental_electric_spark"] = "electric/fx_elec_sparks_burst_blue_optim";
}

/*
	Name: register_clientfields
	Namespace: zm_elemental_zombie
	Checksum: 0x316B7DC
	Offset: 0x588
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("actor", "sparky_zombie_spark_fx", 1, 1, "int", &function_de563d9b, 0, 0);
	clientfield::register("actor", "sparky_zombie_death_fx", 1, 1, "int", &function_d0886efe, 0, 0);
	clientfield::register("actor", "napalm_zombie_death_fx", 1, 1, "int", &function_56ad3a27, 0, 0);
	clientfield::register("actor", "sparky_damaged_fx", 1, 1, "counter", &function_86aaed61, 0, 0);
	clientfield::register("actor", "napalm_damaged_fx", 1, 1, "counter", &function_16467cb6, 0, 0);
	clientfield::register("actor", "napalm_sfx", 11000, 1, "int", &function_b542950d, 0, 0);
}

/*
	Name: function_56ad3a27
	Namespace: zm_elemental_zombie
	Checksum: 0xD6EDB583
	Offset: 0x748
	Size: 0xD4
	Parameters: 7
	Flags: Linked
*/
function function_56ad3a27(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(oldval !== newval && newval === 1)
	{
		fx = playfxontag(localclientnum, level._effect["elemental_napalm_zombie_suicide"], self, "j_spineupper");
		self playsound(0, "zmb_elemental_zombie_explode_fire");
	}
}

/*
	Name: function_16467cb6
	Namespace: zm_elemental_zombie
	Checksum: 0x3EF127A7
	Offset: 0x828
	Size: 0x144
	Parameters: 7
	Flags: Linked
*/
function function_16467cb6(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		if(isdefined(level._effect["elemental_zombie_fire_damage"]))
		{
			playsound(localclientnum, "gdt_electro_bounce", self.origin);
			locs = array("j_wrist_le", "j_wrist_ri");
			fx = playfxontag(localclientnum, level._effect["elemental_zombie_fire_damage"], self, array::random(locs));
			setfxignorepause(localclientnum, fx, 1);
		}
	}
}

/*
	Name: function_b542950d
	Namespace: zm_elemental_zombie
	Checksum: 0x18EA6107
	Offset: 0x978
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_b542950d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(!isdefined(self.var_1f5b576b))
		{
			self.var_1f5b576b = self playloopsound("zmb_elemental_zombie_loop_fire", 0.2);
		}
	}
}

/*
	Name: function_de563d9b
	Namespace: zm_elemental_zombie
	Checksum: 0xDF7BCE1
	Offset: 0xA08
	Size: 0x1BC
	Parameters: 7
	Flags: Linked
*/
function function_de563d9b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	if(newval == 1)
	{
		if(!isdefined(self.var_e863c331))
		{
			self.var_e863c331 = self playloopsound("zmb_electrozomb_lp", 0.2);
		}
		str_tag = "J_SpineUpper";
		if(isdefined(self.var_46d9c2ee))
		{
			str_tag = self.var_46d9c2ee;
		}
		str_fx = level._effect["elemental_zombie_sparky"];
		if(isdefined(self.var_7abb4217))
		{
			str_fx = self.var_7abb4217;
		}
		fx = playfxontag(localclientnum, str_fx, self, str_tag);
		setfxignorepause(localclientnum, fx, 1);
		var_4473cd0 = level._effect["elemental_zombie_spark_light"];
		if(isdefined(self.var_e22d3880))
		{
			var_4473cd0 = self.var_e22d3880;
		}
		fx = playfxontag(localclientnum, var_4473cd0, self, str_tag);
		setfxignorepause(localclientnum, fx, 1);
	}
}

/*
	Name: function_d0886efe
	Namespace: zm_elemental_zombie
	Checksum: 0xD3AFC9BD
	Offset: 0xBD0
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function function_d0886efe(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(oldval !== newval && newval === 1)
	{
		fx = playfxontag(localclientnum, level._effect["elemental_sparky_zombie_suicide"], self, "j_spineupper");
		self playsound(0, "zmb_elemental_zombie_explode_elec");
	}
}

/*
	Name: function_86aaed61
	Namespace: zm_elemental_zombie
	Checksum: 0x1DBD399
	Offset: 0xC90
	Size: 0x12C
	Parameters: 7
	Flags: Linked
*/
function function_86aaed61(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(newval))
	{
		return;
	}
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval >= 1)
	{
		if(!isdefined(self.var_e863c331))
		{
			self.var_e863c331 = self playloopsound("zmb_electrozomb_lp", 0.2);
		}
		fx = playfxontag(localclientnum, level._effect["elemental_electric_spark"], self, "J_SpineUpper");
		setfxignorepause(localclientnum, fx, 1);
	}
}

