// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;

#namespace archetype_human_exposed;

/*
	Name: registerbehaviorscriptfunctions
	Namespace: archetype_human_exposed
	Checksum: 0x9C49652D
	Offset: 0x238
	Size: 0x144
	Parameters: 0
	Flags: AutoExec
*/
function autoexec registerbehaviorscriptfunctions()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("hasCloseEnemy", &hascloseenemy);
	behaviortreenetworkutility::registerbehaviortreescriptapi("noCloseEnemyService", &nocloseenemyservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("tryReacquireService", &tryreacquireservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("prepareToReactToEnemy", &preparetoreacttoenemy);
	behaviortreenetworkutility::registerbehaviortreescriptapi("resetReactionToEnemy", &resetreactiontoenemy);
	behaviortreenetworkutility::registerbehaviortreescriptapi("exposedSetDesiredStanceToStand", &exposedsetdesiredstancetostand);
	behaviortreenetworkutility::registerbehaviortreescriptapi("setPathMoveDelayedRandom", &setpathmovedelayedrandom);
	behaviortreenetworkutility::registerbehaviortreescriptapi("vengeanceService", &vengeanceservice);
}

/*
	Name: preparetoreacttoenemy
	Namespace: archetype_human_exposed
	Checksum: 0xD6DD1C1
	Offset: 0x388
	Size: 0x54
	Parameters: 1
	Flags: Linked, Private
*/
function private preparetoreacttoenemy(behaviortreeentity)
{
	behaviortreeentity.newenemyreaction = 0;
	behaviortreeentity.malfunctionreaction = 0;
	behaviortreeentity pathmode("move delayed", 1, 3);
}

/*
	Name: resetreactiontoenemy
	Namespace: archetype_human_exposed
	Checksum: 0xD030FF30
	Offset: 0x3E8
	Size: 0x2C
	Parameters: 1
	Flags: Linked, Private
*/
function private resetreactiontoenemy(behaviortreeentity)
{
	behaviortreeentity.newenemyreaction = 0;
	behaviortreeentity.malfunctionreaction = 0;
}

/*
	Name: nocloseenemyservice
	Namespace: archetype_human_exposed
	Checksum: 0x67EA8F08
	Offset: 0x420
	Size: 0x54
	Parameters: 1
	Flags: Linked, Private
*/
function private nocloseenemyservice(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemy) && aiutility::hascloseenemytomelee(behaviortreeentity))
	{
		behaviortreeentity clearpath();
		return true;
	}
	return false;
}

/*
	Name: hascloseenemy
	Namespace: archetype_human_exposed
	Checksum: 0x8B3129D4
	Offset: 0x480
	Size: 0x64
	Parameters: 1
	Flags: Linked, Private
*/
function private hascloseenemy(behaviortreeentity)
{
	if(!isdefined(behaviortreeentity.enemy))
	{
		return false;
	}
	if(distancesquared(behaviortreeentity.origin, behaviortreeentity.enemy.origin) < 22500)
	{
		return true;
	}
	return false;
}

/*
	Name: _isvalidneighbor
	Namespace: archetype_human_exposed
	Checksum: 0x6BF7E00B
	Offset: 0x4F0
	Size: 0x38
	Parameters: 2
	Flags: Linked, Private
*/
function private _isvalidneighbor(entity, neighbor)
{
	return isdefined(neighbor) && entity.team === neighbor.team;
}

/*
	Name: vengeanceservice
	Namespace: archetype_human_exposed
	Checksum: 0xE945A739
	Offset: 0x530
	Size: 0x152
	Parameters: 1
	Flags: Linked, Private
*/
function private vengeanceservice(entity)
{
	actors = getaiarray();
	if(!isdefined(entity.attacker))
	{
		return;
	}
	foreach(ai in actors)
	{
		if(_isvalidneighbor(entity, ai) && distancesquared(entity.origin, ai.origin) <= (360 * 360) && randomfloat(1) >= 0.5)
		{
			ai getperfectinfo(entity.attacker, 1);
		}
	}
}

/*
	Name: setpathmovedelayedrandom
	Namespace: archetype_human_exposed
	Checksum: 0x49FFB7C3
	Offset: 0x690
	Size: 0x4C
	Parameters: 2
	Flags: Linked, Private
*/
function private setpathmovedelayedrandom(behaviortreeentity, asmstatename)
{
	behaviortreeentity pathmode("move delayed", 0, randomfloatrange(1, 3));
}

/*
	Name: exposedsetdesiredstancetostand
	Namespace: archetype_human_exposed
	Checksum: 0x5500C47A
	Offset: 0x6E8
	Size: 0x7C
	Parameters: 2
	Flags: Linked, Private
*/
function private exposedsetdesiredstancetostand(behaviortreeentity, asmstatename)
{
	aiutility::keepclaimnode(behaviortreeentity);
	currentstance = blackboard::getblackboardattribute(behaviortreeentity, "_stance");
	blackboard::setblackboardattribute(behaviortreeentity, "_desired_stance", "stand");
}

/*
	Name: tryreacquireservice
	Namespace: archetype_human_exposed
	Checksum: 0xA0542659
	Offset: 0x770
	Size: 0x2D2
	Parameters: 1
	Flags: Linked, Private
*/
function private tryreacquireservice(behaviortreeentity)
{
	if(!isdefined(behaviortreeentity.reacquire_state))
	{
		behaviortreeentity.reacquire_state = 0;
	}
	if(!isdefined(behaviortreeentity.enemy))
	{
		behaviortreeentity.reacquire_state = 0;
		return false;
	}
	if(behaviortreeentity haspath())
	{
		behaviortreeentity.reacquire_state = 0;
		return false;
	}
	if(behaviortreeentity seerecently(behaviortreeentity.enemy, 4))
	{
		behaviortreeentity.reacquire_state = 0;
		return false;
	}
	dirtoenemy = vectornormalize(behaviortreeentity.enemy.origin - behaviortreeentity.origin);
	forward = anglestoforward(behaviortreeentity.angles);
	if(vectordot(dirtoenemy, forward) < 0.5)
	{
		behaviortreeentity.reacquire_state = 0;
		return false;
	}
	switch(behaviortreeentity.reacquire_state)
	{
		case 0:
		case 1:
		case 2:
		{
			step_size = 32 + (behaviortreeentity.reacquire_state * 32);
			reacquirepos = behaviortreeentity reacquirestep(step_size);
			break;
		}
		case 4:
		{
			if(!behaviortreeentity cansee(behaviortreeentity.enemy) || !behaviortreeentity canshootenemy())
			{
				behaviortreeentity flagenemyunattackable();
			}
			break;
		}
		default:
		{
			if(behaviortreeentity.reacquire_state > 15)
			{
				behaviortreeentity.reacquire_state = 0;
				return false;
			}
			break;
		}
	}
	if(isvec(reacquirepos))
	{
		behaviortreeentity useposition(reacquirepos);
		return true;
	}
	behaviortreeentity.reacquire_state++;
	return false;
}

