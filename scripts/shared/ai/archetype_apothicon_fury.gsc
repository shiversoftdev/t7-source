// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_apothicon_fury_interface;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_selector_table;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

class animationadjustmentinfoz 
{
	var adjustmentstarted;
	var readjustmentstarted;

	/*
		Name: constructor
		Namespace: animationadjustmentinfoz
		Checksum: 0xBC354E48
		Offset: 0x18D8
		Size: 0x1C
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
		adjustmentstarted = 0;
		readjustmentstarted = 0;
	}

	/*
		Name: destructor
		Namespace: animationadjustmentinfoz
		Checksum: 0x99EC1590
		Offset: 0x1900
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

}

class animationadjustmentinfoxy 
{
	var adjustmentstarted;

	/*
		Name: constructor
		Namespace: animationadjustmentinfoxy
		Checksum: 0xAF212837
		Offset: 0x19A0
		Size: 0x10
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
		adjustmentstarted = 0;
	}

	/*
		Name: destructor
		Namespace: animationadjustmentinfoxy
		Checksum: 0x99EC1590
		Offset: 0x19B8
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

}

class jukeinfo 
{

	/*
		Name: constructor
		Namespace: jukeinfo
		Checksum: 0x99EC1590
		Offset: 0x54E0
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: jukeinfo
		Checksum: 0x99EC1590
		Offset: 0x54F0
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

}

#namespace apothiconfurybehavior;

/*
	Name: init
	Namespace: apothiconfurybehavior
	Checksum: 0xEAE8CB7B
	Offset: 0xB08
	Size: 0x1B4
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initapothiconfurybehaviorsandasm();
	apothiconfuryinterface::registerapothiconfuryinterfaceattributes();
	spawner::add_archetype_spawn_function("apothicon_fury", &apothiconfuryblackboardinit);
	spawner::add_archetype_spawn_function("apothicon_fury", &zombie_utility::zombiespawnsetup);
	spawner::add_archetype_spawn_function("apothicon_fury", &apothiconfuryspawnsetup);
	if(ai::shouldregisterclientfieldforarchetype("apothicon_fury"))
	{
		clientfield::register("actor", "fury_fire_damage", 15000, getminbitcountfornum(7), "counter");
		clientfield::register("actor", "furious_level", 15000, 1, "int");
		clientfield::register("actor", "bamf_land", 15000, 1, "counter");
		clientfield::register("actor", "apothicon_fury_death", 15000, 2, "int");
		clientfield::register("actor", "juke_active", 15000, 1, "int");
	}
}

/*
	Name: initapothiconfurybehaviorsandasm
	Namespace: apothiconfurybehavior
	Checksum: 0xD5FDB009
	Offset: 0xCC8
	Size: 0x464
	Parameters: 0
	Flags: Linked, Private
*/
function private initapothiconfurybehaviorsandasm()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconCanJuke", &apothiconcanjuke);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconJukeInit", &apothiconjukeinit);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconPreemptiveJukeService", &apothiconpreemptivejukeservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconPreemptiveJukePending", &apothiconpreemptivejukepending);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconPreemptiveJukeDone", &apothiconpreemptivejukedone);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconMoveStart", &apothiconmovestart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconMoveUpdate", &apothiconmoveupdate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconCanMeleeAttack", &apothiconcanmeleeattack);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconShouldMeleeCondition", &apothiconshouldmeleecondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconCanBamf", &apothiconcanbamf);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconCanBamfAfterJuke", &apothiconcanbamfafterjuke);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconBamfInit", &apothiconbamfinit);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconShouldTauntAtPlayer", &apothiconshouldtauntatplayer);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconTauntAtPlayerEvent", &apothicontauntatplayerevent);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconFuriousModeInit", &apothiconfuriousmodeinit);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconKnockdownService", &apothiconknockdownservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconDeathStart", &apothicondeathstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("apothiconDeathTerminate", &apothicondeathterminate);
	animationstatenetwork::registeranimationmocomp("mocomp_teleport@apothicon_fury", &mocompapothiconfuryteleportinit, undefined, &mocompapothiconfuryteleportterminate);
	animationstatenetwork::registeranimationmocomp("mocomp_juke@apothicon_fury", &mocompapothiconfuryjukeinit, &mocompapothiconfuryjukeupdate, &mocompapothiconfuryjuketerminate);
	animationstatenetwork::registeranimationmocomp("mocomp_bamf@apothicon_fury", &mocompapothiconfurybamfinit, &mocompapothiconfurybamfupdate, &mocompapothiconfurybamfterminate);
	animationstatenetwork::registernotetrackhandlerfunction("start_effect", &apothiconbamfout);
	animationstatenetwork::registernotetrackhandlerfunction("end_effect", &apothiconbamfin);
	animationstatenetwork::registernotetrackhandlerfunction("bamf_land", &apothiconbamfland);
	animationstatenetwork::registernotetrackhandlerfunction("start_dissolve", &apothicondeathdissolve);
	animationstatenetwork::registernotetrackhandlerfunction("dissolved", &apothicondeathdissolved);
}

/*
	Name: apothiconfuryblackboardinit
	Namespace: apothiconfurybehavior
	Checksum: 0xBA9F0669
	Offset: 0x1138
	Size: 0x1FC
	Parameters: 0
	Flags: Linked, Private
*/
function private apothiconfuryblackboardinit()
{
	blackboard::createblackboardforentity(self);
	blackboard::registerblackboardattribute(self, "_locomotion_speed", "locomotion_speed_run", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_apothicon_bamf_distance", undefined, &getbamfmeleedistance);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_idgun_damage_direction", "back", &bb_idgungetdamagedirection);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_variant_type", 0, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	self aiutility::registerutilityblackboardattributes();
	ai::createinterfaceforentity(self);
	self.___archetypeonanimscriptedcallback = &apothiconfuryonanimscriptedcallback;
	/#
		self finalizetrackedblackboardattributes();
	#/
}

/*
	Name: apothiconfuryspawnsetup
	Namespace: apothiconfurybehavior
	Checksum: 0x3C5AFC7B
	Offset: 0x1340
	Size: 0x164
	Parameters: 0
	Flags: Linked, Private
*/
function private apothiconfuryspawnsetup()
{
	self.entityradius = 30;
	self.jukemaxdistance = 1500;
	self.updatesight = 0;
	self allowpitchangle(1);
	self setpitchorient();
	self pushactors(1);
	self.skipautoragdoll = 1;
	aiutility::addaioverridedamagecallback(self, &apothicondamagecallback);
	aiutility::addaioverridekilledcallback(self, &apothiconondeath);
	self.zigzag_distance_min = 300;
	self.zigzag_distance_max = 700;
	self.isfurious = 0;
	self.furiouslevel = 0;
	self.nextbamfmeleetime = gettime();
	self.nextjuketime = gettime();
	self.nextpreemptivejukeads = randomfloatrange(0.7, 0.95);
	blackboard::setblackboardattribute(self, "_variant_type", randomintrange(0, 3));
}

/*
	Name: apothiconfuryonanimscriptedcallback
	Namespace: apothiconfurybehavior
	Checksum: 0x989FEC2E
	Offset: 0x14B0
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private apothiconfuryonanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity apothiconfuryblackboardinit();
}

/*
	Name: apothicondeathdissolve
	Namespace: apothiconfurybehavior
	Checksum: 0x64760EC8
	Offset: 0x14F0
	Size: 0x132
	Parameters: 1
	Flags: Linked
*/
function apothicondeathdissolve(entity)
{
	if(entity.archetype != "apothicon_fury")
	{
		return;
	}
	a_zombies = getaiarchetypearray("zombie");
	a_filtered_zombies = array::filter(a_zombies, 0, &apothiconzombieeligibleforknockdown, entity, entity.origin);
	if(a_filtered_zombies.size > 0)
	{
		foreach(zombie in a_filtered_zombies)
		{
			apothiconknockdownzombie(entity, zombie);
		}
	}
}

