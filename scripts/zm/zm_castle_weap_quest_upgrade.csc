// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;
#using scripts\zm\_zm_utility;

#namespace zm_castle_weap_quest_upgrade;

/*
	Name: main
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x830ED46F
	Offset: 0x1058
	Size: 0x147C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level.var_9128852d = [];
	level.var_f91a2b6a = [];
	for(i = 0; i < 4; i++)
	{
		level.var_f91a2b6a[i] = [];
	}
	level._effect["zombie_soul_demon"] = "dlc1/castle/fx_demon_zombie_death_energy";
	level._effect["zombie_soul_rune"] = "dlc1/castle/fx_rune_zombie_death_energy";
	level._effect["zombie_soul_storm"] = "dlc1/castle/fx_storm_zombie_death_energy";
	level._effect["zombie_soul_wolf"] = "dlc1/castle/fx_wolf_zombie_death_energy";
	level._effect["fossil_collect_fx"] = "dlc1/castle/fx_demon_gate_pick_up";
	level._effect["fossil_trail_fx"] = "dlc1/castle/fx_demon_gate_skulls_trail";
	level._effect["quest_portal_open"] = "dlc1/castle/fx_demon_gate_portal_open";
	level._effect["quest_portal_loop"] = "dlc1/castle/fx_demon_gate_portal_loop";
	level._effect["quest_portal_close"] = "dlc1/castle/fx_demon_gate_portal_close";
	level._effect["tower_break"] = "dlc1/castle/fx_elec_exp_blue";
	level._effect["battery_uncharged"] = "dlc1/castle/fx_battery_elec_beam_castle";
	level._effect["battery_charged"] = "dlc1/castle/fx_battery_elec_beam_castle_2";
	level._effect["arrow_charge"] = "dlc1/zmb_weapon/fx_bow_storm_arrowhead_ug_zmb";
	level._effect["beacon_fire"] = "dlc1/castle/fx_fire_tornado_lg";
	level._effect["beacon_fire_charged"] = "dlc1/castle/fx_fire_elec_tornado";
	level._effect["lightning_strike"] = "dlc1/castle/fx_lightning_strike_weathervane";
	level._effect["lightning_tornado"] = "dlc1/castle/fx_fire_elec_weathervane";
	level._effect["circle_kill_impact"] = "dlc1/castle/fx_rune_zombie_death_impact";
	level._effect["runic_circle"] = "dlc1/castle/fx_rune_circle_fire";
	level._effect["wolf_howl_bones"] = "dlc1/castle/fx_wolf_bones_reveal";
	level._effect["wolf_left_print"] = "dlc1/castle/fx_wolf_footprint_left_zmb";
	level._effect["wolf_right_print"] = "dlc1/castle/fx_wolf_footprint_right_zmb";
	level._effect["wolf_run_body"] = "dlc1/castle/fx_wolf_ink_run_body";
	level._effect["wolf_run_head"] = "dlc1/castle/fx_wolf_ink_run_head";
	level._effect["wolf_walk_body"] = "dlc1/castle/fx_wolf_ink_walk_body";
	level._effect["wolf_walk_head"] = "dlc1/castle/fx_wolf_ink_walk_head";
	level._effect["wolf_hold_body"] = "dlc1/castle/fx_wolf_ink_hold_body";
	level._effect["wolf_hold_head"] = "dlc1/castle/fx_wolf_ink_hold_head";
	level._effect["wolf_trail"] = "dlc1/castle/fx_wolf_ink_trail_lg";
	level._effect["arrow_charge_wolf"] = "dlc1/castle/fx_wolf_arrow_whole_float_glow";
	clientfield::register("scriptmover", "fossil_reveal", 5000, 2, "int", &function_fc150bb9, 0, 0);
	clientfield::register("scriptmover", "fossil_collect_fx", 5000, 1, "int", &function_9a901aeb, 0, 0);
	clientfield::register("scriptmover", "demonic_circle_reveal", 5000, 1, "int", &function_9de15a4d, 0, 0);
	clientfield::register("scriptmover", "init_demongate_fossil", 5000, 2, "int", &function_b2c9069f, 0, 0);
	clientfield::register("scriptmover", "urn_impact_fx", 5000, 1, "counter", &function_f821e372, 0, 0);
	clientfield::register("scriptmover", "demongate_fossil_frenzy", 5000, 1, "int", &function_543f9ebd, 0, 0);
	clientfield::register("scriptmover", "demongate_fossil_outro", 5000, 1, "int", &function_fec30c70, 0, 0);
	clientfield::register("world", "demongate_client_cleanup", 5000, 1, "int", &function_8739dc84, 0, 0);
	clientfield::register("scriptmover", "demongate_quest_portal", 5000, 1, "int", &function_e08420f7, 0, 0);
	clientfield::register("toplayer", "demon_vo_release", 8000, 1, "counter", &function_414a0874, 0, 0);
	clientfield::register("toplayer", "demon_vo_return", 8000, 1, "counter", &function_8a7c68af, 0, 0);
	clientfield::register("toplayer", "demon_vo_souls", 8000, 1, "counter", &function_71168013, 0, 0);
	clientfield::register("toplayer", "demon_vo_name", 8000, 1, "counter", &function_41a3306c, 0, 0);
	clientfield::register("toplayer", "demon_vo_ask_name", 8000, 1, "counter", &function_e13571b8, 0, 0);
	clientfield::register("toplayer", "demon_vo_name_correct", 8000, 1, "counter", &function_2ccca749, 0, 0);
	clientfield::register("toplayer", "demon_vo_name_incorrect", 8000, 1, "counter", &function_8cd2582e, 0, 0);
	clientfield::register("toplayer", "demon_vo_door", 8000, 1, "counter", &function_42fe618d, 0, 0);
	clientfield::register("toplayer", "demon_vo_horn", 8000, 1, "counter", &function_ad13a872, 0, 0);
	clientfield::register("toplayer", "demon_vo_heart", 8000, 1, "counter", &function_9b445487, 0, 0);
	clientfield::register("toplayer", "demon_vo_griffon", 8000, 1, "counter", &function_e2b77200, 0, 0);
	clientfield::register("toplayer", "demon_vo_crown", 8000, 1, "counter", &function_4ab357d6, 0, 0);
	clientfield::register("toplayer", "demon_vo_stag", 8000, 1, "counter", &function_153cf9fc, 0, 0);
	clientfield::register("scriptmover", "tower_break_fx", 5000, 1, "int", &function_7cc0d99b, 0, 0);
	clientfield::register("scriptmover", "beacon_fx", 5000, 2, "int", &function_475de8c4, 0, 0);
	clientfield::register("scriptmover", "wallrun_fx", 5000, 2, "int", &function_6103d0f7, 0, 0);
	clientfield::register("scriptmover", "battery_fx", 5000, 2, "int", &function_f51349bf, 0, 0);
	clientfield::register("scriptmover", "lightning_fx", 5000, 1, "int", &function_c31afa5, 0, 0);
	clientfield::register("scriptmover", "tornado_fx", 5000, 1, "int", &function_9db8b2b2, 0, 0);
	clientfield::register("toplayer", "arrow_charge_fx", 5000, 1, "int", &function_3f451756, 0, 1);
	clientfield::register("world", "storm_variable_cleanup", 5000, 1, "int", &function_e92d950c, 0, 0);
	clientfield::register("scriptmover", "obelisk_magma_reveal", 5000, 1, "int", &function_64bc7af0, 0, 0);
	clientfield::register("scriptmover", "obelisk_runes_reveal", 5000, 1, "int", &function_febf0bf4, 0, 0);
	clientfield::register("scriptmover", "obelisk_runes_drain", 5000, 1, "int", &function_5063c4f7, 0, 0);
	clientfield::register("scriptmover", "runic_circle_reveal", 5000, 1, "int", &function_f32932c3, 0, 0);
	clientfield::register("scriptmover", "runic_circle_fx", 5000, 1, "int", &function_3b5b1626, 0, 0);
	clientfield::register("scriptmover", "runic_circle_death_fx", 5000, 1, "counter", &function_d6434cf, 0, 0);
	clientfield::register("toplayer", "anchor_point_postfx", 5000, 1, "int", &function_c069c332, 0, 0);
	clientfield::register("world", "orb_sanim_cleanup", 5000, 1, "counter", &function_2514cb86, 0, 0);
	clientfield::register("scriptmover", "painting_symbol_reveal", 5000, 1, "int", &function_46f52afa, 0, 0);
	clientfield::register("scriptmover", "painting_symbol_blink", 5000, 1, "counter", &function_6f66f54d, 0, 0);
	clientfield::register("scriptmover", "wolf_howl_bone_fx", 5000, 1, "int", &function_65d81fc2, 0, 0);
	clientfield::register("actor", "wolf_trail_fx", 5000, 2, "int", &function_aefa4e67, 0, 0);
	clientfield::register("actor", "wolf_footprint_fx", 5000, 1, "int", &function_60ae2cd0, 0, 0);
	clientfield::register("actor", "wolf_ghost_shader", 5000, 1, "int", &function_ccf12771, 0, 0);
	clientfield::register("scriptmover", "arrow_charge_wolf_fx", 5000, 1, "int", &function_e051553d, 0, 0);
	clientfield::register("scriptmover", "zombie_soul_demon_fx", 5000, 1, "int", &function_c75de902, 0, 0);
	clientfield::register("scriptmover", "zombie_soul_rune_fx", 5000, 1, "int", &function_3cb9b375, 0, 0);
	clientfield::register("scriptmover", "zombie_soul_storm_fx", 5000, 1, "int", &function_fa1ef690, 0, 0);
	clientfield::register("scriptmover", "zombie_soul_wolf_fx", 5000, 1, "int", &function_d0720a0d, 0, 0);
	clientfield::register("world", "quest_state_demon", 5000, 3, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "quest_state_rune", 5000, 3, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "quest_state_storm", 5000, 3, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "quest_state_wolf", 5000, 3, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "quest_owner_demon", 5000, 3, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "quest_owner_rune", 5000, 3, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "quest_owner_storm", 5000, 3, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "quest_owner_wolf", 5000, 3, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_weap_quest_storm", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_weap_quest_rune", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_weap_quest_wolf", 1, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_weap_quest_demon", 1, 1, "int", undefined, 0, 0);
}

/*
	Name: function_9de15a4d
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x81BF60A8
	Offset: 0x24E0
	Size: 0x218
	Parameters: 7
	Flags: Linked
*/
function function_9de15a4d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(newval == 1)
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (2 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = 1;
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
			wait(0.01);
		}
	}
	else
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (2 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = 0;
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
			wait(0.01);
		}
	}
}

