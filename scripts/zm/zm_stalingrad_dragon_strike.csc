// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_19e79ea1;

/*
	Name: __init__sytem__
	Namespace: namespace_19e79ea1
	Checksum: 0xC244C572
	Offset: 0x230
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("zm_stalingrad_dragon_strike", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_19e79ea1
	Checksum: 0x58C0319B
	Offset: 0x270
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "lockbox_light_1", 12000, 2, "int", &lockbox_light_1, 0, 0);
	clientfield::register("scriptmover", "lockbox_light_2", 12000, 2, "int", &lockbox_light_2, 0, 0);
	clientfield::register("scriptmover", "lockbox_light_3", 12000, 2, "int", &lockbox_light_3, 0, 0);
	clientfield::register("scriptmover", "lockbox_light_4", 12000, 2, "int", &lockbox_light_4, 0, 0);
}

/*
	Name: lockbox_light_1
	Namespace: namespace_19e79ea1
	Checksum: 0x3CA1EDA7
	Offset: 0x3A0
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function lockbox_light_1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.var_fbe6c07a))
	{
		stopfx(localclientnum, self.var_fbe6c07a);
	}
	if(newval == 2)
	{
		self.var_fbe6c07a = playfxontag(localclientnum, "dlc3/stalingrad/fx_glow_red_dragonstrike", self, "tag_nixie_red_" + "0");
	}
	else
	{
		self.var_fbe6c07a = playfxontag(localclientnum, "dlc3/stalingrad/fx_glow_green_dragonstrike", self, "tag_nixie_green_" + "0");
	}
}

/*
	Name: lockbox_light_2
	Namespace: namespace_19e79ea1
	Checksum: 0x5C8654A
	Offset: 0x498
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function lockbox_light_2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.var_d5e44611))
	{
		stopfx(localclientnum, self.var_d5e44611);
	}
	if(newval == 2)
	{
		self.var_d5e44611 = playfxontag(localclientnum, "dlc3/stalingrad/fx_glow_red_dragonstrike", self, "tag_nixie_red_" + "1");
	}
	else
	{
		self.var_d5e44611 = playfxontag(localclientnum, "dlc3/stalingrad/fx_glow_green_dragonstrike", self, "tag_nixie_green_" + "1");
	}
}

/*
	Name: lockbox_light_3
	Namespace: namespace_19e79ea1
	Checksum: 0x582AAE33
	Offset: 0x590
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function lockbox_light_3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.var_afe1cba8))
	{
		stopfx(localclientnum, self.var_afe1cba8);
	}
	if(newval == 2)
	{
		self.var_afe1cba8 = playfxontag(localclientnum, "dlc3/stalingrad/fx_glow_red_dragonstrike", self, "tag_nixie_red_" + "2");
	}
	else
	{
		self.var_afe1cba8 = playfxontag(localclientnum, "dlc3/stalingrad/fx_glow_green_dragonstrike", self, "tag_nixie_green_" + "2");
	}
}

/*
	Name: lockbox_light_4
	Namespace: namespace_19e79ea1
	Checksum: 0x1B5C4922
	Offset: 0x688
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function lockbox_light_4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.var_b9f32487))
	{
		stopfx(localclientnum, self.var_b9f32487);
	}
	if(newval == 2)
	{
		self.var_b9f32487 = playfxontag(localclientnum, "dlc3/stalingrad/fx_glow_red_dragonstrike", self, "tag_nixie_red_" + "3");
	}
	else
	{
		self.var_b9f32487 = playfxontag(localclientnum, "dlc3/stalingrad/fx_glow_green_dragonstrike", self, "tag_nixie_green_" + "3");
	}
}

