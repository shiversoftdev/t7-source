// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_challenges;
#using scripts\mp\_scoreevents;
#using scripts\mp\_teamops;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_wager;
#using scripts\mp\killstreaks\_counteruav;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_killstreak_weapons;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\bb_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\challenges_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

#namespace globallogic_score;

/*
	Name: updatematchbonusscores
	Namespace: globallogic_score
	Checksum: 0x2301EE7E
	Offset: 0xC08
	Size: 0x884
	Parameters: 1
	Flags: Linked
*/
function updatematchbonusscores(winner)
{
	if(!game["timepassed"])
	{
		return;
	}
	if(!level.rankedmatch)
	{
		updatecustomgamewinner(winner);
		return;
	}
	if(level.teambased && isdefined(winner))
	{
		if(winner == "endregulation")
		{
			return;
		}
	}
	if(!level.timelimit || level.forcedend)
	{
		gamelength = globallogic_utils::gettimepassed() / 1000;
		gamelength = min(gamelength, 1200);
		if(level.gametype == "twar" && game["roundsplayed"] > 0)
		{
			gamelength = gamelength + (level.timelimit * 60);
		}
	}
	else
	{
		gamelength = level.timelimit * 60;
	}
	if(level.teambased)
	{
		winningteam = "tie";
		foreach(team in level.teams)
		{
			if(winner == team)
			{
				winningteam = team;
				break;
			}
		}
		if(winningteam != "tie")
		{
			winnerscale = 1;
			loserscale = 0.5;
		}
		else
		{
			winnerscale = 0.75;
			loserscale = 0.75;
		}
		players = level.players;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(player.timeplayed["total"] < 1 || player.pers["participation"] < 1)
			{
				player thread rank::endgameupdate();
				continue;
			}
			totaltimeplayed = player.timeplayed["total"];
			if(totaltimeplayed > gamelength)
			{
				totaltimeplayed = gamelength;
			}
			if(level.hostforcedend && player ishost())
			{
				continue;
			}
			if(player.pers["score"] < 0)
			{
				continue;
			}
			spm = player rank::getspm();
			if(winningteam == "tie")
			{
				playerscore = int((winnerscale * ((gamelength / 60) * spm)) * (totaltimeplayed / gamelength));
				player thread givematchbonus("tie", playerscore);
				player.matchbonus = playerscore;
			}
			else
			{
				if(isdefined(player.pers["team"]) && player.pers["team"] == winningteam)
				{
					playerscore = int((winnerscale * ((gamelength / 60) * spm)) * (totaltimeplayed / gamelength));
					player thread givematchbonus("win", playerscore);
					player.matchbonus = playerscore;
				}
				else if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator")
				{
					playerscore = int((loserscale * ((gamelength / 60) * spm)) * (totaltimeplayed / gamelength));
					player thread givematchbonus("loss", playerscore);
					player.matchbonus = playerscore;
				}
			}
			player.pers["totalMatchBonus"] = player.pers["totalMatchBonus"] + player.matchbonus;
		}
	}
	else
	{
		if(isdefined(winner))
		{
			winnerscale = 1;
			loserscale = 0.5;
		}
		else
		{
			winnerscale = 0.75;
			loserscale = 0.75;
		}
		players = level.players;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(player.timeplayed["total"] < 1 || player.pers["participation"] < 1)
			{
				player thread rank::endgameupdate();
				continue;
			}
			totaltimeplayed = player.timeplayed["total"];
			if(totaltimeplayed > gamelength)
			{
				totaltimeplayed = gamelength;
			}
			spm = player rank::getspm();
			iswinner = 0;
			for(pidx = 0; pidx < min(level.placement["all"][0].size, 3); pidx++)
			{
				if(level.placement["all"][pidx] != player)
				{
					continue;
				}
				iswinner = 1;
			}
			if(iswinner)
			{
				playerscore = int((winnerscale * ((gamelength / 60) * spm)) * (totaltimeplayed / gamelength));
				player thread givematchbonus("win", playerscore);
				player.matchbonus = playerscore;
			}
			else
			{
				playerscore = int((loserscale * ((gamelength / 60) * spm)) * (totaltimeplayed / gamelength));
				player thread givematchbonus("loss", playerscore);
				player.matchbonus = playerscore;
			}
			player.pers["totalMatchBonus"] = player.pers["totalMatchBonus"] + player.matchbonus;
		}
	}
}

/*
	Name: updatecustomgamewinner
	Namespace: globallogic_score
	Checksum: 0x35F6CCF8
	Offset: 0x1498
	Size: 0x24E
	Parameters: 1
	Flags: Linked
*/
function updatecustomgamewinner(winner)
{
	if(!level.mpcustommatch)
	{
		return;
	}
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(!isdefined(winner))
		{
			player.pers["victory"] = 0;
		}
		else
		{
			if(level.teambased)
			{
				if(player.team == winner)
				{
					player.pers["victory"] = 2;
				}
				else
				{
					if(winner == "tie")
					{
						player.pers["victory"] = 1;
					}
					else
					{
						player.pers["victory"] = 0;
					}
				}
			}
			else
			{
				iswinner = 0;
				for(pidx = 0; pidx < min(level.placement["all"].size, 3); pidx++)
				{
					if(level.placement["all"][pidx] != player)
					{
						continue;
					}
					iswinner = 1;
				}
				if(iswinner)
				{
					player.pers["victory"] = 2;
				}
				else
				{
					player.pers["victory"] = 0;
				}
			}
		}
		player.victory = player.pers["victory"];
		player.pers["sbtimeplayed"] = player.timeplayed["total"];
		player.sbtimeplayed = player.pers["sbtimeplayed"];
	}
}

/*
	Name: givematchbonus
	Namespace: globallogic_score
	Checksum: 0x591C7BF6
	Offset: 0x16F0
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function givematchbonus(scoretype, score)
{
	self endon(#"disconnect");
	level waittill(#"give_match_bonus");
	if(scoreevents::shouldaddrankxp(self))
	{
		self addrankxpvalue(scoretype, score);
	}
	self rank::endgameupdate();
}

/*
	Name: gethighestscoringplayer
	Namespace: globallogic_score
	Checksum: 0x79FD6EDE
	Offset: 0x1778
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function gethighestscoringplayer()
{
	players = level.players;
	winner = undefined;
	tie = 0;
	for(i = 0; i < players.size; i++)
	{
		if(!isdefined(players[i].pointstowin))
		{
			continue;
		}
		if(players[i].pointstowin < 1)
		{
			continue;
		}
		if(!isdefined(winner) || players[i].pointstowin > winner.pointstowin)
		{
			winner = players[i];
			tie = 0;
			continue;
		}
		if(players[i].pointstowin == winner.pointstowin)
		{
			tie = 1;
		}
	}
	if(tie || !isdefined(winner))
	{
		return undefined;
	}
	return winner;
}

/*
	Name: resetplayerscorechainandmomentum
	Namespace: globallogic_score
	Checksum: 0x6052B42E
	Offset: 0x18C0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function resetplayerscorechainandmomentum(player)
{
	player thread _setplayermomentum(self, 0);
	player thread resetscorechain();
}

/*
	Name: resetscorechain
	Namespace: globallogic_score
	Checksum: 0x505C0E23
	Offset: 0x1908
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function resetscorechain()
{
	self notify(#"reset_score_chain");
	self.scorechain = 0;
	self.rankupdatetotal = 0;
}

/*
	Name: scorechaintimer
	Namespace: globallogic_score
	Checksum: 0xACD38BBB
	Offset: 0x1938
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function scorechaintimer()
{
	self notify(#"score_chain_timer");
	self endon(#"reset_score_chain");
	self endon(#"score_chain_timer");
	self endon(#"death");
	self endon(#"disconnect");
	wait(20);
	self thread resetscorechain();
}

/*
	Name: roundtonearestfive
	Namespace: globallogic_score
	Checksum: 0xFAF43337
	Offset: 0x19A0
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function roundtonearestfive(score)
{
	rounding = score % 5;
	if(rounding <= 2)
	{
		return score - rounding;
	}
	return score + (5 - rounding);
}

/*
	Name: giveplayermomentumnotification
	Namespace: globallogic_score
	Checksum: 0x68BA9A7F
	Offset: 0x1A00
	Size: 0x17C
	Parameters: 6
	Flags: Linked
*/
function giveplayermomentumnotification(score, label, descvalue, countstowardrampage, weapon, combatefficiencybonus = 0)
{
	score = score + combatefficiencybonus;
	if(score != 0)
	{
		self luinotifyevent(&"score_event", 3, label, score, combatefficiencybonus);
		self luinotifyeventtospectators(&"score_event", 3, label, score, combatefficiencybonus);
	}
	score = score;
	if(score > 0 && self hasperk("specialty_earnmoremomentum"))
	{
		score = roundtonearestfive(int((score * getdvarfloat("perk_killstreakMomentumMultiplier")) + 0.5));
	}
	if(isalive(self))
	{
		_setplayermomentum(self, self.pers["momentum"] + score);
	}
}

