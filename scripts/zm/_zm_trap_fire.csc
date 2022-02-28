// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zm_trap_fire;

/*
	Name: __init__sytem__
	Namespace: zm_trap_fire
	Checksum: 0x24BD21B8
	Offset: 0x160
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_trap_fire", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_trap_fire
	Checksum: 0xFFDB07D7
	Offset: 0x1A0
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	a_traps = struct::get_array("trap_fire", "targetname");
	foreach(trap in a_traps)
	{
		clientfield::register("world", trap.script_noteworthy, 21000, 1, "int", &trap_fx_monitor, 0, 0);
	}
}

/*
	Name: trap_fx_monitor
	Namespace: zm_trap_fire
	Checksum: 0x4F8771E4
	Offset: 0x290
	Size: 0x172
	Parameters: 7
	Flags: Linked
*/
function trap_fx_monitor(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	exploder_name = "trap_fire_" + fieldname;
	if(newval)
	{
		exploder::exploder(exploder_name);
	}
	else
	{
		exploder::stop_exploder(exploder_name);
	}
	fire_points = struct::get_array(fieldname, "targetname");
	foreach(point in fire_points)
	{
		if(!isdefined(point.script_noteworthy))
		{
			if(newval)
			{
				point thread fire_trap_fx();
				continue;
			}
			point thread stop_trap_fx();
		}
	}
}

/*
	Name: fire_trap_fx
	Namespace: zm_trap_fire
	Checksum: 0xAF8398B7
	Offset: 0x410
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function fire_trap_fx()
{
	ang = self.angles;
	forward = anglestoforward(ang);
	up = anglestoup(ang);
	if(isdefined(self.loopfx) && self.loopfx.size)
	{
		stop_trap_fx();
	}
	if(!isdefined(self.loopfx))
	{
		self.loopfx = [];
	}
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		self.loopfx[i] = playfx(i, level._effect["fire_trap"], self.origin, forward, up, 0);
	}
}

/*
	Name: stop_trap_fx
	Namespace: zm_trap_fire
	Checksum: 0x601C4C7F
	Offset: 0x548
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function stop_trap_fx()
{
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(self.loopfx[i]))
		{
			stopfx(i, self.loopfx[i]);
		}
	}
	self.loopfx = [];
}

