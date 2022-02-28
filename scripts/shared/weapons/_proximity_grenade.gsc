// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace proximity_grenade;

/*
	Name: init_shared
	Namespace: proximity_grenade
	Checksum: 0x522A7D3E
	Offset: 0x5E0
	Size: 0x30C
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level._effect["prox_grenade_friendly_default"] = "weapon/fx_prox_grenade_scan_blue";
	level._effect["prox_grenade_friendly_warning"] = "weapon/fx_prox_grenade_wrn_grn";
	level._effect["prox_grenade_enemy_default"] = "weapon/fx_prox_grenade_scan_orng";
	level._effect["prox_grenade_enemy_warning"] = "weapon/fx_prox_grenade_wrn_red";
	level._effect["prox_grenade_player_shock"] = "weapon/fx_prox_grenade_impact_player_spwner";
	level._effect["prox_grenade_chain_bolt"] = "weapon/fx_prox_grenade_elec_jump";
	level.proximitygrenadedetectionradius = getdvarint("scr_proximityGrenadeDetectionRadius", 180);
	level.proximitygrenadeduration = getdvarfloat("scr_proximityGrenadeDuration", 1.2);
	level.proximitygrenadegraceperiod = getdvarfloat("scr_proximityGrenadeGracePeriod", 0.05);
	level.proximitygrenadedotdamageamount = getdvarint("scr_proximityGrenadeDOTDamageAmount", 1);
	level.proximitygrenadedotdamageamounthardcore = getdvarint("scr_proximityGrenadeDOTDamageAmountHardcore", 1);
	level.proximitygrenadedotdamagetime = getdvarfloat("scr_proximityGrenadeDOTDamageTime", 0.2);
	level.proximitygrenadedotdamageinstances = getdvarint("scr_proximityGrenadeDOTDamageInstances", 4);
	level.proximitygrenadeactivationtime = getdvarfloat("scr_proximityGrenadeActivationTime", 0.1);
	level.proximitychaindebug = getdvarint("scr_proximityChainDebug", 0);
	level.proximitychaingraceperiod = getdvarint("scr_proximityChainGracePeriod", 2500);
	level.proximitychainboltspeed = getdvarfloat("scr_proximityChainBoltSpeed", 400);
	level.proximitygrenadeprotectedtime = getdvarfloat("scr_proximityGrenadeProtectedTime", 0.45);
	level.poisonfxduration = 6;
	level thread register();
	callback::on_spawned(&on_player_spawned);
	callback::add_weapon_damage(getweapon("proximity_grenade"), &on_damage);
	/#
		level thread updatedvars();
	#/
}

/*
	Name: register
	Namespace: proximity_grenade
	Checksum: 0xF014CEFA
	Offset: 0x8F8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function register()
{
	clientfield::register("toplayer", "tazered", 1, 1, "int");
}

/*
	Name: updatedvars
	Namespace: proximity_grenade
	Checksum: 0xEE08D814
	Offset: 0x938
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function updatedvars()
{
	while(true)
	{
		level.proximitygrenadedetectionradius = getdvarint("scr_proximityGrenadeDetectionRadius", level.proximitygrenadedetectionradius);
		level.proximitygrenadeduration = getdvarfloat("scr_proximityGrenadeDuration", 1.5);
		level.proximitygrenadegraceperiod = getdvarfloat("scr_proximityGrenadeGracePeriod", level.proximitygrenadegraceperiod);
		level.proximitygrenadedotdamageamount = getdvarint("scr_proximityGrenadeDOTDamageAmount", level.proximitygrenadedotdamageamount);
		level.proximitygrenadedotdamageamounthardcore = getdvarint("scr_proximityGrenadeDOTDamageAmountHardcore", level.proximitygrenadedotdamageamounthardcore);
		level.proximitygrenadedotdamagetime = getdvarfloat("scr_proximityGrenadeDOTDamageTime", level.proximitygrenadedotdamagetime);
		level.proximitygrenadedotdamageinstances = getdvarint("scr_proximityGrenadeDOTDamageInstances", level.proximitygrenadedotdamageinstances);
		level.proximitygrenadeactivationtime = getdvarfloat("scr_proximityGrenadeActivationTime", level.proximitygrenadeactivationtime);
		level.proximitychaindebug = getdvarint("scr_proximityChainDebug", level.proximitychaindebug);
		level.proximitychaingraceperiod = getdvarint("scr_proximityChainGracePeriod", level.proximitychaingraceperiod);
		level.proximitychainboltspeed = getdvarfloat("scr_proximityChainBoltSpeed", level.proximitychainboltspeed);
		level.proximitygrenadeprotectedtime = getdvarfloat("scr_proximityGrenadeProtectedTime", level.proximitygrenadeprotectedtime);
		wait(1);
	}
}

/*
	Name: createproximitygrenadewatcher
	Namespace: proximity_grenade
	Checksum: 0x834E24B8
	Offset: 0xB38
	Size: 0x1B0
	Parameters: 0
	Flags: Linked
*/
function createproximitygrenadewatcher()
{
	watcher = self weaponobjects::createproximityweaponobjectwatcher("proximity_grenade", self.team);
	watcher.watchforfire = 1;
	watcher.hackable = 1;
	watcher.hackertoolradius = level.equipmenthackertoolradius;
	watcher.hackertooltimems = level.equipmenthackertooltimems;
	watcher.headicon = 0;
	watcher.activatefx = 1;
	watcher.ownergetsassist = 1;
	watcher.ignoredirection = 1;
	watcher.immediatedetonation = 1;
	watcher.detectiongraceperiod = level.proximitygrenadegraceperiod;
	watcher.detonateradius = level.proximitygrenadedetectionradius;
	watcher.onstun = &weaponobjects::weaponstun;
	watcher.stuntime = 1;
	watcher.ondetonatecallback = &proximitydetonate;
	watcher.activationdelay = level.proximitygrenadeactivationtime;
	watcher.activatesound = "wpn_claymore_alert";
	watcher.immunespecialty = "specialty_immunetriggershock";
	watcher.onspawn = &onspawnproximitygrenadeweaponobject;
}

