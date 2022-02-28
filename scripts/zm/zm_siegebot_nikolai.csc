// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\vehicle_shared;

#using_animtree("generic");

#namespace zm_siegebot_nikolai;

/*
	Name: __init__sytem__
	Namespace: zm_siegebot_nikolai
	Checksum: 0xB79FB928
	Offset: 0x498
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_siegebot_nikolai", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_siegebot_nikolai
	Checksum: 0x4A7A239D
	Offset: 0x4D8
	Size: 0x2FC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	vehicle::add_vehicletype_callback("siegebot_nikolai", &on_spawned);
	clientfield::register("vehicle", "nikolai_destroyed_r_arm", 12000, 1, "int", &nikolai_destroyed_r_arm, 0, 0);
	clientfield::register("vehicle", "nikolai_destroyed_l_arm", 12000, 1, "int", &nikolai_destroyed_l_arm, 0, 0);
	clientfield::register("vehicle", "nikolai_destroyed_r_chest", 12000, 1, "int", &nikolai_destroyed_r_chest, 0, 0);
	clientfield::register("vehicle", "nikolai_destroyed_l_chest", 12000, 1, "int", &nikolai_destroyed_l_chest, 0, 0);
	clientfield::register("vehicle", "nikolai_weakpoint_l_fx", 12000, 1, "int", &nikolai_weakpoint_l_fx, 0, 0);
	clientfield::register("vehicle", "nikolai_weakpoint_r_fx", 12000, 1, "int", &nikolai_weakpoint_r_fx, 0, 0);
	clientfield::register("vehicle", "nikolai_gatling_tell", 12000, 1, "int", &nikolai_gatling_tell, 0, 0);
	clientfield::register("missile", "harpoon_impact", 12000, 1, "int", &harpoon_impact, 0, 0);
	clientfield::register("vehicle", "play_raps_trail_fx", 12000, 1, "int", &function_66f3947f, 0, 0);
	clientfield::register("vehicle", "raps_landing", 12000, 1, "int", &raps_landing, 0, 0);
}

/*
	Name: on_spawned
	Namespace: zm_siegebot_nikolai
	Checksum: 0xD8240D81
	Offset: 0x7E0
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function on_spawned(localclientnum)
{
	self useanimtree($generic);
	self thread function_89d7e567(localclientnum);
	self thread function_48c3fc7d(localclientnum);
}

/*
	Name: function_48c3fc7d
	Namespace: zm_siegebot_nikolai
	Checksum: 0xEBAF355
	Offset: 0x848
	Size: 0x278
	Parameters: 1
	Flags: Linked
*/
function function_48c3fc7d(localclientnum)
{
	self endon(#"entityshutdown");
	self notify(#"hash_48c3fc7d");
	self endon(#"hash_48c3fc7d");
	nikolai = undefined;
	while(true)
	{
		level waittill(#"hash_eeba0c72");
		if(!isdefined(nikolai))
		{
			allents = getentarray(localclientnum);
			foreach(ent in allents)
			{
				if(ent.model === "c_zom_dlc_waw_nikolai_fb" && self isentitylinkedtotag(ent))
				{
					nikolai = ent;
				}
			}
		}
		bottle = undefined;
		if(isdefined(nikolai))
		{
			origin = nikolai gettagorigin("j_ringbase_le");
			angles = nikolai gettagangles("j_ringbase_le");
			up = anglestoup(angles);
			angles = angles + vectorscale((0, 0, 1), 180);
			bottle = spawn(localclientnum, origin, "script_model");
			bottle setmodel("p7_zm_sta_bottle_vodka_01");
			bottle.angles = angles;
			nikolai thread function_97181777(bottle);
		}
		level waittill(#"hash_13cefe1f");
		if(isdefined(bottle))
		{
			bottle delete();
		}
	}
}

/*
	Name: function_97181777
	Namespace: zm_siegebot_nikolai
	Checksum: 0x4ECD6910
	Offset: 0xAC8
	Size: 0x154
	Parameters: 1
	Flags: Linked
*/
function function_97181777(bottle)
{
	while(isdefined(self) && isdefined(bottle))
	{
		origin = self gettagorigin("j_ringbase_le");
		angles = self gettagangles("j_ringbase_le");
		forward = anglestoforward(angles);
		right = anglestoright(angles);
		up = anglestoup(angles);
		angles = angles + vectorscale((0, 0, 1), 180);
		offset = (forward * 1.6) + (right * -1.2) + (up * 11);
		bottle.origin = origin + offset;
		bottle.angles = angles;
		wait(0.016);
	}
}

/*
	Name: function_89d7e567
	Namespace: zm_siegebot_nikolai
	Checksum: 0xCE04DE2E
	Offset: 0xC28
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function function_89d7e567(localclientnum)
{
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	while(true)
	{
		self waittill(#"gunner_weapon_fired");
		self setanim("ai_zm_dlc3_russian_mech_shoot_gunbarrel", 1, 0, 1);
	}
}

/*
	Name: nikolai_gatling_tell
	Namespace: zm_siegebot_nikolai
	Checksum: 0xFE384A06
	Offset: 0xC90
	Size: 0x186
	Parameters: 7
	Flags: Linked
*/
function nikolai_gatling_tell(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.var_16903828 = playfxontag(localclientnum, level._effect["nikolai_gatling_tell"], self, "tag_gunner_aim1");
		self playsound(localclientnum, "zmb_nikolaibot_rapidfire_start", self gettagorigin("tag_eye"));
		self.var_464db63 = self playloopsound("zmb_nikolaibot_rapidfire_barrel_lp");
	}
	else
	{
		if(isdefined(self.var_16903828))
		{
			stopfx(localclientnum, self.var_16903828);
		}
		self playsound(localclientnum, "zmb_nikolaibot_rapidfire_end", self gettagorigin("tag_eye"));
		if(isdefined(self.var_464db63))
		{
			self stoploopsound(self.var_464db63);
			self.var_464db63 = undefined;
		}
	}
}

/*
	Name: nikolai_destroyed_r_arm
	Namespace: zm_siegebot_nikolai
	Checksum: 0x9ECC9C86
	Offset: 0xE20
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function nikolai_destroyed_r_arm(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfxontag(localclientnum, level._effect["nikolai_weakpoint_destroyed"], self, "tag_heat_vent_01_d1");
		self playsound(localclientnum, "zmb_nikolaibot_damage", self gettagorigin("tag_heat_vent_01_d1"));
	}
}

/*
	Name: nikolai_destroyed_l_arm
	Namespace: zm_siegebot_nikolai
	Checksum: 0x6AAB2F5D
	Offset: 0xEE0
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function nikolai_destroyed_l_arm(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfxontag(localclientnum, level._effect["nikolai_weakpoint_destroyed"], self, "tag_heat_vent_02_d1");
		self playsound(localclientnum, "zmb_nikolaibot_damage", self gettagorigin("tag_heat_vent_02_d1"));
	}
}

/*
	Name: nikolai_destroyed_r_chest
	Namespace: zm_siegebot_nikolai
	Checksum: 0xB5EBA05E
	Offset: 0xFA0
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function nikolai_destroyed_r_chest(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfxontag(localclientnum, level._effect["nikolai_weakpoint_destroyed"], self, "tag_heat_vent_03_d1");
		self playsound(localclientnum, "zmb_nikolaibot_damage", self gettagorigin("tag_heat_vent_03_d1"));
	}
}

/*
	Name: nikolai_destroyed_l_chest
	Namespace: zm_siegebot_nikolai
	Checksum: 0x6892A3EB
	Offset: 0x1060
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function nikolai_destroyed_l_chest(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfxontag(localclientnum, level._effect["nikolai_weakpoint_destroyed"], self, "tag_heat_vent_04_d1");
		self playsound(localclientnum, "zmb_nikolaibot_damage", self gettagorigin("tag_heat_vent_04_d1"));
	}
}

/*
	Name: nikolai_weakpoint_r_fx
	Namespace: zm_siegebot_nikolai
	Checksum: 0x6952148
	Offset: 0x1120
	Size: 0xB6
	Parameters: 7
	Flags: Linked
*/
function nikolai_weakpoint_r_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.var_da48848b = playfxontag(localclientnum, level._effect["nikolai_weakpoint_fx"], self, "tag_heat_vent_01_d0");
	}
	else if(isdefined(self.var_da48848b))
	{
		stopfx(localclientnum, self.var_da48848b);
		self.var_da48848b = undefined;
	}
}

/*
	Name: nikolai_weakpoint_l_fx
	Namespace: zm_siegebot_nikolai
	Checksum: 0x766C39B5
	Offset: 0x11E0
	Size: 0xB6
	Parameters: 7
	Flags: Linked
*/
function nikolai_weakpoint_l_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.var_f639a615 = playfxontag(localclientnum, level._effect["nikolai_weakpoint_fx"], self, "tag_heat_vent_02_d0");
	}
	else if(isdefined(self.var_f639a615))
	{
		stopfx(localclientnum, self.var_f639a615);
		self.var_f639a615 = undefined;
	}
}

