// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace empgrenade;

/*
	Name: __init__sytem__
	Namespace: empgrenade
	Checksum: 0x25CE774F
	Offset: 0x1E8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("empgrenade", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: empgrenade
	Checksum: 0xFED6FE21
	Offset: 0x228
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "empd", 1, 1, "int");
	clientfield::register("toplayer", "empd_monitor_distance", 1, 1, "int");
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: empgrenade
	Checksum: 0x81639193
	Offset: 0x2B8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self endon(#"disconnect");
	self thread monitorempgrenade();
	self thread begin_other_grenade_tracking();
}

/*
	Name: monitorempgrenade
	Namespace: empgrenade
	Checksum: 0xADC8CA9D
	Offset: 0x300
	Size: 0x228
	Parameters: 0
	Flags: Linked
*/
function monitorempgrenade()
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"killempmonitor");
	self.empendtime = 0;
	while(true)
	{
		self waittill(#"emp_grenaded", attacker, explosionpoint);
		if(!isalive(self) || self hasperk("specialty_immuneemp"))
		{
			continue;
		}
		hurtvictim = 1;
		hurtattacker = 0;
		/#
			assert(isdefined(self.team));
		#/
		if(level.teambased && isdefined(attacker) && isdefined(attacker.team) && attacker.team == self.team && attacker != self)
		{
			friendlyfire = [[level.figure_out_friendly_fire]](self);
			if(friendlyfire == 0)
			{
				continue;
			}
			else
			{
				if(friendlyfire == 1)
				{
					hurtattacker = 0;
					hurtvictim = 1;
				}
				else
				{
					if(friendlyfire == 2)
					{
						hurtvictim = 0;
						hurtattacker = 1;
					}
					else if(friendlyfire == 3)
					{
						hurtattacker = 1;
						hurtvictim = 1;
					}
				}
			}
		}
		if(hurtvictim && isdefined(self))
		{
			self thread applyemp(attacker, explosionpoint);
		}
		if(hurtattacker && isdefined(attacker))
		{
			attacker thread applyemp(attacker, explosionpoint);
		}
	}
}

