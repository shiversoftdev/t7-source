// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\table_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_wasp;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_rocketshield;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\craftables\_zm_craft_shield;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_zod_idgun_quest;
#using scripts\zm\zm_zod_quest;
#using scripts\zm\zm_zod_shadowman;
#using scripts\zm\zm_zod_util;
#using scripts\zm\zm_zod_vo;

#namespace zm_zod_pods;

/*
	Name: __init__sytem__
	Namespace: zm_zod_pods
	Checksum: 0xEDEF4CC
	Offset: 0x8C0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("zm_zod_pods", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_pods
	Checksum: 0x827A14BE
	Offset: 0x908
	Size: 0x67C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "ZM_ZOD_UI_POD_SPRAYER_PICKUP", 1, 1, "int");
	clientfield::register("scriptmover", "update_fungus_pod_level", 1, 3, "int");
	clientfield::register("scriptmover", "pod_sprayer_glint", 1, 1, "int");
	clientfield::register("scriptmover", "pod_miasma", 1, 1, "counter");
	clientfield::register("scriptmover", "pod_harvest", 1, 1, "counter");
	clientfield::register("scriptmover", "pod_self_destruct", 1, 1, "counter");
	clientfield::register("toplayer", "pod_sprayer_held", 1, 1, "int");
	clientfield::register("toplayer", "pod_sprayer_hint_range", 1, 1, "int");
	level.var_6fa2f6ca = spawnstruct();
	level.var_6fa2f6ca.upgrade_odds = array(0, 0, 0, 0.25, 0.25, 0.5, 0.5, 1);
	a_table = table::load("gamedata/tables/zm/zm_zod_pods.csv", "ScriptID");
	level.var_6fa2f6ca.rewards = [];
	level.var_6fa2f6ca.rewards[1] = [];
	level.var_6fa2f6ca.rewards[2] = [];
	level.var_6fa2f6ca.rewards[3] = [];
	level.var_6fa2f6ca.bonus_points_amount = 100;
	level.bonus_points_powerup_override = &function_20affc0e;
	/#
		level.var_6fa2f6ca.debug_reward_list = [];
	#/
	wpn_none = getweapon("none");
	a_keys = getarraykeys(a_table);
	for(i = 0; i < a_keys.size; i++)
	{
		str_key = a_keys[i];
		s_reward = spawnstruct();
		s_reward.reward_level = a_table[str_key]["Level"];
		s_reward.type = a_table[str_key]["Type"];
		if(s_reward.type == "weapon")
		{
			s_reward.item = getweapon(a_table[str_key]["Item"]);
			if(s_reward.item == wpn_none)
			{
				/#
					/#
						assertmsg("" + a_table[str_key][""] + "");
					#/
				#/
				continue;
			}
		}
		else
		{
			s_reward.item = a_table[str_key]["Item"];
		}
		s_reward.count = a_table[str_key]["Count"];
		s_reward.chance = a_table[str_key]["Weight"];
		if(!isdefined(level.var_6fa2f6ca.rewards[s_reward.reward_level]))
		{
			level.var_6fa2f6ca.rewards[s_reward.reward_level] = [];
		}
		else if(!isarray(level.var_6fa2f6ca.rewards[s_reward.reward_level]))
		{
			level.var_6fa2f6ca.rewards[s_reward.reward_level] = array(level.var_6fa2f6ca.rewards[s_reward.reward_level]);
		}
		level.var_6fa2f6ca.rewards[s_reward.reward_level][level.var_6fa2f6ca.rewards[s_reward.reward_level].size] = s_reward;
		/#
			level.var_6fa2f6ca.debug_reward_list[str_key] = s_reward;
		#/
	}
	function_bcc1a076();
	thread function_77d7e068();
	normalize_reward_chances();
	level flag::init("any_player_has_pod_sprayer");
	level flag::init("hide_pods_for_trailer");
	/#
		level thread function_5c18476f();
	#/
}

/*
	Name: __main__
	Namespace: zm_zod_pods
	Checksum: 0x5C3C873D
	Offset: 0xF90
	Size: 0x374
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level flag::wait_till("start_zombie_round_logic");
	if(getdvarint("splitscreen_playerCount") > 2)
	{
		return;
	}
	level.var_6fa2f6ca.var_4042b27e = struct::get_array("fungus_pod", "targetname");
	level.var_6fa2f6ca.var_5d8c3695 = [];
	foreach(var_343e2beb, var_194575a7 in level.var_6fa2f6ca.var_4042b27e)
	{
		var_194575a7.model = util::spawn_model("tag_origin", var_194575a7.origin, var_194575a7.angles);
		if(isdefined(var_194575a7.script_noteworthy) && var_194575a7.script_noteworthy == "active")
		{
			var_194575a7.var_8486ae6a = 1;
		}
		else
		{
			var_194575a7.var_8486ae6a = 0;
		}
		var_194575a7.model clientfield::set("update_fungus_pod_level", 4);
	}
	level.var_6fa2f6ca.sprayers = [];
	a_sprayers = struct::get_array("pod_sprayer_location", "targetname");
	a_sprayers = array::randomize(a_sprayers);
	a_chosen = [];
	foreach(var_73609434, s_sprayer in a_sprayers)
	{
		if(isdefined(a_chosen[s_sprayer.script_int]))
		{
			continue;
		}
		a_chosen[s_sprayer.script_int] = s_sprayer;
	}
	foreach(var_40ce22db, s_sprayer in a_chosen)
	{
		s_sprayer thread pod_sprayer_think();
	}
	thread function_ab887f9d();
	level thread function_bf70a1ff();
}

/*
	Name: function_5c18476f
	Namespace: zm_zod_pods
	Checksum: 0x70F9F283
	Offset: 0x1310
	Size: 0x240
	Parameters: 0
	Flags: Linked
*/
function function_5c18476f()
{
	/#
		setdvar("", "");
		setdvar("", "");
		adddebugcommand("");
		adddebugcommand("");
		a_keys = getarraykeys(level.var_6fa2f6ca.debug_reward_list);
		for(i = 0; i < a_keys.size; i++)
		{
			str_id = a_keys[i];
			adddebugcommand("" + str_id + "" + str_id + "");
		}
		s_sword_rock = struct::get("", "");
		while(true)
		{
			cmd = getdvarstring("");
			if(cmd != "")
			{
				switch(cmd)
				{
					case "":
					{
						level notify(#"debug_pod_spawn");
						break;
					}
					case "":
					{
						level.debug_pod_spawn_all = 1;
						level notify(#"debug_pod_spawn");
						util::wait_network_frame();
						level.debug_pod_spawn_all = 0;
						break;
					}
					default:
					{
						break;
					}
				}
				setdvar("", "");
			}
			util::wait_network_frame();
		}
	#/
}

/*
	Name: function_bcc1a076
	Namespace: zm_zod_pods
	Checksum: 0x5CDCA32
	Offset: 0x1558
	Size: 0x118
	Parameters: 0
	Flags: Linked
*/
function function_bcc1a076()
{
	foreach(var_cfa31b49, var_3c1def9d in level.var_6fa2f6ca.rewards)
	{
		foreach(var_7e4e54bc, s_reward in var_3c1def9d)
		{
			if(s_reward.type == "shield_recharge")
			{
				s_reward.do_not_consider = 1;
			}
		}
	}
}

/*
	Name: function_77d7e068
	Namespace: zm_zod_pods
	Checksum: 0xB9F25AFC
	Offset: 0x1678
	Size: 0x120
	Parameters: 0
	Flags: Linked
*/
function function_77d7e068()
{
	level waittill(#"shield_built");
	foreach(var_3ed956da, var_3c1def9d in level.var_6fa2f6ca.rewards)
	{
		foreach(var_f2d46208, s_reward in var_3c1def9d)
		{
			if(s_reward.type == "shield_recharge")
			{
				s_reward.do_not_consider = 0;
			}
		}
	}
}

/*
	Name: pod_sprayer_pickup_msg
	Namespace: zm_zod_pods
	Checksum: 0x9D2F7099
	Offset: 0x17A0
	Size: 0x42
	Parameters: 1
	Flags: Linked, Private
*/
private function pod_sprayer_pickup_msg(e_player)
{
	if(e_player clientfield::get_to_player("pod_sprayer_held"))
	{
		return &"";
	}
	return &"ZM_ZOD_PICKUP_SPRAYER";
}

/*
	Name: pod_sprayer_think
	Namespace: zm_zod_pods
	Checksum: 0x695E38B5
	Offset: 0x17F0
	Size: 0x21E
	Parameters: 0
	Flags: Linked, Private
*/
private function pod_sprayer_think()
{
	while(true)
	{
		self.model = util::spawn_model("p7_zm_zod_bug_sprayer", self.origin, self.angles);
		self.model clientfield::set("pod_sprayer_glint", 1);
		self.trigger = zm_zod_util::spawn_trigger_radius(self.origin, 50, 1, &pod_sprayer_pickup_msg);
		while(true)
		{
			self.trigger waittill(#"trigger", e_who);
			if(e_who clientfield::get_to_player("pod_sprayer_held"))
			{
				continue;
			}
			e_who thread zm_audio::create_and_play_dialog("sprayer", "pickup");
			e_who clientfield::set_to_player("pod_sprayer_held", 1);
			e_who thread zm_zod_util::function_55f114f9("zmInventory.widget_sprayer", 3.5);
			e_who thread zm_zod_util::show_infotext_for_duration("ZM_ZOD_UI_POD_SPRAYER_PICKUP", 3.5);
			e_who.var_abe77dc0 = 1;
			self.model delete();
			playsoundatposition("zmb_zod_sprayer_pickup", self.origin);
			zm_unitrigger::unregister_unitrigger(self.trigger);
			self.trigger = undefined;
			level flag::set("any_player_has_pod_sprayer");
			break;
		}
		e_who waittill(#"disconnect");
	}
}

/*
	Name: function_5f89f77a
	Namespace: zm_zod_pods
	Checksum: 0x641C8BFA
	Offset: 0x1A18
	Size: 0x13A
	Parameters: 0
	Flags: Linked, Private
*/
private function function_5f89f77a()
{
	self waittill(#"hash_e446a51c");
	self thread function_a7a6257b();
	self thread function_42bd572d();
	if(1)
	{
		for(;;)
		{
			self.trigger waittill(#"trigger", e_who);
			assert(self.var_8486ae6a > 0);
		}
		for(;;)
		{
			e_who thread function_8d53a342(0);
		}
		/#
		#/
		if(isdefined(level.bzm_worldpaused) && level.bzm_worldpaused)
		{
		}
		if(e_who clientfield::get_to_player("pod_sprayer_held") == 0)
		{
		}
		playsoundatposition("zmb_zod_sprayer_use", self.origin);
		e_who thread function_8d53a342(1);
		self function_7e428fa9(e_who);
		return;
	}
}

/*
	Name: function_8d53a342
	Namespace: zm_zod_pods
	Checksum: 0x24C8822E
	Offset: 0x1B60
	Size: 0xAC
	Parameters: 1
	Flags: Linked, Private
*/
private function function_8d53a342(b_success)
{
	self notify(#"hash_8d53a342");
	self endon(#"hash_8d53a342");
	self thread clientfield::set_player_uimodel("zmInventory.player_using_sprayer", b_success);
	self thread clientfield::set_player_uimodel("zmInventory.widget_sprayer", 1);
	wait(2);
	self thread clientfield::set_player_uimodel("zmInventory.widget_sprayer", 0);
	self thread clientfield::set_player_uimodel("zmInventory.player_using_sprayer", 0);
}

/*
	Name: function_ab887f9d
	Namespace: zm_zod_pods
	Checksum: 0x40180597
	Offset: 0x1C18
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function function_ab887f9d()
{
	var_15c80043 = getentarray("fungus_pod_clip", "targetname");
	level.var_6fa2f6ca.var_755232db = array::sort_by_script_int(var_15c80043, 1);
	foreach(var_74a0c36c, e_clip in level.var_6fa2f6ca.var_755232db)
	{
		e_clip thread function_254faf4d();
	}
}

/*
	Name: function_254faf4d
	Namespace: zm_zod_pods
	Checksum: 0x3F503035
	Offset: 0x1D10
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function function_254faf4d()
{
	level endon(#"_zombie_game_over");
	while(true)
	{
		self.origin = self.origin - vectorscale((0, 0, 1), 5000);
		level waittill("pod_" + self.script_int + "_hatched");
		self.origin = self.origin + vectorscale((0, 0, 1), 5000);
		level waittill("pod_" + self.script_int + "_harvested");
	}
}

/*
	Name: function_cb4c560e
	Namespace: zm_zod_pods
	Checksum: 0x7FBA9D4
	Offset: 0x1DB8
	Size: 0x7C
	Parameters: 1
	Flags: Linked, Private
*/
private function function_cb4c560e(var_8486ae6a = undefined)
{
	if(self.var_8486ae6a < 3)
	{
		if(isdefined(var_8486ae6a))
		{
			self.var_8486ae6a = var_8486ae6a;
		}
		else
		{
			self.var_8486ae6a++;
		}
		self.model clientfield::set("update_fungus_pod_level", self.var_8486ae6a);
	}
}

/*
	Name: function_be2abe
	Namespace: zm_zod_pods
	Checksum: 0x1EFD0EFE
	Offset: 0x1E40
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function function_be2abe()
{
	foreach(var_18b8e1, s_pod in level.var_6fa2f6ca.var_5d8c3695)
	{
		s_pod function_cb4c560e(3);
	}
}

/*
	Name: function_a7a6257b
	Namespace: zm_zod_pods
	Checksum: 0x9DDE99F0
	Offset: 0x1EE8
	Size: 0x182
	Parameters: 0
	Flags: Linked, Private
*/
private function function_a7a6257b()
{
	self endon(#"harvested");
	rounds_since_upgrade = 0;
	if(isdefined(self.zone))
	{
		zm_zonemgr::zone_wait_till_enabled(self.zone);
	}
	if(level clientfield::get("bm_superbeast"))
	{
		self function_cb4c560e(3);
	}
	while(true)
	{
		level util::waittill_any("between_round_over", "debug_pod_spawn");
		rounds_since_upgrade++;
		n_upgrade_odds = level.var_6fa2f6ca.upgrade_odds[rounds_since_upgrade];
		if(!isdefined(n_upgrade_odds))
		{
			n_upgrade_odds = 1;
		}
		else if(isdefined(level.debug_pod_spawn_all) && level.debug_pod_spawn_all)
		{
			n_upgrade_odds = 1;
		}
		else if(n_upgrade_odds == 0)
		{
			continue;
		}
		if(randomfloat(1) <= n_upgrade_odds)
		{
			self function_cb4c560e();
			rounds_since_upgrade = 0;
			if(self.var_8486ae6a >= 3)
			{
				return;
			}
		}
	}
}

/*
	Name: function_42bd572d
	Namespace: zm_zod_pods
	Checksum: 0x38BA8A37
	Offset: 0x2078
	Size: 0x188
	Parameters: 0
	Flags: Linked, Private
*/
private function function_42bd572d()
{
	self endon(#"harvested");
	level flag::wait_till("all_players_spawned");
	while(true)
	{
		level waittill(#"kill_round");
		if(self.var_8486ae6a == 3)
		{
			self.model clientfield::increment("pod_harvest");
			wait(0.05);
			zm_unitrigger::unregister_unitrigger(self.trigger);
			arrayremovevalue(level.var_6fa2f6ca.var_5d8c3695, self);
			if(!isdefined(level.var_6fa2f6ca.var_4042b27e))
			{
				level.var_6fa2f6ca.var_4042b27e = [];
			}
			else if(!isarray(level.var_6fa2f6ca.var_4042b27e))
			{
				level.var_6fa2f6ca.var_4042b27e = array(level.var_6fa2f6ca.var_4042b27e);
			}
			level.var_6fa2f6ca.var_4042b27e[level.var_6fa2f6ca.var_4042b27e.size] = self;
			self notify(#"harvested");
			level notify("pod_" + self.script_int + "_harvested");
		}
	}
}

/*
	Name: function_bf70a1ff
	Namespace: zm_zod_pods
	Checksum: 0x1FA4A4A5
	Offset: 0x2208
	Size: 0x260
	Parameters: 0
	Flags: Linked, Private
*/
private function function_bf70a1ff()
{
	level flag::wait_till("start_zombie_round_logic");
	for(i = 0; i < level.var_6fa2f6ca.var_4042b27e.size; i++)
	{
		e_pod = level.var_6fa2f6ca.var_4042b27e[i];
		e_pod.zone = zm_zonemgr::get_zone_from_position(e_pod.origin + vectorscale((0, 0, 1), 20), 1);
		if(!isdefined(e_pod.zone))
		{
			/#
				println("" + zm_zod_util::vec_to_string(e_pod.origin) + "");
			#/
			arrayremovevalue(level.var_6fa2f6ca.var_4042b27e, e_pod);
		}
	}
	n_pods = int(0.4 * level.var_6fa2f6ca.var_4042b27e.size);
	function_d6abde0a(n_pods);
	while(true)
	{
		level util::waittill_any("between_round_over", "debug_pod_spawn");
		if(level.round_number < 4 && !level flag::get("any_player_has_pod_sprayer") && (!(isdefined(level.debug_pod_spawn_all) && level.debug_pod_spawn_all)))
		{
			continue;
		}
		n_pods = randomintrange(3, 6);
		if(isdefined(level.debug_pod_spawn_all) && level.debug_pod_spawn_all)
		{
			n_pods = 1000;
		}
		function_d6abde0a(n_pods);
	}
}

/*
	Name: function_7e428fa9
	Namespace: zm_zod_pods
	Checksum: 0x30955C65
	Offset: 0x2470
	Size: 0xAC2
	Parameters: 1
	Flags: Linked
*/
function function_7e428fa9(e_harvester)
{
	self.model clientfield::increment("pod_harvest");
	e_harvester thread zm_audio::create_and_play_dialog("sprayer", "use");
	wait(0.1);
	self.harvested_in_round = level.round_number;
	zm_unitrigger::unregister_unitrigger(self.trigger);
	self.trigger = undefined;
	self notify(#"harvested", e_harvester);
	var_785a5f87 = self.var_8486ae6a;
	self.var_8486ae6a = 0;
	self.model clientfield::set("update_fungus_pod_level", self.var_8486ae6a);
	wait(getanimlength("p7_fxanim_zm_zod_fungus_pod_stage" + var_785a5f87 + "_death_bundle") - 0.5);
	e_harvester recordmapevent(24, gettime(), self.origin, level.round_number, var_785a5f87);
	level notify("pod_" + self.script_int + "_harvested");
	n_roll = randomint(100);
	n_cumulation = 0;
	var_68a89987 = 0;
	foreach(var_a054d9e0, s_reward in level.var_6fa2f6ca.rewards[var_785a5f87])
	{
		/#
			str_forced = getdvarstring("");
			if(isdefined(str_forced) && str_forced != "")
			{
				s_reward_forced = 1;
				s_reward = level.var_6fa2f6ca.debug_reward_list[str_forced];
				setdvar("", "");
			}
		#/
		if(s_reward.type == "weapon")
		{
			s_reward.do_not_consider = function_b0138b1(s_reward.item);
		}
		if(isdefined(s_reward.do_not_consider) && s_reward.do_not_consider)
		{
			continue;
		}
		n_cumulation = n_cumulation + s_reward.chance;
		if(n_cumulation >= n_roll || (isdefined(s_reward_forced) && s_reward_forced))
		{
			var_68a89987 = 1;
			switch(s_reward.type)
			{
				case "craftable":
				{
					s_reward.do_not_consider = 1;
					normalize_reward_chances();
					playsoundatposition("evt_zod_pod_open_craftable", self.origin);
					drop_point = self.origin + vectorscale((0, 0, 1), 36);
					zm_zod_idgun_quest::special_craftable_spawn(drop_point, "part_skeleton");
					if(level flag::get("part_skeleton" + "_found"))
					{
						break;
					}
					else
					{
						mdl_part = level zm_craftables::get_craftable_piece_model("idgun", "part_skeleton");
						var_55d0f940 = struct::get("safe_place_for_items", "targetname");
						mdl_part.origin = var_55d0f940.origin;
						s_reward.do_not_consider = 0;
						normalize_reward_chances();
					}
					break;
				}
				case "grenade":
				{
					v_spawnpt = self.origin;
					grenade = getweapon("frag_grenade");
					n_rand = randomintrange(0, 4);
					e_harvester magicgrenadetype(grenade, v_spawnpt, vectorscale((0, 0, 1), 300), 3);
					playsoundatposition("evt_zod_pod_open_grenade", self.origin);
					if(n_rand)
					{
						wait(0.3);
						if(math::cointoss())
						{
							e_harvester magicgrenadetype(grenade, v_spawnpt, vectorscale((0, 0, 1), 300), 3);
						}
					}
					break;
				}
				case "parasite":
				{
					if(isdefined(e_harvester))
					{
						array::add(level.a_wasp_priority_targets, e_harvester);
					}
					s_temp = spawnstruct();
					s_temp.origin = self.origin + vectorscale((0, 0, 1), 30);
					var_b20468d0 = zm_ai_wasp::special_wasp_spawn(1, s_temp, 32, 32, 1, 1, 1);
					if(!ispointinnavvolume(var_b20468d0.origin, "navvolume_small"))
					{
						v_nearest_navmesh_point = var_b20468d0 getclosestpointonnavvolume(s_temp.origin, 100);
						if(isdefined(v_nearest_navmesh_point))
						{
							var_b20468d0.origin = v_nearest_navmesh_point;
						}
					}
					break;
				}
				case "powerup":
				{
					str_item = s_reward.item;
					while(!isdefined(str_item) || (str_item === "full_ammo" && var_785a5f87 != 3))
					{
						str_item = zm_powerups::get_valid_powerup();
					}
					if(isdefined(s_reward.count) && str_item == "bonus_points_team")
					{
						level.var_6fa2f6ca.bonus_points_amount = s_reward.count;
					}
					zm_powerups::specific_powerup_drop(str_item, self.origin, undefined, undefined, 1);
					break;
				}
				case "weapon":
				{
					playsoundatposition("evt_zod_pod_open_weapon", self.origin);
					self thread dig_up_weapon(e_harvester, s_reward.item);
					break;
				}
				case "zombie":
				{
					s_temp = spawnstruct();
					s_temp.origin = function_c9466e61(self.origin, 20);
					if(!isdefined(s_temp.origin))
					{
						s_temp.origin = self.origin;
					}
					s_temp.script_noteworthy = "riser_location";
					s_temp.script_string = "find_flesh";
					zombie_utility::spawn_zombie(level.zombie_spawners[0], "aether_zombie", s_temp);
					break;
				}
				case "shield_recharge":
				{
					v_origin = function_c9466e61(self.origin, 20);
					var_7905adb2 = rocketshield::create_bottle_unitrigger(v_origin, (0, 0, 0));
					var_7905adb2 thread function_92f587b4();
					break;
				}
				default:
				{
					break;
				}
			}
			break;
		}
	}
	if(!var_68a89987)
	{
		str_item = zm_powerups::get_valid_powerup();
		zm_powerups::specific_powerup_drop(str_item, self.origin, undefined, undefined, 1);
	}
	arrayremovevalue(level.var_6fa2f6ca.var_5d8c3695, self);
	if(!isdefined(level.var_6fa2f6ca.var_4042b27e))
	{
		level.var_6fa2f6ca.var_4042b27e = [];
	}
	else if(!isarray(level.var_6fa2f6ca.var_4042b27e))
	{
		level.var_6fa2f6ca.var_4042b27e = array(level.var_6fa2f6ca.var_4042b27e);
	}
	level.var_6fa2f6ca.var_4042b27e[level.var_6fa2f6ca.var_4042b27e.size] = self;
}

/*
	Name: function_c9466e61
	Namespace: zm_zod_pods
	Checksum: 0xD0F3167
	Offset: 0x2F40
	Size: 0xA8
	Parameters: 2
	Flags: Linked
*/
function function_c9466e61(v_pos, radius)
{
	v_origin = getclosestpointonnavmesh(v_pos, radius);
	if(!isdefined(v_origin))
	{
		e_player = zm_utility::get_closest_player(v_pos);
		v_origin = getclosestpointonnavmesh(e_player.origin, radius);
	}
	if(!isdefined(v_origin))
	{
		v_origin = v_pos;
	}
	return v_origin;
}

/*
	Name: function_92f587b4
	Namespace: zm_zod_pods
	Checksum: 0x8B5E488D
	Offset: 0x2FF0
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_92f587b4()
{
	self endon(#"bottle_collected");
	wait(15);
	for(i = 0; i < 40; i++)
	{
		if(i % 2)
		{
			self.mdl_shield_recharge ghost();
		}
		else
		{
			self.mdl_shield_recharge show();
		}
		if(i < 15)
		{
			wait(0.5);
			continue;
		}
		if(i < 25)
		{
			wait(0.25);
			continue;
		}
		wait(0.1);
	}
	self.mdl_shield_recharge delete();
	zm_unitrigger::unregister_unitrigger(self);
}

/*
	Name: pod_player_msg
	Namespace: zm_zod_pods
	Checksum: 0xD191EF97
	Offset: 0x30F0
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function pod_player_msg(e_player)
{
	if(e_player clientfield::get_to_player("pod_sprayer_held"))
	{
		return &"ZM_ZOD_POD_HARVEST";
	}
	if(e_player clientfield::get_to_player("pod_sprayer_hint_range") == 0)
	{
		e_player thread function_3f5779c4();
	}
	return &"";
}

/*
	Name: function_3f5779c4
	Namespace: zm_zod_pods
	Checksum: 0x6AFB123
	Offset: 0x3180
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_3f5779c4()
{
	self endon(#"disconnect");
	self clientfield::set_to_player("pod_sprayer_hint_range", 1);
	wait(1);
	self clientfield::set_to_player("pod_sprayer_hint_range", 0);
}

/*
	Name: function_d6abde0a
	Namespace: zm_zod_pods
	Checksum: 0xEFBAE72F
	Offset: 0x31E0
	Size: 0x508
	Parameters: 1
	Flags: Linked
*/
function function_d6abde0a(n_pods)
{
	if(level flag::get("hide_pods_for_trailer"))
	{
		return;
	}
	a_available = [];
	foreach(var_76f759bd, e_pod in level.var_6fa2f6ca.var_4042b27e)
	{
		if(isdefined(e_pod.harvested_in_round))
		{
			n_rounds_since_spawn = level.round_number - e_pod.harvested_in_round;
			if(n_rounds_since_spawn < 2 && (!(isdefined(level.debug_pod_spawn_all) && level.debug_pod_spawn_all)))
			{
				continue;
			}
		}
		var_11fb7a41 = 0;
		a_players = getplayers();
		foreach(var_483bd0a1, player in a_players)
		{
			if(distance(player.origin, e_pod.origin) < 200)
			{
				var_11fb7a41 = 1;
				break;
			}
		}
		if(var_11fb7a41)
		{
			continue;
		}
		if(!isdefined(a_available))
		{
			a_available = [];
		}
		else if(!isarray(a_available))
		{
			a_available = array(a_available);
		}
		a_available[a_available.size] = e_pod;
	}
	a_available = array::randomize(a_available);
	a_spawned_zones = [];
	for(i = 0; i < n_pods && a_available.size > 0; i++)
	{
		n_index = a_available.size - 1;
		s_pod = a_available[n_index];
		if(n_pods <= 5 && isdefined(s_pod.zone) && isdefined(a_spawned_zones[s_pod.zone]))
		{
			continue;
		}
		arrayremovevalue(level.var_6fa2f6ca.var_4042b27e, s_pod);
		arrayremoveindex(a_available, n_index);
		if(!isdefined(level.var_6fa2f6ca.var_5d8c3695))
		{
			level.var_6fa2f6ca.var_5d8c3695 = [];
		}
		else if(!isarray(level.var_6fa2f6ca.var_5d8c3695))
		{
			level.var_6fa2f6ca.var_5d8c3695 = array(level.var_6fa2f6ca.var_5d8c3695);
		}
		level.var_6fa2f6ca.var_5d8c3695[level.var_6fa2f6ca.var_5d8c3695.size] = s_pod;
		s_pod.var_8486ae6a = 1;
		level notify("pod_" + s_pod.script_int + "_hatched");
		s_pod.model clientfield::set("update_fungus_pod_level", s_pod.var_8486ae6a);
		s_pod thread function_e1065706();
		s_pod thread function_5f89f77a();
		if(isdefined(s_pod.zone))
		{
			if(!isdefined(a_spawned_zones[s_pod.zone]))
			{
				a_spawned_zones[s_pod.zone] = 0;
			}
			a_spawned_zones[s_pod.zone]++;
		}
	}
}

/*
	Name: function_e1065706
	Namespace: zm_zod_pods
	Checksum: 0xCBE7DEEC
	Offset: 0x36F0
	Size: 0x82
	Parameters: 0
	Flags: Linked
*/
function function_e1065706()
{
	wait(getanimlength("p7_fxanim_zm_zod_fungus_pod_base_birth_anim"));
	self.trigger = zm_zod_util::spawn_trigger_radius(self.origin + anglestoup(self.angles) * 8, 50, 1, &pod_player_msg);
	self notify(#"hash_e446a51c");
}

/*
	Name: weapon_trigger_update_prompt
	Namespace: zm_zod_pods
	Checksum: 0xB5D1FB0A
	Offset: 0x3780
	Size: 0xE8
	Parameters: 1
	Flags: Linked
*/
function weapon_trigger_update_prompt(player)
{
	if(!zm_utility::is_player_valid(player) || player.is_drinking > 0 || !player zm_magicbox::can_buy_weapon() || player bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		self sethintstring(&"");
		return 0;
	}
	self setcursorhint("HINT_WEAPON", self.stub.wpn);
	self sethintstring(&"ZOMBIE_TRADE_WEAPON_FILL");
	return 1;
}

/*
	Name: function_b0138b1
	Namespace: zm_zod_pods
	Checksum: 0x4AA6DBCC
	Offset: 0x3870
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function function_b0138b1(w_weapon)
{
	var_272e7943 = zm_weapons::get_base_weapon(w_weapon);
	players = getplayers();
	foreach(var_3cfc4ebf, player in players)
	{
		if(!isdefined(player) || !isalive(player))
		{
			continue;
		}
		if(player zm_weapons::has_weapon_or_upgrade(var_272e7943))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: dig_up_weapon
	Namespace: zm_zod_pods
	Checksum: 0x7E0E5B06
	Offset: 0x3988
	Size: 0x250
	Parameters: 2
	Flags: Linked
*/
function dig_up_weapon(e_digger, wpn_to_spawn)
{
	v_spawnpt = self.origin + (0, 0, 40);
	v_spawnang = (0, 0, 0);
	v_angles = e_digger getplayerangles();
	v_angles = (0, v_angles[1], 0) + vectorscale((0, 1, 0), 90) + v_spawnang;
	m_weapon = zm_utility::spawn_buildkit_weapon_model(e_digger, wpn_to_spawn, undefined, v_spawnpt, v_angles);
	m_weapon.angles = v_angles;
	m_weapon thread timer_til_despawn(v_spawnpt, 40 * -1);
	m_weapon endon(#"dig_up_weapon_timed_out");
	m_weapon.trigger = zm_zod_util::spawn_trigger_radius(v_spawnpt, 100, 1);
	m_weapon.trigger.wpn = wpn_to_spawn;
	m_weapon.trigger.prompt_and_visibility_func = &weapon_trigger_update_prompt;
	m_weapon.trigger waittill(#"trigger", player);
	m_weapon.trigger notify(#"weapon_grabbed");
	m_weapon.trigger thread swap_weapon(wpn_to_spawn, player);
	if(isdefined(m_weapon.trigger))
	{
		zm_unitrigger::unregister_unitrigger(m_weapon.trigger);
		m_weapon.trigger = undefined;
	}
	if(isdefined(m_weapon))
	{
		m_weapon delete();
	}
	if(player != e_digger)
	{
		e_digger notify(#"dig_up_weapon_shared");
	}
}

/*
	Name: swap_weapon
	Namespace: zm_zod_pods
	Checksum: 0x6B29BDBA
	Offset: 0x3BE0
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function swap_weapon(wpn_new, e_player)
{
	wpn_current = e_player getcurrentweapon();
	if(!zm_utility::is_player_valid(e_player))
	{
		return;
	}
	if(e_player.is_drinking > 0)
	{
		return;
	}
	if(zm_utility::is_placeable_mine(wpn_current) || zm_equipment::is_equipment(wpn_current) || wpn_current == level.weaponnone)
	{
		return;
	}
	if(!e_player hasweapon(wpn_new.rootweapon, 1))
	{
		e_player take_old_weapon_and_give_new(wpn_current, wpn_new);
	}
	else
	{
		e_player givemaxammo(wpn_new);
	}
}

/*
	Name: take_old_weapon_and_give_new
	Namespace: zm_zod_pods
	Checksum: 0x1F5A90C4
	Offset: 0x3D00
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function take_old_weapon_and_give_new(current_weapon, weapon)
{
	a_weapons = self getweaponslistprimaries();
	if(isdefined(a_weapons) && a_weapons.size >= zm_utility::get_player_weapon_limit(self))
	{
		self takeweapon(current_weapon);
	}
	var_7b9ca68 = self zm_weapons::give_build_kit_weapon(weapon);
	self giveweapon(var_7b9ca68);
	self switchtoweapon(var_7b9ca68);
}

/*
	Name: timer_til_despawn
	Namespace: zm_zod_pods
	Checksum: 0x42F99C7C
	Offset: 0x3DE0
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function timer_til_despawn(v_float, n_dist)
{
	self endon(#"weapon_grabbed");
	putbacktime = 12;
	self movez(n_dist, putbacktime, putbacktime * 0.5);
	self waittill(#"movedone");
	self notify(#"dig_up_weapon_timed_out");
	if(isdefined(self.trigger))
	{
		zm_unitrigger::unregister_unitrigger(self.trigger);
		self.trigger = undefined;
	}
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: function_20affc0e
	Namespace: zm_zod_pods
	Checksum: 0x7821053A
	Offset: 0x3EB0
	Size: 0x12
	Parameters: 0
	Flags: Linked
*/
function function_20affc0e()
{
	return level.var_6fa2f6ca.bonus_points_amount;
}

/*
	Name: normalize_reward_chances
	Namespace: zm_zod_pods
	Checksum: 0xED998E9F
	Offset: 0x3ED0
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function normalize_reward_chances()
{
	for(i = 1; i <= 3; i++)
	{
		n_total = 0;
		foreach(var_7809b946, reward in level.var_6fa2f6ca.rewards[i])
		{
			if(!(isdefined(reward.do_not_consider) && reward.do_not_consider))
			{
				n_total = n_total + float(reward.chance);
			}
		}
		/#
			assert(reward.chance > 0);
		#/
		foreach(var_f96af48, reward in level.var_6fa2f6ca.rewards[i])
		{
			if(!(isdefined(reward.do_not_consider) && reward.do_not_consider))
			{
				reward.chance = reward.chance / n_total * 100;
			}
		}
	}
}

/*
	Name: function_2947f395
	Namespace: zm_zod_pods
	Checksum: 0x4C5A526D
	Offset: 0x40D0
	Size: 0x122
	Parameters: 0
	Flags: Linked
*/
function function_2947f395()
{
	level flag::set("hide_pods_for_trailer");
	foreach(var_44fa544b, pod in level.var_6fa2f6ca.spawned)
	{
		pod.buff = 0;
		pod.var_70ac16f8 = 0;
		zm_unitrigger::unregister_unitrigger(pod.trigger);
		if(isdefined(self.e_fx_origin))
		{
			pod.e_fx_origin delete();
		}
		arrayremovevalue(level.var_6fa2f6ca.spawned, self);
	}
}

/*
	Name: function_3f95af32
	Namespace: zm_zod_pods
	Checksum: 0x993E3BFB
	Offset: 0x4200
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function function_3f95af32()
{
	foreach(var_52fbc17a, player in level.activeplayers)
	{
		player clientfield::set_to_player("pod_sprayer_held", 1);
		player thread zm_zod_util::function_55f114f9("zmInventory.widget_sprayer", 3.5);
		player.var_abe77dc0 = 1;
		level flag::set("any_player_has_pod_sprayer");
	}
}

