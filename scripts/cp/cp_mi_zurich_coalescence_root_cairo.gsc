// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_zurich_coalescence_root_cinematics;
#using scripts\cp\cp_mi_zurich_coalescence_sound;
#using scripts\cp\cp_mi_zurich_coalescence_util;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_raps;

#namespace root_cairo;

/*
	Name: main
	Namespace: root_cairo
	Checksum: 0xCCBC83BB
	Offset: 0xC40
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	init_clientfields();
	level flag::init("vtol_dropped_wall");
	level._effect["lightning_strike"] = "explosions/fx_exp_lightning_fold_infection";
	level._effect["explosion_medium"] = "explosions/fx_exp_debris_metal_md";
	level._effect["explosion_large"] = "explosions/fx_exp_sky_bridge_lotus";
	level thread function_54b0174d();
	scene::add_scene_func("p7_fxanim_cp_zurich_wall_drop_bundle", &zurich_util::function_9f90bc0f, "done", "cairo_root_completed");
	scene::add_scene_func("p7_fxanim_cp_zurich_checkpoint_wall_01_bundle", &zurich_util::function_9f90bc0f, "done", "cairo_root_completed");
}

/*
	Name: init_clientfields
	Namespace: root_cairo
	Checksum: 0xD1BD5463
	Offset: 0xD58
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	clientfield::register("scriptmover", "vtol_spawn_fx", 1, 1, "counter");
	clientfield::register("world", "cairo_client_ents", 1, 1, "int");
}

/*
	Name: skipto_main
	Namespace: root_cairo
	Checksum: 0x6B7E9AA0
	Offset: 0xDC8
	Size: 0x2B4
	Parameters: 2
	Flags: Linked
*/
function skipto_main(str_objective, b_starting)
{
	load::function_73adcefc();
	if(b_starting)
	{
		level util::screen_fade_out(0);
		level flag::set("flag_diaz_first_path_complete_vo_done");
	}
	videostart("cp_zurich_env_corvusmonitor", 1);
	level scene::init("cin_zur_14_01_cairo_root_1st_fall");
	level thread namespace_67110270::function_973b77f9();
	exploder::exploder("weather_lightning_exp");
	var_4ccf970 = zurich_util::function_a00fa665(str_objective);
	zurich_util::enable_surreal_ai_fx(1, 0.5);
	spawner::add_spawn_function_group("raven_ambush_ai", "script_parameters", &zurich_util::function_aceff870);
	spawner::add_spawn_function_group("raven_spawn_teleport", "script_parameters", &zurich_util::function_3287bea1);
	level thread namespace_67110270::function_1935b4aa();
	level thread function_42dddb91(str_objective);
	level clientfield::set("cairo_client_ents", 1);
	level thread function_4cca3b70();
	level thread function_6559d2b2();
	load::function_a2995f22();
	skipto::teleport_players(str_objective, 0);
	level thread zurich_util::function_a03f30f2(str_objective, "root_cairo_vortex", "root_cairo_regroup");
	level thread zurich_util::function_dd842585(str_objective, "root_cairo_vortex", "t_root_cairo_vortex");
	level thread function_962eebf2(str_objective);
	level waittill(str_objective + "enter_vortex");
	level thread function_95b88092("root_cairo_vortex", 0);
}

