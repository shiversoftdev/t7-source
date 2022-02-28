// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_utility;

#namespace zm_challenges_tomb;

/*
	Name: __init__sytem__
	Namespace: zm_challenges_tomb
	Checksum: 0x316AF679
	Offset: 0x140
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_tomb_chamber", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_challenges_tomb
	Checksum: 0xE27B5683
	Offset: 0x180
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "divider_fx", 21000, 1, "counter", &function_fa586bee, 0, 0);
}

/*
	Name: function_fa586bee
	Namespace: zm_challenges_tomb
	Checksum: 0x68ECC20C
	Offset: 0x1D8
	Size: 0xA6
	Parameters: 7
	Flags: Linked
*/
function function_fa586bee(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		for(i = 1; i <= 9; i++)
		{
			playfxontag(localclientnum, level._effect["crypt_wall_drop"], self, "tag_fx_dust_0" + i);
		}
	}
}

