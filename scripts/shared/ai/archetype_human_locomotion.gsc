// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_state_machine;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;

#namespace archetype_human_locomotion;

/*
	Name: registerbehaviorscriptfunctions
	Namespace: archetype_human_locomotion
	Checksum: 0x40CF54E3
	Offset: 0x558
	Size: 0x39C
	Parameters: 0
	Flags: AutoExec
*/
autoexec function registerbehaviorscriptfunctions()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("prepareForMovement", &prepareformovement);
	behaviorstatemachine::registerbsmscriptapiinternal("prepareForMovement", &prepareformovement);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldTacticalArrive", &shouldtacticalarrivecondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("humanShouldSprint", &humanshouldsprint);
	behaviorstatemachine::registerbsmscriptapiinternal("planHumanArrivalAtCover", &planhumanarrivalatcover);
	behaviorstatemachine::registerbsmscriptapiinternal("shouldPlanArrivalIntoCover", &shouldplanarrivalintocover);
	behaviorstatemachine::registerbsmscriptapiinternal("shouldArriveExposed", &shouldarriveexposed);
	behaviorstatemachine::registerbsmscriptapiinternal("nonCombatLocomotionUpdate", &noncombatlocomotionupdate);
	behaviorstatemachine::registerbsmscriptapiinternal("combatLocomotionStart", &combatlocomotionstart);
	behaviorstatemachine::registerbsmscriptapiinternal("combatLocomotionUpdate", &combatlocomotionupdate);
	behaviorstatemachine::registerbsmscriptapiinternal("humanNonCombatLocomotionCondition", &humannoncombatlocomotioncondition);
	behaviorstatemachine::registerbsmscriptapiinternal("humanCombatLocomotionCondition", &humancombatlocomotioncondition);
	behaviorstatemachine::registerbsmscriptapiinternal("shouldSwitchToTacticalWalkFromRun", &shouldswitchtotacticalwalkfromrun);
	behaviortreenetworkutility::registerbehaviortreescriptapi("prepareToStopNearEnemy", &preparetostopnearenemy);
	behaviorstatemachine::registerbsmscriptapiinternal("prepareToStopNearEnemy", &preparetostopnearenemy);
	behaviortreenetworkutility::registerbehaviortreescriptapi("prepareToMoveAwayFromNearByEnemy", &preparetomoveawayfromnearbyenemy);
	behaviorstatemachine::registerbsmscriptapiinternal("shouldTacticalWalkPain", &shouldtacticalwalkpain);
	behaviorstatemachine::registerbsmscriptapiinternal("beginTacticalWalkPain", &begintacticalwalkpain);
	behaviorstatemachine::registerbsmscriptapiinternal("shouldContinueTacticalWalkPain", &shouldcontinuetacticalwalkpain);
	behaviorstatemachine::registerbsmscriptapiinternal("shouldTacticalWalkScan", &shouldtacticalwalkscan);
	behaviorstatemachine::registerbsmscriptapiinternal("continueTacticalWalkScan", &continuetacticalwalkscan);
	behaviorstatemachine::registerbsmscriptapiinternal("tacticalWalkScanTerminate", &tacticalwalkscanterminate);
	behaviorstatemachine::registerbsmscriptapiinternal("BSMLocomotionHasValidPainInterrupt", &bsmlocomotionhasvalidpaininterrupt);
}

/*
	Name: tacticalwalkscanterminate
	Namespace: archetype_human_locomotion
	Checksum: 0x221BBFA9
	Offset: 0x900
	Size: 0x20
	Parameters: 1
	Flags: Linked, Private
*/
private function tacticalwalkscanterminate(entity)
{
	entity.lasttacticalscantime = gettime();
	return 1;
}

/*
	Name: shouldtacticalwalkscan
	Namespace: archetype_human_locomotion
	Checksum: 0x6E9EBED3
	Offset: 0x928
	Size: 0x130
	Parameters: 1
	Flags: Linked, Private
*/
private function shouldtacticalwalkscan(entity)
{
	if(isdefined(entity.lasttacticalscantime) && entity.lasttacticalscantime + 2000 > gettime())
	{
		return 0;
	}
	if(!entity haspath())
	{
		return 0;
	}
	if(isdefined(entity.enemy))
	{
		return 0;
	}
	if(entity shouldfacemotion())
	{
		if(ai::hasaiattribute(entity, "forceTacticalWalk") && !ai::getaiattribute(entity, "forceTacticalWalk"))
		{
			return 0;
		}
	}
	animation = entity asmgetcurrentdeltaanimation();
	if(isdefined(animation))
	{
		animtime = entity getanimtime(animation);
		return animtime <= 0.05;
	}
	return 0;
}

