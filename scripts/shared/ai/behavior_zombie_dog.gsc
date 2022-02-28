// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\archetype_zombie_dog_interface;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;

#namespace zombiedogbehavior;

/*
	Name: registerbehaviorscriptfunctions
	Namespace: zombiedogbehavior
	Checksum: 0xA551AFE6
	Offset: 0x3F8
	Size: 0x13C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec registerbehaviorscriptfunctions()
{
	spawner::add_archetype_spawn_function("zombie_dog", &archetypezombiedogblackboardinit);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieDogTargetService", &zombiedogtargetservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieDogShouldMelee", &zombiedogshouldmelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieDogShouldWalk", &zombiedogshouldwalk);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieDogShouldRun", &zombiedogshouldrun);
	behaviortreenetworkutility::registerbehaviortreeaction("zombieDogMeleeAction", &zombiedogmeleeaction, undefined, &zombiedogmeleeactionterminate);
	animationstatenetwork::registernotetrackhandlerfunction("dog_melee", &zombiebehavior::zombienotetrackmeleefire);
	zombiedoginterface::registerzombiedoginterfaceattributes();
}

/*
	Name: archetypezombiedogblackboardinit
	Namespace: zombiedogbehavior
	Checksum: 0x3F2BF9C1
	Offset: 0x540
	Size: 0x1B8
	Parameters: 0
	Flags: Linked
*/
function archetypezombiedogblackboardinit()
{
	blackboard::createblackboardforentity(self);
	ai::createinterfaceforentity(self);
	self aiutility::registerutilityblackboardattributes();
	blackboard::registerblackboardattribute(self, "_low_gravity", "normal", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_should_run", "walk", &bb_getshouldrunstatus);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_should_howl", "dont_howl", &bb_getshouldhowlstatus);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	self.___archetypeonanimscriptedcallback = &archetypezombiedogonanimscriptedcallback;
	/#
		self finalizetrackedblackboardattributes();
	#/
	self.kill_on_wine_coccon = 1;
}

/*
	Name: archetypezombiedogonanimscriptedcallback
	Namespace: zombiedogbehavior
	Checksum: 0xA802FDE6
	Offset: 0x700
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private archetypezombiedogonanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity archetypezombiedogblackboardinit();
}

/*
	Name: bb_getshouldrunstatus
	Namespace: zombiedogbehavior
	Checksum: 0xF20CE35D
	Offset: 0x740
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function bb_getshouldrunstatus()
{
	/#
		if(isdefined(self.ispuppet) && self.ispuppet)
		{
			return "";
		}
	#/
	if(isdefined(self.hasseenfavoriteenemy) && self.hasseenfavoriteenemy || (ai::hasaiattribute(self, "sprint") && ai::getaiattribute(self, "sprint")))
	{
		return "run";
	}
	return "walk";
}

/*
	Name: bb_getshouldhowlstatus
	Namespace: zombiedogbehavior
	Checksum: 0x5AE64F5D
	Offset: 0x7D8
	Size: 0xBE
	Parameters: 0
	Flags: Linked
*/
function bb_getshouldhowlstatus()
{
	if(self ai::has_behavior_attribute("howl_chance") && (isdefined(self.hasseenfavoriteenemy) && self.hasseenfavoriteenemy))
	{
		if(!isdefined(self.shouldhowl))
		{
			chance = self ai::get_behavior_attribute("howl_chance");
			self.shouldhowl = randomfloat(1) <= chance;
		}
		if(self.shouldhowl)
		{
			return "howl";
		}
		return "dont_howl";
	}
	return "dont_howl";
}

