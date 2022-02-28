// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\drown;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace challenges;

/*
	Name: init_shared
	Namespace: challenges
	Checksum: 0x99EC1590
	Offset: 0x1140
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function init_shared()
{
}

/*
	Name: pickedupballisticknife
	Namespace: challenges
	Checksum: 0xDB13F45
	Offset: 0x1150
	Size: 0xC
	Parameters: 0
	Flags: None
*/
function pickedupballisticknife()
{
	self.retreivedblades++;
}

/*
	Name: trackassists
	Namespace: challenges
	Checksum: 0x1339CEAD
	Offset: 0x1168
	Size: 0x8A
	Parameters: 3
	Flags: Linked
*/
function trackassists(attacker, damage, isflare)
{
	if(!isdefined(self.flareattackerdamage))
	{
		self.flareattackerdamage = [];
	}
	if(isdefined(isflare) && isflare == 1)
	{
		self.flareattackerdamage[attacker.clientid] = 1;
	}
	else
	{
		self.flareattackerdamage[attacker.clientid] = 0;
	}
}

/*
	Name: destroyedequipment
	Namespace: challenges
	Checksum: 0x2669AC5B
	Offset: 0x1200
	Size: 0x18C
	Parameters: 1
	Flags: Linked
*/
function destroyedequipment(weapon)
{
	if(isdefined(weapon) && weapon.isemp)
	{
		if(self util::is_item_purchased("emp_grenade"))
		{
			self addplayerstat("destroy_equipment_with_emp_grenade", 1);
		}
		self addweaponstat(weapon, "combatRecordStat", 1);
		if(self util::has_hacker_perk_purchased_and_equipped())
		{
			self addplayerstat("destroy_equipment_with_emp_engineer", 1);
			self addplayerstat("destroy_equipment_engineer", 1);
		}
	}
	else if(self util::has_hacker_perk_purchased_and_equipped())
	{
		self addplayerstat("destroy_equipment_engineer", 1);
	}
	self addplayerstat("destroy_equipment", 1);
	if(isdefined(weapon) && weapon.isbulletweapon)
	{
		self addplayerstat("destroy_equipment_with_bullet", 1);
	}
	self hackedordestroyedequipment();
}

/*
	Name: destroyedtacticalinsert
	Namespace: challenges
	Checksum: 0x68E3B065
	Offset: 0x1398
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function destroyedtacticalinsert()
{
	if(!isdefined(self.pers["tacticalInsertsDestroyed"]))
	{
		self.pers["tacticalInsertsDestroyed"] = 0;
	}
	self.pers["tacticalInsertsDestroyed"]++;
	if(self.pers["tacticalInsertsDestroyed"] >= 5)
	{
		self.pers["tacticalInsertsDestroyed"] = 0;
		self addplayerstat("destroy_5_tactical_inserts", 1);
	}
}

/*
	Name: addflyswatterstat
	Namespace: challenges
	Checksum: 0x9160F807
	Offset: 0x1438
	Size: 0x196
	Parameters: 2
	Flags: None
*/
function addflyswatterstat(weapon, aircraft)
{
	if(!isdefined(self.pers["flyswattercount"]))
	{
		self.pers["flyswattercount"] = 0;
	}
	self addweaponstat(weapon, "destroyed_aircraft", 1);
	self.pers["flyswattercount"]++;
	if(self.pers["flyswattercount"] == 5)
	{
		self addweaponstat(weapon, "destroyed_5_aircraft", 1);
	}
	if(isdefined(aircraft) && isdefined(aircraft.birthtime))
	{
		if((gettime() - aircraft.birthtime) < 20000)
		{
			self addweaponstat(weapon, "destroyed_aircraft_under20s", 1);
		}
	}
	if(!isdefined(self.destroyedaircrafttime))
	{
		self.destroyedaircrafttime = [];
	}
	if(isdefined(self.destroyedaircrafttime[weapon]) && (gettime() - self.destroyedaircrafttime[weapon]) < 10000)
	{
		self addweaponstat(weapon, "destroyed_2aircraft_quickly", 1);
		self.destroyedaircrafttime[weapon] = undefined;
	}
	else
	{
		self.destroyedaircrafttime[weapon] = gettime();
	}
}

/*
	Name: destroynonairscorestreak_poststatslock
	Namespace: challenges
	Checksum: 0x130DAB7B
	Offset: 0x15D8
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function destroynonairscorestreak_poststatslock(weapon)
{
	self addweaponstat(weapon, "destroyed_aircraft", 1);
}

/*
	Name: canprocesschallenges
	Namespace: challenges
	Checksum: 0x78388B3C
	Offset: 0x1618
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function canprocesschallenges()
{
	/#
		if(getdvarint("", 0))
		{
			return true;
		}
	#/
	if(level.rankedmatch || level.arenamatch || level.wagermatch || sessionmodeiscampaigngame())
	{
		return true;
	}
	return false;
}

/*
	Name: initteamchallenges
	Namespace: challenges
	Checksum: 0xFB58FFB9
	Offset: 0x1690
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function initteamchallenges(team)
{
	if(!isdefined(game["challenge"]))
	{
		game["challenge"] = [];
	}
	if(!isdefined(game["challenge"][team]))
	{
		game["challenge"][team] = [];
		game["challenge"][team]["plantedBomb"] = 0;
		game["challenge"][team]["destroyedBombSite"] = 0;
		game["challenge"][team]["capturedFlag"] = 0;
	}
	game["challenge"][team]["allAlive"] = 1;
}

/*
	Name: registerchallengescallback
	Namespace: challenges
	Checksum: 0x83C7A33
	Offset: 0x1770
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function registerchallengescallback(callback, func)
{
	if(!isdefined(level.challengescallbacks[callback]))
	{
		level.challengescallbacks[callback] = [];
	}
	level.challengescallbacks[callback][level.challengescallbacks[callback].size] = func;
}

/*
	Name: dochallengecallback
	Namespace: challenges
	Checksum: 0xBBF11B7C
	Offset: 0x17D8
	Size: 0xE2
	Parameters: 2
	Flags: Linked
*/
function dochallengecallback(callback, data)
{
	if(!isdefined(level.challengescallbacks))
	{
		return;
	}
	if(!isdefined(level.challengescallbacks[callback]))
	{
		return;
	}
	if(isdefined(data))
	{
		for(i = 0; i < level.challengescallbacks[callback].size; i++)
		{
			thread [[level.challengescallbacks[callback][i]]](data);
		}
	}
	else
	{
		for(i = 0; i < level.challengescallbacks[callback].size; i++)
		{
			thread [[level.challengescallbacks[callback][i]]]();
		}
	}
}

