// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace bot_combat;

/*
	Name: combat_think
	Namespace: bot_combat
	Checksum: 0xB9EEA440
	Offset: 0x180
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function combat_think()
{
	if(self has_threat())
	{
		if(self threat_is_alive())
		{
			self update_threat();
		}
		else
		{
			self thread [[level.botthreatdead]]();
		}
	}
	if(!self has_threat() && !self get_new_threat())
	{
		return;
	}
	if(self has_threat())
	{
		if(!self threat_visible() || self.bot.threat.lastdistancesq > level.botsettings.threatradiusmaxsq)
		{
			self get_new_threat(level.botsettings.threatradiusmin);
		}
	}
	if(self threat_visible())
	{
		self thread [[level.botupdatethreatgoal]]();
		self thread [[level.botthreatengage]]();
	}
	else
	{
		self thread [[level.botthreatlost]]();
	}
}

/*
	Name: is_alive
	Namespace: bot_combat
	Checksum: 0xCEC84A4F
	Offset: 0x2F8
	Size: 0x22
	Parameters: 1
	Flags: None
*/
function is_alive(entity)
{
	return isalive(entity);
}

/*
	Name: get_bot_threats
	Namespace: bot_combat
	Checksum: 0xBE4C1B4
	Offset: 0x328
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function get_bot_threats(maxdistance = 0)
{
	return self botgetthreats(maxdistance);
}

/*
	Name: get_ai_threats
	Namespace: bot_combat
	Checksum: 0x49DCB002
	Offset: 0x368
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function get_ai_threats()
{
	return getaiteamarray("axis");
}

/*
	Name: ignore_none
	Namespace: bot_combat
	Checksum: 0xADDE8142
	Offset: 0x390
	Size: 0xE
	Parameters: 1
	Flags: None
*/
function ignore_none(entity)
{
	return false;
}

/*
	Name: ignore_non_sentient
	Namespace: bot_combat
	Checksum: 0xDE59D988
	Offset: 0x3A8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function ignore_non_sentient(entity)
{
	return !issentient(entity);
}

/*
	Name: has_threat
	Namespace: bot_combat
	Checksum: 0xE2E3CB35
	Offset: 0x3D8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function has_threat()
{
	return isdefined(self.bot.threat.entity);
}

/*
	Name: threat_visible
	Namespace: bot_combat
	Checksum: 0x301A4EB5
	Offset: 0x400
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function threat_visible()
{
	return self has_threat() && self.bot.threat.visible;
}

/*
	Name: threat_is_alive
	Namespace: bot_combat
	Checksum: 0x48B413B8
	Offset: 0x440
	Size: 0x82
	Parameters: 0
	Flags: Linked
*/
function threat_is_alive()
{
	if(!self has_threat())
	{
		return 0;
	}
	if(isdefined(level.botthreatisalive))
	{
		return self [[level.botthreatisalive]](self.bot.threat.entity);
	}
	return isalive(self.bot.threat.entity);
}

/*
	Name: set_threat
	Namespace: bot_combat
	Checksum: 0xE7593144
	Offset: 0x4D0
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function set_threat(entity)
{
	self.bot.threat.entity = entity;
	self.bot.threat.aimoffset = self get_aim_offset(entity);
	self update_threat(1);
}

/*
	Name: clear_threat
	Namespace: bot_combat
	Checksum: 0xE2BAABCE
	Offset: 0x550
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function clear_threat()
{
	self.bot.threat.entity = undefined;
	self clear_threat_aim();
	self botlookforward();
}

/*
	Name: update_threat
	Namespace: bot_combat
	Checksum: 0x2648F662
	Offset: 0x5A0
	Size: 0x3F0
	Parameters: 1
	Flags: Linked
*/
function update_threat(newthreat)
{
	if(isdefined(newthreat) && newthreat)
	{
		self.bot.threat.wasvisible = 0;
		self clear_threat_aim();
	}
	else
	{
		self.bot.threat.wasvisible = self.bot.threat.visible;
	}
	velocity = self.bot.threat.entity getvelocity();
	distancesq = distancesquared(self geteye(), self.bot.threat.entity.origin);
	predictiontime = (isdefined(level.botsettings.thinkinterval) ? level.botsettings.thinkinterval : 0.05);
	predictedposition = self.bot.threat.entity.origin + (velocity * predictiontime);
	aimpoint = predictedposition + self.bot.threat.aimoffset;
	dot = self bot::fwd_dot(aimpoint);
	fov = self botgetfov();
	if(isdefined(newthreat) && newthreat)
	{
		self.bot.threat.visible = 1;
	}
	else if(dot < fov || !self botsighttrace(self.bot.threat.entity))
	{
		self.bot.threat.visible = 0;
		return;
	}
	self.bot.threat.visible = 1;
	self.bot.threat.lastvisibletime = gettime();
	self.bot.threat.lastdistancesq = distancesq;
	self.bot.threat.lastvelocity = velocity;
	self.bot.threat.lastposition = predictedposition;
	self.bot.threat.aimpoint = aimpoint;
	self.bot.threat.dot = dot;
	weapon = self getcurrentweapon();
	weaponrange = weapon_range(weapon);
	self.bot.threat.inrange = distancesq < (weaponrange * weaponrange);
	weaponrangeclose = weapon_range_close(weapon);
	self.bot.threat.incloserange = distancesq < (weaponrangeclose * weaponrangeclose);
}