/*
	Name: resetplayermomentumonspawn
	Namespace: globallogic_score
	Checksum: 0xCC1C2582
	Offset: 0x1B88
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function resetplayermomentumonspawn()
{
	if(isdefined(level.usingscorestreaks) && level.usingscorestreaks)
	{
		_setplayermomentum(self, 0);
		self thread resetscorechain();
	}
}

/*
	Name: giveplayermomentum
	Namespace: globallogic_score
	Checksum: 0x5BA29951
	Offset: 0x1BE0
	Size: 0x254
	Parameters: 5
	Flags: Linked
*/
function giveplayermomentum(event, player, victim, descvalue, weapon)
{
	if(isdefined(level.disablemomentum) && level.disablemomentum == 1)
	{
		return;
	}
	score = rank::getscoreinfovalue(event);
	/#
		assert(isdefined(score));
	#/
	label = rank::getscoreinfolabel(event);
	countstowardrampage = rank::doesscoreinfocounttowardrampage(event);
	combatefficiencyevent = rank::getcombatefficiencyevent(event);
	if(isdefined(combatefficiencyevent) && player ability_util::gadget_combat_efficiency_enabled())
	{
		combatefficiencyscore = rank::getscoreinfovalue(combatefficiencyevent);
		/#
			assert(isdefined(combatefficiencyscore));
		#/
		player ability_util::gadget_combat_efficiency_power_drain(combatefficiencyscore);
	}
	if(event == "death")
	{
		_setplayermomentum(victim, victim.pers["momentum"] + score);
	}
	if(score == 0)
	{
		return;
	}
	if(level.gameended)
	{
		return;
	}
	if(!isdefined(label))
	{
		/#
			errormsg(event + "");
		#/
		player giveplayermomentumnotification(score, &"SCORE_BLANK", descvalue, countstowardrampage, weapon, combatefficiencyscore);
		return;
	}
	player giveplayermomentumnotification(score, label, descvalue, countstowardrampage, weapon, combatefficiencyscore);
}

/*
	Name: giveplayerscore
	Namespace: globallogic_score
	Checksum: 0x564C7B6A
	Offset: 0x1E40
	Size: 0x4F0
	Parameters: 5
	Flags: Linked
*/
function giveplayerscore(event, player, victim, descvalue, weapon)
{
	scorediff = 0;
	momentum = player.pers["momentum"];
	giveplayermomentum(event, player, victim, descvalue, weapon);
	newmomentum = player.pers["momentum"];
	if(level.overrideplayerscore)
	{
		return 0;
	}
	pixbeginevent("level.onPlayerScore");
	score = player.pers["score"];
	[[level.onplayerscore]](event, player, victim);
	newscore = player.pers["score"];
	pixendevent();
	isusingheropower = 0;
	if(player ability_player::is_using_any_gadget())
	{
		isusingheropower = 1;
	}
	bbprint("mpplayerscore", "spawnid %d gametime %d type %s player %s delta %d deltamomentum %d team %s isusingheropower %d", getplayerspawnid(player), gettime(), event, player.name, newscore - score, newmomentum - momentum, player.team, isusingheropower);
	player bb::add_to_stat("score", newscore - score);
	if(score == newscore)
	{
		return 0;
	}
	pixbeginevent("givePlayerScore");
	recordplayerstats(player, "score", newscore);
	scorediff = newscore - score;
	challengesenabled = !level.disablechallenges;
	player addplayerstatwithgametype("score", scorediff);
	if(challengesenabled)
	{
		player addplayerstat("CAREER_SCORE", scorediff);
	}
	if(level.hardcoremode)
	{
		player addplayerstat("SCORE_HC", scorediff);
		if(challengesenabled)
		{
			player addplayerstat("CAREER_SCORE_HC", scorediff);
		}
	}
	if(level.multiteam)
	{
		player addplayerstat("SCORE_MULTITEAM", scorediff);
		if(challengesenabled)
		{
			player addplayerstat("CAREER_SCORE_MULTITEAM", scorediff);
		}
	}
	if(!level.disablestattracking && isdefined(player.pers["lastHighestScore"]) && newscore > player.pers["lastHighestScore"])
	{
		player setdstat("HighestStats", "highest_score", newscore);
	}
	player persistence::add_recent_stat(0, 0, "score", scorediff);
	player util::player_contract_event("score", scorediff);
	if(isdefined(weapon) && killstreaks::is_killstreak_weapon(weapon))
	{
		killstreak = killstreaks::get_from_weapon(weapon);
		killstreakpurchased = 0;
		if(isdefined(killstreak) && isdefined(level.killstreaks[killstreak]))
		{
			killstreakpurchased = player util::is_item_purchased(level.killstreaks[killstreak].menuname);
		}
		player util::player_contract_event("killstreak_score", scorediff, killstreakpurchased);
	}
	pixendevent();
	return scorediff;
}

/*
	Name: default_onplayerscore
	Namespace: globallogic_score
	Checksum: 0x824153F4
	Offset: 0x2338
	Size: 0xB4
	Parameters: 3
	Flags: Linked
*/
function default_onplayerscore(event, player, victim)
{
	score = rank::getscoreinfovalue(event);
	/#
		assert(isdefined(score));
	#/
	if(level.wagermatch)
	{
		player thread rank::updaterankscorehud(score);
	}
	_setplayerscore(player, player.pers["score"] + score);
}

