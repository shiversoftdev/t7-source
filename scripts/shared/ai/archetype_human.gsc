// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_human_blackboard;
#using scripts\shared\ai\archetype_human_cover;
#using scripts\shared\ai\archetype_human_exposed;
#using scripts\shared\ai\archetype_human_interface;
#using scripts\shared\ai\archetype_human_locomotion;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_notetracks;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#namespace archetype_human;

/*
	Name: init
	Namespace: archetype_human
	Checksum: 0xE4A9E2C8
	Offset: 0x6C8
	Size: 0xBC
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	spawner::add_archetype_spawn_function("human", &archetypehumanblackboardinit);
	spawner::add_archetype_spawn_function("human", &archetypehumaninit);
	humaninterface::registerhumaninterfaceattributes();
	clientfield::register("actor", "facial_dial", 1, 1, "int");
	/#
		level.__ai_forcegibs = getdvarint("");
	#/
}

/*
	Name: archetypehumaninit
	Namespace: archetype_human
	Checksum: 0x80472732
	Offset: 0x790
	Size: 0x124
	Parameters: 0
	Flags: Linked, Private
*/
function private archetypehumaninit()
{
	entity = self;
	aiutility::addaioverridedamagecallback(entity, &damageoverride);
	aiutility::addaioverridekilledcallback(entity, &humangibkilledoverride);
	locomotiontypes = array("alt1", "alt2", "alt3", "alt4");
	altindex = entity getentitynumber() % locomotiontypes.size;
	blackboard::setblackboardattribute(entity, "_human_locomotion_variation", locomotiontypes[altindex]);
	if(isdefined(entity.hero) && entity.hero)
	{
		blackboard::setblackboardattribute(entity, "_human_locomotion_variation", "alt1");
	}
}

/*
	Name: archetypehumanblackboardinit
	Namespace: archetype_human
	Checksum: 0xB6638B53
	Offset: 0x8C0
	Size: 0x12C
	Parameters: 0
	Flags: Linked, Private
*/
function private archetypehumanblackboardinit()
{
	blackboard::createblackboardforentity(self);
	ai::createinterfaceforentity(self);
	self aiutility::registerutilityblackboardattributes();
	self blackboard::registeractorblackboardattributes();
	self.___archetypeonanimscriptedcallback = &archetypehumanonanimscriptedcallback;
	self.___archetypeonbehavecallback = &archetypehumanonbehavecallback;
	/#
		self finalizetrackedblackboardattributes();
	#/
	self thread gameskill::accuracy_buildup_before_fire(self);
	if(self.accuratefire)
	{
		self thread aiutility::preshootlaserandglinton(self);
		self thread aiutility::postshootlaserandglintoff(self);
	}
	destructserverutils::togglespawngibs(self, 1);
	gibserverutils::togglespawngibs(self, 1);
}

/*
	Name: archetypehumanonbehavecallback
	Namespace: archetype_human
	Checksum: 0x48A413F9
	Offset: 0x9F8
	Size: 0xDC
	Parameters: 1
	Flags: Linked, Private
*/
function private archetypehumanonbehavecallback(entity)
{
	if(aiutility::isatcovercondition(entity))
	{
		blackboard::setblackboardattribute(entity, "_previous_cover_mode", "cover_alert");
		blackboard::setblackboardattribute(entity, "_cover_mode", "cover_mode_none");
	}
	grenadethrowinfo = spawnstruct();
	grenadethrowinfo.grenadethrower = entity;
	blackboard::addblackboardevent("human_grenade_throw", grenadethrowinfo, randomintrange(3000, 4000));
}

/*
	Name: archetypehumanonanimscriptedcallback
	Namespace: archetype_human
	Checksum: 0x7C317ABD
	Offset: 0xAE0
	Size: 0x84
	Parameters: 1
	Flags: Linked, Private
*/
function private archetypehumanonanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity archetypehumanblackboardinit();
	vignettemode = ai::getaiattribute(entity, "vignette_mode");
	humansoldierserverutils::vignettemodecallback(entity, "vignette_mode", vignettemode, vignettemode);
}

