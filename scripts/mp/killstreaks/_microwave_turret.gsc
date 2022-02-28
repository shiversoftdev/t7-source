// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_placeables;
#using scripts\mp\killstreaks\_remote_weapons;
#using scripts\mp\killstreaks\_turret;
#using scripts\mp\teams\_teams;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_weaponobjects;

#using_animtree("mp_microwaveturret");

#namespace microwave_turret;

/*
	Name: init
	Namespace: microwave_turret
	Checksum: 0x5964803C
	Offset: 0x970
	Size: 0x23C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	killstreaks::register("microwave_turret", "microwave_turret_deploy", "killstreak_" + "microwave_turret", "microwave_turret" + "_used", &activatemicrowaveturret, 0, 1);
	killstreaks::register_strings("microwave_turret", &"KILLSTREAK_EARNED_MICROWAVE_TURRET", &"KILLSTREAK_MICROWAVE_TURRET_NOT_AVAILABLE", &"KILLSTREAK_MICROWAVE_TURRET_INBOUND", undefined, &"KILLSTREAK_MICROWAVE_TURRET_HACKED", 0);
	killstreaks::register_dialog("microwave_turret", "mpl_killstreak_turret", "microwaveTurretDialogBundle", undefined, "friendlyMicrowaveTurret", "enemyMicrowaveTurret", "enemyMicrowaveTurretMultiple", "friendlyMicrowaveTurretHacked", "enemyMicrowaveTurretHacked", "requestMicrowaveTurret", "threatMicrowaveTurret");
	killstreaks::register_remote_override_weapon("microwave_turret", "microwave_turret");
	level.microwaveopenanim = %mp_microwaveturret::o_turret_guardian_open;
	level.microwavecloseanim = %mp_microwaveturret::o_turret_guardian_close;
	clientfield::register("vehicle", "turret_microwave_open", 1, 1, "int");
	clientfield::register("scriptmover", "turret_microwave_init", 1, 1, "int");
	clientfield::register("scriptmover", "turret_microwave_close", 1, 1, "int");
	vehicle::add_main_callback("microwave_turret", &initturretvehicle);
	callback::on_spawned(&on_player_spawned);
	callback::on_vehicle_spawned(&on_vehicle_spawned);
}

/*
	Name: initturretvehicle
	Namespace: microwave_turret
	Checksum: 0xADA05FE9
	Offset: 0xBB8
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function initturretvehicle()
{
	turretvehicle = self;
	turretvehicle killstreaks::setup_health("microwave_turret");
	turretvehicle.damagetaken = 0;
	turretvehicle.deal_no_crush_damage = 1;
	turretvehicle.health = turretvehicle.maxhealth;
	turretvehicle turret::set_max_target_distance(750 * 1.2, 0);
	turretvehicle turret::set_on_target_angle(15, 0);
	turretvehicle clientfield::set("enemyvehicle", 1);
	turretvehicle.soundmod = "hpm";
	turretvehicle.overridevehicledamage = &onturretdamage;
	turretvehicle.overridevehicledeath = &onturretdeath;
	turretvehicle.overridevehicledeathpostgame = &onturretdeathpostgame;
	turretvehicle.aim_only_no_shooting = 1;
}

/*
	Name: on_player_spawned
	Namespace: microwave_turret
	Checksum: 0xF5FEBB9C
	Offset: 0xD10
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self reset_being_microwaved();
}

/*
	Name: on_vehicle_spawned
	Namespace: microwave_turret
	Checksum: 0xD795ACC2
	Offset: 0xD38
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_vehicle_spawned()
{
	self reset_being_microwaved();
}

/*
	Name: reset_being_microwaved
	Namespace: microwave_turret
	Checksum: 0xB875DF0
	Offset: 0xD60
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function reset_being_microwaved()
{
	self.lastmicrowavedby = undefined;
	self.beingmicrowavedby = undefined;
}

/*
	Name: activatemicrowaveturret
	Namespace: microwave_turret
	Checksum: 0x3DB8207B
	Offset: 0xD80
	Size: 0x2C8
	Parameters: 0
	Flags: Linked
*/
function activatemicrowaveturret()
{
	player = self;
	/#
		assert(isplayer(player));
	#/
	killstreakid = self killstreakrules::killstreakstart("microwave_turret", player.team, 0, 0);
	if(killstreakid == -1)
	{
		return false;
	}
	bundle = level.killstreakbundle["microwave_turret"];
	turret = player placeables::spawnplaceable("microwave_turret", killstreakid, &onplaceturret, &oncancelplacement, &onpickupturret, &onshutdown, undefined, &onemp, "veh_t7_turret_guardian", "veh_t7_turret_guardian_yellow", "veh_t7_turret_guardian_red", 1, &"KILLSTREAK_MICROWAVE_TURRET_PICKUP", 90000, undefined, 1800 + 1, bundle.ksplaceablehint, bundle.ksplaceableinvalidlocationhint);
	turret killstreaks::setup_health("microwave_turret");
	turret.damagetaken = 0;
	turret.killstreakendtime = gettime() + 90000;
	turret thread watchkillstreakend(killstreakid, player.team);
	turret thread util::ghost_wait_show_to_player(player);
	turret.othermodel thread util::ghost_wait_show_to_others(player);
	turret clientfield::set("turret_microwave_init", 1);
	turret.othermodel clientfield::set("turret_microwave_init", 1);
	event = turret util::waittill_any_return("placed", "cancelled", "death", "disconnect");
	if(event != "placed")
	{
		return false;
	}
	return true;
}

