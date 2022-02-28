// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_achievements;
#using scripts\cp\_bb;
#using scripts\cp\_challenges;
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_globallogic_player;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using_animtree("mp_vehicles");

#namespace destructible;

/*
	Name: __init__sytem__
	Namespace: destructible
	Checksum: 0xBAEF40EB
	Offset: 0x4D0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("destructible", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: destructible
	Checksum: 0xB0790C96
	Offset: 0x518
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "start_destructible_explosion", 1, 11, "int");
	level.destructible_callbacks = [];
	destructibles = getentarray("destructible", "targetname");
	if(destructibles.size <= 0)
	{
		return;
	}
	for(i = 0; i < destructibles.size; i++)
	{
		if(getsubstr(destructibles[i].destructibledef, 0, 4) == "veh_")
		{
			destructibles[i] thread car_death_think();
			destructibles[i] thread car_grenade_stuck_think();
			continue;
		}
		if(destructibles[i].destructibledef == "fxdest_upl_metal_tank_01")
		{
			destructibles[i] thread tank_grenade_stuck_think();
		}
	}
	init_explosions();
}

/*
	Name: __main__
	Namespace: destructible
	Checksum: 0x9D891769
	Offset: 0x698
	Size: 0x13A
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	waittillframeend();
	a_destructibles = getentarray("destructible", "targetname");
	if(a_destructibles.size <= 0)
	{
		return;
	}
	foreach(e_destructible in a_destructibles)
	{
		if(issubstr(e_destructible.destructibledef, "explosive_concussive") || issubstr(e_destructible.destructibledef, "explosive_electrical") || issubstr(e_destructible.destructibledef, "explosive_incendiary"))
		{
			e_destructible thread oed::enable_thermal();
		}
	}
}

/*
	Name: init_explosions
	Namespace: destructible
	Checksum: 0xE687C0F6
	Offset: 0x7E0
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
	Checksum: 0x102B4A5A
	Offset: 0x920
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
	Checksum: 0x3646D451
	Offset: 0x9E0
	Size: 0x154
	Parameters: 4
	Flags: Linked
*/
function physics_explosion_and_rumble(origin, radius, var_824b40e2 = 1, var_34aa7e9b = 0)
{
	sexplosion = get_unused_explosion();
	sexplosion.in_use = 1;
	sexplosion.origin = origin;
	wait(0.05);
	/#
		assert(radius <= (pow(2, 10) - 1));
	#/
	var_e0d11135 = radius;
	if(var_824b40e2)
	{
		var_e0d11135 = var_e0d11135 + (1 << 10);
	}
	if(var_34aa7e9b)
	{
		var_e0d11135 = var_e0d11135 + (1 << 9);
	}
	sexplosion clientfield::set("start_destructible_explosion", var_e0d11135);
	sexplosion.in_use = 0;
}

/*
	Name: event_callback
	Namespace: destructible
	Checksum: 0x9432782D
	Offset: 0xB40
	Size: 0x3CE
	Parameters: 3
	Flags: Linked
*/
function event_callback(destructible_event, attacker, weapon)
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
	if(issubstr(destructible_event, "simple_timed_explosion"))
	{
		self thread simple_timed_explosion(destructible_event, attacker);
		return;
	}
	if(isdefined(weapon))
	{
		self.destroyingweapon = weapon;
	}
	switch(destructible_event)
	{
		case "destructible_car_explosion":
		{
			self car_explosion(attacker);
			break;
		}
		case "destructible_car_fire":
		{
			level thread battlechatter::bc_ainearexplodable(self, "car");
			self thread car_fire_think(attacker);
			break;
		}
		case "explode":
		{
			self thread simple_explosion(attacker);
			break;
		}
		case "explode_complex":
		{
			self thread complex_explosion(attacker, 300);
			break;
		}
		case "destructible_explosive_incendiary_small":
		{
			self explosive_incendiary_explosion(attacker, 230);
			break;
		}
		case "destructible_explosive_incendiary_large":
		{
			self explosive_incendiary_explosion(attacker, 265, 1);
			break;
		}
		case "destructible_explosive_electrical_small":
		{
			self explosive_electrical_explosion(attacker, 240);
			break;
		}
		case "destructible_explosive_electrical_large":
		{
			self explosive_electrical_explosion(attacker, 290, 1);
			break;
		}
		case "destructible_explosive_concussive_small":
		{
			self explosive_concussive_explosion(attacker, 240);
			break;
		}
		case "destructible_explosive_concussive_large":
		{
			self explosive_concussive_explosion(attacker, 275, 1);
			break;
		}
		default:
		{
			break;
		}
	}
	if(isdefined(attacker) && isplayer(attacker))
	{
		attacker matchrecordincrementcheckpointstat(skipto::function_52c50cb8(), "destructibles_destroyed");
	}
	bb::logexplosionevent(self, attacker, destructible_event, explosion_radius);
	if(isdefined(level.destructible_callbacks[destructible_event]))
	{
		self thread [[level.destructible_callbacks[destructible_event]]](destructible_event, attacker);
	}
}

