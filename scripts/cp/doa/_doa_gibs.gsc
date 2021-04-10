// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\doa\_doa_dev;
#using scripts\cp\doa\_doa_fx;
#using scripts\cp\doa\_doa_pickups;
#using scripts\cp\doa\_doa_player_utility;
#using scripts\cp\doa\_doa_round;
#using scripts\cp\doa\_doa_score;
#using scripts\cp\doa\_doa_sfx;
#using scripts\cp\doa\_doa_utility;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_fba031c8;

/*
	Name: init
	Namespace: namespace_fba031c8
	Checksum: 0x4DE06458
	Offset: 0x5C0
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.doa.var_2b941d3f = array(getweapon("zombietron_deathmachine"), getweapon("zombietron_deathmachine_1"), getweapon("zombietron_deathmachine_2"), getweapon("zombietron_shotgun"), getweapon("zombietron_shotgun_1"), getweapon("zombietron_shotgun_2"), getweapon("zombietron_rpg_1"), getweapon("zombietron_rpg_2"), getweapon("zombietron_nightfury"));
	level.doa.var_1a7175b1 = array("MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTIVLE_SPLASH", "MOD_EXPLOSIVE");
	level.doa.hitlocs = array("left_hand", "left_arm_lower", "left_arm_upper", "right_hand", "right_arm_lower", "right_arm_upper");
}

/*
	Name: function_ddf685e8
	Namespace: namespace_fba031c8
	Checksum: 0xC3C31D9F
	Offset: 0x760
	Size: 0xE4
	Parameters: 2
	Flags: Linked
*/
function function_ddf685e8(launchvector, attacker)
{
	if(!isdefined(self))
	{
		return;
	}
	if(!isactor(self))
	{
		return;
	}
	if(isdefined(self.boss) && self.boss)
	{
		return;
	}
	gibserverutils::giblegs(self);
	self.becomecrawler = 1;
	self clientfield::set("zombie_saw_explosion", 1);
	/#
		assert(!(isdefined(self.boss) && self.boss));
	#/
	self thread doa_utility::function_e3c30240(launchvector, undefined, undefined, attacker);
}

/*
	Name: function_7b3e39cb
	Namespace: namespace_fba031c8
	Checksum: 0x1D5A08CE
	Offset: 0x850
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_7b3e39cb()
{
	gibserverutils::annihilate(self);
}

/*
	Name: function_45dffa6b
	Namespace: namespace_fba031c8
	Checksum: 0xD2AFBA04
	Offset: 0x878
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function function_45dffa6b(launchvector)
{
	if(!isdefined(self))
	{
		return;
	}
	if(!isactor(self))
	{
		return;
	}
	/#
		assert(!(isdefined(self.boss) && self.boss));
	#/
	self clientfield::set("zombie_gut_explosion", 1);
	self thread doa_utility::function_e3c30240(launchvector);
	if(isdefined(launchvector))
	{
		self thread namespace_1a381543::function_90118d8c("zmb_ragdoll_launched");
	}
}

/*
	Name: function_deb7df37
	Namespace: namespace_fba031c8
	Checksum: 0x410CC0A3
	Offset: 0x940
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_deb7df37()
{
	self endon(#"death");
	if(self.animname == "quad_zombie")
	{
		return;
	}
	if(randomint(100) < 50)
	{
		wait(randomfloatrange(0.53, 1));
		gibserverutils::gibhead(self);
	}
	else
	{
		self thread namespace_eaa992c::function_285a2999("tesla_shock_eyes");
	}
}

/*
	Name: trygibbinghead
	Namespace: namespace_fba031c8
	Checksum: 0x92E5D157
	Offset: 0x9E8
	Size: 0x154
	Parameters: 4
	Flags: Linked
*/
function trygibbinghead(entity, damage, hitloc, isexplosive)
{
	if(!gibserverutils::isgibbed(entity, 8))
	{
		return;
	}
	if(isexplosive && randomfloatrange(0, 1) <= 0.5)
	{
		gibserverutils::gibhead(entity);
	}
	else if(isinarray(array("head", "neck", "helmet"), hitloc) && randomfloatrange(0, 1) <= 1)
	{
		gibserverutils::gibhead(entity);
	}
	else if(entity.health - damage <= 0 && randomfloatrange(0, 1) <= 0.25)
	{
		gibserverutils::gibhead(entity);
	}
}

