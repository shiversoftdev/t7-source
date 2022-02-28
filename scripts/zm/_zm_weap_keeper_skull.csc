// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace keeper_skull;

/*
	Name: __init__sytem__
	Namespace: keeper_skull
	Checksum: 0xDED8E4E8
	Offset: 0xB78
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("keeper_skull", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: keeper_skull
	Checksum: 0xF9F81D59
	Offset: 0xBB8
	Size: 0x65E
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("actor", "zombie_explode", 9000, 1, "int", &zombie_explode_fx, 0, 0);
	clientfield::register("actor", "death_ray_shock_eye_fx", 9000, 1, "int", &death_ray_shock_eye_fx, 0, 0);
	clientfield::register("actor", "entranced", 9000, 1, "int", &function_384d8884, 0, 0);
	clientfield::register("actor", "thrasher_skull_fire", 9000, 1, "int", &thrasher_skull_fire, 0, 0);
	clientfield::register("toplayer", "skull_beam_fx", 9000, 2, "int", &function_4fb98616, 0, 0);
	clientfield::register("toplayer", "skull_torch_fx", 9000, 2, "int", &function_2802db6f, 0, 0);
	clientfield::register("allplayers", "skull_beam_3p_fx", 9000, 2, "int", &function_3f47ba02, 0, 0);
	clientfield::register("allplayers", "skull_torch_3p_fx", 9000, 2, "int", &function_cea6821, 0, 0);
	clientfield::register("allplayers", "skull_emissive", 9000, 1, "int", &function_c92fcc97, 0, 0);
	level._effect["death_ray_shock_eyes"] = "zombie/fx_tesla_shock_eyes_zmb";
	level._effect["glow_eye_white"] = "zombie/fx_glow_eye_white";
	level._effect["zombie_explode"] = "dlc2/island/fx_zombie_torso_explo";
	level._effect["beam_start"] = "dlc2/zmb_weapon/fx_wpn_skull_beam_start_island";
	level._effect["beam_loop"] = "dlc2/zmb_weapon/fx_wpn_skull_beam_loop_island";
	level._effect["beam_end"] = "dlc2/zmb_weapon/fx_wpn_skull_beam_end_island";
	level._effect["beam_start_3p"] = "dlc2/zmb_weapon/fx_wpn_skull_beam_start_3p_island";
	level._effect["beam_loop_3p"] = "dlc2/zmb_weapon/fx_wpn_skull_beam_loop_3p_island";
	level._effect["beam_end_3p"] = "dlc2/zmb_weapon/fx_wpn_skull_beam_end_3p_island";
	level._effect["beam_side_start"] = "dlc2/zmb_weapon/fx_wpn_skull_beam_side_start_island";
	level._effect["beam_side_loop"] = "dlc2/zmb_weapon/fx_wpn_skull_beam_side_loop_island";
	level._effect["beam_side_end"] = "dlc2/zmb_weapon/fx_wpn_skull_beam_side_end_island";
	level._effect["beam_side_start_3p"] = "dlc2/zmb_weapon/fx_wpn_skull_beam_side_start_3p_island";
	level._effect["beam_side_loop_3p"] = "dlc2/zmb_weapon/fx_wpn_skull_beam_side_loop_3p_island";
	level._effect["beam_side_end_3p"] = "dlc2/zmb_weapon/fx_wpn_skull_beam_side_end_3p_island";
	level._effect["torch_start"] = "dlc2/zmb_weapon/fx_wpn_skull_torch_start_island";
	level._effect["torch_loop"] = "dlc2/zmb_weapon/fx_wpn_skull_torch_loop_island";
	level._effect["torch_end"] = "dlc2/zmb_weapon/fx_wpn_skull_torch_end_island";
	level._effect["torch_side_start"] = "dlc2/zmb_weapon/fx_wpn_skull_torch_side_start_island";
	level._effect["torch_side_loop"] = "dlc2/zmb_weapon/fx_wpn_skull_torch_side_loop_island";
	level._effect["torch_side_end"] = "dlc2/zmb_weapon/fx_wpn_skull_torch_side_end_island";
	level._effect["torch_start_3p"] = "dlc2/zmb_weapon/fx_wpn_skull_torch_start_3p_island";
	level._effect["torch_loop_3p"] = "dlc2/zmb_weapon/fx_wpn_skull_torch_loop_3p_island";
	level._effect["torch_end_3p"] = "dlc2/zmb_weapon/fx_wpn_skull_torch_end_3p_island";
	level._effect["torch_side_start_3p"] = "dlc2/zmb_weapon/fx_wpn_skull_torch_side_start_3p_island";
	level._effect["torch_side_loop_3p"] = "dlc2/zmb_weapon/fx_wpn_skull_torch_side_loop_3p_island";
	level._effect["torch_side_end_3p"] = "dlc2/zmb_weapon/fx_wpn_skull_torch_side_end_3p_island";
	level._effect["fx_fire_thrash_arm_left_loop"] = "dlc2/island/fx_fire_thrash_arm_left_loop";
	level._effect["fx_fire_thrash_arm_rgt_loop"] = "dlc2/island/fx_fire_thrash_arm_rgt_loop";
	level._effect["fx_fire_thrash_leg_left_loop"] = "dlc2/island/fx_fire_thrash_leg_left_loop";
	level._effect["fx_fire_thrash_leg_rgt_loop"] = "dlc2/island/fx_fire_thrash_leg_rgt_loop";
	level._effect["fx_fire_thrash_hip_left_loop"] = "dlc2/island/fx_fire_thrash_hip_left_loop";
	level._effect["fx_fire_thrash_hip_rgt_loop"] = "dlc2/island/fx_fire_thrash_hip_rgt_loop";
	level._effect["fx_fire_thrash_torso_loop"] = "dlc2/island/fx_fire_thrash_torso_loop";
	level._effect["fx_fire_thrash_waist_loop"] = "dlc2/island/fx_fire_thrash_waist_loop";
}

/*
	Name: function_2802db6f
	Namespace: keeper_skull
	Checksum: 0xA44C072A
	Offset: 0x1220
	Size: 0x346
	Parameters: 7
	Flags: Linked
*/
function function_2802db6f(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isspectating(localclientnum))
	{
		return;
	}
	if(newval == 1)
	{
		if(isdefined(self gettagorigin("tag_fx_mouth")))
		{
			playviewmodelfx(localclientnum, level._effect["torch_start"], "tag_fx_mouth");
		}
		if(isdefined(self gettagorigin("tag_fx_left")))
		{
			playviewmodelfx(localclientnum, level._effect["torch_side_start"], "tag_fx_left");
		}
		if(isdefined(self gettagorigin("tag_fx_right")))
		{
			playviewmodelfx(localclientnum, level._effect["torch_side_start"], "tag_fx_right");
		}
	}
	else
	{
		if(newval == 2)
		{
			if(isdefined(self gettagorigin("tag_fx_mouth")))
			{
				self.var_159d6213 = playviewmodelfx(localclientnum, level._effect["torch_loop"], "tag_fx_mouth");
			}
			if(isdefined(self gettagorigin("tag_fx_left")))
			{
				self.var_4030b4a0 = playviewmodelfx(localclientnum, level._effect["torch_side_loop"], "tag_fx_left");
			}
			if(isdefined(self gettagorigin("tag_fx_right")))
			{
				self.var_f04b5791 = playviewmodelfx(localclientnum, level._effect["torch_side_loop"], "tag_fx_right");
			}
		}
		else
		{
			if(isdefined(self.var_159d6213))
			{
				stopfx(localclientnum, self.var_159d6213);
				self.var_159d6213 = undefined;
			}
			if(isdefined(self.var_4030b4a0))
			{
				stopfx(localclientnum, self.var_4030b4a0);
				self.var_4030b4a0 = undefined;
			}
			if(isdefined(self.var_f04b5791))
			{
				stopfx(localclientnum, self.var_f04b5791);
				self.var_f04b5791 = undefined;
			}
		}
	}
}

