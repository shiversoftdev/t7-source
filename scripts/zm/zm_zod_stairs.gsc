// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_zod_poweronswitch;

#using_animtree("generic");

#namespace zm_zod_stairs;

/*
	Name: __init__sytem__
	Namespace: zm_zod_stairs
	Checksum: 0x40BB9F1F
	Offset: 0x340
	Size: 0x2C
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("zm_zod_stairs", undefined, &__main__, undefined);
}

/*
	Name: __main__
	Namespace: zm_zod_stairs
	Checksum: 0x6057B528
	Offset: 0x378
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level thread init_stairs();
}

/*
	Name: init_stairs
	Namespace: zm_zod_stairs
	Checksum: 0xC9FA6B54
	Offset: 0x3A0
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function init_stairs()
{
	if(!isdefined(level.a_o_stair))
	{
		level.a_o_stair = [];
		init_stair("slums", 11);
		init_stair("canal", 12);
		init_stair("theater", 13);
		init_stair("start", 14);
		init_stair("brothel", 16);
		init_stair("underground", 15);
	}
}

/*
	Name: init_stair
	Namespace: zm_zod_stairs
	Checksum: 0xEF2AA094
	Offset: 0x488
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function init_stair(str_areaname, n_power_index)
{
	if(!isdefined(level.a_o_stair[n_power_index]))
	{
		object = new cstair();
		[[ object ]]->__constructor();
		level.a_o_stair[n_power_index] = object;
		[[ level.a_o_stair[n_power_index] ]]->init_stair(str_areaname, n_power_index);
		[[ level.a_o_stair[n_power_index] ]]->start_stair();
	}
}

#namespace cstair;

/*
	Name: init_stair
	Namespace: cstair
	Checksum: 0x9CEBAFAF
	Offset: 0x518
	Size: 0x234
	Parameters: 2
	Flags: Linked
*/
function init_stair(str_areaname, n_power_index)
{
	self.m_n_state = 0;
	self.m_n_pause_between_steps = 0.1;
	self.m_str_areaname = str_areaname;
	self.m_a_e_steps = getentarray("stair_step", "targetname");
	self.m_a_e_blockers = getentarray("stair_blocker", "targetname");
	self.m_a_e_clip = getentarray("stair_clip", "targetname");
	self.var_f2f66550 = struct::get_array("stair_staircase", "targetname");
	self.var_39624e3b = struct::get_array("stair_gate", "targetname");
	self.m_a_e_steps = array::filter(self.m_a_e_steps, 0, &filter_areaname, str_areaname);
	self.m_a_e_blockers = array::filter(self.m_a_e_blockers, 0, &filter_areaname, str_areaname);
	self.m_a_e_clip = array::filter(self.m_a_e_clip, 0, &filter_areaname, str_areaname);
	self.var_f2f66550 = array::filter(self.var_f2f66550, 0, &filter_areaname, str_areaname);
	self.var_39624e3b = array::filter(self.var_39624e3b, 0, &filter_areaname, str_areaname);
	self.m_n_power_index = n_power_index;
	self.m_b_discovered = 0;
}

