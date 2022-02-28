// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace spectating;

/*
	Name: __init__sytem__
	Namespace: spectating
	Checksum: 0xA7F8E255
	Offset: 0x110
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("spectating", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: spectating
	Checksum: 0x663AE2B6
	Offset: 0x150
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&main);
}

/*
	Name: main
	Namespace: spectating
	Checksum: 0xB3433432
	Offset: 0x180
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	foreach(team in level.teams)
	{
		level.spectateoverride[team] = spawnstruct();
	}
	callback::on_connecting(&on_player_connecting);
}

/*
	Name: on_player_connecting
	Namespace: spectating
	Checksum: 0xCE59167C
	Offset: 0x248
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function on_player_connecting()
{
	callback::on_joined_team(&on_joined_team);
	callback::on_spawned(&on_player_spawned);
	callback::on_joined_spectate(&on_joined_spectate);
}

/*
	Name: on_player_spawned
	Namespace: spectating
	Checksum: 0xF208C339
	Offset: 0x2B8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self endon(#"disconnect");
	self setspectatepermissions();
}

/*
	Name: on_joined_team
	Namespace: spectating
	Checksum: 0xE6EBF1EC
	Offset: 0x2E8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function on_joined_team()
{
	self endon(#"disconnect");
	self setspectatepermissionsformachine();
}

/*
	Name: on_joined_spectate
	Namespace: spectating
	Checksum: 0x76AA7F1A
	Offset: 0x318
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function on_joined_spectate()
{
	self endon(#"disconnect");
	self setspectatepermissionsformachine();
}

/*
	Name: updatespectatesettings
	Namespace: spectating
	Checksum: 0x8FA82224
	Offset: 0x348
	Size: 0x5E
	Parameters: 0
	Flags: None
*/
function updatespectatesettings()
{
	level endon(#"game_ended");
	for(index = 0; index < level.players.size; index++)
	{
		level.players[index] setspectatepermissions();
	}
}

/*
	Name: getsplitscreenteam
	Namespace: spectating
	Checksum: 0x706E7BF1
	Offset: 0x3B0
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function getsplitscreenteam()
{
	for(index = 0; index < level.players.size; index++)
	{
		if(!isdefined(level.players[index]))
		{
			continue;
		}
		if(level.players[index] == self)
		{
			continue;
		}
		if(!self isplayeronsamemachine(level.players[index]))
		{
			continue;
		}
		team = level.players[index].sessionteam;
		if(team != "spectator")
		{
			return team;
		}
	}
	return self.sessionteam;
}

/*
	Name: otherlocalplayerstillalive
	Namespace: spectating
	Checksum: 0x4B1FF96D
	Offset: 0x488
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function otherlocalplayerstillalive()
{
	for(index = 0; index < level.players.size; index++)
	{
		if(!isdefined(level.players[index]))
		{
			continue;
		}
		if(level.players[index] == self)
		{
			continue;
		}
		if(!self isplayeronsamemachine(level.players[index]))
		{
			continue;
		}
		if(isalive(level.players[index]))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: allowspectateallteams
	Namespace: spectating
	Checksum: 0x434309F6
	Offset: 0x548
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function allowspectateallteams(allow)
{
	foreach(team in level.teams)
	{
		self allowspectateteam(team, allow);
	}
}

/*
	Name: allowspectateallteamsexceptteam
	Namespace: spectating
	Checksum: 0x190F26BB
	Offset: 0x5F0
	Size: 0xB2
	Parameters: 2
	Flags: Linked
*/
function allowspectateallteamsexceptteam(skip_team, allow)
{
	foreach(team in level.teams)
	{
		if(team == skip_team)
		{
			continue;
		}
		self allowspectateteam(team, allow);
	}
}

/*
	Name: setspectatepermissions
	Namespace: spectating
	Checksum: 0xFCCC78F2
	Offset: 0x6B0
	Size: 0x524
	Parameters: 0
	Flags: Linked
*/
function setspectatepermissions()
{
	team = self.sessionteam;
	if(team == "spectator")
	{
		if(self issplitscreen() && !level.splitscreen)
		{
			team = getsplitscreenteam();
		}
		if(team == "spectator")
		{
			self allowspectateallteams(1);
			self allowspectateteam("freelook", 0);
			self allowspectateteam("none", 1);
			self allowspectateteam("localplayers", 1);
			return;
		}
	}
	spectatetype = level.spectatetype;
	switch(spectatetype)
	{
		case 0:
		{
			self allowspectateallteams(0);
			self allowspectateteam("freelook", 0);
			self allowspectateteam("none", 1);
			self allowspectateteam("localplayers", 0);
			break;
		}
		case 3:
		{
			if(self issplitscreen() && self otherlocalplayerstillalive())
			{
				self allowspectateallteams(0);
				self allowspectateteam("none", 0);
				self allowspectateteam("freelook", 0);
				self allowspectateteam("localplayers", 1);
				break;
			}
		}
		case 1:
		{
			if(!level.teambased)
			{
				self allowspectateallteams(1);
				self allowspectateteam("none", 1);
				self allowspectateteam("freelook", 0);
				self allowspectateteam("localplayers", 1);
			}
			else
			{
				if(isdefined(team) && isdefined(level.teams[team]))
				{
					self allowspectateteam(team, 1);
					self allowspectateallteamsexceptteam(team, 0);
					self allowspectateteam("freelook", 0);
					self allowspectateteam("none", 0);
					self allowspectateteam("localplayers", 1);
				}
				else
				{
					self allowspectateallteams(0);
					self allowspectateteam("freelook", 0);
					self allowspectateteam("none", 0);
					self allowspectateteam("localplayers", 1);
				}
			}
			break;
		}
		case 2:
		{
			self allowspectateallteams(1);
			self allowspectateteam("freelook", 1);
			self allowspectateteam("none", 1);
			self allowspectateteam("localplayers", 1);
			break;
		}
	}
	if(isdefined(team) && isdefined(level.teams[team]))
	{
		if(isdefined(level.spectateoverride[team].allowfreespectate))
		{
			self allowspectateteam("freelook", 1);
		}
		if(isdefined(level.spectateoverride[team].allowenemyspectate))
		{
			self allowspectateallteamsexceptteam(team, 1);
		}
	}
}

/*
	Name: setspectatepermissionsformachine
	Namespace: spectating
	Checksum: 0xC780025D
	Offset: 0xBE0
	Size: 0xDE
	Parameters: 0
	Flags: Linked
*/
function setspectatepermissionsformachine()
{
	self setspectatepermissions();
	if(!self issplitscreen())
	{
		return;
	}
	for(index = 0; index < level.players.size; index++)
	{
		if(!isdefined(level.players[index]))
		{
			continue;
		}
		if(level.players[index] == self)
		{
			continue;
		}
		if(!self isplayeronsamemachine(level.players[index]))
		{
			continue;
		}
		level.players[index] setspectatepermissions();
	}
}

