// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;

#namespace system;

/*
	Name: register
	Namespace: system
	Checksum: 0x893F9999
	Offset: 0xC8
	Size: 0x174
	Parameters: 4
	Flags: Linked
*/
function register(str_system, func_preinit, func_postinit, reqs = [])
{
	if(isdefined(level.system_funcs) && isdefined(level.system_funcs[str_system]))
	{
		/#
			assertmsg(("" + str_system) + "");
		#/
		return;
	}
	if(!isdefined(level.system_funcs))
	{
		level.system_funcs = [];
	}
	level.system_funcs[str_system] = spawnstruct();
	level.system_funcs[str_system].prefunc = func_preinit;
	level.system_funcs[str_system].postfunc = func_postinit;
	level.system_funcs[str_system].reqs = reqs;
	level.system_funcs[str_system].predone = !isdefined(func_preinit);
	level.system_funcs[str_system].postdone = !isdefined(func_postinit);
	level.system_funcs[str_system].ignore = 0;
}

/*
	Name: exec_post_system
	Namespace: system
	Checksum: 0xBB29292A
	Offset: 0x248
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function exec_post_system(req)
{
	/#
		if(!isdefined(level.system_funcs[req]))
		{
			/#
				assertmsg(("" + req) + "");
			#/
		}
	#/
	if(level.system_funcs[req].ignore)
	{
		return;
	}
	if(!level.system_funcs[req].postdone)
	{
		[[level.system_funcs[req].postfunc]]();
		level.system_funcs[req].postdone = 1;
	}
}

/*
	Name: run_post_systems
	Namespace: system
	Checksum: 0x9E903355
	Offset: 0x310
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function run_post_systems()
{
	foreach(key, func in level.system_funcs)
	{
		/#
			assert(func.predone || func.ignore, "");
		#/
		if(isarray(func.reqs))
		{
			foreach(req in func.reqs)
			{
				thread exec_post_system(req);
			}
		}
		else
		{
			thread exec_post_system(func.reqs);
		}
		thread exec_post_system(key);
	}
	if(!level flag::exists("system_init_complete"))
	{
		level flag::init("system_init_complete", 0);
	}
	level flag::set("system_init_complete");
}

/*
	Name: exec_pre_system
	Namespace: system
	Checksum: 0x22D22152
	Offset: 0x508
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function exec_pre_system(req)
{
	/#
		if(!isdefined(level.system_funcs[req]))
		{
			/#
				assertmsg(("" + req) + "");
			#/
		}
	#/
	if(level.system_funcs[req].ignore)
	{
		return;
	}
	if(!level.system_funcs[req].predone)
	{
		[[level.system_funcs[req].prefunc]]();
		level.system_funcs[req].predone = 1;
	}
}

/*
	Name: run_pre_systems
	Namespace: system
	Checksum: 0x46324F8D
	Offset: 0x5D0
	Size: 0x15A
	Parameters: 0
	Flags: Linked
*/
function run_pre_systems()
{
	foreach(key, func in level.system_funcs)
	{
		if(isarray(func.reqs))
		{
			foreach(req in func.reqs)
			{
				thread exec_pre_system(req);
			}
		}
		else
		{
			thread exec_pre_system(func.reqs);
		}
		thread exec_pre_system(key);
	}
}

/*
	Name: wait_till
	Namespace: system
	Checksum: 0x6DC19045
	Offset: 0x738
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function wait_till(required_systems)
{
	if(!level flag::exists("system_init_complete"))
	{
		level flag::init("system_init_complete", 0);
	}
	level flag::wait_till("system_init_complete");
}

/*
	Name: ignore
	Namespace: system
	Checksum: 0xB7ED0A78
	Offset: 0x7B0
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function ignore(str_system)
{
	/#
		assert(!isdefined(level.gametype), "");
	#/
	if(!isdefined(level.system_funcs) || !isdefined(level.system_funcs[str_system]))
	{
		register(str_system, undefined, undefined, undefined);
	}
	level.system_funcs[str_system].ignore = 1;
}

/*
	Name: is_system_running
	Namespace: system
	Checksum: 0xE7EEE5A6
	Offset: 0x848
	Size: 0x4A
	Parameters: 1
	Flags: None
*/
function is_system_running(str_system)
{
	if(!isdefined(level.system_funcs) || !isdefined(level.system_funcs[str_system]))
	{
		return 0;
	}
	return level.system_funcs[str_system].postdone;
}