/*
	Name: humangibkilledoverride
	Namespace: archetype_human
	Checksum: 0xCB3B9B1B
	Offset: 0xB70
	Size: 0x310
	Parameters: 8
	Flags: Linked, Private
*/
function private humangibkilledoverride(inflictor, attacker, damage, meansofdeath, weapon, dir, hitloc, offsettime)
{
	entity = self;
	if(math::cointoss())
	{
		return damage;
	}
	attackerdistance = 0;
	if(isdefined(attacker))
	{
		attackerdistance = distancesquared(attacker.origin, entity.origin);
	}
	isexplosive = isinarray(array("MOD_CRUSH", "MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTILE_SPLASH", "MOD_EXPLOSIVE"), meansofdeath);
	forcegibbing = 0;
	if(isdefined(weapon.weapclass) && weapon.weapclass == "turret")
	{
		forcegibbing = 1;
		if(isdefined(inflictor))
		{
			isdirectexplosive = isinarray(array("MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTILE_SPLASH", "MOD_EXPLOSIVE"), meansofdeath);
			iscloseexplosive = distancesquared(inflictor.origin, entity.origin) <= (60 * 60);
			if(isdirectexplosive && iscloseexplosive)
			{
				gibserverutils::annihilate(entity);
			}
		}
	}
	if(forcegibbing || isexplosive || (isdefined(level.__ai_forcegibs) && level.__ai_forcegibs) || (weapon.dogibbing && attackerdistance <= (weapon.maxgibdistance * weapon.maxgibdistance)))
	{
		gibserverutils::togglespawngibs(entity, 1);
		destructserverutils::togglespawngibs(entity, 1);
		trygibbinglimb(entity, damage, hitloc, isexplosive || forcegibbing);
		trygibbinglegs(entity, damage, hitloc, isexplosive);
	}
	return damage;
}

/*
	Name: trygibbinghead
	Namespace: archetype_human
	Checksum: 0x8BBF3326
	Offset: 0xE88
	Size: 0x9C
	Parameters: 4
	Flags: Private
*/
function private trygibbinghead(entity, damage, hitloc, isexplosive)
{
	if(isexplosive)
	{
		gibserverutils::gibhead(entity);
	}
	else if(isinarray(array("head", "neck", "helmet"), hitloc))
	{
		gibserverutils::gibhead(entity);
	}
}

/*
	Name: trygibbinglimb
	Namespace: archetype_human
	Checksum: 0x47A97BBE
	Offset: 0xF30
	Size: 0x1CC
	Parameters: 4
	Flags: Linked, Private
*/
function private trygibbinglimb(entity, damage, hitloc, isexplosive)
{
	if(isexplosive)
	{
		randomchance = randomfloatrange(0, 1);
		if(randomchance < 0.5)
		{
			gibserverutils::gibrightarm(entity);
		}
		else
		{
			gibserverutils::gibleftarm(entity);
		}
	}
	else
	{
		if(isinarray(array("left_hand", "left_arm_lower", "left_arm_upper"), hitloc))
		{
			gibserverutils::gibleftarm(entity);
		}
		else
		{
			if(isinarray(array("right_hand", "right_arm_lower", "right_arm_upper"), hitloc))
			{
				gibserverutils::gibrightarm(entity);
			}
			else if(isinarray(array("torso_upper"), hitloc) && math::cointoss())
			{
				if(math::cointoss())
				{
					gibserverutils::gibleftarm(entity);
				}
				else
				{
					gibserverutils::gibrightarm(entity);
				}
			}
		}
	}
}

/*
	Name: trygibbinglegs
	Namespace: archetype_human
	Checksum: 0x6553B96B
	Offset: 0x1108
	Size: 0x1FC
	Parameters: 5
	Flags: Linked, Private
*/
function private trygibbinglegs(entity, damage, hitloc, isexplosive, attacker)
{
	if(isexplosive)
	{
		randomchance = randomfloatrange(0, 1);
		if(randomchance < 0.33)
		{
			gibserverutils::gibrightleg(entity);
		}
		else
		{
			if(randomchance < 0.66)
			{
				gibserverutils::gibleftleg(entity);
			}
			else
			{
				gibserverutils::giblegs(entity);
			}
		}
	}
	else
	{
		if(isinarray(array("left_leg_upper", "left_leg_lower", "left_foot"), hitloc))
		{
			gibserverutils::gibleftleg(entity);
		}
		else
		{
			if(isinarray(array("right_leg_upper", "right_leg_lower", "right_foot"), hitloc))
			{
				gibserverutils::gibrightleg(entity);
			}
			else if(isinarray(array("torso_lower"), hitloc) && math::cointoss())
			{
				if(math::cointoss())
				{
					gibserverutils::gibleftleg(entity);
				}
				else
				{
					gibserverutils::gibrightleg(entity);
				}
			}
		}
	}
}

