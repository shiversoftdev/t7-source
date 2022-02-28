// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\table_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicles\_raps;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_weaponobjects;

#namespace killstreaks;

/*
	Name: is_killstreak_weapon
	Namespace: killstreaks
	Checksum: 0xFA6BB845
	Offset: 0x2F0
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function is_killstreak_weapon(weapon)
{
	if(weapon == level.weaponnone || weapon.notkillstreak)
	{
		return false;
	}
	if(weapon.isspecificuse || is_weapon_associated_with_killstreak(weapon))
	{
		return true;
	}
	return false;
}

/*
	Name: is_weapon_associated_with_killstreak
	Namespace: killstreaks
	Checksum: 0x14A0DF0C
	Offset: 0x360
	Size: 0x26
	Parameters: 1
	Flags: Linked
*/
function is_weapon_associated_with_killstreak(weapon)
{
	return isdefined(level.killstreakweapons) && isdefined(level.killstreakweapons[weapon]);
}

/*
	Name: switch_to_last_non_killstreak_weapon
	Namespace: killstreaks
	Checksum: 0x1556F46A
	Offset: 0x390
	Size: 0x388
	Parameters: 2
	Flags: Linked
*/
function switch_to_last_non_killstreak_weapon(immediate, awayfromball)
{
	ball = getweapon("ball");
	if(isdefined(ball) && self hasweapon(ball) && (!(isdefined(awayfromball) && awayfromball)))
	{
		self switchtoweaponimmediate(ball);
		self disableweaponcycling();
		self disableoffhandweapons();
	}
	else
	{
		if(isdefined(self.laststand) && self.laststand)
		{
			if(isdefined(self.laststandpistol) && self hasweapon(self.laststandpistol))
			{
				self switchtoweapon(self.laststandpistol);
			}
		}
		else
		{
			if(isdefined(self.lastnonkillstreakweapon) && self hasweapon(self.lastnonkillstreakweapon))
			{
				if(self.lastnonkillstreakweapon.isheroweapon)
				{
					if(self.lastnonkillstreakweapon.gadget_heroversion_2_0)
					{
						if(self.lastnonkillstreakweapon.isgadget && self getammocount(self.lastnonkillstreakweapon) > 0)
						{
							slot = self gadgetgetslot(self.lastnonkillstreakweapon);
							if(self ability_player::gadget_is_in_use(slot))
							{
								return self switchtoweapon(self.lastnonkillstreakweapon);
							}
							return 1;
						}
					}
					else if(self getammocount(self.lastnonkillstreakweapon) > 0)
					{
						return self switchtoweapon(self.lastnonkillstreakweapon);
					}
					if(isdefined(awayfromball) && awayfromball && isdefined(self.lastdroppableweapon) && self hasweapon(self.lastdroppableweapon))
					{
						self switchtoweapon(self.lastdroppableweapon);
					}
					else
					{
						self switchtoweapon();
					}
					return 1;
				}
				if(isdefined(immediate) && immediate)
				{
					self switchtoweaponimmediate(self.lastnonkillstreakweapon);
				}
				else
				{
					self switchtoweapon(self.lastnonkillstreakweapon);
				}
			}
			else
			{
				if(isdefined(self.lastdroppableweapon) && self hasweapon(self.lastdroppableweapon))
				{
					self switchtoweapon(self.lastdroppableweapon);
				}
				else
				{
					return 0;
				}
			}
		}
	}
	return 1;
}

/*
	Name: get_killstreak_weapon
	Namespace: killstreaks
	Checksum: 0x75EBAF3C
	Offset: 0x720
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function get_killstreak_weapon(killstreak)
{
	if(!isdefined(killstreak))
	{
		return level.weaponnone;
	}
	/#
		assert(isdefined(level.killstreaks[killstreak]));
	#/
	return level.killstreaks[killstreak].weapon;
}

/*
	Name: isheldinventorykillstreakweapon
	Namespace: killstreaks
	Checksum: 0x5DE9E384
	Offset: 0x788
	Size: 0x40
	Parameters: 1
	Flags: None
*/
function isheldinventorykillstreakweapon(killstreakweapon)
{
	switch(killstreakweapon.name)
	{
		case "inventory_m32":
		case "inventory_minigun":
		{
			return true;
		}
	}
	return false;
}

