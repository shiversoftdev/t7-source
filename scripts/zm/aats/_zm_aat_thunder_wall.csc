// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\aat_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zm_aat_thunder_wall;

/*
	Name: __init__sytem__
	Namespace: zm_aat_thunder_wall
	Checksum: 0x15EDFC
	Offset: 0x128
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_aat_thunder_wall", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_aat_thunder_wall
	Checksum: 0x66732E47
	Offset: 0x168
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	aat::register("zm_aat_thunder_wall", "zmui_zm_aat_thunder_wall", "t7_icon_zm_aat_thunder_wall");
}

