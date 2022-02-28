// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_stalingrad;
#using scripts\zm\zm_stalingrad_util;

#namespace zm_stalingrad_powered_bridge;

/*
	Name: main
	Namespace: zm_stalingrad_powered_bridge
	Checksum: 0xF808AA81
	Offset: 0x540
	Size: 0x222
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level flag::init("bridge_jitter_stop");
	level flag::init("bridge_in_use");
	level thread scene::init("p7_fxanim_zm_stal_elevator_bundle");
	s_right = struct::get("bridge_trigger_right");
	s_left = struct::get("bridge_trigger_left");
	e_gate = getent("powered_bridge_gate", "targetname");
	e_gate disconnectpaths();
	var_efdf0fee = getentarray("bridge_light_on", "targetname");
	array::run_all(var_efdf0fee, &hide);
	s_right function_e457f1d();
	s_left function_e457f1d();
	var_cefeeda4 = getnodearray("powered_bridge_door", "targetname");
	foreach(var_8bd15b35 in var_cefeeda4)
	{
		unlinktraversal(var_8bd15b35);
	}
}

/*
	Name: function_e457f1d
	Namespace: zm_stalingrad_powered_bridge
	Checksum: 0xCCF99EDC
	Offset: 0x770
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_e457f1d()
{
	self.script_unitrigger_type = "unitrigger_radius_use";
	self.cursor_hint = "HINT_NOICON";
	self.require_look_at = 0;
	self.radius = 64;
	self.height = 64;
	self.prompt_and_visibility_func = &function_87d1b410;
	zm_unitrigger::register_static_unitrigger(self, &function_5156e4d8);
}

/*
	Name: function_87d1b410
	Namespace: zm_stalingrad_powered_bridge
	Checksum: 0x282DB357
	Offset: 0x7F8
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function function_87d1b410(e_player)
{
	if(!level flag::get("power_on"))
	{
		self sethintstring(&"ZOMBIE_NEED_POWER");
		return false;
	}
	if(level flag::get("bridge_in_use"))
	{
		self sethintstring(&"ZM_STALINGRAD_BRIDGE_UNAVAILABLE");
		return false;
	}
	self sethintstring(&"ZM_STALINGRAD_BRIDGE_USE", 500);
	return true;
}

/*
	Name: function_5156e4d8
	Namespace: zm_stalingrad_powered_bridge
	Checksum: 0xF727E037
	Offset: 0x8C8
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_5156e4d8()
{
	while(true)
	{
		self waittill(#"trigger", e_player);
		if(!level flag::get("bridge_in_use"))
		{
			if(e_player zm_score::can_player_purchase(500))
			{
				e_player clientfield::increment_to_player("interact_rumble");
				e_player zm_score::minus_to_player_score(500);
				level thread activate_bridge(e_player);
			}
			else
			{
				zm_utility::play_sound_at_pos("no_purchase", self.origin);
				if(isdefined(level.custom_generic_deny_vo_func))
				{
					e_player thread [[level.custom_generic_deny_vo_func]](1);
				}
				else
				{
					e_player zm_audio::create_and_play_dialog("general", "outofmoney");
				}
				continue;
			}
		}
	}
}

/*
	Name: activate_bridge
	Namespace: zm_stalingrad_powered_bridge
	Checksum: 0xC3BD44BE
	Offset: 0xA08
	Size: 0x48C
	Parameters: 1
	Flags: Linked
*/
function activate_bridge(e_player)
{
	level thread zm_stalingrad_util::function_903f6b36(1, "bridge_trap");
	level flag::set("bridge_in_use");
	level flag::set("activate_bridge");
	level.zones["powered_bridge_zone"].is_enabled = 1;
	e_gate = getent("powered_bridge_gate", "targetname");
	s_rumble = struct::get("bridge_rumble");
	var_cefeeda4 = getnodearray("powered_bridge_door", "targetname");
	level thread scene::play("p7_fxanim_zm_stal_elevator_bundle");
	function_ef72d561();
	e_gate movez(100 * -1, 0.05);
	e_gate waittill(#"movedone");
	e_gate connectpaths();
	foreach(var_8bd15b35 in var_cefeeda4)
	{
		linktraversal(var_8bd15b35);
	}
	level thread zm_zonemgr::zone_flag_wait("activate_bridge");
	wait(3);
	playrumbleonposition("zm_stalingrad_bridge_closing", s_rumble.origin);
	level thread function_40ac3c12(e_player);
	wait(3);
	level flag::set("bridge_jitter_stop");
	level flag::wait_till_clear("bridge_jitter_stop");
	e_gate movez(100, 0.05);
	e_gate waittill(#"movedone");
	e_gate disconnectpaths();
	foreach(var_8bd15b35 in var_cefeeda4)
	{
		unlinktraversal(var_8bd15b35);
	}
	level.zones["powered_bridge_zone"].is_enabled = 0;
	level flag::set_val("activate_bridge", 0);
	level.zones["powered_bridge_A_zone"].adjacent_zones["powered_bridge_B_zone"].is_connected = 0;
	level.zones["powered_bridge_B_zone"].adjacent_zones["powered_bridge_A_zone"].is_connected = 0;
	function_462efa3d();
	wait(5);
	level zm_stalingrad_util::function_903f6b36(0, "bridge_trap");
	level flag::clear("bridge_in_use");
}

/*
	Name: function_462efa3d
	Namespace: zm_stalingrad_powered_bridge
	Checksum: 0x6B1E7CCE
	Offset: 0xEA0
	Size: 0xFA
	Parameters: 0
	Flags: Linked
*/
function function_462efa3d()
{
	var_435fc5db = getent("bridge_area", "targetname");
	a_zombies = getaiteamarray(level.zombie_team);
	foreach(ai in a_zombies)
	{
		if(ai istouching(var_435fc5db))
		{
			ai kill();
		}
	}
}

/*
	Name: function_ef72d561
	Namespace: zm_stalingrad_powered_bridge
	Checksum: 0x210EE80
	Offset: 0xFA8
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function function_ef72d561()
{
	e_bridge = getent("bridge_left", "targetname");
	var_c83a1961 = getent("bridge_right", "targetname");
	e_bridge rotatepitch(90, 0.75);
	var_c83a1961 rotatepitch(-90, 0.75);
	e_bridge waittill(#"rotatedone");
}

/*
	Name: function_40ac3c12
	Namespace: zm_stalingrad_powered_bridge
	Checksum: 0xEB5226D2
	Offset: 0x1070
	Size: 0x3AC
	Parameters: 1
	Flags: Linked
*/
function function_40ac3c12(e_player)
{
	var_efdf0fee = getentarray("bridge_light_on", "targetname");
	array::run_all(var_efdf0fee, &show);
	var_da999e54 = getentarray("bridge_light_off", "targetname");
	array::run_all(var_da999e54, &hide);
	level thread exploder::exploder("bridge_lights_exploder");
	var_fa30b172 = getent("bridge_left", "targetname");
	var_c83a1961 = getent("bridge_right", "targetname");
	while(!level flag::get("bridge_jitter_stop"))
	{
		var_fa30b172 movez(2 * -1, 0.05);
		var_c83a1961 movez(2 * -1, 0.05);
		var_fa30b172 waittill(#"movedone");
		var_fa30b172 movez(2, 0.05);
		var_c83a1961 movez(2, 0.05);
		var_fa30b172 waittill(#"movedone");
	}
	var_edc0081d = getent("bridge_left_volume", "targetname");
	var_55155900 = getent("bridge_right_volume", "targetname");
	function_e0c7ad1e(var_edc0081d, var_55155900);
	function_54227761(var_edc0081d, var_55155900, e_player);
	var_fa30b172 rotatepitch(-90, 0.25);
	var_c83a1961 rotatepitch(90, 0.25);
	wait(0.5);
	level flag::clear("bridge_jitter_stop");
	var_efdf0fee = getentarray("bridge_light_on", "targetname");
	array::run_all(var_efdf0fee, &hide);
	var_da999e54 = getentarray("bridge_light_off", "targetname");
	array::run_all(var_da999e54, &show);
	exploder::kill_exploder("bridge_lights_exploder");
}

/*
	Name: function_e0c7ad1e
	Namespace: zm_stalingrad_powered_bridge
	Checksum: 0x180789C9
	Offset: 0x1428
	Size: 0x102
	Parameters: 2
	Flags: Linked
*/
function function_e0c7ad1e(var_fa30b172, var_c83a1961)
{
	foreach(player in level.players)
	{
		if(player istouching(var_fa30b172))
		{
			player thread function_fce6cca8("left");
			continue;
		}
		if(player istouching(var_c83a1961))
		{
			player thread function_fce6cca8("right");
		}
	}
}

/*
	Name: function_fce6cca8
	Namespace: zm_stalingrad_powered_bridge
	Checksum: 0xC2731B22
	Offset: 0x1538
	Size: 0x1FC
	Parameters: 1
	Flags: Linked
*/
function function_fce6cca8(str_side)
{
	self endon(#"death");
	var_9439ece6 = struct::get("barracks_bridge_fling_target", "targetname");
	var_7bb55377 = struct::get("armory_bridge_fling_target", "targetname");
	v_left = var_9439ece6.origin;
	v_right = var_7bb55377.origin;
	var_848f1155 = spawn("script_model", self.origin);
	var_848f1155 setmodel("tag_origin");
	self playerlinkto(var_848f1155, "tag_origin");
	self notsolid();
	var_848f1155 notsolid();
	self.var_fa6d2a24 = 1;
	if(str_side == "left")
	{
		n_time = var_848f1155 zm_utility::fake_physicslaunch(v_left, 500);
	}
	else
	{
		n_time = var_848f1155 zm_utility::fake_physicslaunch(v_right, 400);
	}
	wait(n_time);
	self.var_fa6d2a24 = 0;
	self solid();
	var_848f1155 delete();
}

/*
	Name: function_54227761
	Namespace: zm_stalingrad_powered_bridge
	Checksum: 0xED56FAC
	Offset: 0x1740
	Size: 0x20C
	Parameters: 3
	Flags: Linked
*/
function function_54227761(var_fa30b172, var_c83a1961, e_player)
{
	a_zombies = getaiteamarray(level.zombie_team);
	n_count = 0;
	n_kill_count = 0;
	foreach(ai_zombie in a_zombies)
	{
		if(ai_zombie istouching(var_fa30b172))
		{
			ai_zombie thread function_d2f913f5("left");
			if(isdefined(e_player))
			{
				e_player zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_KILL_TRAP");
			}
			n_count++;
			n_kill_count++;
			if(n_count >= 3)
			{
				wait(0.05);
				n_count = 0;
			}
			continue;
		}
		if(ai_zombie istouching(var_c83a1961))
		{
			ai_zombie thread function_d2f913f5("right");
			e_player zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_KILL_TRAP");
			n_count++;
			n_kill_count++;
			if(n_count >= 3)
			{
				wait(0.05);
				n_count = 0;
			}
		}
	}
	if(isdefined(e_player))
	{
		e_player notify(#"hash_f7608efe", n_kill_count);
	}
}

/*
	Name: function_d2f913f5
	Namespace: zm_stalingrad_powered_bridge
	Checksum: 0x5E77BD5C
	Offset: 0x1958
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function function_d2f913f5(str_side)
{
	self endon(#"death");
	if(str_side == "left")
	{
		self startragdoll();
		self launchragdoll((5 * -1, 0, 3));
	}
	else
	{
		self startragdoll();
		self launchragdoll((5, 0, 3));
	}
	if(isalive(self))
	{
		self kill();
	}
}

