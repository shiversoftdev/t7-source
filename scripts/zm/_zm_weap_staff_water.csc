// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weap_staff_common;

#namespace zm_weap_staff_water;

/*
	Name: __init__sytem__
	Namespace: zm_weap_staff_water
	Checksum: 0x19AF50FB
	Offset: 0x2E0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_staff_water", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_staff_water
	Checksum: 0x25546EB0
	Offset: 0x320
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "staff_blizzard_fx", 21000, 1, "int", &staff_blizzard_fx, 1, 0);
	clientfield::register("actor", "attach_bullet_model", 21000, 1, "int", &attach_model, 0, 0);
	clientfield::register("actor", "staff_shatter_fx", 21000, 1, "int", &staff_shatter_fx, 0, 0);
	level._effect["staff_water_blizzard"] = "dlc5/zmb_weapon/fx_staff_ice_impact_ug_hit";
	level._effect["staff_water_ice_shard"] = "dlc5/zmb_weapon/fx_staff_ice_trail_bolt";
	level._effect["staff_water_shatter"] = "dlc5/zmb_weapon/fx_staff_ice_exp";
	clientfield::register("actor", "anim_rate", 21000, 2, "float", undefined, 0, 0);
	setupclientfieldanimspeedcallbacks("actor", 1, "anim_rate");
	zm_weap_staff::function_4be5e665(getweapon("staff_water_upgraded"), "dlc5/zmb_weapon/fx_staff_charge_ice_lv1");
}

/*
	Name: attach_model
	Namespace: zm_weap_staff_water
	Checksum: 0xE02FC1BB
	Offset: 0x4E8
	Size: 0x134
	Parameters: 7
	Flags: Linked
*/
function attach_model(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		if(isdefined(self.var_69090dac))
		{
			stopfx(localclientnum, self.var_69090dac);
		}
		self.var_69090dac = playfxontag(localclientnum, level._effect["staff_water_ice_shard"], self, "j_spine4");
		self thread function_9a8e9819(localclientnum);
		self playsound(0, "wpn_waterstaff_freeze_zombie");
	}
	else
	{
		if(isdefined(self.var_69090dac))
		{
			deletefx(localclientnum, self.var_69090dac);
			self.var_69090dac = undefined;
		}
		self thread function_56ddd8d9(localclientnum);
	}
}

/*
	Name: function_9a8e9819
	Namespace: zm_weap_staff_water
	Checksum: 0x68303D64
	Offset: 0x628
	Size: 0xEA
	Parameters: 1
	Flags: Linked
*/
function function_9a8e9819(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"unfreeze");
	var_5e5728a8 = 0.9;
	rate = randomfloatrange(0.005, 0.01);
	f = 0.6;
	while(f <= var_5e5728a8)
	{
		self setshaderconstant(localclientnum, 0, f, 1, 0, 0);
		util::server_wait(localclientnum, 0.05);
		f = f + 0.01;
	}
}

/*
	Name: function_56ddd8d9
	Namespace: zm_weap_staff_water
	Checksum: 0x8199D85B
	Offset: 0x720
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_56ddd8d9(localclientnum)
{
	self endon(#"entityshutdown");
	self notify(#"unfreeze");
	f = 1;
	while(f >= 0.6)
	{
		self setshaderconstant(localclientnum, 0, f, 1, 0, 0);
		util::server_wait(localclientnum, 0.05);
		f = f - 0.05;
	}
	self setshaderconstant(localclientnum, 0, 0, 0, 0, 0);
}

/*
	Name: staff_blizzard_fx
	Namespace: zm_weap_staff_water
	Checksum: 0x5FAD75C0
	Offset: 0x7F0
	Size: 0x19E
	Parameters: 7
	Flags: Linked
*/
function staff_blizzard_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		self.var_80b4df3 = playfxontag(localclientnum, level._effect["staff_water_blizzard"], self, "tag_origin");
		if(!isdefined(self.sndent))
		{
			self.sndent = spawn(0, self.origin, "script_origin");
			self.sndent playsound(0, "wpn_waterstaff_storm_imp");
			self.sndent.n_id = self.sndent playloopsound("wpn_waterstaff_storm");
		}
	}
	else
	{
		if(isdefined(self.var_80b4df3))
		{
			stopfx(localclientnum, self.var_80b4df3);
		}
		if(isdefined(self.sndent))
		{
			self.sndent stoploopsound(self.sndent.n_id, 1.5);
			self.sndent delete();
			self.sndent = undefined;
		}
	}
}

/*
	Name: staff_shatter_fx
	Namespace: zm_weap_staff_water
	Checksum: 0xD8C475FD
	Offset: 0x998
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function staff_shatter_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		self.var_5d11d365 = playfxontag(localclientnum, level._effect["staff_water_shatter"], self, "J_SpineLower");
	}
}

