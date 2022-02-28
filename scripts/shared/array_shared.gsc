// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace array;

/*
	Name: filter
	Namespace: array
	Checksum: 0x48F2EA9E
	Offset: 0x120
	Size: 0x19E
	Parameters: 8
	Flags: Linked
*/
function filter(&array, b_keep_keys, func_filter, arg1, arg2, arg3, arg4, arg5)
{
	a_new = [];
	foreach(key, val in array)
	{
		if(util::single_func(self, func_filter, val, arg1, arg2, arg3, arg4, arg5))
		{
			if(isstring(key) || isweapon(key))
			{
				if(isdefined(b_keep_keys) && !b_keep_keys)
				{
					a_new[a_new.size] = val;
				}
				else
				{
					a_new[key] = val;
				}
				continue;
			}
			if(isdefined(b_keep_keys) && b_keep_keys)
			{
				a_new[key] = val;
				continue;
			}
			a_new[a_new.size] = val;
		}
	}
	return a_new;
}

/*
	Name: remove_dead
	Namespace: array
	Checksum: 0xAE5F9937
	Offset: 0x2C8
	Size: 0x3A
	Parameters: 2
	Flags: Linked
*/
function remove_dead(&array, b_keep_keys)
{
	return filter(array, b_keep_keys, &_filter_dead);
}

/*
	Name: _filter_undefined
	Namespace: array
	Checksum: 0xCA3CBB34
	Offset: 0x310
	Size: 0x12
	Parameters: 1
	Flags: Linked
*/
function _filter_undefined(val)
{
	return isdefined(val);
}

/*
	Name: remove_undefined
	Namespace: array
	Checksum: 0x1C8EB978
	Offset: 0x330
	Size: 0x3A
	Parameters: 2
	Flags: Linked
*/
function remove_undefined(&array, b_keep_keys)
{
	return filter(array, b_keep_keys, &_filter_undefined);
}

/*
	Name: cleanup
	Namespace: array
	Checksum: 0xE5050BA
	Offset: 0x378
	Size: 0x14E
	Parameters: 2
	Flags: Linked
*/
function cleanup(&array, b_keep_empty_arrays = 0)
{
	a_keys = getarraykeys(array);
	for(i = a_keys.size - 1; i >= 0; i--)
	{
		key = a_keys[i];
		if(isarray(array[key]) && array[key].size)
		{
			cleanup(array[key], b_keep_empty_arrays);
			continue;
		}
		if(!isdefined(array[key]) || (!b_keep_empty_arrays && isarray(array[key]) && !array[key].size))
		{
			arrayremoveindex(array, key);
		}
	}
}

/*
	Name: filter_classname
	Namespace: array
	Checksum: 0xFD64D624
	Offset: 0x4D0
	Size: 0x4A
	Parameters: 3
	Flags: Linked
*/
function filter_classname(&array, b_keep_keys, str_classname)
{
	return filter(array, b_keep_keys, &_filter_classname, str_classname);
}

/*
	Name: get_touching
	Namespace: array
	Checksum: 0xD43D8948
	Offset: 0x528
	Size: 0x3A
	Parameters: 2
	Flags: None
*/
function get_touching(&array, b_keep_keys)
{
	return filter(array, b_keep_keys, &istouching);
}

/*
	Name: remove_index
	Namespace: array
	Checksum: 0x2D00F0BB
	Offset: 0x570
	Size: 0xEC
	Parameters: 3
	Flags: Linked
*/
function remove_index(array, index, b_keep_keys)
{
	a_new = [];
	foreach(key, val in array)
	{
		if(key == index)
		{
			continue;
			continue;
		}
		if(isdefined(b_keep_keys) && b_keep_keys)
		{
			a_new[key] = val;
			continue;
		}
		a_new[a_new.size] = val;
	}
	return a_new;
}

