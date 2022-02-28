// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;

#using_animtree("generic");

#namespace zm_island_main_ee_quest;

/*
	Name: function_30d4f164
	Namespace: zm_island_main_ee_quest
	Checksum: 0xF0FB6C74
	Offset: 0x3B0
	Size: 0x254
	Parameters: 0
	Flags: Linked
*/
function function_30d4f164()
{
	clientfield::register("vehicle", "plane_hit_by_aa_gun", 9000, 1, "int", &function_3b831537, 0, 0);
	clientfield::register("scriptmover", "zipline_lightning_fx", 9000, 1, "int", &zipline_lightning_fx, 0, 0);
	clientfield::register("allplayers", "lightning_shield_fx", 9000, 1, "int", &lightning_shield_fx, 1, 1);
	clientfield::register("scriptmover", "smoke_trail_fx", 9000, 1, "int", &smoke_trail_fx, 0, 0);
	clientfield::register("scriptmover", "smoke_smolder_fx", 9000, 1, "int", &function_67a61c, 0, 0);
	clientfield::register("zbarrier", "bgb_lightning_fx", 9000, 1, "int", &bgb_lightning_fx, 0, 0);
	clientfield::register("scriptmover", "perk_lightning_fx", 9000, getminbitcountfornum(6), "int", &perk_lightning_fx, 0, 0);
	clientfield::register("world", "umbra_tome_outro_igc", 9000, 1, "int", &umbra_tome_outro_igc, 0, 0);
}

/*
	Name: function_f0e89ab2
	Namespace: zm_island_main_ee_quest
	Checksum: 0x11DDCA99
	Offset: 0x610
	Size: 0x6C
	Parameters: 7
	Flags: None
*/
function function_f0e89ab2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["glow_formula_piece"], self, "j_spineupper");
}

/*
	Name: function_e9572f40
	Namespace: zm_island_main_ee_quest
	Checksum: 0xD3E5A533
	Offset: 0x688
	Size: 0x6C
	Parameters: 7
	Flags: None
*/
function function_e9572f40(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["glow_formula_piece"], self, "j_spineupper");
}

/*
	Name: function_3b831537
	Namespace: zm_island_main_ee_quest
	Checksum: 0x643C761C
	Offset: 0x700
	Size: 0x11C
	Parameters: 7
	Flags: Linked
*/
function function_3b831537(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_563d869a = playfxontag(localclientnum, level._effect["bomber_explode"], self, "tag_engine_inner_left");
		wait(1);
		self.var_303b0c31 = playfxontag(localclientnum, level._effect["bomber_fire_trail"], self, "tag_engine_inner_right");
	}
	else
	{
		if(isdefined(self.var_563d869a))
		{
			deletefx(localclientnum, self.var_a1d64192);
		}
		if(isdefined(self.var_303b0c31))
		{
			deletefx(localclientnum, self.var_a1d64192);
		}
	}
}

/*
	Name: zipline_lightning_fx
	Namespace: zm_island_main_ee_quest
	Checksum: 0xF78E26AE
	Offset: 0x828
	Size: 0x104
	Parameters: 7
	Flags: Linked
*/
function zipline_lightning_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_1f5ac1dc[localclientnum] = playfxontag(localclientnum, level._effect["lightning_shield_control_panel"], self, "tag_origin");
	}
	else if(isdefined(self.var_1f5ac1dc))
	{
		a_keys = getarraykeys(self.var_1f5ac1dc);
		if(isinarray(a_keys, localclientnum))
		{
			deletefx(localclientnum, self.var_1f5ac1dc[localclientnum], 0);
		}
	}
}

/*
	Name: lightning_shield_fx
	Namespace: zm_island_main_ee_quest
	Checksum: 0xEA003B22
	Offset: 0x938
	Size: 0x278
	Parameters: 7
	Flags: Linked
*/
function lightning_shield_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	var_ae6a34c0 = player getlocalclientnumber();
	if(newval == 1)
	{
		self.var_257ef9e4 = [];
		self.var_42ad0d0c = [];
		if(!isspectating(localclientnum))
		{
			if(player === self)
			{
				self.lightning_shield_fx = playviewmodelfx(localclientnum, level._effect["lightning_shield_1p"], "tag_shield_lightning_fx");
			}
			else
			{
				self.var_42ad0d0c[var_ae6a34c0] = undefined;
				self.var_257ef9e4[var_ae6a34c0] = playfxontag(var_ae6a34c0, level._effect["lightning_shield_3p"], self, "tag_shield_lightning_fx");
			}
			self thread function_7ddd182c(localclientnum);
		}
	}
	else
	{
		self notify(#"hash_1a229bcb");
		if(!isspectating(localclientnum))
		{
			if(player === self)
			{
				if(isdefined(self.lightning_shield_fx))
				{
					deletefx(localclientnum, self.lightning_shield_fx);
					self.lightning_shield_fx = undefined;
				}
			}
			else
			{
				if(isdefined(self.var_257ef9e4) && isdefined(self.var_257ef9e4[var_ae6a34c0]))
				{
					deletefx(var_ae6a34c0, self.var_257ef9e4[var_ae6a34c0]);
					self.var_257ef9e4[var_ae6a34c0] = undefined;
				}
				if(isdefined(self.var_42ad0d0c) && isdefined(self.var_42ad0d0c[var_ae6a34c0]))
				{
					deletefx(var_ae6a34c0, self.var_42ad0d0c[var_ae6a34c0]);
					self.var_42ad0d0c[var_ae6a34c0] = undefined;
				}
			}
		}
	}
}

