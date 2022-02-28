// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_heatseekingmissile;

#namespace heatseekingmissile;

/*
	Name: __init__sytem__
	Namespace: heatseekingmissile
	Checksum: 0x518BB9C5
	Offset: 0x178
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("heatseekingmissile", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: heatseekingmissile
	Checksum: 0x5AE182CF
	Offset: 0x1B8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.lockoncloserange = 220;
	level.lockoncloseradiusscaler = 1;
	init_shared();
}

