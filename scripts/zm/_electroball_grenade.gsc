// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\zm\_zm;
#using scripts\zm\_zm_elemental_zombies;

#namespace electroball_grenade;

/*
	Name: __init__sytem__
	Namespace: electroball_grenade
	Checksum: 0x24BAFD17
	Offset: 0x460
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("electroball_grenade", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: electroball_grenade
	Checksum: 0x98358305
	Offset: 0x4A0
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.proximitygrenadedetectionradius = getdvarint("scr_proximityGrenadeDetectionRadius", 180);
	level.proximitygrenadegraceperiod = getdvarfloat("scr_proximityGrenadeGracePeriod", 0.05);
	level.proximitygrenadedotdamageamount = getdvarint("scr_proximityGrenadeDOTDamageAmount", 1);
	level.proximitygrenadedotdamageamounthardcore = getdvarint("scr_proximityGrenadeDOTDamageAmountHardcore", 1);
	level.proximitygrenadedotdamagetime = getdvarfloat("scr_proximityGrenadeDOTDamageTime", 0.2);
	level.proximitygrenadedotdamageinstances = getdvarint("scr_proximityGrenadeDOTDamageInstances", 4);
	level.proximitygrenadeactivationtime = getdvarfloat("scr_proximityGrenadeActivationTime", 0.1);
	level.proximitygrenadeprotectedtime = getdvarfloat("scr_proximityGrenadeProtectedTime", 0.45);
	level thread register();
	if(!isdefined(level.spawnprotectiontimems))
	{
		level.spawnprotectiontimems = 0;
	}
	callback::on_spawned(&on_player_spawned);
	callback::on_ai_spawned(&on_ai_spawned);
	zm::register_actor_damage_callback(&function_f338543f);
}

/*
	Name: register
	Namespace: electroball_grenade
	Checksum: 0x6F91A6F0
	Offset: 0x680
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function register()
{
	clientfield::register("toplayer", "tazered", 1, 1, "int");
	clientfield::register("actor", "electroball_make_sparky", 1, 1, "int");
	clientfield::register("missile", "electroball_stop_trail", 1, 1, "int");
	clientfield::register("missile", "electroball_play_landed_fx", 1, 1, "int");
	clientfield::register("allplayers", "electroball_shock", 1, 1, "int");
}

/*
	Name: function_b0f1e452
	Namespace: electroball_grenade
	Checksum: 0x83FBFC52
	Offset: 0x780
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function function_b0f1e452()
{
	if(isplayer(self))
	{
		watcher = self weaponobjects::createproximityweaponobjectwatcher("electroball_grenade", self.team);
	}
	else
	{
		watcher = self weaponobjects::createproximityweaponobjectwatcher("electroball_grenade", level.zombie_team);
	}
	watcher.watchforfire = 1;
	watcher.hackable = 0;
	watcher.hackertoolradius = level.equipmenthackertoolradius;
	watcher.hackertooltimems = level.equipmenthackertooltimems;
	watcher.headicon = 0;
	watcher.activatefx = 1;
	watcher.ownergetsassist = 1;
	watcher.ignoredirection = 1;
	watcher.immediatedetonation = 1;
	watcher.detectiongraceperiod = 0.05;
	watcher.detonateradius = 64;
	watcher.onstun = &weaponobjects::weaponstun;
	watcher.stuntime = 1;
	watcher.ondetonatecallback = &proximitydetonate;
	watcher.activationdelay = 0.05;
	watcher.activatesound = "wpn_claymore_alert";
	watcher.immunespecialty = "specialty_immunetriggershock";
	watcher.onspawn = &function_f424c33d;
}

/*
	Name: function_f424c33d
	Namespace: electroball_grenade
	Checksum: 0x5EF42B94
	Offset: 0x980
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function function_f424c33d(watcher, owner)
{
	self thread setupkillcament();
	if(isplayer(owner))
	{
		owner addweaponstat(self.weapon, "used", 1);
	}
	if(isdefined(self.weapon) && self.weapon.proximitydetonation > 0)
	{
		watcher.detonateradius = self.weapon.proximitydetonation;
	}
	weaponobjects::onspawnproximityweaponobject(watcher, owner);
	self thread function_cb55123a();
	self thread function_658aacad();
}

/*
	Name: setupkillcament
	Namespace: electroball_grenade
	Checksum: 0xEB020A51
	Offset: 0xA80
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
	Namespace: electroball_grenade
	Checksum: 0x71413420
	Offset: 0xB00
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
	Namespace: electroball_grenade
	Checksum: 0xA30AD74E
	Offset: 0xB50
	Size: 0x34
	Parameters: 3
	Flags: Linked
*/
function proximitydetonate(attacker, weapon, target)
{
	weaponobjects::weapondetonate(attacker, weapon);
}

/*
	Name: watchproximitygrenadehitplayer
	Namespace: electroball_grenade
	Checksum: 0x2158EE84
	Offset: 0xB90
	Size: 0x112
	Parameters: 1
	Flags: Linked
*/
function watchproximitygrenadehitplayer(owner)
{
	self endon(#"death");
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
	Namespace: electroball_grenade
	Checksum: 0x555DCF24
	Offset: 0xCB0
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
	Name: function_62ffcc2c
	Namespace: electroball_grenade
	Checksum: 0x1AEE8449
	Offset: 0xDF8
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function function_62ffcc2c()
{
	self endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"damage", damage, eattacker, dir, point, type, model, tag, part, weapon, flags);
		if(weapon.name == "electroball_grenade")
		{
			self damageplayerinradius(eattacker);
		}
		wait(0.05);
	}
}

