// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\zm\_zm_utility;

#namespace zm_genesis_wearables;

/*
	Name: function_ad78a144
	Namespace: zm_genesis_wearables
	Checksum: 0xF78E7320
	Offset: 0x160
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_ad78a144()
{
	for(i = 0; i < 4; i++)
	{
		registerclientfield("world", ("player" + i) + "wearableItem", 15000, 4, "int", &zm_utility::setsharedinventoryuimodels, 0);
	}
	clientfield::register("clientuimodel", "zmInventory.wearable_perk_icons", 15000, 2, "int", undefined, 0, 0);
	clientfield::register("scriptmover", "battery_fx", 15000, 2, "int", &function_f51349bf, 0, 0);
}

/*
	Name: function_f51349bf
	Namespace: zm_genesis_wearables
	Checksum: 0x58548947
	Offset: 0x260
	Size: 0x19C
	Parameters: 7
	Flags: Linked
*/
function function_f51349bf(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(isdefined(self.n_fx_id))
		{
			deletefx(localclientnum, self.n_fx_id, 1);
		}
		self.n_fx_id = playfx(localclientnum, level._effect["battery_uncharged"], self.origin, anglestoforward(self.angles), (0, 0, 1));
	}
	else
	{
		if(newval == 2)
		{
			if(isdefined(self.n_fx_id))
			{
				deletefx(localclientnum, self.n_fx_id, 1);
			}
			self.n_fx_id = playfx(localclientnum, level._effect["battery_charged"], self.origin, anglestoforward(self.angles), (0, 0, 1));
		}
		else if(isdefined(self.n_fx_id))
		{
			deletefx(localclientnum, self.n_fx_id, 1);
		}
	}
}

