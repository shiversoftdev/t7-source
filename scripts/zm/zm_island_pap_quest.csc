// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;

#namespace zm_island_pap_quest;

/*
	Name: init
	Namespace: zm_island_pap_quest
	Checksum: 0xA54E5072
	Offset: 0x1B0
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("scriptmover", "show_part", 9000, 1, "int", &function_97bd83a7, 0, 0);
	clientfield::register("actor", "zombie_splash", 9000, 1, "int", &function_b2ce2a08, 0, 0);
	clientfield::register("world", "lower_pap_water", 9000, 2, "int", &lower_pap_water, 0, 0);
}

/*
	Name: function_97bd83a7
	Namespace: zm_island_pap_quest
	Checksum: 0xA569E8B2
	Offset: 0x298
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function function_97bd83a7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["glow_piece"], self, "tag_origin");
}

/*
	Name: function_b2ce2a08
	Namespace: zm_island_pap_quest
	Checksum: 0x4533EEC
	Offset: 0x310
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_b2ce2a08(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfx(localclientnum, level._effect["water_splash"], self.origin + (vectorscale((0, 0, -1), 48)));
}

/*
	Name: lower_pap_water
	Namespace: zm_island_pap_quest
	Checksum: 0x37068F87
	Offset: 0x398
	Size: 0xDC
	Parameters: 7
	Flags: Linked
*/
function lower_pap_water(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		level thread function_cc69986f(-432, 22, 3);
	}
	else
	{
		if(newval == 2)
		{
			level thread function_cc69986f(-454, 22, 3);
		}
		else if(newval == 3)
		{
			level thread function_cc69986f(-476, 22, 3);
		}
	}
}

/*
	Name: function_cc69986f
	Namespace: zm_island_pap_quest
	Checksum: 0x787062FD
	Offset: 0x480
	Size: 0xE4
	Parameters: 3
	Flags: Linked
*/
function function_cc69986f(n_curr, var_e1344a83, n_time)
{
	n_end = n_curr - var_e1344a83;
	var_c1c93aba = 187.5;
	n_delta = var_e1344a83 / var_c1c93aba;
	var_c0b3756a = n_curr;
	while(var_c0b3756a >= n_end)
	{
		var_c0b3756a = var_c0b3756a - n_delta;
		setwavewaterheight("bunker_pap_room_water", var_c0b3756a);
		wait(0.016);
	}
	if(var_c0b3756a < n_end)
	{
		setwavewaterheight("bunker_pap_room_water", n_end);
	}
}

