// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_challenges;
#using scripts\cp\_util;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace scoreevents;

/*
	Name: __init__sytem__
	Namespace: scoreevents
	Checksum: 0x752DAFB8
	Offset: 0x6B8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("scoreevents", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: scoreevents
	Checksum: 0x64F7635D
	Offset: 0x6F8
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
	Namespace: scoreevents
	Checksum: 0x7E37DF8C
	Offset: 0x728
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level.scoreeventcallbacks = [];
	level.scoreeventgameendcallback = &ongameend;
	registerscoreeventcallback("playerKilled", &scoreeventplayerkill);
	registerscoreeventcallback("actorKilled", &scoreeventactorkill);
}

/*
	Name: scoreeventtablelookupint
	Namespace: scoreevents
	Checksum: 0x406EA853
	Offset: 0x7A8
	Size: 0x52
	Parameters: 2
	Flags: None
*/
function scoreeventtablelookupint(index, scoreeventcolumn)
{
	return int(tablelookup(getscoreeventtablename(), 0, index, scoreeventcolumn));
}

/*
	Name: scoreeventtablelookup
	Namespace: scoreevents
	Checksum: 0x45335BB8
	Offset: 0x808
	Size: 0x42
	Parameters: 2
	Flags: None
*/
function scoreeventtablelookup(index, scoreeventcolumn)
{
	return tablelookup(getscoreeventtablename(), 0, index, scoreeventcolumn);
}

/*
	Name: processteamscoreevent
	Namespace: scoreevents
	Checksum: 0xAE836BA6
	Offset: 0x858
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function processteamscoreevent(event)
{
	foreach(e_player in level.players)
	{
		processscoreevent(event, e_player);
	}
	if(isdefined(level.teamscoreuicallback))
	{
		level thread [[level.teamscoreuicallback]](event);
	}
}

/*
	Name: registerscoreeventcallback
	Namespace: scoreevents
	Checksum: 0xDD83568
	Offset: 0x920
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function registerscoreeventcallback(callback, func)
{
	if(!isdefined(level.scoreeventcallbacks[callback]))
	{
		level.scoreeventcallbacks[callback] = [];
	}
	level.scoreeventcallbacks[callback][level.scoreeventcallbacks[callback].size] = func;
}

/*
	Name: scoreeventactorkill
	Namespace: scoreevents
	Checksum: 0x89F4E20E
	Offset: 0x988
	Size: 0x14C
	Parameters: 2
	Flags: Linked
*/
function scoreeventactorkill(data, time)
{
	victim = data.victim;
	attacker = data.attacker;
	time = data.time;
	victim = data.victim;
	meansofdeath = data.smeansofdeath;
	weapon = level.weaponnone;
	if(!level.gametype === "raid")
	{
		return;
	}
	if(!isdefined(attacker))
	{
		return;
	}
	if(!isplayer(attacker))
	{
		return;
	}
	if(isdefined(data.weapon))
	{
		weapon = data.weapon;
		weaponclass = util::getweaponclass(data.weapon);
	}
	attacker thread updatemultikills(weapon, weaponclass);
}

