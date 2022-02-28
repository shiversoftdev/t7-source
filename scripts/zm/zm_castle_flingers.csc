// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;

#namespace zm_castle_flingers;

/*
	Name: main
	Namespace: zm_castle_flingers
	Checksum: 0xD587833E
	Offset: 0x258
	Size: 0x82
	Parameters: 0
	Flags: Linked
*/
function main()
{
	register_clientfields();
	level._effect["flinger_launch"] = "dlc1/castle/fx_elec_jumppad";
	level._effect["flinger_land"] = "dlc1/castle/fx_dust_landingpad";
	level._effect["flinger_trail"] = "dlc1/castle/fx_elec_jumppad_player_trail";
	level._effect["landing_pad_glow"] = "dlc1/castle/fx_elec_landingpad_glow";
}

/*
	Name: register_clientfields
	Namespace: zm_castle_flingers
	Checksum: 0xB8529C12
	Offset: 0x2E8
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("toplayer", "flinger_flying_postfx", 1, 1, "int", &flinger_flying_postfx, 0, 0);
	clientfield::register("toplayer", "flinger_land_smash", 1, 1, "counter", &flinger_land_smash, 0, 0);
	clientfield::register("scriptmover", "player_visibility", 1, 1, "int", &function_a0a5829, 0, 0);
	clientfield::register("scriptmover", "flinger_launch_fx", 1, 1, "counter", &function_3762396c, 0, 0);
	clientfield::register("scriptmover", "flinger_pad_active_fx", 1, 1, "int", &flinger_pad_active_fx, 0, 0);
}

/*
	Name: flinger_flying_postfx
	Namespace: zm_castle_flingers
	Checksum: 0x1D14EE41
	Offset: 0x460
	Size: 0x15C
	Parameters: 7
	Flags: Linked
*/
function flinger_flying_postfx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_6f6f69f0 = playfxontag(localclientnum, level._effect["flinger_trail"], self, "tag_origin");
		self.var_bb0de733 = self playloopsound("zmb_fling_windwhoosh_2d");
		self thread postfx::playpostfxbundle("pstfx_zm_screen_warp");
	}
	else
	{
		if(isdefined(self.var_6f6f69f0))
		{
			deletefx(localclientnum, self.var_6f6f69f0, 1);
			self.var_6f6f69f0 = undefined;
		}
		if(isdefined(self.var_bb0de733))
		{
			self stoploopsound(self.var_bb0de733, 0.75);
			self.var_bb0de733 = undefined;
		}
		self thread postfx::exitpostfxbundle();
	}
}

/*
	Name: flinger_pad_active_fx
	Namespace: zm_castle_flingers
	Checksum: 0xA4697BCC
	Offset: 0x5C8
	Size: 0xBE
	Parameters: 7
	Flags: Linked
*/
function flinger_pad_active_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_c64ddf2c = playfxontag(localclientnum, level._effect["landing_pad_glow"], self, "tag_origin");
	}
	else if(isdefined(self.var_c64ddf2c))
	{
		deletefx(localclientnum, self.var_c64ddf2c, 1);
		self.var_c64ddf2c = undefined;
	}
}

/*
	Name: flinger_land_smash
	Namespace: zm_castle_flingers
	Checksum: 0x820AB1A5
	Offset: 0x690
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function flinger_land_smash(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["flinger_land"], self, "tag_origin");
}

/*
	Name: function_3762396c
	Namespace: zm_castle_flingers
	Checksum: 0xAB67D2D3
	Offset: 0x708
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function function_3762396c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["flinger_launch"], self, "tag_origin");
}

/*
	Name: function_a0a5829
	Namespace: zm_castle_flingers
	Checksum: 0x1A25C659
	Offset: 0x780
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_a0a5829(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(self.owner == getlocalplayer(localclientnum))
		{
			self thread function_7bd5b92f(localclientnum);
		}
	}
}

/*
	Name: function_7bd5b92f
	Namespace: zm_castle_flingers
	Checksum: 0xB55A6AA8
	Offset: 0x810
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_7bd5b92f(localclientnum)
{
	player = getlocalplayer(localclientnum);
	if(isdefined(player))
	{
		if(isthirdperson(localclientnum))
		{
			self show();
			player hide();
		}
		else
		{
			self hide();
		}
	}
}

