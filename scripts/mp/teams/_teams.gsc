// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic_ui;
#using scripts\mp\gametypes\_spectating;
#using scripts\shared\callbacks_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace teams;

/*
	Name: __init__sytem__
	Namespace: teams
	Checksum: 0xE4C4FF14
	Offset: 0x320
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("teams", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: teams
	Checksum: 0xED96DA9D
	Offset: 0x360
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
	level.getenemyteam = &getenemyteam;
	level.use_team_based_logic_for_locking_on = 1;
}

/*
	Name: init
	Namespace: teams
	Checksum: 0xECD73FA6
	Offset: 0x3B0
	Size: 0x234
	Parameters: 0
	Flags: Linked
*/
function init()
{
	game["strings"]["autobalance"] = &"MP_AUTOBALANCE_NOW";
	if(getdvarstring("scr_teambalance") == "")
	{
		setdvar("scr_teambalance", "0");
	}
	level.teambalance = getdvarint("scr_teambalance");
	level.teambalancetimer = 0;
	if(getdvarstring("scr_timeplayedcap") == "")
	{
		setdvar("scr_timeplayedcap", "1800");
	}
	level.timeplayedcap = int(getdvarint("scr_timeplayedcap"));
	level.freeplayers = [];
	if(level.teambased)
	{
		level.alliesplayers = [];
		level.axisplayers = [];
		callback::on_connect(&on_player_connect);
		callback::on_joined_team(&on_joined_team);
		callback::on_joined_spectate(&on_joined_spectators);
		level thread update_balance_dvar();
		wait(0.15);
		if(level.onlinegame)
		{
			level thread update_player_times();
		}
	}
	else
	{
		callback::on_connect(&on_free_player_connect);
		wait(0.15);
		if(level.onlinegame)
		{
			level thread update_player_times();
		}
	}
}

