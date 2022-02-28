// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_challenges;
#using scripts\zm\gametypes\_globallogic_player;

#using_animtree("mp_vehicles");

#namespace destructible;

/*
	Name: __init__sytem__
	Namespace: destructible
	Checksum: 0xE2265F2A
	Offset: 0x3F0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("destructible", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: destructible
	Checksum: 0x995D206C
	Offset: 0x430
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.destructible_callbacks = [];
	destructibles = getentarray("destructible", "targetname");
	clientfield::register("scriptmover", "start_destructible_explosion", 1, 10, "int");
	if(destructibles.size <= 0)
	{
		return;
	}
	for(i = 0; i < destructibles.size; i++)
	{
		if(getsubstr(destructibles[i].destructibledef, 0, 4) == "veh_")
		{
			destructibles[i] thread destructible_car_death_think();
			destructibles[i] thread destructible_car_grenade_stuck_think();
		}
	}
	init_explosions();
}

/*
	Name: init_explosions
	Namespace: destructible
	Checksum: 0x54662CAF
	Offset: 0x570
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function init_explosions()
{
	level.explosion_manager = spawnstruct();
	level.explosion_manager.count = 0;
	level.explosion_manager.a_explosions = [];
	for(i = 0; i < 32; i++)
	{
		sexplosion = spawn("script_model", (0, 0, 0));
		if(!isdefined(level.explosion_manager.a_explosions))
		{
			level.explosion_manager.a_explosions = [];
		}
		else if(!isarray(level.explosion_manager.a_explosions))
		{
			level.explosion_manager.a_explosions = array(level.explosion_manager.a_explosions);
		}
		level.explosion_manager.a_explosions[level.explosion_manager.a_explosions.size] = sexplosion;
	}
}

/*
	Name: get_unused_explosion
	Namespace: destructible
	Checksum: 0xE786B521
	Offset: 0x6B0
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function get_unused_explosion()
{
	foreach(explosion in level.explosion_manager.a_explosions)
	{
		if(!(isdefined(explosion.in_use) && explosion.in_use))
		{
			return explosion;
		}
	}
	return level.explosion_manager.a_explosions[0];
}

/*
	Name: physics_explosion_and_rumble
	Namespace: destructible
	Checksum: 0x86560D2F
	Offset: 0x770
	Size: 0xFC
	Parameters: 3
	Flags: Linked
*/
function physics_explosion_and_rumble(origin, radius, physics_explosion)
{
	sexplosion = get_unused_explosion();
	sexplosion.in_use = 1;
	sexplosion.origin = origin;
	/#
		assert(radius <= (pow(2, 10) - 1));
	#/
	if(isdefined(physics_explosion) && physics_explosion)
	{
		radius = radius + (1 << 9);
	}
	wait(0.05);
	sexplosion clientfield::set("start_destructible_explosion", radius);
	sexplosion.in_use = 0;
}

