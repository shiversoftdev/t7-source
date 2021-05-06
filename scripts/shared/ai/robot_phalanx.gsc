// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;

#namespace robotphalanx;

/*
	Name: _assignphalanxstance
	Namespace: robotphalanx
	Checksum: 0xD2C9FD3B
	Offset: 0x268
	Size: 0xF2
	Parameters: 2
	Flags: Private
*/
private function _assignphalanxstance(robots, stance)
{
	/#
		assert(isarray(robots));
	#/
	foreach(index, robot in robots)
	{
		if(isdefined(robot) && isalive(robot))
		{
			robot ai::set_behavior_attribute("phalanx_force_stance", stance);
		}
	}
}

/*
	Name: _createphalanxtier
	Namespace: robotphalanx
	Checksum: 0xFABDF871
	Offset: 0x368
	Size: 0x260
	Parameters: 6
	Flags: Private
*/
private function _createphalanxtier(phalanxtype, tier, phalanxposition, forward, maxtiersize, spawner = undefined)
{
	robots = [];
	if(!isspawner(spawner))
	{
		spawner = _getphalanxspawner(tier);
	}
	positions = _getphalanxpositions(phalanxtype, tier);
	angles = vectortoangles(forward);
	foreach(index, position in positions)
	{
		if(index >= maxtiersize)
		{
			break;
		}
		orientedpos = _rotatevec(position, angles[1] - 90);
		navmeshposition = getclosestpointonnavmesh(phalanxposition + orientedpos, 200);
		if(!spawner.spawnflags & 64)
		{
			spawner.count++;
		}
		robot = spawner spawner::spawn(1, "", navmeshposition, angles);
		if(isalive(robot))
		{
			_initializerobot(robot);
			wait(0.05);
			robots[robots.size] = robot;
		}
	}
	return robots;
}

/*
	Name: _dampenexplosivedamage
	Namespace: robotphalanx
	Checksum: 0x6F1E95CB
	Offset: 0x5D0
	Size: 0x1C8
	Parameters: 12
	Flags: Private
*/
private function _dampenexplosivedamage(inflictor, attacker, damage, flags, meansofdamage, weapon, point, dir, hitloc, offsettime, boneindex, modelindex)
{
	entity = self;
	isexplosive = isinarray(array("MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTILE_SPLASH", "MOD_EXPLOSIVE"), meansofdamage);
	if(isexplosive && isdefined(inflictor) && isdefined(inflictor.weapon))
	{
		weapon = inflictor.weapon;
		distancetoentity = distance(entity.origin, inflictor.origin);
		fractiondistance = 1;
		if(weapon.explosionradius > 0)
		{
			fractiondistance = weapon.explosionradius - distancetoentity / weapon.explosionradius;
		}
		return int(max(damage * fractiondistance, 1));
	}
	return damage;
}

