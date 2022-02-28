// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;

#namespace zm_craftables;

/*
	Name: __init__sytem__
	Namespace: zm_craftables
	Checksum: 0xA9BE9630
	Offset: 0x148
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_craftables", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_craftables
	Checksum: 0x55691903
	Offset: 0x188
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.craftable_piece_count = 0;
	callback::on_finalize_initialization(&set_craftable_clientfield);
}

/*
	Name: set_craftable_clientfield
	Namespace: zm_craftables
	Checksum: 0xDE710676
	Offset: 0x1C8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function set_craftable_clientfield(localclientnum)
{
	if(!isdefined(level.zombie_craftables))
	{
		level.zombie_craftables = [];
	}
	set_piece_count(level.zombie_craftables.size + 1);
}

/*
	Name: init
	Namespace: zm_craftables
	Checksum: 0xE30558F1
	Offset: 0x218
	Size: 0x20
	Parameters: 0
	Flags: None
*/
function init()
{
	if(isdefined(level.init_craftables))
	{
		[[level.init_craftables]]();
	}
}

/*
	Name: add_zombie_craftable
	Namespace: zm_craftables
	Checksum: 0xC2BD7839
	Offset: 0x240
	Size: 0x86
	Parameters: 1
	Flags: Linked
*/
function add_zombie_craftable(craftable_name)
{
	if(!isdefined(level.zombie_include_craftables))
	{
		level.zombie_include_craftables = [];
	}
	if(isdefined(level.zombie_include_craftables) && !isdefined(level.zombie_include_craftables[craftable_name]))
	{
		return;
	}
	craftable_name = level.zombie_include_craftables[craftable_name];
	if(!isdefined(level.zombie_craftables))
	{
		level.zombie_craftables = [];
	}
	level.zombie_craftables[craftable_name] = craftable_name;
}

/*
	Name: set_clientfield_craftables_code_callbacks
	Namespace: zm_craftables
	Checksum: 0x9420DDF2
	Offset: 0x2D0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function set_clientfield_craftables_code_callbacks()
{
	wait(0.1);
	if(level.zombie_craftables.size > 0)
	{
		setupclientfieldcodecallbacks("toplayer", 1, "craftable");
	}
}

/*
	Name: include_zombie_craftable
	Namespace: zm_craftables
	Checksum: 0x89DCFC27
	Offset: 0x320
	Size: 0x36
	Parameters: 1
	Flags: Linked
*/
function include_zombie_craftable(craftable_name)
{
	if(!isdefined(level.zombie_include_craftables))
	{
		level.zombie_include_craftables = [];
	}
	level.zombie_include_craftables[craftable_name] = craftable_name;
}

/*
	Name: set_piece_count
	Namespace: zm_craftables
	Checksum: 0xF214E544
	Offset: 0x360
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function set_piece_count(n_count)
{
	bits = getminbitcountfornum(n_count);
	registerclientfield("toplayer", "craftable", 1, bits, "int", undefined, 0, 1);
}

