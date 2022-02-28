// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_staff_fire;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_tomb_amb;
#using scripts\zm\zm_tomb_utility;
#using scripts\zm\zm_tomb_vo;

#using_animtree("generic");

#namespace zm_tomb_tank;

/*
	Name: init
	Namespace: zm_tomb_tank
	Checksum: 0x42435215
	Offset: 0xA50
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("vehicle", "tank_tread_fx", 21000, 1, "int");
	clientfield::register("vehicle", "tank_flamethrower_fx", 21000, 2, "int");
	clientfield::register("vehicle", "tank_cooldown_fx", 21000, 2, "int");
	callback::on_spawned(&onplayerspawned);
	level.enemy_location_override_func = &enemy_location_override;
	level.zm_mantle_over_40_move_speed_override = &zm_mantle_over_40_move_speed_override;
}

/*
	Name: main
	Namespace: zm_tomb_tank
	Checksum: 0xED70B033
	Offset: 0xB40
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level.vh_tank = getent("tank", "targetname");
	level.vh_tank tank_setup();
	level.vh_tank thread tank_discovery_vo();
	level thread zm_tomb_vo::watch_occasional_line("tank", "tank_flame_zombie", "vo_tank_flame_zombie");
	level thread zm_tomb_vo::watch_occasional_line("tank", "tank_leave", "vo_tank_leave");
	level thread zm_tomb_vo::watch_occasional_line("tank", "tank_cooling", "vo_tank_cooling");
}

/*
	Name: onplayerspawned
	Namespace: zm_tomb_tank
	Checksum: 0x4DB0ABFB
	Offset: 0xC38
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function onplayerspawned()
{
	self.b_already_on_tank = 0;
	self.var_32857832 = 0;
}

/*
	Name: tank_discovery_vo
	Namespace: zm_tomb_tank
	Checksum: 0x5ACA20D2
	Offset: 0xC60
	Size: 0x1C8
	Parameters: 0
	Flags: Linked
*/
function tank_discovery_vo()
{
	max_dist_sq = 640000;
	level flag::wait_till("activate_zone_village_0");
	while(true)
	{
		a_players = getplayers();
		foreach(e_player in a_players)
		{
			dist_sq = distance2dsquared(level.vh_tank.origin, e_player.origin);
			height_diff = abs(level.vh_tank.origin[2] - e_player.origin[2]);
			if(dist_sq < max_dist_sq && height_diff < 150 && (!(isdefined(e_player.isspeaking) && e_player.isspeaking)))
			{
				e_player zm_audio::create_and_play_dialog("tank", "discover_tank");
				return;
			}
		}
		wait(0.1);
	}
}

