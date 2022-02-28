// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_challenges;
#using scripts\cp\_scoreevents;
#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_weapons;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace globallogic_vehicle;

/*
	Name: callback_vehiclespawned
	Namespace: globallogic_vehicle
	Checksum: 0x85850157
	Offset: 0x428
	Size: 0x2F4
	Parameters: 1
	Flags: Linked
*/
function callback_vehiclespawned(spawner)
{
	self.health = self.healthdefault;
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
	if(isdefined(level.a_vehicle_types))
	{
		if(isdefined(level.a_vehicle_types[self.vehicletype]))
		{
			foreach(func in level.a_vehicle_types[self.vehicletype])
			{
				util::single_thread(self, func["function"], func["param1"], func["param2"], func["param3"], func["param4"]);
			}
		}
	}
	if(isdefined(level.a_vehicle_targetnames))
	{
		if(isdefined(spawner))
		{
			str_targetname = spawner.targetname;
		}
		else
		{
			str_targetname = self.targetname;
		}
		if(isdefined(str_targetname) && isdefined(level.a_vehicle_targetnames[str_targetname]))
		{
			foreach(func in level.a_vehicle_targetnames[str_targetname])
			{
				util::single_thread(self, func["function"], func["param1"], func["param2"], func["param3"], func["param4"]);
			}
		}
	}
	if(issentient(self))
	{
		self spawner::spawn_think(spawner);
	}
	else
	{
		vehicle::init(self);
	}
}

