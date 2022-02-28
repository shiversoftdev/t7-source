// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_zurich_newworld;
#using scripts\cp\cp_mi_zurich_newworld_accolades;
#using scripts\cp\cp_mi_zurich_newworld_sound;
#using scripts\cp\cp_mi_zurich_newworld_util;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_gadget_system_overload;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\player_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

#namespace newworld_rooftops;

/*
	Name: skipto_apartment_igc_init
	Namespace: newworld_rooftops
	Checksum: 0x1879FCE8
	Offset: 0x33D0
	Size: 0x1CC
	Parameters: 2
	Flags: Linked
*/
function skipto_apartment_igc_init(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		load::function_a2995f22();
		level thread newworld_util::function_30ec5bf7(1);
	}
	else
	{
		foreach(player in level.players)
		{
			player newworld_util::on_player_loadout();
		}
	}
	newworld_util::player_snow_fx();
	battlechatter::function_d9f49fba(0);
	level.ai_bomber = spawner::simple_spawn_single("chase_bomber", &bomber_spawn_function);
	util::delay(2, undefined, &function_62976d31);
	var_b2afdf94 = getent("nw_apt_breach_decals", "targetname");
	var_b2afdf94 hide();
	apartment_breach();
	skipto::objective_completed(str_objective);
}

/*
	Name: skipto_apartment_igc_done
	Namespace: newworld_rooftops
	Checksum: 0x3EB9A979
	Offset: 0x35A8
	Size: 0x94
	Parameters: 4
	Flags: Linked
*/
function skipto_apartment_igc_done(str_objective, b_starting, b_direct, player)
{
	if(!level flag::exists("chase_done"))
	{
		level flag::init("chase_done");
	}
	level thread namespace_37a1dc33::function_cd261d0b();
	level thread namespace_37a1dc33::function_323baa37();
}

