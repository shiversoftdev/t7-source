// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\system_shared;

#namespace as_debug;

/*
	Name: __init__sytem__
	Namespace: as_debug
	Checksum: 0x59872824
	Offset: 0xC0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("", &__init__, undefined, undefined);
	#/
}

/*
	Name: __init__
	Namespace: as_debug
	Checksum: 0xC334B472
	Offset: 0x100
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		level thread debugdvars();
	#/
}

/*
	Name: debugdvars
	Namespace: as_debug
	Checksum: 0x8ED8704A
	Offset: 0x128
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function debugdvars()
{
	/#
		while(true)
		{
			if(getdvarint("", 0))
			{
				delete_all_ai_corpses();
			}
			wait(0.05);
		}
	#/
}

/*
	Name: isdebugon
	Namespace: as_debug
	Checksum: 0x24117F0F
	Offset: 0x180
	Size: 0x4A
	Parameters: 0
	Flags: Linked
*/
function isdebugon()
{
	/#
		return getdvarint("") == 1 || (isdefined(anim.debugent) && anim.debugent == self);
	#/
}

/*
	Name: drawdebuglineinternal
	Namespace: as_debug
	Checksum: 0xDCCEF656
	Offset: 0x1D8
	Size: 0x76
	Parameters: 4
	Flags: Linked
*/
function drawdebuglineinternal(frompoint, topoint, color, durationframes)
{
	/#
		for(i = 0; i < durationframes; i++)
		{
			line(frompoint, topoint, color);
			wait(0.05);
		}
	#/
}

/*
	Name: drawdebugline
	Namespace: as_debug
	Checksum: 0x1D597F48
	Offset: 0x258
	Size: 0x64
	Parameters: 4
	Flags: None
*/
function drawdebugline(frompoint, topoint, color, durationframes)
{
	/#
		if(isdebugon())
		{
			thread drawdebuglineinternal(frompoint, topoint, color, durationframes);
		}
	#/
}

/*
	Name: debugline
	Namespace: as_debug
	Checksum: 0x5D0BA0D
	Offset: 0x2C8
	Size: 0x7E
	Parameters: 4
	Flags: Linked
*/
function debugline(frompoint, topoint, color, durationframes)
{
	/#
		for(i = 0; i < (durationframes * 20); i++)
		{
			line(frompoint, topoint, color);
			wait(0.05);
		}
	#/
}

/*
	Name: drawdebugcross
	Namespace: as_debug
	Checksum: 0x37CF8633
	Offset: 0x350
	Size: 0x154
	Parameters: 4
	Flags: None
*/
function drawdebugcross(atpoint, radius, color, durationframes)
{
	/#
		atpoint_high = atpoint + (0, 0, radius);
		atpoint_low = atpoint + (0, 0, -1 * radius);
		atpoint_left = atpoint + (0, radius, 0);
		atpoint_right = atpoint + (0, -1 * radius, 0);
		atpoint_forward = atpoint + (radius, 0, 0);
		atpoint_back = atpoint + (-1 * radius, 0, 0);
		thread debugline(atpoint_high, atpoint_low, color, durationframes);
		thread debugline(atpoint_left, atpoint_right, color, durationframes);
		thread debugline(atpoint_forward, atpoint_back, color, durationframes);
	#/
}

