// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_zurich_coalescence_accolades;
#using scripts\cp\cp_mi_zurich_coalescence_root_cinematics;
#using scripts\cp\cp_mi_zurich_coalescence_sound;
#using scripts\cp\cp_mi_zurich_coalescence_util;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace root_singapore;

/*
	Name: main
	Namespace: root_singapore
	Checksum: 0xAECDAC17
	Offset: 0xEA0
	Size: 0x2A4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	init_clientfields();
	level flag::init("sing_root_depthcharges");
	ai_spawners = getentarray("root_singapore_spawners", "script_noteworthy");
	level._effect["depth_charge_explosion"] = "explosions/fx_exp_underwater_depth_charge";
	level._effect["depth_charge_spawn"] = "player/fx_ai_raven_teleport";
	level._effect["vortex_explode"] = "player/fx_ai_dni_rez_in_hero_clean";
	level._effect["blood_impact_xsm"] = "blood/fx_blood_splash_furn_drop_xsm";
	level._effect["dirt_impact_xsm"] = "dirt/fx_dust_furn_drop_sm";
	level._effect["blood_impact_sm"] = "blood/fx_blood_splash_furn_drop_xsm";
	level._effect["dirt_impact_sm"] = "dirt/fx_dust_furn_drop_sm";
	level._effect["blood_impact_md"] = "blood/fx_blood_splash_furn_drop_md";
	level._effect["dirt_impact_md"] = "dirt/fx_dust_furn_drop_md";
	level._effect["blood_impact_lg"] = "blood/fx_blood_splash_furn_drop_lg";
	level._effect["dirt_impact_lg"] = "dirt/fx_dust_furn_drop_lg";
	scene::add_scene_func("p7_fxanim_cp_zurich_ferris_wheel_bundle", &zurich_util::function_9f90bc0f, "done", "root_singapore_start_done");
	scene::add_scene_func("p7_fxanim_cp_zurich_container_collapse_bundle", &zurich_util::function_9f90bc0f, "done", "root_singapore_start_done");
	scene::add_scene_func("p7_fxanim_cp_zurich_car_slide_bundle", &zurich_util::function_9f90bc0f, "done", "root_singapore_start_done");
	scene::add_scene_func("p7_fxanim_cp_zurich_ferris_wheel_wave_bundle", &function_8fbe0681, "play");
	scene::add_scene_func("p7_fxanim_cp_zurich_ferris_wheel_wave_bundle", &zurich_util::function_9f90bc0f, "done", "root_singapore_start_done");
}

/*
	Name: init_clientfields
	Namespace: root_singapore
	Checksum: 0xBD1180DC
	Offset: 0x1150
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	clientfield::register("scriptmover", "sm_depth_charge_fx", 1, 1, "int");
	clientfield::register("scriptmover", "water_disturbance", 1, 1, "int");
	clientfield::register("toplayer", "umbra_tome_singapore", 1, 2, "counter");
}

/*
	Name: skipto_main
	Namespace: root_singapore
	Checksum: 0x97DB506
	Offset: 0x11F0
	Size: 0x3C2
	Parameters: 2
	Flags: Linked
*/
function skipto_main(str_objective, b_starting)
{
	load::function_73adcefc();
	if(b_starting)
	{
		level util::screen_fade_out(0);
	}
	util::set_streamer_hint(8);
	videostart("cp_zurich_env_corvusmonitor", 1);
	var_4ccf970 = zurich_util::function_a00fa665(str_objective);
	zurich_util::enable_surreal_ai_fx(1, 0.5);
	array::thread_all(level.players, &zurich_util::function_39af75ef, "singapore_root_completed");
	spawner::add_spawn_function_group("raven_ambush_ai", "script_parameters", &zurich_util::function_aceff870);
	level thread scene::init("p7_fxanim_cp_zurich_ferris_wheel_bundle");
	level thread function_29073d62();
	level thread function_eb271a4b(str_objective);
	load::function_a2995f22();
	skipto::teleport_players(str_objective, 0);
	level thread function_23a51944();
	level thread function_54fbadd1();
	array::thread_all(level.activeplayers, &function_db4d091);
	callback::on_spawned(&function_db4d091);
	level.var_1895e0f9 = &function_1aeafdf8;
	level thread function_4402ab63();
	level thread function_95353712();
	level thread function_8842e57d();
	level thread function_a0e6701b();
	level thread function_3893ad5c(str_objective);
	level thread function_c9c3556c(str_objective);
	level thread zurich_util::function_a03f30f2(str_objective, "root_singapore_vortex", "root_singapore_regroup");
	level thread zurich_util::function_dd842585(str_objective, "root_singapore_vortex", "t_root_singapore_vortex");
	level waittill(str_objective + "enter_vortex");
	level thread function_95b88092("root_singapore_vortex", 0);
	foreach(player in level.players)
	{
		player util::show_hud(1);
	}
}