/*
	Name: get_new_threat
	Namespace: bot_combat
	Checksum: 0x81AEE3B0
	Offset: 0x998
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function get_new_threat(maxdistance)
{
	entity = self get_greatest_threat(maxdistance);
	if(isdefined(entity) && entity !== self.bot.threat.entity)
	{
		self set_threat(entity);
		return true;
	}
	return false;
}

/*
	Name: get_greatest_threat
	Namespace: bot_combat
	Checksum: 0xB9522EEE
	Offset: 0xA20
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function get_greatest_threat(maxdistance)
{
	threats = self [[level.botgetthreats]](maxdistance);
	if(!isdefined(threats))
	{
		return undefined;
	}
	foreach(entity in threats)
	{
		if(self [[level.botignorethreat]](entity))
		{
			continue;
		}
		return entity;
	}
	return undefined;
}

/*
	Name: engage_threat
	Namespace: bot_combat
	Checksum: 0xC002A5FD
	Offset: 0xAF8
	Size: 0x4BC
	Parameters: 0
	Flags: Linked
*/
function engage_threat()
{
	if(!self.bot.threat.wasvisible && self.bot.threat.visible && !self isthrowinggrenade() && !self fragbuttonpressed() && !self secondaryoffhandbuttonpressed() && !self isswitchingweapons())
	{
		visibleroll = randomint(100);
		rollweight = (isdefined(level.botsettings.lethalweight) ? level.botsettings.lethalweight : 0);
		if(visibleroll < rollweight && self.bot.threat.lastdistancesq >= level.botsettings.lethaldistanceminsq && self.bot.threat.lastdistancesq <= level.botsettings.lethaldistancemaxsq && self getweaponammostock(self.grenadetypeprimary))
		{
			self clear_threat_aim();
			self throw_grenade(self.grenadetypeprimary, self.bot.threat.lastposition);
			return;
		}
		visibleroll = visibleroll - rollweight;
		rollweight = (isdefined(level.botsettings.tacticalweight) ? level.botsettings.tacticalweight : 0);
		if(visibleroll >= 0 && visibleroll < rollweight && self.bot.threat.lastdistancesq >= level.botsettings.tacticaldistanceminsq && self.bot.threat.lastdistancesq <= level.botsettings.tacticaldistancemaxsq && self getweaponammostock(self.grenadetypesecondary))
		{
			self clear_threat_aim();
			self throw_grenade(self.grenadetypesecondary, self.bot.threat.lastposition);
			return;
		}
		self.bot.threat.aimoffset = self get_aim_offset(self.bot.threat.entity);
	}
	if(self fragbuttonpressed())
	{
		self throw_grenade(self.grenadetypeprimary, self.bot.threat.lastposition);
		return;
	}
	if(self secondaryoffhandbuttonpressed())
	{
		self throw_grenade(self.grenadetypesecondary, self.bot.threat.lastposition);
		return;
	}
	self update_weapon_aim();
	if(self isreloading() || self isswitchingweapons() || self isthrowinggrenade() || self fragbuttonpressed() || self secondaryoffhandbuttonpressed() || self ismeleeing())
	{
		return;
	}
	if(melee_attack())
	{
		return;
	}
	self update_weapon_ads();
	self fire_weapon();
}

