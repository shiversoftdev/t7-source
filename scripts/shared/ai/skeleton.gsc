// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace skeletonbehavior;

/*
	Name: __init__sytem__
	Namespace: skeletonbehavior
	Checksum: 0x96D46297
	Offset: 0x530
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("skeleton", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: skeletonbehavior
	Checksum: 0x458A2A71
	Offset: 0x570
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	initskeletonbehaviorsandasm();
	spawner::add_archetype_spawn_function("skeleton", &archetypeskeletonblackboardinit);
	spawner::add_archetype_spawn_function("skeleton", &skeletonspawnsetup);
	if(ai::shouldregisterclientfieldforarchetype("skeleton"))
	{
		clientfield::register("actor", "skeleton", 1, 1, "int");
	}
}

/*
	Name: skeletonspawnsetup
	Namespace: skeletonbehavior
	Checksum: 0xAFCDB836
	Offset: 0x628
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function skeletonspawnsetup()
{
	self.zombie_move_speed = "walk";
	if(randomint(2) == 0)
	{
		self.zombie_arms_position = "up";
	}
	else
	{
		self.zombie_arms_position = "down";
	}
	self.missinglegs = 0;
	self setavoidancemask("avoid none");
	self pushactors(1);
	clientfield::set("skeleton", 1);
}

/*
	Name: initskeletonbehaviorsandasm
	Namespace: skeletonbehavior
	Checksum: 0xCA7EE6FC
	Offset: 0x6F0
	Size: 0xF4
	Parameters: 0
	Flags: Linked, Private
*/
function private initskeletonbehaviorsandasm()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("skeletonTargetService", &skeletontargetservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("skeletonShouldMelee", &skeletonshouldmeleecondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("skeletonGibLegsCondition", &skeletongiblegscondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isSkeletonWalking", &isskeletonwalking);
	behaviortreenetworkutility::registerbehaviortreescriptapi("skeletonDeathAction", &skeletondeathaction);
	animationstatenetwork::registernotetrackhandlerfunction("contact", &skeletonnotetrackmeleefire);
}

/*
	Name: archetypeskeletonblackboardinit
	Namespace: skeletonbehavior
	Checksum: 0xE6F828D0
	Offset: 0x7F0
	Size: 0x24C
	Parameters: 0
	Flags: Linked, Private
*/
function private archetypeskeletonblackboardinit()
{
	blackboard::createblackboardforentity(self);
	self aiutility::registerutilityblackboardattributes();
	blackboard::registerblackboardattribute(self, "_arms_position", "arms_up", &bb_getarmsposition);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_locomotion_speed", "locomotion_speed_walk", &bb_getlocomotionspeedtype);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_has_legs", "has_legs_yes", &bb_gethaslegsstatus);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_which_board_pull", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_board_attack_spot", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	self.___archetypeonanimscriptedcallback = &archetypeskeletononanimscriptedcallback;
	/#
		self finalizetrackedblackboardattributes();
	#/
}

/*
	Name: archetypeskeletononanimscriptedcallback
	Namespace: skeletonbehavior
	Checksum: 0x8F26919B
	Offset: 0xA48
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private archetypeskeletononanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity archetypeskeletonblackboardinit();
}

/*
	Name: bb_getarmsposition
	Namespace: skeletonbehavior
	Checksum: 0x3EB6F2A6
	Offset: 0xA88
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function bb_getarmsposition()
{
	if(isdefined(self.skeleton_arms_position))
	{
		if(self.zombie_arms_position == "up")
		{
			return "arms_up";
		}
		return "arms_down";
	}
	return "arms_up";
}

/*
	Name: bb_getlocomotionspeedtype
	Namespace: skeletonbehavior
	Checksum: 0x7DB12759
	Offset: 0xAD0
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function bb_getlocomotionspeedtype()
{
	if(isdefined(self.zombie_move_speed))
	{
		if(self.zombie_move_speed == "walk")
		{
			return "locomotion_speed_walk";
		}
		if(self.zombie_move_speed == "run")
		{
			return "locomotion_speed_run";
		}
		if(self.zombie_move_speed == "sprint")
		{
			return "locomotion_speed_sprint";
		}
		if(self.zombie_move_speed == "super_sprint")
		{
			return "locomotion_speed_super_sprint";
		}
	}
	return "locomotion_speed_walk";
}

/*
	Name: bb_gethaslegsstatus
	Namespace: skeletonbehavior
	Checksum: 0x928F481D
	Offset: 0xB70
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function bb_gethaslegsstatus()
{
	if(self.missinglegs)
	{
		return "has_legs_no";
	}
	return "has_legs_yes";
}

/*
	Name: isskeletonwalking
	Namespace: skeletonbehavior
	Checksum: 0xA13D6678
	Offset: 0xB98
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function isskeletonwalking(behaviortreeentity)
{
	if(!isdefined(behaviortreeentity.zombie_move_speed))
	{
		return 1;
	}
	return behaviortreeentity.zombie_move_speed == "walk" && (!(isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs)) && behaviortreeentity.zombie_arms_position == "up";
}

/*
	Name: skeletongiblegscondition
	Namespace: skeletonbehavior
	Checksum: 0x2F256BB4
	Offset: 0xC20
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function skeletongiblegscondition(behaviortreeentity)
{
	return gibserverutils::isgibbed(behaviortreeentity, 256) || gibserverutils::isgibbed(behaviortreeentity, 128);
}

/*
	Name: skeletonnotetrackmeleefire
	Namespace: skeletonbehavior
	Checksum: 0xE809DB28
	Offset: 0xC70
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function skeletonnotetrackmeleefire(animationentity)
{
	hitent = animationentity melee();
	if(isdefined(hitent) && isdefined(animationentity.aux_melee_damage) && self.team != hitent.team)
	{
		animationentity [[animationentity.aux_melee_damage]](hitent);
	}
}

/*
	Name: is_within_fov
	Namespace: skeletonbehavior
	Checksum: 0xA5A69F62
	Offset: 0xCF8
	Size: 0xA2
	Parameters: 4
	Flags: Linked
*/
function is_within_fov(start_origin, start_angles, end_origin, fov)
{
	normal = vectornormalize(end_origin - start_origin);
	forward = anglestoforward(start_angles);
	dot = vectordot(forward, normal);
	return dot >= fov;
}

/*
	Name: skeletoncanseeplayer
	Namespace: skeletonbehavior
	Checksum: 0x9D5917CF
	Offset: 0xDA8
	Size: 0x1EE
	Parameters: 1
	Flags: Linked
*/
function skeletoncanseeplayer(player)
{
	self endon(#"death");
	if(!isdefined(self.players_viscache))
	{
		self.players_viscache = [];
	}
	entnum = player getentitynumber();
	if(!isdefined(self.players_viscache[entnum]))
	{
		self.players_viscache[entnum] = 0;
	}
	if(self.players_viscache[entnum] > gettime())
	{
		return true;
	}
	zombie_eye = self.origin + vectorscale((0, 0, 1), 40);
	player_pos = player.origin + vectorscale((0, 0, 1), 40);
	distancesq = distancesquared(zombie_eye, player_pos);
	if(distancesq < 4096)
	{
		self.players_viscache[entnum] = gettime() + 3000;
		return true;
	}
	if(distancesq > 1048576)
	{
		return false;
	}
	if(is_within_fov(zombie_eye, self.angles, player_pos, cos(60)))
	{
		trace = groundtrace(zombie_eye, player_pos, 0, undefined);
		if(trace["fraction"] < 1)
		{
			return false;
		}
		self.players_viscache[entnum] = gettime() + 3000;
		return true;
	}
	return false;
}

/*
	Name: is_player_valid
	Namespace: skeletonbehavior
	Checksum: 0x70D1EDCF
	Offset: 0xFA0
	Size: 0x170
	Parameters: 3
	Flags: Linked
*/
function is_player_valid(player, checkignoremeflag, ignore_laststand_players)
{
	if(!isdefined(player))
	{
		return 0;
	}
	if(!isalive(player))
	{
		return 0;
	}
	if(!isplayer(player))
	{
		return 0;
	}
	if(isdefined(player.is_zombie) && player.is_zombie == 1)
	{
		return 0;
	}
	if(player.sessionstate == "spectator")
	{
		return 0;
	}
	if(player.sessionstate == "intermission")
	{
		return 0;
	}
	if(isdefined(self.intermission) && self.intermission)
	{
		return 0;
	}
	if(!(isdefined(ignore_laststand_players) && ignore_laststand_players))
	{
		if(player laststand::player_is_in_laststand())
		{
			return 0;
		}
	}
	if(isdefined(checkignoremeflag) && checkignoremeflag && player.ignoreme)
	{
		return 0;
	}
	if(isdefined(level.is_player_valid_override))
	{
		return [[level.is_player_valid_override]](player);
	}
	return 1;
}

/*
	Name: get_closest_valid_player
	Namespace: skeletonbehavior
	Checksum: 0x318714E4
	Offset: 0x1118
	Size: 0x254
	Parameters: 2
	Flags: Linked
*/
function get_closest_valid_player(origin, ignore_player)
{
	valid_player_found = 0;
	players = getplayers();
	if(isdefined(ignore_player))
	{
		for(i = 0; i < ignore_player.size; i++)
		{
			arrayremovevalue(players, ignore_player[i]);
		}
	}
	done = 0;
	while(players.size && !done)
	{
		done = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!is_player_valid(player, 1))
			{
				arrayremovevalue(players, player);
				done = 0;
				break;
			}
		}
	}
	if(players.size == 0)
	{
		return undefined;
	}
	if(!valid_player_found)
	{
		for(;;)
		{
			player = [[self.closest_player_override]](origin, players);
			player = [[level.closest_player_override]](origin, players);
			player = arraygetclosest(origin, players);
			return undefined;
			arrayremovevalue(players, player);
			return undefined;
		}
		if(isdefined(self.closest_player_override))
		{
		}
		else
		{
			if(isdefined(level.closest_player_override))
			{
			}
			else
			{
			}
		}
		if(!isdefined(player) || players.size == 0)
		{
		}
		if(!is_player_valid(player, 1))
		{
			if(players.size == 0)
			{
			}
		}
		return player;
	}
}

