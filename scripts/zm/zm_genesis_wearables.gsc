// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_margwa_elemental;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_genesis_power;
#using scripts\zm\zm_genesis_util;

#using_animtree("generic");

#namespace namespace_6b38abe3;

/*
	Name: __init__sytem__
	Namespace: namespace_6b38abe3
	Checksum: 0x1B3DFA48
	Offset: 0xCA0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_wearables", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_6b38abe3
	Checksum: 0x2B3A9A78
	Offset: 0xCE0
	Size: 0x204
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "battery_fx", 15000, 2, "int");
	clientfield::register("clientuimodel", "zmInventory.wearable_perk_icons", 15000, 2, "int");
	zm_spawner::register_zombie_death_event_callback(&function_9d85b9ce);
	zm_spawner::register_zombie_damage_callback(&function_cb27f92e);
	for(i = 0; i < 4; i++)
	{
		registerclientfield("world", ("player" + i) + "wearableItem", 15000, 4, "int");
	}
	level thread function_aa6437f1();
	level thread function_b4575902();
	level thread function_796904fd();
	level thread function_4fddc919();
	level thread function_6d72c0dc();
	level thread function_8454afd5();
	level thread function_3167c564();
	level thread function_37ba4813();
	/#
		zm_devgui::add_custom_devgui_callback(&function_82e9c58d);
		level thread function_e8a31296();
	#/
}

/*
	Name: function_2436f867
	Namespace: namespace_6b38abe3
	Checksum: 0x16E4D927
	Offset: 0xEF0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_2436f867()
{
	self notify(#"hash_2436f867");
	self endon(#"hash_2436f867");
	self util::waittill_any("disconnect", "bled_out", "death");
	self.var_bc5f242a = undefined;
	function_b712ee6f(0);
	function_30fb8e63(0);
}

/*
	Name: function_b712ee6f
	Namespace: namespace_6b38abe3
	Checksum: 0xEC71EFC0
	Offset: 0xF80
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_b712ee6f(var_908867a0)
{
	level clientfield::set(("player" + self.entity_num) + "wearableItem", var_908867a0);
}

/*
	Name: function_30fb8e63
	Namespace: namespace_6b38abe3
	Checksum: 0x3C64BE7A
	Offset: 0xFC8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_30fb8e63(n_perks)
{
	self clientfield::set_player_uimodel("zmInventory.wearable_perk_icons", n_perks);
}

/*
	Name: function_f6b20985
	Namespace: namespace_6b38abe3
	Checksum: 0xD1DD04EB
	Offset: 0x1000
	Size: 0x194
	Parameters: 4
	Flags: Linked
*/
function function_f6b20985(var_8fca9f8c, var_f48b681c, str_tag, var_f3776824)
{
	s_loc = struct::get(var_8fca9f8c, "targetname");
	level.var_6d65545f = spawn("script_model", s_loc.origin);
	level.var_6d65545f.angles = s_loc.angles;
	level.var_6d65545f setmodel(var_f48b681c);
	var_750a9baa = s_loc zm_unitrigger::create_unitrigger(&"ZM_GENESIS_WEARABLE_PICKUP", undefined, &function_24061b58, &function_7f0ec71c);
	var_750a9baa.var_f4b4f2f2 = var_f48b681c;
	var_750a9baa.str_tag = str_tag;
	var_750a9baa.var_475b0a4e = var_8fca9f8c;
	v_offset = (0, 0, var_f3776824);
	var_750a9baa.origin = var_750a9baa.origin + v_offset;
	zm_unitrigger::unitrigger_force_per_player_triggers(var_750a9baa, 1);
}