/*
	Name: apothicondeathdissolved
	Namespace: apothiconfurybehavior
	Checksum: 0xE4AAA393
	Offset: 0x1630
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function apothicondeathdissolved(entity)
{
}

/*
	Name: mocompapothiconfuryteleportinit
	Namespace: apothiconfurybehavior
	Checksum: 0xE9349E80
	Offset: 0x1648
	Size: 0x188
	Parameters: 5
	Flags: Linked, Private
*/
function private mocompapothiconfuryteleportinit(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity orientmode("face angle", entity.angles[1]);
	entity setrepairpaths(0);
	locomotionspeed = blackboard::getblackboardattribute(entity, "_locomotion_speed");
	if(locomotionspeed == "locomotion_speed_walk")
	{
		rate = 1.6;
	}
	else
	{
		rate = 2;
	}
	entity asmsetanimationrate(rate);
	/#
		assert(isdefined(entity.traverseendnode));
	#/
	entity animmode("noclip", 0);
	entity notsolid();
	entity.blockingpain = 1;
	entity.usegoalanimweight = 1;
	entity.bgbignorefearinheadlights = 1;
}

/*
	Name: mocompapothiconfuryteleportterminate
	Namespace: apothiconfurybehavior
	Checksum: 0x13A9B20A
	Offset: 0x17D8
	Size: 0xF4
	Parameters: 5
	Flags: Linked, Private
*/
function private mocompapothiconfuryteleportterminate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	if(!isdefined(entity.traverseendnode))
	{
		return;
	}
	entity forceteleport(entity.traverseendnode.origin, entity.angles);
	entity asmsetanimationrate(1);
	entity show();
	entity solid();
	entity.blockingpain = 0;
	entity.usegoalanimweight = 0;
	entity.bgbignorefearinheadlights = 0;
}

/*
	Name: mocompapothiconfuryjukeinit
	Namespace: apothiconfurybehavior
	Checksum: 0x9589D02B
	Offset: 0x1A58
	Size: 0x824
	Parameters: 5
	Flags: Linked
*/
function mocompapothiconfuryjukeinit(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity.isjuking = 1;
	if(isdefined(entity.jukeinfo))
	{
		entity orientmode("face angle", entity.jukeinfo.jukestartangles);
	}
	else
	{
		entity orientmode("face angle", entity.angles[1]);
	}
	entity animmode("noclip", 1);
	entity.usegoalanimweight = 1;
	entity.blockingpain = 1;
	entity pushactors(0);
	entity.pushable = 0;
	movedeltavector = getmovedelta(mocompanim, 0, 1, entity);
	landpos = entity localtoworldcoords(movedeltavector);
	velocity = entity getvelocity();
	predictedpos = entity.origin + (velocity * 0.1);
	/#
		recordcircle(landpos, 8, (0, 0, 1), "", entity);
		record3dtext("" + distance(predictedpos, landpos), landpos, (0, 0, 1), "");
	#/
	landposonground = entity.jukeinfo.landposonground;
	heightdiff = landposonground[2] - landpos[2];
	/#
		recordcircle(landposonground, 8, (0, 1, 0), "", entity);
		recordline(landpos, landposonground, (0, 1, 0), "", entity);
	#/
	/#
		assert(animhasnotetrack(mocompanim, ""));
	#/
	starttime = getnotetracktimes(mocompanim, "start_effect")[0];
	vectortostarttime = getmovedelta(mocompanim, 0, starttime, entity);
	startpos = entity localtoworldcoords(vectortostarttime);
	/#
		assert(animhasnotetrack(mocompanim, ""));
	#/
	stoptime = getnotetracktimes(mocompanim, "end_effect")[0];
	vectortostoptime = getmovedelta(mocompanim, 0, stoptime, entity);
	stoppos = entity localtoworldcoords(vectortostoptime);
	/#
		recordsphere(startpos, 3, (0, 0, 1), "", entity);
		recordsphere(stoppos, 3, (0, 0, 1), "", entity);
		recordline(predictedpos, startpos, (0, 0, 1), "", entity);
		recordline(startpos, stoppos, (0, 0, 1), "", entity);
		recordline(stoppos, landpos, (0, 0, 1), "", entity);
	#/
	newstoppos = stoppos + (0, 0, heightdiff);
	/#
		recordline(startpos, newstoppos, (1, 1, 0), "", entity);
		recordline(newstoppos, landposonground, (1, 1, 0), "", entity);
		recordsphere(newstoppos, 3, (1, 1, 0), "", entity);
	#/
	entity.animationadjustmentinfoz = undefined;
	entity.animationadjustmentinfoz = new animationadjustmentinfoz();
	entity.animationadjustmentinfoz.starttime = starttime;
	entity.animationadjustmentinfoz.stoptime = stoptime;
	entity.animationadjustmentinfoz.enemy = entity.enemy;
	animlength = getanimlength(mocompanim) * 1000;
	starttime = starttime * animlength;
	stoptime = stoptime * animlength;
	starttime = floor(starttime / 50);
	stoptime = floor(stoptime / 50);
	adjustduration = stoptime - starttime;
	entity.animationadjustmentinfoz.stepsize = heightdiff / adjustduration;
	entity.animationadjustmentinfoz.landposonground = landposonground;
	/#
		if(heightdiff < 0)
		{
			record3dtext((((("" + distance(landpos, landposonground)) + "") + entity.animationadjustmentinfoz.stepsize) + "") + adjustduration, landposonground, (1, 0.5, 0), "");
		}
		else
		{
			record3dtext((((("" + distance(landpos, landposonground)) + "") + entity.animationadjustmentinfoz.stepsize) + "") + adjustduration, landposonground, (1, 0.5, 0), "");
		}
	#/
}

/*
	Name: mocompapothiconfuryjukeupdate
	Namespace: apothiconfurybehavior
	Checksum: 0x867838A
	Offset: 0x2288
	Size: 0x224
	Parameters: 5
	Flags: Linked
*/
function mocompapothiconfuryjukeupdate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	times = getnotetracktimes(mocompanim, "end_effect");
	if(times.size)
	{
		time = times[0];
	}
	animtime = entity getanimtime(mocompanim);
	if(!entity.animationadjustmentinfoz.adjustmentstarted)
	{
		if(animtime >= entity.animationadjustmentinfoz.starttime)
		{
			entity.animationadjustmentinfoz.adjustmentstarted = 1;
		}
	}
	if(entity.animationadjustmentinfoz.adjustmentstarted && animtime < entity.animationadjustmentinfoz.stoptime)
	{
		adjustedorigin = entity.origin + (0, 0, entity.animationadjustmentinfoz.stepsize);
		entity forceteleport(adjustedorigin, entity.angles);
	}
	else if(isdefined(entity.enemy))
	{
		entity orientmode("face direction", entity.enemy.origin - entity.origin);
	}
	/#
		recordcircle(entity.animationadjustmentinfoz.landposonground, 8, (0, 1, 0), "", entity);
	#/
}

