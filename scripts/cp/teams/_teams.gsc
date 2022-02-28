// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\cp\gametypes\_globallogic_ui;
#using scripts\cp\gametypes\_spectating;
#using scripts\shared\callbacks_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace teams;

/*
	Name: __init__sytem__
	Namespace: teams
	Checksum: 0xD34417CA
	Offset: 0x2D8
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
	Checksum: 0xAFE4D79
	Offset: 0x318
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
	level.getenemyteam = &getenemyteam;
}

/*
	Name: init
	Namespace: teams
	Checksum: 0xF4D87849
	Offset: 0x360
	Size: 0x224
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
		level thread update_player_times();
	}
	else
	{
		callback::on_connect(&on_free_player_connect);
		wait(0.15);
		level thread update_player_times();
	}
}

/*
	Name: on_player_connect
	Namespace: teams
	Checksum: 0xDC65AB83
	Offset: 0x590
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
	Checksum: 0x3CDDBD8E
	Offset: 0x5B8
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
	Checksum: 0xCA5BBFCB
	Offset: 0x5E0
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
	Checksum: 0x3A6C880A
	Offset: 0x638
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
	Checksum: 0x71F33AD3
	Offset: 0x658
	Size: 0x224
	Parameters: 0
	Flags: Linked
*/
function track_played_time()
{
	self endon(#"disconnect");
	self endon(#"killplayedtimemonitor");
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
	Checksum: 0x6D0C53C5
	Offset: 0x888
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
	Checksum: 0xC3111A0D
	Offset: 0x978
	Size: 0x382
	Parameters: 0
	Flags: Linked
*/
function update_played_time()
{
	pixbeginevent("updatePlayedTime");
	foreach(team in level.teams)
	{
		if(self.timeplayed[team])
		{
			self addplayerstat("time_played_" + team, int(min(self.timeplayed[team], level.timeplayedcap)));
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
	Checksum: 0xF88E0480
	Offset: 0xD08
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
	Checksum: 0x37726B91
	Offset: 0xD48
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
	Checksum: 0x1181ABF1
	Offset: 0xE20
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
	Checksum: 0xA4DE2AED
	Offset: 0xF98
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
	Checksum: 0x99BFA1BF
	Offset: 0x1110
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
	Checksum: 0xCE01BF65
	Offset: 0x12B8
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
	Checksum: 0x9B518BCF
	Offset: 0x1338
	Size: 0x6C
	Parameters: 1
	Flags: None
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
	Checksum: 0x2E219FD
	Offset: 0x13B0
	Size: 0x6C
	Parameters: 1
	Flags: None
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
	Name: get_flag_icon
	Namespace: teams
	Checksum: 0xD80F8B81
	Offset: 0x1428
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function get_flag_icon(teamref)
{
	/#
		assert(isdefined(game[""]));
	#/
	/#
		assert(isdefined(game[""][teamref]));
	#/
	return game["carry_icon"][teamref];
}

/*
	Name: getenemyteam
	Namespace: teams
	Checksum: 0x18C46D3F
	Offset: 0x14A0
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