/*
	Name: update_threat_goal
	Namespace: bot_combat
	Checksum: 0x95CE1B32
	Offset: 0xFC0
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function update_threat_goal()
{
	if(self botundermanualcontrol())
	{
		return;
	}
	if(self botgoalset() && (self.bot.threat.wasvisible || !self.bot.threat.visible))
	{
		return;
	}
	radius = get_threat_goal_radius();
	radiussq = radius * radius;
	threatdistsq = distance2dsquared(self.origin, self.bot.threat.lastposition);
	if(threatdistsq < radiussq || !self botsetgoal(self.bot.threat.lastposition, radius))
	{
		self combat_strafe();
	}
}

/*
	Name: get_threat_goal_radius
	Namespace: bot_combat
	Checksum: 0x9CCB08DE
	Offset: 0x1108
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function get_threat_goal_radius()
{
	weapon = self getcurrentweapon();
	if(randomint(100) < 10 || weapon.weapclass == "melee" || (!self getweaponammoclip(weapon) && !self getweaponammostock(weapon)))
	{
		return level.botsettings.meleerange;
	}
	return randomintrange(level.botsettings.threatradiusmin, level.botsettings.threatradiusmax);
}

/*
	Name: fire_weapon
	Namespace: bot_combat
	Checksum: 0x5B1C39CB
	Offset: 0x11F8
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function fire_weapon()
{
	if(!self.bot.threat.inrange)
	{
		return;
	}
	weapon = self getcurrentweapon();
	if(weapon == level.weaponnone || !self getweaponammoclip(weapon) || self.bot.threat.dot < weapon_fire_dot(weapon))
	{
		return;
	}
	if(weapon.firetype == "Single Shot" || weapon.firetype == "Burst" || weapon.firetype == "Charge Shot")
	{
		if(self attackbuttonpressed())
		{
			return;
		}
	}
	self bot::press_attack_button();
	if(weapon.isdualwield)
	{
		self bot::press_throw_button();
	}
}

/*
	Name: melee_attack
	Namespace: bot_combat
	Checksum: 0x9120BE55
	Offset: 0x1350
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function melee_attack()
{
	if(self.bot.threat.dot < level.botsettings.meleedot)
	{
		return false;
	}
	if(distancesquared(self.origin, self.bot.threat.lastposition) > level.botsettings.meleerangesq)
	{
		return false;
	}
	self bot::tap_melee_button();
	return true;
}

/*
	Name: chase_threat
	Namespace: bot_combat
	Checksum: 0x15539658
	Offset: 0x13F0
	Size: 0x1B4
	Parameters: 0
	Flags: None
*/
function chase_threat()
{
	if(self botundermanualcontrol())
	{
		return;
	}
	if(self.bot.threat.wasvisible && !self.bot.threat.visible)
	{
		self clear_threat_aim();
		self botsetgoal(self.bot.threat.lastposition);
		self bot::sprint_to_goal();
		return;
	}
	if((self.bot.threat.lastvisibletime + (isdefined(level.botsettings.chasethreattime) ? level.botsettings.chasethreattime : 0)) < gettime())
	{
		self clear_threat();
		return;
	}
	if(!self botgoalset())
	{
		self bot::navmesh_wander(self.bot.threat.lastvelocity, self.botsettings.chasewandermin, self.botsettings.chasewandermax, self.botsettings.chasewanderspacing, self.botsettings.chasewanderfwddot);
		self clear_threat();
	}
}

/*
	Name: get_aim_offset
	Namespace: bot_combat
	Checksum: 0xF906A30B
	Offset: 0x15B0
	Size: 0xB8
	Parameters: 1
	Flags: Linked
*/
function get_aim_offset(entity)
{
	if(issentient(entity) && randomint(100) < (isdefined(level.botsettings.headshotweight) ? level.botsettings.headshotweight : 0))
	{
		return entity geteye() - entity.origin;
	}
	return entity getcentroid() - entity.origin;
}

