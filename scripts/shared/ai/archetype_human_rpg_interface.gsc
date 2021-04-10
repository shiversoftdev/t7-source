// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_human_rpg;
#using scripts\shared\ai\systems\ai_interface;

#namespace humanrpginterface;

/*
	Name: registerhumanrpginterfaceattributes
	Namespace: humanrpginterface
	Checksum: 0x262765A2
	Offset: 0x118
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function registerhumanrpginterfaceattributes()
{
	ai::registermatchedinterface("human_rpg", "can_be_meleed", 1, array(1, 0));
	ai::registermatchedinterface("human_rpg", "can_melee", 1, array(1, 0));
	ai::registermatchedinterface("human_rpg", "coverIdleOnly", 0, array(1, 0));
	ai::registermatchedinterface("human_rpg", "sprint", 0, array(1, 0));
	ai::registermatchedinterface("human_rpg", "patrol", 0, array(1, 0));
}

