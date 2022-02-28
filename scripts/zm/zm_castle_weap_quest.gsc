// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_castle_vo;

#using_animtree("zm_castle");

#namespace zm_castle_weap_quest;

/*
	Name: __init__sytem__
	Namespace: zm_castle_weap_quest
	Checksum: 0xEDFFC252
	Offset: 0x9C8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_castle_weap_quest", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_castle_weap_quest
	Checksum: 0xEE6081CF
	Offset: 0xA10
	Size: 0x2E8
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		level flag::init("");
	#/
	flag::init("soul_catchers_charged");
	level.soul_catchers = [];
	level.soul_catchers_vol = [];
	level.var_aa775655 = &function_1fba78c8;
	level thread create_anim_references_on_server();
	clientfield::register("actor", "make_client_clone", 5000, 4, "int");
	clientfield::register("toplayer", "bow_pickup_fx", 5000, 1, "int");
	level.var_f302359b = struct::get_array("dragon_position", "targetname");
	for(i = 0; i < level.var_f302359b.size; i++)
	{
		clientfield::register("world", level.var_f302359b[i].script_parameters, 5000, 3, "int");
		level.soul_catchers[i] = level.var_f302359b[i];
		level.soul_catchers_vol[i] = getent(level.var_f302359b[i].target, "targetname");
	}
	for(i = 0; i < level.soul_catchers.size; i++)
	{
		level.soul_catchers[i].var_98730ffa = 0;
		level.soul_catchers[i].is_eating = 0;
		level.soul_catchers[i] thread soul_catcher_check();
		level.soul_catchers[i] thread soul_catcher_state_manager();
		level.soul_catchers[i] thread function_e775e6a4("bow_door_sign_" + (i + 1));
		level.soul_catchers_vol[i] = getent(level.soul_catchers[i].target, "targetname");
	}
	level.n_soul_catchers_charged = 0;
}

/*
	Name: __main__
	Namespace: zm_castle_weap_quest
	Checksum: 0xB51F8491
	Offset: 0xD00
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	array::thread_all(level.zombie_spawners, &spawner::add_spawn_function, &zombie_spawn_func);
}

/*
	Name: create_anim_references_on_server
	Namespace: zm_castle_weap_quest
	Checksum: 0x49E64FEC
	Offset: 0xD48
	Size: 0x252
	Parameters: 0
	Flags: Linked
*/
function create_anim_references_on_server()
{
	root = %zm_castle::root;
	var_dd277883 = %zm_castle::o_zm_dlc1_dragonhead_intro;
	var_160f7e80 = %zm_castle::o_zm_dlc1_dragonhead_outtro;
	var_b86a93ed = %zm_castle::o_zm_dlc1_dragonhead_static;
	var_92a5d68e = %zm_castle::o_zm_dlc1_dragonhead_consume_pre_eat_l_2_r;
	var_799790fe = %zm_castle::o_zm_dlc1_dragonhead_consume_pre_eat_r_2_l;
	var_917cf7dd = [];
	var_917cf7dd[0] = %zm_castle::o_zm_dlc1_dragonhead_idle;
	var_16db17aa = [];
	var_16db17aa[0] = %zm_castle::o_zm_dlc1_dragonhead_idle_twitch_roar;
	var_a56e33ce = %zm_castle::ai_zm_dlc1_dragonhead_zombie_impact;
	var_bbe46e66 = %zm_castle::ai_zm_dlc1_dragonhead_zombie_rise;
	var_c7a1f434 = [];
	var_c7a1f434["right"] = %zm_castle::o_zm_dlc1_dragonhead_consume_pre_eat_r;
	var_c7a1f434["left"] = %zm_castle::o_zm_dlc1_dragonhead_consume_pre_eat_l;
	var_c7a1f434["front"] = %zm_castle::o_zm_dlc1_dragonhead_consume_pre_eat_f;
	var_977975d2["right"] = %zm_castle::o_zm_dlc1_dragonhead_consume_align_r;
	var_977975d2["left"] = %zm_castle::o_zm_dlc1_dragonhead_consume_align_l;
	var_977975d2["front"] = %zm_castle::o_zm_dlc1_dragonhead_consume_align_f;
	var_d198ed8e["right"] = %zm_castle::rtrg_ai_zm_dlc1_dragonhead_consume_zombie_align_r;
	var_d198ed8e["left"] = %zm_castle::rtrg_ai_zm_dlc1_dragonhead_consume_zombie_align_l;
	var_d198ed8e["front"] = %zm_castle::rtrg_ai_zm_dlc1_dragonhead_consume_zombie_align_f;
}

