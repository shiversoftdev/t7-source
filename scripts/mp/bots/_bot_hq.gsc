// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\bots\_bot;
#using scripts\mp\bots\_bot_combat;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#namespace bot_hq;

/*
	Name: hq_think
	Namespace: bot_hq
	Checksum: 0xB2405AE5
	Offset: 0x140
	Size: 0x1E4
	Parameters: 0
	Flags: None
*/
function hq_think()
{
	time = gettime();
	if(time < self.bot.update_objective)
	{
		return;
	}
	self.bot.update_objective = time + randomintrange(500, 1500);
	if(should_patrol_hq())
	{
		self patrol_hq();
	}
	else if(!has_hq_goal())
	{
		self move_to_hq();
	}
	if(self is_capturing_hq())
	{
		self capture_hq();
	}
	hq_tactical_insertion();
	hq_grenade();
	if(!is_capturing_hq() && !self atgoal("hq_patrol"))
	{
		mine = getnearestnode(self.origin);
		point = hq_nearest_point();
		if(isdefined(mine) && bot::navmesh_points_visible(mine.origin, point))
		{
			self lookat(level.radio.baseorigin + vectorscale((0, 0, 1), 30));
		}
	}
}

/*
	Name: has_hq_goal
	Namespace: bot_hq
	Checksum: 0x1F7B0318
	Offset: 0x330
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function has_hq_goal()
{
	origin = self getgoal("hq_radio");
	if(isdefined(origin))
	{
		foreach(point in level.radio.points)
		{
			if(distancesquared(origin, point) < 4096)
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: is_capturing_hq
	Namespace: bot_hq
	Checksum: 0x1F469E7E
	Offset: 0x420
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function is_capturing_hq()
{
	return self atgoal("hq_radio");
}

/*
	Name: should_patrol_hq
	Namespace: bot_hq
	Checksum: 0x36F66449
	Offset: 0x450
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function should_patrol_hq()
{
	if(level.radio.gameobject.ownerteam == "neutral")
	{
		return false;
	}
	if(level.radio.gameobject.ownerteam != self.team)
	{
		return false;
	}
	if(hq_is_contested())
	{
		return false;
	}
	return true;
}

/*
	Name: patrol_hq
	Namespace: bot_hq
	Checksum: 0x738A72E7
	Offset: 0x4C8
	Size: 0x638
	Parameters: 0
	Flags: Linked
*/
function patrol_hq()
{
	self cancelgoal("hq_radio");
	if(self atgoal("hq_patrol"))
	{
		node = getnearestnode(self.origin);
		if(isdefined(node) && node.type == "Path")
		{
			self setstance("crouch");
		}
		else
		{
			self setstance("stand");
		}
		if(gettime() > self.bot.update_lookat)
		{
			origin = self get_look_at();
			z = 20;
			if(distancesquared(origin, self.origin) > 262144)
			{
				z = randomintrange(16, 60);
			}
			self lookat(origin + (0, 0, z));
			if(distancesquared(origin, self.origin) > 65536)
			{
				dir = vectornormalize(self.origin - origin);
				dir = vectorscale(dir, 256);
				origin = origin + dir;
			}
			self bot_combat::combat_throw_proximity(origin);
			self.bot.update_lookat = gettime() + randomintrange(1500, 3000);
		}
		goal = self getgoal("hq_patrol");
		nearest = hq_nearest_point();
		mine = getnearestnode(goal);
		if(isdefined(mine) && !bot::navmesh_points_visible(mine.origin, nearest))
		{
			self clearlookat();
			self cancelgoal("hq_patrol");
		}
		if(gettime() > self.bot.update_objective_patrol)
		{
			self clearlookat();
			self cancelgoal("hq_patrol");
		}
		return;
	}
	nearest = hq_nearest_point();
	if(self hasgoal("hq_patrol"))
	{
		goal = self getgoal("hq_patrol");
		if(distancesquared(self.origin, goal) < 65536)
		{
			origin = self get_look_at();
			self lookat(origin);
		}
		if(distancesquared(self.origin, goal) < 16384)
		{
			self.bot.update_objective_patrol = gettime() + randomintrange(3000, 6000);
		}
		mine = getnearestnode(goal);
		if(isdefined(mine) && !bot::navmesh_points_visible(mine.origin, nearest))
		{
			self clearlookat();
			self cancelgoal("hq_patrol");
		}
		return;
	}
	points = util::positionquery_pointarray(nearest, 0, 512, 70, 64);
	points = navpointsightfilter(points, nearest);
	/#
		assert(points.size);
	#/
	for(i = randomint(points.size); i < points.size; i++)
	{
		if(self bot::friend_goal_in_radius("hq_radio", points[i], 128) == 0)
		{
			if(self bot::friend_goal_in_radius("hq_patrol", points[i], 256) == 0)
			{
				self addgoal(points[i], 24, 3, "hq_patrol");
				return;
			}
		}
	}
}

