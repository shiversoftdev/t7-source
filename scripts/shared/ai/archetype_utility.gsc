// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_aivsaimelee;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_state_machine;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#namespace aiutility;

/*
	Name: registerbehaviorscriptfunctions
	Namespace: aiutility
	Checksum: 0x81C2CEDF
	Offset: 0x11F8
	Size: 0xBC4
	Parameters: 0
	Flags: AutoExec
*/
function autoexec registerbehaviorscriptfunctions()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("forceRagdoll", &forceragdoll);
	behaviortreenetworkutility::registerbehaviortreescriptapi("hasAmmo", &hasammo);
	behaviortreenetworkutility::registerbehaviortreescriptapi("hasLowAmmo", &haslowammo);
	behaviortreenetworkutility::registerbehaviortreescriptapi("hasEnemy", &hasenemy);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isSafeFromGrenades", &issafefromgrenades);
	behaviortreenetworkutility::registerbehaviortreescriptapi("inGrenadeBlastRadius", &ingrenadeblastradius);
	behaviortreenetworkutility::registerbehaviortreescriptapi("recentlySawEnemy", &recentlysawenemy);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldBeAggressive", &shouldbeaggressive);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldOnlyFireAccurately", &shouldonlyfireaccurately);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldReactToNewEnemy", &shouldreacttonewenemy);
	behaviorstatemachine::registerbsmscriptapiinternal("shouldReactToNewEnemy", &shouldreacttonewenemy);
	behaviortreenetworkutility::registerbehaviortreescriptapi("hasWeaponMalfunctioned", &hasweaponmalfunctioned);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldStopMoving", &shouldstopmoving);
	behaviorstatemachine::registerbsmscriptapiinternal("shouldStopMoving", &shouldstopmoving);
	behaviortreenetworkutility::registerbehaviortreescriptapi("chooseBestCoverNodeASAP", &choosebestcovernodeasap);
	behaviortreenetworkutility::registerbehaviortreescriptapi("chooseBetterCoverService", &choosebettercoverservicecodeversion);
	behaviortreenetworkutility::registerbehaviortreescriptapi("trackCoverParamsService", &trackcoverparamsservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("refillAmmoIfNeededService", &refillammo);
	behaviortreenetworkutility::registerbehaviortreescriptapi("tryStoppingService", &trystoppingservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isFrustrated", &isfrustrated);
	behaviortreenetworkutility::registerbehaviortreescriptapi("updatefrustrationLevel", &updatefrustrationlevel);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isLastKnownEnemyPositionApproachable", &islastknownenemypositionapproachable);
	behaviortreenetworkutility::registerbehaviortreescriptapi("tryAdvancingOnLastKnownPositionBehavior", &tryadvancingonlastknownpositionbehavior);
	behaviortreenetworkutility::registerbehaviortreescriptapi("tryGoingToClosestNodeToEnemyBehavior", &trygoingtoclosestnodetoenemybehavior);
	behaviortreenetworkutility::registerbehaviortreescriptapi("tryRunningDirectlyToEnemyBehavior", &tryrunningdirectlytoenemybehavior);
	behaviortreenetworkutility::registerbehaviortreescriptapi("flagEnemyUnAttackableService", &flagenemyunattackableservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("keepClaimNode", &keepclaimnode);
	behaviorstatemachine::registerbsmscriptapiinternal("keepClaimNode", &keepclaimnode);
	behaviortreenetworkutility::registerbehaviortreescriptapi("releaseClaimNode", &releaseclaimnode);
	behaviortreenetworkutility::registerbehaviortreescriptapi("startRagdoll", &scriptstartragdoll);
	behaviortreenetworkutility::registerbehaviortreescriptapi("notStandingCondition", &notstandingcondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("notCrouchingCondition", &notcrouchingcondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("explosiveKilled", &explosivekilled);
	behaviortreenetworkutility::registerbehaviortreescriptapi("electrifiedKilled", &electrifiedkilled);
	behaviortreenetworkutility::registerbehaviortreescriptapi("burnedKilled", &burnedkilled);
	behaviortreenetworkutility::registerbehaviortreescriptapi("rapsKilled", &rapskilled);
	behaviortreenetworkutility::registerbehaviortreescriptapi("meleeAcquireMutex", &meleeacquiremutex);
	behaviortreenetworkutility::registerbehaviortreescriptapi("meleeReleaseMutex", &meleereleasemutex);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldMutexMelee", &shouldmutexmelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("prepareForExposedMelee", &prepareforexposedmelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("cleanupMelee", &cleanupmelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldNormalMelee", &shouldnormalmelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldMelee", &shouldmelee);
	behaviorstatemachine::registerbsmscriptapiinternal("shouldMelee", &shouldmelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("hasCloseEnemyMelee", &hascloseenemytomelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isBalconyDeath", &isbalconydeath);
	behaviortreenetworkutility::registerbehaviortreescriptapi("balconyDeath", &balconydeath);
	behaviortreenetworkutility::registerbehaviortreescriptapi("useCurrentPosition", &usecurrentposition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isUnarmed", &isunarmed);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldChargeMelee", &shouldchargemelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldAttackInChargeMelee", &shouldattackinchargemelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("cleanupChargeMelee", &cleanupchargemelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("cleanupChargeMeleeAttack", &cleanupchargemeleeattack);
	behaviortreenetworkutility::registerbehaviortreescriptapi("setupChargeMeleeAttack", &setupchargemeleeattack);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldChooseSpecialPain", &shouldchoosespecialpain);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldChooseSpecialPronePain", &shouldchoosespecialpronepain);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldChooseSpecialDeath", &shouldchoosespecialdeath);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldChooseSpecialProneDeath", &shouldchoosespecialpronedeath);
	behaviortreenetworkutility::registerbehaviortreescriptapi("setupExplosionAnimScale", &setupexplosionanimscale);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldStealth", &shouldstealth);
	behaviortreenetworkutility::registerbehaviortreescriptapi("stealthReactCondition", &stealthreactcondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("locomotionShouldStealth", &locomotionshouldstealth);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldStealthResume", &shouldstealthresume);
	behaviorstatemachine::registerbsmscriptapiinternal("locomotionShouldStealth", &locomotionshouldstealth);
	behaviorstatemachine::registerbsmscriptapiinternal("stealthReactCondition", &stealthreactcondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("stealthReactStart", &stealthreactstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("stealthReactTerminate", &stealthreactterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("stealthIdleTerminate", &stealthidleterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isInPhalanx", &isinphalanx);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isInPhalanxStance", &isinphalanxstance);
	behaviortreenetworkutility::registerbehaviortreescriptapi("togglePhalanxStance", &togglephalanxstance);
	behaviortreenetworkutility::registerbehaviortreescriptapi("tookFlashbangDamage", &tookflashbangdamage);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isAtAttackObject", &isatattackobject);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldAttackObject", &shouldattackobject);
	behaviortreenetworkutility::registerbehaviortreeaction("defaultAction", undefined, undefined, undefined);
	archetype_aivsaimelee::registeraivsaimeleebehaviorfunctions();
}

/*
	Name: registerutilityblackboardattributes
	Namespace: aiutility
	Checksum: 0xF7A30878
	Offset: 0x1DC8
	Size: 0x1474
	Parameters: 0
	Flags: Linked
*/
function registerutilityblackboardattributes()
{
	blackboard::registerblackboardattribute(self, "_arrival_stance", undefined, &bb_getarrivalstance);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_context", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_context2", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_cover_concealed", undefined, &bb_getcoverconcealed);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_cover_direction", "cover_front_direction", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_cover_mode", "cover_mode_none", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_cover_type", undefined, &bb_getcurrentcovernodetype);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_current_location_cover_type", undefined, &bb_getcurrentlocationcovernodetype);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_exposed_type", undefined, &bb_getcurrentexposedtype);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_damage_direction", undefined, &bb_getdamagedirection);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_damage_location", undefined, &bb_actorgetdamagelocation);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_damage_weapon_class", undefined, &bb_getdamageweaponclass);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_damage_weapon", undefined, &bb_getdamageweapon);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_damage_mod", undefined, &bb_getdamagemod);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_damage_taken", undefined, &bb_getdamagetaken);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_desired_stance", "stand", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_enemy", undefined, &bb_actorhasenemy);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_enemy_yaw", undefined, &bb_actorgetenemyyaw);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_react_yaw", undefined, &bb_actorgetreactyaw);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_fatal_damage_location", undefined, &bb_actorgetfataldamagelocation);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_fire_mode", undefined, &getfiremode);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_gib_location", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_juke_direction", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_juke_distance", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_locomotion_arrival_distance", undefined, &bb_getlocomotionarrivaldistance);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_locomotion_arrival_yaw", undefined, &bb_getlocomotionarrivalyaw);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_locomotion_exit_yaw", undefined, &bb_getlocomotionexityaw);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_locomotion_face_enemy_quadrant", "locomotion_face_enemy_none", &bb_getlocomotionfaceenemyquadrant);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_locomotion_motion_angle", undefined, &bb_getlocomotionmotionangle);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_locomotion_face_enemy_quadrant_previous", "locomotion_face_enemy_none", &bb_getlocomotionfaceenemyquadrantprevious);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_locomotion_pain_type", undefined, &bb_getlocomotionpaintype);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_locomotion_turn_yaw", undefined, &bb_getlocomotionturnyaw);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_lookahead_angle", undefined, &bb_getlookaheadangle);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_patrol", undefined, &bb_actorispatroling);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_perfect_enemy_yaw", undefined, &bb_actorgetperfectenemyyaw);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_previous_cover_direction", "cover_front_direction", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_previous_cover_mode", "cover_mode_none", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_previous_cover_type", undefined, &bb_getpreviouscovernodetype);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_stance", "stand", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_traversal_type", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_melee_distance", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_tracking_turn_yaw", undefined, &bb_actorgettrackingturnyaw);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_weapon_class", "rifle", &bb_getweaponclass);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_throw_distance", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_yaw_to_cover", undefined, &bb_getyawtocovernode);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_special_death", "none", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_awareness", "combat", &bb_getawareness);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_awareness_prev", "combat", &bb_getawarenessprevious);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_melee_enemy_type", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_staircase_num_steps", 0, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_staircase_num_total_steps", 0, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_staircase_state", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_staircase_direction", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_staircase_exit_type", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_staircase_skip_num", undefined, &bb_getstairsnumskipsteps);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	/#
		self finalizetrackedblackboardattributes();
	#/
}

/*
	Name: bb_getstairsnumskipsteps
	Namespace: aiutility
	Checksum: 0xD13A6D5A
	Offset: 0x3248
	Size: 0x172
	Parameters: 0
	Flags: Linked, Private
*/
function private bb_getstairsnumskipsteps()
{
	/#
		assert(isdefined(self._stairsstartnode) && isdefined(self._stairsendnode));
	#/
	numtotalsteps = blackboard::getblackboardattribute(self, "_staircase_num_total_steps");
	stepssofar = blackboard::getblackboardattribute(self, "_staircase_num_steps");
	direction = blackboard::getblackboardattribute(self, "_staircase_direction");
	numoutsteps = 2;
	totalstepswithoutout = numtotalsteps - numoutsteps;
	/#
		assert(stepssofar < totalstepswithoutout);
	#/
	remainingsteps = totalstepswithoutout - stepssofar;
	if(remainingsteps >= 8)
	{
		return "staircase_skip_8";
	}
	if(remainingsteps >= 6)
	{
		return "staircase_skip_6";
	}
	/#
		assert(remainingsteps >= 3);
	#/
	return "staircase_skip_3";
}

/*
	Name: bb_getawareness
	Namespace: aiutility
	Checksum: 0x78059B88
	Offset: 0x33C8
	Size: 0x32
	Parameters: 0
	Flags: Linked, Private
*/
function private bb_getawareness()
{
	if(!isdefined(self.stealth) || !isdefined(self.awarenesslevelcurrent))
	{
		return "combat";
	}
	return self.awarenesslevelcurrent;
}

