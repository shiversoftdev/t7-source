// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_faller;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_server_throttle;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_weapons;

#namespace zm_utility;

/*
	Name: init_utility
	Namespace: zm_utility
	Checksum: 0x99EC1590
	Offset: 0xB00
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init_utility()
{
}

/*
	Name: is_classic
	Namespace: zm_utility
	Checksum: 0xB4DD97D6
	Offset: 0xB10
	Size: 0x8
	Parameters: 0
	Flags: Linked
*/
function is_classic()
{
	return true;
}

/*
	Name: is_standard
	Namespace: zm_utility
	Checksum: 0xDEE46E0A
	Offset: 0xB20
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function is_standard()
{
	dvar = getdvarstring("ui_gametype");
	if(dvar == "zstandard")
	{
		return true;
	}
	return false;
}

/*
	Name: convertsecondstomilliseconds
	Namespace: zm_utility
	Checksum: 0xF3BA1460
	Offset: 0xB68
	Size: 0x16
	Parameters: 1
	Flags: None
*/
function convertsecondstomilliseconds(seconds)
{
	return seconds * 1000;
}

/*
	Name: is_player
	Namespace: zm_utility
	Checksum: 0xF551CB3C
	Offset: 0xB88
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function is_player()
{
	return isplayer(self) || (isdefined(self.pers) && (isdefined(self.pers["isBot"]) && self.pers["isBot"]));
}

/*
	Name: lerp
	Namespace: zm_utility
	Checksum: 0x177403B2
	Offset: 0xBE8
	Size: 0x12C
	Parameters: 1
	Flags: None
*/
function lerp(chunk)
{
	link = spawn("script_origin", self getorigin());
	link.angles = self.first_node.angles;
	self linkto(link);
	link rotateto(self.first_node.angles, level._contextual_grab_lerp_time);
	link moveto(self.attacking_spot, level._contextual_grab_lerp_time);
	link util::waittill_multiple("rotatedone", "movedone");
	self unlink();
	link delete();
}