/*
	Name: function_4fb98616
	Namespace: keeper_skull
	Checksum: 0xB99AC059
	Offset: 0x1570
	Size: 0x2F6
	Parameters: 7
	Flags: Linked
*/
function function_4fb98616(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isspectating(localclientnum))
	{
		return;
	}
	if(newval == 1)
	{
		playviewmodelfx(localclientnum, level._effect["beam_start"], "tag_flash");
		if(isdefined(self gettagorigin("tag_fx_right")))
		{
			playviewmodelfx(localclientnum, level._effect["beam_side_start"], "tag_fx_right");
		}
		if(isdefined(self gettagorigin("tag_fx_left")))
		{
			playviewmodelfx(localclientnum, level._effect["beam_side_start"], "tag_fx_left");
		}
	}
	else
	{
		if(newval == 2)
		{
			self.var_1bcaa674 = playviewmodelfx(localclientnum, level._effect["beam_loop"], "tag_flash");
			if(isdefined(self gettagorigin("tag_fx_left")))
			{
				self.var_17822f77 = playviewmodelfx(localclientnum, level._effect["beam_side_loop"], "tag_fx_left");
			}
			if(isdefined(self gettagorigin("tag_fx_right")))
			{
				self.var_76b0d9e8 = playviewmodelfx(localclientnum, level._effect["beam_side_loop"], "tag_fx_right");
			}
		}
		else
		{
			if(isdefined(self.var_1bcaa674))
			{
				stopfx(localclientnum, self.var_1bcaa674);
				self.var_1bcaa674 = undefined;
			}
			if(isdefined(self.var_17822f77))
			{
				stopfx(localclientnum, self.var_17822f77);
				self.var_17822f77 = undefined;
			}
			if(isdefined(self.var_76b0d9e8))
			{
				stopfx(localclientnum, self.var_76b0d9e8);
				self.var_76b0d9e8 = undefined;
			}
		}
	}
}

