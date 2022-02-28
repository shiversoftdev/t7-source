// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace scrambler;

/*
	Name: init_shared
	Namespace: scrambler
	Checksum: 0xD02BA2A9
	Offset: 0x238
	Size: 0xBC
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level._effect["scrambler_enemy_light"] = "_t6/misc/fx_equip_light_red";
	level._effect["scrambler_friendly_light"] = "_t6/misc/fx_equip_light_green";
	level.scramblerweapon = getweapon("scrambler");
	level.scramblerlength = 30;
	level.scramblerouterradiussq = 1000000;
	level.scramblerinnerradiussq = 360000;
	clientfield::register("missile", "scrambler", 1, 1, "int");
}

/*
	Name: createscramblerwatcher
	Namespace: scrambler
	Checksum: 0xD0A3E2AE
	Offset: 0x300
	Size: 0xC0
	Parameters: 0
	Flags: None
*/
function createscramblerwatcher()
{
	watcher = self weaponobjects::createuseweaponobjectwatcher("scrambler", self.team);
	watcher.onspawn = &onspawnscrambler;
	watcher.ondetonatecallback = &scramblerdetonate;
	watcher.onstun = &weaponobjects::weaponstun;
	watcher.stuntime = 5;
	watcher.hackable = 1;
	watcher.ondamage = &watchscramblerdamage;
}

/*
	Name: onspawnscrambler
	Namespace: scrambler
	Checksum: 0x9768AFF
	Offset: 0x3C8
	Size: 0x122
	Parameters: 2
	Flags: None
*/
function onspawnscrambler(watcher, player)
{
	player endon(#"disconnect");
	self endon(#"death");
	self thread weaponobjects::onspawnuseweaponobject(watcher, player);
	player.scrambler = self;
	self setowner(player);
	self setteam(player.team);
	self.owner = player;
	self clientfield::set("scrambler", 1);
	if(!self util::ishacked())
	{
		player addweaponstat(self.weapon, "used", 1);
	}
	self thread watchshutdown(player);
	level notify(#"scrambler_spawn");
}

/*
	Name: scramblerdetonate
	Namespace: scrambler
	Checksum: 0x51214DB5
	Offset: 0x4F8
	Size: 0xD4
	Parameters: 3
	Flags: None
*/
function scramblerdetonate(attacker, weapon, target)
{
	if(!isdefined(weapon) || !weapon.isemp)
	{
		playfx(level._equipment_explode_fx, self.origin);
	}
	if(self.owner util::isenemyplayer(attacker))
	{
		attacker challenges::destroyedequipment(weapon);
	}
	playsoundatposition("dst_equipment_destroy", self.origin);
	self delete();
}

/*
	Name: watchshutdown
	Namespace: scrambler
	Checksum: 0x9501B7BF
	Offset: 0x5D8
	Size: 0x5A
	Parameters: 1
	Flags: None
*/
function watchshutdown(player)
{
	self util::waittill_any("death", "hacked");
	level notify(#"scrambler_death");
	if(isdefined(player))
	{
		player.scrambler = undefined;
	}
}

/*
	Name: destroyent
	Namespace: scrambler
	Checksum: 0xE212386
	Offset: 0x640
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function destroyent()
{
	self delete();
}

/*
	Name: watchscramblerdamage
	Namespace: scrambler
	Checksum: 0x30E8783D
	Offset: 0x668
	Size: 0x388
	Parameters: 1
	Flags: None
*/
function watchscramblerdamage(watcher)
{
	self endon(#"death");
	self endon(#"hacked");
	self setcandamage(1);
	damagemax = 100;
	if(!self util::ishacked())
	{
		self.damagetaken = 0;
	}
	while(true)
	{
		self.maxhealth = 100000;
		self.health = self.maxhealth;
		self waittill(#"damage", damage, attacker, direction, point, type, tagname, modelname, partname, weapon, idflags);
		if(!isdefined(attacker) || !isplayer(attacker))
		{
			continue;
		}
		if(level.teambased && attacker.team == self.owner.team && attacker != self.owner)
		{
			continue;
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
		if(isplayer(attacker) && level.teambased && isdefined(attacker.team) && self.owner.team == attacker.team && attacker != self.owner)
		{
			continue;
		}
		if(type == "MOD_MELEE" || weapon.isemp)
		{
			self.damagetaken = damagemax;
		}
		else
		{
			self.damagetaken = self.damagetaken + damage;
		}
		if(self.damagetaken >= damagemax)
		{
			watcher thread weaponobjects::waitanddetonate(self, 0, attacker, weapon);
		}
	}
}

/*
	Name: ownersameteam
	Namespace: scrambler
	Checksum: 0x5FC454E0
	Offset: 0x9F8
	Size: 0x84
	Parameters: 2
	Flags: None
*/
function ownersameteam(owner1, owner2)
{
	if(!level.teambased)
	{
		return 0;
	}
	if(!isdefined(owner1) || !isdefined(owner2))
	{
		return 0;
	}
	if(!isdefined(owner1.team) || !isdefined(owner2.team))
	{
		return 0;
	}
	return owner1.team == owner2.team;
}

/*
	Name: checkscramblerstun
	Namespace: scrambler
	Checksum: 0xAC9554B3
	Offset: 0xA88
	Size: 0x1A2
	Parameters: 0
	Flags: None
*/
function checkscramblerstun()
{
	scramblers = getentarray("grenade", "classname");
	if(isdefined(self.name) && self.name == "scrambler")
	{
		return false;
	}
	for(i = 0; i < scramblers.size; i++)
	{
		scrambler = scramblers[i];
		if(!isalive(scrambler))
		{
			continue;
		}
		if(!isdefined(scrambler.name))
		{
			continue;
		}
		if(scrambler.name != "scrambler")
		{
			continue;
		}
		if(ownersameteam(self.owner, scrambler.owner))
		{
			continue;
		}
		flattenedselforigin = (self.origin[0], self.origin[1], 0);
		flattenedscramblerorigin = (scrambler.origin[0], scrambler.origin[1], 0);
		if(distancesquared(flattenedselforigin, flattenedscramblerorigin) < level.scramblerouterradiussq)
		{
			return true;
		}
	}
	return false;
}