/*
	Name: tank_drop_powerups
	Namespace: zm_tomb_tank
	Checksum: 0x40D9FEEC
	Offset: 0xE30
	Size: 0x340
	Parameters: 0
	Flags: Linked
*/
function tank_drop_powerups()
{
	level flag::wait_till("start_zombie_round_logic");
	a_drop_nodes = [];
	for(i = 0; i < 3; i++)
	{
		drop_num = i + 1;
		a_drop_nodes[i] = getvehiclenode("tank_powerup_drop_" + drop_num, "script_noteworthy");
		a_drop_nodes[i].next_drop_round = level.round_number + i;
		s_drop = struct::get("tank_powerup_drop_" + drop_num, "targetname");
		a_drop_nodes[i].drop_pos = s_drop.origin;
	}
	a_possible_powerups = array("nuke", "full_ammo", "zombie_blood", "insta_kill", "fire_sale", "double_points");
	while(true)
	{
		self flag::wait_till("tank_moving");
		foreach(node in a_drop_nodes)
		{
			dist_sq = distance2dsquared(node.origin, self.origin);
			if(dist_sq < 40000)
			{
				a_players = get_players_on_tank(1);
				if(a_players.size > 0)
				{
					if(level.staff_part_count["elemental_staff_lightning"] == 0 && level.round_number >= node.next_drop_round)
					{
						str_powerup = array::random(a_possible_powerups);
						level thread zm_powerups::specific_powerup_drop(str_powerup, node.drop_pos);
						node.next_drop_round = level.round_number + randomintrange(8, 12);
						continue;
					}
					level notify(#"sam_clue_tank", self);
				}
			}
		}
		wait(2);
	}
}

/*
	Name: zm_mantle_over_40_move_speed_override
	Namespace: zm_tomb_tank
	Checksum: 0x6498439C
	Offset: 0x1178
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function zm_mantle_over_40_move_speed_override()
{
	traversealias = "barrier_walk";
	switch(self.zombie_move_speed)
	{
		case "chase_bus":
		{
			traversealias = "barrier_sprint";
			break;
		}
		default:
		{
			/#
				assertmsg(("" + self.zombie_move_speed) + "");
			#/
		}
	}
	return traversealias;
}

/*
	Name: tankuseanimtree
	Namespace: zm_tomb_tank
	Checksum: 0xAF6D91FA
	Offset: 0x1208
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function tankuseanimtree()
{
	self useanimtree($generic);
}

/*
	Name: drawtag
	Namespace: zm_tomb_tank
	Checksum: 0xB0FA175C
	Offset: 0x1238
	Size: 0xB4
	Parameters: 2
	Flags: Linked
*/
function drawtag(tag, opcolor)
{
	/#
		org = self gettagorigin(tag);
		ang = self gettagangles(tag);
		box(org, vectorscale((-1, -1, 0), 8), vectorscale((1, 1, 1), 8), ang[1], opcolor, 1, 0, 1);
	#/
}

/*
	Name: draw_tank_tag
	Namespace: zm_tomb_tank
	Checksum: 0xA4D79DFC
	Offset: 0x12F8
	Size: 0xA8
	Parameters: 2
	Flags: Linked
*/
function draw_tank_tag(tag, opcolor)
{
	/#
		self endon(#"death");
		for(;;)
		{
			if(self tank_tag_is_valid(tag))
			{
				drawtag(tag.str_tag, vectorscale((0, 1, 0), 255));
			}
			else
			{
				drawtag(tag.str_tag, vectorscale((1, 0, 0), 255));
			}
			wait(0.05);
		}
	#/
}

/*
	Name: tank_debug_tags
	Namespace: zm_tomb_tank
	Checksum: 0x895752B9
	Offset: 0x13A8
	Size: 0x368
	Parameters: 0
	Flags: Linked
*/
function tank_debug_tags()
{
	/#
		setdvar("", "");
		adddebugcommand("");
		level flag::wait_till("");
		a_spots = struct::get_array("", "");
		while(true)
		{
			if(getdvarstring("") == "")
			{
				if(!(isdefined(self.tags_drawing) && self.tags_drawing))
				{
					foreach(s_tag in self.a_tank_tags)
					{
						self thread draw_tank_tag(s_tag);
					}
					self.tags_drawing = 1;
				}
				ang = self.angles;
				foreach(s_spot in a_spots)
				{
					org = self tank_get_jump_down_offset(s_spot);
					box(org, vectorscale((-1, -1, 0), 4), vectorscale((1, 1, 1), 4), ang[1], vectorscale((1, 1, 0), 128), 1, 0, 1);
				}
				a_zombies = zombie_utility::get_round_enemy_array();
				foreach(e_zombie in a_zombies)
				{
					if(isdefined(e_zombie.tank_state))
					{
						print3d(e_zombie.origin + vectorscale((0, 0, 1), 60), e_zombie.tank_state, vectorscale((1, 0, 0), 255), 1);
					}
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: tank_jump_down_store_offset
	Namespace: zm_tomb_tank
	Checksum: 0xE418D3F8
	Offset: 0x1718
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function tank_jump_down_store_offset(s_pos)
{
	v_up = anglestoup(self.angles);
	v_right = anglestoright(self.angles);
	v_fwd = anglestoforward(self.angles);
	offset = s_pos.origin - self.origin;
	s_pos.tank_offset = (vectordot(v_fwd, offset), vectordot(v_right, offset), vectordot(v_up, offset));
}

/*
	Name: tank_get_jump_down_offset
	Namespace: zm_tomb_tank
	Checksum: 0x73325F26
	Offset: 0x1828
	Size: 0xD6
	Parameters: 1
	Flags: Linked
*/
function tank_get_jump_down_offset(s_pos)
{
	v_up = anglestoup(self.angles);
	v_right = anglestoright(self.angles);
	v_fwd = anglestoforward(self.angles);
	v_offset = s_pos.tank_offset;
	return (self.origin + (v_offset[0] * v_fwd)) + (v_offset[1] * v_right) + (v_offset[2] * v_up);
}

/*
	Name: tank_setup
	Namespace: zm_tomb_tank
	Checksum: 0x31A4D091
	Offset: 0x1908
	Size: 0x714
	Parameters: 0
	Flags: Linked
*/
function tank_setup()
{
	self flag::init("tank_moving");
	self flag::init("tank_activated");
	self flag::init("tank_cooldown");
	level.tank_boxes_enabled = 0;
	self.tag_occupied = [];
	self.health = 1000;
	self.n_players_on = 0;
	self.chase_pos_time = 0;
	self hidepart("tag_flamethrower");
	self setmovingplatformenabled(1);
	self.e_roof = getent("vol_on_tank_watch", "targetname");
	self.e_roof enablelinkto();
	self.e_roof linkto(self);
	self.var_4da798ac = spawn("trigger_box", (-8192, -3955.5, 144), 0, 96, 41.5, 52.5);
	self.var_4da798ac enablelinkto();
	self.var_4da798ac linkto(self);
	self.t_use = getent("trig_use_tank", "targetname");
	self.t_use enablelinkto();
	self.t_use linkto(self);
	self.t_use sethintstring(&"ZM_TOMB_X2AT", 500);
	self.t_use setcursorhint("HINT_NOICON");
	self.var_5c499e37 = getent("tank_navmesh_cutter", "targetname");
	self.var_5c499e37 enablelinkto();
	self.var_5c499e37 linkto(self);
	self.var_5c499e37 notsolid();
	self.t_hurt = getent("trig_hurt_tank", "targetname");
	self.t_hurt enablelinkto();
	self.t_hurt linkto(self);
	self.t_kill = spawn("trigger_box", (-8192, -4300, 36), 0, 200, 150, 80);
	self.t_kill enablelinkto();
	self.t_kill linkto(self);
	self.var_e444d47d[0] = spawn("trigger_box", (-8280, -3960, 112), 0, 64, 60, 96);
	self.var_e444d47d[0].angles = vectorscale((0, 1, 0), 90);
	self.var_e444d47d[0] enablelinkto();
	self.var_e444d47d[0] linkto(self);
	self.var_e444d47d[1] = spawn("trigger_box", (-8104, -3960, 112), 0, 64, 60, 96);
	self.var_e444d47d[1].angles = vectorscale((0, 1, 0), 90);
	self.var_e444d47d[1] enablelinkto();
	self.var_e444d47d[1] linkto(self);
	self.var_8f5473ed = getweapon("zombie_markiv_flamethrower");
	m_tank_path_blocker = getent("tank_path_blocker", "targetname");
	m_tank_path_blocker delete();
	a_tank_jump_down_spots = struct::get_array("tank_jump_down_spots", "script_noteworthy");
	foreach(s_spot in a_tank_jump_down_spots)
	{
		self tank_jump_down_store_offset(s_spot);
	}
	self thread players_on_tank_update();
	self thread zombies_watch_tank();
	self thread function_c9714eb4();
	self thread function_617c74cb();
	self thread tank_station();
	self thread tank_run_flamethrowers();
	self thread do_treadfx();
	self thread do_cooldown_fx();
	self thread function_118e38b5();
	self thread tank_drop_powerups();
	/#
		self thread tank_debug_tags();
	#/
	self playloopsound("zmb_tank_idle", 0.5);
}

/*
	Name: function_c9714eb4
	Namespace: zm_tomb_tank
	Checksum: 0x44384F02
	Offset: 0x2028
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function function_c9714eb4()
{
	self endon(#"death");
	level flag::wait_till("start_zombie_round_logic");
	do
	{
		for(var_6b1535d6 = 0; var_6b1535d6 < self.a_tank_tags.size; var_6b1535d6++)
		{
			tag_origin = self gettagorigin(self.a_tank_tags[var_6b1535d6].str_tag);
			queryresult = positionquery_source_navigation(tag_origin, 0, 32, 128, 4);
			if(queryresult.data.size)
			{
				result = queryresult.data[0];
				self.a_tank_tags[var_6b1535d6].var_a6e72e82 = result.origin;
			}
		}
		self flag::wait_till("tank_moving");
		wait(0.05);
	}
	while(1);
}

/*
	Name: function_617c74cb
	Namespace: zm_tomb_tank
	Checksum: 0x5999E775
	Offset: 0x2178
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function function_617c74cb()
{
	self endon(#"death");
	level flag::wait_till("start_zombie_round_logic");
	do
	{
		for(var_6b1535d6 = 0; var_6b1535d6 < self.a_mechz_tags.size; var_6b1535d6++)
		{
			tag_origin = self gettagorigin(self.a_mechz_tags[var_6b1535d6].str_tag);
			queryresult = positionquery_source_navigation(tag_origin, 0, 32, 128, 4);
			if(queryresult.data.size)
			{
				result = queryresult.data[0];
				self.a_mechz_tags[var_6b1535d6].var_a6e72e82 = result.origin;
			}
		}
		self flag::wait_till("tank_moving");
		self flag::wait_till_clear("tank_moving");
	}
	while(1);
}

/*
	Name: function_1db98f69
	Namespace: zm_tomb_tank
	Checksum: 0x9CA331F6
	Offset: 0x22E0
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_1db98f69(tag_name)
{
	foreach(tag_struct in self.a_tank_tags)
	{
		if(tag_struct.str_tag == tag_name)
		{
			return tag_struct.var_a6e72e82;
		}
	}
	return undefined;
}

/*
	Name: function_21d81b2c
	Namespace: zm_tomb_tank
	Checksum: 0xC045D631
	Offset: 0x2390
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_21d81b2c(tag_name)
{
	foreach(tag_struct in self.a_mechz_tags)
	{
		if(tag_struct.str_tag == tag_name)
		{
			return tag_struct.var_a6e72e82;
		}
	}
	return undefined;
}

/*
	Name: do_cooldown_fx
	Namespace: zm_tomb_tank
	Checksum: 0x7434DAE9
	Offset: 0x2440
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function do_cooldown_fx()
{
	self endon(#"death");
	level flag::wait_till("start_zombie_round_logic");
	while(true)
	{
		self clientfield::set("tank_cooldown_fx", 2);
		self flag::wait_till("tank_moving");
		self clientfield::set("tank_cooldown_fx", 0);
		self flag::wait_till("tank_cooldown");
		self clientfield::set("tank_cooldown_fx", 1);
		self flag::wait_till_clear("tank_cooldown");
	}
}

/*
	Name: do_treadfx
	Namespace: zm_tomb_tank
	Checksum: 0x8F1A1CED
	Offset: 0x2540
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function do_treadfx()
{
	self endon(#"death");
	while(true)
	{
		self flag::wait_till("tank_moving");
		self clientfield::set("tank_tread_fx", 1);
		self flag::wait_till_clear("tank_moving");
		self clientfield::set("tank_tread_fx", 0);
	}
}

/*
	Name: function_118e38b5
	Namespace: zm_tomb_tank
	Checksum: 0x977EE6F4
	Offset: 0x25E0
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_118e38b5()
{
	self endon(#"death");
	self vehicle::lights_off();
	while(true)
	{
		self flag::wait_till("tank_moving");
		self vehicle::lights_on();
		self flag::wait_till_clear("tank_moving");
		self vehicle::lights_off();
	}
}

/*
	Name: disconnect_reconnect_paths
	Namespace: zm_tomb_tank
	Checksum: 0xADA032F4
	Offset: 0x2688
	Size: 0x88
	Parameters: 1
	Flags: None
*/
function disconnect_reconnect_paths(vh_tank)
{
	self endon(#"death");
	while(true)
	{
		self disconnectpaths();
		wait(1);
		while(vh_tank getspeedmph() < 1)
		{
			wait(0.05);
		}
		self connectpaths();
		wait(0.5);
	}
}

/*
	Name: tank_rumble_update
	Namespace: zm_tomb_tank
	Checksum: 0x649F6B6D
	Offset: 0x2718
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function tank_rumble_update()
{
	while(self.b_already_on_tank)
	{
		if(level.vh_tank flag::get("tank_moving"))
		{
			self clientfield::set_to_player("player_rumble_and_shake", 6);
		}
		else
		{
			self clientfield::set_to_player("player_rumble_and_shake", 0);
		}
		wait(1);
	}
	self clientfield::set_to_player("player_rumble_and_shake", 0);
}

/*
	Name: players_on_tank_update
	Namespace: zm_tomb_tank
	Checksum: 0x996D8F02
	Offset: 0x27B8
	Size: 0x330
	Parameters: 0
	Flags: Linked
*/
function players_on_tank_update()
{
	level flag::wait_till("start_zombie_round_logic");
	self thread tank_disconnect_paths();
	while(true)
	{
		a_players = getplayers();
		foreach(e_player in a_players)
		{
			if(zombie_utility::is_player_valid(e_player))
			{
				if(isdefined(e_player.b_already_on_tank) && !e_player.b_already_on_tank && e_player entity_on_tank())
				{
					e_player.b_already_on_tank = 1;
					self.n_players_on++;
					if(self flag::get("tank_cooldown"))
					{
						level notify(#"vo_tank_cooling", e_player);
					}
					e_player thread tank_rumble_update();
					e_player thread tank_rides_around_map_achievement_watcher();
					e_player thread tank_force_crouch_from_prone_after_on_tank();
					foreach(trig in self.var_e444d47d)
					{
						e_player thread function_de2a4a6e(trig);
					}
					e_player allowcrouch(1);
					e_player allowprone(0);
					continue;
				}
				if(isdefined(e_player.b_already_on_tank) && e_player.b_already_on_tank && !e_player entity_on_tank())
				{
					e_player.b_already_on_tank = 0;
					self.n_players_on--;
					level notify(#"vo_tank_leave", e_player);
					e_player notify(#"player_jumped_off_tank");
					e_player clientfield::set_to_player("player_rumble_and_shake", 0);
					e_player allowprone(1);
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: tank_force_crouch_from_prone_after_on_tank
	Namespace: zm_tomb_tank
	Checksum: 0x72AD89CD
	Offset: 0x2AF0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function tank_force_crouch_from_prone_after_on_tank()
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	wait(1);
	if("prone" == self getstance())
	{
		self setstance("crouch");
	}
}

/*
	Name: function_de2a4a6e
	Namespace: zm_tomb_tank
	Checksum: 0x3B4FDC7B
	Offset: 0x2B58
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function function_de2a4a6e(trig)
{
	self endon(#"player_jumped_off_tank");
	while(self.b_already_on_tank)
	{
		trig waittill(#"trigger", player);
		if(player == self && self isonground())
		{
			v_push = anglestoforward(trig.angles) * 150;
			self setvelocity(v_push);
		}
		wait(0.05);
	}
}

/*
	Name: tank_rides_around_map_achievement_watcher
	Namespace: zm_tomb_tank
	Checksum: 0xC68F00DA
	Offset: 0x2C10
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function tank_rides_around_map_achievement_watcher()
{
	self endon(#"death_or_disconnect");
	self endon(#"player_jumped_off_tank");
	if(level.vh_tank flag::get("tank_moving"))
	{
		level.vh_tank flag::wait_till_clear("tank_moving");
	}
	str_starting_location = level.vh_tank.str_location_current;
	do
	{
		level.vh_tank flag::wait_till("tank_moving");
		level.vh_tank flag::wait_till_clear("tank_moving");
	}
	while(str_starting_location != level.vh_tank.str_location_current);
	self notify(#"rode_tank_around_map");
}

/*
	Name: entity_on_tank
	Namespace: zm_tomb_tank
	Checksum: 0x8FCF0E4B
	Offset: 0x2D00
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function entity_on_tank()
{
	if(!self isonground() && (self istouching(level.vh_tank.e_roof) || self istouching(level.vh_tank.var_4da798ac)))
	{
		return true;
	}
	if(self getgroundent() === level.vh_tank)
	{
		return true;
	}
	return false;
}

/*
	Name: tank_station
	Namespace: zm_tomb_tank
	Checksum: 0x22A3643F
	Offset: 0x2DA8
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function tank_station()
{
	self thread tank_watch_use();
	self thread tank_movement();
	a_call_boxes = getentarray("trig_tank_station_call", "targetname");
	foreach(t_call_box in a_call_boxes)
	{
		t_call_box thread tank_call_box();
	}
	self.t_use waittill(#"trigger");
	level.tank_boxes_enabled = 1;
}

/*
	Name: tank_left_behind
	Namespace: zm_tomb_tank
	Checksum: 0x390023B2
	Offset: 0x2EB8
	Size: 0x2A4
	Parameters: 0
	Flags: Linked
*/
function tank_left_behind()
{
	wait(4);
	n_valid_dist_sq = 1000000;
	a_riders = get_players_on_tank(1);
	if(a_riders.size == 0)
	{
		return;
	}
	e_rider = array::random(a_riders);
	a_players = getplayers();
	a_victims = [];
	v_tank_fwd = anglestoforward(self.angles);
	foreach(e_player in a_players)
	{
		if(isdefined(e_player.b_already_on_tank) && e_player.b_already_on_tank)
		{
			continue;
		}
		if(distance2dsquared(e_player.origin, self.origin) > n_valid_dist_sq)
		{
			continue;
		}
		v_to_tank = self.origin - e_player.origin;
		v_to_tank = vectornormalize(v_to_tank);
		if(vectordot(v_to_tank, v_tank_fwd) < 0)
		{
			continue;
		}
		v_player_fwd = anglestoforward(e_player.angles);
		if(vectordot(v_player_fwd, v_to_tank) < 0)
		{
			continue;
		}
		a_victims[a_victims.size] = e_player;
	}
	if(a_victims.size == 0)
	{
		return;
	}
	e_victim = array::random(a_victims);
	zm_tomb_vo::tank_left_behind_vo(e_victim, e_rider);
}

/*
	Name: tank_watch_use
	Namespace: zm_tomb_tank
	Checksum: 0x4ADA75E
	Offset: 0x3168
	Size: 0x1A0
	Parameters: 0
	Flags: Linked
*/
function tank_watch_use()
{
	while(true)
	{
		self.t_use waittill(#"trigger", e_player);
		cooling_down = self flag::get("tank_cooldown");
		if(zombie_utility::is_player_valid(e_player) && e_player.score >= 500 && !cooling_down)
		{
			self flag::set("tank_activated");
			self flag::set("tank_moving");
			e_player thread zm_audio::create_and_play_dialog("tank", "tank_buy");
			self thread tank_left_behind();
			e_player zm_score::minus_to_player_score(500);
			self waittill(#"tank_stop");
			self playsound("zmb_tank_stop");
			self stoploopsound(1.5);
			if(isdefined(self.b_call_box_used) && self.b_call_box_used)
			{
				self.b_call_box_used = 0;
				self activate_tank_wait_with_no_cost();
			}
		}
	}
}

/*
	Name: activate_tank_wait_with_no_cost
	Namespace: zm_tomb_tank
	Checksum: 0xB057CEB3
	Offset: 0x3310
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function activate_tank_wait_with_no_cost()
{
	self endon(#"call_box_used");
	self.b_no_cost = 1;
	wait(0.05);
	self flag::wait_till_clear("tank_cooldown");
	self.t_use waittill(#"trigger", e_player);
	self flag::set("tank_activated");
	self flag::set("tank_moving");
	self.b_no_cost = 0;
}

/*
	Name: tank_call_box
	Namespace: zm_tomb_tank
	Checksum: 0x22E77461
	Offset: 0x33C0
	Size: 0x19A
	Parameters: 0
	Flags: Linked
*/
function tank_call_box()
{
	while(true)
	{
		self waittill(#"trigger", e_player);
		cooling_down = level.vh_tank flag::get("tank_cooldown");
		if(!level.vh_tank flag::get("tank_activated") && e_player.score >= 500 && !cooling_down)
		{
			level.vh_tank notify(#"call_box_used");
			level.vh_tank.b_call_box_used = 1;
			e_switch = getent(self.target, "targetname");
			self setinvisibletoall();
			wait(0.05);
			e_switch rotatepitch(-180, 0.5);
			e_switch waittill(#"rotatedone");
			e_switch rotatepitch(180, 0.5);
			level.vh_tank.t_use useby(e_player);
			level.vh_tank waittill(#"tank_stop");
		}
	}
}

/*
	Name: tank_call_boxes_update
	Namespace: zm_tomb_tank
	Checksum: 0x31BEA109
	Offset: 0x3568
	Size: 0x252
	Parameters: 0
	Flags: Linked
*/
function tank_call_boxes_update()
{
	str_loc = level.vh_tank.str_location_current;
	a_trigs = getentarray("trig_tank_station_call", "targetname");
	moving = level.vh_tank flag::get("tank_moving");
	cooling = level.vh_tank flag::get("tank_cooldown");
	foreach(trig in a_trigs)
	{
		at_this_station = trig.script_noteworthy == ("call_box_" + str_loc);
		trig setcursorhint("HINT_NOICON");
		if(moving)
		{
			trig setvisibletoall();
			trig sethintstring(&"ZM_TOMB_TNKM");
			continue;
		}
		if(!level.tank_boxes_enabled || at_this_station)
		{
			trig setinvisibletoall();
			continue;
		}
		if(cooling)
		{
			trig setvisibletoall();
			trig sethintstring(&"ZM_TOMB_TNKC");
			continue;
		}
		trig setvisibletoall();
		trig sethintstring(&"ZM_TOMB_X2CT", 500);
	}
}

/*
	Name: tank_movement
	Namespace: zm_tomb_tank
	Checksum: 0xCE6A130E
	Offset: 0x37C8
	Size: 0x420
	Parameters: 0
	Flags: Linked
*/
function tank_movement()
{
	n_path_start = getvehiclenode("tank_start", "targetname");
	self.origin = n_path_start.origin;
	self.angles = n_path_start.angles;
	self.var_78665041 = 0;
	self.a_locations = array("village", "bunkers");
	n_location_index = 0;
	self.str_location_current = self.a_locations[n_location_index];
	tank_call_boxes_update();
	while(true)
	{
		self flag::wait_till("tank_activated");
		if(!self.var_78665041)
		{
			self.var_78665041 = 1;
			self attachpath(n_path_start);
			self startpath();
			self thread follow_path(n_path_start);
			self setspeedimmediate(0);
		}
		/#
			iprintln("");
		#/
		self thread tank_connect_paths();
		self playsound("evt_tank_call");
		self setspeedimmediate(8);
		self.t_use setinvisibletoall();
		tank_call_boxes_update();
		self thread tank_kill_players();
		self thread tank_cooldown_timer();
		self waittill(#"tank_stop");
		self flag::set("tank_cooldown");
		self.t_use setvisibletoall();
		self.t_use sethintstring(&"ZM_TOMB_TNKC");
		self flag::clear("tank_moving");
		self thread tank_disconnect_paths();
		self setspeedimmediate(0);
		n_location_index++;
		if(n_location_index == self.a_locations.size)
		{
			n_location_index = 0;
		}
		self.str_location_current = self.a_locations[n_location_index];
		tank_call_boxes_update();
		self wait_for_tank_cooldown();
		self flag::clear("tank_cooldown");
		if(isdefined(self.b_no_cost) && self.b_no_cost)
		{
			self.t_use sethintstring(&"ZM_TOMB_X2ATF");
		}
		else
		{
			self.t_use sethintstring(&"ZM_TOMB_X2AT", 500);
		}
		self.t_use setcursorhint("HINT_NOICON");
		self flag::clear("tank_activated");
		tank_call_boxes_update();
	}
}

/*
	Name: tank_disconnect_paths
	Namespace: zm_tomb_tank
	Checksum: 0x96D977EB
	Offset: 0x3BF0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function tank_disconnect_paths()
{
	self endon(#"death");
	while(self getspeedmph() > 0)
	{
		wait(0.05);
	}
	self.var_5c499e37 disconnectpaths();
}

/*
	Name: tank_connect_paths
	Namespace: zm_tomb_tank
	Checksum: 0x2A167201
	Offset: 0x3C50
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function tank_connect_paths()
{
	self endon(#"death");
	self.var_5c499e37 connectpaths();
}

/*
	Name: tank_kill_players
	Namespace: zm_tomb_tank
	Checksum: 0x1693591A
	Offset: 0x3C80
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function tank_kill_players()
{
	self endon(#"tank_cooldown");
	foreach(player in level.players)
	{
		player.var_32857832 = 0;
	}
	while(true)
	{
		self.t_kill waittill(#"trigger", player);
		if(!(isdefined(player.b_already_on_tank) && player.b_already_on_tank) && (!(isdefined(player.var_d0cd73ec) && player.var_d0cd73ec)))
		{
			player thread tank_ran_me_over();
			wait(0.05);
		}
		else
		{
			player.var_32857832 = 0;
		}
	}
}

/*
	Name: tank_ran_me_over
	Namespace: zm_tomb_tank
	Checksum: 0x4129078
	Offset: 0x3DC0
	Size: 0x2FE
	Parameters: 0
	Flags: Linked
*/
function tank_ran_me_over()
{
	self.var_32857832++;
	if(self.var_32857832 < 20)
	{
		self dodamage(5, self.origin);
		return;
	}
	self.var_d0cd73ec = 1;
	self disableinvulnerability();
	self dodamage(self.health + 1000, self.origin);
	a_nodes = getnodesinradiussorted(self.origin, 256, 0, 72, "path", 15);
	foreach(node in a_nodes)
	{
		str_zone = zm_zonemgr::get_zone_from_position(node.origin);
		if(!isdefined(str_zone))
		{
			continue;
		}
		if(!(isdefined(node.b_player_downed_here) && node.b_player_downed_here))
		{
			start_wait = 0;
			black_screen_wait = 4;
			fade_in_time = 0.01;
			fade_out_time = 0.2;
			self thread hud::fade_to_black_for_x_sec(start_wait, black_screen_wait, fade_in_time, fade_out_time, "black");
			node.b_player_downed_here = 1;
			e_linker = spawn("script_origin", self.origin);
			self playerlinkto(e_linker);
			e_linker moveto(node.origin + vectorscale((0, 0, 1), 8), 1);
			e_linker wait_to_unlink(self);
			node.b_player_downed_here = undefined;
			e_linker delete();
			self.var_d0cd73ec = undefined;
			return;
		}
	}
	self.var_d0cd73ec = undefined;
}

/*
	Name: wait_to_unlink
	Namespace: zm_tomb_tank
	Checksum: 0x859F9844
	Offset: 0x40C8
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function wait_to_unlink(player)
{
	player endon(#"disconnect");
	wait(4);
	self unlink();
}

/*
	Name: tank_cooldown_timer
	Namespace: zm_tomb_tank
	Checksum: 0x8E40FCF7
	Offset: 0x4108
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function tank_cooldown_timer()
{
	self.n_cooldown_timer = 0;
	str_location_original = self.str_location_current;
	self playsound("zmb_tank_start");
	self stoploopsound(0.4);
	wait(0.4);
	self playloopsound("zmb_tank_loop", 1);
	while(str_location_original == self.str_location_current)
	{
		self.n_cooldown_timer = self.n_cooldown_timer + (self.n_players_on * 0.05);
		wait(0.05);
	}
}

/*
	Name: wait_for_tank_cooldown
	Namespace: zm_tomb_tank
	Checksum: 0x66FB1FE3
	Offset: 0x41E0
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function wait_for_tank_cooldown()
{
	self thread snd_fuel();
	if(self.n_cooldown_timer < 2)
	{
		self.n_cooldown_timer = 2;
	}
	else if(self.n_cooldown_timer > 120)
	{
		self.n_cooldown_timer = 120;
	}
	wait(self.n_cooldown_timer);
	level notify(#"stp_cd");
	self playsound("zmb_tank_ready");
	self playloopsound("zmb_tank_idle");
}

/*
	Name: snd_fuel
	Namespace: zm_tomb_tank
	Checksum: 0x99D2CF5E
	Offset: 0x42A8
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function snd_fuel()
{
	snd_cd_ent = spawn("script_origin", self.origin);
	snd_cd_ent linkto(self);
	wait(4);
	snd_cd_ent playsound("zmb_tank_fuel_start");
	wait(0.5);
	snd_cd_ent playloopsound("zmb_tank_fuel_loop");
	level waittill(#"stp_cd");
	snd_cd_ent stoploopsound(0.5);
	snd_cd_ent playsound("zmb_tank_fuel_end");
	wait(2);
	snd_cd_ent delete();
}

/*
	Name: follow_path
	Namespace: zm_tomb_tank
	Checksum: 0x6A064331
	Offset: 0x43B0
	Size: 0x16C
	Parameters: 1
	Flags: Linked
*/
function follow_path(n_path_start)
{
	self endon(#"death");
	/#
		assert(isdefined(n_path_start), "");
	#/
	self notify(#"newpath");
	self endon(#"newpath");
	n_next_point = n_path_start;
	while(isdefined(n_next_point))
	{
		self.n_next_node = getvehiclenode(n_next_point.target, "targetname");
		self waittill(#"reached_node", n_next_point);
		if(isdefined(n_next_point.script_noteworthy) && issubstr(n_next_point.script_noteworthy, "fxexp"))
		{
			exploder::exploder(n_next_point.script_noteworthy);
		}
		self.n_current = n_next_point;
		n_next_point notify(#"trigger", self);
		if(isdefined(n_next_point.script_noteworthy))
		{
			self notify(n_next_point.script_noteworthy);
			self notify(#"noteworthy", n_next_point.script_noteworthy, n_next_point);
		}
		waittillframeend();
	}
}

/*
	Name: tank_tag_array_setup
	Namespace: zm_tomb_tank
	Checksum: 0x18A250B9
	Offset: 0x4528
	Size: 0x448
	Parameters: 0
	Flags: Linked
*/
function tank_tag_array_setup()
{
	a_tank_tags = [];
	a_tank_tags[0] = spawnstruct();
	a_tank_tags[0].str_tag = "window_left_1_jmp_jnt";
	a_tank_tags[0].disabled_at_bunker = 1;
	a_tank_tags[0].disabled_at_church = 1;
	a_tank_tags[0].side = "left";
	a_tank_tags[0].var_bd6a9142 = "_markiv_leftfront";
	a_tank_tags[1] = spawnstruct();
	a_tank_tags[1].str_tag = "window_left_2_jmp_jnt";
	a_tank_tags[1].disabled_at_bunker = 1;
	a_tank_tags[1].disabled_at_church = 1;
	a_tank_tags[1].side = "left";
	a_tank_tags[1].var_bd6a9142 = "_markiv_leftmid";
	a_tank_tags[2] = spawnstruct();
	a_tank_tags[2].str_tag = "window_left_3_jmp_jnt";
	a_tank_tags[2].disabled_at_bunker = 1;
	a_tank_tags[2].disabled_at_church = 1;
	a_tank_tags[2].side = "left";
	a_tank_tags[2].var_bd6a9142 = "_markiv_leftrear";
	a_tank_tags[3] = spawnstruct();
	a_tank_tags[3].str_tag = "window_right_front_jmp_jnt";
	a_tank_tags[3].side = "front";
	a_tank_tags[3].var_bd6a9142 = "_markiv_front";
	a_tank_tags[4] = spawnstruct();
	a_tank_tags[4].str_tag = "window_right_1_jmp_jnt";
	a_tank_tags[4].side = "right";
	a_tank_tags[4].var_bd6a9142 = "_markiv_rightfront";
	a_tank_tags[5] = spawnstruct();
	a_tank_tags[5].str_tag = "window_right_2_jmp_jnt";
	a_tank_tags[5].disabled_at_church = 1;
	a_tank_tags[5].side = "right";
	a_tank_tags[5].var_bd6a9142 = "_markiv_rightmid";
	a_tank_tags[6] = spawnstruct();
	a_tank_tags[6].str_tag = "window_right_3_jmp_jnt";
	a_tank_tags[6].disabled_at_church = 1;
	a_tank_tags[6].side = "right";
	a_tank_tags[6].var_bd6a9142 = "_markiv_rightrear";
	a_tank_tags[7] = spawnstruct();
	a_tank_tags[7].str_tag = "window_left_rear_jmp_jnt";
	a_tank_tags[7].side = "rear";
	a_tank_tags[7].var_bd6a9142 = "_markiv_rear";
	return a_tank_tags;
}

/*
	Name: get_players_on_tank
	Namespace: zm_tomb_tank
	Checksum: 0xDDF7FC78
	Offset: 0x4978
	Size: 0x1A4
	Parameters: 1
	Flags: Linked
*/
function get_players_on_tank(valid_targets_only = 0)
{
	a_players_on_tank = [];
	a_players = getplayers();
	foreach(e_player in a_players)
	{
		if(zombie_utility::is_player_valid(e_player) && (isdefined(e_player.b_already_on_tank) && e_player.b_already_on_tank))
		{
			if(!valid_targets_only || (!(isdefined(e_player.ignoreme) && e_player.ignoreme) && zombie_utility::is_player_valid(e_player)))
			{
				if(!isdefined(a_players_on_tank))
				{
					a_players_on_tank = [];
				}
				else if(!isarray(a_players_on_tank))
				{
					a_players_on_tank = array(a_players_on_tank);
				}
				a_players_on_tank[a_players_on_tank.size] = e_player;
			}
		}
	}
	return a_players_on_tank;
}

/*
	Name: mechz_tag_array_setup
	Namespace: zm_tomb_tank
	Checksum: 0x20AD0F7D
	Offset: 0x4B28
	Size: 0x1A2
	Parameters: 0
	Flags: Linked
*/
function mechz_tag_array_setup()
{
	a_mechz_tags = [];
	a_mechz_tags[0] = spawnstruct();
	a_mechz_tags[0].str_tag = "tag_mechz_1";
	a_mechz_tags[0].in_use = 0;
	a_mechz_tags[0].in_use_by = undefined;
	a_mechz_tags[1] = spawnstruct();
	a_mechz_tags[1].str_tag = "tag_mechz_2";
	a_mechz_tags[1].in_use = 0;
	a_mechz_tags[1].in_use_by = undefined;
	a_mechz_tags[2] = spawnstruct();
	a_mechz_tags[2].str_tag = "tag_mechz_3";
	a_mechz_tags[2].in_use = 0;
	a_mechz_tags[2].in_use_by = undefined;
	a_mechz_tags[3] = spawnstruct();
	a_mechz_tags[3].str_tag = "tag_mechz_4";
	a_mechz_tags[3].in_use = 0;
	a_mechz_tags[3].in_use_by = undefined;
	return a_mechz_tags;
}

/*
	Name: mechz_tag_in_use_cleanup
	Namespace: zm_tomb_tank
	Checksum: 0xF421959
	Offset: 0x4CD8
	Size: 0x8E
	Parameters: 2
	Flags: Linked
*/
function mechz_tag_in_use_cleanup(mechz, tag_struct_index)
{
	mechz notify(#"kill_mechz_tag_in_use_cleanup");
	mechz util::waittill_any_timeout(30, "death", "kill_ft", "tank_flamethrower_attack_complete", "kill_mechz_tag_in_use_cleanup");
	self.a_mechz_tags[tag_struct_index].in_use = 0;
	self.a_mechz_tags[tag_struct_index].in_use_by = undefined;
}

/*
	Name: get_closest_mechz_tag_on_tank
	Namespace: zm_tomb_tank
	Checksum: 0xBBA25D5F
	Offset: 0x4D70
	Size: 0x256
	Parameters: 2
	Flags: Linked
*/
function get_closest_mechz_tag_on_tank(mechz, target_org)
{
	best_dist = -1;
	best_tag_index = undefined;
	for(i = 0; i < self.a_mechz_tags.size; i++)
	{
		if(self.a_mechz_tags[i].in_use && self.a_mechz_tags[i].in_use_by != mechz)
		{
			continue;
		}
		s_tag = self.a_mechz_tags[i];
		tag_org = self gettagorigin(s_tag.str_tag);
		dist = distancesquared(tag_org, target_org);
		if(dist < best_dist || best_dist < 0)
		{
			best_dist = dist;
			best_tag_index = i;
		}
	}
	if(isdefined(best_tag_index))
	{
		for(i = 0; i < self.a_mechz_tags.size; i++)
		{
			if(self.a_mechz_tags[i].in_use && self.a_mechz_tags[i].in_use_by == mechz)
			{
				self.a_mechz_tags[i].in_use = 0;
				self.a_mechz_tags[i].in_use_by = undefined;
			}
		}
		self.a_mechz_tags[best_tag_index].in_use = 1;
		self.a_mechz_tags[best_tag_index].in_use_by = mechz;
		self thread mechz_tag_in_use_cleanup(mechz, best_tag_index);
		return self.a_mechz_tags[best_tag_index].str_tag;
	}
	return undefined;
}

/*
	Name: tank_tag_is_valid
	Namespace: zm_tomb_tank
	Checksum: 0x4539BD2
	Offset: 0x4FD0
	Size: 0x1B2
	Parameters: 2
	Flags: Linked
*/
function tank_tag_is_valid(s_tag, disable_sides = 0)
{
	if(disable_sides)
	{
		if(s_tag.side == "right" || s_tag.side == "left")
		{
			return 0;
		}
	}
	if(self flag::get("tank_moving"))
	{
		if(s_tag.side == "front")
		{
			return 0;
		}
		if(!isdefined(self.n_next_node))
		{
			return 1;
		}
		if(!isdefined(self.n_next_node.script_string))
		{
			return 1;
		}
		if(issubstr(self.n_next_node.script_string, "disable_" + s_tag.side))
		{
			return 0;
		}
		return 1;
	}
	at_church = self.str_location_current == "village";
	at_bunker = self.str_location_current == "bunkers";
	if(at_church)
	{
		return !(isdefined(s_tag.disabled_at_church) && s_tag.disabled_at_church);
	}
	if(at_bunker)
	{
		return !(isdefined(s_tag.disabled_at_bunker) && s_tag.disabled_at_bunker);
	}
	return 1;
}

/*
	Name: zombies_watch_tank
	Namespace: zm_tomb_tank
	Checksum: 0xE6E8D67D
	Offset: 0x5190
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function zombies_watch_tank()
{
	a_tank_tags = tank_tag_array_setup();
	self.a_tank_tags = a_tank_tags;
	a_mechz_tags = mechz_tag_array_setup();
	self.a_mechz_tags = a_mechz_tags;
	while(true)
	{
		a_zombies = zombie_utility::get_round_enemy_array();
		foreach(e_zombie in a_zombies)
		{
			if(!isdefined(e_zombie.tank_state))
			{
				e_zombie thread tank_zombie_think();
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: start_chasing_tank
	Namespace: zm_tomb_tank
	Checksum: 0x84933793
	Offset: 0x52C0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function start_chasing_tank()
{
	self.tank_state = "tank_chase";
}

/*
	Name: stop_chasing_tank
	Namespace: zm_tomb_tank
	Checksum: 0xA3FFB19A
	Offset: 0x52E0
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function stop_chasing_tank()
{
	self.tank_state = "none";
	self.str_tank_tag = undefined;
	self.var_69140779 = undefined;
	self.tank_tag = undefined;
	self.b_on_tank = 0;
	self.tank_re_eval_time = undefined;
	self notify(#"change_goal");
	if(isdefined(self.zombie_move_speed_original))
	{
		self zombie_utility::set_zombie_run_cycle(self.zombie_move_speed_original);
	}
}

/*
	Name: choose_tag_and_chase
	Namespace: zm_tomb_tank
	Checksum: 0x9836CA53
	Offset: 0x5368
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function choose_tag_and_chase()
{
	s_tag = self get_closest_valid_tank_tag();
	if(isdefined(s_tag))
	{
		self.str_tank_tag = s_tag.str_tag;
		self.var_69140779 = s_tag.var_bd6a9142;
		self.tank_tag = s_tag;
		self.tank_state = "tag_chase";
	}
	else
	{
		wait(1);
	}
}

/*
	Name: choose_tag_and_jump_down
	Namespace: zm_tomb_tank
	Checksum: 0xCCC98FD7
	Offset: 0x53F8
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function choose_tag_and_jump_down()
{
	s_tag = self get_closest_valid_tank_tag(1);
	if(isdefined(s_tag))
	{
		self.str_tank_tag = s_tag.str_tag;
		self.var_69140779 = s_tag.var_bd6a9142;
		self.tank_tag = struct::get(s_tag.str_tag + "_down_start", "targetname");
		self.tank_state = "exit_tank";
		self zombie_utility::set_zombie_run_cycle("walk");
		/#
			assert(isdefined(self.tank_tag));
		#/
	}
	else
	{
		wait(1);
	}
}

/*
	Name: climb_tag
	Namespace: zm_tomb_tank
	Checksum: 0xA91D041D
	Offset: 0x54F8
	Size: 0x204
	Parameters: 0
	Flags: Linked
*/
function climb_tag()
{
	self endon(#"death");
	self.tank_state = "climbing";
	self.b_on_tank = 1;
	str_tag = self.str_tank_tag;
	str_anim_base = self.var_69140779;
	self linkto(level.vh_tank, str_tag);
	v_tag_origin = level.vh_tank gettagorigin(str_tag);
	v_tag_angles = level.vh_tank gettagangles(str_tag);
	str_anim_alias = "_jump_up" + str_anim_base;
	if(level.vh_tank flag::get("tank_moving") && str_tag == "window_left_rear_jmp_jnt")
	{
		str_anim_alias = "_jump_up_onto_markiv_rear";
	}
	if(self.missinglegs)
	{
		str_anim_alias = "_crawl" + str_anim_alias;
	}
	self.b_climbing_tank = 1;
	self animscripted("climb_up_tank_anim", v_tag_origin, v_tag_angles, "ai_zm_dlc5_zombie" + str_anim_alias);
	self zombie_shared::donotetracks("climb_up_tank_anim");
	self unlink();
	self.b_climbing_tank = 0;
	level.vh_tank tank_mark_tag_occupied(str_tag, self, 0);
	self set_zombie_on_tank();
}

/*
	Name: set_zombie_on_tank
	Namespace: zm_tomb_tank
	Checksum: 0x735FBCBC
	Offset: 0x5708
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function set_zombie_on_tank()
{
	self setgoalpos(self.origin);
	self.tank_state = "on_tank";
}

/*
	Name: jump_down_tag
	Namespace: zm_tomb_tank
	Checksum: 0x156F5F48
	Offset: 0x5748
	Size: 0x1DC
	Parameters: 0
	Flags: Linked
*/
function jump_down_tag()
{
	self endon(#"death");
	self.tank_state = "jumping_down";
	str_tag = self.str_tank_tag;
	str_anim_base = self.var_69140779;
	self linkto(level.vh_tank, str_tag);
	v_tag_origin = level.vh_tank gettagorigin(str_tag);
	v_tag_angles = level.vh_tank gettagangles(str_tag);
	self setgoalpos(v_tag_origin);
	str_anim_alias = "_jump_down" + str_anim_base;
	if(self.missinglegs)
	{
		str_anim_alias = "_crawl" + str_anim_alias;
	}
	self.b_climbing_tank = 1;
	self animscripted("climb_down_tank_anim", v_tag_origin, v_tag_angles, "ai_zm_dlc5_zombie" + str_anim_alias);
	self zombie_shared::donotetracks("climb_down_tank_anim");
	self unlink();
	self.b_climbing_tank = 0;
	level.vh_tank tank_mark_tag_occupied(str_tag, self, 0);
	self.pursuing_tank_tag = 0;
	stop_chasing_tank();
}

/*
	Name: watch_zombie_fall_off_tank
	Namespace: zm_tomb_tank
	Checksum: 0xB22019AB
	Offset: 0x5930
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function watch_zombie_fall_off_tank()
{
	self endon(#"death");
	while(true)
	{
		if(self.tank_state == "on_tank" || self.tank_state == "exit_tank")
		{
			if(!self entity_on_tank())
			{
				stop_chasing_tank();
			}
			wait(0.5);
		}
		else if(self.tank_state == "none")
		{
			if(self entity_on_tank())
			{
				self set_zombie_on_tank();
			}
			wait(5);
		}
		util::wait_network_frame();
	}
}

/*
	Name: in_range_2d
	Namespace: zm_tomb_tank
	Checksum: 0x193BAC97
	Offset: 0x5A10
	Size: 0x7E
	Parameters: 4
	Flags: Linked
*/
function in_range_2d(v1, v2, range, vert_allowance)
{
	if((abs(v1[2] - v2[2])) > vert_allowance)
	{
		return 0;
	}
	return distance2dsquared(v1, v2) < (range * range);
}

/*
	Name: tank_zombie_think
	Namespace: zm_tomb_tank
	Checksum: 0x3CD77FCD
	Offset: 0x5A98
	Size: 0x7F0
	Parameters: 0
	Flags: Linked
*/
function tank_zombie_think()
{
	self endon(#"death");
	self.tank_state = "none";
	self thread watch_zombie_fall_off_tank();
	think_time = 0.5;
	while(true)
	{
		a_players_on_tank = get_players_on_tank(1);
		tag_range = 32;
		if(level.vh_tank flag::get("tank_moving"))
		{
			tag_range = 64;
		}
		switch(self.tank_state)
		{
			case "none":
			{
				if(!isdefined(self.ai_state) || self.ai_state != "find_flesh")
				{
					break;
				}
				if(a_players_on_tank.size == 0)
				{
					break;
				}
				if(zombie_utility::is_player_valid(self.favoriteenemy))
				{
					if(isdefined(self.favoriteenemy.b_already_on_tank) && self.favoriteenemy.b_already_on_tank)
					{
						self start_chasing_tank();
					}
				}
				else
				{
					a_players = getplayers();
					a_eligible_players = [];
					foreach(e_player in a_players)
					{
						if(!(isdefined(e_player.ignoreme) && e_player.ignoreme) && zombie_utility::is_player_valid(e_player))
						{
							a_eligible_players[a_eligible_players.size] = e_player;
						}
					}
					if(a_eligible_players.size > 0)
					{
						if(a_players_on_tank.size == a_players.size)
						{
							self.favoriteenemy = array::random(a_eligible_players);
						}
						else
						{
							if(self.var_13ed8adf === level.time)
							{
								self.favoriteenemy = zm_tomb_utility::tomb_get_closest_player_using_paths(self.origin, a_eligible_players);
							}
							else
							{
								self.favoriteenemy = self.var_85a4d178;
							}
						}
					}
				}
				break;
			}
			case "tank_chase":
			{
				if(a_players_on_tank.size == 0)
				{
					self stop_chasing_tank();
					break;
				}
				dist_sq_to_tank = distancesquared(self.origin, level.vh_tank.origin);
				if(dist_sq_to_tank < 250000)
				{
					self choose_tag_and_chase();
				}
				if(!self.missinglegs && self.zombie_move_speed != "super_sprint" && (!(isdefined(self.is_traversing) && self.is_traversing)) && self.ai_state == "find_flesh")
				{
					if(level.vh_tank flag::get("tank_moving"))
					{
						self zombie_utility::set_zombie_run_cycle("super_sprint");
						self thread zombie_chasing_tank_turn_crawler();
					}
				}
				break;
			}
			case "tag_chase":
			{
				if(!isdefined(self.tank_re_eval_time))
				{
					self.tank_re_eval_time = 6;
				}
				else if(self.tank_re_eval_time <= 0)
				{
					if(self entity_on_tank())
					{
						self set_zombie_on_tank();
					}
					else
					{
						self stop_chasing_tank();
					}
					break;
				}
				self notify(#"stop_path_to_tag");
				if(a_players_on_tank.size == 0)
				{
					self stop_chasing_tank();
					break;
				}
				dist_sq_to_tank = distancesquared(self.origin, level.vh_tank.origin);
				if(dist_sq_to_tank > 1000000 || a_players_on_tank.size == 0)
				{
					start_chasing_tank();
					break;
				}
				v_tag = level.vh_tank gettagorigin(self.str_tank_tag);
				if(self.str_tank_tag == "window_right_front_jmp_jnt")
				{
					v_tag = getstartorigin(v_tag, level.vh_tank gettagangles(self.str_tank_tag), "ai_zm_dlc5_zombie_jump_up_markiv_front");
				}
				if(in_range_2d(v_tag, self.origin, tag_range, tag_range))
				{
					tag_claimed = level.vh_tank tank_mark_tag_occupied(self.str_tank_tag, self, 1);
					if(tag_claimed)
					{
						self thread climb_tag();
					}
				}
				else
				{
					self.tank_re_eval_time = self.tank_re_eval_time - think_time;
				}
				break;
			}
			case "climbing":
			{
				break;
			}
			case "on_tank":
			{
				if(a_players_on_tank.size == 0)
				{
					choose_tag_and_jump_down();
				}
				else if(!isdefined(self.favoriteenemy) || !zombie_utility::is_player_valid(self.favoriteenemy, 1))
				{
					self.favoriteenemy = array::random(a_players_on_tank);
				}
				break;
			}
			case "exit_tank":
			{
				self notify(#"stop_exit_tank");
				if(a_players_on_tank.size > 0)
				{
					self set_zombie_on_tank();
					break;
				}
				v_tag_pos = level.vh_tank tank_get_jump_down_offset(self.tank_tag);
				if(in_range_2d(v_tag_pos, self.origin, tag_range, tag_range))
				{
					tag_claimed = level.vh_tank tank_mark_tag_occupied(self.str_tank_tag, self, 1);
					if(tag_claimed)
					{
						self thread jump_down_tag();
					}
				}
				else
				{
					wait(1);
				}
				break;
			}
			case "jumping_down":
			{
				break;
			}
		}
		wait(think_time);
	}
}

/*
	Name: update_zombie_goal_pos
	Namespace: zm_tomb_tank
	Checksum: 0xAD068010
	Offset: 0x6290
	Size: 0x178
	Parameters: 2
	Flags: None
*/
function update_zombie_goal_pos(str_position, stop_notify)
{
	self notify(#"change_goal");
	self endon(#"death");
	self endon(#"goal");
	self endon(#"near_goal");
	self endon(#"change_goal");
	if(isdefined(stop_notify))
	{
		self endon(stop_notify);
	}
	s_script_origin = struct::get(str_position, "targetname");
	while(self.tank_state != "none")
	{
		if(isdefined(s_script_origin))
		{
			v_origin = level.vh_tank tank_get_jump_down_offset(s_script_origin);
			/#
				if(getdvarstring("") == "")
				{
					line(self.origin + vectorscale((0, 0, 1), 30), v_origin);
				}
			#/
		}
		else
		{
			v_origin = level.vh_tank gettagorigin(str_position);
		}
		self setgoalpos(v_origin);
		wait(0.05);
	}
}

/*
	Name: zombie_chasing_tank_turn_crawler
	Namespace: zm_tomb_tank
	Checksum: 0x1BB8D74F
	Offset: 0x6410
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function zombie_chasing_tank_turn_crawler()
{
	self notify(#"tank_watch_turn_crawler");
	self endon(#"tank_watch_turn_crawler");
	self endon(#"death");
	while(!self.missinglegs)
	{
		wait(0.05);
	}
	self zombie_utility::set_zombie_run_cycle(self.zombie_move_speed_original);
}

/*
	Name: tank_mark_tag_occupied
	Namespace: zm_tomb_tank
	Checksum: 0xA97DB503
	Offset: 0x6480
	Size: 0x14C
	Parameters: 3
	Flags: Linked
*/
function tank_mark_tag_occupied(str_tag, ai_occupier, set_occupied)
{
	current_occupier = self.tag_occupied[str_tag];
	min_dist_sq_to_tag = 1024;
	if(set_occupied)
	{
		if(!isdefined(current_occupier))
		{
			self.tag_occupied[str_tag] = ai_occupier;
			return true;
		}
		if(ai_occupier == current_occupier || !isalive(current_occupier))
		{
			dist_sq_to_tag = distance2dsquared(ai_occupier.origin, self gettagorigin(str_tag));
			if(dist_sq_to_tag < min_dist_sq_to_tag)
			{
				self.tag_occupied[str_tag] = ai_occupier;
				return true;
			}
		}
		return false;
	}
	if(!isdefined(current_occupier))
	{
		return true;
	}
	if(current_occupier != ai_occupier)
	{
		return false;
	}
	self.tag_occupied[str_tag] = undefined;
	return true;
}

/*
	Name: is_tag_crowded
	Namespace: zm_tomb_tank
	Checksum: 0x464D48D9
	Offset: 0x65D8
	Size: 0x1AA
	Parameters: 1
	Flags: Linked
*/
function is_tag_crowded(str_tag)
{
	v_tag = self gettagorigin(str_tag);
	a_zombies = getaiteamarray(level.zombie_team);
	n_nearby_zombies = 0;
	foreach(e_zombie in a_zombies)
	{
		dist_sq = distancesquared(v_tag, e_zombie.origin);
		if(dist_sq < 4096)
		{
			if(isdefined(e_zombie.tank_state))
			{
				if(e_zombie.tank_state != "tank_chase" && e_zombie.tank_state != "tag_chase" && e_zombie.tank_state != "none")
				{
					continue;
				}
			}
			n_nearby_zombies++;
			if(n_nearby_zombies >= 4)
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: get_closest_valid_tank_tag
	Namespace: zm_tomb_tank
	Checksum: 0x2A115E7B
	Offset: 0x6790
	Size: 0x1CC
	Parameters: 1
	Flags: Linked
*/
function get_closest_valid_tank_tag(jumping_down = 0)
{
	closest_dist_sq = 100000000;
	closest_tag = undefined;
	disable_sides = 0;
	if(jumping_down && level.vh_tank flag::get("tank_moving"))
	{
		disable_sides = 1;
	}
	foreach(s_tag in level.vh_tank.a_tank_tags)
	{
		if(level.vh_tank tank_tag_is_valid(s_tag, disable_sides))
		{
			v_tag = level.vh_tank gettagorigin(s_tag.str_tag);
			dist_sq = distancesquared(self.origin, v_tag);
			if(dist_sq < closest_dist_sq)
			{
				if(!level.vh_tank is_tag_crowded(s_tag.str_tag))
				{
					closest_tag = s_tag;
					closest_dist_sq = dist_sq;
				}
			}
		}
	}
	return closest_tag;
}

/*
	Name: zombieanimnotetrackthink
	Namespace: zm_tomb_tank
	Checksum: 0x7D639831
	Offset: 0x6968
	Size: 0x5A
	Parameters: 3
	Flags: None
*/
function zombieanimnotetrackthink(str_anim_notetrack_notify, chunk, node)
{
	self endon(#"death");
	while(true)
	{
		self waittill(str_anim_notetrack_notify, str_notetrack);
		if(str_notetrack == "end")
		{
			return;
		}
	}
}

/*
	Name: tank_run_flamethrowers
	Namespace: zm_tomb_tank
	Checksum: 0xE87FBD97
	Offset: 0x69D0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function tank_run_flamethrowers()
{
	self thread tank_flamethrower("tag_flash", 1);
	wait(0.25);
	self thread tank_flamethrower("tag_flash_gunner1", 2);
	wait(0.25);
	self thread tank_flamethrower("tag_flash_gunner2", 3);
}

/*
	Name: tank_flamethrower_get_targets
	Namespace: zm_tomb_tank
	Checksum: 0xC49077D4
	Offset: 0x6A50
	Size: 0x2CC
	Parameters: 2
	Flags: Linked
*/
function tank_flamethrower_get_targets(str_tag, n_flamethrower_id)
{
	a_zombies = getaiteamarray(level.zombie_team);
	a_targets = [];
	v_tag_pos = self gettagorigin(str_tag);
	v_tag_angles = self gettagangles(str_tag);
	v_tag_fwd = anglestoforward(v_tag_angles);
	v_kill_pos = v_tag_pos + (v_tag_fwd * 80);
	foreach(ai_zombie in a_zombies)
	{
		dist_sq = distance2dsquared(ai_zombie.origin, v_kill_pos);
		if(dist_sq > (80 * 80))
		{
			continue;
		}
		if(isdefined(ai_zombie.tank_state))
		{
			if(ai_zombie.tank_state == "climbing" || ai_zombie.tank_state == "jumping_down")
			{
				continue;
			}
		}
		v_to_zombie = vectornormalize(ai_zombie.origin - v_tag_pos);
		n_dot = vectordot(v_tag_fwd, ai_zombie.origin);
		if(n_dot < 0.95)
		{
			continue;
		}
		if(!isdefined(a_targets))
		{
			a_targets = [];
		}
		else if(!isarray(a_targets))
		{
			a_targets = array(a_targets);
		}
		a_targets[a_targets.size] = ai_zombie;
	}
	return a_targets;
}

/*
	Name: tank_flamethrower_cycle_targets
	Namespace: zm_tomb_tank
	Checksum: 0x6932A37D
	Offset: 0x6D28
	Size: 0x100
	Parameters: 2
	Flags: Linked
*/
function tank_flamethrower_cycle_targets(str_tag, n_flamethrower_id)
{
	self endon("flamethrower_stop_" + n_flamethrower_id);
	while(true)
	{
		a_targets = tank_flamethrower_get_targets(str_tag, n_flamethrower_id);
		foreach(ai in a_targets)
		{
			if(isalive(ai))
			{
				self setturrettargetent(ai);
				wait(1);
			}
		}
		wait(1);
	}
}

/*
	Name: tank_flamethrower
	Namespace: zm_tomb_tank
	Checksum: 0x50742B8D
	Offset: 0x6E30
	Size: 0x20E
	Parameters: 2
	Flags: Linked
*/
function tank_flamethrower(str_tag, n_flamethrower_id)
{
	zombieless_waits = 0;
	time_between_flames = randomfloatrange(3, 6);
	while(true)
	{
		wait(1);
		if(n_flamethrower_id == 1)
		{
			self setturrettargetvec(self.origin + (anglestoforward(self.angles) * 1000));
		}
		self flag::wait_till("tank_moving");
		a_targets = tank_flamethrower_get_targets(str_tag, n_flamethrower_id);
		if(a_targets.size > 0 || zombieless_waits > time_between_flames)
		{
			self clientfield::set("tank_flamethrower_fx", n_flamethrower_id);
			self thread flamethrower_damage_zombies(n_flamethrower_id, str_tag);
			if(n_flamethrower_id == 1)
			{
				self thread tank_flamethrower_cycle_targets(str_tag, n_flamethrower_id);
			}
			if(a_targets.size > 0)
			{
				wait(6);
			}
			else
			{
				wait(3);
			}
			self clientfield::set("tank_flamethrower_fx", 0);
			self notify("flamethrower_stop_" + n_flamethrower_id);
			zombieless_waits = 0;
			time_between_flames = randomfloatrange(3, 6);
		}
		else
		{
			zombieless_waits++;
		}
	}
}

/*
	Name: flamethrower_damage_zombies
	Namespace: zm_tomb_tank
	Checksum: 0xD3A6D7EF
	Offset: 0x7048
	Size: 0x1C0
	Parameters: 2
	Flags: Linked
*/
function flamethrower_damage_zombies(n_flamethrower_id, str_tag)
{
	self endon("flamethrower_stop_" + n_flamethrower_id);
	while(true)
	{
		a_targets = tank_flamethrower_get_targets(str_tag, n_flamethrower_id);
		foreach(ai_zombie in a_targets)
		{
			if(isalive(ai_zombie))
			{
				a_players = get_players_on_tank(1);
				if(a_players.size > 0)
				{
					level notify(#"vo_tank_flame_zombie", array::random(a_players));
				}
				if(str_tag == "tag_flash")
				{
					ai_zombie zm_tomb_utility::do_damage_network_safe(self, ai_zombie.health, self.var_8f5473ed, "MOD_BURNED");
					ai_zombie thread zm_tomb_utility::zombie_gib_guts();
				}
				else
				{
					ai_zombie thread zm_weap_staff_fire::flame_damage_fx(self.var_8f5473ed, self);
				}
				wait(0.05);
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: enemy_location_override
	Namespace: zm_tomb_tank
	Checksum: 0x8F92B7C0
	Offset: 0x7210
	Size: 0x690
	Parameters: 0
	Flags: Linked
*/
function enemy_location_override()
{
	enemy = self.favoriteenemy;
	location = enemy.origin;
	tank = level.vh_tank;
	if(isdefined(self.is_mechz) && self.is_mechz)
	{
		if(isdefined(self.var_afe67307))
		{
			return self.var_afe67307;
		}
		if(isdefined(self.jump_pos))
		{
			return self.jump_pos.origin;
		}
		return undefined;
	}
	if(isdefined(self.attackable))
	{
		return self.origin;
	}
	if(isdefined(self.reroute) && self.reroute)
	{
		if(isdefined(self.reroute_origin))
		{
			location = self.reroute_origin;
		}
	}
	if(isdefined(self.tank_state))
	{
		if(self.tank_state == "tank_chase")
		{
			self.goalradius = 128;
		}
		else
		{
			if(self.tank_state == "tag_chase")
			{
				self.goalradius = 16;
			}
			else
			{
				self.goalradius = 32;
			}
		}
		if(self.tank_state == "tank_chase" || (self.tank_state == "none" && (isdefined(enemy.b_already_on_tank) && enemy.b_already_on_tank)))
		{
			tank_front = tank function_1db98f69("window_right_front_jmp_jnt");
			tank_back = tank function_1db98f69("window_left_rear_jmp_jnt");
			if(tank flag::get("tank_moving"))
			{
				self.ignoreall = 1;
				if(!(isdefined(self.close_to_tank) && self.close_to_tank))
				{
					if(gettime() != tank.chase_pos_time)
					{
						tank.chase_pos_time = gettime();
						tank.chase_pos_index = 0;
						tank_forward = vectornormalize(anglestoforward(level.vh_tank.angles));
						tank_right = vectornormalize(anglestoright(level.vh_tank.angles));
						tank.chase_pos = [];
						tank.chase_pos[0] = level.vh_tank.origin + (vectorscale(tank_forward, -164));
						tank.chase_pos[1] = tank_front;
						tank.chase_pos[2] = tank_back;
					}
					location = tank.chase_pos[tank.chase_pos_index];
					tank.chase_pos_index++;
					if(tank.chase_pos_index >= 3)
					{
						tank.chase_pos_index = 0;
					}
					dist_sq = distancesquared(self.origin, location);
					if(dist_sq < 4096)
					{
						self.close_to_tank = 1;
					}
				}
			}
			else
			{
				self.close_to_tank = 0;
				tank_front = getstartorigin(tank_front, tank gettagangles("window_right_front_jmp_jnt"), "ai_zm_dlc5_zombie_jump_up_markiv_front");
				front_dist = distance2dsquared(enemy.origin, tank_front);
				back_dist = distance2dsquared(enemy.origin, tank_back);
				if(front_dist < back_dist)
				{
					location = tank_front;
				}
				else
				{
					location = tank_back;
				}
				self.ignoreall = 0;
			}
		}
		else
		{
			if(self.tank_state == "tag_chase")
			{
				if(self.str_tank_tag === "window_right_front_jmp_jnt")
				{
					location = getstartorigin(tank gettagorigin("window_right_front_jmp_jnt"), tank gettagangles("window_right_front_jmp_jnt"), "ai_zm_dlc5_zombie_jump_up_markiv_front");
				}
				else
				{
					location = level.vh_tank function_1db98f69(self.str_tank_tag);
				}
			}
			else if(self.tank_state == "exit_tank")
			{
				location = level.vh_tank tank_get_jump_down_offset(self.tank_tag);
			}
		}
	}
	if(self.var_13ed8adf === level.time && isdefined(location))
	{
		if(isplayer(enemy) && location == enemy.origin)
		{
			self zm_utility::approximate_path_dist(enemy);
		}
		else
		{
			pathdistance(self.origin, location, 1, self, level.pathdist_type);
		}
	}
	else if(isplayer(enemy) && isdefined(enemy.last_valid_position) && location === enemy.origin)
	{
		location = enemy.last_valid_position;
	}
	return location;
}

/*
	Name: closest_player_tank
	Namespace: zm_tomb_tank
	Checksum: 0x69B93968
	Offset: 0x78A8
	Size: 0xA8
	Parameters: 2
	Flags: None
*/
function closest_player_tank(origin, players)
{
	if(isdefined(level.vh_tank) && level.vh_tank.n_players_on > 0 || (!(isdefined(level.calc_closest_player_using_paths) && level.calc_closest_player_using_paths)))
	{
		player = arraygetclosest(origin, players);
	}
	else
	{
		player = zm_tomb_utility::tomb_get_closest_player_using_paths(origin, players);
	}
	if(isdefined(player))
	{
		return player;
	}
}

/*
	Name: zombie_on_tank_death_animscript_callback
	Namespace: zm_tomb_tank
	Checksum: 0x270AC629
	Offset: 0x7958
	Size: 0x114
	Parameters: 15
	Flags: Linked
*/
function zombie_on_tank_death_animscript_callback(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, boneindex, modelindex, surfacetype, surfacenormal)
{
	if(isdefined(self.exploding) && self.exploding)
	{
		self notify(#"killanimscript");
		self zombie_utility::reset_attack_spot();
		return true;
	}
	if(isdefined(self))
	{
		level zm_spawner::zombie_death_points(self.origin, smeansofdeath, shitloc, eattacker, self);
		self notify(#"killanimscript");
		self zombie_utility::reset_attack_spot();
		return true;
	}
	return false;
}

/*
	Name: tomb_get_path_length_to_tank
	Namespace: zm_tomb_tank
	Checksum: 0xD5F7B2E1
	Offset: 0x7A78
	Size: 0x148
	Parameters: 0
	Flags: Linked
*/
function tomb_get_path_length_to_tank()
{
	tank_front = level.vh_tank function_1db98f69("window_right_front_jmp_jnt");
	tank_back = level.vh_tank function_1db98f69("window_left_rear_jmp_jnt");
	path_length_1 = pathdistance(self.origin, tank_front, 1, self, level.pathdist_type);
	path_length_2 = pathdistance(self.origin, tank_back, 1, self, level.pathdist_type);
	if(!isdefined(path_length_1) && isdefined(path_length_2))
	{
		return path_length_2;
	}
	if(isdefined(path_length_1) && !isdefined(path_length_2))
	{
		return path_length_1;
	}
	if(!isdefined(path_length_1) && !isdefined(path_length_2))
	{
		return undefined;
	}
	if(path_length_1 < path_length_2)
	{
		return path_length_1;
	}
	return path_length_2;
}

