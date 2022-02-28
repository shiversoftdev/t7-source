// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace music;

/*
	Name: __init__sytem__
	Namespace: music
	Checksum: 0xA392E30A
	Offset: 0xC8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("music", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: music
	Checksum: 0x6154177E
	Offset: 0x108
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.activemusicstate = "";
	level.nextmusicstate = "";
	level.musicstates = [];
	util::register_system("musicCmd", &musiccmdhandler);
}

/*
	Name: musiccmdhandler
	Namespace: music
	Checksum: 0x87E0BBA1
	Offset: 0x170
	Size: 0x64
	Parameters: 3
	Flags: Linked
*/
function musiccmdhandler(clientnum, state, oldstate)
{
	if(state != "death")
	{
		level._lastmusicstate = state;
	}
	state = tolower(state);
	soundsetmusicstate(state);
}

