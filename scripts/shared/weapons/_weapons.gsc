// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\bb_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\loadout_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_empgrenade;
#using scripts\shared\weapons\_flashgrenades;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_hive_gun;
#using scripts\shared\weapons\_proximity_grenade;
#using scripts\shared\weapons\_riotshield;
#using scripts\shared\weapons\_sticky_grenade;
#using scripts\shared\weapons\_tabun;
#using scripts\shared\weapons\_trophy_system;
#using scripts\shared\weapons\_weapon_utils;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons_shared;

#namespace weapons;

/*
	Name: init_shared
	Namespace: weapons
	Checksum: 0x67F617A7
	Offset: 0x838
	Size: 0x154
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.weaponnone = getweapon("none");
	level.weaponnull = getweapon("weapon_null");
	level.weaponbasemelee = getweapon("knife");
	level.weaponbasemeleeheld = getweapon("knife_held");
	level.weaponballisticknife = getweapon("knife_ballistic");
	level.weaponriotshield = getweapon("riotshield");
	level.weaponflashgrenade = getweapon("flash_grenade");
	level.weaponsatchelcharge = getweapon("satchel_charge");
	if(!isdefined(level.trackweaponstats))
	{
		level.trackweaponstats = 1;
	}
	level._effect["flashNineBang"] = "_t6/misc/fx_equip_tac_insert_exp";
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: weapons
	Checksum: 0x1B7AC9B
	Offset: 0x998
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.missileentities = [];
	level.hackertooltargets = [];
	level.missileduddeletedelay = getdvarint("scr_missileDudDeleteDelay", 3);
	if(!isdefined(level.roundstartexplosivedelay))
	{
		level.roundstartexplosivedelay = 0;
	}
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_connect
	Namespace: weapons
	Checksum: 0x841AA62A
	Offset: 0xA40
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self.usedweapons = 0;
	self.lastfiretime = 0;
	self.hits = 0;
	self scavenger_hud_create();
}

/*
	Name: on_player_spawned
	Namespace: weapons
	Checksum: 0xA35ECFDC
	Offset: 0xA88
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self.concussionendtime = 0;
	self.scavenged = 0;
	self.hasdonecombat = 0;
	self.shielddamageblocked = 0;
	self thread watch_usage();
	self thread watch_grenade_usage();
	self thread watch_missile_usage();
	self thread watch_weapon_change();
	if(level.trackweaponstats)
	{
		self thread track();
	}
	self.droppeddeathweapon = undefined;
	self.tookweaponfrom = [];
	self.pickedupweaponkills = [];
	self thread update_stowed_weapon();
}

/*
	Name: watch_weapon_change
	Namespace: weapons
	Checksum: 0x29B51C90
	Offset: 0xB80
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function watch_weapon_change()
{
	self endon(#"death");
	self endon(#"disconnect");
	self.lastdroppableweapon = self getcurrentweapon();
	self.lastweaponchange = 0;
	while(true)
	{
		previous_weapon = self getcurrentweapon();
		self waittill(#"weapon_change", newweapon);
		if(may_drop(newweapon))
		{
			self.lastdroppableweapon = newweapon;
			self.lastweaponchange = gettime();
		}
		if(doesweaponreplacespawnweapon(self.spawnweapon, newweapon))
		{
			self.spawnweapon = newweapon;
			self.pers["spawnWeapon"] = newweapon;
		}
	}
}

/*
	Name: update_last_held_weapon_timings
	Namespace: weapons
	Checksum: 0xCF883187
	Offset: 0xC80
	Size: 0xF0
	Parameters: 1
	Flags: Linked
*/
function update_last_held_weapon_timings(newtime)
{
	if(isdefined(self.currentweapon) && isdefined(self.currentweaponstarttime))
	{
		totaltime = int((newtime - self.currentweaponstarttime) / 1000);
		if(totaltime > 0)
		{
			weaponpickedup = 0;
			if(isdefined(self.pickedupweapons) && isdefined(self.pickedupweapons[self.currentweapon]))
			{
				weaponpickedup = 1;
			}
			if(isdefined(self.class_num))
			{
				self addweaponstat(self.currentweapon, "timeUsed", totaltime, self.class_num, weaponpickedup);
				self.currentweaponstarttime = newtime;
			}
		}
	}
}

/*
	Name: update_timings
	Namespace: weapons
	Checksum: 0x43065E59
	Offset: 0xD78
	Size: 0x39E
	Parameters: 1
	Flags: Linked
*/
function update_timings(newtime)
{
	if(self util::is_bot())
	{
		return;
	}
	update_last_held_weapon_timings(newtime);
	if(!isdefined(self.staticweaponsstarttime))
	{
		return;
	}
	totaltime = int((newtime - self.staticweaponsstarttime) / 1000);
	if(totaltime < 0)
	{
		return;
	}
	self.staticweaponsstarttime = newtime;
	if(isdefined(self.weapon_array_grenade))
	{
		for(i = 0; i < self.weapon_array_grenade.size; i++)
		{
			self addweaponstat(self.weapon_array_grenade[i], "timeUsed", totaltime, self.class_num);
		}
	}
	if(isdefined(self.weapon_array_inventory))
	{
		for(i = 0; i < self.weapon_array_inventory.size; i++)
		{
			self addweaponstat(self.weapon_array_inventory[i], "timeUsed", totaltime, self.class_num);
		}
	}
	if(isdefined(self.killstreak))
	{
		for(i = 0; i < self.killstreak.size; i++)
		{
			killstreaktype = level.menureferenceforkillstreak[self.killstreak[i]];
			if(isdefined(killstreaktype))
			{
				killstreakweapon = killstreaks::get_killstreak_weapon(killstreaktype);
				self addweaponstat(killstreakweapon, "timeUsed", totaltime, self.class_num);
			}
		}
	}
	if(level.rankedmatch && level.perksenabled)
	{
		perksindexarray = [];
		specialtys = self.specialty;
		if(!isdefined(specialtys))
		{
			return;
		}
		if(!isdefined(self.curclass))
		{
			return;
		}
		if(isdefined(self.class_num))
		{
			for(numspecialties = 0; numspecialties < level.maxspecialties; numspecialties++)
			{
				perk = self getloadoutitem(self.class_num, "specialty" + (numspecialties + 1));
				if(perk != 0)
				{
					perksindexarray[perk] = 1;
				}
			}
			perkindexarraykeys = getarraykeys(perksindexarray);
			for(i = 0; i < perkindexarraykeys.size; i++)
			{
				if(perksindexarray[perkindexarraykeys[i]] == 1)
				{
					self adddstat("itemStats", perkindexarraykeys[i], "stats", "timeUsed", "statValue", totaltime);
				}
			}
		}
	}
}