/*
	Name: update_weapon_aim
	Namespace: bot_combat
	Checksum: 0x894DC0A8
	Offset: 0x1670
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function update_weapon_aim()
{
	if(!isdefined(self.bot.threat.aimstarttime))
	{
		self start_threat_aim();
	}
	aimtime = gettime() - self.bot.threat.aimstarttime;
	if(aimtime < 0)
	{
		return;
	}
	if(aimtime >= self.bot.threat.aimtime || !isdefined(self.bot.threat.aimerror))
	{
		self botlookatpoint(self.bot.threat.aimpoint);
		return;
	}
	eyepoint = self geteye();
	threatangles = vectortoangles(self.bot.threat.aimpoint - eyepoint);
	initialangles = threatangles + self.bot.threat.aimerror;
	currangles = vectorlerp(initialangles, threatangles, aimtime / self.bot.threat.aimtime);
	playerangles = self getplayerangles();
	self botsetlookangles(anglestoforward(currangles));
}

/*
	Name: start_threat_aim
	Namespace: bot_combat
	Checksum: 0xD75065E7
	Offset: 0x1870
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function start_threat_aim()
{
	self.bot.threat.aimstarttime = gettime() + ((isdefined(level.botsettings.aimdelay) ? level.botsettings.aimdelay : 0) * 1000);
	self.bot.threat.aimtime = (isdefined(level.botsettings.aimtime) ? level.botsettings.aimtime : 0) * 1000;
	loc_00001942:
	pitcherror = angleerror((isdefined(level.botsettings.aimerrorminpitch) ? level.botsettings.aimerrorminpitch : 0), (isdefined(level.botsettings.aimerrormaxpitch) ? level.botsettings.aimerrormaxpitch : 0));
	loc_000019AA:
	yawerror = angleerror((isdefined(level.botsettings.aimerrorminyaw) ? level.botsettings.aimerrorminyaw : 0), (isdefined(level.botsettings.aimerrormaxyaw) ? level.botsettings.aimerrormaxyaw : 0));
	self.bot.threat.aimerror = (pitcherror, yawerror, 0);
}

/*
	Name: angleerror
	Namespace: bot_combat
	Checksum: 0xFF5424A3
	Offset: 0x1A18
	Size: 0x86
	Parameters: 2
	Flags: Linked
*/
function angleerror(anglemin, anglemax)
{
	angle = anglemax - anglemin;
	angle = angle * (randomfloatrange(-1, 1));
	if(angle < 0)
	{
		angle = angle - anglemin;
	}
	else
	{
		angle = angle + anglemin;
	}
	return angle;
}

/*
	Name: clear_threat_aim
	Namespace: bot_combat
	Checksum: 0xD30A5D1B
	Offset: 0x1AA8
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function clear_threat_aim()
{
	if(!isdefined(self.bot.threat.aimstarttime))
	{
		return;
	}
	self.bot.threat.aimstarttime = undefined;
	self.bot.threat.aimtime = undefined;
	self.bot.threat.aimerror = undefined;
}

/*
	Name: bot_pre_combat
	Namespace: bot_combat
	Checksum: 0x74E72767
	Offset: 0x1B20
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function bot_pre_combat()
{
	if(self has_threat())
	{
		return;
	}
	if(isdefined(self.bot.damage.time) && (self.bot.damage.time + 1500) > gettime())
	{
		if(self has_threat() && self.bot.damage.time > self.bot.threat.lastvisibletime)
		{
			self clear_threat();
		}
		self bot::navmesh_wander(self.bot.damage.attackdir, level.botsettings.damagewandermin, level.botsettings.damagewandermax, level.botsettings.damagewanderspacing, level.botsettings.damagewanderfwddot);
		self bot::end_sprint_to_goal();
		self clear_damage();
	}
}

/*
	Name: bot_post_combat
	Namespace: bot_combat
	Checksum: 0x99EC1590
	Offset: 0x1C90
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function bot_post_combat()
{
}

/*
	Name: update_weapon_ads
	Namespace: bot_combat
	Checksum: 0x311BB27F
	Offset: 0x1CA0
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function update_weapon_ads()
{
	if(!self.bot.threat.inrange || self.bot.threat.incloserange)
	{
		return;
	}
	weapon = self getcurrentweapon();
	if(weapon == level.weaponnone || weapon.isdualwield || weapon.weapclass == "melee" || self getweaponammoclip(weapon) <= 0)
	{
		return;
	}
	if(self.bot.threat.dot < weapon_ads_dot(weapon))
	{
		return;
	}
	self bot::press_ads_button();
}

/*
	Name: weapon_ads_dot
	Namespace: bot_combat
	Checksum: 0xF6D0E3A5
	Offset: 0x1DB0
	Size: 0xFE
	Parameters: 1
	Flags: Linked
*/
function weapon_ads_dot(weapon)
{
	if(weapon.issniperweapon)
	{
		return level.botsettings.sniperads;
	}
	if(weapon.isrocketlauncher)
	{
		return level.botsettings.rocketlauncherads;
	}
	switch(weapon.weapclass)
	{
		case "mg":
		{
			return level.botsettings.mgads;
		}
		case "smg":
		{
			return level.botsettings.smgads;
		}
		case "spread":
		{
			return level.botsettings.spreadads;
		}
		case "pistol":
		{
			return level.botsettings.pistolads;
		}
		case "rifle":
		{
			return level.botsettings.rifleads;
		}
	}
	return level.botsettings.defaultads;
}

