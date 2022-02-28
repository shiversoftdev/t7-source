// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_powerup_zombie_blood;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_tomb_main_quest;
#using scripts\zm\zm_tomb_utility;

#namespace zm_tomb_dig;

/*
	Name: init_shovel
	Namespace: zm_tomb_dig
	Checksum: 0x85F87348
	Offset: 0x798
	Size: 0x444
	Parameters: 0
	Flags: Linked
*/
function init_shovel()
{
	callback::on_connect(&init_shovel_player);
	a_shovel_pos = struct::get_array("shovel_location", "targetname");
	a_shovel_zone = [];
	foreach(s_shovel_pos in a_shovel_pos)
	{
		if(!isdefined(a_shovel_zone[s_shovel_pos.script_noteworthy]))
		{
			a_shovel_zone[s_shovel_pos.script_noteworthy] = [];
		}
		a_shovel_zone[s_shovel_pos.script_noteworthy][a_shovel_zone[s_shovel_pos.script_noteworthy].size] = s_shovel_pos;
	}
	foreach(a_zone in a_shovel_zone)
	{
		s_pos = a_zone[randomint(a_zone.size)];
		m_shovel = spawn("script_model", s_pos.origin);
		m_shovel.angles = s_pos.angles;
		m_shovel setmodel("p7_zm_ori_tool_shovel");
		generate_shovel_unitrigger(m_shovel);
	}
	level.get_player_perk_purchase_limit = &get_player_perk_purchase_limit;
	level.bonus_points_powerup_override = &bonus_points_powerup_override;
	level thread dig_powerups_tracking();
	level thread dig_spots_init();
	clientfield::register("world", "player0hasItem", 15000, 2, "int");
	clientfield::register("world", "player1hasItem", 15000, 2, "int");
	clientfield::register("world", "player2hasItem", 15000, 2, "int");
	clientfield::register("world", "player3hasItem", 15000, 2, "int");
	clientfield::register("world", "player0wearableItem", 15000, 1, "int");
	clientfield::register("world", "player1wearableItem", 15000, 1, "int");
	clientfield::register("world", "player2wearableItem", 15000, 1, "int");
	clientfield::register("world", "player3wearableItem", 15000, 1, "int");
	/#
		level thread setup_dig_devgui();
	#/
}

