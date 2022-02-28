// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace flag;

/*
	Name: init
	Namespace: flag
	Checksum: 0x906B7E21
	Offset: 0xD0
	Size: 0x116
	Parameters: 3
	Flags: Linked
*/
function init(str_flag, b_val = 0, b_is_trigger = 0)
{
	if(!isdefined(self.flag))
	{
		self.flag = [];
	}
	/#
		if(!isdefined(level.first_frame))
		{
			/#
				assert(!isdefined(self.flag[str_flag]), ("" + str_flag) + "");
			#/
		}
	#/
	self.flag[str_flag] = b_val;
	if(b_is_trigger)
	{
		if(!isdefined(level.trigger_flags))
		{
			trigger::init_flags();
			level.trigger_flags[str_flag] = [];
		}
		else if(!isdefined(level.trigger_flags[str_flag]))
		{
			level.trigger_flags[str_flag] = [];
		}
	}
}

/*
	Name: exists
	Namespace: flag
	Checksum: 0x9BA4D2B2
	Offset: 0x1F0
	Size: 0x26
	Parameters: 1
	Flags: Linked
*/
function exists(str_flag)
{
	return isdefined(self.flag) && isdefined(self.flag[str_flag]);
}

/*
	Name: set
	Namespace: flag
	Checksum: 0x5100B753
	Offset: 0x220
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function set(str_flag)
{
	/#
		assert(exists(str_flag), ("" + str_flag) + "");
	#/
	self.flag[str_flag] = 1;
	self notify(str_flag);
	trigger::set_flag_permissions(str_flag);
}

/*
	Name: delay_set
	Namespace: flag
	Checksum: 0x1486E9A4
	Offset: 0x2A8
	Size: 0x3C
	Parameters: 3
	Flags: None
*/
function delay_set(n_delay, str_flag, str_cancel)
{
	self thread _delay_set(n_delay, str_flag, str_cancel);
}