/*
	Name: continuetacticalwalkscan
	Namespace: archetype_human_locomotion
	Checksum: 0x724E8970
	Offset: 0xA60
	Size: 0x150
	Parameters: 1
	Flags: Linked, Private
*/
private function continuetacticalwalkscan(entity)
{
	if(!entity haspath())
	{
		return 0;
	}
	if(isdefined(entity.enemy))
	{
		return 0;
	}
	if(entity shouldfacemotion())
	{
		if(ai::hasaiattribute(entity, "forceTacticalWalk") && !ai::getaiattribute(entity, "forceTacticalWalk"))
		{
			return 0;
		}
	}
	animation = entity asmgetcurrentdeltaanimation();
	if(isdefined(animation))
	{
		animlength = getanimlength(animation);
		animtime = entity getanimtime(animation) * animlength;
		normalizedtime = animtime + 0.2 / animlength;
		return normalizedtime < 1;
	}
	return 0;
}

/*
	Name: shouldtacticalwalkpain
	Namespace: archetype_human_locomotion
	Checksum: 0xAE808487
	Offset: 0xBB8
	Size: 0x76
	Parameters: 1
	Flags: Linked, Private
*/
private function shouldtacticalwalkpain(entity)
{
	if(!isdefined(entity.startpaintime) || entity.startpaintime + 3000 < gettime() && randomfloat(1) > 0.25)
	{
		return bsmlocomotionhasvalidpaininterrupt(entity);
	}
	return 0;
}

/*
	Name: begintacticalwalkpain
	Namespace: archetype_human_locomotion
	Checksum: 0x31754BAB
	Offset: 0xC38
	Size: 0x20
	Parameters: 1
	Flags: Linked, Private
*/
private function begintacticalwalkpain(entity)
{
	entity.startpaintime = gettime();
	return 1;
}

/*
	Name: shouldcontinuetacticalwalkpain
	Namespace: archetype_human_locomotion
	Checksum: 0xD50DB974
	Offset: 0xC60
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
private function shouldcontinuetacticalwalkpain(entity)
{
	return entity.startpaintime + 100 >= gettime();
}

/*
	Name: bsmlocomotionhasvalidpaininterrupt
	Namespace: archetype_human_locomotion
	Checksum: 0xEF2852B0
	Offset: 0xC90
	Size: 0x2A
	Parameters: 1
	Flags: Linked, Private
*/
private function bsmlocomotionhasvalidpaininterrupt(entity)
{
	return entity hasvalidinterrupt("pain");
}

