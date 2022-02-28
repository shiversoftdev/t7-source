// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;

#namespace challenges;

/*
	Name: __init__sytem__
	Namespace: challenges
	Checksum: 0x3ABCC6F8
	Offset: 0x980
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("challenges", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: challenges
	Checksum: 0x99EC1590
	Offset: 0x9C0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

/*
	Name: init
	Namespace: challenges
	Checksum: 0x31B7CF42
	Offset: 0x9D0
	Size: 0x194
	Parameters: 0
	Flags: None
*/
function init()
{
	if(!isdefined(level.challengescallbacks))
	{
		level.challengescallbacks = [];
	}
	waittillframeend();
	if(canprocesschallenges())
	{
		registerchallengescallback("playerKilled", &challengekills);
		registerchallengescallback("actorKilled", &challengeactorkills);
		registerchallengescallback("gameEnd", &challengegameend);
		registerchallengescallback("roundEnd", &challengeroundend);
	}
	callback::on_connect(&on_player_connect);
	foreach(team in level.teams)
	{
		initteamchallenges(team);
	}
	level.challengesoneventreceived = &eventreceived;
}

/*
	Name: challengekills
	Namespace: challenges
	Checksum: 0x35A3B5E7
	Offset: 0xB70
	Size: 0x1F6C
	Parameters: 2
	Flags: Linked
*/
function challengekills(data, time)
{
	victim = data.victim;
	player = data.attacker;
	attacker = data.attacker;
	time = data.time;
	victim = data.victim;
	weapon = data.weapon;
	time = data.time;
	inflictor = data.einflictor;
	meansofdeath = data.smeansofdeath;
	wasplanting = data.wasplanting;
	wasdefusing = data.wasdefusing;
	lastweaponbeforetoss = data.lastweaponbeforetoss;
	ownerweaponatlaunch = data.ownerweaponatlaunch;
	if(!isdefined(data.weapon))
	{
		return;
	}
	if(!isdefined(player) || !isplayer(player))
	{
		return;
	}
	weaponclass = util::getweaponclass(weapon);
	game["challenge"][victim.team]["allAlive"] = 0;
	if(level.teambased)
	{
		if(player.team == victim.team)
		{
			return;
		}
	}
	else if(player == victim)
	{
		return;
	}
	if(isdamagefromplayercontrolledaitank(player, inflictor, weapon))
	{
		player addplayerstat("kill_with_remote_control_ai_tank", 1);
	}
	if(weapon.name == "auto_gun_turret")
	{
		if(isdefined(inflictor))
		{
			if(!isdefined(inflictor.killcount))
			{
				inflictor.killcount = 0;
			}
			inflictor.killcount++;
			if(inflictor.killcount >= 5)
			{
				inflictor.killcount = 0;
				player addplayerstat("killstreak_5_with_sentry_gun", 1);
			}
		}
		if(isdamagefromplayercontrolledsentry(player, inflictor, weapon))
		{
			player addplayerstat("kill_with_remote_control_sentry_gun", 1);
		}
	}
	if(weapon.name == "minigun" || weapon.name == "inventory_minigun")
	{
		player.deathmachinekills++;
		if(player.deathmachinekills >= 5)
		{
			player.deathmachinekills = 0;
			player addplayerstat("killstreak_5_with_death_machine", 1);
		}
	}
	if(data.waslockingon && weapon.name == "chopper_minigun")
	{
		player addplayerstat("kill_enemy_locking_on_with_chopper_gunner", 1);
	}
	if(isdefined(level.iskillstreakweapon))
	{
		if([[level.iskillstreakweapon]](weapon))
		{
			return;
		}
	}
	attacker notify(#"killed_enemy_player", time, weapon);
	if(isdefined(player.primaryloadoutweapon) && weapon == player.primaryloadoutweapon || (isdefined(player.primaryloadoutaltweapon) && weapon == player.primaryloadoutaltweapon))
	{
		if(player isbonuscardactive(0, player.class_num))
		{
			player addbonuscardstat(0, "kills", 1, player.class_num);
			player addplayerstat("kill_with_loadout_weapon_with_3_attachments", 1);
		}
		if(isdefined(player.secondaryweaponkill) && player.secondaryweaponkill == 1)
		{
			player.primaryweaponkill = 0;
			player.secondaryweaponkill = 0;
			if(player isbonuscardactive(2, player.class_num))
			{
				player addbonuscardstat(2, "kills", 1, player.class_num);
				player addplayerstat("kill_with_both_primary_weapons", 1);
			}
		}
		else
		{
			player.primaryweaponkill = 1;
		}
	}
	else if(isdefined(player.secondaryloadoutweapon) && weapon == player.secondaryloadoutweapon || (isdefined(player.secondaryloadoutaltweapon) && weapon == player.secondaryloadoutaltweapon))
	{
		if(player isbonuscardactive(1, player.class_num))
		{
			player addbonuscardstat(1, "kills", 1, player.class_num);
		}
		if(isdefined(player.primaryweaponkill) && player.primaryweaponkill == 1)
		{
			player.primaryweaponkill = 0;
			player.secondaryweaponkill = 0;
			if(player isbonuscardactive(2, player.class_num))
			{
				player addbonuscardstat(2, "kills", 1, player.class_num);
				player addplayerstat("kill_with_both_primary_weapons", 1);
			}
		}
		else
		{
			player.secondaryweaponkill = 1;
		}
	}
	if(player isbonuscardactive(5, player.class_num) || player isbonuscardactive(4, player.class_num) || player isbonuscardactive(3, player.class_num))
	{
		player addplayerstat("kill_with_2_perks_same_category", 1);
	}
	baseweapon = getweapon(getreffromitemindex(getbaseweaponitemindex(weapon)));
	if(isdefined(player.weaponkills[baseweapon]))
	{
		player.weaponkills[baseweapon]++;
		if(player.weaponkills[baseweapon] == 5)
		{
			player addweaponstat(baseweapon, "killstreak_5", 1);
		}
		if(player.weaponkills[baseweapon] == 10)
		{
			player addweaponstat(baseweapon, "killstreak_10", 1);
		}
	}
	else
	{
		player.weaponkills[baseweapon] = 1;
	}
	attachmentname = player getweaponoptic(weapon);
	if(isdefined(attachmentname) && attachmentname != "")
	{
		if(isdefined(player.attachmentkills[attachmentname]))
		{
			player.attachmentkills[attachmentname]++;
			if(player.attachmentkills[attachmentname] == 5)
			{
				player addweaponstat(weapon, "killstreak_5_attachment", 1);
			}
		}
		else
		{
			player.attachmentkills[attachmentname] = 1;
		}
	}
	/#
		assert(isdefined(player.activecounteruavs));
	#/
	/#
		assert(isdefined(player.activeuavs));
	#/
	/#
		assert(isdefined(player.activesatellites));
	#/
	if(player.activeuavs > 0)
	{
		player addplayerstat("kill_while_uav_active", 1);
	}
	if(player.activecounteruavs > 0)
	{
		player addplayerstat("kill_while_cuav_active", 1);
	}
	if(player.activesatellites > 0)
	{
		player addplayerstat("kill_while_satellite_active", 1);
	}
	if(isdefined(attacker.tacticalinsertiontime) && (attacker.tacticalinsertiontime + 5000) > time)
	{
		player addplayerstat("kill_after_tac_insert", 1);
		player addweaponstat(level.weapontacticalinsertion, "CombatRecordStat", 1);
	}
	if(isdefined(victim.tacticalinsertiontime) && (victim.tacticalinsertiontime + 5000) > time)
	{
		player addweaponstat(level.weapontacticalinsertion, "headshots", 1);
	}
	if(isdefined(level.isplayertrackedfunc))
	{
		if(attacker [[level.isplayertrackedfunc]](victim, time))
		{
			attacker addplayerstat("kill_enemy_revealed_by_sensor", 1);
			attacker addweaponstat(getweapon("sensor_grenade"), "CombatRecordStat", 1);
		}
	}
	if(level.teambased)
	{
		activeempowner = level.empowners[player.team];
		if(isdefined(activeempowner))
		{
			if(activeempowner == player)
			{
				player addplayerstat("kill_while_emp_active", 1);
			}
		}
	}
	else if(isdefined(level.empplayer))
	{
		if(level.empplayer == player)
		{
			player addplayerstat("kill_while_emp_active", 1);
		}
	}
	if(isdefined(player.flakjacketclaymore[victim.clientid]) && player.flakjacketclaymore[victim.clientid] == 1)
	{
		player addplayerstat("survive_claymore_kill_planter_flak_jacket_equipped", 1);
	}
	if(isdefined(player.dogsactive))
	{
		if(weapon.name != "dog_bite")
		{
			player.dogsactivekillstreak++;
			if(player.dogsactivekillstreak > 5)
			{
				player addplayerstat("killstreak_5_dogs", 1);
			}
		}
	}
	isstunned = 0;
	if(victim util::isflashbanged())
	{
		if(isdefined(victim.lastflashedby) && victim.lastflashedby == player)
		{
			player addplayerstat("kill_flashed_enemy", 1);
			player addweaponstat(getweapon("flash_grenade"), "CombatRecordStat", 1);
		}
		isstunned = 1;
	}
	if(isdefined(victim.concussionendtime) && victim.concussionendtime > gettime())
	{
		if(isdefined(victim.lastconcussedby) && victim.lastconcussedby == player)
		{
			player addplayerstat("kill_concussed_enemy", 1);
			player addweaponstat(getweapon("concussion_grenade"), "CombatRecordStat", 1);
		}
		isstunned = 1;
	}
	if(isdefined(player.laststunnedby))
	{
		if(player.laststunnedby == victim && (player.laststunnedtime + 5000) > time)
		{
			player addplayerstat("kill_enemy_who_shocked_you", 1);
		}
	}
	if(isdefined(victim.laststunnedby) && (victim.laststunnedtime + 5000) > time)
	{
		isstunned = 1;
		if(victim.laststunnedby == player)
		{
			player addplayerstat("kill_shocked_enemy", 1);
			player addweaponstat(getweapon("proximity_grenade"), "CombatRecordStat", 1);
			if(data.smeansofdeath == "MOD_MELEE" || data.smeansofdeath == "MOD_MELEE_ASSASSINATE")
			{
				player addplayerstat("shock_enemy_then_stab_them", 1);
			}
		}
	}
	if(isdefined(player.tookweaponfrom) && isdefined(player.tookweaponfrom[weapon]) && isdefined(player.tookweaponfrom[weapon].previousowner))
	{
		if(level.teambased)
		{
			if(player.tookweaponfrom[weapon].previousowner.team != player.team)
			{
				player.pickedupweaponkills[weapon]++;
				player addplayerstat("kill_enemy_with_picked_up_weapon", 1);
			}
		}
		else
		{
			player.pickedupweaponkills[weapon]++;
			player addplayerstat("kill_enemy_with_picked_up_weapon", 1);
		}
		if(player.pickedupweaponkills[weapon] >= 5)
		{
			player.pickedupweaponkills[weapon] = 0;
			player addplayerstat("killstreak_5_picked_up_weapon", 1);
		}
	}
	if(isdefined(victim.explosiveinfo["originalOwnerKill"]) && victim.explosiveinfo["originalOwnerKill"] == 1)
	{
		if(victim.explosiveinfo["damageExplosiveKill"] == 1)
		{
			player addplayerstat("kill_enemy_shoot_their_explosive", 1);
		}
	}
	if(data.attackerstance == "crouch")
	{
		player addplayerstat("kill_enemy_while_crouched", 1);
	}
	else if(data.attackerstance == "prone")
	{
		player addplayerstat("kill_enemy_while_prone", 1);
	}
	if(data.victimstance == "prone")
	{
		player addplayerstat("kill_prone_enemy", 1);
	}
	if(data.smeansofdeath == "MOD_HEAD_SHOT" || data.smeansofdeath == "MOD_PISTOL_BULLET" || data.smeansofdeath == "MOD_RIFLE_BULLET")
	{
		player genericbulletkill(data, victim, weapon);
	}
	if(level.teambased)
	{
		if(!isdefined(player.pers["kill_every_enemy"]) && (level.playercount[victim.pers["team"]] > 3 && player.pers["killed_players"].size >= level.playercount[victim.pers["team"]]))
		{
			player addplayerstat("kill_every_enemy", 1);
			player.pers["kill_every_enemy"] = 1;
		}
	}
	switch(weaponclass)
	{
		case "weapon_pistol":
		{
			if(data.smeansofdeath == "MOD_HEAD_SHOT")
			{
				player.pers["pistolHeadshot"]++;
				if(player.pers["pistolHeadshot"] >= 10)
				{
					player.pers["pistolHeadshot"] = 0;
					player addplayerstat("pistolHeadshot_10_onegame", 1);
				}
			}
			break;
		}
		case "weapon_assault":
		{
			if(data.smeansofdeath == "MOD_HEAD_SHOT")
			{
				player.pers["assaultRifleHeadshot"]++;
				if(player.pers["assaultRifleHeadshot"] >= 5)
				{
					player.pers["assaultRifleHeadshot"] = 0;
					player addplayerstat("headshot_assault_5_onegame", 1);
				}
			}
			break;
		}
		case "weapon_lmg":
		case "weapon_smg":
		{
			break;
		}
		case "weapon_sniper":
		{
			if(isdefined(victim.firsttimedamaged) && victim.firsttimedamaged == time)
			{
				player addplayerstat("kill_enemy_one_bullet_sniper", 1);
				player addweaponstat(weapon, "kill_enemy_one_bullet_sniper", 1);
				if(!isdefined(player.pers["one_shot_sniper_kills"]))
				{
					player.pers["one_shot_sniper_kills"] = 0;
				}
				player.pers["one_shot_sniper_kills"]++;
				if(player.pers["one_shot_sniper_kills"] == 10)
				{
					player addplayerstat("kill_10_enemy_one_bullet_sniper_onegame", 1);
				}
			}
			break;
		}
		case "weapon_cqb":
		{
			if(isdefined(victim.firsttimedamaged) && victim.firsttimedamaged == time)
			{
				player addplayerstat("kill_enemy_one_bullet_shotgun", 1);
				player addweaponstat(weapon, "kill_enemy_one_bullet_shotgun", 1);
				if(!isdefined(player.pers["one_shot_shotgun_kills"]))
				{
					player.pers["one_shot_shotgun_kills"] = 0;
				}
				player.pers["one_shot_shotgun_kills"]++;
				if(player.pers["one_shot_shotgun_kills"] == 10)
				{
					player addplayerstat("kill_10_enemy_one_bullet_shotgun_onegame", 1);
				}
			}
			break;
		}
	}
	if(data.smeansofdeath == "MOD_MELEE" || data.smeansofdeath == "MOD_MELEE_ASSASSINATE")
	{
		if(weaponhasattachment(weapon, "tacknife"))
		{
			player addplayerstat("kill_enemy_with_tacknife", 1);
			player bladekill();
		}
		else
		{
			if(weapon == level.weaponballisticknife)
			{
				player bladekill();
				player addweaponstat(weapon, "ballistic_knife_melee", 1);
			}
			else
			{
				if(weapon == level.weaponbasemelee || weapon == level.weaponbasemeleeheld)
				{
					player bladekill();
				}
				else if(weapon.isriotshield)
				{
					if((victim.lastfiretime + 3000) > time)
					{
						player addweaponstat(weapon, "shield_melee_while_enemy_shooting", 1);
					}
				}
			}
		}
	}
	else
	{
		if(isdefined(ownerweaponatlaunch))
		{
			if(weaponhasattachment(ownerweaponatlaunch, "stackfire"))
			{
				player addplayerstat("KILL_CROSSBOW_STACKFIRE", 1);
			}
		}
		if(weapon == level.weaponballisticknife)
		{
			player bladekill();
			if(isdefined(player.retreivedblades) && player.retreivedblades > 0)
			{
				player.retreivedblades--;
				player addweaponstat(weapon, "kill_retrieved_blade", 1);
			}
		}
	}
	lethalgrenadekill = 0;
	switch(weapon.name)
	{
		case "bouncingbetty":
		{
			lethalgrenadekill = 1;
			player notify(#"lethalgrenadekill");
			break;
		}
		case "hatchet":
		{
			player bladekill();
			lethalgrenadekill = 1;
			player notify(#"lethalgrenadekill");
			if(isdefined(lastweaponbeforetoss))
			{
				if(lastweaponbeforetoss.isriotshield)
				{
					player addweaponstat(lastweaponbeforetoss, "hatchet_kill_with_shield_equiped", 1);
					player addplayerstat("hatchet_kill_with_shield_equiped", 1);
				}
			}
			break;
		}
		case "claymore":
		{
			lethalgrenadekill = 1;
			player notify(#"lethalgrenadekill");
			player addplayerstat("kill_with_claymore", 1);
			if(data.washacked)
			{
				player addplayerstat("kill_with_hacked_claymore", 1);
			}
			break;
		}
		case "satchel_charge":
		{
			lethalgrenadekill = 1;
			player notify(#"lethalgrenadekill");
			player addplayerstat("kill_with_c4", 1);
			break;
		}
		case "destructible_car":
		{
			player addplayerstat("kill_enemy_withcar", 1);
			if(isdefined(inflictor.destroyingweapon))
			{
				player addweaponstat(inflictor.destroyingweapon, "kills_from_cars", 1);
			}
			break;
		}
		case "sticky_grenade":
		{
			lethalgrenadekill = 1;
			player notify(#"lethalgrenadekill");
			if(isdefined(victim.explosiveinfo["stuckToPlayer"]) && victim.explosiveinfo["stuckToPlayer"] == victim)
			{
				attacker.pers["stickExplosiveKill"]++;
				if(attacker.pers["stickExplosiveKill"] >= 5)
				{
					attacker.pers["stickExplosiveKill"] = 0;
					player addplayerstat("stick_explosive_kill_5_onegame", 1);
				}
			}
			break;
		}
		case "frag_grenade":
		{
			lethalgrenadekill = 1;
			player notify(#"lethalgrenadekill");
			if(isdefined(data.victim.explosiveinfo["cookedKill"]) && data.victim.explosiveinfo["cookedKill"] == 1)
			{
				player addplayerstat("kill_with_cooked_grenade", 1);
			}
			if(isdefined(data.victim.explosiveinfo["throwbackKill"]) && data.victim.explosiveinfo["throwbackKill"] == 1)
			{
				player addplayerstat("kill_with_tossed_back_lethal", 1);
			}
			break;
		}
	}
	if(lethalgrenadekill)
	{
		if(player isbonuscardactive(6, player.class_num))
		{
			player addbonuscardstat(6, "kills", 1, player.class_num);
			if(!isdefined(player.pers["dangerCloseKills"]))
			{
				player.pers["dangerCloseKills"] = 0;
			}
			player.pers["dangerCloseKills"]++;
			if(player.pers["dangerCloseKills"] == 5)
			{
				player addplayerstat("kill_with_dual_lethal_grenades", 1);
			}
		}
	}
	player perkkills(victim, isstunned, time);
}

/*
	Name: challengeactorkills
	Namespace: challenges
	Checksum: 0x9055776D
	Offset: 0x2AE8
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function challengeactorkills(data, time)
{
}

