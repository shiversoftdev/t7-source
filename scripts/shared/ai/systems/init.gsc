// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\systems\weaponlist;
#using scripts\shared\gameskill_shared;
#using scripts\shared\name_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");

#namespace init;

/*
	Name: initweapon
	Namespace: init
	Checksum: 0x49BEA41E
	Offset: 0x238
	Size: 0xE8
	Parameters: 1
	Flags: Linked
*/
function initweapon(weapon)
{
	self.weaponinfo[weapon.name] = spawnstruct();
	self.weaponinfo[weapon.name].position = "none";
	self.weaponinfo[weapon.name].hasclip = 1;
	if(isdefined(weapon.clipmodel))
	{
		self.weaponinfo[weapon.name].useclip = 1;
	}
	else
	{
		self.weaponinfo[weapon.name].useclip = 0;
	}
}

/*
	Name: main
	Namespace: init
	Checksum: 0x5E702D00
	Offset: 0x328
	Size: 0x564
	Parameters: 0
	Flags: Linked
*/
function main()
{
	self.a = spawnstruct();
	self.a.weaponpos = [];
	if(self.weapon == level.weaponnone)
	{
		self aiutility::setcurrentweapon(level.weaponnone);
	}
	self aiutility::setprimaryweapon(self.weapon);
	if(self.secondaryweapon == level.weaponnone)
	{
		self aiutility::setsecondaryweapon(level.weaponnone);
	}
	self aiutility::setsecondaryweapon(self.secondaryweapon);
	self aiutility::setcurrentweapon(self.primaryweapon);
	self.initial_primaryweapon = self.primaryweapon;
	self.initial_secondaryweapon = self.secondaryweapon;
	self initweapon(self.primaryweapon);
	self initweapon(self.secondaryweapon);
	self initweapon(self.sidearm);
	self.weapon_positions = array("left", "right", "chest", "back");
	for(i = 0; i < self.weapon_positions.size; i++)
	{
		self.a.weaponpos[self.weapon_positions[i]] = level.weaponnone;
	}
	self.lastweapon = self.weapon;
	self thread begingrenadetracking();
	self thread globalgrenadetracking();
	firstinit();
	self.a.rockets = 3;
	self.a.rocketvisible = 1;
	self.a.pose = "stand";
	self.a.prevpose = self.a.pose;
	self.a.movement = "stop";
	self.a.special = "none";
	self.a.gunhand = "none";
	shared::placeweaponon(self.primaryweapon, "right");
	if(isdefined(self.secondaryweaponclass) && self.secondaryweaponclass != "none" && self.secondaryweaponclass != "pistol")
	{
		shared::placeweaponon(self.secondaryweapon, "back");
	}
	self.a.combatendtime = gettime();
	self.a.nextgrenadetrytime = 0;
	self.a.isaiming = 0;
	self.rightaimlimit = 45;
	self.leftaimlimit = -45;
	self.upaimlimit = 45;
	self.downaimlimit = -45;
	self.walk = 0;
	self.sprint = 0;
	self.a.postscriptfunc = undefined;
	self.baseaccuracy = self.accuracy;
	if(!isdefined(self.script_accuracy))
	{
		self.script_accuracy = 1;
	}
	if(self.team == "axis" || self.team == "team3")
	{
		self thread gameskill::axisaccuracycontrol();
	}
	else if(self.team == "allies")
	{
		self thread gameskill::alliesaccuracycontrol();
	}
	self.a.misstime = 0;
	self.bulletsinclip = self.weapon.clipsize;
	self.lastenemysighttime = 0;
	self.combattime = 0;
	self.suppressed = 0;
	self.suppressedtime = 0;
	if(self.team == "allies")
	{
		self.suppressionthreshold = 0.75;
	}
	else
	{
		self.suppressionthreshold = 0.5;
	}
	if(self.team == "allies")
	{
		self.randomgrenaderange = 0;
	}
	else
	{
		self.randomgrenaderange = 128;
	}
	self.reacquire_state = 0;
}

/*
	Name: setnameandrank
	Namespace: init
	Checksum: 0x834D6028
	Offset: 0x898
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function setnameandrank()
{
	self endon(#"death");
	self name::get();
}

/*
	Name: donothing
	Namespace: init
	Checksum: 0x99EC1590
	Offset: 0x8C8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function donothing()
{
}

/*
	Name: set_anim_playback_rate
	Namespace: init
	Checksum: 0xF199C4B9
	Offset: 0x8D8
	Size: 0x38
	Parameters: 0
	Flags: None
*/
function set_anim_playback_rate()
{
	self.animplaybackrate = 0.9 + randomfloat(0.2);
	self.moveplaybackrate = 1;
}