/*
	Name: on_player_connect
	Namespace: challenges
	Checksum: 0x25FC86CC
	Offset: 0x18C8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self thread initchallengedata();
	self thread spawnwatcher();
	self thread monitorreloads();
}

/*
	Name: monitorreloads
	Namespace: challenges
	Checksum: 0x85B59098
	Offset: 0x1920
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function monitorreloads()
{
	self endon(#"disconnect");
	self endon(#"killmonitorreloads");
	while(true)
	{
		self waittill(#"reload");
		currentweapon = self getcurrentweapon();
		if(currentweapon == level.weaponnone)
		{
			continue;
		}
		time = gettime();
		self.lastreloadtime = time;
		if(weaponhasattachment(currentweapon, "supply") || weaponhasattachment(currentweapon, "dualclip"))
		{
			self thread reloadthenkill(currentweapon);
		}
	}
}

/*
	Name: reloadthenkill
	Namespace: challenges
	Checksum: 0x1C42F89F
	Offset: 0x1A00
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function reloadthenkill(reloadweapon)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"reloadthenkilltimedout");
	self notify(#"reloadthenkillstart");
	self endon(#"reloadthenkillstart");
	self thread reloadthenkilltimeout(5);
	for(;;)
	{
		self waittill(#"killed_enemy_player", time, weapon);
		if(reloadweapon == weapon)
		{
			self addplayerstat("reload_then_kill_dualclip", 1);
		}
	}
}

/*
	Name: reloadthenkilltimeout
	Namespace: challenges
	Checksum: 0x5B7E30E9
	Offset: 0x1AB8
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function reloadthenkilltimeout(time)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"reloadthenkillstart");
	wait(time);
	self notify(#"reloadthenkilltimedout");
}

/*
	Name: initchallengedata
	Namespace: challenges
	Checksum: 0xF7854EFA
	Offset: 0x1B08
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function initchallengedata()
{
	self.pers["bulletStreak"] = 0;
	self.pers["lastBulletKillTime"] = 0;
	self.pers["stickExplosiveKill"] = 0;
	self.pers["carepackagesCalled"] = 0;
	self.explosiveinfo = [];
}

/*
	Name: isdamagefromplayercontrolledaitank
	Namespace: challenges
	Checksum: 0xDE353EC9
	Offset: 0x1B70
	Size: 0xE2
	Parameters: 3
	Flags: Linked
*/
function isdamagefromplayercontrolledaitank(eattacker, einflictor, weapon)
{
	if(weapon.name == "ai_tank_drone_gun")
	{
		if(isdefined(eattacker) && isdefined(eattacker.remoteweapon) && isdefined(einflictor))
		{
			if(isdefined(einflictor.controlled) && einflictor.controlled)
			{
				if(eattacker.remoteweapon == einflictor)
				{
					return true;
				}
			}
		}
	}
	else if(weapon.name == "ai_tank_drone_rocket")
	{
		if(isdefined(einflictor) && !isdefined(einflictor.from_ai))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: isdamagefromplayercontrolledsentry
	Namespace: challenges
	Checksum: 0x6F8D3828
	Offset: 0x1C60
	Size: 0xA2
	Parameters: 3
	Flags: Linked
*/
function isdamagefromplayercontrolledsentry(eattacker, einflictor, weapon)
{
	if(weapon.name == "auto_gun_turret")
	{
		if(isdefined(eattacker) && isdefined(eattacker.remoteweapon) && isdefined(einflictor))
		{
			if(eattacker.remoteweapon == einflictor)
			{
				if(isdefined(einflictor.controlled) && einflictor.controlled)
				{
					return true;
				}
			}
		}
	}
	return false;
}

/*
	Name: perkkills
	Namespace: challenges
	Checksum: 0xAD6DFD0B
	Offset: 0x1D10
	Size: 0x6E4
	Parameters: 3
	Flags: Linked
*/
function perkkills(victim, isstunned, time)
{
	player = self;
	if(player hasperk("specialty_movefaster"))
	{
		player addplayerstat("perk_movefaster_kills", 1);
	}
	if(player hasperk("specialty_noname"))
	{
		player addplayerstat("perk_noname_kills", 1);
	}
	if(player hasperk("specialty_quieter"))
	{
		player addplayerstat("perk_quieter_kills", 1);
	}
	if(player hasperk("specialty_longersprint"))
	{
		if(isdefined(player.lastsprinttime) && (gettime() - player.lastsprinttime) < 2500)
		{
			player addplayerstat("perk_longersprint", 1);
		}
	}
	if(player hasperk("specialty_fastmantle"))
	{
		if(isdefined(player.lastsprinttime) && (gettime() - player.lastsprinttime) < 2500 && player playerads() >= 1)
		{
			player addplayerstat("perk_fastmantle_kills", 1);
		}
	}
	if(player hasperk("specialty_loudenemies"))
	{
		player addplayerstat("perk_loudenemies_kills", 1);
	}
	if(isstunned == 1 && player hasperk("specialty_stunprotection"))
	{
		player addplayerstat("perk_protection_stun_kills", 1);
	}
	activeenemyemp = 0;
	activecuav = 0;
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			/#
				assert(isdefined(level.activecounteruavs[team]));
			#/
			/#
				assert(isdefined(level.activeemps[team]));
			#/
			if(team == player.team)
			{
				continue;
			}
			if(level.activecounteruavs[team] > 0)
			{
				activecuav = 1;
			}
			if(level.activeemps[team] > 0)
			{
				activeenemyemp = 1;
			}
		}
	}
	else
	{
		/#
			assert(isdefined(level.activecounteruavs[victim.entnum]));
		#/
		/#
			assert(isdefined(level.activeemps[victim.entnum]));
		#/
		players = level.players;
		for(i = 0; i < players.size; i++)
		{
			if(players[i] != player)
			{
				if(isdefined(level.activecounteruavs[players[i].entnum]) && level.activecounteruavs[players[i].entnum] > 0)
				{
					activecuav = 1;
				}
				if(isdefined(level.activeemps[players[i].entnum]) && level.activeemps[players[i].entnum] > 0)
				{
					activeenemyemp = 1;
				}
			}
		}
	}
	if(activecuav == 1 || activeenemyemp == 1)
	{
		if(player hasperk("specialty_immunecounteruav"))
		{
			player addplayerstat("perk_immune_cuav_kills", 1);
		}
	}
	activeuavvictim = 0;
	if(level.teambased)
	{
		if(level.activeuavs[victim.team] > 0)
		{
			activeuavvictim = 1;
		}
	}
	else
	{
		activeuavvictim = isdefined(level.activeuavs[victim.entnum]) && level.activeuavs[victim.entnum] > 0;
	}
	if(activeuavvictim == 1)
	{
		if(player hasperk("specialty_gpsjammer"))
		{
			player addplayerstat("perk_gpsjammer_immune_kills", 1);
		}
	}
	if((player.lastweaponchange + 5000) > time)
	{
		if(player hasperk("specialty_fastweaponswitch"))
		{
			player addplayerstat("perk_fastweaponswitch_kill_after_swap", 1);
		}
	}
	if(player.scavenged == 1)
	{
		if(player hasperk("specialty_scavenger"))
		{
			player addplayerstat("perk_scavenger_kills_after_resupply", 1);
		}
	}
}

/*
	Name: flakjacketprotected
	Namespace: challenges
	Checksum: 0xEEFCAAE0
	Offset: 0x2400
	Size: 0x84
	Parameters: 2
	Flags: None
*/
function flakjacketprotected(weapon, attacker)
{
	if(weapon.name == "claymore")
	{
		self.flakjacketclaymore[attacker.clientid] = 1;
	}
	self addplayerstat("survive_with_flak", 1);
	self.challenge_lastsurvivewithflakfrom = attacker;
	self.challenge_lastsurvivewithflaktime = gettime();
}

/*
	Name: earnedkillstreak
	Namespace: challenges
	Checksum: 0x1DF7A9EA
	Offset: 0x2490
	Size: 0xA0
	Parameters: 0
	Flags: None
*/
function earnedkillstreak()
{
	if(self util::has_purchased_perk_equipped("specialty_anteup"))
	{
		self addplayerstat("earn_scorestreak_anteup", 1);
		if(!isdefined(self.challenge_anteup_earned))
		{
			self.challenge_anteup_earned = 0;
		}
		self.challenge_anteup_earned++;
		if(self.challenge_anteup_earned >= 5)
		{
			self addplayerstat("earn_5_scorestreaks_anteup", 1);
			self.challenge_anteup_earned = 0;
		}
	}
}

/*
	Name: genericbulletkill
	Namespace: challenges
	Checksum: 0x893395D7
	Offset: 0x2538
	Size: 0x164
	Parameters: 3
	Flags: Linked
*/
function genericbulletkill(data, victim, weapon)
{
	player = self;
	time = data.time;
	if(player.pers["lastBulletKillTime"] == time)
	{
		player.pers["bulletStreak"]++;
	}
	else
	{
		player.pers["bulletStreak"] = 1;
	}
	player.pers["lastBulletKillTime"] = time;
	if(data.victim.idflagstime == time)
	{
		if(data.victim.idflags & 8)
		{
			player addplayerstat("kill_enemy_through_wall", 1);
			if(isdefined(weapon) && weaponhasattachment(weapon, "fmj"))
			{
				player addplayerstat("kill_enemy_through_wall_with_fmj", 1);
			}
		}
	}
}

