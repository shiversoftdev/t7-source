// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_shellshock;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_remote_weapons;
#using scripts\shared\_oob;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_flashgrenades;
#using scripts\shared\weapons\_weaponobjects;

#namespace rcbomb;

/*
	Name: init
	Namespace: rcbomb
	Checksum: 0x51077698
	Offset: 0x810
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level._effect["rcbombexplosion"] = "killstreaks/fx_rcxd_exp";
	killstreaks::register("rcbomb", "rcbomb", "killstreak_rcbomb", "rcbomb_used", &activatercbomb);
	killstreaks::register_strings("rcbomb", &"KILLSTREAK_EARNED_RCBOMB", &"KILLSTREAK_RCBOMB_NOT_AVAILABLE", &"KILLSTREAK_RCBOMB_INBOUND", undefined, &"KILLSTREAK_RCBOMB_HACKED", 0);
	killstreaks::register_dialog("rcbomb", "mpl_killstreak_rcbomb", "rcBombDialogBundle", undefined, "friendlyRcBomb", "enemyRcBomb", "enemyRcBombMultiple", "friendlyRcBombHacked", "enemyRcBombHacked", "requestRcBomb");
	killstreaks::allow_assists("rcbomb", 1);
	killstreaks::register_alt_weapon("rcbomb", "killstreak_remote");
	killstreaks::register_alt_weapon("rcbomb", "rcbomb_turret");
	remote_weapons::registerremoteweapon("rcbomb", &"", &startremotecontrol, &endremotecontrol, 0);
	vehicle::add_main_callback("rc_car_mp", &initrcbomb);
	clientfield::register("vehicle", "rcbomb_stunned", 1, 1, "int");
}

/*
	Name: initrcbomb
	Namespace: rcbomb
	Checksum: 0x69B8A4C5
	Offset: 0xA00
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function initrcbomb()
{
	rcbomb = self;
	rcbomb clientfield::set("enemyvehicle", 1);
	rcbomb.allowfriendlyfiredamageoverride = &rccarallowfriendlyfiredamage;
	rcbomb enableaimassist();
	rcbomb setdrawinfrared(1);
	rcbomb.delete_on_death = 1;
	rcbomb.death_enter_cb = &waitremotecontrol;
	rcbomb.disableremoteweaponswitch = 1;
	rcbomb.overridevehicledamage = &ondamage;
	rcbomb.overridevehicledeath = &ondeath;
	rcbomb.watch_remote_weapon_death = 1;
	rcbomb.watch_remote_weapon_death_duration = 0.3;
	if(issentient(rcbomb) == 0)
	{
		rcbomb makesentient();
	}
}

/*
	Name: waitremotecontrol
	Namespace: rcbomb
	Checksum: 0x4EE7AEC8
	Offset: 0xB58
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function waitremotecontrol()
{
	remote_controlled = isdefined(self.control_initiated) && self.control_initiated || (isdefined(self.controlled) && self.controlled);
	if(remote_controlled)
	{
		notifystring = self util::waittill_any_return("remote_weapon_end", "rcbomb_shutdown");
		if(notifystring == "remote_weapon_end")
		{
			self waittill(#"rcbomb_shutdown");
		}
		else
		{
			self waittill(#"remote_weapon_end");
		}
	}
	else
	{
		self waittill(#"rcbomb_shutdown");
	}
}

/*
	Name: togglelightsonaftertime
	Namespace: rcbomb
	Checksum: 0x1B066843
	Offset: 0xC18
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function togglelightsonaftertime(time)
{
	self notify(#"togglelightsonaftertime_singleton");
	self endon(#"togglelightsonaftertime_singleton");
	rcbomb = self;
	rcbomb endon(#"death");
	wait(time);
	rcbomb clientfield::set("toggle_lights", 0);
}

/*
	Name: hackedprefunction
	Namespace: rcbomb
	Checksum: 0x153D2437
	Offset: 0xC90
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function hackedprefunction(hacker)
{
	rcbomb = self;
	rcbomb clientfield::set("toggle_lights", 1);
	rcbomb.owner unlink();
	rcbomb clientfield::set("vehicletransition", 0);
	rcbomb.owner killstreaks::clear_using_remote();
	rcbomb makevehicleunusable();
}

/*
	Name: hackedpostfunction
	Namespace: rcbomb
	Checksum: 0xF5A35B29
	Offset: 0xD50
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function hackedpostfunction(hacker)
{
	rcbomb = self;
	hacker remote_weapons::useremoteweapon(rcbomb, "rcbomb", 1, 0);
	rcbomb makevehicleunusable();
	hacker killstreaks::set_killstreak_delay_killcam("rcbomb");
	hacker killstreak_hacking::set_vehicle_drivable_time_starting_now(rcbomb);
}

/*
	Name: configureteampost
	Namespace: rcbomb
	Checksum: 0xF638D7AB
	Offset: 0xDF0
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function configureteampost(owner, ishacked)
{
	rcbomb = self;
	rcbomb thread watchownergameevents();
}

/*
	Name: activatercbomb
	Namespace: rcbomb
	Checksum: 0xFC9D7C05
	Offset: 0xE38
	Size: 0x4E8
	Parameters: 1
	Flags: Linked
*/
function activatercbomb(hardpointtype)
{
	/#
		assert(isplayer(self));
	#/
	player = self;
	if(!player killstreakrules::iskillstreakallowed(hardpointtype, player.team))
	{
		return false;
	}
	if(player usebuttonpressed())
	{
		return false;
	}
	placement = calculatespawnorigin(self.origin, self.angles);
	if(!isdefined(placement) || !self isonground() || self util::isusingremote() || killstreaks::is_interacting_with_object() || self oob::istouchinganyoobtrigger() || self killstreaks::is_killstreak_start_blocked())
	{
		self iprintlnbold(&"KILLSTREAK_RCBOMB_NOT_PLACEABLE");
		return false;
	}
	killstreak_id = player killstreakrules::killstreakstart("rcbomb", player.team, 0, 1);
	if(killstreak_id == -1)
	{
		return false;
	}
	rcbomb = spawnvehicle("rc_car_mp", placement.origin, placement.angles, "rcbomb");
	rcbomb killstreaks::configure_team("rcbomb", killstreak_id, player, "small_vehicle", undefined, &configureteampost);
	rcbomb killstreak_hacking::enable_hacking("rcbomb", &hackedprefunction, &hackedpostfunction);
	rcbomb.damagetaken = 0;
	rcbomb.abandoned = 0;
	rcbomb.killstreak_id = killstreak_id;
	rcbomb.activatingkillstreak = 1;
	rcbomb setinvisibletoall();
	rcbomb thread watchshutdown();
	rcbomb.health = killstreak_bundles::get_max_health(hardpointtype);
	rcbomb.maxhealth = killstreak_bundles::get_max_health(hardpointtype);
	rcbomb.hackedhealth = killstreak_bundles::get_hacked_health(hardpointtype);
	rcbomb.hackedhealthupdatecallback = &rcbomb_hacked_health_update;
	rcbomb.ignore_vehicle_underneath_splash_scalar = 1;
	self thread killstreaks::play_killstreak_start_dialog("rcbomb", self.team, killstreak_id);
	self addweaponstat(getweapon("rcbomb"), "used", 1);
	remote_weapons::useremoteweapon(rcbomb, "rcbomb", 1, 0);
	if(!isdefined(player) || !isalive(player) || (isdefined(player.laststand) && player.laststand) || player isempjammed())
	{
		if(isdefined(rcbomb))
		{
			rcbomb notify(#"remote_weapon_shutdown");
			rcbomb notify(#"rcbomb_shutdown");
		}
		return false;
	}
	rcbomb setvisibletoall();
	rcbomb.activatingkillstreak = 0;
	target_set(rcbomb);
	rcbomb thread watchgameended();
	return true;
}

/*
	Name: rcbomb_hacked_health_update
	Namespace: rcbomb
	Checksum: 0xE455A0FB
	Offset: 0x1328
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function rcbomb_hacked_health_update(hacker)
{
	rcbomb = self;
	if(rcbomb.health > rcbomb.hackedhealth)
	{
		rcbomb.health = rcbomb.hackedhealth;
	}
}

/*
	Name: startremotecontrol
	Namespace: rcbomb
	Checksum: 0x8A71FC4B
	Offset: 0x1388
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function startremotecontrol(rcbomb)
{
	player = self;
	rcbomb usevehicle(player, 0);
	rcbomb clientfield::set("vehicletransition", 1);
	rcbomb thread audio::sndupdatevehiclecontext(1);
	rcbomb thread watchtimeout();
	rcbomb thread watchdetonation();
	rcbomb thread watchhurttriggers();
	rcbomb thread watchwater();
	player vehicle::set_vehicle_drivable_time_starting_now(40000);
}

/*
	Name: endremotecontrol
	Namespace: rcbomb
	Checksum: 0xD040101D
	Offset: 0x1488
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function endremotecontrol(rcbomb, exitrequestedbyowner)
{
	if(exitrequestedbyowner == 0)
	{
		rcbomb notify(#"rcbomb_shutdown");
		rcbomb thread audio::sndupdatevehiclecontext(0);
	}
	rcbomb clientfield::set("vehicletransition", 0);
}

/*
	Name: watchdetonation
	Namespace: rcbomb
	Checksum: 0x7C4106E7
	Offset: 0x1500
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function watchdetonation()
{
	rcbomb = self;
	rcbomb endon(#"rcbomb_shutdown");
	rcbomb endon(#"death");
	while(!rcbomb.owner attackbuttonpressed())
	{
		wait(0.05);
	}
	rcbomb notify(#"rcbomb_shutdown");
}

/*
	Name: watchwater
	Namespace: rcbomb
	Checksum: 0x5D08FCE1
	Offset: 0x1578
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function watchwater()
{
	self endon(#"rcbomb_shutdown");
	inwater = 0;
	while(!inwater)
	{
		wait(0.5);
		trace = physicstrace(self.origin + vectorscale((0, 0, 1), 10), self.origin + vectorscale((0, 0, 1), 6), vectorscale((-1, -1, -1), 2), vectorscale((1, 1, 1), 2), self, 4);
		inwater = trace["fraction"] < 1;
	}
	self.abandoned = 1;
	self notify(#"rcbomb_shutdown");
}

/*
	Name: watchownergameevents
	Namespace: rcbomb
	Checksum: 0xD57BB4E5
	Offset: 0x1658
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function watchownergameevents()
{
	self notify(#"watchownergameevents_singleton");
	self endon(#"watchownergameevents_singleton");
	rcbomb = self;
	rcbomb endon(#"rcbomb_shutdown");
	rcbomb.owner util::waittill_any("joined_team", "disconnect", "joined_spectators");
	rcbomb.abandoned = 1;
	rcbomb notify(#"rcbomb_shutdown");
}

/*
	Name: watchtimeout
	Namespace: rcbomb
	Checksum: 0xD9271964
	Offset: 0x16F8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function watchtimeout()
{
	rcbomb = self;
	rcbomb thread killstreaks::waitfortimeout("rcbomb", 40000, &rc_shutdown, "rcbomb_shutdown");
}

/*
	Name: rc_shutdown
	Namespace: rcbomb
	Checksum: 0x80FD2D37
	Offset: 0x1750
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function rc_shutdown()
{
	rcbomb = self;
	rcbomb notify(#"rcbomb_shutdown");
}

/*
	Name: watchshutdown
	Namespace: rcbomb
	Checksum: 0x7BFE67CF
	Offset: 0x1780
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function watchshutdown()
{
	rcbomb = self;
	rcbomb endon(#"death");
	rcbomb waittill(#"rcbomb_shutdown");
	if(isdefined(rcbomb.activatingkillstreak) && rcbomb.activatingkillstreak)
	{
		killstreakrules::killstreakstop("rcbomb", rcbomb.originalteam, rcbomb.killstreak_id);
		rcbomb notify(#"rcbomb_shutdown");
		rcbomb delete();
	}
	else
	{
		attacker = (isdefined(rcbomb.owner) ? rcbomb.owner : undefined);
		rcbomb dodamage(rcbomb.health + 1, rcbomb.origin + vectorscale((0, 0, 1), 10), attacker, attacker, "none", "MOD_EXPLOSIVE", 0);
	}
}

/*
	Name: watchhurttriggers
	Namespace: rcbomb
	Checksum: 0xAA07F65A
	Offset: 0x18D0
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function watchhurttriggers()
{
	rcbomb = self;
	rcbomb endon(#"rcbomb_shutdown");
	while(true)
	{
		rcbomb waittill(#"touch", ent);
		if(isdefined(ent.classname) && (ent.classname == "trigger_hurt" || ent.classname == "trigger_out_of_bounds"))
		{
			rcbomb notify(#"rcbomb_shutdown");
		}
	}
}

/*
	Name: ondamage
	Namespace: rcbomb
	Checksum: 0xDACABBBD
	Offset: 0x1978
	Size: 0x1BA
	Parameters: 15
	Flags: Linked
*/
function ondamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(self.activatingkillstreak)
	{
		return 0;
	}
	if(!isdefined(eattacker) || eattacker != self.owner)
	{
		idamage = killstreaks::ondamageperweapon("rcbomb", eattacker, idamage, idflags, smeansofdeath, weapon, self.maxhealth, undefined, self.maxhealth * 0.4, undefined, 0, undefined, 1, 1);
	}
	if(isdefined(eattacker) && isdefined(eattacker.team) && eattacker.team != self.team)
	{
		if(weapon.isemp)
		{
			self.damage_on_death = 0;
			self.died_by_emp = 1;
			idamage = self.health + 1;
		}
	}
	if(weapon.name == "satchel_charge" && smeansofdeath == "MOD_EXPLOSIVE")
	{
		idamage = self.health + 1;
	}
	return idamage;
}

/*
	Name: ondeath
	Namespace: rcbomb
	Checksum: 0x387D8EF0
	Offset: 0x1B40
	Size: 0x1D4
	Parameters: 8
	Flags: Linked
*/
function ondeath(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	rcbomb = self;
	player = rcbomb.owner;
	player endon(#"disconnect");
	player endon(#"joined_team");
	player endon(#"joined_spectators");
	killstreakrules::killstreakstop("rcbomb", rcbomb.originalteam, rcbomb.killstreak_id);
	rcbomb clientfield::set("enemyvehicle", 0);
	rcbomb explode(eattacker, weapon);
	hide_after_wait_time = (rcbomb.died_by_emp === 1 ? 0.2 : 0.1);
	if(isdefined(player))
	{
		player util::freeze_player_controls(1);
		rcbomb thread hideafterwait(hide_after_wait_time);
		wait(0.2);
		player util::freeze_player_controls(0);
	}
	else
	{
		rcbomb thread hideafterwait(hide_after_wait_time);
	}
	if(isdefined(rcbomb))
	{
		rcbomb notify(#"rcbomb_shutdown");
	}
}

/*
	Name: watchgameended
	Namespace: rcbomb
	Checksum: 0x1EFC175E
	Offset: 0x1D20
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function watchgameended()
{
	rcbomb = self;
	rcbomb endon(#"death");
	level waittill(#"game_ended");
	rcbomb.abandoned = 1;
	rcbomb.selfdestruct = 1;
	rcbomb notify(#"rcbomb_shutdown");
}

/*
	Name: hideafterwait
	Namespace: rcbomb
	Checksum: 0x7FA2DA64
	Offset: 0x1D90
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function hideafterwait(waittime)
{
	self endon(#"death");
	wait(waittime);
	self setinvisibletoall();
}

/*
	Name: explode
	Namespace: rcbomb
	Checksum: 0x7C78D3DD
	Offset: 0x1DD0
	Size: 0x2C4
	Parameters: 2
	Flags: Linked
*/
function explode(attacker, weapon)
{
	self endon(#"death");
	owner = self.owner;
	if(!isdefined(attacker) && isdefined(self.owner))
	{
		attacker = self.owner;
	}
	self vehicle_death::death_fx();
	self thread vehicle_death::death_radius_damage();
	self thread vehicle_death::set_death_model(self.deathmodel, self.modelswapdelay);
	self vehicle::toggle_tread_fx(0);
	self vehicle::toggle_exhaust_fx(0);
	self vehicle::toggle_sounds(0);
	self vehicle::lights_off();
	self playrumbleonentity("rcbomb_explosion");
	if(!self.abandoned && attacker != self.owner && isplayer(attacker))
	{
		attacker challenges::destroyrcbomb(weapon);
		if(self.owner util::isenemyplayer(attacker))
		{
			scoreevents::processscoreevent("destroyed_hover_rcxd", attacker, self.owner, weapon);
			luinotifyevent(&"player_callout", 2, &"KILLSTREAK_DESTROYED_RCBOMB", attacker.entnum);
			if(isdefined(weapon) && weapon.isvalid)
			{
				weaponstatname = "destroyed";
				level.globalkillstreaksdestroyed++;
				weapon_rcbomb = getweapon("rcbomb");
				attacker addweaponstat(weapon_rcbomb, "destroyed", 1);
				attacker addweaponstat(weapon, "destroyed_controlled_killstreak", 1);
			}
			self killstreaks::play_destroyed_dialog_on_owner("rcbomb", self.killstreak_id);
		}
	}
}

/*
	Name: rccarallowfriendlyfiredamage
	Namespace: rcbomb
	Checksum: 0x53D55994
	Offset: 0x20A0
	Size: 0x76
	Parameters: 4
	Flags: Linked
*/
function rccarallowfriendlyfiredamage(einflictor, eattacker, smeansofdeath, weapon)
{
	if(isdefined(eattacker) && eattacker == self.owner)
	{
		return true;
	}
	if(isdefined(einflictor) && einflictor islinkedto(self))
	{
		return true;
	}
	return false;
}

/*
	Name: getplacementstartheight
	Namespace: rcbomb
	Checksum: 0x4468EAB8
	Offset: 0x2120
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function getplacementstartheight()
{
	startheight = 50;
	switch(self getstance())
	{
		case "crouch":
		{
			startheight = 30;
			break;
		}
		case "prone":
		{
			startheight = 15;
			break;
		}
	}
	return startheight;
}

/*
	Name: calculatespawnorigin
	Namespace: rcbomb
	Checksum: 0xFF089CA0
	Offset: 0x2198
	Size: 0x4CA
	Parameters: 2
	Flags: Linked
*/
function calculatespawnorigin(origin, angles)
{
	startheight = getplacementstartheight();
	mins = vectorscale((-1, -1, 0), 5);
	maxs = (5, 5, 10);
	startpoints = [];
	startangles = [];
	wheelcounts = [];
	testcheck = [];
	largestcount = 0;
	largestcountindex = 0;
	testangles = [];
	testangles[0] = (0, 0, 0);
	testangles[1] = vectorscale((0, 1, 0), 20);
	testangles[2] = vectorscale((0, -1, 0), 20);
	testangles[3] = vectorscale((0, 1, 0), 45);
	testangles[4] = vectorscale((0, -1, 0), 45);
	heightoffset = 5;
	for(i = 0; i < testangles.size; i++)
	{
		testcheck[i] = 0;
		startangles[i] = (0, angles[1], 0);
		startpoint = origin + (vectorscale(anglestoforward(startangles[i] + testangles[i]), 70));
		endpoint = startpoint - vectorscale((0, 0, 1), 100);
		startpoint = startpoint + (0, 0, startheight);
		mask = 1 | 2;
		trace = physicstrace(startpoint, endpoint, mins, maxs, self, mask);
		if(isdefined(trace["entity"]) && isplayer(trace["entity"]))
		{
			wheelcounts[i] = 0;
			continue;
		}
		startpoints[i] = trace["position"] + (0, 0, heightoffset);
		wheelcounts[i] = testwheellocations(startpoints[i], startangles[i], heightoffset);
		if(positionwouldtelefrag(startpoints[i]))
		{
			continue;
		}
		if(largestcount < wheelcounts[i])
		{
			largestcount = wheelcounts[i];
			largestcountindex = i;
		}
		if(wheelcounts[i] >= 3)
		{
			testcheck[i] = 1;
			if(testspawnorigin(startpoints[i], startangles[i]))
			{
				placement = spawnstruct();
				placement.origin = startpoints[i];
				placement.angles = startangles[i];
				return placement;
			}
		}
	}
	for(i = 0; i < testangles.size; i++)
	{
		if(!testcheck[i])
		{
			if(wheelcounts[i] >= 2)
			{
				if(testspawnorigin(startpoints[i], startangles[i]))
				{
					placement = spawnstruct();
					placement.origin = startpoints[i];
					placement.angles = startangles[i];
					return placement;
				}
			}
		}
	}
	return undefined;
}

/*
	Name: testwheellocations
	Namespace: rcbomb
	Checksum: 0x51AC7F92
	Offset: 0x2670
	Size: 0x202
	Parameters: 3
	Flags: Linked
*/
function testwheellocations(origin, angles, heightoffset)
{
	forward = 13;
	side = 10;
	wheels = [];
	wheels[0] = (forward, side, 0);
	wheels[1] = (forward, -1 * side, 0);
	wheels[2] = (-1 * forward, -1 * side, 0);
	wheels[3] = (-1 * forward, side, 0);
	height = 5;
	touchcount = 0;
	yawangles = (0, angles[1], 0);
	for(i = 0; i < 4; i++)
	{
		wheel = rotatepoint(wheels[i], yawangles);
		startpoint = origin + wheel;
		endpoint = startpoint + (0, 0, -1 * height - heightoffset);
		startpoint = startpoint + (0, 0, height - heightoffset);
		trace = bullettrace(startpoint, endpoint, 0, self);
		if(trace["fraction"] < 1)
		{
			touchcount++;
		}
	}
	return touchcount;
}

/*
	Name: testspawnorigin
	Namespace: rcbomb
	Checksum: 0xAF896409
	Offset: 0x2880
	Size: 0x22E
	Parameters: 2
	Flags: Linked
*/
function testspawnorigin(origin, angles)
{
	liftedorigin = origin + vectorscale((0, 0, 1), 5);
	size = 12;
	height = 15;
	mins = (-1 * size, -1 * size, 0);
	maxs = (size, size, height);
	absmins = liftedorigin + mins;
	absmaxs = liftedorigin + maxs;
	if(boundswouldtelefrag(absmins, absmaxs))
	{
		return false;
	}
	startheight = getplacementstartheight();
	mask = (1 | 2) | 4;
	trace = physicstrace(liftedorigin, origin + (0, 0, 1), mins, maxs, self, mask);
	if(trace["fraction"] < 1)
	{
		return false;
	}
	size = 2.5;
	height = size * 2;
	mins = (-1 * size, -1 * size, 0);
	maxs = (size, size, height);
	sweeptrace = physicstrace(self.origin + (0, 0, startheight), liftedorigin, mins, maxs, self, mask);
	if(sweeptrace["fraction"] < 1)
	{
		return false;
	}
	return true;
}