/*
	Name: updatedebuginfo
	Namespace: as_debug
	Checksum: 0x3C9F817F
	Offset: 0x4B0
	Size: 0x98
	Parameters: 0
	Flags: None
*/
function updatedebuginfo()
{
	/#
		self endon(#"death");
		self.debuginfo = spawnstruct();
		self.debuginfo.enabled = getdvarint("") > 0;
		debugclearstate();
		while(true)
		{
			wait(0.05);
			updatedebuginfointernal();
			wait(0.05);
		}
	#/
}

/*
	Name: updatedebuginfointernal
	Namespace: as_debug
	Checksum: 0x32300C78
	Offset: 0x550
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function updatedebuginfointernal()
{
	/#
		if(isdefined(anim.debugent) && anim.debugent == self)
		{
			doinfo = 1;
		}
		else
		{
			doinfo = getdvarint("") > 0;
			if(doinfo)
			{
				ai_entnum = getdvarint("");
				if(ai_entnum > -1 && ai_entnum != self getentitynumber())
				{
					doinfo = 0;
				}
			}
			if(!self.debuginfo.enabled && doinfo)
			{
				self.debuginfo.shouldclearonanimscriptchange = 1;
			}
			self.debuginfo.enabled = doinfo;
		}
	#/
}

/*
	Name: drawdebugenttext
	Namespace: as_debug
	Checksum: 0x5BE148D
	Offset: 0x660
	Size: 0x144
	Parameters: 4
	Flags: None
*/
function drawdebugenttext(text, ent, color, channel)
{
	/#
		/#
			assert(isdefined(ent));
		#/
		if(!getdvarint(""))
		{
			if(!isdefined(ent.debuganimscripttime) || gettime() > ent.debuganimscripttime)
			{
				ent.debuganimscriptlevel = 0;
				ent.debuganimscripttime = gettime();
			}
			indentlevel = vectorscale(vectorscale((0, 0, -1), 10), ent.debuganimscriptlevel);
			print3d((self.origin + vectorscale((0, 0, 1), 70)) + indentlevel, text, color);
			ent.debuganimscriptlevel++;
		}
		else
		{
			recordenttext(text, ent, color, channel);
		}
	#/
}

/*
	Name: debugpushstate
	Namespace: as_debug
	Checksum: 0x16828103
	Offset: 0x7B0
	Size: 0x1A2
	Parameters: 2
	Flags: None
*/
function debugpushstate(statename, extrainfo)
{
	/#
		if(!getdvarint(""))
		{
			return;
		}
		ai_entnum = getdvarint("");
		if(ai_entnum > -1 && ai_entnum != self getentitynumber())
		{
			return;
		}
		/#
			assert(isdefined(self.debuginfo.states));
		#/
		/#
			assert(isdefined(statename));
		#/
		state = spawnstruct();
		state.statename = statename;
		state.statelevel = self.debuginfo.statelevel;
		state.statetime = gettime();
		state.statevalid = 1;
		self.debuginfo.statelevel++;
		if(isdefined(extrainfo))
		{
			state.extrainfo = extrainfo + "";
		}
		self.debuginfo.states[self.debuginfo.states.size] = state;
	#/
}

/*
	Name: debugaddstateinfo
	Namespace: as_debug
	Checksum: 0xA3CBF9FF
	Offset: 0x960
	Size: 0x2F8
	Parameters: 2
	Flags: None
*/
function debugaddstateinfo(statename, extrainfo)
{
	/#
		if(!getdvarint(""))
		{
			return;
		}
		ai_entnum = getdvarint("");
		if(ai_entnum > -1 && ai_entnum != self getentitynumber())
		{
			return;
		}
		/#
			assert(isdefined(self.debuginfo.states));
		#/
		if(isdefined(statename))
		{
			for(i = self.debuginfo.states.size - 1; i >= 0; i--)
			{
				/#
					assert(isdefined(self.debuginfo.states[i]));
				#/
				if(self.debuginfo.states[i].statename == statename)
				{
					if(!isdefined(self.debuginfo.states[i].extrainfo))
					{
						self.debuginfo.states[i].extrainfo = "";
					}
					self.debuginfo.states[i].extrainfo = self.debuginfo.states[i].extrainfo + (extrainfo + "");
					break;
				}
			}
		}
		else if(self.debuginfo.states.size > 0)
		{
			lastindex = self.debuginfo.states.size - 1;
			/#
				assert(isdefined(self.debuginfo.states[lastindex]));
			#/
			if(!isdefined(self.debuginfo.states[lastindex].extrainfo))
			{
				self.debuginfo.states[lastindex].extrainfo = "";
			}
			self.debuginfo.states[lastindex].extrainfo = self.debuginfo.states[lastindex].extrainfo + (extrainfo + "");
		}
	#/
}

/*
	Name: debugpopstate
	Namespace: as_debug
	Checksum: 0x88CAA3AA
	Offset: 0xC60
	Size: 0x352
	Parameters: 2
	Flags: None
*/
function debugpopstate(statename, exitreason)
{
	/#
		if(!getdvarint("") || self.debuginfo.states.size <= 0)
		{
			return;
		}
		ai_entnum = getdvarint("");
		if(!isdefined(self) || !isalive(self))
		{
			return;
		}
		if(ai_entnum > -1 && ai_entnum != self getentitynumber())
		{
			return;
		}
		/#
			assert(isdefined(self.debuginfo.states));
		#/
		if(isdefined(statename))
		{
			for(i = 0; i < self.debuginfo.states.size; i++)
			{
				if(self.debuginfo.states[i].statename == statename && self.debuginfo.states[i].statevalid)
				{
					self.debuginfo.states[i].statevalid = 0;
					self.debuginfo.states[i].exitreason = exitreason;
					self.debuginfo.statelevel = self.debuginfo.states[i].statelevel;
					for(j = i + 1; j < self.debuginfo.states.size && self.debuginfo.states[j].statelevel > self.debuginfo.states[i].statelevel; j++)
					{
						self.debuginfo.states[j].statevalid = 0;
					}
					break;
				}
			}
		}
		else
		{
			for(i = self.debuginfo.states.size - 1; i >= 0; i--)
			{
				if(self.debuginfo.states[i].statevalid)
				{
					self.debuginfo.states[i].statevalid = 0;
					self.debuginfo.states[i].exitreason = exitreason;
					self.debuginfo.statelevel--;
					break;
				}
			}
		}
	#/
}

/*
	Name: debugclearstate
	Namespace: as_debug
	Checksum: 0xC670A3B3
	Offset: 0xFC0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function debugclearstate()
{
	/#
		self.debuginfo.states = [];
		self.debuginfo.statelevel = 0;
		self.debuginfo.shouldclearonanimscriptchange = 0;
	#/
}

/*
	Name: debugshouldclearstate
	Namespace: as_debug
	Checksum: 0x7D00FEA8
	Offset: 0x1010
	Size: 0x42
	Parameters: 0
	Flags: None
*/
function debugshouldclearstate()
{
	/#
		if(isdefined(self.debuginfo) && isdefined(self.debuginfo.shouldclearonanimscriptchange) && self.debuginfo.shouldclearonanimscriptchange)
		{
			return true;
		}
		return false;
	#/
}

/*
	Name: debugcleanstatestack
	Namespace: as_debug
	Checksum: 0x2E69DCA5
	Offset: 0x1060
	Size: 0xA8
	Parameters: 0
	Flags: None
*/
function debugcleanstatestack()
{
	/#
		newarray = [];
		for(i = 0; i < self.debuginfo.states.size; i++)
		{
			if(self.debuginfo.states[i].statevalid)
			{
				newarray[newarray.size] = self.debuginfo.states[i];
			}
		}
		self.debuginfo.states = newarray;
	#/
}

/*
	Name: indent
	Namespace: as_debug
	Checksum: 0xCFFEBBBD
	Offset: 0x1110
	Size: 0x64
	Parameters: 1
	Flags: None
*/
function indent(depth)
{
	/#
		indent = "";
		for(i = 0; i < depth; i++)
		{
			indent = indent + "";
		}
		return indent;
	#/
}

/*
	Name: debugdrawweightedpoints
	Namespace: as_debug
	Checksum: 0xB7386487
	Offset: 0x1180
	Size: 0x106
	Parameters: 3
	Flags: None
*/
function debugdrawweightedpoints(entity, points, weights)
{
	/#
		lowestvalue = 0;
		highestvalue = 0;
		for(index = 0; index < points.size; index++)
		{
			if(weights[index] < lowestvalue)
			{
				lowestvalue = weights[index];
			}
			if(weights[index] > highestvalue)
			{
				highestvalue = weights[index];
			}
		}
		for(index = 0; index < points.size; index++)
		{
			debugdrawweightedpoint(entity, points[index], weights[index], lowestvalue, highestvalue);
		}
	#/
}

/*
	Name: debugdrawweightedpoint
	Namespace: as_debug
	Checksum: 0xCA208AE4
	Offset: 0x1290
	Size: 0x174
	Parameters: 5
	Flags: Linked
*/
function debugdrawweightedpoint(entity, point, weight, lowestvalue, highestvalue)
{
	/#
		deltavalue = highestvalue - lowestvalue;
		halfdeltavalue = deltavalue / 2;
		midvalue = lowestvalue + (deltavalue / 2);
		if(halfdeltavalue == 0)
		{
			halfdeltavalue = 1;
		}
		if(weight <= midvalue)
		{
			redcolor = 1 - (abs((weight - lowestvalue) / halfdeltavalue));
			recordcircle(point, 2, (redcolor, 0, 0), "", entity);
		}
		else
		{
			greencolor = 1 - (abs((highestvalue - weight) / halfdeltavalue));
			recordcircle(point, 2, (0, greencolor, 0), "", entity);
		}
	#/
}

/*
	Name: delete_all_ai_corpses
	Namespace: as_debug
	Checksum: 0x99621017
	Offset: 0x1410
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function delete_all_ai_corpses()
{
	/#
		setdvar("", 0);
		corpses = getcorpsearray();
		foreach(corpse in corpses)
		{
			if(isactorcorpse(corpse))
			{
				corpse delete();
			}
		}
	#/
}