/*
	Name: destructible_event_callback
	Namespace: destructible
	Checksum: 0x9E4FE93
	Offset: 0x878
	Size: 0x45E
	Parameters: 3
	Flags: Linked
*/
function destructible_event_callback(destructible_event, attacker, weapon)
{
	explosion_radius = 0;
	if(issubstr(destructible_event, "explode") && destructible_event != "explode")
	{
		tokens = strtok(destructible_event, "_");
		explosion_radius = tokens[1];
		if(explosion_radius == "sm")
		{
			explosion_radius = 150;
		}
		else
		{
			if(explosion_radius == "lg")
			{
				explosion_radius = 450;
			}
			else
			{
				explosion_radius = int(explosion_radius);
			}
		}
		destructible_event = "explode_complex";
	}
	if(issubstr(destructible_event, "explosive"))
	{
		tokens = strtok(destructible_event, "_");
		damage_type = tokens[2];
		explosion_radius_type = tokens[3];
		explosion_radius = 300;
		switch(damage_type)
		{
			case "concussive":
			{
				if(explosion_radius_type == "large")
				{
					explosion_radius = 280;
				}
				else
				{
					explosion_radius = 220;
				}
				break;
			}
			case "electrical":
			{
				if(explosion_radius_type == "large")
				{
					explosion_radius = 60;
				}
				else
				{
					explosion_radius = 210;
				}
				break;
			}
			case "incendiary":
			{
				if(explosion_radius_type == "large")
				{
					explosion_radius = 250;
				}
				else
				{
					explosion_radius = 200;
				}
				break;
			}
		}
	}
	if(issubstr(destructible_event, "simple_timed_explosion"))
	{
		self thread simple_timed_explosion(destructible_event, attacker);
		return;
	}
	switch(destructible_event)
	{
		case "destructible_car_explosion":
		{
			self destructible_car_explosion(attacker);
			if(isdefined(weapon))
			{
				self.destroyingweapon = weapon;
			}
			break;
		}
		case "destructible_car_fire":
		{
			self thread destructible_car_fire_think(attacker);
			if(isdefined(weapon))
			{
				self.destroyingweapon = weapon;
			}
			break;
		}
		case "explode":
		{
			self thread simple_explosion(attacker);
			break;
		}
		case "explode_complex":
		{
			self thread complex_explosion(attacker, explosion_radius);
			break;
		}
		case "destructible_explosive_incendiary_large":
		case "destructible_explosive_incendiary_small":
		{
			self explosive_incendiary_explosion(attacker, explosion_radius, 0);
			if(isdefined(weapon))
			{
				self.destroyingweapon = weapon;
			}
			break;
		}
		case "destructible_explosive_electrical_large":
		case "destructible_explosive_electrical_small":
		{
			self explosive_electrical_explosion(attacker, explosion_radius, 0);
			if(isdefined(weapon))
			{
				self.destroyingweapon = weapon;
			}
			break;
		}
		case "destructible_explosive_concussive_large":
		case "destructible_explosive_concussive_small":
		{
			self explosive_concussive_explosion(attacker, explosion_radius, 0);
			if(isdefined(weapon))
			{
				self.destroyingweapon = weapon;
			}
			break;
		}
		default:
		{
			break;
		}
	}
	if(isdefined(level.destructible_callbacks[destructible_event]))
	{
		self thread [[level.destructible_callbacks[destructible_event]]](destructible_event, attacker);
	}
}

