// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_island_util;

#namespace zm_island_challenges;

/*
	Name: main
	Namespace: zm_island_challenges
	Checksum: 0xDE5FAAE8
	Offset: 0xC60
	Size: 0x7C4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level flag::init("flag_init_challenge_pillars");
	level thread init_challenge_pillars();
	if(getdvarint("splitscreen_playerCount") > 2)
	{
		array::run_all(getentarray("t_lookat_challenge_1", "targetname"), &delete);
		array::run_all(getentarray("t_lookat_challenge_2", "targetname"), &delete);
		array::run_all(getentarray("t_lookat_challenge_3", "targetname"), &delete);
		array::thread_all(struct::get_array("s_challenge_trigger"), &struct::delete);
		struct::get("s_challenge_altar") struct::delete();
	}
	else
	{
		level._challenges = spawnstruct();
		level._challenges.challenge_1 = [];
		level._challenges.challenge_2 = [];
		level._challenges.challenge_3 = [];
		array::add(level._challenges.challenge_1, init_challenges(1, &"ZM_ISLAND_CHALLENGE_1_1", 1, "update_challenge_1_1", undefined));
		array::add(level._challenges.challenge_1, init_challenges(1, &"ZM_ISLAND_CHALLENGE_1_2", 1, "update_challenge_1_2", undefined));
		array::add(level._challenges.challenge_1, init_challenges(1, &"ZM_ISLAND_CHALLENGE_1_3", 5, "update_challenge_1_3", undefined));
		array::add(level._challenges.challenge_1, init_challenges(1, &"ZM_ISLAND_CHALLENGE_1_4", 5, "update_challenge_1_4", undefined));
		array::add(level._challenges.challenge_1, init_challenges(1, &"ZM_ISLAND_CHALLENGE_1_5", 5, "update_challenge_1_5", &function_2dbc7cd3));
		array::add(level._challenges.challenge_2, init_challenges(2, &"ZM_ISLAND_CHALLENGE_2_1", 1, "update_challenge_2_1", undefined));
		array::add(level._challenges.challenge_2, init_challenges(2, &"ZM_ISLAND_CHALLENGE_2_2", 1, "update_challenge_2_2", &function_25c1bab7));
		array::add(level._challenges.challenge_2, init_challenges(2, &"ZM_ISLAND_CHALLENGE_2_3", 15, "update_challenge_2_3", undefined));
		array::add(level._challenges.challenge_2, init_challenges(2, &"ZM_ISLAND_CHALLENGE_2_4", 10, "update_challenge_2_4", undefined));
		array::add(level._challenges.challenge_2, init_challenges(2, &"ZM_ISLAND_CHALLENGE_2_5", 20, "update_challenge_2_5", undefined));
		array::add(level._challenges.challenge_2, init_challenges(2, &"ZM_ISLAND_CHALLENGE_2_6", 20, "update_challenge_2_6", undefined));
		array::add(level._challenges.challenge_3, init_challenges(3, &"ZM_ISLAND_CHALLENGE_3_1", 8, "update_challenge_3_1", undefined));
		array::add(level._challenges.challenge_3, init_challenges(3, &"ZM_ISLAND_CHALLENGE_3_2", 3, "update_challenge_3_2", undefined));
		array::add(level._challenges.challenge_3, init_challenges(3, &"ZM_ISLAND_CHALLENGE_3_3", 1, "update_challenge_3_3", &function_5a96677a));
		array::add(level._challenges.challenge_3, init_challenges(3, &"ZM_ISLAND_CHALLENGE_3_4", 30, "update_challenge_3_4", undefined));
		array::add(level._challenges.challenge_3, init_challenges(3, &"ZM_ISLAND_CHALLENGE_3_5", 5, "update_challenge_3_5", &function_26c58398));
		zm_spawner::register_zombie_death_event_callback(&function_905d9544);
		zm_spawner::register_zombie_death_event_callback(&function_682e6fc4);
		zm_spawner::register_zombie_death_event_callback(&function_5a2a9ef9);
		zm_spawner::register_zombie_death_event_callback(&function_fe94c179);
		level thread all_challenges_completed();
		level flag::set("flag_init_player_challenges");
		/#
			function_b9b4ce34();
		#/
	}
}

/*
	Name: init_challenges
	Namespace: zm_island_challenges
	Checksum: 0x7143945B
	Offset: 0x1430
	Size: 0xB0
	Parameters: 5
	Flags: Linked
*/
function init_challenges(n_challenge_index, str_challenge_info, var_80792f67, str_challenge_notify, var_d675d6d8)
{
	s_challenge = spawnstruct();
	s_challenge.n_index = n_challenge_index;
	s_challenge.str_info = str_challenge_info;
	s_challenge.n_count = var_80792f67;
	s_challenge.str_notify = str_challenge_notify;
	s_challenge.func_think = var_d675d6d8;
	return s_challenge;
}