/*
	Name: function_95b88092
	Namespace: root_cairo
	Checksum: 0x3D241068
	Offset: 0x1088
	Size: 0x254
	Parameters: 2
	Flags: Linked
*/
function function_95b88092(str_objective, b_starting)
{
	if(isdefined(b_starting) && b_starting)
	{
		load::function_73adcefc();
		load::function_a2995f22();
		skipto::teleport_players(str_objective, 0);
		zurich_util::enable_surreal_ai_fx(1, 0.5);
		level thread zurich_util::function_c90e23b6(str_objective);
	}
	if(isdefined(level.bzm_zurichdialogue13callback))
	{
		level thread [[level.bzm_zurichdialogue13callback]]();
	}
	level thread scene::init("cairo_fxanim_heart_ceiling", "targetname");
	exploder::exploder("heartLightsCairo");
	level thread namespace_67110270::function_973b77f9();
	level thread function_2dbeaba5();
	level thread function_c3dca267();
	level util::clientnotify("stCAMU");
	if(level.players === 1)
	{
		savegame::checkpoint_save();
	}
	var_8fb0849a = zurich_util::function_a1851f86(str_objective);
	var_8fb0849a waittill(#"brn");
	level thread root_cinematics::play_scene(str_objective, var_8fb0849a.var_90971f20.e_player);
	if(isdefined(level.bzm_forceaicleanup))
	{
		[[level.bzm_forceaicleanup]]();
	}
	level notify(#"hash_ef6331cc");
	videostop("cp_zurich_env_corvusmonitor");
	exploder::stop_exploder("weather_lightning_exp");
	level util::clientnotify("stp_mus");
}

/*
	Name: skipto_done
	Namespace: root_cairo
	Checksum: 0xF2360735
	Offset: 0x12E8
	Size: 0x84
	Parameters: 4
	Flags: Linked
*/
function skipto_done(str_objective, b_starting, b_direct, player)
{
	level notify(#"hash_83eebac0");
	level thread zurich_util::function_4a00a473("root_cairo");
	exploder::stop_exploder("weather_lightning_exp");
	level clientfield::set("cairo_client_ents", 0);
}

/*
	Name: function_7cdb6ab4
	Namespace: root_cairo
	Checksum: 0xAB5E755B
	Offset: 0x1378
	Size: 0x38C
	Parameters: 0
	Flags: Linked
*/
function function_7cdb6ab4()
{
	level endon(#"hash_1f265efe");
	level flag::wait_till("flag_cairo_root_monologue_01");
	level dialog::player_say("plyr_listen_only_to_the_s_0", 3);
	level dialog::player_say("plyr_let_your_mind_relax_0", 3);
	level dialog::player_say("plyr_let_your_thoughts_dr_0", 3);
	level dialog::player_say("plyr_let_the_bad_memories_0", 3);
	level dialog::player_say("plyr_let_peace_be_upon_yo_0", 3);
	level flag::wait_till("flag_cairo_root_monologue_02");
	level dialog::player_say("plyr_surrender_yourself_t_0", 3);
	level dialog::player_say("plyr_let_them_wash_over_y_0", 3);
	level dialog::player_say("plyr_imagine_somewhere_ca_0", 3);
	level dialog::player_say("plyr_imagine_somewhere_sa_0", 3);
	level dialog::player_say("plyr_imagine_yourself_0", 3);
	level flag::wait_till("flag_cairo_root_monologue_03");
	level dialog::player_say("plyr_you_are_standing_in_0", 3);
	level dialog::player_say("plyr_the_trees_around_you_0", 3);
	level dialog::player_say("plyr_pure_white_snowflake_0", 3);
	level dialog::player_say("plyr_you_can_feel_them_me_0", 3);
	level dialog::player_say("plyr_you_are_not_cold_0", 3);
	level dialog::player_say("plyr_it_cannot_overcome_t_0", 3);
	level flag::wait_till("flag_cairo_root_monologue_04");
	level dialog::player_say("plyr_can_you_hear_it_0", 3);
	level dialog::player_say("plyr_you_only_have_to_lis_0", 3);
	level dialog::player_say("plyr_do_you_hear_it_slowi_0", 3);
	level dialog::player_say("plyr_you_are_slowing_it_0", 3);
	level dialog::player_say("plyr_you_are_in_control_0", 3);
	level dialog::player_say("plyr_calm_0", 3);
	level dialog::player_say("plyr_at_peace_0", 3);
	level flag::set("flag_cairo_root_monologue_04_done");
}

/*
	Name: function_2dbeaba5
	Namespace: root_cairo
	Checksum: 0x8C7C86D8
	Offset: 0x1710
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_2dbeaba5()
{
	level endon(#"hash_1f265efe");
	level flag::wait_till("flag_cairo_root_monologue_04_done");
	level dialog::remote("salm_the_nature_of_memory_0", 4, "NO_DNI");
	level dialog::remote("salm_over_the_last_centur_0", 1, "NO_DNI");
}

/*
	Name: function_d3f1996d
	Namespace: root_cairo
	Checksum: 0xF01820D1
	Offset: 0x17A8
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function function_d3f1996d(str_objective)
{
	level endon(str_objective + "enter_vortex");
	level flag::wait_till("flag_diaz_first_path_complete_vo_done");
	wait(3);
	level notify(#"hash_d3c69346");
	level.ai_taylor dialog::say("tayr_diaz_and_maretti_i_0", 1);
	level.ai_taylor dialog::say("tayr_they_were_trying_to_0", 1);
	level.ai_taylor dialog::say("tayr_it_couldn_t_control_1", 1);
	wait(5);
	level thread function_7cdb6ab4();
	level flag::wait_till("flag_taylor_vo_never_give_up");
	level.ai_taylor dialog::say("tayr_don_t_give_up_be_0", 1);
}

/*
	Name: function_962eebf2
	Namespace: root_cairo
	Checksum: 0x81BCA60
	Offset: 0x18D8
	Size: 0x204
	Parameters: 1
	Flags: Linked
*/
function function_962eebf2(str_objective)
{
	array::run_all(level.players, &freezecontrols, 1);
	array::run_all(level.players, &enableinvulnerability);
	level scene::init("cin_zur_14_01_cairo_root_1st_fall");
	level util::streamer_wait();
	level thread util::screen_fade_in(1);
	array::thread_all(level.players, &clientfield::increment_to_player, "postfx_transition");
	playsoundatposition("evt_clearing_trans_in", (0, 0, 0));
	if(isdefined(level.bzm_zurichdialogue15callback))
	{
		level thread [[level.bzm_zurichdialogue15callback]]();
	}
	level scene::play("cin_zur_14_01_cairo_root_1st_fall");
	level util::teleport_players_igc("root_cairo_intro_end");
	array::run_all(level.players, &freezecontrols, 0);
	array::run_all(level.players, &disableinvulnerability);
	util::clear_streamer_hint();
	savegame::checkpoint_save();
	level thread zurich_util::function_c90e23b6(str_objective, "breadcrumb_cairoroot_3");
	level thread function_d3f1996d(str_objective);
}

/*
	Name: function_4cca3b70
	Namespace: root_cairo
	Checksum: 0x4819D692
	Offset: 0x1AE8
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_4cca3b70()
{
	scene::add_scene_func("p7_fxanim_cp_zurich_wall_drop_bundle", &function_fe87d3eb, "done");
	scene::add_scene_func("p7_fxanim_cp_zurich_wall_drop_bundle", &function_e3c9dd29, "play");
	level thread function_ef1ee0c7();
	var_15ecae1 = getent("trigger_vtol_arrival", "targetname");
	var_15ecae1 waittill(#"trigger");
	level thread scene::play("p7_fxanim_cp_zurich_wall_drop_bundle");
	level waittill(#"rocket_hits_vtol");
	wait(3);
	level notify(#"hash_4dbdcce4");
	level flag::wait_till("flag_cairo_start_wall_spawn");
	spawn_manager::enable("sm_vtol_wall");
	savegame::checkpoint_save();
}

/*
	Name: function_fe87d3eb
	Namespace: root_cairo
	Checksum: 0xF6E8021
	Offset: 0x1C28
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_fe87d3eb(a_ents)
{
	level flag::wait_till("vtol_dropped_wall");
	e_doors = getent("wall_drop_doors", "targetname");
	if(!isdefined(e_doors))
	{
		return;
	}
	level scene::play("p7_fxanim_cp_ramses_wall_drop_doors_up_bundle", e_doors);
	spawn_manager::enable("sm_doors_open");
}

/*
	Name: function_ef1ee0c7
	Namespace: root_cairo
	Checksum: 0x39716ED9
	Offset: 0x1CD0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_ef1ee0c7()
{
	var_abef87dc = getent("open_wall_doors", "script_noteworthy");
	var_abef87dc waittill(#"trigger");
	level flag::set("vtol_dropped_wall");
}

/*
	Name: function_e3c9dd29
	Namespace: root_cairo
	Checksum: 0x90A0E4E9
	Offset: 0x1D38
	Size: 0x106
	Parameters: 1
	Flags: Linked
*/
function function_e3c9dd29(a_ents)
{
	e_vtol = a_ents["wall_drop_vtol"];
	e_wall = a_ents["wall_drop_wall"];
	var_24a1012d = struct::get_array("vtol_scene_spawn_fx", "targetname");
	for(i = 0; i < var_24a1012d.size; i++)
	{
		var_9508eea7 = util::spawn_model("tag_origin", var_24a1012d[i].origin, (0, 0, 0));
		util::wait_network_frame();
		var_9508eea7 thread function_899f9f96();
	}
}

/*
	Name: function_899f9f96
	Namespace: root_cairo
	Checksum: 0xE60F6F49
	Offset: 0x1E48
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_899f9f96()
{
	self clientfield::increment("vtol_spawn_fx");
	wait(3);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: function_6559d2b2
	Namespace: root_cairo
	Checksum: 0x859035FA
	Offset: 0x1E98
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function function_6559d2b2()
{
	scene::add_scene_func("p7_fxanim_cp_zurich_checkpoint_wall_01_bundle", &function_c5b12ba9, "init");
	scene::add_scene_func("p7_fxanim_cp_zurich_checkpoint_wall_01_bundle", &function_73238a8, "play");
	trigger::wait_till("trig_cairo_arena_start", "script_noteworthy");
	spawn_manager::enable("sm_cairo_wall_02");
	spawn_manager::enable("sm_cairo_ambush");
	level thread function_8c7755d2();
	level thread function_46b4203d();
	level flag::wait_till("flag_cairo_arena_complete");
	level thread scene::play("p7_fxanim_cp_zurich_checkpoint_wall_01_bundle");
	spawn_manager::disable("sm_cairo_ambush");
}

/*
	Name: function_8c7755d2
	Namespace: root_cairo
	Checksum: 0xF10859CF
	Offset: 0x1FE0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_8c7755d2()
{
	level endon(#"hash_fc5ed004");
	wait(60);
	level flag::set("flag_cairo_arena_complete");
}

/*
	Name: function_46b4203d
	Namespace: root_cairo
	Checksum: 0x96A10702
	Offset: 0x2020
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_46b4203d()
{
	level endon(#"hash_fc5ed004");
	spawn_manager::wait_till_ai_remaining("sm_cairo_wall_02", 2);
	level flag::set("flag_cairo_arena_complete");
}

/*
	Name: function_c5b12ba9
	Namespace: root_cairo
	Checksum: 0x1A2E348A
	Offset: 0x2078
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function function_c5b12ba9(a_ents)
{
	foreach(e_ent in a_ents)
	{
		e_ent hide();
	}
}

/*
	Name: function_73238a8
	Namespace: root_cairo
	Checksum: 0xD4E58A12
	Offset: 0x2118
	Size: 0x1C4
	Parameters: 1
	Flags: Linked
*/
function function_73238a8(a_ents)
{
	var_7be3ca60 = getentarray("root_cairo_arena_doors", "targetname");
	foreach(e_ent in a_ents)
	{
		e_ent show();
	}
	foreach(mdl_door in var_7be3ca60)
	{
		mdl_door delete();
	}
	e_clip = getent("root_cairo_arena_clip", "targetname");
	if(isdefined(e_clip))
	{
		e_clip notsolid();
		e_clip connectpaths();
		e_clip delete();
	}
}

/*
	Name: function_54b0174d
	Namespace: root_cairo
	Checksum: 0xBB8740DF
	Offset: 0x22E8
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_54b0174d()
{
	var_35a225f3 = getent("lotus_tower_sink", "targetname");
	if(isdefined(var_35a225f3))
	{
		var_35a225f3 setscale(0.4);
		var_35a225f3 hide();
		level flag::wait_till("root_cairo_start");
		var_35a225f3 show();
		var_35a225f3 thread function_1a9fae41();
	}
}

/*
	Name: function_1a9fae41
	Namespace: root_cairo
	Checksum: 0x48B5656F
	Offset: 0x23B0
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function function_1a9fae41()
{
	var_70cf920f = getent("t_lotus_sink", "script_noteworthy");
	var_70cf920f waittill(#"trigger");
	s_start = self;
	playfx(level._effect["explosion_large"], self.origin);
	s_next = struct::get(self.target, "targetname");
	while(isdefined(s_next))
	{
		n_distance = distance(s_start.origin, s_next.origin);
		n_time = n_distance / 20;
		self moveto(s_next.origin, n_time);
		self rotateto(s_next.angles, n_time);
		self waittill(#"movedone");
		s_start = s_next;
		s_next = undefined;
		if(isdefined(s_start.target))
		{
			s_next = struct::get(s_start.target, "targetname");
		}
	}
}

/*
	Name: function_42dddb91
	Namespace: root_cairo
	Checksum: 0x9B96087E
	Offset: 0x2570
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function function_42dddb91(str_objective)
{
	level endon(str_objective + "_done");
	level endon(#"hash_83eebac0");
	objectives::breadcrumb("t_breadcrumb_cairoroot_1");
	trigger::wait_till("t_breadcrumb_cairoroot_1");
	level notify(#"hash_431e9a83");
	savegame::checkpoint_save();
	objectives::breadcrumb("t_breadcrumb_cairoroot_2");
	trigger::wait_till("t_breadcrumb_cairoroot_2");
	level notify(#"hash_431e9a83");
	savegame::checkpoint_save();
	objectives::breadcrumb("t_breadcrumb_cairoroot_3");
}

/*
	Name: function_c3dca267
	Namespace: root_cairo
	Checksum: 0x691A8CDD
	Offset: 0x2658
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_c3dca267()
{
	var_765ae49e = getentarray("cairo_vortex_spawn", "targetname");
	array::thread_all(var_765ae49e, &function_24c08a2f);
}

/*
	Name: function_24c08a2f
	Namespace: root_cairo
	Checksum: 0x8018EE36
	Offset: 0x26B8
	Size: 0x14E
	Parameters: 0
	Flags: Linked
*/
function function_24c08a2f()
{
	self waittill(#"trigger");
	var_66b68fff = getentarray(self.target, "targetname");
	self delete();
	for(i = 0; i < var_66b68fff.size; i++)
	{
		ai_raps = spawner::simple_spawn_single(var_66b68fff[i], &zurich_util::ai_surreal_spawn_fx);
		if(isdefined(var_66b68fff[i].script_noteworthy))
		{
			ai_raps.animname = var_66b68fff[i].script_noteworthy;
			ai_raps vehicle_ai::set_state("scripted");
			ai_raps setspeed(20);
			ai_raps thread function_54c51e5b();
			ai_raps thread function_20541efa();
		}
	}
}

/*
	Name: function_54c51e5b
	Namespace: root_cairo
	Checksum: 0x5FA3CE75
	Offset: 0x2810
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_54c51e5b()
{
	self endon(#"death");
	nd_start = getvehiclenode(self.script_noteworthy + "_start", "targetname");
	self thread vehicle::get_on_and_go_path(nd_start);
	self waittill(#"reached_end_node");
	self raps::detonate();
}

/*
	Name: function_20541efa
	Namespace: root_cairo
	Checksum: 0x418CAFE8
	Offset: 0x28A0
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_20541efa()
{
	self endon(#"death");
	while(true)
	{
		e_player = arraygetclosest(self.origin, level.activeplayers);
		if(distance(self.origin, e_player.origin) <= 600)
		{
			self vehicle_ai::set_state("combat");
			return;
		}
		wait(0.1);
	}
}

