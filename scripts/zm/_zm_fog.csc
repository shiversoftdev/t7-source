// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace zm_fog;

/*
	Name: __init__sytem__
	Namespace: zm_fog
	Checksum: 0x71835031
	Offset: 0x198
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_fog", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_fog
	Checksum: 0x578CA1B8
	Offset: 0x1D8
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("world", "globalfog_bank", 15000, 2, "int", &function_83c92b90, 0, 0);
	clientfield::register("world", "litfog_scriptid_to_edit", 15000, 4, "int", undefined, 0, 0);
	clientfield::register("world", "litfog_bank", 15000, 2, "int", &function_7ac70b3c, 0, 0);
}

/*
	Name: function_83c92b90
	Namespace: zm_fog
	Checksum: 0x6AF5D1C8
	Offset: 0x2B0
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_83c92b90(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setworldfogactivebank(localclientnum, newval + 1);
}

/*
	Name: function_7ac70b3c
	Namespace: zm_fog
	Checksum: 0x35F0AC60
	Offset: 0x318
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_7ac70b3c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_18b9a65a = clientfield::get("litfog_scriptid_to_edit");
	setlitfogbank(localclientnum, var_18b9a65a, newval, -1);
}

