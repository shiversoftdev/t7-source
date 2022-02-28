// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_ball;
#using scripts\zm\_zm_weap_octobomb;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis_apothican;
#using scripts\zm\zm_genesis_minor_ee;

#namespace zm_genesis_util;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_util
	Checksum: 0x80A1A79
	Offset: 0xB68
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_util", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_util
	Checksum: 0xFAE56691
	Offset: 0xBB0
	Size: 0x32C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	n_bits = getminbitcountfornum(8);
	clientfield::register("toplayer", "player_rumble_and_shake", 15000, n_bits, "int");
	n_bits = getminbitcountfornum(4);
	clientfield::register("scriptmover", "emit_smoke", 15000, n_bits, "int");
	n_bits = getminbitcountfornum(4);
	clientfield::register("scriptmover", "fire_trap", 15000, n_bits, "int");
	clientfield::register("actor", "fire_trap_ignite_enemy", 15000, 1, "int");
	clientfield::register("scriptmover", "rq_gateworm_magic", 15000, 1, "int");
	clientfield::register("scriptmover", "rq_gateworm_dissolve_finish", 15000, 1, "int");
	clientfield::register("scriptmover", "rq_rune_glow", 15000, 1, "int");
	registerclientfield("world", "gen_rune_electricity", 15000, 1, "int");
	registerclientfield("world", "gen_rune_fire", 15000, 1, "int");
	registerclientfield("world", "gen_rune_light", 15000, 1, "int");
	registerclientfield("world", "gen_rune_shadow", 15000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_rune_parts", 15000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_rune_quest", 15000, 1, "int");
	level.custom_spawner_entry["crawl"] = &function_48cfc7df;
	level.perk_random_idle_effects_override = &function_555e8704;
	level thread function_828240c9();
}

/*
	Name: __main__
	Namespace: zm_genesis_util
	Checksum: 0x98BCF796
	Offset: 0xEE8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	function_b6faf5c0();
	function_8fb96327();
	/#
		level thread function_30672281();
	#/
	/#
		level thread watch_for_open_sesame();
	#/
	level thread function_5bad746b();
}

/*
	Name: function_1bd652e9
	Namespace: zm_genesis_util
	Checksum: 0x82BD762E
	Offset: 0xF60
	Size: 0xC6
	Parameters: 0
	Flags: Linked
*/
function function_1bd652e9()
{
	a_ai_zombies = getaiteamarray("axis");
	n_alive = 0;
	foreach(ai_zombie in a_ai_zombies)
	{
		if(isalive(ai_zombie))
		{
			n_alive++;
		}
	}
	return n_alive;
}

/*
	Name: vec_to_string
	Namespace: zm_genesis_util
	Checksum: 0xD9293A49
	Offset: 0x1030
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function vec_to_string(v)
{
	return (((((("<") + v[0]) + ", ") + v[1]) + ", ") + v[2]) + (">");
}

/*
	Name: function_828240c9
	Namespace: zm_genesis_util
	Checksum: 0x300C7828
	Offset: 0x1088
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_828240c9()
{
	level waittill(#"start_zombie_round_logic");
	if(isdefined(level._custom_powerups["shield_charge"]))
	{
		arrayremoveindex(level._custom_powerups, "shield_charge", 1);
	}
}

/*
	Name: function_5ea427bf
	Namespace: zm_genesis_util
	Checksum: 0x97B6C6DE
	Offset: 0x10E0
	Size: 0x180
	Parameters: 1
	Flags: Linked
*/
function function_5ea427bf(player)
{
	b_visible = 1;
	if(isdefined(player.beastmode) && player.beastmode && (!(isdefined(self.allow_beastmode) && self.allow_beastmode)))
	{
		b_visible = 0;
	}
	else if(isdefined(self.stub.func_unitrigger_visible))
	{
		b_visible = self [[self.stub.func_unitrigger_visible]](player);
	}
	str_msg = &"";
	param1 = undefined;
	if(b_visible)
	{
		if(isdefined(self.stub.func_unitrigger_message))
		{
			str_msg = self [[self.stub.func_unitrigger_message]](player);
		}
		else
		{
			str_msg = self.stub.hint_string;
			param1 = self.stub.hint_parm1;
		}
	}
	if(isdefined(str_msg))
	{
		if(isdefined(param1))
		{
			self sethintstring(str_msg, param1);
		}
		else
		{
			self sethintstring(str_msg);
		}
	}
	return b_visible;
}

