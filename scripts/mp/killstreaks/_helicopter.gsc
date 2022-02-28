// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_player;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_dogs;
#using scripts\mp\killstreaks\_flak_drone;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weaponobjects;

#using_animtree("mp_vehicles");

#namespace helicopter;

/*
	Name: precachehelicopter
	Namespace: helicopter
	Checksum: 0x7234CA08
	Offset: 0x1448
	Size: 0x102
	Parameters: 2
	Flags: Linked
*/
function precachehelicopter(model, type = "blackhawk")
{
	level.vehicle_deathmodel[model] = model;
	level.heli_sound["hit"] = "evt_helicopter_hit";
	level.heli_sound["hitsecondary"] = "evt_helicopter_hit";
	level.heli_sound["damaged"] = "null";
	level.heli_sound["spinloop"] = "evt_helicopter_spin_loop";
	level.heli_sound["spinstart"] = "evt_helicopter_spin_start";
	level.heli_sound["crash"] = "evt_helicopter_midair_exp";
	level.heli_sound["missilefire"] = "wpn_hellfire_fire_npc";
}

/*
	Name: usekillstreakhelicopter
	Namespace: helicopter
	Checksum: 0xE81FD668
	Offset: 0x1558
	Size: 0x338
	Parameters: 1
	Flags: Linked
*/
function usekillstreakhelicopter(hardpointtype)
{
	if(self killstreakrules::iskillstreakallowed(hardpointtype, self.team) == 0)
	{
		return false;
	}
	if(!isdefined(level.heli_paths) || !level.heli_paths.size)
	{
		/#
			iprintlnbold("");
		#/
		return false;
	}
	if(hardpointtype == "helicopter_comlink" || hardpointtype == "inventory_helicopter_comlink")
	{
		result = self selecthelicopterlocation(hardpointtype);
		if(!isdefined(result) || result == 0)
		{
			return false;
		}
	}
	destination = 0;
	missilesenabled = 0;
	if(hardpointtype == "helicopter_x2")
	{
		missilesenabled = 1;
	}
	/#
		assert(level.heli_paths.size > 0, "");
	#/
	random_path = randomint(level.heli_paths[destination].size);
	startnode = level.heli_paths[destination][random_path];
	protectlocation = undefined;
	armored = 0;
	if(hardpointtype == "helicopter_comlink" || hardpointtype == "inventory_helicopter_comlink")
	{
		protectlocation = (level.helilocation[0], level.helilocation[1], int(airsupport::getminimumflyheight()) - 200);
		armored = 0;
		startnode = getvalidprotectlocationstart(random_path, protectlocation, destination);
	}
	killstreak_id = self killstreakrules::killstreakstart(hardpointtype, self.team);
	if(killstreak_id == -1)
	{
		return false;
	}
	if(hardpointtype == "helicopter_comlink" || hardpointtype == "inventory_helicopter_comlink")
	{
		self challenges::calledincomlinkchopper();
	}
	self killstreaks::play_killstreak_start_dialog(hardpointtype, self.team, killstreak_id);
	self thread announcehelicopterinbound(hardpointtype);
	thread heli_think(self, startnode, self.team, missilesenabled, protectlocation, hardpointtype, armored, killstreak_id);
	return true;
}

/*
	Name: announcehelicopterinbound
	Namespace: helicopter
	Checksum: 0xBF4A7E37
	Offset: 0x1898
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function announcehelicopterinbound(hardpointtype)
{
	team = self.team;
	self addweaponstat(killstreaks::get_killstreak_weapon(hardpointtype), "used", 1);
}

/*
	Name: heli_path_graph
	Namespace: helicopter
	Checksum: 0x826BD8C9
	Offset: 0x18F8
	Size: 0x754
	Parameters: 0
	Flags: Linked
*/
function heli_path_graph()
{
	path_start = getentarray("heli_start", "targetname");
	path_dest = getentarray("heli_dest", "targetname");
	loop_start = getentarray("heli_loop_start", "targetname");
	gunner_loop_start = getentarray("heli_gunner_loop_start", "targetname");
	leave_nodes = getentarray("heli_leave", "targetname");
	crash_start = getentarray("heli_crash_start", "targetname");
	/#
		assert(isdefined(path_start) && isdefined(path_dest), "");
	#/
	for(i = 0; i < path_dest.size; i++)
	{
		startnode_array = [];
		isprimarydest = 0;
		destnode_pointer = path_dest[i];
		destnode = getent(destnode_pointer.target, "targetname");
		for(j = 0; j < path_start.size; j++)
		{
			todest = 0;
			currentnode = path_start[j];
			while(isdefined(currentnode.target))
			{
				nextnode = getent(currentnode.target, "targetname");
				if(nextnode.origin == destnode.origin)
				{
					todest = 1;
					break;
				}
				airsupport::debug_print3d_simple("+", currentnode, vectorscale((0, 0, -1), 10));
				if(isdefined(nextnode.target))
				{
					airsupport::debug_line(nextnode.origin, getent(nextnode.target, "targetname").origin, (0.25, 0.5, 0.25), 5);
				}
				if(isdefined(currentnode.script_delay))
				{
					airsupport::debug_print3d_simple("Wait: " + currentnode.script_delay, currentnode, vectorscale((0, 0, 1), 10));
				}
				currentnode = nextnode;
			}
			if(todest)
			{
				startnode_array[startnode_array.size] = getent(path_start[j].target, "targetname");
				if(isdefined(path_start[j].script_noteworthy) && path_start[j].script_noteworthy == "primary")
				{
					isprimarydest = 1;
				}
			}
		}
		/#
			assert(isdefined(startnode_array) && startnode_array.size > 0, "");
		#/
		if(isprimarydest)
		{
			level.heli_primary_path = startnode_array;
			continue;
		}
		level.heli_paths[level.heli_paths.size] = startnode_array;
	}
	for(i = 0; i < loop_start.size; i++)
	{
		startnode = getent(loop_start[i].target, "targetname");
		level.heli_loop_paths[level.heli_loop_paths.size] = startnode;
	}
	/#
		assert(isdefined(level.heli_loop_paths[0]), "");
	#/
	for(i = 0; i < gunner_loop_start.size; i++)
	{
		startnode = getent(gunner_loop_start[i].target, "targetname");
		startnode.isgunnerpath = 1;
		level.heli_loop_paths[level.heli_loop_paths.size] = startnode;
	}
	for(i = 0; i < path_start.size; i++)
	{
		if(isdefined(path_start[i].script_noteworthy) && path_start[i].script_noteworthy == "primary")
		{
			continue;
		}
		level.heli_startnodes[level.heli_startnodes.size] = path_start[i];
	}
	/#
		assert(isdefined(level.heli_startnodes[0]), "");
	#/
	for(i = 0; i < leave_nodes.size; i++)
	{
		level.heli_leavenodes[level.heli_leavenodes.size] = leave_nodes[i];
	}
	/#
		assert(isdefined(level.heli_leavenodes[0]), "");
	#/
	for(i = 0; i < crash_start.size; i++)
	{
		crash_start_node = getent(crash_start[i].target, "targetname");
		level.heli_crash_paths[level.heli_crash_paths.size] = crash_start_node;
	}
	/#
		assert(isdefined(level.heli_crash_paths[0]), "");
	#/
}

/*
	Name: init
	Namespace: helicopter
	Checksum: 0xACCDB620
	Offset: 0x2058
	Size: 0x66C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	path_start = getentarray("heli_start", "targetname");
	loop_start = getentarray("heli_loop_start", "targetname");
	/#
		debug_refresh = 1;
	#/
	thread heli_update_global_dvars(debug_refresh);
	level.chaff_offset["attack"] = (-130, 0, -140);
	level.choppercomlinkfriendly = "veh_t7_drone_hunter";
	level.choppercomlinkenemy = "veh_t7_drone_hunter";
	level.chopperregular = "veh_t7_drone_hunter";
	precachehelicopter(level.chopperregular);
	precachehelicopter(level.choppercomlinkfriendly);
	precachehelicopter(level.choppercomlinkenemy);
	clientfield::register("helicopter", "heli_comlink_bootup_anim", 1, 1, "int");
	clientfield::register("helicopter", "heli_warn_targeted", 1, 1, "int");
	clientfield::register("helicopter", "heli_warn_locked", 1, 1, "int");
	clientfield::register("helicopter", "heli_warn_fired", 1, 1, "int");
	clientfield::register("helicopter", "active_camo", 1, 3, "int");
	clientfield::register("vehicle", "heli_comlink_bootup_anim", 1, 1, "int");
	clientfield::register("vehicle", "heli_warn_targeted", 1, 1, "int");
	clientfield::register("vehicle", "heli_warn_locked", 1, 1, "int");
	clientfield::register("vehicle", "heli_warn_fired", 1, 1, "int");
	clientfield::register("vehicle", "active_camo", 1, 3, "int");
	level.heli_paths = [];
	level.heli_loop_paths = [];
	level.heli_startnodes = [];
	level.heli_leavenodes = [];
	level.heli_crash_paths = [];
	level.last_start_node_index = 0;
	level.chopper_fx["explode"]["death"] = "killstreaks/fx_heli_exp_lg";
	level.chopper_fx["explode"]["guard"] = "killstreaks/fx_heli_exp_md";
	level.chopper_fx["explode"]["gunner"] = "killstreaks/fx_vtol_exp";
	level.chopper_fx["explode"]["large"] = "killstreaks/fx_heli_exp_sm";
	level.chopper_fx["damage"]["light_smoke"] = "killstreaks/fx_heli_smk_trail_engine_33";
	level.chopper_fx["damage"]["heavy_smoke"] = "killstreaks/fx_heli_smk_trail_engine_66";
	level.chopper_fx["smoke"]["trail"] = "killstreaks/fx_heli_smk_trail_tail";
	level.chopper_fx["fire"]["trail"]["large"] = "killstreaks/fx_heli_smk_trail_engine";
	level._effect["heli_comlink_light"]["friendly"] = "_debug/fx_debug_deleted_fx";
	level._effect["heli_comlink_light"]["enemy"] = "_debug/fx_debug_deleted_fx";
	level.helicomlinkbootupanim = %mp_vehicles::veh_anim_future_heli_gearup_bay_open;
	killstreaks::register("helicopter_comlink", "helicopter_comlink", "killstreak_helicopter_comlink", "helicopter_used", &usekillstreakhelicopter, 1);
	killstreaks::register_strings("helicopter_comlink", &"KILLSTREAK_EARNED_HELICOPTER_COMLINK", &"KILLSTREAK_HELICOPTER_COMLINK_NOT_AVAILABLE", &"KILLSTREAK_HELICOPTER_COMLINK_INBOUND", undefined, &"KILLSTREAK_HELICOPTER_COMLINK_HACKED");
	killstreaks::register_dialog("helicopter_comlink", "mpl_killstreak_heli", "helicopterDialogBundle", "helicopterPilotDialogBundle", "friendlyHelicopter", "enemyHelicopter", "enemyHelicopterMultiple", "friendlyHelicopterHacked", "enemyHelicopterHacked", "requestHelicopter", "threatHelicopter");
	killstreaks::register_alt_weapon("helicopter_comlink", "cobra_20mm_comlink");
	killstreaks::set_team_kill_penalty_scale("helicopter_comlink", 0);
	level.killstreaks["helicopter_comlink"].threatonkill = 1;
	level.killstreaks["inventory_helicopter_comlink"].threatonkill = 1;
	if(!path_start.size && !loop_start.size)
	{
		return;
	}
	heli_path_graph();
}

/*
	Name: heli_update_global_dvars
	Namespace: helicopter
	Checksum: 0xDC61D0CF
	Offset: 0x26D0
	Size: 0x55C
	Parameters: 1
	Flags: Linked
*/
function heli_update_global_dvars(debug_refresh)
{
	do
	{
		level.heli_loopmax = heli_get_dvar_int("scr_heli_loopmax", "2");
		level.heli_missile_rof = heli_get_dvar_int("scr_heli_missile_rof", "2");
		level.heli_armor = heli_get_dvar_int("scr_heli_armor", "500");
		level.heli_maxhealth = heli_get_dvar_int("scr_heli_maxhealth", "2000");
		level.heli_amored_maxhealth = heli_get_dvar_int("scr_heli_armored_maxhealth", "1500");
		level.heli_missile_max = heli_get_dvar_int("scr_heli_missile_max", "20");
		level.heli_dest_wait = heli_get_dvar_int("scr_heli_dest_wait", "8");
		level.heli_debug = heli_get_dvar_int("scr_heli_debug", "0");
		level.heli_debug_crash = heli_get_dvar_int("scr_heli_debug_crash", "0");
		level.heli_targeting_delay = heli_get_dvar("scr_heli_targeting_delay", "0.6");
		level.heli_turretreloadtime = heli_get_dvar("scr_heli_turretReloadTime", "0.5");
		level.heli_turretclipsize = heli_get_dvar_int("scr_heli_turretClipSize", "80");
		level.heli_visual_range = (isdefined(level.heli_visual_range_override) ? level.heli_visual_range_override : heli_get_dvar_int("scr_heli_visual_range", "3500"));
		level.heli_missile_range = heli_get_dvar_int("scr_heli_missile_range", "100000");
		level.heli_health_degrade = heli_get_dvar_int("scr_heli_health_degrade", "0");
		level.heli_turret_angle_tan = heli_get_dvar_int("scr_heli_turret_angle_tan", "1");
		level.heli_turret_target_cone = heli_get_dvar("scr_heli_turret_target_cone", "0.6");
		level.heli_target_spawnprotection = heli_get_dvar_int("scr_heli_target_spawnprotection", "5");
		level.heli_missile_regen_time = heli_get_dvar("scr_heli_missile_regen_time", "10");
		level.heli_turret_spinup_delay = heli_get_dvar("scr_heli_turret_spinup_delay", "1.0");
		level.heli_target_recognition = heli_get_dvar("scr_heli_target_recognition", "0.3");
		level.heli_missile_friendlycare = heli_get_dvar_int("scr_heli_missile_friendlycare", "512");
		level.heli_missile_target_cone = heli_get_dvar("scr_heli_missile_target_cone", "0.6");
		level.heli_valid_target_cone = heli_get_dvar("scr_heli_missile_valid_target_cone", "0.7");
		level.heli_armor_bulletdamage = heli_get_dvar("scr_heli_armor_bulletdamage", "0.5");
		level.heli_attract_strength = heli_get_dvar("scr_heli_attract_strength", "1000");
		level.heli_attract_range = heli_get_dvar("scr_heli_attract_range", "20000");
		level.helicopterturretmaxangle = heli_get_dvar_int("scr_helicopterTurretMaxAngle", "35");
		level.heli_protect_time = heli_get_dvar("scr_heli_protect_time", "60");
		level.heli_protect_pos_time = heli_get_dvar("scr_heli_protect_pos_time", "12");
		level.heli_protect_radius = heli_get_dvar_int("scr_heli_protect_radius", "2000");
		level.heli_missile_reload_time = heli_get_dvar("scr_heli_missile_reload_time", "5.0");
		level.heli_warning_distance = heli_get_dvar_int("scr_heli_warning_distance", "500");
		wait(1);
	}
	while(isdefined(debug_refresh));
}