/*
	Name: weapon_fire_dot
	Namespace: bot_combat
	Checksum: 0x4D88569
	Offset: 0x1EB8
	Size: 0xFE
	Parameters: 1
	Flags: Linked
*/
function weapon_fire_dot(weapon)
{
	if(weapon.issniperweapon)
	{
		return level.botsettings.sniperfire;
	}
	if(weapon.isrocketlauncher)
	{
		return level.botsettings.rocketlauncherfire;
	}
	switch(weapon.weapclass)
	{
		case "mg":
		{
			return level.botsettings.mgfire;
		}
		case "smg":
		{
			return level.botsettings.smgfire;
		}
		case "spread":
		{
			return level.botsettings.spreadfire;
		}
		case "pistol":
		{
			return level.botsettings.pistolfire;
		}
		case "rifle":
		{
			return level.botsettings.riflefire;
		}
	}
	return level.botsettings.defaultfire;
}

/*
	Name: weapon_range
	Namespace: bot_combat
	Checksum: 0x45B8FE45
	Offset: 0x1FC0
	Size: 0xFE
	Parameters: 1
	Flags: Linked
*/
function weapon_range(weapon)
{
	if(weapon.issniperweapon)
	{
		return level.botsettings.sniperrange;
	}
	if(weapon.isrocketlauncher)
	{
		return level.botsettings.rocketlauncherrange;
	}
	switch(weapon.weapclass)
	{
		case "mg":
		{
			return level.botsettings.mgrange;
		}
		case "smg":
		{
			return level.botsettings.smgrange;
		}
		case "spread":
		{
			return level.botsettings.spreadrange;
		}
		case "pistol":
		{
			return level.botsettings.pistolrange;
		}
		case "rifle":
		{
			return level.botsettings.riflerange;
		}
	}
	return level.botsettings.defaultrange;
}

/*
	Name: weapon_range_close
	Namespace: bot_combat
	Checksum: 0xB3567CD3
	Offset: 0x20C8
	Size: 0xFE
	Parameters: 1
	Flags: Linked
*/
function weapon_range_close(weapon)
{
	if(weapon.issniperweapon)
	{
		return level.botsettings.sniperrangeclose;
	}
	if(weapon.isrocketlauncher)
	{
		return level.botsettings.rocketlauncherrangeclose;
	}
	switch(weapon.weapclass)
	{
		case "mg":
		{
			return level.botsettings.mgrangeclose;
		}
		case "smg":
		{
			return level.botsettings.smgrangeclose;
		}
		case "spread":
		{
			return level.botsettings.spreadrangeclose;
		}
		case "pistol":
		{
			return level.botsettings.pistolrangeclose;
		}
		case "rifle":
		{
			return level.botsettings.riflerangeclose;
		}
	}
	return level.botsettings.defaultrangeclose;
}

/*
	Name: switch_weapon
	Namespace: bot_combat
	Checksum: 0x6E5F8073
	Offset: 0x21D0
	Size: 0x35A
	Parameters: 0
	Flags: Linked
*/
function switch_weapon()
{
	currentweapon = self getcurrentweapon();
	if(self isswitchingweapons() || currentweapon.isheroweapon || currentweapon.isitem)
	{
		return false;
	}
	weapon = bot::get_ready_gadget();
	if(weapon != level.weaponnone)
	{
		if(!isdefined(level.enemyempactive) || !self [[level.enemyempactive]]())
		{
			self bot::activate_hero_gadget(weapon);
			return true;
		}
	}
	weapons = self getweaponslistprimaries();
	if(currentweapon == level.weaponnone || currentweapon.weapclass == "melee" || currentweapon.weapclass == "rocketLauncher" || currentweapon.weapclass == "pistol")
	{
		foreach(weapon in weapons)
		{
			if(weapon == currentweapon)
			{
				continue;
			}
			if(self getweaponammoclip(weapon) || self getweaponammostock(weapon))
			{
				self botswitchtoweapon(weapon);
				return true;
			}
		}
		return false;
	}
	currentammostock = self getweaponammostock(currentweapon);
	if(currentammostock)
	{
		return false;
	}
	switchfrac = 0.3;
	currentclipfrac = self weapon_clip_frac(currentweapon);
	if(currentclipfrac > switchfrac)
	{
		return false;
	}
	foreach(weapon in weapons)
	{
		if(self getweaponammostock(weapon) || self weapon_clip_frac(weapon) > switchfrac)
		{
			self botswitchtoweapon(weapon);
			return true;
		}
	}
	return false;
}