/*
	Name: _setplayerscore
	Namespace: globallogic_score
	Checksum: 0x8408DE43
	Offset: 0x23F8
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function _setplayerscore(player, score)
{
	if(score == player.pers["score"])
	{
		return;
	}
	if(!level.rankedmatch)
	{
		player thread rank::updaterankscorehud(score - player.pers["score"]);
	}
	player.pers["score"] = score;
	player.score = player.pers["score"];
	recordplayerstats(player, "score", player.pers["score"]);
	if(level.wagermatch)
	{
		player thread wager::player_scored();
	}
}

/*
	Name: _getplayerscore
	Namespace: globallogic_score
	Checksum: 0xC9E31E39
	Offset: 0x2500
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function _getplayerscore(player)
{
	return player.pers["score"];
}

/*
	Name: playtop3sounds
	Namespace: globallogic_score
	Checksum: 0xD6E5B5C1
	Offset: 0x2528
	Size: 0x176
	Parameters: 0
	Flags: Linked
*/
function playtop3sounds()
{
	wait(0.05);
	globallogic::updateplacement();
	for(i = 0; i < level.placement["all"].size; i++)
	{
		prevscoreplace = level.placement["all"][i].prevscoreplace;
		if(!isdefined(prevscoreplace))
		{
			prevscoreplace = 1;
		}
		currentscoreplace = i + 1;
		for(j = i - 1; j >= 0; j--)
		{
			if(level.placement["all"][i].score == level.placement["all"][j].score)
			{
				currentscoreplace--;
			}
		}
		wasinthemoney = prevscoreplace <= 3;
		isinthemoney = currentscoreplace <= 3;
		level.placement["all"][i].prevscoreplace = currentscoreplace;
	}
}

/*
	Name: setpointstowin
	Namespace: globallogic_score
	Checksum: 0xA47BC6D8
	Offset: 0x26A8
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function setpointstowin(points)
{
	self.pers["pointstowin"] = math::clamp(points, 0, 65000);
	self.pointstowin = self.pers["pointstowin"];
	self thread globallogic::checkscorelimit();
	self thread globallogic::checkroundscorelimit();
	self thread globallogic::checkplayerscorelimitsoon();
	level thread playtop3sounds();
}

/*
	Name: givepointstowin
	Namespace: globallogic_score
	Checksum: 0x70E1DAA8
	Offset: 0x2768
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function givepointstowin(points)
{
	self setpointstowin(self.pers["pointstowin"] + points);
}

/*
	Name: _setplayermomentum
	Namespace: globallogic_score
	Checksum: 0x44A66955
	Offset: 0x27B0
	Size: 0x2B0
	Parameters: 3
	Flags: Linked
*/
function _setplayermomentum(player, momentum, updatescore = 1)
{
	if(getdvarint("teamOpsEnabled") == 1)
	{
		return;
	}
	momentum = math::clamp(momentum, 0, 2000);
	oldmomentum = player.pers["momentum"];
	if(momentum == oldmomentum)
	{
		return;
	}
	if(updatescore)
	{
		player bb::add_to_stat("momentum", momentum - oldmomentum);
	}
	if(momentum > oldmomentum)
	{
		highestmomentumcost = 0;
		numkillstreaks = 0;
		if(isdefined(player.killstreak))
		{
			numkillstreaks = player.killstreak.size;
		}
		killstreaktypearray = [];
		for(currentkillstreak = 0; currentkillstreak < numkillstreaks; currentkillstreak++)
		{
			killstreaktype = killstreaks::get_by_menu_name(player.killstreak[currentkillstreak]);
			if(isdefined(killstreaktype))
			{
				momentumcost = level.killstreaks[killstreaktype].momentumcost;
				if(momentumcost > highestmomentumcost)
				{
					highestmomentumcost = momentumcost;
				}
				killstreaktypearray[killstreaktypearray.size] = killstreaktype;
			}
		}
		_giveplayerkillstreakinternal(player, momentum, oldmomentum, killstreaktypearray);
		while(highestmomentumcost > 0 && momentum >= highestmomentumcost)
		{
			oldmomentum = 0;
			momentum = momentum - highestmomentumcost;
			_giveplayerkillstreakinternal(player, momentum, oldmomentum, killstreaktypearray);
		}
	}
	player.pers["momentum"] = momentum;
	player.momentum = player.pers["momentum"];
}

/*
	Name: _giveplayerkillstreakinternal
	Namespace: globallogic_score
	Checksum: 0x3589FF57
	Offset: 0x2A68
	Size: 0x51A
	Parameters: 4
	Flags: Linked
*/
function _giveplayerkillstreakinternal(player, momentum, oldmomentum, killstreaktypearray)
{
	for(killstreaktypeindex = 0; killstreaktypeindex < killstreaktypearray.size; killstreaktypeindex++)
	{
		killstreaktype = killstreaktypearray[killstreaktypeindex];
		momentumcost = level.killstreaks[killstreaktype].momentumcost;
		if(momentumcost > oldmomentum && momentumcost <= momentum)
		{
			weapon = killstreaks::get_killstreak_weapon(killstreaktype);
			was_already_at_max_stacking = 0;
			if(isdefined(level.usingscorestreaks) && level.usingscorestreaks)
			{
				if(weapon.iscarriedkillstreak)
				{
					if(!isdefined(player.pers["held_killstreak_ammo_count"][weapon]))
					{
						player.pers["held_killstreak_ammo_count"][weapon] = 0;
					}
					if(!isdefined(player.pers["killstreak_quantity"][weapon]))
					{
						player.pers["killstreak_quantity"][weapon] = 0;
					}
					currentweapon = player getcurrentweapon();
					if(currentweapon == weapon)
					{
						if(player.pers["killstreak_quantity"][weapon] < level.scorestreaksmaxstacking)
						{
							player.pers["killstreak_quantity"][weapon]++;
						}
					}
					else
					{
						player.pers["held_killstreak_clip_count"][weapon] = weapon.clipsize;
						player.pers["held_killstreak_ammo_count"][weapon] = weapon.maxammo;
						player loadout::setweaponammooverall(weapon, player.pers["held_killstreak_ammo_count"][weapon]);
					}
				}
				else
				{
					old_killstreak_quantity = player killstreaks::get_killstreak_quantity(weapon);
					new_killstreak_quantity = player killstreaks::change_killstreak_quantity(weapon, 1);
					was_already_at_max_stacking = new_killstreak_quantity == old_killstreak_quantity;
					if(!was_already_at_max_stacking)
					{
						player challenges::earnedkillstreak();
						if(player ability_util::gadget_is_active(15))
						{
							scoreevents::processscoreevent("focus_earn_scorestreak", player);
							player scoreevents::specialistmedalachievement();
							player scoreevents::specialiststatabilityusage(4, 1);
							if(player.heroability.name == "gadget_combat_efficiency")
							{
								player addweaponstat(player.heroability, "scorestreaks_earned", 1);
								if(!isdefined(player.scorestreaksearnedperuse))
								{
									player.scorestreaksearnedperuse = 0;
								}
								player.scorestreaksearnedperuse++;
								if(player.scorestreaksearnedperuse >= 3)
								{
									scoreevents::processscoreevent("focus_earn_multiscorestreak", player);
									player.scorestreaksearnedperuse = 0;
								}
							}
						}
					}
				}
				if(!was_already_at_max_stacking)
				{
					player killstreaks::add_to_notification_queue(level.killstreaks[killstreaktype].menuname, new_killstreak_quantity, killstreaktype);
				}
				continue;
			}
			player killstreaks::add_to_notification_queue(level.killstreaks[killstreaktype].menuname, 0, killstreaktype);
			activeeventname = "reward_active";
			if(isdefined(weapon))
			{
				neweventname = weapon.name + "_active";
				if(scoreevents::isregisteredevent(neweventname))
				{
					activeeventname = neweventname;
				}
			}
		}
	}
}

