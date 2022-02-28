// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_human_riotshield_interface;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;

#namespace archetype_human_riotshield;

/*
	Name: main
	Namespace: archetype_human_riotshield
	Checksum: 0xA139F5F
	Offset: 0x560
	Size: 0x74
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	spawner::add_archetype_spawn_function("human_riotshield", &humanriotshieldbehavior::archetypehumanriotshieldblackboardinit);
	spawner::add_archetype_spawn_function("human_riotshield", &humanriotshieldserverutils::humanriotshieldspawnsetup);
	humanriotshieldbehavior::registerbehaviorscriptfunctions();
	humanriotshieldinterface::registerhumanriotshieldinterfaceattributes();
}

#namespace humanriotshieldbehavior;

/*
	Name: registerbehaviorscriptfunctions
	Namespace: humanriotshieldbehavior
	Checksum: 0x399F3948
	Offset: 0x5E0
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function registerbehaviorscriptfunctions()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("riotshieldShouldTacticalWalk", &riotshieldshouldtacticalwalk);
	behaviortreenetworkutility::registerbehaviortreescriptapi("riotshieldNonCombatLocomotionCondition", &riotshieldnoncombatlocomotioncondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("unarmedWalkAction", &unarmedwalkactionstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("riotshieldTacticalWalkStart", &riotshieldtacticalwalkstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("riotshieldAdvanceOnEnemyService", &riotshieldadvanceonenemyservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("riotshieldShouldFlinch", &riotshieldshouldflinch);
	behaviortreenetworkutility::registerbehaviortreescriptapi("riotshieldIncrementFlinchCount", &riotshieldincrementflinchcount);
	behaviortreenetworkutility::registerbehaviortreescriptapi("riotshieldClearFlinchCount", &riotshieldclearflinchcount);
	behaviortreenetworkutility::registerbehaviortreescriptapi("riotshieldUnarmedTargetService", &riotshieldunarmedtargetservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("riotshieldUnarmedAdvanceOnEnemyService", &riotshieldunarmedadvanceonenemyservice);
}

/*
	Name: archetypehumanriotshieldblackboardinit
	Namespace: humanriotshieldbehavior
	Checksum: 0xE0D85EDE
	Offset: 0x780
	Size: 0xF4
	Parameters: 0
	Flags: Linked, Private
*/
function private archetypehumanriotshieldblackboardinit()
{
	entity = self;
	blackboard::createblackboardforentity(entity);
	ai::createinterfaceforentity(entity);
	entity aiutility::registerutilityblackboardattributes();
	self.___archetypeonanimscriptedcallback = &archetypehumanriotshieldonanimscriptedcallback;
	/#
		entity finalizetrackedblackboardattributes();
	#/
	blackboard::registerblackboardattribute(self, "_move_mode", "normal", &riotshieldmovemode);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
}

/*
	Name: archetypehumanriotshieldonanimscriptedcallback
	Namespace: humanriotshieldbehavior
	Checksum: 0x5CB4A3A3
	Offset: 0x880
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private archetypehumanriotshieldonanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity archetypehumanriotshieldblackboardinit();
}

/*
	Name: riotshieldmovemode
	Namespace: humanriotshieldbehavior
	Checksum: 0xCA29D82
	Offset: 0x8C0
	Size: 0x46
	Parameters: 0
	Flags: Linked, Private
*/
function private riotshieldmovemode()
{
	entity = self;
	if(entity ai::get_behavior_attribute("phalanx"))
	{
		return "marching";
	}
	return "normal";
}

/*
	Name: riotshieldshouldflinch
	Namespace: humanriotshieldbehavior
	Checksum: 0x2BB56F5A
	Offset: 0x910
	Size: 0xC4
	Parameters: 1
	Flags: Linked, Private
*/
function private riotshieldshouldflinch(entity)
{
	if(entity haspath() && entity ai::get_behavior_attribute("phalanx"))
	{
		return true;
	}
	if(entity.damagelocation != "riotshield")
	{
		return false;
	}
	if(entity.damagelocation == "riotshield" && entity.flinchcount >= 5 && (entity.lastflinchtime + 1500) >= gettime())
	{
		return false;
	}
	return true;
}

/*
	Name: riotshieldincrementflinchcount
	Namespace: humanriotshieldbehavior
	Checksum: 0xEB7EFA1C
	Offset: 0x9E0
	Size: 0x2C
	Parameters: 1
	Flags: Linked, Private
*/
function private riotshieldincrementflinchcount(entity)
{
	entity.flinchcount++;
	entity.lastflinchtime = gettime();
}

/*
	Name: riotshieldclearflinchcount
	Namespace: humanriotshieldbehavior
	Checksum: 0xE64DADAF
	Offset: 0xA18
	Size: 0x2C
	Parameters: 1
	Flags: Linked, Private
*/
function private riotshieldclearflinchcount(entity)
{
	entity.lastflinchtime = gettime();
	entity.flinchcount = 0;
}

