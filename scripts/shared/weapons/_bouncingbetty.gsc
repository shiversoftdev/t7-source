// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#using_animtree("bouncing_betty");

#namespace bouncingbetty;

/*
	Name: init_shared
	Namespace: bouncingbetty
	Checksum: 0xC22A486C
	Offset: 0x468
	Size: 0x2D4
	Parameters: 0
	Flags: Linked
*/
function init_shared()
{
	level.bettydestroyedfx = "weapon/fx_betty_exp_destroyed";
	level._effect["fx_betty_friendly_light"] = "weapon/fx_betty_light_blue";
	level._effect["fx_betty_enemy_light"] = "weapon/fx_betty_light_orng";
	level.bettymindist = 20;
	level.bettystuntime = 1;
	bettyexplodeanim = %bouncing_betty::o_spider_mine_detonate;
	bettydeployanim = %bouncing_betty::o_spider_mine_deploy;
	level.bettyradius = getdvarint("betty_detect_radius", 180);
	level.bettyactivationdelay = getdvarfloat("betty_activation_delay", 1);
	level.bettygraceperiod = getdvarfloat("betty_grace_period", 0);
	level.bettydamageradius = getdvarint("betty_damage_radius", 180);
	level.bettydamagemax = getdvarint("betty_damage_max", 180);
	level.bettydamagemin = getdvarint("betty_damage_min", 70);
	level.bettydamageheight = getdvarint("betty_damage_cylinder_height", 200);
	level.bettyjumpheight = getdvarint("betty_jump_height_onground", 55);
	level.bettyjumpheightwall = getdvarint("betty_jump_height_wall", 20);
	level.bettyjumpheightwallangle = getdvarint("betty_onground_angle_threshold", 30);
	level.bettyjumpheightwallanglecos = cos(level.bettyjumpheightwallangle);
	level.bettyjumptime = getdvarfloat("betty_jump_time", 0.7);
	level.bettybombletspawndistance = 20;
	level.bettybombletcount = 4;
	level thread register();
	/#
		level thread bouncingbettydvarupdate();
	#/
	callback::add_weapon_watcher(&createbouncingbettywatcher);
}

/*
	Name: register
	Namespace: bouncingbetty
	Checksum: 0x68C82C49
	Offset: 0x748
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function register()
{
	clientfield::register("missile", "bouncingbetty_state", 1, 2, "int");
	clientfield::register("scriptmover", "bouncingbetty_state", 1, 2, "int");
}

/*
	Name: bouncingbettydvarupdate
	Namespace: bouncingbetty
	Checksum: 0x69A91686
	Offset: 0x7B8
	Size: 0x1EE
	Parameters: 0
	Flags: Linked
*/
function bouncingbettydvarupdate()
{
	/#
		for(;;)
		{
			level.bettyradius = getdvarint("", level.bettyradius);
			level.bettyactivationdelay = getdvarfloat("", level.bettyactivationdelay);
			level.bettygraceperiod = getdvarfloat("", level.bettygraceperiod);
			level.bettydamageradius = getdvarint("", level.bettydamageradius);
			level.bettydamagemax = getdvarint("", level.bettydamagemax);
			level.bettydamagemin = getdvarint("", level.bettydamagemin);
			level.bettydamageheight = getdvarint("", level.bettydamageheight);
			level.bettyjumpheight = getdvarint("", level.bettyjumpheight);
			level.bettyjumpheightwall = getdvarint("", level.bettyjumpheightwall);
			level.bettyjumpheightwallangle = getdvarint("", level.bettyjumpheightwallangle);
			level.bettyjumpheightwallanglecos = cos(level.bettyjumpheightwallangle);
			level.bettyjumptime = getdvarfloat("", level.bettyjumptime);
			wait(3);
		}
	#/
}

/*
	Name: createbouncingbettywatcher
	Namespace: bouncingbetty
	Checksum: 0x21DBE58C
	Offset: 0x9B0
	Size: 0x1B8
	Parameters: 0
	Flags: Linked
*/
function createbouncingbettywatcher()
{
	watcher = self weaponobjects::createproximityweaponobjectwatcher("bouncingbetty", self.team);
	watcher.onspawn = &onspawnbouncingbetty;
	watcher.watchforfire = 1;
	watcher.ondetonatecallback = &bouncingbettydetonate;
	watcher.activatesound = "wpn_betty_alert";
	watcher.hackable = 1;
	watcher.hackertoolradius = level.equipmenthackertoolradius;
	watcher.hackertooltimems = level.equipmenthackertooltimems;
	watcher.ownergetsassist = 1;
	watcher.ignoredirection = 1;
	watcher.immediatedetonation = 1;
	watcher.immunespecialty = "specialty_immunetriggerbetty";
	watcher.detectionmindist = level.bettymindist;
	watcher.detectiongraceperiod = level.bettygraceperiod;
	watcher.detonateradius = level.bettyradius;
	watcher.onfizzleout = &onbouncingbettyfizzleout;
	watcher.stun = &weaponobjects::weaponstun;
	watcher.stuntime = level.bettystuntime;
	watcher.activationdelay = level.bettyactivationdelay;
}

