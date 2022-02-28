// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;

#using_animtree("generic");

#namespace zm_island_takeo_fight;

/*
	Name: __init__sytem__
	Namespace: zm_island_takeo_fight
	Checksum: 0x67F9AF91
	Offset: 0x320
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_takeo_fight", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_island_takeo_fight
	Checksum: 0x73E17F9E
	Offset: 0x360
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "takeofight_teleport_fx", 9000, 1, "int", &takeofight_teleport_fx, 0, 0);
	clientfield::register("scriptmover", "takeo_arm_hit_fx", 1, 3, "int", &takeo_arm_hit_fx, 0, 0);
}

/*
	Name: main
	Namespace: zm_island_takeo_fight
	Checksum: 0x99EC1590
	Offset: 0x400
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function main()
{
}

/*
	Name: takeofight_teleport_fx
	Namespace: zm_island_takeo_fight
	Checksum: 0xFB816274
	Offset: 0x410
	Size: 0x3C
	Parameters: 7
	Flags: Linked
*/
function takeofight_teleport_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
}

/*
	Name: takeo_arm_hit_fx
	Namespace: zm_island_takeo_fight
	Checksum: 0xFC0251C8
	Offset: 0x458
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function takeo_arm_hit_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval > 0)
	{
		str_tag = ("tag_fx_eye" + newval) + "_jnt";
		self.var_2c75d806 = playfxontag(localclientnum, level._effect["takeofight_postule_burst"], self, str_tag);
	}
}

