// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_hacker_tool;

#namespace hacker_tool;

/*
	Name: __init__sytem__
	Namespace: hacker_tool
	Checksum: 0x45C5E860
	Offset: 0x128
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("hacker_tool", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: hacker_tool
	Checksum: 0x1395339D
	Offset: 0x168
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