/*
	Name: onbouncingbettyfizzleout
	Namespace: bouncingbetty
	Checksum: 0xEE4E0A1C
	Offset: 0xB70
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function onbouncingbettyfizzleout()
{
	if(isdefined(self.minemover))
	{
		if(isdefined(self.minemover.killcament))
		{
			self.minemover.killcament delete();
		}
		self.minemover delete();
	}
	self delete();
}

/*
	Name: onspawnbouncingbetty
	Namespace: bouncingbetty
	Checksum: 0x956AE8B5
	Offset: 0xBF0
	Size: 0xAC
	Parameters: 2
	Flags: Linked
*/
function onspawnbouncingbetty(watcher, owner)
{
	weaponobjects::onspawnproximityweaponobject(watcher, owner);
	self.originalowner = owner;
	self thread spawnminemover();
	self trackonowner(owner);
	self thread trackusedstatondeath();
	self thread donotrackusedstatonpickup();
	self thread trackusedonhack();
}

/*
	Name: trackusedstatondeath
	Namespace: bouncingbetty
	Checksum: 0xAB87753B
	Offset: 0xCA8
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function trackusedstatondeath()
{
	self endon(#"do_not_track_used");
	self waittill(#"death");
	waittillframeend();
	if(isdefined(self.owner))
	{
		self.owner trackbouncingbettyasused();
	}
	self notify(#"end_donotrackusedonpickup");
	self notify(#"end_donotrackusedonhacked");
}

/*
	Name: donotrackusedstatonpickup
	Namespace: bouncingbetty
	Checksum: 0x57835688
	Offset: 0xD10
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function donotrackusedstatonpickup()
{
	self endon(#"end_donotrackusedonpickup");
	self waittill(#"picked_up");
	self notify(#"do_not_track_used");
}

/*
	Name: trackusedonhack
	Namespace: bouncingbetty
	Checksum: 0x70BB5F68
	Offset: 0xD48
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function trackusedonhack()
{
	self endon(#"end_donotrackusedonhacked");
	self waittill(#"hacked");
	self.originalowner trackbouncingbettyasused();
	self notify(#"do_not_track_used");
}

/*
	Name: trackbouncingbettyasused
	Namespace: bouncingbetty
	Checksum: 0xACE15D4B
	Offset: 0xD98
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function trackbouncingbettyasused()
{
	if(isplayer(self))
	{
		self addweaponstat(getweapon("bouncingbetty"), "used", 1);
	}
}

/*
	Name: trackonowner
	Namespace: bouncingbetty
	Checksum: 0xAF8469E2
	Offset: 0xDF8
	Size: 0x96
	Parameters: 1
	Flags: Linked
*/
function trackonowner(owner)
{
	if(level.trackbouncingbettiesonowner === 1)
	{
		if(!isdefined(owner))
		{
			return;
		}
		if(!isdefined(owner.activebouncingbetties))
		{
			owner.activebouncingbetties = [];
		}
		else
		{
			arrayremovevalue(owner.activebouncingbetties, undefined);
		}
		owner.activebouncingbetties[owner.activebouncingbetties.size] = self;
	}
}