/*
	Name: mocompapothiconfuryjuketerminate
	Namespace: apothiconfurybehavior
	Checksum: 0xA17E420B
	Offset: 0x24B8
	Size: 0x13C
	Parameters: 5
	Flags: Linked
*/
function mocompapothiconfuryjuketerminate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity.blockingpain = 0;
	entity solid();
	entity pushactors(1);
	entity.isjuking = 0;
	entity.usegoalanimweight = 0;
	entity.pushable = 1;
	entity.jukeinfo = undefined;
	/#
		recordcircle(entity.animationadjustmentinfoz.landposonground, 8, (0, 1, 0), "", entity);
	#/
	if(isdefined(entity.enemy))
	{
		entity orientmode("face direction", entity.enemy.origin - entity.origin);
	}
}

/*
	Name: runbamfreadjustmentanalysis
	Namespace: apothiconfurybehavior
	Checksum: 0x7CD58A24
	Offset: 0x2600
	Size: 0x9C0
	Parameters: 5
	Flags: Linked, Private
*/
function private runbamfreadjustmentanalysis(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	/#
		assert(isdefined(entity.animationadjustmentinfoz.adjustmentstarted) && entity.animationadjustmentinfoz.adjustmentstarted);
	#/
	if(isdefined(entity.animationadjustmentinfoz.readjustmentstarted) && entity.animationadjustmentinfoz.readjustmentstarted)
	{
		return;
	}
	readjustmentanimtime = 0.45;
	animtime = entity getanimtime(mocompanim);
	if(animtime >= readjustmentanimtime && entity.enemy === entity.animationadjustmentinfoz.enemy)
	{
		meleestartposition = entity.animationadjustmentinfoz.landposonground;
		if(isdefined(entity.enemy.last_valid_position))
		{
			meleeendposition = entity.enemy.last_valid_position;
		}
		else
		{
			meleeendposition = entity.enemy.origin;
			enemyforwarddir = anglestoforward(entity.enemy.angles);
			newmeleeendposition = meleeendposition + (enemyforwarddir * randomintrange(30, 50));
			newmeleeendposition = getclosestpointonnavmesh(newmeleeendposition, 20, 50);
			if(isdefined(newmeleeendposition))
			{
				meleeendposition = newmeleeendposition;
			}
		}
		if(distancesquared(meleestartposition, meleeendposition) < 1024)
		{
			return;
		}
		if(!util::within_fov(meleeendposition, entity.enemy.angles, entity.origin, 0.642))
		{
			return;
		}
		if(!util::within_fov(meleestartposition, entity.angles, meleeendposition, 0.642))
		{
			return;
		}
		if(!ispointonnavmesh(meleestartposition, entity))
		{
			return;
		}
		if(!ispointonnavmesh(meleeendposition, entity))
		{
			return;
		}
		if(!tracepassedonnavmesh(meleestartposition, meleeendposition, entity.entityradius))
		{
			return;
		}
		if(!entity findpath(meleestartposition, meleeendposition))
		{
			return;
		}
		landpos = entity.animationadjustmentinfoz.landposonground;
		/#
			recordcircle(meleeendposition, 8, (0, 1, 1), "", entity);
			recordcircle(landpos, 8, (0, 0, 1), "", entity);
		#/
		zdiff = landpos[2] - meleeendposition[2];
		tracestart = undefined;
		traceend = undefined;
		if(zdiff < 0)
		{
			traceoffsetabove = (zdiff * -1) + 30;
			tracestart = meleeendposition + (0, 0, traceoffsetabove);
			traceend = meleeendposition + (vectorscale((0, 0, -1), 70));
		}
		else
		{
			traceoffsetbelow = (zdiff * -1) - 30;
			tracestart = meleeendposition + vectorscale((0, 0, 1), 70);
			traceend = meleeendposition + (0, 0, traceoffsetbelow);
		}
		trace = groundtrace(tracestart, traceend, 0, entity, 1, 1);
		landposonground = trace["position"];
		landposonground = getclosestpointonnavmesh(landposonground, 100, 50);
		if(!isdefined(landposonground))
		{
			return;
		}
		/#
			recordcircle(landposonground, 8, (0, 1, 0), "", entity);
			recordline(landpos, landposonground, (0, 1, 0), "", entity);
		#/
		/#
			assert(isdefined(entity.animationadjustmentinfoz));
		#/
		starttime = readjustmentanimtime;
		stoptime = entity.animationadjustmentinfoz.stoptime;
		entity.animationadjustmentinfoz2 = new animationadjustmentinfoz();
		entity.animationadjustmentinfoz2.starttime = readjustmentanimtime;
		entity.animationadjustmentinfoz2.stoptime = stoptime;
		entity.animationadjustmentinfoz2.landposonground = landposonground;
		animlength = getanimlength(mocompanim) * 1000;
		starttime = starttime * animlength;
		stoptime = stoptime * animlength;
		starttime = floor(starttime / 50);
		stoptime = floor(stoptime / 50);
		adjustduration = stoptime - starttime;
		heightdiff = landposonground[2] - landpos[2];
		entity.animationadjustmentinfoz2.stepsize = heightdiff / adjustduration;
		/#
			if(heightdiff < 0)
			{
				record3dtext((("" + entity.animationadjustmentinfoz2.stepsize) + "") + adjustduration, landposonground, (1, 0.5, 0), "");
			}
			else
			{
				record3dtext((("" + entity.animationadjustmentinfoz2.stepsize) + "") + adjustduration, landposonground, (1, 0.5, 0), "");
			}
		#/
		meleeendposition = (meleeendposition[0], meleeendposition[1], landpos[2]);
		xydirection = vectornormalize(meleeendposition - landpos);
		xydistance = distance(meleeendposition, landpos);
		entity.animationadjustmentinfoxy = new animationadjustmentinfoxy();
		entity.animationadjustmentinfoxy.starttime = starttime;
		entity.animationadjustmentinfoxy.stoptime = stoptime;
		entity.animationadjustmentinfoxy.stepsize = xydistance / adjustduration;
		entity.animationadjustmentinfoxy.xydirection = xydirection;
		entity.animationadjustmentinfoxy.adjustmentstarted = 1;
		/#
			record3dtext(((("" + xydistance) + "") + entity.animationadjustmentinfoxy.stepsize) + "", meleeendposition, (0, 0, 1), "");
		#/
		entity.animationadjustmentinfoz.readjustmentstarted = 1;
	}
}

