// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;

#namespace phalanx;

/*
	Name: _assignphalanxstance
	Namespace: phalanx
	Checksum: 0xB2AEF026
	Offset: 0x280
	Size: 0xF2
	Parameters: 2
	Flags: Private
*/
private function _assignphalanxstance(sentients, stance)
{
	/#
		assert(isarray(sentients));
	#/
	foreach(index, sentient in sentients)
	{
		if(isdefined(sentient) && isalive(sentient))
		{
			sentient ai::set_behavior_attribute("phalanx_force_stance", stance);
		}
	}
}

/*
	Name: _createphalanxtier
	Namespace: phalanx
	Checksum: 0x4FF4C826
	Offset: 0x380
	Size: 0x248
	Parameters: 6
	Flags: Private
*/
private function _createphalanxtier(phalanxtype, tier, phalanxposition, forward, maxtiersize, spawner = undefined)
{
	sentients = [];
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
		sentient = spawner spawner::spawn(1, "", navmeshposition, angles);
		_initializesentient(sentient);
		wait(0.05);
		sentients[sentients.size] = sentient;
	}
	return sentients;
}

/*
	Name: _dampenexplosivedamage
	Namespace: phalanx
	Checksum: 0x2F4A405B
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
	Namespace: phalanx
	Checksum: 0x137C7964
	Offset: 0x7A0
	Size: 0x574
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
			jump loc_000008F0;
		}
		case "phalanx_reverse_wedge":
		{
			switch(tier)
			{
				case "phalanx_tier1":
				{
					return array(vectorscale((-1, 0, 0), 32), vectorscale((1, 0, 0), 32));
				}
				case "phalanx_tier2":
				{
					return array(vectorscale((0, -1, 0), 96));
				}
				case "phalanx_tier3":
				{
					return array();
				}
			}
			loc_000008F0:
			jump loc_000009B0;
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
			loc_000009B0:
			jump loc_00000A70;
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
			loc_00000A70:
			jump loc_00000B28;
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
			loc_00000B28:
			jump loc_00000BE8;
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
			loc_00000BE8:
			jump loc_00000C70;
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
			loc_00000C70:
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
	Namespace: phalanx
	Checksum: 0xF7443407
	Offset: 0xD20
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
	Namespace: phalanx
	Checksum: 0xA30A51AC
	Offset: 0xDE8
	Size: 0x14A
	Parameters: 1
	Flags: Private
*/
private function _haltadvance(sentients)
{
	/#
		assert(isarray(sentients));
	#/
	foreach(index, sentient in sentients)
	{
		if(isdefined(sentient) && isalive(sentient) && sentient haspath())
		{
			navmeshposition = getclosestpointonnavmesh(sentient.origin, 200);
			sentient useposition(navmeshposition);
			sentient clearpath();
		}
	}
}

/*
	Name: _haltfire
	Namespace: phalanx
	Checksum: 0xF92052A6
	Offset: 0xF40
	Size: 0xDE
	Parameters: 1
	Flags: Private
*/
private function _haltfire(sentients)
{
	/#
		assert(isarray(sentients));
	#/
	foreach(index, sentient in sentients)
	{
		if(isdefined(sentient) && isalive(sentient))
		{
			sentient.ignoreall = 1;
		}
	}
}

/*
	Name: _initializesentient
	Namespace: phalanx
	Checksum: 0x1CC79723
	Offset: 0x1028
	Size: 0x144
	Parameters: 1
	Flags: None
*/
function _initializesentient(sentient)
{
	/#
		assert(isactor(sentient));
	#/
	sentient ai::set_behavior_attribute("phalanx", 1);
	if(sentient.archetype === "human")
	{
		sentient.allowpain = 0;
	}
	sentient setavoidancemask("avoid none");
	if(isdefined(sentient.archetype) && sentient.archetype == "robot")
	{
		sentient ai::set_behavior_attribute("move_mode", "marching");
		sentient ai::set_behavior_attribute("force_cover", 1);
	}
	aiutility::addaioverridedamagecallback(sentient, &_dampenexplosivedamage, 1);
}

