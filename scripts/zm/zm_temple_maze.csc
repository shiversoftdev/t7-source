// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace zm_temple_maze;

/*
	Name: maze_trap_move_wall
	Namespace: zm_temple_maze
	Checksum: 0x3D467A86
	Offset: 0xD0
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function maze_trap_move_wall(localclientnum, active)
{
	if(!isdefined(self.wall))
	{
		self set_maze_trap_wall(localclientnum);
	}
	wall = self.wall;
	if(isdefined(wall))
	{
		wall thread maze_wall_init(localclientnum);
		wall thread move_maze_wall(active);
	}
}

/*
	Name: maze_wall_init
	Namespace: zm_temple_maze
	Checksum: 0xA8884E9F
	Offset: 0x168
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function maze_wall_init(localclientnum)
{
	if(!isdefined(self.init) || !self.init)
	{
		self init_maze_mover(-128, 0.25, 1, 1, "evt_maze_wall_down", "evt_maze_wall_up");
		self.script_fxid = level._effect["maze_wall_impact"];
		self.var_f88b106c = level._effect["maze_wall_raise"];
		self.fx_active_offset = vectorscale((0, 0, -1), 60);
		self.var_2f5c5654 = vectorscale((0, 0, 1), 75);
		self.init = 1;
		self.client_num = localclientnum;
	}
}

/*
	Name: init_maze_mover
	Namespace: zm_temple_maze
	Checksum: 0xB9663D49
	Offset: 0x248
	Size: 0xD8
	Parameters: 6
	Flags: Linked
*/
function init_maze_mover(movedist, moveuptime, movedowntime, blockspaths, moveupsound, movedownsound)
{
	self.isactive = 0;
	self.activecount = 0;
	self.ismoving = 0;
	self.movedist = movedist;
	self.activeheight = self.origin[2] + movedist;
	self.moveuptime = moveuptime;
	self.movedowntime = movedowntime;
	self.pathblocker = 0;
	self.alwaysactive = 0;
	self.moveupsound = moveupsound;
	self.movedownsound = movedownsound;
	self.startangles = self.angles;
}

/*
	Name: move_maze_wall
	Namespace: zm_temple_maze
	Checksum: 0xE8B5DA90
	Offset: 0x328
	Size: 0x194
	Parameters: 1
	Flags: Linked
*/
function move_maze_wall(active)
{
	goalpos = (self.origin[0], self.origin[1], self.activeheight);
	if(!active)
	{
		goalpos = (goalpos[0], goalpos[1], goalpos[2] - self.movedist);
	}
	movetime = self.moveuptime;
	if(!active)
	{
		movetime = self.movedowntime;
	}
	if(self.ismoving)
	{
		currentz = self.origin[2];
		goalz = goalpos[2];
		ratio = (abs(goalz - currentz)) / abs(self.movedist);
		movetime = movetime * ratio;
	}
	self notify(#"stop_maze_mover", !active && isdefined(self.movedownsound), active && isdefined(self.moveupsound));
	self.isactive = active;
	self thread _maze_mover_move(goalpos, movetime);
}

/*
	Name: set_maze_trap_wall
	Namespace: zm_temple_maze
	Checksum: 0xA11B60E2
	Offset: 0x4C8
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function set_maze_trap_wall(localclientnum)
{
	walls = getentarray(localclientnum, "maze_trap_wall", "targetname");
	bestwall = undefined;
	bestdist = undefined;
	for(i = 0; i < walls.size; i++)
	{
		wall = walls[i];
		if(isdefined(wall.assigned))
		{
			continue;
		}
		dist = distancesquared(self.origin, wall.origin);
		if(!isdefined(bestdist) || dist < bestdist)
		{
			bestdist = dist;
			bestwall = wall;
		}
	}
	self.wall = bestwall;
	if(isdefined(self.wall))
	{
		self.wall.assigned = 1;
	}
}

/*
	Name: _maze_mover_move
	Namespace: zm_temple_maze
	Checksum: 0x785543EC
	Offset: 0x618
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function _maze_mover_move(goal, time)
{
	self endon(#"stop_maze_mover");
	self.ismoving = 1;
	if(time == 0)
	{
		time = 0.01;
	}
	if(self.isactive === 0)
	{
		_maze_mover_play_fx(self.var_f88b106c, self.var_2f5c5654);
	}
	self moveto(goal, time);
	self waittill(#"movedone");
	self.ismoving = 0;
	if(self.isactive === 1)
	{
		_maze_mover_play_fx(self.script_fxid, self.fx_active_offset);
	}
}

/*
	Name: _maze_mover_play_fx
	Namespace: zm_temple_maze
	Checksum: 0xA5A6B046
	Offset: 0x700
	Size: 0x94
	Parameters: 2
	Flags: Linked
*/
function _maze_mover_play_fx(fx_name, offset)
{
	if(isdefined(fx_name))
	{
		vfwd = anglestoforward(self.angles);
		org = self.origin;
		if(isdefined(offset))
		{
			org = org + offset;
		}
		playfx(self.client_num, fx_name, org, vfwd, (0, 0, 1));
	}
}