/*
	Name: damageoverride
	Namespace: archetype_human
	Checksum: 0xF06BD2C0
	Offset: 0x1310
	Size: 0x1BC
	Parameters: 12
	Flags: Linked
*/
function damageoverride(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex, modelindex)
{
	entity = self;
	entity destructserverutils::handledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex, modelindex);
	if(isdefined(eattacker) && !isplayer(eattacker) && !isvehicle(eattacker))
	{
		dist = distancesquared(entity.origin, eattacker.origin);
		if(dist < 65536)
		{
			idamage = int(idamage * 10);
		}
		else
		{
			idamage = int(idamage * 1.5);
		}
	}
	if(sweapon.name == "incendiary_grenade")
	{
		idamage = entity.health;
	}
	return idamage;
}

#namespace humansoldierserverutils;

/*
	Name: cqbattributecallback
	Namespace: humansoldierserverutils
	Checksum: 0x1D67B7A6
	Offset: 0x14D8
	Size: 0xA4
	Parameters: 4
	Flags: Linked
*/
function cqbattributecallback(entity, attribute, oldvalue, value)
{
	if(value)
	{
		entity asmchangeanimmappingtable(2);
	}
	else
	{
		if(entity ai::get_behavior_attribute("useAnimationOverride"))
		{
			entity asmchangeanimmappingtable(1);
		}
		else
		{
			entity asmchangeanimmappingtable(0);
		}
	}
}

/*
	Name: forcetacticalwalkcallback
	Namespace: humansoldierserverutils
	Checksum: 0x811187B7
	Offset: 0x1588
	Size: 0x38
	Parameters: 4
	Flags: Linked
*/
function forcetacticalwalkcallback(entity, attribute, oldvalue, value)
{
	entity.ignorerunandgundist = value;
}

/*
	Name: movemodeattributecallback
	Namespace: humansoldierserverutils
	Checksum: 0xCFF08835
	Offset: 0x15C8
	Size: 0x6E
	Parameters: 4
	Flags: Linked
*/
function movemodeattributecallback(entity, attribute, oldvalue, value)
{
	entity.ignorepathenemyfightdist = 0;
	switch(value)
	{
		case "normal":
		{
			break;
		}
		case "rambo":
		{
			entity.ignorepathenemyfightdist = 1;
			break;
		}
	}
}

/*
	Name: useanimationoverridecallback
	Namespace: humansoldierserverutils
	Checksum: 0x95A7339E
	Offset: 0x1640
	Size: 0x64
	Parameters: 4
	Flags: Linked
*/
function useanimationoverridecallback(entity, attribute, oldvalue, value)
{
	if(value)
	{
		entity asmchangeanimmappingtable(1);
	}
	else
	{
		entity asmchangeanimmappingtable(0);
	}
}

/*
	Name: vignettemodecallback
	Namespace: humansoldierserverutils
	Checksum: 0x8306D905
	Offset: 0x16B0
	Size: 0x1F2
	Parameters: 4
	Flags: Linked
*/
function vignettemodecallback(entity, attribute, oldvalue, value)
{
	switch(value)
	{
		case "off":
		{
			entity.pushable = 1;
			entity pushactors(0);
			entity pushplayer(0);
			entity setavoidancemask("avoid all");
			entity setsteeringmode("normal steering");
			break;
		}
		case "slow":
		{
			entity.pushable = 0;
			entity pushactors(0);
			entity pushplayer(1);
			entity setavoidancemask("avoid ai");
			entity setsteeringmode("vignette steering");
			break;
		}
		case "fast":
		{
			entity.pushable = 0;
			entity pushactors(1);
			entity pushplayer(1);
			entity setavoidancemask("avoid none");
			entity setsteeringmode("vignette steering");
			break;
		}
		default:
		{
			break;
		}
	}
}

