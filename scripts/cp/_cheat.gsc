// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;

#namespace cheat;

/*
	Name: __init__sytem__
	Namespace: cheat
	Checksum: 0x8598BA5D
	Offset: 0xE0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("cheat", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: cheat
	Checksum: 0x6B54A10
	Offset: 0x120
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.cheatstates = [];
	level.cheatfuncs = [];
	level.cheatdvars = [];
	level flag::init("has_cheated");
	level thread death_monitor();
}

/*
	Name: player_init
	Namespace: cheat
	Checksum: 0x31F2394
	Offset: 0x188
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function player_init()
{
	self thread specialfeaturesmenu();
}

/*
	Name: death_monitor
	Namespace: cheat
	Checksum: 0xF13D2A17
	Offset: 0x1B0
	Size: 0x14
	Parameters: 0
	Flags: None
*/
function death_monitor()
{
	setdvars_based_on_varibles();
}

/*
	Name: setdvars_based_on_varibles
	Namespace: cheat
	Checksum: 0xE3961AC8
	Offset: 0x1D0
	Size: 0x66
	Parameters: 0
	Flags: None
*/
function setdvars_based_on_varibles()
{
	/#
		for(index = 0; index < level.cheatdvars.size; index++)
		{
			setdvar(level.cheatdvars[index], level.cheatstates[level.cheatdvars[index]]);
		}
	#/
}

/*
	Name: addcheat
	Namespace: cheat
	Checksum: 0x62F7C4CA
	Offset: 0x240
	Size: 0x9A
	Parameters: 2
	Flags: None
*/
function addcheat(toggledvar, cheatfunc)
{
	/#
		setdvar(toggledvar, 0);
	#/
	level.cheatstates[toggledvar] = getdvarint(toggledvar);
	level.cheatfuncs[toggledvar] = cheatfunc;
	if(level.cheatstates[toggledvar])
	{
		[[cheatfunc]](level.cheatstates[toggledvar]);
	}
}

/*
	Name: checkcheatchanged
	Namespace: cheat
	Checksum: 0x77FFE534
	Offset: 0x2E8
	Size: 0x96
	Parameters: 1
	Flags: None
*/
function checkcheatchanged(toggledvar)
{
	cheatvalue = getdvarint(toggledvar);
	if(level.cheatstates[toggledvar] == cheatvalue)
	{
		return;
	}
	if(cheatvalue)
	{
		level flag::set("has_cheated");
	}
	level.cheatstates[toggledvar] = cheatvalue;
	[[level.cheatfuncs[toggledvar]]](cheatvalue);
}

/*
	Name: specialfeaturesmenu
	Namespace: cheat
	Checksum: 0xE0E3652B
	Offset: 0x388
	Size: 0xAC
	Parameters: 0
	Flags: None
*/
function specialfeaturesmenu()
{
	level endon(#"unloaded");
	addcheat("sf_use_ignoreammo", &ignore_ammomode);
	level.cheatdvars = getarraykeys(level.cheatstates);
	for(;;)
	{
		for(index = 0; index < level.cheatdvars.size; index++)
		{
			checkcheatchanged(level.cheatdvars[index]);
		}
		wait(0.5);
	}
}

/*
	Name: ignore_ammomode
	Namespace: cheat
	Checksum: 0x558A341E
	Offset: 0x440
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function ignore_ammomode(cheatvalue)
{
	if(cheatvalue)
	{
		setsaveddvar("player_sustainAmmo", 1);
	}
	else
	{
		setsaveddvar("player_sustainAmmo", 0);
	}
}

/*
	Name: is_cheating
	Namespace: cheat
	Checksum: 0x52BCEE02
	Offset: 0x4A0
	Size: 0x22
	Parameters: 0
	Flags: None
*/
function is_cheating()
{
	return level flag::get("has_cheated");
}