/*
	Name: _movephalanxtier
	Namespace: phalanx
	Checksum: 0x9403F38E
	Offset: 0x1178
	Size: 0x212
	Parameters: 5
	Flags: Private
*/
private function _movephalanxtier(sentients, phalanxtype, tier, destination, forward)
{
	positions = _getphalanxpositions(phalanxtype, tier);
	angles = vectortoangles(forward);
	/#
		assert(sentients.size <= positions.size, "");
	#/
	foreach(index, sentient in sentients)
	{
		if(isdefined(sentient) && isalive(sentient))
		{
			/#
				assert(isvec(positions[index]), "" + index + "" + tier + "" + phalanxtype);
			#/
			orientedpos = _rotatevec(positions[index], angles[1] - 90);
			navmeshposition = getclosestpointonnavmesh(destination + orientedpos, 200);
			sentient useposition(navmeshposition);
		}
	}
}

/*
	Name: _prunedead
	Namespace: phalanx
	Checksum: 0x3C13C3A6
	Offset: 0x1398
	Size: 0xC0
	Parameters: 1
	Flags: Private
*/
private function _prunedead(sentients)
{
	livesentients = [];
	foreach(index, sentient in sentients)
	{
		if(isdefined(sentient) && isalive(sentient))
		{
			livesentients[index] = sentient;
		}
	}
	return livesentients;
}

/*
	Name: _releasesentient
	Namespace: phalanx
	Checksum: 0x62EB1995
	Offset: 0x1460
	Size: 0x194
	Parameters: 1
	Flags: Private
*/
private function _releasesentient(sentient)
{
	if(isdefined(sentient) && isalive(sentient))
	{
		sentient clearuseposition();
		sentient pathmode("move delayed", 1, randomfloatrange(0.5, 1));
		sentient ai::set_behavior_attribute("phalanx", 0);
		wait(0.05);
		if(sentient.archetype === "human")
		{
			sentient.allowpain = 1;
		}
		sentient setavoidancemask("avoid all");
		aiutility::removeaioverridedamagecallback(sentient, &_dampenexplosivedamage);
		if(isdefined(sentient.archetype) && sentient.archetype == "robot")
		{
			sentient ai::set_behavior_attribute("move_mode", "normal");
			sentient ai::set_behavior_attribute("force_cover", 0);
		}
	}
}

/*
	Name: _releasesentients
	Namespace: phalanx
	Checksum: 0x4AA02EDF
	Offset: 0x1600
	Size: 0xCA
	Parameters: 1
	Flags: Private
*/
private function _releasesentients(sentients)
{
	foreach(index, sentient in sentients)
	{
		_resumefire(sentient);
		_releasesentient(sentient);
		wait(randomfloatrange(0.5, 5));
	}
}

/*
	Name: _resumefire
	Namespace: phalanx
	Checksum: 0x63C49BD1
	Offset: 0x16D8
	Size: 0x40
	Parameters: 1
	Flags: Private
*/
private function _resumefire(sentient)
{
	if(isdefined(sentient) && isalive(sentient))
	{
		sentient.ignoreall = 0;
	}
}

/*
	Name: _resumefiresentients
	Namespace: phalanx
	Checksum: 0xC5BF8D1F
	Offset: 0x1720
	Size: 0xC2
	Parameters: 1
	Flags: Private
*/
private function _resumefiresentients(sentients)
{
	/#
		assert(isarray(sentients));
	#/
	foreach(index, sentient in sentients)
	{
		_resumefire(sentient);
	}
}

/*
	Name: _rotatevec
	Namespace: phalanx
	Checksum: 0xFFDD27CC
	Offset: 0x17F0
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
	Namespace: phalanx
	Checksum: 0xC2391823
	Offset: 0x1898
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
	Namespace: phalanx
	Checksum: 0x6E402192
	Offset: 0x18C8
	Size: 0x40
	Parameters: 0
	Flags: None
*/
function __constructor()
{
	self.sentienttiers_ = [];
	self.startsentientcount_ = 0;
	self.currentsentientcount_ = 0;
	self.breakingpoint_ = 0;
	self.scattered_ = 0;
}