/*
	Name: apartment_breach
	Namespace: newworld_rooftops
	Checksum: 0xA4800FF1
	Offset: 0x3648
	Size: 0x2F0
	Parameters: 0
	Flags: Linked
*/
function apartment_breach()
{
	level scene::init("cin_new_05_01_apartmentbreach_1st_sh010");
	newworld_util::function_83a7d040();
	if(isdefined(level.durango) && level.durango)
	{
		util::streamer_wait(undefined, undefined, 7);
	}
	else
	{
		util::streamer_wait();
	}
	level thread scene::init("p7_fxanim_cp_newworld_chase_door_breach_bundle");
	level thread scene::init("p7_fxanim_cp_newworld_chase_window_break_bundle");
	level thread function_d8ddf1d9();
	level thread function_b444c7bc();
	scene::add_scene_func("cin_new_05_01_apartmentbreach_1st_sh010", &function_985304c3);
	scene::add_scene_func("cin_new_05_01_apartmentbreach_1st_sh010", &function_34fb5ce3, "play");
	scene::add_scene_func("cin_new_05_01_apartmentbreach_3rd_sh020", &function_241c1e7a, "play");
	scene::add_scene_func("cin_new_05_01_apartmentbreach_3rd_sh070", &function_397c0ec9, "play");
	scene::add_scene_func("cin_new_05_01_apartmentbreach_3rd_sh080", &function_8cdb5361, "play");
	scene::add_scene_func("cin_new_05_01_apartmentbreach_3rd_sh100", &function_f28939ed, "play");
	scene::add_scene_func("cin_new_05_01_apartmentbreach_3rd_sh110", &function_617b7548, "play");
	scene::add_scene_func("cin_new_05_01_apartmentbreach_3rd_sh130", &function_98ec301e, "play");
	scene::add_scene_func("cin_new_05_01_apartmentbreach_1st_sh140", &function_6d1ffabf, "done");
	if(isdefined(level.bzm_newworlddialogue5callback))
	{
		level thread [[level.bzm_newworlddialogue5callback]]();
	}
	level scene::play("cin_new_05_01_apartmentbreach_1st_sh010");
	newworld_util::lock_player_controls(0);
	level waittill(#"hash_6d1ffabf");
}

/*
	Name: function_985304c3
	Namespace: newworld_rooftops
	Checksum: 0xD23B29DC
	Offset: 0x3940
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_985304c3(a_ents)
{
	level flag::clear("infinite_white_transition");
	array::thread_all(level.activeplayers, &newworld_util::function_737d2864, &"CP_MI_ZURICH_NEWWORLD_LOCATION_ROOFTOPS", &"CP_MI_ZURICH_NEWWORLD_TIME_ROOFTOPS");
}

/*
	Name: function_d8ddf1d9
	Namespace: newworld_rooftops
	Checksum: 0x2F028E5
	Offset: 0x39B0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_d8ddf1d9()
{
	level.ai_bomber clientfield::set("chase_suspect_fx", 0);
	level waittill(#"hash_fc2a0798");
	level thread scene::play("p7_fxanim_cp_newworld_chase_door_breach_bundle");
}

/*
	Name: function_b444c7bc
	Namespace: newworld_rooftops
	Checksum: 0x5FFB4420
	Offset: 0x3A08
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_b444c7bc()
{
	level waittill(#"hash_d2bb9806");
	level thread scene::play("p7_fxanim_cp_newworld_chase_window_break_bundle");
}

/*
	Name: function_34fb5ce3
	Namespace: newworld_rooftops
	Checksum: 0xE1FBBFFA
	Offset: 0x3A40
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_34fb5ce3(a_ents)
{
	w_ar = getweapon("ar_fastburst");
	a_ents["gunfire01"] thread function_b81a9fbb(w_ar);
	a_ents["gunfire02"] thread function_b81a9fbb(w_ar);
	a_ents["gunfire03"] thread function_b81a9fbb(w_ar);
}

/*
	Name: function_b81a9fbb
	Namespace: newworld_rooftops
	Checksum: 0x65D6855F
	Offset: 0x3AF0
	Size: 0x88
	Parameters: 1
	Flags: Linked
*/
function function_b81a9fbb(var_26fbc878)
{
	level endon(#"hash_d2197033");
	while(true)
	{
		self waittill(#"fire");
		v_end = self.origin + (anglestoforward(self.angles) * 1000);
		magicbullet(var_26fbc878, self.origin, v_end);
	}
}

/*
	Name: function_241c1e7a
	Namespace: newworld_rooftops
	Checksum: 0xF7F5EF2
	Offset: 0x3B80
	Size: 0x1E4
	Parameters: 1
	Flags: Linked
*/
function function_241c1e7a(a_ents)
{
	level notify(#"hash_d2197033");
	a_ents["apartment_igc_robot01"] ai::set_ignoreall(1);
	a_ents["apartment_igc_robot01"] ai::set_ignoreme(1);
	a_ents["apartment_igc_robot02"] ai::set_ignoreall(1);
	a_ents["apartment_igc_robot02"] ai::set_ignoreme(1);
	a_ents["apartment_igc_robot02"] setignorepauseworld(1);
	a_ents["apartment_igc_robot03"] ai::set_ignoreall(1);
	a_ents["apartment_igc_robot03"] ai::set_ignoreme(1);
	a_ents["apartment_igc_robot04"] ai::set_ignoreall(1);
	a_ents["apartment_igc_robot04"] ai::set_ignoreme(1);
	a_ents["apartment_igc_robot04"] setignorepauseworld(1);
	var_b2afdf94 = getent("nw_apt_breach_decals", "targetname");
	var_b2afdf94 show();
}

/*
	Name: function_397c0ec9
	Namespace: newworld_rooftops
	Checksum: 0x77D6BB35
	Offset: 0x3D70
	Size: 0x14C
	Parameters: 1
	Flags: Linked
*/
function function_397c0ec9(a_ents)
{
	a_ents["chase_bomber_ai"] setignorepauseworld(1);
	a_ents["chase_bomber_ai"] waittill(#"freeze");
	var_71a9a72e = spawn("script_origin", (0, 0, 0));
	var_71a9a72e playloopsound("evt_time_freeze_loop", 0.5);
	setpauseworld(1);
	newworld_util::function_85d8906c();
	level waittill(#"hash_e58361f7");
	var_71a9a72e stoploopsound(0.5);
	var_71a9a72e delete();
	setpauseworld(0);
	newworld_util::player_snow_fx();
	level thread scene::play("p7_fxanim_cp_newworld_chase_air_traffic_hunters_01_bundle");
}

/*
	Name: function_8cdb5361
	Namespace: newworld_rooftops
	Checksum: 0x10EB5E26
	Offset: 0x3EC8
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_8cdb5361(a_ents)
{
	ai_taylor = a_ents["taylor"];
	ai_taylor setignorepauseworld(1);
	ai_taylor ghost();
	ai_taylor waittill(#"rez_in");
	ai_taylor thread newworld_util::function_c949a8ed(1);
}

/*
	Name: function_f28939ed
	Namespace: newworld_rooftops
	Checksum: 0xE8A95219
	Offset: 0x3F58
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_f28939ed(a_ents)
{
	ai_hall = a_ents["hall"];
	ai_hall setignorepauseworld(1);
	ai_hall ghost();
	ai_hall waittill(#"rez_in");
	ai_hall show();
}

/*
	Name: function_617b7548
	Namespace: newworld_rooftops
	Checksum: 0x5460DB6B
	Offset: 0x3FE8
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_617b7548(a_ents)
{
	a_ents["apartment_igc_book"] setforcenocull();
	a_ents["apartment_igc_book"] sethighdetail(1);
	a_ents["apartment_igc_book"] setignorepauseworld(1);
}

/*
	Name: function_98ec301e
	Namespace: newworld_rooftops
	Checksum: 0x242BC6F4
	Offset: 0x4070
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_98ec301e(a_ents)
{
	ai_taylor = a_ents["taylor"];
	ai_taylor waittill(#"hash_32fc12d3");
	ai_taylor thread newworld_util::function_4943984c();
}

/*
	Name: function_6d1ffabf
	Namespace: newworld_rooftops
	Checksum: 0x5E8FF492
	Offset: 0x40C8
	Size: 0x1A
	Parameters: 1
	Flags: Linked
*/
function function_6d1ffabf(a_ents)
{
	level notify(#"hash_6d1ffabf");
}

/*
	Name: skipto_chase_init
	Namespace: newworld_rooftops
	Checksum: 0xAB235569
	Offset: 0x40F0
	Size: 0x464
	Parameters: 2
	Flags: Linked
*/
function skipto_chase_init(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		level.ai_bomber = spawner::simple_spawn_single("chase_bomber", &bomber_spawn_function);
		function_f423f05a(str_objective);
		function_62976d31();
		level thread scene::skipto_end("p7_fxanim_cp_newworld_chase_door_breach_bundle");
		level thread scene::skipto_end("p7_fxanim_cp_newworld_chase_window_break_bundle");
		level scene::init("cin_new_06_01_chase_vign_takedown");
		battlechatter::function_d9f49fba(0);
		load::function_a2995f22();
	}
	level thread function_92fdb1da();
	level.var_67e1f60e[0] = &function_3936e284;
	foreach(player in level.players)
	{
		player savegame::set_player_data("b_nw_accolade_11_failed", 0);
		player savegame::set_player_data("b_nw_accolade_12_failed", 0);
		player savegame::set_player_data("b_has_done_chase", 0);
	}
	util::delay(0.6, undefined, &newworld_util::function_3e37f48b, 0);
	callback::on_disconnect(&function_25e57b80);
	function_f423f05a(str_objective);
	trigger::use("chase_hall_start_color", undefined, undefined, 0);
	util::teleport_players_igc(str_objective);
	level thread function_fb28b377("chase_street_traffic_location3");
	level thread function_fb28b377("chase_street_traffic_location4");
	level thread namespace_e38c3c58::function_606b7b8();
	level.ai_hall ai::set_ignoreall(1);
	level.ai_hall ai::set_ignoreme(1);
	level thread function_6a59765b();
	level thread function_59e96bfa(b_starting);
	level thread bomber_chase_path(str_objective);
	level thread rooftops_player_checkpoints();
	level thread function_9c1b6d95();
	level thread function_28aaa11a(30);
	level flag::wait_till("apartment_jump_down");
	level thread function_cd5444f4();
	level flag::wait_till("bridge_collapse_start");
	level thread scene::play("p7_fxanim_cp_newworld_chase_air_traffic_hunters_03_bundle");
	skipto::objective_completed(str_objective);
}

/*
	Name: function_62976d31
	Namespace: newworld_rooftops
	Checksum: 0x8AFDC589
	Offset: 0x4560
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_62976d31()
{
	function_2a977ed8();
	function_22fba3d2();
}

/*
	Name: function_9c1b6d95
	Namespace: newworld_rooftops
	Checksum: 0x306EF137
	Offset: 0x4590
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_9c1b6d95()
{
	trigger::wait_till("start_fxanim_hunter2");
	exploder::exploder_stop("cin_new_05_01_sun_on");
	level thread scene::play("p7_fxanim_cp_newworld_chase_air_traffic_hunters_02_bundle");
}

/*
	Name: bomber_spawn_function
	Namespace: newworld_rooftops
	Checksum: 0xB5B9BB41
	Offset: 0x45F0
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function bomber_spawn_function()
{
	self disableaimassist();
	self ai::set_ignoreme(1);
	self ai::set_ignoreall(1);
	self ai::disable_pain();
	self ai::set_behavior_attribute("sprint", 1);
	self.overrideactordamage = &callback_bomber_damage;
	self.goalradius = 16;
	self.script_objective = "chase_glass_ceiling_igc";
	self.cybercomtargetstatusoverride = 0;
	self.nocybercom = 1;
	self thread bomber_mission_fail_death();
}

/*
	Name: callback_bomber_damage
	Namespace: newworld_rooftops
	Checksum: 0x1AB70624
	Offset: 0x46E0
	Size: 0xD4
	Parameters: 13
	Flags: Linked
*/
function callback_bomber_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname)
{
	if(isplayer(eattacker))
	{
		eattacker thread function_9c291f73();
	}
	else
	{
		idamage = 0;
		return idamage;
	}
	idamage = int(idamage * 0.25);
	return idamage;
}

/*
	Name: bomber_mission_fail_death
	Namespace: newworld_rooftops
	Checksum: 0xE1F5FC11
	Offset: 0x47C0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function bomber_mission_fail_death()
{
	level endon(#"rooftops_terminate");
	self waittill(#"death");
	level notify(#"bomber_killed");
	util::missionfailedwrapper_nodeath(&"CP_MI_ZURICH_NEWWORLD_SUSPECT_KILLED", &"CP_MI_ZURICH_NEWWORLD_SUSPECT_KILLED_HINT");
}

/*
	Name: function_22fba3d2
	Namespace: newworld_rooftops
	Checksum: 0xC1E0D729
	Offset: 0x4818
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_22fba3d2()
{
	level scene::init("p7_fxanim_cp_newworld_bridge_collapse_bundle_init");
	util::wait_network_frame();
}

/*
	Name: hunter_spawn_function
	Namespace: newworld_rooftops
	Checksum: 0x345AC39C
	Offset: 0x4858
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function hunter_spawn_function()
{
	self util::magic_bullet_shield();
	self setteam("allies");
	self ai::set_ignoreme(1);
	self ai::set_ignoreall(1);
}

/*
	Name: function_112af5d1
	Namespace: newworld_rooftops
	Checksum: 0x1A6907A3
	Offset: 0x48D0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_112af5d1()
{
	level.var_79ddcc8b = spawner::simple_spawn_single("chase_hunter", &hunter_spawn_function);
	level scene::init("p7_fxanim_cp_newworld_bridge_collapse_hunter_bundle", array(level.var_79ddcc8b));
}

/*
	Name: function_cd5444f4
	Namespace: newworld_rooftops
	Checksum: 0xDD171B8E
	Offset: 0x4940
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function function_cd5444f4()
{
	spawner::add_spawn_function_group("patio_robot", "script_noteworthy", &patio_robot_adjustments);
	level thread function_480f8035();
	spawn_manager::enable("sm_patio_robots");
	spawn_manager::wait_till_complete("sm_patio_robots");
	var_f49fea10 = spawner::get_ai_group_ai("bar_2nd_floor_robot");
	foreach(ai in var_f49fea10)
	{
		level.ai_hall setignoreent(ai, 1);
	}
	trigger::wait_till("bar_hall_uses_cybercore");
	a_ai_robots = spawner::get_ai_group_ai("bar_1st_floor_robot");
	ai = array::random(a_ai_robots);
	function_e1109a4f(array(ai));
}

/*
	Name: patio_robot_adjustments
	Namespace: newworld_rooftops
	Checksum: 0xF63C43BB
	Offset: 0x4B00
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function patio_robot_adjustments()
{
	self.script_accuracy = 0.1;
	self.health = int(self.health * 0.5);
}

/*
	Name: patio_glass_breaker
	Namespace: newworld_rooftops
	Checksum: 0x71B88473
	Offset: 0x4B50
	Size: 0x74
	Parameters: 0
	Flags: None
*/
function patio_glass_breaker()
{
	level flag::wait_till("apartment_jump_down");
	a_s_glass_break = struct::get_array("patio_glass_break", "targetname");
	array::thread_all(a_s_glass_break, &glass_breaker);
}

/*
	Name: function_92fdb1da
	Namespace: newworld_rooftops
	Checksum: 0x5F11746A
	Offset: 0x4BD0
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function function_92fdb1da()
{
	vh_vtol = vehicle::simple_spawn_single("chase_air_traffic_start");
	vh_vtol thread vehicle::get_on_and_go_path(getvehiclenode(vh_vtol.target, "targetname"));
	var_c49819b1 = vehicle::simple_spawn_single("chase_air_traffic_start2");
	var_c49819b1 thread vehicle::get_on_and_go_path(getvehiclenode(var_c49819b1.target, "targetname"));
	var_9e959f48 = vehicle::simple_spawn_single("chase_air_traffic_start3");
	var_9e959f48 thread vehicle::get_on_and_go_path(getvehiclenode(var_9e959f48.target, "targetname"));
}

/*
	Name: skipto_chase_done
	Namespace: newworld_rooftops
	Checksum: 0x3CB35B85
	Offset: 0x4CE8
	Size: 0x24
	Parameters: 4
	Flags: Linked
*/
function skipto_chase_done(str_objective, b_starting, b_direct, player)
{
}

/*
	Name: function_9a9ab34a
	Namespace: newworld_rooftops
	Checksum: 0x5786501A
	Offset: 0x4D18
	Size: 0x168
	Parameters: 0
	Flags: Linked
*/
function function_9a9ab34a()
{
	self endon(#"death");
	self endon(#"hash_34427886");
	if(isdefined(30))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(30, "timeout");
	}
	self flag::init("sprint_tutorial");
	self thread function_778a3080();
	while(!self flag::get("sprint_tutorial"))
	{
		self thread util::show_hint_text(&"CP_MI_ZURICH_NEWWORLD_SPRINT_TUTORIAL", 0, undefined, 4);
		self flag::wait_till_timeout(4, "sprint_tutorial");
		self thread util::hide_hint_text(1);
		if(!self flag::get("sprint_tutorial"))
		{
			self flag::wait_till_timeout(3, "sprint_tutorial");
		}
	}
}

/*
	Name: function_778a3080
	Namespace: newworld_rooftops
	Checksum: 0x8048EC8D
	Offset: 0x4E88
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_778a3080()
{
	self endon(#"death");
	if(isdefined(30))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(30, "timeout");
	}
	while(true)
	{
		if(self issprinting())
		{
			break;
		}
		wait(0.1);
	}
	self flag::set("sprint_tutorial");
}

/*
	Name: function_144ffd5
	Namespace: newworld_rooftops
	Checksum: 0x886C13EA
	Offset: 0x4F48
	Size: 0x168
	Parameters: 0
	Flags: None
*/
function function_144ffd5()
{
	self endon(#"death");
	self endon(#"hash_34427886");
	if(isdefined(30))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(30, "timeout");
	}
	self flag::init("slide_tutorial");
	self thread function_5bef9ce1();
	while(!self flag::get("slide_tutorial"))
	{
		self thread util::show_hint_text(&"CP_MI_ZURICH_NEWWORLD_SLIDE_TUTORIAL", 0, undefined, 4);
		self flag::wait_till_timeout(4, "slide_tutorial");
		self thread util::hide_hint_text(1);
		if(!self flag::get("slide_tutorial"))
		{
			self flag::wait_till_timeout(3, "slide_tutorial");
		}
	}
}

/*
	Name: function_5bef9ce1
	Namespace: newworld_rooftops
	Checksum: 0x6A293273
	Offset: 0x50B8
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_5bef9ce1()
{
	self endon(#"death");
	if(isdefined(30))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(30, "timeout");
	}
	while(true)
	{
		if(self issliding())
		{
			break;
		}
		wait(0.1);
	}
	self flag::set("slide_tutorial");
}

/*
	Name: function_2a977ed8
	Namespace: newworld_rooftops
	Checksum: 0xCD18B3E7
	Offset: 0x5178
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function function_2a977ed8()
{
	function_18a473c0();
	scene::add_scene_func("cin_new_06_01_chase_vign_railing_civs_var01", &function_1efc629f, "done");
	scene::add_scene_func("cin_new_06_01_chase_vign_train_civs_var2", &function_1efc629f, "done");
	util::wait_network_frame();
	function_b497a9d3();
	util::wait_network_frame();
	function_42903a98();
	util::wait_network_frame();
	function_6892b501();
	util::wait_network_frame();
	function_8926ae16();
	util::wait_network_frame();
	function_ad5b66cd();
	util::wait_network_frame();
	function_1e8b5e92();
	util::wait_network_frame();
	function_14c4a966();
	util::wait_network_frame();
	function_6a341ec9();
	util::wait_network_frame();
}

/*
	Name: function_18a473c0
	Namespace: newworld_rooftops
	Checksum: 0x589A6462
	Offset: 0x5308
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function function_18a473c0()
{
	var_e8942d17 = spawner::simple_spawn_single("chase_bartender_civilian");
	var_e8942d17.var_a0f70d54 = level.ai_bomber;
	var_a61dbbf1 = spawner::simple_spawn_single("chase_bar_civ_1");
	var_a61dbbf1.var_a0f70d54 = level.ai_bomber;
	var_cc20365a = spawner::simple_spawn_single("chase_bar_civ_2");
	var_cc20365a.var_a0f70d54 = level.ai_bomber;
	var_f222b0c3 = spawner::simple_spawn_single("chase_bar_civ_3");
	var_f222b0c3.var_a0f70d54 = level.ai_bomber;
	a_ai = array(var_a61dbbf1, var_cc20365a, var_f222b0c3);
	scene::add_scene_func("cin_new_06_01_chase_vign_bar_civs", &function_e2b3f312, "done");
	level thread scene::init("cin_new_06_01_chase_vign_cower", array(var_e8942d17));
	level thread scene::init("cin_new_06_01_chase_vign_bar_civs", a_ai);
	level thread function_5f1afc64();
}

/*
	Name: function_5f1afc64
	Namespace: newworld_rooftops
	Checksum: 0xC4223C4E
	Offset: 0x54C0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_5f1afc64()
{
	trigger::wait_for_either("bartender_look_trigger", "bartender_touch_trigger");
	level thread scene::play("cin_new_06_01_chase_vign_cower");
	level thread scene::play("cin_new_06_01_chase_vign_bar_civs");
}

/*
	Name: function_e2b3f312
	Namespace: newworld_rooftops
	Checksum: 0x11B84360
	Offset: 0x5530
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function function_e2b3f312(a_ents)
{
	wait(0.05);
	nd_exit = getnode("chase_bar_upper_exit_near", "script_noteworthy");
	foreach(ai_civ in a_ents)
	{
		if(isalive(ai_civ))
		{
			ai_civ thread newworld::function_3840d81a(nd_exit);
		}
	}
}

/*
	Name: function_b497a9d3
	Namespace: newworld_rooftops
	Checksum: 0xD4D17C9E
	Offset: 0x5620
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_b497a9d3()
{
	var_a61dbbf1 = spawner::simple_spawn_single("chase_bar_railing_civ_1");
	var_a61dbbf1.var_a0f70d54 = level.ai_bomber;
	var_cc20365a = spawner::simple_spawn_single("chase_bar_railing_civ_2");
	var_cc20365a.var_a0f70d54 = level.ai_bomber;
	a_ai = array(var_a61dbbf1, var_cc20365a);
	s_scene = struct::get("bar_railing_01", "targetname");
	s_scene thread scene::init(a_ai);
	s_scene thread function_d66e3365();
}

/*
	Name: function_d66e3365
	Namespace: newworld_rooftops
	Checksum: 0xB7D4E859
	Offset: 0x5728
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_d66e3365()
{
	level waittill(#"hash_991e4316");
	self thread scene::play();
}

/*
	Name: function_42903a98
	Namespace: newworld_rooftops
	Checksum: 0x8B23F338
	Offset: 0x5758
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_42903a98()
{
	var_a61dbbf1 = spawner::simple_spawn_single("chase_bar_railing_civ_3");
	var_cc20365a = spawner::simple_spawn_single("chase_bar_railing_civ_4");
	a_ai = array(var_a61dbbf1, var_cc20365a);
	s_scene = struct::get("bar_railing_02", "targetname");
	s_scene thread scene::init(a_ai);
	s_scene thread function_d0a73a33(a_ai);
}

/*
	Name: function_d0a73a33
	Namespace: newworld_rooftops
	Checksum: 0x5F176543
	Offset: 0x5840
	Size: 0xFE
	Parameters: 1
	Flags: Linked
*/
function function_d0a73a33(a_ai)
{
	level waittill(#"hash_287cc85e");
	self scene::play();
	foreach(ai in a_ai)
	{
		wait(randomfloatrange(1, 2));
		if(isalive(ai))
		{
			ai dodamage(1, ai.origin);
			break;
		}
	}
}

/*
	Name: function_6892b501
	Namespace: newworld_rooftops
	Checksum: 0x1FF84146
	Offset: 0x5948
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_6892b501()
{
	var_a61dbbf1 = spawner::simple_spawn_single("chase_bar_railing_civ_5");
	var_cc20365a = spawner::simple_spawn_single("chase_bar_railing_civ_6");
	a_ai = array(var_a61dbbf1, var_cc20365a);
	s_scene = struct::get("bar_railing_03", "targetname");
	s_scene thread scene::init(a_ai);
	s_scene thread function_aaa4bfca(a_ai);
}

/*
	Name: function_aaa4bfca
	Namespace: newworld_rooftops
	Checksum: 0x79D86256
	Offset: 0x5A30
	Size: 0x106
	Parameters: 1
	Flags: Linked
*/
function function_aaa4bfca(a_ai)
{
	level waittill(#"hash_287cc85e");
	wait(0.1);
	self scene::play();
	foreach(ai in a_ai)
	{
		wait(randomfloatrange(0.5, 1));
		if(isalive(ai))
		{
			ai dodamage(1, ai.origin);
			break;
		}
	}
}

/*
	Name: function_1efc629f
	Namespace: newworld_rooftops
	Checksum: 0x305070A6
	Offset: 0x5B40
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function function_1efc629f(a_ents)
{
	wait(0.05);
	nd_exit = getnode(self.target, "targetname");
	foreach(ai_civ in a_ents)
	{
		if(isdefined(ai_civ))
		{
			ai_civ thread newworld::function_3840d81a(nd_exit);
		}
	}
}

/*
	Name: function_8926ae16
	Namespace: newworld_rooftops
	Checksum: 0xBF0BE794
	Offset: 0x5C20
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_8926ae16()
{
	var_a61dbbf1 = spawner::simple_spawn_single("chase_bar_group_civ_1");
	var_cc20365a = spawner::simple_spawn_single("chase_bar_group_civ_2");
	var_f222b0c3 = spawner::simple_spawn_single("chase_bar_group_civ_3");
	var_18252b2c = spawner::simple_spawn_single("chase_bar_group_civ_4");
	a_ai = array(var_a61dbbf1, var_cc20365a, var_f222b0c3, var_18252b2c);
	s_scene = struct::get("chase_bar_group_civs_1", "targetname");
	s_scene thread scene::init(a_ai);
	s_scene thread function_3fc15555();
}

/*
	Name: function_3fc15555
	Namespace: newworld_rooftops
	Checksum: 0x82CCF966
	Offset: 0x5D60
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_3fc15555()
{
	level waittill(#"hash_991e4316");
	self thread scene::play();
}

/*
	Name: function_ad5b66cd
	Namespace: newworld_rooftops
	Checksum: 0x4B8A0953
	Offset: 0x5D90
	Size: 0x204
	Parameters: 0
	Flags: Linked
*/
function function_ad5b66cd()
{
	scene::add_scene_func("cin_new_06_01_chase_vign_bar_stand_civs_var1", &function_d8cfb628, "done");
	scene::add_scene_func("cin_new_06_01_chase_vign_bar_stand_civs_var2", &function_4ad72563, "done");
	var_a61dbbf1 = spawner::simple_spawn_single("chase_mid_bar_1");
	var_cc20365a = spawner::simple_spawn_single("chase_mid_bar_2");
	var_2c5d8c08 = array(var_a61dbbf1, var_cc20365a);
	var_6396997e = struct::get("mid_bar_scene_1", "targetname");
	var_6396997e thread scene::init(var_2c5d8c08);
	var_f222b0c3 = spawner::simple_spawn_single("chase_mid_bar_3");
	var_18252b2c = spawner::simple_spawn_single("chase_mid_bar_4");
	var_9e64fb43 = array(var_f222b0c3, var_18252b2c);
	var_3d941f15 = struct::get("mid_bar_scene_2", "targetname");
	var_3d941f15 thread scene::init(var_9e64fb43);
	level thread function_ffd8ef40(var_6396997e, var_3d941f15);
}

/*
	Name: function_ffd8ef40
	Namespace: newworld_rooftops
	Checksum: 0xBD33E7FE
	Offset: 0x5FA0
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function function_ffd8ef40(var_6396997e, var_3d941f15)
{
	level waittill(#"hash_66de346");
	var_6396997e thread scene::play();
	wait(0.1);
	var_3d941f15 thread scene::play();
}

/*
	Name: function_1e8b5e92
	Namespace: newworld_rooftops
	Checksum: 0xE74C91A1
	Offset: 0x6000
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_1e8b5e92()
{
	var_a61dbbf1 = spawner::simple_spawn_single("chase_mid_bar_sitting01_civ1");
	var_cc20365a = spawner::simple_spawn_single("chase_mid_bar_sitting01_civ2");
	var_2c5d8c08 = array(var_a61dbbf1, var_cc20365a);
	var_6396997e = struct::get("chase_mid_bar_sitting01", "targetname");
	var_6396997e thread scene::init(var_2c5d8c08);
	var_f222b0c3 = spawner::simple_spawn_single("chase_mid_bar_sitting02_civ1");
	var_18252b2c = spawner::simple_spawn_single("chase_mid_bar_sitting02_civ2");
	var_9e64fb43 = array(var_f222b0c3, var_18252b2c);
	var_3d941f15 = struct::get("chase_mid_bar_sitting02", "targetname");
	var_3d941f15 thread scene::init(var_9e64fb43);
	level thread function_dc8a6a3(var_6396997e, var_3d941f15);
}

/*
	Name: function_dc8a6a3
	Namespace: newworld_rooftops
	Checksum: 0x691B78B2
	Offset: 0x61B0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function function_dc8a6a3(var_6396997e, var_3d941f15)
{
	level waittill(#"hash_66de346");
	wait(0.25);
	var_6396997e thread scene::play();
	wait(0.1);
	var_3d941f15 thread scene::play();
}

/*
	Name: function_d8cfb628
	Namespace: newworld_rooftops
	Checksum: 0x6BEA4214
	Offset: 0x6218
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function function_d8cfb628(a_ents)
{
	wait(0.05);
	nd_exit = getnode(self.target, "targetname");
	foreach(ai_civ in a_ents)
	{
		if(isdefined(ai_civ))
		{
			ai_civ thread newworld::function_3840d81a(nd_exit);
		}
	}
}

/*
	Name: function_4ad72563
	Namespace: newworld_rooftops
	Checksum: 0xA2081B46
	Offset: 0x62F8
	Size: 0x14A
	Parameters: 1
	Flags: Linked
*/
function function_4ad72563(a_ents)
{
	wait(0.05);
	var_792430f = getnode("chase_bar_near_exit", "script_noteworthy");
	var_958ad3d4 = getnode("mid_bar_exit_point", "script_noteworthy");
	foreach(ai_civ in a_ents)
	{
		if(isdefined(ai_civ))
		{
			if(issubstr(ai_civ.classname, "female"))
			{
				ai_civ thread newworld::function_3840d81a(var_792430f);
				continue;
			}
			ai_civ thread newworld::function_3840d81a(var_958ad3d4);
		}
	}
}

/*
	Name: function_14c4a966
	Namespace: newworld_rooftops
	Checksum: 0xB301A190
	Offset: 0x6450
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function function_14c4a966()
{
	var_a61dbbf1 = spawner::simple_spawn_single("chase_bar__end_group_civ_1");
	var_cc20365a = spawner::simple_spawn_single("chase_bar__end_group_civ_2");
	var_f222b0c3 = spawner::simple_spawn_single("chase_bar__end_group_civ_3");
	var_18252b2c = spawner::simple_spawn_single("chase_bar__end_group_civ_4");
	a_ai = array(var_a61dbbf1, var_cc20365a, var_f222b0c3, var_18252b2c);
	foreach(ai in a_ai)
	{
		ai thread function_6bc2fd9b();
	}
	s_scene = struct::get("chase_bar_end_group_civs", "targetname");
	s_scene thread scene::init(a_ai);
	s_scene thread function_ce90e373();
}

/*
	Name: function_ce90e373
	Namespace: newworld_rooftops
	Checksum: 0x17080DD0
	Offset: 0x6610
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_ce90e373()
{
	level util::waittill_any("bridge_collapse_start", "bar_end_civs_alerted");
	self thread scene::play();
}

/*
	Name: function_6a341ec9
	Namespace: newworld_rooftops
	Checksum: 0x1B12E190
	Offset: 0x6660
	Size: 0x55C
	Parameters: 0
	Flags: Linked
*/
function function_6a341ec9()
{
	scene::add_scene_func("cin_new_06_01_chase_vign_sitting_civs_right", &function_1efc629f, "done");
	scene::add_scene_func("cin_new_06_01_chase_vign_sitting_civs_left", &function_1efc629f, "done");
	var_a61dbbf1 = spawner::simple_spawn_single("chase_bar_sitting01_civ1");
	var_cc20365a = spawner::simple_spawn_single("chase_bar_sitting01_civ2");
	var_2c5d8c08 = array(var_a61dbbf1, var_cc20365a);
	foreach(ai in var_2c5d8c08)
	{
		ai thread function_6bc2fd9b();
	}
	var_6396997e = struct::get("chase_bar_sitting01", "targetname");
	var_6396997e thread scene::init(var_2c5d8c08);
	wait(0.1);
	var_a61dbbf1 = spawner::simple_spawn_single("chase_bar_sitting02_civ1");
	var_cc20365a = spawner::simple_spawn_single("chase_bar_sitting02_civ2");
	var_9e64fb43 = array(var_a61dbbf1, var_cc20365a);
	foreach(ai in var_9e64fb43)
	{
		ai thread function_6bc2fd9b();
	}
	var_3d941f15 = struct::get("chase_bar_sitting02", "targetname");
	var_3d941f15 thread scene::init(var_9e64fb43);
	wait(0.1);
	var_a61dbbf1 = spawner::simple_spawn_single("chase_bar_sitting03_civ1");
	var_cc20365a = spawner::simple_spawn_single("chase_bar_sitting03_civ2");
	var_786280da = array(var_a61dbbf1, var_cc20365a);
	foreach(ai in var_786280da)
	{
		ai thread function_6bc2fd9b();
	}
	var_1791a4ac = struct::get("chase_bar_sitting03", "targetname");
	var_1791a4ac thread scene::init(var_786280da);
	wait(0.1);
	var_a61dbbf1 = spawner::simple_spawn_single("chase_bar_sitting04_civ1");
	var_cc20365a = spawner::simple_spawn_single("chase_bar_sitting04_civ2");
	var_ea69f015 = array(var_a61dbbf1, var_cc20365a);
	foreach(ai in var_ea69f015)
	{
		ai thread function_6bc2fd9b();
	}
	var_f18f2a43 = struct::get("chase_bar_sitting04", "targetname");
	var_f18f2a43 thread scene::init(var_ea69f015);
	level thread function_790d18d8(var_6396997e, var_3d941f15, var_1791a4ac, var_f18f2a43);
}

/*
	Name: function_790d18d8
	Namespace: newworld_rooftops
	Checksum: 0xA2A3D8F
	Offset: 0x6BC8
	Size: 0xC4
	Parameters: 4
	Flags: Linked
*/
function function_790d18d8(var_6396997e, var_3d941f15, var_1791a4ac, var_f18f2a43)
{
	level util::waittill_any("bridge_collapse_start", "bar_end_civs_alerted");
	var_6396997e thread scene::play();
	wait(0.1);
	var_3d941f15 thread scene::play();
	wait(0.1);
	var_1791a4ac thread scene::play();
	wait(0.1);
	var_f18f2a43 thread scene::play();
}

/*
	Name: function_6bc2fd9b
	Namespace: newworld_rooftops
	Checksum: 0x4C27DBAC
	Offset: 0x6C98
	Size: 0x52
	Parameters: 0
	Flags: Linked
*/
function function_6bc2fd9b()
{
	level endon(#"hash_9f036d3d");
	level endon(#"hash_9988f9e0");
	self util::waittill_any("bulletwhizby", "damage", "death");
	level notify(#"hash_9988f9e0");
}

/*
	Name: skipto_bridge_collapse_igc_init
	Namespace: newworld_rooftops
	Checksum: 0x886E8CF7
	Offset: 0x6CF8
	Size: 0x1F4
	Parameters: 2
	Flags: Linked
*/
function skipto_bridge_collapse_igc_init(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		exploder::exploder_stop("cin_new_05_01_sun_on");
		level.ai_bomber = spawner::simple_spawn_single("chase_bomber", &bomber_spawn_function);
		function_f423f05a(str_objective);
		level.var_79ddcc8b = spawner::simple_spawn_single("chase_hunter", &hunter_spawn_function);
		level thread scene::init("p7_fxanim_cp_newworld_bridge_collapse_bundle_init");
		level thread scene::skipto_end("p7_fxanim_cp_newworld_bridge_collapse_hunter_bundle", array(level.var_79ddcc8b), 0.85);
		load::function_a2995f22();
		newworld_util::function_3e37f48b(0);
		level thread bomber_chase_path(str_objective);
		level thread rooftops_player_checkpoints();
		level thread function_28aaa11a(30);
		callback::on_disconnect(&function_25e57b80);
	}
	level thread hall_bridge_dropdown(0);
	level thread function_82467236();
	level waittill(#"bridge_collapse_igc_done");
	skipto::objective_completed(str_objective);
}

/*
	Name: skipto_bridge_collapse_igc_done
	Namespace: newworld_rooftops
	Checksum: 0x54481D47
	Offset: 0x6EF8
	Size: 0x74
	Parameters: 4
	Flags: Linked
*/
function skipto_bridge_collapse_igc_done(str_objective, b_starting, b_direct, player)
{
	e_clip = getent("bridge_collapse_player_clip", "targetname");
	if(isdefined(e_clip))
	{
		e_clip delete();
	}
}

/*
	Name: function_2c789839
	Namespace: newworld_rooftops
	Checksum: 0xBB789DD1
	Offset: 0x6F78
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function function_2c789839()
{
	scene::add_scene_func("p7_fxanim_cp_newworld_bridge_collapse_bundle", &function_1637aac6, "play");
	scene::add_scene_func("p7_fxanim_cp_newworld_bridge_collapse_bundle", &function_28e6c236, "play");
	level waittill(#"hash_511ddebd");
	level scene::play("p7_fxanim_cp_newworld_bridge_collapse_bundle", array(level.var_79ddcc8b));
	level notify(#"bridge_collapse_igc_done");
}

/*
	Name: function_1637aac6
	Namespace: newworld_rooftops
	Checksum: 0x3BCC60EC
	Offset: 0x7038
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function function_1637aac6(a_ents)
{
	foreach(index, ent in a_ents)
	{
		if(issubstr(index, "wasp"))
		{
			ent thread function_cba88b2();
		}
	}
}

/*
	Name: function_cba88b2
	Namespace: newworld_rooftops
	Checksum: 0x2A0E1F1B
	Offset: 0x70F8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_cba88b2()
{
	self endon(#"death");
	self waittill(#"hash_1637aac6");
	self ghost();
	wait(1);
	self delete();
}

/*
	Name: function_28e6c236
	Namespace: newworld_rooftops
	Checksum: 0xA9A40C84
	Offset: 0x7150
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_28e6c236(a_ents)
{
	level waittill(#"hash_741a928d");
	radiusdamage(a_ents["newworld_bridge_collapse_hunter"].origin, 850, 300, 20, level.ai_bomber, "MOD_EXPLOSIVE");
	e_clip = getent("bridge_collapse_player_clip", "targetname");
	if(isdefined(e_clip))
	{
		e_clip delete();
	}
}

/*
	Name: hall_bridge_dropdown
	Namespace: newworld_rooftops
	Checksum: 0xF7A695EB
	Offset: 0x7208
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function hall_bridge_dropdown(b_no_wait)
{
	level endon(#"hall_train_station_wallrun");
	if(!b_no_wait)
	{
		trigger::wait_till("sarah_bridge_dropdown", undefined, undefined, 0);
	}
	scene::play("cin_new_07_01_bridge_collapse_traverse");
	var_9885044c = getnode("hall_post_bridge_goto", "targetname");
	level.ai_hall setgoal(var_9885044c, 1);
	level thread function_4d159c1c();
}

/*
	Name: function_4d159c1c
	Namespace: newworld_rooftops
	Checksum: 0xFC8D0319
	Offset: 0x72D0
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_4d159c1c()
{
	level flag::wait_till("hall_post_bridge_climb_scene");
	if(isdefined(level.bzm_newworlddialogue6callback))
	{
		level thread [[level.bzm_newworlddialogue6callback]]();
	}
	scene::play("cin_new_06_01_chase_vign_hall_traversal_bridge");
	if(!level flag::get("chase_post_bridge_climb_up"))
	{
		trigger::use("hall_post_traversal_bridge_colors");
	}
}

/*
	Name: function_a507aa05
	Namespace: newworld_rooftops
	Checksum: 0x3CB5A892
	Offset: 0x7370
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_a507aa05(a_ai_robots)
{
	level flag::wait_till("hall_use_systemoverload_post_bridge_collapse");
	function_e1109a4f(a_ai_robots);
}

/*
	Name: function_82467236
	Namespace: newworld_rooftops
	Checksum: 0x34076C39
	Offset: 0x73C0
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function function_82467236()
{
	foreach(player in level.activeplayers)
	{
		player thread function_10f68f8b();
	}
}

/*
	Name: function_10f68f8b
	Namespace: newworld_rooftops
	Checksum: 0x8939DD3B
	Offset: 0x7458
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_10f68f8b()
{
	self endon(#"death");
	level endon(#"rooftops_terminate");
	trigger::wait_till("bridge_collapse_drop_down", "targetname", self);
	self enableinvulnerability();
	wait(2);
	self disableinvulnerability();
}

/*
	Name: skipto_rooftops_init
	Namespace: newworld_rooftops
	Checksum: 0x4C9DD50C
	Offset: 0x74D8
	Size: 0x38C
	Parameters: 2
	Flags: Linked
*/
function skipto_rooftops_init(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		exploder::exploder_stop("cin_new_05_01_sun_on");
		level.ai_bomber = spawner::simple_spawn_single("chase_bomber", &bomber_spawn_function);
		function_f423f05a(str_objective);
		array::run_all(getentarray("collapse_bridge", "targetname"), &delete);
		load::function_a2995f22();
		newworld_util::function_3e37f48b(0);
		level thread hall_bridge_dropdown(1);
		level thread function_82467236();
		level thread bomber_chase_path(str_objective);
		level thread rooftops_player_checkpoints();
		level thread function_c2c5155b();
		level thread function_28aaa11a(30);
		callback::on_disconnect(&function_25e57b80);
	}
	else
	{
		newworld_util::function_c1c980d8("chase_bar_enemy_culling");
	}
	vehicle::add_spawn_function("chase_wasp_mg", &function_694c9886);
	vehicle::add_spawn_function("chase_wasp_rocket", &function_694c9886);
	function_660e6b31(1);
	level thread function_2ac6fe38();
	level thread function_59153fc0();
	level thread function_34427886();
	level flag::init("train_station_start_gate_closed");
	level flag::init("train_station_end_gate_closed");
	level flag::init("chase_train_move");
	level thread function_4cd03714("trigger_chase_trains", "train_station_train_org", "train_station_train_start", "train_station_stop_train", "chase_trainstation_train_rumble", 0, 1, 1);
	rooftops();
	function_e8d2d7d8(1);
	function_e8d2d7d8(2);
	function_e8d2d7d8(3);
	function_8c82b44d(1);
}

/*
	Name: skipto_rooftops_done
	Namespace: newworld_rooftops
	Checksum: 0x127EB4A
	Offset: 0x7870
	Size: 0x24
	Parameters: 4
	Flags: Linked
*/
function skipto_rooftops_done(str_objective, b_starting, b_direct, player)
{
}

/*
	Name: hall_train_station_wallrun
	Namespace: newworld_rooftops
	Checksum: 0x183A6D4F
	Offset: 0x78A0
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function hall_train_station_wallrun()
{
	trigger::wait_till("hall_train_station_wallrun");
	level.ai_hall newworld_util::function_d0aa2f4f();
	level thread scene::play("cin_new_06_02_chase_vign_wallrun");
	level notify(#"hall_train_station_wallrun");
	trigger::use("hall_post_train_station_wallrun_color_trigger", "targetname");
	level thread function_33cb6df1();
}

/*
	Name: function_59153fc0
	Namespace: newworld_rooftops
	Checksum: 0x9955D27F
	Offset: 0x7948
	Size: 0x182
	Parameters: 0
	Flags: Linked
*/
function function_59153fc0()
{
	level waittill(#"hash_fb8f6850");
	level notify(#"hash_210f1e22");
	newworld_util::function_3e37f48b(1);
	level.var_ebe3b234 = 1;
	foreach(player in level.players)
	{
		if(player newworld_util::function_c633d8fe())
		{
			continue;
		}
		player cybercom_gadget::takeallabilities();
		player cybercom_gadget::giveability("cybercom_systemoverload", 0);
		player cybercom_gadget::equipability("cybercom_systemoverload", 1);
		player thread newworld_util::function_6062e90("cybercom_systemoverload", 0, "stop_systemoverload_tutorial", 1, "CP_MI_ZURICH_NEWWORLD_SYSTEM_PARALYSIS_TARGET", "CP_MI_ZURICH_NEWWORLD_SYSTEM_PARALYSIS_RELEASE");
		player thread function_a69280be("cybercom_systemoverload", 0);
	}
}

/*
	Name: function_34427886
	Namespace: newworld_rooftops
	Checksum: 0xFBE329AC
	Offset: 0x7AD8
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function function_34427886()
{
	foreach(player in level.activeplayers)
	{
		if(player newworld_util::function_c633d8fe())
		{
			continue;
		}
		player thread function_3a5a4e5e();
	}
}

/*
	Name: function_3a5a4e5e
	Namespace: newworld_rooftops
	Checksum: 0xA573D8CD
	Offset: 0x7B90
	Size: 0x198
	Parameters: 0
	Flags: Linked
*/
function function_3a5a4e5e()
{
	self endon(#"death");
	level endon(#"hash_210f1e22");
	trigger::wait_till("high_mantle_tutorial", "targetname", self);
	self notify(#"hash_34427886");
	if(isdefined(30))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(30, "timeout");
	}
	self flag::init("high_mantle_tutorial");
	self thread function_87127ac4();
	while(!self flag::get("high_mantle_tutorial"))
	{
		self thread util::show_hint_text(&"CP_MI_ZURICH_NEWWORLD_MANTLE_TUTORIAL", 0, undefined, 4);
		self flag::wait_till_timeout(4, "high_mantle_tutorial");
		self thread util::hide_hint_text(1);
		if(!self flag::get("high_mantle_tutorial"))
		{
			self flag::wait_till_timeout(3, "high_mantle_tutorial");
		}
	}
}

/*
	Name: function_87127ac4
	Namespace: newworld_rooftops
	Checksum: 0x85D362B3
	Offset: 0x7D30
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_87127ac4()
{
	self endon(#"death");
	self waittill(#"mantle_start");
	self flag::set("high_mantle_tutorial");
}

/*
	Name: function_33cb6df1
	Namespace: newworld_rooftops
	Checksum: 0xF092D56B
	Offset: 0x7D78
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_33cb6df1()
{
	level endon(#"hash_de039dbd");
	trigger::wait_till("hall_old_zurich_traversal");
	level thread scene::play("cin_new_06_01_chase_vign_hall_traversal_train");
	level thread function_83d6701();
}

/*
	Name: rooftops
	Namespace: newworld_rooftops
	Checksum: 0x71270679
	Offset: 0x7DE0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function rooftops()
{
	spawner::add_spawn_function_group("train_station_cafe_civs", "targetname", &function_97ed9674);
	level thread function_be23c07c();
	level thread hall_train_station_wallrun();
	function_64c3236();
}

/*
	Name: function_64c3236
	Namespace: newworld_rooftops
	Checksum: 0x17C9F35B
	Offset: 0x7E60
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_64c3236()
{
	scene::add_scene_func("cin_new_06_01_chase_vign_train_civs", &function_c9f8e2cd, "play");
	scene::remove_scene_func("cin_new_06_01_chase_vign_train_civs_var2", &function_1efc629f, "done");
	scene::add_scene_func("cin_new_06_01_chase_vign_train_civs_var2", &function_c9f8e2cd, "play");
	scene::add_scene_func("cin_new_06_01_chase_vign_ticket_civ_group_left", &function_c9f8e2cd, "play");
	function_a22441fa();
	util::wait_network_frame();
	function_2c90def0();
	util::wait_network_frame();
	function_1626a1fa();
	util::wait_network_frame();
	function_e246b288();
	util::wait_network_frame();
	function_1a503ca4();
	util::wait_network_frame();
	function_d0faa80();
	util::wait_network_frame();
	function_8a7ecd4d();
	util::wait_network_frame();
}

/*
	Name: function_e246b288
	Namespace: newworld_rooftops
	Checksum: 0x2923E2FE
	Offset: 0x8010
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function function_e246b288()
{
	var_a61dbbf1 = spawner::simple_spawn_single("chase_trainstation_civ_scene_1");
	var_a61dbbf1.var_a0f70d54 = level.ai_bomber;
	var_cc20365a = spawner::simple_spawn_single("chase_trainstation_civ_scene_2");
	var_cc20365a.var_a0f70d54 = level.ai_bomber;
	var_f222b0c3 = spawner::simple_spawn_single("chase_trainstation_civ_scene_3");
	var_f222b0c3.var_a0f70d54 = level.ai_bomber;
	var_18252b2c = spawner::simple_spawn_single("chase_trainstation_civ_scene_4");
	var_18252b2c.var_a0f70d54 = level.ai_bomber;
	a_ai = array(var_a61dbbf1, var_cc20365a, var_f222b0c3, var_18252b2c);
	scene::add_scene_func("cin_new_06_01_chase_vign_train_civs", &function_c9f8e2cd, "play");
	level thread scene::init("cin_new_06_01_chase_vign_train_civs", a_ai);
	level thread function_df331f0b();
}

/*
	Name: function_df331f0b
	Namespace: newworld_rooftops
	Checksum: 0xD76C99C
	Offset: 0x8198
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_df331f0b()
{
	level waittill(#"hash_5367d5ab");
	level thread scene::play("cin_new_06_01_chase_vign_train_civs");
}

/*
	Name: function_1626a1fa
	Namespace: newworld_rooftops
	Checksum: 0x7E2CC354
	Offset: 0x81D0
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_1626a1fa()
{
	var_a61dbbf1 = spawner::simple_spawn_single("chase_trainstation_civ_ped_walkway_1");
	var_a61dbbf1.var_a0f70d54 = level.ai_bomber;
	var_cc20365a = spawner::simple_spawn_single("chase_trainstation_civ_ped_walkway_2");
	var_cc20365a.var_a0f70d54 = level.ai_bomber;
	var_f222b0c3 = spawner::simple_spawn_single("chase_trainstation_civ_ped_walkway_3");
	var_f222b0c3.var_a0f70d54 = level.ai_bomber;
	var_18252b2c = spawner::simple_spawn_single("chase_trainstation_civ_ped_walkway_4");
	var_18252b2c.var_a0f70d54 = level.ai_bomber;
	a_ai = array(var_a61dbbf1, var_cc20365a, var_f222b0c3, var_18252b2c);
	s_scene = struct::get("train_civs_pedestrian_bridge", "targetname");
	s_scene thread scene::init(a_ai);
	s_scene thread function_67c85dcf();
}

/*
	Name: function_67c85dcf
	Namespace: newworld_rooftops
	Checksum: 0xA9FF8C57
	Offset: 0x8350
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_67c85dcf()
{
	level waittill(#"hash_a6d0e6f3");
	self thread scene::play();
}

/*
	Name: function_1a503ca4
	Namespace: newworld_rooftops
	Checksum: 0x15345178
	Offset: 0x8380
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_1a503ca4()
{
	var_a61dbbf1 = spawner::simple_spawn_single("chase_trainstation_civ_near_1");
	var_a61dbbf1.var_a0f70d54 = level.ai_bomber;
	var_cc20365a = spawner::simple_spawn_single("chase_trainstation_civ_near_2");
	var_cc20365a.var_a0f70d54 = level.ai_bomber;
	var_f222b0c3 = spawner::simple_spawn_single("chase_trainstation_civ_near_3");
	var_f222b0c3.var_a0f70d54 = level.ai_bomber;
	var_18252b2c = spawner::simple_spawn_single("chase_trainstation_civ_near_4");
	var_18252b2c.var_a0f70d54 = level.ai_bomber;
	a_ai = array(var_a61dbbf1, var_cc20365a, var_f222b0c3, var_18252b2c);
	s_scene = struct::get("train_civs_near_group", "targetname");
	s_scene thread scene::init(a_ai);
	s_scene thread function_79da4b91();
}

/*
	Name: function_79da4b91
	Namespace: newworld_rooftops
	Checksum: 0x4AEFE2F6
	Offset: 0x8500
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_79da4b91()
{
	level waittill(#"hash_64ab138");
	self thread scene::play();
}

/*
	Name: function_d0faa80
	Namespace: newworld_rooftops
	Checksum: 0x5450824D
	Offset: 0x8530
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_d0faa80()
{
	var_a61dbbf1 = spawner::simple_spawn_single("chase_trainstation_civ_wallrun_end_1");
	var_a61dbbf1.var_a0f70d54 = level.ai_bomber;
	var_cc20365a = spawner::simple_spawn_single("chase_trainstation_civ_wallrun_end_2");
	var_cc20365a.var_a0f70d54 = level.ai_bomber;
	var_f222b0c3 = spawner::simple_spawn_single("chase_trainstation_civ_wallrun_end_3");
	var_f222b0c3.var_a0f70d54 = level.ai_bomber;
	var_18252b2c = spawner::simple_spawn_single("chase_trainstation_civ_wallrun_end_4");
	var_18252b2c.var_a0f70d54 = level.ai_bomber;
	a_ai = array(var_a61dbbf1, var_cc20365a, var_f222b0c3, var_18252b2c);
	s_scene = struct::get("train_civs_wallrun_end", "targetname");
	s_scene thread scene::init(a_ai);
	s_scene thread function_cde8399();
}

/*
	Name: function_cde8399
	Namespace: newworld_rooftops
	Checksum: 0x56F980C6
	Offset: 0x86B0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_cde8399()
{
	level waittill(#"hash_796ee858");
	self thread scene::play();
}

/*
	Name: function_c9f8e2cd
	Namespace: newworld_rooftops
	Checksum: 0x634D9356
	Offset: 0x86E0
	Size: 0xCA
	Parameters: 1
	Flags: Linked
*/
function function_c9f8e2cd(a_ents)
{
	nd_exit = getnode(self.target, "targetname");
	foreach(ai_civ in a_ents)
	{
		if(isdefined(ai_civ))
		{
			ai_civ thread newworld::function_3840d81a(nd_exit);
		}
	}
}

/*
	Name: function_a22441fa
	Namespace: newworld_rooftops
	Checksum: 0x27D12C5C
	Offset: 0x87B8
	Size: 0x33A
	Parameters: 0
	Flags: Linked
*/
function function_a22441fa()
{
	scene::add_scene_func("cin_new_06_01_chase_vign_ticket_civ_female", &function_bff4697e, "done");
	scene::add_scene_func("cin_new_06_01_chase_vign_ticket_civ_male", &function_bff4697e, "done");
	var_5bcb8a4d = struct::get_array("ticket_civ_male", "targetname");
	foreach(s_scene in var_5bcb8a4d)
	{
		ai = spawner::simple_spawn_single("ticket_civ_male");
		ai.var_a0f70d54 = level.ai_bomber;
		s_scene scene::init(array(ai));
		if(s_scene.script_noteworthy === "ticket_civs_01")
		{
			s_scene thread function_76abdc5e(ai);
			continue;
		}
		if(s_scene.script_noteworthy === "ticket_civs_02")
		{
			s_scene thread function_50a961f5(ai);
		}
	}
	util::wait_network_frame();
	var_5bcb8a4d = struct::get_array("ticket_civ_female", "targetname");
	foreach(s_scene in var_5bcb8a4d)
	{
		ai = spawner::simple_spawn_single("ticket_civ_female");
		ai.var_a0f70d54 = level.ai_bomber;
		s_scene scene::init(array(ai));
		if(s_scene.script_noteworthy === "ticket_civs_01")
		{
			s_scene thread function_76abdc5e(ai);
			continue;
		}
		if(s_scene.script_noteworthy === "ticket_civs_02")
		{
			s_scene thread function_50a961f5(ai);
		}
	}
}

/*
	Name: function_76abdc5e
	Namespace: newworld_rooftops
	Checksum: 0x76C49547
	Offset: 0x8B00
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_76abdc5e(ai)
{
	level waittill(#"hash_1fae4afe");
	wait(randomfloatrange(0.1, 0.5));
	if(isalive(ai))
	{
		self thread scene::play();
	}
}

/*
	Name: function_50a961f5
	Namespace: newworld_rooftops
	Checksum: 0xECFE0CDD
	Offset: 0x8B78
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_50a961f5(ai)
{
	level waittill(#"hash_c589911");
	wait(randomfloatrange(0.1, 0.5));
	if(isalive(ai))
	{
		self thread scene::play();
	}
}

/*
	Name: function_bff4697e
	Namespace: newworld_rooftops
	Checksum: 0x7CF73FA8
	Offset: 0x8BF0
	Size: 0xF2
	Parameters: 1
	Flags: Linked
*/
function function_bff4697e(a_ents)
{
	wait(0.05);
	foreach(ai_civ in a_ents)
	{
		if(isalive(ai_civ))
		{
			if(isdefined(self.target))
			{
				nd_exit = getnode(self.target, "targetname");
				ai_civ thread newworld::function_3840d81a(nd_exit);
			}
		}
	}
}

/*
	Name: function_8a7ecd4d
	Namespace: newworld_rooftops
	Checksum: 0xEA82B306
	Offset: 0x8CF0
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_8a7ecd4d()
{
	var_a61dbbf1 = spawner::simple_spawn_single("chase_trainstation_civ_ticket_line_1");
	var_cc20365a = spawner::simple_spawn_single("chase_trainstation_civ_ticket_line_2");
	var_f222b0c3 = spawner::simple_spawn_single("chase_trainstation_civ_ticket_line_3");
	var_18252b2c = spawner::simple_spawn_single("chase_trainstation_civ_ticket_line_4");
	a_ai = array(var_a61dbbf1, var_cc20365a, var_f222b0c3, var_18252b2c);
	s_scene = struct::get("chase_trainstation_ticket_line", "targetname");
	s_scene thread scene::init(a_ai);
	s_scene thread function_437b4c76();
}

/*
	Name: function_437b4c76
	Namespace: newworld_rooftops
	Checksum: 0x410EE19B
	Offset: 0x8E30
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_437b4c76()
{
	level waittill(#"hash_d4e3672a");
	self thread scene::play();
}

/*
	Name: function_97ed9674
	Namespace: newworld_rooftops
	Checksum: 0x8D6632D9
	Offset: 0x8E60
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_97ed9674()
{
	self endon(#"death");
	self ai::set_behavior_attribute("panic", 1);
	nd_goal = getnode(self.target, "targetname");
	while(isdefined(nd_goal))
	{
		self waittill(#"goal");
		if(isdefined(nd_goal.target))
		{
			nd_goal = getnode(nd_goal.target, "targetname");
		}
		else
		{
			nd_goal = undefined;
		}
	}
	newworld_util::function_523cdc93(0);
}

/*
	Name: function_2c90def0
	Namespace: newworld_rooftops
	Checksum: 0x11A8669A
	Offset: 0x8F40
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_2c90def0()
{
	function_205aeba5();
	util::wait_network_frame();
	function_465d660e();
}

/*
	Name: function_205aeba5
	Namespace: newworld_rooftops
	Checksum: 0xA571AD6D
	Offset: 0x8F80
	Size: 0x28C
	Parameters: 0
	Flags: Linked
*/
function function_205aeba5()
{
	var_a61dbbf1 = spawner::simple_spawn_single("chase_civilian_elevator1_1");
	var_a61dbbf1.var_a0f70d54 = level.ai_bomber;
	var_cc20365a = spawner::simple_spawn_single("chase_civilian_elevator1_2");
	var_cc20365a.var_a0f70d54 = level.ai_bomber;
	var_f222b0c3 = spawner::simple_spawn_single("chase_civilian_elevator1_3");
	var_f222b0c3.var_a0f70d54 = level.ai_bomber;
	var_18252b2c = spawner::simple_spawn_single("chase_civilian_elevator1_4");
	var_18252b2c.var_a0f70d54 = level.ai_bomber;
	var_7545bc63 = array(var_a61dbbf1, var_cc20365a, var_f222b0c3, var_18252b2c);
	e_elevator = getent("station_elevator_01", "targetname");
	e_elevator.origin = e_elevator.origin + vectorscale((0, 0, 1), 274);
	e_elevator setmovingplatformenabled(1);
	e_door_left = getent("station_elevator_door_top_left", "targetname");
	e_door_right = getent("station_elevator_door_top_right", "targetname");
	e_door_left movey(38, 0.25);
	e_door_right movey(-38, 0.25);
	s_scene = struct::get("chase_train_elevator1", "targetname");
	s_scene thread scene::init(var_7545bc63);
	level thread function_e235be84(var_7545bc63, s_scene);
}

/*
	Name: function_e235be84
	Namespace: newworld_rooftops
	Checksum: 0x9D458FC4
	Offset: 0x9218
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function function_e235be84(var_7545bc63, s_scene)
{
	trigger::wait_till("chase_elevator_trigger");
	nd_exit = getnode("train_station_securtiy_checkpoint", "script_noteworthy");
	foreach(ai in var_7545bc63)
	{
		if(isalive(ai))
		{
			ai thread function_37c7fee2(nd_exit);
		}
	}
	s_scene scene::play(var_7545bc63);
}

/*
	Name: function_465d660e
	Namespace: newworld_rooftops
	Checksum: 0x395D3589
	Offset: 0x9338
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function function_465d660e()
{
	var_a61dbbf1 = spawner::simple_spawn_single("chase_civilian_elevator2_1");
	var_a61dbbf1.var_a0f70d54 = level.ai_bomber;
	var_cc20365a = spawner::simple_spawn_single("chase_civilian_elevator2_2");
	var_cc20365a.var_a0f70d54 = level.ai_bomber;
	var_f222b0c3 = spawner::simple_spawn_single("chase_civilian_elevator2_3");
	var_f222b0c3.var_a0f70d54 = level.ai_bomber;
	var_18252b2c = spawner::simple_spawn_single("chase_civilian_elevator2_4");
	var_18252b2c.var_a0f70d54 = level.ai_bomber;
	var_7545bc63 = array(var_a61dbbf1, var_cc20365a, var_f222b0c3, var_18252b2c);
	e_elevator = getent("station_elevator_02", "targetname");
	e_elevator.origin = e_elevator.origin + vectorscale((0, 0, 1), 224);
	e_elevator setmovingplatformenabled(1);
	s_scene = struct::get("chase_train_elevator2", "targetname");
	s_scene thread scene::init(var_7545bc63);
	level thread function_543d2dbf(e_elevator, var_7545bc63, s_scene);
}

/*
	Name: function_543d2dbf
	Namespace: newworld_rooftops
	Checksum: 0x8784A550
	Offset: 0x9530
	Size: 0x1F4
	Parameters: 3
	Flags: Linked
*/
function function_543d2dbf(e_elevator, var_7545bc63, s_scene)
{
	level waittill(#"hash_b112b97b");
	e_elevator movez(70, 2);
	e_elevator waittill(#"movedone");
	e_door_left = getent("chase_elevator_2_door_upper_left", "targetname");
	e_door_right = getent("chase_elevator_2_door_upper_right", "targetname");
	e_door_left movex(38, 0.25);
	e_door_right movex(-38, 0.25);
	e_door_right waittill(#"movedone");
	nd_exit = getnode("train_station_right_side_exit", "script_noteworthy");
	foreach(ai in var_7545bc63)
	{
		if(isalive(ai))
		{
			ai thread function_37c7fee2(nd_exit);
		}
	}
	s_scene scene::play(var_7545bc63);
}

/*
	Name: function_37c7fee2
	Namespace: newworld_rooftops
	Checksum: 0x145919F7
	Offset: 0x9730
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_37c7fee2(nd_exit)
{
	self endon(#"death");
	self waittill(#"hash_7003d0a");
	if(isalive(self))
	{
		if(self.targetname == "chase_civilian_elevator2_3_ai" || self.targetname == "chase_civilian_elevator1_3_ai")
		{
			self setgoal(self.origin);
			self ai::set_behavior_attribute("panic", 1);
		}
		else
		{
			self thread newworld::function_3840d81a(nd_exit);
		}
	}
}

/*
	Name: function_a7ce33a6
	Namespace: newworld_rooftops
	Checksum: 0xDA746078
	Offset: 0x9800
	Size: 0x3AC
	Parameters: 2
	Flags: Linked
*/
function function_a7ce33a6(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		level.var_ebe3b234 = 1;
		level.ai_bomber = spawner::simple_spawn_single("chase_bomber", &bomber_spawn_function);
		function_f423f05a(str_objective);
		e_clip = getent("train_ped_blocker_clip", "targetname");
		e_clip delete();
		exploder::exploder_stop("cin_new_05_01_sun_on");
		level flag::init("chase_train_move");
		spawner::add_spawn_function_group("train_station_cafe_civs", "targetname", &function_97ed9674);
		array::run_all(getentarray("collapse_bridge", "targetname"), &delete);
		vehicle::add_spawn_function("chase_wasp_mg", &function_694c9886);
		vehicle::add_spawn_function("chase_wasp_rocket", &function_694c9886);
		function_93cf0e75(1);
		function_e8d2d7d8(2);
		function_e8d2d7d8(3);
		level thread function_8c82b44d(2);
		scene::skipto_end("p7_fxanim_cp_newworld_chase_wasp_billboard_bundle");
		trigger::use("hall_colors_train_station_end");
		load::function_a2995f22();
		level thread function_660e6b31(1);
		level thread function_33cb6df1();
		level thread function_cd5f4644(b_starting);
		level thread bomber_chase_path(str_objective);
		level thread rooftops_player_checkpoints();
		level thread function_28aaa11a(30);
		callback::on_disconnect(&function_25e57b80);
		level thread function_b453eaab();
		level.var_67e1f60e[0] = &function_3936e284;
	}
	level thread function_699bfff1(1);
	level thread function_3960c46e();
	level thread function_fb28b377("chase_street_traffic_location1");
	level thread function_fb28b377("chase_street_traffic_location2");
}

/*
	Name: function_83d6701
	Namespace: newworld_rooftops
	Checksum: 0xA94BD19A
	Offset: 0x9BB8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_83d6701()
{
	level endon(#"hash_de039dbd");
	trigger::wait_till("hall_pre_slide_color_trigger");
	level thread scene::play("cin_new_06_01_chase_vign_hall_traversal_rooftops");
}

/*
	Name: function_4d063e30
	Namespace: newworld_rooftops
	Checksum: 0x7E07E7AC
	Offset: 0x9C08
	Size: 0x24
	Parameters: 4
	Flags: Linked
*/
function function_4d063e30(str_objective, b_starting, b_direct, player)
{
}

/*
	Name: skipto_construction_site_init
	Namespace: newworld_rooftops
	Checksum: 0x155A569A
	Offset: 0x9C38
	Size: 0x2F4
	Parameters: 2
	Flags: Linked
*/
function skipto_construction_site_init(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		level.var_ebe3b234 = 1;
		exploder::exploder_stop("cin_new_05_01_sun_on");
		level.ai_bomber = spawner::simple_spawn_single("chase_bomber", &bomber_spawn_function);
		function_f423f05a(str_objective);
		level flag::init("chase_train_move");
		level thread function_699bfff1(1);
		level thread function_660e6b31(1);
		array::run_all(getentarray("collapse_bridge", "targetname"), &delete);
		array::run_all(getentarray("chase_train_b", "targetname"), &delete);
		function_93cf0e75(1);
		function_93cf0e75(2);
		function_93cf0e75(3);
		load::function_a2995f22();
		level thread function_b453eaab();
		level thread function_3960c46e();
		level thread bomber_chase_path(str_objective);
		level thread rooftops_player_checkpoints();
		level thread function_28aaa11a(30);
		callback::on_disconnect(&function_25e57b80);
		trigger::use("hall_pre_slide_color_trigger");
	}
	else
	{
		newworld_util::function_c1c980d8("chase_old_zurich_enemy_culling");
	}
	spawner::add_spawn_function_group("chase_construction_site_robots", "script_noteworthy", &function_9d580310);
	level thread scene::init("p7_fxanim_cp_newworld_chase_glass_roof_bundle");
	construction_site();
}

/*
	Name: function_9d580310
	Namespace: newworld_rooftops
	Checksum: 0x64B55CA
	Offset: 0x9F38
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_9d580310()
{
	self endon(#"death");
	self.health = int(self.health * 0.5);
	self.script_accuracy = 0.25;
}

/*
	Name: construction_site
	Namespace: newworld_rooftops
	Checksum: 0xF2CFC415
	Offset: 0x9F90
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function construction_site()
{
	level thread construction_site_glass_breaker();
	level thread construction_site_train();
	teleport_hall_at_slide();
	function_f2f82114();
}

/*
	Name: skipto_construction_site_done
	Namespace: newworld_rooftops
	Checksum: 0xE858DA75
	Offset: 0x9FF0
	Size: 0x4C
	Parameters: 4
	Flags: Linked
*/
function skipto_construction_site_done(str_objective, b_starting, b_direct, player)
{
	level notify(#"hash_97eba3fd");
	objectives::complete("cp_level_newworld_rooftop_chase");
}

/*
	Name: function_3960c46e
	Namespace: newworld_rooftops
	Checksum: 0xB462AD5B
	Offset: 0xA048
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_3960c46e()
{
	scene::add_scene_func("cin_new_06_01_chase_vign_construction_civs", &function_aec9f1d7, "init");
	scene::init("cin_new_06_01_chase_vign_construction_civs");
	level waittill(#"hash_b1604833");
	scene::play("cin_new_06_01_chase_vign_construction_civs");
}

/*
	Name: function_aec9f1d7
	Namespace: newworld_rooftops
	Checksum: 0x4027DA05
	Offset: 0xA0C8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_aec9f1d7(a_ents)
{
	a_ents["chase_construction_scene_civ_1"] thread function_6d6e8e77(a_ents["construction_civs_clipboard"]);
	a_ents["chase_construction_scene_civ_3"] thread function_6d6e8e77(a_ents["construction_civs_mug"]);
}

/*
	Name: function_6d6e8e77
	Namespace: newworld_rooftops
	Checksum: 0x56EBB98B
	Offset: 0xA140
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_6d6e8e77(e_prop)
{
	self waittill(#"death");
	e_prop delete();
}

/*
	Name: teleport_hall_at_slide
	Namespace: newworld_rooftops
	Checksum: 0x319EE17F
	Offset: 0xA178
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function teleport_hall_at_slide()
{
	level endon(#"hash_ad84c994");
	level thread function_68490836();
	level flag::wait_till("teleport_hall_at_slide");
	nd_hall_goto = getnode("teleport_hall_at_slide_node", "targetname");
	level.ai_hall newworld_util::function_d0aa2f4f();
	level notify(#"hash_de039dbd");
	level.ai_hall stopanimscripted();
	level scene::stop("cin_new_06_01_chase_vign_hall_traversal_train");
	level scene::stop("cin_new_06_01_chase_vign_hall_traversal_rooftops");
	level.ai_hall forceteleport(nd_hall_goto.origin, nd_hall_goto.angles, 0, 1);
	level.ai_hall setgoal(nd_hall_goto, 1);
	util::wait_network_frame();
	level.ai_hall newworld_util::function_c949a8ed();
	level.ai_hall.goalradius = 32;
	var_fab95496 = getnode("hall_post_slide", "targetname");
	level.ai_hall setgoal(var_fab95496, 1);
	level.ai_hall util::waittill_either("goal", "near_goal");
	trigger::use("hall_construction_site_color_trigger");
}

/*
	Name: function_68490836
	Namespace: newworld_rooftops
	Checksum: 0xACCE809
	Offset: 0xA3A0
	Size: 0x24A
	Parameters: 0
	Flags: Linked
*/
function function_68490836()
{
	trigger::wait_till("spawn_construction_site_enemies");
	util::wait_network_frame();
	a_ai = spawner::get_ai_group_ai("construction_site_upper_level");
	foreach(ai in a_ai)
	{
		level.ai_hall setignoreent(ai, 1);
	}
	a_ai = spawner::get_ai_group_ai("construction_site_initial_left");
	foreach(ai in a_ai)
	{
		ai thread function_7b0aac1e();
	}
	trigger::wait_till("spawn_construction_site_enemies_2");
	util::wait_network_frame();
	a_ai = spawner::get_ai_group_ai("construction_site_upper_level");
	foreach(ai in a_ai)
	{
		level.ai_hall setignoreent(ai, 1);
	}
}

/*
	Name: function_7b0aac1e
	Namespace: newworld_rooftops
	Checksum: 0x246E0BB7
	Offset: 0xA5F8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_7b0aac1e()
{
	self endon(#"death");
	trigger::wait_till("construction_site_left_wallrun");
	function_e1109a4f(array(self));
}

/*
	Name: function_f2f82114
	Namespace: newworld_rooftops
	Checksum: 0xC3605629
	Offset: 0xA650
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_f2f82114()
{
	trigger::wait_till("hall_construction_site_beckon");
	level thread scene::play("cin_new_08_01_rooftops_vign_beckon");
}

/*
	Name: construction_site_glass_breaker
	Namespace: newworld_rooftops
	Checksum: 0x9C915584
	Offset: 0xA698
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function construction_site_glass_breaker()
{
	a_s_glass_break = struct::get_array("construction_glass_break", "targetname");
	array::thread_all(a_s_glass_break, &glass_breaker);
}

/*
	Name: construction_site_train
	Namespace: newworld_rooftops
	Checksum: 0x5B8BE3CD
	Offset: 0xA6F8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function construction_site_train()
{
	level thread function_4cd03714("start_construction_site_train", "construction_train_org", "construction_train_start", "stop_construction_site_train", "chase_construction_train_rumble", 1);
}

/*
	Name: skipto_glass_ceiling_igc_init
	Namespace: newworld_rooftops
	Checksum: 0xA6952C6B
	Offset: 0xA748
	Size: 0x254
	Parameters: 2
	Flags: Linked
*/
function skipto_glass_ceiling_igc_init(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		exploder::exploder_stop("cin_new_05_01_sun_on");
		level.var_ebe3b234 = 1;
		level.ai_bomber = spawner::simple_spawn_single("chase_bomber", &bomber_spawn_function);
		function_f423f05a(str_objective);
		level thread rooftops_player_checkpoints();
		level thread function_699bfff1(1);
		level thread function_660e6b31(1);
		level thread scene::play("cin_new_08_01_rooftops_vign_beckon");
		scene::init("p7_fxanim_cp_newworld_chase_glass_roof_bundle");
		load::function_a2995f22();
		level thread function_28aaa11a(30);
		callback::on_disconnect(&function_25e57b80);
		level thread function_ea7bace5(1);
	}
	else
	{
		newworld_util::function_c1c980d8("chase_construction_site_enemy_culling");
	}
	level.var_67e1f60e[0] = undefined;
	level thread newworld_util::function_30ec5bf7();
	level notify(#"hash_29e8e5f2");
	level notify(#"hash_ad84c994");
	battlechatter::function_d9f49fba(0);
	level thread glass_ceiling_igc();
	level waittill(#"hash_46308f6f");
	level notify(#"hash_bdb23e9d");
	skipto::objective_completed(str_objective);
	level clientfield::set("set_fog_bank", 0);
}

/*
	Name: skipto_glass_ceiling_igc_done
	Namespace: newworld_rooftops
	Checksum: 0x76B89129
	Offset: 0xA9A8
	Size: 0x30C
	Parameters: 4
	Flags: Linked
*/
function skipto_glass_ceiling_igc_done(str_objective, b_starting, b_direct, player)
{
	foreach(player in level.players)
	{
		player savegame::set_player_data("b_has_done_chase", 1);
	}
	level flag::set("chase_done");
	level notify(#"hash_3d00ae0c");
	callback::remove_on_disconnect(&function_25e57b80);
	function_b83ef318();
	e_door = getent("chase_door_breach", "targetname");
	if(isdefined(e_door))
	{
		e_door delete();
	}
	e_glass = getent("newworld_chase_window_break_", "targetname");
	if(isdefined(e_glass))
	{
		e_glass delete();
	}
	scene::stop("p7_fxanim_gp_wasp_tower_flaps_bundle", 1);
	scene::stop("p7_fxanim_gp_wasp_tower_arms_01_bundle", 1);
	scene::stop("p7_fxanim_gp_wasp_tower_arms_02_bundle", 1);
	scene::stop("p7_fxanim_gp_wasp_tower_arms_03_bundle", 1);
	scene::stop("p7_fxanim_gp_wasp_tower_arms_04_bundle", 1);
	scene::stop("p7_fxanim_cp_newworld_chase_wasp_billboard_bundle", 1);
	e_clip = getent("chase_wasp_billboard_clip", "targetname");
	e_clip delete();
	var_b2afdf94 = getent("nw_apt_breach_decals", "targetname");
	var_b2afdf94 delete();
	objectives::set("cp_level_newworld_underground_locate_terrorist");
	function_776190fe();
}

/*
	Name: function_776190fe
	Namespace: newworld_rooftops
	Checksum: 0x485C29BD
	Offset: 0xACC0
	Size: 0x5DC
	Parameters: 0
	Flags: Linked
*/
function function_776190fe()
{
	newworld_util::scene_cleanup("p7_fxanim_cp_newworld_chase_door_breach_bundle");
	newworld_util::scene_cleanup("cin_new_05_01_apartmentbreach_1st_sh010");
	newworld_util::scene_cleanup("cin_new_05_01_apartmentbreach_3rd_sh020");
	newworld_util::scene_cleanup("cin_new_05_01_apartmentbreach_3rd_sh030");
	newworld_util::scene_cleanup("cin_new_05_01_apartmentbreach_3rd_sh040");
	newworld_util::scene_cleanup("cin_new_05_01_apartmentbreach_3rd_sh050");
	newworld_util::scene_cleanup("cin_new_05_01_apartmentbreach_3rd_sh060");
	newworld_util::scene_cleanup("cin_new_05_01_apartmentbreach_3rd_sh070");
	newworld_util::scene_cleanup("cin_new_05_01_apartmentbreach_3rd_sh080");
	newworld_util::scene_cleanup("cin_new_05_01_apartmentbreach_3rd_sh090");
	newworld_util::scene_cleanup("cin_new_05_01_apartmentbreach_3rd_sh100");
	newworld_util::scene_cleanup("cin_new_05_01_apartmentbreach_3rd_sh110");
	newworld_util::scene_cleanup("cin_new_05_01_apartmentbreach_3rd_sh120");
	newworld_util::scene_cleanup("cin_new_05_01_apartmentbreach_3rd_sh130");
	newworld_util::scene_cleanup("cin_new_05_01_apartmentbreach_1st_sh140");
	newworld_util::scene_cleanup("p7_fxanim_cp_newworld_chase_window_break_bundle");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_cower");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_bar_civs");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_railing_civs_var01");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_train_civs_var2");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_bar_stand_civs_var1");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_bar_stand_civs_var2");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_sitting_civs_right");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_sitting_civs_left");
	newworld_util::scene_cleanup("p7_fxanim_cp_newworld_bridge_collapse_bundle");
	newworld_util::scene_cleanup("cin_new_07_01_bridge_collapse_traverse");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_hall_traversal_bridge");
	newworld_util::scene_cleanup("cin_new_06_02_chase_vign_wallrun");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_hall_traversal_train");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_train_civs");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_ticket_civ_female");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_ticket_civ_male");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_ticket_civ_group_left");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_elevator_civs");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_hall_traversal_rooftops");
	newworld_util::scene_cleanup("cin_new_08_01_rooftops_vign_beckon");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_flee");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_encounter020");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_device");
	newworld_util::scene_cleanup("cin_new_08_01_rooftops_vign_encounter050");
	newworld_util::scene_cleanup("cin_new_08_01_rooftops_vign_encounter070");
	newworld_util::scene_cleanup("cin_new_08_01_rooftops_vign_encounter070_end");
	newworld_util::scene_cleanup("cin_new_08_01_rooftops_vign_encounter080");
	newworld_util::scene_cleanup("cin_new_08_01_rooftops_vign_encounter090");
	newworld_util::scene_cleanup("cin_new_08_01_rooftops_vign_encounter100");
	newworld_util::scene_cleanup("cin_new_08_01_rooftops_vign_encounter110");
	newworld_util::scene_cleanup("cin_new_08_01_rooftops_vign_encounter120");
	newworld_util::scene_cleanup("cin_gen_melee_robot_hits_civ");
	newworld_util::scene_cleanup("cin_new_06_01_chase_vign_takedown");
	newworld_util::scene_cleanup("p7_fxanim_gp_wasp_tower_flaps_bundle");
	newworld_util::scene_cleanup("p7_fxanim_gp_wasp_tower_arms_01_bundle");
	newworld_util::scene_cleanup("p7_fxanim_gp_wasp_tower_arms_02_bundle");
	newworld_util::scene_cleanup("p7_fxanim_gp_wasp_tower_arms_03_bundle");
	newworld_util::scene_cleanup("p7_fxanim_gp_wasp_tower_arms_04_bundle");
	newworld_util::scene_cleanup("p7_fxanim_cp_newworld_chase_wasp_billboard_bundle");
	wait(3);
	newworld_util::scene_cleanup("cin_new_09_01_glassceiling_1st_tackle_part01");
	newworld_util::scene_cleanup("cin_new_09_01_glassceiling_1st_tackle_part01a");
	newworld_util::scene_cleanup("cin_new_09_01_glassceiling_1st_tackle_part02");
	newworld_util::scene_cleanup("p7_fxanim_cp_newworld_chase_glass_roof_bundle");
	newworld_util::scene_cleanup("p7_fxanim_cp_newworld_chase_air_traffic_hunters_01_bundle");
	newworld_util::scene_cleanup("p7_fxanim_cp_newworld_chase_air_traffic_hunters_02_bundle");
	newworld_util::scene_cleanup("p7_fxanim_cp_newworld_chase_air_traffic_hunters_03_bundle");
}

/*
	Name: glass_ceiling_igc
	Namespace: newworld_rooftops
	Checksum: 0x37E0B821
	Offset: 0xB2A8
	Size: 0x39C
	Parameters: 0
	Flags: Linked
*/
function glass_ceiling_igc()
{
	scene::add_scene_func("cin_new_09_01_glassceiling_1st_tackle_part01", &function_8f838402, "play");
	scene::add_scene_func("cin_new_09_01_glassceiling_1st_tackle_part01", &function_92556ff1, "play");
	scene::add_scene_func("cin_new_09_01_glassceiling_1st_tackle_part01", &function_7ad5702a, "play");
	scene::add_scene_func("cin_new_09_01_glassceiling_1st_tackle_part01a", &function_3b3a0120, "play");
	scene::add_scene_func("cin_new_09_01_glassceiling_1st_tackle_part01a", &newworld_util::function_43dfaf16, "skip_started");
	scene::add_scene_func("cin_new_09_01_glassceiling_1st_tackle_part02", &function_4c248a91, "play");
	scene::add_scene_func("cin_new_09_01_glassceiling_1st_tackle_part02", &function_d081fcc5, "play");
	scene::add_scene_func("cin_new_09_01_glassceiling_1st_tackle_part02", &function_47edd0a5);
	scene::add_scene_func("p7_fxanim_cp_newworld_chase_glass_roof_bundle", &function_920e3893, "play");
	level thread function_bc6c3aa5();
	var_5b5cfed1 = getent("start_glass_ceiling_igc", "targetname");
	level.var_f2a5cb1e = var_5b5cfed1;
	while(true)
	{
		var_5b5cfed1 waittill(#"trigger", ent);
		if(isplayer(ent))
		{
			level thread function_3174cbb();
			level notify(#"hash_a70b0538");
			break;
		}
	}
	level thread function_bc6c3aa5();
	if(isdefined(ent))
	{
		ent player::take_weapons();
	}
	wait(0.625);
	if(scene::is_playing("cin_new_08_01_rooftops_vign_encounter120"))
	{
		scene::stop("cin_new_08_01_rooftops_vign_encounter120");
	}
	if(isdefined(ent))
	{
		ent player::give_back_weapons();
	}
	level notify(#"rooftops_terminate");
	level thread function_382f4206();
	if(isdefined(level.bzm_newworlddialogue7callback))
	{
		level thread [[level.bzm_newworlddialogue7callback]]();
	}
	level thread namespace_e38c3c58::function_f4a6634b();
	level.ai_bomber clientfield::set("chase_suspect_fx", 0);
	level thread scene::play("p7_fxanim_cp_newworld_chase_glass_roof_bundle");
	level scene::play("cin_new_09_01_glassceiling_1st_tackle_part01", ent);
}

/*
	Name: function_47edd0a5
	Namespace: newworld_rooftops
	Checksum: 0x4D937604
	Offset: 0xB650
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_47edd0a5(a_ents)
{
	a_ents["player 1"] waittill(#"fade_out");
	level flag::set("infinite_white_transition");
	newworld_util::function_2eded728(0);
}

/*
	Name: function_bc6c3aa5
	Namespace: newworld_rooftops
	Checksum: 0xA39FC68E
	Offset: 0xB6B8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_bc6c3aa5()
{
	if(scene::is_playing("cin_new_08_01_rooftops_vign_encounter120"))
	{
		level waittill(#"hash_7f4315eb");
	}
	level.ai_bomber show();
	level scene::init("cin_new_09_01_glassceiling_1st_tackle_part01");
}

/*
	Name: function_8f838402
	Namespace: newworld_rooftops
	Checksum: 0x275E7EB8
	Offset: 0xB728
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function function_8f838402(a_ents)
{
	a_ents["chase_bomber_ai"] show();
	a_ents["hall"] ghost();
	a_ents["hall"] waittill(#"rez_in");
	a_ents["hall"] thread newworld_util::function_c949a8ed(1);
}

/*
	Name: function_92556ff1
	Namespace: newworld_rooftops
	Checksum: 0xC732D223
	Offset: 0xB7C0
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function function_92556ff1(a_ents)
{
	a_ents["hall"] setignorepauseworld(1);
	a_ents["chase_bomber_ai"] setignorepauseworld(1);
	a_ents["player 1"] waittill(#"freeze");
	setpauseworld(1);
	a_ents["player 1"] waittill(#"unfreeze");
	setpauseworld(0);
}

/*
	Name: function_7ad5702a
	Namespace: newworld_rooftops
	Checksum: 0x3DB443A6
	Offset: 0xB888
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_7ad5702a(a_ents)
{
	level waittill(#"hash_6b9e8dcb");
	level clientfield::set("set_fog_bank", 2);
}

/*
	Name: function_3b3a0120
	Namespace: newworld_rooftops
	Checksum: 0xC16315F0
	Offset: 0xB8D0
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_3b3a0120(a_ents)
{
	a_ents["player 1"] waittill(#"start_hack");
	if(!scene::is_skipping_in_progress())
	{
		newworld_util::function_2eded728(1);
		level thread newworld_util::movie_transition("cp_newworld_fs_dni", "fullscreen_additive");
	}
}

/*
	Name: function_4c248a91
	Namespace: newworld_rooftops
	Checksum: 0xA9E79CA4
	Offset: 0xB950
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_4c248a91(a_ents)
{
	a_ents["taylor"] ghost();
	a_ents["taylor"] waittill(#"spawn_character");
	a_ents["taylor"] thread newworld_util::function_c949a8ed(1);
	a_ents["taylor"] waittill(#"hash_76000c11");
	a_ents["taylor"] thread newworld_util::function_4943984c();
}

/*
	Name: function_d081fcc5
	Namespace: newworld_rooftops
	Checksum: 0x4D0775B1
	Offset: 0xBA00
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_d081fcc5(a_ents)
{
	a_ents["hall"] waittill(#"hash_76000c11");
	a_ents["hall"] thread newworld_util::function_4943984c(1);
}

/*
	Name: function_920e3893
	Namespace: newworld_rooftops
	Checksum: 0xA47403B1
	Offset: 0xBA58
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_920e3893(a_ents)
{
	a_ents["newworld_chase_glass_roof"] setignorepauseworld(1);
}

/*
	Name: function_b83ef318
	Namespace: newworld_rooftops
	Checksum: 0x5D85DD41
	Offset: 0xBA98
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_b83ef318()
{
	array::run_all(getaiarray(), &delete);
	level thread function_699bfff1(0);
	level thread function_660e6b31(0);
}

/*
	Name: function_9c291f73
	Namespace: newworld_rooftops
	Checksum: 0xC96A5D88
	Offset: 0xBB08
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function function_9c291f73()
{
	self endon(#"death");
	if(isdefined(self.var_fc7f3f21) && self.var_fc7f3f21)
	{
		return;
	}
	if(!isdefined(self.var_bf827f00))
	{
		self.var_bf827f00 = 0;
	}
	switch(self.var_bf827f00)
	{
		case 0:
		{
			level.ai_hall dialog::say("hall_don_t_take_him_out_0", undefined, 0, self);
			break;
		}
		case 1:
		{
			level.ai_hall dialog::say("hall_didn_t_you_hear_me_0", undefined, 0, self);
			break;
		}
		case 2:
		{
			level.ai_hall dialog::say("hall_this_part_isn_t_abou_0", undefined, 0, self);
			break;
		}
		case 3:
		{
			level.ai_hall dialog::say("hall_i_m_getting_tired_of_0", undefined, 0, self);
			break;
		}
	}
	self thread function_df9bd811();
}

/*
	Name: function_df9bd811
	Namespace: newworld_rooftops
	Checksum: 0x7BDA0E75
	Offset: 0xBC40
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function function_df9bd811()
{
	self.var_bf827f00++;
	self.var_fc7f3f21 = 1;
	wait(15);
	self.var_fc7f3f21 = 0;
}

/*
	Name: function_6a59765b
	Namespace: newworld_rooftops
	Checksum: 0xA9B9F55E
	Offset: 0xBC70
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function function_6a59765b()
{
	level thread function_e54bdd35();
	foreach(player in level.activeplayers)
	{
		if(player newworld_util::function_c633d8fe())
		{
			continue;
		}
		player thread function_9a9ab34a();
	}
}

/*
	Name: function_e54bdd35
	Namespace: newworld_rooftops
	Checksum: 0x2FE51276
	Offset: 0xBD40
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_e54bdd35()
{
	level endon(#"hash_a70b0538");
	wait(30);
	level.ai_hall dialog::say("hall_jump_down_we_can_t_0");
}

/*
	Name: function_3775434b
	Namespace: newworld_rooftops
	Checksum: 0xADA10AB1
	Offset: 0xBD88
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_3775434b()
{
	level endon(#"hash_bdb23e9d");
	trigger::wait_till("bar_2nd_floor_enemy_VO");
	n_count = spawner::get_ai_group_sentient_count("bar_2nd_floor_robot");
	if(n_count > 0)
	{
		level.ai_hall dialog::say("hall_heads_up_hostiles_s_0");
	}
}

/*
	Name: function_6a13c1d0
	Namespace: newworld_rooftops
	Checksum: 0xD965A22E
	Offset: 0xBE08
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_6a13c1d0()
{
	level.ai_hall dialog::say("hall_sending_his_location_0", 0.5);
}

/*
	Name: function_f4fcddfb
	Namespace: newworld_rooftops
	Checksum: 0x5018C309
	Offset: 0xBE40
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_f4fcddfb()
{
	trigger::wait_till("chase_mid_bar_VO");
	level.ai_hall dialog::say("hall_i_still_have_line_of_0");
}

/*
	Name: function_a00b4c50
	Namespace: newworld_rooftops
	Checksum: 0x6125AB10
	Offset: 0xBE88
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_a00b4c50(b_starting = 0)
{
	level flag::init("bridge_collapse_vo_complete");
	level flag::init("bridge_collapse_vo_started");
	if(!b_starting)
	{
		level.var_79ddcc8b dialog::say("zsfh_surrender_this_is_0", undefined, 1);
	}
	level waittill(#"bridge_collapse_igc_done");
	level thread function_c2c5155b();
}

/*
	Name: function_c2c5155b
	Namespace: newworld_rooftops
	Checksum: 0xCCAE8E12
	Offset: 0xBF40
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function function_c2c5155b()
{
	if(!level flag::exists("bridge_collapse_vo_complete"))
	{
		level flag::init("bridge_collapse_vo_complete");
	}
	if(!level flag::exists("bridge_collapse_vo_started"))
	{
		level flag::init("bridge_collapse_vo_started");
	}
	level flag::set("bridge_collapse_vo_started");
	level.ai_hall dialog::say("hall_our_boy_s_hacking_th_0", 0.5);
	playsoundatposition("amb_train_horn_distant", (-10536, -23636, 10075));
	level dialog::player_say("plyr_he_s_running_scared_0", 0.5);
	level.ai_hall dialog::say("hall_you_re_a_smart_one_n_0", 0.25);
	level flag::set("bridge_collapse_vo_complete");
	level flag::clear("bridge_collapse_vo_started");
}

/*
	Name: function_105db04
	Namespace: newworld_rooftops
	Checksum: 0x944E40E0
	Offset: 0xC0D0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_105db04()
{
	level flag::wait_till("bridge_collapse_vo_complete");
	level flag::wait_till("players_climb_up_post_bridge_collapse");
	level.ai_hall dialog::say("hall_son_of_a_bitch_is_st_0", 0.5);
}

/*
	Name: function_be23c07c
	Namespace: newworld_rooftops
	Checksum: 0xE01E39E8
	Offset: 0xC148
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function function_be23c07c()
{
	trigger::wait_till("chase_trains");
	level.ai_hall dialog::say("hall_use_that_billboard_t_0");
	foreach(player in level.players)
	{
		if(player newworld_util::function_c633d8fe())
		{
			continue;
		}
		player thread util::show_hint_text(&"CP_MI_ZURICH_NEWWORLD_WALLRUN_TUTORIAL", 0, undefined, 4);
	}
}

/*
	Name: function_a69280be
	Namespace: newworld_rooftops
	Checksum: 0x2DE0066F
	Offset: 0xC240
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function function_a69280be(var_81a32895, var_2380d5c)
{
	self endon(#"death");
	level.ai_hall dialog::say("hall_alright_activating_0", undefined, 0, self);
	weapon = newworld_util::function_71840183(var_81a32895, var_2380d5c);
	var_12b288c7 = weapon.name + "_fired";
	var_a2cc98e = var_81a32895 + "_use_ability_tutorial";
	self thread function_47c78606(var_a2cc98e);
	self thread function_57ffa633(var_12b288c7);
}

/*
	Name: function_47c78606
	Namespace: newworld_rooftops
	Checksum: 0x6559DA12
	Offset: 0xC328
	Size: 0x1FE
	Parameters: 1
	Flags: Linked
*/
function function_47c78606(var_a2cc98e)
{
	level endon(#"hash_29e8e5f2");
	self endon(var_a2cc98e);
	self endon(#"death");
	if(!self flag::exists(var_a2cc98e))
	{
		return;
	}
	if(self flag::get(var_a2cc98e))
	{
		return;
	}
	wait(10);
	a_ai = getaiteamarray("axis");
	foreach(ai in a_ai)
	{
		if(isalive(ai) && ai.classname === "script_vehicle")
		{
			break;
		}
	}
	n_line = randomintrange(0, 3);
	switch(n_line)
	{
		case 0:
		{
			level.ai_hall dialog::say("hall_remember_your_cyber_1", undefined, 0, self);
			break;
		}
		case 1:
		{
			level.ai_hall dialog::say("hall_use_system_paralysis_0", undefined, 0, self);
			break;
		}
		case 2:
		{
			level.ai_hall dialog::say("hall_why_you_doing_this_o_0", undefined, 0, self);
			break;
		}
	}
}

/*
	Name: function_57ffa633
	Namespace: newworld_rooftops
	Checksum: 0xF9792CE0
	Offset: 0xC530
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function function_57ffa633(var_12b288c7)
{
	self endon(#"death");
	level endon(#"hash_29e8e5f2");
	self waittill(var_12b288c7);
	wait(0.5);
	n_line = randomintrange(0, 3);
	switch(n_line)
	{
		case 0:
		{
			level.ai_hall dialog::say("hall_piece_of_cake_0", undefined, 0, self);
			break;
		}
		case 1:
		{
			level.ai_hall dialog::say("hall_you_re_getting_the_h_0", undefined, 0, self);
			break;
		}
		case 2:
		{
			level.ai_hall dialog::say("hall_nice_going_newblood_0", undefined, 0, self);
			break;
		}
	}
	level.ai_hall dialog::say("hall_your_cyber_abilities_0", 0.5, 0, self);
}

/*
	Name: function_cd5f4644
	Namespace: newworld_rooftops
	Checksum: 0x79140F82
	Offset: 0xC668
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_cd5f4644(b_starting = 0)
{
	if(!b_starting)
	{
		level waittill(#"hash_f29a6266");
	}
	else
	{
		wait(0.5);
	}
	level.ai_hall dialog::say("hall_he_s_heading_into_ol_0");
}

/*
	Name: function_209e2a03
	Namespace: newworld_rooftops
	Checksum: 0x4CF8E2CE
	Offset: 0xC6D8
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function function_209e2a03()
{
	trigger::wait_till("player_enters_old_rooftops_vo");
	level.ai_hall dialog::say("hall_he_s_getting_distanc_0", 0.25);
}

/*
	Name: function_cc7848ea
	Namespace: newworld_rooftops
	Checksum: 0xFD5FF1D6
	Offset: 0xC728
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function function_cc7848ea()
{
	wait(3);
	a_ai_wasps = getentarray("chase_wasp_tower_2", "targetname");
	if(a_ai_wasps.size > 0)
	{
		level.ai_hall dialog::say("hall_taking_fire_from_the_0");
	}
}

/*
	Name: function_da0e703d
	Namespace: newworld_rooftops
	Checksum: 0xEA2C01CE
	Offset: 0xC798
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_da0e703d()
{
	wait(3);
	a_ai_wasps = getentarray("chase_wasp_tower_3", "targetname");
	if(a_ai_wasps.size > 0)
	{
		level.ai_hall dialog::say("hall_take_them_down_0");
	}
}

/*
	Name: function_b453eaab
	Namespace: newworld_rooftops
	Checksum: 0xC9B7BB82
	Offset: 0xC808
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_b453eaab()
{
	trigger::wait_till("chase_slide_vo");
	level.ai_hall dialog::say("hall_don_t_let_up_slide_0");
}

/*
	Name: function_8aea2545
	Namespace: newworld_rooftops
	Checksum: 0x5C277666
	Offset: 0xC850
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_8aea2545()
{
	level waittill(#"hash_ce19dcf7");
	level.ai_hall dialog::say("hall_don_t_lose_him_now_0");
	level thread function_ea7bace5();
}

/*
	Name: function_ea7bace5
	Namespace: newworld_rooftops
	Checksum: 0x398B7A57
	Offset: 0xC8A8
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_ea7bace5(b_skipto = 0)
{
	if(!b_skipto)
	{
		trigger::wait_till("chase_construction_end_vo");
	}
	level.ai_hall dialog::say("hall_grab_him_newblood_0");
}

/*
	Name: function_3174cbb
	Namespace: newworld_rooftops
	Checksum: 0x29B83DF0
	Offset: 0xC910
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_3174cbb()
{
	level.ai_hall dialog::say("hall_now_s_your_chance_t_0");
}

/*
	Name: function_befa9b05
	Namespace: newworld_rooftops
	Checksum: 0x8B09FA40
	Offset: 0xC940
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_befa9b05()
{
	self endon(#"death");
	if(isdefined(self.var_9d7cd87) && self.var_9d7cd87)
	{
		return;
	}
	if(!isdefined(self.var_4891f22b))
	{
		self.var_4891f22b = array("hall_mind_your_footing_t_0", "hall_watch_the_ledges_yo_0", "hall_you_re_better_than_t_0");
	}
	wait(0.5);
	str_line = array::pop(self.var_4891f22b, randomintrange(0, self.var_4891f22b.size), 0);
	if(self.var_4891f22b.size == 0)
	{
		self.var_4891f22b = undefined;
	}
	level.ai_hall dialog::say(str_line, undefined, 0, self);
	self thread function_187d1fab();
}

/*
	Name: function_187d1fab
	Namespace: newworld_rooftops
	Checksum: 0xD86513E0
	Offset: 0xCA50
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_187d1fab()
{
	self endon(#"death");
	self.var_9d7cd87 = 1;
	wait(30);
	self.var_9d7cd87 = 0;
}

/*
	Name: function_f752dce5
	Namespace: newworld_rooftops
	Checksum: 0x3EBD2F4E
	Offset: 0xCA88
	Size: 0x246
	Parameters: 2
	Flags: Linked
*/
function function_f752dce5(n_wait, str_endon)
{
	level endon(str_endon);
	wait(n_wait / 2);
	if(level flag::exists("bridge_collapse_vo_started"))
	{
		level flag::wait_till_clear("bridge_collapse_vo_started");
	}
	if(level.current_skipto == "chase_glass_ceiling_igc")
	{
		level.ai_hall dialog::say("hall_you_ain_t_gonna_get_0");
	}
	else
	{
		n_index = randomintrange(0, 5);
		switch(n_index)
		{
			case 0:
			{
				level.ai_hall dialog::say("hall_move_it_we_can_t_lo_0");
				break;
			}
			case 1:
			{
				level.ai_hall dialog::say("hall_pick_up_the_pace_le_0");
				break;
			}
			case 2:
			{
				level.ai_hall dialog::say("hall_we_lose_him_it_s_yo_0");
				break;
			}
			case 3:
			{
				level.ai_hall dialog::say("hall_you_re_losing_him_0");
				break;
			}
			case 4:
			{
				s_taylor = struct::get("chase_taylor_vo", "targetname");
				var_fc1953ce = spawn("script_origin", s_taylor.origin);
				var_fc1953ce dialog::say("tayr_keep_up_you_got_no_0", undefined, 1);
				var_fc1953ce delete();
			}
			default:
			{
				break;
			}
		}
	}
}

/*
	Name: function_9e93135c
	Namespace: newworld_rooftops
	Checksum: 0xEF136D5C
	Offset: 0xCCD8
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function function_9e93135c()
{
	n_index = randomintrange(0, 3);
	switch(n_index)
	{
		case 0:
		{
			level.ai_hall dialog::say("hall_suspect_s_escaped_l_0");
			break;
		}
		case 1:
		{
			level.ai_hall dialog::say("hall_you_re_gonna_have_to_0");
			break;
		}
		case 2:
		{
			level.ai_hall dialog::say("hall_you_wanna_run_with_u_0");
			break;
		}
		default:
		{
			break;
		}
	}
}

/*
	Name: function_8e9219f
	Namespace: newworld_rooftops
	Checksum: 0x64DAE2CE
	Offset: 0xCDB8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_8e9219f()
{
	if(isdefined(self.var_46b969f4) && self.var_46b969f4)
	{
		return;
	}
	level.ai_hall dialog::say("hall_check_your_fire_civ_0", undefined, 0, self);
	self thread function_999e5485();
}

/*
	Name: function_999e5485
	Namespace: newworld_rooftops
	Checksum: 0x38DDA5A6
	Offset: 0xCE20
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_999e5485()
{
	self endon(#"death");
	self.var_46b969f4 = 1;
	wait(30);
	self.var_46b969f4 = 0;
}

/*
	Name: bomber_chase_path
	Namespace: newworld_rooftops
	Checksum: 0xF3DDE20E
	Offset: 0xCE58
	Size: 0x122C
	Parameters: 1
	Flags: Linked
*/
function bomber_chase_path(str_objective)
{
	level flag::init("chase_suspect_train_stationstation_1st_half_done");
	level.var_ceb0eec3 = getnode("chase_bomber_teleport", "targetname");
	scene::add_scene_func("cin_new_06_01_chase_vign_flee", &function_5a6a9794, "play");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter050", &function_5a6a9794, "play");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter050", &function_c2f8c75f, "done");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter070", &function_5a6a9794, "play");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter070", &function_90332e7d, "play");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter070", &function_e7e11a61, "done");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter070_end", &function_c2f8c75f, "done");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter080", &function_5a6a9794, "play");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter080", &function_c2f8c75f, "done");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter080", &function_3e091d9e, "done");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter090", &function_5a6a9794, "play");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter090", &function_c2f8c75f, "done");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter100", &function_dae77e96, "init");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter100", &function_5a6a9794, "play");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter100", &function_6a406930, "play");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter100", &function_c2f8c75f, "done");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter110", &function_5a6a9794, "play");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter110", &function_c2f8c75f, "done");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter120", &function_5a6a9794, "play");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter120", &function_c2f8c75f, "done");
	scene::add_scene_func("cin_new_08_01_rooftops_vign_encounter120", &function_7f4315eb, "done");
	a_bomber_multinode_path = [];
	var_e20fd93b = getnode("chase_post_apartment", "targetname");
	nd_pre_bridge_wait = getnode("chase_pre_bridge_wait", "targetname");
	nd_post_explosion = getnode("chase_post_explosion", "targetname");
	nd_post_bridge = getnode("chase_post_bridge", "targetname");
	nd_pre_train_traversals01 = getnode("chase_pre_train_traversals01", "targetname");
	nd_old_rooftop_start04 = getnode("chase_old_rooftop_start_cheat04", "targetname");
	nd_post_slide = getnode("chase_post_slide", "targetname");
	level.ai_bomber.goalradius = 8;
	if(str_objective === "chase_chase_start")
	{
		level.ai_bomber forceteleport(var_e20fd93b.origin, var_e20fd93b.angles);
		level flag::wait_till("apartment_jump_down");
		level.var_f2a5cb1e = getentarray("chase_pre_bridge", "targetname");
		level thread function_28aaa11a(60);
		level thread function_112af5d1();
		level scene::play("cin_new_06_01_chase_vign_flee");
		level thread function_3775434b();
		level thread function_f4fcddfb();
		level waittill(#"hash_13934b0");
		level scene::init("cin_new_06_01_chase_vign_device");
		level flag::wait_till("bridge_collapse_start");
	}
	else
	{
		level.ai_bomber ghost();
		level.ai_bomber forceteleport(nd_pre_bridge_wait.origin, nd_pre_bridge_wait.angles);
	}
	if(str_objective === "chase_chase_start" || str_objective === "chase_bridge_collapse")
	{
		wait(0.05);
		function_5a6a9794();
		level thread function_28aaa11a(30);
		level.var_f2a5cb1e = getentarray("bomber_post_bridge_traversals", "targetname");
		level.ai_bomber util::magic_bullet_shield();
		level thread function_a00b4c50();
		level thread function_2c789839();
		level scene::play("cin_new_06_01_chase_vign_device");
		level.ai_bomber util::stop_magic_bullet_shield();
		level.ai_bomber setgoal(nd_post_explosion);
	}
	else
	{
		level.ai_bomber ghost();
		level.ai_bomber forceteleport(nd_post_explosion.origin, nd_post_explosion.angles);
	}
	if(str_objective === "chase_chase_start" || str_objective === "chase_bridge_collapse" || str_objective === "chase_rooftops")
	{
		wait(0.05);
		function_5a6a9794();
		level.var_f2a5cb1e = getentarray("chase_post_bridge", "targetname");
		level flag::wait_till("bomber_post_bridge_traversals");
		level thread function_28aaa11a(30);
		level thread function_105db04();
		level thread function_1c67a977();
		a_bomber_multinode_path = [];
		array::add(a_bomber_multinode_path, nd_post_bridge);
		array::add(a_bomber_multinode_path, nd_pre_train_traversals01);
		bomber_node_by_node_pathing(a_bomber_multinode_path, "chase_post_bridge");
		flag::wait_till("chase_post_bridge_mantle_up");
		level.var_f2a5cb1e = getentarray("chase_train_station_glass_ceiling", "targetname");
		level thread function_28aaa11a(30);
		level.ai_bomber clientfield::set("chase_suspect_fx", 0);
		util::wait_network_frame();
		level thread scene::play("cin_new_08_01_rooftops_vign_encounter050");
		flag::wait_till("chase_train_station_glass_ceiling");
		level thread function_28aaa11a(60);
		level thread function_b6418460();
		scene::stop("cin_new_08_01_rooftops_vign_encounter050");
		level.ai_bomber show();
		level thread scene::play("cin_new_08_01_rooftops_vign_encounter070");
		level notify(#"hash_64ab138");
		level.var_f2a5cb1e = getentarray("chase_train_station_midpoint", "targetname");
		level flag::wait_till("chase_train_station_midpoint");
		level flag::wait_till("chase_suspect_train_stationstation_1st_half_done");
		level thread scene::play("cin_new_08_01_rooftops_vign_encounter070_end");
		level thread function_cd5f4644();
		trigger::use("spawn_train_station_cafe_civs");
	}
	else
	{
		level.ai_bomber ghost();
		level.ai_bomber forceteleport(nd_old_rooftop_start04.origin, nd_old_rooftop_start04.angles);
	}
	if(str_objective === "chase_chase_start" || str_objective === "chase_bridge_collapse" || str_objective === "chase_rooftops" || str_objective === "chase_old_zurich")
	{
		level.var_f2a5cb1e = getentarray("start_bomber_old_zurich", "targetname");
		level flag::wait_till("start_suspect_vign_encounter080");
		level thread function_28aaa11a(60);
		level thread scene::stop("cin_new_08_01_rooftops_vign_encounter070");
		level.ai_bomber clientfield::set("chase_suspect_fx", 0);
		util::wait_network_frame();
		level.ai_bomber forceteleport(nd_old_rooftop_start04.origin, nd_old_rooftop_start04.angles, 0, 1);
		wait(0.05);
		level.ai_bomber show();
		level.ai_bomber clientfield::set("chase_suspect_fx", 1);
		level thread function_c3fb206c();
		level thread scene::play("cin_new_08_01_rooftops_vign_encounter080");
		level.var_f2a5cb1e = getentarray("suspect_scenes_old_rooftops_2", "targetname");
		level flag::wait_till("start_suspect_vign_encounter090");
		level thread function_28aaa11a(60);
		level thread scene::stop("cin_new_08_01_rooftops_vign_encounter080");
		level.ai_bomber show();
		level thread function_ca093905();
		level thread scene::play("cin_new_08_01_rooftops_vign_encounter090");
	}
	else
	{
		level.ai_bomber ghost();
		level.ai_bomber forceteleport(nd_post_slide.origin, nd_post_slide.angles);
	}
	if(str_objective === "chase_chase_start" || str_objective === "chase_bridge_collapse" || str_objective === "chase_rooftops" || str_objective === "chase_old_zurich" || str_objective === "chase_construction_site")
	{
		wait(0.05);
		function_5a6a9794();
		level thread scene::init("cin_new_08_01_rooftops_vign_encounter100");
		level.var_f2a5cb1e = getentarray("suspect_scenes_construction_1", "targetname");
		level flag::wait_till("start_suspect_vign_encounter100");
		level thread function_28aaa11a(30);
		level thread scene::stop("cin_new_08_01_rooftops_vign_encounter090");
		function_c2f8c75f();
		level.ai_bomber forceteleport(nd_post_slide.origin, nd_post_slide.angles);
		level thread scene::skipto_end("cin_new_08_01_rooftops_vign_encounter100", undefined, undefined, 0.2);
		level thread function_8aea2545();
		level.var_f2a5cb1e = getentarray("suspect_scenes_construction_2", "targetname");
		level flag::wait_till("start_suspect_vign_encounter110");
		level thread function_28aaa11a(30);
		level thread scene::stop("cin_new_08_01_rooftops_vign_encounter100");
		function_c2f8c75f();
		level thread scene::play("cin_new_08_01_rooftops_vign_encounter110");
		level.var_f2a5cb1e = getentarray("suspect_scenes_construction_3", "targetname");
		level flag::wait_till("start_suspect_vign_encounter120");
		level thread function_28aaa11a(30);
		level thread scene::stop("cin_new_08_01_rooftops_vign_encounter110");
		function_c2f8c75f();
		level thread scene::play("cin_new_08_01_rooftops_vign_encounter120");
		var_5b5cfed1 = getent("start_glass_ceiling_igc", "targetname");
		level.var_f2a5cb1e = var_5b5cfed1;
	}
}

/*
	Name: function_5a6a9794
	Namespace: newworld_rooftops
	Checksum: 0xB741AE
	Offset: 0xE090
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_5a6a9794(a_ents)
{
	if(isdefined(a_ents))
	{
		ai_bomber = a_ents["chase_bomber_ai"];
	}
	else
	{
		ai_bomber = level.ai_bomber;
	}
	ai_bomber show();
	wait(0.1);
	ai_bomber clientfield::set("chase_suspect_fx", 1);
}

/*
	Name: function_c2f8c75f
	Namespace: newworld_rooftops
	Checksum: 0x11BF2712
	Offset: 0xE120
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function function_c2f8c75f(a_ents)
{
	if(isdefined(a_ents))
	{
		ai_bomber = a_ents["chase_bomber_ai"];
	}
	else
	{
		ai_bomber = level.ai_bomber;
	}
	ai_bomber ghost();
	ai_bomber clientfield::set("chase_suspect_fx", 0);
	util::wait_network_frame();
	ai_bomber forceteleport(level.var_ceb0eec3.origin);
}

/*
	Name: function_dae77e96
	Namespace: newworld_rooftops
	Checksum: 0x8A26C712
	Offset: 0xE1E0
	Size: 0xCA
	Parameters: 1
	Flags: Linked
*/
function function_dae77e96(a_ents)
{
	foreach(ent in a_ents)
	{
		if(isdefined(ent.classname) && issubstr(ent.classname, "civilian"))
		{
			ent disableaimassist();
		}
	}
}

/*
	Name: function_90332e7d
	Namespace: newworld_rooftops
	Checksum: 0x9A49C23C
	Offset: 0xE2B8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_90332e7d(a_ents)
{
	level waittill(#"hash_6a2e620a");
	level.ai_bomber clientfield::set("chase_suspect_fx", 0);
	level waittill(#"hash_53dda89b");
	level.ai_bomber clientfield::set("chase_suspect_fx", 1);
}

/*
	Name: function_e7e11a61
	Namespace: newworld_rooftops
	Checksum: 0x8DF224FE
	Offset: 0xE330
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_e7e11a61(a_ents)
{
	level flag::set("chase_suspect_train_stationstation_1st_half_done");
}

/*
	Name: function_3e091d9e
	Namespace: newworld_rooftops
	Checksum: 0xEFD9B79E
	Offset: 0xE368
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_3e091d9e(a_ents)
{
	level thread scene::init("cin_new_08_01_rooftops_vign_encounter090");
}

/*
	Name: function_7f4315eb
	Namespace: newworld_rooftops
	Checksum: 0x783BBD0C
	Offset: 0xE3A0
	Size: 0x1A
	Parameters: 1
	Flags: Linked
*/
function function_7f4315eb(a_ents)
{
	level notify(#"hash_7f4315eb");
}

/*
	Name: bomber_node_by_node_pathing
	Namespace: newworld_rooftops
	Checksum: 0x48471FEE
	Offset: 0xE3C8
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function bomber_node_by_node_pathing(a_nd_path, str_endon)
{
	level.ai_bomber endon(#"death");
	if(isdefined(str_endon))
	{
		level endon(str_endon);
	}
	foreach(nd_path in a_nd_path)
	{
		level.ai_bomber setgoal(nd_path);
		level.ai_bomber waittill(#"goal");
	}
}

/*
	Name: function_1c67a977
	Namespace: newworld_rooftops
	Checksum: 0x5FB84F07
	Offset: 0xE4A8
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_1c67a977()
{
	a_ai_robots = spawner::simple_spawn("chase_post_bridge_robots");
	foreach(ai in a_ai_robots)
	{
		ai thread function_117951b9();
	}
	level thread function_a507aa05(a_ai_robots);
	array::wait_till(a_ai_robots, "post_bridge_colllapse_robots_in_place");
	level flag::set("hall_use_systemoverload_post_bridge_collapse");
}

/*
	Name: function_117951b9
	Namespace: newworld_rooftops
	Checksum: 0x8B12CF82
	Offset: 0xE5B8
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function function_117951b9()
{
	self endon(#"death");
	self.health = int(self.health * 0.5);
	self.script_accuracy = 0.25;
	self ai::set_ignoreall(1);
	self ai::set_behavior_attribute("sprint", 1);
	self waittill(#"goal");
	self ai::set_ignoreall(0);
	self notify(#"hash_1dba7b6f");
}

/*
	Name: function_480f8035
	Namespace: newworld_rooftops
	Checksum: 0xC5D1DD95
	Offset: 0xE678
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function function_480f8035()
{
	scene::add_scene_func("cin_gen_melee_robot_hits_civ", &function_d212a60d, "play");
	scene::add_scene_func("cin_gen_melee_robot_hits_civ", &function_65fe4a2f, "done");
	ai_robot = spawner::simple_spawn_single("robot_hits_civ_scene_robot");
	ai_civ = spawner::simple_spawn_single("robot_hits_civ_scene_civ");
	ai_civ disableaimassist();
	ai_civ ai::set_ignoreme(1);
	ai_civ ai::set_ignoreall(1);
	a_ai = array(ai_robot, ai_civ);
	scene::init("cin_gen_melee_robot_hits_civ", a_ai);
	level flag::wait_till("apartment_jump_down");
	wait(0.5);
	scene::play("cin_gen_melee_robot_hits_civ", a_ai);
}

/*
	Name: function_d212a60d
	Namespace: newworld_rooftops
	Checksum: 0xC7CA8EA6
	Offset: 0xE800
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_d212a60d(a_ents)
{
	level waittill(#"hash_b1604833");
	ai_civ = getent("robot_hits_civ_scene_civ_ai", "targetname");
	if(isdefined(ai_civ))
	{
		ai_civ clientfield::set("derez_ai_deaths", 1);
	}
	util::wait_network_frame();
	if(isdefined(ai_civ))
	{
		ai_civ ghost();
	}
}

/*
	Name: function_65fe4a2f
	Namespace: newworld_rooftops
	Checksum: 0xCA36AAAC
	Offset: 0xE8B0
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function function_65fe4a2f(a_ents)
{
	ai_robot = undefined;
	foreach(ent in a_ents)
	{
		if(ent.team === "axis")
		{
			ai_robot = ent;
			break;
		}
	}
	if(isdefined(ai_robot) && isalive(ai_robot))
	{
		e_goalvolume = getent("chase_bar_balcony_goalvolume", "targetname");
		ai_robot setgoal(e_goalvolume, 1);
	}
}

/*
	Name: function_59e96bfa
	Namespace: newworld_rooftops
	Checksum: 0x54BE0A8A
	Offset: 0xE9D8
	Size: 0x1A4
	Parameters: 1
	Flags: Linked
*/
function function_59e96bfa(b_starting)
{
	if(!b_starting)
	{
		level scene::init("cin_new_06_01_chase_vign_takedown");
	}
	level flag::wait_till("apartment_jump_down");
	battlechatter::function_d9f49fba(1);
	level flag::init("hall_takedown_robot");
	level flag::init("hall_takedown_robot_roll_complete");
	scene::add_scene_func("cin_new_06_01_chase_vign_takedown", &function_7c8216c3, "play");
	scene::add_scene_func("cin_new_06_01_chase_vign_takedown", &function_20fcf1cf, "play");
	scene::add_scene_func("cin_new_06_01_chase_vign_takedown", &function_aef2268d, "done");
	level thread function_6a13c1d0();
	level scene::play("cin_new_06_01_chase_vign_takedown");
	level.ai_hall ai::set_ignoreall(0);
	level.ai_hall ai::set_ignoreme(0);
}

/*
	Name: function_7c8216c3
	Namespace: newworld_rooftops
	Checksum: 0x559777E3
	Offset: 0xEB88
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function function_7c8216c3(a_ents)
{
	a_ents["hall_takedown_robot"] endon(#"death");
	a_ents["hall_takedown_robot"] thread function_1ac8d6c6();
	level waittill(#"hash_c6292c7f");
	level flag::set("hall_takedown_robot");
	util::magic_bullet_shield(a_ents["hall_takedown_robot"]);
}

/*
	Name: function_1ac8d6c6
	Namespace: newworld_rooftops
	Checksum: 0x4FC29BBA
	Offset: 0xEC20
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_1ac8d6c6()
{
	self waittill(#"death");
	level flag::wait_till("hall_takedown_robot_roll_complete");
	if(!level flag::get("hall_takedown_robot"))
	{
		level scene::stop("cin_new_06_01_chase_vign_takedown");
	}
}

/*
	Name: function_20fcf1cf
	Namespace: newworld_rooftops
	Checksum: 0xDF167C35
	Offset: 0xEC98
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_20fcf1cf(a_ents)
{
	level waittill(#"hash_47e55a4e");
	level flag::set("hall_takedown_robot_roll_complete");
}

/*
	Name: function_aef2268d
	Namespace: newworld_rooftops
	Checksum: 0x5EDC07F9
	Offset: 0xECD8
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function function_aef2268d(a_ents)
{
	if(isalive(a_ents["hall_takedown_robot"]))
	{
		util::stop_magic_bullet_shield(a_ents["hall_takedown_robot"]);
		a_ents["hall_takedown_robot"] notify(#"ai_derez_death");
		a_ents["hall_takedown_robot"] notify(#"ai_derez_death");
		a_ents["hall_takedown_robot"] clientfield::set("derez_ai_deaths", 1);
		util::wait_network_frame();
		if(isdefined(a_ents["hall_takedown_robot"]))
		{
			a_ents["hall_takedown_robot"] playsound("evt_ai_derez");
		}
		wait(0.1);
		if(isdefined(a_ents["hall_takedown_robot"]))
		{
			a_ents["hall_takedown_robot"] delete();
		}
	}
}

/*
	Name: function_b6418460
	Namespace: newworld_rooftops
	Checksum: 0xDD917A65
	Offset: 0xEE10
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_b6418460()
{
	level waittill(#"hash_c589911");
	level thread function_9d545239(1);
	level thread function_8c82b44d(2);
	level thread function_de250dc9();
}

/*
	Name: function_c3fb206c
	Namespace: newworld_rooftops
	Checksum: 0x99F4D8AC
	Offset: 0xEE78
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_c3fb206c()
{
	level waittill(#"hash_325b137a");
	level thread function_9d545239(2);
	level thread function_8c82b44d(3);
}

/*
	Name: function_ca093905
	Namespace: newworld_rooftops
	Checksum: 0xF7C2A2B7
	Offset: 0xEEC8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_ca093905()
{
	level waittill(#"hash_585d8de3");
	level thread function_9d545239(3);
	level thread function_da0e703d();
}

/*
	Name: function_6a406930
	Namespace: newworld_rooftops
	Checksum: 0x99F0EBB2
	Offset: 0xEF18
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function function_6a406930(a_ents)
{
	level waittill(#"hash_b1604833");
	foreach(ent in a_ents)
	{
		if(ent === level.ai_bomber)
		{
			continue;
			continue;
		}
		ai_civ = ent;
	}
	if(isdefined(ai_civ))
	{
		ai_civ clientfield::set("derez_ai_deaths", 1);
	}
	util::wait_network_frame();
	if(isdefined(ai_civ))
	{
		ai_civ ghost();
	}
}

/*
	Name: function_e1109a4f
	Namespace: newworld_rooftops
	Checksum: 0x8D0E575B
	Offset: 0xF030
	Size: 0xE6
	Parameters: 1
	Flags: Linked
*/
function function_e1109a4f(var_9e31a3a2)
{
	level.ai_hall endon(#"death");
	level.ai_hall cybercom::function_d240e350("cybercom_systemoverload", var_9e31a3a2, 0);
	foreach(ai_robot in var_9e31a3a2)
	{
		wait(0.25);
		if(isalive(ai_robot))
		{
			ai_robot.health = 1;
		}
	}
}

/*
	Name: rooftops_player_checkpoints
	Namespace: newworld_rooftops
	Checksum: 0x694D45D9
	Offset: 0xF120
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function rooftops_player_checkpoints()
{
	level endon(#"rooftops_terminate");
	a_e_triggers = getentarray("rooftops_bad_area", "targetname");
	foreach(e_trigger in a_e_triggers)
	{
		e_trigger thread rooftops_player_fell_off();
	}
}

/*
	Name: rooftops_player_fell_off
	Namespace: newworld_rooftops
	Checksum: 0x9E16360
	Offset: 0xF1E8
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function rooftops_player_fell_off()
{
	level endon(#"rooftops_terminate");
	a_s_teleports = struct::get_array(self.target, "targetname");
	while(true)
	{
		self waittill(#"trigger", e_who);
		if(isplayer(e_who) && (!(isdefined(e_who.var_fc8b8ec) && e_who.var_fc8b8ec)))
		{
			e_who playsoundtoplayer("evt_plr_derez", e_who);
			e_who thread function_c24ce0f9(a_s_teleports);
		}
	}
}

/*
	Name: function_c24ce0f9
	Namespace: newworld_rooftops
	Checksum: 0x3D4E5B0C
	Offset: 0xF2C0
	Size: 0x20C
	Parameters: 1
	Flags: Linked
*/
function function_c24ce0f9(a_s_teleports)
{
	self endon(#"death");
	while(true)
	{
		s_spot = array::random(a_s_teleports);
		if(!positionwouldtelefrag(s_spot.origin))
		{
			self.var_fc8b8ec = 1;
			self.ignoreme = 1;
			self enableinvulnerability();
			self ghost();
			self util::freeze_player_controls(1);
			self setorigin(s_spot.origin);
			self setplayerangles(s_spot.angles);
			self clientfield::increment_to_player("postfx_igc");
			util::wait_network_frame();
			self show();
			self clientfield::set("player_spawn_fx", 1);
			self util::delay(2, "death", &clientfield::set, "player_spawn_fx", 0);
			self thread function_befa9b05();
			wait(2);
			self disableinvulnerability();
			self util::freeze_player_controls(0);
			self.var_fc8b8ec = 0;
			self.ignoreme = 0;
			break;
		}
	}
}

/*
	Name: function_694c9886
	Namespace: newworld_rooftops
	Checksum: 0x7A2CD492
	Offset: 0xF4D8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_694c9886()
{
	self endon(#"death");
	self util::magic_bullet_shield();
	self vehicle_ai::turnoff();
	self.script_objective = "chase_glass_ceiling_igc";
	self ai::set_ignoreme(1);
	self util::set_rogue_controlled(1);
}

/*
	Name: function_e8d2d7d8
	Namespace: newworld_rooftops
	Checksum: 0xA0F26E65
	Offset: 0xF560
	Size: 0x1FC
	Parameters: 1
	Flags: Linked
*/
function function_e8d2d7d8(n_id)
{
	scene::add_scene_func("p7_fxanim_gp_wasp_tower_arms_01_bundle", &function_9895ffca, "play");
	scene::add_scene_func("p7_fxanim_gp_wasp_tower_arms_02_bundle", &function_9895ffca, "play");
	scene::add_scene_func("p7_fxanim_gp_wasp_tower_arms_03_bundle", &function_9895ffca, "play");
	scene::add_scene_func("p7_fxanim_gp_wasp_tower_arms_04_bundle", &function_9895ffca, "play");
	scene::add_scene_func("p7_fxanim_gp_wasp_tower_arms_01_bundle", &function_ce2ec89f, "done");
	scene::add_scene_func("p7_fxanim_gp_wasp_tower_arms_02_bundle", &function_ce2ec89f, "done");
	scene::add_scene_func("p7_fxanim_gp_wasp_tower_arms_03_bundle", &function_ce2ec89f, "done");
	scene::add_scene_func("p7_fxanim_gp_wasp_tower_arms_04_bundle", &function_ce2ec89f, "done");
	scene::add_scene_func("p7_fxanim_gp_wasp_tower_arms_04_bundle", &function_f489203, "done");
	var_8b599504 = struct::get("chase_wasp_tower_" + n_id);
	var_8b599504 scene::init();
}

/*
	Name: function_8c82b44d
	Namespace: newworld_rooftops
	Checksum: 0x249D69C0
	Offset: 0xF768
	Size: 0x2FE
	Parameters: 1
	Flags: Linked
*/
function function_8c82b44d(n_id)
{
	level flag::wait_till("all_players_spawned");
	switch(level.activeplayers.size)
	{
		case 1:
		{
			var_bd061860 = 3;
			break;
		}
		case 2:
		case 3:
		{
			var_bd061860 = 6;
			break;
		}
		case 4:
		{
			var_bd061860 = 8;
			break;
		}
		default:
		{
			var_bd061860 = undefined;
		}
	}
	var_7f20007c = struct::get_array(("chase_wasp_tower_" + n_id) + "_arms");
	for(i = 1; i < 5; i++)
	{
		foreach(s_scene in var_7f20007c)
		{
			if(s_scene.script_int === i)
			{
				break;
			}
		}
		a_wasps = [];
		while(a_wasps.size < 2)
		{
			if(n_id == 1 && i == 1 && a_wasps.size == 0)
			{
				ai_wasp = spawner::simple_spawn_single("chase_wasp_rocket");
				ai_wasp.targetname = "billboard_fxanim_rocket_wasp";
				ai_wasp.cybercomtargetstatusoverride = 0;
				ai_wasp.nocybercom = 1;
				a_wasps[a_wasps.size] = ai_wasp;
				var_bd061860--;
				continue;
			}
			if(var_bd061860 > 0)
			{
				ai_wasp = spawner::simple_spawn_single("chase_wasp_mg");
				ai_wasp.targetname = "chase_wasp_tower_" + n_id;
				a_wasps[a_wasps.size] = ai_wasp;
				var_bd061860--;
			}
			else
			{
				a_wasps[a_wasps.size] = util::spawn_model("tag_origin", s_scene.origin);
			}
		}
		s_scene scene::init(a_wasps);
	}
}

/*
	Name: function_9d545239
	Namespace: newworld_rooftops
	Checksum: 0x156E4EFE
	Offset: 0xFA70
	Size: 0x112
	Parameters: 1
	Flags: Linked
*/
function function_9d545239(n_id)
{
	var_8b599504 = struct::get("chase_wasp_tower_" + n_id);
	var_4c585e4 = struct::get_array(("chase_wasp_tower_" + n_id) + "_arms");
	array::add(var_4c585e4, var_8b599504);
	foreach(s_scene in var_4c585e4)
	{
		s_scene thread scene::play();
	}
}

/*
	Name: function_93cf0e75
	Namespace: newworld_rooftops
	Checksum: 0x2AD38BB5
	Offset: 0xFB90
	Size: 0x1FE
	Parameters: 1
	Flags: Linked
*/
function function_93cf0e75(n_id)
{
	var_8b599504 = struct::get("chase_wasp_tower_" + n_id);
	var_4c585e4 = struct::get_array(("chase_wasp_tower_" + n_id) + "_arms");
	array::add(var_4c585e4, var_8b599504);
	foreach(s_scene in var_4c585e4)
	{
		s_scene scene::skipto_end();
	}
	for(i = 1; i < 5; i++)
	{
		var_608b08b0 = getent(((("wasp_tower_arms_0" + i) + "_wasp_0") + i) + "_a", "targetname");
		var_608b08b0 delete();
		var_d29277eb = getent(((("wasp_tower_arms_0" + i) + "_wasp_0") + i) + "_b", "targetname");
		var_d29277eb delete();
	}
}

/*
	Name: function_9895ffca
	Namespace: newworld_rooftops
	Checksum: 0xDE1E2A43
	Offset: 0xFD98
	Size: 0x23E
	Parameters: 1
	Flags: Linked
*/
function function_9895ffca(a_ents)
{
	foreach(ent in a_ents)
	{
		if(ent.classname === "script_vehicle")
		{
			ent vehicle_ai::turnon();
			ent ai::set_ignoreme(0);
			ent thread function_26d72169();
		}
	}
	switch(self.scriptbundlename)
	{
		case "p7_fxanim_gp_wasp_tower_arms_01_bundle":
		{
			str_notify = "wasp_tower_arms_01_deploy";
			break;
		}
		case "p7_fxanim_gp_wasp_tower_arms_02_bundle":
		{
			str_notify = "wasp_tower_arms_02_deploy";
			break;
		}
		case "p7_fxanim_gp_wasp_tower_arms_03_bundle":
		{
			str_notify = "wasp_tower_arms_03_deploy";
			break;
		}
		case "p7_fxanim_gp_wasp_tower_arms_04_bundle":
		{
			str_notify = "wasp_tower_arms_04_deploy";
			break;
		}
		default:
		{
			str_notify = undefined;
			break;
		}
	}
	level waittill(str_notify);
	foreach(ent in a_ents)
	{
		if(ent.classname === "script_vehicle" && ent.targetname !== "billboard_fxanim_rocket_wasp")
		{
			ent util::stop_magic_bullet_shield();
			ent.cybercomtargetstatusoverride = 1;
		}
	}
}

/*
	Name: function_26d72169
	Namespace: newworld_rooftops
	Checksum: 0xAC834997
	Offset: 0xFFE0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_26d72169()
{
	self endon(#"death");
	self waittill(#"hash_cc44fba5");
	self clientfield::set("wasp_hack_fx", 1);
}

/*
	Name: function_ce2ec89f
	Namespace: newworld_rooftops
	Checksum: 0x950F07F4
	Offset: 0x10028
	Size: 0x1E2
	Parameters: 1
	Flags: Linked
*/
function function_ce2ec89f(a_ents)
{
	level notify(#"hash_fb8f6850");
	switch(self.targetname)
	{
		case "chase_wasp_tower_1_arms":
		{
			e_goalvolume = getent("wasp_tower_1_goalvolume", "targetname");
			break;
		}
		case "chase_wasp_tower_2_arms":
		{
			e_goalvolume = getent("wasp_tower_2_goalvolume", "targetname");
			break;
		}
		case "chase_wasp_tower_3_arms":
		{
			e_goalvolume = getent("wasp_tower_3_goalvolume", "targetname");
			break;
		}
		default:
		{
			str_notify = undefined;
			break;
		}
	}
	foreach(ent in a_ents)
	{
		if(ent.model === "tag_origin")
		{
			ent delete();
			continue;
		}
		if(ent.classname === "script_vehicle")
		{
			ent setgoal(e_goalvolume, 1);
			ent clientfield::set("wasp_hack_fx", 0);
		}
	}
}

/*
	Name: function_f489203
	Namespace: newworld_rooftops
	Checksum: 0x1B2640C0
	Offset: 0x10218
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function function_f489203(a_ents)
{
	if(self.targetname == "chase_wasp_tower_1_arms")
	{
		level notify(#"hash_ab14955f");
	}
}

/*
	Name: function_2ac6fe38
	Namespace: newworld_rooftops
	Checksum: 0x6C124B22
	Offset: 0x10250
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_2ac6fe38()
{
	scene::init("p7_fxanim_cp_newworld_chase_wasp_billboard_bundle");
	e_clip = getent("chase_wasp_billboard_clip", "targetname");
	e_clip notsolid();
}

/*
	Name: function_de250dc9
	Namespace: newworld_rooftops
	Checksum: 0x6AAF61EE
	Offset: 0x102B8
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function function_de250dc9()
{
	level waittill(#"hash_ab14955f");
	ai_wasp = getent("billboard_fxanim_rocket_wasp", "targetname");
	ai_wasp util::magic_bullet_shield();
	ai_wasp.cybercomtargetstatusoverride = 0;
	ai_wasp.nocybercom = 1;
	s_target = struct::get("chase_billboard_fxanim_org", "targetname");
	e_target = spawn("script_model", s_target.origin);
	e_target.health = 100;
	ai_wasp thread ai::shoot_at_target("shoot_until_target_dead", e_target);
	ai_wasp thread function_f85e3014(e_target);
	t_damage = getent("fxanim_billboard_damage_trigger", "targetname");
	t_damage thread function_797186a5(ai_wasp);
	level waittill(#"hash_828a35af");
	level thread function_f4151d2d();
	level scene::play("p7_fxanim_cp_newworld_chase_wasp_billboard_bundle");
}

/*
	Name: function_f85e3014
	Namespace: newworld_rooftops
	Checksum: 0xC6497114
	Offset: 0x10470
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_f85e3014(e_target)
{
	self endon(#"death");
	level waittill(#"hash_828a35af");
	wait(0.1);
	self util::stop_magic_bullet_shield();
	self.cybercomtargetstatusoverride = 1;
	self.nocybercom = 0;
	e_target delete();
}

/*
	Name: function_797186a5
	Namespace: newworld_rooftops
	Checksum: 0x9F886358
	Offset: 0x104F0
	Size: 0xC2
	Parameters: 1
	Flags: Linked
*/
function function_797186a5(ai_wasp)
{
	level endon(#"hash_828a35af");
	while(true)
	{
		self waittill(#"damage", idamage, sattacker, vdirection, vpoint, type, modelname, tagname, partname, weapon, idflags);
		if(sattacker == ai_wasp)
		{
			level notify(#"hash_828a35af");
		}
	}
}

/*
	Name: function_f4151d2d
	Namespace: newworld_rooftops
	Checksum: 0xF8D1A8CA
	Offset: 0x105C0
	Size: 0x1DE
	Parameters: 0
	Flags: Linked
*/
function function_f4151d2d()
{
	level waittill(#"hash_ae133e20");
	e_clip = getent("chase_wasp_billboard_clip", "targetname");
	e_clip solid();
	var_a80eedb1 = getent("chase_billboard_fxanim_damage_trigger", "targetname");
	a_ai = getaiarray();
	a_all_actors = arraycombine(a_ai, level.players, 1, 0);
	foreach(e_actor in a_all_actors)
	{
		if(e_actor util::is_hero())
		{
			continue;
		}
		if(e_actor istouching(var_a80eedb1))
		{
			if(isplayer(e_actor))
			{
				e_actor dodamage(e_actor.health, e_actor.origin);
				break;
				continue;
			}
			e_actor kill();
			break;
		}
	}
}

/*
	Name: glass_breaker
	Namespace: newworld_rooftops
	Checksum: 0x322B25FD
	Offset: 0x107A8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function glass_breaker()
{
	glassradiusdamage(self.origin, 50, 2000, 1500);
}

/*
	Name: function_4cd03714
	Namespace: newworld_rooftops
	Checksum: 0x887A1EB6
	Offset: 0x107E0
	Size: 0x79E
	Parameters: 8
	Flags: Linked
*/
function function_4cd03714(str_trigger_name, var_37713607, var_4b204b1c, str_flag_name, var_10057083, b_reverse = 0, b_timeout = 0, var_76f5cbe9 = 0)
{
	level endon(#"hash_bdb23e9d");
	level flag::init(str_trigger_name);
	t_trigger = getent(str_trigger_name, "targetname");
	if(isdefined(t_trigger))
	{
		trigger::wait_till(str_trigger_name);
	}
	else
	{
		level waittill(str_trigger_name);
		level thread function_dfd78ed7();
	}
	level flag::set("chase_train_move");
	level thread function_c9af9d76(var_10057083);
	var_7af45315 = [];
	var_95af8b3e = [];
	var_37048efd = struct::get(var_37713607, "targetname");
	var_5ae02fb7 = spawn("script_model", var_37048efd.origin);
	var_5ae02fb7.angles = var_37048efd.angles;
	var_5ae02fb7 setmodel(var_37048efd.model);
	var_5ae02fb7.script_objective = "chase_glass_ceiling_igc";
	var_5ae02fb7.script_noteworthy = "chase_train";
	var_5ae02fb7 playloopsound("amb_train_front_engine");
	if(var_76f5cbe9)
	{
		var_5ae02fb7 thread function_db738b68();
	}
	var_7af45315[0] = var_5ae02fb7;
	var_934a157 = struct::get(var_4b204b1c, "targetname");
	var_e5a4a905 = getent(var_37048efd.target, "targetname");
	if(var_37713607 == "train_station_train_org")
	{
		level thread function_69747207();
	}
	if(b_timeout == 1)
	{
		level thread function_a8f0457b(str_flag_name);
	}
	while(var_7af45315.size > 0)
	{
		if(!level flag::get(str_flag_name))
		{
			var_3ebf068e = spawn("script_model", var_934a157.origin);
			var_3ebf068e setmodel(var_934a157.model);
			var_3ebf068e.script_objective = "chase_glass_ceiling_igc";
			var_3ebf068e.script_noteworthy = "chase_train";
			var_3ebf068e playloopsound("amb_train_car");
			var_7af45315[var_7af45315.size] = var_3ebf068e;
			if(var_76f5cbe9)
			{
				var_3ebf068e thread function_db738b68();
			}
		}
		else if(!level flag::get(str_trigger_name))
		{
			level flag::set(str_trigger_name);
			s_end = struct::get("train_station_train_end", "targetname");
			var_3ebf068e = spawn("script_model", var_934a157.origin);
			var_3ebf068e.origin = (var_934a157.origin[0], var_934a157.origin[1], s_end.origin[2]);
			var_3ebf068e.angles = s_end.angles;
			var_3ebf068e setmodel(s_end.model);
			var_3ebf068e.script_objective = "chase_glass_ceiling_igc";
			var_3ebf068e.script_noteworthy = "chase_train";
			var_3ebf068e playloopsound("amb_train_engine");
			var_7af45315[var_7af45315.size] = var_3ebf068e;
			playsoundatposition("amb_train_fades_away", (-12413, -25844, 9837));
			if(var_76f5cbe9)
			{
				var_3ebf068e thread function_db738b68();
			}
		}
		if(b_reverse)
		{
			array::run_all(var_7af45315, &movex, 640, 0.274);
		}
		else
		{
			array::run_all(var_7af45315, &movex, -640, 0.274);
		}
		wait(0.274);
		if(var_37713607 == "train_station_train_org")
		{
			level function_4332c4dc(var_7af45315);
		}
		var_8edb1dfd = [];
		foreach(e_train in var_7af45315)
		{
			if(e_train istouching(var_e5a4a905))
			{
				var_8edb1dfd[var_8edb1dfd.size] = e_train;
			}
		}
		foreach(e_train in var_8edb1dfd)
		{
			arrayremovevalue(var_7af45315, e_train);
			e_train delete();
		}
	}
}

/*
	Name: function_a8f0457b
	Namespace: newworld_rooftops
	Checksum: 0x460CB0F1
	Offset: 0x10F88
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_a8f0457b(str_flag_name)
{
	wait(20);
	level flag::set(str_flag_name);
}

/*
	Name: function_db738b68
	Namespace: newworld_rooftops
	Checksum: 0x7600CA90
	Offset: 0x10FC0
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_db738b68()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"touch", ent);
		if(isplayer(ent))
		{
			ent dodamage(ent.health, ent.origin);
		}
	}
}

/*
	Name: function_69747207
	Namespace: newworld_rooftops
	Checksum: 0xD27C1678
	Offset: 0x11040
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_69747207()
{
	var_668efd10 = getent("train_station_gate_old_side", "targetname");
	var_668efd10 movez(-340, 0.5);
	var_d8966c4b = getent("train_station_gate_modern_side", "targetname");
	var_d8966c4b movez(-340, 0.5);
}

/*
	Name: function_4332c4dc
	Namespace: newworld_rooftops
	Checksum: 0xC63A5C4A
	Offset: 0x110F0
	Size: 0x2DC
	Parameters: 1
	Flags: Linked
*/
function function_4332c4dc(var_7af45315)
{
	if(!level flag::get("train_station_start_gate_closed"))
	{
		var_668efd10 = getent("train_station_gate_old_side", "targetname");
		t_start = getent("train_station_spawn_closet", "targetname");
		var_6d7bb3d1 = 1;
		foreach(e_train in var_7af45315)
		{
			if(e_train istouching(t_start))
			{
				var_6d7bb3d1 = 0;
				break;
			}
		}
		if(var_6d7bb3d1 == 1)
		{
			level flag::set("train_station_start_gate_closed");
			var_668efd10 movez(340, 0.5);
		}
	}
	if(!level flag::get("train_station_end_gate_closed"))
	{
		var_d8966c4b = getent("train_station_gate_modern_side", "targetname");
		var_e5a4a905 = getent("train_station_end_closet", "targetname");
		var_fe4ad5ca = 1;
		foreach(e_train in var_7af45315)
		{
			if(e_train istouching(var_e5a4a905))
			{
				var_fe4ad5ca = 0;
				break;
			}
		}
		if(var_fe4ad5ca == 1)
		{
			level flag::clear("chase_train_move");
			var_d8966c4b thread function_1b3cb751();
		}
	}
}

/*
	Name: function_1b3cb751
	Namespace: newworld_rooftops
	Checksum: 0xDCFB7AF8
	Offset: 0x113D8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_1b3cb751()
{
	if(isdefined(self.var_337d1b65) && self.var_337d1b65)
	{
		return;
	}
	self.var_337d1b65 = 1;
	self movez(340, 0.5);
	self waittill(#"movedone");
	level flag::set("train_station_end_gate_closed");
}

/*
	Name: function_dfd78ed7
	Namespace: newworld_rooftops
	Checksum: 0x1BFF29EB
	Offset: 0x11458
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_dfd78ed7()
{
	level clientfield::set("chase_pedestrian_blockers", 1);
	level thread function_b02cee6();
}

/*
	Name: function_b02cee6
	Namespace: newworld_rooftops
	Checksum: 0x27C601FB
	Offset: 0x114A0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_b02cee6()
{
	level flag::wait_till("train_station_end_gate_closed");
	level clientfield::set("chase_pedestrian_blockers", 0);
	e_clip = getent("train_ped_blocker_clip", "targetname");
	e_clip delete();
}

/*
	Name: function_c9af9d76
	Namespace: newworld_rooftops
	Checksum: 0x64540A2
	Offset: 0x11530
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function function_c9af9d76(var_10057083)
{
	level endon(#"rooftops_terminate");
	t_rumble = getent(var_10057083, "targetname");
	while(level flag::get("chase_train_move"))
	{
		t_rumble waittill(#"trigger", ent);
		if(isplayer(ent) && (!(isdefined(ent.var_c9af9d76) && ent.var_c9af9d76)))
		{
			ent clientfield::set_to_player("chase_train_rumble", 1);
			ent thread function_cdd68ba3(t_rumble);
		}
	}
	level thread function_382f4206();
}

/*
	Name: function_cdd68ba3
	Namespace: newworld_rooftops
	Checksum: 0xA8CD8D1
	Offset: 0x11648
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function function_cdd68ba3(t_rumble)
{
	self endon(#"death");
	level endon(#"rooftops_terminate");
	self.var_c9af9d76 = 1;
	while(true)
	{
		if(!self istouching(t_rumble))
		{
			self clientfield::set_to_player("chase_train_rumble", 0);
			break;
		}
		wait(0.05);
	}
	self.var_c9af9d76 = 0;
}

/*
	Name: function_382f4206
	Namespace: newworld_rooftops
	Checksum: 0x333C4838
	Offset: 0x116E0
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function function_382f4206()
{
	foreach(player in level.activeplayers)
	{
		if(isdefined(player.var_c9af9d76) && player.var_c9af9d76)
		{
			player clientfield::set_to_player("chase_train_rumble", 0);
		}
	}
}

/*
	Name: function_699bfff1
	Namespace: newworld_rooftops
	Checksum: 0x4292CFE4
	Offset: 0x117A8
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_699bfff1(b_play)
{
	if(b_play)
	{
		level clientfield::set("crane_fxanim", 1);
	}
	else
	{
		level clientfield::set("crane_fxanim", 0);
	}
}

/*
	Name: function_660e6b31
	Namespace: newworld_rooftops
	Checksum: 0x339CD7A6
	Offset: 0x11808
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_660e6b31(b_play)
{
	if(b_play)
	{
		level clientfield::set("spinning_vent_fxanim", 1);
	}
	else
	{
		level clientfield::set("spinning_vent_fxanim", 0);
	}
}

/*
	Name: function_fb28b377
	Namespace: newworld_rooftops
	Checksum: 0x6A150A0D
	Offset: 0x11868
	Size: 0x128
	Parameters: 1
	Flags: Linked
*/
function function_fb28b377(str_script_noteworthy)
{
	level endon(#"rooftops_terminate");
	var_dc7c1178 = getvehiclespawnerarray(str_script_noteworthy, "script_noteworthy");
	nd_start = getvehiclenode(str_script_noteworthy, "targetname");
	wait(randomfloatrange(2, 10));
	while(true)
	{
		sp_vehicle = array::random(var_dc7c1178);
		str_targetname = sp_vehicle.targetname;
		veh_car = vehicle::simple_spawn_single(str_targetname);
		veh_car thread function_f579b429(nd_start);
		wait(randomfloatrange(10, 20));
	}
}

/*
	Name: function_f579b429
	Namespace: newworld_rooftops
	Checksum: 0x565609CD
	Offset: 0x11998
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_f579b429(nd_start)
{
	self vehicle::get_on_and_go_path(nd_start);
	self delete();
}

/*
	Name: function_28aaa11a
	Namespace: newworld_rooftops
	Checksum: 0x5AFD93C1
	Offset: 0x119E0
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function function_28aaa11a(n_time)
{
	level notify(#"hash_a70b0538");
	level endon(#"hash_a70b0538");
	level thread function_ec83170f();
	level thread function_f752dce5(n_time, "chase_avoid_fail_condition");
	wait(n_time);
	/#
		if(level.players.size == 1 && isgodmode(level.players[0]))
		{
			return;
		}
	#/
	level thread function_9e93135c();
	util::missionfailedwrapper_nodeath(&"CP_MI_ZURICH_NEWWORLD_SUSPECT_GOT_AWAY", &"CP_MI_ZURICH_NEWWORLD_SUSPECT_FAIL_HINT");
}

/*
	Name: function_ec83170f
	Namespace: newworld_rooftops
	Checksum: 0xEE99877D
	Offset: 0x11AC0
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function function_ec83170f()
{
	level endon(#"hash_a70b0538");
	level.var_c37e4ef3 = 1;
	wait(10);
	level.var_c37e4ef3 = undefined;
}

/*
	Name: function_25e57b80
	Namespace: newworld_rooftops
	Checksum: 0xAD1D29A5
	Offset: 0x11AF8
	Size: 0x102
	Parameters: 1
	Flags: Linked
*/
function function_25e57b80(params)
{
	if(!isdefined(level.var_f2a5cb1e))
	{
		return;
	}
	var_273033a9 = 1;
	foreach(player in level.activeplayers)
	{
		if(distance(player.origin, level.var_f2a5cb1e[0].origin) < 2500)
		{
			var_273033a9 = 0;
			break;
		}
	}
	if(var_273033a9 == 1)
	{
		level notify(#"hash_a70b0538");
	}
}

/*
	Name: function_f423f05a
	Namespace: newworld_rooftops
	Checksum: 0x539204D2
	Offset: 0x11C08
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_f423f05a(str_objective)
{
	level.ai_hall = util::get_hero("hall");
	level.ai_hall ai::set_behavior_attribute("sprint", 1);
	level.ai_hall ai::set_behavior_attribute("useGrenades", 0);
	level.ai_hall thread newworld_util::function_921d7387();
	skipto::teleport_ai(str_objective);
}

/*
	Name: function_3936e284
	Namespace: newworld_rooftops
	Checksum: 0x1D55BB95
	Offset: 0x11CB8
	Size: 0x18
	Parameters: 0
	Flags: Linked
*/
function function_3936e284()
{
	if(isdefined(level.var_c37e4ef3))
	{
		return true;
	}
	return false;
}

