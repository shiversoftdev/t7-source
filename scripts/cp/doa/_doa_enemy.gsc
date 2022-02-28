// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\doa\_doa_arena;
#using scripts\cp\doa\_doa_dev;
#using scripts\cp\doa\_doa_fx;
#using scripts\cp\doa\_doa_gibs;
#using scripts\cp\doa\_doa_hazard;
#using scripts\cp\doa\_doa_pickups;
#using scripts\cp\doa\_doa_player_utility;
#using scripts\cp\doa\_doa_round;
#using scripts\cp\doa\_doa_score;
#using scripts\cp\doa\_doa_utility;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");

#namespace doa_enemy;

/*
	Name: init
	Namespace: doa_enemy
	Checksum: 0x929EA01D
	Offset: 0xA98
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level registerdefaultnotetrackhandlerfunctions();
	level registerbehaviorscriptfunctions();
	level.doa.var_25eb370 = [];
}

/*
	Name: registerdefaultnotetrackhandlerfunctions
	Namespace: doa_enemy
	Checksum: 0x99EC1590
	Offset: 0xAE8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function registerdefaultnotetrackhandlerfunctions()
{
}

/*
	Name: registerbehaviorscriptfunctions
	Namespace: doa_enemy
	Checksum: 0xACA98E45
	Offset: 0xAF8
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function registerbehaviorscriptfunctions()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("doaUpdateToGoal", &function_a1761846);
	behaviortreenetworkutility::registerbehaviortreescriptapi("doaUpdateSilverbackGoal", &function_3209ead3);
	behaviortreenetworkutility::registerbehaviortreescriptapi("doaActorShouldMelee", &function_f31da0d1);
	behaviortreenetworkutility::registerbehaviortreescriptapi("doaActorShouldMove", &function_d597e3fc);
	behaviortreenetworkutility::registerbehaviortreescriptapi("doaSilverbackShouldMove", &function_323b0769);
	behaviortreenetworkutility::registerbehaviortreeaction("doaMeleeAction", &function_98fb0380, undefined, undefined);
	behaviortreenetworkutility::registerbehaviortreescriptapi("doawasKilledByTesla", &function_f8d04082);
	behaviortreenetworkutility::registerbehaviortreeaction("doaZombieMoveAction", undefined, undefined, undefined);
	behaviortreenetworkutility::registerbehaviortreeaction("doaZombieIdleAction", undefined, undefined, undefined);
	behaviortreenetworkutility::registerbehaviortreeaction("doaLocomotionDeathAction", &function_98fb0380, undefined, undefined);
	behaviortreenetworkutility::registerbehaviortreeaction("doavoidAction", undefined, undefined, undefined);
	behaviortreenetworkutility::registerbehaviortreeaction("zombieTraverseAction", &zombietraverseaction, undefined, &zombietraverseactionterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("doaZombieTraversalDoesAnimationExist", &function_599c952d);
	behaviortreenetworkutility::registerbehaviortreeaction("doaSpecialTraverseAction", &function_34a5b8e4, undefined, &function_f821465d);
	animationstatenetwork::registeranimationmocomp("mocomp_doa_special_traversal", &function_e57c0c7b, undefined, &function_c97089da);
}

/*
	Name: function_f8d04082
	Namespace: doa_enemy
	Checksum: 0x973B01D4
	Offset: 0xD88
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function function_f8d04082(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.tesla_death) && behaviortreeentity.tesla_death)
	{
		return true;
	}
	return false;
}

/*
	Name: function_599c952d
	Namespace: doa_enemy
	Checksum: 0x520B75BE
	Offset: 0xDD0
	Size: 0xA2
	Parameters: 1
	Flags: Linked, Private
*/
function private function_599c952d(entity)
{
	if(entity.missinglegs === 1)
	{
		animationresults = entity astsearch(istring("traverse_legless@zombie"));
	}
	else
	{
		animationresults = entity astsearch(istring("traverse@zombie"));
	}
	if(isdefined(animationresults["animation"]))
	{
		return true;
	}
	return false;
}

/*
	Name: function_34a5b8e4
	Namespace: doa_enemy
	Checksum: 0xB21ADD4E
	Offset: 0xE80
	Size: 0x60
	Parameters: 2
	Flags: Linked, Private
*/
function private function_34a5b8e4(entity, asmstatename)
{
	animationstatenetworkutility::requeststate(entity, asmstatename);
	entity ghost();
	entity notsolid();
	return 5;
}

/*
	Name: function_f821465d
	Namespace: doa_enemy
	Checksum: 0xA285EA83
	Offset: 0xEE8
	Size: 0x48
	Parameters: 2
	Flags: Linked, Private
*/
function private function_f821465d(entity, asmstatename)
{
	entity show();
	entity solid();
	return 4;
}

/*
	Name: function_e57c0c7b
	Namespace: doa_enemy
	Checksum: 0x9753F87C
	Offset: 0xF38
	Size: 0x1D0
	Parameters: 5
	Flags: Linked, Private
*/
function private function_e57c0c7b(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity orientmode("face angle", entity.angles[1]);
	entity setrepairpaths(0);
	locomotionspeed = blackboard::getblackboardattribute(entity, "_locomotion_speed");
	if(locomotionspeed == "locomotion_speed_walk")
	{
		rate = 1;
	}
	else
	{
		if(locomotionspeed == "locomotion_speed_run")
		{
			rate = 2;
		}
		else
		{
			rate = 3;
		}
	}
	entity asmsetanimationrate(rate);
	if(entity haspath())
	{
		entity.var_51ea7126 = entity.pathgoalpos;
	}
	/#
		assert(isdefined(entity.traverseendnode));
	#/
	entity forceteleport(entity.traverseendnode.origin, entity.angles);
	entity animmode("noclip", 0);
	entity.blockingpain = 1;
}