/*
	Name: bb_getawarenessprevious
	Namespace: aiutility
	Checksum: 0xB7C38009
	Offset: 0x3408
	Size: 0x32
	Parameters: 0
	Flags: Linked, Private
*/
function private bb_getawarenessprevious()
{
	if(!isdefined(self.stealth) || !isdefined(self.awarenesslevelprevious))
	{
		return "combat";
	}
	return self.awarenesslevelprevious;
}

/*
	Name: bb_getyawtocovernode
	Namespace: aiutility
	Checksum: 0xA809B14A
	Offset: 0x3448
	Size: 0x104
	Parameters: 0
	Flags: Linked, Private
*/
function private bb_getyawtocovernode()
{
	if(!isdefined(self.node))
	{
		return 0;
	}
	disttonodesqr = distance2dsquared(self getnodeoffsetposition(self.node), self.origin);
	if(isdefined(self.keepclaimednode) && self.keepclaimednode)
	{
		if(disttonodesqr > (64 * 64))
		{
			return 0;
		}
	}
	else if(disttonodesqr > (24 * 24))
	{
		return 0;
	}
	angletonode = ceil(angleclamp180(self.angles[1] - self getnodeoffsetangles(self.node)[1]));
	return angletonode;
}

/*
	Name: bb_gethigheststance
	Namespace: aiutility
	Checksum: 0xE9E0E492
	Offset: 0x3558
	Size: 0x7A
	Parameters: 0
	Flags: None
*/
function bb_gethigheststance()
{
	if(self isatcovernodestrict() && self shouldusecovernode())
	{
		higheststance = gethighestnodestance(self.node);
		return higheststance;
	}
	return blackboard::getblackboardattribute(self, "_stance");
}

/*
	Name: bb_getlocomotionfaceenemyquadrantprevious
	Namespace: aiutility
	Checksum: 0xA133A32A
	Offset: 0x35E0
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function bb_getlocomotionfaceenemyquadrantprevious()
{
	if(isdefined(self.prevrelativedir))
	{
		direction = self.prevrelativedir;
		switch(direction)
		{
			case 0:
			{
				return "locomotion_face_enemy_none";
			}
			case 1:
			{
				return "locomotion_face_enemy_front";
			}
			case 2:
			{
				return "locomotion_face_enemy_right";
			}
			case 3:
			{
				return "locomotion_face_enemy_left";
			}
			case 4:
			{
				return "locomotion_face_enemy_back";
			}
		}
	}
	return "locomotion_face_enemy_none";
}

/*
	Name: bb_getcurrentcovernodetype
	Namespace: aiutility
	Checksum: 0x3873AA34
	Offset: 0x3678
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function bb_getcurrentcovernodetype()
{
	return getcovertype(self.node);
}

/*
	Name: bb_getcoverconcealed
	Namespace: aiutility
	Checksum: 0xCEF8CF82
	Offset: 0x36A0
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function bb_getcoverconcealed()
{
	if(iscoverconcealed(self.node))
	{
		return "concealed";
	}
	return "unconcealed";
}

/*
	Name: bb_getcurrentlocationcovernodetype
	Namespace: aiutility
	Checksum: 0xA330E2B
	Offset: 0x36D8
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function bb_getcurrentlocationcovernodetype()
{
	if(isdefined(self.node) && distancesquared(self.origin, self.node.origin) < (48 * 48))
	{
		return bb_getcurrentcovernodetype();
	}
	return bb_getpreviouscovernodetype();
}

/*
	Name: bb_getdamagedirection
	Namespace: aiutility
	Checksum: 0x9BFF02AA
	Offset: 0x3750
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function bb_getdamagedirection()
{
	/#
		if(isdefined(level._debug_damage_direction))
		{
			return level._debug_damage_direction;
		}
	#/
	if(self.damageyaw > 135 || self.damageyaw <= -135)
	{
		self.damage_direction = "front";
		return "front";
	}
	if(self.damageyaw > 45 && self.damageyaw <= 135)
	{
		self.damage_direction = "right";
		return "right";
	}
	if(self.damageyaw > -45 && self.damageyaw <= 45)
	{
		self.damage_direction = "back";
		return "back";
	}
	self.damage_direction = "left";
	return "left";
}

/*
	Name: bb_actorgetdamagelocation
	Namespace: aiutility
	Checksum: 0x59120EC0
	Offset: 0x3838
	Size: 0x3B0
	Parameters: 0
	Flags: Linked
*/
function bb_actorgetdamagelocation()
{
	/#
		if(isdefined(level._debug_damage_pain_location))
		{
			return level._debug_damage_pain_location;
		}
	#/
	shitloc = self.damagelocation;
	possiblehitlocations = array();
	if(isinarray(array("helmet", "head", "neck"), shitloc))
	{
		possiblehitlocations[possiblehitlocations.size] = "head";
	}
	if(isinarray(array("torso_upper", "torso_mid"), shitloc))
	{
		possiblehitlocations[possiblehitlocations.size] = "chest";
	}
	if(isinarray(array("torso_lower"), shitloc))
	{
		possiblehitlocations[possiblehitlocations.size] = "groin";
	}
	if(isinarray(array("torso_lower"), shitloc))
	{
		possiblehitlocations[possiblehitlocations.size] = "legs";
	}
	if(isinarray(array("left_arm_upper", "left_arm_lower", "left_hand"), shitloc))
	{
		possiblehitlocations[possiblehitlocations.size] = "left_arm";
	}
	if(isinarray(array("right_arm_upper", "right_arm_lower", "right_hand", "gun"), shitloc))
	{
		possiblehitlocations[possiblehitlocations.size] = "right_arm";
	}
	if(isinarray(array("right_leg_upper", "left_leg_upper", "right_leg_lower", "left_leg_lower", "right_foot", "left_foot"), shitloc))
	{
		possiblehitlocations[possiblehitlocations.size] = "legs";
	}
	if(isdefined(self.lastdamagetime) && gettime() > self.lastdamagetime && gettime() <= (self.lastdamagetime + 1000))
	{
		if(isdefined(self.lastdamagelocation))
		{
			arrayremovevalue(possiblehitlocations, self.lastdamagelocation);
		}
	}
	if(possiblehitlocations.size == 0)
	{
		possiblehitlocations = undefined;
		possiblehitlocations = [];
		possiblehitlocations[0] = "chest";
		possiblehitlocations[1] = "groin";
	}
	/#
		assert(possiblehitlocations.size > 0, possiblehitlocations.size);
	#/
	damagelocation = possiblehitlocations[randomint(possiblehitlocations.size)];
	self.lastdamagelocation = damagelocation;
	return damagelocation;
}

/*
	Name: bb_getdamageweaponclass
	Namespace: aiutility
	Checksum: 0x9B9E2AD9
	Offset: 0x3BF0
	Size: 0x186
	Parameters: 0
	Flags: Linked
*/
function bb_getdamageweaponclass()
{
	if(isdefined(self.damagemod))
	{
		if(isinarray(array("mod_rifle_bullet"), tolower(self.damagemod)))
		{
			return "rifle";
		}
		if(isinarray(array("mod_pistol_bullet"), tolower(self.damagemod)))
		{
			return "pistol";
		}
		if(isinarray(array("mod_melee", "mod_melee_assassinate", "mod_melee_weapon_butt"), tolower(self.damagemod)))
		{
			return "melee";
		}
		if(isinarray(array("mod_grenade", "mod_grenade_splash", "mod_projectile", "mod_projectile_splash", "mod_explosive"), tolower(self.damagemod)))
		{
			return "explosive";
		}
	}
	return "rifle";
}

/*
	Name: bb_getdamageweapon
	Namespace: aiutility
	Checksum: 0xAC418644
	Offset: 0x3D80
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function bb_getdamageweapon()
{
	if(isdefined(self.special_weapon) && isdefined(self.special_weapon.name))
	{
		return self.special_weapon.name;
	}
	if(isdefined(self.damageweapon) && isdefined(self.damageweapon.name))
	{
		return self.damageweapon.name;
	}
	return "unknown";
}

/*
	Name: bb_getdamagemod
	Namespace: aiutility
	Checksum: 0x651ACE7B
	Offset: 0x3DF8
	Size: 0x32
	Parameters: 0
	Flags: Linked
*/
function bb_getdamagemod()
{
	if(isdefined(self.damagemod))
	{
		return tolower(self.damagemod);
	}
	return "unknown";
}

/*
	Name: bb_getdamagetaken
	Namespace: aiutility
	Checksum: 0x639EFCA2
	Offset: 0x3E38
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function bb_getdamagetaken()
{
	/#
		if(isdefined(level._debug_damage_intensity))
		{
			return level._debug_damage_intensity;
		}
	#/
	damagetaken = self.damagetaken;
	maxhealth = self.maxhealth;
	damagetakentype = "light";
	if(isalive(self))
	{
		ratio = damagetaken / self.maxhealth;
		if(ratio > 0.7)
		{
			damagetakentype = "heavy";
		}
		self.lastdamagetime = gettime();
	}
	else
	{
		ratio = damagetaken / self.maxhealth;
		if(ratio > 0.7)
		{
			damagetakentype = "heavy";
		}
	}
	return damagetakentype;
}

/*
	Name: addaioverridedamagecallback
	Namespace: aiutility
	Checksum: 0x3C02B16F
	Offset: 0x3F30
	Size: 0x2A6
	Parameters: 3
	Flags: Linked
*/
function addaioverridedamagecallback(entity, callback, addtofront)
{
	/#
		assert(isentity(entity));
	#/
	/#
		assert(isfunctionptr(callback));
	#/
	/#
		assert(!isdefined(entity.aioverridedamage) || isarray(entity.aioverridedamage));
	#/
	if(!isdefined(entity.aioverridedamage))
	{
		entity.aioverridedamage = [];
	}
	else if(!isarray(entity.aioverridedamage))
	{
		entity.aioverridedamage = array(entity.aioverridedamage);
	}
	if(isdefined(addtofront) && addtofront)
	{
		damageoverrides = [];
		damageoverrides[damageoverrides.size] = callback;
		foreach(override in entity.aioverridedamage)
		{
			damageoverrides[damageoverrides.size] = override;
		}
		entity.aioverridedamage = damageoverrides;
	}
	else
	{
		if(!isdefined(entity.aioverridedamage))
		{
			entity.aioverridedamage = [];
		}
		else if(!isarray(entity.aioverridedamage))
		{
			entity.aioverridedamage = array(entity.aioverridedamage);
		}
		entity.aioverridedamage[entity.aioverridedamage.size] = callback;
	}
}

/*
	Name: removeaioverridedamagecallback
	Namespace: aiutility
	Checksum: 0x6242B1B
	Offset: 0x41E0
	Size: 0x178
	Parameters: 2
	Flags: None
*/
function removeaioverridedamagecallback(entity, callback)
{
	/#
		assert(isentity(entity));
	#/
	/#
		assert(isfunctionptr(callback));
	#/
	/#
		assert(isarray(entity.aioverridedamage));
	#/
	currentdamagecallbacks = entity.aioverridedamage;
	entity.aioverridedamage = [];
	foreach(value in currentdamagecallbacks)
	{
		if(value != callback)
		{
			entity.aioverridedamage[entity.aioverridedamage.size] = value;
		}
	}
}

/*
	Name: clearaioverridedamagecallbacks
	Namespace: aiutility
	Checksum: 0xEBE463BB
	Offset: 0x4360
	Size: 0x1C
	Parameters: 1
	Flags: None
*/
function clearaioverridedamagecallbacks(entity)
{
	entity.aioverridedamage = [];
}

/*
	Name: addaioverridekilledcallback
	Namespace: aiutility
	Checksum: 0x91EE66FE
	Offset: 0x4388
	Size: 0x156
	Parameters: 2
	Flags: Linked
*/
function addaioverridekilledcallback(entity, callback)
{
	/#
		assert(isentity(entity));
	#/
	/#
		assert(isfunctionptr(callback));
	#/
	/#
		assert(!isdefined(entity.aioverridekilled) || isarray(entity.aioverridekilled));
	#/
	if(!isdefined(entity.aioverridekilled))
	{
		entity.aioverridekilled = [];
	}
	else if(!isarray(entity.aioverridekilled))
	{
		entity.aioverridekilled = array(entity.aioverridekilled);
	}
	entity.aioverridekilled[entity.aioverridekilled.size] = callback;
}