/*
	Name: function_fc150bb9
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x1DF9380A
	Offset: 0x2700
	Size: 0x114
	Parameters: 7
	Flags: Linked
*/
function function_fc150bb9(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	b_show = 0;
	var_ad3c7eb7 = 1;
	if(newval == 1)
	{
		b_show = 1;
	}
	else if(newval == 2)
	{
		b_show = 1;
		var_ad3c7eb7 = 0;
	}
	if(self.model == "tag_origin" && isdefined(self.var_89028fd1))
	{
		self.var_89028fd1 function_1c4fc326(localclientnum, b_show, var_ad3c7eb7);
	}
	else
	{
		self function_1c4fc326(localclientnum, b_show, var_ad3c7eb7);
	}
}

/*
	Name: function_1c4fc326
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xC7681374
	Offset: 0x2820
	Size: 0x2C0
	Parameters: 3
	Flags: Linked
*/
function function_1c4fc326(localclientnum, b_show, var_ad3c7eb7 = 1)
{
	if(b_show)
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (1 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = 1;
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector0", n_shader_value, 0, 0);
			wait(0.01);
		}
		if(var_ad3c7eb7)
		{
			if(isdefined(self.n_fx_id))
			{
				deletefx(localclientnum, self.n_fx_id, 1);
			}
			self.n_fx_id = playfxontag(localclientnum, level._effect["fossil_trail_fx"], self, "tag_fx");
			playsound(0, "zmb_demon_skulls_ignite", self.origin);
		}
	}
	else
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (1 * 1000);
		if(isdefined(self.n_fx_id))
		{
			deletefx(localclientnum, self.n_fx_id, 1);
		}
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = 0;
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector0", n_shader_value, 0, 0);
			wait(0.01);
		}
	}
}