/*
	Name: threat_switch_weapon
	Namespace: bot_combat
	Checksum: 0xE97DA6C4
	Offset: 0x2538
	Size: 0x24A
	Parameters: 0
	Flags: None
*/
function threat_switch_weapon()
{
	currentweapon = self getcurrentweapon();
	if(self isswitchingweapons() || self getweaponammoclip(currentweapon) || currentweapon.isitem)
	{
		return;
	}
	currentammostock = self getweaponammostock(currentweapon);
	weapons = self getweaponslistprimaries();
	foreach(weapon in weapons)
	{
		if(weapon == currentweapon || weapon.requirelockontofire)
		{
			continue;
		}
		if(weapon.weapclass == "melee")
		{
			if(currentammostock && randomintrange(0, 100) < 75)
			{
				continue;
			}
		}
		else
		{
			if(!self getweaponammoclip(weapon) && currentammostock)
			{
				continue;
			}
			weaponammostock = self getweaponammostock(weapon);
			if(!currentammostock && !weaponammostock)
			{
				continue;
			}
			if(weapon.weapclass != "pistol" && randomintrange(0, 100) < 75)
			{
				continue;
			}
		}
		self botswitchtoweapon(weapon);
	}
}

/*
	Name: reload_weapon
	Namespace: bot_combat
	Checksum: 0xFE651764
	Offset: 0x2790
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function reload_weapon()
{
	weapon = self getcurrentweapon();
	if(!self getweaponammostock(weapon))
	{
		return false;
	}
	reloadfrac = 0.5;
	if(weapon.weapclass == "mg")
	{
		reloadfrac = 0.25;
	}
	if(self weapon_clip_frac(weapon) < reloadfrac)
	{
		self bot::tap_reload_button();
		return true;
	}
	return false;
}

/*
	Name: weapon_clip_frac
	Namespace: bot_combat
	Checksum: 0xF355A527
	Offset: 0x2868
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function weapon_clip_frac(weapon)
{
	if(weapon.clipsize <= 0)
	{
		return 1;
	}
	clipammo = self getweaponammoclip(weapon);
	return clipammo / weapon.clipsize;
}

/*
	Name: throw_grenade
	Namespace: bot_combat
	Checksum: 0xF6FBDE65
	Offset: 0x28D8
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function throw_grenade(weapon, target)
{
	if(!isdefined(self.bot.threat.aimstarttime))
	{
		self aim_grenade(weapon, target);
		self press_grenade_button(weapon);
		return;
	}
	if((self.bot.threat.aimstarttime + self.bot.threat.aimtime) > gettime())
	{
		return;
	}
	if(self will_hit_target(weapon, target))
	{
		return;
	}
	self press_grenade_button(weapon);
}

/*
	Name: press_grenade_button
	Namespace: bot_combat
	Checksum: 0xFE18D520
	Offset: 0x29C0
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function press_grenade_button(weapon)
{
	if(weapon == self.grenadetypeprimary)
	{
		self bot::press_frag_button();
	}
	else if(weapon == self.grenadetypesecondary)
	{
		self bot::press_offhand_button();
	}
}

/*
	Name: aim_grenade
	Namespace: bot_combat
	Checksum: 0x1CA88626
	Offset: 0x2A28
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function aim_grenade(weapon, target)
{
	aimpeak = target + vectorscale((0, 0, 1), 100);
	self.bot.threat.aimstarttime = gettime();
	self.bot.threat.aimtime = 1500;
	self botsetlookanglesfrompoint(aimpeak);
}

/*
	Name: will_hit_target
	Namespace: bot_combat
	Checksum: 0x88297306
	Offset: 0x2AB8
	Size: 0x158
	Parameters: 2
	Flags: Linked
*/
function will_hit_target(weapon, target)
{
	velocity = get_throw_velocity(weapon);
	throworigin = self geteye();
	xydist = distance2d(throworigin, target);
	xyspeed = distance2d(velocity, (0, 0, 0));
	t = xydist / xyspeed;
	gravity = getdvarfloat("bg_gravity") * -1;
	theight = (throworigin[2] + (velocity[2] * t)) + (((gravity * t) * t) * 0.5);
	return (abs(theight - target[2])) < 20;
}