/*
	Name: creategadgetproximitygrenadewatcher
	Namespace: proximity_grenade
	Checksum: 0xF0F9537F
	Offset: 0xCF0
	Size: 0x198
	Parameters: 0
	Flags: Linked
*/
function creategadgetproximitygrenadewatcher()
{
	watcher = self weaponobjects::createproximityweaponobjectwatcher("gadget_sticky_proximity", self.team);
	watcher.watchforfire = 1;
	watcher.hackable = 1;
	watcher.hackertoolradius = level.equipmenthackertoolradius;
	watcher.hackertooltimems = level.equipmenthackertooltimems;
	watcher.headicon = 0;
	watcher.activatefx = 1;
	watcher.ownergetsassist = 1;
	watcher.ignoredirection = 1;
	watcher.immediatedetonation = 1;
	watcher.detectiongraceperiod = level.proximitygrenadegraceperiod;
	watcher.detonateradius = level.proximitygrenadedetectionradius;
	watcher.onstun = &weaponobjects::weaponstun;
	watcher.stuntime = 1;
	watcher.ondetonatecallback = &proximitydetonate;
	watcher.activationdelay = level.proximitygrenadeactivationtime;
	watcher.activatesound = "wpn_claymore_alert";
	watcher.onspawn = &onspawnproximitygrenadeweaponobject;
}

/*
	Name: onspawnproximitygrenadeweaponobject
	Namespace: proximity_grenade
	Checksum: 0xF649D748
	Offset: 0xE90
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function onspawnproximitygrenadeweaponobject(watcher, owner)
{
	self thread setupkillcament();
	owner addweaponstat(self.weapon, "used", 1);
	if(isdefined(self.weapon) && self.weapon.proximitydetonation > 0)
	{
		watcher.detonateradius = self.weapon.proximitydetonation;
	}
	weaponobjects::onspawnproximityweaponobject(watcher, owner);
	self trackonowner(self.owner);
}

/*
	Name: trackonowner
	Namespace: proximity_grenade
	Checksum: 0x2D73D5F6
	Offset: 0xF68
	Size: 0x96
	Parameters: 1
	Flags: Linked
*/
function trackonowner(owner)
{
	if(level.trackproximitygrenadesonowner === 1)
	{
		if(!isdefined(owner))
		{
			return;
		}
		if(!isdefined(owner.activeproximitygrenades))
		{
			owner.activeproximitygrenades = [];
		}
		else
		{
			arrayremovevalue(owner.activeproximitygrenades, undefined);
		}
		owner.activeproximitygrenades[owner.activeproximitygrenades.size] = self;
	}
}

