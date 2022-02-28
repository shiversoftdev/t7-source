// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\math_shared;

#namespace behaviortracker;

/*
	Name: setuptraits
	Namespace: behaviortracker
	Checksum: 0x14162BC9
	Offset: 0x1E0
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function setuptraits()
{
	if(isdefined(self.behaviortracker.traits))
	{
		return;
	}
	self.behaviortracker.traits = [];
	self.behaviortracker.traits["effectiveCombat"] = 0.5;
	self.behaviortracker.traits["effectiveWallRunCombat"] = 0.5;
	self.behaviortracker.traits["effectiveDoubleJumpCombat"] = 0.5;
	self.behaviortracker.traits["effectiveSlideCombat"] = 0.5;
	if(self.behaviortracker.version != 0)
	{
		traits = getarraykeys(self.behaviortracker.traits);
		for(i = 0; i < traits.size; i++)
		{
			trait = traits[i];
			self.behaviortracker.traits[trait] = float(self gettraitstatvalue(trait));
		}
	}
}

/*
	Name: initialize
	Namespace: behaviortracker
	Checksum: 0x19B1EF3D
	Offset: 0x370
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function initialize()
{
	if(isdefined(self.pers["isBot"]))
	{
		return;
	}
	if(isdefined(self.behaviortracker))
	{
		return;
	}
	if(isdefined(level.disablebehaviortracker) && level.disablebehaviortracker == 1)
	{
		return;
	}
	self.behaviortracker = spawnstruct();
	self.behaviortracker.version = int(self gettraitstatvalue("version"));
	self.behaviortracker.numrecords = int(self gettraitstatvalue("numRecords")) + 1;
	self setuptraits();
	self.behaviortracker.valid = 1;
}

/*
	Name: finalize
	Namespace: behaviortracker
	Checksum: 0x9A68C475
	Offset: 0x488
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function finalize()
{
	if(!self isallowed())
	{
		return;
	}
	self settraitstats();
	self printtrackertoblackbox();
}

/*
	Name: isallowed
	Namespace: behaviortracker
	Checksum: 0xD65B54D6
	Offset: 0x4E0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function isallowed()
{
	if(!isdefined(self))
	{
		return false;
	}
	if(!isdefined(self.behaviortracker))
	{
		return false;
	}
	if(!self.behaviortracker.valid)
	{
		return false;
	}
	if(isdefined(level.disablebehaviortracker) && level.disablebehaviortracker == 1)
	{
		return false;
	}
	return true;
}

/*
	Name: printtrackertoblackbox
	Namespace: behaviortracker
	Checksum: 0xC8AD4098
	Offset: 0x548
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function printtrackertoblackbox()
{
	bbprint("mpbehaviortracker", "username %s version %d numRecords %d effectiveSlideCombat %f effectiveDoubleJumpCombat %f effectiveWallRunCombat %f effectiveCombat %f", self.name, self.behaviortracker.version, self.behaviortracker.numrecords, self.behaviortracker.traits["effectiveSlideCombat"], self.behaviortracker.traits["effectiveDoubleJumpCombat"], self.behaviortracker.traits["effectiveWallRunCombat"], self.behaviortracker.traits["effectiveCombat"]);
}

/*
	Name: gettraitvalue
	Namespace: behaviortracker
	Checksum: 0x11A6ADD1
	Offset: 0x600
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function gettraitvalue(trait)
{
	return self.behaviortracker.traits[trait];
}

/*
	Name: settraitvalue
	Namespace: behaviortracker
	Checksum: 0xB71A4C2E
	Offset: 0x628
	Size: 0x2E
	Parameters: 2
	Flags: Linked
*/
function settraitvalue(trait, value)
{
	self.behaviortracker.traits[trait] = value;
}

/*
	Name: updatetrait
	Namespace: behaviortracker
	Checksum: 0xDDECE36D
	Offset: 0x660
	Size: 0x164
	Parameters: 2
	Flags: Linked
*/
function updatetrait(trait, percent)
{
	if(!self isallowed())
	{
		return;
	}
	math::clamp(percent, -1, 1);
	currentvalue = self gettraitvalue(trait);
	if(percent >= 0)
	{
		delta = (1 - currentvalue) * percent;
	}
	else
	{
		delta = (currentvalue - 0) * percent;
	}
	weighteddelta = 0.1 * delta;
	newvalue = currentvalue + weighteddelta;
	newvalue = math::clamp(newvalue, 0, 1);
	self settraitvalue(trait, newvalue);
	bbprint("mpbehaviortraitupdate", "username %s trait %s percent %f", self.name, trait, percent);
}

