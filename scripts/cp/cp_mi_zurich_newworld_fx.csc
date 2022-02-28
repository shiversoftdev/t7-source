// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;

#namespace cp_mi_zurich_newworld_fx;

/*
	Name: main
	Namespace: cp_mi_zurich_newworld_fx
	Checksum: 0x9BAAA0AB
	Offset: 0xF8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	clientfield::register("world", "set_fog_bank", 1, 2, "int", &function_c49f36a3, 0, 0);
}

/*
	Name: function_c49f36a3
	Namespace: cp_mi_zurich_newworld_fx
	Checksum: 0xAD1477C8
	Offset: 0x150
	Size: 0x12E
	Parameters: 7
	Flags: Linked
*/
function function_c49f36a3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0)
	{
		var_3a456a21 = 1;
	}
	else
	{
		if(newval == 1)
		{
			var_3a456a21 = 2;
		}
		else if(newval == 2)
		{
			var_3a456a21 = 3;
		}
	}
	for(localclientnum = 0; localclientnum < level.localplayers.size; localclientnum++)
	{
		setworldfogactivebank(localclientnum, var_3a456a21);
		if(var_3a456a21 == 3)
		{
			setexposureactivebank(localclientnum, var_3a456a21);
			continue;
		}
		if(var_3a456a21 == 1)
		{
			setexposureactivebank(localclientnum, var_3a456a21);
		}
	}
}