/*
	Name: getyaw
	Namespace: zombiedogbehavior
	Checksum: 0x620981F
	Offset: 0x8A0
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function getyaw(org)
{
	angles = vectortoangles(org - self.origin);
	return angles[1];
}

/*
	Name: absyawtoenemy
	Namespace: zombiedogbehavior
	Checksum: 0xD4D00370
	Offset: 0x8F0
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function absyawtoenemy()
{
	/#
		assert(isdefined(self.enemy));
	#/
	yaw = self.angles[1] - getyaw(self.enemy.origin);
	yaw = angleclamp180(yaw);
	if(yaw < 0)
	{
		yaw = -1 * yaw;
	}
	return yaw;
}

/*
	Name: need_to_run
	Namespace: zombiedogbehavior
	Checksum: 0x51B27044
	Offset: 0x998
	Size: 0x234
	Parameters: 0
	Flags: Linked
*/
function need_to_run()
{
	run_dist_squared = self ai::get_behavior_attribute("min_run_dist") * self ai::get_behavior_attribute("min_run_dist");
	run_yaw = 20;
	run_pitch = 30;
	run_height = 64;
	if(self.health < self.maxhealth)
	{
		return true;
	}
	if(!isdefined(self.enemy) || !isalive(self.enemy))
	{
		return false;
	}
	if(!self cansee(self.enemy))
	{
		return false;
	}
	dist = distancesquared(self.origin, self.enemy.origin);
	if(dist > run_dist_squared)
	{
		return false;
	}
	height = self.origin[2] - self.enemy.origin[2];
	if(abs(height) > run_height)
	{
		return false;
	}
	yaw = self absyawtoenemy();
	if(yaw > run_yaw)
	{
		return false;
	}
	pitch = angleclamp180(vectortoangles(self.origin - self.enemy.origin)[0]);
	if(abs(pitch) > run_pitch)
	{
		return false;
	}
	return true;
}

/*
	Name: is_target_valid
	Namespace: zombiedogbehavior
	Checksum: 0x51D4D9A5
	Offset: 0xBD8
	Size: 0x1EC
	Parameters: 2
	Flags: Linked, Private
*/
function private is_target_valid(dog, target)
{
	if(!isdefined(target))
	{
		return 0;
	}
	if(!isalive(target))
	{
		return 0;
	}
	if(!dog.team == "allies")
	{
		if(!isplayer(target) && sessionmodeiszombiesgame())
		{
			return 0;
		}
		if(isdefined(target.is_zombie) && target.is_zombie == 1)
		{
			return 0;
		}
	}
	if(isplayer(target) && target.sessionstate == "spectator")
	{
		return 0;
	}
	if(isplayer(target) && target.sessionstate == "intermission")
	{
		return 0;
	}
	if(isdefined(self.intermission) && self.intermission)
	{
		return 0;
	}
	if(isdefined(target.ignoreme) && target.ignoreme)
	{
		return 0;
	}
	if(target isnotarget())
	{
		return 0;
	}
	if(dog.team == target.team)
	{
		return 0;
	}
	if(isplayer(target) && isdefined(level.is_player_valid_override))
	{
		return [[level.is_player_valid_override]](target);
	}
	return 1;
}

/*
	Name: get_favorite_enemy
	Namespace: zombiedogbehavior
	Checksum: 0x58636A97
	Offset: 0xDD0
	Size: 0x26C
	Parameters: 1
	Flags: Linked, Private
*/
function private get_favorite_enemy(dog)
{
	dog_targets = [];
	if(sessionmodeiszombiesgame())
	{
		if(self.team == "allies")
		{
			dog_targets = getaiteamarray(level.zombie_team);
		}
		else
		{
			dog_targets = getplayers();
		}
	}
	else
	{
		dog_targets = arraycombine(getplayers(), getaiarray(), 0, 0);
	}
	least_hunted = dog_targets[0];
	closest_target_dist_squared = undefined;
	for(i = 0; i < dog_targets.size; i++)
	{
		if(!isdefined(dog_targets[i].hunted_by))
		{
			dog_targets[i].hunted_by = 0;
		}
		if(!is_target_valid(dog, dog_targets[i]))
		{
			continue;
		}
		if(!is_target_valid(dog, least_hunted))
		{
			least_hunted = dog_targets[i];
		}
		dist_squared = distancesquared(dog.origin, dog_targets[i].origin);
		if(dog_targets[i].hunted_by <= least_hunted.hunted_by && (!isdefined(closest_target_dist_squared) || dist_squared < closest_target_dist_squared))
		{
			least_hunted = dog_targets[i];
			closest_target_dist_squared = dist_squared;
		}
	}
	if(!is_target_valid(dog, least_hunted))
	{
		return undefined;
	}
	least_hunted.hunted_by = least_hunted.hunted_by + 1;
	return least_hunted;
}