/*
	Name: riotshieldshouldtacticalwalk
	Namespace: humanriotshieldbehavior
	Checksum: 0x5854FAAD
	Offset: 0xA50
	Size: 0x10
	Parameters: 1
	Flags: Linked, Private
*/
function private riotshieldshouldtacticalwalk(behaviortreeentity)
{
	return true;
}

/*
	Name: riotshieldnoncombatlocomotioncondition
	Namespace: humanriotshieldbehavior
	Checksum: 0x6D867AB7
	Offset: 0xA68
	Size: 0x70
	Parameters: 1
	Flags: Linked, Private
*/
function private riotshieldnoncombatlocomotioncondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemy))
	{
		if(distancesquared(behaviortreeentity.origin, behaviortreeentity lastknownpos(behaviortreeentity.enemy)) > 490000)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: riotshieldadvanceonenemyservice
	Namespace: humanriotshieldbehavior
	Checksum: 0x279D9F40
	Offset: 0xAE0
	Size: 0x38E
	Parameters: 1
	Flags: Linked, Private
*/
function private riotshieldadvanceonenemyservice(behaviortreeentity)
{
	itsbeenawhile = gettime() > behaviortreeentity.nextfindbestcovertime;
	isatscriptgoal = behaviortreeentity isatgoal();
	toolongatnode = 0;
	if(behaviortreeentity ai::get_behavior_attribute("phalanx"))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.chosennode))
	{
		dist_sq = distancesquared(behaviortreeentity.origin, behaviortreeentity.chosennode.origin);
		if(dist_sq < 256)
		{
			if(!isdefined(behaviortreeentity.timeatchosennode))
			{
				behaviortreeentity.timeatchosennode = gettime();
			}
		}
	}
	if(isdefined(behaviortreeentity.timeatchosennode))
	{
		if((gettime() - behaviortreeentity.timeatchosennode) > behaviortreeentity.timeatnodemax)
		{
			toolongatnode = 1;
			behaviortreeentity.timeatchosennode = undefined;
		}
	}
	shouldlookforbettercover = itsbeenawhile || !isatscriptgoal || toolongatnode;
	if(shouldlookforbettercover && isdefined(behaviortreeentity.enemy))
	{
		closestrandomnode = undefined;
		closestrandomnodes = behaviortreeentity findbestcovernodes(behaviortreeentity.goalradius, behaviortreeentity.goalpos);
		foreach(node in closestrandomnodes)
		{
			if(isdefined(behaviortreeentity.chosennode) && behaviortreeentity.chosennode == node)
			{
				continue;
			}
			if(aiutility::getcovertype(node) == "cover_exposed")
			{
				closestrandomnode = node;
				break;
			}
		}
		if(!isdefined(closestrandomnode))
		{
			closestrandomnode = closestrandomnodes[0];
		}
		if(isdefined(closestrandomnode) && behaviortreeentity findpath(behaviortreeentity.origin, closestrandomnode.origin, 1, 0))
		{
			aiutility::releaseclaimnode(behaviortreeentity);
			aiutility::usecovernodewrapper(behaviortreeentity, closestrandomnode);
			behaviortreeentity.chosennode = closestrandomnode;
			behaviortreeentity.timeatnodemax = randomintrange(behaviortreeentity.movedelaymin, behaviortreeentity.movedelaymax);
			behaviortreeentity.timeatchosennode = undefined;
			return true;
		}
	}
	return false;
}

/*
	Name: riotshieldtacticalwalkstart
	Namespace: humanriotshieldbehavior
	Checksum: 0xBD03AD94
	Offset: 0xE78
	Size: 0x84
	Parameters: 1
	Flags: Linked, Private
*/
function private riotshieldtacticalwalkstart(behaviortreeentity)
{
	aiutility::resetcoverparameters(behaviortreeentity);
	aiutility::setcanbeflanked(behaviortreeentity, 0);
	blackboard::setblackboardattribute(behaviortreeentity, "_stance", "stand");
	behaviortreeentity orientmode("face enemy");
}