/*
	Name: setplayermomentumdebug
	Namespace: globallogic_score
	Checksum: 0xD7F27887
	Offset: 0x2F90
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function setplayermomentumdebug()
{
	/#
		setdvar("", 0);
		while(true)
		{
			wait(1);
			momentumpercent = getdvarfloat("", 0);
			if(momentumpercent != 0)
			{
				player = util::gethostplayer();
				if(!isdefined(player))
				{
					return;
				}
				if(isdefined(player.killstreak))
				{
					_setplayermomentum(player, int(2000 * (momentumpercent / 100)));
				}
			}
		}
	#/
}

/*
	Name: giveteamscore
	Namespace: globallogic_score
	Checksum: 0xD2F48A3D
	Offset: 0x3088
	Size: 0x134
	Parameters: 4
	Flags: Linked
*/
function giveteamscore(event, team, player, victim)
{
	if(level.overrideteamscore)
	{
		return;
	}
	pixbeginevent("level.onTeamScore");
	teamscore = game["teamScores"][team];
	[[level.onteamscore]](event, team);
	pixendevent();
	newscore = game["teamScores"][team];
	bbprint("mpteamscores", "gametime %d event %s team %d diff %d score %d", gettime(), event, team, newscore - teamscore, newscore);
	if(teamscore == newscore)
	{
		return;
	}
	updateteamscores(team);
	thread globallogic::checkscorelimit();
	thread globallogic::checkroundscorelimit();
}