/*
	Name: start_stair
	Namespace: cstair
	Checksum: 0xE69F1BAA
	Offset: 0x758
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function start_stair()
{
	stair_move(0, 1);
	self thread stair_think();
}

/*
	Name: filter_areaname
	Namespace: cstair
	Checksum: 0xDFC8A256
	Offset: 0x798
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function filter_areaname(e_entity, str_areaname)
{
	if(!isdefined(e_entity.script_string) || e_entity.script_string != str_areaname)
	{
		return 0;
	}
	return 1;
}

/*
	Name: get_blocker
	Namespace: cstair
	Checksum: 0xC0DFD74F
	Offset: 0x7E8
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function get_blocker()
{
	return self.m_a_e_blockers[0];
}

/*
	Name: stair_think
	Namespace: cstair
	Checksum: 0x4CC52059
	Offset: 0x800
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function stair_think()
{
	stair_wait();
	stair_move(1, 0);
}

/*
	Name: stair_wait
	Namespace: cstair
	Checksum: 0x73F11971
	Offset: 0x838
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function stair_wait()
{
	level flag::wait_till("power_on" + self.m_n_power_index);
}

/*
	Name: stair_move
	Namespace: cstair
	Checksum: 0xF80D374F
	Offset: 0x870
	Size: 0x53C
	Parameters: 2
	Flags: Linked
*/
function stair_move(b_is_extending, b_is_instant)
{
	if(self.m_str_areaname != "underground" && self.m_str_areaname != "club" && b_is_extending && !b_is_instant)
	{
		self.var_f2f66550[0] scene::play("p7_fxanim_zm_zod_mechanical_stairs_bundle");
		foreach(var_7d71ed13, e_gate in self.var_39624e3b)
		{
			e_gate thread scene::play("p7_fxanim_zm_zod_gate_scissor_short_bundle");
		}
		self.m_n_state = 2;
		self.m_a_e_clip[0] move_blocker();
		self.m_a_e_clip[0] connectpaths();
		return;
	}
	if(b_is_instant)
	{
		n_step_rise_duration = 0.05;
		n_barricade_duration = 0.05;
	}
	else
	{
		n_step_rise_duration = 0.5;
		n_barricade_duration = 0.25;
	}
	if(b_is_extending)
	{
		self.m_n_state = 1;
	}
	else
	{
		self.m_n_state = 3;
	}
	if(!b_is_extending)
	{
		foreach(var_a8b601f9, e_blocker in self.m_a_e_blockers)
		{
			self thread element_move(e_blocker, !b_is_extending, 64, n_barricade_duration);
		}
	}
	foreach(var_b2c75ad8, e_step in self.m_a_e_steps)
	{
		if(b_is_extending && isdefined(e_step.script_noteworthy) && e_step.script_noteworthy == "swing_door" && isdefined(e_step.angles) && isdefined(e_step.script_float))
		{
			self thread function_15ee241e(e_step, e_step.angles, e_step.script_float, 0.5);
		}
		else
		{
			self thread element_move(e_step, b_is_extending, e_step.script_int, n_step_rise_duration);
		}
		if(isdefined(self.m_n_pause_between_steps))
		{
			wait(self.m_n_pause_between_steps);
		}
	}
	wait(n_step_rise_duration);
	if(b_is_extending)
	{
		foreach(var_d735d617, e_blocker in self.m_a_e_blockers)
		{
			self thread element_move(e_blocker, !b_is_extending, 64, n_barricade_duration);
		}
	}
	if(b_is_extending)
	{
		self.m_n_state = 2;
		self.m_a_e_clip[0] move_blocker();
		self.m_a_e_clip[0] connectpaths();
	}
	else
	{
		self.m_n_state = 0;
		self.m_a_e_clip[0] setvisibletoall();
		self.m_a_e_clip[0] disconnectpaths();
	}
	if(b_is_extending)
	{
		if(isdefined(self.m_a_e_steps[0].script_flag_set))
		{
			level flag::set(self.m_a_e_steps[0].script_flag_set);
		}
	}
}

/*
	Name: element_move
	Namespace: cstair
	Checksum: 0x1D4685A5
	Offset: 0xDB8
	Size: 0x94
	Parameters: 4
	Flags: Linked
*/
function element_move(e_mover, b_is_extending, n_step_rise_distance, n_duration)
{
	if(!b_is_extending)
	{
		n_step_rise_distance = n_step_rise_distance * -1;
	}
	v_offset = anglestoup((0, 0, 0)) * n_step_rise_distance;
	e_mover moveto(e_mover.origin + v_offset, n_duration);
}

/*
	Name: function_15ee241e
	Namespace: cstair
	Checksum: 0xDF28C6E0
	Offset: 0xE58
	Size: 0x4C
	Parameters: 4
	Flags: Linked
*/
function function_15ee241e(e_mover, v_angles, n_rotate, n_duration)
{
	e_mover rotateto(v_angles + (0, n_rotate, 0), n_duration);
}

/*
	Name: move_blocker
	Namespace: cstair
	Checksum: 0x51E71B8A
	Offset: 0xEB0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function move_blocker()
{
	self moveto(self.origin - vectorscale((0, 0, 1), 10000), 0.05);
	wait(0.05);
}

/*
	Name: __constructor
	Namespace: cstair
	Checksum: 0x99EC1590
	Offset: 0xF00
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
}

/*
	Name: __destructor
	Namespace: cstair
	Checksum: 0x99EC1590
	Offset: 0xF10
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __destructor()
{
}

#namespace zm_zod_stairs;

/*
	Name: cstair
	Namespace: zm_zod_stairs
	Checksum: 0x90830356
	Offset: 0xF20
	Size: 0x266
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function cstair()
{
	classes.cstair[0] = spawnstruct();
	classes.cstair[0].__vtable[1606033458] = &cstair::__destructor;
	classes.cstair[0].__vtable[-1690805083] = &cstair::__constructor;
	classes.cstair[0].__vtable[1690453081] = &cstair::move_blocker;
	classes.cstair[0].__vtable[367928350] = &cstair::function_15ee241e;
	classes.cstair[0].__vtable[-28191707] = &cstair::element_move;
	classes.cstair[0].__vtable[-979388272] = &cstair::stair_move;
	classes.cstair[0].__vtable[-673763820] = &cstair::stair_wait;
	classes.cstair[0].__vtable[1899600077] = &cstair::stair_think;
	classes.cstair[0].__vtable[-528427948] = &cstair::get_blocker;
	classes.cstair[0].__vtable[469498444] = &cstair::filter_areaname;
	classes.cstair[0].__vtable[311279545] = &cstair::start_stair;
	classes.cstair[0].__vtable[-398746331] = &cstair::init_stair;
}