/*
	Name: init_shovel_player
	Namespace: zm_tomb_dig
	Checksum: 0x5E0D2742
	Offset: 0xBE8
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function init_shovel_player()
{
	self.dig_vars["has_shovel"] = 0;
	self.dig_vars["has_upgraded_shovel"] = 0;
	self.dig_vars["has_helmet"] = 0;
	self.dig_vars["n_spots_dug"] = 0;
	self.dig_vars["n_losing_streak"] = 0;
}

/*
	Name: generate_shovel_unitrigger
	Namespace: zm_tomb_dig
	Checksum: 0x5E6C7C48
	Offset: 0xC60
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function generate_shovel_unitrigger(e_shovel)
{
	s_unitrigger_stub = spawnstruct();
	s_unitrigger_stub.origin = e_shovel.origin + vectorscale((0, 0, 1), 32);
	s_unitrigger_stub.angles = e_shovel.angles;
	s_unitrigger_stub.radius = 32;
	s_unitrigger_stub.script_length = 64;
	s_unitrigger_stub.script_width = 64;
	s_unitrigger_stub.script_height = 64;
	s_unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_unitrigger_stub.hint_string = &"ZM_TOMB_SHPU";
	s_unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_unitrigger_stub.require_look_at = 1;
	s_unitrigger_stub.prompt_and_visibility_func = &shovel_trigger_prompt_and_visiblity;
	s_unitrigger_stub.e_shovel = e_shovel;
	zm_unitrigger::unitrigger_force_per_player_triggers(s_unitrigger_stub, 1);
	zm_unitrigger::register_static_unitrigger(s_unitrigger_stub, &shovel_unitrigger_think);
}

/*
	Name: shovel_trigger_prompt_and_visiblity
	Namespace: zm_tomb_dig
	Checksum: 0x80578424
	Offset: 0xDE0
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function shovel_trigger_prompt_and_visiblity(e_player)
{
	can_use = self.stub shovel_prompt_update(e_player);
	self setinvisibletoplayer(e_player, !can_use);
	self sethintstring(self.stub.hint_string);
	return can_use;
}

/*
	Name: shovel_prompt_update
	Namespace: zm_tomb_dig
	Checksum: 0x935185E9
	Offset: 0xE68
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function shovel_prompt_update(e_player)
{
	if(!self unitrigger_stub_show_hint_prompt_valid(e_player))
	{
		return false;
	}
	self.hint_string = &"ZM_TOMB_SHPU";
	if(isdefined(e_player.dig_vars["has_shovel"]) && e_player.dig_vars["has_shovel"])
	{
		self.hint_string = &"ZM_TOMB_SHAG";
	}
	return true;
}

/*
	Name: function_6e5f017f
	Namespace: zm_tomb_dig
	Checksum: 0x6331CCCC
	Offset: 0xEF8
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function function_6e5f017f(n_player)
{
	return ("player" + n_player) + "wearableItem";
}

/*
	Name: function_f4768ce9
	Namespace: zm_tomb_dig
	Checksum: 0x98B627CA
	Offset: 0xF20
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function function_f4768ce9(n_player)
{
	return ("player" + n_player) + "hasItem";
}

/*
	Name: shovel_unitrigger_think
	Namespace: zm_tomb_dig
	Checksum: 0xB7CF3E99
	Offset: 0xF48
	Size: 0x1A0
	Parameters: 0
	Flags: Linked
*/
function shovel_unitrigger_think()
{
	self endon(#"kill_trigger");
	while(true)
	{
		self waittill(#"trigger", e_player);
		if(e_player != self.parent_player)
		{
			continue;
		}
		if(!(isdefined(e_player.dig_vars["has_shovel"]) && e_player.dig_vars["has_shovel"]))
		{
			e_player.dig_vars["has_shovel"] = 1;
			e_player playsound("zmb_craftable_pickup");
			e_player dig_reward_dialog("pickup_shovel");
			n_player = e_player getentitynumber();
			level clientfield::set(function_f4768ce9(n_player), 1);
			e_player thread dig_disconnect_watch(n_player, self.stub.e_shovel.origin, self.stub.e_shovel.angles);
			self.stub.e_shovel delete();
			zm_unitrigger::unregister_unitrigger(self.stub);
		}
	}
}

/*
	Name: dig_reward_dialog
	Namespace: zm_tomb_dig
	Checksum: 0x8B946A8C
	Offset: 0x10F0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function dig_reward_dialog(str_category)
{
	if(!(isdefined(self.dig_vo_cooldown) && self.dig_vo_cooldown))
	{
		self zm_utility::do_player_general_vox("digging", str_category);
	}
}

/*
	Name: dig_reward_vo_cooldown
	Namespace: zm_tomb_dig
	Checksum: 0x24696CC3
	Offset: 0x1150
	Size: 0x2A
	Parameters: 0
	Flags: None
*/
function dig_reward_vo_cooldown()
{
	self endon(#"disconnect");
	self.dig_vo_cooldown = 1;
	wait(60);
	self.dig_vo_cooldown = undefined;
}

/*
	Name: unitrigger_stub_show_hint_prompt_valid
	Namespace: zm_tomb_dig
	Checksum: 0x173D21E2
	Offset: 0x1188
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function unitrigger_stub_show_hint_prompt_valid(e_player)
{
	if(!zombie_utility::is_player_valid(e_player))
	{
		self.hint_string = "";
		return false;
	}
	return true;
}

/*
	Name: dig_disconnect_watch
	Namespace: zm_tomb_dig
	Checksum: 0x6FCFA9A7
	Offset: 0x11D0
	Size: 0xF4
	Parameters: 3
	Flags: Linked
*/
function dig_disconnect_watch(n_player, v_origin, v_angles)
{
	self waittill(#"disconnect");
	level clientfield::set(function_f4768ce9(n_player), 0);
	level clientfield::set(function_6e5f017f(n_player), 0);
	m_shovel = spawn("script_model", v_origin);
	m_shovel.angles = v_angles;
	m_shovel setmodel("p7_zm_ori_tool_shovel");
	generate_shovel_unitrigger(m_shovel);
}

/*
	Name: dig_spots_init
	Namespace: zm_tomb_dig
	Checksum: 0xF0649B6D
	Offset: 0x12D0
	Size: 0x294
	Parameters: 0
	Flags: Linked
*/
function dig_spots_init()
{
	while(!level flag::exists("start_zombie_round_logic"))
	{
		wait(0.5);
	}
	level flag::wait_till("start_zombie_round_logic");
	level.n_dig_spots_cur = 0;
	level.n_dig_spots_max = 15;
	level.a_dig_spots = struct::get_array("dig_spot", "targetname");
	foreach(s_dig_spot in level.a_dig_spots)
	{
		if(!isdefined(s_dig_spot.angles))
		{
			s_dig_spot.angles = (0, 0, 0);
		}
		if(isdefined(s_dig_spot.script_noteworthy) && s_dig_spot.script_noteworthy == "initial_spot")
		{
			s_dig_spot thread dig_spot_spawn();
		}
		else
		{
			s_dig_spot.dug = 1;
		}
		s_dig_spot.str_zone = zm_zonemgr::get_zone_from_position(s_dig_spot.origin + vectorscale((0, 0, 1), 32), 1);
		if(!isdefined(s_dig_spot.str_zone))
		{
			s_dig_spot.str_zone = "";
			/#
				/#
					assertmsg(((((("" + s_dig_spot.origin[0]) + "") + s_dig_spot.origin[1]) + "") + s_dig_spot.origin[2]) + "");
				#/
			#/
		}
		util::wait_network_frame();
	}
	level thread dig_spots_respawn();
}

/*
	Name: dig_spots_respawn
	Namespace: zm_tomb_dig
	Checksum: 0x149275DF
	Offset: 0x1570
	Size: 0x3E6
	Parameters: 1
	Flags: Linked
*/
function dig_spots_respawn(a_dig_spots)
{
	while(true)
	{
		level waittill(#"end_of_round");
		wait(2);
		a_dig_spots = array::randomize(level.a_dig_spots);
		n_respawned = 0;
		n_respawned_max = 3;
		if(level.weather_snow > 0)
		{
			n_respawned_max = 0;
		}
		else if(level.weather_rain > 0)
		{
			n_respawned_max = 5;
		}
		if(level.weather_snow == 0)
		{
			n_respawned_max = n_respawned_max + randomint(getplayers().size);
		}
		for(i = 0; i < a_dig_spots.size; i++)
		{
			if(isdefined(a_dig_spots[i].dug) && a_dig_spots[i].dug && n_respawned < n_respawned_max && level.n_dig_spots_cur <= level.n_dig_spots_max)
			{
				a_dig_spots[i].dug = undefined;
				a_dig_spots[i] thread dig_spot_spawn();
				util::wait_network_frame();
				n_respawned++;
			}
		}
		if(level.weather_snow > 0 && level.ice_staff_pieces.size > 0)
		{
			foreach(s_staff in level.ice_staff_pieces)
			{
				a_staff_spots = [];
				n_active_mounds = 0;
				foreach(s_dig_spot in level.a_dig_spots)
				{
					if(isdefined(s_dig_spot.str_zone) && issubstr(s_dig_spot.str_zone, s_staff.zone_substr))
					{
						if(!(isdefined(s_dig_spot.dug) && s_dig_spot.dug))
						{
							n_active_mounds++;
							continue;
						}
						a_staff_spots[a_staff_spots.size] = s_dig_spot;
					}
				}
				if(n_active_mounds < 2 && a_staff_spots.size > 0 && level.n_dig_spots_cur <= level.n_dig_spots_max)
				{
					n_index = randomint(a_staff_spots.size);
					a_staff_spots[n_index].dug = undefined;
					a_staff_spots[n_index] thread dig_spot_spawn();
					arrayremoveindex(a_staff_spots, n_index);
					n_active_mounds++;
					util::wait_network_frame();
				}
			}
		}
	}
}

/*
	Name: dig_spot_spawn
	Namespace: zm_tomb_dig
	Checksum: 0x67FBBDFE
	Offset: 0x1960
	Size: 0x176
	Parameters: 0
	Flags: Linked
*/
function dig_spot_spawn()
{
	level.n_dig_spots_cur++;
	self.m_dig = spawn("script_model", self.origin + (vectorscale((0, 0, -1), 40)));
	self.m_dig setmodel("p7_zm_ori_dig_mound");
	self.m_dig.angles = self.angles;
	self.m_dig moveto(self.origin, 3, 0, 1);
	self.m_dig waittill(#"movedone");
	t_dig = zm_tomb_utility::tomb_spawn_trigger_radius(self.origin + vectorscale((0, 0, 1), 20), 100, 1);
	t_dig.prompt_and_visibility_func = &dig_spot_trigger_visibility;
	t_dig.require_look_at = 1;
	t_dig waittill_dug(self);
	zm_unitrigger::unregister_unitrigger(t_dig);
	t_dig = undefined;
	self.m_dig delete();
	self.m_dig = undefined;
}

/*
	Name: dig_spot_trigger_visibility
	Namespace: zm_tomb_dig
	Checksum: 0xF1E4AE98
	Offset: 0x1AE0
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function dig_spot_trigger_visibility(player)
{
	if(isdefined(player.dig_vars["has_shovel"]) && player.dig_vars["has_shovel"])
	{
		self sethintstring(&"ZM_TOMB_X2D");
	}
	else
	{
		self sethintstring(&"ZM_TOMB_NS");
	}
	return true;
}

/*
	Name: waittill_dug
	Namespace: zm_tomb_dig
	Checksum: 0x5B05C3F9
	Offset: 0x1B68
	Size: 0x4E2
	Parameters: 1
	Flags: Linked
*/
function waittill_dug(s_dig_spot)
{
	while(true)
	{
		self waittill(#"trigger", player);
		if(isdefined(player.dig_vars["has_shovel"]) && player.dig_vars["has_shovel"])
		{
			player playsound("evt_dig");
			s_dig_spot.dug = 1;
			level.n_dig_spots_cur--;
			playfx(level._effect["digging"], self.origin);
			player clientfield::set_to_player("player_rumble_and_shake", 1);
			s_staff_piece = s_dig_spot zm_tomb_main_quest::dig_spot_get_staff_piece(player);
			if(isdefined(s_staff_piece))
			{
				s_staff_piece zm_tomb_main_quest::show_ice_staff_piece(self.origin);
				player dig_reward_dialog("dig_staff_part");
			}
			else
			{
				n_good_chance = 50;
				if(player.dig_vars["n_spots_dug"] == 0 || player.dig_vars["n_losing_streak"] == 3)
				{
					player.dig_vars["n_losing_streak"] = 0;
					n_good_chance = 100;
				}
				if(player.dig_vars["has_upgraded_shovel"])
				{
					if(!player.dig_vars["has_helmet"])
					{
						n_helmet_roll = randomint(100);
						if(n_helmet_roll >= 95)
						{
							player.dig_vars["has_helmet"] = 1;
							level clientfield::set(function_6e5f017f(player getentitynumber()), 1);
							player playsoundtoplayer("zmb_squest_golden_anything", player);
							player thread function_85eef9f2();
							return;
						}
					}
					n_good_chance = 70;
				}
				n_prize_roll = randomint(100);
				if(n_prize_roll > n_good_chance)
				{
					if(math::cointoss())
					{
						player dig_reward_dialog("dig_grenade");
						self thread dig_up_grenade(player);
					}
					else
					{
						player dig_reward_dialog("dig_zombie");
						self thread dig_up_zombie(player, s_dig_spot);
					}
					player.dig_vars["n_losing_streak"]++;
				}
				else
				{
					if(math::cointoss())
					{
						self thread dig_up_powerup(player);
					}
					else
					{
						player dig_reward_dialog("dig_gun");
						self thread dig_up_weapon(player);
					}
				}
			}
			if(!player.dig_vars["has_upgraded_shovel"])
			{
				player.dig_vars["n_spots_dug"]++;
				if(player.dig_vars["n_spots_dug"] >= 30)
				{
					player.dig_vars["has_upgraded_shovel"] = 1;
					player thread ee_zombie_blood_dig();
					level clientfield::set(function_f4768ce9(player getentitynumber()), 2);
					player playsoundtoplayer("zmb_squest_golden_anything", player);
				}
			}
			return;
		}
	}
}

/*
	Name: dig_up_zombie
	Namespace: zm_tomb_dig
	Checksum: 0xDB0CB10E
	Offset: 0x2058
	Size: 0x1D4
	Parameters: 2
	Flags: Linked
*/
function dig_up_zombie(player, s_dig_spot)
{
	ai_zombie = zombie_utility::spawn_zombie(level.dig_spawners[0]);
	ai_zombie endon(#"death");
	ai_zombie ghost();
	e_linker = spawn("script_origin", (0, 0, 0));
	e_linker.origin = ai_zombie.origin;
	e_linker.angles = ai_zombie.angles;
	ai_zombie linkto(e_linker);
	e_linker moveto(player.origin + vectorscale((1, 1, 0), 100), 0.1);
	e_linker waittill(#"movedone");
	ai_zombie unlink();
	e_linker delete();
	ai_zombie show();
	ai_zombie playsound("evt_zombie_dig_dirt");
	ai_zombie zm_tomb_utility::dug_zombie_rise(s_dig_spot);
	find_flesh_struct_string = "find_flesh";
	ai_zombie notify(#"zombie_custom_think_done", find_flesh_struct_string);
}

/*
	Name: dig_up_powerup
	Namespace: zm_tomb_dig
	Checksum: 0x1B260C8B
	Offset: 0x2238
	Size: 0x274
	Parameters: 1
	Flags: Linked
*/
function dig_up_powerup(player)
{
	powerup = spawn("script_model", self.origin);
	powerup endon(#"powerup_grabbed");
	powerup endon(#"powerup_timedout");
	a_rare_powerups = dig_get_rare_powerups(player);
	powerup_item = undefined;
	if((level.dig_n_powerups_spawned + level.powerup_drop_count) > 4 || level.dig_last_prize_rare || a_rare_powerups.size == 0 || randomint(100) < 80)
	{
		if(level.dig_n_zombie_bloods_spawned < 1 && randomint(100) > 70)
		{
			powerup_item = "bonus_points_player";
			player dig_reward_dialog("dig_cash");
		}
		else
		{
			powerup_item = "bonus_points_player";
			player dig_reward_dialog("dig_cash");
		}
		level.dig_last_prize_rare = 0;
	}
	else
	{
		powerup_item = a_rare_powerups[randomint(a_rare_powerups.size)];
		level.dig_last_prize_rare = 1;
		level.dig_n_powerups_spawned++;
		player dig_reward_dialog("dig_powerup");
		dig_set_powerup_spawned(powerup_item);
	}
	powerup zm_powerups::powerup_setup(powerup_item);
	powerup movez(40, 0.6);
	powerup waittill(#"movedone");
	powerup thread zm_powerups::powerup_timeout();
	powerup thread zm_powerups::powerup_wobble();
	powerup thread zm_powerups::powerup_grab();
}

/*
	Name: dig_get_rare_powerups
	Namespace: zm_tomb_dig
	Checksum: 0xC760E6E0
	Offset: 0x24B8
	Size: 0x204
	Parameters: 1
	Flags: Linked
*/
function dig_get_rare_powerups(player)
{
	a_rare_powerups = [];
	a_possible_powerups = array("nuke", "double_points");
	if(level.dig_magic_box_moved && !dig_has_powerup_spawned("fire_sale"))
	{
		if(!isdefined(a_possible_powerups))
		{
			a_possible_powerups = [];
		}
		else if(!isarray(a_possible_powerups))
		{
			a_possible_powerups = array(a_possible_powerups);
		}
		a_possible_powerups[a_possible_powerups.size] = "fire_sale";
	}
	if(player.dig_vars["has_upgraded_shovel"])
	{
		a_possible_powerups = arraycombine(a_possible_powerups, array("insta_kill", "full_ammo"), 0, 0);
	}
	foreach(powerup in a_possible_powerups)
	{
		if(!dig_has_powerup_spawned(powerup))
		{
			if(!isdefined(a_rare_powerups))
			{
				a_rare_powerups = [];
			}
			else if(!isarray(a_rare_powerups))
			{
				a_rare_powerups = array(a_rare_powerups);
			}
			a_rare_powerups[a_rare_powerups.size] = powerup;
		}
	}
	return a_rare_powerups;
}

/*
	Name: dig_up_grenade
	Namespace: zm_tomb_dig
	Checksum: 0x8C19A444
	Offset: 0x26C8
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function dig_up_grenade(player)
{
	player endon(#"disconnect");
	v_spawnpt = self.origin;
	w_grenade = getweapon("frag_grenade");
	n_rand = randomintrange(0, 4);
	player magicgrenadetype(w_grenade, v_spawnpt, vectorscale((0, 0, 1), 300), 3);
	player playsound("evt_grenade_digup");
	if(n_rand)
	{
		wait(0.3);
		if(math::cointoss())
		{
			player magicgrenadetype(w_grenade, v_spawnpt, (50, 50, 300), 3);
		}
	}
}

/*
	Name: dig_up_weapon
	Namespace: zm_tomb_dig
	Checksum: 0xE2E9372C
	Offset: 0x27F8
	Size: 0x4E8
	Parameters: 1
	Flags: Linked
*/
function dig_up_weapon(digger)
{
	var_43f586fe = array(getweapon("pistol_c96"), getweapon("ar_marksman"), getweapon("shotgun_pump"));
	var_63eba41d = array(getweapon("sniper_fastsemi"), getweapon("shotgun_fullauto"));
	if(digger.dig_vars["has_upgraded_shovel"])
	{
		var_63eba41d = arraycombine(var_63eba41d, array(getweapon("bouncingbetty"), getweapon("ar_stg44"), getweapon("smg_standard"), getweapon("smg_mp40_1940"), getweapon("shotgun_precision")), 0, 0);
	}
	var_59d5868d = undefined;
	if(randomint(100) < 90)
	{
		var_59d5868d = var_43f586fe[getarraykeys(var_43f586fe)[randomint(getarraykeys(var_43f586fe).size)]];
	}
	else
	{
		var_59d5868d = var_63eba41d[getarraykeys(var_63eba41d)[randomint(getarraykeys(var_63eba41d).size)]];
	}
	v_spawnpt = self.origin + (0, 0, 40);
	v_spawnang = (0, 0, 0);
	v_angles = digger getplayerangles();
	v_angles = (0, v_angles[1], 0) + vectorscale((0, 1, 0), 90) + v_spawnang;
	m_weapon = zm_utility::spawn_buildkit_weapon_model(digger, var_59d5868d, undefined, v_spawnpt, v_angles);
	m_weapon.angles = v_angles;
	m_weapon playloopsound("evt_weapon_digup");
	m_weapon thread timer_til_despawn(v_spawnpt, 40 * -1);
	m_weapon endon(#"dig_up_weapon_timed_out");
	playfxontag(level._effect["powerup_on_solo"], m_weapon, "tag_origin");
	m_weapon.trigger = zm_tomb_utility::tomb_spawn_trigger_radius(v_spawnpt, 100, 1, undefined, &weapon_trigger_update_prompt);
	m_weapon.trigger.cursor_hint = "HINT_WEAPON";
	m_weapon.trigger.cursor_hint_weapon = var_59d5868d;
	m_weapon.trigger waittill(#"trigger", player);
	m_weapon.trigger notify(#"weapon_grabbed");
	m_weapon.trigger thread swap_weapon(var_59d5868d, player);
	if(isdefined(m_weapon.trigger))
	{
		zm_unitrigger::unregister_unitrigger(m_weapon.trigger);
		m_weapon.trigger = undefined;
	}
	if(isdefined(m_weapon))
	{
		m_weapon delete();
	}
	if(player != digger)
	{
		digger notify(#"dig_up_weapon_shared");
	}
}

/*
	Name: weapon_trigger_update_prompt
	Namespace: zm_tomb_dig
	Checksum: 0x701BA388
	Offset: 0x2CE8
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function weapon_trigger_update_prompt(player)
{
	if(!zm_utility::is_player_valid(player) || player.is_drinking > 0 || !player zm_magicbox::can_buy_weapon() || player bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		self setcursorhint("HINT_NOICON");
		return false;
	}
	self setcursorhint("HINT_WEAPON", self.stub.cursor_hint_weapon);
	return true;
}

/*
	Name: swap_weapon
	Namespace: zm_tomb_dig
	Checksum: 0xB991DDCF
	Offset: 0x2DB8
	Size: 0x224
	Parameters: 2
	Flags: Linked
*/
function swap_weapon(var_375664a9, e_player)
{
	w_current_weapon = e_player getcurrentweapon();
	if(!zombie_utility::is_player_valid(e_player) || (isdefined(e_player.is_drinking) && e_player.is_drinking) || zm_utility::is_placeable_mine(w_current_weapon) || zm_equipment::is_equipment(w_current_weapon) || w_current_weapon == getweapon("none") || e_player zm_equipment::hacker_active())
	{
		return;
	}
	if(isdefined(level.revive_tool) && level.revive_tool == w_current_weapon)
	{
		return;
	}
	var_6c6831af = e_player getweaponslist(1);
	foreach(weapon in var_6c6831af)
	{
		w_base = zm_weapons::get_base_weapon(weapon);
		var_7321b53b = zm_weapons::get_upgrade_weapon(weapon);
		if(var_375664a9 === w_base || var_375664a9 === var_7321b53b)
		{
			e_player givemaxammo(weapon);
			return;
		}
	}
	e_player zm_weapons::weapon_give(var_375664a9);
}

/*
	Name: timer_til_despawn
	Namespace: zm_tomb_dig
	Checksum: 0x6CDA5DB3
	Offset: 0x2FE8
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
	Name: get_player_perk_purchase_limit
	Namespace: zm_tomb_dig
	Checksum: 0x9CB32C30
	Offset: 0x30B8
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function get_player_perk_purchase_limit()
{
	if(isdefined(self.player_perk_purchase_limit))
	{
		return self.player_perk_purchase_limit;
	}
	return level.perk_purchase_limit;
}

/*
	Name: increment_player_perk_purchase_limit
	Namespace: zm_tomb_dig
	Checksum: 0x138F3C2B
	Offset: 0x30E0
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function increment_player_perk_purchase_limit()
{
	if(!isdefined(self.player_perk_purchase_limit))
	{
		self.player_perk_purchase_limit = level.perk_purchase_limit;
	}
	if(self.player_perk_purchase_limit < 8)
	{
		self.player_perk_purchase_limit++;
	}
}

/*
	Name: ee_zombie_blood_dig
	Namespace: zm_tomb_dig
	Checksum: 0xE9851FDC
	Offset: 0x3120
	Size: 0x23C
	Parameters: 0
	Flags: Linked
*/
function ee_zombie_blood_dig()
{
	self endon(#"disconnect");
	n_z_spots_found = 0;
	a_z_spots = struct::get_array("zombie_blood_dig_spot", "targetname");
	self.t_zombie_blood_dig = spawn("trigger_radius_use", (0, 0, 0), 0, 100, 50);
	self.t_zombie_blood_dig.e_unique_player = self;
	self.t_zombie_blood_dig triggerignoreteam();
	self.t_zombie_blood_dig setcursorhint("HINT_NOICON");
	self.t_zombie_blood_dig sethintstring(&"ZM_TOMB_X2D");
	self.t_zombie_blood_dig zm_powerup_zombie_blood::make_zombie_blood_entity();
	while(n_z_spots_found < 4)
	{
		a_randomized = array::randomize(a_z_spots);
		n_index = undefined;
		for(i = 0; i < a_randomized.size; i++)
		{
			if(!isdefined(a_randomized[i].n_player))
			{
				n_index = i;
				break;
			}
		}
		/#
			assert(isdefined(n_index), "");
		#/
		s_z_spot = a_randomized[n_index];
		s_z_spot.n_player = self getentitynumber();
		s_z_spot create_zombie_blood_dig_spot(self);
		n_z_spots_found++;
		level waittill(#"end_of_round");
	}
	self.t_zombie_blood_dig delete();
}

/*
	Name: ee_zombie_blood_dig_disconnect_watch
	Namespace: zm_tomb_dig
	Checksum: 0x4672B3DE
	Offset: 0x3368
	Size: 0x13A
	Parameters: 0
	Flags: None
*/
function ee_zombie_blood_dig_disconnect_watch()
{
	self waittill(#"disconnect");
	if(isdefined(self.t_zombie_blood_dig))
	{
		self.t_zombie_blood_dig delete();
	}
	a_z_spots = struct::get_array("zombie_blood_dig_spot", "targetname");
	foreach(s_pos in a_z_spots)
	{
		if(isdefined(s_pos.n_player) && s_pos.n_player == self getentitynumber())
		{
			s_pos.n_player = undefined;
		}
		if(isdefined(s_pos.m_dig))
		{
			s_pos delete();
		}
	}
}

/*
	Name: create_zombie_blood_dig_spot
	Namespace: zm_tomb_dig
	Checksum: 0xDFFD28F4
	Offset: 0x34B0
	Size: 0x17E
	Parameters: 1
	Flags: Linked
*/
function create_zombie_blood_dig_spot(e_player)
{
	self.m_dig = spawn("script_model", self.origin + (vectorscale((0, 0, -1), 40)));
	self.m_dig.angles = self.angles;
	self.m_dig setmodel("p7_zm_ori_dig_mound_blood");
	self.m_dig zm_powerup_zombie_blood::make_zombie_blood_entity();
	self.m_dig moveto(self.origin, 3, 0, 1);
	self.m_dig waittill(#"movedone");
	self.m_dig.e_unique_player = e_player;
	/#
		self thread zm_tomb_utility::puzzle_debug_position("", vectorscale((0, 0, 1), 255), self.origin);
	#/
	e_player.t_zombie_blood_dig.origin = self.origin + vectorscale((0, 0, 1), 20);
	e_player.t_zombie_blood_dig waittill_zombie_blood_dug(self);
	/#
		self notify(#"stop_debug_position");
	#/
}

/*
	Name: waittill_zombie_blood_dug
	Namespace: zm_tomb_dig
	Checksum: 0xB992617B
	Offset: 0x3638
	Size: 0x11A
	Parameters: 1
	Flags: Linked
*/
function waittill_zombie_blood_dug(s_dig_spot)
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger", player);
		if(isdefined(player.dig_vars["has_shovel"]) && player.dig_vars["has_shovel"])
		{
			player.t_zombie_blood_dig.origin = (0, 0, 0);
			player playsound("evt_dig");
			playfx(level._effect["digging"], self.origin);
			s_dig_spot.m_dig delete();
			spawn_perk_upgrade_bottle(s_dig_spot.origin, player);
			return;
		}
	}
}

/*
	Name: spawn_perk_upgrade_bottle
	Namespace: zm_tomb_dig
	Checksum: 0x13C99067
	Offset: 0x3760
	Size: 0x21C
	Parameters: 2
	Flags: Linked
*/
function spawn_perk_upgrade_bottle(v_origin, e_player)
{
	m_bottle = spawn("script_model", v_origin + vectorscale((0, 0, 1), 40));
	m_bottle setmodel("zombie_pickup_perk_bottle");
	m_bottle.angles = vectorscale((1, 0, 0), 10);
	m_bottle setinvisibletoall();
	m_bottle setvisibletoplayer(e_player);
	m_fx = spawn("script_model", m_bottle.origin);
	m_fx setmodel("tag_origin");
	m_fx setinvisibletoall();
	m_fx setvisibletoplayer(e_player);
	playfxontag(level._effect["special_glow"], m_fx, "tag_origin");
	m_bottle linkto(m_fx);
	m_fx thread rotate_perk_upgrade_bottle();
	while(isdefined(e_player) && !e_player istouching(m_bottle))
	{
		wait(0.05);
	}
	m_bottle delete();
	m_fx delete();
	if(isdefined(e_player))
	{
		e_player increment_player_perk_purchase_limit();
	}
}

/*
	Name: rotate_perk_upgrade_bottle
	Namespace: zm_tomb_dig
	Checksum: 0xB16F96AB
	Offset: 0x3988
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function rotate_perk_upgrade_bottle()
{
	self endon(#"death");
	while(true)
	{
		self rotateyaw(360, 5);
		self waittill(#"rotatedone");
	}
}

/*
	Name: bonus_points_powerup_override
	Namespace: zm_tomb_dig
	Checksum: 0x87D54CB5
	Offset: 0x39D8
	Size: 0x32
	Parameters: 0
	Flags: Linked
*/
function bonus_points_powerup_override()
{
	points = randomintrange(1, 6) * 50;
	return points;
}

/*
	Name: dig_powerups_tracking
	Namespace: zm_tomb_dig
	Checksum: 0x63CEF0CC
	Offset: 0x3A18
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function dig_powerups_tracking()
{
	level endon(#"end_game");
	level.dig_powerups_tracking = [];
	level.dig_magic_box_moved = 0;
	level.dig_last_prize_rare = 0;
	level.dig_n_zombie_bloods_spawned = 0;
	level.dig_n_powerups_spawned = 0;
	while(true)
	{
		level waittill(#"end_of_round");
		foreach(str_powerup, value in level.dig_powerups_tracking)
		{
			level.dig_powerups_tracking[str_powerup] = 0;
		}
		level.dig_n_zombie_bloods_spawned = 0;
		level.dig_n_powerups_spawned = 0;
	}
}

/*
	Name: dig_has_powerup_spawned
	Namespace: zm_tomb_dig
	Checksum: 0x2389E47C
	Offset: 0x3B18
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function dig_has_powerup_spawned(str_powerup)
{
	if(!isdefined(level.dig_powerups_tracking[str_powerup]))
	{
		level.dig_powerups_tracking[str_powerup] = 0;
	}
	return level.dig_powerups_tracking[str_powerup];
}

/*
	Name: dig_set_powerup_spawned
	Namespace: zm_tomb_dig
	Checksum: 0xC0B4B9E
	Offset: 0x3B60
	Size: 0x1E
	Parameters: 1
	Flags: Linked
*/
function dig_set_powerup_spawned(str_powerup)
{
	level.dig_powerups_tracking[str_powerup] = 1;
}

/*
	Name: function_85eef9f2
	Namespace: zm_tomb_dig
	Checksum: 0xFD0560C9
	Offset: 0x3B88
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_85eef9f2()
{
	if(!isdefined(self.var_8e065802))
	{
		self.var_8e065802 = spawnstruct();
	}
	self.var_8e065802.model = "c_t7_zm_dlchd_origins_golden_helmet";
	self.var_8e065802.tag = "j_head";
	self.var_ae07e72c = "golden_helmet";
	self attach(self.var_8e065802.model, self.var_8e065802.tag);
	if(self.characterindex == 1)
	{
		self setcharacterbodystyle(2);
	}
}

/*
	Name: setup_dig_devgui
	Namespace: zm_tomb_dig
	Checksum: 0x7259199E
	Offset: 0x3C60
	Size: 0x2A4
	Parameters: 0
	Flags: Linked
*/
function setup_dig_devgui()
{
	/#
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
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
		level thread watch_devgui_dig();
	#/
	level.a_dig_spots = struct::get_array("dig_spot", "targetname");
	level.dig_spawners = getentarray("zombie_spawner_dig", "script_noteworthy");
}

/*
	Name: watch_devgui_dig
	Namespace: zm_tomb_dig
	Checksum: 0x33EB0CE1
	Offset: 0x3F10
	Size: 0xC80
	Parameters: 0
	Flags: Linked
*/
function watch_devgui_dig()
{
	/#
		while(true)
		{
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				player = getplayers()[0];
				s_dig_spot = arraygetclosest(player.origin, level.a_dig_spots);
				level thread dig_up_zombie(player, s_dig_spot);
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				foreach(player in getplayers())
				{
					player.dig_vars[""] = 1;
					level clientfield::set(function_f4768ce9(player getentitynumber()), 1);
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				foreach(player in getplayers())
				{
					player.dig_vars[""] = 1;
					player.dig_vars[""] = 1;
					player thread ee_zombie_blood_dig();
					level clientfield::set(function_f4768ce9(player getentitynumber()), 2);
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				foreach(player in getplayers())
				{
					player.dig_vars[""] = 1;
					n_player = player getentitynumber() + 1;
					level clientfield::set(function_6e5f017f(n_player - 1), 1);
					player thread function_85eef9f2();
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				a_dig_spots = array::randomize(level.a_dig_spots);
				for(i = 0; i < a_dig_spots.size; i++)
				{
					if(isdefined(a_dig_spots[i].dug) && a_dig_spots[i].dug && level.n_dig_spots_cur <= level.n_dig_spots_max)
					{
						a_dig_spots[i].dug = undefined;
						a_dig_spots[i] thread dig_spot_spawn();
						util::wait_network_frame();
					}
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				a_dig_spots = array::randomize(level.a_dig_spots);
				for(i = 0; i < a_dig_spots.size; i++)
				{
					if(isdefined(a_dig_spots[i].dug) && a_dig_spots[i].dug)
					{
						a_dig_spots[i].dug = undefined;
						a_dig_spots[i] thread dig_spot_spawn();
						util::wait_network_frame();
					}
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				a_z_spots = struct::get_array("", "");
				foreach(s_spot in a_z_spots)
				{
					s_spot.m_dig = spawn("", s_spot.origin + (vectorscale((0, 0, -1), 40)));
					s_spot.m_dig.angles = s_spot.angles;
					s_spot.m_dig setmodel("");
					s_spot.m_dig moveto(s_spot.origin, 3, 0, 1);
					util::wait_network_frame();
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				level.weather_snow = 0;
				level.weather_rain = 5;
				level.weather_vision = 1;
				level clientfield::set("", level.weather_rain);
				level clientfield::set("", level.weather_snow);
				wait(1);
				foreach(player in getplayers())
				{
					if(zombie_utility::is_player_valid(player, 0, 1))
					{
						player zm_tomb_utility::set_weather_to_player();
					}
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				level.weather_snow = 5;
				level.weather_rain = 0;
				level.weather_vision = 2;
				level clientfield::set("", level.weather_rain);
				level clientfield::set("", level.weather_snow);
				wait(1);
				foreach(player in getplayers())
				{
					if(zombie_utility::is_player_valid(player, 0, 1))
					{
						player zm_tomb_utility::set_weather_to_player();
					}
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				level.weather_snow = 0;
				level.weather_rain = 0;
				level.weather_vision = 3;
				level clientfield::set("", level.weather_rain);
				level clientfield::set("", level.weather_snow);
				wait(1);
				foreach(player in getplayers())
				{
					if(zombie_utility::is_player_valid(player, 0, 1))
					{
						player zm_tomb_utility::set_weather_to_player();
					}
				}
			}
			wait(0.05);
		}
	#/
}

