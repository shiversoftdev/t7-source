// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_sentinel_drone;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_stalingrad_util;
#using scripts\zm\zm_stalingrad_vo;

#namespace zm_ai_sentinel_drone;

/*
	Name: __init__sytem__
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x3CE44D05
	Offset: 0x808
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_sentinel_drone", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x1871FEE4
	Offset: 0x850
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.var_8a3cc09a = 1;
	level.var_fef7211a = 0;
	level.var_e476eac3 = 0;
	level.var_d6d4b6f9 = 2500;
	zm_score::register_score_event("death_sentinel", &function_c35ddec4);
	level flag::init("sentinel_round");
	level flag::init("sentinel_round_in_progress");
	level flag::init("sentinel_rez_in_progress");
	register_clientfields();
	level thread aat::register_immunity("zm_aat_blast_furnace", "sentinel_drone", 1, 1, 1);
	level thread aat::register_immunity("zm_aat_dead_wire", "sentinel_drone", 1, 1, 1);
	level thread aat::register_immunity("zm_aat_fire_works", "sentinel_drone", 1, 1, 1);
	level thread aat::register_immunity("zm_aat_thunder_wall", "sentinel_drone", 1, 1, 1);
	level thread aat::register_immunity("zm_aat_turned", "sentinel_drone", 1, 1, 1);
	function_1e5d8e69();
}

/*
	Name: __main__
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xD58066
	Offset: 0xA28
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	/#
		execdevgui("");
		thread function_5715a7cc();
	#/
	visionset_mgr::register_info("visionset", "zm_sentinel_round_visionset", 12000, 22, 31, 0, &visionset_mgr::ramp_in_out_thread, 0);
}

/*
	Name: register_clientfields
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xD0CCCF09
	Offset: 0xAA0
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("world", "sentinel_round_fog", 12000, 1, "int");
	clientfield::register("toplayer", "sentinel_round_fx", 12000, 1, "int");
	clientfield::register("vehicle", "necro_sentinel_fx", 12000, 1, "int");
	clientfield::register("vehicle", "sentinel_spawn_fx", 12000, 1, "int");
	clientfield::register("actor", "sentinel_zombie_spawn_fx", 12000, 1, "int");
}

/*
	Name: function_c35ddec4
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xDE989A3E
	Offset: 0xBA0
	Size: 0x64
	Parameters: 5
	Flags: Linked
*/
function function_c35ddec4(str_event, str_mod, str_hit_location, var_48d0b2fe, var_2f7fd5db)
{
	if(str_event === "death_sentinel")
	{
		scoreevents::processscoreevent("kill_sentinel", self, undefined, var_2f7fd5db);
		return 100;
	}
	return 0;
}

/*
	Name: function_2f7416e5
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xBE5500D1
	Offset: 0xC10
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_2f7416e5()
{
	level.var_fef7211a = 1;
	level.var_35078afd = 0;
	level.var_a657e360 = spawnstruct();
	level.var_a657e360.origin = (0, 0, 0);
	level.var_a657e360.angles = (0, 0, 0);
	level.var_a657e360.script_noteworthy = "riser_location";
	level.var_a657e360.script_string = "find_flesh";
	if(!isdefined(level.var_c7979e0a))
	{
		level.var_c7979e0a = &function_e38b964d;
	}
	level thread [[level.var_c7979e0a]]();
}

/*
	Name: function_1e5d8e69
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x95C3AEF5
	Offset: 0xCD8
	Size: 0x17A
	Parameters: 0
	Flags: Linked
*/
function function_1e5d8e69()
{
	level.var_fda4b3f3 = getspawnerarray("zombie_sentinel_spawner", "script_noteworthy");
	level.var_34fd66c3 = getspawnerarray("zombie_sentinel_zombie_spawner", "script_noteworthy");
	array::thread_all(level.var_34fd66c3, &spawner::add_spawn_function, &zm_spawner::zombie_spawn_init);
	if(level.var_fda4b3f3.size == 0)
	{
		/#
			assertmsg("");
		#/
		return;
	}
	foreach(var_5631b793 in level.var_fda4b3f3)
	{
		var_5631b793.is_enabled = 1;
		var_5631b793.script_forcespawn = 1;
		var_5631b793 spawner::add_spawn_function(&function_3b40bf32);
	}
}

