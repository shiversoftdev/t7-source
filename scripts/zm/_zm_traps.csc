// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zm_traps;

/*
	Name: __init__sytem__
	Namespace: zm_traps
	Checksum: 0x2088E50D
	Offset: 0xE8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_traps", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_traps
	Checksum: 0x1C521A67
	Offset: 0x128
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	s_traps_array = struct::get_array("zm_traps", "targetname");
	a_registered_traps = [];
	foreach(trap in s_traps_array)
	{
		if(isdefined(trap.script_noteworthy))
		{
			if(!trap is_trap_registered(a_registered_traps))
			{
				a_registered_traps[trap.script_noteworthy] = 1;
			}
		}
	}
}

/*
	Name: is_trap_registered
	Namespace: zm_traps
	Checksum: 0x883CAE0
	Offset: 0x228
	Size: 0x1A
	Parameters: 1
	Flags: Linked
*/
function is_trap_registered(a_registered_traps)
{
	return isdefined(a_registered_traps[self.script_noteworthy]);
}

