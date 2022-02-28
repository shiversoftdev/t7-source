// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_decoy;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_weaponobjects;

#namespace sensor_grenade;

/*
	Name: init_shared
	Namespace: sensor_grenade
	Checksum: 0x2411EF02
	Offset: 0x2D8
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.isplayertrackedfunc = &isplayertracked;
	callback::add_weapon_watcher(&createsensorgrenadewatcher);
}

/*
	Name: createsensorgrenadewatcher
	Namespace: sensor_grenade
	Checksum: 0x18F9A9E5
	Offset: 0x320
	Size: 0xCC
	Parameters: 0
	Flags: None
*/
function createsensorgrenadewatcher()
{
	watcher = self weaponobjects::createuseweaponobjectwatcher("sensor_grenade", self.team);
	watcher.headicon = 0;
	watcher.onspawn = &onspawnsensorgrenade;
	watcher.ondetonatecallback = &sensorgrenadedestroyed;
	watcher.onstun = &weaponobjects::weaponstun;
	watcher.stuntime = 0;
	watcher.ondamage = &watchsensorgrenadedamage;
	watcher.enemydestroy = 1;
}

/*
	Name: onspawnsensorgrenade
	Namespace: sensor_grenade
	Checksum: 0x2E9313F0
	Offset: 0x3F8
	Size: 0x134
	Parameters: 2
	Flags: None
*/
function onspawnsensorgrenade(watcher, player)
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
	self thread watchforexplode(player);
	self thread watch_for_decoys(player);
}

/*
	Name: watchforstationary
	Namespace: sensor_grenade
	Checksum: 0x8D1C2086
	Offset: 0x538
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function watchforstationary(owner)
{
	self endon(#"death");
	self endon(#"hacked");
	self endon(#"explode");
	owner endon(#"death");
	owner endon(#"disconnect");
	self waittill(#"stationary");
	checkfortracking(self.origin);
}

/*
	Name: watchforexplode
	Namespace: sensor_grenade
	Checksum: 0x2EA8088D
	Offset: 0x5B0
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function watchforexplode(owner)
{
	self endon(#"hacked");
	self endon(#"delete");
	owner endon(#"death");
	owner endon(#"disconnect");
	self waittill(#"explode", origin);
	checkfortracking(origin + (0, 0, 1));
}

/*
	Name: checkfortracking
	Namespace: sensor_grenade
	Checksum: 0x5B0E9354
	Offset: 0x630
	Size: 0x1D2
	Parameters: 1
	Flags: None
*/
function checkfortracking(origin)
{
	if(isdefined(self.owner) == 0)
	{
		return;
	}
	players = level.players;
	foreach(player in level.players)
	{
		if(player util::isenemyplayer(self.owner))
		{
			if(!player hasperk("specialty_nomotionsensor") && (!(player hasperk("specialty_sengrenjammer") && player clientfield::get("sg_jammer_active"))))
			{
				if(distancesquared(player.origin, origin) < 562500)
				{
					trace = bullettrace(origin, player.origin + vectorscale((0, 0, 1), 12), 0, player);
					if(trace["fraction"] == 1)
					{
						self.owner tracksensorgrenadevictim(player);
					}
				}
			}
		}
	}
}

/*
	Name: tracksensorgrenadevictim
	Namespace: sensor_grenade
	Checksum: 0x8C6709B6
	Offset: 0x810
	Size: 0x5E
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
}

/*
	Name: isplayertracked
	Namespace: sensor_grenade
	Checksum: 0x398E9F90
	Offset: 0x878
	Size: 0x82
	Parameters: 2
	Flags: None
*/
function isplayertracked(player, time)
{
	playertracked = 0;
	if(isdefined(self.sensorgrenadedata) && isdefined(self.sensorgrenadedata[player.clientid]))
	{
		if((self.sensorgrenadedata[player.clientid] + 10000) > time)
		{
			playertracked = 1;
		}
	}
	return playertracked;
}

/*
	Name: sensorgrenadedestroyed
	Namespace: sensor_grenade
	Checksum: 0x28FF607B
	Offset: 0x908
	Size: 0x104
	Parameters: 3
	Flags: None
*/
function sensorgrenadedestroyed(attacker, weapon, target)
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
	Name: watchsensorgrenadedamage
	Namespace: sensor_grenade
	Checksum: 0xD2D17739
	Offset: 0xA18
	Size: 0x35A
	Parameters: 1
	Flags: None
*/
function watchsensorgrenadedamage(watcher)
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
			watcher thread weaponobjects::waitanddetonate(self, 0, attacker, weapon);
			return;
		}
	}
}

/*
	Name: watch_for_decoys
	Namespace: sensor_grenade
	Checksum: 0x1D7938FD
	Offset: 0xD80
	Size: 0x142
	Parameters: 1
	Flags: None
*/
function watch_for_decoys(owner)
{
	self waittill(#"stationary");
	players = level.players;
	foreach(player in level.players)
	{
		if(player util::isenemyplayer(self.owner))
		{
			if(isalive(player) && player hasperk("specialty_decoy"))
			{
				if(distancesquared(player.origin, self.origin) < 57600)
				{
					player thread watch_decoy(self);
				}
			}
		}
	}
}

/*
	Name: get_decoy_spawn_loc
	Namespace: sensor_grenade
	Checksum: 0x3A67BFA
	Offset: 0xED0
	Size: 0x26
	Parameters: 0
	Flags: None
*/
function get_decoy_spawn_loc()
{
	return self.origin - (240 * anglestoforward(self.angles));
}

/*
	Name: watch_decoy
	Namespace: sensor_grenade
	Checksum: 0x2B8DA758
	Offset: 0xF00
	Size: 0xF4
	Parameters: 1
	Flags: None
*/
function watch_decoy(sensor_grenade)
{
	origin = self get_decoy_spawn_loc();
	decoy_grenade = sys::spawn("script_model", origin);
	decoy_grenade.angles = -1 * self.angles;
	wait(0.05);
	decoy_grenade.initial_velocity = -1 * self getvelocity();
	decoy_grenade thread decoy::simulate_weapon_fire(self);
	wait(15);
	decoy_grenade notify(#"done");
	decoy_grenade notify(#"death_before_explode");
	decoy_grenade delete();
}

