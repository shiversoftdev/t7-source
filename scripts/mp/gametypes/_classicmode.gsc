// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_player;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\shared\clientfield_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;

#namespace classicmode;

/*
	Name: __init__sytem__
	Namespace: classicmode
	Checksum: 0x2BA6BDFB
	Offset: 0x308
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("classicmode", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: classicmode
	Checksum: 0x6F31EEE9
	Offset: 0x348
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.classicmode = getgametypesetting("classicMode");
	if(level.classicmode)
	{
		enableclassicmode();
	}
}

/*
	Name: enableclassicmode
	Namespace: classicmode
	Checksum: 0x838AF735
	Offset: 0x398
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function enableclassicmode()
{
	setdvar("bg_t7BlockMeleeUsageTime", 100);
	setdvar("doublejump_enabled", 0);
	setdvar("wallRun_enabled", 0);
	setdvar("slide_maxTime", 550);
	setdvar("playerEnergy_slideEnergyEnabled", 0);
	setdvar("trm_maxSideMantleHeight", 0);
	setdvar("trm_maxBackMantleHeight", 0);
	setdvar("player_swimming_enabled", 0);
	setdvar("player_swimHeightRatio", 0.9);
	setdvar("player_sprintSpeedScale", 1.5);
	setdvar("jump_slowdownEnable", 1);
	setdvar("player_sprintUnlimited", 0);
	setdvar("sprint_allowRestore", 0);
	setdvar("sprint_allowReload", 0);
	setdvar("sprint_allowRechamber", 0);
	setdvar("cg_blur_time", 500);
	setdvar("tu11_enableClassicMode", 1);
}

