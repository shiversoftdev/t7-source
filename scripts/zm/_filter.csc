// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\filter_shared;

#namespace filter;

/*
	Name: init_filter_zm_turned
	Namespace: filter
	Checksum: 0x54402168
	Offset: 0xC0
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_zm_turned(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_zm_turned");
}

/*
	Name: enable_filter_zm_turned
	Namespace: filter
	Checksum: 0xC5533EB0
	Offset: 0x108
	Size: 0x7C
	Parameters: 3
	Flags: None
*/
function enable_filter_zm_turned(player, filterid, overlayid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, level.filter_matid["generic_filter_zm_turned"]);
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: disable_filter_zm_turned
	Namespace: filter
	Checksum: 0x21D2BEDC
	Offset: 0x190
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function disable_filter_zm_turned(player, filterid, overlayid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