/*
	Name: shouldarriveexposed
	Namespace: archetype_human_locomotion
	Checksum: 0xDC6BA5AC
	Offset: 0xCC8
	Size: 0xDC
	Parameters: 1
	Flags: Linked, Private
*/
private function shouldarriveexposed(behaviortreeentity)
{
	if(behaviortreeentity ai::get_behavior_attribute("disablearrivals"))
	{
		return 0;
	}
	if(behaviortreeentity haspath())
	{
		if(isdefined(behaviortreeentity.node) && iscovernode(behaviortreeentity.node) && isdefined(behaviortreeentity.pathgoalpos) && distancesquared(behaviortreeentity.pathgoalpos, behaviortreeentity getnodeoffsetposition(behaviortreeentity.node)) < 8)
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: preparetostopnearenemy
	Namespace: archetype_human_locomotion
	Checksum: 0x2AB3796A
	Offset: 0xDB0
	Size: 0x38
	Parameters: 1
	Flags: Linked, Private
*/
private function preparetostopnearenemy(behaviortreeentity)
{
	behaviortreeentity clearpath();
	behaviortreeentity.keepclaimednode = 1;
}

/*
	Name: preparetomoveawayfromnearbyenemy
	Namespace: archetype_human_locomotion
	Checksum: 0x4F1F9820
	Offset: 0xDF0
	Size: 0x38
	Parameters: 1
	Flags: Linked, Private
*/
private function preparetomoveawayfromnearbyenemy(behaviortreeentity)
{
	behaviortreeentity clearpath();
	behaviortreeentity.keepclaimednode = 1;
}

/*
	Name: shouldplanarrivalintocover
	Namespace: archetype_human_locomotion
	Checksum: 0xD9D4D520
	Offset: 0xE30
	Size: 0x1B8
	Parameters: 1
	Flags: Linked, Private
*/
private function shouldplanarrivalintocover(behaviortreeentity)
{
	goingtocovernode = isdefined(behaviortreeentity.node) && iscovernode(behaviortreeentity.node);
	if(!goingtocovernode)
	{
		return 0;
	}
	if(isdefined(behaviortreeentity.pathgoalpos))
	{
		if(isdefined(behaviortreeentity.arrivalfinalpos))
		{
			if(behaviortreeentity.arrivalfinalpos != behaviortreeentity.pathgoalpos)
			{
				return 1;
			}
			if(behaviortreeentity.replannedcoverarrival === 0 && isdefined(behaviortreeentity.exitpos) && isdefined(behaviortreeentity.predictedexitpos))
			{
				behaviortreeentity.replannedcoverarrival = 1;
				exitdir = vectornormalize(behaviortreeentity.predictedexitpos - behaviortreeentity.exitpos);
				currentdir = vectornormalize(behaviortreeentity.origin - behaviortreeentity.exitpos);
				if(vectordot(exitdir, currentdir) < cos(30))
				{
					behaviortreeentity.predictedarrivaldirectionvalid = 0;
					return 1;
				}
			}
		}
	}
	return 0;
}

/*
	Name: shouldswitchtotacticalwalkfromrun
	Namespace: archetype_human_locomotion
	Checksum: 0xFE6A6802
	Offset: 0xFF0
	Size: 0x146
	Parameters: 1
	Flags: Linked, Private
*/
private function shouldswitchtotacticalwalkfromrun(behaviortreeentity)
{
	if(!behaviortreeentity haspath())
	{
		return 0;
	}
	if(ai::hasaiattribute(behaviortreeentity, "forceTacticalWalk") && ai::getaiattribute(behaviortreeentity, "forceTacticalWalk"))
	{
		return 1;
	}
	goalpos = undefined;
	if(isdefined(behaviortreeentity.arrivalfinalpos))
	{
		goalpos = behaviortreeentity.arrivalfinalpos;
	}
	else
	{
		goalpos = behaviortreeentity.pathgoalpos;
	}
	if(isdefined(behaviortreeentity.pathstartpos) && isdefined(goalpos))
	{
		pathdist = distancesquared(behaviortreeentity.pathstartpos, goalpos);
		if(pathdist < 250 * 250)
		{
			return 1;
		}
	}
	if(!behaviortreeentity shouldfacemotion())
	{
		return 1;
	}
	return 0;
}

/*
	Name: humannoncombatlocomotioncondition
	Namespace: archetype_human_locomotion
	Checksum: 0x4F255D2F
	Offset: 0x1140
	Size: 0x90
	Parameters: 1
	Flags: Linked, Private
*/
private function humannoncombatlocomotioncondition(behaviortreeentity)
{
	if(!behaviortreeentity haspath())
	{
		return 0;
	}
	if(isdefined(behaviortreeentity.accuratefire) && behaviortreeentity.accuratefire)
	{
		return 1;
	}
	if(behaviortreeentity humanshouldsprint())
	{
		return 1;
	}
	if(isdefined(behaviortreeentity.enemy))
	{
		return 0;
	}
	return 1;
}

/*
	Name: humancombatlocomotioncondition
	Namespace: archetype_human_locomotion
	Checksum: 0xB2EB04DA
	Offset: 0x11D8
	Size: 0x8C
	Parameters: 1
	Flags: Linked, Private
*/
private function humancombatlocomotioncondition(behaviortreeentity)
{
	if(!behaviortreeentity haspath())
	{
		return 0;
	}
	if(isdefined(behaviortreeentity.accuratefire) && behaviortreeentity.accuratefire)
	{
		return 0;
	}
	if(behaviortreeentity humanshouldsprint())
	{
		return 0;
	}
	if(isdefined(behaviortreeentity.enemy))
	{
		return 1;
	}
	return 0;
}

/*
	Name: combatlocomotionstart
	Namespace: archetype_human_locomotion
	Checksum: 0xACDA02EF
	Offset: 0x1270
	Size: 0xC8
	Parameters: 1
	Flags: Linked, Private
*/
private function combatlocomotionstart(behaviortreeentity)
{
	randomchance = randomint(100);
	if(randomchance > 50)
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_run_n_gun_variation", "variation_forward");
		return 1;
	}
	if(randomchance > 25)
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_run_n_gun_variation", "variation_strafe_1");
		return 1;
	}
	blackboard::setblackboardattribute(behaviortreeentity, "_run_n_gun_variation", "variation_strafe_2");
	return 1;
}

