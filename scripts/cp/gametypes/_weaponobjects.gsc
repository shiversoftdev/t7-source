// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons_shared;

#namespace weaponobjects;

/*
	Name: __init__sytem__
	Namespace: weaponobjects
	Checksum: 0xC1B2AED3
	Offset: 0x1D0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("weaponobjects", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: weaponobjects
	Checksum: 0xA9CD6A7A
	Offset: 0x210
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
	callback::on_start_gametype(&start_gametype);
}

/*
	Name: start_gametype
	Namespace: weaponobjects
	Checksum: 0x609C463A
	Offset: 0x250
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function start_gametype()
{
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: weaponobjects
	Checksum: 0x57416167
	Offset: 0x2A0
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	for(watcher = 0; watcher < self.weaponobjectwatcherarray.size; watcher++)
	{
		if(self.weaponobjectwatcherarray[watcher].name == "spike_charge")
		{
			arrayremoveindex(self.weaponobjectwatcherarray, watcher);
		}
	}
	self createspikelauncherwatcher("spike_launcher");
}

