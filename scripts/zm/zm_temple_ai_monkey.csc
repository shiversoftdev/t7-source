// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_temple_ai_monkey;

/*
	Name: __init__sytem__
	Namespace: zm_temple_ai_monkey
	Checksum: 0x3B3BC1D2
	Offset: 0x110
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_temple_ai_monkey", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_temple_ai_monkey
	Checksum: 0x43758031
	Offset: 0x150
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "monkey_ragdoll", 21000, 1, "int", &monkey_ragdoll, 1, 0);
}

/*
	Name: monkey_ragdoll
	Namespace: zm_temple_ai_monkey
	Checksum: 0xF5D19323
	Offset: 0x1A8
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function monkey_ragdoll(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		self suppressragdollselfcollision(1);
	}
}

