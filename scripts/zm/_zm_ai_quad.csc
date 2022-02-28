// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zm_ai_quad;

/*
	Name: __init__sytem__
	Namespace: zm_ai_quad
	Checksum: 0x135FB843
	Offset: 0xF0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_quad", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_quad
	Checksum: 0xEACF9393
	Offset: 0x130
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	visionset_mgr::register_overlay_info_style_blur("zm_ai_quad_blur", 21000, 1, 0.1, 0.5, 4);
}

