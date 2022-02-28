// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_state_machine;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;

#namespace aiutility;

/*
	Name: registerbehaviorscriptfunctions
	Namespace: aiutility
	Checksum: 0x993AEE67
	Offset: 0x618
	Size: 0x55C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec registerbehaviorscriptfunctions()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("locomotionBehaviorCondition", &locomotionbehaviorcondition);
	behaviorstatemachine::registerbsmscriptapiinternal("locomotionBehaviorCondition", &locomotionbehaviorcondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("nonCombatLocomotionCondition", &noncombatlocomotioncondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("setDesiredStanceForMovement", &setdesiredstanceformovement);
	behaviortreenetworkutility::registerbehaviortreescriptapi("clearPathFromScript", &clearpathfromscript);
	behaviortreenetworkutility::registerbehaviortreescriptapi("locomotionShouldPatrol", &locomotionshouldpatrol);
	behaviorstatemachine::registerbsmscriptapiinternal("locomotionShouldPatrol", &locomotionshouldpatrol);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldTacticalWalk", &shouldtacticalwalk);
	behaviorstatemachine::registerbsmscriptapiinternal("shouldTacticalWalk", &shouldtacticalwalk);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldAdjustStanceAtTacticalWalk", &shouldadjuststanceattacticalwalk);
	behaviortreenetworkutility::registerbehaviortreescriptapi("adjustStanceToFaceEnemyInitialize", &adjuststancetofaceenemyinitialize);
	behaviortreenetworkutility::registerbehaviortreescriptapi("adjustStanceToFaceEnemyTerminate", &adjuststancetofaceenemyterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("tacticalWalkActionStart", &tacticalwalkactionstart);
	behaviorstatemachine::registerbsmscriptapiinternal("tacticalWalkActionStart", &tacticalwalkactionstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("clearArrivalPos", &cleararrivalpos);
	behaviorstatemachine::registerbsmscriptapiinternal("clearArrivalPos", &cleararrivalpos);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldStartArrival", &shouldstartarrivalcondition);
	behaviorstatemachine::registerbsmscriptapiinternal("shouldStartArrival", &shouldstartarrivalcondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("locomotionShouldTraverse", &locomotionshouldtraverse);
	behaviorstatemachine::registerbsmscriptapiinternal("locomotionShouldTraverse", &locomotionshouldtraverse);
	behaviortreenetworkutility::registerbehaviortreeaction("traverseActionStart", &traverseactionstart, undefined, undefined);
	behaviorstatemachine::registerbsmscriptapiinternal("traverseSetup", &traversesetup);
	behaviortreenetworkutility::registerbehaviortreescriptapi("disableRepath", &disablerepath);
	behaviortreenetworkutility::registerbehaviortreescriptapi("enableRepath", &enablerepath);
	behaviortreenetworkutility::registerbehaviortreescriptapi("canJuke", &canjuke);
	behaviortreenetworkutility::registerbehaviortreescriptapi("chooseJukeDirection", &choosejukedirection);
	behaviorstatemachine::registerbsmscriptapiinternal("locomotionPainBehaviorCondition", &locomotionpainbehaviorcondition);
	behaviorstatemachine::registerbsmscriptapiinternal("locomotionIsOnStairs", &locomotionisonstairs);
	behaviorstatemachine::registerbsmscriptapiinternal("locomotionShouldLoopOnStairs", &locomotionshouldlooponstairs);
	behaviorstatemachine::registerbsmscriptapiinternal("locomotionShouldSkipStairs", &locomotionshouldskipstairs);
	behaviorstatemachine::registerbsmscriptapiinternal("locomotionStairsStart", &locomotionstairsstart);
	behaviorstatemachine::registerbsmscriptapiinternal("locomotionStairsEnd", &locomotionstairsend);
	behaviortreenetworkutility::registerbehaviortreescriptapi("delayMovement", &delaymovement);
	behaviorstatemachine::registerbsmscriptapiinternal("delayMovement", &delaymovement);
}

/*
	Name: locomotionisonstairs
	Namespace: aiutility
	Checksum: 0x5E696457
	Offset: 0xB80
	Size: 0xA6
	Parameters: 1
	Flags: Linked, Private
*/
function private locomotionisonstairs(behaviortreeentity)
{
	startnode = behaviortreeentity.traversestartnode;
	if(isdefined(startnode) && behaviortreeentity shouldstarttraversal())
	{
		if(isdefined(startnode.animscript) && issubstr(tolower(startnode.animscript), "stairs"))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: locomotionshouldskipstairs
	Namespace: aiutility
	Checksum: 0x4CDD98FA
	Offset: 0xC30
	Size: 0x15A
	Parameters: 1
	Flags: Linked, Private
*/
function private locomotionshouldskipstairs(behaviortreeentity)
{
	/#
		assert(isdefined(behaviortreeentity._stairsstartnode) && isdefined(behaviortreeentity._stairsendnode));
	#/
	numtotalsteps = blackboard::getblackboardattribute(behaviortreeentity, "_staircase_num_total_steps");
	stepssofar = blackboard::getblackboardattribute(behaviortreeentity, "_staircase_num_steps");
	direction = blackboard::getblackboardattribute(behaviortreeentity, "_staircase_direction");
	if(direction != "staircase_up")
	{
		return false;
	}
	numoutsteps = 2;
	totalstepswithoutout = numtotalsteps - numoutsteps;
	if(stepssofar >= totalstepswithoutout)
	{
		return false;
	}
	remainingsteps = totalstepswithoutout - stepssofar;
	if(remainingsteps >= 3 || remainingsteps >= 6 || remainingsteps >= 8)
	{
		return true;
	}
	return false;
}

/*
	Name: locomotionshouldlooponstairs
	Namespace: aiutility
	Checksum: 0x31E6D82D
	Offset: 0xD98
	Size: 0x18C
	Parameters: 1
	Flags: Linked, Private
*/
function private locomotionshouldlooponstairs(behaviortreeentity)
{
	/#
		assert(isdefined(behaviortreeentity._stairsstartnode) && isdefined(behaviortreeentity._stairsendnode));
	#/
	numtotalsteps = blackboard::getblackboardattribute(behaviortreeentity, "_staircase_num_total_steps");
	stepssofar = blackboard::getblackboardattribute(behaviortreeentity, "_staircase_num_steps");
	exittype = blackboard::getblackboardattribute(behaviortreeentity, "_staircase_exit_type");
	direction = blackboard::getblackboardattribute(behaviortreeentity, "_staircase_direction");
	numoutsteps = 2;
	if(direction == "staircase_up")
	{
		switch(exittype)
		{
			case "staircase_up_exit_l_3_stairs":
			case "staircase_up_exit_r_3_stairs":
			{
				numoutsteps = 3;
				break;
			}
			case "staircase_up_exit_l_4_stairs":
			case "staircase_up_exit_r_4_stairs":
			{
				numoutsteps = 4;
				break;
			}
		}
	}
	if(stepssofar >= (numtotalsteps - numoutsteps))
	{
		behaviortreeentity setstairsexittransform();
		return false;
	}
	return true;
}

/*
	Name: locomotionstairsstart
	Namespace: aiutility
	Checksum: 0x17CADFE5
	Offset: 0xF30
	Size: 0x390
	Parameters: 1
	Flags: Linked, Private
*/
function private locomotionstairsstart(behaviortreeentity)
{
	startnode = behaviortreeentity.traversestartnode;
	endnode = behaviortreeentity.traverseendnode;
	/#
		assert(isdefined(startnode) && isdefined(endnode));
	#/
	behaviortreeentity._stairsstartnode = startnode;
	behaviortreeentity._stairsendnode = endnode;
	if(startnode.type == "Begin")
	{
		direction = "staircase_down";
	}
	else
	{
		direction = "staircase_up";
	}
	blackboard::setblackboardattribute(behaviortreeentity, "_staircase_type", behaviortreeentity._stairsstartnode.animscript);
	blackboard::setblackboardattribute(behaviortreeentity, "_staircase_state", "staircase_start");
	blackboard::setblackboardattribute(behaviortreeentity, "_staircase_direction", direction);
	numtotalsteps = undefined;
	if(isdefined(startnode.script_int))
	{
		numtotalsteps = int(endnode.script_int);
	}
	else if(isdefined(endnode.script_int))
	{
		numtotalsteps = int(endnode.script_int);
	}
	/#
		assert(isdefined(numtotalsteps) && isint(numtotalsteps) && numtotalsteps > 0);
	#/
	blackboard::setblackboardattribute(behaviortreeentity, "_staircase_num_total_steps", numtotalsteps);
	blackboard::setblackboardattribute(behaviortreeentity, "_staircase_num_steps", 0);
	exittype = undefined;
	if(direction == "staircase_up")
	{
		switch(int(behaviortreeentity._stairsstartnode.script_int) % 4)
		{
			case 0:
			{
				exittype = "staircase_up_exit_r_3_stairs";
				break;
			}
			case 1:
			{
				exittype = "staircase_up_exit_r_4_stairs";
				break;
			}
			case 2:
			{
				exittype = "staircase_up_exit_l_3_stairs";
				break;
			}
			case 3:
			{
				exittype = "staircase_up_exit_l_4_stairs";
				break;
			}
		}
	}
	else
	{
		switch(int(behaviortreeentity._stairsstartnode.script_int) % 2)
		{
			case 0:
			{
				exittype = "staircase_down_exit_l_2_stairs";
				break;
			}
			case 1:
			{
				exittype = "staircase_down_exit_r_2_stairs";
				break;
			}
		}
	}
	blackboard::setblackboardattribute(behaviortreeentity, "_staircase_exit_type", exittype);
	return true;
}

/*
	Name: locomotionstairloopstart
	Namespace: aiutility
	Checksum: 0xC865E4BB
	Offset: 0x12C8
	Size: 0x6C
	Parameters: 1
	Flags: Private
*/
function private locomotionstairloopstart(behaviortreeentity)
{
	/#
		assert(isdefined(behaviortreeentity._stairsstartnode) && isdefined(behaviortreeentity._stairsendnode));
	#/
	blackboard::setblackboardattribute(behaviortreeentity, "_staircase_state", "staircase_loop");
}

/*
	Name: locomotionstairsend
	Namespace: aiutility
	Checksum: 0x40084F0D
	Offset: 0x1340
	Size: 0x4C
	Parameters: 1
	Flags: Linked, Private
*/
function private locomotionstairsend(behaviortreeentity)
{
	blackboard::setblackboardattribute(behaviortreeentity, "_staircase_state", undefined);
	blackboard::setblackboardattribute(behaviortreeentity, "_staircase_direction", undefined);
}

/*
	Name: locomotionpainbehaviorcondition
	Namespace: aiutility
	Checksum: 0xDED5D031
	Offset: 0x1398
	Size: 0x42
	Parameters: 1
	Flags: Linked, Private
*/
function private locomotionpainbehaviorcondition(entity)
{
	return entity haspath() && entity hasvalidinterrupt("pain");
}

/*
	Name: clearpathfromscript
	Namespace: aiutility
	Checksum: 0x8733D9C1
	Offset: 0x13E8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function clearpathfromscript(behaviortreeentity)
{
	behaviortreeentity clearpath();
}

/*
	Name: noncombatlocomotioncondition
	Namespace: aiutility
	Checksum: 0x40C8CC88
	Offset: 0x1418
	Size: 0x70
	Parameters: 1
	Flags: Linked, Private
*/
function private noncombatlocomotioncondition(behaviortreeentity)
{
	if(!behaviortreeentity haspath())
	{
		return false;
	}
	if(isdefined(behaviortreeentity.accuratefire) && behaviortreeentity.accuratefire)
	{
		return true;
	}
	if(isdefined(behaviortreeentity.enemy))
	{
		return false;
	}
	return true;
}

/*
	Name: combatlocomotioncondition
	Namespace: aiutility
	Checksum: 0x7E130122
	Offset: 0x1490
	Size: 0x6C
	Parameters: 1
	Flags: Private
*/
function private combatlocomotioncondition(behaviortreeentity)
{
	if(!behaviortreeentity haspath())
	{
		return false;
	}
	if(isdefined(behaviortreeentity.accuratefire) && behaviortreeentity.accuratefire)
	{
		return false;
	}
	if(isdefined(behaviortreeentity.enemy))
	{
		return true;
	}
	return false;
}

/*
	Name: locomotionbehaviorcondition
	Namespace: aiutility
	Checksum: 0x95D61DDA
	Offset: 0x1508
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function locomotionbehaviorcondition(behaviortreeentity)
{
	return behaviortreeentity haspath();
}

/*
	Name: setdesiredstanceformovement
	Namespace: aiutility
	Checksum: 0x35CE5FB6
	Offset: 0x1538
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private setdesiredstanceformovement(behaviortreeentity)
{
	if(blackboard::getblackboardattribute(behaviortreeentity, "_stance") != "stand")
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_desired_stance", "stand");
	}
}

/*
	Name: locomotionshouldtraverse
	Namespace: aiutility
	Checksum: 0x82F37E3F
	Offset: 0x15A0
	Size: 0x56
	Parameters: 1
	Flags: Linked, Private
*/
function private locomotionshouldtraverse(behaviortreeentity)
{
	startnode = behaviortreeentity.traversestartnode;
	if(isdefined(startnode) && behaviortreeentity shouldstarttraversal())
	{
		return true;
	}
	return false;
}

/*
	Name: traversesetup
	Namespace: aiutility
	Checksum: 0x30C97292
	Offset: 0x1600
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function traversesetup(behaviortreeentity)
{
	blackboard::setblackboardattribute(behaviortreeentity, "_stance", "stand");
	blackboard::setblackboardattribute(behaviortreeentity, "_traversal_type", behaviortreeentity.traversestartnode.animscript);
	return true;
}

/*
	Name: traverseactionstart
	Namespace: aiutility
	Checksum: 0x9DA120ED
	Offset: 0x1670
	Size: 0x100
	Parameters: 2
	Flags: Linked
*/
function traverseactionstart(behaviortreeentity, asmstatename)
{
	traversesetup(behaviortreeentity);
	/#
		animationresults = behaviortreeentity astsearch(istring(asmstatename));
		/#
			assert(isdefined(animationresults[""]), ((((behaviortreeentity.archetype + "") + behaviortreeentity.traversestartnode.animscript) + "") + behaviortreeentity.traversestartnode.origin) + "");
		#/
	#/
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	return 5;
}

/*
	Name: disablerepath
	Namespace: aiutility
	Checksum: 0x87E3AA3F
	Offset: 0x1778
	Size: 0x20
	Parameters: 1
	Flags: Linked, Private
*/
function private disablerepath(entity)
{
	entity.disablerepath = 1;
}

/*
	Name: enablerepath
	Namespace: aiutility
	Checksum: 0x52D28EE
	Offset: 0x17A0
	Size: 0x1C
	Parameters: 1
	Flags: Linked, Private
*/
function private enablerepath(entity)
{
	entity.disablerepath = 0;
}

/*
	Name: shouldstartarrivalcondition
	Namespace: aiutility
	Checksum: 0xEAE52FE1
	Offset: 0x17C8
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function shouldstartarrivalcondition(behaviortreeentity)
{
	if(behaviortreeentity shouldstartarrival())
	{
		return true;
	}
	return false;
}

/*
	Name: cleararrivalpos
	Namespace: aiutility
	Checksum: 0x1D818F77
	Offset: 0x1800
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function cleararrivalpos(behaviortreeentity)
{
	if(!isdefined(behaviortreeentity.isarrivalpending) || (isdefined(behaviortreeentity.isarrivalpending) && behaviortreeentity.isarrivalpending))
	{
		self clearuseposition();
	}
	return true;
}

/*
	Name: delaymovement
	Namespace: aiutility
	Checksum: 0xE3DA1A7F
	Offset: 0x1868
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function delaymovement(entity)
{
	entity pathmode("move delayed", 0, randomfloatrange(1, 2));
	return true;
}

/*
	Name: shouldadjuststanceattacticalwalk
	Namespace: aiutility
	Checksum: 0x18005F1C
	Offset: 0x18B8
	Size: 0x50
	Parameters: 1
	Flags: Linked, Private
*/
function private shouldadjuststanceattacticalwalk(behaviortreeentity)
{
	stance = blackboard::getblackboardattribute(behaviortreeentity, "_stance");
	if(stance != "stand")
	{
		return true;
	}
	return false;
}

/*
	Name: adjuststancetofaceenemyinitialize
	Namespace: aiutility
	Checksum: 0x7B3442D
	Offset: 0x1910
	Size: 0x68
	Parameters: 1
	Flags: Linked, Private
*/
function private adjuststancetofaceenemyinitialize(behaviortreeentity)
{
	behaviortreeentity.newenemyreaction = 0;
	blackboard::setblackboardattribute(behaviortreeentity, "_desired_stance", "stand");
	behaviortreeentity orientmode("face enemy");
	return true;
}

/*
	Name: adjuststancetofaceenemyterminate
	Namespace: aiutility
	Checksum: 0x5B09BFAC
	Offset: 0x1980
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private adjuststancetofaceenemyterminate(behaviortreeentity)
{
	blackboard::setblackboardattribute(behaviortreeentity, "_stance", "stand");
}

/*
	Name: tacticalwalkactionstart
	Namespace: aiutility
	Checksum: 0x1F79EA79
	Offset: 0x19C0
	Size: 0xA0
	Parameters: 1
	Flags: Linked, Private
*/
function private tacticalwalkactionstart(behaviortreeentity)
{
	cleararrivalpos(behaviortreeentity);
	resetcoverparameters(behaviortreeentity);
	setcanbeflanked(behaviortreeentity, 0);
	blackboard::setblackboardattribute(behaviortreeentity, "_stance", "stand");
	behaviortreeentity orientmode("face enemy");
	return true;
}

/*
	Name: validjukedirection
	Namespace: aiutility
	Checksum: 0xDA2B73A9
	Offset: 0x1A68
	Size: 0x14A
	Parameters: 4
	Flags: Linked, Private
*/
function private validjukedirection(entity, entitynavmeshposition, forwardoffset, lateraloffset)
{
	jukenavmeshthreshold = 6;
	forwardposition = (entity.origin + lateraloffset) + forwardoffset;
	backwardposition = (entity.origin + lateraloffset) - forwardoffset;
	forwardpositionvalid = ispointonnavmesh(forwardposition, entity) && tracepassedonnavmesh(entity.origin, forwardposition);
	backwardpositionvalid = ispointonnavmesh(backwardposition, entity) && tracepassedonnavmesh(entity.origin, backwardposition);
	if(!isdefined(entity.ignorebackwardposition))
	{
		return forwardpositionvalid && backwardpositionvalid;
	}
	return forwardpositionvalid;
}

/*
	Name: calculatejukedirection
	Namespace: aiutility
	Checksum: 0x260240EA
	Offset: 0x1BC0
	Size: 0x31C
	Parameters: 3
	Flags: Linked
*/
function calculatejukedirection(entity, entityradius, jukedistance)
{
	jukenavmeshthreshold = 6;
	defaultdirection = "forward";
	if(isdefined(entity.defaultjukedirection))
	{
		defaultdirection = entity.defaultjukedirection;
	}
	if(isdefined(entity.enemy))
	{
		navmeshposition = getclosestpointonnavmesh(entity.origin, jukenavmeshthreshold);
		if(!isvec(navmeshposition))
		{
			return defaultdirection;
		}
		vectortoenemy = entity.enemy.origin - entity.origin;
		vectortoenemyangles = vectortoangles(vectortoenemy);
		forwarddistance = anglestoforward(vectortoenemyangles) * entityradius;
		rightjukedistance = anglestoright(vectortoenemyangles) * jukedistance;
		preferleft = undefined;
		if(entity haspath())
		{
			rightposition = entity.origin + rightjukedistance;
			leftposition = entity.origin - rightjukedistance;
			preferleft = distancesquared(leftposition, entity.pathgoalpos) <= distancesquared(rightposition, entity.pathgoalpos);
		}
		else
		{
			preferleft = math::cointoss();
		}
		if(preferleft)
		{
			if(validjukedirection(entity, navmeshposition, forwarddistance, rightjukedistance * -1))
			{
				return "left";
			}
			if(validjukedirection(entity, navmeshposition, forwarddistance, rightjukedistance))
			{
				return "right";
			}
		}
		else
		{
			if(validjukedirection(entity, navmeshposition, forwarddistance, rightjukedistance))
			{
				return "right";
			}
			if(validjukedirection(entity, navmeshposition, forwarddistance, rightjukedistance * -1))
			{
				return "left";
			}
		}
	}
	return defaultdirection;
}

/*
	Name: calculatedefaultjukedirection
	Namespace: aiutility
	Checksum: 0xBF77357
	Offset: 0x1EE8
	Size: 0x9A
	Parameters: 1
	Flags: Linked, Private
*/
function private calculatedefaultjukedirection(entity)
{
	jukedistance = 30;
	entityradius = 15;
	if(isdefined(entity.jukedistance))
	{
		jukedistance = entity.jukedistance;
	}
	if(isdefined(entity.entityradius))
	{
		entityradius = entity.entityradius;
	}
	return calculatejukedirection(entity, entityradius, jukedistance);
}

/*
	Name: canjuke
	Namespace: aiutility
	Checksum: 0xABDAAFF4
	Offset: 0x1F90
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function canjuke(entity)
{
	if(isdefined(self.is_disabled) && self.is_disabled)
	{
		return 0;
	}
	if(isdefined(entity.jukemaxdistance) && isdefined(entity.enemy))
	{
		maxdistsquared = entity.jukemaxdistance * entity.jukemaxdistance;
		if(distance2dsquared(entity.origin, entity.enemy.origin) > maxdistsquared)
		{
			return 0;
		}
	}
	jukedirection = calculatedefaultjukedirection(entity);
	return jukedirection != "forward";
}

/*
	Name: choosejukedirection
	Namespace: aiutility
	Checksum: 0xA9C71271
	Offset: 0x2080
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function choosejukedirection(entity)
{
	jukedirection = calculatedefaultjukedirection(entity);
	blackboard::setblackboardattribute(entity, "_juke_direction", jukedirection);
}

