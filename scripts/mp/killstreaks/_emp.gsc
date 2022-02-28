// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_placeables;
#using scripts\mp\teams\_teams;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_weaponobjects;

#using_animtree("mp_emp_power_core");

#namespace emp;

/*
	Name: init
	Namespace: emp
	Checksum: 0xDADE4432
	Offset: 0x6A8
	Size: 0x2DC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	bundle = struct::get_script_bundle("killstreak", "killstreak_emp");
	level.empkillstreakbundle = bundle;
	level.activeplayeremps = [];
	level.activeemps = [];
	foreach(team in level.teams)
	{
		level.activeemps[team] = 0;
	}
	level.enemyempactivefunc = &enemyempactive;
	level thread emptracker();
	killstreaks::register("emp", "emp", "killstreak_emp", "emp_used", &activateemp);
	killstreaks::register_strings("emp", &"KILLSTREAK_EARNED_EMP", &"KILLSTREAK_EMP_NOT_AVAILABLE", &"KILLSTREAK_EMP_INBOUND", undefined, &"KILLSTREAK_EMP_HACKED", 0);
	killstreaks::register_dialog("emp", "mpl_killstreak_emp_activate", "empDialogBundle", undefined, "friendlyEmp", "enemyEmp", "enemyEmpMultiple", "friendlyEmpHacked", "enemyEmpHacked", "requestEmp", "threatEmp");
	clientfield::register("scriptmover", "emp_turret_init", 1, 1, "int");
	clientfield::register("vehicle", "emp_turret_deploy", 1, 1, "int");
	spinanim = %mp_emp_power_core::o_turret_emp_core_spin;
	deployanim = %mp_emp_power_core::o_turret_emp_core_deploy;
	callback::on_spawned(&onplayerspawned);
	callback::on_connect(&onplayerconnect);
	vehicle::add_main_callback("emp_turret", &initturretvehicle);
}

/*
	Name: initturretvehicle
	Namespace: emp
	Checksum: 0x745D2AFE
	Offset: 0x990
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function initturretvehicle()
{
	turretvehicle = self;
	turretvehicle killstreaks::setup_health("emp");
	turretvehicle.damagetaken = 0;
	turretvehicle.health = turretvehicle.maxhealth;
	turretvehicle clientfield::set("enemyvehicle", 1);
	turretvehicle.soundmod = "drone_land";
	turretvehicle.overridevehicledamage = &onturretdamage;
	turretvehicle.overridevehicledeath = &onturretdeath;
	target_set(turretvehicle, vectorscale((0, 0, 1), 36));
}

/*
	Name: onplayerspawned
	Namespace: emp
	Checksum: 0x889C859
	Offset: 0xA88
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function onplayerspawned()
{
	self endon(#"disconnect");
	self updateemp();
}

/*
	Name: onplayerconnect
	Namespace: emp
	Checksum: 0x15824918
	Offset: 0xAB8
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect()
{
	self.entnum = self getentitynumber();
	level.activeplayeremps[self.entnum] = 0;
}

/*
	Name: activateemp
	Namespace: emp
	Checksum: 0x6D6296B3
	Offset: 0xB00
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function activateemp()
{
	player = self;
	killstreakid = player killstreakrules::killstreakstart("emp", player.team, 0, 0);
	if(killstreakid == -1)
	{
		return false;
	}
	bundle = level.empkillstreakbundle;
	empbase = player placeables::spawnplaceable("emp", killstreakid, &onplaceemp, &oncancelplacement, undefined, &onshutdown, undefined, undefined, "wpn_t7_turret_emp_core", "wpn_t7_turret_emp_core_yellow", "wpn_t7_turret_emp_core_red", 1, "", undefined, undefined, 0, bundle.ksplaceablehint, bundle.ksplaceableinvalidlocationhint);
	empbase thread util::ghost_wait_show_to_player(player);
	empbase.othermodel thread util::ghost_wait_show_to_others(player);
	empbase clientfield::set("emp_turret_init", 1);
	empbase.othermodel clientfield::set("emp_turret_init", 1);
	event = empbase util::waittill_any_return("placed", "cancelled", "death", "disconnect");
	if(event != "placed")
	{
		return false;
	}
	return true;
}

/*
	Name: onplaceemp
	Namespace: emp
	Checksum: 0xD340D5F6
	Offset: 0xD00
	Size: 0x34C
	Parameters: 1
	Flags: Linked
*/
function onplaceemp(emp)
{
	player = self;
	/#
		assert(isplayer(player));
	#/
	/#
		assert(!isdefined(emp.vehicle));
	#/
	emp.vehicle = spawnvehicle("emp_turret", emp.origin, emp.angles);
	emp.vehicle thread util::ghost_wait_show(0.05);
	emp.vehicle.killstreaktype = emp.killstreaktype;
	emp.vehicle.owner = player;
	emp.vehicle setowner(player);
	emp.vehicle.ownerentnum = player.entnum;
	emp.vehicle.parentstruct = emp;
	player.emptime = gettime();
	player killstreaks::play_killstreak_start_dialog("emp", player.pers["team"], emp.killstreakid);
	player addweaponstat(getweapon("emp"), "used", 1);
	level thread popups::displaykillstreakteammessagetoall("emp", player);
	emp.vehicle killstreaks::configure_team("emp", emp.killstreakid, player);
	emp.vehicle killstreak_hacking::enable_hacking("emp", &hackedcallbackpre, &hackedcallbackpost);
	emp thread killstreaks::waitfortimeout("emp", 60000, &on_timeout, "death");
	if(issentient(emp.vehicle) == 0)
	{
		emp.vehicle makesentient();
	}
	emp.vehicle vehicle::disconnect_paths(0, 0);
	player thread deployempturret(emp);
}