/*
	Name: setupkillcament
	Namespace: proximity_grenade
	Checksum: 0xC1FAD299
	Offset: 0x1008
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function setupkillcament()
{
	self endon(#"death");
	self util::waittillnotmoving();
	self.killcament = spawn("script_model", self.origin + vectorscale((0, 0, 1), 8));
	self thread cleanupkillcamentondeath();
}

/*
	Name: cleanupkillcamentondeath
	Namespace: proximity_grenade
	Checksum: 0x52FAE0B4
	Offset: 0x1088
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function cleanupkillcamentondeath()
{
	self waittill(#"death");
	self.killcament util::deleteaftertime(4 + (level.proximitygrenadedotdamagetime * level.proximitygrenadedotdamageinstances));
}

/*
	Name: proximitydetonate
	Namespace: proximity_grenade
	Checksum: 0x498EA605
	Offset: 0x10D8
	Size: 0xBC
	Parameters: 3
	Flags: Linked
*/
function proximitydetonate(attacker, weapon, target)
{
	if(isdefined(weapon) && weapon.isvalid)
	{
		if(isdefined(attacker))
		{
			if(self.owner util::isenemyplayer(attacker))
			{
				attacker challenges::destroyedexplosive(weapon);
				scoreevents::processscoreevent("destroyed_proxy", attacker, self.owner, weapon);
			}
		}
	}
	weaponobjects::weapondetonate(attacker, weapon);
}

/*
	Name: proximitygrenadedamageplayer
	Namespace: proximity_grenade
	Checksum: 0xF33B8149
	Offset: 0x11A0
	Size: 0xCC
	Parameters: 7
	Flags: Linked
*/
function proximitygrenadedamageplayer(eattacker, einflictor, killcament, weapon, meansofdeath, damage, proximitychain)
{
	self thread damageplayerinradius(einflictor.origin, eattacker, killcament);
	if(weapon.chaineventradius > 0 && !self hasperk("specialty_proximityprotection"))
	{
		self thread proximitygrenadechain(eattacker, einflictor, killcament, weapon, meansofdeath, damage, proximitychain, 0);
	}
}