/*
	Name: actorgetpredictedyawtoenemy
	Namespace: aiutility
	Checksum: 0xCFB8CFAC
	Offset: 0x44E8
	Size: 0x1A0
	Parameters: 2
	Flags: Linked
*/
function actorgetpredictedyawtoenemy(entity, lookaheadtime)
{
	if(isdefined(entity.predictedyawtoenemy) && isdefined(entity.predictedyawtoenemytime) && entity.predictedyawtoenemytime == gettime())
	{
		return entity.predictedyawtoenemy;
	}
	selfpredictedpos = entity.origin;
	moveangle = entity.angles[1] + entity getmotionangle();
	selfpredictedpos = selfpredictedpos + (((cos(moveangle), sin(moveangle), 0) * 200) * lookaheadtime);
	yaw = (vectortoangles(entity lastknownpos(entity.enemy) - selfpredictedpos)[1]) - entity.angles[1];
	yaw = absangleclamp360(yaw);
	entity.predictedyawtoenemy = yaw;
	entity.predictedyawtoenemytime = gettime();
	return yaw;
}

/*
	Name: bb_actorispatroling
	Namespace: aiutility
	Checksum: 0x6B31EE94
	Offset: 0x4690
	Size: 0x66
	Parameters: 0
	Flags: Linked
*/
function bb_actorispatroling()
{
	entity = self;
	if(entity ai::has_behavior_attribute("patrol") && entity ai::get_behavior_attribute("patrol"))
	{
		return "patrol_enabled";
	}
	return "patrol_disabled";
}

/*
	Name: bb_actorhasenemy
	Namespace: aiutility
	Checksum: 0xDD5DC8D1
	Offset: 0x4700
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function bb_actorhasenemy()
{
	entity = self;
	if(isdefined(entity.enemy))
	{
		return "has_enemy";
	}
	return "no_enemy";
}

/*
	Name: bb_actorgetenemyyaw
	Namespace: aiutility
	Checksum: 0x60F0ABE7
	Offset: 0x4740
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function bb_actorgetenemyyaw()
{
	enemy = self.enemy;
	if(!isdefined(enemy))
	{
		return 0;
	}
	toenemyyaw = actorgetpredictedyawtoenemy(self, 0.2);
	return toenemyyaw;
}

/*
	Name: bb_actorgetperfectenemyyaw
	Namespace: aiutility
	Checksum: 0x7BF7E136
	Offset: 0x47A0
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function bb_actorgetperfectenemyyaw()
{
	enemy = self.enemy;
	if(!isdefined(enemy))
	{
		return 0;
	}
	toenemyyaw = (vectortoangles(enemy.origin - self.origin)[1]) - self.angles[1];
	toenemyyaw = absangleclamp360(toenemyyaw);
	/#
		recordenttext("" + toenemyyaw, self, (1, 0, 0), "");
	#/
	return toenemyyaw;
}

/*
	Name: bb_actorgetreactyaw
	Namespace: aiutility
	Checksum: 0x5D1480D
	Offset: 0x4868
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function bb_actorgetreactyaw()
{
	result = 0;
	if(isdefined(self.react_yaw))
	{
		result = self.react_yaw;
		self.react_yaw = undefined;
	}
	else
	{
		v_origin = self geteventpointofinterest();
		if(isdefined(v_origin))
		{
			str_typename = self getcurrenteventtypename();
			e_originator = self getcurrenteventoriginator();
			if(str_typename == "bullet" && isdefined(e_originator))
			{
				v_origin = e_originator.origin;
			}
			deltaorigin = v_origin - self.origin;
			deltaangles = vectortoangles(deltaorigin);
			result = absangleclamp360(self.angles[1] - deltaangles[1]);
		}
	}
	return result;
}

/*
	Name: bb_actorgetfataldamagelocation
	Namespace: aiutility
	Checksum: 0x2D79FA1B
	Offset: 0x49B0
	Size: 0x248
	Parameters: 0
	Flags: Linked
*/
function bb_actorgetfataldamagelocation()
{
	/#
		if(isdefined(level._debug_damage_location))
		{
			return level._debug_damage_location;
		}
	#/
	shitloc = self.damagelocation;
	if(isdefined(shitloc))
	{
		if(isinarray(array("helmet", "head", "neck"), shitloc))
		{
			return "head";
		}
		if(isinarray(array("torso_upper", "torso_mid"), shitloc))
		{
			return "chest";
		}
		if(isinarray(array("torso_lower"), shitloc))
		{
			return "hips";
		}
		if(isinarray(array("right_arm_upper", "right_arm_lower", "right_hand", "gun"), shitloc))
		{
			return "right_arm";
		}
		if(isinarray(array("left_arm_upper", "left_arm_lower", "left_hand"), shitloc))
		{
			return "left_arm";
		}
		if(isinarray(array("right_leg_upper", "left_leg_upper", "right_leg_lower", "left_leg_lower", "right_foot", "left_foot"), shitloc))
		{
			return "legs";
		}
	}
	randomlocs = array("chest", "hips");
	return randomlocs[randomint(randomlocs.size)];
}

/*
	Name: getangleusingdirection
	Namespace: aiutility
	Checksum: 0xF3FC01FD
	Offset: 0x4C00
	Size: 0xCA
	Parameters: 1
	Flags: Linked
*/
function getangleusingdirection(direction)
{
	directionyaw = vectortoangles(direction)[1];
	yawdiff = directionyaw - self.angles[1];
	yawdiff = yawdiff * 0.002777778;
	flooredyawdiff = floor(yawdiff + 0.5);
	turnangle = (yawdiff - flooredyawdiff) * 360;
	return absangleclamp360(turnangle);
}

/*
	Name: wasatcovernode
	Namespace: aiutility
	Checksum: 0xEF2633E8
	Offset: 0x4CD8
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function wasatcovernode()
{
	if(isdefined(self.prevnode))
	{
		if(self.prevnode.type == "Cover Left" || self.prevnode.type == "Cover Right" || self.prevnode.type == "Cover Pillar" || (self.prevnode.type == "Cover Stand" || self.prevnode.type == "Conceal Stand") || (self.prevnode.type == "Cover Crouch" || self.prevnode.type == "Cover Crouch Window" || self.prevnode.type == "Conceal Crouch"))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: bb_getlocomotionexityaw
	Namespace: aiutility
	Checksum: 0x76AF89D3
	Offset: 0x4DD8
	Size: 0x4D8
	Parameters: 2
	Flags: Linked
*/
function bb_getlocomotionexityaw(blackboard, yaw)
{
	exityaw = undefined;
	if(self haspath())
	{
		predictedlookaheadinfo = self predictexit();
		status = predictedlookaheadinfo["path_prediction_status"];
		if(!isdefined(self.pathgoalpos))
		{
			return -1;
		}
		if(distancesquared(self.origin, self.pathgoalpos) <= 4096)
		{
			return -1;
		}
		if(status == 3)
		{
			start = self.origin;
			end = start + vectorscale((0, predictedlookaheadinfo["path_prediction_travel_vector"][1], 0), 100);
			angletoexit = vectortoangles(predictedlookaheadinfo["path_prediction_travel_vector"])[1];
			exityaw = absangleclamp360(angletoexit - self.prevnode.angles[1]);
		}
		else
		{
			if(status == 4)
			{
				start = self.origin;
				end = start + vectorscale((0, predictedlookaheadinfo["path_prediction_travel_vector"][1], 0), 100);
				angletoexit = vectortoangles(predictedlookaheadinfo["path_prediction_travel_vector"])[1];
				exityaw = absangleclamp360(angletoexit - self.angles[1]);
			}
			else
			{
				if(status == 0)
				{
					if(wasatcovernode() && distancesquared(self.prevnode.origin, self.origin) < 25)
					{
						end = self.pathgoalpos;
						angletodestination = vectortoangles(end - self.origin)[1];
						angledifference = absangleclamp360(angletodestination - self.prevnode.angles[1]);
						return angledifference;
					}
					start = predictedlookaheadinfo["path_prediction_start_point"];
					end = start + predictedlookaheadinfo["path_prediction_travel_vector"];
					exityaw = getangleusingdirection(predictedlookaheadinfo["path_prediction_travel_vector"]);
				}
				else if(status == 2)
				{
					if(distancesquared(self.origin, self.pathgoalpos) <= 4096)
					{
						return undefined;
					}
					if(wasatcovernode() && distancesquared(self.prevnode.origin, self.origin) < 25)
					{
						end = self.pathgoalpos;
						angletodestination = vectortoangles(end - self.origin)[1];
						angledifference = absangleclamp360(angletodestination - self.prevnode.angles[1]);
						return angledifference;
					}
					start = self.origin;
					end = self.pathgoalpos;
					exityaw = getangleusingdirection(vectornormalize(end - start));
				}
			}
		}
	}
	/#
		if(isdefined(exityaw))
		{
			record3dtext("" + int(exityaw), self.origin - vectorscale((0, 0, 1), 5), (1, 0, 0), "", undefined, 0.4);
		}
	#/
	return exityaw;
}

/*
	Name: bb_getlocomotionfaceenemyquadrant
	Namespace: aiutility
	Checksum: 0x2AD31C48
	Offset: 0x52B8
	Size: 0xFE
	Parameters: 0
	Flags: Linked
*/
function bb_getlocomotionfaceenemyquadrant()
{
	/#
		walkstring = getdvarstring("");
		switch(walkstring)
		{
			case "":
			{
				return "";
			}
			case "":
			{
				return "";
			}
			case "":
			{
				return "";
			}
		}
	#/
	if(isdefined(self.relativedir))
	{
		direction = self.relativedir;
		switch(direction)
		{
			case 0:
			{
				return "locomotion_face_enemy_front";
			}
			case 1:
			{
				return "locomotion_face_enemy_front";
			}
			case 2:
			{
				return "locomotion_face_enemy_right";
			}
			case 3:
			{
				return "locomotion_face_enemy_left";
			}
			case 4:
			{
				return "locomotion_face_enemy_back";
			}
		}
	}
	return "locomotion_face_enemy_front";
}

/*
	Name: bb_getlocomotionpaintype
	Namespace: aiutility
	Checksum: 0xAD389B7D
	Offset: 0x53C0
	Size: 0x292
	Parameters: 0
	Flags: Linked
*/
function bb_getlocomotionpaintype()
{
	if(self haspath())
	{
		predictedlookaheadinfo = self predictpath();
		status = predictedlookaheadinfo["path_prediction_status"];
		startpos = self.origin;
		furthestpointtowardsgoalclear = 1;
		if(status == 2)
		{
			furthestpointalongtowardsgoal = startpos + vectorscale(self.lookaheaddir, 300);
			furthestpointtowardsgoalclear = self findpath(startpos, furthestpointalongtowardsgoal, 0, 0) && self maymovetopoint(furthestpointalongtowardsgoal);
		}
		if(furthestpointtowardsgoalclear)
		{
			forwarddir = anglestoforward(self.angles);
			possiblepaintypes = [];
			endpos = startpos + vectorscale(forwarddir, 300);
			if(self maymovetopoint(endpos) && self findpath(startpos, endpos, 0, 0))
			{
				possiblepaintypes[possiblepaintypes.size] = "locomotion_moving_pain_long";
			}
			endpos = startpos + vectorscale(forwarddir, 200);
			if(self maymovetopoint(endpos) && self findpath(startpos, endpos, 0, 0))
			{
				possiblepaintypes[possiblepaintypes.size] = "locomotion_moving_pain_med";
			}
			endpos = startpos + vectorscale(forwarddir, 150);
			if(self maymovetopoint(endpos) && self findpath(startpos, endpos, 0, 0))
			{
				possiblepaintypes[possiblepaintypes.size] = "locomotion_moving_pain_short";
			}
			if(possiblepaintypes.size)
			{
				return array::random(possiblepaintypes);
			}
		}
	}
	return "locomotion_inplace_pain";
}

