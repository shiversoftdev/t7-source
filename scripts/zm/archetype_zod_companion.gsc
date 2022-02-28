// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\ai_squads;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\archetype_zod_companion_interface;

#namespace archetype_zod_companion;

/*
	Name: main
	Namespace: archetype_zod_companion
	Checksum: 0x17284B84
	Offset: 0xA08
	Size: 0xA4
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("allplayers", "being_robot_revived", 1, 1, "int");
	spawner::add_archetype_spawn_function("zod_companion", &zodcompanionbehavior::archetypezodcompanionblackboardinit);
	spawner::add_archetype_spawn_function("zod_companion", &zodcompanionserverutils::zodcompanionsoldierspawnsetup);
	zodcompanioninterface::registerzodcompanioninterfaceattributes();
	zodcompanionbehavior::registerbehaviorscriptfunctions();
}

#namespace zodcompanionbehavior;

/*
	Name: registerbehaviorscriptfunctions
	Namespace: zodcompanionbehavior
	Checksum: 0x436CEF15
	Offset: 0xAB8
	Size: 0x2AC
	Parameters: 0
	Flags: Linked
*/
function registerbehaviorscriptfunctions()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionTacticalWalkActionStart", &zodcompaniontacticalwalkactionstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionAbleToShoot", &zodcompanionabletoshootcondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionShouldTacticalWalk", &zodcompanionshouldtacticalwalk);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionMovement", &zodcompanionmovement);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionDelayMovement", &zodcompaniondelaymovement);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionSetDesiredStanceToStand", &zodcompanionsetdesiredstancetostand);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionFinishedSprintTransition", &zodcompanionfinishedsprinttransition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionSprintTransitioning", &zodcompanionsprinttransitioning);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionKeepsCurrentMovementMode", &zodcompanionkeepscurrentmovementmode);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionCanJuke", &zodcompanioncanjuke);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionCanPreemptiveJuke", &zodcompanioncanpreemptivejuke);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionJukeInitialize", &zodcompanionjukeinitialize);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionPreemptiveJukeTerminate", &zodcompanionpreemptivejuketerminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionTargetService", &zodcompaniontargetservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionTryReacquireService", &zodcompaniontryreacquireservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("manage_companion_movement", &manage_companion_movement);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodCompanionCollisionService", &zodcompanioncollisionservice);
}

/*
	Name: mocompignorepainfaceenemyinit
	Namespace: zodcompanionbehavior
	Checksum: 0x555DE963
	Offset: 0xD70
	Size: 0x7C
	Parameters: 5
	Flags: Private
*/
function private mocompignorepainfaceenemyinit(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity.blockingpain = 1;
	entity orientmode("face enemy");
	entity animmode("pos deltas");
}

/*
	Name: mocompignorepainfaceenemyterminate
	Namespace: zodcompanionbehavior
	Checksum: 0x483B0F5B
	Offset: 0xDF8
	Size: 0x3C
	Parameters: 5
	Flags: Private
*/
function private mocompignorepainfaceenemyterminate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity.blockingpain = 0;
}

/*
	Name: archetypezodcompanionblackboardinit
	Namespace: zodcompanionbehavior
	Checksum: 0x2BECAACE
	Offset: 0xE40
	Size: 0x1A4
	Parameters: 0
	Flags: Linked, Private
*/
function private archetypezodcompanionblackboardinit()
{
	entity = self;
	entity.pushable = 1;
	blackboard::createblackboardforentity(entity);
	ai::createinterfaceforentity(entity);
	entity aiutility::registerutilityblackboardattributes();
	blackboard::registerblackboardattribute(self, "_locomotion_speed", "locomotion_speed_sprint", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_move_mode", "normal", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_gibbed_limbs", undefined, &zodcompaniongetgibbedlimbs);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	/#
		entity finalizetrackedblackboardattributes();
	#/
}

/*
	Name: zodcompaniongetgibbedlimbs
	Namespace: zodcompanionbehavior
	Checksum: 0x592AF342
	Offset: 0xFF0
	Size: 0xA6
	Parameters: 0
	Flags: Linked, Private
*/
function private zodcompaniongetgibbedlimbs()
{
	entity = self;
	rightarmgibbed = gibserverutils::isgibbed(entity, 16);
	leftarmgibbed = gibserverutils::isgibbed(entity, 32);
	if(rightarmgibbed && leftarmgibbed)
	{
		return "both_arms";
	}
	if(rightarmgibbed)
	{
		return "right_arm";
	}
	if(leftarmgibbed)
	{
		return "left_arm";
	}
	return "none";
}