/*
	Name: on_player_connect
	Namespace: zm_island_challenges
	Checksum: 0x517793A4
	Offset: 0x14E8
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	level flag::wait_till("flag_init_player_challenges");
	var_a879fa43 = self getentitynumber();
	self.var_8575e180 = 0;
	self.var_26f3bd30 = 0;
	self.var_301c71e9 = 0;
	self._challenges = spawnstruct();
	self._challenges.challenge_1 = [];
	self._challenges.challenge_2 = [];
	self._challenges.challenge_3 = [];
	self._challenges.challenge_1 = array::random(level._challenges.challenge_1);
	self._challenges.challenge_2 = array::random(level._challenges.challenge_2);
	self._challenges.challenge_3 = array::random(level._challenges.challenge_3);
	arrayremovevalue(level._challenges.challenge_1, self._challenges.challenge_1);
	arrayremovevalue(level._challenges.challenge_2, self._challenges.challenge_2);
	arrayremovevalue(level._challenges.challenge_3, self._challenges.challenge_3);
	self thread function_b7156b15(var_a879fa43);
}

/*
	Name: init_challenge_pillars
	Namespace: zm_island_challenges
	Checksum: 0x9392B838
	Offset: 0x16F0
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function init_challenge_pillars()
{
	level flag::wait_till("start_zombie_round_logic");
	for(i = 1; i < 4; i++)
	{
		level clientfield::set("pillar_challenge_0_" + i, 1);
		level clientfield::set("pillar_challenge_1_" + i, 1);
		level clientfield::set("pillar_challenge_2_" + i, 1);
		level clientfield::set("pillar_challenge_3_" + i, 1);
		wait(0.5);
	}
	level flag::set("flag_init_challenge_pillars");
}

/*
	Name: on_player_disconnect
	Namespace: zm_island_challenges
	Checksum: 0x351F311F
	Offset: 0x1810
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function on_player_disconnect()
{
	level flag::wait_till("flag_init_player_challenges");
	var_a879fa43 = self getentitynumber();
	for(i = 1; i < 4; i++)
	{
		level clientfield::set((("pillar_challenge_" + var_a879fa43) + "_") + i, 1);
	}
	array::add(level._challenges.challenge_1, self._challenges.challenge_1);
	array::add(level._challenges.challenge_2, self._challenges.challenge_2);
	array::add(level._challenges.challenge_3, self._challenges.challenge_3);
}

/*
	Name: function_b7156b15
	Namespace: zm_island_challenges
	Checksum: 0x95212E28
	Offset: 0x1950
	Size: 0x502
	Parameters: 1
	Flags: Linked
*/
function function_b7156b15(var_a879fa43)
{
	self endon(#"disconnect");
	self flag::init("flag_player_collected_reward_1");
	self flag::init("flag_player_collected_reward_2");
	self flag::init("flag_player_collected_reward_3");
	self flag::init("flag_player_completed_challenge_1");
	self flag::init("flag_player_completed_challenge_2");
	self flag::init("flag_player_completed_challenge_3");
	self thread function_2ce855f3(self._challenges.challenge_1.n_index, self._challenges.challenge_1.func_think, self._challenges.challenge_1.n_count, self._challenges.challenge_1.str_notify);
	self thread function_2ce855f3(self._challenges.challenge_2.n_index, self._challenges.challenge_2.func_think, self._challenges.challenge_2.n_count, self._challenges.challenge_2.str_notify);
	self thread function_2ce855f3(self._challenges.challenge_3.n_index, self._challenges.challenge_3.func_think, self._challenges.challenge_3.n_count, self._challenges.challenge_3.str_notify);
	self thread function_fbbc8608(self._challenges.challenge_1.n_index, "flag_player_completed_challenge_1");
	self thread function_fbbc8608(self._challenges.challenge_2.n_index, "flag_player_completed_challenge_2");
	self thread function_fbbc8608(self._challenges.challenge_3.n_index, "flag_player_completed_challenge_3");
	self thread function_974d5f1d();
	var_8e2d9e6f = [];
	var_e01fcddc = [];
	for(i = 1; i < 4; i++)
	{
		foreach(t_lookat in getentarray("t_lookat_challenge_" + i, "targetname"))
		{
			if(t_lookat.script_special == var_a879fa43)
			{
				var_e01fcddc[i] = t_lookat;
			}
		}
		var_8e2d9e6f[i] = i;
		self thread function_7fc84e9c(var_a879fa43, var_8e2d9e6f[i]);
		self thread function_e43d4636(var_a879fa43, var_8e2d9e6f[i]);
	}
	foreach(s_challenge in struct::get_array("s_challenge_trigger"))
	{
		if(s_challenge.script_special == var_a879fa43)
		{
			s_challenge function_72a5d5e5(var_a879fa43, var_8e2d9e6f, var_e01fcddc);
		}
	}
}

/*
	Name: function_72a5d5e5
	Namespace: zm_island_challenges
	Checksum: 0xC7BC69EA
	Offset: 0x1E60
	Size: 0x154
	Parameters: 3
	Flags: Linked
*/
function function_72a5d5e5(var_a879fa43, var_8e2d9e6f, var_e01fcddc)
{
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = self.origin;
	unitrigger_stub.angles = self.angles;
	unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	unitrigger_stub.radius = 128;
	unitrigger_stub.require_look_at = 0;
	unitrigger_stub.inactive_reassess_time = 0.5;
	unitrigger_stub.var_a879fa43 = var_a879fa43;
	unitrigger_stub.var_8e2d9e6f = var_8e2d9e6f;
	unitrigger_stub.var_e01fcddc = var_e01fcddc;
	zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, 1);
	unitrigger_stub.prompt_and_visibility_func = &function_3ae0d6d5;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &function_a00e23d0);
}