/*
	Name: onplaceturret
	Namespace: microwave_turret
	Checksum: 0xE5113736
	Offset: 0x1050
	Size: 0x424
	Parameters: 1
	Flags: Linked
*/
function onplaceturret(turret)
{
	player = self;
	/#
		assert(isplayer(player));
	#/
	if(isdefined(turret.vehicle))
	{
		turret.vehicle.origin = turret.origin;
		turret.vehicle.angles = turret.angles;
		turret.vehicle thread util::ghost_wait_show(0.05);
	}
	else
	{
		turret.vehicle = spawnvehicle("microwave_turret", turret.origin, turret.angles, "dynamic_spawn_ai");
		turret.vehicle.owner = player;
		turret.vehicle setowner(player);
		turret.vehicle.ownerentnum = player.entnum;
		turret.vehicle.parentstruct = turret;
		turret.vehicle.team = player.team;
		turret.vehicle setteam(player.team);
		turret.vehicle turret::set_team(player.team, 0);
		turret.vehicle.ignore_vehicle_underneath_splash_scalar = 1;
		turret.vehicle.use_non_teambased_enemy_selection = 1;
		turret.vehicle.turret = turret;
		turret.vehicle thread util::ghost_wait_show(0.05);
		level thread popups::displaykillstreakteammessagetoall("microwave_turret", player);
		player addweaponstat(getweapon("microwave_turret"), "used", 1);
		turret.vehicle killstreaks::configure_team("microwave_turret", turret.killstreakid, player);
		turret.vehicle killstreak_hacking::enable_hacking("microwave_turret", &hackedprefunction, &hackedpostfunction);
		player killstreaks::play_killstreak_start_dialog("microwave_turret", player.pers["team"], turret.killstreakid);
	}
	turret.vehicle turret::enable(0, 0);
	target_set(turret.vehicle, vectorscale((0, 0, 1), 36));
	turret.vehicle vehicle::disconnect_paths(0, 0);
	turret startmicrowave();
}

