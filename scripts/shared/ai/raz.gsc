// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
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
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace razbehavior;

/*
	Name: init
	Namespace: razbehavior
	Checksum: 0xC94AB4BB
	Offset: 0xA60
	Size: 0x244
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initrazbehaviorsandasm();
	spawner::add_archetype_spawn_function("raz", &archetyperazblackboardinit);
	spawner::add_archetype_spawn_function("raz", &razserverutils::razspawnsetup);
	clientfield::register("scriptmover", "raz_detonate_ground_torpedo", 12000, 1, "int");
	clientfield::register("scriptmover", "raz_torpedo_play_fx_on_self", 12000, 1, "int");
	clientfield::register("scriptmover", "raz_torpedo_play_trail", 12000, 1, "counter");
	clientfield::register("actor", "raz_detach_gun", 12000, 1, "int");
	clientfield::register("actor", "raz_gun_weakpoint_hit", 12000, 1, "counter");
	clientfield::register("actor", "raz_detach_helmet", 12000, 1, "int");
	clientfield::register("actor", "raz_detach_chest_armor", 12000, 1, "int");
	clientfield::register("actor", "raz_detach_l_shoulder_armor", 12000, 1, "int");
	clientfield::register("actor", "raz_detach_r_thigh_armor", 12000, 1, "int");
	clientfield::register("actor", "raz_detach_l_thigh_armor", 12000, 1, "int");
}

/*
	Name: initrazbehaviorsandasm
	Namespace: razbehavior
	Checksum: 0x5B252FB7
	Offset: 0xCB0
	Size: 0x2D4
	Parameters: 0
	Flags: Linked, Private
*/
function private initrazbehaviorsandasm()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("razTargetService", &raztargetservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razSprintService", &razsprintservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razShouldMelee", &razshouldmelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razShouldShowPain", &razshouldshowpain);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razShouldShowSpecialPain", &razshouldshowspecialpain);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razShouldShowShieldPain", &razshouldshowshieldpain);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razShouldShootGroundTorpedo", &razshouldshootgroundtorpedo);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razShouldGoBerserk", &razshouldgoberserk);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razShouldTraverseWindow", &razshouldtraversewindow);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razStartMelee", &razstartmelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razFinishMelee", &razfinishmelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razFinishGroundTorpedo", &razfinishgroundtorpedo);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razGoneBerserk", &razgoneberserk);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razStartTraverseWindow", &razstarttraversewindow);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razFinishTraverseWindow", &razfinishtraversewindow);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razTookPain", &raztookpain);
	behaviortreenetworkutility::registerbehaviortreescriptapi("razStartDeath", &razstartdeath);
	animationstatenetwork::registernotetrackhandlerfunction("mangler_fire", &raznotetrackshootgroundtorpedo);
}

/*
	Name: archetyperazblackboardinit
	Namespace: razbehavior
	Checksum: 0xB7600660
	Offset: 0xF90
	Size: 0x24C
	Parameters: 0
	Flags: Linked, Private
*/
function private archetyperazblackboardinit()
{
	blackboard::createblackboardforentity(self);
	self aiutility::registerutilityblackboardattributes();
	blackboard::registerblackboardattribute(self, "_gibbed_limbs", "none", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_locomotion_speed", "locomotion_speed_walk", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_locomotion_should_turn", "should_not_turn", &bb_getshouldturn);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_zombie_damageweapon_type", "regular", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_gib_location", "legs", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	self.___archetypeonanimscriptedcallback = &archetyperazonanimscriptedcallback;
	/#
		self finalizetrackedblackboardattributes();
	#/
}

/*
	Name: archetyperazonanimscriptedcallback
	Namespace: razbehavior
	Checksum: 0xDE2514D4
	Offset: 0x11E8
	Size: 0xD4
	Parameters: 1
	Flags: Linked, Private
*/
function private archetyperazonanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity archetyperazblackboardinit();
	if(isdefined(entity.started_running) && entity.started_running)
	{
		entity.invoke_sprint_time = undefined;
		blackboard::setblackboardattribute(entity, "_locomotion_speed", "locomotion_speed_sprint");
	}
	if(!(isdefined(entity.razhasgunattached) && entity.razhasgunattached))
	{
		blackboard::setblackboardattribute(entity, "_gibbed_limbs", "right_arm");
	}
}

/*
	Name: bb_getshouldturn
	Namespace: razbehavior
	Checksum: 0x43C0E8AC
	Offset: 0x12C8
	Size: 0x2A
	Parameters: 0
	Flags: Linked, Private
*/
function private bb_getshouldturn()
{
	if(isdefined(self.should_turn) && self.should_turn)
	{
		return "should_turn";
	}
	return "should_not_turn";
}

/*
	Name: findnodesservice
	Namespace: razbehavior
	Checksum: 0x340080BC
	Offset: 0x1300
	Size: 0x22E
	Parameters: 1
	Flags: Linked
*/
function findnodesservice(behaviortreeentity)
{
	node = undefined;
	behaviortreeentity.entrance_nodes = [];
	if(isdefined(behaviortreeentity.find_flesh_struct_string))
	{
		if(behaviortreeentity.find_flesh_struct_string == "find_flesh")
		{
			return false;
		}
		for(i = 0; i < level.exterior_goals.size; i++)
		{
			if(isdefined(level.exterior_goals[i].script_string) && level.exterior_goals[i].script_string == behaviortreeentity.find_flesh_struct_string)
			{
				node = level.exterior_goals[i];
				break;
			}
		}
		behaviortreeentity.entrance_nodes[behaviortreeentity.entrance_nodes.size] = node;
		/#
			assert(isdefined(node), ("" + behaviortreeentity.find_flesh_struct_string) + "");
		#/
		behaviortreeentity.first_node = node;
		behaviortreeentity.goalradius = 80;
		behaviortreeentity.mocomp_barricade_offset = getdvarint("raz_node_origin_offset", -22);
		node_origin = node.origin + (anglestoforward(node.angles) * behaviortreeentity.mocomp_barricade_offset);
		behaviortreeentity setgoal(node_origin);
		if(zm_behavior::zombieisatentrance(behaviortreeentity))
		{
			behaviortreeentity.got_to_entrance = 1;
		}
		return true;
	}
}

/*
	Name: shouldskipteardown
	Namespace: razbehavior
	Checksum: 0xEA70976C
	Offset: 0x1538
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function shouldskipteardown(entity)
{
	if(isdefined(entity.destroying_window) && entity.destroying_window)
	{
		return true;
	}
	if(!isdefined(entity.script_string) || entity.script_string == "find_flesh")
	{
		return true;
	}
	return false;
}

/*
	Name: razgetnondestroyedchuncks
	Namespace: razbehavior
	Checksum: 0x2554564B
	Offset: 0x15B0
	Size: 0x54
	Parameters: 0
	Flags: Linked, Private
*/
function private razgetnondestroyedchuncks()
{
	chunks = undefined;
	if(isdefined(self.first_node))
	{
		chunks = zm_utility::get_non_destroyed_chunks(self.first_node, self.first_node.barrier_chunks);
	}
	return chunks;
}

