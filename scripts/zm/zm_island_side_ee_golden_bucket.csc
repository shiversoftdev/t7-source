// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;

#namespace zm_island_side_ee_golden_bucket;

/*
	Name: init
	Namespace: zm_island_side_ee_golden_bucket
	Checksum: 0x1DFD866E
	Offset: 0x1C8
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("world", "reveal_golden_bucket_planting_location", 9000, 1, "int", &reveal_golden_bucket_planting_location, 0, 0);
	clientfield::register("scriptmover", "golden_bucket_glow_fx", 9000, 1, "int", &golden_bucket_glow_fx, 0, 0);
}

/*
	Name: reveal_golden_bucket_planting_location
	Namespace: zm_island_side_ee_golden_bucket
	Checksum: 0xACD85009
	Offset: 0x268
	Size: 0x102
	Parameters: 7
	Flags: Linked
*/
function reveal_golden_bucket_planting_location(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		var_6f80c1d8 = getentarray(localclientnum, "swamp_planter_skull_reveal", "targetname");
		foreach(var_31678178 in var_6f80c1d8)
		{
			var_31678178 movez(-45, 2);
		}
	}
}

/*
	Name: golden_bucket_glow_fx
	Namespace: zm_island_side_ee_golden_bucket
	Checksum: 0xF6678922
	Offset: 0x378
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function golden_bucket_glow_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_f8cafdc6[localclientnum] = playfx(localclientnum, level._effect["plant_hit_with_ww"], self.origin);
	}
	else if(isdefined(self.var_f8cafdc6[localclientnum]))
	{
		deletefx(localclientnum, self.var_f8cafdc6[localclientnum]);
	}
}

