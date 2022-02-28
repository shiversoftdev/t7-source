// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_shellshock;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_qrdrone;
#using scripts\mp\killstreaks\_remote_weapons;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_heatseekingmissile;

#namespace dart;

/*
	Name: init
	Namespace: dart
	Checksum: 0x5E2B748D
	Offset: 0x7F8
	Size: 0x254
	Parameters: 0
	Flags: Linked
*/
function init()
{
	killstreaks::register("dart", "dart", "killstreak_dart", "dart_used", &activatedart, 1);
	killstreaks::register_strings("dart", &"KILLSTREAK_DART_EARNED", &"KILLSTREAK_DART_NOT_AVAILABLE", &"KILLSTREAK_DART_INBOUND", undefined, &"KILLSTREAK_DART_HACKED");
	killstreaks::register_dialog("dart", "mpl_killstreak_dart_strt", "dartDialogBundle", "dartPilotDialogBundle", "friendlyDart", "enemyDart", "enemyDartMultiple", "friendlyDartHacked", "enemyDartHacked", "requestDart", "threatDart");
	killstreaks::override_entity_camera_in_demo("dart", 1);
	killstreaks::register_alt_weapon("dart", "killstreak_remote");
	killstreaks::register_alt_weapon("dart", "dart_blade");
	killstreaks::register_alt_weapon("dart", "dart_turret");
	clientfield::register("toplayer", "dart_update_ammo", 1, 2, "int");
	clientfield::register("toplayer", "fog_bank_3", 1, 1, "int");
	remote_weapons::registerremoteweapon("dart", &"", &startdartremotecontrol, &enddartremotecontrol, 1);
	visionset_mgr::register_info("visionset", "dart_visionset", 1, 90, 16, 1, &visionset_mgr::ramp_in_out_thread_per_player_death_shutdown, 0);
}

