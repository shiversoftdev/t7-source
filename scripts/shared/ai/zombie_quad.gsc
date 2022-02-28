// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
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

#namespace zombiequad;

/*
	Name: init
	Namespace: zombiequad
	Checksum: 0xF8CA25E9
	Offset: 0x500
	Size: 0x64
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initzombiebehaviorsandasm();
	spawner::add_archetype_spawn_function("zombie_quad", &archetypequadblackboardinit);
	spawner::add_archetype_spawn_function("zombie_quad", &quadspawnsetup);
}

/*
	Name: archetypequadblackboardinit
	Namespace: zombiequad
	Checksum: 0xEA8AE66B
	Offset: 0x570
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function archetypequadblackboardinit()
{
	blackboard::createblackboardforentity(self);
	self aiutility::registerutilityblackboardattributes();
	ai::createinterfaceforentity(self);
	blackboard::registerblackboardattribute(self, "_locomotion_speed", "locomotion_speed_walk", &zombiebehavior::bb_getlocomotionspeedtype);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_quad_wall_crawl", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_quad_phase_direction", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_quad_phase_distance", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	self.___archetypeonanimscriptedcallback = &archetypequadonanimscriptedcallback;
	/#
		self finalizetrackedblackboardattributes();
	#/
}

/*
	Name: archetypequadonanimscriptedcallback
	Namespace: zombiequad
	Checksum: 0x9BA23D08
	Offset: 0x768
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private archetypequadonanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity archetypequadblackboardinit();
}

/*
	Name: initzombiebehaviorsandasm
	Namespace: zombiequad
	Checksum: 0x3FDCD04F
	Offset: 0x7A8
	Size: 0x34
	Parameters: 0
	Flags: Linked, Private
*/
function private initzombiebehaviorsandasm()
{
	animationstatenetwork::registeranimationmocomp("mocomp_teleport_traversal@zombie_quad", &quadteleporttraversalmocompstart, undefined, undefined);
}

/*
	Name: quadspawnsetup
	Namespace: zombiequad
	Checksum: 0x53578EC6
	Offset: 0x7E8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function quadspawnsetup()
{
	self setpitchorient();
}

/*
	Name: quadteleporttraversalmocompstart
	Namespace: zombiequad
	Checksum: 0x9E0E2C39
	Offset: 0x810
	Size: 0x19C
	Parameters: 5
	Flags: Linked
*/
function quadteleporttraversalmocompstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity orientmode("face angle", entity.angles[1]);
	entity animmode("normal");
	if(isdefined(entity.traverseendnode))
	{
		/#
			print3d(entity.traversestartnode.origin, "", (1, 0, 0), 1, 1, 60);
			print3d(entity.traverseendnode.origin, "", (0, 1, 0), 1, 1, 60);
			line(entity.traversestartnode.origin, entity.traverseendnode.origin, (0, 1, 0), 1, 0, 60);
		#/
		entity forceteleport(entity.traverseendnode.origin, entity.traverseendnode.angles, 0);
	}
}