/*
	Name: _getphalanxpositions
	Namespace: robotphalanx
	Checksum: 0x37E389C4
	Offset: 0x7A0
	Size: 0x4E4
	Parameters: 2
	Flags: Private
*/
private function _getphalanxpositions(phalanxtype, tier)
{
	switch(phalanxtype)
	{
		case "phanalx_wedge":
		{
			switch(tier)
			{
				case "phalanx_tier1":
				{
					return array((0, 0, 0), (-64, -48, 0), (64, -48, 0), (-128, -96, 0), (128, -96, 0));
				}
				case "phalanx_tier2":
				{
					return array((-32, -96, 0), (32, -96, 0));
				}
				case "phalanx_tier3":
				{
					return array();
				}
			}
			jump loc_00000928;
		}
		case "phalanx_diagonal_left":
		{
			switch(tier)
			{
				case "phalanx_tier1":
				{
					return array((0, 0, 0), (-48, -64, 0), (-96, -128, 0), (-144, -192, 0));
				}
				case "phalanx_tier2":
				{
					return array(vectorscale((1, 0, 0), 64), (16, -64, 0), (-48, -128, 0), (-112, -192, 0));
				}
				case "phalanx_tier3":
				{
					return array();
				}
			}
			loc_00000928:
			jump loc_000009E8;
		}
		case "phalanx_diagonal_right":
		{
			switch(tier)
			{
				case "phalanx_tier1":
				{
					return array((0, 0, 0), (48, -64, 0), (96, -128, 0), (144, -192, 0));
				}
				case "phalanx_tier2":
				{
					return array(vectorscale((-1, 0, 0), 64), (-16, -64, 0), (48, -128, 0), (112, -192, 0));
				}
				case "phalanx_tier3":
				{
					return array();
				}
			}
			loc_000009E8:
			jump loc_00000AA0;
		}
		case "phalanx_forward":
		{
			switch(tier)
			{
				case "phalanx_tier1":
				{
					return array((0, 0, 0), vectorscale((1, 0, 0), 64), vectorscale((1, 0, 0), 128), vectorscale((1, 0, 0), 192));
				}
				case "phalanx_tier2":
				{
					return array((-32, -64, 0), (32, -64, 0), (96, -64, 0), (160, -64, 0));
				}
				case "phalanx_tier3":
				{
					return array();
				}
			}
			loc_00000AA0:
			jump loc_00000B60;
		}
		case "phalanx_column":
		{
			switch(tier)
			{
				case "phalanx_tier1":
				{
					return array((0, 0, 0), vectorscale((-1, 0, 0), 64), vectorscale((0, -1, 0), 64), vectorscale((-1, -1, 0), 64));
				}
				case "phalanx_tier2":
				{
					return array(vectorscale((0, -1, 0), 128), (-64, -128, 0), vectorscale((0, -1, 0), 192), (-64, -192, 0));
				}
				case "phalanx_tier3":
				{
					return array();
				}
			}
			loc_00000B60:
			jump loc_00000BE8;
		}
		case "phalanx_column_right":
		{
			switch(tier)
			{
				case "phalanx_tier1":
				{
					return array((0, 0, 0), vectorscale((0, -1, 0), 64), vectorscale((0, -1, 0), 128), vectorscale((0, -1, 0), 192));
				}
				case "phalanx_tier2":
				{
					return array();
				}
				case "phalanx_tier3":
				{
					return array();
				}
			}
			loc_00000BE8:
			break;
		}
		default:
		{
			/#
				assert("" + phalanxtype + "");
			#/
		}
	}
	/#
		assert("" + tier + "");
	#/
}

/*
	Name: _getphalanxspawner
	Namespace: robotphalanx
	Checksum: 0x9657D2F5
	Offset: 0xC90
	Size: 0xBC
	Parameters: 1
	Flags: Private
*/
private function _getphalanxspawner(tier)
{
	spawner = getspawnerarray(tier, "targetname");
	/#
		assert(spawner.size >= 0, "" + "" + "");
	#/
	/#
		assert(spawner.size == 1, "" + "" + "");
	#/
	return spawner[0];
}

/*
	Name: _haltadvance
	Namespace: robotphalanx
	Checksum: 0xE88AC232
	Offset: 0xD58
	Size: 0x14A
	Parameters: 1
	Flags: Private
*/
private function _haltadvance(robots)
{
	/#
		assert(isarray(robots));
	#/
	foreach(index, robot in robots)
	{
		if(isdefined(robot) && isalive(robot) && robot haspath())
		{
			navmeshposition = getclosestpointonnavmesh(robot.origin, 200);
			robot useposition(navmeshposition);
			robot clearpath();
		}
	}
}

/*
	Name: _haltfire
	Namespace: robotphalanx
	Checksum: 0x48FFF1E8
	Offset: 0xEB0
	Size: 0xDE
	Parameters: 1
	Flags: Private
*/
private function _haltfire(robots)
{
	/#
		assert(isarray(robots));
	#/
	foreach(index, robot in robots)
	{
		if(isdefined(robot) && isalive(robot))
		{
			robot.ignoreall = 1;
		}
	}
}

/*
	Name: _initializerobot
	Namespace: robotphalanx
	Checksum: 0xC90CD839
	Offset: 0xF98
	Size: 0xEC
	Parameters: 1
	Flags: Private
*/
private function _initializerobot(robot)
{
	/#
		assert(isactor(robot));
	#/
	robot ai::set_behavior_attribute("phalanx", 1);
	robot ai::set_behavior_attribute("move_mode", "marching");
	robot ai::set_behavior_attribute("force_cover", 1);
	robot setavoidancemask("avoid none");
	aiutility::addaioverridedamagecallback(robot, &_dampenexplosivedamage, 1);
}

