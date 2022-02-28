// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\zm_tomb_chamber;
#using scripts\zm\zm_tomb_ee_main;
#using scripts\zm\zm_tomb_utility;
#using scripts\zm\zm_tomb_vo;

#namespace zm_tomb_ee_main_step_3;

/*
	Name: init
	Namespace: zm_tomb_ee_main_step_3
	Checksum: 0x7D98C26F
	Offset: 0x470
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function init()
{
	zm_sidequests::declare_sidequest_stage("little_girl_lost", "step_3", &init_stage, &stage_logic, &exit_stage);
}

/*
	Name: init_stage
	Namespace: zm_tomb_ee_main_step_3
	Checksum: 0xB44B34FB
	Offset: 0x4D0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function init_stage()
{
	level._cur_stage_name = "step_3";
	level.check_valid_poi = &mech_zombie_hole_valid;
	create_buttons_and_triggers();
}

/*
	Name: stage_logic
	Namespace: zm_tomb_ee_main_step_3
	Checksum: 0x2A196402
	Offset: 0x518
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function stage_logic()
{
	/#
		iprintln(level._cur_stage_name + "");
	#/
	level thread watch_for_triple_attack();
	level flag::wait_till("ee_mech_zombie_hole_opened");
	util::wait_network_frame();
	zm_sidequests::stage_completed("little_girl_lost", level._cur_stage_name);
}

/*
	Name: exit_stage
	Namespace: zm_tomb_ee_main_step_3
	Checksum: 0x6CE2D383
	Offset: 0x5B8
	Size: 0x136
	Parameters: 1
	Flags: Linked
*/
function exit_stage(success)
{
	level.check_valid_poi = undefined;
	level notify(#"fire_link_cooldown");
	level flag::set("fire_link_enabled");
	a_buttons = getentarray("fire_link_button", "targetname");
	array::delete_all(a_buttons);
	a_structs = struct::get_array("fire_link", "targetname");
	foreach(unitrigger_stub in a_structs)
	{
		zm_unitrigger::unregister_unitrigger(unitrigger_stub);
	}
	level notify(#"hash_7bcf8600");
}

/*
	Name: create_buttons_and_triggers
	Namespace: zm_tomb_ee_main_step_3
	Checksum: 0xA159047
	Offset: 0x6F8
	Size: 0x1AA
	Parameters: 0
	Flags: Linked
*/
function create_buttons_and_triggers()
{
	a_structs = struct::get_array("fire_link", "targetname");
	foreach(unitrigger_stub in a_structs)
	{
		unitrigger_stub.radius = 36;
		unitrigger_stub.height = 256;
		unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
		unitrigger_stub.cursor_hint = "HINT_NOICON";
		unitrigger_stub.require_look_at = 1;
		m_model = spawn("script_model", unitrigger_stub.origin);
		m_model setmodel("p7_zm_ori_button_alarm");
		m_model.angles = unitrigger_stub.angles;
		m_model.targetname = "fire_link_button";
		m_model thread ready_to_activate(unitrigger_stub);
		util::wait_network_frame();
	}
}

/*
	Name: ready_to_activate
	Namespace: zm_tomb_ee_main_step_3
	Checksum: 0x69D0D61E
	Offset: 0x8B0
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function ready_to_activate(unitrigger_stub)
{
	self endon(#"death");
	self playsoundwithnotify("vox_maxi_robot_sync_0", "sync_done");
	self waittill(#"sync_done");
	wait(0.5);
	self playsoundwithnotify("vox_maxi_robot_await_0", "ready_to_use");
	self waittill(#"ready_to_use");
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &activate_fire_link);
}

/*
	Name: watch_for_triple_attack
	Namespace: zm_tomb_ee_main_step_3
	Checksum: 0x6D684F4
	Offset: 0x960
	Size: 0x1BA
	Parameters: 0
	Flags: Linked
*/
function watch_for_triple_attack()
{
	t_hole = getent("fire_link_damage", "targetname");
	while(!level flag::get("ee_mech_zombie_hole_opened"))
	{
		t_hole waittill(#"damage", damage, attacker, direction, point, type, tagname, modelname, partname, weapon);
		if(isdefined(weapon) && weapon.name == "beacon" && level flag::get("fire_link_enabled"))
		{
			playsoundatposition("zmb_squest_robot_floor_collapse", t_hole.origin);
			wait(3);
			m_floor = getent("easter_mechzombie_spawn", "targetname");
			m_floor delete();
			level flag::set("ee_mech_zombie_hole_opened");
			t_hole delete();
			return;
		}
	}
}

/*
	Name: mech_zombie_hole_valid
	Namespace: zm_tomb_ee_main_step_3
	Checksum: 0xD0FA915E
	Offset: 0xB28
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function mech_zombie_hole_valid(valid)
{
	t_hole = getent("fire_link_damage", "targetname");
	if(self istouching(t_hole))
	{
		return 1;
	}
	return valid;
}

/*
	Name: activate_fire_link
	Namespace: zm_tomb_ee_main_step_3
	Checksum: 0x4564865B
	Offset: 0xB90
	Size: 0x176
	Parameters: 0
	Flags: Linked
*/
function activate_fire_link()
{
	self endon(#"kill_trigger");
	while(true)
	{
		self waittill(#"trigger", player);
		self playsound("zmb_squest_robot_button");
		if(level flag::get("three_robot_round"))
		{
			level thread fire_link_cooldown(self);
			self playsound("zmb_squest_robot_button_activate");
			self playloopsound("zmb_squest_robot_button_timer", 0.5);
			level flag::wait_till_clear("fire_link_enabled");
			self stoploopsound(0.5);
			self playsound("zmb_squest_robot_button_deactivate");
		}
		else
		{
			self playsound("vox_maxi_robot_abort_0");
			self playsound("zmb_squest_robot_button_deactivate");
			wait(3);
		}
	}
}

/*
	Name: fire_link_cooldown
	Namespace: zm_tomb_ee_main_step_3
	Checksum: 0xD24681A6
	Offset: 0xD10
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function fire_link_cooldown(t_button)
{
	level notify(#"fire_link_cooldown");
	level endon(#"fire_link_cooldown");
	level flag::set("fire_link_enabled");
	if(isdefined(t_button))
	{
		t_button playsound("vox_maxi_robot_activated_0");
	}
	wait(35);
	if(isdefined(t_button))
	{
		t_button playsound("vox_maxi_robot_deactivated_0");
	}
	level flag::clear("fire_link_enabled");
}