/*
	Name: delete_all
	Namespace: array
	Checksum: 0x38F99515
	Offset: 0x668
	Size: 0xFA
	Parameters: 2
	Flags: Linked
*/
function delete_all(&array, is_struct)
{
	foreach(ent in array)
	{
		if(isdefined(ent))
		{
			if(isdefined(is_struct) && is_struct)
			{
				ent struct::delete();
				continue;
			}
			if(isdefined(ent.__vtable))
			{
				ent notify(#"death");
				ent = undefined;
				continue;
			}
			ent delete();
		}
	}
}

/*
	Name: notify_all
	Namespace: array
	Checksum: 0xFC87ACD1
	Offset: 0x770
	Size: 0x8E
	Parameters: 2
	Flags: Linked
*/
function notify_all(&array, str_notify)
{
	foreach(elem in array)
	{
		elem notify(str_notify);
	}
}

/*
	Name: thread_all
	Namespace: array
	Checksum: 0xBFC1EDA4
	Offset: 0x808
	Size: 0x4CC
	Parameters: 8
	Flags: Linked
*/
function thread_all(&entities, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	/#
		assert(isdefined(entities), "");
	#/
	/#
		assert(isdefined(func), "");
	#/
	if(isarray(entities))
	{
		if(isdefined(arg6))
		{
			foreach(ent in entities)
			{
				ent thread [[func]](arg1, arg2, arg3, arg4, arg5, arg6);
			}
		}
		else
		{
			if(isdefined(arg5))
			{
				foreach(ent in entities)
				{
					ent thread [[func]](arg1, arg2, arg3, arg4, arg5);
				}
			}
			else
			{
				if(isdefined(arg4))
				{
					foreach(ent in entities)
					{
						ent thread [[func]](arg1, arg2, arg3, arg4);
					}
				}
				else
				{
					if(isdefined(arg3))
					{
						foreach(ent in entities)
						{
							ent thread [[func]](arg1, arg2, arg3);
						}
					}
					else
					{
						if(isdefined(arg2))
						{
							foreach(ent in entities)
							{
								ent thread [[func]](arg1, arg2);
							}
						}
						else
						{
							if(isdefined(arg1))
							{
								foreach(ent in entities)
								{
									ent thread [[func]](arg1);
								}
							}
							else
							{
								foreach(ent in entities)
								{
									ent thread [[func]]();
								}
							}
						}
					}
				}
			}
		}
	}
	else
	{
		util::single_thread(entities, func, arg1, arg2, arg3, arg4, arg5, arg6);
	}
}

/*
	Name: thread_all_ents
	Namespace: array
	Checksum: 0xC4372881
	Offset: 0xCE0
	Size: 0x16C
	Parameters: 7
	Flags: Linked
*/
function thread_all_ents(&entities, func, arg1, arg2, arg3, arg4, arg5)
{
	/#
		assert(isdefined(entities), "");
	#/
	/#
		assert(isdefined(func), "");
	#/
	if(isarray(entities))
	{
		if(entities.size)
		{
			keys = getarraykeys(entities);
			for(i = 0; i < keys.size; i++)
			{
				util::single_thread(self, func, entities[keys[i]], arg1, arg2, arg3, arg4, arg5);
			}
		}
	}
	else
	{
		util::single_thread(self, func, entities, arg1, arg2, arg3, arg4, arg5);
	}
}

/*
	Name: run_all
	Namespace: array
	Checksum: 0x3C895DC1
	Offset: 0xE58
	Size: 0x4CC
	Parameters: 8
	Flags: Linked
*/
function run_all(&entities, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	/#
		assert(isdefined(entities), "");
	#/
	/#
		assert(isdefined(func), "");
	#/
	if(isarray(entities))
	{
		if(isdefined(arg6))
		{
			foreach(ent in entities)
			{
				ent [[func]](arg1, arg2, arg3, arg4, arg5, arg6);
			}
		}
		else
		{
			if(isdefined(arg5))
			{
				foreach(ent in entities)
				{
					ent [[func]](arg1, arg2, arg3, arg4, arg5);
				}
			}
			else
			{
				if(isdefined(arg4))
				{
					foreach(ent in entities)
					{
						ent [[func]](arg1, arg2, arg3, arg4);
					}
				}
				else
				{
					if(isdefined(arg3))
					{
						foreach(ent in entities)
						{
							ent [[func]](arg1, arg2, arg3);
						}
					}
					else
					{
						if(isdefined(arg2))
						{
							foreach(ent in entities)
							{
								ent [[func]](arg1, arg2);
							}
						}
						else
						{
							if(isdefined(arg1))
							{
								foreach(ent in entities)
								{
									ent [[func]](arg1);
								}
							}
							else
							{
								foreach(ent in entities)
								{
									ent [[func]]();
								}
							}
						}
					}
				}
			}
		}
	}
	else
	{
		util::single_func(entities, func, arg1, arg2, arg3, arg4, arg5, arg6);
	}
}

/*
	Name: exclude
	Namespace: array
	Checksum: 0xC2768DF0
	Offset: 0x1330
	Size: 0xF0
	Parameters: 2
	Flags: Linked
*/
function exclude(array, array_exclude)
{
	newarray = array;
	if(isarray(array_exclude))
	{
		foreach(exclude_item in array_exclude)
		{
			arrayremovevalue(newarray, exclude_item);
		}
	}
	else
	{
		arrayremovevalue(newarray, array_exclude);
	}
	return newarray;
}

/*
	Name: add
	Namespace: array
	Checksum: 0x416F7F3A
	Offset: 0x1428
	Size: 0x72
	Parameters: 3
	Flags: Linked
*/
function add(&array, item, allow_dupes = 1)
{
	if(isdefined(item))
	{
		if(allow_dupes || !isinarray(array, item))
		{
			array[array.size] = item;
		}
	}
}

/*
	Name: add_sorted
	Namespace: array
	Checksum: 0xEA169CE6
	Offset: 0x14A8
	Size: 0xD2
	Parameters: 3
	Flags: Linked
*/
function add_sorted(&array, item, allow_dupes = 1)
{
	if(isdefined(item))
	{
		if(allow_dupes || !isinarray(array, item))
		{
			for(i = 0; i <= array.size; i++)
			{
				if(i == array.size || item <= array[i])
				{
					arrayinsert(array, item, i);
					break;
				}
			}
		}
	}
}

/*
	Name: wait_till
	Namespace: array
	Checksum: 0xF8DCB179
	Offset: 0x1588
	Size: 0x16E
	Parameters: 3
	Flags: Linked
*/
function wait_till(&array, notifies, n_timeout)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	s_tracker = spawnstruct();
	s_tracker._wait_count = 0;
	foreach(ent in array)
	{
		if(isdefined(ent))
		{
			ent thread util::timeout(n_timeout, &util::_waitlogic, s_tracker, notifies);
		}
	}
	if(s_tracker._wait_count > 0)
	{
		s_tracker waittill(#"waitlogic_finished");
	}
}

/*
	Name: wait_till_match
	Namespace: array
	Checksum: 0xF010E87B
	Offset: 0x1700
	Size: 0x1B6
	Parameters: 4
	Flags: None
*/
function wait_till_match(&array, str_notify, str_match, n_timeout)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	s_tracker = spawnstruct();
	s_tracker._array_wait_count = 0;
	foreach(ent in array)
	{
		if(isdefined(ent))
		{
			s_tracker._array_wait_count++;
			ent thread util::timeout(n_timeout, &_waitlogic_match, s_tracker, str_notify, str_match);
			ent thread util::timeout(n_timeout, &_waitlogic_death, s_tracker);
		}
	}
	if(s_tracker._array_wait_count > 0)
	{
		s_tracker waittill(#"array_wait");
	}
}

/*
	Name: _waitlogic_match
	Namespace: array
	Checksum: 0xC6A73A2A
	Offset: 0x18C0
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function _waitlogic_match(s_tracker, str_notify, str_match)
{
	self endon(#"death");
	self waittillmatch(str_notify);
	update_waitlogic_tracker(s_tracker);
}

/*
	Name: _waitlogic_death
	Namespace: array
	Checksum: 0xC0595426
	Offset: 0x1918
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function _waitlogic_death(s_tracker)
{
	self waittill(#"death");
	update_waitlogic_tracker(s_tracker);
}

/*
	Name: update_waitlogic_tracker
	Namespace: array
	Checksum: 0x4ABF1116
	Offset: 0x1950
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function update_waitlogic_tracker(s_tracker)
{
	s_tracker._array_wait_count--;
	if(s_tracker._array_wait_count == 0)
	{
		s_tracker notify(#"array_wait");
	}
}

/*
	Name: flag_wait
	Namespace: array
	Checksum: 0x99A39A50
	Offset: 0x1998
	Size: 0xCC
	Parameters: 2
	Flags: None
*/
function flag_wait(&array, str_flag)
{
	do
	{
		recheck = 0;
		for(i = 0; i < array.size; i++)
		{
			ent = array[i];
			if(isdefined(ent) && !ent flag::get(str_flag))
			{
				ent util::waittill_either("death", str_flag);
				recheck = 1;
				break;
			}
		}
	}
	while(recheck);
}

/*
	Name: flagsys_wait
	Namespace: array
	Checksum: 0x838C7C25
	Offset: 0x1A70
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function flagsys_wait(&array, str_flag)
{
	do
	{
		recheck = 0;
		for(i = 0; i < array.size; i++)
		{
			ent = array[i];
			if(isdefined(ent) && !ent flagsys::get(str_flag))
			{
				ent util::waittill_either("death", str_flag);
				recheck = 1;
				break;
			}
		}
	}
	while(recheck);
}

/*
	Name: flagsys_wait_any_flag
	Namespace: array
	Checksum: 0x46708E91
	Offset: 0x1B48
	Size: 0x150
	Parameters: 2
	Flags: Linked, Variadic
*/
function flagsys_wait_any_flag(&array, ...)
{
	do
	{
		recheck = 0;
		for(i = 0; i < array.size; i++)
		{
			ent = array[i];
			if(isdefined(ent))
			{
				b_flag_set = 0;
				foreach(str_flag in vararg)
				{
					if(ent flagsys::get(str_flag))
					{
						b_flag_set = 1;
						break;
					}
				}
				if(!b_flag_set)
				{
					ent util::waittill_any_array(vararg);
					recheck = 1;
				}
			}
		}
	}
	while(recheck);
}

/*
	Name: flagsys_wait_any
	Namespace: array
	Checksum: 0x8DC809C9
	Offset: 0x1CA0
	Size: 0xBC
	Parameters: 2
	Flags: None
*/
function flagsys_wait_any(&array, str_flag)
{
	foreach(ent in array)
	{
		if(ent flagsys::get(str_flag))
		{
			return ent;
		}
	}
	wait_any(array, str_flag);
}

/*
	Name: flag_wait_clear
	Namespace: array
	Checksum: 0x117CAEDC
	Offset: 0x1D68
	Size: 0x9E
	Parameters: 2
	Flags: None
*/
function flag_wait_clear(&array, str_flag)
{
	do
	{
		recheck = 0;
		for(i = 0; i < array.size; i++)
		{
			ent = array[i];
			if(ent flag::get(str_flag))
			{
				ent waittill(str_flag);
				recheck = 1;
			}
		}
	}
	while(recheck);
}

/*
	Name: flagsys_wait_clear
	Namespace: array
	Checksum: 0x629872E9
	Offset: 0x1E10
	Size: 0x10E
	Parameters: 3
	Flags: Linked
*/
function flagsys_wait_clear(&array, str_flag, n_timeout)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	do
	{
		recheck = 0;
		for(i = 0; i < array.size; i++)
		{
			ent = array[i];
			if(isdefined(ent) && ent flagsys::get(str_flag))
			{
				ent waittill(str_flag);
				recheck = 1;
			}
		}
	}
	while(recheck);
}