/*
	Name: bb_getlookaheadangle
	Namespace: aiutility
	Checksum: 0x6A3DEA29
	Offset: 0x5660
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function bb_getlookaheadangle()
{
	return absangleclamp360(vectortoangles(self.lookaheaddir)[1] - self.angles[1]);
}

/*
	Name: bb_getpreviouscovernodetype
	Namespace: aiutility
	Checksum: 0x82698B53
	Offset: 0x56B0
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function bb_getpreviouscovernodetype()
{
	return getcovertype(self.prevnode);
}

/*
	Name: bb_actorgettrackingturnyaw
	Namespace: aiutility
	Checksum: 0x8407ABE8
	Offset: 0x56D8
	Size: 0x186
	Parameters: 0
	Flags: Linked
*/
function bb_actorgettrackingturnyaw()
{
	pixbeginevent("BB_ActorGetTrackingTurnYaw");
	if(isdefined(self.enemy))
	{
		predictedpos = undefined;
		if(distance2dsquared(self.enemy.origin, self.origin) < (180 * 180))
		{
			predictedpos = self.enemy.origin;
			self.newenemyreaction = 0;
		}
		else if(!issentient(self.enemy) || (self lastknowntime(self.enemy) + 5000) >= gettime())
		{
			predictedpos = self lastknownpos(self.enemy);
		}
		if(isdefined(predictedpos))
		{
			turnyaw = absangleclamp360(self.angles[1] - (vectortoangles(predictedpos - self.origin)[1]));
			pixendevent();
			return turnyaw;
		}
	}
	pixendevent();
	return undefined;
}

/*
	Name: bb_getweaponclass
	Namespace: aiutility
	Checksum: 0x64665720
	Offset: 0x5868
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function bb_getweaponclass()
{
	return "rifle";
}

/*
	Name: notstandingcondition
	Namespace: aiutility
	Checksum: 0xAEA3E2B8
	Offset: 0x5880
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function notstandingcondition(behaviortreeentity)
{
	if(blackboard::getblackboardattribute(behaviortreeentity, "_stance") != "stand")
	{
		return true;
	}
	return false;
}

/*
	Name: notcrouchingcondition
	Namespace: aiutility
	Checksum: 0x4A7E164
	Offset: 0x58C8
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function notcrouchingcondition(behaviortreeentity)
{
	if(blackboard::getblackboardattribute(behaviortreeentity, "_stance") != "crouch")
	{
		return true;
	}
	return false;
}

/*
	Name: scriptstartragdoll
	Namespace: aiutility
	Checksum: 0xC476784
	Offset: 0x5910
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function scriptstartragdoll(behaviortreeentity)
{
	behaviortreeentity startragdoll();
}

/*
	Name: prepareforexposedmelee
	Namespace: aiutility
	Checksum: 0x74F6C3F2
	Offset: 0x5940
	Size: 0x124
	Parameters: 1
	Flags: Linked, Private
*/
function private prepareforexposedmelee(behaviortreeentity)
{
	keepclaimnode(behaviortreeentity);
	meleeacquiremutex(behaviortreeentity);
	currentstance = blackboard::getblackboardattribute(behaviortreeentity, "_stance");
	if(isdefined(behaviortreeentity.enemy) && isdefined(behaviortreeentity.enemy.vehicletype) && issubstr(behaviortreeentity.enemy.vehicletype, "firefly"))
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_melee_enemy_type", "fireflyswarm");
	}
	if(currentstance == "crouch")
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_desired_stance", "stand");
	}
}

/*
	Name: isfrustrated
	Namespace: aiutility
	Checksum: 0x34E788
	Offset: 0x5A70
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function isfrustrated(behaviortreeentity)
{
	return isdefined(behaviortreeentity.frustrationlevel) && behaviortreeentity.frustrationlevel > 0;
}

/*
	Name: clampfrustration
	Namespace: aiutility
	Checksum: 0xC5EEEE0B
	Offset: 0x5AB0
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function clampfrustration(frustrationlevel)
{
	if(frustrationlevel > 4)
	{
		return 4;
	}
	if(frustrationlevel < 0)
	{
		return 0;
	}
	return frustrationlevel;
}

/*
	Name: updatefrustrationlevel
	Namespace: aiutility
	Checksum: 0x12C279A4
	Offset: 0x5AF0
	Size: 0x3C8
	Parameters: 1
	Flags: Linked
*/
function updatefrustrationlevel(entity)
{
	if(!entity isbadguy())
	{
		return false;
	}
	if(!isdefined(entity.frustrationlevel))
	{
		entity.frustrationlevel = 0;
	}
	if(!isdefined(entity.enemy))
	{
		entity.frustrationlevel = 0;
		return false;
	}
	/#
		record3dtext("" + entity.frustrationlevel, entity.origin, (1, 0.5, 0), "");
	#/
	if(isactor(entity.enemy) || isplayer(entity.enemy))
	{
		if(entity.aggressivemode)
		{
			if(!isdefined(entity.lastfrustrationboost))
			{
				entity.lastfrustrationboost = gettime();
			}
			if((entity.lastfrustrationboost + 5000) < gettime())
			{
				entity.frustrationlevel++;
				entity.lastfrustrationboost = gettime();
				entity.frustrationlevel = clampfrustration(entity.frustrationlevel);
			}
		}
		isawareofenemy = (gettime() - entity lastknowntime(entity.enemy)) < 10000;
		if(entity.frustrationlevel == 4)
		{
			hasseenenemy = entity seerecently(entity.enemy, 2);
		}
		else
		{
			hasseenenemy = entity seerecently(entity.enemy, 5);
		}
		hasattackedenemyrecently = entity attackedrecently(entity.enemy, 5);
		if(!isawareofenemy || isactor(entity.enemy))
		{
			if(!hasseenenemy)
			{
				entity.frustrationlevel++;
			}
			else if(!hasattackedenemyrecently)
			{
				entity.frustrationlevel = entity.frustrationlevel + 2;
			}
			entity.frustrationlevel = clampfrustration(entity.frustrationlevel);
			return true;
		}
		if(hasattackedenemyrecently)
		{
			entity.frustrationlevel = entity.frustrationlevel - 2;
			entity.frustrationlevel = clampfrustration(entity.frustrationlevel);
			return true;
		}
		if(hasseenenemy)
		{
			entity.frustrationlevel--;
			entity.frustrationlevel = clampfrustration(entity.frustrationlevel);
			return true;
		}
	}
	return false;
}

/*
	Name: flagenemyunattackableservice
	Namespace: aiutility
	Checksum: 0x4763758C
	Offset: 0x5EC0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function flagenemyunattackableservice(behaviortreeentity)
{
	behaviortreeentity flagenemyunattackable();
}

/*
	Name: islastknownenemypositionapproachable
	Namespace: aiutility
	Checksum: 0x173546C
	Offset: 0x5EF0
	Size: 0xA6
	Parameters: 1
	Flags: Linked
*/
function islastknownenemypositionapproachable(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemy))
	{
		lastknownpositionofenemy = behaviortreeentity lastknownpos(behaviortreeentity.enemy);
		if(behaviortreeentity isingoal(lastknownpositionofenemy) && behaviortreeentity findpath(behaviortreeentity.origin, lastknownpositionofenemy, 1, 0))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: tryadvancingonlastknownpositionbehavior
	Namespace: aiutility
	Checksum: 0x7CA6E48F
	Offset: 0x5FA0
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function tryadvancingonlastknownpositionbehavior(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemy))
	{
		if(isdefined(behaviortreeentity.aggressivemode) && behaviortreeentity.aggressivemode)
		{
			lastknownpositionofenemy = behaviortreeentity lastknownpos(behaviortreeentity.enemy);
			if(behaviortreeentity isingoal(lastknownpositionofenemy) && behaviortreeentity findpath(behaviortreeentity.origin, lastknownpositionofenemy, 1, 0))
			{
				behaviortreeentity useposition(lastknownpositionofenemy, lastknownpositionofenemy);
				setnextfindbestcovertime(behaviortreeentity, undefined);
				return true;
			}
		}
	}
	return false;
}

/*
	Name: trygoingtoclosestnodetoenemybehavior
	Namespace: aiutility
	Checksum: 0x85BC35A6
	Offset: 0x60B0
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function trygoingtoclosestnodetoenemybehavior(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemy))
	{
		closestrandomnode = behaviortreeentity findbestcovernodes(behaviortreeentity.engagemaxdist, behaviortreeentity.enemy.origin)[0];
		if(isdefined(closestrandomnode) && behaviortreeentity isingoal(closestrandomnode.origin) && behaviortreeentity findpath(behaviortreeentity.origin, closestrandomnode.origin, 1, 0))
		{
			usecovernodewrapper(behaviortreeentity, closestrandomnode);
			return true;
		}
	}
	return false;
}

/*
	Name: tryrunningdirectlytoenemybehavior
	Namespace: aiutility
	Checksum: 0xA78B0691
	Offset: 0x61B0
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function tryrunningdirectlytoenemybehavior(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemy) && (isdefined(behaviortreeentity.aggressivemode) && behaviortreeentity.aggressivemode))
	{
		origin = behaviortreeentity.enemy.origin;
		if(behaviortreeentity isingoal(origin) && behaviortreeentity findpath(behaviortreeentity.origin, origin, 1, 0))
		{
			behaviortreeentity useposition(origin, origin);
			setnextfindbestcovertime(behaviortreeentity, undefined);
			return true;
		}
	}
	return false;
}

/*
	Name: shouldreacttonewenemy
	Namespace: aiutility
	Checksum: 0x9691D3C2
	Offset: 0x62B0
	Size: 0x16
	Parameters: 1
	Flags: Linked
*/
function shouldreacttonewenemy(behaviortreeentity)
{
	return false;
}

/*
	Name: hasweaponmalfunctioned
	Namespace: aiutility
	Checksum: 0xD77D1244
	Offset: 0x6360
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function hasweaponmalfunctioned(behaviortreeentity)
{
	return isdefined(behaviortreeentity.malfunctionreaction) && behaviortreeentity.malfunctionreaction;
}

/*
	Name: issafefromgrenades
	Namespace: aiutility
	Checksum: 0xFA60EBB0
	Offset: 0x6398
	Size: 0x1A4
	Parameters: 1
	Flags: Linked
*/
function issafefromgrenades(entity)
{
	if(isdefined(entity.grenade) && isdefined(entity.grenade.weapon) && entity.grenade !== entity.knowngrenade && !entity issafefromgrenade())
	{
		if(isdefined(entity.node))
		{
			offsetorigin = entity getnodeoffsetposition(entity.node);
			percentradius = distance(entity.grenade.origin, offsetorigin);
			if(entity.grenadeawareness >= percentradius)
			{
				return true;
			}
		}
		else
		{
			percentradius = distance(entity.grenade.origin, entity.origin) / entity.grenade.weapon.explosionradius;
			if(entity.grenadeawareness >= percentradius)
			{
				return true;
			}
		}
		entity.knowngrenade = entity.grenade;
		return false;
	}
	return true;
}

/*
	Name: ingrenadeblastradius
	Namespace: aiutility
	Checksum: 0x80CD33D0
	Offset: 0x6548
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function ingrenadeblastradius(entity)
{
	return !entity issafefromgrenade();
}

/*
	Name: recentlysawenemy
	Namespace: aiutility
	Checksum: 0x57588595
	Offset: 0x6578
	Size: 0x56
	Parameters: 1
	Flags: Linked
*/
function recentlysawenemy(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemy) && behaviortreeentity seerecently(behaviortreeentity.enemy, 6))
	{
		return true;
	}
	return false;
}

/*
	Name: shouldonlyfireaccurately
	Namespace: aiutility
	Checksum: 0x212C6E87
	Offset: 0x65D8
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function shouldonlyfireaccurately(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.accuratefire) && behaviortreeentity.accuratefire)
	{
		return true;
	}
	return false;
}

/*
	Name: shouldbeaggressive
	Namespace: aiutility
	Checksum: 0xDCF501BB
	Offset: 0x6620
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function shouldbeaggressive(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.aggressivemode) && behaviortreeentity.aggressivemode)
	{
		return true;
	}
	return false;
}

/*
	Name: usecovernodewrapper
	Namespace: aiutility
	Checksum: 0x4F334D66
	Offset: 0x6668
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function usecovernodewrapper(behaviortreeentity, node)
{
	samenode = behaviortreeentity.node === node;
	behaviortreeentity usecovernode(node);
	if(!samenode)
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_cover_mode", "cover_mode_none");
		blackboard::setblackboardattribute(behaviortreeentity, "_previous_cover_mode", "cover_mode_none");
	}
	setnextfindbestcovertime(behaviortreeentity, node);
}

/*
	Name: setnextfindbestcovertime
	Namespace: aiutility
	Checksum: 0xEE85B986
	Offset: 0x6738
	Size: 0x58
	Parameters: 2
	Flags: Linked
*/
function setnextfindbestcovertime(behaviortreeentity, node)
{
	behaviortreeentity.nextfindbestcovertime = behaviortreeentity getnextfindbestcovertime(behaviortreeentity.engagemindist, behaviortreeentity.engagemaxdist, behaviortreeentity.coversearchinterval);
}