/*
	Name: hackedprefunction
	Namespace: microwave_turret
	Checksum: 0xD89A2A45
	Offset: 0x1480
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function hackedprefunction(hacker)
{
	turretvehicle = self;
	turretvehicle.turret notify(#"hacker_delete_placeable_trigger");
	turretvehicle.turret stopmicrowave();
	turretvehicle.turret killstreaks::configure_team("microwave_turret", turretvehicle.turret.killstreakid, hacker, undefined, undefined, undefined, 1);
}

/*
	Name: hackedpostfunction
	Namespace: microwave_turret
	Checksum: 0x284327A6
	Offset: 0x1528
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function hackedpostfunction(hacker)
{
	turretvehicle = self;
	turretvehicle.turret startmicrowave();
}

/*
	Name: oncancelplacement
	Namespace: microwave_turret
	Checksum: 0x74CF63C
	Offset: 0x1570
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function oncancelplacement(turret)
{
	turret notify(#"microwave_turret_shutdown");
}

/*
	Name: onpickupturret
	Namespace: microwave_turret
	Checksum: 0x444DF70E
	Offset: 0x1598
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function onpickupturret(turret)
{
	turret stopmicrowave();
	turret.vehicle thread ghostafterwait(0.05);
	turret.vehicle turret::disable(0);
	turret.vehicle linkto(turret);
	target_remove(turret.vehicle);
	turret.vehicle vehicle::connect_paths();
}

/*
	Name: ghostafterwait
	Namespace: microwave_turret
	Checksum: 0xB643856F
	Offset: 0x1670
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function ghostafterwait(wait_time)
{
	self endon(#"death");
	wait(wait_time);
	self ghost();
}

/*
	Name: onemp
	Namespace: microwave_turret
	Checksum: 0x19110E16
	Offset: 0x16B0
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function onemp(attacker)
{
	turret = self;
}

/*
	Name: onturretdamage
	Namespace: microwave_turret
	Checksum: 0x2294D9AE
	Offset: 0x16D8
	Size: 0x138
	Parameters: 15
	Flags: Linked
*/
function onturretdamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	empdamage = int((idamage + (self.healthdefault * 1)) + 0.5);
	idamage = self killstreaks::ondamageperweapon("microwave_turret", eattacker, idamage, idflags, smeansofdeath, weapon, self.maxhealth, undefined, self.maxhealth * 0.4, undefined, empdamage, undefined, 1, 1);
	self.damagetaken = self.damagetaken + idamage;
	return idamage;
}