/*
	Name: unitrigger_refresh_message
	Namespace: zm_genesis_util
	Checksum: 0x26E65965
	Offset: 0x1268
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function unitrigger_refresh_message()
{
	self zm_unitrigger::run_visibility_function_for_all_triggers();
}

/*
	Name: unitrigger_allow_beastmode
	Namespace: zm_genesis_util
	Checksum: 0xEB5E91D5
	Offset: 0x1290
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function unitrigger_allow_beastmode()
{
	self.allow_beastmode = 1;
}

/*
	Name: unitrigger_think
	Namespace: zm_genesis_util
	Checksum: 0x85F437A3
	Offset: 0x12A8
	Size: 0x9C
	Parameters: 0
	Flags: Linked, Private
*/
function private unitrigger_think()
{
	self endon(#"kill_trigger");
	self.stub thread unitrigger_refresh_message();
	while(true)
	{
		self waittill(#"trigger", player);
		if(isdefined(self.allow_beastmode) && self.allow_beastmode || (!(isdefined(player.beastmode) && player.beastmode)))
		{
			self.stub notify(#"trigger", player);
		}
	}
}

/*
	Name: set_unitrigger_hint_string
	Namespace: zm_genesis_util
	Checksum: 0x530C1173
	Offset: 0x1350
	Size: 0x64
	Parameters: 2
	Flags: None
*/
function set_unitrigger_hint_string(str_message, param1)
{
	self.hint_string = str_message;
	self.hint_parm1 = param1;
	zm_unitrigger::unregister_unitrigger(self);
	zm_unitrigger::register_unitrigger(self, &unitrigger_think);
}

/*
	Name: spawn_unitrigger
	Namespace: zm_genesis_util
	Checksum: 0xF93D87C8
	Offset: 0x13C0
	Size: 0x1F8
	Parameters: 5
	Flags: Linked, Private
*/
function private spawn_unitrigger(origin, angles, radius_or_dims, use_trigger = 0, func_per_player_msg)
{
	trigger_stub = spawnstruct();
	trigger_stub.origin = origin;
	str_type = "unitrigger_radius";
	if(isvec(radius_or_dims))
	{
		trigger_stub.script_length = radius_or_dims[0];
		trigger_stub.script_width = radius_or_dims[1];
		trigger_stub.script_height = radius_or_dims[2];
		str_type = "unitrigger_box";
		if(!isdefined(angles))
		{
			angles = (0, 0, 0);
		}
		trigger_stub.angles = angles;
	}
	else
	{
		trigger_stub.radius = radius_or_dims;
	}
	if(use_trigger)
	{
		trigger_stub.cursor_hint = "HINT_NOICON";
		trigger_stub.script_unitrigger_type = str_type + "_use";
	}
	else
	{
		trigger_stub.script_unitrigger_type = str_type;
	}
	if(isdefined(func_per_player_msg))
	{
		trigger_stub.func_unitrigger_message = func_per_player_msg;
		zm_unitrigger::unitrigger_force_per_player_triggers(trigger_stub, 1);
	}
	trigger_stub.prompt_and_visibility_func = &function_5ea427bf;
	zm_unitrigger::register_unitrigger(trigger_stub, &unitrigger_think);
	return trigger_stub;
}

/*
	Name: spawn_trigger_radius
	Namespace: zm_genesis_util
	Checksum: 0xC5BEB279
	Offset: 0x15C0
	Size: 0x5A
	Parameters: 4
	Flags: Linked
*/
function spawn_trigger_radius(origin, radius, use_trigger = 0, func_per_player_msg)
{
	return spawn_unitrigger(origin, undefined, radius, use_trigger, func_per_player_msg);
}

/*
	Name: spawn_trigger_box
	Namespace: zm_genesis_util
	Checksum: 0xFF6C91C4
	Offset: 0x1628
	Size: 0x62
	Parameters: 5
	Flags: None
*/
function spawn_trigger_box(origin, angles, dims, use_trigger = 0, func_per_player_msg)
{
	return spawn_unitrigger(origin, angles, dims, use_trigger, func_per_player_msg);
}

/*
	Name: function_b6faf5c0
	Namespace: zm_genesis_util
	Checksum: 0xFFAD8A24
	Offset: 0x1698
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_b6faf5c0()
{
	level.var_e17963aa = [];
	level.var_7c6cbc08 = struct::get_array("smoke_emitter", "script_noteworthy");
}

/*
	Name: function_c3266652
	Namespace: zm_genesis_util
	Checksum: 0x4577ED4
	Offset: 0x16E0
	Size: 0x30A
	Parameters: 3
	Flags: Linked
*/
function function_c3266652(str_targetname, n_duration, n_offset)
{
	var_bd7e807d = array::filter(level.var_7c6cbc08, 0, &function_f889e065, str_targetname);
	/#
		assert(isdefined(var_bd7e807d), ("" + str_targetname) + "");
	#/
	if(!isdefined(level.var_e17963aa[str_targetname]))
	{
		foreach(var_dddfc725 in var_bd7e807d)
		{
			var_a535abab = util::spawn_model("tag_origin", var_dddfc725.origin, var_dddfc725.angles);
			var_a535abab.script_int = var_dddfc725.script_int;
			if(!isdefined(level.var_e17963aa[str_targetname]))
			{
				level.var_e17963aa[str_targetname] = array(var_a535abab);
				continue;
			}
			if(!isdefined(level.var_e17963aa[str_targetname]))
			{
				level.var_e17963aa[str_targetname] = [];
			}
			else if(!isarray(level.var_e17963aa[str_targetname]))
			{
				level.var_e17963aa[str_targetname] = array(level.var_e17963aa[str_targetname]);
			}
			level.var_e17963aa[str_targetname][level.var_e17963aa[str_targetname].size] = var_a535abab;
		}
	}
	/#
		assert(isdefined(level.var_e17963aa[str_targetname]), ("" + str_targetname) + "");
	#/
	foreach(var_a535abab in level.var_e17963aa[str_targetname])
	{
		var_a535abab thread function_92fbd45f(n_duration);
		if(isdefined(n_offset))
		{
			wait(n_offset);
		}
	}
}

/*
	Name: function_7c229e48
	Namespace: zm_genesis_util
	Checksum: 0x471F67FD
	Offset: 0x19F8
	Size: 0xD8
	Parameters: 1
	Flags: Linked
*/
function function_7c229e48(str_targetname)
{
	if(isdefined(level.var_e17963aa[str_targetname]))
	{
		foreach(var_a535abab in level.var_e17963aa[str_targetname])
		{
			var_a535abab thread function_d8dd128a();
		}
		level.var_e17963aa = array::remove_index(level.var_e17963aa, str_targetname, 1);
	}
}

/*
	Name: function_d8dd128a
	Namespace: zm_genesis_util
	Checksum: 0xA5B76B83
	Offset: 0x1AD8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_d8dd128a()
{
	self clientfield::set("emit_smoke", 0);
	wait(1);
	self delete();
}

/*
	Name: function_92fbd45f
	Namespace: zm_genesis_util
	Checksum: 0x278A8CE5
	Offset: 0x1B20
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function function_92fbd45f(n_duration)
{
	level endon(#"hash_306a8062");
	var_34e5a242 = self.script_int;
	if(!isdefined(var_34e5a242))
	{
		var_34e5a242 = 1;
	}
	self clientfield::set("emit_smoke", var_34e5a242);
	if(isdefined(n_duration))
	{
		wait(n_duration);
		self clientfield::set("emit_smoke", 0);
	}
}

/*
	Name: function_f889e065
	Namespace: zm_genesis_util
	Checksum: 0xE7B995D3
	Offset: 0x1BC0
	Size: 0x28
	Parameters: 2
	Flags: Linked
*/
function function_f889e065(var_dddfc725, str_targetname)
{
	return var_dddfc725.targetname === str_targetname;
}

/*
	Name: function_70f7f8aa
	Namespace: zm_genesis_util
	Checksum: 0xF146EABD
	Offset: 0x1BF0
	Size: 0x70
	Parameters: 4
	Flags: None
*/
function function_70f7f8aa(v_pos, v_angles, var_216e90fd, var_8a2d164)
{
	var_2804cb89 = util::spawn_model("tag_origin", v_pos, v_angles);
	var_2804cb89 thread function_721925b6(var_216e90fd, var_8a2d164);
	return var_2804cb89;
}

/*
	Name: function_721925b6
	Namespace: zm_genesis_util
	Checksum: 0x40ECF264
	Offset: 0x1C68
	Size: 0x144
	Parameters: 2
	Flags: Linked
*/
function function_721925b6(var_216e90fd, var_8a2d164)
{
	self endon(#"death");
	switch(var_216e90fd)
	{
		case 0:
		case 2:
		{
			self clientfield::set("fire_trap", 1);
			self.var_bbfa873e = 1;
			break;
		}
		case 1:
		case 3:
		{
			self clientfield::set("fire_trap", 3);
			self.var_bbfa873e = 2;
			break;
		}
	}
	self flag::init("deactivate_fire_trap");
	self thread function_1f629fb(var_216e90fd);
	self function_9354534f(var_216e90fd, var_8a2d164);
	self clientfield::set("fire_trap", 0);
	self notify(#"deactivate_fire_trap");
	self delete();
}

/*
	Name: function_9354534f
	Namespace: zm_genesis_util
	Checksum: 0xCF931E7E
	Offset: 0x1DB8
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function function_9354534f(var_216e90fd, var_8a2d164)
{
	if(!self flag::get("deactivate_fire_trap"))
	{
		if(var_8a2d164 > 1)
		{
			self thread function_5d940bdb(var_216e90fd, var_8a2d164);
			if(isdefined(var_8a2d164))
			{
				__s = spawnstruct();
				__s endon(#"timeout");
				__s util::delay_notify(var_8a2d164, "timeout");
			}
		}
		self waittill(#"deactivate_fire_trap");
	}
	else
	{
		wait(0.1);
	}
}

/*
	Name: function_5d940bdb
	Namespace: zm_genesis_util
	Checksum: 0xCFDA497D
	Offset: 0x1E98
	Size: 0xC2
	Parameters: 2
	Flags: Linked
*/
function function_5d940bdb(var_216e90fd, var_8a2d164)
{
	self endon(#"death");
	self endon(#"deactivate_fire_trap");
	var_16039327 = var_8a2d164 - 2;
	if(var_16039327 < 1)
	{
		var_16039327 = var_8a2d164 * 0.5;
	}
	wait(var_16039327);
	switch(var_216e90fd)
	{
		case 0:
		case 2:
		{
			self clientfield::set("fire_trap", 2);
			break;
		}
		case 1:
		case 3:
		{
			break;
		}
	}
}

/*
	Name: function_1f629fb
	Namespace: zm_genesis_util
	Checksum: 0xC93C5191
	Offset: 0x1F68
	Size: 0x320
	Parameters: 1
	Flags: Linked
*/
function function_1f629fb(var_216e90fd)
{
	self endon(#"deactivate_fire_trap");
	while(true)
	{
		a_ai_enemies = getaiteamarray(level.zombie_team);
		var_f7c98a7 = arraysortclosest(a_ai_enemies, self.origin, a_ai_enemies.size, 0, 96);
		var_f7c98a7 = array::filter(var_f7c98a7, 0, &function_2179430a);
		var_f7c98a7 = array::filter(var_f7c98a7, 0, &function_bb218fa3, self, 2304);
		if(var_f7c98a7.size)
		{
			foreach(var_7cb53454 in var_f7c98a7)
			{
				b_result = var_7cb53454 function_c8040935(var_216e90fd);
				if(isdefined(b_result) && b_result)
				{
					self notify(#"hash_b2a721cd");
					self.var_bbfa873e--;
					if(self.var_bbfa873e <= 0)
					{
						self flag::set("deactivate_fire_trap");
					}
				}
			}
		}
		a_e_players = arraysortclosest(level.activeplayers, self.origin, level.activeplayers.size, 0, 64);
		a_e_players = array::filter(a_e_players, 0, &function_bb218fa3, self, 1024);
		a_e_players = array::filter(a_e_players, 0, &function_6f7936c1);
		if(a_e_players.size)
		{
			foreach(e_player in a_e_players)
			{
				if(zm_utility::is_player_valid(e_player))
				{
					e_player thread function_28297a11();
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_c8040935
	Namespace: zm_genesis_util
	Checksum: 0xC4FB1753
	Offset: 0x2290
	Size: 0x1AC
	Parameters: 1
	Flags: Linked
*/
function function_c8040935(var_216e90fd)
{
	ai_zombie = self;
	var_1ca69a28 = zm_elemental_zombie::function_4aeed0a5("napalm");
	if(!isdefined(level.var_bd64e31e) || var_1ca69a28 < level.var_bd64e31e)
	{
		if(!(isdefined(ai_zombie.is_elemental_zombie) && ai_zombie.is_elemental_zombie))
		{
			ai_zombie.is_elemental_zombie = 1;
			ai_zombie.var_9a02a614 = "napalm";
			ai_zombie clientfield::set("fire_trap_ignite_enemy", 1);
			ai_zombie clientfield::set("arch_actor_fire_fx", 1);
			ai_zombie thread zm_elemental_zombie::napalm_zombie_death();
			ai_zombie thread zm_elemental_zombie::function_d070bfba();
			if(var_216e90fd == 2 || var_216e90fd == 3)
			{
				ai_zombie.var_6d2a9142 = 1;
			}
			else
			{
				ai_zombie.health = int(ai_zombie.health * 0.75);
				ai_zombie zombie_utility::set_zombie_run_cycle("sprint");
			}
			return true;
		}
	}
	return false;
}

/*
	Name: function_28297a11
	Namespace: zm_genesis_util
	Checksum: 0x20D52CB8
	Offset: 0x2448
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_28297a11()
{
	self endon(#"death");
	self.var_c0ad0afe = 1;
	self dodamage(20, self.origin);
	wait(2);
	self.var_c0ad0afe = 0;
}

/*
	Name: function_bb218fa3
	Namespace: zm_genesis_util
	Checksum: 0x60A8D580
	Offset: 0x24A0
	Size: 0x48
	Parameters: 3
	Flags: Linked
*/
function function_bb218fa3(var_7cb53454, var_2804cb89, n_dist_2d_sq)
{
	return distance2dsquared(var_7cb53454.origin, var_2804cb89.origin) < n_dist_2d_sq;
}

/*
	Name: function_2179430a
	Namespace: zm_genesis_util
	Checksum: 0xD62EFE62
	Offset: 0x24F0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_2179430a(var_7cb53454)
{
	return !(isdefined(var_7cb53454.is_elemental_zombie) && var_7cb53454.is_elemental_zombie) && var_7cb53454.classname != "script_vehicle";
}

/*
	Name: function_6f7936c1
	Namespace: zm_genesis_util
	Checksum: 0x4A1508B6
	Offset: 0x2548
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function function_6f7936c1(var_7cb53454)
{
	return !(isdefined(var_7cb53454.var_c0ad0afe) && var_7cb53454.var_c0ad0afe);
}

/*
	Name: set_rumble_to_player
	Namespace: zm_genesis_util
	Checksum: 0x9BA03673
	Offset: 0x2580
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function set_rumble_to_player(n_rumbletype, var_d00db512)
{
	self notify(#"set_rumble_to_player");
	self endon(#"disconnect");
	self endon(#"set_rumble_to_player");
	self thread clientfield::set_to_player("player_rumble_and_shake", n_rumbletype);
	if(isdefined(var_d00db512))
	{
		wait(var_d00db512);
		self thread set_rumble_to_player(0);
	}
}

/*
	Name: function_3a7a7013
	Namespace: zm_genesis_util
	Checksum: 0x4E59F8B9
	Offset: 0x2610
	Size: 0x102
	Parameters: 4
	Flags: None
*/
function function_3a7a7013(n_rumbletype, n_radius, v_origin, var_d00db512)
{
	var_699d80d5 = n_radius * n_radius;
	foreach(player in level.activeplayers)
	{
		if(isdefined(player) && distance2dsquared(player.origin, v_origin) <= var_699d80d5)
		{
			player thread set_rumble_to_player(n_rumbletype, var_d00db512);
		}
	}
}

/*
	Name: setup_devgui_func
	Namespace: zm_genesis_util
	Checksum: 0x8B3F3B68
	Offset: 0x2720
	Size: 0x120
	Parameters: 5
	Flags: Linked
*/
function setup_devgui_func(str_devgui_path, str_dvar, n_value, func, n_base_value = -1)
{
	setdvar(str_dvar, n_base_value);
	adddebugcommand(((((("devgui_cmd \"" + str_devgui_path) + "\" \"") + str_dvar) + " ") + n_value) + "\"\n");
	while(true)
	{
		n_dvar = getdvarint(str_dvar);
		if(n_dvar > n_base_value)
		{
			[[func]](n_dvar);
			setdvar(str_dvar, n_base_value);
		}
		util::wait_network_frame();
	}
}

/*
	Name: zombie_is_target_reachable
	Namespace: zm_genesis_util
	Checksum: 0x6E9EB754
	Offset: 0x2848
	Size: 0x2E4
	Parameters: 1
	Flags: None
*/
function zombie_is_target_reachable(player)
{
	var_cfd1da70 = self.zone_name;
	player_zone = player.zone_name;
	if(var_cfd1da70 === player_zone)
	{
		return 1;
	}
	if(!isdefined(var_cfd1da70) || !isdefined(player_zone))
	{
		return 0;
	}
	var_9165799c = level.zones[self.zone_name].district;
	var_e8c4df7b = level.zones[player.zone_name].district;
	var_bb534481 = level.zones[self.zone_name].area;
	var_147beb1e = level.zones[player.zone_name].area;
	if(var_bb534481 == 0 && var_147beb1e == 0)
	{
		return 1;
	}
	if(var_9165799c === var_e8c4df7b && var_bb534481 === var_147beb1e)
	{
		return 1;
	}
	if(var_9165799c === var_e8c4df7b)
	{
		if(var_bb534481 > var_147beb1e)
		{
			temp = var_bb534481;
			var_bb534481 = var_147beb1e;
			var_147beb1e = temp;
		}
		var_54f2276d = function_17c00a4f(var_9165799c, var_bb534481, var_e8c4df7b, var_147beb1e);
		return var_54f2276d;
	}
	if(var_bb534481 == 0 && var_147beb1e != 0)
	{
		var_54f2276d = function_17c00a4f("junction", 0, var_e8c4df7b, var_147beb1e);
		return var_54f2276d;
	}
	if(var_147beb1e == 0 && var_bb534481 != 0)
	{
		var_54f2276d = function_17c00a4f("junction", 0, var_9165799c, var_bb534481);
		return var_54f2276d;
	}
	var_92280803 = 1;
	var_58b7daa8 = 1;
	var_92280803 = function_17c00a4f("junction", 0, var_9165799c, var_bb534481);
	var_58b7daa8 = function_17c00a4f("junction", 0, var_e8c4df7b, var_147beb1e);
	return var_58b7daa8 && var_92280803;
}

/*
	Name: function_555e8704
	Namespace: zm_genesis_util
	Checksum: 0x99B4BAF8
	Offset: 0x2B38
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_555e8704()
{
	if(!isdefined(self.unitrigger_stub.in_zone))
	{
		/#
			iprintlnbold("");
		#/
		return;
	}
	switch(self.unitrigger_stub.in_zone)
	{
		case "zm_tomb_trench2_zone":
		{
			str_exploder = "fxexp_261";
			break;
		}
		case "zm_tomb_ruins_interior_zone":
		{
			str_exploder = "fxexp_262";
			break;
		}
		case "zm_asylum_kitchen_landing_zone":
		{
			str_exploder = "fxexp_263";
			break;
		}
		case "zm_theater_hallway_zone":
		{
			str_exploder = " fxexp_264";
			break;
		}
	}
	if(!isdefined(str_exploder))
	{
		/#
			iprintlnbold("");
		#/
		return;
	}
	exploder::exploder(str_exploder);
	while(self.state == "idle")
	{
		wait(0.05);
	}
	exploder::exploder_stop(str_exploder);
}

/*
	Name: function_17c00a4f
	Namespace: zm_genesis_util
	Checksum: 0x9C3B2F99
	Offset: 0x2C78
	Size: 0x28
	Parameters: 4
	Flags: Linked
*/
function function_17c00a4f(var_9165799c, var_25cf04a1, var_e8c4df7b, player_area)
{
	return true;
}

/*
	Name: function_48cfc7df
	Namespace: zm_genesis_util
	Checksum: 0x80C9E93
	Offset: 0x2CA8
	Size: 0x21E
	Parameters: 1
	Flags: Linked
*/
function function_48cfc7df(s_spot)
{
	self endon(#"death");
	self.var_2be9fa75 = 1;
	self ghost();
	var_37b7ca78 = "cin_zm_dlc1_zombie_undercroft_spawn_" + randomintrange(1, 3);
	if(!isdefined(s_spot.angles))
	{
		s_spot.angles = (0, 0, 0);
	}
	mdl_anchor = util::spawn_model("tag_origin", self.origin, self.angles);
	self linkto(mdl_anchor);
	self thread anchor_delete_watcher(mdl_anchor);
	mdl_anchor endon(#"death");
	mdl_anchor.origin = s_spot.origin;
	mdl_anchor.angles = s_spot.angles;
	util::wait_network_frame();
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	self.create_eyes = 1;
	self show();
	if(isalive(self) && self.health > 0)
	{
		mdl_anchor scene::play(var_37b7ca78, self);
	}
	self.var_2be9fa75 = 0;
	self unlink();
	self notify(#"risen", s_spot.script_string);
}

/*
	Name: anchor_delete_watcher
	Namespace: zm_genesis_util
	Checksum: 0x5DE97D0E
	Offset: 0x2ED0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function anchor_delete_watcher(mdl_anchor)
{
	self util::waittill_any("death", "risen");
	util::wait_network_frame();
	if(isdefined(mdl_anchor))
	{
		mdl_anchor delete();
	}
}

/*
	Name: function_42108922
	Namespace: zm_genesis_util
	Checksum: 0xCB5AFC38
	Offset: 0x2F40
	Size: 0x94
	Parameters: 2
	Flags: Linked
*/
function function_42108922(str_zone, str_flag)
{
	/#
		assert(isdefined(level.zones[str_zone]), ("" + str_zone) + "");
	#/
	level flag::wait_till(str_flag);
	if(zm_zonemgr::zone_is_enabled(str_zone))
	{
		return;
	}
	zm_zonemgr::enable_zone(str_zone);
}

/*
	Name: function_342295d8
	Namespace: zm_genesis_util
	Checksum: 0x290CB1B9
	Offset: 0x2FE0
	Size: 0xC0
	Parameters: 2
	Flags: Linked
*/
function function_342295d8(str_zone, b_enable = 1)
{
	/#
		assert(isdefined(level.zones[str_zone]), ("" + str_zone) + "");
	#/
	if(b_enable && zm_zonemgr::zone_is_enabled(str_zone))
	{
		return;
	}
	level.zones[str_zone].is_enabled = b_enable;
	level.zones[str_zone].is_spawning_allowed = b_enable;
}

/*
	Name: function_37a5b776
	Namespace: zm_genesis_util
	Checksum: 0xFCC1360
	Offset: 0x30A8
	Size: 0x1D8
	Parameters: 0
	Flags: Linked
*/
function function_37a5b776()
{
	var_a8951c29 = [];
	var_9e84b959 = array("start_island", "apothicon_island", "temple_island", "prototype_island", "asylum_island", "prison_island", "arena_island");
	for(i = 0; i < var_9e84b959.size; i++)
	{
		e_island = getent(var_9e84b959[i], "targetname");
		for(j = 0; j < level.activeplayers.size; j++)
		{
			if(isdefined(level.activeplayers[j].is_flung) && level.activeplayers[j].is_flung)
			{
				return true;
			}
			if(level.activeplayers[j] istouching(e_island))
			{
				array::add(var_a8951c29, e_island, 0);
			}
		}
	}
	if(!var_a8951c29.size)
	{
		return true;
	}
	for(k = 0; k < var_a8951c29.size; k++)
	{
		if(self istouching(var_a8951c29[k]))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: monitor_wallrun_trigger
	Namespace: zm_genesis_util
	Checksum: 0x6BED65ED
	Offset: 0x3288
	Size: 0xE0
	Parameters: 2
	Flags: Linked
*/
function monitor_wallrun_trigger(str_trigger, str_flag)
{
	t_trigger = getent(str_trigger, "targetname");
	level flag::init(str_flag);
	while(true)
	{
		t_trigger waittill(#"trigger", e_triggerer);
		if(!(isdefined(e_triggerer.b_wall_run_enabled) && e_triggerer.b_wall_run_enabled) && level flag::get(str_flag))
		{
			e_triggerer thread enable_wallrun(t_trigger, str_flag);
		}
	}
}

/*
	Name: function_88777efd
	Namespace: zm_genesis_util
	Checksum: 0x3D5A6905
	Offset: 0x3370
	Size: 0x110
	Parameters: 2
	Flags: Linked
*/
function function_88777efd(str_trigger, str_flag)
{
	t_trigger = getent(str_trigger, "targetname");
	level flag::init(str_flag);
	while(true)
	{
		t_trigger waittill(#"trigger", e_triggerer);
		if(!isplayer(e_triggerer))
		{
			wait(0.1);
			continue;
		}
		if(!(isdefined(e_triggerer.var_7dd18a0) && e_triggerer.var_7dd18a0) && level flag::get(str_flag))
		{
			e_triggerer thread function_36bd06cd(t_trigger, str_flag);
		}
		wait(0.1);
	}
}

/*
	Name: enable_wallrun
	Namespace: zm_genesis_util
	Checksum: 0x8B8692B2
	Offset: 0x3488
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function enable_wallrun(t_trigger, str_flag)
{
	self endon(#"death");
	self.b_wall_run_enabled = 1;
	self allowwallrun(1);
	while(self istouching(t_trigger) && level flag::get(str_flag))
	{
		wait(0.05);
	}
	self.b_wall_run_enabled = 0;
	self allowwallrun(0);
}

/*
	Name: function_36bd06cd
	Namespace: zm_genesis_util
	Checksum: 0x7FCD784E
	Offset: 0x3538
	Size: 0xE8
	Parameters: 2
	Flags: Linked
*/
function function_36bd06cd(t_trigger, str_flag)
{
	self endon(#"death");
	self allowdoublejump(1);
	self setperk("specialty_lowgravity");
	self.var_7dd18a0 = 1;
	while(self istouching(t_trigger) && level flag::get(str_flag))
	{
		wait(0.05);
	}
	self allowdoublejump(0);
	self unsetperk("specialty_lowgravity");
	self.var_7dd18a0 = 0;
}

/*
	Name: function_89067abe
	Namespace: zm_genesis_util
	Checksum: 0x85CCABF2
	Offset: 0x3628
	Size: 0x168
	Parameters: 4
	Flags: Linked
*/
function function_89067abe(e_player, str_text, xpos, ypos)
{
	hudelem = newclienthudelem(e_player);
	if(isdefined(xpos))
	{
		hudelem.alignx = "left";
		hudelem.x = xpos;
	}
	else
	{
		hudelem.alignx = "center";
		hudelem.horzalign = "center";
		hudelem.aligny = "middle";
		hudelem.vertalign = "middle";
	}
	hudelem.y = ypos;
	hudelem.foreground = 1;
	hudelem.font = "default";
	hudelem.fontscale = 1.2;
	hudelem.alpha = 1;
	hudelem.color = (1, 1, 1);
	hudelem settext(str_text);
	return hudelem;
}

/*
	Name: function_a1bfa962
	Namespace: zm_genesis_util
	Checksum: 0x76B08C3D
	Offset: 0x3798
	Size: 0x160
	Parameters: 4
	Flags: Linked
*/
function function_a1bfa962(e_player, str_text, xpos, ypos)
{
	hudelem = newhudelem();
	if(isdefined(xpos))
	{
		hudelem.alignx = "left";
		hudelem.x = xpos;
	}
	else
	{
		hudelem.alignx = "center";
		hudelem.horzalign = "center";
		hudelem.aligny = "middle";
		hudelem.vertalign = "middle";
	}
	hudelem.y = ypos;
	hudelem.foreground = 1;
	hudelem.font = "default";
	hudelem.fontscale = 1.2;
	hudelem.alpha = 1;
	hudelem.color = (1, 1, 1);
	hudelem settext(str_text);
	return hudelem;
}

/*
	Name: array_remove
	Namespace: zm_genesis_util
	Checksum: 0xFE298400
	Offset: 0x3900
	Size: 0x11C
	Parameters: 2
	Flags: Linked
*/
function array_remove(array, object)
{
	if(!isdefined(array) && !isdefined(object))
	{
		return;
	}
	new_array = [];
	foreach(item in array)
	{
		if(item != object)
		{
			if(!isdefined(new_array))
			{
				new_array = [];
			}
			else if(!isarray(new_array))
			{
				new_array = array(new_array);
			}
			new_array[new_array.size] = item;
		}
	}
	return new_array;
}

/*
	Name: function_adcc0e33
	Namespace: zm_genesis_util
	Checksum: 0xE0C7EA04
	Offset: 0x3A28
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function function_adcc0e33()
{
	var_91bcd8f1 = 0;
	a_zombies = getaiteamarray("axis");
	for(i = 0; i < a_zombies.size; i++)
	{
		if(isdefined(a_zombies[i].is_parasite) && a_zombies[i].is_parasite)
		{
			var_91bcd8f1++;
		}
	}
	return var_91bcd8f1;
}

/*
	Name: function_c6462c91
	Namespace: zm_genesis_util
	Checksum: 0x164147DE
	Offset: 0x3AD0
	Size: 0x9A
	Parameters: 0
	Flags: None
*/
function function_c6462c91()
{
	var_2a3db9af = 0;
	a_zombies = getaiteamarray("axis");
	for(i = 0; i < a_zombies.size; i++)
	{
		if(isdefined(a_zombies[i].b_is_spider) && a_zombies[i].b_is_spider)
		{
			var_2a3db9af++;
		}
	}
	return var_2a3db9af;
}

/*
	Name: function_e3e6bdba
	Namespace: zm_genesis_util
	Checksum: 0xCDE33470
	Offset: 0x3B78
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function function_e3e6bdba()
{
	var_9911df60 = 0;
	a_zombies = getaiteamarray("axis");
	for(i = 0; i < a_zombies.size; i++)
	{
		if(isdefined(a_zombies[i].var_b8385ee5) && a_zombies[i].var_b8385ee5)
		{
			var_9911df60++;
		}
	}
	return var_9911df60;
}

/*
	Name: function_23ee29c0
	Namespace: zm_genesis_util
	Checksum: 0x5947020F
	Offset: 0x3C20
	Size: 0x9A
	Parameters: 0
	Flags: None
*/
function function_23ee29c0()
{
	var_87f7eede = 0;
	a_zombies = getaiteamarray("axis");
	for(i = 0; i < a_zombies.size; i++)
	{
		if(isdefined(a_zombies[i].var_1cba9ac3) && a_zombies[i].var_1cba9ac3)
		{
			var_87f7eede++;
		}
	}
	return var_87f7eede;
}

/*
	Name: function_2a0bc326
	Namespace: zm_genesis_util
	Checksum: 0x5B1B8336
	Offset: 0x3CC8
	Size: 0x152
	Parameters: 7
	Flags: Linked
*/
function function_2a0bc326(v_pos, var_48f82942, var_51fbdea, var_644bf6a7, var_8f4ca4be, str_rumble_type = "damage_heavy", var_183c13ad)
{
	if(var_48f82942)
	{
		earthquake(var_48f82942, var_51fbdea, v_pos, var_644bf6a7);
	}
	var_5ca58060 = var_644bf6a7 * var_644bf6a7;
	foreach(player in level.activeplayers)
	{
		if(isdefined(var_183c13ad))
		{
			player shellshock(var_183c13ad, var_51fbdea);
		}
		player thread function_e42cebb6(v_pos, var_5ca58060, var_8f4ca4be, str_rumble_type);
	}
}

/*
	Name: function_e42cebb6
	Namespace: zm_genesis_util
	Checksum: 0x3B0F978
	Offset: 0x3E28
	Size: 0x9E
	Parameters: 4
	Flags: Linked
*/
function function_e42cebb6(v_pos, var_5ca58060, var_8f4ca4be, str_rumble_type)
{
	self endon(#"death");
	for(i = 0; i < var_8f4ca4be; i++)
	{
		if(distancesquared(v_pos, self.origin) <= var_5ca58060)
		{
			self playrumbleonentity(str_rumble_type);
		}
		wait(0.1);
	}
}

/*
	Name: function_8fb96327
	Namespace: zm_genesis_util
	Checksum: 0x7CFA3FEE
	Offset: 0x3ED0
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function function_8fb96327()
{
	level.var_d2484e02 = [];
	level.var_94994361 = [];
	level.var_3787c9a = [];
	level flag::init("electricity_rq_started");
	level flag::init("fire_rq_started");
	level flag::init("light_rq_started");
	level flag::init("shadow_rq_started");
	level flag::init("electricity_rq_done");
	level flag::init("fire_rq_done");
	level flag::init("light_rq_done");
	level flag::init("shadow_rq_done");
	level thread electricity_rune_quest_start();
	level thread fire_rune_quest_start();
	level thread light_rune_quest_start();
	level thread shadow_rune_quest_start();
}

/*
	Name: electricity_rune_quest_start
	Namespace: zm_genesis_util
	Checksum: 0x7EC66C92
	Offset: 0x4060
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function electricity_rune_quest_start()
{
	a_s_start_pos = struct::get_array("electricity_rune_quest_start", "targetname");
	s_start_pos = array::random(a_s_start_pos);
	s_start_pos thread function_15e7a0c8("electricity_rq_started", &function_2f157912, &function_e889d17c);
}

/*
	Name: function_2f157912
	Namespace: zm_genesis_util
	Checksum: 0x892FF661
	Offset: 0x40F8
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function function_2f157912(e_who)
{
	return function_af60288e(e_who, 0);
}

/*
	Name: function_e889d17c
	Namespace: zm_genesis_util
	Checksum: 0xD751073D
	Offset: 0x4128
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_e889d17c(e_who)
{
	self function_87cb72e4(e_who, 0);
}

/*
	Name: fire_rune_quest_start
	Namespace: zm_genesis_util
	Checksum: 0x64D47AA1
	Offset: 0x4158
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function fire_rune_quest_start()
{
	a_s_start_pos = struct::get_array("fire_rune_quest_start", "targetname");
	s_start_pos = array::random(a_s_start_pos);
	s_start_pos thread function_15e7a0c8("fire_rq_started", &function_8164c629, &function_9b7022b5);
}

/*
	Name: function_8164c629
	Namespace: zm_genesis_util
	Checksum: 0x1462DCF0
	Offset: 0x41F0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function function_8164c629(e_who)
{
	return function_af60288e(e_who, 1);
}

/*
	Name: function_9b7022b5
	Namespace: zm_genesis_util
	Checksum: 0xB73884DB
	Offset: 0x4220
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_9b7022b5(e_who)
{
	self function_87cb72e4(e_who, 1);
}

/*
	Name: light_rune_quest_start
	Namespace: zm_genesis_util
	Checksum: 0x45879C8E
	Offset: 0x4258
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function light_rune_quest_start()
{
	a_s_start_pos = struct::get_array("light_rune_quest_start", "targetname");
	s_start_pos = array::random(a_s_start_pos);
	s_start_pos thread function_15e7a0c8("light_rq_started", &function_45c80653, &function_aef2e0a3);
}

/*
	Name: function_45c80653
	Namespace: zm_genesis_util
	Checksum: 0xC1BABAA3
	Offset: 0x42F0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function function_45c80653(e_who)
{
	return function_af60288e(e_who, 2);
}

/*
	Name: function_aef2e0a3
	Namespace: zm_genesis_util
	Checksum: 0x11627370
	Offset: 0x4320
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_aef2e0a3(e_who)
{
	self function_87cb72e4(e_who, 2);
}

/*
	Name: shadow_rune_quest_start
	Namespace: zm_genesis_util
	Checksum: 0xEF708087
	Offset: 0x4358
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function shadow_rune_quest_start()
{
	a_s_start_pos = struct::get_array("shadow_rune_quest_start", "targetname");
	s_start_pos = array::random(a_s_start_pos);
	s_start_pos thread function_15e7a0c8("shadow_rq_started", &function_9944ee4d, &function_6d12ad69);
}

/*
	Name: function_9944ee4d
	Namespace: zm_genesis_util
	Checksum: 0x1F6BD998
	Offset: 0x43F0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function function_9944ee4d(e_who)
{
	return function_af60288e(e_who, 3);
}

/*
	Name: function_6d12ad69
	Namespace: zm_genesis_util
	Checksum: 0xADD6D0BE
	Offset: 0x4420
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_6d12ad69(e_who)
{
	self function_87cb72e4(e_who, 3);
}

/*
	Name: function_87cb72e4
	Namespace: zm_genesis_util
	Checksum: 0x68BC12F4
	Offset: 0x4458
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function function_87cb72e4(e_who, var_e4342d5d)
{
	level.var_94994361[var_e4342d5d] = e_who;
	function_f3a1c8c5(var_e4342d5d, self);
}

/*
	Name: function_af60288e
	Namespace: zm_genesis_util
	Checksum: 0xF2DB0318
	Offset: 0x44A0
	Size: 0x8E
	Parameters: 2
	Flags: Linked
*/
function function_af60288e(e_who, var_e4342d5d)
{
	if(zm_utility::is_player_valid(e_who) && !isdefined(level.var_94994361[var_e4342d5d]) && !array::contains(level.var_94994361, e_who) && e_who flag::get("holding_gateworm"))
	{
		return true;
	}
	return false;
}

/*
	Name: function_5bad746b
	Namespace: zm_genesis_util
	Checksum: 0x13C98F20
	Offset: 0x4538
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_5bad746b()
{
	level flag::wait_till("connect_start_to_left");
	level thread scene::play("debris_sheffield_prison", "targetname");
}

/*
	Name: function_15e7a0c8
	Namespace: zm_genesis_util
	Checksum: 0x416C9981
	Offset: 0x4590
	Size: 0x204
	Parameters: 3
	Flags: Linked
*/
function function_15e7a0c8(var_7b429b7d, var_6908e64b, var_4162ae69)
{
	if(!level flag::exists(var_7b429b7d))
	{
		level flag::init(var_7b429b7d);
	}
	v_pos = self.origin;
	v_angles = self.angles;
	level thread function_83fe94ad(v_pos, var_7b429b7d);
	s_unitrigger_stub = spawn_trigger_radius(v_pos, 72, 1, &function_e0596480);
	while(!level flag::get(var_7b429b7d))
	{
		s_unitrigger_stub waittill(#"trigger", e_who);
		var_a97dcbff = e_who flag::get("holding_gateworm");
		if(isdefined(var_6908e64b))
		{
			var_a97dcbff = [[var_6908e64b]](e_who);
		}
		if(var_a97dcbff)
		{
			level flag::set(var_7b429b7d);
			e_who notify(#"gateworm_used");
			zm_unitrigger::unregister_unitrigger(s_unitrigger_stub);
			if(e_who flag::get("holding_gateworm"))
			{
				e_who zm_genesis_apothican::function_4aa2c78f();
			}
			e_who function_442d17f2(v_pos, v_angles);
			if(isdefined(var_4162ae69))
			{
				self [[var_4162ae69]](e_who);
			}
		}
	}
}

/*
	Name: function_e0596480
	Namespace: zm_genesis_util
	Checksum: 0xEC88A992
	Offset: 0x47A0
	Size: 0x12
	Parameters: 1
	Flags: Linked
*/
function function_e0596480(e_who)
{
	return &"";
}

/*
	Name: function_83fe94ad
	Namespace: zm_genesis_util
	Checksum: 0xE4F9D7EE
	Offset: 0x47C0
	Size: 0x218
	Parameters: 2
	Flags: Linked
*/
function function_83fe94ad(v_start_pos, var_7b429b7d)
{
	while(!level flag::get(var_7b429b7d))
	{
		var_c1dd1728 = array::get_all_closest(v_start_pos, level.activeplayers, undefined, level.activeplayers.size, 384);
		foreach(var_268f35e1 in var_c1dd1728)
		{
			if(zm_utility::is_player_valid(var_268f35e1))
			{
				if(!isdefined(var_268f35e1.var_46c533bd))
				{
					var_268f35e1.var_46c533bd = [];
				}
				if(var_268f35e1 function_ba3dff48(var_7b429b7d))
				{
					if(!isdefined(var_268f35e1.var_46c533bd))
					{
						var_268f35e1.var_46c533bd = [];
					}
					else if(!isarray(var_268f35e1.var_46c533bd))
					{
						var_268f35e1.var_46c533bd = array(var_268f35e1.var_46c533bd);
					}
					var_268f35e1.var_46c533bd[var_268f35e1.var_46c533bd.size] = var_7b429b7d;
					var_268f35e1 thread function_e495c2b6(var_7b429b7d);
					var_268f35e1 thread function_ae4d938c(v_start_pos, 384, 72, "gateworm_used");
				}
			}
		}
		wait(0.2);
	}
}

/*
	Name: function_ba3dff48
	Namespace: zm_genesis_util
	Checksum: 0xB7ACE5BF
	Offset: 0x49E0
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function function_ba3dff48(var_7b429b7d)
{
	if(self flag::get("holding_gateworm") && !array::contains(self.var_46c533bd, var_7b429b7d))
	{
		return true;
	}
	return false;
}

/*
	Name: function_e495c2b6
	Namespace: zm_genesis_util
	Checksum: 0x20272390
	Offset: 0x4A40
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_e495c2b6(var_7b429b7d)
{
	self endon(#"disconnect");
	self function_d3845622(var_7b429b7d);
	self.var_46c533bd = array::exclude(self.var_46c533bd, var_7b429b7d);
}

/*
	Name: function_d3845622
	Namespace: zm_genesis_util
	Checksum: 0xA9F97ADE
	Offset: 0x4AA0
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_d3845622(var_7b429b7d)
{
	level endon(var_7b429b7d);
	self flag::wait_till_clear("holding_gateworm");
}

/*
	Name: function_442d17f2
	Namespace: zm_genesis_util
	Checksum: 0xED98CB32
	Offset: 0x4AE0
	Size: 0x21C
	Parameters: 2
	Flags: Linked
*/
function function_442d17f2(v_start_pos, v_angles)
{
	v_spawn_pos = self geteye() + (anglestoforward(self getplayerangles()) * 64);
	var_7add4736 = util::spawn_model("tag_origin", v_spawn_pos, v_angles);
	mdl_gateworm = util::spawn_model("p7_zm_dlc4_gateworm", v_spawn_pos, v_angles);
	mdl_gateworm linkto(var_7add4736);
	mdl_gateworm thread scene::play("zm_dlc4_gateworm_idle_basin", mdl_gateworm);
	self thread util::delete_on_death(var_7add4736);
	self thread util::delete_on_death(mdl_gateworm);
	mdl_gateworm thread function_9646de9a();
	v_ground_pos = bullettrace(v_start_pos, v_start_pos + (vectorscale((0, 0, -1), 100000)), 0, mdl_gateworm)["position"];
	var_7add4736 moveto(v_ground_pos, 4);
	var_7add4736 playsound("zmb_main_searchparty_worm_appear");
	var_7add4736 playloopsound("zmb_main_omelettes_worm_lp", 1);
	var_7add4736 waittill(#"movedone");
	mdl_gateworm thread function_364b1972(var_7add4736);
}

/*
	Name: function_9646de9a
	Namespace: zm_genesis_util
	Checksum: 0x9A8D3182
	Offset: 0x4D08
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_9646de9a()
{
	self clientfield::set("rq_gateworm_magic", 1);
	wait(2);
	self playsound("zmb_main_searchparty_worm_disapparate");
	self stoploopsound(3);
	self setmodel("p7_zm_dlc4_gateworm_dissolve");
	self clientfield::set("rq_gateworm_dissolve_finish", 1);
	wait(2);
}

/*
	Name: function_364b1972
	Namespace: zm_genesis_util
	Checksum: 0x42E0FF12
	Offset: 0x4DC0
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_364b1972(var_7add4736)
{
	self ghost();
	wait(0.8);
	self clientfield::set("rq_gateworm_magic", 0);
	self delete();
	var_7add4736 delete();
}

/*
	Name: function_f3a1c8c5
	Namespace: zm_genesis_util
	Checksum: 0x9D3BDC00
	Offset: 0x4E48
	Size: 0x398
	Parameters: 2
	Flags: Linked
*/
function function_f3a1c8c5(var_e4342d5d, s_pos)
{
	switch(var_e4342d5d)
	{
		case 0:
		{
			var_25b51f6b = "p7_fxanim_zm_gen_rune_discovery_electricity_mod";
			var_b96024 = "p7_fxanim_zm_gen_rune_discovery_electricity_bundle";
			break;
		}
		case 1:
		{
			var_25b51f6b = "p7_fxanim_zm_gen_rune_discovery_fire_mod";
			var_b96024 = "p7_fxanim_zm_gen_rune_discovery_fire_bundle";
			break;
		}
		case 2:
		{
			var_25b51f6b = "p7_fxanim_zm_gen_rune_discovery_light_mod";
			var_b96024 = "p7_fxanim_zm_gen_rune_discovery_light_bundle";
			break;
		}
		case 3:
		{
			var_25b51f6b = "p7_fxanim_zm_gen_rune_discovery_shadow_mod";
			var_b96024 = "p7_fxanim_zm_gen_rune_discovery_shadow_bundle";
			break;
		}
	}
	level.var_7bddd74e[var_e4342d5d] = util::spawn_model(var_25b51f6b, s_pos.origin, s_pos.angles - vectorscale((0, 1, 0), 90));
	var_7b98b639 = level.var_7bddd74e[var_e4342d5d];
	var_7b98b639 thread scene::play(var_b96024, var_7b98b639);
	var_7b98b639 clientfield::set("rq_rune_glow", 1);
	v_pos = bullettrace(self.origin, self.origin + (vectorscale((0, 0, -1), 100000)), 0, s_pos)["position"];
	v_pos = v_pos + vectorscale((0, 0, 1), 32);
	s_unitrigger_stub = spawn_trigger_radius(v_pos, 128, 1);
	s_unitrigger_stub.var_e4342d5d = var_e4342d5d;
	s_unitrigger_stub.hint_string = "";
	if(distancesquared(var_7b98b639.origin, v_pos) > 102400)
	{
		var_7b98b639.origin = v_pos;
	}
	if(distancesquared(var_7b98b639.origin, v_pos) > 102400)
	{
		var_7b98b639.origin = v_pos;
	}
	while(true)
	{
		s_unitrigger_stub waittill(#"trigger", e_who);
		if(zm_utility::is_player_valid(e_who) && (e_who == level.var_94994361[var_e4342d5d] || !isdefined(level.var_94994361[var_e4342d5d])))
		{
			zm_unitrigger::unregister_unitrigger(s_unitrigger_stub);
			var_7b98b639 delete();
			e_who playsound("zmb_main_searchparty_rune_pickup");
			e_who function_bb26d959(var_e4342d5d);
			if(isdefined(self))
			{
				self notify(#"hash_22e3a570");
			}
			return;
		}
	}
}

/*
	Name: function_bb26d959
	Namespace: zm_genesis_util
	Checksum: 0x3DF88EBD
	Offset: 0x51E8
	Size: 0x254
	Parameters: 1
	Flags: Linked
*/
function function_bb26d959(var_e4342d5d)
{
	level.var_94994361[var_e4342d5d] = undefined;
	level.var_3787c9a[var_e4342d5d] = undefined;
	switch(var_e4342d5d)
	{
		case 0:
		{
			level flag::set("electricity_rq_done");
			str_text = "ELECTRICITY RUNE";
			str_tag_name = "electricity";
			var_198c807f = 10;
			n_y_pos = 200;
			break;
		}
		case 1:
		{
			level flag::set("fire_rq_done");
			str_text = "FIRE RUNE";
			str_tag_name = "fire";
			var_198c807f = 10;
			n_y_pos = 220;
			break;
		}
		case 2:
		{
			level flag::set("light_rq_done");
			str_text = "LIGHT RUNE";
			str_tag_name = "light";
			var_198c807f = 10;
			n_y_pos = 240;
			break;
		}
		case 3:
		{
			level flag::set("shadow_rq_done");
			str_text = "SHADOW RUNE";
			str_tag_name = "shadow";
			var_198c807f = 10;
			n_y_pos = 260;
			break;
		}
	}
	if(!isdefined(level.var_b1b99f8d))
	{
		level.var_b1b99f8d = [];
	}
	else if(!isarray(level.var_b1b99f8d))
	{
		level.var_b1b99f8d = array(level.var_b1b99f8d);
	}
	level.var_b1b99f8d[level.var_b1b99f8d.size] = var_e4342d5d;
	function_1e620a08(str_tag_name);
	self thread function_e7fa3600(var_e4342d5d);
}

/*
	Name: function_1e620a08
	Namespace: zm_genesis_util
	Checksum: 0x8366C829
	Offset: 0x5448
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function function_1e620a08(str_tag_name)
{
	var_c0132a00 = getent("rift_entrance_rune_portal", "targetname");
	var_c0132a00 hidepart(("tag_" + str_tag_name) + "_off");
	var_c0132a00 showpart(("tag_" + str_tag_name) + "_on");
}

/*
	Name: function_e7fa3600
	Namespace: zm_genesis_util
	Checksum: 0x2500A41E
	Offset: 0x54E8
	Size: 0x14A
	Parameters: 1
	Flags: Linked
*/
function function_e7fa3600(var_e4342d5d)
{
	switch(var_e4342d5d)
	{
		case 0:
		{
			str_text = "gen_rune_electricity";
			break;
		}
		case 1:
		{
			str_text = "gen_rune_fire";
			break;
		}
		case 2:
		{
			str_text = "gen_rune_light";
			break;
		}
		case 3:
		{
			str_text = "gen_rune_shadow";
			break;
		}
	}
	level clientfield::set(str_text, 1);
	level notify(#"widget_ui_override");
	foreach(e_player in level.players)
	{
		e_player thread function_22510e73("zmInventory.widget_rune_parts", "zmInventory.player_rune_quest", 0);
	}
}

/*
	Name: function_22510e73
	Namespace: zm_genesis_util
	Checksum: 0x6FB06C4A
	Offset: 0x5640
	Size: 0xD4
	Parameters: 3
	Flags: Linked, Private
*/
function private function_22510e73(str_crafted_clientuimodel, str_widget_clientuimodel, b_is_crafted)
{
	self endon(#"disconnect");
	if(b_is_crafted)
	{
		if(isdefined(str_crafted_clientuimodel))
		{
			self thread clientfield::set_player_uimodel(str_crafted_clientuimodel, 1);
		}
		n_show_ui_duration = 3.5;
	}
	else
	{
		n_show_ui_duration = 3.5;
	}
	self thread clientfield::set_player_uimodel(str_widget_clientuimodel, 1);
	level util::waittill_any_ex(n_show_ui_duration, "widget_ui_override", self, "disconnect");
	self thread clientfield::set_player_uimodel(str_widget_clientuimodel, 0);
}

/*
	Name: function_ae4d938c
	Namespace: zm_genesis_util
	Checksum: 0xE58BEB45
	Offset: 0x5720
	Size: 0x27A
	Parameters: 4
	Flags: Linked
*/
function function_ae4d938c(v_target_pos, var_e57941b7, var_ca841609, str_endon_notify)
{
	self endon(#"bleed_out");
	self endon(#"death");
	self endon(#"disconnect");
	self endon(str_endon_notify);
	n_pulse_delay_range = 2.4;
	var_38a8139 = var_e57941b7 * var_e57941b7;
	var_2b515bba = var_e57941b7 - var_ca841609;
	n_scaled_pulse_delay = undefined;
	n_time_before_next_pulse = undefined;
	n_scale = undefined;
	var_887c2fcb = undefined;
	var_55ae5d19 = 1000;
	while(true)
	{
		n_z_diff = abs(v_target_pos[2] - self.origin[2]);
		n_dist_sq = distance2dsquared(self.origin, v_target_pos);
		if(n_dist_sq <= var_38a8139 && n_z_diff < 84)
		{
			n_dist = distance2d(self.origin, v_target_pos) - var_ca841609;
			n_dist = (n_dist < 0 ? 0 : n_dist);
			n_scale = n_dist / var_2b515bba;
			n_scaled_pulse_delay = n_scale * n_pulse_delay_range;
			n_time_before_next_pulse = 0.2 + n_scaled_pulse_delay;
			var_887c2fcb = (n_dist < (var_2b515bba * 0.25) ? 2 : 1);
		}
		else
		{
			n_time_before_next_pulse = undefined;
		}
		if(isdefined(n_time_before_next_pulse) && var_55ae5d19 > n_time_before_next_pulse)
		{
			var_55ae5d19 = 0;
			self thread function_8d431c98(var_887c2fcb);
		}
		wait(0.05);
		var_55ae5d19 = var_55ae5d19 + 0.05;
	}
}

/*
	Name: function_8d431c98
	Namespace: zm_genesis_util
	Checksum: 0xFB7BD4C8
	Offset: 0x59A8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_8d431c98(var_887c2fcb)
{
	self playsoundtoplayer("zmb_main_searchparty_ping", self);
	self set_rumble_to_player(var_887c2fcb);
	util::wait_network_frame();
	self set_rumble_to_player(0);
}

/*
	Name: function_32c765c5
	Namespace: zm_genesis_util
	Checksum: 0x2F172E6B
	Offset: 0x5A20
	Size: 0xBE
	Parameters: 1
	Flags: None
*/
function function_32c765c5(v_origin)
{
	n_closest_dist = 1E+07;
	a_players = getplayers();
	for(i = 0; i < a_players.size; i++)
	{
		n_dist = distance(a_players[i].origin, v_origin);
		if(n_dist < n_closest_dist)
		{
			n_closest_dist = n_dist;
		}
	}
	return n_closest_dist;
}

/*
	Name: function_a3c6e02f
	Namespace: zm_genesis_util
	Checksum: 0xBEDA4CA6
	Offset: 0x5AE8
	Size: 0x5C
	Parameters: 3
	Flags: None
*/
function function_a3c6e02f(e_to_delete, str_notify, n_delay)
{
	e_to_delete endon(#"death");
	self waittill(str_notify);
	wait(n_delay);
	if(isdefined(e_to_delete))
	{
		e_to_delete delete();
	}
}

/*
	Name: get_lookat_angles
	Namespace: zm_genesis_util
	Checksum: 0xEB8E6EAC
	Offset: 0x5B50
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function get_lookat_angles(v_start, v_end)
{
	v_dir = v_end - v_start;
	v_dir = vectornormalize(v_dir);
	v_angles = vectortoangles(v_dir);
	return v_angles;
}

/*
	Name: watch_for_open_sesame
	Namespace: zm_genesis_util
	Checksum: 0x1B60DA99
	Offset: 0x5BC8
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function watch_for_open_sesame()
{
	/#
		level waittill(#"open_sesame");
		var_2bbbcbec = getentarray("", "");
		foreach(var_a816c58c in var_2bbbcbec)
		{
			var_a816c58c.var_98e1d15 = 1;
			var_7e0a45c8 = var_a816c58c.script_int;
			level thread zm_power::turn_power_on_and_open_doors(var_7e0a45c8);
		}
		zm_zonemgr::enable_zone("");
	#/
}

/*
	Name: function_8faf1d24
	Namespace: zm_genesis_util
	Checksum: 0x70F4A824
	Offset: 0x5CE8
	Size: 0x108
	Parameters: 4
	Flags: None
*/
function function_8faf1d24(v_color, var_8882142e, n_scale, str_endon)
{
	/#
		if(!isdefined(v_color))
		{
			v_color = vectorscale((0, 0, 1), 255);
		}
		if(!isdefined(var_8882142e))
		{
			var_8882142e = "";
		}
		if(!isdefined(n_scale))
		{
			n_scale = 0.25;
		}
		if(!isdefined(str_endon))
		{
			str_endon = "";
		}
		if(getdvarint("") == 0)
		{
			return;
		}
		if(isdefined(str_endon))
		{
			self endon(str_endon);
		}
		origin = self.origin;
		while(true)
		{
			print3d(origin, var_8882142e, v_color, n_scale);
			wait(0.1);
		}
	#/
}

/*
	Name: debug_draw_line
	Namespace: zm_genesis_util
	Checksum: 0x42CC1E75
	Offset: 0x5DF8
	Size: 0xC0
	Parameters: 5
	Flags: None
*/
function debug_draw_line(v_start, v_end, str_endon, v_color, str_endon2)
{
	/#
		if(!isdefined(str_endon))
		{
			str_endon = "";
		}
		if(!isdefined(v_color))
		{
			v_color = (0, 1, 0);
		}
		if(!isdefined(str_endon2))
		{
			str_endon2 = "";
		}
		self endon(str_endon);
		self endon(str_endon2);
		while(true)
		{
			recordline(v_start, v_end, v_color, "", self);
			wait(0.05);
		}
	#/
}

/*
	Name: function_9ff5370d
	Namespace: zm_genesis_util
	Checksum: 0x1747F9B8
	Offset: 0x5EC0
	Size: 0xA8
	Parameters: 4
	Flags: None
*/
function function_9ff5370d(v_origin, n_radius, v_color, e_owner)
{
	/#
		if(!isdefined(n_radius))
		{
			n_radius = 64;
		}
		if(!isdefined(v_color))
		{
			v_color = (0, 1, 0);
		}
		if(!isdefined(e_owner))
		{
			e_owner = self;
		}
		self endon(#"hash_dc898c8");
		while(isdefined(self))
		{
			recordcircle(v_origin, n_radius, v_color, "", e_owner);
			wait(0.05);
		}
	#/
}

/*
	Name: function_68a764f6
	Namespace: zm_genesis_util
	Checksum: 0xC23C43C9
	Offset: 0x5F70
	Size: 0xA8
	Parameters: 3
	Flags: None
*/
function function_68a764f6(n_radius, v_color, e_owner)
{
	/#
		if(!isdefined(n_radius))
		{
			n_radius = 64;
		}
		if(!isdefined(v_color))
		{
			v_color = (0, 1, 0);
		}
		if(!isdefined(e_owner))
		{
			e_owner = self;
		}
		self endon(#"hash_5322c93b");
		while(isdefined(self))
		{
			recordsphere(self.origin, n_radius, v_color, "", e_owner);
			wait(0.05);
		}
	#/
}

/*
	Name: function_ff016910
	Namespace: zm_genesis_util
	Checksum: 0xFEE0C0F1
	Offset: 0x6020
	Size: 0x90
	Parameters: 3
	Flags: None
*/
function function_ff016910(str_text, v_color, e_owner)
{
	/#
		if(!isdefined(v_color))
		{
			v_color = (0, 1, 0);
		}
		if(!isdefined(e_owner))
		{
			e_owner = self;
		}
		self endon(#"hash_8fba9");
		while(isdefined(self))
		{
			record3dtext(str_text, self.origin, v_color, "", e_owner);
			wait(0.05);
		}
	#/
}

/*
	Name: function_ea73a995
	Namespace: zm_genesis_util
	Checksum: 0xC3E74598
	Offset: 0x60B8
	Size: 0x1B8
	Parameters: 2
	Flags: Linked
*/
function function_ea73a995(v_color, str_ender)
{
	/#
		if(!isdefined(v_color))
		{
			v_color = (0, 1, 0);
		}
		if(!isdefined(str_ender))
		{
			str_ender = "";
		}
		self endon(#"death");
		level endon(str_ender);
		for(;;)
		{
			forward = anglestoforward(self.angles);
			forwardfar = vectorscale(forward, 30);
			forwardclose = vectorscale(forward, 20);
			right = anglestoright(self.angles);
			left = vectorscale(right, -10);
			right = vectorscale(right, 10);
			line(self.origin, self.origin + forwardfar, v_color, 0.9);
			line(self.origin + forwardfar, (self.origin + forwardclose) + right, v_color, 0.9);
			line(self.origin + forwardfar, (self.origin + forwardclose) + left, v_color, 0.9);
			wait(0.05);
		}
	#/
}

/*
	Name: function_d8db939b
	Namespace: zm_genesis_util
	Checksum: 0x4528B9BE
	Offset: 0x6278
	Size: 0x144
	Parameters: 3
	Flags: Linked
*/
function function_d8db939b(str_flag, var_6e86b6bc, str_ender)
{
	/#
		if(!isdefined(var_6e86b6bc))
		{
			var_6e86b6bc = 0;
		}
		if(!isdefined(str_ender))
		{
			str_ender = "";
		}
		level endon(str_ender);
		if(level flag::get(str_flag))
		{
			print((("" + str_flag) + "") + "");
			if(var_6e86b6bc)
			{
				iprintlnbold(("" + str_flag) + "");
			}
			return;
		}
		level flag::wait_till(str_flag);
		print((("" + str_flag) + "") + "");
		if(var_6e86b6bc)
		{
			iprintlnbold(("" + str_flag) + "");
		}
	#/
}

/*
	Name: function_1f006e62
	Namespace: zm_genesis_util
	Checksum: 0xD670CBE4
	Offset: 0x63C8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_1f006e62()
{
	/#
		level thread debug_spawn_points();
		level thread function_1953a761();
		level thread function_c0411192();
		level thread function_90c620d8();
	#/
}

/*
	Name: function_c0411192
	Namespace: zm_genesis_util
	Checksum: 0xB066B9D1
	Offset: 0x6438
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_c0411192()
{
	/#
		level notify(#"hash_7fb84095");
		var_3e38f0ae = struct::get_array("");
		var_da104453 = struct::get_array("");
		var_3e38f0ae = arraycombine(var_3e38f0ae, var_da104453, 0, 0);
		var_da104453 = struct::get_array("");
		var_3e38f0ae = arraycombine(var_3e38f0ae, var_da104453, 0, 0);
		var_da104453 = struct::get_array("");
		var_3e38f0ae = arraycombine(var_3e38f0ae, var_da104453, 0, 0);
		array::thread_all(var_3e38f0ae, &function_b411d2a8);
	#/
}

/*
	Name: function_6c518807
	Namespace: zm_genesis_util
	Checksum: 0xA4C1C8A
	Offset: 0x6568
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_6c518807()
{
	/#
		level notify(#"hash_6fd18b70");
		var_3e38f0ae = struct::get_array("");
		var_da104453 = struct::get_array("");
		var_3e38f0ae = arraycombine(var_3e38f0ae, var_da104453, 0, 0);
		var_da104453 = struct::get_array("");
		var_3e38f0ae = arraycombine(var_3e38f0ae, var_da104453, 0, 0);
		var_da104453 = struct::get_array("");
		var_3e38f0ae = arraycombine(var_3e38f0ae, var_da104453, 0, 0);
		array::thread_all(var_3e38f0ae, &function_ba547024);
	#/
}

/*
	Name: function_ba547024
	Namespace: zm_genesis_util
	Checksum: 0x2FF79D55
	Offset: 0x6698
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function function_ba547024()
{
	/#
		level endon(#"hash_6fd18b70");
		v_color = (0, 1, 0);
		n_radius = 32;
		if(self.targetname == "")
		{
			v_color = (1, 1, 0);
			n_radius = 16;
		}
		self thread function_ea73a995(v_color, "");
		while(true)
		{
			circle(self.origin, n_radius, v_color);
			wait(0.05);
		}
	#/
}

/*
	Name: function_b411d2a8
	Namespace: zm_genesis_util
	Checksum: 0x454163C8
	Offset: 0x6758
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function function_b411d2a8()
{
	/#
		level endon(#"hash_7fb84095");
		if(!ispointonnavmesh(self.origin))
		{
			print(("" + self.origin) + "");
			while(!ispointonnavmesh(self.origin) && function_4086bd17(self.origin))
			{
				sphere(self.origin, 16, (1, 0, 0));
				print3d(self.origin + vectorscale((0, 0, 1), 16), self.origin + "", (1, 0, 0));
				wait(0.05);
			}
		}
	#/
}

/*
	Name: debug_spawn_points
	Namespace: zm_genesis_util
	Checksum: 0x25D1C64C
	Offset: 0x6860
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function debug_spawn_points()
{
	/#
		level notify(#"hash_79ca2895");
		a_s_points = struct::get_array("");
		var_97786609 = [];
		foreach(s_respawn in a_s_points)
		{
			var_c901c998 = struct::get_array(s_respawn.target);
			foreach(j, s_point in var_c901c998)
			{
				var_97786609[j] = s_point;
			}
		}
		a_s_spawn_points = arraycombine(a_s_points, var_97786609, 0, 0);
		var_c16df719 = struct::get_array("");
		array::thread_all(var_c16df719, &function_2e9f38b0);
		array::thread_all(a_s_spawn_points, &function_7129ea51);
		array::thread_all(level.zones, &function_3d73091f);
	#/
}

/*
	Name: function_f448730a
	Namespace: zm_genesis_util
	Checksum: 0xA81E760C
	Offset: 0x6A88
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_f448730a()
{
	/#
		level notify(#"hash_3e617e39");
		for(i = 1; i < 4; i++)
		{
			level scene::add_scene_func("" + i, &function_871166cb, "");
		}
		array::thread_all(level.zones, &function_a41558a6);
	#/
}

/*
	Name: function_81eb9b35
	Namespace: zm_genesis_util
	Checksum: 0x353F64EA
	Offset: 0x6B30
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_81eb9b35()
{
	/#
		level notify(#"hash_3e617e39");
		for(i = 1; i < 4; i++)
		{
			level scene::remove_scene_func("" + i, &function_871166cb, "");
		}
		array::thread_all(level.zones, &function_141ddc35);
	#/
}

/*
	Name: function_871166cb
	Namespace: zm_genesis_util
	Checksum: 0x7340E962
	Offset: 0x6BD8
	Size: 0x154
	Parameters: 1
	Flags: Linked
*/
function function_871166cb(a_ents)
{
	/#
		a_ents[0] thread function_ea73a995((1, 1, 0), "");
		recordent(a_ents[0]);
		if(!ispointonnavmesh(a_ents[0].origin))
		{
			for(i = 0; i < 20; i++)
			{
				sphere(a_ents[0].origin, 16, (1, 0, 0));
				print3d(a_ents[0].origin + vectorscale((0, 0, 1), 16), a_ents[0].origin + "", (1, 0, 0));
				wait(0.05);
			}
		}
		wait(3);
		if(isai(a_ents[0]))
		{
			return;
		}
		a_ents[0] delete();
	#/
}

/*
	Name: function_a41558a6
	Namespace: zm_genesis_util
	Checksum: 0x12092520
	Offset: 0x6D38
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function function_a41558a6()
{
	/#
		foreach(a_locs in self.a_loc_types)
		{
			array::thread_all(a_locs, &function_835d6248);
		}
	#/
}

/*
	Name: function_141ddc35
	Namespace: zm_genesis_util
	Checksum: 0x4698411C
	Offset: 0x6DE0
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function function_141ddc35()
{
	/#
		foreach(a_locs in self.a_loc_types)
		{
			array::thread_all(a_locs, &function_3e617e39);
		}
	#/
}

/*
	Name: function_3d73091f
	Namespace: zm_genesis_util
	Checksum: 0x3D2B192C
	Offset: 0x6E88
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function function_3d73091f()
{
	/#
		/#
			assert(self.a_loc_types[""].size > 0, ("" + self.volumes[0].targetname) + "");
		#/
		foreach(a_locs in self.a_loc_types)
		{
			array::thread_all(a_locs, &function_2e9f38b0);
		}
	#/
}

/*
	Name: function_2e9f38b0
	Namespace: zm_genesis_util
	Checksum: 0x5EB31350
	Offset: 0x6F80
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function function_2e9f38b0()
{
	/#
		level endon(#"hash_79ca2895");
		if(self.script_noteworthy == "")
		{
			return;
		}
		if(!ispointonnavmesh(self.origin) && self.script_noteworthy != "")
		{
			print(("" + self.origin) + "");
			while(!ispointonnavmesh(self.origin))
			{
				sphere(self.origin, 32, (1, 0, 0));
				print3d(self.origin + vectorscale((0, 0, 1), 16), (((self.origin + "") + self.script_noteworthy) + "") + self.zone_name, (1, 0, 0));
				wait(0.05);
			}
		}
	#/
}

/*
	Name: function_e0a812f0
	Namespace: zm_genesis_util
	Checksum: 0xBF34817E
	Offset: 0x70B0
	Size: 0xC4
	Parameters: 0
	Flags: None
*/
function function_e0a812f0()
{
	/#
		if(self.script_noteworthy == "")
		{
			if(!isdefined(self.var_640b69b2))
			{
				self.var_640b69b2 = util::spawn_model("", self.origin, self.angles);
			}
			self.var_640b69b2 scene::play("" + randomintrange(1, 3));
			if(isdefined(self.var_969d82a4))
			{
				self.var_969d82a4 delete();
			}
		}
	#/
}

/*
	Name: function_835d6248
	Namespace: zm_genesis_util
	Checksum: 0x540E72A0
	Offset: 0x7180
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function function_835d6248()
{
	/#
		level endon(#"hash_3e617e39");
		if(self.script_noteworthy == "")
		{
			while(true)
			{
				if(!isdefined(self.var_640b69b2))
				{
					self.var_640b69b2 = util::spawn_model("", self.origin, self.angles);
					self.var_640b69b2 thread function_ea73a995(undefined, "");
				}
				self.var_640b69b2 scene::play("" + randomintrange(1, 3));
				wait(0.05);
			}
		}
	#/
}

/*
	Name: function_3e617e39
	Namespace: zm_genesis_util
	Checksum: 0xB2495475
	Offset: 0x7260
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_3e617e39()
{
	/#
		if(self.script_noteworthy == "")
		{
			if(isdefined(self.var_640b69b2))
			{
				for(i = 1; i < 4; i++)
				{
					self.var_640b69b2 scene::stop("" + i);
				}
				self.var_640b69b2 delete();
			}
		}
	#/
}

/*
	Name: function_7129ea51
	Namespace: zm_genesis_util
	Checksum: 0x359FA1DA
	Offset: 0x72F8
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function function_7129ea51()
{
	/#
		level endon(#"hash_79ca2895");
		if(!ispointonnavmesh(self.origin))
		{
			print(("" + self.origin) + "");
			while(!ispointonnavmesh(self.origin))
			{
				sphere(self.origin, 16, (1, 0, 0));
				print3d(self.origin + vectorscale((0, 0, 1), 16), (self.origin + "") + self.script_noteworthy, (1, 0, 0));
				wait(0.05);
			}
		}
	#/
}

/*
	Name: function_1953a761
	Namespace: zm_genesis_util
	Checksum: 0xBACC07E6
	Offset: 0x73E8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_1953a761()
{
	/#
		level notify(#"hash_4a4c33ec");
		a_s_points = struct::get_array("");
		array::thread_all(a_s_points, &function_ed69d7f4);
	#/
}

/*
	Name: function_ed69d7f4
	Namespace: zm_genesis_util
	Checksum: 0x689770ED
	Offset: 0x7450
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function function_ed69d7f4()
{
	/#
		level endon(#"hash_4a4c33ec");
		if(!ispointonnavmesh(self.origin, 61.88) || function_4086bd17(self.origin))
		{
			print(("" + self.origin) + "");
			while(true)
			{
				sphere(self.origin, 61.88, (1, 1, 0));
				print3d(self.origin + vectorscale((0, 0, 1), 16), self.origin + "", (1, 1, 0));
				wait(0.05);
			}
		}
	#/
}

/*
	Name: function_4086bd17
	Namespace: zm_genesis_util
	Checksum: 0x6994D320
	Offset: 0x7560
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_4086bd17(v_point)
{
	/#
		a_trace = bullettrace(v_point, v_point + (vectorscale((0, 0, -1), 2000)), 0, undefined, 0);
		if(distance2dsquared(a_trace[""], v_point) > 36)
		{
			return true;
		}
		return false;
	#/
}

/*
	Name: function_90c620d8
	Namespace: zm_genesis_util
	Checksum: 0x71323A63
	Offset: 0x75E8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_90c620d8()
{
	/#
		level notify(#"hash_6aa36145");
		var_9f26317f = getentarray("", "");
		array::thread_all(var_9f26317f, &function_7b7eeb90);
	#/
}

/*
	Name: function_5e8cafb9
	Namespace: zm_genesis_util
	Checksum: 0xD5EEDDCD
	Offset: 0x7658
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function function_5e8cafb9()
{
	/#
		level notify(#"hash_27118146");
		foreach(t_door in self)
		{
			if(isdefined(t_door.script_flag))
			{
				level thread function_d8db939b(t_door.script_flag, 1, "");
			}
		}
	#/
}

/*
	Name: function_7b7eeb90
	Namespace: zm_genesis_util
	Checksum: 0x9FEE3DD9
	Offset: 0x7728
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function function_7b7eeb90()
{
	/#
		var_3ccf13b = self function_78e15936();
	#/
}

/*
	Name: function_78e15936
	Namespace: zm_genesis_util
	Checksum: 0x12C54CB3
	Offset: 0x7758
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_78e15936()
{
	/#
		var_3ccf13b = [];
		a_e_targets = getentarray(self.target, "");
		foreach(e_target in a_e_targets)
		{
			if(e_target.classname == "" || e_target.script_string === "")
			{
				if(!isdefined(var_3ccf13b))
				{
					var_3ccf13b = [];
				}
				else if(!isarray(var_3ccf13b))
				{
					var_3ccf13b = array(var_3ccf13b);
				}
				var_3ccf13b[var_3ccf13b.size] = e_target;
			}
		}
		return var_3ccf13b;
	#/
}

/*
	Name: function_bc81bb3b
	Namespace: zm_genesis_util
	Checksum: 0x384C1E32
	Offset: 0x78B0
	Size: 0x328
	Parameters: 0
	Flags: Linked
*/
function function_bc81bb3b()
{
	/#
		level endon(#"hash_27118146");
		if(!isdefined(self.script_flag))
		{
			if(isdefined(self.script_noteworthy))
			{
				while(true)
				{
					print3d(self.origin + vectorscale((0, 0, 1), 64), "" + self.script_noteworthy, (0, 0, 1), 1, 0.5);
					wait(0.05);
				}
			}
			return;
		}
		while(true)
		{
			n_offset = 0;
			var_3b72f06c = [];
			v_color = (1, 1, 0);
			if(level flag::exists(self.script_flag) && level flag::get(self.script_flag))
			{
				v_color = (0, 1, 0);
			}
			print3d(self.origin + vectorscale((0, 0, 1), 64), "" + self.script_flag, v_color, 1, 0.5);
			if(isdefined(level.zone_flags[self.script_flag]))
			{
				foreach(i, str_flag in level.zone_flags[self.script_flag])
				{
					n_offset = n_offset - 16;
					var_3b72f06c[i] = n_offset;
				}
				foreach(j, str_flag in level.zone_flags[self.script_flag])
				{
					var_1adee14a = (1, 1, 0);
					if(level flag::exists(str_flag) && level flag::get(str_flag))
					{
						var_1adee14a = (0, 1, 0);
					}
					print3d(self.origin + (0, 0, 64 + var_3b72f06c[j]), "" + str_flag, var_1adee14a, 1, 0.5);
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_b3db2cea
	Namespace: zm_genesis_util
	Checksum: 0x92BDEFCA
	Offset: 0x7BE0
	Size: 0xE8
	Parameters: 0
	Flags: None
*/
function function_b3db2cea()
{
	/#
		level endon(#"hash_4a4c33ec");
		if(!ispointonnavmesh(self.origin, 96))
		{
			print(("" + self.origin) + "");
			while(!ispointonnavmesh(self.origin))
			{
				sphere(self.origin, 96, (1, 1, 0), 0.5);
				print3d(self.origin + vectorscale((0, 0, 1), 16), "", (1, 1, 0));
				wait(0.05);
			}
		}
	#/
}

/*
	Name: devgui
	Namespace: zm_genesis_util
	Checksum: 0x76FB0AEA
	Offset: 0x7CD0
	Size: 0x22C
	Parameters: 0
	Flags: Linked
*/
function devgui()
{
	/#
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
		level thread setup_devgui_func("", "", 1, &zm_genesis_minor_ee::function_e1963311);
		zm_devgui::add_custom_devgui_callback(&function_dbc092aa);
	#/
}

/*
	Name: function_dbc092aa
	Namespace: zm_genesis_util
	Checksum: 0x54FA2C87
	Offset: 0x7F08
	Size: 0x53E
	Parameters: 1
	Flags: Linked
*/
function function_dbc092aa(cmd)
{
	/#
		cmd_strings = strtok(cmd, "");
		switch(cmd_strings[0])
		{
			case "":
			{
				var_9f26317f = getentarray("", "");
				var_9f26317f thread function_5e8cafb9();
				foreach(t_door in var_9f26317f)
				{
					var_3ccf13b = t_door function_78e15936();
					array::thread_all(var_3ccf13b, &function_bc81bb3b);
				}
				break;
			}
			case "":
			{
				level notify(#"hash_27118146");
				break;
			}
			case "":
			{
				function_712a86f4(1);
				break;
			}
			case "":
			{
				function_712a86f4(2);
				break;
			}
			case "":
			{
				function_712a86f4(3);
				break;
			}
			case "":
			{
				function_712a86f4(4);
				break;
			}
			case "":
			{
				function_f448730a();
				break;
			}
			case "":
			{
				function_81eb9b35();
				break;
			}
			case "":
			{
				function_6c518807();
				break;
			}
			case "":
			{
				level notify(#"hash_6fd18b70");
				break;
			}
			case "":
			{
				level.activeplayers[0] function_4667bb64();
				break;
			}
			case "":
			{
				level.activeplayers[0] function_4530c3b2();
				break;
			}
			case "":
			{
				level.activeplayers[0] function_c78305e0();
				break;
			}
			case "":
			{
				level.activeplayers[0] function_d5c8a6c2();
				break;
			}
			case "":
			{
				foreach(e_player in level.activeplayers)
				{
					e_player zm_genesis_apothican::function_4d6562d8();
				}
				break;
			}
			case "":
			{
				foreach(e_player in level.activeplayers)
				{
					e_player zm_genesis_apothican::function_42781615();
				}
				break;
			}
			case "":
			{
				level flag::set("");
				break;
			}
			case "":
			{
				if(isdefined(level.ball))
				{
					level.ball ball::reset_ball(0);
				}
				break;
			}
			case "":
			{
				level thread function_76c3e6c4();
				break;
			}
			case "":
			{
				foreach(e_player in level.activeplayers)
				{
					level thread _zm_weap_octobomb::octobomb_give(e_player);
				}
				break;
			}
			default:
			{
			}
		}
	#/
}

/*
	Name: function_4667bb64
	Namespace: zm_genesis_util
	Checksum: 0x6BA2EA73
	Offset: 0x8450
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_4667bb64()
{
	/#
		self endon(#"death");
		ball::function_b4352e6c(self);
	#/
}

/*
	Name: function_4530c3b2
	Namespace: zm_genesis_util
	Checksum: 0x6F029834
	Offset: 0x8480
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_4530c3b2()
{
	/#
		self endon(#"death");
		ball::function_7eb07bb0(self);
	#/
}

/*
	Name: function_c78305e0
	Namespace: zm_genesis_util
	Checksum: 0x806758AF
	Offset: 0x84B0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_c78305e0()
{
	/#
		self endon(#"death");
		ball::function_5faeea5e(self);
	#/
}

/*
	Name: function_d5c8a6c2
	Namespace: zm_genesis_util
	Checksum: 0x546737A9
	Offset: 0x84E0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_d5c8a6c2()
{
	/#
		self endon(#"death");
		ball::function_257ed160(self, 1);
	#/
}

/*
	Name: function_712a86f4
	Namespace: zm_genesis_util
	Checksum: 0x10308350
	Offset: 0x8518
	Size: 0x10A
	Parameters: 1
	Flags: Linked
*/
function function_712a86f4(var_7e0a45c8)
{
	/#
		var_2bbbcbec = getentarray("", "");
		foreach(var_a816c58c in var_2bbbcbec)
		{
			if(var_a816c58c.script_int == var_7e0a45c8)
			{
				var_a816c58c.var_98e1d15 = 1;
				var_7e0a45c8 = var_a816c58c.script_int;
				level thread zm_power::turn_power_on_and_open_doors(var_7e0a45c8);
			}
		}
	#/
}

/*
	Name: function_30672281
	Namespace: zm_genesis_util
	Checksum: 0x5B82CFD5
	Offset: 0x8630
	Size: 0x1E6
	Parameters: 0
	Flags: Linked
*/
function function_30672281()
{
	/#
		var_2f06ca53 = 0;
		var_f1ef8e43 = [];
		while(true)
		{
			for(i = 0; i < level.activeplayers.size; i++)
			{
				var_83c144e5 = (var_2f06ca53 * 10) + 11;
				if(isdefined(level.activeplayers[i]))
				{
					if(isgodmode(level.activeplayers[i]) && !isdefined(var_f1ef8e43[level.activeplayers[i].name]))
					{
						var_f1ef8e43[level.activeplayers[i].name] = function_a1bfa962(level.activeplayers[i], level.activeplayers[i].name + "", 2, var_83c144e5);
						var_2f06ca53++;
					}
					if(!isgodmode(level.activeplayers[i]) && isdefined(var_f1ef8e43[level.activeplayers[i].name]))
					{
						var_f1ef8e43[level.activeplayers[i].name] destroy();
						var_2f06ca53--;
					}
				}
			}
			wait(1);
		}
	#/
}

/*
	Name: function_76c3e6c4
	Namespace: zm_genesis_util
	Checksum: 0xA5DADD54
	Offset: 0x8820
	Size: 0xEE
	Parameters: 0
	Flags: Linked
*/
function function_76c3e6c4()
{
	/#
		foreach(e_player in level.activeplayers)
		{
			e_player.b_wall_run_enabled = 1;
			e_player allowwallrun(1);
			e_player allowdoublejump(1);
			e_player setperk("");
			e_player.var_7dd18a0 = 1;
		}
	#/
}

