// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\archetype_warlord_interface;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace warlord;

/*
	Name: __init__sytem__
	Namespace: warlord
	Checksum: 0x297F0D08
	Offset: 0x728
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("warlord", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: warlord
	Checksum: 0x4CC9924B
	Offset: 0x768
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	spawner::add_archetype_spawn_function("warlord", &warlordbehavior::archetypewarlordblackboardinit);
	spawner::add_archetype_spawn_function("warlord", &warlordserverutils::warlordspawnsetup);
	if(ai::shouldregisterclientfieldforarchetype("warlord"))
	{
		clientfield::register("actor", "warlord_damage_state", 1, 2, "int");
		clientfield::register("actor", "warlord_thruster_direction", 1, 3, "int");
		clientfield::register("actor", "warlord_type", 1, 2, "int");
		clientfield::register("actor", "warlord_lights_state", 1, 1, "int");
	}
	warlordinterface::registerwarlordinterfaceattributes();
}

#namespace warlordbehavior;

/*
	Name: registerbehaviorscriptfunctions
	Namespace: warlordbehavior
	Checksum: 0x8B1E11DC
	Offset: 0x8B0
	Size: 0x1AC
	Parameters: 0
	Flags: AutoExec
*/
function autoexec registerbehaviorscriptfunctions()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("warlordCanJukeCondition", &canjukecondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("warlordCanTacticalJukeCondition", &cantacticaljukecondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("warlordShouldBeAngryCondition", &shouldbeangrycondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("warlordShouldNormalMelee", &warlordshouldnormalmelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("warlordCanTakePainCondition", &cantakepaincondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("warlordExposedPainActionStart", &exposedpainactionstart);
	behaviortreenetworkutility::registerbehaviortreeaction("warlordDeathAction", &deathaction, undefined, undefined);
	behaviortreenetworkutility::registerbehaviortreeaction("warlordJukeAction", &jukeaction, undefined, &jukeactionterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("chooseBetterPositionService", &choosebetterpositionservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("WarlordAngryAttack", &warlordangryattack);
}

/*
	Name: archetypewarlordblackboardinit
	Namespace: warlordbehavior
	Checksum: 0x66861B70
	Offset: 0xA68
	Size: 0x7C
	Parameters: 0
	Flags: Linked, Private
*/
function private archetypewarlordblackboardinit()
{
	blackboard::createblackboardforentity(self);
	ai::createinterfaceforentity(self);
	self aiutility::registerutilityblackboardattributes();
	self.___archetypeonanimscriptedcallback = &archetypewarlordonanimscriptedcallback;
	/#
		self finalizetrackedblackboardattributes();
	#/
}

/*
	Name: archetypewarlordonanimscriptedcallback
	Namespace: warlordbehavior
	Checksum: 0x725E3DA9
	Offset: 0xAF0
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private archetypewarlordonanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity archetypewarlordblackboardinit();
}

/*
	Name: shouldhuntenemyplayer
	Namespace: warlordbehavior
	Checksum: 0x6819054A
	Offset: 0xB30
	Size: 0x50
	Parameters: 1
	Flags: Linked, Private
*/
function private shouldhuntenemyplayer(entity)
{
	if(isdefined(entity.enemy) && isdefined(entity.huntenemytime) && gettime() < entity.huntenemytime)
	{
		return true;
	}
	return false;
}

/*
	Name: _warlordhuntenemy
	Namespace: warlordbehavior
	Checksum: 0x310DC509
	Offset: 0xB88
	Size: 0x3AC
	Parameters: 1
	Flags: Linked, Private
*/
function private _warlordhuntenemy(entity)
{
	/#
		warlorddebughelpers::trystate(entity, 3, 1);
	#/
	if(distance2dsquared(entity.origin, self lastknownpos(self.enemy)) <= (250 * 250))
	{
		return false;
	}
	if(isdefined(entity.huntupdatenexttime) && gettime() < entity.huntupdatenexttime)
	{
		return false;
	}
	if(entity.isangryattack)
	{
		/#
			warlorddebughelpers::printstate(3, (1, 0, 1), "");
		#/
		return false;
	}
	positiononnavmesh = getclosestpointonnavmesh(self lastknownpos(self.enemy), 200);
	if(!isdefined(positiononnavmesh))
	{
		positiononnavmesh = self lastknownpos(self.enemy);
	}
	queryresult = positionquery_source_navigation(positiononnavmesh, 150, 250, 45, 36, entity, 36);
	positionquery_filter_inclaimedlocation(queryresult, entity);
	positionquery_filter_distancetogoal(queryresult, entity);
	if(queryresult.data.size > 0)
	{
		closestpoint = undefined;
		closestdistance = undefined;
		foreach(point in queryresult.data)
		{
			if(!point.inclaimedlocation && point.disttogoal == 0)
			{
				newclosestdistance = distance2dsquared(entity.origin, point.origin);
				if(!isdefined(closestpoint) || newclosestdistance < closestdistance)
				{
					closestpoint = point.origin;
					closestdistance = newclosestdistance;
				}
			}
		}
		if(isdefined(closestpoint))
		{
			/#
				warlorddebughelpers::setcurrentstate(entity, 3, 1);
			#/
			entity useposition(closestpoint);
			entity.huntupdatenexttime = gettime() + randomintrange(500, 1500);
			return true;
		}
	}
	/#
		warlorddebughelpers::setstatefailed(entity, 3);
	#/
	entity.huntenemytime = undefined;
	return false;
}

/*
	Name: choosebetterpositionservice
	Namespace: warlordbehavior
	Checksum: 0xB162A48F
	Offset: 0xF40
	Size: 0x1284
	Parameters: 1
	Flags: Linked
*/
function choosebetterpositionservice(entity)
{
	if(entity asmistransitionrunning() || entity getbehaviortreestatus() != 5 || entity asmissubstatepending() || entity asmistransdecrunning())
	{
		return 0;
	}
	shouldrepath = 0;
	istrackingenemylastpos = 0;
	searchorigin = undefined;
	bapproachinggoal = entity isapproachinggoal();
	if(!bapproachinggoal)
	{
		warlordserverutils::clearpreferedpoint(entity);
		/#
			warlorddebughelpers::setcurrentstate(entity, 6);
		#/
		if(isdefined(entity.goalent) || entity.goalradius < 72)
		{
			goalposonmesh = getclosestpointonnavmesh(self.goalpos, 200);
			if(!isdefined(goalposonmesh))
			{
				goalposonmesh = self.goalpos;
			}
			entity useposition(goalposonmesh);
			return 1;
		}
	}
	if(bapproachinggoal && shouldhuntenemyplayer(entity))
	{
		return _warlordhuntenemy(entity);
	}
	if(bapproachinggoal && warlordserverutils::updatepreferedpoint(entity))
	{
		return 1;
	}
	if(isdefined(entity.lastenemysightpos) && !warlordserverutils::havetoolowtoattackenemy(entity))
	{
		searchorigin = entity.lastenemysightpos;
	}
	else
	{
		/#
			entity warlorddebughelpers::printstate(undefined, (1, 0, 0), "");
		#/
		searchorigin = entity.goalpos;
	}
	if(isdefined(searchorigin))
	{
		searchorigin = getclosestpointonnavmesh(searchorigin, 200);
	}
	if(!isdefined(searchorigin))
	{
		return 0;
	}
	if(!bapproachinggoal || !isdefined(entity.nextfindbetterpositiontime) || gettime() > entity.nextfindbetterpositiontime)
	{
		shouldrepath = 1;
	}
	if(isdefined(entity.enemy) && !entity seerecently(entity.enemy, 2) && isdefined(entity.lastenemysightpos))
	{
		/#
			entity warlorddebughelpers::printstate(undefined, (1, 1, 1), "");
		#/
		istrackingenemylastpos = 1;
		if(isdefined(entity.pathgoalpos))
		{
			distancetogoalsqr = distancesquared(searchorigin, entity.pathgoalpos);
			if(distancetogoalsqr < (200 * 200))
			{
				shouldrepath = 0;
			}
		}
		else
		{
			shouldrepath = 1;
		}
	}
	if(!shouldrepath)
	{
		if(isdefined(entity.hascrouchingenemy))
		{
			entity.hascrouchingenemy = undefined;
			shouldrepath = 1;
		}
	}
	if(shouldrepath)
	{
		queryresult = positionquery_source_navigation(searchorigin, 0, entity.engagemaxdist, 45, 72, entity, 72);
		positionquery_filter_inclaimedlocation(queryresult, entity);
		positionquery_filter_distancetogoal(queryresult, entity);
		if(isdefined(entity.enemy) && istrackingenemylastpos && (isdefined(entity.var_568222a9) && entity.var_568222a9))
		{
			positionquery_filter_sight(queryresult, self lastknownpos(self.enemy), self geteye() - self.origin, self, 20);
		}
		preferedpoints = [];
		randompoints = [];
		bpointsavailable = 0;
		bpointsingoal = 0;
		bpointsvisible = 0;
		closepointdistance = 36;
		foreach(point in queryresult.data)
		{
			if(point.inclaimedlocation)
			{
				continue;
			}
			bpointsavailable++;
			if(point.disttogoal > 0)
			{
				continue;
			}
			bpointsingoal++;
			if(isdefined(point.visibility) && !point.visibility)
			{
				continue;
			}
			bpointsvisible++;
			if(point.disttoorigin2d < closepointdistance)
			{
				continue;
			}
			randompoints[randompoints.size] = point.origin;
		}
		if(!(isdefined(entity.enemy) && istrackingenemylastpos && (isdefined(entity.var_568222a9) && entity.var_568222a9)))
		{
			preferedpoints = warlordserverutils::getpreferedvalidpoints(entity);
		}
		if(randompoints.size == 0 && preferedpoints.size == 0)
		{
			if(bpointsavailable == 0)
			{
				return 0;
			}
			if(bpointsingoal == 0)
			{
				searchoriginongoalradius = entity.goalpos + ((vectornormalize(searchorigin - entity.goalpos)) * entity.goalradius);
				queryresult = positionquery_source_navigation(searchoriginongoalradius, 0, entity.engagemaxdist, 45, 72, entity, 108);
				positionquery_filter_inclaimedlocation(queryresult, entity);
				positionquery_filter_distancetogoal(queryresult, entity);
				bpointsavailable = 0;
				bpointsingoal = 0;
				bpointsvisible = 0;
				foreach(point in queryresult.data)
				{
					if(point.inclaimedlocation)
					{
						continue;
					}
					bpointsavailable++;
					if(point.disttogoal > 0)
					{
						continue;
					}
					bpointsingoal++;
					if(isdefined(point.visibility) && !point.visibility)
					{
						continue;
					}
					bpointsvisible++;
					if(point.disttoorigin2d < closepointdistance)
					{
						continue;
					}
					randompoints[randompoints.size] = point.origin;
				}
				if(randompoints.size == 0)
				{
					foreach(point in queryresult.data)
					{
						if(point.inclaimedlocation)
						{
							continue;
						}
						if(point.disttogoal > 0)
						{
							continue;
						}
						if(bpointsvisible > 0 && isdefined(point.visibility) && !point.visibility)
						{
							continue;
						}
						randompoints[randompoints.size] = point.origin;
					}
				}
			}
			else
			{
				foreach(point in queryresult.data)
				{
					if(point.inclaimedlocation)
					{
						continue;
					}
					if(point.disttogoal > 0)
					{
						continue;
					}
					if(bpointsvisible > 0 && isdefined(point.visibility) && !point.visibility)
					{
						continue;
					}
					randompoints[randompoints.size] = point.origin;
				}
			}
			if(randompoints.size == 0)
			{
				if(!bapproachinggoal)
				{
					if(!isdefined(randompoints))
					{
						randompoints = [];
					}
					else if(!isarray(randompoints))
					{
						randompoints = array(randompoints);
					}
					randompoints[randompoints.size] = entity.goalpos;
				}
				else
				{
					/#
						warlorddebughelpers::setstatefailed(entity, 5);
					#/
					return 0;
				}
			}
		}
		goalweight = -10000;
		engageminfalloffdistsqrd = entity.engageminfalloffdist * entity.engageminfalloffdist;
		engagemindistsqrd = entity.engagemindist * entity.engagemindist;
		engagemaxdistsqrd = entity.engagemaxdist * entity.engagemaxdist;
		engagemaxfalloffdistsqrd = entity.engagemaxfalloffdist * entity.engagemaxfalloffdist;
		if(isdefined(entity.enemy) && issentient(entity.enemy))
		{
			enemyforward = vectornormalize(anglestoforward(entity.enemy.angles));
		}
		for(index = 0; index < randompoints.size; index++)
		{
			distancesqrdtoenemy = distance2dsquared(randompoints[index], searchorigin);
			bweightsign = 1;
			if(isdefined(istrackingenemylastpos) || (isdefined(entity.var_568222a9) && entity.var_568222a9))
			{
				bweightsign = -1;
			}
			pointweight = 0;
			if(distancesqrdtoenemy < engageminfalloffdistsqrd)
			{
				pointweight = -1 * bweightsign;
			}
			else
			{
				if(distancesqrdtoenemy < engagemindistsqrd)
				{
					pointweight = -0.5 * bweightsign;
				}
				else
				{
					if(distancesqrdtoenemy > engagemaxfalloffdistsqrd)
					{
						pointweight = 1 * bweightsign;
					}
					else if(distancesqrdtoenemy > engagemaxdistsqrd)
					{
						pointweight = 1 * bweightsign;
					}
				}
			}
			if(isdefined(enemyforward))
			{
				anglefromforward = acos(math::clamp(vectordot(vectornormalize(pointweight - entity.enemy.origin), enemyforward), -1, 1));
				if(anglefromforward > 80)
				{
					pointweight = pointweight + -0.5;
				}
			}
			pointweight = pointweight + (randomfloatrange(-0.25, 0.25));
			if(goalweight < pointweight)
			{
				goalweight = pointweight;
				goalposition = randompoints[index];
			}
			/#
				if(getdvarint("") > 0 && isdefined(getentbynum(getdvarint(""))) && entity == getentbynum(getdvarint("")))
				{
					as_debug::debugdrawweightedpoint(entity, randompoints[index], pointweight, -1.25, 1.75);
				}
			#/
		}
		normalpointsmaxgoalweight = goalweight;
		foreach(point in preferedpoints)
		{
			if(point === entity.var_541cb3cf)
			{
				continue;
			}
			pointweight = randomfloatrange(normalpointsmaxgoalweight - 0.25, normalpointsmaxgoalweight + 0.5);
			if(goalweight < pointweight)
			{
				goalweight = pointweight;
				goalposition = point.origin;
				preferedpoint = point;
			}
			/#
				if(getdvarint("") > 0 && isdefined(getentbynum(getdvarint(""))) && entity == getentbynum(getdvarint("")))
				{
					as_debug::debugdrawweightedpoint(entity, point.origin, pointweight, -1.25, 1.75);
				}
			#/
		}
		if(isdefined(goalposition))
		{
			if(entity findpath(entity.origin, goalposition, 1, 0))
			{
				entity useposition(goalposition);
				entity.nextfindbetterpositiontime = gettime() + entity.coversearchinterval;
				if(isdefined(preferedpoint))
				{
					/#
						warlorddebughelpers::setcurrentstate(entity, 4);
					#/
					warlordserverutils::setpreferedpoint(entity, preferedpoint);
				}
				/#
					if(!isdefined(preferedpoint))
					{
						warlorddebughelpers::setcurrentstate(entity, 5);
					}
				#/
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: canjukecondition
	Namespace: warlordbehavior
	Checksum: 0xE169C2F2
	Offset: 0x21D0
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function canjukecondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.nextjuketime) && gettime() < behaviortreeentity.nextjuketime)
	{
		return 0;
	}
	return warlordserverutils::warlordcanjuke(behaviortreeentity);
}

/*
	Name: cantacticaljukecondition
	Namespace: warlordbehavior
	Checksum: 0x4E3031FE
	Offset: 0x2228
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function cantacticaljukecondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.nextjuketime) && gettime() < behaviortreeentity.nextjuketime)
	{
		return 0;
	}
	return warlordserverutils::warlordcantacticaljuke(behaviortreeentity);
}

/*
	Name: warlordshouldnormalmelee
	Namespace: warlordbehavior
	Checksum: 0xAC318479
	Offset: 0x2280
	Size: 0x298
	Parameters: 1
	Flags: Linked
*/
function warlordshouldnormalmelee(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemy) && (!(isdefined(behaviortreeentity.enemy.allowdeath) && behaviortreeentity.enemy.allowdeath)))
	{
		return false;
	}
	if(aiutility::hasenemy(behaviortreeentity) && !isalive(behaviortreeentity.enemy))
	{
		return false;
	}
	if(!issentient(behaviortreeentity.enemy))
	{
		return false;
	}
	if(isvehicle(behaviortreeentity.enemy) && (!(isdefined(behaviortreeentity.enemy.good_melee_target) && behaviortreeentity.enemy.good_melee_target)))
	{
		return false;
	}
	if(!aiutility::shouldmutexmelee(behaviortreeentity))
	{
		return false;
	}
	if(behaviortreeentity ai::has_behavior_attribute("can_melee") && !behaviortreeentity ai::get_behavior_attribute("can_melee"))
	{
		return false;
	}
	if(behaviortreeentity.enemy ai::has_behavior_attribute("can_be_meleed") && !behaviortreeentity.enemy ai::get_behavior_attribute("can_be_meleed"))
	{
		return false;
	}
	if(!isplayer(behaviortreeentity.enemy) && (!(isdefined(behaviortreeentity.enemy.magic_bullet_shield) && behaviortreeentity.enemy.magic_bullet_shield)))
	{
		return false;
	}
	if(aiutility::hascloseenemytomeleewithrange(behaviortreeentity, 100 * 100))
	{
		if(warlordserverutils::isenemytoolowtoattack(behaviortreeentity.enemy))
		{
			warlordserverutils::setenemytoolowtoattack(behaviortreeentity);
			return false;
		}
		return true;
	}
	return false;
}

/*
	Name: cantakepaincondition
	Namespace: warlordbehavior
	Checksum: 0x4E15C437
	Offset: 0x2520
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function cantakepaincondition(behaviortreeentity)
{
	return gettime() >= behaviortreeentity.var_2ac908f2;
}

/*
	Name: jukeaction
	Namespace: warlordbehavior
	Checksum: 0x5C456C57
	Offset: 0x2548
	Size: 0x1C0
	Parameters: 2
	Flags: Linked
*/
function jukeaction(behaviortreeentity, asmstatename)
{
	if(warlordserverutils::havetoolowtoattackenemy(behaviortreeentity))
	{
		nextjuketime = 1000;
	}
	else
	{
		nextjuketime = 3000;
	}
	behaviortreeentity.nextjuketime = gettime() + nextjuketime;
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	jukedirection = blackboard::getblackboardattribute(behaviortreeentity, "_juke_direction");
	switch(jukedirection)
	{
		case "left":
		{
			clientfield::set("warlord_thruster_direction", 4);
			break;
		}
		case "right":
		{
			clientfield::set("warlord_thruster_direction", 3);
			break;
		}
	}
	behaviortreeentity clearpath();
	jukeinfo = spawnstruct();
	jukeinfo.origin = behaviortreeentity.origin;
	jukeinfo.entity = behaviortreeentity;
	blackboard::addblackboardevent("actor_juke", jukeinfo, 2000);
	jukeinfo.entity playsound("fly_jetpack_juke_warlord");
	return 5;
}

/*
	Name: jukeactionterminate
	Namespace: warlordbehavior
	Checksum: 0xFDCC7FFA
	Offset: 0x2710
	Size: 0xB0
	Parameters: 2
	Flags: Linked
*/
function jukeactionterminate(behaviortreeentity, asmstatename)
{
	blackboard::setblackboardattribute(behaviortreeentity, "_juke_direction", undefined);
	clientfield::set("warlord_thruster_direction", 0);
	positiononnavmesh = getclosestpointonnavmesh(behaviortreeentity.origin, 200);
	if(!isdefined(positiononnavmesh))
	{
		positiononnavmesh = behaviortreeentity.origin;
	}
	behaviortreeentity useposition(positiononnavmesh);
	return 4;
}

/*
	Name: deathaction
	Namespace: warlordbehavior
	Checksum: 0x5E96BEC8
	Offset: 0x27C8
	Size: 0x50
	Parameters: 2
	Flags: Linked
*/
function deathaction(behaviortreeentity, asmstatename)
{
	clientfield::set("warlord_damage_state", 3);
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	return 5;
}

/*
	Name: exposedpainactionstart
	Namespace: warlordbehavior
	Checksum: 0xFA8D1E45
	Offset: 0x2820
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function exposedpainactionstart(behaviortreeentity)
{
	behaviortreeentity.var_2ac908f2 = gettime() + randomintrange(500, 2500);
	aiutility::keepclaimnode(behaviortreeentity);
}

/*
	Name: shouldbeangrycondition
	Namespace: warlordbehavior
	Checksum: 0xF09D1CAA
	Offset: 0x2880
	Size: 0x12A
	Parameters: 1
	Flags: Linked
*/
function shouldbeangrycondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.nextangrytime) && gettime() < behaviortreeentity.nextangrytime)
	{
		return 0;
	}
	if(!isdefined(behaviortreeentity.knownattackers) || behaviortreeentity.knownattackers.size == 0)
	{
		return 0;
	}
	if(behaviortreeentity.knownattackers.size == 1 && isdefined(behaviortreeentity.enemy) && behaviortreeentity.knownattackers[0].attacker == behaviortreeentity.enemy)
	{
		return 0;
	}
	if(isdefined(behaviortreeentity.accumilateddamage) && behaviortreeentity.accumilateddamage > warlordserverutils::getscaledforplayers(200, 1.5, 2, 2.5))
	{
		return 1;
	}
	return behaviortreeentity.isangryattack;
}

/*
	Name: warlordangryattack
	Namespace: warlordbehavior
	Checksum: 0xF2D3E11F
	Offset: 0x29B8
	Size: 0x2E0
	Parameters: 1
	Flags: Linked
*/
function warlordangryattack(entity)
{
	/#
		warlorddebughelpers::printstate(1, (0, 1, 0), "");
	#/
	entity.isangryattack = 1;
	entity.forcefire = 1;
	entity.accumilateddamage = 0;
	entity.nextangrytime = gettime() + 13000;
	warlordserverutils::updateattackerslist(entity);
	attackersarray = [];
	for(i = 0; i < entity.knownattackers.size; i++)
	{
		for(j = i + 1; j < entity.knownattackers.size; j++)
		{
			if(entity.knownattackers[i].threat < entity.knownattackers[j].threat)
			{
				tmp = entity.knownattackers[j].threat;
				entity.knownattackers[j].threat = entity.knownattackers[i].threat;
				entity.knownattackers[i].threat = tmp;
			}
		}
	}
	foreach(data in entity.knownattackers)
	{
		if(!isdefined(attackersarray))
		{
			attackersarray = [];
		}
		else if(!isarray(attackersarray))
		{
			attackersarray = array(attackersarray);
		}
		attackersarray[attackersarray.size] = data.attacker;
	}
	thread warlordangryattack_shootthemall(entity, attackersarray);
	return true;
}

/*
	Name: warlordangryattack_shootthemall
	Namespace: warlordbehavior
	Checksum: 0xC6CC73FA
	Offset: 0x2CA0
	Size: 0x14C
	Parameters: 2
	Flags: Linked
*/
function warlordangryattack_shootthemall(entity, attackersarray)
{
	entity endon(#"disconnect");
	entity endon(#"death");
	entity notify(#"hash_b160390f");
	shoottime = getdvarfloat("warlordangryattack", 3);
	foreach(attacker in attackersarray)
	{
		if(isdefined(attacker))
		{
			entity ai::shoot_at_target("normal", attacker, undefined, shoottime, undefined, 1);
		}
	}
	/#
		warlorddebughelpers::printstate(1, (0, 0, 1), "");
	#/
	entity.forcefire = 0;
	entity.isangryattack = 0;
}

#namespace warlordserverutils;

/*
	Name: getaliveplayerscount
	Namespace: warlordserverutils
	Checksum: 0xCAD3D077
	Offset: 0x2DF8
	Size: 0x50
	Parameters: 1
	Flags: None
*/
function getaliveplayerscount(entity)
{
	if(entity.team == "allies")
	{
		return level.alivecount["axis"];
	}
	return level.alivecount["allies"];
}

/*
	Name: setwarlordaggressivemode
	Namespace: warlordserverutils
	Checksum: 0x3AA3D7C8
	Offset: 0x2E58
	Size: 0x15A
	Parameters: 2
	Flags: Linked
*/
function setwarlordaggressivemode(entity, b_aggressive_mode)
{
	entity.var_568222a9 = b_aggressive_mode;
	if(isdefined(b_aggressive_mode) && b_aggressive_mode)
	{
		foreach(player in level.players)
		{
			entity setpersonalthreatbias(player, 1000);
		}
	}
	else
	{
		foreach(player in level.players)
		{
			entity setpersonalthreatbias(player, 0, 1);
		}
	}
}

/*
	Name: addpreferedpoint
	Namespace: warlordserverutils
	Checksum: 0xE8D220CF
	Offset: 0x2FC0
	Size: 0x1D6
	Parameters: 5
	Flags: Linked
*/
function addpreferedpoint(entity, position, min_duration, max_duration, name)
{
	positiononnavmesh = getclosestpointonnavmesh(position, 200, 25);
	if(!isdefined(positiononnavmesh))
	{
		/#
			println("" + position);
		#/
		return;
	}
	position = positiononnavmesh;
	if(!entity isposatgoal(position))
	{
		/#
			println("" + position);
		#/
	}
	point = spawnstruct();
	point.origin = position;
	point.min_duration = min_duration;
	point.max_duration = max_duration;
	point.name = name;
	if(!isdefined(entity.prefered_points))
	{
		entity.prefered_points = [];
	}
	else if(!isarray(entity.prefered_points))
	{
		entity.prefered_points = array(entity.prefered_points);
	}
	entity.prefered_points[entity.prefered_points.size] = point;
}

/*
	Name: deletepreferedpoint
	Namespace: warlordserverutils
	Checksum: 0x1F35D680
	Offset: 0x31A0
	Size: 0x1C2
	Parameters: 2
	Flags: Linked
*/
function deletepreferedpoint(entity, name)
{
	if(isdefined(entity.prefered_points))
	{
		points_to_remove = [];
		foreach(point in entity.prefered_points)
		{
			if(point.name === name)
			{
				if(!isdefined(points_to_remove))
				{
					points_to_remove = [];
				}
				else if(!isarray(points_to_remove))
				{
					points_to_remove = array(points_to_remove);
				}
				points_to_remove[points_to_remove.size] = point;
			}
		}
		if(points_to_remove.size > 0)
		{
			foreach(point in points_to_remove)
			{
				arrayremovevalue(entity.prefered_points, point);
			}
			return true;
		}
	}
	return false;
}

/*
	Name: clearallpreferedpoints
	Namespace: warlordserverutils
	Checksum: 0x9836F391
	Offset: 0x3370
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function clearallpreferedpoints(entity)
{
	clearpreferedpoint(entity);
	entity.prefered_points = [];
}

/*
	Name: clearpreferedpointsoutsidegoal
	Namespace: warlordserverutils
	Checksum: 0xEA480D72
	Offset: 0x33B0
	Size: 0x1A2
	Parameters: 1
	Flags: Linked
*/
function clearpreferedpointsoutsidegoal(entity)
{
	points_to_remove = [];
	foreach(point in entity.prefered_points)
	{
		if(!entity isposatgoal(point.origin))
		{
			if(!isdefined(points_to_remove))
			{
				points_to_remove = [];
			}
			else if(!isarray(points_to_remove))
			{
				points_to_remove = array(points_to_remove);
			}
			points_to_remove[points_to_remove.size] = point;
		}
	}
	foreach(point in points_to_remove)
	{
		arrayremovevalue(entity.prefered_points, point);
	}
}

/*
	Name: setpreferedpoint
	Namespace: warlordserverutils
	Checksum: 0xDBFFF006
	Offset: 0x3560
	Size: 0x44
	Parameters: 2
	Flags: Linked, Private
*/
function private setpreferedpoint(entity, point)
{
	entity.var_541cb3cf = entity.current_prefered_point;
	entity.current_prefered_point = point;
}

/*
	Name: clearpreferedpoint
	Namespace: warlordserverutils
	Checksum: 0x7FA14ED5
	Offset: 0x35B0
	Size: 0x52
	Parameters: 1
	Flags: Linked, Private
*/
function private clearpreferedpoint(entity)
{
	/#
		warlorddebughelpers::setcurrentstate(entity, undefined);
	#/
	entity.var_7e5dd3e4 = undefined;
	entity.current_prefered_point_expiration = undefined;
	entity.current_prefered_point = undefined;
}

/*
	Name: atpreferedpoint
	Namespace: warlordserverutils
	Checksum: 0x884EF31C
	Offset: 0x3610
	Size: 0xB0
	Parameters: 1
	Flags: Linked, Private
*/
function private atpreferedpoint(entity)
{
	if(isdefined(entity.current_prefered_point) && (distancesquared(entity.current_prefered_point.origin, entity.origin) < (36 * 36) && (abs(self.current_prefered_point.origin[2] - entity.origin[2])) < 45))
	{
		return true;
	}
	return false;
}

/*
	Name: reachingpreferedpoint
	Namespace: warlordserverutils
	Checksum: 0x9A2E3624
	Offset: 0x36C8
	Size: 0x88
	Parameters: 1
	Flags: Linked, Private
*/
function private reachingpreferedpoint(entity)
{
	if(!isdefined(entity.current_prefered_point))
	{
		return false;
	}
	if(atpreferedpoint(entity))
	{
		return true;
	}
	if(isdefined(entity.pathgoalpos) && entity.pathgoalpos == entity.current_prefered_point.origin)
	{
		return true;
	}
	return false;
}

/*
	Name: updatepreferedpoint
	Namespace: warlordserverutils
	Checksum: 0xF0F30C96
	Offset: 0x3758
	Size: 0x204
	Parameters: 1
	Flags: Linked, Private
*/
function private updatepreferedpoint(entity)
{
	if(isdefined(entity.current_prefered_point))
	{
		if(atpreferedpoint(entity))
		{
			if(isdefined(entity.current_prefered_point_expiration))
			{
				if(gettime() > entity.current_prefered_point_expiration)
				{
					clearpreferedpoint(entity);
					return false;
				}
				return true;
			}
			if(isdefined(entity.current_prefered_point.min_duration))
			{
				entity.var_7e5dd3e4 = gettime();
				if(!isdefined(entity.current_prefered_point.max_duration) || entity.current_prefered_point.max_duration == entity.current_prefered_point.min_duration)
				{
					entity.current_prefered_point_expiration = gettime() + entity.current_prefered_point.min_duration;
				}
				else
				{
					duration = randomintrange(entity.current_prefered_point.min_duration, entity.current_prefered_point.max_duration);
					entity.current_prefered_point_expiration = gettime() + duration;
				}
				return true;
			}
			clearpreferedpoint(entity);
			return false;
		}
		if(!reachingpreferedpoint(entity))
		{
			entity useposition(entity.current_prefered_point.origin);
		}
		return true;
	}
	return false;
}

/*
	Name: getpreferedvalidpoints
	Namespace: warlordserverutils
	Checksum: 0xB5364E33
	Offset: 0x3968
	Size: 0x244
	Parameters: 1
	Flags: Linked, Private
*/
function private getpreferedvalidpoints(entity)
{
	validpoints = [];
	if(isdefined(entity.prefered_points))
	{
		foreach(point in entity.prefered_points)
		{
			if(!entity isposatgoal(point.origin))
			{
				distance = distance2dsquared(entity.origin, point.origin);
				distance = sqrt(distance);
				continue;
			}
			if(entity isposinclaimedlocation(point.origin))
			{
				continue;
			}
			if(isdefined(entity.enemy) && (isdefined(entity.var_568222a9) && entity.var_568222a9))
			{
				if(!bullettracepassed(entity geteye(), entity.enemy.origin + vectorscale((0, 0, 1), 50), 0, entity, entity.enemy))
				{
					continue;
				}
			}
			if(!isdefined(validpoints))
			{
				validpoints = [];
			}
			else if(!isarray(validpoints))
			{
				validpoints = array(validpoints);
			}
			validpoints[validpoints.size] = point;
		}
	}
	return validpoints;
}

/*
	Name: getscaledforplayers
	Namespace: warlordserverutils
	Checksum: 0xA539659F
	Offset: 0x3BB8
	Size: 0xA6
	Parameters: 4
	Flags: Linked
*/
function getscaledforplayers(val, scale2, scale3, scale4)
{
	if(!isdefined(level.players))
	{
		return val;
	}
	if(level.players.size == 2)
	{
		return val * scale2;
	}
	if(level.players.size == 3)
	{
		return val * scale3;
	}
	if(level.players.size == 4)
	{
		return val * scale4;
	}
	return val;
}

/*
	Name: warlordcanjuke
	Namespace: warlordserverutils
	Checksum: 0x52DEA568
	Offset: 0x3C68
	Size: 0x154
	Parameters: 1
	Flags: Linked
*/
function warlordcanjuke(entity)
{
	if(!isdefined(entity.enemy))
	{
		return false;
	}
	distancesqr = distancesquared(entity.enemy.origin, entity.origin);
	if(distancesqr < (300 * 300))
	{
		jukedistance = 72.5;
	}
	else
	{
		jukedistance = 145;
	}
	jukedirection = aiutility::calculatejukedirection(entity, 18, jukedistance);
	if(jukedirection != "forward")
	{
		blackboard::setblackboardattribute(entity, "_juke_direction", jukedirection);
		if(jukedistance == 145)
		{
			blackboard::setblackboardattribute(entity, "_juke_distance", "long");
		}
		else
		{
			blackboard::setblackboardattribute(entity, "_juke_distance", "short");
		}
		return true;
	}
	return false;
}

/*
	Name: warlordcantacticaljuke
	Namespace: warlordserverutils
	Checksum: 0xDCAACE65
	Offset: 0x3DC8
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function warlordcantacticaljuke(entity)
{
	if(entity haspath())
	{
		locomotiondirection = aiutility::bb_getlocomotionfaceenemyquadrant();
		if(locomotiondirection == "locomotion_face_enemy_front" || locomotiondirection == "locomotion_face_enemy_back")
		{
			jukedirection = aiutility::calculatejukedirection(entity, 50, 145);
			if(jukedirection != "forward")
			{
				blackboard::setblackboardattribute(entity, "_juke_direction", jukedirection);
				blackboard::setblackboardattribute(entity, "_juke_distance", "long");
				return true;
			}
		}
	}
	return false;
}

/*
	Name: isenemytoolowtoattack
	Namespace: warlordserverutils
	Checksum: 0xEE04B64
	Offset: 0x3EC8
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function isenemytoolowtoattack(enemy)
{
	if(isplayer(enemy))
	{
		if(isdefined(enemy.laststand) && enemy.laststand)
		{
			return true;
		}
		playerstance = enemy getstance();
		if(isdefined(playerstance) && (playerstance == "prone" || playerstance == "crouch"))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: havetoolowtoattackenemy
	Namespace: warlordserverutils
	Checksum: 0xD70C1A6C
	Offset: 0x3F78
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function havetoolowtoattackenemy(entity)
{
	if(!isdefined(entity.lasttimetohavecrouchingenemy))
	{
		return false;
	}
	if((gettime() - entity.lasttimetohavecrouchingenemy) <= 4000)
	{
		return true;
	}
	entity.lasttimetohavecrouchingenemy = undefined;
	return false;
}

/*
	Name: setenemytoolowtoattack
	Namespace: warlordserverutils
	Checksum: 0xE8FC266E
	Offset: 0x3FD8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function setenemytoolowtoattack(entity)
{
	if(havetoolowtoattackenemy(entity))
	{
		return;
	}
	entity.lasttimetohavecrouchingenemy = gettime();
	entity.hascrouchingenemy = 1;
}

/*
	Name: computeattackerthreat
	Namespace: warlordserverutils
	Checksum: 0xDB8C660C
	Offset: 0x4030
	Size: 0x1C4
	Parameters: 2
	Flags: Linked
*/
function computeattackerthreat(entity, attackerinfo)
{
	if(attackerinfo.damage < 250)
	{
		return 0;
	}
	threat = 1;
	isattackerplayer = isplayer(attackerinfo.attacker);
	if(isattackerplayer)
	{
		threat = threat * 10;
	}
	distancefromattackersqr = distance2dsquared(entity.origin, attackerinfo.attacker.origin);
	normalizeddistancefromattacker = 0;
	if(isattackerplayer)
	{
		if(distancefromattackersqr <= (100 * 100))
		{
			threat = threat * 1000;
		}
		else
		{
			normalizeddistancefromattacker = distancefromattackersqr / (entity.engagemaxfalloffdist * entity.engagemaxfalloffdist);
			if(normalizeddistancefromattacker > 1)
			{
				normalizeddistancefromattacker = 1;
			}
			normalizeddistancefromattacker = 1 - normalizeddistancefromattacker;
		}
	}
	normalizeddamagefromattacker = attackerinfo.damage / 1000;
	if(normalizeddamagefromattacker > 1)
	{
		normalizeddamagefromattacker = 1;
	}
	threat = threat * ((normalizeddistancefromattacker * 0.65) + (normalizeddamagefromattacker * 0.35) * 100);
	return threat;
}

/*
	Name: shouldswitchtonewthreat
	Namespace: warlordserverutils
	Checksum: 0xFA89E166
	Offset: 0x4200
	Size: 0xB2
	Parameters: 3
	Flags: Linked
*/
function shouldswitchtonewthreat(entity, attacker, threat)
{
	if(entity.enemy === attacker)
	{
		return false;
	}
	if(!isdefined(entity.currentdangerousattacker))
	{
		return true;
	}
	if(entity.currentdangerousattacker.health <= 0)
	{
		return true;
	}
	if(entity.currentdangerousattacker == attacker)
	{
		return false;
	}
	if((gettime() - entity.lastdangerousattackertime) < 1)
	{
		return false;
	}
	return true;
}

/*
	Name: updateattackerslist
	Namespace: warlordserverutils
	Checksum: 0x23F4B590
	Offset: 0x42C0
	Size: 0x49C
	Parameters: 3
	Flags: Linked
*/
function updateattackerslist(entity, newattacker, damage)
{
	if(!isdefined(entity.knownattackers))
	{
		entity.knownattackers = [];
	}
	maxthreat = 0;
	var_a75ea562 = 0;
	for(i = 0; i < entity.knownattackers.size; i++)
	{
		attacker = entity.knownattackers[i].attacker;
		if(!isdefined(attacker) || !isentity(attacker) || attacker.health <= 0 || (gettime() - entity.knownattackers[i].lastattacktime) > 5000)
		{
			arrayremoveindex(entity.knownattackers, i);
			i--;
			continue;
		}
		entity.knownattackers[i].threat = computeattackerthreat(entity, entity.knownattackers[i]);
		if(entity.knownattackers[i].threat > maxthreat)
		{
			maxthreat = entity.knownattackers[i].threat;
			var_64e4a88a = entity.knownattackers[i];
		}
	}
	if(isdefined(newattacker))
	{
		for(i = 0; i < entity.knownattackers.size; i++)
		{
			if(entity.knownattackers[i].attacker == newattacker)
			{
				attackdata = entity.knownattackers[i];
				attackdata.lastattacktime = gettime();
				attackdata.damage = attackdata.damage + damage;
				break;
			}
		}
		if(!isdefined(attackdata))
		{
			attackdata = spawnstruct();
			attackdata.attacker = newattacker;
			attackdata.lastattacktime = gettime();
			attackdata.damage = damage;
			attackdata.threat = 0;
			if(!isdefined(entity.knownattackers))
			{
				entity.knownattackers = [];
			}
			else if(!isarray(entity.knownattackers))
			{
				entity.knownattackers = array(entity.knownattackers);
			}
			entity.knownattackers[entity.knownattackers.size] = attackdata;
		}
		attackdata.threat = computeattackerthreat(entity, attackdata);
		if(attackdata.threat > maxthreat)
		{
			maxthreat = attackdata.threat;
			var_64e4a88a = attackdata;
		}
	}
	if(isdefined(var_64e4a88a) && maxthreat > 0)
	{
		if(shouldswitchtonewthreat(entity, var_64e4a88a.attacker, maxthreat))
		{
			thread warlorddangerousenemyattack(entity, var_64e4a88a.attacker, maxthreat);
		}
	}
	checkifweshouldmove(entity);
}

/*
	Name: checkifweshouldmove
	Namespace: warlordserverutils
	Checksum: 0xBC7908AA
	Offset: 0x4768
	Size: 0x24C
	Parameters: 1
	Flags: Linked
*/
function checkifweshouldmove(entity)
{
	if(!isdefined(entity.knownattackers) || entity.knownattackers.size <= 1)
	{
		return;
	}
	var_a8e832eb = 0;
	if(atpreferedpoint(entity))
	{
		if(!isdefined(entity.var_7e5dd3e4) || (gettime() - entity.var_7e5dd3e4) < 1)
		{
			return;
		}
		var_a8e832eb = 1;
	}
	if(!var_a8e832eb)
	{
		if(isdefined(entity.pathgoalpos))
		{
			if(distance2dsquared(entity.pathgoalpos, entity.origin) < (36 * 36) && (abs(entity.pathgoalpos[2] - entity.origin[2])) < 45)
			{
				var_a8e832eb = 1;
			}
		}
	}
	if(var_a8e832eb)
	{
		if(havetoolowtoattackenemy(entity))
		{
			var_a94cf21a = 1;
		}
		else
		{
			var_a94cf21a = 0;
			foreach(attackerinfo in entity.knownattackers)
			{
				if(attackerinfo.damage > 200)
				{
					var_a94cf21a++;
				}
			}
		}
		if(var_a94cf21a > 1)
		{
			clearpreferedpoint(entity);
			entity.nextfindbetterpositiontime = 0;
		}
	}
}

/*
	Name: warlorddangerousenemyattack
	Namespace: warlordserverutils
	Checksum: 0xB8E19204
	Offset: 0x49C0
	Size: 0x14C
	Parameters: 3
	Flags: Linked
*/
function warlorddangerousenemyattack(entity, attacker, threat)
{
	entity endon(#"disconnect");
	entity endon(#"death");
	attacker endon(#"death");
	entity endon(#"hash_b160390f");
	entity notify(#"hash_beb03d5e");
	entity endon(#"hash_beb03d5e");
	entity.lastdangerousattackertime = gettime();
	entity.currentdangerousattacker = attacker;
	entity.currentmaxthreat = threat;
	/#
		warlorddebughelpers::printstate(0, (0, 1, 0), "");
	#/
	shoottime = getdvarfloat("warlordangryattack", 3);
	entity ai::shoot_at_target("normal", attacker, undefined, shoottime, undefined, 1);
	entity.currentdangerousattacker = undefined;
	/#
		warlorddebughelpers::printstate(0, (0, 0, 1), "");
	#/
}

/*
	Name: warlorddamageoverride
	Namespace: warlordserverutils
	Checksum: 0x81AB499E
	Offset: 0x4B18
	Size: 0x2F4
	Parameters: 15
	Flags: Linked
*/
function warlorddamageoverride(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, boneindex, modelindex, surfacetype, surfacenormal)
{
	entity = self;
	if(!isplayer(eattacker))
	{
		idamage = int(idamage * 0.05);
	}
	if(isdefined(smeansofdeath) && (smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_PROJECTILE_SPLASH" || smeansofdeath == "MOD_EXPLOSIVE" || smeansofdeath == "MOD_GRENADE"))
	{
		idamage = int(idamage * 0.25);
	}
	updateattackerslist(entity, eattacker, idamage);
	if(entity.health <= entity.damageheavystatehealth)
	{
		clientfield::set("warlord_damage_state", 2);
	}
	else
	{
		if(entity.health <= entity.damagestatehealth)
		{
			clientfield::set("warlord_damage_state", 1);
		}
		else
		{
			clientfield::set("warlord_damage_state", 0);
		}
	}
	if(!isdefined(entity.lastdamagetime))
	{
		entity.lastdamagetime = 0;
	}
	if((gettime() - entity.lastdamagetime) > 1500)
	{
		entity.accumilateddamage = idamage;
	}
	else
	{
		entity.accumilateddamage = entity.accumilateddamage + idamage;
	}
	warlord_hunt_max_accumilated_damage_var = getdvarint("warlordhuntdamage", 350);
	if(entity.accumilateddamage > getscaledforplayers(warlord_hunt_max_accumilated_damage_var, 1.5, 2, 2.5))
	{
		self.huntenemytime = gettime() + 15000;
	}
	entity.lastdamagetime = gettime();
	return idamage;
}

/*
	Name: warlordspawnsetup
	Namespace: warlordserverutils
	Checksum: 0x70401228
	Offset: 0x4E18
	Size: 0x236
	Parameters: 0
	Flags: Linked
*/
function warlordspawnsetup()
{
	entity = self;
	entity.var_568222a9 = 0;
	entity.isangryattack = 0;
	entity.var_2ac908f2 = 0;
	entity.lastdangerousattackertime = 0;
	entity.currentmaxthreat = 0;
	entity.ignorerunandgundist = 1;
	entity.combatmode = "no_cover";
	aiutility::addaioverridedamagecallback(entity, &warlorddamageoverride);
	entity.health = int(getscaledforplayers(entity.health, 2, 2.5, 3));
	entity.fullhealth = entity.health;
	entity.damagestatehealth = int(entity.fullhealth * 0.5);
	entity.damageheavystatehealth = int(entity.fullhealth * 0.25);
	entity warlord_projectile_watcher();
	clientfield::set("warlord_damage_state", 0);
	clientfield::set("warlord_lights_state", 1);
	switch(entity.classname)
	{
		case "actor_spawner_bo3_warlord_enemy_hvt":
		{
			clientfield::set("warlord_type", 2);
			break;
		}
		default:
		{
			clientfield::set("warlord_type", 1);
			break;
		}
	}
}

/*
	Name: warlord_projectile_watcher
	Namespace: warlordserverutils
	Checksum: 0xEFBFE8FE
	Offset: 0x5058
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function warlord_projectile_watcher()
{
	if(!isdefined(self.missile_repulsor))
	{
		self.missile_repulsor = missile_createrepulsorent(self, 40000, 256, 1);
	}
	self thread repulsor_fx();
}

/*
	Name: remove_repulsor
	Namespace: warlordserverutils
	Checksum: 0xBA2D75E4
	Offset: 0x50B8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function remove_repulsor()
{
	self endon(#"death");
	if(isdefined(self.missile_repulsor))
	{
		missile_deleteattractor(self.missile_repulsor);
		self.missile_repulsor = undefined;
	}
	wait(0.5);
	if(isdefined(self))
	{
		self warlord_projectile_watcher();
	}
}

/*
	Name: repulsor_fx
	Namespace: warlordserverutils
	Checksum: 0x9B179A14
	Offset: 0x5128
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function repulsor_fx()
{
	self endon(#"death");
	self endon(#"killing_repulsor");
	while(true)
	{
		self util::waittill_any("projectile_applyattractor", "play_meleefx");
		playfxontag("vehicle/fx_quadtank_airburst", self, "tag_origin");
		playfxontag("vehicle/fx_quadtank_airburst_ground", self, "tag_origin");
		self playsound("wpn_trophy_alert");
		self thread remove_repulsor();
		self notify(#"killing_repulsor");
	}
}

/*
	Name: trigger_player_shock_fx
	Namespace: warlordserverutils
	Checksum: 0xCA21C26E
	Offset: 0x5200
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function trigger_player_shock_fx()
{
	if(!isdefined(self._player_shock_fx_quadtank_melee))
	{
		self._player_shock_fx_quadtank_melee = 0;
	}
	self._player_shock_fx_quadtank_melee = !self._player_shock_fx_quadtank_melee;
	self clientfield::set_to_player("player_shock_fx", self._player_shock_fx_quadtank_melee);
}

#namespace warlorddebughelpers;

/*
	Name: printstate
	Namespace: warlorddebughelpers
	Checksum: 0x90CAF4EC
	Offset: 0x5260
	Size: 0x274
	Parameters: 3
	Flags: Linked
*/
function printstate(state, color, string)
{
	/#
		if(getdvarint("") > 0)
		{
			if(!isdefined(string))
			{
				string = "";
			}
			if(!isdefined(state))
			{
				if(!isdefined(self) || !isdefined(self.lastmessage) || self.lastmessage != string)
				{
					self.lastmessage = string;
					printtoprightln(string + gettime(), color, -1);
				}
				return;
			}
			if(state == 0)
			{
				printtoprightln(("" + string) + gettime(), color, -1);
			}
			else
			{
				if(state == 1)
				{
					printtoprightln(("" + string) + gettime(), color, -1);
				}
				else
				{
					if(state == 2)
					{
						printtoprightln(("" + string) + gettime(), color, -1);
					}
					else
					{
						if(state == 3)
						{
							printtoprightln(("" + string) + gettime(), color, -1);
						}
						else
						{
							if(state == 4)
							{
								printtoprightln(("" + string) + gettime(), color, -1);
							}
							else
							{
								if(state == 5)
								{
									printtoprightln(("" + string) + gettime(), color, -1);
								}
								else if(state == 6)
								{
									printtoprightln(("" + string) + gettime(), color, -1);
								}
							}
						}
					}
				}
			}
		}
	#/
}

/*
	Name: trystate
	Namespace: warlorddebughelpers
	Checksum: 0x656E1237
	Offset: 0x54E0
	Size: 0x94
	Parameters: 3
	Flags: Linked
*/
function trystate(entity, state, bchecknew)
{
	/#
		if(getdvarint("") > 0)
		{
			if(!(isdefined(bchecknew) && isnewstate(entity, state)))
			{
				color = (1, 1, 1);
				entity printstate(state, color);
			}
		}
	#/
}

/*
	Name: setcurrentstate
	Namespace: warlorddebughelpers
	Checksum: 0x51C59591
	Offset: 0x5580
	Size: 0x118
	Parameters: 3
	Flags: Linked
*/
function setcurrentstate(entity, state, bcanupdate = 0)
{
	/#
		if(getdvarint("") > 0)
		{
			if(!isdefined(bcanupdate) || isnewstate(entity, state))
			{
				color = (0, 1, 0);
			}
			else
			{
				color = (0, 1, 1);
			}
			if(!isdefined(state))
			{
				color = (0, 0, 1);
				entity printstate(entity.currentstate, color, "");
			}
			entity printstate(state, color);
		}
	#/
	entity.currentstate = state;
}

/*
	Name: setstatefailed
	Namespace: warlorddebughelpers
	Checksum: 0x5896E1E2
	Offset: 0x56A0
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function setstatefailed(entity, state)
{
	/#
		if(getdvarint("") > 0)
		{
			color = (1, 1, 0);
			entity printstate(state, color);
		}
	#/
}

/*
	Name: isnewstate
	Namespace: warlorddebughelpers
	Checksum: 0xDB5AA654
	Offset: 0x5718
	Size: 0x7E
	Parameters: 2
	Flags: Linked
*/
function isnewstate(entity, state)
{
	bnewstate = 0;
	if(!isdefined(entity.currentstate))
	{
		bnewstate = 1;
	}
	else
	{
		if(!isdefined(state))
		{
			return 0;
		}
		if(entity.currentstate != state)
		{
			bnewstate = 1;
		}
	}
	return bnewstate;
}