/*
	Name: get_last_valid_position
	Namespace: zombiedogbehavior
	Checksum: 0xF80434A
	Offset: 0x1048
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function get_last_valid_position()
{
	if(isplayer(self))
	{
		return self.last_valid_position;
	}
	return self.origin;
}

/*
	Name: get_locomotion_target
	Namespace: zombiedogbehavior
	Checksum: 0xE0F97C6E
	Offset: 0x1080
	Size: 0x280
	Parameters: 1
	Flags: Linked
*/
function get_locomotion_target(behaviortreeentity)
{
	last_valid_position = behaviortreeentity.favoriteenemy get_last_valid_position();
	if(!isdefined(last_valid_position))
	{
		return undefined;
	}
	locomotion_target = last_valid_position;
	if(ai::has_behavior_attribute("spacing_value"))
	{
		spacing_near_dist = ai::get_behavior_attribute("spacing_near_dist");
		spacing_far_dist = ai::get_behavior_attribute("spacing_far_dist");
		spacing_horz_dist = ai::get_behavior_attribute("spacing_horz_dist");
		spacing_value = ai::get_behavior_attribute("spacing_value");
		to_enemy = behaviortreeentity.favoriteenemy.origin - behaviortreeentity.origin;
		perp = vectornormalize((to_enemy[1] * -1, to_enemy[0], 0));
		offset = (perp * spacing_horz_dist) * spacing_value;
		spacing_dist = math::clamp(length(to_enemy), spacing_near_dist, spacing_far_dist);
		lerp_amount = math::clamp((spacing_dist - spacing_near_dist) / (spacing_far_dist - spacing_near_dist), 0, 1);
		desired_point = last_valid_position + (offset * lerp_amount);
		desired_point = getclosestpointonnavmesh(desired_point, spacing_horz_dist * 1.2, 16);
		if(isdefined(desired_point))
		{
			locomotion_target = desired_point;
		}
	}
	return locomotion_target;
}

/*
	Name: zombiedogtargetservice
	Namespace: zombiedogbehavior
	Checksum: 0xAE29F58E
	Offset: 0x1308
	Size: 0x3C0
	Parameters: 1
	Flags: Linked
*/
function zombiedogtargetservice(behaviortreeentity)
{
	if(isdefined(level.intermission) && level.intermission)
	{
		behaviortreeentity clearpath();
		return;
	}
	/#
		if(isdefined(behaviortreeentity.ispuppet) && behaviortreeentity.ispuppet)
		{
			return;
		}
	#/
	if(behaviortreeentity.ignoreall || behaviortreeentity.pacifist || (isdefined(behaviortreeentity.favoriteenemy) && !is_target_valid(behaviortreeentity, behaviortreeentity.favoriteenemy)))
	{
		if(isdefined(behaviortreeentity.favoriteenemy) && isdefined(behaviortreeentity.favoriteenemy.hunted_by) && behaviortreeentity.favoriteenemy.hunted_by > 0)
		{
			behaviortreeentity.favoriteenemy.hunted_by--;
		}
		behaviortreeentity.favoriteenemy = undefined;
		behaviortreeentity.hasseenfavoriteenemy = 0;
		if(!behaviortreeentity.ignoreall)
		{
			behaviortreeentity setgoal(behaviortreeentity.origin);
		}
		return;
	}
	if(isdefined(behaviortreeentity.ignoreme) && behaviortreeentity.ignoreme)
	{
		return;
	}
	if(!sessionmodeiszombiesgame() || behaviortreeentity.team == "allies" && !is_target_valid(behaviortreeentity, behaviortreeentity.favoriteenemy))
	{
		behaviortreeentity.favoriteenemy = get_favorite_enemy(behaviortreeentity);
	}
	if(!(isdefined(behaviortreeentity.hasseenfavoriteenemy) && behaviortreeentity.hasseenfavoriteenemy))
	{
		if(isdefined(behaviortreeentity.favoriteenemy) && behaviortreeentity need_to_run())
		{
			behaviortreeentity.hasseenfavoriteenemy = 1;
		}
	}
	if(isdefined(behaviortreeentity.favoriteenemy))
	{
		if(isdefined(level.enemy_location_override_func))
		{
			goalpos = [[level.enemy_location_override_func]](behaviortreeentity, behaviortreeentity.favoriteenemy);
			if(isdefined(goalpos))
			{
				behaviortreeentity setgoal(goalpos);
				return;
			}
		}
		locomotion_target = get_locomotion_target(behaviortreeentity);
		if(isdefined(locomotion_target))
		{
			repathdist = 16;
			if(!isdefined(behaviortreeentity.lasttargetposition) || distancesquared(behaviortreeentity.lasttargetposition, locomotion_target) > (repathdist * repathdist) || !behaviortreeentity haspath())
			{
				behaviortreeentity useposition(locomotion_target);
				behaviortreeentity.lasttargetposition = locomotion_target;
			}
		}
	}
}