/*
	Name: function_9a901aeb
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x7E406C07
	Offset: 0x2AE8
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_9a901aeb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["fossil_collect_fx"], self.origin);
	}
}

/*
	Name: function_b2c9069f
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xF6D6F4CD
	Offset: 0x2B68
	Size: 0x15A
	Parameters: 7
	Flags: Linked
*/
function function_b2c9069f(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self function_60670dd4(localclientnum, "o_zm_dlc1_chomper_demongate_swarm_trophy_room_solo_idle");
		self playsound(0, "zmb_demon_skulls_appear", self.origin);
	}
	else
	{
		if(newval == 2)
		{
			self function_60670dd4(localclientnum, "o_zm_dlc1_chomper_demongate_swarm_trophy_room_solo_idle_b");
			self playsound(0, "zmb_demon_skulls_appear", self.origin);
		}
		else
		{
			if(newval == 3)
			{
				if(isdefined(self.var_89028fd1))
				{
					self.var_89028fd1 setmodel("c_zom_chomper");
				}
			}
			else
			{
				self scene::stop(1);
				self notify(#"hash_24d9d4f5");
			}
		}
	}
}

/*
	Name: function_60670dd4
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x9EB01585
	Offset: 0x2CD0
	Size: 0xC8
	Parameters: 2
	Flags: Linked
*/
function function_60670dd4(localclientnum, str_scene)
{
	self endon(#"entityshutdown");
	level.var_f91a2b6a[localclientnum][level.var_f91a2b6a[localclientnum].size] = self;
	self.var_89028fd1 = util::spawn_model(localclientnum, "c_zom_chomper_demongate", self.origin, self.angles);
	self thread scene::play(str_scene, self.var_89028fd1);
	if(isdemoplaying())
	{
		self thread function_24d9d4f5(localclientnum);
	}
	self.str_scene = str_scene;
}

/*
	Name: function_24d9d4f5
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x67E3A5EB
	Offset: 0x2DA0
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function function_24d9d4f5(localclientnum, str_fx_name)
{
	self notify(#"hash_24d9d4f5");
	self endon(#"hash_24d9d4f5");
	level endon(#"hash_24d9d4f5");
	level waittill(#"demo_jump");
	self scene::stop(1);
}

/*
	Name: function_f821e372
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xCFFE24CE
	Offset: 0x2E10
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_f821e372(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["fossil_collect_fx"], self.origin);
	}
}

/*
	Name: function_543f9ebd
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x6E5FFE71
	Offset: 0x2E90
	Size: 0x284
	Parameters: 7
	Flags: Linked
*/
function function_543f9ebd(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.var_f91a2b6a) || !isdefined(level.var_f91a2b6a[localclientnum]))
	{
		return;
	}
	if(newval == 1)
	{
		var_f4c7c18 = [];
		for(i = 0; i < level.var_f91a2b6a[localclientnum].size; i++)
		{
			if(isdefined(level.var_f91a2b6a[localclientnum][i]) && isdefined(level.var_f91a2b6a[localclientnum][i].var_89028fd1))
			{
				if(!isdefined(var_f4c7c18))
				{
					var_f4c7c18 = [];
				}
				else if(!isarray(var_f4c7c18))
				{
					var_f4c7c18 = array(var_f4c7c18);
				}
				var_f4c7c18[var_f4c7c18.size] = level.var_f91a2b6a[localclientnum][i].var_89028fd1;
			}
		}
		if(var_f4c7c18.size > 0)
		{
			self thread scene::play("o_zm_dlc1_chomper_demongate_swarm_trophy_room_active", var_f4c7c18);
		}
	}
	else
	{
		for(i = 0; i < level.var_f91a2b6a[localclientnum].size; i++)
		{
			if(isdefined(level.var_f91a2b6a[localclientnum][i]) && isdefined(level.var_f91a2b6a[localclientnum][i].var_89028fd1))
			{
				level.var_f91a2b6a[localclientnum][i] thread scene::play(level.var_f91a2b6a[localclientnum][i].str_scene, level.var_f91a2b6a[localclientnum][i].var_89028fd1);
				wait(randomfloatrange(1, 3));
			}
		}
		self scene::stop("o_zm_dlc1_chomper_demongate_swarm_trophy_room_active");
	}
}