/*
	Name: trackcoverparamsservice
	Namespace: aiutility
	Checksum: 0xDABE682A
	Offset: 0x6798
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function trackcoverparamsservice(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.node) && behaviortreeentity isatcovernodestrict() && behaviortreeentity shouldusecovernode())
	{
		if(!isdefined(behaviortreeentity.covernode))
		{
			behaviortreeentity.covernode = behaviortreeentity.node;
			setnextfindbestcovertime(behaviortreeentity, behaviortreeentity.node);
		}
		return;
	}
	behaviortreeentity.covernode = undefined;
}

/*
	Name: choosebestcovernodeasap
	Namespace: aiutility
	Checksum: 0xD207E5BB
	Offset: 0x6850
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function choosebestcovernodeasap(behaviortreeentity)
{
	if(!isdefined(behaviortreeentity.enemy))
	{
		return false;
	}
	node = getbestcovernodeifavailable(behaviortreeentity);
	if(isdefined(node))
	{
		usecovernodewrapper(behaviortreeentity, node);
	}
}

/*
	Name: shouldchoosebettercover
	Namespace: aiutility
	Checksum: 0x84E4A07F
	Offset: 0x68C8
	Size: 0x45A
	Parameters: 1
	Flags: Linked
*/
function shouldchoosebettercover(behaviortreeentity)
{
	if(behaviortreeentity ai::has_behavior_attribute("stealth") && behaviortreeentity ai::get_behavior_attribute("stealth"))
	{
		return 0;
	}
	if(isdefined(behaviortreeentity.avoid_cover) && behaviortreeentity.avoid_cover)
	{
		return 0;
	}
	if(behaviortreeentity isinanybadplace())
	{
		return 1;
	}
	if(isdefined(behaviortreeentity.enemy))
	{
		shouldusecovernoderesult = 0;
		shouldbeboredatcurrentcover = 0;
		abouttoarriveatcover = 0;
		iswithineffectiverangealready = 0;
		islookingaroundforenemy = 0;
		if(behaviortreeentity shouldholdgroundagainstenemy())
		{
			return 0;
		}
		if(behaviortreeentity haspath() && isdefined(behaviortreeentity.arrivalfinalpos) && isdefined(behaviortreeentity.pathgoalpos) && self.pathgoalpos == behaviortreeentity.arrivalfinalpos)
		{
			if(distancesquared(behaviortreeentity.origin, behaviortreeentity.arrivalfinalpos) < 4096)
			{
				abouttoarriveatcover = 1;
			}
		}
		shouldusecovernoderesult = behaviortreeentity shouldusecovernode();
		if(self isatgoal())
		{
			if(shouldusecovernoderesult && isdefined(behaviortreeentity.node) && self isatgoal())
			{
				lastknownpos = behaviortreeentity lastknownpos(behaviortreeentity.enemy);
				dist = distance2d(behaviortreeentity.origin, lastknownpos);
				if(dist > behaviortreeentity.engageminfalloffdist && dist <= behaviortreeentity.engagemaxfalloffdist)
				{
					iswithineffectiverangealready = 1;
				}
			}
			shouldbeboredatcurrentcover = !iswithineffectiverangealready && behaviortreeentity isatcovernode() && gettime() > self.nextfindbestcovertime;
			if(!shouldusecovernoderesult)
			{
				if(isdefined(behaviortreeentity.frustrationlevel) && behaviortreeentity.frustrationlevel > 0 && behaviortreeentity haspath())
				{
					islookingaroundforenemy = 1;
				}
			}
		}
		shouldlookforbettercover = !islookingaroundforenemy && !abouttoarriveatcover && !iswithineffectiverangealready && (!shouldusecovernoderesult || shouldbeboredatcurrentcover || !self isatgoal());
		/#
			if(shouldlookforbettercover)
			{
				color = (0, 1, 0);
			}
			else
			{
				color = (1, 0, 0);
			}
			recordenttext((((((((("" + shouldusecovernoderesult) + "") + islookingaroundforenemy) + "") + abouttoarriveatcover) + "") + iswithineffectiverangealready) + "") + shouldbeboredatcurrentcover, behaviortreeentity, color, "");
		#/
	}
	else
	{
		return !(behaviortreeentity shouldusecovernode() && behaviortreeentity isapproachinggoal());
	}
	return shouldlookforbettercover;
}

/*
	Name: choosebettercoverservicecodeversion
	Namespace: aiutility
	Checksum: 0x962EBA02
	Offset: 0x6D30
	Size: 0x10E
	Parameters: 1
	Flags: Linked
*/
function choosebettercoverservicecodeversion(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.stealth) && behaviortreeentity ai::get_behavior_attribute("stealth"))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.avoid_cover) && behaviortreeentity.avoid_cover)
	{
		return false;
	}
	if(isdefined(behaviortreeentity.knowngrenade))
	{
		return false;
	}
	if(!issafefromgrenades(behaviortreeentity))
	{
		behaviortreeentity.nextfindbestcovertime = 0;
	}
	newnode = behaviortreeentity choosebettercovernode();
	if(isdefined(newnode))
	{
		usecovernodewrapper(behaviortreeentity, newnode);
		return true;
	}
	setnextfindbestcovertime(behaviortreeentity, undefined);
	return false;
}

/*
	Name: choosebettercoverservice
	Namespace: aiutility
	Checksum: 0xDF22936E
	Offset: 0x6E48
	Size: 0x1A6
	Parameters: 1
	Flags: Private
*/
function private choosebettercoverservice(behaviortreeentity)
{
	shouldchoosebettercoverresult = shouldchoosebettercover(behaviortreeentity);
	if(shouldchoosebettercoverresult && !behaviortreeentity.keepclaimednode)
	{
		transitionrunning = behaviortreeentity asmistransitionrunning();
		substatepending = behaviortreeentity asmissubstatepending();
		transdecrunning = behaviortreeentity asmistransdecrunning();
		isbehaviortreeinrunningstate = behaviortreeentity getbehaviortreestatus() == 5;
		if(!transitionrunning && !substatepending && !transdecrunning && isbehaviortreeinrunningstate)
		{
			node = getbestcovernodeifavailable(behaviortreeentity);
			goingtodifferentnode = isdefined(node) && (!isdefined(behaviortreeentity.node) || node != behaviortreeentity.node);
			if(goingtodifferentnode)
			{
				usecovernodewrapper(behaviortreeentity, node);
				return true;
			}
			setnextfindbestcovertime(behaviortreeentity, undefined);
		}
	}
	return false;
}

/*
	Name: refillammo
	Namespace: aiutility
	Checksum: 0xF244AB0E
	Offset: 0x6FF8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function refillammo(behaviortreeentity)
{
	if(behaviortreeentity.weapon != level.weaponnone)
	{
		behaviortreeentity.bulletsinclip = behaviortreeentity.weapon.clipsize;
	}
}

/*
	Name: hasammo
	Namespace: aiutility
	Checksum: 0xD093CAC0
	Offset: 0x7050
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function hasammo(behaviortreeentity)
{
	if(behaviortreeentity.bulletsinclip > 0)
	{
		return true;
	}
	return false;
}

/*
	Name: haslowammo
	Namespace: aiutility
	Checksum: 0xB9BC8DDD
	Offset: 0x7088
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function haslowammo(behaviortreeentity)
{
	if(behaviortreeentity.weapon != level.weaponnone)
	{
		return behaviortreeentity.bulletsinclip < (behaviortreeentity.weapon.clipsize * 0.2);
	}
	return 0;
}

/*
	Name: hasenemy
	Namespace: aiutility
	Checksum: 0x174D6034
	Offset: 0x70F0
	Size: 0x28
	Parameters: 1
	Flags: Linked
*/
function hasenemy(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemy))
	{
		return true;
	}
	return false;
}

/*
	Name: getbestcovernodeifavailable
	Namespace: aiutility
	Checksum: 0x979847B9
	Offset: 0x7120
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function getbestcovernodeifavailable(behaviortreeentity)
{
	node = behaviortreeentity findbestcovernode();
	if(!isdefined(node))
	{
		return undefined;
	}
	if(behaviortreeentity nearclaimnode())
	{
		currentnode = self.node;
	}
	if(isdefined(currentnode) && node == currentnode)
	{
		return undefined;
	}
	if(isdefined(behaviortreeentity.covernode) && node == behaviortreeentity.covernode)
	{
		return undefined;
	}
	return node;
}

/*
	Name: getsecondbestcovernodeifavailable
	Namespace: aiutility
	Checksum: 0x7C5C7EEF
	Offset: 0x71E8
	Size: 0x124
	Parameters: 1
	Flags: None
*/
function getsecondbestcovernodeifavailable(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.fixednode) && behaviortreeentity.fixednode)
	{
		return undefined;
	}
	nodes = behaviortreeentity findbestcovernodes(behaviortreeentity.goalradius, behaviortreeentity.origin);
	if(nodes.size > 1)
	{
		node = nodes[1];
	}
	if(!isdefined(node))
	{
		return undefined;
	}
	if(behaviortreeentity nearclaimnode())
	{
		currentnode = self.node;
	}
	if(isdefined(currentnode) && node == currentnode)
	{
		return undefined;
	}
	if(isdefined(behaviortreeentity.covernode) && node == behaviortreeentity.covernode)
	{
		return undefined;
	}
	return node;
}

/*
	Name: getcovertype
	Namespace: aiutility
	Checksum: 0xBD32B4C8
	Offset: 0x7318
	Size: 0x176
	Parameters: 1
	Flags: Linked
*/
function getcovertype(node)
{
	if(isdefined(node))
	{
		if(node.type == "Cover Pillar")
		{
			return "cover_pillar";
		}
		if(node.type == "Cover Left")
		{
			return "cover_left";
		}
		if(node.type == "Cover Right")
		{
			return "cover_right";
		}
		if(node.type == "Cover Stand" || node.type == "Conceal Stand")
		{
			return "cover_stand";
		}
		if(node.type == "Cover Crouch" || node.type == "Cover Crouch Window" || node.type == "Conceal Crouch")
		{
			return "cover_crouch";
		}
		if(node.type == "Exposed" || node.type == "Guard")
		{
			return "cover_exposed";
		}
	}
	return "cover_none";
}