/*
	Name: ishighestscoringplayer
	Namespace: challenges
	Checksum: 0xA22021D3
	Offset: 0x26A8
	Size: 0x18A
	Parameters: 1
	Flags: None
*/
function ishighestscoringplayer(player)
{
	if(!isdefined(player.score) || player.score < 1)
	{
		return false;
	}
	players = level.players;
	if(level.teambased)
	{
		team = player.pers["team"];
	}
	else
	{
		team = "all";
	}
	highscore = player.score;
	for(i = 0; i < players.size; i++)
	{
		if(!isdefined(players[i].score))
		{
			continue;
		}
		if(players[i] == player)
		{
			continue;
		}
		if(players[i].score < 1)
		{
			continue;
		}
		if(team != "all" && players[i].pers["team"] != team)
		{
			continue;
		}
		if(players[i].score >= highscore)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: spawnwatcher
	Namespace: challenges
	Checksum: 0x14F7D655
	Offset: 0x2840
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function spawnwatcher()
{
	self endon(#"disconnect");
	self endon(#"killspawnmonitor");
	self.pers["stickExplosiveKill"] = 0;
	self.pers["pistolHeadshot"] = 0;
	self.pers["assaultRifleHeadshot"] = 0;
	self.pers["killNemesis"] = 0;
	while(true)
	{
		self waittill(#"spawned_player");
		self.pers["longshotsPerLife"] = 0;
		self.flakjacketclaymore = [];
		self.weaponkills = [];
		self.attachmentkills = [];
		self.retreivedblades = 0;
		self.lastreloadtime = 0;
		self.crossbowclipkillcount = 0;
		self thread watchfordtp();
		self thread watchformantle();
		self thread monitor_player_sprint();
	}
}

/*
	Name: watchfordtp
	Namespace: challenges
	Checksum: 0x3067E610
	Offset: 0x2970
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function watchfordtp()
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"killdtpmonitor");
	self.dtptime = 0;
	while(true)
	{
		self waittill(#"dtp_end");
		self.dtptime = gettime() + 4000;
	}
}

/*
	Name: watchformantle
	Namespace: challenges
	Checksum: 0x15CFAF55
	Offset: 0x29D0
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function watchformantle()
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"killmantlemonitor");
	self.mantletime = 0;
	while(true)
	{
		self waittill(#"mantle_start", mantleendtime);
		self.mantletime = mantleendtime;
	}
}

/*
	Name: disarmedhackedcarepackage
	Namespace: challenges
	Checksum: 0xEB574863
	Offset: 0x2A38
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function disarmedhackedcarepackage()
{
	self addplayerstat("disarm_hacked_carepackage", 1);
}

/*
	Name: destroyed_car
	Namespace: challenges
	Checksum: 0xDCB700EA
	Offset: 0x2A68
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function destroyed_car()
{
	if(!isdefined(self) || !isplayer(self))
	{
		return;
	}
	self addplayerstat("destroy_car", 1);
}

/*
	Name: killednemesis
	Namespace: challenges
	Checksum: 0x18F1E175
	Offset: 0x2AC0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function killednemesis()
{
	self.pers["killNemesis"]++;
	if(self.pers["killNemesis"] >= 5)
	{
		self.pers["killNemesis"] = 0;
		self addplayerstat("kill_nemesis", 1);
	}
}

/*
	Name: killwhiledamagingwithhpm
	Namespace: challenges
	Checksum: 0x45E5068D
	Offset: 0x2B30
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function killwhiledamagingwithhpm()
{
	self addplayerstat("kill_while_damaging_with_microwave_turret", 1);
}

/*
	Name: longdistancehatchetkill
	Namespace: challenges
	Checksum: 0x129D8501
	Offset: 0x2B60
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function longdistancehatchetkill()
{
	self addplayerstat("long_distance_hatchet_kill", 1);
}

/*
	Name: blockedsatellite
	Namespace: challenges
	Checksum: 0x749A5640
	Offset: 0x2B90
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function blockedsatellite()
{
	self addplayerstat("activate_cuav_while_enemy_satelite_active", 1);
}

/*
	Name: longdistancekill
	Namespace: challenges
	Checksum: 0x6B89390D
	Offset: 0x2BC0
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function longdistancekill()
{
	self.pers["longshotsPerLife"]++;
	if(self.pers["longshotsPerLife"] >= 3)
	{
		self.pers["longshotsPerLife"] = 0;
		self addplayerstat("longshot_3_onelife", 1);
	}
}

/*
	Name: challengeroundend
	Namespace: challenges
	Checksum: 0x7725F298
	Offset: 0x2C30
	Size: 0x16A
	Parameters: 1
	Flags: Linked
*/
function challengeroundend(data)
{
	player = data.player;
	winner = data.winner;
	if(endedearly(winner))
	{
		return;
	}
	if(level.teambased)
	{
		winnerscore = game["teamScores"][winner];
		loserscore = getlosersteamscores(winner);
	}
	switch(level.gametype)
	{
		case "sd":
		{
			if(player.team == winner)
			{
				if(game["challenge"][winner]["allAlive"])
				{
					player addgametypestat("round_win_no_deaths", 1);
				}
				if(isdefined(player.lastmansddefeat3enemies))
				{
					player addgametypestat("last_man_defeat_3_enemies", 1);
				}
			}
			break;
		}
		default:
		{
			break;
		}
	}
}

/*
	Name: roundend
	Namespace: challenges
	Checksum: 0xCC098FAB
	Offset: 0x2DA8
	Size: 0x136
	Parameters: 1
	Flags: Linked
*/
function roundend(winner)
{
	wait(0.05);
	data = spawnstruct();
	data.time = gettime();
	if(level.teambased)
	{
		if(isdefined(winner) && isdefined(level.teams[winner]))
		{
			data.winner = winner;
		}
	}
	else if(isdefined(winner))
	{
		data.winner = winner;
	}
	for(index = 0; index < level.placement["all"].size; index++)
	{
		data.player = level.placement["all"][index];
		if(isdefined(data.player))
		{
			data.place = index;
			dochallengecallback("roundEnd", data);
		}
	}
}

/*
	Name: gameend
	Namespace: challenges
	Checksum: 0xBD746BFE
	Offset: 0x2EE8
	Size: 0x1F6
	Parameters: 1
	Flags: Linked
*/
function gameend(winner)
{
	wait(0.05);
	data = spawnstruct();
	data.time = gettime();
	if(level.teambased)
	{
		if(isdefined(winner) && isdefined(level.teams[winner]))
		{
			data.winner = winner;
		}
	}
	else if(isdefined(winner) && isplayer(winner))
	{
		data.winner = winner;
	}
	for(index = 0; index < level.placement["all"].size; index++)
	{
		data.player = level.placement["all"][index];
		data.place = index;
		if(isdefined(data.player))
		{
			dochallengecallback("gameEnd", data);
		}
		data.player.completedgame = 1;
	}
	for(index = 0; index < level.players.size; index++)
	{
		if(!isdefined(level.players[index].completedgame) || level.players[index].completedgame != 1)
		{
			scoreevents::processscoreevent("completed_match", level.players[index]);
		}
	}
}

/*
	Name: getfinalkill
	Namespace: challenges
	Checksum: 0xE528FA30
	Offset: 0x30E8
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function getfinalkill(player)
{
	if(isplayer(player))
	{
		player addplayerstat("get_final_kill", 1);
	}
}

/*
	Name: destroyrcbomb
	Namespace: challenges
	Checksum: 0xE9858751
	Offset: 0x3138
	Size: 0x94
	Parameters: 1
	Flags: None
*/
function destroyrcbomb(weapon)
{
	if(!isplayer(self))
	{
		return;
	}
	self destroyscorestreak(weapon, 1, 1);
	if(weapon.rootweapon.name == "hatchet")
	{
		self addplayerstat("destroy_hcxd_with_hatchet", 1);
	}
}

/*
	Name: capturedcrate
	Namespace: challenges
	Checksum: 0xE15718C6
	Offset: 0x31D8
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function capturedcrate(owner)
{
	if(isdefined(self.lastrescuedby) && isdefined(self.lastrescuedtime))
	{
		if((self.lastrescuedtime + 5000) > gettime())
		{
			self.lastrescuedby addplayerstat("defend_teammate_who_captured_package", 1);
		}
	}
	if(owner != self && (level.teambased && owner.team != self.team || !level.teambased))
	{
		self addplayerstat("capture_enemy_carepackage", 1);
	}
}

/*
	Name: destroyscorestreak
	Namespace: challenges
	Checksum: 0x7B3EE90D
	Offset: 0x32A0
	Size: 0x3CC
	Parameters: 4
	Flags: Linked
*/
function destroyscorestreak(weapon, playercontrolled, groundbased, countaskillstreakvehicle = 1)
{
	if(!isplayer(self))
	{
		return;
	}
	if(isdefined(level.killstreakweapons[weapon]))
	{
		if(level.killstreakweapons[weapon] == "dart")
		{
			self addplayerstat("destroy_scorestreak_with_dart", 1);
		}
	}
	else
	{
		if(isdefined(weapon.isheroweapon) && weapon.isheroweapon == 1)
		{
			self addplayerstat("destroy_scorestreak_with_specialist", 1);
		}
		else if(weaponhasattachment(weapon, "fmj", "rf"))
		{
			self addplayerstat("destroy_scorestreak_rapidfire_fmj", 1);
		}
	}
	if(!isdefined(playercontrolled) || playercontrolled == 0)
	{
		if(self util::has_cold_blooded_perk_purchased_and_equipped())
		{
			if(groundbased)
			{
				self addplayerstat("destroy_ai_scorestreak_coldblooded", 1);
			}
			if(self util::has_blind_eye_perk_purchased_and_equipped())
			{
				if(groundbased)
				{
					self.pers["challenge_destroyed_ground"]++;
				}
				else
				{
					self.pers["challenge_destroyed_air"]++;
				}
				if(self.pers["challenge_destroyed_ground"] > 0 && self.pers["challenge_destroyed_air"] > 0)
				{
					self addplayerstat("destroy_air_and_ground_blindeye_coldblooded", 1);
					self.pers["challenge_destroyed_air"] = 0;
					self.pers["challenge_destroyed_ground"] = 0;
				}
			}
		}
	}
	if(!isdefined(self.pers["challenge_destroyed_killstreak"]))
	{
		self.pers["challenge_destroyed_killstreak"] = 0;
	}
	self.pers["challenge_destroyed_killstreak"]++;
	if(self.pers["challenge_destroyed_killstreak"] >= 5)
	{
		self.pers["challenge_destroyed_killstreak"] = 0;
		self addweaponstat(weapon, "destroy_5_killstreak", 1);
		self addweaponstat(weapon, "destroy_5_killstreak_vehicle", 1);
	}
	self addweaponstat(weapon, "destroy_killstreak", 1);
	weaponpickedup = 0;
	if(isdefined(self.pickedupweapons) && isdefined(self.pickedupweapons[weapon]))
	{
		weaponpickedup = 1;
	}
	self addweaponstat(weapon, "destroyed", 1, self.class_num, weaponpickedup, undefined, self.primaryloadoutgunsmithvariantindex, self.secondaryloadoutgunsmithvariantindex);
	self thread watchforrapiddestroy(weapon);
}

/*
	Name: watchforrapiddestroy
	Namespace: challenges
	Checksum: 0x4F19127B
	Offset: 0x3678
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function watchforrapiddestroy(weapon)
{
	self endon(#"disconnect");
	if(!isdefined(self.challenge_previousdestroyweapon) || self.challenge_previousdestroyweapon != weapon)
	{
		self.challenge_previousdestroyweapon = weapon;
		self.challenge_previousdestroycount = 0;
	}
	else
	{
		self.challenge_previousdestroycount++;
	}
	self waittilltimeoutordeath(4);
	if(self.challenge_previousdestroycount > 1)
	{
		self addweaponstat(weapon, "destroy_2_killstreaks_rapidly", 1);
	}
}

/*
	Name: capturedobjective
	Namespace: challenges
	Checksum: 0xEB6F723B
	Offset: 0x3738
	Size: 0x242
	Parameters: 2
	Flags: None
*/
function capturedobjective(capturetime, objective)
{
	if(isdefined(self.smokegrenadetime) && isdefined(self.smokegrenadeposition))
	{
		if((self.smokegrenadetime + 14000) > capturetime)
		{
			distsq = distancesquared(self.smokegrenadeposition, self.origin);
			if(distsq < 57600)
			{
				if(self util::is_item_purchased("willy_pete"))
				{
					self addplayerstat("capture_objective_in_smoke", 1);
				}
				self addweaponstat(getweapon("willy_pete"), "CombatRecordStat", 1);
			}
		}
	}
	else
	{
		if(isdefined(level.capturedobjectivefunction))
		{
			self [[level.capturedobjectivefunction]]();
		}
		heroabilitywasactiverecently = isdefined(self.heroabilityactive) || (isdefined(self.heroabilitydectivatetime) && self.heroabilitydectivatetime > (gettime() - 3000));
		if(heroabilitywasactiverecently && isdefined(self.heroability) && self.heroability.name == "gadget_camo")
		{
			scoreevents::processscoreevent("optic_camo_capture_objective", self);
		}
		if(isdefined(objective))
		{
			if(self.challenge_objectivedefensive === objective)
			{
				if((isdefined(self.challenge_objectivedefensivekillcount) ? self.challenge_objectivedefensivekillcount : 0) > 0 && ((isdefined(self.recentkillcount) ? self.recentkillcount : 0) > 2 || self.challenge_objectivedefensivetriplekillmedalorbetterearned === 1))
				{
					self addplayerstat("triple_kill_defenders_and_capture", 1);
				}
				self.challenge_objectivedefensivekillcount = 0;
				self.challenge_objectivedefensive = undefined;
				self.challenge_objectivedefensivetriplekillmedalorbetterearned = undefined;
			}
		}
	}
}

/*
	Name: hackedordestroyedequipment
	Namespace: challenges
	Checksum: 0xFFCA2299
	Offset: 0x3988
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function hackedordestroyedequipment()
{
	if(self util::has_hacker_perk_purchased_and_equipped())
	{
		self addplayerstat("perk_hacker_destroy", 1);
	}
}

/*
	Name: bladekill
	Namespace: challenges
	Checksum: 0x9B76E15
	Offset: 0x39D0
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function bladekill()
{
	if(!isdefined(self.pers["bladeKills"]))
	{
		self.pers["bladeKills"] = 0;
	}
	self.pers["bladeKills"]++;
	if(self.pers["bladeKills"] >= 15)
	{
		self.pers["bladeKills"] = 0;
		self addplayerstat("kill_15_with_blade", 1);
	}
}

/*
	Name: destroyedexplosive
	Namespace: challenges
	Checksum: 0xB040179E
	Offset: 0x3A70
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function destroyedexplosive(weapon)
{
	self destroyedequipment(weapon);
	self addplayerstat("destroy_explosive", 1);
}

/*
	Name: assisted
	Namespace: challenges
	Checksum: 0x9BC27188
	Offset: 0x3AC0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function assisted()
{
	self addplayerstat("assist", 1);
}

/*
	Name: earnedmicrowaveassistscore
	Namespace: challenges
	Checksum: 0x306AB679
	Offset: 0x3AF0
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function earnedmicrowaveassistscore(score)
{
	self addplayerstat("assist_score_microwave_turret", score);
	self addplayerstat("assist_score_killstreak", score);
	self addweaponstat(getweapon("microwave_turret_deploy"), "assists", 1);
	self addweaponstat(getweapon("microwave_turret_deploy"), "assist_score", score);
}

/*
	Name: earnedcuavassistscore
	Namespace: challenges
	Checksum: 0x4D6E7675
	Offset: 0x3BB8
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function earnedcuavassistscore(score)
{
	self addplayerstat("assist_score_cuav", score);
	self addplayerstat("assist_score_killstreak", score);
	self addweaponstat(getweapon("counteruav"), "assists", 1);
	self addweaponstat(getweapon("counteruav"), "assist_score", score);
}

/*
	Name: earneduavassistscore
	Namespace: challenges
	Checksum: 0x9A66C963
	Offset: 0x3C80
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function earneduavassistscore(score)
{
	self addplayerstat("assist_score_uav", score);
	self addplayerstat("assist_score_killstreak", score);
	self addweaponstat(getweapon("uav"), "assists", 1);
	self addweaponstat(getweapon("uav"), "assist_score", score);
}

/*
	Name: earnedsatelliteassistscore
	Namespace: challenges
	Checksum: 0x43B4D283
	Offset: 0x3D48
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function earnedsatelliteassistscore(score)
{
	self addplayerstat("assist_score_satellite", score);
	self addplayerstat("assist_score_killstreak", score);
	self addweaponstat(getweapon("satellite"), "assists", 1);
	self addweaponstat(getweapon("satellite"), "assist_score", score);
}

/*
	Name: earnedempassistscore
	Namespace: challenges
	Checksum: 0x93E62307
	Offset: 0x3E10
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function earnedempassistscore(score)
{
	self addplayerstat("assist_score_emp", score);
	self addplayerstat("assist_score_killstreak", score);
	self addweaponstat(getweapon("emp_turret"), "assists", 1);
	self addweaponstat(getweapon("emp_turret"), "assist_score", score);
}

/*
	Name: teamcompletedchallenge
	Namespace: challenges
	Checksum: 0x45B7357E
	Offset: 0x3ED8
	Size: 0xB6
	Parameters: 2
	Flags: Linked
*/
function teamcompletedchallenge(team, challenge)
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i].team) && players[i].team == team)
		{
			players[i] addgametypestat(challenge, 1);
		}
	}
}