/*
	Name: riotshieldunarmedtargetservice
	Namespace: humanriotshieldbehavior
	Checksum: 0x82351F01
	Offset: 0xF08
	Size: 0x31C
	Parameters: 1
	Flags: Linked, Private
*/
function private riotshieldunarmedtargetservice(behaviortreeentity)
{
	if(!aiutility::shouldmutexmelee(behaviortreeentity))
	{
		return false;
	}
	enemies = [];
	ai = getaiarray();
	foreach(value in ai)
	{
		if(value.team != behaviortreeentity.team && isactor(value))
		{
			enemies[enemies.size] = value;
		}
	}
	if(enemies.size > 0)
	{
		closestenemy = undefined;
		closestenemydistance = 0;
		for(index = 0; index < enemies.size; index++)
		{
			enemy = enemies[index];
			enemydistance = distancesquared(behaviortreeentity.origin, enemy.origin);
			checkenemy = 0;
			if(enemydistance > (behaviortreeentity.goalradius * behaviortreeentity.goalradius))
			{
				continue;
			}
			if(!isdefined(enemy.targeted_by) || enemy.targeted_by == behaviortreeentity)
			{
				checkenemy = 1;
			}
			else
			{
				targetdistance = distancesquared(enemy.targeted_by.origin, enemy.origin);
				if(enemydistance < targetdistance)
				{
					checkenemy = 1;
				}
			}
			if(checkenemy)
			{
				if(!isdefined(closestenemy) || enemydistance < closestenemydistance)
				{
					closestenemydistance = enemydistance;
					closestenemy = enemy;
				}
			}
		}
		if(isdefined(behaviortreeentity.favoriteenemy))
		{
			behaviortreeentity.favoriteenemy.targeted_by = undefined;
		}
		behaviortreeentity.favoriteenemy = closestenemy;
		if(isdefined(behaviortreeentity.favoriteenemy))
		{
			behaviortreeentity.favoriteenemy.targeted_by = behaviortreeentity;
		}
		return true;
	}
	return false;
}

/*
	Name: riotshieldunarmedadvanceonenemyservice
	Namespace: humanriotshieldbehavior
	Checksum: 0x11BCFCC0
	Offset: 0x1230
	Size: 0x13E
	Parameters: 1
	Flags: Linked, Private
*/
function private riotshieldunarmedadvanceonenemyservice(behaviortreeentity)
{
	if(gettime() < behaviortreeentity.nextfindbestcovertime)
	{
		return false;
	}
	if(isdefined(behaviortreeentity.favoriteenemy))
	{
		/#
			recordline(behaviortreeentity.favoriteenemy.origin, behaviortreeentity.origin, (1, 0.5, 0), "", behaviortreeentity);
		#/
		enemydistance = distancesquared(behaviortreeentity.favoriteenemy.origin, behaviortreeentity.origin);
		if(enemydistance < (behaviortreeentity.goalradius * behaviortreeentity.goalradius))
		{
			behaviortreeentity useposition(behaviortreeentity.favoriteenemy.origin);
			return true;
		}
	}
	behaviortreeentity clearuseposition();
	return false;
}

/*
	Name: unarmedwalkactionstart
	Namespace: humanriotshieldbehavior
	Checksum: 0x273D3683
	Offset: 0x1378
	Size: 0x54
	Parameters: 1
	Flags: Linked, Private
*/
function private unarmedwalkactionstart(behaviortreeentity)
{
	blackboard::setblackboardattribute(behaviortreeentity, "_stance", "stand");
	behaviortreeentity orientmode("face enemy");
}

/*
	Name: riotshieldkilledoverride
	Namespace: humanriotshieldbehavior
	Checksum: 0xCF029325
	Offset: 0x13D8
	Size: 0x70
	Parameters: 8
	Flags: Linked, Private
*/
function private riotshieldkilledoverride(inflictor, attacker, damage, meansofdeath, weapon, dir, hitloc, offsettime)
{
	entity = self;
	aiutility::dropriotshield(entity);
	return damage;
}

/*
	Name: riotshielddamageoverride
	Namespace: humanriotshieldbehavior
	Checksum: 0xDC26B4E2
	Offset: 0x1450
	Size: 0xF8
	Parameters: 12
	Flags: Linked, Private
*/
function private riotshielddamageoverride(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex, modelindex)
{
	entity = self;
	if(shitloc == "riotshield")
	{
		riotshieldincrementflinchcount(entity);
		entity.health = entity.health + 1;
		return 1;
	}
	if(sweapon.name == "incendiary_grenade")
	{
		idamage = entity.health;
	}
	return idamage;
}

#namespace humanriotshieldserverutils;

/*
	Name: humanriotshieldspawnsetup
	Namespace: humanriotshieldserverutils
	Checksum: 0x8C52BD32
	Offset: 0x1550
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function humanriotshieldspawnsetup()
{
	entity = self;
	aiutility::attachriotshield(entity, getweapon("riotshield"), "wpn_t7_shield_riot_world_lh", "tag_weapon_left");
	entity.movedelaymin = 2500;
	entity.movedelaymax = 5000;
	entity.ignorerunandgundist = 1;
	aiutility::addaioverridedamagecallback(entity, &humanriotshieldbehavior::riotshielddamageoverride);
	aiutility::addaioverridekilledcallback(entity, &humanriotshieldbehavior::riotshieldkilledoverride);
	humanriotshieldbehavior::riotshieldclearflinchcount(entity);
}