/*
	Name: getproximitychain
	Namespace: proximity_grenade
	Checksum: 0xA2264755
	Offset: 0x1278
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function getproximitychain()
{
	if(!isdefined(level.proximitychains))
	{
		level.proximitychains = [];
	}
	foreach(chain in level.proximitychains)
	{
		if(!chainisactive(chain))
		{
			return chain;
		}
	}
	chain = spawnstruct();
	level.proximitychains[level.proximitychains.size] = chain;
	return chain;
}

/*
	Name: chainisactive
	Namespace: proximity_grenade
	Checksum: 0xE50A9619
	Offset: 0x1360
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function chainisactive(chain)
{
	if(isdefined(chain.activeendtime) && chain.activeendtime > gettime())
	{
		return true;
	}
	return false;
}

/*
	Name: cleanupproximitychainent
	Namespace: proximity_grenade
	Checksum: 0x32151E57
	Offset: 0x13A8
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function cleanupproximitychainent()
{
	self.cleanup = 1;
	any_active = 1;
	while(any_active)
	{
		wait(1);
		if(!isdefined(self))
		{
			return;
		}
		any_active = 0;
		foreach(proximitychain in self.chains)
		{
			if(proximitychain.activeendtime > gettime())
			{
				any_active = 1;
				break;
			}
		}
	}
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: isinchain
	Namespace: proximity_grenade
	Checksum: 0x92EAEF7D
	Offset: 0x14A8
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function isinchain(player)
{
	player_num = player getentitynumber();
	return isdefined(self.chain_players[player_num]);
}

/*
	Name: addplayertochain
	Namespace: proximity_grenade
	Checksum: 0xC4929230
	Offset: 0x14F0
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function addplayertochain(player)
{
	player_num = player getentitynumber();
	self.chain_players[player_num] = player;
}

/*
	Name: proximitygrenadechain
	Namespace: proximity_grenade
	Checksum: 0x25D5BD53
	Offset: 0x1540
	Size: 0x4C0
	Parameters: 8
	Flags: Linked
*/
function proximitygrenadechain(eattacker, einflictor, killcament, weapon, meansofdeath, damage, proximitychain, delay)
{
	self endon(#"disconnect");
	self endon(#"death");
	eattacker endon(#"disconnect");
	if(!isdefined(proximitychain))
	{
		proximitychain = getproximitychain();
		proximitychain.chaineventnum = 0;
		if(!isdefined(einflictor.proximitychainent))
		{
			einflictor.proximitychainent = spawn("script_origin", self.origin);
			einflictor.proximitychainent.chains = [];
			einflictor.proximitychainent.chain_players = [];
		}
		proximitychain.proximitychainent = einflictor.proximitychainent;
		proximitychain.proximitychainent.chains[proximitychain.proximitychainent.chains.size] = proximitychain;
	}
	proximitychain.chaineventnum = proximitychain.chaineventnum + 1;
	if(proximitychain.chaineventnum >= weapon.chaineventmax)
	{
		return;
	}
	chaineventradiussq = weapon.chaineventradius * weapon.chaineventradius;
	endtime = gettime() + weapon.chaineventtime;
	proximitychain.proximitychainent addplayertochain(self);
	proximitychain.activeendtime = (endtime + (delay * 1000)) + level.proximitychaingraceperiod;
	if(delay > 0)
	{
		wait(delay);
	}
	if(!isdefined(proximitychain.proximitychainent.cleanup))
	{
		proximitychain.proximitychainent thread cleanupproximitychainent();
	}
	while(true)
	{
		currenttime = gettime();
		if(endtime < currenttime)
		{
			return;
		}
		closestplayers = arraysort(level.players, self.origin, 1);
		foreach(player in closestplayers)
		{
			wait(0.05);
			if(proximitychain.chaineventnum >= weapon.chaineventmax)
			{
				return;
			}
			if(!isdefined(player) || !isalive(player) || player == self)
			{
				continue;
			}
			if(player.sessionstate != "playing")
			{
				continue;
			}
			distancesq = distancesquared(player.origin, self.origin);
			if(distancesq > chaineventradiussq)
			{
				break;
			}
			if(proximitychain.proximitychainent isinchain(player))
			{
				continue;
			}
			if(level.proximitychaindebug || weaponobjects::friendlyfirecheck(eattacker, player))
			{
				if(level.proximitychaindebug || !player hasperk("specialty_proximityprotection"))
				{
					self thread chainplayer(eattacker, killcament, weapon, meansofdeath, damage, proximitychain, player, distancesq);
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: chainplayer
	Namespace: proximity_grenade
	Checksum: 0xFEF483C0
	Offset: 0x1A08
	Size: 0x1CC
	Parameters: 8
	Flags: Linked
*/
function chainplayer(eattacker, killcament, weapon, meansofdeath, damage, proximitychain, player, distancesq)
{
	waittime = 0.25;
	speedsq = level.proximitychainboltspeed * level.proximitychainboltspeed;
	if(speedsq > 100 && distancesq > 1)
	{
		waittime = distancesq / speedsq;
	}
	player thread proximitygrenadechain(eattacker, self, killcament, weapon, meansofdeath, damage, proximitychain, waittime);
	wait(0.05);
	if(level.proximitychaindebug)
	{
		/#
			color = (1, 1, 1);
			alpha = 1;
			depth = 0;
			time = 200;
			util::debug_line(self.origin + vectorscale((0, 0, 1), 50), player.origin + vectorscale((0, 0, 1), 50), color, alpha, depth, time);
		#/
	}
	self tesla_play_arc_fx(player, waittime);
	player thread damageplayerinradius(self.origin, eattacker, killcament);
}

/*
	Name: tesla_play_arc_fx
	Namespace: proximity_grenade
	Checksum: 0x1EC939AD
	Offset: 0x1BE0
	Size: 0x1C4
	Parameters: 2
	Flags: Linked
*/
function tesla_play_arc_fx(target, waittime)
{
	if(!isdefined(self) || !isdefined(target))
	{
		return;
	}
	tag = "J_SpineUpper";
	target_tag = "J_SpineUpper";
	origin = self gettagorigin(tag);
	target_origin = target gettagorigin(target_tag);
	distance_squared = 16384;
	if(distancesquared(origin, target_origin) < distance_squared)
	{
		return;
	}
	fxorg = spawn("script_model", origin);
	fxorg setmodel("tag_origin");
	fx = playfxontag(level._effect["prox_grenade_chain_bolt"], fxorg, "tag_origin");
	playsoundatposition("wpn_tesla_bounce", fxorg.origin);
	fxorg moveto(target_origin, waittime);
	fxorg waittill(#"movedone");
	fxorg delete();
}

/*
	Name: debugchainsphere
	Namespace: proximity_grenade
	Checksum: 0x62421615
	Offset: 0x1DB0
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function debugchainsphere()
{
	/#
		util::debug_sphere(self.origin + vectorscale((0, 0, 1), 50), 20, (1, 1, 1), 1, 0);
	#/
}

/*
	Name: watchproximitygrenadehitplayer
	Namespace: proximity_grenade
	Checksum: 0xF67451FF
	Offset: 0x1DF8
	Size: 0x122
	Parameters: 1
	Flags: Linked
*/
function watchproximitygrenadehitplayer(owner)
{
	self endon(#"death");
	self setowner(owner);
	self setteam(owner.team);
	while(true)
	{
		self waittill(#"grenade_bounce", pos, normal, ent, surface);
		if(isdefined(ent) && isplayer(ent) && surface != "riotshield")
		{
			if(level.teambased && ent.team == self.owner.team)
			{
				continue;
			}
			self proximitydetonate(self.owner, self.weapon);
			return;
		}
	}
}

/*
	Name: performhudeffects
	Namespace: proximity_grenade
	Checksum: 0x81DE685
	Offset: 0x1F28
	Size: 0x140
	Parameters: 2
	Flags: None
*/
function performhudeffects(position, distancetogrenade)
{
	forwardvec = vectornormalize(anglestoforward(self.angles));
	rightvec = vectornormalize(anglestoright(self.angles));
	explosionvec = vectornormalize(position - self.origin);
	fdot = vectordot(explosionvec, forwardvec);
	rdot = vectordot(explosionvec, rightvec);
	fangle = acos(fdot);
	rangle = acos(rdot);
}

/*
	Name: damageplayerinradius
	Namespace: proximity_grenade
	Checksum: 0x22D131C8
	Offset: 0x2070
	Size: 0x40C
	Parameters: 3
	Flags: Linked
*/
function damageplayerinradius(position, eattacker, killcament)
{
	self notify(#"proximitygrenadedamagestart");
	self endon(#"proximitygrenadedamagestart");
	self endon(#"disconnect");
	self endon(#"death");
	eattacker endon(#"disconnect");
	playfxontag(level._effect["prox_grenade_player_shock"], self, "J_SpineUpper");
	g_time = gettime();
	if(self util::mayapplyscreeneffect())
	{
		if(!self hasperk("specialty_proximityprotection"))
		{
			self.lastshockedby = eattacker;
			self.shockendtime = gettime() + (level.proximitygrenadeduration * 1000);
			self shellshock("proximity_grenade", level.proximitygrenadeduration, 0);
		}
		self clientfield::set_to_player("tazered", 1);
	}
	self playrumbleonentity("proximity_grenade");
	self playsound("wpn_taser_mine_zap");
	if(!self hasperk("specialty_proximityprotection"))
	{
		self thread watch_death();
		if(!isdefined(killcament))
		{
			killcament = spawn("script_model", position + vectorscale((0, 0, 1), 8));
		}
		killcament.soundmod = "taser_spike";
		killcament util::deleteaftertime(3 + (level.proximitygrenadedotdamagetime * level.proximitygrenadedotdamageinstances));
		self util::show_hud(0);
		damage = level.proximitygrenadedotdamageamount;
		if(level.hardcoremode)
		{
			damage = level.proximitygrenadedotdamageamounthardcore;
		}
		for(i = 0; i < level.proximitygrenadedotdamageinstances; i++)
		{
			/#
				assert(isdefined(eattacker));
			#/
			if(!isdefined(killcament))
			{
				killcament = spawn("script_model", position + vectorscale((0, 0, 1), 8));
				killcament.soundmod = "taser_spike";
				killcament util::deleteaftertime(3 + (level.proximitygrenadedotdamagetime * (level.proximitygrenadedotdamageinstances - i)));
			}
			self dodamage(damage, position, eattacker, killcament, "none", "MOD_GAS", 0, getweapon("proximity_grenade_aoe"));
			wait(level.proximitygrenadedotdamagetime);
		}
		if((gettime() - g_time) < (level.proximitygrenadeduration * 1000))
		{
			wait((gettime() - g_time) / 1000);
		}
		self util::show_hud(1);
	}
	else
	{
		wait(level.proximitygrenadeprotectedtime);
	}
	self clientfield::set_to_player("tazered", 0);
}

/*
	Name: proximitydeathwait
	Namespace: proximity_grenade
	Checksum: 0xAD26345A
	Offset: 0x2488
	Size: 0x26
	Parameters: 1
	Flags: None
*/
function proximitydeathwait(owner)
{
	self waittill(#"death");
	self notify(#"deletesound");
}

/*
	Name: deleteentonownerdeath
	Namespace: proximity_grenade
	Checksum: 0x75BE551B
	Offset: 0x24B8
	Size: 0x62
	Parameters: 1
	Flags: None
*/
function deleteentonownerdeath(owner)
{
	self thread deleteentontimeout();
	self thread deleteentaftertime();
	self endon(#"delete");
	owner waittill(#"death");
	self notify(#"deletesound");
}

/*
	Name: deleteentaftertime
	Namespace: proximity_grenade
	Checksum: 0xB38B49ED
	Offset: 0x2528
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function deleteentaftertime()
{
	self endon(#"delete");
	wait(10);
	self notify(#"deletesound");
}

/*
	Name: deleteentontimeout
	Namespace: proximity_grenade
	Checksum: 0xC8753C0D
	Offset: 0x2558
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function deleteentontimeout()
{
	self endon(#"delete");
	self waittill(#"deletesound");
	self delete();
}

/*
	Name: watch_death
	Namespace: proximity_grenade
	Checksum: 0x5F2AF52C
	Offset: 0x2598
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function watch_death()
{
	self endon(#"disconnect");
	self notify(#"proximity_cleanup");
	self endon(#"proximity_cleanup");
	self waittill(#"death");
	self stoprumble("proximity_grenade");
	self setblur(0, 0);
	self util::show_hud(1);
	self clientfield::set_to_player("tazered", 0);
}

/*
	Name: on_player_spawned
	Namespace: proximity_grenade
	Checksum: 0xB2E384D7
	Offset: 0x2648
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self thread createproximitygrenadewatcher();
	self thread creategadgetproximitygrenadewatcher();
	self thread begin_other_grenade_tracking();
}

/*
	Name: begin_other_grenade_tracking
	Namespace: proximity_grenade
	Checksum: 0xFD1C6B69
	Offset: 0x26A0
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function begin_other_grenade_tracking()
{
	self endon(#"death");
	self endon(#"disconnect");
	self notify(#"proximitytrackingstart");
	self endon(#"proximitytrackingstart");
	for(;;)
	{
		self waittill(#"grenade_fire", grenade, weapon, cooktime);
		if(grenade util::ishacked())
		{
			continue;
		}
		if(weapon.rootweapon.name == "proximity_grenade")
		{
			grenade thread watchproximitygrenadehitplayer(self);
		}
	}
}

/*
	Name: on_damage
	Namespace: proximity_grenade
	Checksum: 0x9A9163A8
	Offset: 0x2768
	Size: 0x64
	Parameters: 5
	Flags: Linked
*/
function on_damage(eattacker, einflictor, weapon, meansofdeath, damage)
{
	self thread proximitygrenadedamageplayer(eattacker, einflictor, einflictor.killcament, weapon, meansofdeath, damage, undefined);
}