/*
	Name: function_c97089da
	Namespace: doa_enemy
	Checksum: 0x1BABBAF1
	Offset: 0x1110
	Size: 0xBC
	Parameters: 5
	Flags: Linked, Private
*/
function private function_c97089da(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity.blockingpain = 0;
	entity setrepairpaths(1);
	if(isdefined(entity.var_51ea7126))
	{
		entity setgoal(entity.var_51ea7126);
	}
	entity asmsetanimationrate(1);
	entity finishtraversal();
}

/*
	Name: zombietraverseaction
	Namespace: doa_enemy
	Checksum: 0x8FF40EC5
	Offset: 0x11D8
	Size: 0x30
	Parameters: 2
	Flags: Linked
*/
function zombietraverseaction(behaviortreeentity, asmstatename)
{
	aiutility::traverseactionstart(behaviortreeentity, asmstatename);
	return 5;
}

/*
	Name: zombietraverseactionterminate
	Namespace: doa_enemy
	Checksum: 0xA23F4D61
	Offset: 0x1210
	Size: 0x18
	Parameters: 2
	Flags: Linked
*/
function zombietraverseactionterminate(behaviortreeentity, asmstatename)
{
	return 4;
}

/*
	Name: notetrackmeleefire
	Namespace: doa_enemy
	Checksum: 0xDED4B7F6
	Offset: 0x1230
	Size: 0x2C
	Parameters: 2
	Flags: None
*/
function notetrackmeleefire(animationentity, asmstatename)
{
	animationentity melee();
}

/*
	Name: function_98fb0380
	Namespace: doa_enemy
	Checksum: 0xA19186C8
	Offset: 0x1268
	Size: 0x30
	Parameters: 2
	Flags: Linked
*/
function function_98fb0380(behaviortreeentity, asmstatename)
{
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	return 5;
}

/*
	Name: function_d30fe558
	Namespace: doa_enemy
	Checksum: 0x92963F34
	Offset: 0x12A0
	Size: 0x1AC
	Parameters: 2
	Flags: Linked
*/
function function_d30fe558(origin, force = 0)
{
	if(!isdefined(self) || !isdefined(origin))
	{
		return;
	}
	if(!isdefined(self.var_99315107))
	{
		self.var_99315107 = 0;
	}
	if(force)
	{
		self.var_99315107 = 0;
	}
	time = gettime();
	var_bea0505e = time > self.var_99315107;
	distsq = distancesquared(self.origin, origin);
	if(distsq < (128 * 128))
	{
		var_bea0505e = 1;
	}
	if(var_bea0505e)
	{
		self setgoal(origin, 1);
		frac = math::clamp(distsq / (1000 * 1000), 0, 1);
		if(isdefined(self.zombie_move_speed))
		{
			if(self.zombie_move_speed == "walk" || (isdefined(self.missinglegs) && self.missinglegs))
			{
				frac = frac + 0.2;
			}
		}
		self.var_99315107 = time + (int(frac * 1600));
	}
}

/*
	Name: function_b0edb6ef
	Namespace: doa_enemy
	Checksum: 0xF61E3088
	Offset: 0x1458
	Size: 0x5CC
	Parameters: 1
	Flags: Linked
*/
function function_b0edb6ef(var_12ebe63d)
{
	aiprofile_beginentry("zombieUpdateZigZagGoal");
	shouldrepath = 0;
	if(!shouldrepath && isdefined(self.enemy))
	{
		if(!isdefined(self.nextgoalupdate) || self.nextgoalupdate <= gettime())
		{
			shouldrepath = 1;
		}
		else
		{
			if(distancesquared(self.origin, self.enemy.origin) <= (200 * 200))
			{
				shouldrepath = 1;
			}
			else if(isdefined(self.pathgoalpos))
			{
				distancetogoalsqr = distancesquared(self.origin, self.pathgoalpos);
				shouldrepath = distancetogoalsqr < (72 * 72);
			}
		}
	}
	if(isdefined(self.keep_moving) && self.keep_moving)
	{
		if(gettime() > self.keep_moving_time)
		{
			self.keep_moving = 0;
		}
	}
	if(shouldrepath)
	{
		goalpos = var_12ebe63d;
		self setgoal(goalpos);
		if(distancesquared(self.origin, goalpos) > (200 * 200))
		{
			self.keep_moving = 1;
			self.keep_moving_time = gettime() + 250;
			path = self calcapproximatepathtoposition(goalpos, 0);
			/#
				if(getdvarint(""))
				{
					for(index = 1; index < path.size; index++)
					{
						recordline(path[index - 1], path[index], (1, 0.5, 0), "", self);
					}
				}
			#/
			if(isdefined(level._zombiezigzagdistancemin) && isdefined(level._zombiezigzagdistancemax))
			{
				min = level._zombiezigzagdistancemin;
				max = level._zombiezigzagdistancemax;
			}
			else
			{
				min = 600;
				max = 900;
			}
			deviationdistance = randomintrange(min, max);
			segmentlength = 0;
			for(index = 1; index < path.size; index++)
			{
				currentseglength = distance(path[index - 1], path[index]);
				if((segmentlength + currentseglength) > deviationdistance)
				{
					remaininglength = deviationdistance - segmentlength;
					seedposition = (path[index - 1]) + ((vectornormalize(path[index] - (path[index - 1]))) * remaininglength);
					/#
						recordcircle(seedposition, 2, (1, 0.5, 0), "", self);
					#/
					innerzigzagradius = 0;
					outerzigzagradius = 200;
					queryresult = positionquery_source_navigation(seedposition, innerzigzagradius, outerzigzagradius, 0.5 * 72, 16, self, 16);
					positionquery_filter_inclaimedlocation(queryresult, self);
					if(queryresult.data.size > 0)
					{
						point = queryresult.data[randomint(queryresult.data.size)];
						self function_d30fe558(point.origin, 1);
					}
					break;
				}
				segmentlength = segmentlength + currentseglength;
			}
		}
		if(isdefined(level._zombiezigzagtimemin) && isdefined(level._zombiezigzagtimemax))
		{
			mintime = level._zombiezigzagtimemin;
			maxtime = level._zombiezigzagtimemax;
		}
		else
		{
			mintime = 3500;
			maxtime = 5500;
		}
		self.nextgoalupdate = gettime() + randomintrange(mintime, maxtime);
	}
	aiprofile_endentry();
}

