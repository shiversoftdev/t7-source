// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;

#namespace spawnlogic;

/*
	Name: __init__sytem__
	Namespace: spawnlogic
	Checksum: 0xCCDC7DE3
	Offset: 0x288
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
	Checksum: 0x8AD2CD24
	Offset: 0x2C8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: spawnlogic
	Checksum: 0x7FBB5271
	Offset: 0x2F8
	Size: 0x404
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
	level.numplayerswaitingtoenterkillcam = 0;
	level.convert_spawns_to_structs = getdvarint("spawnsystem_convert_spawns_to_structs");
	/#
		println("");
	#/
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
	Checksum: 0xD06F5337
	Offset: 0x708
	Size: 0x27A
	Parameters: 3
	Flags: Linked
*/
function add_spawn_points_internal(team, spawnpoints, list = 0)
{
	oldspawnpoints = [];
	if(level.teamspawnpoints[team].size)
	{
		oldspawnpoints = level.teamspawnpoints[team];
	}
	if(isdefined(level.allowedgameobjects) && level.convert_spawns_to_structs)
	{
		for(i = spawnpoints.size - 1; i >= 0; i--)
		{
			if(!gameobjects::entity_is_allowed(spawnpoints[i], level.allowedgameobjects))
			{
				spawnpoints[i] = undefined;
			}
		}
		arrayremovevalue(spawnpoints, undefined);
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
	Checksum: 0x1C2EE8AF
	Offset: 0x990
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
	level.player_spawn_points = undefined;
}

/*
	Name: add_spawn_points
	Namespace: spawnlogic
	Checksum: 0xB65CF197
	Offset: 0xA38
	Size: 0xC4
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
			/#
				assert(level.teamspawnpoints[team].size, ("" + spawnpointname) + "");
			#/
		#/
		wait(1);
		return;
	}
}

/*
	Name: rebuild_spawn_points
	Namespace: spawnlogic
	Checksum: 0x725968EA
	Offset: 0xB08
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function rebuild_spawn_points(team)
{
	level.teamspawnpoints[team] = [];
	for(index = 0; index < level.spawn_point_team_class_names[team].size; index++)
	{
		add_spawn_points_internal(team, level.spawn_point_team_class_names[team][index]);
	}
}

/*
	Name: place_spawn_points
	Namespace: spawnlogic
	Checksum: 0xB14C4D64
	Offset: 0xB90
	Size: 0x168
	Parameters: 1
	Flags: Linked
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
		/#
			assert(spawnpoints.size, ("" + spawnpointname) + "");
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
	Checksum: 0x4FAD7985
	Offset: 0xD00
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
		placespawnpoint(spawnpoints[index]);
	}
}

/*
	Name: add_spawn_point_classname
	Namespace: spawnlogic
	Checksum: 0x3A9A3EFF
	Offset: 0xDB8
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function add_spawn_point_classname(spawnpointclassname)
{
	if(!isdefined(level.spawn_point_class_names))
	{
		level.spawn_point_class_names = [];
	}
	level.spawn_point_class_names[level.spawn_point_class_names.size] = spawnpointclassname;
}

/*
	Name: add_spawn_point_team_classname
	Namespace: spawnlogic
	Checksum: 0xE1AA8AA3
	Offset: 0xE00
	Size: 0x38
	Parameters: 2
	Flags: Linked
*/
function add_spawn_point_team_classname(team, spawnpointclassname)
{
	level.spawn_point_team_class_names[team][level.spawn_point_team_class_names[team].size] = spawnpointclassname;
}

/*
	Name: _get_spawnpoint_array
	Namespace: spawnlogic
	Checksum: 0x3C321FE4
	Offset: 0xE40
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function _get_spawnpoint_array(spawnpoint_name)
{
	if(isdefined(level.convert_spawns_to_structs) && level.convert_spawns_to_structs)
	{
		return struct::get_array(spawnpoint_name, "targetname");
	}
	return getentarray(spawnpoint_name, "classname");
}

/*
	Name: get_spawnpoint_array
	Namespace: spawnlogic
	Checksum: 0x1A8700FC
	Offset: 0xEA8
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function get_spawnpoint_array(classname)
{
	spawnpoints = _get_spawnpoint_array(classname);
	if(!isdefined(level.extraspawnpoints) || !isdefined(level.extraspawnpoints[classname]))
	{
		return spawnpoints;
	}
	for(i = 0; i < level.extraspawnpoints[classname].size; i++)
	{
		spawnpoints[spawnpoints.size] = level.extraspawnpoints[classname][i];
	}
	return spawnpoints;
}

/*
	Name: spawnpoint_init
	Namespace: spawnlogic
	Checksum: 0xEF0A480E
	Offset: 0xF68
	Size: 0x138
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
	placespawnpoint(spawnpoint);
	spawnpoint.forward = anglestoforward(spawnpoint.angles);
	spawnpoint.sighttracepoint = spawnpoint.origin + vectorscale((0, 0, 1), 50);
	spawnpoint.inited = 1;
}

/*
	Name: get_team_spawnpoints
	Namespace: spawnlogic
	Checksum: 0xD98EDBB8
	Offset: 0x10A8
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
	Checksum: 0xD10B926D
	Offset: 0x10C8
	Size: 0x360
	Parameters: 4
	Flags: Linked
*/
function get_spawnpoint_final(spawnpoints, useweights, predictedspawn, isintermmissionspawn = 0)
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
	if(!isdefined(predictedspawn))
	{
		predictedspawn = 0;
	}
	if(useweights)
	{
		bestspawnpoint = get_best_weighted_spawnpoint(spawnpoints);
		thread spawn_weight_debug(spawnpoints);
	}
	else
	{
		if(isdefined(self.lastspawnpoint) && self.lastspawnpoint.lastspawnpredicted && !predictedspawn && !isintermmissionspawn)
		{
			if(!positionwouldtelefrag(self.lastspawnpoint.origin))
			{
				bestspawnpoint = self.lastspawnpoint;
			}
		}
		if(!isdefined(bestspawnpoint))
		{
			for(i = 0; i < spawnpoints.size; i++)
			{
				if(isdefined(self.lastspawnpoint) && self.lastspawnpoint == spawnpoints[i] && !self.lastspawnpoint.lastspawnpredicted)
				{
					continue;
				}
				if(positionwouldtelefrag(spawnpoints[i].origin))
				{
					continue;
				}
				if(isdefined(level.var_6f13f156) && ![[level.var_6f13f156]](spawnpoints[i], predictedspawn))
				{
					continue;
				}
				bestspawnpoint = spawnpoints[i];
				break;
			}
		}
		if(!isdefined(bestspawnpoint))
		{
			if(isdefined(self.lastspawnpoint) && !positionwouldtelefrag(self.lastspawnpoint.origin))
			{
				for(i = 0; i < spawnpoints.size; i++)
				{
					if(isdefined(level.var_6f13f156) && ![[level.var_6f13f156]](spawnpoints[i], predictedspawn))
					{
						continue;
					}
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
	self finalize_spawnpoint_choice(bestspawnpoint, predictedspawn);
	/#
		self store_spawn_data(spawnpoints, useweights, bestspawnpoint);
	#/
	return bestspawnpoint;
}

/*
	Name: finalize_spawnpoint_choice
	Namespace: spawnlogic
	Checksum: 0xBAB842C7
	Offset: 0x1430
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function finalize_spawnpoint_choice(spawnpoint, predictedspawn)
{
	time = gettime();
	self.lastspawnpoint = spawnpoint;
	self.lastspawntime = time;
	spawnpoint.lastspawnedplayer = self;
	spawnpoint.lastspawntime = time;
	spawnpoint.lastspawnpredicted = predictedspawn;
}

/*
	Name: get_best_weighted_spawnpoint
	Namespace: spawnlogic
	Checksum: 0x3EC7A2F1
	Offset: 0x14B0
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
	Checksum: 0xD5C1C19B
	Offset: 0x1770
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
	Checksum: 0xBFE87F7E
	Offset: 0x18D0
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
	Checksum: 0x7485EDDF
	Offset: 0x19C0
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
		if(bestspawnpoint.classname == "")
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
	Checksum: 0xA56DD7BF
	Offset: 0x2258
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
	Checksum: 0xBE5FE93E
	Offset: 0x2D98
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
	Checksum: 0x97659E9E
	Offset: 0x3218
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
	Checksum: 0xBB6B17A6
	Offset: 0x32A0
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
	Checksum: 0x59C18B75
	Offset: 0x3348
	Size: 0xEA
	Parameters: 3
	Flags: Linked
*/
function get_spawnpoint_random(spawnpoints, predictedspawn, isintermissionspawn = 0)
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
	return get_spawnpoint_final(spawnpoints, 0, predictedspawn, isintermissionspawn);
}

/*
	Name: get_all_other_players
	Namespace: spawnlogic
	Checksum: 0xE761C03D
	Offset: 0x3440
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
	Checksum: 0x6E8ED900
	Offset: 0x3500
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
	Checksum: 0xAC2E7438
	Offset: 0x36F8
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
	Checksum: 0xFAFC988B
	Offset: 0x37C0
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
	Checksum: 0x37050F43
	Offset: 0x3D08
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
	Checksum: 0x68A17155
	Offset: 0x3FB0
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
	Checksum: 0x16050020
	Offset: 0x4008
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
	Checksum: 0x976AD221
	Offset: 0x40B8
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
	Checksum: 0x5D1962B6
	Offset: 0x41D0
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
	Checksum: 0x230F8DE1
	Offset: 0x4238
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
	Checksum: 0x9AFB7CC2
	Offset: 0x4890
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
	Checksum: 0xCB776C98
	Offset: 0x49E0
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
	Checksum: 0x67D8CACE
	Offset: 0x4A48
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
	Checksum: 0xE127D016
	Offset: 0x4B30
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
						victim thread [[level.callbackplayerdamage]](killer, killer, 1000, 0, "", "", (0, 0, 0), (0, 0, 0), "", (0, 0, 0), 0, 0, (1, 0, 0));
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
	Checksum: 0xD34B4281
	Offset: 0x4EB0
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
	Checksum: 0xDC9BC5C9
	Offset: 0x50A0
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
	Checksum: 0xB3476117
	Offset: 0x5558
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
	Checksum: 0xE24D1B1D
	Offset: 0x55B8
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
	Checksum: 0xAB27CC1D
	Offset: 0x58D8
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
	Checksum: 0x496761BB
	Offset: 0x59D0
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
	Checksum: 0xCED99F97
	Offset: 0x5AB8
	Size: 0x14
	Parameters: 2
	Flags: None
*/
function death_occured(dier, killer)
{
}

/*
	Name: check_for_similar_deaths
	Namespace: spawnlogic
	Checksum: 0x4DCA6C06
	Offset: 0x5AD8
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
	Checksum: 0xA4B2DDD7
	Offset: 0x5C08
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
	Checksum: 0x2614953A
	Offset: 0x5DF8
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
	Checksum: 0x99383608
	Offset: 0x5F28
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
	Checksum: 0x61D2C811
	Offset: 0x6148
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
	Checksum: 0xA7F5AE27
	Offset: 0x61D0
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
	Checksum: 0x10445E96
	Offset: 0x6298
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
	Checksum: 0x2BAC4930
	Offset: 0x6378
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
	Checksum: 0xBDF77552
	Offset: 0x6A70
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
	Checksum: 0x32B7C87
	Offset: 0x6AF0
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
	Checksum: 0xC50913CC
	Offset: 0x6DD8
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
	Checksum: 0xBFC7E854
	Offset: 0x7350
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
	Checksum: 0x495230D9
	Offset: 0x75E8
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
	Checksum: 0xFEA5FAF9
	Offset: 0x76F8
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function get_random_intermission_point()
{
	spawnpoints = _get_spawnpoint_array("mp_global_intermission");
	if(!spawnpoints.size)
	{
		spawnpoints = _get_spawnpoint_array("info_player_start");
	}
	/#
		assert(spawnpoints.size);
	#/
	spawnpoint = get_spawnpoint_random(spawnpoints, undefined, 1);
	return spawnpoint;
}

/*
	Name: move_spawn_point
	Namespace: spawnlogic
	Checksum: 0x9D50ABB0
	Offset: 0x77A0
	Size: 0x12C
	Parameters: 4
	Flags: None
*/
function move_spawn_point(targetname, start_point, new_point, new_angles)
{
	if(getdvarint("spawnsystem_convert_spawns_to_structs"))
	{
		spawn_points = struct::get_array(targetname, "targetname");
	}
	else
	{
		spawn_points = getentarray(targetname, "classname");
	}
	for(i = 0; i < spawn_points.size; i++)
	{
		if(distancesquared(spawn_points[i].origin, start_point) < 1)
		{
			spawn_points[i].origin = new_point;
			if(isdefined(new_angles))
			{
				spawn_points[i].angles = new_angles;
			}
			return;
		}
	}
}

