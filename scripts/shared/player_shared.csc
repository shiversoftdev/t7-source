// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace player;

/*
	Name: __init__sytem__
	Namespace: player
	Checksum: 0xDC7A9049
	Offset: 0xF0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("player", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: player
	Checksum: 0xAC5B2152
	Offset: 0x130
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("world", "gameplay_started", 4000, 1, "int", &gameplay_started_callback, 0, 1);
}

/*
	Name: gameplay_started_callback
	Namespace: player
	Checksum: 0x5E2EA3C
	Offset: 0x188
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function gameplay_started_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setdvar("cg_isGameplayActive", newval);
}

