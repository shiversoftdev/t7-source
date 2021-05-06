// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\gametypes\_globallogic;
#using scripts\shared\callbacks_shared;

#namespace sd;

/*
	Name: main
	Namespace: sd
	Checksum: 0xFDD46164
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
	Name: onstartgametype
	Namespace: sd
	Checksum: 0x99EC1590
	Offset: 0x168
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
}

/*
	Name: on_player_spawned
	Namespace: sd
	Checksum: 0x8BE7EF9
	Offset: 0x178
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function on_player_spawned(localclientnum)
{
	self thread player_sound_context_hack();
	self thread globallogic::watch_plant_sound(localclientnum);
}

/*
	Name: player_sound_context_hack
	Namespace: sd
	Checksum: 0x40B028A5
	Offset: 0x1C0
	Size: 0x7E
	Parameters: 0
	Flags: None
*/
function player_sound_context_hack()
{
	if(getgametypesetting("silentPlant") != 0)
	{
		self endon(#"entityshutdown");
		self notify(#"player_sound_context_hack");
		self endon(#"player_sound_context_hack");
		while(true)
		{
			self setsoundentcontext("bomb_plant", "silent");
			wait(1);
		}
	}
}