/*
	Name: car_fire_think
	Namespace: destructible
	Checksum: 0xB75096CF
	Offset: 0xF18
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function car_fire_think(attacker)
{
	self endon(#"death");
	wait(randomintrange(7, 10));
	self thread car_explosion(attacker);
}

/*
	Name: simple_explosion
	Namespace: destructible
	Checksum: 0xAA3E1C70
	Offset: 0xF70
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function simple_explosion(attacker)
{
	if(isdefined(self.exploded) && self.exploded)
	{
		return;
	}
	self.exploded = 1;
	offset = vectorscale((0, 0, 1), 5);
	self radiusdamage(self.origin + offset, 256, 300, 75, attacker, "MOD_EXPLOSIVE", getweapon("explodable_barrel"));
	physics_explosion_and_rumble(self.origin, 255, 0);
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
	Checksum: 0xC52AA86A
	Offset: 0x10A0
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
	Checksum: 0x70B2562F
	Offset: 0x11E8
	Size: 0x124
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
	physics_explosion_and_rumble(self.origin + offset, max_radius, 0);
	if(isdefined(attacker))
	{
		self dodamage(20000, self.origin + offset, attacker, 0);
	}
	else
	{
		self dodamage(20000, self.origin + offset);
	}
}

/*
	Name: car_explosion
	Namespace: destructible
	Checksum: 0xDE2C219B
	Offset: 0x1318
	Size: 0x1C4
	Parameters: 2
	Flags: Linked
*/
function car_explosion(attacker, physics_explosion)
{
	if(isdefined(self.car_dead) && self.car_dead)
	{
		return;
	}
	if(!isdefined(physics_explosion))
	{
		physics_explosion = 1;
	}
	self notify(#"car_dead");
	self.car_dead = 1;
	if(!isvehicle(self))
	{
		if(isdefined(attacker))
		{
			self radiusdamage(self.origin, 256, 300, 75, attacker, "MOD_EXPLOSIVE", getweapon("destructible_car"));
		}
		else
		{
			self radiusdamage(self.origin, 256, 300, 75);
		}
		physics_explosion_and_rumble(self.origin, 255, 0);
	}
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
	Name: tank_grenade_stuck_think
	Namespace: destructible
	Checksum: 0x6AE7220D
	Offset: 0x14E8
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function tank_grenade_stuck_think()
{
	self endon(#"destructible_base_piece_death");
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
			self thread tank_grenade_stuck_explode(missile);
		}
	}
}

/*
	Name: tank_grenade_stuck_explode
	Namespace: destructible
	Checksum: 0x4A9AEE59
	Offset: 0x15B8
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function tank_grenade_stuck_explode(missile)
{
	self endon(#"destructible_base_piece_death");
	self endon(#"death");
	owner = getmissileowner(missile);
	if(isdefined(owner) && missile.model == "wpn_t7_c4_world")
	{
		owner endon(#"disconnect");
		owner endon(#"weapon_object_destroyed");
		missile endon(#"picked_up");
		missile thread tank_hacked_c4(self);
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
	Name: tank_hacked_c4
	Namespace: destructible
	Checksum: 0x5F30CA38
	Offset: 0x16E8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function tank_hacked_c4(tank)
{
	tank endon(#"destructible_base_piece_death");
	tank endon(#"death");
	self endon(#"death");
	self waittill(#"hacked");
	self notify(#"picked_up");
	tank thread tank_grenade_stuck_explode(self);
}

/*
	Name: car_death_think
	Namespace: destructible
	Checksum: 0x97D00261
	Offset: 0x1758
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function car_death_think()
{
	self endon(#"car_dead");
	self.car_dead = 0;
	self thread car_death_notify();
	self waittill(#"destructible_base_piece_death", attacker);
	if(isdefined(self))
	{
		self thread car_explosion(attacker, 0);
	}
}

/*
	Name: car_grenade_stuck_think
	Namespace: destructible
	Checksum: 0x716F1A2F
	Offset: 0x17C8
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function car_grenade_stuck_think()
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
			self thread car_grenade_stuck_explode(missile);
		}
	}
}

/*
	Name: car_grenade_stuck_explode
	Namespace: destructible
	Checksum: 0xA4CD371
	Offset: 0x18A8
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function car_grenade_stuck_explode(missile)
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
		missile thread car_hacked_c4(self);
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
	Name: car_hacked_c4
	Namespace: destructible
	Checksum: 0x357EC4B1
	Offset: 0x19E0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function car_hacked_c4(car)
{
	car endon(#"destructible_base_piece_death");
	car endon(#"car_dead");
	car endon(#"death");
	self endon(#"death");
	self waittill(#"hacked");
	self notify(#"picked_up");
	car thread car_grenade_stuck_explode(self);
}

/*
	Name: car_death_notify
	Namespace: destructible
	Checksum: 0xC8815DBB
	Offset: 0x1A58
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function car_death_notify()
{
	self endon(#"car_dead");
	self waittill(#"death", attacker);
	self notify(#"destructible_base_piece_death", attacker);
}

/*
	Name: codecallback_destructibleevent
	Namespace: destructible
	Checksum: 0xB501EA33
	Offset: 0x1AA0
	Size: 0x11C
	Parameters: 5
	Flags: Linked
*/
function codecallback_destructibleevent(event, param1, param2, param3, param4)
{
	if(event == "broken")
	{
		notify_type = param1;
		attacker = param2;
		piece = param3;
		weapon = param4;
		event_callback(notify_type, attacker, weapon);
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
	Checksum: 0x2D7AB1C2
	Offset: 0x1BC8
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
	Checksum: 0xA7A30C58
	Offset: 0x1C38
	Size: 0x1E4
	Parameters: 3
	Flags: Linked
*/
function explosive_incendiary_explosion(attacker, explosion_radius, var_34aa7e9b = 0)
{
	if(!isvehicle(self))
	{
		offset = vectorscale((0, 0, 1), 5);
		if(isdefined(attacker))
		{
			self radiusdamage(self.origin + offset, explosion_radius, 300, 10, attacker, "MOD_BURNED", getweapon("incendiary_fire"));
		}
		else
		{
			self radiusdamage(self.origin + offset, explosion_radius, 300, 10);
		}
		physics_explosion_and_rumble(self.origin, explosion_radius, 1, var_34aa7e9b);
		if(var_34aa7e9b)
		{
			level thread function_906eae90(self.origin, 80, 10);
		}
		else
		{
			level thread function_906eae90(self.origin, 50, 10);
		}
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
	Name: function_906eae90
	Namespace: destructible
	Checksum: 0xE30D7A2E
	Offset: 0x1E28
	Size: 0x84
	Parameters: 3
	Flags: Linked
*/
function function_906eae90(v_origin, n_radius, n_time)
{
	e_trig = spawn("trigger_radius_hurt", v_origin, 0, n_radius, n_radius);
	e_trig.script_hazard = "heat";
	wait(n_time);
	e_trig delete();
}

/*
	Name: explosive_electrical_explosion
	Namespace: destructible
	Checksum: 0xDFDF4049
	Offset: 0x1EB8
	Size: 0x164
	Parameters: 3
	Flags: Linked
*/
function explosive_electrical_explosion(attacker, explosion_radius, var_34aa7e9b)
{
	if(!isvehicle(self))
	{
		offset = vectorscale((0, 0, 1), 5);
		if(isdefined(attacker))
		{
			self radiusdamage(self.origin + offset, explosion_radius, 300, 10, attacker, "MOD_ELECTROCUTED");
		}
		else
		{
			self radiusdamage(self.origin + offset, explosion_radius, 300, 10);
		}
		physics_explosion_and_rumble(self.origin, explosion_radius, 1, var_34aa7e9b);
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
	Checksum: 0x53764405
	Offset: 0x2028
	Size: 0x164
	Parameters: 3
	Flags: Linked
*/
function explosive_concussive_explosion(attacker, explosion_radius, var_34aa7e9b)
{
	if(!isvehicle(self))
	{
		offset = vectorscale((0, 0, 1), 5);
		if(isdefined(attacker))
		{
			self radiusdamage(self.origin + offset, explosion_radius, 300, 10, attacker, "MOD_GRENADE");
		}
		else
		{
			self radiusdamage(self.origin + offset, explosion_radius, 300, 10);
		}
		physics_explosion_and_rumble(self.origin, explosion_radius, 1, var_34aa7e9b);
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