/*
	Name: _delay_set
	Namespace: flag
	Checksum: 0x41CC8D76
	Offset: 0x2F0
	Size: 0x54
	Parameters: 3
	Flags: Linked
*/
function _delay_set(n_delay, str_flag, str_cancel)
{
	if(isdefined(str_cancel))
	{
		self endon(str_cancel);
	}
	self endon(#"death");
	wait(n_delay);
	set(str_flag);
}

/*
	Name: set_val
	Namespace: flag
	Checksum: 0xF4117306
	Offset: 0x350
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function set_val(str_flag, b_val)
{
	/#
		assert(isdefined(b_val), "");
	#/
	if(b_val)
	{
		set(str_flag);
	}
	else
	{
		clear(str_flag);
	}
}

/*
	Name: set_for_time
	Namespace: flag
	Checksum: 0x8D443D9
	Offset: 0x3D0
	Size: 0x6C
	Parameters: 2
	Flags: None
*/
function set_for_time(n_time, str_flag)
{
	self notify("__flag::set_for_time__" + str_flag);
	self endon("__flag::set_for_time__" + str_flag);
	set(str_flag);
	wait(n_time);
	clear(str_flag);
}

/*
	Name: clear
	Namespace: flag
	Checksum: 0x1C0C5805
	Offset: 0x448
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function clear(str_flag)
{
	/#
		assert(exists(str_flag), ("" + str_flag) + "");
	#/
	if(self.flag[str_flag])
	{
		self.flag[str_flag] = 0;
		self notify(str_flag);
		trigger::set_flag_permissions(str_flag);
	}
}

/*
	Name: toggle
	Namespace: flag
	Checksum: 0xFF17CDE4
	Offset: 0x4E0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function toggle(str_flag)
{
	if(get(str_flag))
	{
		clear(str_flag);
	}
	else
	{
		set(str_flag);
	}
}

/*
	Name: get
	Namespace: flag
	Checksum: 0xCD6A653A
	Offset: 0x540
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function get(str_flag)
{
	/#
		assert(exists(str_flag), ("" + str_flag) + "");
	#/
	return self.flag[str_flag];
}

/*
	Name: get_any
	Namespace: flag
	Checksum: 0xB956E6EF
	Offset: 0x5A0
	Size: 0x9C
	Parameters: 1
	Flags: None
*/
function get_any(&array)
{
	foreach(str_flag in array)
	{
		if(get(str_flag))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: wait_till
	Namespace: flag
	Checksum: 0x9C60C397
	Offset: 0x648
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function wait_till(str_flag)
{
	self endon(#"death");
	while(!get(str_flag))
	{
		self waittill(str_flag);
	}
}

/*
	Name: wait_till_timeout
	Namespace: flag
	Checksum: 0x670CD85A
	Offset: 0x690
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function wait_till_timeout(n_timeout, str_flag)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	wait_till(str_flag);
}

/*
	Name: wait_till_all
	Namespace: flag
	Checksum: 0x8B83EC54
	Offset: 0x720
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function wait_till_all(a_flags)
{
	self endon(#"death");
	for(i = 0; i < a_flags.size; i++)
	{
		str_flag = a_flags[i];
		if(!get(str_flag))
		{
			self waittill(str_flag);
			i = -1;
		}
	}
}

/*
	Name: wait_till_all_timeout
	Namespace: flag
	Checksum: 0x9099FB24
	Offset: 0x7B0
	Size: 0x84
	Parameters: 2
	Flags: None
*/
function wait_till_all_timeout(n_timeout, a_flags)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	wait_till_all(a_flags);
}

/*
	Name: wait_till_any
	Namespace: flag
	Checksum: 0xF22A5AF4
	Offset: 0x840
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function wait_till_any(a_flags)
{
	self endon(#"death");
	foreach(flag in a_flags)
	{
		if(get(flag))
		{
			return flag;
		}
	}
	util::waittill_any_array(a_flags);
}

/*
	Name: wait_till_any_timeout
	Namespace: flag
	Checksum: 0x5A0B8BA7
	Offset: 0x908
	Size: 0x84
	Parameters: 2
	Flags: None
*/
function wait_till_any_timeout(n_timeout, a_flags)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	wait_till_any(a_flags);
}

/*
	Name: wait_till_clear
	Namespace: flag
	Checksum: 0xDD403661
	Offset: 0x998
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function wait_till_clear(str_flag)
{
	self endon(#"death");
	while(get(str_flag))
	{
		self waittill(str_flag);
	}
}

/*
	Name: wait_till_clear_timeout
	Namespace: flag
	Checksum: 0x5C0B5B60
	Offset: 0x9E0
	Size: 0x84
	Parameters: 2
	Flags: None
*/
function wait_till_clear_timeout(n_timeout, str_flag)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	wait_till_clear(str_flag);
}

/*
	Name: wait_till_clear_all
	Namespace: flag
	Checksum: 0xF8CB7874
	Offset: 0xA70
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function wait_till_clear_all(a_flags)
{
	self endon(#"death");
	for(i = 0; i < a_flags.size; i++)
	{
		str_flag = a_flags[i];
		if(get(str_flag))
		{
			self waittill(str_flag);
			i = -1;
		}
	}
}

/*
	Name: wait_till_clear_all_timeout
	Namespace: flag
	Checksum: 0x96B22658
	Offset: 0xB00
	Size: 0x84
	Parameters: 2
	Flags: None
*/
function wait_till_clear_all_timeout(n_timeout, a_flags)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	wait_till_clear_all(a_flags);
}

/*
	Name: wait_till_clear_any
	Namespace: flag
	Checksum: 0x2D75F0A3
	Offset: 0xB90
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function wait_till_clear_any(a_flags)
{
	self endon(#"death");
	while(true)
	{
		foreach(flag in a_flags)
		{
			if(!get(flag))
			{
				return flag;
			}
		}
		util::waittill_any_array(a_flags);
	}
}

/*
	Name: wait_till_clear_any_timeout
	Namespace: flag
	Checksum: 0xF6D4D6B1
	Offset: 0xC60
	Size: 0x84
	Parameters: 2
	Flags: None
*/
function wait_till_clear_any_timeout(n_timeout, a_flags)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	wait_till_clear_any(a_flags);
}

/*
	Name: delete
	Namespace: flag
	Checksum: 0xD99B4579
	Offset: 0xCF0
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function delete(str_flag)
{
	if(isdefined(self.flag[str_flag]))
	{
		self.flag[str_flag] = undefined;
	}
	else
	{
		/#
			println("" + str_flag);
		#/
	}
}

/*
	Name: script_flag_wait
	Namespace: flag
	Checksum: 0x3014E84
	Offset: 0xD50
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function script_flag_wait()
{
	if(isdefined(self.script_flag_wait))
	{
		self wait_till(self.script_flag_wait);
		return true;
	}
	return false;
}

