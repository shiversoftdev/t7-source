// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\zombie;

#namespace mannequininterface;

/*
	Name: registermannequininterfaceattributes
	Namespace: mannequininterface
	Checksum: 0xE164E6D
	Offset: 0x100
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function registermannequininterfaceattributes()
{
	ai::registermatchedinterface("mannequin", "can_juke", 0, array(1, 0));
	ai::registermatchedinterface("mannequin", "suicidal_behavior", 0, array(1, 0));
	ai::registermatchedinterface("mannequin", "spark_behavior", 0, array(1, 0));
}