/*
	Name: waitfortimecheck
	Namespace: killstreaks
	Checksum: 0xBD76A1DC
	Offset: 0x7D0
	Size: 0xA0
	Parameters: 5
	Flags: None
*/
function waitfortimecheck(duration, callback, endcondition1, endcondition2, endcondition3)
{
	self endon(#"hacked");
	if(isdefined(endcondition1))
	{
		self endon(endcondition1);
	}
	if(isdefined(endcondition2))
	{
		self endon(endcondition2);
	}
	if(isdefined(endcondition3))
	{
		self endon(endcondition3);
	}
	hostmigration::migrationawarewait(duration);
	self notify(#"time_check");
	self [[callback]]();
}

/*
	Name: emp_isempd
	Namespace: killstreaks
	Checksum: 0xFA99EBE9
	Offset: 0x878
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function emp_isempd()
{
	if(isdefined(level.enemyempactivefunc))
	{
		return self [[level.enemyempactivefunc]]();
	}
	return 0;
}

/*
	Name: waittillemp
	Namespace: killstreaks
	Checksum: 0xC745D97B
	Offset: 0x8A8
	Size: 0x62
	Parameters: 2
	Flags: None
*/
function waittillemp(onempdcallback, arg)
{
	self endon(#"death");
	self endon(#"delete");
	self waittill(#"emp_deployed", attacker);
	if(isdefined(onempdcallback))
	{
		[[onempdcallback]](attacker, arg);
	}
}

/*
	Name: hasuav
	Namespace: killstreaks
	Checksum: 0x3049658
	Offset: 0x918
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function hasuav(team_or_entnum)
{
	return level.activeuavs[team_or_entnum] > 0;
}

/*
	Name: hassatellite
	Namespace: killstreaks
	Checksum: 0xFCC02B24
	Offset: 0x940
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function hassatellite(team_or_entnum)
{
	return level.activesatellites[team_or_entnum] > 0;
}

/*
	Name: destroyotherteamsequipment
	Namespace: killstreaks
	Checksum: 0x41F4F010
	Offset: 0x968
	Size: 0x114
	Parameters: 2
	Flags: None
*/
function destroyotherteamsequipment(attacker, weapon)
{
	foreach(team in level.teams)
	{
		if(team == attacker.team)
		{
			continue;
		}
		destroyequipment(attacker, team, weapon);
		destroytacticalinsertions(attacker, team);
	}
	destroyequipment(attacker, "free", weapon);
	destroytacticalinsertions(attacker, "free");
}

/*
	Name: destroyequipment
	Namespace: killstreaks
	Checksum: 0xE4EBF8E7
	Offset: 0xA88
	Size: 0x18E
	Parameters: 3
	Flags: Linked
*/
function destroyequipment(attacker, team, weapon)
{
	for(i = 0; i < level.missileentities.size; i++)
	{
		item = level.missileentities[i];
		if(!isdefined(item.weapon))
		{
			continue;
		}
		if(!isdefined(item.owner))
		{
			continue;
		}
		if(isdefined(team) && item.owner.team != team)
		{
			continue;
		}
		else if(item.owner == attacker)
		{
			continue;
		}
		if(!item.weapon.isequipment && (!(isdefined(item.destroyedbyemp) && item.destroyedbyemp)))
		{
			continue;
		}
		watcher = item.owner weaponobjects::getwatcherforweapon(item.weapon);
		if(!isdefined(watcher))
		{
			continue;
		}
		watcher thread weaponobjects::waitanddetonate(item, 0, attacker, weapon);
	}
}

/*
	Name: destroytacticalinsertions
	Namespace: killstreaks
	Checksum: 0x6141162A
	Offset: 0xC20
	Size: 0xC6
	Parameters: 2
	Flags: Linked
*/
function destroytacticalinsertions(attacker, victimteam)
{
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(!isdefined(player.tacticalinsertion))
		{
			continue;
		}
		if(level.teambased && player.team != victimteam)
		{
			continue;
		}
		if(attacker == player)
		{
			continue;
		}
		player.tacticalinsertion thread tacticalinsertion::fizzle();
	}
}

/*
	Name: destroyotherteamsactivevehicles
	Namespace: killstreaks
	Checksum: 0xC960BA72
	Offset: 0xCF0
	Size: 0xD4
	Parameters: 2
	Flags: None
*/
function destroyotherteamsactivevehicles(attacker, weapon)
{
	foreach(team in level.teams)
	{
		if(team == attacker.team)
		{
			continue;
		}
		destroyactivevehicles(attacker, team, weapon);
	}
	destroyneutralgameplayvehicles(attacker, weapon);
}

/*
	Name: destroyneutralgameplayvehicles
	Namespace: killstreaks
	Checksum: 0xA41E5E06
	Offset: 0xDD0
	Size: 0x1D2
	Parameters: 2
	Flags: Linked
*/
function destroyneutralgameplayvehicles(attacker, weapon)
{
	script_vehicles = getentarray("script_vehicle", "classname");
	foreach(vehicle in script_vehicles)
	{
		if(isvehicle(vehicle) && (!isdefined(vehicle.team) || vehicle.team == "neutral"))
		{
			if(isdefined(vehicle.detonateviaemp) && (isdefined(weapon.isempkillstreak) && weapon.isempkillstreak))
			{
				vehicle [[vehicle.detonateviaemp]](attacker, weapon);
			}
			if(isdefined(vehicle.archetype))
			{
				if(vehicle.archetype == "siegebot")
				{
					vehicle dodamage(vehicle.health + 1, vehicle.origin, attacker, attacker, "", "MOD_EXPLOSIVE", 0, weapon);
				}
			}
		}
	}
}

/*
	Name: destroyactivevehicles
	Namespace: killstreaks
	Checksum: 0x853A25CD
	Offset: 0xFB0
	Size: 0x984
	Parameters: 3
	Flags: Linked
*/
function destroyactivevehicles(attacker, team, weapon)
{
	targets = target_getarray();
	destroyentities(targets, attacker, team, weapon);
	ai_tanks = getentarray("talon", "targetname");
	destroyentities(ai_tanks, attacker, team, weapon);
	remotemissiles = getentarray("remote_missile", "targetname");
	destroyentities(remotemissiles, attacker, team, weapon);
	remotedrone = getentarray("remote_drone", "targetname");
	destroyentities(remotedrone, attacker, team, weapon);
	script_vehicles = getentarray("script_vehicle", "classname");
	foreach(vehicle in script_vehicles)
	{
		if(isdefined(team) && vehicle.team == team && isvehicle(vehicle))
		{
			if(isdefined(vehicle.detonateviaemp) && (isdefined(weapon.isempkillstreak) && weapon.isempkillstreak))
			{
				vehicle [[vehicle.detonateviaemp]](attacker, weapon);
			}
			if(isdefined(vehicle.archetype))
			{
				if(vehicle.archetype == "raps")
				{
					vehicle raps::detonate(attacker);
					continue;
				}
				if(vehicle.archetype == "turret" || vehicle.archetype == "rcbomb" || vehicle.archetype == "wasp" || vehicle.archetype == "siegebot")
				{
					vehicle dodamage(vehicle.health + 1, vehicle.origin, attacker, attacker, "", "MOD_EXPLOSIVE", 0, weapon);
				}
			}
		}
	}
	planemortars = getentarray("plane_mortar", "targetname");
	foreach(planemortar in planemortars)
	{
		if(isdefined(team) && isdefined(planemortar.team))
		{
			if(planemortar.team != team)
			{
				continue;
			}
		}
		else if(planemortar.owner == attacker)
		{
			continue;
		}
		planemortar notify(#"emp_deployed", attacker);
	}
	dronestrikes = getentarray("drone_strike", "targetname");
	foreach(dronestrike in dronestrikes)
	{
		if(isdefined(team) && isdefined(dronestrike.team))
		{
			if(dronestrike.team != team)
			{
				continue;
			}
		}
		else if(dronestrike.owner == attacker)
		{
			continue;
		}
		dronestrike notify(#"emp_deployed", attacker);
	}
	counteruavs = getentarray("counteruav", "targetname");
	foreach(counteruav in counteruavs)
	{
		if(isdefined(team) && isdefined(counteruav.team))
		{
			if(counteruav.team != team)
			{
				continue;
			}
		}
		else if(counteruav.owner == attacker)
		{
			continue;
		}
		counteruav notify(#"emp_deployed", attacker);
	}
	satellites = getentarray("satellite", "targetname");
	foreach(satellite in satellites)
	{
		if(isdefined(team) && isdefined(satellite.team))
		{
			if(satellite.team != team)
			{
				continue;
			}
		}
		else if(satellite.owner == attacker)
		{
			continue;
		}
		satellite notify(#"emp_deployed", attacker);
	}
	robots = getaiarchetypearray("robot");
	foreach(robot in robots)
	{
		if(robot.allowdeath !== 0 && robot.magic_bullet_shield !== 1 && isdefined(team) && robot.team == team)
		{
			if(isdefined(attacker) && (!isdefined(robot.owner) || robot.owner util::isenemyplayer(attacker)))
			{
				scoreevents::processscoreevent("destroyed_combat_robot", attacker, robot.owner, weapon);
				luinotifyevent(&"player_callout", 2, &"KILLSTREAK_DESTROYED_COMBAT_ROBOT", attacker.entnum);
			}
			robot kill();
		}
	}
	if(isdefined(level.missile_swarm_owner))
	{
		if(level.missile_swarm_owner util::isenemyplayer(attacker))
		{
			level.missile_swarm_owner notify(#"emp_destroyed_missile_swarm", attacker);
		}
	}
}

/*
	Name: destroyentities
	Namespace: killstreaks
	Checksum: 0xEA6A148
	Offset: 0x1940
	Size: 0x1BA
	Parameters: 4
	Flags: Linked
*/
function destroyentities(entities, attacker, team, weapon)
{
	meansofdeath = "MOD_EXPLOSIVE";
	damage = 5000;
	direction_vec = (0, 0, 0);
	point = (0, 0, 0);
	modelname = "";
	tagname = "";
	partname = "";
	foreach(entity in entities)
	{
		if(isdefined(team) && isdefined(entity.team))
		{
			if(entity.team != team)
			{
				continue;
			}
		}
		else if(isdefined(entity.owner) && entity.owner == attacker)
		{
			continue;
		}
		entity notify(#"damage", damage, attacker, direction_vec, point, meansofdeath, tagname, modelname, partname, weapon);
	}
}

