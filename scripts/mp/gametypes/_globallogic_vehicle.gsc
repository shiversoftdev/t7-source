// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_vehicle;
#using scripts\mp\gametypes\_globallogic_player;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_weapons;

#namespace globallogic_vehicle;

/*
	Name: callback_vehiclespawned
	Namespace: globallogic_vehicle
	Checksum: 0xD15116A4
	Offset: 0x2D0
	Size: 0xE6
	Parameters: 1
	Flags: Linked
*/
function callback_vehiclespawned(spawner)
{
	self.health = self.healthdefault;
	if(issentient(self))
	{
		self spawner::spawn_think(spawner);
	}
	else
	{
		vehicle::init(self);
	}
	if(isdefined(level.vehicle_main_callback))
	{
		if(isdefined(level.vehicle_main_callback[self.vehicletype]))
		{
			self thread [[level.vehicle_main_callback[self.vehicletype]]]();
		}
		else if(isdefined(self.scriptvehicletype) && isdefined(level.vehicle_main_callback[self.scriptvehicletype]))
		{
			self thread [[level.vehicle_main_callback[self.scriptvehicletype]]]();
		}
	}
}

/*
	Name: callback_vehicledamage
	Namespace: globallogic_vehicle
	Checksum: 0xD70C5827
	Offset: 0x3C0
	Size: 0xCE4
	Parameters: 15
	Flags: Linked
*/
function callback_vehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	selfentnum = self getentitynumber();
	eattackernotself = isdefined(eattacker) && eattacker != self;
	eattackerisnotowner = isdefined(eattacker) && isdefined(self.owner) && eattacker != self.owner;
	trytododamagefeedback = !isdefined(self.nodamagefeedback) || !self.nodamagefeedback;
	if(!1 & idflags)
	{
		idamage = loadout::cac_modified_vehicle_damage(self, eattacker, idamage, smeansofdeath, weapon, einflictor);
	}
	self.idflags = idflags;
	self.idflagstime = gettime();
	if(game["state"] == "postgame")
	{
		self finishvehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname, 0);
		return;
	}
	if(isdefined(eattacker) && isplayer(eattacker) && isdefined(eattacker.candocombat) && !eattacker.candocombat)
	{
		return;
	}
	if(self weapons::should_suppress_damage(weapon, einflictor))
	{
		return;
	}
	if(isdefined(self.overridevehicledamage))
	{
		idamage = self [[self.overridevehicledamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal);
	}
	else if(isdefined(level.overridevehicledamage))
	{
		idamage = self [[level.overridevehicledamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal);
	}
	/#
		assert(isdefined(idamage), "");
	#/
	if(idamage == 0)
	{
		return;
	}
	if(!isdefined(vdir))
	{
		idflags = idflags | 4;
	}
	if(isdefined(self.maxhealth) && self.health == self.maxhealth || !isdefined(self.attackers))
	{
		self.attackers = [];
		self.attackerdata = [];
		self.attackerdamage = [];
	}
	if(weapon == level.weaponnone && isdefined(einflictor))
	{
		if(isdefined(einflictor.targetname) && einflictor.targetname == "explodable_barrel")
		{
			weapon = getweapon("explodable_barrel");
		}
		else if(isdefined(einflictor.destructible_type) && issubstr(einflictor.destructible_type, "vehicle_"))
		{
			weapon = getweapon("destructible_car");
		}
	}
	if(!idflags & 2048)
	{
		if(self isvehicleimmunetodamage(idflags, smeansofdeath, weapon))
		{
			return;
		}
		if(smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_GRENADE")
		{
			idamage = idamage * weapon.vehicleprojectiledamagescalar;
			idamage = int(idamage);
			if(idamage == 0)
			{
				return;
			}
		}
		else if(smeansofdeath == "MOD_GRENADE_SPLASH")
		{
			idamage = idamage * getvehicleunderneathsplashscalar(weapon);
			idamage = int(idamage);
			if(idamage == 0)
			{
				return;
			}
		}
		idamage = idamage * level.vehicledamagescalar;
		idamage = int(idamage);
		if(isplayer(eattacker))
		{
			eattacker.pers["participation"]++;
		}
		if(!isdefined(self.maxhealth))
		{
			self.maxhealth = self.healthdefault;
		}
		prevhealthratio = self.health / self.maxhealth;
		if(isdefined(self.owner) && isplayer(self.owner))
		{
			team = self.owner.pers["team"];
		}
		else
		{
			team = self vehicle::vehicle_get_occupant_team();
		}
		if(level.teambased && isplayer(eattacker) && team == eattacker.pers["team"])
		{
			if(!allowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon))
			{
				return;
			}
			self.lastdamagewasfromenemy = 0;
			self finishvehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname, 0);
		}
		else
		{
			if(!level.hardcoremode && isdefined(self.owner) && isdefined(eattacker) && isdefined(eattacker.owner) && self.owner == eattacker.owner && self != eattacker)
			{
				return;
			}
			if(!level.teambased && isdefined(self.archetype) && self.archetype == "raps")
			{
			}
			else
			{
				if(!level.teambased && isdefined(self.targetname) && self.targetname == "rcbomb")
				{
				}
				else if(isdefined(self.owner) && isdefined(eattacker) && self.owner == eattacker)
				{
					return;
				}
			}
			if(idamage < 1)
			{
				idamage = 1;
			}
			if(issubstr(smeansofdeath, "MOD_GRENADE") && isdefined(einflictor) && isdefined(einflictor.iscooked))
			{
				self.wascooked = gettime();
			}
			else
			{
				self.wascooked = undefined;
			}
			attacker_seat = undefined;
			if(isdefined(eattacker))
			{
				attacker_seat = self getoccupantseat(eattacker);
			}
			self.lastdamagewasfromenemy = isdefined(eattacker) && !isdefined(attacker_seat);
			self globallogic_player::giveattackerandinflictorownerassist(eattacker, einflictor, idamage, smeansofdeath, weapon);
			self finishvehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname, 0);
			if(level.gametype == "hack" && !weapon.isemp)
			{
				idamage = 0;
			}
		}
		if(eattackernotself && (eattackerisnotowner || (isdefined(self.selfdestruct) && !self.selfdestruct) || self.forcedamagefeedback === 1))
		{
			if(trytododamagefeedback)
			{
				dofeedback = 1;
				if(isdefined(self.damagetaken) && isdefined(self.maxhealth) && self.damagetaken > self.maxhealth)
				{
					dofeedback = 0;
				}
				if(isdefined(self.shuttingdown) && self.shuttingdown)
				{
					dofeedback = 0;
				}
				if(dofeedback && damagefeedback::dodamagefeedback(weapon, einflictor))
				{
					if(idamage > 0)
					{
						eattacker thread damagefeedback::update(smeansofdeath, einflictor);
					}
				}
			}
		}
	}
	/#
		if(getdvarint(""))
		{
			println(((((((((("" + self getentitynumber()) + "") + self.health) + "") + eattacker.clientid) + "") + isplayer(einflictor) + "") + idamage) + "") + shitloc);
		}
	#/
	if(1)
	{
		lpselfnum = selfentnum;
		lpselfteam = "";
		lpattackerteam = "";
		if(isplayer(eattacker))
		{
			lpattacknum = eattacker getentitynumber();
			lpattackguid = eattacker getguid();
			lpattackname = eattacker.name;
			lpattackerteam = eattacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackguid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}
		/#
			logprint(((((((((((((((((((("" + lpselfnum) + "") + lpselfteam) + "") + lpattackguid) + "") + lpattacknum) + "") + lpattackerteam) + "") + lpattackname) + "") + weapon.name) + "") + idamage) + "") + smeansofdeath) + "") + shitloc) + "");
		#/
	}
}

