// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace castle_rocketshield;

/*
	Name: __init__sytem__
	Namespace: castle_rocketshield
	Checksum: 0x60FAEEA
	Offset: 0x188
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_castle_rocketshield", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: castle_rocketshield
	Checksum: 0xF652FEBD
	Offset: 0x1C8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("allplayers", "rs_ammo", 1, 1, "int", &set_rocketshield_ammo, 0, 0);
}

/*
	Name: set_rocketshield_ammo
	Namespace: castle_rocketshield
	Checksum: 0x992ABE1
	Offset: 0x220
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function set_rocketshield_ammo(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 1, 0, 0);
	}
	else
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 0, 0, 0);
	}
}

