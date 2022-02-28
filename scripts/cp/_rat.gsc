// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_util;
#using scripts\shared\rat_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace rat;

/*
	Name: __init__sytem__
	Namespace: rat
	Checksum: 0xC8065075
	Offset: 0xD8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("", &__init__, undefined, undefined);
	#/
}

/*
	Name: __init__
	Namespace: rat
	Checksum: 0xAA37BD14
	Offset: 0x118
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		rat_shared::init();
		level.rat.common.gethostplayer = &util::gethostplayer;
	#/
}

