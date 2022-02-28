// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_human_rpg_interface;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;

#namespace archetype_human_rpg;

/*
	Name: main
	Namespace: archetype_human_rpg
	Checksum: 0xACB3173C
	Offset: 0x388
	Size: 0x4C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	spawner::add_archetype_spawn_function("human_rpg", &humanrpgbehavior::archetypehumanrpgblackboardinit);
	humanrpgbehavior::registerbehaviorscriptfunctions();
	humanrpginterface::registerhumanrpginterfaceattributes();
}

#namespace humanrpgbehavior;

/*
	Name: registerbehaviorscriptfunctions
	Namespace: humanrpgbehavior
	Checksum: 0x99EC1590
	Offset: 0x3E0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function registerbehaviorscriptfunctions()
{
}

/*
	Name: archetypehumanrpgblackboardinit
	Namespace: humanrpgbehavior
	Checksum: 0x71E239A7
	Offset: 0x3F0
	Size: 0xA4
	Parameters: 0
	Flags: Linked, Private
*/
function private archetypehumanrpgblackboardinit()
{
	entity = self;
	blackboard::createblackboardforentity(entity);
	ai::createinterfaceforentity(entity);
	entity aiutility::registerutilityblackboardattributes();
	self.___archetypeonanimscriptedcallback = &archetypehumanrpgonanimscriptedcallback;
	/#
		entity finalizetrackedblackboardattributes();
	#/
	entity asmchangeanimmappingtable(1);
}

/*
	Name: archetypehumanrpgonanimscriptedcallback
	Namespace: humanrpgbehavior
	Checksum: 0x90E3A80C
	Offset: 0x4A0
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private archetypehumanrpgonanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity archetypehumanrpgblackboardinit();
}