/*
	Name: iscoverconcealed
	Namespace: aiutility
	Checksum: 0x9515EE2F
	Offset: 0x7498
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function iscoverconcealed(node)
{
	if(isdefined(node))
	{
		return node.type == "Conceal Crouch" || node.type == "Conceal Stand";
	}
	return 0;
}

/*
	Name: canseeenemywrapper
	Namespace: aiutility
	Checksum: 0x3DAE964
	Offset: 0x74F0
	Size: 0x4BA
	Parameters: 0
	Flags: None
*/
function canseeenemywrapper()
{
	if(!isdefined(self.enemy))
	{
		return 0;
	}
	if(!isdefined(self.node))
	{
		return self cansee(self.enemy);
	}
	node = self.node;
	enemyeye = self.enemy geteye();
	yawtoenemy = angleclamp180(node.angles[1] - (vectortoangles(enemyeye - node.origin)[1]));
	if(node.type == "Cover Left" || node.type == "Cover Right")
	{
		if(yawtoenemy > 60 || yawtoenemy < -60)
		{
			return 0;
		}
		if(isdefined(node.spawnflags) && (node.spawnflags & 4) == 4)
		{
			if(node.type == "Cover Left" && yawtoenemy > 10)
			{
				return 0;
			}
			if(node.type == "Cover Right" && yawtoenemy < -10)
			{
				return 0;
			}
		}
	}
	nodeoffset = (0, 0, 0);
	if(node.type == "Cover Pillar")
	{
		/#
			assert(!(isdefined(node.spawnflags) && (node.spawnflags & 2048) == 2048) || (!(isdefined(node.spawnflags) && (node.spawnflags & 1024) == 1024)));
		#/
		canseefromleft = 1;
		canseefromright = 1;
		nodeoffset = (-32, 3.7, 60);
		lookfrompoint = calculatenodeoffsetposition(node, nodeoffset);
		canseefromleft = sighttracepassed(lookfrompoint, enemyeye, 0, undefined);
		nodeoffset = (32, 3.7, 60);
		lookfrompoint = calculatenodeoffsetposition(node, nodeoffset);
		canseefromright = sighttracepassed(lookfrompoint, enemyeye, 0, undefined);
		return canseefromright || canseefromleft;
	}
	if(node.type == "Cover Left")
	{
		nodeoffset = (-36, 7, 63);
	}
	else
	{
		if(node.type == "Cover Right")
		{
			nodeoffset = (36, 7, 63);
		}
		else
		{
			if(node.type == "Cover Stand" || node.type == "Conceal Stand")
			{
				nodeoffset = (-3.7, -22, 63);
			}
			else if(node.type == "Cover Crouch" || node.type == "Cover Crouch Window" || node.type == "Conceal Crouch")
			{
				nodeoffset = (3.5, -12.5, 45);
			}
		}
	}
	lookfrompoint = calculatenodeoffsetposition(node, nodeoffset);
	if(sighttracepassed(lookfrompoint, enemyeye, 0, undefined))
	{
		return 1;
	}
	return 0;
}

/*
	Name: calculatenodeoffsetposition
	Namespace: aiutility
	Checksum: 0x4617AB94
	Offset: 0x79B8
	Size: 0xAA
	Parameters: 2
	Flags: Linked
*/
function calculatenodeoffsetposition(node, nodeoffset)
{
	right = anglestoright(node.angles);
	forward = anglestoforward(node.angles);
	return (node.origin + vectorscale(right, nodeoffset[0])) + vectorscale(forward, nodeoffset[1]) + (0, 0, nodeoffset[2]);
}

/*
	Name: gethighestnodestance
	Namespace: aiutility
	Checksum: 0xF815C3D0
	Offset: 0x7A70
	Size: 0x186
	Parameters: 1
	Flags: Linked
*/
function gethighestnodestance(node)
{
	/#
		assert(isdefined(node));
	#/
	if(isdefined(node.spawnflags) && (node.spawnflags & 4) == 4)
	{
		return "stand";
	}
	if(isdefined(node.spawnflags) && (node.spawnflags & 8) == 8)
	{
		return "crouch";
	}
	if(isdefined(node.spawnflags) && (node.spawnflags & 16) == 16)
	{
		return "prone";
	}
	/#
		errormsg(((node.type + "") + node.origin) + "");
	#/
	if(node.type == "Cover Crouch" || node.type == "Cover Crouch Window" || node.type == "Conceal Crouch")
	{
		return "crouch";
	}
	return "stand";
}

/*
	Name: isstanceallowedatnode
	Namespace: aiutility
	Checksum: 0xD904A1
	Offset: 0x7C00
	Size: 0x12E
	Parameters: 2
	Flags: Linked
*/
function isstanceallowedatnode(stance, node)
{
	/#
		assert(isdefined(stance));
	#/
	/#
		assert(isdefined(node));
	#/
	if(stance == "stand" && (isdefined(node.spawnflags) && (node.spawnflags & 4) == 4))
	{
		return true;
	}
	if(stance == "crouch" && (isdefined(node.spawnflags) && (node.spawnflags & 8) == 8))
	{
		return true;
	}
	if(stance == "prone" && (isdefined(node.spawnflags) && (node.spawnflags & 16) == 16))
	{
		return true;
	}
	return false;
}

/*
	Name: trystoppingservice
	Namespace: aiutility
	Checksum: 0x25BFE1D2
	Offset: 0x7D38
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function trystoppingservice(behaviortreeentity)
{
	if(behaviortreeentity shouldholdgroundagainstenemy())
	{
		behaviortreeentity clearpath();
		behaviortreeentity.keepclaimednode = 1;
		return true;
	}
	behaviortreeentity.keepclaimednode = 0;
	return false;
}

/*
	Name: shouldstopmoving
	Namespace: aiutility
	Checksum: 0x8227F0CF
	Offset: 0x7DB0
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function shouldstopmoving(behaviortreeentity)
{
	if(behaviortreeentity shouldholdgroundagainstenemy())
	{
		return true;
	}
	return false;
}

/*
	Name: setcurrentweapon
	Namespace: aiutility
	Checksum: 0xE3057E89
	Offset: 0x7DE8
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function setcurrentweapon(weapon)
{
	self.weapon = weapon;
	self.weaponclass = weapon.weapclass;
	if(weapon != level.weaponnone)
	{
		/#
			assert(isdefined(weapon.worldmodel), ("" + weapon.name) + "");
		#/
	}
	self.weaponmodel = weapon.worldmodel;
}

/*
	Name: setprimaryweapon
	Namespace: aiutility
	Checksum: 0x93F55E66
	Offset: 0x7E90
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function setprimaryweapon(weapon)
{
	self.primaryweapon = weapon;
	self.primaryweaponclass = weapon.weapclass;
	if(weapon != level.weaponnone)
	{
		/#
			assert(isdefined(weapon.worldmodel), ("" + weapon.name) + "");
		#/
	}
}

/*
	Name: setsecondaryweapon
	Namespace: aiutility
	Checksum: 0x7DCA4AD1
	Offset: 0x7F20
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function setsecondaryweapon(weapon)
{
	self.secondaryweapon = weapon;
	self.secondaryweaponclass = weapon.weapclass;
	if(weapon != level.weaponnone)
	{
		/#
			assert(isdefined(weapon.worldmodel), ("" + weapon.name) + "");
		#/
	}
}

/*
	Name: keepclaimnode
	Namespace: aiutility
	Checksum: 0xB3CADD44
	Offset: 0x7FB0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function keepclaimnode(behaviortreeentity)
{
	behaviortreeentity.keepclaimednode = 1;
	return true;
}

/*
	Name: releaseclaimnode
	Namespace: aiutility
	Checksum: 0xC0CDB3F
	Offset: 0x7FE0
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function releaseclaimnode(behaviortreeentity)
{
	behaviortreeentity.keepclaimednode = 0;
	return true;
}

/*
	Name: getaimyawtoenemyfromnode
	Namespace: aiutility
	Checksum: 0x97E0A87D
	Offset: 0x8008
	Size: 0x8A
	Parameters: 3
	Flags: Linked
*/
function getaimyawtoenemyfromnode(behaviortreeentity, node, enemy)
{
	return angleclamp180((vectortoangles(behaviortreeentity lastknownpos(behaviortreeentity.enemy) - node.origin)[1]) - node.angles[1]);
}

/*
	Name: getaimpitchtoenemyfromnode
	Namespace: aiutility
	Checksum: 0xA36C0A17
	Offset: 0x80A0
	Size: 0x82
	Parameters: 3
	Flags: Linked
*/
function getaimpitchtoenemyfromnode(behaviortreeentity, node, enemy)
{
	return angleclamp180((vectortoangles(behaviortreeentity lastknownpos(behaviortreeentity.enemy) - node.origin)[0]) - node.angles[0]);
}

/*
	Name: choosefrontcoverdirection
	Namespace: aiutility
	Checksum: 0x5D933FC0
	Offset: 0x8130
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function choosefrontcoverdirection(behaviortreeentity)
{
	coverdirection = blackboard::getblackboardattribute(behaviortreeentity, "_cover_direction");
	blackboard::setblackboardattribute(behaviortreeentity, "_previous_cover_direction", coverdirection);
	blackboard::setblackboardattribute(behaviortreeentity, "_cover_direction", "cover_front_direction");
}

/*
	Name: shouldtacticalwalk
	Namespace: aiutility
	Checksum: 0x1E201153
	Offset: 0x81C0
	Size: 0x1E6
	Parameters: 1
	Flags: Linked
*/
function shouldtacticalwalk(behaviortreeentity)
{
	if(!behaviortreeentity haspath())
	{
		return false;
	}
	if(ai::hasaiattribute(behaviortreeentity, "forceTacticalWalk") && ai::getaiattribute(behaviortreeentity, "forceTacticalWalk"))
	{
		return true;
	}
	if(ai::hasaiattribute(behaviortreeentity, "disablesprint") && !ai::getaiattribute(behaviortreeentity, "disablesprint"))
	{
		if(ai::hasaiattribute(behaviortreeentity, "sprint") && ai::getaiattribute(behaviortreeentity, "sprint"))
		{
			return false;
		}
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
		if(pathdist < 9216)
		{
			return true;
		}
	}
	if(behaviortreeentity shouldfacemotion())
	{
		return false;
	}
	if(!behaviortreeentity issafefromgrenade())
	{
		return false;
	}
	return true;
}

/*
	Name: shouldstealth
	Namespace: aiutility
	Checksum: 0xF7D29263
	Offset: 0x83B0
	Size: 0x11E
	Parameters: 1
	Flags: Linked
*/
function shouldstealth(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.stealth))
	{
		now = gettime();
		if(behaviortreeentity isinscriptedstate())
		{
			return false;
		}
		if(behaviortreeentity hasvalidinterrupt("react"))
		{
			behaviortreeentity.stealth_react_last = now;
			return true;
		}
		if(isdefined(behaviortreeentity.stealth_reacting) && behaviortreeentity.stealth_reacting || (isdefined(behaviortreeentity.stealth_react_last) && (now - behaviortreeentity.stealth_react_last) < 250))
		{
			return true;
		}
		if(behaviortreeentity ai::has_behavior_attribute("stealth") && behaviortreeentity ai::get_behavior_attribute("stealth"))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: locomotionshouldstealth
	Namespace: aiutility
	Checksum: 0xF981C168
	Offset: 0x84D8
	Size: 0x1D6
	Parameters: 1
	Flags: Linked
*/
function locomotionshouldstealth(behaviortreeentity)
{
	if(!shouldstealth(behaviortreeentity))
	{
		return false;
	}
	if(behaviortreeentity haspath())
	{
		if(isdefined(behaviortreeentity.arrivalfinalpos) || isdefined(behaviortreeentity.pathgoalpos))
		{
			haswait = isdefined(self.currentgoal) && isdefined(self.currentgoal.script_wait_min) && isdefined(self.currentgoal.script_wait_max);
			if(haswait)
			{
				haswait = self.currentgoal.script_wait_min > 0 || self.currentgoal.script_wait_max > 0;
			}
			if(haswait || !isdefined(self.currentgoal) || (isdefined(self.currentgoal) && isdefined(self.currentgoal.scriptbundlename)))
			{
				goalpos = undefined;
				if(isdefined(behaviortreeentity.arrivalfinalpos))
				{
					goalpos = behaviortreeentity.arrivalfinalpos;
				}
				else
				{
					goalpos = behaviortreeentity.pathgoalpos;
				}
				goaldistsq = distancesquared(behaviortreeentity.origin, goalpos);
				if(goaldistsq <= 1936 && goaldistsq <= (behaviortreeentity.goalradius * behaviortreeentity.goalradius))
				{
					return false;
				}
			}
		}
		return true;
	}
	return false;
}

/*
	Name: shouldstealthresume
	Namespace: aiutility
	Checksum: 0x4EDD2E40
	Offset: 0x86B8
	Size: 0x62
	Parameters: 1
	Flags: Linked
*/
function shouldstealthresume(behaviortreeentity)
{
	if(!shouldstealth(behaviortreeentity))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.stealth_resume) && behaviortreeentity.stealth_resume)
	{
		behaviortreeentity.stealth_resume = undefined;
		return true;
	}
	return false;
}

/*
	Name: stealthreactcondition
	Namespace: aiutility
	Checksum: 0xA46A95C1
	Offset: 0x8728
	Size: 0x9C
	Parameters: 1
	Flags: Linked, Private
*/
function private stealthreactcondition(entity)
{
	inscene = isdefined(self._o_scene) && isdefined(self._o_scene._str_state) && self._o_scene._str_state == "play";
	return !(isdefined(entity.stealth_reacting) && entity.stealth_reacting) && entity hasvalidinterrupt("react") && !inscene;
}

