// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace objpoints;

/*
	Name: __init__sytem__
	Namespace: objpoints
	Checksum: 0xD15E79DA
	Offset: 0xF8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("objpoints", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: objpoints
	Checksum: 0x7831EA7C
	Offset: 0x138
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.objpointnames = [];
	level.objpoints = [];
	if(isdefined(level.splitscreen) && level.splitscreen)
	{
		level.objpointsize = 15;
	}
	else
	{
		level.objpointsize = 8;
	}
	level.objpoint_alpha_default = 1;
	level.objpointscale = 1;
}

/*
	Name: create
	Namespace: objpoints
	Checksum: 0x2FE5353D
	Offset: 0x1B0
	Size: 0x2BA
	Parameters: 6
	Flags: Linked
*/
function create(name, origin, team, shader, alpha, scale)
{
	/#
		assert(isdefined(level.teams[team]) || team == "");
	#/
	objpoint = get_by_name(name);
	if(isdefined(objpoint))
	{
		delete(objpoint);
	}
	if(!isdefined(shader))
	{
		shader = "objpoint_default";
	}
	if(!isdefined(scale))
	{
		scale = 1;
	}
	if(team != "all")
	{
		objpoint = newteamhudelem(team);
	}
	else
	{
		objpoint = newhudelem();
	}
	objpoint.name = name;
	objpoint.x = origin[0];
	objpoint.y = origin[1];
	objpoint.z = origin[2];
	objpoint.team = team;
	objpoint.isflashing = 0;
	objpoint.isshown = 1;
	objpoint.fadewhentargeted = 1;
	objpoint.archived = 0;
	objpoint setshader(shader, level.objpointsize, level.objpointsize);
	objpoint setwaypoint(1);
	if(isdefined(alpha))
	{
		objpoint.alpha = alpha;
	}
	else
	{
		objpoint.alpha = level.objpoint_alpha_default;
	}
	objpoint.basealpha = objpoint.alpha;
	objpoint.index = level.objpointnames.size;
	level.objpoints[name] = objpoint;
	level.objpointnames[level.objpointnames.size] = name;
	return objpoint;
}

/*
	Name: delete
	Namespace: objpoints
	Checksum: 0xB116F0AD
	Offset: 0x478
	Size: 0x1A4
	Parameters: 1
	Flags: Linked
*/
function delete(oldobjpoint)
{
	/#
		assert(level.objpoints.size == level.objpointnames.size);
	#/
	if(level.objpoints.size == 1)
	{
		/#
			assert(level.objpointnames[0] == oldobjpoint.name);
		#/
		/#
			assert(isdefined(level.objpoints[oldobjpoint.name]));
		#/
		level.objpoints = [];
		level.objpointnames = [];
		oldobjpoint destroy();
		return;
	}
	newindex = oldobjpoint.index;
	oldindex = level.objpointnames.size - 1;
	objpoint = get_by_index(oldindex);
	level.objpointnames[newindex] = objpoint.name;
	objpoint.index = newindex;
	level.objpointnames[oldindex] = undefined;
	level.objpoints[oldobjpoint.name] = undefined;
	oldobjpoint destroy();
}

/*
	Name: update_origin
	Namespace: objpoints
	Checksum: 0x6EE1AE52
	Offset: 0x628
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function update_origin(origin)
{
	if(self.x != origin[0])
	{
		self.x = origin[0];
	}
	if(self.y != origin[1])
	{
		self.y = origin[1];
	}
	if(self.z != origin[2])
	{
		self.z = origin[2];
	}
}

/*
	Name: set_origin_by_name
	Namespace: objpoints
	Checksum: 0x44DD6A72
	Offset: 0x6B0
	Size: 0x54
	Parameters: 2
	Flags: None
*/
function set_origin_by_name(name, origin)
{
	objpoint = get_by_name(name);
	objpoint update_origin(origin);
}

/*
	Name: get_by_name
	Namespace: objpoints
	Checksum: 0x67D97810
	Offset: 0x710
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function get_by_name(name)
{
	if(isdefined(level.objpoints[name]))
	{
		return level.objpoints[name];
	}
	return undefined;
}

/*
	Name: get_by_index
	Namespace: objpoints
	Checksum: 0xF9C082C5
	Offset: 0x750
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function get_by_index(index)
{
	if(isdefined(level.objpointnames[index]))
	{
		return level.objpoints[level.objpointnames[index]];
	}
	return undefined;
}

/*
	Name: start_flashing
	Namespace: objpoints
	Checksum: 0x8A0FE3D7
	Offset: 0x798
	Size: 0xB8
	Parameters: 0
	Flags: None
*/
function start_flashing()
{
	self endon(#"stop_flashing_thread");
	if(self.isflashing)
	{
		return;
	}
	self.isflashing = 1;
	while(self.isflashing)
	{
		self fadeovertime(0.75);
		self.alpha = 0.35 * self.basealpha;
		wait(0.75);
		self fadeovertime(0.75);
		self.alpha = self.basealpha;
		wait(0.75);
	}
	self.alpha = self.basealpha;
}

/*
	Name: stop_flashing
	Namespace: objpoints
	Checksum: 0xFF3D7255
	Offset: 0x858
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function stop_flashing()
{
	if(!self.isflashing)
	{
		return;
	}
	self.isflashing = 0;
}