/*
	Name: zodcompaniondelaymovement
	Namespace: zodcompanionbehavior
	Checksum: 0x81C474F3
	Offset: 0x10A0
	Size: 0x44
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompaniondelaymovement(entity)
{
	entity pathmode("move delayed", 0, randomfloatrange(1, 2));
}

/*
	Name: zodcompanionmovement
	Namespace: zodcompanionbehavior
	Checksum: 0x97FFAD11
	Offset: 0x10F0
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompanionmovement(entity)
{
	if(blackboard::getblackboardattribute(entity, "_stance") != "stand")
	{
		blackboard::setblackboardattribute(entity, "_desired_stance", "stand");
	}
}

/*
	Name: zodcompanioncanjuke
	Namespace: zodcompanionbehavior
	Checksum: 0x4D3CA24A
	Offset: 0x1158
	Size: 0x156
	Parameters: 1
	Flags: Linked
*/
function zodcompanioncanjuke(entity)
{
	if(!(isdefined(entity.steppedoutofcover) && entity.steppedoutofcover) && aiutility::canjuke(entity))
	{
		jukeevents = blackboard::getblackboardevents("robot_juke");
		tooclosejukedistancesqr = 57600;
		foreach(event in jukeevents)
		{
			if(event.data.entity != entity && distance2dsquared(entity.origin, event.data.origin) <= tooclosejukedistancesqr)
			{
				return false;
			}
		}
		return true;
	}
	return false;
}

/*
	Name: zodcompanioncanpreemptivejuke
	Namespace: zodcompanionbehavior
	Checksum: 0x18865039
	Offset: 0x12B8
	Size: 0x31E
	Parameters: 1
	Flags: Linked
*/
function zodcompanioncanpreemptivejuke(entity)
{
	if(!isdefined(entity.enemy) || !isplayer(entity.enemy))
	{
		return 0;
	}
	if(blackboard::getblackboardattribute(entity, "_stance") == "crouch")
	{
		return 0;
	}
	if(!entity.shouldpreemptivejuke)
	{
		return 0;
	}
	if(isdefined(entity.nextpreemptivejuke) && entity.nextpreemptivejuke > gettime())
	{
		return 0;
	}
	if(entity.enemy playerads() < entity.nextpreemptivejukeads)
	{
		return 0;
	}
	if(distancesquared(entity.origin, entity.enemy.origin) < 360000)
	{
		angledifference = absangleclamp180(entity.angles[1] - entity.enemy.angles[1]);
		/#
			record3dtext(angledifference, entity.origin + vectorscale((0, 0, 1), 5), (0, 1, 0), "");
		#/
		if(angledifference > 135)
		{
			enemyangles = entity.enemy getgunangles();
			toenemy = entity.enemy.origin - entity.origin;
			forward = anglestoforward(enemyangles);
			dotproduct = abs(vectordot(vectornormalize(toenemy), forward));
			/#
				record3dtext(acos(dotproduct), entity.origin + vectorscale((0, 0, 1), 10), (0, 1, 0), "");
			#/
			if(dotproduct > 0.9848)
			{
				return zodcompanioncanjuke(entity);
			}
		}
	}
	return 0;
}

/*
	Name: _isvalidplayer
	Namespace: zodcompanionbehavior
	Checksum: 0xE9BBCB3D
	Offset: 0x15E0
	Size: 0xAE
	Parameters: 1
	Flags: Linked, Private
*/
function private _isvalidplayer(player)
{
	if(!isdefined(player) || !isalive(player) || !isplayer(player) || player.sessionstate == "spectator" || player.sessionstate == "intermission" || player laststand::player_is_in_laststand() || player.ignoreme)
	{
		return false;
	}
	return true;
}

/*
	Name: _findclosest
	Namespace: zodcompanionbehavior
	Checksum: 0x84D9CF2A
	Offset: 0x1698
	Size: 0x142
	Parameters: 2
	Flags: Linked, Private
*/
function private _findclosest(entity, entities)
{
	closest = spawnstruct();
	if(entities.size > 0)
	{
		closest.entity = entities[0];
		closest.distancesquared = distancesquared(entity.origin, closest.entity.origin);
		for(index = 1; index < entities.size; index++)
		{
			distancesquared = distancesquared(entity.origin, entities[index].origin);
			if(distancesquared < closest.distancesquared)
			{
				closest.distancesquared = distancesquared;
				closest.entity = entities[index];
			}
		}
	}
	return closest;
}