/*
	Name: scoreeventplayerkill
	Namespace: scoreevents
	Checksum: 0x9EFBBB5
	Offset: 0xAE0
	Size: 0x10D4
	Parameters: 2
	Flags: Linked
*/
function scoreeventplayerkill(data, time)
{
	victim = data.victim;
	attacker = data.attacker;
	time = data.time;
	level.numkills++;
	victim = data.victim;
	attacker.lastkilledplayer = victim;
	wasdefusing = data.wasdefusing;
	wasplanting = data.wasplanting;
	wasonground = data.victimonground;
	meansofdeath = data.smeansofdeath;
	weapon = level.weaponnone;
	if(isdefined(data.weapon))
	{
		weapon = data.weapon;
		weaponclass = util::getweaponclass(data.weapon);
	}
	victim.anglesondeath = victim getplayerangles();
	if(meansofdeath == "MOD_GRENADE" || meansofdeath == "MOD_GRENADE_SPLASH" || meansofdeath == "MOD_EXPLOSIVE" || meansofdeath == "MOD_EXPLOSIVE_SPLASH" || meansofdeath == "MOD_PROJECTILE" || meansofdeath == "MOD_PROJECTILE_SPLASH")
	{
		if(weapon == level.weaponnone && isdefined(data.victim.explosiveinfo["weapon"]))
		{
			weapon = data.victim.explosiveinfo["weapon"];
		}
	}
	if(level.teambased)
	{
		attacker.lastkilltime = time;
		if(isdefined(victim.lastkilltime) && victim.lastkilltime > (time - 3000))
		{
			if(isdefined(victim.lastkilledplayer) && victim.lastkilledplayer util::isenemyplayer(attacker) == 0 && attacker != victim.lastkilledplayer)
			{
				processscoreevent("kill_enemy_who_killed_teammate", attacker, victim, weapon);
				victim recordkillmodifier("avenger");
			}
		}
		if(isdefined(victim.damagedplayers))
		{
			keys = getarraykeys(victim.damagedplayers);
			for(i = 0; i < keys.size; i++)
			{
				key = keys[i];
				if(key == attacker.clientid)
				{
					continue;
				}
				if(!isdefined(victim.damagedplayers[key].entity))
				{
					continue;
				}
				if(attacker util::isenemyplayer(victim.damagedplayers[key].entity))
				{
					continue;
				}
				if((time - victim.damagedplayers[key].time) < 1000)
				{
					processscoreevent("kill_enemy_injuring_teammate", attacker, victim, weapon);
					if(isdefined(victim.damagedplayers[key].entity))
					{
						victim.damagedplayers[key].entity.lastrescuedby = attacker;
						victim.damagedplayers[key].entity.lastrescuedtime = time;
					}
					victim recordkillmodifier("defender");
				}
			}
		}
	}
	switch(weapon.name)
	{
		case "hatchet":
		{
			attacker.pers["tomahawks"]++;
			attacker.tomahawks = attacker.pers["tomahawks"];
			processscoreevent("hatchet_kill", attacker, victim, weapon);
			if(isdefined(data.victim.explosiveinfo["projectile_bounced"]) && data.victim.explosiveinfo["projectile_bounced"] == 1)
			{
				level.globalbankshots++;
				processscoreevent("bounce_hatchet_kill", attacker, victim, weapon);
			}
			break;
		}
		case "inventory_supplydrop":
		case "supplydrop":
		{
			if(meansofdeath == "MOD_HIT_BY_OBJECT" || meansofdeath == "MOD_CRUSH")
			{
				processscoreevent("kill_enemy_with_care_package_crush", attacker, victim, weapon);
			}
			else
			{
				processscoreevent("kill_enemy_with_hacked_care_package", attacker, victim, weapon);
			}
			break;
		}
	}
	if(isdefined(data.victimweapon))
	{
		if(data.victimweapon.name == "minigun")
		{
			processscoreevent("killed_death_machine_enemy", attacker, victim, weapon);
		}
		else if(data.victimweapon.name == "m32")
		{
			processscoreevent("killed_multiple_grenade_launcher_enemy", attacker, victim, weapon);
		}
	}
	attacker thread updatemultikills(weapon, weaponclass);
	if(level.numkills == 1)
	{
		victim recordkillmodifier("firstblood");
		processscoreevent("first_kill", attacker, victim, weapon);
	}
	else
	{
		if(isdefined(attacker.lastkilledby))
		{
			if(attacker.lastkilledby == victim)
			{
				level.globalpaybacks++;
				processscoreevent("revenge_kill", attacker, victim, weapon);
				attacker addweaponstat(weapon, "revenge_kill", 1);
				victim recordkillmodifier("revenge");
				attacker.lastkilledby = undefined;
			}
		}
		if(isdefined(victim.lastmansd) && victim.lastmansd == 1)
		{
			processscoreevent("final_kill_elimination", attacker, victim, weapon);
			if(isdefined(attacker.lastmansd) && attacker.lastmansd == 1)
			{
				processscoreevent("elimination_and_last_player_alive", attacker, victim, weapon);
			}
		}
	}
	if(is_weapon_valid(meansofdeath, weapon, weaponclass))
	{
		if(isdefined(victim.vattackerorigin))
		{
			attackerorigin = victim.vattackerorigin;
		}
		else
		{
			attackerorigin = attacker.origin;
		}
		disttovictim = distancesquared(victim.origin, attackerorigin);
		weap_min_dmg_range = get_distance_for_weapon(weapon, weaponclass);
		if(disttovictim > weap_min_dmg_range)
		{
			attacker challenges::longdistancekill();
			if(weapon.name == "hatchet")
			{
				attacker challenges::longdistancehatchetkill();
			}
			processscoreevent("longshot_kill", attacker, victim, weapon);
			attacker addweaponstat(weapon, "longshot_kill", 1);
			attacker.pers["longshots"]++;
			attacker.longshots = attacker.pers["longshots"];
			victim recordkillmodifier("longshot");
		}
	}
	if(isalive(attacker))
	{
		if(attacker.health < (attacker.maxhealth * 0.35))
		{
			attacker.lastkillwheninjured = time;
			processscoreevent("kill_enemy_when_injured", attacker, victim, weapon);
			attacker addweaponstat(weapon, "kill_enemy_when_injured", 1);
			if(attacker hasperk("specialty_bulletflinch"))
			{
				attacker addplayerstat("perk_bulletflinch_kills", 1);
			}
		}
	}
	else if(isdefined(attacker.deathtime) && (attacker.deathtime + 800) < time && !attacker isinvehicle())
	{
		level.globalafterlifes++;
		processscoreevent("kill_enemy_after_death", attacker, victim, weapon);
		victim recordkillmodifier("posthumous");
	}
	if(attacker.cur_death_streak >= 3)
	{
		level.globalcomebacks++;
		processscoreevent("comeback_from_deathstreak", attacker, victim, weapon);
		victim recordkillmodifier("comeback");
	}
	if(meansofdeath == "MOD_MELEE" || meansofdeath == "MOD_MELEE_ASSASSINATE" && !weapon.isriotshield)
	{
		attacker.pers["stabs"]++;
		attacker.stabs = attacker.pers["stabs"];
		vangles = victim.anglesondeath[1];
		pangles = attacker.anglesonkill[1];
		anglediff = angleclamp180(vangles - pangles);
		if(anglediff > -30 && anglediff < 70)
		{
			level.globalbackstabs++;
			processscoreevent("backstabber_kill", attacker, victim, weapon);
			attacker addweaponstat(weapon, "backstabber_kill", 1);
			attacker.pers["backstabs"]++;
			attacker.backstabs = attacker.pers["backstabs"];
		}
	}
	else
	{
		if(isdefined(victim.firsttimedamaged) && victim.firsttimedamaged == time)
		{
			if(weaponclass == "weapon_sniper")
			{
				attacker thread updateoneshotmultikills(victim, weapon, victim.firsttimedamaged);
				attacker addweaponstat(weapon, "kill_enemy_one_bullet", 1);
			}
		}
		if(isdefined(attacker.tookweaponfrom[weapon]) && isdefined(attacker.tookweaponfrom[weapon].previousowner))
		{
			pickedupweapon = attacker.tookweaponfrom[weapon];
			if(pickedupweapon.previousowner == victim)
			{
				processscoreevent("kill_enemy_with_their_weapon", attacker, victim, weapon);
				attacker addweaponstat(weapon, "kill_enemy_with_their_weapon", 1);
				if(isdefined(pickedupweapon.weapon) && isdefined(pickedupweapon.smeansofdeath))
				{
					if(pickedupweapon.weapon == level.weaponbasemeleeheld && (pickedupweapon.smeansofdeath == "MOD_MELEE" || pickedupweapon.smeansofdeath == "MOD_MELEE_ASSASSINATE"))
					{
						attacker addweaponstat(level.weaponbasemeleeheld, "kill_enemy_with_their_weapon", 1);
					}
				}
			}
		}
	}
	if(wasdefusing)
	{
		processscoreevent("killed_bomb_defuser", attacker, victim, weapon);
	}
	else if(wasplanting)
	{
		processscoreevent("killed_bomb_planter", attacker, victim, weapon);
	}
	specificweaponkill(attacker, victim, weapon);
	attacker.cur_death_streak = 0;
	attacker disabledeathstreak();
}

