// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\player_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_hive_gun;
#using scripts\shared\weapons\_satchel_charge;
#using scripts\shared\weapons\_trophy_system;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons_shared;

#namespace weaponobjects;

/*
	Name: init_shared
	Namespace: weaponobjects
	Checksum: 0xF8BC256E
	Offset: 0xB48
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function init_shared()
{
	callback::on_start_gametype(&start_gametype);
	clientfield::register("toplayer", "proximity_alarm", 1, 2, "int");
	clientfield::register("clientuimodel", "hudItems.proximityAlarm", 1, 2, "int");
	clientfield::register("missile", "retrievable", 1, 1, "int");
	clientfield::register("scriptmover", "retrievable", 1, 1, "int");
	clientfield::register("missile", "enemyequip", 1, 2, "int");
	clientfield::register("scriptmover", "enemyequip", 1, 2, "int");
	clientfield::register("missile", "teamequip", 1, 1, "int");
	level.weaponobjectdebug = getdvarint("scr_weaponobject_debug", 0);
	level.supplementalwatcherobjects = [];
	/#
		level thread updatedvars();
	#/
}

/*
	Name: updatedvars
	Namespace: weaponobjects
	Checksum: 0xC3469F96
	Offset: 0xD10
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function updatedvars()
{
	while(true)
	{
		level.weaponobjectdebug = getdvarint("scr_weaponobject_debug", 0);
		wait(1);
	}
}

/*
	Name: start_gametype
	Namespace: weaponobjects
	Checksum: 0xDEEF9EEF
	Offset: 0xD50
	Size: 0x25C
	Parameters: 0
	Flags: Linked
*/
function start_gametype()
{
	coneangle = getdvarint("scr_weaponobject_coneangle", 70);
	mindist = getdvarint("scr_weaponobject_mindist", 20);
	graceperiod = getdvarfloat("scr_weaponobject_graceperiod", 0.6);
	radius = getdvarint("scr_weaponobject_radius", 192);
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	level.watcherweapons = [];
	level.watcherweapons = getwatcherweapons();
	level.retrievableweapons = [];
	level.retrievableweapons = getretrievableweapons();
	level.weaponobjectexplodethisframe = 0;
	if(getdvarstring("scr_deleteexplosivesonspawn") == "")
	{
		setdvar("scr_deleteexplosivesonspawn", 1);
	}
	level.deleteexplosivesonspawn = getdvarint("scr_deleteexplosivesonspawn");
	level.claymorefxid = "_t6/weapon/claymore/fx_claymore_laser";
	level._equipment_spark_fx = "explosions/fx_exp_equipment_lg";
	level._equipment_fizzleout_fx = "explosions/fx_exp_equipment_lg";
	level._equipment_emp_destroy_fx = "killstreaks/fx_emp_explosion_equip";
	level._equipment_explode_fx = "_t6/explosions/fx_exp_equipment";
	level._equipment_explode_fx_lg = "explosions/fx_exp_equipment_lg";
	level._effect["powerLight"] = "weapon/fx_equip_light_os";
	setupretrievablehintstrings();
	level.weaponobjects_hacker_trigger_width = 32;
	level.weaponobjects_hacker_trigger_height = 32;
}

/*
	Name: setupretrievablehintstrings
	Namespace: weaponobjects
	Checksum: 0xC7729429
	Offset: 0xFB8
	Size: 0x244
	Parameters: 0
	Flags: Linked
*/
function setupretrievablehintstrings()
{
	createretrievablehint("hatchet", &"MP_HATCHET_PICKUP");
	createretrievablehint("claymore", &"MP_CLAYMORE_PICKUP");
	createretrievablehint("bouncingbetty", &"MP_BOUNCINGBETTY_PICKUP");
	createretrievablehint("trophy_system", &"MP_TROPHY_SYSTEM_PICKUP");
	createretrievablehint("acoustic_sensor", &"MP_ACOUSTIC_SENSOR_PICKUP");
	createretrievablehint("camera_spike", &"MP_CAMERA_SPIKE_PICKUP");
	createretrievablehint("satchel_charge", &"MP_SATCHEL_CHARGE_PICKUP");
	createretrievablehint("scrambler", &"MP_SCRAMBLER_PICKUP");
	createretrievablehint("proximity_grenade", &"MP_SHOCK_CHARGE_PICKUP");
	createdestroyhint("trophy_system", &"MP_TROPHY_SYSTEM_DESTROY");
	createdestroyhint("sensor_grenade", &"MP_SENSOR_GRENADE_DESTROY");
	createhackerhint("claymore", &"MP_CLAYMORE_HACKING");
	createhackerhint("bouncingbetty", &"MP_BOUNCINGBETTY_HACKING");
	createhackerhint("trophy_system", &"MP_TROPHY_SYSTEM_HACKING");
	createhackerhint("acoustic_sensor", &"MP_ACOUSTIC_SENSOR_HACKING");
	createhackerhint("camera_spike", &"MP_CAMERA_SPIKE_HACKING");
	createhackerhint("satchel_charge", &"MP_SATCHEL_CHARGE_HACKING");
	createhackerhint("scrambler", &"MP_SCRAMBLER_HACKING");
}

/*
	Name: on_player_connect
	Namespace: weaponobjects
	Checksum: 0x48BC741F
	Offset: 0x1208
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	if(isdefined(level._weaponobjects_on_player_connect_override))
	{
		level thread [[level._weaponobjects_on_player_connect_override]]();
		return;
	}
	self.usedweapons = 0;
	self.hits = 0;
}

/*
	Name: on_player_spawned
	Namespace: weaponobjects
	Checksum: 0xF39A0617
	Offset: 0x1248
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self endon(#"disconnect");
	pixbeginevent("onPlayerSpawned");
	if(!isdefined(self.watchersinitialized))
	{
		self createbasewatchers();
		self callback::callback_weapon_watcher();
		self createclaymorewatcher();
		self creatercbombwatcher();
		self createqrdronewatcher();
		self createplayerhelicopterwatcher();
		self createhatchetwatcher();
		self createspecialcrossbowwatcher();
		self createtactinsertwatcher();
		self hive_gun::createfireflypodwatcher();
		self setupretrievablewatcher();
		self thread watchweaponobjectusage();
		self.watchersinitialized = 1;
	}
	self resetwatchers();
	self trophy_system::ammo_reset();
	pixendevent();
}

/*
	Name: resetwatchers
	Namespace: weaponobjects
	Checksum: 0xF1A3AB03
	Offset: 0x13E8
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function resetwatchers()
{
	if(!isdefined(self.weaponobjectwatcherarray))
	{
		return undefined;
	}
	team = self.team;
	foreach(watcher in self.weaponobjectwatcherarray)
	{
		resetweaponobjectwatcher(watcher, team);
	}
}

/*
	Name: createbasewatchers
	Namespace: weaponobjects
	Checksum: 0xDBAB33AF
	Offset: 0x14A8
	Size: 0x11A
	Parameters: 0
	Flags: Linked
*/
function createbasewatchers()
{
	foreach(weapon in level.watcherweapons)
	{
		self createweaponobjectwatcher(weapon.name, self.team);
	}
	foreach(weapon in level.retrievableweapons)
	{
		self createweaponobjectwatcher(weapon.name, self.team);
	}
}

/*
	Name: setupretrievablewatcher
	Namespace: weaponobjects
	Checksum: 0x515730F8
	Offset: 0x15D0
	Size: 0xF2
	Parameters: 0
	Flags: Linked
*/
function setupretrievablewatcher()
{
	for(i = 0; i < level.retrievableweapons.size; i++)
	{
		watcher = getweaponobjectwatcherbyweapon(level.retrievableweapons[i]);
		if(isdefined(watcher))
		{
			if(!isdefined(watcher.onspawnretrievetriggers))
			{
				watcher.onspawnretrievetriggers = &onspawnretrievableweaponobject;
			}
			if(!isdefined(watcher.ondestroyed))
			{
				watcher.ondestroyed = &ondestroyed;
			}
			if(!isdefined(watcher.pickup))
			{
				watcher.pickup = &pickup;
			}
		}
	}
}

/*
	Name: createspecialcrossbowwatchertypes
	Namespace: weaponobjects
	Checksum: 0x5A03682
	Offset: 0x16D0
	Size: 0x118
	Parameters: 1
	Flags: Linked
*/
function createspecialcrossbowwatchertypes(weaponname)
{
	watcher = self createuseweaponobjectwatcher(weaponname, self.team);
	watcher.ondetonatecallback = &deleteent;
	watcher.ondamage = &voidondamage;
	if(isdefined(level.b_crossbow_bolt_destroy_on_impact) && level.b_crossbow_bolt_destroy_on_impact)
	{
		watcher.onspawn = &onspawncrossbowboltimpact;
		watcher.onspawnretrievetriggers = &voidonspawnretrievetriggers;
		watcher.pickup = &voidpickup;
	}
	else
	{
		watcher.onspawn = &onspawncrossbowbolt;
		watcher.onspawnretrievetriggers = &onspawnspecialcrossbowtrigger;
		watcher.pickup = &pickupcrossbowbolt;
	}
}