/*
	Name: disabledamagefx
	Namespace: globallogic_vehicle
	Checksum: 0x3C102CB4
	Offset: 0x728
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function disabledamagefx()
{
	self endon(#"death");
	wait(0.05);
	self clientfield::set_to_player("toggle_dnidamagefx", 0);
}

/*
	Name: callback_vehicledamage
	Namespace: globallogic_vehicle
	Checksum: 0x64499D27
	Offset: 0x768
	Size: 0xFAC
	Parameters: 15
	Flags: Linked
*/
function callback_vehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	params = spawnstruct();
	params.einflictor = einflictor;
	params.eattacker = eattacker;
	params.idamage = idamage;
	params.idflags = idflags;
	params.smeansofdeath = smeansofdeath;
	params.weapon = weapon;
	params.vpoint = vpoint;
	params.vdir = vdir;
	params.shitloc = shitloc;
	params.vdamageorigin = vdamageorigin;
	params.psoffsettime = psoffsettime;
	params.damagefromunderneath = damagefromunderneath;
	params.modelindex = modelindex;
	params.partname = partname;
	params.vsurfacenormal = vsurfacenormal;
	if(game["state"] == "postgame")
	{
		return;
	}
	if(isdefined(eattacker) && isplayer(eattacker) && isdefined(eattacker.candocombat) && !eattacker.candocombat)
	{
		return;
	}
	if(!1 & idflags)
	{
		idamage = loadout::cac_modified_vehicle_damage(self, eattacker, idamage, smeansofdeath, weapon, einflictor);
	}
	self.idflags = idflags;
	self.idflagstime = gettime();
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
	if(issentient(self))
	{
		self callback::callback(#"hash_eb4a4369", params);
		self thread globallogic_player::trackattackerdamage(eattacker, idamage, smeansofdeath, weapon);
	}
	self callback::callback(#"hash_9bd1e27f", params);
	if(!idflags & 2048)
	{
		if(smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_GRENADE")
		{
			idamage = idamage * weapon.vehicleprojectiledamagescalar;
			idamage = int(idamage);
		}
		else if(smeansofdeath == "MOD_GRENADE_SPLASH")
		{
			idamage = idamage * getvehicleunderneathsplashscalar(weapon);
			idamage = int(idamage);
		}
		idamage = idamage * level.vehicledamagescalar;
		idamage = idamage * self getvehdamagemultiplier(smeansofdeath);
		idamage = int(idamage);
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
		if(isdefined(level.cybercom) && isdefined(isdefined(level.cybercom.overrideactordamage)))
		{
			idamage = self [[level.cybercom.overridevehicledamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal);
		}
		if(idamage == 0)
		{
			return;
		}
		idamage = int(idamage);
		if(self isvehicleimmunetodamage(idflags, smeansofdeath, weapon))
		{
			return;
		}
		if(isdefined(eattacker) && isplayer(eattacker))
		{
			eattacker.pers["participation"]++;
		}
		prevhealthratio = self.health / self.maxhealth;
		driver = self getseatoccupant(0);
		if(isplayer(driver) && driver isremotecontrolling())
		{
			damagepct = idamage / self.maxhealth;
			damagepct = int(max(damagepct, 3));
			driver addtodamageindicator(damagepct, vdir);
		}
		occupant_team = self vehicle::vehicle_get_occupant_team();
		if(level.teambased && isdefined(eattacker) && occupant_team == eattacker.team && occupant_team != "free")
		{
			damageteammates = 1;
			if(level.friendlyfire == 0)
			{
				if(!allowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon))
				{
					return;
				}
			}
			else
			{
				if(level.friendlyfire == 1)
				{
					damageteammates = 0;
				}
				else
				{
					if(level.friendlyfire == 2)
					{
						if(!allowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon))
						{
							return;
						}
					}
					else if(level.friendlyfire == 3)
					{
						idamage = int(idamage * 0.5);
						damageteammates = 0;
					}
				}
			}
			if(idamage < 1)
			{
				idamage = 1;
			}
			self.lastdamagewasfromenemy = 0;
			self globallogic_player::giveattackerandinflictorownerassist(eattacker, einflictor, idamage, smeansofdeath, weapon);
			self finishvehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname, damageteammates);
		}
		else
		{
			if(!level.hardcoremode && isdefined(self.owner) && isdefined(eattacker) && isdefined(eattacker.owner) && self.owner == eattacker.owner)
			{
				return;
			}
			if(!level.teambased && isdefined(self.targetname) && self.targetname == "rcbomb")
			{
			}
			else if(isdefined(self.owner) && isdefined(eattacker) && self.owner == eattacker)
			{
				return;
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
		if(isdefined(eattacker) && eattacker != self)
		{
			if(damagefeedback::dodamagefeedback(weapon, einflictor))
			{
				if(idamage > 0)
				{
					eattacker thread damagefeedback::update(smeansofdeath, einflictor);
					if(issentient(self) && isplayer(eattacker) && isdefined(einflictor) && (eattacker === einflictor || !isvehicle(einflictor)) && (!isdefined(smeansofdeath) || smeansofdeath != "MOD_MELEE_WEAPON_BUTT"))
					{
						eattacker.hits++;
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
		lpselfnum = self getentitynumber();
		lpselfteam = "";
		lpattackerteam = "";
		if(isplayer(eattacker))
		{
			lpattacknum = eattacker getentitynumber();
			lpattackguid = eattacker getguid();
			lpattackname = eattacker.name;
			lpattackerteam = eattacker.pers["team"];
			self thread challenges::vehicledamaged(eattacker, eattacker, idamage, weapon, shitloc);
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
	Checksum: 0xA11B5469
	Offset: 0x1720
	Size: 0x4A4
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
	friendly = 0;
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
		if(level.teambased && isdefined(eattacker) && occupant_team == eattacker.team && occupant_team != "free")
		{
			if(level.friendlyfire == 0)
			{
				if(!allowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon))
				{
					return;
				}
			}
			else
			{
				if(level.friendlyfire == 1)
				{
				}
				else
				{
					if(level.friendlyfire == 2)
					{
						if(!allowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon))
						{
							return;
						}
					}
					else if(level.friendlyfire == 3)
					{
						idamage = int(idamage * 0.5);
					}
				}
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
	Checksum: 0xAD045EF
	Offset: 0x1BD0
	Size: 0x47C
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
	if(game["state"] == "postgame")
	{
		return;
	}
	eattacker = globallogic_player::figureoutattacker(eattacker);
	if(isdefined(eattacker) && isplayer(eattacker))
	{
		globallogic_score::inctotalkills(eattacker.team);
		eattacker thread globallogic_score::givekillstats(smeansofdeath, weapon, self);
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
	if(issentient(self))
	{
		self callback::callback(#"hash_fc2ec5ff", params);
	}
	self callback::callback(#"hash_acb66515", params);
	if(isdefined(self.overridevehiclekilled))
	{
		self [[self.overridevehiclekilled]](einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime);
	}
	player = eattacker;
	if(eattacker.classname == "script_vehicle" && isdefined(eattacker.owner))
	{
		player = eattacker.owner;
	}
	if(isdefined(player) && isplayer(player) && (!(isdefined(self.disable_score_events) && self.disable_score_events)))
	{
		if(!level.teambased || self.team != player.pers["team"])
		{
			if(smeansofdeath == "MOD_MELEE" || smeansofdeath == "MOD_MELEE_ASSASSINATE")
			{
				scoreevents::processscoreevent("melee_kill" + self.scoretype, player, self, weapon);
			}
			else
			{
				scoreevents::processscoreevent("kill" + self.scoretype, player, self, weapon);
			}
			self thread challenges::vehiclekilled(einflictor, player, idamage, smeansofdeath, weapon, shitloc);
			self vehiclekilled_awardassists(einflictor, eattacker, weapon, eattacker.team);
		}
	}
}

/*
	Name: vehiclecrush
	Namespace: globallogic_vehicle
	Checksum: 0xF0523CD7
	Offset: 0x2058
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
	Checksum: 0xA247001F
	Offset: 0x20F0
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
	Checksum: 0x10F08E10
	Offset: 0x2160
	Size: 0x6E
	Parameters: 4
	Flags: Linked
*/
function allowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon)
{
	if(isdefined(self.skipfriendlyfirecheck) && self.skipfriendlyfirecheck)
	{
		return 1;
	}
	if(isdefined(self.allowfriendlyfiredamageoverride))
	{
		return [[self.allowfriendlyfiredamageoverride]](einflictor, eattacker, smeansofdeath, weapon);
	}
	return 0;
}

/*
	Name: vehiclekilled_awardassists
	Namespace: globallogic_vehicle
	Checksum: 0x850DE047
	Offset: 0x21D8
	Size: 0x164
	Parameters: 4
	Flags: Linked
*/
function vehiclekilled_awardassists(einflictor, eattacker, weapon, lpattackteam)
{
	pixbeginevent("VehicleKilled assists");
	if(isdefined(self.attackers))
	{
		for(j = 0; j < self.attackers.size; j++)
		{
			player = self.attackers[j];
			if(!isdefined(player))
			{
				continue;
			}
			if(player == eattacker)
			{
				continue;
			}
			if(player.team != lpattackteam)
			{
				continue;
			}
			damage_done = self.attackerdamage[player.clientid].damage;
			player thread globallogic_score::processassist(self, damage_done, self.attackerdamage[player.clientid].weapon, "assist" + self.scoretype);
		}
	}
	pixendevent();
}

