// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace zm_tomb_ambient_scripts;

/*
	Name: main
	Namespace: zm_tomb_ambient_scripts
	Checksum: 0xCAB87353
	Offset: 0x150
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	clientfield::register("scriptmover", "zeppelin_fx", 21000, 1, "int", &zeppelin_fx, 0, 0);
}

/*
	Name: zeppelin_fx
	Namespace: zm_tomb_ambient_scripts
	Checksum: 0xC1BC4B49
	Offset: 0x1A8
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function zeppelin_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		self.var_1f4bb75 = playfxontag(localclientnum, level._effect["zeppelin_lights"], self, "tag_body");
	}
	else if(isdefined(self.var_1f4bb75))
	{
		stopfx(localclientnum, self.var_1f4bb75);
	}
}