/*
	Name: razdestroywindow
	Namespace: razbehavior
	Checksum: 0xD82C6E29
	Offset: 0x1610
	Size: 0x21E
	Parameters: 2
	Flags: Linked, Private
*/
function private razdestroywindow(entity, b_destroy_actual_pieces)
{
	if(!(isdefined(b_destroy_actual_pieces) && b_destroy_actual_pieces))
	{
		entity.got_to_entrance = 0;
		entity.destroying_window = 1;
		entity forceteleport(entity.origin, entity.first_node.angles);
		chunks = entity razgetnondestroyedchuncks();
		if(!isdefined(chunks) || chunks.size == 0)
		{
			entity.jump_through_window = 1;
			entity.jump_through_window_angle = entity.angles;
		}
		else
		{
			if(isdefined(entity.razhasgunattached) && entity.razhasgunattached)
			{
				entity.destroy_window_by_torpedo = 1;
			}
			else
			{
				entity.destroy_window_by_melee = 1;
			}
		}
	}
	else
	{
		entity.jump_through_window = 1;
		entity.jump_through_window_angle = entity.angles;
		if(isdefined(entity.first_node))
		{
			chunks = entity razgetnondestroyedchuncks();
			if(isdefined(chunks))
			{
				for(i = 0; i < chunks.size; i++)
				{
					entity.first_node.zbarrier setzbarrierpiecestate(chunks[i], "opening", 0.2);
				}
			}
		}
	}
}

/*
	Name: raztargetservice
	Namespace: razbehavior
	Checksum: 0x202B5C51
	Offset: 0x1838
	Size: 0x36E
	Parameters: 1
	Flags: Linked, Private
*/
function private raztargetservice(entity)
{
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return false;
	}
	if(isdefined(entity.jump_through_window) && entity.jump_through_window)
	{
		return false;
	}
	if(!zm_behavior::inplayablearea(entity) && !shouldskipteardown(entity))
	{
		if(isdefined(entity.got_to_entrance) && entity.got_to_entrance)
		{
			razdestroywindow(entity);
		}
		else
		{
			if(zm_behavior::zombieenteredplayable(entity))
			{
				return false;
			}
			findnodesservice(entity);
		}
		return false;
	}
	if(level.zombie_poi_array.size > 0)
	{
		zombie_poi = entity zm_utility::get_zombie_point_of_interest(entity.origin);
		if(isdefined(zombie_poi))
		{
			targetpos = getclosestpointonnavmesh(zombie_poi[0], 64, 30);
			entity.zombie_poi = zombie_poi;
			entity.enemyoverride = zombie_poi;
			if(isdefined(targetpos))
			{
				self setgoal(targetpos);
			}
			else
			{
				self setgoal(zombie_poi[0]);
			}
			return;
		}
		entity.zombie_poi = undefined;
		entity.enemyoverride = undefined;
	}
	else
	{
		entity.zombie_poi = undefined;
		entity.enemyoverride = undefined;
	}
	player = zombie_utility::get_closest_valid_player(self.origin, self.ignore_player, 1);
	entity.favoriteenemy = player;
	if(!isdefined(player) || player isnotarget())
	{
		if(isdefined(self.ignore_player))
		{
			if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
			{
				return;
			}
			self.ignore_player = [];
		}
		self setgoal(self.origin);
		return false;
	}
	targetpos = getclosestpointonnavmesh(player.origin, 64, 30);
	if(isdefined(targetpos))
	{
		entity setgoal(targetpos);
		return true;
	}
	entity setgoal(entity.origin);
	return false;
}

/*
	Name: razsprintservice
	Namespace: razbehavior
	Checksum: 0xF3C5CA2
	Offset: 0x1BB0
	Size: 0xD4
	Parameters: 1
	Flags: Linked, Private
*/
function private razsprintservice(entity)
{
	if(isdefined(entity.started_running) && entity.started_running)
	{
		return false;
	}
	if(!isdefined(entity.invoke_sprint_time))
	{
		return false;
	}
	if(gettime() > entity.invoke_sprint_time)
	{
		entity.invoke_sprint_time = undefined;
		entity.started_running = 1;
		entity.berserk = 1;
		entity thread razsprintknockdownzombies();
		blackboard::setblackboardattribute(entity, "_locomotion_speed", "locomotion_speed_sprint");
	}
}

/*
	Name: razshouldmelee
	Namespace: razbehavior
	Checksum: 0x505E2969
	Offset: 0x1C90
	Size: 0xD6
	Parameters: 1
	Flags: Linked
*/
function razshouldmelee(entity)
{
	if(isdefined(entity.destroy_window_by_melee) && entity.destroy_window_by_melee)
	{
		return true;
	}
	if(!isdefined(entity.enemy))
	{
		return false;
	}
	if(distancesquared(entity.origin, entity.enemy.origin) > 5625)
	{
		return false;
	}
	yaw = abs(zombie_utility::getyawtoenemy());
	if(yaw > 45)
	{
		return false;
	}
	return true;
}

/*
	Name: razshouldshowpain
	Namespace: razbehavior
	Checksum: 0x601E170B
	Offset: 0x1D70
	Size: 0x60
	Parameters: 1
	Flags: Linked, Private
*/
function private razshouldshowpain(entity)
{
	if(isdefined(entity.berserk) && entity.berserk && (!(isdefined(entity.razhasgoneberserk) && entity.razhasgoneberserk)))
	{
		return false;
	}
	return true;
}

/*
	Name: razshouldshowspecialpain
	Namespace: razbehavior
	Checksum: 0x88DC2499
	Offset: 0x1DD8
	Size: 0xC4
	Parameters: 1
	Flags: Linked, Private
*/
function private razshouldshowspecialpain(entity)
{
	gib_location = blackboard::getblackboardattribute(entity, "_gib_location");
	if(gib_location == "right_arm")
	{
		return true;
	}
	if(!razshouldshowpain(entity))
	{
		return false;
	}
	if(gib_location == "head" || gib_location == "arms" || gib_location == "right_leg" || gib_location == "left_leg" || gib_location == "left_arm")
	{
		return true;
	}
	return false;
}

/*
	Name: razshouldshowshieldpain
	Namespace: razbehavior
	Checksum: 0x9A0151A4
	Offset: 0x1EA8
	Size: 0x60
	Parameters: 1
	Flags: Linked, Private
*/
function private razshouldshowshieldpain(entity)
{
	if(isdefined(entity.damageweapon) && isdefined(entity.damageweapon.name))
	{
		return entity.damageweapon.name == "dragonshield";
	}
	return 0;
}

