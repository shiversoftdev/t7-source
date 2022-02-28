// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace wasp;

/*
	Name: __init__sytem__
	Namespace: wasp
	Checksum: 0x8EBB590E
	Offset: 0x1D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("wasp", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: wasp
	Checksum: 0x6939802F
	Offset: 0x218
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("vehicle", "rocket_wasp_hijacked", 1, 1, "int", &handle_lod_display_for_driver, 0, 0);
	level.sentinelbundle = struct::get_script_bundle("killstreak", "killstreak_sentinel");
	if(isdefined(level.sentinelbundle))
	{
		vehicle::add_vehicletype_callback(level.sentinelbundle.ksvehicle, &spawned);
	}
}

/*
	Name: spawned
	Namespace: wasp
	Checksum: 0x9BB269C3
	Offset: 0x2D8
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function spawned(localclientnum)
{
	self.killstreakbundle = level.sentinelbundle;
}

/*
	Name: handle_lod_display_for_driver
	Namespace: wasp
	Checksum: 0x7DA71F55
	Offset: 0x300
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function handle_lod_display_for_driver(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(isdefined(self))
	{
		if(self islocalclientdriver(localclientnum))
		{
			self sethighdetail(1);
			wait(0.05);
			self vehicle::lights_off(localclientnum);
		}
	}
}