/*
	Name: skeletonsetgoal
	Namespace: skeletonbehavior
	Checksum: 0x320D3F74
	Offset: 0x1378
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function skeletonsetgoal(goal)
{
	if(isdefined(self.setgoaloverridecb))
	{
		return [[self.setgoaloverridecb]](goal);
	}
	self setgoal(goal);
}

/*
	Name: skeletontargetservice
	Namespace: skeletonbehavior
	Checksum: 0x2B5A36DD
	Offset: 0x13D0
	Size: 0x3AE
	Parameters: 1
	Flags: Linked
*/
function skeletontargetservice(behaviortreeentity)
{
	self endon(#"death");
	if(isdefined(behaviortreeentity.ignoreall) && behaviortreeentity.ignoreall)
	{
		return false;
	}
	if(isdefined(behaviortreeentity.enemy) && behaviortreeentity.enemy.team == behaviortreeentity.team)
	{
		behaviortreeentity clearentitytarget();
	}
	if(behaviortreeentity.team == "allies")
	{
		if(isdefined(behaviortreeentity.favoriteenemy))
		{
			behaviortreeentity skeletonsetgoal(behaviortreeentity.favoriteenemy.origin);
			return true;
		}
		if(isdefined(behaviortreeentity.enemy))
		{
			behaviortreeentity skeletonsetgoal(behaviortreeentity.enemy.origin);
			return true;
		}
		target = getclosesttome(getaiteamarray("axis"));
		if(isdefined(target))
		{
			behaviortreeentity skeletonsetgoal(target.origin);
			return true;
		}
		behaviortreeentity skeletonsetgoal(behaviortreeentity.origin);
		return false;
	}
	player = get_closest_valid_player(behaviortreeentity.origin, behaviortreeentity.ignore_player);
	if(!isdefined(player))
	{
		if(isdefined(behaviortreeentity.ignore_player))
		{
			if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
			{
				return;
			}
			behaviortreeentity.ignore_player = [];
		}
		behaviortreeentity skeletonsetgoal(behaviortreeentity.origin);
		return false;
	}
	if(isdefined(player.last_valid_position))
	{
		cansee = self skeletoncanseeplayer(player);
		if(cansee)
		{
			behaviortreeentity skeletonsetgoal(player.last_valid_position);
			return true;
		}
		influencepos = undefined;
		if(isdefined(influencepos))
		{
			if(distancesquared(influencepos, behaviortreeentity.origin) > 1024)
			{
				behaviortreeentity skeletonsetgoal(influencepos);
				return true;
			}
			behaviortreeentity clearpath();
			return false;
		}
		behaviortreeentity clearpath();
		return false;
	}
	behaviortreeentity skeletonsetgoal(behaviortreeentity.origin);
	return false;
}

/*
	Name: isvalidenemy
	Namespace: skeletonbehavior
	Checksum: 0xCB115589
	Offset: 0x1788
	Size: 0x1E
	Parameters: 1
	Flags: Linked
*/
function isvalidenemy(enemy)
{
	if(!isdefined(enemy))
	{
		return false;
	}
	return true;
}

/*
	Name: getyaw
	Namespace: skeletonbehavior
	Checksum: 0x514FEE29
	Offset: 0x17B0
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
	Name: getyawtoenemy
	Namespace: skeletonbehavior
	Checksum: 0x7643419D
	Offset: 0x1800
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function getyawtoenemy()
{
	pos = undefined;
	if(isvalidenemy(self.enemy))
	{
		pos = self.enemy.origin;
	}
	else
	{
		forward = anglestoforward(self.angles);
		forward = vectorscale(forward, 150);
		pos = self.origin + forward;
	}
	yaw = self.angles[1] - getyaw(pos);
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: skeletonshouldmeleecondition
	Namespace: skeletonbehavior
	Checksum: 0x6EC76839
	Offset: 0x18F0
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function skeletonshouldmeleecondition(behaviortreeentity)
{
	if(!isdefined(behaviortreeentity.enemy))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.marked_for_death))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.stunned) && behaviortreeentity.stunned)
	{
		return false;
	}
	yaw = abs(getyawtoenemy());
	if(yaw > 45)
	{
		return false;
	}
	if(distancesquared(behaviortreeentity.origin, behaviortreeentity.enemy.origin) < 4096)
	{
		return true;
	}
	return false;
}

/*
	Name: skeletondeathaction
	Namespace: skeletonbehavior
	Checksum: 0xE713A185
	Offset: 0x19E8
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function skeletondeathaction(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.deathfunction))
	{
		behaviortreeentity [[behaviortreeentity.deathfunction]]();
	}
}

/*
	Name: getclosestto
	Namespace: skeletonbehavior
	Checksum: 0x1C79AF1C
	Offset: 0x1A28
	Size: 0x4A
	Parameters: 2
	Flags: Linked
*/
function getclosestto(origin, entarray)
{
	if(!isdefined(entarray))
	{
		return;
	}
	if(entarray.size == 0)
	{
		return;
	}
	return arraygetclosest(origin, entarray);
}

/*
	Name: getclosesttome
	Namespace: skeletonbehavior
	Checksum: 0x33AE1253
	Offset: 0x1A80
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function getclosesttome(entarray)
{
	return getclosestto(self.origin, entarray);
}

