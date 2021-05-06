// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_zod_cleanup_mgr;
#using scripts\zm\zm_zod_util;

#namespace zm_train;

/*
	Name: __init__sytem__
	Namespace: zm_train
	Checksum: 0xBDD9C4EF
	Offset: 0xCE0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("zm_train", &__init__, undefined, undefined);
}

/*
	Name: onplayerconnect
	Namespace: zm_train
	Checksum: 0x3FA43A3F
	Offset: 0xD20
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect()
{
	self.on_train = 0;
}

/*
	Name: __init__
	Namespace: zm_train
	Checksum: 0x43133229
	Offset: 0xD38
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_connect(&onplayerconnect);
	callback::on_spawned(&player_on_spawned);
	zm_zod_util::on_zombie_killed(&remove_dead_zombie);
	zm_zod_util::add_zod_zombie_spawn_func(&zombie_init);
	clientfield::register("vehicle", "train_switch_light", 1, 2, "int");
	clientfield::register("scriptmover", "train_callbox_light", 1, 2, "int");
	clientfield::register("scriptmover", "train_map_light", 1, 2, "int");
	clientfield::register("vehicle", "train_rain_fx_occluder", 1, 1, "int");
	clientfield::register("world", "sndTrainVox", 1, 4, "int");
	level.player_intemission_spawn_callback = &player_intemission_spawn_callback;
	thread function_b8c85e5c();
	thread function_eb0db7bc();
	/#
		thread train_devgui();
	#/
}

/*
	Name: function_eb0db7bc
	Namespace: zm_train
	Checksum: 0x68EA01F1
	Offset: 0xF08
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_eb0db7bc()
{
	level flag::wait_till("all_players_spawned");
	level flag::wait_till("zones_initialized");
	while(true)
	{
		level waittill(#"host_migration_end");
		[[ level.o_zod_train ]]->function_aaacaec9();
		[[ level.o_zod_train ]]->function_7eb2583b();
		[[ level.o_zod_train ]]->function_dda9a9d2();
		[[ level.o_zod_train ]]->send_train();
	}
}

/*
	Name: player_intemission_spawn_callback
	Namespace: zm_train
	Checksum: 0x49391276
	Offset: 0xFC0
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function player_intemission_spawn_callback(origin, angles)
{
	ride_vehicle = undefined;
	self.ground_ent = self getgroundent();
	if(isdefined(self.ground_ent))
	{
		if(isvehicle(self.ground_ent) && !level.zombie_team === self.ground_ent)
		{
			ride_vehicle = self.ground_ent;
		}
	}
	if(isdefined(ride_vehicle))
	{
		self spawn(origin, angles);
	}
}

/*
	Name: function_b8c85e5c
	Namespace: zm_train
	Checksum: 0xD73D9D57
	Offset: 0x1088
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function function_b8c85e5c()
{
	level flag::wait_till("all_players_spawned");
	level flag::wait_till("zones_initialized");
	e_train = getent("zod_train", "targetname");
	e_train function_7465f87();
	e_train.takedamage = 0;
	e_train clientfield::set("train_rain_fx_occluder", 1);
	object = new czmtrain();
	[[ object ]]->__constructor();
	level.o_zod_train = object;
	[[ level.o_zod_train ]]->initialize(e_train);
	level thread autosend_train();
	level.var_33c4ee76 = 0;
}

/*
	Name: function_f37aa349
	Namespace: zm_train
	Checksum: 0xEC474585
	Offset: 0x1198
	Size: 0xB6
	Parameters: 1
	Flags: None
*/
function function_f37aa349(sn)
{
	ents = getentarray();
	foreach(var_2b851d38, ent in ents)
	{
		if(ent.script_noteworthy === sn)
		{
			return ent;
		}
	}
	return undefined;
}

/*
	Name: function_7465f87
	Namespace: zm_train
	Checksum: 0xF99BFCE4
	Offset: 0x1258
	Size: 0x33A
	Parameters: 0
	Flags: Linked
*/
function function_7465f87()
{
	trigs = getentarray("train_buyable_weapon", "script_noteworthy");
	foreach(var_fc5be8d7, trig in trigs)
	{
		trig enablelinkto();
		trig linkto(self, "", self worldtolocalcoords(trig.origin), (0, 0, 0));
		trig.weapon = getweapon(trig.zombie_weapon_upgrade);
		trig setcursorhint("HINT_WEAPON", trig.weapon);
		trig.cost = zm_weapons::get_weapon_cost(trig.weapon);
		trig.hint_string = zm_weapons::get_weapon_hint(trig.weapon);
		if(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)
		{
			trig sethintstring(trig.hint_string);
		}
		else
		{
			trig.hint_parm1 = trig.cost;
			trig sethintstring(trig.hint_string, trig.hint_parm1);
		}
		self.buyable_weapon = trig;
		level._spawned_wallbuys[level._spawned_wallbuys.size] = trig;
		weapon_model = getent(trig.target, "targetname");
		weapon_model linkto(self, "", self worldtolocalcoords(weapon_model.origin), weapon_model.angles + self.angles);
		weapon_model setmovingplatformenabled(1);
		weapon_model._linked_ent = trig;
		weapon_model show();
		weapon_model thread function_d7993b3d(trig);
	}
}

