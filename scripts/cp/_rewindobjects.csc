// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\system_shared;

#namespace rewindobjects;

/*
	Name: __init__sytem__
	Namespace: rewindobjects
	Checksum: 0x44424142
	Offset: 0xD8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("rewindobjects", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: rewindobjects
	Checksum: 0x42487158
	Offset: 0x118
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.rewindwatcherarray = [];
}

/*
	Name: initrewindobjectwatchers
	Namespace: rewindobjects
	Checksum: 0x129536B3
	Offset: 0x130
	Size: 0x64
	Parameters: 1
	Flags: None
*/
function initrewindobjectwatchers(localclientnum)
{
	level.rewindwatcherarray[localclientnum] = [];
	createnapalmrewindwatcher(localclientnum);
	createairstrikerewindwatcher(localclientnum);
	level thread watchrewindableevents(localclientnum);
}

/*
	Name: watchrewindableevents
	Namespace: rewindobjects
	Checksum: 0xC478AB75
	Offset: 0x1A0
	Size: 0x194
	Parameters: 1
	Flags: Linked
*/
function watchrewindableevents(localclientnum)
{
	for(;;)
	{
		if(isdefined(level.rewindwatcherarray[localclientnum]))
		{
			rewindwatcherkeys = getarraykeys(level.rewindwatcherarray[localclientnum]);
			for(i = 0; i < rewindwatcherkeys.size; i++)
			{
				rewindwatcher = level.rewindwatcherarray[localclientnum][rewindwatcherkeys[i]];
				if(!isdefined(rewindwatcher))
				{
					continue;
				}
				if(!isdefined(rewindwatcher.event))
				{
					continue;
				}
				timekeys = getarraykeys(rewindwatcher.event);
				for(j = 0; j < timekeys.size; j++)
				{
					timekey = timekeys[j];
					if(rewindwatcher.event[timekey].inprogress == 1)
					{
						continue;
					}
					if(level.servertime >= timekey)
					{
						rewindwatcher thread startrewindableevent(localclientnum, timekey);
					}
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: startrewindableevent
	Namespace: rewindobjects
	Checksum: 0x9B076F82
	Offset: 0x340
	Size: 0x214
	Parameters: 2
	Flags: Linked
*/
function startrewindableevent(localclientnum, timekey)
{
	player = getlocalplayer(localclientnum);
	level endon("demo_jump" + localclientnum);
	self.event[timekey].inprogress = 1;
	allfunctionsstarted = 0;
	while(allfunctionsstarted == 0)
	{
		allfunctionsstarted = 1;
		/#
			assert(isdefined(self.timedfunctions));
		#/
		timedfunctionkeys = getarraykeys(self.timedfunctions);
		for(i = 0; i < timedfunctionkeys.size; i++)
		{
			timedfunction = self.timedfunctions[timedfunctionkeys[i]];
			timedfunctionkey = timedfunctionkeys[i];
			if(self.event[timekey].timedfunction[timedfunctionkey] == 1)
			{
				continue;
			}
			starttime = timekey + (timedfunction.starttimesec * 1000);
			if(starttime > level.servertime)
			{
				allfunctionsstarted = 0;
				continue;
			}
			self.event[timekey].timedfunction[timedfunctionkey] = 1;
			level thread [[timedfunction.func]](localclientnum, starttime, timedfunction.starttimesec, self.event[timekey].data);
		}
		wait(0.1);
	}
}

/*
	Name: createnapalmrewindwatcher
	Namespace: rewindobjects
	Checksum: 0x668ABCB9
	Offset: 0x560
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function createnapalmrewindwatcher(localclientnum)
{
	napalmrewindwatcher = createrewindwatcher(localclientnum, "napalm");
	timeincreasebetweenplanes = 0;
}

/*
	Name: createairstrikerewindwatcher
	Namespace: rewindobjects
	Checksum: 0x20280580
	Offset: 0x5B0
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function createairstrikerewindwatcher(localclientnum)
{
	airstrikerewindwatcher = createrewindwatcher(localclientnum, "airstrike");
}

/*
	Name: createrewindwatcher
	Namespace: rewindobjects
	Checksum: 0x8B62737
	Offset: 0x5F0
	Size: 0x108
	Parameters: 2
	Flags: Linked
*/
function createrewindwatcher(localclientnum, name)
{
	player = getlocalplayer(localclientnum);
	if(!isdefined(level.rewindwatcherarray[localclientnum]))
	{
		level.rewindwatcherarray[localclientnum] = [];
	}
	rewindwatcher = getrewindwatcher(localclientnum, name);
	if(!isdefined(rewindwatcher))
	{
		rewindwatcher = spawnstruct();
		level.rewindwatcherarray[localclientnum][level.rewindwatcherarray[localclientnum].size] = rewindwatcher;
	}
	rewindwatcher.name = name;
	rewindwatcher.event = [];
	rewindwatcher thread resetondemojump(localclientnum);
	return rewindwatcher;
}

/*
	Name: resetondemojump
	Namespace: rewindobjects
	Checksum: 0x92202C4E
	Offset: 0x700
	Size: 0x18E
	Parameters: 1
	Flags: Linked
*/
function resetondemojump(localclientnum)
{
	for(;;)
	{
		level waittill("demo_jump" + localclientnum);
		self.inprogress = 0;
		timedfunctionkeys = getarraykeys(self.timedfunctions);
		for(i = 0; i < timedfunctionkeys.size; i++)
		{
			self.timedfunctions[timedfunctionkeys[i]].inprogress = 0;
		}
		eventkeys = getarraykeys(self.event);
		for(i = 0; i < eventkeys.size; i++)
		{
			self.event[eventkeys[i]].inprogress = 0;
			timedfunctionkeys = getarraykeys(self.event[eventkeys[i]].timedfunction);
			for(index = 0; index < timedfunctionkeys.size; index++)
			{
				self.event[eventkeys[i]].timedfunction[timedfunctionkeys[index]] = 0;
			}
		}
	}
}

/*
	Name: addtimedfunction
	Namespace: rewindobjects
	Checksum: 0xD3D3343F
	Offset: 0x898
	Size: 0xCC
	Parameters: 3
	Flags: None
*/
function addtimedfunction(name, func, relativestarttimeinsecs)
{
	if(!isdefined(self.timedfunctions))
	{
		self.timedfunctions = [];
	}
	/#
		assert(!isdefined(self.timedfunctions[name]));
	#/
	self.timedfunctions[name] = spawnstruct();
	self.timedfunctions[name].inprogress = 0;
	self.timedfunctions[name].func = func;
	self.timedfunctions[name].starttimesec = relativestarttimeinsecs;
}

/*
	Name: getrewindwatcher
	Namespace: rewindobjects
	Checksum: 0x4326E67A
	Offset: 0x970
	Size: 0x98
	Parameters: 2
	Flags: Linked
*/
function getrewindwatcher(localclientnum, name)
{
	if(!isdefined(level.rewindwatcherarray[localclientnum]))
	{
		return undefined;
	}
	for(watcher = 0; watcher < level.rewindwatcherarray[localclientnum].size; watcher++)
	{
		if(level.rewindwatcherarray[localclientnum][watcher].name == name)
		{
			return level.rewindwatcherarray[localclientnum][watcher];
		}
	}
	return undefined;
}

/*
	Name: addrewindableeventtowatcher
	Namespace: rewindobjects
	Checksum: 0xFB2F8647
	Offset: 0xA10
	Size: 0x138
	Parameters: 2
	Flags: None
*/
function addrewindableeventtowatcher(starttime, data)
{
	if(isdefined(self.event[starttime]))
	{
		return;
	}
	self.event[starttime] = spawnstruct();
	self.event[starttime].data = data;
	self.event[starttime].inprogress = 0;
	if(isdefined(self.timedfunctions))
	{
		timedfunctionkeys = getarraykeys(self.timedfunctions);
		self.event[starttime].timedfunction = [];
		for(i = 0; i < timedfunctionkeys.size; i++)
		{
			timedfunctionkey = timedfunctionkeys[i];
			self.event[starttime].timedfunction[timedfunctionkey] = 0;
		}
	}
}

/*
	Name: servertimedmoveto
	Namespace: rewindobjects
	Checksum: 0x7070BB6
	Offset: 0xB50
	Size: 0x14E
	Parameters: 5
	Flags: None
*/
function servertimedmoveto(localclientnum, startpoint, endpoint, starttime, duration)
{
	level endon("demo_jump" + localclientnum);
	timeelapsed = (level.servertime - starttime) * 0.001;
	/#
		assert(duration > 0);
	#/
	dojump = 1;
	if(timeelapsed < 0.02)
	{
		dojump = 0;
	}
	if(timeelapsed < duration)
	{
		movetime = duration - timeelapsed;
		if(dojump)
		{
			jumppoint = getpointonline(startpoint, endpoint, timeelapsed / duration);
			self.origin = jumppoint;
		}
		self moveto(endpoint, movetime, 0, 0);
		return true;
	}
	self.origin = endpoint;
	return false;
}

/*
	Name: servertimedrotateto
	Namespace: rewindobjects
	Checksum: 0xFA1944
	Offset: 0xCA8
	Size: 0x10E
	Parameters: 6
	Flags: None
*/
function servertimedrotateto(localclientnum, angles, starttime, duration, timein, timeout)
{
	level endon("demo_jump" + localclientnum);
	timeelapsed = (level.servertime - starttime) * 0.001;
	if(!isdefined(timein))
	{
		timein = 0;
	}
	if(!isdefined(timeout))
	{
		timeout = 0;
	}
	/#
		assert(duration > 0);
	#/
	if(timeelapsed < duration)
	{
		rotatetime = duration - timeelapsed;
		self rotateto(angles, rotatetime, timein, timeout);
		return true;
	}
	self.angles = angles;
	return false;
}

/*
	Name: waitforservertime
	Namespace: rewindobjects
	Checksum: 0x55287B8C
	Offset: 0xDC0
	Size: 0x30
	Parameters: 2
	Flags: None
*/
function waitforservertime(localclientnum, timefromstart)
{
	while(timefromstart > level.servertime)
	{
		wait(0.01);
	}
}

/*
	Name: removecliententonjump
	Namespace: rewindobjects
	Checksum: 0xE0049DA6
	Offset: 0xDF8
	Size: 0x74
	Parameters: 2
	Flags: None
*/
function removecliententonjump(clientent, localclientnum)
{
	clientent endon(#"complete");
	player = getlocalplayer(localclientnum);
	level waittill("demo_jump" + localclientnum);
	clientent notify(#"delete");
	clientent forcedelete();
}

/*
	Name: getpointonline
	Namespace: rewindobjects
	Checksum: 0x3DE87540
	Offset: 0xE78
	Size: 0xA2
	Parameters: 3
	Flags: Linked
*/
function getpointonline(startpoint, endpoint, ratio)
{
	nextpoint = (startpoint[0] + ((endpoint[0] - startpoint[0]) * ratio), startpoint[1] + ((endpoint[1] - startpoint[1]) * ratio), startpoint[2] + ((endpoint[2] - startpoint[2]) * ratio));
	return nextpoint;
}