/*
	Name: heli_get_dvar_int
	Namespace: helicopter
	Checksum: 0x42A4E8BB
	Offset: 0x2C38
	Size: 0x42
	Parameters: 2
	Flags: Linked
*/
function heli_get_dvar_int(dvar, def)
{
	return int(heli_get_dvar(dvar, def));
}

/*
	Name: heli_get_dvar
	Namespace: helicopter
	Checksum: 0x92617F88
	Offset: 0x2C88
	Size: 0x82
	Parameters: 2
	Flags: Linked
*/
function heli_get_dvar(dvar, def)
{
	if(getdvarstring(dvar) != "")
	{
		return getdvarfloat(dvar);
	}
	setdvar(dvar, def);
	return float(def);
}

/*
	Name: set_goal_pos
	Namespace: helicopter
	Checksum: 0x620A50A6
	Offset: 0x2D18
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function set_goal_pos(goalpos, stop)
{
	self.heligoalpos = goalpos;
	self setvehgoalpos(goalpos, stop);
}

/*
	Name: spawn_helicopter
	Namespace: helicopter
	Checksum: 0xFC201790
	Offset: 0x2D60
	Size: 0x268
	Parameters: 8
	Flags: Linked
*/
function spawn_helicopter(owner, origin, angles, model, targetname, target_offset, hardpointtype, killstreak_id)
{
	chopper = spawnhelicopter(owner, origin, angles, model, targetname);
	chopper.owner = owner;
	chopper clientfield::set("enemyvehicle", 1);
	chopper.attackers = [];
	chopper.attackerdata = [];
	chopper.attackerdamage = [];
	chopper.flareattackerdamage = [];
	chopper.destroyfunc = &destroyhelicopter;
	chopper.hardpointtype = hardpointtype;
	chopper.killstreak_id = killstreak_id;
	chopper.pilotistalking = 0;
	chopper setdrawinfrared(1);
	chopper.allowcontinuedlockonafterinvis = 1;
	chopper.soundmod = "heli";
	if(!isdefined(target_offset))
	{
		target_offset = (0, 0, 0);
	}
	chopper.target_offset = target_offset;
	target_set(chopper, target_offset);
	if(hardpointtype == "helicopter_comlink" || hardpointtype == "inventory_helicopter_comlink")
	{
		chopper.allowhackingaftercloak = 1;
		chopper.flak_drone = flak_drone::spawn(chopper, &onflakdronedestroyed);
		chopper.treat_owner_damage_as_friendly_fire = 1;
		chopper.ignore_team_kills = 1;
		chopper init_active_camo();
	}
	return chopper;
}

/*
	Name: onflakdronedestroyed
	Namespace: helicopter
	Checksum: 0xCEADA76F
	Offset: 0x2FD0
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function onflakdronedestroyed()
{
	chopper = self;
	if(!isdefined(chopper))
	{
		return;
	}
	chopper.numflares = 0;
	chopper killstreaks::play_pilot_dialog_on_owner("weaponDestroyed", "helicopter_comlink", chopper.killstreak_id);
	chopper thread heatseekingmissile::missiletarget_proximitydetonateincomingmissile("crashing", "death");
}

/*
	Name: explodeoncontact
	Namespace: helicopter
	Checksum: 0x395789B1
	Offset: 0x3068
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function explodeoncontact(hardpointtype)
{
	self endon(#"death");
	wait(10);
	for(;;)
	{
		self waittill(#"touch");
		self thread heli_explode();
	}
}

/*
	Name: getvalidprotectlocationstart
	Namespace: helicopter
	Checksum: 0x22D7F822
	Offset: 0x30B0
	Size: 0x18A
	Parameters: 3
	Flags: Linked
*/
function getvalidprotectlocationstart(random_path, protectlocation, destination)
{
	startnode = level.heli_paths[destination][random_path];
	path_index = (random_path + 1) % level.heli_paths[destination].size;
	innofly = airsupport::crossesnoflyzone(protectlocation + (0, 0, 1), protectlocation);
	if(isdefined(innofly))
	{
		protectlocation = (protectlocation[0], protectlocation[1], level.noflyzones[innofly].origin[2] + level.noflyzones[innofly].height);
	}
	noflyzone = airsupport::crossesnoflyzone(startnode.origin, protectlocation);
	while(isdefined(noflyzone) && path_index != random_path)
	{
		startnode = level.heli_paths[destination][path_index];
		if(isdefined(noflyzone))
		{
			path_index = (path_index + 1) % level.heli_paths[destination].size;
		}
	}
	return level.heli_paths[destination][path_index];
}

/*
	Name: getvalidrandomleavenode
	Namespace: helicopter
	Checksum: 0x3094FF64
	Offset: 0x3248
	Size: 0x218
	Parameters: 1
	Flags: Linked
*/
function getvalidrandomleavenode(start)
{
	if(self === level.vtol)
	{
		foreach(node in level.heli_leavenodes)
		{
			if(isdefined(node.script_noteworthy) && node.script_noteworthy == "primary")
			{
				return node;
			}
		}
	}
	random_leave_node = randomint(level.heli_leavenodes.size);
	leavenode = level.heli_leavenodes[random_leave_node];
	path_index = (random_leave_node + 1) % level.heli_leavenodes.size;
	noflyzone = airsupport::crossesnoflyzone(leavenode.origin, start);
	isprimary = leavenode.script_noteworthy === "primary";
	while(isdefined(noflyzone) || isprimary && path_index != random_leave_node)
	{
		leavenode = level.heli_leavenodes[path_index];
		noflyzone = airsupport::crossesnoflyzone(leavenode.origin, start);
		isprimary = leavenode.script_noteworthy === "primary";
		path_index = (path_index + 1) % level.heli_leavenodes.size;
	}
	return level.heli_leavenodes[path_index];
}

/*
	Name: getvalidrandomstartnode
	Namespace: helicopter
	Checksum: 0x4A59A6ED
	Offset: 0x3468
	Size: 0x130
	Parameters: 1
	Flags: Linked
*/
function getvalidrandomstartnode(dest)
{
	path_index = randomint(level.heli_startnodes.size);
	best_index = path_index;
	count = 0;
	for(i = 0; i < level.heli_startnodes.size; i++)
	{
		startnode = level.heli_startnodes[path_index];
		noflyzone = airsupport::crossesnoflyzone(startnode.origin, dest);
		if(!isdefined(noflyzone))
		{
			best_index = path_index;
			if(path_index != level.last_start_node_index)
			{
				break;
			}
		}
		path_index = (path_index + 1) % level.heli_startnodes.size;
	}
	level.last_start_node_index = best_index;
	return level.heli_startnodes[best_index];
}

/*
	Name: getvalidrandomcrashnode
	Namespace: helicopter
	Checksum: 0xE46217F6
	Offset: 0x35A0
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function getvalidrandomcrashnode(start)
{
	random_leave_node = randomint(level.heli_crash_paths.size);
	leavenode = level.heli_crash_paths[random_leave_node];
	path_index = (random_leave_node + 1) % level.heli_crash_paths.size;
	noflyzone = airsupport::crossesnoflyzone(leavenode.origin, start);
	while(isdefined(noflyzone) && path_index != random_leave_node)
	{
		leavenode = level.heli_crash_paths[path_index];
		noflyzone = airsupport::crossesnoflyzone(leavenode.origin, start);
		path_index = (path_index + 1) % level.heli_crash_paths.size;
	}
	return level.heli_crash_paths[path_index];
}

/*
	Name: configureteampost
	Namespace: helicopter
	Checksum: 0x18420C22
	Offset: 0x36C8
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function configureteampost(owner, ishacked)
{
	chopper = self;
	owner thread watchforearlyleave(chopper);
}

/*
	Name: hackedcallbackpost
	Namespace: helicopter
	Checksum: 0x2174FA3F
	Offset: 0x3710
	Size: 0xA8
	Parameters: 1
	Flags: Linked
*/
function hackedcallbackpost(hacker)
{
	heli = self;
	if(isdefined(heli.flak_drone))
	{
		heli.flak_drone flak_drone::configureteam(heli, 1);
	}
	heli.endtime = gettime() + (killstreak_bundles::get_hack_timeout() * 1000);
	heli.killstreakendtime = int(heli.endtime);
}

/*
	Name: heli_think
	Namespace: helicopter
	Checksum: 0x95B6BFEF
	Offset: 0x37C0
	Size: 0x6DC
	Parameters: 8
	Flags: Linked
*/
function heli_think(owner, startnode, heli_team, missilesenabled, protectlocation, hardpointtype, armored, killstreak_id)
{
	heliorigin = startnode.origin;
	heliangles = startnode.angles;
	if(hardpointtype == "helicopter_comlink" || hardpointtype == "inventory_helicopter_comlink")
	{
		choppermodelfriendly = level.choppercomlinkfriendly;
		choppermodelenemy = level.choppercomlinkenemy;
	}
	else
	{
		choppermodelfriendly = level.chopperregular;
		choppermodelenemy = level.chopperregular;
	}
	chopper = spawn_helicopter(owner, heliorigin, heliangles, "heli_ai_mp", choppermodelfriendly, vectorscale((0, 0, 1), 100), hardpointtype, killstreak_id);
	chopper.harpointtype = hardpointtype;
	chopper killstreaks::configure_team(hardpointtype, killstreak_id, owner, "helicopter", undefined, &configureteampost);
	if(hardpointtype == "helicopter_comlink" || hardpointtype == "inventory_helicopter_comlink")
	{
		chopper killstreak_hacking::enable_hacking("helicopter_comlink", undefined, &hackedcallbackpost);
	}
	chopper setenemymodel(choppermodelenemy);
	chopper thread watchforemp();
	target_setturretaquire(chopper, 0);
	chopper thread samturretwatcher();
	if(hardpointtype == "helicopter_comlink" || hardpointtype == "inventory_helicopter_comlink")
	{
		chopper.defaultweapon = getweapon("cobra_20mm_comlink");
	}
	else
	{
		chopper.defaultweapon = getweapon("cobra_20mm");
	}
	chopper.requireddeathcount = owner.deathcount;
	chopper.chaff_offset = level.chaff_offset["attack"];
	minigun_snd_ent = spawn("script_origin", chopper gettagorigin("tag_flash"));
	minigun_snd_ent linkto(chopper, "tag_flash", (0, 0, 0), (0, 0, 0));
	chopper.minigun_snd_ent = minigun_snd_ent;
	minigun_snd_ent thread autostopsound();
	chopper thread heli_existance();
	level.chopper = chopper;
	chopper.reached_dest = 0;
	if(armored)
	{
		chopper.maxhealth = level.heli_amored_maxhealth;
	}
	else
	{
		chopper.maxhealth = level.heli_maxhealth;
	}
	chopper.rocketdamageoneshot = level.heli_maxhealth + 1;
	chopper.rocketdamagetwoshot = (level.heli_maxhealth / 2) + 1;
	if(hardpointtype == "helicopter_comlink" || hardpointtype == "inventory_helicopter_comlink")
	{
		chopper.numflares = 0;
	}
	else
	{
		if(hardpointtype == "helicopter_guard")
		{
			chopper.numflares = 1;
		}
		else
		{
			chopper.numflares = 2;
		}
	}
	chopper.flareoffset = vectorscale((0, 0, -1), 256);
	chopper.waittime = level.heli_dest_wait;
	chopper.loopcount = 0;
	chopper.evasive = 0;
	chopper.health_bulletdamageble = level.heli_armor;
	chopper.health_evasive = level.heli_armor;
	chopper.targeting_delay = level.heli_targeting_delay;
	chopper.primarytarget = undefined;
	chopper.secondarytarget = undefined;
	chopper.attacker = undefined;
	chopper.missile_ammo = level.heli_missile_max;
	chopper.currentstate = "ok";
	chopper.lastrocketfiretime = -1;
	if(isdefined(protectlocation))
	{
		chopper thread heli_protect(startnode, protectlocation, hardpointtype, heli_team);
		chopper clientfield::set("heli_comlink_bootup_anim", 1);
	}
	else
	{
		chopper thread heli_fly(startnode, 2, hardpointtype);
	}
	chopper thread heli_damage_monitor(hardpointtype);
	chopper thread wait_for_killed();
	chopper thread heli_health(hardpointtype);
	chopper thread attack_targets(missilesenabled, hardpointtype);
	chopper thread heli_targeting(missilesenabled, hardpointtype);
	chopper thread heli_missile_regen();
	if(hardpointtype != "helicopter_comlink")
	{
		chopper thread heatseekingmissile::missiletarget_proximitydetonateincomingmissile("crashing", "death");
		chopper thread create_flare_ent(vectorscale((0, 0, -1), 100));
	}
}