/*
	Name: endedearly
	Namespace: challenges
	Checksum: 0x28EDFA1
	Offset: 0x3F98
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function endedearly(winner)
{
	if(level.hostforcedend)
	{
		return true;
	}
	if(!isdefined(winner))
	{
		return true;
	}
	if(level.teambased)
	{
		if(winner == "tie")
		{
			return true;
		}
	}
	return false;
}

/*
	Name: getlosersteamscores
	Namespace: challenges
	Checksum: 0x40627411
	Offset: 0x3FF0
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function getlosersteamscores(winner)
{
	teamscores = 0;
	foreach(team in level.teams)
	{
		if(team == winner)
		{
			continue;
		}
		teamscores = teamscores + game["teamScores"][team];
	}
	return teamscores;
}

/*
	Name: didloserfailchallenge
	Namespace: challenges
	Checksum: 0xE9A0E39F
	Offset: 0x40B8
	Size: 0xB8
	Parameters: 2
	Flags: None
*/
function didloserfailchallenge(winner, challenge)
{
	foreach(team in level.teams)
	{
		if(team == winner)
		{
			continue;
		}
		if(game["challenge"][team][challenge])
		{
			return false;
		}
	}
	return true;
}

/*
	Name: challengegameend
	Namespace: challenges
	Checksum: 0x6AACAAFD
	Offset: 0x4178
	Size: 0x56E
	Parameters: 1
	Flags: Linked
*/
function challengegameend(data)
{
	player = data.player;
	winner = data.winner;
	if(endedearly(winner))
	{
		return;
	}
	if(level.teambased)
	{
		winnerscore = game["teamScores"][winner];
		loserscore = getlosersteamscores(winner);
	}
	switch(level.gametype)
	{
		case "tdm":
		{
			if(player.team == winner)
			{
				if(winnerscore >= (loserscore + 20))
				{
					player addgametypestat("CRUSH", 1);
				}
			}
			mostkillsleastdeaths = 1;
			for(index = 0; index < level.placement["all"].size; index++)
			{
				if(level.placement["all"][index].deaths < player.deaths)
				{
					mostkillsleastdeaths = 0;
				}
				if(level.placement["all"][index].kills > player.kills)
				{
					mostkillsleastdeaths = 0;
				}
			}
			if(mostkillsleastdeaths && player.kills > 0 && level.placement["all"].size > 3)
			{
				player addgametypestat("most_kills_least_deaths", 1);
			}
			break;
		}
		case "dm":
		{
			if(player == winner)
			{
				if(level.placement["all"].size >= 2)
				{
					secondplace = level.placement["all"][1];
					if(player.kills >= (secondplace.kills + 7))
					{
						player addgametypestat("CRUSH", 1);
					}
				}
			}
			break;
		}
		case "ctf":
		{
			if(player.team == winner)
			{
				if(loserscore == 0)
				{
					player addgametypestat("SHUT_OUT", 1);
				}
			}
			break;
		}
		case "dom":
		{
			if(player.team == winner)
			{
				if(winnerscore >= (loserscore + 70))
				{
					player addgametypestat("CRUSH", 1);
				}
			}
			break;
		}
		case "hq":
		{
			if(player.team == winner && winnerscore > 0)
			{
				if(winnerscore >= (loserscore + 70))
				{
					player addgametypestat("CRUSH", 1);
				}
			}
			break;
		}
		case "koth":
		{
			if(player.team == winner && winnerscore > 0)
			{
				if(winnerscore >= (loserscore + 70))
				{
					player addgametypestat("CRUSH", 1);
				}
			}
			if(player.team == winner && winnerscore > 0)
			{
				if(winnerscore >= (loserscore + 110))
				{
					player addgametypestat("ANNIHILATION", 1);
				}
			}
			break;
		}
		case "dem":
		{
			if(player.team == game["defenders"] && player.team == winner)
			{
				if(loserscore == 0)
				{
					player addgametypestat("SHUT_OUT", 1);
				}
			}
			break;
		}
		case "sd":
		{
			if(player.team == winner)
			{
				if(loserscore <= 1)
				{
					player addgametypestat("CRUSH", 1);
				}
			}
		}
		default:
		{
			break;
		}
	}
}