/*
	Name: callback_vehicleradiusdamage
	Namespace: globallogic_vehicle
	Checksum: 0x2CB48363
	Offset: 0x10B0
	Size: 0x49C
	Parameters: 13
	Flags: Linked
*/
function callback_vehicleradiusdamage(einflictor, eattacker, idamage, finnerdamage, fouterdamage, idflags, smeansofdeath, weapon, vpoint, fradius, fconeanglecos, vconedir, psoffsettime)
{
	idamage = loadout::cac_modified_vehicle_damage(self, eattacker, idamage, smeansofdeath, weapon, einflictor);
	finnerdamage = loadout::cac_modified_vehicle_damage(self, eattacker, finnerdamage, smeansofdeath, weapon, einflictor);
	fouterdamage = loadout::cac_modified_vehicle_damage(self, eattacker, fouterdamage, smeansofdeath, weapon, einflictor);
	self.idflags = idflags;
	self.idflagstime = gettime();
	if(game["state"] == "postgame")
	{
		return;
	}
	if(isdefined(eattacker) && isplayer(eattacker) && isdefined(eattacker.candocombat) && !eattacker.candocombat)
	{
		return;
	}
	if(isdefined(self.killstreaktype))
	{
		maxhealth = (isdefined(self.maxhealth) ? self.maxhealth : self.health);
		if(!isdefined(maxhealth))
		{
			maxhealth = 200;
		}
		idamage = self killstreaks::ondamageperweapon(self.killstreaktype, eattacker, idamage, idflags, smeansofdeath, weapon, maxhealth, undefined, maxhealth * 0.4, undefined, 0, undefined, 1, 1);
	}
	if(!idflags & 2048)
	{
		if(self isvehicleimmunetodamage(idflags, smeansofdeath, weapon))
		{
			return;
		}
		if(smeansofdeath == "MOD_PROJECTILE_SPLASH" || smeansofdeath == "MOD_GRENADE_SPLASH" || smeansofdeath == "MOD_EXPLOSIVE")
		{
			scalar = weapon.vehicleprojectilesplashdamagescalar;
			idamage = int(idamage * scalar);
			finnerdamage = finnerdamage * scalar;
			fouterdamage = fouterdamage * scalar;
			if(finnerdamage == 0)
			{
				return;
			}
			if(idamage < 1)
			{
				idamage = 1;
			}
		}
		occupant_team = self vehicle::vehicle_get_occupant_team();
		if(level.teambased && isplayer(eattacker) && occupant_team == eattacker.pers["team"])
		{
			if(!allowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon))
			{
				return;
			}
			self.lastdamagewasfromenemy = 0;
			self finishvehicleradiusdamage(einflictor, eattacker, idamage, finnerdamage, fouterdamage, idflags, smeansofdeath, weapon, vpoint, fradius, fconeanglecos, vconedir, psoffsettime);
		}
		else
		{
			if(!level.hardcoremode && isdefined(self.owner) && isdefined(eattacker.owner) && self.owner == eattacker.owner)
			{
				return;
			}
			if(idamage < 1)
			{
				idamage = 1;
			}
			self finishvehicleradiusdamage(einflictor, eattacker, idamage, finnerdamage, fouterdamage, idflags, smeansofdeath, weapon, vpoint, fradius, fconeanglecos, vconedir, psoffsettime);
		}
	}
}

