// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace grapple;

/*
	Name: __init__sytem__
	Namespace: grapple
	Checksum: 0xD9B8185F
	Offset: 0x190
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("grapple", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: grapple
	Checksum: 0x99EC1590
	Offset: 0x1D0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

