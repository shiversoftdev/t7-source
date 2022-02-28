// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace counteruav;

/*
	Name: __init__sytem__
	Namespace: counteruav
	Checksum: 0xC6D99269
	Offset: 0x118
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
	Checksum: 0xBE17D2D8
	Offset: 0x158
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "counteruav", 1, 1, "int", &counteruavchanged, 0, 1);
}

/*
	Name: counteruavchanged
	Namespace: counteruav
	Checksum: 0x7EFA007C
	Offset: 0x1B0
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function counteruavchanged(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	/#
		assert(isdefined(player));
	#/
	player setenemyglobalscrambler(newval);
}