/*
	Name: trackvelocity
	Namespace: init
	Checksum: 0x3A96D7C2
	Offset: 0x918
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function trackvelocity()
{
	self endon(#"death");
	for(;;)
	{
		self.oldorigin = self.origin;
		wait(0.2);
	}
}

/*
	Name: checkapproachangles
	Namespace: init
	Checksum: 0xB2FF24E9
	Offset: 0x950
	Size: 0x410
	Parameters: 1
	Flags: None
*/
function checkapproachangles(transtypes)
{
	/#
		idealtransangles[1] = 45;
		idealtransangles[2] = 0;
		idealtransangles[3] = -45;
		idealtransangles[4] = 90;
		idealtransangles[6] = -90;
		idealtransangles[7] = 135;
		idealtransangles[8] = 180;
		idealtransangles[9] = -135;
		wait(0.05);
		for(i = 1; i <= 9; i++)
		{
			for(j = 0; j < transtypes.size; j++)
			{
				trans = transtypes[j];
				idealadd = 0;
				if(trans == "" || trans == "")
				{
					idealadd = 90;
				}
				else if(trans == "" || trans == "")
				{
					idealadd = -90;
				}
				if(isdefined(anim.covertransangles[trans][i]))
				{
					correctangle = angleclamp180(idealtransangles[i] + idealadd);
					actualangle = angleclamp180(anim.covertransangles[trans][i]);
					if((absangleclamp180(actualangle - correctangle)) > 7)
					{
						println(((((((("" + trans) + "") + i) + "") + actualangle) + "") + correctangle) + "");
					}
				}
			}
		}
		for(i = 1; i <= 9; i++)
		{
			for(j = 0; j < transtypes.size; j++)
			{
				trans = transtypes[j];
				idealadd = 0;
				if(trans == "" || trans == "")
				{
					idealadd = 90;
				}
				else if(trans == "" || trans == "")
				{
					idealadd = -90;
				}
				if(isdefined(anim.coverexitangles[trans][i]))
				{
					correctangle = angleclamp180(-1 * ((idealtransangles[i] + idealadd) + 180));
					actualangle = angleclamp180(anim.coverexitangles[trans][i]);
					if((absangleclamp180(actualangle - correctangle)) > 7)
					{
						println(((((((("" + trans) + "") + i) + "") + actualangle) + "") + correctangle) + "");
					}
				}
			}
		}
	#/
}

/*
	Name: getexitsplittime
	Namespace: init
	Checksum: 0x485C7C83
	Offset: 0xD68
	Size: 0x2A
	Parameters: 2
	Flags: None
*/
function getexitsplittime(approachtype, dir)
{
	return anim.coverexitsplit[approachtype][dir];
}

/*
	Name: gettranssplittime
	Namespace: init
	Checksum: 0x1D9807CF
	Offset: 0xDA0
	Size: 0x2A
	Parameters: 2
	Flags: None
*/
function gettranssplittime(approachtype, dir)
{
	return anim.covertranssplit[approachtype][dir];
}

