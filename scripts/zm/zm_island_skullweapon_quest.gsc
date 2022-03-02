// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_ai_spiders;
#using scripts\zm\_zm_ai_thrasher;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_island_util;
#using scripts\zm\zm_island_vo;

#namespace zm_island_skullquest;

/*
	Name: __init__sytem__
	Namespace: zm_island_skullquest
	Checksum: 0xEDD9D6B4
	Offset: 0x1268
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_skullquest", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_island_skullquest
	Checksum: 0x64DF121F
	Offset: 0x12A8
	Size: 0x2E4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("world", "keeper_spawn_portals", 1, 1, "int");
	clientfield::register("actor", "keeper_fx", 1, 1, "int");
	clientfield::register("actor", "ritual_attacker_fx", 1, 1, "int");
	clientfield::register("world", "skullquest_ritual_1_fx", 1, 3, "int");
	clientfield::register("world", "skullquest_ritual_2_fx", 1, 3, "int");
	clientfield::register("world", "skullquest_ritual_3_fx", 1, 3, "int");
	clientfield::register("world", "skullquest_ritual_4_fx", 1, 3, "int");
	clientfield::register("scriptmover", "skullquest_finish_start_fx", 1, 1, "int");
	clientfield::register("scriptmover", "skullquest_finish_trail_fx", 1, 1, "int");
	clientfield::register("scriptmover", "skullquest_finish_end_fx", 1, 1, "int");
	clientfield::register("scriptmover", "skullquest_finish_done_glow_fx", 1, 1, "int");
	callback::on_spawned(&on_player_spawned);
	scene::add_scene_func("scene_zm_dlc2_zombie_quick_rise_v2", &function_1c624caf, "done");
	level flag::init("a_player_got_skullgun");
	callback::on_spawned(&function_940267cd);
	callback::on_spawned(&function_ba04e236);
	callback::on_spawned(&function_e0075c9f);
}

/*
	Name: main
	Namespace: zm_island_skullquest
	Checksum: 0x5F79C743
	Offset: 0x1598
	Size: 0x14C8
	Parameters: 0
	Flags: Linked
*/
function main()
{
	/#
		level thread function_18d60013();
	#/
	level.var_b34be0cd = array(0, 1, 2, 0, 3);
	level.var_53df8575 = array(0, "p7_zm_isl_pedestal_battle", "p7_zm_isl_pedestal_blood", "p7_zm_isl_pedestal_chaos", "p7_zm_isl_pedestal_doom");
	level.var_8b0a8fa9 = &"ZM_ISLAND_SKULL_GET";
	level.var_983da0e6 = &"ZM_ISLAND_SKULL_PUT";
	level.var_8b418269 = &"ZM_ISLAND_SKULL_START";
	level.var_452c59e0 = 0;
	level.var_3846d9a8 = 0;
	level.var_55c48492 = getent("mdl_skullgun", "targetname");
	level.var_55c48492.var_5cd7e450 = level.var_55c48492.origin;
	level.var_55c48492.var_d7778aba = level.var_55c48492.angles;
	level.var_b2152df5 = struct::get("s_utrig_get_skullgun", "targetname");
	var_cdbcb282 = getentarray("mdl_skull_s", "targetname");
	var_a7ba3819 = getentarray("mdl_skull_p", "targetname");
	var_45f27370 = getentarray("mdl_skulltar", "targetname");
	var_9d3ee5ea = struct::get_array("s_skulltar_skull_pos", "targetname");
	var_71b2b241 = struct::get_array("s_skulltar_attractor_src", "targetname");
	var_ca0fb49a = struct::get_array("s_skulltar_base_pos", "targetname");
	var_d76f80e0 = struct::get_array("s_utrig_pillar", "targetname");
	var_4b5bea8 = struct::get_array("s_utrig_skulltar", "targetname");
	/#
		assert(var_cdbcb282.size == 4, "" + var_cdbcb282.size);
	#/
	/#
		assert(var_a7ba3819.size == 4, "" + var_a7ba3819.size);
	#/
	level.var_cdbcb282 = [];
	level.var_d76f80e0 = [];
	level.var_a576e0b9 = [];
	for(i = 1; i <= 4; i++)
	{
		level.var_a576e0b9[i] = spawnstruct();
		level.var_a576e0b9[i].targetname = "skullquest_" + i;
		level.var_a576e0b9[i].var_d38f69da = [];
		level.var_a576e0b9[i].var_41335b73 = [];
		level.var_a576e0b9[i].var_ed98dfad = [];
		level.var_a576e0b9[i] flag::init("skullquest_completed");
		level flag::init("skull_p_retrieved_for_ritual_" + i);
	}
	var_ed98dfad = struct::get_array("s_skulltar_attack_pos", "targetname");
	foreach(s_skulltar_attack_pos in var_ed98dfad)
	{
		array::add(level.var_a576e0b9[s_skulltar_attack_pos.script_special].var_ed98dfad, s_skulltar_attack_pos);
	}
	for(i = 0; i < 4; i++)
	{
		level.var_cdbcb282[var_cdbcb282[i].script_special] = var_cdbcb282[i];
		level.var_a576e0b9[var_cdbcb282[i].script_special].mdl_skull_s = var_cdbcb282[i];
		level.var_a576e0b9[var_cdbcb282[i].script_special].mdl_skull_s.var_5cd7e450 = var_cdbcb282[i].origin;
		level.var_a576e0b9[var_cdbcb282[i].script_special].mdl_skull_s.var_d7778aba = var_cdbcb282[i].angles;
		level.var_a576e0b9[var_cdbcb282[i].script_special].mdl_skull_s.var_afb64bf6 = undefined;
		level.var_a576e0b9[var_cdbcb282[i].script_special].mdl_skull_s.var_f7d3c273 = level.var_a576e0b9[var_cdbcb282[i].script_special].mdl_skull_s.script_special;
		level.var_a576e0b9[var_a7ba3819[i].script_special].mdl_skull_p = var_a7ba3819[i];
		level.var_a576e0b9[var_a7ba3819[i].script_special].mdl_skull_p.var_5cd7e450 = var_a7ba3819[i].origin;
		level.var_a576e0b9[var_a7ba3819[i].script_special].mdl_skull_p.var_d7778aba = var_a7ba3819[i].angles;
		level.var_a576e0b9[var_a7ba3819[i].script_special].mdl_skull_p.var_afb64bf6 = undefined;
		level.var_a576e0b9[var_a7ba3819[i].script_special].mdl_skull_p ghost();
		level.var_a576e0b9[var_a7ba3819[i].script_special].mdl_skull_p.var_f7d3c273 = level.var_a576e0b9[var_a7ba3819[i].script_special].mdl_skull_p.script_special;
		level.var_d76f80e0[var_d76f80e0[i].script_special] = var_d76f80e0[i];
		level.var_a576e0b9[var_d76f80e0[i].script_special].s_utrig_pillar = var_d76f80e0[i];
		level.var_a576e0b9[var_4b5bea8[i].script_special].s_utrig_skulltar = var_4b5bea8[i];
		level.var_a576e0b9[var_9d3ee5ea[i].script_special].s_skulltar_skull_pos = var_9d3ee5ea[i];
		level.var_a576e0b9[var_71b2b241[i].script_special].s_skulltar_attractor_src = var_71b2b241[i];
		level.var_a576e0b9[var_ca0fb49a[i].script_special].s_skulltar_base_pos = var_ca0fb49a[i];
		level.var_a576e0b9[var_45f27370[i].script_special].mdl_skulltar = var_45f27370[i];
	}
	level.var_21406c35 = [];
	for(i = 0; i < 4; i++)
	{
		level.var_21406c35[i] = i + 1;
	}
	level.var_21406c35 = array::randomize(level.var_21406c35);
	for(i = 3; i >= 0; i--)
	{
		level.var_21406c35[i + 1] = level.var_21406c35[i];
	}
	var_5bdf835e = [];
	array::add(var_5bdf835e, "zone_start_water");
	array::add(var_5bdf835e, "zone_start");
	array::add(var_5bdf835e, "zone_start_2");
	var_35dd08f5 = [];
	array::add(var_35dd08f5, "zone_crash_site");
	array::add(var_35dd08f5, "zone_crash_site_2");
	var_fda8e8c = [];
	array::add(var_fda8e8c, "zone_operating_rooms");
	var_80db60d2 = [];
	array::add(var_80db60d2, "zone_cliffside");
	var_aa15c945 = [];
	var_aa15c945[1] = var_5bdf835e;
	var_aa15c945[2] = var_35dd08f5;
	var_aa15c945[3] = var_fda8e8c;
	var_aa15c945[4] = var_80db60d2;
	level.var_e534ade = getentarray("dais_center", "targetname");
	level.var_9046e7b0 = level.var_e534ade[0];
	if(isdefined(level.var_9046e7b0))
	{
		for(i = 1; i < level.var_e534ade.size; i++)
		{
			level.var_e534ade[i] linkto(level.var_9046e7b0);
		}
	}
	level scene::init("p7_fxanim_zm_island_alter_stairs_bundle");
	level.var_1a9b1b91 = getent("dais_altar", "targetname");
	level.var_9046e7b0.var_9c93e17 = level.var_9046e7b0.origin;
	level.var_1a9b1b91.var_9c93e17 = level.var_1a9b1b91.origin;
	level.var_9046e7b0.v_open_pos = level.var_9046e7b0.origin - vectorscale((0, 0, 1), 256);
	level.var_1a9b1b91.v_open_pos = level.var_1a9b1b91.origin + vectorscale((1, 0, 0), 24);
	level.var_b10ab148 = 0;
	level flag::init("skull_quest_complete");
	for(i = 1; i <= 4; i++)
	{
		level.var_a576e0b9[i].script_special = i;
		level.var_a576e0b9[i].var_ba133ee2 = ("skullquest_ritual_" + level.var_a576e0b9[i].script_special) + "_fx";
		level.var_a576e0b9[i].origin = level.var_a576e0b9[i].s_skulltar_skull_pos.origin;
		level.var_a576e0b9[i].angles = level.var_a576e0b9[i].s_skulltar_skull_pos.angles;
		var_8fb7dd10 = "skullquest_ritual_failed_" + i;
		level zm_island_vo::function_65f8953a(var_8fb7dd10, "response", "negative", 5, 0, 0.5, level.var_a576e0b9[i].origin);
		var_4a347901 = ("skulltar_" + i) + "_spawnpts";
		level.var_a576e0b9[i].a_s_spawnpts = struct::get_array(var_4a347901, "targetname");
		level.var_a576e0b9[i].var_aa15c945 = var_aa15c945[i];
		var_c0032031 = level.var_21406c35[i];
		level.var_a576e0b9[i].mdl_skull_s = level.var_cdbcb282[var_c0032031];
		level.var_a576e0b9[i].mdl_skull_s.var_5cd7e450 = level.var_cdbcb282[var_c0032031].origin;
		level.var_a576e0b9[i].mdl_skull_s.var_d7778aba = level.var_cdbcb282[var_c0032031].angles;
		level.var_a576e0b9[i].mdl_skull_s.var_afb64bf6 = undefined;
		level.var_a576e0b9[i].mdl_skull_s.script_special = i;
		level.var_a576e0b9[i].mdl_skull_s clientfield::set("do_fade_material", 1);
		level.var_a576e0b9[i].mdl_skull_p setmodel(level.var_a576e0b9[i].mdl_skull_s.model);
		level.var_a576e0b9[i].mdl_skull_p.var_f7d3c273 = level.var_a576e0b9[i].mdl_skull_s.var_f7d3c273;
		level.var_a576e0b9[i].mdl_skulltar setmodel(level.var_53df8575[level.var_a576e0b9[i].mdl_skull_s.var_f7d3c273]);
		level.var_a576e0b9[i].s_utrig_pillar = level.var_d76f80e0[var_c0032031];
		level.var_a576e0b9[i].s_utrig_pillar.script_special = i;
		level.var_a576e0b9[i].s_utrig_pillar.script_string = "s_utrig_pillar_" + i;
		function_38f8b6e3(i);
	}
	level flag::init("skullquest_ritual_inprogress1");
	level flag::init("skullquest_ritual_inprogress2");
	level flag::init("skullquest_ritual_inprogress3");
	level flag::init("skullquest_ritual_inprogress4");
	level flag::init("skullquest_ritual_complete1");
	level flag::init("skullquest_ritual_complete2");
	level flag::init("skullquest_ritual_complete3");
	level flag::init("skullquest_ritual_complete4");
	var_93999912 = [];
	var_93999912[1] = getent("reveal_keeper_mural_01", "targetname");
	var_93999912[2] = getent("reveal_keeper_mural_02", "targetname");
	var_93999912[3] = getent("reveal_keeper_mural_03", "targetname");
	foreach(var_d9516038 in var_93999912)
	{
		if(isdefined(var_d9516038))
		{
			var_d9516038 clientfield::set("do_emissive_material", 0);
		}
	}
	var_c9260a5 = array("", "p7_fxanim_zm_island_altar_skull_battle_bundle", "p7_fxanim_zm_island_altar_skull_blood_bundle", "p7_fxanim_zm_island_altar_skull_chaos_bundle", "p7_fxanim_zm_island_altar_skull_doom_bundle");
	foreach(var_e7e46205 in var_c9260a5)
	{
		level thread scene::init(var_c9260a5);
	}
	level.var_4ffafd2 = 0;
	level.var_69fe775a = 0;
}

