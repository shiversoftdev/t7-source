// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_debug;
#using scripts\cp\_dialog;
#using scripts\cp\_hacking;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_cairo_aquifer;
#using scripts\cp\cp_mi_cairo_aquifer_interior;
#using scripts\cp\cp_mi_cairo_aquifer_objectives;
#using scripts\cp\cp_mi_cairo_aquifer_sound;
#using scripts\cp\cp_mi_cairo_aquifer_utility;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai_shared;
#using scripts\shared\ai_sniper_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace cp_mi_cairo_aquifer_boss;

/*
	Name: start_boss
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x35061E4E
	Offset: 0xD28
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function start_boss()
{
	thread function_510d0407();
	level flag::wait_till("start_battle");
	thread init_ally_sniper_route("hendricks");
	thread init_sniper_boss();
}

/*
	Name: defend_obj_hack
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xDDD00107
	Offset: 0xD90
	Size: 0x10C
	Parameters: 1
	Flags: None
*/
function defend_obj_hack(ent)
{
	ent endon(#"death");
	while(!level flag::get("end_battle"))
	{
		offset = vectorscale((0, 0, 1), 60);
		icon_type = "defend";
		if(isdefined(ent._laststand) && ent._laststand)
		{
			offset = vectorscale((0, 0, 1), 30);
			icon_type = "return";
		}
		level.defend_obj = objectives::create_temp_icon(icon_type, "ally_defend", ent.origin + offset);
		wait(0.05);
	}
	level.defend_obj objectives::destroy_temp_icon();
}

/*
	Name: init_ally_sniper_route
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xDD93B2F0
	Offset: 0xEA8
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function init_ally_sniper_route(name)
{
	guy = level.hendricks;
	level.ally_target = guy;
	level.hendricks_moving = 0;
	guy.sniper_hits = 0;
	guy util::magic_bullet_shield();
	ai::createinterfaceforentity(guy);
	guy ai::set_behavior_attribute("sprint", 1);
	level.hendricks battlechatter::function_d9f49fba(1);
	thread function_567a5fa();
	thread function_7a57d63a();
}

/*
	Name: play_all_vo_in_array
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xA5EFC958
	Offset: 0xF88
	Size: 0x56
	Parameters: 1
	Flags: None
*/
function play_all_vo_in_array(arr)
{
	for(i = 0; i < arr.size; i++)
	{
		level.ally_target play_vo_from_array(arr, i);
	}
}

/*
	Name: play_vo_from_array
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xE1526964
	Offset: 0xFE8
	Size: 0x56
	Parameters: 2
	Flags: Linked
*/
function play_vo_from_array(array, num)
{
	self dialog::say(array[num]);
	num++;
	if(num >= array.size)
	{
		num = 0;
	}
	return num;
}

/*
	Name: function_f9d87307
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xC4556447
	Offset: 0x1048
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function function_f9d87307(name)
{
	var_52aea43b = struct::get(name, "targetname");
	points = [];
	start = var_52aea43b;
	while(isdefined(var_52aea43b))
	{
		points[points.size] = var_52aea43b.origin;
		if(!isdefined(var_52aea43b.target))
		{
			break;
		}
		var_52aea43b = struct::get(var_52aea43b.target, "targetname");
		if(isdefined(var_52aea43b) && var_52aea43b == start)
		{
			break;
		}
	}
	level.var_a86d0056 = points;
}

/*
	Name: function_7c54d87d
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x14D9780E
	Offset: 0x1140
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_7c54d87d()
{
	self ai::set_ignoreall(1);
	self ai::set_ignoreme(1);
	self thread ai_sniper::actor_lase_points_behavior(level.var_a86d0056);
}

/*
	Name: init_sniper_boss
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x2BA7F72E
	Offset: 0x11A0
	Size: 0x830
	Parameters: 0
	Flags: Linked
*/
function init_sniper_boss()
{
	level endon(#"start_finale");
	incoming_vo = [];
	incoming_vo[0] = "hend_we_ve_got_company_0";
	incoming_vo[1] = "hend_tangoes_on_the_floor_0";
	incoming_vo[2] = "hend_more_enemies_inbound_0";
	incoming_vo[3] = "hend_heads_up_more_tango_0";
	incoming_vo[4] = "hend_watch_those_doors_0";
	incoming_line = 0;
	level.turret = getent("veh_turret", "targetname");
	level.turret setmaxhealth(9999);
	level.turret vehicle::god_on();
	level.sniper_boss = spawner::simple_spawn_single("hyperion");
	level.sniper_boss util::magic_bullet_shield();
	level.sniper_boss cybercom::function_58c312f2();
	level.sniper_boss ai::set_ignoreall(1);
	level.sniper_boss disableaimassist();
	level.sniper_boss notsolid();
	level.sniper_boss.var_dfa3c2cb = 2;
	level.sniper_boss.baseaccuracy = 9999;
	level.sniper_boss.accuracy = 1;
	level.sniper_boss ai::disable_pain();
	level.var_6447d0d2 = 0;
	level.var_c987bca = 0;
	level.sniper_boss.var_dfa3c2cb = 0;
	level.sniper_boss.var_815502c4 = 1;
	level.sniper_boss.var_26c21ea3 = 10;
	level.sniper_boss.retargeting = 0;
	level.var_7d7334f = [];
	level flag::set("sniper_boss_spawned");
	thread function_6800ac1d();
	thread function_80b6b7eb();
	level.var_ed93c81c = [];
	level.var_ed93c81c[0] = array("sniper_spot_1_1");
	level.var_b8219f59 = array("wave_a", "wave_b", "wave_c");
	level.var_f1ee7b0e = 0;
	level.var_d56cb109 = -1;
	var_a4d5f340 = 7;
	level.var_8f1f476d = "wave_a";
	new_spot = 0;
	level.sniper_boss show();
	level.turret turret::enable_laser(1, 0);
	level.var_c987bca = 1;
	level.sniper_boss function_479d0795(level.sniper_boss.origin);
	wait(2);
	var_66ab2260 = getentarray("1st_barrel", "script_noteworthy");
	foreach(sm in var_66ab2260)
	{
		if(sm.targetname == "destructible")
		{
			shootme = sm;
			continue;
		}
	}
	if(isdefined(shootme))
	{
		level.sniper_boss.lase_ent notify(#"target_lase_transition");
		level.sniper_boss.lase_ent thread ai_sniper::target_lase_override(level.sniper_boss geteye(), shootme, 1, level.sniper_boss, 1, 0);
		thread function_60e39f29(shootme);
		shootme waittill(#"broken");
		level.sniper_boss.lase_ent notify(#"target_lase_override");
		level.sniper_boss.lase_ent.lase_override = undefined;
		exploder::exploder("bossceiling_smk_level1");
		exploder::exploder("lighting_turbine_boss_03");
		level.sniper_boss ai_sniper::actor_lase_stop();
		wait(0.05);
	}
	function_e9aa8887();
	thread function_6ea369f7();
	reset = 1;
	while(!level flag::get("end_battle"))
	{
		if(new_spot)
		{
			switch(level.var_f1ee7b0e)
			{
				case 1:
				{
					break;
				}
				case 2:
				{
					break;
				}
				case 3:
				{
					guys = getaiteamarray("axis");
					vol = getent("boss_end_vol", "targetname");
					foreach(guy in guys)
					{
						guy setgoalvolume(vol);
					}
					break;
				}
			}
			new_spot = 0;
		}
		event = level.sniper_boss util::waittill_any_timeout(var_a4d5f340, "sniper_suppressed", "sniper_disabled", "fire");
		if(event == "fire")
		{
			foreach(player in level.players)
			{
				player playsoundtoplayer("prj_crack", player);
			}
			reset = function_329f82a0();
		}
		else
		{
			reset = 0;
		}
	}
}

/*
	Name: function_60e39f29
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xE0C6E4C0
	Offset: 0x19D8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_60e39f29(shootme)
{
	level.sniper_boss waittill(#"fire");
	shootme kill(level.sniper_boss.origin, level.sniper_boss);
}

/*
	Name: function_479d0795
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x76660800
	Offset: 0x1A30
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function function_479d0795(var_81c506ec)
{
	if(!isdefined(self.lase_ent))
	{
		self.lase_ent = spawn("script_model", var_81c506ec);
		self.lase_ent setmodel("tag_origin");
		self.lase_ent.velocity = vectorscale((1, 0, 0), 100);
		self thread util::delete_on_death(self.lase_ent);
	}
	if(self.lase_ent.health <= 0)
	{
		self.lase_ent.health = 1;
	}
	self thread ai::shoot_at_target("shoot_until_target_dead", self.lase_ent);
	self.holdfire = 0;
	self.blindaim = 1;
}

/*
	Name: function_e9aa8887
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x6879D669
	Offset: 0x1B38
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_e9aa8887()
{
	level.var_d56cb109++;
	spots = function_f1889e69();
	if(level.var_d56cb109 >= spots.size)
	{
		level.var_d56cb109 = 0;
	}
	loc = getnode(spots[level.var_d56cb109], "targetname");
	level.var_1d4f0308 = loc;
	level.sniper_boss forceteleport(loc.origin, loc.angles);
	if(isdefined(loc.target))
	{
		function_f9d87307(loc.target);
	}
	level.sniper_boss thread function_7c54d87d();
}

/*
	Name: function_f1889e69
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xE0006FDF
	Offset: 0x1C40
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function function_f1889e69()
{
	return level.var_ed93c81c[level.var_f1ee7b0e];
}

/*
	Name: get_enemy_sniper_targets
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x2297AD1B
	Offset: 0x1C60
	Size: 0xEC
	Parameters: 0
	Flags: None
*/
function get_enemy_sniper_targets()
{
	targets = getaiteamarray("axis");
	new_targets = [];
	foreach(target in targets)
	{
		if(isai(target) && !isvehicle(target))
		{
			new_targets[new_targets.size] = target;
		}
	}
	return new_targets;
}

/*
	Name: choose_best_player_target
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x8A22405C
	Offset: 0x1D58
	Size: 0x146
	Parameters: 1
	Flags: None
*/
function choose_best_player_target(origin)
{
	targets = util::get_all_alive_players_s();
	targets = targets.a;
	see_targets = [];
	foreach(player in targets)
	{
		if(sighttracepassed(origin, player gettagorigin("tag_eye"), 1, level.turret))
		{
			see_targets[see_targets.size] = player;
		}
	}
	if(see_targets.size > 0)
	{
		target_num = randomintrange(0, see_targets.size);
		return see_targets[target_num];
	}
	return undefined;
}

/*
	Name: choose_sniper_location
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x41C56035
	Offset: 0x1EA8
	Size: 0xAC
	Parameters: 0
	Flags: None
*/
function choose_sniper_location()
{
	loc = randomint(level.sniper_origins.size);
	loc_ent = level.sniper_origins[loc];
	if(!isdefined(level.sniper_loc) || loc_ent == level.sniper_loc)
	{
		loc = loc + 1;
		if(loc >= level.sniper_origins.size)
		{
			loc = 0;
		}
	}
	set_up_sniper_location(loc);
}

/*
	Name: set_up_sniper_location
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x1A5F6F03
	Offset: 0x1F60
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function set_up_sniper_location(index)
{
	level notify(#"sniper_moved");
	level.sniper_target = level.ally_target;
	level.sniper_override_target = undefined;
	if(index >= 0 && index < level.sniper_origins.size)
	{
		level.sniper_loc = level.sniper_origins[index];
		level.sniper_hit_trigger = getent(level.sniper_loc.target, "targetname");
		level.turret.origin = level.sniper_loc.origin - vectorscale((0, 0, 1), 32);
		if(!isdefined(level.sniper_hit_trigger))
		{
			/#
				assertmsg("");
			#/
		}
	}
}

/*
	Name: sniper_timer
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x82DF51DE
	Offset: 0x2060
	Size: 0x2A
	Parameters: 1
	Flags: None
*/
function sniper_timer(duration)
{
	level endon(#"sniper_interrupted");
	wait(duration);
	level notify(#"sniper_fire_timeout");
}

/*
	Name: sniper_suppression_monitor
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xC25F76A
	Offset: 0x2098
	Size: 0x3A
	Parameters: 0
	Flags: None
*/
function sniper_suppression_monitor()
{
	level endon(#"sniper_interrupted");
	level endon(#"sniper_moved");
	level.sniper_hit_trigger waittill(#"damage");
	level notify(#"sniper_interrupted");
}

/*
	Name: function_6485b136
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x3EFFBB83
	Offset: 0x20E0
	Size: 0x10E
	Parameters: 2
	Flags: Linked
*/
function function_6485b136(player, delay = 0)
{
	if(!level.sniper_boss.retargeting && (!isdefined(level.sniper_boss.player_target) || level.sniper_boss.player_target != player))
	{
		var_833c5770 = level.sniper_boss.var_dfa3c2cb;
		level.sniper_boss.var_dfa3c2cb = delay;
		level.sniper_boss.lase_ent ai_sniper::target_lase_override(level.sniper_boss geteye(), player, 1, level.sniper_boss, 1, 0);
		level.sniper_boss.var_dfa3c2cb = var_833c5770;
		level.sniper_boss.player_target = undefined;
	}
}

/*
	Name: function_fe242426
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x3C3B2C59
	Offset: 0x21F8
	Size: 0x58
	Parameters: 0
	Flags: None
*/
function function_fe242426()
{
	while(true)
	{
		debug::debug_sphere(level.sniper_boss.lase_ent.origin, 20, vectorscale((1, 0, 1), 255), 10, 10);
		wait(0.1);
	}
}

/*
	Name: get_players_touching
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x1BA74D10
	Offset: 0x2258
	Size: 0xDA
	Parameters: 1
	Flags: None
*/
function get_players_touching(trigger)
{
	touchers = [];
	players = getplayers();
	foreach(player in players)
	{
		if(player istouching(trigger))
		{
			touchers[touchers.size] = player;
		}
	}
	return touchers;
}

/*
	Name: drawdebuglineoverride
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x329ED654
	Offset: 0x2340
	Size: 0x44
	Parameters: 4
	Flags: None
*/
function drawdebuglineoverride(frompoint, topoint, color, durationframes)
{
	as_debug::drawdebuglineinternal(frompoint, topoint, color, durationframes);
}

/*
	Name: array_create
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x12F6FCC4
	Offset: 0x2390
	Size: 0x46
	Parameters: 2
	Flags: None
*/
function array_create(e1, e2)
{
	a = [];
	a[0] = e1;
	a[1] = e2;
	return a;
}

/*
	Name: end_battle
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xDC5C8742
	Offset: 0x23E0
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function end_battle()
{
	exploder::exploder("lighting_turbine_boss_emergency");
	level.hendricks dialog::say("hend_that_should_do_it_0");
	thread function_c3af0181();
	level flag::set("boss_finale_ready");
	trig = getent("boss_finale_trigger", "targetname");
	trig triggerenable(1);
	trig.var_611ccff1 = util::init_interactive_gameobject(trig, &"cp_level_aquifer_capture_door", &"CP_MI_CAIRO_AQUIFER_BREACH", &function_479374a3);
	trig.var_611ccff1 gameobjects::set_use_time(0.35);
	level waittill(#"start_finale");
	trig.var_611ccff1 gameobjects::disable_object();
	trig triggerenable(0);
}

/*
	Name: function_479374a3
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xE2732C65
	Offset: 0x2540
	Size: 0x534
	Parameters: 0
	Flags: Linked
*/
function function_479374a3()
{
	util::set_streamer_hint(10);
	aquifer_obj::objectives_complete("cp_level_aquifer_boss");
	level notify(#"start_finale");
	level.sniper_boss show();
	level.sniper_boss util::stop_magic_bullet_shield();
	guys = getaiteamarray("axis");
	guys = array::exclude(guys, array(level.sniper_boss));
	if(isdefined(level.bzm_forceaicleanup))
	{
		[[level.bzm_forceaicleanup]]();
	}
	array::thread_all(guys, &aquifer_util::delete_me);
	struct = getent("hyperion_death_origin", "targetname");
	if(isdefined(level.bzm_aquiferdialogue6callback))
	{
		level thread [[level.bzm_aquiferdialogue6callback]]();
	}
	ent = getent("control_window_shatter_01", "targetname");
	if(isdefined(ent))
	{
		ent hide();
	}
	door = getent("boss_hideaway_door", "targetname");
	level thread namespace_71a63eac::function_e0e00797();
	a_ents = [];
	if(!isdefined(a_ents))
	{
		a_ents = [];
	}
	else if(!isarray(a_ents))
	{
		a_ents = array(a_ents);
	}
	a_ents[a_ents.size] = self.trigger.who;
	a_ents["hyperion"] = level.sniper_boss;
	scene::add_scene_func("cin_aqu_07_01_maretti_1st_dropit", &function_f3ee81ce, "skip_started");
	struct scene::play("cin_aqu_07_01_maretti_1st_dropit", a_ents);
	aquifer_util::toggle_door("boss_death_models", 1);
	thread function_2a39915e();
	level util::clientnotify("start_boss_tree");
	exploder::exploder("lgt_tree_glow_01");
	if(!level flag::get("sniper_boss_skipped"))
	{
		array::thread_all(level.activeplayers, &aquifer_util::function_89eaa1b3, 0.5);
	}
	if(isdefined(level.bzm_forceaicleanup))
	{
		[[level.bzm_forceaicleanup]]();
	}
	struct scene::play("cin_aqu_05_20_boss_3rd_death_sh010", level.sniper_boss);
	if(isdefined(level.bzm_forceaicleanup))
	{
		[[level.bzm_forceaicleanup]]();
	}
	level waittill(#"hash_94cdf46c");
	if(isdefined(level.bzm_forceaicleanup))
	{
		[[level.bzm_forceaicleanup]]();
	}
	thread util::screen_fade_out(0.75);
	exploder::stop_exploder("lgt_tree_glow_01");
	level waittill(#"hash_595107d2");
	if(isdefined(level.bzm_forceaicleanup))
	{
		[[level.bzm_forceaicleanup]]();
	}
	exploder::stop_exploder("lighting_turbine_boss_emergency");
	level clientfield::set("toggle_fog_banks", 0);
	thread cp_mi_cairo_aquifer_interior::handle_hideout();
	level.hendricks ai::set_behavior_attribute("cqb", 0);
	thread util::screen_fade_in(0.5);
	level flag::set("hyperion_start_tree_scene");
	aquifer_util::toggle_interior_doors(1);
	util::clear_streamer_hint();
	level.sniper_boss kill();
}

/*
	Name: function_f3ee81ce
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x51F8085E
	Offset: 0x2A80
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_f3ee81ce(a_ents)
{
	level flag::set("sniper_boss_skipped");
}

/*
	Name: function_2a39915e
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xAA422202
	Offset: 0x2AB8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_2a39915e()
{
	level waittill(#"hash_6f76bd0d");
	if(!level flag::get("sniper_boss_skipped"))
	{
		array::thread_all(level.activeplayers, &aquifer_util::function_89eaa1b3, 1);
	}
}

/*
	Name: function_510d0407
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xDAE8E5B1
	Offset: 0x2B20
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function function_510d0407()
{
	ents = getentarray("fire_maker", "script_noteworthy");
	level.var_510d0407 = ents;
	foreach(ent in ents)
	{
		ent thread function_d1b143ce();
	}
}

/*
	Name: function_d1b143ce
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x8E0965F0
	Offset: 0x2BF0
	Size: 0x204
	Parameters: 0
	Flags: Linked
*/
function function_d1b143ce()
{
	var_e42db353 = undefined;
	if(isdefined(self.target))
	{
		var_e42db353 = getent(self.target, "targetname");
		var_e42db353 triggerenable(0);
		self.target = undefined;
	}
	ent = spawnstruct();
	ent.origin = self.origin;
	ent.angles = self.angles;
	fx = "boss_fire";
	if(isdefined(self.script_parameters))
	{
		fx = self.script_parameters;
	}
	self waittill(#"broken");
	arrayremovevalue(level.var_510d0407, self);
	if(isdefined(var_e42db353))
	{
		var_e42db353 triggerenable(1);
		badplace_cylinder(var_e42db353.targetname, -1, ent.origin, 110, 64, "all");
	}
	if(fx == "boss_fire")
	{
		playfx(level._effect[fx], ent.origin, anglestoforward(ent.angles), anglestoup(ent.angles));
	}
	else
	{
		exploder::exploder(fx);
	}
}

/*
	Name: function_e146f6ef
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x58F76717
	Offset: 0x2E00
	Size: 0x22C
	Parameters: 0
	Flags: None
*/
function function_e146f6ef()
{
	best_dist = 0;
	shootme = undefined;
	eyepos = level.sniper_boss geteye();
	foreach(ent in level.var_510d0407)
	{
		if(isdefined(ent) && isalive(ent))
		{
			dist = function_ca9c8f2b(ent.origin);
			if(level.var_c987bca && (best_dist == 0 || dist < best_dist) && sighttracepassed(eyepos, ent.origin, 0, undefined))
			{
				best_dist = dist;
				shootme = ent;
			}
		}
	}
	if(isdefined(shootme))
	{
		level.sniper_boss.lase_ent notify(#"lase_points");
		level.sniper_boss.lase_ent notify(#"target_lase_override");
		level.sniper_boss.lase_ent notify(#"target_lase_transition");
		wait(0.1);
		if(isdefined(shootme))
		{
			level.sniper_boss.lase_ent ai_sniper::target_lase_override(level.sniper_boss geteye(), shootme, 1, level.sniper_boss, 1, 0);
			return true;
		}
	}
	return false;
}

/*
	Name: function_ca9c8f2b
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x3675E211
	Offset: 0x3038
	Size: 0xE6
	Parameters: 1
	Flags: Linked
*/
function function_ca9c8f2b(org)
{
	shortest = 0;
	foreach(guy in level.activeplayers)
	{
		dist = distancesquared(guy.origin, org);
		if(shortest == 0 || dist < shortest)
		{
			shortest = dist;
		}
	}
	return shortest;
}

/*
	Name: function_329f82a0
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xC06D7518
	Offset: 0x3128
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function function_329f82a0()
{
	if(isdefined(level.sniper_boss.lase_ent.lase_override))
	{
		target = level.sniper_boss.lase_ent.lase_override;
		fwd = anglestoforward(level.sniper_boss.angles);
		target_org = target.origin + vectorscale((0, 0, 1), 10);
		if(isplayer(target))
		{
			var_f769885c = (0, 0, 0);
			accuracy = target function_3375c23();
			accuracy = accuracy * 100;
			if(accuracy < randomfloat(100))
			{
				var_f769885c = (randomfloat(100) - 50, 0, 16);
			}
			target_org = (target geteye() + (vectorscale((0, 0, -1), 6))) + var_f769885c;
		}
		magicbullet(getweapon("sniper_hyperion"), level.sniper_boss geteye() + (fwd * 20), target_org, level.sniper_boss);
		return true;
	}
	return false;
}

/*
	Name: function_6ea369f7
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x9F2AD4A
	Offset: 0x3300
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_6ea369f7()
{
	trig = getent("sniper_alley", "targetname");
	while(!level flag::get("end_battle"))
	{
		trig waittill(#"trigger", who);
		if(isplayer(who) && isalive(who))
		{
			if(!isdefined(level.sniper_boss.player_target))
			{
				function_6485b136(who, 2);
			}
		}
	}
}

/*
	Name: function_6800ac1d
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x7E3AEE9
	Offset: 0x33E0
	Size: 0x2EC
	Parameters: 0
	Flags: Linked
*/
function function_6800ac1d()
{
	trig = getent("boss_hack1", "targetname");
	trig2 = getent("boss_hack2", "targetname");
	trig triggerenable(1);
	trig2 triggerenable(0);
	aquifer_obj::objectives_set("cp_level_aquifer_boss");
	trig.var_611ccff1 = trig hacking::init_hack_trigger(5, &"cp_level_aquifer_boss_gen1", &"CP_MI_CAIRO_AQUIFER_HOLD_OVERLOAD", &function_e9c4785f);
	thread function_a354fb63(1);
	level.var_fc9a3509 = 1;
	level waittill(#"hash_e9c4785f");
	thread savegame::checkpoint_save();
	trig.var_611ccff1 gameobjects::disable_object();
	trig2.var_611ccff1 = trig2 hacking::init_hack_trigger(5, &"cp_level_aquifer_boss_gen2", &"CP_MI_CAIRO_AQUIFER_HOLD_OVERLOAD", &function_e9c4785f);
	thread function_a354fb63(2);
	scene::init("cin_aqu_07_01_maretti_1st_dropit");
	level waittill(#"hash_e9c4785f");
	thread savegame::checkpoint_save();
	trig2.var_611ccff1 gameobjects::disable_object();
	wait(1.5);
	struct = getent("hyperion_death_origin", "targetname");
	struct thread scene::play("cin_aqu_05_20_boss_3rd_death_debris");
	wait(2.5);
	var_e42db353 = getent("boss_debris_hurter", "targetname");
	var_e42db353 triggerenable(1);
	aquifer_util::toggle_door("debris_clip", 0);
	wait(0.25);
	var_e42db353 triggerenable(0);
	end_battle();
}

/*
	Name: function_e9c4785f
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x668C82C7
	Offset: 0x36D8
	Size: 0x1A
	Parameters: 1
	Flags: Linked
*/
function function_e9c4785f(gameobj)
{
	level notify(#"hash_e9c4785f");
}

/*
	Name: function_dae6fcbf
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x5065867
	Offset: 0x3700
	Size: 0x142
	Parameters: 1
	Flags: Linked
*/
function function_dae6fcbf(name)
{
	level endon(#"hacking_complete");
	panels = getentarray(name, "targetname");
	delay = 3;
	while(true)
	{
		wait(delay);
		flickers = randomint(5) + 2;
		for(i = 0; i < flickers; i++)
		{
			array::run_all(panels, &hide);
			wait(randomfloatrange(0.05, 0.2));
			array::run_all(panels, &show);
			wait(randomfloatrange(0.05, 0.2));
		}
		delay = delay / 2;
	}
}

/*
	Name: function_a354fb63
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x24F15820
	Offset: 0x3850
	Size: 0x480
	Parameters: 1
	Flags: Linked
*/
function function_a354fb63(num)
{
	b_success = 0;
	trig = getent("boss_hack" + (isdefined(num) ? "" + num : ""), "targetname");
	while(!b_success)
	{
		level.hacking flag::wait_till("in_progress");
		thread function_41ca61ef(num);
		level waittill(#"hacking_complete", b_success);
		if(!b_success)
		{
			level notify(#"hash_90029dea");
		}
		surge = "surge0" + (isdefined(num) ? "" + num : "");
		if(b_success)
		{
			level notify(#"hash_6ca7aa5d");
			exploder::exploder(surge + "_stage05");
			earthquake(0.5, 2, trig.origin, 2000);
			level thread cp_mi_cairo_aquifer_sound::function_e76f158();
			wait(0.25);
			exploder::stop_exploder(surge + "_stage01");
			exploder::stop_exploder(surge + "_stage02");
			exploder::stop_exploder(surge + "_stage03");
			exploder::stop_exploder(surge + "_stage04");
			switch(num)
			{
				case 1:
				{
					exploder::exploder("lighting_sniper_boss_off_set01");
					panels = getentarray("reactor_lights_01", "targetname");
					array::run_all(panels, &hide);
					wait(1);
					function_339776e2("bossbarrel_right01");
					wait(1.5);
					function_339776e2("bossbarrel_right02");
					break;
				}
				case 2:
				{
					exploder::exploder("lighting_sniper_boss_off_set02");
					exploder::exploder("lighting_boss_fire_transition");
					clientfield::set("toggle_fog_banks", 1);
					clientfield::set("toggle_pbg_banks", 1);
					panels = getentarray("reactor_lights_02", "targetname");
					array::run_all(panels, &hide);
					wait(1.5);
					function_339776e2("bossbarrel_left03");
					wait(1);
					function_339776e2("bossbarrel_left02");
					break;
				}
			}
		}
		else
		{
			level thread cp_mi_cairo_aquifer_sound::function_1024da0a();
			exploder::stop_exploder(surge + "_stage01");
			exploder::stop_exploder(surge + "_stage02");
			exploder::stop_exploder(surge + "_stage03");
			exploder::stop_exploder(surge + "_stage04");
		}
		wait(0.1);
	}
}

/*
	Name: function_339776e2
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xEFBD91A2
	Offset: 0x3CD8
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_339776e2(name)
{
	ent = getent(name, "script_parameters");
	if(isdefined(ent))
	{
		ent kill();
	}
}

/*
	Name: function_41ca61ef
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xF4BC9FB2
	Offset: 0x3D40
	Size: 0x14E
	Parameters: 1
	Flags: Linked
*/
function function_41ca61ef(num)
{
	level endon(#"hash_90029dea");
	thread function_dae6fcbf("reactor_lights_0" + (isdefined(num) ? "" + num : ""));
	level thread cp_mi_cairo_aquifer_sound::function_ad15f6f5();
	surge = "surge0" + (isdefined(num) ? "" + num : "");
	exploder::exploder(surge + "_stage01");
	wait(1);
	exploder::exploder(surge + "_stage02");
	wait(1);
	exploder::exploder(surge + "_stage03");
	wait(2);
	exploder::exploder(surge + "_stage04");
	wait(3);
	level notify(#"hash_2891cea2");
}

/*
	Name: function_567a5fa
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x4E15C84C
	Offset: 0x3E98
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_567a5fa()
{
	level waittill(#"hash_cd553ae9");
	wait(0.25);
	level.hendricks dialog::say("hend_maretti_s_locked_him_0");
	wait(3);
	thread function_269260a3();
}

/*
	Name: function_7bde3a88
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x84B478EF
	Offset: 0x3EF8
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_7bde3a88()
{
	level endon(#"start_finale");
	level flag::wait_till("boss_taunt1");
	wait(3);
	level flag::set("boss_convo");
	level.hendricks dialog::say("hend_maretti_0");
	level.hendricks dialog::say("hend_maretti_listen_to_0", 1);
	level dialog::remote("mare_you_haven_t_learned_0", 0.2);
	level.hendricks dialog::say("hend_diaz_and_hall_are_de_0", 0.2);
	function_5e1c1c41();
}

/*
	Name: function_ede5a9c3
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x4F9666B
	Offset: 0x3FF8
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function function_ede5a9c3()
{
	level endon(#"start_finale");
	level flag::wait_till("boss_taunt2");
	level flag::set("boss_convo");
	level dialog::remote("mare_aren_t_you_worried_a_0");
	level.hendricks dialog::say("hend_maretti_you_know_me_0", 0.5);
	level dialog::remote("mare_you_d_better_get_you_1", 1);
	level.hendricks dialog::say("hend_please_i_give_you_0", 0.2);
	function_5e1c1c41();
	wait(5);
	level flag::set("boss_convo");
	level dialog::remote("mare_bullet_to_the_head_l_1", 2);
	function_5e1c1c41();
}

/*
	Name: function_80b6b7eb
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x85064DA4
	Offset: 0x4140
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_80b6b7eb()
{
	thread function_7bde3a88();
	thread function_ede5a9c3();
	level flag::wait_till_timeout(10, "boss_wave1");
	wait(5);
	level flag::set("boss_taunt1");
	level flag::wait_till("boss_wave1");
	level flag::wait_till_timeout(40, "boss_wave2");
	wait(5);
	level flag::set("boss_taunt2");
}

/*
	Name: function_5e1c1c41
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xEB0D0FCB
	Offset: 0x4210
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_5e1c1c41()
{
	wait(1);
	level flag::clear("boss_convo");
}

/*
	Name: boss_vo
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xB26722A1
	Offset: 0x4240
	Size: 0xC8
	Parameters: 2
	Flags: Linked
*/
function boss_vo(str_line, n_timeout = -1)
{
	if(n_timeout < 0)
	{
		level flag::wait_till_clear("boss_convo");
	}
	else
	{
		if(n_timeout > 0)
		{
			level flag::wait_till_clear_timeout(n_timeout, "boss_convo");
		}
		if(level flag::get("boss_convo"))
		{
			return false;
		}
	}
	self dialog::say(str_line);
	return true;
}

/*
	Name: function_4463326b
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xB064FA55
	Offset: 0x4310
	Size: 0xB6
	Parameters: 4
	Flags: Linked
*/
function function_4463326b(a_str_nags, var_aa750b18 = 10, n_timeout, str_endon_notify)
{
	level endon(str_endon_notify);
	n_waittime = var_aa750b18;
	n_line = 0;
	while(n_line < a_str_nags.size)
	{
		wait(n_waittime);
		level.hendricks boss_vo(a_str_nags[n_line], n_timeout);
		n_line++;
		n_waittime = n_waittime + 5;
	}
}

/*
	Name: function_269260a3
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xCAD9A3BD
	Offset: 0x43D0
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function function_269260a3()
{
	var_3d2aa310 = [];
	if(!isdefined(var_3d2aa310))
	{
		var_3d2aa310 = [];
	}
	else if(!isarray(var_3d2aa310))
	{
		var_3d2aa310 = array(var_3d2aa310);
	}
	var_3d2aa310[var_3d2aa310.size] = "hend_overload_that_genera_0";
	if(!isdefined(var_3d2aa310))
	{
		var_3d2aa310 = [];
	}
	else if(!isarray(var_3d2aa310))
	{
		var_3d2aa310 = array(var_3d2aa310);
	}
	var_3d2aa310[var_3d2aa310.size] = "hend_we_need_that_generat_0";
	if(!isdefined(var_3d2aa310))
	{
		var_3d2aa310 = [];
	}
	else if(!isarray(var_3d2aa310))
	{
		var_3d2aa310 = array(var_3d2aa310);
	}
	var_3d2aa310[var_3d2aa310.size] = "hend_i_ll_cover_you_over_0";
	thread function_4463326b(var_3d2aa310, undefined, -1, "gen1_done");
	level waittill(#"hash_6ca7aa5d");
	function_86fc21bb();
}

/*
	Name: function_86fc21bb
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xAD13C5BD
	Offset: 0x4558
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_86fc21bb()
{
	var_3d2aa310 = [];
	if(!isdefined(var_3d2aa310))
	{
		var_3d2aa310 = [];
	}
	else if(!isarray(var_3d2aa310))
	{
		var_3d2aa310 = array(var_3d2aa310);
	}
	var_3d2aa310[var_3d2aa310.size] = "hend_one_down_2";
	if(!isdefined(var_3d2aa310))
	{
		var_3d2aa310 = [];
	}
	else if(!isarray(var_3d2aa310))
	{
		var_3d2aa310 = array(var_3d2aa310);
	}
	var_3d2aa310[var_3d2aa310.size] = "hend_move_to_the_next_gen_0";
	thread function_4463326b(var_3d2aa310, undefined, -1, "gen1_done");
}

/*
	Name: function_c3af0181
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x62D99B0D
	Offset: 0x4660
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_c3af0181()
{
	var_3d2aa310 = [];
	if(!isdefined(var_3d2aa310))
	{
		var_3d2aa310 = [];
	}
	else if(!isarray(var_3d2aa310))
	{
		var_3d2aa310 = array(var_3d2aa310);
	}
	var_3d2aa310[var_3d2aa310.size] = "hend_get_up_there_and_sec_0";
	if(!isdefined(var_3d2aa310))
	{
		var_3d2aa310 = [];
	}
	else if(!isarray(var_3d2aa310))
	{
		var_3d2aa310 = array(var_3d2aa310);
	}
	var_3d2aa310[var_3d2aa310.size] = "hend_there_s_a_path_to_ma_0";
	thread function_4463326b(var_3d2aa310, undefined, -1, "start_finale");
}

/*
	Name: function_ae438739
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xD437B39D
	Offset: 0x4768
	Size: 0x148
	Parameters: 1
	Flags: Linked
*/
function function_ae438739(var_ecd4dcd7)
{
	level endon(#"start_finale");
	level endon(#"death");
	nags = [];
	nags[0] = "hend_keep_your_head_down_1";
	nags[1] = "hend_watch_it_1";
	nags[2] = "hend_watch_that_laser_1";
	while(level.var_6343f89f < nags.size)
	{
		self waittill(#"damage", amount, attacker, dir, point, mod);
		if(attacker == level.sniper_boss && gettime() > (level.var_9ef3831c + (var_ecd4dcd7 * 1000)))
		{
			var_f0c8f3cf = level.hendricks boss_vo(nags[level.var_6343f89f], 2);
			if(var_f0c8f3cf)
			{
				level.var_9ef3831c = gettime();
				level.var_6343f89f++;
			}
		}
	}
}

/*
	Name: function_7a57d63a
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0x802E4ABC
	Offset: 0x48B8
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function function_7a57d63a()
{
	level.var_9ef3831c = 0;
	level.var_6343f89f = 0;
	foreach(player in level.players)
	{
		player thread function_ae438739(5);
	}
}

/*
	Name: function_3375c23
	Namespace: cp_mi_cairo_aquifer_boss
	Checksum: 0xB34A7035
	Offset: 0x4970
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function function_3375c23()
{
	accuracy = 1;
	if(self issprinting())
	{
		accuracy = accuracy - 0.1;
	}
	if(self issliding())
	{
		accuracy = accuracy - 0.1;
	}
	player_vec = self getvelocity();
	speed = length(player_vec);
	if(speed > 100)
	{
		player_vec = self getnormalizedmovement();
		var_8aeaad8d = anglestoforward(level.sniper_boss.angles);
		dot = abs(vectordot(player_vec, var_8aeaad8d));
		accuracy = accuracy - ((1 - dot) * 0.1);
	}
	return accuracy;
}