/*
	Name: mocompapothiconfurybamfinit
	Namespace: apothiconfurybehavior
	Checksum: 0x52BD3B23
	Offset: 0x2FC8
	Size: 0xA84
	Parameters: 5
	Flags: Linked
*/
function mocompapothiconfurybamfinit(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	/#
		assert(isdefined(entity.enemy));
	#/
	entity.animationadjustmentinfoz = undefined;
	entity.animationadjustmentinfoz2 = undefined;
	entity.animationadjustmentinfoxy = undefined;
	entity clearpath();
	entity pathmode("dont move");
	entity.blockingpain = 1;
	entity.usegoalanimweight = 1;
	self pushactors(0);
	entity.isbamfing = 1;
	entity.pushable = 0;
	anglestoenemy = (0, vectortoangles(entity.enemy.origin - entity.origin)[1], 0);
	entity forceteleport(entity.origin, anglestoenemy);
	entity orientmode("face angle", anglestoenemy[1]);
	entity animmode("noclip", 1);
	movedeltavector = getmovedelta(mocompanim, 0, 1, entity);
	landpos = entity localtoworldcoords(movedeltavector);
	/#
		recordcircle(entity.enemy.origin, 8, (0, 1, 1), "", entity);
		recordline(landpos, entity.enemy.origin, (0, 1, 1), "", entity);
		recordcircle(landpos, 8, (0, 0, 1), "", entity);
		record3dtext("" + distance(entity.origin, landpos), landpos, (0, 0, 1), "");
	#/
	zdiff = entity.origin[2] - entity.enemy.origin[2];
	tracestart = undefined;
	traceend = undefined;
	if(zdiff < 0)
	{
		traceoffsetabove = (zdiff * -1) + 30;
		tracestart = landpos + (0, 0, traceoffsetabove);
		traceend = landpos + (vectorscale((0, 0, -1), 70));
	}
	else
	{
		traceoffsetbelow = (zdiff * -1) - 30;
		tracestart = landpos + vectorscale((0, 0, 1), 70);
		traceend = landpos + (0, 0, traceoffsetbelow);
	}
	trace = groundtrace(tracestart, traceend, 0, entity, 1, 1);
	landposonground = trace["position"];
	landposonground = getclosestpointonnavmesh(landposonground, 100, 25);
	if(!isdefined(landposonground))
	{
		landposonground = entity.enemy.origin;
	}
	/#
		recordcircle(landposonground, 8, (0, 1, 0), "", entity);
		recordline(landpos, landposonground, (0, 1, 0), "", entity);
	#/
	heightdiff = landposonground[2] - landpos[2];
	/#
		assert(animhasnotetrack(mocompanim, ""));
	#/
	starttime = getnotetracktimes(mocompanim, "start_effect")[0];
	vectortostarttime = getmovedelta(mocompanim, 0, starttime, entity);
	startpos = entity localtoworldcoords(vectortostarttime);
	/#
		assert(animhasnotetrack(mocompanim, ""));
	#/
	stoptime = getnotetracktimes(mocompanim, "end_effect")[0];
	vectortostoptime = getmovedelta(mocompanim, 0, stoptime, entity);
	stoppos = entity localtoworldcoords(vectortostoptime);
	/#
		recordsphere(startpos, 3, (0, 0, 1), "", entity);
		recordsphere(stoppos, 3, (0, 0, 1), "", entity);
		recordline(entity.origin, startpos, (0, 0, 1), "", entity);
		recordline(startpos, stoppos, (0, 0, 1), "", entity);
		recordline(stoppos, landpos, (0, 0, 1), "", entity);
	#/
	newstoppos = stoppos + (0, 0, heightdiff);
	/#
		recordline(startpos, newstoppos, (0, 1, 0), "", entity);
		recordline(newstoppos, landposonground, (0, 1, 0), "", entity);
		recordsphere(newstoppos, 3, (0, 1, 0), "", entity);
	#/
	entity.animationadjustmentinfoz = new animationadjustmentinfoz();
	entity.animationadjustmentinfoz.starttime = starttime;
	entity.animationadjustmentinfoz.stoptime = stoptime;
	entity.animationadjustmentinfoz.enemy = entity.enemy;
	animlength = getanimlength(mocompanim) * 1000;
	starttime = starttime * animlength;
	stoptime = stoptime * animlength;
	starttime = floor(starttime / 50);
	stoptime = floor(stoptime / 50);
	adjustduration = stoptime - starttime;
	entity.animationadjustmentinfoz.stepsize = heightdiff / adjustduration;
	entity.animationadjustmentinfoz.landposonground = landposonground;
	/#
		if(heightdiff < 0)
		{
			record3dtext((((("" + distance(landpos, landposonground)) + "") + entity.animationadjustmentinfoz.stepsize) + "") + adjustduration, landposonground, (1, 0.5, 0), "");
		}
		else
		{
			record3dtext((((("" + distance(landpos, landposonground)) + "") + entity.animationadjustmentinfoz.stepsize) + "") + adjustduration, landposonground, (1, 0.5, 0), "");
		}
	#/
}

/*
	Name: mocompapothiconfurybamfupdate
	Namespace: apothiconfurybehavior
	Checksum: 0x40A8A313
	Offset: 0x3A58
	Size: 0x2B4
	Parameters: 5
	Flags: Linked
*/
function mocompapothiconfurybamfupdate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	/#
		assert(isdefined(entity.animationadjustmentinfoz));
	#/
	if(!isdefined(entity.enemy))
	{
		return;
	}
	animtime = entity getanimtime(mocompanim);
	if(!entity.animationadjustmentinfoz.adjustmentstarted)
	{
		if(animtime >= entity.animationadjustmentinfoz.starttime)
		{
			entity.animationadjustmentinfoz.adjustmentstarted = 1;
		}
	}
	if(entity.animationadjustmentinfoz.adjustmentstarted && animtime < entity.animationadjustmentinfoz.stoptime)
	{
		adjustedorigin = entity.origin + (0, 0, entity.animationadjustmentinfoz.stepsize);
		runbamfreadjustmentanalysis(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration);
		if(isdefined(entity.animationadjustmentinfoz.readjustmentstarted) && entity.animationadjustmentinfoz.readjustmentstarted)
		{
			if(isdefined(entity.animationadjustmentinfoz2))
			{
				adjustedorigin = adjustedorigin + (0, 0, entity.animationadjustmentinfoz2.stepsize);
			}
			if(isdefined(entity.animationadjustmentinfoxy))
			{
				adjustedorigin = adjustedorigin + (entity.animationadjustmentinfoxy.xydirection * entity.animationadjustmentinfoxy.stepsize);
			}
		}
		entity forceteleport(adjustedorigin, entity.angles);
	}
	else if(isdefined(entity.enemy))
	{
		entity orientmode("face direction", entity.enemy.origin - entity.origin);
	}
}

/*
	Name: mocompapothiconfurybamfterminate
	Namespace: apothiconfurybehavior
	Checksum: 0x2B9201A7
	Offset: 0x3D18
	Size: 0x1B4
	Parameters: 5
	Flags: Linked
*/
function mocompapothiconfurybamfterminate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity pathmode("move allowed");
	entity solid();
	entity show();
	entity.blockingpain = 0;
	entity.usegoalanimweight = 0;
	entity orientmode("face angle", entity.angles[1]);
	entity animmode("gravity");
	entity.isbamfing = 0;
	entity.pushable = 1;
	self pushactors(1);
	entity.jukeinfo = undefined;
	if(!ispointonnavmesh(entity.origin))
	{
		clamptonavmeshlocation = getclosestpointonnavmesh(entity.origin, 100, 25);
		if(isdefined(clamptonavmeshlocation))
		{
			entity forceteleport(clamptonavmeshlocation);
		}
	}
}

/*
	Name: apothiconcanmeleeattack
	Namespace: apothiconfurybehavior
	Checksum: 0x2BB21308
	Offset: 0x3ED8
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function apothiconcanmeleeattack(entity)
{
	return apothiconcanbamf(entity) || apothiconshouldmeleecondition(entity);
}

/*
	Name: apothiconshouldmeleecondition
	Namespace: apothiconfurybehavior
	Checksum: 0xA2BBA148
	Offset: 0x3F20
	Size: 0x164
	Parameters: 1
	Flags: Linked
*/
function apothiconshouldmeleecondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemyoverride) && isdefined(behaviortreeentity.enemyoverride[1]))
	{
		return false;
	}
	if(!isdefined(behaviortreeentity.enemy))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.marked_for_death))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.ignoremelee) && behaviortreeentity.ignoremelee)
	{
		return false;
	}
	if(distancesquared(behaviortreeentity.origin, behaviortreeentity.enemy.origin) > 10000)
	{
		return false;
	}
	yawtoenemy = angleclamp180(behaviortreeentity.angles[1] - (vectortoangles(behaviortreeentity.enemy.origin - behaviortreeentity.origin)[1]));
	if(abs(yawtoenemy) > 60)
	{
		return false;
	}
	return true;
}