/*
	Name: recalc_zombie_array
	Namespace: zm_utility
	Checksum: 0x99EC1590
	Offset: 0xD20
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function recalc_zombie_array()
{
}

/*
	Name: init_zombie_run_cycle
	Namespace: zm_utility
	Checksum: 0xB4E118DE
	Offset: 0xD30
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function init_zombie_run_cycle()
{
	if(isdefined(level.speed_change_round))
	{
		if(level.round_number >= level.speed_change_round)
		{
			speed_percent = 0.2 + ((level.round_number - level.speed_change_round) * 0.2);
			speed_percent = min(speed_percent, 1);
			change_round_max = int(level.speed_change_max * speed_percent);
			change_left = change_round_max - level.speed_change_num;
			if(change_left == 0)
			{
				self zombie_utility::set_zombie_run_cycle();
				return;
			}
			change_speed = randomint(100);
			if(change_speed > 80)
			{
				self change_zombie_run_cycle();
				return;
			}
			zombie_count = zombie_utility::get_current_zombie_count();
			zombie_left = level.zombie_ai_limit - zombie_count;
			if(zombie_left == change_left)
			{
				self change_zombie_run_cycle();
				return;
			}
		}
	}
	self zombie_utility::set_zombie_run_cycle();
}

/*
	Name: change_zombie_run_cycle
	Namespace: zm_utility
	Checksum: 0x453C16BF
	Offset: 0xED8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function change_zombie_run_cycle()
{
	level.speed_change_num++;
	if(level.gamedifficulty == 0)
	{
		self zombie_utility::set_zombie_run_cycle("sprint");
	}
	else
	{
		self zombie_utility::set_zombie_run_cycle("walk");
	}
	self thread speed_change_watcher();
}

/*
	Name: make_supersprinter
	Namespace: zm_utility
	Checksum: 0x16BD6A47
	Offset: 0xF50
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function make_supersprinter()
{
	self zombie_utility::set_zombie_run_cycle("super_sprint");
}

/*
	Name: speed_change_watcher
	Namespace: zm_utility
	Checksum: 0xFD14A7B8
	Offset: 0xF80
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function speed_change_watcher()
{
	self waittill(#"death");
	if(level.speed_change_num > 0)
	{
		level.speed_change_num--;
	}
}

/*
	Name: move_zombie_spawn_location
	Namespace: zm_utility
	Checksum: 0x7E41AAE6
	Offset: 0xFB0
	Size: 0x53C
	Parameters: 1
	Flags: Linked
*/
function move_zombie_spawn_location(spot)
{
	self endon(#"death");
	if(isdefined(self.spawn_pos))
	{
		self notify(#"risen", self.spawn_pos.script_string);
		return;
	}
	self.spawn_pos = spot;
	if(isdefined(spot.target))
	{
		self.target = spot.target;
	}
	if(isdefined(spot.zone_name))
	{
		self.zone_name = spot.zone_name;
		self.previous_zone_name = spot.zone_name;
	}
	if(isdefined(spot.script_parameters))
	{
		self.script_parameters = spot.script_parameters;
	}
	if(!isdefined(spot.script_noteworthy))
	{
		spot.script_noteworthy = "spawn_location";
	}
	tokens = strtok(spot.script_noteworthy, " ");
	foreach(index, token in tokens)
	{
		if(isdefined(self.spawn_point_override))
		{
			spot = self.spawn_point_override;
			token = spot.script_noteworthy;
		}
		if(token == "custom_spawner_entry")
		{
			next_token = index + 1;
			if(isdefined(tokens[next_token]))
			{
				str_spawn_entry = tokens[next_token];
				if(isdefined(level.custom_spawner_entry) && isdefined(level.custom_spawner_entry[str_spawn_entry]))
				{
					self thread [[level.custom_spawner_entry[str_spawn_entry]]](spot);
					continue;
				}
			}
		}
		if(token == "riser_location")
		{
			self thread zm_spawner::do_zombie_rise(spot);
			continue;
		}
		if(token == "faller_location")
		{
			self thread zm_ai_faller::do_zombie_fall(spot);
			continue;
		}
		if(token == "spawn_location")
		{
			if(isdefined(self.anchor))
			{
				return;
			}
			self.anchor = spawn("script_origin", self.origin);
			self.anchor.angles = self.angles;
			self linkto(self.anchor);
			self.anchor thread anchor_delete_failsafe(self);
			if(!isdefined(spot.angles))
			{
				spot.angles = (0, 0, 0);
			}
			self ghost();
			self.anchor moveto(spot.origin, 0.05);
			self.anchor waittill(#"movedone");
			target_org = zombie_utility::get_desired_origin();
			if(isdefined(target_org))
			{
				anim_ang = vectortoangles(target_org - self.origin);
				self.anchor rotateto((0, anim_ang[1], 0), 0.05);
				self.anchor waittill(#"rotatedone");
			}
			if(isdefined(level.zombie_spawn_fx))
			{
				playfx(level.zombie_spawn_fx, spot.origin);
			}
			self unlink();
			if(isdefined(self.anchor))
			{
				self.anchor delete();
			}
			if(!(isdefined(self.dontshow) && self.dontshow))
			{
				self show();
			}
			self notify(#"risen", spot.script_string);
		}
	}
}

/*
	Name: anchor_delete_failsafe
	Namespace: zm_utility
	Checksum: 0x553C20B3
	Offset: 0x14F8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function anchor_delete_failsafe(ai_zombie)
{
	ai_zombie endon(#"risen");
	ai_zombie waittill(#"death");
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: run_spawn_functions
	Namespace: zm_utility
	Checksum: 0x714E261C
	Offset: 0x1548
	Size: 0x1A6
	Parameters: 0
	Flags: None
*/
function run_spawn_functions()
{
	self endon(#"death");
	waittillframeend();
	for(i = 0; i < level.spawn_funcs[self.team].size; i++)
	{
		func = level.spawn_funcs[self.team][i];
		util::single_thread(self, func["function"], func["param1"], func["param2"], func["param3"], func["param4"], func["param5"]);
	}
	if(isdefined(self.spawn_funcs))
	{
		for(i = 0; i < self.spawn_funcs.size; i++)
		{
			func = self.spawn_funcs[i];
			util::single_thread(self, func["function"], func["param1"], func["param2"], func["param3"], func["param4"]);
		}
		/#
			self.saved_spawn_functions = self.spawn_funcs;
		#/
		self.spawn_funcs = undefined;
		/#
			self.spawn_funcs = self.saved_spawn_functions;
			self.saved_spawn_functions = undefined;
		#/
		self.spawn_funcs = undefined;
	}
}

/*
	Name: create_simple_hud
	Namespace: zm_utility
	Checksum: 0x761DECAF
	Offset: 0x16F8
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function create_simple_hud(client, team)
{
	if(isdefined(team))
	{
		hud = newteamhudelem(team);
		hud.team = team;
	}
	else
	{
		if(isdefined(client))
		{
			hud = newclienthudelem(client);
		}
		else
		{
			hud = newhudelem();
		}
	}
	level.hudelem_count++;
	hud.foreground = 1;
	hud.sort = 1;
	hud.hidewheninmenu = 0;
	return hud;
}

/*
	Name: destroy_hud
	Namespace: zm_utility
	Checksum: 0xC427F137
	Offset: 0x17E0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function destroy_hud()
{
	level.hudelem_count--;
	self destroy();
}

/*
	Name: all_chunks_intact
	Namespace: zm_utility
	Checksum: 0xFFA3D479
	Offset: 0x1810
	Size: 0xE2
	Parameters: 2
	Flags: Linked
*/
function all_chunks_intact(barrier, barrier_chunks)
{
	if(isdefined(barrier.zbarrier))
	{
		pieces = barrier.zbarrier getzbarrierpieceindicesinstate("closed");
		if(pieces.size != barrier.zbarrier getnumzbarrierpieces())
		{
			return false;
		}
	}
	else
	{
		for(i = 0; i < barrier_chunks.size; i++)
		{
			if(barrier_chunks[i] get_chunk_state() != "repaired")
			{
				return false;
			}
		}
	}
	return true;
}

/*
	Name: no_valid_repairable_boards
	Namespace: zm_utility
	Checksum: 0xF8AE108F
	Offset: 0x1900
	Size: 0xC2
	Parameters: 2
	Flags: Linked
*/
function no_valid_repairable_boards(barrier, barrier_chunks)
{
	if(isdefined(barrier.zbarrier))
	{
		pieces = barrier.zbarrier getzbarrierpieceindicesinstate("open");
		if(pieces.size)
		{
			return false;
		}
	}
	else
	{
		for(i = 0; i < barrier_chunks.size; i++)
		{
			if(barrier_chunks[i] get_chunk_state() == "destroyed")
			{
				return false;
			}
		}
	}
	return true;
}

/*
	Name: is_survival
	Namespace: zm_utility
	Checksum: 0x241752A8
	Offset: 0x19D0
	Size: 0x6
	Parameters: 0
	Flags: None
*/
function is_survival()
{
	return false;
}

/*
	Name: is_encounter
	Namespace: zm_utility
	Checksum: 0xDD378116
	Offset: 0x19E0
	Size: 0x6
	Parameters: 0
	Flags: None
*/
function is_encounter()
{
	return false;
}

/*
	Name: all_chunks_destroyed
	Namespace: zm_utility
	Checksum: 0x4875FB61
	Offset: 0x19F0
	Size: 0x14A
	Parameters: 2
	Flags: Linked
*/
function all_chunks_destroyed(barrier, barrier_chunks)
{
	if(isdefined(barrier.zbarrier))
	{
		pieces = arraycombine(barrier.zbarrier getzbarrierpieceindicesinstate("open"), barrier.zbarrier getzbarrierpieceindicesinstate("opening"), 1, 0);
		if(pieces.size != barrier.zbarrier getnumzbarrierpieces())
		{
			return false;
		}
	}
	else if(isdefined(barrier_chunks))
	{
		/#
			assert(isdefined(barrier_chunks), "");
		#/
		for(i = 0; i < barrier_chunks.size; i++)
		{
			if(barrier_chunks[i] get_chunk_state() != "destroyed")
			{
				return false;
			}
		}
	}
	return true;
}

/*
	Name: check_point_in_playable_area
	Namespace: zm_utility
	Checksum: 0xED174E11
	Offset: 0x1B48
	Size: 0x10E
	Parameters: 1
	Flags: Linked
*/
function check_point_in_playable_area(origin)
{
	playable_area = getentarray("player_volume", "script_noteworthy");
	if(!isdefined(level.check_model))
	{
		level.check_model = spawn("script_model", origin + vectorscale((0, 0, 1), 40));
	}
	else
	{
		level.check_model.origin = origin + vectorscale((0, 0, 1), 40);
	}
	valid_point = 0;
	for(i = 0; i < playable_area.size; i++)
	{
		if(level.check_model istouching(playable_area[i]))
		{
			valid_point = 1;
		}
	}
	return valid_point;
}

/*
	Name: check_point_in_enabled_zone
	Namespace: zm_utility
	Checksum: 0xF97A89EB
	Offset: 0x1C60
	Size: 0x1E0
	Parameters: 3
	Flags: Linked
*/
function check_point_in_enabled_zone(origin, zone_is_active, player_zones = getentarray("player_volume", "script_noteworthy"))
{
	if(!isdefined(level.zones) || !isdefined(player_zones))
	{
		return 1;
	}
	if(!isdefined(level.e_check_point))
	{
		level.e_check_point = spawn("script_origin", origin + vectorscale((0, 0, 1), 40));
	}
	else
	{
		level.e_check_point.origin = origin + vectorscale((0, 0, 1), 40);
	}
	one_valid_zone = 0;
	for(i = 0; i < player_zones.size; i++)
	{
		if(level.e_check_point istouching(player_zones[i]))
		{
			zone = level.zones[player_zones[i].targetname];
			if(isdefined(zone) && (isdefined(zone.is_enabled) && zone.is_enabled))
			{
				if(isdefined(zone_is_active) && zone_is_active == 1 && (!(isdefined(zone.is_active) && zone.is_active)))
				{
					continue;
				}
				one_valid_zone = 1;
				break;
			}
		}
	}
	return one_valid_zone;
}

/*
	Name: round_up_to_ten
	Namespace: zm_utility
	Checksum: 0x9049A9CE
	Offset: 0x1E48
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function round_up_to_ten(score)
{
	new_score = score - (score % 10);
	if(new_score < score)
	{
		new_score = new_score + 10;
	}
	return new_score;
}

/*
	Name: round_up_score
	Namespace: zm_utility
	Checksum: 0xEEE93FD0
	Offset: 0x1EA0
	Size: 0x70
	Parameters: 2
	Flags: Linked
*/
function round_up_score(score, value)
{
	score = int(score);
	new_score = score - (score % value);
	if(new_score < score)
	{
		new_score = new_score + value;
	}
	return new_score;
}

/*
	Name: halve_score
	Namespace: zm_utility
	Checksum: 0xD3C43031
	Offset: 0x1F18
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function halve_score(n_score)
{
	n_score = n_score / 2;
	n_score = round_up_score(n_score, 10);
	return n_score;
}

/*
	Name: random_tan
	Namespace: zm_utility
	Checksum: 0x3454E594
	Offset: 0x1F60
	Size: 0x56
	Parameters: 0
	Flags: None
*/
function random_tan()
{
	rand = randomint(100);
	if(isdefined(level.char_percent_override))
	{
		percentnotcharred = level.char_percent_override;
	}
	else
	{
		percentnotcharred = 65;
	}
}

/*
	Name: places_before_decimal
	Namespace: zm_utility
	Checksum: 0x4101ED4C
	Offset: 0x1FC0
	Size: 0x82
	Parameters: 1
	Flags: None
*/
function places_before_decimal(num)
{
	abs_num = abs(num);
	count = 0;
	while(true)
	{
		abs_num = abs_num * 0.1;
		count = count + 1;
		if(abs_num < 1)
		{
			return count;
		}
	}
}

/*
	Name: create_zombie_point_of_interest
	Namespace: zm_utility
	Checksum: 0x6D6A2E61
	Offset: 0x2050
	Size: 0x1DC
	Parameters: 7
	Flags: Linked
*/
function create_zombie_point_of_interest(attract_dist, num_attractors, added_poi_value, start_turned_on, initial_attract_func, arrival_attract_func, poi_team)
{
	if(!isdefined(added_poi_value))
	{
		self.added_poi_value = 0;
	}
	else
	{
		self.added_poi_value = added_poi_value;
	}
	if(!isdefined(start_turned_on))
	{
		start_turned_on = 1;
	}
	if(!isdefined(attract_dist))
	{
		attract_dist = 1536;
	}
	self.script_noteworthy = "zombie_poi";
	self.poi_active = start_turned_on;
	if(isdefined(attract_dist))
	{
		self.max_attractor_dist = attract_dist;
		self.poi_radius = attract_dist * attract_dist;
	}
	else
	{
		self.poi_radius = undefined;
	}
	self.num_poi_attracts = num_attractors;
	self.attract_to_origin = 1;
	self.attractor_array = [];
	self.initial_attract_func = undefined;
	self.arrival_attract_func = undefined;
	if(isdefined(poi_team))
	{
		self._team = poi_team;
	}
	if(isdefined(initial_attract_func))
	{
		self.initial_attract_func = initial_attract_func;
	}
	if(isdefined(arrival_attract_func))
	{
		self.arrival_attract_func = arrival_attract_func;
	}
	if(!isdefined(level.zombie_poi_array))
	{
		level.zombie_poi_array = [];
	}
	else if(!isarray(level.zombie_poi_array))
	{
		level.zombie_poi_array = array(level.zombie_poi_array);
	}
	level.zombie_poi_array[level.zombie_poi_array.size] = self;
	self thread watch_for_poi_death();
}

/*
	Name: watch_for_poi_death
	Namespace: zm_utility
	Checksum: 0x7C5F4587
	Offset: 0x2238
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function watch_for_poi_death()
{
	self waittill(#"death");
	if(isinarray(level.zombie_poi_array, self))
	{
		arrayremovevalue(level.zombie_poi_array, self);
	}
}

/*
	Name: debug_draw_new_attractor_positions
	Namespace: zm_utility
	Checksum: 0xDDC51697
	Offset: 0x2290
	Size: 0x138
	Parameters: 0
	Flags: None
*/
function debug_draw_new_attractor_positions()
{
	self endon(#"death");
	while(true)
	{
		foreach(attract in self.attractor_positions)
		{
			passed = bullettracepassed(attract[0] + vectorscale((0, 0, 1), 24), self.origin + vectorscale((0, 0, 1), 24), 0, self);
			if(passed)
			{
				/#
					debugstar(attract[0], 6, (1, 1, 1));
				#/
				continue;
			}
			/#
				debugstar(attract[0], 6, (1, 0, 0));
			#/
		}
		wait(0.05);
	}
}

/*
	Name: create_zombie_point_of_interest_attractor_positions
	Namespace: zm_utility
	Checksum: 0xB0F50C
	Offset: 0x23D0
	Size: 0x2EA
	Parameters: 2
	Flags: Linked
*/
function create_zombie_point_of_interest_attractor_positions(num_attract_dists, attract_dist)
{
	self endon(#"death");
	if(!isdefined(self.num_poi_attracts) || (isdefined(self.script_noteworthy) && self.script_noteworthy != "zombie_poi"))
	{
		return;
	}
	if(!isdefined(num_attract_dists))
	{
		num_attract_dists = 4;
	}
	queryresult = positionquery_source_navigation(self.origin, attract_dist / 2, self.max_attractor_dist, attract_dist / 2, attract_dist / 2, 1, attract_dist / 2);
	if(queryresult.data.size < self.num_poi_attracts)
	{
		self.num_poi_attracts = queryresult.data.size;
	}
	for(i = 0; i < self.num_poi_attracts; i++)
	{
		if(isdefined(level.validate_poi_attractors) && level.validate_poi_attractors)
		{
			passed = bullettracepassed(queryresult.data[i].origin + vectorscale((0, 0, 1), 24), self.origin + vectorscale((0, 0, 1), 24), 0, self);
			if(passed)
			{
				self.attractor_positions[i][0] = queryresult.data[i].origin;
				self.attractor_positions[i][1] = self;
			}
			continue;
		}
		self.attractor_positions[i][0] = queryresult.data[i].origin;
		self.attractor_positions[i][1] = self;
	}
	if(!isdefined(self.attractor_positions))
	{
		self.attractor_positions = [];
	}
	self.num_attract_dists = num_attract_dists;
	self.last_index = [];
	for(i = 0; i < num_attract_dists; i++)
	{
		self.last_index[i] = -1;
	}
	self.last_index[0] = 1;
	self.last_index[1] = self.attractor_positions.size;
	self.attract_to_origin = 0;
	self notify(#"attractor_positions_generated");
	level notify(#"attractor_positions_generated");
}

/*
	Name: generated_radius_attract_positions
	Namespace: zm_utility
	Checksum: 0x67ECF780
	Offset: 0x26C8
	Size: 0x41C
	Parameters: 4
	Flags: None
*/
function generated_radius_attract_positions(forward, offset, num_positions, attract_radius)
{
	self endon(#"death");
	epsilon = 1;
	failed = 0;
	degs_per_pos = 360 / num_positions;
	i = offset;
	while(i < (360 + offset))
	{
		altforward = forward * attract_radius;
		rotated_forward = ((cos(i) * altforward[0]) - (sin(i) * altforward[1]), (sin(i) * altforward[0]) + (cos(i) * altforward[1]), altforward[2]);
		if(isdefined(level.poi_positioning_func))
		{
			pos = [[level.poi_positioning_func]](self.origin, rotated_forward);
		}
		else
		{
			if(isdefined(level.use_alternate_poi_positioning) && level.use_alternate_poi_positioning)
			{
				pos = zm_server_throttle::server_safe_ground_trace("poi_trace", 10, (self.origin + rotated_forward) + vectorscale((0, 0, 1), 10));
			}
			else
			{
				pos = zm_server_throttle::server_safe_ground_trace("poi_trace", 10, (self.origin + rotated_forward) + vectorscale((0, 0, 1), 100));
			}
		}
		if(!isdefined(pos))
		{
			failed++;
		}
		else
		{
			if(isdefined(level.use_alternate_poi_positioning) && level.use_alternate_poi_positioning)
			{
				if(isdefined(self) && isdefined(self.origin))
				{
					if(self.origin[2] >= (pos[2] - epsilon) && (self.origin[2] - pos[2]) <= 150)
					{
						pos_array = [];
						pos_array[0] = pos;
						pos_array[1] = self;
						if(!isdefined(self.attractor_positions))
						{
							self.attractor_positions = [];
						}
						else if(!isarray(self.attractor_positions))
						{
							self.attractor_positions = array(self.attractor_positions);
						}
						self.attractor_positions[self.attractor_positions.size] = pos_array;
					}
				}
				else
				{
					failed++;
				}
			}
			else
			{
				if((abs(pos[2] - self.origin[2])) < 60)
				{
					pos_array = [];
					pos_array[0] = pos;
					pos_array[1] = self;
					if(!isdefined(self.attractor_positions))
					{
						self.attractor_positions = [];
					}
					else if(!isarray(self.attractor_positions))
					{
						self.attractor_positions = array(self.attractor_positions);
					}
					self.attractor_positions[self.attractor_positions.size] = pos_array;
				}
				else
				{
					failed++;
				}
			}
		}
		i = i + degs_per_pos;
	}
	return failed;
}

/*
	Name: debug_draw_attractor_positions
	Namespace: zm_utility
	Checksum: 0x288D4205
	Offset: 0x2AF0
	Size: 0xA6
	Parameters: 0
	Flags: None
*/
function debug_draw_attractor_positions()
{
	/#
		while(true)
		{
			while(!isdefined(self.attractor_positions))
			{
				wait(0.05);
				continue;
			}
			for(i = 0; i < self.attractor_positions.size; i++)
			{
				line(self.origin, self.attractor_positions[i][0], (1, 0, 0), 1, 1);
			}
			wait(0.05);
			if(!isdefined(self))
			{
				return;
			}
		}
	#/
}

/*
	Name: debug_draw_claimed_attractor_positions
	Namespace: zm_utility
	Checksum: 0x7763F05
	Offset: 0x2BA0
	Size: 0xA6
	Parameters: 0
	Flags: None
*/
function debug_draw_claimed_attractor_positions()
{
	/#
		while(true)
		{
			while(!isdefined(self.claimed_attractor_positions))
			{
				wait(0.05);
				continue;
			}
			for(i = 0; i < self.claimed_attractor_positions.size; i++)
			{
				line(self.origin, self.claimed_attractor_positions[i][0], (0, 1, 0), 1, 1);
			}
			wait(0.05);
			if(!isdefined(self))
			{
				return;
			}
		}
	#/
}

/*
	Name: get_zombie_point_of_interest
	Namespace: zm_utility
	Checksum: 0xEA120FE1
	Offset: 0x2C50
	Size: 0x530
	Parameters: 2
	Flags: Linked
*/
function get_zombie_point_of_interest(origin, poi_array)
{
	aiprofile_beginentry("get_zombie_point_of_interest");
	if(isdefined(self.ignore_all_poi) && self.ignore_all_poi)
	{
		aiprofile_endentry();
		return undefined;
	}
	curr_radius = undefined;
	if(isdefined(poi_array))
	{
		ent_array = poi_array;
	}
	else
	{
		ent_array = level.zombie_poi_array;
	}
	best_poi = undefined;
	position = undefined;
	best_dist = 100000000;
	for(i = 0; i < ent_array.size; i++)
	{
		if(!isdefined(ent_array[i]) || !isdefined(ent_array[i].poi_active) || !ent_array[i].poi_active)
		{
			continue;
		}
		if(isdefined(self.ignore_poi_targetname) && self.ignore_poi_targetname.size > 0)
		{
			if(isdefined(ent_array[i].targetname))
			{
				ignore = 0;
				for(j = 0; j < self.ignore_poi_targetname.size; j++)
				{
					if(ent_array[i].targetname == self.ignore_poi_targetname[j])
					{
						ignore = 1;
						break;
					}
				}
				if(ignore)
				{
					continue;
				}
			}
		}
		if(isdefined(self.ignore_poi) && self.ignore_poi.size > 0)
		{
			ignore = 0;
			for(j = 0; j < self.ignore_poi.size; j++)
			{
				if(self.ignore_poi[j] == ent_array[i])
				{
					ignore = 1;
					break;
				}
			}
			if(ignore)
			{
				continue;
			}
		}
		dist = distancesquared(origin, ent_array[i].origin);
		dist = dist - ent_array[i].added_poi_value;
		if(isdefined(ent_array[i].poi_radius))
		{
			curr_radius = ent_array[i].poi_radius;
		}
		if(!isdefined(curr_radius) || dist < curr_radius && dist < best_dist && ent_array[i] can_attract(self))
		{
			best_poi = ent_array[i];
			best_dist = dist;
		}
	}
	if(isdefined(best_poi))
	{
		if(isdefined(best_poi._team))
		{
			if(isdefined(self._race_team) && self._race_team != best_poi._team)
			{
				aiprofile_endentry();
				return undefined;
			}
		}
		if(isdefined(best_poi._new_ground_trace) && best_poi._new_ground_trace)
		{
			position = [];
			position[0] = groundpos_ignore_water_new(best_poi.origin + vectorscale((0, 0, 1), 100));
			position[1] = self;
		}
		else
		{
			if(isdefined(best_poi.attract_to_origin) && best_poi.attract_to_origin)
			{
				position = [];
				position[0] = groundpos(best_poi.origin + vectorscale((0, 0, 1), 100));
				position[1] = self;
			}
			else
			{
				position = self add_poi_attractor(best_poi);
			}
		}
		if(isdefined(best_poi.initial_attract_func))
		{
			self thread [[best_poi.initial_attract_func]](best_poi);
		}
		if(isdefined(best_poi.arrival_attract_func))
		{
			self thread [[best_poi.arrival_attract_func]](best_poi);
		}
	}
	aiprofile_endentry();
	return position;
}

/*
	Name: activate_zombie_point_of_interest
	Namespace: zm_utility
	Checksum: 0x88BFFDC9
	Offset: 0x3188
	Size: 0x28
	Parameters: 0
	Flags: None
*/
function activate_zombie_point_of_interest()
{
	if(self.script_noteworthy != "zombie_poi")
	{
		return;
	}
	self.poi_active = 1;
}

/*
	Name: deactivate_zombie_point_of_interest
	Namespace: zm_utility
	Checksum: 0x14EB05D6
	Offset: 0x31B8
	Size: 0x104
	Parameters: 1
	Flags: None
*/
function deactivate_zombie_point_of_interest(dont_remove)
{
	if(self.script_noteworthy != "zombie_poi")
	{
		return;
	}
	self.attractor_array = array::remove_undefined(self.attractor_array);
	for(i = 0; i < self.attractor_array.size; i++)
	{
		self.attractor_array[i] notify(#"kill_poi");
	}
	self.attractor_array = [];
	self.claimed_attractor_positions = [];
	self.poi_active = 0;
	if(isdefined(dont_remove) && dont_remove)
	{
		return;
	}
	if(isdefined(self))
	{
		if(isinarray(level.zombie_poi_array, self))
		{
			arrayremovevalue(level.zombie_poi_array, self);
		}
	}
}

/*
	Name: assign_zombie_point_of_interest
	Namespace: zm_utility
	Checksum: 0x4A173F7E
	Offset: 0x32C8
	Size: 0x118
	Parameters: 2
	Flags: None
*/
function assign_zombie_point_of_interest(origin, poi)
{
	position = undefined;
	doremovalthread = 0;
	if(isdefined(poi) && poi can_attract(self))
	{
		if(!isdefined(poi.attractor_array) || (isdefined(poi.attractor_array) && !isinarray(poi.attractor_array, self)))
		{
			doremovalthread = 1;
		}
		position = self add_poi_attractor(poi);
		if(isdefined(position) && doremovalthread && isinarray(poi.attractor_array, self))
		{
			self thread update_on_poi_removal(poi);
		}
	}
	return position;
}

/*
	Name: remove_poi_attractor
	Namespace: zm_utility
	Checksum: 0xEDEDF9F
	Offset: 0x33E8
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function remove_poi_attractor(zombie_poi)
{
	if(!isdefined(zombie_poi) || !isdefined(zombie_poi.attractor_array))
	{
		return;
	}
	for(i = 0; i < zombie_poi.attractor_array.size; i++)
	{
		if(zombie_poi.attractor_array[i] == self)
		{
			arrayremovevalue(zombie_poi.attractor_array, zombie_poi.attractor_array[i]);
			arrayremovevalue(zombie_poi.claimed_attractor_positions, zombie_poi.claimed_attractor_positions[i]);
			if(isdefined(self))
			{
				self notify(#"kill_poi");
			}
		}
	}
}

/*
	Name: array_check_for_dupes_using_compare
	Namespace: zm_utility
	Checksum: 0x7C474BCF
	Offset: 0x34E8
	Size: 0x6A
	Parameters: 3
	Flags: Linked
*/
function array_check_for_dupes_using_compare(array, single, is_equal_fn)
{
	for(i = 0; i < array.size; i++)
	{
		if([[is_equal_fn]](array[i], single))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: poi_locations_equal
	Namespace: zm_utility
	Checksum: 0xCF9FC028
	Offset: 0x3560
	Size: 0x26
	Parameters: 2
	Flags: Linked
*/
function poi_locations_equal(loc1, loc2)
{
	return loc1[0] == loc2[0];
}

/*
	Name: add_poi_attractor
	Namespace: zm_utility
	Checksum: 0xDC1A79BB
	Offset: 0x3590
	Size: 0x54A
	Parameters: 1
	Flags: Linked
*/
function add_poi_attractor(zombie_poi)
{
	if(!isdefined(zombie_poi))
	{
		return;
	}
	if(!isdefined(zombie_poi.attractor_array))
	{
		zombie_poi.attractor_array = [];
	}
	if(!isinarray(zombie_poi.attractor_array, self))
	{
		if(!isdefined(zombie_poi.claimed_attractor_positions))
		{
			zombie_poi.claimed_attractor_positions = [];
		}
		if(!isdefined(zombie_poi.attractor_positions) || zombie_poi.attractor_positions.size <= 0)
		{
			return undefined;
		}
		start = -1;
		end = -1;
		last_index = -1;
		for(i = 0; i < 4; i++)
		{
			if(zombie_poi.claimed_attractor_positions.size < zombie_poi.last_index[i])
			{
				start = last_index + 1;
				end = zombie_poi.last_index[i];
				break;
			}
			last_index = zombie_poi.last_index[i];
		}
		best_dist = 100000000;
		best_pos = undefined;
		if(start < 0)
		{
			start = 0;
		}
		if(end < 0)
		{
			return undefined;
		}
		for(i = int(start); i <= int(end); i++)
		{
			if(!isdefined(zombie_poi.attractor_positions[i]))
			{
				continue;
			}
			if(array_check_for_dupes_using_compare(zombie_poi.claimed_attractor_positions, zombie_poi.attractor_positions[i], &poi_locations_equal))
			{
				if(isdefined(zombie_poi.attractor_positions[i][0]) && isdefined(self.origin))
				{
					dist = distancesquared(zombie_poi.attractor_positions[i][0], zombie_poi.origin);
					if(dist < best_dist || !isdefined(best_pos))
					{
						best_dist = dist;
						best_pos = zombie_poi.attractor_positions[i];
					}
				}
			}
		}
		if(!isdefined(best_pos))
		{
			if(isdefined(level.validate_poi_attractors) && level.validate_poi_attractors)
			{
				valid_pos = [];
				valid_pos[0] = zombie_poi.origin;
				valid_pos[1] = zombie_poi;
				return valid_pos;
			}
			return undefined;
		}
		if(!isdefined(zombie_poi.attractor_array))
		{
			zombie_poi.attractor_array = [];
		}
		else if(!isarray(zombie_poi.attractor_array))
		{
			zombie_poi.attractor_array = array(zombie_poi.attractor_array);
		}
		zombie_poi.attractor_array[zombie_poi.attractor_array.size] = self;
		self thread update_poi_on_death(zombie_poi);
		if(!isdefined(zombie_poi.claimed_attractor_positions))
		{
			zombie_poi.claimed_attractor_positions = [];
		}
		else if(!isarray(zombie_poi.claimed_attractor_positions))
		{
			zombie_poi.claimed_attractor_positions = array(zombie_poi.claimed_attractor_positions);
		}
		zombie_poi.claimed_attractor_positions[zombie_poi.claimed_attractor_positions.size] = best_pos;
		return best_pos;
	}
	for(i = 0; i < zombie_poi.attractor_array.size; i++)
	{
		if(zombie_poi.attractor_array[i] == self)
		{
			if(isdefined(zombie_poi.claimed_attractor_positions) && isdefined(zombie_poi.claimed_attractor_positions[i]))
			{
				return zombie_poi.claimed_attractor_positions[i];
			}
		}
	}
	return undefined;
}

/*
	Name: can_attract
	Namespace: zm_utility
	Checksum: 0xC76EABDD
	Offset: 0x3AE8
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function can_attract(attractor)
{
	if(!isdefined(self.attractor_array))
	{
		self.attractor_array = [];
	}
	if(isdefined(self.attracted_array) && !isinarray(self.attracted_array, attractor))
	{
		return false;
	}
	if(isinarray(self.attractor_array, attractor))
	{
		return true;
	}
	if(isdefined(self.num_poi_attracts) && self.attractor_array.size >= self.num_poi_attracts)
	{
		return false;
	}
	return true;
}

/*
	Name: update_poi_on_death
	Namespace: zm_utility
	Checksum: 0x5F1F3A17
	Offset: 0x3B98
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function update_poi_on_death(zombie_poi)
{
	self endon(#"kill_poi");
	self waittill(#"death");
	self remove_poi_attractor(zombie_poi);
}

/*
	Name: update_on_poi_removal
	Namespace: zm_utility
	Checksum: 0x96DA4CCA
	Offset: 0x3BE0
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function update_on_poi_removal(zombie_poi)
{
	zombie_poi waittill(#"death");
	if(!isdefined(zombie_poi.attractor_array))
	{
		return;
	}
	for(i = 0; i < zombie_poi.attractor_array.size; i++)
	{
		if(zombie_poi.attractor_array[i] == self)
		{
			arrayremoveindex(zombie_poi.attractor_array, i);
			arrayremoveindex(zombie_poi.claimed_attractor_positions, i);
		}
	}
}

/*
	Name: invalidate_attractor_pos
	Namespace: zm_utility
	Checksum: 0xB9961F3
	Offset: 0x3CA8
	Size: 0x1FA
	Parameters: 2
	Flags: Linked
*/
function invalidate_attractor_pos(attractor_pos, zombie)
{
	if(!isdefined(self) || !isdefined(attractor_pos))
	{
		wait(0.1);
		return undefined;
	}
	if(isdefined(self.attractor_positions) && !array_check_for_dupes_using_compare(self.attractor_positions, attractor_pos, &poi_locations_equal))
	{
		index = 0;
		for(i = 0; i < self.attractor_positions.size; i++)
		{
			if(poi_locations_equal(self.attractor_positions[i], attractor_pos))
			{
				index = i;
			}
		}
		for(i = 0; i < self.last_index.size; i++)
		{
			if(index <= self.last_index[i])
			{
				self.last_index[i]--;
			}
		}
		arrayremovevalue(self.attractor_array, zombie);
		arrayremovevalue(self.attractor_positions, attractor_pos);
		for(i = 0; i < self.claimed_attractor_positions.size; i++)
		{
			if(self.claimed_attractor_positions[i][0] == attractor_pos[0])
			{
				arrayremovevalue(self.claimed_attractor_positions, self.claimed_attractor_positions[i]);
			}
		}
	}
	else
	{
		wait(0.1);
	}
	return get_zombie_point_of_interest(zombie.origin);
}

/*
	Name: remove_poi_from_ignore_list
	Namespace: zm_utility
	Checksum: 0xE9B98D76
	Offset: 0x3EB0
	Size: 0x90
	Parameters: 1
	Flags: None
*/
function remove_poi_from_ignore_list(poi)
{
	if(isdefined(self.ignore_poi) && self.ignore_poi.size > 0)
	{
		for(i = 0; i < self.ignore_poi.size; i++)
		{
			if(self.ignore_poi[i] == poi)
			{
				arrayremovevalue(self.ignore_poi, self.ignore_poi[i]);
				return;
			}
		}
	}
}

/*
	Name: add_poi_to_ignore_list
	Namespace: zm_utility
	Checksum: 0x7373BC3C
	Offset: 0x3F48
	Size: 0xB6
	Parameters: 1
	Flags: None
*/
function add_poi_to_ignore_list(poi)
{
	if(!isdefined(self.ignore_poi))
	{
		self.ignore_poi = [];
	}
	add_poi = 1;
	if(self.ignore_poi.size > 0)
	{
		for(i = 0; i < self.ignore_poi.size; i++)
		{
			if(self.ignore_poi[i] == poi)
			{
				add_poi = 0;
				break;
			}
		}
	}
	if(add_poi)
	{
		self.ignore_poi[self.ignore_poi.size] = poi;
	}
}

/*
	Name: default_validate_enemy_path_length
	Namespace: zm_utility
	Checksum: 0x7D93802E
	Offset: 0x4008
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function default_validate_enemy_path_length(player)
{
	max_dist = 1296;
	d = distancesquared(self.origin, player.origin);
	if(d <= max_dist)
	{
		return true;
	}
	return false;
}

/*
	Name: get_closest_valid_player
	Namespace: zm_utility
	Checksum: 0x541595AE
	Offset: 0x4078
	Size: 0x426
	Parameters: 2
	Flags: Linked
*/
function get_closest_valid_player(origin, ignore_player)
{
	aiprofile_beginentry("get_closest_valid_player");
	valid_player_found = 0;
	players = getplayers();
	if(isdefined(level.get_closest_valid_player_override))
	{
		players = [[level.get_closest_valid_player_override]]();
	}
	b_designated_target_exists = 0;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!player.am_i_valid)
		{
			continue;
		}
		if(isdefined(level.evaluate_zone_path_override))
		{
			if(![[level.evaluate_zone_path_override]](player))
			{
				array::add(ignore_player, player);
			}
		}
		if(isdefined(player.b_is_designated_target) && player.b_is_designated_target)
		{
			b_designated_target_exists = 1;
		}
	}
	if(isdefined(ignore_player))
	{
		for(i = 0; i < ignore_player.size; i++)
		{
			arrayremovevalue(players, ignore_player[i]);
		}
	}
	done = 0;
	while(players.size && !done)
	{
		done = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player.am_i_valid)
			{
				arrayremovevalue(players, player);
				done = 0;
				break;
			}
			if(b_designated_target_exists && (!(isdefined(player.b_is_designated_target) && player.b_is_designated_target)))
			{
				arrayremovevalue(players, player);
				done = 0;
				break;
			}
		}
	}
	if(players.size == 0)
	{
		aiprofile_endentry();
		return undefined;
	}
	if(!valid_player_found)
	{
		for(;;)
		{
			player = [[self.closest_player_override]](origin, players);
			player = [[level.closest_player_override]](origin, players);
			player = arraygetclosest(origin, players);
			aiprofile_endentry();
			return undefined;
			aiprofile_endentry();
			return player;
			arrayremovevalue(players, player);
			aiprofile_endentry();
			return undefined;
		}
		if(isdefined(self.closest_player_override))
		{
		}
		else
		{
			if(isdefined(level.closest_player_override))
			{
			}
			else
			{
			}
		}
		if(!isdefined(player) || players.size == 0)
		{
		}
		if(isdefined(level.allow_zombie_to_target_ai) && level.allow_zombie_to_target_ai || (isdefined(player.allow_zombie_to_target_ai) && player.allow_zombie_to_target_ai))
		{
		}
		if(!player.am_i_valid)
		{
			if(players.size == 0)
			{
			}
		}
		aiprofile_endentry();
		return player;
	}
}

/*
	Name: update_valid_players
	Namespace: zm_utility
	Checksum: 0xC37D6F04
	Offset: 0x44A8
	Size: 0x3AC
	Parameters: 2
	Flags: Linked
*/
function update_valid_players(origin, ignore_player)
{
	aiprofile_beginentry("update_valid_players");
	valid_player_found = 0;
	players = arraycopy(level.players);
	foreach(player in players)
	{
		self setignoreent(player, 1);
	}
	b_designated_target_exists = 0;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!player.am_i_valid)
		{
			continue;
		}
		if(isdefined(level.evaluate_zone_path_override))
		{
			if(![[level.evaluate_zone_path_override]](player))
			{
				array::add(ignore_player, player);
			}
		}
		if(isdefined(player.b_is_designated_target) && player.b_is_designated_target)
		{
			b_designated_target_exists = 1;
		}
	}
	if(isdefined(ignore_player))
	{
		for(i = 0; i < ignore_player.size; i++)
		{
			arrayremovevalue(players, ignore_player[i]);
		}
	}
	done = 0;
	while(players.size && !done)
	{
		done = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player.am_i_valid)
			{
				arrayremovevalue(players, player);
				done = 0;
				break;
			}
			if(b_designated_target_exists && (!(isdefined(player.b_is_designated_target) && player.b_is_designated_target)))
			{
				arrayremovevalue(players, player);
				done = 0;
				break;
			}
		}
	}
	foreach(player in players)
	{
		self setignoreent(player, 0);
		self getperfectinfo(player);
	}
	aiprofile_endentry();
}

/*
	Name: is_player_valid
	Namespace: zm_utility
	Checksum: 0xAECDD28F
	Offset: 0x4860
	Size: 0x170
	Parameters: 3
	Flags: Linked
*/
function is_player_valid(player, checkignoremeflag, ignore_laststand_players)
{
	if(!isdefined(player))
	{
		return 0;
	}
	if(!isalive(player))
	{
		return 0;
	}
	if(!isplayer(player))
	{
		return 0;
	}
	if(isdefined(player.is_zombie) && player.is_zombie == 1)
	{
		return 0;
	}
	if(player.sessionstate == "spectator")
	{
		return 0;
	}
	if(player.sessionstate == "intermission")
	{
		return 0;
	}
	if(isdefined(level.intermission) && level.intermission)
	{
		return 0;
	}
	if(!(isdefined(ignore_laststand_players) && ignore_laststand_players))
	{
		if(player laststand::player_is_in_laststand())
		{
			return 0;
		}
	}
	if(isdefined(checkignoremeflag) && checkignoremeflag && player.ignoreme)
	{
		return 0;
	}
	if(isdefined(level.is_player_valid_override))
	{
		return [[level.is_player_valid_override]](player);
	}
	return 1;
}

/*
	Name: get_number_of_valid_players
	Namespace: zm_utility
	Checksum: 0x75A045C2
	Offset: 0x49D8
	Size: 0x8C
	Parameters: 0
	Flags: None
*/
function get_number_of_valid_players()
{
	players = getplayers();
	num_player_valid = 0;
	for(i = 0; i < players.size; i++)
	{
		if(is_player_valid(players[i]))
		{
			num_player_valid = num_player_valid + 1;
		}
	}
	return num_player_valid;
}

/*
	Name: in_revive_trigger
	Namespace: zm_utility
	Checksum: 0x9E27BCA8
	Offset: 0x4A70
	Size: 0x10A
	Parameters: 0
	Flags: Linked
*/
function in_revive_trigger()
{
	if(isdefined(self.rt_time) && (self.rt_time + 100) >= gettime())
	{
		return self.in_rt_cached;
	}
	self.rt_time = gettime();
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		current_player = players[i];
		if(isdefined(current_player) && isdefined(current_player.revivetrigger) && isalive(current_player))
		{
			if(self istouching(current_player.revivetrigger))
			{
				self.in_rt_cached = 1;
				return 1;
			}
		}
	}
	self.in_rt_cached = 0;
	return 0;
}

/*
	Name: get_closest_node
	Namespace: zm_utility
	Checksum: 0x415A86E4
	Offset: 0x4B88
	Size: 0x2A
	Parameters: 2
	Flags: None
*/
function get_closest_node(org, nodes)
{
	return arraygetclosest(org, nodes);
}

/*
	Name: non_destroyed_bar_board_order
	Namespace: zm_utility
	Checksum: 0xA6B3C1DA
	Offset: 0x4BC0
	Size: 0x526
	Parameters: 2
	Flags: Linked
*/
function non_destroyed_bar_board_order(origin, chunks)
{
	first_bars = [];
	first_bars1 = [];
	first_bars2 = [];
	for(i = 0; i < chunks.size; i++)
	{
		if(isdefined(chunks[i].script_team) && chunks[i].script_team == "classic_boards")
		{
			if(isdefined(chunks[i].script_parameters) && chunks[i].script_parameters == "board")
			{
				return get_closest_2d(origin, chunks);
			}
			if(isdefined(chunks[i].script_team) && chunks[i].script_team == "bar_board_variant1" || chunks[i].script_team == "bar_board_variant2" || chunks[i].script_team == "bar_board_variant4" || chunks[i].script_team == "bar_board_variant5")
			{
				return undefined;
			}
			continue;
		}
		if(isdefined(chunks[i].script_team) && chunks[i].script_team == "new_barricade")
		{
			if(isdefined(chunks[i].script_parameters) && (chunks[i].script_parameters == "repair_board" || chunks[i].script_parameters == "barricade_vents"))
			{
				return get_closest_2d(origin, chunks);
			}
		}
	}
	for(i = 0; i < chunks.size; i++)
	{
		if(isdefined(chunks[i].script_team) && chunks[i].script_team == "6_bars_bent" || chunks[i].script_team == "6_bars_prestine")
		{
			if(isdefined(chunks[i].script_parameters) && chunks[i].script_parameters == "bar")
			{
				if(isdefined(chunks[i].script_noteworthy))
				{
					if(chunks[i].script_noteworthy == "4" || chunks[i].script_noteworthy == "6")
					{
						first_bars[first_bars.size] = chunks[i];
					}
				}
			}
		}
	}
	for(i = 0; i < first_bars.size; i++)
	{
		if(isdefined(chunks[i].script_team) && chunks[i].script_team == "6_bars_bent" || chunks[i].script_team == "6_bars_prestine")
		{
			if(isdefined(chunks[i].script_parameters) && chunks[i].script_parameters == "bar")
			{
				if(!first_bars[i].destroyed)
				{
					return first_bars[i];
				}
			}
		}
	}
	for(i = 0; i < chunks.size; i++)
	{
		if(isdefined(chunks[i].script_team) && chunks[i].script_team == "6_bars_bent" || chunks[i].script_team == "6_bars_prestine")
		{
			if(isdefined(chunks[i].script_parameters) && chunks[i].script_parameters == "bar")
			{
				if(!chunks[i].destroyed)
				{
					return get_closest_2d(origin, chunks);
				}
			}
		}
	}
}

/*
	Name: non_destroyed_grate_order
	Namespace: zm_utility
	Checksum: 0xD18DDB2B
	Offset: 0x50F0
	Size: 0x572
	Parameters: 2
	Flags: Linked
*/
function non_destroyed_grate_order(origin, chunks_grate)
{
	grate_order = [];
	grate_order1 = [];
	grate_order2 = [];
	grate_order3 = [];
	grate_order4 = [];
	grate_order5 = [];
	grate_order6 = [];
	if(isdefined(chunks_grate))
	{
		for(i = 0; i < chunks_grate.size; i++)
		{
			if(isdefined(chunks_grate[i].script_parameters) && chunks_grate[i].script_parameters == "grate")
			{
				if(isdefined(chunks_grate[i].script_noteworthy) && chunks_grate[i].script_noteworthy == "1")
				{
					grate_order1[grate_order1.size] = chunks_grate[i];
				}
				if(isdefined(chunks_grate[i].script_noteworthy) && chunks_grate[i].script_noteworthy == "2")
				{
					grate_order2[grate_order2.size] = chunks_grate[i];
				}
				if(isdefined(chunks_grate[i].script_noteworthy) && chunks_grate[i].script_noteworthy == "3")
				{
					grate_order3[grate_order3.size] = chunks_grate[i];
				}
				if(isdefined(chunks_grate[i].script_noteworthy) && chunks_grate[i].script_noteworthy == "4")
				{
					grate_order4[grate_order4.size] = chunks_grate[i];
				}
				if(isdefined(chunks_grate[i].script_noteworthy) && chunks_grate[i].script_noteworthy == "5")
				{
					grate_order5[grate_order5.size] = chunks_grate[i];
				}
				if(isdefined(chunks_grate[i].script_noteworthy) && chunks_grate[i].script_noteworthy == "6")
				{
					grate_order6[grate_order6.size] = chunks_grate[i];
				}
			}
		}
		for(i = 0; i < chunks_grate.size; i++)
		{
			if(isdefined(chunks_grate[i].script_parameters) && chunks_grate[i].script_parameters == "grate")
			{
				if(isdefined(grate_order1[i]))
				{
					if(grate_order1[i].state == "repaired")
					{
						grate_order2[i] thread show_grate_pull();
						return grate_order1[i];
					}
					if(grate_order2[i].state == "repaired")
					{
						/#
							iprintlnbold("");
						#/
						grate_order3[i] thread show_grate_pull();
						return grate_order2[i];
					}
					if(grate_order3[i].state == "repaired")
					{
						/#
							iprintlnbold("");
						#/
						grate_order4[i] thread show_grate_pull();
						return grate_order3[i];
					}
					if(grate_order4[i].state == "repaired")
					{
						/#
							iprintlnbold("");
						#/
						grate_order5[i] thread show_grate_pull();
						return grate_order4[i];
					}
					if(grate_order5[i].state == "repaired")
					{
						/#
							iprintlnbold("");
						#/
						grate_order6[i] thread show_grate_pull();
						return grate_order5[i];
					}
					if(grate_order6[i].state == "repaired")
					{
						return grate_order6[i];
					}
				}
			}
		}
	}
}

/*
	Name: non_destroyed_variant1_order
	Namespace: zm_utility
	Checksum: 0xCD013428
	Offset: 0x5670
	Size: 0x3E2
	Parameters: 2
	Flags: None
*/
function non_destroyed_variant1_order(origin, chunks_variant1)
{
	variant1_order = [];
	variant1_order1 = [];
	variant1_order2 = [];
	variant1_order3 = [];
	variant1_order4 = [];
	variant1_order5 = [];
	variant1_order6 = [];
	if(isdefined(chunks_variant1))
	{
		for(i = 0; i < chunks_variant1.size; i++)
		{
			if(isdefined(chunks_variant1[i].script_team) && chunks_variant1[i].script_team == "bar_board_variant1")
			{
				if(isdefined(chunks_variant1[i].script_noteworthy))
				{
					if(chunks_variant1[i].script_noteworthy == "1")
					{
						variant1_order1[variant1_order1.size] = chunks_variant1[i];
					}
					if(chunks_variant1[i].script_noteworthy == "2")
					{
						variant1_order2[variant1_order2.size] = chunks_variant1[i];
					}
					if(chunks_variant1[i].script_noteworthy == "3")
					{
						variant1_order3[variant1_order3.size] = chunks_variant1[i];
					}
					if(chunks_variant1[i].script_noteworthy == "4")
					{
						variant1_order4[variant1_order4.size] = chunks_variant1[i];
					}
					if(chunks_variant1[i].script_noteworthy == "5")
					{
						variant1_order5[variant1_order5.size] = chunks_variant1[i];
					}
					if(chunks_variant1[i].script_noteworthy == "6")
					{
						variant1_order6[variant1_order6.size] = chunks_variant1[i];
					}
				}
			}
		}
		for(i = 0; i < chunks_variant1.size; i++)
		{
			if(isdefined(chunks_variant1[i].script_team) && chunks_variant1[i].script_team == "bar_board_variant1")
			{
				if(isdefined(variant1_order2[i]))
				{
					if(variant1_order2[i].state == "repaired")
					{
						return variant1_order2[i];
					}
					if(variant1_order3[i].state == "repaired")
					{
						return variant1_order3[i];
					}
					if(variant1_order4[i].state == "repaired")
					{
						return variant1_order4[i];
					}
					if(variant1_order6[i].state == "repaired")
					{
						return variant1_order6[i];
					}
					if(variant1_order5[i].state == "repaired")
					{
						return variant1_order5[i];
					}
					if(variant1_order1[i].state == "repaired")
					{
						return variant1_order1[i];
					}
				}
			}
		}
	}
}

/*
	Name: non_destroyed_variant2_order
	Namespace: zm_utility
	Checksum: 0x93E2A8E2
	Offset: 0x5A60
	Size: 0x4CA
	Parameters: 2
	Flags: None
*/
function non_destroyed_variant2_order(origin, chunks_variant2)
{
	variant2_order = [];
	variant2_order1 = [];
	variant2_order2 = [];
	variant2_order3 = [];
	variant2_order4 = [];
	variant2_order5 = [];
	variant2_order6 = [];
	if(isdefined(chunks_variant2))
	{
		for(i = 0; i < chunks_variant2.size; i++)
		{
			if(isdefined(chunks_variant2[i].script_team) && chunks_variant2[i].script_team == "bar_board_variant2")
			{
				if(isdefined(chunks_variant2[i].script_noteworthy) && chunks_variant2[i].script_noteworthy == "1")
				{
					variant2_order1[variant2_order1.size] = chunks_variant2[i];
				}
				if(isdefined(chunks_variant2[i].script_noteworthy) && chunks_variant2[i].script_noteworthy == "2")
				{
					variant2_order2[variant2_order2.size] = chunks_variant2[i];
				}
				if(isdefined(chunks_variant2[i].script_noteworthy) && chunks_variant2[i].script_noteworthy == "3")
				{
					variant2_order3[variant2_order3.size] = chunks_variant2[i];
				}
				if(isdefined(chunks_variant2[i].script_noteworthy) && chunks_variant2[i].script_noteworthy == "4")
				{
					variant2_order4[variant2_order4.size] = chunks_variant2[i];
				}
				if(isdefined(chunks_variant2[i].script_noteworthy) && chunks_variant2[i].script_noteworthy == "5" && isdefined(chunks_variant2[i].script_location) && chunks_variant2[i].script_location == "5")
				{
					variant2_order5[variant2_order5.size] = chunks_variant2[i];
				}
				if(isdefined(chunks_variant2[i].script_noteworthy) && chunks_variant2[i].script_noteworthy == "5" && isdefined(chunks_variant2[i].script_location) && chunks_variant2[i].script_location == "6")
				{
					variant2_order6[variant2_order6.size] = chunks_variant2[i];
				}
			}
		}
		for(i = 0; i < chunks_variant2.size; i++)
		{
			if(isdefined(chunks_variant2[i].script_team) && chunks_variant2[i].script_team == "bar_board_variant2")
			{
				if(isdefined(variant2_order1[i]))
				{
					if(variant2_order1[i].state == "repaired")
					{
						return variant2_order1[i];
					}
					if(variant2_order2[i].state == "repaired")
					{
						return variant2_order2[i];
					}
					if(variant2_order3[i].state == "repaired")
					{
						return variant2_order3[i];
					}
					if(variant2_order5[i].state == "repaired")
					{
						return variant2_order5[i];
					}
					if(variant2_order4[i].state == "repaired")
					{
						return variant2_order4[i];
					}
					if(variant2_order6[i].state == "repaired")
					{
						return variant2_order6[i];
					}
				}
			}
		}
	}
}

/*
	Name: non_destroyed_variant4_order
	Namespace: zm_utility
	Checksum: 0x4FCA0746
	Offset: 0x5F38
	Size: 0x4AE
	Parameters: 2
	Flags: None
*/
function non_destroyed_variant4_order(origin, chunks_variant4)
{
	variant4_order = [];
	variant4_order1 = [];
	variant4_order2 = [];
	variant4_order3 = [];
	variant4_order4 = [];
	variant4_order5 = [];
	variant4_order6 = [];
	if(isdefined(chunks_variant4))
	{
		for(i = 0; i < chunks_variant4.size; i++)
		{
			if(isdefined(chunks_variant4[i].script_team) && chunks_variant4[i].script_team == "bar_board_variant4")
			{
				if(isdefined(chunks_variant4[i].script_noteworthy) && chunks_variant4[i].script_noteworthy == "1" && !isdefined(chunks_variant4[i].script_location))
				{
					variant4_order1[variant4_order1.size] = chunks_variant4[i];
				}
				if(isdefined(chunks_variant4[i].script_noteworthy) && chunks_variant4[i].script_noteworthy == "2")
				{
					variant4_order2[variant4_order2.size] = chunks_variant4[i];
				}
				if(isdefined(chunks_variant4[i].script_noteworthy) && chunks_variant4[i].script_noteworthy == "3")
				{
					variant4_order3[variant4_order3.size] = chunks_variant4[i];
				}
				if(isdefined(chunks_variant4[i].script_noteworthy) && chunks_variant4[i].script_noteworthy == "1" && isdefined(chunks_variant4[i].script_location) && chunks_variant4[i].script_location == "3")
				{
					variant4_order4[variant4_order4.size] = chunks_variant4[i];
				}
				if(isdefined(chunks_variant4[i].script_noteworthy) && chunks_variant4[i].script_noteworthy == "5")
				{
					variant4_order5[variant4_order5.size] = chunks_variant4[i];
				}
				if(isdefined(chunks_variant4[i].script_noteworthy) && chunks_variant4[i].script_noteworthy == "6")
				{
					variant4_order6[variant4_order6.size] = chunks_variant4[i];
				}
			}
		}
		for(i = 0; i < chunks_variant4.size; i++)
		{
			if(isdefined(chunks_variant4[i].script_team) && chunks_variant4[i].script_team == "bar_board_variant4")
			{
				if(isdefined(variant4_order1[i]))
				{
					if(variant4_order1[i].state == "repaired")
					{
						return variant4_order1[i];
					}
					if(variant4_order6[i].state == "repaired")
					{
						return variant4_order6[i];
					}
					if(variant4_order3[i].state == "repaired")
					{
						return variant4_order3[i];
					}
					if(variant4_order4[i].state == "repaired")
					{
						return variant4_order4[i];
					}
					if(variant4_order2[i].state == "repaired")
					{
						return variant4_order2[i];
					}
					if(variant4_order5[i].state == "repaired")
					{
						return variant4_order5[i];
					}
				}
			}
		}
	}
}

/*
	Name: non_destroyed_variant5_order
	Namespace: zm_utility
	Checksum: 0xBA240A11
	Offset: 0x63F0
	Size: 0x44E
	Parameters: 2
	Flags: None
*/
function non_destroyed_variant5_order(origin, chunks_variant5)
{
	variant5_order = [];
	variant5_order1 = [];
	variant5_order2 = [];
	variant5_order3 = [];
	variant5_order4 = [];
	variant5_order5 = [];
	variant5_order6 = [];
	if(isdefined(chunks_variant5))
	{
		for(i = 0; i < chunks_variant5.size; i++)
		{
			if(isdefined(chunks_variant5[i].script_team) && chunks_variant5[i].script_team == "bar_board_variant5")
			{
				if(isdefined(chunks_variant5[i].script_noteworthy))
				{
					if(chunks_variant5[i].script_noteworthy == "1" && !isdefined(chunks_variant5[i].script_location))
					{
						variant5_order1[variant5_order1.size] = chunks_variant5[i];
					}
					if(chunks_variant5[i].script_noteworthy == "2")
					{
						variant5_order2[variant5_order2.size] = chunks_variant5[i];
					}
					if(isdefined(chunks_variant5[i].script_noteworthy) && chunks_variant5[i].script_noteworthy == "1" && isdefined(chunks_variant5[i].script_location) && chunks_variant5[i].script_location == "3")
					{
						variant5_order3[variant5_order3.size] = chunks_variant5[i];
					}
					if(chunks_variant5[i].script_noteworthy == "4")
					{
						variant5_order4[variant5_order4.size] = chunks_variant5[i];
					}
					if(chunks_variant5[i].script_noteworthy == "5")
					{
						variant5_order5[variant5_order5.size] = chunks_variant5[i];
					}
					if(chunks_variant5[i].script_noteworthy == "6")
					{
						variant5_order6[variant5_order6.size] = chunks_variant5[i];
					}
				}
			}
		}
		for(i = 0; i < chunks_variant5.size; i++)
		{
			if(isdefined(chunks_variant5[i].script_team) && chunks_variant5[i].script_team == "bar_board_variant5")
			{
				if(isdefined(variant5_order1[i]))
				{
					if(variant5_order1[i].state == "repaired")
					{
						return variant5_order1[i];
					}
					if(variant5_order6[i].state == "repaired")
					{
						return variant5_order6[i];
					}
					if(variant5_order3[i].state == "repaired")
					{
						return variant5_order3[i];
					}
					if(variant5_order2[i].state == "repaired")
					{
						return variant5_order2[i];
					}
					if(variant5_order5[i].state == "repaired")
					{
						return variant5_order5[i];
					}
					if(variant5_order4[i].state == "repaired")
					{
						return variant5_order4[i];
					}
				}
			}
		}
	}
}

/*
	Name: show_grate_pull
	Namespace: zm_utility
	Checksum: 0xDEA660FA
	Offset: 0x6848
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function show_grate_pull()
{
	wait(0.53);
	self show();
	self vibrate(vectorscale((0, 1, 0), 270), 0.2, 0.4, 0.4);
}

/*
	Name: get_closest_2d
	Namespace: zm_utility
	Checksum: 0xE50A4DD9
	Offset: 0x68B0
	Size: 0x226
	Parameters: 2
	Flags: Linked
*/
function get_closest_2d(origin, ents)
{
	if(!isdefined(ents))
	{
		return undefined;
	}
	dist = distance2d(origin, ents[0].origin);
	index = 0;
	temp_array = [];
	for(i = 1; i < ents.size; i++)
	{
		if(isdefined(ents[i].unbroken) && ents[i].unbroken == 1)
		{
			ents[i].index = i;
			if(!isdefined(temp_array))
			{
				temp_array = [];
			}
			else if(!isarray(temp_array))
			{
				temp_array = array(temp_array);
			}
			temp_array[temp_array.size] = ents[i];
		}
	}
	if(temp_array.size > 0)
	{
		index = temp_array[randomintrange(0, temp_array.size)].index;
		return ents[index];
	}
	for(i = 1; i < ents.size; i++)
	{
		temp_dist = distance2d(origin, ents[i].origin);
		if(temp_dist < dist)
		{
			dist = temp_dist;
			index = i;
		}
	}
	return ents[index];
}

/*
	Name: in_playable_area
	Namespace: zm_utility
	Checksum: 0xE4F1D939
	Offset: 0x6AE0
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function in_playable_area()
{
	playable_area = getentarray("player_volume", "script_noteworthy");
	if(!isdefined(playable_area))
	{
		/#
			println("");
		#/
		return true;
	}
	for(i = 0; i < playable_area.size; i++)
	{
		if(self istouching(playable_area[i]))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: get_closest_non_destroyed_chunk
	Namespace: zm_utility
	Checksum: 0x327492CA
	Offset: 0x6B98
	Size: 0x126
	Parameters: 3
	Flags: Linked
*/
function get_closest_non_destroyed_chunk(origin, barrier, barrier_chunks)
{
	chunks = undefined;
	chunks_grate = undefined;
	chunks_grate = get_non_destroyed_chunks_grate(barrier, barrier_chunks);
	chunks = get_non_destroyed_chunks(barrier, barrier_chunks);
	if(isdefined(barrier.zbarrier))
	{
		if(isdefined(chunks))
		{
			return array::randomize(chunks)[0];
		}
		if(isdefined(chunks_grate))
		{
			return array::randomize(chunks_grate)[0];
		}
	}
	else
	{
		if(isdefined(chunks))
		{
			return non_destroyed_bar_board_order(origin, chunks);
		}
		if(isdefined(chunks_grate))
		{
			return non_destroyed_grate_order(origin, chunks_grate);
		}
	}
	return undefined;
}

/*
	Name: get_random_destroyed_chunk
	Namespace: zm_utility
	Checksum: 0x213F1F86
	Offset: 0x6CC8
	Size: 0x146
	Parameters: 2
	Flags: Linked
*/
function get_random_destroyed_chunk(barrier, barrier_chunks)
{
	if(isdefined(barrier.zbarrier))
	{
		ret = undefined;
		pieces = barrier.zbarrier getzbarrierpieceindicesinstate("open");
		if(pieces.size)
		{
			ret = array::randomize(pieces)[0];
		}
		return ret;
	}
	chunk = undefined;
	chunks_repair_grate = undefined;
	chunks = get_destroyed_chunks(barrier_chunks);
	chunks_repair_grate = get_destroyed_repair_grates(barrier_chunks);
	if(isdefined(chunks))
	{
		return chunks[randomint(chunks.size)];
	}
	if(isdefined(chunks_repair_grate))
	{
		return grate_order_destroyed(chunks_repair_grate);
	}
	return undefined;
}

/*
	Name: get_destroyed_repair_grates
	Namespace: zm_utility
	Checksum: 0x6F3CE155
	Offset: 0x6E18
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function get_destroyed_repair_grates(barrier_chunks)
{
	array = [];
	for(i = 0; i < barrier_chunks.size; i++)
	{
		if(isdefined(barrier_chunks[i]))
		{
			if(isdefined(barrier_chunks[i].script_parameters) && barrier_chunks[i].script_parameters == "grate")
			{
				array[array.size] = barrier_chunks[i];
			}
		}
	}
	if(array.size == 0)
	{
		return undefined;
	}
	return array;
}

/*
	Name: get_non_destroyed_chunks
	Namespace: zm_utility
	Checksum: 0x2120B009
	Offset: 0x6EE0
	Size: 0x43C
	Parameters: 2
	Flags: Linked
*/
function get_non_destroyed_chunks(barrier, barrier_chunks)
{
	if(isdefined(barrier.zbarrier))
	{
		return barrier.zbarrier getzbarrierpieceindicesinstate("closed");
	}
	array = [];
	for(i = 0; i < barrier_chunks.size; i++)
	{
		if(isdefined(barrier_chunks[i].script_team) && barrier_chunks[i].script_team == "classic_boards")
		{
			if(isdefined(barrier_chunks[i].script_parameters) && barrier_chunks[i].script_parameters == "board")
			{
				if(barrier_chunks[i] get_chunk_state() == "repaired")
				{
					if(barrier_chunks[i].origin == barrier_chunks[i].og_origin)
					{
						array[array.size] = barrier_chunks[i];
					}
				}
			}
		}
		if(isdefined(barrier_chunks[i].script_team) && barrier_chunks[i].script_team == "new_barricade")
		{
			if(isdefined(barrier_chunks[i].script_parameters) && (barrier_chunks[i].script_parameters == "repair_board" || barrier_chunks[i].script_parameters == "barricade_vents"))
			{
				if(barrier_chunks[i] get_chunk_state() == "repaired")
				{
					if(barrier_chunks[i].origin == barrier_chunks[i].og_origin)
					{
						array[array.size] = barrier_chunks[i];
					}
				}
			}
			continue;
		}
		if(isdefined(barrier_chunks[i].script_team) && barrier_chunks[i].script_team == "6_bars_bent")
		{
			if(isdefined(barrier_chunks[i].script_parameters) && barrier_chunks[i].script_parameters == "bar")
			{
				if(barrier_chunks[i] get_chunk_state() == "repaired")
				{
					if(barrier_chunks[i].origin == barrier_chunks[i].og_origin)
					{
						array[array.size] = barrier_chunks[i];
					}
				}
			}
			continue;
		}
		if(isdefined(barrier_chunks[i].script_team) && barrier_chunks[i].script_team == "6_bars_prestine")
		{
			if(isdefined(barrier_chunks[i].script_parameters) && barrier_chunks[i].script_parameters == "bar")
			{
				if(barrier_chunks[i] get_chunk_state() == "repaired")
				{
					if(barrier_chunks[i].origin == barrier_chunks[i].og_origin)
					{
						array[array.size] = barrier_chunks[i];
					}
				}
			}
		}
	}
	if(array.size == 0)
	{
		return undefined;
	}
	return array;
}

/*
	Name: get_non_destroyed_chunks_grate
	Namespace: zm_utility
	Checksum: 0x6524E5FE
	Offset: 0x7328
	Size: 0x100
	Parameters: 2
	Flags: Linked
*/
function get_non_destroyed_chunks_grate(barrier, barrier_chunks)
{
	if(isdefined(barrier.zbarrier))
	{
		return barrier.zbarrier getzbarrierpieceindicesinstate("closed");
	}
	array = [];
	for(i = 0; i < barrier_chunks.size; i++)
	{
		if(isdefined(barrier_chunks[i].script_parameters) && barrier_chunks[i].script_parameters == "grate")
		{
			if(isdefined(barrier_chunks[i]))
			{
				array[array.size] = barrier_chunks[i];
			}
		}
	}
	if(array.size == 0)
	{
		return undefined;
	}
	return array;
}

/*
	Name: get_non_destroyed_variant1
	Namespace: zm_utility
	Checksum: 0x9BABEDA9
	Offset: 0x7438
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function get_non_destroyed_variant1(barrier_chunks)
{
	array = [];
	for(i = 0; i < barrier_chunks.size; i++)
	{
		if(isdefined(barrier_chunks[i].script_team) && barrier_chunks[i].script_team == "bar_board_variant1")
		{
			if(isdefined(barrier_chunks[i]))
			{
				array[array.size] = barrier_chunks[i];
			}
		}
	}
	if(array.size == 0)
	{
		return undefined;
	}
	return array;
}

/*
	Name: get_non_destroyed_variant2
	Namespace: zm_utility
	Checksum: 0x8AEB0E58
	Offset: 0x7500
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function get_non_destroyed_variant2(barrier_chunks)
{
	array = [];
	for(i = 0; i < barrier_chunks.size; i++)
	{
		if(isdefined(barrier_chunks[i].script_team) && barrier_chunks[i].script_team == "bar_board_variant2")
		{
			if(isdefined(barrier_chunks[i]))
			{
				array[array.size] = barrier_chunks[i];
			}
		}
	}
	if(array.size == 0)
	{
		return undefined;
	}
	return array;
}

/*
	Name: get_non_destroyed_variant4
	Namespace: zm_utility
	Checksum: 0x6CEF1237
	Offset: 0x75C8
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function get_non_destroyed_variant4(barrier_chunks)
{
	array = [];
	for(i = 0; i < barrier_chunks.size; i++)
	{
		if(isdefined(barrier_chunks[i].script_team) && barrier_chunks[i].script_team == "bar_board_variant4")
		{
			if(isdefined(barrier_chunks[i]))
			{
				array[array.size] = barrier_chunks[i];
			}
		}
	}
	if(array.size == 0)
	{
		return undefined;
	}
	return array;
}

/*
	Name: get_non_destroyed_variant5
	Namespace: zm_utility
	Checksum: 0x58156E91
	Offset: 0x7690
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function get_non_destroyed_variant5(barrier_chunks)
{
	array = [];
	for(i = 0; i < barrier_chunks.size; i++)
	{
		if(isdefined(barrier_chunks[i].script_team) && barrier_chunks[i].script_team == "bar_board_variant5")
		{
			if(isdefined(barrier_chunks[i]))
			{
				array[array.size] = barrier_chunks[i];
			}
		}
	}
	if(array.size == 0)
	{
		return undefined;
	}
	return array;
}

/*
	Name: get_destroyed_chunks
	Namespace: zm_utility
	Checksum: 0x8872F7B1
	Offset: 0x7758
	Size: 0x1E0
	Parameters: 1
	Flags: Linked
*/
function get_destroyed_chunks(barrier_chunks)
{
	array = [];
	for(i = 0; i < barrier_chunks.size; i++)
	{
		if(barrier_chunks[i] get_chunk_state() == "destroyed")
		{
			if(isdefined(barrier_chunks[i].script_parameters) && barrier_chunks[i].script_parameters == "board")
			{
				array[array.size] = barrier_chunks[i];
				continue;
			}
			if(isdefined(barrier_chunks[i].script_parameters) && barrier_chunks[i].script_parameters == "repair_board" || barrier_chunks[i].script_parameters == "barricade_vents")
			{
				array[array.size] = barrier_chunks[i];
				continue;
			}
			if(isdefined(barrier_chunks[i].script_parameters) && barrier_chunks[i].script_parameters == "bar")
			{
				array[array.size] = barrier_chunks[i];
				continue;
			}
			if(isdefined(barrier_chunks[i].script_parameters) && barrier_chunks[i].script_parameters == "grate")
			{
				return undefined;
			}
		}
	}
	if(array.size == 0)
	{
		return undefined;
	}
	return array;
}

/*
	Name: grate_order_destroyed
	Namespace: zm_utility
	Checksum: 0x426B91CA
	Offset: 0x7940
	Size: 0x59A
	Parameters: 1
	Flags: Linked
*/
function grate_order_destroyed(chunks_repair_grate)
{
	grate_repair_order = [];
	grate_repair_order1 = [];
	grate_repair_order2 = [];
	grate_repair_order3 = [];
	grate_repair_order4 = [];
	grate_repair_order5 = [];
	grate_repair_order6 = [];
	for(i = 0; i < chunks_repair_grate.size; i++)
	{
		if(isdefined(chunks_repair_grate[i].script_parameters) && chunks_repair_grate[i].script_parameters == "grate")
		{
			if(isdefined(chunks_repair_grate[i].script_noteworthy) && chunks_repair_grate[i].script_noteworthy == "1")
			{
				grate_repair_order1[grate_repair_order1.size] = chunks_repair_grate[i];
			}
			if(isdefined(chunks_repair_grate[i].script_noteworthy) && chunks_repair_grate[i].script_noteworthy == "2")
			{
				grate_repair_order2[grate_repair_order2.size] = chunks_repair_grate[i];
			}
			if(isdefined(chunks_repair_grate[i].script_noteworthy) && chunks_repair_grate[i].script_noteworthy == "3")
			{
				grate_repair_order3[grate_repair_order3.size] = chunks_repair_grate[i];
			}
			if(isdefined(chunks_repair_grate[i].script_noteworthy) && chunks_repair_grate[i].script_noteworthy == "4")
			{
				grate_repair_order4[grate_repair_order4.size] = chunks_repair_grate[i];
			}
			if(isdefined(chunks_repair_grate[i].script_noteworthy) && chunks_repair_grate[i].script_noteworthy == "5")
			{
				grate_repair_order5[grate_repair_order5.size] = chunks_repair_grate[i];
			}
			if(isdefined(chunks_repair_grate[i].script_noteworthy) && chunks_repair_grate[i].script_noteworthy == "6")
			{
				grate_repair_order6[grate_repair_order6.size] = chunks_repair_grate[i];
			}
		}
	}
	for(i = 0; i < chunks_repair_grate.size; i++)
	{
		if(isdefined(chunks_repair_grate[i].script_parameters) && chunks_repair_grate[i].script_parameters == "grate")
		{
			if(isdefined(grate_repair_order1[i]))
			{
				if(grate_repair_order6[i].state == "destroyed")
				{
					/#
						iprintlnbold("");
					#/
					return grate_repair_order6[i];
				}
				if(grate_repair_order5[i].state == "destroyed")
				{
					/#
						iprintlnbold("");
					#/
					grate_repair_order6[i] thread show_grate_repair();
					return grate_repair_order5[i];
				}
				if(grate_repair_order4[i].state == "destroyed")
				{
					/#
						iprintlnbold("");
					#/
					grate_repair_order5[i] thread show_grate_repair();
					return grate_repair_order4[i];
				}
				if(grate_repair_order3[i].state == "destroyed")
				{
					/#
						iprintlnbold("");
					#/
					grate_repair_order4[i] thread show_grate_repair();
					return grate_repair_order3[i];
				}
				if(grate_repair_order2[i].state == "destroyed")
				{
					/#
						iprintlnbold("");
					#/
					grate_repair_order3[i] thread show_grate_repair();
					return grate_repair_order2[i];
				}
				if(grate_repair_order1[i].state == "destroyed")
				{
					/#
						iprintlnbold("");
					#/
					grate_repair_order2[i] thread show_grate_repair();
					return grate_repair_order1[i];
				}
			}
		}
	}
}

/*
	Name: show_grate_repair
	Namespace: zm_utility
	Checksum: 0xDA45EF16
	Offset: 0x7EE8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function show_grate_repair()
{
	wait(0.34);
	self hide();
}

/*
	Name: get_chunk_state
	Namespace: zm_utility
	Checksum: 0x4A8D599A
	Offset: 0x7F18
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function get_chunk_state()
{
	/#
		assert(isdefined(self.state));
	#/
	return self.state;
}

/*
	Name: array_limiter
	Namespace: zm_utility
	Checksum: 0x64F48742
	Offset: 0x7F50
	Size: 0x78
	Parameters: 2
	Flags: None
*/
function array_limiter(array, total)
{
	new_array = [];
	for(i = 0; i < array.size; i++)
	{
		if(i < total)
		{
			new_array[new_array.size] = array[i];
		}
	}
	return new_array;
}

/*
	Name: fake_physicslaunch
	Namespace: zm_utility
	Checksum: 0x698C9034
	Offset: 0x7FD0
	Size: 0x158
	Parameters: 2
	Flags: Linked
*/
function fake_physicslaunch(target_pos, power)
{
	start_pos = self.origin;
	gravity = getdvarint("bg_gravity") * -1;
	dist = distance(start_pos, target_pos);
	time = dist / power;
	delta = target_pos - start_pos;
	drop = (0.5 * gravity) * (time * time);
	velocity = (delta[0] / time, delta[1] / time, (delta[2] - drop) / time);
	level thread draw_line_ent_to_pos(self, target_pos);
	self movegravity(velocity, time);
	return time;
}

/*
	Name: add_zombie_hint
	Namespace: zm_utility
	Checksum: 0x4CB6CFEA
	Offset: 0x8130
	Size: 0x3E
	Parameters: 2
	Flags: Linked
*/
function add_zombie_hint(ref, text)
{
	if(!isdefined(level.zombie_hints))
	{
		level.zombie_hints = [];
	}
	level.zombie_hints[ref] = text;
}

/*
	Name: get_zombie_hint
	Namespace: zm_utility
	Checksum: 0xA997923D
	Offset: 0x8178
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function get_zombie_hint(ref)
{
	if(isdefined(level.zombie_hints[ref]))
	{
		return level.zombie_hints[ref];
	}
	/#
		println("" + ref);
	#/
	return level.zombie_hints["undefined"];
}

/*
	Name: set_hint_string
	Namespace: zm_utility
	Checksum: 0x74C84254
	Offset: 0x81E8
	Size: 0x114
	Parameters: 3
	Flags: Linked
*/
function set_hint_string(ent, default_ref, cost)
{
	ref = default_ref;
	if(isdefined(ent.script_hint))
	{
		ref = ent.script_hint;
	}
	if(isdefined(level.legacy_hint_system) && level.legacy_hint_system)
	{
		ref = (ref + "_") + cost;
		self sethintstring(get_zombie_hint(ref));
	}
	else
	{
		hint = get_zombie_hint(ref);
		if(isdefined(cost))
		{
			self sethintstring(hint, cost);
		}
		else
		{
			self sethintstring(hint);
		}
	}
}

/*
	Name: get_hint_string
	Namespace: zm_utility
	Checksum: 0x3AECF710
	Offset: 0x8308
	Size: 0xA2
	Parameters: 3
	Flags: Linked
*/
function get_hint_string(ent, default_ref, cost)
{
	ref = default_ref;
	if(isdefined(ent.script_hint))
	{
		ref = ent.script_hint;
	}
	if(isdefined(level.legacy_hint_system) && level.legacy_hint_system && isdefined(cost))
	{
		ref = (ref + "_") + cost;
	}
	return get_zombie_hint(ref);
}

/*
	Name: unitrigger_set_hint_string
	Namespace: zm_utility
	Checksum: 0xE2AE1476
	Offset: 0x83B8
	Size: 0x1CA
	Parameters: 3
	Flags: Linked
*/
function unitrigger_set_hint_string(ent, default_ref, cost)
{
	triggers = [];
	if(self.trigger_per_player)
	{
		triggers = self.playertrigger;
	}
	else
	{
		triggers[0] = self.trigger;
	}
	foreach(trigger in triggers)
	{
		ref = default_ref;
		if(isdefined(ent.script_hint))
		{
			ref = ent.script_hint;
		}
		if(isdefined(level.legacy_hint_system) && level.legacy_hint_system)
		{
			ref = (ref + "_") + cost;
			trigger sethintstring(get_zombie_hint(ref));
			continue;
		}
		hint = get_zombie_hint(ref);
		if(isdefined(cost))
		{
			trigger sethintstring(hint, cost);
			continue;
		}
		trigger sethintstring(hint);
	}
}

/*
	Name: add_sound
	Namespace: zm_utility
	Checksum: 0x46DE2BFD
	Offset: 0x8590
	Size: 0x3E
	Parameters: 2
	Flags: Linked
*/
function add_sound(ref, alias)
{
	if(!isdefined(level.zombie_sounds))
	{
		level.zombie_sounds = [];
	}
	level.zombie_sounds[ref] = alias;
}

/*
	Name: play_sound_at_pos
	Namespace: zm_utility
	Checksum: 0x2FDEA1CC
	Offset: 0x85D8
	Size: 0xF4
	Parameters: 3
	Flags: Linked
*/
function play_sound_at_pos(ref, pos, ent)
{
	if(isdefined(ent))
	{
		if(isdefined(ent.script_soundalias))
		{
			playsoundatposition(ent.script_soundalias, pos);
			return;
		}
		if(isdefined(self.script_sound))
		{
			ref = self.script_sound;
		}
	}
	if(ref == "none")
	{
		return;
	}
	if(!isdefined(level.zombie_sounds[ref]))
	{
		/#
			assertmsg(("" + ref) + "");
		#/
		return;
	}
	playsoundatposition(level.zombie_sounds[ref], pos);
}

/*
	Name: play_sound_on_ent
	Namespace: zm_utility
	Checksum: 0xF0CF55A
	Offset: 0x86D8
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function play_sound_on_ent(ref)
{
	if(isdefined(self.script_soundalias))
	{
		self playsound(self.script_soundalias);
		return;
	}
	if(isdefined(self.script_sound))
	{
		ref = self.script_sound;
	}
	if(ref == "none")
	{
		return;
	}
	if(!isdefined(level.zombie_sounds[ref]))
	{
		/#
			assertmsg(("" + ref) + "");
		#/
		return;
	}
	self playsound(level.zombie_sounds[ref]);
}

/*
	Name: play_loopsound_on_ent
	Namespace: zm_utility
	Checksum: 0x774419BC
	Offset: 0x87A8
	Size: 0x94
	Parameters: 1
	Flags: None
*/
function play_loopsound_on_ent(ref)
{
	if(isdefined(self.script_firefxsound))
	{
		ref = self.script_firefxsound;
	}
	if(ref == "none")
	{
		return;
	}
	if(!isdefined(level.zombie_sounds[ref]))
	{
		/#
			assertmsg(("" + ref) + "");
		#/
		return;
	}
	self playsound(level.zombie_sounds[ref]);
}

/*
	Name: string_to_float
	Namespace: zm_utility
	Checksum: 0xCE8C2BD
	Offset: 0x8848
	Size: 0x130
	Parameters: 1
	Flags: Linked
*/
function string_to_float(string)
{
	floatparts = strtok(string, ".");
	if(floatparts.size == 1)
	{
		return int(floatparts[0]);
	}
	whole = int(floatparts[0]);
	decimal = 0;
	for(i = floatparts[1].size - 1; i >= 0; i--)
	{
		decimal = (decimal / 10) + (int(floatparts[1][i]) / 10);
	}
	if(whole >= 0)
	{
		return whole + decimal;
	}
	return whole - decimal;
}

/*
	Name: set_zombie_var
	Namespace: zm_utility
	Checksum: 0x94956BD0
	Offset: 0x8988
	Size: 0x10A
	Parameters: 5
	Flags: None
*/
function set_zombie_var(zvar, value, is_float = 0, column = 1, is_team_based)
{
	if(isdefined(is_team_based) && is_team_based)
	{
		foreach(team in level.teams)
		{
			level.zombie_vars[team][zvar] = value;
		}
	}
	else
	{
		level.zombie_vars[zvar] = value;
	}
	return value;
}

/*
	Name: get_table_var
	Namespace: zm_utility
	Checksum: 0x97101071
	Offset: 0x8AA0
	Size: 0xFC
	Parameters: 5
	Flags: None
*/
function get_table_var(table = "mp/zombiemode.csv", var_d45c761e, value, is_float = 0, column = 1)
{
	table_value = tablelookup(table, 0, var_d45c761e, column);
	if(isdefined(table_value) && table_value != "")
	{
		if(is_float)
		{
			value = string_to_float(table_value);
		}
		else
		{
			value = int(table_value);
		}
	}
	return value;
}

/*
	Name: hudelem_count
	Namespace: zm_utility
	Checksum: 0xCB454D51
	Offset: 0x8BA8
	Size: 0x98
	Parameters: 0
	Flags: None
*/
function hudelem_count()
{
	/#
		max = 0;
		curr_total = 0;
		while(true)
		{
			if(level.hudelem_count > max)
			{
				max = level.hudelem_count;
			}
			println(((("" + level.hudelem_count) + "") + max) + "");
			wait(0.05);
		}
	#/
}

/*
	Name: debug_round_advancer
	Namespace: zm_utility
	Checksum: 0xB1D7B5F1
	Offset: 0x8C48
	Size: 0xA2
	Parameters: 0
	Flags: None
*/
function debug_round_advancer()
{
	/#
		while(true)
		{
			zombs = zombie_utility::get_round_enemy_array();
			for(i = 0; i < zombs.size; i++)
			{
				zombs[i] dodamage(zombs[i].health + 666, (0, 0, 0));
				wait(0.5);
			}
		}
	#/
}

/*
	Name: print_run_speed
	Namespace: zm_utility
	Checksum: 0xBF0283AA
	Offset: 0x8CF8
	Size: 0x60
	Parameters: 1
	Flags: None
*/
function print_run_speed(speed)
{
	/#
		self endon(#"death");
		while(true)
		{
			print3d(self.origin + vectorscale((0, 0, 1), 64), speed, (1, 1, 1));
			wait(0.05);
		}
	#/
}

/*
	Name: draw_line_ent_to_ent
	Namespace: zm_utility
	Checksum: 0x69DE6CBA
	Offset: 0x8D60
	Size: 0x98
	Parameters: 2
	Flags: None
*/
function draw_line_ent_to_ent(ent1, ent2)
{
	/#
		if(getdvarint("") != 1)
		{
			return;
		}
		ent1 endon(#"death");
		ent2 endon(#"death");
		while(true)
		{
			line(ent1.origin, ent2.origin);
			wait(0.05);
		}
	#/
}

/*
	Name: draw_line_ent_to_pos
	Namespace: zm_utility
	Checksum: 0x938E37E3
	Offset: 0x8E00
	Size: 0xB8
	Parameters: 3
	Flags: Linked
*/
function draw_line_ent_to_pos(ent, pos, end_on)
{
	/#
		if(getdvarint("") != 1)
		{
			return;
		}
		ent endon(#"death");
		ent notify(#"stop_draw_line_ent_to_pos");
		ent endon(#"stop_draw_line_ent_to_pos");
		if(isdefined(end_on))
		{
			ent endon(end_on);
		}
		while(true)
		{
			line(ent.origin, pos);
			wait(0.05);
		}
	#/
}

/*
	Name: debug_print
	Namespace: zm_utility
	Checksum: 0x3C45A5B4
	Offset: 0x8EC0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function debug_print(msg)
{
	/#
		if(getdvarint("") > 0)
		{
			println("" + msg);
		}
	#/
}

/*
	Name: debug_blocker
	Namespace: zm_utility
	Checksum: 0x41C863B
	Offset: 0x8F20
	Size: 0x88
	Parameters: 3
	Flags: Linked
*/
function debug_blocker(pos, rad, height)
{
	/#
		self notify(#"stop_debug_blocker");
		self endon(#"stop_debug_blocker");
		for(;;)
		{
			if(getdvarint("") != 1)
			{
				return;
			}
			wait(0.05);
			drawcylinder(pos, rad, height);
		}
	#/
}

/*
	Name: drawcylinder
	Namespace: zm_utility
	Checksum: 0x39BBEC13
	Offset: 0x8FB0
	Size: 0x25E
	Parameters: 3
	Flags: Linked
*/
function drawcylinder(pos, rad, height)
{
	/#
		currad = rad;
		curheight = height;
		for(r = 0; r < 20; r++)
		{
			theta = (r / 20) * 360;
			theta2 = ((r + 1) / 20) * 360;
			line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta2) * currad, sin(theta2) * currad, 0));
			line(pos + (cos(theta) * currad, sin(theta) * currad, curheight), pos + (cos(theta2) * currad, sin(theta2) * currad, curheight));
			line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta) * currad, sin(theta) * currad, curheight));
		}
	#/
}

/*
	Name: print3d_at_pos
	Namespace: zm_utility
	Checksum: 0x8C8147E9
	Offset: 0x9218
	Size: 0x98
	Parameters: 4
	Flags: None
*/
function print3d_at_pos(msg, pos, thread_endon, offset)
{
	/#
		self endon(#"death");
		if(isdefined(thread_endon))
		{
			self notify(thread_endon);
			self endon(thread_endon);
		}
		if(!isdefined(offset))
		{
			offset = (0, 0, 0);
		}
		while(true)
		{
			print3d(self.origin + offset, msg);
			wait(0.05);
		}
	#/
}

/*
	Name: debug_breadcrumbs
	Namespace: zm_utility
	Checksum: 0xACA53123
	Offset: 0x92B8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function debug_breadcrumbs()
{
	/#
		self endon(#"disconnect");
		self notify(#"stop_debug_breadcrumbs");
		self endon(#"stop_debug_breadcrumbs");
		while(true)
		{
			if(getdvarint("") != 1)
			{
				wait(1);
				continue;
			}
			for(i = 0; i < self.zombie_breadcrumbs.size; i++)
			{
				drawcylinder(self.zombie_breadcrumbs[i], 5, 5);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: debug_attack_spots_taken
	Namespace: zm_utility
	Checksum: 0x23466137
	Offset: 0x9388
	Size: 0x170
	Parameters: 0
	Flags: Linked
*/
function debug_attack_spots_taken()
{
	/#
		self notify(#"stop_debug_breadcrumbs");
		self endon(#"stop_debug_breadcrumbs");
		while(true)
		{
			if(getdvarint("") != 2)
			{
				wait(1);
				continue;
			}
			wait(0.05);
			count = 0;
			for(i = 0; i < self.attack_spots_taken.size; i++)
			{
				if(self.attack_spots_taken[i])
				{
					count++;
					circle(self.attack_spots[i], 12, (1, 0, 0), 0, 1, 1);
					continue;
				}
				circle(self.attack_spots[i], 12, (0, 1, 0), 0, 1, 1);
			}
			msg = (("" + count) + "") + self.attack_spots_taken.size;
			print3d(self.origin, msg);
		}
	#/
}

/*
	Name: float_print3d
	Namespace: zm_utility
	Checksum: 0x2F509A1
	Offset: 0x9500
	Size: 0xB0
	Parameters: 2
	Flags: None
*/
function float_print3d(msg, time)
{
	/#
		self endon(#"death");
		time = gettime() + (time * 1000);
		offset = vectorscale((0, 0, 1), 72);
		while(gettime() < time)
		{
			offset = offset + vectorscale((0, 0, 1), 2);
			print3d(self.origin + offset, msg, (1, 1, 1));
			wait(0.05);
		}
	#/
}

/*
	Name: do_player_vo
	Namespace: zm_utility
	Checksum: 0x920ACE36
	Offset: 0x95B8
	Size: 0x110
	Parameters: 2
	Flags: Linked
*/
function do_player_vo(snd, variation_count)
{
	index = get_player_index(self);
	sound = (("zmb_vox_plr_" + index) + "_") + snd;
	if(isdefined(variation_count))
	{
		sound = (sound + "_") + randomintrange(0, variation_count);
	}
	if(!isdefined(level.player_is_speaking))
	{
		level.player_is_speaking = 0;
	}
	if(level.player_is_speaking == 0)
	{
		level.player_is_speaking = 1;
		self playsoundwithnotify(sound, "sound_done");
		self waittill(#"sound_done");
		wait(2);
		level.player_is_speaking = 0;
	}
}

/*
	Name: is_magic_bullet_shield_enabled
	Namespace: zm_utility
	Checksum: 0x77637776
	Offset: 0x96D0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function is_magic_bullet_shield_enabled(ent)
{
	if(!isdefined(ent))
	{
		return 0;
	}
	return !(isdefined(ent.allowdeath) && ent.allowdeath);
}

/*
	Name: really_play_2d_sound
	Namespace: zm_utility
	Checksum: 0x832FB1DF
	Offset: 0x9718
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function really_play_2d_sound(sound)
{
	temp_ent = spawn("script_origin", (0, 0, 0));
	temp_ent playsoundwithnotify(sound, sound + "wait");
	temp_ent waittill(sound + "wait");
	wait(0.05);
	temp_ent delete();
}

/*
	Name: play_sound_2d
	Namespace: zm_utility
	Checksum: 0xAA70BACB
	Offset: 0x97B8
	Size: 0x24
	Parameters: 1
	Flags: None
*/
function play_sound_2d(sound)
{
	level thread really_play_2d_sound(sound);
}

/*
	Name: include_weapon
	Namespace: zm_utility
	Checksum: 0x84F5C297
	Offset: 0x97E8
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function include_weapon(weapon_name, in_box)
{
	/#
		println("" + weapon_name);
	#/
	if(!isdefined(in_box))
	{
		in_box = 1;
	}
	zm_weapons::include_zombie_weapon(weapon_name, in_box);
}

/*
	Name: trigger_invisible
	Namespace: zm_utility
	Checksum: 0x3761078A
	Offset: 0x9860
	Size: 0x86
	Parameters: 1
	Flags: None
*/
function trigger_invisible(enable)
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i]))
		{
			self setinvisibletoplayer(players[i], enable);
		}
	}
}

/*
	Name: print3d_ent
	Namespace: zm_utility
	Checksum: 0x438B81A2
	Offset: 0x98F0
	Size: 0x130
	Parameters: 6
	Flags: None
*/
function print3d_ent(text, color, scale, offset, end_msg, overwrite)
{
	self endon(#"death");
	if(isdefined(overwrite) && overwrite && isdefined(self._debug_print3d_msg))
	{
		self notify(#"end_print3d");
		wait(0.05);
	}
	self endon(#"end_print3d");
	if(!isdefined(color))
	{
		color = (1, 1, 1);
	}
	if(!isdefined(scale))
	{
		scale = 1;
	}
	if(!isdefined(offset))
	{
		offset = (0, 0, 0);
	}
	if(isdefined(end_msg))
	{
		self endon(end_msg);
	}
	self._debug_print3d_msg = text;
	/#
		while(!(isdefined(level.disable_print3d_ent) && level.disable_print3d_ent))
		{
			print3d(self.origin + offset, self._debug_print3d_msg, color, scale);
			wait(0.05);
		}
	#/
}

/*
	Name: create_counter_hud
	Namespace: zm_utility
	Checksum: 0xA9AD0278
	Offset: 0x9A28
	Size: 0x108
	Parameters: 1
	Flags: Linked
*/
function create_counter_hud(x = 0)
{
	hud = create_simple_hud();
	hud.alignx = "left";
	hud.aligny = "top";
	hud.horzalign = "user_left";
	hud.vertalign = "user_top";
	hud.color = (1, 1, 1);
	hud.fontscale = 32;
	hud.x = x;
	hud.alpha = 0;
	hud setshader("hud_chalk_1", 64, 64);
	return hud;
}

/*
	Name: get_current_zone
	Namespace: zm_utility
	Checksum: 0xA821E1A2
	Offset: 0x9B38
	Size: 0x280
	Parameters: 1
	Flags: Linked
*/
function get_current_zone(return_zone)
{
	level flag::wait_till("zones_initialized");
	if(isdefined(self.cached_zone))
	{
		zone = self.cached_zone;
		zone_name = self.cached_zone_name;
		vol = self.cached_zone_volume;
		if(self istouching(zone.volumes[vol]))
		{
			if(isdefined(return_zone) && return_zone)
			{
				return zone;
			}
			return zone_name;
		}
		for(i = 0; i < zone.volumes.size; i++)
		{
			if(i == vol)
			{
				continue;
			}
			if(self istouching(zone.volumes[i]))
			{
				self.cached_zone = zone;
				self.cached_zone_volume = i;
				if(isdefined(return_zone) && return_zone)
				{
					return zone;
				}
				return zone_name;
			}
		}
	}
	for(z = 0; z < level.zone_keys.size; z++)
	{
		zone_name = level.zone_keys[z];
		zone = level.zones[zone_name];
		if(zone === self.cached_zone)
		{
			continue;
		}
		for(i = 0; i < zone.volumes.size; i++)
		{
			if(self istouching(zone.volumes[i]))
			{
				self.cached_zone = zone;
				self.cached_zone_name = zone_name;
				self.cached_zone_volume = i;
				if(isdefined(return_zone) && return_zone)
				{
					return zone;
				}
				return zone_name;
			}
		}
	}
	self.cached_zone = undefined;
	self.cached_zone_name = undefined;
	self.cached_zone_volume = undefined;
	return undefined;
}

/*
	Name: remove_mod_from_methodofdeath
	Namespace: zm_utility
	Checksum: 0x167E6505
	Offset: 0x9DC0
	Size: 0x10
	Parameters: 1
	Flags: Linked
*/
function remove_mod_from_methodofdeath(mod)
{
	return mod;
}

/*
	Name: clear_fog_threads
	Namespace: zm_utility
	Checksum: 0xEECD7496
	Offset: 0x9DD8
	Size: 0x60
	Parameters: 0
	Flags: None
*/
function clear_fog_threads()
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] notify(#"stop_fog");
	}
}

/*
	Name: display_message
	Namespace: zm_utility
	Checksum: 0xD9243E55
	Offset: 0x9E40
	Size: 0xDC
	Parameters: 3
	Flags: None
*/
function display_message(titletext, notifytext, duration)
{
	notifydata = spawnstruct();
	notifydata.titletext = notifytext;
	notifydata.notifytext = titletext;
	notifydata.sound = "mus_level_up";
	notifydata.duration = duration;
	notifydata.glowcolor = (1, 0, 0);
	notifydata.color = (0, 0, 0);
	notifydata.iconname = "hud_zombies_meat";
	self thread hud_message::notifymessage(notifydata);
}

/*
	Name: is_quad
	Namespace: zm_utility
	Checksum: 0x53276972
	Offset: 0x9F28
	Size: 0x14
	Parameters: 0
	Flags: None
*/
function is_quad()
{
	return self.animname == "quad_zombie";
}

/*
	Name: is_leaper
	Namespace: zm_utility
	Checksum: 0xD24877F5
	Offset: 0x9F48
	Size: 0x14
	Parameters: 0
	Flags: None
*/
function is_leaper()
{
	return self.animname == "leaper_zombie";
}

/*
	Name: shock_onpain
	Namespace: zm_utility
	Checksum: 0x17591A5D
	Offset: 0x9F68
	Size: 0x298
	Parameters: 0
	Flags: Linked
*/
function shock_onpain()
{
	self endon(#"death");
	self endon(#"disconnect");
	self notify(#"stop_shock_onpain");
	self endon(#"stop_shock_onpain");
	if(getdvarstring("blurpain") == "")
	{
		setdvar("blurpain", "on");
	}
	while(true)
	{
		oldhealth = self.health;
		self waittill(#"damage", damage, attacker, direction_vec, point, mod);
		if(isdefined(level.shock_onpain) && !level.shock_onpain)
		{
			continue;
		}
		if(isdefined(self.shock_onpain) && !self.shock_onpain)
		{
			continue;
		}
		if(self.health < 1)
		{
			continue;
		}
		if(isdefined(attacker) && isdefined(attacker.custom_player_shellshock))
		{
			self [[attacker.custom_player_shellshock]](damage, attacker, direction_vec, point, mod);
		}
		else
		{
			if(mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH")
			{
				continue;
			}
			else
			{
				if(mod == "MOD_GRENADE_SPLASH" || mod == "MOD_GRENADE" || mod == "MOD_EXPLOSIVE")
				{
					shocktype = undefined;
					shocklight = undefined;
					if(isdefined(self.is_burning) && self.is_burning)
					{
						shocktype = "lava";
						shocklight = "lava_small";
					}
					self shock_onexplosion(damage, shocktype, shocklight);
				}
				else if(getdvarstring("blurpain") == "on")
				{
					self shellshock("pain_zm", 0.5);
				}
			}
		}
	}
}

/*
	Name: shock_onexplosion
	Namespace: zm_utility
	Checksum: 0xB5F5DF13
	Offset: 0xA208
	Size: 0x11C
	Parameters: 3
	Flags: Linked
*/
function shock_onexplosion(damage, shocktype, shocklight)
{
	time = 0;
	scaled_damage = (100 * damage) / self.maxhealth;
	if(scaled_damage >= 90)
	{
		time = 4;
	}
	else
	{
		if(scaled_damage >= 50)
		{
			time = 3;
		}
		else
		{
			if(scaled_damage >= 25)
			{
				time = 2;
			}
			else if(scaled_damage > 10)
			{
				time = 1;
			}
		}
	}
	if(time)
	{
		if(!isdefined(shocktype))
		{
			shocktype = "explosion";
		}
		self shellshock(shocktype, time);
	}
	else if(isdefined(shocklight))
	{
		self shellshock(shocklight, time);
	}
}

/*
	Name: increment_ignoreme
	Namespace: zm_utility
	Checksum: 0x321259FE
	Offset: 0xA330
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function increment_ignoreme()
{
	if(!isdefined(self.ignorme_count))
	{
		self.ignorme_count = 0;
	}
	self.ignorme_count++;
	self.ignoreme = self.ignorme_count > 0;
}

/*
	Name: decrement_ignoreme
	Namespace: zm_utility
	Checksum: 0xD00F29FA
	Offset: 0xA370
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function decrement_ignoreme()
{
	if(!isdefined(self.ignorme_count))
	{
		self.ignorme_count = 0;
	}
	if(self.ignorme_count > 0)
	{
		self.ignorme_count--;
	}
	else
	{
		/#
			assertmsg("");
		#/
	}
	self.ignoreme = self.ignorme_count > 0;
}

/*
	Name: increment_is_drinking
	Namespace: zm_utility
	Checksum: 0x34F04FB1
	Offset: 0xA3E0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function increment_is_drinking()
{
	/#
		if(isdefined(level.devgui_dpad_watch) && level.devgui_dpad_watch)
		{
			self.is_drinking++;
			return;
		}
	#/
	if(!isdefined(self.is_drinking))
	{
		self.is_drinking = 0;
	}
	if(self.is_drinking == 0)
	{
		self disableoffhandweapons();
		self disableweaponcycling();
	}
	self.is_drinking++;
}

/*
	Name: is_multiple_drinking
	Namespace: zm_utility
	Checksum: 0xFEE42F54
	Offset: 0xA470
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function is_multiple_drinking()
{
	return self.is_drinking > 1;
}

/*
	Name: decrement_is_drinking
	Namespace: zm_utility
	Checksum: 0xAAA24C8
	Offset: 0xA488
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function decrement_is_drinking()
{
	if(self.is_drinking > 0)
	{
		self.is_drinking--;
	}
	else
	{
		/#
			assertmsg("");
		#/
	}
	if(self.is_drinking == 0)
	{
		self enableoffhandweapons();
		self enableweaponcycling();
	}
}

/*
	Name: clear_is_drinking
	Namespace: zm_utility
	Checksum: 0xF2506F3C
	Offset: 0xA508
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function clear_is_drinking()
{
	self.is_drinking = 0;
	self enableoffhandweapons();
	self enableweaponcycling();
}

/*
	Name: increment_no_end_game_check
	Namespace: zm_utility
	Checksum: 0x3C0CABFC
	Offset: 0xA550
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function increment_no_end_game_check()
{
	if(!isdefined(level.n_no_end_game_check_count))
	{
		level.n_no_end_game_check_count = 0;
	}
	level.n_no_end_game_check_count++;
	level.no_end_game_check = level.n_no_end_game_check_count > 0;
}

/*
	Name: decrement_no_end_game_check
	Namespace: zm_utility
	Checksum: 0xC823487F
	Offset: 0xA590
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function decrement_no_end_game_check()
{
	if(!isdefined(level.n_no_end_game_check_count))
	{
		level.n_no_end_game_check_count = 0;
	}
	if(level.n_no_end_game_check_count > 0)
	{
		level.n_no_end_game_check_count--;
	}
	else
	{
		/#
			assertmsg("");
		#/
	}
	level.no_end_game_check = level.n_no_end_game_check_count > 0;
	if(!level.no_end_game_check)
	{
		level zm::checkforalldead();
	}
}

/*
	Name: getweaponclasszm
	Namespace: zm_utility
	Checksum: 0x49129836
	Offset: 0xA620
	Size: 0xFE
	Parameters: 1
	Flags: Linked
*/
function getweaponclasszm(weapon)
{
	/#
		assert(isdefined(weapon));
	#/
	if(!isdefined(weapon))
	{
		return undefined;
	}
	if(!isdefined(level.weaponclassarray))
	{
		level.weaponclassarray = [];
	}
	if(isdefined(level.weaponclassarray[weapon]))
	{
		return level.weaponclassarray[weapon];
	}
	baseweaponindex = getbaseweaponitemindex(weapon);
	statstablename = util::getstatstablename();
	weaponclass = tablelookup(statstablename, 0, baseweaponindex, 2);
	level.weaponclassarray[weapon] = weaponclass;
	return weaponclass;
}

/*
	Name: spawn_weapon_model
	Namespace: zm_utility
	Checksum: 0xE3CA3E64
	Offset: 0xA728
	Size: 0xE0
	Parameters: 5
	Flags: Linked
*/
function spawn_weapon_model(weapon, model = weapon.worldmodel, origin, angles, options)
{
	weapon_model = spawn("script_model", origin);
	if(isdefined(angles))
	{
		weapon_model.angles = angles;
	}
	if(isdefined(options))
	{
		weapon_model useweaponmodel(weapon, model, options);
	}
	else
	{
		weapon_model useweaponmodel(weapon, model);
	}
	return weapon_model;
}

/*
	Name: spawn_buildkit_weapon_model
	Namespace: zm_utility
	Checksum: 0x55A91752
	Offset: 0xA810
	Size: 0xF8
	Parameters: 5
	Flags: Linked
*/
function spawn_buildkit_weapon_model(player, weapon, camo, origin, angles)
{
	weapon_model = spawn("script_model", origin);
	if(isdefined(angles))
	{
		weapon_model.angles = angles;
	}
	upgraded = zm_weapons::is_weapon_upgraded(weapon);
	if(upgraded && (!isdefined(camo) || 0 > camo))
	{
		camo = zm_weapons::get_pack_a_punch_camo_index(undefined);
	}
	weapon_model usebuildkitweaponmodel(player, weapon, camo, upgraded);
	return weapon_model;
}

/*
	Name: is_player_revive_tool
	Namespace: zm_utility
	Checksum: 0x1976A915
	Offset: 0xA910
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function is_player_revive_tool(weapon)
{
	if(weapon == level.weaponrevivetool || weapon === self.weaponrevivetool)
	{
		return true;
	}
	return false;
}

/*
	Name: is_limited_weapon
	Namespace: zm_utility
	Checksum: 0xDB3E9B7D
	Offset: 0xA950
	Size: 0x32
	Parameters: 1
	Flags: None
*/
function is_limited_weapon(weapon)
{
	if(isdefined(level.limited_weapons) && isdefined(level.limited_weapons[weapon]))
	{
		return true;
	}
	return false;
}

/*
	Name: register_lethal_grenade_for_level
	Namespace: zm_utility
	Checksum: 0x2E67D168
	Offset: 0xA990
	Size: 0x72
	Parameters: 1
	Flags: Linked
*/
function register_lethal_grenade_for_level(weaponname)
{
	weapon = getweapon(weaponname);
	if(is_lethal_grenade(weapon))
	{
		return;
	}
	if(!isdefined(level.zombie_lethal_grenade_list))
	{
		level.zombie_lethal_grenade_list = [];
	}
	level.zombie_lethal_grenade_list[weapon] = weapon;
}

/*
	Name: is_lethal_grenade
	Namespace: zm_utility
	Checksum: 0xBAA63134
	Offset: 0xAA10
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function is_lethal_grenade(weapon)
{
	if(!isdefined(weapon) || !isdefined(level.zombie_lethal_grenade_list))
	{
		return 0;
	}
	return isdefined(level.zombie_lethal_grenade_list[weapon]);
}

/*
	Name: is_player_lethal_grenade
	Namespace: zm_utility
	Checksum: 0x87FAC3B8
	Offset: 0xAA58
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function is_player_lethal_grenade(weapon)
{
	if(!isdefined(weapon) || !isdefined(self.current_lethal_grenade))
	{
		return 0;
	}
	return self.current_lethal_grenade == weapon;
}

/*
	Name: get_player_lethal_grenade
	Namespace: zm_utility
	Checksum: 0xA7A4E84B
	Offset: 0xAA98
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function get_player_lethal_grenade()
{
	grenade = level.weaponnone;
	if(isdefined(self.current_lethal_grenade))
	{
		grenade = self.current_lethal_grenade;
	}
	return grenade;
}

/*
	Name: set_player_lethal_grenade
	Namespace: zm_utility
	Checksum: 0x314245A1
	Offset: 0xAAD8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function set_player_lethal_grenade(weapon = level.weaponnone)
{
	self notify(#"new_lethal_grenade", weapon);
	self.current_lethal_grenade = weapon;
}

/*
	Name: init_player_lethal_grenade
	Namespace: zm_utility
	Checksum: 0x3F485972
	Offset: 0xAB28
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function init_player_lethal_grenade()
{
	self set_player_lethal_grenade(level.zombie_lethal_grenade_player_init);
}

/*
	Name: register_tactical_grenade_for_level
	Namespace: zm_utility
	Checksum: 0x3075FDA5
	Offset: 0xAB58
	Size: 0x72
	Parameters: 1
	Flags: Linked
*/
function register_tactical_grenade_for_level(weaponname)
{
	weapon = getweapon(weaponname);
	if(is_tactical_grenade(weapon))
	{
		return;
	}
	if(!isdefined(level.zombie_tactical_grenade_list))
	{
		level.zombie_tactical_grenade_list = [];
	}
	level.zombie_tactical_grenade_list[weapon] = weapon;
}

/*
	Name: is_tactical_grenade
	Namespace: zm_utility
	Checksum: 0xCB2F886C
	Offset: 0xABD8
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function is_tactical_grenade(weapon)
{
	if(!isdefined(weapon) || !isdefined(level.zombie_tactical_grenade_list))
	{
		return 0;
	}
	return isdefined(level.zombie_tactical_grenade_list[weapon]);
}

/*
	Name: is_player_tactical_grenade
	Namespace: zm_utility
	Checksum: 0xDB30E9BC
	Offset: 0xAC20
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function is_player_tactical_grenade(weapon)
{
	if(!isdefined(weapon) || !isdefined(self.current_tactical_grenade))
	{
		return 0;
	}
	return self.current_tactical_grenade == weapon;
}

/*
	Name: get_player_tactical_grenade
	Namespace: zm_utility
	Checksum: 0x7B3374D3
	Offset: 0xAC60
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function get_player_tactical_grenade()
{
	tactical = level.weaponnone;
	if(isdefined(self.current_tactical_grenade))
	{
		tactical = self.current_tactical_grenade;
	}
	return tactical;
}

/*
	Name: set_player_tactical_grenade
	Namespace: zm_utility
	Checksum: 0xF3E99C57
	Offset: 0xACA0
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function set_player_tactical_grenade(weapon = level.weaponnone)
{
	self notify(#"new_tactical_grenade", weapon);
	self.current_tactical_grenade = weapon;
}

/*
	Name: init_player_tactical_grenade
	Namespace: zm_utility
	Checksum: 0xF6865152
	Offset: 0xACF0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function init_player_tactical_grenade()
{
	self set_player_tactical_grenade(level.zombie_tactical_grenade_player_init);
}

/*
	Name: is_placeable_mine
	Namespace: zm_utility
	Checksum: 0x3076F4E7
	Offset: 0xAD20
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function is_placeable_mine(weapon)
{
	if(!isdefined(level.placeable_mines))
	{
		level.placeable_mines = [];
	}
	if(!isdefined(weapon) || weapon == level.weaponnone)
	{
		return 0;
	}
	return isdefined(level.placeable_mines[weapon.name]);
}

/*
	Name: is_player_placeable_mine
	Namespace: zm_utility
	Checksum: 0x8FAEC420
	Offset: 0xAD88
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function is_player_placeable_mine(weapon)
{
	if(!isdefined(weapon) || !isdefined(self.current_placeable_mine))
	{
		return 0;
	}
	return self.current_placeable_mine == weapon;
}

/*
	Name: get_player_placeable_mine
	Namespace: zm_utility
	Checksum: 0x9D9C64A4
	Offset: 0xADC8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function get_player_placeable_mine()
{
	placeable_mine = level.weaponnone;
	if(isdefined(self.current_placeable_mine))
	{
		placeable_mine = self.current_placeable_mine;
	}
	return placeable_mine;
}

/*
	Name: set_player_placeable_mine
	Namespace: zm_utility
	Checksum: 0xE594BB88
	Offset: 0xAE08
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function set_player_placeable_mine(weapon = level.weaponnone)
{
	self notify(#"new_placeable_mine", weapon);
	self.current_placeable_mine = weapon;
}

/*
	Name: init_player_placeable_mine
	Namespace: zm_utility
	Checksum: 0xC843F04A
	Offset: 0xAE58
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function init_player_placeable_mine()
{
	self set_player_placeable_mine(level.zombie_placeable_mine_player_init);
}

/*
	Name: register_melee_weapon_for_level
	Namespace: zm_utility
	Checksum: 0x25EB73C1
	Offset: 0xAE88
	Size: 0x72
	Parameters: 1
	Flags: Linked
*/
function register_melee_weapon_for_level(weaponname)
{
	weapon = getweapon(weaponname);
	if(is_melee_weapon(weapon))
	{
		return;
	}
	if(!isdefined(level.zombie_melee_weapon_list))
	{
		level.zombie_melee_weapon_list = [];
	}
	level.zombie_melee_weapon_list[weapon] = weapon;
}

/*
	Name: is_melee_weapon
	Namespace: zm_utility
	Checksum: 0x3AEF87F7
	Offset: 0xAF08
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function is_melee_weapon(weapon)
{
	if(!isdefined(weapon) || !isdefined(level.zombie_melee_weapon_list) || weapon == getweapon("none"))
	{
		return 0;
	}
	return isdefined(level.zombie_melee_weapon_list[weapon]);
}

/*
	Name: is_player_melee_weapon
	Namespace: zm_utility
	Checksum: 0x421F7EAB
	Offset: 0xAF70
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function is_player_melee_weapon(weapon)
{
	if(!isdefined(weapon) || !isdefined(self.current_melee_weapon))
	{
		return 0;
	}
	return self.current_melee_weapon == weapon;
}

/*
	Name: get_player_melee_weapon
	Namespace: zm_utility
	Checksum: 0x58B74A10
	Offset: 0xAFB0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function get_player_melee_weapon()
{
	melee_weapon = level.weaponnone;
	if(isdefined(self.current_melee_weapon))
	{
		melee_weapon = self.current_melee_weapon;
	}
	return melee_weapon;
}

/*
	Name: set_player_melee_weapon
	Namespace: zm_utility
	Checksum: 0x32098DDE
	Offset: 0xAFF0
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function set_player_melee_weapon(weapon = level.weaponnone)
{
	self notify(#"new_melee_weapon", weapon);
	self.current_melee_weapon = weapon;
}

/*
	Name: init_player_melee_weapon
	Namespace: zm_utility
	Checksum: 0xD052B66B
	Offset: 0xB040
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function init_player_melee_weapon()
{
	self set_player_melee_weapon(level.zombie_melee_weapon_player_init);
}

/*
	Name: register_hero_weapon_for_level
	Namespace: zm_utility
	Checksum: 0xDF6EF51F
	Offset: 0xB070
	Size: 0x72
	Parameters: 1
	Flags: Linked
*/
function register_hero_weapon_for_level(weaponname)
{
	weapon = getweapon(weaponname);
	if(is_hero_weapon(weapon))
	{
		return;
	}
	if(!isdefined(level.zombie_hero_weapon_list))
	{
		level.zombie_hero_weapon_list = [];
	}
	level.zombie_hero_weapon_list[weapon] = weapon;
}

/*
	Name: is_hero_weapon
	Namespace: zm_utility
	Checksum: 0xDAC8D68D
	Offset: 0xB0F0
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function is_hero_weapon(weapon)
{
	if(!isdefined(weapon) || !isdefined(level.zombie_hero_weapon_list))
	{
		return 0;
	}
	return isdefined(level.zombie_hero_weapon_list[weapon]);
}

/*
	Name: is_player_hero_weapon
	Namespace: zm_utility
	Checksum: 0x43B50A3E
	Offset: 0xB138
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function is_player_hero_weapon(weapon)
{
	if(!isdefined(weapon) || !isdefined(self.current_hero_weapon))
	{
		return 0;
	}
	return self.current_hero_weapon == weapon;
}

/*
	Name: get_player_hero_weapon
	Namespace: zm_utility
	Checksum: 0x928FB102
	Offset: 0xB178
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function get_player_hero_weapon()
{
	hero_weapon = level.weaponnone;
	if(isdefined(self.current_hero_weapon))
	{
		hero_weapon = self.current_hero_weapon;
	}
	return hero_weapon;
}

/*
	Name: set_player_hero_weapon
	Namespace: zm_utility
	Checksum: 0x2811DDF1
	Offset: 0xB1B8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function set_player_hero_weapon(weapon = level.weaponnone)
{
	self notify(#"new_hero_weapon", weapon);
	self.current_hero_weapon = weapon;
}

/*
	Name: init_player_hero_weapon
	Namespace: zm_utility
	Checksum: 0x8F6DD68
	Offset: 0xB208
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function init_player_hero_weapon()
{
	self set_player_hero_weapon(level.zombie_hero_weapon_player_init);
}

/*
	Name: has_player_hero_weapon
	Namespace: zm_utility
	Checksum: 0xB45DB9D9
	Offset: 0xB238
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function has_player_hero_weapon()
{
	return isdefined(self.current_hero_weapon) && self.current_hero_weapon != level.weaponnone;
}

/*
	Name: should_watch_for_emp
	Namespace: zm_utility
	Checksum: 0xF013C31F
	Offset: 0xB260
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function should_watch_for_emp()
{
	return isdefined(level.should_watch_for_emp) && level.should_watch_for_emp;
}

/*
	Name: register_offhand_weapons_for_level_defaults
	Namespace: zm_utility
	Checksum: 0xF4CA890A
	Offset: 0xB280
	Size: 0xDE
	Parameters: 0
	Flags: Linked
*/
function register_offhand_weapons_for_level_defaults()
{
	if(isdefined(level.register_offhand_weapons_for_level_defaults_override))
	{
		[[level.register_offhand_weapons_for_level_defaults_override]]();
		return;
	}
	register_lethal_grenade_for_level("frag_grenade");
	level.zombie_lethal_grenade_player_init = getweapon("frag_grenade");
	register_tactical_grenade_for_level("cymbal_monkey");
	level.zombie_tactical_grenade_player_init = undefined;
	level.zombie_placeable_mine_player_init = undefined;
	register_melee_weapon_for_level("knife");
	register_melee_weapon_for_level("bowie_knife");
	level.zombie_melee_weapon_player_init = getweapon("knife");
	level.zombie_equipment_player_init = undefined;
}

/*
	Name: init_player_offhand_weapons
	Namespace: zm_utility
	Checksum: 0x40AAC220
	Offset: 0xB368
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function init_player_offhand_weapons()
{
	init_player_lethal_grenade();
	init_player_tactical_grenade();
	init_player_placeable_mine();
	init_player_melee_weapon();
	init_player_hero_weapon();
	zm_equipment::init_player_equipment();
}

/*
	Name: is_offhand_weapon
	Namespace: zm_utility
	Checksum: 0x75E67106
	Offset: 0xB3D8
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function is_offhand_weapon(weapon)
{
	return is_lethal_grenade(weapon) || is_tactical_grenade(weapon) || is_placeable_mine(weapon) || is_melee_weapon(weapon) || is_hero_weapon(weapon) || zm_equipment::is_equipment(weapon);
}

/*
	Name: is_player_offhand_weapon
	Namespace: zm_utility
	Checksum: 0x70299640
	Offset: 0xB480
	Size: 0x9A
	Parameters: 1
	Flags: None
*/
function is_player_offhand_weapon(weapon)
{
	return self is_player_lethal_grenade(weapon) || self is_player_tactical_grenade(weapon) || self is_player_placeable_mine(weapon) || self is_player_melee_weapon(weapon) || self is_player_hero_weapon(weapon) || self zm_equipment::is_player_equipment(weapon);
}

/*
	Name: has_powerup_weapon
	Namespace: zm_utility
	Checksum: 0xFAC0B5F5
	Offset: 0xB528
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function has_powerup_weapon()
{
	return isdefined(self.has_powerup_weapon) && self.has_powerup_weapon;
}

/*
	Name: has_hero_weapon
	Namespace: zm_utility
	Checksum: 0x6159834E
	Offset: 0xB548
	Size: 0x4A
	Parameters: 0
	Flags: Linked
*/
function has_hero_weapon()
{
	weapon = self getcurrentweapon();
	return isdefined(weapon.isheroweapon) && weapon.isheroweapon;
}

/*
	Name: give_start_weapon
	Namespace: zm_utility
	Checksum: 0xD847E727
	Offset: 0xB5A0
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function give_start_weapon(b_switch_weapon)
{
	if(!isdefined(self.hascompletedsuperee))
	{
		self.hascompletedsuperee = self zm_stats::get_global_stat("DARKOPS_GENESIS_SUPER_EE") > 0;
	}
	if(self.hascompletedsuperee)
	{
		self zm_weapons::weapon_give(level.start_weapon, 0, 0, 1, 0);
		self givemaxammo(level.start_weapon);
		self zm_weapons::weapon_give(level.super_ee_weapon, 0, 0, 1, b_switch_weapon);
	}
	else
	{
		self zm_weapons::weapon_give(level.start_weapon, 0, 0, 1, b_switch_weapon);
	}
}

/*
	Name: array_flag_wait_any
	Namespace: zm_utility
	Checksum: 0x3D902E2F
	Offset: 0xB698
	Size: 0xA8
	Parameters: 1
	Flags: None
*/
function array_flag_wait_any(flag_array)
{
	if(!isdefined(level._array_flag_wait_any_calls))
	{
		level._n_array_flag_wait_any_calls = 0;
	}
	else
	{
		level._n_array_flag_wait_any_calls++;
	}
	str_condition = "array_flag_wait_call_" + level._n_array_flag_wait_any_calls;
	for(index = 0; index < flag_array.size; index++)
	{
		level thread array_flag_wait_any_thread(flag_array[index], str_condition);
	}
	level waittill(str_condition);
}

/*
	Name: array_flag_wait_any_thread
	Namespace: zm_utility
	Checksum: 0x493E262D
	Offset: 0xB748
	Size: 0x3E
	Parameters: 2
	Flags: Linked
*/
function array_flag_wait_any_thread(flag_name, condition)
{
	level endon(condition);
	level flag::wait_till(flag_name);
	level notify(condition);
}

/*
	Name: groundpos
	Namespace: zm_utility
	Checksum: 0x8F520332
	Offset: 0xB790
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function groundpos(origin)
{
	return bullettrace(origin, origin + (vectorscale((0, 0, -1), 100000)), 0, self)["position"];
}

/*
	Name: groundpos_ignore_water
	Namespace: zm_utility
	Checksum: 0x4DD6E24C
	Offset: 0xB7D8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function groundpos_ignore_water(origin)
{
	return bullettrace(origin, origin + (vectorscale((0, 0, -1), 100000)), 0, self, 1)["position"];
}

/*
	Name: groundpos_ignore_water_new
	Namespace: zm_utility
	Checksum: 0x3564DAA1
	Offset: 0xB828
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function groundpos_ignore_water_new(origin)
{
	return groundtrace(origin, origin + (vectorscale((0, 0, -1), 100000)), 0, self, 1)["position"];
}

/*
	Name: self_delete
	Namespace: zm_utility
	Checksum: 0xBA0EB1CE
	Offset: 0xB878
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function self_delete()
{
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: ignore_triggers
	Namespace: zm_utility
	Checksum: 0x675B61E5
	Offset: 0xB8A8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function ignore_triggers(timer)
{
	self endon(#"death");
	self.ignoretriggers = 1;
	if(isdefined(timer))
	{
		wait(timer);
	}
	else
	{
		wait(0.5);
	}
	self.ignoretriggers = 0;
}

/*
	Name: giveachievement_wrapper
	Namespace: zm_utility
	Checksum: 0xA18A6731
	Offset: 0xB900
	Size: 0x234
	Parameters: 2
	Flags: None
*/
function giveachievement_wrapper(achievement, all_players)
{
	if(achievement == "")
	{
		return;
	}
	if(isdefined(level.zm_disable_recording_stats) && level.zm_disable_recording_stats)
	{
		return;
	}
	achievement_lower = tolower(achievement);
	global_counter = 0;
	if(isdefined(all_players) && all_players)
	{
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			players[i] giveachievement(achievement);
			has_achievement = 0;
			if(!(isdefined(has_achievement) && has_achievement))
			{
				global_counter++;
			}
			if(issplitscreen() && i == 0 || !issplitscreen())
			{
				if(isdefined(level.achievement_sound_func))
				{
					players[i] thread [[level.achievement_sound_func]](achievement_lower);
				}
			}
		}
	}
	else
	{
		if(!isplayer(self))
		{
			/#
				println("");
			#/
			return;
		}
		self giveachievement(achievement);
		has_achievement = 0;
		if(!(isdefined(has_achievement) && has_achievement))
		{
			global_counter++;
		}
		if(isdefined(level.achievement_sound_func))
		{
			self thread [[level.achievement_sound_func]](achievement_lower);
		}
	}
	if(global_counter)
	{
		incrementcounter("global_" + achievement_lower, global_counter);
	}
}

/*
	Name: getyaw
	Namespace: zm_utility
	Checksum: 0x82EF318D
	Offset: 0xBB40
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function getyaw(org)
{
	angles = vectortoangles(org - self.origin);
	return angles[1];
}

/*
	Name: getyawtospot
	Namespace: zm_utility
	Checksum: 0xA7722FC5
	Offset: 0xBB90
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function getyawtospot(spot)
{
	pos = spot;
	yaw = self.angles[1] - getyaw(pos);
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: disable_react
	Namespace: zm_utility
	Checksum: 0x6A0B3FF4
	Offset: 0xBC10
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function disable_react()
{
	/#
		assert(isalive(self), "");
	#/
	self.a.disablereact = 1;
	self.allowreact = 0;
}

/*
	Name: enable_react
	Namespace: zm_utility
	Checksum: 0xC18FA75C
	Offset: 0xBC70
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function enable_react()
{
	/#
		assert(isalive(self), "");
	#/
	self.a.disablereact = 0;
	self.allowreact = 1;
}

/*
	Name: bullet_attack
	Namespace: zm_utility
	Checksum: 0xEAA824B4
	Offset: 0xBCD0
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function bullet_attack(type)
{
	if(type == "MOD_PISTOL_BULLET")
	{
		return 1;
	}
	return type == "MOD_RIFLE_BULLET";
}

/*
	Name: pick_up
	Namespace: zm_utility
	Checksum: 0x8DAE37B0
	Offset: 0xBD08
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function pick_up()
{
	player = self.owner;
	self destroy_ent();
	clip_ammo = player getweaponammoclip(self.weapon);
	clip_max_ammo = self.weapon.clipsize;
	if(clip_ammo < clip_max_ammo)
	{
		clip_ammo++;
	}
	player setweaponammoclip(self.weapon, clip_ammo);
}

/*
	Name: destroy_ent
	Namespace: zm_utility
	Checksum: 0x62EF756A
	Offset: 0xBDC0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function destroy_ent()
{
	self delete();
}

/*
	Name: waittill_not_moving
	Namespace: zm_utility
	Checksum: 0x5D3C979F
	Offset: 0xBDE8
	Size: 0xA0
	Parameters: 0
	Flags: None
*/
function waittill_not_moving()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"detonated");
	level endon(#"game_ended");
	if(self.classname == "grenade")
	{
		self waittill(#"stationary");
	}
	else
	{
		prevorigin = self.origin;
		while(true)
		{
			wait(0.15);
			if(self.origin == prevorigin)
			{
				break;
			}
			prevorigin = self.origin;
		}
	}
}

/*
	Name: get_closest_player
	Namespace: zm_utility
	Checksum: 0xAF310145
	Offset: 0xBE90
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function get_closest_player(org)
{
	players = [];
	players = getplayers();
	return arraygetclosest(org, players);
}

/*
	Name: ent_flag_init_ai_standards
	Namespace: zm_utility
	Checksum: 0x1B75B86B
	Offset: 0xBEE8
	Size: 0xA6
	Parameters: 0
	Flags: None
*/
function ent_flag_init_ai_standards()
{
	message_array = [];
	message_array[message_array.size] = "goal";
	message_array[message_array.size] = "damage";
	for(i = 0; i < message_array.size; i++)
	{
		self flag::init(message_array[i]);
		self thread ent_flag_wait_ai_standards(message_array[i]);
	}
}

/*
	Name: ent_flag_wait_ai_standards
	Namespace: zm_utility
	Checksum: 0x80296E66
	Offset: 0xBF98
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function ent_flag_wait_ai_standards(message)
{
	self endon(#"death");
	self waittill(message);
	self.ent_flag[message] = 1;
}

/*
	Name: flat_angle
	Namespace: zm_utility
	Checksum: 0xCECCB34E
	Offset: 0xBFD8
	Size: 0x2E
	Parameters: 1
	Flags: None
*/
function flat_angle(angle)
{
	rangle = (0, angle[1], 0);
	return rangle;
}

/*
	Name: clear_run_anim
	Namespace: zm_utility
	Checksum: 0x9EA6AC75
	Offset: 0xC010
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function clear_run_anim()
{
	self.alwaysrunforward = undefined;
	self.a.combatrunanim = undefined;
	self.run_noncombatanim = undefined;
	self.walk_combatanim = undefined;
	self.walk_noncombatanim = undefined;
	self.precombatrunenabled = 1;
}

/*
	Name: track_players_intersection_tracker
	Namespace: zm_utility
	Checksum: 0x4B047F57
	Offset: 0xC060
	Size: 0x3E0
	Parameters: 0
	Flags: Linked
*/
function track_players_intersection_tracker()
{
	self endon(#"disconnect");
	self endon(#"death");
	level endon(#"end_game");
	wait(5);
	while(true)
	{
		killed_players = 0;
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(players[i] laststand::player_is_in_laststand() || "playing" != players[i].sessionstate)
			{
				continue;
			}
			for(j = 0; j < players.size; j++)
			{
				if(i == j || players[j] laststand::player_is_in_laststand() || "playing" != players[j].sessionstate)
				{
					continue;
				}
				if(isdefined(level.player_intersection_tracker_override))
				{
					if(players[i] [[level.player_intersection_tracker_override]](players[j]))
					{
						continue;
					}
				}
				playeri_origin = players[i].origin;
				playerj_origin = players[j].origin;
				if((abs(playeri_origin[2] - playerj_origin[2])) > 60)
				{
					continue;
				}
				distance_apart = distance2d(playeri_origin, playerj_origin);
				if(abs(distance_apart) > 18)
				{
					continue;
				}
				/#
					iprintlnbold("");
				#/
				players[i] dodamage(1000, (0, 0, 0));
				players[j] dodamage(1000, (0, 0, 0));
				if(!killed_players)
				{
					players[i] playlocalsound(level.zmb_laugh_alias);
				}
				players[i] zm_stats::increment_map_cheat_stat("cheat_too_friendly");
				players[i] zm_stats::increment_client_stat("cheat_too_friendly", 0);
				players[i] zm_stats::increment_client_stat("cheat_total", 0);
				players[j] zm_stats::increment_map_cheat_stat("cheat_too_friendly");
				players[j] zm_stats::increment_client_stat("cheat_too_friendly", 0);
				players[j] zm_stats::increment_client_stat("cheat_total", 0);
				killed_players = 1;
			}
		}
		wait(0.5);
	}
}

/*
	Name: is_player_looking_at
	Namespace: zm_utility
	Checksum: 0x2A6E9621
	Offset: 0xC448
	Size: 0x170
	Parameters: 4
	Flags: Linked
*/
function is_player_looking_at(origin, dot, do_trace, ignore_ent)
{
	/#
		assert(isplayer(self), "");
	#/
	if(!isdefined(dot))
	{
		dot = 0.7;
	}
	if(!isdefined(do_trace))
	{
		do_trace = 1;
	}
	eye = self util::get_eye();
	delta_vec = anglestoforward(vectortoangles(origin - eye));
	view_vec = anglestoforward(self getplayerangles());
	new_dot = vectordot(delta_vec, view_vec);
	if(new_dot >= dot)
	{
		if(do_trace)
		{
			return bullettracepassed(origin, eye, 0, ignore_ent);
		}
		return 1;
	}
	return 0;
}

/*
	Name: add_gametype
	Namespace: zm_utility
	Checksum: 0x251B83B2
	Offset: 0xC5C0
	Size: 0x24
	Parameters: 4
	Flags: None
*/
function add_gametype(gt, dummy1, name, dummy2)
{
}

/*
	Name: add_gameloc
	Namespace: zm_utility
	Checksum: 0xF41CC52B
	Offset: 0xC5F0
	Size: 0x24
	Parameters: 4
	Flags: None
*/
function add_gameloc(gl, dummy1, name, dummy2)
{
}

/*
	Name: get_closest_index
	Namespace: zm_utility
	Checksum: 0x4B01ADB7
	Offset: 0xC620
	Size: 0xF4
	Parameters: 3
	Flags: None
*/
function get_closest_index(org, array, dist = 9999999)
{
	distsq = dist * dist;
	if(array.size < 1)
	{
		return;
	}
	index = undefined;
	for(i = 0; i < array.size; i++)
	{
		newdistsq = distancesquared(array[i].origin, org);
		if(newdistsq >= distsq)
		{
			continue;
		}
		distsq = newdistsq;
		index = i;
	}
	return index;
}

/*
	Name: is_valid_zombie_spawn_point
	Namespace: zm_utility
	Checksum: 0xF6197358
	Offset: 0xC720
	Size: 0xF6
	Parameters: 1
	Flags: None
*/
function is_valid_zombie_spawn_point(point)
{
	liftedorigin = point.origin + vectorscale((0, 0, 1), 5);
	size = 48;
	height = 64;
	mins = (-1 * size, -1 * size, 0);
	maxs = (size, size, height);
	absmins = liftedorigin + mins;
	absmaxs = liftedorigin + maxs;
	if(boundswouldtelefrag(absmins, absmaxs))
	{
		return false;
	}
	return true;
}

/*
	Name: get_closest_index_to_entity
	Namespace: zm_utility
	Checksum: 0xAADCC818
	Offset: 0xC820
	Size: 0x144
	Parameters: 4
	Flags: None
*/
function get_closest_index_to_entity(entity, array, dist, extra_check)
{
	org = entity.origin;
	if(!isdefined(dist))
	{
		dist = 9999999;
	}
	distsq = dist * dist;
	if(array.size < 1)
	{
		return;
	}
	index = undefined;
	for(i = 0; i < array.size; i++)
	{
		if(isdefined(extra_check) && ![[extra_check]](entity, array[i]))
		{
			continue;
		}
		newdistsq = distancesquared(array[i].origin, org);
		if(newdistsq >= distsq)
		{
			continue;
		}
		distsq = newdistsq;
		index = i;
	}
	return index;
}

/*
	Name: set_gamemode_var
	Namespace: zm_utility
	Checksum: 0xD3896D31
	Offset: 0xC970
	Size: 0x4A
	Parameters: 2
	Flags: Linked
*/
function set_gamemode_var(gvar, val)
{
	if(!isdefined(game["gamemode_match"]))
	{
		game["gamemode_match"] = [];
	}
	game["gamemode_match"][gvar] = val;
}

/*
	Name: set_gamemode_var_once
	Namespace: zm_utility
	Checksum: 0xA156C8D1
	Offset: 0xC9C8
	Size: 0x62
	Parameters: 2
	Flags: Linked
*/
function set_gamemode_var_once(gvar, val)
{
	if(!isdefined(game["gamemode_match"]))
	{
		game["gamemode_match"] = [];
	}
	if(!isdefined(game["gamemode_match"][gvar]))
	{
		game["gamemode_match"][gvar] = val;
	}
}

/*
	Name: set_game_var
	Namespace: zm_utility
	Checksum: 0x76A2C2
	Offset: 0xCA38
	Size: 0x22
	Parameters: 2
	Flags: Linked
*/
function set_game_var(gvar, val)
{
	game[gvar] = val;
}

/*
	Name: set_game_var_once
	Namespace: zm_utility
	Checksum: 0x61F90DE8
	Offset: 0xCA68
	Size: 0x30
	Parameters: 2
	Flags: Linked
*/
function set_game_var_once(gvar, val)
{
	if(!isdefined(game[gvar]))
	{
		game[gvar] = val;
	}
}

/*
	Name: get_game_var
	Namespace: zm_utility
	Checksum: 0xA851D4A7
	Offset: 0xCAA0
	Size: 0x26
	Parameters: 1
	Flags: Linked
*/
function get_game_var(gvar)
{
	if(isdefined(game[gvar]))
	{
		return game[gvar];
	}
	return undefined;
}

/*
	Name: get_gamemode_var
	Namespace: zm_utility
	Checksum: 0xA46431D0
	Offset: 0xCAD0
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function get_gamemode_var(gvar)
{
	if(isdefined(game["gamemode_match"]) && isdefined(game["gamemode_match"][gvar]))
	{
		return game["gamemode_match"][gvar];
	}
	return undefined;
}

/*
	Name: waittill_subset
	Namespace: zm_utility
	Checksum: 0x951767C
	Offset: 0xCB20
	Size: 0x1F0
	Parameters: 6
	Flags: None
*/
function waittill_subset(min_num, string1, string2, string3, string4, string5)
{
	self endon(#"death");
	ent = spawnstruct();
	ent.threads = 0;
	returned_threads = 0;
	if(isdefined(string1))
	{
		self thread util::waittill_string(string1, ent);
		ent.threads++;
	}
	if(isdefined(string2))
	{
		self thread util::waittill_string(string2, ent);
		ent.threads++;
	}
	if(isdefined(string3))
	{
		self thread util::waittill_string(string3, ent);
		ent.threads++;
	}
	if(isdefined(string4))
	{
		self thread util::waittill_string(string4, ent);
		ent.threads++;
	}
	if(isdefined(string5))
	{
		self thread util::waittill_string(string5, ent);
		ent.threads++;
	}
	while(ent.threads)
	{
		ent waittill(#"returned");
		ent.threads--;
		returned_threads++;
		if(returned_threads >= min_num)
		{
			break;
		}
	}
	ent notify(#"die");
}

/*
	Name: is_headshot
	Namespace: zm_utility
	Checksum: 0xA57E12D2
	Offset: 0xCD18
	Size: 0xA4
	Parameters: 3
	Flags: Linked
*/
function is_headshot(weapon, shitloc, smeansofdeath)
{
	if(!isdefined(shitloc))
	{
		return 0;
	}
	if(shitloc != "head" && shitloc != "helmet")
	{
		return 0;
	}
	if(smeansofdeath == "MOD_IMPACT" && weapon.isballisticknife)
	{
		return 1;
	}
	return smeansofdeath != "MOD_MELEE" && smeansofdeath != "MOD_IMPACT" && smeansofdeath != "MOD_UNKNOWN";
}

/*
	Name: is_jumping
	Namespace: zm_utility
	Checksum: 0x122DBC9A
	Offset: 0xCDC8
	Size: 0x30
	Parameters: 0
	Flags: None
*/
function is_jumping()
{
	ground_ent = self getgroundent();
	return !isdefined(ground_ent);
}

/*
	Name: is_explosive_damage
	Namespace: zm_utility
	Checksum: 0x2551060F
	Offset: 0xCE00
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function is_explosive_damage(mod)
{
	if(!isdefined(mod))
	{
		return false;
	}
	if(mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_EXPLOSIVE")
	{
		return true;
	}
	return false;
}

/*
	Name: sndswitchannouncervox
	Namespace: zm_utility
	Checksum: 0x53CDA896
	Offset: 0xCE80
	Size: 0x66
	Parameters: 1
	Flags: None
*/
function sndswitchannouncervox(who)
{
	switch(who)
	{
		case "sam":
		{
			game["zmbdialog"]["prefix"] = "vox_zmba_sam";
			level.zmb_laugh_alias = "zmb_laugh_sam";
			level.sndannouncerisrich = 0;
			break;
		}
	}
}

/*
	Name: do_player_general_vox
	Namespace: zm_utility
	Checksum: 0xF9024D13
	Offset: 0xCEF0
	Size: 0xB4
	Parameters: 4
	Flags: Linked
*/
function do_player_general_vox(category, type, timer, chance)
{
	if(isdefined(timer) && isdefined(level.votimer[type]) && level.votimer[type] > 0)
	{
		return;
	}
	self thread zm_audio::create_and_play_dialog(category, type);
	if(isdefined(timer))
	{
		level.votimer[type] = timer;
		level thread general_vox_timer(level.votimer[type], type);
	}
}

/*
	Name: general_vox_timer
	Namespace: zm_utility
	Checksum: 0x779116B0
	Offset: 0xCFB0
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function general_vox_timer(timer, type)
{
	level endon(#"end_game");
	/#
		println(((("" + type) + "") + timer) + "");
	#/
	while(timer > 0)
	{
		wait(1);
		timer--;
	}
	level.votimer[type] = timer;
	/#
		println(((("" + type) + "") + timer) + "");
	#/
}

/*
	Name: create_vox_timer
	Namespace: zm_utility
	Checksum: 0xA0979B90
	Offset: 0xD080
	Size: 0x1E
	Parameters: 1
	Flags: Linked
*/
function create_vox_timer(type)
{
	level.votimer[type] = 0;
}

/*
	Name: play_vox_to_player
	Namespace: zm_utility
	Checksum: 0x2B5FC539
	Offset: 0xD0A8
	Size: 0x1C
	Parameters: 3
	Flags: None
*/
function play_vox_to_player(category, type, force_variant)
{
}

/*
	Name: is_favorite_weapon
	Namespace: zm_utility
	Checksum: 0xCE86269F
	Offset: 0xD0D0
	Size: 0xA2
	Parameters: 1
	Flags: None
*/
function is_favorite_weapon(weapon_to_check)
{
	if(!isdefined(self.favorite_wall_weapons_list))
	{
		return false;
	}
	foreach(weapon in self.favorite_wall_weapons_list)
	{
		if(weapon_to_check == weapon)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: add_vox_response_chance
	Namespace: zm_utility
	Checksum: 0x636FFF89
	Offset: 0xD180
	Size: 0x26
	Parameters: 2
	Flags: None
*/
function add_vox_response_chance(event, chance)
{
	level.response_chances[event] = chance;
}

/*
	Name: set_demo_intermission_point
	Namespace: zm_utility
	Checksum: 0xC92EF484
	Offset: 0xD1B0
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function set_demo_intermission_point()
{
	spawnpoints = getentarray("mp_global_intermission", "classname");
	if(!spawnpoints.size)
	{
		return;
	}
	spawnpoint = spawnpoints[0];
	match_string = "";
	location = level.scr_zm_map_start_location;
	if(location == "default" || location == "" && isdefined(level.default_start_location))
	{
		location = level.default_start_location;
	}
	match_string = (level.scr_zm_ui_gametype + "_") + location;
	for(i = 0; i < spawnpoints.size; i++)
	{
		if(isdefined(spawnpoints[i].script_string))
		{
			tokens = strtok(spawnpoints[i].script_string, " ");
			foreach(token in tokens)
			{
				if(token == match_string)
				{
					spawnpoint = spawnpoints[i];
					i = spawnpoints.size;
					break;
				}
			}
		}
	}
	setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
}

/*
	Name: register_map_navcard
	Namespace: zm_utility
	Checksum: 0x1CB7E08
	Offset: 0xD3D0
	Size: 0x2C
	Parameters: 2
	Flags: None
*/
function register_map_navcard(navcard_on_map, navcard_needed_for_computer)
{
	level.navcard_needed = navcard_needed_for_computer;
	level.map_navcard = navcard_on_map;
}

/*
	Name: does_player_have_map_navcard
	Namespace: zm_utility
	Checksum: 0x61E22E3A
	Offset: 0xD408
	Size: 0x2A
	Parameters: 1
	Flags: None
*/
function does_player_have_map_navcard(player)
{
	return player zm_stats::get_global_stat(level.map_navcard);
}

/*
	Name: does_player_have_correct_navcard
	Namespace: zm_utility
	Checksum: 0xFC9F3253
	Offset: 0xD440
	Size: 0x3A
	Parameters: 1
	Flags: None
*/
function does_player_have_correct_navcard(player)
{
	if(!isdefined(level.navcard_needed))
	{
		return 0;
	}
	return player zm_stats::get_global_stat(level.navcard_needed);
}

/*
	Name: place_navcard
	Namespace: zm_utility
	Checksum: 0xC6E70B1E
	Offset: 0xD488
	Size: 0x35C
	Parameters: 4
	Flags: Linked
*/
function place_navcard(str_model, str_stat, org, angles)
{
	navcard = spawn("script_model", org);
	navcard setmodel(str_model);
	navcard.angles = angles;
	wait(1);
	navcard_pickup_trig = spawn("trigger_radius_use", org, 0, 84, 72);
	navcard_pickup_trig setcursorhint("HINT_NOICON");
	navcard_pickup_trig sethintstring(&"ZOMBIE_NAVCARD_PICKUP");
	navcard_pickup_trig triggerignoreteam();
	a_navcard_stats = array("navcard_held_zm_transit", "navcard_held_zm_highrise", "navcard_held_zm_buried");
	is_holding_card = 0;
	str_placing_stat = undefined;
	while(true)
	{
		navcard_pickup_trig waittill(#"trigger", who);
		if(is_player_valid(who))
		{
			foreach(str_cur_stat in a_navcard_stats)
			{
				if(who zm_stats::get_global_stat(str_cur_stat))
				{
					str_placing_stat = str_cur_stat;
					is_holding_card = 1;
					who zm_stats::set_global_stat(str_cur_stat, 0);
				}
			}
			who playsound("zmb_buildable_piece_add");
			who zm_stats::set_global_stat(str_stat, 1);
			who.navcard_grabbed = str_stat;
			util::wait_network_frame();
			is_stat = who zm_stats::get_global_stat(str_stat);
			thread sq_refresh_player_navcard_hud();
			break;
		}
	}
	navcard delete();
	navcard_pickup_trig delete();
	if(is_holding_card)
	{
		level thread place_navcard(str_model, str_placing_stat, org, angles);
	}
}

/*
	Name: sq_refresh_player_navcard_hud
	Namespace: zm_utility
	Checksum: 0xC6FD7676
	Offset: 0xD7F0
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function sq_refresh_player_navcard_hud()
{
	if(!isdefined(level.navcards))
	{
		return;
	}
	players = getplayers();
	foreach(player in players)
	{
		player thread sq_refresh_player_navcard_hud_internal();
	}
}

/*
	Name: sq_refresh_player_navcard_hud_internal
	Namespace: zm_utility
	Checksum: 0xCCE76C66
	Offset: 0xD8B0
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function sq_refresh_player_navcard_hud_internal()
{
	self endon(#"disconnect");
	navcard_bits = 0;
	for(i = 0; i < level.navcards.size; i++)
	{
		hasit = self zm_stats::get_global_stat(level.navcards[i]);
		if(isdefined(self.navcard_grabbed) && self.navcard_grabbed == level.navcards[i])
		{
			hasit = 1;
		}
		if(hasit)
		{
			navcard_bits = navcard_bits + (1 << i);
		}
	}
	util::wait_network_frame();
	self clientfield::set("navcard_held", 0);
	if(navcard_bits > 0)
	{
		util::wait_network_frame();
		self clientfield::set("navcard_held", navcard_bits);
	}
}

/*
	Name: disable_player_move_states
	Namespace: zm_utility
	Checksum: 0x1A76741B
	Offset: 0xD9F8
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function disable_player_move_states(forcestancechange)
{
	self allowcrouch(1);
	self allowlean(0);
	self allowads(0);
	self allowsprint(0);
	self allowprone(0);
	self allowmelee(0);
	if(isdefined(forcestancechange) && forcestancechange == 1)
	{
		if(self getstance() == "prone")
		{
			self setstance("crouch");
		}
	}
}

/*
	Name: enable_player_move_states
	Namespace: zm_utility
	Checksum: 0x31CA1302
	Offset: 0xDAF8
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function enable_player_move_states()
{
	if(!isdefined(self._allow_lean) || self._allow_lean == 1)
	{
		self allowlean(1);
	}
	if(!isdefined(self._allow_ads) || self._allow_ads == 1)
	{
		self allowads(1);
	}
	if(!isdefined(self._allow_sprint) || self._allow_sprint == 1)
	{
		self allowsprint(1);
	}
	if(!isdefined(self._allow_prone) || self._allow_prone == 1)
	{
		self allowprone(1);
	}
	if(!isdefined(self._allow_melee) || self._allow_melee == 1)
	{
		self allowmelee(1);
	}
}

/*
	Name: check_and_create_node_lists
	Namespace: zm_utility
	Checksum: 0x4B28AFE1
	Offset: 0xDC20
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function check_and_create_node_lists()
{
	if(!isdefined(level._link_node_list))
	{
		level._link_node_list = [];
	}
	if(!isdefined(level._unlink_node_list))
	{
		level._unlink_node_list = [];
	}
}

/*
	Name: link_nodes
	Namespace: zm_utility
	Checksum: 0x598F9850
	Offset: 0xDC60
	Size: 0x22C
	Parameters: 3
	Flags: None
*/
function link_nodes(a, b, bdontunlinkonmigrate = 0)
{
	if(nodesarelinked(a, b))
	{
		return;
	}
	check_and_create_node_lists();
	a_index_string = "" + a.origin;
	b_index_string = "" + b.origin;
	if(!isdefined(level._link_node_list[a_index_string]))
	{
		level._link_node_list[a_index_string] = spawnstruct();
		level._link_node_list[a_index_string].node = a;
		level._link_node_list[a_index_string].links = [];
		level._link_node_list[a_index_string].ignore_on_migrate = [];
	}
	if(!isdefined(level._link_node_list[a_index_string].links[b_index_string]))
	{
		level._link_node_list[a_index_string].links[b_index_string] = b;
		level._link_node_list[a_index_string].ignore_on_migrate[b_index_string] = bdontunlinkonmigrate;
	}
	if(isdefined(level._unlink_node_list[a_index_string]))
	{
		if(isdefined(level._unlink_node_list[a_index_string].links[b_index_string]))
		{
			level._unlink_node_list[a_index_string].links[b_index_string] = undefined;
			level._unlink_node_list[a_index_string].ignore_on_migrate[b_index_string] = undefined;
		}
	}
	linknodes(a, b);
}

/*
	Name: unlink_nodes
	Namespace: zm_utility
	Checksum: 0xA61C3C2C
	Offset: 0xDE98
	Size: 0x22C
	Parameters: 3
	Flags: None
*/
function unlink_nodes(a, b, bdontlinkonmigrate = 0)
{
	if(!nodesarelinked(a, b))
	{
		return;
	}
	check_and_create_node_lists();
	a_index_string = "" + a.origin;
	b_index_string = "" + b.origin;
	if(!isdefined(level._unlink_node_list[a_index_string]))
	{
		level._unlink_node_list[a_index_string] = spawnstruct();
		level._unlink_node_list[a_index_string].node = a;
		level._unlink_node_list[a_index_string].links = [];
		level._unlink_node_list[a_index_string].ignore_on_migrate = [];
	}
	if(!isdefined(level._unlink_node_list[a_index_string].links[b_index_string]))
	{
		level._unlink_node_list[a_index_string].links[b_index_string] = b;
		level._unlink_node_list[a_index_string].ignore_on_migrate[b_index_string] = bdontlinkonmigrate;
	}
	if(isdefined(level._link_node_list[a_index_string]))
	{
		if(isdefined(level._link_node_list[a_index_string].links[b_index_string]))
		{
			level._link_node_list[a_index_string].links[b_index_string] = undefined;
			level._link_node_list[a_index_string].ignore_on_migrate[b_index_string] = undefined;
		}
	}
	unlinknodes(a, b);
}

/*
	Name: spawn_path_node
	Namespace: zm_utility
	Checksum: 0xA4A67902
	Offset: 0xE0D0
	Size: 0x13A
	Parameters: 6
	Flags: None
*/
function spawn_path_node(origin, angles, k1, v1, k2, v2)
{
	if(!isdefined(level._spawned_path_nodes))
	{
		level._spawned_path_nodes = [];
	}
	node = spawnstruct();
	node.origin = origin;
	node.angles = angles;
	node.k1 = k1;
	node.v1 = v1;
	node.k2 = k2;
	node.v2 = v2;
	node.node = spawn_path_node_internal(origin, angles, k1, v1, k2, v2);
	level._spawned_path_nodes[level._spawned_path_nodes.size] = node;
	return node.node;
}

/*
	Name: spawn_path_node_internal
	Namespace: zm_utility
	Checksum: 0xA330827
	Offset: 0xE218
	Size: 0xCA
	Parameters: 6
	Flags: Linked
*/
function spawn_path_node_internal(origin, angles, k1, v1, k2, v2)
{
	if(isdefined(k2))
	{
		return spawnpathnode("node_pathnode", origin, angles, k1, v1, k2, v2);
	}
	if(isdefined(k1))
	{
		return spawnpathnode("node_pathnode", origin, angles, k1, v1);
	}
	return spawnpathnode("node_pathnode", origin, angles);
}

/*
	Name: delete_spawned_path_nodes
	Namespace: zm_utility
	Checksum: 0x99EC1590
	Offset: 0xE2F0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function delete_spawned_path_nodes()
{
}

/*
	Name: respawn_path_nodes
	Namespace: zm_utility
	Checksum: 0xB72939
	Offset: 0xE300
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function respawn_path_nodes()
{
	if(!isdefined(level._spawned_path_nodes))
	{
		return;
	}
	for(i = 0; i < level._spawned_path_nodes.size; i++)
	{
		node_struct = level._spawned_path_nodes[i];
		/#
			println("" + node_struct.origin);
		#/
		node_struct.node = spawn_path_node_internal(node_struct.origin, node_struct.angles, node_struct.k1, node_struct.v1, node_struct.k2, node_struct.v2);
	}
}

/*
	Name: link_changes_internal_internal
	Namespace: zm_utility
	Checksum: 0xD477C58F
	Offset: 0xE3F8
	Size: 0x236
	Parameters: 2
	Flags: Linked
*/
function link_changes_internal_internal(list, func)
{
	keys = getarraykeys(list);
	for(i = 0; i < keys.size; i++)
	{
		node = list[keys[i]].node;
		node_keys = getarraykeys(list[keys[i]].links);
		for(j = 0; j < node_keys.size; j++)
		{
			if(isdefined(list[keys[i]].links[node_keys[j]]))
			{
				if(isdefined(list[keys[i]].ignore_on_migrate[node_keys[j]]) && list[keys[i]].ignore_on_migrate[node_keys[j]])
				{
					/#
						println(((("" + keys[i]) + "") + node_keys[j]) + "");
					#/
					continue;
				}
				/#
					println((("" + keys[i]) + "") + node_keys[j]);
				#/
				[[func]](node, list[keys[i]].links[node_keys[j]]);
			}
		}
	}
}

/*
	Name: link_changes_internal
	Namespace: zm_utility
	Checksum: 0x44A8AAEF
	Offset: 0xE638
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function link_changes_internal(func_for_link_list, func_for_unlink_list)
{
	if(isdefined(level._link_node_list))
	{
		/#
			println("");
		#/
		link_changes_internal_internal(level._link_node_list, func_for_link_list);
	}
	if(isdefined(level._unlink_node_list))
	{
		/#
			println("");
		#/
		link_changes_internal_internal(level._unlink_node_list, func_for_unlink_list);
	}
}

/*
	Name: link_nodes_wrapper
	Namespace: zm_utility
	Checksum: 0x3AE6A827
	Offset: 0xE6E8
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function link_nodes_wrapper(a, b)
{
	if(!nodesarelinked(a, b))
	{
		linknodes(a, b);
	}
}

/*
	Name: unlink_nodes_wrapper
	Namespace: zm_utility
	Checksum: 0x3D700488
	Offset: 0xE740
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function unlink_nodes_wrapper(a, b)
{
	if(nodesarelinked(a, b))
	{
		unlinknodes(a, b);
	}
}

/*
	Name: undo_link_changes
	Namespace: zm_utility
	Checksum: 0xEAD97BCF
	Offset: 0xE798
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function undo_link_changes()
{
	/#
		println("");
		println("");
		println("");
	#/
	link_changes_internal(&unlink_nodes_wrapper, &link_nodes_wrapper);
	delete_spawned_path_nodes();
}

/*
	Name: redo_link_changes
	Namespace: zm_utility
	Checksum: 0xA5F41F53
	Offset: 0xE838
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function redo_link_changes()
{
	/#
		println("");
		println("");
		println("");
	#/
	respawn_path_nodes();
	link_changes_internal(&link_nodes_wrapper, &unlink_nodes_wrapper);
}

/*
	Name: is_gametype_active
	Namespace: zm_utility
	Checksum: 0x35A17A69
	Offset: 0xE8D8
	Size: 0xB2
	Parameters: 1
	Flags: None
*/
function is_gametype_active(a_gametypes)
{
	b_is_gametype_active = 0;
	if(!isarray(a_gametypes))
	{
		a_gametypes = array(a_gametypes);
	}
	for(i = 0; i < a_gametypes.size; i++)
	{
		if(getdvarstring("g_gametype") == a_gametypes[i])
		{
			b_is_gametype_active = 1;
		}
	}
	return b_is_gametype_active;
}

/*
	Name: register_custom_spawner_entry
	Namespace: zm_utility
	Checksum: 0x44E10343
	Offset: 0xE998
	Size: 0x3E
	Parameters: 2
	Flags: None
*/
function register_custom_spawner_entry(spot_noteworthy, func)
{
	if(!isdefined(level.custom_spawner_entry))
	{
		level.custom_spawner_entry = [];
	}
	level.custom_spawner_entry[spot_noteworthy] = func;
}

/*
	Name: get_player_weapon_limit
	Namespace: zm_utility
	Checksum: 0xC4EDDAA4
	Offset: 0xE9E0
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function get_player_weapon_limit(player)
{
	if(isdefined(self.get_player_weapon_limit))
	{
		return [[self.get_player_weapon_limit]](player);
	}
	if(isdefined(level.get_player_weapon_limit))
	{
		return [[level.get_player_weapon_limit]](player);
	}
	weapon_limit = 2;
	if(player hasperk("specialty_additionalprimaryweapon"))
	{
		weapon_limit = level.additionalprimaryweapon_limit;
	}
	return weapon_limit;
}

/*
	Name: get_player_perk_purchase_limit
	Namespace: zm_utility
	Checksum: 0x36353639
	Offset: 0xEA78
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function get_player_perk_purchase_limit()
{
	n_perk_purchase_limit_override = level.perk_purchase_limit;
	if(isdefined(level.get_player_perk_purchase_limit))
	{
		n_perk_purchase_limit_override = self [[level.get_player_perk_purchase_limit]]();
	}
	return n_perk_purchase_limit_override;
}

/*
	Name: can_player_purchase_perk
	Namespace: zm_utility
	Checksum: 0x28A6B25
	Offset: 0xEAC0
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function can_player_purchase_perk()
{
	if(self.num_perks < self get_player_perk_purchase_limit())
	{
		return true;
	}
	if(self bgb::is_enabled("zm_bgb_unquenchable") || self bgb::is_enabled("zm_bgb_soda_fountain"))
	{
		return true;
	}
	return false;
}

/*
	Name: give_player_all_perks
	Namespace: zm_utility
	Checksum: 0x3C679C61
	Offset: 0xEB38
	Size: 0x122
	Parameters: 1
	Flags: Linked
*/
function give_player_all_perks(b_exclude_quick_revive = 0)
{
	a_str_perks = getarraykeys(level._custom_perks);
	foreach(str_perk in a_str_perks)
	{
		if(str_perk == "specialty_quickrevive" && b_exclude_quick_revive)
		{
			continue;
		}
		if(!self hasperk(str_perk))
		{
			self zm_perks::give_perk(str_perk, 0);
			if(isdefined(level.perk_bought_func))
			{
				self [[level.perk_bought_func]](str_perk);
			}
		}
	}
}

/*
	Name: wait_for_attractor_positions_complete
	Namespace: zm_utility
	Checksum: 0x5165B61C
	Offset: 0xEC68
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function wait_for_attractor_positions_complete()
{
	self waittill(#"attractor_positions_generated");
	self.attract_to_origin = 0;
}

/*
	Name: get_player_index
	Namespace: zm_utility
	Checksum: 0x5AA6EE9C
	Offset: 0xEC90
	Size: 0xDA
	Parameters: 1
	Flags: Linked
*/
function get_player_index(player)
{
	/#
		assert(isplayer(player));
	#/
	/#
		assert(isdefined(player.characterindex));
	#/
	/#
		if(player.entity_num == 0 && getdvarstring("") != "")
		{
			new_vo_index = getdvarint("");
			return new_vo_index;
		}
	#/
	return player.characterindex;
}

/*
	Name: get_specific_character
	Namespace: zm_utility
	Checksum: 0xC1660863
	Offset: 0xED78
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function get_specific_character(n_character_index)
{
	foreach(character in level.players)
	{
		if(character.characterindex == n_character_index)
		{
			return character;
		}
	}
	return undefined;
}

/*
	Name: zombie_goto_round
	Namespace: zm_utility
	Checksum: 0xF52DFD0B
	Offset: 0xEE20
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function zombie_goto_round(n_target_round)
{
	level notify(#"restart_round");
	if(n_target_round < 1)
	{
		n_target_round = 1;
	}
	level.zombie_total = 0;
	zombie_utility::ai_calculate_health(n_target_round);
	zm::set_round_number(n_target_round - 1);
	zombies = zombie_utility::get_round_enemy_array();
	if(isdefined(zombies))
	{
		array::run_all(zombies, &kill);
	}
	level.sndgotoroundoccurred = 1;
	level waittill(#"between_round_over");
}

/*
	Name: is_point_inside_enabled_zone
	Namespace: zm_utility
	Checksum: 0xAF0C32EC
	Offset: 0xEF00
	Size: 0x1A6
	Parameters: 2
	Flags: Linked
*/
function is_point_inside_enabled_zone(v_origin, ignore_zone)
{
	temp_ent = spawn("script_origin", v_origin);
	foreach(zone in level.zones)
	{
		if(!zone.is_enabled)
		{
			continue;
		}
		if(isdefined(ignore_zone) && zone == ignore_zone)
		{
			continue;
		}
		foreach(e_volume in zone.volumes)
		{
			if(temp_ent istouching(e_volume))
			{
				temp_ent delete();
				return true;
			}
		}
	}
	temp_ent delete();
	return false;
}

/*
	Name: clear_streamer_hint
	Namespace: zm_utility
	Checksum: 0x3A040836
	Offset: 0xF0B0
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function clear_streamer_hint()
{
	if(isdefined(self.streamer_hint))
	{
		self.streamer_hint delete();
		self.streamer_hint = undefined;
	}
	self notify(#"wait_clear_streamer_hint");
}

/*
	Name: wait_clear_streamer_hint
	Namespace: zm_utility
	Checksum: 0x1CB60E03
	Offset: 0xF100
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function wait_clear_streamer_hint(lifetime)
{
	self endon(#"wait_clear_streamer_hint");
	wait(lifetime);
	if(isdefined(self))
	{
		self clear_streamer_hint();
	}
}

/*
	Name: create_streamer_hint
	Namespace: zm_utility
	Checksum: 0x2B135A74
	Offset: 0xF148
	Size: 0x1AC
	Parameters: 4
	Flags: Linked
*/
function create_streamer_hint(origin, angles, value, lifetime)
{
	if(self == level)
	{
		foreach(player in getplayers())
		{
			player clear_streamer_hint();
		}
	}
	self clear_streamer_hint();
	self.streamer_hint = createstreamerhint(origin, value);
	if(isdefined(angles))
	{
		self.streamer_hint.angles = angles;
	}
	if(self != level)
	{
		self.streamer_hint setinvisibletoall();
		self.streamer_hint setvisibletoplayer(self);
	}
	self.streamer_hint setincludemeshes(1);
	self notify(#"wait_clear_streamer_hint");
	if(isdefined(lifetime) && lifetime > 0)
	{
		self thread wait_clear_streamer_hint(lifetime);
	}
}

/*
	Name: approximate_path_dist
	Namespace: zm_utility
	Checksum: 0x9ED47BD9
	Offset: 0xF300
	Size: 0x180
	Parameters: 1
	Flags: Linked
*/
function approximate_path_dist(player)
{
	aiprofile_beginentry("approximate_path_dist");
	goal_pos = player.origin;
	if(isdefined(player.last_valid_position))
	{
		goal_pos = player.last_valid_position;
	}
	if(isdefined(player.b_teleporting) && player.b_teleporting)
	{
		if(isdefined(player.teleport_location))
		{
			goal_pos = player.teleport_location;
			if(!ispointonnavmesh(goal_pos, self))
			{
				position = getclosestpointonnavmesh(goal_pos, 100, 15);
				if(isdefined(position))
				{
					goal_pos = position;
				}
			}
		}
	}
	/#
		assert(isdefined(level.pathdist_type), "");
	#/
	approx_dist = pathdistance(self.origin, goal_pos, 1, self, level.pathdist_type);
	aiprofile_endentry();
	return approx_dist;
}

/*
	Name: register_slowdown
	Namespace: zm_utility
	Checksum: 0x3F21E441
	Offset: 0xF488
	Size: 0x8C
	Parameters: 3
	Flags: None
*/
function register_slowdown(str_type, n_rate, n_duration)
{
	if(!isdefined(level.a_n_slowdown_rates))
	{
		level.a_n_slowdown_rates = [];
	}
	level.a_s_slowdowns[str_type] = spawnstruct();
	level.a_s_slowdowns[str_type].n_rate = n_rate;
	level.a_s_slowdowns[str_type].n_duration = n_duration;
}

/*
	Name: slowdown_ai
	Namespace: zm_utility
	Checksum: 0x7A59BB11
	Offset: 0xF520
	Size: 0x284
	Parameters: 1
	Flags: None
*/
function slowdown_ai(str_type)
{
	self notify(#"starting_slowdown_ai");
	self endon(#"starting_slowdown_ai");
	self endon(#"death");
	/#
		assert(isdefined(level.a_s_slowdowns[str_type]), ("" + str_type) + "");
	#/
	if(!isdefined(self.a_n_slowdown_timeouts))
	{
		self.a_n_slowdown_timeouts = [];
	}
	n_time = gettime();
	n_timeout = n_time + level.a_s_slowdowns[str_type].n_duration;
	if(!isdefined(self.a_n_slowdown_timeouts[str_type]) || self.a_n_slowdown_timeouts[str_type] < n_timeout)
	{
		self.a_n_slowdown_timeouts[str_type] = n_timeout;
	}
	while(self.a_n_slowdown_timeouts.size)
	{
		str_lowest_type = undefined;
		n_lowest_rate = 10;
		foreach(str_index, n_slowdown_timeout in self.a_n_slowdown_timeouts)
		{
			if(n_slowdown_timeout <= n_time)
			{
				self.a_n_slowdown_timeouts[str_index] = undefined;
				continue;
			}
			if(level.a_s_slowdowns[str_index].n_rate < n_lowest_rate)
			{
				str_lowest_type = str_index;
				n_lowest_rate = level.a_s_slowdowns[str_index].n_rate;
			}
		}
		if(isdefined(str_lowest_type))
		{
			self asmsetanimationrate(n_lowest_rate);
			n_duration = self.a_n_slowdown_timeouts[str_lowest_type] - n_time;
			wait(n_duration);
			self.a_n_slowdown_timeouts[str_lowest_type] = undefined;
		}
	}
	self asmsetanimationrate(1);
}

/*
	Name: get_player_closest_to
	Namespace: zm_utility
	Checksum: 0x9BEB302D
	Offset: 0xF7B0
	Size: 0x7C
	Parameters: 1
	Flags: None
*/
function get_player_closest_to(e_target)
{
	a_players = arraycopy(level.activeplayers);
	arrayremovevalue(a_players, e_target);
	e_closest_player = arraygetclosest(e_target.origin, a_players);
	return e_closest_player;
}

/*
	Name: is_facing
	Namespace: zm_utility
	Checksum: 0xB53EF20
	Offset: 0xF838
	Size: 0x18A
	Parameters: 3
	Flags: None
*/
function is_facing(facee, requireddot = 0.5, b_2d = 1)
{
	orientation = self getplayerangles();
	v_forward = anglestoforward(orientation);
	v_to_facee = facee.origin - self.origin;
	if(b_2d)
	{
		v_forward_computed = (v_forward[0], v_forward[1], 0);
		v_to_facee_computed = (v_to_facee[0], v_to_facee[1], 0);
	}
	else
	{
		v_forward_computed = v_forward;
		v_to_facee_computed = v_to_facee;
	}
	v_unit_forward_computed = vectornormalize(v_forward_computed);
	v_unit_to_facee_computed = vectornormalize(v_to_facee_computed);
	dotproduct = vectordot(v_unit_forward_computed, v_unit_to_facee_computed);
	return dotproduct > requireddot;
}

/*
	Name: is_solo_ranked_game
	Namespace: zm_utility
	Checksum: 0x343B0844
	Offset: 0xF9D0
	Size: 0x32
	Parameters: 0
	Flags: Linked
*/
function is_solo_ranked_game()
{
	return level.players.size == 1 && getdvarint("zm_private_rankedmatch", 0);
}

/*
	Name: upload_zm_dash_counters
	Namespace: zm_utility
	Checksum: 0x8A6360A
	Offset: 0xFA10
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function upload_zm_dash_counters(force_upload = 0)
{
	if(!sessionmodeisonlinegame())
	{
		return;
	}
	if(isdefined(level.var_e097db22) && level.var_e097db22 || (isdefined(force_upload) && force_upload))
	{
		util::function_ad904acd();
	}
	level.var_e097db22 = undefined;
}

/*
	Name: upload_zm_dash_counters_end_game
	Namespace: zm_utility
	Checksum: 0x49ABF15F
	Offset: 0xFA98
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function upload_zm_dash_counters_end_game()
{
	foreach(player in getplayers())
	{
		if(player flag::exists("finished_reporting_consumables"))
		{
			player flag::wait_till("finished_reporting_consumables");
		}
	}
	if(level flag::exists("consumables_reported") && level flag::get("consumables_reported"))
	{
		increment_zm_dash_counter("end_reported_consumables", 1);
	}
	upload_zm_dash_counters(1);
}

/*
	Name: increment_zm_dash_counter
	Namespace: zm_utility
	Checksum: 0x56C30DC5
	Offset: 0xFBD0
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function increment_zm_dash_counter(counter_name, amount)
{
	if(!sessionmodeisonlinegame())
	{
		return;
	}
	counter_name = function_62f3bbf4(counter_name);
	level.var_e097db22 = 1;
	util::function_a4c90358(counter_name, amount);
}

/*
	Name: function_62f3bbf4
	Namespace: zm_utility
	Checksum: 0xD16C54F9
	Offset: 0xFC40
	Size: 0x76
	Parameters: 1
	Flags: Linked
*/
function function_62f3bbf4(counter_name)
{
	var_fa7fbeaf = "zm_dash_";
	if(is_solo_ranked_game())
	{
		var_fa7fbeaf = var_fa7fbeaf + "solo_";
	}
	else
	{
		var_fa7fbeaf = var_fa7fbeaf + "coop_";
	}
	var_fa7fbeaf = var_fa7fbeaf + counter_name;
	return var_fa7fbeaf;
}

/*
	Name: function_8eb96012
	Namespace: zm_utility
	Checksum: 0x87CB84D7
	Offset: 0xFCC0
	Size: 0xB4
	Parameters: 3
	Flags: Linked, Private
*/
function private function_8eb96012(ishost, var_95597467, var_88b8e8ec)
{
	path = spawnstruct();
	path.hosted = (ishost ? "HOSTED" : "PLAYED");
	path.var_95597467 = (var_95597467 ? "USED" : "UNUSED");
	path.var_c0cf8114 = (var_88b8e8ec ? "SOLO" : "COOP");
	return path;
}

/*
	Name: function_9878c818
	Namespace: zm_utility
	Checksum: 0xFE067FA6
	Offset: 0xFD80
	Size: 0x72
	Parameters: 2
	Flags: Private
*/
function private function_9878c818(var_fabefe22, statname)
{
	return self getdstat("dashboardingTrackingHistory", "gameSizeHistory", var_fabefe22.var_c0cf8114, "consumablesHistory", var_fabefe22.var_95597467, "periodHistory", var_fabefe22.hosted, statname);
}

/*
	Name: function_96c1b925
	Namespace: zm_utility
	Checksum: 0x80A342F
	Offset: 0xFE00
	Size: 0xAC
	Parameters: 3
	Flags: Linked, Private
*/
function private function_96c1b925(var_fabefe22, statname, value)
{
	self adddstat("dashboardingTrackingHistory", "gameSizeHistory", var_fabefe22.var_c0cf8114, "consumablesHistory", var_fabefe22.var_95597467, "periodHistory", var_fabefe22.hosted, statname, value);
	self adddstat("dashboardingTrackingHistory", "statsSinceLastComscoreEvent", statname, value);
}

/*
	Name: function_e33a692a
	Namespace: zm_utility
	Checksum: 0xADADD5C6
	Offset: 0xFEB8
	Size: 0xE4
	Parameters: 1
	Flags: Linked, Private
*/
function private function_e33a692a(type)
{
	var_44222444 = self getdstat("dashboardingTrackingHistory", "currentDashboardingTrackingHistoryIndex");
	self setdstat("dashboardingTrackingHistory", "quitType", var_44222444, type);
	var_36d3e544 = (var_44222444 + 1) % 32;
	if(var_36d3e544 == 0)
	{
		self setdstat("dashboardingTrackingHistory", "bufferFull", 1);
	}
	self setdstat("dashboardingTrackingHistory", "currentDashboardingTrackingHistoryIndex", var_36d3e544);
}

/*
	Name: zm_dash_stats_game_start
	Namespace: zm_utility
	Checksum: 0x46ED9518
	Offset: 0xFFA8
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function zm_dash_stats_game_start()
{
	if(!(sessionmodeisonlinegame() && getdvarint("zm_dash_stats_enable_tracking", 0)))
	{
		return;
	}
	level flag::wait_till("all_players_connected");
	self setdstat("dashboardingTrackingHistory", "trackedFirstGame", 1);
	var_fabefe22 = function_8eb96012(self ishost(), 0, is_solo_ranked_game());
	self function_96c1b925(var_fabefe22, "started", 1);
	self setdstat("dashboardingTrackingHistory", "lastGameWasHosted", self ishost());
	self setdstat("dashboardingTrackingHistory", "lastGameUsedConsumable", 0);
	self setdstat("dashboardingTrackingHistory", "lastGameWasCoop", !is_solo_ranked_game());
	uploadstats(self);
}

/*
	Name: zm_dash_stats_game_end
	Namespace: zm_utility
	Checksum: 0xB1C0B49A
	Offset: 0x10150
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function zm_dash_stats_game_end()
{
	if(!(sessionmodeisonlinegame() && getdvarint("zm_dash_stats_enable_tracking", 0)))
	{
		return;
	}
	var_822c3017 = self getdstat("dashboardingTrackingHistory", "lastGameWasHosted");
	var_f4d48599 = self getdstat("dashboardingTrackingHistory", "lastGameUsedConsumable");
	var_44d1dba9 = self getdstat("dashboardingTrackingHistory", "lastGameWasCoop");
	var_fabefe22 = function_8eb96012(var_822c3017, var_f4d48599, !var_44d1dba9);
	self function_96c1b925(var_fabefe22, "completed", 1);
	self function_e33a692a(4);
}

/*
	Name: zm_dash_stats_wait_for_consumable_use
	Namespace: zm_utility
	Checksum: 0x67D10ED0
	Offset: 0x10290
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function zm_dash_stats_wait_for_consumable_use()
{
	if(!(sessionmodeisonlinegame() && getdvarint("zm_dash_stats_enable_tracking", 0)))
	{
		return;
	}
	self endon(#"disconnect");
	self flag::wait_till("used_consumable");
	self setdstat("dashboardingTrackingHistory", "lastGameUsedConsumable", 1);
	var_9eb8805a = self getdstat("dashboardingTrackingHistory", "lastGameWasHosted");
	var_b47e6298 = self getdstat("dashboardingTrackingHistory", "lastGameWasCoop");
	var_ab363340 = function_8eb96012(var_9eb8805a, 0, !var_b47e6298);
	var_c084221 = function_8eb96012(var_9eb8805a, 1, !var_b47e6298);
	self function_96c1b925(var_ab363340, "started", -1);
	self function_96c1b925(var_c084221, "started", 1);
	uploadstats(self);
}

