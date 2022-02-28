// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\systems\animation_selector_table;
#using scripts\shared\array_shared;

#namespace animation_selector_table_evaluators;

/*
	Name: registerastscriptfunctions
	Namespace: animation_selector_table_evaluators
	Checksum: 0xC33DB53E
	Offset: 0x1C8
	Size: 0xA4
	Parameters: 0
	Flags: AutoExec
*/
function autoexec registerastscriptfunctions()
{
	animationselectortable::registeranimationselectortableevaluator("testFunction", &testfunction);
	animationselectortable::registeranimationselectortableevaluator("evaluateBlockedAnimations", &evaluateblockedanimations);
	animationselectortable::registeranimationselectortableevaluator("evaluateHumanTurnAnimations", &evaluatehumanturnanimations);
	animationselectortable::registeranimationselectortableevaluator("evaluateHumanExposedArrivalAnimations", &evaluatehumanexposedarrivalanimations);
}

/*
	Name: testfunction
	Namespace: animation_selector_table_evaluators
	Checksum: 0xA47604A4
	Offset: 0x278
	Size: 0x46
	Parameters: 2
	Flags: Linked
*/
function testfunction(entity, animations)
{
	if(isarray(animations) && animations.size > 0)
	{
		return animations[0];
	}
}

/*
	Name: evaluator_checkanimationagainstgeo
	Namespace: animation_selector_table_evaluators
	Checksum: 0xDC0858
	Offset: 0x2C8
	Size: 0x256
	Parameters: 2
	Flags: Linked, Private
*/
function private evaluator_checkanimationagainstgeo(entity, animation)
{
	pixbeginevent("Evaluator_CheckAnimationAgainstGeo");
	/#
		assert(isactor(entity));
	#/
	localdeltahalfvector = getmovedelta(animation, 0, 0.5, entity);
	midpoint = entity localtoworldcoords(localdeltahalfvector);
	midpoint = (midpoint[0], midpoint[1], entity.origin[2]);
	/#
		recordline(entity.origin, midpoint, (1, 0.5, 0), "", entity);
	#/
	if(entity maymovetopoint(midpoint, 1, 1))
	{
		localdeltavector = getmovedelta(animation, 0, 1, entity);
		endpoint = entity localtoworldcoords(localdeltavector);
		endpoint = (endpoint[0], endpoint[1], entity.origin[2]);
		/#
			recordline(midpoint, endpoint, (1, 0.5, 0), "", entity);
		#/
		if(entity maymovefrompointtopoint(midpoint, endpoint, 1, 1))
		{
			pixendevent();
			return true;
		}
	}
	pixendevent();
	return false;
}

/*
	Name: evaluator_checkanimationendpointagainstgeo
	Namespace: animation_selector_table_evaluators
	Checksum: 0x2FCB299B
	Offset: 0x528
	Size: 0x12E
	Parameters: 2
	Flags: Private
*/
function private evaluator_checkanimationendpointagainstgeo(entity, animation)
{
	pixbeginevent("Evaluator_CheckAnimationEndPointAgainstGeo");
	/#
		assert(isactor(entity));
	#/
	localdeltavector = getmovedelta(animation, 0, 1, entity);
	endpoint = entity localtoworldcoords(localdeltavector);
	endpoint = (endpoint[0], endpoint[1], entity.origin[2]);
	if(entity maymovetopoint(endpoint, 0, 0))
	{
		pixendevent();
		return true;
	}
	pixendevent();
	return false;
}

/*
	Name: evaluator_checkanimationforovershootinggoal
	Namespace: animation_selector_table_evaluators
	Checksum: 0x6A17F2A2
	Offset: 0x660
	Size: 0x19E
	Parameters: 2
	Flags: Linked, Private
*/
function private evaluator_checkanimationforovershootinggoal(entity, animation)
{
	pixbeginevent("Evaluator_CheckAnimationForOverShootingGoal");
	/#
		assert(isactor(entity));
	#/
	localdeltavector = getmovedelta(animation, 0, 1, entity);
	endpoint = entity localtoworldcoords(localdeltavector);
	animdistsq = lengthsquared(localdeltavector);
	if(entity haspath())
	{
		startpos = entity.origin;
		goalpos = entity.pathgoalpos;
		/#
			assert(isdefined(goalpos));
		#/
		disttogoalsq = distancesquared(startpos, goalpos);
		if(animdistsq < disttogoalsq)
		{
			pixendevent();
			return true;
		}
	}
	pixendevent();
	return false;
}