/*
	Name: function_a1761846
	Namespace: doa_enemy
	Checksum: 0x8CC664EA
	Offset: 0x1A30
	Size: 0x7B4
	Parameters: 1
	Flags: Linked
*/
function function_a1761846(behaviortreeentity)
{
	if(level flag::get("doa_game_is_over"))
	{
		behaviortreeentity function_d30fe558(behaviortreeentity.origin);
		return true;
	}
	if(isdefined(behaviortreeentity.doa) && behaviortreeentity.doa.stunned != 0)
	{
		if(!(isdefined(behaviortreeentity.doa.var_da2f5272) && behaviortreeentity.doa.var_da2f5272))
		{
			behaviortreeentity function_d30fe558(behaviortreeentity.doa.original_origin, behaviortreeentity.doa.stunned == 1);
			behaviortreeentity.doa.stunned = 2;
		}
		else
		{
			behaviortreeentity function_d30fe558(behaviortreeentity.origin);
		}
		return true;
	}
	if(isdefined(behaviortreeentity.var_8f12ed02))
	{
		behaviortreeentity function_d30fe558(behaviortreeentity.var_8f12ed02);
		return true;
	}
	if(!(isdefined(behaviortreeentity.var_2d8174e3) && behaviortreeentity.var_2d8174e3))
	{
		poi = doa_utility::getclosestpoi(behaviortreeentity.origin, level.doa.rules.var_187f2874);
		if(isdefined(poi))
		{
			behaviortreeentity.doa.poi = poi;
			if(isdefined(poi.var_111c7bbb))
			{
				behaviortreeentity function_d30fe558(poi.var_111c7bbb);
			}
			else
			{
				behaviortreeentity function_d30fe558(poi.origin);
			}
			return true;
		}
	}
	if(isdefined(behaviortreeentity.enemy))
	{
		time = gettime();
		if(!isdefined(behaviortreeentity.var_dc3adfc7))
		{
			behaviortreeentity.var_dc3adfc7 = 0;
		}
		if(time > behaviortreeentity.var_dc3adfc7)
		{
			behaviortreeentity.var_dc3adfc7 = time + 1500;
			if(behaviortreeentity.team == "axis")
			{
				validtargets = arraycombine(getaiteamarray("team3"), namespace_831a4a7c::function_5eb6e4d1(), 0, 0);
				if(isdefined(level.doa.var_1332e37a) && level.doa.var_1332e37a.size)
				{
					validtargets = arraycombine(validtargets, level.doa.var_1332e37a, 0, 0);
				}
				closest = arraygetclosest(behaviortreeentity.origin, validtargets);
			}
			else if(behaviortreeentity.team == "allies")
			{
				closest = arraygetclosest(behaviortreeentity.origin, getaiteamarray("axis"));
			}
			if(isdefined(closest) && behaviortreeentity.enemy != closest)
			{
				if(namespace_831a4a7c::function_5eb6e4d1().size > 1 && isplayer(closest))
				{
					behaviortreeentity.favoriteenemy = closest;
					behaviortreeentity setpersonalthreatbias(closest, 5000, 1.5);
				}
				else
				{
					distsq = distancesquared(closest.origin, self.origin);
					if(distsq <= (128 * 128))
					{
						behaviortreeentity.favoriteenemy = closest;
					}
				}
			}
		}
		origin = behaviortreeentity function_69b8254();
		point = getclosestpointonnavmesh(origin, 20, 16);
		if(isdefined(point))
		{
			behaviortreeentity.lastknownenemypos = origin;
			if(getdvarint("scr_doa_zigzag_enabled", 0))
			{
				behaviortreeentity function_b0edb6ef(behaviortreeentity.lastknownenemypos);
			}
		}
		else
		{
			point = getclosestpointonnavmesh(origin, 40, 8);
			if(isdefined(point))
			{
				behaviortreeentity.lastknownenemypos = point;
				origin = point;
			}
			else if(isdefined(behaviortreeentity.lastknownenemypos))
			{
				origin = behaviortreeentity.lastknownenemypos;
			}
		}
		behaviortreeentity function_d30fe558(origin);
		return true;
	}
	if(behaviortreeentity.team == "team3")
	{
		return false;
	}
	players = getplayers();
	foreach(player in players)
	{
		if(!isdefined(player.doa))
		{
			continue;
		}
		if(!isalive(player))
		{
			continue;
		}
		behaviortreeentity.favoriteenemy = player;
		behaviortreeentity function_d30fe558(behaviortreeentity.favoriteenemy.origin, 1);
		return true;
	}
	if(isdefined(behaviortreeentity.lastknownenemypos))
	{
		behaviortreeentity function_d30fe558(behaviortreeentity.lastknownenemypos);
		return true;
	}
	return false;
}

