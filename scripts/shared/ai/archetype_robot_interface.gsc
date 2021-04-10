// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_robot;
#using scripts\shared\ai\systems\ai_interface;

#namespace robotinterface;

/*
	Name: registerrobotinterfaceattributes
	Namespace: robotinterface
	Checksum: 0x90F18DA3
	Offset: 0x318
	Size: 0x69C
	Parameters: 0
	Flags: Linked
*/
function registerrobotinterfaceattributes()
{
	ai::registermatchedinterface("robot", "can_be_meleed", 1, array(1, 0));
	ai::registermatchedinterface("robot", "can_become_crawler", 1, array(1, 0));
	ai::registermatchedinterface("robot", "can_become_rusher", 1, array(1, 0));
	ai::registermatchedinterface("robot", "can_gib", 1, array(1, 0));
	ai::registermatchedinterface("robot", "can_melee", 1, array(1, 0));
	ai::registermatchedinterface("robot", "can_initiateaivsaimelee", 1, array(1, 0));
	ai::registermatchedinterface("robot", "disablesprint", 0, array(1, 0));
	ai::registervectorinterface("robot", "escort_position");
	ai::registermatchedinterface("robot", "force_cover", 0, array(1, 0));
	ai::registermatchedinterface("robot", "force_crawler", "normal", array("normal", "gib_legs", "remove_legs"), &robotsoldierserverutils::robotforcecrawler);
	ai::registermatchedinterface("robot", "move_mode", "normal", array("escort", "guard", "normal", "marching", "rambo", "rusher", "squadmember"), &robotsoldierserverutils::robotmovemodeattributecallback);
	ai::registermatchedinterface("robot", "phalanx", 0, array(1, 0));
	ai::registermatchedinterface("robot", "phalanx_force_stance", "normal", array("normal", "stand", "crouch"));
	ai::registermatchedinterface("robot", "robot_lights", 0, array(0, 1, 2, 3, 4), &robotsoldierserverutils::robotlights);
	ai::registermatchedinterface("robot", "robot_mini_raps", 0, array(1, 0), &robotsoldierserverutils::robotequipminiraps);
	ai::registermatchedinterface("robot", "rogue_allow_predestruct", 1, array(1, 0));
	ai::registermatchedinterface("robot", "rogue_allow_pregib", 1, array(1, 0));
	ai::registermatchedinterface("robot", "rogue_control", "level_0", array("level_0", "level_1", "forced_level_1", "level_2", "forced_level_2", "level_3", "forced_level_3"), &robotsoldierserverutils::roguecontrolattributecallback);
	ai::registervectorinterface("robot", "rogue_control_force_goal", undefined, &robotsoldierserverutils::roguecontrolforcegoalattributecallback);
	ai::registermatchedinterface("robot", "rogue_control_speed", "sprint", array("walk", "run", "sprint"), &robotsoldierserverutils::roguecontrolspeedattributecallback);
	ai::registermatchedinterface("robot", "rogue_force_explosion", 0, array(1, 0));
	ai::registermatchedinterface("robot", "shutdown", 0, array(1, 0));
	ai::registermatchedinterface("robot", "sprint", 0, array(1, 0));
	ai::registermatchedinterface("robot", "supports_super_sprint", 0, array(1, 0));
	ai::registermatchedinterface("robot", "traversals", "normal", array("normal", "procedural"), &robotsoldierserverutils::robottraversalattributecallback);
}

