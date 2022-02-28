// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace _mobile_armory;

/*
	Name: __init__sytem__
	Namespace: _mobile_armory
	Checksum: 0xEA56AE85
	Offset: 0x130
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("cp_mobile_armory", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: _mobile_armory
	Checksum: 0x9980BAFC
	Offset: 0x178
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "mobile_armory_cac", 1, 4, "int", &function_dd709a6d, 0, 0);
}

/*
	Name: __main__
	Namespace: _mobile_armory
	Checksum: 0x99EC1590
	Offset: 0x1D0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
}

/*
	Name: function_dd709a6d
	Namespace: _mobile_armory
	Checksum: 0x2C5F84B4
	Offset: 0x1E0
	Size: 0x1B6
	Parameters: 7
	Flags: Linked
*/
function function_dd709a6d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isspectating(localclientnum, 0))
	{
		return;
	}
	if(!isdefined(self.var_c8b2875a))
	{
		self.var_c8b2875a = createluimenu(localclientnum, "ChooseClass_InGame");
	}
	if(isdefined(self.var_c8b2875a))
	{
		if(newval)
		{
			setluimenudata(localclientnum, self.var_c8b2875a, "isInMobileArmory", 1);
			var_5ebe0017 = newval >> 1;
			if(var_5ebe0017)
			{
				var_91475d5f = newval >> 2;
				var_91475d5f = var_91475d5f + 6;
				setluimenudata(localclientnum, self.var_c8b2875a, "fieldOpsKitClassNum", var_91475d5f);
			}
			openluimenu(localclientnum, self.var_c8b2875a);
		}
		else
		{
			setluimenudata(localclientnum, self.var_c8b2875a, "close_current_menu", 1);
			closeluimenu(localclientnum, self.var_c8b2875a);
			self.var_c8b2875a = undefined;
		}
	}
}

