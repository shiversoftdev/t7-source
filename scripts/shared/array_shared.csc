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
	Checksum: 0x4EA9F1F3
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
	Name: remove_undefined
	Namespace: array
	Checksum: 0xEDC67DD3
	Offset: 0x2C8
	Size: 0x60
	Parameters: 2
	Flags: None
*/
function remove_undefined(array, b_keep_keys)
{
	if(isdefined(b_keep_keys))
	{
		arrayremovevalue(array, undefined, b_keep_keys);
	}
	else
	{
		arrayremovevalue(array, undefined);
	}
	return array;
}

/*
	Name: get_touching
	Namespace: array
	Checksum: 0xA1B25701
	Offset: 0x330
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
	Checksum: 0x33526F10
	Offset: 0x378
	Size: 0xEC
	Parameters: 3
	Flags: None
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
	Checksum: 0xDA7D54CD
	Offset: 0x470
	Size: 0xFA
	Parameters: 2
	Flags: None
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
	Checksum: 0x3DAE409A
	Offset: 0x578
	Size: 0x8E
	Parameters: 2
	Flags: None
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
	Checksum: 0xE0409060
	Offset: 0x610
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
	Checksum: 0x25D9A24F
	Offset: 0xAE8
	Size: 0x16C
	Parameters: 7
	Flags: None
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
	Checksum: 0x36DEB30
	Offset: 0xC60
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
	Checksum: 0xCFEB73C6
	Offset: 0x1138
	Size: 0xA8
	Parameters: 2
	Flags: None
*/
function exclude(array, array_exclude)
{
	newarray = array;
	if(isarray(array_exclude))
	{
		for(i = 0; i < array_exclude.size; i++)
		{
			arrayremovevalue(newarray, array_exclude[i]);
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
	Checksum: 0xA6B8ECB7
	Offset: 0x11E8
	Size: 0x76
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
	return array;
}

/*
	Name: add_sorted
	Namespace: array
	Checksum: 0xE0C45F1E
	Offset: 0x1268
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
	Checksum: 0x8F8FD719
	Offset: 0x1348
	Size: 0x16E
	Parameters: 3
	Flags: Linked
*/
function wait_till(&array, msg, n_timeout)
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
			ent thread util::timeout(n_timeout, &util::_waitlogic, s_tracker, msg);
		}
	}
	if(s_tracker._wait_count > 0)
	{
		s_tracker waittill(#"waitlogic_finished");
	}
}

/*
	Name: flag_wait
	Namespace: array
	Checksum: 0x11947C1A
	Offset: 0x14C0
	Size: 0x86
	Parameters: 2
	Flags: None
*/
function flag_wait(&array, str_flag)
{
	for(i = 0; i < array.size; i++)
	{
		ent = array[i];
		if(!ent flag::get(str_flag))
		{
			ent waittill(str_flag);
			i = -1;
		}
	}
}

/*
	Name: flagsys_wait
	Namespace: array
	Checksum: 0x110C2047
	Offset: 0x1550
	Size: 0x86
	Parameters: 2
	Flags: Linked
*/
function flagsys_wait(&array, str_flag)
{
	for(i = 0; i < array.size; i++)
	{
		ent = array[i];
		if(!ent flagsys::get(str_flag))
		{
			ent waittill(str_flag);
			i = -1;
		}
	}
}

/*
	Name: flagsys_wait_any_flag
	Namespace: array
	Checksum: 0x1733A161
	Offset: 0x15E0
	Size: 0x138
	Parameters: 2
	Flags: Linked, Variadic
*/
function flagsys_wait_any_flag(&array, ...)
{
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
				i = -1;
			}
		}
	}
}

/*
	Name: flag_wait_clear
	Namespace: array
	Checksum: 0x172AB17A
	Offset: 0x1720
	Size: 0x86
	Parameters: 2
	Flags: None
*/
function flag_wait_clear(&array, str_flag)
{
	for(i = 0; i < array.size; i++)
	{
		ent = array[i];
		if(ent flag::get(str_flag))
		{
			ent waittill(str_flag);
			i = -1;
		}
	}
}

/*
	Name: flagsys_wait_clear
	Namespace: array
	Checksum: 0x23E66C2E
	Offset: 0x17B0
	Size: 0x86
	Parameters: 2
	Flags: None
*/
function flagsys_wait_clear(&array, str_flag)
{
	for(i = 0; i < array.size; i++)
	{
		ent = array[i];
		if(ent flagsys::get(str_flag))
		{
			ent waittill(str_flag);
			i = -1;
		}
	}
}