/*
	Name: function_fec30c70
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x52680FD1
	Offset: 0x3120
	Size: 0x19C
	Parameters: 7
	Flags: Linked
*/
function function_fec30c70(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.var_f91a2b6a) || !isdefined(level.var_f91a2b6a[localclientnum]))
	{
		return;
	}
	if(newval == 1)
	{
		level notify(#"hash_24d9d4f5");
		var_f4c7c18 = [];
		for(i = 0; i < level.var_f91a2b6a[localclientnum].size; i++)
		{
			if(isdefined(level.var_f91a2b6a[localclientnum][i]) && isdefined(level.var_f91a2b6a[localclientnum][i].var_89028fd1))
			{
				if(!isdefined(var_f4c7c18))
				{
					var_f4c7c18 = [];
				}
				else if(!isarray(var_f4c7c18))
				{
					var_f4c7c18 = array(var_f4c7c18);
				}
				var_f4c7c18[var_f4c7c18.size] = level.var_f91a2b6a[localclientnum][i].var_89028fd1;
			}
		}
		if(var_f4c7c18.size > 0)
		{
			self thread scene::play("o_zm_dlc1_chomper_demongate_swarm_trophy_room_outtro", var_f4c7c18);
		}
	}
}

/*
	Name: function_8739dc84
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xE52D8C61
	Offset: 0x32C8
	Size: 0x1EA
	Parameters: 7
	Flags: Linked
*/
function function_8739dc84(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		level thread struct::delete_script_bundle("scene", "o_zm_dlc1_chomper_demongate_swarm_trophy_room_solo_idle");
		level thread struct::delete_script_bundle("scene", "o_zm_dlc1_chomper_demongate_swarm_trophy_room_solo_idle_b");
		level thread struct::delete_script_bundle("scene", "o_zm_dlc1_chomper_demongate_swarm_trophy_room_active");
		level thread struct::delete_script_bundle("scene", "o_zm_dlc1_chomper_demongate_swarm_trophy_room_outtro");
		if(!isdefined(level.var_f91a2b6a) || !isdefined(level.var_f91a2b6a[localclientnum]))
		{
			return;
		}
		for(i = 0; i < level.var_f91a2b6a[localclientnum].size; i++)
		{
			if(isdefined(level.var_f91a2b6a[localclientnum][i]))
			{
				if(isdefined(level.var_f91a2b6a[localclientnum][i].var_89028fd1))
				{
					level.var_f91a2b6a[localclientnum][i].var_89028fd1 delete();
				}
				level.var_f91a2b6a[localclientnum][i] delete();
			}
		}
		level.var_f91a2b6a[localclientnum] = undefined;
	}
	else
	{
		level.var_f91a2b6a = undefined;
	}
}

/*
	Name: function_e08420f7
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x25B7E9B8
	Offset: 0x34C0
	Size: 0x14C
	Parameters: 7
	Flags: Linked
*/
function function_e08420f7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["quest_portal_open"], self.origin, anglestoforward(self.angles));
		wait(0.45);
		self.var_fd0edd83 = playfx(localclientnum, level._effect["quest_portal_loop"], self.origin, anglestoforward(self.angles));
	}
	else
	{
		deletefx(localclientnum, self.var_fd0edd83, 0);
		playfx(localclientnum, level._effect["quest_portal_close"], self.origin, anglestoforward(self.angles));
	}
}

