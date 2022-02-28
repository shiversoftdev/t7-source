// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace hackable;

/*
	Name: __init__sytem__
	Namespace: hackable
	Checksum: 0x2F8626F6
	Offset: 0x198
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("hackable", &init, undefined, undefined);
}

/*
	Name: init
	Namespace: hackable
	Checksum: 0xFE2998D1
	Offset: 0x1D8
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function init()
{
	if(!isdefined(level.hackable_items))
	{
		level.hackable_items = [];
	}
}

/*
	Name: add_hackable_object
	Namespace: hackable
	Checksum: 0xEA1455E7
	Offset: 0x200
	Size: 0x248
	Parameters: 5
	Flags: None
*/
function add_hackable_object(obj, test_callback, start_callback, fail_callback, complete_callback)
{
	cleanup_hackable_objects();
	if(!isdefined(level.hackable_items))
	{
		level.hackable_items = [];
	}
	else if(!isarray(level.hackable_items))
	{
		level.hackable_items = array(level.hackable_items);
	}
	level.hackable_items[level.hackable_items.size] = obj;
	if(!isdefined(obj.hackable_distance_sq))
	{
		obj.hackable_distance_sq = getdvarfloat("scr_hacker_default_distance") * getdvarfloat("scr_hacker_default_distance");
	}
	if(!isdefined(obj.hackable_angledot))
	{
		obj.hackable_angledot = getdvarfloat("scr_hacker_default_angledot");
	}
	if(!isdefined(obj.hackable_timeout))
	{
		obj.hackable_timeout = getdvarfloat("scr_hacker_default_timeout");
	}
	if(!isdefined(obj.hackable_progress_prompt))
	{
		obj.hackable_progress_prompt = &"WEAPON_HACKING";
	}
	if(!isdefined(obj.hackable_cost_mult))
	{
		obj.hackable_cost_mult = 1;
	}
	if(!isdefined(obj.hackable_hack_time))
	{
		obj.hackable_hack_time = getdvarfloat("scr_hacker_default_hack_time");
	}
	obj.hackable_test_callback = test_callback;
	obj.hackable_start_callback = start_callback;
	obj.hackable_fail_callback = fail_callback;
	obj.hackable_hacked_callback = complete_callback;
}

/*
	Name: remove_hackable_object
	Namespace: hackable
	Checksum: 0xCD7CA715
	Offset: 0x450
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function remove_hackable_object(obj)
{
	arrayremovevalue(level.hackable_items, obj);
	cleanup_hackable_objects();
}

/*
	Name: cleanup_hackable_objects
	Namespace: hackable
	Checksum: 0x26DBC2A6
	Offset: 0x498
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function cleanup_hackable_objects()
{
	level.hackable_items = array::filter(level.hackable_items, 0, &filter_deleted);
}

/*
	Name: filter_deleted
	Namespace: hackable
	Checksum: 0x3FBBF7EF
	Offset: 0x4D8
	Size: 0x12
	Parameters: 1
	Flags: None
*/
function filter_deleted(val)
{
	return isdefined(val);
}

/*
	Name: find_hackable_object
	Namespace: hackable
	Checksum: 0x51AE796A
	Offset: 0x4F8
	Size: 0x17E
	Parameters: 0
	Flags: None
*/
function find_hackable_object()
{
	cleanup_hackable_objects();
	candidates = [];
	origin = self.origin;
	forward = anglestoforward(self.angles);
	foreach(obj in level.hackable_items)
	{
		if(self is_object_hackable(obj, origin, forward))
		{
			if(!isdefined(candidates))
			{
				candidates = [];
			}
			else if(!isarray(candidates))
			{
				candidates = array(candidates);
			}
			candidates[candidates.size] = obj;
		}
	}
	if(candidates.size > 0)
	{
		return arraygetclosest(self.origin, candidates);
	}
	return undefined;
}

/*
	Name: is_object_hackable
	Namespace: hackable
	Checksum: 0xCB7970C2
	Offset: 0x680
	Size: 0x128
	Parameters: 3
	Flags: None
*/
function is_object_hackable(obj, origin, forward)
{
	if(distancesquared(origin, obj.origin) < obj.hackable_distance_sq)
	{
		to_obj = obj.origin - origin;
		to_obj = (to_obj[0], to_obj[1], 0);
		to_obj = vectornormalize(to_obj);
		dot = vectordot(to_obj, forward);
		if(dot >= obj.hackable_angledot)
		{
			if(isdefined(obj.hackable_test_callback))
			{
				return obj [[obj.hackable_test_callback]](self);
			}
			return 1;
		}
		/#
		#/
	}
	return 0;
}

/*
	Name: start_hacking_object
	Namespace: hackable
	Checksum: 0xA913A150
	Offset: 0x7B0
	Size: 0x64
	Parameters: 1
	Flags: None
*/
function start_hacking_object(obj)
{
	obj.hackable_being_hacked = 1;
	obj.hackable_hacked_amount = 0;
	if(isdefined(obj.hackable_start_callback))
	{
		obj thread [[obj.hackable_start_callback]](self);
	}
}

/*
	Name: fail_hacking_object
	Namespace: hackable
	Checksum: 0x52979D6
	Offset: 0x820
	Size: 0x70
	Parameters: 1
	Flags: None
*/
function fail_hacking_object(obj)
{
	if(isdefined(obj.hackable_fail_callback))
	{
		obj thread [[obj.hackable_fail_callback]](self);
	}
	obj.hackable_hacked_amount = 0;
	obj.hackable_being_hacked = 0;
	obj notify(#"hackable_watch_timeout");
}

/*
	Name: complete_hacking_object
	Namespace: hackable
	Checksum: 0x6B41EED1
	Offset: 0x898
	Size: 0x70
	Parameters: 1
	Flags: None
*/
function complete_hacking_object(obj)
{
	obj notify(#"hackable_watch_timeout");
	if(isdefined(obj.hackable_hacked_callback))
	{
		obj thread [[obj.hackable_hacked_callback]](self);
	}
	obj.hackable_hacked_amount = 0;
	obj.hackable_being_hacked = 0;
}

/*
	Name: watch_timeout
	Namespace: hackable
	Checksum: 0xA31C9368
	Offset: 0x910
	Size: 0x54
	Parameters: 2
	Flags: None
*/
function watch_timeout(obj, time)
{
	obj notify(#"hackable_watch_timeout");
	obj endon(#"hackable_watch_timeout");
	wait(time);
	if(isdefined(obj))
	{
		fail_hacking_object(obj);
	}
}

/*
	Name: continue_hacking_object
	Namespace: hackable
	Checksum: 0xD5C346E6
	Offset: 0x970
	Size: 0x1DA
	Parameters: 1
	Flags: None
*/
function continue_hacking_object(obj)
{
	origin = self.origin;
	forward = anglestoforward(self.angles);
	if(self is_object_hackable(obj, origin, forward))
	{
		if(!(isdefined(obj.hackable_being_hacked) && obj.hackable_being_hacked))
		{
			self start_hacking_object(obj);
		}
		if(isdefined(obj.hackable_timeout) && obj.hackable_timeout > 0)
		{
			self thread watch_timeout(obj, obj.hackable_timeout);
		}
		amt = 1 / (20 * obj.hackable_hack_time);
		obj.hackable_hacked_amount = obj.hackable_hacked_amount + amt;
		if(obj.hackable_hacked_amount > 1)
		{
			self complete_hacking_object(obj);
		}
		if(isdefined(obj.hackable_being_hacked) && obj.hackable_being_hacked)
		{
			return obj.hackable_hacked_amount;
		}
	}
	return -1;
}

