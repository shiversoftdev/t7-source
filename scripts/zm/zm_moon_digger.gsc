// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equip_hacker;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_moon;
#using scripts\zm\zm_moon_amb;
#using scripts\zm\zm_moon_gravity;

#namespace zm_moon_digger;

/*
	Name: digger_init_flags
	Namespace: zm_moon_digger
	Checksum: 0x60296F2D
	Offset: 0xB00
	Size: 0x320
	Parameters: 0
	Flags: Linked
*/
function digger_init_flags()
{
	level.diggers_global_time = 240;
	level flag::init("teleporter_digger_hacked");
	level flag::init("teleporter_digger_hacked_before_breached");
	level flag::init("start_teleporter_digger");
	level flag::init("start_hangar_digger");
	level flag::init("hangar_digger_hacked");
	level flag::init("hangar_digger_hacked_before_breached");
	level flag::init("start_biodome_digger");
	level flag::init("biodome_digger_hacked");
	level flag::init("biodome_digger_hacked_before_breached");
	level flag::init("hide_diggers");
	level flag::init("init_diggers");
	level flag::set("init_diggers");
	level flag::init("teleporter_breached");
	level flag::init("hangar_breached");
	level flag::init("biodome_breached");
	level flag::init("teleporter_blocked");
	level flag::init("hangar_blocked");
	level flag::init("both_tunnels_breached");
	level flag::init("both_tunnels_blocked");
	level flag::init("digger_moving");
	level.diggers = array("teleporter", "hangar", "biodome");
	if(!isdefined(level.digger_speed_multiplier))
	{
		level.digger_speed_multiplier = 1;
	}
	if(isdefined(level.quantum_bomb_register_result_func))
	{
		[[level.quantum_bomb_register_result_func]]("remove_digger", &quantum_bomb_remove_digger_result, 75, &quantum_bomb_remove_digger_validation);
	}
}

/*
	Name: digger_init
	Namespace: zm_moon_digger
	Checksum: 0x2DBCFDAF
	Offset: 0xE28
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function digger_init()
{
	level thread setup_diggers();
}

/*
	Name: setup_diggers
	Namespace: zm_moon_digger
	Checksum: 0xE2C7C29C
	Offset: 0xE50
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function setup_diggers()
{
	level thread digger_think_panel("digger_hangar_blocker", "hangar_digger_switch", "start_hangar_digger", "hangar_digger_hacked", "hangar_digger_hacked_before_breached", "hangar_breached", &digger_think_blocker, "hangar");
	level thread digger_think_panel("digger_teleporter_blocker", "teleporter_digger_switch", "start_teleporter_digger", "teleporter_digger_hacked", "teleporter_digger_hacked_before_breached", "teleporter_breached", &digger_think_blocker, "teleporter");
	level thread digger_think_panel(undefined, "biodome_digger_switch", "start_biodome_digger", "biodome_digger_hacked", "biodome_digger_hacked_before_breached", "biodome_breached", &digger_think_biodome, "biodome");
	level thread diggers_think_no_mans_land();
	level thread digger_round_logic();
	diggers = getentarray("digger_body", "targetname");
	level function_c497263d();
	array::thread_all(diggers, &digger_think_move);
	level thread waitfor_smash();
	wait(0.5);
	level flag::clear("init_diggers");
}

/*
	Name: function_c497263d
	Namespace: zm_moon_digger
	Checksum: 0xE351979F
	Offset: 0x1030
	Size: 0x44C
	Parameters: 0
	Flags: Linked
*/
function function_c497263d()
{
	for(i = 0; i < 3; i++)
	{
		switch(i)
		{
			case 0:
			{
				var_794a1037 = "biodome_digger_stopped";
				var_3d838929 = "lgt_exploder_digger_biodome";
				var_ebcc585f = "lgt_exploder_dig_biodome_alt";
				var_575a869f = "lgt_exploder_dig_biodome_arrived";
				var_f78a8481 = "biodome_digger_body_lights";
				var_7dbee661 = "biodome_digger_arm_lights";
				break;
			}
			case 1:
			{
				var_794a1037 = "teleporter_digger_stopped";
				var_3d838929 = "lgt_exploder_digger_teleporter";
				var_ebcc585f = "lgt_exploder_dig_teleporter_alt";
				var_575a869f = "lgt_exploder_dig_teleporter_arrived";
				var_f78a8481 = "teleporter_digger_body_lights";
				var_7dbee661 = "teleporter_digger_arm_lights";
				break;
			}
			case 2:
			{
				var_794a1037 = "stop_hangar_digger";
				var_3d838929 = "lgt_exploder_digger_hangar";
				var_ebcc585f = "lgt_exploder_dig_hangar_alt";
				var_575a869f = "lgt_exploder_dig_hangar_arrived";
				var_f78a8481 = "hangar_digger_body_lights";
				var_7dbee661 = "hangar_digger_arm_lights";
				break;
			}
		}
		var_beb7660e = getent(var_794a1037, "script_string");
		var_beb7660e.var_3d838929 = var_3d838929;
		var_beb7660e.var_ebcc585f = var_ebcc585f;
		var_beb7660e.var_575a869f = var_575a869f;
		var_a68e698 = undefined;
		var_f31f3fa4 = getentarray(var_beb7660e.target, "targetname");
		foreach(mdl_target in var_f31f3fa4)
		{
			if(mdl_target.model == "p7_zm_moo_crane_mining_arm")
			{
				var_beb7660e.var_26dbb029 = mdl_target;
				var_a68e698 = mdl_target;
				break;
			}
		}
		var_d0939dba = getentarray(var_f78a8481, "targetname");
		var_beb7660e.var_d0939dba = var_d0939dba;
		foreach(e_light in var_d0939dba)
		{
			e_light linkto(var_beb7660e);
		}
		if(isdefined(var_a68e698))
		{
			var_3b91d0ec = getentarray(var_7dbee661, "targetname");
			var_a68e698.var_3b91d0ec = var_3b91d0ec;
			foreach(e_light in var_3b91d0ec)
			{
				e_light linkto(var_a68e698);
			}
		}
	}
}