/*
	Name: function_414a0874
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x8CED2D49
	Offset: 0x3618
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_414a0874(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		subtitleprint(localclientnum, 5000, &"ZM_CASTLE_DEMON_VO_RELEASE");
	}
}

/*
	Name: function_8a7c68af
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xB3385465
	Offset: 0x3688
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_8a7c68af(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		subtitleprint(localclientnum, 6000, &"ZM_CASTLE_DEMON_VO_RETURN");
	}
}

/*
	Name: function_71168013
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x3B47A714
	Offset: 0x36F8
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_71168013(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		subtitleprint(localclientnum, 6000, &"ZM_CASTLE_DEMON_VO_SOULS");
	}
}

/*
	Name: function_41a3306c
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x60DC327C
	Offset: 0x3768
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_41a3306c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		subtitleprint(localclientnum, 6000, &"ZM_CASTLE_DEMON_VO_NAME");
	}
}

/*
	Name: function_e13571b8
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xB3273ADB
	Offset: 0x37D8
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_e13571b8(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		subtitleprint(localclientnum, 5000, &"ZM_CASTLE_DEMON_VO_ASK_NAME");
	}
}

/*
	Name: function_2ccca749
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x7A51F57A
	Offset: 0x3848
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_2ccca749(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		subtitleprint(localclientnum, 5000, &"ZM_CASTLE_DEMON_VO_NAME_CORRECT");
	}
}

/*
	Name: function_8cd2582e
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xD342E1D7
	Offset: 0x38B8
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_8cd2582e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		subtitleprint(localclientnum, 5000, &"ZM_CASTLE_DEMON_VO_NAME_INCORRECT");
	}
}

/*
	Name: function_42fe618d
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x51EEEBC1
	Offset: 0x3928
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_42fe618d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		subtitleprint(localclientnum, 4000, &"ZM_CASTLE_DEMON_VO_DOOR");
	}
}

/*
	Name: function_ad13a872
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xAECD7993
	Offset: 0x3998
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_ad13a872(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		subtitleprint(localclientnum, 4000, &"ZM_CASTLE_DEMON_VO_HORN");
	}
}

/*
	Name: function_9b445487
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x3AA94F22
	Offset: 0x3A08
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_9b445487(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		subtitleprint(localclientnum, 4000, &"ZM_CASTLE_DEMON_VO_HEART");
	}
}

/*
	Name: function_e2b77200
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x5E3D803B
	Offset: 0x3A78
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_e2b77200(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		subtitleprint(localclientnum, 4000, &"ZM_CASTLE_DEMON_VO_GRIFFON");
	}
}

/*
	Name: function_4ab357d6
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x54A3DE91
	Offset: 0x3AE8
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_4ab357d6(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		subtitleprint(localclientnum, 4000, &"ZM_CASTLE_DEMON_VO_CROWN");
	}
}

/*
	Name: function_153cf9fc
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x6159D336
	Offset: 0x3B58
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_153cf9fc(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		subtitleprint(localclientnum, 4000, &"ZM_CASTLE_DEMON_VO_STAG");
	}
}

/*
	Name: function_7cc0d99b
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xD35CCC70
	Offset: 0x3BC8
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function function_7cc0d99b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["tower_break"], self.origin, anglestoforward(self.angles));
	}
}

/*
	Name: function_475de8c4
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xE27D8B0C
	Offset: 0x3C60
	Size: 0x15C
	Parameters: 7
	Flags: Linked
*/
function function_475de8c4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(isdefined(self.n_fx_id))
		{
			deletefx(localclientnum, self.n_fx_id, 1);
		}
		self.n_fx_id = playfx(localclientnum, level._effect["beacon_fire"], self.origin);
	}
	else
	{
		if(newval == 2)
		{
			if(isdefined(self.n_fx_id))
			{
				deletefx(localclientnum, self.n_fx_id, 1);
			}
			self.n_fx_id = playfx(localclientnum, level._effect["beacon_fire_charged"], self.origin);
		}
		else if(isdefined(self.n_fx_id))
		{
			stopfx(localclientnum, self.n_fx_id);
		}
	}
}

/*
	Name: function_6103d0f7
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x16976FE4
	Offset: 0x3DC8
	Size: 0x428
	Parameters: 7
	Flags: Linked
*/
function function_6103d0f7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self notify(#"hash_a1e4f5f1");
	self endon(#"hash_a1e4f5f1");
	if(!isdefined(self.n_shader_value))
	{
		self.n_shader_value = 0;
	}
	if(newval == 1)
	{
		n_start_time = gettime();
		var_b1382f05 = n_start_time + (randomfloatrange(0.2, 1.2) * 1000);
		var_c8a6e70a = self.n_shader_value;
		var_2be3abbd = 0.35;
		while(true)
		{
			n_time = gettime();
			if(n_time >= var_b1382f05)
			{
				self.n_shader_value = mapfloat(n_start_time, var_b1382f05, var_c8a6e70a, var_2be3abbd, var_b1382f05);
				n_start_time = gettime();
				var_b1382f05 = n_start_time + (randomfloatrange(0.2, 1.2) * 1000);
				var_c8a6e70a = self.n_shader_value;
				var_2be3abbd = (var_2be3abbd == 0.35 ? 0 : 0.35);
			}
			else
			{
				self.n_shader_value = mapfloat(n_start_time, var_b1382f05, var_c8a6e70a, var_2be3abbd, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, self.n_shader_value, 0);
			wait(0.01);
		}
	}
	else
	{
		if(newval == 2)
		{
			n_start_time = gettime();
			n_end_time = n_start_time + (0.2 * 1000);
			var_c8a6e70a = self.n_shader_value;
			b_is_updating = 1;
			while(b_is_updating)
			{
				n_time = gettime();
				if(n_time >= n_end_time)
				{
					self.n_shader_value = 1;
					b_is_updating = 0;
				}
				else
				{
					self.n_shader_value = mapfloat(n_start_time, n_end_time, var_c8a6e70a, 1, n_time);
				}
				self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, self.n_shader_value, 0);
				wait(0.01);
			}
		}
		else
		{
			n_start_time = gettime();
			n_end_time = n_start_time + (0.2 * 1000);
			var_c8a6e70a = self.n_shader_value;
			b_is_updating = 1;
			while(b_is_updating)
			{
				n_time = gettime();
				if(n_time >= n_end_time)
				{
					self.n_shader_value = 0;
					b_is_updating = 0;
				}
				else
				{
					self.n_shader_value = mapfloat(n_start_time, n_end_time, var_c8a6e70a, 0, n_time);
				}
				self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, self.n_shader_value, 0);
				wait(0.01);
			}
		}
	}
}