/*
	Name: autostopsound
	Namespace: helicopter
	Checksum: 0xA5DF8658
	Offset: 0x3EA8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function autostopsound()
{
	self endon(#"death");
	level waittill(#"game_ended");
	self stoploopsound();
}

/*
	Name: heli_existance
	Namespace: helicopter
	Checksum: 0xEF3F32C5
	Offset: 0x3EE8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function heli_existance()
{
	self waittill(#"leaving");
	self spawning::remove_influencers();
}

/*
	Name: create_flare_ent
	Namespace: helicopter
	Checksum: 0xECF9BA72
	Offset: 0x3F18
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function create_flare_ent(offset)
{
	self.flare_ent = spawn("script_model", self gettagorigin("tag_origin"));
	self.flare_ent setmodel("tag_origin");
	self.flare_ent linkto(self, "tag_origin", offset);
}

/*
	Name: heli_missile_regen
	Namespace: helicopter
	Checksum: 0x45119E0E
	Offset: 0x3FB8
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function heli_missile_regen()
{
	self endon(#"death");
	self endon(#"crashing");
	self endon(#"leaving");
	for(;;)
	{
		airsupport::debug_print3d("Missile Ammo: " + self.missile_ammo, (0.5, 0.5, 1), self, vectorscale((0, 0, -1), 100), 0);
		if(self.missile_ammo >= level.heli_missile_max)
		{
			self waittill(#"hash_b0c5ea03");
		}
		else
		{
			if(self.currentstate == "heavy smoke")
			{
				wait(level.heli_missile_regen_time / 4);
			}
			else
			{
				if(self.currentstate == "light smoke")
				{
					wait(level.heli_missile_regen_time / 2);
				}
				else
				{
					wait(level.heli_missile_regen_time);
				}
			}
		}
		if(self.missile_ammo < level.heli_missile_max)
		{
			self.missile_ammo++;
		}
	}
}

/*
	Name: heli_targeting
	Namespace: helicopter
	Checksum: 0x63E1F0D5
	Offset: 0x40D0
	Size: 0x740
	Parameters: 2
	Flags: Linked
*/
function heli_targeting(missilesenabled, hardpointtype)
{
	self endon(#"death");
	self endon(#"crashing");
	self endon(#"leaving");
	for(;;)
	{
		targets = [];
		targetsmissile = [];
		players = level.players;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(self cantargetplayer_turret(player, hardpointtype))
			{
				if(isdefined(player))
				{
					targets[targets.size] = player;
				}
			}
			if(missilesenabled && self cantargetplayer_missile(player, hardpointtype))
			{
				if(isdefined(player))
				{
					targetsmissile[targetsmissile.size] = player;
				}
				continue;
			}
			continue;
		}
		dogs = dogs::dog_manager_get_dogs();
		foreach(dog in dogs)
		{
			if(self cantargetdog_turret(dog))
			{
				targets[targets.size] = dog;
			}
			if(missilesenabled && self cantargetdog_missile(dog))
			{
				targetsmissile[targetsmissile.size] = dog;
			}
		}
		tanks = getentarray("talon", "targetname");
		tanks = arraycombine(tanks, getentarray("siegebot", "targetname"), 0, 0);
		foreach(tank in tanks)
		{
			if(self cantargettank_turret(tank))
			{
				targets[targets.size] = tank;
			}
		}
		actors = getactorarray();
		foreach(actor in actors)
		{
			if(isdefined(actor) && isdefined(actor.isaiclone) && isalive(actor))
			{
				if(self cantargetactor_turret(actor, hardpointtype))
				{
					targets[targets.size] = actor;
				}
			}
		}
		if(targets.size == 0 && targetsmissile.size == 0)
		{
			self.primarytarget = undefined;
			self.secondarytarget = undefined;
			debug_print_target();
			self setgoalyaw(randomint(360));
			wait(self.targeting_delay);
			continue;
		}
		if(targets.size == 1)
		{
			if(isdefined(targets[0].isaiclone))
			{
				killstreaks::update_actor_threat(targets[0]);
			}
			else
			{
				if(isdefined(targets[0].type) && (targets[0].type == "dog" || targets[0].type == "tank_drone"))
				{
					killstreaks::update_dog_threat(targets[0]);
				}
				else
				{
					if(isdefined(targets[0].killstreaktype))
					{
						killstreaks::update_non_player_threat(targets[0]);
					}
					else
					{
						killstreaks::update_player_threat(targets[0]);
					}
				}
			}
			self.primarytarget = targets[0];
			self notify(#"hash_907788c7");
			self.secondarytarget = undefined;
			debug_print_target();
		}
		else if(targets.size > 1)
		{
			assignprimarytargets(targets);
		}
		if(targetsmissile.size == 1)
		{
			if(!isdefined(targetsmissile[0].type) || targetsmissile[0].type != "dog" || targets[0].type == "tank_drone")
			{
				self killstreaks::update_missile_player_threat(targetsmissile[0]);
			}
			else if(targetsmissile[0].type == "dog")
			{
				self killstreaks::update_missile_dog_threat(targetsmissile[0]);
			}
			self.secondarytarget = targetsmissile[0];
			self notify(#"hash_519af70b");
			debug_print_target();
		}
		else if(targetsmissile.size > 1)
		{
			assignsecondarytargets(targetsmissile);
		}
		wait(self.targeting_delay);
		debug_print_target();
	}
}

/*
	Name: cantargetplayer_turret
	Namespace: helicopter
	Checksum: 0x3C2D61E4
	Offset: 0x4818
	Size: 0x240
	Parameters: 2
	Flags: Linked
*/
function cantargetplayer_turret(player, hardpointtype)
{
	cantarget = 1;
	if(!isalive(player) || player.sessionstate != "playing")
	{
		return 0;
	}
	if(player.ignoreme === 1)
	{
		return 0;
	}
	if(player == self.owner)
	{
		self check_owner(hardpointtype);
		return 0;
	}
	if(player airsupport::cantargetplayerwithspecialty() == 0)
	{
		return 0;
	}
	if(distance(player.origin, self.origin) > level.heli_visual_range)
	{
		return 0;
	}
	if(!isdefined(player.team))
	{
		return 0;
	}
	if(level.teambased && player.team == self.team)
	{
		return 0;
	}
	if(player.team == "spectator")
	{
		return 0;
	}
	if(isdefined(player.spawntime) && ((gettime() - player.spawntime) / 1000) <= level.heli_target_spawnprotection)
	{
		return 0;
	}
	heli_centroid = self.origin + (vectorscale((0, 0, -1), 160));
	heli_forward_norm = anglestoforward(self.angles);
	heli_turret_point = heli_centroid + (144 * heli_forward_norm);
	visible_amount = player sightconetrace(heli_turret_point, self);
	if(visible_amount < level.heli_target_recognition)
	{
		return 0;
	}
	return cantarget;
}

/*
	Name: cantargetactor_turret
	Namespace: helicopter
	Checksum: 0xA28F99DE
	Offset: 0x4A60
	Size: 0x190
	Parameters: 2
	Flags: Linked
*/
function cantargetactor_turret(actor, hardpointtype)
{
	helicopter = self;
	cantarget = 1;
	if(!isalive(actor))
	{
		return actor;
	}
	if(!isdefined(actor.team))
	{
		return 0;
	}
	if(level.teambased && actor.team == helicopter.team)
	{
		return 0;
	}
	if(distancesquared(actor.origin, helicopter.origin) > (level.heli_visual_range * level.heli_visual_range))
	{
		return 0;
	}
	heli_centroid = helicopter.origin + (vectorscale((0, 0, -1), 160));
	heli_forward_norm = anglestoforward(helicopter.angles);
	heli_turret_point = heli_centroid + (144 * heli_forward_norm);
	visible_amount = actor sightconetrace(heli_turret_point, helicopter);
	if(visible_amount < level.heli_target_recognition)
	{
		return 0;
	}
	return cantarget;
}

/*
	Name: getverticaltan
	Namespace: helicopter
	Checksum: 0xA14C30FB
	Offset: 0x4BF8
	Size: 0xE4
	Parameters: 2
	Flags: None
*/
function getverticaltan(startorigin, endorigin)
{
	vector = endorigin - startorigin;
	opposite = startorigin[2] - endorigin[2];
	if(opposite < 0)
	{
		opposite = opposite * 1;
	}
	adjacent = distance2d(startorigin, endorigin);
	if(adjacent < 0)
	{
		adjacent = adjacent * 1;
	}
	if(adjacent < 0.01)
	{
		adjacent = 0.01;
	}
	tangent = opposite / adjacent;
	return tangent;
}

/*
	Name: cantargetplayer_missile
	Namespace: helicopter
	Checksum: 0xB76D3800
	Offset: 0x4CE8
	Size: 0x2A6
	Parameters: 2
	Flags: Linked
*/
function cantargetplayer_missile(player, hardpointtype)
{
	cantarget = 1;
	if(!isalive(player) || player.sessionstate != "playing")
	{
		return 0;
	}
	if(player.ignoreme === 1)
	{
		return 0;
	}
	if(player == self.owner)
	{
		self check_owner(hardpointtype);
		return 0;
	}
	if(player airsupport::cantargetplayerwithspecialty() == 0)
	{
		return 0;
	}
	if(distance(player.origin, self.origin) > level.heli_missile_range)
	{
		return 0;
	}
	if(!isdefined(player.team))
	{
		return 0;
	}
	if(level.teambased && player.team == self.team)
	{
		return 0;
	}
	if(player.team == "spectator")
	{
		return 0;
	}
	if(isdefined(player.spawntime) && ((gettime() - player.spawntime) / 1000) <= level.heli_target_spawnprotection)
	{
		return 0;
	}
	if(self target_cone_check(player, level.heli_missile_target_cone) == 0)
	{
		return 0;
	}
	heli_centroid = self.origin + (vectorscale((0, 0, -1), 160));
	heli_forward_norm = anglestoforward(self.angles);
	heli_turret_point = heli_centroid + (144 * heli_forward_norm);
	if(!isdefined(player.lasthit))
	{
		player.lasthit = 0;
	}
	player.lasthit = self heliturretsighttrace(heli_turret_point, player, player.lasthit);
	if(player.lasthit != 0)
	{
		return 0;
	}
	return cantarget;
}

/*
	Name: cantargetdog_turret
	Namespace: helicopter
	Checksum: 0x39A65B5B
	Offset: 0x4F98
	Size: 0x1B6
	Parameters: 1
	Flags: Linked
*/
function cantargetdog_turret(dog)
{
	cantarget = 1;
	if(!isdefined(dog))
	{
		return 0;
	}
	if(distance(dog.origin, self.origin) > level.heli_visual_range)
	{
		return 0;
	}
	if(!isdefined(dog.team))
	{
		return 0;
	}
	if(level.teambased && dog.team == self.team)
	{
		return 0;
	}
	if(isdefined(dog.script_owner) && self.owner == dog.script_owner)
	{
		return 0;
	}
	heli_centroid = self.origin + (vectorscale((0, 0, -1), 160));
	heli_forward_norm = anglestoforward(self.angles);
	heli_turret_point = heli_centroid + (144 * heli_forward_norm);
	if(!isdefined(dog.lasthit))
	{
		dog.lasthit = 0;
	}
	dog.lasthit = self heliturretdogtrace(heli_turret_point, dog, dog.lasthit);
	if(dog.lasthit != 0)
	{
		return 0;
	}
	return cantarget;
}

/*
	Name: cantargetdog_missile
	Namespace: helicopter
	Checksum: 0xDC655CAF
	Offset: 0x5158
	Size: 0x1B6
	Parameters: 1
	Flags: Linked
*/
function cantargetdog_missile(dog)
{
	cantarget = 1;
	if(!isdefined(dog))
	{
		return 0;
	}
	if(distance(dog.origin, self.origin) > level.heli_missile_range)
	{
		return 0;
	}
	if(!isdefined(dog.team))
	{
		return 0;
	}
	if(level.teambased && dog.team == self.team)
	{
		return 0;
	}
	if(isdefined(dog.script_owner) && self.owner == dog.script_owner)
	{
		return 0;
	}
	heli_centroid = self.origin + (vectorscale((0, 0, -1), 160));
	heli_forward_norm = anglestoforward(self.angles);
	heli_turret_point = heli_centroid + (144 * heli_forward_norm);
	if(!isdefined(dog.lasthit))
	{
		dog.lasthit = 0;
	}
	dog.lasthit = self heliturretdogtrace(heli_turret_point, dog, dog.lasthit);
	if(dog.lasthit != 0)
	{
		return 0;
	}
	return cantarget;
}

/*
	Name: cantargettank_turret
	Namespace: helicopter
	Checksum: 0x360AE6BC
	Offset: 0x5318
	Size: 0xF0
	Parameters: 1
	Flags: Linked
*/
function cantargettank_turret(tank)
{
	cantarget = 1;
	if(!isdefined(tank))
	{
		return 0;
	}
	if(tank.ignoreme === 1)
	{
		return 0;
	}
	if(distance(tank.origin, self.origin) > level.heli_visual_range)
	{
		return 0;
	}
	if(!isdefined(tank.team))
	{
		return 0;
	}
	if(level.teambased && tank.team == self.team)
	{
		return 0;
	}
	if(isdefined(tank.owner) && self.owner == tank.owner)
	{
		return 0;
	}
	return cantarget;
}

/*
	Name: assignprimarytargets
	Namespace: helicopter
	Checksum: 0x2505DC01
	Offset: 0x5410
	Size: 0x256
	Parameters: 1
	Flags: Linked
*/
function assignprimarytargets(targets)
{
	for(idx = 0; idx < targets.size; idx++)
	{
		if(isdefined(targets[idx].isaiclone))
		{
			killstreaks::update_actor_threat(targets[idx]);
			continue;
		}
		if(isdefined(targets[idx].type) && targets[idx].type == "dog")
		{
			killstreaks::update_dog_threat(targets[idx]);
			continue;
		}
		if(isplayer(targets[idx]))
		{
			killstreaks::update_player_threat(targets[idx]);
			continue;
		}
		killstreaks::update_non_player_threat(targets[idx]);
	}
	/#
		assert(targets.size >= 2, "");
	#/
	highest = 0;
	second_highest = 0;
	primarytarget = undefined;
	for(idx = 0; idx < targets.size; idx++)
	{
		/#
			assert(isdefined(targets[idx].threatlevel), "");
		#/
		if(targets[idx].threatlevel >= highest)
		{
			highest = targets[idx].threatlevel;
			primarytarget = targets[idx];
		}
	}
	/#
		assert(isdefined(primarytarget), "");
	#/
	self.primarytarget = primarytarget;
	self notify(#"hash_907788c7");
}

/*
	Name: assignsecondarytargets
	Namespace: helicopter
	Checksum: 0x214564FA
	Offset: 0x5670
	Size: 0x22E
	Parameters: 1
	Flags: Linked
*/
function assignsecondarytargets(targets)
{
	for(idx = 0; idx < targets.size; idx++)
	{
		if(!isdefined(targets[idx].type) || targets[idx].type != "dog")
		{
			self killstreaks::update_missile_player_threat(targets[idx]);
			continue;
		}
		if(targets[idx].type == "dog" || targets[0].type == "tank_drone")
		{
			killstreaks::update_missile_dog_threat(targets[idx]);
		}
	}
	/#
		assert(targets.size >= 2, "");
	#/
	highest = 0;
	second_highest = 0;
	primarytarget = undefined;
	secondarytarget = undefined;
	for(idx = 0; idx < targets.size; idx++)
	{
		/#
			assert(isdefined(targets[idx].missilethreatlevel), "");
		#/
		if(targets[idx].missilethreatlevel >= highest)
		{
			highest = targets[idx].missilethreatlevel;
			secondarytarget = targets[idx];
		}
	}
	/#
		assert(isdefined(secondarytarget), "");
	#/
	self.secondarytarget = secondarytarget;
	self notify(#"hash_519af70b");
}

/*
	Name: heli_reset
	Namespace: helicopter
	Checksum: 0x9289C20B
	Offset: 0x58A8
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function heli_reset()
{
	self cleartargetyaw();
	self cleargoalyaw();
	self setspeed(60, 25);
	self setyawspeed(75, 45, 45);
	self setmaxpitchroll(30, 30);
	self setneargoalnotifydist(256);
	self setturningability(0.9);
}

/*
	Name: heli_wait
	Namespace: helicopter
	Checksum: 0xA63952D6
	Offset: 0x5980
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function heli_wait(waittime)
{
	self endon(#"death");
	self endon(#"crashing");
	self endon(#"evasive");
	self thread heli_hover();
	wait(waittime);
	heli_reset();
	self notify(#"hash_38f853e7");
}

/*
	Name: heli_hover
	Namespace: helicopter
	Checksum: 0xC0C1A218
	Offset: 0x59F8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function heli_hover()
{
	self endon(#"death");
	self endon(#"hash_38f853e7");
	self endon(#"evasive");
	self endon(#"leaving");
	self endon(#"crashing");
	randint = randomint(360);
	self setgoalyaw(self.angles[1] + randint);
}

/*
	Name: wait_for_killed
	Namespace: helicopter
	Checksum: 0x7C914A5D
	Offset: 0x5A90
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function wait_for_killed()
{
	self endon(#"death");
	self endon(#"crashing");
	self endon(#"leaving");
	self.bda = 0;
	while(true)
	{
		self waittill(#"killed", victim);
		if(!isdefined(self.owner) || !isdefined(victim))
		{
			continue;
		}
		if(self.owner == victim)
		{
			continue;
		}
		if(level.teambased && self.owner.team == victim.team)
		{
			continue;
		}
		self thread wait_for_bda_timeout();
	}
}

/*
	Name: wait_for_bda_timeout
	Namespace: helicopter
	Checksum: 0x1F02D7E8
	Offset: 0x5B68
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function wait_for_bda_timeout()
{
	self endon(#"killed");
	wait(2.5);
	if(!isdefined(self))
	{
		return;
	}
	self play_bda_dialog();
}

/*
	Name: play_bda_dialog
	Namespace: helicopter
	Checksum: 0xF425599E
	Offset: 0x5BA8
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function play_bda_dialog()
{
	if(self.bda == 1)
	{
		bdadialog = "kill1";
	}
	else
	{
		if(self.bda == 2)
		{
			bdadialog = "kill2";
		}
		else
		{
			if(self.bda == 3)
			{
				bdadialog = "kill3";
			}
			else if(self.bda > 3)
			{
				bdadialog = "killMultiple";
			}
		}
	}
	self killstreaks::play_pilot_dialog_on_owner(bdadialog, self.killstreaktype, self.killstreak_id);
	self notify(#"bda_dialog", bdadialog);
	self.bda = 0;
}

/*
	Name: heli_hacked_health_update
	Namespace: helicopter
	Checksum: 0xECE16515
	Offset: 0x5C80
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function heli_hacked_health_update(hacker)
{
	helicopter = self;
	hackeddamagetaken = helicopter.maxhealth - helicopter.hackedhealth;
	/#
		assert(hackeddamagetaken > 0);
	#/
	if(hackeddamagetaken > helicopter.damagetaken)
	{
		helicopter.damagetaken = hackeddamagetaken;
	}
}

/*
	Name: heli_damage_monitor
	Namespace: helicopter
	Checksum: 0xA78CA9A8
	Offset: 0x5D18
	Size: 0xBE8
	Parameters: 1
	Flags: Linked
*/
function heli_damage_monitor(hardpointtype)
{
	helicopter = self;
	self endon(#"death");
	self endon(#"crashing");
	self.damagetaken = 0;
	last_hit_vo = 0;
	hit_vo_spacing = 6000;
	tablehealth = killstreak_bundles::get_max_health(hardpointtype);
	if(isdefined(tablehealth))
	{
		self.maxhealth = tablehealth;
	}
	helicopter.hackedhealthupdatecallback = &heli_hacked_health_update;
	helicopter.hackedhealth = killstreak_bundles::get_hacked_health(hardpointtype);
	if(!isdefined(self.attackerdata))
	{
		self.attackers = [];
		self.attackerdata = [];
		self.attackerdamage = [];
		self.flareattackerdamage = [];
	}
	for(;;)
	{
		self waittill(#"damage", damage, attacker, direction, point, type, modelname, tagname, partname, weapon, flags, inflictor, chargelevel);
		if(!isdefined(attacker) || !isplayer(attacker))
		{
			continue;
		}
		heli_friendlyfire = weaponobjects::friendlyfirecheck(self.owner, attacker);
		if(!heli_friendlyfire)
		{
			continue;
		}
		if(!level.hardcoremode)
		{
			if(isdefined(self.owner) && attacker == self.owner)
			{
				continue;
			}
			if(level.teambased)
			{
				isvalidattacker = isdefined(attacker.team) && attacker.team != self.team;
			}
			else
			{
				isvalidattacker = 1;
			}
			if(!isvalidattacker)
			{
				continue;
			}
		}
		self.attacker = attacker;
		weapon_damage = killstreak_bundles::get_weapon_damage(hardpointtype, self.maxhealth, attacker, weapon, type, damage, flags, chargelevel);
		if(!isdefined(weapon_damage))
		{
			if(type == "MOD_RIFLE_BULLET" || type == "MOD_PISTOL_BULLET")
			{
				hasfmj = attacker hasperk("specialty_armorpiercing");
				if(hasfmj)
				{
					damage = damage + (int(damage * level.cac_armorpiercing_data));
				}
				damage = damage * level.heli_armor_bulletdamage;
			}
			else if(type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH" || type == "MOD_EXPLOSIVE")
			{
				shouldupdatedamage = weapon.statindex != level.weaponpistolenergy.statindex && weapon.statindex != level.weaponspecialcrossbow.statindex && weapon.statindex != level.weaponsmgnailgun.statindex;
				if(shouldupdatedamage)
				{
					switch(weapon.name)
					{
						case "tow_turret":
						{
							if(isdefined(self.rocketdamagetwoshot))
							{
								damage = self.rocketdamagetwoshot;
							}
							else if(isdefined(self.rocketdamageoneshot))
							{
								damage = self.rocketdamageoneshot;
							}
							break;
						}
						default:
						{
							if(isdefined(self.rocketdamageoneshot))
							{
								damage = self.rocketdamageoneshot;
							}
							break;
						}
					}
				}
			}
			weapon_damage = damage;
		}
		if(weapon_damage > 0)
		{
			self challenges::trackassists(attacker, weapon_damage, 0);
		}
		self.damagetaken = self.damagetaken + weapon_damage;
		playercontrolled = 0;
		if(self.damagetaken > self.maxhealth && !isdefined(self.xpgiven))
		{
			self.xpgiven = 1;
			switch(hardpointtype)
			{
				case "helicopter_gunner":
				{
					playercontrolled = 1;
					event = "destroyed_vtol_mothership";
					jump loc_000063A8;
				}
				case "helicopter_comlink":
				case "inventory_helicopter_comlink":
				{
					event = "destroyed_helicopter_comlink";
					if(self.leaving !== 1)
					{
						self killstreaks::play_destroyed_dialog_on_owner(self.killstreaktype, self.killstreak_id);
					}
					jump loc_000063A8;
				}
				case "supply_drop":
				case "supply_drop_combat_robot":
				{
					if(isdefined(helicopter.killstreakweaponname))
					{
						switch(helicopter.killstreakweaponname)
						{
							case "ai_tank_drop":
							case "ai_tank_drop_marker":
							case "ai_tank_marker":
							case "inventory_ai_tank_drop":
							case "inventory_ai_tank_marker":
							{
								event = "destroyed_helicopter_agr_drop";
								break;
							}
							case "combat_robot_drop":
							case "combat_robot_marker":
							case "inventory_combat_robot_drop":
							case "inventory_combat_robot_marker":
							{
								event = "destroyed_helicopter_giunit_drop";
								break;
							}
							default:
							{
								event = "destroyed_helicopter_supply_drop";
								break;
							}
						}
					}
					else
					{
						event = "destroyed_helicopter_supply_drop";
					}
					break;
				}
			}
			if(isdefined(event))
			{
				if(isdefined(self.owner) && self.owner util::isenemyplayer(attacker))
				{
					challenges::destroyedhelicopter(attacker, weapon, type, 0);
					challenges::destroyedaircraft(attacker, weapon, playercontrolled);
					scoreevents::processscoreevent(event, attacker, self.owner, weapon);
					attacker challenges::addflyswatterstat(weapon, self);
					if(playercontrolled == 1)
					{
						attacker challenges::destroyedplayercontrolledaircraft();
					}
					if(hardpointtype == "helicopter_player_gunner")
					{
						attacker addweaponstat(weapon, "destroyed_controlled_killstreak", 1);
					}
				}
			}
			weaponstatname = "destroyed";
			switch(weapon.name)
			{
				case "auto_tow":
				case "tow_turret":
				case "tow_turret_drop":
				{
					weaponstatname = "kills";
					break;
				}
			}
			attacker addweaponstat(weapon, weaponstatname, 1);
			notifystring = undefined;
			killstreakreference = undefined;
			switch(hardpointtype)
			{
				case "helicopter_gunner":
				{
					killstreakreference = "killstreak_helicopter_gunner";
					break;
				}
				case "helicopter_player_gunner":
				{
					killstreakreference = "killstreak_helicopter_player_gunner";
					break;
				}
				case "helicopter_player_firstperson":
				{
					killstreakreference = "killstreak_helicopter_player_firstperson";
					break;
				}
				case "helicopter":
				case "helicopter_comlink":
				case "helicopter_x2":
				case "inventory_helicopter_comlink":
				{
					notifystring = &"KILLSTREAK_DESTROYED_HELICOPTER";
					killstreakreference = "killstreak_helicopter_comlink";
					break;
				}
				case "supply_drop":
				{
					notifystring = &"KILLSTREAK_DESTROYED_SUPPLY_DROP_DEPLOY_SHIP";
					killstreakreference = "killstreak_supply_drop";
					break;
				}
				case "helicopter_guard":
				{
					killstreakreference = "killstreak_helicopter_guard";
				}
			}
			if(isdefined(killstreakreference))
			{
				level.globalkillstreaksdestroyed++;
				attacker addweaponstat(getweapon(hardpointtype), "destroyed", 1);
			}
			if(hardpointtype == "helicopter_player_gunner")
			{
				self.owner sendkillstreakdamageevent(600);
			}
			if(isdefined(notifystring))
			{
				luinotifyevent(&"player_callout", 2, notifystring, attacker.entnum);
			}
			if(isdefined(self.attackers))
			{
				for(j = 0; j < self.attackers.size; j++)
				{
					player = self.attackers[j];
					if(!isdefined(player))
					{
						continue;
					}
					if(player == attacker)
					{
						continue;
					}
					flare_done = self.flareattackerdamage[player.clientid];
					if(isdefined(flare_done) && flare_done == 1)
					{
						scoreevents::processscoreevent("aircraft_flare_assist", player);
						continue;
					}
					damage_done = self.attackerdamage[player.clientid];
					player thread processcopterassist(self, damage_done);
				}
				self.attackers = [];
			}
			attacker notify(#"destroyed_helicopter");
			if(target_istarget(self))
			{
				target_remove(self);
			}
		}
		else if(isdefined(self.owner) && isplayer(self.owner))
		{
			if((last_hit_vo + hit_vo_spacing) < gettime())
			{
				if(type == "MOD_PROJECTILE" || randomintrange(0, 3) == 0)
				{
					last_hit_vo = gettime();
				}
			}
		}
		if(hardpointtype == "helicopter_comlink" || hardpointtype == "inventory_helicopter_comlink")
		{
			self thread heli_active_camo_damage_update(damage);
		}
	}
}

/*
	Name: init_active_camo
	Namespace: helicopter
	Checksum: 0xCA90174F
	Offset: 0x6908
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function init_active_camo()
{
	heli = self;
	heli.active_camo_supported = 1;
	heli.active_camo_damage = 0;
	heli.active_camo_disabled = 0;
	heli.camo_state = 0;
	heli_set_active_camo_state(1);
	if(isdefined(heli.flak_drone))
	{
		heli.flak_drone flak_drone::setcamostate(1);
	}
}

/*
	Name: heli_set_active_camo_state
	Namespace: helicopter
	Checksum: 0x64170790
	Offset: 0x69B8
	Size: 0x274
	Parameters: 1
	Flags: Linked
*/
function heli_set_active_camo_state(state)
{
	heli = self;
	if(!isdefined(heli.active_camo_supported))
	{
		return;
	}
	if(state == 0)
	{
		heli clientfield::set("toggle_lights", 1);
		if(heli.camo_state == 1)
		{
			heli playsound("veh_hind_cloak_off");
		}
		heli.camo_state = 0;
		heli.camo_state_switch_time = gettime();
	}
	else
	{
		if(state == 1)
		{
			if(heli.active_camo_disabled)
			{
				return;
			}
			heli clientfield::set("toggle_lights", 0);
			if(heli.camo_state == 0)
			{
				heli playsound("veh_hind_cloak_on");
			}
			heli.camo_state = 1;
			heli.camo_state_switch_time = gettime();
			if(isdefined(heli.owner))
			{
				if(isdefined(heli.play_camo_dialog) && heli.play_camo_dialog)
				{
					heli killstreaks::play_pilot_dialog_on_owner("activateCounter", "helicopter_comlink", self.killstreak_id);
					heli.play_camo_dialog = 0;
				}
				else if(!isdefined(heli.play_camo_dialog))
				{
					heli.play_camo_dialog = 1;
				}
			}
		}
		else if(state == 2)
		{
			heli clientfield::set("toggle_lights", 1);
		}
	}
	if(isdefined(heli.flak_drone))
	{
		heli.flak_drone flak_drone::setcamostate(state);
	}
	heli clientfield::set("active_camo", state);
}

/*
	Name: heli_active_camo_damage_update
	Namespace: helicopter
	Checksum: 0x914B74FF
	Offset: 0x6C38
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function heli_active_camo_damage_update(damage)
{
	self endon(#"death");
	self endon(#"crashing");
	heli = self;
	heli.active_camo_damage = heli.active_camo_damage + damage;
	if(heli.active_camo_damage > 100)
	{
		heli.active_camo_disabled = 1;
		heli thread heli_active_camo_damage_disable();
	}
	else
	{
		heli heli_set_active_camo_state(2);
		wait(1);
		heli heli_set_active_camo_state(1);
	}
}

/*
	Name: heli_active_camo_damage_disable
	Namespace: helicopter
	Checksum: 0x97EA038C
	Offset: 0x6D18
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function heli_active_camo_damage_disable()
{
	self endon(#"death");
	self endon(#"crashing");
	heli = self;
	heli notify(#"heli_active_camo_damage_disable");
	heli endon(#"heli_active_camo_damage_disable");
	heli heli_set_active_camo_state(0);
	wait(10);
	heli.active_camo_damage = 0;
	heli.active_camo_disabled = 0;
	heli heli_set_active_camo_state(1);
}

/*
	Name: heli_health
	Namespace: helicopter
	Checksum: 0x1DCA9C4
	Offset: 0x6DC0
	Size: 0x458
	Parameters: 2
	Flags: Linked
*/
function heli_health(hardpointtype, playernotify)
{
	self endon(#"death");
	self endon(#"crashing");
	self.currentstate = "ok";
	self.laststate = "ok";
	self setdamagestage(3);
	damagestate = 3;
	tablehealth = killstreak_bundles::get_max_health(hardpointtype);
	if(isdefined(tablehealth))
	{
		self.maxhealth = tablehealth;
	}
	for(;;)
	{
		self waittill(#"damage", damage, attacker, direction, point, type, modelname, tagname, partname, weapon);
		wait(0.05);
		if(self.damagetaken > self.maxhealth)
		{
			damagestate = 0;
			self setdamagestage(damagestate);
			self heli_set_active_camo_state(0);
			self thread heli_crash(hardpointtype, self.owner, playernotify);
		}
		else
		{
			if(self.damagetaken >= (self.maxhealth * 0.66) && damagestate >= 2)
			{
				self killstreaks::play_pilot_dialog_on_owner("damaged", "helicopter_comlink", self.killstreak_id);
				if(isdefined(self.vehicletype) && self.vehicletype == "heli_player_gunner_mp")
				{
					playfxontag(level.chopper_fx["damage"]["heavy_smoke"], self, "tag_origin");
				}
				else
				{
					playfxontag(level.chopper_fx["damage"]["heavy_smoke"], self, "tag_main_rotor");
				}
				damagestate = 1;
				self.currentstate = "heavy smoke";
				self.evasive = 1;
				self notify(#"hash_2b25e23d");
			}
			else if(self.damagetaken >= (self.maxhealth * 0.33) && damagestate == 3)
			{
				if(isdefined(self.vehicletype) && self.vehicletype == "heli_player_gunner_mp")
				{
					playfxontag(level.chopper_fx["damage"]["light_smoke"], self, "tag_origin");
				}
				else
				{
					playfxontag(level.chopper_fx["damage"]["light_smoke"], self, "tag_main_rotor");
				}
				damagestate = 2;
				self.currentstate = "light smoke";
				self notify(#"hash_2b25e23d");
			}
		}
		if(self.damagetaken <= level.heli_armor)
		{
			airsupport::debug_print3d_simple("Armor: " + (level.heli_armor - self.damagetaken), self, vectorscale((0, 0, 1), 100), 20);
			continue;
		}
		airsupport::debug_print3d_simple("Health: " + (self.maxhealth - self.damagetaken), self, vectorscale((0, 0, 1), 100), 20);
	}
}

/*
	Name: heli_evasive
	Namespace: helicopter
	Checksum: 0xC809114D
	Offset: 0x7220
	Size: 0x164
	Parameters: 1
	Flags: Linked
*/
function heli_evasive(hardpointtype)
{
	self notify(#"evasive");
	self.evasive = 1;
	loop_startnode = level.heli_loop_paths[0];
	gunnerpathfound = 1;
	if(hardpointtype == "helicopter_gunner")
	{
		gunnerpathfound = 0;
		for(i = 0; i < level.heli_loop_paths.size; i++)
		{
			if(isdefined(level.heli_loop_paths[i].isgunnerpath) && level.heli_loop_paths[i].isgunnerpath)
			{
				loop_startnode = level.heli_loop_paths[i];
				gunnerpathfound = 1;
				break;
			}
		}
	}
	/#
		assert(gunnerpathfound, "");
	#/
	startwait = 2;
	if(isdefined(self.donotstop) && self.donotstop)
	{
		startwait = 0;
	}
	self thread heli_fly(loop_startnode, startwait, hardpointtype);
}

/*
	Name: notify_player
	Namespace: helicopter
	Checksum: 0x83970B31
	Offset: 0x7390
	Size: 0x5C
	Parameters: 3
	Flags: Linked
*/
function notify_player(player, playernotify, delay)
{
	if(!isdefined(player))
	{
		return;
	}
	if(!isdefined(playernotify))
	{
		return;
	}
	player endon(#"disconnect");
	player endon(playernotify);
	wait(delay);
	player notify(playernotify);
}

/*
	Name: play_going_down_vo
	Namespace: helicopter
	Checksum: 0xA9C1E7E1
	Offset: 0x73F8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function play_going_down_vo(delay)
{
	self.owner endon(#"disconnect");
	self endon(#"death");
	wait(delay);
}

/*
	Name: heli_crash
	Namespace: helicopter
	Checksum: 0x796DEC9E
	Offset: 0x7430
	Size: 0x4AC
	Parameters: 3
	Flags: Linked
*/
function heli_crash(hardpointtype, player, playernotify)
{
	self endon(#"death");
	self notify(#"crashing");
	self spawning::remove_influencers();
	self stoploopsound(0);
	if(isdefined(self.minigun_snd_ent))
	{
		self.minigun_snd_ent stoploopsound();
	}
	if(isdefined(self.alarm_snd_ent))
	{
		self.alarm_snd_ent stoploopsound();
	}
	crashtypes = [];
	crashtypes[0] = "crashOnPath";
	crashtypes[1] = "spinOut";
	crashtype = crashtypes[randomint(2)];
	if(isdefined(self.crashtype))
	{
		crashtype = self.crashtype;
	}
	/#
		if(level.heli_debug_crash)
		{
			switch(level.heli_debug_crash)
			{
				case 1:
				{
					crashtype = "";
					break;
				}
				case 2:
				{
					crashtype = "";
					break;
				}
				case 3:
				{
					crashtype = "";
					break;
				}
				default:
				{
				}
			}
		}
	#/
	switch(crashtype)
	{
		case "explode":
		{
			thread notify_player(player, playernotify, 0);
			self thread heli_explode();
			break;
		}
		case "crashOnPath":
		{
			if(isdefined(player))
			{
				self thread play_going_down_vo(0.5);
			}
			thread notify_player(player, playernotify, 4);
			self clear_client_flags();
			self thread crashonnearestcrashpath(hardpointtype);
			break;
		}
		case "spinOut":
		{
			if(isdefined(player))
			{
				self thread play_going_down_vo(0.5);
			}
			thread notify_player(player, playernotify, 4);
			self clear_client_flags();
			heli_reset();
			heli_speed = 30 + randomint(50);
			heli_accel = 10 + randomint(25);
			leavenode = getvalidrandomcrashnode(self.origin);
			self setspeed(heli_speed, heli_accel);
			self set_goal_pos(leavenode.origin, 0);
			rateofspin = 45 + randomint(90);
			thread heli_secondary_explosions();
			self thread heli_spin(rateofspin);
			self util::waittill_any_timeout(randomintrange(4, 6), "near_goal");
			if(isdefined(player) && isdefined(playernotify))
			{
				player notify(playernotify);
			}
			self thread heli_explode();
			break;
		}
	}
	self thread explodeoncontact(hardpointtype);
	time = randomintrange(4, 6);
	self thread waitthenexplode(time);
}

/*
	Name: damagedrotorfx
	Namespace: helicopter
	Checksum: 0xED3430E2
	Offset: 0x78E8
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function damagedrotorfx()
{
	self endon(#"death");
	self setrotorspeed(0.6);
}

/*
	Name: waitthenexplode
	Namespace: helicopter
	Checksum: 0xEA8D9413
	Offset: 0x7920
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function waitthenexplode(time)
{
	self endon(#"death");
	wait(time);
	self thread heli_explode();
}

/*
	Name: crashonnearestcrashpath
	Namespace: helicopter
	Checksum: 0x43127D8F
	Offset: 0x7960
	Size: 0x1E4
	Parameters: 1
	Flags: Linked
*/
function crashonnearestcrashpath(hardpointtype)
{
	crashpathdistance = -1;
	crashpath = level.heli_crash_paths[0];
	for(i = 0; i < level.heli_crash_paths.size; i++)
	{
		currentdistance = distance(self.origin, level.heli_crash_paths[i].origin);
		if(crashpathdistance == -1 || crashpathdistance > currentdistance)
		{
			crashpathdistance = currentdistance;
			crashpath = level.heli_crash_paths[i];
		}
	}
	heli_speed = 30 + randomint(50);
	heli_accel = 10 + randomint(25);
	self setspeed(heli_speed, heli_accel);
	thread heli_secondary_explosions();
	self thread heli_fly(crashpath, 0, hardpointtype);
	rateofspin = 45 + randomint(90);
	self thread heli_spin(rateofspin);
	self waittill(#"hash_df5908ac");
	self waittill(#"hash_9b1f1e2d");
	self thread heli_explode();
}

/*
	Name: checkhelicoptertag
	Namespace: helicopter
	Checksum: 0x4C7E7C25
	Offset: 0x7B50
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function checkhelicoptertag(tagname)
{
	if(isdefined(self.model))
	{
		if(self.model == "veh_t7_drone_hunter")
		{
			switch(tagname)
			{
				case "tag_engine_left":
				{
					return "tag_fx_exhaust2";
				}
				case "tag_engine_right":
				{
					return "tag_fx_exhaust1";
				}
				case "tail_rotor_jnt":
				{
					return "tag_fx_tail";
				}
				default:
				{
					break;
				}
			}
		}
	}
	return tagname;
}

/*
	Name: heli_secondary_explosions
	Namespace: helicopter
	Checksum: 0x863DD9F1
	Offset: 0x7BD8
	Size: 0x244
	Parameters: 0
	Flags: Linked
*/
function heli_secondary_explosions()
{
	self endon(#"death");
	playfxontag(level.chopper_fx["explode"]["large"], self, self checkhelicoptertag("tag_engine_left"));
	self playsound(level.heli_sound["hit"]);
	if(isdefined(self.vehicletype) && self.vehicletype == "heli_player_gunner_mp")
	{
		self thread trail_fx(level.chopper_fx["smoke"]["trail"], self checkhelicoptertag("tag_engine_right"), "stop tail smoke");
	}
	else
	{
		self thread trail_fx(level.chopper_fx["smoke"]["trail"], self checkhelicoptertag("tail_rotor_jnt"), "stop tail smoke");
	}
	self setdamagestage(0);
	self thread trail_fx(level.chopper_fx["fire"]["trail"]["large"], self checkhelicoptertag("tag_engine_left"), "stop body fire");
	wait(3);
	if(!isdefined(self))
	{
		return;
	}
	playfxontag(level.chopper_fx["explode"]["large"], self, self checkhelicoptertag("tag_engine_left"));
	self playsound(level.heli_sound["hitsecondary"]);
}

/*
	Name: heli_spin
	Namespace: helicopter
	Checksum: 0x58AF75D3
	Offset: 0x7E28
	Size: 0x9E
	Parameters: 1
	Flags: Linked
*/
function heli_spin(speed)
{
	self endon(#"death");
	self thread spinsoundshortly();
	self setyawspeed(speed, speed / 3, speed / 3);
	while(isdefined(self))
	{
		self settargetyaw(self.angles[1] + (speed * 0.9));
		wait(1);
	}
}

/*
	Name: spinsoundshortly
	Namespace: helicopter
	Checksum: 0x86FEC863
	Offset: 0x7ED0
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function spinsoundshortly()
{
	self endon(#"death");
	wait(0.25);
	self stoploopsound();
	wait(0.05);
	self playloopsound(level.heli_sound["spinloop"]);
	wait(0.05);
	self playsound(level.heli_sound["spinstart"]);
}

/*
	Name: trail_fx
	Namespace: helicopter
	Checksum: 0xFF9A9CD0
	Offset: 0x7F68
	Size: 0x3C
	Parameters: 3
	Flags: Linked
*/
function trail_fx(trail_fx, trail_tag, stop_notify)
{
	playfxontag(trail_fx, self, trail_tag);
}

/*
	Name: destroyhelicopter
	Namespace: helicopter
	Checksum: 0x62218E3C
	Offset: 0x7FB0
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function destroyhelicopter()
{
	team = self.originalteam;
	if(target_istarget(self))
	{
		target_remove(self);
	}
	self spawning::remove_influencers();
	if(isdefined(self.interior_model))
	{
		self.interior_model delete();
		self.interior_model = undefined;
	}
	if(isdefined(self.minigun_snd_ent))
	{
		self.minigun_snd_ent stoploopsound();
		self.minigun_snd_ent delete();
		self.minigun_snd_ent = undefined;
	}
	if(isdefined(self.alarm_snd_ent))
	{
		self.alarm_snd_ent delete();
		self.alarm_snd_ent = undefined;
	}
	if(isdefined(self.flare_ent))
	{
		self.flare_ent delete();
		self.flare_ent = undefined;
	}
	killstreakrules::killstreakstop(self.hardpointtype, team, self.killstreak_id);
	self delete();
}

/*
	Name: heli_explode
	Namespace: helicopter
	Checksum: 0x7F2F4A66
	Offset: 0x8130
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function heli_explode()
{
	self endon(#"death");
	forward = (self.origin + vectorscale((0, 0, 1), 100)) - self.origin;
	if(isdefined(self.helitype) && self.helitype == "littlebird")
	{
		playfx(level.chopper_fx["explode"]["guard"], self.origin, forward);
	}
	else
	{
		if(isdefined(self.vehicletype) && self.vehicletype == "heli_player_gunner_mp")
		{
			playfx(level.chopper_fx["explode"]["gunner"], self.origin, forward);
		}
		else
		{
			playfx(level.chopper_fx["explode"]["death"], self.origin, forward);
		}
	}
	self playsound(level.heli_sound["crash"]);
	wait(0.1);
	/#
		assert(isdefined(self.destroyfunc));
	#/
	self [[self.destroyfunc]]();
}

/*
	Name: clear_client_flags
	Namespace: helicopter
	Checksum: 0xCE89C105
	Offset: 0x82D8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function clear_client_flags()
{
	self clientfield::set("heli_warn_fired", 0);
	self clientfield::set("heli_warn_targeted", 0);
	self clientfield::set("heli_warn_locked", 0);
}

/*
	Name: heli_leave
	Namespace: helicopter
	Checksum: 0xEDD27A21
	Offset: 0x8348
	Size: 0x2BC
	Parameters: 0
	Flags: Linked
*/
function heli_leave()
{
	self notify(#"hash_df1f87c9");
	self notify(#"leaving");
	hardpointtype = self.hardpointtype;
	self.leaving = 1;
	if(!(isdefined(self.detroyscoreeventgiven) && self.detroyscoreeventgiven))
	{
		self killstreaks::play_pilot_dialog_on_owner("timeout", hardpointtype);
		self killstreaks::play_taacom_dialog_response_on_owner("timeoutConfirmed", hardpointtype);
	}
	leavenode = getvalidrandomleavenode(self.origin);
	heli_reset();
	self clearlookatent();
	exitangles = vectortoangles(leavenode.origin - self.origin);
	self setgoalyaw(exitangles[1]);
	wait(1.5);
	if(!isdefined(self))
	{
		return;
	}
	self setspeed(180, 65);
	/#
		self util::debug_slow_heli_speed();
	#/
	self set_goal_pos((self.origin + ((leavenode.origin - self.origin) / 2)) + vectorscale((0, 0, 1), 1000), 0);
	self waittill(#"near_goal");
	if(isdefined(self))
	{
		self set_goal_pos(leavenode.origin, 1);
		self waittillmatch(#"goal");
		if(isdefined(self))
		{
			self stoploopsound(1);
			self util::death_notify_wrapper();
			if(isdefined(self.alarm_snd_ent))
			{
				self.alarm_snd_ent stoploopsound();
				self.alarm_snd_ent delete();
				self.alarm_snd_ent = undefined;
			}
			/#
				assert(isdefined(self.destroyfunc));
			#/
			self [[self.destroyfunc]]();
		}
	}
}

/*
	Name: heli_fly
	Namespace: helicopter
	Checksum: 0x12905098
	Offset: 0x8610
	Size: 0x51C
	Parameters: 3
	Flags: Linked
*/
function heli_fly(currentnode, startwait, hardpointtype)
{
	self endon(#"death");
	self endon(#"leaving");
	self notify(#"flying");
	self endon(#"flying");
	self endon(#"abandoned");
	self.reached_dest = 0;
	heli_reset();
	pos = self.origin;
	wait(startwait);
	while(isdefined(currentnode.target))
	{
		nextnode = getent(currentnode.target, "targetname");
		/#
			assert(isdefined(nextnode), "");
		#/
		pos = nextnode.origin + vectorscale((0, 0, 1), 30);
		if(isdefined(currentnode.script_airspeed) && isdefined(currentnode.script_accel))
		{
			heli_speed = currentnode.script_airspeed;
			heli_accel = currentnode.script_accel;
		}
		else
		{
			heli_speed = 30 + randomint(20);
			heli_accel = 10 + randomint(5);
		}
		if(isdefined(self.pathspeedscale))
		{
			heli_speed = heli_speed * self.pathspeedscale;
			heli_accel = heli_accel * self.pathspeedscale;
		}
		if(!isdefined(nextnode.target))
		{
			stop = 1;
		}
		else
		{
			stop = 0;
		}
		airsupport::debug_line(currentnode.origin, nextnode.origin, (1, 0.5, 0.5), 200);
		if(self.currentstate == "heavy smoke" || self.currentstate == "light smoke")
		{
			self setspeed(heli_speed, heli_accel);
			self set_goal_pos(pos, stop);
			self waittill(#"near_goal");
			self notify(#"hash_df5908ac");
		}
		else
		{
			if(isdefined(nextnode.script_delay) && !isdefined(self.donotstop))
			{
				stop = 1;
			}
			self setspeed(heli_speed, heli_accel);
			self set_goal_pos(pos, stop);
			if(!isdefined(nextnode.script_delay) || isdefined(self.donotstop))
			{
				self waittill(#"near_goal");
				self notify(#"hash_df5908ac");
			}
			else
			{
				self setgoalyaw(nextnode.angles[1]);
				self waittillmatch(#"goal");
				heli_wait(nextnode.script_delay);
			}
		}
		for(index = 0; index < level.heli_loop_paths.size; index++)
		{
			if(level.heli_loop_paths[index].origin == nextnode.origin)
			{
				self.loopcount++;
			}
		}
		if(self.loopcount >= level.heli_loopmax)
		{
			self thread heli_leave();
			return;
		}
		currentnode = nextnode;
	}
	self setgoalyaw(currentnode.angles[1]);
	self.reached_dest = 1;
	self notify(#"hash_9b1f1e2d");
	if(isdefined(self.waittime) && self.waittime > 0)
	{
		heli_wait(self.waittime);
	}
	if(isdefined(self))
	{
		self thread heli_evasive(hardpointtype);
	}
}

/*
	Name: heli_random_point_in_radius
	Namespace: helicopter
	Checksum: 0x86853B7D
	Offset: 0x8B38
	Size: 0x11C
	Parameters: 2
	Flags: Linked
*/
function heli_random_point_in_radius(protectdest, nodeheight)
{
	min_distance = int(level.heli_protect_radius * 0.2);
	direction = randomintrange(0, 360);
	distance = randomintrange(min_distance, level.heli_protect_radius);
	x = cos(direction);
	y = sin(direction);
	x = x * distance;
	y = y * distance;
	return (protectdest[0] + x, protectdest[1] + y, nodeheight);
}

/*
	Name: heli_get_protect_spot
	Namespace: helicopter
	Checksum: 0x174F8F69
	Offset: 0x8C60
	Size: 0x118
	Parameters: 2
	Flags: Linked
*/
function heli_get_protect_spot(protectdest, nodeheight)
{
	protect_spot = heli_random_point_in_radius(protectdest, nodeheight);
	tries = 10;
	noflyzone = airsupport::crossesnoflyzone(protectdest, protect_spot);
	while(tries != 0 && isdefined(noflyzone))
	{
		protect_spot = heli_random_point_in_radius(protectdest, nodeheight);
		tries--;
		noflyzone = airsupport::crossesnoflyzone(protectdest, protect_spot);
	}
	noflyzoneheight = airsupport::getnoflyzoneheightcrossed(protectdest, protect_spot, nodeheight);
	return (protect_spot[0], protect_spot[1], noflyzoneheight);
}

/*
	Name: wait_or_waittill
	Namespace: helicopter
	Checksum: 0xBE9FCF78
	Offset: 0x8D80
	Size: 0x46
	Parameters: 4
	Flags: Linked
*/
function wait_or_waittill(time, msg1, msg2, msg3)
{
	self endon(msg1);
	self endon(msg2);
	self endon(msg3);
	wait(time);
	return true;
}

/*
	Name: set_heli_speed_normal
	Namespace: helicopter
	Checksum: 0xFBA72374
	Offset: 0x8DD0
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function set_heli_speed_normal()
{
	self setmaxpitchroll(30, 30);
	heli_speed = 30 + randomint(20);
	heli_accel = 10 + randomint(5);
	self setspeed(heli_speed, heli_accel);
	self setyawspeed(75, 45, 45);
}

/*
	Name: set_heli_speed_evasive
	Namespace: helicopter
	Checksum: 0x5151E8F
	Offset: 0x8E88
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function set_heli_speed_evasive()
{
	self setmaxpitchroll(30, 90);
	heli_speed = 50 + randomint(20);
	heli_accel = 30 + randomint(5);
	self setspeed(heli_speed, heli_accel);
	self setyawspeed(100, 75, 75);
}

/*
	Name: set_heli_speed_hover
	Namespace: helicopter
	Checksum: 0x94F565C4
	Offset: 0x8F40
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function set_heli_speed_hover()
{
	self setmaxpitchroll(0, 90);
	self setspeed(20, 10);
	self setyawspeed(55, 25, 25);
}

/*
	Name: is_targeted
	Namespace: helicopter
	Checksum: 0xE594DF09
	Offset: 0x8FA8
	Size: 0x5A
	Parameters: 0
	Flags: Linked
*/
function is_targeted()
{
	if(isdefined(self.locking_on) && self.locking_on)
	{
		return true;
	}
	if(isdefined(self.locked_on) && self.locked_on)
	{
		return true;
	}
	if(isdefined(self.locking_on_hacking) && self.locking_on_hacking)
	{
		return true;
	}
	return false;
}

/*
	Name: heli_mobilespawn
	Namespace: helicopter
	Checksum: 0x389AD7D0
	Offset: 0x9010
	Size: 0x114
	Parameters: 1
	Flags: None
*/
function heli_mobilespawn(protectdest)
{
	self endon(#"death");
	self notify(#"flying");
	self endon(#"flying");
	self endon(#"abandoned");
	iprintlnbold(((((("PROTECT ORIGIN: (" + protectdest[0]) + ",") + protectdest[1]) + ",") + protectdest[2]) + ")\n");
	heli_reset();
	self sethoverparams(50, 100, 50);
	wait(2);
	set_heli_speed_normal();
	self set_goal_pos(protectdest, 1);
	self waittill(#"near_goal");
	set_heli_speed_hover();
}

/*
	Name: heli_protect
	Namespace: helicopter
	Checksum: 0x42FBE55
	Offset: 0x9130
	Size: 0x4F4
	Parameters: 4
	Flags: Linked
*/
function heli_protect(startnode, protectdest, hardpointtype, heli_team)
{
	self endon(#"death");
	self notify(#"flying");
	self endon(#"flying");
	self endon(#"abandoned");
	self.reached_dest = 0;
	heli_reset();
	self sethoverparams(50, 100, 50);
	wait(2);
	currentdest = protectdest;
	nodeheight = protectdest[2];
	nextnode = startnode;
	heightoffset = 0;
	if(heli_team == "axis")
	{
		heightoffset = 400;
	}
	protectdest = (protectdest[0], protectdest[1], nodeheight);
	noflyzoneheight = airsupport::getnoflyzoneheight(protectdest);
	protectdest = (protectdest[0], protectdest[1], noflyzoneheight + heightoffset);
	currentdest = protectdest;
	starttime = gettime();
	self.endtime = starttime + (level.heli_protect_time * 1000);
	self.killstreakendtime = int(self.endtime);
	self setspeed(150, 80);
	/#
		self util::debug_slow_heli_speed();
	#/
	self set_goal_pos((self.origin + ((currentdest - self.origin) / 3)) + vectorscale((0, 0, 1), 1000), 0);
	self waittill(#"near_goal");
	heli_speed = 30 + randomint(20);
	heli_accel = 10 + randomint(5);
	self thread updatetargetyaw();
	mapenter = 1;
	while(gettime() < self.endtime)
	{
		stop = 1;
		if(!mapenter)
		{
			self updatespeed();
		}
		else
		{
			mapenter = 0;
		}
		self set_goal_pos(currentdest, stop);
		self thread updatespeedonlock();
		self util::waittill_any("near_goal", "locking on", "locking on hacking");
		hostmigration::waittillhostmigrationdone();
		self notify(#"hash_df5908ac");
		if(!self is_targeted())
		{
			waittillframeend();
			time = level.heli_protect_pos_time;
			if(self.evasive == 1)
			{
				time = 2;
			}
			set_heli_speed_hover();
			wait_or_waittill(time, "locking on", "locking on hacking", "damage state");
		}
		else
		{
			wait(2);
		}
		prevdest = currentdest;
		currentdest = heli_get_protect_spot(protectdest, nodeheight);
		noflyzoneheight = airsupport::getnoflyzoneheight(currentdest);
		currentdest = (currentdest[0], currentdest[1], noflyzoneheight + heightoffset);
		noflyzones = airsupport::crossesnoflyzones(prevdest, currentdest);
		if(isdefined(noflyzones) && noflyzones.size > 0)
		{
			currentdest = prevdest;
		}
	}
	self heli_set_active_camo_state(1);
	self thread heli_leave();
}

/*
	Name: updatespeedonlock
	Namespace: helicopter
	Checksum: 0x515245ED
	Offset: 0x9630
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function updatespeedonlock()
{
	self endon(#"death");
	self endon(#"crashing");
	self endon(#"leaving");
	self util::waittill_any("near_goal", "locking on", "locking on hacking");
	self updatespeed();
}

/*
	Name: updatespeed
	Namespace: helicopter
	Checksum: 0xF1787FF2
	Offset: 0x96A8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function updatespeed()
{
	if(self is_targeted() || (isdefined(self.evasive) && self.evasive))
	{
		set_heli_speed_evasive();
	}
	else
	{
		set_heli_speed_normal();
	}
}

/*
	Name: updatetargetyaw
	Namespace: helicopter
	Checksum: 0x82009F8F
	Offset: 0x9718
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function updatetargetyaw()
{
	self notify(#"endtargetyawupdate");
	self endon(#"death");
	self endon(#"crashing");
	self endon(#"leaving");
	self endon(#"endtargetyawupdate");
	for(;;)
	{
		if(isdefined(self.primarytarget))
		{
			yaw = math::get_2d_yaw(self.origin, self.primarytarget.origin);
			self settargetyaw(yaw);
		}
		wait(1);
	}
}

/*
	Name: fire_missile
	Namespace: helicopter
	Checksum: 0x37C9F48C
	Offset: 0x97D0
	Size: 0x230
	Parameters: 3
	Flags: Linked
*/
function fire_missile(smissiletype, ishots = 1, etarget)
{
	/#
		assert(self.health > 0);
	#/
	weapon = undefined;
	weaponshoottime = undefined;
	tags = [];
	switch(smissiletype)
	{
		case "ffar":
		{
			weapon = getweapon("hind_FFAR");
			tags[0] = "tag_store_r_2";
			break;
		}
		default:
		{
			/#
				assertmsg("");
			#/
			break;
		}
	}
	/#
		assert(isdefined(weapon));
	#/
	/#
		assert(tags.size > 0);
	#/
	weaponshoottime = weapon.firetime;
	/#
		assert(isdefined(weaponshoottime));
	#/
	self setvehweapon(weapon);
	nextmissiletag = -1;
	for(i = 0; i < ishots; i++)
	{
		nextmissiletag++;
		if(nextmissiletag >= tags.size)
		{
			nextmissiletag = 0;
		}
		emissile = self fireweapon(0, etarget);
		emissile.killcament = self;
		self.lastrocketfiretime = gettime();
		if(i < (ishots - 1))
		{
			wait(weaponshoottime);
		}
	}
}

/*
	Name: check_owner
	Namespace: helicopter
	Checksum: 0x90A723C
	Offset: 0x9A08
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function check_owner(hardpointtype)
{
	if(!isdefined(self.owner) || !isdefined(self.owner.team) || self.owner.team != self.team)
	{
		self notify(#"abandoned");
		self thread heli_leave();
	}
}

/*
	Name: attack_targets
	Namespace: helicopter
	Checksum: 0xAA611BE5
	Offset: 0x9A88
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function attack_targets(missilesenabled, hardpointtype)
{
	self thread attack_primary(hardpointtype);
	if(missilesenabled)
	{
		self thread attack_secondary(hardpointtype);
	}
}

/*
	Name: attack_secondary
	Namespace: helicopter
	Checksum: 0x11F9BE9D
	Offset: 0x9AE0
	Size: 0x1A0
	Parameters: 1
	Flags: Linked
*/
function attack_secondary(hardpointtype)
{
	self endon(#"death");
	self endon(#"crashing");
	self endon(#"leaving");
	for(;;)
	{
		if(isdefined(self.secondarytarget))
		{
			self.secondarytarget.antithreat = undefined;
			self.missiletarget = self.secondarytarget;
			antithreat = 0;
			while(isdefined(self.missiletarget) && isalive(self.missiletarget))
			{
				if(self target_cone_check(self.missiletarget, level.heli_missile_target_cone))
				{
					self thread missile_support(self.missiletarget, level.heli_missile_rof, 1, undefined);
				}
				else
				{
					break;
				}
				antithreat = antithreat + 100;
				self.missiletarget.antithreat = antithreat;
				wait(level.heli_missile_rof);
				if(!isdefined(self.secondarytarget) || (isdefined(self.secondarytarget) && self.missiletarget != self.secondarytarget))
				{
					break;
				}
			}
			if(isdefined(self.missiletarget))
			{
				self.missiletarget.antithreat = undefined;
			}
		}
		self waittill(#"hash_519af70b");
		self check_owner(hardpointtype);
	}
}

/*
	Name: turret_target_check
	Namespace: helicopter
	Checksum: 0x16146E8D
	Offset: 0x9C88
	Size: 0x122
	Parameters: 2
	Flags: Linked
*/
function turret_target_check(turrettarget, attackangle)
{
	targetyaw = math::get_2d_yaw(self.origin, turrettarget.origin);
	chopperyaw = self.angles[1];
	if(targetyaw < 0)
	{
		targetyaw = targetyaw * -1;
	}
	targetyaw = int(targetyaw) % 360;
	if(chopperyaw < 0)
	{
		chopperyaw = chopperyaw * -1;
	}
	chopperyaw = int(chopperyaw) % 360;
	if(chopperyaw > targetyaw)
	{
		difference = chopperyaw - targetyaw;
	}
	else
	{
		difference = targetyaw - chopperyaw;
	}
	return difference <= attackangle;
}

/*
	Name: target_cone_check
	Namespace: helicopter
	Checksum: 0xF6C52CF2
	Offset: 0x9DB8
	Size: 0x104
	Parameters: 2
	Flags: Linked
*/
function target_cone_check(target, conecosine)
{
	heli2target_normal = vectornormalize(target.origin - self.origin);
	heli2forward = anglestoforward(self.angles);
	heli2forward_normal = vectornormalize(heli2forward);
	heli_dot_target = vectordot(heli2target_normal, heli2forward_normal);
	if(heli_dot_target >= conecosine)
	{
		airsupport::debug_print3d_simple("Cone sight: " + heli_dot_target, self, vectorscale((0, 0, -1), 40), 40);
		return true;
	}
	return false;
}

/*
	Name: missile_support
	Namespace: helicopter
	Checksum: 0x4A59C1E7
	Offset: 0x9EC8
	Size: 0x2C2
	Parameters: 4
	Flags: Linked
*/
function missile_support(target_player, rof, instantfire, endon_notify)
{
	self endon(#"death");
	self endon(#"crashing");
	self endon(#"leaving");
	if(isdefined(endon_notify))
	{
		self endon(endon_notify);
	}
	self.turret_giveup = 0;
	if(!instantfire)
	{
		wait(rof);
		self.turret_giveup = 1;
		self notify(#"hash_e4ae4515");
	}
	if(isdefined(target_player))
	{
		if(level.teambased)
		{
			for(i = 0; i < level.players.size; i++)
			{
				player = level.players[i];
				if(isdefined(player.team) && player.team == self.team && distance(player.origin, target_player.origin) <= level.heli_missile_friendlycare)
				{
					airsupport::debug_print3d_simple("Missile omitted due to nearby friendly", self, vectorscale((0, 0, -1), 80), 40);
					self notify(#"hash_2ff1ad5e");
					return;
				}
			}
		}
		else
		{
			player = self.owner;
			if(isdefined(player) && isdefined(player.team) && player.team == self.team && distance(player.origin, target_player.origin) <= level.heli_missile_friendlycare)
			{
				airsupport::debug_print3d_simple("Missile omitted due to nearby friendly", self, vectorscale((0, 0, -1), 80), 40);
				self notify(#"hash_2ff1ad5e");
				return;
			}
		}
	}
	if(self.missile_ammo > 0 && isdefined(target_player))
	{
		self fire_missile("ffar", 1, target_player);
		self.missile_ammo--;
		self notify(#"hash_b0c5ea03");
	}
	else
	{
		return;
	}
	if(instantfire)
	{
		wait(rof);
		self notify(#"hash_2ff1ad5e");
	}
}

/*
	Name: attack_primary
	Namespace: helicopter
	Checksum: 0x73E265B8
	Offset: 0xA198
	Size: 0x4E0
	Parameters: 1
	Flags: Linked
*/
function attack_primary(hardpointtype)
{
	self endon(#"death");
	self endon(#"crashing");
	self endon(#"leaving");
	level endon(#"game_ended");
	for(;;)
	{
		if(isdefined(self.primarytarget))
		{
			self.primarytarget.antithreat = undefined;
			self.turrettarget = self.primarytarget;
			antithreat = 0;
			last_pos = undefined;
			while(isdefined(self.turrettarget) && isalive(self.turrettarget))
			{
				if(hardpointtype == "helicopter_comlink" || hardpointtype == "inventory_helicopter_comlink")
				{
					self setlookatent(self.turrettarget);
				}
				helicopterturretmaxangle = heli_get_dvar_int("scr_helicopterTurretMaxAngle", level.helicopterturretmaxangle);
				while(isdefined(self.turrettarget) && isalive(self.turrettarget) && self turret_target_check(self.turrettarget, helicopterturretmaxangle) == 0)
				{
					wait(0.1);
				}
				if(!isdefined(self.turrettarget) || !isalive(self.turrettarget))
				{
					break;
				}
				self setturrettargetent(self.turrettarget, vectorscale((0, 0, 1), 50));
				self waittill(#"turret_on_target");
				hostmigration::waittillhostmigrationdone();
				self notify(#"turret_on_target");
				self thread turret_target_flag(self.turrettarget);
				wait(1);
				self heli_set_active_camo_state(0);
				wait(level.heli_turret_spinup_delay);
				weaponshoottime = self.defaultweapon.firetime;
				self setvehweapon(self.defaultweapon);
				for(i = 0; i < level.heli_turretclipsize; i++)
				{
					if(isdefined(self.turrettarget) && isdefined(self.primarytarget))
					{
						if(self.primarytarget != self.turrettarget)
						{
							self setturrettargetent(self.primarytarget, vectorscale((0, 0, 1), 40));
						}
					}
					else
					{
						if(isdefined(self.targetlost) && self.targetlost && isdefined(self.turret_last_pos))
						{
							self setturrettargetvec(self.turret_last_pos);
						}
						else
						{
							self clearturrettarget();
						}
					}
					if(gettime() != self.lastrocketfiretime)
					{
						self setvehweapon(self.defaultweapon);
						minigun = self fireweapon();
					}
					if(i < (level.heli_turretclipsize - 1))
					{
						wait(weaponshoottime);
					}
				}
				self notify(#"hash_849f87ba", self.pilotistalking);
				wait(level.heli_turretreloadtime);
				wait(3);
				self heli_set_active_camo_state(1);
				if(isdefined(self.turrettarget) && isalive(self.turrettarget))
				{
					antithreat = antithreat + 100;
					self.turrettarget.antithreat = antithreat;
				}
				if(!isdefined(self.primarytarget) || (isdefined(self.turrettarget) && isdefined(self.primarytarget) && self.primarytarget != self.turrettarget))
				{
					break;
				}
			}
			if(isdefined(self.turrettarget))
			{
				self.turrettarget.antithreat = undefined;
			}
		}
		self waittill(#"hash_907788c7");
		self check_owner(hardpointtype);
	}
}

/*
	Name: turret_target_flag
	Namespace: helicopter
	Checksum: 0x460A89AE
	Offset: 0xA680
	Size: 0x286
	Parameters: 1
	Flags: Linked
*/
function turret_target_flag(turrettarget)
{
	self notify(#"hash_4008e0d0");
	self endon(#"hash_4008e0d0");
	self endon(#"death");
	self endon(#"crashing");
	self endon(#"leaving");
	self endon(#"hash_849f87ba");
	if(isdefined(turrettarget))
	{
		turrettarget endon(#"death");
		turrettarget endon(#"disconnect");
	}
	self.targetlost = 0;
	self.turret_last_pos = undefined;
	while(isdefined(turrettarget))
	{
		heli_centroid = self.origin + (vectorscale((0, 0, -1), 160));
		heli_forward_norm = anglestoforward(self.angles);
		heli_turret_point = heli_centroid + (144 * heli_forward_norm);
		sight_rec = turrettarget sightconetrace(heli_turret_point, self);
		if(sight_rec < level.heli_target_recognition)
		{
			break;
		}
		wait(0.05);
	}
	if(isdefined(turrettarget) && isdefined(turrettarget.origin))
	{
		/#
			assert(isdefined(turrettarget.origin), "");
		#/
		self.turret_last_pos = turrettarget.origin + vectorscale((0, 0, 1), 40);
		/#
			assert(isdefined(self.turret_last_pos), "");
		#/
		self setturrettargetvec(self.turret_last_pos);
		/#
			assert(isdefined(self.turret_last_pos), "");
		#/
		airsupport::debug_print3d_simple("Turret target lost at: " + self.turret_last_pos, self, vectorscale((0, 0, -1), 70), 60);
		self.targetlost = 1;
	}
	else
	{
		self.targetlost = undefined;
		self.turret_last_pos = undefined;
	}
}

/*
	Name: debug_print_target
	Namespace: helicopter
	Checksum: 0x535AF45A
	Offset: 0xA910
	Size: 0x244
	Parameters: 0
	Flags: Linked
*/
function debug_print_target()
{
	if(isdefined(level.heli_debug) && level.heli_debug == 1)
	{
		if(isdefined(self.primarytarget) && isdefined(self.primarytarget.threatlevel))
		{
			if(isdefined(self.primarytarget.type) && self.primarytarget.type == "dog")
			{
				name = "dog";
			}
			else
			{
				name = self.primarytarget.name;
			}
			primary_msg = (("Primary: " + name) + " : ") + self.primarytarget.threatlevel;
		}
		else
		{
			primary_msg = "Primary: ";
		}
		if(isdefined(self.secondarytarget) && isdefined(self.secondarytarget.threatlevel))
		{
			if(isdefined(self.secondarytarget.type) && self.secondarytarget.type == "dog")
			{
				name = "dog";
			}
			else
			{
				name = self.secondarytarget.name;
			}
			secondary_msg = (("Secondary: " + name) + " : ") + self.secondarytarget.threatlevel;
		}
		else
		{
			secondary_msg = "Secondary: ";
		}
		frames = (int(self.targeting_delay * 20)) + 1;
		thread airsupport::draw_text(primary_msg, (1, 0.6, 0.6), self, vectorscale((0, 0, 1), 40), frames);
		thread airsupport::draw_text(secondary_msg, (1, 0.6, 0.6), self, (0, 0, 0), frames);
	}
}

/*
	Name: waittill_confirm_location
	Namespace: helicopter
	Checksum: 0x7A9BADD
	Offset: 0xAB60
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function waittill_confirm_location()
{
	self endon(#"emp_jammed");
	self endon(#"emp_grenaded");
	self waittill(#"confirm_location", location);
	return location;
}

/*
	Name: selecthelicopterlocation
	Namespace: helicopter
	Checksum: 0x4CBE6901
	Offset: 0xABA0
	Size: 0xCA
	Parameters: 1
	Flags: Linked
*/
function selecthelicopterlocation(hardpointtype)
{
	self beginlocationcomlinkselection("compass_objpoint_helicopter", 1500);
	self.selectinglocation = 1;
	self thread airsupport::endselectionthink();
	location = self waittill_confirm_location();
	if(!isdefined(location))
	{
		return 0;
	}
	if(self killstreakrules::iskillstreakallowed(hardpointtype, self.team) == 0)
	{
		return 0;
	}
	level.helilocation = location;
	return airsupport::finishhardpointlocationusage(location, undefined);
}

/*
	Name: processcopterassist
	Namespace: helicopter
	Checksum: 0x496F54C3
	Offset: 0xAC78
	Size: 0x12C
	Parameters: 2
	Flags: Linked
*/
function processcopterassist(destroyedcopter, damagedone)
{
	self endon(#"disconnect");
	destroyedcopter endon(#"disconnect");
	wait(0.05);
	if(!isdefined(level.teams[self.team]))
	{
		return;
	}
	if(self.team == destroyedcopter.team)
	{
		return;
	}
	assist_level = "aircraft_destruction_assist";
	assist_level_value = int(ceil((damagedone.damage / destroyedcopter.maxhealth) * 4));
	if(assist_level_value > 0)
	{
		if(assist_level_value > 3)
		{
			assist_level_value = 3;
		}
		assist_level = (assist_level + "_") + (assist_level_value * 25);
	}
	scoreevents::processscoreevent(assist_level, self);
}

/*
	Name: samturretwatcher
	Namespace: helicopter
	Checksum: 0xC66E2A72
	Offset: 0xADB0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function samturretwatcher()
{
	self endon(#"death");
	self endon(#"crashing");
	self endon(#"leaving");
	level endon(#"game_ended");
	self util::waittill_any("turret_on_target", "path start", "near_goal");
	target_setturretaquire(self, 1);
}

/*
	Name: playpilotdialog
	Namespace: helicopter
	Checksum: 0x84F6802A
	Offset: 0xAE30
	Size: 0xF4
	Parameters: 4
	Flags: None
*/
function playpilotdialog(dialog, time, voice, shouldwait)
{
	self endon(#"death");
	level endon(#"remote_end");
	if(isdefined(time))
	{
		wait(time);
	}
	if(!isdefined(self.pilotvoicenumber))
	{
		self.pilotvoicenumber = 0;
	}
	if(isdefined(voice))
	{
		voicenumber = voice;
	}
	else
	{
		voicenumber = self.pilotvoicenumber;
	}
	soundalias = ((level.teamprefix[self.team] + voicenumber) + "_") + dialog;
	if(isdefined(self.owner))
	{
		self.owner playpilottalking(shouldwait, soundalias);
	}
}

/*
	Name: playpilottalking
	Namespace: helicopter
	Checksum: 0xF2172DA
	Offset: 0xAF30
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function playpilottalking(shouldwait, soundalias)
{
	self endon(#"disconnect");
	self endon(#"joined_team");
	self endon(#"joined_spectators");
	for(trycounter = 0; isdefined(self.pilottalking) && self.pilottalking && trycounter < 10; trycounter++)
	{
		if(isdefined(shouldwait) && !shouldwait)
		{
			return;
		}
		wait(1);
	}
	self.pilottalking = 1;
	self playlocalsound(soundalias);
	wait(3);
	self.pilottalking = 0;
}

/*
	Name: watchforearlyleave
	Namespace: helicopter
	Checksum: 0xA91713CF
	Offset: 0xB008
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function watchforearlyleave(chopper)
{
	chopper notify(#"watchforearlyleave_helicopter");
	chopper endon(#"watchforearlyleave_helicopter");
	chopper endon(#"death");
	self endon(#"heli_timeup");
	self util::waittill_any("joined_team", "disconnect");
	if(isdefined(chopper))
	{
		chopper thread heli_leave();
	}
	if(isdefined(self))
	{
		self notify(#"heli_timeup");
	}
}

/*
	Name: watchforemp
	Namespace: helicopter
	Checksum: 0x971EE825
	Offset: 0xB0B0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function watchforemp()
{
	heli = self;
	heli endon(#"death");
	heli endon(#"heli_timeup");
	heli.owner waittill(#"emp_jammed");
	heli thread heli_explode();
}

