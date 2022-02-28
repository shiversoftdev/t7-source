// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace zm_powerup_genesis_random_weapon;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_genesis_random_weapon
	Checksum: 0x8B64D9EE
	Offset: 0x188
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_genesis_random_weapon", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_genesis_random_weapon
	Checksum: 0x55209953
	Offset: 0x1C8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "random_weap_fx", 15000, 1, "int", &function_1913104f, 0, 0);
	zm_powerups::include_zombie_powerup("genesis_random_weapon");
	zm_powerups::add_zombie_powerup("genesis_random_weapon");
}

/*
	Name: function_1913104f
	Namespace: zm_powerup_genesis_random_weapon
	Checksum: 0xCAD2FCE0
	Offset: 0x250
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function function_1913104f(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		playfxontag(localclientnum, "dlc1/castle/fx_demon_gate_rune_glow", self, "tag_origin");
	}
}

