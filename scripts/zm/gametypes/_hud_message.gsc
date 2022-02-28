// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\gametypes\_globallogic_audio;

#namespace hud_message;

/*
	Name: init
	Namespace: hud_message
	Checksum: 0x597C422B
	Offset: 0x428
	Size: 0x1A2
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
	game["strings"]["game_over"] = &"MP_GAME_OVER_CAPS";
	game["strings"]["halftime"] = &"MP_HALFTIME_CAPS";
	game["strings"]["overtime"] = &"MP_OVERTIME_CAPS";
	game["strings"]["roundend"] = &"MP_ROUNDEND_CAPS";
	game["strings"]["intermission"] = &"MP_INTERMISSION_CAPS";
	game["strings"]["side_switch"] = &"MP_SWITCHING_SIDES_CAPS";
	game["strings"]["match_bonus"] = &"MP_MATCH_BONUS_IS";
}

/*
	Name: teamoutcomenotify
	Namespace: hud_message
	Checksum: 0x802C7D5B
	Offset: 0x5D8
	Size: 0xE74
	Parameters: 3
	Flags: Linked
*/
function teamoutcomenotify(winner, isround, endreasontext)
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
	headerfont = "extrabig";
	font = "default";
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
		spacing = 25;
	}
	duration = 60000;
	outcometitle = hud::createfontstring(headerfont, titlesize);
	outcometitle hud::setpoint("TOP", undefined, 0, 30);
	outcometitle.glowalpha = 1;
	outcometitle.hidewheninmenu = 0;
	outcometitle.archived = 0;
	outcometext = hud::createfontstring(font, 2);
	outcometext hud::setparent(outcometitle);
	outcometext hud::setpoint("TOP", "BOTTOM", 0, 0);
	outcometext.glowalpha = 1;
	outcometext.hidewheninmenu = 0;
	outcometext.archived = 0;
	if(winner == "halftime")
	{
		outcometitle settext(game["strings"]["halftime"]);
		outcometitle.color = (1, 1, 1);
		winner = "allies";
	}
	else
	{
		if(winner == "intermission")
		{
			outcometitle settext(game["strings"]["intermission"]);
			outcometitle.color = (1, 1, 1);
			winner = "allies";
		}
		else
		{
			if(winner == "roundend")
			{
				outcometitle settext(game["strings"]["roundend"]);
				outcometitle.color = (1, 1, 1);
				winner = "allies";
			}
			else
			{
				if(winner == "overtime")
				{
					outcometitle settext(game["strings"]["overtime"]);
					outcometitle.color = (1, 1, 1);
					winner = "allies";
				}
				else
				{
					if(winner == "tie")
					{
						if(isround)
						{
							outcometitle settext(game["strings"]["round_draw"]);
						}
						else
						{
							outcometitle settext(game["strings"]["draw"]);
						}
						outcometitle.color = (0.29, 0.61, 0.7);
						winner = "allies";
					}
					else
					{
						if(isdefined(self.pers["team"]) && winner == team)
						{
							if(isround)
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
							if(isround)
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
			}
		}
	}
	outcometext settext(endreasontext);
	outcometitle setcod7decodefx(200, duration, 600);
	outcometext setpulsefx(100, duration, 1000);
	iconspacing = 100;
	currentx = (((level.teamcount - 1) * -1) * iconspacing) / 2;
	teamicons = [];
	teamicons[team] = hud::createicon(game["icons"][team], iconsize, iconsize);
	teamicons[team] hud::setparent(outcometext);
	teamicons[team] hud::setpoint("TOP", "BOTTOM", currentx, spacing);
	teamicons[team].hidewheninmenu = 0;
	teamicons[team].archived = 0;
	teamicons[team].alpha = 0;
	teamicons[team] fadeovertime(0.5);
	teamicons[team].alpha = 1;
	currentx = currentx + iconspacing;
	foreach(enemyteam in level.teams)
	{
		if(team == enemyteam)
		{
			continue;
		}
		teamicons[enemyteam] = hud::createicon(game["icons"][enemyteam], iconsize, iconsize);
		teamicons[enemyteam] hud::setparent(outcometext);
		teamicons[enemyteam] hud::setpoint("TOP", "BOTTOM", currentx, spacing);
		teamicons[enemyteam].hidewheninmenu = 0;
		teamicons[enemyteam].archived = 0;
		teamicons[enemyteam].alpha = 0;
		teamicons[enemyteam] fadeovertime(0.5);
		teamicons[enemyteam].alpha = 1;
		currentx = currentx + iconspacing;
	}
	teamscores = [];
	teamscores[team] = hud::createfontstring(font, titlesize);
	teamscores[team] hud::setparent(teamicons[team]);
	teamscores[team] hud::setpoint("TOP", "BOTTOM", 0, spacing);
	teamscores[team].glowalpha = 1;
	if(isround)
	{
		teamscores[team] setvalue(getteamscore(team));
	}
	else
	{
		teamscores[team] [[level.setmatchscorehudelemforteam]](team);
	}
	teamscores[team].hidewheninmenu = 0;
	teamscores[team].archived = 0;
	teamscores[team] setpulsefx(100, duration, 1000);
	foreach(enemyteam in level.teams)
	{
		if(team == enemyteam)
		{
			continue;
		}
		teamscores[enemyteam] = hud::createfontstring(headerfont, titlesize);
		teamscores[enemyteam] hud::setparent(teamicons[enemyteam]);
		teamscores[enemyteam] hud::setpoint("TOP", "BOTTOM", 0, spacing);
		teamscores[enemyteam].glowalpha = 1;
		if(isround)
		{
			teamscores[enemyteam] setvalue(getteamscore(enemyteam));
		}
		else
		{
			teamscores[enemyteam] [[level.setmatchscorehudelemforteam]](enemyteam);
		}
		teamscores[enemyteam].hidewheninmenu = 0;
		teamscores[enemyteam].archived = 0;
		teamscores[enemyteam] setpulsefx(100, duration, 1000);
	}
	font = "objective";
	matchbonus = undefined;
	if(isdefined(self.matchbonus))
	{
		matchbonus = hud::createfontstring(font, 2);
		matchbonus hud::setparent(outcometext);
		matchbonus hud::setpoint("TOP", "BOTTOM", 0, (iconsize + (spacing * 3)) + teamscores[team].height);
		matchbonus.glowalpha = 1;
		matchbonus.hidewheninmenu = 0;
		matchbonus.archived = 0;
		matchbonus.label = game["strings"]["match_bonus"];
		matchbonus setvalue(self.matchbonus);
	}
	self thread resetoutcomenotify(teamicons, teamscores, outcometitle, outcometext);
}

/*
	Name: teamoutcomenotifyzombie
	Namespace: hud_message
	Checksum: 0x14D3008F
	Offset: 0x1458
	Size: 0x29C
	Parameters: 3
	Flags: Linked
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
	if(self issplitscreen())
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
	outcometitle settext(endreasontext);
	outcometitle setpulsefx(100, 60000, 1000);
	self thread resetoutcomenotify(undefined, undefined, outcometitle);
}

/*
	Name: outcomenotify
	Namespace: hud_message
	Checksum: 0xA1D32CCE
	Offset: 0x1700
	Size: 0x99C
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
	headerfont = "extrabig";
	font = "default";
	if(self issplitscreen())
	{
		titlesize = 2;
		winnersize = 1.5;
		othersize = 1.5;
		iconsize = 30;
		spacing = 10;
	}
	else
	{
		titlesize = 3;
		winnersize = 2;
		othersize = 1.5;
		iconsize = 30;
		spacing = 20;
	}
	duration = 60000;
	players = level.placement["all"];
	outcometitle = hud::createfontstring(headerfont, titlesize);
	outcometitle hud::setpoint("TOP", undefined, 0, spacing);
	if(!util::isoneround() && !isroundend)
	{
		outcometitle settext(game["strings"]["game_over"]);
	}
	else
	{
		if(isdefined(players[1]) && players[0].score == players[1].score && players[0].deaths == players[1].deaths && (self == players[0] || self == players[1]))
		{
			outcometitle settext(game["strings"]["tie"]);
		}
		else
		{
			if(isdefined(players[2]) && players[0].score == players[2].score && players[0].deaths == players[2].deaths && self == players[2])
			{
				outcometitle settext(game["strings"]["tie"]);
			}
			else
			{
				if(isdefined(players[0]) && self == players[0])
				{
					outcometitle settext(game["strings"]["victory"]);
					outcometitle.color = (0.42, 0.68, 0.46);
				}
				else
				{
					outcometitle settext(game["strings"]["defeat"]);
					outcometitle.color = (0.73, 0.29, 0.19);
				}
			}
		}
	}
	outcometitle.glowalpha = 1;
	outcometitle.hidewheninmenu = 0;
	outcometitle.archived = 0;
	outcometitle setcod7decodefx(200, duration, 600);
	outcometext = hud::createfontstring(font, 2);
	outcometext hud::setparent(outcometitle);
	outcometext hud::setpoint("TOP", "BOTTOM", 0, 0);
	outcometext.glowalpha = 1;
	outcometext.hidewheninmenu = 0;
	outcometext.archived = 0;
	outcometext settext(endreasontext);
	firsttitle = hud::createfontstring(font, winnersize);
	firsttitle hud::setparent(outcometext);
	firsttitle hud::setpoint("TOP", "BOTTOM", 0, spacing);
	firsttitle.glowalpha = 1;
	firsttitle.hidewheninmenu = 0;
	firsttitle.archived = 0;
	if(isdefined(players[0]))
	{
		firsttitle.label = &"MP_FIRSTPLACE_NAME";
		firsttitle setplayernamestring(players[0]);
		firsttitle setcod7decodefx(175, duration, 600);
	}
	secondtitle = hud::createfontstring(font, othersize);
	secondtitle hud::setparent(firsttitle);
	secondtitle hud::setpoint("TOP", "BOTTOM", 0, spacing);
	secondtitle.glowalpha = 1;
	secondtitle.hidewheninmenu = 0;
	secondtitle.archived = 0;
	if(isdefined(players[1]))
	{
		secondtitle.label = &"MP_SECONDPLACE_NAME";
		secondtitle setplayernamestring(players[1]);
		secondtitle setcod7decodefx(175, duration, 600);
	}
	thirdtitle = hud::createfontstring(font, othersize);
	thirdtitle hud::setparent(secondtitle);
	thirdtitle hud::setpoint("TOP", "BOTTOM", 0, spacing);
	thirdtitle hud::setparent(secondtitle);
	thirdtitle.glowalpha = 1;
	thirdtitle.hidewheninmenu = 0;
	thirdtitle.archived = 0;
	if(isdefined(players[2]))
	{
		thirdtitle.label = &"MP_THIRDPLACE_NAME";
		thirdtitle setplayernamestring(players[2]);
		thirdtitle setcod7decodefx(175, duration, 600);
	}
	matchbonus = hud::createfontstring(font, 2);
	matchbonus hud::setparent(thirdtitle);
	matchbonus hud::setpoint("TOP", "BOTTOM", 0, spacing);
	matchbonus.glowalpha = 1;
	matchbonus.hidewheninmenu = 0;
	matchbonus.archived = 0;
	if(isdefined(self.matchbonus))
	{
		matchbonus.label = game["strings"]["match_bonus"];
		matchbonus setvalue(self.matchbonus);
	}
	self thread updateoutcome(firsttitle, secondtitle, thirdtitle);
	self thread resetoutcomenotify(undefined, undefined, outcometitle, outcometext, firsttitle, secondtitle, thirdtitle, matchbonus);
}

/*
	Name: wageroutcomenotify
	Namespace: hud_message
	Checksum: 0xF9458B9F
	Offset: 0x20A8
	Size: 0xA0C
	Parameters: 2
	Flags: Linked
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
	outcometitle setcod7decodefx(200, duration, 600);
	outcometext = hud::createfontstring(font, 2);
	outcometext hud::setparent(outcometitle);
	outcometext hud::setpoint("TOP", "BOTTOM", 0, 0);
	outcometext.glowalpha = 1;
	outcometext.hidewheninmenu = 0;
	outcometext.archived = 0;
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
	Checksum: 0x48C57BC3
	Offset: 0x2AC0
	Size: 0xD6C
	Parameters: 3
	Flags: Linked
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
	outcometext = hud::createfontstring(font, 2);
	outcometext hud::setparent(outcometitle);
	outcometext hud::setpoint("TOP", "BOTTOM", 0, 0);
	outcometext.glowalpha = 1;
	outcometext.hidewheninmenu = 0;
	outcometext.archived = 0;
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
	}
	teamscores = [];
	teamscores[team] = hud::createfontstring(font, titlesize);
	teamscores[team] hud::setparent(teamicons[team]);
	teamscores[team] hud::setpoint("TOP", "BOTTOM", 0, spacing);
	teamscores[team].glowalpha = 1;
	teamscores[team] setvalue(getteamscore(team));
	teamscores[team].hidewheninmenu = 0;
	teamscores[team].archived = 0;
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
			sidebetwinnings.label = game["strings"]["wager_sidebet_winnings"];
			sidebetwinnings setvalue(self.pers["wager_sideBetWinnings"]);
		}
	}
	self thread resetoutcomenotify(teamicons, teamscores, outcometitle, outcometext, matchbonus, sidebetwinnings);
}

/*
	Name: resetoutcomenotify
	Namespace: hud_message
	Checksum: 0x6304B2C9
	Offset: 0x3838
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
	Checksum: 0xB7D5C738
	Offset: 0x3A88
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
	Checksum: 0xFCA790C3
	Offset: 0x3BC0
	Size: 0x170
	Parameters: 3
	Flags: Linked
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
	Checksum: 0xE596F585
	Offset: 0x3D38
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