/*
	Name: function_80794095
	Namespace: zm_island_skullquest
	Checksum: 0x902D01AC
	Offset: 0x2A68
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function function_80794095()
{
	level flag::set("skullquest_ritual_inprogress" + self.script_special);
	self.var_6f46f579 = 1;
	self.mdl_skull_s show();
	self thread function_279e8476("rise");
	var_e9206c7f = 100;
	if(level.var_69fe775a === 0)
	{
		self.n_goal = 350;
	}
	else
	{
		self.n_goal = level.var_69fe775a;
	}
	self.n_progress = 0;
	self.var_cec6c329 = 0;
	self.var_f9d4e953 = 0;
	self.var_2f6a00a = 0;
	zm_spawner::register_zombie_death_event_callback(&function_3aa06eec);
	callback::on_vehicle_killed(&function_5681b8d3);
	self thread function_d15f7b3d();
	self thread function_9098a17a();
	self thread function_ff1550bd();
	level clientfield::set(self.var_ba133ee2, 1);
	self thread function_be54bf9f();
	self thread function_c3360ba8();
}

/*
	Name: function_279e8476
	Namespace: zm_island_skullquest
	Checksum: 0xE51881EB
	Offset: 0x2C38
	Size: 0x164
	Parameters: 1
	Flags: Linked
*/
function function_279e8476(str_state)
{
	switch(str_state)
	{
		case "rise":
		{
			str_anim = "p7_fxanim_zm_island_pedestal_skull_rise_bundle";
			var_affd5bec = self.mdl_skull_s;
			break;
		}
		case "fall":
		{
			str_anim = "p7_fxanim_zm_island_pedestal_skull_fall_bundle";
			var_affd5bec = self.mdl_skull_s;
			break;
		}
	}
	scene::add_scene_func(str_anim, &function_b00b433f, "play", self.script_special);
	self.mdl_skulltar thread scene::play(str_anim);
	if(str_state == "rise")
	{
		wait(1);
	}
	else if(str_state == "fall")
	{
		self.mdl_skulltar waittill(#"scene_done");
		var_affd5bec unlink();
		if(isdefined(self.var_226d2560))
		{
			self.var_226d2560 delete();
		}
	}
	scene::remove_scene_func(str_anim, &function_b00b433f);
}

/*
	Name: function_b00b433f
	Namespace: zm_island_skullquest
	Checksum: 0x173DF114
	Offset: 0x2DA8
	Size: 0xF0
	Parameters: 2
	Flags: Linked
*/
function function_b00b433f(a_ents, var_f2e38849)
{
	var_affd5bec = level.var_a576e0b9[var_f2e38849].mdl_skull_s;
	var_86045b9a = a_ents["pedestal_skull"];
	var_affd5bec.origin = var_86045b9a gettagorigin("skull_link_jnt");
	var_affd5bec.angles = var_86045b9a gettagangles("skull_link_jnt");
	var_affd5bec show();
	var_affd5bec linkto(var_86045b9a, "skull_link_jnt");
	level.var_a576e0b9[var_f2e38849].var_226d2560 = var_86045b9a;
}

/*
	Name: function_e1c1e667
	Namespace: zm_island_skullquest
	Checksum: 0x69CE0BA6
	Offset: 0x2EA0
	Size: 0x1AE
	Parameters: 0
	Flags: None
*/
function function_e1c1e667()
{
	self.var_fcfa044d = 0;
	self._team = "axis";
	if(!isdefined(self.var_94495615))
	{
		self.var_94495615 = spawnstruct();
		self.var_94495615.origin = self.s_skulltar_attractor_src.origin;
		self.var_94495615.angles = self.s_skulltar_attractor_src.angles;
	}
	var_b045a027 = 768;
	n_attractors = 48;
	var_d78038f4 = 5;
	self.var_94495615 zm_utility::create_zombie_point_of_interest(var_b045a027, n_attractors, 10000);
	self.var_94495615.attract_to_origin = 1;
	self.var_94495615 thread zm_utility::create_zombie_point_of_interest_attractor_positions(4, var_d78038f4);
	self.var_94495615 thread zm_utility::wait_for_attractor_positions_complete();
	/#
		self.var_94495615 thread zm_utility::debug_draw_attractor_positions();
	#/
	self thread function_d15f7b3d();
	level flag::wait_till_clear("skullquest_ritual_inprogress" + self.script_special);
	self.var_94495615 notify(#"death");
	self notify(#"skulltar_attractors_off");
}

/*
	Name: function_d15f7b3d
	Namespace: zm_island_skullquest
	Checksum: 0xB08BCC04
	Offset: 0x3058
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function function_d15f7b3d()
{
	self endon(#"skulltar_attractors_off");
	level endon("skullquest_ritual_ended" + self.script_special);
	while(true)
	{
		a_enemy_ai = self.var_41335b73;
		if(isdefined(a_enemy_ai))
		{
			foreach(ai in a_enemy_ai)
			{
				if(isalive(ai) && (!(isdefined(ai.aat_turned) && ai.aat_turned)) && distancesquared(ai.origin, self.s_skulltar_skull_pos.origin) <= 4200)
				{
					self thread function_afdb341(ai);
				}
			}
		}
		wait(1);
	}
}

/*
	Name: function_afdb341
	Namespace: zm_island_skullquest
	Checksum: 0xC3663C3C
	Offset: 0x31B8
	Size: 0x2D4
	Parameters: 1
	Flags: Linked
*/
function function_afdb341(ai)
{
	self endon("skulltar_attractors_off" + self.script_special);
	level endon("skullquest_ritual_ended" + self.script_special);
	ai endon(#"hash_87952665");
	ai endon(#"death");
	if(isdefined(ai.var_6a7c27af) && ai.var_6a7c27af)
	{
		return;
	}
	ai ai::set_ignoreall(1);
	switch(ai.archetype)
	{
		case "zombie":
		{
			var_872d00dd = "ai_zombie_base_ad_attack_v1";
			ai lookatentity(self.mdl_skull_s);
			n_damage = -15;
			break;
		}
		case "thrasher":
		{
			var_872d00dd = "ai_zm_dlc2_thrasher_attack_swing_swipe";
			ai lookatentity(self.mdl_skull_s);
			n_damage = -15;
			break;
		}
		case "spider":
		{
			var_872d00dd = "ai_zm_dlc2_spider_attack_melee";
			n_damage = -15;
			break;
		}
	}
	var_430b638 = getanimlength(var_872d00dd);
	self thread function_2a2ce01f(ai);
	ai notify(#"hash_aedf5455");
	while(level flag::get("skullquest_ritual_inprogress" + self.script_special) && isalive(ai) && (!(isdefined(ai.var_3f6ea790) && ai.var_3f6ea790)))
	{
		self thread function_f20126b2();
		if(!(isdefined(ai.var_3f6ea790) && ai.var_3f6ea790))
		{
			ai animscripted("melee", ai.origin, ai.angles, var_872d00dd, "normal", undefined, undefined, 0.5, 0.5);
			self.mdl_skull_s playsound("zmb_skull_ritual_hit");
			wait(var_430b638 + 1);
		}
	}
}

/*
	Name: function_2a2ce01f
	Namespace: zm_island_skullquest
	Checksum: 0x83E26191
	Offset: 0x3498
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_2a2ce01f(ai)
{
	self.var_cec6c329++;
	ai.var_6a7c27af = 1;
	ai waittill(#"death");
	if(isdefined(ai.var_6a7c27af) && ai.var_6a7c27af)
	{
		self.var_cec6c329--;
	}
}

/*
	Name: function_9098a17a
	Namespace: zm_island_skullquest
	Checksum: 0x3B68FD21
	Offset: 0x3508
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function function_9098a17a(var_c198423 = 1)
{
	self endon("skullquest_ritual_abandoned" + self.script_special);
	level endon("skullquest_ritual_ended" + self.script_special);
	while(self.n_progress < self.n_goal && self.n_progress >= 0 && self.var_2f6a00a < 10)
	{
		self thread function_194dd3fe();
		if(self function_44181b60() && self.n_progress >= 0)
		{
			self thread function_3654cf4c(10);
			self.var_f9d4e953 = 0;
		}
		else
		{
			self.var_f9d4e953++;
			if(self.var_f9d4e953 >= 5)
			{
				break;
			}
		}
		wait(var_c198423);
	}
	self thread function_186d9bd6();
}

/*
	Name: function_194dd3fe
	Namespace: zm_island_skullquest
	Checksum: 0xF3AE7F68
	Offset: 0x3630
	Size: 0xB8
	Parameters: 2
	Flags: Linked
*/
function function_194dd3fe(var_9f8b46b0 = 2, var_d03250e = 0.25)
{
	var_fc1e97a0 = self.n_progress / (self.n_goal * 0.75);
	var_f3370df8 = var_9f8b46b0 - var_d03250e;
	if(var_fc1e97a0 < 0.75)
	{
		self.var_9543b4d3 = var_9f8b46b0 - (var_fc1e97a0 * var_f3370df8);
	}
	else
	{
		self.var_9543b4d3 = var_d03250e;
	}
}

/*
	Name: function_be54bf9f
	Namespace: zm_island_skullquest
	Checksum: 0x718CAADE
	Offset: 0x36F0
	Size: 0x130
	Parameters: 0
	Flags: Linked
*/
function function_be54bf9f()
{
	var_8e94b38a = self.var_2f6a00a / 10;
	if(var_8e94b38a > 1)
	{
		var_8e94b38a = 1;
	}
	if(var_8e94b38a < 0.25)
	{
		var_ced215df = 1;
	}
	else
	{
		if(var_8e94b38a >= 0.25 && var_8e94b38a < 0.5)
		{
			var_ced215df = 2;
		}
		else
		{
			if(var_8e94b38a >= 0.5 && var_8e94b38a < 0.75)
			{
				var_ced215df = 3;
			}
			else if(var_8e94b38a >= 0.75)
			{
				var_ced215df = 4;
			}
		}
	}
	level clientfield::set(self.var_ba133ee2, var_ced215df);
	if(self.var_ced215df !== var_ced215df)
	{
		self.mdl_skull_s thread function_85a2a491();
		self.var_ced215df = var_ced215df;
	}
}

/*
	Name: function_85a2a491
	Namespace: zm_island_skullquest
	Checksum: 0x5C23471A
	Offset: 0x3828
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_85a2a491()
{
	mdl_temp = util::spawn_model("tag_origin", self.origin, self.angles);
	mdl_temp clientfield::set("skullquest_finish_start_fx", 1);
	wait(0.5);
	mdl_temp clientfield::set("skullquest_finish_start_fx", 0);
	mdl_temp delete();
}

/*
	Name: function_c3360ba8
	Namespace: zm_island_skullquest
	Checksum: 0xE3E32D8C
	Offset: 0x38D0
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function function_c3360ba8(n_step_time = 0.1)
{
	self endon(#"hash_52ad0df5");
	var_da791f1d = 30 / n_step_time;
	n_steps = 0;
	while(true)
	{
		var_a747f278 = n_steps / var_da791f1d;
		var_9bcf211d = 1 - var_a747f278;
		self.mdl_skull_s clientfield::set("do_fade_material_direct", var_9bcf211d);
		self.mdl_skulltar clientfield::set("do_emissive_material_direct", var_a747f278);
		wait(n_step_time);
		n_steps++;
	}
}

/*
	Name: function_186d9bd6
	Namespace: zm_island_skullquest
	Checksum: 0x25711656
	Offset: 0x39D0
	Size: 0x2C8
	Parameters: 0
	Flags: Linked
*/
function function_186d9bd6()
{
	zm_spawner::deregister_zombie_death_event_callback(&function_3aa06eec);
	callback::remove_on_vehicle_killed(&function_5681b8d3);
	self notify(#"hash_52ad0df5");
	level flag::clear("skullquest_ritual_inprogress" + self.script_special);
	level notify("skullquest_ritual_ended" + self.script_special);
	self.mdl_skulltar thread scene::stop("p7_fxanim_zm_island_pedestal_skull_rise_bundle");
	self.mdl_skull_s unlink();
	foreach(s_skulltar_attack_pos in self.var_ed98dfad)
	{
		s_skulltar_attack_pos.var_b1c2844f = undefined;
	}
	if(self.n_progress >= self.n_goal)
	{
		self thread function_2b848418();
		b_success = 1;
	}
	else
	{
		if(self.var_f9d4e953 >= 5 && self.n_progress >= 0)
		{
			self thread function_743b2f2f(0);
			b_success = 0;
		}
		else
		{
			self thread function_743b2f2f(1);
			b_success = 0;
		}
	}
	a_ai_enemies = getaiteamarray("axis");
	if(a_ai_enemies.size > 0)
	{
		for(i = 0; i < a_ai_enemies.size; i++)
		{
			if(isalive(a_ai_enemies[i]) && a_ai_enemies[i].var_ecc789a5 === self.script_special)
			{
				a_ai_enemies[i] thread function_c7a0c111(b_success);
			}
		}
	}
	level.zombie_ai_limit = level.zombie_ai_limit + self.var_eca4fee1;
}

/*
	Name: function_c7a0c111
	Namespace: zm_island_skullquest
	Checksum: 0x1A943C6B
	Offset: 0x3CA0
	Size: 0x2AC
	Parameters: 2
	Flags: Linked
*/
function function_c7a0c111(b_success = 1, var_bf49654c = 1)
{
	self endon(#"death");
	self notify(#"hash_eb13d3a5");
	if(!(isdefined(self.var_3f6ea790) && self.var_3f6ea790))
	{
		self setgoal(self.origin);
		if(isdefined(var_bf49654c) && var_bf49654c)
		{
			wait(randomfloatrange(0.05, 0.25));
		}
		if(isdefined(b_success) && b_success)
		{
			if(self.archetype === "zombie")
			{
				self thread zombie_utility::zombie_eye_glow_stop();
				self clientfield::set("death_ray_shock_eye_fx", 1);
				self thread scene::play("cin_zm_dlc1_zombie_dth_deathray_04", self);
				wait(0.75);
				self clientfield::set("death_ray_shock_eye_fx", 0);
				self zombie_utility::zombie_head_gib(self);
			}
			if(self.archetype !== "spider")
			{
				util::wait_network_frame();
				self thread zombie_utility::zombie_gut_explosion();
			}
			if(isdefined(level.bzm_worldpaused) && level.bzm_worldpaused && self.archetype === "spider")
			{
				var_601391ec = zm_island_util::function_4bf4ac40(self.origin);
				self dodamage(self.health, self.origin, var_601391ec);
				self thread fx::play("spider_gib", self.origin, self.angles, undefined, 0, undefined, 1, 1);
				self ghost();
			}
		}
		self dodamage(self.health * 2, self.origin);
	}
}

/*
	Name: function_44181b60
	Namespace: zm_island_skullquest
	Checksum: 0x31C86B49
	Offset: 0x3F58
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function function_44181b60()
{
	var_6c71c640 = 0;
	foreach(zone in self.var_aa15c945)
	{
		var_6c71c640 = var_6c71c640 || zm_zonemgr::any_player_in_zone(zone);
	}
	return var_6c71c640;
}

/*
	Name: function_3654cf4c
	Namespace: zm_island_skullquest
	Checksum: 0x5B1FCD32
	Offset: 0x4010
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function function_3654cf4c(n_amount = 10, var_f8ad0afc)
{
	if(isdefined(var_f8ad0afc))
	{
		var_964af2de = var_f8ad0afc + vectorscale((0, 0, 1), 32);
		v_dest = self.mdl_skulltar.origin + vectorscale((0, 0, 1), 16);
		function_a050863e(var_964af2de, v_dest);
	}
	self.n_progress = self.n_progress + n_amount;
	if(self.n_progress > self.n_goal)
	{
		self.n_progress = self.n_goal;
	}
}

/*
	Name: function_82fc8508
	Namespace: zm_island_skullquest
	Checksum: 0x417D0AC
	Offset: 0x40F0
	Size: 0x64
	Parameters: 1
	Flags: None
*/
function function_82fc8508(var_40e67963)
{
	if(!isdefined(var_40e67963))
	{
		var_40e67963 = -1 * (self.n_progress / 4);
		if(var_40e67963 <= 10)
		{
			var_40e67963 = -100;
		}
	}
	self thread function_3654cf4c(var_40e67963);
}

/*
	Name: function_f20126b2
	Namespace: zm_island_skullquest
	Checksum: 0xFE1BCFBF
	Offset: 0x4160
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_f20126b2()
{
	self.var_2f6a00a++;
	self thread function_be54bf9f();
	if(self.var_2f6a00a >= 10)
	{
		self thread function_186d9bd6();
	}
}

/*
	Name: function_a050863e
	Namespace: zm_island_skullquest
	Checksum: 0x1156EC7C
	Offset: 0x41B8
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function function_a050863e(var_964af2de, v_dest)
{
	if(isdefined(var_964af2de) && isdefined(v_dest))
	{
		var_b6f3d7c3 = spawn("script_model", var_964af2de);
		var_b6f3d7c3 setmodel("p7_sky_vista_light_flare_blue");
		var_b6f3d7c3 playsound("zmb_skull_soul_feed");
		var_b6f3d7c3 moveto(v_dest, 0.5);
		var_b6f3d7c3 waittill(#"movedone");
		var_b6f3d7c3 delete();
	}
}

/*
	Name: function_2b848418
	Namespace: zm_island_skullquest
	Checksum: 0xF807A937
	Offset: 0x4298
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function function_2b848418()
{
	level clientfield::set(self.var_ba133ee2, 5);
	self.mdl_skulltar clientfield::set("do_emissive_material", 1);
	level notify("skullquest_ritual_complete" + self.script_special);
	level flag::set("skullquest_ritual_complete" + self.script_special);
	self.var_6f46f579 = 0;
	level.var_3846d9a8++;
	foreach(player in level.activeplayers)
	{
		if(zombie_utility::is_player_valid(player))
		{
			player zm_score::add_to_player_score(500);
		}
	}
	self function_279e8476("fall");
	function_fae0aa01(self.script_special, "postritual");
}

/*
	Name: function_743b2f2f
	Namespace: zm_island_skullquest
	Checksum: 0x92E9751
	Offset: 0x4428
	Size: 0x204
	Parameters: 1
	Flags: Linked
*/
function function_743b2f2f(var_6763afa8)
{
	str_notify = "skullquest_ritual_failed_" + self.script_special;
	level notify(str_notify);
	self.mdl_skull_s clientfield::set("do_fade_material", 1);
	self.mdl_skulltar clientfield::set("do_emissive_material", 0);
	level clientfield::set(self.var_ba133ee2, 6);
	var_930b9449 = spawn("script_origin", self.origin);
	var_930b9449 playsound("zmb_skull_ritual_fail");
	if(isdefined(self.var_226d2560))
	{
		self.var_226d2560 delete();
	}
	self thread function_7fe36843();
	var_70181bbb = -1.1 * abs(self.n_progress);
	self thread function_3654cf4c(var_70181bbb);
	self.var_6f46f579 = 0;
	wait(0.1);
	switch(var_6763afa8)
	{
		case 0:
		{
			self notify("skullquest_ritual_abandoned" + self.script_special);
			break;
		}
		case 1:
		{
			break;
		}
	}
	wait(2);
	var_930b9449 delete();
	level thread function_fae0aa01(self.script_special, "pre_retry");
}

/*
	Name: function_7fe36843
	Namespace: zm_island_skullquest
	Checksum: 0x4D8051FF
	Offset: 0x4638
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function function_7fe36843(var_a9df1394 = 1)
{
	self.mdl_skulltar scene::stop("p7_fxanim_zm_island_pedestal_skull_rise_bundle");
	self.mdl_skull_s unlink();
	self.mdl_skull_s ghost();
	mdl_temp = util::spawn_model("tag_origin", self.origin, self.angles);
	mdl_temp clientfield::set("skullquest_finish_start_fx", 1);
	wait(var_a9df1394);
	mdl_temp clientfield::set("skullquest_finish_start_fx", 0);
	mdl_temp delete();
}

/*
	Name: function_ff1550bd
	Namespace: zm_island_skullquest
	Checksum: 0x7D0FFF92
	Offset: 0x4750
	Size: 0xBDC
	Parameters: 0
	Flags: Linked
*/
function function_ff1550bd()
{
	self endon("skullquest_ritual_abandoned" + self.script_special);
	level endon("skullquest_ritual_ended" + self.script_special);
	var_f2e38849 = self.script_special;
	self.var_bd61ef5b = 0;
	self.var_d38f69da = [];
	self.var_41335b73 = [];
	var_19b19369 = ("skull" + var_f2e38849) + "_attacker";
	a_spawners = [];
	var_89f44116 = level.zombie_spawners;
	var_64cc2fa5 = level.var_feebf312;
	var_6469b451 = level.var_c38a4fee;
	if(level.var_4ffafd2 > 0)
	{
		var_90d3df61 = level.var_4ffafd2;
	}
	else
	{
		var_90d3df61 = 0;
		for(i = 1; i <= 4; i++)
		{
			if(level flag::get("skullquest_ritual_complete" + i) || level flag::get("skullquest_ritual_inprogress" + i))
			{
				var_90d3df61++;
			}
		}
	}
	var_63ba0b02 = 0;
	switch(var_90d3df61)
	{
		case 1:
		{
			a_spawners = var_89f44116;
			var_63ba0b02 = 1;
			var_8f4e08a8 = array(0, 3, 4, 5, 6);
			var_419b220b = array(0, 3, 4, 5, 6);
			self.var_9543b4d3 = 2;
			self.var_7905a128 = 0;
			break;
		}
		case 2:
		{
			a_spawners = array(var_6469b451[0], var_6469b451[0], var_6469b451[0], var_6469b451[0]);
			var_8f4e08a8 = array(0, 6, 7, 8, 9);
			var_419b220b = array(0, 4, 5, 6, 7);
			self.var_9543b4d3 = 2;
			self.var_7905a128 = 0;
			break;
		}
		case 3:
		{
			a_spawners = array(var_64cc2fa5[0], var_64cc2fa5[0], var_64cc2fa5[0], var_64cc2fa5[0]);
			var_8f4e08a8 = array(0, 6, 7, 8, 9);
			var_419b220b = array(0, 4, 5, 6, 7);
			self.var_9543b4d3 = 2;
			self.var_7905a128 = 1;
			break;
		}
		case 4:
		{
			a_spawners = array(var_6469b451[0], var_6469b451[0], var_6469b451[0], var_64cc2fa5[0]);
			var_8f4e08a8 = array(0, 6, 7, 8, 9);
			var_419b220b = array(0, 4, 5, 6, 7);
			self.var_9543b4d3 = 2;
			self.var_7905a128 = 0;
			break;
		}
	}
	var_eca4fee1 = var_8f4e08a8[level.activeplayers.size];
	var_3be27b2b = var_419b220b[level.activeplayers.size];
	self.var_eca4fee1 = var_eca4fee1;
	level.zombie_ai_limit = level.zombie_ai_limit - self.var_eca4fee1;
	var_d94cc36a = array(0, 1, 1, 1, 1);
	var_44da5f74 = var_d94cc36a[level.activeplayers.size];
	self.a_s_spawnpts = array::randomize(self.a_s_spawnpts);
	self.var_d8cdf3a = 1;
	while(!level flag::get("skullquest_ritual_complete" + self.script_special))
	{
		for(i = 0; i < self.a_s_spawnpts.size; i++)
		{
			level.var_a576e0b9[var_f2e38849].var_41335b73 = array::remove_undefined(level.var_a576e0b9[var_f2e38849].var_41335b73);
			level.var_a576e0b9[var_f2e38849].var_d38f69da = array::remove_undefined(level.var_a576e0b9[var_f2e38849].var_d38f69da);
			while(getfreeactorcount() < 1)
			{
				wait(0.05);
			}
			while(level.var_a576e0b9[var_f2e38849].var_d38f69da.size >= var_eca4fee1)
			{
				wait(0.05);
			}
			if(isdefined(self.var_7905a128 == 1) && self.var_7905a128 == 1 && self.var_bd61ef5b == 0)
			{
				e_spawner = var_64cc2fa5[0];
			}
			else
			{
				if(isdefined(self.var_d8cdf3a) && self.var_d8cdf3a || level.var_a576e0b9[var_f2e38849].var_41335b73.size < 2)
				{
					e_spawner = var_89f44116[0];
				}
				else
				{
					e_spawner = array::random(a_spawners);
				}
			}
			self.var_d8cdf3a = !self.var_d8cdf3a;
			ai_attacker = undefined;
			self.a_s_spawnpts[i].script_string = "";
			if(isdefined(e_spawner) && isdefined(e_spawner.script_noteworthy))
			{
				switch(e_spawner.script_noteworthy)
				{
					case "zombie_spawner":
					{
						if(level.var_a576e0b9[var_f2e38849].var_41335b73.size < var_3be27b2b)
						{
							self.a_s_spawnpts[i].script_string = "find_flesh";
							self.a_s_spawnpts[i].script_noteworthy = "spawn_location";
							ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369, self.a_s_spawnpts[i]);
							/#
								if(isdefined(level.var_32d5991a) && level.var_32d5991a)
								{
									iprintlnbold((("" + i) + "") + self.a_s_spawnpts[i].origin);
								}
							#/
						}
						break;
					}
					case "zombie_thrasher_spawner":
					{
						if(level.var_a576e0b9[var_f2e38849].var_bd61ef5b < var_44da5f74)
						{
							self.a_s_spawnpts[i].script_noteworthy = "thrasher_location";
							ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369);
						}
						break;
					}
					case "zombie_spider_spawner":
					{
						self.a_s_spawnpts[i].script_noteworthy = "spider_location";
						ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369, self.a_s_spawnpts[i]);
						break;
					}
				}
				wait(0.1);
			}
			if(isalive(ai_attacker))
			{
				ai_attacker.var_ecc789a5 = var_f2e38849;
				array::add(level.var_a576e0b9[var_f2e38849].var_d38f69da, ai_attacker);
				ai_attacker.ignore_enemy_count = 1;
				ai_attacker.no_damage_points = 1;
				ai_attacker.deathpoints_already_given = 1;
				switch(e_spawner.script_noteworthy)
				{
					case "zombie_spawner":
					{
						ai_attacker forceteleport(self.a_s_spawnpts[i].origin, self.a_s_spawnpts[i].angles);
						if(ai_attacker.health > 1263)
						{
							ai_attacker.maxhealth = 1263;
							ai_attacker.health = 1263;
						}
						ai_attacker thread function_bd5d2a96(self);
						break;
					}
					case "zombie_thrasher_spawner":
					{
						ai_attacker zm_ai_thrasher::function_89976d94(self.a_s_spawnpts[i].origin);
						self.var_bd61ef5b++;
						ai_attacker clientfield::set("ritual_attacker_fx", 1);
						ai_attacker.var_75729ddd = 1;
						break;
					}
					case "zombie_spider_spawner":
					{
						ai_attacker.favoriteenemy = zm_ai_spiders::get_favorite_enemy();
						self.a_s_spawnpts[i] thread zm_ai_spiders::function_49e57a3b(ai_attacker, self.a_s_spawnpts[i]);
						break;
					}
				}
				ai_attacker thread function_c46730e7(self.script_special);
				ai_attacker thread zm_island_util::function_acd04dc9();
				wait(self.var_9543b4d3);
			}
			level.zombie_ai_limit = level.zombie_ai_limit + self.var_eca4fee1;
			var_eca4fee1 = var_8f4e08a8[level.activeplayers.size];
			self.var_eca4fee1 = var_eca4fee1;
			level.zombie_ai_limit = level.zombie_ai_limit - self.var_eca4fee1;
		}
		wait(self.var_9543b4d3);
	}
}

/*
	Name: function_c46730e7
	Namespace: zm_island_skullquest
	Checksum: 0x8EB8C0E0
	Offset: 0x5338
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function function_c46730e7(var_f2e38849)
{
	self endon(#"death");
	wait(5);
	if(!self function_b948e12a(var_f2e38849))
	{
		/#
			if(isdefined(level.var_32d5991a) && level.var_32d5991a)
			{
				iprintlnbold(("" + self.origin) + "");
			}
		#/
		arrayremovevalue(level.var_a576e0b9[var_f2e38849].var_d38f69da, self);
		arrayremovevalue(level.var_a576e0b9[var_f2e38849].var_41335b73, self);
		util::stop_magic_bullet_shield(self);
		if(isalive(self))
		{
			self kill();
		}
	}
}

/*
	Name: function_b948e12a
	Namespace: zm_island_skullquest
	Checksum: 0xB38E778C
	Offset: 0x5458
	Size: 0xC2
	Parameters: 1
	Flags: Linked
*/
function function_b948e12a(var_f2e38849)
{
	b_in_zone = 0;
	foreach(zone in level.var_a576e0b9[var_f2e38849].var_aa15c945)
	{
		b_in_zone = b_in_zone || self zm_zonemgr::entity_in_zone(zone);
	}
	return b_in_zone;
}

/*
	Name: function_bd5d2a96
	Namespace: zm_island_skullquest
	Checksum: 0x8401F053
	Offset: 0x5528
	Size: 0x1E4
	Parameters: 1
	Flags: Linked
*/
function function_bd5d2a96(var_4126c532)
{
	self endon(#"death");
	if(isalive(self))
	{
		self disableaimassist();
		array::add(var_4126c532.var_41335b73, self);
		self.var_8853cc2a = 1;
		self.nocrawler = 1;
		self ghost();
		self clientfield::set("ritual_attacker_fx", 1);
		self.var_75729ddd = 1;
		self setgoal(self.origin);
		var_197f1988 = util::spawn_model("tag_origin", self.origin, self.angles);
		var_197f1988 thread scene::play("scene_zm_dlc2_zombie_quick_rise_v2", self);
		self playsound("zmb_skull_ritual_portal_zombie");
		wait(0.05);
		if(isalive(self))
		{
			self show();
			var_197f1988 waittill(#"scene_done");
			self thread function_1cbe53ee(var_4126c532);
			self enableaimassist();
		}
		if(isdefined(var_197f1988))
		{
			var_197f1988 delete();
		}
	}
}

/*
	Name: function_1c624caf
	Namespace: zm_island_skullquest
	Checksum: 0xFDDF7360
	Offset: 0x5718
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function function_1c624caf(a_ents, e_align)
{
	self zm_utility::self_delete();
}

/*
	Name: function_1cbe53ee
	Namespace: zm_island_skullquest
	Checksum: 0xE66502AB
	Offset: 0x5750
	Size: 0x2AA
	Parameters: 1
	Flags: Linked
*/
function function_1cbe53ee(var_5e9499e0)
{
	self endon(#"death");
	self endon(#"hash_aedf5455");
	self endon(#"hash_eb13d3a5");
	self zombie_utility::set_zombie_run_cycle("walk");
	self notify(#"stop_find_flesh");
	self notify(#"zombie_acquire_enemy");
	self ai::set_ignoreall(1);
	while(distance(self.origin, var_5e9499e0.s_skulltar_skull_pos.origin) > 32 && (!(isdefined(self.aat_turned) && self.aat_turned)))
	{
		var_b6bec422 = undefined;
		var_4800ca35 = arraycopy(var_5e9499e0.var_ed98dfad);
		var_8432e700 = arraygetclosest(self.origin, var_4800ca35);
		while(!isdefined(var_b6bec422) && var_4800ca35.size > 0)
		{
			arrayremovevalue(var_4800ca35, var_8432e700);
			if(!isdefined(var_8432e700.var_b1c2844f) || var_8432e700.var_b1c2844f === self)
			{
				var_b6bec422 = getclosestpointonnavmesh(var_8432e700.origin, 32);
			}
			if(!isdefined(var_b6bec422))
			{
				var_8432e700 = array::random(var_4800ca35);
			}
		}
		if(!isdefined(var_b6bec422))
		{
			var_b6bec422 = getclosestpointonnavmesh(var_5e9499e0.s_skulltar_base_pos.origin, 48);
			var_8432e700 = undefined;
		}
		self setgoal(var_b6bec422, 1);
		if(isdefined(var_8432e700))
		{
			self.s_goal = var_8432e700;
			self.s_goal.var_b1c2844f = self;
		}
		self lookatentity(var_5e9499e0.mdl_skull_s);
		self waittill(#"goal");
		wait(1);
	}
}

/*
	Name: function_5681b8d3
	Namespace: zm_island_skullquest
	Checksum: 0x813EBD99
	Offset: 0x5A08
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_5681b8d3(params)
{
	self thread function_3aa06eec(params.eattacker);
}

/*
	Name: function_3aa06eec
	Namespace: zm_island_skullquest
	Checksum: 0xB6BA1A6A
	Offset: 0x5A40
	Size: 0x14A
	Parameters: 1
	Flags: Linked
*/
function function_3aa06eec(e_attacker)
{
	if(isdefined(self) && isdefined(self.var_ecc789a5) && isinarray(level.var_a576e0b9[self.var_ecc789a5].var_d38f69da, self))
	{
		arrayremovevalue(level.var_a576e0b9[self.var_ecc789a5].var_d38f69da, self);
		if(self.script_noteworthy === "zombie_thrasher_spawner")
		{
			level.var_a576e0b9[self.var_ecc789a5].var_bd61ef5b--;
		}
		if(isdefined(self.var_75729ddd))
		{
			self clientfield::set("keeper_fx", 0);
		}
		if(isdefined(self.var_8853cc2a) && self.var_8853cc2a)
		{
			arrayremovevalue(level.var_a576e0b9[self.var_ecc789a5].var_41335b73, self);
			if(isdefined(self.s_goal) && isdefined(self.s_goal.var_b1c2844f))
			{
				self.s_goal.var_b1c2844f = undefined;
			}
		}
	}
}

/*
	Name: function_25b82d3f
	Namespace: zm_island_skullquest
	Checksum: 0xD7905BF2
	Offset: 0x5B98
	Size: 0x170
	Parameters: 0
	Flags: None
*/
function function_25b82d3f()
{
	self waittill(#"death");
	if(isdefined(self) && isdefined(self.var_ecc789a5) && isinarray(level.var_a576e0b9[self.var_ecc789a5].var_d38f69da, self))
	{
		arrayremovevalue(level.var_a576e0b9[self.var_ecc789a5].var_d38f69da, self);
		if(self.script_noteworthy === "zombie_thrasher_spawner")
		{
			level.var_a576e0b9[self.var_ecc789a5].var_bd61ef5b--;
		}
		if(isdefined(self.var_75729ddd))
		{
			self clientfield::set("keeper_fx", 0);
		}
		if(isdefined(self.var_8853cc2a) && self.var_8853cc2a)
		{
			arrayremovevalue(level.var_a576e0b9[self.var_ecc789a5].var_41335b73, self);
			level.var_a576e0b9[self.var_ecc789a5].var_41335b73 = array::remove_dead(level.var_a576e0b9[self.var_ecc789a5].var_41335b73);
		}
	}
}

/*
	Name: function_f94079c3
	Namespace: zm_island_skullquest
	Checksum: 0x87AA30FF
	Offset: 0x5D10
	Size: 0xAC
	Parameters: 1
	Flags: None
*/
function function_f94079c3(var_84c62227)
{
	switch(self.archetype)
	{
		case "zombie":
		{
			n_value = 50;
			break;
		}
		case "thrasher":
		{
			n_value = 70;
			break;
		}
		case "spider":
		{
			n_value = 50;
			break;
		}
		default:
		{
			n_value = 50;
			break;
		}
	}
	level.var_a576e0b9[var_84c62227] thread function_3654cf4c(n_value, self.origin);
}

/*
	Name: function_3fe31e5b
	Namespace: zm_island_skullquest
	Checksum: 0xEF808FB
	Offset: 0x5DC8
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function function_3fe31e5b(var_f2e38849, var_9fe01ec5 = 0)
{
	var_f8a0e213 = level.var_a576e0b9[var_f2e38849].mdl_skull_s.var_afb64bf6;
	if(zombie_utility::is_player_valid(var_f8a0e213))
	{
		var_f8a0e213.var_d64275e8 = 0;
	}
	level.var_a576e0b9[var_f2e38849].mdl_skull_s.var_afb64bf6 = undefined;
	function_880d3333(var_f2e38849);
	function_fae0aa01(var_f2e38849, "start");
}

/*
	Name: function_eba0c996
	Namespace: zm_island_skullquest
	Checksum: 0x3251651A
	Offset: 0x5EA8
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function function_eba0c996(var_f2e38849)
{
	var_f8a0e213 = level.var_a576e0b9[var_f2e38849].mdl_skull_p.var_afb64bf6;
	if(isdefined(var_f8a0e213))
	{
		var_f8a0e213.var_4849e523 = 0;
	}
	level.var_a576e0b9[var_f2e38849].mdl_skull_p.var_afb64bf6 = undefined;
	function_fae0aa01(var_f2e38849, "postritual");
}

/*
	Name: function_fdafeea2
	Namespace: zm_island_skullquest
	Checksum: 0x4D2BFAA7
	Offset: 0x5F40
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function function_fdafeea2(var_48d11f40)
{
	if(!(isdefined(level.var_d19220ee) && level.var_d19220ee))
	{
		level.var_d19220ee = 1;
		level.var_9964c1b2 = struct::get("s_ut_skullroom", "targetname");
		level thread function_f20b6331();
		function_97106262();
		if(zm_utility::is_player_valid(var_48d11f40))
		{
			var_48d11f40 thread zm_island_vo::function_5dbba1d3();
		}
	}
}

/*
	Name: function_f20b6331
	Namespace: zm_island_skullquest
	Checksum: 0x10DE97B6
	Offset: 0x6000
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function function_f20b6331()
{
	level thread exploder::exploder("fxexp_500");
	level thread scene::play("p7_fxanim_zm_island_alter_stairs_bundle");
	if(isdefined(level.var_e534ade))
	{
		foreach(e_piece in level.var_e534ade)
		{
			e_piece delete();
		}
	}
	function_e20f6c97(0);
	level flag::set("connect_ruins_to_ruins_underground");
}

/*
	Name: function_9839b367
	Namespace: zm_island_skullquest
	Checksum: 0xF02885A4
	Offset: 0x6118
	Size: 0x6C
	Parameters: 0
	Flags: None
*/
function function_9839b367()
{
	level.var_9046e7b0 playsound("zmb_skull_door_close");
	level.var_9046e7b0 moveto(level.var_9046e7b0.var_9c93e17, 3);
	exploder::exploder("fxexp_501");
}

/*
	Name: function_e20f6c97
	Namespace: zm_island_skullquest
	Checksum: 0x72FAE60C
	Offset: 0x6190
	Size: 0x140
	Parameters: 1
	Flags: Linked
*/
function function_e20f6c97(b_on = 1)
{
	mdl_skullroom_seal = getent("mdl_skullroom_seal", "targetname");
	if(isdefined(b_on) && b_on)
	{
		mdl_skullroom_seal show();
		mdl_skullroom_seal solid();
		exploder::exploder("fxexp_501");
		mdl_skullroom_seal disconnectpaths();
		level.var_a5db31a9 = 1;
	}
	else
	{
		mdl_skullroom_seal ghost();
		mdl_skullroom_seal notsolid();
		exploder::stop_exploder("fxexp_501");
		mdl_skullroom_seal connectpaths();
		level.var_a5db31a9 = 0;
	}
}

/*
	Name: function_97106262
	Namespace: zm_island_skullquest
	Checksum: 0x8E99EA98
	Offset: 0x62D8
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_97106262()
{
	if(!level flag::exists("skullroom_defend_inprogress"))
	{
		level flag::init("skullroom_defend_inprogress");
	}
	if(isdefined(level.var_55c48492))
	{
		level.var_55c48492 show();
	}
	if(isdefined(level.var_b2152df5))
	{
		level.var_b2152df5 setup_unitrigger("unitrigger_radius_use", &function_d3554921, &function_c8ef1118);
	}
}

/*
	Name: function_d3554921
	Namespace: zm_island_skullquest
	Checksum: 0xBC8D23F8
	Offset: 0x63A0
	Size: 0xE8
	Parameters: 1
	Flags: Linked
*/
function function_d3554921(player)
{
	if(isdefined(level.var_b10ab148) && level.var_b10ab148 && player bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		self sethintstring("");
		return false;
	}
	if(level flag::get("skullroom_defend_inprogress") || player hasweapon(level.var_c003f5b, 1))
	{
		self sethintstring("");
		return false;
	}
	self sethintstring(&"ZM_ISLAND_SKULLQUEST_GET_SKULLGUN");
	return true;
}

/*
	Name: function_c8ef1118
	Namespace: zm_island_skullquest
	Checksum: 0x8548EB4B
	Offset: 0x6498
	Size: 0x17E
	Parameters: 0
	Flags: Linked
*/
function function_c8ef1118()
{
	while(true)
	{
		self waittill(#"trigger", ent);
		if(ent function_9e2f0e52() && !level flag::get("skullroom_defend_inprogress"))
		{
			if(isdefined(level.var_b10ab148) && level.var_b10ab148 && !ent hasweapon(level.var_c003f5b, 1))
			{
				ent thread function_458f50f2();
				if(!(isdefined(level.var_e2f72654) && level.var_e2f72654))
				{
					level.var_e2f72654 = 1;
					ent thread zm_island_vo::function_b2a7853b();
				}
			}
			else if(!ent hasweapon(level.var_c003f5b, 1))
			{
				level thread function_b10feb68();
				self playsound("zmb_skulltar_place");
				if(!(isdefined(level.var_d299e345) && level.var_d299e345))
				{
					ent thread zm_island_vo::function_ab027b72();
				}
			}
		}
		wait(1);
	}
}

/*
	Name: function_b10feb68
	Namespace: zm_island_skullquest
	Checksum: 0x8CD34D94
	Offset: 0x6620
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_b10feb68()
{
	if(!level flag::get("skullroom_defend_inprogress"))
	{
		level flag::set("skullroom_defend_inprogress");
		level.var_55c48492 playloopsound("mus_island_skullbattle", 2);
		level thread function_e20f6c97(1);
		level thread function_ef5b1df5();
		level flag::wait_till_clear("skullroom_defend_inprogress");
		level.var_55c48492 stoploopsound(2);
		if(isdefined(level.var_b10ab148) && level.var_b10ab148)
		{
			level util::waittill_any_timeout(10, "a_player_got_skullgun");
		}
		level thread function_e20f6c97(0);
		exploder::exploder("fxexp_502");
	}
}

/*
	Name: function_ef5b1df5
	Namespace: zm_island_skullquest
	Checksum: 0x18769216
	Offset: 0x6778
	Size: 0x778
	Parameters: 0
	Flags: Linked
*/
function function_ef5b1df5()
{
	var_8ac892bf = array(0, 3, 5, 7, 8);
	var_59d27c2f = array(0, 20, 29, 38, 47);
	level.var_d15b7db3 = var_8ac892bf[level.players.size];
	level.var_49c6fb1c = var_59d27c2f[level.players.size];
	level.zombie_ai_limit = level.zombie_ai_limit - level.var_d15b7db3;
	level flag::clear("spawn_zombies");
	level.disable_nuke_delay_spawning = 1;
	level.var_92914699 = 0;
	level.var_9bc0cd6e = 0;
	var_bc3b3f4c = getent("skullroom_keeper_spawner", "targetname");
	level.var_55c48492 clientfield::set("skullquest_finish_start_fx", 1);
	level.var_55c48492 clientfield::set("skullquest_finish_trail_fx", 1);
	level thread function_41b94a87();
	wait(0.25);
	level clientfield::set("keeper_spawn_portals", 1);
	wait(2.5);
	a_spawn_points = struct::get_array("s_spawnpt_skullroom");
	level flag::clear("skullroom_empty_of_players");
	var_2241a147 = [];
	level thread function_d91adba6();
	a_spawn_points = array::randomize(a_spawn_points);
	while(level.var_9bc0cd6e < level.var_49c6fb1c && !level flag::get("skullroom_empty_of_players") && (!(isdefined(level.var_d9d19dae) && level.var_d9d19dae)))
	{
		foreach(s_spawn_point in a_spawn_points)
		{
			while(getfreeactorcount() < 1 && !level flag::get("skullroom_empty_of_players") && (!(isdefined(level.var_d9d19dae) && level.var_d9d19dae)))
			{
				wait(0.05);
			}
			while(level.var_92914699 >= level.var_d15b7db3 && !level flag::get("skullroom_empty_of_players") && (!(isdefined(level.var_d9d19dae) && level.var_d9d19dae)))
			{
				wait(0.05);
			}
			if(level.var_9bc0cd6e >= level.var_49c6fb1c || level flag::get("skullroom_empty_of_players") || (isdefined(level.var_d9d19dae) && level.var_d9d19dae))
			{
				break;
			}
			s_spawn_point.script_string = "find_flesh";
			ai = zombie_utility::spawn_zombie(var_bc3b3f4c, "skullroom_keeper_zombie", s_spawn_point);
			if(isdefined(ai))
			{
				level.var_92914699++;
				ai.var_2f846873 = 1;
				ai.targetname = "skullroom_keeper_zombie";
				ai thread function_2d0c5aa1(s_spawn_point);
				level thread function_efbd4abf(ai, s_spawn_point);
				ai.custom_location = &function_b820cada;
				array::add(var_2241a147, ai);
			}
			wait(1);
		}
	}
	level flag::clear("skullroom_defend_inprogress");
	level clientfield::set("keeper_spawn_portals", 0);
	level.var_55c48492 clientfield::set("skullquest_finish_start_fx", 0);
	level.var_55c48492 clientfield::set("skullquest_finish_trail_fx", 0);
	level.var_b10ab148 = level.var_9bc0cd6e >= level.var_49c6fb1c;
	level flag::set("skull_quest_complete");
	if(isdefined(level.var_b10ab148) && level.var_b10ab148)
	{
		var_363b7d39 = getent("volume_thrasher_non_teleport_ruins_underground", "targetname");
		var_363b7d39 delete();
		level.var_55c48492 thread function_85a2a491();
	}
	var_2241a147 = array::remove_dead(var_2241a147, 0);
	foreach(var_e35bb14a in var_2241a147)
	{
		if(isalive(var_e35bb14a))
		{
			var_e35bb14a kill();
		}
	}
	level.var_55c48492 playsound("evt_keeper_quest_done");
	wait(1.5);
	level.var_55c48492 moveto(level.var_55c48492.var_5cd7e450, 0.5);
	level.zombie_ai_limit = level.zombie_ai_limit + level.var_d15b7db3;
	level flag::set("spawn_zombies");
	level.disable_nuke_delay_spawning = 0;
}

/*
	Name: function_d91adba6
	Namespace: zm_island_skullquest
	Checksum: 0xD8B4CFF0
	Offset: 0x6EF8
	Size: 0x1E6
	Parameters: 0
	Flags: Linked
*/
function function_d91adba6()
{
	t_inside_skullroom = getent("t_inside_skullroom", "targetname");
	level.var_d9d19dae = 0;
	while(level flag::get("skullroom_defend_inprogress"))
	{
		var_f66cf9d4 = [];
		foreach(player in level.activeplayers)
		{
			if(player zm_zonemgr::entity_in_zone("zone_ruins_underground", 1))
			{
				array::add(var_f66cf9d4, player);
			}
		}
		var_c277590a = 0;
		foreach(player in var_f66cf9d4)
		{
			if(player laststand::player_is_in_laststand())
			{
				var_c277590a++;
			}
		}
		if(var_c277590a === var_f66cf9d4.size)
		{
			level.var_d9d19dae = 1;
			break;
		}
		wait(1);
	}
}

/*
	Name: function_41b94a87
	Namespace: zm_island_skullquest
	Checksum: 0xCFE812B4
	Offset: 0x70E8
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_41b94a87()
{
	var_e312b793 = level.var_9bc0cd6e / level.var_49c6fb1c;
	if(var_e312b793 > 1)
	{
		var_e312b793 = 1;
	}
	var_3de76631 = level.var_55c48492.var_5cd7e450[2] + (10 * (1 - var_e312b793));
	var_ba7b8d86 = (level.var_55c48492.origin[0], level.var_55c48492.origin[1], var_3de76631);
	level.var_55c48492 moveto(var_ba7b8d86, 0.2);
}

/*
	Name: function_b820cada
	Namespace: zm_island_skullquest
	Checksum: 0x99EC1590
	Offset: 0x71C8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_b820cada()
{
}

/*
	Name: function_2d0c5aa1
	Namespace: zm_island_skullquest
	Checksum: 0x4501E29A
	Offset: 0x71D8
	Size: 0x19C
	Parameters: 1
	Flags: Linked
*/
function function_2d0c5aa1(s_spawn_point)
{
	self endon(#"death");
	self.script_string = "find_flesh";
	self setphysparams(15, 0, 72);
	self.ignore_enemy_count = 1;
	self.no_eye_glow = 1;
	self.deathpoints_already_given = 1;
	self.exclude_distance_cleanup_adding_to_total = 1;
	self.exclude_cleanup_adding_to_total = 1;
	self setteam("axis");
	self.start_inert = 1;
	self thread zm_spawner::zombie_think();
	self thread zm_spawner::enemy_death_detection();
	self.nocrawler = 1;
	self.no_powerups = 1;
	util::wait_network_frame();
	self clientfield::set("keeper_fx", 1);
	self.voiceprefix = "keeper";
	self.animname = "keeper";
	self thread zm_spawner::play_ambient_zombie_vocals();
	self thread zm_audio::zmbaivox_notifyconvert();
	if(self.zombie_move_speed === "walk")
	{
		self zombie_utility::set_zombie_run_cycle("run");
	}
}

/*
	Name: function_440fec7a
	Namespace: zm_island_skullquest
	Checksum: 0xD0395F39
	Offset: 0x7380
	Size: 0xA4
	Parameters: 1
	Flags: None
*/
function function_440fec7a(params)
{
	if(isdefined(self) && (isdefined(self.var_2f846873) && self.var_2f846873))
	{
		level.var_92914699--;
		level.var_9bc0cd6e++;
		function_a050863e(self.origin, level.var_55c48492.origin);
		level thread function_41b94a87();
		if(isdefined(self))
		{
			self clientfield::set("keeper_fx", 0);
		}
	}
}

/*
	Name: function_efbd4abf
	Namespace: zm_island_skullquest
	Checksum: 0x3BC296BC
	Offset: 0x7430
	Size: 0x10C
	Parameters: 2
	Flags: Linked
*/
function function_efbd4abf(ai_zombie, s_spawn_point)
{
	ai_zombie waittill(#"death");
	var_4124898d = ai_zombie.origin;
	level.var_92914699--;
	level.var_9bc0cd6e++;
	if(level flag::get("skullroom_defend_inprogress"))
	{
		if(isdefined(var_4124898d))
		{
			function_a050863e(var_4124898d, level.var_55c48492.origin);
		}
		level thread function_41b94a87();
	}
	if(isdefined(ai_zombie))
	{
		ai_zombie clientfield::set("keeper_fx", 0);
	}
	util::wait_network_frame();
	if(isdefined(ai_zombie))
	{
		ai_zombie delete();
	}
}

/*
	Name: function_458f50f2
	Namespace: zm_island_skullquest
	Checksum: 0x2E70A059
	Offset: 0x7548
	Size: 0x31C
	Parameters: 0
	Flags: Linked
*/
function function_458f50f2()
{
	self endon(#"death");
	if(!self hasweapon(level.var_c003f5b, 1))
	{
		if(!(isdefined(self.var_b319e777) && self.var_b319e777))
		{
			self.var_b319e777 = 1;
			self disableweaponcycling();
			self playsound("zmb_skullgun_pickup");
			var_7277c7f7 = self getcurrentweapon();
			self function_29d2aa0e(3, undefined, 1);
			self thread zm_audio::create_and_play_dialog("quest_skull", "weapon_success");
			self zm_weapons::weapon_give(level.var_c003f5b, undefined, undefined, 1);
			self gadgetpowerset(0, 100);
			self switchtoweapon(level.var_c003f5b);
			self notify(#"hash_ae5d6003");
			level flag::set("a_player_got_skullgun");
			self waittill(#"weapon_change_complete");
			wait(0.25);
			self switchtoweapon(var_7277c7f7);
			self waittill(#"weapon_change_complete");
			self gadgetpowerset(0, 100);
			self setweaponammoclip(level.var_c003f5b, 0);
			self giveachievement("ZM_ISLAND_OBTAIN_SKULL");
			self enableweaponcycling();
			self flag::set("has_skull");
			self thread function_5d65695d();
		}
		else
		{
			self zm_weapons::weapon_give(level.var_c003f5b, undefined, undefined, 1);
			self gadgetpowerset(0, 100);
			self setweaponammoclip(level.var_c003f5b, 0);
			self zm_hero_weapon::set_hero_weapon_state(level.var_c003f5b, 2);
			self thread function_29d2aa0e(3, undefined, 1);
			self thread zm_hero_weapon::watch_hero_weapon_take();
		}
	}
}

/*
	Name: function_940267cd
	Namespace: zm_island_skullquest
	Checksum: 0x9F9A8188
	Offset: 0x7870
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_940267cd()
{
	self endon(#"disconnect");
	level flag::wait_till("a_player_got_skullgun");
	var_d9516038 = getent("reveal_keeper_mural_01", "targetname");
	if(isdefined(var_d9516038) && !isdefined(var_d9516038.b_shown))
	{
		self thread function_f293f820(var_d9516038, "mural1_revealed");
	}
	else
	{
		callback::remove_on_spawned(&function_940267cd);
	}
}

/*
	Name: function_ba04e236
	Namespace: zm_island_skullquest
	Checksum: 0x925C564
	Offset: 0x7938
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_ba04e236()
{
	self endon(#"disconnect");
	level flag::wait_till("a_player_got_skullgun");
	var_d9516038 = getent("reveal_keeper_mural_02", "targetname");
	if(isdefined(var_d9516038) && !isdefined(var_d9516038.b_shown))
	{
		self thread function_f293f820(var_d9516038, "mural2_revealed");
	}
	else
	{
		callback::remove_on_spawned(&function_ba04e236);
	}
}

/*
	Name: function_e0075c9f
	Namespace: zm_island_skullquest
	Checksum: 0xBF01C4C0
	Offset: 0x7A00
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_e0075c9f()
{
	self endon(#"disconnect");
	level flag::wait_till("a_player_got_skullgun");
	var_d9516038 = getent("reveal_keeper_mural_03", "targetname");
	if(isdefined(var_d9516038) && !isdefined(var_d9516038.b_shown))
	{
		self thread function_f293f820(var_d9516038, "mural3_revealed");
	}
	else
	{
		callback::remove_on_spawned(&function_e0075c9f);
	}
}

/*
	Name: function_f293f820
	Namespace: zm_island_skullquest
	Checksum: 0x1C5DB16A
	Offset: 0x7AC8
	Size: 0x92
	Parameters: 2
	Flags: Linked
*/
function function_f293f820(mdl_target, var_6a4cf64a)
{
	self endon(#"disconnect");
	self endon(#"death");
	level endon(var_6a4cf64a);
	if(isdefined(mdl_target))
	{
		self zm_island_util::function_7448e472(mdl_target);
		mdl_target clientfield::set("do_emissive_material", 1);
		mdl_target.b_shown = 1;
		level notify(var_6a4cf64a);
	}
}

/*
	Name: function_d4ebb4b0
	Namespace: zm_island_skullquest
	Checksum: 0x3F9A5566
	Offset: 0x7B68
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_d4ebb4b0()
{
	if(isdefined(self.var_d64275e8) && self.var_d64275e8 > 0)
	{
		var_fc880a6c = level.var_a576e0b9[self.var_d64275e8].mdl_skull_s;
	}
	else if(isdefined(self.var_4849e523) && self.var_4849e523 > 0)
	{
		var_fc880a6c = level.var_a576e0b9[self.var_4849e523].mdl_skull_p;
	}
	if(isdefined(var_fc880a6c))
	{
		var_96b8c7e2 = level.var_b34be0cd[var_fc880a6c.var_f7d3c273];
		return var_96b8c7e2;
	}
	return -1;
}

/*
	Name: function_9e63bcd3
	Namespace: zm_island_skullquest
	Checksum: 0x7263FB0E
	Offset: 0x7C38
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_9e63bcd3(var_f2e38849)
{
	level.var_a576e0b9[var_f2e38849].mdl_skull_s.var_afb64bf6 = undefined;
	if(isdefined(self))
	{
		self thread function_71593151();
		self.var_d64275e8 = 0;
	}
	function_c029cf5b(var_f2e38849);
}

/*
	Name: function_880d3333
	Namespace: zm_island_skullquest
	Checksum: 0x3801C10F
	Offset: 0x7CA8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_880d3333(var_f2e38849)
{
	level.var_a576e0b9[var_f2e38849].mdl_skull_s function_b15a5bc1(level.var_a576e0b9[var_f2e38849].mdl_skull_s.var_5cd7e450, level.var_a576e0b9[var_f2e38849].mdl_skull_s.var_d7778aba);
}

/*
	Name: function_c029cf5b
	Namespace: zm_island_skullquest
	Checksum: 0xC8C27F5D
	Offset: 0x7D28
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_c029cf5b(var_f2e38849)
{
	level.var_a576e0b9[var_f2e38849].mdl_skull_s function_b15a5bc1(level.var_a576e0b9[var_f2e38849].s_skulltar_skull_pos.origin, level.var_a576e0b9[var_f2e38849].s_skulltar_skull_pos.angles);
	level.var_a576e0b9[var_f2e38849].mdl_skull_s show();
}

/*
	Name: function_b15a5bc1
	Namespace: zm_island_skullquest
	Checksum: 0xA3EFA459
	Offset: 0x7DD0
	Size: 0x6C
	Parameters: 3
	Flags: Linked
*/
function function_b15a5bc1(v_pos, v_angles, b_show = 1)
{
	self.origin = v_pos;
	self.angles = v_angles;
	if(isdefined(b_show) && b_show)
	{
		self show();
	}
}

/*
	Name: function_e3ff3bac
	Namespace: zm_island_skullquest
	Checksum: 0x73AC0DEC
	Offset: 0x7E48
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_e3ff3bac(var_f2e38849)
{
	level.var_a576e0b9[var_f2e38849].mdl_skull_p ghost();
	level.var_a576e0b9[var_f2e38849].mdl_skull_p.var_afb64bf6 = self;
	self.var_4849e523 = var_f2e38849;
	var_96b8c7e2 = self function_d4ebb4b0();
	self function_29d2aa0e(2, var_96b8c7e2, 1);
	self thread zm_island_vo::function_87d97caa();
}

/*
	Name: function_b6c35b21
	Namespace: zm_island_skullquest
	Checksum: 0x48444B5F
	Offset: 0x7F18
	Size: 0x48C
	Parameters: 1
	Flags: Linked
*/
function function_b6c35b21(var_f2e38849)
{
	if(!(isdefined(level.var_a576e0b9[var_f2e38849].mdl_skull_p.var_d17d835d) && level.var_a576e0b9[var_f2e38849].mdl_skull_p.var_d17d835d))
	{
		level.var_a576e0b9[var_f2e38849].mdl_skull_p.var_d17d835d = 1;
		self thread function_71593151();
		level.var_a576e0b9[var_f2e38849].mdl_skull_p.var_afb64bf6 = undefined;
		var_1a3afb94 = self.var_4849e523;
		var_96b8c7e2 = self function_d4ebb4b0();
		self function_29d2aa0e(0, var_96b8c7e2, 0);
		self.var_4849e523 = 0;
		level.var_a576e0b9[var_f2e38849].mdl_skull_s ghost();
		self thread zm_island_vo::function_64f4c27();
		level.var_a576e0b9[var_f2e38849].mdl_skull_p.origin = level.var_a576e0b9[var_f2e38849].mdl_skull_s.var_5cd7e450;
		level.var_a576e0b9[var_f2e38849].mdl_skull_p.angles = level.var_a576e0b9[var_f2e38849].mdl_skull_s.var_d7778aba;
		level.var_a576e0b9[var_f2e38849].mdl_skull_p show();
		level.var_a576e0b9[var_f2e38849].mdl_skull_p clientfield::set("skullquest_finish_start_fx", 1);
		level.var_a576e0b9[var_f2e38849].mdl_skull_p playsound("zmb_skull_pillar_fly");
		level.var_a576e0b9[var_f2e38849].mdl_skull_p clientfield::set("skullquest_finish_end_fx", 1);
		var_4126c532 = level.var_a576e0b9[var_f2e38849];
		mdl_skull_p = level.var_a576e0b9[var_f2e38849].mdl_skull_p;
		var_f7d3c273 = mdl_skull_p.var_f7d3c273;
		var_c274e933 = array("", "altar_skull_battle", "altar_skull_blood", "altar_skull_chaos", "altar_skull_doom");
		var_9d012998 = array("", "skull_battle_jnt", "skull_blood_jnt", "skull_chaos_jnt", "skull_doom_jnt");
		var_c9260a5 = array("", "p7_fxanim_zm_island_altar_skull_battle_bundle", "p7_fxanim_zm_island_altar_skull_blood_bundle", "p7_fxanim_zm_island_altar_skull_chaos_bundle", "p7_fxanim_zm_island_altar_skull_doom_bundle");
		var_e36aa077 = getent(var_c274e933[var_f7d3c273], "targetname");
		var_e36aa077 clientfield::set("do_emissive_material", 1);
		var_e36aa077 thread scene::play(var_c9260a5[var_f7d3c273], var_e36aa077);
		mdl_skull_p linkto(var_e36aa077, var_9d012998[var_f7d3c273]);
		var_e36aa077 waittill(#"scene_done");
		level notify("skull_p_returned" + var_1a3afb94);
	}
}

/*
	Name: function_76e79e0e
	Namespace: zm_island_skullquest
	Checksum: 0xC48BD38B
	Offset: 0x83B0
	Size: 0x18
	Parameters: 0
	Flags: Linked
*/
function function_76e79e0e()
{
	return (self.var_4849e523 + self.var_d64275e8) > 0;
}

/*
	Name: function_9e2f0e52
	Namespace: zm_island_skullquest
	Checksum: 0x5E8A58B7
	Offset: 0x83D0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_9e2f0e52()
{
	return zombie_utility::is_player_valid(self) && isalive(self) && !self laststand::player_is_in_laststand();
}

/*
	Name: on_player_spawned
	Namespace: zm_island_skullquest
	Checksum: 0x9A50C1F3
	Offset: 0x8428
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self.var_d64275e8 = 0;
	self.var_4849e523 = 0;
	self.var_335e6491 = [];
	self.var_335e6491[0] = undefined;
	self.var_335e6491[1] = undefined;
	while(true)
	{
		self waittill(#"bled_out");
		self thread function_c7cd5585();
		self function_29d2aa0e(0, 0, 0);
	}
}

/*
	Name: function_c7cd5585
	Namespace: zm_island_skullquest
	Checksum: 0x8901A7BA
	Offset: 0x84B8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_c7cd5585()
{
	if(self.var_d64275e8 !== 0)
	{
		level thread function_3fe31e5b(self.var_d64275e8);
	}
	else if(self.var_4849e523 !== 0)
	{
		level thread function_eba0c996(self.var_4849e523);
	}
}

/*
	Name: function_18d60013
	Namespace: zm_island_skullquest
	Checksum: 0x9A5CFD92
	Offset: 0x8520
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function function_18d60013()
{
	/#
		zm_devgui::add_custom_devgui_callback(&function_3bd86987);
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
	#/
}

/*
	Name: function_3bd86987
	Namespace: zm_island_skullquest
	Checksum: 0x572BFF83
	Offset: 0x8738
	Size: 0x420
	Parameters: 1
	Flags: Linked
*/
function function_3bd86987(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				function_fdafeea2(level.activeplayers[0]);
				level flag::set("");
				return true;
			}
			case "":
			{
				function_f7ec6ad4(1, level.activeplayers[0]);
				wait(1);
				return true;
			}
			case "":
			{
				function_f7ec6ad4(2, level.activeplayers[0]);
				wait(1);
				return true;
			}
			case "":
			{
				function_f7ec6ad4(3, level.activeplayers[0]);
				wait(1);
				return true;
			}
			case "":
			{
				function_f7ec6ad4(4, level.activeplayers[0]);
				wait(1);
				return true;
			}
			case "":
			{
				foreach(player in level.activeplayers)
				{
					player gadgetpowerset(0, 100);
				}
				return true;
			}
			case "":
			{
				function_8196b5ee();
				level flag::set("");
				wait(1);
				return true;
			}
			case "":
			{
				function_bc2507a3(1);
				return true;
			}
			case "":
			{
				function_bc2507a3(2);
				return true;
			}
			case "":
			{
				function_bc2507a3(3);
				return true;
			}
			case "":
			{
				function_bc2507a3(4);
				return true;
			}
			case "":
			{
				function_bc2507a3(0);
				return true;
			}
			case "":
			{
				function_138d72ee(1);
				return true;
			}
			case "":
			{
				function_138d72ee(2);
				return true;
			}
			case "":
			{
				function_138d72ee(3);
				return true;
			}
			case "":
			{
				function_138d72ee(4);
				return true;
			}
			case "":
			{
				if(!(isdefined(level.var_32d5991a) && level.var_32d5991a))
				{
					level.var_32d5991a = 1;
				}
				else
				{
					level.var_32d5991a = 0;
				}
				return true;
			}
			case "":
			{
				level.var_69fe775a = 100;
				return true;
			}
			case "":
			{
				level.var_69fe775a = 1200;
				return true;
			}
			case "":
			{
				level.var_69fe775a = 0;
				return true;
			}
		}
		return false;
	#/
}

/*
	Name: function_138d72ee
	Namespace: zm_island_skullquest
	Checksum: 0xC389BF35
	Offset: 0x8B68
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_138d72ee(var_f2e38849)
{
	/#
		level thread function_fae0aa01(var_f2e38849, "", level.activeplayers[0]);
	#/
}

/*
	Name: function_bc2507a3
	Namespace: zm_island_skullquest
	Checksum: 0x87B9484
	Offset: 0x8BB0
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function function_bc2507a3(n_progress)
{
	/#
		level.var_4ffafd2 = n_progress;
	#/
}

/*
	Name: function_8196b5ee
	Namespace: zm_island_skullquest
	Checksum: 0x8A38A04
	Offset: 0x8BD8
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function function_8196b5ee()
{
	/#
		foreach(player in level.activeplayers)
		{
			player function_458f50f2();
		}
	#/
}

/*
	Name: function_f7ec6ad4
	Namespace: zm_island_skullquest
	Checksum: 0x29036CC0
	Offset: 0x8C78
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function function_f7ec6ad4(var_f2e38849, ent)
{
	/#
		if(ent.var_d64275e8 === 0)
		{
			function_fae0aa01(var_f2e38849, "", ent);
		}
	#/
}

/*
	Name: function_38f8b6e3
	Namespace: zm_island_skullquest
	Checksum: 0x1E751342
	Offset: 0x8CD0
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function function_38f8b6e3(var_f2e38849)
{
	if(!level flag::exists("skullquest_completed" + var_f2e38849))
	{
		level flag::init("skullquest_completed" + var_f2e38849);
	}
	function_fae0aa01(var_f2e38849, "start");
	level.var_a576e0b9[var_f2e38849].s_utrig_pillar setup_unitrigger("unitrigger_radius_use", &function_8c6a13d0, &function_dc9fe8fe, 24);
	level.var_a576e0b9[var_f2e38849].s_utrig_skulltar setup_unitrigger("unitrigger_radius_use", &function_3cd83908, &function_d757eab6);
}

/*
	Name: setup_unitrigger
	Namespace: zm_island_skullquest
	Checksum: 0x1D79DEE7
	Offset: 0x8DF0
	Size: 0xF4
	Parameters: 6
	Flags: Linked
*/
function setup_unitrigger(str_type = "unitrigger_radius_use", var_fe58e458, func_think, n_radius = 64, n_height = 256, b_lookat = 1)
{
	self.script_unitrigger_type = "unitrigger_radius_use";
	self.cursor_hint = "HINT_NOICON";
	self.require_look_at = b_lookat;
	self.radius = n_radius;
	self.height = n_height;
	self.prompt_and_visibility_func = var_fe58e458;
	zm_unitrigger::register_static_unitrigger(self, func_think);
}

/*
	Name: function_fae0aa01
	Namespace: zm_island_skullquest
	Checksum: 0x7D644B35
	Offset: 0x8EF0
	Size: 0xA36
	Parameters: 3
	Flags: Linked
*/
function function_fae0aa01(var_f2e38849, var_f2a1da83, player)
{
	var_f1556de = array("start", "skull_s_picked_up", "inritual", "pre_retry", "retry", "postritual", "skull_p_picked_up", "completed");
	if(level.var_a576e0b9[var_f2e38849].str_state !== var_f2a1da83 && isinarray(var_f1556de, var_f2a1da83))
	{
		level.var_a576e0b9[var_f2e38849].str_state = var_f2a1da83;
		switch(var_f2a1da83)
		{
			case "start":
			{
				level.var_a576e0b9[var_f2e38849].mdl_skull_s.origin = level.var_a576e0b9[var_f2e38849].mdl_skull_s.var_5cd7e450;
				level.var_a576e0b9[var_f2e38849].mdl_skull_s.angles = level.var_a576e0b9[var_f2e38849].mdl_skull_s.var_d7778aba;
				level.var_a576e0b9[var_f2e38849].mdl_skull_s clientfield::set("do_fade_material_direct", 1);
				level.var_a576e0b9[var_f2e38849].mdl_skull_s show();
				level.var_a576e0b9[var_f2e38849].mdl_skull_s clientfield::set("skullquest_finish_start_fx", 1);
				level.var_a576e0b9[var_f2e38849].mdl_skull_s playsound("zmb_skull_reappear");
				level.var_a576e0b9[var_f2e38849].mdl_skull_s.var_afb64bf6 = undefined;
				foreach(plyr in level.activeplayers)
				{
					if(plyr.var_d64275e8 === var_f2e38849)
					{
						plyr.var_d64275e8 = 0;
					}
				}
				level.var_a576e0b9[var_f2e38849].mdl_skull_p ghost();
				level.var_a576e0b9[var_f2e38849].mdl_skulltar clientfield::set("do_emissive_material", 0);
				break;
			}
			case "skull_s_picked_up":
			{
				player function_5f43b720(var_f2e38849);
				break;
			}
			case "inritual":
			{
				if(!level flag::get("skullquest_ritual_inprogress" + var_f2e38849))
				{
					if(zombie_utility::is_player_valid(player))
					{
						player function_9e63bcd3(var_f2e38849);
						player playsound("zmb_skulltar_place");
					}
					player thread zm_island_vo::function_9984d8f0();
					level.var_a576e0b9[var_f2e38849].mdl_skull_p.origin = level.var_a576e0b9[var_f2e38849].s_skulltar_skull_pos.origin;
					level.var_a576e0b9[var_f2e38849].mdl_skull_p.angles = level.var_a576e0b9[var_f2e38849].s_skulltar_skull_pos.angles;
					level.var_a576e0b9[var_f2e38849].mdl_skull_p ghost();
					level.var_a576e0b9[var_f2e38849] thread function_80794095();
					break;
				}
			}
			case "pre_retry":
			{
				level.var_a576e0b9[var_f2e38849].mdl_skull_s.origin = level.var_a576e0b9[var_f2e38849].s_skulltar_skull_pos.origin;
				level.var_a576e0b9[var_f2e38849].mdl_skull_s.angles = level.var_a576e0b9[var_f2e38849].s_skulltar_skull_pos.angles;
				level.var_a576e0b9[var_f2e38849].mdl_skull_s ghost();
				level.var_a576e0b9[var_f2e38849].mdl_skull_s clientfield::set("skullquest_finish_start_fx", 1);
				level waittill(#"start_of_round");
				if(level.var_a576e0b9[var_f2e38849].str_state === "pre_retry")
				{
					level thread function_fae0aa01(var_f2e38849, "start");
				}
				break;
			}
			case "retry":
			{
				level.var_a576e0b9[var_f2e38849].mdl_skull_s.origin = level.var_a576e0b9[var_f2e38849].s_skulltar_skull_pos.origin;
				level.var_a576e0b9[var_f2e38849].mdl_skull_s.angles = level.var_a576e0b9[var_f2e38849].s_skulltar_skull_pos.angles;
				level.var_a576e0b9[var_f2e38849].mdl_skull_s show();
				level.var_a576e0b9[var_f2e38849].mdl_skull_p.origin = level.var_a576e0b9[var_f2e38849].s_skulltar_skull_pos.origin;
				level.var_a576e0b9[var_f2e38849].mdl_skull_p.angles = level.var_a576e0b9[var_f2e38849].s_skulltar_skull_pos.angles;
				level.var_a576e0b9[var_f2e38849].mdl_skull_p ghost();
				break;
			}
			case "postritual":
			{
				level.var_a576e0b9[var_f2e38849].mdl_skull_p.origin = level.var_a576e0b9[var_f2e38849].mdl_skull_s.origin;
				level.var_a576e0b9[var_f2e38849].mdl_skull_p.angles = level.var_a576e0b9[var_f2e38849].mdl_skull_s.angles;
				level.var_a576e0b9[var_f2e38849].mdl_skull_p show();
				level.var_a576e0b9[var_f2e38849].mdl_skull_s ghost();
				break;
			}
			case "skull_p_picked_up":
			{
				level.var_a576e0b9[var_f2e38849].mdl_skull_s ghost();
				player function_e3ff3bac(var_f2e38849);
				break;
			}
			case "completed":
			{
				level.var_a576e0b9[var_f2e38849] flag::set("skullquest_completed");
				player function_b6c35b21(var_f2e38849);
				level.var_452c59e0++;
				if(level.var_452c59e0 == 4)
				{
					level thread exploder::exploder("fxexp_503");
					wait(0.25);
					level thread function_fdafeea2(player);
					foreach(var_d49f23e6 in level.var_a576e0b9)
					{
						var_d49f23e6.mdl_skull_p clientfield::set("skullquest_finish_done_glow_fx", 1);
					}
				}
				zm_unitrigger::unregister_unitrigger(level.var_a576e0b9[var_f2e38849].s_utrig_pillar);
				zm_unitrigger::unregister_unitrigger(level.var_a576e0b9[var_f2e38849].s_utrig_skulltar);
				break;
			}
		}
	}
}

/*
	Name: function_741beb6d
	Namespace: zm_island_skullquest
	Checksum: 0xBA5DC3CD
	Offset: 0x9930
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function function_741beb6d(var_f2e38849)
{
	return level.var_a576e0b9[var_f2e38849].str_state;
}

/*
	Name: function_8c6a13d0
	Namespace: zm_island_skullquest
	Checksum: 0xFDA63421
	Offset: 0x9960
	Size: 0x210
	Parameters: 1
	Flags: Linked
*/
function function_8c6a13d0(player)
{
	var_6d538e4e = function_741beb6d(self.stub.script_special);
	if(player !== level.var_2371bbc)
	{
		switch(var_6d538e4e)
		{
			case "start":
			{
				if(!player function_76e79e0e())
				{
					self sethintstringforplayer(player, level.var_8b0a8fa9);
					return true;
				}
				else
				{
					self sethintstringforplayer(player, "");
					return false;
				}
			}
			case "skull_s_picked_up":
			{
				if(player.var_d64275e8 === self.stub.script_special)
				{
					self sethintstringforplayer(player, level.var_983da0e6);
					return true;
				}
				else
				{
					self sethintstringforplayer(player, "");
					return false;
				}
			}
			case "skull_p_picked_up":
			{
				if(player.var_4849e523 === self.stub.script_special)
				{
					self sethintstringforplayer(player, level.var_983da0e6);
					return true;
				}
				else
				{
					self sethintstringforplayer(player, "");
					return false;
				}
			}
			default:
			{
				self sethintstringforplayer(player, "");
				return false;
			}
		}
	}
	else
	{
		self sethintstringforplayer(player, "");
		return false;
	}
}

/*
	Name: function_dc9fe8fe
	Namespace: zm_island_skullquest
	Checksum: 0xB9D2BE94
	Offset: 0x9B78
	Size: 0x260
	Parameters: 0
	Flags: Linked
*/
function function_dc9fe8fe()
{
	while(true)
	{
		self waittill(#"trigger", player);
		if(player function_9e2f0e52())
		{
			var_6d538e4e = function_741beb6d(self.stub.script_special);
			switch(var_6d538e4e)
			{
				case "start":
				{
					if(!player function_76e79e0e())
					{
						level thread function_fae0aa01(self.stub.script_special, "skull_s_picked_up", player);
						player playsound("zmb_skull_pickup");
						self sethintstring("");
					}
					break;
				}
				case "skull_s_picked_up":
				{
					if(player.var_d64275e8 === self.stub.script_special)
					{
						player thread function_8302a101(self.stub.script_special);
						player playsound("zmb_skull_place");
						level thread function_fae0aa01(self.stub.script_special, "start");
						self sethintstring("");
					}
					break;
				}
				case "skull_p_picked_up":
				{
					if(player.var_4849e523 === self.stub.script_special)
					{
						level thread function_fae0aa01(self.stub.script_special, "completed", player);
						self sethintstring("");
					}
					break;
				}
			}
			wait(1);
		}
	}
}

/*
	Name: function_3cd83908
	Namespace: zm_island_skullquest
	Checksum: 0xA3740A08
	Offset: 0x9DE0
	Size: 0x17E
	Parameters: 1
	Flags: Linked
*/
function function_3cd83908(player)
{
	var_6d538e4e = function_741beb6d(self.stub.script_special);
	switch(var_6d538e4e)
	{
		case "skull_s_picked_up":
		case "start":
		{
			if(player.var_d64275e8 === self.stub.script_special)
			{
				self sethintstringforplayer(player, level.var_983da0e6);
				return true;
			}
			else
			{
				self sethintstringforplayer(player, "");
				return false;
			}
		}
		case "pre_retry":
		{
			return false;
		}
		case "retry":
		{
			self sethintstringforplayer(player, level.var_8b418269);
			return true;
		}
		case "postritual":
		{
			if(player function_76e79e0e())
			{
				return false;
			}
			else
			{
				self sethintstring(level.var_8b0a8fa9);
				return true;
			}
		}
		default:
		{
			self sethintstringforplayer(player, "");
			return false;
		}
	}
}

/*
	Name: function_d757eab6
	Namespace: zm_island_skullquest
	Checksum: 0xB8329916
	Offset: 0x9F68
	Size: 0x220
	Parameters: 0
	Flags: Linked
*/
function function_d757eab6()
{
	while(true)
	{
		self waittill(#"trigger", player);
		if(player function_9e2f0e52())
		{
			var_6d538e4e = function_741beb6d(self.stub.script_special);
			switch(var_6d538e4e)
			{
				case "skull_s_picked_up":
				case "start":
				{
					if(player.var_d64275e8 === self.stub.script_special)
					{
						level thread function_fae0aa01(self.stub.script_special, "inritual", player);
						self sethintstring("");
					}
					break;
				}
				case "retry":
				{
					level.var_a576e0b9[self.stub.script_special] thread function_80794095();
					level thread function_fae0aa01(self.stub.script_special, "inritual");
					self sethintstring("");
					break;
				}
				case "postritual":
				{
					if(!player function_76e79e0e())
					{
						level thread function_fae0aa01(self.stub.script_special, "skull_p_picked_up", player);
						player playsound("zmb_skull_pickup");
						self sethintstring("");
					}
					break;
				}
			}
			wait(1);
		}
	}
}

/*
	Name: function_5f43b720
	Namespace: zm_island_skullquest
	Checksum: 0x3263A6C7
	Offset: 0xA190
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function function_5f43b720(var_f2e38849)
{
	var_de2720b3 = level.var_a576e0b9[var_f2e38849].mdl_skulltar.origin - vectorscale((0, 0, 1), 32);
	level.var_a576e0b9[var_f2e38849].mdl_skull_s function_b15a5bc1(var_de2720b3, level.var_a576e0b9[var_f2e38849].s_skulltar_skull_pos.angles);
	level.var_a576e0b9[var_f2e38849].mdl_skull_s.var_afb64bf6 = self;
	self.var_d64275e8 = var_f2e38849;
	var_96b8c7e2 = self function_d4ebb4b0();
	self function_29d2aa0e(1, var_96b8c7e2, 1);
	self thread zm_island_vo::function_97ed7288();
}

/*
	Name: function_8302a101
	Namespace: zm_island_skullquest
	Checksum: 0xCA6CFCE0
	Offset: 0xA2C0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_8302a101(var_f2e38849)
{
	var_96b8c7e2 = self function_d4ebb4b0();
	self function_29d2aa0e(0, var_96b8c7e2, 1);
	level thread function_3fe31e5b(var_f2e38849);
}

/*
	Name: function_74513d26
	Namespace: zm_island_skullquest
	Checksum: 0x2862AE22
	Offset: 0xA330
	Size: 0x92
	Parameters: 0
	Flags: None
*/
function function_74513d26()
{
	var_28ff596b = 0;
	for(i = 1; i <= 4; i++)
	{
		str_flag = "skullquest_ritual_inprogress" + i;
		if(level flag::exists(str_flag) && level flag::get(str_flag))
		{
			var_28ff596b++;
		}
	}
	return var_28ff596b;
}

/*
	Name: function_567dfe61
	Namespace: zm_island_skullquest
	Checksum: 0x7C1A3070
	Offset: 0xA3D0
	Size: 0x92
	Parameters: 0
	Flags: None
*/
function function_567dfe61()
{
	var_aa60e64e = 0;
	for(i = 1; i <= 4; i++)
	{
		str_flag = "skullquest_ritual_complete" + i;
		if(level flag::exists(str_flag) && level flag::get(str_flag))
		{
			var_aa60e64e++;
		}
	}
	return var_aa60e64e;
}

/*
	Name: function_29d2aa0e
	Namespace: zm_island_skullquest
	Checksum: 0x33114096
	Offset: 0xA470
	Size: 0x9C
	Parameters: 3
	Flags: Linked
*/
function function_29d2aa0e(var_228798e1, var_96b8c7e2, var_b89973c8 = 0)
{
	self clientfield::set_to_player("skull_skull_state", var_228798e1);
	if(isdefined(var_96b8c7e2))
	{
		self clientfield::set_to_player("skull_skull_type", var_96b8c7e2);
	}
	if(var_b89973c8)
	{
		self thread zm_craftables::player_show_craftable_parts_ui(undefined, "zmInventory.widget_skull_parts", 0);
	}
}

/*
	Name: function_71593151
	Namespace: zm_island_skullquest
	Checksum: 0x1ACD51DF
	Offset: 0xA518
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_71593151()
{
	self function_29d2aa0e(0, 0, 0);
}

/*
	Name: function_5d65695d
	Namespace: zm_island_skullquest
	Checksum: 0x57D69C80
	Offset: 0xA540
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function function_5d65695d()
{
	self endon(#"disconnect");
	self.var_1ff2320b = 0;
	while(!self.var_1ff2320b)
	{
		self waittill(#"weapon_change");
		if(self getcurrentweapon() == level.var_c003f5b)
		{
			self.var_1ff2320b = 1;
			self zm_equipment::show_hint_text(&"ZM_ISLAND_SKULL_VAPORIZE", 4);
		}
	}
}

