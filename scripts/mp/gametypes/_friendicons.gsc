// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace friendicons;

/*
	Name: __init__sytem__
	Namespace: friendicons
	Checksum: 0xBF04A5EF
	Offset: 0x120
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("friendicons", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: friendicons
	Checksum: 0xD33BEB90
	Offset: 0x160
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: friendicons
	Checksum: 0x56ACE878
	Offset: 0x190
	Size: 0x136
	Parameters: 0
	Flags: Linked
*/
function init()
{
	if(!level.teambased)
	{
		return;
	}
	if(getdvarstring("scr_drawfriend") == "")
	{
		setdvar("scr_drawfriend", "0");
	}
	level.drawfriend = getdvarint("scr_drawfriend");
	/#
		assert(isdefined(game[""]), "");
	#/
	/#
		assert(isdefined(game[""]), "");
	#/
	callback::on_spawned(&on_player_spawned);
	callback::on_player_killed(&on_player_killed);
	for(;;)
	{
		updatefriendiconsettings();
		wait(5);
	}
}

/*
	Name: on_player_killed
	Namespace: friendicons
	Checksum: 0x5DCEE5CD
	Offset: 0x2D0
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function on_player_killed()
{
	self endon(#"disconnect");
	self.headicon = "";
}

/*
	Name: on_player_spawned
	Namespace: friendicons
	Checksum: 0x3CF82493
	Offset: 0x2F8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self endon(#"disconnect");
	self thread showfriendicon();
}

/*
	Name: showfriendicon
	Namespace: friendicons
	Checksum: 0xAA94CF75
	Offset: 0x328
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function showfriendicon()
{
	if(level.drawfriend)
	{
		team = self.pers["team"];
		self.headicon = game["headicon_" + team];
		self.headiconteam = team;
	}
}

/*
	Name: updatefriendiconsettings
	Namespace: friendicons
	Checksum: 0xAF5C97E9
	Offset: 0x388
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function updatefriendiconsettings()
{
	drawfriend = getdvarfloat("scr_drawfriend");
	if(level.drawfriend != drawfriend)
	{
		level.drawfriend = drawfriend;
		updatefriendicons();
	}
}

/*
	Name: updatefriendicons
	Namespace: friendicons
	Checksum: 0x714BBACA
	Offset: 0x3E8
	Size: 0x1B0
	Parameters: 0
	Flags: Linked
*/
function updatefriendicons()
{
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
		{
			if(level.drawfriend)
			{
				team = self.pers["team"];
				self.headicon = game["headicon_" + team];
				self.headiconteam = team;
				continue;
			}
			players = level.players;
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
				if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
				{
					player.headicon = "";
				}
			}
		}
	}
}

