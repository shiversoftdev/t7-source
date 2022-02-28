// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\util_shared;

#namespace flag;

/*
	Name: init
	Namespace: flag
	Checksum: 0x86F47E97
	Offset: 0xB0
	Size: 0xB6
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
}

/*
	Name: exists
	Namespace: flag
	Checksum: 0xCCEAB3F4
	Offset: 0x170
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
	Checksum: 0xDE799908
	Offset: 0x1A0
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function set(str_flag)
{
	/#
		/#
			assert(exists(str_flag), ("" + str_flag) + "");
		#/
	#/
	self.flag[str_flag] = 1;
	self notify(str_flag);
}

/*
	Name: delay_set
	Namespace: flag
	Checksum: 0x105BFD7A
	Offset: 0x218
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
	Checksum: 0xF93783E
	Offset: 0x260
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
	Name: set_for_time
	Namespace: flag
	Checksum: 0xDEB85EFE
	Offset: 0x2C0
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
	Checksum: 0x7DD30FEE
	Offset: 0x338
	Size: 0x78
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
	}
}

/*
	Name: toggle
	Namespace: flag
	Checksum: 0xDDE3BB51
	Offset: 0x3B8
	Size: 0x54
	Parameters: 1
	Flags: None
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
	Checksum: 0x68D1A7A0
	Offset: 0x418
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
	Name: wait_till
	Namespace: flag
	Checksum: 0xD47070BA
	Offset: 0x478
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
	Checksum: 0x80D74332
	Offset: 0x4C0
	Size: 0x84
	Parameters: 2
	Flags: None
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
	Checksum: 0x764B357F
	Offset: 0x550
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
	Checksum: 0x642F2FDB
	Offset: 0x5E0
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
	Checksum: 0x50C21698
	Offset: 0x670
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
	Checksum: 0xB0170515
	Offset: 0x738
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
	Checksum: 0xCA73C7F2
	Offset: 0x7C8
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
	Checksum: 0xAE18577F
	Offset: 0x810
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
	Checksum: 0xA536E199
	Offset: 0x8A0
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
	Checksum: 0x65ABAB7B
	Offset: 0x930
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
	Checksum: 0xC94163C1
	Offset: 0x9C0
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
	Checksum: 0x1FB38845
	Offset: 0xA90
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
	Checksum: 0xBD8FE1D5
	Offset: 0xB20
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

