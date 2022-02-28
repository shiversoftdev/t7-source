// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_callbacks;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;

#namespace spawnlogic;

/*
	Name: __init__sytem__
	Namespace: spawnlogic
	Checksum: 0x8A8088D7
	Offset: 0x348
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("spawnlogic", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: spawnlogic
	Checksum: 0x9FA329BB
	Offset: 0x388
	Size: 0x24C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	function_4489f2c9();
	foreach(spawn_point in get_all_spawn_points())
	{
		if(isdefined(spawn_point.scriptgroup_playerspawns_enable))
		{
			foreach(trig in getentarray(spawn_point.scriptgroup_playerspawns_enable, "scriptgroup_playerspawns_enable"))
			{
				spawn_point thread _spawn_point_enable(trig);
			}
		}
		if(isdefined(spawn_point.scriptgroup_playerspawns_disable))
		{
			foreach(trig in getentarray(spawn_point.scriptgroup_playerspawns_disable, "scriptgroup_playerspawns_disable"))
			{
				spawn_point thread _spawn_point_disable(trig);
			}
		}
	}
	level thread update_spawn_points();
	callback::on_start_gametype(&init);
	/#
		level thread debug_spawn_points();
	#/
}

/*
	Name: function_4489f2c9
	Namespace: spawnlogic
	Checksum: 0x3EF5FF22
	Offset: 0x5E0
	Size: 0x13A
	Parameters: 0
	Flags: Linked
*/
function function_4489f2c9()
{
	foreach(spawn_point in get_all_spawn_points())
	{
		if(isdefined(spawn_point.linkto))
		{
			e_linkto = getent(spawn_point.linkto, "linkname");
			spawn_point function_98b48204(e_linkto);
			continue;
		}
		if(isdefined(spawn_point.script_linkto))
		{
			e_linkto = getent(spawn_point.script_linkto, "targetname");
			spawn_point function_98b48204(e_linkto);
		}
	}
}