/*
	Name: _movephalanxtier
	Namespace: robotphalanx
	Checksum: 0x83D68CFC
	Offset: 0x1090
	Size: 0x212
	Parameters: 5
	Flags: Private
*/
private function _movephalanxtier(robots, phalanxtype, tier, destination, forward)
{
	positions = _getphalanxpositions(phalanxtype, tier);
	angles = vectortoangles(forward);
	/#
		assert(robots.size <= positions.size, "");
	#/
	foreach(index, robot in robots)
	{
		if(isdefined(robot) && isalive(robot))
		{
			/#
				assert(isvec(positions[index]), "" + index + "" + tier + "" + phalanxtype);
			#/
			orientedpos = _rotatevec(positions[index], angles[1] - 90);
			navmeshposition = getclosestpointonnavmesh(destination + orientedpos, 200);
			robot useposition(navmeshposition);
		}
	}
}

/*
	Name: _prunedead
	Namespace: robotphalanx
	Checksum: 0x75C7FF0D
	Offset: 0x12B0
	Size: 0xC0
	Parameters: 1
	Flags: Private
*/
private function _prunedead(robots)
{
	liverobots = [];
	foreach(index, robot in robots)
	{
		if(isdefined(robot) && isalive(robot))
		{
			liverobots[index] = robot;
		}
	}
	return liverobots;
}

/*
	Name: _releaserobot
	Namespace: robotphalanx
	Checksum: 0x92772E2B
	Offset: 0x1378
	Size: 0x134
	Parameters: 1
	Flags: Private
*/
private function _releaserobot(robot)
{
	if(isdefined(robot) && isalive(robot))
	{
		robot clearuseposition();
		robot pathmode("move delayed", 1, randomfloatrange(0.5, 1));
		robot ai::set_behavior_attribute("phalanx", 0);
		wait(0.05);
		robot ai::set_behavior_attribute("move_mode", "normal");
		robot ai::set_behavior_attribute("force_cover", 0);
		robot setavoidancemask("avoid all");
		aiutility::removeaioverridedamagecallback(robot, &_dampenexplosivedamage);
	}
}

/*
	Name: _releaserobots
	Namespace: robotphalanx
	Checksum: 0x110463EC
	Offset: 0x14B8
	Size: 0xCA
	Parameters: 1
	Flags: Private
*/
private function _releaserobots(robots)
{
	foreach(index, robot in robots)
	{
		_resumefire(robot);
		_releaserobot(robot);
		wait(randomfloatrange(0.5, 5));
	}
}

/*
	Name: _resumefire
	Namespace: robotphalanx
	Checksum: 0x36F8D4D8
	Offset: 0x1590
	Size: 0x40
	Parameters: 1
	Flags: Private
*/
private function _resumefire(robot)
{
	if(isdefined(robot) && isalive(robot))
	{
		robot.ignoreall = 0;
	}
}

/*
	Name: _resumefirerobots
	Namespace: robotphalanx
	Checksum: 0xD481A9FD
	Offset: 0x15D8
	Size: 0xC2
	Parameters: 1
	Flags: Private
*/
private function _resumefirerobots(robots)
{
	/#
		assert(isarray(robots));
	#/
	foreach(index, robot in robots)
	{
		_resumefire(robot);
	}
}

/*
	Name: _rotatevec
	Namespace: robotphalanx
	Checksum: 0xBD4B7A70
	Offset: 0x16A8
	Size: 0xA0
	Parameters: 2
	Flags: Private
*/
private function _rotatevec(vector, angle)
{
	return (vector[0] * cos(angle) - vector[1] * sin(angle), vector[0] * sin(angle) + vector[1] * cos(angle), vector[2]);
}

/*
	Name: _updatephalanxthread
	Namespace: robotphalanx
	Checksum: 0xF304CCE7
	Offset: 0x1750
	Size: 0x28
	Parameters: 1
	Flags: Private
*/
private function _updatephalanxthread(phalanx)
{
	while([[ phalanx ]]->_updatephalanx())
	{
		wait(1);
	}
}