/*
	Name: multikill
	Namespace: challenges
	Checksum: 0x8201B330
	Offset: 0x46F0
	Size: 0x1A4
	Parameters: 2
	Flags: None
*/
function multikill(killcount, weapon)
{
	if(killcount >= 3 && isdefined(self.lastkillwheninjured))
	{
		if((self.lastkillwheninjured + 5000) > gettime())
		{
			self addplayerstat("multikill_3_near_death", 1);
		}
	}
	self addweaponstat(weapon, "doublekill", int(killcount / 2));
	self addweaponstat(weapon, "triplekill", int(killcount / 3));
	if(weapon.isheroweapon)
	{
		doublekill = int(killcount / 2);
		if(doublekill)
		{
			self addplayerstat("MULTIKILL_2_WITH_HEROWEAPON", doublekill);
		}
		triplekill = int(killcount / 3);
		if(triplekill)
		{
			self addplayerstat("MULTIKILL_3_WITH_HEROWEAPON", triplekill);
		}
	}
}

/*
	Name: domattackermultikill
	Namespace: challenges
	Checksum: 0x914A2A52
	Offset: 0x48A0
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function domattackermultikill(killcount)
{
	self addgametypestat("kill_2_enemies_capturing_your_objective", 1);
}

/*
	Name: totaldomination
	Namespace: challenges
	Checksum: 0xF7AC4006
	Offset: 0x48D8
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function totaldomination(team)
{
	teamcompletedchallenge(team, "control_3_points_3_minutes");
}

/*
	Name: holdflagentirematch
	Namespace: challenges
	Checksum: 0x9BF000A4
	Offset: 0x4910
	Size: 0x9C
	Parameters: 2
	Flags: None
*/
function holdflagentirematch(team, label)
{
	switch(label)
	{
		case "_a":
		{
			event = "hold_a_entire_match";
			break;
		}
		case "_b":
		{
			event = "hold_b_entire_match";
			break;
		}
		case "_c":
		{
			event = "hold_c_entire_match";
			break;
		}
		default:
		{
			return;
		}
	}
	teamcompletedchallenge(team, event);
}

/*
	Name: capturedbfirstminute
	Namespace: challenges
	Checksum: 0x6A9A9936
	Offset: 0x49B8
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function capturedbfirstminute()
{
	self addgametypestat("capture_b_first_minute", 1);
}

/*
	Name: controlzoneentirely
	Namespace: challenges
	Checksum: 0x213CEF8E
	Offset: 0x49E8
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function controlzoneentirely(team)
{
	teamcompletedchallenge(team, "control_zone_entirely");
}

/*
	Name: multi_lmg_smg_kill
	Namespace: challenges
	Checksum: 0xB6EC8FF8
	Offset: 0x4A20
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function multi_lmg_smg_kill()
{
	self addplayerstat("multikill_3_lmg_or_smg_hip_fire", 1);
}

/*
	Name: killedzoneattacker
	Namespace: challenges
	Checksum: 0x80BB8CF7
	Offset: 0x4A50
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function killedzoneattacker(weapon)
{
	if(weapon.name == "planemortar" || weapon.name == "remote_missile_missile" || weapon.name == "remote_missile_bomblet")
	{
		self thread updatezonemultikills();
	}
}

/*
	Name: killeddog
	Namespace: challenges
	Checksum: 0xA209CB4
	Offset: 0x4AD0
	Size: 0x136
	Parameters: 0
	Flags: Linked
*/
function killeddog()
{
	origin = self.origin;
	if(level.teambased)
	{
		teammates = util::get_team_alive_players_s(self.team);
		foreach(player in teammates.a)
		{
			if(player == self)
			{
				continue;
			}
			distsq = distancesquared(origin, player.origin);
			if(distsq < 57600)
			{
				self addplayerstat("killed_dog_close_to_teammate", 1);
				break;
			}
		}
	}
}