/*
	Name: razshouldgoberserk
	Namespace: razbehavior
	Checksum: 0x13999C9F
	Offset: 0x1F10
	Size: 0x60
	Parameters: 1
	Flags: Linked, Private
*/
function private razshouldgoberserk(entity)
{
	if(isdefined(entity.berserk) && entity.berserk && (!(isdefined(entity.razhasgoneberserk) && entity.razhasgoneberserk)))
	{
		return true;
	}
	return false;
}

/*
	Name: razshouldtraversewindow
	Namespace: razbehavior
	Checksum: 0x382C99CB
	Offset: 0x1F78
	Size: 0x2E
	Parameters: 1
	Flags: Linked, Private
*/
function private razshouldtraversewindow(entity)
{
	return isdefined(entity.jump_through_window) && entity.jump_through_window;
}

/*
	Name: razgoneberserk
	Namespace: razbehavior
	Checksum: 0x8E446BA
	Offset: 0x1FB0
	Size: 0x20
	Parameters: 1
	Flags: Linked, Private
*/
function private razgoneberserk(entity)
{
	entity.razhasgoneberserk = 1;
}

/*
	Name: razstarttraversewindow
	Namespace: razbehavior
	Checksum: 0x3B361966
	Offset: 0x1FD8
	Size: 0x7C
	Parameters: 1
	Flags: Linked, Private
*/
function private razstarttraversewindow(entity)
{
	raz_dir = anglestoforward(entity.first_node.angles);
	raz_dir = vectorscale(raz_dir, 100);
	entity setgoal(entity.origin + raz_dir);
}

/*
	Name: razfinishtraversewindow
	Namespace: razbehavior
	Checksum: 0x7AF1F812
	Offset: 0x2060
	Size: 0x84
	Parameters: 1
	Flags: Linked, Private
*/
function private razfinishtraversewindow(entity)
{
	entity setgoal(entity.origin);
	entity.jump_through_window = undefined;
	entity.first_node = undefined;
	if(!(isdefined(entity.completed_emerging_into_playable_area) && entity.completed_emerging_into_playable_area))
	{
		entity zm_spawner::zombie_complete_emerging_into_playable_area();
	}
}

/*
	Name: raztookpain
	Namespace: razbehavior
	Checksum: 0x601CC735
	Offset: 0x20F0
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private raztookpain(entity)
{
	blackboard::setblackboardattribute(entity, "_gib_location", "legs");
}

/*
	Name: razstartdeath
	Namespace: razbehavior
	Checksum: 0x3FE12893
	Offset: 0x2130
	Size: 0x50C
	Parameters: 1
	Flags: Linked, Private
*/
function private razstartdeath(entity)
{
	entity playsoundontag("zmb_raz_death", "tag_eye");
	if(isdefined(entity.razhasgunattached) && entity.razhasgunattached)
	{
		entity clientfield::set("raz_detach_gun", 1);
		entity.razhasgunattached = 0;
		entity detach("c_zom_dlc3_raz_cannon_arm");
		entity hidepart("j_shouldertwist_ri_attach", "", 1);
		entity hidepart("j_shoulder_ri_attach");
		wait(0.05);
		if(isdefined(entity))
		{
			entity razserverutils::razinvalidategibbedarmor();
		}
	}
	if(isdefined(entity))
	{
		if(isdefined(entity.razhashelmet) && entity.razhashelmet)
		{
			entity clientfield::set("raz_detach_helmet", 1);
			entity hidepart("j_head_attach", "", 1);
			entity.razhashelmet = 0;
		}
		if(isdefined(entity.razhaschestarmor) && entity.razhaschestarmor)
		{
			entity clientfield::set("raz_detach_chest_armor", 1);
			entity hidepart("j_spine4_attach", "", 1);
			entity hidepart("j_spineupper_attach", "", 1);
			entity hidepart("j_spinelower_attach", "", 1);
			entity hidepart("j_mainroot_attach", "", 1);
			entity hidepart("j_clavicle_ri_attachbp", "", 1);
			entity hidepart("j_clavicle_le_attachbp", "", 1);
			entity.razhaschestarmor = 0;
		}
		if(isdefined(entity.razhasleftshoulderarmor) && entity.razhasleftshoulderarmor)
		{
			entity clientfield::set("raz_detach_l_shoulder_armor", 1);
			entity hidepart("j_shouldertwist_le_attach", "", 1);
			entity hidepart("j_shoulder_le_attach", "", 1);
			entity hidepart("j_clavicle_le_attach", "", 1);
			entity.razhasleftshoulderarmor = 0;
		}
		if(isdefined(entity.razhasleftthigharmor) && entity.razhasleftthigharmor)
		{
			entity clientfield::set("raz_detach_l_thigh_armor", 1);
			entity hidepart("j_hiptwist_le_attach", "", 1);
			entity hidepart("j_hip_le_attach", "", 1);
			entity.razhasleftthigharmor = 0;
		}
		if(isdefined(entity.razhasrightthigharmor) && entity.razhasrightthigharmor)
		{
			entity clientfield::set("raz_detach_r_thigh_armor", 1);
			entity hidepart("j_hiptwist_ri_attach", "", 1);
			entity hidepart("j_hip_ri_attach", "", 1);
			entity.razhasrightthigharmor = 0;
		}
	}
}