/*
	Name: giveteamscoreforobjective_delaypostprocessing
	Namespace: globallogic_score
	Checksum: 0x1389BE53
	Offset: 0x31C8
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function giveteamscoreforobjective_delaypostprocessing(team, score)
{
	teamscore = game["teamScores"][team];
	onteamscore_incrementscore(score, team);
	newscore = game["teamScores"][team];
	bbprint("mpteamobjscores", "gametime %d  team %d diff %d score %d", gettime(), team, newscore - teamscore, newscore);
	if(teamscore == newscore)
	{
		return;
	}
	updateteamscores(team);
}

/*
	Name: postprocessteamscores
	Namespace: globallogic_score
	Checksum: 0xE13A98A6
	Offset: 0x3298
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function postprocessteamscores(teams)
{
	foreach(team in teams)
	{
		onteamscore_postprocess(team);
	}
	thread globallogic::checkscorelimit();
	thread globallogic::checkroundscorelimit();
}

/*
	Name: giveteamscoreforobjective
	Namespace: globallogic_score
	Checksum: 0x35ABEF94
	Offset: 0x3358
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function giveteamscoreforobjective(team, score)
{
	if(!isdefined(level.teams[team]))
	{
		return;
	}
	teamscore = game["teamScores"][team];
	onteamscore(score, team);
	newscore = game["teamScores"][team];
	bbprint("mpteamobjscores", "gametime %d  team %d diff %d score %d", gettime(), team, newscore - teamscore, newscore);
	if(teamscore == newscore)
	{
		return;
	}
	updateteamscores(team);
	thread globallogic::checkscorelimit();
	thread globallogic::checkroundscorelimit();
	thread globallogic::checksuddendeathscorelimit(team);
}

/*
	Name: _setteamscore
	Namespace: globallogic_score
	Checksum: 0xD6B841EB
	Offset: 0x3478
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function _setteamscore(team, teamscore)
{
	if(teamscore == game["teamScores"][team])
	{
		return;
	}
	game["teamScores"][team] = math::clamp(teamscore, 0, 1000000);
	updateteamscores(team);
	thread globallogic::checkscorelimit();
	thread globallogic::checkroundscorelimit();
}

/*
	Name: resetteamscores
	Namespace: globallogic_score
	Checksum: 0x19206D6E
	Offset: 0x3520
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function resetteamscores()
{
	if(level.scoreroundwinbased || util::isfirstround())
	{
		foreach(team in level.teams)
		{
			game["teamScores"][team] = 0;
		}
	}
	updateallteamscores();
}

/*
	Name: resetallscores
	Namespace: globallogic_score
	Checksum: 0x1707AB2C
	Offset: 0x35E8
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function resetallscores()
{
	resetteamscores();
	resetplayerscores();
	teamops::stopteamops();
}

/*
	Name: resetplayerscores
	Namespace: globallogic_score
	Checksum: 0x850AB37C
	Offset: 0x3628
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function resetplayerscores()
{
	players = level.players;
	winner = undefined;
	tie = 0;
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i].pers["score"]))
		{
			_setplayerscore(players[i], 0);
		}
	}
}

/*
	Name: updateteamscores
	Namespace: globallogic_score
	Checksum: 0xA5BEEDD4
	Offset: 0x36D8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function updateteamscores(team)
{
	setteamscore(team, game["teamScores"][team]);
	level thread globallogic::checkteamscorelimitsoon(team);
}

/*
	Name: updateallteamscores
	Namespace: globallogic_score
	Checksum: 0xA74BAD96
	Offset: 0x3730
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function updateallteamscores()
{
	foreach(team in level.teams)
	{
		updateteamscores(team);
	}
}

/*
	Name: _getteamscore
	Namespace: globallogic_score
	Checksum: 0x57FD85A9
	Offset: 0x37C8
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function _getteamscore(team)
{
	return game["teamScores"][team];
}

/*
	Name: gethighestteamscoreteam
	Namespace: globallogic_score
	Checksum: 0x20B3AFE0
	Offset: 0x37F0
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function gethighestteamscoreteam()
{
	score = 0;
	winning_teams = [];
	foreach(team in level.teams)
	{
		team_score = game["teamScores"][team];
		if(team_score > score)
		{
			score = team_score;
			winning_teams = [];
		}
		if(team_score == score)
		{
			winning_teams[team] = team;
		}
	}
	return winning_teams;
}

/*
	Name: areteamarraysequal
	Namespace: globallogic_score
	Checksum: 0xB480D158
	Offset: 0x38F0
	Size: 0xB0
	Parameters: 2
	Flags: Linked
*/
function areteamarraysequal(teamsa, teamsb)
{
	if(teamsa.size != teamsb.size)
	{
		return false;
	}
	foreach(team in teamsa)
	{
		if(!isdefined(teamsb[team]))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: onteamscore
	Namespace: globallogic_score
	Checksum: 0x3FFAC79E
	Offset: 0x39A8
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function onteamscore(score, team)
{
	onteamscore_incrementscore(score, team);
	onteamscore_postprocess(team);
}

/*
	Name: onteamscore_incrementscore
	Namespace: globallogic_score
	Checksum: 0xAFA0A7F0
	Offset: 0x39F8
	Size: 0x116
	Parameters: 2
	Flags: Linked
*/
function onteamscore_incrementscore(score, team)
{
	game["teamScores"][team] = game["teamScores"][team] + score;
	if(game["teamScores"][team] < 0)
	{
		game["teamScores"][team] = 0;
	}
	if(level.clampscorelimit)
	{
		if(level.scorelimit && game["teamScores"][team] > level.scorelimit)
		{
			game["teamScores"][team] = level.scorelimit;
		}
		if(level.roundscorelimit && game["teamScores"][team] > util::get_current_round_score_limit())
		{
			game["teamScores"][team] = util::get_current_round_score_limit();
		}
	}
}

/*
	Name: onteamscore_postprocess
	Namespace: globallogic_score
	Checksum: 0x803D4C97
	Offset: 0x3B18
	Size: 0x250
	Parameters: 1
	Flags: Linked
*/
function onteamscore_postprocess(team)
{
	if(level.splitscreen)
	{
		return;
	}
	if(level.scorelimit == 1)
	{
		return;
	}
	iswinning = gethighestteamscoreteam();
	if(iswinning.size == 0)
	{
		return;
	}
	if((gettime() - level.laststatustime) < 5000)
	{
		return;
	}
	if(areteamarraysequal(iswinning, level.waswinning))
	{
		return;
	}
	if(iswinning.size == 1)
	{
		level.laststatustime = gettime();
		foreach(team in iswinning)
		{
			if(isdefined(level.waswinning[team]))
			{
				if(level.waswinning.size == 1)
				{
					continue;
				}
			}
			globallogic_audio::leader_dialog("lead_taken", team, undefined, "status");
		}
	}
	else
	{
		return;
	}
	if(level.waswinning.size == 1)
	{
		foreach(team in level.waswinning)
		{
			if(isdefined(iswinning[team]))
			{
				if(iswinning.size == 1)
				{
					continue;
				}
				if(level.waswinning.size > 1)
				{
					continue;
				}
			}
			globallogic_audio::leader_dialog("lead_lost", team, undefined, "status");
		}
	}
	level.waswinning = iswinning;
}

/*
	Name: default_onteamscore
	Namespace: globallogic_score
	Checksum: 0x564A69
	Offset: 0x3D70
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function default_onteamscore(event, team)
{
	score = rank::getscoreinfovalue(event);
	/#
		assert(isdefined(score));
	#/
	onteamscore(score, team);
}

/*
	Name: initpersstat
	Namespace: globallogic_score
	Checksum: 0x5AD7FBFD
	Offset: 0x3DE8
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function initpersstat(dataname, record_stats)
{
	if(!isdefined(self.pers[dataname]))
	{
		self.pers[dataname] = 0;
	}
	if(!isdefined(record_stats) || record_stats == 1)
	{
		recordplayerstats(self, dataname, int(self.pers[dataname]));
	}
}

/*
	Name: getpersstat
	Namespace: globallogic_score
	Checksum: 0x19E1760C
	Offset: 0x3E80
	Size: 0x18
	Parameters: 1
	Flags: Linked
*/
function getpersstat(dataname)
{
	return self.pers[dataname];
}

/*
	Name: incpersstat
	Namespace: globallogic_score
	Checksum: 0xE20732FB
	Offset: 0x3EA0
	Size: 0xEC
	Parameters: 4
	Flags: Linked
*/
function incpersstat(dataname, increment, record_stats, includegametype)
{
	pixbeginevent("incPersStat");
	self.pers[dataname] = self.pers[dataname] + increment;
	if(isdefined(includegametype) && includegametype)
	{
		self addplayerstatwithgametype(dataname, increment);
	}
	else
	{
		self addplayerstat(dataname, increment);
	}
	if(!isdefined(record_stats) || record_stats == 1)
	{
		self thread threadedrecordplayerstats(dataname);
	}
	pixendevent();
}

/*
	Name: threadedrecordplayerstats
	Namespace: globallogic_score
	Checksum: 0x8E55F1DE
	Offset: 0x3F98
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function threadedrecordplayerstats(dataname)
{
	self endon(#"disconnect");
	waittillframeend();
	recordplayerstats(self, dataname, self.pers[dataname]);
}

/*
	Name: updatewinstats
	Namespace: globallogic_score
	Checksum: 0x59A623FC
	Offset: 0x3FE0
	Size: 0x2D4
	Parameters: 1
	Flags: Linked
*/
function updatewinstats(winner)
{
	winner addplayerstatwithgametype("losses", -1);
	winner addplayerstatwithgametype("wins", 1);
	if(level.hardcoremode)
	{
		winner addplayerstat("wins_HC", 1);
	}
	if(level.multiteam)
	{
		winner addplayerstat("wins_MULTITEAM", 1);
	}
	winner updatestatratio("wlratio", "wins", "losses");
	restorewinstreaks(winner);
	winner addplayerstatwithgametype("cur_win_streak", 1);
	winner notify(#"win");
	winner.lootxpmultiplier = 1;
	cur_gamemode_win_streak = winner persistence::stat_get_with_gametype("cur_win_streak");
	gamemode_win_streak = winner persistence::stat_get_with_gametype("win_streak");
	cur_win_streak = winner getdstat("playerstatslist", "cur_win_streak", "StatValue");
	if(!level.disablestattracking && cur_win_streak > winner getdstat("HighestStats", "win_streak"))
	{
		winner setdstat("HighestStats", "win_streak", cur_win_streak);
	}
	if(cur_gamemode_win_streak > gamemode_win_streak)
	{
		winner persistence::stat_set_with_gametype("win_streak", cur_gamemode_win_streak);
	}
	if(bot::is_bot_ranked_match())
	{
		combattrainingwins = winner getdstat("combatTrainingWins");
		winner setdstat("combatTrainingWins", combattrainingwins + 1);
	}
	updateweaponcontractwin(winner);
	updatecontractwin(winner);
}

/*
	Name: canupdateweaponcontractstats
	Namespace: globallogic_score
	Checksum: 0x34ECDA24
	Offset: 0x42C0
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function canupdateweaponcontractstats(player)
{
	if(getdvarint("enable_weapon_contract", 0) == 0)
	{
		return false;
	}
	if(!level.rankedmatch && !level.arenamatch)
	{
		return false;
	}
	if(player getdstat("contracts", 3, "index") != 0)
	{
		return false;
	}
	return true;
}

/*
	Name: updateweaponcontractstart
	Namespace: globallogic_score
	Checksum: 0xE11D7E31
	Offset: 0x4350
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function updateweaponcontractstart(player)
{
	if(!canupdateweaponcontractstats(player))
	{
		return;
	}
	if(player getdstat("weaponContractData", "startTimestamp") == 0)
	{
		player setdstat("weaponContractData", "startTimestamp", getutc());
	}
}

/*
	Name: updateweaponcontractwin
	Namespace: globallogic_score
	Checksum: 0x391DF0EC
	Offset: 0x43E0
	Size: 0x14C
	Parameters: 1
	Flags: Linked
*/
function updateweaponcontractwin(winner)
{
	if(!canupdateweaponcontractstats(winner))
	{
		return;
	}
	matcheswon = winner getdstat("weaponContractData", "currentValue") + 1;
	winner setdstat("weaponContractData", "currentValue", matcheswon);
	if((isdefined(winner getdstat("weaponContractData", "completeTimestamp")) ? winner getdstat("weaponContractData", "completeTimestamp") : 0) == 0)
	{
		targetvalue = getdvarint("weapon_contract_target_value", 100);
		if(matcheswon >= targetvalue)
		{
			winner setdstat("weaponContractData", "completeTimestamp", getutc());
		}
	}
}

/*
	Name: updateweaponcontractplayed
	Namespace: globallogic_score
	Checksum: 0x53EF8A3B
	Offset: 0x4538
	Size: 0x11A
	Parameters: 0
	Flags: Linked
*/
function updateweaponcontractplayed()
{
	foreach(player in level.players)
	{
		if(!isdefined(player))
		{
			continue;
		}
		if(!canupdateweaponcontractstats(player))
		{
			continue;
		}
		if(!isdefined(player.pers["team"]))
		{
			continue;
		}
		matchesplayed = player getdstat("weaponContractData", "matchesPlayed") + 1;
		player setdstat("weaponContractData", "matchesPlayed", matchesplayed);
	}
}

/*
	Name: updatecontractwin
	Namespace: globallogic_score
	Checksum: 0x2287E38
	Offset: 0x4660
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function updatecontractwin(winner)
{
	if(!isdefined(level.updatecontractwinevents))
	{
		return;
	}
	foreach(contractwinevent in level.updatecontractwinevents)
	{
		if(!isdefined(contractwinevent))
		{
			continue;
		}
		[[contractwinevent]](winner);
	}
}

/*
	Name: registercontractwinevent
	Namespace: globallogic_score
	Checksum: 0xF8286310
	Offset: 0x4718
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function registercontractwinevent(event)
{
	if(!isdefined(level.updatecontractwinevents))
	{
		level.updatecontractwinevents = [];
	}
	if(!isdefined(level.updatecontractwinevents))
	{
		level.updatecontractwinevents = [];
	}
	else if(!isarray(level.updatecontractwinevents))
	{
		level.updatecontractwinevents = array(level.updatecontractwinevents);
	}
	level.updatecontractwinevents[level.updatecontractwinevents.size] = event;
}

/*
	Name: updatelossstats
	Namespace: globallogic_score
	Checksum: 0xF08648E5
	Offset: 0x47B8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function updatelossstats(loser)
{
	loser addplayerstatwithgametype("losses", 1);
	loser updatestatratio("wlratio", "wins", "losses");
	loser notify(#"loss");
}

/*
	Name: updatelosslatejoinstats
	Namespace: globallogic_score
	Checksum: 0xE7A0B2DB
	Offset: 0x4830
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function updatelosslatejoinstats(loser)
{
	loser addplayerstatwithgametype("losses", -1);
	loser addplayerstatwithgametype("losses_late_join", 1);
	loser updatestatratio("wlratio", "wins", "losses");
}

/*
	Name: updatetiestats
	Namespace: globallogic_score
	Checksum: 0x993D6A49
	Offset: 0x48B8
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function updatetiestats(loser)
{
	loser addplayerstatwithgametype("losses", -1);
	loser addplayerstatwithgametype("ties", 1);
	loser updatestatratio("wlratio", "wins", "losses");
	if(!level.disablestattracking)
	{
		loser setdstat("playerstatslist", "cur_win_streak", "StatValue", 0);
	}
	loser notify(#"tie");
}

/*
	Name: updatewinlossstats
	Namespace: globallogic_score
	Checksum: 0xAF1C0937
	Offset: 0x4988
	Size: 0x4B6
	Parameters: 1
	Flags: Linked
*/
function updatewinlossstats(winner)
{
	if(!util::waslastround() && !level.hostforcedend)
	{
		return;
	}
	players = level.players;
	updateweaponcontractplayed();
	if(!isdefined(winner) || (isdefined(winner) && !isplayer(winner) && winner == "tie"))
	{
		for(i = 0; i < players.size; i++)
		{
			if(!isdefined(players[i].pers["team"]))
			{
				continue;
			}
			if(level.hostforcedend && players[i] ishost())
			{
				continue;
			}
			updatetiestats(players[i]);
		}
	}
	else
	{
		if(isplayer(winner))
		{
			if(level.hostforcedend && winner ishost())
			{
				return;
			}
			updatewinstats(winner);
			if(!level.teambased)
			{
				placement = level.placement["all"];
				topthreeplayers = min(3, placement.size);
				for(index = 1; index < topthreeplayers; index++)
				{
					nexttopplayer = placement[index];
					updatewinstats(nexttopplayer);
				}
				for(i = 0; i < players.size; i++)
				{
					if(winner == players[i])
					{
						continue;
					}
					for(index = 1; index < topthreeplayers; index++)
					{
						if(players[i] == placement[index])
						{
							break;
						}
					}
					if(index < topthreeplayers)
					{
						continue;
					}
					if(level.rankedmatch && !level.leaguematch && players[i].pers["lateJoin"] === 1)
					{
						updatelosslatejoinstats(players[i]);
					}
				}
			}
		}
		else
		{
			for(i = 0; i < players.size; i++)
			{
				if(!isdefined(players[i].pers["team"]))
				{
					continue;
				}
				if(level.hostforcedend && players[i] ishost())
				{
					continue;
				}
				if(winner == "tie")
				{
					updatetiestats(players[i]);
					continue;
				}
				if(players[i].pers["team"] == winner)
				{
					updatewinstats(players[i]);
					continue;
				}
				if(level.rankedmatch && !level.leaguematch && players[i].pers["lateJoin"] === 1)
				{
					updatelosslatejoinstats(players[i]);
				}
				if(!level.disablestattracking)
				{
					players[i] setdstat("playerstatslist", "cur_win_streak", "StatValue", 0);
				}
			}
		}
	}
}

/*
	Name: backupandclearwinstreaks
	Namespace: globallogic_score
	Checksum: 0xC06F6714
	Offset: 0x4E48
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function backupandclearwinstreaks()
{
	if(isdefined(level.freerun) && level.freerun)
	{
		return;
	}
	self.pers["winStreak"] = self getdstat("playerstatslist", "cur_win_streak", "StatValue");
	if(!level.disablestattracking)
	{
		self setdstat("playerstatslist", "cur_win_streak", "StatValue", 0);
	}
	self.pers["winStreakForGametype"] = persistence::stat_get_with_gametype("cur_win_streak");
	self persistence::stat_set_with_gametype("cur_win_streak", 0);
}

/*
	Name: restorewinstreaks
	Namespace: globallogic_score
	Checksum: 0xDA2D09CC
	Offset: 0x4F38
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function restorewinstreaks(winner)
{
	if(!level.disablestattracking)
	{
		winner setdstat("playerstatslist", "cur_win_streak", "StatValue", winner.pers["winStreak"]);
	}
	winner persistence::stat_set_with_gametype("cur_win_streak", winner.pers["winStreakForGametype"]);
}

/*
	Name: inckillstreaktracker
	Namespace: globallogic_score
	Checksum: 0x63BBEACD
	Offset: 0x4FC8
	Size: 0x72
	Parameters: 1
	Flags: Linked
*/
function inckillstreaktracker(weapon)
{
	self endon(#"disconnect");
	waittillframeend();
	if(weapon.name == "artillery")
	{
		self.pers["artillery_kills"]++;
	}
	if(weapon.name == "dog_bite")
	{
		self.pers["dog_kills"]++;
	}
}

/*
	Name: trackattackerkill
	Namespace: globallogic_score
	Checksum: 0x6F5441EF
	Offset: 0x5048
	Size: 0x4BC
	Parameters: 6
	Flags: Linked
*/
function trackattackerkill(name, rank, xp, prestige, xuid, weapon)
{
	self endon(#"disconnect");
	attacker = self;
	waittillframeend();
	pixbeginevent("trackAttackerKill");
	if(!isdefined(attacker.pers["killed_players"][name]))
	{
		attacker.pers["killed_players"][name] = 0;
	}
	if(!isdefined(attacker.pers["killed_players_with_specialist"][name]))
	{
		attacker.pers["killed_players_with_specialist"][name] = 0;
	}
	if(!isdefined(attacker.killedplayerscurrent[name]))
	{
		attacker.killedplayerscurrent[name] = 0;
	}
	if(!isdefined(attacker.pers["nemesis_tracking"][name]))
	{
		attacker.pers["nemesis_tracking"][name] = 0;
	}
	attacker.pers["killed_players"][name]++;
	attacker.killedplayerscurrent[name]++;
	attacker.pers["nemesis_tracking"][name] = attacker.pers["nemesis_tracking"][name] + 1;
	if(attacker.pers["nemesis_name"] == name)
	{
		attacker challenges::killednemesis();
	}
	if(isdefined(weapon.isheroweapon) && weapon.isheroweapon == 1)
	{
		attacker.pers["killed_players_with_specialist"][name]++;
	}
	if(attacker.pers["nemesis_name"] == "" || attacker.pers["nemesis_tracking"][name] > attacker.pers["nemesis_tracking"][attacker.pers["nemesis_name"]])
	{
		attacker.pers["nemesis_name"] = name;
		attacker.pers["nemesis_rank"] = rank;
		attacker.pers["nemesis_rankIcon"] = prestige;
		attacker.pers["nemesis_xp"] = xp;
		attacker.pers["nemesis_xuid"] = xuid;
	}
	else if(isdefined(attacker.pers["nemesis_name"]) && attacker.pers["nemesis_name"] == name)
	{
		attacker.pers["nemesis_rank"] = rank;
		attacker.pers["nemesis_xp"] = xp;
	}
	if(!isdefined(attacker.lastkilledvictim) || !isdefined(attacker.lastkilledvictimcount))
	{
		attacker.lastkilledvictim = name;
		attacker.lastkilledvictimcount = 0;
	}
	if(attacker.lastkilledvictim == name)
	{
		attacker.lastkilledvictimcount++;
		if(attacker.lastkilledvictimcount >= 5)
		{
			attacker.lastkilledvictimcount = 0;
			attacker addplayerstat("streaker", 1);
		}
	}
	else
	{
		attacker.lastkilledvictim = name;
		attacker.lastkilledvictimcount = 1;
	}
	pixendevent();
}

/*
	Name: trackattackeedeath
	Namespace: globallogic_score
	Checksum: 0xFC629224
	Offset: 0x5510
	Size: 0x364
	Parameters: 5
	Flags: Linked
*/
function trackattackeedeath(attackername, rank, xp, prestige, xuid)
{
	self endon(#"disconnect");
	waittillframeend();
	pixbeginevent("trackAttackeeDeath");
	if(!isdefined(self.pers["killed_by"][attackername]))
	{
		self.pers["killed_by"][attackername] = 0;
	}
	self.pers["killed_by"][attackername]++;
	if(!isdefined(self.pers["nemesis_tracking"][attackername]))
	{
		self.pers["nemesis_tracking"][attackername] = 0;
	}
	self.pers["nemesis_tracking"][attackername] = self.pers["nemesis_tracking"][attackername] + 1.5;
	if(self.pers["nemesis_name"] == "" || self.pers["nemesis_tracking"][attackername] > self.pers["nemesis_tracking"][self.pers["nemesis_name"]])
	{
		self.pers["nemesis_name"] = attackername;
		self.pers["nemesis_rank"] = rank;
		self.pers["nemesis_rankIcon"] = prestige;
		self.pers["nemesis_xp"] = xp;
		self.pers["nemesis_xuid"] = xuid;
	}
	else if(isdefined(self.pers["nemesis_name"]) && self.pers["nemesis_name"] == attackername)
	{
		self.pers["nemesis_rank"] = rank;
		self.pers["nemesis_xp"] = xp;
	}
	if(self.pers["nemesis_name"] == attackername && self.pers["nemesis_tracking"][attackername] >= 2)
	{
		self setclientuivisibilityflag("killcam_nemesis", 1);
	}
	else
	{
		self setclientuivisibilityflag("killcam_nemesis", 0);
	}
	selfkillstowardsattacker = 0;
	if(isdefined(self.pers["killed_players"][attackername]))
	{
		selfkillstowardsattacker = self.pers["killed_players"][attackername];
	}
	self luinotifyevent(&"track_victim_death", 2, self.pers["killed_by"][attackername], selfkillstowardsattacker);
	pixendevent();
}

/*
	Name: default_iskillboosting
	Namespace: globallogic_score
	Checksum: 0xEEB93987
	Offset: 0x5880
	Size: 0x6
	Parameters: 0
	Flags: Linked
*/
function default_iskillboosting()
{
	return false;
}

/*
	Name: givekillstats
	Namespace: globallogic_score
	Checksum: 0xFDAECDE7
	Offset: 0x5890
	Size: 0x1CC
	Parameters: 3
	Flags: Linked
*/
function givekillstats(smeansofdeath, weapon, evictim)
{
	self endon(#"disconnect");
	self.kills = self.kills + 1;
	waittillframeend();
	if(level.rankedmatch && self [[level.iskillboosting]]())
	{
		/#
			self iprintlnbold("");
		#/
		return;
	}
	pixbeginevent("giveKillStats");
	self incpersstat("kills", 1, 1, 1);
	self.kills = self getpersstat("kills");
	self updatestatratio("kdratio", "kills", "deaths");
	attacker = self;
	if(smeansofdeath == "MOD_HEAD_SHOT" && !killstreaks::is_killstreak_weapon(weapon))
	{
		attacker thread incpersstat("headshots", 1, 1, 0);
		attacker.headshots = attacker.pers["headshots"];
		if(isdefined(evictim))
		{
			evictim recordkillmodifier("headshot");
		}
	}
	pixendevent();
}

/*
	Name: inctotalkills
	Namespace: globallogic_score
	Checksum: 0x252CF0C7
	Offset: 0x5A68
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function inctotalkills(team)
{
	if(level.teambased && isdefined(level.teams[team]))
	{
		game["totalKillsTeam"][team]++;
	}
	game["totalKills"]++;
}

/*
	Name: setinflictorstat
	Namespace: globallogic_score
	Checksum: 0x4CEFD3AA
	Offset: 0x5AC0
	Size: 0x1EC
	Parameters: 3
	Flags: Linked
*/
function setinflictorstat(einflictor, eattacker, weapon)
{
	if(!isdefined(eattacker))
	{
		return;
	}
	weaponpickedup = 0;
	if(isdefined(eattacker.pickedupweapons) && isdefined(eattacker.pickedupweapons[weapon]))
	{
		weaponpickedup = 1;
	}
	if(!isdefined(einflictor))
	{
		eattacker addweaponstat(weapon, "hits", 1, eattacker.class_num, weaponpickedup);
		return;
	}
	if(!isdefined(einflictor.playeraffectedarray))
	{
		einflictor.playeraffectedarray = [];
	}
	foundnewplayer = 1;
	for(i = 0; i < einflictor.playeraffectedarray.size; i++)
	{
		if(einflictor.playeraffectedarray[i] == self)
		{
			foundnewplayer = 0;
			break;
		}
	}
	if(foundnewplayer)
	{
		einflictor.playeraffectedarray[einflictor.playeraffectedarray.size] = self;
		if(weapon.rootweapon.name == "tabun_gas")
		{
			eattacker addweaponstat(weapon, "used", 1);
		}
		eattacker addweaponstat(weapon, "hits", 1, eattacker.class_num, weaponpickedup);
	}
}

/*
	Name: processshieldassist
	Namespace: globallogic_score
	Checksum: 0x4AB30F21
	Offset: 0x5CB8
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function processshieldassist(killedplayer)
{
	self endon(#"disconnect");
	killedplayer endon(#"disconnect");
	wait(0.05);
	util::waittillslowprocessallowed();
	if(!isdefined(level.teams[self.pers["team"]]))
	{
		return;
	}
	if(self.pers["team"] == killedplayer.pers["team"])
	{
		return;
	}
	if(!level.teambased)
	{
		return;
	}
	self incpersstat("assists", 1, 1, 1);
	self.assists = self getpersstat("assists");
	scoreevents::processscoreevent("shield_assist", self, killedplayer, "riotshield");
}

/*
	Name: processassist
	Namespace: globallogic_score
	Checksum: 0xA0959909
	Offset: 0x5DD0
	Size: 0x2C4
	Parameters: 3
	Flags: Linked
*/
function processassist(killedplayer, damagedone, weapon)
{
	self endon(#"disconnect");
	killedplayer endon(#"disconnect");
	wait(0.05);
	util::waittillslowprocessallowed();
	if(!isdefined(level.teams[self.pers["team"]]))
	{
		return;
	}
	if(self.pers["team"] == killedplayer.pers["team"])
	{
		return;
	}
	if(!level.teambased)
	{
		return;
	}
	assist_level = "assist";
	assist_level_value = int(ceil(damagedone / 25));
	if(assist_level_value < 1)
	{
		assist_level_value = 1;
	}
	else if(assist_level_value > 3)
	{
		assist_level_value = 3;
	}
	assist_level = (assist_level + "_") + (assist_level_value * 25);
	self incpersstat("assists", 1, 1, 1);
	self.assists = self getpersstat("assists");
	if(isdefined(weapon))
	{
		weaponpickedup = 0;
		if(isdefined(self.pickedupweapons) && isdefined(self.pickedupweapons[weapon]))
		{
			weaponpickedup = 1;
		}
		self addweaponstat(weapon, "assists", 1, self.class_num, weaponpickedup);
	}
	switch(weapon.name)
	{
		case "concussion_grenade":
		{
			assist_level = "assist_concussion";
			break;
		}
		case "flash_grenade":
		{
			assist_level = "assist_flash";
			break;
		}
		case "emp_grenade":
		{
			assist_level = "assist_emp";
			break;
		}
		case "proximity_grenade":
		case "proximity_grenade_aoe":
		{
			assist_level = "assist_proximity";
			break;
		}
	}
	self challenges::assisted();
	scoreevents::processscoreevent(assist_level, self, killedplayer, weapon);
}

/*
	Name: processkillstreakassists
	Namespace: globallogic_score
	Checksum: 0xD89DAA3C
	Offset: 0x60A0
	Size: 0x64A
	Parameters: 3
	Flags: Linked
*/
function processkillstreakassists(attacker, inflictor, weapon)
{
	if(!isdefined(attacker) || !isdefined(attacker.team) || self util::isenemyplayer(attacker) == 0)
	{
		return;
	}
	if(self == attacker || (attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn"))
	{
		return;
	}
	enemycuavactive = 0;
	if(attacker hasperk("specialty_immunecounteruav") == 0)
	{
		foreach(team in level.teams)
		{
			if(team == attacker.team)
			{
				continue;
			}
			if(counteruav::teamhasactivecounteruav(team))
			{
				enemycuavactive = 1;
			}
		}
	}
	foreach(player in level.players)
	{
		if(player.team != attacker.team)
		{
			continue;
		}
		if(player.team == "spectator")
		{
			continue;
		}
		if(player == attacker)
		{
			continue;
		}
		if(player.sessionstate != "playing")
		{
			continue;
		}
		/#
			assert(isdefined(level.activeplayercounteruavs[player.entnum]));
		#/
		/#
			assert(isdefined(level.activeplayeruavs[player.entnum]));
		#/
		/#
			assert(isdefined(level.activeplayersatellites[player.entnum]));
		#/
		is_killstreak_weapon = killstreaks::is_killstreak_weapon(weapon);
		if(level.activeplayercounteruavs[player.entnum] > 0 && !is_killstreak_weapon)
		{
			scoregiven = scoreevents::processscoreevent("counter_uav_assist", player);
			if(isdefined(scoregiven))
			{
				player challenges::earnedcuavassistscore(scoregiven);
				killstreakindex = level.killstreakindices["killstreak_counteruav"];
				killstreaks::killstreak_assist(player, self, killstreakindex);
				player process_killstreak_assist_score("counteruav", scoregiven);
			}
		}
		if(enemycuavactive == 0)
		{
			activeuav = level.activeplayeruavs[player.entnum];
			if(level.forceradar == 1)
			{
				activeuav--;
			}
			if(activeuav > 0 && !is_killstreak_weapon)
			{
				scoregiven = scoreevents::processscoreevent("uav_assist", player);
				if(isdefined(scoregiven))
				{
					player challenges::earneduavassistscore(scoregiven);
					killstreakindex = level.killstreakindices["killstreak_uav"];
					killstreaks::killstreak_assist(player, self, killstreakindex);
					player process_killstreak_assist_score("uav", scoregiven);
				}
			}
			if(level.activeplayersatellites[player.entnum] > 0 && !is_killstreak_weapon)
			{
				scoregiven = scoreevents::processscoreevent("satellite_assist", player);
				if(isdefined(scoregiven))
				{
					player challenges::earnedsatelliteassistscore(scoregiven);
					killstreakindex = level.killstreakindices["killstreak_satellite"];
					killstreaks::killstreak_assist(player, self, killstreakindex);
					player process_killstreak_assist_score("satellite", scoregiven);
				}
			}
		}
		if(player emp::hasactiveemp())
		{
			scoregiven = scoreevents::processscoreevent("emp_assist", player);
			if(isdefined(scoregiven))
			{
				player challenges::earnedempassistscore(scoregiven);
				killstreakindex = level.killstreakindices["killstreak_emp"];
				killstreaks::killstreak_assist(player, self, killstreakindex);
				player process_killstreak_assist_score("emp", scoregiven);
			}
		}
	}
}

/*
	Name: process_killstreak_assist_score
	Namespace: globallogic_score
	Checksum: 0x5E9DFE80
	Offset: 0x66F8
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function process_killstreak_assist_score(killstreak, scoregiven)
{
	player = self;
	killstreakpurchased = 0;
	if(isdefined(killstreak) && isdefined(level.killstreaks[killstreak]))
	{
		killstreakpurchased = player util::is_item_purchased(level.killstreaks[killstreak].menuname);
	}
	player util::player_contract_event("killstreak_score", scoregiven, killstreakpurchased);
}

/*
	Name: xpratethread
	Namespace: globallogic_score
	Checksum: 0xE45ED2D1
	Offset: 0x67A8
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function xpratethread()
{
	/#
		self endon(#"death");
		self endon(#"disconnect");
		level endon(#"game_ended");
		while(level.inprematchperiod)
		{
			wait(0.05);
		}
		for(;;)
		{
			wait(5);
			if(isdefined(level.teams[level.players[0].pers[""]]))
			{
				self rank::giverankxp("", int(min(getdvarint(""), 50)));
			}
		}
	#/
}

