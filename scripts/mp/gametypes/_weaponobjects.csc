// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace weaponobjects;

/*
	Name: __init__sytem__
	Namespace: weaponobjects
	Checksum: 0xE878A9FE
	Offset: 0x298
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("weaponobjects", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: weaponobjects
	Checksum: 0x7888B3E
	Offset: 0x2D8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
	level setupscriptmovercompassicons();
	level setupmissilecompassicons();
}

/*
	Name: setupscriptmovercompassicons
	Namespace: weaponobjects
	Checksum: 0x86400493
	Offset: 0x328
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function setupscriptmovercompassicons()
{
	if(!isdefined(level.scriptmovercompassicons))
	{
		level.scriptmovercompassicons = [];
	}
	level.scriptmovercompassicons["wpn_t7_turret_emp_core"] = "compass_empcore_white";
	level.scriptmovercompassicons["t6_wpn_turret_ads_world"] = "compass_guardian_white";
	level.scriptmovercompassicons["veh_t7_drone_uav_enemy_vista"] = "compass_uav";
	level.scriptmovercompassicons["veh_t7_mil_vtol_fighter_mp"] = "compass_lightningstrike";
	level.scriptmovercompassicons["veh_t7_drone_rolling_thunder"] = "compass_lodestar";
	level.scriptmovercompassicons["veh_t7_drone_srv_blimp"] = "t7_hud_minimap_hatr";
}

/*
	Name: setupmissilecompassicons
	Namespace: weaponobjects
	Checksum: 0x14DC09D4
	Offset: 0x3F8
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function setupmissilecompassicons()
{
	if(!isdefined(level.missilecompassicons))
	{
		level.missilecompassicons = [];
	}
	if(isdefined(getweapon("drone_strike")))
	{
		level.missilecompassicons[getweapon("drone_strike")] = "compass_lodestar";
	}
}

