// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace counteruav;

/*
	Name: __init__sytem__
	Namespace: counteruav
	Checksum: 0x1F86A174
	Offset: 0x1A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("counteruav", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: counteruav
	Checksum: 0x99EC1590
	Offset: 0x1E8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