/*
	Name: updatezonemultikills
	Namespace: challenges
	Checksum: 0x858D3C0B
	Offset: 0x4C10
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function updatezonemultikills()
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	self notify(#"updaterecentzonekills");
	self endon(#"updaterecentzonekills");
	if(!isdefined(self.recentzonekillcount))
	{
		self.recentzonekillcount = 0;
	}
	self.recentzonekillcount++;
	wait(4);
	if(self.recentzonekillcount > 1)
	{
		self addplayerstat("multikill_2_zone_attackers", 1);
	}
	self.recentzonekillcount = 0;
}

/*
	Name: multi_rcbomb_kill
	Namespace: challenges
	Checksum: 0xC993C293
	Offset: 0x4CB0
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function multi_rcbomb_kill()
{
	self addplayerstat("multikill_2_with_rcbomb", 1);
}

/*
	Name: multi_remotemissile_kill
	Namespace: challenges
	Checksum: 0x3FB64DC7
	Offset: 0x4CE0
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function multi_remotemissile_kill()
{
	self addplayerstat("multikill_3_remote_missile", 1);
}

/*
	Name: multi_mgl_kill
	Namespace: challenges
	Checksum: 0xD2FF9DB5
	Offset: 0x4D10
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function multi_mgl_kill()
{
	self addplayerstat("multikill_3_with_mgl", 1);
}

/*
	Name: immediatecapture
	Namespace: challenges
	Checksum: 0xE97E088
	Offset: 0x4D40
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function immediatecapture()
{
	self addgametypestat("immediate_capture", 1);
}

/*
	Name: killedlastcontester
	Namespace: challenges
	Checksum: 0x60FB589F
	Offset: 0x4D70
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function killedlastcontester()
{
	self addgametypestat("contest_then_capture", 1);
}

/*
	Name: bothbombsdetonatewithintime
	Namespace: challenges
	Checksum: 0x1ED52C38
	Offset: 0x4DA0
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function bothbombsdetonatewithintime()
{
	self addgametypestat("both_bombs_detonate_10_seconds", 1);
}

/*
	Name: calledincarepackage
	Namespace: challenges
	Checksum: 0xBC456E3C
	Offset: 0x4DD0
	Size: 0x6A
	Parameters: 0
	Flags: None
*/
function calledincarepackage()
{
	self.pers["carepackagesCalled"]++;
	if(self.pers["carepackagesCalled"] >= 3)
	{
		self addplayerstat("call_in_3_care_packages", 1);
		self.pers["carepackagesCalled"] = 0;
	}
}

/*
	Name: destroyedhelicopter
	Namespace: challenges
	Checksum: 0x5B662697
	Offset: 0x4E48
	Size: 0xA4
	Parameters: 4
	Flags: None
*/
function destroyedhelicopter(attacker, weapon, damagetype, playercontrolled)
{
	if(!isplayer(attacker))
	{
		return;
	}
	attacker destroyscorestreak(weapon, playercontrolled, 0);
	if(damagetype == "MOD_RIFLE_BULLET" || damagetype == "MOD_PISTOL_BULLET")
	{
		attacker addplayerstat("destroyed_helicopter_with_bullet", 1);
	}
}

/*
	Name: destroyedqrdrone
	Namespace: challenges
	Checksum: 0xD0EB46DF
	Offset: 0x4EF8
	Size: 0xAC
	Parameters: 2
	Flags: None
*/
function destroyedqrdrone(damagetype, weapon)
{
	self destroyscorestreak(weapon, 1, 0);
	self addplayerstat("destroy_qrdrone", 1);
	if(damagetype == "MOD_RIFLE_BULLET" || damagetype == "MOD_PISTOL_BULLET")
	{
		self addplayerstat("destroyed_qrdrone_with_bullet", 1);
	}
	self destroyedplayercontrolledaircraft();
}

/*
	Name: destroyedplayercontrolledaircraft
	Namespace: challenges
	Checksum: 0xBC74E46C
	Offset: 0x4FB0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function destroyedplayercontrolledaircraft()
{
	if(self hasperk("specialty_noname"))
	{
		self addplayerstat("destroy_helicopter", 1);
	}
}

/*
	Name: destroyedaircraft
	Namespace: challenges
	Checksum: 0x79F2051F
	Offset: 0x5000
	Size: 0x1FC
	Parameters: 3
	Flags: None
*/
function destroyedaircraft(attacker, weapon, playercontrolled)
{
	if(!isplayer(attacker))
	{
		return;
	}
	attacker destroyscorestreak(weapon, playercontrolled, 0);
	if(isdefined(weapon))
	{
		if(weapon.name == "emp" && attacker util::is_item_purchased("killstreak_emp"))
		{
			attacker addplayerstat("destroy_aircraft_with_emp", 1);
		}
		else
		{
			if(weapon.name == "missile_drone_projectile" || weapon.name == "missile_drone")
			{
				attacker addplayerstat("destroy_aircraft_with_missile_drone", 1);
			}
			else if(weapon.isbulletweapon)
			{
				attacker addplayerstat("shoot_aircraft", 1);
			}
		}
	}
	if(attacker util::has_blind_eye_perk_purchased_and_equipped())
	{
		attacker addplayerstat("perk_nottargetedbyairsupport_destroy_aircraft", 1);
	}
	attacker addplayerstat("destroy_aircraft", 1);
	if(isdefined(playercontrolled) && playercontrolled == 0)
	{
		if(attacker util::has_blind_eye_perk_purchased_and_equipped())
		{
			attacker addplayerstat("destroy_ai_aircraft_using_blindeye", 1);
		}
	}
}

/*
	Name: killstreakten
	Namespace: challenges
	Checksum: 0xA1F284DB
	Offset: 0x5208
	Size: 0x1AC
	Parameters: 0
	Flags: None
*/
function killstreakten()
{
	if(!isdefined(self.class_num))
	{
		return;
	}
	primary = self getloadoutitem(self.class_num, "primary");
	if(primary != 0)
	{
		return;
	}
	secondary = self getloadoutitem(self.class_num, "secondary");
	if(secondary != 0)
	{
		return;
	}
	primarygrenade = self getloadoutitem(self.class_num, "primarygrenade");
	if(primarygrenade != 0)
	{
		return;
	}
	specialgrenade = self getloadoutitem(self.class_num, "specialgrenade");
	if(specialgrenade != 0)
	{
		return;
	}
	for(numspecialties = 0; numspecialties < level.maxspecialties; numspecialties++)
	{
		perk = self getloadoutitem(self.class_num, "specialty" + (numspecialties + 1));
		if(perk != 0)
		{
			return;
		}
	}
	self addplayerstat("killstreak_10_no_weapons_perks", 1);
}