/*
	Name: simple_explosion
	Namespace: destructible
	Checksum: 0xAA005DF8
	Offset: 0xCE0
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function simple_explosion(attacker)
{
	offset = vectorscale((0, 0, 1), 5);
	self radiusdamage(self.origin + offset, 256, 300, 75, attacker, "MOD_EXPLOSIVE", getweapon("explodable_barrel"));
	physics_explosion_and_rumble(self.origin, 255, 1);
	if(isdefined(attacker))
	{
		self dodamage(self.health + 10000, self.origin + offset, attacker);
	}
	else
	{
		self dodamage(self.health + 10000, self.origin + offset);
	}
}

/*
	Name: simple_timed_explosion
	Namespace: destructible
	Checksum: 0x7FAFAC95
	Offset: 0xDF0
	Size: 0x13C
	Parameters: 2
	Flags: Linked
*/
function simple_timed_explosion(destructible_event, attacker)
{
	self endon(#"death");
	wait_times = [];
	str = getsubstr(destructible_event, 23);
	tokens = strtok(str, "_");
	for(i = 0; i < tokens.size; i++)
	{
		wait_times[wait_times.size] = int(tokens[i]);
	}
	if(wait_times.size <= 0)
	{
		wait_times[0] = 5;
		wait_times[1] = 10;
	}
	wait(randomintrange(wait_times[0], wait_times[1]));
	simple_explosion(attacker);
}

/*
	Name: complex_explosion
	Namespace: destructible
	Checksum: 0xB92B401A
	Offset: 0xF38
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function complex_explosion(attacker, max_radius)
{
	offset = vectorscale((0, 0, 1), 5);
	if(isdefined(attacker))
	{
		self radiusdamage(self.origin + offset, max_radius, 300, 100, attacker);
	}
	else
	{
		self radiusdamage(self.origin + offset, max_radius, 300, 100);
	}
	physics_explosion_and_rumble(self.origin, max_radius, 1);
	if(isdefined(attacker))
	{
		self dodamage(20000, self.origin + offset, attacker);
	}
	else
	{
		self dodamage(20000, self.origin + offset);
	}
}

/*
	Name: destructible_car_explosion
	Namespace: destructible
	Checksum: 0xDDAA5DEB
	Offset: 0x1058
	Size: 0x19C
	Parameters: 2
	Flags: Linked
*/
function destructible_car_explosion(attacker, physics_explosion)
{
	if(self.car_dead)
	{
		return;
	}
	if(!isdefined(physics_explosion))
	{
		physics_explosion = 1;
	}
	self notify(#"car_dead");
	self.car_dead = 1;
	if(isdefined(attacker))
	{
		self radiusdamage(self.origin, 256, 300, 75, attacker, "MOD_EXPLOSIVE", getweapon("destructible_car"));
	}
	else
	{
		self radiusdamage(self.origin, 256, 300, 75);
	}
	physics_explosion_and_rumble(self.origin, 255, physics_explosion);
	if(isdefined(attacker))
	{
		attacker thread challenges::destroyed_car();
	}
	level.globalcarsdestroyed++;
	if(isdefined(attacker))
	{
		self dodamage(self.health + 10000, self.origin + (0, 0, 1), attacker);
	}
	else
	{
		self dodamage(self.health + 10000, self.origin + (0, 0, 1));
	}
	self markdestructibledestroyed();
}

/*
	Name: destructible_car_death_think
	Namespace: destructible
	Checksum: 0xAB8F7B95
	Offset: 0x1200
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function destructible_car_death_think()
{
	self endon(#"car_dead");
	self.car_dead = 0;
	self thread destructible_car_death_notify();
	self waittill(#"destructible_base_piece_death", attacker);
	if(isdefined(self))
	{
		self thread destructible_car_explosion(attacker, 0);
	}
}

/*
	Name: destructible_car_grenade_stuck_think
	Namespace: destructible
	Checksum: 0xD16D8A5
	Offset: 0x1270
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function destructible_car_grenade_stuck_think()
{
	self endon(#"destructible_base_piece_death");
	self endon(#"car_dead");
	self endon(#"death");
	for(;;)
	{
		self waittill(#"grenade_stuck", missile);
		if(!isdefined(missile) || !isdefined(missile.model))
		{
			continue;
		}
		if(missile.model == "t5_weapon_crossbow_bolt" || missile.model == "t6_wpn_grenade_semtex_projectile" || missile.model == "wpn_t7_c4_world")
		{
			self thread destructible_car_grenade_stuck_explode(missile);
		}
	}
}

/*
	Name: destructible_car_grenade_stuck_explode
	Namespace: destructible
	Checksum: 0x35CFCDB
	Offset: 0x1350
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function destructible_car_grenade_stuck_explode(missile)
{
	self endon(#"destructible_base_piece_death");
	self endon(#"car_dead");
	self endon(#"death");
	owner = getmissileowner(missile);
	if(isdefined(owner) && missile.model == "wpn_t7_c4_world")
	{
		owner endon(#"disconnect");
		owner endon(#"weapon_object_destroyed");
		missile endon(#"picked_up");
		missile thread destructible_car_hacked_c4(self);
	}
	missile waittill(#"explode");
	if(isdefined(owner))
	{
		self dodamage(self.health + 10000, self.origin + (0, 0, 1), owner);
	}
	else
	{
		self dodamage(self.health + 10000, self.origin + (0, 0, 1));
	}
}

/*
	Name: destructible_car_hacked_c4
	Namespace: destructible
	Checksum: 0xEC415E1B
	Offset: 0x1488
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function destructible_car_hacked_c4(car)
{
	car endon(#"destructible_base_piece_death");
	car endon(#"car_dead");
	car endon(#"death");
	self endon(#"death");
	self waittill(#"hacked");
	self notify(#"picked_up");
	car thread destructible_car_grenade_stuck_explode(self);
}

/*
	Name: destructible_car_death_notify
	Namespace: destructible
	Checksum: 0x42BE802F
	Offset: 0x1500
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function destructible_car_death_notify()
{
	self endon(#"car_dead");
	self waittill(#"death", attacker);
	self notify(#"destructible_base_piece_death", attacker);
}

/*
	Name: destructible_car_fire_think
	Namespace: destructible
	Checksum: 0xF1C72790
	Offset: 0x1548
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function destructible_car_fire_think(attacker)
{
	self endon(#"death");
	wait(randomintrange(7, 10));
	self thread destructible_car_explosion(attacker);
}

/*
	Name: codecallback_destructibleevent
	Namespace: destructible
	Checksum: 0x46C2ED14
	Offset: 0x15A0
	Size: 0x11C
	Parameters: 5
	Flags: None
*/
function codecallback_destructibleevent(event, param1, param2, param3, param4)
{
	if(event == "broken")
	{
		notify_type = param1;
		attacker = param2;
		piece = param3;
		weapon = param4;
		destructible_event_callback(notify_type, attacker, weapon);
		self notify(event, notify_type, attacker);
	}
	else if(event == "breakafter")
	{
		piece = param1;
		time = param2;
		damage = param3;
		self thread breakafter(time, damage, piece);
	}
}

/*
	Name: breakafter
	Namespace: destructible
	Checksum: 0x69821486
	Offset: 0x16C8
	Size: 0x64
	Parameters: 3
	Flags: Linked
*/
function breakafter(time, damage, piece)
{
	self notify(#"breakafter");
	self endon(#"breakafter");
	wait(time);
	self dodamage(damage, self.origin, undefined, undefined);
}

/*
	Name: explosive_incendiary_explosion
	Namespace: destructible
	Checksum: 0xD438C8A6
	Offset: 0x1738
	Size: 0x174
	Parameters: 3
	Flags: Linked
*/
function explosive_incendiary_explosion(attacker, explosion_radius, physics_explosion)
{
	if(!isvehicle(self))
	{
		offset = vectorscale((0, 0, 1), 5);
		if(isdefined(attacker))
		{
			self radiusdamage(self.origin + offset, explosion_radius, 380, 95, attacker, "MOD_BURNED", getweapon("incendiary_fire"));
		}
		else
		{
			self radiusdamage(self.origin + offset, explosion_radius, 380, 95);
		}
		physics_explosion_and_rumble(self.origin, 255, physics_explosion);
	}
	if(isdefined(self.target))
	{
		dest_clip = getent(self.target, "targetname");
		if(isdefined(dest_clip))
		{
			dest_clip delete();
		}
	}
	self markdestructibledestroyed();
}

/*
	Name: explosive_electrical_explosion
	Namespace: destructible
	Checksum: 0x9894917B
	Offset: 0x18B8
	Size: 0x15C
	Parameters: 3
	Flags: Linked
*/
function explosive_electrical_explosion(attacker, explosion_radius, physics_explosion)
{
	if(!isvehicle(self))
	{
		offset = vectorscale((0, 0, 1), 5);
		if(isdefined(attacker))
		{
			self radiusdamage(self.origin + offset, explosion_radius, 350, 80, attacker, "MOD_ELECTROCUTED");
		}
		else
		{
			self radiusdamage(self.origin + offset, explosion_radius, 350, 80);
		}
		physics_explosion_and_rumble(self.origin, 255, physics_explosion);
	}
	if(isdefined(self.target))
	{
		dest_clip = getent(self.target, "targetname");
		if(isdefined(dest_clip))
		{
			dest_clip delete();
		}
	}
	self markdestructibledestroyed();
}

/*
	Name: explosive_concussive_explosion
	Namespace: destructible
	Checksum: 0x80D73C74
	Offset: 0x1A20
	Size: 0x15C
	Parameters: 3
	Flags: Linked
*/
function explosive_concussive_explosion(attacker, explosion_radius, physics_explosion)
{
	if(!isvehicle(self))
	{
		offset = vectorscale((0, 0, 1), 5);
		if(isdefined(attacker))
		{
			self radiusdamage(self.origin + offset, explosion_radius, 300, 50, attacker, "MOD_GRENADE");
		}
		else
		{
			self radiusdamage(self.origin + offset, explosion_radius, 300, 50);
		}
		physics_explosion_and_rumble(self.origin, 255, physics_explosion);
	}
	if(isdefined(self.target))
	{
		dest_clip = getent(self.target, "targetname");
		if(isdefined(dest_clip))
		{
			dest_clip delete();
		}
	}
	self markdestructibledestroyed();
}

