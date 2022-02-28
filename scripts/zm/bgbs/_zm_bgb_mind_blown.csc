// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_mind_blown;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_mind_blown
	Checksum: 0xC885AC39
	Offset: 0x218
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_mind_blown", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_bgb_mind_blown
	Checksum: 0x1380574B
	Offset: 0x258
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	clientfield::register("actor", "zm_bgb_mind_pop_fx", 15000, 1, "int", &function_f10358c6, 0, 0);
	clientfield::register("actor", "zm_bgb_mind_ray_fx", 15000, 1, "int", &function_57f7c3a1, 0, 0);
	bgb::register("zm_bgb_mind_blown", "activated");
}

/*
	Name: function_57f7c3a1
	Namespace: zm_bgb_mind_blown
	Checksum: 0x7CB530B7
	Offset: 0x330
	Size: 0xD4
	Parameters: 7
	Flags: Linked
*/
function function_57f7c3a1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playsound(0, "zmb_bgb_mindblown_start", self gettagorigin("j_neck"));
	self.var_f40a5f31 = playfxontag(localclientnum, "zombie/fx_bgb_head_pop_ray", self, "j_neck");
	self.var_bbd257f7 = playfxontag(localclientnum, "dlc4/genesis/fx_bgb_mindblown_heatup", self, "j_spine4");
}

/*
	Name: function_f10358c6
	Namespace: zm_bgb_mind_blown
	Checksum: 0x4E4097DE
	Offset: 0x410
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function function_f10358c6(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.var_f40a5f31))
	{
		killfx(localclientnum, self.var_f40a5f31);
	}
	if(isdefined(self.var_bbd257f7))
	{
		stopfx(localclientnum, self.var_bbd257f7);
	}
	playfxontag(localclientnum, "zombie/fx_bgb_head_pop", self, "j_neck");
}