/*
	Name: function_f51349bf
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xBDC2250D
	Offset: 0x41F8
	Size: 0x19C
	Parameters: 7
	Flags: Linked
*/
function function_f51349bf(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(isdefined(self.n_fx_id))
		{
			deletefx(localclientnum, self.n_fx_id, 1);
		}
		self.n_fx_id = playfx(localclientnum, level._effect["battery_uncharged"], self.origin, anglestoforward(self.angles), (0, 0, 1));
	}
	else
	{
		if(newval == 2)
		{
			if(isdefined(self.n_fx_id))
			{
				deletefx(localclientnum, self.n_fx_id, 1);
			}
			self.n_fx_id = playfx(localclientnum, level._effect["battery_charged"], self.origin, anglestoforward(self.angles), (0, 0, 1));
		}
		else if(isdefined(self.n_fx_id))
		{
			deletefx(localclientnum, self.n_fx_id, 1);
		}
	}
}

/*
	Name: function_3f451756
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xB83CC21C
	Offset: 0x43A0
	Size: 0x114
	Parameters: 7
	Flags: Linked
*/
function function_3f451756(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.var_9128852d))
	{
		return;
	}
	if(newval == 1)
	{
		if(isdefined(level.var_9128852d[localclientnum]))
		{
			deletefx(localclientnum, level.var_9128852d[localclientnum], 1);
		}
		level.var_9128852d[localclientnum] = playviewmodelfx(localclientnum, level._effect["arrow_charge"], "tag_flash");
	}
	else if(isdefined(level.var_9128852d[localclientnum]))
	{
		deletefx(localclientnum, level.var_9128852d[localclientnum], 1);
	}
}

/*
	Name: function_e92d950c
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xDAE9B3DB
	Offset: 0x44C0
	Size: 0xD2
	Parameters: 7
	Flags: Linked
*/
function function_e92d950c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(level.var_9128852d))
	{
		foreach(n_fx_id in level.var_9128852d)
		{
			if(isdefined(n_fx_id))
			{
				n_fx_id = undefined;
			}
		}
		level.var_e71f8892 = undefined;
	}
}

/*
	Name: function_c31afa5
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xC23944F6
	Offset: 0x45A0
	Size: 0xE4
	Parameters: 7
	Flags: Linked
*/
function function_c31afa5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(isdefined(self.n_fx_id))
		{
			deletefx(localclientnum, self.n_fx_id, 1);
		}
		self.n_fx_id = playfx(localclientnum, level._effect["lightning_strike"], self.origin);
	}
	else if(isdefined(self.n_fx_id))
	{
		stopfx(localclientnum, self.n_fx_id);
	}
}

/*
	Name: function_9db8b2b2
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xF084E307
	Offset: 0x4690
	Size: 0xE4
	Parameters: 7
	Flags: Linked
*/
function function_9db8b2b2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(isdefined(self.var_cff5d8ed))
		{
			deletefx(localclientnum, self.var_cff5d8ed, 1);
		}
		self.var_cff5d8ed = playfx(localclientnum, level._effect["lightning_tornado"], self.origin);
	}
	else if(isdefined(self.var_cff5d8ed))
	{
		stopfx(localclientnum, self.var_cff5d8ed);
	}
}

/*
	Name: function_64bc7af0
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x708CD7E4
	Offset: 0x4780
	Size: 0x258
	Parameters: 7
	Flags: Linked
*/
function function_64bc7af0(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	var_82acb0d9 = 8.5;
	if(newval == 1)
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector0", 1, 0, 0);
	}
	else
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (1 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = 0;
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector0", n_shader_value, 0, 0);
			wait(0.01);
		}
		n_start_time = gettime();
		n_end_time = n_start_time + (var_82acb0d9 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = 1;
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector0", n_shader_value, 0, 0);
			wait(0.01);
		}
	}
}

/*
	Name: function_febf0bf4
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xA1C3C8B7
	Offset: 0x49E0
	Size: 0x190
	Parameters: 7
	Flags: Linked
*/
function function_febf0bf4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	var_82acb0d9 = 8.5;
	if(newval == 1)
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector0", 1, 0, 0);
	}
	else
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (var_82acb0d9 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = 0;
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector0", n_shader_value, 0, 0);
			wait(0.01);
		}
	}
}

