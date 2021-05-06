// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace acousticsensor;

/*
	Name: init_shared
	Namespace: acousticsensor
	Checksum: 0xEFFDB9B0
	Offset: 0x280
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level._effect["acousticsensor_enemy_light"] = "_t6/misc/fx_equip_light_red";
	level._effect["acousticsensor_friendly_light"] = "_t6/misc/fx_equip_light_green";
	callback::add_weapon_watcher(&createacousticsensorwatcher);
}

/*
	Name: createacousticsensorwatcher
	Namespace: acousticsensor
	Checksum: 0xA24F1A71
	Offset: 0x2E8
	Size: 0xC0
	Parameters: 0
	Flags: None
*/
function createacousticsensorwatcher()
{
	watcher = self weaponobjects::createuseweaponobjectwatcher("acoustic_sensor", self.team);
	watcher.onspawn = &onspawnacousticsensor;
	watcher.ondetonatecallback = &acousticsensordetonate;
	watcher.stun = &weaponobjects::weaponstun;
	watcher.stuntime = 5;
	watcher.hackable = 1;
	watcher.ondamage = &watchacousticsensordamage;
}

/*
	Name: onspawnacousticsensor
	Namespace: acousticsensor
	Checksum: 0x8B5D3BD7
	Offset: 0x3B0
	Size: 0x10C
	Parameters: 2
	Flags: None
*/
function onspawnacousticsensor(watcher, player)
{
	self endon(#"death");
	self thread weaponobjects::onspawnuseweaponobject(watcher, player);
	player.acousticsensor = self;
	self setowner(player);
	self setteam(player.team);
	self.owner = player;
	self playloopsound("fly_acoustic_sensor_lp");
	if(!self util::ishacked())
	{
		player addweaponstat(self.weapon, "used", 1);
	}
	self thread watchshutdown(player, self.origin);
}

/*
	Name: acousticsensordetonate
	Namespace: acousticsensor
	Checksum: 0xE3739FA
	Offset: 0x4C8
	Size: 0x104
	Parameters: 3
	Flags: None
*/
function acousticsensordetonate(attacker, weapon, target)
{
	if(!isdefined(weapon) || !weapon.isemp)
	{
		playfx(level._equipment_explode_fx, self.origin);
	}
	if(isdefined(attacker))
	{
		if(self.owner util::isenemyplayer(attacker))
		{
			attacker challenges::destroyedequipment(weapon);
			scoreevents::processscoreevent("destroyed_motion_sensor", attacker, self.owner, weapon);
		}
	}
	playsoundatposition("dst_equipment_destroy", self.origin);
	self destroyent();
}

/*
	Name: destroyent
	Namespace: acousticsensor
	Checksum: 0x8135D255
	Offset: 0x5D8
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function destroyent()
{
	self delete();
}

/*
	Name: watchshutdown
	Namespace: acousticsensor
	Checksum: 0x9939EFBF
	Offset: 0x600
	Size: 0x52
	Parameters: 2
	Flags: None
*/
function watchshutdown(player, origin)
{
	self util::waittill_any("death", "hacked");
	if(isdefined(player))
	{
		player.acousticsensor = undefined;
	}
}

/*
	Name: watchacousticsensordamage
	Namespace: acousticsensor
	Checksum: 0x8499F6B3
	Offset: 0x660
	Size: 0x38A
	Parameters: 1
	Flags: None
*/
function watchacousticsensordamage(watcher)
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
			return;
		}
	}
}