/*
	Name: zodcompaniontargetservice
	Namespace: zodcompanionbehavior
	Checksum: 0x12B9842D
	Offset: 0x17E8
	Size: 0x434
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompaniontargetservice(entity)
{
	if(zodcompanionabletoshootcondition(entity))
	{
		return false;
	}
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return false;
	}
	aienemies = [];
	playerenemies = [];
	ai = getaiarray();
	players = getplayers();
	positiononnavmesh = getclosestpointonnavmesh(entity.origin, 200);
	if(!isdefined(positiononnavmesh))
	{
		return;
	}
	foreach(value in ai)
	{
		if(value.team != entity.team && isactor(value) && !isdefined(entity.favoriteenemy))
		{
			enemypositiononnavmesh = getclosestpointonnavmesh(value.origin, 200);
			if(isdefined(enemypositiononnavmesh) && entity findpath(positiononnavmesh, enemypositiononnavmesh, 1, 0))
			{
				aienemies[aienemies.size] = value;
			}
		}
	}
	foreach(value in players)
	{
		if(_isvalidplayer(value))
		{
			enemypositiononnavmesh = getclosestpointonnavmesh(value.origin, 200);
			if(isdefined(enemypositiononnavmesh) && entity findpath(positiononnavmesh, enemypositiononnavmesh, 1, 0))
			{
				playerenemies[playerenemies.size] = value;
			}
		}
	}
	closestplayer = _findclosest(entity, playerenemies);
	closestai = _findclosest(entity, aienemies);
	if(!isdefined(closestplayer.entity) && !isdefined(closestai.entity))
	{
		return;
	}
	if(!isdefined(closestai.entity))
	{
		entity.favoriteenemy = closestplayer.entity;
	}
	else
	{
		if(!isdefined(closestplayer.entity))
		{
			entity.favoriteenemy = closestai.entity;
		}
		else
		{
			if(closestai.distancesquared < closestplayer.distancesquared)
			{
				entity.favoriteenemy = closestai.entity;
			}
			else
			{
				entity.favoriteenemy = closestplayer.entity;
			}
		}
	}
}

/*
	Name: zodcompaniontacticalwalkactionstart
	Namespace: zodcompanionbehavior
	Checksum: 0xFD51892B
	Offset: 0x1C28
	Size: 0x2C
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompaniontacticalwalkactionstart(entity)
{
	entity orientmode("face enemy");
}

/*
	Name: zodcompanionabletoshootcondition
	Namespace: zodcompanionbehavior
	Checksum: 0xEBFC955B
	Offset: 0x1C60
	Size: 0x54
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompanionabletoshootcondition(entity)
{
	return entity.weapon.name != level.weaponnone.name && !gibserverutils::isgibbed(entity, 16);
}

/*
	Name: zodcompanionshouldtacticalwalk
	Namespace: zodcompanionbehavior
	Checksum: 0xE4B8C005
	Offset: 0x1CC0
	Size: 0x2E
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompanionshouldtacticalwalk(entity)
{
	if(!entity haspath())
	{
		return false;
	}
	return true;
}

/*
	Name: zodcompanionjukeinitialize
	Namespace: zodcompanionbehavior
	Checksum: 0xFC2FB338
	Offset: 0x1CF8
	Size: 0xAC
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompanionjukeinitialize(entity)
{
	aiutility::choosejukedirection(entity);
	entity clearpath();
	jukeinfo = spawnstruct();
	jukeinfo.origin = entity.origin;
	jukeinfo.entity = entity;
	blackboard::addblackboardevent("robot_juke", jukeinfo, 2000);
}

/*
	Name: zodcompanionpreemptivejuketerminate
	Namespace: zodcompanionbehavior
	Checksum: 0xCE04FBD1
	Offset: 0x1DB0
	Size: 0x68
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompanionpreemptivejuketerminate(entity)
{
	entity.nextpreemptivejuke = gettime() + randomintrange(4000, 6000);
	entity.nextpreemptivejukeads = randomfloatrange(0.5, 0.95);
}

/*
	Name: zodcompaniontryreacquireservice
	Namespace: zodcompanionbehavior
	Checksum: 0x913AD5F5
	Offset: 0x1E20
	Size: 0x2F2
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompaniontryreacquireservice(entity)
{
	if(!isdefined(entity.reacquire_state))
	{
		entity.reacquire_state = 0;
	}
	if(!isdefined(entity.enemy))
	{
		entity.reacquire_state = 0;
		return false;
	}
	if(entity haspath())
	{
		return false;
	}
	if(!zodcompanionabletoshootcondition(entity))
	{
		return false;
	}
	if(entity cansee(entity.enemy) && entity canshootenemy())
	{
		entity.reacquire_state = 0;
		return false;
	}
	dirtoenemy = vectornormalize(entity.enemy.origin - entity.origin);
	forward = anglestoforward(entity.angles);
	if(vectordot(dirtoenemy, forward) < 0.5)
	{
		entity.reacquire_state = 0;
		return false;
	}
	switch(entity.reacquire_state)
	{
		case 0:
		case 1:
		case 2:
		{
			step_size = 32 + (entity.reacquire_state * 32);
			reacquirepos = entity reacquirestep(step_size);
			break;
		}
		case 4:
		{
			if(!entity cansee(entity.enemy) || !entity canshootenemy())
			{
				entity flagenemyunattackable();
			}
			break;
		}
		default:
		{
			if(entity.reacquire_state > 15)
			{
				entity.reacquire_state = 0;
				return false;
			}
			break;
		}
	}
	if(isvec(reacquirepos))
	{
		entity useposition(reacquirepos);
		return true;
	}
	entity.reacquire_state++;
	return false;
}

/*
	Name: manage_companion_movement
	Namespace: zodcompanionbehavior
	Checksum: 0x34C7F7BF
	Offset: 0x2120
	Size: 0x7A4
	Parameters: 1
	Flags: Linked, Private
*/
function private manage_companion_movement(entity)
{
	self endon(#"death");
	if(isdefined(level.var_bfd9ed83) && level.var_bfd9ed83.eligible_leader)
	{
		self.leader = level.var_bfd9ed83;
	}
	if(!isdefined(entity.var_57e708f6))
	{
		entity.var_57e708f6 = 0;
	}
	if(entity.bulletsinclip < entity.weapon.clipsize)
	{
		entity.bulletsinclip = entity.weapon.clipsize;
	}
	if(entity.reviving_a_player === 1)
	{
		return;
	}
	if(entity.time_expired === 1)
	{
		return;
	}
	if(entity.var_53ce2a4e === 1 || entity.teleporting === 1)
	{
		return;
	}
	if(entity.leader.teleporting === 1)
	{
		entity thread function_34117adf(entity.leader.teleport_location);
		return;
	}
	if(entity.var_c0e8df41 === 1)
	{
		return;
	}
	if(entity.leader.is_flung === 1)
	{
		entity thread function_3463b8c2(entity.leader.var_fa1ecd39);
	}
	foreach(player in level.players)
	{
		if(player laststand::player_is_in_laststand() && entity.reviving_a_player === 0 && player.revivetrigger.beingrevived !== 1)
		{
			time = gettime();
			if(distancesquared(entity.origin, player.origin) <= (1024 * 1024) && time >= entity.var_57e708f6)
			{
				entity.reviving_a_player = 1;
				entity zod_companion_revive_player(player);
				return;
			}
		}
	}
	if(!isdefined(entity.var_a0c5deb2))
	{
		entity.var_a0c5deb2 = gettime();
	}
	if(gettime() >= entity.var_a0c5deb2 && isdefined(level.active_powerups) && level.active_powerups.size > 0)
	{
		if(!isdefined(entity.var_34a9f1ad))
		{
			entity.var_34a9f1ad = 0;
		}
		foreach(powerup in level.active_powerups)
		{
			if(isinarray(entity.var_fb400bf7, powerup.powerup_name))
			{
				dist = distancesquared(entity.origin, powerup.origin);
				if(dist <= 147456 && randomint(100) < (50 + (10 * entity.var_34a9f1ad)))
				{
					entity setgoal(powerup.origin, 1);
					entity.var_a0c5deb2 = gettime() + randomintrange(2500, 3500);
					entity.next_move_time = gettime() + randomintrange(2500, 3500);
					entity.var_34a9f1ad = 0;
					return;
				}
				entity.var_34a9f1ad = entity.var_34a9f1ad + 1;
			}
		}
		entity.var_a0c5deb2 = gettime() + randomintrange(333, 666);
	}
	follow_radius_squared = 256 * 256;
	if(isdefined(entity.leader))
	{
		entity.companion_anchor_point = entity.leader.origin;
	}
	if(isdefined(entity.pathgoalpos))
	{
		dist_check_start_point = entity.pathgoalpos;
	}
	else
	{
		dist_check_start_point = entity.origin;
	}
	if(isdefined(entity.enemy) && entity.enemy.archetype == "parasite")
	{
		height_difference = abs(entity.origin[2] - entity.enemy.origin[2]);
		var_3b804002 = (1.5 * height_difference) * (1.5 * height_difference);
		if(distancesquared(dist_check_start_point, entity.enemy.origin) < var_3b804002)
		{
			entity pick_new_movement_point();
		}
	}
	if(distancesquared(dist_check_start_point, entity.companion_anchor_point) > follow_radius_squared || distancesquared(dist_check_start_point, entity.companion_anchor_point) < 4096)
	{
		entity pick_new_movement_point();
	}
	if(gettime() >= entity.next_move_time)
	{
		entity pick_new_movement_point();
	}
}

/*
	Name: zodcompanioncollisionservice
	Namespace: zodcompanionbehavior
	Checksum: 0xF33E182
	Offset: 0x28D0
	Size: 0x1D6
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompanioncollisionservice(entity)
{
	if(isdefined(entity.dontpushtime))
	{
		if(gettime() < entity.dontpushtime)
		{
			return true;
		}
	}
	var_5558b624 = 0;
	zombies = getaiteamarray(level.zombie_team);
	foreach(zombie in zombies)
	{
		if(zombie == entity)
		{
			continue;
		}
		dist_sq = distancesquared(entity.origin, zombie.origin);
		if(dist_sq < 14400)
		{
			if(isdefined(zombie.cant_move) && zombie.cant_move)
			{
				zombie thread function_d04291cf();
				var_5558b624 = 1;
			}
		}
	}
	if(var_5558b624)
	{
		entity pushactors(0);
		entity.dontpushtime = gettime() + 2000;
		return true;
	}
	entity pushactors(1);
	return false;
}

/*
	Name: function_d04291cf
	Namespace: zodcompanionbehavior
	Checksum: 0xF5317EE6
	Offset: 0x2AB0
	Size: 0x44
	Parameters: 0
	Flags: Linked, Private
*/
function private function_d04291cf()
{
	self endon(#"death");
	self pushactors(0);
	wait(2);
	self pushactors(1);
}

/*
	Name: function_f62bd05c
	Namespace: zodcompanionbehavior
	Checksum: 0x80851C4
	Offset: 0x2B00
	Size: 0x13E
	Parameters: 2
	Flags: Private
*/
function private function_f62bd05c(target_entity, max_distance)
{
	entity = self;
	var_c96da0a0 = target_entity.origin;
	if(distancesquared(entity.origin, var_c96da0a0) > (max_distance * max_distance))
	{
		return false;
	}
	path = entity calcapproximatepathtoposition(var_c96da0a0);
	segmentlength = 0;
	for(index = 1; index < path.size; index++)
	{
		currentseglength = distance(path[index - 1], path[index]);
		if((currentseglength + segmentlength) > max_distance)
		{
			return false;
		}
		segmentlength = segmentlength + currentseglength;
	}
	return true;
}

/*
	Name: function_34117adf
	Namespace: zodcompanionbehavior
	Checksum: 0x4509F5F1
	Offset: 0x2C48
	Size: 0x50
	Parameters: 1
	Flags: Linked, Private
*/
function private function_34117adf(var_5935e1b9)
{
	self.var_53ce2a4e = 1;
	self setgoal(var_5935e1b9, 1);
	self waittill(#"goal");
	wait(1);
	self.var_53ce2a4e = 0;
}

/*
	Name: function_3463b8c2
	Namespace: zodcompanionbehavior
	Checksum: 0x9B0A229
	Offset: 0x2CA0
	Size: 0xB0
	Parameters: 1
	Flags: Linked, Private
*/
function private function_3463b8c2(var_ee6ad78e)
{
	self.var_c0e8df41 = 1;
	var_c9277d64 = getnodearray("flinger_traversal", "script_noteworthy");
	var_292fba5b = arraygetclosest(var_ee6ad78e, var_c9277d64);
	self setgoal(var_292fba5b.origin, 1);
	self waittill(#"goal");
	wait(1);
	self.var_c0e8df41 = 0;
}

/*
	Name: pick_new_movement_point
	Namespace: zodcompanionbehavior
	Checksum: 0x55FF1AE9
	Offset: 0x2D58
	Size: 0x1CC
	Parameters: 0
	Flags: Linked, Private
*/
function private pick_new_movement_point()
{
	queryresult = positionquery_source_navigation(self.companion_anchor_point, 96, 256, 256, 20, self);
	if(queryresult.data.size)
	{
		if(isdefined(self.enemy) && self.enemy.archetype == "parasite")
		{
			array::filter(queryresult.data, 0, &function_ab299a53, self.enemy);
		}
	}
	if(queryresult.data.size)
	{
		point = queryresult.data[randomint(queryresult.data.size)];
		pathsuccess = self findpath(self.origin, point.origin, 1, 0);
		if(pathsuccess)
		{
			self.companion_destination = point.origin;
		}
		else
		{
			self.next_move_time = gettime() + randomintrange(500, 1500);
			return;
		}
	}
	self setgoal(self.companion_destination, 1);
	self.next_move_time = gettime() + randomintrange(20000, 30000);
}

/*
	Name: function_ab299a53
	Namespace: zodcompanionbehavior
	Checksum: 0x9511E5C1
	Offset: 0x2F30
	Size: 0xB8
	Parameters: 1
	Flags: Linked, Private
*/
function private function_ab299a53(parasite)
{
	point = self;
	height_difference = abs(point.origin[2] - parasite.origin[2]);
	var_3b804002 = (1.5 * height_difference) * (1.5 * height_difference);
	return distancesquared(point.origin, parasite.origin) > var_3b804002;
}

/*
	Name: zodcompanionsetdesiredstancetostand
	Namespace: zodcompanionbehavior
	Checksum: 0xAF0D314
	Offset: 0x2FF0
	Size: 0x6C
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompanionsetdesiredstancetostand(behaviortreeentity)
{
	currentstance = blackboard::getblackboardattribute(behaviortreeentity, "_stance");
	if(currentstance == "crouch")
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_desired_stance", "stand");
	}
}

/*
	Name: zod_companion_revive_player
	Namespace: zodcompanionbehavior
	Checksum: 0x22D4E3C4
	Offset: 0x3068
	Size: 0x3E4
	Parameters: 1
	Flags: Linked
*/
function zod_companion_revive_player(player)
{
	self endon(#"revive_terminated");
	self endon(#"end_game");
	if(!(isdefined(self.reviving_a_player) && self.reviving_a_player))
	{
		self.reviving_a_player = 1;
	}
	player.being_revived_by_robot = 0;
	self thread zod_companion_monitor_revive_attempt(player);
	self.ignoreall = 1;
	queryresult = positionquery_source_navigation(player.origin, 64, 96, 48, 18, self);
	if(queryresult.data.size)
	{
		point = queryresult.data[randomint(queryresult.data.size)];
		self.companion_destination = point.origin;
	}
	self setgoal(self.companion_destination, 1);
	self waittill(#"goal");
	level.var_46040f3e = 1;
	player.revivetrigger.beingrevived = 1;
	player.being_revived_by_robot = 1;
	vector = vectornormalize(player.origin - self.origin);
	angles = vectortoangles(vector);
	self teleport(self.origin, angles);
	self thread animation::play("ai_robot_base_stn_exposed_revive", self, angles, 1.5);
	wait(0.67);
	player clientfield::set("being_robot_revived", 1);
	self waittill(#"robot_revive_complete");
	if(level.players.size == 1 && level flag::get("solo_game"))
	{
		self.var_57e708f6 = gettime() + 10000;
	}
	else
	{
		self.var_57e708f6 = gettime() + 5000;
	}
	player notify(#"stop_revive_trigger");
	if(isplayer(player))
	{
		player allowjump(1);
	}
	player.laststand = undefined;
	player thread zm_laststand::revive_success(self, 0);
	level.var_46040f3e = 0;
	players = getplayers();
	if(players.size == 1 && level flag::get("solo_game") && (isdefined(player.waiting_to_revive) && player.waiting_to_revive))
	{
		level.solo_game_free_player_quickrevive = 1;
		player thread zm_perks::give_perk("specialty_quickrevive", 0);
	}
	self zod_companion_revive_cleanup(player);
}

/*
	Name: zod_companion_monitor_revive_attempt
	Namespace: zodcompanionbehavior
	Checksum: 0xDE5AFC7A
	Offset: 0x3458
	Size: 0xD8
	Parameters: 1
	Flags: Linked
*/
function zod_companion_monitor_revive_attempt(player)
{
	self endon(#"revive_terminated");
	while(true)
	{
		if(isdefined(player.revivetrigger) && player.revivetrigger.beingrevived === 1 && player.being_revived_by_robot !== 1)
		{
			self zod_companion_revive_cleanup(player);
		}
		if(!(isdefined(player laststand::player_is_in_laststand()) && player laststand::player_is_in_laststand()))
		{
			self zod_companion_revive_cleanup(player);
		}
		wait(0.05);
	}
}

/*
	Name: zod_companion_revive_cleanup
	Namespace: zodcompanionbehavior
	Checksum: 0xEE5C154B
	Offset: 0x3538
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function zod_companion_revive_cleanup(player)
{
	self.ignoreall = 0;
	self.reviving_a_player = 0;
	if(isdefined(player))
	{
		if(player.being_revived_by_robot == 1)
		{
			player.being_revived_by_robot = 0;
		}
		player clientfield::set("being_robot_revived", 0);
	}
	self notify(#"revive_terminated");
}

/*
	Name: zodcompanionfinishedsprinttransition
	Namespace: zodcompanionbehavior
	Checksum: 0x9EB06BE3
	Offset: 0x35C8
	Size: 0xDC
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompanionfinishedsprinttransition(behaviortreeentity)
{
	behaviortreeentity.sprint_transition_happening = 0;
	if(blackboard::getblackboardattribute(behaviortreeentity, "_locomotion_speed") == "locomotion_speed_walk")
	{
		behaviortreeentity ai::set_behavior_attribute("sprint", 1);
		blackboard::setblackboardattribute(behaviortreeentity, "_locomotion_speed", "locomotion_speed_sprint");
	}
	else
	{
		behaviortreeentity ai::set_behavior_attribute("sprint", 0);
		blackboard::setblackboardattribute(behaviortreeentity, "_locomotion_speed", "locomotion_speed_walk");
	}
}

/*
	Name: zodcompanionkeepscurrentmovementmode
	Namespace: zodcompanionbehavior
	Checksum: 0x587D468E
	Offset: 0x36B0
	Size: 0xE0
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompanionkeepscurrentmovementmode(behaviortreeentity)
{
	var_ef42515b = 262144;
	var_1be8672c = 147456;
	dist = distancesquared(behaviortreeentity.origin, behaviortreeentity.companion_anchor_point);
	if(dist > var_ef42515b && blackboard::getblackboardattribute(behaviortreeentity, "_locomotion_speed") == "locomotion_speed_walk")
	{
		return false;
	}
	if(dist < var_1be8672c && blackboard::getblackboardattribute(behaviortreeentity, "_locomotion_speed") == "locomotion_speed_sprint")
	{
		return false;
	}
	return true;
}

/*
	Name: zodcompanionsprinttransitioning
	Namespace: zodcompanionbehavior
	Checksum: 0x5188172F
	Offset: 0x3798
	Size: 0x2C
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompanionsprinttransitioning(behaviortreeentity)
{
	if(behaviortreeentity.sprint_transition_happening === 1)
	{
		return true;
	}
	return false;
}

#namespace zodcompanionserverutils;

/*
	Name: _trygibbinghead
	Namespace: zodcompanionserverutils
	Checksum: 0x22882D2E
	Offset: 0x37D0
	Size: 0x134
	Parameters: 4
	Flags: Linked, Private
*/
function private _trygibbinghead(entity, damage, hitloc, isexplosive)
{
	if(isexplosive && randomfloatrange(0, 1) <= 0.5)
	{
		gibserverutils::gibhead(entity);
	}
	else
	{
		if(isinarray(array("head", "neck", "helmet"), hitloc) && randomfloatrange(0, 1) <= 1)
		{
			gibserverutils::gibhead(entity);
		}
		else if((entity.health - damage) <= 0 && randomfloatrange(0, 1) <= 0.25)
		{
			gibserverutils::gibhead(entity);
		}
	}
}

/*
	Name: _trygibbinglimb
	Namespace: zodcompanionserverutils
	Checksum: 0xD648E8BF
	Offset: 0x3910
	Size: 0x27C
	Parameters: 4
	Flags: Linked, Private
*/
function private _trygibbinglimb(entity, damage, hitloc, isexplosive)
{
	if(gibserverutils::isgibbed(entity, 32) || gibserverutils::isgibbed(entity, 16))
	{
		return;
	}
	if(isexplosive && randomfloatrange(0, 1) <= 0.25)
	{
		if((entity.health - damage) <= 0 && entity.allowdeath && math::cointoss())
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
			if((entity.health - damage) <= 0 && entity.allowdeath && isinarray(array("right_hand", "right_arm_lower", "right_arm_upper"), hitloc))
			{
				gibserverutils::gibrightarm(entity);
			}
			else if((entity.health - damage) <= 0 && entity.allowdeath && randomfloatrange(0, 1) <= 0.25)
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
	Name: _trygibbinglegs
	Namespace: zodcompanionserverutils
	Checksum: 0xF06301E
	Offset: 0x3B98
	Size: 0x37C
	Parameters: 5
	Flags: Linked, Private
*/
function private _trygibbinglegs(entity, damage, hitloc, isexplosive, attacker = entity)
{
	cangiblegs = (entity.health - damage) <= 0 && entity.allowdeath;
	cangiblegs = cangiblegs || (((entity.health - damage) / entity.maxhealth) <= 0.25 && distancesquared(entity.origin, attacker.origin) <= 360000 && entity.allowdeath);
	if((entity.health - damage) <= 0 && entity.allowdeath && isexplosive && randomfloatrange(0, 1) <= 0.5)
	{
		gibserverutils::giblegs(entity);
		entity startragdoll();
	}
	else
	{
		if(cangiblegs && isinarray(array("left_leg_upper", "left_leg_lower", "left_foot"), hitloc) && randomfloatrange(0, 1) <= 1)
		{
			if((entity.health - damage) > 0)
			{
				entity.becomecrawler = 1;
			}
			gibserverutils::gibleftleg(entity);
		}
		else
		{
			if(cangiblegs && isinarray(array("right_leg_upper", "right_leg_lower", "right_foot"), hitloc) && randomfloatrange(0, 1) <= 1)
			{
				if((entity.health - damage) > 0)
				{
					entity.becomecrawler = 1;
				}
				gibserverutils::gibrightleg(entity);
			}
			else if((entity.health - damage) <= 0 && entity.allowdeath && randomfloatrange(0, 1) <= 0.25)
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
	Name: zodcompaniongibdamageoverride
	Namespace: zodcompanionserverutils
	Checksum: 0xB8358657
	Offset: 0x3F20
	Size: 0x190
	Parameters: 12
	Flags: Linked, Private
*/
function private zodcompaniongibdamageoverride(inflictor, attacker, damage, flags, meansofdeath, weapon, point, dir, hitloc, offsettime, boneindex, modelindex)
{
	entity = self;
	if(((entity.health - damage) / entity.maxhealth) > 0.75)
	{
		return damage;
	}
	gibserverutils::togglespawngibs(entity, 1);
	isexplosive = isinarray(array("MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTIVLE_SPLASH", "MOD_EXPLOSIVE"), meansofdeath);
	_trygibbinghead(entity, damage, hitloc, isexplosive);
	_trygibbinglimb(entity, damage, hitloc, isexplosive);
	_trygibbinglegs(entity, damage, hitloc, isexplosive, attacker);
	return damage;
}

/*
	Name: zodcompaniondestructdeathoverride
	Namespace: zodcompanionserverutils
	Checksum: 0x75DCA24C
	Offset: 0x40B8
	Size: 0x230
	Parameters: 12
	Flags: Private
*/
function private zodcompaniondestructdeathoverride(inflictor, attacker, damage, flags, meansofdeath, weapon, point, dir, hitloc, offsettime, boneindex, modelindex)
{
	entity = self;
	if((entity.health - damage) <= 0)
	{
		destructserverutils::togglespawngibs(entity, 1);
		piececount = destructserverutils::getpiececount(entity);
		possiblepieces = [];
		for(index = 1; index <= piececount; index++)
		{
			if(!destructserverutils::isdestructed(entity, index) && randomfloatrange(0, 1) <= 0.2)
			{
				possiblepieces[possiblepieces.size] = index;
			}
		}
		gibbedpieces = 0;
		for(index = 0; index < possiblepieces.size && possiblepieces.size > 1 && gibbedpieces < 2; index++)
		{
			randompiece = randomintrange(0, possiblepieces.size - 1);
			if(!destructserverutils::isdestructed(entity, possiblepieces[randompiece]))
			{
				destructserverutils::destructpiece(entity, possiblepieces[randompiece]);
				gibbedpieces++;
			}
		}
	}
	return damage;
}

/*
	Name: zodcompaniondamageoverride
	Namespace: zodcompanionserverutils
	Checksum: 0xFD7B7316
	Offset: 0x42F0
	Size: 0xCC
	Parameters: 12
	Flags: Linked, Private
*/
function private zodcompaniondamageoverride(inflictor, attacker, damage, flags, meansofdeath, weapon, point, dir, hitloc, offsettime, boneindex, modelindex)
{
	entity = self;
	if(hitloc == "helmet" || hitloc == "head" || hitloc == "neck")
	{
		damage = int(damage * 0.5);
	}
	return damage;
}

/*
	Name: findclosestnavmeshpositiontoenemy
	Namespace: zodcompanionserverutils
	Checksum: 0xB8EF9671
	Offset: 0x43C8
	Size: 0x84
	Parameters: 1
	Flags: Private
*/
function private findclosestnavmeshpositiontoenemy(enemy)
{
	enemypositiononnavmesh = undefined;
	for(tolerancelevel = 1; tolerancelevel <= 4; tolerancelevel++)
	{
		enemypositiononnavmesh = getclosestpointonnavmesh(enemy.origin, 200 * tolerancelevel);
		if(isdefined(enemypositiononnavmesh))
		{
			break;
		}
	}
	return enemypositiononnavmesh;
}

/*
	Name: zodcompanionsoldierspawnsetup
	Namespace: zodcompanionserverutils
	Checksum: 0xDC58D726
	Offset: 0x4458
	Size: 0x254
	Parameters: 0
	Flags: Linked, Private
*/
function private zodcompanionsoldierspawnsetup()
{
	entity = self;
	entity.combatmode = "cover";
	entity.fullhealth = entity.health;
	entity.controllevel = 0;
	entity.steppedoutofcover = 0;
	entity.startingweapon = entity.weapon;
	entity.jukedistance = 90;
	entity.jukemaxdistance = 600;
	entity.entityradius = 15;
	entity.base_accuracy = entity.accuracy;
	entity.highlyawareradius = 256;
	entity.treatallcoversasgeneric = 1;
	entity.onlycroucharrivals = 1;
	entity.nextpreemptivejukeads = randomfloatrange(0.5, 0.95);
	entity.shouldpreemptivejuke = math::cointoss();
	entity.reviving_a_player = 0;
	aiutility::addaioverridedamagecallback(entity, &destructserverutils::handledamage);
	aiutility::addaioverridedamagecallback(entity, &zodcompaniondamageoverride);
	aiutility::addaioverridedamagecallback(entity, &zodcompaniongibdamageoverride);
	entity.companion_anchor_point = entity.origin;
	entity.next_move_time = gettime();
	entity.allow_zombie_to_target_ai = 1;
	entity.ignoreme = 1;
	entity thread zodcompanionutility::function_cbe73e3d();
	entity thread zodcompanionutility::manage_companion();
}

#namespace zodcompanionutility;

/*
	Name: manage_companion
	Namespace: zodcompanionutility
	Checksum: 0xABE66E86
	Offset: 0x46B8
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function manage_companion()
{
	self endon(#"death");
	while(true)
	{
		if(!self.reviving_a_player)
		{
			if(!isdefined(self.leader) || !self.leader.eligible_leader)
			{
				self define_new_leader();
			}
		}
		wait(0.5);
	}
}

/*
	Name: function_cbe73e3d
	Namespace: zodcompanionutility
	Checksum: 0x61D92885
	Offset: 0x4728
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function function_cbe73e3d()
{
	self.var_fb400bf7 = [];
	self.var_fb400bf7[0] = "double_points";
	self.var_fb400bf7[1] = "fire_sale";
	self.var_fb400bf7[2] = "insta_kill";
	self.var_fb400bf7[3] = "nuke";
	self.var_fb400bf7[4] = "full_ammo";
	self.var_fb400bf7[5] = "insta_kill_ug";
}

/*
	Name: define_new_leader
	Namespace: zodcompanionutility
	Checksum: 0x957CFC4B
	Offset: 0x47D0
	Size: 0x166
	Parameters: 0
	Flags: Linked
*/
function define_new_leader()
{
	if(isdefined(level.var_bfd9ed83) && level.var_bfd9ed83.eligible_leader)
	{
		self.leader = level.var_bfd9ed83;
	}
	else
	{
		a_potential_leaders = get_potential_leaders(self);
		closest_leader = undefined;
		closest_distance = 1000000;
		if(a_potential_leaders.size == 0)
		{
			self.leader = undefined;
		}
		else
		{
			foreach(potential_leader in a_potential_leaders)
			{
				dist = pathdistance(self.origin, potential_leader.origin);
				if(isdefined(dist) && dist < closest_distance)
				{
					closest_distance = dist;
					self.leader = potential_leader;
				}
			}
		}
	}
}

/*
	Name: get_potential_leaders
	Namespace: zodcompanionutility
	Checksum: 0x148DC9BA
	Offset: 0x4940
	Size: 0x122
	Parameters: 1
	Flags: Linked
*/
function get_potential_leaders(companion)
{
	a_potential_leaders = [];
	foreach(player in level.players)
	{
		if(!isdefined(player.eligible_leader))
		{
			player.eligible_leader = 1;
		}
		if(isdefined(player.eligible_leader) && player.eligible_leader && companion findpath(companion.origin, player.origin))
		{
			a_potential_leaders[a_potential_leaders.size] = player;
		}
	}
	return a_potential_leaders;
}