/*
	Name: specificweaponkill
	Namespace: scoreevents
	Checksum: 0x8C92906E
	Offset: 0x1BC0
	Size: 0x24
	Parameters: 4
	Flags: Linked
*/
function specificweaponkill(attacker, victim, weapon, killstreak)
{
}

/*
	Name: multikill
	Namespace: scoreevents
	Checksum: 0x4A78EB6E
	Offset: 0x1BF0
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function multikill(killcount, weapon)
{
	/#
		assert(killcount > 1);
	#/
	self challenges::multikill(killcount, weapon);
	if(killcount > 8)
	{
		processscoreevent("multikill_more_than_8", self, undefined, weapon);
	}
	else
	{
		processscoreevent("multikill_" + killcount, self, undefined, weapon);
	}
	self recordmultikill(killcount);
}

/*
	Name: is_weapon_valid
	Namespace: scoreevents
	Checksum: 0x26E32E55
	Offset: 0x1CC8
	Size: 0xDE
	Parameters: 3
	Flags: Linked
*/
function is_weapon_valid(meansofdeath, weapon, weaponclass)
{
	valid_weapon = 0;
	if(get_distance_for_weapon(weapon, weaponclass) == 0)
	{
		valid_weapon = 0;
	}
	else
	{
		if(meansofdeath == "MOD_PISTOL_BULLET" || meansofdeath == "MOD_RIFLE_BULLET")
		{
			valid_weapon = 1;
		}
		else
		{
			if(meansofdeath == "MOD_HEAD_SHOT")
			{
				valid_weapon = 1;
			}
			else if(weapon.name == "hatchet" && meansofdeath == "MOD_IMPACT")
			{
				valid_weapon = 1;
			}
		}
	}
	return valid_weapon;
}