/*
	Name: razshouldshootgroundtorpedo
	Namespace: razbehavior
	Checksum: 0xC2D39429
	Offset: 0x2648
	Size: 0x178
	Parameters: 1
	Flags: Linked, Private
*/
function private razshouldshootgroundtorpedo(entity)
{
	if(isdefined(entity.destroy_window_by_torpedo) && entity.destroy_window_by_torpedo)
	{
		return true;
	}
	if(!isdefined(entity.enemy))
	{
		return false;
	}
	if(!(isdefined(entity.razhasgunattached) && entity.razhasgunattached))
	{
		return false;
	}
	time = gettime();
	if(time < entity.next_torpedo_time)
	{
		return false;
	}
	enemy_dist_sq = distancesquared(entity.origin, entity.enemy.origin);
	if(!(enemy_dist_sq >= 22500 && enemy_dist_sq <= 1440000 && entity razcanseetorpedotarget(entity.enemy)))
	{
		return false;
	}
	if(isdefined(entity.check_point_in_enabled_zone))
	{
		in_enabled_zone = [[entity.check_point_in_enabled_zone]](entity.origin);
		if(!in_enabled_zone)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: razcanseetorpedotarget
	Namespace: razbehavior
	Checksum: 0xF75344D1
	Offset: 0x27C8
	Size: 0x186
	Parameters: 1
	Flags: Linked, Private
*/
function private razcanseetorpedotarget(enemy)
{
	entity = self;
	origin_point = entity gettagorigin("tag_weapon_right");
	target_point = enemy.origin + vectorscale((0, 0, 1), 48);
	forward_vect = anglestoforward(self.angles);
	vect_to_enemy = target_point - origin_point;
	if(vectordot(forward_vect, vect_to_enemy) <= 0)
	{
		return false;
	}
	right_vect = anglestoright(self.angles);
	projected_distance = vectordot(vect_to_enemy, right_vect);
	if(abs(projected_distance) > 50)
	{
		return false;
	}
	trace = bullettrace(origin_point, target_point, 0, self);
	if(trace["position"] === target_point)
	{
		return true;
	}
	return false;
}

/*
	Name: razstartmelee
	Namespace: razbehavior
	Checksum: 0xD0958A24
	Offset: 0x2958
	Size: 0x54
	Parameters: 1
	Flags: Linked, Private
*/
function private razstartmelee(entity)
{
	if(isdefined(entity.destroy_window_by_melee) && entity.destroy_window_by_melee)
	{
		wait(1.1);
		razdestroywindow(entity, 1);
	}
}

/*
	Name: razfinishmelee
	Namespace: razbehavior
	Checksum: 0x2CDF71EF
	Offset: 0x29B8
	Size: 0x1A
	Parameters: 1
	Flags: Linked, Private
*/
function private razfinishmelee(entity)
{
	entity.destroy_window_by_melee = undefined;
}

/*
	Name: razfinishgroundtorpedo
	Namespace: razbehavior
	Checksum: 0x8122CFB4
	Offset: 0x29E0
	Size: 0x30
	Parameters: 1
	Flags: Linked, Private
*/
function private razfinishgroundtorpedo(entity)
{
	entity.destroy_window_by_torpedo = undefined;
	entity.next_torpedo_time = gettime() + 3000;
}

/*
	Name: raznotetrackshootgroundtorpedo
	Namespace: razbehavior
	Checksum: 0xFBBCD6EB
	Offset: 0x2A18
	Size: 0x164
	Parameters: 1
	Flags: Linked, Private
*/
function private raznotetrackshootgroundtorpedo(entity)
{
	if(!isdefined(entity.enemy) && (!(isdefined(entity.destroy_window_by_torpedo) && entity.destroy_window_by_torpedo)))
	{
		/#
			println("");
		#/
		return;
	}
	if(isdefined(entity.destroy_window_by_torpedo) && entity.destroy_window_by_torpedo)
	{
		razdestroywindow(entity, 1);
		raz_dir = anglestoforward(entity.first_node.angles);
		entity razshootgroundtorpedo(entity.first_node, vectorscale(raz_dir, 100) + vectorscale((0, 0, 1), 48));
	}
	else
	{
		entity razshootgroundtorpedo(entity.enemy, vectorscale((0, 0, 1), 48));
	}
	entity.next_torpedo_time = gettime() + 3000;
}

/*
	Name: raztorpedolaunchdirection
	Namespace: razbehavior
	Checksum: 0xAA5EC59A
	Offset: 0x2B88
	Size: 0x130
	Parameters: 4
	Flags: Linked, Private
*/
function private raztorpedolaunchdirection(forward_dir, torpedo_pos, torpedo_target_pos, max_angle)
{
	vec_to_enemy = torpedo_target_pos - torpedo_pos;
	vec_to_enemy_normal = vectornormalize(vec_to_enemy);
	angle_to_enemy = vectordot(forward_dir, vec_to_enemy_normal);
	if(angle_to_enemy >= max_angle)
	{
		return vec_to_enemy_normal;
	}
	plane_normal = vectorcross(forward_dir, vec_to_enemy_normal);
	perpendicular_normal = vectorcross(plane_normal, forward_dir);
	torpedo_dir = (forward_dir * cos(max_angle)) + (perpendicular_normal * sin(max_angle));
	return torpedo_dir;
}

/*
	Name: razshootgroundtorpedo
	Namespace: razbehavior
	Checksum: 0xD8574203
	Offset: 0x2CC0
	Size: 0x2B4
	Parameters: 2
	Flags: Linked, Private
*/
function private razshootgroundtorpedo(torpedo_target, torpedo_target_offset)
{
	torpedo_pos = self gettagorigin("tag_weapon_right");
	torpedo_target_pos = torpedo_target.origin + torpedo_target_offset;
	torpedo = spawn("script_model", torpedo_pos);
	torpedo setmodel("tag_origin");
	torpedo clientfield::set("raz_torpedo_play_fx_on_self", 1);
	torpedo.torpedo_trail_iterations = 0;
	torpedo.raz_torpedo_owner = self;
	vec_to_enemy = raztorpedolaunchdirection(anglestoforward(self.angles), torpedo_pos, torpedo_target_pos, 0.7);
	angles_to_enemy = vectortoangles(vec_to_enemy);
	torpedo.angles = angles_to_enemy;
	normal_vector = vectornormalize(vec_to_enemy);
	torpedo.torpedo_old_normal_vector = normal_vector;
	torpedo.knockdown_iterations = 0;
	iteration_move_distance = 50;
	max_trail_iterations = int(1200 / iteration_move_distance);
	torpedo thread raztorpedoknockdownzombies(torpedo_target);
	torpedo thread raztorpedodetonateifclosetotarget(torpedo_target, torpedo_target_offset);
	while(isdefined(torpedo))
	{
		if(!isdefined(torpedo_target) || torpedo.torpedo_trail_iterations >= max_trail_iterations)
		{
			torpedo thread raztorpedodetonate(0);
		}
		else
		{
			torpedo raztorpedomovetotarget(torpedo_target);
			torpedo.torpedo_trail_iterations = torpedo.torpedo_trail_iterations + 1;
		}
		wait(0.1);
	}
}

/*
	Name: raztorpedodetonateifclosetotarget
	Namespace: razbehavior
	Checksum: 0x4055C23A
	Offset: 0x2F80
	Size: 0xC0
	Parameters: 2
	Flags: Linked, Private
*/
function private raztorpedodetonateifclosetotarget(torpedo_target, torpedo_target_offset)
{
	self endon(#"death");
	self endon(#"detonated");
	torpedo = self;
	while(isdefined(torpedo) && isdefined(torpedo_target))
	{
		torpedo_target_pos = torpedo_target.origin + torpedo_target_offset;
		if(distancesquared(torpedo.origin, torpedo_target_pos) <= 4096)
		{
			torpedo thread raztorpedodetonate(0);
		}
		wait(0.05);
	}
}

/*
	Name: raztorpedomovetotarget
	Namespace: razbehavior
	Checksum: 0x995511F9
	Offset: 0x3048
	Size: 0x43C
	Parameters: 1
	Flags: Linked, Private
*/
function private raztorpedomovetotarget(torpedo_target)
{
	self endon(#"death");
	self endon(#"detonated");
	if(!isdefined(self.torpedo_max_yaw_cos))
	{
		torpedo_yaw_per_interval = 13.5;
		self.torpedo_max_yaw_cos = cos(torpedo_yaw_per_interval);
	}
	if(isdefined(self.torpedo_old_normal_vector))
	{
		torpedo_target_point = torpedo_target.origin + vectorscale((0, 0, 1), 48);
		if(isplayer(torpedo_target))
		{
			torpedo_target_point = torpedo_target getplayercamerapos();
		}
		vector_to_target = torpedo_target_point - self.origin;
		normal_vector = vectornormalize(vector_to_target);
		flat_mapped_normal_vector = vectornormalize((normal_vector[0], normal_vector[1], 0));
		flat_mapped_old_normal_vector = vectornormalize((self.torpedo_old_normal_vector[0], self.torpedo_old_normal_vector[1], 0));
		dot = vectordot(flat_mapped_normal_vector, flat_mapped_old_normal_vector);
		if(dot >= 1)
		{
			dot = 1;
		}
		else if(dot <= -1)
		{
			dot = -1;
		}
		if(dot < self.torpedo_max_yaw_cos)
		{
			new_vector = normal_vector - self.torpedo_old_normal_vector;
			angle_between_vectors = acos(dot);
			if(!isdefined(angle_between_vectors))
			{
				angle_between_vectors = 180;
			}
			if(angle_between_vectors == 0)
			{
				angle_between_vectors = 0.0001;
			}
			max_angle_per_interval = 13.5;
			ratio = max_angle_per_interval / angle_between_vectors;
			if(ratio > 1)
			{
				ratio = 1;
			}
			new_vector = new_vector * ratio;
			new_vector = new_vector + self.torpedo_old_normal_vector;
			normal_vector = vectornormalize(new_vector);
		}
		else
		{
			normal_vector = self.torpedo_old_normal_vector;
		}
	}
	move_distance = 50;
	move_vector = move_distance * normal_vector;
	move_to_point = self.origin + move_vector;
	trace = bullettrace(self.origin, move_to_point, 0, self);
	if(trace["surfacetype"] !== "none")
	{
		detonate_point = trace["position"];
		dist_sq = distancesquared(detonate_point, self.origin);
		move_dist_sq = move_distance * move_distance;
		ratio = dist_sq / move_dist_sq;
		delay = ratio * 0.1;
		self thread raztorpedodetonate(delay);
	}
	self.torpedo_old_normal_vector = normal_vector;
	self moveto(move_to_point, 0.1);
}

/*
	Name: raztorpedoplaytraileffect
	Namespace: razbehavior
	Checksum: 0xBB879762
	Offset: 0x3490
	Size: 0xC4
	Parameters: 0
	Flags: Private
*/
function private raztorpedoplaytraileffect()
{
	self endon(#"death");
	self endon(#"detonated");
	surface_check_offset = 26;
	if(self.torpedo_trail_iterations >= 1)
	{
		trace = bullettrace(self.origin + vectorscale((0, 0, 1), 10), self.origin - (0, 0, surface_check_offset), 0, self);
		if(trace["surfacetype"] !== "none")
		{
			self clientfield::increment("raz_torpedo_play_trail", 1);
		}
	}
}

/*
	Name: razknockdownzombies
	Namespace: razbehavior
	Checksum: 0x33FBAFD9
	Offset: 0x3560
	Size: 0x5F0
	Parameters: 1
	Flags: Linked, Private
*/
function private razknockdownzombies(target)
{
	self endon(#"death");
	while(isdefined(self))
	{
		if(isdefined(target))
		{
			if(isplayer(target))
			{
				torpedo_target_position = target.origin + vectorscale((0, 0, 1), 48);
			}
			else
			{
				torpedo_target_position = target.origin;
			}
			prediction_time = 0.3;
			if(isdefined(self.knockdown_iterations) && self.knockdown_iterations < 3)
			{
				if(self.knockdown_iterations == 0)
				{
					prediction_time = 0.075;
				}
				if(self.knockdown_iterations == 1)
				{
					prediction_time = 0.15;
				}
				if(self.knockdown_iterations == 2)
				{
					prediction_time = 0.225;
				}
			}
			self.knockdown_iterations = self.knockdown_iterations + 1;
			vector_to_target = torpedo_target_position - self.origin;
			normal_vector = vectornormalize(vector_to_target);
			move_distance = 500 * prediction_time;
			move_vector = move_distance * normal_vector;
			self.angles = vectortoangles(move_vector);
		}
		else
		{
			velocity = self getvelocity();
			velocitymag = length(velocity);
			b_sprinting = velocitymag >= 40;
			if(b_sprinting)
			{
				predict_time = 0.2;
				move_vector = velocity * predict_time;
			}
		}
		if(!isdefined(b_sprinting) || b_sprinting == 1)
		{
			predicted_pos = self.origin + move_vector;
			a_zombies = getaiarchetypearray("zombie");
			a_filtered_zombies = array::filter(a_zombies, 0, &razzombieeligibleforknockdown, self, predicted_pos);
		}
		else
		{
			wait(0.2);
			continue;
		}
		if(a_filtered_zombies.size > 0)
		{
			foreach(zombie in a_filtered_zombies)
			{
				zombie.knockdown = 1;
				zombie.knockdown_type = "knockdown_shoved";
				zombie_to_target = self.origin - zombie.origin;
				zombie_to_target_2d = vectornormalize((zombie_to_target[0], zombie_to_target[1], 0));
				zombie_forward = anglestoforward(zombie.angles);
				zombie_forward_2d = vectornormalize((zombie_forward[0], zombie_forward[1], 0));
				zombie_right = anglestoright(zombie.angles);
				zombie_right_2d = vectornormalize((zombie_right[0], zombie_right[1], 0));
				dot = vectordot(zombie_to_target_2d, zombie_forward_2d);
				if(dot >= 0.5)
				{
					zombie.knockdown_direction = "front";
					zombie.getup_direction = "getup_back";
					continue;
				}
				if(dot < 0.5 && dot > -0.5)
				{
					dot = vectordot(zombie_to_target_2d, zombie_right_2d);
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
					continue;
				}
				zombie.knockdown_direction = "back";
				zombie.getup_direction = "getup_belly";
			}
		}
		wait(0.2);
	}
}

/*
	Name: raztorpedoknockdownzombies
	Namespace: razbehavior
	Checksum: 0xBB9652D9
	Offset: 0x3B58
	Size: 0x3C
	Parameters: 1
	Flags: Linked, Private
*/
function private raztorpedoknockdownzombies(torpedo_target)
{
	self endon(#"death");
	self endon(#"detonated");
	razknockdownzombies(torpedo_target);
}

/*
	Name: razsprintknockdownzombies
	Namespace: razbehavior
	Checksum: 0xD2ECA887
	Offset: 0x3BA0
	Size: 0x3C
	Parameters: 0
	Flags: Linked, Private
*/
function private razsprintknockdownzombies()
{
	self endon(#"death");
	self notify(#"razsprintknockdownzombies");
	self endon(#"razsprintknockdownzombies");
	razknockdownzombies();
}

/*
	Name: raztorpedodetonate
	Namespace: razbehavior
	Checksum: 0x9BE57EC4
	Offset: 0x3BE8
	Size: 0x1B4
	Parameters: 1
	Flags: Linked, Private
*/
function private raztorpedodetonate(delay)
{
	self notify(#"detonated");
	torpedo = self;
	raz_torpedo_owner = self.raz_torpedo_owner;
	if(delay > 0)
	{
		wait(delay);
	}
	if(isdefined(self))
	{
		self razapplyplayerdetonationeffects();
		w_weapon = getweapon("none");
		explosion_point = torpedo.origin;
		torpedo clientfield::set("raz_detonate_ground_torpedo", 1);
		radiusdamage(explosion_point + vectorscale((0, 0, 1), 18), 128, 100, 50, self.raz_torpedo_owner, "MOD_UNKNOWN", w_weapon);
		razapplytorpedodetonationpushtoplayers(explosion_point + vectorscale((0, 0, 1), 18));
		self clientfield::set("raz_torpedo_play_fx_on_self", 0);
		wait(0.05);
		if(isdefined(raz_torpedo_owner) && (isdefined(level.b_raz_ignore_mangler_cooldown) && level.b_raz_ignore_mangler_cooldown))
		{
			raz_torpedo_owner.next_torpedo_time = gettime();
		}
		if(isdefined(self))
		{
			self delete();
		}
	}
}

/*
	Name: razapplytorpedodetonationpushtoplayers
	Namespace: razbehavior
	Checksum: 0xC3B0478B
	Offset: 0x3DA8
	Size: 0x28E
	Parameters: 1
	Flags: Linked, Private
*/
function private razapplytorpedodetonationpushtoplayers(torpedo_origin)
{
	players = getplayers();
	v_length = 100 * 100;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!isalive(player))
		{
			continue;
		}
		if(player.sessionstate == "spectator")
		{
			continue;
		}
		if(player.sessionstate == "intermission")
		{
			continue;
		}
		if(isdefined(player.ignoreme) && player.ignoreme)
		{
			continue;
		}
		if(player isnotarget())
		{
			continue;
		}
		if(!player isonground())
		{
			continue;
		}
		n_distance = distance2dsquared(torpedo_origin, player.origin);
		if(n_distance < 0.01)
		{
			continue;
		}
		if(n_distance < v_length)
		{
			v_dir = player.origin - torpedo_origin;
			v_dir = (v_dir[0], v_dir[1], 0.1);
			v_dir = vectornormalize(v_dir);
			n_push_strength = getdvarint("raz_n_push_strength", 500);
			n_push_strength = 200 + (randomint(n_push_strength - 200));
			v_player_velocity = player getvelocity();
			player setvelocity(v_player_velocity + (v_dir * n_push_strength));
		}
	}
}

/*
	Name: razapplyplayerdetonationeffects
	Namespace: razbehavior
	Checksum: 0x9EE1D5D7
	Offset: 0x4040
	Size: 0xE6
	Parameters: 0
	Flags: Linked, Private
*/
function private razapplyplayerdetonationeffects()
{
	earthquake(0.4, 0.8, self.origin, 300);
	for(i = 0; i < level.activeplayers.size; i++)
	{
		distancesq = distancesquared(self.origin, level.activeplayers[i].origin + vectorscale((0, 0, 1), 48));
		if(distancesq > 4096)
		{
			continue;
		}
		level.activeplayers[i] playrumbleonentity("damage_heavy");
	}
}

/*
	Name: razzombieeligibleforknockdown
	Namespace: razbehavior
	Checksum: 0xB8178867
	Offset: 0x4130
	Size: 0x234
	Parameters: 3
	Flags: Linked, Private
*/
function private razzombieeligibleforknockdown(zombie, target, predicted_pos)
{
	if(zombie.knockdown === 1)
	{
		return false;
	}
	if(gibserverutils::isgibbed(zombie, 384))
	{
		return false;
	}
	knockdown_dist = 48;
	check_pos = zombie.origin;
	if(!isactor(target))
	{
		check_pos = zombie getcentroid();
		knockdown_dist = 64;
	}
	knockdown_dist_sq = knockdown_dist * knockdown_dist;
	dist_sq = distancesquared(predicted_pos, check_pos);
	if(dist_sq > knockdown_dist_sq)
	{
		return false;
	}
	origin = target.origin;
	facing_vec = anglestoforward(target.angles);
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

#namespace razserverutils;

/*
	Name: razspawnsetup
	Namespace: razserverutils
	Checksum: 0x8CA07DAC
	Offset: 0x4370
	Size: 0x1DC
	Parameters: 0
	Flags: Linked, Private
*/
function private razspawnsetup()
{
	self.invoke_sprint_time = gettime() + 90000;
	self.next_torpedo_time = gettime();
	self.razhasgunattached = 1;
	self.razhashelmet = 1;
	self.razhasleftshoulderarmor = 1;
	self.razhaschestarmor = 1;
	self.razhasrightthigharmor = 1;
	self.razhasleftthigharmor = 1;
	self.razhasgoneberserk = 0;
	if(!isdefined(level.razgunhealth))
	{
		level.razgunhealth = 500;
	}
	if(!isdefined(level.razmaxhealth))
	{
		level.razmaxhealth = self.health;
	}
	if(!isdefined(level.razhelmethealth))
	{
		level.razhelmethealth = 100;
	}
	if(!isdefined(level.razleftshoulderarmorhealth))
	{
		level.razleftshoulderarmorhealth = 100;
	}
	if(!isdefined(level.razchestarmorhealth))
	{
		level.razchestarmorhealth = 100;
	}
	if(!isdefined(level.razthigharmorhealth))
	{
		level.razthigharmorhealth = 100;
	}
	self.maxhealth = level.razmaxhealth;
	self.razgunhealth = level.razgunhealth;
	self.razhelmethealth = level.razhelmethealth;
	self.razchestarmorhealth = level.razchestarmorhealth;
	self.razrightthighhealth = level.razthigharmorhealth;
	self.razleftthighhealth = level.razthigharmorhealth;
	self.razleftshoulderarmorhealth = level.razleftshoulderarmorhealth;
	self.canbetargetedbyturnedzombies = 1;
	self.no_widows_wine = 1;
	self.flame_fx_timeout = 3;
	aiutility::addaioverridedamagecallback(self, &razdamagecallback);
	self thread razgibzombiesonmelee();
}

/*
	Name: razgibzombiesonmelee
	Namespace: razserverutils
	Checksum: 0x15309EDA
	Offset: 0x4558
	Size: 0x42E
	Parameters: 0
	Flags: Linked, Private
*/
function private razgibzombiesonmelee()
{
	self endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"melee_fire");
		a_zombies = getaiarchetypearray("zombie");
		foreach(zombie in a_zombies)
		{
			if(isdefined(zombie.no_gib) && zombie.no_gib)
			{
				continue;
			}
			heightdiff = abs(zombie.origin[2] - self.origin[2]);
			if(heightdiff > 50)
			{
				continue;
			}
			distance2dsq = distance2dsquared(zombie.origin, self.origin);
			if(distance2dsq > (90 * 90))
			{
				continue;
			}
			raz_forward = anglestoforward(self.angles);
			vect_to_enemy = zombie.origin - self.origin;
			if(vectordot(raz_forward, vect_to_enemy) <= 0)
			{
				continue;
			}
			right_vect = anglestoright(self.angles);
			projected_distance = vectordot(vect_to_enemy, right_vect);
			if(abs(projected_distance) > 35)
			{
				continue;
			}
			b_gibbed = 0;
			val = randomint(100);
			if(val > 50)
			{
				zombie zombie_utility::zombie_head_gib();
				b_gibbed = 1;
			}
			val = randomint(100);
			if(val > 50)
			{
				if(!gibserverutils::isgibbed(zombie, 32))
				{
					gibserverutils::gibrightarm(zombie);
					b_gibbed = 1;
				}
			}
			val = randomint(100);
			if(val > 50)
			{
				if(!gibserverutils::isgibbed(zombie, 16))
				{
					gibserverutils::gibleftarm(zombie);
					b_gibbed = 1;
				}
			}
			if(!(isdefined(b_gibbed) && b_gibbed))
			{
				if(!gibserverutils::isgibbed(zombie, 32))
				{
					gibserverutils::gibrightarm(zombie);
					continue;
				}
				if(!gibserverutils::isgibbed(zombie, 16))
				{
					gibserverutils::gibleftarm(zombie);
					continue;
				}
				zombie zombie_utility::zombie_head_gib();
			}
		}
	}
}

/*
	Name: razinvalidategibbedarmor
	Namespace: razserverutils
	Checksum: 0xEB19C9B5
	Offset: 0x4990
	Size: 0x30C
	Parameters: 0
	Flags: Linked, Private
*/
function private razinvalidategibbedarmor()
{
	if(!(isdefined(self.razhasgunattached) && self.razhasgunattached))
	{
		self hidepart("j_shouldertwist_ri_attach", "", 1);
		self hidepart("j_shoulder_ri_attach");
	}
	if(!(isdefined(self.razhaschestarmor) && self.razhaschestarmor))
	{
		self hidepart("j_spine4_attach", "", 1);
		self hidepart("j_spineupper_attach", "", 1);
		self hidepart("j_spinelower_attach", "", 1);
		self hidepart("j_mainroot_attach", "", 1);
		self hidepart("j_clavicle_ri_attachbp", "", 1);
		self hidepart("j_clavicle_le_attachbp", "", 1);
	}
	if(!(isdefined(self.razhasleftshoulderarmor) && self.razhasleftshoulderarmor))
	{
		self hidepart("j_shouldertwist_le_attach", "", 1);
		self hidepart("j_shoulder_le_attach", "", 1);
		self hidepart("j_clavicle_le_attach", "", 1);
	}
	if(!(isdefined(self.razhasrightthigharmor) && self.razhasrightthigharmor))
	{
		self hidepart("j_hiptwist_ri_attach", "", 1);
		self hidepart("j_hip_ri_attach", "", 1);
	}
	if(!(isdefined(self.razhasleftthigharmor) && self.razhasleftthigharmor))
	{
		self hidepart("j_hiptwist_le_attach", "", 1);
		self hidepart("j_hip_le_attach", "", 1);
	}
	if(!(isdefined(self.razhashelmet) && self.razhashelmet))
	{
		self hidepart("j_head_attach", "", 1);
	}
}

/*
	Name: razdamagecallback
	Namespace: razserverutils
	Checksum: 0xA0DE63A3
	Offset: 0x4CA8
	Size: 0x5E4
	Parameters: 12
	Flags: Linked, Private
*/
function private razdamagecallback(inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex)
{
	entity = self;
	entity.last_damage_hit_armor = 0;
	if(isdefined(attacker) && attacker == entity)
	{
		return 0;
	}
	if(mod !== "MOD_PROJECTILE_SPLASH")
	{
		if(isdefined(entity.razhasgunattached) && entity.razhasgunattached)
		{
			b_hit_shoulder_weakpoint = raz_check_for_location_hit(entity, hitloc, point, "right_arm_upper", 81, "j_shouldertwist_ri_attach");
			if(isdefined(b_hit_shoulder_weakpoint) && b_hit_shoulder_weakpoint)
			{
				entity raztrackgundamage(damage, attacker);
				damage = damage * 0.1;
				if(!(isdefined(entity.razhasgunattached) && entity.razhasgunattached))
				{
					post_hit_health = entity.health - damage;
					gun_detach_damage = entity.maxhealth * 0.33;
					post_hit_health_percent = (post_hit_health - gun_detach_damage) / entity.maxhealth;
					if(post_hit_health_percent > 0.25)
					{
						return entity.health - (entity.maxhealth * 0.25);
					}
					return gun_detach_damage;
				}
				return damage;
			}
		}
		if(isdefined(entity.razhaschestarmor) && entity.razhaschestarmor)
		{
			b_hit_chest = raz_check_for_location_hit(entity, hitloc, point, "torso_upper", 144, "j_spine4_attach");
			if(b_hit_chest || hitloc === "torso_lower" || hitloc === "torso_mid")
			{
				entity raztrackchestarmordamage(damage);
				entity.last_damage_hit_armor = 1;
				damage = damage * 0.1;
				return damage;
			}
		}
		if(isdefined(entity.razhasleftshoulderarmor) && entity.razhasleftshoulderarmor)
		{
			b_hit_l_shoulder_armor = raz_check_for_location_hit(entity, hitloc, point, "left_arm_upper", 81, "j_shouldertwist_le_attach");
			if(b_hit_l_shoulder_armor)
			{
				entity raztrackleftshoulderarmordamage(damage);
				entity.last_damage_hit_armor = 1;
				damage = damage * 0.1;
				return damage;
			}
		}
		if(isdefined(entity.razhasrightthigharmor) && entity.razhasrightthigharmor)
		{
			b_hit_r_thigh_armor = raz_check_for_location_hit(entity, hitloc, point, "right_leg_upper", 81, "j_hiptwist_ri_attach");
			if(b_hit_r_thigh_armor)
			{
				entity raztrackrightthigharmordamage(damage);
				entity.last_damage_hit_armor = 1;
				damage = damage * 0.1;
				return damage;
			}
		}
		if(isdefined(entity.razhasleftthigharmor) && entity.razhasleftthigharmor)
		{
			b_hit_l_thigh_armor = raz_check_for_location_hit(entity, hitloc, point, "left_leg_upper", 81, "j_hiptwist_le_attach");
			if(b_hit_l_thigh_armor)
			{
				entity raztrackleftthigharmordamage(damage);
				entity.last_damage_hit_armor = 1;
				damage = damage * 0.1;
				return damage;
			}
		}
		if(isdefined(entity.razhashelmet) && entity.razhashelmet)
		{
			b_hit_head = raz_check_for_location_hit(entity, hitloc, point, "head", 121, "j_head");
			if(b_hit_head || hitloc === "neck" || hitloc === "helmet")
			{
				entity raztrackhelmetdamage(damage, attacker);
				entity.last_damage_hit_armor = 1;
				damage = damage * 0.1;
				return damage;
			}
		}
	}
	return damage;
}

/*
	Name: raz_check_for_location_hit
	Namespace: razserverutils
	Checksum: 0xF51E0C5
	Offset: 0x5298
	Size: 0xD4
	Parameters: 6
	Flags: Linked, Private
*/
function private raz_check_for_location_hit(entity, hitloc, point, location, hit_radius_sq, tag)
{
	b_hit_location = 0;
	if(isdefined(hitloc) && hitloc != "none")
	{
		if(hitloc == location)
		{
			b_hit_location = 1;
		}
	}
	else
	{
		dist_sq = distancesquared(point, entity gettagorigin(tag));
		if(dist_sq <= hit_radius_sq)
		{
			b_hit_location = 1;
		}
	}
	return b_hit_location;
}

/*
	Name: raztrackgundamage
	Namespace: razserverutils
	Checksum: 0xAD25CE7
	Offset: 0x5378
	Size: 0x30E
	Parameters: 2
	Flags: Linked, Private
*/
function private raztrackgundamage(damage, attacker)
{
	entity = self;
	entity.razgunhealth = entity.razgunhealth - damage;
	post_hit_health = entity.health - damage;
	post_hit_health_percent = post_hit_health / entity.maxhealth;
	if(entity.razgunhealth > 0)
	{
		entity clientfield::increment("raz_gun_weakpoint_hit", 1);
	}
	if(entity.razgunhealth <= 0)
	{
		entity.razgunhealth = 0;
		entity clientfield::set("raz_detach_gun", 1);
		entity.razhasgunattached = 0;
		entity.invoke_sprint_time = undefined;
		entity.started_running = 1;
		entity thread razbehavior::razsprintknockdownzombies();
		blackboard::setblackboardattribute(entity, "_locomotion_speed", "locomotion_speed_sprint");
		blackboard::setblackboardattribute(entity, "_gibbed_limbs", "right_arm");
		blackboard::setblackboardattribute(entity, "_gib_location", "right_arm");
		explosion_max_damage = 0.5 * entity.maxhealth;
		explosion_min_damage = 0.25 * entity.maxhealth;
		weapon = getweapon("raz_melee");
		radiusdamage(self.origin + vectorscale((0, 0, 1), 18), 128, explosion_max_damage, explosion_min_damage, entity, "MOD_PROJECTILE_SPLASH", weapon);
		self detach("c_zom_dlc3_raz_cannon_arm");
		self hidepart("j_shouldertwist_ri_attach", "", 1);
		self hidepart("j_shoulder_ri_attach");
		razinvalidategibbedarmor();
		level notify(#"raz_arm_detach", attacker);
		self notify(#"raz_arm_detach", attacker);
	}
}

/*
	Name: raztrackhelmetdamage
	Namespace: razserverutils
	Checksum: 0xE8C8A2C0
	Offset: 0x5690
	Size: 0xEE
	Parameters: 2
	Flags: Linked, Private
*/
function private raztrackhelmetdamage(damage, attacker)
{
	entity = self;
	entity.razhelmethealth = entity.razhelmethealth - damage;
	if(entity.razhelmethealth <= 0)
	{
		entity clientfield::set("raz_detach_helmet", 1);
		entity hidepart("j_head_attach", "", 1);
		entity.razhashelmet = 0;
		blackboard::setblackboardattribute(entity, "_gib_location", "head");
		level notify(#"raz_mask_destroyed", attacker);
	}
}

/*
	Name: raztrackchestarmordamage
	Namespace: razserverutils
	Checksum: 0x79369C9
	Offset: 0x5788
	Size: 0x19C
	Parameters: 1
	Flags: Linked, Private
*/
function private raztrackchestarmordamage(damage)
{
	entity = self;
	entity.razchestarmorhealth = entity.razchestarmorhealth - damage;
	if(entity.razchestarmorhealth <= 0)
	{
		entity clientfield::set("raz_detach_chest_armor", 1);
		entity hidepart("j_spine4_attach", "", 1);
		entity hidepart("j_spineupper_attach", "", 1);
		entity hidepart("j_spinelower_attach", "", 1);
		entity hidepart("j_mainroot_attach", "", 1);
		entity hidepart("j_clavicle_ri_attachbp", "", 1);
		entity hidepart("j_clavicle_le_attachbp", "", 1);
		entity.razhaschestarmor = 0;
		blackboard::setblackboardattribute(entity, "_gib_location", "arms");
	}
}

/*
	Name: raztrackleftshoulderarmordamage
	Namespace: razserverutils
	Checksum: 0x8BACF320
	Offset: 0x5930
	Size: 0x124
	Parameters: 1
	Flags: Linked, Private
*/
function private raztrackleftshoulderarmordamage(damage)
{
	entity = self;
	entity.razleftshoulderarmorhealth = entity.razleftshoulderarmorhealth - damage;
	if(entity.razleftshoulderarmorhealth <= 0)
	{
		entity clientfield::set("raz_detach_l_shoulder_armor", 1);
		entity hidepart("j_shouldertwist_le_attach", "", 1);
		entity hidepart("j_shoulder_le_attach", "", 1);
		entity hidepart("j_clavicle_le_attach", "", 1);
		entity.razhasleftshoulderarmor = 0;
		blackboard::setblackboardattribute(entity, "_gib_location", "left_arm");
	}
}

/*
	Name: raztrackleftthigharmordamage
	Namespace: razserverutils
	Checksum: 0xAFAAAE6F
	Offset: 0x5A60
	Size: 0xFC
	Parameters: 1
	Flags: Linked, Private
*/
function private raztrackleftthigharmordamage(damage)
{
	entity = self;
	entity.razleftthighhealth = entity.razleftthighhealth - damage;
	if(entity.razleftthighhealth <= 0)
	{
		entity clientfield::set("raz_detach_l_thigh_armor", 1);
		entity hidepart("j_hiptwist_le_attach", "", 1);
		entity hidepart("j_hip_le_attach", "", 1);
		entity.razhasleftthigharmor = 0;
		blackboard::setblackboardattribute(entity, "_gib_location", "left_leg");
	}
}

/*
	Name: raztrackrightthigharmordamage
	Namespace: razserverutils
	Checksum: 0x6C288447
	Offset: 0x5B68
	Size: 0xFC
	Parameters: 1
	Flags: Linked, Private
*/
function private raztrackrightthigharmordamage(damage)
{
	entity = self;
	entity.razrightthighhealth = entity.razrightthighhealth - damage;
	if(entity.razrightthighhealth <= 0)
	{
		entity clientfield::set("raz_detach_r_thigh_armor", 1);
		entity hidepart("j_hiptwist_ri_attach", "", 1);
		entity hidepart("j_hip_ri_attach", "", 1);
		entity.razhasrightthigharmor = 0;
		blackboard::setblackboardattribute(entity, "_gib_location", "right_leg");
	}
}

