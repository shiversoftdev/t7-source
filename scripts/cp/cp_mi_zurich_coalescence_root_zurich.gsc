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

#namespace root_zurich;

/*
	Name: main
	Namespace: root_zurich
	Checksum: 0xCEE10A82
	Offset: 0xBE0
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	init_clientfields();
	ai_spawners = getentarray("root_zurich_spawners", "script_noteworthy");
	array::thread_all(ai_spawners, &spawner::add_spawn_function, &util::ai_frost_breath);
	var_603657ba = getentarray("root_zurich_robot_spawners", "script_noteworthy");
	array::thread_all(var_603657ba, &spawner::add_spawn_function, &zurich_util::function_d8c91e6b);
}

/*
	Name: init_clientfields
	Namespace: root_zurich
	Checksum: 0x3211216D
	Offset: 0xCC0
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	clientfield::register("scriptmover", "zurich_snow_rise", 1, 1, "counter");
	clientfield::register("toplayer", "reflection_extracam", 1, 1, "int");
	clientfield::register("toplayer", "zurich_vinewall_init", 1, 1, "int");
	clientfield::register("world", "root_vine_cleanup", 1, 1, "counter");
	clientfield::register("toplayer", "mirror_break", 1, 1, "int");
	clientfield::register("scriptmover", "mirror_warp", 1, 1, "int");
}

/*
	Name: skipto_main
	Namespace: root_zurich
	Checksum: 0xF51F0584
	Offset: 0xDF0
	Size: 0x2E4
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
	level scene::init("cin_zur_12_01_root_1st_mirror_01");
	if(isdefined(level.bzm_zurichdialogue11callback))
	{
		level thread [[level.bzm_zurichdialogue11callback]]();
	}
	var_4ccf970 = zurich_util::function_a00fa665(str_objective);
	exploder::exploder("zurich_lightning_exp");
	zurich_util::enable_surreal_ai_fx(1, 0.5);
	spawner::add_spawn_function_group("raven_ambush_ai", "script_parameters", &zurich_util::function_aceff870);
	level thread function_2d897f84(str_objective);
	level thread function_187dfb55();
	level thread function_8182f3c5();
	level thread function_9831305d();
	load::function_a2995f22();
	skipto::teleport_players(str_objective, 1);
	array::thread_all(level.players, &util::player_frost_breath, 1);
	array::thread_all(level.players, &clientfield::set_to_player, "zurich_vinewall_init", 1);
	level zurich_util::function_b0f0dd1f(1, "light_snow");
	level thread function_aa95075d(str_objective);
	level thread function_53a7bcca();
	level thread zurich_util::function_a03f30f2(str_objective, "root_zurich_vortex", "root_zurich_regroup");
	level thread zurich_util::function_dd842585(str_objective, "root_zurich_vortex", "t_root_zurich_vortex");
	level waittill(str_objective + "enter_vortex");
	level thread namespace_67110270::function_973b77f9();
	level thread function_95b88092("root_zurich_vortex", 0);
}

/*
	Name: function_95b88092
	Namespace: root_zurich
	Checksum: 0x1921466E
	Offset: 0x10E0
	Size: 0x2C4
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
		foreach(e_player in level.activeplayers)
		{
			e_player thread util::player_frost_breath(1);
		}
	}
	if(isdefined(level.bzm_zurichdialogue9callback))
	{
		level thread [[level.bzm_zurichdialogue9callback]]();
	}
	level thread scene::init("zurich_fxanim_heart_ceiling", "targetname");
	exploder::exploder("heartLightsZurich");
	level thread namespace_67110270::function_973b77f9();
	level util::clientnotify("stZURmus");
	level thread function_1ef8526e();
	level zurich_util::function_c90e23b6(str_objective);
	level.ai_taylor thread zurich_util::function_fe5160df(1);
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
	exploder::stop_exploder("zurich_lightning_exp");
}

/*
	Name: skipto_done
	Namespace: root_zurich
	Checksum: 0xAF5B749
	Offset: 0x13B0
	Size: 0x132
	Parameters: 4
	Flags: Linked
*/
function skipto_done(str_objective, b_starting, b_direct, player)
{
	level notify(#"hash_c955b42d");
	level zurich_util::function_b0f0dd1f(0);
	level clientfield::increment("root_vine_cleanup");
	level thread zurich_util::function_4a00a473("root_zurich");
	level util::clientnotify("stp_mus");
	foreach(e_player in level.activeplayers)
	{
		e_player thread util::player_frost_breath(0);
	}
}

/*
	Name: function_a61dfb7
	Namespace: root_zurich
	Checksum: 0xFE09517C
	Offset: 0x14F0
	Size: 0x2CC
	Parameters: 0
	Flags: Linked
*/
function function_a61dfb7()
{
	level endon(#"hash_1d98ceef");
	level flag::wait_till("flag_monologue_zurich_root_01");
	level dialog::player_say("plyr_i_don_t_understand_0", 3);
	level dialog::player_say("plyr_talk_to_me_please_0", 3);
	level dialog::player_say("plyr_i_don_t_know_what_s_0", 3);
	level dialog::player_say("plyr_i_don_t_know_what_to_0", 3);
	level flag::wait_till("flag_monologue_zurich_root_02");
	level dialog::player_say("plyr_i_know_corvus_is_ins_0", 3);
	level dialog::player_say("plyr_i_know_it_s_trying_t_0", 3);
	level dialog::player_say("plyr_i_want_to_get_it_out_0", 3);
	level dialog::player_say("plyr_i_have_to_keep_going_0", 3);
	level dialog::player_say("plyr_i_have_to_finish_thi_0", 3);
	level flag::wait_till("flag_monologue_zurich_root_03");
	level dialog::player_say("plyr_i_m_coming_for_you_c_0", 3);
	level dialog::player_say("plyr_you_destroyed_my_tea_0", 3);
	level dialog::player_say("plyr_you_destroyed_my_fri_0", 3);
	level dialog::player_say("plyr_i_m_going_to_find_yo_0", 3);
	level flag::wait_till("flag_monologue_zurich_root_04");
	level dialog::player_say("plyr_do_you_hear_me_0", 3);
	level dialog::player_say("plyr_it_doesn_t_matter_wh_0", 3);
	level dialog::player_say("plyr_i_will_not_let_go_0", 3);
	level dialog::player_say("plyr_do_you_hear_me_i_wi_0", 3);
	level flag::set("flag_monologue_zurich_root_04_done");
}

/*
	Name: function_1ef8526e
	Namespace: root_zurich
	Checksum: 0x7C08B7B5
	Offset: 0x17C8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_1ef8526e()
{
	level endon(#"hash_1d98ceef");
	level flag::wait_till("flag_monologue_zurich_root_04_done");
	level dialog::remote("salm_the_human_mind_holds_0", 4, "NO_DNI");
	level dialog::remote("salm_our_ability_to_analy_0", 1, "NO_DNI");
}

/*
	Name: function_9dd2872e
	Namespace: root_zurich
	Checksum: 0xAFFECDA8
	Offset: 0x1860
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function function_9dd2872e(str_objective)
{
	level endon(str_objective + "enter_vortex");
	level notify(#"hash_d3c69346");
	level thread namespace_67110270::function_ff7a72bf();
	level.ai_taylor dialog::say("tayr_all_this_shit_around_1", 1);
	level.ai_taylor dialog::say("tayr_corvus_is_messing_wi_0", 1);
	level.ai_taylor dialog::say("tayr_just_stay_with_me_0", 1);
	level thread function_a61dfb7();
}

/*
	Name: function_53a7bcca
	Namespace: root_zurich
	Checksum: 0x3BA2962
	Offset: 0x1938
	Size: 0x13A
	Parameters: 0
	Flags: Linked
*/
function function_53a7bcca()
{
	e_trig = trigger::wait_till("t_zurichroot_2", "script_noteworthy");
	a_ai_enemy = getaiteamarray("axis", "team3");
	foreach(ai_enemy in a_ai_enemy)
	{
		if(distance(e_trig.who.origin, ai_enemy.origin) > 2000)
		{
			util::stop_magic_bullet_shield(ai_enemy);
			ai_enemy kill();
		}
	}
}

/*
	Name: function_aa95075d
	Namespace: root_zurich
	Checksum: 0x14B7830D
	Offset: 0x1A80
	Size: 0x2BC
	Parameters: 1
	Flags: Linked
*/
function function_aa95075d(str_objective)
{
	util::wait_network_frame();
	scene::add_scene_func("p7_fxanim_cp_zurich_mirror_bundle", &function_b8580c84, "init");
	scene::init("p7_fxanim_cp_zurich_mirror_bundle");
	level thread function_c88fe82();
	level thread namespace_67110270::function_973b77f9();
	var_a3612ddd = 0;
	foreach(player in level.players)
	{
		var_a3612ddd++;
		player thread function_2a895f94(var_a3612ddd);
	}
	level waittill(#"hash_3e3847fd");
	wait(1);
	level thread util::screen_fade_in(1);
	array::thread_all(level.players, &clientfield::increment_to_player, "postfx_transition");
	playsoundatposition("evt_clearing_trans_in", (0, 0, 0));
	level waittill(#"hash_1f51b705");
	level thread scene::play("cin_zur_12_01_root_1st_mirror_taylor_cam");
	level waittill(#"hash_c27a3d1");
	level thread scene::play("p7_fxanim_cp_zurich_mirror_bundle");
	level waittill(#"hash_e01132f9");
	util::clear_streamer_hint();
	savegame::checkpoint_save();
	level zurich_util::function_c90e23b6(str_objective, "breadcrumb_zurichroot_5");
	level.ai_taylor thread zurich_util::function_fe5160df(1);
	wait(2);
	level function_3292451c();
	level thread function_9dd2872e(str_objective);
	videostart("cp_zurich_env_corvusmonitor", 1);
}

/*
	Name: function_b8580c84
	Namespace: root_zurich
	Checksum: 0x37FEFFB2
	Offset: 0x1D48
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function function_b8580c84(a_ents)
{
	var_29613ea0 = a_ents["zurich_mirror_start"];
	array::thread_all(level.players, &clientfield::set_to_player, "reflection_extracam", 1);
	array::thread_all(level.players, &clientfield::set_to_player, "mirror_break", 1);
	level notify(#"hash_3e3847fd");
	level waittill(#"hash_80b2a624");
	var_29613ea0 clientfield::set("mirror_warp", 1);
	var_29613ea0 playsound("evt_mirror_warp_taylor");
	level waittill(#"hash_1f51b705");
	var_29613ea0 clientfield::set("mirror_warp", 0);
}

/*
	Name: function_2a895f94
	Namespace: root_zurich
	Checksum: 0x146B700C
	Offset: 0x1E70
	Size: 0x422
	Parameters: 1
	Flags: Linked
*/
function function_2a895f94(var_a3612ddd)
{
	self endon(#"disconnect");
	self endon(#"death");
	scene::add_scene_func("cin_zur_12_01_root_1st_mirror_taylor_0" + var_a3612ddd, &function_cbebe415, "play");
	var_b16f0715 = [];
	var_e0cf565f = array::exclude(level.players, array(self));
	foreach(e_guy in var_e0cf565f)
	{
		e_clone = util::spawn_player_clone(e_guy);
		e_clone.var_f5434f17 = util::spawn_model("tag_origin", e_clone gettagorigin("tag_weapon_right"), e_clone gettagangles("tag_weapon_right"));
		e_weapon = e_guy.currentweapon;
		e_clone.var_f5434f17 useweaponmodel(e_weapon, e_weapon.worldmodel, e_guy getweaponoptions(e_weapon));
		e_clone.var_f5434f17 linkto(e_clone, "tag_weapon_right");
		foreach(e_player in var_e0cf565f)
		{
			e_clone setinvisibletoplayer(e_player, 1);
			e_clone.var_f5434f17 setinvisibletoplayer(e_player, 1);
		}
		array::add(var_b16f0715, e_clone);
	}
	self setinvisibletoall();
	self thread function_2398f048(var_b16f0715, var_a3612ddd);
	array::add(var_b16f0715, self);
	level thread scene::play("cin_zur_12_01_root_1st_mirror_taylor_0" + var_a3612ddd);
	level scene::play("cin_zur_12_01_root_1st_mirror_0" + var_a3612ddd, var_b16f0715);
	util::teleport_players_igc("root_zurich_start");
	var_b16f0715 = array::exclude(var_b16f0715, array(self));
	array::run_all(var_b16f0715, &delete);
	self show();
	self setvisibletoall();
	level notify(#"hash_e01132f9");
}

/*
	Name: function_2398f048
	Namespace: root_zurich
	Checksum: 0xC80B72A4
	Offset: 0x22A0
	Size: 0x1BC
	Parameters: 2
	Flags: Linked
*/
function function_2398f048(var_b16f0715, var_a3612ddd)
{
	self endon(#"disconnect");
	self endon(#"death");
	level waittill(#"hash_1f51b705");
	e_taylor = scene::get_existing_ent("taylor_0" + var_a3612ddd);
	e_taylor setvisibletoplayer(self);
	wait(0.5);
	foreach(e_clone in var_b16f0715)
	{
		if(isdefined(e_clone.var_f5434f17))
		{
			e_clone.var_f5434f17 unlink();
			e_clone.var_f5434f17 delete();
		}
	}
	array::run_all(var_b16f0715, &setinvisibletoplayer, self, 1);
	self hide();
	level waittill(#"hash_e01132f9");
	wait(3);
	self clientfield::set_to_player("reflection_extracam", 0);
}

/*
	Name: function_cbebe415
	Namespace: root_zurich
	Checksum: 0x49A68373
	Offset: 0x2468
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function function_cbebe415(a_ents)
{
	foreach(e_taylor in a_ents)
	{
		e_taylor setinvisibletoall();
	}
}

/*
	Name: function_9831305d
	Namespace: root_zurich
	Checksum: 0x24E2DE13
	Offset: 0x2508
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function function_9831305d()
{
	var_b6e5ad19 = getentarray("zurich_popup_poles", "targetname");
	for(i = 0; i < var_b6e5ad19.size; i++)
	{
		var_b6e5ad19[i].end_pos = var_b6e5ad19[i].origin;
		if(isdefined(var_b6e5ad19[i].target))
		{
			var_fb3442a9 = struct::get_array(var_b6e5ad19[i].target, "targetname");
			for(j = 0; j < var_fb3442a9.size; j++)
			{
				if(var_fb3442a9[j].script_noteworthy === "start_pos")
				{
					var_b6e5ad19[i].start_pos = var_fb3442a9[j].origin;
					var_b6e5ad19[i] moveto(var_b6e5ad19[i].start_pos, 0.05);
					continue;
				}
				if(var_fb3442a9[j].script_noteworthy === "fx_pos")
				{
					var_b6e5ad19[i].fx_pos = var_fb3442a9[j];
				}
			}
		}
	}
}

/*
	Name: function_3292451c
	Namespace: root_zurich
	Checksum: 0x5E19EE15
	Offset: 0x26D8
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function function_3292451c()
{
	var_6fbeca4a = 1;
	var_6fe9b606 = getent("popup_pole_" + var_6fbeca4a, "script_noteworthy");
	while(isdefined(var_6fe9b606))
	{
		var_6fe9b606 moveto(var_6fe9b606.end_pos, 0.5);
		v_ground = groundtrace(var_6fe9b606.fx_pos.origin, var_6fe9b606.origin, 0, var_6fe9b606)["position"];
		var_f33892ac = util::spawn_model("tag_origin", v_ground, var_6fe9b606.angles);
		var_6fe9b606 waittill(#"movedone");
		var_f33892ac clientfield::increment("zurich_snow_rise");
		playsoundatposition("evt_roots_grow", var_f33892ac.origin);
		var_f33892ac thread function_df835392();
		exploder::exploder("lgt_zurichpole_exp_" + var_6fbeca4a);
		var_6fbeca4a++;
		var_6fe9b606 = getent("popup_pole_" + var_6fbeca4a, "script_noteworthy");
	}
}

/*
	Name: function_c88fe82
	Namespace: root_zurich
	Checksum: 0x588B62D9
	Offset: 0x28B0
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function function_c88fe82()
{
	level dialog::remote("mcor_you_ever_say_or_do_s_0", 1, "NO_DNI");
	level dialog::remote("tayr_maretti_is_that_yo_0", 1, "NO_DNI");
	level dialog::remote("mcor_maybe_it_wasn_t_you_0", 1, "NO_DNI");
	level dialog::remote("mcor_maybe_it_was_someone_0", 1, "NO_DNI");
	level dialog::remote("tayr_what_the_fuck_0", 1, "NO_DNI");
	level dialog::player_say("plyr_taylor_3", 1);
	level dialog::player_say("plyr_are_you_still_with_m_0", 1);
}

/*
	Name: function_2d897f84
	Namespace: root_zurich
	Checksum: 0x9B6E11B2
	Offset: 0x2A00
	Size: 0x13E
	Parameters: 1
	Flags: Linked
*/
function function_2d897f84(str_objective)
{
	level endon(str_objective + "_done");
	level endon(#"hash_c955b42d");
	var_b1cdbf1d = 1;
	while(true)
	{
		var_f6e695c0 = struct::get("breadcrumb_zurichroot_" + var_b1cdbf1d, "targetname");
		var_b1fe230f = getent("t_zurichroot_" + var_b1cdbf1d, "script_noteworthy");
		if(!isdefined(var_f6e695c0) || !isdefined(var_b1fe230f))
		{
			return;
		}
		objectives::set("cp_waypoint_breadcrumb", var_f6e695c0);
		var_b1fe230f waittill(#"trigger");
		level notify(#"hash_431e9a83");
		savegame::checkpoint_save();
		objectives::complete("cp_waypoint_breadcrumb", var_f6e695c0);
		var_b1cdbf1d++;
	}
}

/*
	Name: function_8182f3c5
	Namespace: root_zurich
	Checksum: 0x26632D43
	Offset: 0x2B48
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_8182f3c5()
{
	var_3e269f89 = getentarray("zurich_vinewall_trig", "targetname");
	array::thread_all(var_3e269f89, &function_ddbd0859);
}

/*
	Name: function_ddbd0859
	Namespace: root_zurich
	Checksum: 0x2B9D12A6
	Offset: 0x2BA8
	Size: 0x292
	Parameters: 0
	Flags: Linked
*/
function function_ddbd0859()
{
	var_4cb02780 = getentarray(self.target, "targetname");
	for(i = 0; i < var_4cb02780.size; i++)
	{
		var_4cb02780[i].end_pos = var_4cb02780[i].origin;
		if(isdefined(var_4cb02780[i].script_string))
		{
			var_4cb02780[i] thread function_e8047245();
		}
		if(isdefined(var_4cb02780[i].target))
		{
			var_fb3442a9 = struct::get_array(var_4cb02780[i].target, "targetname");
			for(j = 0; j < var_fb3442a9.size; j++)
			{
				if(var_fb3442a9[j].script_noteworthy === "start_pos")
				{
					var_4cb02780[i].start_pos = var_fb3442a9[j].origin;
					var_4cb02780[i] moveto(var_4cb02780[i].start_pos, 0.05);
					continue;
				}
			}
		}
		if(!isdefined(var_4cb02780[i].start_pos))
		{
			var_4cb02780[i] movez(-128, 0.05);
		}
	}
	self waittill(#"trigger");
	foreach(e_wall in var_4cb02780)
	{
		e_wall thread function_300319e3();
	}
}

/*
	Name: function_300319e3
	Namespace: root_zurich
	Checksum: 0xD56A291C
	Offset: 0x2E48
	Size: 0x1D0
	Parameters: 0
	Flags: Linked
*/
function function_300319e3()
{
	n_time = randomfloatrange(0.2, 0.75);
	wait(n_time);
	self moveto(self.end_pos, n_time);
	if(isdefined(self.target))
	{
		var_abc323ed = struct::get_array(self.target, "targetname");
		for(i = 0; i < var_abc323ed.size; i++)
		{
			if(var_abc323ed[i].script_noteworthy === "fx_pos")
			{
				v_ground = groundtrace(var_abc323ed[i].origin, self.origin, 0, self)["position"];
				var_f33892ac = util::spawn_model("tag_origin", v_ground, var_abc323ed[i].angles);
				self waittill(#"movedone");
				var_f33892ac clientfield::increment("zurich_snow_rise");
				playsoundatposition("evt_roots_grow", var_abc323ed[i].origin);
				var_f33892ac thread function_df835392();
				return;
			}
		}
	}
}

/*
	Name: function_e8047245
	Namespace: root_zurich
	Checksum: 0xCBFF9721
	Offset: 0x3020
	Size: 0x14A
	Parameters: 0
	Flags: Linked
*/
function function_e8047245()
{
	a_nd_cover = getnodearray(self.script_string, "targetname");
	foreach(nd_cover in a_nd_cover)
	{
		setenablenode(nd_cover, 0);
	}
	self waittill(#"movedone");
	foreach(nd_cover in a_nd_cover)
	{
		setenablenode(nd_cover, 1);
	}
}

/*
	Name: function_df835392
	Namespace: root_zurich
	Checksum: 0x19C13B44
	Offset: 0x3178
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_df835392()
{
	wait(3);
	self delete();
}

/*
	Name: function_187dfb55
	Namespace: root_zurich
	Checksum: 0x48F2CCFB
	Offset: 0x31A0
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_187dfb55()
{
	scene::add_scene_func("p7_fxanim_cp_zurich_roots_train_bundle", &function_74c17b69, "play");
	scene::add_scene_func("p7_fxanim_cp_zurich_roots_train_bundle", &zurich_util::function_9f90bc0f, "done", "zurich_root_completed");
	level thread scene::init("p7_fxanim_cp_zurich_roots_train_bundle");
	level flag::wait_till("flag_start_zurich_train_logic");
	level thread function_b9295ca8();
	level thread function_ddc2d04e();
	level flag::wait_till("flag_zurich_root_final_encounter_complete");
	objectives::breadcrumb("t_zurichroot_traincars");
	trigger::wait_till("t_zurichroot_traincars");
	spawn_manager::kill("sm_zurich_root_end_rushers");
	playsoundatposition("evt_roots_train_start", (-21602, -25483, 1681));
	level thread function_a85c54c7();
	level scene::play("p7_fxanim_cp_zurich_roots_train_bundle");
}

/*
	Name: function_a85c54c7
	Namespace: root_zurich
	Checksum: 0x4477B264
	Offset: 0x3350
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_a85c54c7()
{
	level waittill(#"hash_bf94f0c3");
	getent("zur_root_train_blocker", "targetname") delete();
	objectives::breadcrumb("t_breadcrumb_zurichroot_exit");
}

/*
	Name: function_74c17b69
	Namespace: root_zurich
	Checksum: 0x19CB0FAE
	Offset: 0x33B8
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function function_74c17b69(a_ents)
{
	foreach(e_ent in a_ents)
	{
		e_ent playrumbleonentity("cp_infection_hideout_stretch");
	}
}

/*
	Name: function_b9295ca8
	Namespace: root_zurich
	Checksum: 0xD2A8B5D6
	Offset: 0x3460
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_b9295ca8()
{
	level endon(#"hash_e0d2827d");
	spawn_manager::wait_till_ai_remaining("sm_zurich_root_end", 2);
	level flag::set("flag_zurich_root_final_encounter_complete");
}

/*
	Name: function_ddc2d04e
	Namespace: root_zurich
	Checksum: 0x3FB53A5D
	Offset: 0x34B8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_ddc2d04e()
{
	level endon(#"hash_e0d2827d");
	wait(60);
	level flag::set("flag_zurich_root_final_encounter_complete");
}

