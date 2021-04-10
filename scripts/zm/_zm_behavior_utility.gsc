// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_spawner;

#namespace zm_behavior_utility;

/*
	Name: setupattackproperties
	Namespace: zm_behavior_utility
	Checksum: 0x772E4EBB
	Offset: 0x218
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function setupattackproperties()
{
	self.ignoreall = 0;
	self.meleeattackdist = 64;
}

/*
	Name: enteredplayablearea
	Namespace: zm_behavior_utility
	Checksum: 0x308197B7
	Offset: 0x240
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function enteredplayablearea()
{
	self zm_spawner::zombie_complete_emerging_into_playable_area();
	self.pushable = 1;
	self setupattackproperties();
}