/*
	Name: zombie_explode_fx
	Namespace: keeper_skull
	Checksum: 0x4EF8C552
	Offset: 0x1870
	Size: 0x314
	Parameters: 7
	Flags: Linked
*/
function zombie_explode_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.gibdef))
	{
		gibbundle = struct::get_script_bundle("gibcharacterdef", self.gibdef);
		var_e02aa733 = self.gibdef + "_nofx";
		if(!isdefined(struct::get_script_bundle("gibcharacterdef", var_e02aa733)))
		{
			var_8083daae = spawnstruct();
			var_8083daae.gibs = [];
			var_8083daae.name = gibbundle.name;
			foreach(gibflag, gib in gibbundle.gibs)
			{
				var_8083daae.gibs[gibflag] = spawnstruct();
				var_8083daae.gibs[gibflag].gibmodel = gibbundle.gibs[gibflag].gibmodel;
				var_8083daae.gibs[gibflag].gibtag = gibbundle.gibs[gibflag].gibtag;
				var_8083daae.gibs[gibflag].gibdynentfx = gibbundle.gibs[gibflag].gibdynentfx;
				var_8083daae.gibs[gibflag].gibsound = gibbundle.gibs[gibflag].gibsound;
			}
			level.scriptbundles["gibcharacterdef"][var_e02aa733] = var_8083daae;
		}
		self.gib_data = spawnstruct();
		self.gib_data.gibdef = var_e02aa733;
	}
	playfxontag(localclientnum, level._effect["zombie_explode"], self, "j_spine4");
}

/*
	Name: death_ray_shock_eye_fx
	Namespace: keeper_skull
	Checksum: 0xA300BF3B
	Offset: 0x1B90
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
	Name: function_384d8884
	Namespace: keeper_skull
	Checksum: 0xBB2B7933
	Offset: 0x1C60
	Size: 0xC6
	Parameters: 7
	Flags: Linked
*/
function function_384d8884(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(!isdefined(self.var_60a62a48))
		{
			self.var_60a62a48 = playfxontag(localclientnum, level._effect["glow_eye_white"], self, "J_Eyeball_LE");
		}
	}
	else
	{
		deletefx(localclientnum, self.var_60a62a48, 1);
		self.var_60a62a48 = undefined;
	}
}