/*
	Name: digger_round_logic
	Namespace: zm_moon_digger
	Checksum: 0x442E4A69
	Offset: 0x1488
	Size: 0x2E4
	Parameters: 0
	Flags: Linked
*/
function digger_round_logic()
{
	level endon(#"digger_logic_stop");
	level flag::wait_till("power_on");
	wait(30);
	last_active_round = level.round_number;
	first_digger_activated = 0;
	if(randomint(100) >= 90)
	{
		digger_activate();
		last_active_round = level.round_number;
		first_digger_activated = 1;
	}
	rnd = 0;
	while(!first_digger_activated)
	{
		level waittill(#"between_round_over");
		if(level flag::exists("teleporter_used") && level flag::get("teleporter_used"))
		{
			continue;
		}
		if(randomint(100) >= 90 || rnd > 2)
		{
			digger_activate();
			last_active_round = level.round_number;
			first_digger_activated = 1;
		}
		rnd++;
	}
	while(true)
	{
		level waittill(#"between_round_over");
		if(level flag::exists("teleporter_used") && level flag::get("teleporter_used"))
		{
			continue;
		}
		if(level flag::get("digger_moving"))
		{
			continue;
		}
		if(level.round_number < 10)
		{
			min_activation_time = 3;
			max_activation_time = 8;
		}
		else
		{
			min_activation_time = 2;
			max_activation_time = 8;
		}
		diff = abs(level.round_number - last_active_round);
		if(diff >= min_activation_time && diff < max_activation_time)
		{
			if(randomint(100) >= 80)
			{
				digger_activate();
				last_active_round = level.round_number;
			}
		}
		else if(diff >= max_activation_time)
		{
			digger_activate();
			last_active_round = level.round_number;
		}
	}
}

/*
	Name: digger_activate
	Namespace: zm_moon_digger
	Checksum: 0xA5E2F855
	Offset: 0x1778
	Size: 0x1DC
	Parameters: 1
	Flags: Linked
*/
function digger_activate(force_digger)
{
	if(isdefined(force_digger))
	{
		level flag::set(("start_" + force_digger) + "_digger");
		level thread send_clientnotify(force_digger, 0);
		level thread play_digger_start_vox(force_digger);
		wait(1);
		level notify(force_digger + "_vox_timer_stop");
		level thread play_timer_vox(force_digger);
		return;
	}
	non_active = [];
	for(i = 0; i < level.diggers.size; i++)
	{
		if(!level flag::get(("start_" + level.diggers[i]) + "_digger"))
		{
			non_active[non_active.size] = level.diggers[i];
		}
	}
	if(non_active.size > 0)
	{
		digger_to_activate = array::random(non_active);
		level flag::set(("start_" + digger_to_activate) + "_digger");
		level thread send_clientnotify(digger_to_activate, 0);
		level thread play_digger_start_vox(digger_to_activate);
		wait(1);
		level thread play_timer_vox(digger_to_activate);
	}
}

/*
	Name: play_digger_start_vox
	Namespace: zm_moon_digger
	Checksum: 0xEF32ED6C
	Offset: 0x1960
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function play_digger_start_vox(digger_name)
{
	level thread zm_moon_amb::play_mooncomp_vox("vox_mcomp_digger_start_", digger_name);
	wait(7);
	if(!(isdefined(level.on_the_moon) && level.on_the_moon))
	{
		return;
	}
	players = getplayers();
	players[randomintrange(0, players.size)] thread zm_audio::create_and_play_dialog("digger", "incoming");
}

/*
	Name: send_clientnotify
	Namespace: zm_moon_digger
	Checksum: 0x11B1F013
	Offset: 0x1A18
	Size: 0x10E
	Parameters: 2
	Flags: Linked
*/
function send_clientnotify(digger_name, pause)
{
	switch(digger_name)
	{
		case "hangar":
		{
			if(!pause)
			{
				util::clientnotify("Dz3");
			}
			else
			{
				util::clientnotify("Dz3e");
			}
			break;
		}
		case "teleporter":
		{
			if(!pause)
			{
				util::clientnotify("Dz2");
			}
			else
			{
				util::clientnotify("Dz2e");
			}
			break;
		}
		case "biodome":
		{
			if(!pause)
			{
				util::clientnotify("Dz5");
			}
			else
			{
				util::clientnotify("Dz5e");
			}
			break;
		}
	}
}

/*
	Name: digger_think_move
	Namespace: zm_moon_digger
	Checksum: 0x98F24A38
	Offset: 0x1B30
	Size: 0x58C
	Parameters: 0
	Flags: Linked
*/
function digger_think_move()
{
	targets = getentarray(self.target, "targetname");
	if(targets[0].model == "p7_zm_moo_crane_mining_body_vista")
	{
		tracks = targets[0];
		arm = targets[1];
	}
	else
	{
		arm = targets[0];
		tracks = targets[1];
	}
	if(self.script_string == "teleporter_digger_stopped")
	{
		tracks = targets[0];
		arm = targets[1];
	}
	else
	{
		arm = targets[0];
		tracks = targets[1];
	}
	blade_center = getent(arm.target, "targetname");
	blade = getent(blade_center.target, "targetname");
	blade linkto(blade_center);
	blade_center linkto(arm);
	arm linkto(self);
	self linkto(tracks);
	tracks clientfield::set("digger_moving", 0);
	arm clientfield::set("digger_arm_fx", 0);
	exploder::delete_exploder_on_clients(self.var_3d838929);
	self.arm = arm;
	switch(tracks.target)
	{
		case "hangar_vehicle_path":
		{
			self.digger_name = "hangar";
			self.down_angle = -45;
			self.up_angle = 45;
			self.zones = array("cata_right_start_zone", "cata_right_middle_zone", "cata_right_end_zone");
			break;
		}
		case "digger_path_teleporter":
		{
			self.digger_name = "teleporter";
			self.down_angle = -52;
			self.up_angle = 52;
			self.zones = array("cata_left_middle_zone", "cata_left_start_zone");
			self.arm_lowered = 0;
			break;
		}
		case "digger_path_biodome":
		{
			self.digger_name = "biodome";
			self.down_angle = -20;
			self.up_angle = 20;
			self.zones = array("forest_zone");
			break;
		}
	}
	self.hacked_flag = self.digger_name + "_digger_hacked";
	self.hacked_before_breached_flag = self.digger_name + "_digger_hacked_before_breached";
	self.breached_flag = self.digger_name + "_breached";
	self.start_flag = ("start_" + self.digger_name) + "_digger";
	self.arm_lowered = 0;
	tracks digger_follow_path(self, undefined, arm);
	self endon(self.digger_name + "_digger_hacked");
	self stoploopsound(2);
	self playsound("evt_dig_move_stop");
	self unlink();
	level.arm_move_speed = 11;
	level.blade_spin_speed = 80;
	level.blade_spin_up_time = 1;
	body_turn = randomintrange(-1, 1);
	body_turn_speed = max(1, abs(body_turn)) * 0.3;
	arm unlink();
	arm.og_angles = arm.angles;
	self thread wait_for_digger_hack_digging(arm, blade_center, tracks);
	self thread wait_for_digger_hack_moving(arm, blade_center, tracks);
	self thread digger_arm_logic(arm, blade_center, tracks);
}

/*
	Name: wait_for_digger_hack_digging
	Namespace: zm_moon_digger
	Checksum: 0x1D360F41
	Offset: 0x20C8
	Size: 0x10C
	Parameters: 3
	Flags: Linked
*/
function wait_for_digger_hack_digging(arm, blade_center, tracks)
{
	self endon(#"stop_monitor");
	self waittill(#"digger_arm_raised");
	exploder::delete_exploder_on_clients(self.var_575a869f);
	blade_center linkto(arm);
	arm linkto(self);
	self linkto(tracks);
	tracks digger_follow_path(self, 1, arm);
	level flag::clear(self.hacked_flag);
	level flag::clear(self.start_flag);
	self thread digger_think_move();
}

/*
	Name: wait_for_digger_hack_moving
	Namespace: zm_moon_digger
	Checksum: 0xF9479A4A
	Offset: 0x21E0
	Size: 0xBC
	Parameters: 3
	Flags: Linked
*/
function wait_for_digger_hack_moving(arm, blade_center, tracks)
{
	self endon(#"arm_lower");
	while(true)
	{
		level waittill(#"digger_hacked", digger_name);
		if(digger_name == self.digger_name)
		{
			level flag::clear(self.hacked_flag);
			level flag::clear(self.start_flag);
			self notify(#"stop_monitor");
			self thread digger_think_move();
			break;
		}
	}
}

/*
	Name: digger_arm_breach_logic
	Namespace: zm_moon_digger
	Checksum: 0xE11DABD9
	Offset: 0x22A8
	Size: 0x5B6
	Parameters: 3
	Flags: Linked
*/
function digger_arm_breach_logic(arm, blade_center, tracks)
{
	self endon(self.hacked_flag);
	wait(8);
	if(level flag::get(self.hacked_flag))
	{
		return;
	}
	level notify(#"digger_arm_smash", self.digger_name, self.zones);
	switch(self.digger_name)
	{
		case "hangar":
		{
			exploder::exploder("fxexp_101");
			level flag::set("hangar_breached");
			level flag::set("hangar_blocked");
			if(isdefined(level.tunnel_11_destroyed))
			{
				level.tunnel_11_destroyed show();
			}
			earthquake(0.5, 3, level.tunnel_11_destroyed.origin, 1500);
			util::clientnotify("sl1");
			util::clientnotify("sl7");
			level.zones["cata_right_start_zone"].adjacent_zones["cata_right_middle_zone"].is_connected = 0;
			level.zones["cata_right_middle_zone"].adjacent_zones["cata_right_start_zone"].is_connected = 0;
			break;
		}
		case "teleporter":
		{
			exploder::exploder("fxexp_111");
			level flag::set("teleporter_breached");
			level flag::set("teleporter_blocked");
			if(isdefined(level.tunnel_6_destroyed))
			{
				level.tunnel_6_destroyed show();
			}
			earthquake(0.5, 3, level.tunnel_6_destroyed.origin, 1500);
			util::clientnotify("sl2");
			util::clientnotify("sl3");
			level.zones["airlock_west2_zone"].adjacent_zones["cata_left_middle_zone"].is_connected = 0;
			level.zones["cata_left_middle_zone"].adjacent_zones["airlock_west2_zone"].is_connected = 0;
			break;
		}
		case "biodome":
		{
			break;
		}
	}
	if(level flag::get("hangar_breached") && level flag::get("teleporter_breached"))
	{
		level flag::set("both_tunnels_breached");
	}
	if(level flag::get("teleporter_blocked") && level flag::get("hangar_blocked"))
	{
		level flag::set("both_tunnels_blocked");
	}
	else
	{
		level flag::clear("both_tunnels_blocked");
	}
	arm waittill(#"rotatedone");
	arm playsound("evt_dig_arm_stop");
	blade_center unlink();
	switch(self.digger_name)
	{
		case "hangar":
		{
			blade_center playloopsound("evt_dig_wheel_loop1", 1);
			break;
		}
		case "teleporter":
		{
			blade_center playloopsound("evt_dig_wheel_loop1", 1);
			break;
		}
		case "biodome":
		{
			blade_center playloopsound("evt_dig_wheel_loop2", 1);
			break;
		}
	}
	blade_center clientfield::set("digger_digging", 1);
	blade_center rotatepitch(720, 5, level.blade_spin_up_time, level.blade_spin_up_time);
	smokeangles = (0, arm.angles[1] + 180, arm.angles[2]);
	forward = anglestoforward(smokeangles);
	wait(2);
	self.arm_moving = undefined;
}

/*
	Name: digger_arm_logic
	Namespace: zm_moon_digger
	Checksum: 0xC0A4936E
	Offset: 0x2868
	Size: 0x57A
	Parameters: 3
	Flags: Linked
*/
function digger_arm_logic(arm, blade_center, tracks)
{
	arm clientfield::set("digger_arm_fx", 1);
	tracks clientfield::set("digger_moving", 1);
	exploder::exploder(self.var_3d838929);
	exploder::exploder(self.var_575a869f);
	if(!level flag::get(self.hacked_flag))
	{
		if(!(isdefined(self.arm_lowered) && self.arm_lowered))
		{
			self notify(#"arm_lower");
			self.arm_lowered = 1;
			self.arm_moving = 1;
			arm unlink();
			arm playsound("evt_dig_arm_move");
			arm rotatepitch(self.down_angle, level.arm_move_speed, level.arm_move_speed / 4, level.arm_move_speed / 4);
			self thread digger_arm_breach_logic(arm, blade_center, tracks);
		}
		while(!level flag::get(self.hacked_flag))
		{
			if(!blade_center islinkedto(arm))
			{
				blade_center rotatepitch(360, 3);
			}
			wait(3);
		}
	}
	while(isdefined(self.arm_moving) && self.arm_moving && !level flag::get(self.hacked_flag))
	{
		wait(0.1);
	}
	if(isdefined(self.arm_lowered) && self.arm_lowered)
	{
		self.arm_moving = 1;
		self.arm_lowered = 0;
		blade_center stoploopsound(2);
		blade_center clientfield::set("digger_digging", 0);
		blade_center linkto(arm);
		arm playsound("evt_dig_arm_move");
		arm rotatepitch(self.up_angle, level.arm_move_speed, level.arm_move_speed / 4, level.arm_move_speed / 4);
		wait(2);
		level notify(#"digger_arm_lift", self.digger_name);
		switch(self.digger_name)
		{
			case "hangar":
			{
				exploder::stop_exploder("fxexp_101");
				if(level flag::get("tunnel_11_door1"))
				{
					level.zones["cata_right_start_zone"].adjacent_zones["cata_right_middle_zone"].is_connected = 1;
					level.zones["cata_right_middle_zone"].adjacent_zones["cata_right_start_zone"].is_connected = 1;
				}
				level flag::clear("hangar_blocked");
				level flag::clear("both_tunnels_blocked");
				break;
			}
			case "teleporter":
			{
				exploder::stop_exploder("fxexp_111");
				if(level flag::get("catacombs_west4"))
				{
					level.zones["airlock_west2_zone"].adjacent_zones["cata_left_middle_zone"].is_connected = 1;
					level.zones["cata_left_middle_zone"].adjacent_zones["airlock_west2_zone"].is_connected = 1;
				}
				level flag::clear("teleporter_blocked");
				level flag::clear("both_tunnels_blocked");
				break;
			}
		}
		arm waittill(#"rotatedone");
		arm linkto(self);
		arm playsound("evt_dig_arm_stop");
		self.arm_moving = undefined;
		self notify(#"digger_arm_raised");
	}
}

/*
	Name: digger_think_panel
	Namespace: zm_moon_digger
	Checksum: 0xDE988CB5
	Offset: 0x2DF0
	Size: 0x364
	Parameters: 8
	Flags: Linked
*/
function digger_think_panel(blocker_name, trig_name, start_flag, hacked_flag, hacked_before_breached_flag, breached_flag, blocker_func, digger_name)
{
	if(isdefined(blocker_name))
	{
		dmg_trig = getent(("digger_" + digger_name) + "_dmg", "targetname");
		blocker = getent(blocker_name, "targetname");
		if(digger_name == "teleporter")
		{
			dmg_trig.origin = dmg_trig.origin + (vectorscale((0, -1, 0), 20));
			blocker.origin = blocker.origin + (vectorscale((0, -1, 0), 20));
		}
		level thread [[blocker_func]](blocker, digger_name, dmg_trig);
	}
	if(!isdefined(blocker_name) && isdefined(blocker_func))
	{
		level thread [[blocker_func]](digger_name);
	}
	trig = getent(trig_name, "targetname");
	struct = spawnstruct();
	struct.origin = trig.origin - vectorscale((0, 0, 1), 12);
	struct.script_int = -1000;
	struct.script_float = 5;
	struct.digger_name = digger_name;
	struct.hacked_flag = hacked_flag;
	struct.hacked_before_breached_flag = hacked_before_breached_flag;
	struct.breached_flag = breached_flag;
	struct.start_flag = start_flag;
	struct.custom_debug_color = vectorscale((1, 0, 0), 255);
	struct.radius = 64;
	struct.height = 64;
	struct.custom_string = &"ZM_MOON_DISABLE_DIGGER";
	struct.no_bullet_trace = 1;
	struct.no_sight_check = 1;
	trig usetriggerrequirelookat();
	trig setcursorhint("HINT_NOICON");
	trig thread zm_equip_hacker::hide_hint_when_hackers_active();
	trig sethintstring(&"ZM_MOON_NO_HACK");
	trig thread set_hint_on_digger_trig(start_flag, hacked_flag, struct);
}

/*
	Name: set_hint_on_digger_trig
	Namespace: zm_moon_digger
	Checksum: 0xA77F8452
	Offset: 0x3160
	Size: 0x2A8
	Parameters: 3
	Flags: Linked
*/
function set_hint_on_digger_trig(start_flag, hacked_flag, struct)
{
	while(true)
	{
		if(!level flag::get(start_flag))
		{
			zm_equip_hacker::deregister_hackable_struct(struct);
			self sethintstring(&"ZM_MOON_NO_HACK");
		}
		level flag::wait_till(start_flag);
		if(!level flag::get(hacked_flag))
		{
			zm_equip_hacker::register_pooled_hackable_struct(struct, &digger_hack_func, &digger_hack_qualifer);
			self sethintstring(&"ZM_MOON_SYSTEM_ONLINE");
			switch(struct.digger_name)
			{
				case "hangar":
				{
					level clientfield::set("HCA", 1);
					break;
				}
				case "teleporter":
				{
					level clientfield::set("TCA", 1);
					break;
				}
				case "biodome":
				{
					level clientfield::set("BCA", 1);
					break;
				}
			}
		}
		level flag::wait_till(hacked_flag);
		zm_equip_hacker::deregister_hackable_struct(struct);
		self sethintstring(&"ZM_MOON_NO_HACK");
		switch(struct.digger_name)
		{
			case "hangar":
			{
				level clientfield::set("HCA", 0);
				break;
			}
			case "teleporter":
			{
				level clientfield::set("TCA", 0);
				break;
			}
			case "biodome":
			{
				level clientfield::set("BCA", 0);
				break;
			}
		}
		level flag::wait_till_clear(hacked_flag);
		wait(0.05);
	}
}

/*
	Name: digger_hack_func
	Namespace: zm_moon_digger
	Checksum: 0x38FE3E38
	Offset: 0x3410
	Size: 0x13A
	Parameters: 1
	Flags: Linked
*/
function digger_hack_func(hacker)
{
	level thread send_clientnotify(self.digger_name, 1);
	hacker thread zm_audio::create_and_play_dialog("digger", "hacked");
	level thread delayed_computer_hacked_vox(self.digger_name);
	level flag::set(self.hacked_flag);
	if(!level flag::get(self.breached_flag))
	{
		level flag::set(self.hacked_before_breached_flag);
	}
	level notify(self.digger_name + "_vox_timer_stop");
	while(true)
	{
		level waittill(#"digger_reached_end", digger_name);
		if(digger_name == self.digger_name)
		{
			break;
		}
	}
	level notify(#"digger_hacked", self.digger_name);
}

/*
	Name: delayed_computer_hacked_vox
	Namespace: zm_moon_digger
	Checksum: 0x120CA481
	Offset: 0x3558
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function delayed_computer_hacked_vox(digger)
{
	wait(4);
	level thread zm_moon_amb::play_mooncomp_vox("vox_mcomp_digger_hacked_", digger);
}

/*
	Name: digger_hack_qualifer
	Namespace: zm_moon_digger
	Checksum: 0x65B20DB0
	Offset: 0x3598
	Size: 0x36
	Parameters: 1
	Flags: Linked
*/
function digger_hack_qualifer(player)
{
	if(!level flag::get(self.hacked_flag))
	{
		return true;
	}
	return false;
}

/*
	Name: digger_think_biodome
	Namespace: zm_moon_digger
	Checksum: 0x48D2987E
	Offset: 0x35D8
	Size: 0x14E
	Parameters: 1
	Flags: Linked
*/
function digger_think_biodome(digger_name)
{
	while(true)
	{
		level waittill(#"digger_arm_smash", name, zones);
		if(name == digger_name)
		{
			level flag::set("biodome_breached");
			level thread biodome_breach_fx();
			for(i = 0; i < zones.size; i++)
			{
				zone = zones[i];
				_zones = getentarray(zone, "targetname");
				for(x = 0; x < _zones.size; x++)
				{
					_zones[x].script_string = "lowgravity";
				}
				level thread zm_moon_gravity::zone_breached(zone);
			}
			break;
		}
	}
}

/*
	Name: biodome_breach_fx
	Namespace: zm_moon_digger
	Checksum: 0x5252F7
	Offset: 0x3730
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function biodome_breach_fx()
{
	util::clientnotify("BIO");
	level clientfield::set("BIO", 1);
	exploder::exploder("fxexp_200");
	exploder::delete_exploder_on_clients("fxexp_1100");
}

/*
	Name: digger_think_blocker
	Namespace: zm_moon_digger
	Checksum: 0x6BFB6488
	Offset: 0x37A8
	Size: 0x1F2
	Parameters: 3
	Flags: Linked
*/
function digger_think_blocker(blocker, digger_name, dmg_trig)
{
	dmg_trig triggerenable(0);
	dmg_trig thread digger_damage_player();
	level thread digger_think_blocker_remove(blocker, digger_name, dmg_trig);
	while(true)
	{
		level waittill(#"digger_arm_smash", name, zones);
		if(name == digger_name)
		{
			blocker movez(-512, 0.05, 0.05);
			blocker waittill(#"movedone");
			blocker disconnectpaths();
			blocker thread kill_anyone_touching_blocker();
			dmg_trig triggerenable(1);
			for(i = 0; i < zones.size; i++)
			{
				zone = zones[i];
				_zones = getentarray(zone, "targetname");
				for(x = 0; x < _zones.size; x++)
				{
					_zones[x].script_string = "lowgravity";
				}
				level thread zm_moon_gravity::zone_breached(zone);
			}
		}
	}
}

/*
	Name: digger_damage_player
	Namespace: zm_moon_digger
	Checksum: 0xD8984F12
	Offset: 0x39A8
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function digger_damage_player()
{
	while(true)
	{
		self waittill(#"trigger", player);
		if(!zombie_utility::is_player_valid(player) && (!(isdefined(player._pushed) && player._pushed)))
		{
			continue;
		}
		if(!player laststand::player_is_in_laststand())
		{
			if(player hasperk("specialty_armorvest"))
			{
				player dodamage(100, player.origin);
			}
			level thread digger_push_player(self, player);
		}
	}
}

/*
	Name: digger_push_player
	Namespace: zm_moon_digger
	Checksum: 0xDBC9C600
	Offset: 0x3A98
	Size: 0x24E
	Parameters: 2
	Flags: Linked
*/
function digger_push_player(trig, player)
{
	player endon(#"disconnect");
	player._pushed = 1;
	eye_org = trig.origin;
	foot_org = trig.origin;
	mid_org = trig.origin;
	explode_radius = 50;
	test_org = player geteye();
	dist = distance(eye_org, test_org);
	scale = 1 - (dist / explode_radius);
	if(scale < 0)
	{
		scale = 0;
	}
	pulse = randomintrange(20, 45);
	dir = (player.origin[0] - trig.origin[0], player.origin[1] - trig.origin[1], 0);
	dir = vectornormalize(dir);
	dir = dir + (0, 0, 1);
	dir = dir * pulse;
	player setorigin(player.origin + vectorscale((0, 0, 1), 0.1));
	player_velocity = dir;
	player setvelocity(player_velocity);
	wait(2);
	player._pushed = undefined;
}

/*
	Name: kill_anyone_touching_blocker
	Namespace: zm_moon_digger
	Checksum: 0x2AABFE7D
	Offset: 0x3CF0
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function kill_anyone_touching_blocker()
{
	self endon(#"stop_check");
	while(true)
	{
		if(isdefined(self.trigger_off))
		{
			wait(0.05);
			continue;
		}
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(players[i] istouching(self))
			{
				if(!players[i] laststand::player_is_in_laststand())
				{
					players[i] player_digger_instant_kill();
				}
			}
		}
		zombies = getaiarray();
		for(i = 0; i < zombies.size; i++)
		{
			if(isdefined(zombies[i]) && zombies[i] istouching(self))
			{
				zombies[i] thread zombie_ragdoll_death();
				util::wait_network_frame();
			}
		}
		wait(0.1);
	}
}

/*
	Name: player_digger_instant_kill
	Namespace: zm_moon_digger
	Checksum: 0xAD9177C9
	Offset: 0x3E80
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function player_digger_instant_kill()
{
	self thread zm_moon::insta_kill_player();
}

/*
	Name: zombie_ragdoll_death
	Namespace: zm_moon_digger
	Checksum: 0x89BC86EF
	Offset: 0x3EA8
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function zombie_ragdoll_death()
{
	self endon(#"death");
	fwd = anglestoforward(zm_utility::flat_angle(self.angles));
	my_velocity = vectorscale(fwd, 200);
	my_velocity_with_lift = (my_velocity[0], my_velocity[1], 20);
	self launchragdoll(my_velocity_with_lift, self.origin);
	util::wait_network_frame();
	self dodamage(self.health + 666, self.origin);
}

/*
	Name: digger_think_blocker_remove
	Namespace: zm_moon_digger
	Checksum: 0xCAABADE4
	Offset: 0x3F90
	Size: 0xB8
	Parameters: 3
	Flags: Linked
*/
function digger_think_blocker_remove(blocker, digger_name, dmg_trig)
{
	while(true)
	{
		level waittill(#"digger_arm_lift", name);
		if(name == digger_name)
		{
			blocker connectpaths();
			blocker movez(512, 0.05, 0.05);
			dmg_trig triggerenable(0);
			blocker notify(#"stop_check");
		}
	}
}

/*
	Name: diggers_think_no_mans_land
	Namespace: zm_moon_digger
	Checksum: 0x95AF6C82
	Offset: 0x4050
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function diggers_think_no_mans_land()
{
	level endon(#"intermission");
	diggers = getentarray("digger_body", "targetname");
	while(true)
	{
		level flag::wait_till("enter_nml");
		array::thread_all(diggers, &diggers_visible, 0);
		flag::wait_till_clear("enter_nml");
		array::thread_all(diggers, &diggers_visible, 1);
	}
}

/*
	Name: diggers_visible
	Namespace: zm_moon_digger
	Checksum: 0x680B595E
	Offset: 0x4118
	Size: 0x26C
	Parameters: 1
	Flags: Linked
*/
function diggers_visible(visible)
{
	targets = getentarray(self.target, "targetname");
	if(targets[0].model == "p7_zm_moo_crane_mining_body_vista")
	{
		tracks = targets[0];
		arm = targets[1];
	}
	else
	{
		arm = targets[0];
		tracks = targets[1];
	}
	if(self.script_string == "teleporter_digger_stopped")
	{
		tracks = targets[0];
		arm = targets[1];
	}
	else
	{
		arm = targets[0];
		tracks = targets[1];
	}
	blade_center = getent(arm.target, "targetname");
	blade = getent(blade_center.target, "targetname");
	if(!visible)
	{
		level clientfield::set("DH", 1);
		blade hide();
		arm hide();
		tracks hide();
		self hide();
	}
	else
	{
		level clientfield::set("DH", 0);
		blade function_267c538a();
		arm function_267c538a();
		tracks function_267c538a();
		self function_267c538a();
	}
}

/*
	Name: function_267c538a
	Namespace: zm_moon_digger
	Checksum: 0x18428E03
	Offset: 0x4390
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function function_267c538a()
{
	self show();
	foreach(player in level.players)
	{
		player givededicatedshadow(self);
	}
}

/*
	Name: play_timer_vox
	Namespace: zm_moon_digger
	Checksum: 0x73D95691
	Offset: 0x4440
	Size: 0x1FC
	Parameters: 1
	Flags: Linked
*/
function play_timer_vox(digger_name)
{
	level endon(digger_name + "_vox_timer_stop");
	time_left = level.diggers_global_time;
	played180sec = 0;
	played120sec = 0;
	played60sec = 0;
	played30sec = 0;
	digger_start_time = gettime();
	while(time_left > 0)
	{
		curr_time = gettime();
		time_used = (curr_time - digger_start_time) / 1000;
		time_left = level.diggers_global_time - time_used;
		if(time_left <= 180 && !played180sec)
		{
			level thread zm_moon_amb::play_mooncomp_vox("vox_mcomp_digger_start_", digger_name);
			played180sec = 1;
		}
		if(time_left <= 120 && !played120sec)
		{
			level thread zm_moon_amb::play_mooncomp_vox("vox_mcomp_digger_start_", digger_name);
			played120sec = 1;
		}
		if(time_left <= 60 && !played60sec)
		{
			level thread zm_moon_amb::play_mooncomp_vox("vox_mcomp_digger_time_60_", digger_name);
			played60sec = 1;
		}
		if(time_left <= 30 && !played30sec)
		{
			level thread zm_moon_amb::play_mooncomp_vox("vox_mcomp_digger_time_30_", digger_name);
			played30sec = 1;
		}
		wait(1);
	}
}

/*
	Name: get_correct_times
	Namespace: zm_moon_digger
	Checksum: 0x567022B8
	Offset: 0x4648
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function get_correct_times(digger)
{
	level endon(#"digger_arm_smash");
	for(i = 0; i < 500; i++)
	{
		iprintlnbold(i);
		wait(1);
	}
}

/*
	Name: waitfor_smash
	Namespace: zm_moon_digger
	Checksum: 0x76EAAF47
	Offset: 0x46B0
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function waitfor_smash()
{
	while(true)
	{
		level waittill(#"digger_arm_smash", digger, zones);
		level thread play_delayed_breach_vox(digger);
		level thread switch_ambient_packages(digger);
		level thread player_breach_vox(zones);
	}
}

/*
	Name: switch_ambient_packages
	Namespace: zm_moon_digger
	Checksum: 0x1D078ABB
	Offset: 0x4738
	Size: 0x1CE
	Parameters: 1
	Flags: Linked
*/
function switch_ambient_packages(digger)
{
	switch(digger)
	{
		case "hangar":
		{
			level clientfield::increment("Az3b");
			level.audio_zones_breached["3b"] = 1;
			level flag::wait_till("tunnel_11_door1");
			level clientfield::increment("Az3a");
			level.audio_zones_breached["3a"] = 1;
			level flag::wait_till("tunnel_11_door2");
			level clientfield::increment("Az3c");
			level.audio_zones_breached["3c"] = 1;
			break;
		}
		case "teleporter":
		{
			level clientfield::increment("Az2b");
			level.audio_zones_breached["2b"] = 1;
			level flag::wait_till("tunnel_6_door1");
			level clientfield::increment("Az2a");
			level.audio_zones_breached["2a"] = 1;
			break;
		}
		case "biodome":
		{
			level clientfield::increment("Az5");
			level.audio_zones_breached["5"] = 1;
			break;
		}
	}
}

/*
	Name: play_delayed_breach_vox
	Namespace: zm_moon_digger
	Checksum: 0xA942F213
	Offset: 0x4910
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function play_delayed_breach_vox(digger)
{
	if(!level.on_the_moon)
	{
		return;
	}
	playsoundatposition("evt_breach_alarm", (0, 0, 0));
	wait(1.5);
	if(!level.on_the_moon)
	{
		return;
	}
	playsoundatposition("evt_breach_alarm", (0, 0, 0));
	wait(1.5);
	if(!level.on_the_moon)
	{
		return;
	}
	playsoundatposition("evt_breach_alarm", (0, 0, 0));
	wait(2);
	level thread zm_moon_amb::play_mooncomp_vox("vox_mcomp_digger_breach_", digger);
}

/*
	Name: player_breach_vox
	Namespace: zm_moon_digger
	Checksum: 0xC325DD22
	Offset: 0x49D8
	Size: 0x15A
	Parameters: 1
	Flags: Linked
*/
function player_breach_vox(zones)
{
	players = getplayers();
	for(i = 0; i < zones.size; i++)
	{
		zone = zones[i];
		_zones = getentarray(zone, "targetname");
		for(x = 0; x < _zones.size; x++)
		{
			for(j = 0; j < players.size; j++)
			{
				if(zombie_utility::is_player_valid(players[j]) && players[j] istouching(_zones[x]))
				{
					players[j] thread zm_audio::create_and_play_dialog("digger", "breach");
				}
			}
		}
	}
}

/*
	Name: link_vehicle_nodes
	Namespace: zm_moon_digger
	Checksum: 0xA2DEF36D
	Offset: 0x4B40
	Size: 0x11E
	Parameters: 1
	Flags: Linked
*/
function link_vehicle_nodes(start_node)
{
	start_node.previous_node = undefined;
	linked_nodes = [];
	linked_nodes[linked_nodes.size] = start_node;
	cur_node = start_node;
	while(true)
	{
		if(isdefined(cur_node.target))
		{
			next_node = getvehiclenode(cur_node.target, "targetname");
			previous_node = cur_node;
			cur_node.next_node = next_node;
			cur_node = getvehiclenode(cur_node.target, "targetname");
			cur_node.previous_node = previous_node;
			linked_nodes[linked_nodes.size] = cur_node;
		}
		else
		{
			break;
		}
	}
	return linked_nodes;
}

/*
	Name: digger_debug_star
	Namespace: zm_moon_digger
	Checksum: 0x251B7996
	Offset: 0x4C68
	Size: 0x64
	Parameters: 3
	Flags: Linked
*/
function digger_debug_star(origin, color, time)
{
	/#
		if(!isdefined(time))
		{
			time = 1000;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		debugstar(origin, time, color);
	#/
}

/*
	Name: digger_follow_path_calc_speed
	Namespace: zm_moon_digger
	Checksum: 0x69539A04
	Offset: 0x4CD8
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function digger_follow_path_calc_speed()
{
	path_start_node = getvehiclenode(self.target, "targetname");
	number_nodes = 0;
	self.path_length = 0;
	start_node = path_start_node;
	while(isdefined(start_node.target))
	{
		next_node = getvehiclenode(start_node.target, "targetname");
		if(isdefined(next_node))
		{
			length = length(next_node.origin - start_node.origin);
			self.path_length = self.path_length + length;
			start_node = next_node;
			digger_debug_star(start_node.origin, (1, 1, 1), 1000);
			number_nodes++;
		}
	}
	self.digger_speed = self.path_length / level.diggers_global_time;
}

/*
	Name: digger_follow_path_recalc_speed
	Namespace: zm_moon_digger
	Checksum: 0x6339CEEB
	Offset: 0x4E30
	Size: 0x17C
	Parameters: 1
	Flags: Linked
*/
function digger_follow_path_recalc_speed(path_start_node)
{
	number_nodes = 0;
	self.path_length = 0;
	start_node = path_start_node;
	while(isdefined(start_node.target))
	{
		next_node = getvehiclenode(start_node.target, "targetname");
		if(isdefined(next_node))
		{
			length = length(next_node.origin - start_node.origin);
			self.path_length = self.path_length + length;
			start_node = next_node;
			digger_debug_star(start_node.origin, (1, 1, 1), 1000);
			number_nodes++;
		}
	}
	curr_time = gettime();
	time_used = (curr_time - self.start_time) / 1000;
	time_left = level.diggers_global_time - time_used;
	self.digger_speed = self.path_length / time_left;
}

/*
	Name: digger_debugger_counter
	Namespace: zm_moon_digger
	Checksum: 0x30DF0681
	Offset: 0x4FB8
	Size: 0x15C
	Parameters: 1
	Flags: Linked
*/
function digger_debugger_counter(time_to_help_them)
{
	/#
		elem = newhudelem();
		elem.hidewheninmenu = 1;
		elem.horzalign = "";
		elem.vertalign = "";
		elem.alignx = "";
		elem.aligny = "";
		elem.x = 0;
		elem.y = 0;
		elem.foreground = 1;
		elem.font = "";
		elem.fontscale = 2;
		elem.color = (1, 1, 1);
		elem.alpha = 1;
		elem settimer(time_to_help_them);
		wait(time_to_help_them + 3);
		elem destroy();
	#/
}

/*
	Name: digger_follow_path
	Namespace: zm_moon_digger
	Checksum: 0x6C83F305
	Offset: 0x5120
	Size: 0xD62
	Parameters: 3
	Flags: Linked
*/
function digger_follow_path(body, reverse, arm)
{
	last_node = undefined;
	next_node_dir = undefined;
	direction = undefined;
	fraction = 0;
	reached_end = 0;
	path_start_node = getvehiclenode(self.target, "targetname");
	linked_nodes = link_vehicle_nodes(path_start_node);
	self thread digger_follow_path_calc_speed();
	if(level flag::get("init_diggers"))
	{
		self.origin = path_start_node.origin;
		self.angles = path_start_node.angles;
	}
	if(isdefined(body.start_flag))
	{
		level flag::wait_till(body.start_flag);
	}
	if(!isdefined(reverse))
	{
		current_node = path_start_node;
		next_node = linked_nodes[0].next_node;
		fx_name = "digger_treadfx_fwd";
		level flag::set("digger_moving");
	}
	else
	{
		current_node = linked_nodes[linked_nodes.size - 1];
		next_node = linked_nodes[linked_nodes.size - 1].previous_node;
		fx_name = "digger_treadfx_bkwd";
		self.digger_speed = 5;
		level flag::clear("digger_moving");
	}
	body playsound("evt_dig_move_start");
	self clientfield::set("digger_moving", 1);
	arm clientfield::set("digger_arm_fx", 1);
	exploder::exploder(body.var_3d838929);
	exploder::exploder(body.var_ebcc585f);
	body playloopsound("evt_dig_move_loop", 0.5);
	if(body.digger_name == "hangar")
	{
		exploder::exploder("fxexp_102");
	}
	else if(body.digger_name == "teleporter")
	{
		exploder::exploder("fxexp_112");
	}
	self.start_time = gettime();
	level thread digger_debugger_counter(level.diggers_global_time);
	while(!reached_end)
	{
		if(level flag::get(body.hacked_flag))
		{
			direction = "bkwd";
			if(level flag::get("digger_moving"))
			{
				level flag::clear("digger_moving");
			}
		}
		else
		{
			if(!level flag::get("digger_moving"))
			{
				level flag::set("digger_moving");
			}
			direction = "fwd";
		}
		last_node_dir = (1, 0, 0);
		if(isdefined(last_node))
		{
			last_node_dir = current_node.origin - last_node.origin;
			last_node_dir = vectornormalize(last_node_dir);
		}
		else
		{
			last_node_dir = anglestoforward(self.angles);
		}
		curr_node_dir = next_node.origin - current_node.origin;
		curr_node_dir = vectornormalize(curr_node_dir);
		if(direction == "fwd")
		{
			if(isdefined(current_node.next_node) && isdefined(current_node.next_node.next_node))
			{
				next_node_dir = current_node.next_node.next_node.origin - next_node.origin;
			}
			else
			{
				end_time = gettime();
				total_time = end_time - self.start_time;
				reached_end = 1;
			}
		}
		else
		{
			if(isdefined(current_node.previous_node) && isdefined(current_node.previous_node.previous_node))
			{
				next_node_dir = current_node.previous_node.previous_node.origin - next_node.origin;
			}
			else
			{
				end_time = gettime();
				total_time = end_time - self.start_time;
				reached_end = 1;
			}
		}
		next_node_dir = vectornormalize(next_node_dir);
		next_node_plane = curr_node_dir + next_node_dir;
		next_node_plane = vectornormalize(next_node_plane);
		curr_node_plane = last_node_dir + curr_node_dir;
		curr_node_plane = vectornormalize(curr_node_plane);
		origin = self.origin;
		curr_node_to_origin = origin - current_node.origin;
		origin_to_next_node = next_node.origin - origin;
		d1 = vectordot(curr_node_to_origin, curr_node_plane);
		d2 = vectordot(origin_to_next_node, next_node_plane);
		if(d2 < 0)
		{
			last_node = current_node;
			current_node = next_node;
			if(direction == "fwd")
			{
				next_node = current_node.next_node;
				self thread digger_follow_path_recalc_speed(current_node);
				continue;
			}
			else
			{
				next_node = current_node.previous_node;
				self thread digger_follow_path_recalc_speed(current_node);
				continue;
			}
		}
		else if(d1 < 0)
		{
			d1 = vectordot(curr_node_dir, curr_node_to_origin);
			if(d1 < 0)
			{
				fraction = 0;
			}
			else
			{
				curr_node_length = length(next_node.origin - current_node.origin);
				dist = length(origin_to_next_node);
				fraction = 1 - (dist / curr_node_length);
				fraction = math::clamp(fraction, 0, 1);
				if(fraction > 0.95)
				{
					last_node = current_node;
					current_node = next_node;
					if(direction == "fwd")
					{
						next_node = current_node.next_node;
						self thread digger_follow_path_recalc_speed(current_node);
						continue;
					}
					else
					{
						next_node = current_node.previous_node;
						self thread digger_follow_path_recalc_speed(current_node);
						continue;
					}
				}
			}
		}
		fraction = d1 / (d1 + d2);
		speed = current_node.speed + ((next_node.speed - current_node.speed) * fraction);
		speed = (speed * 0.5) * level.digger_speed_multiplier;
		look_ahead = current_node.lookahead + ((next_node.lookahead - current_node.lookahead) * fraction);
		look_dist = current_node.lookahead * speed;
		node_length = length(next_node.origin - current_node.origin);
		dist = (fraction * node_length) + look_dist;
		look_pos = (0, 0, 0);
		if(dist > node_length)
		{
			delta = dist - node_length;
			look_pos = next_node.origin + (next_node_dir * delta);
		}
		else
		{
			look_pos = self.origin + (curr_node_dir * dist);
		}
		look_dir = vectornormalize(look_pos - self.origin);
		if(direction == "fwd")
		{
			velocity = (look_dir * self.digger_speed) * level.digger_speed_multiplier;
		}
		else
		{
			velocity = look_dir * speed;
		}
		self.origin = self.origin + (velocity * 0.05);
		look_ahead = current_node.lookahead + ((next_node.lookahead - current_node.lookahead) * fraction);
		self.angles = current_node.angles + ((next_node.angles - current_node.angles) * fraction);
		wait(0.05);
	}
	if(body.digger_name == "hangar")
	{
		exploder::stop_exploder("fxexp_102");
	}
	else if(body.digger_name == "teleporter")
	{
		exploder::stop_exploder("fxexp_112");
	}
	self clientfield::set("digger_moving", 0);
	arm clientfield::set("digger_arm_fx", 0);
	exploder::delete_exploder_on_clients(body.var_3d838929);
	exploder::delete_exploder_on_clients(body.var_ebcc585f);
	level flag::clear("digger_moving");
	level notify(#"digger_reached_end", body.digger_name);
	self notify(#"path_end");
}

/*
	Name: quantum_bomb_remove_digger_validation
	Namespace: zm_moon_digger
	Checksum: 0x50E11624
	Offset: 0x5E90
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_remove_digger_validation(position)
{
	if(!level flag::get("both_tunnels_breached"))
	{
		return false;
	}
	range_squared = 360000;
	hangar_blocker = getent("digger_hangar_blocker", "targetname");
	if(distancesquared(hangar_blocker.origin, position) < range_squared)
	{
		return true;
	}
	teleporter_blocker = getent("digger_teleporter_blocker", "targetname");
	if(distancesquared(teleporter_blocker.origin, position) < range_squared)
	{
		return true;
	}
	return false;
}

/*
	Name: quantum_bomb_remove_digger_result
	Namespace: zm_moon_digger
	Checksum: 0x96540AB0
	Offset: 0x5FA8
	Size: 0x140
	Parameters: 1
	Flags: Linked
*/
function quantum_bomb_remove_digger_result(position)
{
	range_squared = 360000;
	hangar_blocker = getent("digger_hangar_blocker", "targetname");
	if(distancesquared(hangar_blocker.origin, position) < range_squared)
	{
		level flag::set("hangar_digger_hacked");
		[[level.quantum_bomb_play_area_effect_func]](position);
	}
	teleporter_blocker = getent("digger_teleporter_blocker", "targetname");
	if(distancesquared(teleporter_blocker.origin, position) < range_squared)
	{
		level flag::set("teleporter_digger_hacked");
		[[level.quantum_bomb_play_area_effect_func]](position);
	}
}