/*
	Name: function_3209ead3
	Namespace: doa_enemy
	Checksum: 0x5CE536D7
	Offset: 0x21F0
	Size: 0x212
	Parameters: 1
	Flags: Linked
*/
function function_3209ead3(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.var_88168473) && behaviortreeentity.var_88168473)
	{
		return false;
	}
	if(isdefined(behaviortreeentity.enemy))
	{
		behaviortreeentity.favoriteenemy = behaviortreeentity.enemy;
		origin = behaviortreeentity function_69b8254();
		point = getclosestpointonnavmesh(origin, 20, 16);
		if(isdefined(point))
		{
			behaviortreeentity.lastknownenemypos = origin;
		}
		else
		{
			point = getclosestpointonnavmesh(origin, 40, 8);
			if(isdefined(point))
			{
				behaviortreeentity.lastknownenemypos = point;
				origin = point;
			}
			else if(isdefined(behaviortreeentity.lastknownenemypos))
			{
				origin = behaviortreeentity.lastknownenemypos;
			}
		}
		behaviortreeentity function_d30fe558(origin);
		return true;
	}
	if(isdefined(behaviortreeentity.var_f4a5c4fe))
	{
		point = getclosestpointonnavmesh(behaviortreeentity.var_f4a5c4fe, 20, 16);
		if(isdefined(point))
		{
			behaviortreeentity setgoal(behaviortreeentity.var_f4a5c4fe, 1);
		}
		else
		{
			behaviortreeentity setgoal(behaviortreeentity.origin, 1);
		}
		behaviortreeentity.var_f4a5c4fe = undefined;
		return true;
	}
	return false;
}