/*
	Name: applyemp
	Namespace: empgrenade
	Checksum: 0x4D8B6D58
	Offset: 0x530
	Size: 0x334
	Parameters: 2
	Flags: Linked
*/
function applyemp(attacker, explosionpoint)
{
	self notify(#"applyemp");
	self endon(#"applyemp");
	self endon(#"disconnect");
	self endon(#"death");
	wait(0.05);
	if(!(isdefined(self) && isalive(self)))
	{
		return;
	}
	if(self == attacker)
	{
		currentempduration = 1;
	}
	else
	{
		distancetoexplosion = distance(self.origin, explosionpoint);
		ratio = 1 - (distancetoexplosion / 425);
		currentempduration = 3 + (3 * ratio);
	}
	if(isdefined(self.empendtime))
	{
		emp_time_left_ms = self.empendtime - gettime();
		if(emp_time_left_ms > (currentempduration * 1000))
		{
			self.empduration = emp_time_left_ms / 1000;
		}
		else
		{
			self.empduration = currentempduration;
		}
	}
	else
	{
		self.empduration = currentempduration;
	}
	self.empgrenaded = 1;
	self shellshock("emp_shock", 1);
	self clientfield::set_to_player("empd", 1);
	self.empstarttime = gettime();
	self.empendtime = self.empstarttime + (self.empduration * 1000);
	self.empedby = attacker;
	shutdownemprebootindicatormenu();
	emprebootmenu = self openluimenu("EmpRebootIndicator");
	self setluimenudata(emprebootmenu, "endTime", int(self.empendtime));
	self setluimenudata(emprebootmenu, "startTime", int(self.empstarttime));
	self thread emprumbleloop(0.75);
	self setempjammed(1);
	self thread empgrenadedeathwaiter();
	self thread empgrenadecleansewaiter();
	if(self.empduration > 0)
	{
		wait(self.empduration);
	}
	if(isdefined(self))
	{
		self notify(#"empgrenadetimedout");
		self checktoturnoffemp();
	}
}

/*
	Name: empgrenadedeathwaiter
	Namespace: empgrenade
	Checksum: 0x2543D7C5
	Offset: 0x870
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function empgrenadedeathwaiter()
{
	self notify(#"empgrenadedeathwaiter");
	self endon(#"empgrenadedeathwaiter");
	self endon(#"empgrenadetimedout");
	self waittill(#"death");
	if(isdefined(self))
	{
		self checktoturnoffemp();
	}
}

/*
	Name: empgrenadecleansewaiter
	Namespace: empgrenade
	Checksum: 0x5157EF
	Offset: 0x8D0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function empgrenadecleansewaiter()
{
	self notify(#"empgrenadecleansewaiter");
	self endon(#"empgrenadecleansewaiter");
	self endon(#"empgrenadetimedout");
	self waittill(#"gadget_cleanse_on");
	if(isdefined(self))
	{
		self checktoturnoffemp();
	}
}

/*
	Name: checktoturnoffemp
	Namespace: empgrenade
	Checksum: 0x2B0A4B1B
	Offset: 0x930
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function checktoturnoffemp()
{
	if(isdefined(self))
	{
		self.empgrenaded = 0;
		shutdownemprebootindicatormenu();
		if(self killstreaks::emp_isempd())
		{
			return;
		}
		self setempjammed(0);
		self clientfield::set_to_player("empd", 0);
	}
}

/*
	Name: shutdownemprebootindicatormenu
	Namespace: empgrenade
	Checksum: 0x191FB63
	Offset: 0x9B8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function shutdownemprebootindicatormenu()
{
	emprebootmenu = self getluimenu("EmpRebootIndicator");
	if(isdefined(emprebootmenu))
	{
		self closeluimenu(emprebootmenu);
	}
}

/*
	Name: emprumbleloop
	Namespace: empgrenade
	Checksum: 0x76D92163
	Offset: 0xA18
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function emprumbleloop(duration)
{
	self endon(#"emp_rumble_loop");
	self notify(#"emp_rumble_loop");
	goaltime = gettime() + (duration * 1000);
	while(gettime() < goaltime)
	{
		self playrumbleonentity("damage_heavy");
		wait(0.05);
	}
}

/*
	Name: watchempexplosion
	Namespace: empgrenade
	Checksum: 0x17D960F1
	Offset: 0xA90
	Size: 0xAC
	Parameters: 2
	Flags: Linked
*/
function watchempexplosion(owner, weapon)
{
	owner endon(#"disconnect");
	owner endon(#"team_changed");
	self endon(#"trophy_destroyed");
	owner addweaponstat(weapon, "used", 1);
	self waittill(#"explode", origin, surface);
	level empexplosiondamageents(owner, weapon, origin, 425, 1);
}

/*
	Name: empexplosiondamageents
	Namespace: empgrenade
	Checksum: 0x7FBABB98
	Offset: 0xB48
	Size: 0x132
	Parameters: 5
	Flags: Linked
*/
function empexplosiondamageents(owner, weapon, origin, radius, damageplayers)
{
	ents = getdamageableentarray(origin, radius);
	if(!isdefined(damageplayers))
	{
		damageplayers = 1;
	}
	foreach(ent in ents)
	{
		if(!damageplayers && isplayer(ent))
		{
			continue;
		}
		ent dodamage(1, origin, owner, owner, "none", "MOD_GRENADE_SPLASH", 0, weapon);
	}
}

/*
	Name: begin_other_grenade_tracking
	Namespace: empgrenade
	Checksum: 0x37E9F679
	Offset: 0xC88
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function begin_other_grenade_tracking()
{
	self endon(#"death");
	self endon(#"disconnect");
	self notify(#"emptrackingstart");
	self endon(#"emptrackingstart");
	for(;;)
	{
		self waittill(#"grenade_fire", grenade, weapon, cooktime);
		if(grenade util::ishacked())
		{
			continue;
		}
		if(weapon.isemp)
		{
			grenade thread watchempexplosion(self, weapon);
		}
	}
}

