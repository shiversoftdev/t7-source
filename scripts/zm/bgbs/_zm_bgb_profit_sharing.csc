// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_profit_sharing;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_profit_sharing
	Checksum: 0x7FA579B3
	Offset: 0x1F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_profit_sharing", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_bgb_profit_sharing
	Checksum: 0x8CF3600F
	Offset: 0x238
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	clientfield::register("allplayers", "zm_bgb_profit_sharing_3p_fx", 15000, 1, "int", &function_df72a623, 0, 0);
	clientfield::register("toplayer", "zm_bgb_profit_sharing_1p_fx", 15000, 1, "int", &function_f683a0e1, 0, 1);
	bgb::register("zm_bgb_profit_sharing", "time");
	level.var_75dff42 = [];
}

/*
	Name: function_df72a623
	Namespace: zm_bgb_profit_sharing
	Checksum: 0x8A6BB27D
	Offset: 0x318
	Size: 0x128
	Parameters: 7
	Flags: Linked
*/
function function_df72a623(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	e_local_player = getlocalplayer(localclientnum);
	if(newval)
	{
		if(e_local_player != self)
		{
			if(!isdefined(self.var_3485cf73))
			{
				self.var_3485cf73 = [];
			}
			if(isdefined(self.var_3485cf73[localclientnum]))
			{
				return;
			}
			self.var_3485cf73[localclientnum] = playfxontag(localclientnum, "zombie/fx_bgb_profit_3p", self, "j_spine4");
		}
	}
	else if(isdefined(self.var_3485cf73) && isdefined(self.var_3485cf73[localclientnum]))
	{
		stopfx(localclientnum, self.var_3485cf73[localclientnum]);
		self.var_3485cf73[localclientnum] = undefined;
	}
}

/*
	Name: function_f683a0e1
	Namespace: zm_bgb_profit_sharing
	Checksum: 0x6B98415E
	Offset: 0x448
	Size: 0xF8
	Parameters: 7
	Flags: Linked
*/
function function_f683a0e1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(isdefined(level.var_75dff42[localclientnum]))
		{
			deletefx(localclientnum, level.var_75dff42[localclientnum]);
		}
		level.var_75dff42[localclientnum] = playfxoncamera(localclientnum, "zombie/fx_bgb_profit_1p", (0, 0, 0), (1, 0, 0));
	}
	else if(isdefined(level.var_75dff42[localclientnum]))
	{
		stopfx(localclientnum, level.var_75dff42[localclientnum]);
		level.var_75dff42[localclientnum] = undefined;
	}
}

