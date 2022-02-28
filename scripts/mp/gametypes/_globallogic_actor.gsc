// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_challenges;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_player;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\shared\_burnplayer;
#using scripts\shared\abilities\gadgets\_gadget_clone;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\weapons\_weapon_utils;

#namespace globallogic_actor;

/*
	Name: init
	Namespace: globallogic_actor
	Checksum: 0x99EC1590
	Offset: 0x390
	Size: 0x4
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
}

/*
	Name: callback_actorspawned
	Namespace: globallogic_actor
	Checksum: 0xAF0BB128
	Offset: 0x3A0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function callback_actorspawned(spawner)
{
	self thread spawner::spawn_think(spawner);
}

/*
	Name: callback_actordamage
	Namespace: globallogic_actor
	Checksum: 0xBB7D9B4C
	Offset: 0x3D0
	Size: 0xC44
	Parameters: 15
	Flags: Linked
*/
function callback_actordamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, modelindex, surfacetype, vsurfacenormal)
{
	if(game["state"] == "postgame")
	{
		return;
	}
	if(self.team == "spectator")
	{
		return;
	}
	if(isdefined(eattacker) && isplayer(eattacker) && isdefined(eattacker.candocombat) && !eattacker.candocombat)
	{
		return;
	}
	self.idflags = idflags;
	self.idflagstime = gettime();
	eattacker = globallogic_player::figure_out_attacker(eattacker);
	if(!isdefined(vdir))
	{
		idflags = idflags | 4;
	}
	friendly = 0;
	if(self.health == self.maxhealth || !isdefined(self.attackers))
	{
		self.attackers = [];
		self.attackerdata = [];
		self.attackerdamage = [];
		self.attackersthisspawn = [];
	}
	if(globallogic_utils::isheadshot(weapon, shitloc, smeansofdeath, einflictor) && !weapon_utils::ismeleemod(smeansofdeath))
	{
		smeansofdeath = "MOD_HEAD_SHOT";
	}
	if(level.onlyheadshots)
	{
		if(smeansofdeath == "MOD_PISTOL_BULLET" || smeansofdeath == "MOD_RIFLE_BULLET")
		{
			return;
		}
		if(smeansofdeath == "MOD_HEAD_SHOT")
		{
			idamage = 150;
		}
	}
	if(isdefined(self.overrideactordamage))
	{
		idamage = self [[self.overrideactordamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, modelindex);
	}
	friendlyfire = [[level.figure_out_friendly_fire]](self);
	if(friendlyfire == 0 && self.archetype === "robot" && isdefined(eattacker) && eattacker.team === self.team)
	{
		return;
	}
	if(isdefined(self.aioverridedamage))
	{
		for(index = 0; index < self.aioverridedamage.size; index++)
		{
			damagecallback = self.aioverridedamage[index];
			idamage = self [[damagecallback]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, modelindex);
		}
		if(idamage < 1)
		{
			return;
		}
		idamage = int(idamage + 0.5);
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
		if(isplayer(eattacker))
		{
			eattacker.pers["participation"]++;
		}
		prevhealthratio = self.health / self.maxhealth;
		isshootingownclone = 0;
		if(isdefined(self.isaiclone) && self.isaiclone && isplayer(eattacker) && self.owner == eattacker)
		{
			isshootingownclone = 1;
		}
		if(level.teambased && isplayer(eattacker) && self != eattacker && self.team == eattacker.pers["team"] && !isshootingownclone)
		{
			friendlyfire = [[level.figure_out_friendly_fire]](self);
			if(friendlyfire == 0)
			{
				return;
			}
			if(friendlyfire == 1)
			{
				if(idamage < 1)
				{
					idamage = 1;
				}
				self.lastdamagewasfromenemy = 0;
				self globallogic_player::giveattackerandinflictorownerassist(eattacker, einflictor, idamage, smeansofdeath, weapon);
				self finishactordamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, surfacetype, vsurfacenormal);
			}
			else
			{
				if(friendlyfire == 2)
				{
					return;
				}
				if(friendlyfire == 3)
				{
					idamage = int(idamage * 0.5);
					if(idamage < 1)
					{
						idamage = 1;
					}
					self.lastdamagewasfromenemy = 0;
					self globallogic_player::giveattackerandinflictorownerassist(eattacker, einflictor, idamage, smeansofdeath, weapon);
					self finishactordamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, surfacetype, vsurfacenormal);
				}
			}
			friendly = 1;
		}
		else
		{
			if(isdefined(eattacker) && isdefined(self.script_owner) && eattacker == self.script_owner && !level.hardcoremode && !isshootingownclone)
			{
				return;
			}
			if(isdefined(eattacker) && isdefined(self.script_owner) && isdefined(eattacker.script_owner) && eattacker.script_owner == self.script_owner)
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
			self.lastdamagewasfromenemy = isdefined(eattacker) && eattacker != self;
			self globallogic_player::giveattackerandinflictorownerassist(eattacker, einflictor, idamage, smeansofdeath, weapon);
			self finishactordamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, boneindex, surfacetype, vsurfacenormal);
		}
		if(isdefined(eattacker) && eattacker != self)
		{
			if(weapon.name != "artillery" && (!isdefined(einflictor) || !isai(einflictor) || !isdefined(einflictor.controlled) || einflictor.controlled))
			{
				if(idamage > 0 && shitloc !== "riotshield")
				{
					eattacker thread damagefeedback::update(smeansofdeath, einflictor, undefined, weapon, self);
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
		lpselfteam = self.team;
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
			logprint(((((((((((((((((((((("" + lpselfnum) + "") + lpselfteam) + "") + lpattackguid) + "") + lpattacknum) + "") + lpattackerteam) + "") + lpattackname) + "") + weapon.name) + "") + idamage) + "") + smeansofdeath) + "") + shitloc) + "") + boneindex) + "");
		#/
	}
}

/*
	Name: callback_actorkilled
	Namespace: globallogic_actor
	Checksum: 0x9C5BD188
	Offset: 0x1020
	Size: 0x18C
	Parameters: 8
	Flags: Linked
*/
function callback_actorkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	if(game["state"] == "postgame")
	{
		return;
	}
	if(isai(attacker) && isdefined(attacker.script_owner))
	{
		if(attacker.script_owner.team != self.team)
		{
			attacker = attacker.script_owner;
		}
	}
	if(attacker.classname == "script_vehicle" && isdefined(attacker.owner))
	{
		attacker = attacker.owner;
	}
	_gadget_clone::processclonescoreevent(self, attacker, weapon);
	globallogic::doweaponspecifickilleffects(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime);
	globallogic::doweaponspecificcorpseeffects(self, einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime);
}

/*
	Name: callback_actorcloned
	Namespace: globallogic_actor
	Checksum: 0x506A1B49
	Offset: 0x11B8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function callback_actorcloned(original)
{
	destructserverutils::copydestructstate(original, self);
	gibserverutils::copygibstate(original, self);
}