/*
	Name: trygibbinglimb
	Namespace: namespace_fba031c8
	Checksum: 0x34213BA4
	Offset: 0xB48
	Size: 0x334
	Parameters: 4
	Flags: Linked
*/
function trygibbinglimb(entity, damage, hitloc = level.doa.hitlocs[randomint(level.doa.hitlocs.size)], isexplosive = 0)
{
	if(isexplosive && randomfloatrange(0, 1) <= 0.35)
	{
		if(entity.health - damage <= 0 && entity.allowdeath && math::cointoss())
		{
			if(!gibserverutils::isgibbed(entity, 16))
			{
				gibserverutils::gibrightarm(entity);
			}
		}
		else if(!gibserverutils::isgibbed(entity, 32))
		{
			gibserverutils::gibleftarm(entity);
		}
	}
	else if(isinarray(array("left_hand", "left_arm_lower", "left_arm_upper"), hitloc))
	{
		if(!gibserverutils::isgibbed(entity, 32))
		{
			gibserverutils::gibleftarm(entity);
		}
	}
	else if(entity.health - damage <= 0 && entity.allowdeath && isinarray(array("right_hand", "right_arm_lower", "right_arm_upper"), hitloc))
	{
		gibserverutils::gibrightarm(entity);
	}
	else if(entity.health - damage <= 0 && entity.allowdeath && randomfloatrange(0, 1) <= 0.45)
	{
		if(math::cointoss())
		{
			if(!gibserverutils::isgibbed(entity, 32))
			{
				gibserverutils::gibleftarm(entity);
			}
		}
		else if(!gibserverutils::isgibbed(entity, 16))
		{
			gibserverutils::gibrightarm(entity);
		}
	}
}

/*
	Name: trygibbinglegs
	Namespace: namespace_fba031c8
	Checksum: 0xCBDAA51C
	Offset: 0xE88
	Size: 0x49C
	Parameters: 5
	Flags: Linked
*/
function trygibbinglegs(entity, damage, hitloc = level.doa.hitlocs[randomint(level.doa.hitlocs.size)], isexplosive = 0, attacker = entity)
{
	cangiblegs = entity.health - damage <= 0 && entity.allowdeath;
	cangiblegs = cangiblegs || (entity.health - damage / entity.maxhealth <= 0.25 && distancesquared(entity.origin, attacker.origin) <= 600 * 600 && entity.allowdeath);
	if(entity.health - damage <= 0 && entity.allowdeath && isexplosive && randomfloatrange(0, 1) <= 0.5)
	{
		if(!gibserverutils::isgibbed(entity, 384))
		{
			gibserverutils::giblegs(entity);
		}
		/#
			assert(!(isdefined(entity.boss) && entity.boss));
		#/
		entity thread doa_utility::function_e3c30240();
	}
	else if(cangiblegs && isinarray(array("left_leg_upper", "left_leg_lower", "left_foot"), hitloc) && randomfloatrange(0, 1) <= 1)
	{
		if(entity.health - damage > 0)
		{
			entity.becomecrawler = 1;
		}
		if(!gibserverutils::isgibbed(entity, 256))
		{
			gibserverutils::gibleftleg(entity);
		}
	}
	else if(cangiblegs && isinarray(array("right_leg_upper", "right_leg_lower", "right_foot"), hitloc) && randomfloatrange(0, 1) <= 1)
	{
		if(entity.health - damage > 0)
		{
			entity.becomecrawler = 1;
		}
		if(!gibserverutils::isgibbed(entity, 128))
		{
			gibserverutils::gibrightleg(entity);
		}
	}
	else if(entity.health - damage <= 0 && entity.allowdeath && randomfloatrange(0, 1) <= 0.25)
	{
		if(math::cointoss())
		{
			if(!gibserverutils::isgibbed(entity, 256))
			{
				gibserverutils::gibleftleg(entity);
			}
		}
		else if(!gibserverutils::isgibbed(entity, 128))
		{
			gibserverutils::gibrightleg(entity);
		}
	}
}

/*
	Name: function_15a268a6
	Namespace: namespace_fba031c8
	Checksum: 0x21FC330
	Offset: 0x1330
	Size: 0x204
	Parameters: 6
	Flags: Linked
*/
function function_15a268a6(attacker, damage, meansofdeath, weapon, hitloc, vdir)
{
	if(!isactor(self))
	{
		return;
	}
	if(self.archetype != "zombie")
	{
		return;
	}
	if(meansofdeath == "MOD_BURNED")
	{
		return;
	}
	self endon(#"death");
	isexplosive = isinarray(level.doa.var_1a7175b1, meansofdeath);
	trygibbinglimb(self, damage, hitloc, isexplosive);
	trygibbinglegs(self, damage, hitloc, isexplosive, attacker);
	if(damage > self.health && gettime() > self.birthtime)
	{
		if(isinarray(level.doa.var_2b941d3f, weapon))
		{
			self clientfield::increment("zombie_chunk");
		}
		if(weapon == level.doa.var_ccb54987 || weapon == level.doa.var_69899304)
		{
			trygibbinghead(self, damage, hitloc, isexplosive);
			self clientfield::set("zombie_rhino_explosion", 1);
		}
		if(weapon.doannihilate)
		{
			self function_7b3e39cb();
		}
	}
}

