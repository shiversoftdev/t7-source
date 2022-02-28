// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_genesis_util;

#namespace zm_genesis_minor_ee;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_minor_ee
	Checksum: 0x3CAFF76
	Offset: 0x268
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_minor_ee", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_minor_ee
	Checksum: 0x99EC1590
	Offset: 0x2B0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

/*
	Name: __main__
	Namespace: zm_genesis_minor_ee
	Checksum: 0xC4F59970
	Offset: 0x2C0
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level.explode_1st_offset = 0;
	level.explode_2nd_offset = 0;
	level.explode_main_offset = 0;
}

