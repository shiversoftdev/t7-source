// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace zm_moon_gravity;

/*
	Name: init
	Namespace: zm_moon_gravity
	Checksum: 0x99EC1590
	Offset: 0x88
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: zombie_low_gravity
	Namespace: zm_moon_gravity
	Checksum: 0xDB43CDDC
	Offset: 0x98
	Size: 0x78
	Parameters: 7
	Flags: Linked
*/
function zombie_low_gravity(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self endon(#"death");
	self endon(#"entityshutdown");
	if(newval)
	{
		self.in_low_g = 1;
	}
	else
	{
		self.in_low_g = 0;
	}
}

/*
	Name: function_20286238
	Namespace: zm_moon_gravity
	Checksum: 0x20BB67BE
	Offset: 0x118
	Size: 0xC6
	Parameters: 7
	Flags: Linked
*/
function function_20286238(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self endon(#"death");
	self endon(#"entityshutdown");
	if(newval)
	{
		if(!isdefined(self.var_9f5aac3e))
		{
			self.var_9f5aac3e = self playloopsound("zmb_moon_bg_airless");
		}
	}
	else if(isdefined(self.var_9f5aac3e))
	{
		self stoploopsound(self.var_9f5aac3e);
		self.var_9f5aac3e = undefined;
	}
}

