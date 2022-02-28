// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace hud_message;

/*
	Name: init
	Namespace: hud_message
	Checksum: 0x4178C43B
	Offset: 0x5E8
	Size: 0x2E2
	Parameters: 0
	Flags: Linked
*/
function init()
{
	game["strings"]["draw"] = &"MP_DRAW_CAPS";
	game["strings"]["round_draw"] = &"MP_ROUND_DRAW_CAPS";
	game["strings"]["round_win"] = &"MP_ROUND_WIN_CAPS";
	game["strings"]["round_loss"] = &"MP_ROUND_LOSS_CAPS";
	game["strings"]["victory"] = &"MP_VICTORY_CAPS";
	game["strings"]["defeat"] = &"MP_DEFEAT_CAPS";
	game["strings"]["top3"] = &"MP_TOP3_CAPS";
	game["strings"]["game_over"] = &"MP_GAME_OVER_CAPS";
	game["strings"]["halftime"] = &"MP_HALFTIME_CAPS";
	game["strings"]["overtime"] = &"MP_OVERTIME_CAPS";
	game["strings"]["roundend"] = &"MP_ROUNDEND_CAPS";
	game["strings"]["intermission"] = &"MP_INTERMISSION_CAPS";
	game["strings"]["side_switch"] = &"MP_SWITCHING_SIDES_CAPS";
	game["strings"]["match_bonus"] = &"MP_MATCH_BONUS_IS";
	game["strings"]["codpoints_match_bonus"] = &"MP_CODPOINTS_MATCH_BONUS_IS";
	game["strings"]["wager_winnings"] = &"MP_WAGER_WINNINGS_ARE";
	game["strings"]["wager_sidebet_winnings"] = &"MP_WAGER_SIDEBET_WINNINGS_ARE";
	game["strings"]["wager_inthemoney"] = &"MP_WAGER_IN_THE_MONEY_CAPS";
	game["strings"]["wager_loss"] = &"MP_WAGER_LOSS_CAPS";
	game["strings"]["wager_topwinners"] = &"MP_WAGER_TOPWINNERS";
	game["strings"]["join_in_progress_loss"] = &"MP_JOIN_IN_PROGRESS_LOSS";
	game["strings"]["cod_caster_team_wins"] = &"MP_WINS";
	game["strings"]["cod_caster_team_eliminated"] = &"MP_TEAM_ELIMINATED";
}

