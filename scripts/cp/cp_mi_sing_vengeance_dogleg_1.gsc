// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_debug;
#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_sing_vengeance_accolades;
#using scripts\cp\cp_mi_sing_vengeance_quadtank_alley;
#using scripts\cp\cp_mi_sing_vengeance_sound;
#using scripts\cp\cp_mi_sing_vengeance_util;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\stealth;
#using scripts\shared\stealth_aware;
#using scripts\shared\stealth_level;
#using scripts\shared\stealth_status;
#using scripts\shared\stealth_vo;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace vengeance_dogleg_1;

/*
	Name: skipto_dogleg_1_init
	Namespace: vengeance_dogleg_1
	Checksum: 0xA9C2F9A2
	Offset: 0x1308
	Size: 0x24C
	Parameters: 2
	Flags: Linked
*/
function skipto_dogleg_1_init(str_objective, b_starting)
{
	level thread cafe_burning_setup();
	if(b_starting)
	{
		load::function_73adcefc();
		vengeance_util::skipto_baseline(str_objective, b_starting);
		vengeance_util::init_hero("hendricks", str_objective);
		callback::on_spawned(&vengeance_util::give_hero_weapon);
		level.ai_hendricks ai::set_ignoreall(1);
		level.ai_hendricks ai::set_ignoreme(1);
		level.ai_hendricks colors::disable();
		level.ai_hendricks.goalradius = 32;
		level.ai_hendricks setgoal(level.ai_hendricks.origin);
		vengeance_util::function_e00864bd("dogleg_1_umbra_gate", 1, "dogleg_1_gate");
		objectives::set("cp_level_vengeance_rescue_kane");
		objectives::set("cp_level_vengeance_go_to_safehouse");
		objectives::hide("cp_level_vengeance_go_to_safehouse");
		level thread namespace_9fd035::function_dad71f51("tension_loop_2");
		level.var_4c62d05f = level.players[0];
		scene::init("cin_ven_04_10_cafedoor_1st_sh010");
		util::set_streamer_hint(3);
		load::function_a2995f22();
	}
	vengeance_util::function_4e8207e9("dogleg_1");
	dogleg_1_main(str_objective, b_starting);
}

/*
	Name: dogleg_1_main
	Namespace: vengeance_dogleg_1
	Checksum: 0xFBD9BF4B
	Offset: 0x1560
	Size: 0x35A
	Parameters: 2
	Flags: Linked
*/
function dogleg_1_main(str_objective, b_starting)
{
	level flag::set("dogleg_1_begin");
	level thread function_254de1e5();
	function_e17e849c();
	stealth::reset();
	namespace_523da15d::function_e887345e();
	namespace_523da15d::function_eda4634d();
	level thread function_7272ed9d();
	level thread function_4326839a();
	level.var_831ab6b2 = struct::get("quadtank_alley_intro_org");
	level.var_831ab6b2 scene::init("cin_ven_04_30_quadalleydoor_1st");
	level thread function_6236563e();
	level.dogleg_1_patroller_spawners = spawner::simple_spawn("dogleg_1_patroller_spawners", &vengeance_util::setup_patroller);
	level thread dogleg_1_vo(b_starting);
	level thread function_1909c582();
	level thread function_6fdd2184();
	level thread cafe_molotov_setup();
	level thread function_842de716();
	level.lineup_kill_scripted_node = struct::get("lineup_kill_scripted_node", "targetname");
	level.lineup_kill_scripted_node thread scene::init("cin_ven_03_20_storelineup_vign_exit");
	storelineup_door3_clip = getent("storelineup_door3_clip", "targetname");
	if(isdefined(storelineup_door3_clip))
	{
		storelineup_door3_clip solid();
		storelineup_door3_clip disconnectpaths();
	}
	var_eac6b54b = getent("storelineup_door3_open_clip", "targetname");
	var_eac6b54b delete();
	triggers = getentarray("dogleg_1_stealth_checkpoint_trigger", "targetname");
	foreach(trigger in triggers)
	{
		trigger thread vengeance_util::function_f9c94344();
	}
}