/*
	Name: function_f5ef629b
	Namespace: doa_enemy
	Checksum: 0x215A1A8E
	Offset: 0x2410
	Size: 0x100
	Parameters: 0
	Flags: Linked, Private
*/
function private function_f5ef629b()
{
	self endon(#"death");
	self endon(#"hash_d96c599c");
	while(level flag::get("doa_round_spawning"))
	{
		wait(1);
	}
	if(!isdefined(self.zombie_move_speed))
	{
		self.zombie_move_speed = "run";
	}
	while(true)
	{
		left = doa_utility::function_b99d78c7();
		if(left <= 5)
		{
			if(self.zombie_move_speed == "walk")
			{
				self.zombie_move_speed = "run";
			}
			else
			{
				if(self.zombie_move_speed == "run")
				{
					self.zombie_move_speed = "sprint";
				}
				else
				{
					return;
				}
			}
		}
		wait(randomfloatrange(1, 4));
	}
}

/*
	Name: updatespeed
	Namespace: doa_enemy
	Checksum: 0x343C22D6
	Offset: 0x2518
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function updatespeed()
{
	self thread function_f5ef629b();
	if(isdefined(self.crawlonly))
	{
		self.zombie_move_speed = "crawl";
		return;
	}
	if(isdefined(self.walkonly))
	{
		self.zombie_move_speed = "walk";
		return;
	}
	if(isdefined(self.runonly))
	{
		self.zombie_move_speed = "run";
		return;
	}
	if(isdefined(self.sprintonly))
	{
		self.zombie_move_speed = "sprint";
		return;
	}
	rand = randomintrange(level.doa.zombie_move_speed - 25, level.doa.zombie_move_speed + 20);
	if(rand <= 40)
	{
		self.zombie_move_speed = "walk";
	}
	else
	{
		if(rand <= 70)
		{
			self.zombie_move_speed = "run";
		}
		else
		{
			self.zombie_move_speed = "sprint";
		}
	}
}

/*
	Name: function_d597e3fc
	Namespace: doa_enemy
	Checksum: 0x40117BD1
	Offset: 0x2658
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function function_d597e3fc(behaviortreeentity)
{
	return behaviortreeentity haspath();
}

/*
	Name: function_323b0769
	Namespace: doa_enemy
	Checksum: 0xBD629D4C
	Offset: 0x2688
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function function_323b0769(behaviortreeentity)
{
	return behaviortreeentity haspath();
}

/*
	Name: function_69b8254
	Namespace: doa_enemy
	Checksum: 0x443A07E
	Offset: 0x26B8
	Size: 0x122
	Parameters: 0
	Flags: Linked
*/
function function_69b8254()
{
	if(isdefined(self.enemy))
	{
		if(isdefined(self.enemy.doa) && isdefined(self.enemy.doa.vehicle))
		{
			self.lastknownenemypos = self.enemy.doa.vehicle.origin;
			if(!isdefined(self.lastknownenemypos) && isdefined(self.enemy.doa.vehicle.groundpos))
			{
				self.lastknownenemypos = self.enemy.doa.vehicle.groundpos;
			}
			if(isdefined(self.enemy.doa.var_8d2d32e7))
			{
				self.lastknownenemypos = self.enemy.doa.var_8d2d32e7;
			}
			return self.lastknownenemypos;
		}
		return self.enemy.origin;
	}
	return self.origin;
}

/*
	Name: function_f31da0d1
	Namespace: doa_enemy
	Checksum: 0xCD5E1ED0
	Offset: 0x27E8
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function function_f31da0d1(behaviortreeentity)
{
	if(!isdefined(behaviortreeentity.enemy))
	{
		return false;
	}
	yaw = abs(doa_utility::getyawtoenemy());
	if(yaw > 45)
	{
		return false;
	}
	targetorigin = behaviortreeentity function_69b8254();
	if(distancesquared(behaviortreeentity.origin, targetorigin) > (92 * 92))
	{
		return false;
	}
	if(distance2dsquared(behaviortreeentity.origin, targetorigin) < 2304)
	{
		return true;
	}
	return false;
}

/*
	Name: function_2241fc21
	Namespace: doa_enemy
	Checksum: 0x19CEA63E
	Offset: 0x28F0
	Size: 0x63C
	Parameters: 15
	Flags: Linked
*/
function function_2241fc21(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, boneindex, modelindex, surfacetype, surfacenormal)
{
	self endon(#"death");
	if(isdefined(eattacker) && isdefined(eattacker.meleedamage))
	{
		idamage = eattacker.meleedamage;
	}
	if(self.team == "allies")
	{
		/#
			doa_utility::debugmsg((("" + self.archetype) + "") + idamage);
		#/
	}
	if(isdefined(self.allowdeath) && self.allowdeath == 0 && idamage >= self.health)
	{
		idamage = self.health - 1;
	}
	if(isdefined(einflictor) && einflictor.team == self.team || (isdefined(eattacker) && eattacker.team == self.team))
	{
		self finishactordamage(einflictor, eattacker, 0, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, boneindex, surfacetype, surfacenormal);
		return;
	}
	if(isdefined(self.fx) && self.health <= idamage)
	{
		self thread namespace_eaa992c::turnofffx(self.fx);
		self.fx = undefined;
	}
	if(isdefined(weapon) && isdefined(level.doa.var_7808fc8c[weapon.name]))
	{
		level [[level.doa.var_7808fc8c[weapon.name]]](self, idamage, eattacker, vdir, smeansofdeath, weapon);
	}
	if(!(isdefined(self.boss) && self.boss))
	{
		self namespace_fba031c8::function_15a268a6(eattacker, idamage, smeansofdeath, weapon, shitloc, vdir);
	}
	if(smeansofdeath == "MOD_BURNED")
	{
		/#
			doa_utility::debugmsg(((("" + idamage) + "") + self.health) + (idamage > self.health ? "" : ""));
		#/
	}
	if(smeansofdeath == "MOD_CRUSH")
	{
		if(isdefined(self.boss) && self.boss)
		{
			idamage = 0;
		}
		else
		{
			idamage = self.health;
		}
	}
	if(weapon == level.doa.var_69899304)
	{
		idamage = idamage + (int(3 * level.doa.round_number));
	}
	if(isdefined(self.overrideactordamage))
	{
		idamage = self [[self.overrideactordamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, timeoffset, boneindex, modelindex);
	}
	else if(isdefined(level.overrideactordamage))
	{
		idamage = self [[level.overrideactordamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, timeoffset, boneindex, modelindex);
	}
	if(isdefined(self.aioverridedamage))
	{
		if(isarray(self.aioverridedamage))
		{
			foreach(cb in self.aioverridedamage)
			{
				idamage = self [[cb]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, timeoffset, boneindex, modelindex);
			}
		}
		else
		{
			idamage = self [[self.aioverridedamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, timeoffset, boneindex, modelindex);
		}
	}
	if(idamage >= self.health)
	{
		self zombie_eye_glow_stop();
	}
	if(isdefined(eattacker) && isdefined(eattacker.owner))
	{
		eattacker = eattacker.owner;
	}
	self finishactordamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, boneindex, surfacetype, surfacenormal);
}

/*
	Name: function_ff217d39
	Namespace: doa_enemy
	Checksum: 0x9BCA2599
	Offset: 0x2F38
	Size: 0x4FC
	Parameters: 14
	Flags: Linked
*/
function function_ff217d39(einflictor, eattacker, idamage, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(isdefined(einflictor))
	{
		self.damageinflictor = einflictor;
	}
	self asmsetanimationrate(1);
	if(self.team == "allies")
	{
		/#
			doa_utility::debugmsg("" + self.archetype);
		#/
	}
	if(isdefined(self.fx))
	{
		self thread namespace_eaa992c::turnofffx(self.fx);
	}
	if(randomint(100) < 20)
	{
		switch(randomint(3))
		{
			case 0:
			{
				self thread namespace_eaa992c::function_285a2999("headshot");
				break;
			}
			case 1:
			{
				self thread namespace_eaa992c::function_285a2999("headshot_nochunks");
				break;
			}
			default:
			{
				self thread namespace_eaa992c::function_285a2999("bloodspurt");
				break;
			}
		}
	}
	if(isdefined(self.doa) && (!(isdefined(self.boss) && self.boss)) && (!(isdefined(self.doa.var_4d252af6) && self.doa.var_4d252af6)))
	{
		roll = randomint((isdefined(self.var_2ea42113) ? self.var_2ea42113 : getdvarint("scr_doa_drop_rate_perN", 200)));
		if(roll == 0)
		{
			doa_pickups::spawnubertreasure(self.origin, 1, 85, 1, 0, undefined, level.doa.var_9bf7e61b);
		}
	}
	if(isdefined(self.interdimensional_gun_kill) && self.interdimensional_gun_kill)
	{
		self namespace_fba031c8::function_7b3e39cb();
		level thread doa_pickups::spawnubertreasure(self.origin, 1, 1, 1, 1);
	}
	if(isdefined(eattacker))
	{
		if(isactor(eattacker) && isdefined(eattacker.owner) && isplayer(eattacker.owner))
		{
			eattacker = eattacker.owner;
		}
		if(isplayer(eattacker) && isdefined(eattacker.doa) && isdefined(self.doa) && isdefined(self.doa.points))
		{
			eattacker.kills = math::clamp(eattacker.kills + 1, 0, 65535);
			eattacker.doa.kills++;
			eattacker namespace_64c6b720::function_80eb303(self.doa.points);
		}
	}
	if(smeansofdeath == "MOD_CRUSH")
	{
		/#
			assert(!(isdefined(self.boss) && self.boss));
		#/
		self namespace_fba031c8::function_ddf685e8(undefined, eattacker);
		if(isdefined(eattacker))
		{
			eattacker notify(#"hash_108fd845");
		}
	}
	if(smeansofdeath == "MOD_ELECTROCUTED" && isdefined(einflictor))
	{
		dir = self.origin - einflictor.origin;
		self thread doa_utility::function_e3c30240(dir);
	}
}

/*
	Name: function_c26b6656
	Namespace: doa_enemy
	Checksum: 0x1560AA28
	Offset: 0x3440
	Size: 0x254
	Parameters: 15
	Flags: Linked
*/
function function_c26b6656(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(isdefined(eattacker) && eattacker.team == self.team)
	{
		idamage = 0;
	}
	if(isdefined(self.owner) && isplayer(self.owner) && (isdefined(self.playercontrolled) && self.playercontrolled))
	{
		idamage = 0;
	}
	if(isdefined(self.overridevehicledamage))
	{
		idamage = self [[self.overridevehicledamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal);
	}
	else if(isdefined(level.overridevehicledamage))
	{
		idamage = self [[level.overridevehicledamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal);
	}
	if(idamage == 0)
	{
		return;
	}
	idamage = int(idamage);
	self finishvehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname, 0);
}

/*
	Name: function_90772ac6
	Namespace: doa_enemy
	Checksum: 0x2F9EFBE4
	Offset: 0x36A0
	Size: 0x230
	Parameters: 8
	Flags: Linked
*/
function function_90772ac6(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	if(isdefined(einflictor))
	{
		self.damageinflictor = einflictor;
	}
	if(isdefined(eattacker) && isplayer(eattacker) && isdefined(eattacker.doa) && isdefined(self.doa))
	{
		eattacker.kills = math::clamp(eattacker.kills + 1, 0, 65535);
		eattacker.doa.kills++;
		eattacker namespace_64c6b720::function_80eb303(self.doa.points);
	}
	params = spawnstruct();
	params.einflictor = einflictor;
	params.eattacker = eattacker;
	params.idamage = idamage;
	params.smeansofdeath = smeansofdeath;
	params.weapon = weapon;
	params.vdir = vdir;
	params.shitloc = shitloc;
	params.psoffsettime = psoffsettime;
	self callback::callback(#"hash_acb66515", params);
	if(isdefined(self.overridevehiclekilled))
	{
		self [[self.overridevehiclekilled]](einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime);
	}
}

/*
	Name: function_e77599c
	Namespace: doa_enemy
	Checksum: 0x3B856DC6
	Offset: 0x38D8
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function function_e77599c()
{
	level.doa.var_b351e5fb++;
	self waittill(#"death");
	level.doa.var_b351e5fb--;
	if(level.doa.var_b351e5fb < 0)
	{
		level.doa.var_b351e5fb = 0;
	}
}

/*
	Name: function_7c435737
	Namespace: doa_enemy
	Checksum: 0xE272B44C
	Offset: 0x3938
	Size: 0xAE
	Parameters: 0
	Flags: None
*/
function function_7c435737()
{
	self endon(#"death");
	self endon(#"hash_10fd80ee");
	while(isalive(self))
	{
		target = namespace_831a4a7c::function_35f36dec(self.origin);
		if(isdefined(target) && (!(isdefined(self.ignoreall) && self.ignoreall)))
		{
			self setentitytarget(target);
		}
		else
		{
			self clearentitytarget();
		}
		wait(1);
	}
}

/*
	Name: function_a4e16560
	Namespace: doa_enemy
	Checksum: 0x9D76CABC
	Offset: 0x39F0
	Size: 0x568
	Parameters: 3
	Flags: Linked
*/
function function_a4e16560(sp_enemy, s_spawn_loc, force = 0)
{
	/#
	#/
	if(!force && level.doa.var_b351e5fb >= level.doa.rules.max_enemy_count)
	{
		return;
	}
	if(!mayspawnentity())
	{
		return;
	}
	sp_enemy.lastspawntime = 0;
	if(!isdefined(s_spawn_loc.angles))
	{
		s_spawn_loc.angles = (0, 0, 0);
	}
	sp_enemy.count = 9999;
	ai_spawned = sp_enemy spawner::spawn(1, "doa enemy", s_spawn_loc.origin, s_spawn_loc.angles, 1);
	if(!isdefined(ai_spawned))
	{
		return;
	}
	ai_spawned.spawner = sp_enemy;
	ai_spawned setthreatbiasgroup("zombies");
	ai_spawned.doa = spawnstruct();
	ai_spawned.doa.original_origin = ai_spawned.origin;
	ai_spawned.doa.points = level.doa.rules.var_c7b07ba9;
	ai_spawned.doa.stunned = 0;
	ai_spawned.no_eye_glow = 1;
	ai_spawned.holdfire = 1;
	ai_spawned.meleedamage = 123;
	ai_spawned thread function_e77599c();
	ai_spawned thread function_53055b45();
	ai_spawned thread function_155957e9();
	ai_spawned thread function_755b8a2e();
	ai_spawned thread function_8abf3753();
	ai_spawned thread doa_utility::function_783519c1("cleanUpAI", 1);
	ai_spawned thread function_ab6f6263();
	ai_spawned thread function_462594a2();
	if(isvehicle(ai_spawned))
	{
		ai_spawned.origin = s_spawn_loc.origin;
		ai_spawned.angles = s_spawn_loc.angles;
		return ai_spawned;
	}
	ai_spawned.setgoaloverridecb = &function_d30fe558;
	gibserverutils::togglespawngibs(ai_spawned, 1);
	if(isdefined(sp_enemy.script_noteworthy) && issubstr(sp_enemy.script_noteworthy, "has_eyes"))
	{
		ai_spawned.no_eye_glow = undefined;
		ai_spawned zombie_eye_glow();
	}
	ai_spawned forceteleport(s_spawn_loc.origin, s_spawn_loc.angles);
	ai_spawned.goalradius = 8;
	ai_spawned updatespeed();
	ai_spawned.health = level.doa.zombie_health;
	ai_spawned.maxhealth = level.doa.zombie_health;
	ai_spawned.animname = "zombie";
	ai_spawned.ignore_gravity = 0;
	ai_spawned.updatesight = 0;
	ai_spawned.maxsightdistsqrd = 512 * 512;
	ai_spawned.fovcosine = 0.77;
	ai_spawned.anim_rate = level.doa.var_c061227e;
	if(isdefined(sp_enemy.var_8d1af144) && sp_enemy.var_8d1af144)
	{
		ai_spawned asmsetanimationrate(ai_spawned.anim_rate);
		ai_spawned.var_96437a17 = 1;
	}
	ai_spawned.badplaceawareness = 0;
	ai_spawned setrepairpaths(0);
	return ai_spawned;
}

/*
	Name: function_71a4f1d5
	Namespace: doa_enemy
	Checksum: 0x73A4E661
	Offset: 0x3F60
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function function_71a4f1d5()
{
	self waittill(#"actor_corpse", corpse);
}

/*
	Name: zombie_eye_glow
	Namespace: doa_enemy
	Checksum: 0x8A45F0A1
	Offset: 0x3F88
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function zombie_eye_glow()
{
	if(!isdefined(self))
	{
		return;
	}
	if(!isdefined(self.no_eye_glow) || !self.no_eye_glow)
	{
		self clientfield::set("zombie_has_eyes", 1);
	}
}

/*
	Name: function_462594a2
	Namespace: doa_enemy
	Checksum: 0xD3E64DC3
	Offset: 0x3FE0
	Size: 0x210
	Parameters: 0
	Flags: Linked
*/
function function_462594a2()
{
	self endon(#"death");
	if(!isdefined(self))
	{
		return;
	}
	if(!isdefined(self.aitype))
	{
		return;
	}
	alias = "zmb_vocals_zombie_default";
	switch(self.aitype)
	{
		case "spawner_zombietron_zombie":
		{
			alias = "zmb_vocals_zombie_default";
			break;
		}
		case "spawner_zombietron_smokeman":
		{
			alias = "zmb_vocals_zombie_default";
			break;
		}
		case "spawner_zombietron_cellbreaker":
		{
			alias = "zmb_vocals_warlord";
			break;
		}
		case "spawner_zombietron_warlord":
		{
			alias = "zmb_vocals_warlord";
			break;
		}
		case "spawner_zombietron_silverback":
		{
			alias = "zmb_simianaut_vocal";
			break;
		}
		case "spawner_zombietron_robot":
		{
			alias = "zmb_vocals_bot_ambient";
			break;
		}
		case "spawner_zombietron_riser":
		{
			alias = "zmb_vocals_zombie_default";
			break;
		}
		case "spawner_zombietron_bloodriser":
		{
			alias = "zmb_vocals_zombie_default";
			break;
		}
		case "spawner_zombietron_poor_urban":
		{
			alias = "zmb_vocals_zombie_default";
			break;
		}
		case "spawner_zombietron_margwa":
		{
			alias = undefined;
			break;
		}
		case "spawner_zombietron_dog":
		{
			alias = "zmb_vocals_hellhound_ambient";
			break;
		}
		case "spawner_zombietron_collector":
		{
			alias = "zmb_vocals_collector";
			break;
		}
		case "spawner_zombietron_skeleton":
		{
			alias = "zmb_vocals_skel_ambient";
			break;
		}
		case "spawner_zombietron_54i_robot":
		{
			alias = "zmb_vocals_bot_ambient";
			break;
		}
	}
	if(!isdefined(alias))
	{
		return;
	}
	wait(randomfloatrange(1, 4));
	while(isdefined(self))
	{
		if(mayspawnentity())
		{
			self playsound(alias);
		}
		wait(randomintrange(4, 10));
	}
}

/*
	Name: zombie_eye_glow_stop
	Namespace: doa_enemy
	Checksum: 0xFF347DFD
	Offset: 0x41F8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function zombie_eye_glow_stop()
{
	if(!isdefined(self))
	{
		return;
	}
	if(!isdefined(self.no_eye_glow) || !self.no_eye_glow)
	{
		self clientfield::set("zombie_has_eyes", 0);
	}
}

/*
	Name: function_8abf3753
	Namespace: doa_enemy
	Checksum: 0xF0AEAD23
	Offset: 0x4250
	Size: 0x48
	Parameters: 1
	Flags: Linked, Private
*/
function private function_8abf3753(time = 1)
{
	self endon(#"death");
	wait(time);
	self.doa.original_origin = self.origin;
}

/*
	Name: function_8a4222de
	Namespace: doa_enemy
	Checksum: 0x120A4639
	Offset: 0x42A0
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_8a4222de(time)
{
	if(!isactor(self))
	{
		return;
	}
	self endon(#"death");
	self endon(#"hash_67a97d62");
	self setavoidancemask("avoid none");
	var_e0bc9b4c = self pushactors(0);
	wait(time);
	self setavoidancemask("avoid all");
	if(isdefined(var_e0bc9b4c))
	{
		self pushactors(var_e0bc9b4c);
	}
}

/*
	Name: function_155957e9
	Namespace: doa_enemy
	Checksum: 0xA5B23D9F
	Offset: 0x4370
	Size: 0x198
	Parameters: 0
	Flags: Linked
*/
function function_155957e9()
{
	self endon(#"death");
	self endon(#"hash_67a97d62");
	if(isdefined(self.boss))
	{
		return;
	}
	var_2f36e0eb = 0;
	while(!level flag::get("doa_game_is_over"))
	{
		wait(1);
		safezone = namespace_3ca3c537::function_dc34896f();
		if(!self istouching(safezone))
		{
			var_2f36e0eb++;
		}
		else
		{
			var_2f36e0eb = 0;
		}
		if(var_2f36e0eb == 5)
		{
			/#
				doa_utility::debugmsg((("" + self.origin) + "") + self.spawner.targetname);
			#/
			self.var_802ce72 = 1;
			self.allowdeath = 1;
			self kill();
		}
		if(var_2f36e0eb == 6)
		{
			/#
				doa_utility::debugmsg((("" + self.origin) + "") + self.spawner.targetname);
			#/
			self.var_802ce72 = 1;
			self delete();
		}
	}
}

/*
	Name: function_755b8a2e
	Namespace: doa_enemy
	Checksum: 0xC0B8CA77
	Offset: 0x4510
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_755b8a2e()
{
	self endon(#"death");
	self endon(#"hash_6dcbb83e");
	wait(1);
	while(level flag::get("doa_round_spawning"))
	{
		wait(0.05);
	}
	if(doa_utility::function_b99d78c7() > 5)
	{
		wait(0.05);
	}
	self thread doa_utility::function_ba30b321(60);
}

/*
	Name: function_53055b45
	Namespace: doa_enemy
	Checksum: 0xA369CA9A
	Offset: 0x45A0
	Size: 0x3D8
	Parameters: 0
	Flags: Linked
*/
function function_53055b45()
{
	self endon(#"death");
	self endon(#"hash_6e8326fc");
	if(isdefined(self.boss))
	{
		return;
	}
	fails = 0;
	while(!level flag::get("doa_game_is_over"))
	{
		if(isdefined(self.traversestartnode) || isdefined(self.doa.poi) || self.doa.stunned != 0 || (isdefined(self.var_dd70dacd) && self.var_dd70dacd) || (isdefined(self.rising) && self.rising) || (isdefined(level.hostmigrationtimer) && level.hostmigrationtimer) || (isdefined(self.var_58acb0e3) && self.var_58acb0e3))
		{
			wait(1);
			continue;
		}
		if(fails == 0)
		{
			if(isdefined(self.var_b7e79322) && self.var_b7e79322)
			{
				checkpos = (self.origin[0], self.origin[1], self.origin[2]);
				time = 2;
			}
			else
			{
				checkpos = (self.origin[0], self.origin[1], 0);
				time = 1;
			}
		}
		wait(time);
		if(isdefined(self.var_b7e79322) && self.var_b7e79322)
		{
			mindistsq = 4 * 4;
			var_3faea97b = (self.origin[0], self.origin[1], self.origin[2]);
		}
		else
		{
			mindistsq = 32 * 32;
			var_3faea97b = (self.origin[0], self.origin[1], 0);
		}
		distsq = distancesquared(checkpos, var_3faea97b);
		if(distsq < mindistsq)
		{
			fails++;
			if(fails == 2)
			{
				self thread function_8a4222de(3);
			}
			if(fails == 5)
			{
				/#
					doa_utility::debugmsg((("" + self.origin) + "") + self.spawner.targetname);
				#/
				self dodamage(self.health + 666, self.origin);
			}
		}
		else
		{
			fails = 0;
		}
		if(level flag::get("doa_round_spawning") || isdefined(self.doa.poi))
		{
			continue;
		}
		if(isdefined(self.missinglegs) && self.missinglegs || (isdefined(self.iscrawler) && self.iscrawler))
		{
			self dodamage(int(self.maxhealth * 0.1), self.origin);
		}
	}
}

/*
	Name: function_ab6f6263
	Namespace: doa_enemy
	Checksum: 0x534C6208
	Offset: 0x4980
	Size: 0x254
	Parameters: 0
	Flags: Linked
*/
function function_ab6f6263()
{
	var_2c143867 = array(%generic::ai_zombie_base_idle_ad_v1, %generic::ai_zombie_base_idle_au_v1, %generic::bo3_ai_zombie_attack_v1, %generic::bo3_ai_zombie_attack_v2, %generic::bo3_ai_zombie_attack_v3, %generic::bo3_ai_zombie_attack_v4, %generic::bo3_ai_zombie_attack_v6);
	self endon(#"death");
	self notify(#"hash_ab6f6263");
	self endon(#"hash_ab6f6263");
	self.var_58acb0e3 = undefined;
	while(!(isdefined(level.hostmigrationtimer) && level.hostmigrationtimer))
	{
		wait(1);
	}
	self.ignoreall = 1;
	self clearentitytarget();
	while(isdefined(level.hostmigrationtimer) && level.hostmigrationtimer)
	{
		self.var_58acb0e3 = 1;
		if(isdefined(self.var_96437a17) && self.var_96437a17 && (!(isdefined(self.rising) && self.rising)))
		{
			idleanim = var_2c143867[randomint(var_2c143867.size)];
			self animscripted("zombieanim", self.origin, self.angles, idleanim, "normal", %generic::body, 1, 0.3, 0.3);
			self waittillmatch(#"hash_24281fe0");
		}
		else
		{
			self setgoal(self.origin, 0);
			wait(1);
		}
	}
	wait(0.05);
	self.ignoreall = 0;
	self.var_58acb0e3 = undefined;
	self thread function_ab6f6263();
}

