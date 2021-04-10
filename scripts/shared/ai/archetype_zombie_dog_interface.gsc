// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\behavior_zombie_dog;
#using scripts\shared\ai\systems\ai_interface;

#namespace zombiedoginterface;

/*
	Name: registerzombiedoginterfaceattributes
	Namespace: zombiedoginterface
	Checksum: 0x26B16E52
	Offset: 0x110
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function registerzombiedoginterfaceattributes()
{
	ai::registermatchedinterface("zombie_dog", "gravity", "normal", array("low", "normal"), &zombiedogbehavior::zombiedoggravity);
	ai::registermatchedinterface("zombie_dog", "min_run_dist", 500);
	ai::registermatchedinterface("zombie_dog", "sprint", 0, array(1, 0));
}

