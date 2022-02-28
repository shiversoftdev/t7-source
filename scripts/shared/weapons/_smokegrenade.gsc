// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_weaponobjects;

#namespace smokegrenade;

/*
	Name: init_shared
	Namespace: smokegrenade
	Checksum: 0xA4898F3B
	Offset: 0x270
	Size: 0x8C
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.willypetedamageradius = 300;
	level.willypetedamageheight = 128;
	level.smokegrenadeduration = 8;
	level.smokegrenadedissipation = 4;
	level.smokegrenadetotaltime = level.smokegrenadeduration + level.smokegrenadedissipation;
	level.fx_smokegrenade_single = "smoke_center";
	level.smoke_grenade_triggers = [];
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: watchsmokegrenadedetonation
	Namespace: smokegrenade
	Checksum: 0xF9D8A67C
	Offset: 0x308
	Size: 0x134
	Parameters: 5
	Flags: Linked
*/
function watchsmokegrenadedetonation(owner, statweapon, grenadeweaponname, duration, totaltime)
{
	self endon(#"trophy_destroyed");
	owner addweaponstat(statweapon, "used", 1);
	self waittill(#"explode", position, surface);
	onefoot = vectorscale((0, 0, 1), 12);
	startpos = position + onefoot;
	smokeweapon = getweapon(grenadeweaponname);
	smokedetonate(owner, statweapon, smokeweapon, position, 128, totaltime, duration);
	damageeffectarea(owner, startpos, smokeweapon.explosionradius, level.willypetedamageheight, undefined);
}

/*
	Name: smokedetonate
	Namespace: smokegrenade
	Checksum: 0x9273D07C
	Offset: 0x448
	Size: 0x160
	Parameters: 7
	Flags: Linked
*/
function smokedetonate(owner, statweapon, smokeweapon, position, radius, effectlifetime, smokeblockduration)
{
	dir_up = (0, 0, 1);
	ent = spawntimedfx(smokeweapon, position, dir_up, effectlifetime);
	ent setteam(owner.team);
	ent setowner(owner);
	ent thread smokeblocksight(radius);
	ent thread spawnsmokegrenadetrigger(smokeblockduration);
	if(isdefined(owner))
	{
		owner.smokegrenadetime = gettime();
		owner.smokegrenadeposition = position;
	}
	thread playsmokesound(position, smokeblockduration, statweapon.projsmokestartsound, statweapon.projsmokeendsound, statweapon.projsmokeloopsound);
	return ent;
}

/*
	Name: damageeffectarea
	Namespace: smokegrenade
	Checksum: 0xD0AEF74C
	Offset: 0x5B0
	Size: 0x9C
	Parameters: 5
	Flags: Linked
*/
function damageeffectarea(owner, position, radius, height, killcament)
{
	effectarea = spawn("trigger_radius", position, 0, radius, height);
	if(isdefined(level.dogsonflashdogs))
	{
		owner thread [[level.dogsonflashdogs]](effectarea);
	}
	effectarea delete();
}

/*
	Name: smokeblocksight
	Namespace: smokegrenade
	Checksum: 0xF846A3DC
	Offset: 0x658
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function smokeblocksight(radius)
{
	self endon(#"death");
	while(true)
	{
		fxblocksight(self, radius);
		/#
			if(getdvarint("", 0))
			{
				sphere(self.origin, 128, (1, 0, 0), 0.25, 0, 10, 15);
			}
		#/
		wait(0.75);
	}
}

/*
	Name: spawnsmokegrenadetrigger
	Namespace: smokegrenade
	Checksum: 0xDF98B74C
	Offset: 0x6F8
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function spawnsmokegrenadetrigger(duration)
{
	team = self.team;
	trigger = spawn("trigger_radius", self.origin, 0, 128, 128);
	if(!isdefined(level.smoke_grenade_triggers))
	{
		level.smoke_grenade_triggers = [];
	}
	else if(!isarray(level.smoke_grenade_triggers))
	{
		level.smoke_grenade_triggers = array(level.smoke_grenade_triggers);
	}
	level.smoke_grenade_triggers[level.smoke_grenade_triggers.size] = trigger;
	self util::waittill_any_timeout(duration, "death");
	arrayremovevalue(level.smoke_grenade_triggers, trigger);
	trigger delete();
}

/*
	Name: isinsmokegrenade
	Namespace: smokegrenade
	Checksum: 0xAB5B5D76
	Offset: 0x820
	Size: 0x94
	Parameters: 0
	Flags: None
*/
function isinsmokegrenade()
{
	foreach(trigger in level.smoke_grenade_triggers)
	{
		if(self istouching(trigger))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: on_player_spawned
	Namespace: smokegrenade
	Checksum: 0x32980ACC
	Offset: 0x8C0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self endon(#"disconnect");
	self thread begin_other_grenade_tracking();
}

/*
	Name: begin_other_grenade_tracking
	Namespace: smokegrenade
	Checksum: 0x5B9A858F
	Offset: 0x8F0
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function begin_other_grenade_tracking()
{
	self endon(#"death");
	self endon(#"disconnect");
	self notify(#"smoketrackingstart");
	self endon(#"smoketrackingstart");
	weapon_smoke = getweapon("willy_pete");
	for(;;)
	{
		self waittill(#"grenade_fire", grenade, weapon, cooktime);
		if(grenade util::ishacked())
		{
			continue;
		}
		if(weapon.rootweapon == weapon_smoke)
		{
			grenade thread watchsmokegrenadedetonation(self, weapon_smoke, level.fx_smokegrenade_single, level.smokegrenadeduration, level.smokegrenadetotaltime);
		}
	}
}

/*
	Name: playsmokesound
	Namespace: smokegrenade
	Checksum: 0x175271AF
	Offset: 0x9E8
	Size: 0x13C
	Parameters: 5
	Flags: Linked
*/
function playsmokesound(position, duration, startsound, stopsound, loopsound)
{
	smokesound = spawn("script_origin", (0, 0, 1));
	smokesound.origin = position;
	if(isdefined(startsound))
	{
		smokesound playsound(startsound);
	}
	if(isdefined(loopsound))
	{
		smokesound playloopsound(loopsound);
	}
	if(duration > 0.5)
	{
		wait(duration - 0.5);
	}
	if(isdefined(stopsound))
	{
		thread sound::play_in_space(stopsound, position);
	}
	smokesound stoploopsound(0.5);
	wait(0.5);
	smokesound delete();
}

