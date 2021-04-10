// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\systems\ai_interface;
#using scripts\zm\archetype_zod_companion;

#namespace zodcompanioninterface;

/*
	Name: registerzodcompanioninterfaceattributes
	Namespace: zodcompanioninterface
	Checksum: 0x24852F7B
	Offset: 0xE8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function registerzodcompanioninterfaceattributes()
{
	ai::registermatchedinterface("zod_companion", "sprint", 0, array(1, 0));
}

