// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_powerup_castle_tram_token;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0x9F18ED32
	Offset: 0x250
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_castle_tram_token", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0xC95FE51B
	Offset: 0x290
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	register_clientfields();
	zm_powerups::include_zombie_powerup("castle_tram_token");
	zm_powerups::add_zombie_powerup("castle_tram_token");
	level._effect["fuse_pickup_fx"] = "dlc1/castle/fx_glow_115_fuse_pickup_castle";
}

/*
	Name: register_clientfields
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0x5B5C23B2
	Offset: 0x2F8
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("toplayer", "has_castle_tram_token", 1, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "ZM_CASTLE_TRAM_TOKEN_ACQUIRED", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("scriptmover", "powerup_fuse_fx", 1, 1, "int", &function_4f546258, 0, 0);
	for(i = 0; i < 4; i++)
	{
		registerclientfield("world", ("player" + i) + "hasItem", 1, 1, "int", &zm_utility::setsharedinventoryuimodels, 0);
	}
	clientfield::register("clientuimodel", "zmInventory.player_using_sprayer", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_sprayer", 1, 1, "int", undefined, 0, 0);
}

/*
	Name: function_4f546258
	Namespace: zm_powerup_castle_tram_token
	Checksum: 0xA5BEA765
	Offset: 0x4B0
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_4f546258(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.powerup_fuse_fx = playfxontag(localclientnum, level._effect["fuse_pickup_fx"], self, "j_fuse_main");
	}
}

