// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\zombie;

#namespace zombieinterface;

/*
	Name: registerzombieinterfaceattributes
	Namespace: zombieinterface
	Checksum: 0x2EA92298
	Offset: 0x110
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function registerzombieinterfaceattributes()
{
	ai::registermatchedinterface("zombie", "can_juke", 0, array(1, 0));
	ai::registermatchedinterface("zombie", "suicidal_behavior", 0, array(1, 0));
	ai::registermatchedinterface("zombie", "spark_behavior", 0, array(1, 0));
	ai::registermatchedinterface("zombie", "use_attackable", 0, array(1, 0));
}

