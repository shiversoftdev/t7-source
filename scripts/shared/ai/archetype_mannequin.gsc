// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_mannequin_interface;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\spawner_shared;

#namespace mannequinbehavior;

/*
	Name: init
	Namespace: mannequinbehavior
	Checksum: 0x41C61ABB
	Offset: 0x1C8
	Size: 0x214
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	level.zm_variant_type_max = [];
	level.zm_variant_type_max["walk"] = [];
	level.zm_variant_type_max["run"] = [];
	level.zm_variant_type_max["sprint"] = [];
	level.zm_variant_type_max["walk"]["down"] = 14;
	level.zm_variant_type_max["walk"]["up"] = 16;
	level.zm_variant_type_max["run"]["down"] = 13;
	level.zm_variant_type_max["run"]["up"] = 12;
	level.zm_variant_type_max["sprint"]["down"] = 7;
	level.zm_variant_type_max["sprint"]["up"] = 6;
	spawner::add_archetype_spawn_function("mannequin", &zombiebehavior::archetypezombieblackboardinit);
	spawner::add_archetype_spawn_function("mannequin", &zombiebehavior::archetypezombiedeathoverrideinit);
	spawner::add_archetype_spawn_function("mannequin", &zombie_utility::zombiespawnsetup);
	spawner::add_archetype_spawn_function("mannequin", &mannequinspawnsetup);
	mannequininterface::registermannequininterfaceattributes();
	behaviortreenetworkutility::registerbehaviortreescriptapi("mannequinCollisionService", &mannequincollisionservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mannequinShouldMelee", &mannequinshouldmelee);
}

/*
	Name: mannequincollisionservice
	Namespace: mannequinbehavior
	Checksum: 0xC9C59DC4
	Offset: 0x3E8
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function mannequincollisionservice(entity)
{
	if(isdefined(entity.enemy) && distancesquared(entity.origin, entity.enemy.origin) > (300 * 300))
	{
		entity pushactors(0);
	}
	else
	{
		entity pushactors(1);
	}
}

/*
	Name: mannequinspawnsetup
	Namespace: mannequinbehavior
	Checksum: 0xEDD38CBA
	Offset: 0x490
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function mannequinspawnsetup(entity)
{
}

/*
	Name: mannequinshouldmelee
	Namespace: mannequinbehavior
	Checksum: 0xEB636FA1
	Offset: 0x4A8
	Size: 0x18C
	Parameters: 1
	Flags: Linked, Private
*/
function private mannequinshouldmelee(entity)
{
	if(!isdefined(entity.enemy))
	{
		return false;
	}
	if(isdefined(entity.marked_for_death))
	{
		return false;
	}
	if(isdefined(entity.ignoremelee) && entity.ignoremelee)
	{
		return false;
	}
	if(distance2dsquared(entity.origin, entity.enemy.origin) > (64 * 64))
	{
		return false;
	}
	if((abs(entity.origin[2] - entity.enemy.origin[2])) > 72)
	{
		return false;
	}
	yawtoenemy = angleclamp180(entity.angles[1] - (vectortoangles(entity.enemy.origin - entity.origin)[1]));
	if(abs(yawtoenemy) > 45)
	{
		return false;
	}
	return true;
}