/*
	Name: noncombatlocomotionupdate
	Namespace: archetype_human_locomotion
	Checksum: 0xB1B0623C
	Offset: 0x1340
	Size: 0xFE
	Parameters: 1
	Flags: Linked, Private
*/
private function noncombatlocomotionupdate(behaviortreeentity)
{
	if(!behaviortreeentity haspath())
	{
		return 0;
	}
	if(isdefined(behaviortreeentity.enemy) && (!(isdefined(behaviortreeentity.accuratefire) && behaviortreeentity.accuratefire) && !behaviortreeentity humanshouldsprint()))
	{
		return 0;
	}
	if(!behaviortreeentity asmistransitionrunning())
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_stance", "stand");
		if(!isdefined(behaviortreeentity.replannedcoverarrival))
		{
			behaviortreeentity.replannedcoverarrival = 0;
		}
	}
	else
	{
		behaviortreeentity.replannedcoverarrival = undefined;
	}
	return 1;
}

/*
	Name: combatlocomotionupdate
	Namespace: archetype_human_locomotion
	Checksum: 0x77C81A0A
	Offset: 0x1448
	Size: 0xDC
	Parameters: 1
	Flags: Linked, Private
*/
private function combatlocomotionupdate(behaviortreeentity)
{
	if(!behaviortreeentity haspath())
	{
		return 0;
	}
	if(behaviortreeentity humanshouldsprint())
	{
		return 0;
	}
	if(!behaviortreeentity asmistransitionrunning())
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_stance", "stand");
		if(!isdefined(behaviortreeentity.replannedcoverarrival))
		{
			behaviortreeentity.replannedcoverarrival = 0;
		}
	}
	else
	{
		behaviortreeentity.replannedcoverarrival = undefined;
	}
	if(isdefined(behaviortreeentity.enemy))
	{
		return 1;
	}
	return 0;
}

/*
	Name: prepareformovement
	Namespace: archetype_human_locomotion
	Checksum: 0xDE44EABB
	Offset: 0x1530
	Size: 0x38
	Parameters: 1
	Flags: Linked, Private
*/
private function prepareformovement(behaviortreeentity)
{
	blackboard::setblackboardattribute(behaviortreeentity, "_stance", "stand");
	return 1;
}

