// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zm_ai_raz;

/*
	Name: __init__sytem__
	Namespace: zm_ai_raz
	Checksum: 0xE991112F
	Offset: 0x120
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_raz", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_raz
	Checksum: 0xE7FE6FE9
	Offset: 0x168
	Size: 0x44
	Parameters: 0
	Flags: Linked, AutoExec
*/
function autoexec __init__()
{
	level._effect["fx_raz_eye_glow"] = "dlc3/stalingrad/fx_raz_eye_glow";
	ai::add_archetype_spawn_function("raz", &function_f87a1709);
}

/*
	Name: __main__
	Namespace: zm_ai_raz
	Checksum: 0x99EC1590
	Offset: 0x1B8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
}

/*
	Name: function_f87a1709
	Namespace: zm_ai_raz
	Checksum: 0xBB8F5C6B
	Offset: 0x1C8
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_f87a1709(localclientnum)
{
	self._eyeglow_fx_override = level._effect["fx_raz_eye_glow"];
	self._eyeglow_tag_override = "tag_eye_glow";
}