/*
	Name: __destructor
	Namespace: phalanx
	Checksum: 0x99EC1590
	Offset: 0x1910
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function __destructor()
{
}

/*
	Name: _updatephalanx
	Namespace: phalanx
	Checksum: 0x951D7949
	Offset: 0x1920
	Size: 0x10C
	Parameters: 0
	Flags: Private
*/
private function _updatephalanx()
{
	if(self.scattered_)
	{
		return 0;
	}
	self.currentsentientcount_ = 0;
	foreach(name, tier in self.sentienttiers_)
	{
		self.sentienttiers_[name] = _prunedead(tier);
		self.currentsentientcount_ = self.currentsentientcount_ + self.sentienttiers_[name].size;
	}
	if(self.currentsentientcount_ <= self.startsentientcount_ - self.breakingpoint_)
	{
		scatterphalanx();
		return 0;
	}
	return 1;
}

/*
	Name: haltfire
	Namespace: phalanx
	Checksum: 0x3EC579A5
	Offset: 0x1A38
	Size: 0x8A
	Parameters: 0
	Flags: None
*/
function haltfire()
{
	foreach(name, tier in self.sentienttiers_)
	{
		_haltfire(tier);
	}
}

/*
	Name: haltadvance
	Namespace: phalanx
	Checksum: 0xFF39D917
	Offset: 0x1AD0
	Size: 0x9A
	Parameters: 0
	Flags: None
*/
function haltadvance()
{
	if(!self.scattered_)
	{
		foreach(name, tier in self.sentienttiers_)
		{
			_haltadvance(tier);
		}
	}
}

/*
	Name: initialize
	Namespace: phalanx
	Checksum: 0xCE283740
	Offset: 0x1B78
	Size: 0x3E4
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
	tierspawners = [];
	tierspawners["phalanx_tier1"] = tieronespawner;
	tierspawners["phalanx_tier2"] = tiertwospawner;
	tierspawners["phalanx_tier3"] = tierthreespawner;
	maxtiersize = math::clamp(maxtiersize, 1, 10);
	forward = vectornormalize(destination - origin);
	foreach(var_205db64a, tiername in array("phalanx_tier1", "phalanx_tier2", "phalanx_tier3"))
	{
		self.sentienttiers_[tiername] = _createphalanxtier(phalanxtype, tiername, origin, forward, maxtiersize, tierspawners[tiername]);
		self.startsentientcount_ = self.startsentientcount_ + self.sentienttiers_[tiername].size;
	}
	_assignphalanxstance(self.sentienttiers_["phalanx_tier1"], "crouch");
	foreach(name, tier in self.sentienttiers_)
	{
		_movephalanxtier(self.sentienttiers_[name], phalanxtype, name, destination, forward);
	}
	self.breakingpoint_ = breakingpoint;
	self.startposition_ = origin;
	self.endposition_ = destination;
	self.phalanxtype_ = phalanxtype;
	self thread _updatephalanxthread(self);
}

/*
	Name: resumeadvance
	Namespace: phalanx
	Checksum: 0x49DF480A
	Offset: 0x1F68
	Size: 0x164
	Parameters: 0
	Flags: None
*/
function resumeadvance()
{
	if(!self.scattered_)
	{
		_assignphalanxstance(self.sentienttiers_["phalanx_tier1"], "stand");
		wait(1);
		forward = vectornormalize(self.endposition_ - self.startposition_);
		_movephalanxtier(self.sentienttiers_["phalanx_tier1"], self.phalanxtype_, "phalanx_tier1", self.endposition_, forward);
		_movephalanxtier(self.sentienttiers_["phalanx_tier2"], self.phalanxtype_, "phalanx_tier2", self.endposition_, forward);
		_movephalanxtier(self.sentienttiers_["phalanx_tier3"], self.phalanxtype_, "phalanx_tier3", self.endposition_, forward);
		_assignphalanxstance(self.sentienttiers_["phalanx_tier1"], "crouch");
	}
}

