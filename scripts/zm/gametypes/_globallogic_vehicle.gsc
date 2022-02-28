// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\gametypes\_damagefeedback;
#using scripts\zm\gametypes\_globallogic_player;
#using scripts\zm\gametypes\_weapons;

#namespace globallogic_vehicle;

/*
	Name: callback_vehiclespawned
	Namespace: globallogic_vehicle
	Checksum: 0xC7E5A907
	Offset: 0x288
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function callback_vehiclespawned(spawner)
{
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
	if(issentient(self))
	{
		self spawner::spawn_think(spawner);
	}
}

/*
	Name: callback_vehicledamage
	Namespace: globallogic_vehicle
	Checksum: 0x986E2BDD
	Offset: 0x350
	Size: 0xD4C
	Parameters: 15
	Flags: Linked
*/
function callback_vehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
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
	if(!isdefined(vdir))
	{
		idflags = idflags | level.idflags_no_knockback;
	}
	friendly = 0;
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
	if(!idflags & level.idflags_no_protection)
	{
		if(self isvehicleimmunetodamage(idflags, smeansofdeath, weapon))
		{
			if(isdefined(self.overridevehicledamage))
			{
				idamage = self [[self.overridevehicledamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal);
			}
			else if(isdefined(level.overridevehicledamage))
			{
				idamage = self [[level.overridevehicledamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal);
			}
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
		idamage = idamage * self getvehdamagemultiplier(smeansofdeath);
		idamage = int(idamage);
		if(isplayer(eattacker))
		{
			eattacker.pers["participation"]++;
		}
		if(!isdefined(self.maxhealth))
		{
			self.maxhealth = self.healthdefault;
		}
		if(isdefined(self.overridevehicledamage))
		{
			idamage = self [[self.overridevehicledamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal);
		}
		else if(isdefined(level.overridevehicledamage))
		{
			idamage = self [[level.overridevehicledamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal);
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
			if(level.friendlyfire == 0)
			{
				if(!allowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon))
				{
					return;
				}
				if(idamage < 1)
				{
					idamage = 1;
				}
				self.lastdamagewasfromenemy = 0;
				self finishvehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname, 1);
			}
			else
			{
				if(level.friendlyfire == 1)
				{
					if(idamage < 1)
					{
						idamage = 1;
					}
					self.lastdamagewasfromenemy = 0;
					self finishvehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname, 0);
				}
				else
				{
					if(level.friendlyfire == 2)
					{
						if(!allowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon))
						{
							return;
						}
						if(idamage < 1)
						{
							idamage = 1;
						}
						self.lastdamagewasfromenemy = 0;
						self finishvehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname, 1);
					}
					else if(level.friendlyfire == 3)
					{
						idamage = int(idamage * 0.5);
						if(idamage < 1)
						{
							idamage = 1;
						}
						self.lastdamagewasfromenemy = 0;
						self finishvehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname, 0);
					}
				}
			}
			friendly = 1;
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
			if(idamage < 1 && (!(isdefined(level.bzm_worldpaused) && level.bzm_worldpaused)))
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
			self finishvehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname, 0);
			if(level.gametype == "hack" && !weapon.isemp)
			{
				idamage = 0;
			}
		}
		if(isdefined(eattacker) && eattacker != self)
		{
			if(damagefeedback::dodamagefeedback(weapon, einflictor))
			{
				if(idamage > 0)
				{
					eattacker thread damagefeedback::update(smeansofdeath, einflictor);
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
		lpselfnum = self getentitynumber();
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
		logprint(((((((((((((((((((("VD;" + lpselfnum) + ";") + lpselfteam) + ";") + lpattackguid) + ";") + lpattacknum) + ";") + lpattackerteam) + ";") + lpattackname) + ";") + weapon.name) + ";") + idamage) + ";") + smeansofdeath) + ";") + shitloc) + "\n");
	}
}

/*
	Name: callback_vehicleradiusdamage
	Namespace: globallogic_vehicle
	Checksum: 0xF7C4AEBC
	Offset: 0x10A8
	Size: 0x5DC
	Parameters: 13
	Flags: Linked
*/
function callback_vehicleradiusdamage(einflictor, eattacker, idamage, finnerdamage, fouterdamage, idflags, smeansofdeath, weapon, vpoint, fradius, fconeanglecos, vconedir, psoffsettime)
{
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
	friendly = 0;
	if(!idflags & level.idflags_no_protection)
	{
		if(self isvehicleimmunetodamage(idflags, smeansofdeath, weapon))
		{
			return;
		}
		if(isdefined(self.overridevehicleradiusdamage))
		{
			idamage = self [[self.overridevehicleradiusdamage]](einflictor, eattacker, idamage, finnerdamage, fouterdamage, idflags, smeansofdeath, weapon, vpoint, fradius, fconeanglecos, vconedir, psoffsettime);
		}
		else if(isdefined(level.overridevehicleradiusdamage))
		{
			idamage = self [[level.overridevehicleradiusdamage]](einflictor, eattacker, idamage, finnerdamage, fouterdamage, idflags, smeansofdeath, weapon, vpoint, fradius, fconeanglecos, vconedir, psoffsettime);
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
			if(level.friendlyfire == 0)
			{
				if(!allowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon))
				{
					return;
				}
				if(idamage < 1)
				{
					idamage = 1;
				}
				self.lastdamagewasfromenemy = 0;
				self finishvehicleradiusdamage(einflictor, eattacker, idamage, finnerdamage, fouterdamage, idflags, smeansofdeath, weapon, vpoint, fradius, fconeanglecos, vconedir, psoffsettime);
			}
			else
			{
				if(level.friendlyfire == 1)
				{
					if(idamage < 1)
					{
						idamage = 1;
					}
					self.lastdamagewasfromenemy = 0;
					self finishvehicleradiusdamage(einflictor, eattacker, idamage, finnerdamage, fouterdamage, idflags, smeansofdeath, weapon, vpoint, fradius, fconeanglecos, vconedir, psoffsettime);
				}
				else
				{
					if(level.friendlyfire == 2)
					{
						if(!allowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon))
						{
							return;
						}
						if(idamage < 1)
						{
							idamage = 1;
						}
						self.lastdamagewasfromenemy = 0;
						self finishvehicleradiusdamage(einflictor, eattacker, idamage, finnerdamage, fouterdamage, idflags, smeansofdeath, weapon, vpoint, fradius, fconeanglecos, vconedir, psoffsettime);
					}
					else if(level.friendlyfire == 3)
					{
						idamage = int(idamage * 0.5);
						if(idamage < 1)
						{
							idamage = 1;
						}
						self.lastdamagewasfromenemy = 0;
						self finishvehicleradiusdamage(einflictor, eattacker, idamage, finnerdamage, fouterdamage, idflags, smeansofdeath, weapon, vpoint, fradius, fconeanglecos, vconedir, psoffsettime);
					}
				}
			}
			friendly = 1;
		}
		else
		{
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
	Checksum: 0x971E7C9F
	Offset: 0x1690
	Size: 0x248
	Parameters: 8
	Flags: Linked
*/
function callback_vehiclekilled(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	params = spawnstruct();
	params.einflictor = einflictor;
	params.eattacker = eattacker;
	params.idamage = idamage;
	params.smeansofdeath = smeansofdeath;
	params.weapon = weapon;
	params.vdir = vdir;
	params.shitloc = shitloc;
	params.psoffsettime = psoffsettime;
	self.str_damagemod = smeansofdeath;
	self.w_damage = weapon;
	if(game["state"] == "postgame")
	{
		return;
	}
	if(isai(eattacker) && isdefined(eattacker.script_owner))
	{
		if(eattacker.script_owner.team != self.team)
		{
			eattacker = eattacker.script_owner;
		}
	}
	if(isdefined(eattacker) && isdefined(eattacker.onkill))
	{
		eattacker [[eattacker.onkill]](self);
	}
	if(isdefined(einflictor))
	{
		self.damageinflictor = einflictor;
	}
	self callback::callback(#"hash_acb66515", params);
	if(isdefined(self.overridevehiclekilled))
	{
		self [[self.overridevehiclekilled]](einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime);
	}
}

/*
	Name: vehiclecrush
	Namespace: globallogic_vehicle
	Checksum: 0x4804548D
	Offset: 0x18E0
	Size: 0x8C
	Parameters: 0
	Flags: None
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
	Checksum: 0xC22F7914
	Offset: 0x1978
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function getvehicleunderneathsplashscalar(weapon)
{
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
	Checksum: 0x65DB527E
	Offset: 0x19E8
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