/*
	Name: function_5063c4f7
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x4AEF2648
	Offset: 0x4B78
	Size: 0x188
	Parameters: 7
	Flags: Linked
*/
function function_5063c4f7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(newval == 1)
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector0", 0, 0, 0);
	}
	else
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (30 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = 1;
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector0", n_shader_value, 0, 0);
			wait(0.01);
		}
	}
}

/*
	Name: function_f32932c3
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xFB361798
	Offset: 0x4D08
	Size: 0x218
	Parameters: 7
	Flags: Linked
*/
function function_f32932c3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(newval == 1)
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (0.5 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = 1;
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
			wait(0.01);
		}
	}
	else
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (0.5 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = 0;
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
			wait(0.01);
		}
	}
}

/*
	Name: function_3b5b1626
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xC8001F6D
	Offset: 0x4F28
	Size: 0x124
	Parameters: 7
	Flags: Linked
*/
function function_3b5b1626(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(isdefined(self.n_fx_id))
		{
			deletefx(localclientnum, self.n_fx_id, 1);
		}
		self.n_fx_id = playfx(localclientnum, level._effect["runic_circle"], self.origin, anglestoup(self.angles), anglestoforward(self.angles + vectorscale((0, 1, 0), 90)));
	}
	else if(isdefined(self.n_fx_id))
	{
		deletefx(localclientnum, self.n_fx_id, 1);
	}
}

/*
	Name: function_d6434cf
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xB4343785
	Offset: 0x5058
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_d6434cf(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["circle_kill_impact"], self.origin, vectorscale((0, 0, 1), 90));
	}
}

/*
	Name: function_c069c332
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x2906FAB
	Offset: 0x50E8
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_c069c332(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self thread postfx::playpostfxbundle("pstfx_arrow_rune");
	}
	else
	{
		self thread postfx::stoppostfxbundle();
	}
}

/*
	Name: function_2514cb86
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x13D7FD2C
	Offset: 0x5170
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function function_2514cb86(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		var_c6a8f11b = getent(localclientnum, "quest_rune_orb", "targetname");
		if(isdefined(var_c6a8f11b))
		{
			var_c6a8f11b delete();
		}
		wait(5);
		level thread struct::delete_script_bundle("scene", "p7_fxanim_zm_castle_quest_rune_orb_scale_down_bundle");
	}
}

/*
	Name: function_46f52afa
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xDFEC91FF
	Offset: 0x5240
	Size: 0x218
	Parameters: 7
	Flags: Linked
*/
function function_46f52afa(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(newval == 1)
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (0.5 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = 1;
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
			wait(0.01);
		}
	}
	else
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (0.5 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = 0;
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
			wait(0.01);
		}
	}
}

/*
	Name: function_6f66f54d
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xF103247F
	Offset: 0x5460
	Size: 0x210
	Parameters: 7
	Flags: Linked
*/
function function_6f66f54d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	n_start_time = gettime();
	n_end_time = n_start_time + (0.5 * 1000);
	b_is_updating = 1;
	while(b_is_updating)
	{
		n_time = gettime();
		if(n_time >= n_end_time)
		{
			n_shader_value = 1;
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_time);
		}
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
		wait(0.01);
	}
	n_start_time = gettime();
	n_end_time = n_start_time + (0.5 * 1000);
	b_is_updating = 1;
	while(b_is_updating)
	{
		n_time = gettime();
		if(n_time >= n_end_time)
		{
			n_shader_value = 0;
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
		}
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
		wait(0.01);
	}
}

/*
	Name: function_65d81fc2
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xD05FCF53
	Offset: 0x5678
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function function_65d81fc2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(isdefined(self.n_fx_id))
		{
			deletefx(localclientnum, self.n_fx_id, 1);
		}
		self.n_fx_id = playfx(localclientnum, level._effect["wolf_howl_bones"], self.origin + vectorscale((0, 0, 1), 4), (1, 0, 0), (0, 0, 1));
	}
	else if(isdefined(self.n_fx_id))
	{
		stopfx(localclientnum, self.n_fx_id);
	}
}

/*
	Name: function_aefa4e67
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xB90B5C17
	Offset: 0x5780
	Size: 0x234
	Parameters: 7
	Flags: Linked
*/
function function_aefa4e67(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.var_d0e1c4f7))
	{
		stopfx(localclientnum, self.var_d0e1c4f7);
	}
	if(isdefined(self.var_c35be71d))
	{
		stopfx(localclientnum, self.var_c35be71d);
	}
	if(isdefined(self.var_96ef984f))
	{
		stopfx(localclientnum, self.var_96ef984f);
	}
	if(newval == 0)
	{
		return;
	}
	if(newval == 1)
	{
		var_a975b59c = "wolf_hold_head";
		var_2072b44e = "wolf_hold_body";
	}
	else
	{
		if(newval == 2)
		{
			var_a975b59c = "wolf_walk_head";
			var_2072b44e = "wolf_walk_body";
			self.var_96ef984f = playfxontag(localclientnum, level._effect["wolf_trail"], self, "j_mainroot");
		}
		else if(newval == 3)
		{
			var_a975b59c = "wolf_run_head";
			var_2072b44e = "wolf_run_body";
			self.var_96ef984f = playfxontag(localclientnum, level._effect["wolf_trail"], self, "j_mainroot");
		}
	}
	self.var_d0e1c4f7 = playfxontag(localclientnum, level._effect[var_a975b59c], self, "j_head");
	self.var_c35be71d = playfxontag(localclientnum, level._effect[var_2072b44e], self, "spine3_jnt");
}