/*
	Name: player_on_spawned
	Namespace: zm_train
	Checksum: 0xAA3FE45E
	Offset: 0x15A0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function player_on_spawned()
{
	self thread function_69c89e00();
}

/*
	Name: function_69c89e00
	Namespace: zm_train
	Checksum: 0x64908CD3
	Offset: 0x15C8
	Size: 0x142
	Parameters: 0
	Flags: Linked
*/
function function_69c89e00()
{
	self endon(#"disconnect");
	self notify(#"hash_69c89e00");
	self endon(#"hash_69c89e00");
	level flag::wait_till("all_players_spawned");
	level flag::wait_till("zones_initialized");
	wait(1);
	wallbuy = level.o_zod_train.var_36e768e4.buyable_weapon;
	self notify(#"zm_bgb_secret_shopper", wallbuy);
	self.var_316060b3 = 0;
	while(isdefined(self))
	{
		if(isdefined(self.on_train) && self.on_train)
		{
			if(!self.var_316060b3)
			{
				self notify(#"zm_bgb_secret_shopper", wallbuy);
			}
			wallbuy function_2e9b7fc1(self, wallbuy.weapon);
		}
		else if(self.var_316060b3)
		{
			self notify(#"hash_a09e2c64");
		}
		self.var_316060b3 = self.on_train;
		wait(1);
	}
}

/*
	Name: function_2e9b7fc1
	Namespace: zm_train
	Checksum: 0x539A5EBF
	Offset: 0x1718
	Size: 0x4F8
	Parameters: 2
	Flags: Linked
*/
function function_2e9b7fc1(player, weapon = self.weapon)
{
	player_has_weapon = player zm_weapons::has_weapon_or_upgrade(weapon);
	if(!player_has_weapon && (isdefined(level.weapons_using_ammo_sharing) && level.weapons_using_ammo_sharing))
	{
		shared_ammo_weapon = player zm_weapons::get_shared_ammo_weapon(self.zombie_weapon_upgrade);
		if(isdefined(shared_ammo_weapon))
		{
			weapon = shared_ammo_weapon;
			player_has_weapon = 1;
		}
	}
	if(!player_has_weapon)
	{
		cursor_hint = "HINT_WEAPON";
		cost = zm_weapons::get_weapon_cost(weapon);
		if(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)
		{
			if(player bgb::is_enabled("zm_bgb_secret_shopper") && !zm_weapons::is_wonder_weapon(player.currentweapon))
			{
				hint_string = &"ZOMBIE_WEAPONCOSTONLY_CFILL_BGB_SECRET_SHOPPER";
				self sethintstringforplayer(player, hint_string);
			}
			else
			{
				hint_string = &"ZOMBIE_WEAPONCOSTONLY_CFILL";
				self sethintstringforplayer(player, hint_string);
			}
		}
		else if(player bgb::is_enabled("zm_bgb_secret_shopper") && !zm_weapons::is_wonder_weapon(player.currentweapon))
		{
			hint_string = &"ZOMBIE_WEAPONCOSTONLYFILL_BGB_SECRET_SHOPPER";
			n_bgb_cost = player zm_weapons::get_ammo_cost_for_weapon(player.currentweapon);
			self sethintstringforplayer(player, hint_string, cost, n_bgb_cost);
		}
		else
		{
			hint_string = &"ZOMBIE_WEAPONCOSTONLYFILL";
			self sethintstringforplayer(player, hint_string, cost);
		}
	}
	else if(player bgb::is_enabled("zm_bgb_secret_shopper") && !zm_weapons::is_wonder_weapon(weapon))
	{
		ammo_cost = player zm_weapons::get_ammo_cost_for_weapon(weapon);
	}
	else if(player zm_weapons::has_upgrade(weapon))
	{
		ammo_cost = zm_weapons::get_upgraded_ammo_cost(weapon);
	}
	else
	{
		ammo_cost = zm_weapons::get_ammo_cost(weapon);
	}
	if(isdefined(level.weapon_cost_client_filled) && level.weapon_cost_client_filled)
	{
		if(player bgb::is_enabled("zm_bgb_secret_shopper") && !zm_weapons::is_wonder_weapon(player.currentweapon))
		{
			hint_string = &"ZOMBIE_WEAPONAMMOONLY_CFILL_BGB_SECRET_SHOPPER";
			self sethintstringforplayer(player, hint_string);
		}
		else
		{
			hint_string = &"ZOMBIE_WEAPONAMMOONLY_CFILL";
			self sethintstringforplayer(player, hint_string);
		}
	}
	else if(player bgb::is_enabled("zm_bgb_secret_shopper") && !zm_weapons::is_wonder_weapon(player.currentweapon))
	{
		hint_string = &"ZOMBIE_WEAPONAMMOONLY_BGB_SECRET_SHOPPER";
		n_bgb_cost = player zm_weapons::get_ammo_cost_for_weapon(player.currentweapon);
		self sethintstringforplayer(player, hint_string, ammo_cost, n_bgb_cost);
	}
	else
	{
		hint_string = &"ZOMBIE_WEAPONAMMOONLY";
		self sethintstringforplayer(player, hint_string, ammo_cost);
	}
	cursor_hint = "HINT_WEAPON";
	cursor_hint_weapon = weapon;
	self setcursorhint(cursor_hint, cursor_hint_weapon);
	return 1;
}

/*
	Name: function_d7993b3d
	Namespace: zm_train
	Checksum: 0x619407B6
	Offset: 0x1C18
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_d7993b3d(trigger)
{
	self.var_5823efe0 = self.model;
	self setmodel("wpn_t7_none_world");
	trigger waittill(#"trigger");
	self setmodel(self.var_5823efe0);
}

/*
	Name: zombie_init
	Namespace: zm_train
	Checksum: 0x11518FA2
	Offset: 0x1C88
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function zombie_init()
{
	self.locked_in_train = 0;
}

/*
	Name: autosend_train
	Namespace: zm_train
	Checksum: 0xDD56E2FA
	Offset: 0x1CA0
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function autosend_train()
{
	level flag::wait_till("connect_start_to_junction");
	[[ level.o_zod_train ]]->send_train();
}

#namespace czmtrain;

/*
	Name: __constructor
	Namespace: czmtrain
	Checksum: 0x1AA5265D
	Offset: 0x1CE0
	Size: 0x226
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
	self.var_36e768e4 = undefined;
	self.m_s_trigger = undefined;
	self.m_t_switch = undefined;
	self.m_e_volume = undefined;
	self.m_b_facing_forward = 1;
	self.m_b_free = 0;
	self.m_b_incoming = 0;
	self.var_c2e30cf8 = [];
	self.m_a_mdl_doors = [];
	self.m_str_station = undefined;
	self.m_str_destination = undefined;
	self.m_a_zombies_locked_in = [];
	self.m_n_last_jumper_time = 0;
	self.m_a_jumptags = [];
	self.var_9e0dc993 = 1;
	a_names = array("tag_enter_back_top", "tag_enter_front_top", "tag_enter_left_top", "tag_enter_right_top");
	a_anims = array("ai_zombie_zod_train_win_trav_from_roof_b", "ai_zombie_zod_train_win_trav_from_roof_f", "ai_zombie_zod_train_win_trav_from_roof_l", "ai_zombie_zod_train_win_trav_from_roof_r");
	/#
		assert(a_names.size == a_anims.size);
	#/
	for(i = 0; i < a_names.size; i++)
	{
		str_name = a_names[i];
		str_anim = a_anims[i];
		self.m_a_jumptags[str_name] = spawnstruct();
		s_entrance = self.m_a_jumptags[str_name];
		s_entrance.str_tag = str_name;
		s_entrance.str_anim = str_anim;
		s_entrance.occupied = 0;
	}
}

/*
	Name: debug_draw_paths
	Namespace: czmtrain
	Checksum: 0xB1E15503
	Offset: 0x1F10
	Size: 0x410
	Parameters: 0
	Flags: Linked
*/
function debug_draw_paths()
{
	/#
		do
		{
			n_debug = getdvarint("");
			wait(1);
		}
		while(!isdefined(n_debug) || n_debug <= 0);
		while(true)
		{
			a_keys = getarraykeys(self.var_c2e30cf8);
			for(key_num = 0; key_num < self.var_c2e30cf8.size; key_num++)
			{
				j = a_keys[key_num];
				node_set = self.var_c2e30cf8[j].nodes;
				for(i = 0; i < node_set.size; i++)
				{
					node = node_set[i];
					node_pos = node.origin + vectorscale((0, 0, -1), 95);
					debugstar(node_pos, 1, (1, 0, 0));
					if(isdefined(node.target))
					{
						node_target = getvehiclenode(node.target, "");
						node_target_pos = node_target.origin + vectorscale((0, 0, -1), 70);
						line(node_pos, node_target_pos, (0, 1, 0), 0, 1);
						debugstar(node_target_pos, 1, (0, 1, 0));
					}
					if(isdefined(node.target2))
					{
						var_dc338423 = getvehiclenode(node.target2, "");
						var_e9bd3ba0 = var_dc338423.origin + vectorscale((0, 0, -1), 120);
						line(node_pos, var_e9bd3ba0, (0, 0, 1), 0, 1);
						debugstar(var_e9bd3ba0, 1, (0, 0, 1));
					}
				}
			}
			a_zombies = getaiteamarray(level.zombie_team);
			foreach(var_ca8afd1, ai in a_zombies)
			{
				if(isdefined(ai.locked_in_train) && ai.locked_in_train)
				{
					print3d(ai.origin + vectorscale((0, 0, 1), 100), "" + self.m_a_zombies_locked_in.size + "", vectorscale((0, 1, 0), 255), 1);
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_35ac589d
	Namespace: czmtrain
	Checksum: 0xBBCBF00E
	Offset: 0x2328
	Size: 0x318
	Parameters: 0
	Flags: Linked
*/
function function_35ac589d()
{
	do
	{
		n_debug = getdvarint("train_debug_doors");
		wait(1);
	}
	while(!isdefined(n_debug) || n_debug <= 0);
	while(true)
	{
		duration = 1;
		var_6ffe9d93 = 240;
		var_4dc5a359 = 12;
		origin = self.var_36e768e4.origin;
		origin = origin + vectorscale((0, 0, -1), 90);
		forward = anglestoforward(self.var_36e768e4.angles);
		right = anglestoright(self.var_36e768e4.angles);
		if(!self.m_b_facing_forward)
		{
			forward = -1 * forward;
		}
		var_bba032ca = origin + var_6ffe9d93 * forward;
		/#
			line(origin, var_bba032ca, (1, 0, 0), 1, 1, duration);
		#/
		/#
			line(var_bba032ca, var_bba032ca - var_4dc5a359 * forward - var_4dc5a359 * right, (1, 0, 0), 1, 1, duration);
		#/
		/#
			line(var_bba032ca, var_bba032ca - var_4dc5a359 * forward + var_4dc5a359 * right, (1, 0, 0), 1, 1, duration);
		#/
		foreach(var_f8b1571, e_door in self.m_a_mdl_doors)
		{
			var_d4280494 = e_door.origin;
			open = function_39fb130f(e_door);
			str_state = "closed";
			if(open)
			{
				str_state = "open";
			}
			/#
				print3d(var_d4280494, str_state, (0, 0, 1), 1, 1, duration);
			#/
		}
		wait(0.05);
	}
}

/*
	Name: switch_path_direction
	Namespace: czmtrain
	Checksum: 0x8B0F3DEB
	Offset: 0x2648
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function switch_path_direction(all_nodes, direction)
{
	for(i = 0; i < all_nodes.size; i++)
	{
		prev_target = all_nodes[i].target;
		all_nodes[i].target = all_nodes[i].target2;
		all_nodes[i].target2 = prev_target;
	}
	return !direction;
}

/*
	Name: enable_train_switches
	Namespace: czmtrain
	Checksum: 0xB675E256
	Offset: 0x26F8
	Size: 0xB8
	Parameters: 1
	Flags: Linked
*/
function enable_train_switches(b_enabled)
{
	if(b_enabled)
	{
		self flag::set("switches_enabled");
		self.m_t_switch sethintstring(&"ZM_ZOD_SWITCH_ENABLE");
		function_ca899bfc();
	}
	else
	{
		self flag::clear("switches_enabled");
		self.m_t_switch sethintstring(&"ZM_ZOD_SWITCH_DISABLE");
		self.var_36e768e4 notify(#"hash_51689c0f");
	}
}

/*
	Name: function_8cf8e3a5
	Namespace: czmtrain
	Checksum: 0x4B6CC725
	Offset: 0x27B8
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function function_8cf8e3a5()
{
	return self.var_36e768e4;
}

/*
	Name: function_a8e2d7ff
	Namespace: czmtrain
	Checksum: 0x99DAB385
	Offset: 0x27D0
	Size: 0x228
	Parameters: 0
	Flags: Linked
*/
function function_a8e2d7ff()
{
	var_aed9540e = [];
	var_aed9540e["moving"] = getentarray("lgt_train_lightrig_veh_placement", "targetname");
	var_aed9540e["canals"] = getentarray("lgt_train_lightrig_canals_debug", "targetname");
	var_aed9540e["slums"] = getentarray("lgt_train_lightrig_slums_debug", "targetname");
	var_aed9540e["theater"] = getentarray("lgt_train_lightrig_theater_debug", "targetname");
	var_105cc375 = vectorscale((0, 1, 0), 45);
	self enablelinkto();
	foreach(var_b4778b9e, var_83e6406e in var_aed9540e)
	{
		foreach(var_a054d9e0, var_66fccd7 in var_83e6406e)
		{
			var_66fccd7.origin = self.origin;
			var_66fccd7.angles = self.angles + var_105cc375;
			var_66fccd7 linkto(self);
		}
	}
}

/*
	Name: function_ae26c4a8
	Namespace: czmtrain
	Checksum: 0x82585757
	Offset: 0x2A00
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function function_ae26c4a8()
{
	return self.m_str_station;
}

/*
	Name: get_current_destination
	Namespace: czmtrain
	Checksum: 0xB5995F60
	Offset: 0x2A18
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function get_current_destination()
{
	if(self.var_c2e30cf8[self.m_str_station].var_bd2282e4)
	{
		return self.var_c2e30cf8[self.m_str_station].left_path;
	}
	return self.var_c2e30cf8[self.m_str_station].right_path;
}

/*
	Name: watch_node_parameters
	Namespace: czmtrain
	Checksum: 0x320F6EBF
	Offset: 0x2A80
	Size: 0x15A
	Parameters: 0
	Flags: Linked
*/
function watch_node_parameters()
{
	self.var_36e768e4 endon(#"docked_in_station");
	while(true)
	{
		self.var_36e768e4 waittill(#"reached_node", nd);
		if(isdefined(nd.script_parameters))
		{
			switch(nd.script_parameters)
			{
				case "arrival_brakes":
				{
					if(self.m_b_incoming)
					{
						self.var_36e768e4 playsound("evt_train_stop");
						self.var_36e768e4 stoploopsound(3);
					}
					break;
				}
				case "arrival_bell":
				{
					if(self.m_b_incoming)
					{
						e_callbox = self.var_c2e30cf8[self.m_str_destination].callbox;
						e_callbox playsound("evt_train_station_bell");
					}
					break;
				}
				default:
				{
					/#
						assertmsg("" + nd.script_parameters);
					#/
					break;
				}
			}
		}
	}
}

/*
	Name: function_7eb2583b
	Namespace: czmtrain
	Checksum: 0x8836593C
	Offset: 0x2BE8
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function function_7eb2583b()
{
	timeout = 15;
	while(timeout > 0 && self flag::get("moving"))
	{
		timeout = timeout - 1;
		wait(1);
	}
}

/*
	Name: move
	Namespace: czmtrain
	Checksum: 0x47B4E91
	Offset: 0x2C48
	Size: 0x604
	Parameters: 0
	Flags: Linked
*/
function move()
{
	self.m_b_incoming = 0;
	str_start = self.m_str_station;
	str_left = self.var_c2e30cf8[str_start].left_path;
	str_right = self.var_c2e30cf8[str_start].right_path;
	if(self.var_c2e30cf8[str_start].path_toward_junction == 0)
	{
		self.var_36e768e4 flip180();
		self.var_c2e30cf8[str_start].path_toward_junction = switch_path_direction(self.var_c2e30cf8[str_start].nodes, self.var_c2e30cf8[str_start].path_toward_junction);
		self.var_36e768e4 switchstartnode(self.var_c2e30cf8[str_start].start_node, self.var_c2e30cf8[str_start].junction_node);
	}
	if(self.var_c2e30cf8[str_left].path_toward_junction == 1)
	{
		self.var_c2e30cf8[str_left].path_toward_junction = switch_path_direction(self.var_c2e30cf8[str_left].nodes, self.var_c2e30cf8[str_left].path_toward_junction);
		self.var_36e768e4 switchstartnode(self.var_c2e30cf8[str_left].start_node, self.var_c2e30cf8[str_left].junction_node);
	}
	if(self.var_c2e30cf8[str_right].path_toward_junction == 1)
	{
		self.var_c2e30cf8[str_right].path_toward_junction = switch_path_direction(self.var_c2e30cf8[str_right].nodes, self.var_c2e30cf8[str_right].path_toward_junction);
		self.var_36e768e4 switchstartnode(self.var_c2e30cf8[str_right].start_node, self.var_c2e30cf8[str_right].junction_node);
	}
	sndnum = self.var_c2e30cf8[self.m_str_destination].audio_depart;
	level clientfield::set("sndTrainVox", sndnum);
	self.var_36e768e4 playsoundontag(level.var_98f27ad[sndnum - 1], "tag_support_arm_01");
	thread watch_node_parameters();
	self.var_36e768e4 recalcsplinepaths();
	self.var_36e768e4 attachpath(self.var_c2e30cf8[str_start].start_node);
	self.var_36e768e4 startpath();
	while(distance2dsquared(self.var_36e768e4.origin, self.var_c2e30cf8[str_start].junction_node.origin) > 122500)
	{
		util::wait_network_frame();
	}
	enable_train_switches(0);
	thread function_a377ba46();
	str_chosen_path = str_left;
	if(!self.var_c2e30cf8[str_start].var_bd2282e4)
	{
		str_chosen_path = str_right;
	}
	which_way = self.var_c2e30cf8[str_chosen_path].junction_node;
	self.var_36e768e4 setswitchnode(self.var_c2e30cf8[str_start].junction_node, self.var_c2e30cf8[str_chosen_path].junction_node);
	self.m_b_incoming = 1;
	self.var_97fef807 = str_chosen_path;
	level flag::set(self.var_c2e30cf8[str_chosen_path].var_6ac14e0c);
	self.var_36e768e4 waittill(#"reached_end_node");
	self.m_b_facing_forward = !self.m_b_facing_forward;
	self.m_str_station = str_chosen_path;
	self.m_str_destination = get_current_destination();
	self.var_36e768e4 notify(#"docked_in_station", self.m_str_station);
	sndnum = self.var_c2e30cf8[self.m_str_station].audio_arrive;
	level clientfield::set("sndTrainVox", sndnum);
	self.var_36e768e4 playsoundontag(level.var_98f27ad[sndnum - 1], "tag_support_arm_01");
}

/*
	Name: function_eb9ee200
	Namespace: czmtrain
	Checksum: 0x275C672C
	Offset: 0x3258
	Size: 0x13E
	Parameters: 1
	Flags: Linked
*/
function function_eb9ee200(spawnpos)
{
	foreach(var_aedb9a10, e_player in level.players)
	{
		if(!zm_utility::is_player_valid(e_player, 0, 0))
		{
			continue;
		}
		porigin = e_player.origin;
		if(abs(porigin[2] - spawnpos[2]) > 60)
		{
			continue;
		}
		distance_apart = distance2d(porigin, spawnpos);
		if(abs(distance_apart) > 18)
		{
			continue;
		}
		return 0;
	}
	return 1;
}

/*
	Name: function_a9acf9e2
	Namespace: czmtrain
	Checksum: 0xDBC35E55
	Offset: 0x33A0
	Size: 0x402
	Parameters: 0
	Flags: Linked
*/
function function_a9acf9e2()
{
	var_e19f73fe = [];
	foreach(var_d6365ea5, e_player in level.players)
	{
		if(is_touching_train(e_player))
		{
			/#
				if(e_player isinmovemode("", ""))
				{
					continue;
				}
			#/
			if(!zm_utility::is_player_valid(e_player, 1, 0))
			{
				continue;
			}
			e_player.var_e51032ec = gettime();
			if(!isdefined(var_e19f73fe))
			{
				var_e19f73fe = [];
			}
			else if(!isarray(var_e19f73fe))
			{
				var_e19f73fe = array(var_e19f73fe);
			}
			var_e19f73fe[var_e19f73fe.size] = e_player;
		}
	}
	self.var_36e768e4 waittill(#"docked_in_station");
	var_1a8b64d3 = self.var_36e768e4 getcentroid();
	var_10b9b744 = 0;
	foreach(var_9713f65c, e_player in var_e19f73fe)
	{
		/#
			if(e_player isinmovemode("", ""))
			{
				continue;
			}
		#/
		if(!zm_utility::is_player_valid(e_player, 1, 0))
		{
			continue;
		}
		if(!isdefined(e_player.var_e51032ec))
		{
			continue;
		}
		if(isdefined(e_player.last_bleed_out_time) && e_player.last_bleed_out_time > e_player.var_e51032ec)
		{
			continue;
		}
		if(!is_touching_train(e_player))
		{
			fatal = 0;
			do
			{
				spawnpos = var_1a8b64d3;
				switch(var_10b9b744)
				{
					case 0:
					{
						spawnpos = spawnpos + vectorscale((1, 1, 0), 36);
						break;
					}
					case 1:
					{
						spawnpos = spawnpos + vectorscale((-1, -1, 0), 36);
						break;
					}
					case 2:
					{
						spawnpos = spawnpos + vectorscale((1, -1, 0), 36);
						break;
					}
					case 3:
					{
						spawnpos = spawnpos + vectorscale((-1, 1, 0), 36);
						break;
					}
					case 4:
					{
						e_player dodamage(1000, (0, 0, 0));
						fatal = 1;
						jump loc_0000374E;
					}
				}
				var_10b9b744++;
			}
			while(!fatal && !function_eb9ee200(spawnpos));
			e_player setorigin(spawnpos);
		}
	}
}

/*
	Name: function_dda9a9d2
	Namespace: czmtrain
	Checksum: 0x4FA3ACD0
	Offset: 0x37B0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function function_dda9a9d2()
{
	self.m_b_facing_forward = !self.m_b_facing_forward;
}

/*
	Name: function_aaacaec9
	Namespace: czmtrain
	Checksum: 0x7762DE6C
	Offset: 0x37D0
	Size: 0x922
	Parameters: 0
	Flags: Linked
*/
function function_aaacaec9()
{
	self.var_c2e30cf8 = [];
	a_path_nodes = getnodearray("train_pathnode", "targetname");
	foreach(var_deed7019, nd in a_path_nodes)
	{
		str_station = nd.script_string;
		self.var_c2e30cf8[str_station] = spawnstruct();
		self.var_c2e30cf8[str_station].path_node = nd;
		self.var_c2e30cf8[str_station].origin = nd.origin;
		self.var_c2e30cf8[str_station].angles = nd.angles;
		self.var_c2e30cf8[str_station].station_id = str_station;
		self.var_c2e30cf8[str_station].door_side = nd.script_parameters;
	}
	self.var_c2e30cf8["slums"].left_path = "canal";
	self.var_c2e30cf8["slums"].right_path = "theater";
	self.var_c2e30cf8["slums"].var_bd2282e4 = 0;
	self.var_c2e30cf8["slums"].var_6ac14e0c = "activate_slums_waterfront";
	self.var_c2e30cf8["slums"].audio_divert = 8;
	self.var_c2e30cf8["slums"].audio_depart = 5;
	self.var_c2e30cf8["slums"].audio_arrive = 1;
	self.var_c2e30cf8["slums"].start_node = getvehiclenode("a1", "targetname");
	self.var_c2e30cf8["theater"].left_path = "slums";
	self.var_c2e30cf8["theater"].right_path = "canal";
	self.var_c2e30cf8["theater"].var_bd2282e4 = 0;
	self.var_c2e30cf8["theater"].var_6ac14e0c = "activate_theater_square";
	self.var_c2e30cf8["theater"].audio_divert = 9;
	self.var_c2e30cf8["theater"].audio_depart = 6;
	self.var_c2e30cf8["theater"].audio_arrive = 2;
	self.var_c2e30cf8["theater"].start_node = getvehiclenode("b1", "targetname");
	self.var_c2e30cf8["canal"].left_path = "theater";
	self.var_c2e30cf8["canal"].right_path = "slums";
	self.var_c2e30cf8["canal"].var_bd2282e4 = 0;
	self.var_c2e30cf8["canal"].var_6ac14e0c = "activate_brothel_street";
	self.var_c2e30cf8["canal"].audio_divert = 7;
	self.var_c2e30cf8["canal"].audio_depart = 4;
	self.var_c2e30cf8["canal"].audio_arrive = 3;
	self.var_c2e30cf8["canal"].start_node = getvehiclenode("c1", "targetname");
	level.var_98f27ad = array("vox_tanc_board_canal_0", "vox_tanc_board_slums_0", "vox_tanc_board_theater_0", "vox_tanc_depart_canal_0", "vox_tanc_depart_slums_0", "vox_tanc_depart_theater_0", "vox_tanc_divert_canal_0", "vox_tanc_divert_slums_0", "vox_tanc_divert_theater_0");
	a_keys = getarraykeys(self.var_c2e30cf8);
	for(i = 0; i < a_keys.size; i++)
	{
		str_key = a_keys[i];
		nd_next = self.var_c2e30cf8[str_key].start_node;
		nd_prev = undefined;
		self.var_c2e30cf8[str_key].nodes = [];
		while(isdefined(nd_next))
		{
			if(isdefined(nd_prev))
			{
				nd_next.target2 = nd_prev.targetname;
			}
			if(!isdefined(self.var_c2e30cf8[str_key].nodes))
			{
				self.var_c2e30cf8[str_key].nodes = [];
			}
			else if(!isarray(self.var_c2e30cf8[str_key].nodes))
			{
				self.var_c2e30cf8[str_key].nodes = array(self.var_c2e30cf8[str_key].nodes);
			}
			self.var_c2e30cf8[str_key].nodes[self.var_c2e30cf8[str_key].nodes.size] = nd_next;
			nd_prev = nd_next;
			if(!isdefined(nd_next.target))
			{
				break;
			}
			else
			{
				nd_next = getvehiclenode(nd_next.target, "targetname");
			}
		}
		num_nodes = self.var_c2e30cf8[str_key].nodes.size;
		self.var_c2e30cf8[str_key].junction_node = self.var_c2e30cf8[str_key].nodes[num_nodes - 1];
		self.var_c2e30cf8[str_key].path_toward_junction = 1;
	}
	a_callboxes = getentarray("train_call_lever", "targetname");
	foreach(var_79a018f7, e_callbox in a_callboxes)
	{
		var_374d0b9b = arraygetclosest(e_callbox.origin, self.var_c2e30cf8);
		/#
			assert(isdefined(var_374d0b9b));
		#/
		e_callbox.script_string = var_374d0b9b.station_id;
		var_374d0b9b.callbox = e_callbox;
	}
}

/*
	Name: initialize
	Namespace: czmtrain
	Checksum: 0x5CAA134C
	Offset: 0x4100
	Size: 0x8B2
	Parameters: 1
	Flags: Linked
*/
function initialize(e_train)
{
	/#
		assert(isdefined(e_train));
	#/
	self.var_36e768e4 = e_train;
	self.var_36e768e4.var_619deb2d = 0;
	self.var_36e768e4.var_901503d0 = 0;
	if(!self flag::exists("moving"))
	{
		self flag::init("moving", 0);
	}
	if(!self flag::exists("cooldown"))
	{
		self flag::init("cooldown", 0);
	}
	if(!self flag::exists("offline"))
	{
		self flag::init("offline", 0);
	}
	if(!self flag::exists("switches_enabled"))
	{
		self flag::init("switches_enabled", 1);
	}
	if(!level flag::exists("callbox"))
	{
		level flag::init("callbox");
	}
	self.var_36e768e4.team = "spectator";
	function_aaacaec9();
	/#
		thread debug_draw_paths();
		thread function_35ac589d();
	#/
	a_e_children = getentarray(self.var_36e768e4.target, "targetname");
	foreach(var_1051b86f, e_ent in a_e_children)
	{
		if(isdefined(e_ent.script_string))
		{
			if(e_ent.script_string == "train_volume")
			{
				if(!isdefined(self.m_e_volume))
				{
					/#
						assert(!isdefined(self.m_e_volume));
					#/
					e_ent enablelinkto();
					self.m_e_volume = e_ent;
				}
			}
			else if(e_ent.script_string == "train_rear_door" || e_ent.script_string == "train_front_door")
			{
				if(!isdefined(e_ent.script_origin))
				{
					e_ent.script_origin = spawn("script_origin", e_ent.origin);
					e_ent.script_origin.angles = self.var_36e768e4.angles;
					e_ent.script_origin linkto(self.var_36e768e4);
				}
				if(!isdefined(self.m_a_mdl_doors))
				{
					self.m_a_mdl_doors = [];
				}
				else if(!isarray(self.m_a_mdl_doors))
				{
					self.m_a_mdl_doors = array(self.m_a_mdl_doors);
				}
				self.m_a_mdl_doors[self.m_a_mdl_doors.size] = e_ent;
			}
			e_ent linkto(self.var_36e768e4);
			continue;
		}
		/#
			iprintlnbold("" + zm_zod_util::vec_to_string(e_ent.origin) + "");
		#/
	}
	function_6f6ab7a4();
	/#
		if(!isdefined(self.m_e_volume))
		{
			/#
				assertmsg("" + zm_zod_util::vec_to_string(self.var_36e768e4.origin) + "");
			#/
		}
	#/
	self.var_36e768e4 function_a8e2d7ff();
	self.m_t_switch = getent("m_s_switch_trigger", "targetname");
	self.m_t_switch triggerignoreteam();
	self.m_t_switch setteamfortrigger("none");
	self.m_t_switch sethintstring(&"ZM_ZOD_SWITCH_DISABLE");
	self.m_t_switch setcursorhint("HINT_NOICON");
	self.m_t_switch enablelinkto();
	self.m_t_switch linkto(self.var_36e768e4);
	self.m_t_switch.player_used = 0;
	thread main();
	a_callboxes = getentarray("train_call_lever", "targetname");
	foreach(var_c0a57120, e_callbox in a_callboxes)
	{
		thread run_callbox(e_callbox.script_string);
	}
	a_gates = getentarray("train_gate", "targetname");
	foreach(var_10fe41d1, gate in a_gates)
	{
		station = self.var_c2e30cf8[gate.script_string];
		if(!isdefined(station.gates))
		{
			station.gates = [];
		}
		if(!isdefined(station.gates))
		{
			station.gates = [];
		}
		else if(!isarray(station.gates))
		{
			station.gates = array(station.gates);
		}
		station.gates[station.gates.size] = gate;
		jump_nodes = getnodearray(station.path_node.target, "targetname");
		self thread run_gate(gate, jump_nodes);
	}
}

/*
	Name: function_6f6ab7a4
	Namespace: czmtrain
	Checksum: 0x3A33B794
	Offset: 0x49C0
	Size: 0x1AA
	Parameters: 0
	Flags: Linked
*/
function function_6f6ab7a4()
{
	for(i = 0; i < self.m_a_mdl_doors.size; i++)
	{
		e_door = self.m_a_mdl_doors[i];
		e_door hide();
		if(e_door.script_string == "train_front_door")
		{
			e_door.e_clip = getent("train_front_clip", "script_string");
		}
		else if(e_door.script_string == "train_rear_door")
		{
			e_door.e_clip = getent("train_rear_clip", "script_string");
		}
		if(isdefined(e_door.e_clip))
		{
			e_origin = spawn("script_origin", e_door.e_clip.origin);
			e_origin.angles = self.var_36e768e4.angles;
			e_origin linkto(self.var_36e768e4);
			e_door.e_clip.var_b620e1b1 = e_origin;
		}
	}
}

/*
	Name: main
	Namespace: czmtrain
	Checksum: 0xC784593D
	Offset: 0x4B78
	Size: 0x7B0
	Parameters: 0
	Flags: Linked
*/
function main()
{
	a_path_names = getarraykeys(self.var_c2e30cf8);
	a_path_names = array::randomize(a_path_names);
	self.m_str_station = a_path_names[0];
	self.var_97fef807 = self.m_str_station;
	self.var_c2e30cf8[self.m_str_station].var_bd2282e4 = randomint(2);
	self.m_str_destination = get_current_destination();
	self.var_36e768e4 attachpath(self.var_c2e30cf8[self.m_str_station].start_node);
	b_first_run = 1;
	self thread function_876255();
	self thread watch_players_on_train();
	self thread function_955e57a7();
	wait(1);
	v_front = self.var_36e768e4 gettagorigin("tag_button_front");
	self.m_s_trigger = zm_zod_util::spawn_trigger_radius(v_front, 60, 1);
	self.var_36e768e4 playloopsound("evt_train_idle_loop", 4);
	open_doors();
	thread run_switch();
	while(true)
	{
		update_use_trigger();
		enable_train_switches(1);
		level thread function_b0af9dac();
		while(true)
		{
			self.var_36e768e4 clientfield::set("train_switch_light", 1);
			self.m_s_trigger waittill(#"trigger", e_who);
			self.var_36e768e4 clientfield::set("train_switch_light", 0);
			if(self.m_b_free)
			{
				self.m_b_free = 0;
				break;
			}
			else if(!e_who zm_score::can_player_purchase(500))
			{
				e_who zm_audio::create_and_play_dialog("general", "transport_deny");
			}
			else
			{
				e_who zm_score::minus_to_player_score(500);
				e_who zm_audio::create_and_play_dialog("train", "start");
				break;
			}
		}
		level.var_33c4ee76++;
		thread function_a377ba46();
		wait(0.05);
		self flag::set("moving");
		zm_unitrigger::unregister_unitrigger(self.m_s_trigger);
		self.m_s_trigger = undefined;
		close_doors();
		self.var_36e768e4 playsound("evt_train_start");
		self.var_36e768e4 playloopsound("evt_train_loop", 4);
		var_8d722bd4 = function_ccd778ab();
		if(var_8d722bd4 || b_first_run)
		{
			self.var_36e768e4 setspeed(32);
		}
		else
		{
			level.b_host_migration_force_player_respawn = 1;
			thread function_a9acf9e2();
		}
		move();
		self.var_36e768e4 playloopsound("evt_train_idle_loop", 4);
		a_riders = get_players_on_train(0);
		if(a_riders.size > 0)
		{
			level flag::set(self.var_c2e30cf8[self.m_str_station].var_6ac14e0c);
			level flag::set("train_rode_to_" + self.m_str_station);
		}
		if(var_8d722bd4 || b_first_run)
		{
			self.var_36e768e4 resumespeed();
		}
		if(b_first_run)
		{
			b_first_run = 0;
		}
		open_doors();
		a_riders = get_players_on_train(0);
		if(a_riders.size > 0)
		{
			var_3a349c58 = a_riders[randomint(a_riders.size)];
			var_3a349c58 zm_audio::create_and_play_dialog("train", "stop");
		}
		v_trig = (0, 0, 0);
		if(!self.m_b_facing_forward)
		{
			v_trig = self.var_36e768e4 gettagorigin("tag_button_back");
		}
		else
		{
			v_trig = self.var_36e768e4 gettagorigin("tag_button_front");
		}
		self flag::clear("moving");
		level.b_host_migration_force_player_respawn = 0;
		self function_312bb6e1();
		if(!self.m_b_free && level.var_33c4ee76 > 0)
		{
			self flag::set("cooldown");
			update_use_trigger();
			n_wait = 40;
			/#
				if(getdvarint("") > 0)
				{
					n_wait = 5;
				}
			#/
			wait(n_wait);
			self.m_s_trigger = zm_zod_util::spawn_trigger_radius(v_trig, 60, 1);
			self flag::clear("cooldown");
		}
		else
		{
			self.m_s_trigger = zm_zod_util::spawn_trigger_radius(v_trig, 60, 1);
		}
	}
}

/*
	Name: function_a377ba46
	Namespace: czmtrain
	Checksum: 0x722C5A18
	Offset: 0x5330
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_a377ba46()
{
	if(flag::get("moving"))
	{
		var_38c97a3b = get_current_destination();
	}
	else
	{
		var_38c97a3b = self.m_str_station;
	}
	switch(var_38c97a3b)
	{
		case "slums":
		{
			var_bddb9113 = "lgt_exp_train_slums_debug";
			break;
		}
		case "canal":
		{
			var_bddb9113 = "lgt_exp_train_canals_debug";
			break;
		}
		case "theater":
		{
			var_bddb9113 = "lgt_exp_train_theater_debug";
			break;
		}
	}
	if(flag::get("moving"))
	{
		exploder::exploder(var_bddb9113);
	}
	else
	{
		wait(2);
		exploder::exploder_stop(var_bddb9113);
	}
}

/*
	Name: function_312bb6e1
	Namespace: czmtrain
	Checksum: 0xFD33D9E3
	Offset: 0x5440
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_312bb6e1()
{
	level endon(#"hash_12be7dbb");
	if(level flag::get("ee_boss_defeated") && !level flag::get("ee_final_boss_defeated"))
	{
		return;
	}
	if(level.var_33c4ee76 < 5)
	{
		return;
	}
	self flag::set("offline");
	self.var_36e768e4 clientfield::set("train_switch_light", 2);
	update_use_trigger();
	level waittill(#"between_round_over");
	self flag::clear("offline");
	wait(0.05);
}

/*
	Name: function_955e57a7
	Namespace: czmtrain
	Checksum: 0xB2896446
	Offset: 0x5538
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_955e57a7()
{
	level flag::wait_till("ee_boss_defeated");
	level notify(#"hash_12be7dbb");
	self flag::clear("offline");
	update_use_trigger();
}

/*
	Name: function_b0af9dac
	Namespace: czmtrain
	Checksum: 0x6D6EFD06
	Offset: 0x55A0
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function function_b0af9dac()
{
	while(true)
	{
		level waittill(#"between_round_over");
		level.var_33c4ee76 = 0;
		wait(0.05);
	}
}

/*
	Name: run_callbox_hintstring
	Namespace: czmtrain
	Checksum: 0x47FC1C3E
	Offset: 0x55D8
	Size: 0x258
	Parameters: 3
	Flags: Linked
*/
function run_callbox_hintstring(str_callbox, t_use, e_light)
{
	while(true)
	{
		if(self.m_str_station == str_callbox)
		{
			e_light clientfield::set("train_callbox_light", 0);
			t_use zm_zod_util::set_unitrigger_hint_string(&"");
		}
		else
		{
			e_light clientfield::set("train_callbox_light", 1);
			t_use zm_zod_util::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_CALL", 500);
		}
		self flag::wait_till("moving");
		e_light clientfield::set("train_callbox_light", 0);
		t_use zm_zod_util::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_MOVING");
		self flag::wait_till_clear("moving");
		wait(0.05);
		if(self flag::get("offline"))
		{
			t_use zm_zod_util::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_OFFLINE");
			e_light clientfield::set("train_callbox_light", 2);
			self flag::wait_till_clear("offline");
		}
		else if(self.m_str_station == str_callbox)
		{
			t_use zm_zod_util::set_unitrigger_hint_string(&"");
			self flag::wait_till_clear("cooldown");
		}
		else
		{
			t_use zm_zod_util::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_COOLDOWN");
			self flag::wait_till_clear("cooldown");
		}
	}
}

/*
	Name: run_callbox
	Namespace: czmtrain
	Checksum: 0x83A1C33E
	Offset: 0x5838
	Size: 0x260
	Parameters: 1
	Flags: Linked
*/
function run_callbox(str_callbox)
{
	/#
		assert(isdefined(self.m_str_station));
	#/
	e_lever = self.var_c2e30cf8[str_callbox].callbox;
	t_use = zm_zod_util::spawn_trigger_radius(e_lever.origin, 60, 1);
	thread run_callbox_hintstring(str_callbox, t_use, getent(e_lever.target, "targetname"));
	while(true)
	{
		t_use waittill(#"trigger", e_who);
		if(!e_who zm_score::can_player_purchase(500))
		{
			e_who zm_audio::create_and_play_dialog("general", "transport_deny");
			continue;
		}
		if(self.m_str_station != str_callbox && isdefined(self.m_s_trigger))
		{
			self.m_b_free = 0;
			if(str_callbox != self.m_str_destination)
			{
				level flag::set("callbox");
				self.m_t_switch notify(#"trigger");
				level waittill(#"hash_8939bd21");
			}
			self.m_s_trigger notify(#"trigger", e_who);
			util::wait_network_frame();
			self.m_b_free = 1;
			e_lever rotatepitch(180, 0.5);
			self flag::wait_till("moving");
			self flag::wait_till_clear("moving");
			e_lever rotatepitch(-180, 0.5);
		}
	}
}

/*
	Name: run_gate
	Namespace: czmtrain
	Checksum: 0xF14137D4
	Offset: 0x5AA0
	Size: 0x350
	Parameters: 2
	Flags: Linked
*/
function run_gate(e_gate, a_jump_nodes)
{
	nd_start = self.var_c2e30cf8[e_gate.script_string].start_node;
	v_open = e_gate.origin;
	v_closed = v_open + anglestoforward(nd_start.angles) * 96;
	if(self.var_c2e30cf8[e_gate.script_string].door_side == "right")
	{
		v_closed = v_open - anglestoforward(nd_start.angles) * 96;
	}
	b_open = 1;
	while(true)
	{
		if(b_open)
		{
			self.var_9e0dc993 = 0;
			e_gate moveto(v_closed, 1);
			b_open = 0;
			foreach(var_4aea15cb, nd in a_jump_nodes)
			{
				unlinktraversal(nd);
			}
		}
		self flag::wait_till_clear("moving");
		if(self.m_str_station == e_gate.script_string)
		{
			e_gate moveto(v_open, 1);
			b_open = 1;
			e_gate waittill(#"movedone");
			foreach(var_645c9944, nd in a_jump_nodes)
			{
				b_fwd_node = nd.script_string === "forward";
				if(self.m_b_facing_forward && b_fwd_node || (!self.m_b_facing_forward && !b_fwd_node))
				{
					linktraversal(nd);
				}
			}
			self.var_9e0dc993 = 1;
		}
		self flag::wait_till("moving");
		wait(1);
	}
}

/*
	Name: get_door_open_pos
	Namespace: czmtrain
	Checksum: 0x6ED9E238
	Offset: 0x5DF8
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function get_door_open_pos(e_door)
{
	if(e_door.script_string == "front_door")
	{
		return e_door.script_origin.origin - anglestoforward(e_door.script_origin.angles) * 100;
	}
	return e_door.script_origin.origin + anglestoforward(e_door.script_origin.angles) * 100;
}

/*
	Name: get_door_closed_pos
	Namespace: czmtrain
	Checksum: 0xD4D64F94
	Offset: 0x5EC0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function get_door_closed_pos(e_door)
{
	return e_door.script_origin.origin;
}

/*
	Name: get_open_side
	Namespace: czmtrain
	Checksum: 0xD2C82C3A
	Offset: 0x5EF0
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function get_open_side()
{
	str_side = self.var_c2e30cf8[self.m_str_station].door_side;
	if(!self.m_b_facing_forward)
	{
		if(str_side == "left")
		{
			return "right";
		}
		if(str_side == "right")
		{
			return "left";
		}
	}
	return str_side;
}

/*
	Name: function_39fb130f
	Namespace: czmtrain
	Checksum: 0x34141D98
	Offset: 0x5F68
	Size: 0x8A
	Parameters: 1
	Flags: Linked
*/
function function_39fb130f(e_door)
{
	str_side = get_open_side();
	if(str_side == "left" && e_door.script_string == "train_rear_door" || (str_side == "right" && e_door.script_string == "train_front_door"))
	{
		return self.var_9e0dc993;
	}
	return 0;
}

/*
	Name: open_doors
	Namespace: czmtrain
	Checksum: 0x16F263C8
	Offset: 0x6000
	Size: 0x418
	Parameters: 1
	Flags: Linked
*/
function open_doors(str_side = get_open_side())
{
	self.var_36e768e4 function_59722edc(str_side);
	var_7631d55c = vectorscale((0, 0, 1), 300);
	a_doors_moved = [];
	foreach(var_95390cc9, e_door in self.m_a_mdl_doors)
	{
		if(!isdefined(str_side) || (str_side == "left" && e_door.script_string == "train_rear_door") || (str_side == "right" && e_door.script_string == "train_front_door"))
		{
			v_pos = get_door_open_pos(e_door);
			e_door unlink();
			e_door moveto(v_pos, 0.3);
			if(!isdefined(a_doors_moved))
			{
				a_doors_moved = [];
			}
			else if(!isarray(a_doors_moved))
			{
				a_doors_moved = array(a_doors_moved);
			}
			a_doors_moved[a_doors_moved.size] = e_door;
			e_door.e_clip unlink();
			e_door.e_clip moveto(e_door.e_clip.origin + var_7631d55c, 0.3);
		}
	}
	if(a_doors_moved.size > 0)
	{
		a_doors_moved[0] waittill(#"movedone");
		util::wait_network_frame();
	}
	util::wait_network_frame();
	foreach(var_ae58faa9, e_door in a_doors_moved)
	{
		v_pos = get_door_open_pos(e_door);
		e_door.origin = v_pos;
		e_door.angles = e_door.script_origin.angles;
		e_door linkto(self.var_36e768e4);
		e_door.e_clip linkto(self.var_36e768e4);
	}
	for(i = self.m_a_zombies_locked_in.size - 1; i >= 0; i--)
	{
		ai = self.m_a_zombies_locked_in[i];
		if(isdefined(ai))
		{
			remove_zombie_locked_in(ai);
		}
	}
	self.m_a_zombies_locked_in = [];
}

/*
	Name: function_59722edc
	Namespace: czmtrain
	Checksum: 0x6EA4B71E
	Offset: 0x6420
	Size: 0x88
	Parameters: 1
	Flags: Linked
*/
function function_59722edc(str_side)
{
	if(str_side == "right")
	{
		if(!self.var_901503d0)
		{
			self thread scene::play("p7_fxanim_zm_zod_train_door_rt_open_bundle", self);
			self.var_901503d0 = 1;
		}
	}
	else if(!self.var_619deb2d)
	{
		self thread scene::play("p7_fxanim_zm_zod_train_door_lft_open_bundle", self);
		self.var_619deb2d = 1;
	}
}

/*
	Name: close_doors
	Namespace: czmtrain
	Checksum: 0x2A64A2CD
	Offset: 0x64B0
	Size: 0x27C
	Parameters: 0
	Flags: Linked
*/
function close_doors()
{
	self.var_36e768e4 function_285f0f0b();
	foreach(var_3762868a, e_door in self.m_a_mdl_doors)
	{
		v_pos = get_door_closed_pos(e_door);
		e_door unlink();
		e_door moveto(v_pos, 0.3);
		e_door.e_clip unlink();
		e_door.e_clip moveto(e_door.e_clip.var_b620e1b1.origin, 0.3);
	}
	self.m_a_mdl_doors[0] waittill(#"movedone");
	util::wait_network_frame();
	foreach(var_49affa7a, e_door in self.m_a_mdl_doors)
	{
		v_pos = get_door_closed_pos(e_door);
		e_door.origin = v_pos;
		e_door.angles = e_door.script_origin.angles;
		e_door linkto(self.var_36e768e4);
		e_door.e_clip linkto(self.var_36e768e4);
	}
	thread recalc_zombies_locked_in_train();
}

/*
	Name: function_9211290c
	Namespace: czmtrain
	Checksum: 0x870CAA11
	Offset: 0x6738
	Size: 0x252
	Parameters: 0
	Flags: Linked
*/
function function_9211290c()
{
	foreach(var_d529ed2e, e_door in self.m_a_mdl_doors)
	{
		v_pos = get_door_closed_pos(e_door);
		e_door unlink();
		e_door moveto(v_pos, 0.3);
		e_door.e_clip unlink();
		e_door.e_clip moveto(e_door.e_clip.var_b620e1b1.origin, 0.3);
	}
	self.m_a_mdl_doors[0] waittill(#"movedone");
	util::wait_network_frame();
	foreach(var_ee49db0e, e_door in self.m_a_mdl_doors)
	{
		v_pos = get_door_closed_pos(e_door);
		e_door.origin = v_pos;
		e_door.angles = e_door.script_origin.angles;
		e_door linkto(self.var_36e768e4);
		e_door.e_clip linkto(self.var_36e768e4);
	}
}

/*
	Name: function_285f0f0b
	Namespace: czmtrain
	Checksum: 0xADD75752
	Offset: 0x6998
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function function_285f0f0b()
{
	if(self.var_901503d0)
	{
		self scene::play("p7_fxanim_zm_zod_train_door_rt_close_bundle", self);
		self.var_901503d0 = 0;
	}
	if(self.var_619deb2d)
	{
		self scene::play("p7_fxanim_zm_zod_train_door_lft_close_bundle", self);
		self.var_619deb2d = 0;
	}
}

/*
	Name: recalc_zombies_locked_in_train
	Namespace: czmtrain
	Checksum: 0xE99250E8
	Offset: 0x6A10
	Size: 0x12A
	Parameters: 0
	Flags: Linked
*/
function recalc_zombies_locked_in_train()
{
	zombies = getaiteamarray(level.zombie_team);
	n_counter = 0;
	foreach(var_847e86e4, zombie in zombies)
	{
		if(!isdefined(zombie) || !isalive(zombie))
		{
			continue;
		}
		if(is_touching_train_volume(zombie))
		{
			add_zombie_locked_in(zombie);
		}
		n_counter++;
		if(n_counter % 3 == 0)
		{
			util::wait_network_frame();
		}
	}
}

/*
	Name: update_use_trigger
	Namespace: czmtrain
	Checksum: 0x169B5F65
	Offset: 0x6B48
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function update_use_trigger()
{
	if(!isdefined(self.m_s_trigger))
	{
		return;
	}
	if(self.m_b_free)
	{
		self.m_s_trigger zm_zod_util::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_USE_FREE");
	}
	else if(function_e7a31329())
	{
		self.m_s_trigger zm_zod_util::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_OFFLINE");
	}
	else if(is_cooling_down())
	{
		self.m_s_trigger zm_zod_util::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_COOLDOWN");
	}
	else
	{
		self.m_s_trigger zm_zod_util::set_unitrigger_hint_string(&"ZM_ZOD_TRAIN_USE", 500);
	}
}

/*
	Name: send_train
	Namespace: czmtrain
	Checksum: 0xB2E91FB7
	Offset: 0x6C28
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function send_train()
{
	if(isdefined(self.m_s_trigger))
	{
		self.m_b_free = 1;
		self.m_s_trigger notify(#"trigger");
	}
}

/*
	Name: run_switch
	Namespace: czmtrain
	Checksum: 0xC6967EB0
	Offset: 0x6C60
	Size: 0x21E
	Parameters: 0
	Flags: Linked
*/
function run_switch()
{
	while(true)
	{
		function_de6e1f4f(self.m_t_switch);
		str_prev_dest = self.m_str_destination;
		if(self.m_t_switch.player_used)
		{
			self.var_c2e30cf8[self.m_str_station].var_bd2282e4 = !self.var_c2e30cf8[self.m_str_station].var_bd2282e4;
			self.m_str_destination = get_current_destination();
		}
		if(self.m_str_destination != str_prev_dest)
		{
			function_ca899bfc();
			if(is_moving() && !level flag::get("callbox"))
			{
				sndnum = self.var_c2e30cf8[self.m_str_destination].audio_divert;
				level clientfield::set("sndTrainVox", sndnum);
				self.var_36e768e4 playsoundontag(level.var_98f27ad[sndnum - 1], "tag_support_arm_01");
			}
			if(level flag::get("callbox"))
			{
				level flag::clear("callbox");
			}
			self.m_t_switch sethintstring(&"ZM_ZOD_SWITCHING_PROGRESS");
			wait(1);
			if(flag::get("switches_enabled"))
			{
				self.m_t_switch sethintstring(&"ZM_ZOD_SWITCH_ENABLE");
			}
		}
		level notify(#"hash_8939bd21");
	}
}

/*
	Name: function_de6e1f4f
	Namespace: czmtrain
	Checksum: 0x56F3A46
	Offset: 0x6E88
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_de6e1f4f(m_t_switch)
{
	self.var_36e768e4 endon(#"hash_51689c0f");
	if(!flag::get("switches_enabled"))
	{
		flag::wait_till("switches_enabled");
	}
	m_t_switch.player_used = 0;
	m_t_switch waittill(#"trigger");
	m_t_switch.player_used = 1;
}

/*
	Name: function_ca899bfc
	Namespace: czmtrain
	Checksum: 0x82EF5413
	Offset: 0x6F10
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function function_ca899bfc()
{
	if(self.m_str_destination == "slums")
	{
		self.var_36e768e4 hidepart("tag_sign_footlight");
		self.var_36e768e4 hidepart("tag_sign_canals");
		self.var_36e768e4 showpart("tag_sign_waterfront");
		playsoundatposition("evt_train_switch_track_hit", self.m_t_switch.origin);
	}
	else if(self.m_str_destination == "theater")
	{
		self.var_36e768e4 hidepart("tag_sign_canals");
		self.var_36e768e4 hidepart("tag_sign_waterfront");
		self.var_36e768e4 showpart("tag_sign_footlight");
		playsoundatposition("evt_train_switch_track_hit", self.m_t_switch.origin);
	}
	else if(self.m_str_destination == "canal")
	{
		self.var_36e768e4 hidepart("tag_sign_footlight");
		self.var_36e768e4 hidepart("tag_sign_waterfront");
		self.var_36e768e4 showpart("tag_sign_canals");
		playsoundatposition("evt_train_switch_track_hit", self.m_t_switch.origin);
	}
}

/*
	Name: function_ccd778ab
	Namespace: czmtrain
	Checksum: 0x669AB6C6
	Offset: 0x7100
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_ccd778ab()
{
	foreach(var_37d90d3b, e_player in level.players)
	{
		if(is_touching_train(e_player))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: watch_players_on_train
	Namespace: czmtrain
	Checksum: 0x16D9C3ED
	Offset: 0x71A0
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function watch_players_on_train()
{
	/#
		foreach(var_5b5ce993, e_player in level.players)
		{
			/#
				assert(isdefined(e_player.on_train));
			#/
		}
	#/
	while(true)
	{
		foreach(var_16eaaf8f, e_player in level.players)
		{
			e_player.on_train = is_touching_train(e_player);
		}
		wait(0.5);
	}
}

/*
	Name: is_touching_train
	Namespace: czmtrain
	Checksum: 0xDF58DF76
	Offset: 0x72F0
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function is_touching_train(e_ent)
{
	return e_ent istouching(self.m_e_volume);
}

/*
	Name: watch_zombie_fall_off
	Namespace: czmtrain
	Checksum: 0xCD16708F
	Offset: 0x7328
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function watch_zombie_fall_off(ai)
{
	ai endon(#"death");
	ai endon(#"released_from_train");
	zm_net::network_safe_init("train_fall_check", 1);
	while(self zm_net::network_choke_action("train_fall_check", &is_touching_train, ai))
	{
		wait(2);
	}
	remove_zombie_locked_in(ai);
}

/*
	Name: is_touching_train_volume
	Namespace: czmtrain
	Checksum: 0x78AAE0B6
	Offset: 0x73D0
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function is_touching_train_volume(ent)
{
	return ent istouching(self.m_e_volume);
}

/*
	Name: get_players_on_train
	Namespace: czmtrain
	Checksum: 0xB9A1FCB3
	Offset: 0x7408
	Size: 0x14C
	Parameters: 1
	Flags: Linked
*/
function get_players_on_train(b_valid_targets_only = 0)
{
	a_players = [];
	foreach(var_47441b8b, e_player in level.players)
	{
		if(b_valid_targets_only && (e_player.ignoreme || !zm_utility::is_player_valid(e_player)))
		{
			continue;
		}
		if(e_player.on_train)
		{
			if(!isdefined(a_players))
			{
				a_players = [];
			}
			else if(!isarray(a_players))
			{
				a_players = array(a_players);
			}
			a_players[a_players.size] = e_player;
		}
	}
	return a_players;
}

/*
	Name: add_zombie_locked_in
	Namespace: czmtrain
	Checksum: 0x7D5F2F11
	Offset: 0x7560
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function add_zombie_locked_in(ai_zombie)
{
	ai_zombie.locked_in_train = 1;
	array::add(self.m_a_zombies_locked_in, ai_zombie, 0);
	thread watch_zombie_fall_off(ai_zombie);
}

/*
	Name: remove_zombie_locked_in
	Namespace: czmtrain
	Checksum: 0x1A0CCCA2
	Offset: 0x75C0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function remove_zombie_locked_in(ai_zombie)
{
	ai_zombie.locked_in_train = 0;
	arrayremovevalue(self.m_a_zombies_locked_in, ai_zombie);
	ai_zombie notify(#"released_from_train");
}

/*
	Name: locked_in_list_remove_undefined
	Namespace: czmtrain
	Checksum: 0x2855851E
	Offset: 0x7618
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function locked_in_list_remove_undefined()
{
	self.m_a_zombies_locked_in = array::remove_undefined(self.m_a_zombies_locked_in);
}

/*
	Name: get_zombies_locked_in
	Namespace: czmtrain
	Checksum: 0x4E3CC587
	Offset: 0x7648
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_zombies_locked_in()
{
	return self.m_a_zombies_locked_in;
}

/*
	Name: get_time_since_last_jumper
	Namespace: czmtrain
	Checksum: 0x4F33D043
	Offset: 0x7660
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function get_time_since_last_jumper()
{
	return float(gettime() - self.m_n_last_jumper_time) / 1000;
}

/*
	Name: mark_jumper_time
	Namespace: czmtrain
	Checksum: 0x6857928C
	Offset: 0x7698
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function mark_jumper_time()
{
	self.m_n_last_jumper_time = gettime();
}

/*
	Name: jump_into_train
	Namespace: czmtrain
	Checksum: 0x1C2AC7C1
	Offset: 0x76B0
	Size: 0x18C
	Parameters: 2
	Flags: Linked
*/
function jump_into_train(ai, str_tag)
{
	self endon(#"death");
	s_tag = self.m_a_jumptags[str_tag];
	s_tag.occupied = 1;
	v_tag_pos = self.var_36e768e4 gettagorigin(str_tag);
	v_tag_angles = self.var_36e768e4 gettagangles(str_tag);
	ai teleport(v_tag_pos, v_tag_angles);
	util::wait_network_frame();
	ai linkto(self.var_36e768e4, str_tag);
	ai animscripted("entered_train", v_tag_pos, v_tag_angles, s_tag.str_anim);
	ai zombie_shared::donotetracks("entered_train");
	ai unlink();
	s_tag.occupied = 0;
	if(is_moving())
	{
		add_zombie_locked_in(ai);
	}
}

/*
	Name: get_junction_origin
	Namespace: czmtrain
	Checksum: 0xCF2A6F09
	Offset: 0x7848
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function get_junction_origin()
{
	v_origin = (0, 0, 0);
	foreach(var_65f519ca, s_station in self.var_c2e30cf8)
	{
		v_origin = v_origin + s_station.junction_node.origin;
	}
	v_origin = v_origin / float(self.var_c2e30cf8.size);
	return v_origin;
}

/*
	Name: is_moving
	Namespace: czmtrain
	Checksum: 0x4DB9E472
	Offset: 0x7928
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function is_moving()
{
	return self flag::get("moving");
}

/*
	Name: function_3e62f527
	Namespace: czmtrain
	Checksum: 0x55BB8013
	Offset: 0x7958
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function function_3e62f527()
{
	return self.var_9e0dc993;
}

/*
	Name: is_cooling_down
	Namespace: czmtrain
	Checksum: 0x73C29708
	Offset: 0x7970
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function is_cooling_down()
{
	return self flag::get("cooldown");
}

/*
	Name: function_e7a31329
	Namespace: czmtrain
	Checksum: 0x58B6AC15
	Offset: 0x79A0
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function function_e7a31329()
{
	return self flag::get("offline");
}

/*
	Name: any_player_facing_tag
	Namespace: czmtrain
	Checksum: 0x89FC4974
	Offset: 0x79D0
	Size: 0x128
	Parameters: 1
	Flags: Linked, Private
*/
private function any_player_facing_tag(str_tag)
{
	foreach(var_e28e8004, e_player in level.players)
	{
		v_pos = self.var_36e768e4 gettagorigin(str_tag);
		v_fwd = anglestoforward(e_player.angles);
		v_to_tag = vectornormalize(v_pos - e_player.origin);
		if(vectordot(v_fwd, v_to_tag) > 0)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: get_available_jumptag
	Namespace: czmtrain
	Checksum: 0xA8D9047B
	Offset: 0x7B00
	Size: 0x2A2
	Parameters: 0
	Flags: Linked
*/
function get_available_jumptag()
{
	a_valid_tags = [];
	foreach(var_57148d50, tag in self.m_a_jumptags)
	{
		if(tag.occupied)
		{
			continue;
		}
		if(!isdefined(a_valid_tags))
		{
			a_valid_tags = [];
		}
		else if(!isarray(a_valid_tags))
		{
			a_valid_tags = array(a_valid_tags);
		}
		a_valid_tags[a_valid_tags.size] = tag;
	}
	a_valid_tags = array::randomize(a_valid_tags);
	a_forward_tags = [];
	a_players = get_players_on_train(0);
	n_roll = randomint(100);
	if(n_roll < 80 && a_players.size > 0)
	{
		foreach(var_69def4e2, s_tag in a_valid_tags)
		{
			if(any_player_facing_tag(s_tag.str_tag))
			{
				if(!isdefined(a_forward_tags))
				{
					a_forward_tags = [];
				}
				else if(!isarray(a_forward_tags))
				{
					a_forward_tags = array(a_forward_tags);
				}
				a_forward_tags[a_forward_tags.size] = s_tag;
			}
		}
	}
	if(a_forward_tags.size > 2)
	{
		a_valid_tags = a_forward_tags;
	}
	if(a_valid_tags.size == 0)
	{
		return undefined;
	}
	return array::random(a_valid_tags);
}

/*
	Name: get_origin
	Namespace: czmtrain
	Checksum: 0x94A2A997
	Offset: 0x7DB0
	Size: 0x12
	Parameters: 0
	Flags: Linked
*/
function get_origin()
{
	return self.var_36e768e4.origin;
}

/*
	Name: function_876255
	Namespace: czmtrain
	Checksum: 0x9BC27727
	Offset: 0x7DD0
	Size: 0x200
	Parameters: 0
	Flags: Linked
*/
function function_876255()
{
	var_6609d101 = getentarray("map_train", "targetname");
	while(true)
	{
		str_station = function_ae26c4a8();
		switch(str_station)
		{
			case "slums":
			{
				var_112666d8 = 1;
				break;
			}
			case "theater":
			{
				var_112666d8 = 2;
				break;
			}
			case "canal":
			{
				var_112666d8 = 3;
				break;
			}
		}
		foreach(var_66d97f79, var_19166ffe in var_6609d101)
		{
			var_19166ffe clientfield::set("train_map_light", var_112666d8);
		}
		self flag::wait_till("moving");
		foreach(var_3e5866ff, var_19166ffe in var_6609d101)
		{
			var_19166ffe clientfield::set("train_map_light", 0);
		}
		self flag::wait_till_clear("moving");
	}
}

/*
	Name: __destructor
	Namespace: czmtrain
	Checksum: 0x99EC1590
	Offset: 0x7FD8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __destructor()
{
}

#namespace zm_train;

/*
	Name: czmtrain
	Namespace: zm_train
	Checksum: 0xE17A404F
	Offset: 0x7FE8
	Size: 0xC26
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function czmtrain()
{
	classes.czmtrain[0] = spawnstruct();
	classes.czmtrain[0].__vtable[1606033458] = &czmtrain::__destructor;
	classes.czmtrain[0].__vtable[8872533] = &czmtrain::function_876255;
	classes.czmtrain[0].__vtable[-365059668] = &czmtrain::get_origin;
	classes.czmtrain[0].__vtable[-65452882] = &czmtrain::get_available_jumptag;
	classes.czmtrain[0].__vtable[2101558321] = &czmtrain::any_player_facing_tag;
	classes.czmtrain[0].__vtable[-408743127] = &czmtrain::function_e7a31329;
	classes.czmtrain[0].__vtable[-1252310656] = &czmtrain::is_cooling_down;
	classes.czmtrain[0].__vtable[1046672679] = &czmtrain::function_3e62f527;
	classes.czmtrain[0].__vtable[-643491610] = &czmtrain::is_moving;
	classes.czmtrain[0].__vtable[-484375205] = &czmtrain::get_junction_origin;
	classes.czmtrain[0].__vtable[-60091111] = &czmtrain::jump_into_train;
	classes.czmtrain[0].__vtable[-1070779204] = &czmtrain::mark_jumper_time;
	classes.czmtrain[0].__vtable[-920278003] = &czmtrain::get_time_since_last_jumper;
	classes.czmtrain[0].__vtable[251886806] = &czmtrain::get_zombies_locked_in;
	classes.czmtrain[0].__vtable[-1719939928] = &czmtrain::locked_in_list_remove_undefined;
	classes.czmtrain[0].__vtable[-868129045] = &czmtrain::remove_zombie_locked_in;
	classes.czmtrain[0].__vtable[794290114] = &czmtrain::add_zombie_locked_in;
	classes.czmtrain[0].__vtable[-1102276445] = &czmtrain::get_players_on_train;
	classes.czmtrain[0].__vtable[1080970153] = &czmtrain::is_touching_train_volume;
	classes.czmtrain[0].__vtable[-76032633] = &czmtrain::watch_zombie_fall_off;
	classes.czmtrain[0].__vtable[-387521356] = &czmtrain::is_touching_train;
	classes.czmtrain[0].__vtable[-1759866740] = &czmtrain::watch_players_on_train;
	classes.czmtrain[0].__vtable[-858294101] = &czmtrain::function_ccd778ab;
	classes.czmtrain[0].__vtable[-896951300] = &czmtrain::function_ca899bfc;
	classes.czmtrain[0].__vtable[-563208369] = &czmtrain::function_de6e1f4f;
	classes.czmtrain[0].__vtable[-756994765] = &czmtrain::run_switch;
	classes.czmtrain[0].__vtable[640858128] = &czmtrain::send_train;
	classes.czmtrain[0].__vtable[118676939] = &czmtrain::update_use_trigger;
	classes.czmtrain[0].__vtable[-1557587309] = &czmtrain::recalc_zombies_locked_in_train;
	classes.czmtrain[0].__vtable[677318411] = &czmtrain::function_285f0f0b;
	classes.czmtrain[0].__vtable[-1844369140] = &czmtrain::function_9211290c;
	classes.czmtrain[0].__vtable[-1881066007] = &czmtrain::close_doors;
	classes.czmtrain[0].__vtable[1500655324] = &czmtrain::function_59722edc;
	classes.czmtrain[0].__vtable[-1894359369] = &czmtrain::open_doors;
	classes.czmtrain[0].__vtable[972755727] = &czmtrain::function_39fb130f;
	classes.czmtrain[0].__vtable[1783161788] = &czmtrain::get_open_side;
	classes.czmtrain[0].__vtable[-1813351978] = &czmtrain::get_door_closed_pos;
	classes.czmtrain[0].__vtable[-176962386] = &czmtrain::get_door_open_pos;
	classes.czmtrain[0].__vtable[-2142038298] = &czmtrain::run_gate;
	classes.czmtrain[0].__vtable[643610466] = &czmtrain::run_callbox;
	classes.czmtrain[0].__vtable[1251890137] = &czmtrain::run_callbox_hintstring;
	classes.czmtrain[0].__vtable[-1330668116] = &czmtrain::function_b0af9dac;
	classes.czmtrain[0].__vtable[-1788979289] = &czmtrain::function_955e57a7;
	classes.czmtrain[0].__vtable[824948449] = &czmtrain::function_312bb6e1;
	classes.czmtrain[0].__vtable[-1552434618] = &czmtrain::function_a377ba46;
	classes.czmtrain[0].__vtable[-762254342] = &czmtrain::main;
	classes.czmtrain[0].__vtable[1869264804] = &czmtrain::function_6f6ab7a4;
	classes.czmtrain[0].__vtable[-422924033] = &czmtrain::initialize;
	classes.czmtrain[0].__vtable[-1431523639] = &czmtrain::function_aaacaec9;
	classes.czmtrain[0].__vtable[-576083502] = &czmtrain::function_dda9a9d2;
	classes.czmtrain[0].__vtable[-1448281630] = &czmtrain::function_a9acf9e2;
	classes.czmtrain[0].__vtable[-341908992] = &czmtrain::function_eb9ee200;
	classes.czmtrain[0].__vtable[1227831890] = &czmtrain::move;
	classes.czmtrain[0].__vtable[2125617211] = &czmtrain::function_7eb2583b;
	classes.czmtrain[0].__vtable[1274668080] = &czmtrain::watch_node_parameters;
	classes.czmtrain[0].__vtable[-733342228] = &czmtrain::get_current_destination;
	classes.czmtrain[0].__vtable[-1373191000] = &czmtrain::function_ae26c4a8;
	classes.czmtrain[0].__vtable[-1461528577] = &czmtrain::function_a8e2d7ff;
	classes.czmtrain[0].__vtable[-1929845851] = &czmtrain::function_8cf8e3a5;
	classes.czmtrain[0].__vtable[-1941346850] = &czmtrain::enable_train_switches;
	classes.czmtrain[0].__vtable[16013323] = &czmtrain::switch_path_direction;
	classes.czmtrain[0].__vtable[900487325] = &czmtrain::function_35ac589d;
	classes.czmtrain[0].__vtable[298368378] = &czmtrain::debug_draw_paths;
	classes.czmtrain[0].__vtable[-1690805083] = &czmtrain::__constructor;
}

/*
	Name: in_range_2d
	Namespace: zm_train
	Checksum: 0x6822FD88
	Offset: 0x8C18
	Size: 0x7E
	Parameters: 4
	Flags: None
*/
function in_range_2d(v1, v2, range, vert_allowance)
{
	if(abs(v1[2] - v2[2]) > vert_allowance)
	{
		return 0;
	}
	return distance2dsquared(v1, v2) < range * range;
}

/*
	Name: get_players_on_train
	Namespace: zm_train
	Checksum: 0x7B70A744
	Offset: 0x8CA0
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function get_players_on_train(b_valid_targets_only = 0)
{
	return [[ level.o_zod_train ]]->get_players_on_train(1);
}

/*
	Name: is_moving
	Namespace: zm_train
	Checksum: 0x9C7B626A
	Offset: 0x8CE0
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function is_moving()
{
	if(!isdefined(level.o_zod_train))
	{
		return 0;
	}
	return [[ level.o_zod_train ]]->is_moving();
}

/*
	Name: zombie_jump_onto_moving_train
	Namespace: zm_train
	Checksum: 0x95C19E39
	Offset: 0x8D10
	Size: 0x88
	Parameters: 1
	Flags: Linked
*/
function zombie_jump_onto_moving_train(ai)
{
	[[ level.o_zod_train ]]->mark_jumper_time();
	spot = [[ level.o_zod_train ]]->get_available_jumptag();
	if(isdefined(spot))
	{
		ai.str_train_tag = spot.str_tag;
		[[ level.o_zod_train ]]->jump_into_train(ai, spot.str_tag);
	}
}

/*
	Name: remove_dead_zombie
	Namespace: zm_train
	Checksum: 0x514BEC09
	Offset: 0x8DA0
	Size: 0xE8
	Parameters: 3
	Flags: Linked
*/
function remove_dead_zombie(e_attacker, str_means_of_death, weapon)
{
	if(isdefined(self))
	{
		b_on_train = 0;
		if(is_moving())
		{
			if(self.locked_in_train)
			{
				b_on_train = 1;
			}
		}
		if(b_on_train)
		{
			self clientfield::set("zombie_gut_explosion", 1);
			self ghost();
		}
	}
	if(isdefined(level.o_zod_train))
	{
		if(isdefined(self) && self.locked_in_train)
		{
			[[ level.o_zod_train ]]->remove_zombie_locked_in(self);
		}
		else
		{
			[[ level.o_zod_train ]]->locked_in_list_remove_undefined();
		}
	}
}

/*
	Name: get_num_zombies_locked_in
	Namespace: zm_train
	Checksum: 0xDE13BFA5
	Offset: 0x8E90
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function get_num_zombies_locked_in()
{
	a_zombies = [[ level.o_zod_train ]]->get_zombies_locked_in();
	return a_zombies.size;
}

/*
	Name: is_full
	Namespace: zm_train
	Checksum: 0xDAF9ED5D
	Offset: 0x8EC8
	Size: 0x18
	Parameters: 0
	Flags: Linked
*/
function is_full()
{
	return get_num_zombies_locked_in() >= 6;
}

/*
	Name: is_ready_for_jumper
	Namespace: zm_train
	Checksum: 0xC4210679
	Offset: 0x8EE8
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function is_ready_for_jumper()
{
	return [[ level.o_zod_train ]]->get_time_since_last_jumper() > 10;
}

/*
	Name: debug_go_to_train
	Namespace: zm_train
	Checksum: 0x9185ACAB
	Offset: 0x8F10
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function debug_go_to_train()
{
	/#
		train = getent("", "");
		if(isdefined(train))
		{
			train_origin = train getorigin();
			player = level.players[0];
			if(isdefined(player) && isdefined(train_origin))
			{
				train_origin = (train_origin[0], train_origin[1], train_origin[2] - 100);
				player setorigin(train_origin);
			}
		}
	#/
}

/*
	Name: train_devgui
	Namespace: zm_train
	Checksum: 0x5577B68C
	Offset: 0x8FF8
	Size: 0x1F0
	Parameters: 0
	Flags: Linked
*/
function train_devgui()
{
	/#
		setdvar("", "");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		while(true)
		{
			cmd = getdvarstring("");
			if(cmd != "")
			{
				switch(cmd)
				{
					case "":
					case "":
					case "":
					{
						break;
					}
					case "":
					{
						[[ level.o_zod_train ]]->open_doors();
						break;
					}
					case "":
					{
						[[ level.o_zod_train ]]->close_doors();
						break;
					}
					case "":
					{
						debug_go_to_train();
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