/*
	Name: __constructor
	Namespace: robotphalanx
	Checksum: 0x739FBA53
	Offset: 0x1780
	Size: 0x58
	Parameters: 0
	Flags: None
*/
function __constructor()
{
	self.tier1robots_ = [];
	self.tier2robots_ = [];
	self.tier3robots_ = [];
	self.startrobotcount_ = 0;
	self.currentrobotcount_ = 0;
	self.breakingpoint_ = 0;
	self.scattered_ = 0;
}

/*
	Name: __destructor
	Namespace: robotphalanx
	Checksum: 0x99EC1590
	Offset: 0x17E0
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function __destructor()
{
}

/*
	Name: _updatephalanx
	Namespace: robotphalanx
	Checksum: 0x2472769D
	Offset: 0x17F0
	Size: 0xD4
	Parameters: 0
	Flags: Private
*/
private function _updatephalanx()
{
	if(self.scattered_)
	{
		return 0;
	}
	self.tier1robots_ = _prunedead(self.tier1robots_);
	self.tier2robots_ = _prunedead(self.tier2robots_);
	self.tier3robots_ = _prunedead(self.tier3robots_);
	self.currentrobotcount_ = self.tier1robots_.size + self.tier2robots_.size + self.tier2robots_.size;
	if(self.currentrobotcount_ <= self.startrobotcount_ - self.breakingpoint_)
	{
		scatterphalanx();
		return 0;
	}
	return 1;
}

/*
	Name: haltfire
	Namespace: robotphalanx
	Checksum: 0x4550017C
	Offset: 0x18D0
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function haltfire()
{
	_haltfire(self.tier1robots_);
	_haltfire(self.tier2robots_);
	_haltfire(self.tier3robots_);
}

/*
	Name: haltadvance
	Namespace: robotphalanx
	Checksum: 0xA42156B8
	Offset: 0x1928
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function haltadvance()
{
	if(!self.scattered_)
	{
		_haltadvance(self.tier1robots_);
		_haltadvance(self.tier2robots_);
		_haltadvance(self.tier3robots_);
	}
}

/*
	Name: initialize
	Namespace: robotphalanx
	Checksum: 0x24B3DE30
	Offset: 0x1988
	Size: 0x35C
	Parameters: 8
	Flags: None
*/
function initialize(phalanxtype, origin, destination, breakingpoint, maxtiersize = 10, tieronespawner = undefined, tiertwospawner = undefined, tierthreespawner = undefined)
{
	/#
		assert(isstring(phalanxtype));
	#/
	/#
		assert(isint(breakingpoint));
	#/
	/#
		assert(isvec(origin));
	#/
	/#
		assert(isvec(destination));
	#/
	maxtiersize = math::clamp(maxtiersize, 1, 10);
	forward = vectornormalize(destination - origin);
	self.tier1robots_ = _createphalanxtier(phalanxtype, "phalanx_tier1", origin, forward, maxtiersize, tieronespawner);
	self.tier2robots_ = _createphalanxtier(phalanxtype, "phalanx_tier2", origin, forward, maxtiersize, tiertwospawner);
	self.tier3robots_ = _createphalanxtier(phalanxtype, "phalanx_tier3", origin, forward, maxtiersize, tierthreespawner);
	_assignphalanxstance(self.tier1robots_, "crouch");
	_movephalanxtier(self.tier1robots_, phalanxtype, "phalanx_tier1", destination, forward);
	_movephalanxtier(self.tier2robots_, phalanxtype, "phalanx_tier2", destination, forward);
	_movephalanxtier(self.tier3robots_, phalanxtype, "phalanx_tier3", destination, forward);
	self.startrobotcount_ = self.tier1robots_.size + self.tier2robots_.size + self.tier3robots_.size;
	self.breakingpoint_ = breakingpoint;
	self.startposition_ = origin;
	self.endposition_ = destination;
	self.phalanxtype_ = phalanxtype;
	self thread _updatephalanxthread(self);
}