/*
	Name: get_throw_velocity
	Namespace: bot_combat
	Checksum: 0x1B6210CD
	Offset: 0x2C18
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function get_throw_velocity(weapon)
{
	angles = self getplayerangles();
	forward = anglestoforward(angles);
	return forward * 928;
}

/*
	Name: get_lethal_grenade
	Namespace: bot_combat
	Checksum: 0x78DBAD39
	Offset: 0x2C80
	Size: 0xDA
	Parameters: 0
	Flags: None
*/
function get_lethal_grenade()
{
	weaponslist = self getweaponslist();
	foreach(weapon in weaponslist)
	{
		if(weapon.type == "grenade" && self getweaponammostock(weapon))
		{
			return weapon;
		}
	}
	return level.weaponnone;
}

/*
	Name: wait_damage_loop
	Namespace: bot_combat
	Checksum: 0x227B42DA
	Offset: 0x2D68
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function wait_damage_loop()
{
	self endon(#"death");
	level endon(#"game_ended");
	while(true)
	{
		self waittill(#"damage", damage, attacker, direction, point, mod, unused1, unused2, unused3, weapon, flags, inflictor);
		self.bot.damage.entity = attacker;
		self.bot.damage.amount = damage;
		self.bot.damage.attackdir = vectornormalize(attacker.origin - self.origin);
		self.bot.damage.weapon = weapon;
		self.bot.damage.mod = mod;
		self.bot.damage.time = gettime();
		self thread [[level.onbotdamage]]();
	}
}

/*
	Name: clear_damage
	Namespace: bot_combat
	Checksum: 0x3923B7D8
	Offset: 0x2F08
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function clear_damage()
{
	self.bot.damage.entity = undefined;
	self.bot.damage.amount = undefined;
	self.bot.damage.direction = undefined;
	self.bot.damage.weapon = undefined;
	self.bot.damage.mod = undefined;
	self.bot.damage.time = undefined;
}

/*
	Name: combat_strafe
	Namespace: bot_combat
	Checksum: 0x5510F30C
	Offset: 0x2FA8
	Size: 0x394
	Parameters: 5
	Flags: Linked
*/
function combat_strafe(radiusmin = (isdefined(level.botsettings.strafemin) ? level.botsettings.strafemin : 0), radiusmax, spacing, sidedotmin, sidedotmax)
{
	if(!isdefined(radiusmax))
	{
		radiusmax = (isdefined(level.botsettings.strafemax) ? level.botsettings.strafemax : 0);
	}
	if(!isdefined(spacing))
	{
		spacing = (isdefined(level.botsettings.strafespacing) ? level.botsettings.strafespacing : 0);
	}
	if(!isdefined(sidedotmin))
	{
		sidedotmin = (isdefined(level.botsettings.strafesidedotmin) ? level.botsettings.strafesidedotmin : 0);
	}
	if(!isdefined(sidedotmax))
	{
		sidedotmax = (isdefined(level.botsettings.strafesidedotmax) ? level.botsettings.strafesidedotmax : 0);
	}
	fwd = anglestoforward(self.angles);
	/#
	#/
	queryresult = positionquery_source_navigation(self.origin, radiusmin, radiusmax, 64, spacing, self);
	best_point = undefined;
	foreach(point in queryresult.data)
	{
		movedir = vectornormalize(point.origin - self.origin);
		dot = vectordot(movedir, fwd);
		if(dot >= sidedotmin && dot <= sidedotmax)
		{
			point.score = mapfloat(radiusmin, radiusmax, 0, 50, point.disttoorigin2d);
			point.score = point.score + randomfloatrange(0, 50);
		}
		/#
		#/
		if(!isdefined(best_point) || point.score > best_point.score)
		{
			best_point = point;
		}
	}
	if(isdefined(best_point))
	{
		/#
		#/
		self botsetgoal(best_point.origin);
		self bot::end_sprint_to_goal();
	}
}