/*
	Name: zombiedogshouldmelee
	Namespace: zombiedogbehavior
	Checksum: 0x8C4C8C99
	Offset: 0x16D0
	Size: 0x1E8
	Parameters: 1
	Flags: Linked
*/
function zombiedogshouldmelee(behaviortreeentity)
{
	if(behaviortreeentity.ignoreall || !is_target_valid(behaviortreeentity, behaviortreeentity.favoriteenemy))
	{
		return false;
	}
	if(!(isdefined(level.intermission) && level.intermission))
	{
		meleedist = 72;
		if(distancesquared(behaviortreeentity.origin, behaviortreeentity.favoriteenemy.origin) < (meleedist * meleedist) && behaviortreeentity cansee(behaviortreeentity.favoriteenemy))
		{
			dog_eye = behaviortreeentity.origin + vectorscale((0, 0, 1), 40);
			enemy_eye = behaviortreeentity.favoriteenemy geteye();
			clip_mask = 1 | 8;
			trace = physicstrace(dog_eye, enemy_eye, (0, 0, 0), (0, 0, 0), self, clip_mask);
			can_melee = trace["fraction"] == 1 || (isdefined(trace["entity"]) && trace["entity"] == behaviortreeentity.favoriteenemy);
			if(isdefined(can_melee) && can_melee)
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: zombiedogshouldwalk
	Namespace: zombiedogbehavior
	Checksum: 0x3B6EAC05
	Offset: 0x18C0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function zombiedogshouldwalk(behaviortreeentity)
{
	return bb_getshouldrunstatus() == "walk";
}

/*
	Name: zombiedogshouldrun
	Namespace: zombiedogbehavior
	Checksum: 0xA7BA0B7B
	Offset: 0x18F0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function zombiedogshouldrun(behaviortreeentity)
{
	return bb_getshouldrunstatus() == "run";
}

/*
	Name: use_low_attack
	Namespace: zombiedogbehavior
	Checksum: 0x515F4316
	Offset: 0x1920
	Size: 0x166
	Parameters: 0
	Flags: Linked
*/
function use_low_attack()
{
	if(!isdefined(self.enemy) || !isplayer(self.enemy))
	{
		return false;
	}
	height_diff = self.enemy.origin[2] - self.origin[2];
	low_enough = 30;
	if(height_diff < low_enough && self.enemy getstance() == "prone")
	{
		return true;
	}
	melee_origin = (self.origin[0], self.origin[1], self.origin[2] + 65);
	enemy_origin = (self.enemy.origin[0], self.enemy.origin[1], self.enemy.origin[2] + 32);
	if(!bullettracepassed(melee_origin, enemy_origin, 0, self))
	{
		return true;
	}
	return false;
}

/*
	Name: zombiedogmeleeaction
	Namespace: zombiedogbehavior
	Checksum: 0xC19E23DD
	Offset: 0x1A90
	Size: 0xA0
	Parameters: 2
	Flags: Linked
*/
function zombiedogmeleeaction(behaviortreeentity, asmstatename)
{
	behaviortreeentity clearpath();
	context = "high";
	if(behaviortreeentity use_low_attack())
	{
		context = "low";
	}
	blackboard::setblackboardattribute(behaviortreeentity, "_context", context);
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	return 5;
}

/*
	Name: zombiedogmeleeactionterminate
	Namespace: zombiedogbehavior
	Checksum: 0xE2F947DC
	Offset: 0x1B38
	Size: 0x38
	Parameters: 2
	Flags: Linked
*/
function zombiedogmeleeactionterminate(behaviortreeentity, asmstatename)
{
	blackboard::setblackboardattribute(behaviortreeentity, "_context", undefined);
	return 4;
}

/*
	Name: zombiedoggravity
	Namespace: zombiedogbehavior
	Checksum: 0x217E011F
	Offset: 0x1B78
	Size: 0x44
	Parameters: 4
	Flags: Linked
*/
function zombiedoggravity(entity, attribute, oldvalue, value)
{
	blackboard::setblackboardattribute(entity, "_low_gravity", value);
}