/*
	Name: updatemultikills
	Namespace: scoreevents
	Checksum: 0x56C02A99
	Offset: 0x1DB0
	Size: 0x3C4
	Parameters: 3
	Flags: Linked
*/
function updatemultikills(weapon, weaponclass, killstreak)
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	self notify(#"updaterecentkills");
	self endon(#"updaterecentkills");
	baseweapon = getweapon(getreffromitemindex(getbaseweaponitemindex(weapon)));
	if(!isdefined(self.recentkillcount))
	{
		self.recentkillcount = 0;
	}
	if(!isdefined(self.recentkillcountweapon) || self.recentkillcountweapon != baseweapon)
	{
		self.recentkillcountsameweapon = 0;
		self.recentkillcountweapon = baseweapon;
	}
	if(!isdefined(killstreak))
	{
		self.recentkillcountsameweapon++;
		self.recentkillcount++;
	}
	if(!isdefined(self.recent_lmg_smg_killcount))
	{
		self.recent_lmg_smg_killcount = 0;
	}
	if(!isdefined(self.recentremotemissilekillcount))
	{
		self.recentremotemissilekillcount = 0;
	}
	if(!isdefined(self.recentrcbombkillcount))
	{
		self.recentrcbombkillcount = 0;
	}
	if(!isdefined(self.recentmglkillcount))
	{
		self.recentmglkillcount = 0;
	}
	if(isdefined(weaponclass))
	{
		if(weaponclass == "weapon_lmg" || weaponclass == "weapon_smg")
		{
			if(self playerads() < 1)
			{
				self.recent_lmg_smg_killcount++;
			}
		}
	}
	if(isdefined(killstreak))
	{
		switch(killstreak)
		{
			case "remote_missile":
			{
				self.recentremotemissilekillcount++;
				break;
			}
			case "rcbomb":
			{
				self.recentrcbombkillcount++;
				break;
			}
			case "inventory_m32":
			case "m32":
			{
				self.recentmglkillcount++;
				break;
			}
		}
	}
	if(self.recentkillcountsameweapon == 2)
	{
		self addweaponstat(weapon, "multikill_2", 1);
	}
	else if(self.recentkillcountsameweapon == 3)
	{
		self addweaponstat(weapon, "multikill_3", 1);
	}
	self waittilltimeoutordeath(4);
	if(self.recent_lmg_smg_killcount >= 3)
	{
		self challenges::multi_lmg_smg_kill();
	}
	if(self.recentrcbombkillcount >= 2)
	{
		self challenges::multi_rcbomb_kill();
	}
	if(self.recentmglkillcount >= 3)
	{
		self challenges::multi_mgl_kill();
	}
	if(self.recentremotemissilekillcount >= 3)
	{
		self challenges::multi_remotemissile_kill();
	}
	if(self.recentkillcount > 1)
	{
		self multikill(self.recentkillcount, weapon);
	}
	self.recentkillcount = 0;
	self.recentkillcountsameweapon = 0;
	self.recentkillcountweapon = undefined;
	self.recent_lmg_smg_killcount = 0;
	self.recentremotemissilekillcount = 0;
	self.recentrcbombkillcount = 0;
	self.recentmglkillcount = 0;
}

/*
	Name: waittilltimeoutordeath
	Namespace: scoreevents
	Checksum: 0xDBD0869E
	Offset: 0x2180
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function waittilltimeoutordeath(timeout)
{
	self endon(#"death");
	wait(timeout);
}

/*
	Name: updateoneshotmultikills
	Namespace: scoreevents
	Checksum: 0xEE81E220
	Offset: 0x21A8
	Size: 0xE0
	Parameters: 3
	Flags: Linked
*/
function updateoneshotmultikills(victim, weapon, firsttimedamaged)
{
	self endon(#"death");
	self endon(#"disconnect");
	self notify("updateoneshotmultikills" + firsttimedamaged);
	self endon("updateoneshotmultikills" + firsttimedamaged);
	if(!isdefined(self.oneshotmultikills))
	{
		self.oneshotmultikills = 0;
	}
	self.oneshotmultikills++;
	wait(1);
	if(self.oneshotmultikills > 1)
	{
		processscoreevent("kill_enemies_one_bullet", self, victim, weapon);
	}
	else
	{
		processscoreevent("kill_enemy_one_bullet", self, victim, weapon);
	}
	self.oneshotmultikills = 0;
}

/*
	Name: get_distance_for_weapon
	Namespace: scoreevents
	Checksum: 0x996C99CF
	Offset: 0x2290
	Size: 0x13A
	Parameters: 2
	Flags: Linked
*/
function get_distance_for_weapon(weapon, weaponclass)
{
	distance = 0;
	switch(weaponclass)
	{
		case "weapon_smg":
		{
			distance = 1562500;
			break;
		}
		case "weapon_assault":
		{
			distance = 2250000;
			break;
		}
		case "weapon_lmg":
		{
			distance = 2250000;
			break;
		}
		case "weapon_sniper":
		{
			distance = 3062500;
			break;
		}
		case "weapon_pistol":
		{
			distance = 490000;
			break;
		}
		case "weapon_cqb":
		{
			distance = 422500;
			break;
		}
		case "weapon_special":
		{
			if(weapon == level.weaponballisticknife)
			{
				distance = 2250000;
			}
			break;
		}
		case "weapon_grenade":
		{
			if(weapon.name == "hatchet")
			{
				distance = 6250000;
			}
			break;
		}
		default:
		{
			distance = 0;
			break;
		}
	}
	return distance;
}

/*
	Name: ongameend
	Namespace: scoreevents
	Checksum: 0xCBD91BA5
	Offset: 0x23D8
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function ongameend(data)
{
	player = data.player;
	winner = data.winner;
	if(isdefined(winner))
	{
		if(level.teambased)
		{
			if(winner != "tie" && player.team == winner)
			{
				processscoreevent("won_match", player);
				return;
			}
		}
		else
		{
			placement = level.placement["all"];
			topthreeplayers = min(3, placement.size);
			for(index = 0; index < topthreeplayers; index++)
			{
				if(level.placement["all"][index] == player)
				{
					processscoreevent("won_match", player);
					return;
				}
			}
		}
	}
	processscoreevent("completed_match", player);
}

