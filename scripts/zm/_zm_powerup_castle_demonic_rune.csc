// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace zm_powerup_demonic_rune;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_demonic_rune
	Checksum: 0xD7FF5007
	Offset: 0x1D0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_demonic_rune", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_demonic_rune
	Checksum: 0xE4CED1F7
	Offset: 0x210
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "demonic_rune_fx", 5000, 1, "int", &function_4a94c040, 0, 0);
	zm_powerups::include_zombie_powerup("demonic_rune_lor");
	zm_powerups::add_zombie_powerup("demonic_rune_lor");
	zm_powerups::include_zombie_powerup("demonic_rune_ulla");
	zm_powerups::add_zombie_powerup("demonic_rune_ulla");
	zm_powerups::include_zombie_powerup("demonic_rune_oth");
	zm_powerups::add_zombie_powerup("demonic_rune_oth");
	zm_powerups::include_zombie_powerup("demonic_rune_zor");
	zm_powerups::add_zombie_powerup("demonic_rune_zor");
	zm_powerups::include_zombie_powerup("demonic_rune_mar");
	zm_powerups::add_zombie_powerup("demonic_rune_mar");
	zm_powerups::include_zombie_powerup("demonic_rune_uja");
	zm_powerups::add_zombie_powerup("demonic_rune_uja");
}

/*
	Name: function_4a94c040
	Namespace: zm_powerup_demonic_rune
	Checksum: 0x50A77DED
	Offset: 0x388
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function function_4a94c040(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		playfxontag(localclientnum, "dlc1/castle/fx_demon_gate_rune_glow", self, "tag_origin");
	}
}

