// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zm_trap_electric;

/*
	Name: __init__sytem__
	Namespace: zm_trap_electric
	Checksum: 0x7AD41E7F
	Offset: 0x170
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_trap_electric", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_trap_electric
	Checksum: 0x625B5C98
	Offset: 0x1B0
	Size: 0x10A
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	visionset_mgr::register_overlay_info_style_electrified("zm_trap_electric", 1, 15, 1.25);
	a_traps = struct::get_array("trap_electric", "targetname");
	foreach(trap in a_traps)
	{
		clientfield::register("world", trap.script_noteworthy, 1, 1, "int", &trap_fx_monitor, 0, 0);
	}
}

/*
	Name: trap_fx_monitor
	Namespace: zm_trap_electric
	Checksum: 0xD9DC0162
	Offset: 0x2C8
	Size: 0x172
	Parameters: 7
	Flags: Linked
*/
function trap_fx_monitor(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	exploder_name = "trap_electric_" + fieldname;
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
				point thread electric_trap_fx();
				continue;
			}
			point thread stop_trap_fx();
		}
	}
}

/*
	Name: electric_trap_fx
	Namespace: zm_trap_electric
	Checksum: 0x9C39991
	Offset: 0x448
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function electric_trap_fx()
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
		self.loopfx[i] = playfx(i, level._effect["zapper"], self.origin, forward, up, 0);
	}
}

/*
	Name: stop_trap_fx
	Namespace: zm_trap_electric
	Checksum: 0x9AD7086E
	Offset: 0x580
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

