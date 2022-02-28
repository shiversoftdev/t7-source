// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_debug;
#using scripts\cp\_dialog;
#using scripts\cp\_hazard;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_cairo_aquifer_ambience;
#using scripts\cp\cp_mi_cairo_aquifer_objectives;
#using scripts\cp\cp_mi_cairo_aquifer_sound;
#using scripts\cp\cp_mi_cairo_aquifer_utility;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace namespace_967f4af8;

/*
	Name: main
	Namespace: namespace_967f4af8
	Checksum: 0xE5A01181
	Offset: 0xDB0
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level._effect["emp_flash"] = "_t6/weapon/emp/fx_emp_explosion";
	thread init_flags();
	thread function_60f7b1b6();
	thread function_1ecf48ef();
	thread function_4a90c357();
	thread function_ee430caa();
	thread function_a1b52577();
	thread function_18af354a();
	spawner::add_spawn_function_group("water_robots", "targetname", &robot_underwater_callback);
	spawner::add_spawn_function_group("water_robots2", "targetname", &robot_underwater_callback);
	spawner::add_spawn_function_group("water_robots3", "targetname", &robot_underwater_callback);
}

/*
	Name: init_flags
	Namespace: namespace_967f4af8
	Checksum: 0xEB475BAC
	Offset: 0xEE0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function init_flags()
{
	level flag::init("flag_kayne_ready_trap");
	level flag::init("door_explodes");
	level flag::init("flag_door_explodes");
	level flag::init("flag_double_doors_open");
}

/*
	Name: function_60f7b1b6
	Namespace: namespace_967f4af8
	Checksum: 0xB708C701
	Offset: 0xF70
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_60f7b1b6()
{
	level endon(#"hash_ee3f7dc5");
	struct = getent("igc_kane_khalil_1", "targetname");
	level flag::wait_till("flag_kayne_pre_water");
	wait(6);
	struct scene::play("cin_aqu_03_19_pre_water_room_kane", level.kayne);
	struct scene::play("cin_aqu_03_19_pre_water_room_wait_kane", level.kayne);
}

/*
	Name: function_1ecf48ef
	Namespace: namespace_967f4af8
	Checksum: 0x4D807C32
	Offset: 0x1020
	Size: 0x364
	Parameters: 0
	Flags: Linked
*/
function function_1ecf48ef()
{
	level endon(#"hash_47f08523");
	scene::add_scene_func("cin_aqu_05_01_enter_1st_look", &function_3d8a313e, "play");
	scene::init("cin_aqu_05_01_enter_1st_look");
	level waittill(#"hash_7e64f485");
	var_5b5cfed1 = trigger::wait_till("water_room_igc");
	struct = getent("igc_kane_khalil_1", "targetname");
	level notify(#"hash_ee3f7dc5");
	if(isdefined(level.bzm_aquiferdialogue1_7callback))
	{
		level thread [[level.bzm_aquiferdialogue1_7callback]]();
	}
	if(isdefined(level.kayne) && isalive(level.kayne))
	{
		level.kayne delete();
	}
	aquifer_obj::function_b3ed487d(1);
	exploder::exploder_stop("lighting_server_perf_lights");
	function_cd377710();
	struct scene::play("cin_aqu_05_01_enter_1st_look", var_5b5cfed1.who);
	aquifer_obj::function_61034146(0);
	level flag::set("inside_water_room");
	util::teleport_players_igc("igc_enter_water_structs");
	level.kayne aquifer_obj::function_30343b22("kayne_waterroom_swim");
	level.kayne thread function_8fdcc95b(1);
	savegame::checkpoint_save();
	setdvar("player_swimSpeed", 80);
	if(isdefined(level.bzm_aquiferdialogue2callback))
	{
		level thread [[level.bzm_aquiferdialogue2callback]]();
	}
	foreach(p in level.players)
	{
		p thread player_underwater();
	}
	thread function_645f7873();
	thread function_408f0fb5();
	struct scene::play("cin_aqu_03_20_water_room", level.kayne);
	struct thread scene::play("cin_aqu_03_20_water_room_idle", level.kayne);
}

/*
	Name: function_cd377710
	Namespace: namespace_967f4af8
	Checksum: 0x7ACB3CBA
	Offset: 0x1390
	Size: 0x12A
	Parameters: 0
	Flags: Linked
*/
function function_cd377710()
{
	foreach(player in level.activeplayers)
	{
		if(isdefined(player getlinkedent()))
		{
			player.pvtol notify(#"hash_c38e4003");
			player unlink();
			player.pvtol.state = undefined;
			player.pvtol clientfield::set("vtol_canopy_state", 0);
			player.pvtol clientfield::set("vtol_enable_wash_fx", 0);
			wait(0.05);
		}
	}
}

/*
	Name: function_3d8a313e
	Namespace: namespace_967f4af8
	Checksum: 0xD6E906B1
	Offset: 0x14C8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_3d8a313e(a_ents)
{
	aquifer_util::function_c897523d("respawn_in_water_room");
}

/*
	Name: function_4a90c357
	Namespace: namespace_967f4af8
	Checksum: 0x288DB59C
	Offset: 0x14F8
	Size: 0x29C
	Parameters: 0
	Flags: Linked
*/
function function_4a90c357()
{
	level flag::wait_till("flag_kayne_water_moment");
	setdvar("player_swimSpeed", 30);
	level notify(#"hash_47f08523");
	level flag::set("inside_data_center");
	foreach(p in level.activeplayers)
	{
		p clientfield::set_to_player("player_bubbles_fx", 0);
	}
	level thread lui::screen_fade_out(1);
	wait(1);
	level.kayne stopanimscripted();
	setdvar("player_swimSpeed", 150);
	level.kayne clientfield::set("kane_bubbles_fx", 0);
	thread function_3ed240f1();
	var_31b9fd4a = getent("doubledoor_sbm", "targetname");
	var_31b9fd4a hide();
	level thread namespace_71a63eac::function_8210b658();
	level thread scene::play("cin_aqu_02_01_floodroom_1st_dragged", level.kayne);
	level waittill(#"hash_b580186f");
	level notify(#"hash_8f79547f");
	level thread namespace_71a63eac::function_e18f629a();
	util::teleport_players_igc("igc_post_water_structs");
	setdvar("player_swimSpeed", 150);
	thread function_a079b7e3();
	savegame::checkpoint_save();
	thread function_8aec0a4c();
}

/*
	Name: function_8aec0a4c
	Namespace: namespace_967f4af8
	Checksum: 0x9A3ABE90
	Offset: 0x17A0
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function function_8aec0a4c()
{
	level endon(#"hash_66250ae7");
	trig = getent("trig_trap_door", "targetname");
	trig triggerenable(0);
	struct = getent("igc_kane_water", "targetname");
	var_31b9fd4a = getent("doubledoor_sbm", "targetname");
	var_31b9fd4a show();
	struct scene::play("cin_aqu_03_21_server_room_enter", level.kayne);
	struct thread scene::play("cin_aqu_03_21_server_room_idle", level.kayne);
	level flag::set("flag_kayne_ready_trap");
	thread function_cc9a0395();
	trig triggerenable(1);
	level flag::wait_till("flag_maretti_trap_door");
	level notify(#"hash_eb6a1c8b");
	level.kayne scene::stop(1);
	struct thread scene::play("cin_aqu_03_21_server_room_explosion", level.kayne);
	if(isdefined(level.bzm_aquiferdialogue2_1callback))
	{
		level thread [[level.bzm_aquiferdialogue2_1callback]]();
	}
	level.kayne dialog::say("kane_on_me_0");
}

/*
	Name: function_cc9a0395
	Namespace: namespace_967f4af8
	Checksum: 0x3C3E34A5
	Offset: 0x19B8
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_cc9a0395()
{
	level endon(#"hash_eb6a1c8b");
	wait(2);
	level.kayne dialog::say("kane_come_on_get_in_pos_0");
	wait(6);
	level.kayne dialog::say("kane_hurry_it_up_0");
	wait(12);
	level.kayne dialog::say("kane_come_on_get_in_pos_0");
	wait(20);
	level.kayne dialog::say("kane_hurry_it_up_0");
	wait(25);
	level.kayne dialog::say("kane_come_on_get_in_pos_0");
	wait(30);
	level.kayne dialog::say("kane_hurry_it_up_0");
}

/*
	Name: function_c1808198
	Namespace: namespace_967f4af8
	Checksum: 0xF8E3184C
	Offset: 0x1AC0
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function function_c1808198()
{
	foreach(p in level.activeplayers)
	{
		p thread aquifer_util::function_89eaa1b3(1.5);
		p hazard::do_damage("o2", 85);
		p thread function_498a7d66();
	}
}

/*
	Name: function_498a7d66
	Namespace: namespace_967f4af8
	Checksum: 0x45E1FEAB
	Offset: 0x1B98
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_498a7d66()
{
	self endon(#"disconnect");
	self clientfield::set_to_player("player_bubbles_fx", 1);
	wait(2);
	self clientfield::set_to_player("player_bubbles_fx", 0);
}

/*
	Name: function_ee430caa
	Namespace: namespace_967f4af8
	Checksum: 0x6C165947
	Offset: 0x1BF8
	Size: 0x44C
	Parameters: 0
	Flags: Linked
*/
function function_ee430caa()
{
	var_99b9d1f2 = trigger::wait_till("water_room_exit_igc");
	level thread namespace_71a63eac::function_973b77f9();
	level notify(#"hash_9f732141");
	level notify(#"hash_bf1c950c");
	aquifer_util::function_8bf8a765(1);
	level flag::clear("inside_data_center");
	aquifer_obj::function_61034146(1);
	aquifer_obj::function_b3ed487d(0);
	exploder::exploder("lighting_server_perf_lights");
	var_ebc124a5 = spawner::get_ai_group_ai("interior_robots");
	var_19e0145d = spawner::get_ai_group_ai("interior_robots_stairs");
	var_f3dd99f4 = spawner::get_ai_group_ai("interior_robots_water");
	var_a40e8c9b = arraycombine(var_ebc124a5, var_19e0145d, 0, 0);
	var_8a13f363 = arraycombine(var_a40e8c9b, var_f3dd99f4, 0, 0);
	foreach(i in var_8a13f363)
	{
		if(isdefined(i))
		{
			i delete();
		}
	}
	if(isdefined(level.kayne) && isalive(level.kayne))
	{
		level.kayne delete();
	}
	if(isdefined(level.bzm_aquiferdialogue3callback))
	{
		level thread [[level.bzm_aquiferdialogue3callback]]();
	}
	thread function_ddc03444();
	struct = getent("igc_kane_khalil_1", "targetname");
	if(!isdefined(level.activeplayers[0].pvtol))
	{
		level.activeplayers[0] aquifer_util::function_d683f26a(0);
	}
	level.activeplayers[0].pvtol show();
	struct thread scene::play("cin_aqu_03_01_platform_1st_secureplatform_vtol", level.activeplayers[0].pvtol);
	clientfield::set("water_room_exit_scenes", 0);
	struct scene::play("cin_aqu_03_01_platform_1st_secureplatform", var_99b9d1f2.who);
	thread function_430fd872();
	struct scene::play("cin_aqu_03_01_platform_1st_secureplatform_exit");
	level notify(#"hash_2ff2d753");
	struct scene::stop("cin_aqu_03_20_water_room_body_loop", 1);
	savegame::checkpoint_save();
	level flag::set("flag_khalil_water_igc_done");
	struct scene::stop("cin_aqu_03_01_platform_1st_secureplatform");
}

/*
	Name: function_430fd872
	Namespace: namespace_967f4af8
	Checksum: 0x92039143
	Offset: 0x2050
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_430fd872()
{
	level dialog::remote("hend_we_ve_got_additional_0");
	wait(1);
	level dialog::player_say("plyr_copy_that_we_re_on_0");
	wait(4);
	level dialog::player_say("plyr_i_see_em_multiple_0");
	level thread namespace_71a63eac::function_b1ee6c2d();
	wait(1);
	level dialog::player_say("kane_copy_i_see_em_too_0");
}

/*
	Name: function_ddc03444
	Namespace: namespace_967f4af8
	Checksum: 0x47A11F9E
	Offset: 0x20F8
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function function_ddc03444()
{
	var_c0155443 = struct::get("water_room_flyby_1", "targetname");
	var_4e0de508 = struct::get("water_room_flyby_2", "targetname");
	wait(3);
	var_c0155443 scene::play(var_c0155443.scriptbundlename);
	var_c0155443 scene::stop(1);
	wait(8);
	var_4e0de508 scene::play(var_4e0de508.scriptbundlename);
	var_4e0de508 scene::stop(1);
}

/*
	Name: function_a079b7e3
	Namespace: namespace_967f4af8
	Checksum: 0x153A874F
	Offset: 0x21E8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_a079b7e3()
{
	level dialog::remote("khal_something_s_jamming_0", 2);
	level dialog::player_say("plyr_something_doesn_t_fe_0", 3);
	level.kayne dialog::say("kane_yeah_i_got_that_same_0");
	level.kayne dialog::say("kane_up_here_ready_weapo_0", 2);
}

/*
	Name: function_26031755
	Namespace: namespace_967f4af8
	Checksum: 0xA83D5152
	Offset: 0x2280
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function function_26031755()
{
	playfxontag(level._effect["emp_flash"], self, "tag_origin");
}

/*
	Name: emprumbleloop
	Namespace: namespace_967f4af8
	Checksum: 0x8AC5CA08
	Offset: 0x22C0
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function emprumbleloop(duration)
{
	self endon(#"emp_rumble_loop");
	self notify(#"emp_rumble_loop");
	goaltime = gettime() + (duration * 1000);
	while(gettime() < goaltime)
	{
		self playrumbleonentity("damage_heavy");
		wait(0.05);
	}
}

/*
	Name: checktoturnoffemp
	Namespace: namespace_967f4af8
	Checksum: 0x4BA2CB77
	Offset: 0x2338
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function checktoturnoffemp()
{
	if(isdefined(self))
	{
		self.empgrenaded = 0;
		shutdownemprebootindicatormenu();
		self setempjammed(0);
		self clientfield::set_to_player("empd", 0);
	}
}

/*
	Name: shutdownemprebootindicatormenu
	Namespace: namespace_967f4af8
	Checksum: 0xC6ABB6A6
	Offset: 0x23A8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function shutdownemprebootindicatormenu()
{
	emprebootmenu = self getluimenu("EmpRebootIndicator");
	if(isdefined(emprebootmenu))
	{
		self closeluimenu(emprebootmenu);
	}
}

/*
	Name: function_4f725f0b
	Namespace: namespace_967f4af8
	Checksum: 0xDB3EDF2
	Offset: 0x2408
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function function_4f725f0b()
{
	self endon(#"disconnect");
	self enableinvulnerability();
	self.empduration = 7;
	self.empgrenaded = 1;
	self shellshock("emp_shock", 1);
	self clientfield::set_to_player("empd", 1);
	self.empstarttime = gettime();
	self.empendtime = self.empstarttime + (self.empduration * 1000);
	emprebootmenu = self openluimenu("EmpRebootIndicator");
	self setluimenudata(emprebootmenu, "endTime", int(self.empendtime));
	self setluimenudata(emprebootmenu, "startTime", int(self.empstarttime));
	self thread emprumbleloop(0.75);
	self setempjammed(1);
	wait(7);
	if(isdefined(self))
	{
		self notify(#"empgrenadetimedout");
		self checktoturnoffemp();
	}
	self disableinvulnerability();
}

/*
	Name: function_408f0fb5
	Namespace: namespace_967f4af8
	Checksum: 0x7806BD47
	Offset: 0x25D8
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function function_408f0fb5()
{
	level endon(#"hash_47f08523");
	level flag::wait_till("flag_player_start_drown sequence");
	level flag::wait_till("water_corvus_vo_cleared");
	foreach(p in level.activeplayers)
	{
		p thread function_4f725f0b();
	}
	setdvar("player_swimSpeed", 95);
	level notify(#"hash_781a429d");
	level thread cp_mi_cairo_aquifer_sound::function_69386a6b();
	function_846f1215(0.5);
	level thread cp_mi_cairo_aquifer_sound::function_decbd389();
	wait(2);
	setdvar("player_swimSpeed", 80);
	function_846f1215(0.65);
	level thread cp_mi_cairo_aquifer_sound::function_4ce4df2();
	wait(2);
	setdvar("player_swimSpeed", 50);
	function_846f1215(0.8);
	level thread cp_mi_cairo_aquifer_sound::function_2ad0c85b();
	wait(2);
	level flag::set("flag_kayne_water_moment");
}

/*
	Name: function_846f1215
	Namespace: namespace_967f4af8
	Checksum: 0x43A32278
	Offset: 0x27E0
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function function_846f1215(n_alpha)
{
	foreach(p in level.activeplayers)
	{
		p thread function_45676b91(n_alpha);
		p hazard::do_damage("o2", 20);
		p thread function_498a7d66();
	}
}

/*
	Name: function_45676b91
	Namespace: namespace_967f4af8
	Checksum: 0x76BC628F
	Offset: 0x28C0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_45676b91(n_alpha)
{
	self endon(#"disconnect");
	self util::screen_fade_to_alpha(n_alpha, 1);
	self util::screen_fade_to_alpha(0, 1);
}

/*
	Name: function_645f7873
	Namespace: namespace_967f4af8
	Checksum: 0xAB8698AC
	Offset: 0x2918
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function function_645f7873()
{
	level endon(#"hash_47f08523");
	setdvar("player_swimSpeed", 95);
	wait(0.5);
	level thread cp_mi_cairo_aquifer_sound::function_fc716128();
	thread function_c1808198();
	level dialog::remote("corv_listen_only_to_the_s_2", undefined, "corvus");
	wait(0.2);
	level thread cp_mi_cairo_aquifer_sound::function_6e78d063();
	thread function_c1808198();
	level dialog::remote("corv_imagine_yourself_0", undefined, "corvus");
	wait(0.2);
	level thread cp_mi_cairo_aquifer_sound::function_487655fa();
	thread function_c1808198();
	level dialog::remote("corv_in_a_frozen_fore_0", undefined, "corvus");
	level flag::set("water_corvus_vo_cleared");
}

/*
	Name: function_ba41df77
	Namespace: namespace_967f4af8
	Checksum: 0xBAEADA78
	Offset: 0x2A80
	Size: 0x6C
	Parameters: 0
	Flags: None
*/
function function_ba41df77()
{
	thread util::screen_fade_out(0.55, "white");
	wait(0.55);
	util::screen_fade_out(0, "white");
	util::screen_fade_in(0.55, "white");
}

/*
	Name: function_e367262c
	Namespace: namespace_967f4af8
	Checksum: 0x1855A16E
	Offset: 0x2AF8
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function function_e367262c()
{
	self hazard::function_459e5eff("o2", 0);
	self hazard::do_damage("o2", 50);
}

/*
	Name: player_underwater
	Namespace: namespace_967f4af8
	Checksum: 0xF685B4FA
	Offset: 0x2B50
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function player_underwater()
{
	self endon(#"disconnect");
	self notify(#"hash_1fffa65c");
	self endon(#"death");
	self endon(#"hash_1fffa65c");
	while(true)
	{
		if(self.sessionstate == "playing" && isalive(self) && self isplayerunderwater() && (!(isdefined(self.is_underwater) && self.is_underwater)))
		{
			self thread function_41018429();
		}
		wait(0.5);
	}
}

/*
	Name: function_41018429
	Namespace: namespace_967f4af8
	Checksum: 0xEAFC9E38
	Offset: 0x2C10
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function function_41018429()
{
	self notify(#"hash_8f1abd30");
	self endon(#"hash_8f1abd30");
	self endon(#"death");
	self.is_underwater = 1;
	self hazard::function_459e5eff("o2", 0);
	var_dd075cd2 = 1;
	while(self isplayerunderwater())
	{
		wait(1);
		var_dd075cd2 = self hazard::do_damage("o2", 5);
	}
	self hazard::function_459e5eff("o2", 1);
	self.is_underwater = 0;
}

/*
	Name: function_a1923020
	Namespace: namespace_967f4af8
	Checksum: 0x96F756AE
	Offset: 0x2D00
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_a1923020()
{
	level waittill(#"hash_a57da79e");
	level flag::set("flag_door_explodes");
}

/*
	Name: function_a1b52577
	Namespace: namespace_967f4af8
	Checksum: 0x109B04E8
	Offset: 0x2D38
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function function_a1b52577()
{
	thread function_a1923020();
	level flag::wait_till_all(array("flag_maretti_trap_door", "flag_kayne_ready_trap", "flag_door_explodes"));
	exploder::exploder("server_room_boobytrap");
	level thread cp_mi_cairo_aquifer_sound::function_ceaeaa5a();
	trapdoor = getent("mdl_trapdoor", "targetname");
	trapdoor delete();
	level thread function_cb3decf1();
	thread function_a05b1c8c();
	level notify(#"hash_66250ae7");
	wait(2);
	level dialog::remote("khal_kane_do_you_read_me_0");
	level dialog::remote("khal_there_s_multiple_con_0");
	level.kayne dialog::say("kane_taylor_and_maretti_0");
	level thread namespace_71a63eac::function_a2d40521();
	level dialog::remote("khal_kane_you_have_to_go_0");
	thread function_71af9864();
	level flag::set("water_room_checkpoint");
	level.kayne colors::set_force_color("r");
	trigger::use("breadcrumb_exit_water", "targetname");
	savegame::checkpoint_save();
}

/*
	Name: function_71af9864
	Namespace: namespace_967f4af8
	Checksum: 0x85D9812C
	Offset: 0x2F50
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_71af9864()
{
	spawn_manager::enable("spawn_manager_flood_robots");
	spawn_manager::enable("spawn_manager_water_robots");
	spawn_manager::enable("spawn_manager_flood_robots2");
	wait(2);
	struct = getent("igc_kane_water", "targetname");
	struct thread scene::play("cin_aqu_03_21_server_room_doors_open");
	level thread cp_mi_cairo_aquifer_sound::function_ed6114d2();
	var_31b9fd4a = getent("doubledoor_sbm", "targetname");
	var_31b9fd4a delete();
}

/*
	Name: function_b563cc38
	Namespace: namespace_967f4af8
	Checksum: 0xFC1543F5
	Offset: 0x3050
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_b563cc38()
{
	spawner::waittill_ai_group_cleared("interior_robots_stairs");
	level flag::set("flag_kane_start_water_escape");
}

/*
	Name: function_18af354a
	Namespace: namespace_967f4af8
	Checksum: 0x222F3B2E
	Offset: 0x3098
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function function_18af354a()
{
	level flag::wait_till("flag_kane_start_water_escape");
	exploder::exploder("lighting_water_exit");
	foreach(p in level.players)
	{
		p thread player_underwater();
	}
	level.kayne ai::set_ignoreme(1);
	level.kayne thread function_8fdcc95b(5);
	thread function_67c72b6();
}

/*
	Name: function_8fdcc95b
	Namespace: namespace_967f4af8
	Checksum: 0xF6DD97DD
	Offset: 0x31B0
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_8fdcc95b(delay)
{
	if(isdefined(delay))
	{
		wait(delay);
	}
	self fx::play("bubbles", self.origin, (0, 0, 0), "swim_done", 1, "j_spineupper", 1);
}

/*
	Name: function_67c72b6
	Namespace: namespace_967f4af8
	Checksum: 0x7DFC2CEF
	Offset: 0x3218
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_67c72b6()
{
	level endon(#"hash_bf1c950c");
	struct = getent("igc_kane_water", "targetname");
	struct scene::play("cin_aqu_03_22_water_room_escape_start", level.kayne);
	struct thread scene::play("cin_aqu_03_22_water_room_escape_fire_loop", level.kayne);
	spawner::waittill_ai_group_cleared("interior_robots_water");
	level.kayne stopanimscripted();
	struct scene::play("cin_aqu_03_22_water_room_escape_end", level.kayne);
	struct scene::play("cin_aqu_03_22_water_room_escape_end_loop", level.kayne);
}

/*
	Name: function_cb3decf1
	Namespace: namespace_967f4af8
	Checksum: 0x53CED520
	Offset: 0x3328
	Size: 0x1AA
	Parameters: 0
	Flags: Linked
*/
function function_cb3decf1()
{
	var_e9dd177b = getent("trig_trap_door", "targetname");
	t_inner = getent("inner_explosion_area", "targetname");
	foreach(player in level.activeplayers)
	{
		if(player istouching(var_e9dd177b))
		{
			if(player istouching(t_inner))
			{
				player thread function_a476832a(0.5, 4);
				earthquake(0.7, 1.2, player.origin, 1000);
			}
			else
			{
				earthquake(0.6, 1, player.origin, 800);
			}
			player playrumbleonentity("damage_heavy");
		}
	}
}

/*
	Name: function_a476832a
	Namespace: namespace_967f4af8
	Checksum: 0xC597B4AF
	Offset: 0x34E0
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function function_a476832a(delay, duration)
{
	wait(delay);
	self shellshock("proximity_grenade", duration);
}

/*
	Name: function_a05b1c8c
	Namespace: namespace_967f4af8
	Checksum: 0xB679127C
	Offset: 0x3528
	Size: 0x2C2
	Parameters: 0
	Flags: Linked
*/
function function_a05b1c8c()
{
	closest = level.activeplayers[0];
	var_e34a3797 = [];
	kane = getent("look_at_kane_origin", "targetname");
	var_be38fd90 = getent("door_trap_origin", "targetname");
	foreach(player in level.activeplayers)
	{
		if(distance(player.origin, var_be38fd90.origin) < 175)
		{
			array::add(var_e34a3797, player);
		}
	}
	if(var_e34a3797.size < 1)
	{
		foreach(player in level.activeplayers)
		{
			if(distance(player.origin, var_be38fd90.origin) < distance(closest.origin, var_be38fd90.origin))
			{
				closest = player;
			}
		}
		array::add(var_e34a3797, closest);
	}
	foreach(player in var_e34a3797)
	{
		thread function_a0faf694(player, kane, var_be38fd90);
	}
}

/*
	Name: function_a0faf694
	Namespace: namespace_967f4af8
	Checksum: 0xEB54C5DA
	Offset: 0x37F8
	Size: 0x25C
	Parameters: 3
	Flags: Linked
*/
function function_a0faf694(var_4b70f64, kane, var_be38fd90)
{
	rotator = spawn("script_origin", var_4b70f64.origin);
	rotator.angles = var_4b70f64 getplayerangles();
	var_4b70f64 playerlinkto(rotator, undefined, 1, 0, 0, 0, 0);
	player_eye = var_4b70f64 geteye();
	if(distance(var_4b70f64.origin, var_be38fd90.origin) < 175)
	{
		if(var_4b70f64.origin[1] < var_be38fd90.origin[1])
		{
			rotator moveto(rotator.origin + vectorscale((0, 1, 0), 40), 0.3, 0.15, 0.15);
		}
		rotator rotateto(vectortoangles(kane.origin - var_4b70f64.origin), 0.7, 0.3, 0.3);
	}
	else
	{
		rotator rotateto(vectortoangles(kane.origin - player_eye), 0.7, 0.3, 0.3);
	}
	rotator waittill(#"rotatedone");
	var_4b70f64 unlink();
	rotator delete();
}

/*
	Name: robot_underwater_callback
	Namespace: namespace_967f4af8
	Checksum: 0xD0A3853D
	Offset: 0x3A60
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function robot_underwater_callback()
{
	self.script_accuracy = 0.3;
	self.health = 100;
	self.skipdeath = 1;
	self asmsetanimationrate(0.7);
	self clientfield::set("robot_bubbles_fx", 1);
	self waittill(#"death");
	if(isdefined(self))
	{
		self startragdoll();
	}
}

/*
	Name: function_3b4d25aa
	Namespace: namespace_967f4af8
	Checksum: 0x4C4B12B5
	Offset: 0x3B00
	Size: 0x6C
	Parameters: 0
	Flags: None
*/
function function_3b4d25aa()
{
	self ai::set_behavior_attribute("rogue_control_speed", "sprint");
	self ai::set_behavior_attribute("rogue_control", "forced_level_2");
	self ai::set_ignoreme(1);
}

/*
	Name: function_3ed240f1
	Namespace: namespace_967f4af8
	Checksum: 0x8A9E5D29
	Offset: 0x3B78
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_3ed240f1()
{
	level.var_75756ef4 = 0;
	thread function_8492aced();
}

/*
	Name: function_8492aced
	Namespace: namespace_967f4af8
	Checksum: 0x66287DAD
	Offset: 0x3BA8
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_8492aced()
{
	level waittill(#"hash_43565802");
	lui::screen_fade_out(0, "black");
	wait(0.25);
	level waittill(#"hash_f26c95d0");
	lui::screen_fade_in(1, "black");
	level waittill(#"hash_43565802");
	lui::screen_fade_out(0.5, "black");
	level waittill(#"hash_f26c95d0");
	util::screen_fade_out(0, "black");
	level thread util::screen_fade_in(1, "black");
	level waittill(#"hash_43565802");
	lui::screen_fade_out(0.5, "black");
	level waittill(#"hash_f26c95d0");
	util::screen_fade_out(0, "black");
	level thread util::screen_fade_in(1, "black");
}

/*
	Name: fade_from_black
	Namespace: namespace_967f4af8
	Checksum: 0xBBAD9B36
	Offset: 0x3D00
	Size: 0x60
	Parameters: 0
	Flags: None
*/
function fade_from_black()
{
	level endon(#"hash_8f79547f");
	while(true)
	{
		level waittill(#"hash_f26c95d0");
		if(level.var_75756ef4 == 1)
		{
			level.var_75756ef4 = 0;
			thread lui::screen_fade_in(0.5);
		}
	}
}

/*
	Name: fade_to_black
	Namespace: namespace_967f4af8
	Checksum: 0x7A5EC2C1
	Offset: 0x3D68
	Size: 0x60
	Parameters: 0
	Flags: None
*/
function fade_to_black()
{
	level endon(#"hash_8f79547f");
	while(true)
	{
		level waittill(#"hash_43565802");
		if(level.var_75756ef4 == 0)
		{
			level.var_75756ef4 = 1;
			thread lui::screen_fade_out(0.5);
		}
	}
}