/*
	Name: stealthreactstart
	Namespace: aiutility
	Checksum: 0x5ACE4537
	Offset: 0x87D0
	Size: 0x20
	Parameters: 1
	Flags: Linked, Private
*/
function private stealthreactstart(behaviortreeentity)
{
	behaviortreeentity.stealth_reacting = 1;
}

/*
	Name: stealthreactterminate
	Namespace: aiutility
	Checksum: 0x1D064623
	Offset: 0x87F8
	Size: 0x1A
	Parameters: 1
	Flags: Linked, Private
*/
function private stealthreactterminate(behaviortreeentity)
{
	behaviortreeentity.stealth_reacting = undefined;
}

/*
	Name: stealthidleterminate
	Namespace: aiutility
	Checksum: 0xDBA3404C
	Offset: 0x8820
	Size: 0x60
	Parameters: 1
	Flags: Linked, Private
*/
function private stealthidleterminate(behaviortreeentity)
{
	behaviortreeentity notify(#"stealthidleterminate");
	if(isdefined(behaviortreeentity.stealth_resume_after_idle) && behaviortreeentity.stealth_resume_after_idle)
	{
		behaviortreeentity.stealth_resume_after_idle = undefined;
		behaviortreeentity.stealth_resume = 1;
	}
}

/*
	Name: locomotionshouldpatrol
	Namespace: aiutility
	Checksum: 0xBF0EE21D
	Offset: 0x8888
	Size: 0x8E
	Parameters: 1
	Flags: Linked
*/
function locomotionshouldpatrol(behaviortreeentity)
{
	if(shouldstealth(behaviortreeentity))
	{
		return false;
	}
	if(behaviortreeentity haspath() && behaviortreeentity ai::has_behavior_attribute("patrol") && behaviortreeentity ai::get_behavior_attribute("patrol"))
	{
		return true;
	}
	return false;
}

/*
	Name: explosivekilled
	Namespace: aiutility
	Checksum: 0x7CDE30C5
	Offset: 0x8920
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function explosivekilled(behaviortreeentity)
{
	if(blackboard::getblackboardattribute(behaviortreeentity, "_damage_weapon_class") == "explosive")
	{
		return true;
	}
	return false;
}

/*
	Name: _dropriotshield
	Namespace: aiutility
	Checksum: 0xC541EC5B
	Offset: 0x8968
	Size: 0x84
	Parameters: 1
	Flags: Linked, Private
*/
function private _dropriotshield(riotshieldinfo)
{
	entity = self;
	entity shared::throwweapon(riotshieldinfo.weapon, riotshieldinfo.tag, 0);
	if(isdefined(entity))
	{
		entity detach(riotshieldinfo.model, riotshieldinfo.tag);
	}
}

/*
	Name: attachriotshield
	Namespace: aiutility
	Checksum: 0x7EECC596
	Offset: 0x89F8
	Size: 0xB8
	Parameters: 4
	Flags: Linked
*/
function attachriotshield(entity, riotshieldweapon, riotshieldmodel, riotshieldtag)
{
	riotshield = spawnstruct();
	riotshield.weapon = riotshieldweapon;
	riotshield.tag = riotshieldtag;
	riotshield.model = riotshieldmodel;
	entity attach(riotshieldmodel, riotshield.tag);
	entity.riotshield = riotshield;
}

/*
	Name: dropriotshield
	Namespace: aiutility
	Checksum: 0xBCE0508B
	Offset: 0x8AB8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function dropriotshield(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.riotshield))
	{
		riotshieldinfo = behaviortreeentity.riotshield;
		behaviortreeentity.riotshield = undefined;
		behaviortreeentity thread _dropriotshield(riotshieldinfo);
	}
}

/*
	Name: electrifiedkilled
	Namespace: aiutility
	Checksum: 0x595DE238
	Offset: 0x8B28
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function electrifiedkilled(behaviortreeentity)
{
	if(behaviortreeentity.damageweapon.rootweapon.name == "shotgun_pump_taser")
	{
		return true;
	}
	if(blackboard::getblackboardattribute(behaviortreeentity, "_damage_mod") == "mod_electrocuted")
	{
		return true;
	}
	return false;
}

/*
	Name: burnedkilled
	Namespace: aiutility
	Checksum: 0x5F01CDCF
	Offset: 0x8BA0
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function burnedkilled(behaviortreeentity)
{
	if(blackboard::getblackboardattribute(behaviortreeentity, "_damage_mod") == "mod_burned")
	{
		return true;
	}
	return false;
}

/*
	Name: rapskilled
	Namespace: aiutility
	Checksum: 0xDA17B8B3
	Offset: 0x8BE8
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function rapskilled(behaviortreeentity)
{
	if(isdefined(self.attacker) && isdefined(self.attacker.archetype) && self.attacker.archetype == "raps")
	{
		return true;
	}
	return false;
}

/*
	Name: meleeacquiremutex
	Namespace: aiutility
	Checksum: 0x7793B9AF
	Offset: 0x8C40
	Size: 0xF8
	Parameters: 1
	Flags: Linked
*/
function meleeacquiremutex(behaviortreeentity)
{
	if(isdefined(behaviortreeentity) && isdefined(behaviortreeentity.enemy))
	{
		behaviortreeentity.melee = spawnstruct();
		behaviortreeentity.melee.enemy = behaviortreeentity.enemy;
		if(isplayer(behaviortreeentity.melee.enemy))
		{
			if(!isdefined(behaviortreeentity.melee.enemy.meleeattackers))
			{
				behaviortreeentity.melee.enemy.meleeattackers = 0;
			}
			behaviortreeentity.melee.enemy.meleeattackers++;
		}
	}
}

/*
	Name: meleereleasemutex
	Namespace: aiutility
	Checksum: 0x6F2F1142
	Offset: 0x8D40
	Size: 0x11A
	Parameters: 1
	Flags: Linked
*/
function meleereleasemutex(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.melee))
	{
		if(isdefined(behaviortreeentity.melee.enemy))
		{
			if(isplayer(behaviortreeentity.melee.enemy))
			{
				if(isdefined(behaviortreeentity.melee.enemy.meleeattackers))
				{
					behaviortreeentity.melee.enemy.meleeattackers = behaviortreeentity.melee.enemy.meleeattackers - 1;
					if(behaviortreeentity.melee.enemy.meleeattackers <= 0)
					{
						behaviortreeentity.melee.enemy.meleeattackers = undefined;
					}
				}
			}
		}
		behaviortreeentity.melee = undefined;
	}
}

/*
	Name: shouldmutexmelee
	Namespace: aiutility
	Checksum: 0x12405F23
	Offset: 0x8E68
	Size: 0xEA
	Parameters: 1
	Flags: Linked
*/
function shouldmutexmelee(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.melee))
	{
		return 0;
	}
	if(isdefined(behaviortreeentity.enemy))
	{
		if(!isplayer(behaviortreeentity.enemy))
		{
			if(isdefined(behaviortreeentity.enemy.melee))
			{
				return 0;
			}
		}
		else
		{
			if(!sessionmodeiscampaigngame())
			{
				return 1;
			}
			if(!isdefined(behaviortreeentity.enemy.meleeattackers))
			{
				behaviortreeentity.enemy.meleeattackers = 0;
			}
			return behaviortreeentity.enemy.meleeattackers < 1;
		}
	}
	return 1;
}

/*
	Name: shouldnormalmelee
	Namespace: aiutility
	Checksum: 0x425658F2
	Offset: 0x8F60
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function shouldnormalmelee(behaviortreeentity)
{
	return hascloseenemytomelee(behaviortreeentity);
}

/*
	Name: shouldmelee
	Namespace: aiutility
	Checksum: 0xB7E6D289
	Offset: 0x8F90
	Size: 0x320
	Parameters: 1
	Flags: Linked
*/
function shouldmelee(entity)
{
	if(isdefined(entity.lastshouldmeleeresult) && !entity.lastshouldmeleeresult && (entity.lastshouldmeleechecktime + 50) >= gettime())
	{
		return false;
	}
	entity.lastshouldmeleechecktime = gettime();
	entity.lastshouldmeleeresult = 0;
	if(!isdefined(entity.enemy))
	{
		return false;
	}
	if(!entity.enemy.allowdeath)
	{
		return false;
	}
	if(!isalive(entity.enemy))
	{
		return false;
	}
	if(!issentient(entity.enemy))
	{
		return false;
	}
	if(isvehicle(entity.enemy) && (!(isdefined(entity.enemy.good_melee_target) && entity.enemy.good_melee_target)))
	{
		return false;
	}
	if(isplayer(entity.enemy) && entity.enemy getstance() == "prone")
	{
		return false;
	}
	chargedistsq = (isdefined(entity.melee_charge_rangesq) ? entity.melee_charge_rangesq : 140 * 140);
	if(distancesquared(entity.origin, entity.enemy.origin) > chargedistsq)
	{
		return false;
	}
	if(!shouldmutexmelee(entity))
	{
		return false;
	}
	if(ai::hasaiattribute(entity, "can_melee") && !ai::getaiattribute(entity, "can_melee"))
	{
		return false;
	}
	if(ai::hasaiattribute(entity.enemy, "can_be_meleed") && !ai::getaiattribute(entity.enemy, "can_be_meleed"))
	{
		return false;
	}
	if(shouldnormalmelee(entity) || shouldchargemelee(entity))
	{
		entity.lastshouldmeleeresult = 1;
		return true;
	}
	return false;
}

/*
	Name: hascloseenemytomelee
	Namespace: aiutility
	Checksum: 0xBCADD7D9
	Offset: 0x92B8
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function hascloseenemytomelee(entity)
{
	return hascloseenemytomeleewithrange(entity, 64 * 64);
}

/*
	Name: hascloseenemytomeleewithrange
	Namespace: aiutility
	Checksum: 0x8FA7A46B
	Offset: 0x92F0
	Size: 0x1C4
	Parameters: 2
	Flags: Linked
*/
function hascloseenemytomeleewithrange(entity, melee_range_sq)
{
	/#
		assert(isdefined(entity.enemy));
	#/
	if(!entity cansee(entity.enemy))
	{
		return 0;
	}
	predicitedposition = entity.enemy.origin + vectorscale(entity getenemyvelocity(), 0.25);
	distsq = distancesquared(entity.origin, predicitedposition);
	yawtoenemy = angleclamp180(entity.angles[1] - (vectortoangles(entity.enemy.origin - entity.origin)[1]));
	if(distsq <= (36 * 36))
	{
		return abs(yawtoenemy) <= 40;
	}
	if(distsq <= melee_range_sq && entity maymovetopoint(entity.enemy.origin))
	{
		return abs(yawtoenemy) <= 80;
	}
	return 0;
}

/*
	Name: shouldchargemelee
	Namespace: aiutility
	Checksum: 0xC0CC81F8
	Offset: 0x94C0
	Size: 0x24C
	Parameters: 1
	Flags: Linked
*/
function shouldchargemelee(entity)
{
	/#
		assert(isdefined(entity.enemy));
	#/
	currentstance = blackboard::getblackboardattribute(entity, "_stance");
	if(currentstance != "stand")
	{
		return 0;
	}
	if(isdefined(entity.nextchargemeleetime))
	{
		if(gettime() < entity.nextchargemeleetime)
		{
			return 0;
		}
	}
	enemydistsq = distancesquared(entity.origin, entity.enemy.origin);
	if(enemydistsq < (64 * 64))
	{
		return 0;
	}
	offset = entity.enemy.origin - ((vectornormalize(entity.enemy.origin - entity.origin)) * 36);
	chargedistsq = (isdefined(entity.melee_charge_rangesq) ? entity.melee_charge_rangesq : 140 * 140);
	if(enemydistsq < chargedistsq && entity maymovetopoint(offset, 1, 1))
	{
		yawtoenemy = angleclamp180(entity.angles[1] - (vectortoangles(entity.enemy.origin - entity.origin)[1]));
		return abs(yawtoenemy) <= 80;
	}
	return 0;
}

