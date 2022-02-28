// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_margwa;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_ai_wasp;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace zm_zod_util;

/*
	Name: __init__sytem__
	Namespace: zm_zod_util
	Checksum: 0x5FB11104
	Offset: 0x348
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_util", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_util
	Checksum: 0xE7160671
	Offset: 0x390
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.tag_origin_pool = [];
}

/*
	Name: __main__
	Namespace: zm_zod_util
	Checksum: 0xEE9D1FCD
	Offset: 0x3A8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	/#
		assert(isdefined(level.zombie_spawners));
	#/
	if(isdefined(level.zombie_spawn_callbacks))
	{
		foreach(fn in level.zombie_spawn_callbacks)
		{
			add_zod_zombie_spawn_func(fn);
		}
	}
	level.zombie_spawn_callbacks = undefined;
	add_zod_zombie_spawn_func(&watch_zombie_death);
	callback::on_connect(&on_player_connect);
	level.teleport_positions = struct::get_array("teleport_position");
}

/*
	Name: tag_origin_allocate
	Namespace: zm_zod_util
	Checksum: 0x41CBCB1
	Offset: 0x4D8
	Size: 0xE0
	Parameters: 2
	Flags: Linked
*/
function tag_origin_allocate(v_pos, v_angles)
{
	if(level.tag_origin_pool.size == 0)
	{
		e_model = util::spawn_model("tag_origin", v_pos, v_angles);
		return e_model;
	}
	n_index = level.tag_origin_pool.size - 1;
	e_model = level.tag_origin_pool[n_index];
	arrayremoveindex(level.tag_origin_pool, n_index);
	e_model.angles = v_angles;
	e_model.origin = v_pos;
	e_model notify(#"reallocated_from_pool");
	return e_model;
}

/*
	Name: tag_origin_free
	Namespace: zm_zod_util
	Checksum: 0x495976E7
	Offset: 0x5C8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function tag_origin_free()
{
	if(!isdefined(level.tag_origin_pool))
	{
		level.tag_origin_pool = [];
	}
	else if(!isarray(level.tag_origin_pool))
	{
		level.tag_origin_pool = array(level.tag_origin_pool);
	}
	level.tag_origin_pool[level.tag_origin_pool.size] = self;
	self thread tag_origin_expire();
}

/*
	Name: tag_origin_expire
	Namespace: zm_zod_util
	Checksum: 0x695CD8A1
	Offset: 0x658
	Size: 0x4C
	Parameters: 0
	Flags: Linked, Private
*/
function private tag_origin_expire()
{
	self endon(#"reallocated_from_pool");
	wait(20);
	arrayremovevalue(level.tag_origin_pool, self);
	self delete();
}

/*
	Name: watch_zombie_death
	Namespace: zm_zod_util
	Checksum: 0xDAFBD50C
	Offset: 0x6B0
	Size: 0xD2
	Parameters: 0
	Flags: Linked, Private
*/
function private watch_zombie_death()
{
	self waittill(#"death", e_attacker, str_means_of_death, weapon);
	if(isdefined(self))
	{
		if(isdefined(level.zombie_death_callbacks))
		{
			foreach(fn_callback in level.zombie_death_callbacks)
			{
				self thread [[fn_callback]](e_attacker, str_means_of_death, weapon);
			}
		}
	}
}

/*
	Name: vec_to_string
	Namespace: zm_zod_util
	Checksum: 0xB333C970
	Offset: 0x790
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function vec_to_string(v)
{
	return (((((("<") + v[0]) + ", ") + v[1]) + ", ") + v[2]) + (">");
}

/*
	Name: zod_unitrigger_assess_visibility
	Namespace: zm_zod_util
	Checksum: 0x522A28FA
	Offset: 0x7E8
	Size: 0x170
	Parameters: 1
	Flags: Linked
*/
function zod_unitrigger_assess_visibility(player)
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
	if(isdefined(param1))
	{
		self sethintstring(str_msg, param1);
	}
	else
	{
		self sethintstring(str_msg);
	}
	return b_visible;
}

/*
	Name: unitrigger_refresh_message
	Namespace: zm_zod_util
	Checksum: 0x15BD2504
	Offset: 0x960
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
	Namespace: zm_zod_util
	Checksum: 0xE5D9A087
	Offset: 0x988
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
	Namespace: zm_zod_util
	Checksum: 0xFC80AA6F
	Offset: 0x9A0
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
	Name: teleport_player
	Namespace: zm_zod_util
	Checksum: 0xE7346C2B
	Offset: 0xA48
	Size: 0x3CC
	Parameters: 1
	Flags: None
*/
function teleport_player(struct_targetname)
{
	/#
		assert(isdefined(struct_targetname));
	#/
	a_dest = struct::get_array(struct_targetname, "targetname");
	if(a_dest.size == 0)
	{
		/#
			/#
				assertmsg(("" + struct_targetname) + "");
			#/
		#/
		return;
	}
	v_dest_origin = a_dest[0].origin;
	v_dest_angles = a_dest[0].angles;
	b_valid_found = 0;
	e_teleport = tag_origin_allocate(self.origin, self.angles);
	self playerlinktoabsolute(e_teleport, "tag_origin");
	e_teleport.origin = level.teleport_positions[self.characterindex].origin;
	e_teleport.angles = level.teleport_positions[self.characterindex].angles;
	self freezecontrols(1);
	self disableweapons();
	self disableoffhandweapons();
	wait(2);
	foreach(s_dest in a_dest)
	{
		foreach(e_player in level.players)
		{
			if(distance2dsquared(e_player.origin, s_dest.origin) > 10000)
			{
				b_valid_found = 1;
				v_dest_origin = s_dest.origin;
				v_dest_angles = s_dest.angles;
				break;
			}
		}
		if(b_valid_found)
		{
			break;
		}
	}
	e_teleport.origin = v_dest_origin;
	e_teleport.angles = v_dest_angles;
	wait(0.5);
	self unlink();
	e_teleport tag_origin_free();
	self freezecontrols(0);
	self enableweapons();
	self enableoffhandweapons();
}

/*
	Name: set_unitrigger_hint_string
	Namespace: zm_zod_util
	Checksum: 0x7579C6D6
	Offset: 0xE20
	Size: 0x64
	Parameters: 2
	Flags: Linked
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
	Namespace: zm_zod_util
	Checksum: 0xC2EF750E
	Offset: 0xE90
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
	trigger_stub.prompt_and_visibility_func = &zod_unitrigger_assess_visibility;
	zm_unitrigger::register_unitrigger(trigger_stub, &unitrigger_think);
	return trigger_stub;
}

/*
	Name: spawn_trigger_radius
	Namespace: zm_zod_util
	Checksum: 0xE7B132EE
	Offset: 0x1090
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
	Namespace: zm_zod_util
	Checksum: 0xB00194D2
	Offset: 0x10F8
	Size: 0x62
	Parameters: 5
	Flags: Linked
*/
function spawn_trigger_box(origin, angles, dims, use_trigger = 0, func_per_player_msg)
{
	return spawn_unitrigger(origin, angles, dims, use_trigger, func_per_player_msg);
}

/*
	Name: add_zod_zombie_spawn_func
	Namespace: zm_zod_util
	Checksum: 0xB101CAC6
	Offset: 0x1168
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function add_zod_zombie_spawn_func(fn_zombie_spawned)
{
	if(!isdefined(level.zombie_spawners))
	{
		if(!isdefined(level.zombie_spawn_callbacks))
		{
			level.zombie_spawn_callbacks = [];
		}
		if(!isdefined(level.zombie_spawn_callbacks))
		{
			level.zombie_spawn_callbacks = [];
		}
		else if(!isarray(level.zombie_spawn_callbacks))
		{
			level.zombie_spawn_callbacks = array(level.zombie_spawn_callbacks);
		}
		level.zombie_spawn_callbacks[level.zombie_spawn_callbacks.size] = fn_zombie_spawned;
	}
	else
	{
		array::thread_all(level.zombie_spawners, &spawner::add_spawn_function, fn_zombie_spawned);
		a_ritual_spawners = getentarray("ritual_zombie_spawner", "targetname");
		array::thread_all(a_ritual_spawners, &spawner::add_spawn_function, fn_zombie_spawned);
	}
}

/*
	Name: on_player_connect
	Namespace: zm_zod_util
	Checksum: 0x7BA8ABBA
	Offset: 0x1290
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"bled_out");
		if(isdefined(level.bled_out_callbacks))
		{
			foreach(fn in level.bled_out_callbacks)
			{
				self thread [[fn]]();
			}
		}
	}
}

/*
	Name: on_zombie_killed
	Namespace: zm_zod_util
	Checksum: 0x41550F87
	Offset: 0x1350
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function on_zombie_killed(fn_zombie_killed)
{
	if(!isdefined(level.zombie_death_callbacks))
	{
		level.zombie_death_callbacks = [];
	}
	if(!isdefined(level.zombie_death_callbacks))
	{
		level.zombie_death_callbacks = [];
	}
	else if(!isarray(level.zombie_death_callbacks))
	{
		level.zombie_death_callbacks = array(level.zombie_death_callbacks);
	}
	level.zombie_death_callbacks[level.zombie_death_callbacks.size] = fn_zombie_killed;
}

/*
	Name: on_player_bled_out
	Namespace: zm_zod_util
	Checksum: 0x294A7FE6
	Offset: 0x13F0
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function on_player_bled_out(fn_callback)
{
	if(!isdefined(level.bled_out_callbacks))
	{
		level.bled_out_callbacks = [];
	}
	if(!isdefined(level.bled_out_callbacks))
	{
		level.bled_out_callbacks = [];
	}
	else if(!isarray(level.bled_out_callbacks))
	{
		level.bled_out_callbacks = array(level.bled_out_callbacks);
	}
	level.bled_out_callbacks[level.bled_out_callbacks.size] = fn_callback;
}

/*
	Name: set_rumble_to_player
	Namespace: zm_zod_util
	Checksum: 0xCB377CBC
	Offset: 0x1490
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
	Namespace: zm_zod_util
	Checksum: 0xF3A5E99B
	Offset: 0x1520
	Size: 0x102
	Parameters: 4
	Flags: Linked
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
	Name: function_5cc835d6
	Namespace: zm_zod_util
	Checksum: 0x12987D36
	Offset: 0x1630
	Size: 0x11C
	Parameters: 3
	Flags: Linked
*/
function function_5cc835d6(v_origin, v_target, n_duration)
{
	/#
		assert(isdefined(v_origin), "");
	#/
	/#
		assert(isdefined(v_target), "");
	#/
	e_fx = tag_origin_allocate(v_origin, (0, 0, 0));
	e_fx clientfield::set("zod_egg_soul", 1);
	e_fx moveto(v_target, n_duration);
	e_fx waittill(#"movedone");
	e_fx clientfield::set("zod_egg_soul", 0);
	e_fx tag_origin_free();
}

/*
	Name: function_15166300
	Namespace: zm_zod_util
	Checksum: 0x67FF3D05
	Offset: 0x1758
	Size: 0x28C
	Parameters: 1
	Flags: Linked
*/
function function_15166300(var_c3a9e22d)
{
	var_49fa7253 = 0;
	var_565450eb = 0;
	n_wasps_alive = 0;
	n_raps_alive = 0;
	switch(var_c3a9e22d)
	{
		case 1:
		{
			var_565450eb = zombie_utility::get_current_zombie_count();
			var_32218d0b = min(level.activeplayers.size * 5, 10);
			var_49fa7253 = var_32218d0b - var_565450eb;
			break;
		}
		case 2:
		{
			n_wasps_alive = zm_ai_wasp::get_current_wasp_count();
			var_32218d0b = min(level.activeplayers.size * 4, 8);
			var_49fa7253 = var_32218d0b - n_wasps_alive;
			break;
		}
		case 3:
		{
			n_raps_alive = zm_ai_raps::get_current_raps_count();
			var_32218d0b = min(level.activeplayers.size * 4, 13);
			var_49fa7253 = var_32218d0b - n_raps_alive;
			break;
		}
		case 4:
		{
			var_49fa7253 = 3 - level.var_6e63e659;
			var_73d2bce8 = level.zm_loc_types["margwa_location"].size < 1;
			if(var_73d2bce8)
			{
				var_49fa7253 = 0;
			}
			break;
		}
	}
	var_4422ef10 = (var_565450eb + (n_wasps_alive * 2)) + (n_raps_alive * 2) + level.var_6e63e659;
	var_e1bef548 = level.zombie_ai_limit - var_4422ef10;
	var_49fa7253 = min(var_49fa7253, var_e1bef548);
	if(var_49fa7253 > 0 && (var_c3a9e22d === 2 || var_c3a9e22d === 3))
	{
		var_49fa7253 = var_49fa7253 / 2;
		var_49fa7253 = floor(var_49fa7253);
	}
	return var_49fa7253;
}

/*
	Name: function_55f114f9
	Namespace: zm_zod_util
	Checksum: 0x30304A59
	Offset: 0x19F0
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function function_55f114f9(var_c94b52fa, n_duration)
{
	self clientfield::set_player_uimodel(var_c94b52fa, 1);
	wait(n_duration);
	self clientfield::set_player_uimodel(var_c94b52fa, 0);
}

/*
	Name: show_infotext_for_duration
	Namespace: zm_zod_util
	Checksum: 0xA26A96A4
	Offset: 0x1A50
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function show_infotext_for_duration(str_infotext, n_duration)
{
	self clientfield::set_to_player(str_infotext, 1);
	wait(n_duration);
	self clientfield::set_to_player(str_infotext, 0);
}

/*
	Name: setup_devgui_func
	Namespace: zm_zod_util
	Checksum: 0x9EEE0471
	Offset: 0x1AB0
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

