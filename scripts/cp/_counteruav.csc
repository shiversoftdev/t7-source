// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace counteruav;

/*
	Name: __init__sytem__
	Namespace: counteruav
	Checksum: 0x9E244FDB
	Offset: 0x130
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
	Checksum: 0x50F4CE2E
	Offset: 0x170
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "counteruav", 1, 1, "int", &spawned, 0, 0);
}

/*
	Name: spawned
	Namespace: counteruav
	Checksum: 0xE529A53B
	Offset: 0x1C8
	Size: 0x10E
	Parameters: 7
	Flags: None
*/
function spawned(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.counteruavs))
	{
		level.counteruavs = [];
	}
	if(!isdefined(level.counteruavs[localclientnum]))
	{
		level.counteruavs[localclientnum] = 0;
	}
	player = getlocalplayer(localclientnum);
	/#
		assert(isdefined(player));
	#/
	if(newval)
	{
		level.counteruavs[localclientnum]++;
		self thread counteruav_think(localclientnum);
		player setenemyglobalscrambler(1);
	}
	else
	{
		self notify(#"counteruav_off");
	}
}

/*
	Name: counteruav_think
	Namespace: counteruav
	Checksum: 0x32428AE9
	Offset: 0x2E0
	Size: 0xDC
	Parameters: 1
	Flags: None
*/
function counteruav_think(localclientnum)
{
	self util::waittill_any("entityshutdown", "counteruav_off");
	level.counteruavs[localclientnum]--;
	if(level.counteruavs[localclientnum] < 0)
	{
		level.counteruavs[localclientnum] = 0;
	}
	player = getlocalplayer(localclientnum);
	/#
		assert(isdefined(player));
	#/
	if(level.counteruavs[localclientnum] == 0)
	{
		player setenemyglobalscrambler(0);
	}
}