/*
	Name: damageplayerinradius
	Namespace: electroball_grenade
	Checksum: 0x30C6150A
	Offset: 0xEE8
	Size: 0x1F4
	Parameters: 1
	Flags: Linked
*/
function damageplayerinradius(eattacker)
{
	self notify(#"proximitygrenadedamagestart");
	self endon(#"proximitygrenadedamagestart");
	self endon(#"disconnect");
	self endon(#"death");
	eattacker endon(#"disconnect");
	self clientfield::set("electroball_shock", 1);
	g_time = gettime();
	if(self util::mayapplyscreeneffect())
	{
		self.lastshockedby = eattacker;
		self.shockendtime = gettime() + 100;
		self shellshock("electrocution", 0.1);
		self clientfield::set_to_player("tazered", 1);
	}
	self playrumbleonentity("proximity_grenade");
	self playsound("wpn_taser_mine_zap");
	if(!self hasperk("specialty_proximityprotection"))
	{
		self thread watch_death();
		self util::show_hud(0);
		if((gettime() - g_time) < 100)
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
	Namespace: electroball_grenade
	Checksum: 0xF15BB8D6
	Offset: 0x10E8
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
	Namespace: electroball_grenade
	Checksum: 0x33817271
	Offset: 0x1118
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
	Namespace: electroball_grenade
	Checksum: 0x807641F3
	Offset: 0x1188
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
	Namespace: electroball_grenade
	Checksum: 0x8BDCE009
	Offset: 0x11B8
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
	Namespace: electroball_grenade
	Checksum: 0xE5093CB5
	Offset: 0x11F8
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
	Namespace: electroball_grenade
	Checksum: 0xAEC2653D
	Offset: 0x12A8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	if(isplayer(self))
	{
		self thread function_b0f1e452();
		self thread begin_other_grenade_tracking();
		self thread function_62ffcc2c();
	}
}

/*
	Name: on_ai_spawned
	Namespace: electroball_grenade
	Checksum: 0xB3B74871
	Offset: 0x1318
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function on_ai_spawned()
{
	if(self.archetype === "mechz")
	{
		self thread function_b0f1e452();
		self thread begin_other_grenade_tracking();
	}
}

/*
	Name: begin_other_grenade_tracking
	Namespace: electroball_grenade
	Checksum: 0xDA909244
	Offset: 0x1368
	Size: 0xA8
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
		if(weapon.rootweapon.name == "electroball_grenade")
		{
			grenade thread watchproximitygrenadehitplayer(self);
		}
	}
}

/*
	Name: function_cb55123a
	Namespace: electroball_grenade
	Checksum: 0x29FB6CA2
	Offset: 0x1418
	Size: 0x218
	Parameters: 0
	Flags: Linked
*/
function function_cb55123a()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"delete");
	self waittill(#"grenade_bounce");
	while(true)
	{
		var_82aacc64 = zm_elemental_zombie::function_d41418b8();
		var_82aacc64 = arraysortclosest(var_82aacc64, self.origin);
		var_199ecc3a = zm_elemental_zombie::function_4aeed0a5("sparky");
		if(!isdefined(level.var_1ae26ca5) || var_199ecc3a < level.var_1ae26ca5)
		{
			if(!isdefined(level.var_a9284ac8) || (gettime() - level.var_a9284ac8) >= 0.5)
			{
				foreach(ai_zombie in var_82aacc64)
				{
					dist_sq = distancesquared(self.origin, ai_zombie.origin);
					if(dist_sq <= 9216 && ai_zombie.is_elemental_zombie !== 1 && ai_zombie.var_3531cf2b !== 1)
					{
						ai_zombie clientfield::set("electroball_make_sparky", 1);
						ai_zombie zm_elemental_zombie::function_1b1bb1b();
						level.var_a9284ac8 = gettime();
						break;
					}
				}
			}
		}
		wait(0.5);
	}
}

/*
	Name: function_658aacad
	Namespace: electroball_grenade
	Checksum: 0x2F275AD6
	Offset: 0x1638
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_658aacad()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"delete");
	self waittill(#"grenade_bounce");
	self clientfield::set("electroball_stop_trail", 1);
	self setmodel("tag_origin");
	self clientfield::set("electroball_play_landed_fx", 1);
	if(!isdefined(level.a_electroball_grenades))
	{
		level.a_electroball_grenades = [];
	}
	array::add(level.a_electroball_grenades, self);
}

/*
	Name: function_f338543f
	Namespace: electroball_grenade
	Checksum: 0x5F1F3B7F
	Offset: 0x1708
	Size: 0xD0
	Parameters: 12
	Flags: Linked
*/
function function_f338543f(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	if(isdefined(weapon) && weapon.rootweapon.name === "electroball_grenade")
	{
		if(isdefined(attacker) && self.team === attacker.team)
		{
			return 0;
		}
		if(self.var_3531cf2b === 1)
		{
			return 0;
		}
	}
	return -1;
}