/*
	Name: wait_any
	Namespace: array
	Checksum: 0xFE2DF630
	Offset: 0x1F28
	Size: 0x164
	Parameters: 3
	Flags: Linked
*/
function wait_any(array, msg, n_timeout)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	s_tracker = spawnstruct();
	foreach(ent in array)
	{
		if(isdefined(ent))
		{
			level thread util::timeout(n_timeout, &_waitlogic2, s_tracker, ent, msg);
		}
	}
	s_tracker endon(#"array_wait");
	wait_till(array, "death");
}

/*
	Name: _waitlogic2
	Namespace: array
	Checksum: 0x9DFD6D35
	Offset: 0x2098
	Size: 0x6C
	Parameters: 3
	Flags: Linked
*/
function _waitlogic2(s_tracker, ent, msg)
{
	s_tracker endon(#"array_wait");
	if(msg != "death")
	{
		ent endon(#"death");
	}
	ent util::waittill_any_array(msg);
	s_tracker notify(#"array_wait");
}

/*
	Name: flag_wait_any
	Namespace: array
	Checksum: 0x633AD1F
	Offset: 0x2110
	Size: 0xCC
	Parameters: 2
	Flags: None
*/
function flag_wait_any(array, str_flag)
{
	self endon(#"death");
	foreach(ent in array)
	{
		if(ent flag::get(str_flag))
		{
			return ent;
		}
	}
	wait_any(array, str_flag);
}

/*
	Name: random
	Namespace: array
	Checksum: 0xC1ADB6A4
	Offset: 0x21E8
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function random(array)
{
	if(array.size > 0)
	{
		keys = getarraykeys(array);
		return array[keys[randomint(keys.size)]];
	}
}

/*
	Name: randomize
	Namespace: array
	Checksum: 0xB435E2CE
	Offset: 0x2258
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function randomize(array)
{
	for(i = 0; i < array.size; i++)
	{
		j = randomint(array.size);
		temp = array[i];
		array[i] = array[j];
		array[j] = temp;
	}
	return array;
}

/*
	Name: clamp_size
	Namespace: array
	Checksum: 0x6D15F724
	Offset: 0x2300
	Size: 0x66
	Parameters: 2
	Flags: None
*/
function clamp_size(array, n_size)
{
	a_ret = [];
	for(i = 0; i < n_size; i++)
	{
		a_ret[i] = array[i];
	}
	return a_ret;
}

/*
	Name: reverse
	Namespace: array
	Checksum: 0x64B3717F
	Offset: 0x2370
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function reverse(array)
{
	a_array2 = [];
	for(i = array.size - 1; i >= 0; i--)
	{
		a_array2[a_array2.size] = array[i];
	}
	return a_array2;
}

/*
	Name: remove_keys
	Namespace: array
	Checksum: 0x1D20894A
	Offset: 0x23E0
	Size: 0xAA
	Parameters: 1
	Flags: None
*/
function remove_keys(array)
{
	a_new = [];
	foreach(val in array)
	{
		if(isdefined(val))
		{
			a_new[a_new.size] = val;
		}
	}
	return a_new;
}

/*
	Name: swap
	Namespace: array
	Checksum: 0xCBCAADA3
	Offset: 0x2498
	Size: 0x5A
	Parameters: 3
	Flags: Linked
*/
function swap(&array, index1, index2)
{
	temp = array[index1];
	array[index1] = array[index2];
	array[index2] = temp;
}

/*
	Name: pop
	Namespace: array
	Checksum: 0x54E5164A
	Offset: 0x2500
	Size: 0xC2
	Parameters: 3
	Flags: Linked
*/
function pop(&array, index, b_keep_keys = 1)
{
	if(array.size > 0)
	{
		if(!isdefined(index))
		{
			keys = getarraykeys(array);
			index = keys[0];
		}
		if(isdefined(array[index]))
		{
			ret = array[index];
			arrayremoveindex(array, index, b_keep_keys);
			return ret;
		}
	}
}

/*
	Name: pop_front
	Namespace: array
	Checksum: 0x97E768CA
	Offset: 0x25D0
	Size: 0x82
	Parameters: 2
	Flags: Linked
*/
function pop_front(&array, b_keep_keys = 1)
{
	keys = getarraykeys(array);
	index = keys[keys.size - 1];
	return pop(array, index, b_keep_keys);
}

/*
	Name: push
	Namespace: array
	Checksum: 0xA246B8C
	Offset: 0x2660
	Size: 0x104
	Parameters: 3
	Flags: Linked
*/
function push(&array, val, index)
{
	if(!isdefined(index))
	{
		index = 0;
		foreach(key in getarraykeys(array))
		{
			if(isint(key) && key >= index)
			{
				index = key + 1;
			}
		}
	}
	arrayinsert(array, val, index);
}

/*
	Name: push_front
	Namespace: array
	Checksum: 0xB3701521
	Offset: 0x2770
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function push_front(&array, val)
{
	push(array, val, 0);
}

/*
	Name: get_closest
	Namespace: array
	Checksum: 0x73F13020
	Offset: 0x27B0
	Size: 0x3C
	Parameters: 3
	Flags: None
*/
function get_closest(org, &array, dist)
{
	/#
		assert(0, "");
	#/
}

/*
	Name: get_farthest
	Namespace: array
	Checksum: 0x2803DF89
	Offset: 0x27F8
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function get_farthest(org, &array, dist = undefined)
{
	/#
		assert(0, "");
	#/
}

/*
	Name: closerfunc
	Namespace: array
	Checksum: 0xF131CA05
	Offset: 0x2850
	Size: 0x1E
	Parameters: 2
	Flags: None
*/
function closerfunc(dist1, dist2)
{
	return dist1 >= dist2;
}

/*
	Name: fartherfunc
	Namespace: array
	Checksum: 0xC1C365ED
	Offset: 0x2878
	Size: 0x1E
	Parameters: 2
	Flags: None
*/
function fartherfunc(dist1, dist2)
{
	return dist1 <= dist2;
}

/*
	Name: get_all_farthest
	Namespace: array
	Checksum: 0x1D0B4F1C
	Offset: 0x28A0
	Size: 0xC4
	Parameters: 5
	Flags: None
*/
function get_all_farthest(org, &array, a_exclude, n_max = array.size, n_maxdist)
{
	a_ret = exclude(array, a_exclude);
	if(isdefined(n_maxdist))
	{
		a_ret = arraysort(a_ret, org, 0, n_max, n_maxdist);
	}
	else
	{
		a_ret = arraysort(a_ret, org, 0, n_max);
	}
	return a_ret;
}

/*
	Name: get_all_closest
	Namespace: array
	Checksum: 0x388139B5
	Offset: 0x2970
	Size: 0xCC
	Parameters: 5
	Flags: Linked
*/
function get_all_closest(org, &array, a_exclude, n_max = array.size, n_maxdist)
{
	a_ret = exclude(array, a_exclude);
	if(isdefined(n_maxdist))
	{
		a_ret = arraysort(a_ret, org, 1, n_max, n_maxdist);
	}
	else
	{
		a_ret = arraysort(a_ret, org, 1, n_max);
	}
	return a_ret;
}

/*
	Name: alphabetize
	Namespace: array
	Checksum: 0x1874D73B
	Offset: 0x2A48
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function alphabetize(&array)
{
	return sort_by_value(array, 1);
}

/*
	Name: sort_by_value
	Namespace: array
	Checksum: 0x2FA18433
	Offset: 0x2A78
	Size: 0x4A
	Parameters: 2
	Flags: Linked
*/
function sort_by_value(&array, b_lowest_first = 0)
{
	return merge_sort(array, &_sort_by_value_compare_func, b_lowest_first);
}

/*
	Name: _sort_by_value_compare_func
	Namespace: array
	Checksum: 0x8FCAA61B
	Offset: 0x2AD0
	Size: 0x3E
	Parameters: 3
	Flags: Linked
*/
function _sort_by_value_compare_func(val1, val2, b_lowest_first)
{
	if(b_lowest_first)
	{
		return val1 < val2;
	}
	return val1 > val2;
}

/*
	Name: sort_by_script_int
	Namespace: array
	Checksum: 0x602F5FB4
	Offset: 0x2B18
	Size: 0x4A
	Parameters: 2
	Flags: Linked
*/
function sort_by_script_int(&a_ents, b_lowest_first = 0)
{
	return merge_sort(a_ents, &_sort_by_script_int_compare_func, b_lowest_first);
}

/*
	Name: _sort_by_script_int_compare_func
	Namespace: array
	Checksum: 0x7D1D00FF
	Offset: 0x2B70
	Size: 0x60
	Parameters: 3
	Flags: Linked
*/
function _sort_by_script_int_compare_func(e1, e2, b_lowest_first)
{
	if(b_lowest_first)
	{
		return e1.script_int < e2.script_int;
	}
	return e1.script_int > e2.script_int;
}

/*
	Name: merge_sort
	Namespace: array
	Checksum: 0xCE74A113
	Offset: 0x2BE0
	Size: 0x1E4
	Parameters: 3
	Flags: Linked
*/
function merge_sort(&current_list, func_sort, param)
{
	if(current_list.size <= 1)
	{
		return current_list;
	}
	left = [];
	right = [];
	middle = current_list.size / 2;
	for(x = 0; x < middle; x++)
	{
		if(!isdefined(left))
		{
			left = [];
		}
		else if(!isarray(left))
		{
			left = array(left);
		}
		left[left.size] = current_list[x];
	}
	while(x < current_list.size)
	{
		if(!isdefined(right))
		{
			right = [];
		}
		else if(!isarray(right))
		{
			right = array(right);
		}
		right[right.size] = current_list[x];
		x++;
	}
	left = merge_sort(left, func_sort, param);
	right = merge_sort(right, func_sort, param);
	result = merge(left, right, func_sort, param);
	return result;
}

/*
	Name: merge
	Namespace: array
	Checksum: 0x88388D37
	Offset: 0x2DD0
	Size: 0x192
	Parameters: 4
	Flags: Linked
*/
function merge(left, right, func_sort, param)
{
	result = [];
	li = 0;
	ri = 0;
	while(li < left.size && ri < right.size)
	{
		b_result = undefined;
		if(isdefined(param))
		{
			b_result = [[func_sort]](left[li], right[ri], param);
		}
		else
		{
			b_result = [[func_sort]](left[li], right[ri]);
		}
		if(b_result)
		{
			result[result.size] = left[li];
			li++;
		}
		else
		{
			result[result.size] = right[ri];
			ri++;
		}
	}
	while(li < left.size)
	{
		result[result.size] = left[li];
		li++;
	}
	while(ri < right.size)
	{
		result[result.size] = right[ri];
		ri++;
	}
	return result;
}

/*
	Name: insertion_sort
	Namespace: array
	Checksum: 0x623BC17E
	Offset: 0x2F70
	Size: 0xBA
	Parameters: 3
	Flags: None
*/
function insertion_sort(&a, comparefunc, val)
{
	if(!isdefined(a))
	{
		a = [];
		a[0] = val;
		return;
	}
	for(i = 0; i < a.size; i++)
	{
		if([[comparefunc]](a[i], val) <= 0)
		{
			arrayinsert(a, val, i);
			return;
		}
	}
	a[a.size] = val;
}

/*
	Name: spread_all
	Namespace: array
	Checksum: 0xDC8831E9
	Offset: 0x3038
	Size: 0x1BC
	Parameters: 7
	Flags: None
*/
function spread_all(&entities, func, arg1, arg2, arg3, arg4, arg5)
{
	/#
		assert(isdefined(entities), "");
	#/
	/#
		assert(isdefined(func), "");
	#/
	if(isarray(entities))
	{
		foreach(ent in entities)
		{
			if(isdefined(ent))
			{
				util::single_thread(ent, func, arg1, arg2, arg3, arg4, arg5);
			}
			wait(randomfloatrange(0.06666666, 0.1333333));
		}
	}
	else
	{
		util::single_thread(entities, func, arg1, arg2, arg3, arg4, arg5);
		wait(randomfloatrange(0.06666666, 0.1333333));
	}
}

/*
	Name: wait_till_touching
	Namespace: array
	Checksum: 0x85A7D872
	Offset: 0x3200
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function wait_till_touching(&a_ents, e_volume)
{
	while(!is_touching(a_ents, e_volume))
	{
		wait(0.05);
	}
}

/*
	Name: is_touching
	Namespace: array
	Checksum: 0xAD2808CD
	Offset: 0x3248
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function is_touching(&a_ents, e_volume)
{
	foreach(e_ent in a_ents)
	{
		if(!e_ent istouching(e_volume))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: contains
	Namespace: array
	Checksum: 0xFB7E7375
	Offset: 0x32F8
	Size: 0xBE
	Parameters: 2
	Flags: Linked
*/
function contains(array_or_val, value)
{
	if(isarray(array_or_val))
	{
		foreach(element in array_or_val)
		{
			if(element === value)
			{
				return 1;
			}
		}
		return 0;
	}
	return array_or_val === value;
}

/*
	Name: _filter_dead
	Namespace: array
	Checksum: 0x1E69047E
	Offset: 0x33C0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function _filter_dead(val)
{
	return isalive(val);
}

/*
	Name: _filter_classname
	Namespace: array
	Checksum: 0xDF98B053
	Offset: 0x33F0
	Size: 0x32
	Parameters: 2
	Flags: Linked
*/
function _filter_classname(val, arg)
{
	return issubstr(val.classname, arg);
}

/*
	Name: quicksort
	Namespace: array
	Checksum: 0x807F5242
	Offset: 0x3430
	Size: 0x3A
	Parameters: 2
	Flags: None
*/
function quicksort(array, compare_func)
{
	return quicksortmid(array, 0, array.size - 1, compare_func);
}

/*
	Name: quicksortmid
	Namespace: array
	Checksum: 0x866A62F6
	Offset: 0x3478
	Size: 0x1DE
	Parameters: 4
	Flags: Linked
*/
function quicksortmid(array, start, end, compare_func)
{
	i = start;
	k = end;
	if(!isdefined(compare_func))
	{
		compare_func = &quicksort_compare;
	}
	if((end - start) >= 1)
	{
		pivot = array[start];
		while(k > i)
		{
			while([[compare_func]](array[i], pivot) && i <= end && k > i)
			{
				i++;
			}
			while(![[compare_func]](array[k], pivot) && k >= start && k >= i)
			{
				k--;
			}
			if(k > i)
			{
				swap(array, i, k);
			}
		}
		swap(array, start, k);
		array = quicksortmid(array, start, k - 1, compare_func);
		array = quicksortmid(array, k + 1, end, compare_func);
	}
	else
	{
		return array;
	}
	return array;
}

/*
	Name: quicksort_compare
	Namespace: array
	Checksum: 0xB0A4B4AB
	Offset: 0x3660
	Size: 0x1E
	Parameters: 2
	Flags: Linked
*/
function quicksort_compare(left, right)
{
	return left <= right;
}

