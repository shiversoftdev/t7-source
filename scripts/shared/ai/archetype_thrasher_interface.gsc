// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_thrasher;
#using scripts\shared\ai\systems\ai_interface;

#namespace thrasherinterface;

/*
	Name: registerthrasherinterfaceattributes
	Namespace: thrasherinterface
	Checksum: 0xFAE534BD
	Offset: 0x118
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function registerthrasherinterfaceattributes()
{
	ai::registermatchedinterface("thrasher", "stunned", 0, array(1, 0));
	ai::registermatchedinterface("thrasher", "move_mode", "normal", array("normal", "friendly"), &thrasherserverutils::thrashermovemodeattributecallback);
	ai::registermatchedinterface("thrasher", "use_attackable", 0, array(1, 0));
}

