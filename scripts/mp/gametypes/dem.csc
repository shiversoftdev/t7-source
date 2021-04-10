// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\gametypes\_globallogic;
#using scripts\shared\callbacks_shared;

#namespace dem;

/*
	Name: main
	Namespace: dem
	Checksum: 0xD2CE7FD9
	Offset: 0xF8
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function main()
{
	callback::on_spawned(&on_player_spawned);
	if(getgametypesetting("silentPlant") != 0)
	{
		setsoundcontext("bomb_plant", "silent");
	}
}

/*
	Name: onprecachegametype
	Namespace: dem
	Checksum: 0x99EC1590
	Offset: 0x168
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function onprecachegametype()
{
}

/*
	Name: onstartgametype
	Namespace: dem
	Checksum: 0x99EC1590
	Offset: 0x178
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
}

/*
	Name: on_player_spawned
	Namespace: dem
	Checksum: 0x6FA62E24
	Offset: 0x188
	Size: 0x24
	Parameters: 1
	Flags: None
*/
function on_player_spawned(localclientnum)
{
	self thread globallogic::watch_plant_sound(localclientnum);
}

