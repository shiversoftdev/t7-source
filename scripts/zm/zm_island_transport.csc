// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace zm_island_transport;

/*
	Name: init
	Namespace: zm_island_transport
	Checksum: 0x4AED2560
	Offset: 0x170
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("vehicle", "sewer_current_fx", 9000, 1, "int", &sewer_current_fx, 0, 0);
}

/*
	Name: sewer_current_fx
	Namespace: zm_island_transport
	Checksum: 0xD740AD0A
	Offset: 0x1C8
	Size: 0xCC
	Parameters: 7
	Flags: Linked
*/
function sewer_current_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(!isdefined(self.var_7e61ace3))
		{
			self.var_7e61ace3 = [];
		}
		self thread function_a39e4663(localclientnum);
	}
	else
	{
		self notify(#"hash_ab837d11");
		if(isdefined(self.var_7e61ace3[localclientnum]))
		{
			deletefx(localclientnum, self.var_7e61ace3[localclientnum], 0);
		}
	}
}

/*
	Name: function_a39e4663
	Namespace: zm_island_transport
	Checksum: 0xEE601996
	Offset: 0x2A0
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function function_a39e4663(localclientnum)
{
	self endon(#"hash_ab837d11");
	while(true)
	{
		self.var_7e61ace3[localclientnum] = playfxontag(localclientnum, level._effect["current_effect"], self, "tag_origin");
		wait(0.05);
	}
}