/*
	Name: function_98b48204
	Namespace: spawnlogic
	Checksum: 0xEBFFD5E7
	Offset: 0x728
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function function_98b48204(e_linkto)
{
	var_14497229 = spawn("script_origin", self.origin);
	var_14497229.angles = self.angles;
	var_14497229.targetname = self.targetname;
	var_14497229.script_objective = self.script_objective;
	var_14497229.scriptgroup_playerspawns_disable = self.scriptgroup_playerspawns_disable;
	var_14497229.scriptgroup_playerspawns_enable = self.scriptgroup_playerspawns_enable;
	if(isdefined(e_linkto))
	{
		var_14497229 linkto(e_linkto);
	}
	self struct::delete();
}

/*
	Name: _spawn_point_enable
	Namespace: spawnlogic
	Checksum: 0xB29B001B
	Offset: 0x810
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function _spawn_point_enable(trig)
{
	trig endon(#"death");
	self.disabled = 1;
	while(true)
	{
		trig waittill(#"trigger");
		function_82c857e9(0);
	}
}

/*
	Name: _spawn_point_disable
	Namespace: spawnlogic
	Checksum: 0xD515BD34
	Offset: 0x868
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function _spawn_point_disable(trig)
{
	trig endon(#"death");
	while(true)
	{
		trig waittill(#"trigger");
		function_82c857e9(1);
	}
}

/*
	Name: function_82c857e9
	Namespace: spawnlogic
	Checksum: 0xE637A5D0
	Offset: 0x8B8
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function function_82c857e9(b_enabled)
{
	var_1b30c0b0 = isdefined(b_enabled) && (b_enabled ? 1 : undefined);
	if(self.disabled !== var_1b30c0b0)
	{
		level flagsys::set("spawnpoints_dirty");
		self.disabled = var_1b30c0b0;
	}
}

/*
	Name: update_spawn_points
	Namespace: spawnlogic
	Checksum: 0xFF193C80
	Offset: 0x930
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function update_spawn_points()
{
	while(true)
	{
		if(level flagsys::get("spawnpoints_dirty"))
		{
			foreach(team in level.teams)
			{
				rebuild_spawn_points(team);
			}
			level.unified_spawn_points = undefined;
			spawning::updateallspawnpoints();
			level flagsys::clear("spawnpoints_dirty");
		}
		wait(0.05);
	}
}

/*
	Name: get_all_spawn_points
	Namespace: spawnlogic
	Checksum: 0x6331C46B
	Offset: 0xA38
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function get_all_spawn_points(b_include_disabled)
{
	a_spawn_points = arraycombine(get_spawnpoint_array("cp_coop_spawn", b_include_disabled), get_spawnpoint_array("cp_coop_respawn", b_include_disabled), 0, 0);
	return a_spawn_points;
}

/*
	Name: debug_spawn_points
	Namespace: spawnlogic
	Checksum: 0x300AF62A
	Offset: 0xAA8
	Size: 0x2B0
	Parameters: 0
	Flags: Linked
*/
function debug_spawn_points()
{
	/#
		if(getdvarstring("") == "")
		{
			setdvar("", 0);
			setdvar("", 0);
		}
		while(true)
		{
			b_debug = getdvarint("", 0);
			if(b_debug)
			{
				foreach(spawn_point in get_all_spawn_points(1))
				{
					color = (1, 0, 1);
					if(spawn_point.targetname === "")
					{
						color = (0, 0, 1);
					}
					if(isdefined(spawn_point.disabled) && spawn_point.disabled || (isdefined(spawn_point.different_skipto) && spawn_point.different_skipto))
					{
						color = (1, 0, 0);
					}
					print3d(spawn_point.origin + (vectorscale((0, 0, -1), 35)), spawn_point.targetname, color, 1, 0.3, 1);
					print3d(spawn_point.origin + (vectorscale((0, 0, -1), 43)), (isdefined(spawn_point.script_objective) ? spawn_point.script_objective : ""), color, 1, 0.3, 1);
					box(spawn_point.origin, (-16, -16, -36), (16, 16, 36), 0, color, 0, 1);
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: init
	Namespace: spawnlogic
	Checksum: 0x3091C87F
	Offset: 0xD60
	Size: 0x3BC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	/#
		if(getdvarstring("") == "")
		{
			setdvar("", 0);
		}
		level.storespawndata = getdvarint("");
		if(getdvarstring("") == "")
		{
			setdvar("", 0);
		}
		if(getdvarstring("") == "")
		{
			setdvar("", 0.25);
		}
		thread loop_bot_spawns();
	#/
	level.spawnlogic_deaths = [];
	level.spawnlogic_spawnkills = [];
	level.players = [];
	level.grenades = [];
	level.pipebombs = [];
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	level.spawnminsmaxsprimed = 0;
	if(isdefined(level.safespawns))
	{
		for(i = 0; i < level.safespawns.size; i++)
		{
			level.safespawns[i] spawnpoint_init();
		}
	}
	if(getdvarstring("scr_spawn_enemyavoiddist") == "")
	{
		setdvar("scr_spawn_enemyavoiddist", "800");
	}
	if(getdvarstring("scr_spawn_enemyavoidweight") == "")
	{
		setdvar("scr_spawn_enemyavoidweight", "0");
	}
	/#
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarint("") > 0)
		{
			thread show_deaths_debug();
			thread update_death_info_debug();
			thread profile_debug();
		}
		if(level.storespawndata)
		{
			thread allow_spawn_data_reading();
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		thread watch_spawn_profile();
		thread spawn_graph_check();
	#/
}

/*
	Name: add_spawn_points_internal
	Namespace: spawnlogic
	Checksum: 0x5B22B67B
	Offset: 0x1128
	Size: 0x1EA
	Parameters: 2
	Flags: Linked
*/
function add_spawn_points_internal(team, spawnpoints)
{
	oldspawnpoints = [];
	if(level.teamspawnpoints[team].size)
	{
		oldspawnpoints = level.teamspawnpoints[team];
	}
	if(isdefined(level.filter_spawnpoints))
	{
		spawnpoints = [[level.filter_spawnpoints]](spawnpoints);
	}
	level.teamspawnpoints[team] = spawnpoints;
	if(!isdefined(level.spawnpoints))
	{
		level.spawnpoints = [];
	}
	for(index = 0; index < level.teamspawnpoints[team].size; index++)
	{
		spawnpoint = level.teamspawnpoints[team][index];
		if(!isdefined(spawnpoint.inited))
		{
			spawnpoint spawnpoint_init();
			level.spawnpoints[level.spawnpoints.size] = spawnpoint;
		}
	}
	for(index = 0; index < oldspawnpoints.size; index++)
	{
		origin = oldspawnpoints[index].origin;
		level.spawnmins = math::expand_mins(level.spawnmins, origin);
		level.spawnmaxs = math::expand_maxs(level.spawnmaxs, origin);
		level.teamspawnpoints[team][level.teamspawnpoints[team].size] = oldspawnpoints[index];
	}
}

/*
	Name: clear_spawn_points
	Namespace: spawnlogic
	Checksum: 0xAFCDA111
	Offset: 0x1320
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function clear_spawn_points()
{
	foreach(team in level.teams)
	{
		level.teamspawnpoints[team] = [];
	}
	level.spawnpoints = [];
	level.unified_spawn_points = undefined;
}

/*
	Name: add_spawn_points
	Namespace: spawnlogic
	Checksum: 0x67D58D2F
	Offset: 0x13C8
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function add_spawn_points(team, spawnpointname)
{
	add_spawn_point_classname(spawnpointname);
	add_spawn_point_team_classname(team, spawnpointname);
	add_spawn_points_internal(team, get_spawnpoint_array(spawnpointname));
	if(!level.teamspawnpoints[team].size)
	{
		/#
			if(!isdefined(level.var_a6f85f47))
			{
				/#
					assert(level.teamspawnpoints[team].size, ("" + spawnpointname) + "");
				#/
			}
		#/
		wait(1);
		return;
	}
}

/*
	Name: rebuild_spawn_points
	Namespace: spawnlogic
	Checksum: 0x66A6EB92
	Offset: 0x14A8
	Size: 0x86
	Parameters: 1
	Flags: Linked
*/
function rebuild_spawn_points(team)
{
	level.teamspawnpoints[team] = [];
	for(index = 0; index < level.spawn_point_team_class_names[team].size; index++)
	{
		add_spawn_points_internal(team, get_spawnpoint_array(level.spawn_point_team_class_names[team][index]));
	}
}

/*
	Name: place_spawn_points
	Namespace: spawnlogic
	Checksum: 0x3DD5C882
	Offset: 0x1538
	Size: 0x138
	Parameters: 1
	Flags: None
*/
function place_spawn_points(spawnpointname)
{
	add_spawn_point_classname(spawnpointname);
	spawnpoints = get_spawnpoint_array(spawnpointname);
	/#
		if(!isdefined(level.extraspawnpointsused))
		{
			level.extraspawnpointsused = [];
		}
	#/
	if(!spawnpoints.size)
	{
		/#
			println(("" + spawnpointname) + "");
		#/
		callback::abort_level();
		wait(1);
		return;
	}
	for(index = 0; index < spawnpoints.size; index++)
	{
		spawnpoints[index] spawnpoint_init();
		/#
			spawnpoints[index].fakeclassname = spawnpointname;
			level.extraspawnpointsused[level.extraspawnpointsused.size] = spawnpoints[index];
		#/
	}
}

/*
	Name: drop_spawn_points
	Namespace: spawnlogic
	Checksum: 0xEC46E7F9
	Offset: 0x1678
	Size: 0xAE
	Parameters: 1
	Flags: None
*/
function drop_spawn_points(spawnpointname)
{
	spawnpoints = get_spawnpoint_array(spawnpointname);
	if(!spawnpoints.size)
	{
		/#
			println(("" + spawnpointname) + "");
		#/
		return;
	}
	for(index = 0; index < spawnpoints.size; index++)
	{
		spawnpoints[index] place_spawn();
	}
}

/*
	Name: add_spawn_point_classname
	Namespace: spawnlogic
	Checksum: 0x908DFE4
	Offset: 0x1730
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function add_spawn_point_classname(spawnpointclassname)
{
	if(!isdefined(level.spawn_point_class_names))
	{
		level.spawn_point_class_names = [];
	}
	array::add(level.spawn_point_class_names, spawnpointclassname, 0);
}

/*
	Name: add_spawn_point_team_classname
	Namespace: spawnlogic
	Checksum: 0xFA8E2E9F
	Offset: 0x1780
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function add_spawn_point_team_classname(team, spawnpointclassname)
{
	array::add(level.spawn_point_team_class_names[team], spawnpointclassname, 0);
}

/*
	Name: get_spawnpoint_array
	Namespace: spawnlogic
	Checksum: 0x7B09A86B
	Offset: 0x17C8
	Size: 0x21A
	Parameters: 2
	Flags: Linked
*/
function get_spawnpoint_array(classname, b_include_disabled = 0)
{
	a_all_spawn_points = arraycombine(struct::get_array(classname, "targetname"), getentarray(classname, "targetname"), 0, 0);
	a_spawn_points = [];
	if(!b_include_disabled)
	{
		foreach(spawn_point in a_all_spawn_points)
		{
			if(!(isdefined(spawn_point.disabled) && spawn_point.disabled))
			{
				if(!isdefined(a_spawn_points))
				{
					a_spawn_points = [];
				}
				else if(!isarray(a_spawn_points))
				{
					a_spawn_points = array(a_spawn_points);
				}
				a_spawn_points[a_spawn_points.size] = spawn_point;
			}
		}
	}
	else
	{
		a_spawn_points = a_all_spawn_points;
	}
	if(!isdefined(level.extraspawnpoints) || !isdefined(level.extraspawnpoints[classname]))
	{
		return a_spawn_points;
	}
	for(i = 0; i < level.extraspawnpoints[classname].size; i++)
	{
		a_spawn_points[a_spawn_points.size] = level.extraspawnpoints[classname][i];
	}
	return a_spawn_points;
}

/*
	Name: spawnpoint_init
	Namespace: spawnlogic
	Checksum: 0x50B264B5
	Offset: 0x19F0
	Size: 0x160
	Parameters: 0
	Flags: Linked
*/
function spawnpoint_init()
{
	spawnpoint = self;
	origin = spawnpoint.origin;
	if(!level.spawnminsmaxsprimed)
	{
		level.spawnmins = origin;
		level.spawnmaxs = origin;
		level.spawnminsmaxsprimed = 1;
	}
	else
	{
		level.spawnmins = math::expand_mins(level.spawnmins, origin);
		level.spawnmaxs = math::expand_maxs(level.spawnmaxs, origin);
	}
	spawnpoint place_spawn();
	if(!isdefined(spawnpoint.angles))
	{
		spawnpoint.angles = (0, 0, 0);
	}
	spawnpoint.forward = anglestoforward(spawnpoint.angles);
	spawnpoint.sighttracepoint = spawnpoint.origin + vectorscale((0, 0, 1), 50);
	spawnpoint.inited = 1;
}

/*
	Name: get_team_spawnpoints
	Namespace: spawnlogic
	Checksum: 0xC09F1E89
	Offset: 0x1B58
	Size: 0x18
	Parameters: 1
	Flags: Linked
*/
function get_team_spawnpoints(team)
{
	return level.teamspawnpoints[team];
}

/*
	Name: get_spawnpoint_final
	Namespace: spawnlogic
	Checksum: 0xAD6892B3
	Offset: 0x1B78
	Size: 0x240
	Parameters: 2
	Flags: Linked
*/
function get_spawnpoint_final(spawnpoints, useweights)
{
	bestspawnpoint = undefined;
	if(!isdefined(spawnpoints) || spawnpoints.size == 0)
	{
		return undefined;
	}
	if(!isdefined(useweights))
	{
		useweights = 1;
	}
	if(useweights)
	{
		bestspawnpoint = get_best_weighted_spawnpoint(spawnpoints);
		thread spawn_weight_debug(spawnpoints);
	}
	else
	{
		for(i = 0; i < spawnpoints.size; i++)
		{
			if(isdefined(self.lastspawnpoint) && self.lastspawnpoint == spawnpoints[i])
			{
				continue;
			}
			if(positionwouldtelefrag(spawnpoints[i].origin))
			{
				continue;
			}
			bestspawnpoint = spawnpoints[i];
			break;
		}
		if(!isdefined(bestspawnpoint))
		{
			if(isdefined(self.lastspawnpoint) && !positionwouldtelefrag(self.lastspawnpoint.origin))
			{
				for(i = 0; i < spawnpoints.size; i++)
				{
					if(spawnpoints[i] == self.lastspawnpoint)
					{
						bestspawnpoint = spawnpoints[i];
						break;
					}
				}
			}
		}
	}
	if(!isdefined(bestspawnpoint))
	{
		if(useweights)
		{
			bestspawnpoint = spawnpoints[randomint(spawnpoints.size)];
		}
		else
		{
			bestspawnpoint = spawnpoints[0];
		}
	}
	self finalize_spawnpoint_choice(bestspawnpoint);
	/#
		self store_spawn_data(spawnpoints, useweights, bestspawnpoint);
	#/
	return bestspawnpoint;
}

/*
	Name: finalize_spawnpoint_choice
	Namespace: spawnlogic
	Checksum: 0x8EE68E39
	Offset: 0x1DC0
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function finalize_spawnpoint_choice(spawnpoint)
{
	time = gettime();
	self.lastspawnpoint = spawnpoint;
	self.lastspawntime = time;
	spawnpoint.lastspawnedplayer = self;
	spawnpoint.lastspawntime = time;
}

/*
	Name: get_best_weighted_spawnpoint
	Namespace: spawnlogic
	Checksum: 0x3B7B2E63
	Offset: 0x1E20
	Size: 0x2B6
	Parameters: 1
	Flags: Linked
*/
function get_best_weighted_spawnpoint(spawnpoints)
{
	maxsighttracedspawnpoints = 3;
	for(try = 0; try <= maxsighttracedspawnpoints; try++)
	{
		bestspawnpoints = [];
		bestweight = undefined;
		bestspawnpoint = undefined;
		for(i = 0; i < spawnpoints.size; i++)
		{
			if(!isdefined(bestweight) || spawnpoints[i].weight > bestweight)
			{
				if(positionwouldtelefrag(spawnpoints[i].origin))
				{
					continue;
				}
				bestspawnpoints = [];
				bestspawnpoints[0] = spawnpoints[i];
				bestweight = spawnpoints[i].weight;
				continue;
			}
			if(spawnpoints[i].weight == bestweight)
			{
				if(positionwouldtelefrag(spawnpoints[i].origin))
				{
					continue;
				}
				bestspawnpoints[bestspawnpoints.size] = spawnpoints[i];
			}
		}
		if(bestspawnpoints.size == 0)
		{
			return undefined;
		}
		bestspawnpoint = bestspawnpoints[randomint(bestspawnpoints.size)];
		if(try == maxsighttracedspawnpoints)
		{
			return bestspawnpoint;
		}
		if(isdefined(bestspawnpoint.lastsighttracetime) && bestspawnpoint.lastsighttracetime == gettime())
		{
			return bestspawnpoint;
		}
		if(!last_minute_sight_traces(bestspawnpoint))
		{
			return bestspawnpoint;
		}
		penalty = get_los_penalty();
		/#
			if(level.storespawndata || level.debugspawning)
			{
				bestspawnpoint.spawndata[bestspawnpoint.spawndata.size] = "" + penalty;
			}
		#/
		bestspawnpoint.weight = bestspawnpoint.weight - penalty;
		bestspawnpoint.lastsighttracetime = gettime();
	}
}

/*
	Name: check_bad
	Namespace: spawnlogic
	Checksum: 0x14975231
	Offset: 0x20E0
	Size: 0x156
	Parameters: 1
	Flags: Linked
*/
function check_bad(spawnpoint)
{
	/#
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if(!isalive(player) || player.sessionstate != "")
			{
				continue;
			}
			if(level.teambased && player.team == self.team)
			{
				continue;
			}
			losexists = bullettracepassed(player.origin + vectorscale((0, 0, 1), 50), spawnpoint.sighttracepoint, 0, undefined);
			if(losexists)
			{
				thread bad_spawn_line(spawnpoint.sighttracepoint, player.origin + vectorscale((0, 0, 1), 50), self.name, player.name);
			}
		}
	#/
}

/*
	Name: bad_spawn_line
	Namespace: spawnlogic
	Checksum: 0x3C3150C6
	Offset: 0x2240
	Size: 0xE6
	Parameters: 4
	Flags: Linked
*/
function bad_spawn_line(start, end, name1, name2)
{
	/#
		dist = distance(start, end);
		for(i = 0; i < 200; i++)
		{
			line(start, end, (1, 0, 0));
			print3d(start, (("" + name1) + "") + dist);
			print3d(end, name2);
			wait(0.05);
		}
	#/
}

/*
	Name: store_spawn_data
	Namespace: spawnlogic
	Checksum: 0x6A7E6551
	Offset: 0x2330
	Size: 0x88C
	Parameters: 3
	Flags: Linked
*/
function store_spawn_data(spawnpoints, useweights, bestspawnpoint)
{
	/#
		if(!isdefined(level.storespawndata) || !level.storespawndata)
		{
			return;
		}
		level.storespawndata = getdvarint("");
		if(!level.storespawndata)
		{
			return;
		}
		if(!isdefined(level.spawnid))
		{
			level.spawngameid = randomint(100);
			level.spawnid = 0;
		}
		if(bestspawnpoint.targetname == "")
		{
			return;
		}
		level.spawnid++;
		file = openfile("", "");
		fprintfields(file, (((((level.spawngameid + "") + level.spawnid) + "") + spawnpoints.size) + "") + self.name);
		for(i = 0; i < spawnpoints.size; i++)
		{
			str = vec_to_str(spawnpoints[i].origin) + "";
			if(spawnpoints[i] == bestspawnpoint)
			{
				str = str + "";
			}
			else
			{
				str = str + "";
			}
			if(!useweights)
			{
				str = str + "";
			}
			else
			{
				str = str + (spawnpoints[i].weight + "");
			}
			if(!isdefined(spawnpoints[i].spawndata))
			{
				spawnpoints[i].spawndata = [];
			}
			if(!isdefined(spawnpoints[i].sightchecks))
			{
				spawnpoints[i].sightchecks = [];
			}
			str = str + (spawnpoints[i].spawndata.size + "");
			for(j = 0; j < spawnpoints[i].spawndata.size; j++)
			{
				str = str + (spawnpoints[i].spawndata[j] + "");
			}
			str = str + (spawnpoints[i].sightchecks.size + "");
			for(j = 0; j < spawnpoints[i].sightchecks.size; j++)
			{
				str = str + ((spawnpoints[i].sightchecks[j].penalty + "") + vec_to_str(spawnpoints[i].origin) + "");
			}
			fprintfields(file, str);
		}
		obj = spawnstruct();
		get_all_allied_and_enemy_players(obj);
		numallies = 0;
		numenemies = 0;
		str = "";
		for(i = 0; i < obj.allies.size; i++)
		{
			if(obj.allies[i] == self)
			{
				continue;
			}
			numallies++;
			str = str + (vec_to_str(obj.allies[i].origin) + "");
		}
		for(i = 0; i < obj.enemies.size; i++)
		{
			numenemies++;
			str = str + (vec_to_str(obj.enemies[i].origin) + "");
		}
		str = (((numallies + "") + numenemies) + "") + str;
		fprintfields(file, str);
		otherdata = [];
		if(isdefined(level.bombguy))
		{
			index = otherdata.size;
			otherdata[index] = spawnstruct();
			otherdata[index].origin = level.bombguy.origin + vectorscale((0, 0, 1), 20);
			otherdata[index].text = "";
		}
		else if(isdefined(level.bombpos))
		{
			index = otherdata.size;
			otherdata[index] = spawnstruct();
			otherdata[index].origin = level.bombpos;
			otherdata[index].text = "";
		}
		if(isdefined(level.flags))
		{
			for(i = 0; i < level.flags.size; i++)
			{
				index = otherdata.size;
				otherdata[index] = spawnstruct();
				otherdata[index].origin = level.flags[i].origin;
				otherdata[index].text = level.flags[i].useobj gameobjects::get_owner_team() + "";
			}
		}
		str = otherdata.size + "";
		for(i = 0; i < otherdata.size; i++)
		{
			str = str + (((vec_to_str(otherdata[i].origin) + "") + otherdata[i].text) + "");
		}
		fprintfields(file, str);
		closefile(file);
		thisspawnid = (level.spawngameid + "") + level.spawnid;
		self.thisspawnid = thisspawnid;
	#/
}

/*
	Name: read_spawn_data
	Namespace: spawnlogic
	Checksum: 0x11E58333
	Offset: 0x2BC8
	Size: 0xB34
	Parameters: 2
	Flags: Linked
*/
function read_spawn_data(desiredid, relativepos)
{
	/#
		file = openfile("", "");
		if(file < 0)
		{
			return;
		}
		oldspawndata = level.curspawndata;
		level.curspawndata = undefined;
		prev = undefined;
		prevthisplayer = undefined;
		lookingfornextthisplayer = 0;
		lookingfornext = 0;
		if(isdefined(relativepos) && !isdefined(oldspawndata))
		{
			return;
		}
		while(true)
		{
			if(freadln(file) <= 0)
			{
				break;
			}
			data = spawnstruct();
			data.id = fgetarg(file, 0);
			numspawns = int(fgetarg(file, 1));
			if(numspawns > 256)
			{
				break;
			}
			data.playername = fgetarg(file, 2);
			data.spawnpoints = [];
			data.friends = [];
			data.enemies = [];
			data.otherdata = [];
			for(i = 0; i < numspawns; i++)
			{
				if(freadln(file) <= 0)
				{
					break;
				}
				spawnpoint = spawnstruct();
				spawnpoint.origin = str_to_vec(fgetarg(file, 0));
				spawnpoint.winner = int(fgetarg(file, 1));
				spawnpoint.weight = int(fgetarg(file, 2));
				spawnpoint.data = [];
				spawnpoint.sightchecks = [];
				if(i == 0)
				{
					data.minweight = spawnpoint.weight;
					data.maxweight = spawnpoint.weight;
				}
				else
				{
					if(spawnpoint.weight < data.minweight)
					{
						data.minweight = spawnpoint.weight;
					}
					if(spawnpoint.weight > data.maxweight)
					{
						data.maxweight = spawnpoint.weight;
					}
				}
				argnum = 4;
				numdata = int(fgetarg(file, 3));
				if(numdata > 256)
				{
					break;
				}
				for(j = 0; j < numdata; j++)
				{
					spawnpoint.data[spawnpoint.data.size] = fgetarg(file, argnum);
					argnum++;
				}
				numsightchecks = int(fgetarg(file, argnum));
				argnum++;
				if(numsightchecks > 256)
				{
					break;
				}
				for(j = 0; j < numsightchecks; j++)
				{
					index = spawnpoint.sightchecks.size;
					spawnpoint.sightchecks[index] = spawnstruct();
					spawnpoint.sightchecks[index].penalty = int(fgetarg(file, argnum));
					argnum++;
					spawnpoint.sightchecks[index].origin = str_to_vec(fgetarg(file, argnum));
					argnum++;
				}
				data.spawnpoints[data.spawnpoints.size] = spawnpoint;
			}
			if(!isdefined(data.minweight))
			{
				data.minweight = -1;
				data.maxweight = 0;
			}
			if(data.minweight == data.maxweight)
			{
				data.minweight = data.minweight - 1;
			}
			if(freadln(file) <= 0)
			{
				break;
			}
			numfriends = int(fgetarg(file, 0));
			numenemies = int(fgetarg(file, 1));
			if(numfriends > 32 || numenemies > 32)
			{
				break;
			}
			argnum = 2;
			for(i = 0; i < numfriends; i++)
			{
				data.friends[data.friends.size] = str_to_vec(fgetarg(file, argnum));
				argnum++;
			}
			for(i = 0; i < numenemies; i++)
			{
				data.enemies[data.enemies.size] = str_to_vec(fgetarg(file, argnum));
				argnum++;
			}
			if(freadln(file) <= 0)
			{
				break;
			}
			numotherdata = int(fgetarg(file, 0));
			argnum = 1;
			for(i = 0; i < numotherdata; i++)
			{
				otherdata = spawnstruct();
				otherdata.origin = str_to_vec(fgetarg(file, argnum));
				argnum++;
				otherdata.text = fgetarg(file, argnum);
				argnum++;
				data.otherdata[data.otherdata.size] = otherdata;
			}
			if(isdefined(relativepos))
			{
				if(relativepos == "")
				{
					if(data.id == oldspawndata.id)
					{
						level.curspawndata = prevthisplayer;
						break;
					}
				}
				else
				{
					if(relativepos == "")
					{
						if(data.id == oldspawndata.id)
						{
							level.curspawndata = prev;
							break;
						}
					}
					else
					{
						if(relativepos == "")
						{
							if(lookingfornextthisplayer)
							{
								level.curspawndata = data;
								break;
							}
							else if(data.id == oldspawndata.id)
							{
								lookingfornextthisplayer = 1;
							}
						}
						else if(relativepos == "")
						{
							if(lookingfornext)
							{
								level.curspawndata = data;
								break;
							}
							else if(data.id == oldspawndata.id)
							{
								lookingfornext = 1;
							}
						}
					}
				}
			}
			else if(data.id == desiredid)
			{
				level.curspawndata = data;
				break;
			}
			prev = data;
			if(isdefined(oldspawndata) && data.playername == oldspawndata.playername)
			{
				prevthisplayer = data;
			}
		}
		closefile(file);
	#/
}

/*
	Name: draw_spawn_data
	Namespace: spawnlogic
	Checksum: 0xA688EC78
	Offset: 0x3708
	Size: 0x474
	Parameters: 0
	Flags: Linked
*/
function draw_spawn_data()
{
	/#
		level notify(#"drawing_spawn_data");
		level endon(#"drawing_spawn_data");
		textoffset = vectorscale((0, 0, -1), 12);
		while(true)
		{
			if(!isdefined(level.curspawndata))
			{
				wait(0.5);
				continue;
			}
			for(i = 0; i < level.curspawndata.friends.size; i++)
			{
				print3d(level.curspawndata.friends[i], "", (0.5, 1, 0.5), 1, 5);
			}
			for(i = 0; i < level.curspawndata.enemies.size; i++)
			{
				print3d(level.curspawndata.enemies[i], "", (1, 0.5, 0.5), 1, 5);
			}
			for(i = 0; i < level.curspawndata.otherdata.size; i++)
			{
				print3d(level.curspawndata.otherdata[i].origin, level.curspawndata.otherdata[i].text, (0.5, 0.75, 1), 1, 2);
			}
			for(i = 0; i < level.curspawndata.spawnpoints.size; i++)
			{
				sp = level.curspawndata.spawnpoints[i];
				orig = sp.sighttracepoint;
				if(sp.winner)
				{
					print3d(orig, level.curspawndata.playername + "", (0.5, 0.5, 1), 1, 2);
					orig = orig + textoffset;
				}
				amnt = (sp.weight - level.curspawndata.minweight) / (level.curspawndata.maxweight - level.curspawndata.minweight);
				print3d(orig, "" + sp.weight, (1 - amnt, amnt, 0.5));
				orig = orig + textoffset;
				for(j = 0; j < sp.data.size; j++)
				{
					print3d(orig, sp.data[j], (1, 1, 1));
					orig = orig + textoffset;
				}
				for(j = 0; j < sp.sightchecks.size; j++)
				{
					print3d(orig, "" + sp.sightchecks[j].penalty, (1, 0.5, 0.5));
					orig = orig + textoffset;
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: vec_to_str
	Namespace: spawnlogic
	Checksum: 0x877CABC6
	Offset: 0x3B88
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function vec_to_str(vec)
{
	/#
		return ((int(vec[0]) + "") + int(vec[1]) + "") + int(vec[2]);
	#/
}

/*
	Name: str_to_vec
	Namespace: spawnlogic
	Checksum: 0x88D89BE4
	Offset: 0x3C10
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function str_to_vec(str)
{
	/#
		parts = strtok(str, "");
		if(parts.size != 3)
		{
			return (0, 0, 0);
		}
		return (int(parts[0]), int(parts[1]), int(parts[2]));
	#/
}

/*
	Name: get_spawnpoint_random
	Namespace: spawnlogic
	Checksum: 0x7BDF592F
	Offset: 0x3CB8
	Size: 0xC2
	Parameters: 1
	Flags: Linked
*/
function get_spawnpoint_random(spawnpoints)
{
	if(!isdefined(spawnpoints))
	{
		return undefined;
	}
	for(i = 0; i < spawnpoints.size; i++)
	{
		j = randomint(spawnpoints.size);
		spawnpoint = spawnpoints[i];
		spawnpoints[i] = spawnpoints[j];
		spawnpoints[j] = spawnpoint;
	}
	return get_spawnpoint_final(spawnpoints, 0);
}

/*
	Name: get_all_other_players
	Namespace: spawnlogic
	Checksum: 0xACB256AB
	Offset: 0x3D88
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function get_all_other_players()
{
	aliveplayers = [];
	for(i = 0; i < level.players.size; i++)
	{
		if(!isdefined(level.players[i]))
		{
			continue;
		}
		player = level.players[i];
		if(player.sessionstate != "playing" || player == self)
		{
			continue;
		}
		aliveplayers[aliveplayers.size] = player;
	}
	return aliveplayers;
}

/*
	Name: get_all_allied_and_enemy_players
	Namespace: spawnlogic
	Checksum: 0xE24F2998
	Offset: 0x3E48
	Size: 0x1EC
	Parameters: 1
	Flags: Linked
*/
function get_all_allied_and_enemy_players(obj)
{
	if(level.teambased)
	{
		/#
			assert(isdefined(level.teams[self.team]));
		#/
		obj.allies = level.aliveplayers[self.team];
		obj.enemies = undefined;
		foreach(team in level.teams)
		{
			if(team == self.team)
			{
				continue;
			}
			if(!isdefined(obj.enemies))
			{
				obj.enemies = level.aliveplayers[team];
				continue;
			}
			foreach(player in level.aliveplayers[team])
			{
				obj.enemies[obj.enemies.size] = player;
			}
		}
	}
	else
	{
		obj.allies = [];
		obj.enemies = level.activeplayers;
	}
}

/*
	Name: init_weights
	Namespace: spawnlogic
	Checksum: 0xAFBE77A0
	Offset: 0x4040
	Size: 0xBA
	Parameters: 1
	Flags: Linked
*/
function init_weights(spawnpoints)
{
	for(i = 0; i < spawnpoints.size; i++)
	{
		spawnpoints[i].weight = 0;
	}
	/#
		if(level.storespawndata || level.debugspawning)
		{
			for(i = 0; i < spawnpoints.size; i++)
			{
				spawnpoints[i].spawndata = [];
				spawnpoints[i].sightchecks = [];
			}
		}
	#/
}

/*
	Name: get_spawnpoint_near_team
	Namespace: spawnlogic
	Checksum: 0x845BCCB9
	Offset: 0x4108
	Size: 0x540
	Parameters: 2
	Flags: Linked
*/
function get_spawnpoint_near_team(spawnpoints, favoredspawnpoints)
{
	if(!isdefined(spawnpoints))
	{
		return undefined;
	}
	/#
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			return get_spawnpoint_random(spawnpoints);
		}
	#/
	if(getdvarint("scr_spawnsimple") > 0)
	{
		return get_spawnpoint_random(spawnpoints);
	}
	begin();
	k_favored_spawn_point_bonus = 25000;
	init_weights(spawnpoints);
	obj = spawnstruct();
	get_all_allied_and_enemy_players(obj);
	numplayers = obj.allies.size + obj.enemies.size;
	allieddistanceweight = 2;
	myteam = self.team;
	for(i = 0; i < spawnpoints.size; i++)
	{
		spawnpoint = spawnpoints[i];
		if(!isdefined(spawnpoint.numplayersatlastupdate))
		{
			spawnpoint.numplayersatlastupdate = 0;
		}
		if(spawnpoint.numplayersatlastupdate > 0)
		{
			allydistsum = spawnpoint.distsum[myteam];
			enemydistsum = spawnpoint.enemydistsum[myteam];
			spawnpoint.weight = (enemydistsum - (allieddistanceweight * allydistsum)) / spawnpoint.numplayersatlastupdate;
			/#
				if(level.storespawndata || level.debugspawning)
				{
					spawnpoint.spawndata[spawnpoint.spawndata.size] = (((((("" + int(spawnpoint.weight)) + "") + int(enemydistsum) + "") + allieddistanceweight) + "") + int(allydistsum) + "") + spawnpoint.numplayersatlastupdate;
				}
			#/
			continue;
		}
		spawnpoint.weight = 0;
		/#
			if(level.storespawndata || level.debugspawning)
			{
				spawnpoint.spawndata[spawnpoint.spawndata.size] = "";
			}
		#/
	}
	if(isdefined(favoredspawnpoints))
	{
		for(i = 0; i < favoredspawnpoints.size; i++)
		{
			if(isdefined(favoredspawnpoints[i].weight))
			{
				favoredspawnpoints[i].weight = favoredspawnpoints[i].weight + k_favored_spawn_point_bonus;
				continue;
			}
			favoredspawnpoints[i].weight = k_favored_spawn_point_bonus;
		}
	}
	avoid_same_spawn(spawnpoints);
	avoid_spawn_reuse(spawnpoints, 1);
	avoid_weapon_damage(spawnpoints);
	avoid_visible_enemies(spawnpoints, 1);
	result = get_spawnpoint_final(spawnpoints);
	/#
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			check_bad(result);
		}
	#/
	return result;
}

/*
	Name: get_spawnpoint_dm
	Namespace: spawnlogic
	Checksum: 0xFA1AE4F7
	Offset: 0x4650
	Size: 0x29A
	Parameters: 1
	Flags: None
*/
function get_spawnpoint_dm(spawnpoints)
{
	if(!isdefined(spawnpoints))
	{
		return undefined;
	}
	begin();
	init_weights(spawnpoints);
	aliveplayers = get_all_other_players();
	idealdist = 1600;
	baddist = 1200;
	if(aliveplayers.size > 0)
	{
		for(i = 0; i < spawnpoints.size; i++)
		{
			totaldistfromideal = 0;
			nearbybadamount = 0;
			for(j = 0; j < aliveplayers.size; j++)
			{
				dist = distance(spawnpoints[i].origin, aliveplayers[j].origin);
				if(dist < baddist)
				{
					nearbybadamount = nearbybadamount + ((baddist - dist) / baddist);
				}
				distfromideal = abs(dist - idealdist);
				totaldistfromideal = totaldistfromideal + distfromideal;
			}
			avgdistfromideal = totaldistfromideal / aliveplayers.size;
			welldistancedamount = (idealdist - avgdistfromideal) / idealdist;
			spawnpoints[i].weight = (welldistancedamount - (nearbybadamount * 2)) + randomfloat(0.2);
		}
	}
	avoid_same_spawn(spawnpoints);
	avoid_spawn_reuse(spawnpoints, 0);
	avoid_weapon_damage(spawnpoints);
	avoid_visible_enemies(spawnpoints, 0);
	return get_spawnpoint_final(spawnpoints);
}

/*
	Name: begin
	Namespace: spawnlogic
	Checksum: 0x7A324981
	Offset: 0x48F8
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function begin()
{
	/#
		level.storespawndata = getdvarint("");
		level.debugspawning = getdvarint("") > 0;
	#/
}

/*
	Name: watch_spawn_profile
	Namespace: spawnlogic
	Checksum: 0x1A1AE24F
	Offset: 0x4950
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function watch_spawn_profile()
{
	/#
		while(true)
		{
			while(true)
			{
				if(getdvarint("") > 0)
				{
					break;
				}
				wait(0.05);
			}
			thread spawn_profile();
			while(true)
			{
				if(getdvarint("") <= 0)
				{
					break;
				}
				wait(0.05);
			}
			level notify(#"stop_spawn_profile");
		}
	#/
}

/*
	Name: spawn_profile
	Namespace: spawnlogic
	Checksum: 0x12CA3AC
	Offset: 0x4A00
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function spawn_profile()
{
	/#
		level endon(#"stop_spawn_profile");
		while(true)
		{
			if(level.players.size > 0 && level.spawnpoints.size > 0)
			{
				playernum = randomint(level.players.size);
				player = level.players[playernum];
				attempt = 1;
				while(!isdefined(player) && attempt < level.players.size)
				{
					playernum = (playernum + 1) % level.players.size;
					attempt++;
					player = level.players[playernum];
				}
				player get_spawnpoint_near_team(level.spawnpoints);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: spawn_graph_check
	Namespace: spawnlogic
	Checksum: 0xA2F3901C
	Offset: 0x4B18
	Size: 0x5A
	Parameters: 0
	Flags: Linked
*/
function spawn_graph_check()
{
	/#
		while(true)
		{
			wait(3);
		}
		if(getdvarint("") < 1)
		{
		}
		thread spawn_graph();
		return;
	#/
}

/*
	Name: spawn_graph
	Namespace: spawnlogic
	Checksum: 0x8A7DA13B
	Offset: 0x4B80
	Size: 0x650
	Parameters: 0
	Flags: Linked
*/
function spawn_graph()
{
	/#
		w = 20;
		h = 20;
		weightscale = 0.1;
		fakespawnpoints = [];
		corners = getentarray("", "");
		if(corners.size != 2)
		{
			println("");
			return;
		}
		min = corners[0].origin;
		max = corners[0].origin;
		if(corners[1].origin[0] > max[0])
		{
			max = (corners[1].origin[0], max[1], max[2]);
		}
		else
		{
			min = (corners[1].origin[0], min[1], min[2]);
		}
		if(corners[1].origin[1] > max[1])
		{
			max = (max[0], corners[1].origin[1], max[2]);
		}
		else
		{
			min = (min[0], corners[1].origin[1], min[2]);
		}
		i = 0;
		for(y = 0; y < h; y++)
		{
			yamnt = y / (h - 1);
			for(x = 0; x < w; x++)
			{
				xamnt = x / (w - 1);
				fakespawnpoints[i] = spawnstruct();
				fakespawnpoints[i].origin = ((min[0] * xamnt) + (max[0] * (1 - xamnt)), (min[1] * yamnt) + (max[1] * (1 - yamnt)), min[2]);
				fakespawnpoints[i].angles = (0, 0, 0);
				fakespawnpoints[i].forward = anglestoforward(fakespawnpoints[i].angles);
				fakespawnpoints[i].sighttracepoint = fakespawnpoints[i].origin;
				i++;
			}
		}
		didweights = 0;
		while(true)
		{
			spawni = 0;
			numiters = 5;
			for(i = 0; i < numiters; i++)
			{
				if(!level.players.size || !isdefined(level.players[0].team) || level.players[0].team == "" || !isdefined(level.players[0].curclass))
				{
					break;
				}
				endspawni = spawni + (fakespawnpoints.size / numiters);
				if(i == (numiters - 1))
				{
					endspawni = fakespawnpoints.size;
				}
				while(spawni < endspawni)
				{
					spawnpoint_update(fakespawnpoints[spawni]);
					spawni++;
				}
				if(didweights)
				{
					level.players[0] draw_spawn_graph(fakespawnpoints, w, h, weightscale);
				}
				wait(0.05);
			}
			if(!level.players.size || !isdefined(level.players[0].team) || level.players[0].team == "" || !isdefined(level.players[0].curclass))
			{
				wait(1);
				continue;
			}
			level.players[0] get_spawnpoint_near_team(fakespawnpoints);
			for(i = 0; i < fakespawnpoints.size; i++)
			{
				setup_spawn_graph_point(fakespawnpoints[i], weightscale);
			}
			didweights = 1;
			level.players[0] draw_spawn_graph(fakespawnpoints, w, h, weightscale);
			wait(0.05);
		}
	#/
}

/*
	Name: draw_spawn_graph
	Namespace: spawnlogic
	Checksum: 0xE87546D
	Offset: 0x51D8
	Size: 0x146
	Parameters: 4
	Flags: Linked
*/
function draw_spawn_graph(fakespawnpoints, w, h, weightscale)
{
	/#
		i = 0;
		for(y = 0; y < h; y++)
		{
			yamnt = y / (h - 1);
			for(x = 0; x < w; x++)
			{
				xamnt = x / (w - 1);
				if(y > 0)
				{
					spawn_graph_line(fakespawnpoints[i], fakespawnpoints[i - w], weightscale);
				}
				if(x > 0)
				{
					spawn_graph_line(fakespawnpoints[i], fakespawnpoints[i - 1], weightscale);
				}
				i++;
			}
		}
	#/
}

/*
	Name: setup_spawn_graph_point
	Namespace: spawnlogic
	Checksum: 0xDAA8BDAA
	Offset: 0x5328
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function setup_spawn_graph_point(s1, weightscale)
{
	/#
		s1.visible = 1;
		if(s1.weight < -1000 / weightscale)
		{
			s1.visible = 0;
		}
	#/
}

/*
	Name: spawn_graph_line
	Namespace: spawnlogic
	Checksum: 0x658A4EA6
	Offset: 0x5390
	Size: 0xDC
	Parameters: 3
	Flags: Linked
*/
function spawn_graph_line(s1, s2, weightscale)
{
	/#
		if(!s1.visible || !s2.visible)
		{
			return;
		}
		p1 = s1.origin + (0, 0, (s1.weight * weightscale) + 100);
		p2 = s2.origin + (0, 0, (s2.weight * weightscale) + 100);
		line(p1, p2, (1, 1, 1));
	#/
}

/*
	Name: loop_bot_spawns
	Namespace: spawnlogic
	Checksum: 0xC305282A
	Offset: 0x5478
	Size: 0x374
	Parameters: 0
	Flags: Linked
*/
function loop_bot_spawns()
{
	/#
		while(true)
		{
			if(getdvarint("") < 1)
			{
				wait(3);
				continue;
			}
			if(!isdefined(level.players))
			{
				wait(0.05);
				continue;
			}
			bots = [];
			for(i = 0; i < level.players.size; i++)
			{
				if(!isdefined(level.players[i]))
				{
					continue;
				}
				if(level.players[i].sessionstate == "" && issubstr(level.players[i].name, ""))
				{
					bots[bots.size] = level.players[i];
				}
			}
			if(bots.size > 0)
			{
				if(getdvarint("") == 1)
				{
					killer = bots[randomint(bots.size)];
					victim = bots[randomint(bots.size)];
					victim thread [[level.callbackplayerdamage]](killer, killer, 1000, 0, "", level.weaponnone, (0, 0, 0), (0, 0, 0), "", (0, 0, 0), 0, 0, (1, 0, 0));
				}
				else
				{
					numkills = getdvarint("");
					lastvictim = undefined;
					for(index = 0; index < numkills; index++)
					{
						killer = bots[randomint(bots.size)];
						victim = bots[randomint(bots.size)];
						while(isdefined(lastvictim) && victim == lastvictim)
						{
							victim = bots[randomint(bots.size)];
						}
						victim thread [[level.callbackplayerdamage]](killer, killer, 1000, 0, "", level.weaponnone, (0, 0, 0), (0, 0, 0), "", (0, 0, 0), 0, 0, (1, 0, 0));
						lastvictim = victim;
					}
				}
			}
			if(getdvarstring("") != "")
			{
				wait(getdvarfloat(""));
			}
			else
			{
				wait(0.05);
			}
		}
	#/
}

/*
	Name: allow_spawn_data_reading
	Namespace: spawnlogic
	Checksum: 0x4656EE6C
	Offset: 0x57F8
	Size: 0x1E8
	Parameters: 0
	Flags: Linked
*/
function allow_spawn_data_reading()
{
	/#
		setdvar("", "");
		prevval = getdvarstring("");
		prevrelval = getdvarstring("");
		readthistime = 0;
		while(true)
		{
			val = getdvarstring("");
			relval = undefined;
			if(!isdefined(val) || val == prevval)
			{
				relval = getdvarstring("");
				if(isdefined(relval) && relval != "")
				{
					setdvar("", "");
				}
				else
				{
					wait(0.5);
					continue;
				}
			}
			prevval = val;
			readthistime = 0;
			read_spawn_data(val, relval);
			if(!isdefined(level.curspawndata))
			{
				println("");
			}
			else
			{
				println("" + level.curspawndata.id);
			}
			thread draw_spawn_data();
		}
	#/
}

/*
	Name: show_deaths_debug
	Namespace: spawnlogic
	Checksum: 0xE7EE5738
	Offset: 0x59E8
	Size: 0x4B0
	Parameters: 0
	Flags: Linked
*/
function show_deaths_debug()
{
	/#
		while(true)
		{
			if(getdvarstring("") == "")
			{
				wait(3);
				continue;
			}
			time = gettime();
			for(i = 0; i < level.spawnlogic_deaths.size; i++)
			{
				if(isdefined(level.spawnlogic_deaths[i].los))
				{
					line(level.spawnlogic_deaths[i].org, level.spawnlogic_deaths[i].killorg, (1, 0, 0));
				}
				else
				{
					line(level.spawnlogic_deaths[i].org, level.spawnlogic_deaths[i].killorg, (1, 1, 1));
				}
				killer = level.spawnlogic_deaths[i].killer;
				if(isdefined(killer) && isalive(killer))
				{
					line(level.spawnlogic_deaths[i].killorg, killer.origin, (0.4, 0.4, 0.8));
				}
			}
			for(p = 0; p < level.players.size; p++)
			{
				if(!isdefined(level.players[p]))
				{
					continue;
				}
				if(isdefined(level.players[p].spawnlogic_killdist))
				{
					print3d(level.players[p].origin + vectorscale((0, 0, 1), 64), level.players[p].spawnlogic_killdist, (1, 1, 1));
				}
			}
			oldspawnkills = level.spawnlogic_spawnkills;
			level.spawnlogic_spawnkills = [];
			for(i = 0; i < oldspawnkills.size; i++)
			{
				spawnkill = oldspawnkills[i];
				if(spawnkill.dierwasspawner)
				{
					line(spawnkill.spawnpointorigin, spawnkill.dierorigin, (0.4, 0.5, 0.4));
					line(spawnkill.dierorigin, spawnkill.killerorigin, (0, 1, 1));
					print3d(spawnkill.dierorigin + vectorscale((0, 0, 1), 32), "", (0, 1, 1));
				}
				else
				{
					line(spawnkill.spawnpointorigin, spawnkill.killerorigin, (0.4, 0.5, 0.4));
					line(spawnkill.killerorigin, spawnkill.dierorigin, (0, 1, 1));
					print3d(spawnkill.dierorigin + vectorscale((0, 0, 1), 32), "", (0, 1, 1));
				}
				if((time - spawnkill.time) < 60000)
				{
					level.spawnlogic_spawnkills[level.spawnlogic_spawnkills.size] = oldspawnkills[i];
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: update_death_info_debug
	Namespace: spawnlogic
	Checksum: 0x63DD92BA
	Offset: 0x5EA0
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function update_death_info_debug()
{
	while(true)
	{
		if(getdvarstring("scr_spawnpointdebug") == "0")
		{
			wait(3);
			continue;
		}
		update_death_info();
		wait(3);
	}
}

/*
	Name: spawn_weight_debug
	Namespace: spawnlogic
	Checksum: 0x94F24A10
	Offset: 0x5F00
	Size: 0x314
	Parameters: 1
	Flags: Linked
*/
function spawn_weight_debug(spawnpoints)
{
	level notify(#"stop_spawn_weight_debug");
	level endon(#"stop_spawn_weight_debug");
	/#
		while(true)
		{
			if(getdvarstring("") == "")
			{
				wait(3);
				continue;
			}
			textoffset = vectorscale((0, 0, -1), 12);
			for(i = 0; i < spawnpoints.size; i++)
			{
				amnt = 1 * (1 - (spawnpoints[i].weight / -100000));
				if(amnt < 0)
				{
					amnt = 0;
				}
				if(amnt > 1)
				{
					amnt = 1;
				}
				orig = spawnpoints[i].origin + vectorscale((0, 0, 1), 80);
				print3d(orig, int(spawnpoints[i].weight), (1, amnt, 0.5));
				orig = orig + textoffset;
				if(isdefined(spawnpoints[i].spawndata))
				{
					for(j = 0; j < spawnpoints[i].spawndata.size; j++)
					{
						print3d(orig, spawnpoints[i].spawndata[j], vectorscale((1, 1, 1), 0.5));
						orig = orig + textoffset;
					}
				}
				if(isdefined(spawnpoints[i].sightchecks))
				{
					for(j = 0; j < spawnpoints[i].sightchecks.size; j++)
					{
						if(spawnpoints[i].sightchecks[j].penalty == 0)
						{
							continue;
						}
						print3d(orig, "" + spawnpoints[i].sightchecks[j].penalty, vectorscale((1, 1, 1), 0.5));
						orig = orig + textoffset;
					}
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: profile_debug
	Namespace: spawnlogic
	Checksum: 0xFD9796C0
	Offset: 0x6220
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function profile_debug()
{
	while(true)
	{
		if(getdvarstring("scr_spawnpointprofile") != "1")
		{
			wait(3);
			continue;
		}
		for(i = 0; i < level.spawnpoints.size; i++)
		{
			level.spawnpoints[i].weight = randomint(10000);
		}
		if(level.players.size > 0)
		{
			level.players[randomint(level.players.size)] get_spawnpoint_near_team(level.spawnpoints);
		}
		wait(0.05);
	}
}

/*
	Name: debug_nearby_players
	Namespace: spawnlogic
	Checksum: 0xC2A22C43
	Offset: 0x6318
	Size: 0xE0
	Parameters: 2
	Flags: None
*/
function debug_nearby_players(players, origin)
{
	/#
		if(getdvarstring("") == "")
		{
			return;
		}
		starttime = gettime();
		while(true)
		{
			for(i = 0; i < players.size; i++)
			{
				line(players[i].origin, origin, (0.5, 1, 0.5));
			}
			if((gettime() - starttime) > 5000)
			{
				return;
			}
			wait(0.05);
		}
	#/
}

/*
	Name: death_occured
	Namespace: spawnlogic
	Checksum: 0xC5612788
	Offset: 0x6400
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function death_occured(dier, killer)
{
}

/*
	Name: check_for_similar_deaths
	Namespace: spawnlogic
	Checksum: 0xD976DF9E
	Offset: 0x6420
	Size: 0x122
	Parameters: 1
	Flags: None
*/
function check_for_similar_deaths(deathinfo)
{
	for(i = 0; i < level.spawnlogic_deaths.size; i++)
	{
		if(level.spawnlogic_deaths[i].killer == deathinfo.killer)
		{
			dist = distance(level.spawnlogic_deaths[i].org, deathinfo.org);
			if(dist > 200)
			{
				continue;
			}
			dist = distance(level.spawnlogic_deaths[i].killorg, deathinfo.killorg);
			if(dist > 200)
			{
				continue;
			}
			level.spawnlogic_deaths[i].remove = 1;
		}
	}
}

/*
	Name: update_death_info
	Namespace: spawnlogic
	Checksum: 0x3F01D1A8
	Offset: 0x6550
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function update_death_info()
{
	time = gettime();
	for(i = 0; i < level.spawnlogic_deaths.size; i++)
	{
		deathinfo = level.spawnlogic_deaths[i];
		if((time - deathinfo.time) > 90000 || !isdefined(deathinfo.killer) || !isalive(deathinfo.killer) || !isdefined(level.teams[deathinfo.killer.team]) || distance(deathinfo.killer.origin, deathinfo.killorg) > 400)
		{
			level.spawnlogic_deaths[i].remove = 1;
		}
	}
	oldarray = level.spawnlogic_deaths;
	level.spawnlogic_deaths = [];
	start = 0;
	if((oldarray.size - 1024) > 0)
	{
		start = oldarray.size - 1024;
	}
	for(i = start; i < oldarray.size; i++)
	{
		if(!isdefined(oldarray[i].remove))
		{
			level.spawnlogic_deaths[level.spawnlogic_deaths.size] = oldarray[i];
		}
	}
}

/*
	Name: is_point_vulnerable
	Namespace: spawnlogic
	Checksum: 0x73FBDD1B
	Offset: 0x6740
	Size: 0x128
	Parameters: 1
	Flags: None
*/
function is_point_vulnerable(playerorigin)
{
	pos = self.origin + level.bettymodelcenteroffset;
	playerpos = playerorigin + vectorscale((0, 0, 1), 32);
	distsqrd = distancesquared(pos, playerpos);
	forward = anglestoforward(self.angles);
	if(distsqrd < (level.bettydetectionradius * level.bettydetectionradius))
	{
		playerdir = vectornormalize(playerpos - pos);
		angle = acos(vectordot(playerdir, forward));
		if(angle < level.bettydetectionconeangle)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: avoid_weapon_damage
	Namespace: spawnlogic
	Checksum: 0x9BF393C4
	Offset: 0x6870
	Size: 0x212
	Parameters: 1
	Flags: Linked
*/
function avoid_weapon_damage(spawnpoints)
{
	if(getdvarstring("scr_spawnpointnewlogic") == "0")
	{
		return;
	}
	weapondamagepenalty = 100000;
	if(getdvarstring("scr_spawnpointweaponpenalty") != "" && getdvarstring("scr_spawnpointweaponpenalty") != "0")
	{
		weapondamagepenalty = getdvarfloat("scr_spawnpointweaponpenalty");
	}
	mingrenadedistsquared = 62500;
	for(i = 0; i < spawnpoints.size; i++)
	{
		for(j = 0; j < level.grenades.size; j++)
		{
			if(!isdefined(level.grenades[j]))
			{
				continue;
			}
			if(distancesquared(spawnpoints[i].origin, level.grenades[j].origin) < mingrenadedistsquared)
			{
				spawnpoints[i].weight = spawnpoints[i].weight - weapondamagepenalty;
				/#
					if(level.storespawndata || level.debugspawning)
					{
						spawnpoints[i].spawndata[spawnpoints[i].spawndata.size] = "" + int(weapondamagepenalty);
					}
				#/
			}
		}
	}
}

/*
	Name: spawn_per_frame_update
	Namespace: spawnlogic
	Checksum: 0xAF74B47F
	Offset: 0x6A90
	Size: 0x80
	Parameters: 0
	Flags: None
*/
function spawn_per_frame_update()
{
	spawnpointindex = 0;
	while(true)
	{
		wait(0.05);
		if(!isdefined(level.spawnpoints))
		{
			return;
		}
		spawnpointindex = (spawnpointindex + 1) % level.spawnpoints.size;
		spawnpoint = level.spawnpoints[spawnpointindex];
		spawnpoint_update(spawnpoint);
	}
}

/*
	Name: get_non_team_sum
	Namespace: spawnlogic
	Checksum: 0x8422B618
	Offset: 0x6B18
	Size: 0xC0
	Parameters: 2
	Flags: Linked
*/
function get_non_team_sum(skip_team, sums)
{
	value = 0;
	foreach(team in level.teams)
	{
		if(team == skip_team)
		{
			continue;
		}
		value = value + sums[team];
	}
	return value;
}

/*
	Name: get_non_team_min_dist
	Namespace: spawnlogic
	Checksum: 0xB500B02F
	Offset: 0x6BE0
	Size: 0xD2
	Parameters: 2
	Flags: Linked
*/
function get_non_team_min_dist(skip_team, mindists)
{
	dist = 9999999;
	foreach(team in level.teams)
	{
		if(team == skip_team)
		{
			continue;
		}
		if(dist > mindists[team])
		{
			dist = mindists[team];
		}
	}
	return dist;
}

/*
	Name: spawnpoint_update
	Namespace: spawnlogic
	Checksum: 0xD5F0D82F
	Offset: 0x6CC0
	Size: 0x6EA
	Parameters: 1
	Flags: Linked
*/
function spawnpoint_update(spawnpoint)
{
	if(level.teambased)
	{
		sights = [];
		foreach(team in level.teams)
		{
			spawnpoint.enemysights[team] = 0;
			sights[team] = 0;
			spawnpoint.nearbyplayers[team] = [];
		}
	}
	else
	{
		spawnpoint.enemysights = 0;
		spawnpoint.nearbyplayers["all"] = [];
	}
	spawnpointdir = spawnpoint.forward;
	debug = 0;
	/#
		debug = getdvarint("") > 0;
	#/
	mindist = [];
	distsum = [];
	if(!level.teambased)
	{
		mindist["all"] = 9999999;
	}
	foreach(team in level.teams)
	{
		spawnpoint.distsum[team] = 0;
		spawnpoint.enemydistsum[team] = 0;
		spawnpoint.minenemydist[team] = 9999999;
		mindist[team] = 9999999;
	}
	spawnpoint.numplayersatlastupdate = 0;
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(player.sessionstate != "playing")
		{
			continue;
		}
		diff = player.origin - spawnpoint.origin;
		diff = (diff[0], diff[1], 0);
		dist = length(diff);
		team = "all";
		if(level.teambased)
		{
			team = player.team;
		}
		if(dist < 1024)
		{
			spawnpoint.nearbyplayers[team][spawnpoint.nearbyplayers[team].size] = player;
		}
		if(dist < mindist[team])
		{
			mindist[team] = dist;
		}
		distsum[team] = distsum[team] + dist;
		spawnpoint.numplayersatlastupdate++;
		pdir = anglestoforward(player.angles);
		if(vectordot(spawnpointdir, diff) < 0 && vectordot(pdir, diff) > 0)
		{
			continue;
		}
		losexists = bullettracepassed(player.origin + vectorscale((0, 0, 1), 50), spawnpoint.sighttracepoint, 0, undefined);
		spawnpoint.lastsighttracetime = gettime();
		if(losexists)
		{
			if(level.teambased)
			{
				sights[player.team]++;
			}
			else
			{
				spawnpoint.enemysights++;
			}
			/#
				if(debug)
				{
					line(player.origin + vectorscale((0, 0, 1), 50), spawnpoint.sighttracepoint, (0.5, 1, 0.5));
				}
			#/
		}
	}
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			spawnpoint.enemysights[team] = get_non_team_sum(team, sights);
			spawnpoint.minenemydist[team] = get_non_team_min_dist(team, mindist);
			spawnpoint.distsum[team] = distsum[team];
			spawnpoint.enemydistsum[team] = get_non_team_sum(team, distsum);
		}
	}
	else
	{
		spawnpoint.distsum["all"] = distsum["all"];
		spawnpoint.enemydistsum["all"] = distsum["all"];
		spawnpoint.minenemydist["all"] = mindist["all"];
	}
}

/*
	Name: get_los_penalty
	Namespace: spawnlogic
	Checksum: 0x18BA0E18
	Offset: 0x73B8
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function get_los_penalty()
{
	if(getdvarstring("scr_spawnpointlospenalty") != "" && getdvarstring("scr_spawnpointlospenalty") != "0")
	{
		return getdvarfloat("scr_spawnpointlospenalty");
	}
	return 100000;
}

/*
	Name: last_minute_sight_traces
	Namespace: spawnlogic
	Checksum: 0xF13FB75B
	Offset: 0x7438
	Size: 0x2DE
	Parameters: 1
	Flags: Linked
*/
function last_minute_sight_traces(spawnpoint)
{
	if(!isdefined(spawnpoint.nearbyplayers))
	{
		return false;
	}
	closest = undefined;
	closestdistsq = undefined;
	secondclosest = undefined;
	secondclosestdistsq = undefined;
	foreach(team in spawnpoint.nearbyplayers)
	{
		if(team == self.team)
		{
			continue;
		}
		for(i = 0; i < spawnpoint.nearbyplayers[team].size; i++)
		{
			player = spawnpoint.nearbyplayers[team][i];
			if(!isdefined(player))
			{
				continue;
			}
			if(player.sessionstate != "playing")
			{
				continue;
			}
			if(player == self)
			{
				continue;
			}
			distsq = distancesquared(spawnpoint.origin, player.origin);
			if(!isdefined(closest) || distsq < closestdistsq)
			{
				secondclosest = closest;
				secondclosestdistsq = closestdistsq;
				closest = player;
				closestdistsq = distsq;
				continue;
			}
			if(!isdefined(secondclosest) || distsq < secondclosestdistsq)
			{
				secondclosest = player;
				secondclosestdistsq = distsq;
			}
		}
	}
	if(isdefined(closest))
	{
		if(bullettracepassed(closest.origin + vectorscale((0, 0, 1), 50), spawnpoint.sighttracepoint, 0, undefined))
		{
			return true;
		}
	}
	if(isdefined(secondclosest))
	{
		if(bullettracepassed(secondclosest.origin + vectorscale((0, 0, 1), 50), spawnpoint.sighttracepoint, 0, undefined))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: avoid_visible_enemies
	Namespace: spawnlogic
	Checksum: 0xC988B060
	Offset: 0x7720
	Size: 0x570
	Parameters: 2
	Flags: Linked
*/
function avoid_visible_enemies(spawnpoints, teambased)
{
	if(getdvarstring("scr_spawnpointnewlogic") == "0")
	{
		return;
	}
	lospenalty = get_los_penalty();
	mindistteam = self.team;
	if(teambased)
	{
		for(i = 0; i < spawnpoints.size; i++)
		{
			if(!isdefined(spawnpoints[i].enemysights))
			{
				continue;
			}
			penalty = lospenalty * spawnpoints[i].enemysights[self.team];
			spawnpoints[i].weight = spawnpoints[i].weight - penalty;
			/#
				if(level.storespawndata || level.debugspawning)
				{
					index = spawnpoints[i].sightchecks.size;
					spawnpoints[i].sightchecks[index] = spawnstruct();
					spawnpoints[i].sightchecks[index].penalty = penalty;
				}
			#/
		}
	}
	else
	{
		for(i = 0; i < spawnpoints.size; i++)
		{
			if(!isdefined(spawnpoints[i].enemysights))
			{
				continue;
			}
			penalty = lospenalty * spawnpoints[i].enemysights;
			spawnpoints[i].weight = spawnpoints[i].weight - penalty;
			/#
				if(level.storespawndata || level.debugspawning)
				{
					index = spawnpoints[i].sightchecks.size;
					spawnpoints[i].sightchecks[index] = spawnstruct();
					spawnpoints[i].sightchecks[index].penalty = penalty;
				}
			#/
		}
		mindistteam = "all";
	}
	avoidweight = getdvarfloat("scr_spawn_enemyavoidweight");
	if(avoidweight != 0)
	{
		nearbyenemyouterrange = getdvarfloat("scr_spawn_enemyavoiddist");
		nearbyenemyouterrangesq = nearbyenemyouterrange * nearbyenemyouterrange;
		nearbyenemypenalty = 1500 * avoidweight;
		nearbyenemyminorpenalty = 800 * avoidweight;
		lastattackerorigin = vectorscale((-1, -1, -1), 99999);
		lastdeathpos = vectorscale((-1, -1, -1), 99999);
		if(isalive(self.lastattacker))
		{
			lastattackerorigin = self.lastattacker.origin;
		}
		if(isdefined(self.lastdeathpos))
		{
			lastdeathpos = self.lastdeathpos;
		}
		for(i = 0; i < spawnpoints.size; i++)
		{
			mindist = spawnpoints[i].minenemydist[mindistteam];
			if(mindist < (nearbyenemyouterrange * 2))
			{
				penalty = nearbyenemyminorpenalty * (1 - (mindist / (nearbyenemyouterrange * 2)));
				if(mindist < nearbyenemyouterrange)
				{
					penalty = penalty + (nearbyenemypenalty * (1 - (mindist / nearbyenemyouterrange)));
				}
				if(penalty > 0)
				{
					spawnpoints[i].weight = spawnpoints[i].weight - penalty;
					/#
						if(level.storespawndata || level.debugspawning)
						{
							spawnpoints[i].spawndata[spawnpoints[i].spawndata.size] = (("" + int(spawnpoints[i].minenemydist[mindistteam])) + "") + int(penalty);
						}
					#/
				}
			}
		}
	}
}

/*
	Name: avoid_spawn_reuse
	Namespace: spawnlogic
	Checksum: 0xDD3D43B9
	Offset: 0x7C98
	Size: 0x28C
	Parameters: 2
	Flags: Linked
*/
function avoid_spawn_reuse(spawnpoints, teambased)
{
	if(getdvarstring("scr_spawnpointnewlogic") == "0")
	{
		return;
	}
	time = gettime();
	maxtime = 10000;
	maxdistsq = 1048576;
	for(i = 0; i < spawnpoints.size; i++)
	{
		spawnpoint = spawnpoints[i];
		if(!isdefined(spawnpoint.lastspawnedplayer) || !isdefined(spawnpoint.lastspawntime) || !isalive(spawnpoint.lastspawnedplayer))
		{
			continue;
		}
		if(spawnpoint.lastspawnedplayer == self)
		{
			continue;
		}
		if(teambased && spawnpoint.lastspawnedplayer.team == self.team)
		{
			continue;
		}
		timepassed = time - spawnpoint.lastspawntime;
		if(timepassed < maxtime)
		{
			distsq = distancesquared(spawnpoint.lastspawnedplayer.origin, spawnpoint.origin);
			if(distsq < maxdistsq)
			{
				worsen = (5000 * (1 - (distsq / maxdistsq))) * (1 - (timepassed / maxtime));
				spawnpoint.weight = spawnpoint.weight - worsen;
				/#
					if(level.storespawndata || level.debugspawning)
					{
						spawnpoint.spawndata[spawnpoint.spawndata.size] = "" + worsen;
					}
				#/
			}
			else
			{
				spawnpoint.lastspawnedplayer = undefined;
			}
			continue;
		}
		spawnpoint.lastspawnedplayer = undefined;
	}
}

/*
	Name: avoid_same_spawn
	Namespace: spawnlogic
	Checksum: 0x37ECBE93
	Offset: 0x7F30
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function avoid_same_spawn(spawnpoints)
{
	if(getdvarstring("scr_spawnpointnewlogic") == "0")
	{
		return;
	}
	if(!isdefined(self.lastspawnpoint))
	{
		return;
	}
	for(i = 0; i < spawnpoints.size; i++)
	{
		if(spawnpoints[i] == self.lastspawnpoint)
		{
			spawnpoints[i].weight = spawnpoints[i].weight - 50000;
			/#
				if(level.storespawndata || level.debugspawning)
				{
					spawnpoints[i].spawndata[spawnpoints[i].spawndata.size] = "";
				}
			#/
			break;
		}
	}
}

/*
	Name: get_random_intermission_point
	Namespace: spawnlogic
	Checksum: 0xC84B4010
	Offset: 0x8040
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function get_random_intermission_point()
{
	spawnpoints = struct::get_array("cp_global_intermission", "targetname");
	if(!spawnpoints.size)
	{
		spawnpoints = struct::get_array("cp_coop_spawn", "targetname");
	}
	/#
		assert(spawnpoints.size);
	#/
	spawnpoint = get_spawnpoint_random(spawnpoints);
	return spawnpoint;
}

/*
	Name: place_spawn
	Namespace: spawnlogic
	Checksum: 0x99EC1590
	Offset: 0x80F0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function place_spawn()
{
}