/*
	Name: resumeadvance
	Namespace: robotphalanx
	Checksum: 0xDE707302
	Offset: 0x1CF0
	Size: 0x124
	Parameters: 0
	Flags: None
*/
function resumeadvance()
{
	if(!self.scattered_)
	{
		_assignphalanxstance(self.tier1robots_, "stand");
		wait(1);
		forward = vectornormalize(self.endposition_ - self.startposition_);
		_movephalanxtier(self.tier1robots_, self.phalanxtype_, "phalanx_tier1", self.endposition_, forward);
		_movephalanxtier(self.tier2robots_, self.phalanxtype_, "phalanx_tier2", self.endposition_, forward);
		_movephalanxtier(self.tier3robots_, self.phalanxtype_, "phalanx_tier3", self.endposition_, forward);
		_assignphalanxstance(self.tier1robots_, "crouch");
	}
}

/*
	Name: resumefire
	Namespace: robotphalanx
	Checksum: 0xAC88A1F4
	Offset: 0x1E20
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function resumefire()
{
	_resumefirerobots(self.tier1robots_);
	_resumefirerobots(self.tier2robots_);
	_resumefirerobots(self.tier3robots_);
}

/*
	Name: scatterphalanx
	Namespace: robotphalanx
	Checksum: 0x2FF433D6
	Offset: 0x1E78
	Size: 0x100
	Parameters: 0
	Flags: None
*/
function scatterphalanx()
{
	if(!self.scattered_)
	{
		self.scattered_ = 1;
		_releaserobots(self.tier1robots_);
		self.tier1robots_ = [];
		_assignphalanxstance(self.tier2robots_, "crouch");
		wait(randomfloatrange(5, 7));
		_releaserobots(self.tier2robots_);
		self.tier2robots_ = [];
		_assignphalanxstance(self.tier3robots_, "crouch");
		wait(randomfloatrange(5, 7));
		_releaserobots(self.tier3robots_);
		self.tier3robots_ = [];
	}
}

/*
	Name: robotphalanx
	Namespace: robotphalanx
	Checksum: 0x4EC8CEA1
	Offset: 0x1F80
	Size: 0x4D6
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function robotphalanx()
{
	classes.robotphalanx[0] = spawnstruct();
	classes.robotphalanx[0].__vtable[228897961] = &scatterphalanx;
	classes.robotphalanx[0].__vtable[2087719912] = &resumefire;
	classes.robotphalanx[0].__vtable[1720367946] = &resumeadvance;
	classes.robotphalanx[0].__vtable[-422924033] = &initialize;
	classes.robotphalanx[0].__vtable[1167879746] = &haltadvance;
	classes.robotphalanx[0].__vtable[-2118610224] = &haltfire;
	classes.robotphalanx[0].__vtable[972280915] = &_updatephalanx;
	classes.robotphalanx[0].__vtable[1606033458] = &__destructor;
	classes.robotphalanx[0].__vtable[-1690805083] = &__constructor;
	classes.robotphalanx[0].__vtable[-381269537] = &_updatephalanxthread;
	classes.robotphalanx[0].__vtable[-362582783] = &_rotatevec;
	classes.robotphalanx[0].__vtable[1581873510] = &_resumefirerobots;
	classes.robotphalanx[0].__vtable[-1629199683] = &_resumefire;
	classes.robotphalanx[0].__vtable[-513305948] = &_releaserobots;
	classes.robotphalanx[0].__vtable[-1080422827] = &_releaserobot;
	classes.robotphalanx[0].__vtable[1001347994] = &_prunedead;
	classes.robotphalanx[0].__vtable[1972227195] = &_movephalanxtier;
	classes.robotphalanx[0].__vtable[-1954370578] = &_initializerobot;
	classes.robotphalanx[0].__vtable[-501039299] = &_haltfire;
	classes.robotphalanx[0].__vtable[1576816289] = &_haltadvance;
	classes.robotphalanx[0].__vtable[1383035786] = &_getphalanxspawner;
	classes.robotphalanx[0].__vtable[-34869766] = &_getphalanxpositions;
	classes.robotphalanx[0].__vtable[2037194283] = &_dampenexplosivedamage;
	classes.robotphalanx[0].__vtable[-1045739606] = &_createphalanxtier;
	classes.robotphalanx[0].__vtable[-1604255525] = &_assignphalanxstance;
}