/*
	Name: teamoutcomenotify
	Namespace: hud_message
	Checksum: 0x13443E2B
	Offset: 0x8D8
	Size: 0xB9C
	Parameters: 3
	Flags: Linked
*/
function teamoutcomenotify(winner, endtype, endreasontext)
{
	self endon(#"disconnect");
	self notify(#"reset_outcome");
	team = self.pers["team"];
	if(team != "spectator" && (!isdefined(team) || !isdefined(level.teams[team])))
	{
		team = "allies";
	}
	while(self.doingnotify)
	{
		wait(0.05);
	}
	self endon(#"reset_outcome");
	outcometext = "";
	notifyroundendtoui = undefined;
	overridespectator = 0;
	if(endtype == "halftime")
	{
		outcometext = game["strings"]["halftime"];
		notifyroundendtoui = 1;
	}
	else
	{
		if(endtype == "intermission")
		{
			outcometext = game["strings"]["intermission"];
			notifyroundendtoui = 1;
		}
		else
		{
			if(endtype == "overtime")
			{
				outcometext = game["strings"]["overtime"];
				notifyroundendtoui = 1;
			}
			else
			{
				if(endtype == "roundend")
				{
					if(winner == "tie")
					{
						outcometext = game["strings"]["round_draw"];
					}
					else
					{
						if(isdefined(self.pers["team"]) && winner == team)
						{
							outcometext = game["strings"]["round_win"];
							overridespectator = 1;
						}
						else
						{
							outcometext = game["strings"]["round_loss"];
							if(isdefined(level.enddefeatreasontext))
							{
								endreasontext = level.enddefeatreasontext;
							}
							overridespectator = 1;
						}
					}
					notifyroundendtoui = 1;
				}
				else if(endtype == "gameend")
				{
					if(winner == "tie")
					{
						outcometext = game["strings"]["draw"];
					}
					else
					{
						if(isdefined(self.pers["team"]) && winner == team)
						{
							outcometext = game["strings"]["victory"];
							overridespectator = 1;
						}
						else
						{
							outcometext = game["strings"]["defeat"];
							if(isdefined(level.enddefeatreasontext))
							{
								endreasontext = level.enddefeatreasontext;
							}
							if(level.rankedmatch || level.leaguematch && self.pers["lateJoin"] === 1)
							{
								endreasontext = game["strings"]["join_in_progress_loss"];
							}
							overridespectator = 1;
						}
					}
					notifyroundendtoui = 0;
				}
			}
		}
	}
	matchbonus = 0;
	if(isdefined(self.pers["totalMatchBonus"]))
	{
		bonus = ceil(self.pers["totalMatchBonus"] * level.xpscale);
		if(bonus > 0)
		{
			matchbonus = bonus;
		}
	}
	winnerenum = 0;
	if(winner == "allies")
	{
		winnerenum = 1;
	}
	else if(winner == "axis")
	{
		winnerenum = 2;
	}
	if(isdefined(level.var_c17c938d) && [[level.var_c17c938d]](winner, endtype, endreasontext, outcometext, team, winnerenum, notifyroundendtoui, matchbonus))
	{
	}
	else
	{
		if(level.gametype == "ctf" || level.gametype == "escort" || level.gametype == "ball" && isdefined(game["overtime_round"]))
		{
			if(game["overtime_round"] == 1)
			{
				if(isdefined(game[level.gametype + "_overtime_first_winner"]))
				{
					winner = game[level.gametype + "_overtime_first_winner"];
				}
				if(isdefined(winner) && winner != "tie")
				{
					winningtime = game[level.gametype + "_overtime_time_to_beat"];
				}
			}
			else
			{
				if(isdefined(game[level.gametype + "_overtime_first_winner"]) && (game[level.gametype + "_overtime_first_winner"]) == "tie")
				{
					winningtime = game[level.gametype + "_overtime_best_time"];
				}
				else
				{
					winningtime = undefined;
					if(winner == "tie" && isdefined(game[level.gametype + "_overtime_first_winner"]))
					{
						if((game[level.gametype + "_overtime_first_winner"]) == "allies")
						{
							winnerenum = 1;
						}
						else if((game[level.gametype + "_overtime_first_winner"]) == "axis")
						{
							winnerenum = 2;
						}
					}
					if(isdefined(game[level.gametype + "_overtime_time_to_beat"]))
					{
						winningtime = game[level.gametype + "_overtime_time_to_beat"];
					}
					if(isdefined(game[level.gametype + "_overtime_best_time"]) && (!isdefined(winningtime) || winningtime > (game[level.gametype + "_overtime_best_time"])))
					{
						if((game[level.gametype + "_overtime_first_winner"]) !== winner)
						{
							losingtime = winningtime;
						}
						winningtime = game[level.gametype + "_overtime_best_time"];
						if(winner === "tie")
						{
							winningtime = 0;
						}
					}
				}
				if(level.gametype == "escort" && winner === "tie")
				{
					winnerenum = 0;
					if(!(isdefined(level.finalgameend) && level.finalgameend))
					{
						if(game["defenders"] == team)
						{
							outcometext = game["strings"]["round_win"];
						}
						else
						{
							outcometext = game["strings"]["round_loss"];
						}
					}
				}
			}
			if(!isdefined(winningtime))
			{
				winningtime = 0;
			}
			if(!isdefined(losingtime))
			{
				losingtime = 0;
			}
			if(winningtime == 0 && losingtime == 0)
			{
				winnerenum = 0;
			}
			if(team == "spectator" && overridespectator)
			{
				outcometext = game["strings"]["cod_caster_team_wins"];
				notifyroundendtoui = 0;
			}
			self luinotifyevent(&"show_outcome", 7, outcometext, endreasontext, int(matchbonus), winnerenum, notifyroundendtoui, int(winningtime / 1000), int(losingtime / 1000));
		}
		else
		{
			if(level.gametype == "ball" && isdefined(winner) && winner != "tie" && game["roundsplayed"] < level.roundlimit && isdefined(game["round_time_to_beat"]) && !isdefined(game["overtime_round"]))
			{
				winningtime = game["round_time_to_beat"];
				if(!isdefined(losingtime))
				{
					losingtime = 0;
				}
				switch(winner)
				{
					case "allies":
					{
						winnerenum = 1;
						break;
					}
					case "axis":
					{
						winnerenum = 2;
						break;
					}
					default:
					{
						winnerenum = 0;
					}
				}
				if(team == "spectator" && overridespectator)
				{
					outcometext = game["strings"]["cod_caster_team_wins"];
					notifyroundendtoui = 0;
				}
				self luinotifyevent(&"show_outcome", 7, outcometext, endreasontext, int(matchbonus), winnerenum, notifyroundendtoui, int(winningtime / 1000), int(losingtime / 1000));
			}
			else
			{
				if(team == "spectator" && overridespectator)
				{
					foreach(team in level.teams)
					{
						if(endreasontext == (game["strings"][team + "_eliminated"]))
						{
							endreasontext = game["strings"]["cod_caster_team_eliminated"];
							break;
						}
					}
					outcometext = game["strings"]["cod_caster_team_wins"];
					notifyroundendtoui = 0;
				}
				self luinotifyevent(&"show_outcome", 5, outcometext, endreasontext, int(matchbonus), winnerenum, notifyroundendtoui);
			}
		}
	}
}

/*
	Name: teamoutcomenotifyzombie
	Namespace: hud_message
	Checksum: 0x4CDBF92C
	Offset: 0x1480
	Size: 0x2BC
	Parameters: 3
	Flags: None
*/
function teamoutcomenotifyzombie(winner, isround, endreasontext)
{
	self endon(#"disconnect");
	self notify(#"reset_outcome");
	team = self.pers["team"];
	if(isdefined(team) && team == "spectator")
	{
		for(i = 0; i < level.players.size; i++)
		{
			if(self.currentspectatingclient == level.players[i].clientid)
			{
				team = level.players[i].pers["team"];
				break;
			}
		}
	}
	if(!isdefined(team) || !isdefined(level.teams[team]))
	{
		team = "allies";
	}
	while(self.doingnotify)
	{
		wait(0.05);
	}
	self endon(#"reset_outcome");
	if(level.splitscreen)
	{
		titlesize = 2;
		spacing = 10;
		font = "default";
	}
	else
	{
		titlesize = 3;
		spacing = 50;
		font = "objective";
	}
	outcometitle = hud::createfontstring(font, titlesize);
	outcometitle hud::setpoint("TOP", undefined, 0, spacing);
	outcometitle.glowalpha = 1;
	outcometitle.hidewheninmenu = 0;
	outcometitle.archived = 0;
	outcometitle.immunetodemogamehudsettings = 1;
	outcometitle.immunetodemofreecamera = 1;
	outcometitle settext(endreasontext);
	outcometitle setpulsefx(100, 60000, 1000);
	self thread resetoutcomenotify(undefined, undefined, outcometitle);
}

/*
	Name: outcomenotify
	Namespace: hud_message
	Checksum: 0x56F50007
	Offset: 0x1748
	Size: 0x2DC
	Parameters: 3
	Flags: Linked
*/
function outcomenotify(winner, isroundend, endreasontext)
{
	self endon(#"disconnect");
	self notify(#"reset_outcome");
	while(self.doingnotify)
	{
		wait(0.05);
	}
	self endon(#"reset_outcome");
	outcometext = "";
	players = level.placement["all"];
	numclients = players.size;
	overridespectator = 0;
	if(!util::isoneround() && !isroundend)
	{
		outcometext = game["strings"]["game_over"];
	}
	else
	{
		if(players[0].pointstowin == 0)
		{
			outcometext = game["strings"]["tie"];
		}
		else
		{
			if(self isintop(players, 1))
			{
				outcometext = game["strings"]["victory"];
				overridespectator = 1;
			}
			else
			{
				if(self isintop(players, 3))
				{
					outcometext = game["strings"]["top3"];
				}
				else
				{
					outcometext = game["strings"]["defeat"];
					overridespectator = 1;
				}
			}
		}
	}
	matchbonus = 0;
	if(isdefined(self.pers["totalMatchBonus"]))
	{
		matchbonus = self.pers["totalMatchBonus"];
	}
	wait(2);
	team = self.pers["team"];
	if(isdefined(team) && team == "spectator" && overridespectator)
	{
		outcometext = game["strings"]["cod_caster_team_wins"];
		self luinotifyevent(&"show_outcome", 5, outcometext, endreasontext, matchbonus, winner, 0);
	}
	else
	{
		self luinotifyevent(&"show_outcome", 4, outcometext, endreasontext, matchbonus, numclients);
	}
}

/*
	Name: wageroutcomenotify
	Namespace: hud_message
	Checksum: 0xA21AB923
	Offset: 0x1A30
	Size: 0xAAC
	Parameters: 2
	Flags: None
*/
function wageroutcomenotify(winner, endreasontext)
{
	self endon(#"disconnect");
	self notify(#"reset_outcome");
	while(self.doingnotify)
	{
		wait(0.05);
	}
	self endon(#"reset_outcome");
	headerfont = "extrabig";
	font = "objective";
	if(self issplitscreen())
	{
		titlesize = 2;
		winnersize = 1.5;
		othersize = 1.5;
		iconsize = 30;
		spacing = 2;
	}
	else
	{
		titlesize = 3;
		winnersize = 2;
		othersize = 1.5;
		iconsize = 30;
		spacing = 20;
	}
	halftime = 0;
	if(isdefined(level.sidebet) && level.sidebet)
	{
		halftime = 1;
	}
	duration = 60000;
	players = level.placement["all"];
	outcometitle = hud::createfontstring(headerfont, titlesize);
	outcometitle hud::setpoint("TOP", undefined, 0, spacing);
	if(halftime)
	{
		outcometitle settext(game["strings"]["intermission"]);
		outcometitle.color = (1, 1, 0);
		outcometitle.glowcolor = (1, 0, 0);
	}
	else
	{
		if(isdefined(level.dontcalcwagerwinnings) && level.dontcalcwagerwinnings == 1)
		{
			outcometitle settext(game["strings"]["wager_topwinners"]);
			outcometitle.color = (0.42, 0.68, 0.46);
		}
		else
		{
			if(isdefined(self.wagerwinnings) && self.wagerwinnings > 0)
			{
				outcometitle settext(game["strings"]["wager_inthemoney"]);
				outcometitle.color = (0.42, 0.68, 0.46);
			}
			else
			{
				outcometitle settext(game["strings"]["wager_loss"]);
				outcometitle.color = (0.73, 0.29, 0.19);
			}
		}
	}
	outcometitle.glowalpha = 1;
	outcometitle.hidewheninmenu = 0;
	outcometitle.archived = 0;
	outcometitle.immunetodemogamehudsettings = 1;
	outcometitle.immunetodemofreecamera = 1;
	outcometitle setcod7decodefx(200, duration, 600);
	outcometext = hud::createfontstring(font, 2);
	outcometext hud::setparent(outcometitle);
	outcometext hud::setpoint("TOP", "BOTTOM", 0, 0);
	outcometext.glowalpha = 1;
	outcometext.hidewheninmenu = 0;
	outcometext.archived = 0;
	outcometext.immunetodemogamehudsettings = 1;
	outcometext.immunetodemofreecamera = 1;
	outcometext settext(endreasontext);
	playernamehudelems = [];
	playercphudelems = [];
	numplayers = players.size;
	for(i = 0; i < numplayers; i++)
	{
		if(!halftime && isdefined(players[i]))
		{
			secondtitle = hud::createfontstring(font, othersize);
			if(playernamehudelems.size == 0)
			{
				secondtitle hud::setparent(outcometext);
				secondtitle hud::setpoint("TOP_LEFT", "BOTTOM", -175, spacing * 3);
			}
			else
			{
				secondtitle hud::setparent(playernamehudelems[playernamehudelems.size - 1]);
				secondtitle hud::setpoint("TOP_LEFT", "BOTTOM_LEFT", 0, spacing);
			}
			secondtitle.glowalpha = 1;
			secondtitle.hidewheninmenu = 0;
			secondtitle.archived = 0;
			secondtitle.immunetodemogamehudsettings = 1;
			secondtitle.immunetodemofreecamera = 1;
			secondtitle.label = &"MP_WAGER_PLACE_NAME";
			secondtitle.playernum = i;
			secondtitle setplayernamestring(players[i]);
			playernamehudelems[playernamehudelems.size] = secondtitle;
			secondcp = hud::createfontstring(font, othersize);
			secondcp hud::setparent(secondtitle);
			secondcp hud::setpoint("TOP_RIGHT", "TOP_LEFT", 350, 0);
			secondcp.glowalpha = 1;
			secondcp.hidewheninmenu = 0;
			secondcp.archived = 0;
			secondcp.immunetodemogamehudsettings = 1;
			secondcp.immunetodemofreecamera = 1;
			secondcp.label = &"MENU_POINTS";
			secondcp.currentvalue = 0;
			if(isdefined(players[i].wagerwinnings))
			{
				secondcp.targetvalue = players[i].wagerwinnings;
			}
			else
			{
				secondcp.targetvalue = 0;
			}
			if(secondcp.targetvalue > 0)
			{
				secondcp.color = (0.42, 0.68, 0.46);
			}
			secondcp setvalue(0);
			playercphudelems[playercphudelems.size] = secondcp;
		}
	}
	self thread updatewageroutcome(playernamehudelems, playercphudelems);
	self thread resetwageroutcomenotify(playernamehudelems, playercphudelems, outcometitle, outcometext);
	if(halftime)
	{
		return;
	}
	stillupdating = 1;
	countupduration = 2;
	cpincrement = 9999;
	if(isdefined(playercphudelems[0]))
	{
		cpincrement = int(playercphudelems[0].targetvalue / (countupduration / 0.05));
		if(cpincrement < 1)
		{
			cpincrement = 1;
		}
	}
	while(stillupdating)
	{
		stillupdating = 0;
		for(i = 0; i < playercphudelems.size; i++)
		{
			if(isdefined(playercphudelems[i]) && playercphudelems[i].currentvalue < playercphudelems[i].targetvalue)
			{
				playercphudelems[i].currentvalue = playercphudelems[i].currentvalue + cpincrement;
				if(playercphudelems[i].currentvalue > playercphudelems[i].targetvalue)
				{
					playercphudelems[i].currentvalue = playercphudelems[i].targetvalue;
				}
				playercphudelems[i] setvalue(playercphudelems[i].currentvalue);
				stillupdating = 1;
			}
		}
		wait(0.05);
	}
}

/*
	Name: teamwageroutcomenotify
	Namespace: hud_message
	Checksum: 0xCD0673CF
	Offset: 0x24E8
	Size: 0xECC
	Parameters: 3
	Flags: None
*/
function teamwageroutcomenotify(winner, isroundend, endreasontext)
{
	self endon(#"disconnect");
	self notify(#"reset_outcome");
	team = self.pers["team"];
	if(!isdefined(team) || !isdefined(level.teams[team]))
	{
		team = "allies";
	}
	wait(0.05);
	while(self.doingnotify)
	{
		wait(0.05);
	}
	self endon(#"reset_outcome");
	headerfont = "extrabig";
	font = "objective";
	if(self issplitscreen())
	{
		titlesize = 2;
		textsize = 1.5;
		iconsize = 30;
		spacing = 10;
	}
	else
	{
		titlesize = 3;
		textsize = 2;
		iconsize = 70;
		spacing = 15;
	}
	halftime = 0;
	if(isdefined(level.sidebet) && level.sidebet)
	{
		halftime = 1;
	}
	duration = 60000;
	outcometitle = hud::createfontstring(headerfont, titlesize);
	outcometitle hud::setpoint("TOP", undefined, 0, spacing);
	outcometitle.glowalpha = 1;
	outcometitle.hidewheninmenu = 0;
	outcometitle.archived = 0;
	outcometitle.immunetodemogamehudsettings = 1;
	outcometitle.immunetodemofreecamera = 1;
	outcometext = hud::createfontstring(font, 2);
	outcometext hud::setparent(outcometitle);
	outcometext hud::setpoint("TOP", "BOTTOM", 0, 0);
	outcometext.glowalpha = 1;
	outcometext.hidewheninmenu = 0;
	outcometext.archived = 0;
	outcometext.immunetodemogamehudsettings = 1;
	outcometext.immunetodemofreecamera = 1;
	if(winner == "tie")
	{
		if(isroundend)
		{
			outcometitle settext(game["strings"]["round_draw"]);
		}
		else
		{
			outcometitle settext(game["strings"]["draw"]);
		}
		outcometitle.color = (1, 1, 1);
		winner = "allies";
	}
	else
	{
		if(winner == "overtime")
		{
			outcometitle settext(game["strings"]["overtime"]);
			outcometitle.color = (1, 1, 1);
		}
		else
		{
			if(isdefined(self.pers["team"]) && winner == team)
			{
				if(isroundend)
				{
					outcometitle settext(game["strings"]["round_win"]);
				}
				else
				{
					outcometitle settext(game["strings"]["victory"]);
				}
				outcometitle.color = (0.42, 0.68, 0.46);
			}
			else
			{
				if(isroundend)
				{
					outcometitle settext(game["strings"]["round_loss"]);
				}
				else
				{
					outcometitle settext(game["strings"]["defeat"]);
				}
				outcometitle.color = (0.73, 0.29, 0.19);
			}
		}
	}
	if(!isdefined(level.dontshowendreason) || !level.dontshowendreason)
	{
		outcometext settext(endreasontext);
	}
	outcometitle setpulsefx(100, duration, 1000);
	outcometext setpulsefx(100, duration, 1000);
	teamicons = [];
	teamicons[team] = hud::createicon(game["icons"][team], iconsize, iconsize);
	teamicons[team] hud::setparent(outcometext);
	teamicons[team] hud::setpoint("TOP", "BOTTOM", -60, spacing);
	teamicons[team].hidewheninmenu = 0;
	teamicons[team].archived = 0;
	teamicons[team].alpha = 0;
	teamicons[team] fadeovertime(0.5);
	teamicons[team].alpha = 1;
	teamicons[team].immunetodemogamehudsettings = 1;
	teamicons[team].immunetodemofreecamera = 1;
	foreach(enemyteam in level.teams)
	{
		if(team == enemyteam)
		{
			continue;
		}
		teamicons[enemyteam] = hud::createicon(game["icons"][enemyteam], iconsize, iconsize);
		teamicons[enemyteam] hud::setparent(outcometext);
		teamicons[enemyteam] hud::setpoint("TOP", "BOTTOM", 60, spacing);
		teamicons[enemyteam].hidewheninmenu = 0;
		teamicons[enemyteam].archived = 0;
		teamicons[enemyteam].alpha = 0;
		teamicons[enemyteam] fadeovertime(0.5);
		teamicons[enemyteam].alpha = 1;
		teamicons[enemyteam].immunetodemogamehudsettings = 1;
		teamicons[enemyteam].immunetodemofreecamera = 1;
	}
	teamscores = [];
	teamscores[team] = hud::createfontstring(font, titlesize);
	teamscores[team] hud::setparent(teamicons[team]);
	teamscores[team] hud::setpoint("TOP", "BOTTOM", 0, spacing);
	teamscores[team].glowalpha = 1;
	teamscores[team] setvalue(getteamscore(team));
	teamscores[team].hidewheninmenu = 0;
	teamscores[team].archived = 0;
	teamscores[team].immunetodemogamehudsettings = 1;
	teamscores[team].immunetodemofreecamera = 1;
	teamscores[team] setpulsefx(100, duration, 1000);
	foreach(enemyteam in level.teams)
	{
		if(team == enemyteam)
		{
			continue;
		}
		teamscores[enemyteam] = hud::createfontstring(font, titlesize);
		teamscores[enemyteam] hud::setparent(teamicons[enemyteam]);
		teamscores[enemyteam] hud::setpoint("TOP", "BOTTOM", 0, spacing);
		teamscores[enemyteam].glowalpha = 1;
		teamscores[enemyteam] setvalue(getteamscore(enemyteam));
		teamscores[enemyteam].hidewheninmenu = 0;
		teamscores[enemyteam].archived = 0;
		teamscores[enemyteam].immunetodemogamehudsettings = 1;
		teamscores[enemyteam].immunetodemofreecamera = 1;
		teamscores[enemyteam] setpulsefx(100, duration, 1000);
	}
	matchbonus = undefined;
	sidebetwinnings = undefined;
	if(!isroundend && !halftime && isdefined(self.wagerwinnings))
	{
		matchbonus = hud::createfontstring(font, 2);
		matchbonus hud::setparent(outcometext);
		matchbonus hud::setpoint("TOP", "BOTTOM", 0, (iconsize + (spacing * 3)) + teamscores[team].height);
		matchbonus.glowalpha = 1;
		matchbonus.hidewheninmenu = 0;
		matchbonus.archived = 0;
		matchbonus.immunetodemogamehudsettings = 1;
		matchbonus.immunetodemofreecamera = 1;
		matchbonus.label = game["strings"]["wager_winnings"];
		matchbonus setvalue(self.wagerwinnings);
		if(isdefined(game["side_bets"]) && game["side_bets"])
		{
			sidebetwinnings = hud::createfontstring(font, 2);
			sidebetwinnings hud::setparent(matchbonus);
			sidebetwinnings hud::setpoint("TOP", "BOTTOM", 0, spacing);
			sidebetwinnings.glowalpha = 1;
			sidebetwinnings.hidewheninmenu = 0;
			sidebetwinnings.archived = 0;
			sidebetwinnings.immunetodemogamehudsettings = 1;
			sidebetwinnings.immunetodemofreecamera = 1;
			sidebetwinnings.label = game["strings"]["wager_sidebet_winnings"];
			sidebetwinnings setvalue(self.pers["wager_sideBetWinnings"]);
		}
	}
	self thread resetoutcomenotify(teamicons, teamscores, outcometitle, outcometext, matchbonus, sidebetwinnings);
}

/*
	Name: resetoutcomenotify
	Namespace: hud_message
	Checksum: 0xA9AE7E12
	Offset: 0x33C0
	Size: 0x242
	Parameters: 10
	Flags: Linked
*/
function resetoutcomenotify(hudelemlist1, hudelemlist2, hudelem3, hudelem4, hudelem5, hudelem6, hudelem7, hudelem8, hudelem9, hudelem10)
{
	self endon(#"disconnect");
	self waittill(#"reset_outcome");
	destroyhudelem(hudelem3);
	destroyhudelem(hudelem4);
	destroyhudelem(hudelem5);
	destroyhudelem(hudelem6);
	destroyhudelem(hudelem7);
	destroyhudelem(hudelem8);
	destroyhudelem(hudelem9);
	destroyhudelem(hudelem10);
	if(isdefined(hudelemlist1))
	{
		foreach(elem in hudelemlist1)
		{
			destroyhudelem(elem);
		}
	}
	if(isdefined(hudelemlist2))
	{
		foreach(elem in hudelemlist2)
		{
			destroyhudelem(elem);
		}
	}
}

/*
	Name: resetwageroutcomenotify
	Namespace: hud_message
	Checksum: 0x6AE9DA15
	Offset: 0x3610
	Size: 0x12C
	Parameters: 4
	Flags: Linked
*/
function resetwageroutcomenotify(playernamehudelems, playercphudelems, outcometitle, outcometext)
{
	self endon(#"disconnect");
	self waittill(#"reset_outcome");
	for(i = playernamehudelems.size - 1; i >= 0; i--)
	{
		if(isdefined(playernamehudelems[i]))
		{
			playernamehudelems[i] destroy();
		}
	}
	for(i = playercphudelems.size - 1; i >= 0; i--)
	{
		if(isdefined(playercphudelems[i]))
		{
			playercphudelems[i] destroy();
		}
	}
	if(isdefined(outcometext))
	{
		outcometext destroy();
	}
	if(isdefined(outcometitle))
	{
		outcometitle destroy();
	}
}

/*
	Name: updateoutcome
	Namespace: hud_message
	Checksum: 0xD83A1BD9
	Offset: 0x3748
	Size: 0x170
	Parameters: 3
	Flags: None
*/
function updateoutcome(firsttitle, secondtitle, thirdtitle)
{
	self endon(#"disconnect");
	self endon(#"reset_outcome");
	while(true)
	{
		self waittill(#"update_outcome");
		players = level.placement["all"];
		if(isdefined(firsttitle) && isdefined(players[0]))
		{
			firsttitle setplayernamestring(players[0]);
		}
		else if(isdefined(firsttitle))
		{
			firsttitle.alpha = 0;
		}
		if(isdefined(secondtitle) && isdefined(players[1]))
		{
			secondtitle setplayernamestring(players[1]);
		}
		else if(isdefined(secondtitle))
		{
			secondtitle.alpha = 0;
		}
		if(isdefined(thirdtitle) && isdefined(players[2]))
		{
			thirdtitle setplayernamestring(players[2]);
		}
		else if(isdefined(thirdtitle))
		{
			thirdtitle.alpha = 0;
		}
	}
}

/*
	Name: updatewageroutcome
	Namespace: hud_message
	Checksum: 0xC6A5AE9F
	Offset: 0x38C0
	Size: 0x146
	Parameters: 2
	Flags: Linked
*/
function updatewageroutcome(playernamehudelems, playercphudelems)
{
	self endon(#"disconnect");
	self endon(#"reset_outcome");
	while(true)
	{
		self waittill(#"update_outcome");
		players = level.placement["all"];
		for(i = 0; i < playernamehudelems.size; i++)
		{
			if(isdefined(playernamehudelems[i]) && isdefined(players[playernamehudelems[i].playernum]))
			{
				playernamehudelems[i] setplayernamestring(players[playernamehudelems[i].playernum]);
				continue;
			}
			if(isdefined(playernamehudelems[i]))
			{
				playernamehudelems[i].alpha = 0;
			}
			if(isdefined(playercphudelems[i]))
			{
				playercphudelems[i].alpha = 0;
			}
		}
	}
}