/*
	Name: wait_dart_timed_out
	Namespace: dart
	Checksum: 0xB767C07D
	Offset: 0xA58
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function wait_dart_timed_out(time)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"dart_throw_failed");
	self endon(#"dart_entered");
	wait(time);
	self notify(#"dart_throw_timed_out");
}

/*
	Name: wait_for_throw_status
	Namespace: dart
	Checksum: 0x907E2727
	Offset: 0xAB0
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function wait_for_throw_status()
{
	thread wait_dart_timed_out(5);
	notifystring = self util::waittill_any_return("death", "disconnect", "dart_entered", "dart_throw_timed_out", "dart_throw_failed");
	if(notifystring == "dart_entered" || notifystring == "death")
	{
		return true;
	}
	return false;
}

/*
	Name: activatedart
	Namespace: dart
	Checksum: 0x8BD11924
	Offset: 0xB48
	Size: 0x24C
	Parameters: 1
	Flags: Linked
*/
function activatedart(killstreaktype)
{
	player = self;
	/#
		assert(isplayer(player));
	#/
	if(!player killstreakrules::iskillstreakallowed("dart", player.team))
	{
		return 0;
	}
	player disableoffhandweapons();
	missileweapon = player getcurrentweapon();
	if(!(isdefined(missileweapon) && (missileweapon.name == "dart" || missileweapon.name == "inventory_dart")))
	{
		return 0;
	}
	player thread watchthrow(missileweapon);
	notifystring = player util::waittill_any_return("weapon_change", "grenade_fire", "death", "disconnect", "joined_team", "emp_jammed", "emp_grenaded");
	if(notifystring == "death" || notifystring == "emp_jammed" || notifystring == "emp_grenaded")
	{
		if(player.waitingondartthrow)
		{
			player notify(#"dart_putaway");
		}
		player enableoffhandweapons();
		return 0;
	}
	if(notifystring == "grenade_fire")
	{
		return player wait_for_throw_status();
	}
	if(notifystring == "weapon_change")
	{
		if(player.waitingondartthrow)
		{
			player notify(#"dart_putaway");
		}
		player enableoffhandweapons();
		return 0;
	}
	return 1;
}

/*
	Name: cleanup_grenade
	Namespace: dart
	Checksum: 0x6A6F17D0
	Offset: 0xDA0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function cleanup_grenade()
{
	self thread waitthendelete(0.05);
	self.origin = self.origin + vectorscale((0, 0, 1), 1000);
}

/*
	Name: watchthrow
	Namespace: dart
	Checksum: 0x14FAFC2A
	Offset: 0xDF0
	Size: 0x314
	Parameters: 1
	Flags: Linked
*/
function watchthrow(missileweapon)
{
	/#
		assert(isplayer(self));
	#/
	player = self;
	playerentnum = player.entnum;
	player endon(#"disconnect");
	player endon(#"joined_team");
	player endon(#"dart_putaway");
	level endon(#"game_ended");
	player.waitingondartthrow = 1;
	player waittill(#"grenade_fire", grenade, weapon);
	player.waitingondartthrow = 0;
	if(weapon != missileweapon)
	{
		self notify(#"dart_throw_failed");
		return;
	}
	trace = player check_launch_space(grenade.origin);
	if(trace["fraction"] < 1)
	{
		self iprintlnbold(&"KILLSTREAK_DART_NOT_AVAILABLE");
		grenade cleanup_grenade();
		self notify(#"dart_throw_failed");
		return;
	}
	killstreak_id = player killstreakrules::killstreakstart("dart", player.team, undefined, 0);
	if(killstreak_id == -1)
	{
		grenade cleanup_grenade();
		self notify(#"dart_throw_failed");
		return;
	}
	player.dart_thrown_time = gettime();
	player takeweapon(missileweapon);
	player killstreaks::set_killstreak_delay_killcam("dart");
	player.resurrect_not_allowed_by = "dart";
	player addweaponstat(getweapon("dart"), "used", 1);
	level thread popups::displaykillstreakteammessagetoall("dart", player);
	dart = player spawndart(grenade, killstreak_id, trace["position"]);
	if(isdefined(dart))
	{
		player killstreaks::play_killstreak_start_dialog("dart", player.team, killstreak_id);
	}
}

/*
	Name: hackedprefunction
	Namespace: dart
	Checksum: 0xD451B56
	Offset: 0x1110
	Size: 0x16C
	Parameters: 1
	Flags: Linked
*/
function hackedprefunction(hacker)
{
	dart = self;
	dart.owner util::freeze_player_controls(0);
	visionset_mgr::deactivate("visionset", "dart_visionset", dart.owner);
	dart.owner clientfield::set_to_player("fog_bank_3", 0);
	dart.owner unlink();
	dart clientfield::set("vehicletransition", 0);
	dart.owner killstreaks::clear_using_remote();
	dart.owner killstreaks::unhide_compass();
	dart.owner vehicle::stop_monitor_missiles_locked_on_to_me();
	dart.owner vehicle::stop_monitor_damage_as_occupant();
	dart disabledartmissilelocking();
}

/*
	Name: hackedpostfunction
	Namespace: dart
	Checksum: 0x4528778A
	Offset: 0x1288
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function hackedpostfunction(hacker)
{
	dart = self;
	hacker startdartremotecontrol(dart);
	hacker killstreak_hacking::set_vehicle_drivable_time_starting_now(dart);
	hacker remote_weapons::useremoteweapon(dart, "dart", 0);
	hacker killstreaks::set_killstreak_delay_killcam("dart");
}

/*
	Name: dart_hacked_health_update
	Namespace: dart
	Checksum: 0x924639EC
	Offset: 0x1320
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function dart_hacked_health_update(hacker)
{
	dart = self;
	if(dart.health > dart.hackedhealth)
	{
		dart.health = dart.hackedhealth;
	}
}

/*
	Name: check_launch_space
	Namespace: dart
	Checksum: 0xB7E1234F
	Offset: 0x1380
	Size: 0xCA
	Parameters: 1
	Flags: Linked
*/
function check_launch_space(origin)
{
	player_angles = self getplayerangles();
	forward = anglestoforward(player_angles);
	spawn_origin = origin + vectorscale(forward, 50);
	radius = 10;
	return physicstrace(origin, spawn_origin, (radius * -1, radius * -1, 0), (radius, radius, 2 * radius), self, 1);
}

/*
	Name: spawndart
	Namespace: dart
	Checksum: 0x4193EDAC
	Offset: 0x1458
	Size: 0x538
	Parameters: 3
	Flags: Linked
*/
function spawndart(grenade, killstreak_id, spawn_origin)
{
	player = self;
	/#
		assert(isplayer(player));
	#/
	playerentnum = player.entnum;
	player_angles = player getplayerangles();
	grenade cleanup_grenade();
	params = level.killstreakbundle["dart"];
	if(!isdefined(params.ksdartvehicle))
	{
		params.ksdartvehicle = "veh_dart_mp";
	}
	if(!isdefined(params.ksdartinitialspeed))
	{
		params.ksdartinitialspeed = 35;
	}
	if(!isdefined(params.ksdartacceleration))
	{
		params.ksdartacceleration = 35;
	}
	dart = spawnvehicle(params.ksdartvehicle, spawn_origin, player_angles, "dynamic_spawn_ai");
	dart.is_shutting_down = 0;
	dart.team = player.team;
	dart setspeedimmediate(params.ksdartinitialspeed, params.ksdartacceleration);
	dart.maxhealth = killstreak_bundles::get_max_health("dart");
	dart.health = dart.maxhealth;
	dart.hackedhealth = killstreak_bundles::get_hacked_health("dart");
	dart.hackedhealthupdatecallback = &dart_hacked_health_update;
	dart killstreaks::configure_team("dart", killstreak_id, player, "small_vehicle");
	dart killstreak_hacking::enable_hacking("dart", &hackedprefunction, &hackedpostfunction);
	dart clientfield::set("enemyvehicle", 1);
	dart.killstreak_id = killstreak_id;
	dart.hardpointtype = "dart";
	dart thread killstreaks::waitfortimeout("dart", 30000, &stop_remote_weapon, "remote_weapon_end", "death");
	dart hacker_tool::registerwithhackertool(50, 2000);
	dart.overridevehicledamage = &dartdamageoverride;
	dart.detonateviaemp = &emp_damage_cb;
	dart.do_scripted_crash = 0;
	dart.delete_on_death = 1;
	dart.one_remote_use = 1;
	dart.vehcheckforpredictedcrash = 1;
	dart.predictedcollisiontime = 0.2;
	dart.glasscollision_alt = 1;
	dart.damagetaken = 0;
	dart.death_enter_cb = &waitremotecontrol;
	target_set(dart);
	dart vehicle::init_target_group();
	dart vehicle::add_to_target_group(dart);
	dart thread watchcollision();
	dart thread watchdeath();
	dart thread watchownernondeathevents();
	dart.forcewaitremotecontrol = 1;
	player util::waittill_any("weapon_change", "death");
	player remote_weapons::useremoteweapon(dart, "dart", 1, 1, 1);
	player notify(#"dart_entered");
	return dart;
}

/*
	Name: debug_origin
	Namespace: dart
	Checksum: 0x245A88D6
	Offset: 0x1998
	Size: 0x58
	Parameters: 0
	Flags: None
*/
function debug_origin()
{
	self endon(#"death");
	while(true)
	{
		/#
			sphere(self.origin, 5, (1, 0, 0), 1, 1, 2, 120);
		#/
		wait(0.05);
	}
}

/*
	Name: waitremotecontrol
	Namespace: dart
	Checksum: 0x34A4F797
	Offset: 0x19F8
	Size: 0xF2
	Parameters: 0
	Flags: Linked
*/
function waitremotecontrol()
{
	dart = self;
	remote_controlled = isdefined(dart.control_initiated) && dart.control_initiated || (isdefined(dart.controlled) && dart.controlled);
	if(remote_controlled)
	{
		notifystring = dart util::waittill_any_return("remote_weapon_end", "dart_left");
		if(isdefined(notifystring))
		{
			if(notifystring == "remote_weapon_end")
			{
				dart waittill(#"dart_left");
			}
			else
			{
				dart waittill(#"remote_weapon_end");
			}
		}
	}
	else
	{
		dart waittill(#"dart_left");
	}
}

/*
	Name: startdartremotecontrol
	Namespace: dart
	Checksum: 0xF99DDC1D
	Offset: 0x1AF8
	Size: 0x23C
	Parameters: 1
	Flags: Linked
*/
function startdartremotecontrol(dart)
{
	player = self;
	/#
		assert(isplayer(player));
	#/
	if(!dart.is_shutting_down)
	{
		player.dart_thrown_time = undefined;
		dart usevehicle(player, 0);
		player.resurrect_not_allowed_by = undefined;
		dart clientfield::set("vehicletransition", 1);
		dart thread watchammo();
		dart thread vehicle::monitor_missiles_locked_on_to_me(player);
		dart thread vehicle::monitor_damage_as_occupant(player);
		player vehicle::set_vehicle_drivable_time_starting_now(30000);
		player.no_fade2black = 1;
		dart.inheliproximity = 0;
		minheightoverride = undefined;
		minz_struct = struct::get("vehicle_oob_minz", "targetname");
		if(isdefined(minz_struct))
		{
			minheightoverride = minz_struct.origin[2];
		}
		dart thread qrdrone::qrdrone_watch_distance(2000, minheightoverride);
		dart.distance_shutdown_override = &dartdistancefailure;
		dart enabledartmissilelocking();
		visionset_mgr::activate("visionset", "dart_visionset", self, 1, 90000, 1);
		player clientfield::set_to_player("fog_bank_3", 1);
	}
}

/*
	Name: enddartremotecontrol
	Namespace: dart
	Checksum: 0x1F530DEC
	Offset: 0x1D40
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function enddartremotecontrol(dart, exitrequestedbyowner)
{
	dart thread leave_dart();
}

/*
	Name: dartdistancefailure
	Namespace: dart
	Checksum: 0x9FB65301
	Offset: 0x1D78
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function dartdistancefailure()
{
	thread stop_remote_weapon();
}

/*
	Name: stop_remote_weapon
	Namespace: dart
	Checksum: 0x9C5C942
	Offset: 0x1D98
	Size: 0x18C
	Parameters: 2
	Flags: Linked
*/
function stop_remote_weapon(attacker, weapon)
{
	dart = self;
	dart.detonateviaemp = undefined;
	attacker = self [[level.figure_out_attacker]](attacker);
	if(isdefined(attacker) && (!isdefined(dart.owner) || dart.owner util::isenemyplayer(attacker)))
	{
		challenges::destroyedaircraft(attacker, weapon, 1);
		attacker challenges::addflyswatterstat(weapon, self);
		scoreevents::processscoreevent("destroyed_dart", attacker, dart.owner, weapon);
		luinotifyevent(&"player_callout", 2, &"KILLSTREAK_DESTROYED_DART", attacker.entnum);
	}
	if(isdefined(attacker) && attacker != dart.owner)
	{
		dart killstreaks::play_destroyed_dialog_on_owner("dart", dart.killstreak_id);
	}
	dart thread remote_weapons::endremotecontrolweaponuse(0);
}

/*
	Name: dartdamageoverride
	Namespace: dart
	Checksum: 0x8FE941B1
	Offset: 0x1F30
	Size: 0x154
	Parameters: 15
	Flags: Linked
*/
function dartdamageoverride(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	dart = self;
	if(smeansofdeath == "MOD_TRIGGER_HURT" || (isdefined(dart.is_shutting_down) && dart.is_shutting_down))
	{
		return 0;
	}
	player = dart.owner;
	idamage = killstreaks::ondamageperweapon("dart", eattacker, idamage, idflags, smeansofdeath, weapon, self.maxhealth, &stop_remote_weapon, self.maxhealth * 0.4, undefined, 0, &emp_damage_cb, 1, 1);
	return idamage;
}

/*
	Name: emp_damage_cb
	Namespace: dart
	Checksum: 0xFC09F7E3
	Offset: 0x2090
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function emp_damage_cb(attacker, weapon)
{
	dart = self;
	dart stop_remote_weapon(attacker, weapon);
}

/*
	Name: darpredictedcollision
	Namespace: dart
	Checksum: 0x3264F7CA
	Offset: 0x20E0
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function darpredictedcollision()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"veh_predictedcollision", velocity, normal, ent, stype);
		self notify(#"veh_collision", velocity, normal, ent, stype);
		if(stype == "glass")
		{
			continue;
		}
		else
		{
			break;
		}
	}
}

/*
	Name: watchcollision
	Namespace: dart
	Checksum: 0x55C3DE3A
	Offset: 0x2180
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function watchcollision()
{
	dart = self;
	dart endon(#"death");
	dart.owner endon(#"disconnect");
	dart thread darpredictedcollision();
	while(true)
	{
		dart waittill(#"veh_collision", velocity, normal, ent, stype);
		if(stype === "glass")
		{
			continue;
		}
		dart setspeedimmediate(0);
		dart vehicle_death::death_fx();
		dart thread stop_remote_weapon();
		break;
	}
}

/*
	Name: watchdeath
	Namespace: dart
	Checksum: 0x1898584B
	Offset: 0x2288
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function watchdeath()
{
	dart = self;
	player = dart.owner;
	player endon(#"dart_entered");
	dart endon(#"delete");
	dart waittill(#"death");
	dart thread leave_dart();
}

/*
	Name: watchownernondeathevents
	Namespace: dart
	Checksum: 0x9DF30AF7
	Offset: 0x2300
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function watchownernondeathevents(endcondition1, endcondition2)
{
	dart = self;
	player = dart.owner;
	player endon(#"dart_entered");
	dart endon(#"death");
	dart thread watchforgameend();
	player util::waittill_any("joined_team", "disconnect", "joined_spectators", "emp_jammed");
	dart thread leave_dart();
}

/*
	Name: watchforgameend
	Namespace: dart
	Checksum: 0x7D1B2F4F
	Offset: 0x23C8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function watchforgameend()
{
	dart = self;
	dart endon(#"death");
	level waittill(#"game_ended");
	dart thread leave_dart();
}

/*
	Name: watchammo
	Namespace: dart
	Checksum: 0xE6005F80
	Offset: 0x2418
	Size: 0x258
	Parameters: 0
	Flags: Linked
*/
function watchammo()
{
	dart = self;
	dart endon(#"death");
	player = dart.owner;
	player endon(#"disconnect");
	shotcount = 0;
	params = level.killstreakbundle["dart"];
	if(!isdefined(params.ksdartshotcount))
	{
		params.ksdartshotcount = 3;
	}
	if(!isdefined(params.ksdartbladecount))
	{
		params.ksdartbladecount = 6;
	}
	if(!isdefined(params.ksdartwaittimeafterlastshot))
	{
		params.ksdartwaittimeafterlastshot = 1;
	}
	if(!isdefined(params.ksbladestartdistance))
	{
		params.ksbladestartdistance = 0;
	}
	if(!isdefined(params.ksbladeenddistance))
	{
		params.ksbladeenddistance = 10000;
	}
	if(!isdefined(params.ksbladestartspreadradius))
	{
		params.ksbladestartspreadradius = 50;
	}
	if(!isdefined(params.ksbladeendspreadradius))
	{
		params.ksbladeendspreadradius = 1;
	}
	player clientfield::set_to_player("dart_update_ammo", params.ksdartshotcount);
	while(true)
	{
		dart waittill(#"weapon_fired");
		shotcount++;
		player clientfield::set_to_player("dart_update_ammo", params.ksdartshotcount - shotcount);
		if(shotcount >= params.ksdartshotcount)
		{
			dart disabledriverfiring(1);
			wait(params.ksdartwaittimeafterlastshot);
			dart stop_remote_weapon();
		}
	}
}

/*
	Name: leave_dart
	Namespace: dart
	Checksum: 0xB95B2A16
	Offset: 0x2678
	Size: 0x7D4
	Parameters: 0
	Flags: Linked
*/
function leave_dart()
{
	dart = self;
	owner = dart.owner;
	if(isdefined(owner))
	{
		visionset_mgr::deactivate("visionset", "dart_visionset", owner);
		owner clientfield::set_to_player("fog_bank_3", 0);
		owner qrdrone::destroyhud();
	}
	if(isdefined(dart) && dart.is_shutting_down == 1)
	{
		return;
	}
	dart.is_shutting_down = 1;
	dart clientfield::set("timeout_beep", 0);
	dart vehicle::lights_off();
	dart vehicle_death::death_fx();
	dart hide();
	dart_original_team = dart.originalteam;
	dart_killstreak_id = dart.killstreak_id;
	if(target_istarget(dart))
	{
		target_remove(dart);
	}
	if(isalive(dart))
	{
		dart notify(#"death");
	}
	params = level.killstreakbundle["dart"];
	if(!isdefined(params.ksdartexplosionouterradius))
	{
		params.ksdartexplosionouterradius = 200;
	}
	if(!isdefined(params.ksdartexplosioninnerradius))
	{
		params.ksdartexplosioninnerradius = 1;
	}
	if(!isdefined(params.ksdartexplosionouterdamage))
	{
		params.ksdartexplosionouterdamage = 25;
	}
	if(!isdefined(params.ksdartexplosioninnerdamage))
	{
		params.ksdartexplosioninnerdamage = 350;
	}
	if(!isdefined(params.ksdartexplosionmagnitude))
	{
		params.ksdartexplosionmagnitude = 1;
	}
	physicsexplosionsphere(dart.origin, params.ksdartexplosionouterradius, params.ksdartexplosioninnerradius, params.ksdartexplosionmagnitude, params.ksdartexplosionouterdamage, params.ksdartexplosioninnerdamage);
	if(isdefined(owner))
	{
		owner killstreaks::set_killstreak_delay_killcam("dart");
		dart radiusdamage(dart.origin, params.ksdartexplosionouterradius, params.ksdartexplosioninnerdamage, params.ksdartexplosionouterdamage, owner, "MOD_EXPLOSIVE", getweapon("dart"));
		owner thread play_bda_dialog(self.pilotindex);
		if(isdefined(dart.controlled) && dart.controlled || (isdefined(dart.control_initiated) && dart.control_initiated))
		{
			owner setclientuivisibilityflag("hud_visible", 0);
			owner unlink();
			dart clientfield::set("vehicletransition", 0);
			if(isdefined(params.ksexplosionrumble))
			{
				owner playrumbleonentity(params.ksexplosionrumble);
			}
			owner vehicle::stop_monitor_missiles_locked_on_to_me();
			owner vehicle::stop_monitor_damage_as_occupant();
			dart disabledartmissilelocking();
			owner util::freeze_player_controls(1);
			forward = anglestoforward(dart.angles);
			if(!isdefined(params.ksdartcamerawatchdistance))
			{
				params.ksdartcamerawatchdistance = 350;
			}
			moveamount = vectorscale(forward, params.ksdartcamerawatchdistance * -1);
			size = 4;
			trace = physicstrace(dart.origin, dart.origin + moveamount, (size * -1, size * -1, size * -1), (size, size, size), undefined, 1);
			cam = spawn("script_model", trace["position"]);
			cam setmodel("tag_origin");
			cam linkto(dart);
			dart setspeedimmediate(0);
			owner camerasetposition(cam.origin);
			owner camerasetlookat(dart.origin);
			owner cameraactivate(1);
			if(!isdefined(params.ksdartcamerawatchduration))
			{
				params.ksdartcamerawatchduration = 2;
			}
			wait(params.ksdartcamerawatchduration);
			if(isdefined(owner))
			{
				owner cameraactivate(0);
			}
			cam delete();
			if(isdefined(owner))
			{
				if(!level.gameended)
				{
					owner util::freeze_player_controls(0);
				}
				owner setclientuivisibilityflag("hud_visible", 1);
			}
		}
		if(isdefined(owner))
		{
			owner killstreaks::reset_killstreak_delay_killcam();
		}
	}
	killstreakrules::killstreakstop("dart", dart_original_team, dart_killstreak_id);
	if(isdefined(dart))
	{
		dart notify(#"dart_left");
	}
}

/*
	Name: deleteonconditions
	Namespace: dart
	Checksum: 0x8638DC99
	Offset: 0x2E58
	Size: 0x64
	Parameters: 1
	Flags: None
*/
function deleteonconditions(condition)
{
	dart = self;
	dart endon(#"delete");
	if(isdefined(condition))
	{
		dart waittill(condition);
	}
	dart notify(#"delete");
	dart delete();
}

/*
	Name: waitthendelete
	Namespace: dart
	Checksum: 0xEA573B45
	Offset: 0x2EC8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function waitthendelete(waittime)
{
	self endon(#"delete");
	self endon(#"death");
	wait(waittime);
	self delete();
}

/*
	Name: play_bda_dialog
	Namespace: dart
	Checksum: 0x7E736BC7
	Offset: 0x2F10
	Size: 0x106
	Parameters: 1
	Flags: Linked
*/
function play_bda_dialog(pilotindex)
{
	self endon(#"game_ended");
	wait(0.5);
	if(!isdefined(self.dartbda) || self.dartbda == 0)
	{
		bdadialog = "killNone";
	}
	else
	{
		if(self.dartbda == 1)
		{
			bdadialog = "kill1";
		}
		else
		{
			if(self.dartbda == 2)
			{
				bdadialog = "kill2";
			}
			else
			{
				if(self.dartbda == 3)
				{
					bdadialog = "kill3";
				}
				else if(self.dartbda > 3)
				{
					bdadialog = "killMultiple";
				}
			}
		}
	}
	self killstreaks::play_pilot_dialog(bdadialog, "dart", undefined, pilotindex);
	self.dartbda = undefined;
}

/*
	Name: enabledartmissilelocking
	Namespace: dart
	Checksum: 0x70E743F4
	Offset: 0x3020
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function enabledartmissilelocking()
{
	dart = self;
	player = dart.owner;
	weapon = dart seatgetweapon(0);
	player.get_stinger_target_override = &getdartmissiletargets;
	player.is_still_valid_target_for_stinger_override = &isstillvaliddartmissiletarget;
	player.is_valid_target_for_stinger_override = &isvaliddartmissiletarget;
	player.dart_killstreak_weapon = weapon;
	player thread heatseekingmissile::stingerirtloop(weapon);
}

/*
	Name: disabledartmissilelocking
	Namespace: dart
	Checksum: 0x574DAA6B
	Offset: 0x30F8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function disabledartmissilelocking()
{
	player = self.owner;
	player.get_stinger_target_override = undefined;
	player.is_still_valid_target_for_stinger_override = undefined;
	player.is_valid_target_for_stinger_override = undefined;
	player.dart_killstreak_weapon = undefined;
	player notify(#"stinger_irt_off");
	player heatseekingmissile::clearirtarget();
}

/*
	Name: getdartmissiletargets
	Namespace: dart
	Checksum: 0xAD709D95
	Offset: 0x3170
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function getdartmissiletargets()
{
	targets = arraycombine(target_getarray(), level.missileentities, 0, 0);
	targets = arraycombine(targets, level.players, 0, 0);
	return targets;
}

/*
	Name: isvaliddartmissiletarget
	Namespace: dart
	Checksum: 0xA869999B
	Offset: 0x31E8
	Size: 0x14E
	Parameters: 1
	Flags: Linked
*/
function isvaliddartmissiletarget(ent)
{
	player = self;
	if(!isdefined(ent))
	{
		return false;
	}
	entisplayer = isplayer(ent);
	if(entisplayer && !isalive(ent))
	{
		return false;
	}
	if(ent.ignoreme === 1)
	{
		return false;
	}
	dart = player getvehicleoccupied();
	if(!isdefined(dart))
	{
		return false;
	}
	if(distancesquared(dart.origin, ent.origin) > (player.dart_killstreak_weapon.lockonmaxrange * player.dart_killstreak_weapon.lockonmaxrange))
	{
		return false;
	}
	if(entisplayer && ent hasperk("specialty_nokillstreakreticle"))
	{
		return false;
	}
	return true;
}

/*
	Name: isstillvaliddartmissiletarget
	Namespace: dart
	Checksum: 0x6D667B69
	Offset: 0x3340
	Size: 0x1C6
	Parameters: 2
	Flags: Linked
*/
function isstillvaliddartmissiletarget(ent, weapon)
{
	player = self;
	if(!(target_istarget(ent) || isplayer(ent)) && (!(isdefined(ent.allowcontinuedlockonafterinvis) && ent.allowcontinuedlockonafterinvis)))
	{
		return false;
	}
	dart = player getvehicleoccupied();
	if(!isdefined(dart))
	{
		return false;
	}
	entisplayer = isplayer(ent);
	if(entisplayer && !isalive(ent))
	{
		return false;
	}
	if(ent.ignoreme === 1)
	{
		return false;
	}
	if(distancesquared(dart.origin, ent.origin) > (player.dart_killstreak_weapon.lockonmaxrange * player.dart_killstreak_weapon.lockonmaxrange))
	{
		return false;
	}
	if(entisplayer && ent hasperk("specialty_nokillstreakreticle"))
	{
		return false;
	}
	if(!heatseekingmissile::insidestingerreticlelocked(ent, weapon))
	{
		return false;
	}
	return true;
}