/*
	Name: evaluator_checkanimationagainstnavmesh
	Namespace: animation_selector_table_evaluators
	Checksum: 0x60939DB6
	Offset: 0x808
	Size: 0xBE
	Parameters: 2
	Flags: Linked, Private
*/
function private evaluator_checkanimationagainstnavmesh(entity, animation)
{
	/#
		assert(isactor(entity));
	#/
	localdeltavector = getmovedelta(animation, 0, 1, entity);
	endpoint = entity localtoworldcoords(localdeltavector);
	if(ispointonnavmesh(endpoint, entity))
	{
		return true;
	}
	return false;
}

/*
	Name: evaluator_checkanimationarrivalposition
	Namespace: animation_selector_table_evaluators
	Checksum: 0x29C22AF3
	Offset: 0x8D0
	Size: 0x112
	Parameters: 2
	Flags: Linked, Private
*/
function private evaluator_checkanimationarrivalposition(entity, animation)
{
	localdeltavector = getmovedelta(animation, 0, 1, entity);
	endpoint = entity localtoworldcoords(localdeltavector);
	animdistsq = lengthsquared(localdeltavector);
	startpos = entity.origin;
	goalpos = entity.pathgoalpos;
	disttogoalsq = distancesquared(startpos, goalpos);
	return disttogoalsq < animdistsq && entity isposatgoal(endpoint);
}

/*
	Name: evaluator_findfirstvalidanimation
	Namespace: animation_selector_table_evaluators
	Checksum: 0xDBFA0DEF
	Offset: 0x9F0
	Size: 0x1CE
	Parameters: 3
	Flags: Linked, Private
*/
function private evaluator_findfirstvalidanimation(entity, animations, tests)
{
	/#
		assert(isarray(animations), "");
	#/
	/#
		assert(isarray(tests), "");
	#/
	foreach(aliasanimations in animations)
	{
		if(aliasanimations.size > 0)
		{
			valid = 1;
			animation = aliasanimations[0];
			foreach(test in tests)
			{
				if(![[test]](entity, animation))
				{
					valid = 0;
					break;
				}
			}
			if(valid)
			{
				return animation;
			}
		}
	}
}

/*
	Name: evaluateblockedanimations
	Namespace: animation_selector_table_evaluators
	Checksum: 0x50CC3FA2
	Offset: 0xBC8
	Size: 0x6E
	Parameters: 2
	Flags: Linked, Private
*/
function private evaluateblockedanimations(entity, animations)
{
	if(animations.size > 0)
	{
		return evaluator_findfirstvalidanimation(entity, animations, array(&evaluator_checkanimationagainstgeo, &evaluator_checkanimationforovershootinggoal));
	}
	return undefined;
}

/*
	Name: evaluatehumanturnanimations
	Namespace: animation_selector_table_evaluators
	Checksum: 0xAA2165C4
	Offset: 0xC40
	Size: 0xEE
	Parameters: 2
	Flags: Linked, Private
*/
function private evaluatehumanturnanimations(entity, animations)
{
	/#
		if(isdefined(level.ai_dontturn) && level.ai_dontturn)
		{
			return undefined;
		}
	#/
	/#
		record3dtext(("" + gettime()) + "", entity.origin, (1, 0.5, 0), "", entity);
	#/
	if(animations.size > 0)
	{
		return evaluator_findfirstvalidanimation(entity, animations, array(&evaluator_checkanimationforovershootinggoal, &evaluator_checkanimationagainstgeo, &evaluator_checkanimationagainstnavmesh));
	}
	return undefined;
}

/*
	Name: evaluatehumanexposedarrivalanimations
	Namespace: animation_selector_table_evaluators
	Checksum: 0x696DD51B
	Offset: 0xD38
	Size: 0x76
	Parameters: 2
	Flags: Linked, Private
*/
function private evaluatehumanexposedarrivalanimations(entity, animations)
{
	if(!isdefined(entity.pathgoalpos))
	{
		return undefined;
	}
	if(animations.size > 0)
	{
		return evaluator_findfirstvalidanimation(entity, animations, array(&evaluator_checkanimationarrivalposition));
	}
	return undefined;
}