/*
	Name: soul_catcher_state_manager
	Namespace: zm_castle_weap_quest
	Checksum: 0x33C0043
	Offset: 0xFA8
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function soul_catcher_state_manager()
{
	wait(1);
	level clientfield::set(self.script_parameters, 7);
	self waittill(#"first_zombie_killed_in_zone", e_player);
	level clientfield::set(self.script_parameters, 1);
	anim_length = getanimlength(%zm_castle::rtrg_o_zm_dlc1_dragonhead_intro);
	e_player thread zm_castle_vo::function_ad27f488(anim_length);
	wait(anim_length);
	while(!self.is_charged)
	{
		level clientfield::set(self.script_parameters, 2);
		self util::waittill_either("fully_charged", "finished_eating");
	}
	level clientfield::set(self.script_parameters, 6);
}

/*
	Name: zombie_spawn_func
	Namespace: zm_castle_weap_quest
	Checksum: 0x76B43303
	Offset: 0x10E0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function zombie_spawn_func()
{
	self.actor_killed_override = &zombie_killed_override;
}

/*
	Name: zombie_killed_override
	Namespace: zm_castle_weap_quest
	Checksum: 0x6D14A0EB
	Offset: 0x1108
	Size: 0x1B4
	Parameters: 8
	Flags: Linked
*/
function zombie_killed_override(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime)
{
	if(self.archetype != "zombie")
	{
		return;
	}
	if(isplayer(attacker))
	{
		for(i = 0; i < level.soul_catchers.size; i++)
		{
			if(self istouching(level.soul_catchers_vol[i]))
			{
				if(!level.soul_catchers[i].is_charged)
				{
					self.var_56269cbf = level.soul_catchers[i];
					self.deathfunction = &zombie_soul_catcher_death;
				}
			}
		}
	}
	var_816fc685 = getent("docked_tram_car_interior", "targetname");
	var_a35e6789 = getent("player_tram_car_interior", "targetname");
	if(self istouching(var_816fc685) || self istouching(var_a35e6789))
	{
		self zombie_utility::zombie_gut_explosion();
	}
}

