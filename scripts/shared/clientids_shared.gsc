// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace clientids;

/*
	Name: __init__sytem__
	Namespace: clientids
	Checksum: 0xF44F4F79
	Offset: 0xE8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("clientids", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: clientids
	Checksum: 0x9015D925
	Offset: 0x128
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_start_gametype(&init);
	callback::on_connect(&on_player_connect);
}

/*
	Name: init
	Namespace: clientids
	Checksum: 0xB3CA95F2
	Offset: 0x178
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function init()
{
	level.clientid = 0;
}

/*
	Name: on_player_connect
	Namespace: clientids
	Checksum: 0x2AE1DC68
	Offset: 0x190
	Size: 0x94
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self.clientid = matchrecordnewplayer(self);
	if(!isdefined(self.clientid) || self.clientid == -1)
	{
		self.clientid = level.clientid;
		level.clientid++;
	}
	/#
		println((("" + self.name) + "") + self.clientid);
	#/
}

