// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
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
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace clonebehavior;

/*
	Name: init
	Namespace: clonebehavior
	Checksum: 0xF339E233
	Offset: 0x430
	Size: 0x64
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initthrasherbehaviorsandasm();
	spawner::add_archetype_spawn_function("human_clone", &archetypecloneblackboardinit);
	spawner::add_archetype_spawn_function("human_clone", &clonespawnsetup);
}

/*
	Name: initthrasherbehaviorsandasm
	Namespace: clonebehavior
	Checksum: 0x99EC1590
	Offset: 0x4A0
	Size: 0x4
	Parameters: 0
	Flags: Linked, Private
*/
function private initthrasherbehaviorsandasm()
{
}

/*
	Name: archetypecloneblackboardinit
	Namespace: clonebehavior
	Checksum: 0xE5AAEA65
	Offset: 0x4B0
	Size: 0x94
	Parameters: 0
	Flags: Linked, Private
*/
function private archetypecloneblackboardinit()
{
	entity = self;
	blackboard::createblackboardforentity(entity);
	entity aiutility::registerutilityblackboardattributes();
	ai::createinterfaceforentity(entity);
	entity.___archetypeonanimscriptedcallback = &archetypecloneonanimscriptedcallback;
	/#
		entity finalizetrackedblackboardattributes();
	#/
}

/*
	Name: archetypecloneonanimscriptedcallback
	Namespace: clonebehavior
	Checksum: 0xDF1C244
	Offset: 0x550
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private archetypecloneonanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity archetypecloneblackboardinit();
}

/*
	Name: perfectinfothread
	Namespace: clonebehavior
	Checksum: 0x825610F3
	Offset: 0x590
	Size: 0x70
	Parameters: 0
	Flags: Linked, Private
*/
function private perfectinfothread()
{
	entity = self;
	entity endon(#"death");
	while(true)
	{
		if(isdefined(entity.enemy))
		{
			entity getperfectinfo(entity.enemy, 1);
		}
		wait(0.05);
	}
}

/*
	Name: clonespawnsetup
	Namespace: clonebehavior
	Checksum: 0xCF81C61D
	Offset: 0x608
	Size: 0xA4
	Parameters: 0
	Flags: Linked, Private
*/
function private clonespawnsetup()
{
	entity = self;
	entity.ignoreme = 1;
	entity.ignoreall = 1;
	entity setcontents(8192);
	entity setavoidancemask("avoid none");
	entity setclone();
	entity thread perfectinfothread();
}

#namespace cloneserverutils;

/*
	Name: cloneplayerlook
	Namespace: cloneserverutils
	Checksum: 0x977DDCE7
	Offset: 0x6B8
	Size: 0x244
	Parameters: 3
	Flags: Linked
*/
function cloneplayerlook(clone, cloneplayer, targetplayer)
{
	/#
		assert(isactor(clone));
	#/
	/#
		assert(isplayer(cloneplayer));
	#/
	/#
		assert(isplayer(targetplayer));
	#/
	clone.owner = cloneplayer;
	clone setentitytarget(targetplayer, 1);
	clone setentityowner(cloneplayer);
	clone detachall();
	bodymodel = cloneplayer getcharacterbodymodel();
	if(isdefined(bodymodel))
	{
		clone setmodel(bodymodel);
	}
	headmodel = cloneplayer getcharacterheadmodel();
	if(isdefined(headmodel) && headmodel != "tag_origin")
	{
		if(isdefined(clone.head))
		{
			clone detach(clone.head);
		}
		clone attach(headmodel);
	}
	helmetmodel = cloneplayer getcharacterhelmetmodel();
	if(isdefined(helmetmodel) && headmodel != "tag_origin")
	{
		clone attach(helmetmodel);
	}
}