/*
	Name: track
	Namespace: weapons
	Checksum: 0x8B04BA21
	Offset: 0x1120
	Size: 0x1BA
	Parameters: 0
	Flags: Linked
*/
function track()
{
	currentweapon = self getcurrentweapon();
	currenttime = gettime();
	spawnid = getplayerspawnid(self);
	while(true)
	{
		event = self util::waittill_any_return("weapon_change", "death", "disconnect");
		newtime = gettime();
		if(event == "weapon_change")
		{
			self bb::commit_weapon_data(spawnid, currentweapon, currenttime);
			newweapon = self getcurrentweapon();
			if(newweapon != level.weaponnone && newweapon != currentweapon)
			{
				update_last_held_weapon_timings(newtime);
				self loadout::initweaponattachments(newweapon);
				currentweapon = newweapon;
				currenttime = newtime;
			}
		}
		else
		{
			if(event != "disconnect" && isdefined(self))
			{
				self bb::commit_weapon_data(spawnid, currentweapon, currenttime);
				update_timings(newtime);
			}
			return;
		}
	}
}

/*
	Name: may_drop
	Namespace: weapons
	Checksum: 0xBD01174B
	Offset: 0x12E8
	Size: 0xA8
	Parameters: 1
	Flags: Linked
*/
function may_drop(weapon)
{
	if(level.disableweapondrop == 1)
	{
		return false;
	}
	if(weapon == level.weaponnone)
	{
		return false;
	}
	if(killstreaks::is_killstreak_weapon(weapon))
	{
		return false;
	}
	if(weapon.isgameplayweapon)
	{
		return false;
	}
	if(!weapon.isprimary)
	{
		return false;
	}
	if(isdefined(level.maydropweapon) && ![[level.maydropweapon]](weapon))
	{
		return false;
	}
	return true;
}

/*
	Name: drop_for_death
	Namespace: weapons
	Checksum: 0x1BE08F36
	Offset: 0x1398
	Size: 0x4CC
	Parameters: 3
	Flags: None
*/
function drop_for_death(attacker, sweapon, smeansofdeath)
{
	if(level.disableweapondrop == 1)
	{
		return;
	}
	weapon = self.lastdroppableweapon;
	if(isdefined(self.droppeddeathweapon))
	{
		return;
	}
	if(!isdefined(weapon))
	{
		/#
			if(getdvarstring("") == "")
			{
				println("");
			}
		#/
		return;
	}
	if(weapon == level.weaponnone)
	{
		/#
			if(getdvarstring("") == "")
			{
				println("");
			}
		#/
		return;
	}
	if(!self hasweapon(weapon))
	{
		/#
			if(getdvarstring("") == "")
			{
				println(("" + weapon.name) + "");
			}
		#/
		return;
	}
	if(!self anyammoforweaponmodes(weapon))
	{
		/#
			if(getdvarstring("") == "")
			{
				println("");
			}
		#/
		return;
	}
	if(!should_drop_limited_weapon(weapon, self))
	{
		return;
	}
	if(weapon.iscarriedkillstreak)
	{
		return;
	}
	clipammo = self getweaponammoclip(weapon);
	stockammo = self getweaponammostock(weapon);
	clip_and_stock_ammo = clipammo + stockammo;
	if(!clip_and_stock_ammo && (!(isdefined(weapon.unlimitedammo) && weapon.unlimitedammo)))
	{
		/#
			if(getdvarstring("") == "")
			{
				println("");
			}
		#/
		return;
	}
	if(isdefined(weapon.isnotdroppable) && weapon.isnotdroppable)
	{
		return;
	}
	stockmax = weapon.maxammo;
	if(stockammo > stockmax)
	{
		stockammo = stockmax;
	}
	item = self dropitem(weapon);
	if(!isdefined(item))
	{
		/#
			iprintlnbold("" + weapon.name);
		#/
		return;
	}
	/#
		if(getdvarstring("") == "")
		{
			println("" + weapon.name);
		}
	#/
	drop_limited_weapon(weapon, self, item);
	self.droppeddeathweapon = 1;
	item itemweaponsetammo(clipammo, stockammo);
	if(isdefined(level.var_ad0ac054))
	{
		self [[level.var_ad0ac054]](item);
	}
	item.owner = self;
	item.ownersattacker = attacker;
	item.sweapon = sweapon;
	item.smeansofdeath = smeansofdeath;
	item thread watch_pickup();
	item thread delete_pickup_after_awhile();
}

