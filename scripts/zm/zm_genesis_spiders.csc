// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm;

#namespace zm_genesis_spiders;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_spiders
	Checksum: 0xC5E0455C
	Offset: 0x100
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_spiders", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_spiders
	Checksum: 0x99EC1590
	Offset: 0x148
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

/*
	Name: __main__
	Namespace: zm_genesis_spiders
	Checksum: 0x7A9BF9E7
	Offset: 0x158
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	register_clientfields();
}

/*
	Name: register_clientfields
	Namespace: zm_genesis_spiders
	Checksum: 0x99EC1590
	Offset: 0x178
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
}