/*
	Name: function_60ae2cd0
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xE4B21DB6
	Offset: 0x59C0
	Size: 0x6E
	Parameters: 7
	Flags: Linked
*/
function function_60ae2cd0(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level thread function_a783453f(localclientnum, self);
	}
	else
	{
		self notify(#"hash_5ad4a160");
	}
}

/*
	Name: function_a783453f
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x9FA26AEC
	Offset: 0x5A38
	Size: 0x1F0
	Parameters: 2
	Flags: Linked
*/
function function_a783453f(localclientnum, var_3a9e6062)
{
	var_3a9e6062 endon(#"death");
	var_3a9e6062 endon(#"entityshutdown");
	var_3a9e6062 endon(#"hash_5ad4a160");
	b_left_side = 1;
	var_cc9030a = var_3a9e6062.origin;
	while(isdefined(var_3a9e6062))
	{
		wait(0.15);
		if(var_3a9e6062.origin != var_cc9030a)
		{
			var_cc9030a = var_3a9e6062.origin;
			if(isdefined(b_left_side) && b_left_side)
			{
				str_tag = "l_frontlegend_jnt";
				var_375e50e1 = "wolf_left_print";
				b_left_side = undefined;
			}
			else
			{
				str_tag = "r_frontlegend_jnt";
				var_375e50e1 = "wolf_right_print";
				b_left_side = 1;
			}
			v_pos = var_3a9e6062 gettagorigin(str_tag) + vectorscale((0, 0, 1), 4);
			var_c6f6381a = bullettrace(v_pos, v_pos - vectorscale((0, 0, 1), 12), 0, undefined);
			v_final_pos = var_c6f6381a["position"] + (0, 0, 1);
			playfx(localclientnum, level._effect[var_375e50e1], v_final_pos, anglestoforward(var_3a9e6062.angles), (0, 0, 1));
		}
	}
}

/*
	Name: function_ccf12771
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xFA8EB61D
	Offset: 0x5C30
	Size: 0x2A0
	Parameters: 7
	Flags: Linked
*/
function function_ccf12771(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(newval == 1)
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (2.5 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				var_6d9840be = 1;
				var_11bb1597 = 0.7;
				b_is_updating = 0;
			}
			else
			{
				var_6d9840be = mapfloat(n_start_time, n_end_time, 0, 1, n_time);
				var_11bb1597 = mapfloat(n_start_time, n_end_time, 0, 0.7, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector2", var_6d9840be, var_11bb1597, 0);
			wait(0.01);
		}
	}
	else
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (2.5 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				var_6d9840be = 0;
				var_11bb1597 = 0;
				b_is_updating = 0;
			}
			else
			{
				var_6d9840be = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
				var_11bb1597 = mapfloat(n_start_time, n_end_time, 0.7, 0, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector2", var_6d9840be, var_11bb1597, 0);
			wait(0.01);
		}
	}
}

/*
	Name: function_e051553d
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x7E879A13
	Offset: 0x5ED8
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function function_e051553d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.n_fx_id = playfxontag(localclientnum, level._effect["arrow_charge_wolf"], self, "tag_fx_base_arrow_jnt");
	}
	else
	{
		deletefx(localclientnum, self.n_fx_id);
	}
}

/*
	Name: function_c75de902
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xBA2B2F50
	Offset: 0x5F80
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_c75de902(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self function_1ee903c(localclientnum, "zombie_soul_demon", newval);
}

/*
	Name: function_3cb9b375
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x2BEBE8DF
	Offset: 0x5FF0
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_3cb9b375(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self function_1ee903c(localclientnum, "zombie_soul_rune", newval);
}

/*
	Name: function_fa1ef690
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x8846C2BC
	Offset: 0x6060
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_fa1ef690(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self function_1ee903c(localclientnum, "zombie_soul_storm", newval);
}

/*
	Name: function_d0720a0d
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0x11FEAFAC
	Offset: 0x60D0
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_d0720a0d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self function_1ee903c(localclientnum, "zombie_soul_wolf", newval);
}

/*
	Name: function_1ee903c
	Namespace: zm_castle_weap_quest_upgrade
	Checksum: 0xB004A32E
	Offset: 0x6140
	Size: 0xC4
	Parameters: 3
	Flags: Linked
*/
function function_1ee903c(localclientnum, str_fx_name, newval)
{
	if(newval == 1)
	{
		if(isdefined(self.var_1a7640e2))
		{
			deletefx(localclientnum, self.var_1a7640e2, 1);
		}
		self.var_1a7640e2 = playfxontag(localclientnum, level._effect[str_fx_name], self, "tag_origin");
	}
	else if(isdefined(self.var_1a7640e2))
	{
		deletefx(localclientnum, self.var_1a7640e2, 1);
	}
}

