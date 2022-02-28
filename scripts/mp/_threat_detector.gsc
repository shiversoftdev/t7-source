// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_weaponobjects;

#namespace threat_detector;

/*
	Name: __init__sytem__
	Namespace: threat_detector
	Checksum: 0x2A0046F6
	Offset: 0x260
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("threat_detector", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: threat_detector
	Checksum: 0xC727A561
	Offset: 0x2A0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("missile", "threat_detector", 1, 1, "int");
	callback::add_weapon_watcher(&createthreatdetectorwatcher);
}

/*
	Name: createthreatdetectorwatcher
	Namespace: threat_detector
	Checksum: 0x26DBCC5F
	Offset: 0x300
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function createthreatdetectorwatcher()
{
	watcher = self weaponobjects::createuseweaponobjectwatcher("threat_detector", self.team);
	watcher.headicon = 0;
	watcher.onspawn = &onspawnthreatdetector;
	watcher.ondetonatecallback = &threatdetectordestroyed;
	watcher.stun = &weaponobjects::weaponstun;
	watcher.stuntime = 0;
	watcher.ondamage = &watchthreatdetectordamage;
	watcher.enemydestroy = 1;
}

/*
	Name: onspawnthreatdetector
	Namespace: threat_detector
	Checksum: 0xE7B5E964
	Offset: 0x3D8
	Size: 0x104
	Parameters: 2
	Flags: Linked
*/
function onspawnthreatdetector(watcher, player)
{
	self endon(#"death");
	self thread weaponobjects::onspawnuseweaponobject(watcher, player);
	self setowner(player);
	self setteam(player.team);
	self.owner = player;
	self playloopsound("wpn_sensor_nade_lp");
	self hacker_tool::registerwithhackertool(level.equipmenthackertoolradius, level.equipmenthackertooltimems);
	player addweaponstat(self.weapon, "used", 1);
	self thread watchforstationary(player);
}

/*
	Name: watchforstationary
	Namespace: threat_detector
	Checksum: 0x7D336D0D
	Offset: 0x4E8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function watchforstationary(owner)
{
	self endon(#"death");
	self endon(#"hacked");
	self endon(#"explode");
	owner endon(#"death");
	owner endon(#"disconnect");
	self waittill(#"stationary");
	self clientfield::set("threat_detector", 1);
}

/*
	Name: tracksensorgrenadevictim
	Namespace: threat_detector
	Checksum: 0x92DCAF36
	Offset: 0x568
	Size: 0x7C
	Parameters: 1
	Flags: None
*/
function tracksensorgrenadevictim(victim)
{
	if(!isdefined(self.sensorgrenadedata))
	{
		self.sensorgrenadedata = [];
	}
	if(!isdefined(self.sensorgrenadedata[victim.clientid]))
	{
		self.sensorgrenadedata[victim.clientid] = gettime();
	}
	self clientfield::set_to_player("threat_detected", 1);
}

/*
	Name: threatdetectordestroyed
	Namespace: threat_detector
	Checksum: 0x9FFF7F31
	Offset: 0x5F0
	Size: 0x104
	Parameters: 3
	Flags: Linked
*/
function threatdetectordestroyed(attacker, weapon, target)
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
	playsoundatposition("wpn_sensor_nade_explo", self.origin);
	self delete();
}

/*
	Name: watchthreatdetectordamage
	Namespace: threat_detector
	Checksum: 0xABD7EF3C
	Offset: 0x700
	Size: 0x34A
	Parameters: 1
	Flags: Linked
*/
function watchthreatdetectordamage(watcher)
{
	self endon(#"death");
	self endon(#"hacked");
	self setcandamage(1);
	damagemax = 1;
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
		if(level.teambased && isplayer(attacker))
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

