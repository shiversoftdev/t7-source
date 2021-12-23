// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\zm\_zm_utility;

#namespace zm_stalingrad_wearables;

/*
	Name: function_ad78a144
	Namespace: zm_stalingrad_wearables
	Checksum: 0x9D8137B3
	Offset: 0x110
	Size: 0xBE
	Parameters: 0
	Flags: Linked
*/
function function_ad78a144()
{
	clientfield::register("scriptmover", "show_wearable", 12000, 1, "int", &show_wearable, 0, 0);
	for(i = 0; i < 4; i++)
	{
		registerclientfield("world", ("player" + i) + "wearableItem", 12000, 2, "int", &zm_utility::setsharedinventoryuimodels, 0);
	}
}

/*
	Name: show_wearable
	Namespace: zm_stalingrad_wearables
	Checksum: 0x7BAFACF6
	Offset: 0x1D8
	Size: 0x54
	Parameters: 3
	Flags: Linked
*/
function show_wearable(localclientnum, oldval, newval)
{
	if(newval)
	{
		self show();
	}
	else
	{
		self hide();
	}
}