/*
	Name: scavengedgrenade
	Namespace: challenges
	Checksum: 0x43F4FBE6
	Offset: 0x53C0
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function scavengedgrenade()
{
	self endon(#"disconnect");
	self endon(#"death");
	self notify(#"scavengedgrenade");
	self endon(#"scavengedgrenade");
	self notify(#"scavenged_primary_grenade");
	for(;;)
	{
		self waittill(#"lethalgrenadekill");
		self addplayerstat("kill_with_resupplied_lethal_grenade", 1);
	}
}

/*
	Name: stunnedtankwithempgrenade
	Namespace: challenges
	Checksum: 0x9CCC5630
	Offset: 0x5438
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function stunnedtankwithempgrenade(attacker)
{
	attacker addplayerstat("stun_aitank_wIth_emp_grenade", 1);
}

/*
	Name: playerkilled
	Namespace: challenges
	Checksum: 0x9EA5FF6B
	Offset: 0x5470
	Size: 0x16A4
	Parameters: 8
	Flags: Linked
*/
function playerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, shitloc, attackerstance, bledout)
{
	/#
		print(level.gametype);
	#/
	self.anglesondeath = self getplayerangles();
	if(isdefined(attacker))
	{
		attacker.anglesonkill = attacker getplayerangles();
	}
	if(!isdefined(weapon))
	{
		weapon = level.weaponnone;
	}
	self endon(#"disconnect");
	data = spawnstruct();
	data.victim = self;
	data.victimorigin = self.origin;
	data.victimstance = self getstance();
	data.einflictor = einflictor;
	data.attacker = attacker;
	data.attackerstance = attackerstance;
	data.idamage = idamage;
	data.smeansofdeath = smeansofdeath;
	data.weapon = weapon;
	data.shitloc = shitloc;
	data.time = gettime();
	data.bledout = 0;
	if(isdefined(bledout))
	{
		data.bledout = bledout;
	}
	if(isdefined(einflictor) && isdefined(einflictor.lastweaponbeforetoss))
	{
		data.lastweaponbeforetoss = einflictor.lastweaponbeforetoss;
	}
	if(isdefined(einflictor) && isdefined(einflictor.ownerweaponatlaunch))
	{
		data.ownerweaponatlaunch = einflictor.ownerweaponatlaunch;
	}
	waslockingon = 0;
	washacked = 0;
	if(isdefined(einflictor))
	{
		if(isdefined(einflictor.locking_on))
		{
			waslockingon = waslockingon | einflictor.locking_on;
		}
		if(isdefined(einflictor.locked_on))
		{
			waslockingon = waslockingon | einflictor.locked_on;
		}
		washacked = einflictor util::ishacked();
	}
	waslockingon = waslockingon & (1 << data.victim.entnum);
	if(waslockingon != 0)
	{
		data.waslockingon = 1;
	}
	else
	{
		data.waslockingon = 0;
	}
	data.washacked = washacked;
	data.wasplanting = data.victim.isplanting;
	data.wasunderwater = data.victim isplayerunderwater();
	if(!isdefined(data.wasplanting))
	{
		data.wasplanting = 0;
	}
	data.wasdefusing = data.victim.isdefusing;
	if(!isdefined(data.wasdefusing))
	{
		data.wasdefusing = 0;
	}
	data.victimweapon = data.victim.currentweapon;
	data.victimonground = data.victim isonground();
	data.victimwaswallrunning = data.victim iswallrunning();
	data.victimlaststunnedby = data.victim.laststunnedby;
	data.victimwasdoublejumping = data.victim isdoublejumping();
	data.victimcombatefficiencylastontime = data.victim.combatefficiencylastontime;
	data.victimspeedburstlastontime = data.victim.speedburstlastontime;
	data.victimcombatefficieny = data.victim ability_util::gadget_is_active(15);
	data.victimflashbacktime = data.victim.flashbacktime;
	data.victimheroabilityactive = ability_player::gadget_checkheroabilitykill(data.victim);
	data.victimelectrifiedby = data.victim.electrifiedby;
	data.victimheroability = data.victim.heroability;
	data.victimwasinslamstate = data.victim isslamming();
	data.victimwaslungingwitharmblades = data.victim isgadgetmeleecharging();
	data.victimwasheatwavestunned = data.victim isheatwavestunned();
	data.victimpowerarmorlasttookdamagetime = data.victim.power_armor_last_took_damage_time;
	data.victimheroweaponkillsthisactivation = data.victim.heroweaponkillsthisactivation;
	data.victimgadgetpower = data.victim gadgetpowerget(0);
	data.victimgadgetwasactivelastdamage = data.victim.gadget_was_active_last_damage;
	data.victimisthieforroulette = data.victim.isthief === 1 || data.victim.isroulette === 1;
	data.victimheroabilityname = data.victim.heroabilityname;
	if(!isdefined(data.victimflashbacktime))
	{
		data.victimflashbacktime = 0;
	}
	if(!isdefined(data.victimcombatefficiencylastontime))
	{
		data.victimcombatefficiencylastontime = 0;
	}
	if(!isdefined(data.victimspeedburstlastontime))
	{
		data.victimspeedburstlastontime = 0;
	}
	data.victimvisionpulseactivatetime = data.victim.visionpulseactivatetime;
	if(!isdefined(data.victimvisionpulseactivatetime))
	{
		data.victimvisionpulseactivatetime = 0;
	}
	data.victimvisionpulsearray = util::array_copy_if_array(data.victim.visionpulsearray);
	data.victimvisionpulseorigin = data.victim.visionpulseorigin;
	data.victimvisionpulseoriginarray = util::array_copy_if_array(data.victim.visionpulseoriginarray);
	data.victimattackersthisspawn = util::array_copy_if_array(data.victim.attackersthisspawn);
	data.victim_doublejump_begin = data.victim.challenge_doublejump_begin;
	data.victim_doublejump_end = data.victim.challenge_doublejump_end;
	data.victim_jump_begin = data.victim.challenge_jump_begin;
	data.victim_jump_end = data.victim.challenge_jump_end;
	data.victim_swimming_begin = data.victim.challenge_swimming_begin;
	data.victim_swimming_end = data.victim.challenge_swimming_end;
	data.victim_slide_begin = data.victim.challenge_slide_begin;
	data.victim_slide_end = data.victim.challenge_slide_end;
	data.victim_wallrun_begin = data.victim.challenge_wallrun_begin;
	data.victim_wallrun_end = data.victim.challenge_wallrun_end;
	data.victim_was_drowning = data.victim drown::is_player_drowning();
	if(isdefined(data.victim.activeproximitygrenades))
	{
		data.victimactiveproximitygrenades = [];
		arrayremovevalue(data.victim.activeproximitygrenades, undefined);
		foreach(proximitygrenade in data.victim.activeproximitygrenades)
		{
			proximitygrenadeinfo = spawnstruct();
			proximitygrenadeinfo.origin = proximitygrenade.origin;
			data.victimactiveproximitygrenades[data.victimactiveproximitygrenades.size] = proximitygrenadeinfo;
		}
	}
	if(isdefined(data.victim.activebouncingbetties))
	{
		data.victimactivebouncingbetties = [];
		arrayremovevalue(data.victim.activebouncingbetties, undefined);
		foreach(bouncingbetty in data.victim.activebouncingbetties)
		{
			bouncingbettyinfo = spawnstruct();
			bouncingbettyinfo.origin = bouncingbetty.origin;
			data.victimactivebouncingbetties[data.victimactivebouncingbetties.size] = bouncingbettyinfo;
		}
	}
	if(isplayer(attacker))
	{
		data.attackerorigin = data.attacker.origin;
		data.attackeronground = data.attacker isonground();
		data.attackerwallrunning = data.attacker iswallrunning();
		data.attackerdoublejumping = data.attacker isdoublejumping();
		data.attackertraversing = data.attacker istraversing();
		data.attackersliding = data.attacker issliding();
		data.attackerspeedburst = data.attacker ability_util::gadget_is_active(13);
		data.attackerflashbacktime = data.attacker.flashbacktime;
		data.attackerheroabilityactive = ability_player::gadget_checkheroabilitykill(data.attacker);
		data.attackerheroability = data.attacker.heroability;
		if(!isdefined(data.attackerflashbacktime))
		{
			data.attackerflashbacktime = 0;
		}
		data.attackervisionpulseactivatetime = attacker.visionpulseactivatetime;
		if(!isdefined(data.attackervisionpulseactivatetime))
		{
			data.attackervisionpulseactivatetime = 0;
		}
		data.attackervisionpulsearray = util::array_copy_if_array(attacker.visionpulsearray);
		data.attackervisionpulseorigin = attacker.visionpulseorigin;
		if(!isdefined(data.attackerstance))
		{
			data.attackerstance = data.attacker getstance();
		}
		data.attackervisionpulseoriginarray = util::array_copy_if_array(attacker.visionpulseoriginarray);
		data.attackerwasflashed = data.attacker isflashbanged();
		data.attackerlastflashedby = data.attacker.lastflashedby;
		data.attackerlaststunnedby = data.attacker.laststunnedby;
		data.attackerlaststunnedtime = data.attacker.laststunnedtime;
		data.attackerwasconcussed = isdefined(data.attacker.concussionendtime) && data.attacker.concussionendtime > gettime();
		data.attackerwasheatwavestunned = data.attacker isheatwavestunned();
		data.attackerwasunderwater = data.attacker isplayerunderwater();
		data.attackerlastfastreloadtime = data.attacker.lastfastreloadtime;
		data.attackerwassliding = data.attacker issliding();
		data.attackerwassprinting = data.attacker issprinting();
		data.attackeristhief = attacker.isthief === 1;
		data.attackerisroulette = attacker.isroulette === 1;
		data.attacker_doublejump_begin = data.attacker.challenge_doublejump_begin;
		data.attacker_doublejump_end = data.attacker.challenge_doublejump_end;
		data.attacker_jump_begin = data.attacker.challenge_jump_begin;
		data.attacker_jump_end = data.attacker.challenge_jump_end;
		data.attacker_swimming_begin = data.attacker.challenge_swimming_begin;
		data.attacker_swimming_end = data.attacker.challenge_swimming_end;
		data.attacker_slide_begin = data.attacker.challenge_slide_begin;
		data.attacker_slide_end = data.attacker.challenge_slide_end;
		data.attacker_wallrun_begin = data.attacker.challenge_wallrun_begin;
		data.attacker_wallrun_end = data.attacker.challenge_wallrun_end;
		data.attacker_was_drowning = data.attacker drown::is_player_drowning();
		data.attacker_sprint_begin = data.attacker.challenge_sprint_begin;
		data.attacker_sprint_end = data.attacker.challenge_sprint_end;
		data.attacker_wallrantwooppositewallsnoground = data.attacker.wallrantwooppositewallsnoground;
		if(level.allow_vehicle_challenge_check === 1 && attacker isinvehicle())
		{
			vehicle = attacker getvehicleoccupied();
			if(isdefined(vehicle))
			{
				data.attackerinvehiclearchetype = vehicle.archetype;
			}
		}
	}
	else
	{
		data.attackeronground = 0;
		data.attackerwallrunning = 0;
		data.attackerdoublejumping = 0;
		data.attackertraversing = 0;
		data.attackersliding = 0;
		data.attackerspeedburst = 0;
		data.attackerflashbacktime = 0;
		data.attackervisionpulseactivatetime = 0;
		data.attackerwasflashed = 0;
		data.attackerwasconcussed = 0;
		data.attackerheroabilityactive = 0;
		data.attackerwasheatwavestunned = 0;
		data.attackerstance = "stand";
		data.attackerwasunderwater = 0;
		data.attackerwassprinting = 0;
		data.attackeristhief = 0;
		data.attackerisroulette = 0;
	}
	if(isdefined(einflictor))
	{
		if(isdefined(einflictor.iscooked))
		{
			data.inflictoriscooked = einflictor.iscooked;
		}
		else
		{
			data.inflictoriscooked = 0;
		}
		if(isdefined(einflictor.challenge_hatchettosscount))
		{
			data.inflictorchallenge_hatchettosscount = einflictor.challenge_hatchettosscount;
		}
		else
		{
			data.inflictorchallenge_hatchettosscount = 0;
		}
		if(isdefined(einflictor.ownerwassprinting))
		{
			data.inflictorownerwassprinting = einflictor.ownerwassprinting;
		}
		else
		{
			data.inflictorownerwassprinting = 0;
		}
		if(isdefined(einflictor.playerhasengineerperk))
		{
			data.inflictorplayerhasengineerperk = einflictor.playerhasengineerperk;
		}
		else
		{
			data.inflictorplayerhasengineerperk = 0;
		}
	}
	else
	{
		data.inflictoriscooked = 0;
		data.inflictorchallenge_hatchettosscount = 0;
		data.inflictorownerwassprinting = 0;
		data.inflictorplayerhasengineerperk = 0;
	}
	waitandprocessplayerkilledcallback(data);
	data.attacker notify(#"playerkilledchallengesprocessed");
}

/*
	Name: doscoreeventcallback
	Namespace: challenges
	Checksum: 0x5175AB86
	Offset: 0x6B20
	Size: 0xE2
	Parameters: 2
	Flags: Linked
*/
function doscoreeventcallback(callback, data)
{
	if(!isdefined(level.scoreeventcallbacks))
	{
		return;
	}
	if(!isdefined(level.scoreeventcallbacks[callback]))
	{
		return;
	}
	if(isdefined(data))
	{
		for(i = 0; i < level.scoreeventcallbacks[callback].size; i++)
		{
			thread [[level.scoreeventcallbacks[callback][i]]](data);
		}
	}
	else
	{
		for(i = 0; i < level.scoreeventcallbacks[callback].size; i++)
		{
			thread [[level.scoreeventcallbacks[callback][i]]]();
		}
	}
}

/*
	Name: waitandprocessplayerkilledcallback
	Namespace: challenges
	Checksum: 0x756AD309
	Offset: 0x6C10
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function waitandprocessplayerkilledcallback(data)
{
	if(isdefined(data.attacker))
	{
		data.attacker endon(#"disconnect");
	}
	wait(0.05);
	util::waittillslowprocessallowed();
	level thread dochallengecallback("playerKilled", data);
	level thread doscoreeventcallback("playerKilled", data);
}

/*
	Name: weaponisknife
	Namespace: challenges
	Checksum: 0x89D306
	Offset: 0x6CA8
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function weaponisknife(weapon)
{
	if(weapon == level.weaponbasemelee || weapon == level.weaponbasemeleeheld || weapon == level.weaponballisticknife)
	{
		return true;
	}
	return false;
}

/*
	Name: eventreceived
	Namespace: challenges
	Checksum: 0x6A03774E
	Offset: 0x6CF8
	Size: 0x462
	Parameters: 1
	Flags: Linked
*/
function eventreceived(eventname)
{
	self endon(#"disconnect");
	util::waittillslowprocessallowed();
	switch(level.gametype)
	{
		case "tdm":
		{
			if(eventname == "killstreak_10")
			{
				self addgametypestat("killstreak_10", 1);
			}
			else
			{
				if(eventname == "killstreak_15")
				{
					self addgametypestat("killstreak_15", 1);
				}
				else
				{
					if(eventname == "killstreak_20")
					{
						self addgametypestat("killstreak_20", 1);
					}
					else
					{
						if(eventname == "multikill_3")
						{
							self addgametypestat("multikill_3", 1);
						}
						else
						{
							if(eventname == "kill_enemy_who_killed_teammate")
							{
								self addgametypestat("kill_enemy_who_killed_teammate", 1);
							}
							else if(eventname == "kill_enemy_injuring_teammate")
							{
								self addgametypestat("kill_enemy_injuring_teammate", 1);
							}
						}
					}
				}
			}
			break;
		}
		case "dm":
		{
			if(eventname == "killstreak_10")
			{
				self addgametypestat("killstreak_10", 1);
			}
			else
			{
				if(eventname == "killstreak_15")
				{
					self addgametypestat("killstreak_15", 1);
				}
				else
				{
					if(eventname == "killstreak_20")
					{
						self addgametypestat("killstreak_20", 1);
					}
					else if(eventname == "killstreak_30")
					{
						self addgametypestat("killstreak_30", 1);
					}
				}
			}
			break;
		}
		case "sd":
		{
			if(eventname == "defused_bomb_last_man_alive")
			{
				self addgametypestat("defused_bomb_last_man_alive", 1);
			}
			else
			{
				if(eventname == "elimination_and_last_player_alive")
				{
					self addgametypestat("elimination_and_last_player_alive", 1);
				}
				else
				{
					if(eventname == "killed_bomb_planter")
					{
						self addgametypestat("killed_bomb_planter", 1);
					}
					else if(eventname == "killed_bomb_defuser")
					{
						self addgametypestat("killed_bomb_defuser", 1);
					}
				}
			}
			break;
		}
		case "ctf":
		{
			if(eventname == "kill_flag_carrier")
			{
				self addgametypestat("kill_flag_carrier", 1);
			}
			else if(eventname == "defend_flag_carrier")
			{
				self addgametypestat("defend_flag_carrier", 1);
			}
			break;
		}
		case "dem":
		{
			if(eventname == "killed_bomb_planter")
			{
				self addgametypestat("killed_bomb_planter", 1);
			}
			else if(eventname == "killed_bomb_defuser")
			{
				self addgametypestat("killed_bomb_defuser", 1);
			}
			break;
		}
		default:
		{
			break;
		}
	}
}

/*
	Name: monitor_player_sprint
	Namespace: challenges
	Checksum: 0x434C3AD4
	Offset: 0x7168
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function monitor_player_sprint()
{
	self endon(#"disconnect");
	self endon(#"killplayersprintmonitor");
	self endon(#"death");
	self.lastsprinttime = undefined;
	while(true)
	{
		self waittill(#"sprint_begin");
		self waittill(#"sprint_end");
		self.lastsprinttime = gettime();
	}
}

/*
	Name: isflashbanged
	Namespace: challenges
	Checksum: 0x22C30967
	Offset: 0x71D0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function isflashbanged()
{
	return isdefined(self.flashendtime) && gettime() < self.flashendtime;
}

/*
	Name: isheatwavestunned
	Namespace: challenges
	Checksum: 0x9484E149
	Offset: 0x71F8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function isheatwavestunned()
{
	return isdefined(self._heat_wave_stuned_end) && gettime() < self._heat_wave_stuned_end;
}

/*
	Name: trophy_defense
	Namespace: challenges
	Checksum: 0xAED9091F
	Offset: 0x7220
	Size: 0xFE
	Parameters: 2
	Flags: Linked
*/
function trophy_defense(origin, radius)
{
	if(isdefined(level.challenge_scorestreaksenabled) && level.challenge_scorestreaksenabled == 1)
	{
		entities = getdamageableentarray(origin, radius);
		foreach(entity in entities)
		{
			if(isdefined(entity.challenge_isscorestreak))
			{
				self addplayerstat("protect_streak_with_trophy", 1);
				break;
			}
		}
	}
}

/*
	Name: waittilltimeoutordeath
	Namespace: challenges
	Checksum: 0xC223F5D4
	Offset: 0x7328
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function waittilltimeoutordeath(timeout)
{
	self endon(#"death");
	wait(timeout);
}

