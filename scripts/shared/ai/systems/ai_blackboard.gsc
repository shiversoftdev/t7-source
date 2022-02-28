// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace blackboard;

/*
	Name: main
	Namespace: blackboard
	Checksum: 0xCAD340B0
	Offset: 0x80
	Size: 0x14
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	_initializeblackboard();
}

/*
	Name: _initializeblackboard
	Namespace: blackboard
	Checksum: 0xA675A2DD
	Offset: 0xA0
	Size: 0x24
	Parameters: 0
	Flags: Linked, Private
*/
function private _initializeblackboard()
{
	level.__ai_blackboard = [];
	level thread _updateevents();
}

/*
	Name: _updateevents
	Namespace: blackboard
	Checksum: 0x710C6DDF
	Offset: 0xD0
	Size: 0x18E
	Parameters: 0
	Flags: Linked, Private
*/
function private _updateevents()
{
	waittime = 0.05;
	updatemillis = waittime * 1000;
	while(true)
	{
		foreach(eventname, events in level.__ai_blackboard)
		{
			liveevents = [];
			foreach(event in events)
			{
				event.ttl = event.ttl - updatemillis;
				if(event.ttl > 0)
				{
					liveevents[liveevents.size] = event;
				}
			}
			level.__ai_blackboard[eventname] = liveevents;
		}
		wait(waittime);
	}
}

/*
	Name: addblackboardevent
	Namespace: blackboard
	Checksum: 0x48C9B02C
	Offset: 0x268
	Size: 0x1A8
	Parameters: 3
	Flags: Linked
*/
function addblackboardevent(eventname, data, timetoliveinmillis)
{
	/#
		/#
			assert(isstring(eventname), "");
		#/
		/#
			assert(isdefined(data), "");
		#/
		/#
			assert(isint(timetoliveinmillis) && timetoliveinmillis > 0, "");
		#/
	#/
	event = spawnstruct();
	event.data = data;
	event.timestamp = gettime();
	event.ttl = timetoliveinmillis;
	if(!isdefined(level.__ai_blackboard[eventname]))
	{
		level.__ai_blackboard[eventname] = [];
	}
	else if(!isarray(level.__ai_blackboard[eventname]))
	{
		level.__ai_blackboard[eventname] = array(level.__ai_blackboard[eventname]);
	}
	level.__ai_blackboard[eventname][level.__ai_blackboard[eventname].size] = event;
}

/*
	Name: getblackboardevents
	Namespace: blackboard
	Checksum: 0x17147A3F
	Offset: 0x418
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function getblackboardevents(eventname)
{
	if(isdefined(level.__ai_blackboard[eventname]))
	{
		return level.__ai_blackboard[eventname];
	}
	return [];
}

/*
	Name: removeblackboardevents
	Namespace: blackboard
	Checksum: 0x52A2A4F5
	Offset: 0x450
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function removeblackboardevents(eventname)
{
	if(isdefined(level.__ai_blackboard[eventname]))
	{
		level.__ai_blackboard[eventname] = undefined;
	}
}