/*
	Name: updateplayerdamage
	Namespace: behaviortracker
	Checksum: 0x2B140806
	Offset: 0x7D0
	Size: 0x2D4
	Parameters: 3
	Flags: Linked
*/
function updateplayerdamage(attacker, victim, damage)
{
	if(isdefined(victim) && victim isallowed())
	{
		damageratio = float(damage) / float(victim.maxhealth);
		math::clamp(damageratio, 0, 1);
		damageratio = damageratio * -1;
		victim updatetrait("effectiveCombat", damageratio);
		if(victim iswallrunning())
		{
			victim updatetrait("effectiveWallRunCombat", damageratio);
		}
		if(victim issliding())
		{
			victim updatetrait("effectiveSlideCombat", damageratio);
		}
		if(victim isdoublejumping())
		{
			victim updatetrait("effectiveDoubleJumpCombat", damageratio);
		}
	}
	if(isdefined(attacker) && attacker isallowed() && attacker != victim)
	{
		damageratio = float(damage) / float(attacker.maxhealth);
		math::clamp(damageratio, 0, 1);
		attacker updatetrait("effectiveCombat", damageratio);
		if(attacker iswallrunning())
		{
			attacker updatetrait("effectiveWallRunCombat", damageratio);
		}
		if(attacker issliding())
		{
			attacker updatetrait("effectiveSlideCombat", damageratio);
		}
		if(attacker isdoublejumping())
		{
			attacker updatetrait("effectiveDoubleJumpCombat", damageratio);
		}
	}
}

/*
	Name: updateplayerkilled
	Namespace: behaviortracker
	Checksum: 0xC25AD2D5
	Offset: 0xAB0
	Size: 0x234
	Parameters: 2
	Flags: Linked
*/
function updateplayerkilled(attacker, victim)
{
	if(isdefined(victim) && victim isallowed())
	{
		victim updatetrait("effectiveCombat", -1);
		if(victim iswallrunning())
		{
			victim updatetrait("effectiveWallRunCombat", -1);
		}
		if(victim issliding())
		{
			victim updatetrait("effectiveSlideCombat", -1);
		}
		if(victim isdoublejumping())
		{
			victim updatetrait("effectiveDoubleJumpCombat", -1);
		}
	}
	if(isdefined(attacker) && attacker isallowed() && attacker != victim)
	{
		attacker updatetrait("effectiveCombat", 1);
		if(attacker iswallrunning())
		{
			attacker updatetrait("effectiveWallRunCombat", 1);
		}
		if(attacker issliding())
		{
			attacker updatetrait("effectiveSlideCombat", 1);
		}
		if(attacker isdoublejumping())
		{
			attacker updatetrait("effectiveDoubleJumpCombat", 1);
		}
	}
}

/*
	Name: settraitstats
	Namespace: behaviortracker
	Checksum: 0xB2D34BCF
	Offset: 0xCF0
	Size: 0x116
	Parameters: 0
	Flags: Linked
*/
function settraitstats()
{
	if(self.behaviortracker.version == 0)
	{
		return;
	}
	self.behaviortracker.numrecords = self.behaviortracker.numrecords + 1;
	self settraitstatvalue("numRecords", self.behaviortracker.numrecords);
	traits = getarraykeys(self.behaviortracker.traits);
	for(i = 0; i < traits.size; i++)
	{
		trait = traits[i];
		value = self.behaviortracker.traits[trait];
		self settraitstatvalue(trait, value);
	}
}

/*
	Name: gettraitstatvalue
	Namespace: behaviortracker
	Checksum: 0x382EAB2B
	Offset: 0xE10
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function gettraitstatvalue(trait)
{
	return self getdstat("behaviorTracker", trait);
}

/*
	Name: settraitstatvalue
	Namespace: behaviortracker
	Checksum: 0x24CD4F49
	Offset: 0xE48
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function settraitstatvalue(trait, value)
{
	self setdstat("behaviorTracker", trait, value);
}