/*
	Name: createspecialcrossbowwatcher
	Namespace: weaponobjects
	Checksum: 0x357583BF
	Offset: 0x17F0
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function createspecialcrossbowwatcher()
{
	createspecialcrossbowwatchertypes("special_crossbow");
	createspecialcrossbowwatchertypes("special_crossbowlh");
	createspecialcrossbowwatchertypes("special_crossbow_dw");
	if(isdefined(level.b_create_upgraded_crossbow_watchers) && level.b_create_upgraded_crossbow_watchers)
	{
		createspecialcrossbowwatchertypes("special_crossbowlh_upgraded");
		createspecialcrossbowwatchertypes("special_crossbow_dw_upgraded");
	}
}

/*
	Name: createhatchetwatcher
	Namespace: weaponobjects
	Checksum: 0x370D4DB8
	Offset: 0x1890
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function createhatchetwatcher()
{
	watcher = self createuseweaponobjectwatcher("hatchet", self.team);
	watcher.ondetonatecallback = &deleteent;
	watcher.onspawn = &onspawnhatchet;
	watcher.ondamage = &voidondamage;
	watcher.onspawnretrievetriggers = &onspawnhatchettrigger;
}

/*
	Name: createtactinsertwatcher
	Namespace: weaponobjects
	Checksum: 0x6D17FB88
	Offset: 0x1930
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function createtactinsertwatcher()
{
	watcher = self createuseweaponobjectwatcher("tactical_insertion", self.team);
	watcher.playdestroyeddialog = 0;
}

/*
	Name: creatercbombwatcher
	Namespace: weaponobjects
	Checksum: 0x12C9DBB2
	Offset: 0x1980
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function creatercbombwatcher()
{
	watcher = self createuseweaponobjectwatcher("rcbomb", self.team);
	watcher.altdetonate = 0;
	watcher.headicon = 0;
	watcher.ismovable = 1;
	watcher.ownergetsassist = 1;
	watcher.playdestroyeddialog = 0;
	watcher.deleteonkillbrush = 0;
	watcher.ondetonatecallback = level.rcbombonblowup;
	watcher.stuntime = 1;
	watcher.notequipment = 1;
}

/*
	Name: createqrdronewatcher
	Namespace: weaponobjects
	Checksum: 0xD0B96BBF
	Offset: 0x1A68
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function createqrdronewatcher()
{
	watcher = self createuseweaponobjectwatcher("qrdrone", self.team);
	watcher.altdetonate = 0;
	watcher.headicon = 0;
	watcher.ismovable = 1;
	watcher.ownergetsassist = 1;
	watcher.playdestroyeddialog = 0;
	watcher.deleteonkillbrush = 0;
	watcher.ondetonatecallback = level.qrdroneonblowup;
	watcher.ondamage = level.qrdroneondamage;
	watcher.stuntime = 5;
	watcher.notequipment = 1;
}

/*
	Name: getspikelauncheractivespikecount
	Namespace: weaponobjects
	Checksum: 0x4E57AE7A
	Offset: 0x1B60
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function getspikelauncheractivespikecount(watcher)
{
	currentitemcount = 0;
	foreach(obj in watcher.objectarray)
	{
		if(isdefined(obj) && obj.item !== watcher.weapon)
		{
			currentitemcount++;
		}
	}
	return currentitemcount;
}

/*
	Name: watchspikelauncheritemcountchanged
	Namespace: weaponobjects
	Checksum: 0x41CDC0FC
	Offset: 0x1C30
	Size: 0xE8
	Parameters: 1
	Flags: Linked
*/
function watchspikelauncheritemcountchanged(watcher)
{
	self endon(#"death");
	lastitemcount = undefined;
	while(true)
	{
		self waittill(#"weapon_change", weapon);
		while(weapon.name == "spike_launcher")
		{
			currentitemcount = getspikelauncheractivespikecount(watcher);
			if(currentitemcount !== lastitemcount)
			{
				self setcontrolleruimodelvalue("spikeLauncherCounter.spikesReady", currentitemcount);
				lastitemcount = currentitemcount;
			}
			wait(0.1);
			weapon = self getcurrentweapon();
		}
	}
}

/*
	Name: spikesdetonating
	Namespace: weaponobjects
	Checksum: 0xAA9A0BE5
	Offset: 0x1D20
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function spikesdetonating(watcher)
{
	spikecount = getspikelauncheractivespikecount(watcher);
	if(spikecount > 0)
	{
		self setcontrolleruimodelvalue("spikeLauncherCounter.blasting", 1);
		wait(2);
		self setcontrolleruimodelvalue("spikeLauncherCounter.blasting", 0);
	}
}

/*
	Name: createspikelauncherwatcher
	Namespace: weaponobjects
	Checksum: 0x16A0479B
	Offset: 0x1DB0
	Size: 0x1A4
	Parameters: 1
	Flags: None
*/
function createspikelauncherwatcher(weapon)
{
	watcher = self createuseweaponobjectwatcher(weapon, self.team);
	watcher.altname = "spike_charge";
	watcher.altweapon = getweapon("spike_charge");
	watcher.altdetonate = 0;
	watcher.watchforfire = 1;
	watcher.hackable = 1;
	watcher.hackertoolradius = level.equipmenthackertoolradius;
	watcher.hackertooltimems = level.equipmenthackertooltimems;
	watcher.headicon = 0;
	watcher.ondetonatecallback = &spikedetonate;
	watcher.onstun = &weaponstun;
	watcher.stuntime = 1;
	watcher.ownergetsassist = 1;
	watcher.detonatestationary = 0;
	watcher.detonationdelay = 0;
	watcher.detonationsound = "wpn_claymore_alert";
	watcher.ondetonationhandle = &spikesdetonating;
	self thread watchspikelauncheritemcountchanged(watcher);
}

/*
	Name: createplayerhelicopterwatcher
	Namespace: weaponobjects
	Checksum: 0x9086791E
	Offset: 0x1F60
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function createplayerhelicopterwatcher()
{
	watcher = self createuseweaponobjectwatcher("helicopter_player", self.team);
	watcher.altdetonate = 1;
	watcher.headicon = 0;
	watcher.notequipment = 1;
}

/*
	Name: createclaymorewatcher
	Namespace: weaponobjects
	Checksum: 0x992402CA
	Offset: 0x1FD8
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function createclaymorewatcher()
{
	watcher = self createproximityweaponobjectwatcher("claymore", self.team);
	watcher.watchforfire = 1;
	watcher.ondetonatecallback = &claymoredetonate;
	watcher.activatesound = "wpn_claymore_alert";
	watcher.hackable = 1;
	watcher.hackertoolradius = level.equipmenthackertoolradius;
	watcher.hackertooltimems = level.equipmenthackertooltimems;
	watcher.ownergetsassist = 1;
	detectionconeangle = getdvarint("scr_weaponobject_coneangle");
	watcher.detectiondot = cos(detectionconeangle);
	watcher.detectionmindist = getdvarint("scr_weaponobject_mindist");
	watcher.detectiongraceperiod = getdvarfloat("scr_weaponobject_graceperiod");
	watcher.detonateradius = getdvarint("scr_weaponobject_radius");
	watcher.onstun = &weaponstun;
	watcher.stuntime = 1;
}

/*
	Name: voidonspawn
	Namespace: weaponobjects
	Checksum: 0xA524D68C
	Offset: 0x2198
	Size: 0x14
	Parameters: 2
	Flags: None
*/
function voidonspawn(unused0, unused1)
{
}

/*
	Name: voidondamage
	Namespace: weaponobjects
	Checksum: 0x19B3433
	Offset: 0x21B8
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function voidondamage(unused0)
{
}

/*
	Name: voidonspawnretrievetriggers
	Namespace: weaponobjects
	Checksum: 0x7B1CE4C3
	Offset: 0x21D0
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function voidonspawnretrievetriggers(unused0, unused1)
{
}

/*
	Name: voidpickup
	Namespace: weaponobjects
	Checksum: 0x34BFC36B
	Offset: 0x21F0
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function voidpickup(unused0, unused1)
{
}

/*
	Name: deleteent
	Namespace: weaponobjects
	Checksum: 0x9A595374
	Offset: 0x2210
	Size: 0x34
	Parameters: 3
	Flags: Linked
*/
function deleteent(attacker, emp, target)
{
	self delete();
}

/*
	Name: clearfxondeath
	Namespace: weaponobjects
	Checksum: 0xC1C380A3
	Offset: 0x2250
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function clearfxondeath(fx)
{
	fx endon(#"death");
	self util::waittill_any("death", "hacked");
	fx delete();
}

/*
	Name: deleteweaponobjectinstance
	Namespace: weaponobjects
	Checksum: 0x17E34678
	Offset: 0x22B0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function deleteweaponobjectinstance()
{
	if(!isdefined(self))
	{
		return;
	}
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
	Name: deleteweaponobjectarray
	Namespace: weaponobjects
	Checksum: 0xDFF5D9AB
	Offset: 0x2340
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function deleteweaponobjectarray()
{
	if(isdefined(self.objectarray))
	{
		foreach(weaponobject in self.objectarray)
		{
			weaponobject deleteweaponobjectinstance();
		}
	}
	self.objectarray = [];
}

/*
	Name: delayedspikedetonation
	Namespace: weaponobjects
	Checksum: 0xECAD4261
	Offset: 0x23F0
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function delayedspikedetonation(attacker, weapon)
{
	if(!isdefined(self.owner.spikedelay))
	{
		self.owner.spikedelay = 0;
	}
	delaytime = self.owner.spikedelay;
	owner = self.owner;
	self.owner.spikedelay = self.owner.spikedelay + 0.3;
	waittillframeend();
	wait(delaytime);
	owner.spikedelay = owner.spikedelay - 0.3;
	if(isdefined(self))
	{
		self weapondetonate(attacker, weapon);
	}
}

/*
	Name: spikedetonate
	Namespace: weaponobjects
	Checksum: 0x2FBE828
	Offset: 0x24F0
	Size: 0x7C
	Parameters: 3
	Flags: Linked
*/
function spikedetonate(attacker, weapon, target)
{
	if(isdefined(weapon) && weapon.isvalid)
	{
		if(isdefined(attacker))
		{
		}
	}
	thread delayedspikedetonation(attacker, weapon);
}

/*
	Name: claymoredetonate
	Namespace: weaponobjects
	Checksum: 0xCB87575E
	Offset: 0x2578
	Size: 0xC4
	Parameters: 3
	Flags: Linked
*/
function claymoredetonate(attacker, weapon, target)
{
	if(isdefined(attacker) && self.owner util::isenemyplayer(attacker))
	{
		attacker challenges::destroyedexplosive(weapon);
		scoreevents::processscoreevent("destroyed_claymore", attacker, self.owner, weapon);
	}
	weapondetonate(attacker, weapon);
}

/*
	Name: weapondetonate
	Namespace: weaponobjects
	Checksum: 0x160CD586
	Offset: 0x2648
	Size: 0x124
	Parameters: 2
	Flags: Linked
*/
function weapondetonate(attacker, weapon)
{
	if(isdefined(weapon) && weapon.isemp)
	{
		self delete();
		return;
	}
	if(isdefined(attacker))
	{
		if(isdefined(self.owner) && attacker != self.owner)
		{
			self.playdialog = 1;
		}
		if(isplayer(attacker))
		{
			self detonate(attacker);
		}
		else
		{
			self detonate();
		}
	}
	else
	{
		if(isdefined(self.owner) && isplayer(self.owner))
		{
			self.playdialog = 0;
			self detonate(self.owner);
		}
		else
		{
			self detonate();
		}
	}
}

/*
	Name: detonatewhenstationary
	Namespace: weaponobjects
	Checksum: 0x1657E892
	Offset: 0x2778
	Size: 0xA4
	Parameters: 4
	Flags: Linked
*/
function detonatewhenstationary(object, delay, attacker, weapon)
{
	level endon(#"game_ended");
	object endon(#"death");
	object endon(#"hacked");
	object endon(#"detonating");
	if(object isonground() == 0)
	{
		object waittill(#"stationary");
	}
	self thread waitanddetonate(object, delay, attacker, weapon);
}

/*
	Name: waitanddetonate
	Namespace: weaponobjects
	Checksum: 0x4D81C32D
	Offset: 0x2828
	Size: 0x398
	Parameters: 4
	Flags: Linked
*/
function waitanddetonate(object, delay, attacker, weapon)
{
	object endon(#"death");
	object endon(#"hacked");
	if(!isdefined(attacker) && !isdefined(weapon) && object.weapon.proximityalarmactivationdelay > 0)
	{
		if(isdefined(object.armed_detonation_wait) && object.armed_detonation_wait)
		{
			return;
		}
		object.armed_detonation_wait = 1;
		while(!(isdefined(object.proximity_deployed) && object.proximity_deployed))
		{
			wait(0.05);
		}
	}
	if(isdefined(object.detonated) && object.detonated)
	{
		return;
	}
	object.detonated = 1;
	object notify(#"detonating");
	isempdetonated = isdefined(weapon) && weapon.isemp;
	if(isempdetonated && object.weapon.doempdestroyfx)
	{
		object.stun_fx = 1;
		playfx(level._equipment_emp_destroy_fx, object.origin + vectorscale((0, 0, 1), 5), (0, randomfloat(360), 0));
		empfxdelay = 1.1;
	}
	if(!isdefined(self.ondetonatecallback))
	{
		return;
	}
	if(!isempdetonated && !isdefined(weapon))
	{
		if(isdefined(self.detonationdelay) && self.detonationdelay > 0)
		{
			if(isdefined(self.detonationsound))
			{
				object playsound(self.detonationsound);
			}
			delay = self.detonationdelay;
		}
	}
	else if(isdefined(empfxdelay))
	{
		delay = empfxdelay;
	}
	if(delay > 0)
	{
		wait(delay);
	}
	if(isdefined(attacker) && isplayer(attacker) && isdefined(attacker.pers["team"]) && isdefined(object.owner) && isdefined(object.owner.pers["team"]))
	{
		if(level.teambased)
		{
			if(attacker.pers["team"] != object.owner.pers["team"])
			{
				attacker notify(#"destroyed_explosive");
			}
		}
		else if(attacker != object.owner)
		{
			attacker notify(#"destroyed_explosive");
		}
	}
	object [[self.ondetonatecallback]](attacker, weapon, undefined);
}

/*
	Name: waitandfizzleout
	Namespace: weaponobjects
	Checksum: 0xF7C2224A
	Offset: 0x2BC8
	Size: 0xC8
	Parameters: 2
	Flags: Linked
*/
function waitandfizzleout(object, delay)
{
	object endon(#"death");
	object endon(#"hacked");
	if(isdefined(object.detonated) && object.detonated == 1)
	{
		return;
	}
	object.detonated = 1;
	object notify(#"fizzleout");
	if(delay > 0)
	{
		wait(delay);
	}
	if(!isdefined(self.onfizzleout))
	{
		self deleteent();
		return;
	}
	object [[self.onfizzleout]]();
}

/*
	Name: detonateweaponobjectarray
	Namespace: weaponobjects
	Checksum: 0xC5992079
	Offset: 0x2C98
	Size: 0x23C
	Parameters: 2
	Flags: Linked
*/
function detonateweaponobjectarray(forcedetonation, weapon)
{
	undetonated = [];
	if(isdefined(self.objectarray))
	{
		for(i = 0; i < self.objectarray.size; i++)
		{
			if(isdefined(self.objectarray[i]))
			{
				if(self.objectarray[i] isstunned() && forcedetonation == 0)
				{
					undetonated[undetonated.size] = self.objectarray[i];
					continue;
				}
				if(isdefined(weapon))
				{
					if(weapon util::ishacked() && weapon.name != self.objectarray[i].weapon.name)
					{
						undetonated[undetonated.size] = self.objectarray[i];
						continue;
					}
					else if(self.objectarray[i] util::ishacked() && weapon.name != self.objectarray[i].weapon.name)
					{
						undetonated[undetonated.size] = self.objectarray[i];
						continue;
					}
				}
				if(isdefined(self.detonatestationary) && self.detonatestationary && forcedetonation == 0)
				{
					self thread detonatewhenstationary(self.objectarray[i], 0, undefined, weapon);
					continue;
				}
				self thread waitanddetonate(self.objectarray[i], 0, undefined, weapon);
			}
		}
	}
	self.objectarray = undetonated;
}

/*
	Name: addweaponobjecttowatcher
	Namespace: weaponobjects
	Checksum: 0xADA34BBE
	Offset: 0x2EE0
	Size: 0x8C
	Parameters: 2
	Flags: None
*/
function addweaponobjecttowatcher(watchername, weapon_instance)
{
	watcher = getweaponobjectwatcher(watchername);
	/#
		assert(isdefined(watcher), ("" + watchername) + "");
	#/
	self addweaponobject(watcher, weapon_instance);
}

/*
	Name: addweaponobject
	Namespace: weaponobjects
	Checksum: 0x4D2EE354
	Offset: 0x2F78
	Size: 0x334
	Parameters: 3
	Flags: Linked
*/
function addweaponobject(watcher, weapon_instance, weapon)
{
	if(!isdefined(watcher.storedifferentobject))
	{
		watcher.objectarray[watcher.objectarray.size] = weapon_instance;
	}
	if(!isdefined(weapon))
	{
		weapon = watcher.weapon;
	}
	weapon_instance.owner = self;
	weapon_instance.detonated = 0;
	weapon_instance.weapon = weapon;
	if(isdefined(watcher.ondamage))
	{
		weapon_instance thread [[watcher.ondamage]](watcher);
	}
	else
	{
		weapon_instance thread weaponobjectdamage(watcher);
	}
	weapon_instance.ownergetsassist = watcher.ownergetsassist;
	weapon_instance.destroyedbyemp = watcher.destroyedbyemp;
	if(isdefined(watcher.onspawn))
	{
		weapon_instance thread [[watcher.onspawn]](watcher, self);
	}
	if(isdefined(watcher.onspawnfx))
	{
		weapon_instance thread [[watcher.onspawnfx]]();
	}
	weapon_instance thread setupreconeffect();
	if(isdefined(watcher.onspawnretrievetriggers))
	{
		weapon_instance thread [[watcher.onspawnretrievetriggers]](watcher, self);
	}
	if(watcher.hackable)
	{
		weapon_instance thread hackerinit(watcher);
	}
	if(watcher.playdestroyeddialog)
	{
		weapon_instance thread playdialogondeath(self);
		weapon_instance thread watchobjectdamage(self);
	}
	if(watcher.deleteonkillbrush)
	{
		if(isdefined(level.deleteonkillbrushoverride))
		{
			weapon_instance thread [[level.deleteonkillbrushoverride]](self, watcher);
		}
		else
		{
			weapon_instance thread deleteonkillbrush(self);
		}
	}
	if(weapon_instance useteamequipmentclientfield(watcher))
	{
		weapon_instance clientfield::set("teamequip", 1);
	}
	if(watcher.timeout)
	{
		weapon_instance thread weapon_object_timeout(watcher);
	}
	weapon_instance thread delete_on_notify(self);
	weapon_instance thread cleanupwatcherondeath(watcher);
}

/*
	Name: cleanupwatcherondeath
	Namespace: weaponobjects
	Checksum: 0xAC44725A
	Offset: 0x32B8
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function cleanupwatcherondeath(watcher)
{
	self waittill(#"death");
	if(isdefined(watcher) && isdefined(watcher.objectarray))
	{
		removeweaponobject(watcher, self);
	}
	if(isdefined(self) && self.delete_on_death === 1)
	{
		self deleteweaponobjectinstance();
	}
}

/*
	Name: weapon_object_timeout
	Namespace: weaponobjects
	Checksum: 0x5939E650
	Offset: 0x3340
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function weapon_object_timeout(watcher)
{
	self endon(#"death");
	wait(watcher.timeout);
	self deleteent();
}

/*
	Name: delete_on_notify
	Namespace: weaponobjects
	Checksum: 0x52B8BC2A
	Offset: 0x3388
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function delete_on_notify(e_player)
{
	e_player endon(#"disconnect");
	self endon(#"death");
	e_player waittill(#"delete_weapon_objects");
	self delete();
}

/*
	Name: deleteweaponobjecthelper
	Namespace: weaponobjects
	Checksum: 0x21AC3DA4
	Offset: 0x33D8
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function deleteweaponobjecthelper(weapon_ent)
{
	watcher = self getweaponobjectwatcherbyweapon(weapon_ent.weapon);
	if(!isdefined(watcher))
	{
		return;
	}
	removeweaponobject(watcher, weapon_ent);
}

/*
	Name: removeweaponobject
	Namespace: weaponobjects
	Checksum: 0xC6D68181
	Offset: 0x3440
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function removeweaponobject(watcher, weapon_ent)
{
	watcher.objectarray = array::remove_undefined(watcher.objectarray);
	arrayremovevalue(watcher.objectarray, weapon_ent);
}

/*
	Name: cleanweaponobjectarray
	Namespace: weaponobjects
	Checksum: 0x9E9C53A9
	Offset: 0x34B0
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function cleanweaponobjectarray(watcher)
{
	watcher.objectarray = array::remove_undefined(watcher.objectarray);
}

/*
	Name: weapon_object_do_damagefeedback
	Namespace: weaponobjects
	Checksum: 0x7F8B26E6
	Offset: 0x34F0
	Size: 0xEC
	Parameters: 2
	Flags: Linked
*/
function weapon_object_do_damagefeedback(weapon, attacker)
{
	if(isdefined(weapon) && isdefined(attacker))
	{
		if(weapon.dodamagefeedback)
		{
			if(level.teambased && self.owner.team != attacker.team)
			{
				if(damagefeedback::dodamagefeedback(weapon, attacker))
				{
					attacker damagefeedback::update();
				}
			}
			else if(!level.teambased && self.owner != attacker)
			{
				if(damagefeedback::dodamagefeedback(weapon, attacker))
				{
					attacker damagefeedback::update();
				}
			}
		}
	}
}

/*
	Name: weaponobjectdamage
	Namespace: weaponobjects
	Checksum: 0xDBC64138
	Offset: 0x35E8
	Size: 0x42C
	Parameters: 1
	Flags: Linked
*/
function weaponobjectdamage(watcher)
{
	self endon(#"death");
	self endon(#"hacked");
	self endon(#"detonating");
	self setcandamage(1);
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	self.damagetaken = 0;
	attacker = undefined;
	while(true)
	{
		self waittill(#"damage", damage, attacker, direction_vec, point, type, modelname, tagname, partname, weapon, idflags);
		self.damagetaken = self.damagetaken + damage;
		if(!isplayer(attacker) && isdefined(attacker.owner))
		{
			attacker = attacker.owner;
		}
		if(isdefined(weapon))
		{
			self weapon_object_do_damagefeedback(weapon, attacker);
			if(watcher.stuntime > 0 && weapon.dostun)
			{
				self thread stunstart(watcher, watcher.stuntime);
				continue;
			}
		}
		if(level.teambased && isplayer(attacker) && isdefined(self.owner))
		{
			if(!level.hardcoremode && self.owner.team == attacker.pers["team"] && self.owner != attacker)
			{
				continue;
			}
		}
		if(isdefined(watcher.shoulddamage) && !self [[watcher.shoulddamage]](watcher, attacker, weapon, damage))
		{
			continue;
		}
		if(!isvehicle(self) && !friendlyfirecheck(self.owner, attacker))
		{
			continue;
		}
		break;
	}
	if(level.weaponobjectexplodethisframe)
	{
		wait(0.1 + randomfloat(0.4));
	}
	else
	{
		wait(0.05);
	}
	if(!isdefined(self))
	{
		return;
	}
	level.weaponobjectexplodethisframe = 1;
	thread resetweaponobjectexplodethisframe();
	self entityheadicons::setentityheadicon("none");
	if(isdefined(type) && (issubstr(type, "MOD_GRENADE_SPLASH") || issubstr(type, "MOD_GRENADE") || issubstr(type, "MOD_EXPLOSIVE")))
	{
		self.waschained = 1;
	}
	if(isdefined(idflags) && idflags & 8)
	{
		self.wasdamagedfrombulletpenetration = 1;
	}
	self.wasdamaged = 1;
	watcher thread waitanddetonate(self, 0, attacker, weapon);
}

/*
	Name: playdialogondeath
	Namespace: weaponobjects
	Checksum: 0x4DB3CF1C
	Offset: 0x3A20
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function playdialogondeath(owner)
{
	owner endon(#"death");
	owner endon(#"disconnect");
	self endon(#"hacked");
	self waittill(#"death");
	if(isdefined(self.playdialog) && self.playdialog)
	{
		if(isdefined(level.playequipmentdestroyedonplayer))
		{
			owner [[level.playequipmentdestroyedonplayer]]();
		}
	}
}

/*
	Name: watchobjectdamage
	Namespace: weaponobjects
	Checksum: 0x32130B58
	Offset: 0x3AA0
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function watchobjectdamage(owner)
{
	owner endon(#"death");
	owner endon(#"disconnect");
	self endon(#"hacked");
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage", damage, attacker);
		if(isdefined(attacker) && isplayer(attacker) && attacker != owner)
		{
			self.playdialog = 1;
		}
		else
		{
			self.playdialog = 0;
		}
	}
}

/*
	Name: stunstart
	Namespace: weaponobjects
	Checksum: 0xD6C5131C
	Offset: 0x3B68
	Size: 0x10C
	Parameters: 2
	Flags: Linked
*/
function stunstart(watcher, time)
{
	self endon(#"death");
	if(self isstunned())
	{
		return;
	}
	if(isdefined(watcher.onstun))
	{
		self thread [[watcher.onstun]]();
	}
	if(watcher.name == "rcbomb")
	{
		self.owner util::freeze_player_controls(1);
	}
	if(isdefined(time))
	{
		wait(time);
	}
	else
	{
		return;
	}
	if(watcher.name == "rcbomb")
	{
		self.owner util::freeze_player_controls(0);
	}
	self stunstop();
}

/*
	Name: stunstop
	Namespace: weaponobjects
	Checksum: 0x529CEAA0
	Offset: 0x3C80
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function stunstop()
{
	self notify(#"not_stunned");
}

/*
	Name: weaponstun
	Namespace: weaponobjects
	Checksum: 0xFFA07B51
	Offset: 0x3CA8
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function weaponstun()
{
	self endon(#"death");
	self endon(#"not_stunned");
	origin = self gettagorigin("tag_fx");
	if(!isdefined(origin))
	{
		origin = self.origin + vectorscale((0, 0, 1), 10);
	}
	self.stun_fx = spawn("script_model", origin);
	self.stun_fx setmodel("tag_origin");
	self thread stunfxthink(self.stun_fx);
	wait(0.1);
	playfxontag(level._equipment_spark_fx, self.stun_fx, "tag_origin");
}

/*
	Name: stunfxthink
	Namespace: weaponobjects
	Checksum: 0x4AEB7DC2
	Offset: 0x3DB0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function stunfxthink(fx)
{
	fx endon(#"death");
	self util::waittill_any("death", "not_stunned");
	fx delete();
}

/*
	Name: isstunned
	Namespace: weaponobjects
	Checksum: 0xE4FA26A
	Offset: 0x3E10
	Size: 0xC
	Parameters: 0
	Flags: Linked
*/
function isstunned()
{
	return isdefined(self.stun_fx);
}

/*
	Name: weaponobjectfizzleout
	Namespace: weaponobjects
	Checksum: 0xABD20804
	Offset: 0x3E28
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function weaponobjectfizzleout()
{
	self endon(#"death");
	playfx(level._equipment_fizzleout_fx, self.origin);
	deleteent();
}

/*
	Name: resetweaponobjectexplodethisframe
	Namespace: weaponobjects
	Checksum: 0x1AE0EB89
	Offset: 0x3E70
	Size: 0x18
	Parameters: 0
	Flags: Linked
*/
function resetweaponobjectexplodethisframe()
{
	wait(0.05);
	level.weaponobjectexplodethisframe = 0;
}

/*
	Name: getweaponobjectwatcher
	Namespace: weaponobjects
	Checksum: 0x5EB43710
	Offset: 0x3E90
	Size: 0xB6
	Parameters: 1
	Flags: Linked
*/
function getweaponobjectwatcher(name)
{
	if(!isdefined(self.weaponobjectwatcherarray))
	{
		return undefined;
	}
	for(watcher = 0; watcher < self.weaponobjectwatcherarray.size; watcher++)
	{
		if(self.weaponobjectwatcherarray[watcher].name == name || (isdefined(self.weaponobjectwatcherarray[watcher].altname) && self.weaponobjectwatcherarray[watcher].altname == name))
		{
			return self.weaponobjectwatcherarray[watcher];
		}
	}
	return undefined;
}

/*
	Name: getweaponobjectwatcherbyweapon
	Namespace: weaponobjects
	Checksum: 0xAD5B758B
	Offset: 0x3F50
	Size: 0x136
	Parameters: 1
	Flags: Linked
*/
function getweaponobjectwatcherbyweapon(weapon)
{
	if(!isdefined(self.weaponobjectwatcherarray))
	{
		return undefined;
	}
	if(!isdefined(weapon))
	{
		return undefined;
	}
	for(watcher = 0; watcher < self.weaponobjectwatcherarray.size; watcher++)
	{
		if(isdefined(self.weaponobjectwatcherarray[watcher].weapon) && (self.weaponobjectwatcherarray[watcher].weapon == weapon || self.weaponobjectwatcherarray[watcher].weapon == weapon.rootweapon))
		{
			return self.weaponobjectwatcherarray[watcher];
		}
		if(isdefined(self.weaponobjectwatcherarray[watcher].weapon) && isdefined(self.weaponobjectwatcherarray[watcher].altweapon) && self.weaponobjectwatcherarray[watcher].altweapon == weapon)
		{
			return self.weaponobjectwatcherarray[watcher];
		}
	}
	return undefined;
}

/*
	Name: resetweaponobjectwatcher
	Namespace: weaponobjects
	Checksum: 0xBDE01247
	Offset: 0x4090
	Size: 0x90
	Parameters: 2
	Flags: Linked
*/
function resetweaponobjectwatcher(watcher, ownerteam)
{
	if(watcher.deleteonplayerspawn == 1 || (isdefined(watcher.ownerteam) && watcher.ownerteam != ownerteam))
	{
		self notify(#"weapon_object_destroyed");
		watcher deleteweaponobjectarray();
	}
	watcher.ownerteam = ownerteam;
}

/*
	Name: createweaponobjectwatcher
	Namespace: weaponobjects
	Checksum: 0x30C9CC52
	Offset: 0x4128
	Size: 0x398
	Parameters: 2
	Flags: Linked
*/
function createweaponobjectwatcher(weaponname, ownerteam)
{
	if(!isdefined(self.weaponobjectwatcherarray))
	{
		self.weaponobjectwatcherarray = [];
	}
	weaponobjectwatcher = getweaponobjectwatcher(weaponname);
	if(!isdefined(weaponobjectwatcher))
	{
		weaponobjectwatcher = spawnstruct();
		self.weaponobjectwatcherarray[self.weaponobjectwatcherarray.size] = weaponobjectwatcher;
		weaponobjectwatcher.name = weaponname;
		weaponobjectwatcher.type = "use";
		weaponobjectwatcher.weapon = getweapon(weaponname);
		weaponobjectwatcher.watchforfire = 0;
		weaponobjectwatcher.hackable = 0;
		weaponobjectwatcher.altdetonate = 0;
		weaponobjectwatcher.detectable = 1;
		weaponobjectwatcher.headicon = 0;
		weaponobjectwatcher.stuntime = 0;
		weaponobjectwatcher.timeout = 0;
		weaponobjectwatcher.destroyedbyemp = 1;
		weaponobjectwatcher.activatesound = undefined;
		weaponobjectwatcher.ignoredirection = undefined;
		weaponobjectwatcher.immediatedetonation = undefined;
		weaponobjectwatcher.deploysound = weaponobjectwatcher.weapon.firesound;
		weaponobjectwatcher.deploysoundplayer = weaponobjectwatcher.weapon.firesoundplayer;
		weaponobjectwatcher.pickupsound = weaponobjectwatcher.weapon.pickupsound;
		weaponobjectwatcher.pickupsoundplayer = weaponobjectwatcher.weapon.pickupsoundplayer;
		weaponobjectwatcher.altweapon = weaponobjectwatcher.weapon.altweapon;
		weaponobjectwatcher.ownergetsassist = 0;
		weaponobjectwatcher.playdestroyeddialog = 1;
		weaponobjectwatcher.deleteonkillbrush = 1;
		weaponobjectwatcher.deleteondifferentobjectspawn = 1;
		weaponobjectwatcher.enemydestroy = 0;
		weaponobjectwatcher.deleteonplayerspawn = level.deleteexplosivesonspawn;
		weaponobjectwatcher.ignorevehicles = 0;
		weaponobjectwatcher.ignoreai = 0;
		weaponobjectwatcher.activationdelay = 0;
		weaponobjectwatcher.onspawn = undefined;
		weaponobjectwatcher.onspawnfx = undefined;
		weaponobjectwatcher.onspawnretrievetriggers = undefined;
		weaponobjectwatcher.ondetonatecallback = undefined;
		weaponobjectwatcher.onstun = undefined;
		weaponobjectwatcher.onstunfinished = undefined;
		weaponobjectwatcher.ondestroyed = undefined;
		weaponobjectwatcher.onfizzleout = &weaponobjectfizzleout;
		weaponobjectwatcher.shoulddamage = undefined;
		weaponobjectwatcher.onsupplementaldetonatecallback = undefined;
		if(!isdefined(weaponobjectwatcher.objectarray))
		{
			weaponobjectwatcher.objectarray = [];
		}
	}
	resetweaponobjectwatcher(weaponobjectwatcher, ownerteam);
	return weaponobjectwatcher;
}

/*
	Name: createuseweaponobjectwatcher
	Namespace: weaponobjects
	Checksum: 0x919BFA09
	Offset: 0x44C8
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function createuseweaponobjectwatcher(weaponname, ownerteam)
{
	weaponobjectwatcher = createweaponobjectwatcher(weaponname, ownerteam);
	weaponobjectwatcher.type = "use";
	weaponobjectwatcher.onspawn = &onspawnuseweaponobject;
	return weaponobjectwatcher;
}

/*
	Name: createproximityweaponobjectwatcher
	Namespace: weaponobjects
	Checksum: 0x4CDF0E6E
	Offset: 0x4540
	Size: 0x12C
	Parameters: 2
	Flags: Linked
*/
function createproximityweaponobjectwatcher(weaponname, ownerteam)
{
	weaponobjectwatcher = createweaponobjectwatcher(weaponname, ownerteam);
	weaponobjectwatcher.type = "proximity";
	weaponobjectwatcher.onspawn = &onspawnproximityweaponobject;
	detectionconeangle = getdvarint("scr_weaponobject_coneangle");
	weaponobjectwatcher.detectiondot = cos(detectionconeangle);
	weaponobjectwatcher.detectionmindist = getdvarint("scr_weaponobject_mindist");
	weaponobjectwatcher.detectiongraceperiod = getdvarfloat("scr_weaponobject_graceperiod");
	weaponobjectwatcher.detonateradius = getdvarint("scr_weaponobject_radius");
	return weaponobjectwatcher;
}

/*
	Name: commononspawnuseweaponobject
	Namespace: weaponobjects
	Checksum: 0x43D14E9F
	Offset: 0x4678
	Size: 0x23C
	Parameters: 2
	Flags: Linked
*/
function commononspawnuseweaponobject(watcher, owner)
{
	level endon(#"game_ended");
	self endon(#"death");
	self endon(#"hacked");
	if(watcher.detectable)
	{
		if(watcher.headicon && level.teambased)
		{
			self util::waittillnotmoving();
			if(isdefined(self))
			{
				offset = self.weapon.weaponheadobjectiveheight;
				v_up = anglestoup(self.angles);
				x_offset = abs(v_up[0]);
				y_offset = abs(v_up[1]);
				z_offset = abs(v_up[2]);
				if(x_offset > y_offset && x_offset > z_offset)
				{
				}
				else
				{
					if(y_offset > x_offset && y_offset > z_offset)
					{
					}
					else if(z_offset > x_offset && z_offset > y_offset)
					{
						v_up = v_up * (0, 0, 1);
					}
				}
				up_offset_modified = v_up * offset;
				up_offset = anglestoup(self.angles) * offset;
				objective = getequipmentheadobjective(self.weapon);
				self entityheadicons::setentityheadicon(owner.pers["team"], owner, up_offset, objective);
			}
		}
	}
}

/*
	Name: wasproximityalarmactivatedbyself
	Namespace: weaponobjects
	Checksum: 0xFEDE9AD4
	Offset: 0x48C0
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function wasproximityalarmactivatedbyself()
{
	return isdefined(self.owner.proximityamlarment) && self.owner.proximityamlarment == self;
}

/*
	Name: proximityalarmactivate
	Namespace: weaponobjects
	Checksum: 0x39972161
	Offset: 0x48F8
	Size: 0x15C
	Parameters: 2
	Flags: Linked
*/
function proximityalarmactivate(active, watcher)
{
	if(!isdefined(self.owner) || !isplayer(self.owner))
	{
		return;
	}
	if(active && !isdefined(self.owner.proximityamlarment))
	{
		self.owner.proximityamlarment = self;
		self.owner clientfield::set_to_player("proximity_alarm", 2);
		self.owner clientfield::set_player_uimodel("hudItems.proximityAlarm", 2);
	}
	else if(!isdefined(self) || self wasproximityalarmactivatedbyself() || self.owner clientfield::get_to_player("proximity_alarm") == 1)
	{
		self.owner.proximityamlarment = undefined;
		self.owner clientfield::set_to_player("proximity_alarm", 0);
		self.owner clientfield::set_player_uimodel("hudItems.proximityAlarm", 0);
	}
}

/*
	Name: proximityalarmloop
	Namespace: weaponobjects
	Checksum: 0xF08BFA33
	Offset: 0x4A60
	Size: 0x696
	Parameters: 2
	Flags: Linked
*/
function proximityalarmloop(watcher, owner)
{
	level endon(#"game_ended");
	self endon(#"death");
	self endon(#"hacked");
	self endon(#"detonating");
	if(self.weapon.proximityalarminnerradius <= 0)
	{
		return;
	}
	self util::waittillnotmoving();
	delaytimesec = self.weapon.proximityalarmactivationdelay / 1000;
	if(delaytimesec > 0)
	{
		wait(delaytimesec);
		if(!isdefined(self))
		{
			return;
		}
	}
	if(!(isdefined(self.owner._disable_proximity_alarms) && self.owner._disable_proximity_alarms))
	{
		self.owner clientfield::set_to_player("proximity_alarm", 1);
		self.owner clientfield::set_player_uimodel("hudItems.proximityAlarm", 1);
	}
	self.proximity_deployed = 1;
	alarmstatusold = "notify";
	alarmstatus = "off";
	while(true)
	{
		wait(0.05);
		if(!isdefined(self.owner) || !isplayer(self.owner))
		{
			return;
		}
		if(isalive(self.owner) == 0 && self.owner util::isusingremote() == 0)
		{
			self proximityalarmactivate(0, watcher);
			return;
		}
		if(isdefined(self.owner._disable_proximity_alarms) && self.owner._disable_proximity_alarms)
		{
			self proximityalarmactivate(0, watcher);
		}
		else if(alarmstatus != alarmstatusold || (alarmstatus == "on" && !isdefined(self.owner.proximityamlarment)))
		{
			if(alarmstatus == "on")
			{
				if(alarmstatusold == "off" && isdefined(watcher) && isdefined(watcher.proximityalarmactivatesound))
				{
					playsoundatposition(watcher.proximityalarmactivatesound, self.origin + vectorscale((0, 0, 1), 32));
				}
				self proximityalarmactivate(1, watcher);
			}
			else
			{
				self proximityalarmactivate(0, watcher);
			}
			alarmstatusold = alarmstatus;
		}
		alarmstatus = "off";
		actors = getactorarray();
		players = getplayers();
		detectentities = arraycombine(players, actors, 0, 0);
		foreach(entity in detectentities)
		{
			wait(0.05);
			if(!isdefined(entity))
			{
				continue;
			}
			owner = entity;
			if(isactor(entity) && (!isdefined(entity.isaiclone) || !entity.isaiclone))
			{
				continue;
			}
			else if(isactor(entity))
			{
				owner = entity.owner;
			}
			if(entity.team == "spectator")
			{
				continue;
			}
			if(level.weaponobjectdebug != 1)
			{
				if(owner hasperk("specialty_detectexplosive"))
				{
					continue;
				}
				if(isdefined(self.owner) && owner == self.owner)
				{
					continue;
				}
				if(!friendlyfirecheck(self.owner, owner, 0))
				{
					continue;
				}
			}
			if(self isstunned())
			{
				continue;
			}
			if(!isalive(entity))
			{
				continue;
			}
			if(isdefined(watcher.immunespecialty) && owner hasperk(watcher.immunespecialty))
			{
				continue;
			}
			radius = self.weapon.proximityalarmouterradius;
			distancesqr = distancesquared(self.origin, entity.origin);
			if((radius * radius) < distancesqr)
			{
				continue;
			}
			if(entity damageconetrace(self.origin, self) == 0)
			{
				continue;
			}
			if(alarmstatusold == "on")
			{
				alarmstatus = "on";
				break;
			}
			radius = self.weapon.proximityalarminnerradius;
			if((radius * radius) < distancesqr)
			{
				continue;
			}
			alarmstatus = "on";
			break;
		}
	}
}

/*
	Name: commononspawnuseweaponobjectproximityalarm
	Namespace: weaponobjects
	Checksum: 0x6ED92634
	Offset: 0x5100
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function commononspawnuseweaponobjectproximityalarm(watcher, owner)
{
	/#
		if(level.weaponobjectdebug == 1)
		{
			self thread proximityalarmweaponobjectdebug(watcher);
		}
	#/
	self proximityalarmloop(watcher, owner);
	self proximityalarmactivate(0, watcher);
}

/*
	Name: onspawnuseweaponobject
	Namespace: weaponobjects
	Checksum: 0x331DD17A
	Offset: 0x5188
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function onspawnuseweaponobject(watcher, owner)
{
	self thread commononspawnuseweaponobject(watcher, owner);
	self thread commononspawnuseweaponobjectproximityalarm(watcher, owner);
}

/*
	Name: onspawnproximityweaponobject
	Namespace: weaponobjects
	Checksum: 0x82672BCF
	Offset: 0x51E8
	Size: 0xAC
	Parameters: 2
	Flags: Linked
*/
function onspawnproximityweaponobject(watcher, owner)
{
	self.protected_entities = [];
	self thread commononspawnuseweaponobject(watcher, owner);
	if(isdefined(level._proximityweaponobjectdetonation_override))
	{
		self thread [[level._proximityweaponobjectdetonation_override]](watcher);
	}
	else
	{
		self thread proximityweaponobjectdetonation(watcher);
	}
	/#
		if(level.weaponobjectdebug == 1)
		{
			self thread proximityweaponobjectdebug(watcher);
		}
	#/
}

/*
	Name: watchweaponobjectusage
	Namespace: weaponobjects
	Checksum: 0xC401BCFD
	Offset: 0x52A0
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function watchweaponobjectusage()
{
	self endon(#"disconnect");
	if(!isdefined(self.weaponobjectwatcherarray))
	{
		self.weaponobjectwatcherarray = [];
	}
	self thread watchweaponobjectspawn("grenade_fire");
	self thread watchweaponobjectspawn("grenade_launcher_fire");
	self thread watchweaponobjectspawn("missile_fire");
	self thread watchweaponobjectdetonation();
	self thread watchweaponobjectaltdetonation();
	self thread watchweaponobjectaltdetonate();
	self thread deleteweaponobjectson();
}

/*
	Name: watchweaponobjectspawn
	Namespace: weaponobjects
	Checksum: 0x606225FE
	Offset: 0x5390
	Size: 0x200
	Parameters: 1
	Flags: Linked
*/
function watchweaponobjectspawn(notify_type)
{
	self notify("watchWeaponObjectSpawn_" + notify_type);
	self endon("watchWeaponObjectSpawn_" + notify_type);
	self endon(#"disconnect");
	while(true)
	{
		self waittill(notify_type, weapon_instance, weapon);
		if(sessionmodeiscampaignzombiesgame() || (isdefined(level.projectiles_should_ignore_world_pause) && level.projectiles_should_ignore_world_pause) && isdefined(weapon_instance))
		{
			weapon_instance setignorepauseworld(1);
		}
		if(weapon.setusedstat && !self util::ishacked())
		{
			self addweaponstat(weapon, "used", 1);
		}
		watcher = getweaponobjectwatcherbyweapon(weapon);
		if(isdefined(watcher))
		{
			cleanweaponobjectarray(watcher);
			if(weapon.maxinstancesallowed)
			{
				if(watcher.objectarray.size > (weapon.maxinstancesallowed - 1))
				{
					watcher thread waitandfizzleout(watcher.objectarray[0], 0.1);
					watcher.objectarray[0] = undefined;
					cleanweaponobjectarray(watcher);
				}
			}
			self addweaponobject(watcher, weapon_instance);
		}
	}
}

/*
	Name: anyobjectsinworld
	Namespace: weaponobjects
	Checksum: 0x8DD940B4
	Offset: 0x5598
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function anyobjectsinworld(weapon)
{
	objectsinworld = 0;
	for(i = 0; i < self.weaponobjectwatcherarray.size; i++)
	{
		if(self.weaponobjectwatcherarray[i].weapon != weapon)
		{
			continue;
		}
		if(isdefined(self.weaponobjectwatcherarray[i].ondetonatecallback) && self.weaponobjectwatcherarray[i].objectarray.size > 0)
		{
			objectsinworld = 1;
			break;
		}
	}
	return objectsinworld;
}

/*
	Name: proximitysphere
	Namespace: weaponobjects
	Checksum: 0xB3372E19
	Offset: 0x5660
	Size: 0xB0
	Parameters: 5
	Flags: Linked
*/
function proximitysphere(origin, innerradius, incolor, outerradius, outcolor)
{
	/#
		self endon(#"death");
		while(true)
		{
			if(isdefined(innerradius))
			{
				dev::debug_sphere(origin, innerradius, incolor, 0.25, 1);
			}
			if(isdefined(outerradius))
			{
				dev::debug_sphere(origin, outerradius, outcolor, 0.25, 1);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: proximityalarmweaponobjectdebug
	Namespace: weaponobjects
	Checksum: 0x60D4C255
	Offset: 0x5718
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function proximityalarmweaponobjectdebug(watcher)
{
	/#
		self endon(#"death");
		self util::waittillnotmoving();
		if(!isdefined(self))
		{
			return;
		}
		self thread proximitysphere(self.origin, self.weapon.proximityalarminnerradius, vectorscale((0, 1, 0), 0.75), self.weapon.proximityalarmouterradius, vectorscale((0, 1, 0), 0.75));
	#/
}

/*
	Name: proximityweaponobjectdebug
	Namespace: weaponobjects
	Checksum: 0x5897BAAC
	Offset: 0x57B0
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function proximityweaponobjectdebug(watcher)
{
	/#
		self endon(#"death");
		self util::waittillnotmoving();
		if(!isdefined(self))
		{
			return;
		}
		if(isdefined(watcher.ignoredirection))
		{
			self thread proximitysphere(self.origin, watcher.detonateradius, (1, 0.85, 0), self.weapon.explosionradius, (1, 0, 0));
		}
		else
		{
			self thread showcone(acos(watcher.detectiondot), watcher.detonateradius, (1, 0.85, 0));
			self thread showcone(60, 256, (1, 0, 0));
		}
	#/
}

/*
	Name: showcone
	Namespace: weaponobjects
	Checksum: 0x8456960E
	Offset: 0x58C0
	Size: 0x22C
	Parameters: 3
	Flags: Linked
*/
function showcone(angle, range, color)
{
	/#
		self endon(#"death");
		start = self.origin;
		forward = anglestoforward(self.angles);
		right = vectorcross(forward, (0, 0, 1));
		up = vectorcross(forward, right);
		fullforward = (forward * range) * cos(angle);
		sideamnt = range * sin(angle);
		while(true)
		{
			prevpoint = (0, 0, 0);
			for(i = 0; i <= 20; i++)
			{
				coneangle = (i / 20) * 360;
				point = (start + fullforward) + (sideamnt * (right * cos(coneangle)) + (up * sin(coneangle)));
				if(i > 0)
				{
					line(start, point, color);
					line(prevpoint, point, color);
				}
				prevpoint = point;
			}
			wait(0.05);
		}
	#/
}

/*
	Name: weaponobjectdetectionmovable
	Namespace: weaponobjects
	Checksum: 0xBE03BCBF
	Offset: 0x5AF8
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function weaponobjectdetectionmovable(ownerteam)
{
	self endon(#"end_detection");
	level endon(#"game_ended");
	self endon(#"death");
	self endon(#"hacked");
	if(!level.teambased)
	{
		return;
	}
	self.detectid = ("rcBomb" + gettime()) + randomint(1000000);
}

/*
	Name: seticonpos
	Namespace: weaponobjects
	Checksum: 0x48ED7D4F
	Offset: 0x5B78
	Size: 0x88
	Parameters: 3
	Flags: None
*/
function seticonpos(item, icon, heightincrease)
{
	icon.x = item.origin[0];
	icon.y = item.origin[1];
	icon.z = item.origin[2] + heightincrease;
}

/*
	Name: weaponobjectdetectiontrigger_wait
	Namespace: weaponobjects
	Checksum: 0xA7C358E
	Offset: 0x5C08
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function weaponobjectdetectiontrigger_wait(ownerteam)
{
	self endon(#"death");
	self endon(#"hacked");
	self endon(#"detonating");
	util::waittillnotmoving();
	self thread weaponobjectdetectiontrigger(ownerteam);
}

/*
	Name: weaponobjectdetectiontrigger
	Namespace: weaponobjects
	Checksum: 0x5EBCCCB4
	Offset: 0x5C70
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function weaponobjectdetectiontrigger(ownerteam)
{
	trigger = spawn("trigger_radius", self.origin - vectorscale((0, 0, 1), 128), 0, 512, 256);
	trigger.detectid = ("trigger" + gettime()) + randomint(1000000);
	trigger sethintlowpriority(1);
	self util::waittill_any("death", "hacked", "detonating");
	trigger notify(#"end_detection");
	if(isdefined(trigger.bombsquadicon))
	{
		trigger.bombsquadicon destroy();
	}
	trigger delete();
}

/*
	Name: hackertriggersetvisibility
	Namespace: weaponobjects
	Checksum: 0x955B1FF5
	Offset: 0x5DA0
	Size: 0x130
	Parameters: 1
	Flags: Linked
*/
function hackertriggersetvisibility(owner)
{
	self endon(#"death");
	/#
		assert(isplayer(owner));
	#/
	ownerteam = owner.pers["team"];
	for(;;)
	{
		if(level.teambased && isdefined(ownerteam))
		{
			self setvisibletoallexceptteam(ownerteam);
			self setexcludeteamfortrigger(ownerteam);
		}
		else
		{
			self setvisibletoall();
			self setteamfortrigger("none");
		}
		if(isdefined(owner))
		{
			self setinvisibletoplayer(owner);
		}
		level util::waittill_any("player_spawned", "joined_team");
	}
}

/*
	Name: hackernotmoving
	Namespace: weaponobjects
	Checksum: 0x3E4AA773
	Offset: 0x5ED8
	Size: 0x32
	Parameters: 0
	Flags: Linked
*/
function hackernotmoving()
{
	self endon(#"death");
	self util::waittillnotmoving();
	self notify(#"landed");
}

/*
	Name: hackerinit
	Namespace: weaponobjects
	Checksum: 0x6C253D37
	Offset: 0x5F18
	Size: 0x264
	Parameters: 1
	Flags: Linked
*/
function hackerinit(watcher)
{
	self thread hackernotmoving();
	event = self util::waittill_any_return("death", "landed");
	if(event == "death")
	{
		return;
	}
	triggerorigin = self.origin;
	if("" != self.weapon.hackertriggerorigintag)
	{
		triggerorigin = self gettagorigin(self.weapon.hackertriggerorigintag);
	}
	self.hackertrigger = spawn("trigger_radius_use", triggerorigin, level.weaponobjects_hacker_trigger_width, level.weaponobjects_hacker_trigger_height);
	/#
	#/
	self.hackertrigger sethintlowpriority(1);
	self.hackertrigger setcursorhint("HINT_NOICON", self);
	self.hackertrigger setignoreentfortrigger(self);
	self.hackertrigger enablelinkto();
	self.hackertrigger linkto(self);
	if(isdefined(level.hackerhints[self.weapon.name]))
	{
		self.hackertrigger sethintstring(level.hackerhints[self.weapon.name].hint);
	}
	else
	{
		self.hackertrigger sethintstring(&"MP_GENERIC_HACKING");
	}
	self.hackertrigger setperkfortrigger("specialty_disarmexplosive");
	self.hackertrigger thread hackertriggersetvisibility(self.owner);
	self thread hackerthink(self.hackertrigger, watcher);
}

/*
	Name: hackerthink
	Namespace: weaponobjects
	Checksum: 0x4ACC328D
	Offset: 0x6188
	Size: 0xA2
	Parameters: 2
	Flags: Linked
*/
function hackerthink(trigger, watcher)
{
	self endon(#"death");
	for(;;)
	{
		trigger waittill(#"trigger", player, instant);
		if(!isdefined(instant) && !trigger hackerresult(player, self.owner))
		{
			continue;
		}
		self itemhacked(watcher, player);
		return;
	}
}

/*
	Name: itemhacked
	Namespace: weaponobjects
	Checksum: 0x1D78C87B
	Offset: 0x6238
	Size: 0x354
	Parameters: 2
	Flags: Linked
*/
function itemhacked(watcher, player)
{
	self proximityalarmactivate(0, watcher);
	self.owner hackerremoveweapon(self);
	if(isdefined(level.playequipmenthackedonplayer))
	{
		self.owner [[level.playequipmenthackedonplayer]]();
	}
	if(self.weapon.ammocountequipment > 0 && isdefined(self.ammo))
	{
		ammoleftequipment = self.ammo;
		if(self.weapon.rootweapon == getweapon("trophy_system"))
		{
			player trophy_system::ammo_weapon_hacked(ammoleftequipment);
		}
	}
	self.hacked = 1;
	self setmissileowner(player);
	self setteam(player.pers["team"]);
	self.owner = player;
	self clientfield::set("retrievable", 0);
	if(self.weapon.dohackedstats)
	{
		scoreevents::processscoreevent("hacked", player);
		player addweaponstat(getweapon("pda_hack"), "CombatRecordStat", 1);
		player challenges::hackedordestroyedequipment();
	}
	if(self.weapon.rootweapon == level.weaponsatchelcharge && isdefined(player.lowermessage))
	{
		player.lowermessage settext(&"PLATFORM_SATCHEL_CHARGE_DOUBLE_TAP");
		player.lowermessage.alpha = 1;
		player.lowermessage fadeovertime(2);
		player.lowermessage.alpha = 0;
	}
	self notify(#"hacked", player);
	level notify(#"hacked", self, player);
	if(isdefined(self.camerahead))
	{
		self.camerahead notify(#"hacked", player);
	}
	/#
	#/
	wait(0.05);
	if(isdefined(player) && player.sessionstate == "playing")
	{
		player notify(#"grenade_fire", self, self.weapon, 1);
	}
	else
	{
		watcher thread waitanddetonate(self, 0, undefined, self.weapon);
	}
}

/*
	Name: hackerunfreezeplayer
	Namespace: weaponobjects
	Checksum: 0xCC5D4AE
	Offset: 0x6598
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function hackerunfreezeplayer(player)
{
	self endon(#"hack_done");
	self waittill(#"death");
	if(isdefined(player))
	{
		player util::freeze_player_controls(0);
		player enableweapons();
	}
}

/*
	Name: hackerresult
	Namespace: weaponobjects
	Checksum: 0x2AB3D6E2
	Offset: 0x6600
	Size: 0x2E6
	Parameters: 2
	Flags: Linked
*/
function hackerresult(player, owner)
{
	success = 1;
	time = gettime();
	hacktime = getdvarfloat("perk_disarmExplosiveTime");
	if(!canhack(player, owner, 1))
	{
		return 0;
	}
	self thread hackerunfreezeplayer(player);
	while((time + (hacktime * 1000)) > gettime())
	{
		if(!canhack(player, owner, 0))
		{
			success = 0;
			break;
		}
		if(!player usebuttonpressed())
		{
			success = 0;
			break;
		}
		if(!isdefined(self))
		{
			success = 0;
			break;
		}
		player util::freeze_player_controls(1);
		player disableweapons();
		if(!isdefined(self.progressbar))
		{
			self.progressbar = player hud::createprimaryprogressbar();
			self.progressbar.lastuserate = -1;
			self.progressbar hud::showelem();
			self.progressbar hud::updatebar(0.01, 1 / hacktime);
			self.progresstext = player hud::createprimaryprogressbartext();
			self.progresstext settext(&"MP_HACKING");
			self.progresstext hud::showelem();
			player playlocalsound("evt_hacker_hacking");
		}
		wait(0.05);
	}
	if(isdefined(player))
	{
		player util::freeze_player_controls(0);
		player enableweapons();
	}
	if(isdefined(self.progressbar))
	{
		self.progressbar hud::destroyelem();
		self.progresstext hud::destroyelem();
	}
	if(isdefined(self))
	{
		self notify(#"hack_done");
	}
	return success;
}

/*
	Name: canhack
	Namespace: weaponobjects
	Checksum: 0xAD90914F
	Offset: 0x68F0
	Size: 0x32A
	Parameters: 3
	Flags: Linked
*/
function canhack(player, owner, weapon_check)
{
	if(!isdefined(player))
	{
		return false;
	}
	if(!isplayer(player))
	{
		return false;
	}
	if(!isalive(player))
	{
		return false;
	}
	if(!isdefined(owner))
	{
		return false;
	}
	if(owner == player)
	{
		return false;
	}
	if(level.teambased && player.team == owner.team)
	{
		return false;
	}
	if(isdefined(player.isdefusing) && player.isdefusing)
	{
		return false;
	}
	if(isdefined(player.isplanting) && player.isplanting)
	{
		return false;
	}
	if(isdefined(player.proxbar) && !player.proxbar.hidden)
	{
		return false;
	}
	if(isdefined(player.revivingteammate) && player.revivingteammate == 1)
	{
		return false;
	}
	if(!player isonground())
	{
		return false;
	}
	if(player isinvehicle())
	{
		return false;
	}
	if(player isweaponviewonlylinked())
	{
		return false;
	}
	if(!player hasperk("specialty_disarmexplosive"))
	{
		return false;
	}
	if(player isempjammed())
	{
		return false;
	}
	if(isdefined(player.laststand) && player.laststand)
	{
		return false;
	}
	if(weapon_check)
	{
		if(player isthrowinggrenade())
		{
			return false;
		}
		if(player isswitchingweapons())
		{
			return false;
		}
		if(player ismeleeing())
		{
			return false;
		}
		weapon = player getcurrentweapon();
		if(!isdefined(weapon))
		{
			return false;
		}
		if(weapon == level.weaponnone)
		{
			return false;
		}
		if(weapon.isequipment && player isfiring())
		{
			return false;
		}
		if(weapon.isspecificuse)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: hackerremoveweapon
	Namespace: weaponobjects
	Checksum: 0xB1186F91
	Offset: 0x6C28
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function hackerremoveweapon(weapon_instance)
{
	for(i = 0; i < self.weaponobjectwatcherarray.size; i++)
	{
		if(self.weaponobjectwatcherarray[i].weapon != weapon_instance.weapon.rootweapon)
		{
			continue;
		}
		removeweaponobject(self.weaponobjectwatcherarray[i], weapon_instance);
		return;
	}
}

/*
	Name: proximityweaponobject_createdamagearea
	Namespace: weaponobjects
	Checksum: 0x3A3CEC37
	Offset: 0x6CC8
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function proximityweaponobject_createdamagearea(watcher)
{
	damagearea = spawn("trigger_radius", self.origin + (0, 0, 0 - watcher.detonateradius), level.aitriggerspawnflags | level.vehicletriggerspawnflags, watcher.detonateradius, watcher.detonateradius * 2);
	damagearea enablelinkto();
	damagearea linkto(self);
	self thread deleteondeath(damagearea);
	return damagearea;
}

/*
	Name: proximityweaponobject_validtriggerentity
	Namespace: weaponobjects
	Checksum: 0xD69C2206
	Offset: 0x6D98
	Size: 0x206
	Parameters: 2
	Flags: Linked
*/
function proximityweaponobject_validtriggerentity(watcher, ent)
{
	if(level.weaponobjectdebug != 1)
	{
		if(isdefined(self.owner) && ent == self.owner)
		{
			return false;
		}
		if(isvehicle(ent))
		{
			if(watcher.ignorevehicles)
			{
				return false;
			}
			if(self.owner === ent.owner)
			{
				return false;
			}
		}
		if(!friendlyfirecheck(self.owner, ent, 0))
		{
			return false;
		}
		if(watcher.ignorevehicles && isai(ent) && (!(isdefined(ent.isaiclone) && ent.isaiclone)))
		{
			return false;
		}
	}
	if(lengthsquared(ent getvelocity()) < 10 && !isdefined(watcher.immediatedetonation))
	{
		return false;
	}
	if(!ent shouldaffectweaponobject(self, watcher))
	{
		return false;
	}
	if(self isstunned())
	{
		return false;
	}
	if(isplayer(ent))
	{
		if(!isalive(ent))
		{
			return false;
		}
		if(isdefined(watcher.immunespecialty) && ent hasperk(watcher.immunespecialty))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: proximityweaponobject_removespawnprotectondeath
	Namespace: weaponobjects
	Checksum: 0x74ED0825
	Offset: 0x6FA8
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function proximityweaponobject_removespawnprotectondeath(ent)
{
	self endon(#"death");
	ent util::waittill_any("death", "disconnected");
	arrayremovevalue(self.protected_entities, ent);
}

/*
	Name: proximityweaponobject_spawnprotect
	Namespace: weaponobjects
	Checksum: 0x3FFB7002
	Offset: 0x7010
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function proximityweaponobject_spawnprotect(watcher, ent)
{
	self endon(#"death");
	ent endon(#"death");
	ent endon(#"disconnect");
	self.protected_entities[self.protected_entities.size] = ent;
	self thread proximityweaponobject_removespawnprotectondeath(ent);
	radius_sqr = watcher.detonateradius * watcher.detonateradius;
	while(true)
	{
		if(distancesquared(ent.origin, self.origin) > radius_sqr)
		{
			arrayremovevalue(self.protected_entities, ent);
			return;
		}
		wait(0.5);
	}
}

/*
	Name: proximityweaponobject_isspawnprotected
	Namespace: weaponobjects
	Checksum: 0xACDAF6D1
	Offset: 0x7110
	Size: 0x12C
	Parameters: 2
	Flags: Linked
*/
function proximityweaponobject_isspawnprotected(watcher, ent)
{
	if(!isplayer(ent))
	{
		return false;
	}
	foreach(protected_ent in self.protected_entities)
	{
		if(protected_ent == ent)
		{
			return true;
		}
	}
	linked_to = self getlinkedent();
	if(linked_to === ent)
	{
		return false;
	}
	if(ent player::is_spawn_protected())
	{
		self thread proximityweaponobject_spawnprotect(watcher, ent);
		return true;
	}
	return false;
}

/*
	Name: proximityweaponobject_dodetonation
	Namespace: weaponobjects
	Checksum: 0x23FFA9B9
	Offset: 0x7248
	Size: 0x170
	Parameters: 3
	Flags: Linked
*/
function proximityweaponobject_dodetonation(watcher, ent, traceorigin)
{
	self endon(#"death");
	self endon(#"hacked");
	self notify(#"kill_target_detection");
	if(isdefined(watcher.activatesound))
	{
		self playsound(watcher.activatesound);
	}
	wait(watcher.detectiongraceperiod);
	if(isplayer(ent) && ent hasperk("specialty_delayexplosive"))
	{
		wait(getdvarfloat("perk_delayExplosiveTime"));
	}
	self entityheadicons::setentityheadicon("none");
	self.origin = traceorigin;
	if(isdefined(self.owner) && isplayer(self.owner))
	{
		self [[watcher.ondetonatecallback]](self.owner, undefined, ent);
	}
	else
	{
		self [[watcher.ondetonatecallback]](undefined, undefined, ent);
	}
}

/*
	Name: proximityweaponobject_activationdelay
	Namespace: weaponobjects
	Checksum: 0x5DC6E7AE
	Offset: 0x73C0
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function proximityweaponobject_activationdelay(watcher)
{
	self util::waittillnotmoving();
	if(watcher.activationdelay)
	{
		wait(watcher.activationdelay);
	}
}

/*
	Name: proximityweaponobject_waittillframeendanddodetonation
	Namespace: weaponobjects
	Checksum: 0xA415E575
	Offset: 0x7410
	Size: 0xC4
	Parameters: 3
	Flags: Linked
*/
function proximityweaponobject_waittillframeendanddodetonation(watcher, ent, traceorigin)
{
	self endon(#"death");
	dist = distance(ent.origin, self.origin);
	if(isdefined(self.activated_entity_distance))
	{
		if(dist < self.activated_entity_distance)
		{
			self notify(#"better_target");
		}
		else
		{
			return;
		}
	}
	self endon(#"better_target");
	self.activated_entity_distance = dist;
	wait(0.05);
	proximityweaponobject_dodetonation(watcher, ent, traceorigin);
}

/*
	Name: proximityweaponobjectdetonation
	Namespace: weaponobjects
	Checksum: 0xE488DEE
	Offset: 0x74E0
	Size: 0x158
	Parameters: 1
	Flags: Linked
*/
function proximityweaponobjectdetonation(watcher)
{
	self endon(#"death");
	self endon(#"hacked");
	self endon(#"kill_target_detection");
	proximityweaponobject_activationdelay(watcher);
	damagearea = proximityweaponobject_createdamagearea(watcher);
	up = anglestoup(self.angles);
	traceorigin = self.origin + up;
	while(true)
	{
		damagearea waittill(#"trigger", ent);
		if(!proximityweaponobject_validtriggerentity(watcher, ent))
		{
			continue;
		}
		if(proximityweaponobject_isspawnprotected(watcher, ent))
		{
			continue;
		}
		if(ent damageconetrace(traceorigin, self) > 0)
		{
			thread proximityweaponobject_waittillframeendanddodetonation(watcher, ent, traceorigin);
		}
	}
}

/*
	Name: shouldaffectweaponobject
	Namespace: weaponobjects
	Checksum: 0x496DB00E
	Offset: 0x7640
	Size: 0x1A4
	Parameters: 2
	Flags: Linked
*/
function shouldaffectweaponobject(object, watcher)
{
	radius = object.weapon.explosionradius;
	distancesqr = distancesquared(self.origin, object.origin);
	if((radius * radius) < distancesqr)
	{
		return 0;
	}
	pos = self.origin + vectorscale((0, 0, 1), 32);
	if(isdefined(watcher.ignoredirection))
	{
		return 1;
	}
	dirtopos = pos - object.origin;
	objectforward = anglestoforward(object.angles);
	dist = vectordot(dirtopos, objectforward);
	if(dist < watcher.detectionmindist)
	{
		return 0;
	}
	dirtopos = vectornormalize(dirtopos);
	dot = vectordot(dirtopos, objectforward);
	return dot > watcher.detectiondot;
}

/*
	Name: deleteondeath
	Namespace: weaponobjects
	Checksum: 0xECD05237
	Offset: 0x77F0
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function deleteondeath(ent)
{
	self util::waittill_any("death", "hacked");
	wait(0.05);
	if(isdefined(ent))
	{
		ent delete();
	}
}

/*
	Name: testkillbrushonstationary
	Namespace: weaponobjects
	Checksum: 0xB3F708D7
	Offset: 0x7858
	Size: 0x15C
	Parameters: 2
	Flags: Linked
*/
function testkillbrushonstationary(a_killbrushes, player)
{
	player endon(#"disconnect");
	self endon(#"death");
	self waittill(#"stationary");
	foreach(trig in a_killbrushes)
	{
		if(isdefined(trig) && self istouching(trig))
		{
			if(!trig istriggerenabled())
			{
				continue;
			}
			if(isdefined(self.spawnflags) && (self.spawnflags & 2) == 2)
			{
				continue;
			}
			if(self.origin[2] > player.origin[2])
			{
				break;
			}
			if(isdefined(self))
			{
				self delete();
			}
			return;
		}
	}
}

/*
	Name: deleteonkillbrush
	Namespace: weaponobjects
	Checksum: 0xBCF66354
	Offset: 0x79C0
	Size: 0x18C
	Parameters: 1
	Flags: Linked
*/
function deleteonkillbrush(player)
{
	player endon(#"disconnect");
	self endon(#"death");
	self endon(#"stationary");
	a_killbrushes = getentarray("trigger_hurt", "classname");
	self thread testkillbrushonstationary(a_killbrushes, player);
	while(true)
	{
		a_killbrushes = getentarray("trigger_hurt", "classname");
		for(i = 0; i < a_killbrushes.size; i++)
		{
			if(self istouching(a_killbrushes[i]))
			{
				if(!a_killbrushes[i] istriggerenabled())
				{
					continue;
				}
				if(isdefined(self.spawnflags) && (self.spawnflags & 2) == 2)
				{
					continue;
				}
				if(self.origin[2] > player.origin[2])
				{
					break;
				}
				if(isdefined(self))
				{
					self delete();
				}
				return;
			}
		}
		wait(0.1);
	}
}

/*
	Name: watchweaponobjectaltdetonation
	Namespace: weaponobjects
	Checksum: 0x5CA1C7BF
	Offset: 0x7B58
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function watchweaponobjectaltdetonation()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"alt_detonate");
		if(!isalive(self) || self util::isusingremote())
		{
			continue;
		}
		for(watcher = 0; watcher < self.weaponobjectwatcherarray.size; watcher++)
		{
			if(self.weaponobjectwatcherarray[watcher].altdetonate)
			{
				self.weaponobjectwatcherarray[watcher] detonateweaponobjectarray(0);
			}
		}
	}
}

/*
	Name: watchweaponobjectaltdetonate
	Namespace: weaponobjects
	Checksum: 0xCED61C76
	Offset: 0x7C30
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function watchweaponobjectaltdetonate()
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	buttontime = 0;
	for(;;)
	{
		self waittill(#"doubletap_detonate");
		if(!isalive(self) && !self util::isusingremote())
		{
			continue;
		}
		self notify(#"alt_detonate");
		wait(0.05);
	}
}

/*
	Name: watchweaponobjectdetonation
	Namespace: weaponobjects
	Checksum: 0x4B4CB0EA
	Offset: 0x7CC0
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function watchweaponobjectdetonation()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"detonate");
		if(self isusingoffhand())
		{
			weap = self getcurrentoffhand();
		}
		else
		{
			weap = self getcurrentweapon();
		}
		watcher = getweaponobjectwatcherbyweapon(weap);
		if(isdefined(watcher))
		{
			if(isdefined(watcher.ondetonationhandle))
			{
				self thread [[watcher.ondetonationhandle]](watcher);
			}
			watcher detonateweaponobjectarray(0);
		}
	}
}

/*
	Name: cleanupwatchers
	Namespace: weaponobjects
	Checksum: 0xD7C6DB4D
	Offset: 0x7DC0
	Size: 0x136
	Parameters: 0
	Flags: Linked
*/
function cleanupwatchers()
{
	if(!isdefined(self.weaponobjectwatcherarray))
	{
		/#
			assert("");
		#/
		return;
	}
	watchers = [];
	for(watcher = 0; watcher < self.weaponobjectwatcherarray.size; watcher++)
	{
		weaponobjectwatcher = spawnstruct();
		watchers[watchers.size] = weaponobjectwatcher;
		weaponobjectwatcher.objectarray = [];
		if(isdefined(self.weaponobjectwatcherarray[watcher].objectarray))
		{
			weaponobjectwatcher.objectarray = self.weaponobjectwatcherarray[watcher].objectarray;
		}
	}
	wait(0.05);
	for(watcher = 0; watcher < watchers.size; watcher++)
	{
		watchers[watcher] deleteweaponobjectarray();
	}
}

/*
	Name: watchfordisconnectcleanup
	Namespace: weaponobjects
	Checksum: 0x9003A486
	Offset: 0x7F00
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function watchfordisconnectcleanup()
{
	self waittill(#"disconnect");
	cleanupwatchers();
}

/*
	Name: deleteweaponobjectson
	Namespace: weaponobjects
	Checksum: 0x221BDA1B
	Offset: 0x7F30
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function deleteweaponobjectson()
{
	self thread watchfordisconnectcleanup();
	self endon(#"disconnect");
	if(!isplayer(self))
	{
		return;
	}
	while(true)
	{
		msg = self util::waittill_any_return("joined_team", "joined_spectators", "death", "disconnect");
		if(msg == "death")
		{
			continue;
		}
		cleanupwatchers();
	}
}

/*
	Name: saydamaged
	Namespace: weaponobjects
	Checksum: 0x199C0A4D
	Offset: 0x7FE8
	Size: 0x6E
	Parameters: 2
	Flags: None
*/
function saydamaged(orig, amount)
{
	/#
		for(i = 0; i < 60; i++)
		{
			print3d(orig, "" + amount);
			wait(0.05);
		}
	#/
}

/*
	Name: showheadicon
	Namespace: weaponobjects
	Checksum: 0xB75D0F50
	Offset: 0x8060
	Size: 0x29C
	Parameters: 1
	Flags: None
*/
function showheadicon(trigger)
{
	triggerdetectid = trigger.detectid;
	useid = -1;
	for(index = 0; index < 4; index++)
	{
		detectid = self.bombsquadicons[index].detectid;
		if(detectid == triggerdetectid)
		{
			return;
		}
		if(detectid == "")
		{
			useid = index;
		}
	}
	if(useid < 0)
	{
		return;
	}
	self.bombsquadids[triggerdetectid] = 1;
	self.bombsquadicons[useid].x = trigger.origin[0];
	self.bombsquadicons[useid].y = trigger.origin[1];
	self.bombsquadicons[useid].z = (trigger.origin[2] + 24) + 128;
	self.bombsquadicons[useid] fadeovertime(0.25);
	self.bombsquadicons[useid].alpha = 1;
	self.bombsquadicons[useid].detectid = trigger.detectid;
	while(isalive(self) && isdefined(trigger) && self istouching(trigger))
	{
		wait(0.05);
	}
	if(!isdefined(self))
	{
		return;
	}
	self.bombsquadicons[useid].detectid = "";
	self.bombsquadicons[useid] fadeovertime(0.25);
	self.bombsquadicons[useid].alpha = 0;
	self.bombsquadids[triggerdetectid] = undefined;
}

/*
	Name: friendlyfirecheck
	Namespace: weaponobjects
	Checksum: 0x6D5D4A21
	Offset: 0x8308
	Size: 0x230
	Parameters: 3
	Flags: Linked
*/
function friendlyfirecheck(owner, attacker, forcedfriendlyfirerule)
{
	if(!isdefined(owner))
	{
		return true;
	}
	if(!level.teambased)
	{
		return true;
	}
	friendlyfirerule = [[level.figure_out_friendly_fire]](undefined);
	if(isdefined(forcedfriendlyfirerule))
	{
		friendlyfirerule = forcedfriendlyfirerule;
	}
	if(friendlyfirerule != 0)
	{
		return true;
	}
	if(attacker == owner)
	{
		return true;
	}
	if(isplayer(attacker))
	{
		if(!isdefined(attacker.pers["team"]))
		{
			return true;
		}
		if(attacker.pers["team"] != owner.pers["team"])
		{
			return true;
		}
	}
	else
	{
		if(isactor(attacker))
		{
			if(attacker.team != owner.pers["team"])
			{
				return true;
			}
		}
		else if(isvehicle(attacker))
		{
			if(isdefined(attacker.owner) && isplayer(attacker.owner))
			{
				if(attacker.owner.pers["team"] != owner.pers["team"])
				{
					return true;
				}
			}
			else
			{
				occupant_team = attacker vehicle::vehicle_get_occupant_team();
				if(occupant_team != owner.pers["team"] && occupant_team != "spectator")
				{
					return true;
				}
			}
		}
	}
	return false;
}

/*
	Name: onspawnhatchet
	Namespace: weaponobjects
	Checksum: 0x8F34F670
	Offset: 0x8540
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function onspawnhatchet(watcher, player)
{
	if(isdefined(level.playthrowhatchet))
	{
		player [[level.playthrowhatchet]]();
	}
}

/*
	Name: onspawncrossbowbolt
	Namespace: weaponobjects
	Checksum: 0x1EB4F530
	Offset: 0x8580
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function onspawncrossbowbolt(watcher, player)
{
	self.delete_on_death = 1;
	self thread onspawncrossbowbolt_internal(watcher, player);
}

/*
	Name: onspawncrossbowbolt_internal
	Namespace: weaponobjects
	Checksum: 0x9F901473
	Offset: 0x85C8
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function onspawncrossbowbolt_internal(watcher, player)
{
	player endon(#"disconnect");
	self endon(#"death");
	wait(0.25);
	linkedent = self getlinkedent();
	if(!isdefined(linkedent) || !isvehicle(linkedent))
	{
		self.takedamage = 0;
	}
	else
	{
		self.takedamage = 1;
		if(isvehicle(linkedent))
		{
			self thread dieonentitydeath(linkedent, player);
		}
	}
}

/*
	Name: dieonentitydeath
	Namespace: weaponobjects
	Checksum: 0xC3E90E6
	Offset: 0x86A8
	Size: 0x96
	Parameters: 2
	Flags: Linked
*/
function dieonentitydeath(entity, player)
{
	player endon(#"disconnect");
	self endon(#"death");
	alreadydead = entity.dead === 1 || (isdefined(entity.health) && entity.health < 0);
	if(!alreadydead)
	{
		entity waittill(#"death");
	}
	self notify(#"death");
}

/*
	Name: onspawncrossbowboltimpact
	Namespace: weaponobjects
	Checksum: 0x20A3C85E
	Offset: 0x8748
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function onspawncrossbowboltimpact(s_watcher, e_player)
{
	self.delete_on_death = 1;
	self thread onspawncrossbowboltimpact_internal(s_watcher, e_player);
}

/*
	Name: onspawncrossbowboltimpact_internal
	Namespace: weaponobjects
	Checksum: 0x7ADE11B
	Offset: 0x8790
	Size: 0x104
	Parameters: 2
	Flags: Linked
*/
function onspawncrossbowboltimpact_internal(s_watcher, e_player)
{
	self endon(#"death");
	e_player endon(#"disconnect");
	self waittill(#"stationary");
	s_watcher thread waitandfizzleout(self, 0);
	foreach(n_index, e_object in s_watcher.objectarray)
	{
		if(self == e_object)
		{
			s_watcher.objectarray[n_index] = undefined;
		}
	}
	cleanweaponobjectarray(s_watcher);
}

/*
	Name: onspawnspecialcrossbowtrigger
	Namespace: weaponobjects
	Checksum: 0xC5177EB5
	Offset: 0x88A0
	Size: 0x31C
	Parameters: 2
	Flags: Linked
*/
function onspawnspecialcrossbowtrigger(watcher, player)
{
	self endon(#"death");
	self setowner(player);
	self setteam(player.pers["team"]);
	self.owner = player;
	self.oldangles = self.angles;
	self util::waittillnotmoving();
	waittillframeend();
	if(player.pers["team"] == "spectator")
	{
		return;
	}
	triggerorigin = self.origin;
	triggerparentent = undefined;
	if(isdefined(self.stucktoplayer))
	{
		if(isalive(self.stucktoplayer) || !isdefined(self.stucktoplayer.body))
		{
			if(isalive(self.stucktoplayer))
			{
				triggerparentent = self;
				self unlink();
				self.angles = self.oldangles;
				self launch(vectorscale((1, 1, 1), 5));
				self util::waittillnotmoving();
				waittillframeend();
			}
			else
			{
				triggerparentent = self.stucktoplayer;
			}
		}
		else
		{
			triggerparentent = self.stucktoplayer.body;
		}
	}
	if(isdefined(triggerparentent))
	{
		triggerorigin = triggerparentent.origin + vectorscale((0, 0, 1), 10);
	}
	if(self.weapon.shownretrievable)
	{
		self clientfield::set("retrievable", 1);
	}
	self.hatchetpickuptrigger = spawn("trigger_radius", triggerorigin, 0, 50, 50);
	self.hatchetpickuptrigger enablelinkto();
	self.hatchetpickuptrigger linkto(self);
	if(isdefined(triggerparentent))
	{
		self.hatchetpickuptrigger linkto(triggerparentent);
	}
	self thread watchspecialcrossbowtrigger(self.hatchetpickuptrigger, watcher.pickup, watcher.pickupsoundplayer, watcher.pickupsound);
	/#
		thread switch_team(self, watcher, player);
	#/
	self thread watchshutdown(player);
}

/*
	Name: watchspecialcrossbowtrigger
	Namespace: weaponobjects
	Checksum: 0x3E871BE9
	Offset: 0x8BC8
	Size: 0x186
	Parameters: 4
	Flags: Linked
*/
function watchspecialcrossbowtrigger(trigger, callback, playersoundonuse, npcsoundonuse)
{
	self endon(#"delete");
	self endon(#"hacked");
	while(true)
	{
		trigger waittill(#"trigger", player);
		if(!isalive(player))
		{
			continue;
		}
		if(isdefined(trigger.claimedby) && player != trigger.claimedby)
		{
			continue;
		}
		crossbow_weapon = player get_player_crossbow_weapon();
		if(!isdefined(crossbow_weapon))
		{
			continue;
		}
		stock_ammo = player getweaponammostock(crossbow_weapon);
		if(stock_ammo >= crossbow_weapon.maxammo)
		{
			continue;
		}
		if(isdefined(playersoundonuse))
		{
			player playlocalsound(playersoundonuse);
		}
		if(isdefined(npcsoundonuse))
		{
			player playsound(npcsoundonuse);
		}
		self thread [[callback]](player, crossbow_weapon);
	}
}

/*
	Name: onspawnhatchettrigger
	Namespace: weaponobjects
	Checksum: 0x13227FC
	Offset: 0x8D58
	Size: 0x31C
	Parameters: 2
	Flags: Linked
*/
function onspawnhatchettrigger(watcher, player)
{
	self endon(#"death");
	self setowner(player);
	self setteam(player.pers["team"]);
	self.owner = player;
	self.oldangles = self.angles;
	self util::waittillnotmoving();
	waittillframeend();
	if(player.pers["team"] == "spectator")
	{
		return;
	}
	triggerorigin = self.origin;
	triggerparentent = undefined;
	if(isdefined(self.stucktoplayer))
	{
		if(isalive(self.stucktoplayer) || !isdefined(self.stucktoplayer.body))
		{
			if(isalive(self.stucktoplayer))
			{
				triggerparentent = self;
				self unlink();
				self.angles = self.oldangles;
				self launch(vectorscale((1, 1, 1), 5));
				self util::waittillnotmoving();
				waittillframeend();
			}
			else
			{
				triggerparentent = self.stucktoplayer;
			}
		}
		else
		{
			triggerparentent = self.stucktoplayer.body;
		}
	}
	if(isdefined(triggerparentent))
	{
		triggerorigin = triggerparentent.origin + vectorscale((0, 0, 1), 10);
	}
	if(self.weapon.shownretrievable)
	{
		self clientfield::set("retrievable", 1);
	}
	self.hatchetpickuptrigger = spawn("trigger_radius", triggerorigin, 0, 50, 50);
	self.hatchetpickuptrigger enablelinkto();
	self.hatchetpickuptrigger linkto(self);
	if(isdefined(triggerparentent))
	{
		self.hatchetpickuptrigger linkto(triggerparentent);
	}
	self thread watchhatchettrigger(self.hatchetpickuptrigger, watcher.pickup, watcher.pickupsoundplayer, watcher.pickupsound);
	/#
		thread switch_team(self, watcher, player);
	#/
	self thread watchshutdown(player);
}

/*
	Name: watchhatchettrigger
	Namespace: weaponobjects
	Checksum: 0x4317A9B4
	Offset: 0x9080
	Size: 0x282
	Parameters: 4
	Flags: Linked
*/
function watchhatchettrigger(trigger, callback, playersoundonuse, npcsoundonuse)
{
	self endon(#"delete");
	self endon(#"hacked");
	while(true)
	{
		trigger waittill(#"trigger", player);
		if(!isalive(player))
		{
			continue;
		}
		if(!player isonground() && !player isplayerswimming())
		{
			continue;
		}
		if(isdefined(trigger.claimedby) && player != trigger.claimedby)
		{
			continue;
		}
		heldweapon = player get_held_weapon_match_or_root_match(self.weapon);
		if(!isdefined(heldweapon))
		{
			continue;
		}
		maxammo = 0;
		if(heldweapon == player.grenadetypeprimary && isdefined(player.grenadetypeprimarycount) && player.grenadetypeprimarycount > 0)
		{
			maxammo = player.grenadetypeprimarycount;
		}
		else if(heldweapon == player.grenadetypesecondary && isdefined(player.grenadetypesecondarycount) && player.grenadetypesecondarycount > 0)
		{
			maxammo = player.grenadetypesecondarycount;
		}
		if(maxammo == 0)
		{
			continue;
		}
		clip_ammo = player getweaponammoclip(heldweapon);
		if(clip_ammo >= maxammo)
		{
			continue;
		}
		if(isdefined(playersoundonuse))
		{
			player playlocalsound(playersoundonuse);
		}
		if(isdefined(npcsoundonuse))
		{
			player playsound(npcsoundonuse);
		}
		self thread [[callback]](player);
	}
}

/*
	Name: get_held_weapon_match_or_root_match
	Namespace: weaponobjects
	Checksum: 0x77A9C063
	Offset: 0x9310
	Size: 0x13E
	Parameters: 1
	Flags: Linked
*/
function get_held_weapon_match_or_root_match(weapon)
{
	pweapons = self getweaponslist(1);
	foreach(pweapon in pweapons)
	{
		if(pweapon == weapon)
		{
			return pweapon;
		}
	}
	foreach(pweapon in pweapons)
	{
		if(pweapon.rootweapon == weapon.rootweapon)
		{
			return pweapon;
		}
	}
	return undefined;
}

/*
	Name: get_player_crossbow_weapon
	Namespace: weaponobjects
	Checksum: 0xDB9CA7D
	Offset: 0x9458
	Size: 0x11E
	Parameters: 0
	Flags: Linked
*/
function get_player_crossbow_weapon()
{
	pweapons = self getweaponslist(1);
	crossbow = getweapon("special_crossbow");
	crossbow_dw = getweapon("special_crossbow_dw");
	foreach(pweapon in pweapons)
	{
		if(pweapon.rootweapon == crossbow || pweapon.rootweapon == crossbow_dw)
		{
			return pweapon;
		}
	}
	return undefined;
}

/*
	Name: onspawnretrievableweaponobject
	Namespace: weaponobjects
	Checksum: 0x48C8AD67
	Offset: 0x9580
	Size: 0x60C
	Parameters: 2
	Flags: Linked
*/
function onspawnretrievableweaponobject(watcher, player)
{
	self endon(#"death");
	self endon(#"hacked");
	self setowner(player);
	self setteam(player.pers["team"]);
	self.owner = player;
	self.oldangles = self.angles;
	self util::waittillnotmoving();
	if(watcher.activationdelay)
	{
		wait(watcher.activationdelay);
	}
	waittillframeend();
	if(player.pers["team"] == "spectator")
	{
		return;
	}
	triggerorigin = self.origin;
	triggerparentent = undefined;
	if(isdefined(self.stucktoplayer))
	{
		if(isalive(self.stucktoplayer) || !isdefined(self.stucktoplayer.body))
		{
			triggerparentent = self.stucktoplayer;
		}
		else
		{
			triggerparentent = self.stucktoplayer.body;
		}
	}
	if(isdefined(triggerparentent))
	{
		triggerorigin = triggerparentent.origin + vectorscale((0, 0, 1), 10);
	}
	else
	{
		up = anglestoup(self.angles);
		triggerorigin = self.origin + up;
	}
	if(!self util::ishacked())
	{
		if(self.weapon.shownretrievable)
		{
			self clientfield::set("retrievable", 1);
		}
		self.pickuptrigger = spawn("trigger_radius_use", triggerorigin);
		self.pickuptrigger sethintlowpriority(1);
		self.pickuptrigger setcursorhint("HINT_NOICON", self);
		self.pickuptrigger enablelinkto();
		self.pickuptrigger linkto(self);
		self.pickuptrigger setinvisibletoall();
		self.pickuptrigger setvisibletoplayer(player);
		if(isdefined(level.retrievehints[watcher.name]))
		{
			self.pickuptrigger sethintstring(level.retrievehints[watcher.name].hint);
		}
		else
		{
			self.pickuptrigger sethintstring(&"MP_GENERIC_PICKUP");
		}
		self.pickuptrigger setteamfortrigger(player.pers["team"]);
		if(isdefined(triggerparentent))
		{
			self.pickuptrigger linkto(triggerparentent);
		}
		self thread watchusetrigger(self.pickuptrigger, watcher.pickup, watcher.pickupsoundplayer, watcher.pickupsound);
		if(isdefined(watcher.pickup_trigger_listener))
		{
			self thread [[watcher.pickup_trigger_listener]](self.pickuptrigger, player);
		}
	}
	if(watcher.enemydestroy)
	{
		self.enemytrigger = spawn("trigger_radius_use", triggerorigin);
		self.enemytrigger setcursorhint("HINT_NOICON", self);
		self.enemytrigger enablelinkto();
		self.enemytrigger linkto(self);
		self.enemytrigger setinvisibletoplayer(player);
		if(level.teambased)
		{
			self.enemytrigger setexcludeteamfortrigger(player.team);
			self.enemytrigger.triggerteamignore = self.team;
		}
		if(isdefined(level.destroyhints[watcher.name]))
		{
			self.enemytrigger sethintstring(level.destroyhints[watcher.name].hint);
		}
		else
		{
			self.enemytrigger sethintstring(&"MP_GENERIC_DESTROY");
		}
		self thread watchusetrigger(self.enemytrigger, watcher.ondestroyed);
	}
	/#
		thread switch_team(self, watcher, player);
	#/
	self thread watchshutdown(player);
}

/*
	Name: destroyent
	Namespace: weaponobjects
	Checksum: 0x1B3A93A8
	Offset: 0x9B98
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function destroyent()
{
	self delete();
}

/*
	Name: pickup
	Namespace: weaponobjects
	Checksum: 0xE8FC221D
	Offset: 0x9BC0
	Size: 0x26C
	Parameters: 1
	Flags: Linked
*/
function pickup(player)
{
	if(!self.weapon.anyplayercanretrieve && isdefined(self.owner) && self.owner != player)
	{
		return;
	}
	pikedweapon = self.weapon;
	if(self.weapon.ammocountequipment > 0 && isdefined(self.ammo))
	{
		ammoleftequipment = self.ammo;
	}
	self notify(#"picked_up");
	self.playdialog = 0;
	self destroyent();
	heldweapon = player get_held_weapon_match_or_root_match(self.weapon);
	if(!isdefined(heldweapon))
	{
		return;
	}
	maxammo = 0;
	if(heldweapon == player.grenadetypeprimary && isdefined(player.grenadetypeprimarycount) && player.grenadetypeprimarycount > 0)
	{
		maxammo = player.grenadetypeprimarycount;
	}
	else if(heldweapon == player.grenadetypesecondary && isdefined(player.grenadetypesecondarycount) && player.grenadetypesecondarycount > 0)
	{
		maxammo = player.grenadetypesecondarycount;
	}
	if(maxammo == 0)
	{
		return;
	}
	clip_ammo = player getweaponammoclip(heldweapon);
	if(clip_ammo < maxammo)
	{
		clip_ammo++;
	}
	if(isdefined(ammoleftequipment))
	{
		if(pikedweapon.rootweapon == getweapon("trophy_system"))
		{
			player trophy_system::ammo_weapon_pickup(ammoleftequipment);
		}
	}
	player setweaponammoclip(heldweapon, clip_ammo);
}

/*
	Name: pickupcrossbowbolt
	Namespace: weaponobjects
	Checksum: 0xAC2F0E17
	Offset: 0x9E38
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function pickupcrossbowbolt(player, heldweapon)
{
	self notify(#"picked_up");
	self.playdialog = 0;
	self destroyent();
	stock_ammo = player getweaponammostock(heldweapon);
	stock_ammo++;
	player setweaponammostock(heldweapon, stock_ammo);
}

/*
	Name: ondestroyed
	Namespace: weaponobjects
	Checksum: 0x55B06FB1
	Offset: 0x9ED0
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function ondestroyed(attacker)
{
	playfx(level._effect["tacticalInsertionFizzle"], self.origin);
	self playsound("dst_tac_insert_break");
	if(isdefined(level.playequipmentdestroyedonplayer))
	{
		self.owner [[level.playequipmentdestroyedonplayer]]();
	}
	self delete();
}

/*
	Name: watchshutdown
	Namespace: weaponobjects
	Checksum: 0x4C7878EE
	Offset: 0x9F70
	Size: 0x15C
	Parameters: 1
	Flags: Linked
*/
function watchshutdown(player)
{
	self util::waittill_any("death", "hacked", "detonating");
	pickuptrigger = self.pickuptrigger;
	hackertrigger = self.hackertrigger;
	hatchetpickuptrigger = self.hatchetpickuptrigger;
	enemytrigger = self.enemytrigger;
	if(isdefined(pickuptrigger))
	{
		pickuptrigger delete();
	}
	if(isdefined(hackertrigger))
	{
		if(isdefined(hackertrigger.progressbar))
		{
			hackertrigger.progressbar hud::destroyelem();
			hackertrigger.progresstext hud::destroyelem();
		}
		hackertrigger delete();
	}
	if(isdefined(hatchetpickuptrigger))
	{
		hatchetpickuptrigger delete();
	}
	if(isdefined(enemytrigger))
	{
		enemytrigger delete();
	}
}

/*
	Name: watchusetrigger
	Namespace: weaponobjects
	Checksum: 0xA88D1CBE
	Offset: 0xA0D8
	Size: 0x25A
	Parameters: 4
	Flags: Linked
*/
function watchusetrigger(trigger, callback, playersoundonuse, npcsoundonuse)
{
	self endon(#"delete");
	self endon(#"hacked");
	while(true)
	{
		trigger waittill(#"trigger", player);
		if(isdefined(self.detonated) && self.detonated == 1)
		{
			if(isdefined(trigger))
			{
				trigger delete();
			}
			return;
		}
		if(!isalive(player))
		{
			continue;
		}
		if(isdefined(trigger.triggerteam) && player.pers["team"] != trigger.triggerteam)
		{
			continue;
		}
		if(isdefined(trigger.triggerteamignore) && player.team == trigger.triggerteamignore)
		{
			continue;
		}
		if(isdefined(trigger.claimedby) && player != trigger.claimedby)
		{
			continue;
		}
		grenade = player.throwinggrenade;
		weapon = player getcurrentweapon();
		if(weapon.isequipment)
		{
			grenade = 0;
		}
		if(player usebuttonpressed() && !grenade && !player meleebuttonpressed())
		{
			if(isdefined(playersoundonuse))
			{
				player playlocalsound(playersoundonuse);
			}
			if(isdefined(npcsoundonuse))
			{
				player playsound(npcsoundonuse);
			}
			self thread [[callback]](player);
		}
	}
}

/*
	Name: createretrievablehint
	Namespace: weaponobjects
	Checksum: 0xE8D3B64E
	Offset: 0xA340
	Size: 0x6A
	Parameters: 2
	Flags: Linked
*/
function createretrievablehint(name, hint)
{
	retrievehint = spawnstruct();
	retrievehint.name = name;
	retrievehint.hint = hint;
	level.retrievehints[name] = retrievehint;
}

/*
	Name: createhackerhint
	Namespace: weaponobjects
	Checksum: 0xEE07352A
	Offset: 0xA3B8
	Size: 0x6A
	Parameters: 2
	Flags: Linked
*/
function createhackerhint(name, hint)
{
	hackerhint = spawnstruct();
	hackerhint.name = name;
	hackerhint.hint = hint;
	level.hackerhints[name] = hackerhint;
}

/*
	Name: createdestroyhint
	Namespace: weaponobjects
	Checksum: 0xE0EB667B
	Offset: 0xA430
	Size: 0x6A
	Parameters: 2
	Flags: Linked
*/
function createdestroyhint(name, hint)
{
	destroyhint = spawnstruct();
	destroyhint.name = name;
	destroyhint.hint = hint;
	level.destroyhints[name] = destroyhint;
}

/*
	Name: setupreconeffect
	Namespace: weaponobjects
	Checksum: 0x10424D35
	Offset: 0xA4A8
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function setupreconeffect()
{
	if(!isdefined(self))
	{
		return;
	}
	if(self.weapon.shownenemyexplo || self.weapon.shownenemyequip)
	{
		if(isdefined(self.hacked) && self.hacked)
		{
			self clientfield::set("enemyequip", 2);
		}
		else
		{
			self clientfield::set("enemyequip", 1);
		}
	}
}

/*
	Name: useteamequipmentclientfield
	Namespace: weaponobjects
	Checksum: 0x7667216F
	Offset: 0xA548
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function useteamequipmentclientfield(watcher)
{
	if(isdefined(watcher))
	{
		if(!isdefined(watcher.notequipment))
		{
			if(isdefined(self))
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: getwatcherforweapon
	Namespace: weaponobjects
	Checksum: 0x56F47BA6
	Offset: 0xA588
	Size: 0x96
	Parameters: 1
	Flags: Linked
*/
function getwatcherforweapon(weapon)
{
	if(!isdefined(self))
	{
		return undefined;
	}
	if(!isplayer(self))
	{
		return undefined;
	}
	for(i = 0; i < self.weaponobjectwatcherarray.size; i++)
	{
		if(self.weaponobjectwatcherarray[i].weapon != weapon)
		{
			continue;
		}
		return self.weaponobjectwatcherarray[i];
	}
	return undefined;
}

/*
	Name: destroy_other_teams_supplemental_watcher_objects
	Namespace: weaponobjects
	Checksum: 0xD4A3D6CE
	Offset: 0xA628
	Size: 0xEC
	Parameters: 2
	Flags: None
*/
function destroy_other_teams_supplemental_watcher_objects(attacker, weapon)
{
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			if(team == attacker.team)
			{
				continue;
			}
			destroy_supplemental_watcher_objects(attacker, team, weapon);
		}
	}
	destroy_supplemental_watcher_objects(attacker, "free", weapon);
}

/*
	Name: destroy_supplemental_watcher_objects
	Namespace: weaponobjects
	Checksum: 0x99C5D786
	Offset: 0xA720
	Size: 0x17E
	Parameters: 3
	Flags: Linked
*/
function destroy_supplemental_watcher_objects(attacker, team, weapon)
{
	foreach(item in level.supplementalwatcherobjects)
	{
		if(!isdefined(item.weapon))
		{
			continue;
		}
		if(!isdefined(item.owner))
		{
			continue;
		}
		if(isdefined(team) && item.owner.team != team)
		{
			continue;
		}
		else if(item.owner == attacker)
		{
			continue;
		}
		watcher = item.owner getwatcherforweapon(item.weapon);
		if(!isdefined(watcher) || !isdefined(watcher.onsupplementaldetonatecallback))
		{
			continue;
		}
		item thread [[watcher.onsupplementaldetonatecallback]]();
	}
}

/*
	Name: add_supplemental_object
	Namespace: weaponobjects
	Checksum: 0x54675ACA
	Offset: 0xA8A8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function add_supplemental_object(object)
{
	level.supplementalwatcherobjects[level.supplementalwatcherobjects.size] = object;
	object thread watch_supplemental_object_death();
}

/*
	Name: watch_supplemental_object_death
	Namespace: weaponobjects
	Checksum: 0x52B5CA6C
	Offset: 0xA8F0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function watch_supplemental_object_death()
{
	self waittill(#"death");
	arrayremovevalue(level.supplementalwatcherobjects, self);
}

/*
	Name: switch_team
	Namespace: weaponobjects
	Checksum: 0x7B0A97FC
	Offset: 0xA928
	Size: 0x198
	Parameters: 3
	Flags: Linked
*/
function switch_team(entity, watcher, owner)
{
	/#
		self notify(#"stop_disarmthink");
		self endon(#"stop_disarmthink");
		self endon(#"death");
		setdvar("", "");
		while(true)
		{
			wait(0.5);
			devgui_int = getdvarint("");
			if(devgui_int != 0)
			{
				team = "";
				if(isdefined(level.getenemyteam) && isdefined(owner) && isdefined(owner.team))
				{
					team = [[level.getenemyteam]](owner.team);
				}
				if(isdefined(level.devongetormakebot))
				{
					player = [[level.devongetormakebot]](team);
				}
				if(!isdefined(player))
				{
					println("");
					wait(1);
					continue;
				}
				entity itemhacked(watcher, player);
				setdvar("", "");
			}
		}
	#/
}

