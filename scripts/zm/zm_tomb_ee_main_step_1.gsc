// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
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
#using scripts\zm\zm_tomb_craftables;
#using scripts\zm\zm_tomb_ee_main;
#using scripts\zm\zm_tomb_utility;
#using scripts\zm\zm_tomb_vo;

#namespace zm_tomb_ee_main_step_1;

/*
	Name: init
	Namespace: zm_tomb_ee_main_step_1
	Checksum: 0x9491BD93
	Offset: 0x280
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function init()
{
	zm_sidequests::declare_sidequest_stage("little_girl_lost", "step_1", &init_stage, &stage_logic, &exit_stage);
}

/*
	Name: init_stage
	Namespace: zm_tomb_ee_main_step_1
	Checksum: 0x7572F9A6
	Offset: 0x2E0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function init_stage()
{
	level._cur_stage_name = "step_1";
}

/*
	Name: stage_logic
	Namespace: zm_tomb_ee_main_step_1
	Checksum: 0x392795D
	Offset: 0x300
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function stage_logic()
{
	/#
		iprintln(level._cur_stage_name + "");
	#/
	level flag::wait_till("ee_all_staffs_upgraded");
	util::wait_network_frame();
	zm_sidequests::stage_completed("little_girl_lost", level._cur_stage_name);
}

/*
	Name: exit_stage
	Namespace: zm_tomb_ee_main_step_1
	Checksum: 0x342996AA
	Offset: 0x388
	Size: 0x1A
	Parameters: 1
	Flags: Linked
*/
function exit_stage(success)
{
	level notify(#"hash_e6967d42");
}

