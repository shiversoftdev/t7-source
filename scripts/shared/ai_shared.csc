// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace ai_shared;

/*
	Name: main
	Namespace: ai_shared
	Checksum: 0x92D15211
	Offset: 0x78
	Size: 0x1C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	level._customactorcbfunc = &ai::spawned_callback;
}

#namespace ai;

/*
	Name: add_ai_spawn_function
	Namespace: ai
	Checksum: 0x1AB047E0
	Offset: 0xA0
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function add_ai_spawn_function(spawn_func)
{
	if(!isdefined(level.spawn_ai_func))
	{
		level.spawn_ai_func = [];
	}
	func = [];
	func["function"] = spawn_func;
	level.spawn_ai_func[level.spawn_ai_func.size] = func;
}

/*
	Name: add_archetype_spawn_function
	Namespace: ai
	Checksum: 0x5C316DA5
	Offset: 0x108
	Size: 0x110
	Parameters: 2
	Flags: Linked
*/
function add_archetype_spawn_function(archetype, spawn_func)
{
	if(!isdefined(level.spawn_funcs))
	{
		level.spawn_funcs = [];
	}
	if(!isdefined(level.spawn_funcs[archetype]))
	{
		level.spawn_funcs[archetype] = [];
	}
	func = [];
	func["function"] = spawn_func;
	if(!isdefined(level.spawn_funcs[archetype]))
	{
		level.spawn_funcs[archetype] = [];
	}
	else if(!isarray(level.spawn_funcs[archetype]))
	{
		level.spawn_funcs[archetype] = array(level.spawn_funcs[archetype]);
	}
	level.spawn_funcs[archetype][level.spawn_funcs[archetype].size] = func;
}

/*
	Name: spawned_callback
	Namespace: ai
	Checksum: 0xEA9C8723
	Offset: 0x220
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function spawned_callback(localclientnum)
{
	if(isdefined(level.spawn_ai_func))
	{
		for(index = 0; index < level.spawn_ai_func.size; index++)
		{
			func = level.spawn_ai_func[index];
			self thread [[func["function"]]](localclientnum);
		}
	}
	if(isdefined(level.spawn_funcs) && isdefined(level.spawn_funcs[self.archetype]))
	{
		for(index = 0; index < level.spawn_funcs[self.archetype].size; index++)
		{
			func = level.spawn_funcs[self.archetype][index];
			self thread [[func["function"]]](localclientnum);
		}
	}
}

/*
	Name: shouldregisterclientfieldforarchetype
	Namespace: ai
	Checksum: 0xA940B9ED
	Offset: 0x330
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function shouldregisterclientfieldforarchetype(archetype)
{
	if(isdefined(level.clientfieldaicheck) && level.clientfieldaicheck && !isarchetypeloaded(archetype))
	{
		return false;
	}
	return true;
}