/*
	Name: thrasher_skull_fire
	Namespace: keeper_skull
	Checksum: 0xFC56D6E1
	Offset: 0x1D30
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function thrasher_skull_fire(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0)
	{
		self thread function_c16de463(0, localclientnum);
	}
	else if(newval == 1)
	{
		self thread function_c16de463(1, localclientnum);
	}
}

/*
	Name: function_c16de463
	Namespace: keeper_skull
	Checksum: 0x704D11CF
	Offset: 0x1DD0
	Size: 0x592
	Parameters: 2
	Flags: Linked
*/
function function_c16de463(var_1607039a, localclientnum)
{
	if(var_1607039a)
	{
		if(!isdefined(self.var_9cd89d5f))
		{
			self.var_9cd89d5f = [];
			if(!isdefined(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = [];
			}
			else if(!isarray(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = array(self.var_9cd89d5f);
			}
			self.var_9cd89d5f[self.var_9cd89d5f.size] = playfxontag(localclientnum, level._effect["fx_fire_thrash_arm_left_loop"], self, "j_shoulder_le");
			if(!isdefined(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = [];
			}
			else if(!isarray(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = array(self.var_9cd89d5f);
			}
			self.var_9cd89d5f[self.var_9cd89d5f.size] = playfxontag(localclientnum, level._effect["fx_fire_thrash_arm_rgt_loop"], self, "j_shoulder_ri");
			if(!isdefined(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = [];
			}
			else if(!isarray(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = array(self.var_9cd89d5f);
			}
			self.var_9cd89d5f[self.var_9cd89d5f.size] = playfxontag(localclientnum, level._effect["fx_fire_thrash_leg_left_loop"], self, "j_knee_le");
			if(!isdefined(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = [];
			}
			else if(!isarray(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = array(self.var_9cd89d5f);
			}
			self.var_9cd89d5f[self.var_9cd89d5f.size] = playfxontag(localclientnum, level._effect["fx_fire_thrash_leg_rgt_loop"], self, "j_knee_ri");
			if(!isdefined(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = [];
			}
			else if(!isarray(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = array(self.var_9cd89d5f);
			}
			self.var_9cd89d5f[self.var_9cd89d5f.size] = playfxontag(localclientnum, level._effect["fx_fire_thrash_hip_left_loop"], self, "j_hip_le");
			if(!isdefined(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = [];
			}
			else if(!isarray(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = array(self.var_9cd89d5f);
			}
			self.var_9cd89d5f[self.var_9cd89d5f.size] = playfxontag(localclientnum, level._effect["fx_fire_thrash_hip_rgt_loop"], self, "j_hip_ri");
			if(!isdefined(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = [];
			}
			else if(!isarray(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = array(self.var_9cd89d5f);
			}
			self.var_9cd89d5f[self.var_9cd89d5f.size] = playfxontag(localclientnum, level._effect["fx_fire_thrash_torso_loop"], self, "j_spineupper");
			if(!isdefined(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = [];
			}
			else if(!isarray(self.var_9cd89d5f))
			{
				self.var_9cd89d5f = array(self.var_9cd89d5f);
			}
			self.var_9cd89d5f[self.var_9cd89d5f.size] = playfxontag(localclientnum, level._effect["fx_fire_thrash_waist_loop"], self, "j_spinelower");
		}
	}
	else
	{
		foreach(var_41865f6c in self.var_9cd89d5f)
		{
			stopfx(localclientnum, var_41865f6c);
		}
		self.var_9cd89d5f = undefined;
	}
}

/*
	Name: function_c92fcc97
	Namespace: keeper_skull
	Checksum: 0xA63DDE97
	Offset: 0x2370
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function function_c92fcc97(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 1, 1, 1, 0);
	}
	else
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 0, 0, 0);
	}
}

/*
	Name: function_cea6821
	Namespace: keeper_skull
	Checksum: 0x3A41785
	Offset: 0x2420
	Size: 0x15E
	Parameters: 7
	Flags: Linked
*/
function function_cea6821(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isspectating(localclientnum))
	{
		return;
	}
	player = getlocalplayer(localclientnum);
	if(newval == 1)
	{
		if(player != self)
		{
			playfxontag(localclientnum, level._effect["torch_start_3p"], self, "tag_flash");
		}
	}
	else
	{
		if(newval == 2)
		{
			if(player != self)
			{
				self.var_23a3e944 = playfxontag(localclientnum, level._effect["torch_loop_3p"], self, "tag_flash");
			}
		}
		else if(player != self)
		{
			if(isdefined(self.var_23a3e944))
			{
				stopfx(localclientnum, self.var_23a3e944);
				self.var_23a3e944 = undefined;
			}
		}
	}
}

/*
	Name: function_3f47ba02
	Namespace: keeper_skull
	Checksum: 0xDCBFB49A
	Offset: 0x2588
	Size: 0x15E
	Parameters: 7
	Flags: Linked
*/
function function_3f47ba02(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isspectating(localclientnum))
	{
		return;
	}
	player = getlocalplayer(localclientnum);
	if(newval == 1)
	{
		if(player != self)
		{
			playfxontag(localclientnum, level._effect["beam_start_3p"], self, "tag_flash");
		}
	}
	else
	{
		if(newval == 2)
		{
			if(player != self)
			{
				self.var_5f48ba4b = playfxontag(localclientnum, level._effect["beam_loop_3p"], self, "tag_flash");
			}
		}
		else if(player != self)
		{
			if(isdefined(self.var_5f48ba4b))
			{
				stopfx(localclientnum, self.var_5f48ba4b);
				self.var_5f48ba4b = undefined;
			}
		}
	}
}