/*
	Name: spawnminemover
	Namespace: bouncingbetty
	Checksum: 0x95E6A23
	Offset: 0xE98
	Size: 0x2A4
	Parameters: 0
	Flags: Linked
*/
function spawnminemover()
{
	self endon(#"death");
	self util::waittillnotmoving();
	self clientfield::set("bouncingbetty_state", 2);
	self useanimtree($bouncing_betty);
	self setanim(%bouncing_betty::o_spider_mine_deploy, 1, 0, 1);
	minemover = spawn("script_model", self.origin);
	minemover.angles = self.angles;
	minemover setmodel("tag_origin");
	minemover.owner = self.owner;
	mineup = anglestoup(minemover.angles);
	z_offset = getdvarfloat("scr_bouncing_betty_killcam_offset", 18);
	minemover enablelinkto();
	minemover linkto(self);
	minemover.killcamoffset = vectorscale(mineup, z_offset);
	minemover.weapon = self.weapon;
	minemover playsound("wpn_betty_arm");
	killcament = spawn("script_model", minemover.origin + minemover.killcamoffset);
	killcament.angles = (0, 0, 0);
	killcament setmodel("tag_origin");
	killcament setweapon(self.weapon);
	minemover.killcament = killcament;
	self.minemover = minemover;
	self thread killminemoveronpickup();
}

/*
	Name: killminemoveronpickup
	Namespace: bouncingbetty
	Checksum: 0xE7F9B829
	Offset: 0x1148
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function killminemoveronpickup()
{
	self.minemover endon(#"death");
	self util::waittill_any("picked_up", "hacked");
	self killminemover();
}

/*
	Name: killminemover
	Namespace: bouncingbetty
	Checksum: 0x6E34F188
	Offset: 0x11A8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function killminemover()
{
	if(isdefined(self.minemover))
	{
		if(isdefined(self.minemover.killcament))
		{
			self.minemover.killcament delete();
		}
		self.minemover delete();
	}
}

/*
	Name: bouncingbettydetonate
	Namespace: bouncingbetty
	Checksum: 0xBB0528B2
	Offset: 0x1210
	Size: 0x15C
	Parameters: 3
	Flags: Linked
*/
function bouncingbettydetonate(attacker, weapon, target)
{
	if(isdefined(weapon) && weapon.isvalid)
	{
		self.destroyedby = attacker;
		if(isdefined(attacker))
		{
			if(self.owner util::isenemyplayer(attacker))
			{
				attacker challenges::destroyedexplosive(weapon);
				scoreevents::processscoreevent("destroyed_bouncingbetty", attacker, self.owner, weapon);
			}
		}
		self bouncingbettydestroyed();
	}
	else
	{
		if(isdefined(self.minemover))
		{
			self.minemover.ignore_team_kills = 1;
			self.minemover setmodel(self.model);
			self.minemover thread bouncingbettyjumpandexplode();
			self delete();
		}
		else
		{
			self bouncingbettydestroyed();
		}
	}
}

/*
	Name: bouncingbettydestroyed
	Namespace: bouncingbetty
	Checksum: 0x518785ED
	Offset: 0x1378
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function bouncingbettydestroyed()
{
	playfx(level.bettydestroyedfx, self.origin);
	playsoundatposition("dst_equipment_destroy", self.origin);
	if(isdefined(self.trigger))
	{
		self.trigger delete();
	}
	self killminemover();
	self radiusdamage(self.origin, 128, 110, 10, self.owner, "MOD_EXPLOSIVE", self.weapon);
	self delete();
}

/*
	Name: bouncingbettyjumpandexplode
	Namespace: bouncingbetty
	Checksum: 0x58DEC02A
	Offset: 0x1460
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function bouncingbettyjumpandexplode()
{
	jumpdir = vectornormalize(anglestoup(self.angles));
	if(jumpdir[2] > level.bettyjumpheightwallanglecos)
	{
		jumpheight = level.bettyjumpheight;
	}
	else
	{
		jumpheight = level.bettyjumpheightwall;
	}
	explodepos = self.origin + (jumpdir * jumpheight);
	self.killcament moveto(explodepos + self.killcamoffset, level.bettyjumptime, 0, level.bettyjumptime);
	self clientfield::set("bouncingbetty_state", 1);
	wait(level.bettyjumptime);
	self thread mineexplode(jumpdir, explodepos);
}

/*
	Name: mineexplode
	Namespace: bouncingbetty
	Checksum: 0x76EB6742
	Offset: 0x1580
	Size: 0x17C
	Parameters: 2
	Flags: Linked
*/
function mineexplode(explosiondir, explodepos)
{
	if(!isdefined(self) || !isdefined(self.owner))
	{
		return;
	}
	self playsound("wpn_betty_explo");
	self clientfield::set("sndRattle", 1);
	wait(0.05);
	if(!isdefined(self) || !isdefined(self.owner))
	{
		return;
	}
	self cylinderdamage(explosiondir * level.bettydamageheight, explodepos, level.bettydamageradius, level.bettydamageradius, level.bettydamagemax, level.bettydamagemin, self.owner, "MOD_EXPLOSIVE", self.weapon);
	self ghost();
	wait(0.1);
	if(!isdefined(self) || !isdefined(self.owner))
	{
		return;
	}
	if(isdefined(self.trigger))
	{
		self.trigger delete();
	}
	self.killcament delete();
	self delete();
}

