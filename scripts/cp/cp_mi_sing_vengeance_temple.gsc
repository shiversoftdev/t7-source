// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_sing_vengeance_accolades;
#using scripts\cp\cp_mi_sing_vengeance_sound;
#using scripts\cp\cp_mi_sing_vengeance_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai\archetype_warlord_interface;
#using scripts\shared\ai_shared;
#using scripts\shared\ai_sniper_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\stealth;
#using scripts\shared\stealth_aware;
#using scripts\shared\stealth_status;
#using scripts\shared\stealth_vo;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace vengeance_temple;

/*
	Name: skipto_temple_init
	Namespace: vengeance_temple
	Checksum: 0xFB15E3DC
	Offset: 0x13E0
	Size: 0x13C
	Parameters: 2
	Flags: Linked
*/
function skipto_temple_init(str_objective, b_starting)
{
	if(b_starting)
	{
		load::function_73adcefc();
		vengeance_util::skipto_baseline(str_objective, b_starting);
		callback::on_spawned(&vengeance_util::give_hero_weapon);
		vengeance_util::init_hero("hendricks", str_objective);
		level thread vengeance_util::function_cc6f3598();
		level thread vengeance_util::function_3f34106b();
		level thread namespace_9fd035::function_dad71f51();
		load::function_a2995f22();
		objectives::set("cp_level_vengeance_rescue_kane");
		objectives::set("cp_level_vengeance_go_to_safehouse");
		objectives::hide("cp_level_vengeance_go_to_safehouse");
	}
	temple_main(str_objective);
}

/*
	Name: temple_main
	Namespace: vengeance_temple
	Checksum: 0x245311A1
	Offset: 0x1528
	Size: 0x802
	Parameters: 1
	Flags: Linked
*/
function temple_main(str_objective)
{
	stealth::reset();
	level.var_67e1f60e[level.var_67e1f60e.size] = &function_591ead63;
	level flag::set("temple_begin");
	setdvar("scr_security_breach_lose_contact_distance", 36000);
	setdvar("scr_security_breach_lost_contact_distance", 72000);
	level thread namespace_523da15d::function_a6fadcaa();
	level thread temple_vo();
	level.ai_hendricks thread setup_temple_hendricks();
	spawner::add_spawn_function_group("temple_ambient_civilian", "script_noteworthy", &function_8e6475bd);
	level thread function_47dc557f();
	level thread function_a86ac59d();
	level thread setup_breakable_garden_windows();
	vengeance_util::function_e00864bd("office_umbra_gate", 0, "office_gate");
	level.temple_patroller_spawners = spawner::simple_spawn("temple_patroller_spawners", &function_e8f0e2bd);
	level thread function_f8f4e73e();
	level thread vengeance_util::function_e3420328("temple_ambient_anims", "dogleg_2_at_end");
	level thread scene::play("cin_ven_05_20_pond_floaters_vign");
	spawner::add_spawn_function_group("drowncivilian_enemy", "targetname", &function_558af5fd, undefined, "cin_ven_05_22_drowncivilian_civdeath_vign", "cin_ven_05_22_drowncivilian_enemyreact_vign", undefined);
	level thread scene::play("cin_ven_05_22_drowncivilian_vign");
	spawner::add_spawn_function_group("rocksmash_enemy", "targetname", &function_558af5fd, undefined, "cin_ven_05_21_rocksmash_civdeath_vign", "cin_ven_05_21_rocksmash_enemyreact_vign", "rocksmash_boulder");
	var_6a07eb6c = [];
	var_6a07eb6c[0] = "rocksmash_civilian";
	scene::add_scene_func("cin_ven_05_21_rocksmash_vign", &vengeance_util::function_65a61b78, "play", var_6a07eb6c);
	level thread scene::play("cin_ven_05_21_rocksmash_vign");
	spawner::add_spawn_function_group("slicendice_enemy", "targetname", &function_558af5fd, undefined, "cin_ven_05_23_slicendice_civdeath_vign", undefined, "slicendice_machete");
	var_6a07eb6c = [];
	var_6a07eb6c[0] = "slicendice_civilian";
	scene::add_scene_func("cin_ven_05_23_slicendice_vign", &vengeance_util::function_65a61b78, "play", var_6a07eb6c);
	level thread scene::play("cin_ven_05_23_slicendice_vign");
	spawner::add_spawn_function_group("beatdown_enemy", "targetname", &function_558af5fd, undefined, "cin_ven_05_26_beatdown_civdeath_vign", undefined, undefined);
	level thread scene::play("cin_ven_05_26_beatdown_vign");
	spawner::add_spawn_function_group("execution_lineup_enemy", "targetname", &function_558af5fd, undefined, "cin_ven_05_24_execution_lineup_civdeath_vign", undefined, undefined);
	level thread scene::play("cin_ven_05_24_execution_lineup_vign");
	spawner::add_spawn_function_group("ammorestock_en3", "targetname", &function_558af5fd, undefined, undefined, "cin_ven_05_27_ammorestock_enemyreact_vign", undefined);
	level thread scene::play("cin_ven_05_27_ammorestock_vign");
	spawner::add_spawn_function_group("grassstomp_enemy", "targetname", &function_558af5fd, undefined, "cin_ven_05_28_grassstomp_civdeath_vign", undefined, undefined);
	level thread scene::play("cin_ven_05_28_grassstomp_vign");
	spawner::add_spawn_function_group("railbeatdown_enemy", "targetname", &function_558af5fd, undefined, "cin_ven_05_29_rail_beatdown_civdeath_vign", "cin_ven_05_29_rail_beatdown_enemyreact_vign", undefined);
	var_6a07eb6c = [];
	var_6a07eb6c[0] = "railbeatdown_civ";
	scene::add_scene_func("cin_ven_05_29_rail_beatdown_vign", &vengeance_util::function_65a61b78, "play", var_6a07eb6c);
	level thread scene::play("cin_ven_05_29_rail_beatdown_vign");
	spawner::add_spawn_function_group("wallbeatdown_enemy1", "targetname", &function_558af5fd, undefined, "cin_ven_05_32_wall_beatdown_civdeath_vign", "cin_ven_05_32_wall_beatdown_enemyreact_vign", undefined);
	level thread scene::play("cin_ven_05_32_wall_beatdown_vign");
	level thread function_ea758541("temple_rooftop_sniper_trigger", "targetname");
	triggers = getentarray("temple_stealth_checkpoint_trigger", "targetname");
	foreach(trigger in triggers)
	{
		trigger thread vengeance_util::function_f9c94344();
	}
	level thread function_68be9dc2();
	clips = getentarray("temple_spawn_closet_door_pathing_clip", "targetname");
	foreach(clip in clips)
	{
		clip disconnectpaths();
	}
}

