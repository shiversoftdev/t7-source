// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\challenges_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\_weapons;

#namespace airsupport;

/*
	Name: init
	Namespace: airsupport
	Checksum: 0xF27215D2
	Offset: 0x358
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	if(!isdefined(level.airsupportheightscale))
	{
		level.airsupportheightscale = 1;
	}
	level.airsupportheightscale = getdvarint("scr_airsupportHeightScale", level.airsupportheightscale);
	level.noflyzones = [];
	level.noflyzones = getentarray("no_fly_zone", "targetname");
	airsupport_heights = struct::get_array("air_support_height", "targetname");
	/#
		if(airsupport_heights.size > 1)
		{
			util::error("");
		}
	#/
	airsupport_heights = getentarray("air_support_height", "targetname");
	/#
		if(airsupport_heights.size > 0)
		{
			util::error("");
		}
	#/
	heli_height_meshes = getentarray("heli_height_lock", "classname");
	/#
		if(heli_height_meshes.size > 1)
		{
			util::error("");
		}
	#/
	initrotatingrig();
}

/*
	Name: finishhardpointlocationusage
	Namespace: airsupport
	Checksum: 0x4D4AC4A8
	Offset: 0x4F0
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function finishhardpointlocationusage(location, usedcallback)
{
	self notify(#"used");
	wait(0.05);
	if(isdefined(usedcallback))
	{
		return self [[usedcallback]](location);
	}
	return 1;
}

/*
	Name: finishdualhardpointlocationusage
	Namespace: airsupport
	Checksum: 0x10CF9677
	Offset: 0x548
	Size: 0x48
	Parameters: 3
	Flags: None
*/
function finishdualhardpointlocationusage(locationstart, locationend, usedcallback)
{
	self notify(#"used");
	wait(0.05);
	return self [[usedcallback]](locationstart, locationend);
}

/*
	Name: endselectionongameend
	Namespace: airsupport
	Checksum: 0xE0B98A60
	Offset: 0x598
	Size: 0x5A
	Parameters: 0
	Flags: Linked
*/
function endselectionongameend()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"cancel_location");
	self endon(#"used");
	self endon(#"host_migration_begin");
	level waittill(#"game_ended");
	self notify(#"game_ended");
}

/*
	Name: endselectiononhostmigration
	Namespace: airsupport
	Checksum: 0xC69E28DE
	Offset: 0x600
	Size: 0x5A
	Parameters: 0
	Flags: Linked
*/
function endselectiononhostmigration()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"cancel_location");
	self endon(#"used");
	self endon(#"game_ended");
	level waittill(#"host_migration_begin");
	self notify(#"cancel_location");
}

/*
	Name: endselectionthink
	Namespace: airsupport
	Checksum: 0x1F5FB587
	Offset: 0x668
	Size: 0x176
	Parameters: 0
	Flags: Linked
*/
function endselectionthink()
{
	/#
		assert(isplayer(self));
	#/
	/#
		assert(isalive(self));
	#/
	/#
		assert(isdefined(self.selectinglocation));
	#/
	/#
		assert(self.selectinglocation == 1);
	#/
	self thread endselectionongameend();
	self thread endselectiononhostmigration();
	event = self util::waittill_any_return("death", "disconnect", "cancel_location", "game_ended", "used", "weapon_change", "emp_jammed");
	if(event != "disconnect")
	{
		self.selectinglocation = undefined;
		self thread clearuplocationselection();
	}
	if(event != "used")
	{
		self notify(#"confirm_location", undefined, undefined);
	}
}

/*
	Name: clearuplocationselection
	Namespace: airsupport
	Checksum: 0x383FCC23
	Offset: 0x7E8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function clearuplocationselection()
{
	event = self util::waittill_any_return("death", "disconnect", "game_ended", "used", "weapon_change", "emp_jammed", "weapon_change_complete");
	if(event != "disconnect")
	{
		self endlocationselection();
	}
}

/*
	Name: stoploopsoundaftertime
	Namespace: airsupport
	Checksum: 0xDC000094
	Offset: 0x878
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function stoploopsoundaftertime(time)
{
	self endon(#"death");
	wait(time);
	self stoploopsound(2);
}

/*
	Name: calculatefalltime
	Namespace: airsupport
	Checksum: 0xA3BA544E
	Offset: 0x8B8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function calculatefalltime(flyheight)
{
	gravity = getdvarint("bg_gravity");
	time = sqrt((2 * flyheight) / gravity);
	return time;
}

/*
	Name: calculatereleasetime
	Namespace: airsupport
	Checksum: 0x2EEF3FF7
	Offset: 0x928
	Size: 0x92
	Parameters: 4
	Flags: Linked
*/
function calculatereleasetime(flytime, flyheight, flyspeed, bombspeedscale)
{
	falltime = calculatefalltime(flyheight);
	bomb_x = (flyspeed * bombspeedscale) * falltime;
	release_time = bomb_x / flyspeed;
	return (flytime * 0.5) - release_time;
}

/*
	Name: getminimumflyheight
	Namespace: airsupport
	Checksum: 0xF0951F8A
	Offset: 0x9C8
	Size: 0x10E
	Parameters: 0
	Flags: Linked
*/
function getminimumflyheight()
{
	airsupport_height = struct::get("air_support_height", "targetname");
	if(isdefined(airsupport_height))
	{
		planeflyheight = airsupport_height.origin[2];
	}
	else
	{
		/#
			println("");
		#/
		planeflyheight = 850;
		if(isdefined(level.airsupportheightscale))
		{
			level.airsupportheightscale = getdvarint("scr_airsupportHeightScale", level.airsupportheightscale);
			planeflyheight = planeflyheight * getdvarint("scr_airsupportHeightScale", level.airsupportheightscale);
		}
		if(isdefined(level.forceairsupportmapheight))
		{
			planeflyheight = planeflyheight + level.forceairsupportmapheight;
		}
	}
	return planeflyheight;
}

/*
	Name: callstrike
	Namespace: airsupport
	Checksum: 0x54344857
	Offset: 0xAE0
	Size: 0x3F4
	Parameters: 1
	Flags: None
*/
function callstrike(flightplan)
{
	level.bomberdamagedents = [];
	level.bomberdamagedentscount = 0;
	level.bomberdamagedentsindex = 0;
	/#
		assert(flightplan.distance != 0, "");
	#/
	planehalfdistance = flightplan.distance / 2;
	path = getstrikepath(flightplan.target, flightplan.height, planehalfdistance);
	startpoint = path["start"];
	endpoint = path["end"];
	flightplan.height = path["height"];
	direction = path["direction"];
	d = length(startpoint - endpoint);
	flytime = d / flightplan.speed;
	bombtime = calculatereleasetime(flytime, flightplan.height, flightplan.speed, flightplan.bombspeedscale);
	if(bombtime < 0)
	{
		bombtime = 0;
	}
	/#
		assert(flytime > bombtime);
	#/
	flightplan.owner endon(#"disconnect");
	requireddeathcount = flightplan.owner.deathcount;
	side = vectorcross(anglestoforward(direction), (0, 0, 1));
	plane_seperation = 25;
	side_offset = vectorscale(side, plane_seperation);
	level thread planestrike(flightplan.owner, requireddeathcount, startpoint, endpoint, bombtime, flytime, flightplan.speed, flightplan.bombspeedscale, direction, flightplan.planespawncallback);
	wait(flightplan.planespacing);
	level thread planestrike(flightplan.owner, requireddeathcount, startpoint + side_offset, endpoint + side_offset, bombtime, flytime, flightplan.speed, flightplan.bombspeedscale, direction, flightplan.planespawncallback);
	wait(flightplan.planespacing);
	side_offset = vectorscale(side, -1 * plane_seperation);
	level thread planestrike(flightplan.owner, requireddeathcount, startpoint + side_offset, endpoint + side_offset, bombtime, flytime, flightplan.speed, flightplan.bombspeedscale, direction, flightplan.planespawncallback);
}

/*
	Name: planestrike
	Namespace: airsupport
	Checksum: 0xF170A78D
	Offset: 0xEE0
	Size: 0x14C
	Parameters: 10
	Flags: Linked
*/
function planestrike(owner, requireddeathcount, pathstart, pathend, bombtime, flytime, flyspeed, bombspeedscale, direction, planespawnedfunction)
{
	if(!isdefined(owner))
	{
		return;
	}
	plane = spawnplane(owner, "script_model", pathstart);
	plane.angles = direction;
	plane moveto(pathend, flytime, 0, 0);
	thread debug_plane_line(flytime, flyspeed, pathstart, pathend);
	if(isdefined(planespawnedfunction))
	{
		plane [[planespawnedfunction]](owner, requireddeathcount, pathstart, pathend, bombtime, bombspeedscale, flytime, flyspeed);
	}
	wait(flytime);
	plane notify(#"delete");
	plane delete();
}

/*
	Name: determinegroundpoint
	Namespace: airsupport
	Checksum: 0xC1DD2E4B
	Offset: 0x1038
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function determinegroundpoint(player, position)
{
	ground = (position[0], position[1], player.origin[2]);
	trace = bullettrace(ground + vectorscale((0, 0, 1), 10000), ground, 0, undefined);
	return trace["position"];
}

/*
	Name: determinetargetpoint
	Namespace: airsupport
	Checksum: 0x30014B87
	Offset: 0x10D0
	Size: 0x4A
	Parameters: 2
	Flags: None
*/
function determinetargetpoint(player, position)
{
	point = determinegroundpoint(player, position);
	return clamptarget(point);
}

/*
	Name: getmintargetheight
	Namespace: airsupport
	Checksum: 0xC0FA1D15
	Offset: 0x1128
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function getmintargetheight()
{
	return level.spawnmins[2] - 500;
}

/*
	Name: getmaxtargetheight
	Namespace: airsupport
	Checksum: 0x918658CB
	Offset: 0x1148
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function getmaxtargetheight()
{
	return level.spawnmaxs[2] + 500;
}

/*
	Name: clamptarget
	Namespace: airsupport
	Checksum: 0x273A1457
	Offset: 0x1168
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function clamptarget(target)
{
	min = getmintargetheight();
	max = getmaxtargetheight();
	if(target[2] < min)
	{
		target[2] = min;
	}
	if(target[2] > max)
	{
		target[2] = max;
	}
	return target;
}

/*
	Name: _insidecylinder
	Namespace: airsupport
	Checksum: 0x233BF2CB
	Offset: 0x1208
	Size: 0x8E
	Parameters: 4
	Flags: Linked
*/
function _insidecylinder(point, base, radius, height)
{
	if(isdefined(height))
	{
		if(point[2] > (base[2] + height))
		{
			return false;
		}
	}
	dist = distance2d(point, base);
	if(dist < radius)
	{
		return true;
	}
	return false;
}

/*
	Name: _insidenoflyzonebyindex
	Namespace: airsupport
	Checksum: 0x9C3FC95B
	Offset: 0x12A0
	Size: 0x9A
	Parameters: 3
	Flags: Linked
*/
function _insidenoflyzonebyindex(point, index, disregardheight)
{
	height = level.noflyzones[index].height;
	if(isdefined(disregardheight))
	{
		height = undefined;
	}
	return _insidecylinder(point, level.noflyzones[index].origin, level.noflyzones[index].radius, height);
}

/*
	Name: getnoflyzoneheight
	Namespace: airsupport
	Checksum: 0xD6E8E7DB
	Offset: 0x1348
	Size: 0x100
	Parameters: 1
	Flags: Linked
*/
function getnoflyzoneheight(point)
{
	height = point[2];
	origin = undefined;
	for(i = 0; i < level.noflyzones.size; i++)
	{
		if(_insidenoflyzonebyindex(point, i))
		{
			if(height < level.noflyzones[i].height)
			{
				height = level.noflyzones[i].height;
				origin = level.noflyzones[i].origin;
			}
		}
	}
	if(!isdefined(origin))
	{
		return point[2];
	}
	return origin[2] + height;
}

/*
	Name: insidenoflyzones
	Namespace: airsupport
	Checksum: 0x36811204
	Offset: 0x1450
	Size: 0x86
	Parameters: 2
	Flags: Linked
*/
function insidenoflyzones(point, disregardheight)
{
	noflyzones = [];
	for(i = 0; i < level.noflyzones.size; i++)
	{
		if(_insidenoflyzonebyindex(point, i, disregardheight))
		{
			noflyzones[noflyzones.size] = i;
		}
	}
	return noflyzones;
}

/*
	Name: crossesnoflyzone
	Namespace: airsupport
	Checksum: 0x8BFA5B4F
	Offset: 0x14E0
	Size: 0x156
	Parameters: 2
	Flags: Linked
*/
function crossesnoflyzone(start, end)
{
	for(i = 0; i < level.noflyzones.size; i++)
	{
		point = math::closest_point_on_line(level.noflyzones[i].origin + (0, 0, 0.5 * level.noflyzones[i].height), start, end);
		dist = distance2d(point, level.noflyzones[i].origin);
		if(point[2] > (level.noflyzones[i].origin[2] + level.noflyzones[i].height))
		{
			continue;
		}
		if(dist < level.noflyzones[i].radius)
		{
			return i;
		}
	}
	return undefined;
}

/*
	Name: crossesnoflyzones
	Namespace: airsupport
	Checksum: 0x7110A680
	Offset: 0x1640
	Size: 0x144
	Parameters: 2
	Flags: Linked
*/
function crossesnoflyzones(start, end)
{
	zones = [];
	for(i = 0; i < level.noflyzones.size; i++)
	{
		point = math::closest_point_on_line(level.noflyzones[i].origin, start, end);
		dist = distance2d(point, level.noflyzones[i].origin);
		if(point[2] > (level.noflyzones[i].origin[2] + level.noflyzones[i].height))
		{
			continue;
		}
		if(dist < level.noflyzones[i].radius)
		{
			zones[zones.size] = i;
		}
	}
	return zones;
}

/*
	Name: getnoflyzoneheightcrossed
	Namespace: airsupport
	Checksum: 0xB1CDCCBB
	Offset: 0x1790
	Size: 0x132
	Parameters: 3
	Flags: Linked
*/
function getnoflyzoneheightcrossed(start, end, minheight)
{
	height = minheight;
	for(i = 0; i < level.noflyzones.size; i++)
	{
		point = math::closest_point_on_line(level.noflyzones[i].origin, start, end);
		dist = distance2d(point, level.noflyzones[i].origin);
		if(dist < level.noflyzones[i].radius)
		{
			if(height < level.noflyzones[i].height)
			{
				height = level.noflyzones[i].height;
			}
		}
	}
	return height;
}

/*
	Name: _shouldignorenoflyzone
	Namespace: airsupport
	Checksum: 0xE1A41D17
	Offset: 0x18D0
	Size: 0x7A
	Parameters: 2
	Flags: Linked
*/
function _shouldignorenoflyzone(noflyzone, noflyzones)
{
	if(!isdefined(noflyzone))
	{
		return true;
	}
	for(i = 0; i < noflyzones.size; i++)
	{
		if(isdefined(noflyzones[i]) && noflyzones[i] == noflyzone)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: _shouldignorestartgoalnoflyzone
	Namespace: airsupport
	Checksum: 0x9915DC5
	Offset: 0x1958
	Size: 0x6E
	Parameters: 3
	Flags: Linked
*/
function _shouldignorestartgoalnoflyzone(noflyzone, startnoflyzones, goalnoflyzones)
{
	if(!isdefined(noflyzone))
	{
		return true;
	}
	if(_shouldignorenoflyzone(noflyzone, startnoflyzones))
	{
		return true;
	}
	if(_shouldignorenoflyzone(noflyzone, goalnoflyzones))
	{
		return true;
	}
	return false;
}

/*
	Name: gethelipath
	Namespace: airsupport
	Checksum: 0x82B6DE87
	Offset: 0x19D0
	Size: 0x118
	Parameters: 2
	Flags: Linked
*/
function gethelipath(start, goal)
{
	startnoflyzones = insidenoflyzones(start, 1);
	thread debug_line(start, goal, (1, 1, 1));
	goalnoflyzones = insidenoflyzones(goal);
	if(goalnoflyzones.size)
	{
		goal = (goal[0], goal[1], getnoflyzoneheight(goal));
	}
	goal_points = calculatepath(start, goal, startnoflyzones, goalnoflyzones);
	if(!isdefined(goal_points))
	{
		return undefined;
	}
	/#
		assert(goal_points.size >= 1);
	#/
	return goal_points;
}

/*
	Name: followpath
	Namespace: airsupport
	Checksum: 0x3AAB51E1
	Offset: 0x1AF0
	Size: 0x114
	Parameters: 3
	Flags: Linked
*/
function followpath(path, donenotify, stopatgoal)
{
	for(i = 0; i < (path.size - 1); i++)
	{
		self setvehgoalpos(path[i], 0);
		thread debug_line(self.origin, path[i], (1, 1, 0));
		self waittill(#"goal");
	}
	self setvehgoalpos(path[path.size - 1], stopatgoal);
	thread debug_line(self.origin, path[i], (1, 1, 0));
	self waittill(#"goal");
	if(isdefined(donenotify))
	{
		self notify(donenotify);
	}
}

/*
	Name: setgoalposition
	Namespace: airsupport
	Checksum: 0xD8B13B8E
	Offset: 0x1C10
	Size: 0xA4
	Parameters: 3
	Flags: None
*/
function setgoalposition(goal, donenotify, stopatgoal = 1)
{
	start = self.origin;
	goal_points = gethelipath(start, goal);
	if(!isdefined(goal_points))
	{
		goal_points = [];
		goal_points[0] = goal;
	}
	followpath(goal_points, donenotify, stopatgoal);
}

/*
	Name: clearpath
	Namespace: airsupport
	Checksum: 0xBE577164
	Offset: 0x1CC0
	Size: 0xA0
	Parameters: 4
	Flags: None
*/
function clearpath(start, end, startnoflyzone, goalnoflyzone)
{
	noflyzones = crossesnoflyzones(start, end);
	for(i = 0; i < noflyzones.size; i++)
	{
		if(!_shouldignorestartgoalnoflyzone(noflyzones[i], startnoflyzone, goalnoflyzone))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: append_array
	Namespace: airsupport
	Checksum: 0x8C960F08
	Offset: 0x1D68
	Size: 0x56
	Parameters: 2
	Flags: None
*/
function append_array(dst, src)
{
	for(i = 0; i < src.size; i++)
	{
		dst[dst.size] = src[i];
	}
}

/*
	Name: calculatepath_r
	Namespace: airsupport
	Checksum: 0xC51CE290
	Offset: 0x1DC8
	Size: 0x102
	Parameters: 6
	Flags: Linked
*/
function calculatepath_r(start, end, points, startnoflyzones, goalnoflyzones, depth)
{
	depth--;
	if(depth <= 0)
	{
		points[points.size] = end;
		return points;
	}
	noflyzones = crossesnoflyzones(start, end);
	for(i = 0; i < noflyzones.size; i++)
	{
		noflyzone = noflyzones[i];
		if(!_shouldignorestartgoalnoflyzone(noflyzone, startnoflyzones, goalnoflyzones))
		{
			return undefined;
		}
	}
	points[points.size] = end;
	return points;
}

/*
	Name: calculatepath
	Namespace: airsupport
	Checksum: 0xE9EB8A5B
	Offset: 0x1ED8
	Size: 0x172
	Parameters: 4
	Flags: Linked
*/
function calculatepath(start, end, startnoflyzones, goalnoflyzones)
{
	points = [];
	points = calculatepath_r(start, end, points, startnoflyzones, goalnoflyzones, 3);
	if(!isdefined(points))
	{
		return undefined;
	}
	/#
		assert(points.size >= 1);
	#/
	debug_sphere(points[points.size - 1], 10, (1, 0, 0), 1, 1000);
	point = start;
	for(i = 0; i < points.size; i++)
	{
		thread debug_line(point, points[i], (0, 1, 0));
		debug_sphere(points[i], 10, (0, 0, 1), 1, 1000);
		point = points[i];
	}
	return points;
}

/*
	Name: _getstrikepathstartandend
	Namespace: airsupport
	Checksum: 0x9D7370AB
	Offset: 0x2058
	Size: 0x1B2
	Parameters: 3
	Flags: Linked
*/
function _getstrikepathstartandend(goal, yaw, halfdistance)
{
	direction = (0, yaw, 0);
	startpoint = goal + (vectorscale(anglestoforward(direction), -1 * halfdistance));
	endpoint = goal + vectorscale(anglestoforward(direction), halfdistance);
	noflyzone = crossesnoflyzone(startpoint, endpoint);
	path = [];
	if(isdefined(noflyzone))
	{
		path["noFlyZone"] = noflyzone;
		startpoint = (startpoint[0], startpoint[1], level.noflyzones[noflyzone].origin[2] + level.noflyzones[noflyzone].height);
		endpoint = (endpoint[0], endpoint[1], startpoint[2]);
	}
	else
	{
		path["noFlyZone"] = undefined;
	}
	path["start"] = startpoint;
	path["end"] = endpoint;
	path["direction"] = direction;
	return path;
}

/*
	Name: getstrikepath
	Namespace: airsupport
	Checksum: 0x9CD84D68
	Offset: 0x2218
	Size: 0x18A
	Parameters: 4
	Flags: Linked
*/
function getstrikepath(target, height, halfdistance, yaw)
{
	noflyzoneheight = getnoflyzoneheight(target);
	worldheight = target[2] + height;
	if(noflyzoneheight > worldheight)
	{
		worldheight = noflyzoneheight;
	}
	goal = (target[0], target[1], worldheight);
	path = [];
	if(!isdefined(yaw) || yaw != "random")
	{
		for(i = 0; i < 3; i++)
		{
			path = _getstrikepathstartandend(goal, randomint(360), halfdistance);
			if(!isdefined(path["noFlyZone"]))
			{
				break;
			}
		}
	}
	else
	{
		path = _getstrikepathstartandend(goal, yaw, halfdistance);
	}
	path["height"] = worldheight - target[2];
	return path;
}

/*
	Name: doglassdamage
	Namespace: airsupport
	Checksum: 0x289984A2
	Offset: 0x23B0
	Size: 0x74
	Parameters: 5
	Flags: None
*/
function doglassdamage(pos, radius, max, min, mod)
{
	wait(randomfloatrange(0.05, 0.15));
	glassradiusdamage(pos, radius, max, min, mod);
}

/*
	Name: entlosradiusdamage
	Namespace: airsupport
	Checksum: 0xFBAB79BA
	Offset: 0x2430
	Size: 0x418
	Parameters: 7
	Flags: None
*/
function entlosradiusdamage(ent, pos, radius, max, min, owner, einflictor)
{
	dist = distance(pos, ent.damagecenter);
	if(ent.isplayer || ent.isactor)
	{
		assumed_ceiling_height = 800;
		eye_position = ent.entity geteye();
		head_height = eye_position[2];
		debug_display_time = 4000;
		trace = weapons::damage_trace(ent.entity.origin, ent.entity.origin + (0, 0, assumed_ceiling_height), 0, undefined);
		indoors = trace["fraction"] != 1;
		if(indoors)
		{
			test_point = trace["position"];
			debug_star(test_point, (0, 1, 0), debug_display_time);
			trace = weapons::damage_trace((test_point[0], test_point[1], head_height), (pos[0], pos[1], head_height), 0, undefined);
			indoors = trace["fraction"] != 1;
			if(indoors)
			{
				debug_star((pos[0], pos[1], head_height), (0, 1, 0), debug_display_time);
				dist = dist * 4;
				if(dist > radius)
				{
					return false;
				}
			}
			else
			{
				debug_star((pos[0], pos[1], head_height), (1, 0, 0), debug_display_time);
				trace = weapons::damage_trace((pos[0], pos[1], head_height), pos, 0, undefined);
				indoors = trace["fraction"] != 1;
				if(indoors)
				{
					debug_star(pos, (0, 1, 0), debug_display_time);
					dist = dist * 4;
					if(dist > radius)
					{
						return false;
					}
				}
				else
				{
					debug_star(pos, (1, 0, 0), debug_display_time);
				}
			}
		}
		else
		{
			debug_star(ent.entity.origin + (0, 0, assumed_ceiling_height), (1, 0, 0), debug_display_time);
		}
	}
	ent.damage = int(max + (((min - max) * dist) / radius));
	ent.pos = pos;
	ent.damageowner = owner;
	ent.einflictor = einflictor;
	return true;
}

/*
	Name: getmapcenter
	Namespace: airsupport
	Checksum: 0x7D46AF59
	Offset: 0x2850
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function getmapcenter()
{
	minimaporigins = getentarray("minimap_corner", "targetname");
	if(minimaporigins.size)
	{
		return math::find_box_center(minimaporigins[0].origin, minimaporigins[1].origin);
	}
	return (0, 0, 0);
}

/*
	Name: getrandommappoint
	Namespace: airsupport
	Checksum: 0xDE07BBE7
	Offset: 0x28C8
	Size: 0x216
	Parameters: 4
	Flags: Linked
*/
function getrandommappoint(x_offset, y_offset, map_x_percentage, map_y_percentage)
{
	minimaporigins = getentarray("minimap_corner", "targetname");
	if(minimaporigins.size)
	{
		rand_x = 0;
		rand_y = 0;
		if(minimaporigins[0].origin[0] < minimaporigins[1].origin[0])
		{
			rand_x = randomfloatrange(minimaporigins[0].origin[0] * map_x_percentage, minimaporigins[1].origin[0] * map_x_percentage);
			rand_y = randomfloatrange(minimaporigins[0].origin[1] * map_y_percentage, minimaporigins[1].origin[1] * map_y_percentage);
		}
		else
		{
			rand_x = randomfloatrange(minimaporigins[1].origin[0] * map_x_percentage, minimaporigins[0].origin[0] * map_x_percentage);
			rand_y = randomfloatrange(minimaporigins[1].origin[1] * map_y_percentage, minimaporigins[0].origin[1] * map_y_percentage);
		}
		return (x_offset + rand_x, y_offset + rand_y, 0);
	}
	return (x_offset, y_offset, 0);
}

/*
	Name: getmaxmapwidth
	Namespace: airsupport
	Checksum: 0x7F5EDB97
	Offset: 0x2AE8
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function getmaxmapwidth()
{
	minimaporigins = getentarray("minimap_corner", "targetname");
	if(minimaporigins.size)
	{
		x = abs(minimaporigins[0].origin[0] - minimaporigins[1].origin[0]);
		y = abs(minimaporigins[0].origin[1] - minimaporigins[1].origin[1]);
		return max(x, y);
	}
	return 0;
}

/*
	Name: initrotatingrig
	Namespace: airsupport
	Checksum: 0x8426984D
	Offset: 0x2BE8
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function initrotatingrig()
{
	level.airsupport_rotator = spawn("script_model", getmapcenter() + ((isdefined(level.rotator_x_offset) ? level.rotator_x_offset : 0), (isdefined(level.rotator_y_offset) ? level.rotator_y_offset : 0), 1200));
	level.airsupport_rotator setmodel("tag_origin");
	level.airsupport_rotator.angles = vectorscale((0, 1, 0), 115);
	level.airsupport_rotator hide();
	level.airsupport_rotator thread rotaterig();
	level.airsupport_rotator thread swayrig();
}

/*
	Name: rotaterig
	Namespace: airsupport
	Checksum: 0x8264CAD6
	Offset: 0x2CF0
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function rotaterig()
{
	for(;;)
	{
		self rotateyaw(-360, 60);
		wait(60);
	}
}

/*
	Name: swayrig
	Namespace: airsupport
	Checksum: 0xFE9F30F6
	Offset: 0x2D28
	Size: 0x11E
	Parameters: 0
	Flags: Linked
*/
function swayrig()
{
	centerorigin = self.origin;
	for(;;)
	{
		z = randomintrange(-200, -100);
		time = randomintrange(3, 6);
		self moveto(centerorigin + (0, 0, z), time, 1, 1);
		wait(time);
		z = randomintrange(100, 200);
		time = randomintrange(3, 6);
		self moveto(centerorigin + (0, 0, z), time, 1, 1);
		wait(time);
	}
}

/*
	Name: stoprotation
	Namespace: airsupport
	Checksum: 0x2BDF16E4
	Offset: 0x2E50
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function stoprotation(time)
{
	self endon(#"death");
	wait(time);
	self stoploopsound();
}

/*
	Name: flattenyaw
	Namespace: airsupport
	Checksum: 0xC231A83F
	Offset: 0x2E90
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function flattenyaw(goal)
{
	self endon(#"death");
	increment = 3;
	if(self.angles[1] > goal)
	{
		increment = increment * -1;
	}
	while((abs(self.angles[1] - goal)) > 3)
	{
		self.angles = (self.angles[0], self.angles[1] + increment, self.angles[2]);
		wait(0.05);
	}
}

/*
	Name: flattenroll
	Namespace: airsupport
	Checksum: 0x303A839D
	Offset: 0x2F58
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function flattenroll()
{
	self endon(#"death");
	while(self.angles[2] < 0)
	{
		self.angles = (self.angles[0], self.angles[1], self.angles[2] + 2.5);
		wait(0.05);
	}
}

/*
	Name: leave
	Namespace: airsupport
	Checksum: 0x2E06FAA2
	Offset: 0x2FC8
	Size: 0x2A2
	Parameters: 1
	Flags: Linked
*/
function leave(duration)
{
	self unlink();
	self thread stoprotation(1);
	tries = 10;
	yaw = 0;
	while(tries > 0)
	{
		exitvector = (anglestoforward(self.angles + (0, yaw, 0))) * 20000;
		exitpoint = (self.origin[0] + exitvector[0], self.origin[1] + exitvector[1], self.origin[2] - 2500);
		exitpoint = self.origin + exitvector;
		nfz = crossesnoflyzone(self.origin, exitpoint);
		if(isdefined(nfz))
		{
			if(tries != 1)
			{
				if((tries % 2) == 1)
				{
					yaw = yaw * -1;
				}
				else
				{
					yaw = yaw + 10;
					yaw = yaw * -1;
				}
			}
			tries--;
		}
		else
		{
			tries = 0;
		}
	}
	self thread flattenyaw(self.angles[1] + yaw);
	if(self.angles[2] != 0)
	{
		self thread flattenroll();
	}
	if(isvehicle(self))
	{
		self setspeed((length(exitvector) / duration) / 17.6, 60);
		self setvehgoalpos(exitpoint, 0, 0);
	}
	else
	{
		self moveto(exitpoint, duration, 0, 0);
	}
	self notify(#"leaving");
}

/*
	Name: getrandomhelicopterstartorigin
	Namespace: airsupport
	Checksum: 0xDE1AB329
	Offset: 0x3278
	Size: 0x1E4
	Parameters: 0
	Flags: None
*/
function getrandomhelicopterstartorigin()
{
	dist = -1 * getdvarint("scr_supplydropIncomingDistance", 10000);
	pathrandomness = 100;
	direction = (0, randomintrange(-2, 3), 0);
	start_origin = anglestoforward(direction) * dist;
	start_origin = start_origin + ((randomfloat(2) - 1) * pathrandomness, (randomfloat(2) - 1) * pathrandomness, 0);
	/#
		if(getdvarint("", 0))
		{
			if(level.noflyzones.size)
			{
				index = randomintrange(0, level.noflyzones.size);
				delta = level.noflyzones[index].origin;
				delta = (delta[0] + randomint(10), delta[1] + randomint(10), 0);
				delta = vectornormalize(delta);
				start_origin = delta * dist;
			}
		}
	#/
	return start_origin;
}

/*
	Name: debug_no_fly_zones
	Namespace: airsupport
	Checksum: 0x83E51DD
	Offset: 0x3468
	Size: 0x96
	Parameters: 0
	Flags: None
*/
function debug_no_fly_zones()
{
	/#
		for(i = 0; i < level.noflyzones.size; i++)
		{
			debug_airsupport_cylinder(level.noflyzones[i].origin, level.noflyzones[i].radius, level.noflyzones[i].height, (1, 1, 1), undefined, 5000);
		}
	#/
}

/*
	Name: debug_plane_line
	Namespace: airsupport
	Checksum: 0x70A35416
	Offset: 0x3508
	Size: 0xC6
	Parameters: 4
	Flags: Linked
*/
function debug_plane_line(flytime, flyspeed, pathstart, pathend)
{
	thread debug_line(pathstart, pathend, (1, 1, 1));
	delta = vectornormalize(pathend - pathstart);
	for(i = 0; i < flytime; i++)
	{
		thread debug_star(pathstart + (vectorscale(delta, i * flyspeed)), (1, 0, 0));
	}
}

/*
	Name: debug_draw_bomb_explosion
	Namespace: airsupport
	Checksum: 0xBC2BE801
	Offset: 0x35D8
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function debug_draw_bomb_explosion(prevpos)
{
	self notify(#"draw_explosion");
	wait(0.05);
	self endon(#"draw_explosion");
	self waittill(#"projectile_impact", weapon, position);
	thread debug_line(prevpos, position, (0.5, 1, 0));
	thread debug_star(position, (1, 0, 0));
}

/*
	Name: debug_draw_bomb_path
	Namespace: airsupport
	Checksum: 0xA734E241
	Offset: 0x3678
	Size: 0x118
	Parameters: 3
	Flags: None
*/
function debug_draw_bomb_path(projectile, color, time)
{
	/#
		self endon(#"death");
		level.airsupport_debug = getdvarint("", 0);
		if(!isdefined(color))
		{
			color = (0.5, 1, 0);
		}
		if(isdefined(level.airsupport_debug) && level.airsupport_debug == 1)
		{
			prevpos = self.origin;
			while(isdefined(self.origin))
			{
				thread debug_line(prevpos, self.origin, color, time);
				prevpos = self.origin;
				if(isdefined(projectile) && projectile)
				{
					thread debug_draw_bomb_explosion(prevpos);
				}
				wait(0.2);
			}
		}
	#/
}

/*
	Name: debug_print3d_simple
	Namespace: airsupport
	Checksum: 0x6BA8BB3F
	Offset: 0x3798
	Size: 0xD4
	Parameters: 4
	Flags: Linked
*/
function debug_print3d_simple(message, ent, offset, frames)
{
	/#
		level.airsupport_debug = getdvarint("", 0);
		if(isdefined(level.airsupport_debug) && level.airsupport_debug == 1)
		{
			if(isdefined(frames))
			{
				thread draw_text(message, vectorscale((1, 1, 1), 0.8), ent, offset, frames);
			}
			else
			{
				thread draw_text(message, vectorscale((1, 1, 1), 0.8), ent, offset, 0);
			}
		}
	#/
}

/*
	Name: draw_text
	Namespace: airsupport
	Checksum: 0xE6EAC4A
	Offset: 0x3878
	Size: 0x11E
	Parameters: 5
	Flags: Linked
*/
function draw_text(msg, color, ent, offset, frames)
{
	/#
		if(frames == 0)
		{
			while(isdefined(ent) && isdefined(ent.origin))
			{
				print3d(ent.origin + offset, msg, color, 0.5, 4);
				wait(0.05);
			}
		}
		else
		{
			for(i = 0; i < frames; i++)
			{
				if(!isdefined(ent))
				{
					break;
				}
				print3d(ent.origin + offset, msg, color, 0.5, 4);
				wait(0.05);
			}
		}
	#/
}

/*
	Name: debug_print3d
	Namespace: airsupport
	Checksum: 0x4A7C9A94
	Offset: 0x39A0
	Size: 0x9C
	Parameters: 5
	Flags: Linked
*/
function debug_print3d(message, color, ent, origin_offset, frames)
{
	/#
		level.airsupport_debug = getdvarint("", 0);
		if(isdefined(level.airsupport_debug) && level.airsupport_debug == 1)
		{
			self thread draw_text(message, color, ent, origin_offset, frames);
		}
	#/
}

/*
	Name: debug_line
	Namespace: airsupport
	Checksum: 0xA606EB83
	Offset: 0x3A48
	Size: 0xEC
	Parameters: 5
	Flags: Linked
*/
function debug_line(from, to, color, time, depthtest)
{
	/#
		level.airsupport_debug = getdvarint("", 0);
		if(isdefined(level.airsupport_debug) && level.airsupport_debug == 1)
		{
			if(distancesquared(from, to) < 0.01)
			{
				return;
			}
			if(!isdefined(time))
			{
				time = 1000;
			}
			if(!isdefined(depthtest))
			{
				depthtest = 1;
			}
			line(from, to, color, 1, depthtest, time);
		}
	#/
}

/*
	Name: debug_star
	Namespace: airsupport
	Checksum: 0x13E48A71
	Offset: 0x3B40
	Size: 0xAC
	Parameters: 3
	Flags: Linked
*/
function debug_star(origin, color, time)
{
	/#
		level.airsupport_debug = getdvarint("", 0);
		if(isdefined(level.airsupport_debug) && level.airsupport_debug == 1)
		{
			if(!isdefined(time))
			{
				time = 1000;
			}
			if(!isdefined(color))
			{
				color = (1, 1, 1);
			}
			debugstar(origin, time, color);
		}
	#/
}

/*
	Name: debug_circle
	Namespace: airsupport
	Checksum: 0xC97D38C7
	Offset: 0x3BF8
	Size: 0xBC
	Parameters: 4
	Flags: None
*/
function debug_circle(origin, radius, color, time)
{
	/#
		level.airsupport_debug = getdvarint("", 0);
		if(isdefined(level.airsupport_debug) && level.airsupport_debug == 1)
		{
			if(!isdefined(time))
			{
				time = 1000;
			}
			if(!isdefined(color))
			{
				color = (1, 1, 1);
			}
			circle(origin, radius, color, 1, 1, time);
		}
	#/
}

/*
	Name: debug_sphere
	Namespace: airsupport
	Checksum: 0x1FE407C3
	Offset: 0x3CC0
	Size: 0x104
	Parameters: 5
	Flags: Linked
*/
function debug_sphere(origin, radius, color, alpha, time)
{
	/#
		level.airsupport_debug = getdvarint("", 0);
		if(isdefined(level.airsupport_debug) && level.airsupport_debug == 1)
		{
			if(!isdefined(time))
			{
				time = 1000;
			}
			if(!isdefined(color))
			{
				color = (1, 1, 1);
			}
			sides = int(10 * (1 + (int(radius / 100))));
			sphere(origin, radius, color, alpha, 1, sides, time);
		}
	#/
}

/*
	Name: debug_airsupport_cylinder
	Namespace: airsupport
	Checksum: 0xB12ADA07
	Offset: 0x3DD0
	Size: 0xA4
	Parameters: 6
	Flags: Linked
*/
function debug_airsupport_cylinder(origin, radius, height, color, mustrenderheight, time)
{
	/#
		level.airsupport_debug = getdvarint("", 0);
		if(isdefined(level.airsupport_debug) && level.airsupport_debug == 1)
		{
			debug_cylinder(origin, radius, height, color, mustrenderheight, time);
		}
	#/
}

/*
	Name: debug_cylinder
	Namespace: airsupport
	Checksum: 0xC00B6E9C
	Offset: 0x3E80
	Size: 0x14C
	Parameters: 6
	Flags: Linked
*/
function debug_cylinder(origin, radius, height, color, mustrenderheight, time)
{
	/#
		subdivision = 600;
		if(!isdefined(time))
		{
			time = 1000;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		count = height / subdivision;
		for(i = 0; i < count; i++)
		{
			point = origin + (0, 0, i * subdivision);
			circle(point, radius, color, 1, 1, time);
		}
		if(isdefined(mustrenderheight))
		{
			point = origin + (0, 0, mustrenderheight);
			circle(point, radius, color, 1, 1, time);
		}
	#/
}

/*
	Name: getpointonline
	Namespace: airsupport
	Checksum: 0x6850499E
	Offset: 0x3FD8
	Size: 0xA2
	Parameters: 3
	Flags: None
*/
function getpointonline(startpoint, endpoint, ratio)
{
	nextpoint = (startpoint[0] + ((endpoint[0] - startpoint[0]) * ratio), startpoint[1] + ((endpoint[1] - startpoint[1]) * ratio), startpoint[2] + ((endpoint[2] - startpoint[2]) * ratio));
	return nextpoint;
}

/*
	Name: cantargetplayerwithspecialty
	Namespace: airsupport
	Checksum: 0x81B80E91
	Offset: 0x4088
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function cantargetplayerwithspecialty()
{
	if(self hasperk("specialty_nottargetedbyairsupport") || (isdefined(self.specialty_nottargetedbyairsupport) && self.specialty_nottargetedbyairsupport))
	{
		if(!isdefined(self.nottargettedai_underminspeedtimer) || self.nottargettedai_underminspeedtimer < getdvarint("perk_nottargetedbyai_graceperiod"))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: monitorspeed
	Namespace: airsupport
	Checksum: 0xE9D6DFA2
	Offset: 0x4108
	Size: 0x19E
	Parameters: 1
	Flags: Linked
*/
function monitorspeed(spawnprotectiontime)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(self hasperk("specialty_nottargetedbyairsupport") == 0)
	{
		return;
	}
	getdvarstring("perk_nottargetted_graceperiod");
	graceperiod = getdvarint("perk_nottargetedbyai_graceperiod");
	minspeed = getdvarint("perk_nottargetedbyai_min_speed");
	minspeedsq = minspeed * minspeed;
	waitperiod = 0.25;
	waitperiodmilliseconds = waitperiod * 1000;
	if(minspeedsq == 0)
	{
		return;
	}
	self.nottargettedai_underminspeedtimer = 0;
	if(isdefined(spawnprotectiontime))
	{
		wait(spawnprotectiontime);
	}
	while(true)
	{
		velocity = self getvelocity();
		speedsq = lengthsquared(velocity);
		if(speedsq < minspeedsq)
		{
			self.nottargettedai_underminspeedtimer = self.nottargettedai_underminspeedtimer + waitperiodmilliseconds;
		}
		else
		{
			self.nottargettedai_underminspeedtimer = 0;
		}
		wait(waitperiod);
	}
}

/*
	Name: clearmonitoredspeed
	Namespace: airsupport
	Checksum: 0xF9C5426C
	Offset: 0x42B0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function clearmonitoredspeed()
{
	if(isdefined(self.nottargettedai_underminspeedtimer))
	{
		self.nottargettedai_underminspeedtimer = 0;
	}
}