/*
	Name: shouldattackinchargemelee
	Namespace: aiutility
	Checksum: 0x8DEAB18
	Offset: 0x9718
	Size: 0xF6
	Parameters: 1
	Flags: Linked, Private
*/
function private shouldattackinchargemelee(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemy))
	{
		if(distancesquared(behaviortreeentity.origin, behaviortreeentity.enemy.origin) < (74 * 74))
		{
			yawtoenemy = angleclamp180(behaviortreeentity.angles[1] - (vectortoangles(behaviortreeentity.enemy.origin - behaviortreeentity.origin)[1]));
			if(abs(yawtoenemy) > 80)
			{
				return false;
			}
			return true;
		}
	}
}

/*
	Name: setupchargemeleeattack
	Namespace: aiutility
	Checksum: 0xAF37EC01
	Offset: 0x9818
	Size: 0xC4
	Parameters: 1
	Flags: Linked, Private
*/
function private setupchargemeleeattack(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemy) && isdefined(behaviortreeentity.enemy.vehicletype) && issubstr(behaviortreeentity.enemy.vehicletype, "firefly"))
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_melee_enemy_type", "fireflyswarm");
	}
	meleeacquiremutex(behaviortreeentity);
	keepclaimnode(behaviortreeentity);
}

/*
	Name: cleanupmelee
	Namespace: aiutility
	Checksum: 0xFD8D084B
	Offset: 0x98E8
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private cleanupmelee(behaviortreeentity)
{
	meleereleasemutex(behaviortreeentity);
	releaseclaimnode(behaviortreeentity);
	blackboard::setblackboardattribute(behaviortreeentity, "_melee_enemy_type", undefined);
}

/*
	Name: cleanupchargemelee
	Namespace: aiutility
	Checksum: 0x75CAA300
	Offset: 0x9950
	Size: 0xB4
	Parameters: 1
	Flags: Linked, Private
*/
function private cleanupchargemelee(behaviortreeentity)
{
	behaviortreeentity.nextchargemeleetime = gettime() + 2000;
	blackboard::setblackboardattribute(behaviortreeentity, "_melee_enemy_type", undefined);
	meleereleasemutex(behaviortreeentity);
	releaseclaimnode(behaviortreeentity);
	behaviortreeentity pathmode("move delayed", 1, randomfloatrange(0.75, 1.5));
}

/*
	Name: cleanupchargemeleeattack
	Namespace: aiutility
	Checksum: 0x53E02229
	Offset: 0x9A10
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function cleanupchargemeleeattack(behaviortreeentity)
{
	meleereleasemutex(behaviortreeentity);
	releaseclaimnode(behaviortreeentity);
	blackboard::setblackboardattribute(behaviortreeentity, "_melee_enemy_type", undefined);
	behaviortreeentity pathmode("move delayed", 1, randomfloatrange(0.5, 1));
}

/*
	Name: shouldchoosespecialpronepain
	Namespace: aiutility
	Checksum: 0xC2F3DB4A
	Offset: 0x9AB8
	Size: 0x54
	Parameters: 1
	Flags: Linked, Private
*/
function private shouldchoosespecialpronepain(behaviortreeentity)
{
	stance = blackboard::getblackboardattribute(behaviortreeentity, "_stance");
	return stance == "prone_back" || stance == "prone_front";
}

/*
	Name: shouldchoosespecialpain
	Namespace: aiutility
	Checksum: 0xABDE30A1
	Offset: 0x9B18
	Size: 0x4C
	Parameters: 1
	Flags: Linked, Private
*/
function private shouldchoosespecialpain(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.damageweapon))
	{
		return behaviortreeentity.damageweapon.specialpain || isdefined(behaviortreeentity.special_weapon);
	}
	return 0;
}

/*
	Name: shouldchoosespecialdeath
	Namespace: aiutility
	Checksum: 0xCD9C3040
	Offset: 0x9B70
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private shouldchoosespecialdeath(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.damageweapon))
	{
		return behaviortreeentity.damageweapon.specialpain;
	}
	return 0;
}

/*
	Name: shouldchoosespecialpronedeath
	Namespace: aiutility
	Checksum: 0x22A3B7E5
	Offset: 0x9BB8
	Size: 0x54
	Parameters: 1
	Flags: Linked, Private
*/
function private shouldchoosespecialpronedeath(behaviortreeentity)
{
	stance = blackboard::getblackboardattribute(behaviortreeentity, "_stance");
	return stance == "prone_back" || stance == "prone_front";
}

/*
	Name: setupexplosionanimscale
	Namespace: aiutility
	Checksum: 0x92EC95F1
	Offset: 0x9C18
	Size: 0x48
	Parameters: 2
	Flags: Linked, Private
*/
function private setupexplosionanimscale(entity, asmstatename)
{
	self.animtranslationscale = 2;
	self asmsetanimationrate(0.7);
	return 4;
}

/*
	Name: isbalconydeath
	Namespace: aiutility
	Checksum: 0x12DE9861
	Offset: 0x9C68
	Size: 0x270
	Parameters: 1
	Flags: Linked
*/
function isbalconydeath(behaviortreeentity)
{
	if(!isdefined(behaviortreeentity.node))
	{
		return false;
	}
	if(!(behaviortreeentity.node.spawnflags & 1024 || behaviortreeentity.node.spawnflags & 2048))
	{
		return false;
	}
	covermode = blackboard::getblackboardattribute(behaviortreeentity, "_cover_mode");
	if(covermode == "cover_alert" || covermode == "cover_mode_none")
	{
		return false;
	}
	if(isdefined(behaviortreeentity.node.script_balconydeathchance) && randomint(100) > (int(100 * behaviortreeentity.node.script_balconydeathchance)))
	{
		return false;
	}
	distsq = distancesquared(behaviortreeentity.origin, behaviortreeentity.node.origin);
	if(distsq > (16 * 16))
	{
		return false;
	}
	if(isdefined(level.players) && level.players.size > 0)
	{
		closest_player = util::get_closest_player(behaviortreeentity.origin, level.players[0].team);
		if(isdefined(closest_player))
		{
			if((abs(closest_player.origin[2] - behaviortreeentity.origin[2])) < 100)
			{
				distance2dfromplayersq = distance2dsquared(closest_player.origin, behaviortreeentity.origin);
				if(distance2dfromplayersq < (600 * 600))
				{
					return false;
				}
			}
		}
	}
	self.b_balcony_death = 1;
	return true;
}

/*
	Name: balconydeath
	Namespace: aiutility
	Checksum: 0x70B58874
	Offset: 0x9EE0
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function balconydeath(behaviortreeentity)
{
	behaviortreeentity.clamptonavmesh = 0;
	if(behaviortreeentity.node.spawnflags & 1024)
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_special_death", "balcony");
	}
	else if(behaviortreeentity.node.spawnflags & 2048)
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_special_death", "balcony_norail");
	}
}

/*
	Name: usecurrentposition
	Namespace: aiutility
	Checksum: 0xABDB06E6
	Offset: 0x9F98
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function usecurrentposition(entity)
{
	entity useposition(entity.origin);
}

/*
	Name: isunarmed
	Namespace: aiutility
	Checksum: 0xE3507CD
	Offset: 0x9FD0
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function isunarmed(behaviortreeentity)
{
	if(behaviortreeentity.weapon == level.weaponnone)
	{
		return true;
	}
	return false;
}

/*
	Name: forceragdoll
	Namespace: aiutility
	Checksum: 0x4351A17B
	Offset: 0xA008
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function forceragdoll(entity)
{
	entity startragdoll();
}

/*
	Name: preshootlaserandglinton
	Namespace: aiutility
	Checksum: 0x9E5A27A2
	Offset: 0xA038
	Size: 0x1A8
	Parameters: 1
	Flags: Linked
*/
function preshootlaserandglinton(ai)
{
	self endon(#"death");
	if(!isdefined(ai.laserstatus))
	{
		ai.laserstatus = 0;
	}
	sniper_glint = "lensflares/fx_lensflare_sniper_glint";
	while(true)
	{
		self waittill(#"about_to_fire");
		if(ai.laserstatus !== 1)
		{
			ai laseron();
			ai.laserstatus = 1;
			if(ai.team != "allies")
			{
				tag = ai gettagorigin("tag_glint");
				if(isdefined(tag))
				{
					playfxontag(sniper_glint, ai, "tag_glint");
				}
				else
				{
					type = (isdefined(ai.classname) ? "" + ai.classname : "");
					/#
						println(("" + type) + "");
					#/
					playfxontag(sniper_glint, ai, "tag_eye");
				}
			}
		}
	}
}

/*
	Name: postshootlaserandglintoff
	Namespace: aiutility
	Checksum: 0x89933B5C
	Offset: 0xA1E8
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function postshootlaserandglintoff(ai)
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"stopped_firing");
		if(ai.laserstatus === 1)
		{
			ai laseroff();
			ai.laserstatus = 0;
		}
	}
}

/*
	Name: isinphalanx
	Namespace: aiutility
	Checksum: 0xF795B6DB
	Offset: 0xA260
	Size: 0x2A
	Parameters: 1
	Flags: Linked, Private
*/
function private isinphalanx(entity)
{
	return entity ai::get_behavior_attribute("phalanx");
}

/*
	Name: isinphalanxstance
	Namespace: aiutility
	Checksum: 0x761035C
	Offset: 0xA298
	Size: 0xA6
	Parameters: 1
	Flags: Linked, Private
*/
function private isinphalanxstance(entity)
{
	phalanxstance = entity ai::get_behavior_attribute("phalanx_force_stance");
	currentstance = blackboard::getblackboardattribute(entity, "_stance");
	switch(phalanxstance)
	{
		case "stand":
		{
			return currentstance == "stand";
		}
		case "crouch":
		{
			return currentstance == "crouch";
		}
	}
	return 1;
}

/*
	Name: togglephalanxstance
	Namespace: aiutility
	Checksum: 0xBAF8AA62
	Offset: 0xA348
	Size: 0xA6
	Parameters: 1
	Flags: Linked, Private
*/
function private togglephalanxstance(entity)
{
	phalanxstance = entity ai::get_behavior_attribute("phalanx_force_stance");
	switch(phalanxstance)
	{
		case "stand":
		{
			blackboard::setblackboardattribute(entity, "_desired_stance", "stand");
			break;
		}
		case "crouch":
		{
			blackboard::setblackboardattribute(entity, "_desired_stance", "crouch");
			break;
		}
	}
}

/*
	Name: tookflashbangdamage
	Namespace: aiutility
	Checksum: 0xD9CB97CA
	Offset: 0xA3F8
	Size: 0x10E
	Parameters: 1
	Flags: Linked, Private
*/
function private tookflashbangdamage(entity)
{
	if(isdefined(entity.damageweapon) && isdefined(entity.damagemod))
	{
		weapon = entity.damageweapon;
		return entity.damagemod == "MOD_GRENADE_SPLASH" && isdefined(weapon.rootweapon) && (issubstr(weapon.rootweapon.name, "flash_grenade") || issubstr(weapon.rootweapon.name, "concussion_grenade") || issubstr(weapon.rootweapon.name, "proximity_grenade"));
	}
	return 0;
}

/*
	Name: isatattackobject
	Namespace: aiutility
	Checksum: 0x69A26EF
	Offset: 0xA510
	Size: 0xD0
	Parameters: 1
	Flags: Linked
*/
function isatattackobject(entity)
{
	if(isdefined(entity.enemyoverride) && isdefined(entity.enemyoverride[1]))
	{
		return false;
	}
	if(isdefined(entity.attackable) && (isdefined(entity.attackable.is_active) && entity.attackable.is_active))
	{
		if(!isdefined(entity.attackable_slot))
		{
			return false;
		}
		if(entity isatgoal())
		{
			entity.is_at_attackable = 1;
			return true;
		}
	}
	return false;
}

/*
	Name: shouldattackobject
	Namespace: aiutility
	Checksum: 0xA0661012
	Offset: 0xA5E8
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function shouldattackobject(entity)
{
	if(isdefined(entity.enemyoverride) && isdefined(entity.enemyoverride[1]))
	{
		return false;
	}
	if(isdefined(entity.attackable) && (isdefined(entity.attackable.is_active) && entity.attackable.is_active))
	{
		if(isdefined(entity.is_at_attackable) && entity.is_at_attackable)
		{
			return true;
		}
	}
	return false;
}