/*
	Name: callback_vehiclekilled
	Namespace: globallogic_vehicle
	Checksum: 0x868BA28D
	Offset: 0x1558
	Size: 0x130
	Parameters: 8
	Flags: Linked
*/
function callback_vehiclekilled(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	if(game["state"] == "postgame" && (!isdefined(self.selfdestruct) || !self.selfdestruct))
	{
		if(isdefined(self.overridevehicledeathpostgame))
		{
			self [[self.overridevehicledeathpostgame]](einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime);
		}
		return;
	}
	if(isdefined(self.overridevehiclekilled))
	{
		self [[self.overridevehiclekilled]](einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime);
	}
	if(isdefined(self.overridevehicledeath))
	{
		self [[self.overridevehicledeath]](einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime);
	}
}

/*
	Name: vehiclecrush
	Namespace: globallogic_vehicle
	Checksum: 0x594E8B52
	Offset: 0x1690
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function vehiclecrush()
{
	self endon(#"disconnect");
	if(isdefined(level._effect) && isdefined(level._effect["tanksquish"]))
	{
		playfx(level._effect["tanksquish"], self.origin + vectorscale((0, 0, 1), 30));
	}
	self playsound("chr_crunch");
}

/*
	Name: getvehicleunderneathsplashscalar
	Namespace: globallogic_vehicle
	Checksum: 0x9723BDF7
	Offset: 0x1728
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function getvehicleunderneathsplashscalar(weapon)
{
	if(isdefined(self) && isdefined(self.ignore_vehicle_underneath_splash_scalar))
	{
		return 1;
	}
	if(weapon.name == "satchel_charge")
	{
		scale = 10;
		scale = scale * 3;
	}
	else
	{
		scale = 1;
	}
	return scale;
}

/*
	Name: allowfriendlyfiredamage
	Namespace: globallogic_vehicle
	Checksum: 0x7B420C5D
	Offset: 0x17B0
	Size: 0x52
	Parameters: 4
	Flags: Linked
*/
function allowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon)
{
	if(isdefined(self.allowfriendlyfiredamageoverride))
	{
		return [[self.allowfriendlyfiredamageoverride]](einflictor, eattacker, smeansofdeath, weapon);
	}
	return 0;
}