/*
	Name: apothiconcanbamfafterjuke
	Namespace: apothiconfurybehavior
	Checksum: 0xAD513294
	Offset: 0x4090
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function apothiconcanbamfafterjuke(entity)
{
	return apothiconcanbamfinternal(entity);
}

/*
	Name: apothiconcanbamf
	Namespace: apothiconfurybehavior
	Checksum: 0x1FEA1B65
	Offset: 0x40C0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function apothiconcanbamf(entity)
{
	return apothiconcanbamfinternal(entity);
}

/*
	Name: apothiconcanbamfinternal
	Namespace: apothiconfurybehavior
	Checksum: 0x4EEF90DF
	Offset: 0x40F0
	Size: 0x4DA
	Parameters: 2
	Flags: Linked
*/
function apothiconcanbamfinternal(entity, bamfafterjuke = 0)
{
	if(!ai::getaiattribute(entity, "can_bamf"))
	{
		return false;
	}
	if(!isdefined(entity.enemy))
	{
		return false;
	}
	if(!isplayer(entity.enemy))
	{
		return false;
	}
	if(isdefined(entity.juking) && entity.juking)
	{
		return false;
	}
	if(isdefined(entity.isbamfing) && entity.isbamfing)
	{
		return false;
	}
	if(!bamfafterjuke)
	{
		if(gettime() < entity.nextbamfmeleetime)
		{
			return false;
		}
		jukeevents = blackboard::getblackboardevents("apothicon_fury_bamf");
		tooclosejukedistancesqr = 400 * 400;
		foreach(event in jukeevents)
		{
			if(distance2dsquared(entity.origin, event.data.origin) <= tooclosejukedistancesqr)
			{
				return false;
			}
		}
	}
	/#
		assert(isdefined(entity.enemy));
	#/
	enemyorigin = entity.enemy.origin;
	apothiconfurys = getaiarchetypearray("apothicon_fury");
	furiesnearplayer = 0;
	foreach(apothiconfury in apothiconfurys)
	{
		if(distancesquared(enemyorigin, apothiconfury.origin) <= 6400)
		{
			furiesnearplayer++;
		}
	}
	if(furiesnearplayer >= 4)
	{
		return false;
	}
	distancetoenemysq = distancesquared(enemyorigin, entity.origin);
	distanceminthresholdsq = 400 * 400;
	if(bamfafterjuke)
	{
		distanceminthresholdsq = 250 * 250;
	}
	if(distancetoenemysq > distanceminthresholdsq && distancetoenemysq < (750 * 750))
	{
		if(!util::within_fov(enemyorigin, entity.enemy.angles, entity.origin, 0.642))
		{
			return false;
		}
		if(!util::within_fov(entity.origin, entity.angles, enemyorigin, 0.642))
		{
			return false;
		}
		meleestartposition = entity.origin;
		meleeendposition = enemyorigin;
		if(!ispointonnavmesh(meleestartposition, entity))
		{
			return false;
		}
		if(!ispointonnavmesh(meleeendposition, entity))
		{
			return false;
		}
		if(!tracepassedonnavmesh(meleestartposition, meleeendposition, entity.entityradius))
		{
			return false;
		}
		if(!entity findpath(meleestartposition, meleeendposition))
		{
			return false;
		}
		return true;
	}
	return false;
}

/*
	Name: getbamfmeleedistance
	Namespace: apothiconfurybehavior
	Checksum: 0xC0E1F14E
	Offset: 0x45D8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function getbamfmeleedistance(entity)
{
	distancetoenemy = distance(self.enemy.origin, self.origin);
	return distancetoenemy;
}

/*
	Name: apothiconbamfinit
	Namespace: apothiconfurybehavior
	Checksum: 0x95FA6968
	Offset: 0x4628
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function apothiconbamfinit(entity)
{
	jukeinfo = spawnstruct();
	jukeinfo.origin = entity.origin;
	jukeinfo.entity = entity;
	blackboard::addblackboardevent("apothicon_fury_bamf", jukeinfo, 4500);
	if(isdefined(level.nextbamfmeleetimemin) && isdefined(level.nextbamfmeleetimemax))
	{
		entity.nextbamfmeleetime = gettime() + randomfloatrange(level.nextbamfmeleetimemin, level.nextbamfmeleetimemax);
	}
	else
	{
		entity.nextbamfmeleetime = gettime() + randomfloatrange(4500, 6000);
	}
}

/*
	Name: apothiconshouldtauntatplayer
	Namespace: apothiconfurybehavior
	Checksum: 0x37F2EEAD
	Offset: 0x4728
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function apothiconshouldtauntatplayer(entity)
{
	tauntevents = blackboard::getblackboardevents("apothicon_fury_taunt");
	if(isdefined(tauntevents) && tauntevents.size)
	{
		return false;
	}
	return true;
}

/*
	Name: apothicontauntatplayerevent
	Namespace: apothiconfurybehavior
	Checksum: 0xE69994ED
	Offset: 0x4780
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function apothicontauntatplayerevent(entity)
{
	jukeinfo = spawnstruct();
	jukeinfo.origin = entity.origin;
	jukeinfo.entity = entity;
	blackboard::addblackboardevent("apothicon_fury_taunt", jukeinfo, 9500);
}

/*
	Name: bb_idgungetdamagedirection
	Namespace: apothiconfurybehavior
	Checksum: 0x5D2BE2CC
	Offset: 0x4808
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function bb_idgungetdamagedirection()
{
	if(isdefined(self.damage_direction))
	{
		return self.damage_direction;
	}
	return self aiutility::bb_getdamagedirection();
}

/*
	Name: apothiconbamfland
	Namespace: apothiconfurybehavior
	Checksum: 0xC391199C
	Offset: 0x4840
	Size: 0x17C
	Parameters: 1
	Flags: Linked
*/
function apothiconbamfland(entity)
{
	if(entity.archetype != "apothicon_fury")
	{
		return;
	}
	if(isdefined(entity.enemy))
	{
		entity orientmode("face direction", entity.enemy.origin - entity.origin);
	}
	entity clientfield::increment("bamf_land");
	if(isdefined(entity.enemy) && isplayer(entity.enemy) && distancesquared(entity.enemy.origin, entity.origin) <= (250 * 250))
	{
		entity.enemy dodamage(25, entity.origin, entity, entity, undefined, "MOD_MELEE");
	}
	physicsexplosionsphere(entity.origin, 100, 15, 10);
}

/*
	Name: apothiconmovestart
	Namespace: apothiconfurybehavior
	Checksum: 0x15902495
	Offset: 0x49C8
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function apothiconmovestart(entity)
{
	entity.movetime = gettime();
	entity.moveorigin = entity.origin;
}

/*
	Name: apothiconmoveupdate
	Namespace: apothiconfurybehavior
	Checksum: 0xDCF170D
	Offset: 0x4A08
	Size: 0x138
	Parameters: 1
	Flags: Linked
*/
function apothiconmoveupdate(entity)
{
	if(isdefined(entity.move_anim_end_time) && gettime() >= entity.move_anim_end_time)
	{
		entity.move_anim_end_time = undefined;
		return;
	}
	if(!(isdefined(entity.missinglegs) && entity.missinglegs) && (gettime() - entity.movetime) > 1000)
	{
		distsq = distance2dsquared(entity.origin, entity.moveorigin);
		if(distsq < 144)
		{
			if(isdefined(entity.cant_move_cb))
			{
				entity [[entity.cant_move_cb]]();
			}
		}
		else
		{
			entity.cant_move = 0;
		}
		entity.movetime = gettime();
		entity.moveorigin = entity.origin;
	}
}