/*
	Name: move_to_hq
	Namespace: bot_hq
	Checksum: 0x47C2E6CB
	Offset: 0xB08
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function move_to_hq()
{
	self clearlookat();
	self cancelgoal("hq_radio");
	self cancelgoal("hq_patrol");
	if(self getstance() == "prone")
	{
		self setstance("crouch");
		wait(0.25);
	}
	if(self getstance() == "crouch")
	{
		self setstance("stand");
		wait(0.25);
	}
	points = array::randomize(level.radio.points);
	foreach(point in points)
	{
		if(self bot::friend_goal_in_radius("hq_radio", point, 64) == 0)
		{
			self addgoal(point, 24, 3, "hq_radio");
			return;
		}
	}
	self addgoal(array::random(points), 24, 3, "hq_radio");
}

/*
	Name: get_look_at
	Namespace: bot_hq
	Checksum: 0x33777D41
	Offset: 0xD28
	Size: 0x232
	Parameters: 0
	Flags: Linked
*/
function get_look_at()
{
	enemy = self bot::get_closest_enemy(self.origin, 1);
	if(isdefined(enemy))
	{
		node = getvisiblenode(self.origin, enemy.origin);
		if(isdefined(node) && distancesquared(self.origin, node.origin) > 16384)
		{
			return node.origin;
		}
	}
	enemies = self bot::get_enemies(0);
	if(enemies.size)
	{
		enemy = array::random(enemies);
	}
	if(isdefined(enemy))
	{
		node = getvisiblenode(self.origin, enemy.origin);
		if(isdefined(node) && distancesquared(self.origin, node.origin) > 16384)
		{
			return node.origin;
		}
	}
	spawn = array::random(level.spawnpoints);
	node = getvisiblenode(self.origin, spawn.origin);
	if(isdefined(node) && distancesquared(self.origin, node.origin) > 16384)
	{
		return node.origin;
	}
	return level.radio.baseorigin;
}

/*
	Name: capture_hq
	Namespace: bot_hq
	Checksum: 0xC77FAD24
	Offset: 0xF68
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function capture_hq()
{
	self addgoal(self.origin, 24, 3, "hq_radio");
	self setstance("crouch");
	if(gettime() > self.bot.update_lookat)
	{
		origin = self get_look_at();
		z = 20;
		if(distancesquared(origin, self.origin) > 262144)
		{
			z = randomintrange(16, 60);
		}
		self lookat(origin + (0, 0, z));
		if(distancesquared(origin, self.origin) > 65536)
		{
			dir = vectornormalize(self.origin - origin);
			dir = vectorscale(dir, 256);
			origin = origin + dir;
		}
		self bot_combat::combat_throw_proximity(origin);
		self.bot.update_lookat = gettime() + randomintrange(1500, 3000);
	}
}

/*
	Name: any_other_team_touching
	Namespace: bot_hq
	Checksum: 0xE0E45D34
	Offset: 0x1148
	Size: 0xB6
	Parameters: 1
	Flags: Linked
*/
function any_other_team_touching(skip_team)
{
	foreach(team in level.teams)
	{
		if(team == skip_team)
		{
			continue;
		}
		if(level.radio.gameobject.numtouching[team])
		{
			return true;
		}
	}
	return false;
}

/*
	Name: is_hq_contested
	Namespace: bot_hq
	Checksum: 0x1546A980
	Offset: 0x1208
	Size: 0xA8
	Parameters: 1
	Flags: Linked
*/
function is_hq_contested(skip_team)
{
	if(any_other_team_touching(skip_team))
	{
		return true;
	}
	enemy = self bot::get_closest_enemy(level.radio.baseorigin, 1);
	if(isdefined(enemy) && distancesquared(enemy.origin, level.radio.baseorigin) < 262144)
	{
		return true;
	}
	return false;
}

/*
	Name: hq_grenade
	Namespace: bot_hq
	Checksum: 0x7389C65C
	Offset: 0x12B8
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function hq_grenade()
{
	enemies = bot::get_enemies();
	if(!enemies.size)
	{
		return;
	}
	if(self atgoal("hq_patrol") || self atgoal("hq_radio"))
	{
		if(self getweaponammostock(getweapon("proximity_grenade")) > 0)
		{
			origin = get_look_at();
			if(self bot_combat::combat_throw_proximity(origin))
			{
				return;
			}
		}
	}
	if(!is_hq_contested(self.team))
	{
		self bot_combat::combat_throw_smoke(level.radio.baseorigin);
		return;
	}
	enemy = self bot::get_closest_enemy(level.radio.baseorigin, 0);
	if(isdefined(enemy))
	{
		origin = enemy.origin;
	}
	else
	{
		origin = level.radio.baseorigin;
	}
	dir = vectornormalize(self.origin - origin);
	dir = (0, dir[1], 0);
	origin = origin + vectorscale(dir, 128);
	if(!self bot_combat::combat_throw_lethal(origin))
	{
		self bot_combat::combat_throw_tactical(origin);
	}
}

/*
	Name: hq_tactical_insertion
	Namespace: bot_hq
	Checksum: 0x686161E
	Offset: 0x14D8
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function hq_tactical_insertion()
{
	if(!self hasweapon(getweapon("tactical_insertion")))
	{
		return;
	}
	dist = self getlookaheaddist();
	dir = self getlookaheaddir();
	if(!isdefined(dist) || !isdefined(dir))
	{
		return;
	}
	point = hq_nearest_point();
	mine = getnearestnode(self.origin);
	if(isdefined(mine) && !bot::navmesh_points_visible(mine.origin, point))
	{
		origin = self.origin + vectorscale(dir, dist);
		next = getnearestnode(origin);
		if(isdefined(next) && bot::navmesh_points_visible(next.origin, point))
		{
			bot_combat::combat_tactical_insertion(self.origin);
		}
	}
}

/*
	Name: hq_nearest_point
	Namespace: bot_hq
	Checksum: 0xE24F241
	Offset: 0x1668
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function hq_nearest_point()
{
	return array::random(level.radio.points);
}

/*
	Name: hq_is_contested
	Namespace: bot_hq
	Checksum: 0xA3C46D17
	Offset: 0x1698
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function hq_is_contested()
{
	enemy = self bot::get_closest_enemy(level.radio.baseorigin, 0);
	return isdefined(enemy) && distancesquared(enemy.origin, level.radio.baseorigin) < (level.radio.node_radius * level.radio.node_radius);
}