/*
	Name: isarrivingfour
	Namespace: archetype_human_locomotion
	Checksum: 0x991C0B9C
	Offset: 0x1570
	Size: 0x30
	Parameters: 1
	Flags: Linked, Private
*/
private function isarrivingfour(arrivalangle)
{
	if(arrivalangle >= 45 && arrivalangle <= 120)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isarrivingone
	Namespace: archetype_human_locomotion
	Checksum: 0x562A9B33
	Offset: 0x15A8
	Size: 0x30
	Parameters: 1
	Flags: Linked, Private
*/
private function isarrivingone(arrivalangle)
{
	if(arrivalangle >= 120 && arrivalangle <= 165)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isarrivingtwo
	Namespace: archetype_human_locomotion
	Checksum: 0x77E6A1A3
	Offset: 0x15E0
	Size: 0x30
	Parameters: 1
	Flags: Linked, Private
*/
private function isarrivingtwo(arrivalangle)
{
	if(arrivalangle >= 165 && arrivalangle <= 195)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isarrivingthree
	Namespace: archetype_human_locomotion
	Checksum: 0x11597442
	Offset: 0x1618
	Size: 0x30
	Parameters: 1
	Flags: Linked, Private
*/
private function isarrivingthree(arrivalangle)
{
	if(arrivalangle >= 195 && arrivalangle <= 240)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isarrivingsix
	Namespace: archetype_human_locomotion
	Checksum: 0x2DA9B06C
	Offset: 0x1650
	Size: 0x30
	Parameters: 1
	Flags: Linked, Private
*/
private function isarrivingsix(arrivalangle)
{
	if(arrivalangle >= 240 && arrivalangle <= 315)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isfacingfour
	Namespace: archetype_human_locomotion
	Checksum: 0xDFA41AEA
	Offset: 0x1688
	Size: 0x30
	Parameters: 1
	Flags: Linked, Private
*/
private function isfacingfour(facingangle)
{
	if(facingangle >= 45 && facingangle <= 135)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isfacingeight
	Namespace: archetype_human_locomotion
	Checksum: 0x364207B9
	Offset: 0x16C0
	Size: 0x30
	Parameters: 1
	Flags: Linked, Private
*/
private function isfacingeight(facingangle)
{
	if(facingangle >= -45 && facingangle <= 45)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isfacingseven
	Namespace: archetype_human_locomotion
	Checksum: 0xD3A84200
	Offset: 0x16F8
	Size: 0x2E
	Parameters: 1
	Flags: Linked, Private
*/
private function isfacingseven(facingangle)
{
	if(facingangle >= 0 && facingangle <= 90)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isfacingsix
	Namespace: archetype_human_locomotion
	Checksum: 0x7E65C9CB
	Offset: 0x1730
	Size: 0x30
	Parameters: 1
	Flags: Linked, Private
*/
private function isfacingsix(facingangle)
{
	if(facingangle >= -135 && facingangle <= -45)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isfacingnine
	Namespace: archetype_human_locomotion
	Checksum: 0x8FC3CFEB
	Offset: 0x1768
	Size: 0x2E
	Parameters: 1
	Flags: Linked, Private
*/
private function isfacingnine(facingangle)
{
	if(facingangle >= -90 && facingangle <= 0)
	{
		return 1;
	}
	return 0;
}

/*
	Name: shouldtacticalarrivecondition
	Namespace: archetype_human_locomotion
	Checksum: 0xC6224FEB
	Offset: 0x17A0
	Size: 0x400
	Parameters: 1
	Flags: Linked, Private
*/
private function shouldtacticalarrivecondition(behaviortreeentity)
{
	if(getdvarint("enableTacticalArrival") != 1)
	{
		return 0;
	}
	if(!isdefined(behaviortreeentity.node))
	{
		return 0;
	}
	if(!behaviortreeentity.node.type == "Cover Left")
	{
		return 0;
	}
	stance = blackboard::getblackboardattribute(behaviortreeentity, "_arrival_stance");
	if(stance != "stand")
	{
		return 0;
	}
	arrivaldistance = 35;
	/#
		arrivaldvar = getdvarint("");
		if(arrivaldvar != 0)
		{
			arrivaldistance = arrivaldvar;
		}
	#/
	nodeoffsetposition = behaviortreeentity getnodeoffsetposition(behaviortreeentity.node);
	if(distance(nodeoffsetposition, behaviortreeentity.origin) > arrivaldistance || distance(nodeoffsetposition, behaviortreeentity.origin) < 25)
	{
		return 0;
	}
	entityangles = vectortoangles(behaviortreeentity.origin - nodeoffsetposition);
	if(abs(behaviortreeentity.node.angles[1] - entityangles[1]) < 60)
	{
		return 0;
	}
	tacticalfaceangle = blackboard::getblackboardattribute(behaviortreeentity, "_tactical_arrival_facing_yaw");
	arrivalangle = blackboard::getblackboardattribute(behaviortreeentity, "_locomotion_arrival_yaw");
	if(isarrivingfour(arrivalangle))
	{
		if(!isfacingsix(tacticalfaceangle) && !isfacingeight(tacticalfaceangle) && !isfacingfour(tacticalfaceangle))
		{
			return 0;
		}
	}
	else if(isarrivingone(arrivalangle))
	{
		if(!isfacingnine(tacticalfaceangle) && !isfacingseven(tacticalfaceangle))
		{
			return 0;
		}
	}
	else if(isarrivingtwo(arrivalangle))
	{
		if(!isfacingeight(tacticalfaceangle))
		{
			return 0;
		}
	}
	else if(isarrivingthree(arrivalangle))
	{
		if(!isfacingseven(tacticalfaceangle) && !isfacingnine(tacticalfaceangle))
		{
			return 0;
		}
	}
	else if(isarrivingsix(arrivalangle))
	{
		if(!isfacingfour(tacticalfaceangle) && !isfacingeight(tacticalfaceangle) && !isfacingsix(tacticalfaceangle))
		{
			return 0;
		}
	}
	else
	{
		return 0;
	}
	return 1;
}

/*
	Name: humanshouldsprint
	Namespace: archetype_human_locomotion
	Checksum: 0xA6B2A3B8
	Offset: 0x1BA8
	Size: 0x3C
	Parameters: 0
	Flags: Linked, Private
*/
private function humanshouldsprint()
{
	currentlocomovementtype = blackboard::getblackboardattribute(self, "_human_locomotion_movement_type");
	return currentlocomovementtype == "human_locomotion_movement_sprint";
}

/*
	Name: planhumanarrivalatcover
	Namespace: archetype_human_locomotion
	Checksum: 0xB7B2B442
	Offset: 0x1BF0
	Size: 0x57C
	Parameters: 2
	Flags: Linked, Private
*/
private function planhumanarrivalatcover(behaviortreeentity, arrivalanim)
{
	if(behaviortreeentity ai::get_behavior_attribute("disablearrivals"))
	{
		return 0;
	}
	blackboard::setblackboardattribute(behaviortreeentity, "_desired_stance", "stand");
	if(!isdefined(arrivalanim))
	{
		return 0;
	}
	if(isdefined(behaviortreeentity.node) && isdefined(behaviortreeentity.pathgoalpos))
	{
		if(!iscovernode(behaviortreeentity.node))
		{
			return 0;
		}
		nodeoffsetposition = behaviortreeentity getnodeoffsetposition(behaviortreeentity.node);
		if(nodeoffsetposition != behaviortreeentity.pathgoalpos)
		{
			return 0;
		}
		if(isdefined(arrivalanim))
		{
			isright = behaviortreeentity.node.type == "Cover Right";
			splittime = getarrivalsplittime(arrivalanim, isright);
			issplitarrival = splittime < 1;
			nodeapproachyaw = behaviortreeentity getnodeoffsetangles(behaviortreeentity.node)[1];
			angle = (0, nodeapproachyaw - getangledelta(arrivalanim), 0);
			if(issplitarrival)
			{
				forwarddir = anglestoforward(angle);
				rightdir = anglestoright(angle);
				animlength = getanimlength(arrivalanim);
				movedelta = getmovedelta(arrivalanim, 0, animlength - 0.2 / animlength);
				premovedelta = getmovedelta(arrivalanim, 0, splittime);
				postmovedelta = movedelta - premovedelta;
				forward = vectorscale(forwarddir, postmovedelta[0]);
				right = vectorscale(rightdir, postmovedelta[1]);
				coverenterpos = nodeoffsetposition - forward + right;
				postenterpos = coverenterpos;
				forward = vectorscale(forwarddir, premovedelta[0]);
				right = vectorscale(rightdir, premovedelta[1]);
				coverenterpos = coverenterpos - forward + right;
				/#
					recordline(postenterpos, nodeoffsetposition, (1, 0.5, 0), "", behaviortreeentity);
					recordline(coverenterpos, postenterpos, (1, 0.5, 0), "", behaviortreeentity);
				#/
				if(!behaviortreeentity maymovefrompointtopoint(postenterpos, nodeoffsetposition, 1, 0))
				{
					return 0;
				}
				if(!behaviortreeentity maymovefrompointtopoint(coverenterpos, postenterpos, 1, 0))
				{
					return 0;
				}
			}
			else
			{
				forwarddir = anglestoforward(angle);
				rightdir = anglestoright(angle);
				movedeltaarray = getmovedelta(arrivalanim);
				forward = vectorscale(forwarddir, movedeltaarray[0]);
				right = vectorscale(rightdir, movedeltaarray[1]);
				coverenterpos = nodeoffsetposition - forward + right;
				if(!behaviortreeentity maymovefrompointtopoint(coverenterpos, nodeoffsetposition, 1, 1))
				{
					return 0;
				}
			}
			if(!checkcoverarrivalconditions(coverenterpos, nodeoffsetposition))
			{
				return 0;
			}
			if(ispointonnavmesh(coverenterpos, behaviortreeentity))
			{
				/#
					recordcircle(coverenterpos, 2, (1, 0, 0), "", behaviortreeentity);
				#/
				behaviortreeentity useposition(coverenterpos, behaviortreeentity.pathgoalpos);
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: checkcoverarrivalconditions
	Namespace: archetype_human_locomotion
	Checksum: 0x686DF052
	Offset: 0x2178
	Size: 0x2DC
	Parameters: 2
	Flags: Linked, Private
*/
private function checkcoverarrivalconditions(coverenterpos, coverpos)
{
	distsqtonode = distancesquared(self.origin, coverpos);
	distsqfromnodetoenterpos = distancesquared(coverpos, coverenterpos);
	awayfromenterpos = distsqtonode >= distsqfromnodetoenterpos + 150;
	if(!awayfromenterpos)
	{
		return 0;
	}
	trace = groundtrace(coverenterpos + vectorscale((0, 0, 1), 72), coverenterpos + vectorscale((0, 0, -1), 72), 0, 0, 0);
	if(isdefined(trace["position"]) && abs(trace["position"][2] - coverpos[2]) > 30)
	{
		/#
			if(getdvarint(""))
			{
				recordcircle(coverenterpos, 1, (1, 0, 0), "");
				record3dtext("", coverenterpos, (1, 0, 0), "", undefined, 0.4);
				recordcircle(trace[""], 1, (1, 0, 0), "");
				record3dtext("" + int(abs(trace[""][2] - coverpos[2])), trace[""] + vectorscale((0, 0, 1), 5), (1, 0, 0), "", undefined, 0.4);
				record3dtext("" + 30, trace[""], (1, 0, 0), "", undefined, 0.4);
				recordline(coverenterpos, trace[""], (1, 0, 0), "");
			}
		#/
		return 0;
	}
	return 1;
}

/*
	Name: getarrivalsplittime
	Namespace: archetype_human_locomotion
	Checksum: 0xE2BF33C2
	Offset: 0x2460
	Size: 0x2D6
	Parameters: 2
	Flags: Linked, Private
*/
private function getarrivalsplittime(arrivalanim, isright)
{
	if(!isdefined(level.animarrivalsplittimes))
	{
		level.animarrivalsplittimes = [];
	}
	if(isdefined(level.animarrivalsplittimes[arrivalanim]))
	{
		return level.animarrivalsplittimes[arrivalanim];
	}
	bestsplit = -1;
	if(animhasnotetrack(arrivalanim, "cover_split"))
	{
		times = getnotetracktimes(arrivalanim, "cover_split");
		/#
			assert(times.size > 0);
		#/
		bestsplit = times[0];
	}
	else
	{
		animlength = getanimlength(arrivalanim);
		normalizedlength = animlength - 0.2 / animlength;
		angledelta = getangledelta(arrivalanim, 0, normalizedlength);
		fulldelta = getmovedelta(arrivalanim, 0, normalizedlength);
		bestvalue = -100000000;
		for(i = 0; i < 100; i++)
		{
			splittime = 1 * i / 100 - 1;
			delta = getmovedelta(arrivalanim, 0, splittime);
			delta = deltarotate(fulldelta - delta, 180 - angledelta);
			if(isright)
			{
				delta = (delta[0], 0 - delta[1], delta[2]);
			}
			val = min(delta[0] - 32, delta[1]);
			if(val > bestvalue || bestsplit < 0)
			{
				bestvalue = val;
				bestsplit = splittime;
			}
		}
	}
	level.animarrivalsplittimes[arrivalanim] = bestsplit;
	return bestsplit;
}

/*
	Name: deltarotate
	Namespace: archetype_human_locomotion
	Checksum: 0x2D89B03D
	Offset: 0x2740
	Size: 0x9C
	Parameters: 2
	Flags: Linked, Private
*/
private function deltarotate(delta, yaw)
{
	cosine = cos(yaw);
	sine = sin(yaw);
	return (delta[0] * cosine - delta[1] * sine, delta[1] * cosine + delta[0] * sine, 0);
}