/*
	Name: function_fbbc8608
	Namespace: zm_island_challenges
	Checksum: 0x29C71DA6
	Offset: 0x1FC0
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function function_fbbc8608(n_challenge_index, var_d4adfa57)
{
	self endon(#"disconnect");
	self flag::wait_till(var_d4adfa57);
	var_d6b47fd3 = "";
	if(n_challenge_index == 1)
	{
		var_d6b47fd3 = self._challenges.challenge_1.str_info;
	}
	else
	{
		if(n_challenge_index == 2)
		{
			var_d6b47fd3 = self._challenges.challenge_2.str_info;
		}
		else
		{
			var_d6b47fd3 = self._challenges.challenge_3.str_info;
		}
	}
	self luinotifyevent(&"trial_complete", 2, &"ZM_ISLAND_TRIAL_COMPLETE", var_d6b47fd3);
}

/*
	Name: function_e8547a5b
	Namespace: zm_island_challenges
	Checksum: 0xA93D5E88
	Offset: 0x20C0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_e8547a5b(var_cc0f18cc)
{
	if(self.challenge_text !== var_cc0f18cc)
	{
		self.challenge_text = var_cc0f18cc;
		self luinotifyevent(&"trial_set_description", 1, self.challenge_text);
	}
}

/*
	Name: function_27f6c3cd
	Namespace: zm_island_challenges
	Checksum: 0x45C0E2A3
	Offset: 0x2120
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function function_27f6c3cd(player, n_challenge_index)
{
	if(self.stub.var_8e2d9e6f[n_challenge_index] == 1)
	{
		player function_e8547a5b(player._challenges.challenge_1.str_info);
	}
	else
	{
		if(self.stub.var_8e2d9e6f[n_challenge_index] == 2)
		{
			player function_e8547a5b(player._challenges.challenge_2.str_info);
		}
		else
		{
			player function_e8547a5b(player._challenges.challenge_3.str_info);
		}
	}
}

/*
	Name: function_23c9ffd3
	Namespace: zm_island_challenges
	Checksum: 0x7CA5A195
	Offset: 0x2220
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_23c9ffd3(player)
{
	self notify(#"hash_23c9ffd3");
	self endon(#"hash_23c9ffd3");
	while(true)
	{
		wait(0.5);
		if(!isdefined(player))
		{
			break;
		}
		if(!isdefined(self) || distance(player.origin, self.stub.origin) > 500)
		{
			player clientfield::set_player_uimodel("trialWidget.visible", 0);
			break;
		}
	}
}

/*
	Name: function_3ae0d6d5
	Namespace: zm_island_challenges
	Checksum: 0x9D06FE05
	Offset: 0x22D8
	Size: 0x408
	Parameters: 1
	Flags: Linked
*/
function function_3ae0d6d5(player)
{
	if(player getentitynumber() == self.stub.var_a879fa43)
	{
		var_a51a0ba6 = 0;
		for(i = 1; i < 4; i++)
		{
			if(player function_3f67a723(self.stub.var_e01fcddc[i].origin, 20, 0) && distance(player.origin, self.stub.origin) < 500)
			{
				self function_27f6c3cd(player, i);
				player clientfield::set_player_uimodel("trialWidget.visible", 1);
				player clientfield::set_player_uimodel("trialWidget.progress", player.var_873a3e27[self.stub.var_8e2d9e6f[i]]);
				if(!player flag::get("flag_player_completed_challenge_" + self.stub.var_8e2d9e6f[i]))
				{
					self sethintstringforplayer(player, "");
					var_a51a0ba6 = 1;
					self thread function_23c9ffd3(player);
					return true;
				}
				if(!player flag::get("flag_player_collected_reward_" + self.stub.var_8e2d9e6f[i]) && !level flag::get("flag_player_initialized_reward"))
				{
					self sethintstringforplayer(player, &"ZM_ISLAND_CHALLENGE_REWARD");
					var_a51a0ba6 = 1;
					self thread function_23c9ffd3(player);
					return true;
				}
				if(!player flag::get("flag_player_collected_reward_" + self.stub.var_8e2d9e6f[i]) && level flag::get("flag_player_initialized_reward"))
				{
					self sethintstringforplayer(player, &"ZM_ISLAND_CHALLENGE_ALTAR_IN_USE");
					var_a51a0ba6 = 1;
					self thread function_23c9ffd3(player);
					return true;
				}
				self sethintstringforplayer(player, "");
				var_a51a0ba6 = 1;
				self thread function_23c9ffd3(player);
				return true;
			}
		}
		if(!var_a51a0ba6)
		{
			self sethintstringforplayer(player, "");
			player clientfield::set_player_uimodel("trialWidget.visible", 0);
			return false;
		}
	}
	else
	{
		self sethintstringforplayer(player, "");
		player clientfield::set_player_uimodel("trialWidget.visible", 0);
		return false;
	}
}

