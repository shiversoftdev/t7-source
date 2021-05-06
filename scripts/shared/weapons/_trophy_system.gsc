// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_weaponobjects;

#using_animtree("mp_trophy_system");

#namespace trophy_system;

/*
	Name: init_shared
	Namespace: trophy_system
	Checksum: 0x534F85DF
	Offset: 0x3F0
	Size: 0x9C
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.trophylongflashfx = "weapon/fx_trophy_flash";
	level.trophydetonationfx = "weapon/fx_trophy_detonation";
	level.fx_trophy_radius_indicator = "weapon/fx_trophy_radius_indicator";
	trophydeployanim = %mp_trophy_system::o_trophy_deploy;
	trophyspinanim = %mp_trophy_system::o_trophy_spin;
	level thread register();
	callback::on_spawned(&createtrophysystemwatcher);
}

/*
	Name: register
	Namespace: trophy_system
	Checksum: 0xC0DB9C85
	Offset: 0x498
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function register()
{
	clientfield::register("missile", "trophy_system_state", 1, 2, "int");
	clientfield::register("scriptmover", "trophy_system_state", 1, 2, "int");
}

/*
	Name: createtrophysystemwatcher
	Namespace: trophy_system
	Checksum: 0x28C00D1D
	Offset: 0x508
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function createtrophysystemwatcher()
{
	if(level.gametype == "infect" && self.team == game["attackers"])
	{
		return;
	}
	watcher = self weaponobjects::createuseweaponobjectwatcher("trophy_system", self.team);
	watcher.ondetonatecallback = &trophysystemdetonate;
	watcher.activatesound = "wpn_claymore_alert";
	watcher.hackable = 1;
	watcher.hackertoolradius = level.equipmenthackertoolradius;
	watcher.hackertooltimems = level.equipmenthackertooltimems;
	watcher.ownergetsassist = 1;
	watcher.ignoredirection = 1;
	watcher.activationdelay = 0.1;
	watcher.headicon = 0;
	watcher.enemydestroy = 1;
	watcher.onspawn = &ontrophysystemspawn;
	watcher.ondamage = &watchtrophysystemdamage;
	watcher.ondestroyed = &ontrophysystemsmashed;
	watcher.onstun = &weaponobjects::weaponstun;
	watcher.stuntime = 1;
}

/*
	Name: ontrophysystemspawn
	Namespace: trophy_system
	Checksum: 0x7607893B
	Offset: 0x6B0
	Size: 0x27C
	Parameters: 2
	Flags: Linked
*/
function ontrophysystemspawn(watcher, player)
{
	player endon(#"death");
	player endon(#"disconnect");
	level endon(#"game_ended");
	self endon(#"death");
	self useanimtree($mp_trophy_system);
	self weaponobjects::onspawnuseweaponobject(watcher, player);
	self.trophysystemstationary = 0;
	movestate = self util::waittillrollingornotmoving();
	if(movestate == "rolling")
	{
		self setanim(%mp_trophy_system::o_trophy_deploy, 1);
		self clientfield::set("trophy_system_state", 1);
		self util::waittillnotmoving();
	}
	self.trophysystemstationary = 1;
	player addweaponstat(self.weapon, "used", 1);
	self.ammo = player ammo_get(self.weapon);
	self thread trophyactive(player);
	self thread trophywatchhack();
	self setanim(%mp_trophy_system::o_trophy_deploy, 0);
	self setanim(%mp_trophy_system::o_trophy_spin, 1);
	self clientfield::set("trophy_system_state", 2);
	self playsound("wpn_trophy_deploy_start");
	self playloopsound("wpn_trophy_spin", 0.25);
	self setreconmodeldeployed();
}

/*
	Name: setreconmodeldeployed
	Namespace: trophy_system
	Checksum: 0xB05C3F98
	Offset: 0x938
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function setreconmodeldeployed()
{
	if(isdefined(self.reconmodelentity))
	{
		self.reconmodelentity clientfield::set("trophy_system_state", 2);
	}
}

/*
	Name: trophywatchhack
	Namespace: trophy_system
	Checksum: 0x17509010
	Offset: 0x978
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function trophywatchhack()
{
	self endon(#"death");
	self waittill(#"hacked", player);
	self clientfield::set("trophy_system_state", 0);
}

/*
	Name: ontrophysystemsmashed
	Namespace: trophy_system
	Checksum: 0xFCBD519B
	Offset: 0x9C8
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function ontrophysystemsmashed(attacker)
{
	playfx(level._effect["tacticalInsertionFizzle"], self.origin);
	self playsound("dst_trophy_smash");
	if(isdefined(level.playequipmentdestroyedonplayer))
	{
		self.owner [[level.playequipmentdestroyedonplayer]]();
	}
	if(isdefined(attacker) && self.owner util::isenemyplayer(attacker))
	{
		attacker challenges::destroyedequipment();
		scoreevents::processscoreevent("destroyed_trophy_system", attacker, self.owner);
	}
	self delete();
}

/*
	Name: trophyactive
	Namespace: trophy_system
	Checksum: 0xE6CCF268
	Offset: 0xAD0
	Size: 0x37A
	Parameters: 1
	Flags: Linked
*/
function trophyactive(owner)
{
	owner endon(#"disconnect");
	self endon(#"death");
	self endon(#"hacked");
	while(true)
	{
		if(!isdefined(self))
		{
			return;
		}
		if(level.missileentities.size < 1 || isdefined(self.disabled))
		{
			wait(0.05);
			continue;
		}
		for(index = 0; index < level.missileentities.size; index++)
		{
			wait(0.05);
			if(!isdefined(self))
			{
				return;
			}
			grenade = level.missileentities[index];
			if(!isdefined(grenade))
			{
				continue;
			}
			if(grenade == self)
			{
				continue;
			}
			if(!grenade.weapon.destroyablebytrophysystem)
			{
				continue;
			}
			switch(grenade.model)
			{
				case "t6_wpn_grenade_supply_projectile":
				{
					continue;
				}
			}
			if(grenade.weapon == self.weapon)
			{
				if(self.trophysystemstationary == 0 && grenade.trophysystemstationary == 1)
				{
					continue;
				}
			}
			if(!isdefined(grenade.owner))
			{
				grenade.owner = getmissileowner(grenade);
			}
			if(isdefined(grenade.owner))
			{
				if(level.teambased)
				{
					if(grenade.owner.team == owner.team)
					{
						continue;
					}
				}
				else if(grenade.owner == owner)
				{
					continue;
				}
				grenadedistancesquared = distancesquared(grenade.origin, self.origin);
				if(grenadedistancesquared < 262144)
				{
					if(bullettracepassed(grenade.origin, self.origin + vectorscale((0, 0, 1), 29), 0, self, grenade, 0, 1))
					{
						playfx(level.trophylongflashfx, self.origin + vectorscale((0, 0, 1), 15), grenade.origin - self.origin, anglestoup(self.angles));
						owner thread projectileexplode(grenade, self);
						index--;
						self playsound("wpn_trophy_alert");
						if(getdvarint("player_sustainAmmo") == 0)
						{
							self.ammo--;
							if(self.ammo <= 0)
							{
								self thread trophysystemdetonate();
							}
						}
					}
				}
			}
		}
	}
}

/*
	Name: projectileexplode
	Namespace: trophy_system
	Checksum: 0xCB25FEB4
	Offset: 0xE58
	Size: 0x14C
	Parameters: 2
	Flags: Linked
*/
function projectileexplode(projectile, trophy)
{
	self endon(#"death");
	projposition = projectile.origin;
	playfx(level.trophydetonationfx, projposition);
	projectile notify(#"trophy_destroyed");
	trophy radiusdamage(projposition, 128, 105, 10, self);
	scoreevents::processscoreevent("trophy_defense", self);
	self challenges::trophy_defense(projposition, 512);
	if(self util::is_item_purchased("trophy_system"))
	{
		self addplayerstat("destroy_explosive_with_trophy", 1);
	}
	self addweaponstat(trophy.weapon, "CombatRecordStat", 1);
	projectile delete();
}

/*
	Name: trophydestroytacinsert
	Namespace: trophy_system
	Checksum: 0x63381435
	Offset: 0xFB0
	Size: 0x12C
	Parameters: 2
	Flags: None
*/
function trophydestroytacinsert(tacinsert, trophy)
{
	self endon(#"death");
	tacpos = tacinsert.origin;
	playfx(level.trophydetonationfx, tacinsert.origin);
	tacinsert thread tacticalinsertion::tacticalinsertiondestroyedbytrophysystem(self, trophy);
	trophy radiusdamage(tacpos, 128, 105, 10, self);
	scoreevents::processscoreevent("trophy_defense", self);
	if(self util::is_item_purchased("trophy_system"))
	{
		self addplayerstat("destroy_explosive_with_trophy", 1);
	}
	self addweaponstat(trophy.weapon, "CombatRecordStat", 1);
}

/*
	Name: trophysystemdetonate
	Namespace: trophy_system
	Checksum: 0x507A48CF
	Offset: 0x10E8
	Size: 0x104
	Parameters: 3
	Flags: Linked
*/
function trophysystemdetonate(attacker, weapon, target)
{
	if(!isdefined(weapon) || !weapon.isemp)
	{
		playfx(level._equipment_explode_fx_lg, self.origin);
	}
	if(isdefined(attacker) && self.owner util::isenemyplayer(attacker))
	{
		attacker challenges::destroyedequipment(weapon);
		scoreevents::processscoreevent("destroyed_trophy_system", attacker, self.owner, weapon);
	}
	playsoundatposition("exp_trophy_system", self.origin);
	self delete();
}

/*
	Name: watchtrophysystemdamage
	Namespace: trophy_system
	Checksum: 0xEF86E522
	Offset: 0x11F8
	Size: 0x372
	Parameters: 1
	Flags: Linked
*/
function watchtrophysystemdamage(watcher)
{
	self endon(#"death");
	self endon(#"hacked");
	self setcandamage(1);
	damagemax = 20;
	if(!self util::ishacked())
	{
		self.damagetaken = 0;
	}
	self.maxhealth = 10000;
	self.health = self.maxhealth;
	self setmaxhealth(self.maxhealth);
	attacker = undefined;
	while(true)
	{
		self waittill(#"damage", damage, attacker, direction_vec, point, type, modelname, tagname, partname, weapon, idflags);
		attacker = self [[level.figure_out_attacker]](attacker);
		if(!isplayer(attacker))
		{
			continue;
		}
		if(level.teambased)
		{
			if(!level.hardcoremode && self.owner.team == attacker.pers["team"] && self.owner != attacker)
			{
				continue;
			}
		}
		if(watcher.stuntime > 0 && weapon.dostun)
		{
			self thread weaponobjects::stunstart(watcher, watcher.stuntime);
		}
		if(weapon.dodamagefeedback)
		{
			if(level.teambased && self.owner.team != attacker.team)
			{
				if(damagefeedback::dodamagefeedback(weapon, attacker))
				{
					attacker damagefeedback::update();
				}
			}
			else if(!level.teambased && self.owner != attacker)
			{
				if(damagefeedback::dodamagefeedback(weapon, attacker))
				{
					attacker damagefeedback::update();
				}
			}
		}
		if(type == "MOD_MELEE" || weapon.isemp || weapon.destroysequipment)
		{
			self.damagetaken = damagemax;
		}
		else
		{
			self.damagetaken = self.damagetaken + damage;
		}
		if(self.damagetaken >= damagemax)
		{
			watcher thread weaponobjects::waitanddetonate(self, 0.05, attacker, weapon);
			return;
		}
	}
}

/*
	Name: ammo_scavenger
	Namespace: trophy_system
	Checksum: 0x4BFD03AD
	Offset: 0x1578
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function ammo_scavenger(weapon)
{
	self ammo_reset();
}

/*
	Name: ammo_reset
	Namespace: trophy_system
	Checksum: 0x8690777A
	Offset: 0x15A8
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function ammo_reset()
{
	self._trophy_system_ammo1 = undefined;
	self._trophy_system_ammo2 = undefined;
}

/*
	Name: ammo_get
	Namespace: trophy_system
	Checksum: 0x8CC2A621
	Offset: 0x15C8
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function ammo_get(weapon)
{
	totalammo = weapon.ammocountequipment;
	if(isdefined(self._trophy_system_ammo1) && !self util::ishacked())
	{
		totalammo = self._trophy_system_ammo1;
		self._trophy_system_ammo1 = undefined;
		if(isdefined(self._trophy_system_ammo2))
		{
			self._trophy_system_ammo1 = self._trophy_system_ammo2;
			self._trophy_system_ammo2 = undefined;
		}
	}
	return totalammo;
}

/*
	Name: ammo_weapon_pickup
	Namespace: trophy_system
	Checksum: 0x93AA7869
	Offset: 0x1668
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function ammo_weapon_pickup(ammo)
{
	if(isdefined(ammo))
	{
		if(isdefined(self._trophy_system_ammo1))
		{
			self._trophy_system_ammo2 = self._trophy_system_ammo1;
			self._trophy_system_ammo1 = ammo;
		}
		else
		{
			self._trophy_system_ammo1 = ammo;
		}
	}
}

/*
	Name: ammo_weapon_hacked
	Namespace: trophy_system
	Checksum: 0x3FA6DE87
	Offset: 0x16C0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function ammo_weapon_hacked(ammo)
{
	self ammo_weapon_pickup(ammo);
}