/*
	Name: deployempturret
	Namespace: emp
	Checksum: 0x3F48ED8B
	Offset: 0x1058
	Size: 0x1DC
	Parameters: 1
	Flags: Linked
*/
function deployempturret(emp)
{
	player = self;
	player endon(#"disconnect");
	player endon(#"joined_team");
	player endon(#"joined_spectators");
	emp endon(#"death");
	emp.vehicle useanimtree($mp_emp_power_core);
	emp.vehicle setanim(%mp_emp_power_core::o_turret_emp_core_deploy, 1);
	length = getanimlength(%mp_emp_power_core::o_turret_emp_core_deploy);
	emp.vehicle clientfield::set("emp_turret_deploy", 1);
	wait(length * 0.75);
	emp.vehicle thread playempfx();
	emp.vehicle playsound("mpl_emp_turret_activate");
	emp.vehicle setanim(%mp_emp_power_core::o_turret_emp_core_spin, 1);
	player thread emp_jamenemies(emp, 0);
	wait(length * 0.25);
	emp.vehicle clearanim(%mp_emp_power_core::o_turret_emp_core_deploy, 0);
}

/*
	Name: hackedcallbackpre
	Namespace: emp
	Checksum: 0x72B7733F
	Offset: 0x1240
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function hackedcallbackpre(hacker)
{
	emp_vehicle = self;
	emp_vehicle clientfield::set("enemyvehicle", 2);
	emp_vehicle.parentstruct killstreaks::configure_team("emp", emp_vehicle.parentstruct.killstreakid, hacker, undefined, undefined, undefined, 1);
}

/*
	Name: hackedcallbackpost
	Namespace: emp
	Checksum: 0x6E3BB1BF
	Offset: 0x12D0
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function hackedcallbackpost(hacker)
{
	emp_vehicle = self;
	hacker thread emp_jamenemies(emp_vehicle.parentstruct, 1);
}

/*
	Name: doneempfx
	Namespace: emp
	Checksum: 0xC471D655
	Offset: 0x1320
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function doneempfx(fxtagorigin)
{
	playfx("killstreaks/fx_emp_exp_death", fxtagorigin);
	playsoundatposition("mpl_emp_turret_deactivate", fxtagorigin);
}

/*
	Name: playempfx
	Namespace: emp
	Checksum: 0x849433C6
	Offset: 0x1378
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function playempfx()
{
	emp_vehicle = self;
	emp_vehicle playloopsound("mpl_emp_turret_loop_close");
	wait(0.05);
}

/*
	Name: on_timeout
	Namespace: emp
	Checksum: 0xC4F519ED
	Offset: 0x13C0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function on_timeout()
{
	emp = self;
	if(isdefined(emp.vehicle))
	{
		fxtagorigin = emp.vehicle gettagorigin("tag_fx");
		doneempfx(fxtagorigin);
	}
	shutdownemp(emp);
}

/*
	Name: oncancelplacement
	Namespace: emp
	Checksum: 0x589FA470
	Offset: 0x1450
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function oncancelplacement(emp)
{
	stopemp(emp.team, emp.ownerentnum, emp.originalteam, emp.killstreakid);
}

/*
	Name: onturretdamage
	Namespace: emp
	Checksum: 0x5D845760
	Offset: 0x14A8
	Size: 0x158
	Parameters: 15
	Flags: Linked
*/
function onturretdamage(einflictor, attacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	empdamage = 0;
	idamage = self killstreaks::ondamageperweapon("emp", attacker, idamage, idflags, smeansofdeath, weapon, self.maxhealth, undefined, self.maxhealth * 0.4, undefined, empdamage, undefined, 1, 1);
	self.damagetaken = self.damagetaken + idamage;
	if(self.damagetaken > self.maxhealth && !isdefined(self.will_die))
	{
		self.will_die = 1;
		self thread ondeathafterframeend(attacker, weapon);
	}
	return idamage;
}

/*
	Name: onturretdeath
	Namespace: emp
	Checksum: 0x3DA8DD63
	Offset: 0x1608
	Size: 0x64
	Parameters: 8
	Flags: Linked
*/
function onturretdeath(inflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	self ondeath(attacker, weapon);
}

/*
	Name: ondeathafterframeend
	Namespace: emp
	Checksum: 0xE1595E7D
	Offset: 0x1678
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function ondeathafterframeend(attacker, weapon)
{
	waittillframeend();
	if(isdefined(self))
	{
		self ondeath(attacker, weapon);
	}
}

/*
	Name: ondeath
	Namespace: emp
	Checksum: 0x8D4E2DE6
	Offset: 0x16C0
	Size: 0x22C
	Parameters: 2
	Flags: Linked
*/
function ondeath(attacker, weapon)
{
	emp_vehicle = self;
	fxtagorigin = self gettagorigin("tag_fx");
	doneempfx(fxtagorigin);
	if(isdefined(attacker) && isplayer(attacker) && (!isdefined(emp_vehicle.owner) || emp_vehicle.owner util::isenemyplayer(attacker)))
	{
		attacker challenges::destroyscorestreak(weapon, 0, 1, 0);
		attacker challenges::destroynonairscorestreak_poststatslock(weapon);
		attacker addplayerstat("destroy_turret", 1);
		attacker addweaponstat(weapon, "destroy_turret", 1);
		scoreevents::processscoreevent("destroyed_emp", attacker, emp_vehicle.owner, weapon);
		luinotifyevent(&"player_callout", 2, &"KILLSTREAK_DESTROYED_EMP", attacker.entnum);
	}
	if(isdefined(attacker) && isdefined(emp_vehicle.owner) && attacker != emp_vehicle.owner)
	{
		emp_vehicle killstreaks::play_destroyed_dialog_on_owner("emp", emp_vehicle.parentstruct.killstreakid);
	}
	shutdownemp(emp_vehicle.parentstruct);
}

/*
	Name: onshutdown
	Namespace: emp
	Checksum: 0x5797D9AD
	Offset: 0x18F8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function onshutdown(emp)
{
	shutdownemp(emp);
}

/*
	Name: shutdownemp
	Namespace: emp
	Checksum: 0xAC2607DB
	Offset: 0x1928
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function shutdownemp(emp)
{
	if(!isdefined(emp))
	{
		return;
	}
	if(isdefined(emp.already_shutdown))
	{
		return;
	}
	emp.already_shutdown = 1;
	if(isdefined(emp.vehicle))
	{
		emp.vehicle clientfield::set("emp_turret_deploy", 0);
	}
	stopemp(emp.team, emp.ownerentnum, emp.originalteam, emp.killstreakid);
	if(isdefined(emp.othermodel))
	{
		emp.othermodel delete();
	}
	if(isdefined(emp.vehicle))
	{
		emp.vehicle delete();
	}
	emp delete();
}

/*
	Name: stopemp
	Namespace: emp
	Checksum: 0x6BCEE5BF
	Offset: 0x1A68
	Size: 0x54
	Parameters: 4
	Flags: Linked
*/
function stopemp(currentteam, currentownerentnum, originalteam, killstreakid)
{
	stopempeffect(currentteam, currentownerentnum);
	stopemprule(originalteam, killstreakid);
}

/*
	Name: stopempeffect
	Namespace: emp
	Checksum: 0xBF2A633B
	Offset: 0x1AC8
	Size: 0x42
	Parameters: 2
	Flags: Linked
*/
function stopempeffect(team, ownerentnum)
{
	level.activeemps[team] = 0;
	level.activeplayeremps[ownerentnum] = 0;
	level notify(#"emp_updated");
}

/*
	Name: stopemprule
	Namespace: emp
	Checksum: 0xA7BCC1BE
	Offset: 0x1B18
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function stopemprule(killstreakoriginalteam, killstreakid)
{
	killstreakrules::killstreakstop("emp", killstreakoriginalteam, killstreakid);
}

/*
	Name: hasactiveemp
	Namespace: emp
	Checksum: 0x2BF3AB27
	Offset: 0x1B58
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function hasactiveemp()
{
	return level.activeplayeremps[self.entnum];
}

/*
	Name: teamhasactiveemp
	Namespace: emp
	Checksum: 0xC881F687
	Offset: 0x1B78
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function teamhasactiveemp(team)
{
	return level.activeemps[team] > 0;
}

/*
	Name: enemyempactive
	Namespace: emp
	Checksum: 0x52BCDFA4
	Offset: 0x1BA0
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function enemyempactive()
{
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			if(team != self.team && teamhasactiveemp(team))
			{
				return true;
			}
		}
	}
	else
	{
		enemies = self teams::getenemyplayers();
		foreach(player in enemies)
		{
			if(player hasactiveemp())
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: enemyempowner
	Namespace: emp
	Checksum: 0x3169DB1B
	Offset: 0x1D10
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function enemyempowner()
{
	enemies = self teams::getenemyplayers();
	foreach(player in enemies)
	{
		if(player hasactiveemp())
		{
			return player;
		}
	}
	return undefined;
}

/*
	Name: emp_jamenemies
	Namespace: emp
	Checksum: 0x20DA5E81
	Offset: 0x1DD0
	Size: 0x1B4
	Parameters: 2
	Flags: Linked
*/
function emp_jamenemies(empent, hacked)
{
	level endon(#"game_ended");
	self endon(#"killstreak_hacked");
	if(level.teambased)
	{
		if(hacked)
		{
			level.activeemps[empent.originalteam] = 0;
		}
		level.activeemps[self.team] = 1;
	}
	if(hacked)
	{
		level.activeplayeremps[empent.originalownerentnum] = 0;
	}
	level.activeplayeremps[self.entnum] = 1;
	level notify(#"emp_updated");
	level notify(#"emp_deployed");
	visionsetnaked("flash_grenade", 1.5);
	wait(0.1);
	visionsetnaked("flash_grenade", 0);
	visionsetnaked(getdvarstring("mapname"), 5);
	empkillstreakweapon = getweapon("emp");
	empkillstreakweapon.isempkillstreak = 1;
	level killstreaks::destroyotherteamsactivevehicles(self, empkillstreakweapon);
	level killstreaks::destroyotherteamsequipment(self, empkillstreakweapon);
	level weaponobjects::destroy_other_teams_supplemental_watcher_objects(self, empkillstreakweapon);
}

/*
	Name: emptracker
	Namespace: emp
	Checksum: 0xDCD703C7
	Offset: 0x1F90
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function emptracker()
{
	level endon(#"game_ended");
	while(true)
	{
		level waittill(#"emp_updated");
		foreach(player in level.players)
		{
			player updateemp();
		}
	}
}

/*
	Name: updateemp
	Namespace: emp
	Checksum: 0xC2622160
	Offset: 0x2048
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function updateemp()
{
	player = self;
	enemy_emp_active = player enemyempactive();
	player setempjammed(enemy_emp_active);
	emped = player isempjammed();
	player clientfield::set_to_player("empd_monitor_distance", emped);
	if(emped)
	{
		player notify(#"emp_jammed");
	}
}

