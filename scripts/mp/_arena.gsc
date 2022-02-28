// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\teams\_teams;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace arena;

/*
	Name: __init__sytem__
	Namespace: arena
	Checksum: 0x53C11B50
	Offset: 0x1A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("arena", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: arena
	Checksum: 0x50926AA4
	Offset: 0x1E8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_connect(&on_connect);
}

/*
	Name: on_connect
	Namespace: arena
	Checksum: 0xBE742470
	Offset: 0x218
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function on_connect()
{
	if(isdefined(self.pers["arenaInit"]) && self.pers["arenaInit"] == 1)
	{
		return;
	}
	draftenabled = getgametypesetting("pregameDraftEnabled") == 1;
	voteenabled = getgametypesetting("pregameItemVoteEnabled") == 1;
	if(!draftenabled && !voteenabled)
	{
		self arenabeginmatch();
	}
	self.pers["arenaInit"] = 1;
}

/*
	Name: update_arena_challenge_seasons
	Namespace: arena
	Checksum: 0x33AFBEE2
	Offset: 0x2F0
	Size: 0x172
	Parameters: 0
	Flags: Linked
*/
function update_arena_challenge_seasons()
{
	perseasonwins = self getdstat("arenaPerSeasonStats", "wins");
	if(perseasonwins >= getdvarint("arena_seasonVetChallengeWins"))
	{
		arenaslot = arenagetslot();
		currentseason = self getdstat("arenaStats", arenaslot, "season");
		seasonvetchallengearraycount = self getdstatarraycount("arenaChallengeSeasons");
		for(i = 0; i < seasonvetchallengearraycount; i++)
		{
			challengeseason = self getdstat("arenaChallengeSeasons", i);
			if(challengeseason == currentseason)
			{
				return;
			}
			if(challengeseason == 0)
			{
				self setdstat("arenaChallengeSeasons", i, currentseason);
				break;
			}
		}
	}
}

/*
	Name: match_end
	Namespace: arena
	Checksum: 0x90B2B63A
	Offset: 0x470
	Size: 0x136
	Parameters: 1
	Flags: Linked
*/
function match_end(winner)
{
	for(index = 0; index < level.players.size; index++)
	{
		player = level.players[index];
		if(isdefined(player.pers["arenaInit"]) && player.pers["arenaInit"] == 1)
		{
			if(winner == "tie")
			{
				player arenaendmatch(0);
				continue;
			}
			if(winner == player.pers["team"])
			{
				player arenaendmatch(1);
				player update_arena_challenge_seasons();
				continue;
			}
			player arenaendmatch(-1);
		}
	}
}