/*
	Name: apothiconknockdownservice
	Namespace: apothiconfurybehavior
	Checksum: 0xE5457C01
	Offset: 0x4B48
	Size: 0x20A
	Parameters: 1
	Flags: Linked
*/
function apothiconknockdownservice(entity)
{
	if(isdefined(entity.isjuking) && entity.isjuking)
	{
		return;
	}
	if(isdefined(entity.isbamfing) && entity.isbamfing)
	{
		return;
	}
	velocity = entity getvelocity();
	predict_time = 0.5;
	predicted_pos = entity.origin + (velocity * predict_time);
	move_dist_sq = distancesquared(predicted_pos, entity.origin);
	speed = move_dist_sq / predict_time;
	if(speed >= 10)
	{
		a_zombies = getaiarchetypearray("zombie");
		a_filtered_zombies = array::filter(a_zombies, 0, &apothiconzombieeligibleforknockdown, entity, predicted_pos);
		if(a_filtered_zombies.size > 0)
		{
			foreach(zombie in a_filtered_zombies)
			{
				apothiconknockdownzombie(entity, zombie);
			}
		}
	}
}

/*
	Name: apothiconzombieeligibleforknockdown
	Namespace: apothiconfurybehavior
	Checksum: 0x529E817E
	Offset: 0x4D60
	Size: 0x1D4
	Parameters: 3
	Flags: Linked, Private
*/
function private apothiconzombieeligibleforknockdown(zombie, thrasher, predicted_pos)
{
	if(zombie.knockdown === 1)
	{
		return false;
	}
	if(isdefined(zombie.missinglegs) && zombie.missinglegs)
	{
		return false;
	}
	knockdown_dist_sq = 2304;
	dist_sq = distancesquared(predicted_pos, zombie.origin);
	if(dist_sq > knockdown_dist_sq)
	{
		return false;
	}
	origin = thrasher.origin;
	facing_vec = anglestoforward(thrasher.angles);
	enemy_vec = zombie.origin - origin;
	enemy_yaw_vec = (enemy_vec[0], enemy_vec[1], 0);
	facing_yaw_vec = (facing_vec[0], facing_vec[1], 0);
	enemy_yaw_vec = vectornormalize(enemy_yaw_vec);
	facing_yaw_vec = vectornormalize(facing_yaw_vec);
	enemy_dot = vectordot(facing_yaw_vec, enemy_yaw_vec);
	if(enemy_dot < 0)
	{
		return false;
	}
	return true;
}

/*
	Name: apothiconknockdownzombie
	Namespace: apothiconfurybehavior
	Checksum: 0x9A05AA64
	Offset: 0x4F40
	Size: 0x2B4
	Parameters: 2
	Flags: Linked
*/
function apothiconknockdownzombie(entity, zombie)
{
	zombie.knockdown = 1;
	zombie.knockdown_type = "knockdown_shoved";
	zombie_to_thrasher = entity.origin - zombie.origin;
	zombie_to_thrasher_2d = vectornormalize((zombie_to_thrasher[0], zombie_to_thrasher[1], 0));
	zombie_forward = anglestoforward(zombie.angles);
	zombie_forward_2d = vectornormalize((zombie_forward[0], zombie_forward[1], 0));
	zombie_right = anglestoright(zombie.angles);
	zombie_right_2d = vectornormalize((zombie_right[0], zombie_right[1], 0));
	dot = vectordot(zombie_to_thrasher_2d, zombie_forward_2d);
	if(dot >= 0.5)
	{
		zombie.knockdown_direction = "front";
		zombie.getup_direction = "getup_back";
	}
	else
	{
		if(dot < 0.5 && dot > -0.5)
		{
			dot = vectordot(zombie_to_thrasher_2d, zombie_right_2d);
			if(dot > 0)
			{
				zombie.knockdown_direction = "right";
				if(math::cointoss())
				{
					zombie.getup_direction = "getup_back";
				}
				else
				{
					zombie.getup_direction = "getup_belly";
				}
			}
			else
			{
				zombie.knockdown_direction = "left";
				zombie.getup_direction = "getup_belly";
			}
		}
		else
		{
			zombie.knockdown_direction = "back";
			zombie.getup_direction = "getup_belly";
		}
	}
}

/*
	Name: apothiconshouldswitchtofuriousmode
	Namespace: apothiconfurybehavior
	Checksum: 0x2F7A1DA2
	Offset: 0x5200
	Size: 0x18C
	Parameters: 1
	Flags: Linked
*/
function apothiconshouldswitchtofuriousmode(entity)
{
	if(!ai::getaiattribute(entity, "can_be_furious"))
	{
		return false;
	}
	if(isdefined(entity.isfurious) && entity.isfurious)
	{
		return false;
	}
	apothiconfurys = getaiarchetypearray("apothicon_fury");
	count = 0;
	foreach(apothiconfury in apothiconfurys)
	{
		if(isdefined(apothiconfury.isfurious) && apothiconfury.isfurious)
		{
			count++;
		}
	}
	if(count >= 1)
	{
		return false;
	}
	furiousevents = blackboard::getblackboardevents("apothicon_furious_mode");
	if(!furiousevents.size && entity.furiouslevel >= 3)
	{
		return true;
	}
	return false;
}

/*
	Name: apothiconfuriousmodeinit
	Namespace: apothiconfurybehavior
	Checksum: 0xA45E8CB6
	Offset: 0x5398
	Size: 0x140
	Parameters: 1
	Flags: Linked
*/
function apothiconfuriousmodeinit(entity)
{
	if(!apothiconshouldswitchtofuriousmode(entity))
	{
		return;
	}
	furiousinfo = spawnstruct();
	furiousinfo.origin = entity.origin;
	furiousinfo.entity = entity;
	blackboard::addblackboardevent("apothicon_furious_mode", furiousinfo, randomintrange(5000, 7000));
	entity pushactors(0);
	entity.isfurious = 1;
	blackboard::setblackboardattribute(entity, "_locomotion_speed", "locomotion_speed_super_sprint");
	entity clientfield::set("furious_level", 1);
	entity.health = entity.health * 2;
}

/*
	Name: apothiconpreemptivejukeservice
	Namespace: apothiconfurybehavior
	Checksum: 0x7B68C4DF
	Offset: 0x5590
	Size: 0xF8
	Parameters: 1
	Flags: Linked
*/
function apothiconpreemptivejukeservice(entity)
{
	if(!(isdefined(entity.isfurious) && entity.isfurious))
	{
		return false;
	}
	if(isdefined(entity.nextjuketime) && entity.nextjuketime > gettime())
	{
		return false;
	}
	if(isdefined(entity.enemy))
	{
		if(!isplayer(entity.enemy))
		{
			return false;
		}
		if(entity.enemy playerads() < entity.nextpreemptivejukeads)
		{
			return false;
		}
	}
	if(apothiconcanjuke(entity))
	{
		entity.apothiconpreemptivejuke = 1;
	}
}