/*
	Name: function_68be9dc2
	Namespace: vengeance_temple
	Checksum: 0x77A65954
	Offset: 0x1D38
	Size: 0x260
	Parameters: 0
	Flags: Linked
*/
function function_68be9dc2()
{
	wait(0.25);
	var_dd48cfe3 = [];
	var_dd48cfe3[var_dd48cfe3.size] = "drowncivilian_civilian";
	var_dd48cfe3[var_dd48cfe3.size] = "rocksmash_civilian";
	var_dd48cfe3[var_dd48cfe3.size] = "slicendice_civilian";
	var_dd48cfe3[var_dd48cfe3.size] = "beatdown_civilian";
	var_dd48cfe3[var_dd48cfe3.size] = "execution_lineup_civ1";
	var_dd48cfe3[var_dd48cfe3.size] = "execution_lineup_civ2";
	var_dd48cfe3[var_dd48cfe3.size] = "execution_lineup_civ3";
	var_dd48cfe3[var_dd48cfe3.size] = "execution_lineup_civ4";
	var_dd48cfe3[var_dd48cfe3.size] = "execution_lineup_civ5";
	var_dd48cfe3[var_dd48cfe3.size] = "execution_lineup_civ6";
	var_dd48cfe3[var_dd48cfe3.size] = "temple_butcher_civilian";
	var_dd48cfe3[var_dd48cfe3.size] = "gateroughup_civilian";
	var_dd48cfe3[var_dd48cfe3.size] = "grassstomp_civ";
	var_dd48cfe3[var_dd48cfe3.size] = "railbeatdown_civ";
	var_dd48cfe3[var_dd48cfe3.size] = "wallbeatdown_civilian";
	foreach(var_aca1a7c8 in var_dd48cfe3)
	{
		var_ad10cf41 = getentarray(var_aca1a7c8, "targetname");
		foreach(civ in var_ad10cf41)
		{
			civ thread vengeance_util::function_f832e2fa();
		}
	}
}