/*
	Name: function_e38b964d
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xC031B788
	Offset: 0xE60
	Size: 0x228
	Parameters: 0
	Flags: Linked
*/
function function_e38b964d()
{
	if(level.players.size == 1)
	{
		level.var_a78effc7 = randomintrange(12, 16);
	}
	else
	{
		level.var_a78effc7 = randomintrange(9, 12);
	}
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;
	while(true)
	{
		level waittill(#"between_round_over");
		/#
			if(getdvarint("") > 0)
			{
				level.var_a78effc7 = level.round_number;
			}
		#/
		if(level.round_number == level.var_a78effc7)
		{
			level.sndmusicspecialround = 1;
			old_spawn_func = level.round_spawn_func;
			old_wait_func = level.round_wait_func;
			function_71f8e359();
			level.round_spawn_func = &function_7766fb04;
			level.round_wait_func = &function_989acb59;
			if(isdefined(level.var_a1ca5313))
			{
				level.var_a78effc7 = [[level.var_a1ca5313]]();
			}
			else
			{
				level.var_a78effc7 = level.var_a78effc7 + randomintrange(7, 10);
			}
			/#
				level.players[0] iprintln("" + level.var_a78effc7);
			#/
		}
		else if(level flag::get("sentinel_round"))
		{
			function_5cf4e163();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
		}
	}
}

/*
	Name: function_71f8e359
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xE457A466
	Offset: 0x1090
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_71f8e359()
{
	level flag::set("sentinel_round");
	level flag::set("special_round");
	level.var_35078afd++;
	level.var_e476eac3 = 1;
	level notify(#"hash_90d1f5ef");
	level thread zm_audio::sndmusicsystem_playstate("sentinel_roundstart");
	level.var_a61a9af4 = getdvarint("Sentinel_Move_Speed");
	setdvar("Sentinel_Move_Speed", 5);
}

/*
	Name: function_5cf4e163
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x4039BE20
	Offset: 0x1160
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function function_5cf4e163()
{
	level flag::clear("sentinel_round");
	level flag::clear("special_round");
	setdvar("Sentinel_Move_Speed", level.var_a61a9af4);
	level.var_e476eac3 = 0;
	level notify(#"hash_d32683ce");
}

/*
	Name: function_7766fb04
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xF325E9E3
	Offset: 0x11E8
	Size: 0x340
	Parameters: 0
	Flags: Linked
*/
function function_7766fb04()
{
	level endon(#"intermission");
	level endon(#"sentinel_round");
	level.var_6693a532 = getplayers();
	for(i = 0; i < level.var_6693a532.size; i++)
	{
		level.var_6693a532[i].hunted_by = 0;
	}
	level endon(#"restart_round");
	/#
		level endon(#"kill_round");
		if(getdvarint("") == 2 || getdvarint("") >= 4)
		{
			return;
		}
	#/
	if(level.intermission)
	{
		return;
	}
	array::thread_all(level.players, &function_6a866be7);
	function_e930da45();
	level.zombie_total = function_e9be6289();
	/#
		if(getdvarstring("") != "" && getdvarint("") > 0)
		{
			level.zombie_total = getdvarint("");
			setdvar("", 0);
		}
	#/
	wait(1);
	sentinel_round_fx(1);
	visionset_mgr::activate("visionset", "zm_sentinel_round_visionset", undefined, 1.5, 1.5, 2);
	playsoundatposition("vox_zmba_event_sentinelstart_0", (0, 0, 0));
	level thread zm_stalingrad_vo::function_3800b6e0();
	wait(3);
	level flag::set("sentinel_round_in_progress");
	level endon(#"last_ai_down");
	level thread function_53547f4d();
	while(true)
	{
		while(level.zombie_total > 0)
		{
			if(isdefined(level.bzm_worldpaused) && level.bzm_worldpaused)
			{
				util::wait_network_frame();
				continue;
			}
			var_c94972aa = level.var_35078afd > 1 && (level.zombie_total % 2) == 0;
			function_23a30f49(var_c94972aa);
			util::wait_network_frame();
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_fded8158
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x50F4C45A
	Offset: 0x1530
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function function_fded8158(spawner, s_spot)
{
	var_663b2442 = zombie_utility::spawn_zombie(level.var_fda4b3f3[0], "sentinel", s_spot);
	if(isdefined(var_663b2442))
	{
		var_663b2442.check_point_in_enabled_zone = &zm_utility::check_point_in_playable_area;
	}
	return var_663b2442;
}

/*
	Name: function_f9c9e7e0
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x34D06F9E
	Offset: 0x15B0
	Size: 0x2CC
	Parameters: 0
	Flags: Linked
*/
function function_f9c9e7e0()
{
	a_s_spawn_locs = [];
	s_spawn_loc = undefined;
	foreach(s_zone in level.zones)
	{
		if(s_zone.is_enabled && isdefined(s_zone.a_loc_types["sentinel_location"]) && s_zone.a_loc_types["sentinel_location"].size)
		{
			foreach(s_loc in s_zone.a_loc_types["sentinel_location"])
			{
				foreach(player in level.activeplayers)
				{
					n_dist_sq = distancesquared(player.origin, s_loc.origin);
					if(n_dist_sq > 65536 && n_dist_sq < 2250000)
					{
						if(!isdefined(a_s_spawn_locs))
						{
							a_s_spawn_locs = [];
						}
						else if(!isarray(a_s_spawn_locs))
						{
							a_s_spawn_locs = array(a_s_spawn_locs);
						}
						a_s_spawn_locs[a_s_spawn_locs.size] = s_loc;
						break;
					}
				}
			}
		}
	}
	s_spawn_loc = array::random(a_s_spawn_locs);
	if(!isdefined(s_spawn_loc))
	{
		s_spawn_loc = array::random(level.zm_loc_types["sentinel_location"]);
	}
	return s_spawn_loc;
}

/*
	Name: function_23a30f49
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xB32843F5
	Offset: 0x1888
	Size: 0x1D4
	Parameters: 1
	Flags: Linked
*/
function function_23a30f49(var_c94972aa = 0)
{
	while(!function_74ab7484())
	{
		wait(0.1);
	}
	s_spawn_loc = undefined;
	if(isdefined(level.var_2babfade))
	{
		s_spawn_loc = [[level.var_2babfade]]();
	}
	else
	{
		/#
			iprintlnbold("");
		#/
		if(level.zm_loc_types[""].size == 0)
		{
		}
		s_spawn_loc = function_f9c9e7e0();
	}
	if(!isdefined(s_spawn_loc))
	{
		wait(randomfloatrange(0.3333333, 0.6666667));
		return;
	}
	ai = function_fded8158(level.var_fda4b3f3[0]);
	if(isdefined(ai))
	{
		ai.nuke_damage_func = &function_306f9403;
		ai.instakill_func = &function_306f9403;
		ai.s_spawn_loc = s_spawn_loc;
		ai thread function_b27530eb(s_spawn_loc.origin);
		if(var_c94972aa)
		{
			ai.var_c94972aa = 1;
			ai.var_580a32ea = 6;
		}
		level.zombie_total--;
		function_20c64325();
	}
}

/*
	Name: function_b27530eb
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xE3EC954F
	Offset: 0x1A68
	Size: 0x24C
	Parameters: 1
	Flags: Linked
*/
function function_b27530eb(v_pos)
{
	self endon(#"death");
	self sentinel_drone::sentinel_intro();
	self vehicle::toggle_sounds(0);
	var_92968756 = v_pos + vectorscale((0, 0, 1), 30);
	self.origin = v_pos + vectorscale((0, 0, 1), 5000);
	self.angles = (0, randomintrange(0, 360), 0);
	e_origin = spawn("script_origin", self.origin);
	e_origin.angles = self.angles;
	self linkto(e_origin);
	e_origin moveto(var_92968756, 3);
	e_origin playsound("zmb_sentinel_intro_spawn");
	e_origin util::delay(3, undefined, &function_e6bf0279);
	self clientfield::set("sentinel_spawn_fx", 1);
	wait(3);
	self clientfield::set("sentinel_spawn_fx", 0);
	wait(1);
	self vehicle::toggle_sounds(1);
	self.origin = var_92968756;
	self unlink();
	e_origin delete();
	self flag::set("completed_spawning");
	wait(0.2);
	self sentinel_drone::sentinel_introcompleted();
}

/*
	Name: function_e6bf0279
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x5BC97D4B
	Offset: 0x1CC0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_e6bf0279()
{
	self playsound("zmb_sentinel_intro_land");
}

/*
	Name: function_306f9403
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xF8638743
	Offset: 0x1CF0
	Size: 0x20
	Parameters: 3
	Flags: Linked
*/
function function_306f9403(player, mod, hit_location)
{
	return true;
}

/*
	Name: function_d600cb9a
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x372FD239
	Offset: 0x1D18
	Size: 0x7AE
	Parameters: 0
	Flags: Linked
*/
function function_d600cb9a()
{
	self endon(#"hash_d600cb9a");
	self endon(#"death");
	self thread function_caadf4b1();
	self flag::wait_till("completed_spawning");
	var_4b9c276c = function_5b91ab3a();
	while(true)
	{
		level flag::wait_till_clear("sentinel_rez_in_progress");
		while(zombie_utility::get_current_zombie_count() >= var_4b9c276c)
		{
			wait(0.1);
		}
		if(zombie_utility::get_current_actor_count() >= level.zombie_actor_limit)
		{
			zombie_utility::clear_all_corpses();
			wait(0.1);
			continue;
		}
		v_spawn_pos = undefined;
		if(isdefined(self.var_98bec529) && self.var_98bec529)
		{
			query_result = positionquery_source_navigation(self.origin, 16, 768, 200, 40, 32);
			if(query_result.data.size)
			{
				a_s_locs = array::randomize(query_result.data);
				foreach(s_loc in a_s_locs)
				{
					var_caae2f83 = [[self.check_point_in_enabled_zone]](s_loc.origin, 1);
					if(var_caae2f83)
					{
						continue;
					}
					var_e31f585b = getclosestpointonnavmesh(s_loc.origin, 96, 32);
					if(isdefined(var_e31f585b))
					{
						var_c85c791d = 0;
						foreach(player in level.activeplayers)
						{
							n_dist_sq = distancesquared(self.origin, s_loc.origin);
							if(n_dist_sq < 250000)
							{
								var_c85c791d = 1;
								break;
							}
						}
						if(var_c85c791d)
						{
							continue;
						}
						s_spawn_loc = arraygetclosest(var_e31f585b, level.exterior_goals);
						if(isdefined(s_spawn_loc.script_string))
						{
							level.var_a657e360.script_string = s_spawn_loc.script_string;
						}
						a_ground_trace = groundtrace(var_e31f585b + vectorscale((0, 0, 1), 64), var_e31f585b + (vectorscale((0, 0, -1), 128)), 0, undefined);
						v_spawn_pos = a_ground_trace["position"];
						break;
					}
				}
			}
		}
		else
		{
			player = zombie_utility::get_closest_valid_player(self.origin);
			if(!isdefined(player))
			{
				wait(3);
				continue;
			}
			query_result = positionquery_source_navigation(self.origin, 500, 768, 200, 40, 32);
			if(query_result.data.size)
			{
				a_s_locs = array::randomize(query_result.data);
				foreach(s_loc in a_s_locs)
				{
					var_caae2f83 = [[self.check_point_in_enabled_zone]](s_loc.origin, 1);
					if(var_caae2f83)
					{
						var_c85c791d = 0;
						foreach(player in level.activeplayers)
						{
							n_dist_sq = distancesquared(self.origin, s_loc.origin);
							if(n_dist_sq < 250000)
							{
								var_c85c791d = 1;
								break;
							}
						}
						if(var_c85c791d)
						{
							continue;
						}
						level.var_a657e360.script_string = "find_flesh";
						v_spawn_pos = s_loc.origin;
						break;
					}
				}
			}
		}
		if(isdefined(v_spawn_pos))
		{
			if(level flag::get("sentinel_rez_in_progress"))
			{
				return;
			}
			level flag::set("sentinel_rez_in_progress");
			self.var_7e04bb3 = 1;
			self thread function_b7a02494();
			self sentinel_drone::sentinel_forcegoandstayinposition(1, v_spawn_pos + vectorscale((0, 0, 1), 106));
			self waittill(#"goal");
			level.var_a657e360.origin = v_spawn_pos + vectorscale((0, 0, 1), 8);
			level.var_a657e360.angles = self.angles;
			self clientfield::set("necro_sentinel_fx", 1);
			self function_1a7787ed();
			self clientfield::set("necro_sentinel_fx", 0);
			self sentinel_drone::sentinel_forcegoandstayinposition(0);
			wait(5);
			self.var_7e04bb3 = 0;
			level flag::clear("sentinel_rez_in_progress");
		}
		wait(1);
	}
}

/*
	Name: function_b7a02494
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xE1D3F632
	Offset: 0x24D0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_b7a02494()
{
	self endon(#"sentinel_rez_in_progress");
	self waittill(#"death");
	level flag::clear("sentinel_rez_in_progress");
}

/*
	Name: function_1a7787ed
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x3E612246
	Offset: 0x2518
	Size: 0x230
	Parameters: 0
	Flags: Linked
*/
function function_1a7787ed()
{
	self endon(#"death");
	self endon(#"hash_15969cec");
	var_4bb04d82 = get_zombie_spawn_delay();
	var_4b9c276c = function_5b91ab3a();
	n_num_to_spawn = randomintrange(6, 24);
	while(n_num_to_spawn)
	{
		if(zombie_utility::get_current_zombie_count() >= var_4b9c276c)
		{
			return;
		}
		if(zombie_utility::get_current_actor_count() >= level.zombie_actor_limit)
		{
			return;
		}
		if(flag::exists("world_is_paused") && level flag::get("world_is_paused"))
		{
			level flag::wait_till_clear("world_is_paused");
			continue;
		}
		if(!level flag::get("spawn_zombies"))
		{
			level flag::wait_till("spawn_zombies");
			continue;
		}
		ai_zombie = zombie_utility::spawn_zombie(level.var_34fd66c3[0], "sentinel_riser", level.var_a657e360);
		if(isdefined(ai_zombie))
		{
			n_num_to_spawn--;
			ai_zombie clientfield::set("sentinel_zombie_spawn_fx", 1);
			ai_zombie thread function_fdd9c3df(self);
			playsoundatposition("zmb_sentinel_res_spawn", level.var_a657e360.origin);
			wait(var_4bb04d82);
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_caadf4b1
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x107F9853
	Offset: 0x2750
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_caadf4b1()
{
	self waittill(#"death");
	self clientfield::set("necro_sentinel_fx", 0);
	a_ai_zombies = getaiteamarray(level.zombie_team);
	var_7f0cc3c7 = [];
	foreach(ai_zombie in a_ai_zombies)
	{
		if(ai_zombie.var_ec3fb9eb === self)
		{
			if(!isdefined(var_7f0cc3c7))
			{
				var_7f0cc3c7 = [];
			}
			else if(!isarray(var_7f0cc3c7))
			{
				var_7f0cc3c7 = array(var_7f0cc3c7);
			}
			var_7f0cc3c7[var_7f0cc3c7.size] = ai_zombie;
			ai_zombie.nuked = 1;
		}
	}
	if(var_7f0cc3c7.size)
	{
		zm_stalingrad_util::function_adf4d1d0(var_7f0cc3c7);
	}
}

/*
	Name: function_fdd9c3df
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x97B96242
	Offset: 0x28D0
	Size: 0x22C
	Parameters: 1
	Flags: Linked
*/
function function_fdd9c3df(var_4e5c415e)
{
	self endon(#"death");
	var_4e5c415e endon(#"death");
	self.b_ignore_cleanup = 1;
	self.exclude_cleanup_adding_to_total = 1;
	if(var_4e5c415e.var_580a32ea > 0)
	{
		var_4e5c415e.var_580a32ea--;
		self thread function_ea9730d8(var_4e5c415e);
	}
	else
	{
		self.no_damage_points = 1;
		self.deathpoints_already_given = 1;
	}
	self.var_ec3fb9eb = var_4e5c415e;
	self.var_bb98125f = 1;
	zm_elemental_zombie::function_1b1bb1b();
	self.health = int(level.zombie_health / 2);
	self waittill(#"completed_emerging_into_playable_area");
	self.no_powerups = 1;
	n_timeout = gettime() + 60000;
	while(!isdefined(self.enemy))
	{
		wait(0.1);
	}
	if(!self canpath(self.origin, self.enemy.origin))
	{
		var_4e5c415e notify(#"hash_15969cec");
		self kill();
		return;
	}
	n_dist_sq_max = randomfloatrange(1048448, 1048576);
	while(gettime() < n_timeout)
	{
		n_dist_sq = distancesquared(self.origin, var_4e5c415e.origin);
		if(n_dist_sq > 1048576)
		{
			break;
		}
		wait(1);
	}
	self kill();
}

/*
	Name: function_ea9730d8
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xB380B8C9
	Offset: 0x2B08
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function function_ea9730d8(var_4e5c415e)
{
	self endon(#"hash_107a4ece");
	var_4e5c415e endon(#"death");
	self function_cb2c6547();
	if(!isdefined(self.attacker) || !isplayer(self.attacker))
	{
		var_4e5c415e.var_580a32ea++;
	}
}

/*
	Name: function_cb2c6547
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xEEA05561
	Offset: 0x2B88
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function function_cb2c6547()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage", n_damage, e_attacker);
		if(isdefined(e_attacker) && isplayer(e_attacker))
		{
			self notify(#"hash_107a4ece");
		}
	}
}

/*
	Name: function_e9be6289
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x1414D126
	Offset: 0x2C00
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_e9be6289()
{
	switch(level.players.size)
	{
		case 1:
		{
			n_wave_count = 6;
			var_ebe16089 = 1;
			break;
		}
		case 2:
		{
			n_wave_count = 9;
			var_ebe16089 = 2;
			break;
		}
		case 3:
		{
			n_wave_count = 12;
			var_ebe16089 = 3;
			break;
		}
		default:
		{
			n_wave_count = 15;
			var_ebe16089 = 4;
		}
	}
	return n_wave_count + ((level.var_35078afd - 1) * var_ebe16089);
}

/*
	Name: function_5b91ab3a
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x53D26C87
	Offset: 0x2CC8
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function function_5b91ab3a()
{
	switch(level.players.size)
	{
		case 1:
		{
			n_count = 10;
			break;
		}
		case 2:
		{
			n_count = 10;
			break;
		}
		case 3:
		{
			n_count = 10;
			break;
		}
		default:
		{
			n_count = 12;
		}
	}
	return n_count;
}

/*
	Name: get_zombie_spawn_delay
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x7FDC9D96
	Offset: 0x2D50
	Size: 0x82
	Parameters: 0
	Flags: Linked
*/
function get_zombie_spawn_delay()
{
	switch(level.players.size)
	{
		case 1:
		{
			n_delay = 2.5;
			break;
		}
		case 2:
		{
			n_delay = 2;
			break;
		}
		case 3:
		{
			n_delay = 1.5;
			break;
		}
		default:
		{
			n_delay = 1;
		}
	}
	return n_delay;
}

/*
	Name: function_989acb59
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x6FB57405
	Offset: 0x2DE0
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function function_989acb59()
{
	level endon(#"restart_round");
	/#
		level endon(#"kill_round");
	#/
	if(level flag::get("sentinel_round"))
	{
		level flag::wait_till("sentinel_round_in_progress");
		level flag::wait_till_clear("sentinel_round_in_progress");
	}
	level.sndmusicspecialround = 0;
}

/*
	Name: function_41375d48
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xDB916B7F
	Offset: 0x2E70
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function function_41375d48()
{
	var_8b442d22 = getentarray("zombie_sentinel", "targetname");
	var_5eecf676 = var_8b442d22.size;
	foreach(var_663b2442 in var_8b442d22)
	{
		if(!isalive(var_663b2442))
		{
			var_5eecf676--;
		}
	}
	return var_5eecf676;
}

/*
	Name: function_e4aafac
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xB87871BF
	Offset: 0x2F50
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function function_e4aafac()
{
	switch(level.players.size)
	{
		case 1:
		{
			return 3;
			break;
		}
		case 2:
		{
			return 4;
			break;
		}
		case 3:
		{
			return 5;
			break;
		}
		case 4:
		{
			return 6;
			break;
		}
	}
}

/*
	Name: sentinel_round_fx
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x616C4CD
	Offset: 0x2FC0
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function sentinel_round_fx(n_val)
{
	if(n_val)
	{
		foreach(player in level.players)
		{
			player clientfield::set_to_player("sentinel_round_fx", n_val);
		}
	}
	level clientfield::set("sentinel_round_fog", n_val);
}

/*
	Name: function_74ab7484
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xCE20FA2C
	Offset: 0x3090
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_74ab7484()
{
	var_8d70c285 = function_41375d48();
	var_f285bab2 = function_e4aafac();
	if(var_8d70c285 >= var_f285bab2 || !level flag::get("spawn_zombies"))
	{
		return false;
	}
	return true;
}

/*
	Name: function_20c64325
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xB01BF704
	Offset: 0x3110
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function function_20c64325()
{
	switch(level.players.size)
	{
		case 1:
		{
			n_default_wait = 2.25;
			break;
		}
		case 2:
		{
			n_default_wait = 1.75;
			break;
		}
		case 3:
		{
			n_default_wait = 1.25;
			break;
		}
		default:
		{
			n_default_wait = 0.75;
			break;
		}
	}
	wait(n_default_wait);
}

/*
	Name: function_53547f4d
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x4D7C7907
	Offset: 0x31A0
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function function_53547f4d()
{
	level waittill(#"last_ai_down", var_663b2442, e_attacker);
	level thread zm_audio::sndmusicsystem_playstate("sentinel_roundend");
	if(isdefined(level.zm_override_ai_aftermath_powerup_drop))
	{
		[[level.zm_override_ai_aftermath_powerup_drop]](var_663b2442, level.var_6a6f912a);
	}
	else
	{
		var_4a50cb2a = level.var_6a6f912a;
		if(isdefined(var_4a50cb2a))
		{
			var_bae0d10b = level zm_powerups::specific_powerup_drop("full_ammo", var_4a50cb2a);
			if(isplayer(e_attacker))
			{
				v_destination = e_attacker.origin;
			}
			else
			{
				e_player = zm_utility::get_closest_player(var_4a50cb2a);
				v_destination = e_player.origin;
			}
			var_bae0d10b thread function_630f7ed5(v_destination);
		}
	}
	wait(2);
	level.sndmusicspecialround = 0;
	wait(6);
	level thread sentinel_round_fx(0);
	level flag::clear("sentinel_round_in_progress");
}

/*
	Name: function_630f7ed5
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x98BB82B1
	Offset: 0x3338
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_630f7ed5(v_origin)
{
	self endon(#"death");
	v_navmesh = getclosestpointonnavmesh(v_origin, 512, 16);
	if(isdefined(v_navmesh))
	{
		wait(2);
		self moveto(v_navmesh + vectorscale((0, 0, 1), 40), 2);
	}
}

/*
	Name: function_e930da45
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x8E6978F4
	Offset: 0x33C0
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_e930da45()
{
	level.var_d6d4b6f9 = 2500 + (level.round_number * 200);
	if(level.var_d6d4b6f9 < 4500)
	{
		level.var_d6d4b6f9 = 4500;
	}
	else if(level.var_d6d4b6f9 > 50000)
	{
		level.var_d6d4b6f9 = 50000;
	}
	level.var_d6d4b6f9 = int(level.var_d6d4b6f9 * (1 + (0.25 * (level.players.size - 1))));
}

/*
	Name: function_6a866be7
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x5A6477A1
	Offset: 0x3478
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_6a866be7()
{
	self playlocalsound("zmb_sentinel_round_start");
	wait(4.5);
	n_index = randomintrange(0, level.activeplayers.size);
	level.activeplayers[n_index] zm_audio::create_and_play_dialog("general", "sentinel_spawn");
}

/*
	Name: function_3b40bf32
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x999C0C26
	Offset: 0x3510
	Size: 0x330
	Parameters: 0
	Flags: Linked
*/
function function_3b40bf32()
{
	self.targetname = "zombie_sentinel";
	self.script_noteworthy = undefined;
	self.animname = "zombie_sentinel";
	self.allowdeath = 1;
	self.allowpain = 1;
	self.force_gib = 1;
	self.is_zombie = 1;
	self.gibbed = 0;
	self.head_gibbed = 0;
	self.default_goalheight = 40;
	self.ignore_inert = 1;
	self.no_eye_glow = 1;
	self.no_powerups = 1;
	self.lightning_chain_immune = 1;
	self.holdfire = 1;
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoresuppression = 1;
	self.suppressionthreshold = 1;
	self.nododgemove = 1;
	self.dontshootwhilemoving = 1;
	self.pathenemylookahead = 0;
	self.chatinitialized = 0;
	self.missinglegs = 0;
	self.team = level.zombie_team;
	self.sword_kill_power = 4;
	self.sentinel_electrifyzombie = &function_c72cf6e1;
	self.sentinel_getnearestzombie = &function_49b3a408;
	if(isdefined(level.var_97596556))
	{
		self.func_custom_cleanup_check = level.var_97596556;
	}
	self.b_widows_wine_no_powerup = 1;
	self.maxhealth = level.var_d6d4b6f9;
	if(isdefined(level.a_zombie_respawn_health[self.archetype]) && level.a_zombie_respawn_health[self.archetype].size > 0)
	{
		self.health = level.a_zombie_respawn_health[self.archetype][0];
		arrayremovevalue(level.a_zombie_respawn_health[self.archetype], level.a_zombie_respawn_health[self.archetype][0]);
	}
	else
	{
		self.health = self.maxhealth;
	}
	self thread function_d0769312();
	self thread function_6cb24476();
	self flag::init("completed_spawning");
	level thread zm_spawner::zombie_death_event(self);
	self thread zm_spawner::enemy_death_detection();
	if(self.var_c94972aa === 1)
	{
		self thread function_d600cb9a();
	}
	self zm_spawner::zombie_history(("zombie_sentinel_spawn_init -> Spawned = ") + self.origin);
	if(isdefined(level.achievement_monitor_func))
	{
		self thread [[level.achievement_monitor_func]]();
	}
}

/*
	Name: function_d0769312
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x95852347
	Offset: 0x3848
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function function_d0769312()
{
	self waittill(#"death", attacker);
	if(function_41375d48() == 0 && level.zombie_total <= 0)
	{
		if(!isdefined(level.zm_ai_round_over) || [[level.zm_ai_round_over]]())
		{
			level.var_6a6f912a = self.origin;
			level notify(#"last_ai_down", self, attacker);
		}
	}
	if(isplayer(attacker))
	{
		if(!(isdefined(self.deathpoints_already_given) && self.deathpoints_already_given))
		{
			attacker zm_score::player_add_points("death_sentinel");
		}
		if(isdefined(level.hero_power_update))
		{
			[[level.hero_power_update]](attacker, self);
		}
		attacker zm_audio::create_and_play_dialog("kill", "sentinel");
		attacker zm_stats::increment_client_stat("zsentinel_killed");
		attacker zm_stats::increment_player_stat("zsentinel_killed");
	}
	if(isdefined(attacker) && isai(attacker))
	{
		attacker notify(#"killed", self);
	}
	if(isdefined(self))
	{
		self stoploopsound();
		self thread function_acaa3ee4(self.origin);
	}
}

/*
	Name: function_acaa3ee4
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x45213080
	Offset: 0x3A20
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function function_acaa3ee4(origin)
{
}

/*
	Name: function_6cb24476
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x88A4A165
	Offset: 0x3A38
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_6cb24476()
{
	self endon(#"death");
	v_compact_mode = getent("sentinel_compact", "targetname");
	while(true)
	{
		if(self istouching(v_compact_mode))
		{
			self sentinel_drone::sentinel_setcompactmode(1);
			while(self istouching(v_compact_mode))
			{
				wait(0.5);
			}
			self sentinel_drone::sentinel_setcompactmode(0);
		}
		wait(0.2);
	}
}

/*
	Name: function_60f92893
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xF5FCC519
	Offset: 0x3B00
	Size: 0x60
	Parameters: 0
	Flags: None
*/
function function_60f92893()
{
	self zm_spawner::zombie_history("zombie_setup_attack_properties()");
	self ai::set_ignoreall(0);
	self.meleeattackdist = 64;
	self.disablearrivals = 1;
	self.disableexits = 1;
}

/*
	Name: function_586ac2c3
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x912AF253
	Offset: 0x3B68
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function function_586ac2c3()
{
	self waittill(#"death");
	self stopsounds();
}

/*
	Name: function_19d0b055
	Namespace: zm_ai_sentinel_drone
	Checksum: 0xCE4FBC20
	Offset: 0x3B98
	Size: 0x19C
	Parameters: 4
	Flags: Linked
*/
function function_19d0b055(n_to_spawn = 1, var_e41e673a, b_force_spawn = 0, var_b7959229 = undefined)
{
	n_spawned = 0;
	while(n_spawned < n_to_spawn)
	{
		if(!b_force_spawn && !function_74ab7484())
		{
			return n_spawned;
		}
		if(isdefined(var_b7959229))
		{
			s_spawn_loc = var_b7959229;
		}
		else
		{
			if(isdefined(level.var_809d579e))
			{
				s_spawn_loc = [[level.var_809d579e]](level.var_fda4b3f3);
			}
			else
			{
				s_spawn_loc = function_f9c9e7e0();
			}
		}
		if(!isdefined(s_spawn_loc))
		{
			return 0;
		}
		ai = function_fded8158(level.var_fda4b3f3[0]);
		if(isdefined(ai))
		{
			ai thread function_b27530eb(s_spawn_loc.origin);
			n_spawned++;
			if(isdefined(var_e41e673a))
			{
				ai thread [[var_e41e673a]]();
			}
		}
		function_20c64325();
	}
	return 1;
}

/*
	Name: function_9a59090e
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x250479B5
	Offset: 0x3D40
	Size: 0x50
	Parameters: 0
	Flags: None
*/
function function_9a59090e()
{
	self endon(#"death");
	while(true)
	{
		self playsound("zmb_hellhound_vocals_amb");
		wait(randomfloatrange(3, 6));
	}
}

/*
	Name: function_c72cf6e1
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x7E2C6C52
	Offset: 0x3D98
	Size: 0x2B2
	Parameters: 3
	Flags: Linked
*/
function function_c72cf6e1(origin, zombie, radius)
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"delete");
	if(isdefined(zombie) && (isdefined(zombie.zombie_think_done) && zombie.zombie_think_done))
	{
		if(zombie.is_elemental_zombie !== 1 && zombie.var_3531cf2b !== 1)
		{
			zombie zm_elemental_zombie::function_1b1bb1b();
		}
	}
	if(isdefined(radius) && radius > 0)
	{
		var_199ecc3a = zm_elemental_zombie::function_4aeed0a5("sparky");
		if(!isdefined(level.var_1ae26ca5) || var_199ecc3a < level.var_1ae26ca5)
		{
			var_82aacc64 = zm_elemental_zombie::function_d41418b8();
			var_82aacc64 = arraysortclosest(var_82aacc64, origin);
			radius_sq = radius * radius;
			foreach(ai_zombie in var_82aacc64)
			{
				if(!isdefined(ai_zombie))
				{
					continue;
				}
				if(!isalive(ai_zombie))
				{
					continue;
				}
				if(!(isdefined(ai_zombie.zombie_think_done) && ai_zombie.zombie_think_done))
				{
					continue;
				}
				if(!(ai_zombie.is_elemental_zombie !== 1 && ai_zombie.var_3531cf2b !== 1))
				{
					continue;
				}
				dist_sq = distance2dsquared(origin, ai_zombie.origin);
				if(dist_sq <= radius_sq)
				{
					ai_zombie zm_elemental_zombie::function_1b1bb1b();
					continue;
				}
				break;
			}
		}
	}
}

/*
	Name: function_49b3a408
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x45BF4ABA
	Offset: 0x4058
	Size: 0x2C0
	Parameters: 4
	Flags: Linked
*/
function function_49b3a408(origin, b_ignore_elemental = 1, b_outside_playable_area = 1, radius = 2000)
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"delete");
	if(isdefined(radius) && radius > 0)
	{
		var_199ecc3a = zm_elemental_zombie::function_4aeed0a5("sparky");
		if(!isdefined(level.var_1ae26ca5) || var_199ecc3a < level.var_1ae26ca5)
		{
			var_82aacc64 = zm_elemental_zombie::function_d41418b8();
			var_82aacc64 = arraysortclosest(var_82aacc64, origin);
			radius_sq = radius * radius;
			foreach(ai_zombie in var_82aacc64)
			{
				if(!isdefined(ai_zombie))
				{
					continue;
				}
				if(!isalive(ai_zombie))
				{
					continue;
				}
				if(!(isdefined(ai_zombie.zombie_think_done) && ai_zombie.zombie_think_done))
				{
					continue;
				}
				if(isdefined(ai_zombie.var_3531cf2b) && ai_zombie.var_3531cf2b)
				{
					continue;
				}
				if(b_ignore_elemental && (isdefined(ai_zombie.is_elemental_zombie) && ai_zombie.is_elemental_zombie))
				{
					continue;
				}
				if(isdefined(ai_zombie.hunted_by_sentinel) && ai_zombie.hunted_by_sentinel)
				{
					continue;
				}
				dist_sq = distance2dsquared(origin, ai_zombie.origin);
				if(dist_sq <= radius_sq)
				{
					return ai_zombie;
				}
			}
		}
	}
	return undefined;
}

/*
	Name: function_5715a7cc
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x11362BB3
	Offset: 0x4320
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_5715a7cc()
{
	/#
		level flagsys::wait_till("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		zm_devgui::add_custom_devgui_callback(&function_c630bba3);
	#/
}

/*
	Name: function_c630bba3
	Namespace: zm_ai_sentinel_drone
	Checksum: 0x1EEE3A65
	Offset: 0x4460
	Size: 0x5E6
	Parameters: 1
	Flags: Linked
*/
function function_c630bba3(cmd)
{
	/#
		if(level.var_fda4b3f3.size == 0)
		{
			return;
		}
		switch(cmd)
		{
			case "":
			{
				player = level.players[0];
				v_direction = player getplayerangles();
				v_direction = anglestoforward(v_direction) * 8000;
				v_eye = player geteye();
				trace = bullettrace(v_eye, v_eye + v_direction, 0, undefined);
				var_feba5c63 = positionquery_source_navigation(trace[""], 128, 256, 128, 20);
				s_spot = spawnstruct();
				if(isdefined(var_feba5c63) && var_feba5c63.data.size > 0)
				{
					s_spot.origin = var_feba5c63.data[0].origin;
				}
				else
				{
					s_spot.origin = player.origin;
				}
				s_spot.angles = (0, player.angles[1] - 180, 0);
				function_19d0b055(1, undefined, 1, s_spot);
				return true;
			}
			case "":
			{
				zm_devgui::zombie_devgui_goto_round(level.var_a78effc7);
				return true;
			}
			case "":
			{
				curvalue = getdvarint("", 0);
				if(curvalue == 0)
				{
					curvalue = 1;
				}
				else
				{
					curvalue = 0;
				}
				setdvar("", curvalue);
				return true;
			}
			case "":
			{
				curvalue = getdvarint("", 0);
				if(curvalue == 0)
				{
					curvalue = 1;
				}
				else
				{
					curvalue = 0;
				}
				setdvar("", curvalue);
				return true;
			}
			case "":
			{
				curvalue = getdvarint("", 0);
				if(curvalue == 0)
				{
					curvalue = 1;
				}
				else
				{
					curvalue = 0;
				}
				setdvar("", curvalue);
				return true;
			}
			case "":
			{
				curvalue = getdvarint("", 0);
				if(curvalue == 0)
				{
					curvalue = 1;
				}
				else
				{
					curvalue = 0;
				}
				setdvar("", curvalue);
				return true;
			}
			case "":
			{
				curvalue = getdvarint("", 0);
				if(curvalue == 0)
				{
					curvalue = 1;
				}
				else
				{
					curvalue = 0;
				}
				setdvar("", curvalue);
				return true;
			}
			case "":
			{
				curvalue = getdvarint("", 0);
				if(curvalue == 0)
				{
					curvalue = 1;
				}
				else
				{
					curvalue = 0;
				}
				setdvar("", curvalue);
				return true;
			}
			case "":
			{
				curvalue = getdvarint("", 0);
				if(curvalue == 0)
				{
					curvalue = 1;
				}
				else
				{
					curvalue = 0;
				}
				setdvar("", curvalue);
				return true;
			}
			case "":
			{
				curvalue = getdvarint("", 0);
				if(curvalue == 0)
				{
					curvalue = 1;
				}
				else
				{
					curvalue = 0;
				}
				setdvar("", curvalue);
				return true;
			}
			case "":
			{
				curvalue = getdvarint("", 0);
				if(curvalue == 0)
				{
					curvalue = 1;
				}
				else
				{
					curvalue = 0;
				}
				setdvar("", curvalue);
				return true;
			}
			default:
			{
				return false;
			}
		}
	#/
}