/*
	Name: apothiconpreemptivejukepending
	Namespace: apothiconfurybehavior
	Checksum: 0xAF69401
	Offset: 0x5690
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function apothiconpreemptivejukepending(entity)
{
	return isdefined(entity.apothiconpreemptivejuke) && entity.apothiconpreemptivejuke;
}

/*
	Name: apothiconpreemptivejukedone
	Namespace: apothiconfurybehavior
	Checksum: 0x4DCF272B
	Offset: 0x56C8
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function apothiconpreemptivejukedone(entity)
{
	entity.apothiconpreemptivejuke = 0;
}

/*
	Name: apothiconcanjuke
	Namespace: apothiconfurybehavior
	Checksum: 0x2052786D
	Offset: 0x56F0
	Size: 0x37A
	Parameters: 1
	Flags: Linked
*/
function apothiconcanjuke(entity)
{
	if(!ai::getaiattribute(entity, "can_juke"))
	{
		return false;
	}
	if(!isdefined(entity.enemy) || !isplayer(entity.enemy))
	{
		return false;
	}
	if(isdefined(entity.isjuking) && entity.isjuking)
	{
		return false;
	}
	if(isdefined(entity.apothiconpreemptivejuke) && entity.apothiconpreemptivejuke)
	{
		return true;
	}
	if(isdefined(entity.nextjuketime) && gettime() < entity.nextjuketime)
	{
		return false;
	}
	jukeevents = blackboard::getblackboardevents("apothicon_fury_juke");
	tooclosejukedistancesqr = 250 * 250;
	foreach(event in jukeevents)
	{
		if(distance2dsquared(entity.origin, event.data.origin) <= tooclosejukedistancesqr)
		{
			return false;
		}
	}
	if(distance2dsquared(entity.origin, entity.enemy.origin) < (250 * 250))
	{
		return false;
	}
	if(!util::within_fov(entity.enemy.origin, entity.enemy.angles, entity.origin, 0.642))
	{
		return false;
	}
	if(!util::within_fov(entity.origin, entity.angles, entity.enemy.origin, 0.642))
	{
		return false;
	}
	if(isdefined(entity.jukemaxdistance) && isdefined(entity.enemy))
	{
		maxdistsquared = entity.jukemaxdistance * entity.jukemaxdistance;
		if(distance2dsquared(entity.origin, entity.enemy.origin) > maxdistsquared)
		{
			return false;
		}
	}
	jukeinfo = calculatejukeinfo(entity);
	if(isdefined(jukeinfo))
	{
		return true;
	}
	return false;
}