/*
	Name: function_254de1e5
	Namespace: vengeance_dogleg_1
	Checksum: 0xDFD89CF4
	Offset: 0x18C8
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function function_254de1e5()
{
	a_allies = getaiteamarray("allies");
	foreach(ally in a_allies)
	{
		if(isdefined(ally.remote_owner))
		{
			ally delete();
		}
	}
}

/*
	Name: function_e17e849c
	Namespace: vengeance_dogleg_1
	Checksum: 0xCA4D83D7
	Offset: 0x1998
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function function_e17e849c()
{
	level.var_5abaf57 = struct::get("dogleg_1_intro_org");
	vengeance_util::co_op_teleport_on_igc_end("cin_ven_04_10_cafedoor_1st_sh100", "cafe_igc_teleport");
	level thread function_798b0fec();
	level thread function_d45f757d();
	if(isdefined(level.bzm_vengeancedialogue4callback))
	{
		level thread [[level.bzm_vengeancedialogue4callback]]();
	}
	level.var_5abaf57 thread scene::play("cin_ven_04_10_cafedoor_1st_sh010", level.var_4c62d05f);
	level.ai_hendricks thread setup_dogleg_1_hendricks();
	level waittill(#"hash_a60d391c");
	level thread cafe_execution_setup();
	level thread function_e9e34547();
	level waittill(#"hash_2b965a47");
	if(isdefined(level.bzm_vengeancedialogue5callback))
	{
		level thread [[level.bzm_vengeancedialogue5callback]]();
	}
	level thread namespace_9fd035::function_dad71f51("tension_loop_2");
	foreach(player in level.players)
	{
		player thread function_fd7fd40d();
	}
	util::clear_streamer_hint();
	savegame::checkpoint_save();
}

/*
	Name: function_fd7fd40d
	Namespace: vengeance_dogleg_1
	Checksum: 0x7A9F8156
	Offset: 0x1BA0
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_fd7fd40d()
{
	self endon(#"death");
	self endon(#"disconnect");
	self thread function_8e0d7da8();
	weap = getweapon("ar_marksman_veng_hero_weap");
	if(!self hasweapon(weap))
	{
		self giveweapon(weap);
	}
	self switchtoweaponimmediate(weap);
	self thread vengeance_util::function_12a1b6a0();
}

/*
	Name: function_8e0d7da8
	Namespace: vengeance_dogleg_1
	Checksum: 0x8431ECAA
	Offset: 0x1C60
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_8e0d7da8()
{
	self endon(#"death");
	self endon(#"disconnect");
	self hideviewmodel();
	weap = getweapon("ar_marksman_veng_hero_weap");
	wait(0.15);
	self showviewmodel();
}

/*
	Name: function_798b0fec
	Namespace: vengeance_dogleg_1
	Checksum: 0x10C77771
	Offset: 0x1CD8
	Size: 0x274
	Parameters: 0
	Flags: Linked
*/
function function_798b0fec()
{
	level endon(#"hash_2b965a47");
	level dialog::remote("tayr_you_don_t_understand_1", 0, "no_dni");
	level thread namespace_9fd035::function_862430bd();
	util::clientnotify("sndLRstop");
	level notify(#"hash_15e32f84");
	level.ai_hendricks waittill(#"hash_a89f76ac");
	level.ai_hendricks vengeance_util::function_5fbec645("hend_you_sold_us_out_you_0");
	level dialog::remote("tayr_i_told_the_truth_0", 0, "no_dni");
	level dialog::remote("tayr_behind_a_slick_corpo_0", 0, "no_dni");
	level dialog::remote("tayr_experiments_that_wou_0", 0, "no_dni");
	level dialog::remote("tayr_ask_yourself_who_s_0", 0, "no_dni");
	level dialog::remote("tayr_the_people_who_survi_0", 0, "no_dni");
	level dialog::remote("tayr_or_the_fucking_suits_0", 0, "no_dni");
	level dialog::remote("tayr_the_immortals_built_0", 0, "no_dni");
	level dialog::remote("tayr_maybe_they_want_reve_0", 0, "no_dni");
	level dialog::remote("tayr_maybe_they_just_want_0", 0, "no_dni");
	level dialog::remote("tayr_either_way_you_can_0", 0, "no_dni");
	level dialog::remote("hend_taylor_taylor_0", 0, "no_dni");
	dialog::player_say("plyr_kane_how_the_hell_0");
}

/*
	Name: function_d45f757d
	Namespace: vengeance_dogleg_1
	Checksum: 0xB1BC4303
	Offset: 0x1F58
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_d45f757d()
{
	level waittill(#"hash_73c7894d");
	var_58cff577 = getent("molotov_civilian", "targetname");
	if(isdefined(var_58cff577))
	{
		var_58cff577 thread vengeance_util::set_civilian_on_fire();
	}
	var_b2db52d7 = getent("molotov_civilian2", "targetname");
	if(isdefined(var_b2db52d7))
	{
		var_b2db52d7 thread vengeance_util::set_civilian_on_fire();
	}
	var_8cd8d86e = getent("molotov_civilian3", "targetname");
	if(isdefined(var_8cd8d86e))
	{
		var_8cd8d86e thread vengeance_util::set_civilian_on_fire();
	}
}

/*
	Name: function_842de716
	Namespace: vengeance_dogleg_1
	Checksum: 0x8DA5B2D8
	Offset: 0x2068
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_842de716()
{
	var_a47f76cc = getent("dogleg_1_entrance_door_clip", "targetname");
	if(isdefined(var_a47f76cc))
	{
		var_a47f76cc notsolid();
		var_a47f76cc connectpaths();
		wait(0.05);
		var_a47f76cc delete();
	}
}

/*
	Name: function_7272ed9d
	Namespace: vengeance_dogleg_1
	Checksum: 0x74E85E1A
	Offset: 0x2100
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function function_7272ed9d()
{
	var_e6aec0a = getentarray("killing_streets_lineup_kill_ai_blockers", "targetname");
	foreach(ent in var_e6aec0a)
	{
		ent notsolid();
		ent connectpaths();
		wait(0.05);
		ent delete();
	}
}

/*
	Name: setup_dogleg_1_hendricks
	Namespace: vengeance_dogleg_1
	Checksum: 0x83524E3C
	Offset: 0x21F8
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function setup_dogleg_1_hendricks()
{
	self endon(#"death");
	self ai::set_ignoreall(1);
	self ai::set_ignoreme(1);
	self colors::disable();
	self ai::set_behavior_attribute("cqb", 1);
	self.goalradius = 32;
	self setgoal(self.origin);
	self waittill(#"hash_8e639ede");
	self delete();
}

/*
	Name: function_4326839a
	Namespace: vengeance_dogleg_1
	Checksum: 0x422D82A4
	Offset: 0x22C0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_4326839a()
{
	level.var_4326839a = spawner::simple_spawn("dogleg_1_wasps", &function_b5dfff73);
	level.var_4843e321 = level.var_4326839a.size;
	namespace_523da15d::function_cae14a51();
}

/*
	Name: function_b5dfff73
	Namespace: vengeance_dogleg_1
	Checksum: 0x1DD5D0B8
	Offset: 0x2320
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_b5dfff73()
{
	var_a896d541 = getent("dogleg_1_wasp_gv", "targetname");
	if(isdefined(var_a896d541))
	{
		self clearforcedgoal();
		self cleargoalvolume();
		self setgoal(var_a896d541);
	}
}

/*
	Name: cafe_execution_setup
	Namespace: vengeance_dogleg_1
	Checksum: 0x14F242F5
	Offset: 0x23A8
	Size: 0x1DC
	Parameters: 0
	Flags: Linked
*/
function cafe_execution_setup()
{
	level.cafe_execution_org = struct::get("cafe_execution_org");
	spawner::add_spawn_function_group("cafe_execution_civ_spawners", "script_noteworthy", &cafe_execution_civ_spawn_func);
	spawner::add_spawn_function_group("cafe_execution_thug_spawners", "script_noteworthy", &cafe_exeuction_thug_spawn_func);
	spawner::add_spawn_function_group("cafe_execution_thug_spawners", "script_noteworthy", &cafe_exeuction_thug_death_watcher_spawn_func);
	level.cafe_execution_org scene::init("cin_ven_04_20_cafeexecution_vign_intro");
	while(!level scene::is_ready("cin_ven_04_20_cafeexecution_vign_intro"))
	{
		wait(0.05);
	}
	level.var_f7d1a350 = getent("cafe_execution_54i_thug_a_ai", "targetname", 1);
	level.var_3848e5e1 = getent("cafe_execution_civ_01_ai", "targetname", 1);
	level.var_1836a85c = getent("cafe_execution_civ_02_ai", "targetname", 1);
	level.var_f6f4fc0b = getent("cafe_execution_civ_03_ai", "targetname", 1);
	level thread function_dbe2f523();
}

/*
	Name: cafe_execution_civ_spawn_func
	Namespace: vengeance_dogleg_1
	Checksum: 0x5EDD5EE4
	Offset: 0x2590
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function cafe_execution_civ_spawn_func()
{
	self endon(#"death");
	self.team = "allies";
	self ai::set_ignoreme(1);
	self ai::set_ignoreall(1);
	self ai::set_behavior_attribute("panic", 0);
	self.health = 1;
	self util::waittill_either("try_to_escape", "kill_me");
	if(!level flag::get("cafe_execution_thug_dead"))
	{
		self.takedamage = 1;
		self.skipdeath = 1;
		self.allowdeath = 1;
		self kill();
	}
	else
	{
		self stopanimscripted();
		self.civilian = 1;
		self ai::set_ignoreme(0);
		self ai::set_ignoreall(0);
		self animation::play(self.script_parameters, level.cafe_execution_org.origin, level.cafe_execution_org.angles);
		if(isdefined(self.target))
		{
			node = getnode(self.target, "targetname");
			self thread vengeance_util::delete_ai_at_path_end(node);
		}
		self ai::set_behavior_attribute("panic", 1);
	}
}

/*
	Name: cafe_exeuction_thug_spawn_func
	Namespace: vengeance_dogleg_1
	Checksum: 0xD48AF6CE
	Offset: 0x27A8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function cafe_exeuction_thug_spawn_func()
{
	self endon(#"death");
	self waittill(#"alert");
	level.cafe_execution_org scene::play("cin_ven_04_20_cafeexecution_vign_intro");
}

/*
	Name: cafe_exeuction_thug_death_watcher_spawn_func
	Namespace: vengeance_dogleg_1
	Checksum: 0x6FF80127
	Offset: 0x27F0
	Size: 0xC6
	Parameters: 0
	Flags: Linked
*/
function cafe_exeuction_thug_death_watcher_spawn_func()
{
	self waittill(#"death");
	level flag::set("cafe_execution_thug_dead");
	for(i = 1; i < 6; i++)
	{
		guy = getent(("cafe_execution_civ_0" + i) + "_ai", "targetname");
		if(isdefined(guy) && isalive(guy))
		{
			guy notify(#"try_to_escape");
		}
	}
}

/*
	Name: function_dbe2f523
	Namespace: vengeance_dogleg_1
	Checksum: 0xDA523C9D
	Offset: 0x28C0
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function function_dbe2f523()
{
	level.var_f7d1a350 endon(#"death");
	level.var_3848e5e1 endon(#"death");
	level.var_1836a85c endon(#"death");
	level.var_f6f4fc0b endon(#"death");
	level.var_f7d1a350 endon(#"alert");
	level.var_f7d1a350 endon(#"hash_da6a4775");
	trigger = getent("cafeexecution_vign_vo_trigger", "targetname");
	trigger waittill(#"trigger");
	level.var_f7d1a350 vengeance_util::function_5fbec645("ffim1_all_your_money_won_t_1");
	wait(0.5);
	level.var_f7d1a350 vengeance_util::function_5fbec645("ffim2_laughter_2");
	wait(0.5);
	level.var_3848e5e1 vengeance_util::function_5fbec645("mciv_stoooop_noooooo_0");
	wait(1);
	level.var_1836a85c vengeance_util::function_5fbec645("mciv_let_me_go_please_0");
	wait(0.5);
	level.var_f7d1a350 vengeance_util::function_5fbec645("ffim3_laughter_3");
}

/*
	Name: cafe_burning_setup
	Namespace: vengeance_dogleg_1
	Checksum: 0x864D161F
	Offset: 0x2A28
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function cafe_burning_setup()
{
	level.cafe_burning_org = struct::get("cafe_burning_org");
	spawner::add_spawn_function_group("cafe_burning_54i_thug_a", "targetname", &function_8b8b9516);
	spawner::add_spawn_function_group("cafe_burning_54i_thug_b", "targetname", &function_97ac3293);
	spawner::add_spawn_function_group("cafe_burning_civ_01", "targetname", &cafe_burning_civ_spawn_func);
	spawner::add_spawn_function_group("cafe_burning_civ_02", "targetname", &cafe_burning_civ_spawn_func);
	spawner::add_spawn_function_group("cafe_burning_civ_03", "targetname", &cafe_burning_civ_spawn_func);
	scene::add_scene_func("cin_ven_04_20_cafeburning_vign_loop", &function_924af258, "init", 1);
	level.cafe_burning_org scene::init("cin_ven_04_20_cafeburning_vign_loop");
}

/*
	Name: function_e9e34547
	Namespace: vengeance_dogleg_1
	Checksum: 0x8B9160FB
	Offset: 0x2BA0
	Size: 0x27C
	Parameters: 0
	Flags: Linked
*/
function function_e9e34547()
{
	scene::add_scene_func("cin_ven_04_20_cafeburning_vign_loop", &function_924af258, "play");
	level.cafe_burning_org thread scene::play("cin_ven_04_20_cafeburning_vign_loop");
	wait(1);
	level.var_b6fadac7 = getent("cafe_burning_54i_thug_a_ai", "targetname", 1);
	level.var_2e6fdc0e = getent("cafe_burning_54i_thug_b_ai", "targetname", 1);
	level.var_3a5715c2 = getent("cafe_burning_civ_01_ai", "targetname", 1);
	level.var_4e5d9a0c = getent("cafe_burning_civ_02_ai", "targetname", 1);
	level.var_96a3037b = getent("cafe_burning_civ_03_ai", "targetname", 1);
	level thread function_558e4ac8();
	level.var_b6fadac7 thread vengeance_util::function_394ba9b5(level.var_2e6fdc0e);
	level.var_2e6fdc0e thread vengeance_util::function_394ba9b5(level.var_b6fadac7);
	level.var_b6fadac7 thread vengeance_util::function_d468b73d("death", array(level.var_3a5715c2, level.var_96a3037b, level.var_4e5d9a0c), "cafe_burning_check_for_escape");
	enemy_array = [];
	enemy_array[0] = level.var_b6fadac7;
	enemy_array[1] = level.var_2e6fdc0e;
	level.var_3a5715c2 thread function_dc4e86b5(enemy_array);
	level.var_96a3037b thread function_dc4e86b5(enemy_array);
	level.var_4e5d9a0c thread function_dc4e86b5(enemy_array);
}

/*
	Name: function_558e4ac8
	Namespace: vengeance_dogleg_1
	Checksum: 0x87FD3BC4
	Offset: 0x2E28
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function function_558e4ac8()
{
	level.var_b6fadac7 endon(#"death");
	level.var_2e6fdc0e endon(#"death");
	level.var_3a5715c2 endon(#"death");
	level.var_4e5d9a0c endon(#"death");
	level.var_96a3037b endon(#"death");
	level.var_b6fadac7 endon(#"alert");
	level.var_2e6fdc0e endon(#"alert");
	level.var_b6fadac7 endon(#"hash_da6a4775");
	level.var_2e6fdc0e endon(#"hash_da6a4775");
	trigger = getent("cafeburning_vign_vo_trigger", "targetname");
	trigger waittill(#"trigger");
	level.var_b6fadac7 vengeance_util::function_5fbec645("ffim1_now_we_re_the_ones_w_1");
	wait(1);
	level.var_2e6fdc0e vengeance_util::function_5fbec645("ffim2_laughter_3");
	wait(1);
	level.var_3a5715c2 vengeance_util::function_5fbec645("mciv_no_please_noooooo_0");
	wait(1.5);
	level.var_96a3037b vengeance_util::function_5fbec645("mciv_stop_i_have_childre_0");
	wait(0.5);
	level.var_b6fadac7 vengeance_util::function_5fbec645("ffim1_your_children_will_j_0");
	wait(0.5);
	level.var_2e6fdc0e vengeance_util::function_5fbec645("ffim3_laughter_3");
}

/*
	Name: function_924af258
	Namespace: vengeance_dogleg_1
	Checksum: 0xFC07D4DA
	Offset: 0x2FE8
	Size: 0x122
	Parameters: 2
	Flags: Linked
*/
function function_924af258(a_ents, hide_me)
{
	if(isdefined(hide_me))
	{
		foreach(ent in a_ents)
		{
			ent hide();
		}
	}
	else
	{
		foreach(ent in a_ents)
		{
			ent show();
		}
	}
}

/*
	Name: function_8b8b9516
	Namespace: vengeance_dogleg_1
	Checksum: 0x1234DC46
	Offset: 0x3118
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function function_8b8b9516()
{
	self endon(#"death");
	self ai::set_behavior_attribute("can_melee", 0);
	var_ccf9b73f = util::spawn_anim_model("p7_ven_gascan_static");
	var_ccf9b73f linkto(self, "tag_weapon_chest", (0, 0, 0), (0, 0, 0));
	self thread function_78c388c0(var_ccf9b73f);
	self thread vengeance_util::function_57b69bd6(var_ccf9b73f);
	self waittill(#"hash_da6a4775");
	if(isdefined(self.silenced) && self.silenced)
	{
		return;
	}
	self stopanimscripted();
}

/*
	Name: function_78c388c0
	Namespace: vengeance_dogleg_1
	Checksum: 0xBBE243B
	Offset: 0x3208
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_78c388c0(var_ccf9b73f)
{
	function_3f42ba98(var_ccf9b73f);
}

/*
	Name: function_3f42ba98
	Namespace: vengeance_dogleg_1
	Checksum: 0xF0057C6F
	Offset: 0x3238
	Size: 0x338
	Parameters: 1
	Flags: Linked
*/
function function_3f42ba98(var_ccf9b73f)
{
	self endon(#"death");
	self endon(#"hash_da6a4775");
	self endon(#"alert");
	while(true)
	{
		level waittill(#"hash_e239447e");
		playfxontag(level._effect["fx_fuel_pour_far_ven"], var_ccf9b73f, "tag_fx");
		level waittill(#"hash_bc36ca15");
		playfxontag(level._effect["fx_fuel_pour_far_ven"], var_ccf9b73f, "tag_fx");
		level waittill(#"hash_96344fac");
		playfxontag(level._effect["fx_fuel_pour_far_ven"], var_ccf9b73f, "tag_fx");
		level waittill(#"hash_7031d543");
		playfxontag(level._effect["fx_fuel_pour_far_ven"], var_ccf9b73f, "tag_fx");
		level waittill(#"hash_4a2f5ada");
		playfxontag(level._effect["fx_fuel_pour_far_ven"], var_ccf9b73f, "tag_fx");
		level waittill(#"hash_242ce071");
		playfxontag(level._effect["fx_fuel_pour_far_ven"], var_ccf9b73f, "tag_fx");
		level waittill(#"hash_fe2a6608");
		playfxontag(level._effect["fx_fuel_pour_far_ven"], var_ccf9b73f, "tag_fx");
		level waittill(#"hash_d827eb9f");
		playfxontag(level._effect["fx_fuel_pour_far_ven"], var_ccf9b73f, "tag_fx");
		level waittill(#"hash_b2257136");
		playfxontag(level._effect["fx_fuel_pour_far_ven"], var_ccf9b73f, "tag_fx");
		level waittill(#"hash_be9dc60a");
		playfxontag(level._effect["fx_fuel_pour_far_ven"], var_ccf9b73f, "tag_fx");
		level waittill(#"hash_e4a04073");
		playfxontag(level._effect["fx_fuel_pour_far_ven"], var_ccf9b73f, "tag_fx");
		level waittill(#"hash_7298d138");
		playfxontag(level._effect["fx_fuel_pour_far_ven"], var_ccf9b73f, "tag_fx");
	}
}

/*
	Name: function_97ac3293
	Namespace: vengeance_dogleg_1
	Checksum: 0x8A90379F
	Offset: 0x3578
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function function_97ac3293()
{
	self endon(#"death");
	self thread watch_for_death();
	wait(0.2);
	self thread function_a44271e3();
	self util::waittill_any("alert", "fake_alert");
	level notify(#"hash_f4512440");
	if(isdefined(self.silenced) && self.silenced)
	{
		return;
	}
	level.cafe_burning_org thread scene::play("cin_ven_04_20_cafeburning_vign_main");
	self waittill(#"cafe_burning_match_thrown");
	level flag::set("cafe_burning_match_thrown");
	self.allowdeath = 1;
}

/*
	Name: function_a44271e3
	Namespace: vengeance_dogleg_1
	Checksum: 0xB6696FC3
	Offset: 0x3668
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_a44271e3()
{
	level endon(#"hash_e9ff59d5");
	while(isalive(self))
	{
		var_dd18437 = getent("cafe_burning_flare", "targetname", 1);
		if(isdefined(var_dd18437))
		{
			break;
		}
		wait(0.05);
	}
	if(!isalive(self) && !isdefined(var_dd18437))
	{
		level.cafe_burning_org scene::stop("cin_ven_04_20_cafeburning_vign_loop");
	}
	else
	{
		self thread vengeance_util::function_1ed65aa(array(var_dd18437));
	}
}

/*
	Name: watch_for_death
	Namespace: vengeance_dogleg_1
	Checksum: 0xB258248A
	Offset: 0x3760
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function watch_for_death()
{
	self waittill(#"death");
	level notify(#"hash_22b8c948");
}

/*
	Name: cafe_burning_civ_spawn_func
	Namespace: vengeance_dogleg_1
	Checksum: 0x215B0036
	Offset: 0x3788
	Size: 0x23C
	Parameters: 0
	Flags: Linked
*/
function cafe_burning_civ_spawn_func()
{
	self endon(#"death");
	self.team = "allies";
	self ai::set_ignoreme(1);
	self ai::set_ignoreall(1);
	self ai::set_behavior_attribute("panic", 0);
	self.health = 1;
	self.goalradius = 32;
	msg = level util::waittill_any_return("cafeburning_flare_enemy_alert", "cafeburning_flare_enemy_dead");
	if(msg == "cafeburning_flare_enemy_dead")
	{
		self stopanimscripted();
		self.civilian = 1;
		self ai::set_ignoreme(0);
		self ai::set_ignoreall(0);
		level.cafe_burning_org scene::play(self.script_parameters);
		if(isdefined(self.target))
		{
			node = getnode(self.target, "targetname");
			self thread vengeance_util::delete_ai_at_path_end(node, undefined, undefined, 1024);
		}
		self ai::set_behavior_attribute("panic", 1);
	}
	else
	{
		self waittill(#"cafe_burning_check_for_escape");
		playsoundatposition("evt_civ_group_burn", (21564, -86, 136));
		self vengeance_util::set_civilian_on_fire(0);
		self vengeance_util::set_civilian_on_fire(0);
		self vengeance_util::set_civilian_on_fire(0);
	}
}

/*
	Name: function_dc4e86b5
	Namespace: vengeance_dogleg_1
	Checksum: 0x34BEDEE1
	Offset: 0x39D0
	Size: 0xEA
	Parameters: 1
	Flags: Linked
*/
function function_dc4e86b5(enemy_array)
{
	level endon(#"hash_e9ff59d5");
	level endon(#"hash_8a3b89d3");
	self waittill(#"damage", damage, attacker);
	if(isplayer(attacker))
	{
		foreach(enemy in enemy_array)
		{
			if(isdefined(enemy))
			{
				enemy thread stealth_level::function_959a64c9();
			}
		}
	}
}

/*
	Name: cafe_molotov_setup
	Namespace: vengeance_dogleg_1
	Checksum: 0xEF5E150B
	Offset: 0x3AC8
	Size: 0x5F4
	Parameters: 0
	Flags: Linked
*/
function cafe_molotov_setup()
{
	level endon(#"hash_e9ff59d5");
	level.cafe_molotov_org = struct::get("cafe_molotov_org");
	spawner::add_spawn_function_group("cafe_molotov_civ_spawners", "script_noteworthy", &function_147bbbbf);
	var_932d1fc6 = [];
	var_932d1fc6[0] = spawner::simple_spawn_single("cafe_molotov_thug_a", undefined, undefined, undefined, undefined, undefined, undefined, 1);
	var_932d1fc6[1] = util::spawn_anim_model("p7_emergency_flare");
	var_932d1fc6[2] = util::spawn_anim_model("p7_bottle_glass_liquor_03");
	var_932d1fc6[3] = util::spawn_anim_model("p7_bottle_glass_liquor_03");
	var_932d1fc6[4] = util::spawn_anim_model("p7_bottle_glass_liquor_03");
	var_932d1fc6[5] = util::spawn_anim_model("p7_bottle_glass_liquor_03");
	a_objects = [];
	a_objects[0] = var_932d1fc6[1];
	a_objects[1] = var_932d1fc6[2];
	a_objects[2] = var_932d1fc6[3];
	a_objects[3] = var_932d1fc6[4];
	a_objects[4] = var_932d1fc6[5];
	wait(0.2);
	level.cafe_molotov_org thread scene::play("cin_ven_04_20_cafemolotovflush_vign_intro", var_932d1fc6);
	wait(0.2);
	var_932d1fc6[0] thread vengeance_util::function_7122594d(a_objects);
	wait(14);
	level.cafe_molotov_org thread scene::play("cin_ven_04_20_cafemolotovflush_vign_civa");
	wait(0.05);
	guy = getent("cafe_molotov_civ_01_ai", "targetname");
	if(isdefined(guy))
	{
		guy thread vengeance_util::set_civilian_on_fire();
	}
	wait(randomfloatrange(4, 8));
	level.cafe_molotov_org thread scene::play("cin_ven_04_20_cafemolotovflush_vign_civb");
	wait(0.05);
	guy = getent("cafe_molotov_civ_02_ai", "targetname");
	if(isdefined(guy))
	{
		guy thread vengeance_util::set_civilian_on_fire();
	}
	wait(randomfloatrange(4, 8));
	level.cafe_molotov_org thread scene::play("cin_ven_04_20_cafemolotovflush_vign_civc");
	wait(0.05);
	guy = getent("cafe_molotov_civ_03_ai", "targetname");
	if(isdefined(guy))
	{
		guy thread vengeance_util::set_civilian_on_fire();
	}
	wait(randomfloatrange(4, 8));
	level.cafe_molotov_org thread scene::play("cin_ven_04_20_cafemolotovflush_vign_civd");
	wait(0.05);
	guy = getent("cafe_molotov_civ_04_ai", "targetname");
	if(isdefined(guy))
	{
		guy thread vengeance_util::set_civilian_on_fire();
	}
	wait(randomfloatrange(4, 8));
	level.cafe_molotov_org thread scene::play("cin_ven_04_20_cafemolotovflush_vign_cive");
	wait(0.05);
	guy = getent("cafe_molotov_civ_05_ai", "targetname");
	if(isdefined(guy))
	{
		guy thread vengeance_util::set_civilian_on_fire();
	}
	wait(randomfloatrange(4, 8));
	level.cafe_molotov_org thread scene::play("cin_ven_04_20_cafemolotovflush_vign_civf");
	wait(0.05);
	guy = getent("cafe_molotov_civ_06_ai", "targetname");
	if(isdefined(guy))
	{
		guy thread vengeance_util::set_civilian_on_fire();
	}
	wait(randomfloatrange(4, 8));
	level.cafe_molotov_org thread scene::play("cin_ven_04_20_cafemolotovflush_vign_civg");
	wait(0.05);
	guy = getent("cafe_molotov_civ_07_ai", "targetname");
	if(isdefined(guy))
	{
		guy thread vengeance_util::set_civilian_on_fire();
	}
}

/*
	Name: function_147bbbbf
	Namespace: vengeance_dogleg_1
	Checksum: 0xB9E4998C
	Offset: 0x40C8
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function function_147bbbbf()
{
	self endon(#"death");
	self.team = "allies";
	self ai::set_ignoreme(1);
	self ai::set_ignoreall(1);
	self ai::set_behavior_attribute("panic", 0);
	self.health = 1;
}

/*
	Name: function_6236563e
	Namespace: vengeance_dogleg_1
	Checksum: 0x1C5807D
	Offset: 0x4150
	Size: 0x294
	Parameters: 0
	Flags: Linked
*/
function function_6236563e()
{
	wait(3);
	var_4d665055 = struct::get("goto_quadtank_alley_obj_org", "targetname");
	objectives::set("cp_level_vengeance_goto_quadtank_alley", var_4d665055);
	var_23b47afc = getent("quadtank_alley_intro_trigger", "script_noteworthy");
	var_23b47afc triggerenable(0);
	msg = level util::waittill_any_return("goto_quadtank_alley_trigger_touched", "stealth_discovered");
	if(msg == "stealth_discovered")
	{
		objectives::hide("cp_level_vengeance_goto_quadtank_alley");
		objectives::set("cp_level_vengeance_clear_area");
		level flag::wait_till_clear("stealth_discovered");
		objectives::show("cp_level_vengeance_goto_quadtank_alley");
		objectives::hide("cp_level_vengeance_clear_area");
		level flag::wait_till("goto_quadtank_alley_trigger_touched");
	}
	objectives::hide("cp_level_vengeance_goto_quadtank_alley");
	var_23b47afc triggerenable(1);
	e_door_use_object = util::init_interactive_gameobject(var_23b47afc, &"cp_prompt_enter_ven_gate", &"CP_MI_SING_VENGEANCE_HINT_OPEN", &function_9c72eea2);
	objectives::set("cp_level_vengeance_open_quadtank_alley_menu");
	level thread vengeance_util::stealth_combat_toggle_trigger_and_objective(var_23b47afc, undefined, "cp_level_vengeance_open_quadtank_alley_menu", "start_quadtank_alley_intro", "cp_level_vengeance_clear_area", e_door_use_object);
	level flag::wait_till("start_quadtank_alley_intro");
	e_door_use_object gameobjects::disable_object();
	objectives::hide("cp_level_vengeance_open_quadtank_alley_menu");
}

/*
	Name: function_9c72eea2
	Namespace: vengeance_dogleg_1
	Checksum: 0xC64C4987
	Offset: 0x43F0
	Size: 0x28
	Parameters: 1
	Flags: Linked
*/
function function_9c72eea2(e_player)
{
	level notify(#"hash_93d1a6c2");
	level.var_4c62d05f = e_player;
}

/*
	Name: function_1909c582
	Namespace: vengeance_dogleg_1
	Checksum: 0x50280DF1
	Offset: 0x4420
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function function_1909c582()
{
	level endon(#"hash_e9ff59d5");
	level flag::wait_till("stealth_combat");
	level.var_508337f6 = 1;
}

/*
	Name: function_6fdd2184
	Namespace: vengeance_dogleg_1
	Checksum: 0x12D6626A
	Offset: 0x4460
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_6fdd2184()
{
	level endon(#"hash_e9ff59d5");
	level flag::wait_till("stealth_discovered");
	stealth::function_26f24c93(0);
	level thread vengeance_util::function_80840124();
	level thread function_adb6f63(5);
	while(true)
	{
		guys = getaiteamarray("axis");
		if(isdefined(guys) && guys.size <= 0 || !isdefined(guys))
		{
			break;
		}
		else
		{
			wait(0.1);
		}
	}
	vengeance_util::function_ee75acde("hend_that_s_the_last_of_0");
	level flag::clear("stealth_combat");
	level flag::clear("stealth_discovered");
}

/*
	Name: function_24a63cea
	Namespace: vengeance_dogleg_1
	Checksum: 0xCA38F392
	Offset: 0x45A0
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function function_24a63cea()
{
	self endon(#"death");
	if(isdefined(self.script_stealth_dontseek) && self.script_stealth_dontseek)
	{
		self ai::set_behavior_attribute("sprint", 1);
	}
}

/*
	Name: skipto_dogleg_1_done
	Namespace: vengeance_dogleg_1
	Checksum: 0xFEB8E2B6
	Offset: 0x45F0
	Size: 0x3DC
	Parameters: 4
	Flags: Linked
*/
function skipto_dogleg_1_done(str_objective, b_starting, b_direct, player)
{
	level flag::set("dogleg_1_end");
	level notify(#"hash_bab8795");
	level flag::clear("combat_enemies_retreating");
	level cleanup_dogleg_1();
	namespace_523da15d::function_a4b67c57();
	namespace_523da15d::function_82266abb();
	vengeance_util::function_4e8207e9("dogleg_1", 0);
	if(!isdefined(b_starting) || (isdefined(b_starting) && b_starting == 0))
	{
		vengeance_util::init_hero("hendricks", str_objective);
		vengeance_util::co_op_teleport_on_igc_end("cin_ven_04_30_quadalleydoor_1st", "quadalleydoor_igc_teleport");
		spawner::add_spawn_function_group("quadteaser_qt", "script_noteworthy", &vengeance_quadtank_alley::quadtank_alley_quadtank_setup);
		level thread vengeance_quadtank_alley::function_32620a97();
		level thread vengeance_quadtank_alley::function_323d0a39();
		level util::waittill_notify_or_timeout("quadtank_alley_activated", 1);
		if(isdefined(level.bzm_vengeancedialogue6callback))
		{
			level thread [[level.bzm_vengeancedialogue6callback]]();
		}
		level.var_831ab6b2 thread scene::play("cin_ven_04_30_quadalleydoor_1st", level.var_4c62d05f);
		level waittill(#"hash_57cf6a02");
		var_7d044b82 = struct::get("quad_alley_door_physics", "targetname");
		physicsexplosionsphere(var_7d044b82.origin, 64, 48, 1);
	}
	level struct::delete_script_bundle("scene", "cin_ven_04_10_cafedoor_1st_sh010");
	level struct::delete_script_bundle("scene", "cin_ven_04_10_cafedoor_3rd_sh020");
	level struct::delete_script_bundle("scene", "cin_ven_04_10_cafedoor_3rd_sh030");
	level struct::delete_script_bundle("scene", "cin_ven_04_10_cafedoor_3rd_sh040");
	level struct::delete_script_bundle("scene", "cin_ven_04_10_cafedoor_3rd_sh050");
	level struct::delete_script_bundle("scene", "cin_ven_04_10_cafedoor_3rd_sh060");
	level struct::delete_script_bundle("scene", "cin_ven_04_10_cafedoor_3rd_sh070");
	level struct::delete_script_bundle("scene", "cin_ven_04_10_cafedoor_3rd_sh080");
	level struct::delete_script_bundle("scene", "cin_ven_04_10_cafedoor_3rd_sh090");
	level struct::delete_script_bundle("scene", "cin_ven_04_10_cafedoor_1st_sh100");
}

/*
	Name: cleanup_dogleg_1
	Namespace: vengeance_dogleg_1
	Checksum: 0x70AE359F
	Offset: 0x49D8
	Size: 0x10A
	Parameters: 0
	Flags: Linked
*/
function cleanup_dogleg_1()
{
	array::thread_all(getaiteamarray("axis"), &util::self_delete);
	array::run_all(getcorpsearray(), &delete);
	if(isdefined(level.var_4326839a))
	{
		foreach(enemy in level.var_4326839a)
		{
			if(isdefined(enemy))
			{
				enemy delete();
			}
		}
	}
}

/*
	Name: function_adb6f63
	Namespace: vengeance_dogleg_1
	Checksum: 0x9A688757
	Offset: 0x4AF0
	Size: 0x290
	Parameters: 1
	Flags: Linked
*/
function function_adb6f63(var_f02766b0)
{
	level endon(#"hash_e9ff59d5");
	if(!isdefined(var_f02766b0))
	{
		var_f02766b0 = 3;
	}
	while(true)
	{
		guys = getaiteamarray("axis");
		if(isdefined(guys) && guys.size <= var_f02766b0)
		{
			foreach(guy in guys)
			{
				if(isdefined(guy) && isalive(guy))
				{
					if(isvehicle(guy))
					{
						var_fea4c4ed = struct::get_array("dogleg_1_wasp_retreat_nodes", "targetname");
						node = array::random(var_fea4c4ed);
						guy thread vengeance_util::delete_ai_at_path_end(node);
					}
					node = getnodearraysorted("dogleg_1_retreat_nodes", "targetname", guy.origin, 4096);
					if(isdefined(node[0]))
					{
						if(guy ai::has_behavior_attribute("sprint"))
						{
							guy ai::set_behavior_attribute("sprint", 1);
						}
						guy thread vengeance_util::delete_ai_at_path_end(node[0]);
						continue;
					}
					a_ai = array(guy);
					level thread vengeance_util::delete_ai_when_out_of_sight(a_ai, 1024);
				}
			}
			level flag::set("combat_enemies_retreating");
			break;
		}
		else
		{
			wait(1);
		}
	}
}

/*
	Name: dogleg_1_vo
	Namespace: vengeance_dogleg_1
	Checksum: 0x866D64F8
	Offset: 0x4D88
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function dogleg_1_vo(b_starting)
{
	level endon(#"hash_8a3b89d3");
	stealth::function_26f24c93(1);
	flag::wait_till("dogleg_1_stealth_motivator_01");
	flag::wait_till("dogleg_1_stealth_motivator_02");
}