/*
	Name: resumefire
	Namespace: phalanx
	Checksum: 0x2DE4AE11
	Offset: 0x20D8
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function resumefire()
{
	_resumefiresentients(self.sentienttiers_["phalanx_tier1"]);
	_resumefiresentients(self.sentienttiers_["phalanx_tier2"]);
	_resumefiresentients(self.sentienttiers_["phalanx_tier3"]);
}

/*
	Name: scatterphalanx
	Namespace: phalanx
	Checksum: 0xDEE1A0F
	Offset: 0x2160
	Size: 0x15A
	Parameters: 0
	Flags: None
*/
function scatterphalanx()
{
	if(!self.scattered_)
	{
		self.scattered_ = 1;
		_releasesentients(self.sentienttiers_["phalanx_tier1"]);
		self.sentienttiers_["phalanx_tier1"] = [];
		_assignphalanxstance(self.sentienttiers_["phalanx_tier2"], "crouch");
		wait(randomfloatrange(5, 7));
		_releasesentients(self.sentienttiers_["phalanx_tier2"]);
		self.sentienttiers_["phalanx_tier2"] = [];
		_assignphalanxstance(self.sentienttiers_["phalanx_tier3"], "crouch");
		wait(randomfloatrange(5, 7));
		_releasesentients(self.sentienttiers_["phalanx_tier3"]);
		self.sentienttiers_["phalanx_tier3"] = [];
	}
}

/*
	Name: phalanx
	Namespace: phalanx
	Checksum: 0xA20418EF
	Offset: 0x22C8
	Size: 0x4D6
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function phalanx()
{
	classes.phalanx[0] = spawnstruct();
	classes.phalanx[0].__vtable[228897961] = &scatterphalanx;
	classes.phalanx[0].__vtable[2087719912] = &resumefire;
	classes.phalanx[0].__vtable[1720367946] = &resumeadvance;
	classes.phalanx[0].__vtable[-422924033] = &initialize;
	classes.phalanx[0].__vtable[1167879746] = &haltadvance;
	classes.phalanx[0].__vtable[-2118610224] = &haltfire;
	classes.phalanx[0].__vtable[972280915] = &_updatephalanx;
	classes.phalanx[0].__vtable[1606033458] = &__destructor;
	classes.phalanx[0].__vtable[-1690805083] = &__constructor;
	classes.phalanx[0].__vtable[-381269537] = &_updatephalanxthread;
	classes.phalanx[0].__vtable[-362582783] = &_rotatevec;
	classes.phalanx[0].__vtable[2035712678] = &_resumefiresentients;
	classes.phalanx[0].__vtable[-1629199683] = &_resumefire;
	classes.phalanx[0].__vtable[-894352604] = &_releasesentients;
	classes.phalanx[0].__vtable[-1608913963] = &_releasesentient;
	classes.phalanx[0].__vtable[1001347994] = &_prunedead;
	classes.phalanx[0].__vtable[1972227195] = &_movephalanxtier;
	classes.phalanx[0].__vtable[-920952828] = &_initializesentient;
	classes.phalanx[0].__vtable[-501039299] = &_haltfire;
	classes.phalanx[0].__vtable[1576816289] = &_haltadvance;
	classes.phalanx[0].__vtable[1383035786] = &_getphalanxspawner;
	classes.phalanx[0].__vtable[-34869766] = &_getphalanxpositions;
	classes.phalanx[0].__vtable[2037194283] = &_dampenexplosivedamage;
	classes.phalanx[0].__vtable[-1045739606] = &_createphalanxtier;
	classes.phalanx[0].__vtable[-1604255525] = &_assignphalanxstance;
}