/*
	Name: apothiconjukeinit
	Namespace: apothiconfurybehavior
	Checksum: 0x49F6C65E
	Offset: 0x5A78
	Size: 0x1DC
	Parameters: 1
	Flags: Linked
*/
function apothiconjukeinit(entity)
{
	jukeinfo = calculatejukeinfo(entity);
	/#
		assert(isdefined(jukeinfo));
	#/
	blackboard::setblackboardattribute(entity, "_juke_distance", jukeinfo.jukedistance);
	blackboard::setblackboardattribute(entity, "_juke_direction", jukeinfo.jukedirection);
	entity clearpath();
	entity notify(#"bhtn_action_notify", "apothicon_fury_juke");
	jukeinfo = spawnstruct();
	jukeinfo.origin = entity.origin;
	jukeinfo.entity = entity;
	blackboard::addblackboardevent("apothicon_fury_juke", jukeinfo, 6000);
	entity.nextpreemptivejukeads = randomfloatrange(0.6, 0.8);
	if(isdefined(level.nextjukemeleetimemin) && isdefined(level.nextjukemeleetimemax))
	{
		entity.nextjukemeleetime = gettime() + randomfloatrange(level.nextjukemeleetimemin, level.nextjukemeleetimemax);
	}
	else
	{
		entity.nextjuketime = gettime() + randomfloatrange(7000, 10000);
	}
}

/*
	Name: validatejuke
	Namespace: apothiconfurybehavior
	Checksum: 0x263B8263
	Offset: 0x5C60
	Size: 0x2E4
	Parameters: 3
	Flags: Linked
*/
function validatejuke(entity, entityradius, jukevector)
{
	velocity = entity getvelocity();
	predictedpos = entity.origin + (velocity * 0.1);
	jukelandpos = predictedpos + jukevector;
	if(!isdefined(jukelandpos))
	{
		return undefined;
	}
	tracestart = jukelandpos + vectorscale((0, 0, 1), 70);
	traceend = jukelandpos + (vectorscale((0, 0, -1), 70));
	trace = groundtrace(tracestart, traceend, 0, entity, 1, 1);
	landposonground = trace["position"];
	if(!isdefined(landposonground))
	{
		return undefined;
	}
	if(!ispointonnavmesh(landposonground))
	{
		return undefined;
	}
	/#
		recordline(entity.origin, predictedpos, (0, 1, 0), "", entity);
	#/
	/#
		recordsphere(jukelandpos, 2, (1, 0, 0), "", entity);
	#/
	/#
		recordline(predictedpos, jukelandpos, (1, 0, 0), "", entity);
	#/
	if(ispointonnavmesh(landposonground, entity.entityradius * 2.5) && tracepassedonnavmesh(predictedpos, landposonground, entity.entityradius))
	{
		if(!entity isposinclaimedlocation(landposonground) && entity maymovefrompointtopoint(predictedpos, landposonground, 0, 0))
		{
			/#
				recordsphere(landposonground, 2, (0, 1, 0), "", entity);
			#/
			/#
				recordline(predictedpos, landposonground, (0, 1, 0), "", entity);
			#/
			return landposonground;
		}
	}
	return undefined;
}

/*
	Name: getjukevector
	Namespace: apothiconfurybehavior
	Checksum: 0x5C33436
	Offset: 0x5F50
	Size: 0xB4
	Parameters: 2
	Flags: Linked, Private
*/
function private getjukevector(entity, jukeanimalias)
{
	jukeanim = entity animmappingsearch(istring(jukeanimalias));
	localdeltavector = getmovedelta(jukeanim, 0, 1, entity);
	endpoint = entity localtoworldcoords(localdeltavector);
	return endpoint - entity.origin;
}

/*
	Name: calculatejukeinfo
	Namespace: apothiconfurybehavior
	Checksum: 0x26F833FA
	Offset: 0x6010
	Size: 0x540
	Parameters: 1
	Flags: Linked, Private
*/
function private calculatejukeinfo(entity)
{
	if(isdefined(entity.jukeinfo))
	{
		return entity.jukeinfo;
	}
	directiontoenemy = vectornormalize(entity.enemy.origin - entity.origin);
	forwarddir = anglestoforward(entity.angles);
	possiblejukes = [];
	jukevaliddistancetype = [];
	entityradius = entity.entityradius;
	jukevector = getjukevector(entity, "anim_zombie_juke_left_long");
	landposonground = validatejuke(entity, entityradius, jukevector);
	if(isdefined(landposonground))
	{
		jukeinfo = new jukeinfo();
		jukeinfo.jukedirection = "left";
		jukeinfo.jukedistance = "long";
		jukeinfo.landposonground = landposonground;
		if(!isdefined(possiblejukes))
		{
			possiblejukes = [];
		}
		else if(!isarray(possiblejukes))
		{
			possiblejukes = array(possiblejukes);
		}
		possiblejukes[possiblejukes.size] = jukeinfo;
	}
	jukevector = getjukevector(entity, "anim_zombie_juke_right_long");
	landposonground = validatejuke(entity, entityradius, jukevector);
	if(isdefined(landposonground))
	{
		jukeinfo = new jukeinfo();
		jukeinfo.jukedirection = "right";
		jukeinfo.jukedistance = "long";
		jukeinfo.landposonground = landposonground;
		if(!isdefined(possiblejukes))
		{
			possiblejukes = [];
		}
		else if(!isarray(possiblejukes))
		{
			possiblejukes = array(possiblejukes);
		}
		possiblejukes[possiblejukes.size] = jukeinfo;
	}
	jukevector = getjukevector(entity, "anim_zombie_juke_left_front_long");
	landposonground = validatejuke(entity, entityradius, jukevector);
	if(isdefined(landposonground))
	{
		jukeinfo = new jukeinfo();
		jukeinfo.jukedirection = "left_front";
		jukeinfo.jukedistance = "long";
		jukeinfo.landposonground = landposonground;
		if(!isdefined(possiblejukes))
		{
			possiblejukes = [];
		}
		else if(!isarray(possiblejukes))
		{
			possiblejukes = array(possiblejukes);
		}
		possiblejukes[possiblejukes.size] = jukeinfo;
	}
	jukevector = getjukevector(entity, "anim_zombie_juke_right_front_long");
	landposonground = validatejuke(entity, entityradius, jukevector);
	if(isdefined(landposonground))
	{
		jukeinfo = new jukeinfo();
		jukeinfo.jukedirection = "right_front";
		jukeinfo.jukedistance = "long";
		jukeinfo.landposonground = landposonground;
		if(!isdefined(possiblejukes))
		{
			possiblejukes = [];
		}
		else if(!isarray(possiblejukes))
		{
			possiblejukes = array(possiblejukes);
		}
		possiblejukes[possiblejukes.size] = jukeinfo;
	}
	if(possiblejukes.size)
	{
		jukeinfo = array::random(possiblejukes);
		jukeinfo.jukestartangles = entity.angles;
		entity.lastjukeinfoupdatetime = gettime();
		entity.jukeinfo = jukeinfo;
		return jukeinfo;
	}
	return undefined;
}

/*
	Name: apothiconbamfout
	Namespace: apothiconfurybehavior
	Checksum: 0xA0A94412
	Offset: 0x6558
	Size: 0x182
	Parameters: 1
	Flags: Linked
*/
function apothiconbamfout(entity)
{
	if(entity.archetype != "apothicon_fury")
	{
		return;
	}
	entity ghost();
	entity notsolid();
	self clientfield::set("juke_active", 0);
	a_zombies = getaiarchetypearray("zombie");
	a_filtered_zombies = array::filter(a_zombies, 0, &apothiconzombieeligibleforknockdown, entity, entity.origin);
	if(a_filtered_zombies.size > 0)
	{
		foreach(zombie in a_filtered_zombies)
		{
			apothiconknockdownzombie(entity, zombie);
		}
	}
}

/*
	Name: apothiconbamfin
	Namespace: apothiconfurybehavior
	Checksum: 0xFE1494FB
	Offset: 0x66E8
	Size: 0x29A
	Parameters: 1
	Flags: Linked
*/
function apothiconbamfin(entity)
{
	if(entity.archetype != "apothicon_fury")
	{
		return;
	}
	if(isdefined(entity.traverseendnode))
	{
		entity forceteleport(entity.traverseendnode.origin, entity.angles);
		entity unlink();
		entity.istraveling = 0;
		entity notify(#"travel_complete");
		entity setrepairpaths(1);
		entity.blockingpain = 0;
		entity.usegoalanimweight = 0;
		entity.bgbignorefearinheadlights = 0;
		entity asmsetanimationrate(1);
		entity finishtraversal();
		entity animmode("gravity", 1);
	}
	entity show();
	entity solid();
	self clientfield::set("juke_active", 1);
	a_zombies = getaiarchetypearray("zombie");
	a_filtered_zombies = array::filter(a_zombies, 0, &apothiconzombieeligibleforknockdown, entity, entity.origin);
	if(a_filtered_zombies.size > 0)
	{
		foreach(zombie in a_filtered_zombies)
		{
			apothiconknockdownzombie(entity, zombie);
		}
	}
}

/*
	Name: apothicondeathstart
	Namespace: apothiconfurybehavior
	Checksum: 0xA5C82BB0
	Offset: 0x6990
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function apothicondeathstart(entity)
{
	entity setmodel("c_zom_dlc4_apothicon_fury_dissolve");
	entity clientfield::set("apothicon_fury_death", 2);
	entity notsolid();
}

/*
	Name: apothicondeathterminate
	Namespace: apothiconfurybehavior
	Checksum: 0xF2A9C16
	Offset: 0x6A00
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function apothicondeathterminate(entity)
{
}

/*
	Name: apothicondamageclientfieldupdate
	Namespace: apothiconfurybehavior
	Checksum: 0x9C467609
	Offset: 0x6A18
	Size: 0x21C
	Parameters: 2
	Flags: Linked
*/
function apothicondamageclientfieldupdate(entity, shitloc)
{
	increment = 0;
	if(isinarray(array("helmet", "head", "neck"), shitloc))
	{
		increment = 1;
	}
	else
	{
		if(isinarray(array("torso_upper", "torso_mid"), shitloc))
		{
			increment = 2;
		}
		else
		{
			if(isinarray(array("torso_lower"), shitloc))
			{
				increment = 3;
			}
			else
			{
				if(isinarray(array("right_arm_upper", "right_arm_lower", "right_hand", "gun"), shitloc))
				{
					increment = 4;
				}
				else
				{
					if(isinarray(array("left_arm_upper", "left_arm_lower", "left_hand"), shitloc))
					{
						increment = 5;
					}
					else
					{
						if(isinarray(array("left_leg_upper", "left_leg_lower", "left_foot"), shitloc))
						{
							increment = 7;
						}
						else
						{
							increment = 6;
						}
					}
				}
			}
		}
	}
	entity clientfield::increment("fury_fire_damage", increment);
}

/*
	Name: apothicondamagecallback
	Namespace: apothiconfurybehavior
	Checksum: 0xC3C3E5FA
	Offset: 0x6C40
	Size: 0x120
	Parameters: 13
	Flags: Linked
*/
function apothicondamagecallback(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname)
{
	if(!(isdefined(self.zombie_think_done) && self.zombie_think_done))
	{
		return 0;
	}
	if(isdefined(eattacker) && isplayer(eattacker) && isdefined(shitloc))
	{
		apothicondamageclientfieldupdate(self, shitloc);
	}
	if(isdefined(shitloc))
	{
		if(!(isdefined(self.isfurious) && self.isfurious))
		{
			self.furiouslevel = self.furiouslevel + 1;
		}
	}
	eattacker zombie_utility::show_hit_marker();
	return idamage;
}

/*
	Name: apothiconondeath
	Namespace: apothiconfurybehavior
	Checksum: 0xC2EE274F
	Offset: 0x6D68
	Size: 0x80
	Parameters: 8
	Flags: Linked
*/
function apothiconondeath(inflictor, attacker, damage, meansofdeath, weapon, dir, hitloc, offsettimes)
{
	self clientfield::set("apothicon_fury_death", 1);
	self notsolid();
	return damage;
}

#namespace apothiconfurybehaviorinterface;

/*
	Name: movespeedattributecallback
	Namespace: apothiconfurybehaviorinterface
	Checksum: 0xA8A8F42D
	Offset: 0x6DF0
	Size: 0x12A
	Parameters: 4
	Flags: Linked
*/
function movespeedattributecallback(entity, attribute, oldvalue, value)
{
	if(isdefined(entity.isfurious) && entity.isfurious)
	{
		return;
	}
	switch(value)
	{
		case "walk":
		{
			blackboard::setblackboardattribute(entity, "_locomotion_speed", "locomotion_speed_walk");
			break;
		}
		case "run":
		{
			blackboard::setblackboardattribute(entity, "_locomotion_speed", "locomotion_speed_run");
			break;
		}
		case "sprint":
		{
			blackboard::setblackboardattribute(entity, "_locomotion_speed", "locomotion_speed_sprint");
			break;
		}
		case "super_sprint":
		{
			blackboard::setblackboardattribute(entity, "_locomotion_speed", "locomotion_speed_super_sprint");
			break;
		}
		default:
		{
			break;
		}
	}
}