/*
	Name: delete_pickup_after_awhile
	Namespace: weapons
	Checksum: 0xCD0354C9
	Offset: 0x1870
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function delete_pickup_after_awhile()
{
	self endon(#"death");
	wait(60);
	if(!isdefined(self))
	{
		return;
	}
	self delete();
}

/*
	Name: watch_pickup
	Namespace: weapons
	Checksum: 0x465EE9CC
	Offset: 0x18B0
	Size: 0x3BC
	Parameters: 0
	Flags: Linked
*/
function watch_pickup()
{
	self endon(#"death");
	weapon = self.item;
	self waittill(#"trigger", player, droppeditem, pickedupontouch);
	if(1)
	{
		if(isdefined(player) && isplayer(player))
		{
			if(isdefined(player.weaponpickupscount))
			{
				player.weaponpickupscount++;
			}
			else
			{
				player.weaponpickupscount = 1;
			}
			player incrementspecificweaponpickedupcount(weapon);
			if(!isdefined(player.pickedupweapons))
			{
				player.pickedupweapons = [];
			}
			player.pickedupweapons[weapon] = 1;
		}
	}
	/#
		if(getdvarstring("") == "")
		{
			println((("" + weapon.name) + "") + isdefined(self.ownersattacker));
		}
	#/
	/#
		assert(isdefined(player.tookweaponfrom));
	#/
	/#
		assert(isdefined(player.pickedupweaponkills));
	#/
	if(isdefined(droppeditem))
	{
		for(i = 0; i < droppeditem.size; i++)
		{
			if(!isdefined(droppeditem[i]))
			{
				continue;
			}
			droppedweapon = droppeditem[i].item;
			if(isdefined(player.tookweaponfrom[droppedweapon]))
			{
				droppeditem[i].owner = player.tookweaponfrom[droppedweapon];
				droppeditem[i].ownersattacker = player;
				player.tookweaponfrom[droppedweapon] = undefined;
			}
			droppeditem[i] thread watch_pickup();
		}
	}
	if(!isdefined(pickedupontouch) || !pickedupontouch)
	{
		if(isdefined(self.ownersattacker) && self.ownersattacker == player)
		{
			player.tookweaponfrom[weapon] = spawnstruct();
			player.tookweaponfrom[weapon].previousowner = self.owner;
			player.tookweaponfrom[weapon].sweapon = self.sweapon;
			player.tookweaponfrom[weapon].smeansofdeath = self.smeansofdeath;
			player.pickedupweaponkills[weapon] = 0;
		}
		else
		{
			player.tookweaponfrom[weapon] = undefined;
			player.pickedupweaponkills[weapon] = undefined;
		}
	}
}

/*
	Name: watch_usage
	Namespace: weapons
	Checksum: 0x5B6443B6
	Offset: 0x1C78
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function watch_usage()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	for(;;)
	{
		self waittill(#"weapon_fired", curweapon);
		self.lastfiretime = gettime();
		self.hasdonecombat = 1;
		switch(curweapon.weapclass)
		{
			case "mg":
			case "pistol":
			case "pistol spread":
			case "rifle":
			case "smg":
			case "spread":
			{
				self track_fire(curweapon);
				level.globalshotsfired++;
				break;
			}
			case "grenade":
			case "rocketlauncher":
			{
				self addweaponstat(curweapon, "shots", 1, self.class_num, 0);
				break;
			}
			default:
			{
				break;
			}
		}
		if(isdefined(curweapon.gadget_type) && curweapon.gadget_type == 14)
		{
			if(isdefined(self.heroweaponshots))
			{
				self.heroweaponshots++;
			}
		}
		if(curweapon.iscarriedkillstreak)
		{
			if(isdefined(self.pers["held_killstreak_ammo_count"][curweapon]))
			{
				self.pers["held_killstreak_ammo_count"][curweapon]--;
			}
		}
	}
}

/*
	Name: track_fire
	Namespace: weapons
	Checksum: 0xB04E0E19
	Offset: 0x1E20
	Size: 0x1F4
	Parameters: 1
	Flags: Linked
*/
function track_fire(curweapon)
{
	if(isdefined(level.var_64783fef) && level.var_64783fef)
	{
		return;
	}
	pixbeginevent("trackWeaponFire");
	weaponpickedup = 0;
	if(isdefined(self.pickedupweapons) && isdefined(self.pickedupweapons[curweapon]))
	{
		weaponpickedup = 1;
	}
	self trackweaponfirenative(curweapon, 1, self.hits, 1, self.class_num, weaponpickedup, self.primaryloadoutgunsmithvariantindex, self.secondaryloadoutgunsmithvariantindex);
	if(isdefined(self.totalmatchshots))
	{
		self.totalmatchshots++;
	}
	self bb::add_to_stat("shots", 1);
	self bb::add_to_stat("hits", self.hits);
	if(level.mpcustommatch === 1)
	{
		self.pers["shotsfired"]++;
		self.shotsfired = self.pers["shotsfired"];
		self.pers["shotshit"] = self.pers["shotshit"] + self.hits;
		self.shotshit = self.pers["shotshit"];
		self.pers["shotsmissed"] = self.shotsfired - self.shotshit;
		self.shotsmissed = self.pers["shotsmissed"];
	}
	self.hits = 0;
	pixendevent();
}

/*
	Name: watch_grenade_usage
	Namespace: weapons
	Checksum: 0xDE5E77F8
	Offset: 0x2020
	Size: 0x158
	Parameters: 0
	Flags: Linked
*/
function watch_grenade_usage()
{
	self endon(#"death");
	self endon(#"disconnect");
	self.throwinggrenade = 0;
	self.gotpullbacknotify = 0;
	self thread begin_other_grenade_tracking();
	self thread watch_for_throwbacks();
	self thread watch_for_grenade_duds();
	self thread watch_for_grenade_launcher_duds();
	for(;;)
	{
		self waittill(#"grenade_pullback", weapon);
		self addweaponstat(weapon, "shots", 1, self.class_num);
		self.hasdonecombat = 1;
		self.throwinggrenade = 1;
		self.gotpullbacknotify = 1;
		if(weapon.drawoffhandmodelinhand)
		{
			self setoffhandvisible(1);
			self thread watch_offhand_end();
		}
		self thread begin_grenade_tracking();
	}
}

/*
	Name: watch_missile_usage
	Namespace: weapons
	Checksum: 0x3989661D
	Offset: 0x2180
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function watch_missile_usage()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	for(;;)
	{
		self waittill(#"missile_fire", missile, weapon);
		self.hasdonecombat = 1;
		/#
			/#
				assert(isdefined(missile));
			#/
		#/
		level.missileentities[level.missileentities.size] = missile;
		missile.weapon = weapon;
		missile thread watch_missile_death();
	}
}

/*
	Name: watch_missile_death
	Namespace: weapons
	Checksum: 0xAF60BCBB
	Offset: 0x2248
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function watch_missile_death()
{
	self waittill(#"death");
	arrayremovevalue(level.missileentities, self);
}

/*
	Name: drop_all_to_ground
	Namespace: weapons
	Checksum: 0xE02B04BA
	Offset: 0x2280
	Size: 0x112
	Parameters: 2
	Flags: None
*/
function drop_all_to_ground(origin, radius)
{
	weapons = getdroppedweapons();
	for(i = 0; i < weapons.size; i++)
	{
		if(distancesquared(origin, weapons[i].origin) < (radius * radius))
		{
			trace = bullettrace(weapons[i].origin, weapons[i].origin + (vectorscale((0, 0, -1), 2000)), 0, weapons[i]);
			weapons[i].origin = trace["position"];
		}
	}
}

/*
	Name: drop_grenades_to_ground
	Namespace: weapons
	Checksum: 0x2186506A
	Offset: 0x23A0
	Size: 0xCE
	Parameters: 2
	Flags: None
*/
function drop_grenades_to_ground(origin, radius)
{
	grenades = getentarray("grenade", "classname");
	for(i = 0; i < grenades.size; i++)
	{
		if(distancesquared(origin, grenades[i].origin) < (radius * radius))
		{
			grenades[i] launch(vectorscale((1, 1, 1), 5));
		}
	}
}

/*
	Name: watch_grenade_cancel
	Namespace: weapons
	Checksum: 0xF7BE0457
	Offset: 0x2478
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function watch_grenade_cancel()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"grenade_fire");
	waittillframeend();
	weapon = level.weaponnone;
	while(self isthrowinggrenade() && weapon == level.weaponnone)
	{
		self waittill(#"weapon_change", weapon);
	}
	self.throwinggrenade = 0;
	self.gotpullbacknotify = 0;
	self notify(#"grenade_throw_cancelled");
}

/*
	Name: watch_offhand_end
	Namespace: weapons
	Checksum: 0x5FDA6EDD
	Offset: 0x2528
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function watch_offhand_end()
{
	self notify(#"watchoffhandend");
	self endon(#"watchoffhandend");
	while(self is_using_offhand_equipment())
	{
		msg = self util::waittill_any_return("death", "disconnect", "grenade_fire", "weapon_change", "watchOffhandEnd");
		if(msg == "death" || msg == "disconnect")
		{
			break;
		}
	}
	if(isdefined(self))
	{
		self setoffhandvisible(0);
	}
}

/*
	Name: is_using_offhand_equipment
	Namespace: weapons
	Checksum: 0xFB180180
	Offset: 0x25F8
	Size: 0x5A
	Parameters: 0
	Flags: Linked
*/
function is_using_offhand_equipment()
{
	if(self isusingoffhand())
	{
		weapon = self getcurrentoffhand();
		if(weapon.isequipment)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: begin_grenade_tracking
	Namespace: weapons
	Checksum: 0x5E39C0EE
	Offset: 0x2660
	Size: 0x3A4
	Parameters: 0
	Flags: Linked
*/
function begin_grenade_tracking()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"grenade_throw_cancelled");
	starttime = gettime();
	self thread watch_grenade_cancel();
	self waittill(#"grenade_fire", grenade, weapon, cooktime);
	/#
		/#
			assert(isdefined(grenade));
		#/
	#/
	level.missileentities[level.missileentities.size] = grenade;
	grenade.weapon = weapon;
	grenade thread watch_missile_death();
	if(sessionmodeiscampaignzombiesgame() || (isdefined(level.projectiles_should_ignore_world_pause) && level.projectiles_should_ignore_world_pause))
	{
		grenade setignorepauseworld(1);
	}
	if(grenade util::ishacked())
	{
		return;
	}
	blackboxeventname = "mpequipmentuses";
	if(sessionmodeiscampaigngame())
	{
		blackboxeventname = "cpequipmentuses";
	}
	else if(sessionmodeiszombiesgame())
	{
		blackboxeventname = "zmequipmentuses";
	}
	bbprint(blackboxeventname, "gametime %d spawnid %d weaponname %s", gettime(), getplayerspawnid(self), weapon.name);
	cookedtime = gettime() - starttime;
	if(cookedtime > 1000)
	{
		grenade.iscooked = 1;
	}
	if(isdefined(self.grenadesused))
	{
		self.grenadesused++;
	}
	switch(weapon.rootweapon.name)
	{
		case "frag_grenade":
		{
			level.globalfraggrenadesfired++;
		}
		case "sticky_grenade":
		{
			self addweaponstat(weapon, "used", 1);
			grenade setteam(self.pers["team"]);
			grenade setowner(self);
		}
		case "explosive_bolt":
		{
			grenade.originalowner = self;
			break;
		}
		case "satchel_charge":
		{
			level.globalsatchelchargefired++;
			break;
		}
		case "concussion_grenade":
		case "flash_grenade":
		{
			self addweaponstat(weapon, "used", 1);
			break;
		}
	}
	self.throwinggrenade = 0;
	if(weapon.cookoffholdtime > 0)
	{
		grenade thread track_cooked_detonation(self, weapon, cooktime);
	}
	else if(weapon.multidetonation > 0)
	{
		grenade thread track_multi_detonation(self, weapon, cooktime);
	}
}

/*
	Name: begin_other_grenade_tracking
	Namespace: weapons
	Checksum: 0x83E9E592
	Offset: 0x2A10
	Size: 0x1C6
	Parameters: 0
	Flags: Linked
*/
function begin_other_grenade_tracking()
{
	self notify(#"othergrenadetrackingstart");
	self endon(#"othergrenadetrackingstart");
	self endon(#"disconnect");
	for(;;)
	{
		self waittill(#"grenade_fire", grenade, weapon);
		if(grenade util::ishacked())
		{
			continue;
		}
		switch(weapon.rootweapon.name)
		{
			case "tabun_gas":
			{
				grenade thread tabun::watchtabungrenadedetonation(self);
				break;
			}
			case "sticky_grenade":
			{
				grenade thread check_stuck_to_player(1, 1, weapon);
				grenade thread riotshield::check_stuck_to_shield();
				break;
			}
			case "c4":
			case "satchel_charge":
			{
				grenade thread check_stuck_to_player(1, 0, weapon);
				break;
			}
			case "hatchet":
			{
				grenade.lastweaponbeforetoss = self util::getlastweapon();
				grenade thread check_hatchet_bounce();
				grenade thread check_stuck_to_player(0, 0, weapon);
				self addweaponstat(weapon, "used", 1);
				break;
			}
			default:
			{
				break;
			}
		}
	}
}

/*
	Name: check_stuck_to_player
	Namespace: weapons
	Checksum: 0xC8B7655B
	Offset: 0x2BE0
	Size: 0xD0
	Parameters: 3
	Flags: Linked
*/
function check_stuck_to_player(deleteonteamchange, awardscoreevent, weapon)
{
	self endon(#"death");
	self waittill(#"stuck_to_player", player);
	if(isdefined(player))
	{
		if(deleteonteamchange)
		{
			self thread stuck_to_player_team_change(player);
		}
		if(awardscoreevent && isdefined(self.originalowner))
		{
			if(self.originalowner util::isenemyplayer(player))
			{
				scoreevents::processscoreevent("stick_explosive_kill", self.originalowner, player, weapon);
			}
		}
		self.stucktoplayer = player;
	}
}

/*
	Name: check_hatchet_bounce
	Namespace: weapons
	Checksum: 0x1D0FA64C
	Offset: 0x2CB8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function check_hatchet_bounce()
{
	self endon(#"stuck_to_player");
	self endon(#"death");
	self waittill(#"grenade_bounce");
	self.bounced = 1;
}

/*
	Name: stuck_to_player_team_change
	Namespace: weapons
	Checksum: 0x5A84F380
	Offset: 0x2CF8
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function stuck_to_player_team_change(player)
{
	self endon(#"death");
	player endon(#"disconnect");
	originalteam = player.pers["team"];
	while(true)
	{
		player waittill(#"joined_team");
		if(player.pers["team"] != originalteam)
		{
			self detonate();
			return;
		}
	}
}

/*
	Name: watch_for_throwbacks
	Namespace: weapons
	Checksum: 0xCD8A9FF1
	Offset: 0x2DA0
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function watch_for_throwbacks()
{
	self endon(#"death");
	self endon(#"disconnect");
	for(;;)
	{
		self waittill(#"grenade_fire", grenade, weapon);
		if(self.gotpullbacknotify)
		{
			self.gotpullbacknotify = 0;
			continue;
		}
		if(!issubstr(weapon.name, "frag_"))
		{
			continue;
		}
		grenade.threwback = 1;
		grenade.originalowner = self;
	}
}

/*
	Name: wait_and_delete_dud
	Namespace: weapons
	Checksum: 0xBD6A0922
	Offset: 0x2E50
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function wait_and_delete_dud(waittime)
{
	self endon(#"death");
	wait(waittime);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: gettimefromlevelstart
	Namespace: weapons
	Checksum: 0xE56CCB7F
	Offset: 0x2E98
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function gettimefromlevelstart()
{
	if(!isdefined(level.starttime))
	{
		return 0;
	}
	return gettime() - level.starttime;
}

/*
	Name: turn_grenade_into_a_dud
	Namespace: weapons
	Checksum: 0xA95F8633
	Offset: 0x2EC0
	Size: 0x154
	Parameters: 3
	Flags: Linked
*/
function turn_grenade_into_a_dud(weapon, isthrowngrenade, player)
{
	time = gettimefromlevelstart() / 1000;
	if(level.roundstartexplosivedelay >= time)
	{
		if(weapon.disallowatmatchstart || weaponhasattachment(weapon, "gl"))
		{
			timeleft = int(level.roundstartexplosivedelay - time);
			if(!timeleft)
			{
				timeleft = 1;
			}
			if(isthrowngrenade)
			{
				player iprintlnbold(&"MP_GRENADE_UNAVAILABLE_FOR_N", (" " + timeleft) + " ", &"EXE_SECONDS");
			}
			else
			{
				player iprintlnbold(&"MP_LAUNCHER_UNAVAILABLE_FOR_N", (" " + timeleft) + " ", &"EXE_SECONDS");
			}
			self makegrenadedud();
		}
	}
}

/*
	Name: watch_for_grenade_duds
	Namespace: weapons
	Checksum: 0x78A51E6C
	Offset: 0x3020
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function watch_for_grenade_duds()
{
	self endon(#"spawned_player");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"grenade_fire", grenade, weapon);
		grenade turn_grenade_into_a_dud(weapon, 1, self);
	}
}

/*
	Name: watch_for_grenade_launcher_duds
	Namespace: weapons
	Checksum: 0x5967A361
	Offset: 0x3098
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function watch_for_grenade_launcher_duds()
{
	self endon(#"spawned_player");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"grenade_launcher_fire", grenade, weapon);
		grenade turn_grenade_into_a_dud(weapon, 0, self);
		/#
			/#
				assert(isdefined(grenade));
			#/
		#/
		level.missileentities[level.missileentities.size] = grenade;
		grenade.weapon = weapon;
		grenade thread watch_missile_death();
	}
}

/*
	Name: get_damageable_ents
	Namespace: weapons
	Checksum: 0x3F7153ED
	Offset: 0x3168
	Size: 0x818
	Parameters: 4
	Flags: None
*/
function get_damageable_ents(pos, radius, dolos, startradius)
{
	ents = [];
	if(!isdefined(dolos))
	{
		dolos = 0;
	}
	if(!isdefined(startradius))
	{
		startradius = 0;
	}
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(!isalive(players[i]) || players[i].sessionstate != "playing")
		{
			continue;
		}
		playerpos = players[i].origin + vectorscale((0, 0, 1), 32);
		distsq = distancesquared(pos, playerpos);
		if(distsq < (radius * radius) && (!dolos || damage_trace_passed(pos, playerpos, startradius, undefined)))
		{
			newent = spawnstruct();
			newent.isplayer = 1;
			newent.isadestructable = 0;
			newent.isadestructible = 0;
			newent.isactor = 0;
			newent.entity = players[i];
			newent.damagecenter = playerpos;
			ents[ents.size] = newent;
		}
	}
	grenades = getentarray("grenade", "classname");
	for(i = 0; i < grenades.size; i++)
	{
		entpos = grenades[i].origin;
		distsq = distancesquared(pos, entpos);
		if(distsq < (radius * radius) && (!dolos || damage_trace_passed(pos, entpos, startradius, grenades[i])))
		{
			newent = spawnstruct();
			newent.isplayer = 0;
			newent.isadestructable = 0;
			newent.isadestructible = 0;
			newent.isactor = 0;
			newent.entity = grenades[i];
			newent.damagecenter = entpos;
			ents[ents.size] = newent;
		}
	}
	destructibles = getentarray("destructible", "targetname");
	for(i = 0; i < destructibles.size; i++)
	{
		entpos = destructibles[i].origin;
		distsq = distancesquared(pos, entpos);
		if(distsq < (radius * radius) && (!dolos || damage_trace_passed(pos, entpos, startradius, destructibles[i])))
		{
			newent = spawnstruct();
			newent.isplayer = 0;
			newent.isadestructable = 0;
			newent.isadestructible = 1;
			newent.isactor = 0;
			newent.entity = destructibles[i];
			newent.damagecenter = entpos;
			ents[ents.size] = newent;
		}
	}
	destructables = getentarray("destructable", "targetname");
	for(i = 0; i < destructables.size; i++)
	{
		entpos = destructables[i].origin;
		distsq = distancesquared(pos, entpos);
		if(distsq < (radius * radius) && (!dolos || damage_trace_passed(pos, entpos, startradius, destructables[i])))
		{
			newent = spawnstruct();
			newent.isplayer = 0;
			newent.isadestructable = 1;
			newent.isadestructible = 0;
			newent.isactor = 0;
			newent.entity = destructables[i];
			newent.damagecenter = entpos;
			ents[ents.size] = newent;
		}
	}
	dogs = [[level.dogmanagerongetdogs]]();
	if(isdefined(dogs))
	{
		foreach(dog in dogs)
		{
			if(!isalive(dog))
			{
				continue;
			}
			entpos = dog.origin;
			distsq = distancesquared(pos, entpos);
			if(distsq < (radius * radius) && (!dolos || damage_trace_passed(pos, entpos, startradius, dog)))
			{
				newent = spawnstruct();
				newent.isplayer = 0;
				newent.isadestructable = 0;
				newent.isadestructible = 0;
				newent.isactor = 1;
				newent.entity = dog;
				newent.damagecenter = entpos;
				ents[ents.size] = newent;
			}
		}
	}
	return ents;
}

/*
	Name: damage_trace_passed
	Namespace: weapons
	Checksum: 0x2B576490
	Offset: 0x3988
	Size: 0x62
	Parameters: 4
	Flags: Linked
*/
function damage_trace_passed(from, to, startradius, ignore)
{
	trace = damage_trace(from, to, startradius, ignore);
	return trace["fraction"] == 1;
}

/*
	Name: damage_trace
	Namespace: weapons
	Checksum: 0xC65B159B
	Offset: 0x39F8
	Size: 0x1E0
	Parameters: 4
	Flags: Linked
*/
function damage_trace(from, to, startradius, ignore)
{
	midpos = undefined;
	diff = to - from;
	if(lengthsquared(diff) < (startradius * startradius))
	{
		midpos = to;
	}
	dir = vectornormalize(diff);
	midpos = from + (dir[0] * startradius, dir[1] * startradius, dir[2] * startradius);
	trace = bullettrace(midpos, to, 0, ignore);
	if(getdvarint("scr_damage_debug") != 0)
	{
		if(trace["fraction"] == 1)
		{
			thread debugline(midpos, to, (1, 1, 1));
		}
		else
		{
			thread debugline(midpos, trace["position"], (1, 0.9, 0.8));
			thread debugline(trace["position"], to, (1, 0.4, 0.3));
		}
	}
	return trace;
}

/*
	Name: damage_ent
	Namespace: weapons
	Checksum: 0x36889EC1
	Offset: 0x3BE0
	Size: 0x19C
	Parameters: 7
	Flags: None
*/
function damage_ent(einflictor, eattacker, idamage, smeansofdeath, weapon, damagepos, damagedir)
{
	if(self.isplayer)
	{
		self.damageorigin = damagepos;
		self.entity thread [[level.callbackplayerdamage]](einflictor, eattacker, idamage, 0, smeansofdeath, weapon, damagepos, damagedir, "none", damagepos, 0, 0, undefined);
	}
	else
	{
		if(self.isactor)
		{
			self.damageorigin = damagepos;
			self.entity thread [[level.callbackactordamage]](einflictor, eattacker, idamage, 0, smeansofdeath, weapon, damagepos, damagedir, "none", damagepos, 0, 0, 0, 0, (1, 0, 0));
		}
		else
		{
			if(self.isadestructible)
			{
				self.damageorigin = damagepos;
				self.entity dodamage(idamage, damagepos, eattacker, einflictor, 0, smeansofdeath, 0, weapon);
			}
			else
			{
				self.entity util::damage_notify_wrapper(idamage, eattacker, (0, 0, 0), (0, 0, 0), "mod_explosive", "", "");
			}
		}
	}
}

/*
	Name: debugline
	Namespace: weapons
	Checksum: 0xF09ABCD7
	Offset: 0x3D88
	Size: 0x6E
	Parameters: 3
	Flags: Linked
*/
function debugline(a, b, color)
{
	/#
		for(i = 0; i < 600; i++)
		{
			line(a, b, color);
			wait(0.05);
		}
	#/
}

/*
	Name: on_damage
	Namespace: weapons
	Checksum: 0xF272A1A7
	Offset: 0x3E00
	Size: 0x27E
	Parameters: 5
	Flags: None
*/
function on_damage(eattacker, einflictor, weapon, meansofdeath, damage)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(isdefined(level._custom_weapon_damage_func))
	{
		is_weapon_registered = self [[level._custom_weapon_damage_func]](eattacker, einflictor, weapon, meansofdeath, damage);
		if(is_weapon_registered)
		{
			return;
		}
	}
	switch(weapon.rootweapon.name)
	{
		case "concussion_grenade":
		{
			if(isdefined(self.concussionimmune) && self.concussionimmune)
			{
				return;
			}
			radius = weapon.explosionradius;
			if(self == eattacker)
			{
				radius = radius * 0.5;
			}
			scale = 1 - (distance(self.origin, einflictor.origin) / radius);
			if(scale < 0)
			{
				scale = 0;
			}
			time = 0.25 + (4 * scale);
			wait(0.05);
			if(meansofdeath != "MOD_IMPACT")
			{
				if(self hasperk("specialty_stunprotection"))
				{
					time = time * 0.1;
				}
				else if(self util::mayapplyscreeneffect())
				{
					self shellshock("concussion_grenade_mp", time, 0);
				}
				self thread play_concussion_sound(time);
				self.concussionendtime = gettime() + (time * 1000);
				self.lastconcussedby = eattacker;
			}
			break;
		}
		default:
		{
			if(isdefined(level.shellshockonplayerdamage))
			{
				[[level.shellshockonplayerdamage]](meansofdeath, damage, weapon);
			}
			break;
		}
	}
}

/*
	Name: play_concussion_sound
	Namespace: weapons
	Checksum: 0x1B40F140
	Offset: 0x4088
	Size: 0x154
	Parameters: 1
	Flags: Linked
*/
function play_concussion_sound(duration)
{
	self endon(#"death");
	self endon(#"disconnect");
	concussionsound = spawn("script_origin", (0, 0, 1));
	concussionsound.origin = self.origin;
	concussionsound linkto(self);
	concussionsound thread delete_ent_on_owner_death(self);
	concussionsound playsound("");
	concussionsound playloopsound("");
	if(duration > 0.5)
	{
		wait(duration - 0.5);
	}
	concussionsound playsound("");
	concussionsound stoploopsound(0.5);
	wait(0.5);
	concussionsound notify(#"delete");
	concussionsound delete();
}

/*
	Name: delete_ent_on_owner_death
	Namespace: weapons
	Checksum: 0x9C673764
	Offset: 0x41E8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function delete_ent_on_owner_death(owner)
{
	self endon(#"delete");
	owner waittill(#"death");
	self delete();
}

/*
	Name: update_stowed_weapon
	Namespace: weapons
	Checksum: 0xF2D68EBF
	Offset: 0x4230
	Size: 0x358
	Parameters: 0
	Flags: Linked
*/
function update_stowed_weapon()
{
	self endon(#"spawned");
	self endon(#"killed_player");
	self endon(#"disconnect");
	self.tag_stowed_back = undefined;
	self.tag_stowed_hip = undefined;
	team = self.pers["team"];
	playerclass = self.pers["class"];
	while(true)
	{
		self waittill(#"weapon_change", newweapon);
		if(self ismantling())
		{
			continue;
		}
		currentstowed = self getstowedweapon();
		hasstowed = 0;
		self.weapon_array_primary = [];
		self.weapon_array_sidearm = [];
		self.weapon_array_grenade = [];
		self.weapon_array_inventory = [];
		weaponslist = self getweaponslist();
		for(idx = 0; idx < weaponslist.size; idx++)
		{
			switch(weaponslist[idx].name)
			{
				case "m32":
				case "minigun":
				{
					continue;
				}
				default:
				{
					break;
				}
			}
			if(!hasstowed || currentstowed == weaponslist[idx])
			{
				currentstowed = weaponslist[idx];
				hasstowed = 1;
			}
			if(is_primary_weapon(weaponslist[idx]))
			{
				self.weapon_array_primary[self.weapon_array_primary.size] = weaponslist[idx];
				continue;
			}
			if(is_side_arm(weaponslist[idx]))
			{
				self.weapon_array_sidearm[self.weapon_array_sidearm.size] = weaponslist[idx];
				continue;
			}
			if(is_grenade(weaponslist[idx]))
			{
				self.weapon_array_grenade[self.weapon_array_grenade.size] = weaponslist[idx];
				continue;
			}
			if(is_inventory(weaponslist[idx]))
			{
				self.weapon_array_inventory[self.weapon_array_inventory.size] = weaponslist[idx];
				continue;
			}
			if(weaponslist[idx].isprimary)
			{
				self.weapon_array_primary[self.weapon_array_primary.size] = weaponslist[idx];
			}
		}
		if(newweapon != level.weaponnone || !hasstowed)
		{
			detach_all_weapons();
			stow_on_back();
			stow_on_hip();
		}
	}
}

/*
	Name: loadout_get_offhand_weapon
	Namespace: weapons
	Checksum: 0xAA51B53
	Offset: 0x4590
	Size: 0xE2
	Parameters: 1
	Flags: None
*/
function loadout_get_offhand_weapon(stat)
{
	if(isdefined(level.givecustomloadout))
	{
		return level.weaponnone;
	}
	/#
		assert(isdefined(self.class_num));
	#/
	if(isdefined(self.class_num))
	{
		index = self loadout::getloadoutitemfromddlstats(self.class_num, stat);
		if(isdefined(level.tbl_weaponids[index]) && isdefined(level.tbl_weaponids[index]["reference"]))
		{
			return getweapon(level.tbl_weaponids[index]["reference"]);
		}
	}
	return level.weaponnone;
}

/*
	Name: loadout_get_offhand_count
	Namespace: weapons
	Checksum: 0xB4F6C83A
	Offset: 0x4680
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function loadout_get_offhand_count(stat)
{
	count = 0;
	if(isdefined(level.givecustomloadout))
	{
		return 0;
	}
	/#
		assert(isdefined(self.class_num));
	#/
	if(isdefined(self.class_num))
	{
		count = self loadout::getloadoutitemfromddlstats(self.class_num, stat);
	}
	return count;
}

/*
	Name: flash_scavenger_icon
	Namespace: weapons
	Checksum: 0x5869C852
	Offset: 0x4710
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function flash_scavenger_icon()
{
	self.scavenger_icon.alpha = 1;
	self.scavenger_icon fadeovertime(1);
	self.scavenger_icon.alpha = 0;
}

/*
	Name: scavenger_think
	Namespace: weapons
	Checksum: 0x95FC46E8
	Offset: 0x4768
	Size: 0x58A
	Parameters: 0
	Flags: Linked
*/
function scavenger_think()
{
	self endon(#"death");
	self waittill(#"scavenger", player);
	primary_weapons = player getweaponslistprimaries();
	offhand_weapons_and_alts = array::exclude(player getweaponslist(1), primary_weapons);
	arrayremovevalue(offhand_weapons_and_alts, level.weaponbasemelee);
	offhand_weapons_and_alts = array::reverse(offhand_weapons_and_alts);
	player playsound("wpn_ammo_pickup");
	player playlocalsound("wpn_ammo_pickup");
	player flash_scavenger_icon();
	for(i = 0; i < offhand_weapons_and_alts.size; i++)
	{
		weapon = offhand_weapons_and_alts[i];
		if(!weapon.isscavengable || killstreaks::is_killstreak_weapon(weapon))
		{
			continue;
		}
		maxammo = 0;
		if(weapon == player.grenadetypeprimary && isdefined(player.grenadetypeprimarycount) && player.grenadetypeprimarycount > 0)
		{
			maxammo = player.grenadetypeprimarycount;
		}
		else if(weapon == player.grenadetypesecondary && isdefined(player.grenadetypesecondarycount) && player.grenadetypesecondarycount > 0)
		{
			maxammo = player.grenadetypesecondarycount;
		}
		if(isdefined(level.var_859df572))
		{
			maxammo = player [[level.var_859df572]](weapon, maxammo);
		}
		if(maxammo == 0)
		{
			continue;
		}
		if(weapon.rootweapon == level.weaponsatchelcharge)
		{
			if(player weaponobjects::anyobjectsinworld(weapon.rootweapon))
			{
				continue;
			}
		}
		stock = player getweaponammostock(weapon);
		if(stock < maxammo)
		{
			ammo = stock + 1;
			if(ammo > maxammo)
			{
				ammo = maxammo;
			}
			player setweaponammostock(weapon, ammo);
			player.scavenged = 1;
			player thread challenges::scavengedgrenade();
			continue;
		}
		if(weapon.rootweapon == getweapon("trophy_system"))
		{
			player trophy_system::ammo_scavenger(weapon);
		}
	}
	for(i = 0; i < primary_weapons.size; i++)
	{
		weapon = primary_weapons[i];
		if(!weapon.isscavengable || killstreaks::is_killstreak_weapon(weapon))
		{
			continue;
		}
		stock = player getweaponammostock(weapon);
		start = player getfractionstartammo(weapon);
		clip = weapon.clipsize;
		clip = clip * getdvarfloat("scavenger_clip_multiplier", 1);
		clip = int(clip);
		if(isdefined(level.weaponlauncherex41) && weapon.statindex == level.weaponlauncherex41.statindex)
		{
			clip = 1;
		}
		maxammo = weapon.maxammo;
		if(stock < (maxammo - clip))
		{
			ammo = stock + clip;
			player setweaponammostock(weapon, ammo);
			player.scavenged = 1;
			continue;
		}
		player setweaponammostock(weapon, maxammo);
		player.scavenged = 1;
	}
}

/*
	Name: scavenger_hud_destroyondisconnect
	Namespace: weapons
	Checksum: 0x291B7DF8
	Offset: 0x4D00
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function scavenger_hud_destroyondisconnect()
{
	self waittill(#"disconnect");
	if(isdefined(self.scavenger_icon))
	{
		self.scavenger_icon destroy();
	}
}

/*
	Name: scavenger_hud_create
	Namespace: weapons
	Checksum: 0xF56D679B
	Offset: 0x4D40
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function scavenger_hud_create()
{
	if(level.wagermatch)
	{
		return;
	}
	if(isdefined(level.noscavenger) && level.noscavenger)
	{
		return;
	}
	self.scavenger_icon = newclienthudelem(self);
	if(isdefined(self.scavenger_icon))
	{
		self thread scavenger_hud_destroyondisconnect();
		self.scavenger_icon.horzalign = "center";
		self.scavenger_icon.vertalign = "middle";
		self.scavenger_icon.alpha = 0;
		width = 64;
		height = 64;
		if(level.splitscreen)
		{
			width = int(width * 0.5);
			height = int(height * 0.5);
		}
		self.scavenger_icon.x = (width * -1) / 2;
		self.scavenger_icon.y = 16;
		self.scavenger_icon setshader("hud_scavenger_pickup", width, height);
	}
}

/*
	Name: drop_scavenger_for_death
	Namespace: weapons
	Checksum: 0xC489457
	Offset: 0x4EC8
	Size: 0xEC
	Parameters: 1
	Flags: None
*/
function drop_scavenger_for_death(attacker)
{
	if(level.wagermatch)
	{
		return;
	}
	if(!isdefined(attacker))
	{
		return;
	}
	if(attacker == self)
	{
		return;
	}
	if(level.gametype == "hack")
	{
		item = self dropscavengeritem(getweapon("scavenger_item_hack"));
	}
	else
	{
		if(isplayer(attacker))
		{
			item = self dropscavengeritem(getweapon("scavenger_item"));
		}
		else
		{
			return;
		}
	}
	item thread scavenger_think();
}

/*
	Name: add_limited_weapon
	Namespace: weapons
	Checksum: 0x6B27D1B4
	Offset: 0x4FC0
	Size: 0x74
	Parameters: 3
	Flags: None
*/
function add_limited_weapon(weapon, owner, num_drops)
{
	limited_info = spawnstruct();
	limited_info.weapon = weapon;
	limited_info.drops = num_drops;
	owner.limited_info = limited_info;
}

/*
	Name: should_drop_limited_weapon
	Namespace: weapons
	Checksum: 0xFF173157
	Offset: 0x5040
	Size: 0x7A
	Parameters: 2
	Flags: Linked
*/
function should_drop_limited_weapon(weapon, owner)
{
	limited_info = owner.limited_info;
	if(!isdefined(limited_info))
	{
		return true;
	}
	if(limited_info.weapon != weapon)
	{
		return true;
	}
	if(limited_info.drops <= 0)
	{
		return false;
	}
	return true;
}

/*
	Name: drop_limited_weapon
	Namespace: weapons
	Checksum: 0x6E0524D
	Offset: 0x50C8
	Size: 0xAC
	Parameters: 3
	Flags: Linked
*/
function drop_limited_weapon(weapon, owner, item)
{
	limited_info = owner.limited_info;
	if(!isdefined(limited_info))
	{
		return;
	}
	if(limited_info.weapon != weapon)
	{
		return;
	}
	limited_info.drops = limited_info.drops - 1;
	owner.limited_info = undefined;
	item thread limited_pickup(limited_info);
}

/*
	Name: limited_pickup
	Namespace: weapons
	Checksum: 0x522E4688
	Offset: 0x5180
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function limited_pickup(limited_info)
{
	self endon(#"death");
	self waittill(#"trigger", player, item);
	if(!isdefined(item))
	{
		return;
	}
	player.limited_info = limited_info;
}

/*
	Name: track_cooked_detonation
	Namespace: weapons
	Checksum: 0xA05EE6F5
	Offset: 0x51E8
	Size: 0x8C
	Parameters: 3
	Flags: Linked
*/
function track_cooked_detonation(attacker, weapon, cooktime)
{
	self endon(#"trophy_destroyed");
	self waittill(#"explode", origin, surface);
	if(weapon.rootweapon == level.weaponflashgrenade)
	{
		level thread ninebang_doninebang(attacker, weapon, origin, cooktime);
	}
}

/*
	Name: ninebang_doninebang
	Namespace: weapons
	Checksum: 0xCD8D71A9
	Offset: 0x5280
	Size: 0x4A6
	Parameters: 4
	Flags: Linked
*/
function ninebang_doninebang(attacker, weapon, pos, cooktime)
{
	level endon(#"game_ended");
	maxstages = 4;
	maxradius = 20;
	mindelay = 0.15;
	maxdelay = 0.3;
	explosionradiussq = weapon.explosionradius * weapon.explosionradius;
	explosionradiusminsq = weapon.explosioninnerradius * weapon.explosioninnerradius;
	cookstages = ((cooktime / weapon.cookoffholdtime) * maxstages) + 1;
	detonations = 0;
	if(cookstages < 2)
	{
		return;
	}
	if(cookstages < 3)
	{
		detonations = 3;
	}
	else
	{
		if(cookstages < 4)
		{
			detonations = 6;
		}
		else
		{
			detonations = 9;
		}
	}
	wait(randomfloatrange(mindelay, maxdelay));
	for(i = 1; i < detonations; i++)
	{
		newpos = level ninebang_getsubexplosionpos(pos, maxradius);
		playsoundatposition("wpn_flash_grenade_explode", newpos);
		playfx(level._effect["flashNineBang"], newpos);
		closestplayers = arraysort(level.players, newpos, 1);
		foreach(player in closestplayers)
		{
			if(!isdefined(player) || !isalive(player))
			{
				continue;
			}
			if(player.sessionstate != "playing")
			{
				continue;
			}
			vieworigin = player geteye();
			dist = distancesquared(pos, vieworigin);
			if(dist > explosionradiussq)
			{
				break;
			}
			if(!bullettracepassed(pos, vieworigin, 0, player))
			{
				continue;
			}
			if(dist <= explosionradiusminsq)
			{
				percent_distance = 1;
			}
			else
			{
				percent_distance = 1 - (dist - explosionradiusminsq) / (explosionradiussq - explosionradiusminsq);
			}
			forward = anglestoforward(player getplayerangles());
			toblast = pos - vieworigin;
			toblast = vectornormalize(toblast);
			percent_angle = 0.5 * (1 + vectordot(forward, toblast));
			player notify(#"flashbang", percent_distance, percent_angle, attacker);
		}
		wait(randomfloatrange(mindelay, maxdelay));
	}
}

/*
	Name: ninebang_getsubexplosionpos
	Namespace: weapons
	Checksum: 0xFFC45F1D
	Offset: 0x5730
	Size: 0xB0
	Parameters: 2
	Flags: Linked
*/
function ninebang_getsubexplosionpos(startpos, range)
{
	offset = (randomfloatrange(-1 * range, range), randomfloatrange(-1 * range, range), 0);
	newpos = startpos + offset;
	if(bullettracepassed(startpos, newpos, 0, undefined))
	{
		return newpos;
	}
	return startpos;
}

/*
	Name: ninebang_doempdamage
	Namespace: weapons
	Checksum: 0x3217CA5F
	Offset: 0x57E8
	Size: 0x136
	Parameters: 3
	Flags: None
*/
function ninebang_doempdamage(player, weapon, position)
{
	kninebangempradius = 512;
	radiussq = kninebangempradius * kninebangempradius;
	playsoundatposition("wpn_emp_explode", position);
	level empgrenade::empexplosiondamageents(player, weapon, position, kninebangempradius, 0);
	foreach(targetent in level.players)
	{
		if(ninebang_empcandamage(targetent, position, radiussq, 0, 0))
		{
			targetent notify(#"emp_grenaded", player);
		}
	}
}

/*
	Name: ninebang_empcandamage
	Namespace: weapons
	Checksum: 0xA6E55A88
	Offset: 0x5928
	Size: 0xAA
	Parameters: 5
	Flags: Linked
*/
function ninebang_empcandamage(ent, pos, radiussq, dolos, startradius)
{
	entpos = ent.origin;
	distsq = distancesquared(pos, entpos);
	return distsq < radiussq && (!dolos || weapondamagetracepassed(pos, entpos, startradius, ent));
}

/*
	Name: track_multi_detonation
	Namespace: weapons
	Checksum: 0xB7DAF205
	Offset: 0x59E0
	Size: 0x196
	Parameters: 3
	Flags: Linked
*/
function track_multi_detonation(ownerent, weapon, cooktime)
{
	self endon(#"trophy_destroyed");
	self waittill(#"explode", origin, surface);
	if(weapon.rootweapon == getweapon("frag_grenade_grenade"))
	{
		for(i = 0; i < weapon.multidetonation; i++)
		{
			if(!isdefined(ownerent))
			{
				return;
			}
			multiblastweapon = getweapon("frag_multi_blast");
			dir = level multi_detonation_get_cluster_launch_dir(i, weapon.multidetonation);
			vel = dir * multiblastweapon.multidetonationfragmentspeed;
			fusetime = multiblastweapon.fusetime / 1000;
			grenade = ownerent magicgrenadetype(multiblastweapon, origin, vel, fusetime);
			util::wait_network_frame();
		}
	}
}

/*
	Name: multi_detonation_get_cluster_launch_dir
	Namespace: weapons
	Checksum: 0xB813BC3C
	Offset: 0x5B80
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function multi_detonation_get_cluster_launch_dir(index, multival)
{
	pitch = 45;
	yaw = -180 + ((360 / multival) * index);
	angles = (pitch, yaw, 45);
	dir = anglestoforward(angles);
	return dir;
}

/*
	Name: should_suppress_damage
	Namespace: weapons
	Checksum: 0x73C8F2EE
	Offset: 0x5C18
	Size: 0xEC
	Parameters: 2
	Flags: None
*/
function should_suppress_damage(weapon, inflictor)
{
	if(!isdefined(weapon))
	{
		return false;
	}
	if(!isdefined(self))
	{
		return false;
	}
	if(isdefined(level.weaponspecialdiscgun) && weapon.statindex == level.weaponspecialdiscgun.statindex)
	{
		if(isdefined(inflictor))
		{
			if(!isdefined(inflictor.hit_info))
			{
				inflictor.hit_info = [];
			}
			victimentnum = self getentitynumber();
			if(isdefined(inflictor.hit_info[victimentnum]))
			{
				return true;
			}
			inflictor.hit_info[victimentnum] = 1;
		}
	}
	return false;
}