/*
	Name: harpoon_impact
	Namespace: zm_siegebot_nikolai
	Checksum: 0x9B3E04A2
	Offset: 0x12A0
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function harpoon_impact(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["nikolai_harpoon_impact"], self.origin, anglestoforward(self.angles) * -1);
		playsound(0, "zmb_nikolaibot_harpoon_impact", self.origin + vectorscale((0, 0, 1), 10));
		playrumbleonposition(localclientnum, "harpoon_land", self.origin + vectorscale((0, 0, 1), 10));
	}
}

/*
	Name: function_66f3947f
	Namespace: zm_siegebot_nikolai
	Checksum: 0xDBA8FF97
	Offset: 0x13A8
	Size: 0xE4
	Parameters: 7
	Flags: Linked
*/
function function_66f3947f(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	if(n_val_new)
	{
		self.fx_trail = playfxontag(n_local_client, level._effect["nikolai_raps_trail"], self, "tag_body");
		self playsound(0, "wpn_nikolaibot_raps_launch");
	}
	else if(isdefined(self.fx_trail))
	{
		stopfx(n_local_client, self.fx_trail);
	}
}

/*
	Name: raps_landing
	Namespace: zm_siegebot_nikolai
	Checksum: 0x5043A525
	Offset: 0x1498
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function raps_landing(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfxontag(localclientnum, level._effect["nikolai_raps_landing"], self, "tag_origin");
		self playsound(0, "zmb_nikolaibot_raps_impact");
	}
}

