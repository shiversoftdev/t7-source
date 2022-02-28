// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_prototype_barrels;

/*
	Name: __init__sytem__
	Namespace: zm_prototype_barrels
	Checksum: 0x4632A22B
	Offset: 0x200
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_prototype_barrels", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_prototype_barrels
	Checksum: 0x5333241A
	Offset: 0x240
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "exploding_barrel_burn_fx", 21000, 1, "int", &function_66d46c7d, 0, 0);
	clientfield::register("scriptmover", "exploding_barrel_explode_fx", 21000, 1, "int", &function_b6fe19c5, 0, 0);
}

/*
	Name: function_66d46c7d
	Namespace: zm_prototype_barrels
	Checksum: 0x1E78A8B3
	Offset: 0x2E0
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_66d46c7d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.var_39bdc445 = playfxontag(localclientnum, level.breakables_fx["barrel"]["burn_start"], self, "tag_fx_btm");
	}
}

/*
	Name: function_b6fe19c5
	Namespace: zm_prototype_barrels
	Checksum: 0x3ABEBBD8
	Offset: 0x370
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function function_b6fe19c5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(isdefined(self.var_39bdc445))
		{
			stopfx(localclientnum, self.var_39bdc445);
		}
		self.var_4360e059 = playfxontag(localclientnum, level.breakables_fx["barrel"]["explode"], self, "tag_fx_btm");
	}
}

