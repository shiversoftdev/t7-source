// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace client_flag;

/*
	Name: __init__sytem__
	Namespace: client_flag
	Checksum: 0x983DF1C2
	Offset: 0xF8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("client_flag", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: client_flag
	Checksum: 0x812FF7F
	Offset: 0x138
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "ctf_flag_away", 1, 1, "int", &setctfaway, 0, 0);
}

/*
	Name: setctfaway
	Namespace: client_flag
	Checksum: 0xF37FB99F
	Offset: 0x190
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function setctfaway(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	team = self.team;
	setflagasaway(localclientnum, team, newval);
	self thread clearctfaway(localclientnum, team);
}

/*
	Name: clearctfaway
	Namespace: client_flag
	Checksum: 0x4A4F0902
	Offset: 0x228
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function clearctfaway(localclientnum, team)
{
	self waittill(#"entityshutdown");
	setflagasaway(localclientnum, team, 0);
}