/*
	Name: wait_any
	Namespace: array
	Checksum: 0x24910351
	Offset: 0x1840
	Size: 0x1F4
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
	a_structs = [];
	foreach(ent in array)
	{
		if(isdefined(ent))
		{
			s = spawnstruct();
			s thread util::timeout(n_timeout, &_waitlogic2, s_tracker, ent, msg);
			if(!isdefined(a_structs))
			{
				a_structs = [];
			}
			else if(!isarray(a_structs))
			{
				a_structs = array(a_structs);
			}
			a_structs[a_structs.size] = s;
		}
	}
	s_tracker endon(#"array_wait");
	wait_till(array, "death");
}

/*
	Name: _waitlogic2
	Namespace: array
	Checksum: 0xE122F8E2
	Offset: 0x1A40
	Size: 0x50
	Parameters: 3
	Flags: Linked
*/
function _waitlogic2(s_tracker, ent, msg)
{
	s_tracker endon(#"array_wait");
	ent endon(#"death");
	ent waittill(msg);
	s_tracker notify(#"array_wait");
}

/*
	Name: flag_wait_any
	Namespace: array
	Checksum: 0xB9F72E12
	Offset: 0x1A98
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
	Checksum: 0x37DE7978
	Offset: 0x1B70
	Size: 0x56
	Parameters: 1
	Flags: Linked
*/
function random(array)
{
	keys = getarraykeys(array);
	return array[keys[randomint(keys.size)]];
}

/*
	Name: randomize
	Namespace: array
	Checksum: 0x33E209A5
	Offset: 0x1BD0
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
	Name: reverse
	Namespace: array
	Checksum: 0xBB8CA7AB
	Offset: 0x1C78
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
	Checksum: 0x1EEDCD47
	Offset: 0x1CE8
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
	Checksum: 0xC64DA545
	Offset: 0x1DA0
	Size: 0xAA
	Parameters: 3
	Flags: None
*/
function swap(&array, index1, index2)
{
	/#
		assert(index1 < array.size, "");
	#/
	/#
		assert(index2 < array.size, "");
	#/
	temp = array[index1];
	array[index1] = array[index2];
	array[index2] = temp;
}

/*
	Name: pop
	Namespace: array
	Checksum: 0xB58035DF
	Offset: 0x1E58
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
	Checksum: 0xC2569658
	Offset: 0x1F28
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
	Checksum: 0xEF751FE6
	Offset: 0x1FB8
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
	Checksum: 0xF0326F59
	Offset: 0x20C8
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function push_front(&array, val)
{
	push(array, val, 0);
}

/*
	Name: get_closest
	Namespace: array
	Checksum: 0x5BCF3371
	Offset: 0x2108
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function get_closest(org, &array, dist = undefined)
{
	/#
		assert(0, "");
	#/
}

/*
	Name: get_farthest
	Namespace: array
	Checksum: 0xD538273A
	Offset: 0x2160
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
	Checksum: 0x7D943098
	Offset: 0x21B8
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
	Checksum: 0xD36A7F6B
	Offset: 0x21E0
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
	Checksum: 0x12BFBA14
	Offset: 0x2208
	Size: 0xDC
	Parameters: 4
	Flags: None
*/
function get_all_farthest(org, &array, excluders, max)
{
	sorted_array = get_closest(org, array, excluders);
	if(isdefined(max))
	{
		temp_array = [];
		for(i = 0; i < sorted_array.size; i++)
		{
			temp_array[temp_array.size] = sorted_array[sorted_array.size - i];
		}
		sorted_array = temp_array;
	}
	sorted_array = reverse(sorted_array);
	return sorted_array;
}

/*
	Name: get_all_closest
	Namespace: array
	Checksum: 0xDEBFF42F
	Offset: 0x22F0
	Size: 0x330
	Parameters: 5
	Flags: None
*/
function get_all_closest(org, &array, excluders = [], max = array.size, maxdist)
{
	maxdists2rd = undefined;
	if(isdefined(maxdist))
	{
		maxdists2rd = maxdist * maxdist;
	}
	dist = [];
	index = [];
	for(i = 0; i < array.size; i++)
	{
		if(!isdefined(array[i]))
		{
			continue;
		}
		excluded = 0;
		for(p = 0; p < excluders.size; p++)
		{
			if(array[i] != excluders[p])
			{
				continue;
			}
			excluded = 1;
			break;
		}
		if(excluded)
		{
			continue;
		}
		length = distancesquared(org, array[i].origin);
		if(isdefined(maxdists2rd) && maxdists2rd < length)
		{
			continue;
		}
		dist[dist.size] = length;
		index[index.size] = i;
	}
	for(;;)
	{
		change = 0;
		for(i = 0; i < (dist.size - 1); i++)
		{
			if(dist[i] <= (dist[i + 1]))
			{
				continue;
			}
			change = 1;
			temp = dist[i];
			dist[i] = dist[i + 1];
			dist[i + 1] = temp;
			temp = index[i];
			index[i] = index[i + 1];
			index[i + 1] = temp;
		}
		if(!change)
		{
			break;
		}
	}
	newarray = [];
	if(max > dist.size)
	{
		max = dist.size;
	}
	for(i = 0; i < max; i++)
	{
		newarray[i] = array[index[i]];
	}
	return newarray;
}

/*
	Name: alphabetize
	Namespace: array
	Checksum: 0xC5D2AD4
	Offset: 0x2628
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
	Checksum: 0xAB0399A9
	Offset: 0x2658
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
	Checksum: 0xF5CAEB0F
	Offset: 0x26B0
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
	Checksum: 0x1D35FDE7
	Offset: 0x26F8
	Size: 0x4A
	Parameters: 2
	Flags: None
*/
function sort_by_script_int(&a_ents, b_lowest_first = 0)
{
	return merge_sort(a_ents, &_sort_by_script_int_compare_func, b_lowest_first);
}

/*
	Name: _sort_by_script_int_compare_func
	Namespace: array
	Checksum: 0xC7217C81
	Offset: 0x2750
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
	Checksum: 0xE0FC88B5
	Offset: 0x27C0
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
	Checksum: 0xC9EF56E8
	Offset: 0x29B0
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
	Name: spread_all
	Namespace: array
	Checksum: 0x69A07E96
	Offset: 0x2B50
	Size: 0x1B4
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
			util::single_thread(ent, func, arg1, arg2, arg3, arg4, arg5);
			wait(randomfloatrange(0.06666666, 0.1333333));
		}
	}
	else
	{
		util::single_thread(entities, func, arg1, arg2, arg3, arg4, arg5);
		wait(randomfloatrange(0.06666666, 0.1333333));
	}
}