/*
	Name: function_24061b58
	Namespace: namespace_6b38abe3
	Checksum: 0x5E459BE1
	Offset: 0x11A0
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function function_24061b58(e_player)
{
	if(isdefined(e_player.var_bc5f242a) && e_player.var_bc5f242a.str_model === self.stub.var_f4b4f2f2)
	{
		self sethintstring(&"ZM_GENESIS_WEARABLE_EQUIPPED");
		return false;
	}
	self sethintstring(&"ZM_GENESIS_WEARABLE_PICKUP");
	return true;
}

/*
	Name: function_7f0ec71c
	Namespace: namespace_6b38abe3
	Checksum: 0x34F01979
	Offset: 0x1248
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function function_7f0ec71c()
{
	self endon(#"death");
	while(true)
	{
		self trigger::wait_till();
		e_player = self.who;
		if(!isdefined(e_player.var_bc5f242a))
		{
			e_player.var_bc5f242a = spawnstruct();
		}
		e_player function_e5974b49();
		str_tag = self.stub.str_tag;
		var_475b0a4e = self.stub.var_475b0a4e;
		e_player function_a16ce474(self.stub.var_f4b4f2f2, var_475b0a4e, str_tag);
	}
}

/*
	Name: function_a16ce474
	Namespace: namespace_6b38abe3
	Checksum: 0x4B93DF8C
	Offset: 0x1340
	Size: 0x60E
	Parameters: 3
	Flags: Linked
*/
function function_a16ce474(str_model, var_475b0a4e, str_tag)
{
	self function_e5515520();
	self.var_bc5f242a.str_model = str_model;
	self.var_bc5f242a.str_tag = str_tag;
	self attach(self.var_bc5f242a.str_model, str_tag);
	self playsound("zmb_craftable_pickup");
	self notify(#"changed_wearable", var_475b0a4e);
	self thread function_2436f867();
	switch(var_475b0a4e)
	{
		case "s_weasels_hat":
		{
			self playsound("zmb_wearable_weasel_wear");
			self function_b712ee6f(1);
			self function_30fb8e63(0);
			break;
		}
		case "s_helm_of_siegfried":
		{
			self playsound("zmb_wearable_siegfried_wear");
			self thread function_edd475ab(20, 10, "c_zom_dlc4_player_siegfried_helmet");
			self.n_player_health_boost = 45;
			self zm_perks::perk_set_max_health_if_jugg("health_reboot", 0, 0);
			self function_b712ee6f(2);
			self function_30fb8e63(2);
			break;
		}
		case "s_helm_of_the_king":
		{
			self playsound("zmb_wearable_mechz_wear");
			self.var_e1384d1e = 0.5;
			self.var_ad21546 = 0.5;
			self.n_margwa_head_damage_scale = 1.33;
			self.var_bbd3efb8 = 1.33;
			self.var_fd3f1056 = 1;
			self setperk("specialty_tombstone");
			self function_b712ee6f(4);
			self function_30fb8e63(1);
			break;
		}
		case "s_dire_wolf_head":
		{
			self playsound("zmb_wearable_wolf_wear");
			self setperk("specialty_tombstone");
			self thread function_edd475ab(20, 10, "c_zom_dlc4_player_direwolf_helmet");
			self function_b712ee6f(7);
			self function_30fb8e63(1);
			break;
		}
		case "s_margwa_head":
		{
			self playsound("zmb_wearable_margwa_wear");
			self.var_e1384d1e = 0.5;
			self.n_margwa_head_damage_scale = 1.33;
			self setperk("specialty_tombstone");
			self function_b712ee6f(6);
			self function_30fb8e63(1);
			break;
		}
		case "s_keeper_skull_head":
		{
			self playsound("zmb_wearable_keeper_wear");
			self.n_player_health_boost = 45;
			self zm_perks::perk_set_max_health_if_jugg("health_reboot", 0, 0);
			self.var_e7f63e2e = 30;
			self.var_ebafd972 = 0.5;
			self.var_74fe492b = 1;
			self function_b712ee6f(5);
			self function_30fb8e63(2);
			break;
		}
		case "s_apothicon_mask":
		{
			self playsound("zmb_wearable_apothigod_wear");
			self.var_e8e8daad = 1;
			self.var_bcff1de = 1;
			self.n_margwa_head_damage_scale = 1.5;
			self.var_bbd3efb8 = 1.5;
			self setperk("specialty_tombstone");
			self.n_player_health_boost = 45;
			self zm_perks::perk_set_max_health_if_jugg("health_reboot", 0, 0);
			self function_b712ee6f(3);
			self function_30fb8e63(3);
			break;
		}
		case "s_fury_head":
		{
			self playsound("zmb_wearable_fury_wear");
			self.var_eef0616b = 0.66;
			self.var_15c79ed8 = 1;
			self.n_player_health_boost = 45;
			self zm_perks::perk_set_max_health_if_jugg("health_reboot", 0, 0);
			self function_b712ee6f(8);
			self function_30fb8e63(2);
			break;
		}
	}
}

/*
	Name: function_e5515520
	Namespace: namespace_6b38abe3
	Checksum: 0x11624876
	Offset: 0x1958
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function function_e5515520()
{
	var_77268fe9 = self getcharacterbodymodel();
	switch(var_77268fe9)
	{
		case "c_zom_dlc3_nikolai_mpc_fb":
		{
			self setcharacterbodystyle(2);
			break;
		}
		case "c_zom_dlc3_takeo_mpc_fb":
		{
			self setcharacterbodystyle(2);
			break;
		}
	}
}

/*
	Name: function_e5974b49
	Namespace: namespace_6b38abe3
	Checksum: 0x121E0F29
	Offset: 0x19E8
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_e5974b49()
{
	self notify(#"hash_baf651e0");
	self.var_e8e8daad = undefined;
	self.var_bcff1de = undefined;
	self.var_e1384d1e = undefined;
	self.var_ad21546 = undefined;
	self.n_margwa_head_damage_scale = undefined;
	self.var_bbd3efb8 = undefined;
	self.var_e7f63e2e = undefined;
	self.var_ebafd972 = undefined;
	self.b_no_trap_damage = undefined;
	self.var_74fe492b = undefined;
	self.var_adaec269 = undefined;
	self.var_fd3f1056 = undefined;
	self.var_eef0616b = undefined;
	self.var_15c79ed8 = undefined;
	self.n_player_health_boost = undefined;
	self zm_perks::perk_set_max_health_if_jugg("health_reboot", 0, 0);
	if(self hasperk("specialty_tombstone"))
	{
		self unsetperk("specialty_tombstone");
	}
	if(isdefined(self.var_bc5f242a.str_model))
	{
		self detach(self.var_bc5f242a.str_model, self.var_bc5f242a.str_tag);
	}
}

/*
	Name: function_aa6437f1
	Namespace: namespace_6b38abe3
	Checksum: 0xD1FC1244
	Offset: 0x1B28
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_aa6437f1()
{
	level waittill(#"all_players_spawned");
	function_f6b20985("s_weasels_hat", "c_zom_dlc4_player_arlington_helmet", "j_head", 0);
}

/*
	Name: function_b4575902
	Namespace: namespace_6b38abe3
	Checksum: 0xF157F5E6
	Offset: 0x1B70
	Size: 0x304
	Parameters: 0
	Flags: Linked
*/
function function_b4575902()
{
	var_66b0cbbe = struct::get_array("ancient_battery", "targetname");
	var_5a533244 = [];
	foreach(var_d186cfae in var_66b0cbbe)
	{
		var_8d2dd868 = util::spawn_model("p7_zm_ctl_battery_ceramic", var_d186cfae.origin, var_d186cfae.angles);
		var_8d2dd868.target = var_d186cfae.target;
		if(!isdefined(var_5a533244))
		{
			var_5a533244 = [];
		}
		else if(!isarray(var_5a533244))
		{
			var_5a533244 = array(var_5a533244);
		}
		var_5a533244[var_5a533244.size] = var_8d2dd868;
	}
	function_9157236c();
	foreach(var_8d2dd868 in var_5a533244)
	{
		var_8d2dd868 clientfield::set("battery_fx", 1);
	}
	function_b8449f8c(var_5a533244);
	foreach(var_8d2dd868 in var_5a533244)
	{
		var_8d2dd868 clientfield::set("battery_fx", 0);
	}
	playsoundatposition("zmb_wearable_siegfried_horn_1", (0, 0, 0));
	/#
		iprintlnbold("");
	#/
	function_f6b20985("s_helm_of_siegfried", "c_zom_dlc4_player_siegfried_helmet", "j_head", 0);
}

/*
	Name: function_9157236c
	Namespace: namespace_6b38abe3
	Checksum: 0x795E943B
	Offset: 0x1E80
	Size: 0x2B4
	Parameters: 0
	Flags: Linked
*/
function function_9157236c()
{
	var_7bd91d87 = struct::get_array("s_ee_clock", "targetname");
	var_687cab15 = getent("ee_grand_tour_undercroft", "targetname");
	var_687cab15 setcandamage(1);
	n_stage = 9;
	var_c52419ba = 1;
	while(var_c52419ba)
	{
		var_687cab15 waittill(#"damage", damage, attacker, direction_vec, v_point, type, modelname, tagname, partname, weapon, idflags);
		n_closest = 9999999;
		s_closest = var_7bd91d87[0];
		for(i = 0; i < var_7bd91d87.size; i++)
		{
			n_dist = distance(var_7bd91d87[i].origin, v_point);
			if(n_dist < n_closest)
			{
				n_closest = n_dist;
				s_closest = var_7bd91d87[i];
			}
		}
		switch(n_stage)
		{
			case 9:
			{
				if(s_closest.script_int == 9)
				{
					n_stage = 3;
				}
				break;
			}
			case 3:
			{
				if(s_closest.script_int == 3)
				{
					n_stage = 5;
				}
				else
				{
					n_stage = 9;
				}
				break;
			}
			case 5:
			{
				if(s_closest.script_int == 5)
				{
					var_c52419ba = 0;
				}
				else
				{
					n_stage = 9;
				}
				break;
			}
		}
	}
	var_687cab15 playsound("zmb_wearable_siegfried_bell");
}

/*
	Name: function_b8449f8c
	Namespace: namespace_6b38abe3
	Checksum: 0x5474ADC2
	Offset: 0x2140
	Size: 0x2D4
	Parameters: 1
	Flags: Linked
*/
function function_b8449f8c(var_5a533244)
{
	level.var_5317b760 = 1;
	for(i = 0; i < var_5a533244.size; i++)
	{
		var_5a533244[i].var_b4a21360 = 5;
	}
	while(var_5a533244.size > 0)
	{
		level waittill(#"hash_e8c3642d");
		v_kill_pos = level.var_98fdd784;
		var_e84c42f6 = 0;
		var_688f490b = undefined;
		n_closest_dist = 9999999;
		for(i = 0; i < var_5a533244.size; i++)
		{
			var_8d2dd868 = var_5a533244[i];
			s_center = struct::get(var_8d2dd868.target, "targetname");
			n_dist = distance(s_center.origin, v_kill_pos);
			if(n_dist < n_closest_dist)
			{
				n_closest_dist = n_dist;
				var_688f490b = var_8d2dd868;
				if(isdefined(s_center.script_num))
				{
					var_e84c42f6 = 1;
					continue;
				}
				var_e84c42f6 = 0;
			}
		}
		if(var_e84c42f6)
		{
			var_6b63f67e = s_center.script_num;
		}
		else
		{
			var_6b63f67e = 256;
		}
		if(n_closest_dist <= var_6b63f67e)
		{
			zm_genesis_power::zombie_blood_soul_streak_fx(v_kill_pos + vectorscale((0, 0, 1), 50), (0, 0, 0), var_688f490b.origin, 0.75);
			var_688f490b.var_b4a21360--;
			if(var_688f490b.var_b4a21360 <= 0)
			{
				var_688f490b clientfield::set("battery_fx", 2);
				arrayremovevalue(var_5a533244, var_688f490b);
				var_688f490b playsound("zmb_wearable_siegfried_battery_charged");
				/#
					iprintlnbold("");
				#/
			}
		}
	}
	level.var_5317b760 = 0;
}

/*
	Name: function_edd475ab
	Namespace: namespace_6b38abe3
	Checksum: 0xAE3F892E
	Offset: 0x2420
	Size: 0x16C
	Parameters: 3
	Flags: Linked
*/
function function_edd475ab(var_dd087d43, var_33c3e058, var_e7d196cc)
{
	self endon(#"disconnect");
	self endon(#"hash_baf651e0");
	self.var_adaec269 = 1;
	n_start_time = undefined;
	var_fce7f186 = 0;
	while(true)
	{
		self waittill(#"hash_ab106e77");
		n_time = gettime();
		if(!isdefined(n_start_time))
		{
			n_start_time = n_time;
		}
		var_84e70e75 = (n_time - n_start_time) / 1000;
		if(var_84e70e75 > var_33c3e058)
		{
			n_start_time = n_time;
			var_fce7f186 = 0;
		}
		else
		{
			var_fce7f186++;
			if(var_fce7f186 >= var_dd087d43)
			{
				switch(var_e7d196cc)
				{
					case "c_zom_dlc4_player_siegfried_helmet":
					{
						self playsoundtoplayer("zmb_wearable_siegfried_horn_2", self);
						break;
					}
					case "c_zom_dlc4_player_direwolf_helmet":
					{
						self playsoundtoplayer("zmb_wearable_wolf_howl", self);
						break;
					}
				}
				n_start_time = n_time;
				var_fce7f186 = 0;
			}
		}
	}
}

/*
	Name: function_8454afd5
	Namespace: namespace_6b38abe3
	Checksum: 0xEC936B93
	Offset: 0x2598
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function function_8454afd5()
{
	level flag::init("mechz_gun_flag");
	level flag::init("mechz_mask_flag");
	level flag::init("mechz_trap_flag");
	level thread function_59c5b722("mechz_gun_flag");
	level thread function_1a3ef9c4("mechz_mask_flag");
	level thread function_a4ae62cc("mechz_trap_flag");
	level flag::wait_till_all(array("mechz_gun_flag", "mechz_mask_flag", "mechz_trap_flag"));
	playsoundatposition("zmb_wearable_mechz_complete", (0, 0, 0));
	function_f6b20985("s_helm_of_the_king", "c_zom_dlc4_player_king_helmet", "j_head", 0);
}

/*
	Name: function_59c5b722
	Namespace: namespace_6b38abe3
	Checksum: 0x98BCAF96
	Offset: 0x26E8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_59c5b722(str_flag)
{
	level waittill(#"mechz_gun_detached");
	level flag::set(str_flag);
	function_c81a7efa();
}

/*
	Name: function_1a3ef9c4
	Namespace: namespace_6b38abe3
	Checksum: 0xE113FC98
	Offset: 0x2738
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_1a3ef9c4(str_flag)
{
	level waittill(#"mechz_faceplate_detached");
	level flag::set(str_flag);
	function_c81a7efa();
}

/*
	Name: function_a4ae62cc
	Namespace: namespace_6b38abe3
	Checksum: 0x355A65C
	Offset: 0x2788
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_a4ae62cc(str_flag)
{
	for(var_fce7f186 = 0; var_fce7f186 < 50; var_fce7f186++)
	{
		level util::waittill_any("flogger_killed_zombie", "trap_kill", "autoturret_killed_zombie");
	}
	level flag::set(str_flag);
	function_c81a7efa();
}

/*
	Name: function_c81a7efa
	Namespace: namespace_6b38abe3
	Checksum: 0x2481A381
	Offset: 0x2818
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_c81a7efa()
{
	/#
		iprintlnbold("");
	#/
	playsoundatposition("zmb_wearable_mechz_step", (0, 0, 0));
}

/*
	Name: function_796904fd
	Namespace: namespace_6b38abe3
	Checksum: 0xEF210D27
	Offset: 0x2868
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_796904fd()
{
	level flag::init("keeper_skull_dg4_flag");
	level flag::init("keeper_skull_turret_flag");
	level thread function_c489ad78("keeper_skull_dg4_flag");
	level thread function_f4caac35("keeper_skull_turret_flag");
	level flag::wait_till_all(array("keeper_skull_dg4_flag", "keeper_skull_turret_flag"));
	/#
		iprintlnbold("");
	#/
	playsoundatposition("zmb_wearable_wolf_howl_finish", (0, 0, 0));
	function_f6b20985("s_dire_wolf_head", "c_zom_dlc4_player_direwolf_helmet", "j_head", 0);
}

/*
	Name: function_c489ad78
	Namespace: namespace_6b38abe3
	Checksum: 0x4006BC8F
	Offset: 0x2990
	Size: 0x162
	Parameters: 1
	Flags: Linked
*/
function function_c489ad78(str_flag)
{
	var_3f709380 = struct::get("s_dire_wolf_coffin", "targetname");
	t_damage = spawn("trigger_damage", var_3f709380.origin, 0, 15, 10);
	while(true)
	{
		t_damage waittill(#"damage", amount, attacker, dir, point, mod);
		if(isdefined(mod) && mod == "MOD_GRENADE_SPLASH")
		{
			n_dist = distance(point, var_3f709380.origin);
			if(n_dist <= 90)
			{
				break;
			}
		}
	}
	level flag::set(str_flag);
	t_damage delete();
	level notify(#"hash_208ce56d");
}

/*
	Name: function_f4caac35
	Namespace: namespace_6b38abe3
	Checksum: 0xEE508679
	Offset: 0x2B00
	Size: 0x234
	Parameters: 1
	Flags: Linked
*/
function function_f4caac35(str_flag)
{
	level waittill(#"hash_208ce56d");
	var_3f709380 = struct::get("s_dire_wolf_coffin", "targetname");
	var_affd5bec = util::spawn_model("tag_origin", var_3f709380.origin, (0, 0, 0));
	var_affd5bec setmodel("p7_ban_north_tribe_lion_skull");
	s_path = struct::get("s_dire_wolf_path_start", "targetname");
	while(true)
	{
		n_time = 0.4;
		var_affd5bec moveto(s_path.origin, n_time);
		if(!isdefined(s_path.target))
		{
			var_affd5bec waittill(#"movedone");
			var_affd5bec playsound("zmb_wearable_wolf_skull_land");
			break;
		}
		else
		{
			wait(n_time - 0.05);
		}
		s_path = struct::get(s_path.target, "targetname");
	}
	var_affd5bec thread function_579caadc();
	level.var_a92f045 = 1;
	level.var_ab7d79d8 = var_affd5bec;
	for(var_fce7f186 = 0; var_fce7f186 < 15; var_fce7f186++)
	{
		level waittill(#"hash_3171c43f");
	}
	level.var_a92f045 = 0;
	wait(0.2);
	var_affd5bec delete();
	level flag::set(str_flag);
}

/*
	Name: function_579caadc
	Namespace: namespace_6b38abe3
	Checksum: 0xAE47CC3D
	Offset: 0x2D40
	Size: 0x24C
	Parameters: 0
	Flags: Linked
*/
function function_579caadc()
{
	self endon(#"death");
	v_ground_pos = self.origin;
	n_move_time = 1.5;
	var_504ff975 = 1;
	while(true)
	{
		if(level flag::get("low_grav_on") && var_504ff975)
		{
			self playsound("zmb_wearable_wolf_skull_rise");
			self playloopsound("zmb_wearable_wolf_skull_lp", 2);
			self moveto(v_ground_pos + vectorscale((0, 0, 1), 65), n_move_time, n_move_time / 8, n_move_time / 8);
			self waittill(#"movedone");
			var_504ff975 = 0;
		}
		else
		{
			if(level flag::get("low_grav_on") == 0 && !var_504ff975)
			{
				self playsound("zmb_wearable_wolf_skull_lower");
				self stoploopsound(2);
				self moveto(v_ground_pos, n_move_time, n_move_time / 8, n_move_time / 8);
				self waittill(#"movedone");
				self playsound("zmb_wearable_wolf_skull_land");
				var_504ff975 = 1;
			}
			else
			{
				if(level flag::get("low_grav_on") && !var_504ff975)
				{
					self rotateto(self.angles + vectorscale((0, 1, 0), 180), 0.5);
					wait(0.45);
				}
				else
				{
					wait(0.5);
				}
			}
		}
	}
}

/*
	Name: function_3167c564
	Namespace: namespace_6b38abe3
	Checksum: 0xB918F02F
	Offset: 0x2F98
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function function_3167c564()
{
	level flag::init("keeper_skull_dg4_flag");
	level flag::init("keeper_skull_turret_flag");
	level flag::init("keeper_skull_zombie_flag");
	level thread function_5aca8a04("keeper_skull_turret_flag");
	level thread function_cceea36c("keeper_skull_zombie_flag");
	level.var_1c301ed2 = 1;
	level flag::wait_till_all(array("keeper_skull_turret_flag", "keeper_skull_zombie_flag"));
	level.var_1c301ed2 = 0;
	/#
		iprintlnbold("");
	#/
	playsoundatposition("zmb_wearable_keeper_complete", (0, 0, 0));
	function_f6b20985("s_keeper_skull_head", "c_zom_dlc4_player_keeper_helmet", "j_head", 0);
}

/*
	Name: function_5aca8a04
	Namespace: namespace_6b38abe3
	Checksum: 0xF44FAD3D
	Offset: 0x30F8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_5aca8a04(str_flag)
{
	for(var_fce7f186 = 0; var_fce7f186 < 10; var_fce7f186++)
	{
		level waittill(#"hash_353fc85a");
	}
	playsoundatposition("zmb_wearable_keeper_step", (0, 0, 0));
	level flag::set(str_flag);
}

/*
	Name: function_cceea36c
	Namespace: namespace_6b38abe3
	Checksum: 0x42FA448F
	Offset: 0x3178
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_cceea36c(str_flag)
{
	for(var_fce7f186 = 0; var_fce7f186 < 30; var_fce7f186++)
	{
		level waittill(#"hash_dcb6576d");
	}
	playsoundatposition("zmb_wearable_keeper_step", (0, 0, 0));
	level flag::set(str_flag);
}

/*
	Name: function_4fddc919
	Namespace: namespace_6b38abe3
	Checksum: 0x27150DA9
	Offset: 0x31F8
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_4fddc919()
{
	level flag::init("margwa_head_wasps_flag");
	level flag::init("margwa_head_fire_flag");
	level flag::init("margwa_head_shadow_flag");
	level thread function_43e9a25a("margwa_head_wasps_flag");
	level thread function_9b35bbf0("margwa_head_fire_flag", "margwa_head_shadow_flag");
	level thread function_bf2067a4("margwa_head_shadow_flag", "margwa_head_fire_flag");
	level.var_16f4dfa5 = 1;
	level.margwa_head_kill_weapon_check = &function_a5131f0d;
	level flag::wait_till_all(array("margwa_head_wasps_flag", "margwa_head_fire_flag", "margwa_head_shadow_flag"));
	level.var_16f4dfa5 = 0;
	level.margwa_head_kill_weapon_check = undefined;
	/#
		iprintlnbold("");
	#/
	playsoundatposition("zmb_wearable_margwa_complete", (0, 0, 0));
	function_f6b20985("s_margwa_head", "c_zom_dlc4_player_margwa_helmet", "j_head", 0);
}

/*
	Name: function_a5131f0d
	Namespace: namespace_6b38abe3
	Checksum: 0xA5EFF186
	Offset: 0x33A8
	Size: 0xAE
	Parameters: 2
	Flags: Linked
*/
function function_a5131f0d(var_4ef2ab6, weapon)
{
	var_b6eb007c = util::getweaponclass(weapon);
	if(isdefined(var_b6eb007c) && var_b6eb007c == "weapon_sniper")
	{
		if(!isdefined(var_4ef2ab6.var_9e4e3d01))
		{
			var_4ef2ab6.var_9e4e3d01 = 0;
		}
		var_4ef2ab6.var_9e4e3d01++;
		if(var_4ef2ab6.var_9e4e3d01 == 3)
		{
			level notify(#"hash_b2146d93");
		}
	}
}

/*
	Name: function_43e9a25a
	Namespace: namespace_6b38abe3
	Checksum: 0xF6B93A6E
	Offset: 0x3460
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_43e9a25a(str_flag)
{
	level waittill(#"hash_b2146d93");
	level flag::set(str_flag);
	level thread function_838522a5();
}

/*
	Name: function_9b35bbf0
	Namespace: namespace_6b38abe3
	Checksum: 0x399AC3C3
	Offset: 0x34B8
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function function_9b35bbf0(str_flag, var_c5b75477)
{
	level waittill(#"hash_8b3deb9");
	level flag::set(str_flag);
	if(level flag::get(var_c5b75477))
	{
		level thread function_838522a5();
	}
}

/*
	Name: function_bf2067a4
	Namespace: namespace_6b38abe3
	Checksum: 0x1F68A960
	Offset: 0x3530
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function function_bf2067a4(str_flag, var_c5b75477)
{
	level waittill(#"hash_e3170555");
	level flag::set(str_flag);
	if(level flag::get(var_c5b75477))
	{
		level thread function_838522a5();
	}
}

/*
	Name: function_838522a5
	Namespace: namespace_6b38abe3
	Checksum: 0xE8FBCD17
	Offset: 0x35A8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_838522a5()
{
	playsoundatposition("zmb_wearable_margwa_step", (0, 0, 0));
}

/*
	Name: function_37ba4813
	Namespace: namespace_6b38abe3
	Checksum: 0xEE2FE8BC
	Offset: 0x35D8
	Size: 0x25C
	Parameters: 0
	Flags: Linked
*/
function function_37ba4813()
{
	level flag::init("apothicon_mask_all_zombies_killed");
	level flag::init("apothicon_mask_all_wasps_killed");
	level flag::init("apothicon_mask_all_spiders_killed");
	level flag::init("apothicon_mask_all_margwas_killed");
	level flag::init("apothicon_mask_all_fury_killed");
	level flag::init("apothicon_mask_all_keepers_killed");
	level thread function_b464a575("apothicon_mask_all_zombies_killed");
	level thread function_b507724f("apothicon_mask_all_wasps_killed");
	level thread function_d3f5f766("apothicon_mask_all_spiders_killed");
	level thread function_f6aa218a("apothicon_mask_all_margwas_killed");
	level thread function_904f0f67("apothicon_mask_all_fury_killed");
	level thread function_a94b36fd("apothicon_mask_all_keepers_killed");
	level.var_26af7b39 = 1;
	level flag::wait_till_all(array("apothicon_mask_all_zombies_killed", "apothicon_mask_all_wasps_killed", "apothicon_mask_all_spiders_killed", "apothicon_mask_all_margwas_killed", "apothicon_mask_all_fury_killed", "apothicon_mask_all_keepers_killed"));
	level.var_26af7b39 = 0;
	/#
		iprintlnbold("");
	#/
	playsoundatposition("zmb_wearable_apothigod_complete", (0, 0, 0));
	function_f6b20985("s_apothicon_mask", "c_zom_dlc4_player_apothican_helmet", "j_head", -30);
}

/*
	Name: function_b464a575
	Namespace: namespace_6b38abe3
	Checksum: 0x53235599
	Offset: 0x3840
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_b464a575(var_776628b2)
{
	for(var_fce7f186 = 0; var_fce7f186 < 50; var_fce7f186++)
	{
		level waittill(#"hash_69f0d192");
	}
	level flag::set(var_776628b2);
	level thread function_70b329b3();
}

/*
	Name: function_b507724f
	Namespace: namespace_6b38abe3
	Checksum: 0xEA3F3BB6
	Offset: 0x38C0
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_b507724f(var_776628b2)
{
	for(var_fce7f186 = 0; var_fce7f186 < 5; var_fce7f186++)
	{
		level waittill(#"hash_b7ed57c7");
	}
	level flag::set(var_776628b2);
	level thread function_70b329b3();
}

/*
	Name: function_d3f5f766
	Namespace: namespace_6b38abe3
	Checksum: 0xB8D599CA
	Offset: 0x3940
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_d3f5f766(var_776628b2)
{
	for(var_fce7f186 = 0; var_fce7f186 < 5; var_fce7f186++)
	{
		level waittill(#"hash_ca3a841");
	}
	level flag::set(var_776628b2);
	level thread function_70b329b3();
}

/*
	Name: function_f6aa218a
	Namespace: namespace_6b38abe3
	Checksum: 0x2CDEE76D
	Offset: 0x39C0
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_f6aa218a(var_776628b2)
{
	for(var_fce7f186 = 0; var_fce7f186 < 3; var_fce7f186++)
	{
		level waittill(#"hash_6571fc3d");
	}
	level flag::set(var_776628b2);
	level thread function_70b329b3();
}

/*
	Name: function_904f0f67
	Namespace: namespace_6b38abe3
	Checksum: 0xF62EE0A6
	Offset: 0x3A40
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_904f0f67(var_776628b2)
{
	for(var_fce7f186 = 0; var_fce7f186 < 10; var_fce7f186++)
	{
		level waittill(#"hash_67009580");
	}
	level flag::set(var_776628b2);
	level thread function_70b329b3();
}

/*
	Name: function_a94b36fd
	Namespace: namespace_6b38abe3
	Checksum: 0x4ECBB282
	Offset: 0x3AC0
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_a94b36fd(var_776628b2)
{
	for(var_fce7f186 = 0; var_fce7f186 < 10; var_fce7f186++)
	{
		level waittill(#"hash_6a066b2e");
	}
	level flag::set(var_776628b2);
	level thread function_70b329b3();
}

/*
	Name: function_70b329b3
	Namespace: namespace_6b38abe3
	Checksum: 0xF401682D
	Offset: 0x3B40
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_70b329b3()
{
	/#
		iprintlnbold("");
	#/
	playsoundatposition("zmb_wearable_apothigod_step", (0, 0, 0));
	level thread zm_genesis_util::function_2a0bc326(level.var_b1471d99, 0.65, 2, 800, 4);
}

/*
	Name: function_6d72c0dc
	Namespace: namespace_6b38abe3
	Checksum: 0xC231471C
	Offset: 0x3BC8
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function function_6d72c0dc()
{
	level flag::init("fury_head_sniper_kill");
	level thread function_f1691f03("fury_head_sniper_kill");
	level.var_2bb34f66 = 1;
	level flag::wait_till("fury_head_sniper_kill");
	level.var_2bb34f66 = 0;
	/#
		iprintlnbold("");
	#/
	playsoundatposition("zmb_wearable_fury_complete", (0, 0, 0));
	function_f6b20985("s_fury_head", "c_zom_dlc4_player_fury_helmet", "j_head", -30);
}

/*
	Name: function_f1691f03
	Namespace: namespace_6b38abe3
	Checksum: 0x302921A4
	Offset: 0x3CB8
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function function_f1691f03(var_776628b2)
{
	level flag::wait_till_all(array("power_on1", "power_on2", "power_on3", "power_on4"));
	for(var_fce7f186 = 0; var_fce7f186 < 40; var_fce7f186++)
	{
		level waittill(#"fury_head_sniper_kill");
	}
	level flag::set(var_776628b2);
	level thread function_716f6548();
}

/*
	Name: function_716f6548
	Namespace: namespace_6b38abe3
	Checksum: 0x59A3F01F
	Offset: 0x3D78
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_716f6548()
{
	playsoundatposition("zmb_wearable_fury_step", (0, 0, 0));
}

/*
	Name: function_9d85b9ce
	Namespace: namespace_6b38abe3
	Checksum: 0xED9070D1
	Offset: 0x3DA8
	Size: 0x4C8
	Parameters: 1
	Flags: Linked
*/
function function_9d85b9ce(e_attacker)
{
	if(isdefined(level.var_5317b760) && level.var_5317b760 && isplayer(e_attacker))
	{
		if(zm_utility::is_headshot(self.damageweapon, self.damagelocation, self.damagemod))
		{
			level.var_98fdd784 = self.origin;
			level notify(#"hash_e8c3642d");
		}
	}
	if(isplayer(e_attacker) && (isdefined(e_attacker.var_adaec269) && e_attacker.var_adaec269))
	{
		e_attacker notify(#"hash_ab106e77");
	}
	if(isplayer(e_attacker) && (isdefined(level.var_26af7b39) && level.var_26af7b39) && (isdefined(level.var_a5d2ba4) && level.var_a5d2ba4))
	{
		var_46927a7e = getent("apothicon_belly_center", "targetname");
		if(e_attacker istouching(var_46927a7e) && self istouching(var_46927a7e))
		{
			if(isdefined(self.archetype))
			{
				switch(self.archetype)
				{
					case "parasite":
					{
						level notify(#"hash_b7ed57c7");
						break;
					}
					case "margwa":
					{
						level notify(#"hash_6571fc3d");
						break;
					}
					case "zombie":
					{
						level notify(#"hash_69f0d192");
						break;
					}
					case "keeper":
					{
						level notify(#"hash_6a066b2e");
						break;
					}
					case "apothicon_fury":
					{
						level notify(#"hash_67009580");
						break;
					}
				}
			}
			level.var_b1471d99 = self.origin;
		}
	}
	if(isdefined(level.var_1c301ed2) && level.var_1c301ed2)
	{
		if(isdefined(e_attacker) && isdefined(e_attacker.archetype) && e_attacker.archetype == "keeper_companion")
		{
			if(isdefined(self.archetype) && self.archetype == "zombie")
			{
				level notify(#"hash_dcb6576d");
			}
		}
		if(self.archetype === "keeper" && isdefined(self.damageweapon) && (self.damageweapon.name == "hero_gravityspikes" || self.damageweapon.name == "hero_gravityspikes_melee"))
		{
			level notify(#"hash_d81381c8");
		}
	}
	if(isdefined(level.var_16f4dfa5) && level.var_16f4dfa5)
	{
		if(zm_ai_margwa_elemental::function_6bbd2a18(self))
		{
			level notify(#"hash_8b3deb9");
		}
		else if(zm_ai_margwa_elemental::function_b9fad980(self))
		{
			level notify(#"hash_e3170555");
		}
	}
	if(isdefined(level.var_a92f045) && level.var_a92f045)
	{
		if(level flag::get("low_grav_on"))
		{
			var_d0c30abc = level.var_ab7d79d8.origin;
			n_dist = distance(var_d0c30abc, self.origin);
			if(n_dist <= 256)
			{
				level thread zm_genesis_power::zombie_blood_soul_streak_fx(self.origin + vectorscale((0, 0, 1), 50), self.angles, var_d0c30abc, 1);
				level notify(#"hash_3171c43f");
			}
		}
	}
	if(isdefined(level.var_2bb34f66) && level.var_2bb34f66)
	{
		if(isdefined(self.archetype) && self.archetype == "apothicon_fury")
		{
			if(isdefined(self.damageweapon) && self.damageweapon.isbulletweapon)
			{
				level notify(#"fury_head_sniper_kill");
			}
		}
	}
	if(isdefined(self.var_9f6fbb95) && self.var_9f6fbb95)
	{
		level.var_2306bf38--;
	}
}

/*
	Name: function_cb27f92e
	Namespace: namespace_6b38abe3
	Checksum: 0x7A3D3B3E
	Offset: 0x4278
	Size: 0x176
	Parameters: 13
	Flags: Linked
*/
function function_cb27f92e(mod, hit_location, hit_origin, player, amount, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel)
{
	if(isplayer(player) && (isdefined(player.var_e8e8daad) && player.var_e8e8daad))
	{
		n_amount = amount / 2;
		self dodamage(n_amount, hit_origin, player);
	}
	if(isplayer(player) && (isdefined(player.var_15c79ed8) && player.var_15c79ed8))
	{
		if(isdefined(self.archetype) && self.archetype == "apothicon_fury")
		{
			n_amount = amount / 2;
			self dodamage(n_amount, hit_origin, player);
		}
	}
	return false;
}

/*
	Name: function_e8a31296
	Namespace: namespace_6b38abe3
	Checksum: 0x11C41E5C
	Offset: 0x43F8
	Size: 0x244
	Parameters: 0
	Flags: Linked
*/
function function_e8a31296()
{
	/#
		adddebugcommand(("" + "") + "");
		adddebugcommand(("" + "") + "");
		adddebugcommand(("" + "") + "");
		adddebugcommand(("" + "") + "");
		adddebugcommand(("" + "") + "");
		adddebugcommand(("" + "") + "");
		adddebugcommand(("" + "") + "");
		adddebugcommand(("" + "") + "");
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
	Name: function_b03acf4e
	Namespace: namespace_6b38abe3
	Checksum: 0x92CD238E
	Offset: 0x4648
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_b03acf4e(var_b3ecaf28)
{
	/#
		s_loc = struct::get(var_b3ecaf28, "");
		var_9f8b01da = getclosestpointonnavmesh(s_loc.origin, 100);
		if(!isdefined(var_9f8b01da))
		{
			var_9f8b01da = s_loc.origin;
		}
		self setorigin(var_9f8b01da);
	#/
}

/*
	Name: function_82e9c58d
	Namespace: namespace_6b38abe3
	Checksum: 0x49D7BE7A
	Offset: 0x46F0
	Size: 0x33E
	Parameters: 1
	Flags: Linked
*/
function function_82e9c58d(cmd)
{
	/#
		player = level.players[0];
		switch(cmd)
		{
			case "":
			{
				function_f6b20985("", "", "", 0);
				break;
			}
			case "":
			{
				function_f6b20985("", "", "", 0);
				break;
			}
			case "":
			{
				function_f6b20985("", "", "", 0);
				break;
			}
			case "":
			{
				function_f6b20985("", "", "", 0);
				break;
			}
			case "":
			{
				function_f6b20985("", "", "", 0);
				break;
			}
			case "":
			{
				function_f6b20985("", "", "", 0);
				break;
			}
			case "":
			{
				function_f6b20985("", "", "", 0);
				break;
			}
			case "":
			{
				function_f6b20985("", "", "", 0);
				break;
			}
			case "":
			{
				player function_b03acf4e("");
				break;
			}
			case "":
			{
				player function_b03acf4e("");
				break;
			}
			case "":
			{
				player function_b03acf4e("");
				break;
			}
			case "":
			{
				player function_b03acf4e("");
				break;
			}
			case "":
			{
				player function_b03acf4e("");
				break;
			}
			case "":
			{
				player function_b03acf4e("");
				break;
			}
			case "":
			{
				player function_b03acf4e("");
				break;
			}
			case "":
			{
				player function_b03acf4e("");
				break;
			}
		}
	#/
}

