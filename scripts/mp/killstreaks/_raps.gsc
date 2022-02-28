// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_helicopter;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\teams\_teams;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_raps;
#using scripts\shared\weapons\_smokegrenade;

#namespace raps_mp;

/*
	Name: init
	Namespace: raps_mp
	Checksum: 0x479C4C6A
	Offset: 0x890
	Size: 0x2AA
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.raps_settings = level.scriptbundles["vehiclecustomsettings"]["rapssettings_mp"];
	/#
		assert(isdefined(level.raps_settings));
	#/
	level.raps = [];
	level.raps_helicopters = [];
	level.raps_force_get_enemies = &forcegetenemies;
	killstreaks::register("raps", "raps", "killstreak_raps", "raps_used", &activaterapskillstreak, 1);
	killstreaks::register_strings("raps", &"KILLSTREAK_EARNED_RAPS", &"KILLSTREAK_RAPS_NOT_AVAILABLE", &"KILLSTREAK_RAPS_INBOUND", undefined, &"KILLSTREAK_RAPS_HACKED");
	killstreaks::register_dialog("raps", "mpl_killstreak_raps", "rapsHelicopterDialogBundle", "rapsHelicopterPilotDialogBundle", "friendlyRaps", "enemyRaps", "enemyRapsMultiple", "friendlyRapsHacked", "enemyRapsHacked", "requestRaps", "threatRaps");
	killstreaks::allow_assists("raps", 1);
	killstreaks::register_dev_debug_dvar("raps");
	killstreak_bundles::register_killstreak_bundle("raps_drone");
	inithelicopterpositions();
	callback::on_connect(&onplayerconnect);
	clientfield::register("vehicle", "monitor_raps_drop_landing", 1, 1, "int");
	clientfield::register("vehicle", "raps_heli_low_health", 1, 1, "int");
	clientfield::register("vehicle", "raps_heli_extra_low_health", 1, 1, "int");
	level.raps_helicopter_drop_tag_names = [];
	level.raps_helicopter_drop_tag_names[0] = "tag_raps_drop_left";
	level.raps_helicopter_drop_tag_names[1] = "tag_raps_drop_right";
}

/*
	Name: onplayerconnect
	Namespace: raps_mp
	Checksum: 0xE0B34048
	Offset: 0xB48
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect()
{
	self.entnum = self getentitynumber();
	level.raps[self.entnum] = spawnstruct();
	level.raps[self.entnum].killstreak_id = -1;
	level.raps[self.entnum].raps = [];
	level.raps[self.entnum].helicopter = undefined;
}

/*
	Name: rapshelicopterdynamicavoidance
	Namespace: raps_mp
	Checksum: 0xBC213822
	Offset: 0xBF8
	Size: 0x6C
	Parameters: 0
	Flags: None
*/
function rapshelicopterdynamicavoidance()
{
	level endon(#"game_ended");
	index_to_update = 0;
	while(true)
	{
		rapshelicopterdynamicavoidanceupdate(index_to_update);
		index_to_update++;
		if(index_to_update >= level.raps_helicopters.size)
		{
			index_to_update = 0;
		}
		wait(0.05);
	}
}

/*
	Name: rapshelicopterdynamicavoidanceupdate
	Namespace: raps_mp
	Checksum: 0x656151F7
	Offset: 0xC70
	Size: 0xA8C
	Parameters: 1
	Flags: Linked
*/
function rapshelicopterdynamicavoidanceupdate(index_to_update)
{
	helicopterreforigin = (0, 0, 0);
	otherhelicopterreforigin = (0, 0, 0);
	arrayremovevalue(level.raps_helicopters, undefined);
	if(index_to_update >= level.raps_helicopters.size)
	{
		index_to_update = 0;
	}
	if(level.raps_helicopters.size >= 2)
	{
		helicopter = level.raps_helicopters[index_to_update];
		/#
			helicopter.__action_just_made = 0;
		#/
		for(i = 0; i < level.raps_helicopters.size; i++)
		{
			if(i == index_to_update)
			{
				continue;
			}
			if(helicopter.droppingraps)
			{
				continue;
			}
			if(!isdefined(helicopter.lastnewgoaltime))
			{
				helicopter.lastnewgoaltime = gettime();
			}
			helicopterforward = anglestoforward(helicopter getangles());
			helicopterreforigin = helicopter.origin + (helicopterforward * 500);
			otherhelicopterforward = anglestoforward(level.raps_helicopters[i] getangles());
			otherhelicopterreforigin = level.raps_helicopters[i].origin + (otherhelicopterforward * 100);
			deltatoother = otherhelicopterreforigin - helicopterreforigin;
			otherinfront = vectordot(helicopterforward, vectornormalize(deltatoother)) > 0.707;
			distancesqr = distance2dsquared(helicopterreforigin, otherhelicopterreforigin);
			if(distancesqr < (200 + 1200) * (200 + 1200) || helicopter getspeed() == 0 && (gettime() - helicopter.lastnewgoaltime) > 5000)
			{
				/#
					helicopter.__last_dynamic_avoidance_action = 20;
				#/
				/#
					helicopter.__action_just_made = 1;
				#/
				helicopter updatehelicopterspeed();
				if(helicopter.isleaving)
				{
					self.leavelocation = getrandomhelicopterleaveorigin(0, self.origin);
					helicopter setvehgoalpos(self.leavelocation, 0);
				}
				else
				{
					self.targetdroplocation = getrandomhelicopterposition(self.lastdroplocation);
					helicopter setvehgoalpos(self.targetdroplocation, 1);
				}
				helicopter.lastnewgoaltime = gettime();
				continue;
			}
			if(distancesqr < (1200 * 1200) && otherinfront && (gettime() - helicopter.laststoptime) > 500)
			{
				/#
					helicopter.__last_dynamic_avoidance_action = 10;
				#/
				/#
					helicopter.__action_just_made = 1;
				#/
				helicopter stophelicopter();
				continue;
			}
			if(helicopter getspeed() == 0 && otherinfront && distancesqr < (1200 * 1200))
			{
				/#
					helicopter.__last_dynamic_avoidance_action = 50;
				#/
				/#
					helicopter.__action_just_made = 1;
				#/
				delta = otherhelicopterreforigin - helicopterreforigin;
				newgoalposition = helicopter.origin - (deltatoother[0] * randomfloatrange(0.7, 2.5), deltatoother[1] * randomfloatrange(0.7, 2.5), 0);
				helicopter updatehelicopterspeed();
				helicopter setvehgoalpos(newgoalposition, 0);
				if(1 || (gettime() - helicopter.lastnewgoaltime) > 5000)
				{
					/#
						helicopter.__last_dynamic_avoidance_action = 51;
					#/
					helicopter.targetdroplocation = getclosestrandomhelicopterposition(newgoalposition, 8);
					helicopter.lastnewgoaltime = gettime();
				}
				continue;
			}
			if(distancesqr < (1000 + (200 + 1200)) * (1000 + (200 + 1200)) && helicopter.drivemodespeedscale == 1)
			{
				/#
					helicopter.__last_dynamic_avoidance_action = (otherinfront ? 31 : 30);
				#/
				/#
					helicopter.__action_just_made = 1;
				#/
				helicopter updatehelicopterspeed((otherinfront ? 2 : 1));
				continue;
			}
			if(distancesqr >= (1000 + (200 + 1200)) * (1000 + (200 + 1200)) && helicopter.drivemodespeedscale < 1)
			{
				/#
					helicopter.__last_dynamic_avoidance_action = 40;
				#/
				/#
					helicopter.__action_just_made = 1;
				#/
				helicopter updatehelicopterspeed(0);
				continue;
			}
			if(helicopter getspeed() == 0 && (gettime() - helicopter.laststoptime) > 500)
			{
				helicopter updatehelicopterspeed();
			}
		}
		/#
			if(getdvarint(""))
			{
				if(isdefined(helicopter))
				{
					server_frames_to_persist = int((0.05 * 2) / 0.05);
					sphere(helicopterreforigin, 10, (0, 0, 1), 1, 0, 10, server_frames_to_persist);
					sphere(otherhelicopterreforigin, 10, (1, 0, 0), 1, 0, 10, server_frames_to_persist);
					circle(helicopterreforigin, 1000 + (200 + 1200), (1, 1, 0), 1, 1, server_frames_to_persist);
					circle(helicopterreforigin, 200 + 1200, (0, 0, 0), 1, 1, server_frames_to_persist);
					circle(helicopterreforigin, 1200, (1, 0, 0), 1, 1, server_frames_to_persist);
					print3d(helicopter.origin, "" + int(helicopter getspeedmph()), (1, 1, 1), 1, 2.5, server_frames_to_persist);
					action_debug_color = vectorscale((1, 1, 1), 0.8);
					debug_action_string = "";
					if(helicopter.__action_just_made)
					{
						action_debug_color = (0, 1, 0);
					}
					switch(helicopter.__last_dynamic_avoidance_action)
					{
						case 0:
						{
							break;
						}
						case 10:
						{
							debug_action_string = "";
							break;
						}
						case 20:
						{
							debug_action_string = "";
							break;
						}
						case 30:
						{
							debug_action_string = "";
							break;
						}
						case 31:
						{
							debug_action_string = "";
							break;
						}
						case 40:
						{
							debug_action_string = "";
							break;
						}
						case 50:
						{
							debug_action_string = "";
							break;
						}
						case 51:
						{
							debug_action_string = "";
							break;
						}
						default:
						{
							debug_action_string = "";
							break;
						}
					}
					print3d(helicopter.origin + (vectorscale((0, 0, -1), 50)), debug_action_string, action_debug_color, 1, 2.5, server_frames_to_persist);
				}
			}
		#/
	}
}

/*
	Name: activaterapskillstreak
	Namespace: raps_mp
	Checksum: 0x9D2428B5
	Offset: 0x1708
	Size: 0x388
	Parameters: 1
	Flags: Linked
*/
function activaterapskillstreak(hardpointtype)
{
	player = self;
	if(!player killstreakrules::iskillstreakallowed("raps", player.team))
	{
		return false;
	}
	if(game["raps_helicopter_positions"].size <= 0)
	{
		/#
			iprintlnbold("");
		#/
		self iprintlnbold(&"KILLSTREAK_RAPS_NOT_AVAILABLE");
		return false;
	}
	killstreakid = player killstreakrules::killstreakstart("raps", player.team);
	if(killstreakid == -1)
	{
		player iprintlnbold(&"KILLSTREAK_RAPS_NOT_AVAILABLE");
		return false;
	}
	player thread teams::waituntilteamchange(player, &onteamchanged, player.entnum, "raps_complete");
	level thread watchrapskillstreakend(killstreakid, player.entnum, player.team);
	helicopter = player spawnrapshelicopter(killstreakid);
	helicopter.killstreakid = killstreakid;
	player killstreaks::play_killstreak_start_dialog("raps", player.team, killstreakid);
	player addweaponstat(getweapon("raps"), "used", 1);
	helicopter killstreaks::play_pilot_dialog_on_owner("arrive", "raps", killstreakid);
	level.raps[player.entnum].helicopter = helicopter;
	if(!isdefined(level.raps_helicopters))
	{
		level.raps_helicopters = [];
	}
	else if(!isarray(level.raps_helicopters))
	{
		level.raps_helicopters = array(level.raps_helicopters);
	}
	level.raps_helicopters[level.raps_helicopters.size] = level.raps[player.entnum].helicopter;
	level thread updatekillstreakonhelicopterdeath(level.raps[player.entnum].helicopter, player.entnum);
	/#
		if(getdvarint(""))
		{
			level thread autoreactivaterapskillstreak(player.entnum, player, hardpointtype);
		}
	#/
	return true;
}

/*
	Name: autoreactivaterapskillstreak
	Namespace: raps_mp
	Checksum: 0x6166109
	Offset: 0x1A98
	Size: 0x9A
	Parameters: 3
	Flags: Linked
*/
function autoreactivaterapskillstreak(ownerentnum, player, hardpointtype)
{
	/#
		if(1)
		{
			for(;;)
			{
				level waittill("" + ownerentnum);
			}
			if(isdefined(level.raps[ownerentnum].helicopter))
			{
			}
			wait(randomfloatrange(2, 5));
			player thread activaterapskillstreak(hardpointtype);
			return;
		}
	#/
}

/*
	Name: watchrapskillstreakend
	Namespace: raps_mp
	Checksum: 0x210A7C97
	Offset: 0x1B40
	Size: 0x82
	Parameters: 3
	Flags: Linked
*/
function watchrapskillstreakend(killstreakid, ownerentnum, team)
{
	if(1)
	{
		for(;;)
		{
			level waittill("raps_updated_" + ownerentnum);
		}
		if(isdefined(level.raps[ownerentnum].helicopter))
		{
		}
		killstreakrules::killstreakstop("raps", team, killstreakid);
		return;
	}
}

/*
	Name: updatekillstreakonhelicopterdeath
	Namespace: raps_mp
	Checksum: 0xAAF12B68
	Offset: 0x1BD0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function updatekillstreakonhelicopterdeath(helicopter, ownerentenum)
{
	helicopter waittill(#"death");
	level notify("raps_updated_" + ownerentenum);
}

/*
	Name: onteamchanged
	Namespace: raps_mp
	Checksum: 0x949D64EF
	Offset: 0x1C10
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function onteamchanged(entnum, event)
{
	abandoned = 1;
	destroyallraps(entnum, abandoned);
}

/*
	Name: onemp
	Namespace: raps_mp
	Checksum: 0x5F3613F2
	Offset: 0x1C60
	Size: 0x2C
	Parameters: 2
	Flags: None
*/
function onemp(attacker, ownerentnum)
{
	destroyallraps(ownerentnum);
}

/*
	Name: novehiclefacethread
	Namespace: raps_mp
	Checksum: 0xD966CB85
	Offset: 0x1C98
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function novehiclefacethread(mapcenter, radius)
{
	level endon(#"game_ended");
	wait(3);
	marknovehiclenavmeshfaces(mapcenter, radius, 21);
}

/*
	Name: inithelicopterpositions
	Namespace: raps_mp
	Checksum: 0xFF5FD701
	Offset: 0x1CE8
	Size: 0x1042
	Parameters: 0
	Flags: Linked
*/
function inithelicopterpositions()
{
	startsearchpoint = airsupport::getmapcenter();
	mapcenter = getclosestpointonnavmesh(startsearchpoint, 1024);
	if(!isdefined(mapcenter))
	{
		startsearchpoint = (startsearchpoint[0], startsearchpoint[1], 0);
	}
	remaining_attempts = 10;
	while(!isdefined(mapcenter) && remaining_attempts > 0)
	{
		startsearchpoint = startsearchpoint + vectorscale((1, 1, 0), 100);
		mapcenter = getclosestpointonnavmesh(startsearchpoint, 1024);
		remaining_attempts = remaining_attempts - 1;
	}
	if(!isdefined(mapcenter))
	{
		mapcenter = airsupport::getmapcenter();
	}
	radius = airsupport::getmaxmapwidth();
	if(radius < 1)
	{
		radius = 1;
	}
	if(isdefined(game["raps_helicopter_positions"]))
	{
		return;
	}
	lots_of_height = 1024;
	randomnavmeshpoints = util::positionquery_pointarray(mapcenter, 0, radius * 3, lots_of_height, 132);
	if(randomnavmeshpoints.size == 0)
	{
		mapcenter = vectorscale((0, 0, 1), 39);
		randomnavmeshpoints = util::positionquery_pointarray(mapcenter, 0, radius, 70, 132);
	}
	/#
		position_query_drop_location_count = randomnavmeshpoints.size;
	#/
	if(isdefined(level.add_raps_drop_locations))
	{
		[[level.add_raps_drop_locations]](randomnavmeshpoints);
	}
	/#
		if(getdvarint(""))
		{
			boxhalfwidth = 220 * 0.25;
			for(i = position_query_drop_location_count; i < randomnavmeshpoints.size; i++)
			{
				box(randomnavmeshpoints[i], (boxhalfwidth * -1, boxhalfwidth * -1, 0), (boxhalfwidth, boxhalfwidth, 8.88), 0, (1, 0.53, 0), 0.9, 0, 9999999);
			}
		}
	#/
	omit_locations = [];
	if(isdefined(level.add_raps_omit_locations))
	{
		[[level.add_raps_omit_locations]](omit_locations);
	}
	/#
		if(getdvarint(""))
		{
			debug_radius = 220 * 0.5;
			foreach(omit_location in omit_locations)
			{
				circle(omit_location, debug_radius, vectorscale((1, 1, 1), 0.05), 0, 1, 9999999);
				circle(omit_location + vectorscale((0, 0, 1), 4), debug_radius, vectorscale((1, 1, 1), 0.05), 0, 1, 9999999);
				circle(omit_location + vectorscale((0, 0, 1), 8), debug_radius, vectorscale((1, 1, 1), 0.05), 0, 1, 9999999);
			}
		}
	#/
	game["raps_helicopter_positions"] = [];
	minflyheight = int(airsupport::getminimumflyheight() + 1000);
	test_point_radius = 12;
	fit_radius = 220 * 0.5;
	fit_radius_corner = fit_radius * 0.7071;
	omit_radius = 220 * 0.5;
	foreach(point in randomnavmeshpoints)
	{
		start_water_trace = point + vectorscale((0, 0, 1), 6);
		stop_water_trace = point + vectorscale((0, 0, 1), 8);
		trace = physicstrace(start_water_trace, stop_water_trace, vectorscale((-1, -1, -1), 2), vectorscale((1, 1, 1), 2), undefined, 4);
		if(trace["fraction"] < 1)
		{
			/#
				if(getdvarint(""))
				{
					debugboxwidth = 220 * 0.5;
					debugboxheight = 10;
					box(start_water_trace, (debugboxwidth * -1, debugboxwidth * -1, 0), (debugboxwidth, debugboxwidth, debugboxheight), 0, (0, 0, 1), 0.9, 0, 9999999);
					box(start_water_trace, vectorscale((-1, -1, -1), 2), vectorscale((1, 1, 1), 2), 0, (0, 0, 1), 0.9, 0, 9999999);
				}
			#/
			continue;
		}
		should_omit = 0;
		foreach(omit_location in omit_locations)
		{
			if(distancesquared(omit_location, point) < (omit_radius * omit_radius))
			{
				should_omit = 1;
				/#
					if(getdvarint(""))
					{
						debugboxwidth = 220 * 0.5;
						debugboxheight = 10;
						box(point, (debugboxwidth * -1, debugboxwidth * -1, 0), (debugboxwidth, debugboxwidth, debugboxheight), 0, vectorscale((1, 1, 1), 0.05), 1, 0, 9999999);
					}
				#/
				break;
			}
		}
		if(should_omit)
		{
			continue;
		}
		randomtestpoints = util::positionquery_pointarray(point, 0, 128, lots_of_height, test_point_radius);
		max_attempts = 12;
		point_added = 0;
		for(i = 0; !point_added && i < max_attempts && i < randomtestpoints.size; i++)
		{
			test_point = randomtestpoints[i];
			can_fit_on_nav_mesh = ispointonnavmesh(test_point + (0, fit_radius, 0), 0) && ispointonnavmesh(test_point + (0, fit_radius * -1, 0), 0) && ispointonnavmesh(test_point + (fit_radius, 0, 0), 0) && ispointonnavmesh(test_point + (fit_radius * -1, 0, 0), 0) && ispointonnavmesh(test_point + (fit_radius_corner, fit_radius_corner, 0), 0) && ispointonnavmesh(test_point + (fit_radius_corner, fit_radius_corner * -1, 0), 0) && ispointonnavmesh(test_point + (fit_radius_corner * -1, fit_radius_corner, 0), 0) && ispointonnavmesh(test_point + (fit_radius_corner * -1, fit_radius_corner * -1, 0), 0);
			if(can_fit_on_nav_mesh)
			{
				point_added = tryaddpointforhelicopterposition(test_point, minflyheight);
			}
		}
	}
	if(game["raps_helicopter_positions"].size == 0)
	{
		/#
			iprintlnbold("");
		#/
		game["raps_helicopter_positions"] = randomnavmeshpoints;
	}
	flood_fill_start_point = undefined;
	flood_fill_start_point_distance_squared = 9999999;
	foreach(point in game["raps_helicopter_positions"])
	{
		if(!isdefined(point))
		{
			continue;
		}
		distance_squared = distancesquared(point, mapcenter);
		if(distance_squared < flood_fill_start_point_distance_squared)
		{
			flood_fill_start_point_distance_squared = distance_squared;
			flood_fill_start_point = point;
		}
	}
	if(!isdefined(flood_fill_start_point))
	{
		flood_fill_start_point = mapcenter;
	}
	level thread novehiclefacethread(flood_fill_start_point, radius * 2);
	force_debug_draw = 0;
	/#
		if(killstreaks::should_draw_debug("") || force_debug_draw)
		{
			time = 9999999;
			sphere(mapcenter, 20, (1, 1, 0), 1, 0, 10, time);
			circle(mapcenter, airsupport::getmaxmapwidth(), (0, 1, 0), 1, 1, time);
			box(mapcenter, vectorscale((-1, -1, 0), 4), (4, 4, 5000), 0, (1, 1, 0), 0.6, 0, time);
			sphere(flood_fill_start_point, 20, (0, 1, 1), 1, 0, 10, time);
			box(flood_fill_start_point, vectorscale((-1, -1, 0), 4), (4, 4, 4200), 0, (0, 1, 1), 0.6, 0, time);
			foreach(point in randomnavmeshpoints)
			{
				sphere(point + vectorscale((0, 0, 1), 950), 10, (0, 0, 1), 1, 0, 10, time);
				circle(point, 128, (1, 0, 0), 1, 1, time);
			}
			foreach(point in game[""])
			{
				sphere(point + vectorscale((0, 0, 1), 1000), 10, (0, 1, 0), 1, 0, 10, time);
				circle(point + vectorscale((0, 0, 1), 2), 128, (0, 1, 0), 1, 1, time);
				airsupport::debug_cylinder(point, 8, 1000, vectorscale((0, 1, 0), 0.8), 16, time);
				box(point, vectorscale((-1, -1, 0), 4), (4, 4, 1000), 0, vectorscale((0, 1, 0), 0.7), 0.6, 0, time);
				halfboxwidth = 220 * 0.5;
				box(point, (halfboxwidth * -1, halfboxwidth * -1, 2), (halfboxwidth, halfboxwidth, 300), 0, vectorscale((0, 0, 1), 0.6), 0.6, 0, time);
			}
		}
	#/
}

/*
	Name: tryaddpointforhelicopterposition
	Namespace: raps_mp
	Checksum: 0xB7ED0D3C
	Offset: 0x2D38
	Size: 0xFE
	Parameters: 2
	Flags: Linked
*/
function tryaddpointforhelicopterposition(spaciouspoint, minflyheight)
{
	traceheight = minflyheight + 500;
	traceboxhalfwidth = 220 * 0.5;
	if(istracesafeforrapsdronedropfromhelicopter(spaciouspoint, traceheight, traceboxhalfwidth))
	{
		if(!isdefined(game["raps_helicopter_positions"]))
		{
			game["raps_helicopter_positions"] = [];
		}
		else if(!isarray(game["raps_helicopter_positions"]))
		{
			game["raps_helicopter_positions"] = array(game["raps_helicopter_positions"]);
		}
		game["raps_helicopter_positions"][game["raps_helicopter_positions"].size] = spaciouspoint;
		return true;
	}
	return false;
}

/*
	Name: istracesafeforrapsdronedropfromhelicopter
	Namespace: raps_mp
	Checksum: 0x27F4C236
	Offset: 0x2E40
	Size: 0x208
	Parameters: 3
	Flags: Linked
*/
function istracesafeforrapsdronedropfromhelicopter(spaciouspoint, traceheight, traceboxhalfwidth)
{
	start = (spaciouspoint[0], spaciouspoint[1], traceheight);
	end = (spaciouspoint[0], spaciouspoint[1], spaciouspoint[2] + 36);
	trace = physicstrace(start, end, (traceboxhalfwidth * -1, traceboxhalfwidth * -1, 0), (traceboxhalfwidth, traceboxhalfwidth, traceboxhalfwidth * 2), undefined, 1);
	/#
		if(getdvarint(""))
		{
			if(trace[""] < 1)
			{
				box(end, (traceboxhalfwidth * -1, traceboxhalfwidth * -1, 0), (traceboxhalfwidth, traceboxhalfwidth, (start[2] - end[2]) * (1 - trace[""])), 0, (1, 0, 0), 0.6, 0, 9999999);
			}
			else
			{
				box(end, (traceboxhalfwidth * -1, traceboxhalfwidth * -1, 0), (traceboxhalfwidth, traceboxhalfwidth, 8.88), 0, (0, 1, 0), 0.6, 0, 9999999);
			}
		}
	#/
	return trace["fraction"] == 1 && trace["surfacetype"] == "none";
}

/*
	Name: getrandomhelicopterstartorigin
	Namespace: raps_mp
	Checksum: 0xF4E38A78
	Offset: 0x3050
	Size: 0x52
	Parameters: 2
	Flags: Linked
*/
function getrandomhelicopterstartorigin(fly_height, firstdroplocation)
{
	best_node = helicopter::getvalidrandomstartnode(firstdroplocation);
	return best_node.origin + (0, 0, fly_height);
}

/*
	Name: getrandomhelicopterleaveorigin
	Namespace: raps_mp
	Checksum: 0xB7CFE505
	Offset: 0x30B0
	Size: 0x52
	Parameters: 2
	Flags: Linked
*/
function getrandomhelicopterleaveorigin(fly_height, startlocationtoleavefrom)
{
	best_node = helicopter::getvalidrandomleavenode(startlocationtoleavefrom);
	return best_node.origin + (0, 0, fly_height);
}

/*
	Name: getinitialhelicopterflyheight
	Namespace: raps_mp
	Checksum: 0x1B8C3DF
	Offset: 0x3110
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function getinitialhelicopterflyheight()
{
	arrayremovevalue(level.raps_helicopters, undefined);
	minimum_fly_height = airsupport::getminimumflyheight();
	if(level.raps_helicopters.size > 0)
	{
		already_assigned_height = level.raps_helicopters[0].assigned_fly_height;
		if(already_assigned_height == (minimum_fly_height + (int(airsupport::getminimumflyheight() + 1000))))
		{
			return (minimum_fly_height + (int(airsupport::getminimumflyheight() + 1000))) + 400;
		}
	}
	return minimum_fly_height + (int(airsupport::getminimumflyheight() + 1000));
}

/*
	Name: configurechopperteampost
	Namespace: raps_mp
	Checksum: 0x34C0E48A
	Offset: 0x3230
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function configurechopperteampost(owner, ishacked)
{
	helicopter = self;
	helicopter thread watchownerdisconnect(owner);
	helicopter thread createrapshelicopterinfluencer();
}

/*
	Name: spawnrapshelicopter
	Namespace: raps_mp
	Checksum: 0x378BDEF3
	Offset: 0x3290
	Size: 0x4E8
	Parameters: 1
	Flags: Linked
*/
function spawnrapshelicopter(killstreakid)
{
	player = self;
	assigned_fly_height = getinitialhelicopterflyheight();
	prepickeddroplocation = picknextdroplocation(undefined, 0, player.origin, assigned_fly_height);
	spawnorigin = getrandomhelicopterstartorigin(0, prepickeddroplocation);
	helicopter = spawnhelicopter(player, spawnorigin, (0, 0, 0), "heli_raps_mp", "veh_t7_mil_vtol_dropship_raps");
	helicopter.prepickeddroplocation = prepickeddroplocation;
	helicopter.assigned_fly_height = assigned_fly_height;
	helicopter killstreaks::configure_team("raps", killstreakid, player, undefined, undefined, &configurechopperteampost);
	helicopter killstreak_hacking::enable_hacking("raps");
	helicopter.droppingraps = 0;
	helicopter.isleaving = 0;
	helicopter.droppedraps = 0;
	helicopter.drivemodespeedscale = 3;
	helicopter.drivemodeaccel = 20 * 5;
	helicopter.drivemodedecel = 20 * 5;
	helicopter.laststoptime = 0;
	helicopter.targetdroplocation = vectorscale((-1, -1, -1), 9999999);
	helicopter.lastdroplocation = vectorscale((-1, -1, -1), 9999999);
	helicopter.firstdropreferencepoint = (player.origin[0], player.origin[1], int(airsupport::getminimumflyheight() + 1000));
	/#
		helicopter.__last_dynamic_avoidance_action = 0;
	#/
	helicopter clientfield::set("enemyvehicle", 1);
	helicopter.health = 99999999;
	helicopter.maxhealth = killstreak_bundles::get_max_health("raps");
	helicopter.lowhealth = killstreak_bundles::get_low_health("raps");
	helicopter.extra_low_health = helicopter.lowhealth * 0.5;
	helicopter.extra_low_health_callback = &onextralowhealth;
	helicopter setcandamage(1);
	helicopter thread killstreaks::monitordamage("raps", helicopter.maxhealth, &ondeath, helicopter.lowhealth, &onlowhealth, 0, undefined, 1);
	helicopter.rocketdamage = (helicopter.maxhealth / 4) + 1;
	helicopter.remotemissiledamage = (helicopter.maxhealth / 1) + 1;
	helicopter.hackertooldamage = (helicopter.maxhealth / 2) + 1;
	helicopter.detonateviaemp = &raps::detonate_damage_monitored;
	target_set(helicopter, vectorscale((0, 0, 1), 100));
	helicopter setdrawinfrared(1);
	helicopter thread waitforhelicoptershutdown();
	helicopter thread helicopterthink();
	helicopter thread watchgameended();
	/#
		helicopter thread helicopterthinkdebugvisitall();
	#/
	return helicopter;
}

/*
	Name: waitforhelicoptershutdown
	Namespace: raps_mp
	Checksum: 0x37654FFD
	Offset: 0x3780
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function waitforhelicoptershutdown()
{
	helicopter = self;
	helicopter waittill(#"raps_helicopter_shutdown", killed);
	level notify("raps_updated_" + helicopter.ownerentnum);
	if(target_istarget(helicopter))
	{
		target_remove(helicopter);
	}
	if(killed)
	{
		wait(randomfloatrange(0.1, 0.2));
		helicopter firstheliexplo();
		helicopter helideathtrails();
		helicopter thread spin();
		goalx = randomfloatrange(650, 700);
		goaly = randomfloatrange(650, 700);
		if(randomintrange(0, 2) > 0)
		{
			goalx = goalx * -1;
		}
		if(randomintrange(0, 2) > 0)
		{
			goaly = goaly * -1;
		}
		helicopter setvehgoalpos(helicopter.origin + (goalx, goaly, randomfloatrange(285, 300) * -1), 0);
		wait(randomfloatrange(3, 4));
		helicopter finalhelideathexplode();
		wait(0.1);
		helicopter ghost();
		self notify(#"stop_death_spin");
		wait(0.5);
	}
	else
	{
		helicopter helicopterleave();
	}
	helicopter delete();
}

/*
	Name: watchownerdisconnect
	Namespace: raps_mp
	Checksum: 0xDE6FF177
	Offset: 0x3A10
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function watchownerdisconnect(owner)
{
	self notify(#"watchownerdisconnect_singleton");
	self endon(#"watchownerdisconnect_singleton");
	helicopter = self;
	helicopter endon(#"raps_helicopter_shutdown");
	owner util::waittill_any("joined_team", "disconnect", "joined_spectators");
	helicopter notify(#"raps_helicopter_shutdown", 0);
}

/*
	Name: watchgameended
	Namespace: raps_mp
	Checksum: 0x93A1615D
	Offset: 0x3AA0
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function watchgameended()
{
	helicopter = self;
	helicopter endon(#"raps_helicopter_shutdown");
	helicopter endon(#"death");
	level waittill(#"game_ended");
	helicopter notify(#"raps_helicopter_shutdown", 0);
}

/*
	Name: ondeath
	Namespace: raps_mp
	Checksum: 0xDFBA2745
	Offset: 0x3AF0
	Size: 0x1C4
	Parameters: 2
	Flags: Linked
*/
function ondeath(attacker, weapon)
{
	helicopter = self;
	if(isdefined(attacker) && (!isdefined(helicopter.owner) || helicopter.owner util::isenemyplayer(attacker)))
	{
		challenges::destroyedaircraft(attacker, weapon, 0);
		attacker challenges::addflyswatterstat(weapon, self);
		scoreevents::processscoreevent("destroyed_raps_deployship", attacker, helicopter.owner, weapon);
		if(isdefined(helicopter.droppedraps) && helicopter.droppedraps == 0)
		{
			attacker addplayerstat("destroy_raps_before_drop", 1);
		}
		luinotifyevent(&"player_callout", 2, &"KILLSTREAK_DESTROYED_RAPS_DEPLOY_SHIP", attacker.entnum);
		helicopter notify(#"raps_helicopter_shutdown", 1);
	}
	if(helicopter.isleaving !== 1)
	{
		helicopter killstreaks::play_pilot_dialog_on_owner("destroyed", "raps");
		helicopter killstreaks::play_destroyed_dialog_on_owner("raps", self.killstreakid);
	}
}

/*
	Name: onlowhealth
	Namespace: raps_mp
	Checksum: 0x64729DCB
	Offset: 0x3CC0
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function onlowhealth(attacker, weapon)
{
	helicopter = self;
	helicopter killstreaks::play_pilot_dialog_on_owner("damaged", "raps", helicopter.killstreakid);
	helicopter helilowhealthfx();
}

/*
	Name: onextralowhealth
	Namespace: raps_mp
	Checksum: 0x629C7941
	Offset: 0x3D38
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function onextralowhealth(attacker, weapon)
{
	helicopter = self;
	helicopter heliextralowhealthfx();
}

/*
	Name: getrandomhelicopterposition
	Namespace: raps_mp
	Checksum: 0x85642215
	Offset: 0x3D80
	Size: 0x388
	Parameters: 3
	Flags: Linked
*/
function getrandomhelicopterposition(avoidpoint = vectorscale((-1, -1, -1), 9999999), otheravoidpoint = vectorscale((-1, -1, -1), 9999999), avoidradiussqr = 1800 * 1800)
{
	flyheight = int(airsupport::getminimumflyheight() + 1000);
	found = 0;
	tries = 0;
	for(i = 0; i <= 3; i++)
	{
		if(i == 3)
		{
			avoidradiussqr = -1;
		}
		/#
			if(getdvarint("") > 0)
			{
				server_frames_to_persist = int(60);
				circle(avoidpoint, 1800, (1, 0, 0), 1, 1, server_frames_to_persist);
				circle(avoidpoint, 1800 - 1, (1, 0, 0), 1, 1, server_frames_to_persist);
				circle(avoidpoint, 1800 - 2, (1, 0, 0), 1, 1, server_frames_to_persist);
				circle(otheravoidpoint, 1800, (1, 0, 0), 1, 1, server_frames_to_persist);
				circle(otheravoidpoint, 1800 - 1, (1, 0, 0), 1, 1, server_frames_to_persist);
				circle(otheravoidpoint, 1800 - 2, (1, 0, 0), 1, 1, server_frames_to_persist);
			}
		#/
		while(!found && tries < game["raps_helicopter_positions"].size)
		{
			index = randomintrange(0, game["raps_helicopter_positions"].size);
			randompoint = (game["raps_helicopter_positions"][index][0], game["raps_helicopter_positions"][index][1], flyheight);
			found = distance2dsquared(randompoint, avoidpoint) > avoidradiussqr && distance2dsquared(randompoint, otheravoidpoint) > avoidradiussqr;
			tries++;
		}
		if(!found)
		{
			avoidradiussqr = avoidradiussqr * 0.25;
			tries = 0;
		}
	}
	/#
		assert(found, "");
	#/
	return randompoint;
}

/*
	Name: getclosestrandomhelicopterposition
	Namespace: raps_mp
	Checksum: 0x665F76DC
	Offset: 0x4110
	Size: 0x150
	Parameters: 4
	Flags: Linked
*/
function getclosestrandomhelicopterposition(refpoint, pickcount, avoidpoint = vectorscale((-1, -1, -1), 9999999), otheravoidpoint = vectorscale((-1, -1, -1), 9999999))
{
	bestposition = getrandomhelicopterposition(avoidpoint, otheravoidpoint);
	bestdistancesqr = distance2dsquared(bestposition, refpoint);
	for(i = 1; i < pickcount; i++)
	{
		candidateposition = getrandomhelicopterposition(avoidpoint, otheravoidpoint);
		candidatedistancesqr = distance2dsquared(candidateposition, refpoint);
		if(candidatedistancesqr < bestdistancesqr)
		{
			bestposition = candidateposition;
			bestdistancesqr = candidatedistancesqr;
		}
	}
	return bestposition;
}

/*
	Name: waitforstoppingmovetoexpire
	Namespace: raps_mp
	Checksum: 0xA5B4445
	Offset: 0x4268
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function waitforstoppingmovetoexpire()
{
	elapsedtimestopping = gettime() - self.laststoptime;
	if(elapsedtimestopping < 2000)
	{
		wait((2000 - elapsedtimestopping) * 0.001);
	}
}

/*
	Name: getotherhelicopterpointtoavoid
	Namespace: raps_mp
	Checksum: 0xBC9A69C9
	Offset: 0x42B8
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function getotherhelicopterpointtoavoid()
{
	avoid_point = undefined;
	arrayremovevalue(level.raps_helicopters, undefined);
	foreach(heli in level.raps_helicopters)
	{
		if(heli != self)
		{
			avoid_point = heli.targetdroplocation;
			break;
		}
	}
	return avoid_point;
}

/*
	Name: picknextdroplocation
	Namespace: raps_mp
	Checksum: 0xDDA23EF8
	Offset: 0x4388
	Size: 0x13A
	Parameters: 5
	Flags: Linked
*/
function picknextdroplocation(heli, drop_index, firstdropreferencepoint, assigned_fly_height, lastdroplocation)
{
	avoid_point = self getotherhelicopterpointtoavoid();
	if(isdefined(heli) && isdefined(heli.prepickeddroplocation))
	{
		targetdroplocation = heli.prepickeddroplocation;
		heli.prepickeddroplocation = undefined;
		return targetdroplocation;
	}
	targetdroplocation = (drop_index == 0 ? getclosestrandomhelicopterposition(firstdropreferencepoint, int((game["raps_helicopter_positions"].size * (66.6 / 100)) + 1), avoid_point) : getrandomhelicopterposition(lastdroplocation, avoid_point));
	targetdroplocation = (targetdroplocation[0], targetdroplocation[1], assigned_fly_height);
	return targetdroplocation;
}

/*
	Name: helicopterthink
	Namespace: raps_mp
	Checksum: 0xEA04A85
	Offset: 0x44D0
	Size: 0x2EE
	Parameters: 0
	Flags: Linked
*/
function helicopterthink()
{
	/#
		if(getdvarint(""))
		{
			return;
		}
	#/
	self endon(#"raps_helicopter_shutdown");
	for(i = 0; i < 3; i++)
	{
		self.targetdroplocation = picknextdroplocation(self, i, self.firstdropreferencepoint, self.assigned_fly_height, self.lastdroplocation);
		while(distance2dsquared(self.origin, self.targetdroplocation) > 25)
		{
			self waitforstoppingmovetoexpire();
			self updatehelicopterspeed();
			self setvehgoalpos(self.targetdroplocation, 1);
			self waittill(#"goal");
		}
		if(isdefined(self.owner))
		{
			if((i + 1) < 3)
			{
				self killstreaks::play_pilot_dialog_on_owner("waveStart", "raps", self.killstreakid);
			}
			else
			{
				self killstreaks::play_pilot_dialog_on_owner("waveStartFinal", "raps", self.killstreakid);
			}
		}
		enemy = self.owner battlechatter::get_closest_player_enemy(self.origin, 1);
		enemyradius = battlechatter::mpdialog_value("rapsDropRadius", 0);
		if(isdefined(enemy) && distance2dsquared(self.origin, enemy.origin) < (enemyradius * enemyradius))
		{
			enemy battlechatter::play_killstreak_threat("raps");
		}
		self dropraps();
		wait(((i + 1) >= 3 ? 2 + (randomfloatrange(1 * -1, 1)) : 2 + (randomfloatrange(2 * -1, 2))));
	}
	self notify(#"raps_helicopter_shutdown", 0);
}

/*
	Name: helicopterthinkdebugvisitall
	Namespace: raps_mp
	Checksum: 0x3BD65471
	Offset: 0x47C8
	Size: 0x26E
	Parameters: 0
	Flags: Linked
*/
function helicopterthinkdebugvisitall()
{
	/#
		self endon(#"death");
		if(getdvarint("") == 0)
		{
			return;
		}
		for(i = 0; i < 100; i++)
		{
			for(j = 0; j < game[""].size; j++)
			{
				self.targetdroplocation = (game[""][j][0], game[""][j][1], self.assigned_fly_height);
				while(distance2dsquared(self.origin, self.targetdroplocation) > 25)
				{
					self waitforstoppingmovetoexpire();
					self updatehelicopterspeed();
					self setvehgoalpos(self.targetdroplocation, 1);
					self waittill(#"goal");
				}
				self dropraps();
				wait(1);
				if(getdvarint("") > 0)
				{
					if(((j + 1) % 3) == 0)
					{
						self.targetdroplocation = getrandomhelicopterstartorigin(self.assigned_fly_height, self.origin);
						while(distance2dsquared(self.origin, self.targetdroplocation) > 25)
						{
							self waitforstoppingmovetoexpire();
							self updatehelicopterspeed();
							self setvehgoalpos(self.targetdroplocation, 1);
							self waittill(#"goal");
						}
					}
				}
			}
		}
		self notify(#"raps_helicopter_shutdown", 0);
	#/
}

/*
	Name: dropraps
	Namespace: raps_mp
	Checksum: 0x283A8B20
	Offset: 0x4A40
	Size: 0x238
	Parameters: 0
	Flags: Linked
*/
function dropraps()
{
	level endon(#"game_ended");
	self endon(#"death");
	self.droppingraps = 1;
	self.lastdroplocation = self.origin;
	precisedroplocation = 0.5 * (self gettagorigin(level.raps_helicopter_drop_tag_names[0]) + self gettagorigin(level.raps_helicopter_drop_tag_names[1]));
	precisegoallocation = self.targetdroplocation + (self.targetdroplocation - precisedroplocation);
	precisegoallocation = (precisegoallocation[0], precisegoallocation[1], self.targetdroplocation[2]);
	self setvehgoalpos(precisegoallocation, 1);
	self waittill(#"goal");
	self.droppedraps = 1;
	for(i = 0; i < level.raps_settings.spawn_count; i++)
	{
		spawn_tag = level.raps_helicopter_drop_tag_names[i % level.raps_helicopter_drop_tag_names.size];
		origin = self gettagorigin(spawn_tag);
		angles = self gettagangles(spawn_tag);
		if(!isdefined(origin) || !isdefined(angles))
		{
			origin = self.origin;
			angles = self.angles;
		}
		self.owner thread spawnraps(origin, angles);
		self playsound("veh_raps_launch");
		wait(1);
	}
	self.droppingraps = 0;
}

/*
	Name: spin
	Namespace: raps_mp
	Checksum: 0xA3CB64CE
	Offset: 0x4C80
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function spin()
{
	self endon(#"stop_death_spin");
	speed = randomintrange(180, 220);
	self setyawspeed(speed, speed * 0.25, speed);
	if(randomintrange(0, 2) > 0)
	{
		speed = speed * -1;
	}
	while(isdefined(self))
	{
		self settargetyaw(self.angles[1] + (speed * 0.4));
		wait(1);
	}
}

/*
	Name: firstheliexplo
	Namespace: raps_mp
	Checksum: 0xAD53C445
	Offset: 0x4D60
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function firstheliexplo()
{
	playfxontag("killstreaks/fx_heli_raps_exp_sm", self, "tag_fx_engine_exhaust_back");
	self playsound(level.heli_sound["crash"]);
}

/*
	Name: helilowhealthfx
	Namespace: raps_mp
	Checksum: 0xCAE3B582
	Offset: 0x4DB8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function helilowhealthfx()
{
	self clientfield::set("raps_heli_low_health", 1);
}

/*
	Name: heliextralowhealthfx
	Namespace: raps_mp
	Checksum: 0x2F679691
	Offset: 0x4DE8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function heliextralowhealthfx()
{
	self clientfield::set("raps_heli_extra_low_health", 1);
}

/*
	Name: helideathtrails
	Namespace: raps_mp
	Checksum: 0xB41FC3B6
	Offset: 0x4E18
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function helideathtrails()
{
	playfxontag("killstreaks/fx_heli_raps_exp_trail", self, "tag_fx_engine_exhaust_back");
}

/*
	Name: finalhelideathexplode
	Namespace: raps_mp
	Checksum: 0xD3870968
	Offset: 0x4E48
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function finalhelideathexplode()
{
	playfxontag("killstreaks/fx_heli_raps_exp_lg", self, "tag_fx_death");
	self playsound(level.heli_sound["crash"]);
}

/*
	Name: helicopterleave
	Namespace: raps_mp
	Checksum: 0x7CBCDE96
	Offset: 0x4EA0
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function helicopterleave()
{
	self.isleaving = 1;
	self killstreaks::play_pilot_dialog_on_owner("timeout", "raps");
	self killstreaks::play_taacom_dialog_response_on_owner("timeoutConfirmed", "raps");
	self.leavelocation = getrandomhelicopterleaveorigin(0, self.origin);
	while(distance2dsquared(self.origin, self.leavelocation) > 360000)
	{
		self updatehelicopterspeed();
		self setvehgoalpos(self.leavelocation, 0);
		self waittill(#"goal");
	}
}

/*
	Name: updatehelicopterspeed
	Namespace: raps_mp
	Checksum: 0x5852CAEB
	Offset: 0x4FA0
	Size: 0x164
	Parameters: 1
	Flags: Linked
*/
function updatehelicopterspeed(drivemode)
{
	if(isdefined(drivemode))
	{
		switch(drivemode)
		{
			case 0:
			{
				self.drivemodespeedscale = 1;
				self.drivemodeaccel = 20;
				self.drivemodedecel = 20;
				break;
			}
			case 1:
			case 2:
			{
				self.drivemodespeedscale = (drivemode == 2 ? 0.2 : 0.5);
				self.drivemodeaccel = 12;
				self.drivemodedecel = 100;
				break;
			}
		}
	}
	desiredspeed = (self getmaxspeed() / 17.6) * self.drivemodespeedscale;
	if(desiredspeed < self getspeedmph())
	{
		self setspeed(desiredspeed, self.drivemodedecel, self.drivemodedecel);
	}
	else
	{
		self setspeed(desiredspeed, self.drivemodeaccel, self.drivemodedecel);
	}
}

/*
	Name: stophelicopter
	Namespace: raps_mp
	Checksum: 0xEA51925F
	Offset: 0x5110
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function stophelicopter()
{
	self setspeed(0, 500, 500);
	self.laststoptime = gettime();
}

/*
	Name: spawnraps
	Namespace: raps_mp
	Checksum: 0x6F2F6FB0
	Offset: 0x5148
	Size: 0x354
	Parameters: 2
	Flags: Linked
*/
function spawnraps(origin, angles)
{
	originalowner = self;
	originalownerentnum = originalowner.entnum;
	raps = spawnvehicle("spawner_bo3_raps_mp", origin, angles, "dynamic_spawn_ai");
	if(!isdefined(raps))
	{
		return;
	}
	raps.forceonemissile = 1;
	raps.drop_deploying = 1;
	raps.hurt_trigger_immune_end_time = gettime() + (isdefined(level.raps_hurt_trigger_immune_duration_ms) ? level.raps_hurt_trigger_immune_duration_ms : 5000);
	if(!isdefined(level.raps[originalownerentnum].raps))
	{
		level.raps[originalownerentnum].raps = [];
	}
	else if(!isarray(level.raps[originalownerentnum].raps))
	{
		level.raps[originalownerentnum].raps = array(level.raps[originalownerentnum].raps);
	}
	level.raps[originalownerentnum].raps[level.raps[originalownerentnum].raps.size] = raps;
	raps killstreaks::configure_team("raps", "raps", originalowner, undefined, undefined, &configureteampost);
	raps killstreak_hacking::enable_hacking("raps");
	raps clientfield::set("enemyvehicle", 1);
	raps.soundmod = "raps";
	raps.ignore_vehicle_underneath_splash_scalar = 1;
	raps.detonate_sides_disabled = 1;
	raps.treat_owner_damage_as_friendly_fire = 1;
	raps.ignore_team_kills = 1;
	raps setinvisibletoall();
	raps thread autosetvisibletoall();
	raps vehicle::toggle_sounds(0);
	raps thread watchrapskills(originalowner);
	raps thread watchrapsdeath(originalowner);
	raps thread killstreaks::waitfortimeout("raps", raps.settings.max_duration * 1000, &onrapstimeout, "death");
}

/*
	Name: configureteampost
	Namespace: raps_mp
	Checksum: 0x9DA73730
	Offset: 0x54A8
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function configureteampost(owner, ishacked)
{
	raps = self;
	raps thread createrapsinfluencer();
	raps thread initenemyselection(owner);
	raps thread watchrapstippedover(owner);
}

/*
	Name: autosetvisibletoall
	Namespace: raps_mp
	Checksum: 0x8836D64E
	Offset: 0x5520
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function autosetvisibletoall()
{
	self endon(#"death");
	wait(0.05);
	wait(0.05);
	self setvisibletoall();
}

/*
	Name: onrapstimeout
	Namespace: raps_mp
	Checksum: 0x877DF6FF
	Offset: 0x5560
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function onrapstimeout()
{
	self selfdestruct(self.owner);
}

/*
	Name: selfdestruct
	Namespace: raps_mp
	Checksum: 0x91DFBCB9
	Offset: 0x5590
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function selfdestruct(attacker)
{
	self.selfdestruct = 1;
	self raps::detonate(attacker);
}

/*
	Name: watchrapskills
	Namespace: raps_mp
	Checksum: 0x1A7DA20E
	Offset: 0x55D0
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function watchrapskills(originalowner)
{
	originalowner endon(#"raps_complete");
	self endon(#"death");
	if(self.settings.max_kill_count == 0)
	{
		return;
	}
	while(true)
	{
		self waittill(#"killed", victim);
		if(isdefined(victim) && isplayer(victim))
		{
			if(!isdefined(self.killcount))
			{
				self.killcount = 0;
			}
			self.killcount++;
			if(self.killcount >= self.settings.max_kill_count)
			{
				self raps::detonate(self.owner);
			}
		}
	}
}

/*
	Name: watchrapstippedover
	Namespace: raps_mp
	Checksum: 0x74349800
	Offset: 0x56B8
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function watchrapstippedover(owner)
{
	owner endon(#"disconnect");
	self endon(#"death");
	while(true)
	{
		wait(3.5);
		if(abs(self.angles[2]) > 75)
		{
			self raps::detonate(owner);
		}
	}
}

/*
	Name: watchrapsdeath
	Namespace: raps_mp
	Checksum: 0x241A2301
	Offset: 0x5738
	Size: 0x22C
	Parameters: 1
	Flags: Linked
*/
function watchrapsdeath(originalowner)
{
	originalownerentnum = originalowner.entnum;
	self waittill(#"death", attacker, damagefromunderneath, weapon);
	attacker = self [[level.figure_out_attacker]](attacker);
	if(isdefined(attacker) && isplayer(attacker))
	{
		if(isdefined(self.owner) && self.owner != attacker && self.owner.team != attacker.team)
		{
			scoreevents::processscoreevent("killed_raps", attacker);
			attacker challenges::destroyscorestreak(weapon, 1);
			attacker challenges::destroynonairscorestreak_poststatslock(weapon);
			if(isdefined(self.attackers))
			{
				foreach(player in self.attackers)
				{
					if(isplayer(player) && player != attacker && player != self.owner)
					{
						scoreevents::processscoreevent("killed_raps_assist", player);
					}
				}
			}
		}
	}
	arrayremovevalue(level.raps[originalownerentnum].raps, self);
}

/*
	Name: initenemyselection
	Namespace: raps_mp
	Checksum: 0xDB392AA5
	Offset: 0x5970
	Size: 0x274
	Parameters: 1
	Flags: Linked
*/
function initenemyselection(owner)
{
	owner endon(#"disconnect");
	self endon(#"death");
	self endon(#"hacked");
	self vehicle_ai::set_state("off");
	util::wait_network_frame();
	util::wait_network_frame();
	self setvehiclefordropdeploy();
	self clientfield::set("monitor_raps_drop_landing", 1);
	wait(3);
	if(self initialwaituntilsettled())
	{
		self resetvehiclefromdropdeploy();
		self setgoal(self.origin);
		self vehicle_ai::set_state("combat");
		self vehicle::toggle_sounds(1);
		self.drop_deploying = undefined;
		self.hurt_trigger_immune_end_time = undefined;
		target_set(self);
		for(i = 0; i < level.raps[owner.entnum].raps.size; i++)
		{
			raps = level.raps[owner.entnum].raps[i];
			if(isdefined(raps) && isdefined(raps.enemy) && isdefined(self) && isdefined(self.enemy) && raps != self && raps.enemy == self.enemy)
			{
				self setpersonalthreatbias(self.enemy, -2000, 5);
			}
		}
	}
	else
	{
		self selfdestruct(self.owner);
	}
}

/*
	Name: initialwaituntilsettled
	Namespace: raps_mp
	Checksum: 0x8C6AEB3E
	Offset: 0x5BF0
	Size: 0x136
	Parameters: 0
	Flags: Linked
*/
function initialwaituntilsettled()
{
	waittime = 0;
	while(abs(self.velocity[2]) > 0.1 && waittime < 5)
	{
		wait(0.2);
		waittime = waittime + 0.2;
	}
	while(!ispointonnavmesh(self.origin, 36) || abs(self.velocity[2]) > 0.1 && waittime < (5 + 5))
	{
		wait(0.2);
		waittime = waittime + 0.2;
	}
	/#
		if(0)
		{
			waittime = waittime + (5 + 5);
		}
	#/
	return waittime < (5 + 5);
}

/*
	Name: destroyallraps
	Namespace: raps_mp
	Checksum: 0xCA01F090
	Offset: 0x5D30
	Size: 0xFA
	Parameters: 2
	Flags: Linked
*/
function destroyallraps(entnum, abandoned = 0)
{
	foreach(raps in level.raps[entnum].raps)
	{
		if(isalive(raps))
		{
			raps.owner = undefined;
			raps.abandoned = abandoned;
			raps raps::detonate(raps);
		}
	}
}

/*
	Name: forcegetenemies
	Namespace: raps_mp
	Checksum: 0x618812D8
	Offset: 0x5E38
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function forcegetenemies()
{
	foreach(player in level.players)
	{
		if(isdefined(self.owner) && self.owner util::isenemyplayer(player) && !player smokegrenade::isinsmokegrenade() && !player hasperk("specialty_nottargetedbyraps"))
		{
			self getperfectinfo(player);
			return;
		}
	}
}

/*
	Name: createrapshelicopterinfluencer
	Namespace: raps_mp
	Checksum: 0xC57333FF
	Offset: 0x5F40
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function createrapshelicopterinfluencer()
{
	level endon(#"game_ended");
	helicopter = self;
	if(isdefined(helicopter.influencerent))
	{
		helicopter.influencerent delete();
	}
	influencerent = spawn("script_model", helicopter.origin - (0, 0, self.assigned_fly_height));
	helicopter.influencerent = influencerent;
	helicopter.influencerent.angles = (0, 0, 0);
	helicopter.influencerent linkto(helicopter);
	preset = getinfluencerpreset("helicopter");
	if(!isdefined(preset))
	{
		return;
	}
	enemy_team_mask = helicopter spawning::get_enemy_team_mask(helicopter.team);
	helicopter.influencerent spawning::create_entity_influencer("helicopter", enemy_team_mask);
	helicopter waittill(#"death");
	if(isdefined(influencerent))
	{
		influencerent delete();
	}
}

/*
	Name: createrapsinfluencer
	Namespace: raps_mp
	Checksum: 0xB8E45F7D
	Offset: 0x60E8
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function createrapsinfluencer()
{
	raps = self;
	preset = getinfluencerpreset("raps");
	if(!isdefined(preset))
	{
		return;
	}
	enemy_team_mask = raps spawning::get_enemy_team_mask(raps.team);
	raps spawning::create_entity_influencer("raps", enemy_team_mask);
}

