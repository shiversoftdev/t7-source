// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;

#namespace zm_island_spider_ee_quest;

/*
	Name: init
	Namespace: zm_island_spider_ee_quest
	Checksum: 0x876D29C5
	Offset: 0x210
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("vehicle", "spider_glow_fx", 9000, 1, "int", &spider_glow_fx, 0, 0);
	clientfield::register("vehicle", "spider_drinks_fx", 9000, 2, "int", &function_f9f39b8e, 0, 0);
	clientfield::register("scriptmover", "jungle_cage_charged_fx", 9000, 1, "int", &jungle_cage_charged_fx, 0, 0);
}

/*
	Name: spider_glow_fx
	Namespace: zm_island_spider_ee_quest
	Checksum: 0xF14BB4BA
	Offset: 0x2F8
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function spider_glow_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_6cbaf065 = playfxontag(localclientnum, level._effect["spider_glow_red"], self, "tag_driver");
	}
	else if(isdefined(self.var_6cbaf065))
	{
		deletefx(localclientnum, self.var_6cbaf065);
	}
}

/*
	Name: function_f9f39b8e
	Namespace: zm_island_spider_ee_quest
	Checksum: 0x7899C6D
	Offset: 0x3B8
	Size: 0x17C
	Parameters: 7
	Flags: Linked
*/
function function_f9f39b8e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self.var_163815ae))
	{
		self.var_163815ae = [];
	}
	if(newval == 1)
	{
		self.var_163815ae[localclientnum] = playfxontag(localclientnum, level._effect["spider_drink_lair"], self, "tag_flash");
	}
	else
	{
		if(newval == 2)
		{
			self.var_163815ae[localclientnum] = playfxontag(localclientnum, level._effect["spider_drink_meteor"], self, "tag_flash");
		}
		else
		{
			if(newval == 3)
			{
				self.var_163815ae[localclientnum] = playfxontag(localclientnum, level._effect["spider_drink_bunker"], self, "tag_flash");
			}
			else if(isdefined(self.var_163815ae[localclientnum]))
			{
				deletefx(localclientnum, self.var_163815ae[localclientnum]);
			}
		}
	}
}

/*
	Name: jungle_cage_charged_fx
	Namespace: zm_island_spider_ee_quest
	Checksum: 0x2BBA3A50
	Offset: 0x540
	Size: 0x104
	Parameters: 7
	Flags: Linked
*/
function jungle_cage_charged_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_da0d0e02[localclientnum] = playfxontag(localclientnum, level._effect["lightning_shield_control_panel"], self, "tag_origin");
	}
	else if(isdefined(self.var_da0d0e02))
	{
		a_keys = getarraykeys(self.var_da0d0e02);
		if(isinarray(a_keys, localclientnum))
		{
			deletefx(localclientnum, self.var_da0d0e02[localclientnum], 0);
		}
	}
}