/*
	Name: function_558af5fd
	Namespace: vengeance_temple
	Checksum: 0xA50A4B90
	Offset: 0x1FA0
	Size: 0x1DC
	Parameters: 4
	Flags: Linked
*/
function function_558af5fd(var_7131db57, var_1f486a3b, react_scene, drop_object)
{
	self endon(#"death");
	if(isdefined(var_7131db57))
	{
		self stealth_vo::function_4970c8b8(var_7131db57);
	}
	self thread function_c2627018(var_1f486a3b, drop_object);
	self util::waittill_any("alert", "damage");
	if(isdefined(self.script_aigroup))
	{
		group = getaiarray(self.script_aigroup, "script_aigroup");
		foreach(guy in group)
		{
			if(isalive(guy) && guy != self)
			{
				guy notify(#"alert", "combat");
			}
		}
	}
	if(isdefined(drop_object))
	{
		level thread function_54c1902c(drop_object);
	}
	if(isdefined(react_scene))
	{
		self stopanimscripted();
		level thread scene::play(react_scene);
	}
}

/*
	Name: function_c2627018
	Namespace: vengeance_temple
	Checksum: 0x4B290FD7
	Offset: 0x2188
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function function_c2627018(var_1f486a3b, drop_object)
{
	self util::waittill_any("death", "alert", "damage");
	if(isdefined(drop_object))
	{
		level thread function_54c1902c(drop_object);
	}
	if(isdefined(var_1f486a3b))
	{
		level thread scene::play(var_1f486a3b);
	}
}

/*
	Name: function_e0d6af75
	Namespace: vengeance_temple
	Checksum: 0x594BFDEA
	Offset: 0x2218
	Size: 0x114
	Parameters: 0
	Flags: None
*/
function function_e0d6af75()
{
	self endon(#"death");
	self ai::set_ignoreme(1);
	self thread function_64cea510();
	self util::waittill_any("alert", "fake_alert");
	self animation::fire_weapon();
	self stopanimscripted();
	civ = getent("gunpoint_civilian_ai", "targetname");
	if(isdefined(civ) && isalive(civ))
	{
		civ notify(#"fake_death");
	}
	wait(0.1);
	self ai::set_ignoreme(0);
}

/*
	Name: function_64cea510
	Namespace: vengeance_temple
	Checksum: 0xC8542168
	Offset: 0x2338
	Size: 0x148
	Parameters: 0
	Flags: Linked
*/
function function_64cea510()
{
	self waittill(#"death");
	civ = getent("gunpoint_civilian_ai", "targetname");
	if(isdefined(civ) && isalive(civ))
	{
		civ notify(#"fake_death");
	}
	if(isdefined(self))
	{
		start_origin = self gettagorigin("tag_flash");
		if(isdefined(start_origin))
		{
			end_origin = start_origin + (anglestoforward(self gettagangles("tag_flash")) * 120);
			if(isdefined(start_origin) && isdefined(end_origin))
			{
				shot = magicbullet(getweapon("shotgun_pump"), start_origin, end_origin);
			}
		}
	}
}

/*
	Name: function_bddcb39c
	Namespace: vengeance_temple
	Checksum: 0xAB435EE5
	Offset: 0x2488
	Size: 0x17C
	Parameters: 0
	Flags: None
*/
function function_bddcb39c()
{
	self endon(#"death");
	self.team = "allies";
	self.civilian = 1;
	self ai::set_ignoreme(1);
	self ai::set_ignoreall(1);
	self ai::set_behavior_attribute("panic", 0);
	self.health = 1;
	self util::waittill_any("damage", "alert", "fake_death");
	guy = getent("gunpoint_enemy_ai", "targetname");
	if(isdefined(guy) && isalive(guy))
	{
		guy notify(#"hash_da6a4775");
	}
	if(isdefined(self.magic_bullet_shield))
	{
		util::stop_magic_bullet_shield(self);
	}
	self.takedamage = 1;
	self.allowdeath = 1;
	self kill();
	self startragdoll();
}

/*
	Name: function_54c1902c
	Namespace: vengeance_temple
	Checksum: 0x9E622472
	Offset: 0x2610
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function function_54c1902c(e_obj)
{
	if(isdefined(e_obj))
	{
		e_obj = getent(e_obj, "targetname");
		if(isdefined(e_obj))
		{
			e_obj stopanimscripted();
			e_obj physicslaunch(e_obj.origin, vectorscale((0, 0, 1), 0.1));
		}
	}
}

/*
	Name: function_8e6475bd
	Namespace: vengeance_temple
	Checksum: 0x5B05475D
	Offset: 0x26A8
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function function_8e6475bd()
{
	self endon(#"death");
	self.team = "allies";
	self.civilian = 1;
	self ai::set_ignoreme(1);
	self ai::set_ignoreall(1);
	self ai::set_behavior_attribute("panic", 0);
	self.health = 1;
}

/*
	Name: function_e8f0e2bd
	Namespace: vengeance_temple
	Checksum: 0xE6499894
	Offset: 0x2738
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_e8f0e2bd()
{
	self thread vengeance_util::setup_patroller();
	self playloopsound("amb_patrol_walla");
	self thread ai_sniper::agent_init();
}

/*
	Name: function_47dc557f
	Namespace: vengeance_temple
	Checksum: 0x8BF68457
	Offset: 0x2798
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_47dc557f()
{
	level.var_47dc557f = spawner::simple_spawn("temple_wasps", &function_a044ee0);
}

/*
	Name: function_a044ee0
	Namespace: vengeance_temple
	Checksum: 0x5F66F194
	Offset: 0x27D8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_a044ee0()
{
	var_850a4b14 = getent("temple_wasp_gv", "targetname");
	if(isdefined(var_850a4b14))
	{
		self clearforcedgoal();
		self cleargoalvolume();
		self setgoal(var_850a4b14);
	}
}

/*
	Name: setup_temple_hendricks
	Namespace: vengeance_temple
	Checksum: 0x56CEED60
	Offset: 0x2860
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function setup_temple_hendricks()
{
	level endon(#"hash_8a3b89d3");
	self endon(#"death");
	self thread function_f6b53854();
	self ai::set_ignoreall(1);
	self ai::set_ignoreme(1);
	self colors::disable();
	self ai::set_behavior_attribute("cqb", 1);
	self.holdfire = 1;
	self battlechatter::function_d9f49fba(0);
	level scene::play("cin_ven_05_10_templearrival_vign");
	self.disablearrivals = 1;
	self.disableexits = 1;
	node = getnode("temple_hendricks_node_05", "targetname");
	self setgoal(node, 1);
	level notify(#"temple_vo");
	wait(1);
	self.disablearrivals = 0;
	self.disableexits = 0;
}

/*
	Name: function_f6b53854
	Namespace: vengeance_temple
	Checksum: 0xE855E725
	Offset: 0x29D0
	Size: 0x2D4
	Parameters: 0
	Flags: Linked
*/
function function_f6b53854()
{
	level flag::wait_till("stealth_discovered");
	level flag::set("temple_stealth_broken");
	self.disablearrivals = 0;
	self.disableexits = 0;
	self ai::set_ignoreall(0);
	self ai::set_ignoreme(0);
	self.fixednode = 0;
	self clearforcedgoal();
	self ai::set_behavior_attribute("cqb", 0);
	self.holdfire = 0;
	self.var_df53bc6 = self.script_accuracy;
	self.script_accuracy = 0.1;
	objectives::set("cp_level_vengeance_support", self);
	self thread vengeance_util::function_5a886ae0();
	level flag::wait_till_clear("stealth_discovered");
	self notify(#"hash_90a20e6d");
	self ai::set_ignoreall(1);
	self ai::set_ignoreme(1);
	self.holdfire = 1;
	self battlechatter::function_d9f49fba(0);
	self.script_accuracy = self.var_df53bc6;
	self clearforcedgoal();
	self cleargoalvolume();
	self colors::disable();
	var_d7b9ba9b = getnode("temple_end_hendricks_node", "targetname");
	self.forcegoal = 1;
	self.fixednode = 1;
	self.goalradius = 32;
	self setgoalnode(var_d7b9ba9b, 1);
	level flag::clear("stealth_combat");
	self waittill(#"goal");
	self.forcegoal = 0;
	self.fixednode = 0;
	level flag::set("temple_hendricks_done");
}

/*
	Name: function_4002969a
	Namespace: vengeance_temple
	Checksum: 0xA6D4BAC4
	Offset: 0x2CB0
	Size: 0x19C
	Parameters: 0
	Flags: None
*/
function function_4002969a()
{
	level flag::wait_till("all_players_at_temple_exit");
	if(!level flag::get("hendricks_near_dogleg_2"))
	{
		nodes = getnodearray("hendricks_temple_end_teleport_node", "targetname");
		node = arraygetclosest(level.ai_hendricks.origin, nodes);
		n_off_screen_dot = 0.75;
		if(vengeance_util::any_player_looking_at(level.ai_hendricks.origin + vectorscale((0, 0, 1), 48), n_off_screen_dot, 1))
		{
			level.ai_hendricks forceteleport(node.origin, node.angles);
			wait(0.1);
			var_d7b9ba9b = getnode("temple_end_hendricks_node", "targetname");
			self.forcegoal = 1;
			self.fixednode = 1;
			self.goalradius = 32;
			self setgoalnode(var_d7b9ba9b, 1);
		}
	}
}

/*
	Name: function_578145a3
	Namespace: vengeance_temple
	Checksum: 0xCBE0D6DA
	Offset: 0x2E58
	Size: 0xBBC
	Parameters: 0
	Flags: Linked
*/
function function_578145a3()
{
	var_1044cded = 0;
	i = 3;
	for(i = 3; i >= 2; i--)
	{
		var_26b3981a = getent("temple_axis_gv_0" + i, "targetname");
		var_42cc32ad = function_f1c7b73f(var_26b3981a);
		if(isdefined(var_42cc32ad) && var_42cc32ad)
		{
			var_1044cded = 1;
			break;
		}
	}
	var_17994622 = getaiteamarray("axis");
	if(isdefined(var_1044cded) && var_1044cded)
	{
		ally_volume = getent("temple_ally_gv_0" + i, "targetname");
		var_a2d2b3b = getent("temple_axis_gv_0" + i, "targetname");
		var_fcf2483c = getent("temple_axis_cleanup_volume_0" + i, "targetname");
		level thread function_620fbb8a(var_17994622, var_fcf2483c);
	}
	else
	{
		ally_volume = getent("temple_ally_gv_01", "targetname");
		var_a2d2b3b = getent("temple_axis_gv_01", "targetname");
	}
	foreach(guy in var_17994622)
	{
		if(isalive(guy))
		{
			guy clearforcedgoal();
			guy cleargoalvolume();
			guy setgoal(var_a2d2b3b);
		}
	}
	if(isdefined(var_1044cded) && var_1044cded)
	{
		nodes = getnodearray("hendircks_forced_advance_0" + i, "targetname");
		node = array::random(nodes);
		level.ai_hendricks forceteleport(node.origin, node.angles);
		wait(0.1);
	}
	level.ai_hendricks clearforcedgoal();
	level.ai_hendricks cleargoalvolume();
	level.ai_hendricks setgoal(ally_volume);
	ally_volume = getent("temple_ally_gv_02", "targetname");
	var_a2d2b3b = getent("temple_axis_gv_02", "targetname");
	while(true)
	{
		if(isdefined(var_1044cded) && var_1044cded && i >= 2)
		{
			break;
		}
		guys_left = getaiteamarray("axis");
		if(isdefined(guys_left) && guys_left.size <= (var_17994622.size * 0.8))
		{
			foreach(guy in guys_left)
			{
				if(isalive(guy))
				{
					guy clearforcedgoal();
					guy cleargoalvolume();
					guy setgoal(var_a2d2b3b);
				}
			}
			level.ai_hendricks clearforcedgoal();
			level.ai_hendricks cleargoalvolume();
			level.ai_hendricks setgoal(ally_volume);
			break;
		}
		wait(0.1);
	}
	ally_volume = getent("temple_ally_gv_03", "targetname");
	var_a2d2b3b = getent("temple_axis_gv_03", "targetname");
	while(true)
	{
		if(isdefined(var_1044cded) && var_1044cded && i >= 3)
		{
			break;
		}
		guys_left = getaiteamarray("axis");
		if(isdefined(guys_left) && guys_left.size <= (var_17994622.size * 0.6))
		{
			foreach(guy in guys_left)
			{
				if(isalive(guy))
				{
					guy clearforcedgoal();
					guy cleargoalvolume();
					guy setgoal(var_a2d2b3b);
				}
			}
			level.ai_hendricks clearforcedgoal();
			level.ai_hendricks cleargoalvolume();
			level.ai_hendricks setgoal(ally_volume);
			break;
		}
		wait(0.1);
	}
	ally_volume = getent("temple_ally_gv_04", "targetname");
	var_a2d2b3b = getent("temple_axis_gv_04", "targetname");
	while(true)
	{
		guys_left = getaiteamarray("axis");
		if(isdefined(guys_left) && guys_left.size <= (var_17994622.size * 0.4))
		{
			foreach(guy in guys_left)
			{
				if(isalive(guy))
				{
					guy clearforcedgoal();
					guy cleargoalvolume();
					guy setgoal(var_a2d2b3b);
				}
			}
			level.ai_hendricks clearforcedgoal();
			level.ai_hendricks cleargoalvolume();
			level.ai_hendricks setgoal(ally_volume);
			break;
		}
		wait(0.1);
	}
	while(true)
	{
		guys_left = getaiteamarray("axis");
		if(isdefined(guys_left) && guys_left.size <= (var_17994622.size * 0.2))
		{
			foreach(guy in guys_left)
			{
				if(isdefined(guy) && isalive(guy))
				{
					if(isvehicle(guy))
					{
						var_c1cd872a = struct::get_array("temple_wasp_retreat_nodes", "targetname");
						node = array::random(var_c1cd872a);
						guy thread vengeance_util::delete_ai_at_path_end(node);
					}
					node = getnodearraysorted("temple_retreat_nodes", "targetname", guy.origin, 4096);
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
			level flag::set("disable_temple_robot_triggers");
			break;
		}
		wait(0.1);
	}
}

/*
	Name: function_f1c7b73f
	Namespace: vengeance_temple
	Checksum: 0x4CEA7C11
	Offset: 0x3A20
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_f1c7b73f(trigger)
{
	foreach(player in getplayers())
	{
		if(!player istouching(trigger))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_620fbb8a
	Namespace: vengeance_temple
	Checksum: 0xEAA41B3D
	Offset: 0x3AD8
	Size: 0x14C
	Parameters: 2
	Flags: Linked
*/
function function_620fbb8a(var_7cd99f10, e_volume)
{
	a_ai = [];
	foreach(ai in var_7cd99f10)
	{
		if(isdefined(ai) && isalive(ai) && ai istouching(e_volume))
		{
			if(!isdefined(a_ai))
			{
				a_ai = [];
			}
			else if(!isarray(a_ai))
			{
				a_ai = array(a_ai);
			}
			a_ai[a_ai.size] = ai;
		}
	}
	level thread vengeance_util::delete_ai_when_out_of_sight(a_ai, 512);
}

/*
	Name: temple_vo
	Namespace: vengeance_temple
	Checksum: 0x89177B15
	Offset: 0x3C30
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function temple_vo()
{
	level endon(#"hash_8a3b89d3");
	level.ai_hendricks endon(#"death");
	level waittill(#"temple_vo");
	foreach(player in level.activeplayers)
	{
		player thread vengeance_util::function_51caee84("temple_end");
	}
	level flag::set("show_temple_gather");
	stealth::function_26f24c93(1);
	flag::wait_till("tmeple_stealth_motivator_01");
	vengeance_util::function_ee75acde("hend_stick_to_the_shadows_0");
	flag::wait_till("tmeple_stealth_motivator_02");
	vengeance_util::function_ee75acde("hend_lots_of_movement_dow_1");
	flag::wait_till("tmeple_stealth_motivator_03");
	vengeance_util::function_ee75acde("hend_keep_moving_they_ha_0");
}

/*
	Name: function_a86ac59d
	Namespace: vengeance_temple
	Checksum: 0x46002196
	Offset: 0x3DB8
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function function_a86ac59d()
{
	level endon(#"hash_29964e40");
	level flag::wait_till("stealth_discovered");
	array::thread_all(getaiteamarray("axis"), &function_329c89f);
	level thread vengeance_util::function_e6399870("temple_molotov_trigger", "script_noteworthy", 2);
	level flag::set("enable_temple_robot_triggers");
	var_b264f09 = getentarray("temple_robot_trigger", "targetname");
	array::thread_all(var_b264f09, &function_dd797045);
	stealth::function_26f24c93(0);
	level thread vengeance_util::function_80840124(&function_e4612dd6);
	level thread function_578145a3();
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
	objectives::complete("cp_level_vengeance_support", level.ai_hendricks);
	level flag::clear("stealth_discovered");
}

/*
	Name: function_329c89f
	Namespace: vengeance_temple
	Checksum: 0x838FBE86
	Offset: 0x3FC0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_329c89f()
{
	self stopsounds();
}

/*
	Name: function_dd797045
	Namespace: vengeance_temple
	Checksum: 0x48D27CAE
	Offset: 0x3FE8
	Size: 0x5E4
	Parameters: 0
	Flags: Linked
*/
function function_dd797045()
{
	level endon(#"hash_29964e40");
	level endon(#"hash_fecd096c");
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger");
		guys = getaiteamarray("axis");
		guys = array::remove_dead(guys);
		if(guys.size > 37)
		{
			wait(2);
			continue;
		}
		volume = getent(self.target + "_volume", "targetname");
		if(isdefined(volume))
		{
			robots = getentarray(self.target, "targetname");
			foreach(robot in robots)
			{
				robot.ignoreall = 1;
				robot.ignoreme = 1;
			}
			doors = getentarray("temple_spawn_closet_door", "targetname");
			foreach(door in doors)
			{
				var_6c37ffe1 = self.target + "_closet";
				if(isdefined(door.script_noteworthy) && door.script_noteworthy == var_6c37ffe1)
				{
					var_8b006810 = door;
					break;
				}
			}
			var_d17d5da5 = getentarray("temple_spawn_closet_door_clip", "targetname");
			foreach(clip in var_d17d5da5)
			{
				var_35f2b287 = self.target + "_closet";
				if(isdefined(clip.script_noteworthy) && clip.script_noteworthy == var_35f2b287)
				{
					var_17c44fc9 = clip;
					break;
				}
			}
			var_6e15ff70 = getentarray("temple_spawn_closet_door_pathing_clip", "targetname");
			foreach(clip in var_6e15ff70)
			{
				var_35f2b287 = self.target + "_closet";
				if(isdefined(clip.script_noteworthy) && clip.script_noteworthy == var_35f2b287)
				{
					var_3cdd15e3 = clip;
					break;
				}
			}
			if(isdefined(var_8b006810) && isdefined(var_17c44fc9))
			{
				var_17c44fc9 linkto(var_8b006810);
			}
			if(isdefined(var_8b006810))
			{
				var_8b006810 rotateto(var_8b006810.angles + vectorscale((0, 1, 0), 90), 1);
			}
			wait(0.5);
			if(isdefined(var_3cdd15e3))
			{
				var_3cdd15e3 notsolid();
				wait(0.05);
				var_3cdd15e3 connectpaths();
			}
			foreach(robot in robots)
			{
				if(isalive(robot))
				{
					robot.ignoreall = 0;
					robot.ignoreme = 0;
				}
			}
			self triggerenable(0);
			break;
		}
	}
}

/*
	Name: function_e4612dd6
	Namespace: vengeance_temple
	Checksum: 0xD6C6271C
	Offset: 0x45D8
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_e4612dd6()
{
	level endon(#"hash_29964e40");
	level.ai_hendricks battlechatter::function_d9f49fba(0);
	var_eb6e35ef = [];
	var_eb6e35ef[0] = "hend_shifting_positions_0";
	var_eb6e35ef[1] = "hend_i_m_dropping_down_to_0";
	line = array::random(var_eb6e35ef);
	vengeance_util::function_ee75acde(line);
	vengeance_util::function_ee75acde("hend_if_we_can_clear_the_0", 4);
	level thread namespace_9fd035::function_14592f48();
	level.ai_hendricks battlechatter::function_d9f49fba(1);
}

/*
	Name: function_1a289333
	Namespace: vengeance_temple
	Checksum: 0x99EC1590
	Offset: 0x46D0
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function function_1a289333()
{
}

/*
	Name: skipto_temple_done
	Namespace: vengeance_temple
	Checksum: 0x911F34C1
	Offset: 0x46E0
	Size: 0x84
	Parameters: 4
	Flags: Linked
*/
function skipto_temple_done(str_objective, b_starting, b_direct, player)
{
	level flag::set("temple_end");
	level thread cleanup_temple();
	level struct::delete_script_bundle("scene", "cin_ven_hanging_body_loop_vign_civ07_ropeshort");
}

/*
	Name: cleanup_temple
	Namespace: vengeance_temple
	Checksum: 0x8F9585A2
	Offset: 0x4770
	Size: 0x152
	Parameters: 0
	Flags: Linked
*/
function cleanup_temple()
{
	if(isdefined(level.temple_patroller_spawners))
	{
		foreach(enemy in level.temple_patroller_spawners)
		{
			if(isdefined(enemy))
			{
				enemy stealth_status::function_180adb28();
				enemy delete();
			}
		}
	}
	if(isdefined(level.var_47dc557f))
	{
		foreach(enemy in level.var_47dc557f)
		{
			if(isdefined(enemy))
			{
				enemy delete();
			}
		}
	}
}

/*
	Name: setup_breakable_garden_windows
	Namespace: vengeance_temple
	Checksum: 0xD0A187DC
	Offset: 0x48D0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function setup_breakable_garden_windows()
{
	breakable_garden_windows = getentarray("breakable_garden_window", "targetname");
	array::thread_all(breakable_garden_windows, &breakable_garden_window_watcher);
}

/*
	Name: breakable_garden_window_watcher
	Namespace: vengeance_temple
	Checksum: 0x87033EBD
	Offset: 0x4930
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function breakable_garden_window_watcher()
{
	self setcandamage(1);
	self.health = 10;
	while(true)
	{
		self waittill(#"damage", damage, attacker);
		if(isdefined(attacker) && isplayer(attacker) && isdefined(damage))
		{
			self.health = self.health - damage;
			if(self.health <= 0)
			{
				self delete();
				break;
			}
		}
	}
}

/*
	Name: function_f8f4e73e
	Namespace: vengeance_temple
	Checksum: 0xA384A0FE
	Offset: 0x49F8
	Size: 0x30C
	Parameters: 0
	Flags: Linked
*/
function function_f8f4e73e()
{
	var_cd0466c3 = struct::get("dogleg_2_intro_obj_struct");
	if(isdefined(var_cd0466c3))
	{
		objectives::set("cp_level_vengeance_goto_dogleg_2", var_cd0466c3);
	}
	objectives::hide("cp_level_vengeance_goto_dogleg_2");
	level flag::wait_till_any(array("show_temple_gather", "stealth_discovered"));
	objectives::show("cp_level_vengeance_goto_dogleg_2");
	var_f8f4e73e = getent("dogleg_2_intro_trigger", "script_noteworthy");
	if(isdefined(var_f8f4e73e))
	{
		level thread vengeance_util::stealth_combat_toggle_trigger_and_objective(var_f8f4e73e, "cp_level_vengeance_goto_dogleg_2", undefined, "all_players_at_temple_exit", "cp_level_vengeance_clear_area");
	}
	level flag::wait_till("all_players_at_temple_exit");
	objectives::hide("cp_level_vengeance_goto_dogleg_2");
	if(level flag::get("temple_stealth_broken"))
	{
		level flag::wait_till("temple_hendricks_done");
	}
	level.ai_hendricks thread vengeance_util::function_5fbec645("hend_open_it_up_i_ll_cov_0");
	level thread function_cf782b84();
	s_anim_node = struct::get("tag_align_dogleg_2", "targetname");
	s_anim_node thread scene::play("cin_ven_05_65_deadcivilians_vign");
	n_node = getnode("hendricks_dogleg_2_stairs", "targetname");
	level waittill(#"hash_ad75a4f1");
	level thread function_29e96a35();
	if(level flag::get("temple_stealth_broken"))
	{
		level waittill(#"hash_9fb1ff75");
		level.ai_hendricks setgoal(n_node, 1);
	}
	else
	{
		wait(1.5);
		level thread function_37d4d605();
		s_anim_node scene::init("cin_ven_05_70_dogleg2_takedown_vign");
	}
	level flag::set("dogleg_2_begin");
}

/*
	Name: function_29e96a35
	Namespace: vengeance_temple
	Checksum: 0xCDD34A40
	Offset: 0x4D10
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_29e96a35()
{
	level.ai_hendricks notify(#"hash_6f33cd57");
	level.ai_hendricks.var_5d9fbd2d = 0;
	if(level flag::get("temple_stealth_broken"))
	{
		level waittill(#"hash_9fb1ff75");
		level.ai_hendricks dialog::say("hend_you_sure_you_don_t_w_0");
	}
	else
	{
		level waittill(#"hash_132639c7");
		level.ai_hendricks dialog::say("hend_you_sure_you_don_t_w_0", 1);
	}
	level dialog::player_say("plyr_not_a_chance_hendri_0");
}

/*
	Name: function_38bcd0
	Namespace: vengeance_temple
	Checksum: 0x34C60F6D
	Offset: 0x4DF0
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_38bcd0()
{
	e_trigger = getent("dogleg_2_door_entry_trigger", "targetname");
	e_trigger triggerenable(0);
	var_71678477 = getent("dogleg_2_entry_door_lf", "targetname");
	var_1d746940 = getent(var_71678477.target, "targetname");
	var_1d746940 disconnectpaths();
	var_b8e4988b = getent("dogleg_2_entry_door_rt", "targetname");
	var_4a669fbc = getent(var_b8e4988b.target, "targetname");
	var_4a669fbc disconnectpaths();
	var_35a1e4f8 = struct::get("tag_align_dogleg_2_door", "targetname");
	var_35a1e4f8 thread scene::init("cin_ven_05_60_officedoor_1st");
}

/*
	Name: function_cf782b84
	Namespace: vengeance_temple
	Checksum: 0xDA8C4721
	Offset: 0x4F70
	Size: 0x39C
	Parameters: 0
	Flags: Linked
*/
function function_cf782b84()
{
	e_trigger = getent("dogleg_2_door_entry_trigger", "targetname");
	e_trigger triggerenable(1);
	e_door_use_object = util::init_interactive_gameobject(e_trigger, &"cp_prompt_enter_ven_doors", &"CP_MI_SING_VENGEANCE_HINT_OPEN", &function_863781f2);
	objectives::set("cp_level_vengeance_open_dogleg_2_menu");
	level notify(#"hash_479fadce");
	var_71678477 = getent("dogleg_2_entry_door_lf", "targetname");
	var_1d746940 = getent(var_71678477.target, "targetname");
	var_71678477.animname = "dogleg_2_entry_door_lf";
	var_71678477.old_angles = var_71678477.angles;
	var_71678477.old_origin = var_71678477.origin;
	var_b8e4988b = getent("dogleg_2_entry_door_rt", "targetname");
	var_4a669fbc = getent(var_b8e4988b.target, "targetname");
	var_b8e4988b.animname = "dogleg_2_entry_door_rt";
	var_b8e4988b.old_angles = var_b8e4988b.angles;
	var_b8e4988b.old_origin = var_b8e4988b.origin;
	var_1d746940 linkto(var_71678477);
	var_4a669fbc linkto(var_b8e4988b);
	level thread vengeance_util::stealth_combat_toggle_trigger_and_objective(e_trigger, undefined, "cp_level_vengeance_open_dogleg_2_menu", "dogleg_2_entry_door_opening", "cp_level_vengeance_clear_area", e_door_use_object);
	level waittill(#"hash_ad75a4f1");
	e_door_use_object gameobjects::disable_object();
	objectives::hide("cp_level_vengeance_open_dogleg_2_menu");
	level waittill(#"hash_c4bb0520");
	if(!level flag::get("temple_stealth_broken"))
	{
		var_71678477 stopanimscripted();
		var_71678477.angles = var_71678477.old_angles;
		var_71678477.origin = var_71678477.old_origin;
		var_b8e4988b stopanimscripted();
		var_b8e4988b.angles = var_b8e4988b.old_angles;
		var_b8e4988b.origin = var_b8e4988b.old_origin;
	}
	else
	{
		var_1d746940 connectpaths();
		var_4a669fbc connectpaths();
	}
}

/*
	Name: function_863781f2
	Namespace: vengeance_temple
	Checksum: 0x48D0F0A2
	Offset: 0x5318
	Size: 0x19E
	Parameters: 1
	Flags: Linked
*/
function function_863781f2(e_player)
{
	level.var_67e1f60e = undefined;
	foreach(player in level.activeplayers)
	{
		if(isdefined(player.var_b9e5210f))
		{
			player.var_b9e5210f = undefined;
		}
	}
	skipto::objective_completed("temple");
	var_35a1e4f8 = struct::get("tag_align_dogleg_2_door", "targetname");
	if(level flag::get("temple_stealth_broken"))
	{
		var_35a1e4f8 thread scene::play("cin_ven_05_60_officedoor_1st", e_player);
	}
	else
	{
		vengeance_util::co_op_teleport_on_igc_end("cin_ven_05_60_officedoor_1st_shared", "dogleg_2_entrance_teleport");
		var_35a1e4f8 thread scene::play("cin_ven_05_60_officedoor_1st_shared", e_player);
	}
	level notify(#"hash_ad75a4f1");
	var_35a1e4f8 waittill(#"scene_done");
	level notify(#"hash_9fb1ff75");
}

/*
	Name: function_37d4d605
	Namespace: vengeance_temple
	Checksum: 0x4010AE1E
	Offset: 0x54C0
	Size: 0xF2
	Parameters: 0
	Flags: Linked
*/
function function_37d4d605()
{
	level waittill(#"hash_132639c7");
	var_c13b7e2a = struct::get_array("dogleg_2_glass_break", "targetname");
	exploder::exploder("dogleg_2_railing_break");
	foreach(var_d64f5bac in var_c13b7e2a)
	{
		glassradiusdamage(var_d64f5bac.origin, 38, 200, 175);
	}
}

/*
	Name: function_ca660ef7
	Namespace: vengeance_temple
	Checksum: 0xA0BDF0BA
	Offset: 0x55C0
	Size: 0x102
	Parameters: 0
	Flags: None
*/
function function_ca660ef7()
{
	self endon(#"death");
	level flag::wait_till("stealth_discovered");
	self.goalheight = 512;
	a_warlord_nodes = getnodearray(self.script_noteworthy, "targetname");
	foreach(node in a_warlord_nodes)
	{
		self warlordinterface::addpreferedpoint(node.origin, 4000, 8000);
	}
}

/*
	Name: function_ea758541
	Namespace: vengeance_temple
	Checksum: 0x2215ACF5
	Offset: 0x56D0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function function_ea758541(name, key)
{
	var_fc0a0636 = getentarray(name, key);
	array::thread_all(var_fc0a0636, &function_8f9d056c);
}

/*
	Name: function_3bb1295b
	Namespace: vengeance_temple
	Checksum: 0x4F35C107
	Offset: 0x5738
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_3bb1295b()
{
	guys = getaiteamarray("axis");
	guys = arraysortclosest(guys, self.origin);
	foreach(guy in guys)
	{
		if(isdefined(guy) && isalive(guy) && isdefined(guy.lase_ent))
		{
			return guy;
		}
	}
}

/*
	Name: function_8f9d056c
	Namespace: vengeance_temple
	Checksum: 0xABF12506
	Offset: 0x5838
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function function_8f9d056c()
{
	self endon(#"death");
	level endon(#"hash_8a3b89d3");
	while(true)
	{
		self waittill(#"trigger", player);
		if(isplayer(player))
		{
			self function_a1a65fdc(player);
		}
	}
}

/*
	Name: function_a1a65fdc
	Namespace: vengeance_temple
	Checksum: 0xCD132F91
	Offset: 0x58B0
	Size: 0x2B8
	Parameters: 1
	Flags: Linked
*/
function function_a1a65fdc(player)
{
	player endon(#"death_or_disconnect");
	if(isdefined(player.var_15f789fb) && player.var_15f789fb == self)
	{
		return;
	}
	var_c2918075 = gettime();
	if(isdefined(player.var_496772e9))
	{
		var_c2918075 = gettime() - player.var_496772e9;
	}
	var_d3e8dab = -1;
	if(isdefined(player.var_18091778))
	{
		var_d3e8dab = distancesquared(player.origin, player.var_18091778);
	}
	player.var_15f789fb = self;
	player.var_496772e9 = gettime();
	player thread function_b321fac9(self);
	if(var_c2918075 < 5000 && var_d3e8dab > 0 && var_d3e8dab > 10000)
	{
		if(!(isdefined(player.var_b9e5210f) && player.var_b9e5210f))
		{
			var_2dd18bed = [];
			var_2dd18bed[0] = "hend_get_off_the_rooftops_0";
			var_2dd18bed[1] = "hend_stay_off_the_rooftop_0";
			var_2dd18bed[2] = "hend_they_re_going_to_spo_0";
			player thread vengeance_util::function_ee75acde(array::random(var_2dd18bed), 0, undefined, player);
		}
		player.var_b9e5210f = 1;
		wait(4);
		if(isdefined(player.var_15f789fb) && !player istouching(player.var_15f789fb))
		{
			player.var_b9e5210f = 0;
			return;
		}
		guy = player function_3bb1295b();
		if(isdefined(guy) && isdefined(guy.lase_ent))
		{
			guy.lase_ent ai_sniper::function_b77b41d1(guy geteye(), player, guy);
		}
	}
}

/*
	Name: function_b321fac9
	Namespace: vengeance_temple
	Checksum: 0x68223329
	Offset: 0x5B70
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_b321fac9(trigger)
{
	self notify(#"hash_b321fac9");
	self endon(#"hash_b321fac9");
	self endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		if(self istouching(trigger))
		{
			self.var_18091778 = self.origin;
		}
		else
		{
			return;
		}
		wait(0.05);
	}
}

/*
	Name: function_591ead63
	Namespace: vengeance_temple
	Checksum: 0x9968D547
	Offset: 0x5C00
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_591ead63()
{
	foreach(player in level.activeplayers)
	{
		if(isdefined(player.var_b9e5210f) && player.var_b9e5210f)
		{
			return false;
		}
	}
	return true;
}