/*
	Name: firstinit
	Namespace: init
	Checksum: 0xA42BA06F
	Offset: 0xDD8
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function firstinit()
{
	if(isdefined(anim.notfirsttime))
	{
		return;
	}
	anim.notfirsttime = 1;
	anim.grenadetimers["player_frag_grenade_sp"] = randomintrange(1000, 20000);
	anim.grenadetimers["player_flash_grenade_sp"] = randomintrange(1000, 20000);
	anim.grenadetimers["player_double_grenade"] = randomintrange(10000, 60000);
	anim.grenadetimers["AI_frag_grenade_sp"] = randomintrange(0, 20000);
	anim.grenadetimers["AI_flash_grenade_sp"] = randomintrange(0, 20000);
	anim.numgrenadesinprogresstowardsplayer = 0;
	anim.lastgrenadelandednearplayertime = -1000000;
	anim.lastfraggrenadetoplayerstart = -1000000;
	thread setnextplayergrenadetime();
	if(!isdefined(level.flag))
	{
		level.flag = [];
	}
	level.painai = undefined;
	anim.covercrouchleanpitch = -55;
}

/*
	Name: onplayerconnect
	Namespace: init
	Checksum: 0xEBE0AAA1
	Offset: 0xF50
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function onplayerconnect()
{
	player = self;
	firstinit();
	player.invul = 0;
}

/*
	Name: setnextplayergrenadetime
	Namespace: init
	Checksum: 0xD36AB55D
	Offset: 0xF90
	Size: 0x156
	Parameters: 0
	Flags: Linked
*/
function setnextplayergrenadetime()
{
	waittillframeend();
	if(isdefined(anim.playergrenaderangetime))
	{
		maxtime = int(anim.playergrenaderangetime * 0.7);
		if(maxtime < 1)
		{
			maxtime = 1;
		}
		anim.grenadetimers["player_frag_grenade_sp"] = randomintrange(0, maxtime);
		anim.grenadetimers["player_flash_grenade_sp"] = randomintrange(0, maxtime);
	}
	if(isdefined(anim.playerdoublegrenadetime))
	{
		maxtime = int(anim.playerdoublegrenadetime);
		mintime = int(maxtime / 2);
		if(maxtime <= mintime)
		{
			maxtime = mintime + 1;
		}
		anim.grenadetimers["player_double_grenade"] = randomintrange(mintime, maxtime);
	}
}

/*
	Name: addtomissiles
	Namespace: init
	Checksum: 0x320CAED
	Offset: 0x10F0
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function addtomissiles(grenade)
{
	if(!isdefined(level.missileentities))
	{
		level.missileentities = [];
	}
	if(!isdefined(level.missileentities))
	{
		level.missileentities = [];
	}
	else if(!isarray(level.missileentities))
	{
		level.missileentities = array(level.missileentities);
	}
	level.missileentities[level.missileentities.size] = grenade;
	while(isdefined(grenade))
	{
		wait(0.05);
	}
	arrayremovevalue(level.missileentities, grenade);
}

/*
	Name: globalgrenadetracking
	Namespace: init
	Checksum: 0x6E31397B
	Offset: 0x11C0
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function globalgrenadetracking()
{
	if(!isdefined(level.missileentities))
	{
		level.missileentities = [];
	}
	self endon(#"death");
	self thread globalgrenadelaunchertracking();
	self thread globalmissiletracking();
	for(;;)
	{
		self waittill(#"grenade_fire", grenade, weapon);
		grenade.owner = self;
		grenade.weapon = weapon;
		level thread addtomissiles(grenade);
	}
}

/*
	Name: globalgrenadelaunchertracking
	Namespace: init
	Checksum: 0xCAD206B4
	Offset: 0x1280
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function globalgrenadelaunchertracking()
{
	self endon(#"death");
	for(;;)
	{
		self waittill(#"grenade_launcher_fire", grenade, weapon);
		grenade.owner = self;
		grenade.weapon = weapon;
		level thread addtomissiles(grenade);
	}
}

/*
	Name: globalmissiletracking
	Namespace: init
	Checksum: 0xE8657850
	Offset: 0x1300
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function globalmissiletracking()
{
	self endon(#"death");
	for(;;)
	{
		self waittill(#"missile_fire", grenade, weapon);
		grenade.owner = self;
		grenade.weapon = weapon;
		level thread addtomissiles(grenade);
	}
}

/*
	Name: begingrenadetracking
	Namespace: init
	Checksum: 0x623988C7
	Offset: 0x1380
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function begingrenadetracking()
{
	self endon(#"death");
	for(;;)
	{
		self waittill(#"grenade_fire", grenade, weapon);
		grenade thread grenade_earthquake();
	}
}

/*
	Name: endondeath
	Namespace: init
	Checksum: 0x653FCA96
	Offset: 0x13D8
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function endondeath()
{
	self waittill(#"death");
	waittillframeend();
	self notify(#"end_explode");
}

/*
	Name: grenade_earthquake
	Namespace: init
	Checksum: 0x56AF4433
	Offset: 0x1400
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function grenade_earthquake()
{
	self thread endondeath();
	self endon(#"end_explode");
	self waittill(#"explode", position);
	playrumbleonposition("grenade_rumble", position);
	earthquake(0.3, 0.5, position, 400);
}

/*
	Name: end_script
	Namespace: init
	Checksum: 0x99EC1590
	Offset: 0x1490
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function end_script()
{
}

