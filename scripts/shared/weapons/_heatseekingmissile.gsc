// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapon_utils;

#namespace heatseekingmissile;

/*
	Name: init_shared
	Namespace: heatseekingmissile
	Checksum: 0x50A1EADF
	Offset: 0x318
	Size: 0x84
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	game["locking_on_sound"] = "uin_alert_lockon_start";
	game["locked_on_sound"] = "uin_alert_lockon";
	callback::on_spawned(&on_player_spawned);
	level.fx_flare = "killstreaks/fx_heli_chaff";
	/#
		setdvar("", "");
	#/
}

/*
	Name: on_player_spawned
	Namespace: heatseekingmissile
	Checksum: 0xF794B0F4
	Offset: 0x3A8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self endon(#"disconnect");
	self clearirtarget();
	thread stingertoggleloop();
	self thread stingerfirednotify();
}

/*
	Name: clearirtarget
	Namespace: heatseekingmissile
	Checksum: 0xDE948D44
	Offset: 0x400
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function clearirtarget()
{
	self notify(#"stop_lockon_sound");
	self notify(#"stop_locked_sound");
	self.stingerlocksound = undefined;
	self stoprumble("stinger_lock_rumble");
	self.stingerlockstarttime = 0;
	self.stingerlockstarted = 0;
	self.stingerlockfinalized = 0;
	self.stingerlockdetected = 0;
	if(isdefined(self.stingertarget))
	{
		self.stingertarget notify(#"missile_unlocked");
		self lockingon(self.stingertarget, 0);
		self lockedon(self.stingertarget, 0);
	}
	self.stingertarget = undefined;
	self weaponlockfree();
	self weaponlocktargettooclose(0);
	self weaponlocknoclearance(0);
	self stoplocalsound(game["locking_on_sound"]);
	self stoplocalsound(game["locked_on_sound"]);
	self destroylockoncanceledmessage();
}

/*
	Name: stingerfirednotify
	Namespace: heatseekingmissile
	Checksum: 0xA4BF0F7A
	Offset: 0x588
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function stingerfirednotify()
{
	self endon(#"disconnect");
	self endon(#"death");
	while(true)
	{
		self waittill(#"missile_fire", missile, weapon);
		/#
			thread debug_missile(missile);
		#/
		if(weapon.lockontype == "Legacy Single")
		{
			if(isdefined(self.stingertarget) && self.stingerlockfinalized)
			{
				self.stingertarget notify(#"stinger_fired_at_me", missile, weapon, self);
			}
		}
	}
}

/*
	Name: debug_missile
	Namespace: heatseekingmissile
	Checksum: 0xEC561DEA
	Offset: 0x648
	Size: 0x248
	Parameters: 1
	Flags: Linked
*/
function debug_missile(missile)
{
	/#
		level notify(#"debug_missile");
		level endon(#"debug_missile");
		level.debug_missile_dots = [];
		while(true)
		{
			if(getdvarint("", 0) == 0)
			{
				wait(0.5);
				continue;
			}
			if(isdefined(missile))
			{
				missile_info = spawnstruct();
				missile_info.origin = missile.origin;
				target = missile missile_gettarget();
				missile_info.targetentnum = (isdefined(target) ? target getentitynumber() : undefined);
				if(!isdefined(level.debug_missile_dots))
				{
					level.debug_missile_dots = [];
				}
				else if(!isarray(level.debug_missile_dots))
				{
					level.debug_missile_dots = array(level.debug_missile_dots);
				}
				level.debug_missile_dots[level.debug_missile_dots.size] = missile_info;
			}
			foreach(missile_info in level.debug_missile_dots)
			{
				dot_color = (isdefined(missile_info.targetentnum) ? (1, 0, 0) : (0, 1, 0));
				dev::debug_sphere(missile_info.origin, 10, dot_color, 0.66, 1);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: stingerwaitforads
	Namespace: heatseekingmissile
	Checksum: 0x1FE97987
	Offset: 0x898
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function stingerwaitforads()
{
	while(!self playerstingerads())
	{
		wait(0.05);
		currentweapon = self getcurrentweapon();
		if(currentweapon.lockontype != "Legacy Single")
		{
			return false;
		}
	}
	return true;
}

/*
	Name: stingertoggleloop
	Namespace: heatseekingmissile
	Checksum: 0x9BCA456
	Offset: 0x910
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function stingertoggleloop()
{
	self endon(#"disconnect");
	self endon(#"death");
	for(;;)
	{
		self waittill(#"weapon_change", weapon);
		while(weapon.lockontype == "Legacy Single")
		{
			if(self getweaponammoclip(weapon) == 0)
			{
				wait(0.05);
				weapon = self getcurrentweapon();
				continue;
			}
			if(!stingerwaitforads())
			{
				break;
			}
			self thread stingerirtloop(weapon);
			while(self playerstingerads())
			{
				wait(0.05);
			}
			self notify(#"stinger_irt_off");
			self clearirtarget();
			weapon = self getcurrentweapon();
		}
	}
}

/*
	Name: stingerirtloop
	Namespace: heatseekingmissile
	Checksum: 0x1FBB6C0
	Offset: 0xA50
	Size: 0x670
	Parameters: 1
	Flags: Linked
*/
function stingerirtloop(weapon)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"stinger_irt_off");
	locklength = self getlockonspeed();
	for(;;)
	{
		wait(0.05);
		if(!self hasweapon(weapon))
		{
			break;
		}
		if(self.stingerlockfinalized)
		{
			passed = softsighttest();
			if(!passed)
			{
				continue;
			}
			if(!self isstillvalidtarget(self.stingertarget, weapon) || self insidestingerreticlelocked(self.stingertarget, weapon) == 0)
			{
				self setweaponlockonpercent(weapon, 0);
				self clearirtarget();
				continue;
			}
			if(!self.stingertarget.locked_on)
			{
				self.stingertarget notify(#"missile_lock", self, self getcurrentweapon());
			}
			self lockingon(self.stingertarget, 0);
			self lockedon(self.stingertarget, 1);
			if(isdefined(weapon))
			{
				setfriendlyflags(weapon, self.stingertarget);
			}
			thread looplocallocksound(game["locked_on_sound"], 0.75);
			continue;
		}
		if(self.stingerlockstarted)
		{
			if(!self isstillvalidtarget(self.stingertarget, weapon) || self insidestingerreticlelocked(self.stingertarget, weapon) == 0)
			{
				self setweaponlockonpercent(weapon, 0);
				self clearirtarget();
				continue;
			}
			self lockingon(self.stingertarget, 1);
			self lockedon(self.stingertarget, 0);
			if(isdefined(weapon))
			{
				setfriendlyflags(weapon, self.stingertarget);
			}
			passed = softsighttest();
			if(!passed)
			{
				continue;
			}
			timepassed = gettime() - self.stingerlockstarttime;
			if(isdefined(weapon))
			{
				self setweaponlockonpercent(weapon, (timepassed / locklength) * 100);
				setfriendlyflags(weapon, self.stingertarget);
			}
			if(timepassed < locklength)
			{
				continue;
			}
			/#
				assert(isdefined(self.stingertarget));
			#/
			self notify(#"stop_lockon_sound");
			self.stingerlockfinalized = 1;
			self weaponlockfinalize(self.stingertarget);
			continue;
		}
		besttarget = self getbeststingertarget(weapon);
		if(!isdefined(besttarget) || (isdefined(self.stingertarget) && self.stingertarget != besttarget))
		{
			self destroylockoncanceledmessage();
			if(self.stingerlockdetected == 1)
			{
				self weaponlockfree();
				self.stingerlockdetected = 0;
			}
			continue;
		}
		if(!self locksighttest(besttarget))
		{
			self destroylockoncanceledmessage();
			continue;
		}
		if(isdefined(besttarget.lockondelay) && besttarget.lockondelay)
		{
			self displaylockoncanceledmessage();
			continue;
		}
		if(!targetwithinrangeofplayspace(besttarget))
		{
			self displaylockoncanceledmessage();
			continue;
		}
		self destroylockoncanceledmessage();
		if(self insidestingerreticlelocked(besttarget, weapon) == 0)
		{
			if(self.stingerlockdetected == 0)
			{
				self weaponlockdetect(besttarget);
			}
			self.stingerlockdetected = 1;
			if(isdefined(weapon))
			{
				setfriendlyflags(weapon, besttarget);
			}
			continue;
		}
		self.stingerlockdetected = 0;
		initlockfield(besttarget);
		self.stingertarget = besttarget;
		self.stingerlockstarttime = gettime();
		self.stingerlockstarted = 1;
		self.stingerlostsightlinetime = 0;
		self weaponlockstart(besttarget);
		self thread looplocalseeksound(game["locking_on_sound"], 0.6);
	}
}

/*
	Name: targetwithinrangeofplayspace
	Namespace: heatseekingmissile
	Checksum: 0xDA82C207
	Offset: 0x10C8
	Size: 0x170
	Parameters: 1
	Flags: Linked
*/
function targetwithinrangeofplayspace(target)
{
	/#
		if(getdvarint("", 0) > 0)
		{
			extraradiusdvar = getdvarint("", 5000);
			if(extraradiusdvar != (isdefined(level.missilelockplayspacecheckextraradius) ? level.missilelockplayspacecheckextraradius : 0))
			{
				level.missilelockplayspacecheckextraradius = extraradiusdvar;
				level.missilelockplayspacecheckradiussqr = undefined;
			}
		}
	#/
	if(level.missilelockplayspacecheckenabled === 1)
	{
		if(!isdefined(target))
		{
			return false;
		}
		if(!isdefined(level.playspacecenter))
		{
			level.playspacecenter = util::getplayspacecenter();
		}
		if(!isdefined(level.missilelockplayspacecheckradiussqr))
		{
			level.missilelockplayspacecheckradiussqr = ((util::getplayspacemaxwidth() * 0.5) + level.missilelockplayspacecheckextraradius) * ((util::getplayspacemaxwidth() * 0.5) + level.missilelockplayspacecheckextraradius);
		}
		if(distance2dsquared(target.origin, level.playspacecenter) > level.missilelockplayspacecheckradiussqr)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: destroylockoncanceledmessage
	Namespace: heatseekingmissile
	Checksum: 0xE97B552
	Offset: 0x1240
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function destroylockoncanceledmessage()
{
	if(isdefined(self.lockoncanceledmessage))
	{
		self.lockoncanceledmessage destroy();
	}
}

/*
	Name: displaylockoncanceledmessage
	Namespace: heatseekingmissile
	Checksum: 0x770F8F57
	Offset: 0x1278
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function displaylockoncanceledmessage()
{
	if(isdefined(self.lockoncanceledmessage))
	{
		return;
	}
	self.lockoncanceledmessage = newclienthudelem(self);
	self.lockoncanceledmessage.fontscale = 1.25;
	self.lockoncanceledmessage.x = 0;
	self.lockoncanceledmessage.y = 50;
	self.lockoncanceledmessage.alignx = "center";
	self.lockoncanceledmessage.aligny = "top";
	self.lockoncanceledmessage.horzalign = "center";
	self.lockoncanceledmessage.vertalign = "top";
	self.lockoncanceledmessage.foreground = 1;
	self.lockoncanceledmessage.hidewhendead = 0;
	self.lockoncanceledmessage.hidewheninmenu = 1;
	self.lockoncanceledmessage.archived = 0;
	self.lockoncanceledmessage.alpha = 1;
	self.lockoncanceledmessage settext(&"MP_CANNOT_LOCKON_TO_TARGET");
}

/*
	Name: getbeststingertarget
	Namespace: heatseekingmissile
	Checksum: 0x7799C0EA
	Offset: 0x13D8
	Size: 0x3BC
	Parameters: 1
	Flags: Linked
*/
function getbeststingertarget(weapon)
{
	targetsall = [];
	if(isdefined(self.get_stinger_target_override))
	{
		targetsall = self [[self.get_stinger_target_override]]();
	}
	else
	{
		targetsall = target_getarray();
	}
	targetsvalid = [];
	for(idx = 0; idx < targetsall.size; idx++)
	{
		/#
			if(getdvarstring("") == "")
			{
				if(self insidestingerreticlenolock(targetsall[idx], weapon))
				{
					targetsvalid[targetsvalid.size] = targetsall[idx];
				}
				continue;
			}
		#/
		target = targetsall[idx];
		if(level.teambased || level.use_team_based_logic_for_locking_on === 1)
		{
			if(isdefined(target.team) && target.team != self.team)
			{
				if(self insidestingerreticledetect(target, weapon))
				{
					if(!isdefined(self.is_valid_target_for_stinger_override) || self [[self.is_valid_target_for_stinger_override]](target))
					{
						hascamo = isdefined(target.camo_state) && target.camo_state == 1 && !self hasperk("specialty_showenemyequipment");
						if(!hascamo)
						{
							targetsvalid[targetsvalid.size] = target;
						}
					}
				}
			}
			continue;
		}
		if(self insidestingerreticledetect(target, weapon))
		{
			if(isdefined(target.owner) && self != target.owner || (isplayer(target) && self != target))
			{
				if(!isdefined(self.is_valid_target_for_stinger_override) || self [[self.is_valid_target_for_stinger_override]](target))
				{
					targetsvalid[targetsvalid.size] = target;
				}
			}
		}
	}
	if(targetsvalid.size == 0)
	{
		return undefined;
	}
	besttarget = targetsvalid[0];
	if(targetsvalid.size > 1)
	{
		closestratio = 0;
		foreach(target in targetsvalid)
		{
			ratio = ratiodistancefromscreencenter(target, weapon);
			if(ratio > closestratio)
			{
				closestratio = ratio;
				besttarget = target;
			}
		}
	}
	return besttarget;
}

/*
	Name: calclockonradius
	Namespace: heatseekingmissile
	Checksum: 0x3CBC8529
	Offset: 0x17A0
	Size: 0xFA
	Parameters: 2
	Flags: Linked
*/
function calclockonradius(target, weapon)
{
	radius = self getlockonradius();
	if(isdefined(weapon) && isdefined(weapon.lockonscreenradius) && weapon.lockonscreenradius > radius)
	{
		radius = weapon.lockonscreenradius;
	}
	if(isdefined(level.lockoncloserange) && isdefined(level.lockoncloseradiusscaler))
	{
		dist2 = distancesquared(target.origin, self.origin);
		if(dist2 < (level.lockoncloserange * level.lockoncloserange))
		{
			radius = radius * level.lockoncloseradiusscaler;
		}
	}
	return radius;
}

/*
	Name: calclockonlossradius
	Namespace: heatseekingmissile
	Checksum: 0x9236A5D1
	Offset: 0x18A8
	Size: 0xFA
	Parameters: 2
	Flags: Linked
*/
function calclockonlossradius(target, weapon)
{
	radius = self getlockonlossradius();
	if(isdefined(weapon) && isdefined(weapon.lockonscreenradius) && weapon.lockonscreenradius > radius)
	{
		radius = weapon.lockonscreenradius;
	}
	if(isdefined(level.lockoncloserange) && isdefined(level.lockoncloseradiusscaler))
	{
		dist2 = distancesquared(target.origin, self.origin);
		if(dist2 < (level.lockoncloserange * level.lockoncloserange))
		{
			radius = radius * level.lockoncloseradiusscaler;
		}
	}
	return radius;
}

/*
	Name: ratiodistancefromscreencenter
	Namespace: heatseekingmissile
	Checksum: 0xF62B7CAE
	Offset: 0x19B0
	Size: 0x5A
	Parameters: 2
	Flags: Linked
*/
function ratiodistancefromscreencenter(target, weapon)
{
	radius = calclockonradius(target, weapon);
	return target_scaleminmaxradius(target, self, 65, 0, radius);
}

/*
	Name: insidestingerreticledetect
	Namespace: heatseekingmissile
	Checksum: 0xE2C3CB46
	Offset: 0x1A18
	Size: 0x5A
	Parameters: 2
	Flags: Linked
*/
function insidestingerreticledetect(target, weapon)
{
	radius = calclockonradius(target, weapon);
	return target_isincircle(target, self, 65, radius);
}

/*
	Name: insidestingerreticlenolock
	Namespace: heatseekingmissile
	Checksum: 0xC8AAAF54
	Offset: 0x1A80
	Size: 0x5A
	Parameters: 2
	Flags: Linked
*/
function insidestingerreticlenolock(target, weapon)
{
	radius = calclockonradius(target, weapon);
	return target_isincircle(target, self, 65, radius);
}

/*
	Name: insidestingerreticlelocked
	Namespace: heatseekingmissile
	Checksum: 0x2065FDDD
	Offset: 0x1AE8
	Size: 0x5A
	Parameters: 2
	Flags: Linked
*/
function insidestingerreticlelocked(target, weapon)
{
	radius = calclockonlossradius(target, weapon);
	return target_isincircle(target, self, 65, radius);
}

/*
	Name: isstillvalidtarget
	Namespace: heatseekingmissile
	Checksum: 0xE206145F
	Offset: 0x1B50
	Size: 0xAE
	Parameters: 2
	Flags: Linked
*/
function isstillvalidtarget(ent, weapon)
{
	if(!isdefined(ent))
	{
		return 0;
	}
	if(isdefined(self.is_still_valid_target_for_stinger_override))
	{
		return self [[self.is_still_valid_target_for_stinger_override]](ent, weapon);
	}
	if(!target_istarget(ent) && (!(isdefined(ent.allowcontinuedlockonafterinvis) && ent.allowcontinuedlockonafterinvis)))
	{
		return 0;
	}
	if(!insidestingerreticledetect(ent, weapon))
	{
		return 0;
	}
	return 1;
}

/*
	Name: playerstingerads
	Namespace: heatseekingmissile
	Checksum: 0xB73AD6D0
	Offset: 0x1C08
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function playerstingerads()
{
	return self playerads() == 1;
}

/*
	Name: looplocalseeksound
	Namespace: heatseekingmissile
	Checksum: 0xD249438C
	Offset: 0x1C38
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function looplocalseeksound(alias, interval)
{
	self endon(#"stop_lockon_sound");
	self endon(#"disconnect");
	self endon(#"death");
	for(;;)
	{
		self playsoundforlocalplayer(alias);
		self playrumbleonentity("stinger_lock_rumble");
		wait(interval / 2);
	}
}

/*
	Name: playsoundforlocalplayer
	Namespace: heatseekingmissile
	Checksum: 0x2FC92D8D
	Offset: 0x1CC0
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function playsoundforlocalplayer(alias)
{
	if(self isinvehicle())
	{
		sound_target = self getvehicleoccupied();
		if(isdefined(sound_target))
		{
			sound_target playsoundtoplayer(alias, self);
		}
	}
	else
	{
		self playlocalsound(alias);
	}
}

/*
	Name: looplocallocksound
	Namespace: heatseekingmissile
	Checksum: 0x5CC53D84
	Offset: 0x1D58
	Size: 0x152
	Parameters: 2
	Flags: Linked
*/
function looplocallocksound(alias, interval)
{
	self endon(#"stop_locked_sound");
	self endon(#"disconnect");
	self endon(#"death");
	if(isdefined(self.stingerlocksound))
	{
		return;
	}
	self.stingerlocksound = 1;
	for(;;)
	{
		self playsoundforlocalplayer(alias);
		self playrumbleonentity("stinger_lock_rumble");
		wait(interval / 6);
		self playsoundforlocalplayer(alias);
		self playrumbleonentity("stinger_lock_rumble");
		wait(interval / 6);
		self playsoundforlocalplayer(alias);
		self playrumbleonentity("stinger_lock_rumble");
		wait(interval / 6);
		self stoprumble("stinger_lock_rumble");
	}
	self.stingerlocksound = undefined;
}

/*
	Name: locksighttest
	Namespace: heatseekingmissile
	Checksum: 0x9AE55E44
	Offset: 0x1EB8
	Size: 0x220
	Parameters: 1
	Flags: Linked
*/
function locksighttest(target)
{
	camerapos = self getplayercamerapos();
	if(!isdefined(target))
	{
		return false;
	}
	if(isdefined(target.parent))
	{
		passed = bullettracepassed(camerapos, target.origin, 0, target, target.parent);
	}
	else
	{
		passed = bullettracepassed(camerapos, target.origin, 0, target);
	}
	if(passed)
	{
		return true;
	}
	front = target getpointinbounds(1, 0, 0);
	if(isdefined(target.parent))
	{
		passed = bullettracepassed(camerapos, front, 0, target, target.parent);
	}
	else
	{
		passed = bullettracepassed(camerapos, front, 0, target);
	}
	if(passed)
	{
		return true;
	}
	back = target getpointinbounds(-1, 0, 0);
	if(isdefined(target.parent))
	{
		passed = bullettracepassed(camerapos, back, 0, target, target.parent);
	}
	else
	{
		passed = bullettracepassed(camerapos, back, 0, target);
	}
	if(passed)
	{
		return true;
	}
	return false;
}

/*
	Name: softsighttest
	Namespace: heatseekingmissile
	Checksum: 0xC2CF59AE
	Offset: 0x20E0
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function softsighttest()
{
	lost_sight_limit = 500;
	if(self locksighttest(self.stingertarget))
	{
		self.stingerlostsightlinetime = 0;
		return true;
	}
	if(self.stingerlostsightlinetime == 0)
	{
		self.stingerlostsightlinetime = gettime();
	}
	timepassed = gettime() - self.stingerlostsightlinetime;
	if(timepassed >= lost_sight_limit)
	{
		self clearirtarget();
		return false;
	}
	return true;
}

/*
	Name: initlockfield
	Namespace: heatseekingmissile
	Checksum: 0xFD54E46A
	Offset: 0x2190
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function initlockfield(target)
{
	if(isdefined(target.locking_on))
	{
		return;
	}
	target.locking_on = 0;
	target.locked_on = 0;
	target.locking_on_hacking = 0;
}

/*
	Name: lockingon
	Namespace: heatseekingmissile
	Checksum: 0xA960E7CF
	Offset: 0x21F0
	Size: 0xF8
	Parameters: 2
	Flags: Linked
*/
function lockingon(target, lock)
{
	/#
		assert(isdefined(target.locking_on));
	#/
	clientnum = self getentitynumber();
	if(lock)
	{
		target notify(#"hash_b081980b");
		target.locking_on = target.locking_on | (1 << clientnum);
		self thread watchclearlockingon(target, clientnum);
	}
	else
	{
		self notify(#"locking_on_cleared");
		target.locking_on = target.locking_on & (~(1 << clientnum));
	}
}

/*
	Name: watchclearlockingon
	Namespace: heatseekingmissile
	Checksum: 0x1E4C6477
	Offset: 0x22F0
	Size: 0x78
	Parameters: 2
	Flags: Linked
*/
function watchclearlockingon(target, clientnum)
{
	target endon(#"death");
	self endon(#"locking_on_cleared");
	self util::waittill_any("death", "disconnect");
	target.locking_on = target.locking_on & (~(1 << clientnum));
}

/*
	Name: lockedon
	Namespace: heatseekingmissile
	Checksum: 0x1C3DC256
	Offset: 0x2370
	Size: 0xE8
	Parameters: 2
	Flags: Linked
*/
function lockedon(target, lock)
{
	/#
		assert(isdefined(target.locked_on));
	#/
	clientnum = self getentitynumber();
	if(lock)
	{
		target.locked_on = target.locked_on | (1 << clientnum);
		self thread watchclearlockedon(target, clientnum);
	}
	else
	{
		self notify(#"locked_on_cleared");
		target.locked_on = target.locked_on & (~(1 << clientnum));
	}
}

/*
	Name: targetinghacking
	Namespace: heatseekingmissile
	Checksum: 0xEAEE5728
	Offset: 0x2460
	Size: 0xF8
	Parameters: 2
	Flags: Linked
*/
function targetinghacking(target, lock)
{
	/#
		assert(isdefined(target.locking_on_hacking));
	#/
	clientnum = self getentitynumber();
	if(lock)
	{
		target notify(#"hash_e1494b46");
		target.locking_on_hacking = target.locking_on_hacking | (1 << clientnum);
		self thread watchclearhacking(target, clientnum);
	}
	else
	{
		self notify(#"locking_on_hacking_cleared");
		target.locking_on_hacking = target.locking_on_hacking & (~(1 << clientnum));
	}
}

/*
	Name: watchclearhacking
	Namespace: heatseekingmissile
	Checksum: 0x39D39304
	Offset: 0x2560
	Size: 0x78
	Parameters: 2
	Flags: Linked
*/
function watchclearhacking(target, clientnum)
{
	target endon(#"death");
	self endon(#"locking_on_hacking_cleared");
	self util::waittill_any("death", "disconnect");
	target.locking_on_hacking = target.locking_on_hacking & (~(1 << clientnum));
}

/*
	Name: setfriendlyflags
	Namespace: heatseekingmissile
	Checksum: 0x97D833A5
	Offset: 0x25E0
	Size: 0x52C
	Parameters: 2
	Flags: Linked
*/
function setfriendlyflags(weapon, target)
{
	if(!self isinvehicle())
	{
		self setfriendlyhacking(weapon, target);
		self setfriendlytargetting(weapon, target);
		self setfriendlytargetlocked(weapon, target);
		if(isdefined(level.killstreakmaxhealthfunction))
		{
			if(isdefined(target.usevtoltime) && isdefined(level.vtol))
			{
				killstreakendtime = level.vtol.killstreakendtime;
				if(isdefined(killstreakendtime))
				{
					self settargetedentityendtime(weapon, killstreakendtime);
				}
			}
			else
			{
				if(isdefined(target.killstreakendtime))
				{
					self settargetedentityendtime(weapon, target.killstreakendtime);
				}
				else
				{
					if(isdefined(target.parentstruct) && isdefined(target.parentstruct.killstreakendtime))
					{
						self settargetedentityendtime(weapon, target.parentstruct.killstreakendtime);
					}
					else
					{
						self settargetedentityendtime(weapon, 0);
					}
				}
			}
			self settargetedmissilesremaining(weapon, 0);
			killstreaktype = target.killstreaktype;
			if(!isdefined(target.killstreaktype) && isdefined(target.parentstruct) && isdefined(target.parentstruct.killstreaktype))
			{
				killstreaktype = target.parentstruct.killstreaktype;
			}
			else if(isdefined(target.usevtoltime) && isdefined(level.vtol.killstreaktype))
			{
				killstreaktype = level.vtol.killstreaktype;
			}
			if(isdefined(killstreaktype) && isdefined(level.killstreakbundle[killstreaktype]))
			{
				if(isdefined(target.forceonemissile))
				{
					self settargetedmissilesremaining(weapon, 1);
				}
				else
				{
					if(isdefined(target.usevtoltime) && isdefined(level.vtol) && isdefined(level.vtol.totalrockethits) && isdefined(level.vtol.missiletodestroy))
					{
						self settargetedmissilesremaining(weapon, level.vtol.missiletodestroy - level.vtol.totalrockethits);
					}
					else
					{
						maxhealth = [[level.killstreakmaxhealthfunction]](killstreaktype);
						damagetaken = target.damagetaken;
						if(!isdefined(damagetaken) && isdefined(target.parentstruct))
						{
							damagetaken = target.parentstruct.damagetaken;
						}
						if(isdefined(target.missiletrackdamage))
						{
							damagetaken = target.missiletrackdamage;
						}
						if(isdefined(damagetaken) && isdefined(maxhealth))
						{
							damageperrocket = (maxhealth / level.killstreakbundle[killstreaktype].ksrocketstokill) + 1;
							remaininghealth = maxhealth - damagetaken;
							if(remaininghealth > 0)
							{
								missilesremaining = int(ceil(remaininghealth / damageperrocket));
								if(isdefined(target.numflares) && target.numflares > 0)
								{
									missilesremaining = missilesremaining + target.numflares;
								}
								if(isdefined(target.flak_drone))
								{
									missilesremaining = missilesremaining + 1;
								}
								self settargetedmissilesremaining(weapon, missilesremaining);
							}
						}
					}
				}
			}
		}
	}
}

/*
	Name: setfriendlyhacking
	Namespace: heatseekingmissile
	Checksum: 0x8DD04A
	Offset: 0x2B18
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function setfriendlyhacking(weapon, target)
{
	if(level.teambased)
	{
		friendlyhackingmask = target.locking_on_hacking;
		if(isdefined(friendlyhackingmask))
		{
			friendlyhacking = 0;
			clientnum = self getentitynumber();
			friendlyhackingmask = friendlyhackingmask & (~(1 << clientnum));
			if(friendlyhackingmask != 0)
			{
				friendlyhacking = 1;
			}
			self setweaponfriendlyhacking(weapon, friendlyhacking);
		}
	}
}

/*
	Name: setfriendlytargetting
	Namespace: heatseekingmissile
	Checksum: 0x13856911
	Offset: 0x2BE0
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function setfriendlytargetting(weapon, target)
{
	if(level.teambased)
	{
		friendlytargetingmask = target.locking_on;
		if(isdefined(friendlytargetingmask))
		{
			friendlytargeting = 0;
			clientnum = self getentitynumber();
			friendlytargetingmask = friendlytargetingmask & (~(1 << clientnum));
			if(friendlytargetingmask != 0)
			{
				friendlytargeting = 1;
			}
			self setweaponfriendlytargeting(weapon, friendlytargeting);
		}
	}
}

/*
	Name: setfriendlytargetlocked
	Namespace: heatseekingmissile
	Checksum: 0xD29AF4BB
	Offset: 0x2CA8
	Size: 0xEC
	Parameters: 2
	Flags: Linked
*/
function setfriendlytargetlocked(weapon, target)
{
	if(level.teambased)
	{
		friendlytargetlocked = 0;
		friendlylockingonmask = target.locked_on;
		if(isdefined(friendlylockingonmask))
		{
			friendlytargetlocked = 0;
			clientnum = self getentitynumber();
			friendlylockingonmask = friendlylockingonmask & (~(1 << clientnum));
			if(friendlylockingonmask != 0)
			{
				friendlytargetlocked = 1;
			}
		}
		if(friendlytargetlocked == 0)
		{
			friendlytargetlocked = target missiletarget_isotherplayermissileincoming(self);
		}
		self setweaponfriendlytargetlocked(weapon, friendlytargetlocked);
	}
}

/*
	Name: watchclearlockedon
	Namespace: heatseekingmissile
	Checksum: 0xBA84AE61
	Offset: 0x2DA0
	Size: 0x78
	Parameters: 2
	Flags: Linked
*/
function watchclearlockedon(target, clientnum)
{
	self endon(#"locked_on_cleared");
	self util::waittill_any("death", "disconnect");
	if(isdefined(target))
	{
		target.locked_on = target.locked_on & (~(1 << clientnum));
	}
}

/*
	Name: missiletarget_lockonmonitor
	Namespace: heatseekingmissile
	Checksum: 0xDEED5377
	Offset: 0x2E20
	Size: 0x230
	Parameters: 3
	Flags: None
*/
function missiletarget_lockonmonitor(player, endon1, endon2)
{
	self endon(#"death");
	if(isdefined(endon1))
	{
		self endon(endon1);
	}
	if(isdefined(endon2))
	{
		self endon(endon2);
	}
	for(;;)
	{
		if(target_istarget(self))
		{
			if(self missiletarget_ismissileincoming())
			{
				self clientfield::set("heli_warn_fired", 1);
				self clientfield::set("heli_warn_locked", 0);
				self clientfield::set("heli_warn_targeted", 0);
			}
			else
			{
				if(isdefined(self.locked_on) && self.locked_on)
				{
					self clientfield::set("heli_warn_locked", 1);
					self clientfield::set("heli_warn_fired", 0);
					self clientfield::set("heli_warn_targeted", 0);
				}
				else
				{
					if(isdefined(self.locking_on) && self.locking_on)
					{
						self clientfield::set("heli_warn_targeted", 1);
						self clientfield::set("heli_warn_fired", 0);
						self clientfield::set("heli_warn_locked", 0);
					}
					else
					{
						self clientfield::set("heli_warn_fired", 0);
						self clientfield::set("heli_warn_targeted", 0);
						self clientfield::set("heli_warn_locked", 0);
					}
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: _incomingmissile
	Namespace: heatseekingmissile
	Checksum: 0x87CED7FB
	Offset: 0x3058
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function _incomingmissile(missile, attacker)
{
	if(!isdefined(self.incoming_missile))
	{
		self.incoming_missile = 0;
	}
	if(!isdefined(self.incoming_missile_owner))
	{
		self.incoming_missile_owner = [];
	}
	if(!isdefined(self.incoming_missile_owner[attacker.entnum]))
	{
		self.incoming_missile_owner[attacker.entnum] = 0;
	}
	self.incoming_missile++;
	self.incoming_missile_owner[attacker.entnum]++;
	attacker lockedon(self, 1);
	self thread _incomingmissiletracker(missile, attacker);
}

/*
	Name: _incomingmissiletracker
	Namespace: heatseekingmissile
	Checksum: 0xBC2B3A76
	Offset: 0x3140
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function _incomingmissiletracker(missile, attacker)
{
	self endon(#"death");
	attacker_entnum = attacker.entnum;
	missile waittill(#"death");
	self.incoming_missile--;
	self.incoming_missile_owner[attacker_entnum]--;
	if(self.incoming_missile_owner[attacker_entnum] == 0)
	{
		self.incoming_missile_owner[attacker_entnum] = undefined;
	}
	if(isdefined(attacker))
	{
		attacker lockedon(self, 0);
	}
	/#
		assert(self.incoming_missile >= 0);
	#/
}

/*
	Name: missiletarget_ismissileincoming
	Namespace: heatseekingmissile
	Checksum: 0xA0BF9F6
	Offset: 0x3210
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function missiletarget_ismissileincoming()
{
	if(!isdefined(self.incoming_missile))
	{
		return false;
	}
	if(self.incoming_missile)
	{
		return true;
	}
	return false;
}

/*
	Name: missiletarget_isotherplayermissileincoming
	Namespace: heatseekingmissile
	Checksum: 0x8A0AF1F7
	Offset: 0x3240
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function missiletarget_isotherplayermissileincoming(attacker)
{
	if(!isdefined(self.incoming_missile_owner))
	{
		return false;
	}
	if(self.incoming_missile_owner.size == 0)
	{
		return false;
	}
	if(self.incoming_missile_owner.size == 1 && isdefined(self.incoming_missile_owner[attacker.entnum]))
	{
		return false;
	}
	return true;
}

/*
	Name: missiletarget_handleincomingmissile
	Namespace: heatseekingmissile
	Checksum: 0x5A040B2B
	Offset: 0x32B0
	Size: 0xDE
	Parameters: 4
	Flags: Linked
*/
function missiletarget_handleincomingmissile(responsefunc, endon1, endon2, allowdirectdamage)
{
	level endon(#"game_ended");
	self endon(#"death");
	if(isdefined(endon1))
	{
		self endon(endon1);
	}
	if(isdefined(endon2))
	{
		self endon(endon2);
	}
	for(;;)
	{
		self waittill(#"stinger_fired_at_me", missile, weapon, attacker);
		_incomingmissile(missile, attacker);
		if(isdefined(responsefunc))
		{
			[[responsefunc]](missile, attacker, weapon, endon1, endon2, allowdirectdamage);
		}
	}
}

/*
	Name: missiletarget_proximitydetonateincomingmissile
	Namespace: heatseekingmissile
	Checksum: 0xCE2F6394
	Offset: 0x3398
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function missiletarget_proximitydetonateincomingmissile(endon1, endon2, allowdirectdamage)
{
	missiletarget_handleincomingmissile(&missiletarget_proximitydetonate, endon1, endon2, allowdirectdamage);
}

/*
	Name: _missiledetonate
	Namespace: heatseekingmissile
	Checksum: 0x888AE76E
	Offset: 0x33F0
	Size: 0x194
	Parameters: 6
	Flags: Linked
*/
function _missiledetonate(attacker, weapon, range, mindamage, maxdamage, allowdirectdamage)
{
	origin = self.origin;
	target = self missile_gettarget();
	self detonate();
	if(allowdirectdamage === 1 && isdefined(target) && isdefined(target.origin))
	{
		mindistsq = (isdefined(target.locked_missile_min_distsq) ? target.locked_missile_min_distsq : range * range);
		distsq = distancesquared(self.origin, target.origin);
		if(distsq < mindistsq)
		{
			target dodamage(maxdamage, origin, attacker, self, "none", "MOD_PROJECTILE", 0, weapon);
		}
	}
	radiusdamage(origin, range, maxdamage, mindamage, attacker, "MOD_PROJECTILE_SPLASH", weapon);
}

/*
	Name: missiletarget_proximitydetonate
	Namespace: heatseekingmissile
	Checksum: 0x4C0A86FA
	Offset: 0x3590
	Size: 0x33C
	Parameters: 6
	Flags: Linked
*/
function missiletarget_proximitydetonate(missile, attacker, weapon, endon1, endon2, allowdirectdamage)
{
	level endon(#"game_ended");
	missile endon(#"death");
	if(isdefined(endon1))
	{
		self endon(endon1);
	}
	if(isdefined(endon2))
	{
		self endon(endon2);
	}
	mindist = distancesquared(missile.origin, self.origin);
	lastcenter = self.origin;
	missile missile_settarget(self, (isdefined(target_getoffset(self)) ? target_getoffset(self) : (0, 0, 0)));
	if(isdefined(self.missiletargetmissdistance))
	{
		misseddistancesq = self.missiletargetmissdistance * self.missiletargetmissdistance;
	}
	else
	{
		misseddistancesq = 250000;
	}
	flaredistancesq = 12250000;
	for(;;)
	{
		if(!isdefined(self))
		{
			center = lastcenter;
		}
		else
		{
			center = self.origin;
		}
		lastcenter = center;
		curdist = distancesquared(missile.origin, center);
		if(curdist < flaredistancesq && isdefined(self.numflares) && self.numflares > 0)
		{
			self.numflares--;
			self thread missiletarget_playflarefx();
			self challenges::trackassists(attacker, 0, 1);
			newtarget = self missiletarget_deployflares(missile.origin, missile.angles);
			missile missile_settarget(newtarget, (isdefined(target_getoffset(newtarget)) ? target_getoffset(newtarget) : (0, 0, 0)));
			missiletarget = newtarget;
			return;
		}
		if(curdist < mindist)
		{
			mindist = curdist;
		}
		if(curdist > mindist)
		{
			if(curdist > misseddistancesq)
			{
				return;
			}
			missile thread _missiledetonate(attacker, weapon, 500, 600, 600, allowdirectdamage);
			return;
		}
		wait(0.05);
	}
}

/*
	Name: missiletarget_playflarefx
	Namespace: heatseekingmissile
	Checksum: 0x154F29A7
	Offset: 0x38D8
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function missiletarget_playflarefx()
{
	if(!isdefined(self))
	{
		return;
	}
	flare_fx = level.fx_flare;
	if(isdefined(self.fx_flare))
	{
		flare_fx = self.fx_flare;
	}
	if(isdefined(self.flare_ent))
	{
		playfxontag(flare_fx, self.flare_ent, "tag_origin");
	}
	else
	{
		playfxontag(flare_fx, self, "tag_origin");
	}
	if(isdefined(self.owner))
	{
		self playsoundtoplayer("veh_huey_chaff_drop_plr", self.owner);
	}
	self playsound("veh_huey_chaff_explo_npc");
}

/*
	Name: missiletarget_deployflares
	Namespace: heatseekingmissile
	Checksum: 0x2E661A2F
	Offset: 0x39C8
	Size: 0x2C8
	Parameters: 2
	Flags: Linked
*/
function missiletarget_deployflares(origin, angles)
{
	vec_toforward = anglestoforward(self.angles);
	vec_toright = anglestoright(self.angles);
	vec_tomissileforward = anglestoforward(angles);
	delta = self.origin - origin;
	dot = vectordot(vec_tomissileforward, vec_toright);
	sign = 1;
	if(dot > 0)
	{
		sign = -1;
	}
	flare_dir = vectornormalize((vectorscale(vec_toforward, -0.5)) + vectorscale(vec_toright, sign));
	velocity = vectorscale(flare_dir, randomintrange(200, 400));
	velocity = (velocity[0], velocity[1], velocity[2] - randomintrange(10, 100));
	flareorigin = self.origin;
	flareorigin = flareorigin + vectorscale(flare_dir, randomintrange(600, 800));
	flareorigin = flareorigin + vectorscale((0, 0, 1), 500);
	if(isdefined(self.flareoffset))
	{
		flareorigin = flareorigin + self.flareoffset;
	}
	flareobject = spawn("script_origin", flareorigin);
	flareobject.angles = self.angles;
	flareobject setmodel("tag_origin");
	flareobject movegravity(velocity, 5);
	flareobject thread util::deleteaftertime(5);
	/#
		self thread debug_tracker(flareobject);
	#/
	return flareobject;
}

/*
	Name: debug_tracker
	Namespace: heatseekingmissile
	Checksum: 0x246A2EFE
	Offset: 0x3C98
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function debug_tracker(target)
{
	/#
		target endon(#"death");
		while(true)
		{
			dev::debug_sphere(target.origin, 10, (1, 0, 0), 1, 1);
			wait(0.05);
		}
	#/
}

