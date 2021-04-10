// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#using_animtree("generic");

#namespace zm_zod_bridges;

/*
	Name: __init__sytem__
	Namespace: zm_zod_bridges
	Checksum: 0xD1F51EE3
	Offset: 0x330
	Size: 0x2C
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("zm_zod_bridges", undefined, &__main__, undefined);
}

/*
	Name: __main__
	Namespace: zm_zod_bridges
	Checksum: 0x9B24A9A6
	Offset: 0x368
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level thread init_bridges();
}

/*
	Name: init_bridges
	Namespace: zm_zod_bridges
	Checksum: 0xEE322FE9
	Offset: 0x390
	Size: 0x94
	Parameters: 0
	Flags: None
*/
function init_bridges()
{
	if(!isdefined(level.beast_mode_targets))
	{
		level.beast_mode_targets = [];
	}
	if(!isdefined(level.a_o_bridge))
	{
		level.a_o_bridge = [];
		init_bridge("slums", 1);
		init_bridge("canal", 2);
		init_bridge("theater", 3);
	}
}

/*
	Name: init_bridge
	Namespace: zm_zod_bridges
	Checksum: 0x645BB9C5
	Offset: 0x430
	Size: 0x50
	Parameters: 2
	Flags: None
*/
function init_bridge(str_areaname, n_index)
{
	object = new cbridge();
	[[ object ]]->__constructor();
	level.a_o_bridge[n_index] = object;
	[[ level.a_o_bridge[n_index] ]]->init_bridge(str_areaname);
}

#namespace cbridge;

/*
	Name: init_bridge
	Namespace: cbridge
	Checksum: 0x5FFBAC61
	Offset: 0x488
	Size: 0x3C4
	Parameters: 1
	Flags: None
*/
function init_bridge(str_areaname)
{
	self.m_str_areaname = str_areaname;
	m_n_state = 0;
	m_n_pause_between_steps = 0.1;
	door_name = str_areaname + "_bridge_door";
	m_door_array = getentarray(door_name, "script_noteworthy");
	self.m_a_e_blockers = getentarray("bridge_blocker", "targetname");
	a_e_clip_blockers = getentarray("bridge_clip_blocker", "targetname");
	a_e_walkway = getentarray("bridge_walkway", "targetname");
	a_t_pull_trigger = getentarray("bridge_pull_trigger", "targetname");
	a_e_pull_target = getentarray("bridge_pull_target", "targetname");
	self.m_a_e_blockers = array::filter(self.m_a_e_blockers, 0, &filter_areaname, str_areaname);
	a_e_clip_blockers = array::filter(a_e_clip_blockers, 0, &filter_areaname, str_areaname);
	self.m_e_clip_blocker = a_e_clip_blockers[0];
	a_e_walkway = array::filter(a_e_walkway, 0, &filter_areaname, str_areaname);
	self.m_e_walkway = a_e_walkway[0];
	a_e_pull_target = array::filter(a_e_pull_target, 0, &filter_areaname, str_areaname);
	self.m_e_pull_target = a_e_pull_target[0];
	self.m_b_discovered = 0;
	self.m_e_walkway setinvisibletoall();
	foreach(var_cf345ee5, e_blocker in self.m_a_e_blockers)
	{
		e_blocker useanimtree($generic);
	}
	self.m_e_walkway useanimtree($generic);
	self.m_e_pull_target setgrapplabletype(3);
	array::add(level.beast_mode_targets, self.m_e_pull_target, 0);
	self.m_e_pull_target clientfield::set("bminteract", 3);
	self thread bridge_connect(m_door_array[0], m_door_array[1]);
}

/*
	Name: filter_areaname
	Namespace: cbridge
	Checksum: 0x5A78BAE8
	Offset: 0x858
	Size: 0x48
	Parameters: 2
	Flags: None
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
	Name: bridge_connect
	Namespace: cbridge
	Checksum: 0xCEED0C4D
	Offset: 0x8A8
	Size: 0x1CC
	Parameters: 2
	Flags: None
*/
function bridge_connect(t_trigger_a, t_trigger_b)
{
	util::waittill_any_ents_two(t_trigger_a, "trigger", t_trigger_b, "trigger");
	foreach(var_e3bb182, e_blocker in self.m_a_e_blockers)
	{
		e_blocker setanim(%generic::p7_fxanim_zm_zod_gate_scissor_short_open_anim);
	}
	self.m_e_walkway setanim(%generic::p7_fxanim_zm_zod_beast_bridge_open_anim);
	self.m_e_walkway setvisibletoall();
	self.m_e_pull_target setinvisibletoall();
	self.m_e_pull_target clientfield::set("bminteract", 0);
	self.m_e_pull_target setgrapplabletype(0);
	level.beast_mode_targets = array::exclude(level.beast_mode_targets, self.m_e_pull_target);
	wait(1);
	self.m_e_clip_blocker move_blocker();
	self.m_e_clip_blocker connectpaths();
	unlock_zones();
}

/*
	Name: unlock_zones
	Namespace: cbridge
	Checksum: 0xB3E1E759
	Offset: 0xA80
	Size: 0xAC
	Parameters: 0
	Flags: None
*/
function unlock_zones()
{
	str_zonename = self.m_str_areaname + "_district_zone_high";
	if(!zm_zonemgr::zone_is_enabled(str_zonename))
	{
		zm_zonemgr::zone_init(str_zonename);
		zm_zonemgr::enable_zone(str_zonename);
	}
	zm_zonemgr::add_adjacent_zone(self.m_str_areaname + "_district_zone_B", str_zonename, "enter_" + self.m_str_areaname + "_district_high_from_B");
}

/*
	Name: move_blocker
	Namespace: cbridge
	Checksum: 0xE2E1D080
	Offset: 0xB38
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function move_blocker()
{
	self moveto(self.origin - vectorscale((0, 0, 1), 10000), 0.05);
	wait(0.05);
}

/*
	Name: __constructor
	Namespace: cbridge
	Checksum: 0x99EC1590
	Offset: 0xB88
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function __constructor()
{
}

/*
	Name: __destructor
	Namespace: cbridge
	Checksum: 0x99EC1590
	Offset: 0xB98
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function __destructor()
{
}

#namespace zm_zod_bridges;

/*
	Name: cbridge
	Namespace: zm_zod_bridges
	Checksum: 0xEC7B2580
	Offset: 0xBA8
	Size: 0x176
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function cbridge()
{
	classes.cbridge[0] = spawnstruct();
	classes.cbridge[0].__vtable[1606033458] = &cbridge::__destructor;
	classes.cbridge[0].__vtable[-1690805083] = &cbridge::__constructor;
	classes.cbridge[0].__vtable[1690453081] = &cbridge::move_blocker;
	classes.cbridge[0].__vtable[900951893] = &cbridge::unlock_zones;
	classes.cbridge[0].__vtable[644748357] = &cbridge::bridge_connect;
	classes.cbridge[0].__vtable[469498444] = &cbridge::filter_areaname;
	classes.cbridge[0].__vtable[1775345993] = &cbridge::init_bridge;
}

