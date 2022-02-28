// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_eth_prologue;
#using scripts\cp\cp_mi_eth_prologue_accolades;
#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;
#using scripts\cp\cp_prologue_apc;
#using scripts\cp\cp_prologue_cyber_soldiers;
#using scripts\cp\cp_prologue_hangars;
#using scripts\cp\cp_prologue_util;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\doors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace hostage_1;

/*
	Name: hostage_1_start
	Namespace: hostage_1
	Checksum: 0x2E6DB1B7
	Offset: 0x2260
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function hostage_1_start(str_objective)
{
	hostage_1_precache();
	spawner::add_spawn_function_group("fuel_tunnel_ai", "script_noteworthy", &cp_prologue_util::ai_idle_then_alert, "fuel_tunnel_alerted", 1024);
	if(!isdefined(level.ai_hendricks))
	{
		level.ai_hendricks = util::get_hero("hendricks");
		cp_mi_eth_prologue::init_hendricks("skipto_hostage_1_hendricks");
		skipto::teleport_ai(str_objective);
	}
	level.ai_hendricks.ignoreme = 1;
	level thread hostage_1_main();
}

/*
	Name: hostage_1_precache
	Namespace: hostage_1
	Checksum: 0xA59F99FE
	Offset: 0x2350
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function hostage_1_precache()
{
	level thread scene::init("cin_pro_06_01_hostage_vign_rollgrenade");
	level thread scene::init("p7_fxanim_cp_prologue_underground_truck_explode_bundle");
}

/*
	Name: hostage_1_main
	Namespace: hostage_1
	Checksum: 0x69E2F064
	Offset: 0x23A0
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function hostage_1_main()
{
	level thread cp_prologue_util::function_950d1c3b(1);
	level thread function_ca7de8e8();
	objectives::set("cp_level_prologue_free_the_minister");
	battlechatter::function_d9f49fba(1);
	cp_prologue_util::function_47a62798(1);
	level.ai_hendricks thread function_672c874();
	trigger::wait_till("hendricks_rollgrenade");
	array::thread_all(level.players, &watch_player_fire);
	level.ai_hendricks waittill(#"hash_ff2562ea");
	level thread function_88ddc4d5();
	level flag::set("fuel_tunnel_alerted");
	level thread function_5d78fd66();
	level thread function_f41e9505();
	level thread cp_prologue_util::function_8f7b1e06("t_fuel_tunnel_ai_fallback_controller", "info_fuel_tunnel_fallback_begin", "info_fuel_tunnel_fallback_end");
	level waittill(#"hash_5d08c61e");
	skipto::objective_completed("skipto_hostage_1");
}

/*
	Name: function_5d78fd66
	Namespace: hostage_1
	Checksum: 0xDD03FE32
	Offset: 0x2550
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_5d78fd66()
{
	wait(1.5);
	level thread cp_prologue_util::function_a7eac508("sp_fuel_tunnel_explosion_runners", undefined, 1024, undefined);
}

/*
	Name: function_ca7de8e8
	Namespace: hostage_1
	Checksum: 0x77D354A1
	Offset: 0x2590
	Size: 0x3A4
	Parameters: 0
	Flags: Linked
*/
function function_ca7de8e8()
{
	a_ai_enemies = getaiteamarray("axis");
	foreach(ai_enemy in a_ai_enemies)
	{
		ai_enemy delete();
	}
	level thread function_b7afdf3a();
	level thread function_e14a508d();
	spawn_manager::enable("sm_fuel_tunnel");
	spawner::simple_spawn("sp_fuel_depot_staging");
	level thread spawn_machine_gunner();
	level thread function_ee3c7f46();
	level thread function_d9bab593("t_fuel_tunnel_left_door", "fueltunnel_spawnclosetdoor_2", "sp_fuel_tunnel_left_door", "info_fuel_tunnel_left_door", "info_fuel_tunnel_fallback_end", 0);
	level thread function_d9bab593("t_fuel_tunnel_right_door", "fueltunnel_spawnclosetdoor_3", "sp_fuel_tunnel_right_door", "info_fuel_tunnel_right_door", "info_fuel_tunnel_fallback_end");
	level thread cp_prologue_util::function_8f7b1e06("t_fueling_bridge_attacker", "info_fueling_bridge_attacker", "info_grenade_truck_guys_fallback");
	level thread function_12ac9114();
	level.ai_hendricks waittill(#"hash_ff2562ea");
	level thread cp_prologue_util::function_e0fb6da9("s_enemy_moveup_point_0", 100, 15, 1, 1, 6, "info_fuel_tunnel_fallback_end", "info_grenade_truck_guys_fallback");
	level thread cp_prologue_util::function_e0fb6da9("s_enemy_moveup_point_1", 100, 15, 1, 1, 6, "info_fuel_tunnel_fallback_end", "info_grenade_truck_guys_fallback");
	level thread cp_prologue_util::function_e0fb6da9("s_enemy_moveup_point_2", 100, 15, 1, 1, 6, "info_fuel_tunnel_fallback_end", "info_grenade_truck_guys_fallback");
	level thread cp_prologue_util::function_e0fb6da9("s_enemy_moveup_point_forklift", 180, 8, 1, 1, 8, "info_fuel_tunnel_fallback_end", "info_grenade_truck_guys_fallback");
	level thread cp_prologue_util::function_e0fb6da9("s_enemy_moveup_point_4", 100, 5, 1, 1, 2, "info_fuel_tunnel_fallback_end", "info_grenade_truck_guys_fallback");
	level thread cp_prologue_util::function_e0fb6da9("s_enemy_moveup_point_5", 100, 5, 1, 1, 2, "info_fuel_tunnel_fallback_end", "info_grenade_truck_guys_fallback");
	level thread function_50d18609();
}

/*
	Name: function_b7afdf3a
	Namespace: hostage_1
	Checksum: 0x7666D252
	Offset: 0x2940
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_b7afdf3a()
{
	trigger::wait_till("t_fueling_tunnel_alert_enemy");
	level flag::set("fuel_tunnel_alerted");
}

/*
	Name: function_e14a508d
	Namespace: hostage_1
	Checksum: 0xF63C9D09
	Offset: 0x2988
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function function_e14a508d()
{
	a_ents = getentarray("sp_fueling_stairwell_intro_guys", "targetname");
	for(i = 0; i < a_ents.size; i++)
	{
		e_ent = a_ents[i] spawner::spawn();
		e_ent.overrideactordamage = &function_e93a75b6;
		e_ent.goalradius = 32;
	}
	level notify(#"hash_db677f8c");
}

/*
	Name: function_e93a75b6
	Namespace: hostage_1
	Checksum: 0xC6C793A0
	Offset: 0x2A50
	Size: 0xA6
	Parameters: 13
	Flags: Linked
*/
function function_e93a75b6(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname)
{
	if(isdefined(eattacker) && !isplayer(eattacker))
	{
		idamage = self.health + 1;
	}
	return idamage;
}

/*
	Name: function_88ddc4d5
	Namespace: hostage_1
	Checksum: 0xFEF665F4
	Offset: 0x2B00
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_88ddc4d5()
{
	level scene::add_scene_func("p7_fxanim_cp_prologue_underground_truck_explode_bundle", &function_70b550de);
	level thread scene::play("p7_fxanim_cp_prologue_underground_truck_explode_bundle");
	level clientfield::set("fuel_depot_truck_explosion", 1);
	orig_explosion = getent("orig_fuel_tunnel_explosion", "targetname");
	level.ai_hendricks radiusdamage(orig_explosion.origin, 300, 2001, 2000, undefined, "MOD_EXPLOSIVE");
}

/*
	Name: function_70b550de
	Namespace: hostage_1
	Checksum: 0x5246F697
	Offset: 0x2BF8
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function function_70b550de(a_ents)
{
	a_ents["underground_truck_explode"] waittill(#"hash_5ec0d21e");
	a_ents["underground_truck_explode"] setmodel("veh_t7_civ_truck_med_cargo_egypt_dead");
	var_f33f812b = getent("fuel_truck_faxnim_clip", "targetname");
	var_f33f812b solid();
}

/*
	Name: function_f41e9505
	Namespace: hostage_1
	Checksum: 0x56FC34CE
	Offset: 0x2C90
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_f41e9505()
{
	wait(0.5);
	level thread cp_prologue_util::function_8f7b1e06(undefined, "info_grenade_truck_guys", "info_grenade_truck_guys_fallback");
}

/*
	Name: function_ee3c7f46
	Namespace: hostage_1
	Checksum: 0x480C41F4
	Offset: 0x2CD0
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function function_ee3c7f46()
{
	trigger::wait_till("t_spawn_machine_gunner");
	m_door_r = getent("fueltunnel_spawnclosetdoor_1", "targetname");
	m_door_r rotateto(m_door_r.angles + (vectorscale((0, -1, 0), 150)), 0.5);
	m_door_r playsound("evt_spawner_door_open");
	var_8e7793a5 = getent("info_fuel_tunnel_fallback_end", "targetname");
	a_ai = getentarray("sp_fuel_tunnel_upper_door", "targetname");
	a_players = getplayers();
	if(a_players.size == 1)
	{
		n_num_to_spawn = 1;
	}
	else
	{
		if(a_players.size == 2)
		{
			n_num_to_spawn = 2;
		}
		else
		{
			n_num_to_spawn = 5;
		}
	}
	if(n_num_to_spawn > a_ai.size)
	{
		n_num_to_spawn = a_ai.size;
	}
	for(i = 0; i < n_num_to_spawn; i++)
	{
		e_ent = a_ai[i] spawner::spawn();
		e_ent thread cp_prologue_util::ai_wakamole(1024, undefined);
		wait(0.5);
	}
	level thread function_3964d78d();
}

/*
	Name: function_3964d78d
	Namespace: hostage_1
	Checksum: 0xF1761E99
	Offset: 0x2EF0
	Size: 0x2AC
	Parameters: 0
	Flags: Linked
*/
function function_3964d78d()
{
	e_volume = getent("info_final_tunnel_attackers", "targetname");
	ready = 0;
	while(!ready)
	{
		if(level.ai_hendricks istouching(e_volume))
		{
			ready = 1;
		}
		a_players = getplayers();
		for(i = 0; i < a_players.size; i++)
		{
			if(a_players[i] istouching(e_volume))
			{
				ready = 1;
			}
		}
		wait(0.05);
	}
	a_sp = getentarray("sp_fuel_tunnel_stairs_attackers", "targetname");
	for(i = 0; i < a_sp.size; i++)
	{
		e_ent = a_sp[i] spawner::spawn();
		nd_target = getnode(e_ent.target, "targetname");
		e_ent.goalradius = 140;
		e_ent setgoal(nd_target.origin);
	}
	while(true)
	{
		num_touching = cp_prologue_util::function_609c412a("info_fuel_tunnel_upper_door", 1);
		if(!num_touching)
		{
			break;
		}
		wait(0.05);
	}
	m_door_r = getent("fueltunnel_spawnclosetdoor_1", "targetname");
	m_door_r rotateto(m_door_r.angles - (vectorscale((0, -1, 0), 150)), 0.5);
	m_door_r playsound("evt_spawner_door_close");
}

/*
	Name: function_672c874
	Namespace: hostage_1
	Checksum: 0x2B96221
	Offset: 0x31A8
	Size: 0x40C
	Parameters: 0
	Flags: Linked
*/
function function_672c874()
{
	self function_8b6e6abe();
	level flag::wait_till("start_grenade_roll");
	level thread scene::play("cin_pro_06_01_hostage_vign_rollgrenade", level.ai_hendricks);
	level util::delay(0.5, undefined, &trigger::use, "t_script_color_allies_r510");
	level.ai_hendricks waittill(#"hash_ff2562ea");
	level thread cp_prologue_util::function_2a0bc326(level.ai_hendricks.origin, 0.65, 1.2, 800, 4);
	level.ai_hendricks ai::set_pacifist(0);
	level.ai_hendricks ai::set_ignoreme(0);
	level.ai_hendricks ai::set_ignoreall(0);
	s_struct = struct::get("s_truck_explosion_origin", "targetname");
	physicsexplosionsphere(s_struct.origin, 255, 254, 0.3, 25, 400);
	wait(0.1);
	var_ff31c6f9 = getentarray("truck_red_barrel", "script_noteworthy");
	foreach(piece in var_ff31c6f9)
	{
		if(isdefined(piece) && piece.targetname == "destructible")
		{
			piece dodamage(5000, piece.origin, level.ai_hendricks);
		}
	}
	wait(0.3);
	var_7bb33476 = getnode("nd_grenade_throw", "targetname");
	setenablenode(var_7bb33476, 0);
	trigger::use("t_script_color_allies_r520");
	cp_prologue_util::function_d1f1caad("t_script_color_allies_r530");
	cp_prologue_util::function_d1f1caad("t_script_color_allies_r540");
	scene::play("cin_pro_06_01_hostage_vign_jumpdown");
	self colors::enable();
	self setgoal(self.origin);
	wait(1);
	trigger::use("t_script_color_allies_r550");
	wait(1);
	self waittill(#"goal");
	self.goalradius = 256;
	cp_prologue_util::function_d1f1caad("t_script_color_allies_r560");
	function_7a05bbf();
	if(getplayers().size == 1)
	{
		level notify(#"hash_bf9ccb51");
	}
	self thread function_5dc67e92();
}

/*
	Name: function_5dc67e92
	Namespace: hostage_1
	Checksum: 0x2B08FDA
	Offset: 0x35C0
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function function_5dc67e92()
{
	self endon(#"hero_catch_up_teleport");
	e_volume = getent("info_fuel_tunnel_fallback_end", "targetname");
	while(true)
	{
		a_ai = cp_prologue_util::function_68b8f4af(e_volume);
		if(a_ai.size <= 3)
		{
			array::thread_all(a_ai, &ai::bloody_death, randomintrange(6, 8));
		}
		if(a_ai.size <= 1)
		{
			break;
		}
		wait(0.05);
	}
	e_trigger = getent("t_script_color_allies_r580", "targetname");
	if(isdefined(e_trigger))
	{
		e_trigger delete();
	}
	self thread function_386e6074();
	function_1ddfda41();
	nd_node = getnode("nd_fueling_tunnel_exit", "targetname");
	self setgoal(nd_node.origin);
	self.goalradius = 64;
	self util::waittill_notify_or_timeout("goal", 15);
	self notify(#"stop_hero_catch_up_teleport");
	self thread function_c9d7d48a();
}

/*
	Name: function_386e6074
	Namespace: hostage_1
	Checksum: 0x142C6A1C
	Offset: 0x37B0
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_386e6074()
{
	var_72634645 = spawnstruct();
	var_72634645.origin = (5742, -1122, -328);
	var_72634645.angles = vectorscale((0, 1, 0), 270);
	var_f3ec8a31 = spawn("trigger_box", (5728, -1308, -276), 0, 300, 300, 300);
	var_f3ec8a31 waittill(#"trigger");
	self colors::hero_catch_up_teleport(var_72634645, 350, 1, &function_bbaa282a);
}

/*
	Name: function_bbaa282a
	Namespace: hostage_1
	Checksum: 0xE7148E9B
	Offset: 0x3890
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_bbaa282a()
{
	wait(0.5);
	nd_node = getnode("nd_fueling_tunnel_exit", "targetname");
	self setgoal(nd_node.origin);
	self.goalradius = 64;
	self util::waittill_notify_or_timeout("goal", 15);
	self thread function_c9d7d48a();
}

/*
	Name: function_7a05bbf
	Namespace: hostage_1
	Checksum: 0x55BEDAC1
	Offset: 0x3940
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_7a05bbf()
{
	while(true)
	{
		e_trigger = getent("t_script_color_allies_r570", "targetname");
		if(!isdefined(e_trigger))
		{
			break;
		}
		num_touching = cp_prologue_util::function_609c412a("info_fuel_tunnel_fallback_end", 0);
		if(num_touching <= 3)
		{
			trigger::use("t_script_color_allies_r570");
			break;
		}
		wait(0.05);
	}
}

/*
	Name: function_1ddfda41
	Namespace: hostage_1
	Checksum: 0x9D3E02FE
	Offset: 0x39F0
	Size: 0x204
	Parameters: 0
	Flags: Linked
*/
function function_1ddfda41()
{
	e_volume = getent("info_fueling_tunnel_balcony", "targetname");
	a_enemy = cp_prologue_util::function_68b8f4af(e_volume);
	for(i = 0; i < a_enemy.size; i++)
	{
		self getperfectinfo(a_enemy[i], 1);
		a_enemy[i].overrideactordamage = &function_e93a75b6;
	}
	nd_node = getnode("nd_fueling_tunnel_top_stairs", "targetname");
	self setgoal(nd_node.origin);
	self.goalradius = 64;
	self waittill(#"goal");
	while(true)
	{
		a_enemy = cp_prologue_util::function_68b8f4af(e_volume);
		if(a_enemy.size == 0)
		{
			break;
		}
		wait(0.05);
	}
	a_ai_enemy = getaiteamarray("axis");
	while(a_ai_enemy.size > 0)
	{
		a_ai_enemy[0] ai::bloody_death();
		wait(randomfloatrange(0.6666666, 1.333333));
		a_ai_enemy = getaiteamarray("axis");
	}
}

/*
	Name: function_50d18609
	Namespace: hostage_1
	Checksum: 0x272BDFC6
	Offset: 0x3C00
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_50d18609()
{
	level waittill(#"hash_bf9ccb51");
	a_nodes = getnodearray("nd_fueling_end", "targetname");
	for(i = 0; i < a_nodes.size; i++)
	{
		nd_node = a_nodes[i];
		setenablenode(nd_node, 0);
	}
	wait(2);
	cp_prologue_util::function_8f7b1e06(undefined, "info_fuel_tunnel_fallback_end", "info_fueling_flush_out_volume");
}

/*
	Name: function_8b6e6abe
	Namespace: hostage_1
	Checksum: 0x74021E69
	Offset: 0x3CD8
	Size: 0x224
	Parameters: 0
	Flags: Linked
*/
function function_8b6e6abe()
{
	level flag::wait_till("hendricks_exit_cam_room");
	wait(0.5);
	level thread hend_fuel_depot_otr_dialog();
	self ai::set_behavior_attribute("can_melee", 0);
	self colors::disable();
	nd_node = getnode("nd_hendricks_attack_fueling_start_guys", "targetname");
	self.perfectaim = 1;
	self.goalradius = 32;
	self ai::force_goal(nd_node);
	wait(1);
	a_enemy = spawner::get_ai_group_ai("tunnel_1st_contact_guys");
	foreach(enemy in a_enemy)
	{
		if(isdefined(enemy) && isalive(enemy))
		{
			self ai::shoot_at_target("shoot_until_target_dead", enemy);
		}
	}
	spawner::waittill_ai_group_cleared("tunnel_1st_contact_guys");
	self.perfectaim = 0;
	self.goalradius = 512;
	self ai::set_behavior_attribute("can_melee", 1);
	self colors::enable();
}

/*
	Name: function_c9d7d48a
	Namespace: hostage_1
	Checksum: 0x870848CA
	Offset: 0x3F08
	Size: 0x264
	Parameters: 0
	Flags: Linked
*/
function function_c9d7d48a()
{
	e_volume = getent("info_fueling_tunnel_exit_area", "targetname");
	while(true)
	{
		num_players = cp_prologue_util::num_players_touching_volume(e_volume);
		if(num_players > 0)
		{
			break;
		}
		wait(0.05);
	}
	level thread namespace_21b2c1f2::function_d4c52995();
	wait(0.15);
	level scene::add_scene_func("cin_pro_06_02_hostage_vign_getminister_hendricks_airlock", &function_5729b9e7, "play");
	level scene::play("cin_pro_06_02_hostage_vign_getminister_hendricks_airlock");
	n_node = getnode("nd_hendricks_jail_setup", "targetname");
	level.ai_hendricks setgoal(n_node, 1);
	wait(0.5);
	level notify(#"hash_5d08c61e");
	s_struct = struct::get("s_close_security_door", "targetname");
	while(true)
	{
		v_forward = anglestoforward(s_struct.angles);
		v_dir = vectornormalize(s_struct.origin - level.ai_hendricks.origin);
		dp = vectordot(v_forward, v_dir);
		if(dp < 0)
		{
			break;
		}
		wait(0.1);
	}
	cp_prologue_util::wait_for_all_players_to_pass_struct("s_close_security_door", undefined);
	level thread function_6ae70954(0);
}

/*
	Name: function_5729b9e7
	Namespace: hostage_1
	Checksum: 0x4F67794E
	Offset: 0x4178
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_5729b9e7(a_ents)
{
	level waittill(#"hash_5729b9e7");
	level function_6ae70954(1);
}

/*
	Name: function_6ae70954
	Namespace: hostage_1
	Checksum: 0x7E6F6AA2
	Offset: 0x41B8
	Size: 0x214
	Parameters: 1
	Flags: Linked
*/
function function_6ae70954(open_door)
{
	exploder::exploder("fx_exploder_door_vacuum");
	m_door1 = getent("holdingcells_entrydoor_1", "targetname");
	m_door2 = getent("holdingcells_entrydoor_2", "targetname");
	if(open_door)
	{
		exploder::exploder("light_exploder_prison_door");
		m_door1 movex(64, 1, 0.1, 0.2);
		m_door1 playsound("evt_fueldepot_door_open");
		wait(0.25);
		m_door2 movex(64, 1, 0.1, 0.2);
		m_door2 playsound("evt_fueldepot_door_open");
	}
	else
	{
		exploder::stop_exploder("light_exploder_prison_door");
		m_door2 movex(-64, 1, 0.1, 0.2);
		m_door2 playsound("evt_fueldepot_door_close");
		wait(0.25);
		m_door1 movex(-64, 1, 0.1, 0.2);
		m_door1 playsound("evt_fueldepot_door_close");
	}
}

/*
	Name: watch_player_fire
	Namespace: hostage_1
	Checksum: 0x426FCB2E
	Offset: 0x43D8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function watch_player_fire()
{
	self endon(#"death");
	self waittill(#"weapon_fired");
	level flag::set("fuel_tunnel_alerted");
}

/*
	Name: hend_fuel_depot_otr_dialog
	Namespace: hostage_1
	Checksum: 0xE9884A88
	Offset: 0x4420
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function hend_fuel_depot_otr_dialog()
{
	trigger::wait_till("t_spawn_machine_gunner");
	wait(1);
	level.ai_hendricks dialog::say("hend_gunner_up_top_0");
	level waittill(#"hash_5d08c61e");
	level.ai_hendricks dialog::say("hend_cell_block_ahead_on_0");
}

/*
	Name: spawn_machine_gunner
	Namespace: hostage_1
	Checksum: 0x7072E264
	Offset: 0x44A0
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function spawn_machine_gunner()
{
	trigger::wait_till("t_spawn_machine_gunner");
	e_gunner = spawner::simple_spawn_single("fuel_tunnel_mg_guy");
}

/*
	Name: function_d9bab593
	Namespace: hostage_1
	Checksum: 0xE59D1A0F
	Offset: 0x44E8
	Size: 0x284
	Parameters: 6
	Flags: Linked
*/
function function_d9bab593(str_trigger, str_door, str_spawners, var_137809d6, var_343b0267, var_bfba634f = 1)
{
	e_trigger = getent(str_trigger, "targetname");
	e_trigger waittill(#"trigger");
	e_door = getent(str_door, "targetname");
	e_door rotateto(e_door.angles + (vectorscale((0, -1, 0), 110)), 0.5);
	e_door playsound("evt_spawner_door_open");
	e_goal_volume = getent(var_343b0267, "targetname");
	a_ai = getentarray(str_spawners, "targetname");
	for(i = 0; i < a_ai.size; i++)
	{
		e_ent = a_ai[i] spawner::spawn();
		e_ent setgoal(e_goal_volume);
		wait(1.5);
	}
	if(!var_bfba634f)
	{
		return;
	}
	wait(1);
	while(true)
	{
		num_touching = cp_prologue_util::function_609c412a(var_137809d6, 1);
		if(!num_touching)
		{
			break;
		}
		wait(0.05);
	}
	e_door rotateto(e_door.angles + vectorscale((0, 1, 0), 110), 0.5);
	e_door playsound("evt_spawner_door_close");
}

/*
	Name: function_12ac9114
	Namespace: hostage_1
	Checksum: 0xF943C0B0
	Offset: 0x4778
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function function_12ac9114()
{
	sp_enemy = getent("sp_stair_runners", "targetname");
	e_volume = getent("info_fuel_tunnel_fallback_end", "targetname");
	level thread function_6ae70954(1);
	level flag::wait_till("fuel_tunnel_stair_runners_1");
	ai_enemy = sp_enemy spawner::spawn();
	ai_enemy setgoal(e_volume);
	wait(1.5);
	ai_enemy = sp_enemy spawner::spawn();
	ai_enemy setgoal(e_volume);
	level flag::wait_till("fuel_tunnel_stair_runners_2");
	ai_enemy = sp_enemy spawner::spawn();
	ai_enemy setgoal(e_volume);
	wait(3);
	level thread function_6ae70954(0);
}

#namespace prison;

/*
	Name: prison_start
	Namespace: prison
	Checksum: 0x7B6030AC
	Offset: 0x4918
	Size: 0x254
	Parameters: 1
	Flags: Linked
*/
function prison_start(str_objective)
{
	prison_precache();
	if(!isdefined(level.ai_hendricks))
	{
		level.ai_hendricks = util::get_hero("hendricks");
		cp_mi_eth_prologue::init_hendricks("skipto_prison_hendricks");
		skipto::teleport_ai(str_objective);
	}
	if(!isdefined(level.ai_minister))
	{
		level.ai_minister = util::get_hero("minister");
		level.ai_minister.ignoreme = 1;
		level.ai_minister.ignoreall = 1;
		cp_mi_eth_prologue::init_minister("skipto_prison_minister");
		level.ai_minister.goalradius = 64;
	}
	if(!isdefined(level.ai_khalil))
	{
		level.ai_khalil = util::get_hero("khalil");
		level.ai_khalil.ignoreme = 1;
		level.ai_khalil.ignoreall = 1;
		cp_mi_eth_prologue::init_khalil("skipto_prison_khalil");
		level.ai_khalil.goalradius = 64;
	}
	trigger::use("t_prison_respawns_disable", "targetname", undefined, 0);
	battlechatter::function_d9f49fba(0);
	cp_prologue_util::function_47a62798(1);
	level.ai_hendricks.pacifist = 0;
	level.ai_hendricks.ignoreme = 0;
	level flag::init("khalil_door_breached");
	level flag::init("player_interrogation_breach");
	level thread prison_main();
}

/*
	Name: prison_precache
	Namespace: prison
	Checksum: 0x99EC1590
	Offset: 0x4B78
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function prison_precache()
{
}

/*
	Name: prison_main
	Namespace: prison
	Checksum: 0x192956FF
	Offset: 0x4B88
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function prison_main()
{
	level thread cp_prologue_util::function_950d1c3b(1);
	level thread function_b317c15f();
	level thread scene::init("cin_pro_06_03_hostage_1st_khalil_intro_rescue");
	security_desk::function_bfe70f02();
	level thread function_f50dec65();
	level thread function_771ca4c3();
	var_beb17601 = getent("collision_observation_door", "targetname");
	var_ddb80384 = getent("observation_door", "targetname");
	var_beb17601 linkto(var_ddb80384);
	level thread function_ef1899fb();
	level.ai_hendricks thread hendricks_update();
	level thread function_15c51270();
	level thread prisoner_dialog();
}

/*
	Name: function_f50dec65
	Namespace: prison
	Checksum: 0x570D7D2B
	Offset: 0x4D00
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_f50dec65()
{
	level thread util::set_streamer_hint(3);
	level waittill(#"hash_516cb5e4");
	util::clear_streamer_hint();
	level thread util::set_streamer_hint(4);
	level waittill(#"hash_29445f62");
	util::clear_streamer_hint();
}

/*
	Name: function_771ca4c3
	Namespace: prison
	Checksum: 0x9B10C9F8
	Offset: 0x4D80
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function function_771ca4c3()
{
	objectives::set("cp_level_prologue_free_the_minister");
	callback::on_ai_killed(&namespace_61c634f2::function_c58a9e36);
	level flag::wait_till("player_entered_observation");
	objectives::complete("cp_level_prologue_goto_minister_door");
	level waittill(#"hash_a859aef4");
	objectives::complete("cp_level_prologue_free_the_minister");
	savegame::checkpoint_save();
	level waittill(#"khalil_available");
	trigger::use("t_prison_respawns_enable", "targetname", undefined, 0);
	s_pos = struct::get("s_objective_khalil_cell", "targetname");
	objectives::set("cp_level_prologue_goto_khalil_door", s_pos);
	objectives::set("cp_level_prologue_free_khalil");
	level flag::wait_till("khalil_door_breached");
	objectives::complete("cp_level_prologue_goto_minister_door");
	objectives::complete("cp_level_prologue_free_khalil");
	callback::remove_on_ai_killed(&namespace_61c634f2::function_c58a9e36);
	objectives::set("cp_level_prologue_get_to_the_surface");
	level waittill(#"hendricks_by_weapon_room");
	level thread objectives::breadcrumb("post_prison_breadcrumb_start");
}

/*
	Name: hendricks_update
	Namespace: prison
	Checksum: 0x2D9D08B
	Offset: 0x4F78
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function hendricks_update()
{
	nd_node = getnode("nd_hendricks_jail_setup", "targetname");
	self setgoal(nd_node, 1);
	self waittill(#"goal");
	level flag::wait_till("post_up_minister_breach");
	level thread function_a1ad4aa7();
	self sethighdetail(1);
	function_a859aef4();
	self sethighdetail(0);
}

/*
	Name: function_22b149da
	Namespace: prison
	Checksum: 0x87E2748F
	Offset: 0x5050
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_22b149da()
{
	level waittill(#"hash_5ea48ae9");
	level thread namespace_21b2c1f2::function_1c0460dd();
	level waittill(#"hash_35308140");
	level.ai_hendricks dialog::say("hend_depot_ahead_will_be_0");
}

/*
	Name: function_f48bd4a7
	Namespace: prison
	Checksum: 0x83E23E6E
	Offset: 0x50B0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_f48bd4a7()
{
	level waittill(#"hash_1dd905ef");
	exploder::exploder("light_exploder_prison_exit");
}

/*
	Name: function_a859aef4
	Namespace: prison
	Checksum: 0x11C999F0
	Offset: 0x50E8
	Size: 0x1EA
	Parameters: 0
	Flags: Linked
*/
function function_a859aef4()
{
	trig_khalil_door = getent("trig_use_khalil_door", "targetname");
	trig_khalil_door triggerenable(0);
	level thread scene::play("cin_pro_06_03_hostage_vign_breach_hendrickscover");
	level flag::wait_till("player_entered_observation");
	level thread function_b8c0a930();
	if(isdefined(level.bzm_prologuedialogue4callback))
	{
		level thread [[level.bzm_prologuedialogue4callback]]();
	}
	level flag::wait_till_any(array("interrogation_finished", "player_breached_early"));
	level thread scene::play("cin_pro_06_03_hostage_vign_breach");
	level thread scene::play("cin_pro_06_03_hostage_vign_breach_hend_min");
	level notify(#"hash_a859aef4");
	level.ai_minister.overrideactordamage = undefined;
	level waittill(#"khalil_available");
	trig_khalil_door triggerenable(1);
	var_d86e08d0 = util::init_interactive_gameobject(trig_khalil_door, &"cp_prompt_enteralt_prologue_khalil_breach", &"CP_MI_ETH_PROLOGUE_DOOR_BREACH", &function_28af2208);
	var_d86e08d0 thread gameobjects::hide_icon_distance_and_los((1, 1, 1), 800, 0);
	level notify(#"hash_bd4342ed");
}

/*
	Name: function_db5cf0d5
	Namespace: prison
	Checksum: 0xFFF10DFC
	Offset: 0x52E0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_db5cf0d5()
{
	self endon(#"death");
	level endon(#"hash_a59a51");
	level endon(#"hash_bedc2f57");
	self waittill(#"weapon_fired");
	level flag::set("player_breached_early");
}

/*
	Name: function_a1ad4aa7
	Namespace: prison
	Checksum: 0x4C7331EC
	Offset: 0x5340
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_a1ad4aa7()
{
	level waittill(#"hash_5e84ced9");
	level clientfield::set("interrogate_physics", 1);
}

/*
	Name: function_28af2208
	Namespace: prison
	Checksum: 0x6CA8042
	Offset: 0x5380
	Size: 0x18C
	Parameters: 1
	Flags: Linked
*/
function function_28af2208(e_player)
{
	self gameobjects::disable_object();
	array::run_all(level.players, &util::set_low_ready, 1);
	callback::on_spawned(&cp_mi_eth_prologue::function_4d4f1d4f);
	level thread function_2137acd9();
	level flag::set("khalil_door_breached");
	level thread scene::play("cin_pro_06_03_hostage_1st_khalil_intro_player_rescue", e_player);
	level thread scene::play("cin_pro_06_03_hostage_1st_khalil_intro_rescue");
	level.ai_khalil sethighdetail(1);
	level thread function_22b149da();
	level thread function_f48bd4a7();
	level waittill(#"hendricks_by_weapon_room");
	level.ai_khalil sethighdetail(0);
	level notify(#"hash_29445f62");
	skipto::objective_completed("skipto_prison");
}

/*
	Name: function_2137acd9
	Namespace: prison
	Checksum: 0x65A902A6
	Offset: 0x5518
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_2137acd9()
{
	wait(42);
	array::run_all(level.players, &util::set_low_ready, 0);
	callback::remove_on_spawned(&cp_mi_eth_prologue::function_4d4f1d4f);
	level thread cp_prologue_util::base_alarm_goes_off();
	level thread function_fae1bd07();
}

/*
	Name: function_fae1bd07
	Namespace: prison
	Checksum: 0xBD72F079
	Offset: 0x55A8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_fae1bd07()
{
	playsoundatposition("amb_walla_troops_1", (6175, -1548, -157));
	wait(8);
	playsoundatposition("amb_walla_troops_0", (6129, -1037, -266));
}

/*
	Name: function_b8c0a930
	Namespace: prison
	Checksum: 0x3161F09F
	Offset: 0x5610
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_b8c0a930()
{
	level.ai_minister.overrideactordamage = &function_9b720436;
}

/*
	Name: function_9b720436
	Namespace: prison
	Checksum: 0x5063CE04
	Offset: 0x5640
	Size: 0x134
	Parameters: 13
	Flags: Linked
*/
function function_9b720436(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname)
{
	if(isdefined(eattacker) && isplayer(eattacker))
	{
		if(idamage <= 1 || (isdefined(weapon) && weapon.isemp))
		{
			idamage = 0;
		}
		if(!isdefined(self.var_28e02422))
		{
			self.var_28e02422 = 0;
		}
		self.var_28e02422 = self.var_28e02422 + idamage;
		if(self.var_28e02422 >= self.maxhealth)
		{
			util::missionfailedwrapper_nodeath(&"CP_MI_ETH_PROLOGUE_MINISTER_SHOT", &"SCRIPT_MISSIONFAIL_WATCH_FIRE");
		}
		else
		{
			idamage = 0;
		}
	}
	return idamage;
}

/*
	Name: function_ef1899fb
	Namespace: prison
	Checksum: 0x999322EE
	Offset: 0x5780
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_ef1899fb()
{
	var_130a032 = getent("trig_use_minister_door", "targetname");
	var_130a032 triggerenable(1);
	var_e0897b20 = util::init_interactive_gameobject(var_130a032, &"cp_prompt_enteralt_prologue_minister_breach", &"CP_MI_ETH_PROLOGUE_DOOR_BREACH", &function_b0c29b02);
	var_e0897b20 thread gameobjects::hide_icon_distance_and_los((1, 1, 1), 800, 0);
}

/*
	Name: function_b0c29b02
	Namespace: prison
	Checksum: 0x3068BB35
	Offset: 0x5838
	Size: 0x18C
	Parameters: 1
	Flags: Linked
*/
function function_b0c29b02(e_player)
{
	self.trigger triggerenable(0);
	self gameobjects::disable_object();
	foreach(var_12195048 in level.activeplayers)
	{
		var_12195048 util::set_low_ready(1);
		var_12195048 thread function_db5cf0d5();
	}
	callback::on_spawned(&cp_mi_eth_prologue::function_4d4f1d4f);
	level flag::set("player_interrogation_breach");
	level scene::play("cin_pro_06_03_hostage_vign_breach_playerbreach", e_player);
	level notify(#"hash_516cb5e4");
	level thread dialog::player_say("plyr_interrogator_has_his_0", 3);
	level thread function_813f55a8();
}

/*
	Name: function_f8d7f50a
	Namespace: prison
	Checksum: 0x597E5E14
	Offset: 0x59D0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_f8d7f50a(a_ents)
{
	e_door = a_ents["observation_door"];
	e_door setmodel("p7_door_metal_security_02_rt_keypad");
	level waittill(#"hash_18c83555");
	e_door setmodel("p7_door_metal_security_02_rt_keypad_damage");
}

/*
	Name: function_b317c15f
	Namespace: prison
	Checksum: 0xD06242C1
	Offset: 0x5A48
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_b317c15f()
{
	level scene::add_scene_func("cin_pro_06_03_hostage_vign_breach_interrogation", &function_b8d7b823, "init");
	level scene::init("cin_pro_06_03_hostage_vign_breach_interrogation");
	level waittill(#"hash_5c0ece37");
	scene::add_scene_func("cin_pro_06_03_hostage_vign_breach_guardloop", &function_53775c4d, "play");
	level thread scene::play("cin_pro_06_03_hostage_vign_breach_guardloop");
	level scene::play("cin_pro_06_03_hostage_vign_breach_interrogation");
	level flag::set("interrogation_finished");
}

/*
	Name: function_b8d7b823
	Namespace: prison
	Checksum: 0x8A26A2AD
	Offset: 0x5B48
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function function_b8d7b823(a_ents)
{
	a_ents["interrogator"].cybercomtargetstatusoverride = 0;
	a_ents["interrogator"] cybercom::cybercom_aioptout("cybercom_fireflyswarm");
	level waittill(#"ready_to_breach");
	level.ai_hendricks dialog::say("hend_on_my_mark_0");
	wait(1);
	level.ai_hendricks thread dialog::say("hend_three_two_go_0");
	level thread namespace_21b2c1f2::function_2f85277b();
	wait(1);
	foreach(e_player in level.activeplayers)
	{
		e_player util::set_low_ready(0);
	}
	callback::remove_on_spawned(&cp_mi_eth_prologue::function_4d4f1d4f);
}

/*
	Name: function_53775c4d
	Namespace: prison
	Checksum: 0xC9D56732
	Offset: 0x5CC8
	Size: 0xBA
	Parameters: 1
	Flags: Linked
*/
function function_53775c4d(a_ents)
{
	foreach(ai_guard in a_ents)
	{
		ai_guard.var_c54411a6 = 1;
		ai_guard.cybercomtargetstatusoverride = 0;
		ai_guard cybercom::cybercom_aioptout("cybercom_fireflyswarm");
	}
}

/*
	Name: function_813f55a8
	Namespace: prison
	Checksum: 0xC752078B
	Offset: 0x5D90
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_813f55a8()
{
	trigger::wait_till("trig_dam_int_room");
	level thread cp_prologue_util::function_2a0bc326(level.ai_hendricks.origin, 0.3, 0.75, 5000, 10, "damage_heavy");
	var_d3079b09 = getent("int_room_sound_wall", "targetname");
	var_d3079b09 delete();
	hidemiscmodels("interrogation_glass_hologram");
	exploder::exploder("fx_exploder_glass_screen");
}

/*
	Name: function_15c51270
	Namespace: prison
	Checksum: 0x6AB64A9E
	Offset: 0x5E70
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_15c51270()
{
	level thread function_88b82e8a();
	level waittill(#"hash_a859aef4");
	level thread function_b1d2594d();
	level flag::wait_till("khalil_door_breached");
	level thread namespace_21b2c1f2::function_fb4a2ce1();
}

/*
	Name: function_88b82e8a
	Namespace: prison
	Checksum: 0xC7F11E40
	Offset: 0x5EF0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_88b82e8a()
{
	level endon(#"hash_df5cca92");
	wait(17);
	level.ai_hendricks dialog::say("hend_that_exfil_won_t_wai_0");
}

/*
	Name: function_b1d2594d
	Namespace: prison
	Checksum: 0x82AF6675
	Offset: 0x5F30
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_b1d2594d()
{
	level endon(#"hash_94c473aa");
	level waittill(#"hash_bd4342ed");
	wait(20);
	level.ai_hendricks dialog::say("hend_sooner_we_get_khalil_0");
	wait(15);
	level.ai_hendricks dialog::say("hend_they_re_gonna_be_on_0");
}

/*
	Name: prisoner_dialog
	Namespace: prison
	Checksum: 0x5718FEF9
	Offset: 0x5FA8
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function prisoner_dialog()
{
	level thread cell_prisoner_message_update("trig_volume_prisoner1_cell", "pris_please_please_help_0");
	level thread cell_prisoner_message_update("trig_volume_prisoner2_cell", "pris_get_us_out_of_here_0");
	level thread cell_prisoner_message_update("trig_volume_prisoner3_cell", "pris_don_t_leave_me_here_0");
	level thread cell_prisoner_message_update("trig_volume_prisoner4_cell", "pris_please_help_us_0");
}

/*
	Name: cell_prisoner_message_update
	Namespace: prison
	Checksum: 0x726DE23E
	Offset: 0x6058
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function cell_prisoner_message_update(str_trigger, str_vo)
{
	level trigger::wait_till(str_trigger, "targetname", undefined, 0);
	level.ai_hendricks dialog::say(str_vo);
}

#namespace security_desk;

/*
	Name: security_desk_start
	Namespace: security_desk
	Checksum: 0x227CA899
	Offset: 0x60C0
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function security_desk_start(str_objective)
{
	security_desk_precache();
	level.ai_hendricks ai::set_ignoreall(0);
	level.ai_minister ai::set_ignoreall(0);
	battlechatter::function_d9f49fba(1);
	cp_prologue_util::function_47a62798(1);
	spawner::add_spawn_function_group("bridge_attacker", "script_noteworthy", &hangar::ai_think);
	level thread security_desk_main();
	trigger::wait_till("t_start_lift_battle");
	skipto::objective_completed("skipto_security_desk");
}

/*
	Name: security_desk_precache
	Namespace: security_desk
	Checksum: 0x99EC1590
	Offset: 0x61C0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function security_desk_precache()
{
}

/*
	Name: security_desk_main
	Namespace: security_desk
	Checksum: 0xD8B20055
	Offset: 0x61D0
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function security_desk_main()
{
	level thread cp_prologue_util::function_950d1c3b(1);
	level thread function_e6af47cb();
	level thread function_5e374f7a();
	trig_weapon_room_door = getent("trig_open_weapons_room", "targetname");
	trig_weapon_room_door triggerenable(1);
	level flag::wait_till("open_weapons_room");
	level thread namespace_21b2c1f2::function_6c35b4f3();
	level thread bioweapon_objective_handler();
}

/*
	Name: function_bfe70f02
	Namespace: security_desk
	Checksum: 0x2375AC3
	Offset: 0x62C0
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function function_bfe70f02()
{
	if(!isdefined(level.var_e5ed7cda))
	{
		scene::init("cin_pro_07_01_securitydesk_vign_weapons_doorinit");
		level.var_e5ed7cda = 1;
	}
}

/*
	Name: function_5e374f7a
	Namespace: security_desk
	Checksum: 0x7EF4EBF6
	Offset: 0x6300
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_5e374f7a()
{
	level flag::wait_till("open_weapons_room");
	level waittill(#"hash_ecefb6c8");
	level thread function_4fd5aaec();
	wait(1);
	level thread function_bce54c0b();
	level thread function_36113d75();
	level thread function_680575de();
}

/*
	Name: function_4fd5aaec
	Namespace: security_desk
	Checksum: 0xCE883277
	Offset: 0x6398
	Size: 0x29E
	Parameters: 0
	Flags: Linked
*/
function function_4fd5aaec()
{
	a_ai = getentarray("sp_armory_lift_area_1st_attacker", "targetname");
	for(i = 0; i < a_ai.size; i++)
	{
		e_ent = a_ai[i] spawner::spawn();
		nd_node = getnode(e_ent.target, "targetname");
		e_ent.goalradius = 64;
		e_ent setgoal(nd_node.origin);
		e_ent thread cp_prologue_util::ai_wakamole(256, 1);
	}
	e_volume = getent("info_armory_enemy_pushup", "targetname");
	a_ai = getentarray("sp_armory_lift_area_attackers", "targetname");
	for(i = 0; i < a_ai.size; i++)
	{
		e_ent = a_ai[i] spawner::spawn();
		e_ent setgoal(e_volume);
		e_ent thread cp_prologue_util::ai_wakamole(512, 1);
	}
	e_volume = getent("info_armory_wave2", "targetname");
	a_ai = getentarray("sp_armory_lift_area_attackers_part2", "targetname");
	for(i = 0; i < a_ai.size; i++)
	{
		e_ent = a_ai[i] spawner::spawn();
		e_ent setgoal(e_volume);
		e_ent thread cp_prologue_util::ai_wakamole(512, 1);
	}
}

/*
	Name: function_bce54c0b
	Namespace: security_desk
	Checksum: 0x6EC3DE8F
	Offset: 0x6640
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_bce54c0b()
{
	a_spawners = getentarray("sp_armory_walkway_attackers", "targetname");
	for(i = 0; i < a_spawners.size; i++)
	{
		e_ent = a_spawners[i] spawner::spawn();
		wait(1.5);
	}
	wait(3);
	level thread function_ad03757a();
}

/*
	Name: function_36113d75
	Namespace: security_desk
	Checksum: 0x57A2607B
	Offset: 0x66F0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_36113d75()
{
	level thread cp_prologue_util::function_e0fb6da9("s_armory_moveup_start", 240, 7, 1, 1, 3, "info_armory_wave2", "info_armory_enemy_pushup");
	level thread cp_prologue_util::function_e0fb6da9("s_armory_moveup_point_left", 240, 4, 1, 1, 6, "info_armory_wave2", "info_armory_enemy_pushup");
	level thread cp_prologue_util::function_e0fb6da9("s_armory_moveup_point_right", 240, 4, 1, 1, 6, "info_armory_wave2", "info_armory_enemy_pushup");
}

/*
	Name: function_e6af47cb
	Namespace: security_desk
	Checksum: 0xA9A98A4D
	Offset: 0x67C0
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function function_e6af47cb()
{
	level flag::wait_till("open_weapons_room");
	level.ai_hendricks setgoal(level.ai_hendricks.origin);
	level.ai_hendricks clearforcedgoal();
	level.ai_hendricks.goalradius = 64;
	level thread function_473b7de8();
	wait(2);
	trigger::use("trig_armory_color");
	cp_prologue_util::function_d1f1caad("t_script_color_allies_r2010");
	cp_prologue_util::function_d1f1caad("t_script_color_allies_r2020");
	cp_prologue_util::function_d1f1caad("t_script_color_allies_r2030");
	cp_prologue_util::function_d1f1caad("t_script_color_allies_r2040");
}

/*
	Name: function_473b7de8
	Namespace: security_desk
	Checksum: 0x3B59A3DE
	Offset: 0x68D8
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function function_473b7de8()
{
	while(!scene::is_ready("cin_pro_07_01_securitydesk_vign_weapons"))
	{
		wait(0.05);
	}
	scene::add_scene_func("cin_pro_07_01_securitydesk_vign_weapons", &function_d4401b52);
	scene::play("cin_pro_07_01_securitydesk_vign_weapons");
	level notify(#"hash_69db142c");
	nd_node = getnode("nd_khalil_armory_battle", "targetname");
	level.ai_khalil.goalradius = 64;
	level.ai_khalil setgoal(nd_node.origin);
	level.ai_khalil waittill(#"goal");
	level.ai_khalil.goalradius = 512;
}

/*
	Name: function_d4401b52
	Namespace: security_desk
	Checksum: 0x6C33AF91
	Offset: 0x69F0
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function function_d4401b52(a_ents)
{
	level endon(#"security_desk_done");
	level.ai_minister ai::gun_remove();
	level.ai_khalil ai::gun_remove();
	level.ai_minister waittill(#"weapon_swap");
	a_ents["arak_m"] hide();
	level.ai_minister ai::gun_recall();
	level.ai_khalil waittill(#"hash_2dc522e9");
	a_ents["arak_k"] hide();
	level.ai_khalil ai::gun_recall();
}

/*
	Name: function_ad03757a
	Namespace: security_desk
	Checksum: 0x589803B0
	Offset: 0x6AD0
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function function_ad03757a()
{
	wait(3);
	a_ai = spawner::get_ai_group_ai("security_balcony");
	if(a_ai.size > 0)
	{
		var_b5dd40c7 = array::random(a_ai);
		var_b5dd40c7 scene::play("cin_pro_07_01_securitydesk_vign_dropdown", var_b5dd40c7);
		if(isalive(var_b5dd40c7))
		{
			var_b5dd40c7 setgoal(var_b5dd40c7.origin);
			var_b5dd40c7.goalradius = 512;
		}
	}
}

/*
	Name: function_680575de
	Namespace: security_desk
	Checksum: 0xB94DC2D0
	Offset: 0x6BB0
	Size: 0xB6
	Parameters: 0
	Flags: Linked
*/
function function_680575de()
{
	cp_prologue_util::function_520255e3("t_armory_wave2", 5);
	a_sp = getentarray("sp_armory_wave2", "targetname");
	for(i = 0; i < a_sp.size; i++)
	{
		e_ent = a_sp[i] spawner::spawn();
		e_ent thread function_2fa59109();
	}
}

/*
	Name: function_2fa59109
	Namespace: security_desk
	Checksum: 0x6FD31327
	Offset: 0x6C70
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_2fa59109()
{
	e_volume = getent("info_armory_wave2", "targetname");
	self setgoal(e_volume);
}

/*
	Name: need_weapon_message
	Namespace: security_desk
	Checksum: 0x2976FA64
	Offset: 0x6CC8
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function need_weapon_message()
{
	level.ai_khalil thread dialog::say("khal_i_need_to_get_my_wea_0");
}

/*
	Name: bioweapon_objective_handler
	Namespace: security_desk
	Checksum: 0xB379975F
	Offset: 0x6CF8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function bioweapon_objective_handler()
{
	objectives::set("cp_level_prologue_defend_khalil", level.ai_khalil);
	level waittill(#"hash_69db142c");
	objectives::complete("cp_level_prologue_defend_khalil");
}

#namespace lift_escape;

/*
	Name: lift_escape_precache
	Namespace: lift_escape
	Checksum: 0xF8213853
	Offset: 0x6D50
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function lift_escape_precache()
{
	level flag::init("lift_arrived");
	level flag::init("crane_in_position");
	level flag::init("crane_dropped");
	level.var_1dd14818 = 0;
}

/*
	Name: lift_escape_start
	Namespace: lift_escape
	Checksum: 0x46C7131E
	Offset: 0x6DC8
	Size: 0x364
	Parameters: 1
	Flags: Linked
*/
function lift_escape_start(str_objective)
{
	lift_escape_precache();
	if(!isdefined(level.ai_hendricks))
	{
		level.ai_hendricks = util::get_hero("hendricks");
		cp_mi_eth_prologue::init_hendricks();
		level.ai_hendricks.goalradius = 16;
		level.ai_minister = util::get_hero("minister");
		cp_mi_eth_prologue::init_minister();
		level.ai_minister ai::set_ignoreme(1);
		level.ai_khalil = util::get_hero("khalil");
		cp_mi_eth_prologue::init_khalil();
		level.ai_khalil ai::set_ignoreme(1);
		skipto::teleport_ai(str_objective);
	}
	callback::on_ai_killed(&namespace_61c634f2::function_cbaf37cd);
	var_489e46a = getent("t_regroup_lift", "targetname");
	var_489e46a triggerenable(0);
	trigger::use("t_lift_respawns_disable");
	exploder::stop_exploder("light_exploder_prison_exit");
	level.ai_hendricks ai::set_ignoreall(0);
	level.ai_minister ai::set_ignoreall(0);
	battlechatter::function_d9f49fba(1);
	cp_prologue_util::function_47a62798(1);
	level thread function_9793598c();
	level thread function_5517d018();
	level thread function_6fabe3da();
	level thread function_b17bd9c5();
	function_e97f7dba();
	var_489e46a = getent("t_regroup_lift", "targetname");
	var_489e46a triggerenable(1);
	trigger::use("t_lift_respawns_enable");
	level thread function_a3dbf6a2();
	level thread lift_escape_cleanup();
	level waittill(#"hash_b100689e");
	callback::remove_on_ai_killed(&namespace_61c634f2::function_cbaf37cd);
	skipto::objective_completed("skipto_lift_escape");
}

/*
	Name: function_9793598c
	Namespace: lift_escape
	Checksum: 0x1B610609
	Offset: 0x7138
	Size: 0x2EC
	Parameters: 0
	Flags: Linked
*/
function function_9793598c()
{
	level thread function_b1017ede();
	level thread cp_prologue_util::function_e0fb6da9("s_lift_enemy_moveup_point_1", 130, 10, 1, 2, 10, "v_lift_fallback", "info_lift_start_right_side");
	level thread function_eeb1c74e();
	level thread function_30a5bc5();
	level thread function_c8950894();
	level thread function_a86c4e88();
	level thread cp_prologue_util::function_40e4b0cf("sm_lift_start_left_side", "sp_lift_start_left_side", "info_lift_start_left_side");
	if(level.activeplayers.size > 1)
	{
		level thread cp_prologue_util::function_40e4b0cf("sm_lift_start_right_side", "sp_lift_start_right_side", "info_lift_start_right_side");
	}
	else
	{
		spawn_manager::kill("sm_lift_start_right_side");
	}
	level thread function_8a1821e("t_left_start_fallback", "info_left_start_fallback", "v_lift_fallback");
	level thread function_8a1821e("t_right_start_fallback", "info_lift_start_right_side", "v_lift_fallback");
	level thread function_8949fadf();
	level thread function_51da5fc6();
	trigger::wait_till("t_lift_reinforcements", undefined, undefined, 0);
	a_spawners = getentarray("sp_stairs_guy_wave2", "targetname");
	foreach(sp_spawner in a_spawners)
	{
		sp_spawner spawner::spawn();
	}
	level thread cp_prologue_util::function_40e4b0cf("sm_lift_final_attackers", "sp_lift_final_attackers", "v_lift_fallback");
	level thread function_93c4d161();
}

/*
	Name: function_b1017ede
	Namespace: lift_escape
	Checksum: 0x6E6DC19A
	Offset: 0x7430
	Size: 0x244
	Parameters: 0
	Flags: Linked
*/
function function_b1017ede()
{
	level endon(#"hash_631a1949");
	a_players = getplayers();
	if(a_players.size > 1)
	{
		return;
	}
	start_time = gettime();
	var_c2798c63 = getent("info_lift_players_camping", "targetname");
	var_a9dae27c = getent("info_lift_area_volume", "targetname");
	while(true)
	{
		e_player = getplayers()[0];
		time = gettime();
		if(e_player istouching(var_c2798c63))
		{
			dt = (time - start_time) / 1000;
			if(dt > 15)
			{
				var_f2c0d323 = 0;
				a_enemy = cp_prologue_util::function_68b8f4af(var_a9dae27c);
				for(i = 0; i < a_enemy.size; i++)
				{
					e_enemy = a_enemy[i];
					if(!isdefined(e_enemy.var_4383fc69))
					{
						e_enemy.var_4383fc69 = 1;
						e_enemy.goalradius = 200;
						e_enemy setgoal(e_player.origin);
						start_time = time;
						var_f2c0d323 = 1;
						break;
					}
				}
				if(!var_f2c0d323)
				{
					return;
				}
			}
		}
		else
		{
			start_time = time;
		}
		wait(0.05);
	}
}

/*
	Name: function_a86c4e88
	Namespace: lift_escape
	Checksum: 0x47C76B03
	Offset: 0x7680
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_a86c4e88()
{
	cp_prologue_util::function_d1f1caad("t_lift_intro_runners");
	wait(10);
	level thread cp_prologue_util::function_a7eac508("sp_lift_intro_rightside_backup", undefined, undefined, undefined);
}

/*
	Name: function_eeb1c74e
	Namespace: lift_escape
	Checksum: 0xC7B6544F
	Offset: 0x76D0
	Size: 0x27E
	Parameters: 0
	Flags: Linked
*/
function function_eeb1c74e()
{
	level flag::wait_till("lift_arrived");
	wait(10);
	var_91737097 = getent("info_lift_area_volume", "targetname");
	var_2320a476 = getent("info_lift_start_area_volume", "targetname");
	while(true)
	{
		if(isdefined(level.var_1f5f8798) && level.var_1f5f8798)
		{
			return;
		}
		a_ai = getaiteamarray("axis");
		count = 0;
		for(i = 0; i < a_ai.size; i++)
		{
			if(a_ai[i] istouching(var_2320a476))
			{
				count++;
			}
		}
		if(count <= 2)
		{
			break;
		}
		wait(0.05);
	}
	a_ai = getaiteamarray("axis");
	a_enemy = [];
	for(i = 0; i < a_ai.size; i++)
	{
		e_ent = a_ai[i];
		if(e_ent istouching(var_91737097) && !e_ent istouching(var_2320a476))
		{
			a_enemy[a_enemy.size] = e_ent;
		}
	}
	count = a_enemy.size;
	if(count > 3)
	{
		count = 3;
	}
	for(i = 0; i < count; i++)
	{
		e_ent = a_enemy[i];
		e_ent setgoal(var_2320a476);
	}
}

/*
	Name: function_30a5bc5
	Namespace: lift_escape
	Checksum: 0x3D443E64
	Offset: 0x7958
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_30a5bc5()
{
	cp_prologue_util::function_d1f1caad("t_lift_intro_runners");
	level thread cp_prologue_util::function_a7eac508("sp_lift_intro_runners", 64, 64, undefined);
}

/*
	Name: function_c8950894
	Namespace: lift_escape
	Checksum: 0x28F049D6
	Offset: 0x79A8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_c8950894()
{
	cp_prologue_util::function_d1f1caad("t_intro_guys_on_bridge");
	cp_prologue_util::function_73acb160("sp_lift_stairs_intro_guys", undefined);
}

/*
	Name: function_b17bd9c5
	Namespace: lift_escape
	Checksum: 0xAAD521EF
	Offset: 0x79E8
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function function_b17bd9c5()
{
	level.ai_hendricks.script_accuracy = 0.6;
	level.ai_minister.script_accuracy = 0.6;
	level.ai_khalil.script_accuracy = 0.6;
	level thread function_17d64396();
	trigger::use("t_script_color_allies_r920");
	trigger::wait_till("t_script_color_allies_r950");
	level flag::wait_till("crane_in_position");
	if(!level flag::get("crane_dropped"))
	{
		e_target = util::spawn_model("tag_origin", struct::get("s_destroy_pipes", "targetname").origin);
		e_target.health = 1000;
		level.ai_hendricks ai::shoot_at_target("normal", e_target, "tag_origin", 3);
		e_target delete();
		t_damage = getent("crane_damage_trigger", "targetname");
		if(isdefined(t_damage))
		{
			t_damage useby(level.ai_hendricks);
		}
	}
}

/*
	Name: function_e97f7dba
	Namespace: lift_escape
	Checksum: 0x75C614E3
	Offset: 0x7BC8
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function function_e97f7dba()
{
	spawner::waittill_ai_group_cleared("lift_area");
	level thread namespace_21b2c1f2::function_49fef8f4();
	level thread function_d4734ff1();
	level thread function_6f04ae03();
	level.ai_hendricks thread send_hendricks_to_lift();
	level.ai_khalil thread function_f92b76b7();
	level.ai_minister thread function_c3ab179b();
	level flag::wait_till("hendricks_in_lift");
	level flag::wait_till("minister_in_lift");
	level flag::wait_till("khalil_in_lift");
	while(!level scene::is_ready("cin_pro_09_01_intro_1st_cybersoldiers_diaz_attack") || !level scene::is_ready("cin_pro_09_01_intro_1st_cybersoldiers_maretti_attack") || !level scene::is_ready("cin_pro_09_01_intro_1st_cybersoldiers_sarah_attack") || !level scene::is_ready("cin_pro_09_01_intro_1st_cybersoldiers_taylor_attack"))
	{
		wait(0.05);
	}
}

/*
	Name: function_17d64396
	Namespace: lift_escape
	Checksum: 0x2D37BFA0
	Offset: 0x7D70
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function function_17d64396()
{
	cp_prologue_util::function_d1f1caad("entering_lift_fight");
	start_time = gettime();
	while(true)
	{
		time = gettime();
		dt = (time - start_time) / 1000;
		if(dt > 10)
		{
			num_touching = cp_prologue_util::function_609c412a("info_lift_start_area_volume", 0);
			if(num_touching <= 2)
			{
				break;
			}
		}
		wait(0.05);
	}
	e_trigger = getent("t_script_color_allies_r930", "targetname");
	if(isdefined(e_trigger))
	{
		trigger::use("t_script_color_allies_r930");
	}
}

/*
	Name: function_8a1821e
	Namespace: lift_escape
	Checksum: 0x47BFEC4D
	Offset: 0x7E88
	Size: 0x156
	Parameters: 3
	Flags: Linked
*/
function function_8a1821e(str_trigger, var_fc9c675e, var_62ec3b42)
{
	e_trigger = getent(str_trigger, "targetname");
	if(isdefined(e_trigger))
	{
		e_trigger waittill(#"trigger");
	}
	var_cc6832b6 = getent(var_fc9c675e, "targetname");
	var_97e01c0a = getent(var_62ec3b42, "targetname");
	a_ai = getaiteamarray("axis");
	for(i = 0; i < a_ai.size; i++)
	{
		e_ent = a_ai[i];
		if(e_ent istouching(var_cc6832b6))
		{
			e_ent setgoalvolume(var_97e01c0a);
		}
	}
}

/*
	Name: function_d4734ff1
	Namespace: lift_escape
	Checksum: 0x9A46799E
	Offset: 0x7FE8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_d4734ff1()
{
	level thread scene::init("cin_pro_09_01_intro_1st_cybersoldiers_diaz_attack");
	level thread scene::init("cin_pro_09_01_intro_1st_cybersoldiers_maretti_attack");
	level thread scene::init("cin_pro_09_01_intro_1st_cybersoldiers_sarah_attack");
	level thread scene::init("cin_pro_09_01_intro_1st_cybersoldiers_taylor_attack");
}

/*
	Name: function_a3dbf6a2
	Namespace: lift_escape
	Checksum: 0x6D7BEC2
	Offset: 0x8078
	Size: 0x360
	Parameters: 0
	Flags: Linked
*/
function function_a3dbf6a2()
{
	trigger::wait_till("t_lift_interior");
	var_d39a9d5b = getent("player_lift_clip", "targetname");
	var_d39a9d5b movez(124, 0.05);
	level.var_5b3ac1ed = 1;
	level scene::add_scene_func("cin_pro_09_01_intro_1st_cybersoldiers_elevator_ride", &intro_cyber_soldiers::function_679e7da9, "play");
	level thread scene::play("cin_pro_09_01_intro_1st_cybersoldiers_lift_pushbutton");
	level.ai_minister.goalradius = 16;
	level.ai_minister.goalheight = 1600;
	level.ai_minister setgoal(level.ai_minister.origin);
	level.ai_khalil.goalradius = 16;
	level.ai_khalil.goalheight = 1600;
	level.ai_khalil setgoal(level.ai_khalil.origin);
	level notify(#"lift_is_moving");
	level thread function_45ed0d4b(0, 1.5);
	level waittill(#"hash_9e4059e6");
	level.e_lift = getent("freight_lift", "targetname");
	level.e_lift setmovingplatformenabled(1);
	level.e_lift playsound("evt_freight_lift_start");
	level.snd_lift = spawn("script_origin", level.e_lift.origin);
	level.snd_lift linkto(level.e_lift);
	level.snd_lift playloopsound("evt_freight_lift_loop");
	level thread function_4d214c02(1);
	level thread function_e19320a1(1);
	level.e_lift thread scene::play("cin_pro_09_01_intro_1st_cybersoldiers_elevator");
	level.var_3dce3f88 movez(270, 16.3);
	level.var_3dce3f88 thread function_5bd223b0();
	wait(16.3 - 2);
	setdvar("grenadeAllowRigidBodyPhysics", "1");
	level notify(#"hash_b100689e");
	level.var_b100689e = 1;
}

/*
	Name: function_5bd223b0
	Namespace: lift_escape
	Checksum: 0xEABB26E4
	Offset: 0x83E0
	Size: 0x12E
	Parameters: 0
	Flags: Linked
*/
function function_5bd223b0()
{
	self endon(#"death");
	self waittill(#"movedone");
	var_18f37a5b = getent("t_lift_interior", "targetname");
	a_s_spots = struct::get_array("lift_left_behind", "targetname");
	for(i = 0; i < level.activeplayers.size; i++)
	{
		player = level.activeplayers[i];
		if(player istouching(var_18f37a5b))
		{
			player setorigin(a_s_spots[i].origin);
			player setplayerangles(a_s_spots[i].angles);
		}
	}
}

/*
	Name: function_e19320a1
	Namespace: lift_escape
	Checksum: 0xC2815EFA
	Offset: 0x8518
	Size: 0x164
	Parameters: 1
	Flags: Linked
*/
function function_e19320a1(n_delay = 0.05)
{
	wait(n_delay);
	exploder::stop_exploder("light_exploder_lift_inside");
	exploder::exploder("light_exploder_lift_rising");
	exploder::exploder("light_exploder_igc_cybersoldier");
	exploder::exploder("fx_exploder_door_open_dust");
	mdl_door_left = getent("hangar_lift_door_left", "targetname");
	mdl_door_right = getent("hangar_lift_door_right", "targetname");
	playsoundatposition("evt_freight_lift_abovedoor", mdl_door_right.origin);
	mdl_door_left movey(104, 5);
	mdl_door_right movey(104 * -1, 5);
}

/*
	Name: function_4d214c02
	Namespace: lift_escape
	Checksum: 0xEDF71BBF
	Offset: 0x8688
	Size: 0x1B0
	Parameters: 1
	Flags: Linked
*/
function function_4d214c02(delay)
{
	wait(delay);
	while(!(isdefined(level.var_b100689e) && level.var_b100689e))
	{
		foreach(player in level.players)
		{
			player playrumbleonentity("cp_prologue_rumble_lift");
		}
		wait(0.5);
	}
	start_time = gettime();
	while(true)
	{
		time = gettime();
		dt = (time - start_time) / 1000;
		if(dt > 8)
		{
			break;
		}
		foreach(player in level.players)
		{
			player playrumbleonentity("cp_prologue_rumble_lift");
		}
		wait(0.5);
	}
}

/*
	Name: function_17ecef2
	Namespace: lift_escape
	Checksum: 0x44C7DE3B
	Offset: 0x8840
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function function_17ecef2()
{
	self.script_accuracy = 0.5;
	self.overrideactordamage = &function_10ffa58e;
}

/*
	Name: function_10ffa58e
	Namespace: lift_escape
	Checksum: 0xBF17D8AE
	Offset: 0x8878
	Size: 0xB8
	Parameters: 13
	Flags: Linked
*/
function function_10ffa58e(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname)
{
	if((self.health - idamage) <= 0)
	{
		if(isdefined(eattacker) && isplayer(eattacker))
		{
			eattacker notify(#"hash_38f375b6");
		}
	}
	return idamage;
}

/*
	Name: lift_escape_cleanup
	Namespace: lift_escape
	Checksum: 0x8DD56F83
	Offset: 0x8938
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function lift_escape_cleanup()
{
	level waittill(#"hash_b100689e");
	wait(2);
	if(isdefined(level.str_guard_lift))
	{
		cp_mi_eth_prologue::deletegroupdelete(level.str_guard_lift);
	}
	if(isdefined(level.str_guards_at_elevator))
	{
		cp_mi_eth_prologue::deletegroupdelete(level.str_guards_at_elevator);
	}
	level.ai_minister.goalheight = 80;
	level.ai_khalil.goalheight = 80;
	a_ai = getaiteamarray("axis");
	for(i = 0; i < a_ai.size; i++)
	{
		a_ai[i] delete();
	}
}

/*
	Name: cleanup
	Namespace: lift_escape
	Checksum: 0x51272AFF
	Offset: 0x8A38
	Size: 0xEA
	Parameters: 2
	Flags: None
*/
function cleanup(spawn_mgr_name, ai_groups_name)
{
	spawn_manager::kill(spawn_mgr_name);
	var_db932442 = spawner::get_ai_group_ai(ai_groups_name);
	foreach(ai_dude in var_db932442)
	{
		if(isalive(ai_dude))
		{
			ai_dude delete();
		}
	}
}

/*
	Name: get_to_lift_wait
	Namespace: lift_escape
	Checksum: 0x61B88850
	Offset: 0x8B30
	Size: 0x8C
	Parameters: 1
	Flags: None
*/
function get_to_lift_wait(str_s_target)
{
	s_target = struct::get(str_s_target, "targetname");
	self.at_lift = undefined;
	self.goalradius = 128;
	self setgoalpos(s_target.origin);
	self waittill(#"goal");
	self.at_lift = 1;
}

/*
	Name: send_hendricks_to_lift
	Namespace: lift_escape
	Checksum: 0x4B1C3849
	Offset: 0x8BC8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function send_hendricks_to_lift()
{
	self colors::disable();
	scene::add_scene_func("cin_pro_09_01_intro_1st_cybersoldiers_elevator_ride_start_hendricks", &function_3703e000, "play");
	level scene::play("cin_pro_09_01_intro_1st_cybersoldiers_elevator_ride_start_hendricks");
	level flag::set("hendricks_in_lift");
}

/*
	Name: function_c3ab179b
	Namespace: lift_escape
	Checksum: 0x2BDA4124
	Offset: 0x8C60
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_c3ab179b()
{
	self ai::set_behavior_attribute("vignette_mode", "slow");
	scene::add_scene_func("cin_pro_09_01_intro_1st_cybersoldiers_elevator_ride_start_minister", &function_6d36e736, "play");
	level scene::play("cin_pro_09_01_intro_1st_cybersoldiers_elevator_ride_start_minister");
	self setgoal(self.origin, 1);
	level flag::set("minister_in_lift");
}

/*
	Name: function_f92b76b7
	Namespace: lift_escape
	Checksum: 0x9764EAD7
	Offset: 0x8D28
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_f92b76b7()
{
	self ai::set_behavior_attribute("vignette_mode", "slow");
	scene::add_scene_func("cin_pro_09_01_intro_1st_cybersoldiers_elevator_ride_start_khalil", &function_789cecd6, "play");
	level scene::play("cin_pro_09_01_intro_1st_cybersoldiers_elevator_ride_start_khalil");
	self setgoal(self.origin, 1);
	level flag::set("khalil_in_lift");
}

/*
	Name: function_3703e000
	Namespace: lift_escape
	Checksum: 0x73023C63
	Offset: 0x8DF0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_3703e000(a_ents)
{
	level endon(#"hash_7880f194");
	wait(6);
	level flag::set("hendricks_in_lift");
}

/*
	Name: function_6d36e736
	Namespace: lift_escape
	Checksum: 0x4C79B06E
	Offset: 0x8E38
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_6d36e736(a_ents)
{
	level endon(#"hash_9368976");
	wait(4);
	level flag::set("minister_in_lift");
}

/*
	Name: function_789cecd6
	Namespace: lift_escape
	Checksum: 0x567AFC6C
	Offset: 0x8E80
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_789cecd6(a_ents)
{
	level endon(#"hash_4c888af6");
	wait(6.7);
	level flag::set("khalil_in_lift");
}

/*
	Name: function_8949fadf
	Namespace: lift_escape
	Checksum: 0x7469CBD8
	Offset: 0x8EC8
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function function_8949fadf()
{
	e_trigger = getent("t_lift_player_advances", "targetname");
	if(isdefined(e_trigger))
	{
		e_trigger waittill(#"trigger");
	}
	level thread cp_prologue_util::function_a7eac508("sp_lift_player_advances", 64, 64, undefined);
	level.var_1f5f8798 = 1;
}

/*
	Name: function_51da5fc6
	Namespace: lift_escape
	Checksum: 0xF19DC9D7
	Offset: 0x8F50
	Size: 0x49C
	Parameters: 0
	Flags: Linked
*/
function function_51da5fc6()
{
	level.e_lift = getent("freight_lift", "targetname");
	level.var_3dce3f88 = spawn("script_model", level.e_lift.origin);
	level.e_lift linkto(level.var_3dce3f88);
	level.e_lift setmovingplatformenabled(1);
	level.e_lift thread function_f2f20b35();
	exploder::exploder("light_exploder_lift_inside");
	function_dfbe3c61();
	a_spawners = getentarray("sp_lift_reinforcements", "targetname");
	for(i = 0; i < a_spawners.size; i++)
	{
		a_spawners[i] spawner::add_spawn_function(&function_38a8e28b);
		a_spawners[i] spawner::spawn();
	}
	v_down = (0, 0, -1);
	dist = 354;
	move_time = 5;
	v_lift_destination = level.e_lift.origin + (v_down * dist);
	level.var_3dce3f88 moveto(v_lift_destination, move_time);
	level.e_lift = getent("freight_lift", "targetname");
	level.e_lift playsound("evt_freight_lift_start");
	snd_lift = spawn("script_origin", level.e_lift.origin);
	snd_lift linkto(level.e_lift);
	snd_lift playloopsound("evt_freight_lift_loop");
	level.var_3dce3f88 waittill(#"movedone");
	level.var_3dce3f88 scene::init("cin_pro_08_01_liftescape_vign_lift_doorsopen", level.e_lift);
	snd_lift stoploopsound(0.1);
	setdvar("grenadeAllowRigidBodyPhysics", "0");
	open_time = 1.5;
	level thread function_45ed0d4b(1, open_time);
	wait(open_time + 0.1);
	nd_lift_traversal = getnode("n_lift_entrance_begin3", "targetname");
	linktraversal(nd_lift_traversal);
	level flag::set("lift_arrived");
	a_nodes = getnodearray("nd_exit_lift", "targetname");
	a_ai = getentarray("sp_lift_reinforcements_ai", "targetname");
	for(i = 0; i < a_ai.size; i++)
	{
		a_ai[i] thread function_c6db42e4(a_nodes[i]);
	}
	wait(1);
	level.ai_hendricks dialog::say("hend_spotted_more_reinfor_0");
}

/*
	Name: function_c6db42e4
	Namespace: lift_escape
	Checksum: 0x910488E1
	Offset: 0x93F8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_c6db42e4(nd_node)
{
	self endon(#"death");
	self util::stop_magic_bullet_shield();
	self.goalradius = 64;
	self setgoal(nd_node.origin);
	self waittill(#"goal");
	self.goalradius = 1024;
}

/*
	Name: function_38a8e28b
	Namespace: lift_escape
	Checksum: 0x5F5B4038
	Offset: 0x9478
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_38a8e28b()
{
	self.goalradius = 64;
	self.var_37b94263 = 1;
	self util::magic_bullet_shield();
}

/*
	Name: function_93c4d161
	Namespace: lift_escape
	Checksum: 0xFFC41143
	Offset: 0x94B8
	Size: 0x226
	Parameters: 0
	Flags: Linked
*/
function function_93c4d161()
{
	e_volume = getent("info_lift_start_area_volume", "targetname");
	while(true)
	{
		var_b9c84787 = getaiteamarray("axis");
		if(var_b9c84787.size < 5)
		{
			a_enemy = cp_prologue_util::function_68b8f4af(e_volume);
			if(a_enemy.size < 3)
			{
				break;
			}
		}
		wait(0.05);
	}
	var_d6bb42cf = getent("v_lift_fallback", "targetname");
	for(i = 0; i < a_enemy.size; i++)
	{
		e_ai = a_enemy[i];
		e_ai setgoal(var_d6bb42cf);
	}
	var_d6bb42cf = getent("info_lift_area_volume", "targetname");
	while(true)
	{
		a_enemy = cp_prologue_util::function_68b8f4af(e_volume);
		if(a_enemy.size <= 1)
		{
			break;
		}
		wait(0.05);
	}
	for(i = 0; i < a_enemy.size; i++)
	{
		e_player = getplayers()[0];
		e_enemy = a_enemy[i];
		e_enemy.goalradius = 200;
		e_enemy setgoal(e_player);
	}
}

/*
	Name: function_dfbe3c61
	Namespace: lift_escape
	Checksum: 0x7B084EC6
	Offset: 0x96E8
	Size: 0x106
	Parameters: 0
	Flags: Linked
*/
function function_dfbe3c61()
{
	cp_prologue_util::function_d1f1caad("entering_lift_fight");
	start_time = gettime();
	while(true)
	{
		time = gettime();
		dt = (time - start_time) / 1000;
		if(dt > 20)
		{
			e_trigger = getent("t_lift_reinforcements", "targetname");
			if(!isdefined(e_trigger))
			{
				break;
			}
			num_touching = cp_prologue_util::function_609c412a("info_lift_area_volume", 0);
			if(num_touching < 3)
			{
				break;
			}
		}
		wait(0.05);
	}
	level notify(#"hash_631a1949");
}

/*
	Name: function_f2f20b35
	Namespace: lift_escape
	Checksum: 0x5FAFE553
	Offset: 0x97F8
	Size: 0x304
	Parameters: 0
	Flags: Linked
*/
function function_f2f20b35()
{
	probe_lift = getent("probe_lift", "targetname");
	probe_lift linkto(self);
	light_lift = getent("light_lift", "targetname");
	light_lift linkto(self);
	var_51875481 = getentarray("light_lift_02", "targetname");
	foreach(light in var_51875481)
	{
		light linkto(self);
	}
	var_51875481 = getentarray("light_lift_03", "targetname");
	foreach(light in var_51875481)
	{
		light linkto(self);
	}
	var_51875481 = getentarray("light_lift_panel_anim01", "targetname");
	foreach(light in var_51875481)
	{
		light linkto(self);
	}
	light_lift = getent("light_lift_panel_anim02", "targetname");
	light_lift linkto(self);
	level waittill(#"hash_a1a67fd8");
	exploder::exploder("light_lift_panel_green");
}

/*
	Name: function_45ed0d4b
	Namespace: lift_escape
	Checksum: 0x79CF6136
	Offset: 0x9B08
	Size: 0x31C
	Parameters: 2
	Flags: Linked
*/
function function_45ed0d4b(open_door, move_time)
{
	var_507d66a5 = getent("lift_door_top", "targetname");
	var_3d3eb4dd = getent("lift_door_bottom", "targetname");
	v_up = (0, 0, 1);
	move_amount = 100;
	if(open_door)
	{
		if(level.var_1dd14818 == 1)
		{
			return;
		}
		v_dest = var_507d66a5.origin + (v_up * move_amount);
		var_507d66a5 moveto(v_dest, move_time);
		v_dest = var_3d3eb4dd.origin + (v_up * (move_amount * -1));
		var_3d3eb4dd moveto(v_dest, move_time);
		level.var_1dd14818 = 1;
	}
	else
	{
		if(level.var_1dd14818 == 0)
		{
			return;
		}
		v_dest = var_507d66a5.origin + (v_up * (move_amount * -1));
		var_507d66a5 moveto(v_dest, move_time);
		v_dest = var_3d3eb4dd.origin + (v_up * move_amount);
		var_3d3eb4dd moveto(v_dest, move_time);
		level.var_1dd14818 = 0;
	}
	var_3d3eb4dd playsound("evt_freight_elev_door_start");
	snd_door = spawn("script_origin", var_3d3eb4dd.origin);
	snd_door linkto(var_3d3eb4dd);
	snd_door playloopsound("evt_freight_elev_door_loop");
	wait(move_time);
	var_3d3eb4dd playsound("evt_freight_elev_door_stop");
	snd_door stoploopsound(0.1);
	if(open_door)
	{
		level.var_3dce3f88 scene::play("cin_pro_08_01_liftescape_vign_lift_doorsopen", level.e_lift);
	}
	else
	{
		level.var_3dce3f88 scene::play("cin_pro_08_01_liftescape_vign_lift_doorsclose", level.e_lift);
	}
}

/*
	Name: function_5517d018
	Namespace: lift_escape
	Checksum: 0x8BC0C0C6
	Offset: 0x9E30
	Size: 0x36C
	Parameters: 0
	Flags: Linked
*/
function function_5517d018()
{
	e_trigger = getent("crane_damage_trigger", "targetname");
	e_trigger triggerenable(0);
	cp_prologue_util::function_d1f1caad("t_intro_guys_on_bridge");
	level thread scene::play("p7_fxanim_cp_prologue_ceiling_underground_crane_bundle", "scriptbundlename");
	level waittill(#"hash_231a1398");
	level flag::set("crane_in_position");
	e_trigger triggerenable(1);
	e_trigger waittill(#"trigger", e_who);
	e_trigger delete();
	level thread scene::play("p7_fxanim_cp_prologue_ceiling_underground_crane_shot_bundle");
	level waittill(#"hash_1cda5581");
	level flag::set("crane_dropped");
	a_ai = getaiteamarray("axis");
	e_volume = getent("info_crane_drop", "targetname");
	for(i = 0; i < a_ai.size; i++)
	{
		if(isalive(a_ai[i]) && a_ai[i] istouching(e_volume))
		{
			a_ai[i] kill();
			if(isplayer(e_who))
			{
				namespace_61c634f2::function_d248b92b(e_who);
			}
		}
	}
	foreach(player in level.players)
	{
		if(player istouching(e_volume))
		{
			player dodamage(500, e_volume.origin);
		}
	}
	e_volume delete();
	var_2fd07777 = getent("lifttunnel_pipecollision", "targetname");
	var_2fd07777 movez(-80, 0.05);
}

/*
	Name: function_6fabe3da
	Namespace: lift_escape
	Checksum: 0x1E70B52C
	Offset: 0xA1A8
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_6fabe3da()
{
	trigger::wait_till("entering_lift_fight");
	level.ai_hendricks dialog::say("hend_that_s_our_exit_car_0");
	cp_prologue_util::function_520255e3("t_lift_reinforcements", 60);
	level.ai_hendricks dialog::say("hend_elevator_s_right_the_0");
	level waittill(#"lift_is_moving");
	level thread namespace_21b2c1f2::function_9f50ebc2();
	level thread namespace_21b2c1f2::function_c4c71c7();
}

/*
	Name: function_6f04ae03
	Namespace: lift_escape
	Checksum: 0xF2AFF467
	Offset: 0xA268
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_6f04ae03()
{
	level endon(#"lift_is_moving");
	level.ai_hendricks dialog::say("hend_let_s_move_get_to_t_0");
	wait(15);
	level.ai_hendricks dialog::say("hend_keep_pushing_forward_0");
}

