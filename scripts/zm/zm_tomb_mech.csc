// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\mechz;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\_zm_ai_mechz_claw;

#namespace zm_tomb_mech;

/*
	Name: init
	Namespace: zm_tomb_mech
	Checksum: 0xDBDA6C5D
	Offset: 0x238
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("actor", "tomb_mech_eye", 21000, 1, "int", &function_8c8b6484, 0, 0);
}

/*
	Name: function_8c8b6484
	Namespace: zm_tomb_mech
	Checksum: 0x78E40CC4
	Offset: 0x290
	Size: 0xB8
	Parameters: 7
	Flags: Linked
*/
function function_8c8b6484(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		waittillframeend();
		var_f9e79b00 = self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 1, 3, 0);
	}
	else
	{
		waittillframeend();
		var_f9e79b00 = self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 0, 3, 0);
	}
}

