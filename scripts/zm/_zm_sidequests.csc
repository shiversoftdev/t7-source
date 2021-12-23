// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;

#namespace zm_sidequests;

/*
	Name: register_sidequest_icon
	Namespace: zm_sidequests
	Checksum: 0xEF1A64CA
	Offset: 0xF0
	Size: 0xAC
	Parameters: 2
	Flags: None
*/
function register_sidequest_icon(icon_name, version_number)
{
	clientfieldprefix = ("sidequestIcons." + icon_name) + ".";
	clientfield::register("clientuimodel", clientfieldprefix + "icon", version_number, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", clientfieldprefix + "notification", version_number, 1, "int", undefined, 0, 0);
}

