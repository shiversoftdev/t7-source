// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#namespace clean;

/*
	Name: main
	Namespace: clean
	Checksum: 0x49B918A2
	Offset: 0x160
	Size: 0x94
	Parameters: 0
	Flags: None
*/
function main()
{
	clientfield::register("scriptmover", "taco_flag", 12000, 2, "int", &function_3fdcaa92, 0, 0);
	clientfield::register("allplayers", "taco_carry", 12000, 1, "int", &function_87660047, 0, 0);
}

/*
	Name: function_3fdcaa92
	Namespace: clean
	Checksum: 0x250B9960
	Offset: 0x200
	Size: 0x1D4
	Parameters: 7
	Flags: None
*/
function function_3fdcaa92(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self notify(#"hash_c329133d");
	if(isdefined(self.var_bc148e61))
	{
		self.var_bc148e61 unlink();
		self.var_bc148e61.origin = self.origin;
	}
	self function_21017588(localclientnum);
	if(newval != 0)
	{
		if(!isdefined(self.var_bc148e61))
		{
			self.var_bc148e61 = spawn(localclientnum, self.origin, "script_model");
			self.var_bc148e61 setmodel("tag_origin");
			self thread function_8eab3bb6(localclientnum);
		}
		self.var_fd5fd3d4 = playfxontag(localclientnum, "ui/fx_stockpile_drop_marker", self.var_bc148e61, "tag_origin");
		setfxteam(localclientnum, self.var_fd5fd3d4, self.team);
	}
	if(newval == 1)
	{
		self.var_bc148e61 linkto(self);
	}
	else if(newval == 2)
	{
		self thread function_ffa114bb(localclientnum);
	}
}

/*
	Name: function_8eab3bb6
	Namespace: clean
	Checksum: 0x63337A3B
	Offset: 0x3E0
	Size: 0x56
	Parameters: 1
	Flags: None
*/
function function_8eab3bb6(localclientnum)
{
	self waittill(#"entityshutdown");
	self function_21017588(localclientnum);
	self.var_bc148e61 delete();
	self.var_bc148e61 = undefined;
}

/*
	Name: function_21017588
	Namespace: clean
	Checksum: 0x90BB5176
	Offset: 0x440
	Size: 0x3E
	Parameters: 1
	Flags: None
*/
function function_21017588(localclientnum)
{
	if(isdefined(self.var_fd5fd3d4))
	{
		killfx(localclientnum, self.var_fd5fd3d4);
		self.var_fd5fd3d4 = undefined;
	}
}

/*
	Name: function_ffa114bb
	Namespace: clean
	Checksum: 0x506FF72C
	Offset: 0x488
	Size: 0xDA
	Parameters: 1
	Flags: None
*/
function function_ffa114bb(localclientnum)
{
	self endon(#"hash_c329133d");
	self endon(#"entityshutdown");
	toppos = self.origin + vectorscale((0, 0, 1), 12);
	bottompos = self.origin;
	while(true)
	{
		self.var_bc148e61 moveto(toppos, 0.5, 0, 0);
		self.var_bc148e61 waittill(#"movedone");
		self.var_bc148e61 moveto(bottompos, 0.5, 0, 0);
		self.var_bc148e61 waittill(#"movedone");
	}
}

/*
	Name: function_87660047
	Namespace: clean
	Checksum: 0x941939C6
	Offset: 0x570
	Size: 0x1F4
	Parameters: 7
	Flags: None
*/
function function_87660047(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self function_d5c5a3f2(localclientnum);
	if(newval && getlocalplayer(localclientnum) != self)
	{
		if(!isdefined(self.var_bc148e61))
		{
			self util::waittill_dobj(localclientnum);
			var_e69241e6 = self gettagorigin("j_neck");
			var_b1ff0198 = self gettagangles("j_neck");
			self.var_bc148e61 = spawn(localclientnum, var_e69241e6, "script_model");
			self.var_bc148e61 setmodel("tag_origin");
			self.var_bc148e61.angles = var_b1ff0198;
			self.var_bc148e61 linkto(self, "j_neck");
			self thread function_842b9892(localclientnum);
		}
		self.var_51b02da4 = playfxontag(localclientnum, "ui/fx_stockpile_player_marker", self.var_bc148e61, "tag_origin");
		setfxteam(localclientnum, self.var_51b02da4, self.team);
	}
}

/*
	Name: function_842b9892
	Namespace: clean
	Checksum: 0x799B6DF6
	Offset: 0x770
	Size: 0x56
	Parameters: 1
	Flags: None
*/
function function_842b9892(localclientnum)
{
	self waittill(#"entityshutdown");
	self function_d5c5a3f2(localclientnum);
	self.var_bc148e61 delete();
	self.var_bc148e61 = undefined;
}

/*
	Name: function_d5c5a3f2
	Namespace: clean
	Checksum: 0xF1672D3B
	Offset: 0x7D0
	Size: 0x3E
	Parameters: 1
	Flags: None
*/
function function_d5c5a3f2(localclientnum)
{
	if(isdefined(self.var_51b02da4))
	{
		killfx(localclientnum, self.var_51b02da4);
		self.var_51b02da4 = undefined;
	}
}