/*
	Name: onturretdeath
	Namespace: microwave_turret
	Checksum: 0x3BF8AA93
	Offset: 0x1818
	Size: 0x32C
	Parameters: 8
	Flags: Linked
*/
function onturretdeath(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	turretvehicle = self;
	eattacker = self [[level.figure_out_attacker]](eattacker);
	if(isdefined(turretvehicle.parentstruct))
	{
		turretvehicle.parentstruct placeables::forceshutdown();
		if(turretvehicle.parentstruct.killstreaktimedout === 1 && isdefined(turretvehicle.owner))
		{
			turretvehicle.owner globallogic_audio::play_taacom_dialog("timeout", turretvehicle.parentstruct.killstreaktype);
		}
		else if(isdefined(eattacker) && isplayer(eattacker) && isdefined(turretvehicle.owner) && eattacker != turretvehicle.owner)
		{
			turretvehicle.parentstruct killstreaks::play_destroyed_dialog_on_owner(turretvehicle.parentstruct.killstreaktype, turretvehicle.parentstruct.killstreakid);
		}
	}
	if(isdefined(eattacker) && isplayer(eattacker) && (!isdefined(self.owner) || self.owner util::isenemyplayer(eattacker)))
	{
		scoreevents::processscoreevent("destroyed_microwave_turret", eattacker, self.owner, weapon);
		eattacker challenges::destroyscorestreak(weapon, 0, 1, 0);
		eattacker challenges::destroynonairscorestreak_poststatslock(weapon);
		eattacker addplayerstat("destroy_turret", 1);
		eattacker addweaponstat(weapon, "destroy_turret", 1);
		luinotifyevent(&"player_callout", 2, &"KILLSTREAK_DESTROYED_MICROWAVE_TURRET", eattacker.entnum);
	}
	if(isdefined(turretvehicle.parentstruct))
	{
		turretvehicle.parentstruct notify(#"microwave_turret_shutdown");
	}
	turretvehicle vehicle_death::death_fx();
	wait(0.1);
	turretvehicle delete();
}

/*
	Name: onturretdeathpostgame
	Namespace: microwave_turret
	Checksum: 0x3CF83048
	Offset: 0x1B50
	Size: 0xE4
	Parameters: 8
	Flags: Linked
*/
function onturretdeathpostgame(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	turretvehicle = self;
	if(isdefined(turretvehicle.parentstruct))
	{
		turretvehicle.parentstruct placeables::forceshutdown();
	}
	if(isdefined(turretvehicle.parentstruct))
	{
		turretvehicle.parentstruct notify(#"microwave_turret_shutdown");
	}
	turretvehicle vehicle_death::death_fx();
	wait(0.1);
	turretvehicle delete();
}

/*
	Name: onshutdown
	Namespace: microwave_turret
	Checksum: 0x95D65599
	Offset: 0x1C40
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function onshutdown(turret)
{
	turret stopmicrowave();
	if(isdefined(turret.vehicle))
	{
		turret.vehicle playsound("mpl_m_turret_exp");
		turret.vehicle kill();
	}
	turret notify(#"microwave_turret_shutdown");
}

/*
	Name: watchkillstreakend
	Namespace: microwave_turret
	Checksum: 0xC31FFF4D
	Offset: 0x1CD8
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function watchkillstreakend(killstreak_id, team)
{
	turret = self;
	turret waittill(#"microwave_turret_shutdown");
	killstreakrules::killstreakstop("microwave_turret", team, killstreak_id);
}

/*
	Name: startmicrowave
	Namespace: microwave_turret
	Checksum: 0xEFA9CFD6
	Offset: 0x1D38
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function startmicrowave()
{
	turret = self;
	if(isdefined(turret.trigger))
	{
		turret.trigger delete();
	}
	turret.trigger = spawn("trigger_radius", turret.origin + (0, 0, 750 * -1), level.aitriggerspawnflags | level.vehicletriggerspawnflags, 750, 750 * 2);
	turret thread turretthink();
	turret clientfield::set("turret_microwave_close", 0);
	turret.othermodel clientfield::set("turret_microwave_close", 0);
	if(isdefined(turret.vehicle))
	{
		turret.vehicle clientfield::set("turret_microwave_open", 1);
	}
	turret turret::createturretinfluencer("turret");
	turret turret::createturretinfluencer("turret_close");
	/#
		turret thread turretdebugwatch();
	#/
}

/*
	Name: stopmicrowave
	Namespace: microwave_turret
	Checksum: 0x704AED9E
	Offset: 0x1EE0
	Size: 0x160
	Parameters: 0
	Flags: Linked
*/
function stopmicrowave()
{
	turret = self;
	turret spawning::remove_influencers();
	if(isdefined(turret))
	{
		turret clientfield::set("turret_microwave_close", 1);
		turret.othermodel clientfield::set("turret_microwave_close", 1);
		if(isdefined(turret.vehicle))
		{
			turret.vehicle clientfield::set("turret_microwave_open", 0);
		}
		turret playsound("mpl_microwave_beam_off");
		if(isdefined(turret.microwavefxent))
		{
			turret.microwavefxent delete();
		}
		if(isdefined(turret.trigger))
		{
			turret.trigger notify(#"microwave_end_fx");
			turret.trigger delete();
		}
		/#
			turret notify(#"stop_turret_debug");
		#/
	}
}

/*
	Name: turretdebugwatch
	Namespace: microwave_turret
	Checksum: 0x4FFEED07
	Offset: 0x2048
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function turretdebugwatch()
{
	turret = self;
	turret endon(#"stop_turret_debug");
	for(;;)
	{
		if(getdvarint("scr_microwave_turret_debug") != 0)
		{
			turret turretdebug();
			wait(0.05);
			continue;
		}
		wait(1);
	}
}

/*
	Name: turretdebug
	Namespace: microwave_turret
	Checksum: 0x83388755
	Offset: 0x20C8
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function turretdebug()
{
	turret = self;
	debug_line_frames = 3;
	angles = turret.vehicle gettagangles("tag_flash");
	origin = turret.vehicle gettagorigin("tag_flash");
	cone_apex = origin;
	forward = anglestoforward(angles);
	dome_apex = cone_apex + vectorscale(forward, 750);
	util::debug_spherical_cone(cone_apex, dome_apex, 15, 16, (0.95, 0.1, 0.1), 0.3, 1, debug_line_frames);
}

/*
	Name: turretthink
	Namespace: microwave_turret
	Checksum: 0xCD51CE19
	Offset: 0x2200
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function turretthink()
{
	turret = self;
	turret endon(#"microwave_turret_shutdown");
	turret.trigger endon(#"death");
	turret.trigger endon(#"delete");
	turret.turret_vehicle_entnum = turret.vehicle getentitynumber();
	while(true)
	{
		turret.trigger waittill(#"trigger", ent);
		if(ent == turret)
		{
			continue;
		}
		if(!isdefined(ent.beingmicrowavedby))
		{
			ent.beingmicrowavedby = [];
		}
		if(!isdefined(ent.beingmicrowavedby[turret.turret_vehicle_entnum]))
		{
			turret thread microwaveentity(ent);
		}
	}
}

/*
	Name: microwaveentitypostshutdowncleanup
	Namespace: microwave_turret
	Checksum: 0x2B0869D7
	Offset: 0x2318
	Size: 0xA8
	Parameters: 1
	Flags: Linked
*/
function microwaveentitypostshutdowncleanup(entity)
{
	entity endon(#"disconnect");
	entity endon(#"end_microwaveentitypostshutdowncleanup");
	turret = self;
	turret_vehicle_entnum = turret.turret_vehicle_entnum;
	turret waittill(#"microwave_turret_shutdown");
	if(isdefined(entity))
	{
		if(isdefined(entity.beingmicrowavedby) && isdefined(entity.beingmicrowavedby[turret_vehicle_entnum]))
		{
			entity.beingmicrowavedby[turret_vehicle_entnum] = undefined;
		}
	}
}

/*
	Name: microwaveentity
	Namespace: microwave_turret
	Checksum: 0x46C49B69
	Offset: 0x23C8
	Size: 0x6F8
	Parameters: 1
	Flags: Linked
*/
function microwaveentity(entity)
{
	turret = self;
	turret endon(#"microwave_turret_shutdown");
	entity endon(#"disconnect");
	entity endon(#"death");
	if(isplayer(entity))
	{
		entity endon(#"joined_team");
		entity endon(#"joined_spectators");
	}
	turret thread microwaveentitypostshutdowncleanup(entity);
	entity.beingmicrowavedby[turret.turret_vehicle_entnum] = turret.owner;
	entity.microwavedamageinitialdelay = 1;
	entity.microwaveeffect = 0;
	shellshockscalar = 1;
	viewkickscalar = 1;
	damagescalar = 1;
	if(isplayer(entity) && entity hasperk("specialty_microwaveprotection"))
	{
		shellshockscalar = getdvarfloat("specialty_microwaveprotection_shellshock_scalar", 0.5);
		viewkickscalar = getdvarfloat("specialty_microwaveprotection_viewkick_scalar", 0.5);
		damagescalar = getdvarfloat("specialty_microwaveprotection_damage_scalar", 0.5);
	}
	turretweapon = getweapon("microwave_turret");
	while(true)
	{
		if(!isdefined(turret) || !turret microwaveturretaffectsentity(entity) || !isdefined(turret.trigger))
		{
			if(!isdefined(entity))
			{
				return;
			}
			entity.beingmicrowavedby[turret.turret_vehicle_entnum] = undefined;
			if(isdefined(entity.microwavepoisoning) && entity.microwavepoisoning)
			{
				entity.microwavepoisoning = 0;
			}
			entity notify(#"end_microwaveentitypostshutdowncleanup");
			return;
		}
		damage = 15 * damagescalar;
		if(level.hardcoremode)
		{
			damage = damage / 2;
		}
		if(!isai(entity) && entity util::mayapplyscreeneffect())
		{
			if(!isdefined(entity.microwavepoisoning) || !entity.microwavepoisoning)
			{
				entity.microwavepoisoning = 1;
				entity.microwaveeffect = 0;
			}
		}
		if(isdefined(entity.microwavedamageinitialdelay))
		{
			wait(randomfloatrange(0.1, 0.3));
			entity.microwavedamageinitialdelay = undefined;
		}
		entity dodamage(damage, turret.origin, turret.owner, turret.vehicle, 0, "MOD_TRIGGER_HURT", 0, turretweapon);
		entity.microwaveeffect++;
		entity.lastmicrowavedby = turret.owner;
		time = gettime();
		if(isplayer(entity) && !entity isremotecontrolling())
		{
			if((time - (isdefined(entity.microwaveshellshockandviewkicktime) ? entity.microwaveshellshockandviewkicktime : 0)) > 950)
			{
				if((entity.microwaveeffect % 2) == 1)
				{
					if(distancesquared(entity.origin, turret.origin) > ((750 * 2) / 3) * ((750 * 2) / 3))
					{
						entity shellshock("mp_radiation_low", 1.5 * shellshockscalar);
						entity viewkick(int(25 * viewkickscalar), turret.origin);
					}
					else
					{
						if(distancesquared(entity.origin, turret.origin) > ((750 * 1) / 3) * ((750 * 1) / 3))
						{
							entity shellshock("mp_radiation_med", 1.5 * shellshockscalar);
							entity viewkick(int(50 * viewkickscalar), turret.origin);
						}
						else
						{
							entity shellshock("mp_radiation_high", 1.5 * shellshockscalar);
							entity viewkick(int(75 * viewkickscalar), turret.origin);
						}
					}
					entity.microwaveshellshockandviewkicktime = time;
				}
			}
		}
		if(isplayer(entity) && (entity.microwaveeffect % 3) == 2)
		{
			scoreevents::processscoreevent("hpm_suppress", turret.owner, entity, turretweapon);
		}
		wait(0.5);
	}
}

/*
	Name: microwaveturretaffectsentity
	Namespace: microwave_turret
	Checksum: 0xBF232E13
	Offset: 0x2AC8
	Size: 0x2BA
	Parameters: 1
	Flags: Linked
*/
function microwaveturretaffectsentity(entity)
{
	turret = self;
	if(!isalive(entity))
	{
		return false;
	}
	if(!isplayer(entity) && !isai(entity))
	{
		return false;
	}
	if(entity.ignoreme === 1)
	{
		return false;
	}
	if(isdefined(turret.carried) && turret.carried)
	{
		return false;
	}
	if(turret weaponobjects::isstunned())
	{
		return false;
	}
	if(isdefined(turret.owner) && entity == turret.owner)
	{
		return false;
	}
	if(!weaponobjects::friendlyfirecheck(turret.owner, entity, 0))
	{
		return false;
	}
	if(distancesquared(entity.origin, turret.origin) > (750 * 750))
	{
		return false;
	}
	angles = turret.vehicle gettagangles("tag_flash");
	origin = turret.vehicle gettagorigin("tag_flash");
	shoot_at_pos = entity getshootatpos(turret);
	entdirection = vectornormalize(shoot_at_pos - origin);
	forward = anglestoforward(angles);
	dot = vectordot(entdirection, forward);
	if(dot < cos(15))
	{
		return false;
	}
	if(entity damageconetrace(origin, turret, forward) <= 0)
	{
		return false;
	}
	return true;
}