/*
	Name: function_1fba78c8
	Namespace: zm_castle_weap_quest
	Checksum: 0x53A5424
	Offset: 0x12C8
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function function_1fba78c8()
{
	if(self.archetype != "zombie")
	{
		return false;
	}
	for(i = 0; i < level.soul_catchers.size; i++)
	{
		if(self istouching(level.soul_catchers_vol[i]))
		{
			if(!level.soul_catchers[i].is_charged && !level.soul_catchers[i].is_eating)
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: zombie_soul_catcher_death
	Namespace: zm_castle_weap_quest
	Checksum: 0xA8F1FEB1
	Offset: 0x1380
	Size: 0x3F0
	Parameters: 8
	Flags: Linked
*/
function zombie_soul_catcher_death(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	var_56269cbf = self.var_56269cbf;
	level zm_spawner::zombie_death_points(self.origin, self.damagemod, self.damagelocation, self.attacker, self);
	level.var_63e17dd5 = self.attacker;
	if(var_56269cbf.is_eating)
	{
		return false;
	}
	if(var_56269cbf.var_98730ffa >= 8)
	{
		return false;
	}
	if(var_56269cbf.var_98730ffa == 0)
	{
		var_56269cbf.var_98730ffa = var_56269cbf.var_98730ffa + 1;
		var_56269cbf notify(#"first_zombie_killed_in_zone", self.attacker);
		var_56269cbf.is_eating = 1;
		var_56269cbf thread function_edf4b761();
		return false;
	}
	self thread zm_spawner::zombie_death_animscript();
	var_56269cbf.is_eating = 1;
	n_eating_anim = self which_eating_anim();
	client_notify_value = 1;
	self clientfield::set("make_client_clone", client_notify_value);
	self ghost();
	if(var_56269cbf.var_98730ffa >= 7)
	{
		level clientfield::set(var_56269cbf.script_parameters, 0);
	}
	var_f41bc81e = %zm_castle::ai_zm_dlc1_dragonhead_zombie_impact;
	n_anim_time = getanimlength(var_f41bc81e) + 0.2;
	wait(n_anim_time);
	level clientfield::set(var_56269cbf.script_parameters, n_eating_anim);
	if(n_eating_anim == 3)
	{
		var_a8b20b82 = (getanimlength(%zm_castle::rtrg_o_zm_dlc1_dragonhead_consume_pre_eat_f)) + (getanimlength(%zm_castle::rtrg_ai_zm_dlc1_dragonhead_consume_zombie_align_f));
	}
	else
	{
		if(n_eating_anim == 4)
		{
			var_a8b20b82 = (getanimlength(%zm_castle::rtrg_o_zm_dlc1_dragonhead_consume_pre_eat_r)) + (getanimlength(%zm_castle::rtrg_ai_zm_dlc1_dragonhead_consume_zombie_align_r));
		}
		else
		{
			var_a8b20b82 = (getanimlength(%zm_castle::rtrg_o_zm_dlc1_dragonhead_consume_pre_eat_l)) + (getanimlength(%zm_castle::rtrg_ai_zm_dlc1_dragonhead_consume_zombie_align_l));
		}
	}
	wait(var_a8b20b82 - 0.5);
	var_56269cbf.var_98730ffa++;
	wait(0.5);
	var_56269cbf notify(#"finished_eating");
	var_56269cbf.is_eating = 0;
	if(isdefined(self))
	{
		self delete();
	}
	return true;
}

/*
	Name: get_correct_model_array
	Namespace: zm_castle_weap_quest
	Checksum: 0xEB26829E
	Offset: 0x1778
	Size: 0xD8
	Parameters: 0
	Flags: None
*/
function get_correct_model_array()
{
	mod = 0;
	if(self.model == "c_zom_guard_body" && isdefined(self.hatmodel) && self.hatmodel == "c_zom_der_zombie_helmet1")
	{
		mod = 4;
	}
	if(self.head == "c_zom_zombie_barbwire_head")
	{
		return 1 + mod;
	}
	if(self.head == "c_zom_zombie_hellcatraz_head")
	{
		return 2 + mod;
	}
	if(self.head == "c_zom_zombie_mask_head")
	{
		return 3 + mod;
	}
	if(self.head == "c_zom_zombie_slackjaw_head")
	{
		return 4 + mod;
	}
	return 5;
}

/*
	Name: function_edf4b761
	Namespace: zm_castle_weap_quest
	Checksum: 0xB5C066B4
	Offset: 0x1858
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_edf4b761()
{
	anim_length = getanimlength(%zm_castle::rtrg_o_zm_dlc1_dragonhead_intro);
	wait(anim_length);
	self notify(#"hash_f77f4f21");
	self.is_eating = 0;
}

/*
	Name: which_eating_anim
	Namespace: zm_castle_weap_quest
	Checksum: 0x510B4979
	Offset: 0x18B0
	Size: 0x102
	Parameters: 0
	Flags: Linked
*/
function which_eating_anim()
{
	soul_catcher = self.var_56269cbf;
	forward_dot = vectordot(anglestoforward(soul_catcher.angles), vectornormalize(self.origin - soul_catcher.origin));
	if(forward_dot > 0.7)
	{
		return 3;
	}
	right_dot = vectordot(anglestoright(soul_catcher.angles), self.origin - soul_catcher.origin);
	if(right_dot > 0)
	{
		return 4;
	}
	return 5;
}

/*
	Name: soul_catcher_check
	Namespace: zm_castle_weap_quest
	Checksum: 0x4C15307A
	Offset: 0x19C0
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function soul_catcher_check()
{
	self.is_charged = 0;
	while(true)
	{
		if(self.var_98730ffa >= 8)
		{
			level.n_soul_catchers_charged++;
			self.is_charged = 1;
			self notify(#"fully_charged");
			break;
		}
		wait(0.05);
	}
	if(level.n_soul_catchers_charged == 1)
	{
		self thread function_54af3e05();
	}
	else if(level.n_soul_catchers_charged >= level.soul_catchers.size)
	{
		level flag::set("soul_catchers_charged");
		self thread function_b7dd8bb3();
		level.var_63e17dd5 thread zm_castle_vo::function_439c7159();
		level thread function_a01a53de();
	}
}

/*
	Name: function_e775e6a4
	Namespace: zm_castle_weap_quest
	Checksum: 0xAAA7A358
	Offset: 0x1AD0
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function function_e775e6a4(var_63530679)
{
	self waittill(#"fully_charged");
	if(self.script_label == "dragonhead_1")
	{
		m_collision = getent("uc_dragoncollision", "targetname");
		m_collision delete();
	}
	else if(self.script_label == "dragonhead_2")
	{
		m_collision = getent("lc_dragoncollision", "targetname");
		m_collision delete();
	}
}

/*
	Name: function_7b154c37
	Namespace: zm_castle_weap_quest
	Checksum: 0x99EC1590
	Offset: 0x1B98
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function function_7b154c37()
{
}

/*
	Name: function_54af3e05
	Namespace: zm_castle_weap_quest
	Checksum: 0x99EC1590
	Offset: 0x1BA8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_54af3e05()
{
}

/*
	Name: function_b7dd8bb3
	Namespace: zm_castle_weap_quest
	Checksum: 0x99EC1590
	Offset: 0x1BB8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_b7dd8bb3()
{
}

/*
	Name: function_a01a53de
	Namespace: zm_castle_weap_quest
	Checksum: 0x7450503B
	Offset: 0x1BC8
	Size: 0x294
	Parameters: 0
	Flags: Linked
*/
function function_a01a53de()
{
	/#
		if(level flag::get(""))
		{
			return;
		}
		level flag::set("");
	#/
	var_14ea0734 = struct::get("base_bow_pickup_struct", "targetname");
	level thread scene::play("p7_fxanim_zm_castle_quest_base_bow_idle_bundle");
	wait(0.25);
	level.var_15acc392 = getent("base_bow_pickup", "targetname");
	var_14ea0734 function_bb60c970();
	array::thread_all(level.players, &function_9376cff9);
	callback::on_connect(&function_c9cdf051);
	var_65a03676 = array("rune_prison_spawned", "demon_gate_spawned", "elemental_storm_spawned", "wolf_howl_spawned", "ee_start_done");
	flag::wait_till_all(var_65a03676);
	level notify(#"hash_1deaef05");
	foreach(e_player in level.players)
	{
		e_player clientfield::set_to_player("bow_pickup_fx", 0);
	}
	level scene::stop("p7_fxanim_zm_castle_quest_base_bow_idle_bundle");
	callback::remove_on_connect(&function_c9cdf051);
	zm_unitrigger::unregister_unitrigger(var_14ea0734.var_67b5dd94);
	wait(5);
	level thread struct::delete_script_bundle("scene", "p7_fxanim_zm_castle_quest_base_bow_idle_bundle");
}

/*
	Name: function_9376cff9
	Namespace: zm_castle_weap_quest
	Checksum: 0xE7C7B2CD
	Offset: 0x1E68
	Size: 0x160
	Parameters: 0
	Flags: Linked
*/
function function_9376cff9()
{
	self endon(#"death");
	level endon(#"hash_1deaef05");
	self clientfield::set_to_player("bow_pickup_fx", 1);
	var_14ea0734 = struct::get("base_bow_pickup_struct", "targetname");
	while(true)
	{
		self util::waittill_either("weapon_change", "show_base_bow");
		if(!self function_e464049a())
		{
			if(isdefined(level.var_15acc392))
			{
				level.var_15acc392 setvisibletoplayer(self);
			}
			self clientfield::set_to_player("bow_pickup_fx", 1);
		}
		else
		{
			if(isdefined(level.var_15acc392))
			{
				level.var_15acc392 setinvisibletoplayer(self);
			}
			self clientfield::set_to_player("bow_pickup_fx", 0);
		}
		var_14ea0734.var_67b5dd94 thread zm_unitrigger::run_visibility_function_for_all_triggers();
	}
}

/*
	Name: function_e464049a
	Namespace: zm_castle_weap_quest
	Checksum: 0x4C46CE70
	Offset: 0x1FD0
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function function_e464049a()
{
	if(self hasweapon(getweapon("elemental_bow")) || self hasweapon(getweapon("elemental_bow_wolf_howl")) || self hasweapon(getweapon("elemental_bow_storm")) || self hasweapon(getweapon("elemental_bow_rune_prison")) || self hasweapon(getweapon("elemental_bow_demongate")))
	{
		return true;
	}
	return false;
}

/*
	Name: function_fb853e2c
	Namespace: zm_castle_weap_quest
	Checksum: 0xE54D7704
	Offset: 0x20D0
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function function_fb853e2c()
{
	self notify(#"hash_99ff6d52");
	self endon(#"death");
	self endon(#"hash_99ff6d52");
	level endon(#"hash_1deaef05");
	var_890bca07 = getweapon("elemental_bow");
	while(true)
	{
		self util::waittill_either("projectile_impact", "zmb_max_ammo");
		if(self hasweapon(var_890bca07))
		{
			self.var_e8e28d9e = self getweaponammostock(var_890bca07);
			self.var_8f97fa0b = self getweaponammoclip(var_890bca07);
		}
	}
}

/*
	Name: function_71d4f620
	Namespace: zm_castle_weap_quest
	Checksum: 0x20B82F6F
	Offset: 0x21B8
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_71d4f620()
{
	self notify(#"hash_a1f46392");
	self endon(#"death");
	self endon(#"hash_a1f46392");
	level endon(#"hash_1deaef05");
	var_890bca07 = getweapon("elemental_bow");
	var_d95a0cf3 = -1;
	while(var_d95a0cf3 != self.characterindex)
	{
		level waittill(#"bleed_out", var_d95a0cf3);
	}
	self.var_e8e28d9e = var_890bca07.maxammo;
	self.var_8f97fa0b = var_890bca07.clipsize;
}

/*
	Name: function_c9cdf051
	Namespace: zm_castle_weap_quest
	Checksum: 0xC80FA01C
	Offset: 0x2280
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_c9cdf051()
{
	self thread function_9376cff9();
}

/*
	Name: function_bb60c970
	Namespace: zm_castle_weap_quest
	Checksum: 0x5D3F38E3
	Offset: 0x22A8
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_bb60c970()
{
	s_unitrigger = spawnstruct();
	s_unitrigger.origin = self.origin;
	s_unitrigger.angles = self.angles;
	s_unitrigger.script_unitrigger_type = "unitrigger_radius_use";
	s_unitrigger.radius = 100;
	s_unitrigger.cursor_hint = "HINT_NOICON";
	s_unitrigger.require_look_at = 1;
	zm_unitrigger::unitrigger_force_per_player_triggers(s_unitrigger, 1);
	s_unitrigger.prompt_and_visibility_func = &function_65fb1c47;
	self.var_67b5dd94 = s_unitrigger;
	zm_unitrigger::register_static_unitrigger(s_unitrigger, &function_26e22a99);
}

/*
	Name: function_65fb1c47
	Namespace: zm_castle_weap_quest
	Checksum: 0x90A21B12
	Offset: 0x23B0
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function function_65fb1c47(e_player)
{
	if(e_player function_e464049a() || e_player function_9dfa159b())
	{
		self sethintstring(&"");
		return false;
	}
	self sethintstring(&"ZM_CASTLE_PICK_UP_BASE_BOW");
	return true;
}

/*
	Name: function_26e22a99
	Namespace: zm_castle_weap_quest
	Checksum: 0x86251B11
	Offset: 0x2438
	Size: 0x2B8
	Parameters: 0
	Flags: Linked
*/
function function_26e22a99()
{
	self endon(#"kill_trigger");
	level endon(#"hash_1deaef05");
	self.stub thread zm_unitrigger::run_visibility_function_for_all_triggers();
	while(true)
	{
		self waittill(#"trigger", e_who);
		if(e_who function_e464049a() || e_who function_9dfa159b())
		{
			continue;
		}
		var_dd27188c = zm_utility::get_player_weapon_limit(e_who);
		var_d4434fab = e_who getweaponslistprimaries();
		if(var_d4434fab.size > var_dd27188c)
		{
			w_current = e_who getcurrentweapon();
			e_who zm_weapons::weapon_take(w_current);
		}
		var_e1041201 = getweapon("elemental_bow");
		e_who zm_weapons::weapon_give(var_e1041201, 0, 0, 1);
		e_who thread zm_castle_vo::base_bow_picked_up();
		if(isdefined(e_who.var_e8e28d9e))
		{
			e_who setweaponammostock(var_e1041201, e_who.var_e8e28d9e);
		}
		if(isdefined(e_who.var_8f97fa0b))
		{
			e_who setweaponammoclip(var_e1041201, e_who.var_8f97fa0b);
		}
		else
		{
			e_who setweaponammoclip(var_e1041201, var_e1041201.clipsize);
		}
		e_who switchtoweapon(var_e1041201);
		e_who thread function_fb853e2c();
		e_who thread function_71d4f620();
		level.var_15acc392 setinvisibletoplayer(e_who);
		e_who clientfield::set_to_player("bow_pickup_fx", 0);
		self.stub thread zm_unitrigger::run_visibility_function_for_all_triggers();
	}
}

/*
	Name: function_9dfa159b
	Namespace: zm_castle_weap_quest
	Checksum: 0xD8753211
	Offset: 0x26F8
	Size: 0xC6
	Parameters: 0
	Flags: Linked
*/
function function_9dfa159b()
{
	if(!self weaponcyclingenabled() || !self offhandweaponsenabled())
	{
		return true;
	}
	w_current = self getcurrentweapon();
	if(zm_utility::is_placeable_mine(w_current) || zm_equipment::is_equipment_that_blocks_purchase(w_current) || self hasweapon(getweapon("minigun")))
	{
		return true;
	}
	return false;
}