/*
	Name: on_player_connect
	Namespace: teams
	Checksum: 0xA8F8A694
	Offset: 0x5F0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self thread track_played_time();
}

/*
	Name: on_free_player_connect
	Namespace: teams
	Checksum: 0x63289757
	Offset: 0x618
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_free_player_connect()
{
	self thread track_free_played_time();
}

/*
	Name: on_joined_team
	Namespace: teams
	Checksum: 0xF5184102
	Offset: 0x640
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function on_joined_team()
{
	/#
		println("" + self.pers[""]);
	#/
	self update_time();
}

/*
	Name: on_joined_spectators
	Namespace: teams
	Checksum: 0x1D83FB76
	Offset: 0x698
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function on_joined_spectators()
{
	self.pers["teamTime"] = undefined;
}

/*
	Name: track_played_time
	Namespace: teams
	Checksum: 0xE29D8516
	Offset: 0x6B8
	Size: 0x28C
	Parameters: 0
	Flags: Linked
*/
function track_played_time()
{
	self endon(#"disconnect");
	if(!isdefined(self.pers["totalTimePlayed"]))
	{
		self.pers["totalTimePlayed"] = 0;
	}
	foreach(team in level.teams)
	{
		self.timeplayed[team] = 0;
	}
	self.timeplayed["free"] = 0;
	self.timeplayed["other"] = 0;
	self.timeplayed["alive"] = 0;
	if(!isdefined(self.timeplayed["total"]) || (!(level.gametype == "twar" && 0 < game["roundsplayed"] && 0 < self.timeplayed["total"])))
	{
		self.timeplayed["total"] = 0;
	}
	while(level.inprematchperiod)
	{
		wait(0.05);
	}
	for(;;)
	{
		if(game["state"] == "playing")
		{
			if(isdefined(level.teams[self.sessionteam]))
			{
				self.timeplayed[self.sessionteam]++;
				self.timeplayed["total"]++;
				if(level.mpcustommatch)
				{
					self.pers["sbtimeplayed"] = self.timeplayed["total"];
					self.sbtimeplayed = self.pers["sbtimeplayed"];
				}
				if(isalive(self))
				{
					self.timeplayed["alive"]++;
				}
			}
			else if(self.sessionteam == "spectator")
			{
				self.timeplayed["other"]++;
			}
		}
		wait(1);
	}
}

/*
	Name: update_player_times
	Namespace: teams
	Checksum: 0xED0FBF6D
	Offset: 0x950
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function update_player_times()
{
	varwait = 10;
	nexttoupdate = 0;
	for(;;)
	{
		varwait = varwait - 1;
		nexttoupdate++;
		if(nexttoupdate >= level.players.size)
		{
			nexttoupdate = 0;
			if(varwait > 0)
			{
				wait(varwait);
			}
			varwait = 10;
		}
		if(isdefined(level.players[nexttoupdate]))
		{
			level.players[nexttoupdate] update_played_time();
			level.players[nexttoupdate] persistence::check_contract_expirations();
		}
		wait(1);
	}
}

/*
	Name: update_played_time
	Namespace: teams
	Checksum: 0xAD5E0249
	Offset: 0xA40
	Size: 0x41A
	Parameters: 0
	Flags: Linked
*/
function update_played_time()
{
	pixbeginevent("updatePlayedTime");
	if(level.rankedmatch || level.leaguematch)
	{
		foreach(team in level.teams)
		{
			if(self.timeplayed[team])
			{
				if(level.teambased)
				{
					self addplayerstat("time_played_" + team, int(min(self.timeplayed[team], level.timeplayedcap)));
				}
				self addplayerstatwithgametype("time_played_total", int(min(self.timeplayed[team], level.timeplayedcap)));
			}
		}
		if(self.timeplayed["other"])
		{
			self addplayerstat("time_played_other", int(min(self.timeplayed["other"], level.timeplayedcap)));
			self addplayerstatwithgametype("time_played_total", int(min(self.timeplayed["other"], level.timeplayedcap)));
		}
		if(self.timeplayed["alive"])
		{
			timealive = int(min(self.timeplayed["alive"], level.timeplayedcap));
			self persistence::increment_contract_times(timealive);
			self addplayerstat("time_played_alive", timealive);
		}
	}
	if(level.onlinegame)
	{
		timealive = int(min(self.timeplayed["alive"], level.timeplayedcap));
		self.pers["time_played_alive"] = self.pers["time_played_alive"] + timealive;
	}
	pixendevent();
	if(game["state"] == "postgame")
	{
		return;
	}
	foreach(team in level.teams)
	{
		self.timeplayed[team] = 0;
	}
	self.timeplayed["other"] = 0;
	self.timeplayed["alive"] = 0;
}

/*
	Name: update_time
	Namespace: teams
	Checksum: 0x681E707E
	Offset: 0xE68
	Size: 0x32
	Parameters: 0
	Flags: Linked
*/
function update_time()
{
	if(game["state"] != "playing")
	{
		return;
	}
	self.pers["teamTime"] = gettime();
}

/*
	Name: update_balance_dvar
	Namespace: teams
	Checksum: 0xB13D8352
	Offset: 0xEA8
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function update_balance_dvar()
{
	for(;;)
	{
		teambalance = getdvarint("scr_teambalance");
		if(level.teambalance != teambalance)
		{
			level.teambalance = getdvarint("scr_teambalance");
		}
		timeplayedcap = getdvarint("scr_timeplayedcap");
		if(level.timeplayedcap != timeplayedcap)
		{
			level.timeplayedcap = int(getdvarint("scr_timeplayedcap"));
		}
		wait(1);
	}
}

/*
	Name: change
	Namespace: teams
	Checksum: 0xD8DA7570
	Offset: 0xF80
	Size: 0x16A
	Parameters: 1
	Flags: None
*/
function change(team)
{
	if(self.sessionstate != "dead")
	{
		self.switching_teams = 1;
		self.switchedteamsresetgadgets = 1;
		self.joining_team = team;
		self.leaving_team = self.pers["team"];
		self suicide();
	}
	self.pers["team"] = team;
	self.team = team;
	self.pers["weapon"] = undefined;
	self.pers["spawnweapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	self.pers["teamTime"] = undefined;
	self.sessionteam = self.pers["team"];
	self globallogic_ui::updateobjectivetext();
	self spectating::set_permissions();
	self setclientscriptmainmenu(game["menu_start_menu"]);
	self openmenu(game["menu_start_menu"]);
	self notify(#"end_respawn");
}

/*
	Name: count_players
	Namespace: teams
	Checksum: 0xB89698BF
	Offset: 0x10F8
	Size: 0x170
	Parameters: 0
	Flags: Linked
*/
function count_players()
{
	players = level.players;
	playercounts = [];
	foreach(team in level.teams)
	{
		playercounts[team] = 0;
	}
	foreach(player in level.players)
	{
		if(player == self)
		{
			continue;
		}
		team = player.pers["team"];
		if(isdefined(team) && isdefined(level.teams[team]))
		{
			playercounts[team]++;
		}
	}
	return playercounts;
}

/*
	Name: track_free_played_time
	Namespace: teams
	Checksum: 0x50570ACB
	Offset: 0x1270
	Size: 0x1A0
	Parameters: 0
	Flags: Linked
*/
function track_free_played_time()
{
	self endon(#"disconnect");
	foreach(team in level.teams)
	{
		self.timeplayed[team] = 0;
	}
	self.timeplayed["other"] = 0;
	self.timeplayed["total"] = 0;
	self.timeplayed["alive"] = 0;
	for(;;)
	{
		if(game["state"] == "playing")
		{
			team = self.pers["team"];
			if(isdefined(team) && isdefined(level.teams[team]) && self.sessionteam != "spectator")
			{
				self.timeplayed[team]++;
				self.timeplayed["total"]++;
				if(isalive(self))
				{
					self.timeplayed["alive"]++;
				}
			}
			else
			{
				self.timeplayed["other"]++;
			}
		}
		wait(1);
	}
}

/*
	Name: set_player_model
	Namespace: teams
	Checksum: 0xF03C7348
	Offset: 0x1418
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function set_player_model(team, weapon)
{
	self detachall();
	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
}

/*
	Name: get_flag_model
	Namespace: teams
	Checksum: 0xF2202718
	Offset: 0x1498
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function get_flag_model(teamref)
{
	/#
		assert(isdefined(game[""]));
	#/
	/#
		assert(isdefined(game[""][teamref]));
	#/
	return game["flagmodels"][teamref];
}

/*
	Name: get_flag_carry_model
	Namespace: teams
	Checksum: 0x363FBB5E
	Offset: 0x1510
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function get_flag_carry_model(teamref)
{
	/#
		assert(isdefined(game[""]));
	#/
	/#
		assert(isdefined(game[""][teamref]));
	#/
	return game["carry_flagmodels"][teamref];
}

/*
	Name: getteamindex
	Namespace: teams
	Checksum: 0x7EF0F9BA
	Offset: 0x1588
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function getteamindex(team)
{
	if(!isdefined(team))
	{
		return 0;
	}
	if(team == "free")
	{
		return 0;
	}
	if(team == "allies")
	{
		return 1;
	}
	if(team == "axis")
	{
		return 2;
	}
	return 0;
}

/*
	Name: getenemyteam
	Namespace: teams
	Checksum: 0x9FC9F4D5
	Offset: 0x15F0
	Size: 0xBA
	Parameters: 1
	Flags: Linked
*/
function getenemyteam(player_team)
{
	foreach(team in level.teams)
	{
		if(team == player_team)
		{
			continue;
		}
		if(team == "spectator")
		{
			continue;
		}
		return team;
	}
	return util::getotherteam(player_team);
}

/*
	Name: getenemyplayers
	Namespace: teams
	Checksum: 0x3C833CCF
	Offset: 0x16B8
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function getenemyplayers()
{
	enemies = [];
	foreach(player in level.players)
	{
		if(player.team == "spectator")
		{
			continue;
		}
		if(level.teambased && player.team != self.team || (!level.teambased && player != self))
		{
			if(!isdefined(enemies))
			{
				enemies = [];
			}
			else if(!isarray(enemies))
			{
				enemies = array(enemies);
			}
			enemies[enemies.size] = player;
		}
	}
	return enemies;
}

/*
	Name: getfriendlyplayers
	Namespace: teams
	Checksum: 0x90F6EC45
	Offset: 0x1800
	Size: 0x10C
	Parameters: 0
	Flags: None
*/
function getfriendlyplayers()
{
	friendlies = [];
	foreach(player in level.players)
	{
		if(player.team == self.team && player != self)
		{
			if(!isdefined(friendlies))
			{
				friendlies = [];
			}
			else if(!isarray(friendlies))
			{
				friendlies = array(friendlies);
			}
			friendlies[friendlies.size] = player;
		}
	}
	return friendlies;
}

/*
	Name: waituntilteamchange
	Namespace: teams
	Checksum: 0x2580118F
	Offset: 0x1918
	Size: 0xC0
	Parameters: 6
	Flags: Linked
*/
function waituntilteamchange(player, callback, arg, end_condition1, end_condition2, end_condition3)
{
	if(isdefined(end_condition1))
	{
		self endon(end_condition1);
	}
	if(isdefined(end_condition2))
	{
		self endon(end_condition2);
	}
	if(isdefined(end_condition3))
	{
		self endon(end_condition3);
	}
	event = player util::waittill_any("joined_team", "disconnect", "joined_spectators");
	if(isdefined(callback))
	{
		self [[callback]](arg, event);
	}
}

/*
	Name: waituntilteamchangesingleton
	Namespace: teams
	Checksum: 0x9767E803
	Offset: 0x19E0
	Size: 0xE0
	Parameters: 7
	Flags: Linked
*/
function waituntilteamchangesingleton(player, singletonstring, callback, arg, end_condition1, end_condition2, end_condition3)
{
	self notify(singletonstring);
	self endon(singletonstring);
	if(isdefined(end_condition1))
	{
		self endon(end_condition1);
	}
	if(isdefined(end_condition2))
	{
		self endon(end_condition2);
	}
	if(isdefined(end_condition3))
	{
		self endon(end_condition3);
	}
	event = player util::waittill_any("joined_team", "disconnect", "joined_spectators");
	if(isdefined(callback))
	{
		self thread [[callback]](arg, event);
	}
}

/*
	Name: hidetosameteam
	Namespace: teams
	Checksum: 0xD678EE7A
	Offset: 0x1AC8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function hidetosameteam()
{
	if(level.teambased)
	{
		self setvisibletoallexceptteam(self.team);
	}
	else
	{
		self setvisibletoall();
		self setinvisibletoplayer(self.owner);
	}
}