/*
	Name: function_7ddd182c
	Namespace: zm_island_main_ee_quest
	Checksum: 0x7A53D024
	Offset: 0xBB8
	Size: 0x2F6
	Parameters: 1
	Flags: Linked
*/
function function_7ddd182c(localclientnum)
{
	self endon(#"disconnect");
	self endon(#"hash_1a229bcb");
	player = getlocalplayer(localclientnum);
	var_ae6a34c0 = player getlocalclientnumber();
	while(true)
	{
		self waittill(#"weapon_change");
		currentweapon = getcurrentweapon(localclientnum);
		if(!isspectating(localclientnum))
		{
			if(isdefined(currentweapon.isriotshield) && currentweapon.isriotshield)
			{
				if(player === self)
				{
					if(!isdefined(self.lightning_shield_fx))
					{
						self.lightning_shield_fx = playviewmodelfx(localclientnum, level._effect["lightning_shield_1p"], "tag_shield_lightning_fx");
					}
				}
				else
				{
					if(isdefined(self.var_42ad0d0c) && isdefined(self.var_42ad0d0c[var_ae6a34c0]))
					{
						deletefx(var_ae6a34c0, self.var_42ad0d0c[var_ae6a34c0]);
						self.var_42ad0d0c[var_ae6a34c0] = undefined;
					}
					var_68b2abba = self.var_257ef9e4[var_ae6a34c0];
					if(!isdefined(var_68b2abba))
					{
						self.var_257ef9e4[var_ae6a34c0] = playfxontag(var_ae6a34c0, level._effect["lightning_shield_3p"], self, "tag_shield_lightning_fx");
					}
				}
			}
			else if(!isspectating(localclientnum))
			{
				if(player === self)
				{
					if(isdefined(self.lightning_shield_fx))
					{
						deletefx(localclientnum, self.lightning_shield_fx);
						self.lightning_shield_fx = undefined;
					}
				}
				else
				{
					if(isdefined(self.var_257ef9e4) && isdefined(self.var_257ef9e4[var_ae6a34c0]))
					{
						deletefx(var_ae6a34c0, self.var_257ef9e4[var_ae6a34c0]);
						self.var_257ef9e4[var_ae6a34c0] = undefined;
					}
					var_14c202b4 = self.var_42ad0d0c[var_ae6a34c0];
					if(!isdefined(var_14c202b4))
					{
						self.var_42ad0d0c[var_ae6a34c0] = playfxontag(var_ae6a34c0, level._effect["lightning_shield_3p"], self, "tag_shield_lightning_fx");
					}
				}
			}
		}
	}
}

/*
	Name: smoke_trail_fx
	Namespace: zm_island_main_ee_quest
	Checksum: 0xDD1CCF0
	Offset: 0xEB8
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function smoke_trail_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_43991df3 = playfxontag(localclientnum, level._effect["gear_smoke_trail"], self, "tag_origin");
	}
	else if(isdefined(self.var_43991df3))
	{
		stopfx(localclientnum, self.var_43991df3);
	}
}

/*
	Name: function_67a61c
	Namespace: zm_island_main_ee_quest
	Checksum: 0xEAE35C42
	Offset: 0xF78
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function function_67a61c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_e05c9faa = playfxontag(localclientnum, level._effect["gear_smoke_smolder"], self, "tag_origin");
	}
	else if(isdefined(self.var_e05c9faa))
	{
		stopfx(localclientnum, self.var_e05c9faa);
	}
}

/*
	Name: perk_lightning_fx
	Namespace: zm_island_main_ee_quest
	Checksum: 0xBD7D6777
	Offset: 0x1038
	Size: 0x236
	Parameters: 7
	Flags: Linked
*/
function perk_lightning_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 0:
		{
			if(isdefined(self.var_99de3d90))
			{
				stopfx(localclientnum, self.var_99de3d90);
			}
			break;
		}
		case 1:
		{
			self.var_99de3d90 = playfxontag(localclientnum, level._effect["perk_lightning_fx_dbltap"], self, "tag_origin");
			break;
		}
		case 2:
		{
			self.var_99de3d90 = playfxontag(localclientnum, level._effect["perk_lightning_fx_jugg"], self, "tag_origin");
			break;
		}
		case 3:
		{
			self.var_99de3d90 = playfxontag(localclientnum, level._effect["perk_lightning_fx_revive"], self, "tag_origin");
			break;
		}
		case 4:
		{
			self.var_99de3d90 = playfxontag(localclientnum, level._effect["perk_lightning_fx_speed"], self, "tag_origin");
			break;
		}
		case 5:
		{
			self.var_99de3d90 = playfxontag(localclientnum, level._effect["perk_lightning_fx_staminup"], self, "tag_origin");
			break;
		}
		case 6:
		{
			self.var_99de3d90 = playfxontag(localclientnum, level._effect["perk_lightning_fx_mulekick"], self, "tag_origin");
			break;
		}
	}
}

/*
	Name: bgb_lightning_fx
	Namespace: zm_island_main_ee_quest
	Checksum: 0x5F587176
	Offset: 0x1278
	Size: 0xCC
	Parameters: 7
	Flags: Linked
*/
function bgb_lightning_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_543f3d1d = playfxontag(localclientnum, level._effect["bgb_lightning_fx"], self zbarriergetpiece(5), "tag_origin");
	}
	else if(isdefined(self.var_543f3d1d))
	{
		stopfx(localclientnum, self.var_543f3d1d);
	}
}

/*
	Name: umbra_tome_outro_igc
	Namespace: zm_island_main_ee_quest
	Checksum: 0x2216789D
	Offset: 0x1350
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function umbra_tome_outro_igc(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		umbra_settometrigger(localclientnum, "bunker_armory_tome");
	}
}

