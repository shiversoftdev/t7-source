// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_hacker_tool;

#namespace hacker_tool;

/*
	Name: __init__sytem__
	Namespace: hacker_tool
	Checksum: 0xCA58CA08
	Offset: 0x138
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("hacker_tool", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: hacker_tool
	Checksum: 0xFEA0C76E
	Offset: 0x178
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