/*
	Name: function_3f67a723
	Namespace: zm_island_challenges
	Checksum: 0x308BE38B
	Offset: 0x26E8
	Size: 0xB2
	Parameters: 4
	Flags: Linked
*/
function function_3f67a723(origin, arc_angle_degrees = 90, do_trace, e_ignore)
{
	arc_angle_degrees = absangleclamp360(arc_angle_degrees);
	dot = cos(arc_angle_degrees * 0.5);
	if(self util::is_player_looking_at(origin, dot, do_trace, e_ignore))
	{
		return true;
	}
	return false;
}

/*
	Name: function_a00e23d0
	Namespace: zm_island_challenges
	Checksum: 0x7C77AEEA
	Offset: 0x27A8
	Size: 0x1D8
	Parameters: 0
	Flags: Linked
*/
function function_a00e23d0()
{
	self endon(#"kill_trigger");
	while(true)
	{
		self waittill(#"trigger", e_who);
		if(e_who getentitynumber() == self.stub.var_a879fa43)
		{
			for(i = 1; i < 4; i++)
			{
				if(e_who function_3f67a723(self.stub.var_e01fcddc[i].origin, 20, 0) && distance(e_who.origin, self.stub.origin) < 500)
				{
					if(e_who flag::get("flag_player_completed_challenge_" + self.stub.var_8e2d9e6f[i]) && !e_who flag::get("flag_player_collected_reward_" + self.stub.var_8e2d9e6f[i]) && !level flag::get("flag_player_initialized_reward"))
					{
						e_who thread function_8675d6ed(self.stub.var_8e2d9e6f[i]);
					}
				}
			}
			self sethintstringforplayer(e_who, "");
		}
	}
}

/*
	Name: function_7fc84e9c
	Namespace: zm_island_challenges
	Checksum: 0x6040925C
	Offset: 0x2988
	Size: 0xEC
	Parameters: 2
	Flags: Linked
*/
function function_7fc84e9c(var_a879fa43, n_challenge)
{
	self endon(#"disconnect");
	self flag::wait_till("flag_player_completed_challenge_" + n_challenge);
	switch(var_a879fa43)
	{
		case 0:
		{
			str_exploder = "fxexp_820";
			break;
		}
		case 1:
		{
			str_exploder = "fxexp_821";
			break;
		}
		case 2:
		{
			str_exploder = "fxexp_822";
			break;
		}
		case 3:
		{
			str_exploder = "fxexp_823";
			break;
		}
	}
	exploder::exploder(str_exploder);
	wait(1);
	exploder::stop_exploder(str_exploder);
}

/*
	Name: function_e43d4636
	Namespace: zm_island_challenges
	Checksum: 0x52CD298A
	Offset: 0x2A80
	Size: 0x124
	Parameters: 2
	Flags: Linked
*/
function function_e43d4636(var_a879fa43, n_challenge)
{
	self endon(#"disconnect");
	level flag::wait_till("flag_init_challenge_pillars");
	level clientfield::set((("pillar_challenge_" + var_a879fa43) + "_") + n_challenge, 2);
	self flag::wait_till("flag_player_completed_challenge_" + n_challenge);
	level clientfield::set((("pillar_challenge_" + var_a879fa43) + "_") + n_challenge, 3);
	self flag::wait_till("flag_player_collected_reward_" + n_challenge);
	level clientfield::set((("pillar_challenge_" + var_a879fa43) + "_") + n_challenge, 4);
}

/*
	Name: function_8675d6ed
	Namespace: zm_island_challenges
	Checksum: 0x3FB05F9A
	Offset: 0x2BB0
	Size: 0x434
	Parameters: 1
	Flags: Linked
*/
function function_8675d6ed(n_challenge)
{
	self endon(#"disconnect");
	var_a879fa43 = self getentitynumber();
	var_81d71db = [];
	s_altar = struct::get("s_challenge_altar");
	if(n_challenge == 1)
	{
		var_c9d33fc4 = "p7_zm_power_up_max_ammo";
	}
	else
	{
		if(n_challenge == 2)
		{
			array::add(var_81d71db, "wpn_t7_lmg_dingo_world");
			array::add(var_81d71db, "wpn_t7_shotty_gator_world");
			array::add(var_81d71db, "wpn_t7_sniper_svg100_world");
			var_c9d33fc4 = array::random(var_81d71db);
		}
		else
		{
			var_c9d33fc4 = "zombie_pickup_perk_bottle";
		}
	}
	level flag::set("flag_player_initialized_reward");
	var_a6a1ecf9 = getent("altar_lid", "targetname");
	self function_d655a4ce(var_a6a1ecf9);
	self thread function_26abcbe0();
	self thread function_994b4784(var_a6a1ecf9);
	if(n_challenge == 2)
	{
		v_spawnpt = s_altar.origin + (0, 8, 30);
	}
	else
	{
		v_spawnpt = s_altar.origin + (0, 0, 30);
	}
	var_30ff0d6c = function_5e39bbbe(var_c9d33fc4, v_spawnpt, s_altar.angles);
	self thread function_6168d051(var_30ff0d6c);
	if(n_challenge == 1)
	{
		var_30ff0d6c clientfield::set("challenge_glow_fx", 1);
	}
	else if(n_challenge == 3)
	{
		var_30ff0d6c clientfield::set("challenge_glow_fx", 2);
	}
	var_30ff0d6c thread timer_til_despawn(self, n_challenge, v_spawnpt, 30 * -1);
	self thread function_5c44a258(var_30ff0d6c);
	var_30ff0d6c endon(#"hash_59e0fa55");
	var_30ff0d6c.trigger = s_altar function_be89930d(var_a879fa43, n_challenge);
	var_30ff0d6c.trigger waittill(#"trigger", e_who);
	if(e_who == self)
	{
		self playsoundtoplayer("zmb_trial_unlock_reward", self);
		var_30ff0d6c.trigger notify(#"reward_grabbed");
		self player_give_reward(n_challenge, s_altar, var_c9d33fc4);
		if(isdefined(var_30ff0d6c.trigger))
		{
			zm_unitrigger::unregister_unitrigger(var_30ff0d6c.trigger);
			var_30ff0d6c.trigger = undefined;
		}
		if(isdefined(var_30ff0d6c))
		{
			var_30ff0d6c delete();
		}
	}
}

/*
	Name: function_5e39bbbe
	Namespace: zm_island_challenges
	Checksum: 0xB05B46DA
	Offset: 0x2FF0
	Size: 0x5C
	Parameters: 3
	Flags: Linked
*/
function function_5e39bbbe(var_c9d33fc4, v_origin, v_angles)
{
	var_30ff0d6c = util::spawn_model(var_c9d33fc4, v_origin, v_angles + vectorscale((0, 1, 0), 90));
	return var_30ff0d6c;
}

/*
	Name: timer_til_despawn
	Namespace: zm_island_challenges
	Checksum: 0xF7574D9F
	Offset: 0x3058
	Size: 0xE4
	Parameters: 4
	Flags: Linked
*/
function timer_til_despawn(player, n_challenge, v_float, n_dist)
{
	player endon(#"disconnect");
	self endon(#"reward_grabbed");
	self movez(n_dist, 12, 6);
	self waittill(#"movedone");
	self notify(#"hash_59e0fa55");
	level flag::clear("flag_player_initialized_reward");
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
	Name: function_5c44a258
	Namespace: zm_island_challenges
	Checksum: 0xCA07DE39
	Offset: 0x3148
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_5c44a258(var_30ff0d6c)
{
	self endon(#"hash_994b4784");
	self waittill(#"disconnect");
	level flag::clear("flag_player_initialized_reward");
	var_30ff0d6c delete();
}

/*
	Name: player_give_reward
	Namespace: zm_island_challenges
	Checksum: 0x327BEB88
	Offset: 0x31B0
	Size: 0x17A
	Parameters: 3
	Flags: Linked
*/
function player_give_reward(n_challenge, s_altar, var_c9d33fc4)
{
	if(n_challenge == 1)
	{
		level thread zm_powerups::specific_powerup_drop("full_ammo", self.origin);
	}
	else
	{
		if(n_challenge == 2)
		{
			if(var_c9d33fc4 == "wpn_t7_lmg_dingo_world")
			{
				e_weapon = getweapon("lmg_cqb");
			}
			else
			{
				if(var_c9d33fc4 == "wpn_t7_shotty_gator_world")
				{
					e_weapon = getweapon("shotgun_semiauto");
				}
				else
				{
					e_weapon = getweapon("sniper_powerbolt");
				}
			}
			self thread zm_island_util::swap_weapon(e_weapon);
		}
		else
		{
			level thread zm_powerups::specific_powerup_drop("empty_perk", self.origin);
		}
	}
	self flag::set("flag_player_collected_reward_" + n_challenge);
	level flag::clear("flag_player_initialized_reward");
	self notify(#"reward_grabbed");
}

/*
	Name: function_be89930d
	Namespace: zm_island_challenges
	Checksum: 0x288312AB
	Offset: 0x3338
	Size: 0x128
	Parameters: 2
	Flags: Linked
*/
function function_be89930d(var_a879fa43, n_challenge)
{
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = self.origin;
	unitrigger_stub.angles = self.angles;
	unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	unitrigger_stub.radius = 128;
	unitrigger_stub.require_look_at = 0;
	unitrigger_stub.var_a879fa43 = var_a879fa43;
	unitrigger_stub.n_challenge = n_challenge;
	zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, 1);
	unitrigger_stub.prompt_and_visibility_func = &function_6d42affc;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &function_1e314338);
	return unitrigger_stub;
}

/*
	Name: function_6d42affc
	Namespace: zm_island_challenges
	Checksum: 0x95C70A78
	Offset: 0x3468
	Size: 0x146
	Parameters: 1
	Flags: Linked
*/
function function_6d42affc(player)
{
	w_current = player getcurrentweapon();
	if(zm_utility::is_placeable_mine(w_current) || zm_equipment::is_equipment(w_current) || w_current == level.weaponnone || w_current.isheroweapon == 1 && self.stub.n_challenge == 2)
	{
		self sethintstringforplayer(player, "");
		return false;
	}
	if(player getentitynumber() == self.stub.var_a879fa43)
	{
		self sethintstringforplayer(player, &"ZM_ISLAND_CHALLENGE_REWARD");
		return true;
	}
	self sethintstringforplayer(player, "");
	return false;
}

/*
	Name: function_1e314338
	Namespace: zm_island_challenges
	Checksum: 0x831DF3C9
	Offset: 0x35B8
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_1e314338()
{
	self endon(#"kill_trigger");
	while(true)
	{
		self waittill(#"trigger", player);
		w_current = player getcurrentweapon();
		if(zm_utility::is_placeable_mine(w_current) || zm_equipment::is_equipment(w_current) || w_current == level.weaponnone || w_current.isheroweapon == 1 && self.stub.n_challenge == 2)
		{
			continue;
		}
		if(player bgb::is_enabled("zm_bgb_disorderly_combat"))
		{
			continue;
		}
		self.stub notify(#"trigger", player);
	}
}

/*
	Name: function_d655a4ce
	Namespace: zm_island_challenges
	Checksum: 0x3952F4EA
	Offset: 0x36C8
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_d655a4ce(var_a6a1ecf9)
{
	self endon(#"hash_994b4784");
	level.var_2371bbc = self;
	var_a6a1ecf9 setignorepauseworld(1);
	var_a6a1ecf9 playsound("zmb_challenge_altar_open");
	var_a6a1ecf9 scene::play("p7_fxanim_zm_island_altar_skull_lid_rise_bundle", var_a6a1ecf9);
	var_a6a1ecf9 thread scene::play("p7_fxanim_zm_island_altar_skull_lid_idle_bundle", var_a6a1ecf9);
}

/*
	Name: function_994b4784
	Namespace: zm_island_challenges
	Checksum: 0xA5108A9B
	Offset: 0x3770
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function function_994b4784(var_a6a1ecf9)
{
	self waittill(#"hash_994b4784");
	var_a6a1ecf9 playsound("zmb_challenge_altar_close");
	var_a6a1ecf9 scene::play("p7_fxanim_zm_island_altar_skull_lid_fall_bundle", var_a6a1ecf9);
	level.var_2371bbc = undefined;
}

/*
	Name: function_26abcbe0
	Namespace: zm_island_challenges
	Checksum: 0xA88DAAF3
	Offset: 0x37D8
	Size: 0x4A
	Parameters: 0
	Flags: Linked
*/
function function_26abcbe0()
{
	self endon(#"hash_994b4784");
	self util::waittill_any("disconnect", "death", "reward_grabbed");
	self notify(#"hash_994b4784");
}

/*
	Name: function_6168d051
	Namespace: zm_island_challenges
	Checksum: 0x3773CDE1
	Offset: 0x3830
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function function_6168d051(var_30ff0d6c)
{
	self endon(#"hash_994b4784");
	var_30ff0d6c waittill(#"hash_59e0fa55");
	self notify(#"hash_994b4784");
}

/*
	Name: function_2dbc7cd3
	Namespace: zm_island_challenges
	Checksum: 0xED969996
	Offset: 0x3870
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function function_2dbc7cd3()
{
	self endon(#"disconnect");
	while(!self flag::get("flag_player_completed_challenge_1"))
	{
		self waittill(#"hash_7ae66b0a");
		self notify(#"update_challenge_1_5");
	}
}

/*
	Name: function_fe94c179
	Namespace: zm_island_challenges
	Checksum: 0xA5C45D7E
	Offset: 0x38C8
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function function_fe94c179(e_attacker)
{
	if(isplayer(e_attacker) && (isdefined(self.var_61f7b3a0) && self.var_61f7b3a0) && (!(isdefined(self.thrasherhasturnedberserk) && self.thrasherhasturnedberserk)))
	{
		e_attacker notify(#"update_challenge_2_1");
	}
}

/*
	Name: function_25c1bab7
	Namespace: zm_island_challenges
	Checksum: 0xDCFEF272
	Offset: 0x3938
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function function_25c1bab7()
{
	self endon(#"disconnect");
	while(!self flag::get("flag_player_completed_challenge_2"))
	{
		self waittill(#"hash_61bbe625");
		self notify(#"update_challenge_2_2");
	}
}

/*
	Name: function_5a2a9ef9
	Namespace: zm_island_challenges
	Checksum: 0x51934EDA
	Offset: 0x3990
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function function_5a2a9ef9(e_attacker)
{
	if(isplayer(e_attacker) && self.archetype === "zombie" && isdefined(self.attackable))
	{
		if(self.attackable.scriptbundlename == "zm_island_trap_plant_attackable" || self.attackable.scriptbundlename == "zm_island_trap_plant_upgraded_attackable")
		{
			e_attacker notify(#"update_challenge_2_3");
		}
	}
}

/*
	Name: function_682e6fc4
	Namespace: zm_island_challenges
	Checksum: 0xBCD966C3
	Offset: 0x3A28
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function function_682e6fc4(e_attacker)
{
	if(isplayer(e_attacker) && self.archetype === "zombie" && (isdefined(self.var_34d00e7) && self.var_34d00e7))
	{
		e_attacker notify(#"update_challenge_3_2");
	}
}

/*
	Name: function_5a96677a
	Namespace: zm_island_challenges
	Checksum: 0x5249729A
	Offset: 0x3A90
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function function_5a96677a()
{
	self endon(#"disconnect");
	while(!self flag::get("flag_player_completed_challenge_3"))
	{
		self waittill(#"hash_3e1e1a8");
		self notify(#"update_challenge_3_3");
	}
}

/*
	Name: function_905d9544
	Namespace: zm_island_challenges
	Checksum: 0xF23F8C6C
	Offset: 0x3AE8
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function function_905d9544(e_attacker)
{
	if(isplayer(e_attacker))
	{
		if(!e_attacker flag::get("flag_player_completed_challenge_2") && self.archetype === "zombie" && (isdefined(self.var_d07c64b6) && self.var_d07c64b6))
		{
			if(isdefined(self.damagelocation) && self.damagelocation == "head" || self.damagelocation == "helmet")
			{
				e_attacker notify(#"update_challenge_2_4");
			}
		}
		if(!e_attacker flag::get("flag_player_completed_challenge_2") && self.archetype === "zombie" && e_attacker isplayerunderwater())
		{
			e_attacker notify(#"update_challenge_2_5");
		}
	}
}

/*
	Name: function_26c58398
	Namespace: zm_island_challenges
	Checksum: 0x7A180273
	Offset: 0x3C08
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function function_26c58398()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"destroyed_thrasher_head");
		self notify(#"update_challenge_3_5");
	}
}

/*
	Name: function_2ce855f3
	Namespace: zm_island_challenges
	Checksum: 0xD08C76C7
	Offset: 0x3C48
	Size: 0xF4
	Parameters: 4
	Flags: Linked
*/
function function_2ce855f3(n_challenge_index, var_d675d6d8, var_80792f67, str_challenge_notify)
{
	self endon(#"disconnect");
	/#
		self endon(#"hash_1e547c60");
	#/
	if(isdefined(var_d675d6d8))
	{
		self thread [[var_d675d6d8]]();
	}
	if(!isdefined(self.var_873a3e27))
	{
		self.var_873a3e27 = [];
	}
	self.var_873a3e27[n_challenge_index] = 0;
	var_ea184c3d = var_80792f67;
	while(var_80792f67 > 0)
	{
		self waittill(str_challenge_notify);
		var_80792f67--;
		self.var_873a3e27[n_challenge_index] = 1 - (var_80792f67 / var_ea184c3d);
	}
	self flag::set("flag_player_completed_challenge_" + n_challenge_index);
}

/*
	Name: function_974d5f1d
	Namespace: zm_island_challenges
	Checksum: 0xAAF14CE6
	Offset: 0x3D48
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function function_974d5f1d()
{
	self endon(#"disconnect");
	a_flags = array("flag_player_completed_challenge_1", "flag_player_completed_challenge_2", "flag_player_completed_challenge_3");
	self flag::wait_till_all(a_flags);
	level notify(#"hash_41370469");
}

/*
	Name: all_challenges_completed
	Namespace: zm_island_challenges
	Checksum: 0xA05DB97B
	Offset: 0x3DC0
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function all_challenges_completed()
{
	level.var_c28313cd = 0;
	callback::on_disconnect(&function_b1cd865a);
	while(true)
	{
		level waittill(#"hash_41370469");
		level.var_c28313cd++;
		if(level.var_c28313cd >= level.players.size)
		{
			level flag::set("all_challenges_completed");
			level thread function_397b26ee();
			break;
		}
	}
}

/*
	Name: function_b1cd865a
	Namespace: zm_island_challenges
	Checksum: 0x4B9E50D3
	Offset: 0x3E70
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_b1cd865a()
{
	if(level.var_c28313cd >= level.players.size)
	{
		level flag::set("all_challenges_completed");
	}
}

/*
	Name: function_397b26ee
	Namespace: zm_island_challenges
	Checksum: 0xC341F37F
	Offset: 0x3EB0
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function function_397b26ee()
{
	var_45a970ad = [];
	array::add(var_45a970ad, "fxexp_820");
	array::add(var_45a970ad, "fxexp_821");
	array::add(var_45a970ad, "fxexp_822");
	array::add(var_45a970ad, "fxexp_823");
	wait(1.5);
	while(var_45a970ad.size > 0)
	{
		var_c490d0cd = array::random(var_45a970ad);
		exploder::exploder(var_c490d0cd);
		arrayremovevalue(var_45a970ad, var_c490d0cd);
		wait(randomfloatrange(0.5, 1.5));
	}
	wait(5);
	exploder::stop_exploder("fxexp_820");
	exploder::stop_exploder("fxexp_821");
	exploder::stop_exploder("fxexp_822");
	exploder::stop_exploder("fxexp_823");
	var_45a970ad = undefined;
}

/*
	Name: function_b9b4ce34
	Namespace: zm_island_challenges
	Checksum: 0xEEE47FD2
	Offset: 0x4048
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_b9b4ce34()
{
	/#
		zm_devgui::add_custom_devgui_callback(&challenges_devgui_callback);
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
	#/
}

/*
	Name: challenges_devgui_callback
	Namespace: zm_island_challenges
	Checksum: 0x49E60582
	Offset: 0x40F8
	Size: 0x6E8
	Parameters: 1
	Flags: Linked
*/
function challenges_devgui_callback(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				level flag::set("");
				return true;
			}
			case "":
			{
				foreach(player in level.players)
				{
					player flag::set("");
					player.var_873a3e27[1] = 1;
				}
				return true;
			}
			case "":
			{
				foreach(player in level.players)
				{
					player flag::set("");
					player.var_873a3e27[2] = 1;
				}
				return true;
			}
			case "":
			{
				foreach(player in level.players)
				{
					player flag::set("");
					player.var_873a3e27[3] = 1;
				}
				return true;
			}
			case "":
			{
				foreach(player in level.players)
				{
					array::add(level._challenges.challenge_1, player._challenges.challenge_1);
					array::add(level._challenges.challenge_2, player._challenges.challenge_2);
					array::add(level._challenges.challenge_3, player._challenges.challenge_3);
				}
				foreach(player in level.players)
				{
					player notify(#"hash_1e547c60");
					player.var_873a3e27 = undefined;
					player._challenges.challenge_1 = array::random(level._challenges.challenge_1);
					player._challenges.challenge_2 = array::random(level._challenges.challenge_2);
					player._challenges.challenge_3 = array::random(level._challenges.challenge_3);
					arrayremovevalue(level._challenges.challenge_1, player._challenges.challenge_1);
					arrayremovevalue(level._challenges.challenge_2, player._challenges.challenge_2);
					arrayremovevalue(level._challenges.challenge_3, player._challenges.challenge_3);
					player thread function_2ce855f3(player._challenges.challenge_1.n_index, player._challenges.challenge_1.func_think, player._challenges.challenge_1.n_count, player._challenges.challenge_1.str_notify);
					player thread function_2ce855f3(player._challenges.challenge_2.n_index, player._challenges.challenge_2.func_think, player._challenges.challenge_2.n_count, player._challenges.challenge_2.str_notify);
					player thread function_2ce855f3(player._challenges.challenge_3.n_index, player._challenges.challenge_3.func_think, player._challenges.challenge_3.n_count, player._challenges.challenge_3.str_notify);
				}
				return true;
			}
		}
		return false;
	#/
}