/*
	Name: function_db4d091
	Namespace: root_singapore
	Checksum: 0xE22E16CF
	Offset: 0x15C0
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_db4d091()
{
	level endon(#"hash_73b00182");
	self notify(#"hash_db4d091");
	self endon(#"hash_db4d091");
	self thread function_52ac3a61();
	self waittill(#"hash_a71a53c4");
	self clientfield::increment_to_player("umbra_tome_singapore");
	level thread function_252e350();
	level util::clientnotify("stSINmus");
}

/*
	Name: function_52ac3a61
	Namespace: root_singapore
	Checksum: 0x8FA0440A
	Offset: 0x1668
	Size: 0x156
	Parameters: 0
	Flags: Linked
*/
function function_52ac3a61()
{
	level endon(#"hash_73b00182");
	self endon(#"disconnect");
	self endon(#"hash_a71a53c4");
	self notify(#"hash_52ac3a61");
	self endon(#"hash_52ac3a61");
	var_4d85762b = self getentitynumber();
	self waittill(#"death");
	wait(0.5);
	if(isdefined(self.currentspectatingclient) && self.currentspectatingclient >= 0 && var_4d85762b != self.currentspectatingclient)
	{
		foreach(player in level.players)
		{
			if(player getentitynumber() == self.currentspectatingclient)
			{
				player clientfield::increment_to_player("umbra_tome_singapore");
				break;
			}
		}
	}
}

/*
	Name: function_1aeafdf8
	Namespace: root_singapore
	Checksum: 0xDAD2D249
	Offset: 0x17C8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_1aeafdf8()
{
	self clientfield::increment_to_player("umbra_tome_singapore");
}

/*
	Name: function_c38b8260
	Namespace: root_singapore
	Checksum: 0xF2D0C906
	Offset: 0x17F8
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function function_c38b8260()
{
	level flag::wait_till("all_players_spawned");
	util::wait_network_frame();
	util::wait_network_frame();
	foreach(e_player in level.players)
	{
		e_player clientfield::increment_to_player("umbra_tome_singapore");
	}
}

/*
	Name: function_95b88092
	Namespace: root_singapore
	Checksum: 0xBC99FB18
	Offset: 0x18D8
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
		array::thread_all(level.players, &zurich_util::function_39af75ef, "singapore_root_completed");
		level thread function_252e350();
		zurich_util::enable_surreal_ai_fx(1, 0.5);
		level thread zurich_util::function_c90e23b6(str_objective);
	}
	if(isdefined(level.bzm_zurichdialogue17callback))
	{
		level thread [[level.bzm_zurichdialogue17callback]]();
	}
	level thread scene::init("singapore_fxanim_heart_ceiling", "targetname");
	exploder::exploder("heartLightsSing");
	level thread namespace_67110270::function_973b77f9();
	self zurich_util::function_b0f0dd1f(0);
	level thread function_4b2f6f7();
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
	videostop("cp_zurich_env_corvusmonitor");
	util::clientnotify("stp_mus");
}

/*
	Name: skipto_start_done
	Namespace: root_singapore
	Checksum: 0xC4EB2684
	Offset: 0x1B38
	Size: 0x8C
	Parameters: 4
	Flags: Linked
*/
function skipto_start_done(str_objective, b_starting, b_direct, player)
{
	level thread function_c38b8260();
	a_e_cover = getentarray("singapore_cover", "targetname");
	array::run_all(a_e_cover, &delete);
}

/*
	Name: function_53a05865
	Namespace: root_singapore
	Checksum: 0x493158DB
	Offset: 0x1BD0
	Size: 0x7C
	Parameters: 4
	Flags: Linked
*/
function function_53a05865(str_objective, b_starting, b_direct, player)
{
	level notify(#"hash_73b00182");
	callback::remove_on_spawned(&function_db4d091);
	level.var_1895e0f9 = undefined;
	level thread zurich_util::function_4a00a473("root_singapore");
}

/*
	Name: function_efc52a3e
	Namespace: root_singapore
	Checksum: 0xAE3F5CE2
	Offset: 0x1C58
	Size: 0x3BC
	Parameters: 0
	Flags: Linked
*/
function function_efc52a3e()
{
	level endon(#"hash_8ba64bc4");
	level flag::wait_till("flag_singapore_root_monologue_01");
	level dialog::player_say("plyr_listen_only_to_the_s_2", 3);
	level dialog::player_say("plyr_let_your_mind_relax_2", 3);
	level dialog::player_say("plyr_let_your_thoughts_dr_2", 3);
	level dialog::player_say("plyr_let_the_bad_memories_2", 3);
	level dialog::player_say("plyr_let_peace_be_upon_yo_2", 3);
	level flag::wait_till("flag_singapore_root_monologue_02");
	level dialog::player_say("plyr_surrender_yourself_t_2", 3);
	level dialog::player_say("plyr_let_them_wash_over_y_2", 3);
	level dialog::player_say("plyr_imagine_somewhere_ca_2", 3);
	level dialog::player_say("plyr_imagine_somewhere_sa_2", 3);
	level dialog::player_say("plyr_imagine_yourself_2", 3);
	level flag::set("flag_singapore_root_monologue_02_done");
	level flag::wait_till_all(array("flag_salim_cognititve_neural_vo_done", "flag_singapore_root_monologue_03"));
	level dialog::player_say("plyr_you_are_standing_in_2", 3);
	level dialog::player_say("plyr_the_trees_around_you_2", 3);
	level dialog::player_say("plyr_pure_white_snowflake_2", 3);
	level dialog::player_say("plyr_you_can_feel_them_me_2", 3);
	level dialog::player_say("plyr_you_are_not_cold_2", 3);
	level dialog::player_say("plyr_it_cannot_overcome_t_2", 3);
	level flag::wait_till("flag_singapore_root_monologue_04");
	level dialog::player_say("plyr_can_you_hear_it_2", 3);
	level dialog::player_say("plyr_you_only_have_to_lis_2", 3);
	level dialog::player_say("plyr_do_you_hear_it_slowi_2", 3);
	level dialog::player_say("plyr_you_are_slowing_it_2", 3);
	level dialog::player_say("plyr_you_are_in_control_4", 3);
	level dialog::player_say("plyr_calm_2", 3);
	level dialog::player_say("plyr_at_peace_2", 3);
	level flag::set("flag_singapore_root_monologue_04_done");
}

/*
	Name: function_23a51944
	Namespace: root_singapore
	Checksum: 0x302BDDF1
	Offset: 0x2020
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_23a51944()
{
	wait(2);
	level dialog::remote("hcor_rachel_kane_never_ha_0", 1, "NO_DNI");
	level thread namespace_67110270::function_65e1e4b4();
	level dialog::remote("hcor_but_you_can_still_ma_0", 1, "NO_DNI");
	level flag::set("flag_hall_sing_intro_vo_done");
}

/*
	Name: function_49b9e027
	Namespace: root_singapore
	Checksum: 0x2DD7B72
	Offset: 0x20C8
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function function_49b9e027(str_objective)
{
	level endon(str_objective + "enter_vortex");
	level flag::wait_till("flag_hall_sing_intro_vo_done");
	wait(3);
	level notify(#"hash_d3c69346");
	level.ai_taylor dialog::say("tayr_you_ve_just_got_to_h_0");
	level.ai_taylor dialog::say("tayr_if_we_can_breach_the_0", 1);
	wait(5);
	level thread function_efc52a3e();
	level flag::wait_till("flag_taylor_vo_just_stay_with_me");
	if(flag::get("flag_singapore_root_monologue_02_done"))
	{
		level.ai_taylor dialog::say("tayr_just_stay_with_me_1");
	}
}

/*
	Name: function_4b2f6f7
	Namespace: root_singapore
	Checksum: 0xCBE6D28
	Offset: 0x21D8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_4b2f6f7()
{
	level endon(#"hash_8ba64bc4");
	level flag::wait_till("flag_singapore_root_monologue_04_done");
	level dialog::remote("salm_as_with_any_ground_b_0", 4, "NO_DNI");
	level dialog::remote("salm_should_the_internati_0", 1, "NO_DNI");
}

/*
	Name: function_54fbadd1
	Namespace: root_singapore
	Checksum: 0xD2EC553E
	Offset: 0x2270
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_54fbadd1()
{
	trigger::wait_till("t_sing_swim_salim_vo");
	if(flag::get("flag_singapore_root_monologue_02_done"))
	{
		level dialog::remote("salm_cognitive_neural_int_0", 1, "NO_DNI");
	}
	level flag::set("flag_salim_cognititve_neural_vo_done");
}

/*
	Name: function_c9c3556c
	Namespace: root_singapore
	Checksum: 0x70BA8342
	Offset: 0x2300
	Size: 0x1DC
	Parameters: 1
	Flags: Linked
*/
function function_c9c3556c(str_objective)
{
	array::run_all(level.players, &freezecontrols, 1);
	array::run_all(level.players, &enableinvulnerability);
	array::run_all(level.players, &util::show_hud, 0);
	wait(2);
	level thread util::screen_fade_in(1);
	array::thread_all(level.players, &clientfield::increment_to_player, "postfx_transition");
	playsoundatposition("evt_clearing_trans_in", (0, 0, 0));
	level zurich_util::function_c90e23b6(str_objective, "breadcrumb_singroot_3");
	level.ai_taylor ai::set_ignoreall(1);
	array::run_all(level.players, &freezecontrols, 0);
	array::run_all(level.players, &disableinvulnerability);
	array::run_all(level.players, &util::show_hud, 1);
	util::clear_streamer_hint();
	savegame::checkpoint_save();
}

/*
	Name: function_3893ad5c
	Namespace: root_singapore
	Checksum: 0x34D56DC1
	Offset: 0x24E8
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function function_3893ad5c(str_objective)
{
	b_in_water = 1;
	wait(1);
	if(isdefined(level.bzm_zurichdialogue19callback))
	{
		level thread [[level.bzm_zurichdialogue19callback]]();
	}
	while(b_in_water)
	{
		foreach(e_player in level.activeplayers)
		{
			if(!e_player isplayerunderwater())
			{
				b_in_water = 0;
			}
		}
		wait(0.05);
	}
	level.ai_taylor ai::set_ignoreall(0);
	level thread function_49b9e027(str_objective);
}

/*
	Name: function_eb271a4b
	Namespace: root_singapore
	Checksum: 0x31D8E255
	Offset: 0x2610
	Size: 0x156
	Parameters: 1
	Flags: Linked
*/
function function_eb271a4b(str_objective)
{
	level endon(str_objective + "_done");
	level endon(#"hash_73b00182");
	var_b1cdbf1d = 0;
	while(true)
	{
		var_f6e695c0 = struct::get("breadcrumb_singroot_" + var_b1cdbf1d, "targetname");
		var_b1fe230f = getent("t_singroot_" + var_b1cdbf1d, "script_noteworthy");
		if(!isdefined(var_f6e695c0) || !isdefined(var_b1fe230f))
		{
			return;
		}
		objectives::set("cp_waypoint_breadcrumb", var_f6e695c0);
		var_b1fe230f waittill(#"trigger");
		level notify(#"hash_431e9a83");
		savegame::checkpoint_save();
		if(var_b1cdbf1d == 2)
		{
			level thread function_26f61e7c();
		}
		objectives::complete("cp_waypoint_breadcrumb", var_f6e695c0);
		var_b1cdbf1d++;
	}
}

/*
	Name: function_26f61e7c
	Namespace: root_singapore
	Checksum: 0x22834404
	Offset: 0x2770
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_26f61e7c()
{
	level zurich_util::function_b0f0dd1f(1, "red_rain");
}

/*
	Name: function_8842e57d
	Namespace: root_singapore
	Checksum: 0xA012B0C0
	Offset: 0x27A0
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function function_8842e57d()
{
	var_d5aeed2b = getentarray("root_sing_cover", "targetname");
	var_d5aeed2b = array::thread_all(var_d5aeed2b, &function_258afdfc);
}

/*
	Name: function_258afdfc
	Namespace: root_singapore
	Checksum: 0x5078D27C
	Offset: 0x2800
	Size: 0x27A
	Parameters: 0
	Flags: Linked
*/
function function_258afdfc()
{
	var_482d5204 = struct::get_array(self.target, "targetname");
	/#
		assert(isdefined(var_482d5204), "");
	#/
	foreach(var_19966f24 in var_482d5204)
	{
		/#
			assert(isdefined(var_19966f24.model), "");
		#/
		/#
			assert(isdefined(var_19966f24.target), "");
		#/
		if(isdefined(var_19966f24.script_string))
		{
			a_nd_cover = getnodearray(var_19966f24.script_string, "targetname");
			foreach(nd_cover in a_nd_cover)
			{
				setenablenode(nd_cover, 0);
			}
		}
	}
	self waittill(#"trigger");
	foreach(var_19966f24 in var_482d5204)
	{
		var_19966f24 thread function_375f158a();
	}
}

/*
	Name: function_375f158a
	Namespace: root_singapore
	Checksum: 0xB6848F2A
	Offset: 0x2A88
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_375f158a()
{
	wait(randomfloat(2));
	var_4b1dfeae = util::spawn_model(self.model, self.origin, self.angles);
	var_4b1dfeae.var_1069f2d4 = struct::get(self.target, "targetname");
	var_4b1dfeae.targetname = "singapore_cover";
	if(isdefined(self.script_fxid))
	{
		var_4b1dfeae.script_fxid = self.script_fxid;
	}
	if(isdefined(self.script_string))
	{
		var_4b1dfeae.script_string = self.script_string;
		var_4b1dfeae thread function_e8047245();
	}
	var_4b1dfeae thread function_14bb726e();
	var_4b1dfeae thread function_1bf4af4f();
}

/*
	Name: function_14bb726e
	Namespace: root_singapore
	Checksum: 0xCB72C4FA
	Offset: 0x2BB0
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_14bb726e()
{
	n_move_time = randomfloatrange(0.5, 1.25);
	self moveto(self.var_1069f2d4.origin, n_move_time);
	self rotateto(self.var_1069f2d4.angles, n_move_time);
	self waittill(#"movedone");
	self solid();
	self playrumbleonentity("damage_heavy");
	playsoundatposition("evt_floor_debris_big", self.origin);
	if(isdefined(self.script_fxid))
	{
		playfxontag(level._effect[self.script_fxid], self, "tag_origin");
	}
	else
	{
		playfxontag(level._effect["dirt_impact_lg"], self, "tag_origin");
	}
}

/*
	Name: function_e8047245
	Namespace: root_singapore
	Checksum: 0x11E1E97D
	Offset: 0x2D08
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function function_e8047245()
{
	a_nd_cover = getnodearray(self.script_string, "targetname");
	self waittill(#"movedone");
	foreach(nd_cover in a_nd_cover)
	{
		setenablenode(nd_cover, 1);
	}
}

/*
	Name: function_1bf4af4f
	Namespace: root_singapore
	Checksum: 0x44BFB5F2
	Offset: 0x2DD8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_1bf4af4f()
{
	self endon(#"delete");
	level waittill(#"hash_4bb2007e");
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: function_a0e6701b
	Namespace: root_singapore
	Checksum: 0xFE6BCC06
	Offset: 0x2E20
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_a0e6701b()
{
	var_95ff9697 = getentarray("sing_falling_destructible", "script_noteworthy");
	array::thread_all(var_95ff9697, &function_514e0b2e);
}

/*
	Name: function_514e0b2e
	Namespace: root_singapore
	Checksum: 0xF333BD19
	Offset: 0x2E80
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function function_514e0b2e()
{
	if(self.classname === "script_model")
	{
		n_move_time = randomfloatrange(0.75, 1.5);
		self hide();
		self.t_radius = spawn("trigger_radius", self.origin, 0, 1024, 128);
		self movez(1024, 0.05);
		self.t_radius waittill(#"trigger");
		self.t_radius delete();
		self show();
		self movez(-1024, n_move_time);
		self waittill(#"movedone");
		self playrumbleonentity("damage_heavy");
		playsoundatposition("evt_floor_debris_big", self.origin);
		playfxontag(level._effect["dirt_impact_md"], self, "tag_origin");
	}
}

/*
	Name: function_29073d62
	Namespace: root_singapore
	Checksum: 0xA2697D14
	Offset: 0x3010
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_29073d62()
{
	level scene::init("p7_fxanim_cp_zurich_container_collapse_bundle");
	trigger::wait_till("container_fxanim", "script_noteworthy");
	level scene::play("p7_fxanim_cp_zurich_container_collapse_bundle");
}

/*
	Name: function_4402ab63
	Namespace: root_singapore
	Checksum: 0x7DE8D6A
	Offset: 0x3080
	Size: 0x182
	Parameters: 0
	Flags: Linked
*/
function function_4402ab63()
{
	trigger::wait_till("t_singroot_1", "script_noteworthy");
	level thread scene::play("p7_fxanim_cp_zurich_ferris_wheel_bundle");
	level thread scene::play("p7_fxanim_cp_zurich_ferris_wheel_wave_bundle");
	foreach(player in level.activeplayers)
	{
		player playrumbleonentity("damage_heavy");
	}
	level waittill(#"hash_55a06ec6");
	foreach(player in level.activeplayers)
	{
		player playrumbleonentity("cp_zurich_ferris_wheel_fall");
	}
}

/*
	Name: function_8fbe0681
	Namespace: root_singapore
	Checksum: 0xA060D1C3
	Offset: 0x3210
	Size: 0x22C
	Parameters: 1
	Flags: Linked
*/
function function_8fbe0681(a_ents)
{
	e_wave = a_ents["zurich_ferris_wheel_wave"];
	str_joint = "zur_wave_jnt";
	t_start = spawn("trigger_box", e_wave gettagorigin(str_joint), 0, 128, 1200, 128);
	t_start.angles = e_wave gettagangles(str_joint);
	t_start enablelinkto();
	t_start linkto(e_wave, str_joint, (0, 0, 0), vectorscale((0, 1, 0), 30));
	foreach(player in level.players)
	{
		t_start thread surge_player_tracker(player);
	}
	t_start thread enemy_surge_tracker();
	wait(0.05);
	e_wave clientfield::set("water_disturbance", 1);
	level waittill(#"hash_99c4740a");
	e_wave clientfield::set("water_disturbance", 0);
	level notify(#"wave_done");
	t_start delete();
}

/*
	Name: surge_player_tracker
	Namespace: root_singapore
	Checksum: 0x188F5A06
	Offset: 0x3448
	Size: 0x13C
	Parameters: 1
	Flags: Linked
*/
function surge_player_tracker(player)
{
	self endon(#"death");
	self endon(#"wave_stop");
	player endon(#"death");
	while(true)
	{
		self waittill(#"trigger", e_hit);
		if(e_hit == player && (!(isdefined(player.is_surged) && player.is_surged)))
		{
			player.is_surged = 1;
			player thread surge_trigger_watcher(self);
			if(isplayer(player) && player istouching(self))
			{
				player thread surge_player_push(self);
				player thread surge_player_rumble(self);
				player playsound("evt_surge_impact");
				break;
			}
		}
	}
}

/*
	Name: surge_trigger_watcher
	Namespace: root_singapore
	Checksum: 0x1C3029DA
	Offset: 0x3590
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function surge_trigger_watcher(t_surge)
{
	self endon(#"death");
	while(isdefined(t_surge) && self istouching(t_surge))
	{
		wait(0.05);
	}
	self.is_surged = 0;
	if(isdefined(t_surge))
	{
		t_surge notify(#"wave_stop");
	}
}

/*
	Name: surge_player_rumble
	Namespace: root_singapore
	Checksum: 0x80AB015B
	Offset: 0x3608
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function surge_player_rumble(t_wave)
{
	self endon(#"death");
	t_wave endon(#"wave_stop");
	while(true)
	{
		self playrumbleonentity("damage_heavy");
		wait(0.1);
	}
}

/*
	Name: surge_player_push
	Namespace: root_singapore
	Checksum: 0x3983BA0D
	Offset: 0x3668
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function surge_player_push(t_wave)
{
	self endon(#"death");
	t_wave endon(#"wave_stop");
	while(true)
	{
		if(!(isdefined(self.laststand) && self.laststand))
		{
			self setvelocity(anglestoforward(vectorscale((0, 1, 0), 345)) * 200);
		}
		wait(0.05);
	}
}

/*
	Name: enemy_surge_tracker
	Namespace: root_singapore
	Checksum: 0xBE8C53FF
	Offset: 0x3700
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function enemy_surge_tracker()
{
	self endon(#"death");
	self endon(#"wave_stop");
	while(true)
	{
		self waittill(#"trigger", ai_entity);
		if(isalive(ai_entity) && ai_entity.team == "axis" && (!(isdefined(ai_entity.b_swept) && ai_entity.b_swept)))
		{
			ai_entity.b_swept = 1;
			ai_entity thread enemy_surge_hit(self);
		}
	}
}

/*
	Name: enemy_surge_hit
	Namespace: root_singapore
	Checksum: 0xCDBD8854
	Offset: 0x37D0
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function enemy_surge_hit(t_surge)
{
	self endon(#"death");
	v_dir = vectornormalize(self.origin - t_surge.origin);
	self startragdoll();
	self launchragdoll(v_dir * 75);
	self kill();
}

/*
	Name: function_95353712
	Namespace: root_singapore
	Checksum: 0x3C5D06B0
	Offset: 0x3870
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_95353712()
{
	var_c44abb6a = getent("t_singroot_car1", "targetname");
	level thread scene::init("p7_fxanim_cp_zurich_car_slide_bundle");
	var_c44abb6a waittill(#"trigger");
	level thread scene::play("p7_fxanim_cp_zurich_car_slide_bundle");
}

/*
	Name: function_252e350
	Namespace: root_singapore
	Checksum: 0xB988EE19
	Offset: 0x38F0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_252e350()
{
	if(level flag::get("sing_root_depthcharges"))
	{
		return;
	}
	level flag::set("sing_root_depthcharges");
	level thread namespace_e9d9fb34::function_62b0213a();
	var_8edc0313 = struct::get_array("singapore_depth_charge", "targetname");
	array::thread_all(var_8edc0313, &create_depth_charge);
	level thread function_1c297ab3();
}

/*
	Name: create_depth_charge
	Namespace: root_singapore
	Checksum: 0x79AF2C93
	Offset: 0x39C0
	Size: 0x14E
	Parameters: 0
	Flags: Linked
*/
function create_depth_charge()
{
	level endon(#"hash_cc8de88d");
	self endon(#"hash_f9256645");
	self thread function_6a938164();
	n_spawned = 0;
	wait(1);
	while(3 > n_spawned)
	{
		e_depth_charge = self create_depth_charge_model();
		n_spawned++;
		if(isdefined(e_depth_charge))
		{
			s_target = struct::get(self.target, "targetname");
			if(isdefined(s_target))
			{
				e_depth_charge thread handle_movement(s_target);
			}
			e_depth_charge.targetname = "depth_charger_dive";
			e_depth_charge thread early_explosion();
			e_depth_charge thread detect_nearby_player(200);
			e_depth_charge waittill(#"exploded");
			wait(randomfloatrange(1.5, 3));
		}
		else
		{
			return;
		}
	}
}

/*
	Name: function_1c297ab3
	Namespace: root_singapore
	Checksum: 0x55EB819F
	Offset: 0x3B18
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_1c297ab3()
{
	trigger::wait_till("stop_depth_charges");
	level notify(#"hash_cc8de88d");
	level flag::clear("sing_root_depthcharges");
}

/*
	Name: function_6a938164
	Namespace: root_singapore
	Checksum: 0x8D27AD79
	Offset: 0x3B68
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_6a938164()
{
	self endon(#"hash_f9256645");
	level endon(#"hash_cc8de88d");
	while(true)
	{
		e_player = arraygetclosest(self.origin, level.activeplayers);
		if(isdefined(e_player) && distance(e_player.origin, self.origin) < 256)
		{
			self notify(#"hash_f9256645");
		}
		wait(0.1);
	}
}

/*
	Name: create_depth_charge_model
	Namespace: root_singapore
	Checksum: 0x8FFE6D03
	Offset: 0x3C10
	Size: 0x140
	Parameters: 0
	Flags: Linked
*/
function create_depth_charge_model()
{
	playfx(level._effect["depth_charge_spawn"], self.origin);
	wait(0.2);
	e_depth_charge = util::spawn_model("veh_t7_drone_depth_charge", self.origin, (randomint(360), randomint(360), randomint(360)));
	if(isdefined(e_depth_charge))
	{
		e_depth_charge.script_noteworthy = "depth_charge_model";
		e_depth_charge setcandamage(1);
		e_depth_charge.health = 999999;
		e_depth_charge clientfield::set("sm_depth_charge_fx", 1);
		e_depth_charge thread handle_damage();
	}
	return e_depth_charge;
}

/*
	Name: handle_movement
	Namespace: root_singapore
	Checksum: 0x8AF3B017
	Offset: 0x3D58
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function handle_movement(s_target, should_ignore_player)
{
	self endon(#"death");
	while(isdefined(s_target))
	{
		n_distance = distance(self.origin, s_target.origin);
		n_time = n_distance / 100;
		self moveto(s_target.origin, n_time);
		self waittill(#"movedone");
		if(isdefined(s_target.target))
		{
			s_target = struct::get(s_target.target, "targetname");
		}
		else
		{
			s_target = undefined;
		}
	}
	level.var_e83d53e9 = 1;
	self detonate_depth_charge();
}

/*
	Name: handle_damage
	Namespace: root_singapore
	Checksum: 0x28870AFB
	Offset: 0x3E78
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function handle_damage()
{
	self endon(#"death");
	self waittill(#"damage", damage, e_attacker);
	self detonate_depth_charge(isdefined(e_attacker) && isplayer(e_attacker));
}

/*
	Name: early_explosion
	Namespace: root_singapore
	Checksum: 0x34B205DA
	Offset: 0x3EE8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function early_explosion()
{
	self endon(#"death");
	n_fuse_time = randomfloatrange(12, 32);
	wait(n_fuse_time);
	level.var_e83d53e9 = 1;
	self detonate_depth_charge();
}

/*
	Name: detonate_depth_charge
	Namespace: root_singapore
	Checksum: 0x522E707C
	Offset: 0x3F58
	Size: 0x1FA
	Parameters: 1
	Flags: Linked
*/
function detonate_depth_charge(should_chain = 0)
{
	if(!isdefined(self))
	{
		return;
	}
	v_origin = self.origin;
	self radiusdamage(v_origin, 200, 80, 40, self);
	playrumbleonposition("depth_charge_rumble", v_origin);
	self notify(#"exploded");
	if(self.classname === "script_model")
	{
		playfx(level._effect["depth_charge_explosion"], v_origin);
		playsoundatposition("exp_drone_underwater", v_origin);
		self util::self_delete();
	}
	wait(0.1);
	if(isdefined(should_chain) && should_chain)
	{
		a_e_depth_charges = getentarray("depth_charge_model", "script_noteworthy");
		a_e_depth_charges = arraysortclosest(a_e_depth_charges, v_origin, undefined, 0, 120);
		foreach(e_depth_charge in a_e_depth_charges)
		{
			e_depth_charge detonate_depth_charge();
		}
	}
}

/*
	Name: detect_nearby_player
	Namespace: root_singapore
	Checksum: 0x8F994307
	Offset: 0x4160
	Size: 0x1F8
	Parameters: 1
	Flags: Linked
*/
function detect_nearby_player(n_update_range = 200)
{
	self endon(#"death");
	while(true)
	{
		foreach(e_player in level.activeplayers)
		{
			if(!e_player isinmovemode("ufo", "noclip"))
			{
				if(distancesquared(e_player.origin, self.origin) < (n_update_range * n_update_range) && !e_player laststand::player_is_in_laststand())
				{
					self._activated_player = e_player;
					level.var_e83d53e9 = 1;
					self detonate_depth_charge();
				}
			}
			if(self.classname === "script_model")
			{
				if(distancesquared(self.origin, e_player.origin) < (n_update_range * 1.8) * (n_update_range * 1.8))
				{
					self clientfield::set("sm_depth_charge_fx", 0);
					continue;
				}
				self clientfield::set("sm_depth_charge_fx", 1);
			}
		}
		wait(0.1);
	}
}

